unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, ExtCtrls, ShellApi, AppEvnts, Contnrs,
  IBDatabase, DB, IBCustomDataSet, IBQuery, untnfceForm, ACBrNFe, funcoesdav,
  ACBrBase, ACBrSocket, ACBrIBPTax, ACBrDFe, IniFiles, Gauges, func,
  IdBaseComponent, IdComponent, IdUDPBase, IdUDPClient, IdSNTP,
  ACBrNFeDANFEClass, ACBrNFeDANFeRLClass, IdAntiFreezeBase, IdAntiFreeze,
  ACBrNFeDANFeESCPOS, ACBrDANFCeFortesFr, Vcl.Menus, RxShell, sEdit, acPNG, vcl.imaging.jpeg,
  TLHelp32, pcnConversaoNFe;

const
  WM_ICONTRAY = WM_USER + 1;

type
  TForm1 = class(TForm)
    RichEdit1: TRichEdit;
    Label1: TLabel;
    Timer1: TTimer;
    Timer2: TTimer;
    BDControl: TIBDatabase;
    IBTransaction2: TIBTransaction;
    QueryControlProd: TIBQuery;
    QueryControlVenda: TIBQuery;
    QueryControlDivs: TIBQuery;
    IBTransaction1: TIBTransaction;
    Button1: TButton;
    ACBrIBPTax1: TACBrIBPTax;
    BD_Servidor: TIBDatabase;
    IBQueryServer1: TIBQuery;
    IBTransaction3: TIBTransaction;
    IBQueryServer2: TIBQuery;
    IBQuery1: TIBQuery;
    IBQuery2: TIBQuery;
    Gauge1: TGauge;
    IdSNTP1: TIdSNTP;
    ACBrNFeDANFeRL1: TACBrNFeDANFeRL;
    ACBrNFe1: TACBrNFe;
    Panel1: TPanel;
    Label2: TLabel;
    ACBrNFeDANFCeFortes1: TACBrNFeDANFCeFortes;
    ACBrNFeDANFeESCPOS1: TACBrNFeDANFeESCPOS;
    TrayIcon1: TTrayIcon;
    PopupMenu1: TPopupMenu;
    Abrir1: TMenuItem;
    Fechar1: TMenuItem;
    IBQuery3: TIBQuery;
    IBTransaction4: TIBTransaction;
    Timer3: TTimer;
    IdAntiFreeze1: TIdAntiFreeze;
    FinalizaTimer: TTimer;
    Label3: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure Timer2Timer(Sender: TObject);
    procedure FormClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure TrayIcon1Click(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure Abrir1Click(Sender: TObject);
    procedure Fechar1Click(Sender: TObject);
    procedure Timer3Timer(Sender: TObject);
    procedure ACBrNFe1GerarLog(const ALogLine: string; var Tratado: Boolean);
    procedure FinalizaTimerTimer(Sender: TObject);
  private
    inicio, inicioPgerais: Smallint;
    totEnvia, contAtualizacao: integer;
    bancoControl, erro12: String;
    bdPronto, emitNFe, emitNFCe, CAMPO_EXPORTADO_FOI_CRIADO: boolean;
    pastaControlW_Servidor: String;
    pastanfe: String;
    usaMinimize, baixarEstoque: boolean;
    function ProcessExists(exeFileName: string): Boolean;
    procedure VerificaXMLS_XX();
    function verificaCstatXML(chaveXML : String) : boolean;
    function buscaConfigNaPastaDoControlW1(Const config_name: String;
      gravaVazio: boolean = false): String;
    function verSeExisteTabela(nome: String; var query: TIBQuery): boolean;
    function procuraProdutoNaLista(cod: integer;
      var lista1: TStringList): integer;
    procedure testaNFe();
    function VerificaCampoTabela(NomeCampo, tabela: string;
      var query: TIBQuery): boolean;
    function listaArquivos(const pasta: String): TStringList;
    procedure sinal(const num: integer);
    function conectaBD_Local(): boolean;
    function verSeOcorreuMudancaEstoque(): boolean;
    procedure ajustaHoraPelaInternet();
    procedure LerDadosArquivo();
    procedure TrayMessage(var Msg: TMessage); message WM_ICONTRAY;
    procedure enviaCuponsPendentes();
    function conectaBD_Servidor(): boolean;
    function sincronizaParamGerais(): boolean;
    function sincronizaEstoque(): boolean;
    function sincronizaUsuarios(): boolean;
    function sincronizaCEST(): boolean;
    function sincronizaNFCe(): boolean;
    function sincronizaPromoc(): boolean;
    procedure le_estoque(var listaprod: TStringList);
    procedure copiaProduto(cod: integer);
    procedure copiaProdutoDataSet(var queryServer: TIBQuery);
    function copiaVendas(nota: integer; var notaNova: integer; chave: String;
      Cancelado: integer = 0) : boolean;
    function copiaNFCes(chave: String; nota, notaNova: integer;
      somenteCopiaXML: boolean = false): boolean;
    procedure copiaNFes();
    function Incrementa_Generator(Gen_name: string; valor_incremento: integer;
      var query: TIBQuery): string;
    function verificaNFCeNovo(dataIni: String = ''; DataFim: String = '';
      sped: boolean = False): boolean;
    procedure progresso(ini, fim: integer);
    function adicionaNFCeNaoEncontrada(num, ser : String) :boolean;
    { Private declarations }
  public
    caminhoComBarraNoFinal: String;
    pgerais1: TStringList;
    arquivo : TStringList;
    erroConectaServidor : integer;
    { Public declarations }
  end;

var
  Form1: TForm1;
  Nid: TNotifyIconData;
procedure TrimAppMemorySize;

const
  { sqlSinc : String = 'select p.cod, hash(nome || codbar || cast(p_venda as varchar(20))'+
    ' ||unid||classif||aliquota||is_pis||p.cod_ispis) as hash from produto p order by p.cod';
    sqlSincServer : String = 'select p.cod,nome, codbar, quant, p_venda, unid, classif, aliquota, is_pis, cod_ispis, hash(nome || codbar || cast(p_venda as varchar(20))'+
    ' ||unid||classif||aliquota||is_pis||p.cod_ispis) as hash from produto p order by p.cod'; }

  sqlSinc: String =
    'select p.cod, hash(nome || codbar || cast(p_venda as varchar(20))' +
    ' ||unid||classif||aliquota||is_pis||p.cod_ispis  || quant) as hash from produto p order by p.cod';

  sqlSincServer
    : String =
    'select p.cod,nome, codbar, quant, p_venda, unid, classif, aliquota, is_pis, cod_ispis, hash(nome || codbar || cast(p_venda as varchar(20))'
    + ' ||unid||classif||aliquota||is_pis||p.cod_ispis  || quant) as hash from produto p order by p.cod';

implementation

uses DateUtils, Math, StrUtils;

{$R *.dfm}

procedure TForm1.enviaCuponsPendentes();
var
  esta: string;
  envi: boolean;
  ok: integer;
  img : tjpegimage;
  arq1 : TStringList;
begin
  erro12 := '0';
  if not conectaBD_Local then
  begin
    RichEdit1.Lines.Add('Não Conectado!139');
    exit;
  end;

  erro12 := '1';
  QueryControlProd.Close;
  QueryControlProd.SQL.Text :=
    'select nota, chave, data from nfce where ((adic = ''OFF'') and (substring(chave from 23 for 3) = :serie)) and tentativa < 20 ';
  QueryControlProd.ParamByName('serie').AsString := strzero(getSerieNFCe, 3);
  try
    QueryControlProd.Open;
    QueryControlProd.FetchAll;
  except
    on e: exception do
    begin
      RichEdit1.Lines.Add('Erro Linha 148: ' + e.Message);
      exit;
    end;
  end;

  erro12 := '2';

  if QueryControlProd.IsEmpty then  begin
   { RichEdit1.Lines.Add('Erro Linha 165: Registros' + IntToStr(QueryControlProd.RecordCount));
    RichEdit1.Lines.Add('Serie: ' + strzero(getSerieNFCe, 3));
    RichEdit1.Lines.Add('BD: '+QueryControlProd.Database.DatabaseName);}
    exit;
  end;

  erro12 := '3';

  ok := 0;
  while not QueryControlProd.Eof do
  begin
    sleep(1);
    ok := ok + 1;
    self.Caption := 'Enviando Cupons => ' + IntToStr(ok) + '/' +
      IntToStr(QueryControlProd.RecordCount);
    Application.ProcessMessages;
    Application.ProcessMessages;
    Label1.Caption := 'Enviando Cupom:' + #13 + 'Nota: ' +
      QueryControlProd.fieldbyname('nota').AsString + #13 + 'Chave: ' +
      QueryControlProd.fieldbyname('chave').AsString + #13 + 'Total Emitidas: '
      + IntToStr(totEnvia);
    Application.ProcessMessages;
    RichEdit1.Lines.Add('--------------------------------------------------');
    RichEdit1.Lines.Add('Nota: ' + QueryControlProd.fieldbyname('nota')
      .AsString);
    RichEdit1.Lines.Add('Chave: ' + QueryControlProd.fieldbyname('chave')
      .AsString);
    envi := false;

    try
      envi := EnviarCupomEletronico2(QueryControlProd.fieldbyname('nota')
        .AsString, QueryControlProd.fieldbyname('chave').AsString, RichEdit1, esta, false,
        true, false);

      erro12 := '4';

      if erro12002 >= 20 then begin
        arq1 := TStringList.Create;
        arq1.SaveToFile(ExtractFileDir(ParamStr(0)) + '\davXXX.rca');
        arq1.Free;
        ERRO_dados := 'Application.Terminate;';
        Application.Terminate;
      end;

      if ERRO_dados = 'Application.Terminate;' then begin
        ShellExecute(handle,'open',PChar(ParamStr(0)), '','',SW_SHOWNORMAL);
        exit;
      end;
        
    except
      on e: exception do
      begin
        erro12 := '6';
        RichEdit1.Lines.Add('Erro 175: ' + e.Message);
      end;
    end;

    if envi then
    begin
      erro12 := '7';
      erro12002 := 0;
      RichEdit1.Lines.Add('Estado: Enviado');
      totEnvia := totEnvia + 1;
    end
    else
    begin
      erro12 := '8';
      try
        RichEdit1.Lines.Add('Estado: ERRO => ' + esta);
      except
        on e: exception do begin
          RichEdit1.Lines.Add('Erro 233: ' + e.Message);
        end;
      end;

      if not Contido('Falha no Envio da Requisição', esta) then begin
        IBQuery2.Close;
        IBQuery2.SQL.Text := 'update nfce set tentativa = tentativa + 1 where chave = :chave';
        IBQuery2.ParamByName('chave').AsString := QueryControlProd.fieldbyname('chave').AsString;
        IBQuery2.ExecSQL;
        IBQuery2.Transaction.Commit;
      end;
    end;

    erro12 := '9';
    RichEdit1.Lines.Add('--------------------------------------------------');
    QueryControlProd.Next;
  end;
  // end;
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  lista1: TList;
  lis, arq: TStringList;
begin
  if ProcessExists(ExtractFileName(ParamStr(0))) then begin
    FinalizaTimer.Enabled := true;
    exit;
  end;

  baixarEstoque := true;
  erroConectaServidor := 0;

  arquivo := TStringList.Create;
  erro12002 := 0;
  try
    RichEdit1.Clear;
    sinal(1);
    LerDadosArquivo;
    inicio := 0;
    inicioPgerais := 0;
    contAtualizacao := 2000;
    usaMinimize := false;

    if buscaConfigNaPastaDoControlW1('X') = '1' then
    begin
      usaMinimize := true;
    end;

    { with Nid do
      begin
      cbSize := SizeOf(Nid);
      Wnd := Handle;
      uID := 0;
      uFlags := NIF_MESSAGE + NIF_ICON + NIF_TIP;
      uCallbackMessage := WM_ICONTRAY;
      hIcon := Application.Icon.Handle;
      StrPCopy(szTip, Application.Title);
      end; }

    caminhoComBarraNoFinal := ExtractFileDir(ParamStr(0)) + '\';

    if ParamStr(1) = '' then
    begin
      if FileExists(caminhoComBarraNoFinal + 'bd.fdb') then
        bancoControl := caminhoComBarraNoFinal + 'bd.fdb'
      else
        bancoControl := 'C:\CONTROLW\BD.FDB';
    end
    else
      bancoControl := ParamStr(1);

    BDControl.DatabaseName := bancoControl;

    lista1 := TList.Create;
    lista1.Add(QueryControlVenda);
    lista1.Add(QueryControlDivs);
    lista1.Add(ACBrNFe1);
    lista1.Add(nil);
    lista1.Add(ACBrNFeDANFCeFortes1);
    lista1.Add(ACBrNFeDANFeRL1);
    lista1.Add(nil);
    lista1.Add(ACBrNFeDANFeESCPOS1);
    lista1.Add(ACBrIBPTax1);

    try
      setQueryNFCe(lista1);
      LerConfiguracaoNFCe(false);
    except
    end;

  finally
    Timer2.Enabled := true;
    totEnvia := 1;
  end;


  if FileExists(ExtractFileDir(ParamStr(0)) + '\davXXX.rca') then begin
    Timer3.Enabled := true;
  end;
end;

procedure TForm1.FormHide(Sender: TObject);
begin
  TrayIcon1.Visible := true;
end;

procedure TForm1.Timer2Timer(Sender: TObject);
begin
  Timer2.Enabled := false;
  Timer1.Enabled := true;

  if usaMinimize then
    Application.Minimize
  else begin
    Hide;
    TrayIcon1.Visible := true;
  end;
end;

procedure TForm1.Timer3Timer(Sender: TObject);
begin
  Timer3.Enabled := false;
  DeleteFile(ExtractFileDir(ParamStr(0)) + '\davXXX.rca');
  TrayIcon1.Visible := true;
  self.Hide;
end;

procedure TForm1.TrayIcon1Click(Sender: TObject);
begin
  TrayIcon1.Visible := false;
  self.Show;
end;

procedure TForm1.TrayMessage(var Msg: TMessage);
begin
  { case Msg.lParam of
    WM_LBUTTONDOWN:
    begin
    Form1.Show;
    end;
    WM_RBUTTONDOWN:
    begin
    Form1.Hide;
    end;
    end; }
end;

procedure TForm1.Fechar1Click(Sender: TObject);
begin
  Application.Terminate;
end;

procedure TForm1.FinalizaTimerTimer(Sender: TObject);
var
  i : integer;
begin
  FinalizaTimer.Enabled := false;
  RichEdit1.Lines.Add('A Aplicação Já está em Execução e Será Finalizada!');
  for I := 1 to 5 do begin
    RichEdit1.Lines.Add(IntToStr(i));
    Application.ProcessMessages;
    Sleep(1000);
  end;

  Application.Terminate;
end;

procedure TForm1.FormClick(Sender: TObject);
begin
  if usaMinimize then
    Application.Minimize
  else
    Hide;
  // self.Hide;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
var
  tmp : String;
begin
  Timer1.Enabled := false;
  arquivo.SaveToFile(ExtractFileDir(ParamStr(0)) + '\arquivo.dat');

  try
    if not conectaBD_Local() then
    begin
      RichEdit1.Lines.Add('EXIT: linha 343');
      exit;
    end;

     if not conectaBD_Servidor() then begin
       if BD_Servidor.DatabaseName <> '' then begin
         RichEdit1.Lines.Add('EXIT: linha 348');
         exit;
       end;
     end;


    contAtualizacao := contAtualizacao + 1;
    try
      if contAtualizacao > 4 then begin
        try
          sincronizaEstoque;
        except
          on e: exception do begin
            RichEdit1.Lines.Add('ERRO: ' + e.Message + ' linha 290');
          end;
        end;
        contAtualizacao := 1;
      end;

      if inicio = 0 then begin
        if pastaControlW_Servidor <> 'XX' then begin
          RichEdit1.Lines.Add('PC Local: ' + NomedoComputador);
          tmp := copy(pastaControlW_Servidor, 3, length(pastaControlW_Servidor));
          tmp := copy(tmp, 1, pos('\', tmp) -1);

          if ((UpperCase(NomedoComputador) = UpperCase(tmp)) or (UpperCase(tmp) = 'LOCALHOST') or (UpperCase(tmp) = '127.0.0.1')) then begin
            pastaControlW_Servidor := 'XX';
            RichEdit1.Lines.Add('Altere a Pasta de Cópia de XML, Não pode ser informado o PC Local!');
          end;

          RichEdit1.Lines.Add('Destino: ' + tmp);
        end;

        inicio := 1;
        try
          ajustaHoraPelaInternet;
        except
        on e: exception do
          begin
            RichEdit1.Lines.Add('ERRO ajustaHoraPelaInternet 378: ' + e.Message + ' linha 378');
          end;
        end;


        verificaNFCeNovo(DateToStr(StartOfTheMonth(now)), DateToStr(EndOfTheMonth(now)), false);

        try
          sincronizaEstoque;
        except
        on e: exception do
          begin
            RichEdit1.Lines.Add('ERRO sincronizaEstoque: ' + e.Message + ' linha 387');
          end;
        end;

        try
          sincronizaUsuarios;
        except
        on e: exception do
          begin
            RichEdit1.Lines.Add('ERRO sincronizaUsuarios: ' + e.Message + ' linha 396');
          end;
        end;

        try
          sincronizaCEST;
        except
        on e: exception do
          begin
            RichEdit1.Lines.Add('ERRO sincronizaCEST: ' + e.Message + ' linha 405');
          end;
        end;

        try
          sincronizaParamGerais;
        except
        on e: exception do
          begin
            RichEdit1.Lines.Add('ERRO sincronizaParamGerais: ' + e.Message + ' linha 414');
          end;
        end;

        try
          sincronizaPromoc;
        except
        on e: exception do
          begin
            RichEdit1.Lines.Add('ERRO sincronizaPromoc: ' + e.Message + ' linha 498');
          end;
        end;

        try
          testaNFe();
        except
          on e: exception do begin
            RichEdit1.Lines.Add('ERRO testaNFe: ' + e.Message + ' linha 422');
          end;
        end;
      end; //if inicio = 0 then begin

      try
        enviaCuponsPendentes;
      except
        on e: exception do
        begin
          RichEdit1.Lines.Add('ERRO 356: ' + e.Message + #13 +'parte> ' + erro12);
        end;
      end;
    except
      on e: exception do
      begin
        RichEdit1.Lines.Add('ERRO 362: ' + e.Message);
      end;
    end;

    if ERRO_dados = 'Application.Terminate;' then exit;

    if not conectaBD_Local() then
    begin
      RichEdit1.Lines.Add('EXIT: linha 410');
      exit;
    end;

    try
      sincronizaNFCe;
    except
      on e: exception do
      begin
        RichEdit1.Lines.Add('Linha 419: ' + e.Message);
      end;
    end;

    try
      copiaNFes;
    except
      on e: exception do
      begin
        RichEdit1.Lines.Add('Linha 428: ' + e.Message);
      end;
    end;
  finally
    if ERRO_dados <> 'Application.Terminate;' then Timer1.Enabled := true;
  end;
end;

procedure TForm1.FormShow(Sender: TObject);
begin
  Label3.Caption := 'Versão: '+ FileAgeCreate(ParamStr(0));
  TrayIcon1.Visible := false;
end;

procedure TrimAppMemorySize;
var
  MainHandle: THandle;
begin
  try
    MainHandle := OpenProcess(PROCESS_ALL_ACCESS, false, GetCurrentProcessID);
    SetProcessWorkingSetSize(MainHandle, $FFFFFFFF, $FFFFFFFF);
    CloseHandle(MainHandle);
  except
  end;
  Application.ProcessMessages;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  criaXMLs(InputBox('', '', ''), '', '');
end;

function TForm1.conectaBD_Servidor(): boolean;
begin
  Result := false;
  if BD_Servidor.DatabaseName = '' then exit;
  
  BD_Servidor.Connected := false;
  try
    BD_Servidor.Connected := true;
    Result := true;
  except
    on e: exception do
    begin
      RichEdit1.Lines.Add('Ocorreu um Erro na Conexao do BD do servidor!' + #13
        + 'Caminho BD: ' + BD_Servidor.DatabaseName + #13 + 'Erro: ' +
        e.Message);
      erroConectaServidor := erroConectaServidor + 1;
      if erroConectaServidor > 11 then begin
        Self.FormStyle := fsStayOnTop;
        self.Show;
      end;

      if erroConectaServidor > 25 then begin
        erroConectaServidor := 0;
        Self.FormStyle := fsNormal;
      end;
    end;
  end;
end;

function TForm1.sincronizaParamGerais(): boolean;
var
  valor: String;
begin
  Result := false;
  if bdPronto = false then
    exit;

  if conectaBD_Servidor = false then
    exit;

  IBQueryServer1.Close;
  IBQueryServer1.SQL.Text := 'select cod, valor from pgerais where cod = 10';
  try
    IBQueryServer1.Open;
  except
    on e: exception do
    begin
      RichEdit1.Lines.Add('Erro lin 454: ' + e.Message);
      exit;
    end;
  end;

  valor := strnum(IBQueryServer1.fieldbyname('valor').AsString);

  if Contido('|' + valor + '|', '|1|2|3|4|') then
  begin
    IBQuery1.Close;
    IBQuery1.SQL.Text := 'update pgerais set valor = :valor where cod = 10';
    IBQuery1.ParamByName('valor').AsString := valor;
    IBQuery1.ExecSQL;
    IBQuery1.Transaction.Commit;
    RichEdit1.Lines.Add('Parâmetros Gerais Importados: PARAM 10 = ' + valor);
    Result := true;
  end
  else
  begin
    RichEdit1.Lines.Add
      ('ERRO na Conversao dos Param Gerais: PARAM 10 = ' + valor);
  end;

  IBQueryServer1.Close;
  BD_Servidor.Connected := false;
end;

function TForm1.sincronizaEstoque(): boolean;
var
  cods, codsParaExcluir: String;
  lista: TStringList;
  ini, fim, atu, listacount, atualizados, tmp, cont, exclu, acc: integer;
begin
  if bdPronto = false then
    exit;
  if conectaBD_Servidor = false then
    exit;

  if verSeOcorreuMudancaEstoque = false then
    exit;

  IBQueryServer1.Close;
  IBQueryServer1.SQL.Text := sqlSincServer;
  try
    IBQueryServer1.Open;
  except
    on e: exception do
    begin
      RichEdit1.Lines.Add('Erro lin 497: ' + e.Message);
      exit;
    end;
  end;
  IBQueryServer1.FetchAll;

  lista := TStringList.Create;
  lista.Clear;
  le_estoque(lista);

  ini := 0;
  atu := 0;
  cont := 5000;
  atualizados := 0;
  exclu := 0;
  fim := IBQueryServer1.RecordCount;
  if lista.Count = 0 then
    listacount := 0
  else
    listacount := lista.Count - 1;
  self.Caption := 'Sincronizando Estoque...';

  if IBQuery1.Transaction.InTransaction then
    IBQuery1.Transaction.Commit;
  IBQuery1.Transaction.StartTransaction;

  cods := '|';
  acc := 0;
  Gauge1.Progress := 0;
  Gauge1.MaxValue := fim;
  while not IBQueryServer1.Eof do
  begin
    Application.ProcessMessages;
    Gauge1.Progress := Gauge1.Progress + 1;

    cods := cods + IBQueryServer1.fieldbyname('COD').AsString + '|';

    if atu > listacount then
    begin
      try
        copiaProdutoDataSet(IBQueryServer1);
      except
        on e: exception do
        begin
          RichEdit1.Lines.Add('ERRO: ' + e.Message + ' Linha 432');
        end;
      end;
      atu := atu + 1;
      atualizados := atualizados + 1;
    end
    else
    begin
      if listacount = 0 then
      begin
        try
          copiaProdutoDataSet(IBQueryServer1);
        except
          on e: exception do begin
            RichEdit1.Lines.Add('ERRO: ' + e.Message + ' Linha 692');
          end;
        end;
        atualizados := atualizados + 1;
      end
      else
      begin
        IF lista.Names[atu] <> IBQueryServer1.fieldbyname('COD').AsString then
        begin
          tmp := procuraProdutoNaLista(IBQueryServer1.fieldbyname('COD')
            .AsInteger, lista);
          if tmp = -1 then
          begin
             copiaProdutoDataSet(IBQueryServer1);
            if atu < listacount then
              atu := atu + 1;
            atualizados := atualizados + 1;
          end;
        end;

        if lista.ValueFromIndex[atu] <> IBQueryServer1.fieldbyname('hash').AsString
        then
        begin
          try
            copiaProdutoDataSet(IBQueryServer1);
          except
            on e: exception do begin
              RichEdit1.Lines.Add('ERRO719: ' + e.Message );
            end;
          end;
          atualizados := atualizados + 1;
        end;
      end;
    end;

    IBQueryServer1.Next;
    ini := ini + 1;
    acc := acc + 1;
    if atu < listacount then
      atu := atu + 1;
  end;

  if ini > 0 then
  begin
    IBQuery1.Close;
    IBQuery1.SQL.Text := 'select cod from produto';

    try
      IBQuery1.Open;
    except
      on e: exception do
      begin
        RichEdit1.Lines.Add('Erro738: ' + e.Message);
        exit;
      end;
    end;

    while not IBQuery1.Eof do
    begin
      Application.ProcessMessages;
      if Contido('|' + IBQuery1.fieldbyname('cod').AsString + '|', cods) = false
      then
      begin
        IBQuery2.Close;
        IBQuery2.SQL.Text := 'delete from produto where cod = :cod';
        IBQuery2.ParamByName('cod').AsInteger := IBQuery1.fieldbyname('cod')
          .AsInteger;
        try
          IBQuery2.ExecSQL;
        except
          on e: exception do begin
            RichEdit1.Lines.Add('ERRO757: ' + e.Message );
          end;
        end;
        exclu := exclu + 1;
      end;

      IBQuery1.Next;
    end;
  end;
  { IBQuery1.Close;
    IBQuery1.SQL.Text := 'delete from produto p where position(''|'' || p.cod || ''|'' in '+ QuotedStr(cods) +') = 0';
    try
    IBQuery1.ExecSQL;
    except
    on e:exception do
    begin
    RichEdit1.Lines.Add('ERRO: ' + e.Message + ' Linha 480' + #13 + IBQuery1.SQL.Text);
    end;
    end; }

  try
    lista.Free;
  except
  end;

  RichEdit1.Lines.Add('Quantidade de Registros Atualizados: ' +
    IntToStr(atualizados) + ' Produtos');
  RichEdit1.Lines.Add('Quantidade de Produtos  Excluidos  : ' + IntToStr(exclu)
    + ' Produtos');
  if IBQuery1.Transaction.InTransaction then
    IBQuery1.Transaction.Commit;
  if IBQuery2.Transaction.InTransaction then
    IBQuery2.Transaction.Commit;

  reStartGenerator('ATUALIZACADPROD',
    StrToInt(Incrementa_Generator('ATUALIZACADPROD', 0, IBQueryServer1)))
end;

procedure TForm1.LerDadosArquivo();
var
  IniFile, usarBD : String;
  ini: TIniFile;
begin
  if FileExists(ExtractFileDir(ParamStr(0)) + '\ControlW.ini') then
  begin
    IniFile := ExtractFileDir(ParamStr(0)) + '\ControlW.ini';
    // exit;
  end
  else
  begin
    IniFile := ChangeFileExt(Application.ExeName, '.ini');
  end;
  ini := TIniFile.Create(IniFile);

  if ini.ReadString('SERVER', 'usarServidorRemoto', 'N') = 'S' then
    bdPronto := true
  else
    bdPronto := false;

  pastaControlW_Servidor := ini.ReadString('SERVER', 'pastaServidor', '');
  if ((pastaControlW_Servidor <> '') and (pastaControlW_Servidor <> 'XX')) then
  begin
    if RightStr(pastaControlW_Servidor, 1) <> '\' then
      pastaControlW_Servidor := pastaControlW_Servidor + '\';
  end;
  { else begin
    pastaControlW_Servidor := 'XX';
    end; }

  if pastaControlW_Servidor <> '' then
  begin
    RichEdit1.Lines.Add('Pasta ControlW Servidor: ' + pastaControlW_Servidor);
  end;

  BD_Servidor.DatabaseName := ini.ReadString('SERVER', 'conexaoBD', '');

  BD_Servidor.Connected := false;
  ini.Free;
end;

function TForm1.sincronizaUsuarios(): boolean;
var
  ini, fim, atu: integer;
  vende : String;
begin
  if bdPronto = false then
    exit;

  if conectaBD_Servidor = false then
    exit;

  IBQueryServer1.Close;
  IBQueryServer1.SQL.Text := 'select * from usuario';
  try
    IBQueryServer1.Open;
  except
    on e: exception do
    begin
      RichEdit1.Lines.Add('Erro: lin 680' + e.Message);
      exit;
    end;
  end;
  IBQueryServer1.FetchAll;

  ini := 0;
  atu := 0;
  fim := IBQueryServer1.RecordCount;
   vende := '-';

  while not IBQueryServer1.Eof do
  begin
    Application.ProcessMessages;
    ini := ini + 1;

    vende := vende +  IBQueryServer1.fieldbyname('cod').AsString + '-';

    IBQuery1.Close;
    IBQuery1.SQL.Text :=
      'update or insert into usuario(cod, nome, senha, acesso, usu, nom, vendedor, configu)'
      + 'values(:cod, :nome, :senha, :acesso, :usu, :nom, :vendedor, :configu)';
    IBQuery1.ParamByName('cod').AsInteger := IBQueryServer1.fieldbyname('cod')
      .AsInteger;
    IBQuery1.ParamByName('nome').AsString := IBQueryServer1.fieldbyname
      ('nome').AsString;
    IBQuery1.ParamByName('senha').AsString := IBQueryServer1.fieldbyname
      ('senha').AsString;
    IBQuery1.ParamByName('acesso').AsString :=
      IBQueryServer1.fieldbyname('acesso').AsString;
    IBQuery1.ParamByName('usu').AsString := IBQueryServer1.fieldbyname
      ('usu').AsString;
    IBQuery1.ParamByName('nom').AsString := IBQueryServer1.fieldbyname
      ('nom').AsString;
    IBQuery1.ParamByName('vendedor').AsInteger :=
      IBQueryServer1.fieldbyname('vendedor').AsInteger;
    IBQuery1.ParamByName('configu').AsString :=
      IBQueryServer1.fieldbyname('configu').AsString;
    IBQuery1.ExecSQL;

    IBQueryServer1.Next;
  end;

  IBQuery1.Close;
  IBQuery1.SQL.Text := 'select cod from usuario';
  IBQuery1.Open;

  while not IBQuery1.Eof do begin
    if Contido('-' + IBQuery1.FieldByName('cod').AsString + '-', vende) = false then begin
      IBQuery2.Close;
      IBQuery2.SQL.Text := 'delete from usuario where cod = :cod';
      IBQuery2.ParamByName('cod').AsInteger := IBQuery1.FieldByName('cod').AsInteger;
      IBQuery2.ExecSQL;
    end;

    IBQuery1.Next;
  end;




  RichEdit1.Lines.Add('Usuários Importados: ' + IntToStr(ini));

  IBQueryServer1.Close;
  IBQueryServer1.SQL.Text := 'select * from vendedor';
  try
    IBQueryServer1.Open;
  except
    on e: exception do
    begin
      RichEdit1.Lines.Add('Erro lin 719: ' + e.Message);
      exit;
    end;
  end;
  IBQueryServer1.FetchAll;

  ini := 0;
  atu := 0;
  fim := IBQueryServer1.RecordCount;
  vende := '-';

  while not IBQueryServer1.Eof do
  begin
    Application.ProcessMessages;
    ini := ini + 1;

    vende := vende +  IBQueryServer1.fieldbyname('cod').AsString + '-';

    IBQuery1.Close;
    IBQuery1.SQL.Text :=
      'update or insert into VENDEDOR(cod, nome) values(:cod, :nome)';
    IBQuery1.ParamByName('cod').AsInteger := IBQueryServer1.fieldbyname('cod')
      .AsInteger;
    IBQuery1.ParamByName('nome').AsString := IBQueryServer1.fieldbyname
      ('nome').AsString;
    IBQuery1.ExecSQL;

    IBQueryServer1.Next;
  end;

  IBQuery1.Close;
  IBQuery1.SQL.Text := 'select cod from vendedor';
  IBQuery1.Open;

  while not IBQuery1.Eof do begin
    if Contido('-' + IBQuery1.FieldByName('cod').AsString + '-', vende) = false then begin
      IBQuery2.Close;
      IBQuery2.SQL.Text := 'delete from vendedor where cod = :cod';
      IBQuery2.ParamByName('cod').AsInteger := IBQuery1.FieldByName('cod').AsInteger;
      IBQuery2.ExecSQL;
    end;

    IBQuery1.Next;
  end;

  if IBQuery2.Transaction.InTransaction then IBQuery2.Transaction.Commit;

  if ini > 0 then
  begin
    if IBQuery1.Transaction.InTransaction then
      IBQuery1.Transaction.Commit;
  end;

  RichEdit1.Lines.Add('Vendedores Importados: ' + IntToStr(ini));

  IBQueryServer1.Close;
  BD_Servidor.Connected := false;
end;

function TForm1.sincronizaNFCe(): boolean;
var
  //lista: TStringList;
  ini, fim, atu, notaVenda, XMLnEncontrado: integer;
  copiado: boolean;
begin
  Result := false;
  // aqui vai entrar quando nao estiver marcado sincronização e nao estiver informado a pasta pra copiar os xmls
  if ((pastaControlW_Servidor = 'XX') and (bdPronto = false)) then
  begin
    VerificaXMLS_XX;
    exit;
  end;

  // aqui vai entrar quando nao estiver marcado sincronização mas estiver informado a pasta pra copiar os xmls
  if (bdPronto = false) and (pastaControlW_Servidor <> '') then begin
    //RichEdit1.Lines.Add('-----------Nao Tem Sincronização de BD----------------');
    IBQuery1.Close;
    IBQuery1.SQL.Text :=
      'select chave, nota from nfce where ((adic <> ''OFF'')  and (adic = '''') or (adic = ''CANC'') or (adic = ''DENEGADA'')) and exportado = 0 and (substring(chave from 23 for 3) = :serie) ';
    IBQuery1.ParamByName('serie').AsString := strzero(getSerieNFCe, 3);
    IBQuery1.Open;

    if IBQuery1.IsEmpty then begin
      exit;
    end;
    IBQuery1.FetchAll;

    ini := 0;
    atu := 0;
    XMLnEncontrado := 0;
    fim := IBQuery1.RecordCount;

    while not IBQuery1.Eof do begin
      Application.ProcessMessages;
      ini := ini + 1;

      if FileExists(buscaPastaNFCe(IBQuery1.fieldbyname('chave').AsString) +
        IBQuery1.fieldbyname('chave').AsString + '-nfe.xml') then begin

        copiado := copiaNFCes(IBQuery1.fieldbyname('chave').AsString,
          IBQuery1.fieldbyname('nota').AsInteger, notaVenda, true);

        if copiado then begin
          IBQuery2.Close;
          IBQuery2.SQL.Text :=
          'update nfce set exportado = 1 where chave = :chave';
          IBQuery2.ParamByName('chave').AsString := IBQuery1.fieldbyname('chave').AsString;
          IBQuery2.ExecSQL;
          IBQuery2.Transaction.Commit;
        end;

        // if copiado then RichEdit1.Lines.Add('Nota Servidor: ' + IntToStr(notaVenda) + ' OK!!')
        // else RichEdit1.Lines.Add('ERRO Nota Servidor: ' + IntToStr(notaVenda) + ' !');
      end
      else
        XMLnEncontrado := XMLnEncontrado + 1;

      IBQuery1.Next;
    end;

    if ini > 0 then begin
      RichEdit1.Lines.Add('Vendas Exportadas1: ' + strzero(ini, 3) + ' Nota: ' +
        IBQuery1.fieldbyname('nota').AsString + #13 + 'XML Nao Encontrados: ' +
        IntToStr(XMLnEncontrado));
      if IBQuery2.Transaction.InTransaction then
        IBQuery2.Transaction.Commit;
    end;

    exit;
  end;

  if bdPronto = false then begin
    RichEdit1.Lines.Add('bdPronto = false Linha: 996');
    exit;
  end;

  if conectaBD_Servidor = false then begin
    RichEdit1.Lines.Add('conectaBD_Servidor = false Linha: 1001');
    exit;
  end;

  if IBQueryServer1.Transaction.InTransaction then
    IBQueryServer1.Transaction.Commit;
  IBQueryServer1.Transaction.StartTransaction;

  IBQuery1.Close;
  IBQuery1.SQL.Text :=
    'select chave, nota from nfce where ((adic <> ''OFF'')  and(adic = '''') or (adic = ''CANC'') or (adic = ''DENEGADA'')) and exportado = 0 and (substring(chave from 23 for 3) = :serie) ';
  IBQuery1.ParamByName('serie').AsString := strzero(getSerieNFCe, 3);
  IBQuery1.Open;
  IBQuery1.FetchAll;

  if IBQuery1.IsEmpty then begin

  end;

  ini := 0;
  atu := 0;
  XMLnEncontrado := 0;
  fim := IBQuery1.RecordCount;

  while not IBQuery1.Eof do
  begin
    Application.ProcessMessages;
    ini := ini + 1;

    if FileExists(buscaPastaNFCe(IBQuery1.fieldbyname('chave').AsString) +
      IBQuery1.fieldbyname('chave').AsString + '-nfe.xml') then

    begin
      if verificaCstatXML(IBQuery1.fieldbyname('chave').AsString) then begin
        if copiaVendas(IBQuery1.fieldbyname('nota').AsInteger, notaVenda,
          IBQuery1.fieldbyname('chave').AsString) then begin

          copiado := copiaNFCes(IBQuery1.fieldbyname('chave').AsString,
          IBQuery1.fieldbyname('nota').AsInteger, notaVenda);

          if copiado then begin
            IBQuery2.Close;
            IBQuery2.SQL.Text := 'update nfce set exportado = 1 where chave = :chave';
            IBQuery2.ParamByName('chave').AsString := IBQuery1.fieldbyname('chave').AsString;
            IBQuery2.ExecSQL;
            IBQuery2.Transaction.Commit;
          end;
        end
        else RichEdit1.Lines.Add('copiaVendas false');
      end;

      RichEdit1.Lines.Add('Nota Servidor: ' + IntToStr(notaVenda) + ' OK!!');
    end
    else begin
      XMLnEncontrado := XMLnEncontrado + 1;

      RichEdit1.Lines.Add('XML '+buscaPastaNFCe(IBQuery1.fieldbyname('chave').AsString) +
      IBQuery1.fieldbyname('chave').AsString + '-nfe.xml Não Encontrado!');
    end;

    IBQuery1.Next;
  end;

  if ini > 0 then
  begin
    RichEdit1.Lines.Add('Vendas Exportadas: ' + strzero(ini, 3) + ' Nota: ' +
      IBQuery1.fieldbyname('nota').AsString + #13 + 'XML Nao Encontrados: ' +
      IntToStr(XMLnEncontrado));

    if IBQuery2.Transaction.InTransaction then
      IBQuery2.Transaction.Commit;
    if IBQueryServer1.Transaction.InTransaction then
      IBQueryServer1.Transaction.Commit;
  end;

  BD_Servidor.Connected := false;
  // BD_Servidor.Close;
end;

function TForm1.copiaVendas(nota: integer; var notaNova: integer;
  chave: String; Cancelado: integer = 0) : boolean;
var
  vendedor : string;
begin
  Result := false;

  if nota = 0 then begin
    Result := true;
    exit;
  end;

  Result := false;
  IBQuery2.Close;
  IBQuery2.SQL.Text := 'select * from venda where nota = :nota';
  IBQuery2.ParamByName('nota').AsInteger := nota;
  IBQuery2.Open;

  if IBQuery2.IsEmpty then begin
    //RichEdit1.Lines.Add('IBQuery2.IsEmpty - Linha 1064');
    RichEdit1.Lines.Add('Venda: ' + IntToStr(nota) + ' Não Encontrada!');
    exit;
  end;

  IBQueryServer1.Close;
  IBQueryServer1.SQL.Text :=
    'select chave, nota from nfce where chave = :chave';
  IBQueryServer1.ParamByName('chave').AsString := chave;

  try
    IBQueryServer1.Open;
  except
    on e: exception do
    begin
      RichEdit1.Lines.Add('Erro 897: ' + e.Message);
      exit;
    end;
  end;

  If IBQueryServer1.IsEmpty = false then
  // se existir uma nfce com essa chave no bd do servidor
  begin
    notaNova := IBQueryServer1.fieldbyname('nota').AsInteger;
    Cancelado := IBQuery2.fieldbyname('cancelado').AsInteger;
    // if Cancelado = 0 then Cancelado := 1;
    if Cancelado > 0 then begin
      IBQueryServer1.Close;
      IBQueryServer1.SQL.Text :=
        'update venda set cancelado = :canc where nota = :nota';
      IBQueryServer1.ParamByName('canc').AsInteger := Cancelado;
      IBQueryServer1.ParamByName('nota').AsInteger := notaNova;
      IBQueryServer1.ExecSQL;
      IBQueryServer1.Transaction.Commit;
      Result := true;

      RichEdit1.Lines.Add('Venda No ' + IntToStr(notaNova) +
        ' Cancelada No Servidor pelo Usuário ' + IntToStr(Cancelado) +
        ' Linha 630');
      Result := true;
      exit;
    end
    else begin
      IBQueryServer1.Close;
      IBQueryServer1.SQL.Text := 'select * from venda where nota = :nota';
      IBQueryServer1.ParamByName('nota').AsInteger := notaNova;
      try
        IBQueryServer1.Open;
      except
        on e: exception do
        begin
          RichEdit1.Lines.Add('Erro 929: ' + e.Message);
          exit
        end;
      end;

      if not IBQueryServer1.IsEmpty then begin
        RichEdit1.Lines.Add('Venda No ' + IntToStr(notaNova) + ' Linha 642');
        {copiaNFCes(IBQuery1.fieldbyname('chave').AsString,
        IBQuery1.fieldbyname('nota').AsInteger, notaVenda, true);
        exit;}
        Result := true;
        exit;
      end;

      IBQueryServer1.Close;
      IBQueryServer1.SQL.Text := 'select nota, crc from venda where crc = :crc';
      IBQueryServer1.ParamByName('crc').AsString := IBQuery2.FieldByName('crc').AsString;
      try
        IBQueryServer1.Open;
      except
        on e: exception do
        begin
          RichEdit1.Lines.Add('Erro 929: ' + e.Message);
          exit
        end;
      end;

      if not IBQueryServer1.IsEmpty then begin
        RichEdit1.Lines.Add('Venda No ' + IntToStr(nota) + ' já Existe Linha 1106');
        notaNova := nota;
        Result := true;
        exit;
      end;
    end;
  end;


  IBQueryServer1.Close;
  IBQueryServer1.SQL.Text := 'select nota from venda where crc = :nota';
  IBQueryServer1.ParamByName('nota').AsString := buscaCRCdaChave(chave);
  IBQueryServer1.Open;

  if IBQueryServer1.IsEmpty = false then begin
    Result := true;
    RichEdit1.Lines.Add('IBQueryServer1.IsEmpty - Linha 1269');
    RichEdit1.Lines.Add('Venda já existe NOTA: ' + IBQueryServer1.FieldByName('nota').AsString + ' crc='+ IBQuery2.FieldByName('crc').AsString);
    exit;
  end
  else begin
    RichEdit1.Lines.Add('CRC: '+ '"' + buscaCRCdaChave(chave) + '"' );
  end;


  notaNova := StrToInt(Incrementa_Generator('venda', 1, IBQueryServer1));
  RichEdit1.Lines.Add('Venda No: ' + IntToStr(notaNova));

  if IBQueryServer1.Transaction.InTransaction then
    IBQueryServer1.Transaction.Commit;
  IBQueryServer1.Transaction.StartTransaction;

  IBQueryServer1.Close;
  IBQueryServer1.SQL.Text :=
    'insert into venda(nota, data, total, vendedor, cliente, desconto, entrega, hora,'
    + 'codhis, cancelado, prazo, entrada, ok, crc, usuario) values(:nota, :data, :total, :vendedor, :cliente, :desconto, :entrega, :hora,'
    + ':codhis, :cancelado, :prazo, :entrada, :ok, :crc, :usuario)';
  IBQueryServer1.ParamByName('nota').AsInteger := notaNova;
  IBQueryServer1.ParamByName('data').AsDate := IBQuery2.fieldbyname('data')
    .AsDateTime;
  IBQueryServer1.ParamByName('total').AsCurrency :=
    IBQuery2.fieldbyname('total').AsCurrency;

  vendedor := IBQuery2.fieldbyname('vendedor').AsString;
  IBQueryServer1.ParamByName('vendedor').AsInteger :=
    IBQuery2.fieldbyname('vendedor').AsInteger;
  IBQueryServer1.ParamByName('cliente').AsInteger :=
    IBQuery2.fieldbyname('cliente').AsInteger;
  IBQueryServer1.ParamByName('desconto').AsCurrency :=
    IBQuery2.fieldbyname('desconto').AsCurrency;
  IBQueryServer1.ParamByName('entrega').AsString :=
    IBQuery2.fieldbyname('entrega').AsString;
  IBQueryServer1.ParamByName('hora').AsTime := IBQuery2.fieldbyname('hora')
    .AsDateTime;
  IBQueryServer1.ParamByName('codhis').AsInteger :=
    IBQuery2.fieldbyname('codhis').AsInteger;
  IBQueryServer1.ParamByName('cancelado').AsInteger :=
    IBQuery2.fieldbyname('cancelado').AsInteger;
  IBQueryServer1.ParamByName('prazo').AsInteger := IBQuery2.fieldbyname('prazo')
    .AsInteger;
  IBQueryServer1.ParamByName('entrada').AsCurrency :=
    IBQuery2.fieldbyname('entrada').AsCurrency;
  IBQueryServer1.ParamByName('ok').AsString :=
    IBQuery2.fieldbyname('ok').AsString;
  IBQueryServer1.ParamByName('crc').AsString :=
    IBQuery2.fieldbyname('crc').AsString;
  IBQueryServer1.ParamByName('usuario').AsInteger :=
    IBQuery2.fieldbyname('usuario').AsInteger;
  IBQueryServer1.ExecSQL;

  IBQuery2.Close;
  IBQuery2.SQL.Text := 'select * from item_venda where nota = :nota';
  IBQuery2.ParamByName('nota').AsInteger := nota;
  IBQuery2.Open;

  while not IBQuery2.Eof do
  begin
    Application.ProcessMessages;
    IBQueryServer1.Close;
    IBQueryServer1.SQL.Text :=
      'insert into item_venda(nota, cod, quant, p_venda, total, aliquota, data, unid, vendedor)'
      + ' values(:nota, :cod, :quant, :p_venda, :total, :aliquota, :data, :unid, :vendedor)';
    IBQueryServer1.ParamByName('nota').AsInteger := notaNova;
    IBQueryServer1.ParamByName('cod').AsInteger := IBQuery2.fieldbyname('cod')
      .AsInteger;
    IBQueryServer1.ParamByName('quant').AsCurrency :=
      IBQuery2.fieldbyname('quant').AsCurrency;
    IBQueryServer1.ParamByName('p_venda').AsCurrency :=
      IBQuery2.fieldbyname('p_venda').AsCurrency;
    IBQueryServer1.ParamByName('total').AsCurrency :=
      IBQuery2.fieldbyname('total').AsCurrency;
    IBQueryServer1.ParamByName('aliquota').AsString :=
      IBQuery2.fieldbyname('aliquota').AsString;
    IBQueryServer1.ParamByName('data').AsDate := IBQuery2.fieldbyname('data')
      .AsDateTime;
    IBQueryServer1.ParamByName('unid').AsString :=
      IBQuery2.fieldbyname('unid').AsString;

    IBQueryServer1.ParamByName('vendedor').AsString := vendedor;
    IBQueryServer1.ExecSQL;

    if baixarEstoque then begin
      IBQueryServer1.Close;
      IBQueryServer1.SQL.Text :=
      'update produto set quant = quant - :quant where cod = :cod';
      IBQueryServer1.ParamByName('quant').AsCurrency :=
      IBQuery2.fieldbyname('quant').AsCurrency;
      IBQueryServer1.ParamByName('cod').AsInteger := IBQuery2.fieldbyname('cod')
      .AsInteger;
      IBQueryServer1.ExecSQL;
    end;


    baixarEstoque := true;

    IBQuery2.Next;
  end;

  IBQueryServer1.Transaction.Commit;
  Result := true;
end;

function TForm1.copiaNFCes(chave: String; nota, notaNova: integer;
  somenteCopiaXML: boolean = false): boolean;
var
  arq: TStringList;
  cstat: String;
  copiado : boolean;
begin
  Result := false;
  IBQuery2.Close;
  IBQuery2.SQL.Text := 'select * from nfce where chave = :nota';
  IBQuery2.ParamByName('nota').AsString := chave;
  IBQuery2.Open;

  if verificaCstatXML(chave) = false then exit;

  try
    if pastaControlW_Servidor = 'XX' then begin
      IBQuery2.Close;
      IBQuery2.SQL.Text :=
      'update nfce set exportado = 1 where chave = :chave';
      IBQuery2.ParamByName('chave').AsString := chave;
      IBQuery2.ExecSQL;
      IBQuery2.Transaction.Commit;
      exit;
    end;
  except
    on e: exception do begin
      RichEdit1.Lines.Add('XML SEM PROTOCOLO: ' + chave);
      RichEdit1.Lines.Add('CONSULTA ERRO: ' + e.Message);
      exit;
    end;
  end;

    try
      if not DirectoryExists(buscaPastaNFCe(chave, false, pastaControlW_Servidor)) then
        ForceDirectories(buscaPastaNFCe(chave, false, pastaControlW_Servidor));

      if FileExists(buscaPastaNFCe(chave) + chave +
        '-nfe.xml') then begin
        Result := copiaArquivo(buscaPastaNFCe(chave) +
          chave + '-nfe.xml', (buscaPastaNFCe(chave, false, pastaControlW_Servidor) +
          chave + '-nfe.xml'));
      end;
    except
      on e: exception do begin
        RichEdit1.Lines.Add('Erro na Cópia de XML para o Servidor: ' + e.Message
          + ' Linha 781');
      end;
    end;

    if Result then begin
      RichEdit1.Lines.Add('XML ' + chave + ' Copiado para ' +
        buscaPastaNFCe(chave, false, pastaControlW_Servidor));
      RichEdit1.Lines.Add('XML EXPORTADO' + chave + ' !');
    end
    else begin
      RichEdit1.Lines.Add('ERRO NA COPIA XML ' + chave);
      RichEdit1.Lines.Add('DE ' + buscaPastaNFCe(chave) +
        chave + '-nfe.xml' + '  PARA ' + buscaPastaNFCe(chave, false, pastaControlW_Servidor) +
        chave + '-nfe.xml');
    end;


  if bdPronto = false then begin
    RichEdit1.Lines.Add('exit linha 1430');
    exit;
  end;


  if IBQueryServer1.Transaction.InTransaction then
    IBQueryServer1.Transaction.Commit;
  IBQueryServer1.Transaction.StartTransaction;

  IBQueryServer1.Close;
  IBQueryServer1.SQL.Text :=
    'update or insert into nfce(nota, data, chave, adic, cliente, EXPORTADO)' +
    ' values(:nota, :data, :chave, :adic, :cliente, :EXPORTADO) matching(chave)';
  IBQueryServer1.ParamByName('nota').AsInteger := notaNova;
  IBQueryServer1.ParamByName('data').AsDate := IBQuery2.fieldbyname('data')
    .AsDateTime;
  IBQueryServer1.ParamByName('chave').AsString :=
    IBQuery2.fieldbyname('chave').AsString;
  IBQueryServer1.ParamByName('adic').AsString :=
    IBQuery2.fieldbyname('adic').AsString;
  IBQueryServer1.ParamByName('cliente').AsInteger := nota;
  IBQueryServer1.ParamByName('EXPORTADO').AsInteger :=
    IBQuery2.fieldbyname('EXPORTADO').AsInteger;
  try
    IBQueryServer1.ExecSQL;
    RichEdit1.Lines.Add('Registro ' + IBQuery2.fieldbyname('chave').AsString + ' Inserido com Sucesso!');

   { arq := TStringList.Create;
    try

      arq.LoadFromFile(buscaPastaNFCe(IBQuery2.fieldbyname('chave').AsString) +
        IBQuery2.fieldbyname('chave').AsString + '-nfe.xml');
      if Le_Nodo('cStat', arq.Text) = '' then
      begin
        ACBrNFe1.NotasFiscais.LoadFromFile(buscaPastaNFCe(IBQuery2.fieldbyname('chave').AsString) + IBQuery2.fieldbyname('chave').AsString + '-nfe.xml');
        // ACBrNFe1.Consultar;
      end;
    except
      on e: exception do
      begin
        RichEdit1.Lines.Add('Erro na Cópia de XML para o Servidor: ' + e.Message
          + ' Linha 845');
      end;
    end;  }


    try
      if not DirectoryExists(buscaPastaNFCe(chave, false, pastaControlW_Servidor)) then
        ForceDirectories(buscaPastaNFCe(chave, false, pastaControlW_Servidor));

      if verificaCstatXML(IBQuery2.fieldbyname('chave').AsString) = false then exit;

      copiado := CopyFile(pchar(buscaPastaNFCe(IBQuery2.fieldbyname('chave').AsString) +
        IBQuery2.fieldbyname('chave').AsString + '-nfe.xml'),
        pchar(buscaPastaNFCe(IBQuery2.fieldbyname('chave').AsString, false, pastaControlW_Servidor) +
        IBQuery2.fieldbyname('chave').AsString + '-nfe.xml'), true);
    except
      on e: exception do
      begin
        RichEdit1.Lines.Add('Erro na Cópia de XML para o Servidor: ' + e.Message
          + ' Linha 854');
      end;
    end;

    if copiado then begin
      IBQuery2.Close;
      IBQuery2.SQL.Text := 'update nfce set exportado = 1 where chave = :chave';
      IBQuery2.ParamByName('chave').AsString := chave;
      IBQuery2.ExecSQL;
      IBQuery2.Transaction.Commit;
    end;

    if IBQueryServer1.Transaction.InTransaction then
      IBQueryServer1.Transaction.Commit;
  except
    on e: exception do
      begin
        RichEdit1.Lines.Add('Erro na inserção do registro: ' + e.Message
          + ' Linha 1504');
      end;
  end;
end;

function TForm1.Incrementa_Generator(Gen_name: string;
  valor_incremento: integer; var query: TIBQuery): string;
begin
  try
    query.Close;
    query.SQL.Clear;
    query.SQL.Add('select gen_id(' + Gen_name + ',' + IntToStr(valor_incremento)
      + ') as venda from rdb$database');
    query.Open;

    Result := '';
    Result := query.fieldbyname('venda').AsString;

    query.Close;
  except
  end;
end;

procedure TForm1.le_estoque(var listaprod: TStringList);
var
  ini, fim: integer;
begin
  listaprod := TStringList.Create;
  IBQuery1.Close;
  IBQuery1.SQL.Text := sqlSinc;
  IBQuery1.Open;
  IBQuery1.FetchAll;

  ini := 0;
  // fim := IBQuery1.RecordCount;
  self.Caption := 'Lendo Estoque...';

  if IBQuery1.IsEmpty then
  begin
    listaprod.Clear;
    IBQuery1.Close;
    exit;
  end;

  while not IBQuery1.Eof do
  begin
    Application.ProcessMessages;
    ini := ini + 1;
    // progresso(ini, fim);
    listaprod.Add(IBQuery1.fieldbyname('cod').AsString + '=' +
      IBQuery1.fieldbyname('hash').AsString);
    IBQuery1.Next;
  end;
end;

procedure TForm1.copiaProduto(cod: integer);
begin
  IBQueryServer2.Close;
  if cod > 0 then
  begin
    IBQueryServer2.SQL.Text :=
      'select cod,nome, codbar, quant, p_venda, unid, classif, aliquota, is_pis, cod_ispis from produto'
      + ' where cod = :cod';
    IBQueryServer2.ParamByName('cod').AsInteger := cod;
  end
  else
    IBQueryServer2.SQL.Text :=
      'select cod,nome, codbar, quant, p_venda, unid, classif, aliquota, is_pis, cod_ispis from produto';

  try
    IBQueryServer2.Open;
  except
    on e: exception do
    begin
      RichEdit1.Lines.Add('ERRO: ' + e.Message + ' Linha 945');
    end;
  end;

  IBQuery1.Close;
  IBQuery1.SQL.Text :=
    'update or insert into produto(cod, quant, nome, codbar, p_venda, unid, classif, aliquota, is_pis, cod_ispis, grupo)'
    + ' values(:cod, :quant, :nome, :codbar, :p_venda, :unid, :classif, :aliquota, :is_pis, :cod_ispis, 0)';
  IBQuery1.ParamByName('quant').AsCurrency := IBQueryServer2.fieldbyname
    ('quant').AsCurrency;
  IBQuery1.ParamByName('cod').AsInteger := IBQueryServer2.fieldbyname('cod')
    .AsInteger;
  IBQuery1.ParamByName('nome').AsString := IBQueryServer2.fieldbyname
    ('nome').AsString;
  IBQuery1.ParamByName('codbar').AsString := IBQueryServer2.fieldbyname
    ('codbar').AsString;
  IBQuery1.ParamByName('p_venda').AsCurrency :=
    IBQueryServer2.fieldbyname('p_venda').AsCurrency;
  IBQuery1.ParamByName('unid').AsString := IBQueryServer2.fieldbyname
    ('unid').AsString;
  IBQuery1.ParamByName('classif').AsString := IBQueryServer2.fieldbyname
    ('classif').AsString;
  IBQuery1.ParamByName('aliquota').AsString :=
    IBQueryServer2.fieldbyname('aliquota').AsString;
  IBQuery1.ParamByName('is_pis').AsString := IBQueryServer2.fieldbyname
    ('is_pis').AsString;
  IBQuery1.ParamByName('cod_ispis').AsString :=
    IBQueryServer2.fieldbyname('cod_ispis').AsString;

  try
    IBQuery1.ExecSQL;
  except
    on e: exception do
    begin
      RichEdit1.Lines.Add('ERRO: ' + e.Message + ' Linha 965');
    end;
  end;
end;

procedure TForm1.copiaProdutoDataSet(var queryServer: TIBQuery);
begin

  IBQuery1.Close;
  IBQuery1.SQL.Text :=
    'update or insert into produto(cod, quant, nome, codbar, p_venda, unid, classif, aliquota, is_pis, cod_ispis, grupo)'
    + ' values(:cod, :quant, :nome, :codbar, :p_venda, :unid, :classif, :aliquota, :is_pis, :cod_ispis, 0)';
  IBQuery1.ParamByName('cod').AsInteger := queryServer.fieldbyname('cod')
    .AsInteger;
  IBQuery1.ParamByName('quant').AsCurrency := queryServer.fieldbyname('quant')
    .AsCurrency;
  IBQuery1.ParamByName('nome').AsString :=
    queryServer.fieldbyname('nome').AsString;
  IBQuery1.ParamByName('codbar').AsString :=
    queryServer.fieldbyname('codbar').AsString;

  if ((LeftStr(queryServer.fieldbyname('codbar').AsString, 1) = '2') and
    (length(queryServer.fieldbyname('codbar').AsString) < 13)) then
  begin
    IBQuery1.ParamByName('codbar').AsString :=
      LeftStr(queryServer.fieldbyname('codbar').AsString, 5);
  end;

  IBQuery1.ParamByName('p_venda').AsCurrency :=
    queryServer.fieldbyname('p_venda').AsCurrency;
  IBQuery1.ParamByName('unid').AsString :=
    queryServer.fieldbyname('unid').AsString;
  IBQuery1.ParamByName('classif').AsString :=
    queryServer.fieldbyname('classif').AsString;
  IBQuery1.ParamByName('aliquota').AsString :=
    queryServer.fieldbyname('aliquota').AsString;
  IBQuery1.ParamByName('is_pis').AsString :=
    queryServer.fieldbyname('is_pis').AsString;
  IBQuery1.ParamByName('cod_ispis').AsString :=
    queryServer.fieldbyname('cod_ispis').AsString;
  try
    IBQuery1.ExecSQL;
  except
    on e: exception do
    begin
      RichEdit1.Lines.Add('ERRO: ' + e.Message + ' Linha 971');
    end;
  end;
end;

procedure TForm1.progresso(ini, fim: integer);
var
  b: integer;
begin
  Application.ProcessMessages;
  // exit;
  Gauge1.Progress := trunc(ini / fim * 100);
  if Gauge1.Progress > b then
  begin
    b := b + 5;
    Gauge1.Progress := b;
  end;
end;

procedure TForm1.Abrir1Click(Sender: TObject);
begin
  self.Show;
end;

procedure TForm1.ACBrNFe1GerarLog(const ALogLine: string; var Tratado: Boolean);
begin
  gravaERRO_LOG1('', ALogLine, '');
end;

procedure TForm1.ajustaHoraPelaInternet();
var
  data: TDateTime;
  SystemTime: TSystemTime;
  cont: integer;
begin
  cont := 0;
  while true do
  begin
    if cont > 5 then
    begin
      RichEdit1.Lines.Add
        ('Tentativas de Atualização de Hora Esgotados e Não Possivel atualizar a Hora!');
      exit;
    end;

    cont := cont + 1;
    try
      data := IdSNTP1.DateTime;
    except
      on e: exception do
      begin
        RichEdit1.Lines.Add
          ('Erro Na Atualização da Hora data := IdSNTP1.DateTime: ' +
          e.Message);
      end;
    end;

    try
      if data > StrToDate('01/01/2016') then
      begin
        break;
      end;
    except
      on e: exception do
      begin
        RichEdit1.Lines.Add
          ('Erro Na Atualização da Hora:  data > StrToDate(01/01/2016):' +
          e.Message);
      end;
    end;
  end;

  try
    if data < StrToDate('01/01/2016') then
    begin
      RichEdit1.Lines.Add
        ('Tentativas de Atualização de Hora Esgotados e Não Possivel atualizar a Hora! Linha 1083');
      exit;
    end;
  except
    on e: exception do
    begin
      RichEdit1.Lines.Add
        ('Erro Na Atualização da Hora:  data > StrToDate(01/01/2016):' +
        e.Message);
    end;
  end;

  RichEdit1.Lines.Add('--------------------------------------------------');
  RichEdit1.Lines.Add('Hora Ajustada: ' + FormatDateTime('dd/mm/yy', data) + ' '
    + FormatDateTime('hh:mm:ss', data));
  RichEdit1.Lines.Add('--------------------------------------------------');

  SystemTime.wYear := YearOf(data);
  SystemTime.wMonth := MonthOf(data);
  SystemTime.wDay := DayOf(data);
  SystemTime.wHour := HourOf(data);
  SystemTime.wMinute := MinuteOf(data);
  SystemTime.wSecond := SecondOf(data);
  SetLocalTime(SystemTime);
end;

function TForm1.verSeOcorreuMudancaEstoque(): boolean;
var
  codLocal: String;
begin
  if BD_Servidor.Connected = false then
    exit;
  Result := false;
  codLocal := Incrementa_Generator('ATUALIZACADPROD', 0, IBQuery2);
  if codLocal <> Incrementa_Generator('ATUALIZACADPROD', 0, IBQueryServer1) then
  begin
    Result := true;
  end;
end;

function TForm1.conectaBD_Local(): boolean;
begin
  Result := false;
  try
    BDControl.Connected := false;

    {if BDControl.Connected then
    begin
      sinal(3);
      Result := true;
      if inicioPgerais = 0 then
      begin
        geraPgerais(pgerais);
        inicioPgerais := 1;
      end;
      exit;
    end;   }

    BDControl.Connected := true;
    Result := true;
    sinal(3);

    if inicioPgerais = 0 then
    begin
      geraPgerais(pgerais);
      inicioPgerais := 1;
    end;
  except
    on e: exception do
    begin
      RichEdit1.Lines.Add('Ocorreu um Erro na Conexao do BD!' + #13 +
        'Caminho BD: ' + BDControl.DatabaseName + #13 + 'Erro: ' + e.Message);
      sinal(2);
    end;
  end;

end;

procedure TForm1.sinal(const num: integer);
begin
  if num = 1 then
  begin
    Panel1.Color := clYellow;
    Label2.Caption := 'Preparando...';
  end
  else if num = 2 then
  begin
    Panel1.Color := clRed;
    Label2.Caption := 'Erro!';
  end
  else if num = 3 then
  begin
    Panel1.Color := clGreen;
    Label2.Caption := 'Funcionando!';
  end;
end;

procedure TForm1.copiaNFes();
var
  arq: TStringList;
  csta : integer;
  copiado : boolean;
begin
  if (((emitNFe and CAMPO_EXPORTADO_FOI_CRIADO) = false)) then
  begin
    exit;
  end;

  // if pastaControlW_Servidor = '' then exit;

  arq := TStringList.Create;

  IBQuery1.Close;
  IBQuery1.SQL.Text := 'select * from nfe where exportado = 0';
  IBQuery1.Open;

  while not IBQuery1.Eof do
  begin
    Application.ProcessMessages;
    IBQuery2.Close;
    IBQuery2.SQL.Text := 'update nfe set exportado = 1 where chave = :chave';
    IBQuery2.ParamByName('chave').AsString := IBQuery1.fieldbyname('chave').AsString;
    IBQuery2.ExecSQL;
    IBQuery2.Transaction.Commit;

    TRY
    if not FileExists(pastanfe + IBQuery1.fieldbyname('chave').AsString +
      '-nfe.xml') then
    begin
      RichEdit1.Lines.Add('NFe: ' + IBQuery1.fieldbyname('chave').AsString +
        '-nfe.xml Não Encontrada!');
    end
    else
    begin
      arq.LoadFromFile(pastanfe + IBQuery1.fieldbyname('chave').AsString +
        '-nfe.xml');
      if Le_Nodo('cStat', arq.Text) = '' then
      begin
        ACBrNFe1.NotasFiscais.LoadFromFile(ExtractFileDir(ParamStr(0)) +
          '\NFe\EMIT\' + IBQuery1.fieldbyname('chave').AsString + '-nfe.xml');
        try
          ACBrNFe1.Consultar;
          csta := ACBrNFe1.NotasFiscais[0].NFe.procNFe.cstat;
          RichEdit1.Lines.Add('------------------------------------------------------');
          RichEdit1.Lines.Add('Chave NFe: ' + IBQuery1.fieldbyname('chave').AsString);
          RichEdit1.Lines.Add('CONSULTA: cStat=' +
          IntToStr(ACBrNFe1.NotasFiscais[0].NFe.procNFe.cstat));
          if csta = 237 then begin
            RichEdit1.Lines.Add('Enviando...');
            ACBrNFe1.Enviar(0, false);
            if csta in [100,150] then begin
              acBrNFe1.NotasFiscais[0].GravarXML(IBQuery1.fieldbyname('chave').AsString + '-nfe.xml', ExtractFileDir(ParamStr(0)) +
              '\NFe\EMIT\' );
            end;
          end;

          RichEdit1.Lines.Add('------------------------------------------------------');

        except
          on e: exception do
          begin
            RichEdit1.Lines.Add('Erro na Consulta da NFe: ' +
              IBQuery1.fieldbyname('chave').AsString + ' Linha 967' + #13 + e.Message);
          end;
        end;
      end
      else
      begin
        if ((pastaControlW_Servidor <> 'XX') and (pastaControlW_Servidor <> '')) then begin
          try
            if not DirectoryExists(pastaControlW_Servidor + 'NFe\EMIT\') then
              ForceDirectories(pastaControlW_Servidor + 'NFe\EMIT\');

            if verificaCstatXML(IBQuery1.fieldbyname('chave').AsString) = false then exit;

            copiado := CopyFile(pchar(ExtractFileDir(ParamStr(0)) + '\NFe\EMIT\' +
              IBQuery1.fieldbyname('chave').AsString + '-nfe.xml'),
              pchar(pastaControlW_Servidor + 'NFe\EMIT\' +
              IBQuery1.fieldbyname('chave').AsString + '-nfe.xml'), true);
          except
            on e: exception do begin
              RichEdit1.Lines.Add('Erro na Cópia de XML para o Servidor: ' +
                e.Message + ' Linha 1066');
            end;
          end;
        end;

        if copiado then begin
          IBQuery2.Close;
          IBQuery2.SQL.Text :=
          'update nfe set exportado = 1 where chave = :chave';
          IBQuery2.ParamByName('chave').AsString :=
          IBQuery1.fieldbyname('chave').AsString;
          IBQuery2.ExecSQL;
          IBQuery2.Transaction.Commit;
        end;
      end;
    end;
    FINALLY
      IBQuery1.Next;
    END;
  end;

end;

function TForm1.listaArquivos(const pasta: String): TStringList;
Var
  SearchFile: TSearchRec;
  FindResult: integer;
begin
  Result := TStringList.Create;
  FindResult := FindFirst(pasta, 0, SearchFile);
  try
    While FindResult = 0 do
    begin
      Application.ProcessMessages;
      Result.Add(SearchFile.Name);
      FindResult := FindNext(SearchFile);
    end;
  finally
    FindClose(SearchFile)
  end;
end;

function TForm1.VerificaCampoTabela(NomeCampo, tabela: string;
  var query: TIBQuery): boolean;
var
  texto: string;
  ini: integer;
begin
  Result := false;

  query.Close;
  query.SQL.Text :=
    'SELECT R.RDB$FIELD_NAME AS CAMPO,T.RDB$TYPE_NAME AS TIPO,  ' +
    'F.RDB$FIELD_LENGTH AS TAMANHO FROM RDB$RELATION_FIELDS R   ' +
    'JOIN RDB$FIELDS F ON F.RDB$FIELD_NAME = R.RDB$FIELD_SOURCE ' +
    'JOIN RDB$TYPES T ON F.RDB$FIELD_TYPE = T.RDB$TYPE WHERE    ' +
    '(R.RDB$RELATION_NAME = ' + QuotedStr(tabela) + ') AND                 ' +
    '(T.RDB$FIELD_NAME = ''RDB$FIELD_TYPE'') AND R.RDB$FIELD_NAME = ' +
    QuotedStr(NomeCampo) + ' ORDER BY R.RDB$FIELD_NAME';
  query.Open;

  if not query.IsEmpty then
  begin
    Result := true;
  end;

  query.Close;

  { query.Close;
    query.SQL.Clear;
    query.SQL.Add('select * from ' + tabela);
    query.Open;

    for ini := 0 to query.FieldList.Count -1 do
    begin
    if UpperCase(NomeCampo) = UpperCase(query.FieldList[ini].FieldName) then
    begin
    Result := true;
    break;
    end;
    end;

    query.Close;
    if funcoes.Contido(UpperCase(NomeCampo),UpperCase(texto)) then
    begin
    dm.IBselect.Close;
    Result := true;
    end
    else
    begin
    dm.IBselect.Close;
    Result := false;
    end; }
end;

procedure TForm1.testaNFe();
var
  arq: TStringList;
begin
  emitNFe := false;

  if DirectoryExists(caminhoComBarraNoFinal + 'NFE\EMIT\') then
  begin
    pastanfe := caminhoComBarraNoFinal + 'NFE\EMIT\';
    arq := listaArquivos(pastanfe + '*.xml');

    if arq.Count > 0 then
    begin
      emitNFe := true;
    end;
    arq.Free;
  end;

  CAMPO_EXPORTADO_FOI_CRIADO := VerificaCampoTabela('EXPORTADO', 'NFE',
    IBQuery1);

  if not emitNFe then
  begin
    RichEdit1.Lines.Add('*ERRO PC sem Informações de NFe ******');
  end
  else
    RichEdit1.Lines.Add('****** PC com Informações de NFe ******');

  if not CAMPO_EXPORTADO_FOI_CRIADO then
  begin
    RichEdit1.Lines.Add('ERRO CAMPO EXPORTADO na tabela NFe não existe ******');
  end
  else
    RichEdit1.Lines.Add
      ('****** Campo EXPORTADO na tabela NFe Encontrado ******');

  if emitNFe and CAMPO_EXPORTADO_FOI_CRIADO then
    RichEdit1.Lines.Add('PC Pronto para sincronização de NFe')
  else
    RichEdit1.Lines.Add('PC Nao está Pronto para sincronização de NFe');
end;

function TForm1.procuraProdutoNaLista(cod: integer;
  var lista1: TStringList): integer;
var
  i, f: integer;
begin
  Result := -1;
  f := lista1.Count - 1;
  for i := 0 to f do
  begin
    if StrToIntDef(lista1.Names[i], 0) = cod then
    begin
      Result := i;
      exit;
    end;
  end;

end;

function TForm1.sincronizaCEST(): boolean;
var
  ini, fim, atu: integer;
begin
  if bdPronto = false then
    exit;
  if conectaBD_Servidor = false then
    exit;

  If not verSeExisteTabela('NCM_CEST', IBQueryServer1) then begin
    RichEdit1.Lines.Add
      ('ERRO: Tabela Cest no Servidor Não Existe! Atualize o ControlW no Servidor');
    exit;
  end;

  If verSeExisteTabela('NCM_CEST', IBQuery1) then
  begin
    RichEdit1.Lines.Add('Tabela Cest OK Local');
    exit;
  end
  else
  begin
    IBQuery1.Close;
    IBQuery1.SQL.Text := 'CREATE TABLE NCM_CEST (' +
      'NCM   VARCHAR(10) DEFAULT '''' NOT NULL,' +
      'CEST  VARCHAR(10) DEFAULT '''' NOT NULL)';
    IBQuery1.ExecSQL;
    IBQuery1.Transaction.Commit;

    IBQuery1.Close;
    IBQuery1.SQL.Text := 'alter table NCM_CEST ' + 'add constraint PK_NCM_CEST '
      + 'primary key (NCM, CEST)';
    IBQuery1.ExecSQL;
    IBQuery1.Transaction.Commit;
  end;

  IBQueryServer1.Close;
  IBQueryServer1.SQL.Text := 'select ncm, cest from NCM_CEST';

  try
    IBQueryServer1.Open;
  except
    on e: exception do
    begin
      RichEdit1.Lines.Add('Erro 1643: ' + e.Message);
      exit;
    end;
  end;
  IBQueryServer1.FetchAll;

  ini := 0;
  atu := 0;
  fim := IBQueryServer1.RecordCount;

  while not IBQueryServer1.Eof do
  begin
    Application.ProcessMessages;
    ini := ini + 1;

    IBQuery1.Close;
    IBQuery1.SQL.Text :=
      'update or insert into NCM_CEST(ncm, cest) values(:ncm, :cest)';
    IBQuery1.ParamByName('ncm').AsString := IBQueryServer1.fieldbyname
      ('ncm').AsString;
    IBQuery1.ParamByName('cest').AsString := IBQueryServer1.fieldbyname
      ('cest').AsString;

    try
      IBQuery1.ExecSQL;
    except
      on e: exception do
      begin
        RichEdit1.Lines.Add('ERRO: ' + e.Message + ' Linha 1293');
      end;
    end;

    IBQueryServer1.Next;
  end;

  RichEdit1.Lines.Add('Cest Importados: ' + IntToStr(ini));

  if IBQuery1.Transaction.InTransaction then
    IBQuery1.Transaction.Commit;
  IBQueryServer1.Close;
  BD_Servidor.Connected := false;
end;

function TForm1.verSeExisteTabela(nome: String; var query: TIBQuery): boolean;
begin
  Result := false;
  query.Close;
  query.SQL.Clear;
  query.SQL.Add
    ('select rdb$relation_name from rdb$relations where (rdb$system_flag = 0) and (rdb$relation_name = '
    + QuotedStr(nome) + ')');
  query.Open;

  if query.IsEmpty then
    Result := false
  else
    Result := true;

  query.Close;
end;

function TForm1.buscaConfigNaPastaDoControlW1(Const config_name: String;
  gravaVazio: boolean = false): String;
var
  arq: TStringList;
  caminhoEXE_com_barra_no_final: String;
begin
  caminhoEXE_com_barra_no_final := ExtractFileDir(ParamStr(0)) + '\';
  if not FileExists(caminhoEXE_com_barra_no_final + 'CONFIG.DAT') then
  begin
    arq := TStringList.Create;
    arq.SaveToFile(caminhoEXE_com_barra_no_final + 'CONFIG.DAT');
    arq.Free;
  end;

  Result := '';
  arq := TStringList.Create;
  arq.LoadFromFile(caminhoEXE_com_barra_no_final + 'CONFIG.DAT');

  if gravaVazio then
  begin
    if not Contido('pastaMGV5_Balanca', arq.Text) then
    begin
      arq.Add('pastaMGV5_Balanca=');
      arq.SaveToFile(caminhoEXE_com_barra_no_final + 'CONFIG.DAT');
    end;
  end;

  Result := arq.Values[config_name];
  arq.Free;
end;


function TForm1.verificaCstatXML(chaveXML : String) : boolean;
var
 arq : TStringList;
 cstat : String;
begin
  Result := false;
  arq := TStringList.Create;
  try
    arq.LoadFromFile(buscaPastaNFCe(chaveXML) + chaveXML +
    '-nfe.xml');
    cstat := Le_Nodo('cStat', arq.Text);
    if cstat = '' then begin
      IBQuery2.Close;
      IBQuery2.SQL.Text :=
      'update nfce set adic = ''OFF'' where chave = :chave';
      IBQuery2.ParamByName('chave').AsString := chaveXML;
      IBQuery2.ExecSQL;
      IBQuery2.Transaction.Commit;
      RichEdit1.Lines.Add('CHAVE ' + chaveXML + ' MARCADA PARA ENVIO!');
    end
    else Result := true;
  except
    on e:exception do begin
      arq.Free;
      RichEdit1.Lines.Add('Erro: ' + e.Message);
    end;
  end;
end;

function TForm1.sincronizaPromoc(): boolean;
var
  valor, acc: String;
  arq : TStringList;
  cont : Integer;
begin
  Result := false;
  if bdPronto = false then
    exit;

  if conectaBD_Servidor = false then
    exit;

  IBQuery1.Close;
  IBQuery1.SQL.Text := 'select doc, cod, codgru, p_venda, quant, usuario, data, valido, tipo, (doc || cod || p_venda || quant) as soma from promoc1';

  try
    IBQuery1.Open;
  except
    on e:exception do begin
      RichEdit1.Lines.Add('Erro 2281: Atualização Promoc1, Atualize BD neste Terminal com ControlW atualizado!'  + #13 + e.Message);
      exit;
    end;
  end;

  arq := TStringList.Create;
  acc := '-';

  while not IBQuery1.Eof do begin
    arq.Add(IBQuery1.FieldByName('soma').AsString + '=X');
    IBQuery1.Next;
  end;

  IBQueryServer1.Close;
  IBQueryServer1.SQL.Text := 'select doc, cod, codgru, p_venda, quant, usuario, data, valido, tipo, (doc || cod || p_venda || quant) as soma from promoc1';
  try
    IBQueryServer1.Open;
  except
    on e: exception do
    begin
      RichEdit1.Lines.Add('Erro lin 454: ' + e.Message);
      exit;
    end;
  end;

  cont := 0;

  while not IBQueryServer1.Eof do begin
    acc := acc + IBQueryServer1.FieldByName('doc').AsString + '-';
    //ShowMessage(arq.GetText + #13 + #13 +  IBQueryServer1.FieldByName('soma').AsString + #13 + #13 +
    //'1='+arq.Values[IBQueryServer1.FieldByName('soma').AsString]);

    if arq.Values[IBQueryServer1.FieldByName('soma').AsString] = '' then begin
      IBQuery1.Close;
      IBQuery1.SQL.Text := 'update or insert into promoc1(doc, cod, codgru, p_venda, quant, usuario, data, valido, tipo)'+
      '  values(:doc, :cod, :codgru, :p_venda, :quant, :usuario, :data, :valido, :tipo) matching(doc)';
      IBQuery1.ParamByName('doc').AsString     := IBQueryServer1.FieldByName('doc').AsString;
      IBQuery1.ParamByName('cod').AsString     := IBQueryServer1.FieldByName('cod').AsString;
      IBQuery1.ParamByName('codgru').AsString  := IBQueryServer1.FieldByName('codgru').AsString;
      IBQuery1.ParamByName('p_venda').AsCurrency := IBQueryServer1.FieldByName('p_venda').AsCurrency;
      IBQuery1.ParamByName('quant').AsCurrency   := IBQueryServer1.FieldByName('quant').AsCurrency;
      IBQuery1.ParamByName('usuario').AsString := IBQueryServer1.FieldByName('usuario').AsString;
      IBQuery1.ParamByName('data').AsDate    := IBQueryServer1.FieldByName('data').AsDateTime;
      IBQuery1.ParamByName('valido').AsDate  := IBQueryServer1.FieldByName('valido').AsDateTime;
      IBQuery1.ParamByName('tipo').AsString    := IBQueryServer1.FieldByName('tipo').AsString;
      IBQuery1.ExecSQL;

      cont := cont + 1;
    end;

    IBQueryServer1.Next;
  end;

  if IBQuery1.Transaction.InTransaction then IBQuery1.Transaction.Commit;

  IBQuery1.Close;
  IBQuery1.SQL.Text := 'select * from promoc1';
  IBQuery1.Open;

  while not IBQuery1.Eof do begin
    if Contido('-' + IBQuery1.FieldByName('doc').AsString + '-', acc) = false then begin
      IBQuery2.Close;
      IBQuery2.SQL.Text := 'delete from promoc1 where doc = :doc';
      IBQuery2.ParamByName('doc').AsInteger := IBQuery1.FieldByName('doc').AsInteger;
      IBQuery2.ExecSQL;
    end;

    IBQuery1.Next;
  end;


  if IBQuery2.Transaction.InTransaction then IBQuery2.Transaction.Commit;

  RichEdit1.Lines.Add('Tabela Promoc1: ' + IntToStr(cont) + ' Registros Sincronizados');
  arq.Free;

  IBQueryServer1.Close;
  BD_Servidor.Connected := false;
end;


procedure TForm1.VerificaXMLS_XX();
var
  XMLnEncontrado, ini, atu, fim : integer;
begin
  IBQuery1.Close;
    IBQuery1.SQL.Text :=
      'select chave, nota from nfce where ((adic <> ''OFF'')  and (exportado = 0)  and (substring(chave from 23 for 3) = :serie)) ';
    IBQuery1.ParamByName('serie').AsString := strzero(getSerieNFCe, 3);
    IBQuery1.Open;
    IBQuery1.FetchAll;


    ini := 0;
    atu := 0;
    XMLnEncontrado := 0;
    fim := IBQuery1.RecordCount;

    while not IBQuery1.Eof do begin
      Application.ProcessMessages;
      ini := ini + 1;

      if FileExists(buscaPastaNFCe(IBQuery1.fieldbyname('chave').AsString) +
        IBQuery1.fieldbyname('chave').AsString + '-nfe.xml') then
      begin
        if verificaCstatXML(IBQuery1.fieldbyname('chave').AsString) then begin
          IBQuery2.Close;
          IBQuery2.SQL.Text := 'update nfce set exportado = 1 where chave = :chave';
          IBQuery2.ParamByName('chave').AsString := IBQuery1.fieldbyname('chave').AsString;
          IBQuery2.ExecSQL;
          IBQuery2.Transaction.Commit;
        end
        else exit;
      end
      else begin
        XMLnEncontrado := XMLnEncontrado + 1;
        RichEdit1.Lines.Add('XML Não Encontrado: ');
         RichEdit1.Lines.Add(buscaPastaNFCe(IBQuery1.fieldbyname('chave').AsString) +
        IBQuery1.fieldbyname('chave').AsString + '-nfe.xml');
      end;

      IBQuery1.Next;
    end;

    if ini > 0 then
    begin
      RichEdit1.Lines.Add('NFCes Verificadas: ' + strzero(ini, 3) + ' Nota: ' +
        IBQuery1.fieldbyname('nota').AsString + #13 + 'XML Nao Encontrados: ' +
        IntToStr(XMLnEncontrado));
      if IBQuery2.Transaction.InTransaction then
        IBQuery2.Transaction.Commit;
    end;

    //Result := true;
    if bdPronto = false then begin
      exit;
    end;
end;

function TForm1.ProcessExists(exeFileName: string): Boolean;
var
  ContinueLoop: BOOL;
  FSnapshotHandle: THandle;
  FProcessEntry32: TProcessEntry32;
  i : integer;
begin
  i := 0;
  FSnapshotHandle := CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
  FProcessEntry32.dwSize := SizeOf(FProcessEntry32);
  ContinueLoop := Process32First(FSnapshotHandle, FProcessEntry32);
  Result := False;
  while Integer(ContinueLoop) <> 0 do
  begin
    if ((UpperCase(ExtractFileName(FProcessEntry32.szExeFile)) =
      UpperCase(ExeFileName)) or (UpperCase(FProcessEntry32.szExeFile) =
      UpperCase(ExeFileName))) then
    begin
      Result := True;
      i      := i + 1;
    end;
    ContinueLoop := Process32Next(FSnapshotHandle, FProcessEntry32);
  end;
  CloseHandle(FSnapshotHandle);

  if i >= 2 then Result := true
    else Result := false;
end;

function TForm1.verificaNFCeNovo(dataIni: String = ''; DataFim: String = '';
      sped: boolean = False): boolean;
var
  arq: tstringList;
  semProtocolo, pulos, erro, acc, puloInutilizado : String;
  cont, serie, fi, i: integer;
begin
  RichEdit1.Lines.Add('Verificando Erros em NFCe, Aguarde...');

  ibquery1.Close;
  ibquery1.SQL.text := 'select * from nfce where chave = '''' ';
  ibquery1.Open;
  ibquery1.FetchAll;

  if not ibquery1.IsEmpty then begin
    i := ibquery1.RecordCount;
    ibquery1.Close;
    ibquery1.SQL.text := 'delete from nfce where trim(chave) = '''' ';
    ibquery1.ExecSQL;
    ibquery1.Transaction.Commit;
  end;

  ibquery1.Close;
  ibquery1.SQL.text := 'select count(*) as quant from nfce where ((adic = ''OFF'') and (substring(chave from 23 for 3) = :serie)) and tentativa >= 20';
  IBQuery1.ParamByName('serie').AsString := strzero(getSerieNFCe, 3);
  ibquery1.Open;
  ibquery1.FetchAll;

  if not ibquery1.IsEmpty then begin
    i := IBQuery1.FieldByName('quant').AsInteger;
    if i > 0 then begin
      ibquery1.Close;
      ibquery1.SQL.text := 'update nfce set tentativa = 0 where tentativa >= 20 ';
      ibquery1.ExecSQL;
      ibquery1.Transaction.Commit;

      RichEdit1.Lines.Add(IntToStr(i) +' NFCes Marcadas apra Envio...');
      try
       SendPostDataMensagem(form72.IdHTTP1,IntToStr(i) +' NFCes Marcadas apra Envio...', 'verificaNFCeNovo 2565 DAVNFCe.exe', '-3', NomedoComputador);
      finally
      end;
    end;
  end;

  ibquery1.Close;
  ibquery1.SQL.text :=
    'select nota,chave, cast(substring(chave from 26 for 9) as integer) as nnf, cast(substring(chave from 23 for 3) as integer)'
    + ' as serie from nfce where chave <> '''' and data >= :ini and data <= :fim '
    + 'order by cast(substring(chave from 23 for 3) as integer),cast(substring(chave from 26 for 9) as integer)';
  ibquery1.ParamByName('ini').AsDate := StrToDate(dataIni);
  ibquery1.ParamByName('fim').AsDate := StrToDate(DataFim);
  ibquery1.Open;
  ibquery1.FetchAll;

  semProtocolo := '';
  acc := '';
  cont := 0;
  serie := 99999;
  i := 0;
  puloInutilizado := '';

  fi := ibquery1.RecordCount;
  arq := tstringList.Create;

  while not ibquery1.Eof do
  begin
    i := i + 1;
    if serie <> ibquery1.FieldByName('serie').AsInteger then begin
      if serie <> 99999 then begin
        try
          acc := acc + pulos + semProtocolo;
          RichEdit1.Lines.Add('Saltos NNF: ' + pulos);
          RichEdit1.Lines.Add('Sem Protocolo :');
          RichEdit1.Lines.Add(semProtocolo);
        except
          on e: exception do
          begin
            RichEdit1.Lines.Add(e.Message + #13 + semProtocolo);
          end;
        end;

        pulos := '';
        semProtocolo := '';
      end;

      serie := ibquery1.FieldByName('serie').AsInteger;
      cont  := ibquery1.FieldByName('nnf').AsInteger;
    end;

    while true do begin
      if ibquery1.Eof then break;
      if cont <> ibquery1.FieldByName('nnf').AsInteger then begin
        erro := '';

        IBQuery2.Close;
        IBQuery2.SQL.text :=
          'select chave, data from nfce where substring(chave from 23 for 3) = :serie and substring(chave from 26 for 9) = :nnf';
        IBQuery2.ParamByName('serie').AsString := STRZERO(serie, 3);
        IBQuery2.ParamByName('nnf').AsString  := STRZERO(cont, 9);
        IBQuery2.Open;

        if IBQuery2.IsEmpty then begin
          IBQuery2.Close;
          IBQuery2.SQL.text :=
          'select * from INUTILIZACAO where inicio <= '+IntToStr(cont)+' and'+
          ' fim >= '+IntToStr(cont)+' and serie = '+IntToStr(serie);
          IBQuery2.Open;
          IBQuery2.FetchAll;

          if IBQuery2.IsEmpty = false then begin
            erro            := '9:Essa Numeração já se Encontra Inutilizada No BD!';
            puloInutilizado := puloInutilizado + IntToStr(cont)+ '-Inutilizado ' + FormatDateTime('dd/mm/yyyy',IBQuery2.FieldByName('data').AsDateTime) + #13;
          end
          else begin
            if adicionaNFCeNaoEncontrada(IntToStr(cont), IntToStr(serie)) = false then begin
              erro := '|1|'+IntToStr(cont)+'|Não Existe Essa Numeração No BD!|';
              acc := acc + IntToStr(cont) + ' - ';
              pulos := pulos + IntToStr(cont) + ' - ';
            end;
          end;
        end //if IBQuery2.IsEmpty then begin
        else begin
          erro := '2: NFCe Encontrada no dia ' + FormatDateTime('dd/mm/yy', IBQuery2.FieldByName('data').AsDateTime);
        end;
        IBQuery2.Close;
      end
      else break;

      if cont < IBQuery1.FieldByName('nnf').AsInteger then
        cont := cont + 1
      else

        IBQuery1.Next;
    end;

    if FileExists(buscaPastaNFCe(IBQuery1.FieldByName('chave').AsString) +
      IBQuery1.FieldByName('chave').AsString + '-nfe.xml') then
    begin
      try
        arq.LoadFromFile(buscaPastaNFCe(IBQuery1.FieldByName('chave')
          .AsString) + IBQuery1.FieldByName('chave').AsString + '-nfe.xml');

        if Le_Nodo('cStat', arq.text) = '' then begin
          RichEdit1.Lines.Add('Sem Protocolo: '+ IBQuery1.FieldByName('chave').AsString);

          IBQuery2.Close;
          IBQuery2.SQL.Text := 'update nfce set adic = ''OFF'', exportado = 0 where chave = :chave';
          IBQuery2.ParamByName('chave').AsString := IBQuery1.FieldByName('chave').AsString;
          IBQuery2.ExecSQL;
        end;

        arq.Clear;
      except
        on e: exception do
        begin
          RichEdit1.Lines.Add('erro2623: ' +e.Message + #13 + IBQuery1.FieldByName('chave')
            .AsString);
        end;
      end;
    end
    else
    begin
      semProtocolo := semProtocolo + ' XML Nao Encontrado: ' +
        IBQuery1.FieldByName('chave').AsString + #13#10;
      acc := acc + ' XML Nao Encontrado: ' + IBQuery1.FieldByName('chave')
        .AsString + #13#10;
    end;

    cont := cont + 1;
    IBQuery1.Next;
  end;

  if trim(pulos) <> '' then begin
    RichEdit1.Lines.Add('Saltos NNF: ' + pulos);
    RichEdit1.Lines.Add('Inserindo Notificação Remota...');
    try
      if SendPostDataMensagem(form72.IdHTTP1, 'Saltos NNF: ' + pulos, 'verificaNFCeNovo 2661 DAVNFCe.exe', '-1', NomedoComputador) then RichEdit1.Lines.Add('Notificação Inserida!'+ #13)
        else RichEdit1.Lines.Add('Erro No Envio da Notificação!' + #13);
    finally
    end;
  end;

  if IBQuery2.Transaction.InTransaction then IBQuery2.Transaction.Commit;

  if trim(semProtocolo) <> '' then begin
    RichEdit1.Lines.Add('Sem Protocolo :');
    RichEdit1.Lines.Add(semProtocolo);
  end;

  pulos := '';
  semProtocolo := '';

  Result := true;

  if acc <> '' then
  begin
    Result := False;
  end;
end;

function TForm1.adicionaNFCeNaoEncontrada(num, ser : String) : boolean;
var
  tmp : String;
  arq : TStringList;
begin
  Result := false;
  tmp := achaXML_NFCePeloNumero(num, ser);
  if tmp = '' then begin
    RichEdit1.Lines.Add('NFCe Não Encontrada: Nº ' + num + ' Série: ' + ser );
    exit;
  end;

  arq := TStringList.Create;
  arq.LoadFromFile(tmp);

  IBQuery2.Close;
  IBQuery2.SQL.Text := 'insert into nfce(chave,nota, data, adic) values(:chave, :nota, :data, :adic)';
  IBQuery2.ParamByName('chave').AsString := copy(ExtractFileName(tmp), 1, 44);
  IBQuery2.ParamByName('nota').AsString  := copy(IBQuery2.ParamByName('chave').AsString, 37, 7);
  IBQuery2.ParamByName('data').AsDate    := StrToDate(dataInglesToBrasil(leftstr(Le_Nodo('dhEmi', arq.Text), 10)));
  IBQuery2.ParamByName('adic').AsString  := 'OFF';
  IBQuery2.ExecSQL;
  IBQuery2.Transaction.Commit;
  arq.free;

  Result := true;
  RichEdit1.Lines.Add('NFCe ' + copy(ExtractFileName(tmp), 1, 44) + ' Adicionada com Sucesso!');
  try
   SendPostDataMensagem(form72.IdHTTP1, 'NFCe ' + copy(ExtractFileName(tmp), 1, 44) + ' Adicionada com Sucesso!', 'adicionaNFCeNaoEncontrada 2716 DAVNFCe.exe', '-2', NomedoComputador);
  finally
  end;
end;


end.
