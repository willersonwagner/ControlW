unit func;

interface

uses controls, windows, forms, Types , messages, ibquery, untDtmMain, classes1, classes,StdCtrls,Dialogs, db,
SysUtils, ExtCtrls, JsEditInteiro1, JsEditNumero1, ComCtrls, dialog, graphics, acbrECF,acbrbal, dbgrids, jsedit1, acbrutil,
gifAguarde, IdTCPConnection, IdTCPClient;

procedure mensagemEnviandoNFCE(const msg : String; abrir, fechar : boolean);
procedure MeuKeyPress1(Sender: TObject; var Key: Char);
FUNCTION MensagemTextoInput(Caption, default: string): string;
function reStartGenerator1(nome : string; Valor : integer; var query : TIBQuery): String;
function criaGeneratorContadorNFCe(serie : String; var query : TIBQuery) : integer;
function VerSeExisteGeneratorPeloNome(Const nome : String; var query : TIBQuery) : boolean;
procedure progresso(label1 : String; ini, fim : integer; novo, fechar : boolean);
procedure setParametrosACBrECF2(var bal : TACBrBAL; var arq : TStringList);
function Arredonda2( valor:currency; decimais:integer; tipo : string = '') : currency;
function ValidaCNPJ(CNPJ: string): Boolean;
function ValidaCPF(sCPF: string): boolean;
function DesCriptografar(wStri: String): String;
function LerConfig(valor:string;posi:integer) : string;
function HexToTColor(sColor : string) : TColor;
procedure setParametrosACBrECF1(var ecf : TACBrECF;var bal : TACBrBAL; var arq : TStringList);
procedure LerParametrosACBrECF1(var arq : TStringList);
function le_codbar(var query : TIBQuery; const codbar, paramGe38 : String; arredon : String = '') : TprodutoVendaCodBar;
function le_codbar1(var query : TIBQuery; const codbar, paramGe38 : String; arredon : String = '') : TprodutoVendaCodBar;
function retornaPos(valor:string;sub:string;posi:integer) : integer;
procedure redimensionaTelaDbgrid(var dbgrid : TDBGrid);
function lerForma(const form : String; const ind : integer) : String;
function checaCodbar(vx_cod : String) : boolean;
FUNCTION DIGEAN(vx_cod : string) : string;
function LerFormPato(index:integer; label1 : string; escSair : boolean) : string;
procedure CtrlResize(var Sender: TForm);
function formataCurrency(const valor : currency) : String ;
procedure FormataCampos(query:Tibquery;qtdCasasDecimais:integer;CampoFormatoDiferente:string;qtd:integer);
function retornaSQL(const sql : String) : String;
function conectaBD() : boolean;
function logar(const usu, senha : String) : Boolean;
function Criptografar(wStri: String): String;
function Arredonda( valor:currency; decimais:integer; tipo : string = '') : currency;
function Arredonda1( valor:currency; decimais:integer; tipo : string = '') : currency;
function ArredondaFinanceiro(Value: Currency; Decimals: integer): Currency;
function ArredondaTrunca(Value: Extended;decimais:integer): Extended;
function ArredondaTrunca1(Value: currency;decimais:integer): Extended;
procedure lerPgerais(var pr : TStringList);
Function ProcuraItemNaLista(var lista : TList; cod1 : integer) : integer;
function Incrementa_Generator(Gen_name : string; valor_incremento : integer) : string;
function StrNum(const entra: string) :  string;
function Contido(substring:string;texto:string):boolean;
function PosFinal(substr:string;Texto:string):integer;
function CompletaOuRepete(const valorParaCompletar:AnsiString;const ValorFinal:AnsiString;valorParaRepetir:string;contadorDeRepeticao:integer):string;
procedure criaPasta(const pasta : String);
procedure ArredondarComponente(Componente: TWinControl; const Radius: SmallInt);
procedure protecaoDeTela();
function GetFileList(const Path: string): TStringList;
function centraliza(valor:string;repetir:string;tamanho:integer):string;
function ContaChar(estring:string;sub:string):string;
function dialogo(tipo:string;maxlengt : integer;ValorEntrada:string;tamanhocampo:integer;obrigatorio1:boolean;trocaletras:string;titulo:string;label1:string;default:string):string;
function dialogoG(tipo:string;maxlengt : integer;ValorEntrada:string;tamanhocampo:integer;obrigatorio1:boolean;trocaletras:string;titulo:string;label1:string;default:string;const Normal : boolean):string;
function busca(var dataset:tibquery;busca:string;retorno:string;campobusca:string;camposdataset:string):string;
function localizar1(titulo:string;tabela:string;campos:string;retorno:string;esconde:string;localizarPor:string;OrdenarPor:string;editLocaliza:boolean;editavel:boolean;deletar:boolean;campoLocate:string;keyLocate: String;tamanho:integer;compnenteAlinhar: TObject):string;
procedure mostraMensagem(const mensagem1 : String;const novo : boolean);
function localizar2(titulo:string;tabela:string;campos:string;retorno:string;esconde:string;localizarPor:string;OrdenarPor:string;editLocaliza:boolean;editavel:boolean;deletar:boolean;campoLocate:string;keyLocate: String;tamanho:integer;compnenteAlinhar: TObject):string;
procedure setqueryFunc();
function procuraForma(var lista : TStringList; const entrada : boolean) : integer;
procedure SetBorder(var comp : TWinControl;AColor: TColor);
procedure setParametrosACBrECF(var ecf : TACBrECF;var bal : TACBrBAL;const indexImpressora, velocidade : integer; const porta, velobal, portabal, tipobal : String);
procedure gravaParametrosACBrECF(const indexImpressora, velocidade : integer; const porta, UsarDLL : String);
procedure LerParametrosACBrECF(var indexImpressora, velocidade : integer; var porta, usaDLL, portaBal, velobal, tipobal, intervalo : String);
function VerificaRegistroPDV(var query : TIBQuery) : boolean;
function StringToInteger(Ent : String) : integer;
function Trunca(const nValor: Currency; const iCasas: Integer): Currency;

var
 Simbolos : array [0..3] of String;
 retornoBusca1 : String;
 query : TIBQuery;
 query1 : TIBQuery;
 b : integer;

const
  simbolos1 : String = 'ABCDEFGHIJLMNOPQRSTUVXZYWK abcdefghijlmnopqrstuvxzywk1234567890-+=_?/.,<>;:)(*&^%$#@!~áäà';
  simbolos2 : String = 'ÂÀ©Øû×ƒçêùÿ5Üø£úñÑªº¿®¬¼ëèïÙýÄÅÉæÆôÁáâäàåíóÇüé¾¶§÷ÎÏ-+ÌÓß¸°¨·¹³²Õµþîì¡«½WDX2U3BHJKMSZDTQ4';

implementation

uses login, Math, protetor, buscaselecao, localizar, mens, StrUtils;

function DesCriptografar(wStri: String): String;
var
  x , posicao            : Integer;
begin
 Result := '';
 for x := 1 to Length(wStri) do
   begin
     posicao := pos(wStri[x], simbolos2);
     Result := Result + simbolos1[posicao];
   end;
end;

function le_codbar(var query : TIBQuery; const codbar, paramGe38 : String; arredon : String = '') : TprodutoVendaCodBar;
var
  _ptot, quanti, ptotCodbar, qtt : currency;
