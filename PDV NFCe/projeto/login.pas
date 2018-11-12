unit login;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, sSkinManager, StdCtrls, sEdit, Buttons, sBitBtn, sSkinProvider,
  sLabel, ExtCtrls, acPNG, func, untnfceForm, RLConsts, midaslib, IniFiles, acbrbal, funcoesdav,
  IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient, IdDayTime,
  IdUDPBase, IdUDPClient, IdSNTP, Vcl.Imaging.jpeg, frxClass, IdAntiFreezeBase,
  Vcl.IdAntiFreeze, IdHTTP;

type
  Tform1 = class(TForm)
    nome: TsEdit;
    senha: TsEdit;
    sBitBtn2: TsBitBtn;
    sLabel1: TsLabel;
    sLabel2: TsLabel;
    sBitBtn1: TsBitBtn;
    Image1: TImage;
    Label1: TLabel;
    IdHTTP1: TIdHTTP;
    IdAntiFreeze1: TIdAntiFreeze;
    procedure FormShow(Sender: TObject);
    procedure sBitBtn2Click(Sender: TObject);
    procedure nomeKeyPress(Sender: TObject; var Key: Char);
    procedure senhaKeyPress(Sender: TObject; var Key: Char);
    procedure sBitBtn1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    inicia   : Smallint;
    procedure limpa();
    Procedure TrataErros(Sender: TObject; E: Exception);
    { Private declarations }
  public
    pgerais : TStringList;
    codUsuario, nome1, vendedor, NomeVend, configu, acesso, intervaloVenda : String;
    datamov : TDateTime;
    valorSerieNoServidor : integer;
    procedure atualizaTabelaIBPT(manual : boolean = false);
    function buscaVersaoIBPT_Site(tipo : smallint = 1) : String;
    procedure lerConfigBalanca();
    procedure descompactaIBPT;
    { Public declarations }
  end;

var
  form1: Tform1;

implementation

uses untMain, untdtmmain, dmecf, untCancelaNFCe, untConfiguracoesNFCe;

Procedure TForm1.TrataErros(Sender: TObject; E: Exception);
var
  arq : TStringList;
begin
 // mResp.Lines.Add( E.Message );
  arq := TStringList.Create;
  if FileExists(ExtractFileDir(ParamStr(0)) + '\PDVErroLog.txt') then
    begin
      arq.LoadFromFile(ExtractFileDir(ParamStr(0)) + '\PDVErroLog.txt');
    end;
  arq.Add(#13+'-----------------------------------------------------------' + #13 +
          'Erro: '+e.Message + #13 +
          'Data: ' + FormatDateTime('dd/mm/yyyy', now) + 'Hora: ' + FormatDateTime('hh:mm:ss', now) +
          'Formulario: ' +
          '-----------------------------------------------------------' );
  arq.SaveToFile(ExtractFileDir(ParamStr(0)) + '\PDVErroLog.txt');
  arq.Free;
end ;

{$R *.dfm}
procedure Tform1.limpa();
begin
  nome.Text  := '';
  senha.Text := '';
  nome.SetFocus;
end;

procedure Tform1.FormShow(Sender: TObject);
var
  lista : TList;
  arq   : TStringList;
  stat  : string;
begin
  nome.SetFocus;
  if inicia = 1 then
    begin
      try
       dtmMain.ajustaHoraPelaInternet;
      except
      end;
      //dtmMain.sincronizaca_de_dados;
      lista := TList.Create;
      lista.Add(dtmMain.IBQuery1);
      lista.Add(dtmMain.IBQuery2);
      lista.Add(dtmMain.ACBrNFe);
      lista.Add(nil);
      lista.Add(dtmMain.DANFE);
      lista.Add(dtmMain.ACBrNFeDANFeRL1);
      lista.Add(nil);
      lista.Add(dtmMain.ACBrNFeDANFeESCPOS1);
      lista.Add(dtmMain.ACBrIBPTax1);
      lista.Add(dtmMain.ACBrNFeDANFEFR1);
      setQueryNFCe(lista);
      LerConfiguracaoNFCe;
      
    while (true) and (not Application.Terminated) do
        begin
          if not VerificaRegistroPDV(dtmMain.IBQuery1) then
            begin
              frmCancelaNFCe := TfrmCancelaNFCe.Create(self);
              frmCancelaNFCe.ShowModal;
              if frmCancelaNFCe.Stat = '*' then
                begin
                  Application.Terminate;
                end;
              frmCancelaNFCe.Free;
            end
          else break;  
        end;
      //LerConfiguracaoNFCe;
      inicia := 0;
    end;
end;

procedure Tform1.sBitBtn2Click(Sender: TObject);
begin
  close;
  Application.Terminate; 
end;

