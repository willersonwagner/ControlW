unit untnfceForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, IniFiles, comctrls,
  ComObj, StdCtrls, ShDocVw,
  pcnConversao, pcnNFeRTXT, ACBrUtil, DateUtils, ACBrNFe,
  ACBrNFeDANFEClass, printers, ACBrNFeDANFeESCPOS,
  func, ibquery, classes1, StrUtils, acbrbal, funcoesdav,
  ACBrIBPTax, pcnConversaoNFe,
  ACBrDFeSSL, ACBrPosPrinter, ACBrDANFCeFortesFr, ACBrNFeDANFeRL,
  ACBrNFeDANFeRLClass, SyncObjs, ACBrNFeDANFEFR, ACBrMail, IdThreadComponent,
  pcnNFe, Math, DB, ACBrNFeNotasFiscais, pcnEventoNFe, pcnEnvEventoNFe,
  ACBrNFeWebServices, IdBaseComponent, BMDThread, IdComponent, IdTCPConnection,
  IdTCPClient, IdHTTP, IdMultipartFormData;

type
  TTWtheadNFeEnvia = class(TThread)
  private
    acbrnf: TACBrNFe;
    FCritical: TCriticalSection;
    procedure AfterConstruction; override;
  protected
    procedure Execute; override;
    procedure FinalizaSessaoCritica;
  public
    constructor Create(const CreateSuspended: boolean; var acbrnf1: TACBrNFe);
  end;

  TTWtheadNFeConsulta = class(TThread)
  private
    acbrnf: TACBrNFe;
    FCritical: TCriticalSection;
    procedure AfterConstruction; override;
  protected
    procedure Execute; override;
  public
    constructor Create(const CreateSuspended: boolean; var acbrnf1: TACBrNFe);
  end;

  TForm72 = class(TForm)
    IdThreadComponent1: TIdThreadComponent;
    BMDThread1: TBMDThread;
    IdHTTP1: TIdHTTP;
    procedure IdThreadComponent2Run(Sender: TIdThreadComponent);
    procedure IdThreadComponent1Exception(Sender: TIdThreadComponent;
      AException: Exception);
    procedure BMDThread1Execute(Sender: TObject; Thread: TBMDExecuteThread;
      var Data: Pointer);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

function FileAgeCreate(const fileName: string): String;
function GetBuildInfo(Prog: string): string;
//function substitui_Nodo(nome:string; conteudo : string; const texto :string) : String;
procedure validaCodbarCSTAT882(chave1: String);
function GRAVA_NODO_PROT_NFCe(ARQ_caminho : string) : string;
function SendPostData(var http : TIdHTTP; arquivo, estado, cstat : String) : boolean;
function SendPostDataMensagem(var http : TIdHTTP; erro, tipo, cstat, nomePC : String) : boolean;
function usaNFe4ouMaior() : boolean;
procedure atualizaRegistroNFCe(chaveVelha1, chaveNova1 : String);
function CodificaDataPelaChave(chave: String): TDateTime;
function manifestoDestinatarioNFe(chave: string): boolean;
procedure validaNCM_NaNFCe(chave1: String);
function GravaConfigNaPastaDoControlW(Const config_name: String;
  const default: string): String;
function buscaConfigNaPastaDoControlW(Const config_name: String;
  const default: string): String;
function buscaVersaoIBPT_Local(): String;
function ve_unidTributavel(DEST_NFE, NCM, Unidade: string): String;
function verificarValidadeCertificado(exception1: boolean = false): boolean;
procedure rateiaDesconto(var lista0: TList; totalDesconto: currency);
function retornaDescontoDoItem(descontoItem: currency): currency;
procedure insereInutilizacao(inicio, fim: integer; tipo, serie: string;
  Data: tdate);
function acbrNFeConsultarThread(P: Pointer): LongInt;
function acbrNFeConsultar(segundos: integer = 20): boolean;
function existeProxNumero(chave: String): boolean;
function buscaPastaNFe(const chave: String; abrir: boolean = true): String;
function buscaPastaNFCe(const chave: String; abrir: boolean = true): String;
function acbrNFeEnviar1(segundos: integer = 20): boolean;
function acbrNFeEnviar(segundos: integer = 20): boolean;
function acbrNFeEnviarThread(P: Pointer): LongInt;
function verificaDadosClienteNFe(cod: String;
  exterior: boolean = false): boolean;
function verificaSeExisteVendaDeVariosPedidos(nota: String): boolean;
function verificaSePodeEmitirContigencia(): boolean;
function ve_cest(codAliq: integer; NCM: String): String;
function verificaDadosNecessariosDeCliente(codCliente: integer): boolean;
procedure atualizaProtocoloXML(const caminhoxml: String);
function RetornaEndeRua(const entra: string): string;
procedure carregaConfigsNFCe;
function valXML(const val: String): currency;
function reStartGenerator(nome: string; Valor: integer): String;
procedure trataDuplicidade(erroDup: String; msg: boolean; nfe: boolean = false;
  modificaGenerator: boolean = true);
procedure trataDuplicidade1(erroDup: String; msg: boolean; nfe: boolean = false;
  modificaGenerator: boolean = true; chaveAtual: String = '');
function Incrementa_Generator(Gen_name: string;
  valor_incremento: integer): string;
procedure Ler_dados_pela_chave(var chav1: TChaveDetalhes);
procedure insereNotaBD1(var dados: Tvenda);
procedure insereNotaBD2(var dados: Tvenda; GravaMudancaDeChave: boolean = true);
FUNCTION GerarNFCeTexto(nota: String; cliente: String; nnf: String = '';
  chave: String = ''): AnsiString;
// FUNCTION GerarNFCeTextoCliente(nota : String; var cliente : TStringList; nnf : String = '') : AnsiString;
FUNCTION NODO_DEST(tipo, CPF, CNPJ, nome, ENDE, BAIRRO, COD_MUN, NOM_MUN, UF,
  CEP, FONE, IE, CODMUN_EMI: String): string;
function NODO_TRANP(): String;
FUNCTION NODO_PAG(): STRING;
FUNCTION NODO_RAIZ(nota: STRING): string;
FUNCTION NODO_NFE(nota: STRING): string;
FUNCTION NODO_INFNFE(CHAVENF, nota: string): string;
FUNCTION NODO_IDE(nota, UF, NUM_NF, FIN_NFE, COD_CFOP, EXT_CFOP, DAT, FORMPAG,
  COD_MUNIC, DV_NF: string; OFFLine: boolean = false): string;
function GeraChaveNf(nota: STRING): string;
FUNCTION NODO_ITENS(var lista: TList; CFOP, POS, CSTICM_CFP, CSTPIS_CFP,
  _ORIGE: string): string;
FUNCTION NODO_TOTAL(TOTNOTA, TOT_BASEICM, TOT_ICM, TOT_PIS, TOT_COFINS,
  TOTDESCICM, TOTDESC: currency): string;
FUNCTION NODO_INFADIC(INFO: string; PIS_NT, PIS_ST, COFINS_ST,
  _CFOP: currency): String;
FUNCTION NODO_ICMS1(var MAT: Item_venda; CSTICM_CFOP, _ORIGE: string): string;
FUNCTION NODO_PISCOFINS1(var item1: Item_venda; CSTPIS_CFOP: string): string;
FUNCTION SUB_NODO_END(ENDE: String): string;
procedure GravarTexto(SalvarComo, Texto: String);
function getDataHoraAtualXML(comFuso: boolean = true): String;
FUNCTION CAMPO_VAZIO(ENT: STRING): Smallint;
Function testacpf(CPF: string): boolean;
procedure criaXMLs(nota1, nnf, chav4: String);
procedure criaXMLsComDATA(nota1, nnf, chav4, Data: String);
procedure LimpaVariaveis();
function verificaExisteNFCe(const nota2: String;
  imprime: boolean = false): string;
function buscaChaveErroDeDuplicidade(erro: String): String;

function GRAVA_NODO_PROT_NFE1(ARQ_caminho: string): string;
procedure geraPgerais(var lis: TStringList);
function Arredonda(Valor: currency; decimais: integer; tipo: string = '')
  : currency;
function buscaCRCdaChave(const chve: string): String;
function substitui_Nodo(nome: string; conteudo: string;
  const Texto: string): String;
function buscaPastaConfigControlRede(): String;
function validaDadosDestinatario(): String;
function downloadXML(const chave, cnpj1, caminhoControlWBarra: String;
  const copiar: boolean = true): boolean;
procedure imprimirNfce();
procedure imprimirNfceESCPOS();
procedure imprimirNFe(impLogo: boolean = true);
procedure imprimirNFeFast(nfe: boolean = true);
function calculaVlrAproxImpostos(var lista11: TList): currency;
function ArredondaTrunca(Value: Extended; decimais: integer): Extended;
function ArredondaFinanceiro(Value: currency; Decimals: integer): currency;
procedure lerVenda(const nota1: String);
function Retorna_FinalidadeNFe(svl: string): TpcnFinalidadeNFe;
function FormataData(Data: TDateTime): string;
function Retorna_UFComerciante(svl: string): String;
function Retorna_TipoAmbiente(svl: string): TpcnTipoAmbiente;
function Retorna_TipoEmissaoNFe(svl: string): TpcnTipoEmissao;
function FormaPagamento_NFCe(formaPagto: String): TpcnFormaPagamento;
procedure lerItensDaVenda(var lista: TList; var nota: string);
FUNCTION NODO_ICMS(var MAT: Item_venda; CSTICM_CFOP, _ORIGE: string;
  indx: integer): string;
FUNCTION NODO_EMIT(CNPJ, RAZAO, FANTASIA, ENDE, BAIRRO, COD_MUN, NOM_MUN, UF,
  CEP, FONE, IE, CRT: string): string;
function GeraXml: String;
procedure insereNotaBD(var dados: Tvenda);
Function ProcuraItemNaLista(var lista: TList; cod1: integer): integer;
function setPrinter(const indx: integer; ImpressoraNome: String = ''): String;
procedure lerConfigBalanca();
// FUNCTION CAMPO_VAZIO(ENT : STRING) : Smallint;
procedure gravaERRO_LOG(caminho1, erro2, local1: String);
procedure gravaERRO_LOG1(caminho1, erro2, local1: String);

procedure Verifica_Status_NFe;
procedure LoadXML(MyMemo: TMemo; MyWebBrowser: TWebBrowser);
function LerConfiguracaoCFOP(): String;
procedure LerConfiguracaoNFCe(abreBD: boolean = true);
procedure LerConfiguracaoNFe();
procedure lerNodoIde(const codNF: integer; nota: String; serie: String = '1');
procedure lerNodoEmitDest();
Procedure LerDados_Emit_Dest(codDest: string; nnf: String = '');
Procedure LerDados_Emit_Dest1(var codDest: TStringList; nnf: String = '');
// function deRua(const entra : string) : string;
function RetornaNumero(const entra: string): string;
function verNCM(const cod: integer): String;
function Format_num(Valor: currency; vString: String = ''): string;
procedure inicializaVariaveis();
FUNCTION NODO_PISCOFINS(var item1: Item_venda; CSTPIS_CFOP: string;
  indx: integer): string;
FUNCTION VE_IMPOSTO(_PC, _PV, _qtd: currency): currency;

procedure GravarConfiguracao(certificadoCaminho, certificadoSenha,
  certificadoNumeroSerie: String; FinalidadeNFE, DANFETipo, DANFEFormaEmissao
  : integer; DANFELogomarca: String; ArqLog: boolean; CaminhoLog, WebUF: String;
  WebAmbiente: integer; WebVisualiza: boolean; ProxHost, ProxPorta, ProxUser,
  ProxSenha, EmailHost, EmailPorta, EmailUsuario, EmailSenha,
  EmailAssunto: String; mmEmailMsg: TMemo; EmailSSL: boolean;
  ArquivosPDF: String; ArquivosNFE: String; CDCFOP: String;
  idToken, Token: String; idxImpre, idxImpreNFe, tipoImpre: integer;
  preview: boolean; const portaBalanca, veloBal, tipoBal: string;
  serie: String = '1'; qtdViasStr: String = '1'; tipoImp: String = '0';
  PortaImpNFCE: String = ''; previewNFCe: boolean = false);

procedure CarregarConfiguracao();
procedure setQueryNFCe(var lista: TList);
procedure lerPathSalvar(var path: String);

function procuraNCM_Na_Tabela(NCM: String): boolean;
procedure GerarNFCe(nota, NumNFCe, TipoEmissao, TipoAmbiente, UFComerciante,
  FinalidadeNFE: String; recebido: currency = 0);
function reenviarCupom(nota22: String; var stats: String): boolean;
function EnviarCupomEletronico2(nota, chave1: String; var richED: TRichEdit;
  var estado: String; const imprime, dav: boolean;
  const lerconfig: boolean = true): boolean;
function EnviarCupomEletronicoTitular(nota: String; var Status, xmotivo: string;
  const tipo: integer; const enviar: boolean; const cliente1: String;
  obs1: String = ''; serie1: String = '1'; nnf: STRING = '';
  imp: boolean = true; recebido: currency = 0; EscPos: boolean = false)
  : boolean;
procedure Imprimir_DANFE_PDF(numeroNota: String; nnf: String = '';
  fortes: boolean = true; serie99: string = '1');
function Cancelamento_NFe(numeroNota: String; MemoResp: TMemo;
  WBResposta: TWebBrowser): boolean; Overload;
function Cancelamento_NFe1(numeroNota, Justificativa: String;
  cancelamento: integer = 0; chaveENT: String = ''): boolean;
function Cancelamento_NFePorNNF(numeroNota, Justificativa: String): boolean;
procedure ConsultarNFe(numeroNota: String; visuali: boolean = true);
function getSerieNFCe(): String;
function getUltimoNumero(): String;
function getNumeroValido(): String;
function verCSTcFOP(CFOP: String): String;
procedure reimpressaoNFCe(numeroNota: String);
function inutilizacaoNFCE(ini, fim, modelo: integer; just: String;
  _serie: integer = 0): boolean;
procedure setVersaoNFCe();
procedure setVersaoNFe();

procedure Carrega_NotaFiscal_ArquivoXML(OpenDialog: TOpenDialog;
  var NotaFiscal: String; var CFOP: String; var CondPagto: String;
  var ModeloNF: String; var SerieNF: String; var DtEmissao: tdate;
  var DtEntSai: tdate; var HrEntSai: TDateTime; var CNPJEmitente: String;
  var InscEstEmitente: String; var InscMunicEmitente: String;
  var EnderecoEmitente: String; var NumeroEndEmitente: String;
  var BairroEmitente: String; var codMunicipoEmitente: String;
  var NomeMunicipioEmiente: String; var UFEmitente: String;
  var FoneEmitente: String; var CEPEmitente: String; var CNPJDestinario: String;
  var codMunicipioDestinario: String; var VlBaseCalculo: String;
  var VlICMS: String; var VlBaseCalculoST: String; var VlST: String;
  var VlProduto: String; var VlFrete: String; var VlSeguro: String;
  var VlDesconto: String; var VlIPI: String; var VlPis: String;
  var VlCofins: String; var VlOutros: String; var VlNotaFiscal: String;
  var ListaProdutos: TStrings);

var
  minhaThreadTeste: TIdThreadComponent;
  EmailMsg: TStringList;
  arqNCM_UNID: TStringList;
  preview: boolean;
  enviouNFE: Char;
  gProxHost, gProxPorta, gProxUser, gProxSenha, DigiVerifi, CHAVENF, natOp,
    ERRO_dados, infAdic, dHAtual, tpEmis, obs2, margemEsquerda, versaoNFe,
    versaoNFCe, codUlt, chaveRecria: string;
  venda: Tvenda;
  lista: TList;
  codNF, erro12002, USUARIO1: integer;
  query1, query2, query3: tibquery;
  dadosEmitente, dadosDest: TStringList;
  TOT_PIS, TOT_COFINS, totalNota, PIS_ST, COFINS_ST, TRIB_ALIQ_COFINS, BASE_ICM,
    VLR_ICM, tot_Geral, TOTICM, TOT_BASEICM, PIS_NT, TRIB_ALIQ_PIS, TotImp,
    TOTDESC, vlRecebido: currency;
  ACBrNFe: TACBrNFe;
  tipoDanfe: integer;
  AcbrEmail: TACBrMail;
  DANFE: TACBrNFeDANFCeFortes;
  DANFEEscPos: TACBrNFeDANFeESCPOS;
  DANFE_Rave: TACBrNFeDANFeRL;
  DANFE_Fast: TACBrNFeDANFEFR;
  BALANCA: TACBrBAL;
  ACBrIBPTax1: TACBrIBPTax;
  pgerais: TStringList;
  TipoEmissao: integer;
  pathSalvarControlW, pastaControlW, cstIcmCfop, cstpisCfop, portaCOMNFCE,
    impreNFCE, impreNFE: String;
  previewNFCe1, campoDescontoExiste, usarCertificadoA3: boolean;

  richedt : TRichEdit;

  indxImpressora: integer;
  indxImpressoraNFE, serie2, tipoImp: integer;

  glbCFOP, glbNuCheque, glbNumeroDAV, glbNumeroIP, cliente, serie, cod_OP,
    NomeGeneratorSerie: string;
  gTipoEmissao: string;
  gTipoAmbiente: string;
  gUFComerciante: String;
  gFinalidadeNFe: String;
  gSmtpHost: String;
  gSmtpPorta: String;
  gSmtpUsuario: String;
  gSmtpSenha: String;
  gemailAssunto: String;
  gemailSSL: boolean;
  ad_cdserie: string;
  gArqPDF: String;
  gArqNFE: String;
  gSenhaCert, CDCFOP: String;

  // 0-normal 1-resumido
  tipoIMPRESSAO, qtdVias: integer;
  contOFFLINE, existeCampoTipo_item, expLogoMarca: boolean;
  Form72: TForm72;

implementation

{$R *.dfm}

uses gifAguarde;

procedure lerConfigBalanca();
var
  ini: TIniFile;
  arq: TStringList;
  pasta, tipo, velo, porta: String;
begin
  if not assigned(BALANCA) then
    exit;

  pasta := copy(ParamStr(0), 1, length(ParamStr(0)) - 3) + 'ini';
  if FilesExists(pasta) then
  begin
    ini := TIniFile.Create(pasta);

    porta := ini.ReadString('BALANCA', 'PORTA', 'COM1');
    velo := ini.ReadString('BALANCA', 'VELO', '9600');
    tipo := ini.ReadString('BALANCA', 'BALANCA', '0');
    ini.Free;

    BALANCA.Device.Baud := StrToIntDef(velo, 9600);
    BALANCA.Device.porta := porta;
    if tipo = '0' then
      BALANCA.modelo := balNenhum
    else if tipo = '1' then
      BALANCA.modelo := balDigitron
    else if tipo = '2' then
      BALANCA.modelo := balFilizola
    else if tipo = '3' then
      BALANCA.modelo := balLucasTec
    else if tipo = '4' then
      BALANCA.modelo := balMagellan
    else if tipo = '5' then
      BALANCA.modelo := balMagna
    else if tipo = '6' then
      BALANCA.modelo := balToledo
    else if tipo = '7' then
      BALANCA.modelo := balToledo2180
    else if tipo = '8' then
      BALANCA.modelo := balUrano
    else if tipo = '8' then
      BALANCA.modelo := balUranoPOP;
  end;
end;

procedure lerVenda(const nota1: String);
begin
  query1.Close;
  query1.SQL.Clear;
  // query1.SQL.Add('select v.nota, v.desconto, v.total, v.codhis, v.cliente, (select nome, codhis from formpagto f where f.cod = v.codhis) as nome from venda v where v.nota = :nota');
  query1.SQL.Add
    ('select v.nota, v.desconto, v.total, v.codhis, v.cliente, f.nome, f.codgru as codform, v.data from venda v left join formpagto f on (f.cod = v.codhis) where v.nota = :nota');
  query1.ParamByName('nota').AsString := nota1;
  query1.Open;

  venda := Tvenda.Create;
  venda.total := query1.fieldbyname('total').AsCurrency;
  venda.desconto := (query1.fieldbyname('desconto').AsCurrency);
  venda.cliente := StrToIntDef(cliente, 1);
  venda.codForma := query1.fieldbyname('codhis').AsString;
  venda._FORMPG := query1.fieldbyname('nome').AsString;
  venda.nota := query1.fieldbyname('nota').AsInteger;
  venda.Data := query1.fieldbyname('data').AsDateTime;
  venda.adic := IfThen(contOFFLINE, 'OFF', '');
  venda.codFormaNFCE := query1.fieldbyname('codform').AsString;
  venda.codFormaNFCE := strnum(venda.codFormaNFCE);

  if Contido('|' + venda.codFormaNFCE + '|', '|01|02|03|04|05|10|11|12|13|99|')
    = false then
    venda.codFormaNFCE := '01';

  query1.Close;
end;

procedure imprimirNFeFast(nfe: boolean = true);
var
  ini: integer;
begin
  ACBrNFe.DANFE := DANFE_Fast;
  if nfe then
  begin
    DANFE_Fast.margemEsquerda := 0.6;
    if tipoDanfe = 2 then
    begin
      DANFE_Fast.FastFile := ExtractFileDir(ParamStr(0)) +
        '\Report\DANFePaisagem.fr3';
    end
    else if tipoDanfe = 3 then
    begin
      DANFE_Fast.FastFile := ExtractFileDir(ParamStr(0)) +
        '\Report\DANFeSimplificado.fr3';
      DANFE_Fast.margemEsquerda := 0.3;
    end
    else
      DANFE_Fast.FastFile := ExtractFileDir(ParamStr(0)) +
        '\Report\DANFeRetrato.fr3';

    DANFE_Fast.MostrarPreview := DANFE_Rave.MostrarPreview;
    DANFE_Fast.ShowDialog := true;
    ACBrNFe.DANFE.Impressora := setPrinter(indxImpressoraNFE, impreNFE);
  end
  else
  begin
    DANFE_Fast.ShowDialog := false;
    DANFE_Fast.FastFile := ExtractFileDir(ParamStr(0)) +
      '\Report\DANFeNFCe.fr3';
    DANFE_Fast.margemEsquerda := StrToCurrDef(margemEsquerda, 0.1);
    DANFE_Fast.MostrarPreview := DANFE.MostrarPreview;
    ACBrNFe.DANFE.Impressora := setPrinter(indxImpressora, impreNFCE);
  end;

  try
    for ini := 0 to qtdVias - 1 do
    begin
      ACBrNFe.NotasFiscais.Imprimir;
      // if tipoIMPRESSAO = 0 then ACBrNFe.NotasFiscais.Imprimir
      // else ACBrNFe.NotasFiscais.ImprimirResumido;
    end;

    // if tipoIMPRESSAO = 0 then ACBrNFe.NotasFiscais.ImprimirPDF
    // else ACBrNFe.NotasFiscais.ImprimirResumidoPDF;
  except
    on e: Exception do
    begin
      ShowMessage('ERRO: ' + e.Message);
    end;
  end;

  ACBrNFe.DANFE.NFeCancelada := false;
end;

procedure imprimirNFe(impLogo: boolean = true);
var
  ini: integer;
  logo: String;
  expLogo: boolean;
begin
  if tipoIMPRESSAO = 2 then
  begin
    imprimirNFeFast(true);
    exit;
  end;

  query1.Close;
  query1.SQL.text := 'select * from nfe where nota = :nota';
  query1.ParamByName('nota').AsString :=
    IntToStr(ACBrNFe.NotasFiscais[0].nfe.Ide.nnf);
  query1.Open;

  if trim(query1.fieldbyname('ESTADO').AsString) = 'C' then
    DANFE_Rave.NFeCancelada := true;

  ACBrNFe.DANFE := DANFE_Rave;
  expLogo := false;

  if impLogo = false then
  begin
    logo := DANFE_Rave.logo;
    DANFE_Rave.logo := '';
    DANFE_Rave.ExpandirLogoMarca := false;
  end;

  try
    ACBrNFe.DANFE.Impressora := setPrinter(indxImpressoraNFE, impreNFE);

    for ini := 0 to qtdVias - 1 do
    begin
      ACBrNFe.NotasFiscais.Imprimir;
      // if tipoIMPRESSAO = 0 then ACBrNFe.NotasFiscais.Imprimir
      // else ACBrNFe.NotasFiscais.ImprimirResumido;
    end;

  except
    on e: Exception do
    begin
      ShowMessage('ERRO: ' + e.Message);
    end;
  end;

  if impLogo = false then
  begin
    // DANFE_Rave.Logo := logo;
    // danfe.ExpandirLogoMarca := expLogoMarca;
    LerConfiguracaoNFCe;
  end;

  ACBrNFe.DANFE.NFeCancelada := false;
end;

procedure imprimirNfce();
begin

  if tipoIMPRESSAO = 2 then
  begin
    imprimirNFeFast(false);
    exit;
  end;

  if tipoIMPRESSAO = 1 then
  begin
    imprimirNfceESCPOS();
    exit;
  end;

  DANFE.MostrarStatus := false;
  DANFE.tipoDanfe := tiNFCe;
  ACBrNFe.DANFE := DANFE;
  DANFE.ImprimeNomeFantasia := true;

  try
    if DANFE.MostrarPreview then
      form65.Close;
  except

  end;

  try
    setPrinter(indxImpressora, impreNFCE);
    ACBrNFe.NotasFiscais.Imprimir;

    // printer.Create;//hack pra printer voltar ao tamanho A4
    // if tipoIMPRESSAO = 0 then ACBrNFe.NotasFiscais.ImprimirPDF
    // else ACBrNFe.NotasFiscais.ImprimirResumidoPDF;

    DANFE.vTroco := 0;
  except
    on e: Exception do
    begin
      DANFE.vTroco := 0;
      ShowMessage('erro: ' + e.Message);
    end;
  end;
end;

procedure imprimirNfceESCPOS();
begin
  try
    ACBrNFe.DANFE := DANFEEscPos;
    ACBrNFe.NotasFiscais.Imprimir;
    DANFEEscPos.vTroco := 0;
  except
    on e: Exception do
    begin
      gravaERRO_LOG1('', e.Message, 'imprimirNfceESCPOS();');
      MessageDlg('Erro na Impressão: ' + #13 + e.Message + #13, mtError,
        [mbOK], 1);
    end;
  end;
end;

procedure lerPathSalvar(var path: String);
begin
  pathSalvarControlW := path;
end;

function setPrinter(const indx: integer; ImpressoraNome: String = ''): String;
begin
  if printer.printers.Count = 0 then
    exit;
  printer.PrinterIndex := indx;

  if ImpressoraNome <> '' then
  begin
    DANFE.Impressora := ImpressoraNome;
    Result := ImpressoraNome;
    exit;
  end;

  Result := printer.printers.Strings[indx];
  DANFE.Impressora := Result;
end;

Function ProcuraItemNaLista(var lista: TList; cod1: integer): integer;
var
  fim, i: integer;
  item1: Item_venda;
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

procedure setQueryNFCe(var lista: TList);
var
  fim: integer;
begin
  chaveRecria := '';
  fim := lista.Count - 1;
  if 0 <= fim then
    query1 := tibquery(lista.Items[0]);
  if 1 <= fim then
    query2 := tibquery(lista.Items[1]);
  if 2 <= fim then
    ACBrNFe := TACBrNFe(lista.Items[2]);
  if 3 <= fim then
    pgerais := TStringList(lista.Items[3]);
  if 4 <= fim then
  begin
    DANFE := TACBrNFeDANFCeFortes(lista.Items[4]);
  end;
  if 5 <= fim then
    DANFE_Rave := TACBrNFeDANFeRL(lista.Items[5]);
  if 6 <= fim then
    BALANCA := TACBrBAL(lista.Items[6]);
  if 7 <= fim then
    DANFEEscPos := TACBrNFeDANFeESCPOS(lista.Items[7]);
  if 8 <= fim then
    ACBrIBPTax1 := TACBrIBPTax(lista.Items[8]);
  if 9 <= fim then
  begin
    DANFE_Fast := TACBrNFeDANFEFR(lista.Items[9]);
    // DANFE_Fast.ShowDialog := true;
    DANFE_Fast.ImprimeEmUmaLinha := true;
  end;

  if 10 <= fim then
  begin
    AcbrEmail := TACBrMail(lista.Items[10]);
  end;

  versaoNFe := '3.10';
  versaoNFCe := '3.10';
  ACBrNFe.Configuracoes.Geral.VersaoDF := ve310;

  {if ((now >= StrToDate('01/07/2018')) or (ACBrNFe.Configuracoes.WebServices.Ambiente = taHomologacao)) then begin
    versaoNFe  := '4.00';
    versaoNFCe := '4.00';
    ACBrNFe.Configuracoes.Geral.VersaoDF := ve400;
  end;

  if FileExists(ExtractFileDir(ParamStr(0)) + '\4.00.txt') then begin}
    versaoNFe  := '4.00';
    versaoNFCe := '4.00';
    ACBrNFe.Configuracoes.Geral.VersaoDF := ve400;
//  end;

  //if ((now >= StrToDate('01/10/2018')) or (ACBrNFe.Configuracoes.WebServices.Ambiente = taHomologacao))  then begin
  //if FileExists(ExtractFileDir(ParamStr(0)) + '\qrcode.txt') then begin
    ACBrNFe.Configuracoes.Geral.VersaoQRCode := veqr200;
    //ShowMessage('qrcode.txt');
  //end;


  if pgerais = nil then
  begin
    try
      geraPgerais(pgerais);
    except
    end;
  end;
end;

procedure insereNotaBD(var dados: Tvenda);
begin
  query1.Close;
  query1.SQL.text := 'select chave from nfce where chave = :chave';
  query1.ParamByName('chave').AsString    := dados.chave;
  query1.Open;


  if query1.IsEmpty then begin
    query1.Close;
    query1.SQL.text :=
    'update or insert into nfce(chave, nota, data, cliente, adic, USUARIO, RECEBIDO) values(:chave, :nota, :data, :cliente, :adic, :USUARIO, :RECEBIDO) matching (chave)';
    query1.ParamByName('chave').AsString    := LeftStr(dados.chave, 44);
    query1.ParamByName('nota').AsInteger    := dados.nota;
    query1.ParamByName('data').AsDate       := now;
    query1.ParamByName('cliente').AsInteger := dados.cliente;
    query1.ParamByName('adic').AsString     := trim(dados.adic);
    query1.ParamByName('USUARIO').AsInteger := USUARIO1;

    if length(strnum(CurrToStr(DANFE.vTroco))) >= 8 then DANFE.vTroco := 0;

    query1.ParamByName('RECEBIDO').AsCurrency := DANFE.vTroco;
    try
      query1.ExecSQL;
      query1.Transaction.Commit;
    except
      on e: exception do begin
        MessageDlg('Erro em insereNotaBD(venda)704: ' + #13 + e.Message + #13+ #13+ #13 +
        'CHAVENF=' + CHAVENF + #13 + 'ADIC=' + venda.adic + #13 + 'crc=' + buscaCRCdaChave(strnum(venda.chave)) + #13 +
        'nota=' + IntToStr(venda.nota) + #13 + 'USUARIO1=' + IntToStr(USUARIO1) + #13 + 'dados.cliente=' + IntToStr(dados.cliente) + #13 +
        'DANFE.vTroco=' + CurrToStr(DANFE.vTroco),
          mtError, [mbOK], 1);
      end;
    end;
  end
  else begin
    query1.Close;
    query1.SQL.text :=
    'update nfce set adic = :adic where chave = :chave';
    query1.ParamByName('adic').AsString     := dados.adic;
    query1.ParamByName('chave').AsString    := LeftStr(dados.chave, 44);
    try
      query1.ExecSQL;
      query1.Transaction.Commit;
    except
      on e: exception do begin
        MessageDlg('Erro em insereNotaBD(venda)722: ' + #13 + e.Message + #13+ #13+ #13 +
        'CHAVENF=' + CHAVENF + #13 + 'ADIC=' + venda.adic + #13 + 'crc=' + buscaCRCdaChave(strnum(venda.chave)) + #13 +
        'nota=' + IntToStr(venda.nota) + #13 + 'USUARIO1=' + IntToStr(USUARIO1) + #13 + 'dados.cliente=' + IntToStr(dados.cliente) + #13 +
        'DANFE.vTroco=' + CurrToStr(DANFE.vTroco),
          mtError, [mbOK], 1);
      end;
    end;
  end;

  query1.Close;
  query1.SQL.text :=
    'update venda set crc = :crc, entrega = ''E'' where nota = :nota';
  query1.ParamByName('crc').AsString := LeftStr(buscaCRCdaChave(strnum(dados.chave)), 9);
  query1.ParamByName('nota').AsInteger := dados.nota;
  try
      query1.ExecSQL;
      query1.Transaction.Commit;
    except
      on e: exception do begin
        MessageDlg('Erro em insereNotaBD(venda)740: ' + #13 + e.Message + #13+ #13+ #13 +
        'CHAVENF=' + CHAVENF + #13 + 'ADIC=' + venda.adic + #13 + 'crc=' + buscaCRCdaChave(strnum(venda.chave)) + #13 +
        'nota=' + IntToStr(venda.nota) + #13 + 'USUARIO1=' + IntToStr(USUARIO1) + #13 + 'dados.cliente=' + IntToStr(dados.cliente) + #13 +
        'DANFE.vTroco=' + CurrToStr(DANFE.vTroco),
          mtError, [mbOK], 1);
      end;

  end;
end;

procedure insereNotaBD1(var dados: Tvenda);
begin
  if dados.chave <> '' then begin
    {{query1.Close;
    query1.SQL.text := 'delete from nfce where nota = :nota';
    query1.ParamByName('nota').AsInteger := dados.nota;
    query1.ExecSQL;
    query1.Transaction.Commit;}
  end;

  query1.Close;
  query1.SQL.text :=
    'update or insert into nfce(chave, nota, data, cliente, adic) values(:chave, :nota, :data, :cliente, :adic) matching(chave)';
  query1.ParamByName('chave').AsString := dados.chave;
  query1.ParamByName('nota').AsInteger := dados.nota;
  query1.ParamByName('data').AsDate := now;
  query1.ParamByName('cliente').AsInteger := dados.cliente;
  query1.ParamByName('adic').AsString    := dados.adic;
  query1.ExecSQL;
  query1.Transaction.Commit;


end;

procedure insereNotaBD2(var dados: Tvenda; GravaMudancaDeChave: boolean = true);
begin
  //essa chave foi retornada pelo erro do webservice da sefaz
  if length(strnum(dados.chave)) <> 44 then begin
    try
      richedt.Lines.Add('Chave Invalida(782): ' + dados.chave);
    except

    end;
    exit;
  end;

  //busca as chaves da mesma numeração e a mesma serie para excluir
  //primeiro grava no log para saber se foi excluida
  query1.Close;
  query1.SQL.text :=
    'select chave from nfce where (substring(chave from 26 for 9) = :nota) and (substring(chave from 23 for 3) = :serie) '
    + ' and (chave <> :chave)';
  query1.ParamByName('nota').AsString  := copy(dados.chave, 26, 9);
  query1.ParamByName('serie').AsString := copy(dados.chave, 23, 3);
  query1.ParamByName('chave').AsString := dados.chave;
  query1.Open;

  while not query1.Eof do
  begin
    if GravaMudancaDeChave then
      gravaERRO_LOG1('', 'Exclusao de Chave: ' + query1.fieldbyname('chave')
        .AsString, 'Duplicidade: insereNotaBD2');
    query1.Next;
  end;


 //deleta as chaves que estiverem a mesma numeração e mesma serie
 query1.Close;
  query1.SQL.text :=
    'delete from nfce where (substring(chave from 26 for 9) = :nota) and (substring(chave from 23 for 3) = :serie)'
    + ' and (chave <> :chave)';
  query1.ParamByName('nota').AsString := copy(dados.chave, 26, 9);
  query1.ParamByName('serie').AsString := copy(dados.chave, 23, 3);
  query1.ParamByName('chave').AsString := dados.chave;
  query1.ExecSQL;
  query1.Transaction.Commit;

  //adiciona e altera o registro da chave atual
  query1.Close;
  query1.SQL.text :=
    'update or insert into nfce(chave, nota, data, cliente, adic, exportado, USUARIO) values(:chave, :nota, :data, :cliente, :adic, 0, :USUARIO) matching(chave)';
  query1.ParamByName('chave').AsString := dados.chave;
  query1.ParamByName('nota').AsInteger := dados.nota;
  query1.ParamByName('data').AsDate := dados.Data;
  query1.ParamByName('USUARIO').AsInteger := USUARIO1;
  try
    if ((query1.ParamByName('data').IsNull) or
      (query1.ParamByName('data').AsDate <= StrToDate('01/01/1900'))) then
      query1.ParamByName('data').AsDate := now;
  except
    on e: exception do begin
      query1.ParamByName('data').AsDate := now;
      //ShowMessage(e.Message);
    end;

  end;

  query1.ParamByName('cliente').AsInteger := dados.cliente;
  query1.ParamByName('adic').AsString := dados.adic;
  try
    query1.ExecSQL;
  except
    on e: exception do begin
      query1.ParamByName('data').AsDate := now;
      //ShowMessage(e.Message);
    end;

  end;

  //atualiza o crc da tabela venda
  query1.Close;
  query1.SQL.text := 'update venda set crc = :crc where nota = :nota';
  query1.ParamByName('crc').AsString := buscaCRCdaChave(strnum(dados.chave));
  query1.ParamByName('nota').AsInteger := dados.nota;
  query1.ExecSQL;
  query1.Transaction.Commit;
end;

procedure inicializaVariaveis();
begin
  TOT_PIS := 0;
  TOT_COFINS := 0;
  TOTICM := 0;
  TOT_BASEICM := 0;
  PIS_ST := 0;
  PIS_NT := 0;
  tot_Geral := 0;
end;

FUNCTION NODO_EMIT(CNPJ, RAZAO, FANTASIA, ENDE, BAIRRO, COD_MUN, NOM_MUN, UF,
  CEP, FONE, IE, CRT: string): string;
var
  invalido: integer;
  ok: boolean;
begin
  invalido := 0;
  ok := true;
  // OK := VALIDACNPJ(CNPJ);

  IF (NOT ok) then
  begin
    ERRO_dados := 'CNPJ do Emitente Inválido ' + #13;
  end;

  invalido := invalido + CAMPO_VAZIO(ENDE);
  invalido := invalido + CAMPO_VAZIO(BAIRRO);
  invalido := invalido + CAMPO_VAZIO(COD_MUN);
  invalido := invalido + CAMPO_VAZIO(NOM_MUN);
  invalido := invalido + CAMPO_VAZIO(UF);
  invalido := invalido + CAMPO_VAZIO(CEP);

  if ((length(strnum(FONE)) < 6) or (length(strnum(FONE)) > 14)) then
  begin
    FONE := '';
  end;

  IF invalido <> 0 then
  begin
    ERRO_dados := ERRO_dados + 'Dados do Emitente Incompletos ' + #13;
    exit;
  end;

  Result := '<emit><CNPJ>' + CNPJ + '</CNPJ><xNome>' + removeCarateresEspeciais
    (RAZAO) + '</xNome>' + '<xFant>' + removeCarateresEspeciais(FANTASIA) +
    '</xFant><enderEmit>' + SUB_NODO_END(ENDE) + '<xBairro>' +
    removeCarateresEspeciais(BAIRRO) + '</xBairro><cMun>' + COD_MUN +
    '</cMun><xMun>' + removeCarateresEspeciais(NOM_MUN) + '</xMun><UF>' + UF +
    '</UF>' + '<CEP>' + CEP + '</CEP><cPais>1058</cPais><xPais>BRASIL</xPais>' +
    '<fone>' + FONE + '</fone></enderEmit><IE>' + IE + '</IE><CRT>' + CRT +
    '</CRT></emit>';

end;

function FormataData(Data: TDateTime): string;
begin
  Result := FormatDateTime('YYYY-MM-DD', Data);
end;

function GeraXml: String;
var
  Nome_Arquivo, Caminho, arq, test, ce: string;
  ini: integer;
begin
  PIS_ST := 0;
  PIS_NT := 0;
  COFINS_ST := 0;
  { valida := false;
    try
    LerDados_Emit_Dest(dest);
    //CriaLista_De_itens_Venda(lista_itens);
    except
    end;

    IF DEST_NFE = '2' then
    begin
    _EXPORTA := '<exporta><UFEmbarq>' +  dadosEmitente.Values['est'] + '</UFEmbarq>' +
    '<xLocEmbarq>' + dadosEmitente.Values['cid'] + '</xLocEmbarq></exporta>';
    end;


    //CriaDirCaminho('NFE\EMIT');
    //Caminho := pastaNFE_ControlW + 'NFE\EMIT\';

    try
    xml1 := NODO_RAIZ; //aqui cria o xml

    EmptyTList(Lista_Itens);
    if erro_dados <> '' then
    begin
    ShowMessage('Erro: '+erro_dados);
    exit;
    end;
    except
    on e: exception do
    begin
    ShowMessage('Erro Inesperado '+ e.Message);
    exit;
    end;
    end;

    arq := Caminho + chaveNF + '-nfe'+'.xml';
    if FileExists(Caminho + chaveNF + '-nfe'+'.xml') then
    begin
    dadosEmitente := TStringList.Create;
    dadosEmitente.LoadFromFile(Caminho + chaveNF + '-nfe'+'.xml');
    erro_dados := dadosEmitente.GetText;
    test := Le_Nodo('nProt', erro_dados);
    ce := Le_Nodo('cStat', erro_dados);
    if funcoes.Contido(ce,'100-101') AND (Length(ce) = 3) AND (Length(test) >= 13) AND (Length(test) <= 15) then
    begin
    ShowMessage('A nota '+ chaveNF +' já foi emitida.'+ #13 + #10 + #13 + #10 +
    'Numero de Protocolo: ' + test + ' ' + #13 + #10 +
    'Data e Hora de Autorização: ' + Le_Nodo('dhRecbto', ERRO_DADOS) + ' ' + #13 + #10 +
    'Status: ' + Le_Nodo('xMotivo', ERRO_DADOS) + ' ' + #13 + #10 +
    'Use a rotina Utilitários > Nfe > Reimpressão para ' +
    'imprimi-la, se necessário. Para emitir uma nova NF-e entre com um numero ' +
    'diferente deste.');
    exit;
    end;
    end;

    GravarTexto(arq, xml1);
    erro_dados := '';
    erro_dados := ValidarNfe(arq); // valida e envia o arquivo

    IF erro_dados <> '' THEN
    begin
    ShowMessage(erro_dados);
    EXIT;
    end;

    insereRegistroDaNotaNaTabelaNFE(nfeTemp, chaveNF);

    for ini := 0 to notas.Count -1 do
    begin
    funcoes.GRAVA_MOV(notas[ini], Form22.datamov, nfeTemp, '90', dest, false);
    end;

    Fechar_Datasets_limpar_Listas_e_variaveis;
  } end;

FUNCTION NODO_PISCOFINS(var item1: Item_venda; CSTPIS_CFOP: string;
  indx: integer): string;
VAR
  COF_ALIQ, PIS_ALIQ: string;
  tot, VLR_COFINS, VLR_PIS: currency;
begin
  try
    TRIB_ALIQ_PIS := StrToCurr(pgerais.Values['11']);
    TRIB_ALIQ_COFINS := StrToCurr(pgerais.Values['12']);
  except
    TRIB_ALIQ_COFINS := 0;
    TRIB_ALIQ_COFINS := 0;
  end;

  tot := item1.total - item1.desconto;
  // SE FOR OPTANTE DO SIMPLES NACIONAL, NAO USA TAG PIS/COFINS
  IF pgerais.Values['10'] = '1' then
  begin
    with ACBrNFe.NotasFiscais.Items[0].nfe.Det.Items[indx].Imposto do
    begin
      pis.CST := pis01;
      pis.vBC := tot;
      pis.vPIS := 0;
      COFINS.CST := cof01;
      COFINS.vBC := tot;
      COFINS.pCOFINS := 0;
      COFINS.vCOFINS := 0;
    end;
    { Result := '<PIS><PISAliq><CST>01</CST><vBC>' + FORMAT_NUM(TOT) + '</vBC><pPIS>0.00</pPIS>' +
      '<vPIS>0.00</vPIS></PISAliq></PIS>' +
      '<COFINS><COFINSAliq><CST>01</CST><vBC>' + FORMAT_NUM(TOT) + '</vBC>' +
      '<pCOFINS>0.00</pCOFINS><vCOFINS>0.00</vCOFINS></COFINSAliq></COFINS>';
    } exit;
  end;

  PIS_ALIQ := '<PISAliq><CST>02</CST><vBC>' + Format_num(tot) +
    '</vBC><pPIS>0.00</pPIS>' + '<vPIS>0.00</vPIS></PISAliq>';
  COF_ALIQ := '<COFINSAliq><CST>02</CST><vBC>' + Format_num(tot) + '</vBC>' +
    '<pCOFINS>0.00</pCOFINS><vCOFINS>0.00</vCOFINS></COFINSAliq>';

  // SE O CFOP E ISENTO DE PIS/COFINS
  IF CSTPIS_CFOP = 'I' then
  begin
    with ACBrNFe.NotasFiscais.Items[0].nfe.Det.Items[indx].Imposto do
    begin
      pis.CST := pis07;
      COFINS.CST := cof07;
      pis.vPIS := 0;
      COFINS.vCOFINS := 0;
    end;

    PIS_NT := PIS_NT + tot;
    { Result := '<PIS>' + PIS_ALIQ + '<PISNT><CST>07</CST></PISNT></PIS>' +
      '<COFINS>' + COF_ALIQ + '<COFINSNT><CST>07</CST></COFINSNT></COFINS>';
    } exit;
  end;

  // SE O CFOP NAO E TRIBUTADO POR PIS/COFINS
  IF CSTPIS_CFOP = 'N' then
  begin
    with ACBrNFe.NotasFiscais.Items[0].nfe.Det.Items[indx].Imposto do
    begin
      pis.CST := pis06;
      COFINS.CST := cof06;
      pis.vPIS := 0;
      COFINS.vCOFINS := 0;
    end;

    PIS_NT := PIS_NT + tot;
    Result := '<PIS>' + PIS_ALIQ + '<PISNT><CST>06</CST></PISNT></PIS>' +
      '<COFINS>' + COF_ALIQ + '<COFINSNT><CST>06</CST></COFINSNT></COFINS>';
    exit;
  end;

  // SE O CFOP TEM  A ALIQ RED. A ZERO DE PIS/COFINS
  IF CSTPIS_CFOP = 'R' then
  begin
    with ACBrNFe.NotasFiscais.Items[0].nfe.Det.Items[indx].Imposto do
    begin
      pis.CST := pis02;
      pis.vBC := tot;
      COFINS.CST := cof02;
      COFINS.vBC := tot;
      pis.pPIS := 0;
      pis.vPIS := 0;
      COFINS.vCOFINS := 0;
      COFINS.pCOFINS := 0;
    end;

    PIS_NT := PIS_NT + tot;
    Result := '<PIS><PISAliq><CST>02</CST><vBC>' + Format_num(tot) +
      '</vBC><pPIS>0.00</pPIS>' + '<vPIS>0.00</vPIS></PISAliq></PIS>' +
      '<COFINS><COFINSAliq><CST>02</CST><vBC>' + Format_num(tot) + '</vBC>' +
      '<pCOFINS>0.00</pCOFINS><vCOFINS>0.00</vCOFINS></COFINSAliq></COFINS>';
    exit;
  end;

  // SE O CFOP NAO E TRIBUTADO POR PIS/COFINS
  IF CSTPIS_CFOP = 'M' then
  begin
    with ACBrNFe.NotasFiscais.Items[0].nfe.Det.Items[indx].Imposto do
    begin
      pis.CST := pis04;
      COFINS.CST := cof04;
    end;

    PIS_NT := PIS_NT + tot;
    Result := '<PIS>' + '<PISNT><CST>04</CST></PISNT></PIS>' + '<COFINS>' +
      '<COFINSNT><CST>04</CST></COFINSNT></COFINS>';
  end;

  // SE O CFOP E ISENTO DE PIS/COFINS
  IF CSTPIS_CFOP = 'X' then
  begin
    with ACBrNFe.NotasFiscais.Items[0].nfe.Det.Items[indx].Imposto do
    begin
      pis.CST := pis08;
      COFINS.CST := cof08;
    end;

    PIS_NT := PIS_NT + tot;
    Result := '<PIS><PISNT><CST>08</CST></PISNT></PIS>' +
      '<COFINS><COFINSNT><CST>08</CST></COFINSNT></COFINS>';
  end;

  // SE O CFOP TEM ALIQ DIFERENCIADA
  IF CSTPIS_CFOP = 'D' then
  begin
    with ACBrNFe.NotasFiscais.Items[0].nfe.Det.Items[indx].Imposto do
    begin
      pis.CST := pis02;
      pis.vBC := tot;
      COFINS.CST := cof02;
      COFINS.vBC := tot;
      pis.pPIS := 0;
      pis.vPIS := 0;
      COFINS.pCOFINS := 0;
      COFINS.vCOFINS := 0;
    end;

    PIS_NT := PIS_NT + tot;
    { Result := '<PIS><PISAliq><CST>02</CST><vBC>' + FORMAT_NUM(TOT) + '</vBC><pPIS>0.00</pPIS>' +
      '<vPIS>' + Format_num(0.00) + '</vPIS></PISAliq></PIS>'  +
      '<COFINS><COFINSAliq><CST>02</CST><vBC>' + FORMAT_NUM(TOT) + '</vBC>' +
      '<pCOFINS>0.00</pCOFINS><vCOFINS>' + Format_num(0.00) + '</vCOFINS></COFINSAliq></COFINS>'; }
  end;

  // CFOP - SE JA RECOLHEU PIS/COFINS POR SUBSTITUICAO TRIBUTARIA
  IF CSTPIS_CFOP = 'S' then
  begin
    VLR_PIS := Arredonda(item1.Total_Preco_Compra * TRIB_ALIQ_PIS / 100, 2);
    VLR_COFINS := Arredonda(item1.Total_Preco_Compra * TRIB_ALIQ_COFINS
      / 100, 2);
    PIS_ST := PIS_ST + VLR_PIS;
    COFINS_ST := COFINS_ST + VLR_COFINS;

    with ACBrNFe.NotasFiscais.Items[0].nfe.Det.Items[indx].Imposto do
    begin
      pis.CST := pis02;
      pis.vBC := tot;
      pis.pPIS := TRIB_ALIQ_PIS;
      pis.vPIS := VLR_PIS;
      COFINS.CST := cof02;
      COFINS.vBC := item1.Total_Preco_Compra;
      COFINS.pCOFINS := TRIB_ALIQ_COFINS;
      COFINS.vCOFINS := VLR_COFINS;
    end;

    { Result := '<PIS>' + PIS_ALIQ + '<PISST><vBC>' + FORMAT_NUM(item1.Total_Preco_Compra) + '</vBC>' +
      '<pPIS>' + FORMAT_NUM(TRIB_ALIQ_PIS) + '</pPIS>' +
      '<vPIS>' + FORMAT_NUM(VLR_PIS) + '</vPIS></PISST></PIS>' +
      '<COFINS>' + COF_ALIQ + '<COFINSST><vBC>' + FORMAT_NUM(item1.Total_Preco_Compra) + '</vBC>' +
      '<pCOFINS>' + FORMAT_NUM(TRIB_ALIQ_COFINS) + '</pCOFINS>' +
      '<vCOFINS>' + FORMAT_NUM(VLR_COFINS) + '</vCOFINS></COFINSST></COFINS>'; }
    exit;
  end;

  // SE O PRODUTO E ISENTO DE PIS/COFINS
  IF ((item1.pis = 'I') and (length(strnum(item1.codISPIS)) = 3)) then
  begin
    PIS_NT := PIS_NT + tot;

    with ACBrNFe.NotasFiscais.Items[0].nfe.Det.Items[indx].Imposto do
    begin
      pis.CST := pis07;
      pis.vBC := 0;
      pis.pPIS := TRIB_ALIQ_PIS;
      pis.vPIS := 0;
      COFINS.CST := cof07;
      COFINS.vBC := 0;
      COFINS.pCOFINS := TRIB_ALIQ_COFINS;
      COFINS.vCOFINS := 0;
    end;

    // Result := '<PIS>' + PIS_ALIQ + '<PISNT><CST>07</CST></PISNT></PIS>' +
    // '<COFINS>' + COF_ALIQ + '<COFINSNT><CST>07</CST></COFINSNT></COFINS>' ;
    exit;
  end;

  // SE O PRODUTO NAO E TRIBUTADO POR PIS/COFINS
  IF ((item1.pis = 'N') and (length(strnum(item1.codISPIS)) = 3)) then
  begin
    with ACBrNFe.NotasFiscais.Items[0].nfe.Det.Items[indx].Imposto do
    begin
      pis.CST := pis06;
      pis.vPIS := 0;
      COFINS.CST := cof06;
      COFINS.vCOFINS := 0;
    end;

    PIS_NT := PIS_NT + tot;
    Result := '<PIS>' + PIS_ALIQ + '<PISNT><CST>06</CST></PISNT></PIS>' +
      '<COFINS>' + COF_ALIQ + '<COFINSNT><CST>06</CST></COFINSNT></COFINS>';
    exit;
  end;

  // SE O PRODUTO TEM  A ALIQ RED. A ZERO DE PIS/COFINS
  IF ((item1.pis = 'R') and (length(strnum(item1.codISPIS)) = 3)) then
  begin
    with ACBrNFe.NotasFiscais.Items[0].nfe.Det.Items[indx].Imposto do
    begin
      pis.CST := pis06;
      pis.pPIS := 0;
      pis.vPIS := 0;
      pis.vBC := tot;
      COFINS.CST := cof06;
      COFINS.vBC := tot;
      COFINS.vCOFINS := 0;
      COFINS.pCOFINS := 0;
    end;

    PIS_NT := PIS_NT + tot;
    Result := '<PIS><PISAliq><CST>02</CST><vBC>' + Format_num(tot) +
      '</vBC><pPIS>0.00</pPIS>' + '<vPIS>0.00</vPIS></PISAliq></PIS>' +
      '<COFINS><COFINSAliq><CST>02</CST><vBC>' + Format_num(tot) + '</vBC>' +
      '<pCOFINS>0.00</pCOFINS><vCOFINS>0.00</vCOFINS></COFINSAliq></COFINS>';
    exit;
  end;

  // SE O PRODUTO TEM  A ALIQ RED. A ZERO DE PIS/COFINS
  IF ((item1.pis = 'X') and (length(strnum(item1.codISPIS)) = 3)) then
  begin
    with ACBrNFe.NotasFiscais.Items[0].nfe.Det.Items[indx].Imposto do
    begin
      pis.CST := pis08;
      pis.pPIS := 0;
      pis.vPIS := 0;
      pis.vBC := 0;
      COFINS.CST := cof08;
      COFINS.vBC := 0;
      COFINS.vCOFINS := 0;
      COFINS.pCOFINS := 0;
    end;

    PIS_NT := PIS_NT + tot;
    Result := '<PIS><PISAliq><CST>02</CST><vBC>' + Format_num(tot) +
      '</vBC><pPIS>0.00</pPIS>' + '<vPIS>0.00</vPIS></PISAliq></PIS>' +
      '<COFINS><COFINSAliq><CST>02</CST><vBC>' + Format_num(tot) + '</vBC>' +
      '<pCOFINS>0.00</pCOFINS><vCOFINS>0.00</vCOFINS></COFINSAliq></COFINS>';
    exit;
  end;

  // PRODUTO - SE JA RECOLHEU PIS/COFINS POR SUBSTITUICAO TRIBUTARIA
  IF item1.pis = 'S' then
  begin
    VLR_PIS := Arredonda(tot * TRIB_ALIQ_PIS / 100, 2);
    VLR_COFINS := Arredonda(tot * TRIB_ALIQ_COFINS / 100, 2);
    PIS_ST := PIS_ST + VLR_PIS;
    COFINS_ST := COFINS_ST + VLR_COFINS;

    with ACBrNFe.NotasFiscais.Items[0].nfe.Det.Items[indx].Imposto do
    begin
      pis.CST := pis02;
      pis.vPIS := VLR_PIS;
      pis.pPIS := TRIB_ALIQ_PIS;
      pis.vBC := tot;
      COFINS.CST := cof02;
      COFINS.vBC := tot;
      COFINS.pCOFINS := TRIB_ALIQ_COFINS;
      COFINS.vCOFINS := VLR_COFINS;
    end;

    Result := '<PIS>' + PIS_ALIQ + '<PISST><vBC>' +
      Format_num(item1.Total_Preco_Compra) + '</vBC>' + '<pPIS>' +
      Format_num(TRIB_ALIQ_PIS) + '</pPIS>' + '<vPIS>' + Format_num(VLR_PIS) +
      '</vPIS></PISST></PIS>' + '<COFINS>' + COF_ALIQ + '<COFINSST><vBC>' +
      Format_num(item1.Total_Preco_Compra) + '</vBC>' + '<pCOFINS>' +
      Format_num(TRIB_ALIQ_COFINS) + '</pCOFINS>' + '<vCOFINS>' +
      Format_num(VLR_COFINS) + '</vCOFINS></COFINSST></COFINS>';
    exit;
  end;

  // REGIME NORMAL - RECOLHIMENTO DE PIS E COFINS
  // CALCULA PIS/COFINS SOBRE O VALOR DO PRODUTO - DESCONTO
  VLR_PIS := Arredonda(tot * TRIB_ALIQ_PIS / 100, 2);
  TOT_PIS := TOT_PIS + VLR_PIS;
  VLR_COFINS := Arredonda(tot * TRIB_ALIQ_COFINS / 100, 2);
  TOT_COFINS := TOT_COFINS + VLR_COFINS;

  with ACBrNFe.NotasFiscais.Items[0].nfe.Det.Items[indx].Imposto do
  begin
    pis.CST := pis01;
    pis.vBC := tot;
    pis.pPIS := TRIB_ALIQ_PIS;
    pis.vPIS := VLR_PIS;
    COFINS.CST := cof01;
    COFINS.vBC := item1.Total_Preco_Compra;
    COFINS.pCOFINS := TRIB_ALIQ_COFINS;
    COFINS.vCOFINS := VLR_COFINS;
  end;

  { Result := '<PIS><PISAliq><CST>01</CST><vBC>' + FORMAT_NUM(TOT) + '</vBC>' +
    '<pPIS>' + FORMAT_NUM(TRIB_ALIQ_PIS) + '</pPIS>' +
    '<vPIS>' + FORMAT_NUM(VLR_PIS) +
    '</vPIS></PISAliq></PIS>' +
    '<COFINS><COFINSAliq><CST>01</CST><vBC>' + FORMAT_NUM(TOT) + '</vBC>' +
    '<pCOFINS>' + FORMAT_NUM(TRIB_ALIQ_COFINS) + '</pCOFINS>' +
    '<vCOFINS>' + FORMAT_NUM(VLR_COFINS) +
    '</vCOFINS></COFINSAliq></COFINS>';
  } end;

function Format_num(Valor: currency; vString: String = ''): string;
begin
  if vString <> '' then
  begin
    Result := StringReplace(trim(vString), ',', '.', [rfReplaceAll]);
    exit;
  end;
  // Result := trim(FormatCurr('0.00', valor));
  Result := StringReplace(trim(FormatCurr('0.00', Valor)), ',', '.',
    [rfReplaceAll]);
end;

FUNCTION NODO_ICMS(var MAT: Item_venda; CSTICM_CFOP, _ORIGE: string;
  indx: integer): string;
var
  tot: currency;
  cod_OP: String;
begin
  tot := MAT.total - MAT.desconto;
  cod_OP := CDCFOP;
  Result := '';
  // se a empresa é optante do simples nacional
  if pgerais.Values['10'] = '1' then
  begin
    // EXPORTAÇÃO - CSOSN = 300
    IF Contido(LeftStr(cod_OP, 1), '4-7') then
    begin
      with ACBrNFe.NotasFiscais.Items[0].nfe.Det.Items[indx].Imposto do
      begin
        ICMS.CSOSN := csosn300;
        ICMS.orig := oeNacional;
      end;
      Result := '<ICMS><ICMSSN102><orig>' + _ORIGE +
        '</orig><CSOSN>300</CSOSN></ICMSSN102></ICMS>';
      exit;
    end;

    if MAT.codAliq = 10 then
    begin
      with ACBrNFe.NotasFiscais.Items[0].nfe.Det.Items[indx].Imposto do
      begin
        ICMS.CSOSN := csosn500;
        ICMS.orig := oeNacional;
        ICMS.vBCSTRet := MAT.p_compra;
        ICMS.vICMSSTRet := Arredonda(MAT.p_compra * 0.16, 2);
      end;
      { Result := '<ICMS><ICMSSN500><orig>' + _ORIGE + '</orig><CSOSN>500</CSOSN>' +
        '<vBCSTRet>' + FormatCurr('0.00',mat.p_compra) + '</vBCSTRet>' +
        '<vICMSSTRet>' + FormatCurr('0.00',ARREDONDA(mat.p_compra * 0.16, 2)) + '</vICMSSTRet>' +
        '</ICMSSN500></ICMS>';
      } exit;
    end;

    if MAT.codAliq = 11 then
    begin
      with ACBrNFe.NotasFiscais.Items[0].nfe.Det.Items[indx].Imposto do
      begin
        ICMS.CSOSN := csosn102;
        ICMS.orig := oeNacional;
      end;

      // Result := '<ICMS><ICMSSN102><orig>' + _ORIGE + '</orig><CSOSN>400</CSOSN></ICMSSN102></ICMS>';
      exit;
    end;

    if MAT.codAliq = 12 then
    begin
      with ACBrNFe.NotasFiscais.Items[0].nfe.Det.Items[indx].Imposto do
      begin
        ICMS.CSOSN := csosn102;
        ICMS.orig := oeNacional;
      end;
      Result := '<ICMS><ICMSSN102><orig>' + _ORIGE +
        '</orig><CSOSN>300</CSOSN></ICMSSN102></ICMS>';
      exit;
    end;

    if MAT.Reducao <> 0 then
    begin
      with ACBrNFe.NotasFiscais.Items[0].nfe.Det.Items[indx].Imposto do
      begin
        ICMS.CSOSN := csosn900;
        ICMS.orig := oeNacional;
        ICMS.modBC := dbiValorOperacao;
        ICMS.vBC := Arredonda(tot * MAT.Reducao / 100, 2);
        ICMS.pICMS := MAT.p_venda;
        ICMS.vICMS := 0;
        ICMS.vBCST := 0;
        ICMS.pICMSST := 0;
        ICMS.vICMSST := 0;
        ICMS.pCredSN := 0;
        ICMS.vCredICMSSN := 0;
      end;
      { Result := '<ICMSSN900><orig>' + _ORIGE + '</orig><CSOSN>900</CSOSN><modBC>3</modBC>' +
        '<vBC>' + FORMAT_NUM(ARREDONDA(tot * mat.Reducao / 100, 2)) + '</vBC>' +
        '<pRedBC>' + FORMAT_NUM(mat.Reducao) + '</pRedBC>' +
        '<pICMS>' + FORMAT_NUM(mat.p_venda) + '</pICMS>' +
        '<vICMS>' + FORMAT_NUM(0) + '</vICMS>' +
        '<modBCST>0.00</modBCST><vBCST>0.00</vBCST>' +
        '<pICMSST>0.00</pICMSST><vICMSST>0.00</vICMSST>' +
        '<pCredSN>0.00</pCredSN><vCredICMSSN>0.00</vCredICMSSN>' +
        '</ICMSSN900>' ;
      }

      exit;
    end;

    // TRIBUTACAO NORMAL PELO SIMPLES NACIONAL
    with ACBrNFe.NotasFiscais.Items[0].nfe.Det.Items[indx].Imposto do
    begin
      ICMS.CSOSN := csosn102;
      ICMS.orig := oeNacional;
    end;

    Result := '<ICMS><ICMSSN102><orig>' + _ORIGE +
      '</orig><CSOSN>102</CSOSN></ICMSSN102></ICMS>';
    exit;
  end;

  // EXPORTAÇÃO - CST = 41
  IF Contido(LeftStr(cod_OP, 1), '4-7') then
  begin
    with ACBrNFe.NotasFiscais.Items[0].nfe.Det.Items[indx].Imposto do
    begin
      ICMS.CST := cst41;
      ICMS.orig := oeNacional;
    end;
    Result := '<ICMS><ICMS40><orig>' + _ORIGE +
      '</orig><CST>41</CST></ICMS40></ICMS>';
    exit;
  end;

  { //CFOP SUBSTITUICAO TRIBUTARIA
    IF CSTICM_CFOP = 'S' then
    begin
    Result := '<ICMS><ICMS60><orig>' + _ORIGE + '</orig><CST>60</CST>' +
    '<vBCSTRet>' + FORMAT_NUM(mat.Total_Preco_Compra) + '</vBCSTRet>' +
    '<vICMSSTRet>' + FORMAT_NUM(Arredonda(mat.Total_Preco_Compra * 0.16, 2)) + '</vICMSSTRet>' +
    '</ICMS60></ICMS>';
    exit;
    end;

    //CFOP ISENTO
    IF CSTICM_CFOP = 'I' then
    begin
    Result := '<ICMS><ICMS40><orig>' + _ORIGE + '</orig><CST>40</CST></ICMS40></ICMS>';
    exit;
    end;

    //CFOP NAO SE APLICA ICM
    IF CSTICM_CFOP = 'N' then
    begin
    Result := '<ICMS><ICMS40><orig>' + _ORIGE + '</orig><CST>41</CST></ICMS40></ICMS>';
    exit;
    end;

    //CFOP TRIBUTADO COM REDUCAO NA BASE DE CALCULO
    IF CSTICM_CFOP = 'R' then
    begin
    //SE EXISTE REDUCAO NA BASE DE CALCULO PELO CFOP, ENTAO REDUCAO E DE 100%
    mat.Reducao := 0;
    mat.PercICMS := 0;
    mat.VlrICMS := 0;
    BASE_ICM := TOT;
    VLR_ICM := 0;
    TOTICM := VLR_ICM;
    TOT_BASEICM := BASE_ICM;

    Result := '<ICMS><ICMS20><orig>' + _ORIGE + '</orig><CST>20</CST><modBC>3</modBC>' +
    '<pRedBC>' + FORMAT_NUM(mat.Reducao) + '</pRedBC>' +
    '<vBC>' + FORMAT_NUM(mat.DescICMS) + '</vBC>' +
    '<pICMS>' + FORMAT_NUM(mat.PercICMS) + '</pICMS>' +
    '<vICMS>' + FORMAT_NUM(mat.VlrICMS) + '</vICMS></ICMS20></ICMS>';
    exit;
    end;
  }

  // TRIBUTACAO DO ICMS EM REGIME NORMAL
  // PRODUTO SUBSTITUICAO TRIBUTARIA
  IF MAT.codAliq = 10 then
  begin
    with ACBrNFe.NotasFiscais.Items[0].nfe.Det.Items[indx].Imposto do
    begin
      ICMS.CST := cst60;
      ICMS.orig := oeNacional;
      ICMS.vBCSTRet := MAT.p_compra;
      ICMS.vICMSSTRet := Arredonda(MAT.p_compra * 0.16, 2);
    end;

    { Result := '<ICMS><ICMS60><orig>' + _ORIGE + '</orig><CST>60</CST>' +
      '<vBCSTRet>' + FORMAT_NUM(mat.p_compra) + '</vBCSTRet>' +
      '<vICMSSTRet>' + FORMAT_NUM(ARREDONDA(mat.p_compra * 0.16, 2)) + '</vICMSSTRet>' +
      '</ICMS60></ICMS>';
    } exit;
  end;

  // PRODUTO ISENTO
  IF MAT.codAliq = 11 then
  begin
    with ACBrNFe.NotasFiscais.Items[0].nfe.Det.Items[indx].Imposto do
    begin
      ICMS.CST := cst40;
      ICMS.orig := oeNacional;
    end;
    Result := '<ICMS><ICMS40><orig>' + _ORIGE +
      '</orig><CST>40</CST></ICMS40></ICMS>';
    exit;
  end;

  // PRODUTO NAO SE APLICA ICM
  IF MAT.codAliq = 12 then
  begin
    with ACBrNFe.NotasFiscais.Items[0].nfe.Det.Items[indx].Imposto do
    begin
      ICMS.CST := cst41;
      ICMS.orig := oeNacional;
    end;

    Result := '<ICMS><ICMS40><orig>' + _ORIGE +
      '</orig><CST>41</CST></ICMS40></ICMS>';
    exit;
  end;

  // PRODUTO TRIBUTADO COM REDUCAO NA BASE DE CALCULO
  IF MAT.Reducao <> 0 then
  begin
    BASE_ICM := Arredonda(tot - (tot * MAT.Reducao / 100), 2);
    VLR_ICM := Arredonda(BASE_ICM * MAT.PercICMS / 100, 2);
    TOTICM := TOTICM + VLR_ICM;
    TOT_BASEICM := TOT_BASEICM + BASE_ICM;

    with ACBrNFe.NotasFiscais.Items[0].nfe.Det.Items[indx].Imposto do
    begin
      ICMS.CST := cst20;
      ICMS.modBC := dbiValorOperacao;
      ICMS.orig := oeNacional;
      ICMS.pRedBC := MAT.Reducao;
      ICMS.vBC := BASE_ICM;
      ICMS.pICMS := MAT.PercICMS;
      ICMS.vICMS := VLR_ICM;
    end;
    exit;
  end;

  // TRIBUTADO INTEGRAL
  BASE_ICM := tot;
  VLR_ICM := Arredonda(BASE_ICM * MAT.PercICMS / 100, 2);
  TOTICM := TOTICM + VLR_ICM;
  TOT_BASEICM := TOT_BASEICM + BASE_ICM;

  with ACBrNFe.NotasFiscais.Items[0].nfe.Det.Items[indx].Imposto do
  begin
    ICMS.CST := cst00;
    ICMS.modBC := dbiValorOperacao;
    ICMS.orig := oeNacional;
    ICMS.vBC := BASE_ICM;
    ICMS.pICMS := MAT.PercICMS;
    ICMS.vICMS := VLR_ICM;
  end;

  { Result := '<ICMS><ICMS00><orig>' + _ORIGE + '</orig><CST>00</CST><modBC>3</modBC>' +
    '<vBC>' + FORMAT_NUM(BASE_ICM) + '</vBC>' +
    '<pICMS>' + FORMAT_NUM(mat.PercICMS) + '</pICMS>' +
    '<vICMS>' + FORMAT_NUM(VLR_ICM) + '</vICMS></ICMS00></ICMS>';
  } end;



function verNCM(const cod: integer): String;
var
  ncm_prod: String;
  ex1, descricao: String;
  tabela: integer;
  aliqFedNac, aliqFedImp, aliqEst, aliqMun: double;
begin
  Result := '96089989';
  ncm_prod := '';

  query2.Close;
  query2.SQL.text := 'select classif, aliquota from produto where cod = :cod';
  query2.ParamByName('cod').AsInteger := cod;
  query2.Open;

  ncm_prod := trim(strnum(query2.fieldbyname('classif').AsString));
  if StrToInt(strnum(query2.fieldbyname('aliquota').AsString)) <> 10 then
    Result := '72189900';

  try
    if length(ncm_prod) = 8 then
    begin
      if procuraNCM_Na_Tabela(ncm_prod) then
      begin
        Result := ncm_prod;
      end;
    end;
  except
    Result := '96089989';
  end;
  query2.Close;
end;

procedure lerNodoEmitDest();
var
  erro: String;
begin
  with ACBrNFe.NotasFiscais.Items[0].nfe do
  begin
    Emit.CNPJCPF := dadosEmitente.Values['cnpj'];
    Emit.IE := dadosEmitente.Values['ies'];
    if Emit.IE = '' then
    begin
      Emit.IE := 'ISENTO';
      Emit.IEST := 'ISENTO';
    end;
    Emit.xNome := dadosEmitente.Values['razao'];
    Emit.xFant := LeftStr(dadosEmitente.Values['empresa'], 25);
    Emit.EnderEmit.FONE := dadosEmitente.Values['telres'];
    Emit.EnderEmit.CEP := 0;
    // Emit.EnderEmit.xLgr    := RetornaEndeRua(dadosEmitente.Values['ende']);
    Emit.EnderEmit.nro := RetornaNumero(dadosEmitente.Values['ende']);
    Emit.EnderEmit.xCpl := '';
    Emit.EnderEmit.xBairro := dadosEmitente.Values['bairro'];
    Emit.EnderEmit.cMun := StrToIntDef((dadosEmitente.Values['cod_mun']
      ), 1400100);
    Emit.EnderEmit.xMun := dadosEmitente.Values['cid'];
    Emit.EnderEmit.UF := dadosEmitente.Values['est'];
    Emit.EnderEmit.cPais := 1058;
    Emit.EnderEmit.xPais := 'BRASIL';

    if pgerais.Values['10'] = '1' then
      Emit.CRT := crtSimplesNacional
    else if pgerais.Values['10'] = '2' then
      Emit.CRT := crtSimplesExcessoReceita
    else
      Emit.CRT := crtRegimeNormal;
    // (1-crtSimplesNacional, 2-crtSimplesExcessoReceita, 3-crtRegimeNormal)

    if dadosDest.Values['cod'] = '*' then
      exit;

    erro := validaDadosDestinatario();
    if erro <> '' then
      exit;

    if ((dadosDest.Values['tipo'] = '1') or (dadosDest.Values['tipo'] = '6'))
    then
    begin
      dest.indIEDest := inNaoContribuinte;
    end
    else
    begin
      dest.IE := dadosDest.Values['ies'];
      if dest.IE = '' then
        dest.indIEDest := inNaoContribuinte
      else
        dest.indIEDest := inContribuinte;
    end;

    dest.IE := '';
    dest.indIEDest := inNaoContribuinte;

    dest.CNPJCPF := dadosDest.Values['cnpj'];
    dest.xNome := dadosDest.Values['nome'];
    dest.EnderDest.FONE := dadosDest.Values['telres'];
    // if RetiraCaracteresEspeciais(qr.FieldByName('CEPCLIENTE').AsString) = '' then
    dest.EnderDest.CEP := 0; // else
    // Dest.EnderDest.CEP     := StrToInt(RetiraCaracteresEspeciais(qr.FieldByName('CEPCLIENTE').AsString));
    // Dest.EnderDest.xLgr    := RetornaEndeRua(dadosDest.Values['ende']);
    dest.EnderDest.nro := RetornaNumero(dadosDest.Values['ende']);
    dest.EnderDest.xCpl := ' ';
    dest.EnderDest.xBairro := dadosDest.Values['bairro'];
    //
    if dadosDest.Values['cod_mun'] = '' then
      dadosDest.Values['cod_mun'] := dadosEmitente.Values['cod_mun'];
    dest.EnderDest.cMun := StrToInt(dadosDest.Values['cod_mun']);
    //
    dest.EnderDest.xMun := dadosDest.Values['cid'];
    dest.EnderDest.UF := dadosDest.Values['est'];
    dest.EnderDest.cPais := 1058;
    dest.EnderDest.xPais := 'BRASIL';
  end;
end;

Procedure LerDados_Emit_Dest(codDest: string; nnf: String = '');
var
  i: integer;
  arq00: TStringList;
begin
  if NomeGeneratorSerie = '' then
    NomeGeneratorSerie := 'NFCE';

  if (serie2 > 1) and (ParamCount > 0) then
  begin
    NomeGeneratorSerie := NomeGeneratorSerie + IntToStr(serie2);
  end;

  query1.Close;
  query1.SQL.Clear;
  query1.SQL.Add('select * from registro');
  query1.Open;

  dadosEmitente := TStringList.Create;
  dadosDest := TStringList.Create;

  dadosEmitente.Values['cod_mun'] := query1.fieldbyname('cod_mun').AsString;
  dadosEmitente.Values['ies'] := strnum(query1.fieldbyname('ies').AsString);
  dadosEmitente.Values['razao'] := query1.fieldbyname('nome').AsString;
  dadosEmitente.Values['empresa'] :=
    LeftStr(trim(query1.fieldbyname('empresa').AsString), 27);
  dadosEmitente.Values['cnpj'] := strnum(query1.fieldbyname('cnpj').AsString);
  dadosEmitente.Values['est'] := query1.fieldbyname('est').AsString;
  dadosEmitente.Values['ende'] := query1.fieldbyname('ende').AsString;
  dadosEmitente.Values['bairro'] := query1.fieldbyname('bairro').AsString;
  dadosEmitente.Values['cep'] := strnum(query1.fieldbyname('cep').AsString);
  dadosEmitente.Values['telres'] :=
    strnum(query1.fieldbyname('telres').AsString);
  dadosEmitente.Values['cid'] := query1.fieldbyname('cid').AsString;

  if nnf <> '' then
  begin
    codNF := StrToIntDef(strnum(nnf), 0);
    if codNF = 0 then
    begin
      // dadosEmitente.Values['nf'] := StrToIntDef(Incrementa_Generator('nfce', 0), 1);
      codNF := 1;
    end;
    dadosEmitente.Values['nf'] := IntToStr(codNF);
  end
  else
  begin
    codNF := StrToIntDef(Incrementa_Generator(NomeGeneratorSerie, 0), 0);
    if codNF = 0 then
    begin
      codNF := StrToIntDef(Incrementa_Generator(NomeGeneratorSerie, 1), 1);
    end;
    dadosEmitente.Values['nf'] := IntToStr(codNF);
  end;

 if chaveRecria <> '' then begin
   codNF                      := StrToIntDef(copy(chaveRecria, 26, 9), 0);
   dadosEmitente.Values['nf'] := IntToStr(codNF);
 end;

  if Contido('=', codDest) = false then
  begin
    query1.Close;
    query1.SQL.Clear;
    query1.SQL.Add('select * from cliente where cod = :cod');
    query1.ParamByName('cod').AsString := codDest;
    query1.Open;
    dadosDest.Values['cod'] := '*';
  end
  else
  begin
    arq00 := TStringList.Create;
    arq00.text := cliente;
  end;

  // dadosDest.Values['cod']    := '';
  if dadosDest.Values['cod'] = '*' then
  begin
    if (not query1.IsEmpty) then
    begin
      dadosDest.Values['cod'] := codDest;
      dadosDest.Values['cod_mun'] :=
        IfThen(trim(query1.fieldbyname('cod_mun').AsString) = '',
        dadosEmitente.Values['cod_mun'],
        trim(query1.fieldbyname('cod_mun').AsString));
      dadosDest.Values['tipo'] := trim(query1.fieldbyname('tipo').AsString);
      dadosDest.Values['cnpj'] := strnum(query1.fieldbyname('cnpj').AsString);
      dadosDest.Values['nome'] := trim(query1.fieldbyname('nome').AsString);
      dadosDest.Values['ende'] := trim(query1.fieldbyname('ende').AsString);
      dadosDest.Values['est'] := trim(query1.fieldbyname('est').AsString);
      dadosDest.Values['bairro'] := trim(query1.fieldbyname('bairro').AsString);
      dadosDest.Values['cep'] := strnum(query1.fieldbyname('cep').AsString);
      dadosDest.Values['telres'] :=
        strnum(query1.fieldbyname('telres').AsString);
      dadosDest.Values['cid'] := trim(query1.fieldbyname('cid').AsString);
      dadosDest.Values['ies'] := trim(query1.fieldbyname('ies').AsString);
    end;
  end
  else
  begin
    if arq00.Values['estx'] = '1' then
    begin
      dadosDest.Values['estx'] := '1';
      dadosDest.Values['cod_mun'] := dadosEmitente.Values['cod_mun'];
      dadosDest.Values['cnpj'] := strnum(arq00.Values['cpf']);
      dadosDest.Values['nome'] := trim(arq00.Values['nome']);
      dadosDest.Values['pais'] := trim(arq00.Values['pais']);
      dadosDest.Values['codpais'] := trim(arq00.Values['codpais']);

      arq00.Free;
      exit;
    end;

    dadosDest.Values['cod_mun'] := dadosEmitente.Values['cod_mun'];
    dadosDest.Values['cnpj'] := strnum(arq00.Values['cpf']);
    dadosDest.Values['nome'] := trim(arq00.Values['nome']);
    arq00.Free;
  end;

  query1.Close;
end;

Procedure LerDados_Emit_Dest1(var codDest: TStringList; nnf: String = '');
var
  i: integer;
begin
  query1.Close;
  query1.SQL.Clear;
  query1.SQL.Add('select * from registro');
  query1.Open;

  dadosEmitente := TStringList.Create;
  dadosDest := TStringList.Create;

  dadosEmitente.Values['cod_mun'] := query1.fieldbyname('cod_mun').AsString;
  dadosEmitente.Values['ies'] := strnum(query1.fieldbyname('ies').AsString);
  dadosEmitente.Values['razao'] := query1.fieldbyname('nome').AsString;
  dadosEmitente.Values['empresa'] :=
    LeftStr(trim(query1.fieldbyname('empresa').AsString), 27);
  dadosEmitente.Values['cnpj'] := strnum(query1.fieldbyname('cnpj').AsString);
  dadosEmitente.Values['est'] := query1.fieldbyname('est').AsString;
  dadosEmitente.Values['ende'] := query1.fieldbyname('ende').AsString;
  dadosEmitente.Values['bairro'] := query1.fieldbyname('bairro').AsString;
  dadosEmitente.Values['cep'] := strnum(query1.fieldbyname('cep').AsString);
  dadosEmitente.Values['telres'] :=
    strnum(query1.fieldbyname('telres').AsString);
  dadosEmitente.Values['cid'] := query1.fieldbyname('cid').AsString;

  if nnf <> '' then
  begin
    codNF := StrToIntDef(nnf, 0);
    if codNF = 0 then
      codNF := 1;
    dadosEmitente.Values['nf'] := IntToStr(codNF);
  end
  else
  begin
    codNF := StrToIntDef(Incrementa_Generator('nfce', 0), 0);
    if codNF = 0 then
      codNF := 1;
    dadosEmitente.Values['nf'] := IntToStr(codNF);
  end;

  if (codDest.Values['cod'] = '0') then
  begin
    dadosDest.Values['cod'] := codDest.Values['cod'];
    dadosDest.Values['cod_mun'] :=
      IfThen(trim(query1.fieldbyname('cod_mun').AsString) = '',
      dadosEmitente.Values['cod_mun'],
      trim(query1.fieldbyname('cod_mun').AsString));
    dadosDest.Values['tipo'] := '1';
    dadosDest.Values['cnpj'] := strnum(codDest.Values['cnpj']);
    dadosDest.Values['nome'] := trim(codDest.Values['nome']);
    dadosDest.Values['ende'] := trim(codDest.Values['ende']);
    dadosDest.Values['est'] := trim(codDest.Values['est']);
    dadosDest.Values['bairro'] := trim(codDest.Values['bairro']);
    dadosDest.Values['cep'] := strnum(codDest.Values['cep']);
    dadosDest.Values['telres'] := strnum(codDest.Values['telres']);
    dadosDest.Values['cid'] := trim(codDest.Values['cid']);
    dadosDest.Values['ies'] := trim(codDest.Values['ies']);
  end
  else
  begin
    query1.Close;
    query1.SQL.Clear;
    query1.SQL.Add('select * from cliente where cod = :cod');
    query1.ParamByName('cod').AsString := strnum(codDest.Values['cod']);
    query1.Open;

    dadosDest.Values['cod'] := strnum(codDest.Values['cod']);
    dadosDest.Values['cod_mun'] :=
      IfThen(trim(query1.fieldbyname('cod_mun').AsString) = '',
      dadosEmitente.Values['cod_mun'],
      trim(query1.fieldbyname('cod_mun').AsString));
    dadosDest.Values['tipo'] := trim(query1.fieldbyname('tipo').AsString);
    dadosDest.Values['cnpj'] := strnum(query1.fieldbyname('cnpj').AsString);
    dadosDest.Values['nome'] := trim(query1.fieldbyname('nome').AsString);
    dadosDest.Values['ende'] := trim(query1.fieldbyname('ende').AsString);
    dadosDest.Values['est'] := trim(query1.fieldbyname('est').AsString);
    dadosDest.Values['bairro'] := trim(query1.fieldbyname('bairro').AsString);
    dadosDest.Values['cep'] := strnum(query1.fieldbyname('cep').AsString);
    dadosDest.Values['telres'] := strnum(query1.fieldbyname('telres').AsString);
    dadosDest.Values['cid'] := trim(query1.fieldbyname('cid').AsString);
    dadosDest.Values['ies'] := trim(query1.fieldbyname('ies').AsString);
  end;

  query1.Close;
end;

procedure lerNodoIde(const codNF: integer; nota: String; serie: String = '1');
begin
  with ACBrNFe.NotasFiscais.Items[0].nfe do
  begin
    Ide.cNF := StrToIntDef(nota, 1);
    Ide.natOp := 'VENDA COMSUMIDOR';
    Ide.indPag := ipVista;
    Ide.modelo := 65;
    Ide.serie := StrToIntDef(serie, 1);
    Ide.nnf := codNF;
    Ide.dEmi := now;
    Ide.dSaiEnt := now;
    Ide.hSaiEnt := now;
    Ide.tpNF := tnSaida;
    if contOFFLINE then
    begin
      Ide.tpEmis := teOffLine;
      Ide.dhCont := now;
      Ide.xJust := 'NOTA FISCAL EMITIDA EM CONTINGENCIA';
    end
    else
      Ide.tpEmis := teNormal;

    // if pgerais.Values['tpamb'] = '1' then
    if ACBrNFe.Configuracoes.WebServices.Ambiente = taProducao then
    begin
      Ide.tpAmb := taProducao;
    end
    else
    begin
      { Ide.tpAmb    := taHomologacao;
        ACBrNFe.Configuracoes.Geral.IdToken := '000001';
        ACBrNFe.Configuracoes.Geral.Token   :=
        LeftStr(dadosEmitente.Values['cnpj'], 8) + IntToStr(YearOf(Now)) + '0001'; }
    end;
    Ide.finNFe := fnNormal;
    Ide.tpImp := tiNFCe;
    Ide.indFinal := cfConsumidorFinal;
    Ide.indPres := pcPresencial;

    Ide.cUF := 14;
    Ide.cMunFG := StrToIntDef(dadosEmitente.Values['cod_mun'], 1400100);

    Transp.modFrete := mfSemFrete; // NFC-e não pode ter FRETE
  end;
end;

procedure lerItensDaVenda(var lista: TList; var nota: string);
var
  desc, temp, tot, temp1: currency;
  i, fim, tem, txtxa, ini: integer;
  aliq: string[3];
  notatemp: String;
  CB: boolean;
  item: Item_venda;
  totalNotaORIGI, quant, tot2, p_venda: currency;
  notas: TStringList;
begin
  // venda := Tvenda.Create;

  tpEmis := '1';
  totalNota := 0;
  TOTDESC := 0;
  totalNotaORIGI := 0;
  dHAtual := '';
  notas := TStringList.Create;
  lista := TList.Create;
  lista.Clear;

  if chaveRecria <> '' then begin
    nota := copy(chaveRecria, 37, 7);
  end;

  nota := trim(nota);

  if Contido(' ', nota) = false then
    notas.Add('0=' + nota)
  else
  begin
    nota := trocachar(nota, ' ', '|');
    nota := '|' + nota + '|';

    LE_CAMPOS(notas, nota, '|');
  end;

  for ini := 0 to notas.Count - 1 do
  begin
    notatemp := strnum(notas.ValueFromIndex[ini]);
    if length(notatemp) <= 10 then
    begin

      lerVenda(notatemp);

      if venda.desconto < 0 then
      begin
        TOTDESC := TOTDESC + abs(venda.desconto);
      end;

      totalNotaORIGI := totalNotaORIGI + venda.total;

      query1.Close;
      query1.SQL.Clear;

      query1.SQL.Add
        ('select cod, quant, total, p_venda, aliquota, p_compra, desconto from item_venda where nota = :nota');
      query1.ParamByName('nota').AsString := notatemp;
      query1.Open;

      if not query1.IsEmpty then
      begin
        nota := notatemp;

        while not query1.Eof do
        begin
          query2.Close;
          query2.SQL.Clear;
          if existeCampoTipo_item then
            query2.SQL.Add
              ('select cod, nome, tipo_item, codbar, unid, aliquota, is_pis, cod_ispis, p_compra, p_venda from produto where cod = :cod')
          else
            query2.SQL.Add
              ('select cod, nome, codbar, unid, aliquota, is_pis, cod_ispis, p_compra, p_venda from produto where cod = :cod');
          query2.ParamByName('cod').AsString :=
            query1.fieldbyname('cod').AsString;
          query2.Open;

          tot2 := 0;

          if not query2.IsEmpty then
          begin
            // quant   := Arredonda(query1.fieldbyname('quant').AsCurrency, 2);
            quant := abs(query1.fieldbyname('quant').AsCurrency);
            // p_venda := Arredonda(query1.fieldbyname('p_venda').AsCurrency, 2);
            p_venda := abs(query1.fieldbyname('p_venda').AsCurrency);
            tot2 := Arredonda(quant * p_venda, 2);

            { if pgerais.Values['71'] <> 'S' then
              if query2.fieldbyname('p_venda').AsCurrency > p_venda then p_venda := query2.fieldbyname('p_venda').AsCurrency;

              if  query1.fieldbyname('desconto').AsCurrency > 0 then begin
              p_venda := p_venda + query1.fieldbyname('desconto').AsCurrency;
              end;

              tot2    := Arredonda(quant * p_venda, 2);
              if  query1.fieldbyname('desconto').AsCurrency > 0 then begin
              tot2 := tot2 + query1.fieldbyname('desconto').AsCurrency;
              end; }

            tem := ProcuraItemNaLista(lista, query1.fieldbyname('cod')
              .AsInteger);
            if tem <> -1 then
            begin
              tot2 := Arredonda(quant * item.p_venda, 2);
              { if query1.fieldbyname('desconto').AsCurrency > 0 then begin
                tot2 := tot2 + query1.fieldbyname('desconto').AsCurrency;
                end; }
              item := lista.Items[tem];
              item.quant := item.quant + quant;
              item.total := item.total + tot2;
              // query1.fieldbyname('total').AsCurrency;
              totalNota := totalNota + tot2;
              // item.total := item.total + query1.fieldbyname('total').AsCurrency;
              // totalNota := totalNota   + query1.fieldbyname('total').AsCurrency;
            end
            else
            begin
              item := Item_venda.Create;

              CB := false;

              try
                CB := checaCodbar(strnum(query2.fieldbyname('codbar').AsString));
              except
              end;

              if CB then
              begin
                item.codbar := strnum(query2.fieldbyname('codbar').AsString);
              end;

              if CB = false then
              begin
                item.codbar :=
                  DIGEAN('789000' + CompletaOuRepete('',
                  query2.fieldbyname('cod').AsString, '0', 6));
              end;

              item.p_compra := query2.fieldbyname('P_compra').AsCurrency;
              item.cod := query2.fieldbyname('cod').AsInteger;
              item.nome := removeCarateresEspeciais(query2.fieldbyname('nome')
                .AsString);
              if trim(item.nome) = '' then
              begin
                item.nome := 'PRODUTO DESCONHECIDO';
              end;

              item.unid := removeCarateresEspeciais
                (IfThen(trim(query2.fieldbyname('unid').AsString) = '', 'UN',
                query2.fieldbyname('unid').AsString));
              item.quant := quant;
              item.p_venda := p_venda;
              item.total := tot2;
              totalNota := totalNota + tot2;

              item.PercICMS := 0;
              item.VlrICMS := 0;
              item.DescICMS := 0;
              item.aliq := strnum(query1.fieldbyname('aliquota').AsString);

              item.Reducao := 0;
              item.codAliq := StrToIntDef(strnum(item.aliq), 0);
              
              if item.codAliq = 0 then
                item.codAliq := 2;

              if existeCampoTipo_item then
              begin
                if Contido('|' + query2.fieldbyname('tipo_item').AsString + '|',
                  '|07|09|') then
                begin
                  item.aliq := '12';
                  item.codAliq := 12;
                end;
              end;

              item.Total_Preco_Compra :=
                Arredonda(query1.fieldbyname('p_compra').AsCurrency, 2);
              item.pis := query2.fieldbyname('is_pis').AsString;
              item.codISPIS := trim(query2.fieldbyname('cod_ispis').AsString);
              item.desconto := 0;
              item.vlr_imposto := 0;

              item.NCM := verNCM(item.cod);
              // IfThen((ConfParamGerais.Strings[26] = 'S') AND (StrToIntDef(dm.IBselect.fieldbyname('classif').AsString, 0) <> 0), StrToIntDef(dm.IBselect.fieldbyname('classif').AsString, 0), 98);

              item.Vlr_Frete := 0;

              query2.Close;
              query2.SQL.Clear;
              query2.SQL.Add('select * from aliq where cod = :cod');
              query2.ParamByName('cod').AsInteger := item.codAliq;
              query2.Open;

              temp1 := 0;
              temp := 0;
              if query2.IsEmpty then
              begin
                query2.Close;
              end
              else
              begin
                temp1 := query2.fieldbyname('aliq').AsCurrency;
                temp := query2.fieldbyname('reducao').AsCurrency;
              end;

              item.PercICMS := temp1;
              item.DescICMS := temp;

              lista.Add(item);
            end; // else -> if tem <> -1 then
          end; // empty

          query1.Next;
        end; // while not query1.Eof do
      end; // for notas.count -1
    end; // if not query1.IsEmpty then begin
  end; // if length(notatemp) <= 10 then begin

  query2.Close;
  query1.Close;
  fim := lista.Count - 1;
  totalNota := 0;

  for i := 0 to fim do
  begin
    item := lista.Items[i];
    item.total := Arredonda(item.p_venda * item.quant, 2);
    totalNota := totalNota + item.total;
  end;

  { ShowMessage('totalNota=' + CurrToStr(totalNota) + #13 +
    'totDesc='+ CurrToStr(totDesc)); }

  // rateio desconto
  if TOTDESC > 0 then
  begin
    desc := TOTDESC;
    fim := lista.Count - 1;
    for i := 0 to fim do
    begin

      item := lista.Items[i];
      if i = fim then
      begin
        if desc < 0 then
          desc := 0;
        item.desconto := Arredonda(desc, 2);
      end
      else
      begin
        temp := Arredonda((item.total / totalNota) * TOTDESC, 2);

        if temp > desc then
        begin
          temp := desc;
        end;

        item.desconto := temp;
        desc := desc - temp;
      end;
    end;
  end;

  // calcula o icms
  fim := lista.Count - 1;
  for i := 0 to lista.Count - 1 do
  begin
    item := lista.Items[i];
    tot := item.total - item.desconto;
    if item.Reducao <> 0 then
    begin
      BASE_ICM := tot - Arredonda(tot * (item.Reducao / 100), 2);
      VLR_ICM := Arredonda(BASE_ICM * (item.PercICMS / 100), 2);
    end
    else
    begin
      BASE_ICM := tot;
      VLR_ICM := Arredonda(tot * item.PercICMS / 100, 2);
    end;

    if item.codAliq > 9 then
    begin
      BASE_ICM := 0;
      VLR_ICM := 0;
    end;
    // item.PercICMS := BASE_ICM;
    item.VlrICMS := VLR_ICM;
  end;

  venda.total := totalNota - venda.desconto;
  notas.Free;
end;

procedure LoadXML(MyMemo: TMemo; MyWebBrowser: TWebBrowser);
begin
  MyMemo.Lines.SaveToFile(ExtractFileDir(application.ExeName) + 'temp.xml');
  MyWebBrowser.Navigate(ExtractFileDir(application.ExeName) + 'temp.xml');
end;

procedure Verifica_Status_NFe;
var
  MemoResp: TMemo;
  MemWeb: TWebBrowser;
begin
  try

    // MemoResp := TMemo.Create(nil);
    // MemWeb   := TWebBrowser.Create(nil);

    { ShowMessage(ACBrNFe.Configuracoes.WebServices.UF + #13 +
      IfThen(ACBrNFe.Configuracoes.WebServices.Ambiente = taProducao, 'PRoducao ', 'homologacao' ) + #13 +
      ACBrNFe.Configuracoes.Geral.IdCSC + #13 + ACBrNFe.Configuracoes.Geral.CSC + #13  +
      ACBrNFe.Configuracoes.Arquivos.PathSchemas); }
    ACBrNFe.Configuracoes.Geral.ModeloDF := moNFCe;
    ACBrNFe.Configuracoes.WebServices.Visualizar := true;
    ACBrNFe.WebServices.StatusServico.Executar;
  finally
    ACBrNFe.Configuracoes.WebServices.Visualizar := false;
  end;
end;

procedure GravarConfiguracao(certificadoCaminho, certificadoSenha,
  certificadoNumeroSerie: String; FinalidadeNFE, DANFETipo, DANFEFormaEmissao
  : integer; DANFELogomarca: String; ArqLog: boolean; CaminhoLog, WebUF: String;
  WebAmbiente: integer; WebVisualiza: boolean; ProxHost, ProxPorta, ProxUser,
  ProxSenha, EmailHost, EmailPorta, EmailUsuario, EmailSenha,
  EmailAssunto: String; mmEmailMsg: TMemo; EmailSSL: boolean;
  ArquivosPDF: String; ArquivosNFE: String; CDCFOP: String;
  idToken, Token: String; idxImpre, idxImpreNFe, tipoImpre: integer;
  preview: boolean; const portaBalanca, veloBal, tipoBal: string;
  serie: String = '1'; qtdViasStr: String = '1'; tipoImp: String = '0';
  PortaImpNFCE: String = ''; previewNFCe: boolean = false);
var
  qtd: integer;
  IniFile: String;
  ini: TIniFile;
  StreamMemo: TMemoryStream;
begin
  try
    // IniFile    := ChangeFileExt(Application.ExeName, '.ini') ;
    if FileExists(ExtractFileDir(ParamStr(0)) + '\ControlW.ini') then
    begin
      IniFile := ExtractFileDir(ParamStr(0)) + '\ControlW.ini';
      // exit;
    end
    else
    begin
      IniFile := ChangeFileExt(application.ExeName, '.ini');
    end;

    ini := TIniFile.Create(IniFile);

    // mmEmailMsg := TMemo.Create(nil);

    ini.WriteString('BALANCA', 'PORTA', portaBalanca);
    ini.WriteString('BALANCA', 'VELO', veloBal);
    ini.WriteString('BALANCA', 'BALANCA', tipoBal);

    ini.WriteString('Certificado', 'Caminho', certificadoCaminho);
    ini.WriteString('Certificado', 'Senha', certificadoSenha);
    ini.WriteString('Certificado', 'NumSerie', certificadoNumeroSerie);
    //
    qtd := StrToIntDef(strnum(qtdViasStr), 1);
    if qtd < 1 then
      qtd := 1;
    ini.WriteInteger('Geral', 'ViasNFe', qtd);
    ini.WriteInteger('Geral', 'Finalidade', FinalidadeNFE);

    ini.WriteInteger('Geral', 'DANFE', DANFETipo);
    ini.WriteInteger('Geral', 'FormaEmissao', DANFEFormaEmissao);
    ini.WriteString('Geral', 'LogoMarca', DANFELogomarca);
    ini.WriteString('Geral', 'PortaImpNFCE', PortaImpNFCE);
    ini.WriteInteger('Geral', 'impIndex', StrToIntDef(tipoImp, 0));
    ini.WriteBool('Geral', 'Salvar', ArqLog);

    ini.WriteInteger('Geral', 'TipoImpressao', tipoImpre);
    ini.WriteInteger('Geral', 'idxImpressora', idxImpre);
    ini.WriteInteger('Geral', 'idxImpressoraNFe', idxImpreNFe);
    ini.WriteBool('Geral', 'preview', preview);
    ini.WriteBool('Geral', 'previewNFCe', previewNFCe);
    ini.WriteInteger('Geral', 'serie', StrToIntDef(serie, 1));

    ini.WriteString('Geral', 'PathSalvar', CaminhoLog);
    ini.WriteString('Geral', 'CFOP', CDCFOP);

    ini.WriteString('Geral', 'ArquivosPDF', ArquivosPDF);
    ini.WriteString('Geral', 'ArquivosNFE', ArquivosNFE);

    ini.WriteString('Geral', 'IDToken', idToken);
    ini.WriteString('Geral', 'Token', Token);

    ini.WriteString('Certificado', 'ArquivosPDF', ArquivosPDF);
    ini.WriteString('Certificado', 'ArquivosNFe', ArquivosNFE);
    //
    ini.WriteString('WebService', 'UF', WebUF);
    ini.WriteInteger('WebService', 'Ambiente', WebAmbiente);
    ini.WriteBool('WebService', 'Visualizar', WebVisualiza);
    //
    ini.WriteString('Proxy', 'Host', ProxHost);
    ini.WriteString('Proxy', 'Porta', ProxPorta);
    ini.WriteString('Proxy', 'User', ProxUser);
    ini.WriteString('Proxy', 'Pass', ProxSenha);
    //
    ini.WriteString('Email', 'Host', EmailHost);
    ini.WriteString('Email', 'Port', EmailPorta);
    ini.WriteString('Email', 'User', EmailUsuario);
    ini.WriteString('Email', 'Pass', EmailSenha);
    ini.WriteString('Email', 'Assunto', EmailAssunto);
    ini.WriteBool('Email', 'SSL', EmailSSL);

    StreamMemo := TMemoryStream.Create;
    mmEmailMsg.Lines.SaveToStream(StreamMemo);
    StreamMemo.Seek(0, soFromBeginning);
    ini.WriteBinaryStream('Email', 'Mensagem', StreamMemo);
    StreamMemo.Free;
  finally
    ini.Free;
    FreeAndNil(mmEmailMsg);
  end;
end;

function LerConfiguracaoCFOP(): String;
var
  ini: TIniFile;
  IniFile: String;
begin
  Result := '';
  try
    IniFile := ChangeFileExt(application.ExeName, '.ini');
    ini := TIniFile.Create(IniFile);
    Result := ini.ReadString('Geral', 'CFOP', '');
  finally
    ini.Free;
  end;
end;

procedure LerConfiguracaoNFCe(abreBD: boolean = true);
var
  certificadoCaminho: String;
  certificadoSenha: String;
  certificadoNumeroSerie: String;
  Finalidade: integer;
  DANFETipo: integer;
  DANFEFormaEmissao: integer;
  DANFELogomarca: String;
  ArqLog: boolean;
  CaminhoLog: String;
  WebUF: String;
  WebAmbiente: integer;
  WebVisualiza: boolean;
  ProxHost: String;
  ProxPorta: String;
  ProxUser: String;
  ProxSenha: String;
  EmailHost: String;
  EmailPorta: String;
  EmailUsuario: String;
  EmailSenha: String;
  EmailAssunto: String;
  EmailSSL: boolean;
  IniFile: String;
  ini: TIniFile;
  ok: boolean;
  StreamMemo: TMemoryStream;
  mmEmailMsg: TMemo;
  TipoAmbiente, FinalidadeNFE, UFComerciante,
  /// CDCFOP,
  TipoEmissao, ArquivoPDF, ArquivoNFE, SenhaCertificado: string;
begin

  // campoDescontoExiste := VerificaCampoTabela1('desconto', 'item_venda', query1);

  if FileExists(ExtractFileDir(ParamStr(0)) + '\ControlW.ini') then
  begin
    IniFile := ExtractFileDir(ParamStr(0)) + '\ControlW.ini';
    // exit;
  end
  else
  begin
    IniFile := ChangeFileExt(application.ExeName, '.ini');
  end;
  // IniFile    := ChangeFileExt( Application.ExeName, '.ini') ;
  ini := TIniFile.Create(IniFile);
  mmEmailMsg := TMemo.Create(nil);
  try
    if DANFE <> nil then
      ACBrNFe.DANFE := DANFE;

{$IFDEF ACBrNFeOpenSSL}
    certificadoCaminho := ini.ReadString('Certificado', 'Caminho', '');
    certificadoSenha := ini.ReadString('Certificado', 'Senha', '');
    ACBrNFe.Configuracoes.Certificados.Certificado := certificadoCaminho;
    ACBrNFe.Configuracoes.Certificados.Senha := certificadoSenha;
    //
    certificadoNumeroSerie := ini.ReadString('Certificado', 'NumSerie', '');
    ACBrNFe.Configuracoes.Certificados.NumeroSerie := certificadoNumeroSerie;
    certificadoNumeroSerie := ACBrNFe.Configuracoes.Certificados.NumeroSerie;

{$ELSE}
    SenhaCertificado := ini.ReadString('Certificado', 'Senha', '');
    certificadoNumeroSerie := ini.ReadString('Certificado', 'NumSerie', '');
    ACBrNFe.SSL.NumeroSerie := certificadoNumeroSerie;
    ACBrNFe.SSL.Senha := SenhaCertificado;
    // certificadoNumeroSerie                                  := ACBrNFe.Configuracoes.Certificados.NumeroSerie;
{$ENDIF}
    ACBrNFe.Configuracoes.Geral.CSC := ini.ReadString('Geral', 'Token', '');
    ACBrNFe.Configuracoes.Geral.IdCSC := ini.ReadString('Geral', 'IDToken', '');

    DANFEFormaEmissao := ini.ReadInteger('Geral', 'FormaEmissao', 0);
    TipoEmissao := IntToStr(DANFEFormaEmissao);
    ArqLog := ini.ReadBool('Geral', 'Salvar', true);

    tipoDanfe := ini.ReadInteger('SERVER', 'tipoNFe', 0);
    DANFE_Rave.tipoDanfe := TpcnTipoImpressao(tipoDanfe);
    DANFE.ImprimirDescPorc := ini.ReadBool('SERVER', 'impDescProduto', true);
    DANFE_Rave.ImprimeNomeFantasia := ini.ReadBool('SERVER',
      'imprimirNomeFantasia', false);

    DANFE.ImprimeDescAcrescItem := ini.ReadBool('SERVER',
      'impDescProduto', true);

    impreNFCE := ini.ReadString('SERVER', 'ImpNFCe', '');
    impreNFE := ini.ReadString('SERVER', 'ImpNFe', '');

    DANFE.ImprimeDescAcrescItem := ini.ReadBool('SERVER',
      'impDescProduto', true);
    if DANFEEscPos.PosPrinter <> nil then
    begin
      DANFEEscPos.PosPrinter.ControlePorta :=
        ini.ReadBool('SERVER', 'ControleDePorta', false);
      // if DANFEEscPos.PosPrinter.ControlePorta then    ShowMessage('1')
      // else ShowMessage('0');
    end;

    tipoImp := ini.ReadInteger('Geral', 'impIndex', 0);

    ArquivoPDF := ini.ReadString('Geral', 'ArquivosPDF', '');
    ArquivoNFE := ini.ReadString('Geral', 'ArquivosNFE', '');
    CDCFOP := ini.ReadString('Geral', 'CFOP', '');
    portaCOMNFCE := ini.ReadString('Geral', 'PortaImpNFCE', '');

    try
      DANFEEscPos.PosPrinter.modelo := TACBrPosPrinterModelo(tipoImp);
      DANFEEscPos.PosPrinter.Device.Baud :=
        StrToIntDef(ini.ReadString('SERVER', 'velocidade', '9600'), 9600);
      DANFEEscPos.PosPrinter.EspacoEntreLinhas :=
        StrToIntDef(ini.ReadString('SERVER', 'espacoEntreLinhas', '50'), 50);

      if DANFEEscPos.PosPrinter.modelo = ppEscPosEpson then
      begin
        DANFEEscPos.PosPrinter.Device.TimeOut := 20;
      end;

      DANFEEscPos.PosPrinter.Device.porta := portaCOMNFCE;
      DANFEEscPos.PosPrinter.LinhasEntreCupons := 10;
      DANFEEscPos.PosPrinter.CortaPapel := true;
    except
    end;

    qtdVias := 1;
    qtdVias := ini.ReadInteger('Geral', 'ViasNFe', 1);
    if qtdVias < 1 then
      qtdVias := 1;
    if CDCFOP = '' then
      CDCFOP := '5102';

    existeCampoTipo_item := true;

    if abreBD then
    begin
      existeCampoTipo_item := VerificaCampoTabela1('tipo_item',
        'produto', query1);
    end;

    CaminhoLog := ini.ReadString('Geral', 'PathSalvar', '');

    // pastaControlW := buscaPastaConfigControlRede();
    pastaControlW := ini.ReadString('Geral', 'ArquivosNFE', '');
    if trim(pastaControlW) = '' then
      pastaControlW := ExtractFileDir(ParamStr(0)) + '\';

    criaPasta(pastaControlW + 'NFCe\');
    criaPasta(pastaControlW + 'NFCe\EMIT\');
    criaPasta(pastaControlW + 'NFCe\CANC\');
    criaPasta(pastaControlW + 'NFCe\RESP\');
    criaPasta(pastaControlW + 'NFCe\PDF\');
    if DANFE <> nil then
      DANFE.PathPDF := pastaControlW + 'NFCe\PDF\';

    { Balanca }

    ACBrNFe.Configuracoes.Geral.FormaEmissao :=
      StrToTpEmis(ok, IntToStr(DANFEFormaEmissao + 1));
    ACBrNFe.Configuracoes.Geral.Salvar := false;
    // ACBrNFe.Configuracoes.Geral.AtualizarXMLCancelado := true;
    ACBrNFe.Configuracoes.WebServices.Salvar := false;
    ACBrNFe.Configuracoes.Arquivos.Salvar := false;
    ACBrNFe.Configuracoes.Arquivos.SalvarEvento := true;
    ACBrNFe.Configuracoes.Arquivos.EmissaoPathNFe := true;
    ACBrNFe.Configuracoes.Arquivos.SalvarApenasNFeProcessadas := true;

    ACBrNFe.Configuracoes.Arquivos.PathSalvar := pastaControlW + 'NFCe\EMIT\';
    ACBrNFe.Configuracoes.Arquivos.PathNFe := pastaControlW + 'NFCe\EMIT\';

    ACBrNFe.Configuracoes.Arquivos.PathSchemas := ExtractFileDir(ParamStr(0)) +
      '\Schemas';

    WebUF := ini.ReadString('WebService', 'UF', 'RR');
    WebAmbiente := ini.ReadInteger('WebService', 'Ambiente', 1);

    UFComerciante := WebUF;
    FinalidadeNFE := '0';
    TipoAmbiente := IntToStr(WebAmbiente);
    WebVisualiza := ini.ReadBool('WebService', 'Visualizar', false);
    ACBrNFe.Configuracoes.WebServices.UF := WebUF;
    ACBrNFe.Configuracoes.WebServices.Ambiente :=
      StrToTpAmb(ok, IntToStr(WebAmbiente));

    if WebAmbiente = 1 then
    begin
      ACBrNFe.Configuracoes.WebServices.Ambiente        := taProducao;
      ACBrNFe.Configuracoes.Geral.CamposFatObrigatorios := false;
    end
    else
    begin
      ACBrNFe.Configuracoes.WebServices.Ambiente := taHomologacao;
      ACBrNFe.Configuracoes.Geral.CamposFatObrigatorios := true;
    end;

    ACBrNFe.Configuracoes.WebServices.Visualizar := WebVisualiza;
    gTipoEmissao := TipoEmissao;
    gTipoAmbiente := TipoAmbiente;
    gUFComerciante := UFComerciante;
    gFinalidadeNFe := FinalidadeNFE;

    //
    ProxHost := ini.ReadString('Proxy', 'Host', '');
    ProxPorta := ini.ReadString('Proxy', 'Porta', '');
    ProxUser := ini.ReadString('Proxy', 'User', '');
    ProxSenha := ini.ReadString('Proxy', 'Pass', '');
    //

    gProxHost := ini.ReadString('Proxy', 'Host', '');
    gProxPorta := ini.ReadString('Proxy', 'Porta', '');
    gProxUser := ini.ReadString('Proxy', 'User', '');
    gProxSenha := ini.ReadString('Proxy', 'Pass', '');

    indxImpressora := ini.ReadInteger('Geral', 'idxImpressora', 0);
    indxImpressoraNFE := ini.ReadInteger('Geral', 'idxImpressoraNFe', 0);
    tipoIMPRESSAO := ini.ReadInteger('Geral', 'TipoImpressao', 0);

    serie2 := StrToIntDef(trim(ini.ReadString('Geral', 'serie', '')), 1);;
    usarCertificadoA3 := ini.ReadBool('SERVER', 'usarCertiA3', false);

    previewNFCe1 := ini.ReadBool('Geral', 'previewNFCe', false);
    try
      DANFE.MostrarPreview := previewNFCe1;
    except
    end;
    preview := ini.ReadBool('Geral', 'preview', false);

    // setPrinter(indxImpressora);
    // seta a impressora padrao de nfe
    //
    ACBrNFe.Configuracoes.WebServices.ProxyHost := ProxHost;
    ACBrNFe.Configuracoes.WebServices.ProxyPort := ProxPorta;
    ACBrNFe.Configuracoes.WebServices.ProxyUser := ProxUser;
    ACBrNFe.Configuracoes.WebServices.ProxyPass := ProxSenha;
    //
    { ACBrNFe.Configuracoes.Arquivos.PathNFe  := ExtractFilePath(Application.ExeName);
      ACBrNFe.Configuracoes.Arquivos.PathCan  := ExtractFilePath(Application.ExeName);
      ACBrNFe.Configuracoes.Arquivos.PathInu  := ExtractFilePath(Application.ExeName);
      ACBrNFe.Configuracoes.Arquivos.PathDPEC := ExtractFilePath(Application.ExeName);
      ACBrNFe.Configuracoes.Geral.PathSalvar  := ExtractFilePath(Application.ExeName);
    }
    //
    DANFETipo := ini.ReadInteger('Geral', 'DANFE', 0);
    DANFELogomarca := ini.ReadString('Geral', 'LogoMarca', '');

    //
    if DANFEEscPos <> nil then
    begin
      DANFEEscPos.Sistema := 'Controlw Sistemas';
    end;

    if DANFE <> nil then
    begin
      DANFE.Sistema := 'Controlw Sistemas';
      // ACBrNFe.DANFE.TipoDANFE  := StrToTpImp(OK,IntToStr(DANFETipo+1));
      // ACBrNFe.DANFE.Logo       := DANFELogomarca;
    end;

    if DANFE_Rave <> nil then
    begin
      DANFE_Rave.Sistema := 'Controlw Sistemas';
      DANFE_Rave.ExibeCampoFatura := true;
      DANFE_Rave.logo := DANFELogomarca;
      if FileExists(DANFELogomarca) then
      begin
        DANFE_Rave.ExpandirLogoMarca :=
          ini.ReadBool('SERVER', 'expandirLogo', false);
        expLogoMarca := ini.ReadBool('SERVER', 'expandirLogo', false);
        DANFE_Rave.TamanhoLogoHeight := ini.ReadInteger('SERVER',
          'FonteOutCampos', 10);
        DANFE_Rave.TamanhoFonteEndereco := ini.ReadInteger('SERVER',
          'fonteEnde', 0);
        DANFE_Rave.TamanhoLogoHeight := ini.ReadInteger('SERVER',
          'logoheigth', 1);
        DANFE_Rave.TamanhoLogoWidth := ini.ReadInteger('SERVER',
          'LOGOWIDTH', 1);
        DANFE_Rave.Fonte.TamanhoFonte_RazaoSocial :=
          ini.ReadInteger('SERVER', 'fonteRazao', 8);

      end;
    end;

    margemEsquerda := ini.ReadString('SERVER', 'MargemEsquerda', '0,1');
    DANFE.margemEsquerda := StrToCurrDef(margemEsquerda, 0.1);
    if DANFE.margemEsquerda = 0.6 then
      DANFE.margemEsquerda := 0.1;
    DANFE.LarguraBobina := 280;
    //

    EmailHost := ini.ReadString('Email', 'Host', '');
    EmailPorta := ini.ReadString('Email', 'Port', '');
    EmailUsuario := ini.ReadString('Email', 'User', '');
    EmailSenha := ini.ReadString('Email', 'Pass', '');
    EmailAssunto := ini.ReadString('Email', 'Assunto', '');
    EmailSSL := ini.ReadBool('Email', 'SSL', false);

    if AcbrEmail <> nil then
    begin
      AcbrEmail.Host := EmailHost;
      AcbrEmail.Port := EmailPorta;
      AcbrEmail.Username := EmailUsuario;
      AcbrEmail.Password := EmailSenha;
      AcbrEmail.From := EmailAssunto;
      AcbrEmail.SetSSL := EmailSSL; // SSL - ConexÃ£o Segura
      AcbrEmail.SetTLS := ini.ReadBool('SERVER', 'usarTLS', false);
      AcbrEmail.ReadingConfirmation := false;
      // Pede confirmaÃ§Ã£o de leitura do email
      AcbrEmail.UseThread := false; // Aguarda Envio do Email(nÃ£o usa thread)
    end;

    EmailMsg := TStringList.Create;

    StreamMemo := TMemoryStream.Create;
    try
      ini.ReadBinaryStream('Email', 'Mensagem', StreamMemo);
      EmailMsg.LoadFromStream(StreamMemo);
    except
      on e: Exception do
      begin
        ShowMessage(e.Message);
      end;
    end;
    StreamMemo.Free;

    // ACBrNFe.Configuracoes.Geral.AtualizarXMLCancelado := true;
    DANFE_Rave.MostrarPreview := preview;

    ACBrNFe.Configuracoes.Geral.ModeloDF := moNFCe;
  finally
    ini.Free;
    mmEmailMsg.Free;
  end;
end;

procedure LerConfiguracaoNFe();
var
  certificadoCaminho: String;
  certificadoSenha: String;
  certificadoNumeroSerie: String;
  Finalidade: integer;
  DANFETipo: integer;
  DANFEFormaEmissao: integer;
  DANFELogomarca: String;
  ArqLog: boolean;
  CaminhoLog: String;
  WebUF: String;
  WebAmbiente: integer;
  WebVisualiza: boolean;
  ProxHost: String;
  ProxPorta: String;
  ProxUser: String;
  ProxSenha: String;
  EmailHost: String;
  EmailPorta: String;
  EmailUsuario: String;
  EmailSenha: String;
  EmailAssunto: String;
  EmailSSL: boolean;
  IniFile: String;
  ini: TIniFile;
  ok, preview: boolean;
  StreamMemo: TMemoryStream;
  mmEmailMsg: TMemo;
  TipoAmbiente, FinalidadeNFE, UFComerciante, CDCFOP, TipoEmissao, ArquivoPDF,
    ArquivoNFE, SenhaCertificado: string;
begin

  ACBrNFe.DANFE := DANFE;
  DANFE.NFeCancelada := false;

  if FileExists(ExtractFileDir(ParamStr(0)) + '\ControlW.ini') then
  begin
    IniFile := ExtractFileDir(ParamStr(0)) + '\ControlW.ini';
    // exit;
  end
  else
  begin
    IniFile := ChangeFileExt(application.ExeName, '.ini');
  end;
  // IniFile    := ChangeFileExt( Application.ExeName, '.ini') ;
  // IniFile    := ChangeFileExt( Application.ExeName, '.ini') ;
  ini := TIniFile.Create(IniFile);
  mmEmailMsg := TMemo.Create(nil);
  try
{$IFDEF ACBrNFeOpenSSL}
    certificadoCaminho := ini.ReadString('Certificado', 'Caminho', '');
    certificadoSenha := ini.ReadString('Certificado', 'Senha', '');
    ACBrNFe.Configuracoes.Certificados.Certificado := certificadoCaminho;
    ACBrNFe.Configuracoes.Certificados.Senha := certificadoSenha;
    //
    certificadoNumeroSerie := ini.ReadString('Certificado', 'NumSerie', '');
    ACBrNFe.Configuracoes.Certificados.NumeroSerie := certificadoNumeroSerie;
    certificadoNumeroSerie := ACBrNFe.Configuracoes.Certificados.NumeroSerie;

{$ELSE}
    SenhaCertificado := ini.ReadString('Certificado', 'Senha', '');
    certificadoNumeroSerie := ini.ReadString('Certificado', 'NumSerie', '');
    ACBrNFe.Configuracoes.Certificados.NumeroSerie := certificadoNumeroSerie;
    ACBrNFe.Configuracoes.Certificados.Senha := SenhaCertificado;
    certificadoNumeroSerie := ACBrNFe.Configuracoes.Certificados.NumeroSerie;
{$ENDIF}
    DANFEFormaEmissao := ini.ReadInteger('Geral', 'FormaEmissao', 0);
    TipoEmissao := IntToStr(DANFEFormaEmissao);
    ArqLog := ini.ReadBool('Geral', 'Salvar', true);

    ArquivoPDF := ini.ReadString('Geral', 'ArquivosPDF', '');
    ArquivoNFE := ini.ReadString('Geral', 'ArquivosNFE', '');
    CDCFOP := ini.ReadString('Geral', 'CFOP', '');

    CaminhoLog := ini.ReadString('Geral', 'PathSalvar', '');

    pastaControlW := buscaPastaConfigControlRede();
    if pastaControlW = '' then
      pastaControlW := ExtractFileDir(ParamStr(0)) + '\';

    criaPasta(pastaControlW + 'NFe\');
    criaPasta(pastaControlW + 'NFe\EMIT\');
    criaPasta(pastaControlW + 'NFe\CANC\');
    criaPasta(pastaControlW + 'NFe\RESP\');
    criaPasta(pastaControlW + 'NFe\PDF\');
    DANFE.PathPDF := pastaControlW + 'NFe\PDF\';
    // DANFE_Rave.PathPDF                                   := pastaControlW + 'NFe\PDF\';

    ACBrNFe.Configuracoes.Geral.FormaEmissao :=
      StrToTpEmis(ok, IntToStr(DANFEFormaEmissao + 1));
    ACBrNFe.Configuracoes.Arquivos.PathSalvar := pastaControlW + 'NFe\RESP\';
    ACBrNFe.Configuracoes.Arquivos.PathNFe := pastaControlW + 'NFe\EMIT\';
    // ACBrNFe.Configuracoes.Arquivos.PathCan       := pastaControlW + 'NFe\CANC\';

    ACBrNFe.Configuracoes.Geral.Salvar := false;
    // ACBrNFe.Configuracoes.Geral.AtualizarXMLCancelado := true;
    ACBrNFe.Configuracoes.WebServices.Salvar := false;
    ACBrNFe.Configuracoes.Arquivos.Salvar := true;
    ACBrNFe.Configuracoes.Arquivos.EmissaoPathNFe := true;
    ACBrNFe.Configuracoes.Arquivos.SalvarApenasNFeProcessadas := true;
    ACBrNFe.Configuracoes.Arquivos.PathSchemas := pastaControlW + 'Schemas';
    //
    WebUF := ini.ReadString('WebService', 'UF', 'RR');
    WebAmbiente := ini.ReadInteger('WebService', 'Ambiente', 1);

    UFComerciante := WebUF;
    FinalidadeNFE := '0';
    TipoAmbiente := IntToStr(WebAmbiente);
    WebVisualiza := ini.ReadBool('WebService', 'Visualizar', false);
    ACBrNFe.Configuracoes.WebServices.UF := WebUF;
    ACBrNFe.Configuracoes.WebServices.Ambiente :=
      StrToTpAmb(ok, IntToStr(WebAmbiente));
    ACBrNFe.Configuracoes.WebServices.Visualizar := WebVisualiza;
    gTipoEmissao := TipoEmissao;
    gTipoAmbiente := TipoAmbiente;
    gUFComerciante := UFComerciante;
    gFinalidadeNFe := FinalidadeNFE;

    //
    ProxHost := ini.ReadString('Proxy', 'Host', '');
    ProxPorta := ini.ReadString('Proxy', 'Porta', '');
    ProxUser := ini.ReadString('Proxy', 'User', '');
    ProxSenha := ini.ReadString('Proxy', 'Pass', '');
    //
    gProxHost := ini.ReadString('Proxy', 'Host', '');
    gProxPorta := ini.ReadString('Proxy', 'Porta', '');
    gProxUser := ini.ReadString('Proxy', 'User', '');
    gProxSenha := ini.ReadString('Proxy', 'Pass', '');

    indxImpressora := ini.ReadInteger('Geral', 'idxImpressora', 0);
    indxImpressoraNFE := ini.ReadInteger('Geral', 'idxImpressoraNFe', 0);
    tipoIMPRESSAO := ini.ReadInteger('Geral', 'TipoImpressao', 0);
    preview := ini.ReadBool('Geral', 'preview', false);

    // setPrinter(indxImpressora);
    // seta a impressora padrao de nfe
    //
    ACBrNFe.Configuracoes.WebServices.ProxyHost := ProxHost;
    ACBrNFe.Configuracoes.WebServices.ProxyPort := ProxPorta;
    ACBrNFe.Configuracoes.WebServices.ProxyUser := ProxUser;
    ACBrNFe.Configuracoes.WebServices.ProxyPass := ProxSenha;
    //
    { ACBrNFe.Configuracoes.Arquivos.PathNFe  := ExtractFilePath(Application.ExeName);
      ACBrNFe.Configuracoes.Arquivos.PathCan  := ExtractFilePath(Application.ExeName);
      ACBrNFe.Configuracoes.Arquivos.PathInu  := ExtractFilePath(Application.ExeName);
      ACBrNFe.Configuracoes.Arquivos.PathDPEC := ExtractFilePath(Application.ExeName);
      ACBrNFe.Configuracoes.Geral.PathSalvar  := ExtractFilePath(Application.ExeName);
    }
    //
    DANFETipo := ini.ReadInteger('Geral', 'DANFE', 0);
    DANFELogomarca := ini.ReadString('Geral', 'LogoMarca', '');
    //
    if ACBrNFe.DANFE <> nil then
    begin
      ACBrNFe.DANFE.tipoDanfe := tiRetrato;
      ACBrNFe.DANFE.logo := DANFELogomarca;
    end;
    //
    EmailHost := ini.ReadString('Email', 'Host', '');
    EmailPorta := ini.ReadString('Email', 'Port', '');
    EmailUsuario := ini.ReadString('Email', 'User', '');
    EmailSenha := ini.ReadString('Email', 'Pass', '');
    EmailAssunto := ini.ReadString('Email', 'Assunto', '');
    EmailSSL := ini.ReadBool('Email', 'SSL', false);
    StreamMemo := TMemoryStream.Create;
    ini.ReadBinaryStream('Email', 'Mensagem', StreamMemo);
    mmEmailMsg.Lines.LoadFromStream(StreamMemo);
    StreamMemo.Free;

    // ACBrNFe.Configuracoes.Geral.AtualizarXMLCancelado := true;
    // ACBrNFe.Configuracoes.Geral.VersaoDF := ve310;
    ACBrNFe.DANFE := DANFE;
    ACBrNFe.DANFE.MostrarPreview := preview;
    ACBrNFe.Configuracoes.Geral.ModeloDF := moNFe;
  finally
    ini.Free;
    FreeAndNil(mmEmailMsg);
  end;
end;

procedure CarregarConfiguracao();
var
  IniFile: String;
  ini: TIniFile;
  ok: boolean;
  StreamMemo: TMemoryStream;
  mmEmailMsg: TMemo;
  //
  certificadoCaminho, certificadoSenha, certificadoNumeroSerie: String;
  Finalidade: integer;
  DANFETipo: integer;
  DANFEFormaEmissao: integer;
  DANFELogomarca: String;
  ArqLog: boolean;
  CaminhoLog: String;
  WebUF: String;
  WebAmbiente: integer;
  WebVisualiza: boolean;
  ProxHost: String;
  ProxPorta: String;
  ProxUser: String;
  ProxSenha: String;
  EmailHost: String;
  EmailPorta: String;
  EmailUsuario: String;
  EmailSenha: String;
  EmailAssunto: String;
  EmailSSL: boolean;
begin
  IniFile := ChangeFileExt(application.ExeName, '.ini');
  ini := TIniFile.Create(IniFile);
  mmEmailMsg := TMemo.Create(nil);
  try
{$IFDEF ACBrNFeOpenSSL}
    certificadoCaminho := ini.ReadString('Certificado', 'Caminho', '');
    certificadoSenha := ini.ReadString('Certificado', 'Senha', '');
    ACBrNFe.Configuracoes.Certificados.Certificado := certificadoCaminho;
    ACBrNFe.Configuracoes.Certificados.Senha := certificadoSenha;
{$ELSE}
    certificadoNumeroSerie := ini.ReadString('Certificado', 'NumSerie', '');
    ACBrNFe.Configuracoes.Certificados.NumeroSerie := certificadoNumeroSerie;
    certificadoNumeroSerie := ACBrNFe.Configuracoes.Certificados.NumeroSerie;
{$ENDIF}
    ACBrNFe.Configuracoes.Geral.CSC := ini.ReadString('Geral', 'Token', '');
    ACBrNFe.Configuracoes.Geral.IdCSC := ini.ReadString('Geral', 'IDToken', '');

    // ShowMessage(ACBrNFe.Configuracoes.Geral.Token + #13 + ACBrNFe.Configuracoes.Geral.IdToken);

    DANFEFormaEmissao := ini.ReadInteger('Geral', 'FormaEmissao', 0);
    ArqLog := ini.ReadBool('Geral', 'Salvar', true);
    CaminhoLog := ini.ReadString('Geral', 'PathSalvar', '');
    ACBrNFe.Configuracoes.Geral.FormaEmissao :=
      StrToTpEmis(ok, IntToStr(DANFEFormaEmissao + 1));
    ACBrNFe.Configuracoes.Geral.Salvar := ArqLog;
    ACBrNFe.Configuracoes.Arquivos.PathSalvar := CaminhoLog;
    //
    WebUF := ini.ReadString('WebService', 'UF', 'MG');
    WebAmbiente := ini.ReadInteger('WebService', 'Ambiente', 0);

    pgerais.Values['tpamb'] := IntToStr(WebAmbiente);

    WebVisualiza := ini.ReadBool('WebService', 'Visualizar', false);
    ACBrNFe.Configuracoes.WebServices.UF := WebUF;
    ACBrNFe.Configuracoes.WebServices.Ambiente :=
      StrToTpAmb(ok, IntToStr(WebAmbiente));
    ACBrNFe.Configuracoes.WebServices.Visualizar := WebVisualiza;

    //
    ProxHost := ini.ReadString('Proxy', 'Host', '');
    ProxPorta := ini.ReadString('Proxy', 'Porta', '');
    ProxUser := ini.ReadString('Proxy', 'User', '');
    ProxSenha := ini.ReadString('Proxy', 'Pass', '');
    //
    ACBrNFe.Configuracoes.WebServices.ProxyHost := ProxHost;
    ACBrNFe.Configuracoes.WebServices.ProxyPort := ProxPorta;
    ACBrNFe.Configuracoes.WebServices.ProxyUser := ProxUser;
    ACBrNFe.Configuracoes.WebServices.ProxyPass := ProxSenha;
    //
    DANFETipo := ini.ReadInteger('Geral', 'DANFE', 0);
    DANFELogomarca := ini.ReadString('Geral', 'LogoMarca', '');
    if ACBrNFe.DANFE <> nil then
    begin
      ACBrNFe.DANFE.tipoDanfe := StrToTpImp(ok, IntToStr(DANFETipo + 1));
      ACBrNFe.DANFE.logo := DANFELogomarca;
    end;
    //
    EmailHost := ini.ReadString('Email', 'Host', '');
    EmailPorta := ini.ReadString('Email', 'Port', '');
    EmailUsuario := ini.ReadString('Email', 'User', '');
    EmailSenha := ini.ReadString('Email', 'Pass', '');
    EmailAssunto := ini.ReadString('Email', 'Assunto', '');
    EmailSSL := ini.ReadBool('Email', 'SSL', false);
    StreamMemo := TMemoryStream.Create;
    ini.ReadBinaryStream('Email', 'Mensagem', StreamMemo);
    mmEmailMsg.Lines.LoadFromStream(StreamMemo);
    StreamMemo.Free;
  finally
    ini.Free;
    FreeAndNil(mmEmailMsg);
  end;
end;

function EnviarCupomEletronicoTitular(nota: String; var Status, xmotivo: string;
  const tipo: integer; const enviar: boolean; const cliente1: String;
  obs1: String = ''; serie1: String = '1'; nnf: STRING = '';
  imp: boolean = true; recebido: currency = 0; EscPos: boolean = false)
  : boolean;
var
  SQL, qUsuario, para, ssChave, erro1, NumeroRecibo, ser, erroTemp: string;
  Mensagememail: TStrings;
  csta, i: integer;
  enviou: boolean;
  xml: AnsiString;
  arq: TStringList;
  TOTNOTA: currency;
begin
  setVersaoNFCe;
  //ACBrNFe.Configuracoes.Geral.v
  if verificarValidadeCertificado(false) = false then
    exit;

  TOTNOTA := 0;
  { query1.Close;
    query1.SQL.Text := 'select total from venda where nota = :nota';
    query1.ParamByName('nota').AsString := nota;
    query1.Open;

    totNota := query1.FieldByName('total').AsCurrency; }

  try
    Result := false;
    if not Contido(' ', nota) then
    begin
      query1.Close;
      query1.SQL.text := 'select total from venda where nota = :nota';
      query1.ParamByName('nota').AsString := nota;
      query1.Open;

      if query1.fieldbyname('total').AsCurrency <= 0 then
      begin
        ShowMessage('Não Pode Ser Emitido Uma NFCe desta Venda!' + #13 +
          'Venda Com Valor R$ ' + formataCurrency(query1.fieldbyname('total')
          .AsCurrency));
        query1.Close;
        exit;
      end;

      TOTNOTA := query1.fieldbyname('total').AsCurrency;

      query1.Close;
      query1.SQL.text :=
        'select count(*) as cont from item_venda where nota = :nota';
      query1.ParamByName('nota').AsString := nota;
      query1.Open;

      if query1.fieldbyname('cont').AsInteger <= 0 then
      begin
        ShowMessage('Não Pode Ser Emitido Uma NFCe desta Venda!' + #13 +
          'Quantidade de Itens: ' + query1.fieldbyname('cont').AsString);
        query1.Close;
        exit;
      end;
    end;

    if RightStr(trim(pastaControlW), 1) <> '\' then
      pastaControlW := pastaControlW + '\';
    carregaConfigsNFCe;

    NomeGeneratorSerie := 'nfce';

    // LerConfiguracaoNFCe();

    DANFE.vTroco := recebido;
    if DANFE.vTroco < 0 then
      DANFE.vTroco := 0;

    { danfe.vTroco := recebido - totNota;
      if danfe.vTroco < 0 then danfe.vTroco := 0;

      if tipoIMPRESSAO = 1 then begin
      DANFEEscPos.vTroco := recebido - totNota;
      if DANFEEscPos.vTroco < 0 then DANFEEscPos.vTroco := 0;
      end; }

    obs2 := obs1;
    Status := '';
    Result := false;
    ssChave := '';
    vlRecebido := recebido;
    inicializaVariaveis();
    TipoEmissao := tipo;
    enviou := true;
    DANFE.NFeCancelada := false;

    ACBrNFe.NotasFiscais.Clear;
    ACBrNFe.WebServices.Consulta.Clear;
    ACBrNFe.WebServices.Retorno.Clear;
    CDCFOP := '5102';


    cliente := cliente1;
    try

      if enviar then
      begin
        contOFFLINE := false;
        ACBrNFe.Configuracoes.Geral.FormaEmissao := teNormal;
      end
      else
      begin
        contOFFLINE := true;
        ACBrNFe.Configuracoes.Geral.FormaEmissao := teOffLine;
        // contigência OFFLINE
      end;

    except
      on e: Exception do
      begin
        gravaERRO_LOG1('', e.Message,
          'ACBrNFe.Configuracoes.Geral.FormaEmissao := teNormal; LINHA 2590');
      end;
    end;

    serie1 := IntToStr(serie2);
    /// //GERAR NFC-e:

    if true then begin
      xml := GerarNFCeTexto(nota, cliente1);
      GravarTexto(buscaPastaNFCe(CHAVENF, false) + CHAVENF + '-nfe.xml', xml);
      xml := '';
    end;

    query1.Close;
    ACBrNFe.NotasFiscais.Clear;
    ACBrNFe.NotasFiscais.LoadFromFile(buscaPastaNFCe(CHAVENF, false) + CHAVENF +
      '-nfe.xml', false);

  except
    on e: Exception do
    begin
      gravaERRO_LOG1('', e.Message,
        'ACBrNFe.NotasFiscais.LoadFromFile(pastaControlW + \NFCe\EMIT\ + chaveNF + -nfe.xml, false); LINHA 2625');
    end;
  end;

  if enviar then
  begin
    try
      ACBrNFe.NotasFiscais.Assinar;

      ACBrNFe.NotasFiscais[0].GravarXML(CHAVENF + '-nfe.xml',
      buscaPastaNFCe(CHAVENF, false));

      ACBrNFe.NotasFiscais.Validar;
    except
      on e: Exception do
      begin
        erro1 := e.Message;
        gravaERRO_LOG1('', e.Message, 'Validação dos Dados');
        MessageDlg('Falha na Validação da Nota: ' + #13 + e.Message + #13,
          mtError, [mbOK], 1);

        Status := 'vali';
        Result := false;
        exit;
      end;
    end;

    ssChave := CHAVENF;
    venda.adic := 'OFF';

    ACBrNFe.NotasFiscais[0].GravarXML(CHAVENF + '-nfe.xml',
      buscaPastaNFCe(CHAVENF, false));

    if (ACBrNFe.Configuracoes.WebServices.Ambiente = taHomologacao) then
    begin
      try
        ACBrNFe.NotasFiscais[0].nfe.Det[0].Prod.xProd :=
          'NOTA FISCAL EMITIDA EM AMBIENTE DE HOMOLOGACAO - SEM VALOR FISCAL';
      except
      end;
    end;

    i := 0;
    csta := 999;
    while true do
    begin
      if i = 1 then
        break;
      i := i + 1;
      try
        ERRO_dados := '';
        gravaERRO_LOG1('', 'Enviando NFCe: ' + CHAVENF, 'erro1');
        if acbrNFeEnviar(20) then
        begin

          csta := ACBrNFe.WebServices.enviar.cStat;
          if csta = 0 then
            csta := ACBrNFe.WebServices.enviar.cStat;


          ACBrNFe.WebServices.Retorno.Recibo :=
            ACBrNFe.WebServices.enviar.Recibo;
          ACBrNFe.WebServices.Retorno.Executar;

          csta := ACBrNFe.WebServices.Retorno.cStat;

          if (csta in [100, 150, 103]) then
          begin
            ERRO_dados := '';
            gravaERRO_LOG1('', 'Retorno  NFCe: ' + CHAVENF + '  ERRO_dados: ' +
              ERRO_dados, 'erro1');
            enviou := true;
            Result := true;
            break;
          end;
        end;

        gravaERRO_LOG1('', 'Retorno  NFCe: ' + CHAVENF + ERRO_dados, 'erro1');
        if ERRO_dados <> '' then
        begin
          Status := ERRO_dados;
          raise Exception.Create(ERRO_dados);
        end;
      except
        On e: Exception do
        begin
          erroTemp := e.Message;
          gravaERRO_LOG1('', e.Message, 'Enviar');
          csta := ACBrNFe.WebServices.Retorno.cStat;

          try
            sendPostDataMensagem(form72.IdHTTP1, trim(e.Message + ' | ' + ACBrNFe.WebServices.Retorno.xMotivo), 'EnviarCupomEletronico2 3728', IntToStr(csta), NomedoComputador);
          finally

          end;

          if Contido('Rejeicao: ', e.Message) then
          begin
            if Contido('Duplicidade', e.Message) = false then
            begin
              gravaERRO_LOG1('', e.Message,
                'if Contido(Duplicidade, e.Message) = false then');
              Status := e.Message;
              MessageDlg('E3286: ' +e.Message, mtError, [mbOK], 1);
              Result := false;
              csta := 999;
              // exit;
            end;
          end;

          Status := e.Message;

          if (csta in [100, 150]) = false then
            csta := 999;

          if (Contido('Duplicidade de NF-e [chNFe:', e.Message)) THEN
          begin
            try
              trataDuplicidade1(e.Message, false, false, true);
              // inicializaVariaveis;
              ACBrNFe.NotasFiscais.Clear;
            except
              on e: Exception do
              begin
                gravaERRO_LOG1('', e.Message,
                  'else if Contido(Duplicidade de NF-e, com diferenca na Chave de Acesso [chNFe:, e.Message) THEN');
              end;
            end;
          end
          else if (Contido
            ('Duplicidade de NF-e, com diferenca na Chave de Acesso [chNFe:',
            e.Message) or (csta = 539)) THEN
          begin
            try
              trataDuplicidade1(e.Message, false, false, true);
              //MessageDlg(e.Message, mtError, [mbOK], 1);
              // inicializaVariaveis;
              ACBrNFe.NotasFiscais.Clear;
              { inicializaVariaveis;
                xml := GerarNFCeTexto(nota, cliente1);
                GravarTexto(buscaPastaNFCe(chaveNF, false) + chaveNF + '-nfe.xml', xml);
                ACBrNFe.NotasFiscais.Clear;
                ACBrNFe.NotasFiscais.LoadFromFile(buscaPastaNFCe(chaveNF, false) +chaveNF + '-nfe.xml'); }
            except
              on e: Exception do
              begin
                gravaERRO_LOG1('', e.Message,
                  'else if Contido(Duplicidade de NF-e, com diferenca na Chave de Acesso [chNFe:, e.Message) THEN');
                csta := 999;
              end;
            end;
          end;

          if ACBrNFe.WebServices.Retorno.RetornoWS = '' then
          begin
            csta := 999;
            Result := false;
          end;
        end;
      end; // try enviar
    end; // while true

    if csta = 999 then
    begin
      LimpaVariaveis;
      EnviarCupomEletronicoTitular(nota, Status, xmotivo, tipo, false, cliente1,
        obs1, '', '', imp, recebido, EscPos);
      Result := true;
      exit;
    end;

    ssChave := CHAVENF;
    ACBrNFe.NotasFiscais[0].GravarXML(CHAVENF + '-nfe.xml',
      buscaPastaNFCe(CHAVENF, false));

    // if (cSta in [100, 150, 103, 301]) then

    if Contido('-' + IntToStr(csta) + '-', '-100-150-103-301-') then
    begin
      if imp then
      begin
        TRY
          SendPostData(Form72.IdHTTP1, buscaPastaNFCe(CHAVENF) + CHAVENF + '-nfe.xml', 'E', IntToStr(csta));
        FINALLY
        END;

        try

          // if EscPos then
          if tipoIMPRESSAO = 1 then
          begin
            DANFEEscPos.vTroco := recebido;
            imprimirNfceESCPOS;
          end
          else
            imprimirNfce();
        except
          on e: Exception do
          begin
            ShowMessage(e.Message);
          end;
        end;
      end;

      try
        ACBrNFe.NotasFiscais[0].GravarXML(CHAVENF + '-nfe.xml',
          buscaPastaNFCe(CHAVENF, false));
      except
        on e: Exception do
        begin
          gravaERRO_LOG1('', e.Message, 'insereNotaBD(venda); Linha 2842');
        end;
      end;

      try
        Result := true;
        Status := 'OK';
        venda.adic := '';

        venda.chave := CHAVENF;
        erro1 := LeftStr(erro1, 200);
        if csta <> 100 then
          venda.adic := 'OFF';
        if csta = 301 then
          venda.adic := 'DENEGADA';
        insereNotaBD(venda);
      except
        on e: Exception do
        begin
          gravaERRO_LOG1('', e.Message, 'insereNotaBD(venda); Linha 2857');
        end;
      end;

      Incrementa_Generator(NomeGeneratorSerie, 1);
      LimpaVariaveis;
      ACBrNFe.NotasFiscais.Clear;
      exit;
    end
    else
    begin
      Status := 'vali';
      xmotivo := ACBrNFe.WebServices.enviar.xmotivo;
      ShowMessage('NF-e ' + ' Houve uma falha na Validação!' + #13 + #10 + #13 +
        #10 + 'xMotivo: ' + ACBrNFe.WebServices.enviar.xmotivo + #13 +
        'cStat..: ' + IntToStr(csta) + #13 + 'Erro...: ' + erroTemp);
      // +qry.FieldByName('RECIBO_DESCSTATUS').AsString);
      Result := false;
      LimpaVariaveis;
      exit;
    end;
  end
  else // aqui é em contigencia OFFLINE
  begin

    try
      ACBrNFe.NotasFiscais.Assinar;
      ACBrNFe.NotasFiscais.Validar;
    except
      on e: Exception do
      begin
        gravaERRO_LOG1('', e.Message, 'validar');
        Status := 'vali';
        MessageDlg('Falha na Validação da Nota11: ' + #13 + e.Message + #13,
          mtError, [mbOK], 1);
        Result := false;
        exit;
      end;
    end;


      venda.adic := 'OFF';
      venda.chave := CHAVENF;
      insereNotaBD(venda);
      try
      ACBrNFe.NotasFiscais[0].GravarXML(CHAVENF + '-nfe.xml',buscaPastaNFCe(CHAVENF, false));
    except
      on e: Exception do
      begin
        gravaERRO_LOG1('', e.Message, 'insereNotaBD(venda); linha 2899');
        MessageDlg('Erro em insereNotaBD(venda)3013: ' + #13 + e.Message + #13+ #13+ #13 +
        'CHAVENF=' + CHAVENF + #13 + 'ADIC=' + venda.adic + #13 + 'crc=' + buscaCRCdaChave(strnum(venda.chave)) + #13 +
        'nota=' + IntToStr(venda.nota),
          mtError, [mbOK], 1);
      end;
    end;

    Incrementa_Generator(NomeGeneratorSerie, 1);

    if imp then
    begin
      if tipoIMPRESSAO = 1 then
      begin
        DANFEEscPos.vTroco := recebido;
        imprimirNfceESCPOS;
      end
      else
        imprimirNfce();

    end;

    LimpaVariaveis;
    Result := true;
  end;

  para := 'wagner.br.xx@gmail.com';
  ACBrNFe.NotasFiscais.Clear;

  Result := true;
end;

function EnviarCupomEletronico2(nota, chave1: String; var richED: TRichEdit;
  var estado: String; const imprime, dav: boolean;
  const lerconfig: boolean = true): boolean;
var
  para, ssChave, ssChaveVelha, NumeroRecibo, erro2: string;
  csta: integer;
  Mensagememail: TStrings;
  xml: AnsiString;
  chaveDetalhe: TChaveDetalhes;
  novo: boolean;
  arq, arq1: TStringList;
begin
  try
    verificarValidadeCertificado(true);
  except
    on e: Exception do
    begin
      if Contido('(1)', e.Message) then
      begin
        richED.Lines.Add(e.Message);
        exit;
      end;
    end;
  end;

  if lerconfig then
    LerConfiguracaoNFCe();
  if RightStr(trim(pastaControlW), 1) <> '\' then
    pastaControlW := pastaControlW + '\';

  carregaConfigsNFCe;

  Result := false;
  ssChave := '';
  inicializaVariaveis();
  novo := false;
  csta := 0;

  richedt := richED;

  ACBrNFe.NotasFiscais.Clear;
  ACBrNFe.WebServices.Consulta.Clear;
  ACBrNFe.WebServices.Retorno.Clear;

  //ACBrNFe.Configuracoes.Geral.IncluirQRCodeXMLNFCe := true;

  query1.Close;
  query1.SQL.text :=
    'select chave from nfce where chave = :nota and chave <> ''''';
  query1.ParamByName('nota').AsString := chave1;
  query1.Open;

  if query1.IsEmpty then
  begin
    query1.Close;
    if not dav then
      ShowMessage('NFCe não encontrada');
    exit;
  end;

  ssChave := query1.fieldbyname('chave').AsString;
  CHAVENF := ssChave;
  ssChaveVelha := CHAVENF;

  if FileExists(buscaPastaNFCe(CHAVENF) + CHAVENF + '-nfe.xml') = false then
  begin
    Result := false;
    richED.Lines.Add('NFCe Não Encontrada: ' + buscaPastaNFCe(CHAVENF) + CHAVENF
      + '-nfe.xml');
    exit;
  end else begin
    arq := TStringList.Create;
    arq.LoadFromFile(buscaPastaNFCe(CHAVENF) + CHAVENF +
        '-nfe.xml');
    if Contido('"3.10"', arq.Text) then begin
      arq.Text := StringReplace(arq.Text, '"3.10"', '"4.00"', [rfReplaceAll]);
      erro2 := Le_Nodo('pag', arq.Text);
      erro2 := '<pag><detPag>'+ erro2 + '</detPag></pag>';

      arq.Text := substitui_Nodo('pag', erro2, arq.Text);
      arq.SaveToFile(buscaPastaNFCe(CHAVENF) + CHAVENF +
        '-nfe.xml');
    end;

    if Contido('<detPag>', arq.Text) = false then begin
      erro2 := Le_Nodo('pag', arq.Text);
      erro2 := '<pag><detPag>'+ erro2 + '</detPag></pag>';

      arq.Text := substitui_Nodo('pag', erro2, arq.Text);
      arq.SaveToFile(buscaPastaNFCe(CHAVENF) + CHAVENF +
        '-nfe.xml');
    end;

    arq.free;
  end;

  // estado  := 'XML nao encontrado: ' + pastaControlW + 'NFCE\EMIT\' + chaveNF + '-nfe.xml';
  estado := 'Sem Resposta!';

  contOFFLINE := false;
  lerVenda(nota);

  try
    // Mensagememail := TStringList.Create;
    ACBrNFe.NotasFiscais.Clear;
    /// //GERAR NFC-e:

    chaveDetalhe := TChaveDetalhes.Create;
    chaveDetalhe.chave := CHAVENF;
    Ler_dados_pela_chave(chaveDetalhe);

    if FileExists(buscaPastaNFCe(chaveDetalhe.chave) + chaveDetalhe.chave +
      '-nfe.xml') then
    begin
      arq := TStringList.Create;
      arq.LoadFromFile(buscaPastaNFCe(chaveDetalhe.chave) + chaveDetalhe.chave +
        '-nfe.xml');
      csta := StrToIntDef(Le_Nodo('cStat', arq.text), 0);
      arq.Free;

      if csta in [100, 150] then
      begin
        query1.Close;
        query1.SQL.text := 'update nfce set adic = '''' where chave = :chave';
        query1.ParamByName('chave').AsString := chaveDetalhe.chave;

        try
          query1.ExecSQL;
          query1.Transaction.Commit;
          Result := true;
          estado := 'OK';
          richED.Lines.Add('Nota Verificada ' + chaveDetalhe.chave +
            ': cStat 100');
          exit;
        except
        end;
      end;
    end;

    if (FormatDateTime('yymm', now) <> chaveDetalhe.anoMesYYMM) and (csta <> 100)
    then
    begin
      csta := 0;

      // if csta = 0 then
      // begin
      if chaveDetalhe.tpEmis = 9 then
      begin
        contOFFLINE := true;
      end;

      inicializaVariaveis;
      xml := GerarNFCeTexto(IntToStr(chaveDetalhe.codNF), '0',
        IntToStr(chaveDetalhe.nnf));
      GravarTexto(buscaPastaNFCe(CHAVENF) + CHAVENF + '-nfe.xml', xml);
      xml := '';

      gravaERRO_LOG1('', 'Troca de Chave Por Erro de Envio: ' + #13#10 +
        'Chave Antiga: ' + ssChave + #13#10 + 'Chave   Nova: ' + CHAVENF +
        #13#10 + 'Data  Troca : ' + FormatDateTime('dd/mm/yyyy', now) + ' ' +
        FormatDateTime('hh:mm:ss', now), 'Nova Criação de XML');

      ssChave := CHAVENF;

      ACBrNFe.NotasFiscais.Clear;
      ACBrNFe.NotasFiscais.LoadFromFile(buscaPastaNFCe(CHAVENF) + CHAVENF +
        '-nfe.xml');

      gravaERRO_LOG1('', 'Acabou: ' + FormatDateTime('hh:mm:ss', now),
        'Nova Criação de XML');
      // novo := true;
      // end;
    end
    else
    begin
      ACBrNFe.NotasFiscais.Clear;
      ACBrNFe.NotasFiscais.LoadFromFile(buscaPastaNFCe(CHAVENF) + CHAVENF +
        '-nfe.xml');
    end;

    // if csta <> 100 then
    // begin

    ACBrNFe.NotasFiscais[0].nfe.Ide.dEmi := now;
    ACBrNFe.NotasFiscais[0].nfe.Ide.dSaiEnt := now;
    if ACBrNFe.NotasFiscais[0].nfe.Ide.tpEmis = teOffLine then
    begin
      ACBrNFe.NotasFiscais[0].nfe.Ide.dhCont := now;
      ACBrNFe.NotasFiscais[0].nfe.Ide.xJust :=
        'NOTA FISCAL EMITIDA EM CONTINGENCIA';
    end;

    ACBrNFe.NotasFiscais[0].nfe.Ide.hSaiEnt := now;

    ACBrNFe.NotasFiscais.Assinar;

    try
      ACBrNFe.NotasFiscais.Validar;
    except
      on e:exception do begin
        Exception.Create(e.Message);
      end;
    end;
    
    try
      try
        ERRO_dados := '';
        richED.Lines.Add('Enviando...');
        ACBrNFe.WebServices.Retorno.Clear;

        if acbrNFeEnviar(35) then
        begin
          csta := ACBrNFe.WebServices.enviar.cStat;
          if csta = 0 then
            csta := ACBrNFe.WebServices.enviar.cStat;

          richED.Lines.Add('Recibo: ' + ACBrNFe.WebServices.enviar.Recibo);
          richED.Lines.Add('Consultando Recibo... ');
          ACBrNFe.WebServices.Retorno.Recibo :=
            ACBrNFe.WebServices.enviar.Recibo;
          ACBrNFe.WebServices.Retorno.Executar;

          csta := ACBrNFe.WebServices.Retorno.cStat;

          richED.Lines.Add('Enviado Cstat: ' + IntToStr(csta));
          if Contido('-' + IntToStr(csta) + '-', '-100-150-') then
            ERRO_dados := '';

          sleep(10);
          estado := 'OK';

          richED.Lines.Add('xMotivo=' + ACBrNFe.WebServices.enviar.xmotivo);
        end;

        if ERRO_dados <> '' then
        begin
          estado := ERRO_dados;
          ACBrNFe.WebServices.Retorno.Executar;
          csta := ACBrNFe.WebServices.Retorno.cStat;
          if csta <> 100 then raise Exception.Create(estado);
        end;

      except
        On e: Exception do
        begin
          ACBrNFe.WebServices.Retorno.Executar;
          csta := ACBrNFe.WebServices.Retorno.cStat;

          richED.Lines.Add('*** erro: ' + e.Message + #13 + 'cstat: ' +
            IntToStr(csta) + ' ***' + #13 + ACBrNFe.WebServices.Retorno.xMotivo + #13 +
            ACBrNFe.WebServices.enviar.xmotivo);
          Result := false;

          try
            sendPostDataMensagem(form72.IdHTTP1, trim(e.Message + ' | ' + ACBrNFe.WebServices.Retorno.xMotivo), 'EnviarCupomEletronico2 3728', IntToStr(csta), NomedoComputador);
          finally
          end;

          if Contido('(5)-Requisição não', ERRO_dados) and (csta <> 100)  then exit;


          if ((csta = 778) or (false)) then
          begin
            validaNCM_NaNFCe('');
            exit;
          end;

          if ((csta = 882) or (csta = 884)) then
          begin
            validaCodbarCSTAT882('');
            exit;
          end;

          if Contido('12002', estado) then
          begin
            erro12002 := erro12002 + 1;

            { if erro12002 > 3 then begin
              arq1 := TStringList.Create;
              arq1.SaveToFile(ExtractFileDir(ParamStr(0)) + '\davXXX.rca');
              arq1.Free;
              ERRO_dados := 'Application.Terminate;';
              Application.Terminate;
              estado := estado + #13 + #13 + 'O davNFCe Será Reiniciado!';
              end; }
            exit;
          end;

          if Contido('-' + IntToStr(csta) + '-', '-205-301-') then
          begin
            query1.Close;
            query1.SQL.text :=
              'update nfce set adic = ''DENEGADA'', exportado = 1 where chave = :chave';
            query1.ParamByName('chave').AsString := ssChaveVelha;
            try
              query1.ExecSQL;
              query1.Transaction.Commit;
              estado := 'Marcada Como DENEGADA! CHAVE: ' + ssChaveVelha;
            except
              On e: Exception do
              begin
                estado := e.Message + #13 +
                  'update nfce set adic = INUTILIZADA where chave = :chave';
                gravaERRO_LOG1('', 'Marcada Como Inutilizada! CHAVE: ' +
                  ssChaveVelha + ' ' + FormatDateTime('dd/mm/yyyy', now) +
                  FormatDateTime('hh:mm:ss', now), 'Cstat 206');
                exit;
              end;
            end;
            exit;
          end;

          if csta = 206 then
          begin
            query1.Close;
            query1.SQL.text :=
              'update nfce set adic = ''INUTILIZADA'', exportado = 1 where chave = :chave';
            query1.ParamByName('chave').AsString := ssChaveVelha;
            try
              query1.ExecSQL;
              query1.Transaction.Commit;
              estado := 'Marcada Como Inutilizada! CHAVE: ' + ssChaveVelha;
            except
              On e: Exception do
              begin
                estado := e.Message + #13 +
                  'update nfce set adic = INUTILIZADA where chave = :chave';
                gravaERRO_LOG1('', 'Marcada Como Inutilizada! CHAVE: ' +
                  ssChaveVelha + ' ' + FormatDateTime('dd/mm/yyyy', now) +
                  FormatDateTime('hh:mm:ss', now), 'Cstat 206');
                exit;
              end;
            end;
            exit;
          end;

          if Contido('NF-e ja esta cancelada', e.Message) THEN
          begin
            query1.Close;
            query1.SQL.text :=
              'update nfce set adic = ''CANC'' where chave = :chave';
            query1.ParamByName('chave').AsString := CHAVENF;
            try
              query1.ExecSQL;
              query1.Transaction.Commit;
            except
              On e: Exception do
              begin
                estado := e.Message + #13 +
                  'update nfce set adic = ''CANC'' where chave = :chave   Linha 3535';
                gravaERRO_LOG1('', 'Marcada Como Cancelada! CHAVE: ' +
                  ssChaveVelha + ' ' + FormatDateTime('dd/mm/yyyy', now) +
                  FormatDateTime('hh:mm:ss', now), 'NF-e ja esta cancelada');
                exit;
              end;
            end;
            estado := e.Message + #13 + 'NFCe ' + CHAVENF +
              ' já está marcada no BD como Cancelada!';
            exit;
          end;

          if not dav then
            MessageDlg('Ocorreu um Erro: ' + #13 + e.Message + #13, mtError,
              [mbOK], 1);
          estado := '|cc| ' + e.Message;

          // gravaERRO_LOG1('', '--RETORNO3--' , '');

          //
          if csta <> 100 then
          begin
            estado := estado + #13 + ACBrNFe.WebServices.enviar.xmotivo +
              '| cStat: ' + IntToStr(ACBrNFe.WebServices.enviar.cStat);
            gravaERRO_LOG1('', 'erro Linha 3276 ' + estado +
              FormatDateTime('dd/mm/yyyy', now) + FormatDateTime('hh:mm:ss',
              now), 'trataDuplicidade1');
          end;

          if (Contido('Duplicidade de NF-e', e.Message)) or (csta = 539) or
            (csta = 204) THEN
          begin
            try
              richED.Lines.Add('(Tratando a Duplicidade) linha 3443');
              estado := '|ii| ' + e.Message + #13 +
                ACBrNFe.WebServices.enviar.xmotivo + '| cStat: ' +
                IntToStr(ACBrNFe.WebServices.enviar.cStat);

              gravaERRO_LOG1('', estado + ssChaveVelha + ' ' +
                FormatDateTime('dd/mm/yyyy', now) + FormatDateTime('hh:mm:ss',
                now), 'trataDuplicidade1');

              erro2 := ACBrNFe.WebServices.enviar.xmotivo;
              if not Contido('Duplicidade de', erro2) then erro2 := e.Message;



              trataDuplicidade1(erro2, false, false, false, CHAVENF);
              gravaERRO_LOG1('', 'Fim trataDuplicidade1' +
                FormatDateTime('dd/mm/yyyy', now) + FormatDateTime('hh:mm:ss',
                now), 'trataDuplicidade1');
              exit;
            except
            end;
          end

          { if Contido('Duplicidade de NF-e [chNFe:', e.Message) THEN
            begin
            try
            estado := '|ii| '+e.Message + #13 + ACBrNFe.WebServices.Retorno.xMotivo + '| cStat: ' + IntToStr(ACBrNFe.WebServices.Retorno.cStat);

            trataDuplicidade1(e.Message, false, false, false);
            exit;
            except
            end;
            end
            else if Contido('Duplicidade de NF-e, com diferenca na Chave de Acesso [chNFe:', e.Message) THEN
            begin
            estado := '|ee| '+e.Message + #13 + ACBrNFe.WebServices.Retorno.xMotivo + '| cStat: ' + IntToStr(ACBrNFe.WebServices.Retorno.cStat);
            trataDuplicidade1(e.Message, false, false, false, chaveNF);
            exit;
            end; }
        end;
        // end;

      end;

      // gravaERRO_LOG1('', '--RETORNO4--' , '');
      // if ACBrNFe.WebServices.Retorno.cStat <= 200 then
      // if csta in [100, 150, 103, 301] then
      if Contido('-' + IntToStr(csta) + '-', '-100-150-103-301-') then
      begin
        try
          // gravaERRO_LOG1('', '--RETORNO5-- csta in [100, 150]' , '');
          ACBrNFe.NotasFiscais[0].GravarXML(CHAVENF + '-nfe.xml',
            buscaPastaNFCe(CHAVENF));
          ssChave := CHAVENF;
          venda.adic := '';
          Result := true;

          venda.chave := CHAVENF;

          TRY
            SendPostData(Form72.IdHTTP1, buscaPastaNFCe(CHAVENF) + CHAVENF + '-nfe.xml', 'E', IntToStr(csta));
          FINALLY
          END;

          if csta = 301 then
          BEGIN
            richED.Lines.Add('Estado: DENEGADA');
            richED.Lines.Add('cStat.: ' + IntToStr(csta));
            venda.adic := 'DENEGADA';
          END;

          if novo then
            insereNotaBD1(venda)
          else
            insereNotaBD(venda);
          Result := true;
        except
          on e: Exception do
          begin
            estado := 'TT' + e.Message;
            // LimpaVariaveis();
            exit;
          end;
        end;
      end;

      if csta > 200 Then
      begin
        if dav = false then
        begin
          ShowMessage('NF-e ' + ' Houve uma falha na Validação!' + #13 + #10 +
            #13 + #10 + 'Favor Corrigir: ' +
            ACBrNFe.WebServices.enviar.xmotivo);
          // +qry.FieldByName('RECIBO_DESCSTATUS').AsString);
        end;
        Result := false;
        exit;
      end;

      try
        if imprime then
          imprimirNfce();
      except
        On e: Exception do
        begin
          richED.Lines.Add('BB: ' + e.Message);
          // MessageDlg('Verifique se o Acrobat está instalado corretamente.', mtInformation, [mbok],0 );
        end;
      end;

      ACBrNFe.NotasFiscais.Clear;
    except
      on e: Exception do
      begin
        estado := 'VV' + e.Message;
        // LimpaVariaveis();
      end;
    end;
  finally
    //gravaERRO_LOG1('', '--RETORNO6--', '');
    ACBrNFe.NotasFiscais.Clear;
    chaveDetalhe.Free;
    venda.Free;
  end;
end;

procedure ConsultarNFe(numeroNota: String; visuali: boolean = true);
begin
  //

  if Contido('\', numeroNota) = false then
  begin
    carregaConfigsNFCe;
    query1.Close;
    query1.SQL.text :=
      'select chave from nfce where cast(substring(chave from 26 for 9) as integer) = :nota';
    query1.ParamByName('nota').AsString := numeroNota;
    query1.Open;

    if query1.IsEmpty then
    begin
      query1.Close;
      ShowMessage('NFCe não encontrada');
      exit;
    end;

    ACBrNFe.Configuracoes.WebServices.Visualizar := visuali;
    ACBrNFe.NotasFiscais.Clear;
    numeroNota := buscaPastaNFCe(query1.fieldbyname('chave').AsString) +
      query1.fieldbyname('chave').AsString + '-nfe.xml';
    ACBrNFe.NotasFiscais.LoadFromFile(numeroNota);
  end
  else
  begin
    ACBrNFe.Configuracoes.WebServices.Visualizar := visuali;
    ACBrNFe.NotasFiscais.Clear;
    ACBrNFe.NotasFiscais.LoadFromFile(numeroNota);
  end;

  ACBrNFe.Configuracoes.WebServices.Visualizar := true;
  try
    ACBrNFe.Consultar();
  finally
    ACBrNFe.Configuracoes.WebServices.Visualizar := false;
  end;
  { if acbrNFeConsultar(25) = false then begin
    ShowMessage(ERRO_dados);
    exit;
    end; }
  ACBrNFe.Configuracoes.WebServices.Visualizar := visuali;
  ACBrNFe.NotasFiscais[0].GravarXML(ExtractFileName(numeroNota),
    ExtractFileDir(numeroNota));
end;

procedure Imprimir_DANFE_PDF(numeroNota: String; nnf: String = '';
  fortes: boolean = true; serie99: string = '1');
var
  ArqPDF, nomeArquivo, canc: string;
begin
  if nnf <> '' then
  begin
    query1.Close;
    query1.SQL.text :=
      'select chave, nota from nfce where substring(chave from 26 for 9) = :nota and substring(chave from 23 for 3) = :ser';
    query1.ParamByName('nota').AsString := strzero(nnf, 9);
    query1.ParamByName('ser').AsString := strzero(serie99, 3);
    query1.Open;

    if query1.IsEmpty then
    begin
      query1.Close;
      ShowMessage('NFCe não encontrada1');
      exit;
    end;

    numeroNota := query1.fieldbyname('chave').AsString;
  end;

  query1.Close;
  query1.SQL.text := 'select chave, adic, recebido from nfce where chave = :nota';
  query1.ParamByName('nota').AsString := numeroNota;
  query1.Open;

  if query1.IsEmpty then
  begin
    query1.Close;
    ShowMessage('NFCe não encontrada2');
    exit;
  end;

  canc := query1.fieldbyname('adic').AsString;

  if canc = 'CANC' then
    DANFE.NFeCancelada := true;


  danfe.vTroco := query1.FieldByName('recebido').AsCurrency;
  ACBrNFe.NotasFiscais.Clear;
  nomeArquivo := buscaPastaNFCe(query1.fieldbyname('chave').AsString) +
    query1.fieldbyname('chave').AsString + '-nfe.xml';
  ACBrNFe.NotasFiscais.LoadFromFile(nomeArquivo);

  if fortes then
    imprimirNfce()
  else
    imprimirNfceESCPOS;

  DANFE.NFeCancelada := false;
end;

function Cancelamento_NFe(numeroNota: String; MemoResp: TMemo;
  WBResposta: TWebBrowser): boolean;
var
  chave, idLote, CNPJ, Protocolo, Justificativa, tmp: string;
begin
  Result := false;
  query1.Close;
  query1.SQL.text := 'select chave from nfce where nota = :nota';
  query1.ParamByName('nota').AsString := numeroNota;
  query1.Open;

  if query1.IsEmpty then
  begin
    query1.Close;
    ShowMessage('NFCe não encontrada');
    exit;
  end;

  chave := query1.fieldbyname('chave').AsString;

  if MessageDlg('Tem Certeza que Deseja Cancelar a Nota Fiscal: ' + numeroNota +
    ' ?', mtConfirmation, [mbYes, mbNo], 0) = mrno then
    exit;

  application.ProcessMessages;
  application.ProcessMessages;

  ACBrNFe.NotasFiscais.Clear;
  ACBrNFe.NotasFiscais.LoadFromFile(buscaPastaNFCe(chave) + chave + '-nfe.xml');

  idLote := '1';
  Justificativa := '';

  while length(trim(Justificativa)) < 15 do
  begin
    Justificativa := dialogo('normal', 0, '', 150, true, '', application.Title,
      'Qual a Justificativa?', Justificativa);
    if Justificativa = '*' then
      break;

    if length(trim(Justificativa)) < 15 then
      ShowMessage('Justificativa Deve conter mais do que  14 caracteres');
  end;

  if Justificativa = '*' then
    exit;

  ACBrNFe.EventoNFe.Evento.Clear;
  ACBrNFe.EventoNFe.idLote := StrToInt(idLote);
  with ACBrNFe.EventoNFe.Evento.Add do
  begin
    InfEvento.chNFe := chave;
    InfEvento.dhEvento := now;
    InfEvento.tpEvento := teCancelamento;
    InfEvento.detEvento.xJust := Justificativa;
    InfEvento.tpAmb := ACBrNFe.Configuracoes.WebServices.Ambiente;
  end;

  ACBrNFe.EnviarEvento(StrToInt(idLote));
  tmp := ACBrNFe.WebServices.EnvEvento.EventoRetorno.retEvento.Items[0]
    .RetInfEvento.xmotivo;

  if ACBrNFe.WebServices.EnvEvento.EventoRetorno.retEvento.Items[0]
    .RetInfEvento.cStat < 200 then
  begin
    CopyFile(pchar(buscaPastaNFCe(chave) + chave + '-nfe.xml'),
      pchar(pastaControlW + 'NFCe\CANC\' + chave + '-nfe.xml'), true);
    // DANFE.NFeCancelada := true;

    ACBrNFe.DANFE := DANFE;
    ACBrNFe.ImprimirEvento;
    // imprimirNfce;
    // RenameFile(pastaControlW + 'NFCe\EMIT\' + chave + '-nfe.xml', pastaControlW + 'NFCe\EMIT\' + chave + '-nfe.old')
    ShowMessage('NF-e Cancelada com Sucesso. Protocolo ' +
      ACBrNFe.WebServices.Retorno.Protocolo + #13 + 'cStat: ' +
      IntToStr(ACBrNFe.WebServices.EnvEvento.EventoRetorno.retEvento.Items[0]
      .RetInfEvento.cStat));
    Result := true;
  end
  else
  begin
    ShowMessage('Ocorreu um Erro no Cancelamento:' + #13 + tmp +
      IfThen(POS('Duplicidade', tmp) > 0,
      #13 + #13 + 'Esta Nota já pode ter Sido Cancelada', ''));
  end;
end;

function Cancelamento_NFe1(numeroNota, Justificativa: String;
  cancelamento: integer = 0; chaveENT: String = ''): boolean;
var
  chave, idLote, CNPJ, Protocolo, tmp, tmp1: string;
  cStat: integer;
  arq1: TStringList;
begin
  carregaConfigsNFCe;
  Result := false;
  query1.Close;
  query1.SQL.text := 'select chave from nfce where nota = :nota';
  query1.ParamByName('nota').AsString := numeroNota;
  query1.Open;

  chave := chaveENT;

  if chave = '' then
  begin
    query1.Close;
    query1.SQL.text := 'select chave from nfce where nota = :nota';
    query1.ParamByName('nota').AsInteger := StrToIntDef(numeroNota, 0);
    query1.Open;

    if query1.IsEmpty then
    begin
      query1.Close;
      ShowMessage('NFCe não encontrada');
      exit;
    end;
    chave := query1.fieldbyname('chave').AsString;
  end;

  if MessageDlg('Tem Certeza que Deseja Cancelar a Nota Fiscal: ' + chave +
    ' ?', mtConfirmation, [mbYes, mbNo], 0) = mrno then
    exit;

  application.ProcessMessages;
  application.ProcessMessages;

  ACBrNFe.NotasFiscais.Clear;
  ACBrNFe.NotasFiscais.LoadFromFile(buscaPastaNFCe(chave) + chave + '-nfe.xml');

  idLote := '1';

  Justificativa := UpperCase(Justificativa);

  ACBrNFe.EventoNFe.Evento.Clear;
  ACBrNFe.EventoNFe.idLote := StrToInt(idLote);
  with ACBrNFe.EventoNFe.Evento.Add do
  begin
    InfEvento.chNFe := chave;
    InfEvento.dhEvento := now;
    InfEvento.tpEvento := teCancelamento;
    InfEvento.detEvento.xJust := Justificativa;
    InfEvento.tpAmb := ACBrNFe.Configuracoes.WebServices.Ambiente;
  end;

  ACBrNFe.EnviarEvento(StrToInt(idLote));

  tmp := ACBrNFe.WebServices.EnvEvento.EventoRetorno.retEvento.Items[0]
    .RetInfEvento.xmotivo;

  cStat := ACBrNFe.WebServices.EnvEvento.EventoRetorno.retEvento.Items[0]
    .RetInfEvento.cStat;
  if POS('-' + IntToStr(cStat) + '-', '-101-135-151-573-') > 0 then
  // if (cstat in [101, 135, 151, 573]) then
  begin
    query1.Close;
    query1.SQL.text :=
      'update nfce set adic = ''CANC'', exportado = 0 where chave = :chave';
    query1.ParamByName('chave').AsString := chave;
    query1.ExecSQL;

    if cancelamento > 0 then
    begin
      query1.Close;
      query1.SQL.text :=
        'update venda set cancelado = :canc where nota = :nota';
      query1.ParamByName('canc').AsInteger := cancelamento;
      query1.ParamByName('nota').AsString := strnum(numeroNota);
      query1.ExecSQL;
    end;

    query1.Transaction.Commit;


    GRAVA_NODO_PROT_NFCe(buscaPastaNFCe(chave) + chave + '-nfe.xml');

    try
      SendPostData(Form72.IdHTTP1, buscaPastaNFCe(chave) + chave + '-nfe.xml', 'C', IntToStr(cStat));
    finally

    end;

    CopyFile(pchar(buscaPastaNFCe(chave) + chave + '-nfe.xml'),
      pchar(pastaControlW + 'NFCe\CANC\' + chave + '-nfe.xml'), true);

    DANFE.NFeCancelada := true;

    setPrinter(indxImpressora, impreNFCE);

    if tipoIMPRESSAO = 1 then // DANFEEscPos
    begin
      try
        ACBrNFe.DANFE := DANFEEscPos;
        DANFEEscPos.ImprimirEvento(ACBrNFe.NotasFiscais[0].nfe);
      except
        on e: Exception do
        begin
          MessageDlg('Ocorreu um Erro Na Impressão: ' + e.Message, mtError,
            [mbOK], 1);
        end;
      end;
    end
    else
      DANFE.ImprimirDANFECancelado(ACBrNFe.NotasFiscais[0].nfe);

    // imprimirNfce;

    DANFE.NFeCancelada := false;

    { ACBrNFe.DANFE := DANFE;
      ACBrNFe.ImprimirEvento; }

    // DANFE.NFeCancelada := false;
    ShowMessage('NF-e Cancelada com Sucesso.' + #13 + 'Estado: ' +
      ACBrNFe.WebServices.EnvEvento.EventoRetorno.retEvento.Items[0]
      .RetInfEvento.xmotivo + #13 + 'Protocolo: ' +
      ACBrNFe.WebServices.EnvEvento.EventoRetorno.retEvento.Items[0]
      .RetInfEvento.nProt + #13 + 'cStat: ' +
      IntToStr(ACBrNFe.WebServices.EnvEvento.EventoRetorno.retEvento.Items[0]
      .RetInfEvento.cStat));
    Result := true;
  end
  else
  begin
    ShowMessage('Ocorreu um Erro no Cancelamento:' + #13 + tmp +
      IfThen(POS('Duplicidade', tmp) > 0,
      #13 + #13 + 'Esta Nota já pode ter Sido Cancelada', ''));
  end;

end;

function Cancelamento_NFePorNNF(numeroNota, Justificativa: String): boolean;
var
  chave, idLote, CNPJ, Protocolo, tmp, tmp1: string;
  arq1: TStringList;
begin
  Result := false;
  query1.Close;
  query1.SQL.text :=
    'select nota, chave from nfce where substring(chave from 26 for 9) = :nota';
  query1.ParamByName('nota').AsString := strzero(numeroNota, 9);
  query1.Open;

  if query1.IsEmpty then
  begin
    query1.Close;
    ShowMessage('NFCe de Número ' + numeroNota + ' Não Encontrado.');
    exit;
  end;

  Result := Cancelamento_NFe1(query1.fieldbyname('nota').AsString,
    Justificativa, 0, query1.fieldbyname('chave').AsString);
end;

// GerarNFCe(nota, cliente, obs1, serie1, NNF, '');
procedure GerarNFCe(nota, NumNFCe, TipoEmissao, TipoAmbiente, UFComerciante,
  FinalidadeNFE: String; recebido: currency = 0);
var
  qr, qrPg: tibquery;
  SQL: string;
  sCST, idCST: string;
  sCondPag: string;
  CodUF, CodMun: string;
  bolISSQN: string;
  qry: tibquery;
  ini, fim: integer;
  item: Item_venda;
  op: TOpenDialog;
  ok: boolean;
begin
  lerItensDaVenda(lista, nota);
  IF UFComerciante = '' THEN
  begin
    codNF := StrToIntDef(Incrementa_Generator('NFCE', 0), 0);
    // codNF := StrToIntDef(getNumeroValido(), 0);
    if codNF = 0 then
      codNF := 1;
  end
  else
  begin
    codNF := StrToIntDef(UFComerciante, 1);
  end;

  verCSTcFOP(CDCFOP);
  if TipoAmbiente = '' then
    TipoAmbiente := '1';
  ACBrNFe.NotasFiscais.Clear;

  try
    ACBrNFe.NotasFiscais.Clear;
    ACBrNFe.NotasFiscais.Add;

    with ACBrNFe.NotasFiscais.Items[0].nfe do
    begin
      LerDados_Emit_Dest(cliente);
      lerNodoIde(codNF, nota, TipoAmbiente);
      lerNodoEmitDest();

      with pag.Add do
      begin
        tPag := StrToFormaPagamento(ok, venda.codFormaNFCE);
        if ok = false then
        begin
          tPag := fpDinheiro;
        end;

        if recebido = 0 then
          DANFE.vTroco := 0
        else
          DANFE.vTroco := recebido - venda.total;

        // if recebido > venda.total then vPag := recebido
        // else vPag := venda.total;
        vPag := venda.total;
      end;

      // Adicionando Produtos
      fim := lista.Count - 1;
      for ini := 0 to fim do
      begin
        item := Item_venda(lista.Items[ini]);

        Det.Add;
        with Det.Items[ini] do
        begin
          Prod.nItem := ini + 1;
          Prod.cProd := strzero(IntToStr(item.cod), 6);
          Prod.cEAN := item.codbar;
          Prod.xProd := item.nome;
          Prod.NCM := item.NCM;
          Prod.EXTIPI := '';
          Prod.CFOP := CDCFOP;
          Prod.uCom := item.unid;
          Prod.qCom := item.quant;
          Prod.vUnCom := item.p_venda;
          Prod.vProd := item.total;
          Prod.cEANTrib := item.codbar;
          Prod.uTrib := item.unid;
          Prod.qTrib := item.quant;
          Prod.vUnTrib := item.p_venda;
          Prod.vFrete := 0;
          Prod.vSeg := 0;
          Prod.vDesc := item.desconto;

          tot_Geral := tot_Geral + (item.total - item.desconto);

          NODO_ICMS(item, cstIcmCfop, '', ini);
          NODO_PISCOFINS(item, cstpisCfop, ini);
          infAdProd := ' ';
        end;
      end;

      TotImp := 0;

      TotImp := calculaVlrAproxImpostos(lista);
      TipoEmissao := 'Valor aprox. Impostos:' + FormatCurr('#,###,###0.00',
        TotImp) + ' (' + FormatCurr('#,###,###0.00',
        ArredondaTrunca(TotImp / (totalNota - venda.desconto) * 100, 2)) +
        '%)Fonte IBPT' + ';' + TipoEmissao;

      total.ICMSTot.vBC := TOT_BASEICM;
      total.ICMSTot.vICMS := TOTICM;
      total.ICMSTot.vBCST := 0;
      total.ICMSTot.vST := 0;
      total.ICMSTot.vNF := totalNota - venda.desconto;
      total.ICMSTot.vProd := totalNota;
      total.ICMSTot.vFrete := 0;
      total.ICMSTot.vSeg := 0;
      total.ICMSTot.vDesc := venda.desconto;
      total.ICMSTot.vIPI := 0;
      total.ICMSTot.vPIS := TOT_PIS;
      total.ICMSTot.vCOFINS := TOT_COFINS;
      total.ICMSTot.vOutro := 0;
      Transp.modFrete := mfSemFrete; // NFC-e não pode ter FRETE
      infAdic.infCpl := TipoEmissao;
      infAdic.infAdFisco := '';
      // ACBrNFe.NotasFiscais.Items[0].SaveToFile(ExtractFileDir(ParamStr(0)) + '\arq.xml');
      // ShowMessage(dtmMain.ACBrNFe.NotasFiscais.Items[0].);
      { // Informa as formas de pagamento e seus respectivos valores !!
        try
        qrPg := TIB_Query.Create(nil);
        sql := 'select f.cdfinalizavenda,  f.cdformapagto, fp.nmformapagto, f.vlformapagto '+
        ' from finalizavenda f, formapagto fp, vendacfe v '+
        ' where f.cdformapagto = fp.cdformapagto '+
        ' and   f.cdvendacfe = v.cdvendacfe '+
        ' and v.nuvendacfe   = '''+NumNFCe+'''';
        qrPg.SQL.Add(sql);
        qrPg.Open;
        qrPg.First;
        while not qrPg.Eof do
        begin
        with pag.Add do
        begin
        tPag := FormaPagamento_NFCe(qrPg.FieldByName('nmformapagto').AsString);
        vPag := qrPg.FieldByName('vlformapagto').AsFloat;
        end;
        qrPg.Next;
        end;

        finally
        FreeAndNil(qrPg);
        end;
      }

    end;
  finally
    // FreeAndNil(qr);
  end;
end;

function FormaPagamento_NFCe(formaPagto: String): TpcnFormaPagamento;
begin
  Result := fpDinheiro;

  if (POS('Cart', formaPagto) > 0) or (POS('cart', formaPagto) > 0) or
    (POS('CART', formaPagto) > 0) or (POS('cArT', formaPagto) > 0) or
    (POS('CARt', formaPagto) > 0) then
    Result := fpCartaoCredito
  else
    Result := fpDinheiro;

  if (POS('Val', formaPagto) > 0) or (POS('VAL', formaPagto) > 0) or
    (POS('val', formaPagto) > 0) or (POS('VAl', formaPagto) > 0) or
    (POS('VaL', formaPagto) > 0) then
    Result := fpValePresente
  else
    Result := fpDinheiro;

  if (POS('Refeicao', formaPagto) > 0) or (POS('REFEICAO', formaPagto) > 0) or
    (POS('refeição', formaPagto) > 0) or (POS('REFEIÇÃO', formaPagto) > 0) or
    (POS('Refeição', formaPagto) > 0) then
    Result := fpValeRefeicao
  else
    Result := fpDinheiro;

  if (POS('Din', formaPagto) > 0) or (POS('DIN', formaPagto) > 0) or
    (POS('din', formaPagto) > 0) or (POS('DIn', formaPagto) > 0) then
    Result := fpDinheiro
  else
    Result := fpDinheiro;

  if (POS('Cheq', formaPagto) > 0) or (POS('CHEQ', formaPagto) > 0) or
    (POS('cheq', formaPagto) > 0) or (POS('CHeq', formaPagto) > 0) then
    Result := fpCheque
  else
    Result := fpDinheiro;

  if (POS('Credito', formaPagto) > 0) or (POS('Crédito', formaPagto) > 0) or
    (POS('credito', formaPagto) > 0) or (POS('crédito', formaPagto) > 0) or
    (POS('CREDITO', formaPagto) > 0) or (POS('CRÉDITO', formaPagto) > 0) then
    Result := fpCartaoCredito
  else
    Result := fpDinheiro;

  if (POS('Debito', formaPagto) > 0) or (POS('Débito', formaPagto) > 0) or
    (POS('debito', formaPagto) > 0) or (POS('débito', formaPagto) > 0) or
    (POS('DEBITO', formaPagto) > 0) or (POS('débito', formaPagto) > 0) then
    Result := fpCartaoDebito
  else
    Result := fpDinheiro;

end;

function Retorna_TipoEmissaoNFe(svl: string): TpcnTipoEmissao;
begin
  Result := teNormal;
  if svl = '1' then
    Result := teContingencia
  else if svl = '2' then
    Result := teSCAN
  else if svl = '3' then
    Result := teDPEC
  else if svl = '4' then
    Result := teFSDA
  else
    Result := teNormal;
end;

function Retorna_TipoAmbiente(svl: string): TpcnTipoAmbiente;
begin
  if svl = '1' then
    Result := taProducao
  else
    Result := taHomologacao;
end;

function Retorna_UFComerciante(svl: string): String;
begin
  Result := svl
end;

procedure reimpressaoNFCe(numeroNota: String);
begin

end;

function Retorna_FinalidadeNFe(svl: string): TpcnFinalidadeNFe;
begin
  if svl = 'COMPLEMENTAR' then
    Result := fnComplementar
  else if svl = 'AJUSTE' then
    Result := fnAjuste
  else
    Result := fnNormal;
end;

procedure Carrega_NotaFiscal_ArquivoXML(OpenDialog: TOpenDialog;
  var NotaFiscal: String; var CFOP: String; var CondPagto: String;
  var ModeloNF: String; var SerieNF: String; var DtEmissao: tdate;
  var DtEntSai: tdate; var HrEntSai: TDateTime; var CNPJEmitente: String;
  var InscEstEmitente: String; var InscMunicEmitente: String;
  var EnderecoEmitente: String; var NumeroEndEmitente: String;
  var BairroEmitente: String; var codMunicipoEmitente: String;
  var NomeMunicipioEmiente: String; var UFEmitente: String;
  var FoneEmitente: String; var CEPEmitente: String; var CNPJDestinario: String;
  var codMunicipioDestinario: String; var VlBaseCalculo: String;
  var VlICMS: String; var VlBaseCalculoST: String; var VlST: String;
  var VlProduto: String; var VlFrete: String; var VlSeguro: String;
  var VlDesconto: String; var VlIPI: String; var VlPis: String;
  var VlCofins: String; var VlOutros: String; var VlNotaFiscal: String;
  var ListaProdutos: TStrings);
var
  i, j, k, n: integer;
  nota, Node, NodePai, NodeItem: TTreeNode;
  NFeRTXT: TNFeRTXT;
  nuItem, CodProd, NomeProd, qtdProd, vlUnitProd, vlTotProd, codEANProd,
    CodNCMProd, CFOPProd, unidadeProd, vlFreteProd, vlSeguroProd, vlOutrosProd,
    vlDescontoProd, CSTProd, vlBaseCalcICMSProd, vlICMSProd, alICMSProd,
    vlBaseCalcSTProd, vlSTICMSProd, alICMSSTProd, vlBaseCalcICMSRedProd,
    vlICMSRedProd, alICMSRedProd, vlBaseCalcIPIProd, vlIPIProd, alIPIProd,
    vlBaseCalcPisProd, vlPisProd, alPisProd, vlBaseCalcCofinsProd, vlCofinsProd,
    alCofinsProd: String;
begin
  with OpenDialog do
  begin
    FileName := '';
    Title := 'Selecione a NFE';
    DefaultExt := '*-nfe.XML';
    Filter := 'Arquivos NFE (*-nfe.XML)|*-nfe.XML|Arquivos XML (*.XML)|*.XML|Arquivos TXT (*.TXT)|*.TXT|Todos os Arquivos (*.*)|*.*';
    InitialDir := ACBrNFe.Configuracoes.Arquivos.PathSalvar;
  end;
  if OpenDialog.Execute then
  begin
    ACBrNFe.NotasFiscais.Clear;
    ACBrNFe.NotasFiscais.Add;
    NFeRTXT := TNFeRTXT.Create(ACBrNFe.NotasFiscais.Items[0].nfe);
    NFeRTXT.CarregarArquivo(OpenDialog.FileName);
    if NFeRTXT.LerTxt then
      NFeRTXT.Free
    else
    begin
      NFeRTXT.Free;
      // tenta XML
      ACBrNFe.NotasFiscais.Clear;
      try
        ACBrNFe.NotasFiscais.LoadFromFile(OpenDialog.FileName);
      except
        ShowMessage('Arquivo NFC-e Inválido');
        exit;
      end;
    end;

    for n := 0 to ACBrNFe.NotasFiscais.Count - 1 do
    begin
      with ACBrNFe.NotasFiscais.Items[n].nfe do
      begin
        NotaFiscal := IntToStr(Ide.nnf);
        CFOP := Ide.natOp;
        CondPagto := IndpagToStr(Ide.indPag);
        ModeloNF := IntToStr(Ide.modelo);
        SerieNF := IntToStr(Ide.serie);
        DtEmissao := (Ide.dEmi);
        DtEntSai := (Ide.dSaiEnt);
        CNPJEmitente := Emit.CNPJCPF;
        InscEstEmitente := Emit.IE;
        InscEstEmitente := Emit.IEST;
        InscMunicEmitente := Emit.IM;
        FoneEmitente := Emit.EnderEmit.FONE;
        CEPEmitente := IntToStr(Emit.EnderEmit.CEP);
        EnderecoEmitente := Emit.EnderEmit.xLgr;
        NumeroEndEmitente := Emit.EnderEmit.nro;
        BairroEmitente := Emit.EnderEmit.xBairro;
        codMunicipoEmitente := IntToStr(Emit.EnderEmit.cMun);
        NomeMunicipioEmiente := Emit.EnderEmit.xMun;
        UFEmitente := Emit.EnderEmit.UF;

        // Dados Destinatário !!
        CNPJDestinario := dest.CNPJCPF;
        codMunicipioDestinario := IntToStr(dest.EnderDest.cMun);
        //
        for i := 0 to Det.Count - 1 do
        begin
          with Det.Items[i] do
          begin
            nuItem := IntToStr(Prod.nItem);
            CodProd := Prod.cProd;
            codEANProd := Prod.cEAN;
            NomeProd := Prod.xProd;
            CodNCMProd := Prod.NCM;
            CFOPProd := Prod.CFOP;
            unidadeProd := Prod.uCom;
            qtdProd := FloatToStr(Prod.qCom);
            vlUnitProd := FloatToStr(Prod.vUnCom);
            vlTotProd := FloatToStr(Prod.vProd);
            // vlFreteProd      := FloatToStr(Prod.vFrete);
            // vlSeguroProd     := FloatToStr(Prod.vSeg);
            vlDescontoProd := FloatToStr(Prod.vDesc);
            //
            with Imposto do
            begin
              with ICMS do
              begin
                if CST = cst00 then
                begin
                  vlBaseCalcICMSProd := FloatToStr(ICMS.vBC);
                  vlICMSProd := FloatToStr(ICMS.vICMS);
                  alICMSProd := FloatToStr(ICMS.pICMS);
                end
                else if CST = cst10 then
                begin
                  vlBaseCalcICMSProd := FloatToStr(ICMS.vBC);
                  vlICMSProd := FloatToStr(ICMS.vICMS);
                  alICMSProd := FloatToStr(ICMS.pICMS);
                  //
                  vlBaseCalcSTProd := FloatToStr(ICMS.vBCST);
                  vlSTICMSProd := FloatToStr(ICMS.vICMSST);
                  alICMSSTProd := FloatToStr(ICMS.pICMSST);
                end
                else if CST = cst20 then
                begin
                  vlBaseCalcICMSProd := FloatToStr(ICMS.vBC);
                  vlICMSProd := FloatToStr(ICMS.vICMS);
                  alICMSProd := FloatToStr(ICMS.pICMS);
                end
                else if CST = cst30 then
                begin
                  vlBaseCalcSTProd := FloatToStr(ICMS.vBCST);
                  vlSTICMSProd := FloatToStr(ICMS.vICMSST);
                  alICMSSTProd := FloatToStr(ICMS.pICMSST);
                end

                else if (CST = cst40) or (CST = cst41) or (CST = cst50) then
                begin
                  // trvwNFe.Items.AddChild(Node,'orig='    +OrigToStr(ICMS.orig));
                  vlBaseCalcICMSProd := FloatToStr(ICMS.vBC);
                  vlICMSProd := FloatToStr(ICMS.vICMS);
                  alICMSProd := FloatToStr(ICMS.pICMS);
                end
                else if CST = cst51 then
                begin
                  vlBaseCalcICMSProd := FloatToStr(ICMS.vBC);
                  vlICMSProd := FloatToStr(ICMS.vICMS);
                  alICMSProd := FloatToStr(ICMS.pICMS);
                end
                else if CST = cst60 then
                begin
                  vlBaseCalcSTProd := FloatToStr(ICMS.vBCST);
                  vlSTICMSProd := FloatToStr(ICMS.vICMSST);
                  alICMSSTProd := FloatToStr(ICMS.pICMSST);
                end
                else if CST = cst70 then
                begin
                  vlBaseCalcICMSProd := FloatToStr(ICMS.vBC);
                  vlICMSProd := FloatToStr(ICMS.vICMS);
                  alICMSProd := FloatToStr(ICMS.pICMS);
                  //
                  vlBaseCalcSTProd := FloatToStr(ICMS.vBCST);
                  vlSTICMSProd := FloatToStr(ICMS.vICMSST);
                  alICMSSTProd := FloatToStr(ICMS.pICMSST);
                end
                else if CST = cst90 then
                begin
                  vlBaseCalcICMSProd := FloatToStr(ICMS.vBC);
                  vlICMSProd := FloatToStr(ICMS.vICMS);
                  alICMSProd := FloatToStr(ICMS.pICMS);
                  //
                  vlBaseCalcSTProd := FloatToStr(ICMS.vBCST);
                  vlSTICMSProd := FloatToStr(ICMS.vICMSST);
                  alICMSSTProd := FloatToStr(ICMS.pICMSST);
                end;
              end;

              if (IPI.vBC > 0) then
              begin
                with IPI do
                begin
                  vlBaseCalcIPIProd := FloatToStr(IPI.vBC);
                  vlIPIProd := FloatToStr(IPI.vIPI);
                  alIPIProd := FloatToStr(IPI.pIPI);
                end;
              end;

              if (II.vBC > 0) then
              begin
                with II do
                begin
                  //
                end;
              end;

              with pis do
              begin
                if (CST = pis01) or (CST = pis02) then
                begin
                  vlBaseCalcPisProd := FloatToStr(pis.vBC);
                  vlPisProd := FloatToStr(pis.vPIS);
                  alPisProd := FloatToStr(pis.pPIS);
                end
                else if CST = pis03 then
                begin
                  //
                end
                else if CST = pis99 then
                begin
                  //
                end;
              end;

              if (PISST.vBC > 0) then
              begin
                with PISST do
                begin
                  //
                end;
              end;

              with COFINS do
              begin
                if (CST = cof01) or (CST = cof02) then
                begin
                  vlBaseCalcCofinsProd := FloatToStr(COFINS.vBC);
                  vlCofinsProd := FloatToStr(COFINS.vCOFINS);
                  alCofinsProd := FloatToStr(COFINS.pCOFINS);
                end
                else if CST = cof03 then
                begin
                  //
                end
                else if CST = cof99 then
                begin
                  //
                end;
              end;
              if (COFINSST.vBC > 0) then
              begin
                with COFINSST do
                begin
                  //
                end;
              end;
            end;
          end;
          // if vlFreteProd           = '' then vlFreteProd            := '0';
          if vlSeguroProd = '' then
            vlSeguroProd := '0';
          if vlOutrosProd = '' then
            vlOutrosProd := '0';
          if vlDescontoProd = '' then
            vlDescontoProd := '0';
          if CSTProd = '' then
            CSTProd := '0000';
          if vlBaseCalcICMSProd = '' then
            vlBaseCalcICMSProd := '0';
          if vlICMSProd = '' then
            vlICMSProd := '0';
          if alICMSProd = '' then
            alICMSProd := '0';
          if vlBaseCalcSTProd = '' then
            vlBaseCalcSTProd := '0';
          if vlSTICMSProd = '' then
            vlSTICMSProd := '0';
          if alICMSSTProd = '' then
            alICMSSTProd := '0';
          if vlBaseCalcICMSRedProd = '' then
            vlBaseCalcICMSRedProd := '0';
          if vlICMSRedProd = '' then
            vlICMSRedProd := '0';
          if alICMSRedProd = '' then
            alICMSRedProd := '0';
          if vlBaseCalcIPIProd = '' then
            vlBaseCalcIPIProd := '0';
          if vlIPIProd = '' then
            vlIPIProd := '0';
          if alIPIProd = '' then
            alIPIProd := '0';
          if vlBaseCalcPisProd = '' then
            vlBaseCalcPisProd := '0';
          if vlPisProd = '' then
            vlPisProd := '0';
          if alPisProd = '' then
            alPisProd := '0';
          if vlBaseCalcCofinsProd = '' then
            vlBaseCalcCofinsProd := '0';
          if vlCofinsProd = '' then
            vlCofinsProd := '0';
          if alCofinsProd = '' then
            alCofinsProd := '0';

          { ListaProdutos.Add(Alinha_Esquerda(nuItem,08)+' '+Alinha_Esquerda(CodProd,08)+' '+AjustaString(codEANProd,40)+' '+AjustaString(NomeProd, 60)+' '+AjustaString(CodNCMProd,40)+' '+
            AjustaString(CFOPProd,10)+' '+AjustaString(unidadeProd,05)+' '+Alinha_Esquerda(qtdProd,08)+' '+Alinha_Esquerda(vlUnitProd,16)+' '+Alinha_Esquerda(vlTotProd,16)+' '+
            Alinha_Esquerda(vlFreteProd,16)+' '+Alinha_Esquerda(vlSeguroProd,16)+' '+Alinha_Esquerda(vlDescontoProd,16)+' '+Alinha_Esquerda(vlOutrosProd,16)+' '+Alinha_Esquerda(vlBaseCalcICMSProd,16)+' '+
            Alinha_Esquerda(vlICMSProd,16)+' '+Alinha_Esquerda(alICMSProd,16)+' '+Alinha_Esquerda(vlBaseCalcSTProd,16)+' '+Alinha_Esquerda(vlSTICMSProd,16)+' '+Alinha_Esquerda(alICMSSTProd,16)+' '+
            Alinha_Esquerda(vlBaseCalcIPIProd,16)+' '+Alinha_Esquerda(vlIPIProd,16)+' '+Alinha_Esquerda(alIPIProd,16)+' '+Alinha_Esquerda(vlBaseCalcPisProd,16)+' '+Alinha_Esquerda(vlIPIProd,16)+' '+
            Alinha_Esquerda(alPisProd,16)+' '+Alinha_Esquerda(vlBaseCalcCofinsProd,16)+' '+Alinha_Esquerda(vlCofinsProd,16)+' '+Alinha_Esquerda(alCofinsProd,16));
          } end;
        VlBaseCalculo := FloatToStr(total.ICMSTot.vBC);
        VlICMS := FloatToStr(total.ICMSTot.vICMS);
        VlBaseCalculoST := FloatToStr(total.ICMSTot.vBCST);
        VlST := FloatToStr(total.ICMSTot.vST);
        VlProduto := FloatToStr(total.ICMSTot.vProd);
        VlFrete := FloatToStr(total.ICMSTot.vFrete);
        VlSeguro := FloatToStr(total.ICMSTot.vSeg);
        VlDesconto := FloatToStr(total.ICMSTot.vDesc);
        VlIPI := FloatToStr(total.ICMSTot.vIPI);
        VlPis := FloatToStr(total.ICMSTot.vPIS);
        VlCofins := FloatToStr(total.ICMSTot.vCOFINS);
        VlOutros := FloatToStr(total.ICMSTot.vOutro);
        VlNotaFiscal := FloatToStr(total.ICMSTot.vNF);
      end;
    end;
  end;
end;

function downloadXML(const chave, cnpj1, caminhoControlWBarra: String;
  const copiar: boolean = true): boolean;
begin
  LerConfiguracaoNFe();
  ACBrNFe.Configuracoes.Geral.Salvar := true;
  ACBrNFe.EventoNFe.Evento.Clear;
  with ACBrNFe.EventoNFe.Evento.Add do
  begin
    InfEvento.chNFe := chave;
    InfEvento.CNPJ := cnpj1;
    InfEvento.dhEvento := now;
    InfEvento.tpEvento := teManifDestCiencia;
    InfEvento.cOrgao := 91;
  end;

  ACBrNFe.EnviarEvento(0);
  if not ACBrNFe.WebServices.EnvEvento.EventoRetorno.retEvento[0]
    .RetInfEvento.cStat > 200 then
  begin
    MessageDlg('Evento - Não foi possível fazer o Download do XML:' + #13 +
      'Motivo: ' + ACBrNFe.WebServices.EnvEvento.EventoRetorno.retEvento[0]
      .RetInfEvento.xmotivo, mtError, [mbOK], 0);
    exit;
  end
  else
  begin
    MessageDlg('Evento Processado' + #13 + 'Motivo: ' +
      ACBrNFe.WebServices.EnvEvento.EventoRetorno.retEvento[0]
      .RetInfEvento.xmotivo + #13 + 'Cstat: ' +
      IntToStr(ACBrNFe.WebServices.EnvEvento.EventoRetorno.retEvento[0]
      .RetInfEvento.cStat), mtError, [mbOK], 0);
  end;

  ACBrNFe.DownloadNFe.Download.Chaves.Clear;
  ACBrNFe.DownloadNFe.Download.Chaves.Add.chNFe := chave;
  ACBrNFe.DownloadNFe.Download.CNPJ := cnpj1;

  if not ACBrNFe.WebServices.DownloadNFe.Executar then
  begin
    MessageDlg('NFe - Não foi possível fazer o Download do XML:' + #13 + #13 +
      'Motivo: ' + ACBrNFe.WebServices.DownloadNFe.retDownloadNFe.xmotivo,
      mtError, [mbOK], 0);
    exit;
  end;

  if copiar then
    CopyFile(pchar(caminhoControlWBarra + 'NFE\RESP\' +
      ACBrNFe.WebServices.DownloadNFe.ArqResp),
      pchar(caminhoControlWBarra + 'ENTRADAXML\' +
      ACBrNFe.WebServices.DownloadNFe.ArqResp), true);
  ShowMessage('Download Efetuado com Sucesso');
  ACBrNFe.Configuracoes.Geral.Salvar := false;
end;

function validaDadosDestinatario(): String;
var
  tipo: String;
  ok: boolean;
  invalido: integer;
begin
  Result := '';

  if length(dadosDest.Values['cnpj']) = 11 then
    tipo := '1'
  else if length(dadosDest.Values['cnpj']) = 14 then
    tipo := '2'
  else
  begin
    dadosDest.Values['cod'] := '';
    Result := Result + 'CPF/CNPJ Inválidos.';
  end;
  tipo := trim(tipo);
  IF (tipo = '1') OR (tipo = '6') then
  begin
    ok := VALIDACPF(dadosDest.Values['cnpj']);
    if tipo = '1' then
      dadosDest.Values['ies'] := '';
  end
  ELSE
  begin
    ok := VALIDACNPJ(dadosDest.Values['cnpj']);
  end;

  // SE O CODIGO DO MUNICIPIO ESTA EM BRANCO, USA O CODIGO DO MUNICIPIO DO EMITENTE
  IF (dadosDest.Values['cod_mun'] = '') then
    dadosDest.Values['cod_mun'] := dadosEmitente.Values['cod_mun'];

  invalido := 0;

  IF NOT ok then
  begin
    Result := Result + ' CPF/CNPJ do Destinatário Inválido ' + #13;
    invalido := invalido + 1;
  end;

  if CAMPO_VAZIO(dadosDest.Values['ende']) = 1 then
  begin
    Result := Result + 'Endereço Inválido ' + #13;
    invalido := invalido + 1;
  end;

  if CAMPO_VAZIO(dadosDest.Values['bairro']) = 1 then
  begin
    Result := Result + 'Bairro Inválido ' + #13;
    invalido := invalido + 1;
  end;

  if CAMPO_VAZIO(dadosDest.Values['cod_mun']) = 1 then
  begin
    Result := Result + 'Código do Municipio Inválido ' + #13;
    invalido := invalido + 1;
  end;

  if CAMPO_VAZIO(dadosDest.Values['cid']) = 1 then
  begin
    Result := Result + 'Nome do Municipio Inválido ' + #13;
    invalido := invalido + 1;
  end;

  if CAMPO_VAZIO(dadosDest.Values['est']) = 1 then
  begin
    Result := Result + 'Estado Inválido ' + #13;
    invalido := invalido + 1;
  end;

  if CAMPO_VAZIO(dadosDest.Values['cep']) = 1 then
  begin
    Result := Result + 'Cep Inválido ' + #13;
    invalido := invalido + 1;
  end;

  IF invalido <> 0 then
    Result := ' Dados do Cliente Incompletos ' + #13 + Result;
end;

FUNCTION CAMPO_VAZIO(ENT: STRING): Smallint;
BEGIN
  IF length(trim(ENT)) = 0 THEN
    Result := 1
  ELSE
    Result := 0;
END;

function buscaPastaConfigControlRede(): String;
var
  arq1: TStringList;
begin
  // PASTA_CONTROL_NFE
  Result := '';
  arq1 := TStringList.Create;
  if FileExists(ExtractFileDir(ParamStr(0)) + '\CONFIG.DAT') then
  begin
    arq1.Free;
    exit;
  end;

  arq1.LoadFromFile(ExtractFileDir(ParamStr(0)) + '\CONFIG.DAT');
  Result := arq1.Values['PASTA_CONTROL_NFE'];
  arq1.Free;
end;

function buscaConfigNaPastaDoControlW(Const config_name: String;
  const default: string): String;
var
  arq: TStringList;
  caminhoEXE_com_barra_no_final: String;
begin
  caminhoEXE_com_barra_no_final := ExtractFileDir(ParamStr(0)) + '\';

  // asume o valor padrão como valor de retorno
  Result := default;
  // se config.dat não encontrado, cria e retorna o valor default
  if not FileExists(caminhoEXE_com_barra_no_final + 'CONFIG.DAT') then
  begin
    arq := TStringList.Create;
    arq.SaveToFile(caminhoEXE_com_barra_no_final + 'CONFIG.DAT');
    arq.Free;
    exit;
  end;

  arq := TStringList.Create;
  arq.LoadFromFile(caminhoEXE_com_barra_no_final + 'CONFIG.DAT');
  // se o valor do parametro é válido, pega esse valor
  if trim(arq.Values[config_name]) <> '' then
    Result := arq.Values[config_name];
  arq.Free;
end;

function substitui_Nodo(nome: string; conteudo: string;
  const Texto: string): String;
var
  ini, fim: integer;
  come, final: String;
begin
  ini := 0;
  fim := 0;
  ini := POS('<' + nome + '>', Texto) + length('<' + nome + '>') - 1;
  come := copy(Texto, 1, ini);
  fim := POS('</' + nome + '>', Texto);
  final := copy(Texto, fim, length(Texto));
  // fim := fim + length('</'+nome+'>') + 1;
  Result := come + conteudo + final;

  // Result := copy(texto, 1, ini) + conteudo  + Result := copy(texto, fim, length(texto));
  // Result := copy(texto,ini,fim );
end;

function getSerieNFCe(): String;
begin
  Result := IntToStr(serie2);
end;

function buscaCRCdaChave(const chve: string): String;
begin
  Result := '';
  Result := copy(chve, 26, 9); // nNF
  Result := RightStr(Result, 7);
  Result := Result + RightStr(copy(chve, 23, 3), 2); // serie
end;

function ArredondaFinanceiro(Value: currency; Decimals: integer): currency;
var
  Factor, Fraction: currency;
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

function Arredonda(Valor: currency; decimais: integer; tipo: string = '')
  : currency;
begin
  Result := ArredondaFinanceiro(Valor, decimais);
end;

function reenviarCupom(nota22: String; var stats: String): boolean;
var
  n1, ssChave: string;
begin
  query1.Close;
  query1.SQL.text := 'select chave, adic from nfce where (nota = :nota)';
  query1.ParamByName('nota').AsString := nota22;
  query1.Open;

  if query1.fieldbyname('adic').AsString = '' then
  begin
    query1.Close;
    exit;
  end;

  ACBrNFe.NotasFiscais.Clear;
  if FileExists(buscaPastaNFCe(query1.fieldbyname('chave').AsString) +
    query1.fieldbyname('chave').AsString + '-nfe.xml') then
  begin
    ACBrNFe.NotasFiscais.LoadFromFile
      (buscaPastaNFCe(query1.fieldbyname('chave').AsString) +
      query1.fieldbyname('chave').AsString + '-nfe.xml');
    n1 := IntToStr(ACBrNFe.NotasFiscais[0].nfe.Ide.nnf);
    ACBrNFe.NotasFiscais.Clear;
  end
  else
    n1 := '';
  query1.Close;

  GerarNFCe(nota22, '0', '', serie, n1, '');
  try
    ACBrNFe.enviar(0, false);
  except
    on e: Exception do
    begin
      stats := e.Message;
      exit;
    end;
  end;

  ssChave := ACBrNFe.WebServices.Retorno.ChaveNFe;
  if ACBrNFe.WebServices.enviar.cStat <= 200 then
  begin
    Result := true;
    stats := 'OK';
    venda.chave := ssChave;
    if ACBrNFe.WebServices.enviar.cStat = 100 then
      venda.adic := '';
    insereNotaBD(venda);
  end;
end;

procedure geraPgerais(var lis: TStringList);
begin
  if query1.Database.Connected = false then
    exit;
  query1.Close;
  query1.SQL.Clear;
  query1.SQL.Add('select * from pgerais order by cod');
  query1.Open;
  query1.First;
  lis := TStringList.Create;
  while not query1.Eof do
  begin
    lis.Add(query1.fieldbyname('cod').AsString + '=' +
      query1.fieldbyname('valor').AsString);
    query1.Next;
  end;

  query1.Close;
end;

function inutilizacaoNFCE(ini, fim, modelo: integer; just: String;
  _serie: integer = 0): boolean;
var
  CNPJ: String;
begin
  carregaConfigsNFCe;
  query1.Close;
  query1.SQL.text := 'select cnpj from registro';
  query1.Open;

  CNPJ := strnum(query1.fieldbyname('cnpj').AsString);
  ACBrNFe.Configuracoes.Geral.Salvar := true;

  if modelo = 55 then
  begin
    CriaDiretorio(ExtractFileDir(ParamStr(0)) + '\NFE\INU\');
    ACBrNFe.Configuracoes.Arquivos.PathInu := ExtractFileDir(ParamStr(0)) +
      '\NFE\INU\';
    ACBrNFe.Configuracoes.Geral.ModeloDF := moNFe;
    ACBrNFe.DANFE := DANFE_Rave;
    _serie := 1;
  end
  else
  begin
    CriaDiretorio(ExtractFileDir(ParamStr(0)) + '\NFCE\INU\');
    ACBrNFe.Configuracoes.Arquivos.PathInu := ExtractFileDir(ParamStr(0)) +
      '\NFCE\INU\';
    ACBrNFe.Configuracoes.Geral.ModeloDF := moNFCe;
    ACBrNFe.DANFE := DANFE;
    if _serie = 0 then
      _serie := StrToIntDef(getSerieNFCe, 1);
  end;

  try
    try
      ACBrNFe.Configuracoes.WebServices.Visualizar := true;
      ACBrNFe.WebServices.Inutiliza(CNPJ, just,
        StrToIntDef(FormatDateTime('yyyy', now), 2016), modelo, _serie,
        ini, fim);
    except
      on e: Exception do
      begin
        ShowMessage(e.Message);
        exit;
      end;
    end;
  finally
    ACBrNFe.Configuracoes.WebServices.Visualizar := false;
    ACBrNFe.Configuracoes.Geral.Salvar := false;
  end;

  if ACBrNFe.WebServices.Inutilizacao.cStat = 102 then
  begin
    insereInutilizacao(ini, fim, IntToStr(modelo), IntToStr(_serie), now);
  end;
  // ACBrNFe.DANFE := DANFE_Rave;
  // DANFE_Rave.MostrarPreview := true;
  // ACBrNFe.;
end;

function verCSTcFOP(CFOP: String): String;
begin
  query1.Close;
  query1.SQL.text := 'select * from cod_op where cod = :cod';
  query1.ParamByName('cod').AsString := strnum(CFOP);
  query1.Open;

  if not query1.IsEmpty then
  begin
    cstIcmCfop := query1.fieldbyname('icms').AsString;
    cstpisCfop := query1.fieldbyname('pis').AsString;
  end
  else
  begin
    cstIcmCfop := '';
    cstpisCfop := '';
  end;
end;

procedure gravaERRO_LOG(caminho1, erro2, local1: String);
var
  F: TextFile;
  S, temp, Caminho: String;
  i: integer;
begin
  Try
    if caminho1 = '' then
      caminho1 := ExtractFileDir(ParamStr(0)) + '\ERRONFE.txt';

    // IF NOT FileExists(caminho1) THEN GravarTexto(caminho1, '');

    temp := erro2;
    // S := (DateTimeToStr(Now)+' '+NomeDoUsuario+': '+S);
    AssignFile(F, caminho1);
    If FileExists(caminho1) Then
      Append(F)
    Else
      Rewrite(F); { if }
    { temp :=       '----------------------------------------------------------------'+ #13+#10;
      temp := temp + 'Chave:    '+ ACBrNFe.NotasFiscais[0].NFe.infNFe.ID + #13 + #10;
      temp := temp + 'nNF:      '+ IntToStr(ACBrNFe.NotasFiscais[0].NFe.Ide.nNF) + #13 + #10;
      temp := temp + 'cNF:      '+ IntToStr(ACBrNFe.NotasFiscais[0].NFe.Ide.cNF) + #13 + #10;
      temp := temp + 'Processo: '+ local1 + #13 + #10;
      temp := temp + 'data:     '+ FormatDateTime('dd/mm/yy',now) + ' ' + FormatDateTime('tt',now) + #13 + #10;
      temp := temp + 'Erro: ' + erro2 + #13 + #10;
      temp := temp + '---------------------------------------------------------------'+ #13+#10; }
    Writeln(F, erro2);
    CloseFile(F);
  Except
    // Abort;
  End; { try }
end; { procedure }

procedure gravaERRO_LOG1(caminho1, erro2, local1: String);
var
  F: TextFile;
  S, temp, Caminho: String;
  i: integer;
  arq: TStringList;
begin
  gravaERRO_LOG(caminho1, erro2, local1);
  exit;

  Try
    if caminho1 = '' then
      caminho1 := ExtractFileDir(ParamStr(0)) + '\ERRONFE.txt';
    arq := TStringList.Create;

    if FileExists(caminho1) then
      arq.LoadFromFile(caminho1);
    temp := erro2;

    if local1 = 'erro1' then
      temp := temp + ' Data: ' + FormatDateTime('dd/mm/yy', now) + ' ' +
        FormatDateTime('tt', now);

    { temp :=       '----------------------------------------------------------------'+ #13+#10;
      temp := temp + 'Chave:    '+ ACBrNFe.NotasFiscais[0].NFe.infNFe.ID + #13 + #10;
      temp := temp + 'nNF:      '+ IntToStr(ACBrNFe.NotasFiscais[0].NFe.Ide.nNF) + #13 + #10;
      temp := temp + 'cNF:      '+ IntToStr(ACBrNFe.NotasFiscais[0].NFe.Ide.cNF) + #13 + #10;
      temp := temp + 'Processo: '+ local1 + #13 + #10;
      temp := temp + 'data:     '+ FormatDateTime('dd/mm/yy',now) + ' ' + FormatDateTime('tt',now) + #13 + #10;
      temp := temp + 'Erro: ' + erro2 + #13 + #10;
      temp := temp + '---------------------------------------------------------------'+ #13+#10; }

    arq.Add(temp);
    arq.SaveToFile(caminho1);
    arq.Free;
  Except
  End; { try }
end; { procedure }

function getUltimoNumero(): String;
var
  ini, ret: integer;
begin
  Result := '1';

  query1.Close;
  query1.SQL.text :=
    'select max(cast(substring(chave from 26 for 9) as integer)) as ord from nfce';
  query1.Open;

  if query1.IsEmpty then
  begin
    query1.Close;
    exit;
  end;

  Result := query1.fieldbyname('ord').AsString;
  query1.Close;
end;

function getNumeroValido(): String;
var
  ini, ret: integer;
begin
  Result := '1';

  query1.Close;
  query1.SQL.text :=
    'select substring(chave from 26 for 9) as ord from nfce order by ord';
  query1.Open;

  if query1.IsEmpty then
  begin
    query1.Close;
    exit;
  end;

  ini := 0;
  Result := '';
  while not query1.Eof do
  begin
    while true do
    begin
      if query1.Eof then
        break;
      ini := ini + 1;
      if ini <> query1.fieldbyname('ord').AsInteger then
      begin
        Result := IntToStr(ini);
        exit;
      end
      else
        break;
    end;

    ret := query1.fieldbyname('ord').AsInteger;
    query1.Next;
  end;

  ret := ret + 1;
  Result := IntToStr(ret);
  query1.Close;
end;

FUNCTION VE_IMPOSTO(_PC, _PV, _qtd: currency): currency;
var
  PERC, LUC, APLICA_PERC: currency;
begin
  _PC := _PC * _qtd;
  _PV := _PV * _qtd;

  PERC := StrToCurrDef(pgerais.Values['40'], 100);
  Result := 0;

  // LIMITA OS PERCENTUAIS
  PERC := IfThen(PERC <= 5, 40, PERC);
  PERC := IfThen(PERC >= 500, 70, PERC);

  // SE APLICA O PERCENTUAL SOBRE O LUCRO BRUTO OU SOBRE PRE? DE VENDA
  // APLICA_PERC := VAL(SUBSTR(CONFIG1, 162, 1))
  if _PV - _PC = 0 then
  begin
    Result := (_PV * PERC) / 100;
    exit;
  end;

  Result := (((_PV - _PC) * _qtd) * (PERC / 100));
end;

function GRAVA_NODO_PROT_NFE1(ARQ_caminho: string): string;
var
  Texto, NODO_PROT, cStat, nnf, chave1, digVal: string;
  Retorno: TStringList;
  txt1: AnsiString;
begin
  cStat := '';
  Result := '';
  NODO_PROT := '';
  Retorno := TStringList.Create;

  if not FileExists(ARQ_caminho) then
  begin
    exit;
  end;

  Retorno.LoadFromFile(ARQ_caminho);
  Result := Retorno.text;

  cStat := IntToStr(ACBrNFe.WebServices.enviar.cStat);
  cStat := trim(cStat);
  // if funcoes.Contido(cStat, '101-135') then cStat := '101';

  // dadosEmitente.LoadFromFile(ARQ_caminho);
  Retorno.Values['DhRecbto'] := FormatDateTime('yyyy-mm-dd', now);

  // retorno.Text := copy(ACBrNFe.WebServices.Retorno.RetWS, pos('<protNFe versao=', ACBrNFe.WebServices.Retorno.RetWS), pos('</protNFe>', ACBrNFe.WebServices.Retorno.RetWS) );
  NODO_PROT := copy(ACBrNFe.WebServices.Retorno.RetWS,
    POS('<protNFe versao=', ACBrNFe.WebServices.Retorno.RetWS),
    length(ACBrNFe.WebServices.Retorno.RetWS));
  NODO_PROT := LeftStr(NODO_PROT, POS('</protNFe>', NODO_PROT) + 9);

  if Contido('<protNFe', Result) then
  begin
    Result := copy(Result, 1, POS('<protNFe', Result) - 1);
  end
  else
  begin
    Result := copy(Result, 1, POS('</NFe>', Result) - 1);
  end;

  if Result[length(Result)] <> '>' then
    Result := Result + '>';
  Result := Result + NODO_PROT + '</nfeProc>';

  Retorno.text := Result;
  Retorno.SaveToFile(ARQ_caminho);

  Retorno.Free;
end;

function calculaVlrAproxImpostos(var lista11: TList): currency;
var
  ex, descricao: String;
  tabela: integer;
  aliqFedNac, aliqFedImp, aliqEst, aliqMun: double;
  ini1: integer;
  item: Item_venda;
  arqExiste: Smallint;
begin
  Result := 0;
  arqExiste := 0;

  if FileExists(ExtractFileDir(ParamStr(0)) + '\IBPT.csv') then
  begin
    ACBrIBPTax1.AbrirTabela(ExtractFileDir(ParamStr(0)) + '\IBPT.csv');
  end;

  for ini1 := 0 to lista11.Count - 1 do
  begin
    application.ProcessMessages;
    try
      item := lista11[ini1];
    except
      on e: Exception do
      begin
        ShowMessage('erro:' + e.Message);
      end;
    end;

    query2.Close;
    query2.SQL.text :=
      'select p_venda, p_compra, classif from produto where cod = :cod';
    query2.ParamByName('cod').AsInteger := item.cod;
    query2.Open;

    item.p_venda := query2.fieldbyname('p_venda').AsCurrency;
    item.p_compra := query2.fieldbyname('p_compra').AsCurrency;
    item.quant := abs(item.quant);
    query2.Close;

    if ACBrIBPTax1.Procurar(item.NCM, ex, descricao, tabela, aliqFedNac,
      aliqFedImp, aliqEst, aliqMun, true) then
    begin
      item.vlr_imposto := ArredondaTrunca((abs(item.total) - abs(item.desconto))
        * (aliqFedNac + aliqEst) / 100, 2);
      Result := Result + item.vlr_imposto;
      // ShowMessage('imp=' + CurrToStr(item.vlr_imposto) + #13 + 'aliq=' + CurrToStr(aliqFedNac + aliqEst) + #13 + 'Result=' +  CurrToStr(Result));
      { ShowMessage('imp-achou=' + CurrToStr(item.vlr_imposto) +
        #13 + 'p_venda='+ CurrToStr(item.p_venda) + #13 + 'p_comra=' + CurrToStr(item.p_compra) +
        #13 + 'Result=' +  CurrToStr(Result)); }
    end
    else
    begin
      ACBrIBPTax1.Procurar('96089989', ex, descricao, tabela, aliqFedNac,
        aliqFedImp, aliqEst, aliqMun, true);
      item.vlr_imposto := ArredondaTrunca((abs(item.total) - abs(item.desconto))
        * (aliqFedNac + aliqEst) / 100, 2);
      Result := Result + item.vlr_imposto;

      { item.vlr_imposto := VE_IMPOSTO(item.p_compra, item.p_venda, item.quant);
        Result := Result + item.vlr_imposto; }
      { ShowMessage('imp=' + CurrToStr(item.vlr_imposto) +
        #13 + 'p_venda='+ CurrToStr(item.p_venda) + #13 + 'p_comra=' + CurrToStr(item.p_compra) +
        #13 + 'Result=' +  CurrToStr(Result)); }

    end;
  end;

end;

function ArredondaTrunca(Value: Extended; decimais: integer): Extended;
begin
  if decimais = 2 then
    Result := trunc(Value * 100) / 100
  else
    Result := trunc(Value * 1000) / 1000;
end;

FUNCTION GerarNFCeTexto(nota: String; cliente: String; nnf: String = '';
  chave: String = ''): AnsiString;
begin
  PIS_ST := 0;
  PIS_NT := 0;
  COFINS_ST := 0;
  cod_OP := '5102';

  lerItensDaVenda(lista, nota);
  LerDados_Emit_Dest(cliente, nnf);
  Result := NODO_RAIZ(nota);
end;

{ FUNCTION GerarNFCeTextoCliente( nota : String; var cliente : TStringList; nnf : String = '') : AnsiString;
  begin
  exit
  PIS_ST := 0;
  PIS_NT := 0;
  COFINS_ST := 0;
  cod_OP := '5102';

  lerItensDaVenda(lista, nota);
  LerDados_Emit_Dest1(cliente, nnf);

  Result := NODO_RAIZ(NOTA);
  end; }

FUNCTION NODO_RAIZ(nota: STRING): string;
begin
  Result := '<?xml version="1.0" encoding="UTF-8"?><nfeProc versao="' +
    versaoNFCe + '" xmlns="http://www.portalfiscal.inf.br/nfe">' +
    trim(NODO_NFE(nota)) + '</nfeProc>';
end;

FUNCTION NODO_NFE(nota: STRING): string;
begin
  Result := '<NFe xmlns="http://www.portalfiscal.inf.br/nfe">' +
    trim(NODO_INFNFE(GeraChaveNf(nota), nota)) + '</NFe>';
end;

FUNCTION NODO_INFNFE(CHAVENF, nota: string): string;
var
  dest_ies: string;
begin
  Result := '<infNFe versao="' + versaoNFCe + '" Id="NFe' +
    trim(CHAVENF) + '">';
  Result := Result + NODO_IDE(nota, '14', dadosEmitente.Values['nf'], '1',
    CDCFOP, '0', FormataData(now), '1', '1400100', DigiVerifi);
  Result := Result + NODO_EMIT(dadosEmitente.Values['cnpj'],
    dadosEmitente.Values['razao'], dadosEmitente.Values['empresa'],
    dadosEmitente.Values['ende'], dadosEmitente.Values['bairro'],
    dadosEmitente.Values['cod_mun'], dadosEmitente.Values['cid'],
    dadosEmitente.Values['est'], strnum(dadosEmitente.Values['cep']),
    dadosEmitente.Values['telres'], dadosEmitente.Values['ies'],
    pgerais.Values['10']);
  Result := Result + NODO_DEST(dadosDest.Values['tipo'],
    dadosDest.Values['cnpj'], dadosDest.Values['cnpj'],
    dadosDest.Values['nome'], dadosDest.Values['ende'],
    dadosDest.Values['bairro'], dadosDest.Values['cod_mun'],
    dadosDest.Values['cid'], dadosDest.Values['est'], dadosDest.Values['cep'],
    dadosDest.Values['telres'], dadosDest.Values['ies'],
    dadosEmitente.Values['cod_mun']);
  Result := Result + NODO_ITENS(lista, CDCFOP, '', '', '', '0');
  Result := Result + NODO_TOTAL(totalNota, TOT_BASEICM, TOTICM, TOT_PIS,
    TOT_COFINS, 0, TOTDESC);
  Result := Result + NODO_TRANP();
  Result := Result + NODO_PAG();
  Result := Result + NODO_INFADIC(infAdic, PIS_NT, PIS_ST, COFINS_ST, 0) +
    '</infNFe>';
end;

FUNCTION NODO_IDE(nota, UF, NUM_NF, FIN_NFE, COD_CFOP, EXT_CFOP, DAT, FORMPAG,
  COD_MUNIC, DV_NF: string; OFFLine: boolean = false): string;
var
  TIPO_AMB, idDest, partContigencia: string;
begin
  if ACBrNFe.Configuracoes.WebServices.Ambiente = taProducao then
    TIPO_AMB := '1'
  else
    TIPO_AMB := '2';
  if strnum(CDCFOP) = '0' then
    COD_CFOP := '5102';
  idDest := '1';
  if tpEmis = '' then
    tpEmis := '1';
  partContigencia := '';

  dHAtual := getDataHoraAtualXML();

  if contOFFLINE then
  begin
    tpEmis := '9';
    partContigencia := '<dhCont>' + dHAtual + '</dhCont>' +
      '<xJust>NOTA FISCAL EMITIDA EM CONTINGENCIA</xJust>';
  end;

  Result := '<ide><cUF>' + UF + '</cUF><cNF>' + CompletaOuRepete('', nota, '0',
    8) + '</cNF><natOp>VENDA AO CONSUMIDOR</natOp>' + '<indPag>' +
    IfThen(FORMPAG = '1', '0', '1') + '</indPag><mod>65</mod><serie>' +
    getSerieNFCe + '</serie><nNF>' + NUM_NF + '</nNF><dhEmi>' + dHAtual +
    '</dhEmi>' + '<tpNF>' + IfThen(Contido(COD_CFOP[1], '567'), '1', '0') +
    '</tpNF><idDest>' + idDest + '</idDest><cMunFG>' + COD_MUNIC + '</cMunFG>' +
    '<tpImp>4</tpImp><tpEmis>' + tpEmis + '</tpEmis><cDV>' + DV_NF +
    '</cDV><tpAmb>' + TIPO_AMB + '</tpAmb><finNFe>' + FIN_NFE +
    '</finNFe><indFinal>1</indFinal><indPres>1</indPres><procEmi>0</procEmi><verProc>ControlW Versao 1</verProc>'
    + partContigencia + '</ide>';
  Result := trim(Result);
end;

function GeraChaveNf(nota: STRING): string;
var
  seq: string;
  i: integer;
  total, dv: currency;
  Data: TDateTime;
begin
  if contOFFLINE then
  begin
    tpEmis := '9';
  end;

  Data := now;
  if chaveRecria <> '' then
  begin
    Data   := CodificaDataPelaChave(chaveRecria);
    tpEmis := copy(chaveRecria, 35, 1);
    codNF  := StrToIntDef(copy(chaveRecria, 26, 9), 0);
  end;

  Result := '';
  Result := IntToStr(14); // cod uf tamanho 02
  Result := Result + FormatDateTime('yymm', Data);
  // ano e mes de emissao tamanho 04
  Result := Result + dadosEmitente.Values['cnpj'];
  // cnpj do emitente tamanho 14
  Result := Result + '65'; // modelo da nf 02
  Result := Result + strzero(getSerieNFCe, 3);
  // '001';                    //serie 03
  Result := Result + CompletaOuRepete('', IntToStr(codNF), '0', 9);
  // numero nota fiscal 09
  Result := Result + tpEmis; // forma de emissao
  Result := Result + CompletaOuRepete('', nota, '0', 8); // nota de venda
  seq := '';
  seq := '432' + CompletaOuRepete('', '', '98765432', 5);
  total := 0;

  for i := 1 to length(Result) do
  begin
    try
      total := total + StrToCurr(seq[i]) * StrToCurr(Result[i]);
    except
      Result := '*';
      exit;
    end;
  end;

  i := (trunc(total) mod 11);
  i := 11 - i;
  if i > 9 then
    i := 0;
  DigiVerifi := IntToStr(i);
  Result := Result + IntToStr(i);
  // Result := 'NFe' + Result;
  CHAVENF := Result;
end;

FUNCTION NODO_ITENS(var lista: TList; CFOP, POS, CSTICM_CFP, CSTPIS_CFP,
  _ORIGE: string): string;
var
  barras, CFOP1 : string;
  cont, i, qtd: integer;
  item: Item_venda;
begin
  CSTPIS_CFP := pgerais.Values['10'];
  Result := '';
  qtd := 0;
  cont := lista.Count - 1;
  for i := 0 to cont do
  begin
    application.ProcessMessages;
    if usaNFe4ouMaior then begin
      CFOP1 := '5102';
    end
    else CFOP1 := pgerais.Values['96'];

    if ((trim(CFOP1) = '') or (length(CFOP1) <> 4) or (LeftStr(CFOP1, 1) <> '5'))
    then
      CFOP1 := '5102';
    qtd := qtd + 1;
    item := lista.Items[i];

    if (ACBrNFe.Configuracoes.WebServices.Ambiente = taHomologacao) and (i = 0)
    then
    begin
      item.nome :=
        'NOTA FISCAL EMITIDA EM AMBIENTE DE HOMOLOGACAO - SEM VALOR FISCAL';
    end;

    barras := item.codbar;

      if item.codAliq = 10 then begin
        CFOP1 := '5405';
      end;
   
    if length(barras) <> 13 then barras := '';
    if ((usaNFe4ouMaior) and (LeftStr(barras, 3) <> '789')) then barras := 'SEM GTIN';

    Result := Result + '<det nItem="' + IntToStr(qtd) + '"><prod>' + '<cProd>' +
      strzero(IntToStr(item.cod), 6) + '</cProd><cEAN>' + barras + '</cEAN>' +
      '<xProd>' + trim(item.nome) + '</xProd><NCM>' + item.NCM + '</NCM>' +
      ve_cest(item.codAliq, item.NCM) + '<CFOP>' + CFOP1 + '</CFOP>' + '<uCom>'
      + item.unid + '</uCom><qCom>' +
      Format_num(0, FormatCurr('0.0000', item.quant)) + '</qCom><vUnCom>' +
      Format_num(0, FormatCurr('0.000000', item.p_venda)) + '</vUnCom><vProd>' +
      Format_num(item.total) + '</vProd><cEANTrib>' + barras + '</cEANTrib>' +
      '<uTrib>' + item.unid + '</uTrib><qTrib>' +
      Format_num(0, FormatCurr('0.0000', item.quant)) + '</qTrib><vUnTrib>' +
      Format_num(0, FormatCurr('0.000000', item.p_venda)) + '</vUnTrib>' +
      '<vFrete>' + Format_num(item.Vlr_Frete) + '</vFrete>' +
      IfThen(item.desconto = 0, '<vDesc>0.00</vDesc>',
      '<vDesc>' + Format_num(item.desconto) + '</vDesc>') +
      '<indTot>1</indTot></prod><imposto>' + NODO_ICMS1(item, cstIcmCfop,
      _ORIGE) + NODO_PISCOFINS1(item, cstpisCfop) + '</imposto></det>';
    // NODO_PISCOFINS(MAT, CSTPIS_CFP)
    { Result := Result + '<det nItem="' + IntToStr(qtd) + '"><prod>' +
      '<cProd>' + strzero(IntToStr(item.cod), 6) + '</cProd><cEAN>' + barras + '</cEAN>' +
      '<xProd>' + trim(item.nome) + '</xProd><NCM>' + item.Ncm + '</NCM>'+ve_cest(item.CodAliq, item.Ncm)+'<CFOP>' + CFOP1 + '</CFOP>' +
      '<uCom>' + item.unid + '</uCom><qCom>' + FORMAT_NUM(item.quant) + '</qCom><vUnCom>' +
      FORMAT_NUM(item.p_venda) + '</vUnCom><vProd>' + FORMAT_NUM(item.total) + '</vProd><cEANTrib></cEANTrib>' +
      '<uTrib>' + item.unid + '</uTrib><qTrib>' + FORMAT_NUM(item.quant) + '</qTrib><vUnTrib>' +
      FORMAT_NUM(item.p_venda) + '</vUnTrib>'+ IfThen(item.Vlr_Frete > 0, '<vFrete>'+ Format_num(item.Vlr_Frete) +'</vFrete>', '') + IfThen(item.Desconto > 0,'<vDesc>' + FORMAT_NUM(item.Desconto) + '</vDesc>','') +
      '<indTot>1</indTot></prod><imposto>' + NODO_ICMS1(item, cstIcmCfop, _ORIGE) + NODO_PISCOFINS1(item, cstpisCfop) + '</imposto></det>'; //NODO_PISCOFINS(MAT, CSTPIS_CFP) }
  end;
end;

FUNCTION NODO_TOTAL(TOTNOTA, TOT_BASEICM, TOT_ICM, TOT_PIS, TOT_COFINS,
  TOTDESCICM, TOTDESC: currency): string;
begin
  TOTDESCICM := 0;
  Result := '<total><ICMSTot><vBC>' + Format_num(TOT_BASEICM) + '</vBC><vICMS>'
    + Format_num(TOT_ICM) + '</vICMS><vBCST>0.00</vBCST><vST>0.00</vST><vProd>'
    + Format_num(TOTNOTA) +
    '</vProd><vFrete>0.00</vFrete><vSeg>0.00</vSeg><vDesc>' +
    Format_num(TOTDESCICM + TOTDESC) + '</vDesc>' +
    '<vII>0.00</vII><vIPI>0.00</vIPI><vPIS>' + Format_num(TOT_PIS) +
    '</vPIS><vCOFINS>' + Format_num(TOT_COFINS) +
    '</vCOFINS><vOutro>0.00</vOutro><vNF>' + Format_num(TOTNOTA - TOTDESC) +
    '</vNF></ICMSTot></total>';

  try
    // danfe.vTroco := vlRecebido - (TOTNOTA - TOTDESc);
  except
  end;
  // ShowMessage(CurrToStr(TOTNOTA) + #13 + CurrToStr(TOTDESCICM) + #13 + CurrToStr(totDesc));
end;

FUNCTION NODO_INFADIC(INFO: string; PIS_NT, PIS_ST, COFINS_ST,
  _CFOP: currency): String;
var
  OBS: string;
begin
  OBS := '';
  { //PEGA MENSAGENS DO CFOP, SE TIVEREM
    IF(length(OBS) <> 0) then OBS := OBS + #10;
    IF(PIS_NT <> 0) then      OBS := OBS + 'Total de mercadorias nao tributadas por PIS/COFINS: ' + FormatCurr('#,###,###0.00',PIS_NT) + ';';
    IF(PIS_ST <> 0) then      OBS := OBS + ' Total de PIS retido anteriormente por ST: ' + FormatCurr('#,###,###0.00',PIS_ST) + ';';
    IF(COFINS_ST <> 0) then   OBS := OBS + ' Total de COFINS retida anteriormente por ST: ' + FormatCurr('#,###,###0.00',COFINS_ST) + ';';
    IF(TOT_PIS <> 0) then     OBS := OBS + ' PIS recolher: ' + FormatCurr('#,###,###0.00',TOT_PIS) + ';';
    IF(TOT_COFINS <> 0) then  OBS := OBS + ' COFINS a recolher: ' + FormatCurr('#,###,###0.00',TOT_COFINS) + ';'; }

  TotImp := calculaVlrAproxImpostos(lista);

  OBS := OBS + 'Valor aprox. Impostos: ' + formataCurrency(TotImp) + '(' +
    formataCurrency(TotImp / (totalNota - TOTDESC) * 100) + '%) Fonte: IBPT ';
  IF INFO <> '' THEN
    INFO := INFO + ';';
  OBS := OBS + ' ' + (INFO);
  OBS := obs2 + OBS;
  Result := '';

  /// obs := obs2 + InputBox('','','');

  Result := '<infAdic><infCpl>' + removeCarateresEspeciais(OBS) +
    '</infCpl></infAdic>';
end;

FUNCTION NODO_ICMS1(var MAT: Item_venda; CSTICM_CFOP, _ORIGE: string): string;
var
  tot: currency;
begin
  tot := MAT.total - MAT.desconto;
  Result := '';
  // se a empresa é optante do simples nacional
  if pgerais.Values['10'] = '1' then
  begin
    // EXPORTAÇÃO - CSOSN = 300
    IF Contido(LeftStr(cod_OP, 1), '4-7') then
    begin
      Result := '<ICMS><ICMSSN102><orig>' + _ORIGE +
        '</orig><CSOSN>300</CSOSN></ICMSSN102></ICMS>';
      exit;
    end;

    if mat.CodAliq = 10 then begin
      if usaNFe4ouMaior then begin
        Result := '<ICMS><ICMSSN500><orig>' + _ORIGE + '</orig><CSOSN>500</CSOSN>' +
        '</ICMSSN500></ICMS>';
      end
      else begin
        Result := '<ICMS><ICMSSN500><orig>' + _ORIGE + '</orig><CSOSN>500</CSOSN>' +
        '<vBCSTRet>' + FORMAT_NUM(mat.p_compra) + '</vBCSTRet>' +
        '<vICMSSTRet>' + FORMAT_NUM(Arredonda(mat.p_compra * 0.16, 2)) + '</vICMSSTRet>' +
        '</ICMSSN500></ICMS>';
      end;

      exit;
    end;

    if MAT.codAliq = 11 then
    begin
      Result := '<ICMS><ICMSSN102><orig>' + _ORIGE +
        '</orig><CSOSN>400</CSOSN></ICMSSN102></ICMS>';
      exit;
    end;

    if MAT.codAliq = 12 then
    begin
      Result := '<ICMS><ICMSSN102><orig>' + _ORIGE +
        '</orig><CSOSN>300</CSOSN></ICMSSN102></ICMS>';
      exit;
    end;

    if MAT.Reducao <> 0 then
    begin
      Result := '<ICMSSN900><orig>' + _ORIGE +
        '</orig><CSOSN>900</CSOSN><modBC>3</modBC>' + '<vBC>' +
        Format_num(Arredonda(tot * MAT.Reducao / 100, 2)) + '</vBC>' +
        '<pRedBC>' + Format_num(MAT.Reducao) + '</pRedBC>' + '<pICMS>' +
        Format_num(MAT.p_venda) + '</pICMS>' + '<vICMS>' + Format_num(0) +
        '</vICMS>' + '<modBCST>0.00</modBCST><vBCST>0.00</vBCST>' +
        '<pICMSST>0.00</pICMSST><vICMSST>0.00</vICMSST>' +
        '<pCredSN>0.00</pCredSN><vCredICMSSN>0.00</vCredICMSSN>' +
        '</ICMSSN900>';
      exit;
    end;
    // TRIBUTACAO NORMAL PELO SIMPLES NACIONAL
    Result := '<ICMS><ICMSSN102><orig>' + _ORIGE +
      '</orig><CSOSN>102</CSOSN></ICMSSN102></ICMS>';
    exit;
  end;

  // EXPORTAÇÃO - CST = 41
  IF Contido(LeftStr(cod_OP, 1), '4-7') then
  begin
    Result := '<ICMS><ICMS40><orig>' + _ORIGE +
      '</orig><CST>41</CST></ICMS40></ICMS>';
    exit;
  end;

  // CFOP SUBSTITUICAO TRIBUTARIA
  IF CSTICM_CFOP = 'S' then
  begin
    if usaNFe4ouMaior then begin
      Result := '<ICMS><ICMS60><orig>' + _ORIGE + '</orig><CST>60</CST>' +
      '</ICMS60></ICMS>';
    end
    else begin
      Result := '<ICMS><ICMS60><orig>' + _ORIGE + '</orig><CST>60</CST>' +
      '<vBCSTRet>' + FORMAT_NUM(mat.p_compra) + '</vBCSTRet>' +
      '<vICMSSTRet>' + FORMAT_NUM(arredonda(mat.p_compra * 0.16, 2)) + '</vICMSSTRet>' +
      '</ICMS60></ICMS>';
    end;
  end;

  // CFOP ISENTO
  IF CSTICM_CFOP = 'I' then
  begin
    Result := '<ICMS><ICMS40><orig>' + _ORIGE +
      '</orig><CST>40</CST></ICMS40></ICMS>';
    exit;
  end;

  // CFOP NAO SE APLICA ICM
  IF CSTICM_CFOP = 'N' then
  begin
    Result := '<ICMS><ICMS40><orig>' + _ORIGE +
      '</orig><CST>41</CST></ICMS40></ICMS>';
    exit;
  end;

  // CFOP TRIBUTADO COM REDUCAO NA BASE DE CALCULO
  IF CSTICM_CFOP = 'R' then
  begin
    // SE EXISTE REDUCAO NA BASE DE CALCULO PELO CFOP, ENTAO REDUCAO E DE 100%
    MAT.Reducao := 0;
    MAT.PercICMS := 0;
    MAT.VlrICMS := 0;
    BASE_ICM := tot;
    VLR_ICM := 0;
    TOTICM := VLR_ICM;
    TOT_BASEICM := BASE_ICM;

    Result := '<ICMS><ICMS20><orig>' + _ORIGE +
      '</orig><CST>20</CST><modBC>3</modBC>' + '<pRedBC>' +
      Format_num(MAT.Reducao) + '</pRedBC>' + '<vBC>' + Format_num(MAT.DescICMS)
      + '</vBC>' + '<pICMS>' + Format_num(MAT.PercICMS) + '</pICMS>' + '<vICMS>'
      + Format_num(MAT.VlrICMS) + '</vICMS></ICMS20></ICMS>';
    exit;
  end;

  // TRIBUTACAO DO ICMS EM REGIME NORMAL
  // PRODUTO SUBSTITUICAO TRIBUTARIA
  IF mat.CodAliq = 10 then
  begin
    if usaNFe4ouMaior then begin
      Result := '<ICMS><ICMS60><orig>' + _ORIGE + '</orig><CST>60</CST>' +
      '</ICMS60></ICMS>';
    end
    else begin
      Result := '<ICMS><ICMS60><orig>' + _ORIGE + '</orig><CST>60</CST>' +
      '<vBCSTRet>' + FORMAT_NUM(mat.p_compra) + '</vBCSTRet>' +
      '<vICMSSTRet>' + FORMAT_NUM(arredonda(mat.p_compra * 0.16, 2)) + '</vICMSSTRet>' +
      '</ICMS60></ICMS>';
    end;

    //ShowMessage(Result);
    exit;
  end;


  // PRODUTO ISENTO
  IF MAT.codAliq = 11 then
  begin
    Result := '<ICMS><ICMS40><orig>' + _ORIGE +
      '</orig><CST>40</CST></ICMS40></ICMS>';
    exit;
  end;

  // PRODUTO NAO SE APLICA ICM
  IF MAT.codAliq = 12 then
  begin
    Result := '<ICMS><ICMS40><orig>' + _ORIGE +
      '</orig><CST>41</CST></ICMS40></ICMS>';
    exit;
  end;

  // PRODUTO TRIBUTADO COM REDUCAO NA BASE DE CALCULO
  IF MAT.Reducao <> 0 then
  begin
    BASE_ICM := Arredonda(tot - (tot * MAT.Reducao / 100), 2);
    VLR_ICM := Arredonda(BASE_ICM * MAT.PercICMS / 100, 2);
    TOTICM := TOTICM + VLR_ICM;
    TOT_BASEICM := TOT_BASEICM + BASE_ICM;
    Result := '<ICMS><ICMS20><orig>' + _ORIGE +
      '</orig><CST>20</CST><modBC>3</modBC>' + '<pRedBC>' +
      Format_num(MAT.Reducao) + '</pRedBC>' + '<vBC>' + Format_num(BASE_ICM) +
      '</vBC>' + '<pICMS>' + Format_num(MAT.PercICMS) + '</pICMS>' + '<vICMS>' +
      Format_num(VLR_ICM) + '</vICMS></ICMS20></ICMS>';
    exit;
  end;

  // TRIBUTADO INTEGRAL
  BASE_ICM := tot;
  VLR_ICM := Arredonda(BASE_ICM * MAT.PercICMS / 100, 2);
  TOTICM := TOTICM + VLR_ICM;
  TOT_BASEICM := TOT_BASEICM + BASE_ICM;
  Result := '<ICMS><ICMS00><orig>' + _ORIGE +
    '</orig><CST>00</CST><modBC>3</modBC>' + '<vBC>' + Format_num(BASE_ICM) +
    '</vBC>' + '<pICMS>' + Format_num(MAT.PercICMS) + '</pICMS>' + '<vICMS>' +
    Format_num(VLR_ICM) + '</vICMS></ICMS00></ICMS>';
end;

FUNCTION NODO_PISCOFINS1(var item1: Item_venda; CSTPIS_CFOP: string): string;
VAR
  COF_ALIQ, PIS_ALIQ: string;
  tot, VLR_COFINS, VLR_PIS: currency;
begin
  tot := item1.total - item1.desconto;
  // SE FOR OPTANTE DO SIMPLES NACIONAL, NAO USA TAG PIS/COFINS
  IF (Contido(pgerais.Values['10'], '1-2')) and (item1.pis = '') then
  begin
    Result := '<PIS><PISAliq><CST>01</CST><vBC>0.00</vBC><pPIS>0.00</pPIS>' +
      '<vPIS>0.00</vPIS></PISAliq></PIS>' +
      '<COFINS><COFINSAliq><CST>01</CST><vBC>0.00</vBC>' +
      '<pCOFINS>0.00</pCOFINS><vCOFINS>0.00</vCOFINS></COFINSAliq></COFINS>';
    exit;
  end;

  { PIS_ALIQ := '<PISAliq><CST>02</CST><vBC>' + FORMAT_NUM(TOT) + '</vBC><pPIS>0.00</pPIS>' +
    '<vPIS>0.00</vPIS></PISAliq>';
    COF_ALIQ := '<COFINSAliq><CST>02</CST><vBC>' + FORMAT_NUM(TOT) + '</vBC>' +
    '<pCOFINS>0.00</pCOFINS><vCOFINS>0.00</vCOFINS></COFINSAliq>'; }

  PIS_ALIQ := '<PISAliq><CST>02</CST><vBC>0.00</vBC><pPIS>0.00</pPIS>' +
    '<vPIS>0.00</vPIS></PISAliq>';
  COF_ALIQ := '<COFINSAliq><CST>02</CST><vBC>0.00</vBC>' +
    '<pCOFINS>0.00</pCOFINS><vCOFINS>0.00</vCOFINS></COFINSAliq>';

  // SE O CFOP E ISENTO DE PIS/COFINS
  IF CSTPIS_CFOP = 'I' then
  begin
    PIS_NT := PIS_NT + tot;
    Result := '<PIS>' + PIS_ALIQ + '<PISNT><CST>07</CST></PISNT></PIS>' +
      '<COFINS>' + COF_ALIQ + '<COFINSNT><CST>07</CST></COFINSNT></COFINS>';
    exit;
  end;

  // SE O CFOP NAO E TRIBUTADO POR PIS/COFINS
  IF CSTPIS_CFOP = 'N' then
  begin
    PIS_NT := PIS_NT + tot;
    Result := '<PIS>' + PIS_ALIQ + '<PISNT><CST>06</CST></PISNT></PIS>' +
      '<COFINS>' + COF_ALIQ + '<COFINSNT><CST>06</CST></COFINSNT></COFINS>';
    exit;
  end;

  // SE O CFOP TEM  A ALIQ RED. A ZERO DE PIS/COFINS
  IF CSTPIS_CFOP = 'R' then
  begin
    PIS_NT := PIS_NT + tot;
    Result := '<PIS><PISAliq><CST>02</CST><vBC>0.00</vBC><pPIS>0.00</pPIS>' +
      '<vPIS>0.00</vPIS></PISAliq></PIS>' +
      '<COFINS><COFINSAliq><CST>02</CST><vBC>0.00</vBC>' +
      '<pCOFINS>0.00</pCOFINS><vCOFINS>0.00</vCOFINS></COFINSAliq></COFINS>';
    exit;
  end;

  // SE O CFOP NAO E TRIBUTADO POR PIS/COFINS
  IF CSTPIS_CFOP = 'M' then
  begin
    PIS_NT := PIS_NT + tot;
    Result := '<PIS>' + '<PISNT><CST>04</CST></PISNT></PIS>' + '<COFINS>' +
      '<COFINSNT><CST>04</CST></COFINSNT></COFINS>';
  end;

  // SE O CFOP E ISENTO DE PIS/COFINS
  IF CSTPIS_CFOP = 'X' then
  begin
    PIS_NT := PIS_NT + tot;
    Result := '<PIS><PISNT><CST>08</CST></PISNT></PIS>' +
      '<COFINS><COFINSNT><CST>08</CST></COFINSNT></COFINS>';
  end;

  // SE O CFOP TEM ALIQ DIFERENCIADA
  IF CSTPIS_CFOP = 'D' then
  begin
    PIS_NT := PIS_NT + tot;
    Result := '<PIS><PISAliq><CST>02</CST><vBC>0.00</vBC><pPIS>0.00</pPIS>' +
      '<vPIS>0.00</vPIS></PISAliq></PIS>' +
      '<COFINS><COFINSAliq><CST>02</CST><vBC>0.00</vBC>' +
      '<pCOFINS>0.00</pCOFINS><vCOFINS>0.00</vCOFINS></COFINSAliq></COFINS>';
  end;

  // CFOP - SE JA RECOLHEU PIS/COFINS POR SUBSTITUICAO TRIBUTARIA
  IF CSTPIS_CFOP = 'S' then
  begin
    VLR_PIS := Arredonda(item1.Total_Preco_Compra * TRIB_ALIQ_PIS / 100, 2);
    VLR_COFINS := Arredonda(item1.Total_Preco_Compra * TRIB_ALIQ_COFINS
      / 100, 2);
    PIS_ST := PIS_ST + VLR_PIS;
    COFINS_ST := COFINS_ST + VLR_COFINS;
    Result := '<PIS>' + PIS_ALIQ + '<PISST><vBC>' +
      Format_num(item1.Total_Preco_Compra) + '</vBC>' + '<pPIS>' +
      Format_num(TRIB_ALIQ_PIS) + '</pPIS>' + '<vPIS>' + Format_num(VLR_PIS) +
      '</vPIS></PISST></PIS>' + '<COFINS>' + COF_ALIQ + '<COFINSST><vBC>' +
      Format_num(item1.Total_Preco_Compra) + '</vBC>' + '<pCOFINS>' +
      Format_num(TRIB_ALIQ_COFINS) + '</pCOFINS>' + '<vCOFINS>' +
      Format_num(VLR_COFINS) + '</vCOFINS></COFINSST></COFINS>';
    exit;
  end;

  // ShowMessage('Pis='+item1.Pis + #13 + 'cod_ispis=' + item1.codISPIS);

  // SE O PRODUTO E ISENTO DE PIS/COFINS
  IF ((item1.pis = 'I') and (length(strnum(item1.codISPIS)) = 3)) then
  begin
    PIS_NT := PIS_NT + tot;
    Result := '<PIS>' + '<PISNT><CST>07</CST></PISNT></PIS>' + '<COFINS>' +
      '<COFINSNT><CST>07</CST></COFINSNT></COFINS>';
    exit;
  end;

  // SE O PRODUTO NAO E TRIBUTADO POR PIS/COFINS
  IF ((item1.pis = 'N') and (length(strnum(item1.codISPIS)) = 3)) then
  begin
    PIS_NT := PIS_NT + tot;
    Result := '<PIS>' + '<PISNT><CST>06</CST></PISNT></PIS>' + '<COFINS>' +
      '<COFINSNT><CST>06</CST></COFINSNT></COFINS>';
    exit;
  end;

  // SE O PRODUTO NAO E TRIBUTADO POR PIS/COFINS
  IF ((item1.pis = 'M') and (length(strnum(item1.codISPIS)) = 3)) then
  begin
    PIS_NT := PIS_NT + tot;
    Result := '<PIS>' + '<PISNT><CST>04</CST></PISNT></PIS>' + '<COFINS>' +
      '<COFINSNT><CST>04</CST></COFINSNT></COFINS>';
    exit;
  end;

  // SE O PRODUTO TEM  A ALIQ RED. A ZERO DE PIS/COFINS
  IF ((item1.pis = 'R') and (length(strnum(item1.codISPIS)) = 3)) then
  begin
    PIS_NT := PIS_NT + tot;
    Result := '<PIS>' + '<PISNT><CST>06</CST></PISNT></PIS>' + '<COFINS>' +
      '<COFINSNT><CST>06</CST></COFINSNT></COFINS>';
    exit;
  end;

  IF ((item1.pis = 'X') and (length(strnum(item1.codISPIS)) = 3)) then
  begin
    PIS_NT := PIS_NT + tot;
    Result := '<PIS>' + '<PISNT><CST>08</CST></PISNT></PIS>' + '<COFINS>' +
      '<COFINSNT><CST>08</CST></COFINSNT></COFINS>';
    exit;
  end;

  // PRODUTO - SE JA RECOLHEU PIS/COFINS POR SUBSTITUICAO TRIBUTARIA
  IF ((item1.pis = 'S') and (length(strnum(item1.codISPIS)) = 3)) then
  begin
    VLR_PIS := Arredonda(item1.Total_Preco_Compra * TRIB_ALIQ_PIS / 100, 2);
    VLR_COFINS := Arredonda(item1.Total_Preco_Compra * TRIB_ALIQ_COFINS
      / 100, 2);
    PIS_ST := PIS_ST + VLR_PIS;
    COFINS_ST := COFINS_ST + VLR_COFINS;

    Result := '<PIS>' + PIS_ALIQ + '<PISST><vBC>' +
      Format_num(item1.Total_Preco_Compra) + '</vBC>' + '<pPIS>' +
      Format_num(TRIB_ALIQ_PIS) + '</pPIS>' + '<vPIS>' + Format_num(VLR_PIS) +
      '</vPIS></PISST></PIS>' + '<COFINS>' + COF_ALIQ + '<COFINSST><vBC>' +
      Format_num(item1.Total_Preco_Compra) + '</vBC>' + '<pCOFINS>' +
      Format_num(TRIB_ALIQ_COFINS) + '</pCOFINS>' + '<vCOFINS>' +
      Format_num(VLR_COFINS) + '</vCOFINS></COFINSST></COFINS>';
    exit;
  end;

  try
    TRIB_ALIQ_PIS := StrToCurr(pgerais.Values['11']);
    TRIB_ALIQ_COFINS := StrToCurr(pgerais.Values['12'])
  except
    TRIB_ALIQ_COFINS := 0;
    TRIB_ALIQ_COFINS := 0;
  end;
  // REGIME NORMAL - RECOLHIMENTO DE PIS E COFINS
  // CALCULA PIS/COFINS SOBRE O VALOR DO PRODUTO - DESCONTO
  VLR_PIS := Arredonda(tot * TRIB_ALIQ_PIS / 100, 2);
  TOT_PIS := TOT_PIS + VLR_PIS;
  VLR_COFINS := Arredonda(tot * TRIB_ALIQ_COFINS / 100, 2);
  TOT_COFINS := TOT_COFINS + VLR_COFINS;
  Result := '<PIS><PISAliq><CST>01</CST><vBC>' + Format_num(tot) + '</vBC>' +
    '<pPIS>' + Format_num(TRIB_ALIQ_PIS) + '</pPIS>' + '<vPIS>' +
    Format_num(VLR_PIS) + '</vPIS></PISAliq></PIS>' +
    '<COFINS><COFINSAliq><CST>01</CST><vBC>' + Format_num(tot) + '</vBC>' +
    '<pCOFINS>' + Format_num(TRIB_ALIQ_COFINS) + '</pCOFINS>' + '<vCOFINS>' +
    Format_num(VLR_COFINS) + '</vCOFINS></COFINSAliq></COFINS>';
end;

procedure GravarTexto(SalvarComo, Texto: String);
var
  txt: TextFile;
begin
  try
    AssignFile(txt, SalvarComo);
    Rewrite(txt);
    Append(txt);
    Writeln(txt, Texto);
  finally
    CloseFile(txt);
  end;
end;

FUNCTION SUB_NODO_END(ENDE: String): string;
begin
  Result := '<xLgr>' + trim(RetornaEndeRua(ENDE)) + '</xLgr><nro>' +
    trim(RetornaNumero(ENDE)) + '</nro>';
end;

function RetornaEndeRua(const entra: string): string;
begin
  Result := '';
  if Contido(',', entra) then
  begin
    Result := copy(entra, 1, PosFinal(',', entra) - 1);
  end
  else
  begin
    Result := copy(entra, 1, PosFinal(' ', entra) - 1);
  end;
end;

function RetornaNumero(const entra: string): string;
begin
  Result := '';
  if Contido(',', entra) then
  begin
    Result := copy(entra, PosFinal(',', entra) + 1, length(entra));
  end
  else
  begin
    Result := copy(entra, PosFinal(' ', entra) + 1, length(entra));
  end;

  Result := trim(strnum(Result));
  if Result = '' then
    Result := '100';
end;

function NODO_TRANP(): String;
begin
  Result := '<transp><modFrete>9</modFrete></transp>';
end;

FUNCTION NODO_PAG(): STRING;
begin
  if usaNFe4ouMaior then begin
    Result := '<pag>'+
    '<detPag>'+
    '<tpag>'+venda.codFormaNFCE+'</tpag>'+
    '<vpag>' + Format_num(totalNota - TOTDESC) +  '</vpag>' +
    '</detPag>' +
    '</pag>';
    exit;
  end;

  Result := '<pag>' + '<tpag>' + venda.codFormaNFCE + '</tpag>' + '<vpag>' +
    FormatCurr('0.00', totalNota - TOTDESC) + '</vpag>' + '</pag>';
end;

function getDataHoraAtualXML(comFuso: boolean = true): String;
var
  Data: TDateTime;
begin
  Data := now;

  if chaveRecria <> '' then
  begin
    Data := CodificaDataPelaChave(chaveRecria);
  end;

  Result := FormatDateTime('yyy-mm-dd', Data) + 'T' + FormatDateTime('hh:mm:ss',
    Data) + IfThen(comFuso, '-04:00', '');
end;

FUNCTION NODO_DEST(tipo, CPF, CNPJ, nome, ENDE, BAIRRO, COD_MUN, NOM_MUN, UF,
  CEP, FONE, IE, CODMUN_EMI: String): string;
var
  CPF_CNPJ, indIEDest, idEstrangeiro, tmp, codPaisDest: string;
  invalido: integer;
  ok: boolean;
begin
  ERRO_dados := '';
  tmp := IE;
  codPaisDest := '1058';
  invalido := 0;
  tipo := trim(tipo);
  CPF := strnum(CPF);

  if dadosDest.Values['estx'] = '1' then
  begin
    { tmp := '<enderDest>' + SUB_NODO_END(ENDE) + '<xBairro>' + removeCarateresEspeciais(BAIRRO) +
      '</xBairro><cMun>' + COD_MUN + '</cMun><xMun>' + removeCarateresEspeciais(NOM_MUN) + '</xMun>' +
      '<UF>'  + UF + '</UF><CEP>' + CEP + '</CEP><cPais>'+ dadosDest.Values['codpais'] +'</cPais>' +
      '<xPais>'+dadosDest.Values['pais']+'</xPais><fone>' + IfThen(FONE = '0', '', FONE) + '</fone></enderDest>'; }

    CPF_CNPJ := '<CPF></CPF><idEstrangeiro>' + CPF + '</idEstrangeiro>';
    Result := '<dest>' + CPF_CNPJ + '<xNome>' + removeCarateresEspeciais(nome) +
      '</xNome>' + tmp + '<indIEDest>9</indIEDest></dest>';
    exit;
  end;

  if length(strnum(CPF)) <> 11 then
  begin
    Result := '';
    exit;
  end;

  IF length(strnum(CPF)) = 11 then
  begin
    ok := testacpf(CPF);
    CPF_CNPJ := '<CPF>' + CPF + '</CPF>';
  end;

  // SE O CODIGO DO MUNICIPIO ESTA EM BRANCO, USA O CODIGO DO MUNICIPIO DO EMITENTE
  COD_MUN := dadosEmitente.Values['cod_mun'];
  UF := dadosEmitente.Values['est'];
  CEP := dadosEmitente.Values['cep'];
  NOM_MUN := dadosEmitente.Values['cid'];

  IF NOT ok then
  begin
    ERRO_dados := ' CPF/CNPJ do Destinatário Inválido ' + #13;
    invalido := invalido + 1;
  end;

  { INVALIDO := INVALIDO + CAMPO_VAZIO(ENDE);
    INVALIDO := INVALIDO + CAMPO_VAZIO(BAIRRO);
    INVALIDO := INVALIDO + CAMPO_VAZIO(COD_MUN);
    INVALIDO := INVALIDO + CAMPO_VAZIO(NOM_MUN);
    INVALIDO := INVALIDO + CAMPO_VAZIO(UF);
    INVALIDO := INVALIDO + CAMPO_VAZIO(CEP); }
  IF invalido <> 0 then
    ERRO_dados := ' Dados do Cliente Incompletos ' + #13;

  indIEDest := '2';
  if IE = '0' then
    IE := '';
  if IE = '' then
    indIEDest := '2';
  if length(strnum(CPF_CNPJ)) = 11 then
  begin
    indIEDest := '9';
    IE := '';
  end;

  if length(strnum(CPF_CNPJ)) = 14 then
  begin
    Result := '';
    exit;
    // indIEDest := '1';
    if IE <> '' then
    begin
      indIEDest := '1';
    end;
  end;

  tmp := '';

  if invalido > 0 then
  begin
    Result := '';
    exit;
  end;

  if ((length(strnum(FONE)) < 6) or (length(strnum(FONE)) > 14)) then
  begin
    FONE := '';
  end;

  if ((ENDE <> '') and (BAIRRO <> '')) then
  begin
    tmp := '<enderDest>' + SUB_NODO_END(ENDE) + '<xBairro>' +
      removeCarateresEspeciais(BAIRRO) + '</xBairro><cMun>' + COD_MUN +
      '</cMun><xMun>' + removeCarateresEspeciais(NOM_MUN) + '</xMun>' + '<UF>' +
      UF + '</UF><CEP>' + CEP + '</CEP><cPais>' + codPaisDest + '</cPais>' +
      '<xPais>BRASIL</xPais><fone>' + IfThen(FONE = '0', '', FONE) +
      '</fone></enderDest>';
  end;

  Result := '<dest>' + CPF_CNPJ + '<xNome>' + removeCarateresEspeciais(nome) +
    '</xNome>' + tmp + '<indIEDest>9</indIEDest></dest>';

  { Result := '<dest>' + CPF_CNPJ + '<xNome>' + trim(NOME) + '</xNome><enderDest>' +
    SUB_NODO_END(ENDE) + '<xBairro>' + BAIRRO +
    '</xBairro><cMun>' + COD_MUN + '</cMun><xMun>' + NOM_MUN + '</xMun>' +
    '<UF>'  + UF + '</UF><CEP>' + CEP + '</CEP><cPais>'+ codPaisDest +'</cPais>' +
    '<xPais>BRASIL</xPais><fone>' + IfThen(FONE = '0', '', FONE) + '</fone></enderDest>' +
    '<indIEDest>'+ indIEDest +'</indIEDest>'+ IfThen(indIEDest =  '1', '<IE>' + IE + '</IE>', '') + '</dest>'; }
end;

Function testacpf(CPF: string): boolean;
var
  i: integer;
  Want: Char;
  Wvalid: boolean;
  Wdigit1, Wdigit2: integer;
begin
  CPF := strnum(CPF);
  Result := false;
  if length(CPF) <> 11 then
    exit;

  Wdigit1 := 0;
  Wdigit2 := 0;
  Want := CPF[1];
  // variavel para testar se o cpf é repetido como 111.111.111-11
  Delete(CPF, ansipos('.', CPF), 1); // retira as mascaras se houver
  Delete(CPF, ansipos('.', CPF), 1);
  Delete(CPF, ansipos('-', CPF), 1);

  // testar se o cpf é repetido como 111.111.111-11
  for i := 1 to length(CPF) do
  begin
    if CPF[i] <> Want then
    begin
      Wvalid := true;
      // se o cpf possui um digito diferente ele passou no primeiro teste
      break
    end;
  end;
  // se o cpf é composto por numeros repetido retorna falso
  if not Wvalid then
  begin
    Result := false;
    exit;
  end;

  // executa o calculo para o primeiro verificador
  for i := 1 to 9 do
  begin
    Wdigit1 := Wdigit1 + (StrToInt(CPF[10 - i]) * (i + 1));
  end;
  Wdigit1 := ((11 - (Wdigit1 mod 11)) mod 11) mod 10;
  { formula do primeiro verificador
    soma=1°*2+2°*3+3°*4.. até 9°*10
    digito1 = 11 - soma mod 11
    se digito > 10 digito1 =0
  }

  // verifica se o 1° digito confere
  if IntToStr(Wdigit1) <> CPF[10] then
  begin
    Result := false;
    exit;
  end;

  for i := 1 to 10 do
  begin
    Wdigit2 := Wdigit2 + (StrToInt(CPF[11 - i]) * (i + 1));
  end;
  Wdigit2 := ((11 - (Wdigit2 mod 11)) mod 11) mod 10;
  { formula do segundo verificador
    soma=1°*2+2°*3+3°*4.. até 10°*11
    digito1 = 11 - soma mod 11
    se digito > 10 digito1 =0
  }

  // confere o 2° digito verificador
  if IntToStr(Wdigit2) <> CPF[11] then
  begin
    Result := false;
    exit;
  end;

  // se chegar até aqui o cpf é valido
  Result := true;
end;

procedure criaXMLs(nota1, nnf, chav4: String);
var
  vend1: Tvenda;
  xml: String;
  chavb: TChaveDetalhes;
begin
  // DecimalSeparator  := '.';
  // ThousandSeparator := '.';

  chaveRecria := chav4;
  cliente := '0';
  inicializaVariaveis();
  chavb := TChaveDetalhes.Create;
  vend1 := Tvenda.Create;

  chavb.chave := chav4;
  vend1.chave := chav4;
  chavb.codNF := StrToIntDef(nota1, 0);
  vend1.nota := StrToIntDef(nota1, 0);
  vend1.adic := 'OFF';
  vend1.cliente := 0;

  Ler_dados_pela_chave(chavb);

  if chavb.tpEmis = 9 then
  begin
    contOFFLINE := true;
    ACBrNFe.Configuracoes.Geral.FormaEmissao := teOffLine;
  end
  else
  begin
    contOFFLINE := false;
    ACBrNFe.Configuracoes.Geral.FormaEmissao := teNormal;
  end;
  // if chavb.tpemis = 9 then ACBrNFe.Configuracoes.Geral.FormaEmissao := teOffLine
  // else ACBrNFe.Configuracoes.Geral.FormaEmissao := teNormal;

  if nnf = '' then
    nnf := IntToStr(chavb.nnf);
  nota1 := IntToStr(vend1.nota);

  xml := GerarNFCeTexto(nota1, cliente, nnf);

  //ShowMessage(buscaPastaNFCe(CHAVENF, false) + CHAVENF + '-nfe.xml');
  GravarTexto(buscaPastaNFCe(CHAVENF, false) + CHAVENF + '-nfe.xml', xml);
  xml := '';

  ACBrNFe.NotasFiscais.Clear;
  ACBrNFe.NotasFiscais.LoadFromFile(buscaPastaNFCe(CHAVENF) + CHAVENF +
    '-nfe.xml');
  ACBrNFe.NotasFiscais[0].GravarXML(CHAVENF + '-nfe.xml',
    buscaPastaNFCe(CHAVENF, false));

  { ACBrNFe.NotasFiscais.Clear;
    ACBrNFe.NotasFiscais.LoadFromFile(pastaControlW + '\NFCe\EMIT\' + chaveNF + '-nfe.xml'); }

  vend1.cliente := 0;
  vend1.chave := CHAVENF;

  chavb.Free;
  vend1.Free;
  LimpaVariaveis();

  // DecimalSeparator  := ',';
  // ThousandSeparator := ',';
end;

procedure criaXMLsComDATA(nota1, nnf, chav4, Data: String);
var
  vend1: Tvenda;
  xml: String;
  chavb: TChaveDetalhes;
begin
  cliente := '0';
  inicializaVariaveis();
  chavb := TChaveDetalhes.Create;
  vend1 := Tvenda.Create;

  chavb.chave := chav4;
  vend1.chave := chav4;
  chavb.codNF := StrToIntDef(nota1, 0);
  vend1.nota := StrToIntDef(nota1, 0);
  vend1.adic := 'OFF';
  vend1.cliente := 0;

  Ler_dados_pela_chave(chavb);

  if nnf = '' then
    nnf := IntToStr(chavb.nnf);

  nota1 := IntToStr(vend1.nota);

  // ShowMessage(nnf);
  xml := GerarNFCeTexto(nota1, cliente, nnf);
  GravarTexto(buscaPastaNFCe(CHAVENF, false) + CHAVENF + '-nfe.xml', xml);
  xml := '';

  vend1.cliente := 0;
  vend1.chave := CHAVENF;
  // insereNotaBD1(vend1);

  LimpaVariaveis();
end;

procedure LimpaVariaveis();
begin
  lista.Free;
  dadosEmitente.Free;
  dadosDest.Free;
  ACBrNFe.NotasFiscais.Clear;
end;

function verificaExisteNFCe(const nota2: String;
  imprime: boolean = false): string;
var
  arq: TStringList;
  csta: String;
begin
  Result := '';

  query1.Close;
  query1.SQL.text :=
    'select chave from nfce where substring(chave from 36 for 8) = :nota';
  query1.ParamByName('nota').AsString := CompletaOuRepete('', nota2, '0', 8);
  query1.Open;

  if query1.IsEmpty then
  begin
    query1.Close;
    exit;
  end;

  arq := TStringList.Create;
  Result := '';
  while query1.Eof do
  begin
    if FileExists(buscaPastaNFCe(query1.fieldbyname('chave').AsString) +
      query1.fieldbyname('chave').AsString + '-nfe.xml') then
    begin
      Result := query1.fieldbyname('chave').AsString;
      arq.LoadFromFile(buscaPastaNFCe(query1.fieldbyname('chave').AsString) +
        query1.fieldbyname('chave').AsString + '-nfe.xml');
      csta := Le_Nodo('cStat', arq.text);
      if Contido(trim(csta), '100-150') then
      begin
        Result := query1.fieldbyname('chave').AsString;
      end;
    end;

    query1.Next;
  end;

  Result := query1.fieldbyname('chave').AsString;
  arq.Free;
end;

procedure Ler_dados_pela_chave(var chav1: TChaveDetalhes);
begin
  if chav1.chave = '' then
  begin
    chav1.nnf := 0;
    exit;
  end;

  chav1.nnf := StrToIntDef(copy(chav1.chave, 26, 9), 0);
  chav1.CodUF := StrToIntDef(copy(chav1.chave, 1, 2), 0);
  chav1.anoMesYYMM := copy(chav1.chave, 3, 4);
  chav1.CNPJ := copy(chav1.chave, 7, 14);
  chav1.modelo := StrToIntDef(copy(chav1.chave, 21, 2), 0);
  chav1.serie := StrToIntDef(copy(chav1.chave, 23, 3), 0);
  chav1.nnf := StrToIntDef(copy(chav1.chave, 26, 9), 0);
  chav1.tpEmis := StrToIntDef(copy(chav1.chave, 35, 1), 0);
  chav1.codNF := StrToIntDef(copy(chav1.chave, 37, 7), 0);
end;

function Incrementa_Generator(Gen_name: string;
  valor_incremento: integer): string;
begin
  query1.Close;
  query1.SQL.Clear;
  query1.SQL.Add('select gen_id(' + Gen_name + ',' + IntToStr(valor_incremento)
    + ') as venda from rdb$database');
  query1.Open;

  Result := '';
  Result := query1.fieldbyname('venda').AsString;

  query1.Close;
end;

procedure trataDuplicidade(erroDup: String; msg: boolean; nfe: boolean = false;
  modificaGenerator: boolean = true);
var
  chavb: TChaveDetalhes;
  stat: String;
  vend: Tvenda;
begin
  if msg then
  begin
    MessageDlg('Ocorreu Um Erro de Duplicidade e o Sistem irá recuperar a NFe!',
      mtWarning, [mbOK], 1);
  end;

  chavb := TChaveDetalhes.Create;
  chavb.chave := buscaChaveErroDeDuplicidade(erroDup);
  Ler_dados_pela_chave(chavb);

  if not FileExists(buscaPastaNFCe(chavb.chave) + chavb.chave + '-nfe.xml') then
  begin
    criaXMLs(IntToStr(chavb.codNF), '', chavb.chave);
  end;

  // reStartGenerator('nfce', chavb.nnf + 1);

  ACBrNFe.NotasFiscais.Clear;

  if not FileExists(buscaPastaNFCe(chavb.chave) + chavb.chave + '-nfe.xml') then
  begin
    exit;
  end;

  ACBrNFe.NotasFiscais.LoadFromFile(buscaPastaNFCe(chavb.chave) + chavb.chave +
    '-nfe.xml');

  stat := Le_Nodo('cStat', ACBrNFe.NotasFiscais[0].xml);
  if stat = '' then
  begin
    if acbrNFeConsultar(25) = false then
    begin
      exit;
    end;
    stat := IntToStr(ACBrNFe.NotasFiscais[0].nfe.procNFe.cStat);
  end;

  vend := Tvenda.Create;
  vend.adic := '';
  vend.nota := chavb.codNF;
  vend.chave := chavb.chave;
  if stat <> '100' then
    vend.adic := 'OFF';

  insereNotaBD1(vend);
  if msg then
    imprimirNfce;
  chavb.Free;
  vend.Free;
end;

procedure trataDuplicidade1(erroDup: String; msg: boolean; nfe: boolean = false;
  modificaGenerator: boolean = true; chaveAtual: String = '');
var
  chavb: TChaveDetalhes;
  stat, chavt: String;
  vend: Tvenda;
  arq: TStringList;
begin
  { if msg then
    begin
    MessageDlg('Ocorreu Um Erro de Duplicidade e o Sistem irá recuperar a NFe!', mtWarning, [mbOK], 1);
    end; }

  chavb := TChaveDetalhes.Create;
  chavb.chave := buscaChaveErroDeDuplicidade(erroDup);
  chavt := chavb.chave;
  Ler_dados_pela_chave(chavb);


  try
    RICHEDT.Lines.Add('');
    RICHEDT.Lines.Add('chaveAtual=' + chaveAtual);
    RICHEDT.Lines.Add('chavt=     ' + chavt);
    RICHEDT.Lines.Add('');
  except
  end;


  {if (chaveAtual <> '') and (chaveAtual <> chavt) and
    (length(strnum(chavt)) = 44) then
  begin
    query1.Close;
    query1.SQL.text := 'delete from nfce where chave = :chave';
    query1.ParamByName('chave').AsString := chaveAtual;
    try
      query1.ExecSQL;
      query1.Transaction.Commit;
    except
    end;

    query1.Close;
    query1.SQL.text :=
      'insert into nfce(chave, exportado, nota, cliente, adic, data) values' +
      '(:chave, :exportado, :nota, :cliente, :adic, :data)';
    query1.ParamByName('chave').AsString := chavt;
    query1.ParamByName('exportado').AsInteger := 1;
    query1.ParamByName('nota').AsInteger := StrToIntDef(copy(chavt, 37, 7), 0);;
    query1.ParamByName('cliente').AsInteger := 0;
    query1.ParamByName('adic').AsString := '';
    query1.ParamByName('data').AsDate := now;
    //query1.ParamByName('USUARIO').AsInteger := USUARIO1;

    try
      query1.ExecSQL;
      query1.Transaction.Commit;
    except
    end;
  end;   }

  if not FileExists(buscaPastaNFCe(chavt) + chavt + '-nfe.xml') then
  begin
    query1.Close;
    query1.SQL.text :=
      'update nfce set adic = '''', exportado = 1 where chave = :chave';
    query1.ParamByName('chave').AsString := chavt;
    try
      query1.ExecSQL;
      query1.Transaction.Commit;
    except
    end;

    // MessageDlg('saiu: ' + pastaControlW+ 'nfce\emit\' + chavb.chave + '-nfe.xml', mtInformation, [mbOK], 1);
    gravaERRO_LOG1('', buscaPastaNFCe(chavb.chave) + chavb.chave + '-nfe.xml  Não Existe!', 'Nova Criação de XML');
    //exit;
  end;

  if not FileExists(buscaPastaNFCe(chavb.chave) + chavb.chave + '-nfe.xml') then
  begin
    //criaXMLs(IntToStr(chavb.codNF), '', chavb.chave);
  end;

  if modificaGenerator then
  begin
    //if chavb.nnf = StrToInt(Incrementa_Generator('nfce', 0)) then
      //Incrementa_Generator('nfce', 1);
  end;

  arq := TStringList.Create;
  arq.LoadFromFile(buscaPastaNFCe(chavb.chave) + chavb.chave + '-nfe.xml');
  stat := Le_Nodo('cStat', arq.text);
  if stat = '' then
  begin
    try
      ACBrNFe.NotasFiscais.Clear;
      ACBrNFe.NotasFiscais.LoadFromFile(buscaPastaNFCe(chavb.chave) +
        chavb.chave + '-nfe.xml', false);

      if acbrNFeConsultar(25) = false then
      begin
        raise Exception.Create(ERRO_dados);
      end;
      stat := IntToStr(ACBrNFe.NotasFiscais[0].nfe.procNFe.cStat);

      try
        RICHEDT.Lines.Add('');
        RICHEDT.Lines.Add('******* Consultando ' + chavb.chave + '  cstat: ' + stat + #13  + ACBrNFe.WebServices.Consulta.NFeChave + #13 + #13);
        RICHEDT.Lines.Add('');

       { if stat = '613' then begin
          chavb.chave := ACBrNFe.WebServices.Consulta.NFeChave;
        end;}

      except
      end;



      if stat = '110' then begin
        query1.Close;
        query1.SQL.text := 'update nfce set adic = ''DENEGADA'', EXPORTADO = 1 where chave = :chave';
        query1.ParamByName('chave').AsString := chavb.chave;
        query1.ExecSQL;
        query1.Transaction.Commit;

        try
          RICHEDT.Lines.Add('((MARCADO COMO DENEGADO!))');
        except
        end;

        ACBrNFe.NotasFiscais[0].GravarXML(chavb.chave + '-nfe.xml',
          buscaPastaNFCe(chavb.chave, false));
        EXIT;
      end;

      if stat = '100' then
      begin
        ACBrNFe.NotasFiscais[0].GravarXML(chavb.chave + '-nfe.xml',
          buscaPastaNFCe(chavb.chave, false));
      end;
    except
      stat := '999';
    end;

  end;

  vend := Tvenda.Create;
  vend.adic := '';
  vend.nota := chavb.codNF;
  vend.chave := chavb.chave;
  if stat <> '100' then
    vend.adic := 'OFF';
  if chaveAtual <> '' then
  begin
    if chaveAtual = chavb.chave then
    begin
      vend.adic := '';
    end;
  end;

  try
    arq.Free;
  except
  end;

  insereNotaBD2(vend);
  if msg then
    imprimirNfce;
  chavb.Free;
  vend.Free;
end;

function buscaChaveErroDeDuplicidade(erro: String): String;
var
  ini, fim: integer;
begin
  ini := POS('[chNFe:', erro) + 7;
  fim := POS(']', erro);
  Result := copy(erro, ini, fim - ini);
end;

function reStartGenerator(nome: string; Valor: integer): String;
begin
  query1.Close;
  query1.SQL.Clear;
  query1.SQL.Add('ALTER SEQUENCE ' + nome + ' RESTART WITH ' + IntToStr(Valor));
  query1.ExecSQL;

  query1.Transaction.Commit;
  Result := '';
end;

function valXML(const val: String): currency;
begin
  Result := StrToCurrDef(StringReplace(val, '.', ',',
    [rfReplaceAll, rfIgnoreCase]), 0);
end;

procedure carregaConfigsNFCe;
begin
  ACBrNFe.Configuracoes.Geral.ModeloDF := moNFCe;
end;

procedure atualizaProtocoloXML(const caminhoxml: String);
var
  arq: TStringList;
  xml: string;
begin
  if ACBrNFe.WebServices.EnvEvento.EventoRetorno.retEvento.Items[0]
    .RetInfEvento.cStat = 0 then
    exit;
  arq := TStringList.Create;
  try
    arq.LoadFromFile(caminhoxml);
  except
    exit;
  end;

  // if Le_Nodo('cStat', arq.GetText) = '' then
  // begin
  xml := arq.text;
  xml := copy(xml, 1, POS('</NFe>', xml) + 5);
  xml := xml + '<protNFe versao=' + versaoNFCe + '>' + '<infProt>' + '<tpAmb>' +
    TpAmbToStr(ACBrNFe.WebServices.EnvEvento.EventoRetorno.retEvento.Items[0]
    .RetInfEvento.tpAmb) + '</tpAmb>' + '<verAplic>' +
    ACBrNFe.WebServices.EnvEvento.EventoRetorno.retEvento.Items[0]
    .RetInfEvento.verAplic + '</verAplic>' + '<chNFe>' +
    ACBrNFe.WebServices.EnvEvento.EventoRetorno.retEvento.Items[0]
    .RetInfEvento.chNFe + '</chNFe>' + '<dhRecbto>' +
    FormatDateTime('yyyy-mm-dd',
    ACBrNFe.WebServices.EnvEvento.EventoRetorno.retEvento.Items[0]
    .RetInfEvento.dhRegEvento) + 'T' + FormatDateTime('hh:mm:ss',
    ACBrNFe.WebServices.EnvEvento.EventoRetorno.retEvento.Items[0]
    .RetInfEvento.dhRegEvento) + '</dhRecbto>' + '<nProt>' +
    ACBrNFe.WebServices.EnvEvento.EventoRetorno.retEvento.Items[0]
    .RetInfEvento.nProt + '</nProt>' + '<digVal>' +
    ACBrNFe.WebServices.EnvEvento.EventoRetorno.retEvento.Items[0]
    .RetInfEvento.nProt + '</digVal>' + '<cStat>' +
    IntToStr(ACBrNFe.WebServices.EnvEvento.EventoRetorno.retEvento.Items[0]
    .RetInfEvento.cStat) + '</cStat>' + '<xMotivo>' +
    ACBrNFe.WebServices.EnvEvento.EventoRetorno.retEvento.Items[0]
    .RetInfEvento.xmotivo + '</xMotivo>' + '</infProt>' + '</protNFe>' +
    '</nfeProc>';

  if not Contido('<nfeProc', xml) then
  begin
    xml := '<nfeProc xmlns="http://www.portalfiscal.inf.br/nfe" versao=' +
      versaoNFCe + '>' + xml;
  end;

  arq.text := xml;
  arq.SaveToFile(caminhoxml);
  arq.Free;
  { end
    else
    begin
    arq.Text := substitui_Nodo('cStat', IntToStr(ACBrNFe.WebServices.EnvEvento.EventoRetorno.retEvento.Items[0].RetInfEvento.cStat), arq.GetText);
    arq.Text := substitui_Nodo('xMotivo', ACBrNFe.WebServices.EnvEvento.EventoRetorno.retEvento.Items[0].RetInfEvento.xMotivo, arq.GetText);
    end; }
end;

function verificaDadosNecessariosDeCliente(codCliente: integer): boolean;
begin
  Result := false;
end;

function procuraNCM_Na_Tabela(NCM: String): boolean;
var
  ini, fim: integer;
  tmp: String;
begin
  Result := false;
  NCM := trim(strnum(NCM));
  if length(NCM) <> 8 then
    exit;
  if not FileExists(ExtractFileDir(ParamStr(0)) + '\IBPT.csv') then
  begin
    MessageDlg('Tabela do IBPT Não Foi Encontrada, Favor Contate o Suporte!',
      mtInformation, [mbOK], 1);
    exit;
  end;

  ACBrIBPTax1.AbrirTabela(ExtractFileDir(ParamStr(0)) + '\IBPT.csv');

  fim := ACBrIBPTax1.Arquivo.Count - 1;
  for ini := 0 to fim do
  begin
    tmp := copy(ACBrIBPTax1.Arquivo.Strings[ini], 1,
      POS(';', ACBrIBPTax1.Arquivo.Strings[ini]) - 1);
    if length(tmp) = 8 then
    begin
      tmp := strnum(tmp);
      if tmp = NCM then
      begin
        Result := true;
        exit;
      end;
    end;
  end;
end;

function ve_unidTributavel(DEST_NFE, NCM, Unidade: string): String;
begin
  if trim(Unidade) = '' then
    Unidade := 'UN';
  Result := trim(Unidade);
  if DEST_NFE <> '2' then
    exit;

  if arqNCM_UNID.Count = 0 then
  begin
    arqNCM_UNID.LoadFromFile(ExtractFileDir(ParamStr(0)) + '\NCM_UNID.txt');
  end;

  Result := arqNCM_UNID.Values[NCM];
  if trim(Result) = '' then
    Result := Unidade;
end;

function ve_cest(codAliq: integer; NCM: String): String;
begin
  Result := '';
  if ((now <= StrToDate('01/04/2016')) and
    (ACBrNFe.Configuracoes.WebServices.Ambiente <> taHomologacao)) then
    exit;
  if codAliq <> 10 then
    exit;

  query1.Close;
  query1.SQL.text := 'select cest from ncm_cest where ncm like :ncm';
  query1.ParamByName('ncm').AsString := NCM + '%';
  query1.Open;

  Result := query1.fieldbyname('cest').AsString;

  if query1.IsEmpty then
  begin
    query1.Close;
    query1.SQL.text := 'select cest from ncm_cest where :ncm like ncm||''%''';
    query1.ParamByName('ncm').AsString := NCM;
    query1.Open;

    Result := query1.fieldbyname('cest').AsString;
  end;

  if query1.IsEmpty then
  begin
    Result := '2804400';
  end;

  Result := '<CEST>' + Result + '</CEST>';
  query1.Close;
end;

function verificaSePodeEmitirContigencia(): boolean;
var
  notas: string;
  dias: Smallint;
begin
  Result := false;
  query1.Close;
  query1.SQL.text :=
    'select chave,data from nfce where adic = ''OFF'' and (substring(chave from 23 for 3) = :serie) order by data';
  query1.ParamByName('serie').AsString := strzero(getSerieNFCe, 3);
  query1.Open;

  if query1.IsEmpty then
  begin
    Result := true;
    query1.Close;
    exit;
  end;

  notas := '';
  while not query1.Eof do
  begin
    notas := notas + #13 + query1.fieldbyname('chave').AsString + ' ' +
      FormatDateTime('dd/mm/yyy', query1.fieldbyname('data').AsDateTime);
    query1.Next;
  end;

  dias := StrToIntDef(pgerais.Values['79'], 2);
  if dias < 2 then
    dias := 2;

  if abs(DaysBetween(query1.fieldbyname('data').AsDateTime, now)) >= dias then
  begin
    MessageDlg('O Sistema só pode Emitir NFCe quando As Notas Forem Enviadas: '
      + #13 + notas, mtInformation, [mbOK], 1);
    exit;
  end;

  Result := true;
  query1.Close;
end;

function verificaSeExisteVendaDeVariosPedidos(nota: String): boolean;
var
  notas: TStringList;
  ini: integer;
begin
  Result := false;
  nota := trim(nota);
  if Contido(' ', nota) = false then
  begin
    exit;
  end
  else
  begin
    nota := trocachar(nota, ' ', '|');
    nota := '|' + nota + '|';

    LE_CAMPOS(notas, nota, '|');

    for ini := 0 to notas.Count - 1 do
    begin
      nota := strnum(notas.ValueFromIndex[ini]);

      if length(nota) <= 10 then
      begin
        query1.Close;
        query1.SQL.text := 'select nota from venda where nota = :nota';
        query1.ParamByName('nota').AsString := nota;
        query1.Open;

        if not query1.IsEmpty then
        begin
          Result := true;
          query1.Close;
          notas.Free;
          exit;
        end;
      end;
    end;
  end;
end;

function verificaDadosClienteNFe(cod: String;
  exterior: boolean = false): boolean;
var
  CNPJ, acc: String;
begin
  Result := false;
  query1.Close;
  query1.SQL.text :=
    'select nome, cnpj, tipo, ende, bairro, cod_mun, est, cid, cep, ies from cliente where cod = :cod';
  query1.ParamByName('cod').AsString := strnum(cod);
  query1.Open;

  if exterior then
  begin
    CNPJ := strnum(query1.fieldbyname('ies').AsString);
    if length(CNPJ) <= 1 then
    begin
      ShowMessage('Destinatário: Informação de Identidade ' + CNPJ +
        ' Inválido!');
      exit;
    end;

    if length(query1.fieldbyname('ende').AsString) < 5 then
    begin
      ShowMessage('Destinatário: Endereço ' + query1.fieldbyname('ende')
        .AsString + ' Muito Curto!');
      exit;
    end;

    if length(query1.fieldbyname('bairro').AsString) < 2 then
    begin
      ShowMessage('Destinatário: Bairro ' + query1.fieldbyname('bairro')
        .AsString + ' Muito Curto!');
      exit;
    end;

    Result := true;
    exit;
  end;

  if query1.IsEmpty then
  begin
    ShowMessage('Cliente ' + strnum(cod) + ' Não Existe!');
    query1.Close;
    exit;
  end;

  CNPJ := strnum(query1.fieldbyname('cnpj').AsString);
  acc := '';
  if length(CNPJ) = 11 then
  begin
    if not testacpf(CNPJ) then
    begin
      acc := acc + 'Destinatário: CPF ' + CNPJ + ' Inválido!' + #13;
    end;
  end
  else
  begin
    if not VALIDACNPJ(CNPJ) then
    begin
      acc := acc + 'Destinatário: CNPJ ' + CNPJ + ' Inválido!' + #13;
    end;
  end;

  if length(query1.fieldbyname('ende').AsString) < 5 then
  begin
    acc := acc + 'Destinatário: Endereço ' + query1.fieldbyname('ende').AsString
      + ' Muito Curto!' + #13;
  end;

  if ((length(query1.fieldbyname('cod_mun').AsString) < 5) and
    (query1.fieldbyname('est').AsString <> 'RR')) then
  begin
    acc := acc + 'Destinatário: Código do Município ' +
      query1.fieldbyname('cod_mun').AsString + ' Inválido!' + #13;
  end;

  if query1.fieldbyname('est').AsString = '' then
  begin
    acc := acc + 'Destinatário: Estado Não Preenchido!' + #13;
  end;

  if query1.fieldbyname('cid').AsString = '' then
  begin
    acc := acc + 'Destinatário: Cidade Não Preenchida!' + #13;
  end;

  if query1.fieldbyname('cep').AsString = '' then
  begin
    acc := acc + 'Destinatário: CEP Não Preenchido!' + #13;
  end;

  if length(query1.fieldbyname('bairro').AsString) < 2 then
  begin
    acc := acc + 'Destinatário: Bairro Inválido!' + #13;
  end;

  if acc <> '' then
  begin
    ShowMessage('Dados do Destinatário Incompletos: ' + #13 + #13 + acc);
    exit;
  end;

  Result := true;
  query1.Close;
end;

procedure TTWtheadNFeEnvia.FinalizaSessaoCritica;
begin
  self.FCritical.Leave;
  self.FCritical.Free;
end;

procedure TTWtheadNFeEnvia.AfterConstruction;
begin
  self.FCritical := TCriticalSection.Create;
end;

procedure TTWtheadNFeConsulta.AfterConstruction;
begin
  self.FCritical := TCriticalSection.Create;
end;

procedure TTWtheadNFeEnvia.Execute;
begin
  enviouNFE := 'N';
  try
    try
      self.FCritical.Enter;
      self.acbrnf.enviar(0, false, true);
      enviouNFE := 'S';
    except
      on e: Exception do
      begin
        ERRO_dados := e.Message;
        enviouNFE := 'E';
      end;
    end;
  finally
    // self.FCritical.Leave;
    // Self.FCritical.Free;
  end;

  if enviouNFE = 'N' then
    enviouNFE := 'E';
  sleep(1);
end;

procedure TTWtheadNFeConsulta.Execute;
begin
  enviouNFE := 'N';
  try
    try
      self.FCritical.Enter;
      self.acbrnf.Consultar();
      enviouNFE := 'S';
    except
      on e: Exception do
      begin
        ERRO_dados := e.Message;
        enviouNFE := 'E';
      end;
    end;
  finally
    self.FCritical.Leave;
    self.FCritical.Free;
  end;

  if enviouNFE = 'N' then
    enviouNFE := 'S';
  sleep(1);
end;

constructor TTWtheadNFeEnvia.Create(const CreateSuspended: boolean;
  var acbrnf1: TACBrNFe);
begin
  self.acbrnf := acbrnf1;
  inherited Create(CreateSuspended);
end;

constructor TTWtheadNFeConsulta.Create(const CreateSuspended: boolean;
  var acbrnf1: TACBrNFe);
begin
  self.acbrnf := acbrnf1;
  inherited Create(CreateSuspended);
end;

function acbrNFeEnviar(segundos: integer = 20): boolean;
var
  threadEnvi: TTWtheadNFeEnvia;
  cont: integer;
begin
  cont := 0;
  Result := false;

  Form72.BMDThread1.Start;

  ERRO_dados := '';
  while true do
  begin
    application.ProcessMessages;
    sleep(500);
    cont := cont + 1;
    if trunc(cont / 2) > segundos then
    begin // se acabou o tempo de espera
      ERRO_dados := '(5)-Requisição não enviada';
      Form72.BMDThread1.Suspend;
      Form72.BMDThread1.Stop;
      exit;
    end;

    if enviouNFE = 'E' then
    begin // Se ocorreu algum ERRO no Envio

      ERRO_dados := '(1)-' + ERRO_dados;
      Form72.BMDThread1.Suspend;
      Form72.BMDThread1.Stop;
      exit;
    end;

    if ERRO_dados <> '' then
    begin // ERRO_dados recebeu o e.message do erro
      ERRO_dados := '(2)-' + ERRO_dados;
      Form72.BMDThread1.Suspend;
      Form72.BMDThread1.Stop;
      exit;
    end;

    if enviouNFE = 'S' then
    begin // Se o metodo Enviar foi executado sem erros
      Result := true;
      Form72.BMDThread1.Suspend;
      Form72.BMDThread1.Stop;
      exit;
    end;
  end;
end;

function acbrNFeEnviar1(segundos: integer = 20): boolean;
var
  cont: integer;
  hThreadID: THandle;
  ThreadID: DWord;
begin
  cont := 0;
  Result := false;
  ERRO_dados := '';
  hThreadID := CreateThread(nil, 0, @acbrNFeEnviarThread, nil, 0, ThreadID);

  SetThreadPriority(hThreadID, HIGH_PRIORITY_CLASS);

  while true do
  begin
    application.ProcessMessages;
    sleep(500);
    cont := cont + 1;

    if trunc(cont / 2) > segundos then
    begin // se acabou o tempo de espera
      ERRO_dados := '(5)-Requisição não enviada';
      TerminateThread(hThreadID, 0);
      exit;
    end;

    if enviouNFE = 'E' then
    begin // Se ocorreu algum ERRO no Envio
      ERRO_dados := '(1)-' + ERRO_dados;
      TerminateThread(hThreadID, 0);
      exit;
    end;

    if ERRO_dados <> '' then
    begin // ERRO_dados recebeu o e.message do erro
      ERRO_dados := '(2)-' + ERRO_dados;
      TerminateThread(hThreadID, 0);
      exit;
    end;

    if enviouNFE = 'S' then
    begin // Se o metodo Enviar foi executado sem erros
      Result := true;
      TerminateThread(hThreadID, 0);
      exit;
    end;
  end;
end;

function acbrNFeConsultar(segundos: integer = 20): boolean;
var
  cont: integer;
  hThreadID: THandle;
  ThreadID: DWord;
  threadConsulta: TTWtheadNFeConsulta;
begin
  cont := 0;
  Result := false;
  ERRO_dados := '';

  threadConsulta := TTWtheadNFeConsulta.Create(true, ACBrNFe);
  threadConsulta.Start;
  // hThreadID := CreateThread(nil, 0, @acbrNFeConsultarThread, nil, 0, ThreadID);
  // SetThreadPriority(hThreadID, HIGH_PRIORITY_CLASS);

  while true do
  begin
    application.ProcessMessages;
    sleep(500);
    cont := cont + 1;
    if trunc(cont / 2) > segundos then
    begin // se acabou o tempo de espera
      ERRO_dados := '(5)-' + ERRO_dados;
      TerminateThread(threadConsulta.Handle, 0);
      exit;
    end;

    if enviouNFE = 'E' then
    begin // Se ocorreu algum ERRO no Envio
      ERRO_dados := '(1)-' + ERRO_dados;
      TerminateThread(threadConsulta.Handle, 0);
      exit;
    end;

    if ERRO_dados <> '' then
    begin // ERRO_dados recebeu o e.message do erro
      ERRO_dados := '(2)-' + ERRO_dados;
      TerminateThread(threadConsulta.Handle, 0);
      exit;
    end;

    if enviouNFE = 'S' then
    begin // Se o metodo Enviar foi executado sem erros
      Result := true;
      TerminateThread(threadConsulta.Handle, 0);
      exit;
    end;
  end;
end;

function acbrNFeEnviarThread(P: Pointer): LongInt;
begin
  enviouNFE := 'N';
  try
    ACBrNFe.enviar(0, false);
    enviouNFE := 'S';
  except
    on e: Exception do
    begin
      ERRO_dados := e.Message;
      enviouNFE := 'E';
    end;
  end;
  if enviouNFE = 'N' then
    enviouNFE := 'E';
  sleep(1);
end;

function acbrNFeConsultarThread(P: Pointer): LongInt;
begin
  enviouNFE := 'N';
  try
    ACBrNFe.Consultar;
    enviouNFE := 'S';
  except
    on e: Exception do
    begin
      ERRO_dados := e.Message;
      enviouNFE := 'E';
    end;
  end;

  if enviouNFE = 'N' then
    enviouNFE := 'E';
  sleep(1);
end;

function buscaPastaNFCe(const chave: String; abrir: boolean = true): String;
begin
  Result := ExtractFileDir(ParamStr(0)) + '\NFCe\EMIT\';
  if abrir = false then
  begin
    Result := Result + copy(chave, 3, 4) + '\';
    if DirectoryExists(Result) = false then
      ForceDirectories(Result);
  end;

  if chave <> '' then
  begin
    if FileExists(Result + copy(chave, 3, 4) + '\' + chave + '-nfe.xml') then
    begin
      Result := Result + copy(chave, 3, 4) + '\';
    end;
  end;
end;

function buscaPastaNFe(const chave: String; abrir: boolean = true): String;
begin
  Result := ExtractFileDir(ParamStr(0)) + '\NFe\EMIT\';
  if DirectoryExists(Result) = false then
    ForceDirectories(Result);
  if abrir = false then
  begin
    // Result := Result + copy(chave, 3, 4) + '\';
    if DirectoryExists(Result) = false then
      ForceDirectories(Result);
  end;

  { if chave <> '' then begin
    if FileExists(Result + copy(chave, 3, 4) + '\' + chave + '-nfe.xml') then begin
    Result := Result + copy(chave, 3, 4) + '\';
    end;
    end; }
end;

function existeProxNumero(chave: String): boolean;
var
  nnf: integer;
begin
  Result := true;

  nnf := StrToInt(strnum(copy(chave, 26, 9)));
  if nnf = 0 then
    exit;

  query1.Close;
  query1.SQL.text :=
    'select * from nfce where cast(substring(chave from 26 for 9) as integer) = :nnf ';
  query1.ParamByName('nnf').AsInteger := nnf + 1;
  query1.Open;

  if query1.IsEmpty then
    Result := false;
  query1.Close;
end;

procedure insereInutilizacao(inicio, fim: integer; tipo, serie: string;
  Data: tdate);
begin
  query1.Close;
  query1.SQL.text :=
    'INSERT INTO INUTILIZACAO(COD, INICIO, FIM, TIPO, DATA, SERIE) ' +
    'VALUES(gen_id(INUTILIZACAO, 1), :INICIO, :FIM, :TIPO, :DATA, :SERIE)';
  query1.ParamByName('INICIO').AsInteger := inicio;
  query1.ParamByName('FIM').AsInteger := fim;
  query1.ParamByName('TIPO').AsString := tipo;
  query1.ParamByName('DATA').AsDate := Data;
  query1.ParamByName('SERIE').AsString := serie;
  query1.ExecSQL;
  query1.Transaction.Commit;
end;

function retornaDescontoDoItem(descontoItem: currency): currency;
begin
  Result := 0;
  if descontoItem = 0 then
  begin
    exit;
  end;

  if (pgerais.Values['71'] = 'S') and (descontoItem > 0) then
  begin
    Result := descontoItem;
  end;
end;

procedure rateiaDesconto(var lista0: TList; totalDesconto: currency);
begin

end;

function verificarValidadeCertificado(exception1: boolean = false): boolean;
var
  dias: integer;
begin
  Result := false;
  dias := trunc(ACBrNFe.SSL.CertDataVenc - now);
  if dias < 10 then
  begin
    if dias < 0 then
    begin
      if exception1 then
      begin
        Exception.Create('(1)O Certificado Digital Está Vencido!' + #13 +
          'Entre' + ' em contato com o suporte para atualização do certificado'
          + #13 + 'Vencimento: ' + FormatDateTime('dd/mm/yyyy',
          ACBrNFe.SSL.CertDataVenc));
        exit;
      end;

      MessageDlg('(1)O Certificado Digital Está Vencido!' + #13 + 'Entre' +
        ' em contato com o suporte para atualização do certificado' + #13 +
        'Vencimento: ' + FormatDateTime('dd/mm/yyyy', ACBrNFe.SSL.CertDataVenc),
        mtInformation, [mbOK], 1);
      exit;
    end;

    Result := true;
    if exception1 then
    begin
      Exception.Create('(2)Faltam ' + IntToStr(dias) +
        ' Dias Para o Vencimento do Certificado Digital!');
      exit;
    end;

    MessageDlg('Faltam ' + IntToStr(dias) +
      ' Dias Para o Vencimento do Certificado Digital!', mtInformation,
      [mbOK], 1);
  end;
  Result := true;
end;

function buscaVersaoIBPT_Local(): String;
var
  arq, te: TStringList;
  val: string;
begin
  Result := '';
  if not FileExists(ExtractFileDir(ParamStr(0)) + '\IBPT.csv') then
    exit;

  arq := TStringList.Create;
  arq.LoadFromFile(ExtractFileDir(ParamStr(0)) + '\IBPT.csv');
  if arq.Count > 10 then
  begin
    try
      if StrToInt(ContaChar(arq[5], ';')) > 4 then
      begin
        val := ';' + arq[5] + ';';
        LE_CAMPOS(te, val, ';', true);
        // Result := copy(arq[5], length(arq[5]) -10, 6);
        Result := te.Values['11'];
        te.Free;
      end;
    except
      Result := 'XX';
    end;
  end;
  arq.Free;
end;

function GravaConfigNaPastaDoControlW(Const config_name: String;
  const default: string): String;
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

  arq := TStringList.Create;
  arq.LoadFromFile(caminhoEXE_com_barra_no_final + 'CONFIG.DAT');
  arq.Values[config_name] := default;

  Result := '';
  Result := arq.Values[config_name];
  arq.SaveToFile(caminhoEXE_com_barra_no_final + 'CONFIG.DAT');
  arq.Free;
end;

procedure validaNCM_NaNFCe(chave1: String);
var
  ini, fim: integer;
begin
  fim := ACBrNFe.NotasFiscais[0].nfe.Det.Count - 1;
  for ini := 0 to fim do
  begin
    ACBrNFe.NotasFiscais[0].nfe.Det[ini].Prod.NCM :=
      verNCM(StrToInt(strnum(ACBrNFe.NotasFiscais[0].nfe.Det[ini].Prod.cProd)));
    query1.Close;
    query1.SQL.text := 'select aliquota from produto where cod = :cod';
    query1.ParamByName('cod').AsInteger :=
      StrToInt(strnum(ACBrNFe.NotasFiscais[0].nfe.Det[ini].Prod.cProd));
    query1.Open;

    ACBrNFe.NotasFiscais[0].nfe.Det[ini].Prod.CEST :=
      ve_cest(StrToInt(strnum(query1.fieldbyname('aliquota').AsString)),
      ACBrNFe.NotasFiscais[0].nfe.Det[ini].Prod.NCM);
    query1.Close;
  end;

  GravarTexto(buscaPastaNFCe(CHAVENF) + CHAVENF + '-nfe.xml',
    ACBrNFe.NotasFiscais[0].GerarXML);
end;


procedure validaCodbarCSTAT882(chave1: String);
var
  ini, fim: integer;
begin
  fim := ACBrNFe.NotasFiscais[0].nfe.Det.Count - 1;
  for ini := 0 to fim do
  begin
    if ((LeftStr(ACBrNFe.NotasFiscais[0].nfe.Det[ini].Prod.cEAN, 3) <> '789')) then begin
      ACBrNFe.NotasFiscais[0].nfe.Det[ini].Prod.cEAN :=
      DIGEAN('789000' + CompletaOuRepete('', IntToStr(StrToInt(strnum(ACBrNFe.NotasFiscais[0].nfe.Det[ini].Prod.cProd))), '0', 6));
    end;

    ACBrNFe.NotasFiscais[0].nfe.Det[ini].Prod.cEANTrib := ACBrNFe.NotasFiscais[0].nfe.Det[ini].Prod.cEAN;
  end;

  GravarTexto(buscaPastaNFCe(CHAVENF) + CHAVENF + '-nfe.xml',
    ACBrNFe.NotasFiscais[0].GerarXML);
end;


function manifestoDestinatarioNFe(chave: string): boolean;
var
  CNPJ: String;
begin
  query1.Close;
  query1.SQL.text := 'select cnpj from registro';
  query1.Open;

  CNPJ := strnum(query1.fieldbyname('cnpj').AsString);
  query1.Close;

  ACBrNFe.EventoNFe.Evento.Clear;
  with ACBrNFe.EventoNFe.Evento.Add do
  begin
    InfEvento.cOrgao := 14;
    InfEvento.chNFe := chave;
    InfEvento.CNPJ := CNPJ;
    InfEvento.dhEvento := now;
    InfEvento.tpEvento := teManifDestConfirmacao;
  end;

  ACBrNFe.EnviarEvento(1);
end;

procedure TForm72.BMDThread1Execute(Sender: TObject; Thread: TBMDExecuteThread;
  var Data: Pointer);
var
  inif : TCustomIniFile;
begin
  enviouNFE := 'N';
  try
    ACBrNFe.Configuracoes.WebServices.Visualizar := false;
    ACBrNFe.enviar(0, false);
    enviouNFE := 'S';
  except
    on e: Exception do
    begin
      ERRO_dados := e.Message;
      {if Contido('Campo cUF inexistente no elemento nfeCabecMsg do SOAP Header', ERRO_dados) then begin
        ERRO_dados := '';
        enviouNFE := 'S';
      end;}

      enviouNFE := 'E';
    end;
  end;
  if enviouNFE = 'N' then
    enviouNFE := 'E';

  sleep(1);
end;

procedure TForm72.IdThreadComponent1Exception(Sender: TIdThreadComponent;
  AException: Exception);
begin
  ERRO_dados := AException.Message;
end;

procedure TForm72.IdThreadComponent2Run(Sender: TIdThreadComponent);
begin
  enviouNFE := 'N';
  try
    ACBrNFe.Configuracoes.WebServices.Visualizar := false;
    ACBrNFe.enviar(0, false);
    enviouNFE := 'S';
  except
    on e: Exception do
    begin
      ERRO_dados := e.Message;
      enviouNFE := 'E';
    end;
  end;
  if enviouNFE = 'N' then
    enviouNFE := 'E';

  if ACBrNFe.WebServices.enviar.cStat in [100, 103] then
  begin
    enviouNFE := 'S';
    ERRO_dados := '';
  end;
  sleep(1);
end;

function CodificaDataPelaChave(chave: String): TDateTime;
var
  dia, mes, ano: Word;
begin
  dia := 1;
  ano := YearOf(now);

  if copy(chave, 3, 2) <> RightStr(IntToStr(ano), 2) then
  begin
    ano := StrToIntDef('20' + copy(chave, 3, 2), ano);
  end;

  mes := StrToInt(copy(chave, 5, 2));
  Result := EncodeDate(ano, mes, dia);

  Result := Result + TimeOf(now);
end;

procedure setVersaoNFCe();
begin
  //ACBrNFe.Configuracoes.Geral.VersaoDF := ve310;
  ACBrNFe.Configuracoes.Geral.ModeloDF := moNFCe;
end;

procedure setVersaoNFe();
begin
  //ACBrNFe.Configuracoes.Geral.VersaoDF := ve310;

  ACBrNFe.Configuracoes.Geral.ModeloDF := moNFe;
end;


function usaNFe4ouMaior() : boolean;
begin
  Result := false;
  if LeftStr(versaoNFe, 1) = '4' then Result := true;
end;


procedure atualizaRegistroNFCe(chaveVelha1, chaveNova1 : String);
begin
  if length(trim(chaveVelha1)) <> 44 then begin
    exit;
  end;
  if length(trim(chaveNova1))  <> 44 then begin
    exit;
  end;

  query1.Close;
  query1.SQL.Text := 'select * from nfce where chave = ' + QuotedStr(chaveNova1);
  query1.Open;

  if not query1.IsEmpty then begin
    query1.Close;
    query1.SQL.Text := 'update nfce set chave = '+QuotedStr(chaveNova1)+' where chave = ' + QuotedStr(chaveVelha1);
    try
      query1.ExecSQL;
      query1.Transaction.Commit;
    except
     on e:exception do begin
       ShowMessage(e.Message);
     end;
    end;
  end
  else begin
    query1.Close;
    query1.SQL.Text := 'delete from nfce where chave = ' + QuotedStr(chaveVelha1);
    try
      query1.ExecSQL;
      query1.Transaction.Commit;
    except
     on e:exception do begin
       ShowMessage(e.Message);
     end;
    end;
  end;

  ShowMessage(query1.SQL.Text);
end;


function SendPostData(var http : TIdHTTP; arquivo, estado, cstat : String) : boolean;
var
  Stream: TStringStream;
  Params: TIdMultipartFormDataStream;
  ret : string;
begin
  query1.Close;
  query1.SQL.Text := 'select * from registro';
  query1.Open;

  Result := false;

  Stream := TStringStream.Create('');
  try
   Params := TIdMultipartFormDataStream.Create;
   try
    //o nome 'arquivo' é obrigatório, não se pode mudar se não mudar no arquivo php tbm.
    Params.AddFile('file', arquivo,'plain/text');
    params.AddFormField('empresa', trim(query1.FieldByName('empresa').AsString));
    params.AddFormField('estado',  estado);
    params.AddFormField('cstat',  cstat);
    params.AddFormField('cnpj', strnum(query1.FieldByName('cnpj').AsString));
    params.AddFormField('endereco', trim(query1.FieldByName('ende').AsString) + ', ' + trim(query1.FieldByName('bairro').AsString) + ' ' + trim(query1.FieldByName('cid').AsString) + ' ' +
    trim(query1.FieldByName('telres').AsString) + ' ' + trim(query1.FieldByName('telcom').AsString) );
    try
      HTTP.Post('http://controlw.blog.br/si2/upload_binario.php', Params, Stream);
    except
     on E: Exception do
       //ShowMessage('Error encountered during POST: ' + E.Message);
    end;
    if trim(Stream.DataString) = 'SUCESSO' then Result := true;
   finally
    Params.Free;
   end;
  finally
   Stream.Free;
  end;

  query1.Close;
end;

function SendPostDataMensagem(var http : TIdHTTP; erro, tipo, cstat, nomePC : String) : boolean;
var
  Stream: TStringStream;
  Params: TIdMultipartFormDataStream;
  ret : string;
begin
  query1.Close;
  query1.SQL.Text := 'select * from registro';
  query1.Open;

  Result := false;

  Stream := TStringStream.Create('');
  try
   Params := TIdMultipartFormDataStream.Create;
   try
    params.AddFormField('empresa', trim(query1.FieldByName('empresa').AsString));
    params.AddFormField('cnpj', strnum(query1.FieldByName('cnpj').AsString));
    params.AddFormField('endereco', trim(query1.FieldByName('ende').AsString) + ', ' + trim(query1.FieldByName('bairro').AsString) + ' ' + trim(query1.FieldByName('cid').AsString) + ' ' +
    trim(query1.FieldByName('telres').AsString) + ' ' + trim(query1.FieldByName('telcom').AsString) );

    params.AddFormField('erro',  erro);
    params.AddFormField('tipo',  tipo);
    params.AddFormField('cstat', cstat);
    params.AddFormField('nomepc', nomePC);
    try
      HTTP.Post('http://controlw.blog.br/si2/msg.php', Params, Stream);
    except
     on E: Exception do
       //ShowMessage('Error encountered during POST: ' + E.Message);
    end;

    if trim(Stream.DataString) = 'SUCESSO' then Result := true;
   finally
    Params.Free;
   end;
  finally
   Stream.Free;
  end;

  query1.Close;
end;

function GRAVA_NODO_PROT_NFCe(ARQ_caminho : string ) : string;
var
  texto, NODO_PROT, cStat, nNF, Chave1, digVal: string;
  retorno : TStringList;
  txt1 : AnsiString;
  valida : boolean;
begin
  cStat := '';
  valida := false;
  Result := '';
  NODO_PROT := '';
  retorno := TStringList.Create;

  nNF    := IntToStr(ACBrNFe.NotasFiscais[0].NFe.Ide.nNF); //Le_Nodo('nNF', dadosDest.GetText);
  Chave1 := entraXMLeRetornaChave(ACBrNFe.NotasFiscais[0].XML);
  digVal := Le_Nodo('DigestValue', ACBrNFe.WebServices.EnvEvento.EventoRetorno.retEvento.Items[0].RetInfEvento.verAplic + '</verAplic><chNFe>' + ACBrNFe.WebServices.EnvEvento.EventoRetorno.retEvento.Items[0].RetInfEvento.XML);

  dadosEmitente := TStringList.Create;

  cStat := IntToStr(ACBrNFe.WebServices.EnvEvento.EventoRetorno.retEvento.Items[0].RetInfEvento.cStat);
  cStat := trim(cStat);
  //if funcoes.Contido(cStat, '101-135') then cStat := '101';

  dadosEmitente.LoadFromFile(ARQ_caminho);
  RETORNO.Values['DhRecbto'] := FormatDateTime('yyyy-mm-dd', ACBrNFe.WebServices.EnvEvento.EventoRetorno.retEvento.Items[0].RetInfEvento.dhRegEvento) + 'T' + FormatDateTime('hh:mm:ss', ACBrNFe.WebServices.EnvEvento.EventoRetorno.retEvento.Items[0].RetInfEvento.dhRegEvento);

   NODO_PROT := '<protNFe versao="'+versaoNFe+'"><infProt><tpAmb>' + TpAmbToStr(ACBrNFe.WebServices.EnvEvento.EventoRetorno.retEvento.Items[0].RetInfEvento.tpAmb) + '</tpAmb>' +
   '<verAplic>' +  ACBrNFe.WebServices.EnvEvento.EventoRetorno.retEvento.Items[0].RetInfEvento.verAplic + '</verAplic><chNFe>' + ACBrNFe.WebServices.EnvEvento.EventoRetorno.retEvento.Items[0].RetInfEvento.chNFe + '</chNFe>' +
   '<dhRecbto>' + (RETORNO.Values['DhRecbto']) + '</dhRecbto>' + '<nProt>' + ACBrNFe.WebServices.EnvEvento.EventoRetorno.retEvento.Items[0].RetInfEvento.nProt +
   '</nProt><digVal>' + digVal + '</digVal>' + '<cStat>' + cStat + '</cStat>' +
   '<xMotivo>' + ACBrNFe.WebServices.EnvEvento.EventoRetorno.retEvento.Items[0].RetInfEvento.xMotivo + '</xMotivo></infProt></protNFe>';

  Result := dadosEmitente.GetText;
  dadosEmitente.Free;

  if Contido('<protNFe', Result) then
    begin
      Result := copy(Result, 1, pos('<protNFe',Result) - 1);
    end
  else
    begin
      Result := copy(Result, 1, pos('</NFe>',Result) - 1);
    end;

  if Result[Length(Result)] <> '>' then Result :=  Result + '>';
  Result := Result + NODO_PROT + '</nfeProc>';
  GravarTexto(ARQ_caminho, Result);

  retorno.Free;
end;


function GetBuildInfo(Prog: string): string;
var
 VerInfoSize: DWORD;
 VerInfo: Pointer;
 VerValueSize: DWORD;
 VerValue: PVSFixedFileInfo;
 Dummy: DWORD;
 V1, V2, V3, V4: Word;
begin
 try
   VerInfoSize := GetFileVersionInfoSize(PChar(Prog), Dummy);
   GetMem(VerInfo, VerInfoSize);
   GetFileVersionInfo(PChar(prog), 0, VerInfoSize, VerInfo);
   VerQueryValue(VerInfo, '', Pointer(VerValue), VerValueSize);
   with (VerValue^) do
   begin
     V1 := dwFileVersionMS shr 16;
     V2 := dwFileVersionMS and $FFFF;
     V3 := dwFileVersionLS shr 16;
     V4 := dwFileVersionLS and $FFFF;
   end;
   FreeMem(VerInfo, VerInfoSize);
   Result := Format('%d.%d.%d.%d', [v1, v2, v3, v4]);
 except
   Result := '1.0.0';
 end;
end;

function FileAgeCreate(const fileName: string): String;
begin
  Result := FormatDateTime('yy.mm.dd', FileDateToDateTime(FileAge(fileName)));
end;



end.