begin
  if arredon = '' then arredon := 'T';
  Result        := TprodutoVendaCodBar.Create;
  Result.preco  := 0;
  Result.precoTemp := 0;
  Result.codbar := LeftStr(trim(codbar), 5);

  query.Close;
  query.SQL.Text := 'select cod, p_venda, nome, codbar from produto where (substring(codbar from 1 for 5) = '+ QuotedStr(Result.codbar)+')';
  query.Open;
  query.FetchAll;

  if query.RecordCount = 0 then
    begin
      Result.codbar := '*';
      query.Close;
      exit;
    end;

  Result.codbar := query.fieldbyname('codbar').AsString;
  Result.preco  := query.fieldbyname('p_venda').AsCurrency;
  query.Close;

  quanti := StrToCurrDef(copy(codbar, 6, 7), 0);
  qtt := quanti;

  if paramGe38 = '2' then
    begin
      Result.precoTemp := (quanti /100);

      Result.quant := ARREDONDA((quanti /100) / Result.preco, 2, arredon);
      quanti := Result.quant; // quanti tem  a quantidade aprox

      while true do
        begin
          _ptot := ARREDONDA(quanti * Result.preco, 2, arredon);//valor aprox
          //ShowMessage(CurrToStr(quanti) + #13 + CurrToStr(_ptot) + #13 + CurrToStr(Result.precoTemp));
          if _PTOT >= Result.precoTemp then break;

          quanti := quanti + 0.0001;
        end;
        
      Result.quant := quanti;
    end
  else
    begin
      Result.quant := (quanti / 1000);
      Result.precoTemp := ARREDONDA(Result.quant * Result.preco, 2, arredon);
    end;
end;

function StringToInteger(Ent : String) : integer;
var
  cont : integer;
  temp : string;
begin
  temp := '';
  Result := 0;
  for cont := 1 to length(ent) do
    begin
      Result := Result + ord(ent[cont]);
    end;
end;

function VerificaRegistroPDV(var query : TIBQuery) : boolean;
var
  ativo, empresa, tmp, temp : string;
  t1 : integer;
begin
  Result := true;
  exit;

  Result := false;
  query.Close;
  query.SQL.Text := ('select empresa, registro, versao from registro');
  query.Open;

  temp := StrNum(query.FieldByName('versao').AsString);
  ativo := '';
  empresa := '';
  empresa := trim(query.FieldByName('empresa').AsString);

  t1 := StringToInteger(empresa);
  t1 := trunc(t1 * 57.3);

  if IntToStr(t1) <> temp then
    begin
      query.Close;
      ShowMessage('Este Sistema Não está registrado, Efetue o Registro para poder continuar utilizando');
      exit;
    end;

  Result := true;
  exit;
{  if (t1 = 0) then
    begin
      exit;
    end;

      if t1 = temp then
        begin
          Result := true;
          Ativado := true;
          demo := false;
        end
      else if temp = trunc(StringToInteger(empresa) / 2) then
        begin
          Result := true;
          Ativado := true;
          demo := true;
          dm.IBselect.Close;
          dm.IBselect.SQL.Clear;
          dm.IBselect.SQL.Add('select dtr from acesso where dtr = :d');
          dm.IBselect.ParamByName('d').AsDateTime := form22.datamov;
          dm.IBselect.Open;

          if dm.IBselect.IsEmpty then
            begin
              dm.IBQuery1.Close;
              dm.IBQuery1.SQL.Clear;
              dm.IBQuery1.SQL.Add('insert into acesso(acesso,dtr) values('+QuotedStr('')+', :d)');
              dm.IBQuery1.ParamByName('d').AsDateTime := form22.datamov;
              dm.IBQuery1.ExecSQL;
              dm.IBQuery1.Transaction.Commit;
            end;
          dm.IBselect.Close;
          dm.IBselect.SQL.Clear;
          dm.IBselect.SQL.Add('select dtr from acesso');
          dm.IBselect.Open;
          dm.IBselect.FetchAll;
          temp := dm.IBselect.RecordCount - 1;
          if temp > 15 then
            begin
              Result := false;
              Ativado := false;
              ShowMessage('Esta Versão de Demonstração Expirou os 15 dias');
            end
          else if temp = 5 then ShowMessage('Falta apenas 10 dias Para está cópia expirar.')
          else if temp >= 10 then ShowMessage('Falta apenas '+ IntToStr(15 - temp) +' dias Para está cópia expirar.');

          dm.IBselect.Close;
          dm.IBQuery1.Close;
        end
      else
        begin
          Result := false;
          Ativado := false;
          demo := false;
        end;
}end;

procedure LerParametrosACBrECF1(var arq : TStringList);
begin
  arq := TStringList.create;
  if not FileExists(ExtractFileDir(ParamStr(0)) + '\ConfECF.ini') then exit;
  arq.LoadFromFile(ExtractFileDir(ParamStr(0)) + '\ConfECF.ini');
end;

procedure LerParametrosACBrECF(var indexImpressora, velocidade : integer; var porta, usaDLL, portaBal, velobal, tipobal, intervalo : String );
var
  arq : TStringList;
begin
  if not FileExists(ExtractFileDir(ParamStr(0)) + '\ConfECF.ini') then exit;

  arq := TStringList.create;
  arq.LoadFromFile(ExtractFileDir(ParamStr(0)) + '\ConfECF.ini');
  indexImpressora  := StrToIntDef(arq.Values['indexImpressora'], 0);
  velocidade       := StrToIntDef(arq.Values['velocidade'], 9600);
  porta            := arq.Values['porta'];
  usaDLL           := arq.Values['usarDLL'];

  portaBal         := arq.Values['portabal'];
  tipobal          := arq.Values['tipoBal'];
  velobal          := arq.Values['velobal'];
  intervalo        := arq.Values['intervalo'];
  arq.Free;
end;

procedure gravaParametrosACBrECF(const indexImpressora, velocidade : integer; const porta, UsarDLL : String);
var
  arq : TStringList;
begin
  arq := TStringList.create;
  arq.Values['indexImpressora'] := IntToStr(indexImpressora);
  arq.Values['velocidade']      := IntToStr(velocidade);
  arq.Values['porta']           := porta;
  arq.Values['usarDLL']         := UsarDLL;
  arq.SaveToFile(ExtractFileDir(ParamStr(0)) + '\ConfECF.ini');
  arq.Free;
end;

procedure setParametrosACBrECF1(var ecf : TACBrECF;var bal : TACBrBAL; var arq : TStringList);
var
  tipobal : String;
  indexImpressora : smallint;
