unit P4InfoVarejo_Rotinas;

interface

uses windows, sysutils, registry, forms, controls, stdctrls, dbctrls, graphics,
     IBQuery,IBDatabase, DB,variants, printers, classes, shellapi, extctrls,
     dialogs, ComCtrls, IBODataset,IB_Components, IB_StoredProc,
     IB_SessionProps, IB_Grid,DBChart, Winsock,

     P4InfoVarejo_constantes;

Type
  TSemestre = record
    Mes, Ano : Word;
  end;

  Semestre = array[0..5] of TSemestre;

function  AbreviaNome(Nome: String): String;
function  AppIsRunning                                                    :Boolean;
function  AddchrF           (Texto  :string; FChar: char; nvezes:integer) :string;
function  AddchrI           (Texto  :string; IChar: char; nvezes:integer) :string;
function  apenas_numero     (vl:string):boolean;
procedure ApenasCaracteresAlfaNumericos(var key:char);
function  Ano_Bissexto      (ano:integer):boolean;
function  CentralizarString(texto:string; Tamanho:integer):string;
function  ChrCount(const sSearchFor: String; sString: String): Integer;
procedure Classificar_Strings(var cd:TStrings);
function  ContarString      (StrText:string; StrChar:char)                :integer;
function  CountWords(InputString: string): integer;
procedure CriaDiretorio(NomeDir: String);
function  CurrText(RichEdit:TRichEdit): TTextAttributes;
function  DataExtenso(Data:TDateTime): String;
procedure DigitaData (sender:TObject; var Key: Char);
function  Espaco            (valor  :integer)                             :string;
procedure ExecFile(F: String);overload;
function  ExecFile(const FileName, Params, DefaultDir: string;ShowCmd: Integer): THandle;overload;
function  ExisteString      (StrText:string; StrChar: char)               :Boolean;
Function  Extenso           (Valor  :Extended; Monetario:Boolean)         :String;
function  FillString        (StrChar:Char; qtd:integer)                   :string;
function  fSpace(Count: Integer): String;
function  fPad(sString: String; Count: Integer): String;
function  flPad(sString: String; Count: Integer): String;
function  fNVL(pValue: Variant;pDefault: Variant): Variant;
function  StrZero(sSource: String; Len: Integer): String;
function  RemoveUltimoCaracter(sString: String): String;
Function  GetNetWorkUserName                                              :string;
function  IsInteger(numero:string):boolean;
function  IsWeekEnd(dData : TDateTime) : boolean;
function  LimpaAcentos      (S      : String)                             :String;
Function  Mascara_Inscricao_Estadual( Inscricao, Estado : String ) : String;
function  NameMonth(Mes:Word;Abrev:Boolean):String;
Function  NomeComputador                                                  :String;
function  PortaImpressora(chave:string):string;
function  PrimeiroDiaUtil(Data:TDateTime):TDateTime;
procedure PrintForm(frm: TForm);
function  QuebraString(sString: String;nLength: Integer;nIndex: Integer): String;
function  RepeteChar        (C:char;N :integer):string;
function  RemoveSimbolos    (numero:string):string;
function  RemoverChar (texto:string; simbolo : char):string;
function  RemoverCaracteres(texto:string):string;
function  RemoverEspacosVazios(Texto:string):string;
function  RetiraAcentos(txt: String): String;
function  ReturnSixMonth(Actual:TDateTime):Semestre;
function  StrRepl(sString: String; sSearch: String; sReplace: String): String;
function  substituir        (texto: string; velho: string; novo: char):string;overload;
function  substituir        (texto, velho, novo: string):string;overload;
function  TextoFormatado(RichEdit: TRichEdit; nsFonte:integer;Sublinhado,negrito, TextoPesquisa: string): string;
function  Truncar           (valor : currency):currency;overload;
function  Truncar2(valor:currency):currency;
function  TruncarInteiro    (valor : currency):integer;overload;
function  Ultimo_Dia_Mes    (data : TDate):integer;
function  ValorIcms(qtitem, vlunitario, pricms:currency):currency;
function  valor_numero_inteiro(valor:string):boolean;
function  valor_numero_decimal(valor:string):Boolean;
function  ValorIpi(qtitem, vlunitario, pripi:currency):currency;
function  VerificaCNPJ      (CPNJ   : string)                             :Boolean;
function  VerificaCPF       (CPF    : string)                             :Boolean;
function  Verifica_Inscricao_Estadual( Inscricao, Tipo : String ) : Boolean;
function  Alinha_Esquerda(sString: String; Count: Integer): String;
function  EspacoStr(count: Integer): String;
function  Converte_String_Inteiro(valor:string):Double;
function  LeRegistroSistema : string;
function  LeRegistroSistema_BD_Usuario(var Usuario:String; var Senha:String) : string;
function  Substitui(Texto:string;Atual:string;Novo:String):String;
function  Retorna_Nome_Aliquota(valor:String):String;
function  Retorna_Aliquota(valor:String;Banco:TIBDatabase;Transacao:TIBTransaction):String;overload;
function  Retorna_Aliquota(valor:String):String;overload;
function  Retorna_Aliquota_Somente(valor:String):String;
function  Retorna_Unidade_Sigla(valor:string):String;
function  RetiraArgumento(Retirar,Argumento:string):string;
function  Retorna_Unidade_Medida(valor:string):String;
function  RetiraCaracteresEspeciais(valor:string):String;
function  HexToTColor(sColor : string):TColor;
function  Ajusta_Moeda_Sem_Centavos(valor:string):String;
function  Ajusta_Moeda(valor:string):String;overload;
function  Ajusta_Moeda(valor:string;novo:boolean):String;overload;
function  Inserir_Aliquota(conmain:TIB_Connection; nome:string;nomereduzido:string;tptributacao:string; vlaliquota:string):Integer;
function  Inserir_Unidade_Medida(conmain:TIB_Connection; nome:string;nomereduzido:string):Integer;
function  Converte_Moeda_String(valor:Currency):String;
procedure WriteStatusBar(ACanvas:TCanvas; Rect:TRect; atext:string; fontcolor:TColor);overload;
procedure WriteStatusBar(ACanvas:TCanvas; Rect:TRect; atext:string; fontcolor, backgroundcolor:TColor);overload;
procedure InicializaValores();
function GetDateElement(FDate: TDateTime;Index: Integer): Integer;
function ArrCondPag(sCondPag: String;dDataBase: TDateTime;sTipoFora: String): Variant;
function RemoveAcento(Str:String): String;
function RetornaDataString(Data:string):string;overload;
function RetornaDataString(Data:string; formato:string):string;overload;
function RetornaDataMovtoECF(Data:string):string;
function FormataStringParaData(Data:string):string;
function Substitui_Ponto_Virgula(valor:string):String;
function ReplicaTexto(col:integer; Texto:string):String;
function AjustaString(str: String; tam: Integer): String;
function AjustaNumerico(VlrMoeda: Currency; tam: Integer) : String;
function AjustaInteiro(inteiro:String;tam:integer) : String;
function Exibir_Periodo(cdcliente:string):string;
function SeparaMes(Data:TDate):Integer;
function RemoveDigitoCodigoBarras(cdbarras:string):String;
function Proximo_Codigo_Barra(conmain: tib_connection):string;


procedure RemoverValoresLista(cdlista:TStrings; ilinha:integer; var campo:string; var desccampo:string; var tipodedado:string);
procedure ConfiguraIB_Grid(qry:TIB_Query;grd:TIB_Grid);
procedure LimpaIB_Grid(qry:TIB_Query;grd:TIB_Grid);

function RetirarCaracteresEspeciais(valor:string):String;
function FormataCNPJ(valor:string):String;
function FormataCPF(valor:string):String;
function FormataCEP(valor:string):String;
function FormataTelefone(valor:string):String;
function AcumulaHoras(Horas:TStrings):String;
function RetornaDataMesAnoReferencia(Data:string):string;


function Retorna_Permissao_Usuario_Caixa(UsuarioConectado, BancoSeguranca, Usuario, Senha:String):Boolean;

// PLCBEMASYS 2009

function LeParametro(sparam:string):String;
function LeValorParametro(sparam:string):String;
procedure LeDadosArquivoImpressoraFiscal(var nuserie:string; var impressora: string; var porta: string; var MFD: string;
                                         var gaveta: string; var impcheque: string; var tef_dial:string; var tef_Disc:string;
                                         var gt_ecf:string);

function Formata_CNPJ(cnpj:String):String;
function Substitui_Caracter(Palavra,valorAntigo,valorNovo:string):String;
function FormataPercentual(valor:string; decimais:boolean):Double;overload;
function FormataPercentual(valor:string):String;overload;
//
function NomeArquivoBancoRemessa():String;
function ConverteDecimal_DataHora(valorNumerico:Double):String;
function Subtrai_Datas(DataInicial, DataFinal:TDateTime; HoraInicial:TTime; HoraFinal:TTime):String;
function IPLocal:string;
function Tratar_NumeroIP_Computador(ip:string):String;

var
 RegConexao,RegCaminho,RegUsuario,RegSenha,RegProtocolo,RegServidor,mensagem : string;
 RePortaImp,Empresa, MensagemCupom,InformaQtd, BolDigCodBarras, BolGeraReferencia :string;
 VendaAberta:Boolean;


implementation

uses IBCustomDataSet;

function HexToTColor(sColor : string):TColor;
begin
 Result := RGB(StrToInt('$'+Copy(sColor, 1, 2)),
               StrToInt('$'+Copy(sColor, 3, 2)),
               StrToInt('$'+Copy(sColor, 5, 2)));
end;

function Converte_Moeda_String(valor:Currency):String;
var
 vetCent: array[1..14] of string;
 sValor:string;
 j:integer;
begin
 for j := 1 to 14 do
  begin
   vetcent[j] := Copy(FloatToStr(valor) ,j,1);
  end;
  for j := 1 to 14 do
   begin
    sValor := svalor+''+VetCent[j];
   end;
  Result := sValor;
end;

function Ajusta_Moeda_Sem_Centavos(valor:string):String;
var
 Posicao,contZero:integer;
 i,tam,ivalor:integer;
 centavos:string;
begin
 valor    := Copy(valor,1,length(valor)-2);
 centavos := Copy(valor,length(valor),2);
 Result   := valor+','+centavos;
end;

function Ajusta_Moeda(valor:string):String;
var
 Posicao,contZero:integer;
 i,tam,ivalor:integer;
begin
 contZero := 0;
 Posicao  := Pos(',',valor);
 if Posicao = 0 then
  begin
   valor := valor+'00';
  end;
  if Posicao > 0 then
   begin
    tam := Length(valor);
    ivalor := tam - Posicao;
    if ivalor = 1 then
     valor := valor+'0';
   end;
   Posicao  := Pos(',',valor);
   while Posicao > 0 do
    begin
     Delete(valor,Posicao,1);
     Posicao := Pos(',',valor);
     contZero := contZero + 1;
    end;
    for i := 0 to contZero -1 do
     begin
      Insert('0',valor,1);
     end;
     Result := valor;
end;

function Ajusta_Moeda(valor:string;novo:boolean):String;
var
 Posicao,contZero:integer;
 i,tam,ivalor:integer;
begin
 contZero := 0;
 Posicao  := Pos(',',valor);
 if Posicao = 0 then
  begin
   valor := valor+'000';
  end;
  if Posicao > 0 then
   begin
    tam := Length(valor);
    ivalor := tam - Posicao;
    if ivalor = 1 then
     valor := valor+'00';
   end;
   Posicao  := Pos(',',valor);
   Result := valor;
end;

function RetiraArgumento(Retirar,Argumento:string):string;
var
  Auxarg,Aux:string;
  numero:integer;
begin
 Auxarg := Argumento;
 numero := pos(Retirar,Auxarg);
 if numero > 0 then
  begin
   aux := copy(Auxarg,0,numero -1);
   while numero > 0 do
    begin
     Auxarg := copy(Auxarg,numero + 1,255);
     numero := pos(Retirar, Auxarg);
     aux := aux+copy(Auxarg, 0, numero -1);
   end;
   aux := aux+copy(Auxarg, 0, 255);
   result := aux;
  end
  else
  result := Argumento;
end;