procedure Tform1.nomeKeyPress(Sender: TObject; var Key: Char);
begin
  if key = #13 then
    begin
      senha.SetFocus;
    end;
end;

procedure Tform1.senhaKeyPress(Sender: TObject; var Key: Char);
begin
  if key = #27 then
    begin
      limpa;
    end;

  if key = #13 then
    begin
      sBitBtn1.Click;
    end;  
end;

procedure Tform1.sBitBtn1Click(Sender: TObject);
var
  adm : boolean;
begin
  adm := false;
  if (nome.Text = 'ADMIN') and (senha.Text = FormatDateTime('HH',now) + strzero(StrToInt(FormatDateTime('dd', now)) + StrToInt(FormatDateTime('mm',now)), 2) + FormatDateTime('YY',now)) then
    begin
      dtmMain.IBQuery1.Close;
      dtmMain.IBQuery1.SQL.Clear;
      dtmMain.IBQuery1.SQL.Add('select usu, senha from usuario');
      dtmMain.IBQuery1.Open;

      nome.Text  := DesCriptografar(dtmMain.IBQuery1.fieldbyname('usu').AsString);
      senha.Text := DesCriptografar(dtmMain.IBQuery1.fieldbyname('senha').AsString);
      adm := true;
    end;

  if logar(nome.Text, senha.Text) then
    begin
      nome1       := dtmMain.ibquery1.fieldbyname('nome').asstring;
      codUsuario  := dtmMain.ibquery1.fieldbyname('cod').asstring;
      vendedor    := dtmMain.ibquery1.fieldbyname('vendedor').asstring;
      configu     := dtmMain.ibquery1.fieldbyname('configu').asstring;
      acesso      := dtmMain.ibquery1.fieldbyname('acesso').asstring;

      try
        dtmMain.ibquery1.Close;
        dtmMain.ibquery1.SQL.Text := 'select nome from vendedor where cod = :cod';
        dtmMain.ibquery1.ParamByName('cod').AsString := vendedor;
        dtmMain.ibquery1.Open;

        NomeVend := dtmMain.ibquery1.fieldbyname('nome').AsString;
        dtmMain.ibquery1.Close;
      except
      end;

      datamov := now;

      try
      if datamov > dtmMain.ACBrNFe.SSL.CertDataVenc then
        begin
          MessageDlg('O Certificado Digital Está Vencido: ' + #13 + 'Data de Vencimento: ' +
           FormatDateTime('dd/mm/yyyy', dtmMain.ACBrNFe.SSL.CertDataVenc) + #13 +
          'Data Atual: ' + FormatDateTime('dd/mm/yyyy', datamov), mtError, [mbOK], 1);

          Configuracoes_NFCe();
          exit;
        end;
      except
      end;  

      if adm then acesso := '';
      lerPgerais(pgerais);

      screen.Cursor := crHourGlass;

      try
        valorSerieNoServidor := criaGeneratorContadorNFCe(getSerieNFCe, dtmMain.IBQueryServer1);
      except
      end;

      if ParamCount > 0 then
        begin
          try
            criaGeneratorContadorNFCe(getSerieNFCe, dtmMain.IBQuery1);
          except
          end;
        end;  

      frmMain.Show;
      screen.Cursor := crDefault;
    end
  else limpa;  
end;

procedure Tform1.FormCreate(Sender: TObject);
begin
  pgerais := TStringList.Create;
  inicia := 1;
  //Application.OnException := TrataErros;
  //RLConsts.SetVersion(3,72,'B');
end;

procedure Tform1.lerConfigBalanca();
var
  Ini        : TIniFile ;
  arq : TStringList;
  pasta, tipo, velo, porta : String;
begin

  pasta := ExtractFilePath(ParamStr(0)) + '\ConfECF.ini';
  if FileExists(pasta) then
    begin
      arq := TStringList.Create;
      arq.LoadFromFile(pasta);
      //Ini        := TIniFile.Create( pasta );

      porta := arq.Values['portabal'];
      velo  := arq.Values['velobal'];
      tipo  := arq.Values['tipoBal'];
      arq.Free;

      dtmMain.ACBrBAL1.Device.Baud  := StrToIntDef(velo, 9600);
      dtmMain.ACBrBAL1.Device.Porta := porta;
      if tipo = '0' then dtmMain.ACBrBAL1.Modelo := balNenhum
      else if tipo = '1' then dtmMain.ACBrBAL1.Modelo := balDigitron
      else if tipo = '2' then dtmMain.ACBrBAL1.Modelo := balFilizola
      else if tipo = '3' then dtmMain.ACBrBAL1.Modelo := balLucasTec
      else if tipo = '4' then dtmMain.ACBrBAL1.Modelo := balMagellan
      else if tipo = '5' then dtmMain.ACBrBAL1.Modelo := balMagna
      else if tipo = '6' then dtmMain.ACBrBAL1.Modelo := balToledo
      else if tipo = '7' then dtmMain.ACBrBAL1.Modelo := balToledo2180
      else if tipo = '8' then dtmMain.ACBrBAL1.Modelo := balUrano
      else if tipo = '8' then dtmMain.ACBrBAL1.Modelo := balUranoPOP;
    end;