begin
  arq := TStringList.create;
  if not FileExists(ExtractFileDir(ParamStr(0)) + '\ConfECF.ini') then exit;
  arq.LoadFromFile(ExtractFileDir(ParamStr(0)) + '\ConfECF.ini');

  if dtmMain.ACBrBAL1.Ativo then dtmMain.ACBrBAL1.Desativar;

  bal.Porta := arq.Values['portabal'];
  bal.Device.Baud  := StrToIntDef(arq.Values['velobal'], 9600);
  tipobal  := arq.Values['tipoBal'];

  bal.MonitorarBalanca := false;

  if tipobal = '0' then bal.Modelo := balNenhum
  else if tipobal = '1' then bal.Modelo := balDigitron
  else if tipobal = '2' then bal.Modelo := balFilizola
  else if tipobal = '3' then bal.Modelo := balLucasTec
  else if tipobal = '4' then bal.Modelo := balMagellan
  else if tipobal = '5' then bal.Modelo := balMagna
  else if tipobal = '6' then bal.Modelo := balToledo
  else if tipobal = '7' then bal.Modelo := balToledo2180
  else if tipobal = '8' then bal.Modelo := balUrano
  else if tipobal = '8' then bal.Modelo := balUranoPOP;

  try
    //if not bal.Ativo then bal.Ativar;
  except
  end;

  indexImpressora := StrToIntDef(arq.Values['indexImpressora'], 11);

  if      indexImpressora = 0  then ecf.Modelo := ecfBematech
  else if indexImpressora = 1  then ecf.Modelo := ecfDaruma
  else if indexImpressora = 2  then ecf.Modelo := ecfDataRegis
  else if indexImpressora = 3  then ecf.Modelo := ecfECFVirtual
  else if indexImpressora = 4  then ecf.Modelo := ecfEpson
  else if indexImpressora = 5  then ecf.Modelo := ecfEscECF
  else if indexImpressora = 6  then ecf.Modelo := ecfFiscNET
  else if indexImpressora = 7  then ecf.Modelo := ecfICash
  else if indexImpressora = 8  then ecf.Modelo := ecfMecaf
  else if indexImpressora = 9  then ecf.Modelo := ecfNaoFiscal
  else if indexImpressora = 10 then ecf.Modelo := ecfNCR
  else if indexImpressora = 11 then ecf.Modelo := ecfNenhum
  else if indexImpressora = 12 then ecf.Modelo := ecfQuattro
  else if indexImpressora = 13 then ecf.Modelo := ecfSchalter
  else if indexImpressora = 14 then ecf.Modelo := ecfSweda
  else if indexImpressora = 15 then ecf.Modelo := ecfSwedaSTX
  else if indexImpressora = 16 then ecf.Modelo := ecfUrano
  else if indexImpressora = 17 then ecf.Modelo := ecfYanco;

  ecf.Porta                := arq.Values['porta'];
  ecf.Device.Baud          := StrToIntDef(arq.Values['velocidade'], 9600);
  ecf.LinhasEntreCupons    := StrToIntDef(arq.Values['LinhasCupons'], 7);
  if arq.Values['SinalInvertido'] = 'S' then ecf.GavetaSinalInvertido := true
    else ecf.GavetaSinalInvertido := false;
end;

procedure setParametrosACBrECF2(var bal : TACBrBAL; var arq : TStringList);
var
  tipobal : String;
  indexImpressora : smallint;
begin
  arq := TStringList.create;
  if not FileExists(ExtractFileDir(ParamStr(0)) + '\ConfECF.ini') then exit;
  arq.LoadFromFile(ExtractFileDir(ParamStr(0)) + '\ConfECF.ini');

  if dtmMain.ACBrBAL1.Ativo then dtmMain.ACBrBAL1.Desativar;

  bal.Porta := arq.Values['portabal'];
  bal.Device.Baud  := StrToIntDef(arq.Values['velobal'], 9600);
  tipobal  := arq.Values['tipoBal'];

  bal.MonitorarBalanca := false;

  if tipobal = '0' then bal.Modelo := balNenhum
  else if tipobal = '1' then bal.Modelo := balDigitron
  else if tipobal = '2' then bal.Modelo := balFilizola
  else if tipobal = '3' then bal.Modelo := balLucasTec
  else if tipobal = '4' then bal.Modelo := balMagellan
  else if tipobal = '5' then bal.Modelo := balMagna
  else if tipobal = '6' then bal.Modelo := balToledo
  else if tipobal = '7' then bal.Modelo := balToledo2180
  else if tipobal = '8' then bal.Modelo := balUrano
  else if tipobal = '8' then bal.Modelo := balUranoPOP;

  try
    //if not bal.Ativo then bal.Ativar;
  except
  end;

end;



procedure setParametrosACBrECF(var ecf : TACBrECF;var bal : TACBrBAL;const indexImpressora, velocidade : integer; const porta, velobal, portabal, tipobal : String);
begin
  bal.Porta := portabal;
  bal.Device.Baud  := StrToIntDef(velobal, 9600);
  if tipobal = '0' then bal.Modelo := balNenhum
  else if tipobal = '1' then bal.Modelo := balDigitron
  else if tipobal = '2' then bal.Modelo := balFilizola
  else if tipobal = '3' then bal.Modelo := balLucasTec
  else if tipobal = '4' then bal.Modelo := balMagellan
  else if tipobal = '5' then bal.Modelo := balMagna
  else if tipobal = '6' then bal.Modelo := balToledo
  else if tipobal = '7' then bal.Modelo := balToledo2180
  else if tipobal = '8' then bal.Modelo := balUrano
  else if tipobal = '8' then bal.Modelo := balUranoPOP;

  if      indexImpressora = 0  then ecf.Modelo := ecfBematech
  else if indexImpressora = 1  then ecf.Modelo := ecfDaruma
  else if indexImpressora = 2  then ecf.Modelo := ecfDataRegis
  else if indexImpressora = 3  then ecf.Modelo := ecfECFVirtual
  else if indexImpressora = 4  then ecf.Modelo := ecfEpson
  else if indexImpressora = 5  then ecf.Modelo := ecfEscECF
  else if indexImpressora = 6  then ecf.Modelo := ecfFiscNET
  else if indexImpressora = 7  then ecf.Modelo := ecfICash
  else if indexImpressora = 8  then ecf.Modelo := ecfMecaf
  else if indexImpressora = 9  then ecf.Modelo := ecfNaoFiscal
  else if indexImpressora = 10 then ecf.Modelo := ecfNCR
  else if indexImpressora = 11 then ecf.Modelo := ecfNenhum
  else if indexImpressora = 12 then ecf.Modelo := ecfQuattro
  else if indexImpressora = 13 then ecf.Modelo := ecfSchalter
  else if indexImpressora = 14 then ecf.Modelo := ecfSweda
  else if indexImpressora = 15 then ecf.Modelo := ecfSwedaSTX
  else if indexImpressora = 16 then ecf.Modelo := ecfUrano
  else if indexImpressora = 17 then ecf.Modelo := ecfYanco;

  ecf.Porta := porta;
  ecf.Device.Baud := velocidade;
end;

procedure SetBorder(var comp : TWinControl;AColor: TColor);
var
  Canvas: TCanvas;
begin
  //Canvas := TCanvas.Create;
    try
      ShowMessage('1');
      TForm(comp).Canvas.Handle := GetWindowDC(Application.Handle);
      ShowMessage('2');
      TForm(comp).Canvas.Pen.Style := psSolid;
      ShowMessage('3');
      TForm(comp).Canvas.Pen.Color := AColor;
      ShowMessage('4');
      TForm(comp).Canvas.Brush.Style := bsClear;
      ShowMessage('5');
      TForm(comp).Canvas.Rectangle(0, 0, comp.Width, comp.Height);
      ShowMessage('6');
    finally
      ReleaseDC(Application.Handle, TForm(comp).Canvas.Handle);
    end;
end;

function procuraForma(var lista : TStringList; const entrada : boolean) : integer;
var
  ini, fim : integer;
begin
  Result := 0;
  fim    := lista.Count -1;
  for ini := 0 to fim do
    begin
      if entrada then
        begin
          if lista.Names[ini] = '1' then
            begin
              Result := ini;
              break;
            end;
        end
      else
        begin
          if lista.Names[ini] <> '1' then
            begin
              Result := ini;
              break;
            end;
        end;
    end;
