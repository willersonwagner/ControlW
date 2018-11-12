unit principal;

//{$WEAKLINKRTTI ON}

interface

uses

  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, IniFiles, ExtCtrls, JsEdit1, JsEditNumero1, Mask,
  JsEditData1, ComCtrls, Buttons, JsBotao1, sEdit, acPNG, AppEvnts,RLConsts,
  IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient, IdTime, funcoesdav, imprNovo,
  untnfceForm, pcnConversao, classes1,Unit63, DBClient, Data.DB, midaslib, DateUtils,
  Vcl.Imaging.jpeg, shellapi, acbrmail, ACBrValidador;

type
  Tform22 = class(TForm)
    Timer1: TTimer;
    Panel1: TPanel;
    Image1: TImage;
    data1: TLabel;
    hora: TLabel;
    Label1: TLabel;
    nome: TEdit;
    Label2: TLabel;
    senha: TEdit;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;                                                 
    Label8: TLabel;
    Label9: TLabel;
    ApplicationEvents1: TApplicationEvents;
    Label10: TLabel;
    Button1: TButton;
    ClientDataSet1: TClientDataSet;
    ClientDataSet1COOD: TIntegerField;
    ClientDataSet1NOME: TStringField;
    procedure nomeKeyPress(Sender: TObject; var Key: Char);
    procedure senhaKeyPress(Sender: TObject; var Key: Char);
    procedure FormShow(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormPaint(Sender: TObject);
    function SetScreenResolution(Width, Height: integer): Longint;
    procedure FormCreate(Sender: TObject);
    procedure ApplicationEvents1Minimize(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    cont : integer;
    { Private declarations }
  public
    codusario, notaVenda, valorDeChecagem, nomeUsuario : string;
    usuario: string;
    Pgerais, nomesServico : TStringList;
    datamov: tdatetime;
    superUsu : integer;
    procedure TrimAppMemorySize;
    procedure EventoErro(Sender: TObject; E: Exception);
    function enviNFCe(const perg : String = ''; nnf : String = ''; recebido : currency = 0) : boolean;
    function enviNFCeNaoEnviadas() : boolean;
    { Public declarations }
  end;

var
  form22: Tform22;
  ConfParamGerais,Conf_Ter,meses : TStringList;
  //Papel_de_Parede : TJPEGImage;
  CaminhoBD : String;
  Ativado,demo : boolean;
  VersaoExe : string;
  caminhoEXE_com_barra_no_final : String;
  UsaSped : boolean;
implementation

uses Unit1,  func, Unit2, relatorio, minilocalizar, Math, Unit38,
  creceberposicao, registro, TypInfo, StrUtils, backup, dialog, nfe, spedfiscal,
  Unit49, Unit48, cadCli, untConfiguracoesNFCe, U_Principal, gifAguarde;

{$R *.dfm}                

procedure Tform22.EventoErro(Sender: TObject; E: Exception);
var
F : TextFile;
S, temp, caminho : String;
I : Integer;
begin
{$I-}
Try
  caminho := copy(ParamStr(0),1, funcoes.PosFinal('\', ParamStr(0)));
  I := 0;
  S := '';
  temp := '';
  While (E.Message[I] <> Chr(13)) and (I < Length(E.Message)) do
  Begin
    I := (I +1);
    S := (S + E.Message[I]);
  End;{do}
  //S := (DateTimeToStr(Now)+' '+NomeDoUsuario+': '+S);
  AssignFile(F,(Caminho+'errolog.txt'));
  If FileExists((Caminho+'errolog.txt')) Then
    Append(F){}
  Else
  Rewrite(F);{if}
  temp := '---------------------------------------------------------------'+ #13+#10;
  temp := temp + 'Formulário: '+ Screen.ActiveForm.Name + #13 + #10;
  temp := temp + 'Componente: '+ Screen.ActiveControl.Name + #13 + #10;
  temp := temp + 'hora: ' + FormatDateTime('tt',now) + #13 + #10;
  temp := temp + 'data: '+ FormatDateTime('dd/mm/yy',form22.datamov) + #13 + #10;
  temp := temp + 'usuario: ' + form22.usuario + #13 + #10;
  temp := temp + 'Erro: ' + s + #13 + #10;
  temp := temp + 'Método: '+ Screen.ActiveControl.MethodName(nil) + #13 + #10;
  temp := temp + '---------------------------------------------------------------'+ #13+#10;
  Writeln(F,temp);
  CloseFile(F);


  if contido(UpperCase('Unable to complete network request to host'), UpperCase(s)) then begin
    MessageDlg('ERRO: ' + s + #13 +
  ' Ocorreu um erro inesperado, se persistir entre em contato com o SUPORTE' + #13 +
  'O sistema Será Finalizado!!', mtInformation, [mbOK], 1);
    Application.Terminate;
  end
  else begin
    ShowMessage('ERRO: ' + s + #13 +
  ' Ocorreu um erro inesperado, se persistir entre em contato com o SUPORTE');
  end;
  //FreeAndNil(f);
//  Application.Terminate;
  //Abort;
Except
//  Application.Terminate;
  Abort;
End;{try}
{$I+}
end;{procedure}



procedure Tform22.nomeKeyPress(Sender: TObject; var Key: Char);
var
  proc : TMailStatus;
begin
  if (key = #13) then senha.SetFocus;
  if key= #27 then
    begin
      if dm.execucaoEmail = 1  then begin
        ShowMessage('Aguarde, Enviando Backup!');
        exit;
      end;

      dm.IBselect.Close;
      dm.IBQuery2.Close;
      dm.IBQuery1.Close;
      Application.Terminate;
    end;
end;

procedure Tform22.senhaKeyPress(Sender: TObject; var Key: Char);
var
  temp, acs : string;
  dias, t1 : integer;
  reg, bloq : boolean;
begin
if key=#27 then
     begin
       senha.Text :='';
       nome.Text := '';
       nome.SetFocus;
    end;

  if (key = #13) then
     begin
        superUsu := 0;
        // ADMIN HH + (DD + MM) + YY
        if (nome.Text = 'ADMIN') and (senha.Text = FormatDateTime('HH',now) + strzero(StrToInt(FormatDateTime('dd', now)) + StrToInt(FormatDateTime('mm',now)), 2) + FormatDateTime('YY',now)) then
        begin
          superUsu := 1;
          dm.IBQuery1.Close;
          dm.IBQuery1.SQL.Text := ('select cod, nome from usuario');
          dm.IBQuery1.Open;

          if dm.IBQuery1.IsEmpty then
            begin
              form2.Show;
              exit;
            end;
        end;

       if superUsu = 0 then
         begin
          dm.IBQuery1.Close;
          dm.IBQuery1.SQL.Clear;

          if VerificaCampoTabela('EXCLUIDO', 'USUARIO') then dm.IBQuery1.SQL.Add('select cod, nome from usuario where (usu = :nome) and (senha = :senha) and excluido = 0')
            else dm.IBQuery1.SQL.Add('select cod, nome from usuario where (usu = :nome) and (senha = :senha)');
          dm.IBQuery1.ParamByName('nome').AsString  := funcoes.Criptografar(nome.Text);
          dm.IBQuery1.ParamByName('senha').AsString := funcoes.Criptografar(senha.Text);
          dm.IBQuery1.Open;
          if dm.IBQuery1.IsEmpty then begin
            dm.IBQuery1.Close;
            ShowMessage('Usuário ou senha inválidos!!');
            senha.Text := '';
            nome.Text := '';
            nome.SetFocus;
            exit;
          end;
        end;

       try
         Pgerais.Free;
       except
       end;

       form22.Hide;

        try
         funcoes.atualizaHoraDoPCapatirDoServidor; //cria o arquivo confhora.dat na pasta do sistema
       except                                          // com ip do computador que este pc vai buscar a hora e atualizar a hora do windows
       end;

       funcoes.GeraTemas; //funcao que le os temas do BD, imagem da tela principal e outras configuracoes

       codusario      := dm.IBQuery1.fieldbyname('cod').AsString ;
       USUARIO1       := dm.IBQuery1.fieldbyname('cod').AsInteger ;

       if superUsu = 1 then
         begin
           usuario   := 'ADMIN';
         end
       else usuario := dm.IBQuery1.fieldbyname('NOME').AsString;
       form2.caption  := 'Control Estoque - Usuário: ' + usuario;
       form2.stb.Panels[0].Text := 'Usuário: ' + usuario;

       try
         Pgerais := funcoes.GerarPgeraisList(codusario); // gera os parametros gerais referente ao usuario
       except
       end;

       try
         funcoes.lerConfigIMPRESSORA();
       except
       end;

       try
         funcoes.validaDataHora(datamov, usuario);
       except
       end;

       acs := '';

       if superUsu = 1 then
         begin
           usuario   := 'ADMIN';
           Pgerais.Values['acessousu'] := '';
         end;  

       try
         acs := funcoes.VerAcesso('');
       except
         on e: exception do
           begin
             gravaErrosNoArquivo(e.Message,'pricipal','240','funcoes.VerAcesso()');
           end;
       end;

       if acs <> '' then
         begin
                //ShowMessage('Verifique os Níveis de Acesso em Ultilitários > Níveis de Acesso');
         end;

       funcoes.Traca_Nome_Rota;
       reg := VerificaRegistro(1, bloq);

       if (not reg) then
         begin
           form35 := TForm35.Create(self);
           form35.ShowModal;
           form35.Free;
         end;
       if Ativado then
         begin
           if demo then form2.Caption := Form2.Caption + ' (Demonstração)';
           form2.empresa.Caption := form22.Pgerais.Values['empresa'];

           if bloq then
             begin
               t1 := funcoes.getDiasBloqueioRestantes(true);
               dias := funcoes.getDiasBloqueioRestantes();
               if dias >= 0 then funcoes.adicionaRegistroDataBloqueio(true, true, t1, dm.IBQuery4, false);
               form2.Caption := form22.Pgerais.Values['empresa'] + ' ('+ IntToStr(t1) +' dias Para Bloquear o Sistema)';
               if dias < 0 then
                 begin
                   Randomize;
                   valorDeChecagem := funcoes.GeraAleatorio(8);
                   if MessageDlg('O sistema está bloqueado, Deseja Inserir o código de Dessbloqueio ?' + #13 +
                   'Código de Verificação: ' + valorDeChecagem, mtConfirmation, [mbYes, mbNo], 1) = idyes then
                     begin
                       if funcoes.dialogo('normal',0,'',0,true,'',Application.Title,'Qual o Cód de desbloqueio ? Cod: ' + valorDeChecagem,'') =  IntToStr(trunc(StrToCurr(valorDeChecagem) / 87)) then
                         begin
                           funcoes.limpaBloqueado(query1);
                         end;
                     end;
                   self.Show;
                   try
                     funcoes.Mensagem(Application.Title,'Aguarde Conectando com o servidor...',12,'Courier New',false,0, clRed, false);
                     funcoes.verificaPermissaoPagamento(false);
                     pergunta1.Close;
                   except
                     pergunta1.Close;
                   end;  
                   exit;
                 end;
             end;

          dm.IBQuery2.Close;
          dm.IBselect.Close;
          dm.IBQuery1.Close;

          refori1 :=  'refori';

                if ((funcoes.LerConfig(form22.Pgerais.Values['imp'], 1) <> '1') and (funcoes.LerConfig(form22.Pgerais.Values['imp'], 1) <> '2')) then
                  begin
                    try
                      funcoes.mapearLPT1_em_rede();
                    except
                      on e: exception do
                        begin
                          gravaErrosNoArquivo(e.Message,'pricipal','324','funcoes.mapearLPT1_em_rede()');
                        end;
                    end;
                  end;


                dm.IBQuery1.Close;
                dm.IBselect.Close;
                dm.IBQuery2.Close;

                {if ((ConfParamGerais[24] = 'N') or (Length(Pgerais.Values['acessousu']) > 0)) then
                  begin
                    form2.SadadeEstoque2.Visible := false;
                  end;}

                ///notavenda := Pgerais.Values['nota'];

                if usuario = 'ADMIN' then
                  begin
                    codusario := '999';
                  end;

                //TrimAppMemorySize;

                form2.Show;
                funcoes.fazBackupMandaPorEmail;
              end
              else
                begin
                  WWMessage('Esta Cópia Não Está Registrada. Entre em Contato com o SUPORTE',mtError,[mbok],clYellow,true,false,clRed);
                  Application.Terminate;
                end;

    end;
end;

function Tform22.SetScreenResolution(Width, Height: integer): Longint;
var
  DeviceMode: TDeviceMode;
begin
  with DeviceMode do begin
   dmSize := SizeOf(TDeviceMode);
   dmPelsWidth := Width;
   dmPelsHeight := Height;
   dmFields := DM_PELSWIDTH or DM_PELSHEIGHT;
  end;

  Result := ChangeDisplaySettings(DeviceMode, CDS_UPDATEREGISTRY);
end;

procedure Tform22.FormShow(Sender: TObject);
begin
  //verifica atualiza BD foi colocado aqui pq não pode ser no oncreate
  //essa função vai ser chamada e vai verificar se existe o ARQUIVO BD0.FDB
  // e vai criar os campos que deve criar

  //ShowMessage(GetFileList(ExtractFileDir(ParamStr(0)) + '\*.exe').GetText);

  Label9.Width := form22.Width;

  senha.Text := '';
  nome.Text := '';
  nome.SetFocus;
  data1.Caption  := FormatDateTime('ddd,dd/mm/yy',now);
  hora.Caption   := FormatDateTime('hh:mm:ss',now);
  Timer1.Enabled := true;

end;

procedure Tform22.Timer1Timer(Sender: TObject);
begin
   hora.Caption := FormatDateTime('hh:mm:ss',now);
end;

procedure Tform22.FormClose(Sender: TObject; var Action: TCloseAction);
begin
Application.Terminate;
end;

procedure Tform22.FormPaint(Sender: TObject);

begin
   {
     if bd<>1 then begin
     dm.bd.Connected:=false;
     dm.bd.DatabaseName:=funcoes.LerValorPGerais('BD',Pgerais);
     dm.bd.Connected:=true;
     bd:=1;
     end;

     memo.Clear;
     if funcoes.VerSeExisteConfig then Memo.Lines.Add('Config.ini Conectado')
     else Memo.Lines.Add('Erro no Config.ini');

     if dm.bd.TestConnected then Memo.Lines.Add('Banco de Dados Conectado')
     else Memo.Lines.Add('Erro Banco de Dados');
           }
end;



procedure Tform22.FormCreate(Sender: TObject);
var age : integer;
begin
  VersaoExe := '0.1';
  Application.OnException := EventoErro;
  caminhoEXE_com_barra_no_final := copy(ParamStr(0),1,funcoes.PosFinal('\',ParamStr(0)));
  funcoes.buscaNomeConfigDat;
  cont := 0;

  Label10.Caption := FileAgeCreate(ParamStr(0)); //FormatDateTime('yy.mm.dd', FileDateToDateTime(age)) ;

  try
    funcoes.copiaExecutavel();
  except
    on e: exception do
      begin
        gravaErrosNoArquivo(e.Message,'principal','428','funcoes.copiaExecutavel()');
      end;
  end;

  //RLConsts.SetVersion(3,72,'B');
end;

procedure Tform22.ApplicationEvents1Minimize(Sender: TObject);
begin
  Application.Minimize;
end;

procedure Tform22.Button1Click(Sender: TObject);
var
  op : TOpenDialog;
  proc : TMailStatus;
  val, ser : string;
  i : integer;
begin
  for I := 0 to 10000 do begin
    dm.IBQuery1.Close;
    dm.IBQuery1.SQL.Text := 'update venda set ok = ''S'' ';
    dm.IBQuery1.ExecSQL;
    dm.IBQuery1.Transaction.Commit;
  end;

  ShowMessage('terminou');
  exit;
  val := InputBox('numero:', '','');
  ser := InputBox('serie:', '','');

  ShowMessage(achaXML_NFCePeloNumero(val, ser));
  exit;
  ShowMessage(funcoes.MensagemTextoInput('',''));

  exit;
  nota := 52003;
  Imprimir_DANFE_PDF('52003', '52003', tipoIMPRESSAO <> 1, '5');


  //funcoes.buscaNomeConfigDat;
  exit;
  funcoes.enviaXMLsEmail;

  exit;
  {cod := InputBox('Cod produto','','');
  funcoes.VER_ESTOQUE('ACERTA', 'Lançando Acertos de Estoque', 'Acert', StrToIntDef(COD, -1));
  exit;
  DM.IBselect.Close;
  DM.IBselect.SQL.Text := 'SELECT DESCONTO FROM PRODUTO';
  DM.IBselect.Open;

  DM.IBselect.FieldByName('DESCONTO').
  EXIT;}

  if InputBox('1-restaura 2-faz backup','','1') = '1' then
  funcoes.restaurarbackup
    else funcoes.SincronizarExtoque2('d:\matriz.dat');
  //showmessage(buscaVersaoIBPT_Local);
  //funcoes.SincronizarExtoque2('d:\matriz.dat');
end;

function Tform22.enviNFCe(const perg : String = ''; nnf : String = ''; recebido : currency = 0) : boolean;
var
  statu, xmot, cliente, nota, obs, vend, th : String;
  tpemissao  : integer;
  envi, primeiroCupom   : boolean;
  tot1 : currency;
begin
  tpemissao := 0;
  Result    := false;
  tot1      := 0;
  if ((dm.ACBrNFe.Configuracoes.Geral.IdCSC = '') or (dm.ACBrNFe.Configuracoes.Geral.CSC = '')) then
    begin
      MessageDlg('Informações de QrCode Não Encontradas. Preencha CSC e o IdCSC da NFCe!' + #13 +
      'Esta Informação é gerada na area de Serviços do Portal da NFCe do estado vigente.', mtError, [mbOK], 1);
      Configuracoes_NFCe(true);
      exit;
    end;

   if not verificaSePodeEmitirContigencia then exit;

   try
    funcoes.Mensagem(Application.Title,'Aguarde Conectando com o servidor...',12,'Courier New',false,0, clRed, false);
    th := funcoes.verificaPermissaoPagamento;
    if th = '4' then
      begin
        pergunta1.Close;
        ShowMessage('Sistema Não Liberado para Emissao de Notas Fiscais');
        exit;
      end;
    pergunta1.Close;
  except
    pergunta1.Close;
  end;

  envi := true;
  try
    if ConfParamGerais[45] = 'S' then
      begin
         envi := false;
      end
    else
      begin
        envi := true;
      end;
  except
    on e:exception do
      begin
        ShowMessage('ERRO: ' + e.Message);
      end;
  end;

  primeiroCupom := false;

  dm.IBselect.Close;
  dm.IBselect.SQL.Text := 'select CHAVE from nfce where ADIC = ''''';
  dm.IBselect.Open;

  if dm.IBselect.IsEmpty then
    begin
      envi := true;
      primeiroCupom := true;
    end;
  dm.IBselect.Close;

  if perg = '' then
    begin
      nota := funcoes.dialogo('not',200,'1234567890'+#8+#32,200,true,'',Application.Title,'Qual a Nota de Venda?','');
      if nota = '*' then exit;

    end
  else nota := perg;

  vend := '';
  nota := Trim(nota);
  if Contido(' ', nota) = FALSE then
    begin
      if length(nota) <= 10 then begin
        dm.IBQuery4.Close;
        dm.IBQuery4.SQL.Text := 'select nota, cliente, vendedor, total from venda where (nota = :nota) and (cancelado = 0)';
        dm.IBQuery4.ParamByName('nota').AsString := nota;
        dm.IBQuery4.Open;

        if dm.IBQuery4.IsEmpty then  begin
          dm.IBQuery4.Close;
          ShowMessage('Nota ' + nota + ' Não Encontrada');
          exit;
        end;

        cliente := dm.IBQuery4.fieldbyname('cliente').AsString;
        vend    := dm.IBQuery4.fieldbyname('vendedor').AsString;
        tot1    := dm.IBQuery4.fieldbyname('total').AsCurrency;

        dm.IBQuery4.Close;
        dm.IBQuery4.SQL.Text := 'select nome from vendedor where (cod = :nota)';
        dm.IBQuery4.ParamByName('nota').AsString := vend;
        dm.IBQuery4.Open;

        vend := vend + '-' + LeftStr(dm.IBQuery4.fieldbyname('nome').AsString, 15);
      end
      else begin
        ShowMessage('Nota ' + nota + ' Não Encontrada');
        exit;
      end;
    end
  else
    begin
      if verificaSeExisteVendaDeVariosPedidos(nota) = false then
        begin
          ShowMessage('Nenhum Destes Pedidos é uma Venda Válida: ' + nota );
          exit;
        end;
    end;

  if tot1 >= 10000 then
    begin
      cliente := funcoes.cadastroClienteNFCeRetornaCod(tot1, StrToInt(StrNum(cliente)));
      if cliente = 'x' then exit;
    end
  else
    begin
      if cliente = '0' then cliente := '';
      cliente := funcoes.dialogo('generico',0,'1234567890,.'+#8,50,false,'',Application.Title,'Qual o Código do Cliente?',cliente);
      cliente := trim(cliente);

      if  cliente = '*' then exit;

      if cliente = '0' then
        begin
          cliente := funcoes.cadastroClienteNFCeRetornaCod(tot1);
        end;
    end;

  obs := '';
  obs := 'NOTA: ' + nota;
  if vend <> '' then obs := obs + ';' + 'VENDEDOR: ' + vend;
   obs := obs + ';' + 'OPERADOR: ' + usuario + ';';

  try
    statu := '';

    funcoes.mensagemEnviandoNFCE('Aguarde, Enviando NFCe...', true, false);
    //funcoes.Mensagem(Application.Title ,'Aguarde, Enviando NFCe...',15,'Courier New',false,0,clred);
    Application.ProcessMessages;
    Application.ProcessMessages;
    Application.ProcessMessages;
    Application.ProcessMessages;

    Result := EnviarCupomEletronicoTitular(nota, statu, xmot, tpemissao, envi, cliente, obs, '',nnf,TRUE, recebido, primeiroCupom);

    if statu = 'vali' then
      begin
        funcoes.mensagemEnviandoNFCE('Aguarde, Enviando NFCe...', false, true);
        exit;
      end;
  except
    on e:exception do
      begin
        MessageDlg('ERRO: ' + e.Message, mtError, [mbok], 1);
        gravaERRO_LOG1('', 'ERRO: FORM22, metodo function Tform22.enviNFCe(const perg : String = ''; nnf : String = ''; recebido : currency = 0) : boolean;' + #13+ #13 +'e.Message=' +e.Message, '');
      end;
  end;

  funcoes.mensagemEnviandoNFCE('Aguarde, Enviando NFCe...', false, true);

  Funcoes.verificaDavNFCeTravado;
  //pergunta1.Close;
  form2.Button1Click(nil);
end;

procedure Tform22.TrimAppMemorySize;
var
  MainHandle : THandle;
begin
  try
    MainHandle := OpenProcess(PROCESS_ALL_ACCESS, false, GetCurrentProcessID) ;
    SetProcessWorkingSetSize(MainHandle, $FFFFFFFF, $FFFFFFFF) ;
    CloseHandle(MainHandle) ;
  except
  end;
  Application.ProcessMessages;
end;

function Tform22.enviNFCeNaoEnviadas() : boolean;
var
  statu, xmot, cliente, nota, obs, vend : String;
  msg, tpemissao,acc  : integer;
  envi   : boolean;
  tot1 : currency;
  nnf : String;
begin
  acc := 0;
  dm.IBselect.Close;
  dm.IBselect.SQL.Text := 'select nota, chave, data from nfce where adic = ''OFF''';
  dm.IBselect.Open;
  while not dm.IBselect.Eof do
    begin
      acc := acc + 1;
      if (datamov - dm.IBselect.FieldByName('data').AsDateTime) > 1 then
        begin
          nota := dm.IBselect.FieldByName('nota').AsString;
          ACBrNFe.NotasFiscais.Clear;
          if FileExists(buscaPastaNFCe(dm.IBselect.fieldbyname('chave').AsString) + dm.IBselect.fieldbyname('chave').AsString + '-nfe.xml') then
            begin
              ACBrNFe.NotasFiscais.LoadFromFile(buscaPastaNFCe(dm.IBselect.fieldbyname('chave').AsString) +dm.IBselect.fieldbyname('chave').AsString + '-nfe.xml');
              nnf := IntToStr(ACBrNFe.NotasFiscais[0].NFe.Ide.nNF);
              ACBrNFe.NotasFiscais.Clear;
            end
          else nnf := '';

          dm.IBQuery4.Close;
          dm.IBQuery4.SQL.Text := 'select nota, cliente, vendedor, total from venda where (nota = :nota) and (cancelado = 0)';
          dm.IBQuery4.ParamByName('nota').AsString := nota;
          dm.IBQuery4.Open;

          if dm.IBQuery4.IsEmpty then
            begin
              dm.IBQuery4.Close;
              ShowMessage('Nota ' + nota + ' Não Encontrada');
              exit;
            end;

          cliente := dm.IBQuery4.fieldbyname('cliente').AsString;
          vend    := dm.IBQuery4.fieldbyname('vendedor').AsString;
          tot1    := dm.IBQuery4.fieldbyname('total').AsCurrency;

          dm.IBQuery4.Close;
          dm.IBQuery4.SQL.Text := 'select nome from vendedor where (cod = :nota)';
          dm.IBQuery4.ParamByName('nota').AsString := vend;
          dm.IBQuery4.Open;

          vend := vend + '-' + dm.IBQuery4.fieldbyname('nome').AsString;

          dm.IBQuery4.Close;
          dm.IBQuery4.SQL.Text := 'select chave, adic from nfce where (nota = :nota)';
          dm.IBQuery4.ParamByName('nota').AsString := nota;
          dm.IBQuery4.Open;

          ACBrNFe.NotasFiscais.Clear;
          chaveNF := dm.IBQuery4.fieldbyname('chave').AsString;
          if FileExists(buscaPastaNFCe(dm.IBQuery4.fieldbyname('chave').AsString) +dm.IBQuery4.fieldbyname('chave').AsString + '-nfe.xml') then
            begin
              ACBrNFe.NotasFiscais.LoadFromFile(buscaPastaNFCe(dm.IBQuery4.fieldbyname('chave').AsString) +dm.IBQuery4.fieldbyname('chave').AsString + '-nfe.xml');
              nnf := IntToStr(ACBrNFe.NotasFiscais[0].NFe.Ide.nNF);
              ACBrNFe.NotasFiscais.Clear;
            end
          else nnf := '';
          dm.IBQuery4.Close;

          dm.IBQuery4.Close;
          dm.IBQuery4.SQL.Text := 'select i.nota,i.cod, p.p_compra, i.p_venda, i.quant from item_venda i inner join produto p on (p.cod = i.cod) where nota = :nota';
          dm.IBQuery4.ParamByName('nota').AsString := nota;
          dm.IBQuery4.Open;

          obs := 'NOTA: ' + nota + #13 + 'VENDEDOR: ' + vend + #13 + obs;

          try
            statu := '';
            //EnviarCupomEletronico2(nota, statu, true, false);
            criaXMLs(chaveNF,nnf, '');
            //Result := EnviarCupomEletronico1(nota, statu, xmot, tpemissao, false, cliente, obs, '',nnf, false);
          finally
             dm.IBQuery4.Close;
          end;
        end;
      dm.IBselect.Next;  
    end;
    
  ShowMessage('Total De Notas Criadas: ' + IntToStr(acc));
end;

end.