function RetiraCaracteresEspeciais(valor:string):String;
begin
 valor := RetiraArgumento('''',valor);
 valor := RetiraArgumento(',',valor);
 valor := RetiraArgumento('.',valor);
 valor := RetiraArgumento('-',valor);
 valor := RetiraArgumento('/',valor);
 valor := RetiraArgumento('\',valor);
 valor := RetiraArgumento('=',valor);
 valor := RetiraArgumento('%',valor);
 valor := RetiraArgumento(':',valor);
 valor := RetiraArgumento(';',valor);
 Result := valor;
end;

function EspacoStr(count: Integer): String;
begin
 Result := StringOfChar(' ',Count);
end;

function Alinha_Esquerda(sString: String; Count: Integer): String;
begin
 Result := EspacoStr(Count) + sString;
 Result := Copy(Result,Length(Result)+1-Count,Count);
end;

function Ultimo_Dia_Mes(data:TDate):integer;
var
  i : integer;
  mes : integer;
begin
  result := 30;
  mes := strtoint(formatdatetime('MM', data));
  for i := 1 to 31 do
  begin
    data := data + 1;
    if mes <> strtoint(formatdatetime('MM', data)) then
    begin
      data := data - 1;
      result := strtoint(formatdatetime('DD', data));
      break;
    end;
  end;
end;

function valor_numero_inteiro(valor:string):boolean;
begin
 try
  strtoint(valor);
  result := true;
 except
  result := false;
 end;
end;

function  valor_numero_decimal(valor:string):Boolean;
begin
 try
  StrToFloat(valor);
  result := true;
 except
  result := false;
 end;
end;

procedure Classificar_Strings(var cd:TStrings);
var
  i, j : integer;
  aux : string;
begin
  for i := 0 to cd.Count - 2 do
    for j := cd.Count - 1 downto i+1 do
      if cd[j-1] > cd[j] then
      begin
        aux     := cd[j-1];
        cd[j-1] := cd[j];
        cd[j]   := aux;
      end;
end;

function Ano_Bissexto(ano:integer):boolean;
begin
  result := false;
  if (ano div 4) * 4 = ano then
    result := true;
end;

function CurrText(RichEdit:TRichEdit): TTextAttributes;
begin
  if RichEdit.SelLength > 0 then Result := RichEdit.SelAttributes
  else Result := RichEdit.DefAttributes;
end;

function TextoFormatado(RichEdit: TRichEdit; nsFonte:integer;Sublinhado,negrito, TextoPesquisa: string): string;
var
  startpos, position, endpos: integer;
begin
  startpos := 0;
  with RichEdit do
  begin
    RichEdit.Lines.Count;
    SelText := TextoPesquisa;
    endpos := Length(RichEdit.Text);
    Lines.BeginUpdate;
    while FindText(TextoPesquisa, startpos, endpos, [stMatchCase])<>-1 do
    begin
      endpos := Length(RichEdit.Text) - startpos;
      position := FindText(TextoPesquisa, startpos, endpos, [stMatchCase]);
      Inc(startpos, Length(TextoPesquisa));
      SelStart := position;
      SelLength := Length(TextoPesquisa);
      if negrito = 'S' then
        CurrText(RichEdit).Style := CurrText(RichEdit).Style + [fsBold]
      else
        CurrText(RichEdit).Style := CurrText(RichEdit).Style - [fsBold];
      if sublinhado = 'S' then
        CurrText(RichEdit).Style := CurrText(RichEdit).Style + [fsUnderline]
      else
        CurrText(RichEdit).Style := CurrText(RichEdit).Style - [fsUnderline];
      CurrText(RichEdit).Size := nsFonte;
      richedit.clearselection;
      Seltext := TextoPesquisa;
    end;
    Lines.EndUpdate;
  end;
end;

procedure ExecFile(F: String);
var
  r: String;
  handle : integer;
begin
 handle := 0;
  case ShellExecute(Handle, nil, PChar(F), nil, nil, SW_SHOWNORMAL) of
    ERROR_FILE_NOT_FOUND: r := 'The specified file was not found.';
    ERROR_PATH_NOT_FOUND: r := 'The specified path was not found.';
    ERROR_BAD_FORMAT: r := 'The .EXE file is invalid (non-Win32 .EXE or error in .EXE image).';
    SE_ERR_ACCESSDENIED: r := 'Windows 95 only: The operating system denied access to the specified file.';
    SE_ERR_ASSOCINCOMPLETE: r := 'The filename association is incomplete or invalid.';
    SE_ERR_DDEBUSY: r := 'The DDE transaction could not be completed because other DDE transactions were being processed.';
    SE_ERR_DDEFAIL: r := 'The DDE transaction failed.';
    SE_ERR_DDETIMEOUT: r := 'The DDE transaction could not be completed because the request timed out.';
    SE_ERR_DLLNOTFOUND: r := 'Windows 95 only: The specified dynamic-link library was not found.';
    SE_ERR_NOASSOC: r := 'There is no application associated with the given filename extension.';
    SE_ERR_OOM: r := 'Windows 95 only: There was not enough memory to complete the operation.';
    SE_ERR_SHARE: r := 'A sharing violation occurred.';
  else
    Exit;
  end;
  ShowMessage(r);
end;

function apenas_numero(vl:string):boolean;
var
  i : integer;
begin
  result := true;
  for i := 1 to length(vl) do
    if not (vl[i] in ['0','1','2','3','4','5','6','7','8','9']) then
    begin
      result := false;
      exit;
    end;
end;

Function Verifica_Inscricao_Estadual( Inscricao, Tipo : String ) : Boolean;
Var
  Contador  : ShortInt;
  Casos     : ShortInt;
  Digitos   : ShortInt;

  Tabela_1  : String;
  Tabela_2  : String;
  Tabela_3  : String;

  Base_1    : String;
  Base_2    : String;
  Base_3    : String;

  Valor_1   : ShortInt;

  Soma_1    : Integer;
  Soma_2    : Integer;

  Erro_1    : ShortInt;
  Erro_2    : ShortInt;
  Erro_3    : ShortInt;

  Posicao_1 : string;
  Posicao_2 : String;

  Tabela    : String;
  Rotina    : String;
  Modulo    : ShortInt;
  Peso      : String;

  Digito    : ShortInt;

  Resultado : String;
  Retorno   : Boolean;

Begin

  Try

  Tabela_1 := ' ';
  Tabela_2 := ' ';
  Tabela_3 := ' ';

  {                                                                               }                                                                                                                 {                                                                                                }
  {         Valores possiveis para os digitos (j)                                 }
  {                                                                               }
  { 0 a 9 = Somente o digito indicado.                                            }
  {     N = Numeros 0 1 2 3 4 5 6 7 8 ou 9                                        }
  {     A = Numeros 1 2 3 4 5 6 7 8 ou 9                                          }
  {     B = Numeros 0 3 5 7 ou 8                                                  }
  {     C = Numeros 4 ou 7                                                        }
  {     D = Numeros 3 ou 4                                                        }
  {     E = Numeros 0 ou 8                                                        }
  {     F = Numeros 0 1 ou 5                                                      }
  {     G = Numeros 1 7 8 ou 9                                                    }
  {     H = Numeros 0 1 2 ou 3                                                    }
  {     I = Numeros 0 1 2 3 ou 4                                                  }
  {     J = Numeros 0 ou 9                                                        }
  {     K = Numeros 1 2 3 ou 9                                                    }
  {                                                                               }
  { ----------------------------------------------------------------------------- }
  {                                                                               }
  {         Valores possiveis para as rotinas (d) e (g)                           }
  {                                                                               }
  { A a E = Somente a Letra indicada.                                             }
  {     0 = B e D                                                                 }
  {     1 = C e E                                                                 }
  {     2 = A e E                                                                 }
  {                                                                               }
  { ----------------------------------------------------------------------------- }
  {                                                                               }
  {                                  C T  F R M  P  R M  P                        }
  {                                  A A  A O O  E  O O  E                        }
  {                                  S M  T T D  S  T D  S                        }
  {                                                                               }
  {                                  a b  c d e  f  g h  i  jjjjjjjjjjjjjj        }
  {                                  0000000001111111111222222222233333333        }
  {                                  1234567890123456789012345678901234567        }

  IF Tipo = 'AC'   Then Tabela_1 := '1.09.0.E.11.01. .  .  .     01NNNNNNX.14.00';
  IF Tipo = 'AC'   Then Tabela_2 := '2.13.0.E.11.02.E.11.01. 01NNNNNNNNNXY.13.14';
  IF Tipo = 'AL'   Then Tabela_1 := '1.09.0.0.11.01. .  .  .     24BNNNNNX.14.00';
  IF Tipo = 'AP'   Then Tabela_1 := '1.09.0.1.11.01. .  .  .     03NNNNNNX.14.00';
  IF Tipo = 'AP'   Then Tabela_2 := '2.09.1.1.11.01. .  .  .     03NNNNNNX.14.00';
  IF Tipo = 'AP'   Then Tabela_3 := '3.09.0.E.11.01. .  .  .     03NNNNNNX.14.00';
  IF Tipo = 'AM'   Then Tabela_1 := '1.09.0.E.11.01. .  .  .     0CNNNNNNX.14.00';
  IF Tipo = 'BA'   Then Tabela_1 := '1.08.0.E.10.02.E.10.03.      NNNNNNYX.14.13';
  IF Tipo = 'BA'   Then Tabela_2 := '2.08.0.E.11.02.E.11.03.      NNNNNNYX.14.13';
  IF Tipo = 'CE'   Then Tabela_1 := '1.09.0.E.11.01. .  .  .     0NNNNNNNX.14.13';
  IF Tipo = 'DF'   Then Tabela_1 := '1.13.0.E.11.02.E.11.01. 07DNNNNNNNNXY.13.14';
  IF Tipo = 'ES'   Then Tabela_1 := '1.09.0.E.11.01. .  .  .     0ENNNNNNX.14.00';
  IF Tipo = 'GO'   Then Tabela_1 := '1.09.1.E.11.01. .  .  .     1FNNNNNNX.14.00';
  IF Tipo = 'GO'   Then Tabela_2 := '2.09.0.E.11.01. .  .  .     1FNNNNNNX.14.00';
  IF Tipo = 'MA'   Then Tabela_1 := '1.09.0.E.11.01. .  .  .     12NNNNNNX.14.00';
  IF Tipo = 'MT'   Then Tabela_1 := '1.11.0.E.11.01. .  .  .   NNNNNNNNNNX.14.00';
  IF Tipo = 'MS'   Then Tabela_1 := '1.09.0.E.11.01. .  .  .     28NNNNNNX.14.00';
  IF Tipo = 'MG'   Then Tabela_1 := '1.13.0.2.10.10.E.11.11. NNNNNNNNNNNXY.13.14';
  IF Tipo = 'PA'   Then Tabela_1 := '1.09.0.E.11.01. .  .  .     15NNNNNNX.14.00';
  IF Tipo = 'PB'   Then Tabela_1 := '1.09.0.E.11.01. .  .  .     16NNNNNNX.14.00';
  IF Tipo = 'PR'   Then Tabela_1 := '1.10.0.E.11.09.E.11.08.    NNNNNNNNXY.13.14';
  IF Tipo = 'PE'   Then Tabela_1 := '1.14.1.E.11.07. .  .  .18ANNNNNNNNNNX.14.00';
  IF Tipo = 'PI'   Then Tabela_1 := '1.09.0.E.11.01. .  .  .     19NNNNNNX.14.00';
  IF Tipo = 'RJ'   Then Tabela_1 := '1.08.0.E.11.08. .  .  .      GNNNNNNX.14.00';
  IF Tipo = 'RN'   Then Tabela_1 := '1.09.0.0.11.01. .  .  .     20HNNNNNX.14.00';
  IF Tipo = 'RS'   Then Tabela_1 := '1.10.0.E.11.01. .  .  .    INNNNNNNNX.14.00';
  IF Tipo = 'RO'   Then Tabela_1 := '1.09.1.E.11.04. .  .  .     ANNNNNNNX.14.00';
  IF Tipo = 'RO'   Then Tabela_2 := '2.14.0.E.11.01. .  .  .NNNNNNNNNNNNNX.14.00';
  IF Tipo = 'RR'   Then Tabela_1 := '1.09.0.D.09.05. .  .  .     24NNNNNNX.14.00';
  IF Tipo = 'SC'   Then Tabela_1 := '1.09.0.E.11.01. .  .  .     NNNNNNNNX.14.00';
  IF Tipo = 'SP'   Then Tabela_1 := '1.12.0.D.11.12.D.11.13.  NNNNNNNNXNNY.11.14';
  IF Tipo = 'SP'   Then Tabela_2 := '2.12.0.D.11.12. .  .  .  NNNNNNNNXNNN.11.00';
  IF Tipo = 'SE'   Then Tabela_1 := '1.09.0.E.11.01. .  .  .     NNNNNNNNX.14.00';
  IF Tipo = 'TO'   Then Tabela_1 := '1.11.0.E.11.06. .  .  .   29JKNNNNNNX.14.00';

  IF Tipo = 'CNPJ' Then Tabela_1 := '1.14.0.E.11.21.E.11.22.NNNNNNNNNNNNXY.13.14';
  IF Tipo = 'CPF'  Then Tabela_1 := '1.11.0.E.11.31.E.11.32.   NNNNNNNNNXY.13.14';

  { Deixa somente os numeros }

  Base_1 := '';

  For Contador := 1 TO 30 Do IF Pos( Copy( Inscricao, Contador, 1 ), '0123456789' ) <> 0 Then Base_1 := Base_1 + Copy( Inscricao, Contador, 1 );

  { Repete 3x - 1 para cada caso possivel  }

  Casos  := 0;

  Erro_1 := 0;
  Erro_2 := 0;
  Erro_3 := 0;

  While Casos < 3 Do Begin

    Casos := Casos + 1;

    IF Casos = 1 Then Tabela := Tabela_1;
    IF Casos = 2 Then Erro_1 := Erro_3  ;
    IF Casos = 2 Then Tabela := Tabela_2;
    IF Casos = 3 Then Erro_2 := Erro_3  ;
    IF Casos = 3 Then Tabela := Tabela_3;

    Erro_3 := 0 ;

    IF Copy( Tabela, 1, 1 ) <> ' ' Then Begin

      { Verifica o Tamanho }

      IF Length( Trim( Base_1 ) ) <> ( StrToInt( Copy( Tabela,  3,  2 ) ) ) Then Erro_3 := 1;

      IF Erro_3 = 0 Then Begin

        { Ajusta o Tamanho }

        Base_2 := Copy( '              ' + Base_1, Length( '              ' + Base_1 ) - 13, 14 );

        { Compara com valores possivel para cada uma da 14 posiÁıes }

        Contador := 0 ;

        While ( Contador < 14 ) AND ( Erro_3 = 0 ) Do Begin

          Contador := Contador + 1;

          Posicao_1 := Copy( Copy( Tabela, 24, 14 ), Contador, 1 );
          Posicao_2 := Copy( Base_2                , Contador, 1 );

          IF ( Posicao_1  = ' '        ) AND (      Posicao_2                 <> ' ' ) Then Erro_3 := 1;
          IF ( Posicao_1  = 'N'        ) AND ( Pos( Posicao_2, '0123456789' )  =   0 ) Then Erro_3 := 1;
          IF ( Posicao_1  = 'A'        ) AND ( Pos( Posicao_2, '123456789'  )  =   0 ) Then Erro_3 := 1;
          IF ( Posicao_1  = 'B'        ) AND ( Pos( Posicao_2, '03578'      )  =   0 ) Then Erro_3 := 1;
          IF ( Posicao_1  = 'C'        ) AND ( Pos( Posicao_2, '47'         )  =   0 ) Then Erro_3 := 1;
          IF ( Posicao_1  = 'D'        ) AND ( Pos( Posicao_2, '34'         )  =   0 ) Then Erro_3 := 1;
          IF ( Posicao_1  = 'E'        ) AND ( Pos( Posicao_2, '08'         )  =   0 ) Then Erro_3 := 1;
          IF ( Posicao_1  = 'F'        ) AND ( Pos( Posicao_2, '015'        )  =   0 ) Then Erro_3 := 1;
          IF ( Posicao_1  = 'G'        ) AND ( Pos( Posicao_2, '1789'       )  =   0 ) Then Erro_3 := 1;
          IF ( Posicao_1  = 'H'        ) AND ( Pos( Posicao_2, '0123'       )  =   0 ) Then Erro_3 := 1;
          IF ( Posicao_1  = 'I'        ) AND ( Pos( Posicao_2, '01234'      )  =   0 ) Then Erro_3 := 1;
          IF ( Posicao_1  = 'J'        ) AND ( Pos( Posicao_2, '09'         )  =   0 ) Then Erro_3 := 1;
          IF ( Posicao_1  = 'K'        ) AND ( Pos( Posicao_2, '1239'       )  =   0 ) Then Erro_3 := 1;
          IF ( Posicao_1 <>  Posicao_2 ) AND ( Pos( Posicao_1, '0123456789' )  >   0 ) Then Erro_3 := 1;

        End;

        { Calcula os Digitos }

        Rotina  := ' ';
        Digitos := 000;
        Digito  := 000;

        While ( Digitos < 2 ) AND ( Erro_3 = 0 ) Do Begin

          Digitos := Digitos + 1;

          { Carrega peso }

          Peso := Copy( Tabela, 5 + ( Digitos * 8 ), 2 );

          IF Peso <> '  ' Then Begin

            Rotina :=           Copy( Tabela, 0 + ( Digitos * 8 ), 1 )  ;
            Modulo := StrToInt( Copy( Tabela, 2 + ( Digitos * 8 ), 2 ) );

            IF Peso = '01' Then Peso := '06.05.04.03.02.09.08.07.06.05.04.03.02.00';
            IF Peso = '02' Then Peso := '05.04.03.02.09.08.07.06.05.04.03.02.00.00';
            IF Peso = '03' Then Peso := '06.05.04.03.02.09.08.07.06.05.04.03.00.02';
            IF Peso = '04' Then Peso := '00.00.00.00.00.00.00.00.06.05.04.03.02.00';
            IF Peso = '05' Then Peso := '00.00.00.00.00.01.02.03.04.05.06.07.08.00';
            IF Peso = '06' Then Peso := '00.00.00.09.08.00.00.07.06.05.04.03.02.00';
            IF Peso = '07' Then Peso := '05.04.03.02.01.09.08.07.06.05.04.03.02.00';
            IF Peso = '08' Then Peso := '08.07.06.05.04.03.02.07.06.05.04.03.02.00';
            IF Peso = '09' Then Peso := '07.06.05.04.03.02.07.06.05.04.03.02.00.00';
            IF Peso = '10' Then Peso := '00.01.02.01.01.02.01.02.01.02.01.02.00.00';
            IF Peso = '11' Then Peso := '00.03.02.11.10.09.08.07.06.05.04.03.02.00';
            IF Peso = '12' Then Peso := '00.00.01.03.04.05.06.07.08.10.00.00.00.00';
            IF Peso = '13' Then Peso := '00.00.03.02.10.09.08.07.06.05.04.03.02.00';
            IF Peso = '21' Then Peso := '05.04.03.02.09.08.07.06.05.04.03.02.00.00';
            IF Peso = '22' Then Peso := '06.05.04.03.02.09.08.07.06.05.04.03.02.00';
            IF Peso = '31' Then Peso := '00.00.00.10.09.08.07.06.05.04.03.02.00.00';
            IF Peso = '32' Then Peso := '00.00.00.11.10.09.08.07.06.05.04.03.02.00';

            { Multiplica }

            Base_3 := Copy( ( '0000000000000000' + Trim( Base_2 ) ), Length( ( '0000000000000000' + Trim( Base_2 ) ) ) - 13, 14 );

            Soma_1 := 0;
            Soma_2 := 0;

            For Contador := 1 To 14 Do Begin

              Valor_1 := ( StrToInt( Copy( Base_3, Contador, 01 ) ) * StrToInt( Copy( Peso, Contador * 3 - 2, 2 ) ) );

              Soma_1  := Soma_1 + Valor_1;

              IF Valor_1 > 9 Then Valor_1 := Valor_1 - 9;

              Soma_2  := Soma_2 + Valor_1;

            End;

            { Ajusta valor da soma }

            IF Pos( Rotina, 'A2'  ) > 0 Then Soma_1 := Soma_2;
            IF Pos( Rotina, 'B0'  ) > 0 Then Soma_1 := Soma_1 * 10;
            IF Pos( Rotina, 'C1'  ) > 0 Then Soma_1 := Soma_1 + ( 5 + 4 * StrToInt( Copy( Tabela, 6, 1 ) ) );

            { Calcula o Digito }

            IF Pos( Rotina, 'D0'  ) > 0 Then Digito := Soma_1 Mod Modulo;
            IF Pos( Rotina, 'E12' ) > 0 Then Digito := Modulo - ( Soma_1 Mod Modulo);

            IF Digito < 10 Then Resultado := IntToStr( Digito );
            IF Digito = 10 Then Resultado := '0';
            IF Digito = 11 Then Resultado := Copy( Tabela, 6, 1 );

            { Verifica o Digito }

            IF ( Copy( Base_2, StrToInt( Copy( Tabela, 36 + ( Digitos * 3 ), 2 ) ), 1 ) <> Resultado ) Then Erro_3 := 1;

          End;

        End;

      End;

    End;

  End;

  { Retorna o resultado da VerificaÁ„o }

  Retorno := FALSE;

  IF ( Trim( Tabela_1 ) <> '' ) AND ( ERRO_1 = 0 ) Then Retorno := TRUE;
  IF ( Trim( Tabela_2 ) <> '' ) AND ( ERRO_2 = 0 ) Then Retorno := TRUE;
  IF ( Trim( Tabela_3 ) <> '' ) AND ( ERRO_3 = 0 ) Then Retorno := TRUE;

  IF Trim( Inscricao ) = 'ISENTO' Then Retorno := TRUE;

  Result := Retorno;

  Except

  Result := False;

End;

End;

{ Mascara_Inscricao __________________________________________________________________________________ }

Function Mascara_Inscricao_Estadual( Inscricao, Estado : String ) : String;
Var
  Mascara     : String;
  Contador_1  : Integer;
  Contador_2  : Integer;

Begin

  IF Estado = 'AC' Then Mascara := '**.***.***/***-**' ;
  IF Estado = 'AL' Then Mascara := '*********'         ;
  IF Estado = 'AP' Then Mascara := '*********'         ;
  IF Estado = 'AM' Then Mascara := '**.***.***-*'      ;
  IF Estado = 'BA' Then Mascara := '******-**'         ;
  IF Estado = 'CE' Then Mascara := '********-*'        ;
  IF Estado = 'DF' Then Mascara := '***********-**'    ;
  IF Estado = 'ES' Then Mascara := '*********'         ;
  IF Estado = 'GO' Then Mascara := '**.***.***-*'      ;
  IF Estado = 'MA' Then Mascara := '*********'         ;
  IF Estado = 'MT' Then Mascara := '**********-*'      ;
  IF Estado = 'MS' Then Mascara := '*********'         ;
  IF Estado = 'MG' Then Mascara := '***.***.***/****'  ;
  IF Estado = 'PA' Then Mascara := '**-******-*'       ;
  IF Estado = 'PB' Then Mascara := '********-*'        ;
  IF Estado = 'PR' Then Mascara := '********-**'       ;
  IF Estado = 'PE' Then Mascara := '**.*.***.*******-*';
  IF Estado = 'PI' Then Mascara := '*********'         ;
  IF Estado = 'RJ' Then Mascara := '**.***.**-*'       ;
  IF Estado = 'RN' Then Mascara := '**.***.***-*'      ;
  IF Estado = 'RS' Then Mascara := '***/*******'       ;
  IF Estado = 'RO' Then Mascara := '***.*****-*'       ;
  IF Estado = 'RR' Then Mascara := '********-*'        ;
  IF Estado = 'SC' Then Mascara := '***.***.***'       ;
  IF Estado = 'SP' Then Mascara := '***.***.***.***'   ;
  IF Estado = 'SE' Then Mascara := '*********-*'       ;
  IF Estado = 'TO' Then Mascara := '***********'       ;

  Contador_2  := 1;

  Result      := '';

  Mascara     := Mascara + '****';

  For Contador_1 := 1 To Length( Mascara ) Do Begin

    IF Copy( Mascara, Contador_1, 1 ) =  '*' Then Result := Result + Copy( Inscricao, Contador_2, 1 );
    IF Copy( Mascara, Contador_1, 1 ) <> '*' Then Result := Result + Copy( Mascara  , Contador_1, 1 );

    IF Copy( Mascara, Contador_1, 1 ) =  '*' Then Contador_2 := Contador_2 + 1;

  End;

  Result := Trim( Result );

End;

function CountWords(InputString: string): integer;
var
  aChar: char;
  WordCount: integer;
  IsWord: boolean;
  i: integer;
begin
  WordCount := 0;
  IsWord := False;
  for i := 0 to Length(InputString) do
  begin
    aChar := InputString[i];
    if (aChar in [
                  'a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s',
                  't','u','v','w','x','y','z',
                  'A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S',
                  'T','U','V','W','X','Y','Z',
                  '0','1','2','3','4','5','6','7','8','9','0','''','-'
                 ]) then
    begin
      if not IsWord then Inc(WordCount);
        IsWord := True;
    end
    else if aChar = '\' then IsWord := True
    else IsWord := False
  end;
  Result := WordCount;