end;

function lerForma(const form : String; const ind : integer) : String;
begin
  if ind = 0 then
    begin
      Result := copy(form, 1, pos('-', form) - 1);
      Result := trim(Result);
    end
  else
    begin
      Result := copy(form, pos('-', form) + 1, length(form));
      Result := trim(Result);
    end;
end;

procedure setqueryFunc();
begin
  query  := dtmMain.IBQuery1;
  query1 := dtmMain.IBQuery2;
end;

function checaCodbar(vx_cod : String) : boolean;
var
 ut : string;
 vx_ta, vx_soma, vx_ret, vx_i : integer;
 vx_cal : variant;
begin
  Result := false;
  ut := vx_cod;
  vx_cod := copy(vx_cod, 1, 12);
  vx_ta := Length(vx_cod);
  vx_soma := 0;
  vx_ret := 0;
  if Length(vx_cod) <> 12 then
    begin
      exit;
    end;

  FOR vx_i := 1 TO vx_ta do
    begin
      vx_cal := StrToInt(copy(vx_cod,vx_i,1));

      IF (vx_i mod 2) = 0 then vx_cal := vx_cal * 3;
      vx_soma := vx_soma + vx_cal;
    end;

    WHILE (vx_soma / 10 <> trunc(vx_soma/10)) do
      begin
        vx_ret := vx_ret + 1;
        vx_soma := vx_soma + 1;
      end;

  vx_cod := (trim(vx_cod) + TRIM(IntToStr(vx_ret)));

  if vx_cod = ut then Result := true;

end;


function LerFormPato(index:integer; label1 : string; escSair : boolean) : string;
begin
end;

FUNCTION DIGEAN(vx_cod : string) : string;
var
 vx_ta, vx_soma, vx_ret, vx_i : integer;
 vx_cal : variant;
begin
  vx_ta := Length(vx_cod);
  vx_soma := 0;
  vx_ret := 0;
  if Length(vx_cod) <> 12 then
    begin
      Result := vx_cod;
      exit;
    end;
  FOR vx_i := 1 TO vx_ta do
    begin
      vx_cal := StrToInt(copy(vx_cod,vx_i,1));

      IF (vx_i mod 2) = 0 then vx_cal := vx_cal * 3;
      vx_soma := vx_soma + vx_cal;
    end;

    WHILE (vx_soma / 10 <> trunc(vx_soma/10)) do
      begin
        vx_ret := vx_ret + 1;
        vx_soma := vx_soma + 1;
      end;
  Result := (trim(vx_cod) + TRIM(IntToStr(vx_ret)));
end;


procedure mostraMensagem(const mensagem1 : String;const novo : boolean);
begin
  if novo then
    begin
      Application.ProcessMessages;
      mensagem := Tmensagem.Create(Application);
      mensagem.Label1.Caption := mensagem1;
      mensagem.Width := mensagem.Label1.Left + mensagem.Label1.Width + 20;
      mensagem.Show;
      Application.ProcessMessages;
    end
  else
    begin
      mensagem.Close;
      mensagem.Free;
    end;
end;

function localizar1(titulo:string;tabela:string;campos:string;retorno:string;esconde:string;localizarPor:string;OrdenarPor:string;editLocaliza:boolean;editavel:boolean;deletar:boolean;campoLocate:string;keyLocate: String;tamanho:integer;compnenteAlinhar: TObject):string;
var pRect:TRect;
begin
  setqueryFunc();

  Form7 := Tform7.Create(Application);

  if form1.pgerais.Values['42'] = 'S' then form7.usarBuscaProdutoCodigoSeq := true
    else form7.usarBuscaProdutoCodigoSeq := false;

  form7.query  := query;
  form7.query1 := query1;
  if tamanho<>0 then form7.Width:=tamanho;
  //alinhar em baixo do componente
  if compnenteAlinhar <> nil then
   begin
    GetWindowRect(tedit(compnenteAlinhar).Handle,pRect);
    pRect.Top := pRect.Top + 21;
    form7.Top := pRect.Top;
    if pRect.Left + form7.Width > Screen.Width then form7.Left := Screen.Width - form7.Width
     else form7.Left := pRect.Left;
   end
  else
   begin
     form7.Position := poScreenCenter;
   end;
  form7.tabela :=tabela;
  form7.campos:= campos;
  form7.Caption := titulo;
  form7.campolocaliza:=localizarPor;
  form7.ordem:=OrdenarPor;
  form7.retorno:=retorno;
  form7.editalvel:=editavel;
  form7.deletar:=deletar;
  //form7.formulario := self;
  form7.esconde := esconde;
  form7.campoLocate := campoLocate;
  form7.keyLocate := keyLocate;
  if not(editLocaliza) then
   begin
    form7.editlocaliza := true;
    form7.Label1.Visible := false;
    form7.Edit1.Visible := false;
    form7.DBGrid1.Top := 1;
    form7.DBGrid1.Height:=form7.DBGrid1.Height+30;
   end
  else form7.editlocaliza := false;
  Form7.ShowModal;
  result := form7.retLocalizar;
  Form7.Free;
end;

function localizar2(titulo:string;tabela:string;campos:string;retorno:string;esconde:string;localizarPor:string;OrdenarPor:string;editLocaliza:boolean;editavel:boolean;deletar:boolean;campoLocate:string;keyLocate: String;tamanho:integer;compnenteAlinhar: TObject):string;
var pRect:TRect;
begin
  setqueryFunc();

  Form7 := Tform7.Create(Application);
  form7.query  := query;
  form7.query1 := query1;
  if tamanho<>0 then form7.Width:=tamanho;
  //alinhar em baixo do componente
  if compnenteAlinhar <> nil then
   begin
    GetWindowRect(tedit(compnenteAlinhar).Handle,pRect);
    pRect.Top := pRect.Top + 21;
    form7.Top := pRect.Top;
    if pRect.Left + form7.Width > Screen.Width then form7.Left := Screen.Width - form7.Width
     else form7.Left := pRect.Left;
   end
  else
   begin
     form7.Position := poScreenCenter;
   end;
  form7.tabela :=tabela;
  form7.campos:= campos;
  form7.Caption := titulo;
  form7.campolocaliza:=localizarPor;
  form7.ordem:=OrdenarPor;
  form7.retorno:=retorno;
  form7.editalvel:=editavel;
  form7.deletar:=deletar;
  //form7.formulario := self;
  form7.esconde := esconde;
  form7.condicao  := campoLocate;
  form7.keyLocate := '';
  if not(editLocaliza) then
   begin
    form7.editlocaliza := true;
    form7.Label1.Visible := false;
    form7.Edit1.Visible := false;
    form7.DBGrid1.Top := 1;
    form7.DBGrid1.Height:=form7.DBGrid1.Height+30;
   end
  else form7.editlocaliza := false;
  Form7.ShowModal;
  result := form7.retLocalizar;
  Form7.Free;
end;


function busca(var dataset:tibquery;busca:string;retorno:string;campobusca:string;camposdataset:string):string;
var
 i   :integer;
 lab : TLabel;