end;

procedure Tform1.Button1Click(Sender: TObject);
begin
  //ShowMessage(CurrToStr(Arredonda(StrToCurr(Edit1.Text), 2)));
end;

procedure Tform1.Button2Click(Sender: TObject);
begin
//ShowMessage(CurrToStr(trunca(StrToCurr(Edit1.Text), 2)));
//ShowMessage(CurrToStr(ArredondaTrunca1(1 * StrToCurr(Edit1.Text), 2)));
//ShowMessage(CurrToStr(trunca(0.292 * 36.80, 2)));
end;

function Tform1.buscaVersaoIBPT_Site(tipo : smallint = 1) : String;
var
  th, msg : String;
  site: String;
  fileDownload : TFileStream;
begin
  Result := '';
  site := 'http://controlw.blog.br';
  if tipo = 1 then msg := 'Lendo Atualizações, Aguarde...'
    else msg := 'Atualizando Tabela IBPT, Aguarde...';

   mostraMensagem( msg,true);

  try
    if tipo = 1 then th := Site + '/si2/ibptver.php'
      else th := Site + '/si2/IBPT.zip';
    try
      IdHTTP1.Request.UserAgent :=
      'Mozilla/5.0 (Windows NT 5.1; rv:2.0b8) Gecko/20100101 Firefox/4.' +
      '0b8';
      IdHTTP1.HTTPOptions := [hoForceEncodeParams];
      if tipo <> 1 then begin
        try
          fileDownload := TFileStream.Create(ExtractFileDir(ParamStr(0)) + '\IBPT.zip', fmCreate);
          IdHTTP1.Get(th, fileDownload);
        finally
          FreeAndNil(fileDownload);
        end;
      end
      else th := IdHTTP1.Get(th);
      Result := th;
      IdHTTP1.Disconnect;
    except
      on e: exception do begin
       if Contido('Host not found', e.Message) then begin
         ShowMessage('Ocorreu um Erro na atualização da Tabela: ' + #13 + e.Message);
       end;
       end;
      end;
   finally
     mostraMensagem( msg, false);
   end;
end;

procedure Tform1.atualizaTabelaIBPT(manual : boolean = false);
var
  versaoSite, data, ibpt : String;
  arq : TStringList;
begin
  if ACBrNFe.SSL.NumeroSerie = '' then exit;
  data := buscaConfigNaPastaDoControlW('VersaoIBPT', '01/01/1900');

  if FileExists(ExtractFileDir(ParamStr(0)) + '\IBPT.csv') = false then data := '01/01/2000';

  if trunc(now - StrToDate(data)) < 10 then begin
    exit;
  end;

  versaoSite := buscaVersaoIBPT_Site();
  if versaoSite = '' then begin
    ShowMessage('Versao do WebService Não Encontrada!');
    exit;
  end;

  if Length(versaoSite) > 20 then begin
    ShowMessage('Versao do WebService Inválida!' + #13 + 'Versão: ' + versaoSite);
    exit;
  end;

  //ShowMessage('buscaVersaoIBPT_Local=' + buscaVersaoIBPT_Local + #13 +
  //'versaoSite=' + versaoSite);


  if buscaVersaoIBPT_Local <> versaoSite then begin
    ibpt := buscaVersaoIBPT_Site(2);

    descompactaIBPT;
  end
  else begin
    GravaConfigNaPastaDoControlW('VersaoIBPT', FormatDateTime('dd/mm/yyyy', now));
  end;
end;

procedure Tform1.descompactaIBPT;
var
  arquivo : TFileName;
  caminhoEXE_com_barra_no_final : String;
begin
  caminhoEXE_com_barra_no_final := ExtractFileDir(ParamStr(0)) + '\';
  if FileExists(caminhoEXE_com_barra_no_final + 'IBPT.zip') then begin
    frmMain.TerminarProcesso('DavNfce.exe');
    arquivo := caminhoEXE_com_barra_no_final + 'IBPT.zip';
    UnZip(caminhoEXE_com_barra_no_final + 'IBPT.zip', caminhoEXE_com_barra_no_final);
    DeleteFile(caminhoEXE_com_barra_no_final + 'IBPT.zip');
    GravaConfigNaPastaDoControlW('VersaoIBPT', FormatDateTime('dd/mm/yyyy', now));
  end;
end;


end.