end;


function CentralizarString(texto:string; Tamanho:integer):string;
var
  esquerda, direita: string;
begin
  esquerda := stringofchar(' ', (tamanho - length(texto)) div 2);
  direita  := stringofchar(' ', tamanho - length(texto) - (tamanho - length(texto)) div 2);
  result := esquerda+texto+direita;
end;

// Executa um aplicativo, j· abrindo um arquivo anexo
// --------------------------------------------------------------------------------
function ExecFile(const FileName, Params, DefaultDir: string;ShowCmd: Integer): THandle;
// DefautDir: Diretorio onde ele ir· trabalhar
// ShowCmd:  1 = Normal
//           2 = Minimizado
//           3 = Tela Cheia
var
zFileName, zParams, zDir: array[0..79] of Char;
begin
Result := ShellExecute(Application.MainForm.Handle,
                       nil,StrPCopy(zFileName, FileName), StrPCopy(zParams, Params),
                       StrPCopy(zDir, DefaultDir), ShowCmd);
end;

function StrRepl(sString: String; sSearch: String; sReplace: String): String;
begin
  result := '';
  while Pos(sSearch,sString) > 0 do
  begin
    Result := Result + Copy(sString,1,Pos(sSearch,sString )-1);
    Result := Result + sReplace;
    Delete(sString,1,Pos(sSearch,sString)+Length(sSearch)-1);
  end;
  Result := Result + sString;
end;

function ChrCount(const sSearchFor: String; sString: String): Integer;
begin
  Result := 0;
  while Pos(sSearchFor, sString) > 0 do
  begin
    sString := Copy(sString,Pos(sSearchFor, sString)+1,Length(sString));
    Result := Result + 1
  end
end;