begin
  //form33 := tform33.Create(Application);
  form33.campobusca := campobusca;
  form33.campolocalizaca := retorno;
  FormataCampos(dataset,2,'',2);
  form33.DataSource1.DataSet := dataset;
  if UpperCase(campobusca) = 'CODMOV' then
    begin
      form33.DBGrid1.Align := alTop;
      form33.DBGrid1.Height := form33.Height - 50;
      lab := TLabel.Create(form33);
      lab.Parent := form33;
      lab.Top  := form33.DBGrid1.Height + 5;
      lab.Left := 10;
      lab.Caption := 'I - Imprime,  T - Total';
      lab.Font.Style := [fsBold];
    end;
  form33.retornoEnter := '';  
  form33.ShowModal;

  if UpperCase(campobusca) = 'CODMOV' then lab.Free;
  //dataset.Close;
  result := form33.retornoEnter;
  //form33.Free;
 // a.Close;
 // a.free;
end;

function dialogo(tipo:string;maxlengt : integer;ValorEntrada:string;tamanhocampo:integer;obrigatorio1:boolean;trocaletras:string;titulo:string;label1:string;default:string):string;
var
  valordg : String;
begin
//se TIPO = NORMAL entao maxlength sera o minimo de caracteres que ira aceitar
  pergunta1 := Tpergunta1.Create(Application);
  CtrlResize(tform(pergunta1));
  pergunta1.Gauge1.Visible := false;
  pergunta1.option := 1;
  pergunta1.maxlengt := maxlengt;
  pergunta1.obrigatorio := obrigatorio1;
  pergunta1.Caption := titulo;
  pergunta1.valorPadrao := default;
  pergunta1.valorLabel := label1;
  pergunta1.tempo := true;
  if  tamanhocampo = 0 then pergunta1.tamanhoEdit:=0
    else pergunta1.tamanhoEdit := tamanhocampo;
  pergunta1.botoes := trocaletras;
  pergunta1.tipo := tipo;
  pergunta1.valorTecla := ValorEntrada;
  pergunta1.ShowModal;
  //if tipo='numero' then pergunta1.valordg := CurrToStr(pergunta1.jsnumero1.getValor);
  result := pergunta1.valordg;
  valordg := '' ;

  try
    jsedit.LiberaMemoria(pergunta1);
    pergunta1.DestroyComponents;
    pergunta1.Destroy;
  except
  end;

  {jsedit.LiberaMemoria(pergunta1);
  pergunta1.Free;
  pergunta1.DestroyComponents;
  pergunta1.Destroy;
  jsedit.LiberaMemoria(pergunta1);}
end;

function dialogoG(tipo:string;maxlengt : integer;ValorEntrada:string;tamanhocampo:integer;obrigatorio1:boolean;trocaletras:string;titulo:string;label1:string;default:string;const Normal : boolean):string;
var
  valordg : String;
begin
//se TIPO = NORMAL entao maxlength sera o minimo de caracteres que ira aceitar
  pergunta1 := Tpergunta1.Create(Application);
  CtrlResize(tform(pergunta1));
  pergunta1.Gauge1.Visible := false;
  pergunta1.option := 1;
  pergunta1.maxlengt := maxlengt;
  pergunta1.obrigatorio := obrigatorio1;
  pergunta1.Caption := titulo;
  pergunta1.valorPadrao := default;
  pergunta1.valorLabel := label1;
  pergunta1.tempo := true;
  pergunta1.normal := Normal;
  if  tamanhocampo = 0 then pergunta1.tamanhoEdit:=0
    else pergunta1.tamanhoEdit := tamanhocampo;
  pergunta1.botoes := trocaletras;
  pergunta1.tipo := tipo;
  pergunta1.valorTecla := ValorEntrada;
  pergunta1.Label1.Font.Style := [fsBold];
  
  pergunta1.ShowModal;
  //if tipo='numero' then pergunta1.valordg := CurrToStr(pergunta1.jsnumero1.getValor);
  result := pergunta1.valordg;
  valordg := '' ;
  try
    jsedit.LiberaMemoria(pergunta1);
    pergunta1.DestroyComponents;
    pergunta1.Destroy;
    //pergunta1.Free;
  except
  end;
  //pergunta1.DestroyComponents;
  //pergunta1.Destroy;
end;

function ContaChar(estring:string;sub:string):string;
var i:integer;
begin
 result:='0';
 i:=1;
  while pos(sub,estring)>0 do
  begin
    result:=IntToStr(strtoint(result)+1);
    i:=pos(sub,estring);
    estring:= copy(estring,i+1,length(estring));
  end;
end;


procedure CtrlResize(var Sender: TForm);
const
  iWidth = 800;
  iHeight = 600;
var i, b, wi, he : Integer;
 totwi, tothe : double;
begin
  wi := Screen.Width;
  he := Screen.Height;

  totwi := wi / iWidth;
  tothe := he / iHeight;

  with Sender do
    begin
      for i := 0 to ComponentCount -1 do
        begin
          if ((Components[i] is JsEditInteiro) or (Components[i] is JsEditNumero)) then
            begin
              if wi = 1366 then TEdit(Components[i]).Font.Size := 28;
              //TEdit(Components[i]).Font.Size := trunc(TPanel(Components[i]).Font.Size * (totwi / tothe)) -2;
            end
          else if Components[i] is TListBox then
            begin
              if ((wi >= 1280) and (wi <= 1366)) then TPanel(Components[i]).Font.Size := 20;
              //if wi = 1280 then TPanel(Components[i]).Font.Size := 20;
              if wi = 1024 then TPanel(Components[i]).Font.Size := 18;
              TWinControl(Components[i]).Width  := trunc(TWinControl(Components[i]).Width * (wi / iWidth));
              TWinControl(Components[i]).Height := Round(TWinControl(Components[i]).Height * (he / iHeight));
              TWinControl(Components[i]).Left   := Round(TWinControl(Components[i]).Left * (wi / iWidth));
              TWinControl(Components[i]).Top    := Round(TWinControl(Components[i]).Top * (he / iHeight));
              //TPanel(Components[i]).Font.Size := trunc(TPanel(Components[i]).Font.Size * (wi / iWidth));
            end
          else if Components[i] is TWinControl then
            begin
              TWinControl(Components[i]).Width  := trunc(TWinControl(Components[i]).Width * (wi / iWidth));
              TWinControl(Components[i]).Height := Round(TWinControl(Components[i]).Height * (he / iHeight));
              TWinControl(Components[i]).Left   := Round(TWinControl(Components[i]).Left * (wi / iWidth));
              TWinControl(Components[i]).Top    := Round(TWinControl(Components[i]).Top * (he / iHeight));
            end
          else
            begin
              if Components[i] is TLabel then
               begin
                TLabel(Components[i]).Width := trunc((totwi / tothe) * TLabel(Components[i]).Width);//Round((TWinControl(Components[i]).Width * wi) div iWidth); //Canvas.TextWidth(TLabel(Components[i]).Caption);
                TLabel(Components[i]).Height := trunc((totwi / tothe) * TLabel(Components[i]).Height);//Round((TWinControl(Components[i]).Height * he) div iHeight);  // Canvas.TextHeight(TLabel(Components[i]).Caption)+6;
                b := TLabel(Components[i]).Font.Size;
                TLabel(Components[i]).Font.Size := trunc((totwi / tothe) * b);//trunc((totwi * b) + b);;// Round((b * Screen.Width) div iWidth);// Round(TWinControl(Components[i]).Width / (Screen.Width / iWidth));;

                //TWinControl(Components[i]).Left   := Round(TWinControl(Components[i]).Left * (wi / iWidth));
                //TWinControl(Components[i]).Top    := Round(TWinControl(Components[i]).Top * (he / iHeight));
                //TLabel(Components[i]).Left := trunc((TWinControl(Components[i]).Left * wi) div iWidth);//Round((TWinControl(Components[i]).Left * wi) div iWidth);
                //TLabel(Components[i]).Top := trunc((TWinControl(Components[i]).Top * he) div iHeight);
                TLabel(Components[i]).Update;
               end;
                Sender.Refresh;
            end;
        end;

       Sender.Width := Round(Sender.Width * (wi / iWidth));
       Sender.Height := Round(Sender.Height * (he / iHeight));
       Sender.Top := Round(Sender.Top * (Screen.Height / iHeight));
       Sender.Left := Round(Sender.Left * (wi / iWidth));
       Sender.Font.Size := Round(Sender.Font.Size * (he / iHeight));

     end;