function QuebraString(sString: String;nLength: Integer;nIndex: Integer): String;
var
  NewString: String;
  function CharSpread(xString: String;xLength: Integer): String;
  var nQtdeSpace, nOldQtde, nPos: Integer;
  begin
    nQtdeSpace := xLength - Length(xString);
    while Length(xString) < xLength do
    begin
      nOldQtde := nQtdeSpace;
      if nQtdeSpace > 0 then
      begin
        nPos := Pos(' ',xString);
        if nPos > 0 then
        begin
          xString[nPos] := '_';
          Insert('_',xString,nPos);
          nQtdeSpace := nQtdeSpace - 1;
        end;
      end;
      if nQtdeSpace >  0 then
      begin
        nPos := LastDelimiter(' ',xString);
        if nPos > 0 then
        begin
          xString[nPos] := '_';
          Insert('_',xString,nPos);
          nQtdeSpace := nQtdeSpace - 1;
        end;
      end;
      if nQtdeSpace = nOldQtde then
      begin
        if ChrCount('_',xString) > 0 then
          xString := StrRepl(xString,'_',' ')
        else
          xString := fPad(xString,xLength);
      end;
    end;
    Result := StrRepl(xString,'_',' ');
  end;

begin
  newString := '';
  while Length(sString) > nLength do
  begin
    if isDelimiter(' ',sString,nLength) then
    begin
      NewString := NewString + CharSpread(Copy(sString,1,nLength-1),nLength);
      sString := Copy(sString,nLength+1,Length(sString));
    end;
    if isDelimiter(' ',sString,nLength+1) then
    begin
      NewString := NewString + CharSpread(Copy(sString,1,nLength),nLength);
      sString := TrimLeft(Copy(sString,nLength+1,Length(sString)));
    end;
    if Pos(' ',sString) > 0 then
    begin
      NewString := NewString + CharSpread(Copy(sString,1,LastDelimiter(' ',Copy(sString,1,nLength))-1),nLength);
      sString := Copy(sString, (LastDelimiter(' ',Copy(sString,1,nLength))+1),Length(sString));
    end
    else
    begin
      NewString := NewString + sString;
      sString := ''
    end;
  end;
  NewString := NewString + fPad(sString,nLength);
  Result := Copy(NewString,(1+(nLength*(nIndex-1))),nLength);
end;

function fSpace(Count: Integer): String;
begin
  Result := StringOfChar(' ',Count);
end;

function fPad(sString: String; Count: Integer): String;
begin
  Result := sString + fSpace(Count);
  Result := Copy(Result,1,Count);
end;

function flPad(sString: String; Count: Integer): String;
begin
  Result := fSpace(Count) + sString;
  Result := Copy(Result,Length(Result)+1-Count,Count);
end;

function fNVL(pValue: Variant;pDefault: Variant): Variant;
begin
  Result := pValue;
  if pValue = null then Result := pDefault;
end;

function StrZero(sSource: String; Len: Integer): String;
var iCount: Integer;
begin
  Result := Trim(sSource);
  for iCount := 1 to (Len-Length(Result)) do
    Result := ('0'+Result);
end;

function RemoveUltimoCaracter(sString: String): String;
begin
  result := '';
  Delete(sString, length(sSTring), 1);
  Result := Result + sString;
end;

function ValorIpi(qtitem, vlunitario, pripi:currency):currency;
begin
  result := Truncar(((QTITEM / 1000) * VLUNITARIO) * ( 1 + (pripi/ 100)) - ((QTITEM / 1000) * VLUNITARIO));
end;

function ValorIcms(qtitem, vlunitario, pricms:currency):currency;
begin
  result := Truncar(((QTITEM / 1000) * VLUNITARIO) * ( 1 + (pricms/ 100)) - ((QTITEM / 1000) * VLUNITARIO));
end;

function RemUCaracter(sString: String): String;
begin
  result := '';
  Delete(sString, length(sSTring), 1);
  Result := Result + sString;
end;

function RemoverEspacosVazios(Texto:string):string;
var
  i : integer;
begin
  for i := length(texto) downto 1 do
    if texto[i] <> ' ' then
    begin
      result := copy (texto, 1, i);
      break;
    end;
end;

procedure CriaDiretorio(NomeDir: String);
var
  dir, CriarDir, Pasta: String;
  n, ErrCode: Integer;
begin
  dir := NomeDir;
  if dir[Length(dir)] <> '\' then
    dir := dir + '\';
  CriarDir := '';
  while dir <> '' do
  begin
    n := Pos('\', dir);
    Pasta := Copy(dir, 1, n - 1);
    Delete(dir, 1, n);
    CriarDir := CriarDir + Pasta;
    if not DirectoryExists(CriarDir) then
    begin
      {$I-}
      MkDir(CriarDir);
      {$I+}
      ErrCode := IOResult;
      if ErrCode <> 0 then
        raise Exception.Create('N„o foi possÌvel criar o diretÛrio "' + NomeDir +
          '". CÛdigo do erro: ' + IntToStr(ErrCode) + '.');
    end;
    CriarDir := CriarDir + '\';
  end;
end;

procedure PrintForm(frm: TForm);
var
  bmp: TBitMap;
  x, y, WDPI, HDPI: Integer;
  OldColor: TColor;
begin
  Screen.Cursor := crHourGlass;
  OldColor := frm.Color;
  frm.Color := clWhite;
  frm.Update;
  bmp := frm.GetFormImage;
  with Printer do
  begin
    Orientation := poLandscape;
    BeginDoc;
    HDPI := PageHeight div 8;
    WDPI := PageWidth div 8;
    x := PageWidth - Round(WDPI * 0.4);  //0.4" margem direita
    y := PageHeight - Round(HDPI * 0.5); //0.5" Altura do rodapÈ
    Canvas.StretchDraw(Rect(0, 0, x, y), bmp);
    EndDoc;
  end;
  bmp.Free;
  frm.Color := OldColor;
  Screen.Cursor := crDefault;
end;

procedure ApenasCaracteresAlfaNumericos(var key:char);
begin
  if not (key in ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9',
                  'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J',
                  'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T',
                  'U', 'V', 'X', 'Z', 'W', 'Y',
                  char(8), char(13)]) then  key := #0;
  if key in ['-', ' '] then
    key := #0;
end;

function RetiraAcentos(txt: String): String;
var
  i: Integer;
begin
  Result := txt;
  for i := 1 to Length(Result) do
  case Result[i] of
    '·', '‡', '‚', '‰', '„': Result[i] := 'a';
    '¡', '¿', '¬', 'ƒ', '√': Result[i] := 'A';
    'È', 'Ë', 'Í', 'Î': Result[i] := 'e';
    '…', '»', ' ', 'À': Result[i] := 'E';
    'Ì', 'Ï', 'Ó', 'Ô': Result[i] := 'i';
    'Õ', 'Ã', 'Œ', 'œ': Result[i] := 'I';
    'Û', 'Ú', 'Ù', 'ˆ', 'ı': Result[i] := 'o';
    '”', '“', '‘', '÷', '’': Result[i] := 'O';
    '˙', '˘', '˚', '¸': Result[i] := 'u';
    '⁄', 'Ÿ', '€', '‹': Result[i] := 'U';
    'Á': Result[i] := 'c';
    '«': Result[i] := 'C';
  end;
end;

function AbreviaNome(Nome: String): String;
var
  Nomes: array[1..20] of string; 
  i, TotalNomes: Integer; 
begin 
  Nome := Trim(Nome); 
  Result := Nome;
  Nome := Nome + #32;   {Insere um espaÁo para garantir que todas as letras sejam testadas}
  i := Pos(#32, Nome);   {Pega a posiÁ„o do primeiro espaÁo}
  if i > 0 then
  begin
    TotalNomes := 0;
    while i > 0 do      {Separa todos os nomes}
    begin
      Inc(TotalNomes);
      Nomes[TotalNomes] := Copy(Nome, 1, i - 1);
      Delete(Nome, 1, i);
      i := Pos(#32, Nome);
    end;
    if TotalNomes > 2 then
    begin
      for i := 2 to TotalNomes - 1 do {Abreviar a partir do segundo nome, exceto o ˙ltimo.}
      begin
        if Length(Nomes[i]) > 3 then {ContÈm mais de 3 letras? (ignorar de, da, das, do, dos, etc.)}
          Nomes[i] := Nomes[i][1] + '.'; {Pega apenas a primeira letra do nome e coloca um ponto apÛs.} 
      end; 
      Result := ''; 
      for i := 1 to TotalNomes do
        Result := Result + Trim(Nomes[i]) + #32; 
      Result := Trim(Result); 
    end; 
  end; 
end; 

//--------------------- Verifica se uma data informada cai em um final de semana
function IsWeekEnd(dData : TDateTime) : boolean;
begin
  if DayOfWeek(dData) in [1,7] then
    result := true
  else
    result := false;
end;

//-------------- Retorna data do primeiro dia Util do mes, de uma data informada
function PrimeiroDiaUtil(Data:TDateTime):TDateTime;
var Ano, Mes, Dia : word;
DiaDaSemana : Integer;
begin
  DecodeDate (Data, Ano, Mes, Dia);
  Dia := 1;
  DiaDaSemana := DayOfWeek(Data);
  if DiaDaSemana in [1,7] then
    Dia := 2;
  Result := EncodeDate(Ano, Mes, Dia);
end;

//------------------------------------------------ Retorna uma data por extenso
function DataExtenso(Data:TDateTime): String;
var
  NoDia : Integer;
  DiaDaSemana : array [1..7] of String;
  Meses : array [1..12] of String;
  Dia, Mes, Ano : Word;
begin
{ Dias da Semana }
  DiaDasemana [1]:= 'Domingo';
  DiaDasemana [2]:= 'Segunda-feira';
  DiaDasemana [3]:= 'TerÁa-feira';
  DiaDasemana [4]:= 'Quarta-feira';
  DiaDasemana [5]:= 'Quinta-feira';
  DiaDasemana [6]:= 'Sexta-feira';
  DiaDasemana [7]:= 'S·bado';
{ Meses do ano }
  Meses [1] := 'Janeiro';
  Meses [2] := 'Fevereiro';
  Meses [3] := 'MarÁo';
  Meses [4] := 'Abril';
  Meses [5] := 'Maio';
  Meses [6] := 'Junho';
  Meses [7] := 'Julho';
  Meses [8] := 'Agosto';
  Meses [9] := 'Setembro';
  Meses [10]:= 'Outubro';
  Meses [11]:= 'Novembro';
  Meses [12]:= 'Dezembro';

  DecodeDate (Data, Ano, Mes, Dia);
  NoDia := DayOfWeek (Data);
  Result := DiaDaSemana[NoDia] + ', ' +
            IntToStr(Dia) + ' de ' + Meses[Mes]+ ' de ' + IntToStr(Ano);
end;

//----------------------------------- Retorna o nome de um mÍs abreviado ou n„o
function  NameMonth(Mes:Word;Abrev:Boolean):String;
const
  NameL : array [1..12] of String[9] = ('JANEIRO','FEVEREIRO','MAR«O','ABRIL',
                                        'MAIO','JUNHO','JULHO','AGOSTO',
                                        'SETEMBRO','OUTUBRO','NOVEMBRO',
                                        'DEZEMBRO');
begin
  if (Mes in [1..12]) then
    if Abrev then
      Result := Copy(NameL[Mes],1,3)
    else
      Result := NameL[Mes];
end;

//------------------------- Retorna 6 meses atr·s da data enviada, de mes em mes
function ReturnSixMonth(Actual:TDateTime):Semestre;
var
  d,m,y : word;
  i : byte;
  Data : TDateTime;
begin
  for i := 6 downto 1 do begin
    Data := Actual - (30 * i);
    DecodeDate(Data,y,m,d);
    Result[i].Mes := m;
    Result[i].Ano := y;
  end;
end;

//------------------------- Verifica se o n˙mero È do tipo inteiro
function IsInteger(numero:string):boolean;
begin
  result := true;
  try
    numero := inttostr(StrToInt(numero));
  except
    on exception do
      result := false;
  end;
end;

function PortaImpressora(chave:string):string;
var
  Reg : TRegistry;
begin
  Reg := TRegistry.Create;
  try
    reg.rootkey := HKEY_CURRENT_USER;
    if Reg.KeyExists(chave) then
    begin
      reg.OpenKey(chave, true);
      if reg.ValueExists('Porta Impressora')  then result := reg.ReadString('Porta Impressora')
      else
      begin
        reg.WriteString('Porta Impressora'   , 'LPT1');
        result := 'LPT1';
      end;
    end;
  finally
    reg.closekey;
    reg.free;
  end;
end;

procedure WriteStatusBar(ACanvas:TCanvas; Rect:TRect; atext:string; fontcolor, backgroundcolor:TColor);
begin
  with ACanvas do
  begin
    Brush.Color := backgroundcolor;
    Brush.Style := bssolid;
    FillRect(Rect);

    Font.Color := fontcolor;
    SetBkMode(Handle, TRANSPARENT);

    DrawText(Handle, PChar(atext), length(atext), Rect, DT_CENTER or DT_SINGLELINE or DT_VCENTER);
  end;
end;

procedure WriteStatusBar(ACanvas:TCanvas; Rect:TRect; atext:string; fontcolor:TColor);
begin
  with ACanvas do
  begin
//    Brush.Color := clwhite;
    Brush.Style := bssolid;
    FillRect(Rect);

    Font.Color := fontcolor;
    SetBkMode(Handle, TRANSPARENT);

    DrawText(Handle, PChar(atext), length(atext), Rect, DT_CENTER or DT_SINGLELINE or DT_VCENTER);
  end;
end;

function removercaracteres(texto : string):string;
var
  i : integer;
begin
  result := '';
  for i := 1 to length(texto) do
  begin
    if texto[i] in ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'] then
      result := result + texto[i];
  end;
end;

{ Usada no componente TEdit, ou seus descendentes DB, etc.
  passse o parametro Sender e key da seguinte forma:

  procedure TForm1.Edit1KeyPress(Sender: TObject; var Key: Char);
  begin
    DigitaData(sender, key);
  end;
  }
procedure DigitaData(Sender:TObject; var Key: Char);
var x, numbarras : integer ;
begin
  if key <> #8 then
  begin
    if Sender is Tdbedit then
    begin
      if (length(trim(Tdbedit(sender).text)) >= 10) or (not (Key in ['0'..'9', '/', #8])) then
      begin
        Key := #0 ;
        exit ;
      end;
      numbarras := 0 ;
      for x := 1 to length(trim(Tdbedit(sender).text)) do
      begin
        if copy(trim(Tdbedit(sender).text),x,1) = '/' then
          numbarras := numbarras + 1 ;
      end;
      if numBarras <2 then
      begin
        if length(trim(Tdbedit(sender).text)) = 2  then
        begin
          Tdbedit(sender).text := Tdbedit(sender).text + '/' ;
          Tdbedit(sender).SelStart := length(trim(Tdbedit(sender).text)) ;
        end;
        if length(trim(Tdbedit(sender).text)) = 5  then
        begin
          Tdbedit(sender).text := Tdbedit(sender).text + '/' ;
          Tdbedit(sender).SelStart := length(trim(Tdbedit(sender).text)) ;
        end;
      end;
      if (copy(Tdbedit(sender).text,length(Tdbedit(sender).text),1) = '/') and (key = '/') then
        Key := #0 ;
      exit ;
    end;
    if Sender is Tedit then
    begin
      if (length(trim(Tedit(sender).text)) >= 10) or (not (Key in ['0'..'9', '/', #8])) then
      begin
        Key := #0 ;
        exit ;
      end;
      numbarras := 0 ;
      for x := 1 to length(trim(Tedit(sender).text)) do
      begin
        if copy(trim(Tedit(sender).text),x,1) = '/' then
          numbarras := numbarras + 1 ;
      end;
      if numBarras <2 then
      begin
        if length(trim(Tedit(sender).text)) = 2  then
        begin
          Tedit(sender).text := Tedit(sender).text + '/' ;
          Tedit(sender).SelStart := length(trim(Tedit(sender).text)) ;
        end;
        if length(trim(Tedit(sender).text)) = 5  then
        begin
          Tedit(sender).text := Tedit(sender).text + '/' ;
          Tedit(sender).SelStart := length(trim(Tedit(sender).text)) ;
        end;
      end;
      if (copy(Tedit(sender).text,length(Tedit(sender).text),1) = '/') and (key = '/') then
        Key := #0 ;
    end;
  end;
end;

function Truncar(valor:currency):currency;
begin
  result    := valor;
  result    := result * 1000;
  if result - trunc(result) >= 0.5 then
    result := result + 1;
  result := trunc(result);
  result := result / 1000;
  result    := result * 100;
  if result - trunc(result) >= 0.5 then
    result := result + 1;
  result := trunc(result);
  result := result / 100;
end;

function Truncar2(valor:currency):currency;
begin
  // truncar 2 casa
  result    := valor;
  result    := result * 100;
  if result - trunc(result) >= 0.5 then
    result := result + 1;
  result := trunc(result);
  result := result / 100;
end;

function Truncarinteiro(valor:currency):integer;
begin
  valor := valor * 10;
  if valor - trunc(valor) >= 0.5 then
    valor := valor + 1;
  result := trunc(valor);
  result := result div 10;
end;

function RemoverChar (texto:string; simbolo : char):string;
var
  posicao : integer;
begin
  while pos(simbolo, texto) > 0 do
  begin
    posicao := pos(simbolo, texto);
    delete(texto, posicao, 1);
  end;
  result := texto;
end;

function RemoveSimbolos (numero:string):string;
var
  j :integer;
  new : string;
begin
  for j := 1 to length(numero) do
  begin
    if numero[j] in ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9']  then
      new := new + numero[j];
  end;
  result := new;
end;

function RepeteChar(C:char;N:Integer):string;
var
  I :integer;
begin
  if n < 1 then
  begin
    result := '';
    exit;
  end;
  for i := 1 to N do
    result := result + c;
end;

function AppIsRunning: Boolean;
var
  hSem : THandle;
  AppTitle: string;
begin
  Result := False;
  AppTitle := Application.Title;
  hSem := CreateSemaphore(nil, 0, 1, pChar(AppTitle));
  if ((hSem <> 0) AND (GetLastError() = ERROR_ALREADY_EXISTS)) then
  begin
    CloseHandle(hSem);
    Result := True;
  end;
end;

Function NomeComputador : String;
var
  lpBuffer : PChar;
  nSize    : DWord;
const
  Buff_Size = MAX_COMPUTERNAME_LENGTH + 1;
begin
  nSize := Buff_Size;
  lpBuffer := StrAlloc(Buff_Size);
  GetComputerName(lpBuffer,nSize);
  Result := String(lpBuffer);
  StrDispose(lpBuffer);
end;

function LimpaAcentos(S: String): String;
var
  Acentos1, Acentos2 : String;
  i, Aux : Integer;
begin
  Acentos1 := '¡Õ”⁄… ƒœ÷‹À ¿Ã“Ÿ» √’ ¬Œ‘€  ·ÌÛ˙È ‰Ôˆ¸Î ‡ÏÚ˘Ë „ı ‚ÓÙ˚Í «Á';
  Acentos2 := 'AIOUE AIOUE AIOUE AO AIOUE aioue aioue aioue ao aioue Cc';
  for i := 0 to Length(S)-1 do
  begin
    Aux := Pos(S[i], Acentos1);
    if (aux > 0) then S[i] := Acentos2[Aux];
  end;
  Result := S;
end;

function VerificaCNPJ(CPNJ: string): Boolean;
var
  S: String;
  Soma: Integer;
  iPos, Fator, i: Integer;
  iDig: Integer;
begin
   Result := False;
   S := CPNJ;
   { remove os simbolos especiais }
   s := RemoveSimbolos(S);
   { verifica o CPNJ possui 14 digitos }
   if Length(S) <> 14 then Exit;
   { calcula os 2 ˙ltimos dÌgitos }
   for iPos := 12 to 13 do
   begin
      Soma := 0;
      Fator := 2;
      for i := iPos downto 1 do
      begin
        Soma := Soma + StrToInt(S[i]) * Fator;
        Inc(Fator);
        if Fator > 9 then Fator := 2;
      end;
      iDig := 11 - (Soma mod 11);
      if iDig > 9 then iDig := 0;
      { verifica os digitos com o forncedido }
      if iDig <> StrToInt(S[iPos + 1]) then
        Exit;
   end;
   Result := True;
end;

function VerificaCPF(CPF: string): Boolean;
var
  S: String;
  Soma: Integer;
  iPos, Fator, i: Integer;
  iDig: Integer;
begin
   Result := False;
   S := CPF;
   { remove os simbolos especiais }
   s := RemoveSimbolos(S);
   { verifica o CPF possui 11 digitos }
   if Length(S) <> 11 then Exit;
   { calcula os 2 ˙ltimos dÌgitos }
   for iPos := 9 to 10 do
   begin
      Soma := 0;
      Fator := 2;
      for i := iPos downto 1 do
      begin
        Soma := Soma + StrToInt(S[i]) * Fator;
        Inc(Fator);
      end;
      iDig := 11 - Soma mod 11;
      if iDig > 9 then iDig := 0;
      { verifica os digitos com o forncedido }
      if iDig <> StrToInt( S[iPos + 1]) then
        Exit;
   end;
   Result := True;
end;

function AddChrF(Texto:string; FChar:Char; Nvezes:integer):string;
begin
  while length(texto)   <  nvezes do texto := Texto + FChar;
  result := texto;
end;

function AddChrI(Texto:string; IChar:Char; Nvezes:integer):string;
begin
  while length(texto)   <  nvezes do texto := IChar + Texto;
  result := texto;
end;

Function Extenso(Valor : Extended; Monetario:Boolean): String;
Var
  Centavos, Centena, Milhar, Milhao, Bilhao, Texto : String;
  X : Byte;
Const
  Unidades: array [1..9] of string[10] =
  ('um', 'dois', 'trÍs', 'quatro','cinco','seis', 'sete', 'oito','nove');
  Dez     : array [1..9] of string[12] =
  ('onze', 'doze', 'treze','quatorze', 'quinze','dezesseis', 'dezessete','dezoito', 'dezenove');
  Dezenas : array [1..9] of string[12] =
  ('dez', 'vinte', 'trinta','quarenta', 'cinquenta','sessenta', 'setenta','oitenta', 'noventa');
  Centenas: array [1..9] of string[20] =
  ('cento', 'duzentos','trezentos', 'quatrocentos','quinhentos', 'seiscentos','setecentos','oitocentos', 'novecentos');

  Function Ifs( Expressao: Boolean; CasoVerdadeiro, CasoFalso: String): String;
  Begin
    If Expressao then Result := CasoVerdadeiro else Result := CasoFalso;
  end;

  Function MiniExtenso( Valor: String ): String;
  Var
    Unidade, Dezena, Centena: String;
  Begin
    Unidade := '';
    Dezena  := '';
    Centena := '';
    If (Valor[2] = '1') and (Valor[3] <> '0') then
    Begin
      Unidade := Dez[StrToInt(Valor[3])];
      Dezena  := '';
    End
    Else
    Begin
      If Valor[2] <> '0' Then Dezena  := Dezenas[StrToInt(Valor[2])];
      If Valor[3] <> '0' then Unidade := Unidades[StrToInt(Valor[3])];
    end;
    If (Valor[1] = '1') and (Unidade = '') and (Dezena = '') then
      Centena := 'cem'
    Else If Valor[1] <> '0' then
      Centena := Centenas[StrToInt(Valor[1])]
    Else
      Centena := '';
    Result := Centena +
    Ifs((Centena <> '') and ((Dezena <> '') or (Unidade <> '')),' e ', '') + Dezena +
    Ifs((Dezena  <> '') and (Unidade <> ''), ' e ', '') + Unidade;
  end;
Begin
  If Valor = 0 Then
  Begin
    Result := 'Zero';
    Exit;
  End;
  Texto    := FormatFloat( '000000000000.00', Valor );
  Centavos := MiniExtenso( '0' + Copy( Texto, 14, 2 ) );
  Centena  := MiniExtenso(       Copy( Texto, 10, 3 ) );
  Milhar   := MiniExtenso(       Copy( Texto,  7, 3 ) );
  If Milhar <> '' then Milhar := Milhar + ' mil';
  Milhao := MiniExtenso( Copy( Texto, 4, 3 ) );
  If Milhao <> '' then Milhao := Milhao + ifs( Copy( Texto, 4, 3 ) = '001', ' milh„o',' milhıes');
  Bilhao := MiniExtenso( Copy( Texto, 1, 3 ) );
  If Bilhao <> '' then Bilhao := Bilhao + ifs( Copy( Texto, 1, 3 ) = '001', ' bilh„o',' bilhıes');
  If Monetario Then
  Begin
    If (Bilhao <> '') and (Milhao + Milhar + Centena = '') then
      Result := Bilhao + ' de Reais '
    Else If (Milhao <> '') and (Milhar + Centena = '') then
      Result := Milhao + ' de Reais '
    Else
      Result := Bilhao +
       ifs( (Bilhao <> '') and (Milhao + Milhar + Centena <> ''),
        ifs((Pos(' e ', Bilhao) > 0) or (Pos( ' e ', Milhao + Milhar + Centena ) > 0 ), ', ', ' e '), '') +
       Milhao +
       ifs( (Milhao <> '') and (Milhar + Centena <> ''), ifs((Pos(' e ', Milhao) > 0) or
        (Pos( ' e ', Milhar + Centena ) > 0 ), ', ',' e '), '') +
       Milhar + ifs( (Milhar <> '') and (Centena <> ''),ifs(Pos( ' e ', Centena ) > 0, ', ', ' e '), '') +
       Centena +
       ifs( Int(Valor) = 0, '', (ifs( Int(Valor) = 1, ' Real ', ' Reais ' )));
    If (Result <> '') and (Centavos <> '') then
      Result := Result + ' e '
    else
      Result := Result ;
    If Centavos <> '' then
      Result := Result + Centavos +
    ifs( Copy( Texto, 14, 2 )= '01', ' Centavo ', ' Centavos ' );
//    For X := 1 To 250 Do Result := Result + '*. ';
    For X := 1 To 250 Do Result := Result + '*';
  End
  Else
  Begin
    Result := Bilhao + ifs( (Bilhao <> '') and (Milhao + Milhar + Centena <> ''),
                       ifs((Pos(' e ', Bilhao) > 0) or (Pos( ' e ', Milhao + Milhar + Centena ) > 0 ), ', ', ' e '), '') +
              Milhao + ifs( (Milhao <> '') and (Milhar + Centena <> ''),
                       ifs((Pos(' e ', Milhao) > 0) or
                          (Pos( ' e ', Milhar + Centena ) > 0 ), ', ',' e '), '') +
              Milhar + ifs( (Milhar <> '') and (Centena <> ''),
                       ifs(Pos( ' e ', Centena ) > 0, ', ', ' e '), '') +
              Centena;
    If Centavos <> '' then Result := Result + ' e ' + Centavos;
  End;
  if copy(result, 1, 3) = 'um ' then
    result := 'H'+result
  else
    result := uppercase(result[1])+copy(result, 2, length(result) -1);
end;

function ExisteString(StrText: string; strChar: char): boolean;
var
  i : integer;
begin
  result := false;
  if strtext = '' then exit;
  for i := 0 to length(strText) do
    if strText[i] = strChar then
    begin
      result := true;
      exit;
    end;
end;

function FillString (StrChar: char; qtd: integer): string;
var
  i : integer;
begin
  result := '';
  for i := 0 to qtd do
    result := result + strChar;
end;

function ContarString(StrText : string; StrChar:char): integer;
var
  i : integer;
begin
  result := 0;
  for i := 0 to length(strText) do
    if strText[i] = strChar then
      result := result + 1;
end;

function espaco(valor:integer):string;
var
  linha : string;
  i : integer;
begin
  for i := 1 to valor do
  begin
    linha := linha + ' ';
  end;
  result := linha;
end;

function substituir (texto: string; velho: string; novo: char):string;
var
  i : integer;
begin
  for i := 0 to length(texto) do
    if texto[i] = velho then texto[i] := novo;
  result := texto;
end;

function substituir (texto, velho, novo: string):string;
var
  i : integer;
begin
  i := pos(velho, texto);
  delete(texto, i, length(velho));
  Insert(novo, texto, i);
  result := texto;
end;

Function GetNetWorkUserName:string;
var
   buffer : array[0..128] of char;
   l      : dword;
begin
   l := SizeOf(buffer);
   GetUserName (buffer,l);
   if l>0 then
      result := StrPas(buffer)
   else
      result := 'GUEST';
end;

function LeRegistroSistema : string;
var
 Reg  :TRegistry;
begin
 Reg := TRegistry.Create;
 Reg.RootKey := HKEY_CURRENT_USER;
 if Reg.OpenKey('\SOFTWARE\P4INFORMATICA\CORPORE',false) then
  begin
   RegCaminho   := Reg.ReadString('Caminho');
   RegProtocolo := Reg.ReadString('Protocolo');
   RegUsuario   := Reg.ReadString('Usu·rio');
   RegSenha     := Reg.ReadString('Senha');
   RegServidor  := Reg.ReadString('Servidor');
   RePortaImp   := Reg.ReadString('Porta Impressora');
   if RegProtocolo = 'LOCAL' then
    begin
     RegConexao := RegCaminho;
    end;
    if RegProtocolo = 'NETBEUI' then
     begin
      RegConexao := '\\'+RegServidor+'\'+RegCaminho;
      end;
      if RegProtocolo = 'TCP/IP'then
       begin
        RegConexao := RegServidor+':'+RegCaminho;
       end;
       if RegProtocolo = 'IPX/SPX' then
        begin
         RegConexao := RegServidor+'@'+RegCaminho;
        end;
  end;
end;

{Verifica configuraÁıes conforme a tabela de registro!!!}
procedure InicializaValores();
var
 qryTmpRegistro:TIBODataset;
begin
 try
  qryTmpRegistro := TIBODataset.Create(nil);
   qryTmpRegistro.Close;
   with qryTmpRegistro.SQL do
    begin
     Clear;
     Add('SELECT * FROM REGISTRO');
    end;
    qryTmpRegistro.Open;
    Empresa           := qryTmpRegistro.FieldByName('NMEMPRESA').AsString;
    MensagemCupom     := qryTmpRegistro.FieldByName('DSCONFIGIMPMENSAGEM').AsString;
    InformaQtd        := qryTmpRegistro.FieldByName('BOLINFORMAQUANTIDADE').AsString;
    BolDigCodBarras   := qryTmpRegistro.FieldByName('BOLREJEITADIGITOCODBARRAS').AsString;
    BolGeraReferencia := qryTmpRegistro.FieldByName('BOLGERARREFERENCIA').AsString;
 finally
  FreeAndNil(qryTmpRegistro);
 end;
end;

function Converte_String_Inteiro(valor:string):Double;
begin
 Result := 0;
 try
  Result := StrToFloat(valor);
 except
  On Exception do
   begin
    MessageDlg('Erro ao Converter "String" Para "Inteiro".',MtError,[MbOk],0);
    Abort;
   end;
 end;
end;

function Substitui(Texto:string;Atual:string;Novo:String):String;
var
 Posicao:integer;
begin
 if Texto = '' then
  Texto := '0';
 Posicao := Pos(Atual,Texto);
 while Pos(Atual,Texto) > 0 do
  begin
   Delete(Texto,Posicao,1);
   Insert(Novo,Texto,Posicao);
   Posicao := Pos(Atual,Texto);
  end;
  Result := Texto;
end;

function Inserir_Unidade_Medida(conmain:TIB_Connection; nome:string;nomereduzido:string):Integer;
var
 sql,
 scdunidade : string;
 icdunidade : integer;
begin
 //icdunidade := GerarCodigo(conmain,'UNIDADE');
 Result     := icdunidade;
 scdunidade := IntToStr(icdunidade);
 sql := 'INSERT INTO UNIDADE(CDUNIDADE, NMUNIDADE, NMREDUZIDO, USUINCLUSAO, COMPINCLUSAO, USUALTERACAO, COMPALTERACAO)'+
        ' VALUES('+scdunidade+','''+nome+''', '''+nomereduzido+''', ''MIGRACAO'', ''MIGRACAO'',''MIGRACAO'',''MIGRACAO'')';
// ExecutaSQL(conmain,sql);
end;

function Inserir_Aliquota(conmain:TIB_Connection; nome:string;nomereduzido:string;tptributacao:string; vlaliquota:string):Integer;
var
 sql,
 scdaliquota : string;
 icdaliquota : integer;
begin
// icdaliquota  := GerarCodigo(conmain,'ALIQUOTA');
 Result      := icdaliquota;
 scdaliquota := IntToStr(icdaliquota);
 sql := 'INSERT INTO ALIQUOTA(CDALIQUOTA, NMALIQUOTA, NMREDUZIDO, CDTPTRIBUTACAO, VLALIQUOTA, USUINCLUSAO, COMPINCLUSAO, USUALTERACAO, COMPALTERACAO)'+
        ' VALUES('+scdaliquota+','''+nome+''', '''+nomereduzido+''',1,'''+nome+''', ''MIGRACAO'', ''MIGRACAO'',''MIGRACAO'',''MIGRACAO'')';
// ExecutaSQL(conmain,sql);
end;


function  Retorna_Aliquota_Somente(valor:String):String;
var
 qryTmp:TIB_Query;
 sql,saliquota:string;
begin
 Result := '';
 sql := ' SELECT CDALIQUOTA, NMALIQUOTA FROM ALIQUOTA  '+
        ' WHERE VLALIQUOTA = '''+RetiraArgumento(' ',valor)+'''             ';
 try
  qryTmp := TIB_Query.Create(nil);
  qryTmp.SQL.Add(sql);
  qryTmp.Open;
  if qryTmp.IsEmpty then saliquota := ''
  else  saliquota := qryTmp.FieldByName('CDALIQUOTA').AsString;
   Result := saliquota;
 finally
  FreeAndNil(qryTmp);
 end;
end;


function  Retorna_Unidade_Medida(valor:string):String;
var
 qryTmp: TIB_Query;
 sql   : string;
begin
 Result := '';
 sql := ' SELECT CDUNIDADE, NMREDUZIDO     '+
        ' FROM UNIDADE                     '+
        ' WHERE NMREDUZIDO = '''+valor+''' ';
 try
  qryTmp := TIB_Query.Create(nil);
  qryTmp.SQL.Add(sql);
  qryTmp.Open;
   Result := qryTmp.Fields[0].AsString;
 finally
  FreeAndNil(qryTmp);
 end;
end;


function  Retorna_Unidade_Sigla(valor:string):String;
var
 qryTmp: TIB_Query;
 sql   : string;
begin
 Result := '';
 sql := ' SELECT U.NMREDUZIDO             '+
        ' FROM UNIDADE U, DETALHE D       '+
        ' WHERE U.CDUNIDADE = D.CDUNIDADE '+
        ' AND D.CDDETALHE = '''+valor+''' ';
 try
  qryTmp := TIB_Query.Create(nil);
  qryTmp.SQL.Add(sql);
  qryTmp.Open;
   Result := qryTmp.Fields[0].AsString;
 finally
  FreeAndNil(qryTmp);
 end;
end;

function  Retorna_Aliquota(valor:String):String;
var
 qryTmp:TIB_Query;
 sql,saliquota:string;
begin
 sql := ' SELECT A.CDALIQUOTA, A.VLALIQUOTA, A.NMALIQUOTA  '+
        ' FROM ALIQUOTA A, DETALHE D                       '+
        ' WHERE A.CDALIQUOTA = D.CDALIQUOTA                '+
        ' AND D.CDDETALHE = '''+valor+'''                  ';
 try
  qryTmp := TIB_Query.Create(nil);
  qryTmp.SQL.Add(sql);
  qryTmp.Open;
  if qryTmp.IsEmpty then saliquota := '00'
  else  saliquota := qryTmp.FieldByName('VLALIQUOTA').AsString;
  if Length(saliquota) = 1 then
   saliquota := '0'+saliquota;
   saliquota := RetiraArgumento('%',saliquota);
   saliquota := RetiraArgumento(' ',saliquota);
   Result    := saliquota;
 finally
  FreeAndNil(qryTmp);
 end;
end;

function  Retorna_Nome_Aliquota(valor:String):String;
var
 qryTmp:TIB_Query;
 sql,saliquota:string;
begin
 sql := ' SELECT A.NMALIQUOTA               '+
        ' FROM ALIQUOTA A, DETALHE D        '+
        ' WHERE A.CDALIQUOTA = D.CDALIQUOTA '+
        ' AND D.CDDETALHE = '''+valor+'''   ';
 try
  qryTmp := TIB_Query.Create(nil);
  qryTmp.SQL.Add(sql);
  qryTmp.Open;
  if qryTmp.IsEmpty then saliquota := '00'
  else  saliquota := qryTmp.FieldByName('NMALIQUOTA').AsString;
  if Length(saliquota) = 1 then
   saliquota := '0'+saliquota;
   saliquota := RetiraArgumento('%',saliquota);
   saliquota := RetiraArgumento(' ',saliquota);
   Result    := saliquota;
 finally
  FreeAndNil(qryTmp);
 end;
end;


function  Retorna_Aliquota(valor:String;Banco:TIBDatabase;Transacao:TIBTransaction):String;
var
 qryTmp:TIBQuery;
 sql,saliquota:string;
begin
 sql := ' select vlaliquota from aliquota a, detalhe d where a.cdaliquota = d.cdaliquota'+
        ' and d.cddetalhe = '''+valor+'''';
 try
  qryTmp               := TIBQuery.Create(nil);
  qryTmp.Database      := Banco;
  qryTmp.Transaction   := Transacao;
  qryTmp.CachedUpdates := true;
  qryTmp.SQL.Add(sql);
  qryTmp.Open;
  if qryTmp.IsEmpty then
   saliquota := '00'
  else  saliquota := qryTmp.Fields[0].AsString;
  if Length(saliquota) = 1 then
   saliquota := '0'+saliquota;
   Result := saliquota;
 finally
  FreeAndNil(qryTmp);
 end;
end;

function ArrCondPag(sCondPag: String;dDataBase: TDateTime;sTipoFora: String): Variant;
var
 aResult: Variant;
 x, xMax: Integer;
 NewDate, DiasExtras: TDateTime;
begin
  xMax := 0;
  if Pos(',',sCondPag) > 0 then
  begin
    xMax    := ChrCount(',',sCondPag);
    aResult := VarArrayCreate([0,xMax],varInteger);
    for x := 0 To xMax do
    begin
      if x = xMax then
        aResult[x] := StrToInt(Trim(sCondPag))
      else
        aResult[x] := StrToInt(Trim(Copy(sCondPag,1,Pos(',',sCondPag)-1)));
      sCondPag := Copy(sCondPag,Pos(',',sCondPag)+1,Length(sCondPag));
    end;
  end
  else
  begin
    aResult := VarArrayOf([StrToInt(Trim(sCondPag))]);
  end;

  NewDate := dDataBase;
  if sTipoFora = 'M' then
    while GetDateElement(NewDate,3) <> 1 do
      NewDate := NewDate + 1
  else if sTipoFora = 'Q' then
    if GetDateElement(dDataBase,3) <= 15 then
      while GetDateElement(NewDate,3) <> 16 do
        NewDate := NewDate + 1
    else
      while GetDateElement(NewDate,3) <> 1 do
        NewDate := NewDate + 1
  else if sTipoFora = 'D' then
    if GetDateElement(dDataBase,3) <= 10 then
      while GetDateElement(NewDate,3) <> 11 do
        NewDate := NewDate + 1
    else if GetDateElement(dDataBase,3) <= 20 then
      while GetDateElement(NewDate,3) <> 21 do
        NewDate := NewDate + 1
    else
      while GetDateElement(NewDate,3) <> 1 do
        NewDate := NewDate + 1
  else
    NewDate := dDataBase;

  DiasExtras := (NewDate - dDataBase);

  if DiasExtras <> 0 then
    for x := 0 To xMax do
      aResult[x] := aResult[x]+DiasExtras;

  Result := aResult;
end;

function GetDateElement(FDate: TDateTime;Index: Integer): Integer;
var
  AYear, AMonth, ADay: Word;
begin
  DecodeDate(FDate, AYear, AMonth, ADay); { break encoded date into elements }
 case Index of
   1: Result := AYear;
   2: Result := AMonth;
   3: Result := ADay;
   else Result := -1;
 end;
end;

function RemoveAcento(Str:String): String;
const
// ComAcento = '‡‚ÍÙ˚„ı·ÈÌÛ˙Á¸¿¬ ‘€√’¡…Õ”⁄«‹';
// ComAcento = 'A† A¢ A™ A¥ Aª A£ Aµ A° A© A≠ A≥ A∫ Aß A';
// SemAcento = 'aaeouaoaeioucuAAEOUAOAEIOUCU';

 ComAcento = '‡‚ÍÙ˚„ı·ÈÌÛ˙Á¸¿¬ ‘€√’¡…Õ”⁄«‹A† A¢ A™ A¥ Aª A£ Aµ A° A© A≠ A≥ A∫ Aß A';
 SemAcento = 'aaeouaoaeioucuAAEOUAOAEIOUCUaaeouaoaeioucuAAEOUAOAEIOUCU';

var
 x : Integer;
begin
 for x := 1 to Length(Str) do
  begin
   if Pos(Str[x],ComAcento)<>0 Then
   Str[x] := SemAcento[Pos(Str[x],ComAcento)];
  end;
  Result := Str;
end;

function RetornaDataString(Data:string):string;
var
 Dia,Mes,Ano:string;
begin
 Dia := Copy(Data,0,2);
 Mes := Copy(Data,4,2);
 Ano := Copy(Data,7,8);
 Result := Ano+Mes+Dia;
end;

function RetornaDataString(Data:string; formato:string):string;
var
 Dia,Mes,Ano:string;
begin
 Dia := Copy(Data,0,2);
 Mes := Copy(Data,4,2);
 Ano := Copy(Data,7,8);
 Data := Dia+'/'+Mes+'/'+Ano;
 Result := FormatDateTime(formato, StrToDate(data));
end;

function RetornaDataMovtoECF(Data:string):string;
var
 Dia,Mes,Ano:string;
begin
 Dia := Copy(Data,0,2);
 Mes := Copy(Data,4,2);
 Ano := Copy(Data,7,8);
 Result := Dia+Mes+Ano;
end;

function RetornaDataMesAnoReferencia(Data:string):string;
var
 Dia,Mes,Ano:string;
begin
 Dia := Copy(Data,0,2);
 Mes := Copy(Data,4,2);
 Ano := Copy(Data,7,8);
 Result := Mes+Ano;
end;

function FormataStringParaData(Data:string):string;
var
 Dia,Mes,Ano:string;
 sRes:string;
begin
 Dia  := Copy(Data,0,2);
 Mes  := Copy(Data,3,2);
 Ano  := Copy(Data,5,8);
 sRes := Dia+'/'+Mes+'/'+Ano;
 Result := RetiraArgumento(' ',sRes);
end;

function Cria_Diretorio(var diretorio:String):Boolean;
begin
 Result := false;
 if not DirectoryExists(diretorio) then
  begin
   if MessageDlg('DiretÛrio Para Armazenar Arquivos N„o Existe.'+chr(10)+chr(13)+
                 'Deseja Cri·-lo?',mtConfirmation,[MbYes,MbNo],0)=IdYes then
    begin
     ForceDirectories(diretorio);
     result := true;
    end;
 end else
  begin
   result := false;
   end;
end;

function Substitui_Ponto_Virgula(valor:string):String;
var
 iposicao:integer;
begin
 iposicao := Pos(',',valor);
 if iposicao > 0 then
  begin
   Delete(valor,iposicao,1);
   Insert('.',valor,iposicao);
  end;
  Result := Valor;
end;

function Substitui_Caracter(Palavra,valorAntigo,valorNovo:string):String;
var
 iposicao:integer;
begin
 iposicao := Pos(valorAntigo,Palavra);
 if iposicao > 0 then
  begin
   Delete(Palavra,iposicao,1);
   Insert(valorNovo,Palavra,iposicao);
  end;
  Result := Palavra;
end;


{=================================}


function ReplicaTexto(col:integer; Texto:string):String;
var
 x:integer;
begin
 Result := '';
 x := 0;
 repeat
  inc(x);
  Result := result+''+Texto;
 until( x = col);
end;

function AjustaString(str: String; tam: Integer): String;
//Funcao que completa a string com espacos em branco Criado Por PlÌnio!!
begin
 while Length ( str ) < tam do
  str := str + ' ';
  if Length ( str ) > tam then
   str := Copy ( str, 1, tam );
   Result := str;
end;

function AjustaNumerico(VlrMoeda: Currency; tam: Integer) : String;
var
 sVlr: String;
begin
 if Pos(',',CurrToStr(VlrMoeda)) > 0 then
  sVlr := RetiraArgumento(',', FormatFloat('000000000.00', VlrMoeda))
 else sVlr := CurrToStr(VlrMoeda) + '00';
 while Length(sVlr) < tam do sVlr := '0'+sVlr;
 if Length(sVlr) > tam then  sVlr := Copy(sVlr,1,tam);
 Result := sVlr;
end;

function AjustaInteiro(inteiro:String;tam:integer) : String;
begin
 Result := '';
 while length(inteiro) < tam do
  inteiro := '0'+inteiro;
  if Length(inteiro) > tam then inteiro := Copy(inteiro,1,tam);
  Result := inteiro;
end;

function Exibir_Periodo(cdcliente:string):string;
var
  q : tib_query;
  dttermino, dtinicio, nuitperiodo, sql : string;
begin
  sql := 'select max(nuitperiodo) from itperiodo where cdcliente = '+cdcliente;
  q := tib_query.create(nil);
  try
    q.sql.add(sql);
    q.Open;
    if q.fields[0].asinteger = 0 then
    begin
      result := 'Cliente n„o realizou nenhum perÌodo.';
      exit;
    end;
    nuitperiodo := q.fields[0].asstring;
    sql := 'select dtinicio, dttermino, dtfechamento from itperiodo '+
           'where nuitperiodo = '+nuitperiodo+' and cdcliente = '+cdcliente;
    q.Close;
    q.sql.Clear;
    q.SQL.Add(sql);
    q.open;
    dtinicio  := formatdatetime(P4InfoVarejo_dtabrev, q.fieldbyname('dtinicio').AsDate);
    dttermino := formatdatetime(P4InfoVarejo_dtabrev, q.fieldbyname('dttermino').AsDate);
   { if q.fieldbyname('dtfechamento').IsNull then
    begin
      if DtBanco > q.fieldbyname('dttermino').AsDate then
        result := 'PerÌodo em atraso: '+dtinicio+' atÈ '+dttermino
      else
        result := 'PerÌodo aberto: '+dtinicio+' atÈ '+dttermino;
    end
    else
      result := 'PerÌodo fechado: '+dtinicio+' atÈ '+dttermino;
  }finally
    q.Close;
    freeandnil(q);
  end;
end;

function SeparaMes(Data:TDate):Integer;
var
 sData,sMes:string;
begin
 Result := 1;
 LongDateFormat  := 'dd/mm/yyyy';
 ShortDateFormat := 'dd/mm/yyyy';
 sData  := DateToStr(Data);
 sMes   := Copy(sData,4,2);
 if sMes = '' then sMes := '1';
 try
  Result := StrToInt(sMes);
 except
  Result := 1;
 end;
end;

function RemoveDigitoCodigoBarras(cdbarras:string):String;
begin
 Result := Copy(cdbarras,2,length(cdbarras));
end;

procedure RemoverValoresLista(cdlista:TStrings; ilinha:integer; var campo:string; var desccampo:string; var tipodedado:string);
var
 slinha         : string;
 scampo,
 sdesccampo,
 stipodedado    : string;
 iPosicao,iCont : integer;
begin
 iCont    := 1;
 slinha   := cdlista.Strings[ilinha];
 iPosicao := Pos(':',slinha);
 while iPosicao > 0 do
  begin
   if iCont = 1 then scampo      := Copy(slinha,0,iPosicao-1);
   if iCont = 2 then sdesccampo  := Copy(slinha,0,iPosicao-1);
   Delete(slinha,1,iPosicao);
   iPosicao := Pos(':',slinha);
   Inc(iCont);
  end;
  stipodedado := slinha;
  campo       := scampo;
  desccampo   := sdesccampo;
  tipodedado  := stipodedado;
end;


function RetirarCaracteresEspeciais(valor:string):String;
var
 svalor:string;
begin
 svalor := valor;
 svalor := RetiraArgumento(' ',svalor);
 svalor := RetiraArgumento('.',svalor);
 svalor := RetiraArgumento(',',svalor);
 svalor := RetiraArgumento('/',svalor);
 svalor := RetiraArgumento('\',svalor);
 svalor := RetiraArgumento('-',svalor);
 svalor := RetiraArgumento('.',svalor);
 svalor := RetiraArgumento('|',svalor);
 svalor := RetiraArgumento('(',svalor);
 svalor := RetiraArgumento(')',svalor);
 Result := svalor;
end;

function FormataCNPJ(valor:string):String;
var
 svalor, sCampo1, sCampo2,
 sCampo3, sCampo4, sCampo5 : string;
begin
 svalor := valor;
 if svalor = '' then exit;
 sCampo1 := Copy(svalor,1,2);
 sCampo2 := Copy(svalor,3,3);
 sCampo3 := Copy(svalor,6,3);
 sCampo4 := Copy(svalor,9,4);
 sCampo5 := Copy(svalor,13,2);
 Result  := sCampo1+'.'+sCampo2+'.'+sCampo3+'/'+sCampo4+'-'+sCampo5;
end;

function FormataCPF(valor:string):String;
var
 svalor, sCampo1,
 sCampo2, sCampo3, sCampo4 : string;
begin
 svalor := (valor);
 if svalor = '' then exit;
 sCampo1 := Copy(svalor,1,3);
 sCampo2 := Copy(svalor,4,3);
 sCampo3 := Copy(svalor,7,3);
 sCampo4 := Copy(svalor,10,2);
 Result  := sCampo1+'.'+sCampo2+'.'+sCampo3+'-'+sCampo4;
end;

function FormataCEP(valor:string):String;
var
 svalor, sCampo1,
 sCampo2, sCampo3: string;
begin
 svalor := (valor);
 if svalor = '' then exit;
 sCampo1 := Copy(svalor,1,2);
 sCampo2 := Copy(svalor,3,3);
 sCampo3 := Copy(svalor,6,3);
 Result  := sCampo1+sCampo2+'-'+sCampo3;
end;

function FormataTelefone(valor:string):String;
var
 svalor, sCampo1,
 sCampo2, sCampo3: string;
 tam :integer;
begin
 tam        := 0;
 svalor := (valor);
 tam    := length(svalor);
 if tam <= 8 then svalor := '31'+svalor;
 if svalor = '' then exit;
 sCampo1 := Copy(svalor,1,2);
 sCampo2 := Copy(svalor,3,4);
 sCampo3 := Copy(svalor,7,4);
 Result  := '('+sCampo1+')'+sCampo2+'-'+sCampo3;
end;

function AcumulaHoras(Horas:TStrings):String;
var
 i, iPos        : integer;
 sHoras, sMin   : string;
 iHoras,iMins   : integer;
 acHoras, acMins: integer;
begin
 i       := 0;
 iPos    := 0;
 sHoras  := '';
 sMin    := '';
 iHoras  := 0;
 iMins   := 0;
 acHoras := 0;
 acMins  := 0;
 for i := 0 to Horas.Count - 1 do
  begin
   sHoras  := Horas.Strings[i];
   iPos    := Pos(':',sHoras);
   iHoras  := StrToInt( Copy(sHoras,0,iPos-1));
   acHoras := acHoras + iHoras;
   iMins   := StrToInt( Copy(sHoras,iPos+1,2));
   acMins  := acMins + iMins;
   if acMins >= 60 then
    begin
     acMins := acMins - 60;
     inc(acHoras);
    end;
  end;
  sHoras := IntToStr(acHoras);
  sMin   := IntToStr(acMins);
  if Length(sHoras) = 1 then sHoras := '0'+sHoras;
  if length(sMin)   = 1 then sMin   := '0'+sMin;
  Result := sHoras+':'+sMin;
end;

procedure ConfiguraIB_Grid(qry:TIB_Query;grd:TIB_Grid);
var
 i         :integer;
 itemLink,
 itemSeq   : string;
begin
 itemLink := '';
 itemSeq  := '';
 for i := 0 to qry.Fields.ColumnCount - 1 do
  begin
   itemLink := qry.fields[i].FieldName+'='+qry.fields[i].FieldName+';'+qry.fields[i].FieldName+' DESC';
   itemSeq  := qry.fields[i].FieldName+'='+IntToStr(i+1);

   qry.OrderingLinks.Add(itemLink);
   qry.OrderingItems.Add(itemSeq);

        if qry.Fields[i].FieldName = 'CDFUNCIONARIO'      then qry.Fields[i].DisplayLabel := 'CÛdigo'
   else if qry.Fields[i].FieldName = 'NMFUNCIONARIO'      then qry.Fields[i].DisplayLabel := 'Funcion·rio'
   else if qry.Fields[i].FieldName = 'CDCLIENTE'          then qry.Fields[i].DisplayLabel := 'CÛdigo'
   else if qry.Fields[i].FieldName = 'NMCLIENTE'          then qry.Fields[i].DisplayLabel := 'Cliente'
   else if qry.Fields[i].FieldName = 'VENDASECF'          then qry.Fields[i].DisplayLabel := 'Vendas E.C.F.'
   else if qry.Fields[i].FieldName = 'VENDASNF'           then qry.Fields[i].DisplayLabel := 'Vendas N.F.'
   else if qry.Fields[i].FieldName = 'VENDASCONS'         then qry.Fields[i].DisplayLabel := 'Vendas Consignadas'
   else if qry.Fields[i].FieldName = 'VENDASORC'          then qry.Fields[i].DisplayLabel := 'Vendas OrÁamento'
   else if qry.Fields[i].FieldName = 'CDFORNECEDOR'       then qry.Fields[i].DisplayLabel := 'CÛdigo'
   else if qry.Fields[i].FieldName = 'NMFORNECEDOR'       then qry.Fields[i].DisplayLabel := 'Fornecedor'
   else if qry.Fields[i].FieldName = 'CDTRANSPORTADOR'    then qry.Fields[i].DisplayLabel := 'CÛdigo'
   else if qry.Fields[i].FieldName = 'NMTRANSPORTADOR'    then qry.Fields[i].DisplayLabel := 'Transportadora';

   grd.GridLinks.Add(qry.fields[i].FieldName);
  end;
  grd.Refresh;
end;

procedure LimpaIB_Grid(qry:TIB_Query;grd:TIB_Grid);
begin
 qry.OrderingItems.Clear;
 qry.OrderingLinks.Clear;
 grd.GridLinks.Clear;
 grd.EditLinks.Clear;
end;

function Proximo_Codigo_Barra(conmain: tib_connection):string;
var
  sql,cdbarra,cdproduto,prefixo : string;
  qryTmpBarra: TIB_Query;
  icdproduto:integer;
begin
 prefixo := '';
 cdbarra := '';
 sql := 'SELECT CDBARRA FROM REGISTRO';
 try
  qryTmpBarra := TIB_Query.Create(nil);
  with qryTmpBarra.SQL do
   begin
    Add(sql);
   end;
   qryTmpBarra.Open;
   if not qryTmpBarra.IsEmpty then
   {Original!!}
 // repeat
//    cdbarra := inttostr(GerarCodigo(conmain, 'BARRA'));
    prefixo := qryTmpBarra.FieldByName('CDBARRA').AsString;
    prefixo := Copy(prefixo, 1, 05);
    cdbarra := prefixo+cdbarra;
    while length(cdbarra) < 12 do cdbarra := cdbarra+'0';
    if Length(cdbarra) > 12 then cdbarra := Copy(cdbarra, 1,12);
//    cdbarra := cdbarra + digito_verificador_codigo_barra(cdbarra);
//  until not CodigoExiste('DETALHE', 'CDALTERNATIVO', 'string', cdbarra);
  result := cdbarra;
 finally
  FreeAndNil(qryTmpBarra);
 end;
end;

function LeParametro(sparam:string):String;
var
 iPos:Integer;
begin
 Result := '';
 iPos   := Pos('=',sparam);
 Result := Copy(sparam,0,iPos-2);
end;

function LeValorParametro(sparam:string):String;
var
 iPos:Integer;
begin
 Result := '';
 iPos   := Pos('=',sparam);
 Result := Copy(sparam,iPos+1,Length(sparam)-iPos);
end;

procedure LeDadosArquivoImpressoraFiscal(var nuserie:string; var impressora: string; var porta: string; var MFD: string;
                                         var gaveta: string; var impcheque: string; var tef_dial:string; var tef_Disc:string;
                                         var gt_ecf:string);
var
 ArqTexto : TextFile;
 Arquivo  : String;
 sLinha   : String;
 sparam,
 svlparam : string;
begin
 sparam   := '';
 svlparam := '';
 Arquivo  := 'c:\PFile.csi';

 if not FileExists('c:\PFile.csi') then
  begin
   try
    AssignFile(ArqTexto,'c:\PFile.csi');
    Rewrite(ArqTexto);
    Writeln(ArqTexto,'IMPRESSORA=Bematech');
    Writeln(ArqTexto,'MODELO=MFD2000');
    Writeln(ArqTexto,'MFD=S');
    Writeln(ArqTexto,'NUMERO SERIE ECF=');
   finally
    CloseFile(ArqTexto);
   end;
  end;

 try
  AssignFile(ArqTexto,Arquivo);
  Reset(ArqTexto);
  while not Eof(ArqTexto) do
   begin
    Readln(ArqTexto,SLinha);
    sparam   := LeParametro(sLinha);
    svlparam := LeValorParametro(sLinha);
    if sparam = 'NUMERO SERIE ECF' then nuserie     := svlparam;
    if sparam = 'IMPRESSORA'       then impressora  := svlparam;
    if sparam = 'PORTA'            then porta       := svlparam;
//    if sparam = 'GT_ECF'           then gt_ecf      := svlparam;
    if sparam = 'MFD'              then MFD         := svlparam;
    if sparam = 'GAVETA'           then gaveta      := svlparam;
    if sparam = 'CHEQUE'           then impcheque   := svlparam;
    if sparam = 'TEF_DIAL'         then tef_dial    := svlparam;
    if sparam = 'TEF_DISC'         then tef_Disc    := svlparam;
   end;
 finally
  CloseFile(ArqTexto);
 end;
end;

function LeRegistroSistema_BD_Usuario(var Usuario:String; var Senha:String) : string;
var
 Reg  : TRegistry;
 ssRegConexao,
 ssRegCaminho,
 ssRegProtocolo,
 ssRegServidor   : string;
begin
 Result := '';
 Reg := TRegistry.Create;
 Reg.RootKey := HKEY_CURRENT_USER;
 if Reg.OpenKey('\SOFTWARE\P4INFORMATICA\SECURITY',false) then
  begin
   ssRegCaminho   := Reg.ReadString('Caminho');
   ssRegProtocolo := Reg.ReadString('Protocolo');
   ssRegServidor  := Reg.ReadString('Servidor');
   Usuario        := Reg.ReadString('Usu·rio');
   Senha          := Reg.ReadString('Senha');
   if ssRegProtocolo = 'LOCAL' then
    begin
     ssRegConexao := ssRegCaminho;
    end;
   if ssRegProtocolo = 'NETBEUI' then
    begin
     ssRegConexao := '\\'+ssRegServidor+'\'+ssRegCaminho;
    end;
   if ssRegProtocolo = 'TCP/IP'then
    begin
     ssRegConexao := ssRegServidor+':'+ssRegCaminho;
    end;
   if ssRegProtocolo = 'IPX/SPX' then
    begin
     ssRegConexao := ssRegServidor+'@'+ssRegCaminho;
    end;
   Result := ssRegConexao;
  end;
end;

function Retorna_Permissao_Usuario_Caixa(UsuarioConectado, BancoSeguranca, Usuario, Senha:String):Boolean;
var
 sql  : string;
 q    : TIB_Query;
 Conn : TIB_Connection;
begin
 Result := false;
 sql := ' select po.bolacesso                            '+
        ' from objeto o, permissao_objeto po, usuario u  '+
        ' where nmformulario = ''actFluxoCaixa''         '+
        ' and   o.cdobjeto   = po.cdobjeto               '+
        ' and   po.usucod    = u.usucod                  '+
        ' and u.usulogin    = '''+UsuarioConectado+'''   ';

 try
  Conn              := TIB_Connection.Create(nil);
  Conn.Disconnect;
  Conn.DatabaseName := BancoSeguranca;
  Conn.Username     := Usuario;
  Conn.Password     := Senha;
  try
   Conn.Connect;
  except
  end;
  q := TIB_Query.Create(nil);
  q.IB_Connection := Conn;
  q.SQL.Add(sql);
  q.Open;
  if not q.IsEmpty then
   begin
    if q.FieldByName('BOLACESSO').AsString = 'T' then Result := true else Result := false;
   end;
 finally
  FreeAndNil(q);
  Conn.Disconnect;
  FreeAndNil(Conn);
 end;
end;


function Formata_CNPJ(cnpj:String):String;
var
 str1,
 str2,
 str3,
 str4,
 str5 : string;
begin
 //   08.633.795/0001-87
 //   08633795000187
 Result := '';
 str1   := Copy(cnpj,0,2);
 str2   := Copy(cnpj,3,3);
 str3   := Copy(cnpj,6,3);
 str4   := Copy(cnpj,9,4);
 Str5   := Copy(cnpj,13,2);
 Result := str1+'.'+str2+'.'+str3+'/'+str4+'-'+str5;
end;

function FormataPercentual(valor:string):String;
var
 tam:integer;
 int,dec:string;
begin
 tam := length(valor);
 int := Copy(valor,1,tam-2);
 dec := Copy(valor, tam-1,2);
 Result := int+','+dec;
end;

function FormataPercentual(valor:string; decimais:boolean):Double;
var
 tam:integer;
 int,dec:string;
 sValor:String;
begin
 tam    := length(valor);
 int    := Copy(valor,1,tam-2);
 dec    := Copy(valor, tam-1,2);
 sValor := int+','+dec;
 Result := StrToFloat(sValor);
end;

function NomeArquivoBancoRemessa():String;
var
 sData:String;
 sHora:String;
begin
// sData := FormatDateTime(P4InfoVarejo_dtabrev, DtBanco);
// sHora := FormatDateTime(P4InfoVarejo_hrbanco, HrBanco);

 sData := RetiraCaracteresEspeciais(sData);
 sHora := RetiraCaracteresEspeciais(sHora);

 Result := 'Remessa'+sData+'_'+sHora+'.txt';
 ShowMessage(Result);
end;

function Subtrai_Datas(DataInicial, DataFinal:TDateTime; HoraInicial:TTime; HoraFinal:TTime):String;
var
 intDias: double;
 sDias:string;
begin
 intDias := (DataFinal - DataInicial);

 sDias := FloatToStr(intDias);
 Result := sDias+' Dia(s) '+ FormatDateTime(P4InfoVarejo_hrbanco, (HoraFinal - HoraInicial));
end;



function ConverteDecimal_DataHora(valorNumerico:Double):String;
var
 sValorNum,
 sHora,
 sMin,
 sSeg  : string;
 iPos  : integer;
 fHora,
 fMin,
 fSeg  : double;
begin
 sValorNum := FloatToStr(valorNumerico);
 if Pos(',', sValorNum) > 0 then
  begin
   iPos  := Pos(',', sValorNum);
   sHora := Copy(sValorNum, 0, iPos-1);
   sMin  := Copy(sValorNum, iPos+1, length(sValorNum)-iPos);
   if sMin = '' then sMin := '0';
   fMin := StrToFloat(sMin);
   fMin := (fMin * 60) / 100;
   sValorNum := FloatToStr(fMin);
   iPos := Pos(',',sValorNum);
   if iPos > 0 then
    begin
     sMin := Copy(sValorNum, 0, iPos);
     sSeg := Copy(sValorNum, iPos, Length(sValorNum) - iPos);
     if sSeg = '' then sSeg := '00';
     fSeg := StrToFloat(sSeg);
     fSeg := (fSeg * 60) / 100;
     sSeg := FloatToStr(fSeg);
     if Pos(',', sSeg) > 0 then
      begin
       iPos := Pos(',', sSeg);
       sSeg := Copy(sSeg,0, iPos);
      end;
    end else
     begin

     end;
  end;
  Result := sHora+' hora(s), '+sMin+'minuto(s) '+sSeg+'segundo(s)';
end;

function IPLocal:string;
var
 WSAData: TWSAData;
 HostEnt: PHostEnt;
 Name   : string;
begin
 WSAStartup(2, WSAData);
 SetLength(Name, 255);
 Gethostname(PChar(Name), 255);
 SetLength(Name, StrLen(PChar(Name)));
 HostEnt := gethostbyname(PChar(Name));
 with HostEnt^ do
  begin
   Result := Tratar_NumeroIP_Computador(Format('%d.%d.%d.%d', [Byte(h_addr^[0]),Byte(h_addr^[1]), Byte(h_addr^[2]),Byte(h_addr^[3])]));
  end;
  WSACleanup;
end;

function Tratar_NumeroIP_Computador(ip:string):String;
var
 c1, c2,
 c3, c4  : string;
 ipos    : integer;
begin
 Result := ip;
 ipos   := Pos('.',ip);
 c1     := Copy(ip,0,ipos-1);
 Delete(ip,1,ipos);
 ipos   := Pos('.',ip);
 c2     := Copy(ip,0,ipos-1);
 Delete(ip,1,ipos);
 ipos   := Pos('.',ip);
 c3     := Copy(ip,0,ipos-1);
 Delete(ip,1,ipos);
 c4     := Copy(ip,0,length(ip));
 Delete(ip,1,ipos);
 while length(c1) < 03 do c1 := '0'+c1;
 while length(c2) < 03 do c2 := '0'+c2;
 while length(c3) < 03 do c3 := '0'+c3;
 while length(c4) < 03 do c4 := '0'+c4;
 Result := c1+'.'+c2+'.'+c3+'.'+c4;
end;


end.