end;


function formataCurrency(const valor : currency) : String ;
begin
  Result := FormatCurr('#,###,###0.00', valor);
end;

function centraliza(valor:string;repetir:string;tamanho:integer):string;
var i,cont,ch:integer;
acc:string;
begin
  acc:='';
  cont:=1;
  ch := tamanho-length(valor);
  for i:= 1 to ch do
  begin
    acc := acc + repetir;
    if (i>=ch/2) and (cont=1)  then
     begin
      cont:=2;
      acc := acc+valor;
     end;
  end;
  if length(acc)=tamanho then result:=acc
  else
   begin
      for i:= length(acc) to tamanho do
       begin
        acc := acc + repetir;
       end;
      result:=acc ;
   end;
end;

function GetFileList(const Path: string): TStringList;
var
    I: Integer;
    SearchRec: TSearchRec;
begin
    Result := TStringList.Create;
    try
      I := FindFirst(Path, faAnyFile, SearchRec);
      while I = 0 do
      begin
        Result.Add(SearchRec.Name);
        I := FindNext(SearchRec);
      end;
    except
      Result.Free;
      raise;
    end;
end;


procedure protecaoDeTela();
var
  lista  : TStringList;
  caminho : String;
begin
  caminho := ExtractFileDir(ParamStr(0)) + '\';
  //ShowMessage(caminho);
  criapasta(caminho + 'papel\');
  lista := GetFileList(caminho + 'papel\*.JPG');

  if lista.Count = 0 then
    begin
      lista.Free;
      exit;
    end;

  form4 := tform4.Create(Application);
  form4.caminho := caminho;
  form4.Image1.Picture.LoadFromFile(caminho + 'papel\' + lista[0]);
  form4.lista := lista;
  form4.ShowModal;
  form4.Free;
end;

procedure ArredondarComponente(Componente: TWinControl; const Radius: SmallInt);
var
  R : TRect;
  Rgn : HRGN;
begin
  with Componente do
  begin
    R := ClientRect;
    Rgn := CreateRoundRectRgn(R.Left, R.Top, R.Right, R.Bottom, Radius, Radius);
    Perform(EM_GETRECT, 0, lParam(@R));
    InflateRect(R, -5, -5);
    Perform(EM_SETRECTNP, 0, lParam(@R));
    SetWindowRgn(Handle, Rgn, True);
    Invalidate;
  end;
end;

procedure criaPasta(const pasta : String);
begin
  if not DirectoryExists(pasta) then forceDirectories(pasta);
end;

procedure FormataCampos(query:Tibquery;qtdCasasDecimais:integer;CampoFormatoDiferente:string;qtd:integer);
var a:integer;
begin
  a:=0;
  while a<>query.FieldCount do
  begin
    if (FieldTypeNames[query.Fields.Fields[a].DataType]='BCD') and (query.Fields[a].FieldName<> CampoFormatoDiferente) then
      begin
        TcurrencyField(query.FieldByName(query.Fields[a].FieldName)).DisplayFormat := '###,##0.'+CompletaOuRepete('','','0',qtdCasasDecimais);
      end;
    if (FieldTypeNames[query.Fields.Fields[a].DataType]='BCD') and (query.Fields[a].FieldName=campoFormatoDiferente) then
      begin
        TcurrencyField(query.FieldByName(query.Fields[a].FieldName)).DisplayFormat := '###,##0.'+CompletaOuRepete('','','0',qtd);
      end;
    a:=a+1;
  end;
end;


function CompletaOuRepete(const valorParaCompletar:AnsiString;const ValorFinal:AnsiString;valorParaRepetir:string;contadorDeRepeticao:integer):string;
var i:integer;
var acc:string;
  begin
    if length(valorParaCompletar+ValorFinal)<=contadorDeRepeticao then
    begin
    i:=length(ValorFinal);
    acc:='';
    if valorParaCompletar='' then
      begin
        while i < contadorDeRepeticao do
          begin
            try
            acc:=acc+valorParaRepetir;
            except
            end;
            i:=i+1;
            end;
          if ValorFinal<>'' then result:=acc+ValorFinal
             else result:=acc;
      end
    else
      begin
         i := length(valorParaCompletar)+length(ValorFinal);
         acc:=valorParaCompletar;
         while i < contadorDeRepeticao do
          begin
            i:=i+1;
            try
              acc:=acc+valorParaRepetir;
            except
            end;
            end;
          if ValorFinal<>'' then result:=acc+ValorFinal
             else result := acc;
      end;
    end
      else
        begin
          acc := CompletaOuRepete('', '', '*', contadorDeRepeticao);//'*****';
          ///acc := valorParaCompletar + acc + ValorFinal;
          i := length(acc);
          while i < contadorDeRepeticao do
          begin
            i:=i+1;
            try
              acc:=acc+valorParaRepetir;
            except
            end;
            end;
          Result := acc;
        end;
  end;


function PosFinal(substr:string;Texto:string):integer;
var a,b:integer;
var retorno:string;
begin
 b:=0;
 Result := 0;
 for a:=length(Texto) downto 1 do
   begin
     if (texto[a]=substr) and (b=0) then
      begin
       result:=a;
       b:=1;
      end;
   end;
end;

function Contido(substring:string;texto:string):boolean;
begin
  if Pos(substring,texto ) > 0 then result:=true
    else result:=false;
end;

function StrNum(const entra: string) :  string;
var
  cont : integer;
begin
  Result := '';
  for cont := 1 to length(entra) do
    begin
      if Contido(entra[cont],'1234567890') then Result := Result + entra[cont];
    end;
  if Result = '' then Result := '0';
end;

Function ProcuraItemNaLista(var lista : TList; cod1 : integer) : integer;
var fim, i : integer;
 item1 : Item_venda;
begin
  fim := lista.Count - 1;
  Result := -1;

  for i := 0 to fim do
   begin
     item1 := lista.Items[i];
     if item1.cod = cod1 then
       begin
         Result := i;
         break;
       end;
   end;
end;

function Incrementa_Generator(Gen_name : string; valor_incremento : integer) : string;
begin
  setqueryFunc();
  
  query.Close;
  query.SQL.Clear;
  query.SQL.Add('select gen_id('+ Gen_name +','+ IntToStr(valor_incremento) +') as venda from rdb$database');
  query.Open;

  Result := '';
  Result := query.fieldbyname('venda').AsString;

  query.Close;
end;

function ArredondaTrunca(Value: Extended;decimais:integer): Extended;
begin
  if decimais = 2 then Result := trunc(value * 100)/100
     else Result := trunc(value * 1000)/1000;
end;

function ArredondaFinanceiro(Value: Currency; Decimals: integer): Currency;
var
  Factor, Fraction: Currency;
begin
  Factor := IntPower(10, Decimals);
  Value := StrToFloat(FloatToStr(Value * Factor));
  Result := Int(Value);
  Fraction := Frac(Value);
  if Fraction >= 0.5 then
    Result := Result + 1
  else if Fraction <= -0.5 then
    Result := Result - 1;
  Result := Result / Factor;
end;

procedure lerPgerais(var pr : TStringList);
begin
  setqueryFunc();

  query.Close;
  query.SQL.Text := 'select cod, valor from pgerais order by cod';
  query.Open;
  pr.Clear;

  while not query.Eof do
    begin
      pr.Values[query.FieldByName('cod').AsString] := query.FieldByName('valor').AsString;
      query.Next;
    end;

  query.Close;
  query.SQL.Text := 'select empresa from registro';
  query.Open;

  pr.Values['empresa'] := query.fieldbyname('empresa').AsString;
  query.Close;
end;

function Arredonda( valor:currency; decimais:integer; tipo : string = '') : currency;
begin
   if tipo = '' then tipo := form1.pgerais.Values['0'];
   Result := ArredondaFinanceiro(valor,decimais);
   exit;
   tipo := 'F';
   if tipo = 'F' then Result := ArredondaFinanceiro(valor,decimais)
   else Result := trunca(valor,decimais);
end;

function Arredonda2( valor:currency; decimais:integer; tipo : string = '') : currency;
begin
   //ShowMessage(tipo);
   if tipo = '' then tipo := form1.pgerais.Values['0'];
   {Result := ArredondaFinanceiro(valor,decimais);

   exit;
   tipo := 'F';
   }if tipo = 'F' then Result := ArredondaFinanceiro(valor,decimais)
   else Result := trunca(valor,decimais);
end;


function Arredonda1( valor:currency; decimais:integer; tipo : string = '') : currency;
begin
   if tipo = '' then tipo := form1.pgerais.Values['0'];
   //if tipo = 'F' then Result := ArredondaFinanceiro(valor,decimais)
   //else Result := ArredondaTrunca(valor,decimais);
   if tipo = 'F' then Result := RoundABNT(valor, -2)
   else Result := TruncFix(valor * 100 ) / 100 ;
end;

function Criptografar(wStri: String): String;
var
   x , posicao            : Integer;
begin
 Result := '';
 for x := 1 to Length(wStri) do
   begin
     try
       posicao := pos(wStri[x],simbolos1);
       Result := Result + simbolos2[posicao];
     except
     end;
   end;
end;

function logar(const usu, senha : String) : Boolean;
begin
  setqueryFunc();
  
  Result := false;
  query.Close;
  query.SQL.Text := 'select cod, nome, acesso, vendedor, configu from usuario where usu = :usu and senha = :senha';
  query.ParamByName('usu').AsString   := Criptografar(usu);
  query.ParamByName('senha').AsString := Criptografar(senha);
  query.Open;

  if query.IsEmpty then
    begin
      query.Close;
      ShowMessage('Usuário ou Senha Inválidos');
      exit;
    end;

  Result := true;  
end;

function conectaBD() : boolean;
begin
  result := false;
  if ParamStr(1) <> '' then dtmMain.bd.DatabaseName := ParamStr(1)
    else dtmMain.bd.DatabaseName := ExtractFileDir(ParamStr(0)) + '\bd.fdb';

  try
    dtmMain.bd.Connected := true;
    result := true;
  except
    on e:exception do
      begin
        ShowMessage('Ocorreu um Erro na Conexão do Banco de dados:' + #13 + e.Message + #13 + 'Verifique se o caminho está correto');
      end;
  end;
end;

function retornaSQL(const sql : String) : String;
begin

end;

procedure redimensionaTelaDbgrid(var dbgrid : TDBGrid);
var
  ini, fim, acc, wi, he : integer;
begin
  wi := screen.Width;
  he := screen.Height;

  acc := 0;
  fim := dbgrid.Columns.Count -1;
  for ini := 0 to fim do
    begin
      acc := acc + dbgrid.Columns.Items[ini].Width;
    end;

  dbgrid.Width := acc;
  acc := acc + 30;
  if acc > screen.Width then acc := Screen.Width - 20;
  tform(dbgrid.Owner).Width := acc;
  if (acc + tform(dbgrid.Owner).Left) > wi then tform(dbgrid.Owner).Width := wi - (tform(dbgrid.Owner).Left + 20);
  dbgrid.Align := alClient;
end;

function LerConfig(valor:string;posi:integer) : string;
begin
  result := Trim(copy(valor,pos(inttostr(posi) + '-',valor) + 3,retornaPos(valor,'-', pos(inttostr(posi)+'-',valor)+3)));
  //ShowMessage(Result);
end;

function retornaPos(valor:string;sub:string;posi:integer) : integer;
begin
 valor := copy(valor,posi,length(valor));
 result := pos(sub,valor)-1;
end;

function HexToTColor(sColor : string) : TColor;
begin
   Result :=
     RGB(
       StrToInt('$'+Copy(sColor, 1, 2)),
       StrToInt('$'+Copy(sColor, 3, 2)),
       StrToInt('$'+Copy(sColor, 5, 2))
     ) ;
end;

function ArredondaTrunca1(Value: currency;decimais:integer): Extended;
var
 temp : String;
 posi : integer;
begin
  temp := FormatCurr('###0.0000000000000000', Value);
  //temp := CurrToStr(Value);
  //ShowMessage(temp);
  posi := PosFinal(',', temp);
  temp := copy(temp, 1, posi + decimais);
  Result := StrToCurr(temp);
end;

function Trunca(const nValor: Currency; const iCasas: Integer): Currency;
begin
  Result := nValor;

  if iCasas <= 0 then
    Result := Trunc(nValor)
  else
    if iCasas = 1 then
      Result := Trunc(nValor * 10) / 10
    else
      if iCasas = 2 then
        Result := Trunc(nValor * 100) / 100
      else
        if iCasas = 3 then
          Result := Trunc(nValor * 1000) / 1000
        else
          if iCasas = 4 then
            Result := Trunc(nValor * 10000) / 10000;
end;

function ValidaCPF(sCPF: string): boolean;
var
  sDigs, sVal : string;
  iSTot, iSTot2: integer;
  i: integer;
begin
  Result := false;
  if length(sCPF) <> 11 then exit;

  sCPF := Trim(StrNum(sCPF));
  iSTot := 0;
  iSTot2 := 0;
  if Length(sCPF) = 11 then
    begin
      for i := 9 downto 1 do
        begin
          iSTot := iSTot + StrToInt(sCPF[i]) * (11 - i);
          iSTot2 := iSTot2 + StrToInt(sCPF[i]) * (12 - i);
        end;
       iSTot := iSTot mod 11;
       sDigs := sDigs + IntToStr(IfThen(iSTot < 2, 0, 11 - iSTot));
       iSTot2 := iSTot2 + 2 * StrToInt(sDigs);
       isTot2 := iSTot2 mod 11;
       sDigs := sDigs + IntToStr(IfThen(iSTot2 < 2, 0, 11 - iSTot2));
       sVal := Copy(sCPF,10,2);
       if sDigs = sVal then Result := true
        else Result := false;
       //Result := IfThen(sDigs = sVal,true,false);
    end;
end;

function ValidaCNPJ(CNPJ: string): Boolean;
var
  i, digito1, digito2, cont: integer;
begin
  //Deleta a mascara do CPF caso tenho
  CNPJ := StrNum(CNPJ);
  if (Length(CNPJ) <> 14) then //Verifica se o mesmo possui 14 digitos exatos
    begin
      Result := False;
      exit;
    end
  else if (CNPJ = '00000000000000') then //Verifica se todos os digitos são 0
    Result := False
  else
  begin
    digito1 := 0;
    digito2 := 0;
    cont := 2;
    try //Caso ocorra algum erro não previsto retorna False
      for i := 12 downto 1 do
      begin
        if cont = 10 then
          cont := 2;
        digito1 := digito1 + (StrToInt(CNPJ[i]) * cont);
        digito2 := digito2 + (StrToInt(CNPJ[i + 1]) * cont);
        cont := cont + 1;
      end;
      digito2 := digito2 + (StrToInt(CNPJ[1]) * 6);
      if (digito1 mod 11) < 2 then
        digito1 := 0
      else
        digito1 := 11 - (digito1 mod 11);
      if (digito2 mod 11) < 2 then
        digito2 := 0
      else
        digito2 := 11 - (digito2 mod 11);
      if (digito1 <> StrToInt(CNPJ[13])) or (digito2 <> StrToInt(CNPJ[14])) then
        Result := False
      else
        Result := True;
    except
      Result := False;
    end;
  end;
end;

function le_codbar1(var query : TIBQuery; const codbar, paramGe38 : String; arredon : String = '') : TprodutoVendaCodBar;
var
  _ptot, quanti, ptotCodbar, qtt : currency;
begin
  if arredon = '' then arredon := 'T';
  Result        := TprodutoVendaCodBar.Create;
  Result.preco  := 0;
  Result.precoTemp := 0;
  Result.codbar := LeftStr(trim(codbar), 5);

  query.Close;
  query.SQL.Text := 'select cod, p_venda, nome, codbar from produto where (substring(codbar from 1 for 5) = '+ QuotedStr(Result.codbar)+')';
  query.Open;
  query.FetchAll;

  if query.RecordCount = 0 then
    begin
      Result.codbar := '*';
      query.Close;
      exit;
    end;

  Result.codbar := query.fieldbyname('codbar').AsString;
  Result.preco  := query.fieldbyname('p_venda').AsCurrency;
  query.Close;

  quanti := StrToCurrDef(copy(codbar, 6, 7), 0);
  qtt := quanti;

  if paramGe38 = '2' then
    begin
      Result.precoTemp := (quanti /100);

      Result.quant := ARREDONDA2((quanti /100) / Result.preco, 2, arredon);
      quanti := Result.quant; // quanti tem  a quantidade aprox

      while true do
        begin
          _ptot := ARREDONDA2(quanti * Result.preco, 2, arredon);//valor aprox
          //ShowMessage(CurrToStr(quanti) + #13 + CurrToStr(_ptot) + #13 + CurrToStr(Result.precoTemp));
          if _PTOT >= Result.precoTemp then break;

          quanti := quanti + 0.0001;
        end;

      Result.quant := quanti;
    end
  else
    begin
      Result.quant := (quanti / 1000);
      Result.precoTemp := ARREDONDA2(Result.quant * Result.preco, 2, arredon);
    end;
end;

procedure progresso(label1 : String; ini, fim : integer; novo, fechar : boolean);
var
  b : integer;
begin
  if novo then
    begin
      pergunta1.Show;
      pergunta1.Gauge1.Progress := 0;
      pergunta1.Gauge1.Visible := true;
      pergunta1.Label1.Caption := label1;
      b := 5;
    end;

  if fechar then
    begin
      pergunta1.Close;
      pergunta1.Gauge1.Visible := false;
      exit;
    end;

  Application.ProcessMessages;
  pergunta1.Gauge1.Progress := trunc(ini / fim * 100);
  if pergunta1.Gauge1.Progress > b then
    begin
      b := b + 5;
      pergunta1.Gauge1.Progress := b;
    end;

  if (b >= 100) then pergunta1.Close;  
end;

function VerSeExisteGeneratorPeloNome(Const nome : String; var query : TIBQuery) : boolean;
begin
  Result := false;
  query.Close;
  query.SQL.Clear;
  query.SQL.Add('select rdb$generator_name from rdb$generators where rdb$generator_name = ' + QuotedStr(nome));
  query.Open;

  if not query.IsEmpty then Result := true;

  query.Close;
end;

function criaGeneratorContadorNFCe(serie : String; var query : TIBQuery) : integer;
var
  servidor : String;
begin
  Result := 0;
  if query.Database.DatabaseName = '' then exit;


  if not dtmMain.conectaBD_Servidor then exit;
  


  serie := StrNum(serie);
  if serie = '0' then serie := '';
  if VerSeExisteGeneratorPeloNome('NFCE' + serie, query) = false then
    begin
      query.Close;
      query.SQL.Text := 'CREATE SEQUENCE NFCE' + serie;
      try
        query.ExecSQL;
        query.Transaction.Commit;
      except
      end;
      query.Close;  
    end;

  query.Close;
  query.SQL.Text := 'select gen_id(NFCE'+ serie +',0) as venda from rdb$database';
  query.Open;

  Result := 0;
  Result := query.fieldbyname('venda').AsInteger;
  query.Close;

  query.Database.Connected := false;  
end;

function reStartGenerator1(nome : string; Valor : integer; var query : TIBQuery): String;
begin
  query.Close;
  query.SQL.Clear;
  query.SQL.Add('ALTER SEQUENCE ' + nome + ' RESTART WITH ' + IntToStr(Valor));
  query.ExecSQL;

  query.Transaction.Commit;
  Result := '';
end;

FUNCTION MensagemTextoInput(Caption, default: string): string;
begin
  pergunta1 := Tpergunta1.Create(Application);
  if Caption = '' then
    pergunta1.Caption := Application.Title
  else
    pergunta1.Caption := Caption;
  pergunta1.option := 2;
  pergunta1.gauge1.Visible := false;
  pergunta1.label1.Visible := false;
  // pergunta1.Label1.Caption := Mensagem;
  pergunta1.label1.Font.color := clRed;
  CtrlResize(TForm(pergunta1));

  pergunta1.tipo := 'texto';
  pergunta1.memo1 := TMemo.Create(Application);
  pergunta1.memo1.Name := 'memo1';
  pergunta1.memo1.Parent := pergunta1;
  pergunta1.memo1.Align := alClient;
  pergunta1.memo1.Text := default;
  pergunta1.memo1.OnKeyPress := pergunta1.MeuKeyPress;
  pergunta1.ShowModal;
  Result := pergunta1.memo1.Text;
  exit;
end;

procedure MeuKeyPress1(Sender: TObject; var Key: Char);
begin
  if ((Key = #13) or (Key = #27)) then
    pergunta1.Close;
end;

procedure mensagemEnviandoNFCE(const msg : String; abrir, fechar : boolean);
begin
  if abrir then begin
    form65 := tform65.create(Application);
    try
      form65.RxGIFAnimator1.Image.LoadFromFile(ExtractFileDir(ParamStr(0)) + '\c.gif');
      form65.Label1.Caption         := msg;
      form65.RxGIFAnimator1.Animate := true;
    except
    end;
    form65.Show;
  end;

  if fechar then begin
    Form65.Close;
    form65.Free;
  end;
end;




end.
