
unit func;

interface

uses
  StdCtrls, Controls, Forms,Windows, Messages, SysUtils,IBQuery, Variants, Classes, Graphics,
  Dialogs,IniFiles,SHELLAPI, db,dbgrids,ComCtrls,richedit,dbclient, IBDatabase,
  IBCustomDataSet, ExtCtrls, printers, funcoesDAV, OleCtrls,
  SHDocVw, sButton
  , IdComponent, IdTCPConnection, IdTCPClient, IdHTTP,
  IdBaseComponent, IdAntiFreezeBase, IdAntiFreeze, WinInet, RxCalc, IdFTP,
  IdTime, ibsql, shlobj, Grids, Registry,ActiveX, ComObj, Provider, jsedit1, SyncObjs,
  classes1, ACBrETQ ;
type
  Ptr_Item = ^Item_pagamento;
  Item_pagamento = record
    codFormaPagamento : integer;
    codVendedor : integer;
    total : currency;
  end;

 TTWtheadEnviaCupons1 = class(TThread)
  private
    timer0 : TTimer;
    label1 : TLabel;
    Fcount : integer;
    enviandoCupom : boolean;
    SessaoCritica: TcriticalSection;
  protected
    procedure Execute; override;
  public
    constructor Create(CreateSuspended: Boolean;lab1:TLabel); overload;
    procedure enviaCupons;
  end;

 TTWThreadVerificaPagamento = class(TThread)
  private
    SessaoCritica: TcriticalSection;
  protected
    procedure Execute; override;
  public
  end;

  Ptr_sinc = ^Item_sinc;
  Item_sinc = record
    cod : integer;
    nome : String;
    p_vendaEstoque : currency;
    p_vendaSincronizacao : currency;
  end;

  Ptr_nota = ^Item_nota;
  Item_nota = record
    cod : integer;
    numProd : integer;
    nome : string[40];
    quant : currency;
    qtd : currency;
    preco : currency;
    preco1 : currency;
    total : currency;
    totNota : currency;
    unid : string[8];
    codbar : string[15];
    data : TDateTime;
    nota : string;
    NCM : string;
  end;

type
  Tfuncoes = class(TForm)
    a: TIBQuery;
    IBTransaction1: TIBTransaction;
    WebBrowser1: TWebBrowser;
    Timer2: TTimer;
    RxCalculator1: TRxCalculator;
    IdFTP1: TIdFTP;
    DataSource1: TDataSource;
    DBGrid1: TDBGrid;
    Timer1: TTimer;
    DataSetProvider1: TDataSetProvider;
    Timer3: TTimer;
    IdHTTP1: TIdHTTP;
    procedure FormCreate(Sender: TObject);
    procedure WebBrowser1DocumentComplete(Sender: TObject;
      const pDisp: IDispatch; var URL: OleVariant);
    procedure Timer1Timer(Sender: TObject);
    procedure Timer3Timer(Sender: TObject);
  private
    retornobusca:string;
    texto : String;
    cdsEquiva : TClientDataSet;
    buscaTimer : String;
    listaProdutos : Tprodutos;
    procedure SOMA_EST(const COD : integer;const QTD, DEP : currency;var lista : TItensAcumProd) ;
    procedure Button1Click(Sender: TObject);
    procedure MeuKeyPress1(Sender: TObject; var Key: Char);
    FUNCTION BUSCA_EST(COD : integer;var QTD_LOJA, QTD_DEP : currency; var lista : TItensAcumProd) : boolean;
    { Private declarations }
  public
     inicio1 : Smallint;
     cds1 : TClientDataSet;
     botao : TsButton;
     lista1 : string;
     valordg:string;
     formpato:string;
     info:string;
     retornoLocalizar, bloq :string;
     ReParcelamento : tstringList;
     OK : BOOLEAN;
     Simbolos : array [0..4] of String;
     enviandoCupom :boolean;
     fonteRelatorioForm19 : Integer;
     NegritoRelatorioForm19 : boolean;
     procedure alinhabdgrid(var bdgrid : TDBGrid);
     function limitar_QTD_Estoque(quant : currency; cod, origem : integer) : boolean;
     function emiteNfe(nota : String = '';simplificado : boolean = false) : boolean;
     procedure restartGeneratorPelaTabelaMax(tabela, generator : String);
     function recebeFornecedores(var arq : TStringList) : boolean;
     function exportaFornecedores(var arq : TextFile) : boolean;
     function buscaXMl(const path : String; novo : boolean = true) : boolean;
     function exportaTabela(Tabela, CAMPOS : String; var arq : TextFile; var query : TIBQuery) : boolean;
     function sincronizarArquivoDeRemessa(caminho : String; var query : TIBQuery) : boolean;
     function criaBackup() : boolean;
     function marcaXMLNFCeParaEnvio(chave, erro, serie : String) : boolean;
     function manutencaoDeXml(inicia : smallint) : String;
     function retornaEscalaDoCampo(campo, tabela : String) : Smallint;
     procedure criaDataSetVirtualProdutosForm33();
     function buscaUltimaVendaOrcamentoDoUsuario(codUsuario : integer; opcao : Smallint) : String;
     procedure atualizaCFOPs();
     procedure atualizaTabelaCest();
     procedure imprimeGrafico(tipo, nota, vendedor : String; listaProdutos1 : TItensProduto; desconto : currency);
     function DSiFileSize(const fileName: string): int64;
     function Trunca(const nValor: Currency; const iCasas: Integer): Currency;
     procedure AjustaForm(Formulario : tform);
     function getDiasBloqueioRestantes(soDiasParaBloquear : boolean = false) : integer;
     procedure BuscaAplicacao(CONST SQL : sTRING; VAR GRID1 : TDBGrid; ORDENACAMP : BOOLEAN);
     function DeleteFolder(FolderName: String): Boolean;
     procedure somenteNumeros(var key : char);
     function buscaVendaNFCe(nnf, serie : String; var chave : String) : String;
     function buscaVendaECF(nnf, serie : String) : String;
     function BrowseForFolderCallBack(Wnd: HWND; uMsg: UINT; lParam, lpData: LPARAM): Integer stdcall;
     function cadastroClienteNFCeRetornaCod(total : currency = 0; cod : integer = 0) : string;
     function vercCountContigencia() : integer;
     procedure gravaAlteracao(altera : String);
     function buscaParamGeral(indice : integer; deafault : String) : String;
     procedure aumentaFonte(formula : TForm; dbgridr : boolean; opcao : integer; redimensionar : boolean = false);
     procedure adicionaRegistrosBloqueio();
     procedure dbgrid1Registro(var dbgrid44 : TDBGrid);
     Function testacpf(cpf:string):boolean;
     function isCPF(CPF: string): boolean;
     function lista11() : string;
     FUNCTION VE_CODISPIS(_CODISPIS, _ISPIS : String) : string;
     function buscaFieldDBgrid1(const nome : String; var grid : TDBGrid) : integer;
     function buscaFieldDBgrid(const nome : String; var grid : TDBGrid) : tfield;
     procedure ordernaDataSetVenda(const ordem1, valorLocate, sqlVenda : String; var dbgrid99 : TDBGrid; ordem2 : string = ''; ordenaCampos : boolean = true);
     procedure mostraValorDinheiroTela(const valor : currency);
     function buscaNomeSite() : String;
     function le_configTerminalWindows(posi : integer; padrao : string) : String;
     procedure exportaNFCeEmitidas();
     function verQuntDecimais(const campo, tabela : String) : integer;
     procedure limpaBloqueado(var quer : TIBQuery);
     function buscaDiasBloqueio() : integer;
     procedure adicionaRegistroDataBloqueio(const mostraMensagem, adicionaBloqueio  : boolean; var dias : integer; var quer : TIBQuery; buscaDiasSite : boolean = false);
     procedure acertarTamanhoDBGRID(var tabela : TDBGrid);
     function dataInglesToBrasil(const data : String) : string;
     function buscaProdutoCodCodBar(const cod : String) : String;
     function acha_vendaCCF(const ccf_caixa : String) : String;
     function entraXMLeRetornaChave(ent : String) : string;
     function cadastraFornec(const xml : String) : String;
     function insereDadosAdic(const xml : String) : smallint;
     procedure WriteToTXT(const arquivo, linha : string);
     function downloadNFE(chave : String) : boolean;
     function verValorUnidade(unidade : String) : currency;
     procedure lerDestXML(const arqXML : String; var mat : TStringList);
     procedure descamarcaVenda(const numVenda : String);
     function importaXMLnaEntrada1 : boolean;
     function cancelamentoDeNota(const nota : String) : String;
     procedure atualizaVendaDaOrdemDeServico(const cos_os, numVenda : string);
     function lerPosString(const valor : String;const sub : String; const posi : integer) : integer;
     function lerValorPipePrimeiro1(const valor : String; const num : Integer) : String;
     procedure LeNomesServicos();
     function lerServicoNoBdEcriaUmObjetoOrdem(const cod : String; var ordem : TOrdem) : boolean;
     function abreVendaSeparaPecasOrdemDeServico(const finaliza, orcamento : boolean) : boolean;
     Function RelSomatoria_T_(var lista1 : Tlist; dini, dfim : String; geral : currency) : AnsiString;
     procedure fichaDoProduto(sende1 : TObject;var te : String; const centroTipoLOJADEPOSITO : boolean);
     procedure imprimeOrdemDeServico(var ordem : TOrdem; const orcamento : boolean);
     procedure atualizaMensagemUsuario(const mens : String);
     procedure Descomprimir(ArquivoZip: TFileName; DiretorioDestino: string);
     procedure Comprimir(ArquivoCompacto: TFileName; Arquivos: array of TFileName);
     function retornaTipoDoCampo(campo, tabela : String) : String;
     function verificaSeExisteIndiceTrueExiste(const indiceName : String) : boolean;
     procedure iniciaDataset(var ibquery : TIBQuery; const sql : String);
     function retornaTamanhoDoCampoBD(const nomeCampo, tabela : String) : Smallint;
     FUNCTION VE_CUSTO(PCOMPRA, PVENDA : Currency; COD : String) : currency;
     procedure desmarcaVendaPaf(const numvenda : String);
     function trocaChar(texto, velho, novo:string):string;
     procedure limpaMemoria();
     function trocaDeUsuario() : boolean;
     function ImprimirPedidoVias(qtdVias : Smallint) : boolean;
     function formataChaveNFE(const chave : String) : String;
     function lerConfigIMPRESSORA()   : String;
     function allTrim(const texto : String) : String;
     function NomedoComputador: String;
     function buscaConfigTerminal(indice : Smallint;const default : String): String;
     function reorganizaClientes : boolean;
     procedure geraPgerais();
     procedure abreDataSetMemoriaEquivalencias();
     function primeiraLetraMaiuscula(const nome : string) : string;
     function reorganizaProdutos : boolean;
     function VE_PAIS() : String;
     FUNCTION ATU_ESTOQUE(ACAO : String; var lista : TItensAcumProd; cod1 : integer = 0) : boolean;
     function LE_ESTOQUE(PULA_REGISTRO, SO_VENDAS : boolean; var lista : TItensAcumProd; cod1 : integer = 0) : String;
     procedure VER_ESTOQUE(ACAO, MENS, MENS1 : String; cod : integer = 0);
     function localizar1(titulo:string;tabela:string;campos:string;retorno:string;esconde:string;localizarPor:string;OrdenarPor:string;editLocaliza:boolean;editavel:boolean;deletar:boolean;campoLocate:string;keyLocate: String;tamanho:integer;compnenteAlinhar: TObject):string;
     function CriaDiretorio(const NomeSubDir: string): boolean;
     function dataDoArquivo(const FileName: string): TDateTime;
     function verFornecedorStringList(xml : string) : TStringList;
     function insereFornec(var matriz : TStringList) : String;
     procedure copiaExecutavel();
     procedure mapearLPT1_em_rede();
     procedure copiaXMLEntrada(const xml, chave : String);
     function formataCNPJ(Const cnpj : String) : String;
     function importaXMLnaEntrada : boolean;
     function SincronizarExtoque1(CaminhoArq : String) : boolean;
     function receberSincronizacaoExtoque1(CaminhoArq : String) : boolean;
     function geraRelFechamento(const cod12 : integer; vendedor : String) : String;
     function recuperaChaveNFe(const nota : string) : string;
     function listaArquivos(const pasta : String) : tstringlist;
     function dadosAdicSped(xml : String) : tstringlist;
     procedure executaCalculadora();
     function GerarCodigo(Codigo: String; imagem1 : TImage) : integer;
     function verificaConexaoComInternetSeTiverTRUEsenaoFALSE : boolean;
     function verEquivalencia(cod : String) : String;
     procedure converteDados;
     procedure ResizeLabel(var Sender: TLabel);
     procedure adicionarExcecao;
     procedure SetRetornoBusca(ret : string);
     function IniciaNfe : boolean;
     function StrNum(const entra: string) :  string;
     function OrdenarValoresStringList(var valor_a_Ser_Ordenado : TStringList) : TStringList;
     function RetornaValorConfig(Config:string;posi:integer) : variant;
     function GerarPgeraisList(codUsu: string) : TStringList;
     function CompararStringLists(var v1: tstringlist;var v2 : tstringlist) : boolean;
     function GravaTexT(dire:string;conteudo:string) : boolean;
     function GetTheWindowsDirectory : string;
     function GeraNota(numNota:string;tipo:string;EnviarImpressora:string; opcao : Smallint) : boolean;
     procedure le_Venda(nota : String; var desconto : currency;var vendedor :String; var listprod : TItensProduto);
     function lista(var t: TObject; center : boolean) : string;
     function Parcelamento(Total : currency; Cliente : string; prazo : string) : TstringList;
     function LerIni(valor:string):string;
     function PreparaData(Valor: string): TDateTime;
     function ArredondaFinanceiro(Value: Currency; Decimals: integer): Currency;
     function novocod(gen: string) : string;
     function VerSeExisteConfig:boolean;
     function VerSeExisteGeneratorPeloNome(Const nome : String) : boolean;
     function dialogo(tipo:string;maxlengt : integer;ValorEntrada:string;tamanhocampo:integer;obrigatorio1:boolean;trocaletras:string;titulo:string;label1:string;default:string):string;
     function ArredondaTrunca(Value: Currency;decimais:integer): Extended;
     function TiraOuTrocaSubstring(StringDeEntrada:string;ValorTrocar:string;ValorQSeraSubstituido:string):string;
     function LerFormPato(index:integer; label1 : string; escSair : boolean; const padrao : string = '') : string;
     function LerIniToStringList:TStringList;
     function LerValorPGerais(NomeConfig:string;arr:TStringList):string;
     function CompletaOuRepete(const valorParaCompletar:AnsiString;const ValorFinal:AnsiString;valorParaRepetir:string;contadorDeRepeticao:integer):string;
     function RelatorioCabecalho(NomeEmpresa:string;NomeRelatorio:string;tamanho:integer):string;
     procedure informacao(posicao:integer;total:integer;informacao:string;novo:boolean;fechar:boolean;valorprogressao:integer);
     procedure CtrlResize(var Sender: TForm); export;
     function grelatoriocima(SQLGrupo:string;SQLFornec:string;SQLFabric:string;SQLCom2Filtros:string;SQLSemFiltros:string;cabecalho:string;NomeDaEmpresa:string;NomeDoRelatorio:string;colunas:string):boolean;
     procedure ExecFile(F: String);
     function Contido(substring:string;texto:string):boolean;
     function PerguntasRel(var query:tibquery;paramper:string;paramverifica:boolean;valorbd:string;valorstring:string) : boolean;
     function BuscaNomeBD(var query:tibquery;NomeCampo:string;NomeTabela:string;condicao:string) : string;
     procedure OrdenaCamposVenda(campos:string);
     procedure FormataCampos(query:Tibquery;qtdCasasDecimais:integer;CampoFormatoDiferente:string;qtd:integer);
     Function ConverteNumerico(valor:string):string;
     function ContaChar(estring:string;sub:string):string;
     function PosFinal(substr:string;Texto:string):integer;
     procedure CharSetRichEdit(var rich:TRichEdit);
     function BrowseForFolder(const browseTitle: String;  const initialFolder: String ='';  mayCreateNewFolder: Boolean = False) : String;
     procedure ResizeForms();
     function localizar(titulo:string;tabela:string;campos:string;retorno:string;esconde:string;localizarPor:string;OrdenarPor:string;editLocaliza:boolean;editavel:boolean;deletar:boolean;condicao:string;tamanho:integer;compnenteAlinhar: TObject):string;
     function busca(var dataset:tibquery;busca:string;retorno:string;campobusca:string;camposdataset:string):string;
     function procuraMultiplos(entradaDataset:string;valorParaComarar:string):boolean;
     function SomaCampoDBGRID(var dataset:tibquery;campo:string;dataini:TDateTime;datafim:TDateTime;dataIgual:TDateTime;NomeCampoDataParaComparar:string): currency;
     function valorPorExtenso(vlr: real): string;
     function centraliza(valor:string;repetir:string;tamanho:integer):string;
     function GeraAleatorio(valor:integer):string;
     function VerAcesso(param:string) : string;
     function DeletaChar(sub:string;texto:string):string;
     function LerConfig(valor:string;posi:integer) : string;
     function Criptografar(wStri: String): String;
     function DesCriptografar(wStri: String): String;
     function RetornaMaiorData(v1 : TDateTime; v2 : TDateTime) : TDateTime;
     function TimageToFileStream(caminho : string) : TFileStream;
     procedure GeraTemas;
     procedure ImprimeParcelamento(ini,fim,entrada,nota : string);
     function ExisteParcelamento(nota : string) : boolean;
     function QuebraLinhas(ini,fim,entrada:string; qtdQuebra:integer) : string;
     procedure Traca_Nome_Rota;
     procedure GeraCarne(nota,tipo : String);
     procedure Ibquery_to_clienteDataSet(var ibquer : TIBQuery; var cliente: TClientDataSet);
     function RetornaMaiorTstrings(entra:tstrings) :  string;
     procedure VerificaVersao_do_bd;
     FUNCTION Mensagem(Caption : String;Mensagem : string; FontSize : integer; fonteLetra : string; btOk : boolean; option : integer; color : TColor) : string;
     FUNCTION MensagemTextoInput(caption, default : string) : string;
     function Procura_em_Multiplos_Campos(var data_set : TIBQuery;Campo_separados_por_espaco, valorParaComparar : string) : boolean;
     procedure CentralizaNoFormulario(var compo : TWinControl; var send : tform);
     function verificaCodbar(cod, codbar : string; opcao : smallint) : String;
     procedure atualizaBD;
     procedure adicionaConfig(valorQueProvavelmenteExiste, NovoValor : string);
     function verificaPermissaoPagamento(const abreTelaBloqueado : boolean = true) : String;
     FUNCTION IMP_CODBAR(const cod : String) : boolean;
     function troca_str(texto, valor, novo : string) : string;
     procedure restartGeneratorSMALL(gen, valor : String);
     function incrementaGenSmall(nome, valor : String) : Integer;
     function gravaVendaSmallPendente(nota1 : string) : string;
     function verVendedor(numVendedor : String) : String;
     procedure marcarVendaExportada(nota : String);
     function atualizaAutomatico() : String;
     procedure atualizaHoraDoPCapatirDoServidor();
     function verSeExisteTabela(nome : String) : boolean;
     function testaChaveNFE(chave : String) : boolean;
     function checaCodbar(vx_cod : String) : boolean;
     function checaCodbar1(vx_cod : String) : String;
     function buscaCodbarRetornaCodigo(codbar : String; pergunta : boolean = false) : String;
     function buscaPorCodigotornaCodigoBarrasValido(const cod : String) : String;
     function verPermissaoDiaria(const ret : String) : String;
     function formataCPF(const cpf : String) : String;
     function buscaConfigNaPastaDoControlW(Const config_name : String; const default : string) : String;
     function buscaConfigNaPastaDoControlW1(Const config_name : String) : String;
     function GravaConfigNaPastaDoControlW(Const config_name : String; const default : string) : String;
     function verProdutoExisteRetornaNome(const cod : string; var nome : String) : boolean;
     procedure somaQTD_produto_ibquery1_sem_commit(cod : integer; var qtd, deposito : currency);
     function senhaDodia : boolean;
     procedure CriarAtalho(ANomeArquivo, AParametros, ADiretorioInicial,ANomedoAtalho, APastaDoAtalho: string);
     procedure buscaEquivalencia(codEx : String);
     procedure buscaEquivalencia1(codEx : String);
     FUNCTION GRAVA_MOV(PEDIDO : String; DATA : tdatetime; NF, TIPO, COD_CLI : String; GRAV_VENDA : boolean) : boolean;
     FUNCTION CANC_MOV(NUM_NF, TIPO : String) : boolean;
     function FORM_DATA_YY_MM_DD(data : TDateTime) : String;
     function logar(usu, senha : String) : boolean;
     function voltarLogin(var form : TForm) : boolean;
     function baixaEstoque(cod : String; quant : currency; destino : integer) : boolean;
     function verificaTamnhoCampoBD(tabela, campo : String; tamanhoComparar  : integer) : boolean;
     function addRegSite(emp1 : String; var quer : TIBQuery) : String;
     procedure procuraTimmer(var dataset : TIBQuery; caracter : char;const campo : String);
     procedure fazBackupDoBD(const rede : boolean);
     procedure criaArqTerminal();
     procedure redimensionaTelaDbgrid(var dbgrid : TDBGrid);
     procedure gravaConfigTerminal(const con : String);
     procedure transformaStringList(var li1, li2 : TStringList);
     function verificaSeExisteVenda(const nota : string) : boolean;
     function verificaSePodeVenderFracionado(cod : integer;unid : String; quant : currency) : boolean;
  end;

var
  funcoes: Tfuncoes;
  cont:integer;
  refori1, CRLF : string;
  lg_StartFolder: string;
  //function calculaVlrAproxImpostos(var lista1 : TList) : currency;
  function buscaChaveErroDeDuplicidade(erro : String) : String;
  Function testacpf(cpf:string):boolean;
  function calculaVlrAproxImpostos1(nota : String) : currency;
  function ContaChar1(estring:string;sub:string): integer;
  function ACHA_CODFORNEC(CPF_CNPJ, UF : String) : String;
  procedure informacao(posicao:integer;total:integer;informacao:string;novo:boolean;fechar:boolean;valorprogressao:integer);
  function StrNum(const entra: string) :  string;
  function PosFinal(substr:string;Texto:string):integer;
  function Contido(substring:string;texto:string):boolean;
  function CompletaOuRepete(const valorParaCompletar:AnsiString;const ValorFinal:AnsiString;valorParaRepetir:string;contadorDeRepeticao:integer):string;
  function Arredonda(valor : currency; decimais:integer) : currency;
  function WWMessage(flmessage: String; flType: TMsgDlgType; flbutton: TMsgDlgButtons; flColor: TColor; flBold, flItalic: boolean;WWFormColor:TColor): String;
  function GravarConfig(valor:string;AserGravado:string;posi:integer) : string;
  function retornaPos(valor:string;sub:string;posi:integer) : integer;
  function lancaValorMinimo(total:currency;minimo:currency;Msg:string) : currency;
  Procedure FileCopy( Const sourcefilename, targetfilename: String );
  function VerificaRegistro(param : integer; var bloq : boolean) : boolean;
  function HexToTColor(sColor : string) : TColor;
  function Reorganizar : boolean;
  procedure GeraParcelamento(codvenda,formpagto,codcliente,nomecliente,vendedor,codgru : string ;parcelas,periodo : integer;vencimento1 : TDateTime;valorp : Currency);
  procedure addRelatorioForm19(Adicionar : string);
  function JustificarStrings(ent: string;qtd: integer) : string;
  function VerificaAcesso_Se_Nao_tiver_Nenhum_bloqueio_true_senao_false : boolean;
  function RetornaAcessoUsuario : integer;
  function StringToInteger(Ent : String) : integer;
  function ValidaCNPJ(CNPJ: string): Boolean;
  function ValidaCPF(sCPF: string): boolean;
  function iif(lTest:Boolean; vExpr1,vExpr2:Variant):Variant;
  function VerificaCampoTabela(NomeCampo, tabela : string) : boolean;
  procedure Retorna_Array_de_Numero_de_Notas(var mat : TStringList; notas : string; const separador : String = ' ');
  FUNCTION STR_ALFA(PAR : string) : string;
  function RetornaValorStringList(var ent : TStringList; estring : string) : string;
  function Incrementa_Generator(Gen_name : string; valor_incremento : integer) : string;
  procedure EmptyTList(Var AList: TList);
  function verificaSeTemImpressora() : boolean;
  function formataDataDDMMYY(data : tdatetime) : String;
  function MessageText(wmessage: String; flColor: TColor; flBold, flItalic: boolean;WWFormColor:TColor): String;
  function reStartGenerator(nome : string; Valor : integer): String;
  function gravaErrosNoArquivo(erro, formulario, linha, funcao : String) : String;
  function FileAgeCreate(const FileName: string): String;
  function maior(v1, v2 : variant) : variant;
  FUNCTION DIGEAN(vx_cod : string) : string;
  function GetFileList(const Path: string): TStringList;
  function formataCurrency(const valor : currency) : String ;
  procedure criaPasta(const pasta : String);
  function checaCodbar(vx_cod : String) : boolean;
  function dialogo(tipo:string;maxlengt : integer;ValorEntrada:string;tamanhocampo:integer;obrigatorio1:boolean;trocaletras:string;titulo:string;label1:string;default:string):string;
  procedure LE_CAMPOS(var mat : TStringList;LIN : String;const separador : String; criaMAT : boolean = true);
  procedure completaStringList(var mat : TStringList; qtd : integer);

//  function enviNFCe(const perg : string = '') : boolean;

const
  diasParaBloquear : integer = 14;
  site  : String = 'http://controlw.zz.vc';
  site1 : String = 'http://controlw.tk';
  site2 : String = 'http://controlw.blog.br';

implementation

uses Unit1, Math, dialog, formpagtoformulario, StrUtils,
  mensagem,  relatorio, principal, Unit2, localizar,
  buscaSelecao, Menus, Unit38, caixaLista, imprime1,jpeg, Unit42, dm1,
  subconsulta, vendas, nfe, Unit48, login, DateUtils, zlib, envicupom, untNFCe,
  Unit57, cadCli, cadCli1, dadosTransp;

{$R *.dfm}
procedure Tfuncoes.descamarcaVenda(const numVenda : String);
begin
  dm.IBQuery1.Close;
  dm.IBQuery1.SQL.Text := 'update venda set exportado = 0 where nota = :nota';
  dm.IBQuery1.ParamByName('nota').AsString := numVenda;
  dm.IBQuery1.ExecSQL;
  if dm.IBQuery1.Transaction.InTransaction then dm.IBQuery1.Transaction.Commit;
end;

function Tfuncoes.dataInglesToBrasil(const data : String) : string;
begin
  //2015-01-01
  Result := '';
  Result := copy(data, 9, 2) + '/' + copy(data, 6, 2) + '/' + copy(data, 1, 4)
end;

function Tfuncoes.buscaXMl(const path : String; novo : boolean = true) : boolean;
var
  lista, arq : TStringList;
  ini, fim : integer;
  cnpj, cnpj1, emitNome, cNF, dEMI     : string;
begin
  Result := true;
  lista := listaArquivos(path + '*.xml');
  arq    := TStringList.Create;

  if novo then begin
    form33 := tform33.Create(self);
    form33.Caption := 'Consulta de XML - F8 Download de XML';
    form33.ClientDataSet1.FieldDefs.Clear;
    form33.ClientDataSet1.FieldDefs.Add('arq', ftString, 60);
    form33.ClientDataSet1.FieldDefs.Add('ARQUIVO', ftString, 50);
    form33.ClientDataSet1.CreateDataSet;
  end;
  form33.ClientDataSet1.EmptyDataSet;
  form33.ClientDataSet1.FieldByName('arq').Visible := false;
  form33.DataSource1.DataSet := form33.ClientDataSet1;
  form33.DBGrid1.DataSource := form33.DataSource1;
  form33.campobusca := 'arq';

  dm.IBselect.Close;
  dm.IBselect.SQL.Text := 'select cnpj from registro';
  dm.IBselect.Open;

  cnpj := funcoes.StrNum(dm.IBselect.fieldbyname('cnpj').AsString);
  dm.IBselect.Close;
  //dm.ACBrNFe.NotasFiscais.Clear;

  fim := lista.Count - 1;
  for ini := 0 to fim do
    begin
      arq.Clear;
      arq.LoadFromFile(path + lista[ini]);
      cnpj1 := Le_Nodo('dest', arq.GetText);
      cnpj1 := IfThen(funcoes.Contido('CNPJ', cnpj1), Le_Nodo('CNPJ', cnpj1), Le_Nodo('CPF', cnpj1));
      //dm.ACBrNFe.NotasFiscais.LoadFromFile(path + lista[ini]);
      //if cnpj = cnpj1 then
      if true then
        begin
          cNF  := Le_Nodo('nNF', arq.GetText);
          dEMI := Le_Nodo('dEmi', arq.GetText);
          emitNome := Le_Nodo('emit', arq.GetText);
          emitNome := Le_Nodo('xNome', emitNome);
          Form33.ClientDataSet1.Insert;
          form33.ClientDataSet1.FieldByName('arq').AsString := lista[ini];
          form33.ClientDataSet1.FieldByName('arquivo').AsString := cNF + ' ' + dEMI + ' ' + emitNome;
          form33.ClientDataSet1.Post;
        end;
      //dm.ACBrNFe.NotasFiscais.Clear;
    end;
  funcoes.retornobusca := '';
  if novo then begin
    form33.ShowModal;
    form33.ClientDataSet1.EmptyDataSet;

    form33.ClientDataSet1.Close;
    form33.Free;
  end;
  lista.Free;
end;

procedure criaPasta(const pasta : String);
begin
  if not DirectoryExists(pasta) then forceDirectories(pasta);
end;

function Tfuncoes.verificaSeExisteVenda(const nota : string) : boolean;
begin
  Result := false;
  dm.IBselect.Close;
  dm.IBselect.SQL.Text := 'select nota from venda where (nota = :nota) and (cancelado = 0)';
  dm.IBselect.ParamByName('nota').AsString := nota;
  dm.IBselect.Open;

  if dm.IBselect.IsEmpty then
    begin
      dm.IBselect.Close;
      ShowMessage('Venda Nº ' + nota + ' Não Encontrada' );
      exit;
    end
  else Result := true;
  dm.IBselect.Close;
end;

procedure Tfuncoes.transformaStringList(var li1, li2 : TStringList);
var
  ini, fim : integer;
begin
  li2 := TStringList.Create;
  fim := li1.Count -1;
  for ini := 0 to fim do
    begin
      li2.Values[IntToStr(ini)] := li1[ini];
    end;
end;

function Tfuncoes.cancelamentoDeNota(const nota : String) : String;
var
  campo, sim, nota1 : string;
  data : TDateTime;
  total, entrada : currency;
  enc : boolean;
begin
  enc  := true;
  nota1 := '0';
  if nota = '' then
    begin
      nota1 := IntToStr(StrToIntDef(Incrementa_Generator('venda', 0), 1));

      nota1 := funcoes.dialogo('generico',0,'1234567890'+#8,100,false,'',Application.Title,'Informe o Número Da Nota:', nota1);
      if (nota1 = '*') or (nota1 = '') then exit;
    end
  else nota1 := nota;    

  Result := nota1;

  dm.IBQuery2.Close;
  dm.IBQuery2.SQL.Clear;
  dm.IBQuery2.SQL.Add('select * from venda where (nota = :nota) and (cancelado = 0)');
  dm.IBQuery2.ParamByName('nota').AsString := nota1;
  dm.IBQuery2.Open;

  if dm.IBQuery2.IsEmpty then
    begin
      enc := false;
      dm.IBQuery2.Close;
      //ShowMessage('Nota Não Encontrada!');
      //nota := '*';
      //exit;
    end;
  sim := '';

  dm.IBQuery1.Close;
  dm.IBQuery1.SQL.Clear;
  dm.IBQuery1.SQL.Add('select nota from contasreceber where (nota = :nota)');
  dm.IBQuery1.ParamByName('nota').AsString := nota1;
  dm.IBQuery1.Open;

  // se existe parcelamento na conta do cliente e não foi encontrado venda
  if ((not dm.IBQuery1.IsEmpty) and (not enc)) then
    begin
      sim := funcoes.dialogo('generico',0,'SN'+#8,30,true,'S',Application.Title,'Deseja Cancelar o Parcelamento da Nota '+nota1+' ? Sim ou Não (S/N)?','');
      if sim = '*' then exit;
      if sim = 'S' then
        begin
          try
            dm.IBQuery1.Close;
            dm.IBQuery1.SQL.Clear;
            dm.IBQuery1.SQL.Add('delete from contasreceber where (nota = :nota)');
            dm.IBQuery1.ParamByName('nota').AsString := nota1;
            dm.IBQuery1.ExecSQL;

            dm.IBQuery1.Transaction.Commit;
          except
            on e : exception do
              begin
                ShowMessage('Ocorreu um Erro: ' + e.Message + #13 + #10 + 'Tente Novamente');
                exit;
              end;
          end;
        end;
      dm.IBQuery1.Close;
      exit;
    end
   else if ((dm.IBQuery2.IsEmpty) and (dm.IBQuery1.IsEmpty)) then
     begin
       dm.IBQuery2.Close;
       dm.IBQuery1.Close;
       ShowMessage('Nota Não Encontrada!');
       exit;
     end;

  dm.IBQuery1.Close;
  sim := '';
  while sim = '' do  sim := funcoes.dialogo('generico',0,'SN'+#8,30,false,'S',Application.Title,'Confirma Cancelamento da Nota '+nota1+' ? Sim ou Não (S/N)?','');
  if (sim = 'N') or (sim = '') or (sim = '*') then
    begin
      dm.IBQuery2.Close;
      exit;
    end;

  if dm.IBQuery2.FieldByName('data').AsDateTime <> form22.datamov then
    begin
      sim := '';
      while sim = '' do sim := funcoes.dialogo('generico',0,'SN'+#8,30,false,'S',Application.Title,'Atenção, a Nota '+nota1+' é do dia '+FormatDateTime('dd/mm/yy',dm.IBQuery2.FieldByName('data').AsDateTime)+', Cancelar Mesmo Assim ? Sim ou Não (S/N)?','');
      if (sim = 'N') or (sim = '') then
        begin
          dm.IBQuery2.Close;
          exit;
        end;
    end;

//  dm.IBQuery1.Transaction.StartTransaction;

  total   := dm.IBQuery2.FieldByName('total').AsCurrency;
  entrada := dm.IBQuery2.FieldByName('entrada').AsCurrency;

  if ((dm.IBQuery2.FieldByName('codhis').AsString = '1') or (entrada > 0)) then
    begin
      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add('update caixa set entrada = entrada - :ent where (historico like '+QuotedStr('%VENDAS DO DIA%')+') and (cast(data as date) = :d) ');
      if entrada > 0 then total := entrada;
      dm.IBQuery1.ParamByName('ent').AsCurrency := total;
      dm.IBQuery1.ParamByName('d').AsDateTime := dm.IBQuery2.FieldByName('data').AsDateTime;
      dm.IBQuery1.ExecSQL;
    end;

  if (entrada > 0) and (dm.IBQuery2.FieldByName('codhis').AsString <> '1') then
    begin
      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Text := 'delete from caixa where historico like :nome';
      dm.IBQuery1.ParamByName('nome').AsString := Nota1 + '-%';
      dm.IBQuery1.ExecSQL;
    end;

  dm.IBQuery1.Close;
  dm.IBQuery1.SQL.Clear;
  dm.IBQuery1.SQL.Add('update venda set cancelado = :canc where nota = :nota');
  dm.IBQuery1.ParamByName('canc').AsString := Form22.codusario;
  dm.IBQuery1.ParamByName('nota').AsString := Nota1;
  dm.IBQuery1.ExecSQL;

  {dm.IBQuery1.Close;
  dm.IBQuery1.SQL.Clear;
  dm.IBQuery1.SQL.Add('update item_venda set cancelado = :canc where nota = :nota');
  dm.IBQuery1.ParamByName('canc').AsString := Form22.codusario;
  dm.IBQuery1.ParamByName('nota').AsString := nota1;
  dm.IBQuery1.ExecSQL;}

  dm.IBQuery2.Close;
  dm.IBQuery2.SQL.Clear;
  dm.IBQuery2.SQL.Add('select * from item_venda where nota = :nota');
  dm.IBQuery2.ParamByName('nota').AsString := nota1;
  dm.IBQuery2.Open;
  dm.IBQuery2.First;

  while not dm.IBQuery2.Eof do
    begin
      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      if dm.IBQuery2.FieldByName('origem').AsInteger = 1 then campo := 'quant'
        else campo := 'deposito';

      dm.IBQuery1.SQL.Add('update produto set '+campo+' = '+campo+' + :quant where cod= :cod');
      dm.IBQuery1.ParamByName('quant').AsCurrency := dm.IBQuery2.fieldbyname('quant').AsCurrency;
      dm.IBQuery1.ParamByName('cod').AsString := dm.IBQuery2.fieldbyname('cod').AsString;
      dm.IBQuery1.ExecSQL;

      dm.IBQuery2.Next;
    end;

  dm.IBQuery1.Close;
  dm.IBQuery1.SQL.Clear;
  dm.IBQuery1.SQL.Add('delete from contasreceber where nota = :nota');
  dm.IBQuery1.ParamByName('nota').AsString := nota1;
  dm.IBQuery1.ExecSQL;

  try
    dm.IBQuery1.Transaction.Commit;
    dm.IBQuery2.Close;
    ShowMessage('Os Itens da Nota '+nota1+' Foram Devolvidos Para o Estoque.');
  except
    dm.IBQuery1.Transaction.Rollback;
    WWMessage('A Venda Não Pode Ser Cancelada. Tente Novamente!',mtError,[mbok],clYellow,true,false,clRed);
  end;

  dm.IBselect.Close;
  dm.IBselect.SQL.Clear;
  dm.IBselect.SQL.Add('select * from contasreceber where nota = :nota');
  dm.IBselect.ParamByName('nota').AsString := nota1;
  dm.IBselect.Open;

  if not dm.IBselect.IsEmpty then
    begin
      dm.IBQuery2.Close;
      dm.IBQuery2.SQL.Clear;
      dm.IBQuery2.SQL.Add('delete from contasreceber where nota = :nota');
      dm.IBQuery2.ParamByName('nota').AsString := nota1;
      dm.IBQuery2.ExecSQL;
      dm.IBQuery2.Transaction.Commit;
      dm.IBselect.Close;
    end;
end;

procedure Tfuncoes.atualizaVendaDaOrdemDeServico(const cos_os, numVenda : string);
begin
  dm.IBQuery1.Close;
  dm.IBQuery1.SQL.Text := 'update servico set venda = :venda where cod = :cod';
  dm.IBQuery1.ParamByName('venda').AsString := numVenda;
  dm.IBQuery1.ParamByName('cod').AsString   := cos_os;
  dm.IBQuery1.ExecSQL;

  dm.IBQuery1.Transaction.Commit;
end;

function Tfuncoes.lerValorPipePrimeiro1(const valor : String; const num : Integer) : String;
var
  ini, fim : integer;
begin
  ini := lerPosString(valor, '|', num) + 1;
  fim := lerPosString(valor, '|', num + 1);
  fim := fim - ini;
  Result := copy(valor, ini, fim);
end;

function Tfuncoes.lerPosString(const valor : String;const sub : String; const posi : integer) : integer;
var
  ini, fim, cont : Integer;
begin
  fim := length(valor);
  cont := 0;
  for ini := 1 to fim do
    begin
      if sub = valor[ini] then cont := cont + 1;
      if cont = posi then break;
    end;
  Result := ini;  
end;

procedure Tfuncoes.LeNomesServicos();
begin
  form22.nomesServico := TStringList.Create;
  form22.nomesServico.Values['1'] := funcoes.lerValorPipePrimeiro1(ConfParamGerais[35], 1);
  form22.nomesServico.Values['2'] := funcoes.lerValorPipePrimeiro1(ConfParamGerais[35], 2);
  form22.nomesServico.Values['3'] := funcoes.lerValorPipePrimeiro1(ConfParamGerais[35], 3);
  form22.nomesServico.Values['4'] := funcoes.lerValorPipePrimeiro1(ConfParamGerais[35], 4);
  form22.nomesServico.Values['5'] := funcoes.lerValorPipePrimeiro1(ConfParamGerais[35], 5);
  form22.nomesServico.Values['6'] := funcoes.lerValorPipePrimeiro1(ConfParamGerais[35], 6);
end;

function Tfuncoes.lerServicoNoBdEcriaUmObjetoOrdem(const cod : String; var ordem : TOrdem) : boolean;
begin
  Result := False;
  dm.IBselect.Close;
  dm.IBselect.SQL.Text := 'select venda, h_sai, cod, saida, cliente, data, equip, marca, modelo, defeito, obs, serie, tecnico, usuario, h_ent from servico where cod = :cod';
  dm.IBselect.ParamByName('cod').AsString := cod;
  dm.IBselect.Open;

  if dm.IBselect.IsEmpty then
    begin
      dm.IBselect.Close;
      ShowMessage('Nota ' + cod + ' Não Encontrada');
      exit;
    end;

  ordem := TOrdem.Create;
  ordem.cod     := dm.IBselect.fieldbyname('cod').AsInteger;
  ordem.saida   := dm.IBselect.fieldbyname('saida').AsDateTime;
  ordem.cliente := dm.IBselect.fieldbyname('cliente').AsInteger;
  ordem.data    := dm.IBselect.fieldbyname('data').AsDateTime;
  ordem.equipe  := dm.IBselect.fieldbyname('equip').AsString;
  ordem.marca   := dm.IBselect.fieldbyname('marca').AsString;
  ordem.modelo  := dm.IBselect.fieldbyname('modelo').AsString;
  ordem.defeito := dm.IBselect.fieldbyname('defeito').AsString;
  ordem.obs     := dm.IBselect.fieldbyname('obs').AsString;
  ordem.serie   := dm.IBselect.fieldbyname('serie').AsString;
  ordem.tecnico := dm.IBselect.fieldbyname('tecnico').AsString;
  ordem.usuario := dm.IBselect.fieldbyname('usuario').AsInteger;
  ordem.venda   := IfThen(dm.IBselect.fieldbyname('venda').AsString = '', 0, dm.IBselect.fieldbyname('venda').AsInteger);
  ordem._ent    := FormatDateTime('hh:mm', dm.IBselect.fieldbyname('h_ent').AsDateTime);
  ordem.h_saida := FormatDateTime('hh:mm', dm.IBselect.fieldbyname('h_sai').AsDateTime);
  dm.IBselect.Close;
  Result := true;
end;

function Tfuncoes.abreVendaSeparaPecasOrdemDeServico(const finaliza, orcamento : boolean) : boolean;
begin
  Result := true;
  form20 := tform20.Create(self);
  form20.Saiu := false;
  form20.finaliza            := finaliza;
  if not finaliza then form20.JsEditInteiro1.Text := dm.TabelaOrdemCOD.AsString;
  form20.separaVendaOrcamento := orcamento;
  if orcamento then
    begin
      form20.Modo_Orcamento := true;
      form20.Modo_Venda     := false;
      form20.finaliza       := true;
    end
  else form20.Modo_Venda  := true;  
  form20.COD_SERVICO         := dm.TabelaOrdemCOD.AsString;
  form20.JsEdit3.Text        := dm.TabelaOrdemCLIENTE.AsString;
  form20.JsEdit2.Text        := dm.TabelaOrdemVENDEDOR.AsString;
  form20.separaPecas := true;
  //form20.Modo_Venda  := true;
  funcoes.CtrlResize(tform(form20));

  dm.IBselect.Close;
  dm.IBselect.SQL.Text := 'select nome from cliente where cod = :cod';
  dm.IBselect.ParamByName('cod').AsString := dm.TabelaOrdemCLIENTE.AsString;
  dm.IBselect.Open;

  form20.LabelVenda.Caption := dm.TabelaOrdemCLIENTE.AsString + ' - ' + dm.IBselect.fieldbyname('nome').AsString;
  dm.IBselect.Close;
  form20.ShowModal;
  if form20.Saiu then Result := FALSE;
  form20.Free;
end;

Function Tfuncoes.RelSomatoria_T_(var lista1 : Tlist; dini, dfim : String; geral : currency) : AnsiString;
 var t1 : currency;
 prod, prod1 : Ptr_Produto;
begin
  t1 := 0;
  Result := '';
  Result := 'PERIODO: ' + FormatDateTime('dd/mm/yy',StrToDateTime(DINI)) + ' A ' + FormatDateTime('dd/mm/yy',StrToDateTime(dfim)) + '     Quant.       Preco ' + '                           ' + #13 + #10 ;
  Result := Result + funcoes.CompletaOuRepete('','','-',56) + #13 + #10;
  prod := lista1.Items[0]; //VENDA PROD
  prod1 := lista1.Items[1]; //COMPRA PROD1
  Result := Result + 'TOTAL A PRECO DE COMPRA..:' + funcoes.CompletaOuRepete('',FormatCurr('#,###,###0.00', prod1.tot3), ' ', 13) + funcoes.CompletaOuRepete('',FormatCurr('#,###,###0.00', Arredonda(prod1.tot2 * prod1.tot3, 2)), ' ', 13) + #13 + #10;
  Result := Result + 'TOTAL A PRECO DE VENDA...:' + funcoes.CompletaOuRepete('',FormatCurr('#,###,###0.00', prod.tot3), ' ', 13) + funcoes.CompletaOuRepete('',FormatCurr('#,###,###0.00', Arredonda(prod.tot2 * prod.tot3, 2)), ' ', 13) + #13 + #10;
  t1 := Arredonda(prod1.tot2 * prod1.tot3, 2) - Arredonda(prod.tot2 * prod.tot3, 2);
  Result := Result + 'LUCRO BRUTO S/VENDA......: ------------' + funcoes.CompletaOuRepete('',FormatCurr('#,###,###0.00', t1), ' ', 13) + #13 + #10;
  Result := Result + 'PRECO MEDIO DE COMPRA....: ------------' + funcoes.CompletaOuRepete('',FormatCurr('#,###,###0.00', prod1.tot2), ' ', 13) + #13 + #10;
  Result := Result + 'PRECO MEDIO DE VENDA.....: ------------' + funcoes.CompletaOuRepete('',FormatCurr('#,###,###0.00', prod.tot2), ' ', 13) + #13 + #10;
  Result := Result + 'ESTOQUE A PRECO DE COMPRA:' + funcoes.CompletaOuRepete('',FormatCurr('#,###,###0.00', prod.tot1), ' ', 13) + funcoes.CompletaOuRepete('',FormatCurr('#,###,###0.00', Arredonda( prod.tot1 * prod.qtd_atual, 2)), ' ', 13) + #13 + #10;
  Result := Result + 'ESTOQUE A PRECO MEDIO....:' + funcoes.CompletaOuRepete('',FormatCurr('#,###,###0.00', prod1.tot2), ' ', 13) + funcoes.CompletaOuRepete('',FormatCurr('#,###,###0.00', Arredonda(prod1.tot2 * prod.qtd_atual, 2)), ' ', 13) + #13 + #10;
  Result := Result + funcoes.CompletaOuRepete('','','-',56) + #13 + #10;
  Dispose(prod);
  Dispose(prod1);
end;

procedure Tfuncoes.fichaDoProduto(sende1 : TObject;var te : String; const centroTipoLOJADEPOSITO : boolean);
var cod1, dini, dfim, DEST, origem : string;
   fat : integer;
   datini, ini, fim, ret : TDateTime;
   tot, geral, saldoAnteriorLoja, saldoAnteriorDeposito : currency;
   prod : Ptr_Produto;
   lista : TList;
   lab : TLabel;
   //lis : TStringList;
begin
  if te = '' then
    begin
      cod1 := funcoes.dialogo('generico',0,'1234567890,.'+#8,50,false,'',Application.Title,'Qual o Cód do Produto?','');
      if (cod1 = '*') or (cod1 = '') then exit;

      te := cod1;
    end;

  ini := form22.datamov - 180;
  fim := form22.datamov;

  dini := funcoes.dialogo('data',0,'',2,true,'',Application.Title,'Qual a Data Inicial de Movimento?',formatadataddmmyy(ini));
  if dini = '*' then exit;

  dfim := funcoes.dialogo('data',0,'',2,true,'',Application.Title,'Qual a Data Final de Movimento?',formatadataddmmyy(fim));
  if dfim = '*' then exit;

  cod1 := funcoes.dialogo('generico',0,'123'+#8,50,false,'S',Application.Title,'Qual o Critério de Seleção da Mercadoria (1-Loja 2-Deposito 3-Loja + Deposito)?','');
  if cod1 = '*' then exit;

  if cod1 = '' then
    begin
      cod1 := '*';
      form39 := tform39.Create(self);
      form39.ListBox1.Items.Add('3- LOJA + DEPOSITO');
      form39.ListBox1.Items.Add('1- LOJA');
      form39.ListBox1.Items.Add('2- DEPOSITO');
      form39.Position := poScreenCenter;
      cod1 := funcoes.lista(sende1, centroTipoLOJADEPOSITO);
      if cod1 = '*' then exit;

    end;

  cod1 := trim(cod1);
  form33 := TForm33.Create(self);

  form33.Caption := 'Ficha do Produto: ' + te + '-' + funcoes.BuscaNomeBD(dm.ibquery2, 'nome', 'produto','where cod = ' + te);

  form33.ClientDataSet1.FieldDefs.Add('DATA',ftDate);
  form33.ClientDataSet1.FieldDefs.Add('HISTORICO',ftString,40);
  form33.ClientDataSet1.FieldDefs.Add('PRECO',ftCurrency);
  form33.ClientDataSet1.FieldDefs.Add('QUANT',ftCurrency);
  form33.ClientDataSet1.FieldDefs.Add('SALDO',ftCurrency);
  form33.ClientDataSet1.FieldDefs.Add('cont',ftInteger);

  form33.DataSource1.DataSet := form33.ClientDataSet1;
  Form33.DBGrid1.DataSource := form33.DataSource1;

  form33.ClientDataSet1.CreateDataSet;
  form33.ClientDataSet1.LogChanges := false;

  TCurrencyField(form33.ClientDataSet1.FieldByName('preco')).currency := false;
  TCurrencyField(form33.ClientDataSet1.FieldByName('quant')).currency := false;
  TCurrencyField(form33.ClientDataSet1.FieldByName('saldo')).currency := false;

  with form33.ClientDataSet1.IndexDefs.AddIndexDef do
    begin
      Fields := 'cont';
      Name := 'indice';
    end;

  //form33.ClientDataSet1.IndexName := 'indice';
  tot := 0;
  geral := 0;
  saldoAnteriorLoja := 0;
  saldoAnteriorDeposito := 0;
  datini := StrToDateTime(dini);

  dm.IBselect.Close;
  dm.IBselect.SQL.Clear;
  dm.IBselect.SQL.Add('select sad, sal from produto where cod = :cod');
  dm.IBselect.ParamByName('cod').AsString := te;
  dm.IBselect.Open;
  saldoAnteriorLoja := dm.IBselect.fieldbyname('sal').AsCurrency;
  saldoAnteriorDeposito := dm.IBselect.fieldbyname('sad').AsCurrency;

  if cod1 = '3' then cod1 := '1-2';
  origem := QuotedStr(cod1);  //origem loja + depósito - valor padrão
  if pos('1', origem) > 0 then
     geral := geral + saldoAnteriorLoja;
  if pos('2', origem) > 0 then 
     geral := geral + saldoAnteriorDeposito;


  form33.ClientDataSet1.Open;
  form33.ClientDataSet1.Edit;
  form33.ClientDataSet1.Insert;
  form33.ClientDataSet1.FieldByName('data').AsDateTime := datini - 1;
  form33.ClientDataSet1.FieldByName('historico').AsString := 'SALDO ANTERIOR';
  form33.ClientDataSet1.FieldByName('preco').AsCurrency := 0;
  form33.ClientDataSet1.FieldByName('quant').AsCurrency := 0;
  form33.ClientDataSet1.FieldByName('cont').AsInteger := Form33.ClientDataSet1.RecordCount + 1;
  form33.ClientDataSet1.FieldByName('saldo').AsCurrency := 0;
  form33.ClientDataSet1.Post;


  //ENTRADAS
  //soma os lançamentos anteriores à data inicial no saldo anterior
  prod := new(ptr_produto);
  prod.tot1 := 0;
  prod.tot2 := 0;
  prod.tot3 := 0;

  dm.IBselect.Close;
  dm.IBselect.SQL.Clear;
  dm.IBselect.SQL.Add('SELECT SUM(QUANT) AS saldoanterior from item_entrada where (data < :ini) and ' +
    ' (destino = 1) and (cod = ' + te + ')');
  dm.IBselect.ParamByName('ini').AsDateTime := datini;
  dm.IBselect.Open;
  saldoAnteriorLoja := saldoAnteriorLoja + dm.IBselect.fieldbyname('saldoanterior').AsCurrency;

  dm.IBselect.Close;
  dm.IBselect.SQL.Clear;
  dm.IBselect.SQL.Add('SELECT SUM(QUANT) AS saldoanterior from item_entrada where (data < :ini) and' +
    ' (destino <> 1) and (cod = ' + te + ')');
  dm.IBselect.ParamByName('ini').AsDateTime := datini;
  dm.IBselect.Open;
  saldoAnteriorDeposito := saldoAnteriorDeposito + dm.IBselect.fieldbyname('saldoanterior').AsCurrency;

  //pega os lançamentos a partir da data inicial
  dm.IBselect.Close;
  dm.IBselect.SQL.Clear;
  dm.IBselect.SQL.Add('select cod, p_compra, destino, quant, nota, data from item_entrada where (data >= :ini) and (cod = ' +
  te + ') and ' + origem + ' containing cast(destino as varchar(1))');
  dm.IBselect.ParamByName('ini').AsDateTime := datini;
  dm.IBselect.Open;

  while not dm.IBselect.Eof do
    begin
      geral := geral + (dm.IBselect.fieldbyname('quant').asCurrency);

	    prod.tot2 := prod.tot2 + Arredonda((dm.IBselect.fieldbyname('quant').asCurrency * dm.IBselect.fieldbyname('p_compra').asCurrency), 2);
      prod.tot3 := prod.tot3 + dm.IBselect.fieldbyname('quant').asCurrency;

      form33.ClientDataSet1.Open;
      form33.ClientDataSet1.Edit;
      form33.ClientDataSet1.Insert;
      form33.ClientDataSet1.FieldByName('data').AsDateTime := dm.IBselect.fieldbyname('data').AsDateTime;
      form33.ClientDataSet1.FieldByName('historico').AsString := 'ENTRADA NOTA ' + dm.IBselect.fieldbyname('nota').AsString +
	    iif(dm.IBselect.fieldbyname('destino').AsInteger = 1, ' LOJA', ' DEPOSITO');
      form33.ClientDataSet1.FieldByName('preco').AsCurrency := dm.IBselect.fieldbyname('p_compra').AsCurrency;
      form33.ClientDataSet1.FieldByName('quant').AsCurrency := dm.IBselect.fieldbyname('quant').asCurrency;
      form33.ClientDataSet1.FieldByName('saldo').AsCurrency := geral;
      form33.ClientDataSet1.FieldByName('cont').AsInteger := Form33.ClientDataSet1.RecordCount + 1;
      form33.ClientDataSet1.Post;
      dm.IBselect.Next;
    end;
  dm.IBselect.Close;

  if prod.tot2 > 0 then prod.tot2 := Arredonda(prod.tot2 / prod.tot3, 2);

  lista := tlist.Create;
  lista.Add(prod);

  //VENDAS
  //soma os lançamentos anteriores à data inicial no saldo anterior
  dm.IBselect.Close;
  dm.IBselect.SQL.Clear;
  dm.IBselect.SQL.Add('SELECT SUM(QUANT) AS saldoanterior from item_venda where (data < :ini) and ' +
    ' (origem = 1) and (cod = ' + te + ')');
  dm.IBselect.ParamByName('ini').AsDateTime := datini;
  dm.IBselect.Open;
  saldoAnteriorLoja := saldoAnteriorLoja - dm.IBselect.fieldbyname('saldoanterior').AsCurrency;

  dm.IBselect.Close;
  dm.IBselect.SQL.Clear;
  dm.IBselect.SQL.Add('SELECT SUM(QUANT) AS saldoanterior from item_venda where (data < :ini) and ' +
    '(origem <> 1) and (cod = ' + te + ')');
  dm.IBselect.ParamByName('ini').AsDateTime := datini;
  dm.IBselect.Open;
  saldoAnteriorDeposito := saldoAnteriorDeposito - dm.IBselect.fieldbyname('saldoanterior').AsCurrency;

  //pega os lançamentos a partir da data inicial
  dm.IBselect.Close;
  dm.IBselect.SQL.Clear;
  dm.IBselect.SQL.Add('select i.data,i.p_venda,i.quant,i.total,i.nota, i.origem, (select nome from formpagto where cod=v.codhis) ' +
  'from item_venda i,venda v where (v.cancelado = 0) and(i.nota=v.nota) and (i.cod = ' +
  te + ') and ' + origem + ' containing cast(i.origem as varchar(1)) and (i.data >= :ini) order by data, nota' );
  dm.IBselect.ParamByName('ini').AsDateTime := datini;
  dm.IBselect.Open;
  prod := new(ptr_produto);
  prod.qtd_atual := 0;
  prod.tot1 := 0;
  prod.tot2 := 0;
  prod.tot3 := 0;

  while not dm.IBselect.Eof do
    begin
      geral := geral + (- dm.IBselect.fieldbyname('quant').asCurrency);

      prod.nome := 'TOTAL PRECO DE VENDA: ';
      prod.tot2 := prod.tot2 + Arredonda((dm.IBselect.fieldbyname('quant').asCurrency * dm.IBselect.fieldbyname('p_venda').asCurrency),2);
      prod.tot3 := prod.tot3 + dm.IBselect.fieldbyname('quant').asCurrency;

      form33.ClientDataSet1.Open;
      form33.ClientDataSet1.Edit;
      form33.ClientDataSet1.Insert;
      form33.ClientDataSet1.FieldByName('data').AsDateTime := dm.IBselect.fieldbyname('data').AsDateTime;
      form33.ClientDataSet1.FieldByName('historico').AsString := 'VENDA NOTA ' + dm.IBselect.fieldbyname('nota').AsString + ' ' + dm.IBselect.fieldbyname('nome').AsString +
	    iif(dm.IBselect.fieldbyname('origem').AsInteger = 1, ' LOJA', ' DEPOSITO');
      form33.ClientDataSet1.FieldByName('preco').AsCurrency := dm.IBselect.fieldbyname('p_venda').AsCurrency;
      form33.ClientDataSet1.FieldByName('quant').AsCurrency := - dm.IBselect.fieldbyname('quant').asCurrency;
      form33.ClientDataSet1.FieldByName('saldo').AsCurrency := geral;
      form33.ClientDataSet1.FieldByName('cont').AsInteger := Form33.ClientDataSet1.RecordCount + 1;
      form33.ClientDataSet1.Post;
      dm.IBselect.Next;
    end;
  if prod.tot2 > 0 then prod.tot2 := Arredonda(prod.tot2 / prod.tot3, 2);

  dm.IBselect.Close;
  dm.IBselect.SQL.Clear;
  dm.IBselect.SQL.Add('select p_compra, quant, deposito from produto where cod = ' + te);
  dm.IBselect.Open;

  prod.tot1 := dm.IBselect.fieldbyname('p_compra').AsCurrency;
  prod.qtd_atual := dm.IBselect.fieldbyname('quant').AsCurrency + dm.IBselect.fieldbyname('deposito').AsCurrency;
  lista.Add(prod);

  dm.IBselect.Close;

  //TRANSFERÊNCIAS
  //soma os lançamentos anteriores à data inicial no saldo anterior
  //primeiro as transferências para LOJA
  dm.IBselect.Close;
  dm.IBselect.SQL.Clear;
  dm.IBselect.SQL.Add('SELECT SUM(QUANT) AS saldoanterior from transferencia where (data < :ini) and' +
    ' (destino = 1) and (cod = ' + te + ')');
  dm.IBselect.ParamByName('ini').AsDateTime := datini;
  dm.IBselect.Open;
  if Pos('1', origem) > 0 then
     begin
       saldoAnteriorLoja := saldoAnteriorLoja + dm.IBselect.fieldbyname('saldoanterior').AsCurrency;
	     saldoAnteriorDeposito := saldoAnteriorDeposito - dm.IBselect.fieldbyname('saldoanterior').AsCurrency;
	 end;

  //agora as transferências para DEPOSITO
  dm.IBselect.Close;
  dm.IBselect.SQL.Clear;
  dm.IBselect.SQL.Add('SELECT SUM(QUANT) AS saldoanterior from transferencia where (data < :ini) and' +
    ' (destino = 2) and (cod = ' + te + ')');
  dm.IBselect.ParamByName('ini').AsDateTime := datini;
  dm.IBselect.Open;
  if Pos('2', origem) > 0 then
     begin
       saldoAnteriorLoja := saldoAnteriorLoja - dm.IBselect.fieldbyname('saldoanterior').AsCurrency;
	     saldoAnteriorDeposito := saldoAnteriorDeposito + dm.IBselect.fieldbyname('saldoanterior').AsCurrency;
     end;

  dm.IBselect.Close;
  dm.IBselect.SQL.Clear;
  dm.IBselect.SQL.Add('select cod, data, destino, quant, documento from transferencia where (data >= :ini) and (cod = '+ te + ')');
  dm.IBselect.ParamByName('ini').AsDateTime := datini;
  dm.IBselect.Open;

  while not dm.IBselect.Eof do
    begin
      //cod1 é a origem da mercadoria(1-loja, 2-depósito)
      cod1 := '1';
  	  if (dm.IBselect.fieldbyname('destino').AsString = '1') then cod1 := '2';

      //se é pra mostrar o movimento de origem
	   if Pos(cod1, origem) > 0 then
        begin
          DEST := ' PARA LOJA';
          if cod1 = '1' then DEST := ' PARA DEPOSITO';
          fat := -1;
          form33.ClientDataSet1.Insert;
          form33.ClientDataSet1.FieldByName('data').AsDateTime := dm.IBselect.fieldbyname('data').AsDateTime;
          form33.ClientDataSet1.FieldByName('historico').AsString := 'TRANSFERENCIA ' + dm.IBselect.fieldbyname('documento').AsString + DEST ;
          form33.ClientDataSet1.FieldByName('preco').AsCurrency := 0;
          form33.ClientDataSet1.FieldByName('quant').AsCurrency := fat * dm.IBselect.fieldbyname('quant').asCurrency ;
          form33.ClientDataSet1.FieldByName('saldo').AsCurrency := geral;
          form33.ClientDataSet1.FieldByName('cont').AsInteger := Form33.ClientDataSet1.RecordCount + 1;
          form33.ClientDataSet1.Post;
        end;

      //se é pra mostrar o movimento de destino
   	 if Pos(dm.IBselect.fieldbyname('destino').AsString, origem) > 0 then
	      begin
          DEST := ' PARA DEPOSITO';
          if dm.IBselect.fieldbyname('destino').AsString = '1' then DEST := ' PARA LOJA';
          fat := 1;
          form33.ClientDataSet1.Insert;
          form33.ClientDataSet1.FieldByName('data').AsDateTime := dm.IBselect.fieldbyname('data').AsDateTime;
          form33.ClientDataSet1.FieldByName('historico').AsString := 'TRANSFERENCIA ' + dm.IBselect.fieldbyname('documento').AsString + DEST ;
          form33.ClientDataSet1.FieldByName('preco').AsCurrency := 0;
          form33.ClientDataSet1.FieldByName('quant').AsCurrency := fat * dm.IBselect.fieldbyname('quant').asCurrency ;
          form33.ClientDataSet1.FieldByName('saldo').AsCurrency := geral;
          form33.ClientDataSet1.FieldByName('cont').AsInteger := Form33.ClientDataSet1.RecordCount + 1;
          form33.ClientDataSet1.Post;
        end;
     dm.IBselect.Next;
  end;


  //ACERTOS DE ESTOQUE
  dm.IBselect.Close;
  dm.IBselect.SQL.Clear;
  dm.IBselect.SQL.Add('SELECT SUM(QUANT) AS saldoantLoja, SUM(deposito) AS saldoantDeposito from acerto where (data < :ini) and (codigo = ' + te + ')');
  dm.IBselect.ParamByName('ini').AsDateTime := datini;
  dm.IBselect.Open;
  saldoAnteriorLoja := saldoAnteriorLoja + dm.IBselect.fieldbyname('saldoantLoja').AsCurrency;
  saldoAnteriorDeposito := saldoAnteriorDeposito + dm.IBselect.fieldbyname('saldoantDeposito').AsCurrency;

  dm.IBselect.Close;
  dm.IBselect.SQL.Clear;
  dm.IBselect.SQL.Add('select codigo, data, quant, deposito from acerto where '+
   ' (data >= :ini) and (codigo = ' + te + ')');
  dm.IBselect.ParamByName('ini').AsDateTime := StrToDateTime(dini);
  dm.IBselect.Open;
  dm.IBselect.FetchAll;

        while not dm.IBselect.Eof do
         begin

           if ((dm.IBselect.fieldbyname('quant').AsCurrency <> 0) and (Pos('1', origem) > 0)) then
             begin
               geral := geral + dm.IBselect.fieldbyname('quant').asCurrency;
               form33.ClientDataSet1.Open;
               form33.ClientDataSet1.Insert;
               form33.ClientDataSet1.FieldByName('data').AsDateTime := dm.IBselect.fieldbyname('data').AsDateTime;
               form33.ClientDataSet1.FieldByName('historico').AsString := 'ACERTO DE ESTOQUE - LOJA' ;
               form33.ClientDataSet1.FieldByName('preco').AsCurrency := 0;
               form33.ClientDataSet1.FieldByName('quant').AsCurrency := dm.IBselect.fieldbyname('quant').asCurrency ;
               form33.ClientDataSet1.FieldByName('saldo').AsCurrency := geral;
               form33.ClientDataSet1.FieldByName('cont').AsInteger := Form33.ClientDataSet1.RecordCount + 1;
               form33.ClientDataSet1.Post;
             end;

          if ((dm.IBselect.fieldbyname('deposito').AsCurrency <> 0) and (Pos('2', origem) > 0)) then
             begin
               geral := geral + dm.IBselect.fieldbyname('deposito').asCurrency;
               form33.ClientDataSet1.Open;
               form33.ClientDataSet1.Insert;
               form33.ClientDataSet1.FieldByName('data').AsDateTime := dm.IBselect.fieldbyname('data').AsDateTime;
               form33.ClientDataSet1.FieldByName('historico').AsString := 'ACERTO DE ESTOQUE - DEPOSITO' ;
               form33.ClientDataSet1.FieldByName('preco').AsCurrency := 0;
               form33.ClientDataSet1.FieldByName('quant').AsCurrency := dm.IBselect.fieldbyname('deposito').asCurrency ;
               form33.ClientDataSet1.FieldByName('saldo').AsCurrency := geral;
               form33.ClientDataSet1.FieldByName('cont').AsInteger := Form33.ClientDataSet1.RecordCount + 1;
               form33.ClientDataSet1.Post;
             end;
           dm.IBselect.Next;
         end;

      {fim acertos}

       prod := new(ptr_produto);
       prod.tot1 := 0;
       prod.tot2 := 0;
       prod.tot3 := 0;

       form33.ClientDataSet1.IndexName := 'indice';
       form33.ClientDataSet1.fieldbyname('cont').Visible := false;
       form33.ClientDataSet1.First;

       TCurrencyField(form33.ClientDataSet1.FieldByName('preco')).DisplayFormat := '#,###,###0.00';
       TCurrencyField(form33.ClientDataSet1.FieldByName('quant')).DisplayFormat := '#,###,###0.00';
       TCurrencyField(form33.ClientDataSet1.FieldByName('saldo')).DisplayFormat := '#,###,###0.00';

       form33.ClientDataSet1.First;
       form33.txt := RelSomatoria_T_(lista,dini,dfim,geral);

       geral := 0;
       if Pos('1', origem) > 0 then geral := geral + saldoAnteriorLoja;
       if Pos('2', origem) > 0 then geral := geral + saldoAnteriorDeposito;

       form33.ClientDataSet1.First;
       form33.ClientDataSet1.Edit;
       form33.ClientDataSet1.FieldByName('saldo').AsCurrency := geral;
       form33.ClientDataSet1.Post;

       form33.ClientDataSet1.IndexFieldNames := 'data';
       form33.ClientDataSet1.First;


       while not form33.ClientDataSet1.Eof do
         begin
           geral := geral + form33.ClientDataSet1.FieldByName('quant').AsCurrency;
           form33.ClientDataSet1.Edit;
           form33.ClientDataSet1.FieldByName('saldo').AsCurrency := geral;
           form33.ClientDataSet1.Post;
           form33.ClientDataSet1.Next;
         end;
       form33.ClientDataSet1.First;

       {FIM de calcular o saldo}

       lab := TLabel.Create(self);
       lab.Name := 'lab';
       lab.Parent := form33;
       lab.Caption := 'I-IMPRIME     T-TOTAL' ;
       lab.Align := alBottom;
       lab.AutoSize := true;
       lab.Font.Style := [fsbold];
       lab.Font.Size := 9;
       funcoes.CtrlResize(tform(form33));
       form33.ShowModal;
       //lis.Free;
       form33.ClientDataSet1.Free;
       form33.Free;
	     Dispose(prod);
	     lista.free;
       lab := nil;
end;

procedure Tfuncoes.imprimeOrdemDeServico(var ordem : TOrdem; const orcamento : boolean);
var
  tot, desc : currency;
  sim, USU, tmp : String;
  i   : integer;
begin
  tot := 0;
  form19.RichEdit1.Clear;
  if Contido(form22.Pgerais.Values['nota'], 'TD')  then
    begin
      dm.IBselect.Close;
      dm.IBselect.SQL.Text := 'select nome from usuario where cod = :cod';
      dm.IBselect.ParamByName('cod').AsInteger := ORDEM.usuario;
      dm.IBselect.Open;

      USU := IntToStr(ordem.usuario) + '-' + dm.IBselect.fieldbyname('nome').AsString;

      addRelatorioForm19(funcoes.CompletaOuRepete('','','-',40)+#13+#10);
      addRelatorioForm19( funcoes.centraliza(form22.Pgerais.Values['empresa'],' ',40)+#13+#10);
      addRelatorioForm19(funcoes.CompletaOuRepete('','','-',40)+#13+#10);
      addRelatorioForm19(funcoes.CompletaOuRepete('DATA: ' +FormatDateTime('dd/mm/yy',FORM22.datamov), ' HORA: ' + FormatDateTime('hh:mm:ss', now),' ',40) + CRLF);
      addRelatorioForm19('Servico: ' + IntToStr(ordem.cod) + '    USUARIO: ' + USU + CRLF);
      if ordem.venda > 0 then addRelatorioForm19('Venda: ' + IntToStr(ordem.venda) + CRLF);
      addRelatorioForm19(funcoes.CompletaOuRepete('','','-',40)+#13+#10);

      if ordem.cliente > 0 then
        begin
          dm.IBselect.Close;
          dm.IBselect.SQL.Text := 'select nome, ende, bairro, telres, telcom from cliente where cod = :cod';
          dm.IBselect.ParamByName('cod').AsInteger := ORDEM.cliente;
          dm.IBselect.Open;

          addRelatorioForm19('NOME: ' + LeftStr(dm.IBselect.fieldbyname('nome').AsString, 33) + CRLF);
          addRelatorioForm19('END: ' + LeftStr(dm.IBselect.fieldbyname('ende').AsString, 33) + CRLF);
          addRelatorioForm19('BAIRRO: ' + dm.IBselect.fieldbyname('bairro').AsString + CRLF);
          addRelatorioForm19('FONES: ' + dm.IBselect.fieldbyname('telres').AsString + ' ' + dm.IBselect.fieldbyname('TELCOM').AsString + CRLF);
          addRelatorioForm19(funcoes.CompletaOuRepete('','','-',40)+ CRLF);
        end;

      addRelatorioForm19(ORDEM.equipe+ CRLF);
      addRelatorioForm19(ORDEM.marca+ CRLF);
      addRelatorioForm19(ORDEM.modelo+ CRLF);
      addRelatorioForm19(ORDEM.serie+ CRLF);
      addRelatorioForm19(ORDEM.tecnico+ CRLF);

      IF Length(ORDEM.obs) > 0 then
        begin
          addRelatorioForm19(funcoes.CompletaOuRepete('','','-',40)+ CRLF);
          addRelatorioForm19('OBS: ' + LeftStr(ordem.obs, 35) + CRLF);
          if Length(ORDEM.obs) > 35 then
            begiN
              addRelatorioForm19(copy(ordem.obs, 36, length(ordem.obs)) + CRLF);
            end;
        end;

      addRelatorioForm19(funcoes.CompletaOuRepete('','','-',40)+ CRLF);

      if (not orcamento) then
        begin
          if ordem.venda = 0 then
            begin
              dm.IBselect.Close;
              dm.IBselect.SQL.Text := 'select o.cod, p.nome, 0 as desconto, s.pago, o.quant, o.p_venda,p.codbar, p.refori, p.localiza, o.total from os_itens o left join produto p on (p.cod = o.cod)'+
              'left join servico s on (s.cod = o.nota) where nota = :nota';
              dm.IBselect.ParamByName('nota').AsInteger := ordem.cod;
              dm.IBselect.Open;
            end
          else
            begin
              dm.IBselect.Close;
              dm.IBselect.SQL.Text := 'select v.desconto, s.pago, v.desconto, v.total as total1, o.cod,p.codbar, p.refori, p.localiza, p.nome, o.quant, o.p_venda, o.total from item_venda o left join produto p on (p.cod = o.cod) left join venda v on (v.nota = o.nota)'+
              'left join servico s on (s.cod = :codserv) where o.nota = :nota';
              dm.IBselect.ParamByName('codserv').AsInteger := ordem.cod;
              dm.IBselect.ParamByName('nota').AsInteger    := ordem.venda;
              dm.IBselect.Open;
            end;

        
        while not dm.IBselect.Eof do
      begin
        if ConfParamGerais[5] = 'S' then
          begin
            tmp := IfThen(dm.IBselect.fieldbyname('codbar').AsString = '', dm.IBselect.fieldbyname('codbar').AsString, dm.IBselect.fieldbyname('cod').AsString);
            addRelatorioForm19(funcoes.CompletaOuRepete(tmp+'-'+copy(dm.IBselect.fieldbyname('nome').AsString,1,37 -length(tmp)),'',' ',40) + CRLF);
            addRelatorioForm19(funcoes.CompletaOuRepete(LeftStr(IfThen(trim(dm.IBselect.fieldbyname('localiza').AsString) = '', '*', trim(dm.IBselect.fieldbyname('localiza').AsString)), 14),'',' ',15)+funcoes.CompletaOuRepete('',FormatCurr('0.000',dm.IBselect.fieldbyname('quant').AsCurrency),' ',8)+funcoes.CompletaOuRepete('',FormatCurr('0.00',dm.IBselect.fieldbyname('p_venda').AsCurrency) ,' ',8)+
            funcoes.CompletaOuRepete('',FormatCurr('0.00',dm.IBselect.fieldbyname('total').AsCurrency) ,' ',9)+CRLF);
          end
        else
          begin
            form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete(dm.IBselect.fieldbyname('cod').AsString+'-'+copy(dm.IBselect.fieldbyname('nome').AsString,1,37-length(dm.IBselect.fieldbyname('cod').AsString)),'',' ',40)+#13+#10))));
            form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('=>QTD:',FormatCurr('#,###,###0.000',dm.IBselect.fieldbyname('quant').AsCurrency),' ',13)+funcoes.CompletaOuRepete('',FormatCurr('#,###,###0.00',dm.IBselect.fieldbyname('p_venda').AsCurrency) + 'R$',' ',13)
            + funcoes.CompletaOuRepete('',FormatCurr('#,###,###0.00', dm.IBselect.fieldbyname('total').AsCurrency) + 'R$',' ',14)+#13+#10))));
          end;

        tot := tot + dm.IBselect.fieldbyname('total').AsCurrency;
        dm.IBselect.Next;
      end;
      end;
      //faltou forma de pagamento

     desc := dm.IBselect.fieldbyname('desconto').AsCurrency;
     ordem.pago := dm.IBselect.fieldbyname('pago').AsCurrency;
     addRelatorioForm19(funcoes.CompletaOuRepete('','','-',40)+ CRLF);
     addRelatorioForm19(funcoes.CompletaOuRepete('Sub-Total:',FormatCurr('0.00', tot),'.',40)+ CRLF);
     if desc <> 0 then addRelatorioForm19(funcoes.CompletaOuRepete('Desconto:',FormatCurr('0.00', desc),'.',40)+ CRLF);
     if ordem.pago > 0 then addRelatorioForm19(funcoes.CompletaOuRepete('Entrada:',FormatCurr('0.00', ordem.pago),'.',40)+ CRLF);
     addRelatorioForm19(funcoes.CompletaOuRepete('','','-',40)+ CRLF);
     addRelatorioForm19(funcoes.CompletaOuRepete('Total a Pagar:',FormatCurr('0.00', tot - ordem.pago + desc),'.',40)+ CRLF);

     addRelatorioForm19(funcoes.CompletaOuRepete('','','-',40)+ CRLF);

     sim := funcoes.dialogo('generico',20,'SN',20,false,'S',Application.Title,'Enviar para Impressora?(S/N)' + #13 + #10,'S');
     if (sim = '*') then exit;

     if sim = 'S' then imprime.textx('')
      else form19.ShowModal;

      exit;
    end;

  tot := 0;
  funcoes.CharSetRichEdit(form19.RichEdit1);
  form19.RichEdit1.Clear;
  addRelatorioForm19(funcoes.CompletaOuRepete(#218, #191, #196, 80) + CRLF);
  addRelatorioForm19(funcoes.CompletaOuRepete(#179 + ' ORDEM DE SERVICO Nr.: ' + IntToStr(ordem.cod), 'DATA: ' + formatadataddmmyy(form22.datamov) + '   ' + #179, ' ', 80) + CRLF);
  addRelatorioForm19(funcoes.CompletaOuRepete(#195, #180, #196, 80) + CRLF);

  dm.IBselect.Close;
  dm.IBselect.SQL.Text := 'select cnpj, ende, telcom, telres, bairro, cid, est, obs from registro';
  dm.IBselect.Open;

  addRelatorioForm19(funcoes.CompletaOuRepete(#179 + ' ' + form22.Pgerais.Values['empresa'],'CNPJ: ' + dm.IBselect.fieldbyname('cnpj').AsString + '   ' + #179, ' ', 80) + CRLF);
  addRelatorioForm19(funcoes.CompletaOuRepete(#179 + ' ' + dm.IBselect.fieldbyname('ende').AsString + ' - ' + dm.IBselect.fieldbyname('bairro').AsString, #179, ' ', 80) + CRLF);
  addRelatorioForm19(funcoes.CompletaOuRepete(#179 + ' Tel: ' + dm.IBselect.fieldbyname('telres').AsString + ' ' + dm.IBselect.fieldbyname('cid').AsString + ' - ' + dm.IBselect.fieldbyname('est').AsString, #179, ' ', 80) + CRLF);
  addRelatorioForm19(funcoes.CompletaOuRepete(#179 + ' Obs: ' + dm.IBselect.fieldbyname('obs').AsString, #179, ' ', 80) + CRLF);
  addRelatorioForm19(funcoes.CompletaOuRepete(#195, #194, #196, 49) + funcoes.CompletaOuRepete('', #180, #196, 31) + CRLF);
  dm.IBselect.Close;

  dm.IBselect.Close;
  dm.IBselect.SQL.Text := 'select cod,ies, cnpj, nome, ende, telcom, telres, bairro, cid, est, obs from cliente where cod = :cod';
  dm.IBselect.ParamByName('cod').AsInteger := ordem.cliente;
  dm.IBselect.Open;

  {DADOS DO CLIENTE}
  addRelatorioForm19(funcoes.CompletaOuRepete(#179 + ' Nome: ' + dm.IBselect.fieldbyname('nome').AsString, #179, ' ', 49) + funcoes.CompletaOuRepete('CPF/CNPJ:' + dm.IBselect.fieldbyname('cnpj').AsString, #179, ' ', 31) + CRLF);
  addRelatorioForm19(funcoes.CompletaOuRepete(#179 + ' Endereco: ' + dm.IBselect.fieldbyname('ende').AsString, #179, ' ', 49) + funcoes.CompletaOuRepete( 'INSC. EST.:' + dm.IBselect.fieldbyname('ies').AsString, #179, ' ', 31) + CRLF);
  addRelatorioForm19(funcoes.CompletaOuRepete(#179 + ' Bairro: ' + dm.IBselect.fieldbyname('bairro').AsString + ' ' + dm.IBselect.fieldbyname('cid').AsString + '-' + dm.IBselect.fieldbyname('est').AsString, #179, ' ', 49) + funcoes.CompletaOuRepete( 'CODIGO:' + dm.IBselect.fieldbyname('cod').AsString, #179, ' ', 31) + CRLF);
  addRelatorioForm19(funcoes.CompletaOuRepete(#179 + ' Obs: ' + dm.IBselect.fieldbyname('obs').AsString, #179, ' ', 49) + funcoes.CompletaOuRepete( 'Fone:' + dm.IBselect.fieldbyname('telres').AsString, #179, ' ', 31) + CRLF);
  addRelatorioForm19(funcoes.CompletaOuRepete(#195, #197, #196, 49) + funcoes.CompletaOuRepete('', #180, #196, 31) + CRLF);
  dm.IBselect.Close;

  {DADOS DA O. S.}
  addRelatorioForm19(funcoes.CompletaOuRepete(#179 + ' ' + form22.nomesServico.Values['1'] + ': ' + ordem.equipe, #179, ' ', 49) + funcoes.CompletaOuRepete(form22.nomesServico.Values['4'] + ': ' + ordem.serie, #179, ' ', 31) + CRLF);
  addRelatorioForm19(funcoes.CompletaOuRepete(#179 + ' ' + funcoes.CompletaOuRepete(form22.nomesServico.Values['2'] + ': ' + ordem.marca, '', ' ', 23) + ' ' + form22.nomesServico.Values['3'] + ': ' + ordem.modelo, #179, ' ', 49) + funcoes.CompletaOuRepete(form22.nomesServico.Values['5'] + ': ' + ordem.tecnico, #179, ' ', 31) + CRLF);
  addRelatorioForm19(funcoes.CompletaOuRepete(#179 + ' ' + form22.nomesServico.Values['6'] + ': ' + ordem.defeito, #179, ' ', 49) + funcoes.CompletaOuRepete( 'Usuario: ' + funcoes.BuscaNomeBD(dm.ibquery3, 'nome', 'usuario', 'where cod = ' + IntToStr(ordem.usuario)), #179, ' ', 31) + CRLF);
  addRelatorioForm19(funcoes.CompletaOuRepete(#179 + ' Obs: ' + ordem.obs, #179, ' ', 49) + funcoes.CompletaOuRepete( 'Vendedor: ' + '', #179, ' ', 31) + CRLF);

  addRelatorioForm19(funcoes.CompletaOuRepete(#195, #194, #196, 8) + funcoes.CompletaOuRepete('', #194, #196, 8) + funcoes.CompletaOuRepete('', #193, #196, 33) + funcoes.CompletaOuRepete('', #194, #196, 8) +
  {aqui começa unitario} funcoes.CompletaOuRepete('', #194, #196, 11) + funcoes.CompletaOuRepete('', #180, #196, 12) + CRLF);

  addRelatorioForm19(funcoes.CompletaOuRepete(#179 + 'Codigo', #179, ' ', 8) + funcoes.CompletaOuRepete('  Qtd.' , #179, ' ', 8) + funcoes.CompletaOuRepete(' Descricao', #179, ' ', 41) +
  {aqui começa unitario} funcoes.CompletaOuRepete(' Unitario', #179, ' ', 11) + funcoes.CompletaOuRepete('   Total', #179, ' ', 12) + CRLF);

  addRelatorioForm19(funcoes.CompletaOuRepete(#195, #197, #196, 8) + funcoes.CompletaOuRepete('', #197, #196, 8) + funcoes.CompletaOuRepete('', #197, #196, 41) +
  {aqui começa unitario} funcoes.CompletaOuRepete('', #197, #196, 11) + funcoes.CompletaOuRepete('', #180, #196, 12) + CRLF);


  if (not orcamento) then
    begin
      if ordem.venda = 0 then
        begin
          dm.IBselect.Close;
          dm.IBselect.SQL.Text := 'select o.cod, p.nome, o.quant, o.p_venda, o.total from os_itens o left join produto p on (p.cod = o.cod) where nota = :nota';
          dm.IBselect.ParamByName('nota').AsInteger := ordem.cod;
          dm.IBselect.Open;
        end
      else
        begin
          dm.IBselect.Close;
          dm.IBselect.SQL.Text := 'select v.desconto, v.total as total1, o.cod, p.nome, o.quant, o.p_venda, o.total from item_venda o left join produto p on (p.cod = o.cod) left join venda v on (v.nota = o.nota) where o.nota = :nota';
          dm.IBselect.ParamByName('nota').AsInteger := ordem.venda;
          dm.IBselect.Open;
        end;

      tot := 0;
      while not dm.IBselect.Eof do
        begin
          tot := tot + dm.IBselect.fieldbyname('total').AsCurrency;
          addRelatorioForm19(funcoes.CompletaOuRepete(#179 ,dm.IBselect.fieldbyname('cod').AsString + #179, ' ', 8) + funcoes.CompletaOuRepete('' ,formatacurrency(dm.IBselect.fieldbyname('quant').AsCurrency) + #179, ' ', 8) + funcoes.CompletaOuRepete(copy(dm.IBselect.fieldbyname('nome').AsString, 1, 39), #179, ' ', 41) +
          {aqui começa unitario} funcoes.CompletaOuRepete('',formatacurrency(dm.IBselect.fieldbyname('p_venda').AsCurrency) + #179, ' ', 11) + funcoes.CompletaOuRepete('',formatacurrency(dm.IBselect.fieldbyname('total').AsCurrency) + #179, ' ', 12) + CRLF);
          dm.IBselect.Next;
        end;

      if (ordem.venda <> 0) then
        begin
          tot := dm.IBselect.fieldbyname('total1').AsCurrency;
          if (dm.IBselect.fieldbyname('desconto').AsCurrency <> 0) then
            begin
              addRelatorioForm19(funcoes.CompletaOuRepete(#179 , #179, ' ', 8) + funcoes.CompletaOuRepete('',formatacurrency(0) + #179, ' ', 8) + funcoes.CompletaOuRepete('Desconto R$', #179, ' ', 41) +
              {aqui começa unitario} funcoes.CompletaOuRepete('',formatacurrency(0) + #179, ' ', 11) + funcoes.CompletaOuRepete('',formatacurrency(dm.IBselect.fieldbyname('desconto').AsCurrency) + #179, ' ', 12) + CRLF);
            end;
        end;

      if dm.IBselect.IsEmpty then
        begin
          for i := 0 to 30 do
            begin
              addRelatorioForm19(funcoes.CompletaOuRepete(#179 , #179, ' ', 8) + funcoes.CompletaOuRepete('' , #179, ' ', 8) + funcoes.CompletaOuRepete('', #179, ' ', 41) +
              {aqui começa unitario} funcoes.CompletaOuRepete('', #179, ' ', 11) + funcoes.CompletaOuRepete('', #179, ' ', 12) + CRLF);
            end;  
          //addRelatorioForm19(funcoes.CompletaOuRepete(#179 , #179, ' ', 8) + funcoes.CompletaOuRepete('' , #179, ' ', 8) + funcoes.CompletaOuRepete('', #179, ' ', 41) +
          //{aqui começa unitario} funcoes.CompletaOuRepete('', #179, ' ', 11) + funcoes.CompletaOuRepete('', #179, ' ', 12) + CRLF);
        end;
      dm.IBselect.Close;

    end {fim not orcamento}
  else
    begin
      form20.ClientDataSet1.First;
      while not form20.ClientDataSet1.Eof do
        begin
          addRelatorioForm19(funcoes.CompletaOuRepete(#179 ,form20.ClientDataSet1.fieldbyname('codigo').AsString + #179, ' ', 8) + funcoes.CompletaOuRepete('' ,formatacurrency(form20.ClientDataSet1.fieldbyname('quant').AsCurrency) + #179, ' ', 8) + funcoes.CompletaOuRepete(form20.ClientDataSet1DESCRICAO.AsString, #179, ' ', 41) +
          {aqui começa unitario} funcoes.CompletaOuRepete('',formatacurrency(form20.ClientDataSet1.fieldbyname('preco').AsCurrency) + #179, ' ', 11) + funcoes.CompletaOuRepete('',formatacurrency(form20.ClientDataSet1.fieldbyname('total').AsCurrency) + #179, ' ', 12) + CRLF);
          form20.ClientDataSet1.Next;
        end;

      if (form20.desconto <> 0) then
        begin
          addRelatorioForm19(funcoes.CompletaOuRepete(#179 , #179, ' ', 8) + funcoes.CompletaOuRepete('',formatacurrency(0) + #179, ' ', 8) + funcoes.CompletaOuRepete('Desconto R$', #179, ' ', 41) +
          {aqui começa unitario} funcoes.CompletaOuRepete('',formatacurrency(0) + #179, ' ', 11) + funcoes.CompletaOuRepete('',formatacurrency(form20.desconto) + #179, ' ', 12) + CRLF);
        end;
      tot := form20.total1;
    end;

  addRelatorioForm19(funcoes.CompletaOuRepete(#195, #193, #196, 8) + funcoes.CompletaOuRepete('', #193, #196, 8) + funcoes.CompletaOuRepete('', #193, #196, 41) +
  {aqui começa unitario} funcoes.CompletaOuRepete('', #193, #196, 11) + funcoes.CompletaOuRepete('', #180, #196, 12) + CRLF);
  addRelatorioForm19(funcoes.CompletaOuRepete(#179 + '                          Total:. . . . . . . . . . . . . . . ', formatacurrency(tot) + ' ' + #179, ' ', 80) + CRLF);
  addRelatorioForm19(funcoes.CompletaOuRepete(#195, #180, #196, 80) + CRLF);
  addRelatorioForm19(funcoes.CompletaOuRepete(#179 + ' ENTRADA: ' + formatadataddmmyy(ordem.data) + ' AS ' + ordem._ent , '', ' ', 35) + funcoes.CompletaOuRepete(' Recebido Por: '  , #179, ' ', 45) + CRLF);
  addRelatorioForm19(funcoes.CompletaOuRepete(#179 + ' SAIDA  : ' + IfThen(formatadataddmmyy(ordem.saida) = '01/01/00', '  /  /  ', formatadataddmmyy(ordem.saida)) + ' AS '+ ordem.h_saida , '', ' ', 35) + funcoes.CompletaOuRepete('' + IfThen((ordem.venda <> 0) and (not orcamento), ' PEDIDO: ' + inttostr(ordem.venda), ''), #179, ' ', 45) + CRLF);
  addRelatorioForm19(funcoes.CompletaOuRepete(#192, #217, #196, 80) + CRLF);

  sim := funcoes.dialogo('normal',0,'SN',30,false,'S',Application.Title,'Enviar para Impressora?(S/N)' + #13 + #10,'N');
  if (sim = '*') then exit;

  if sim = 'S' then imprime.textxArq('')
    else form19.ShowModal;
  //imprime.textxArq('');
end;

procedure Tfuncoes.atualizaMensagemUsuario(const mens : String);
begin
  form22.Pgerais.Values['mens'] := mens;
  dm.IBQuery1.Close;
  dm.IBQuery1.SQL.Text := 'update usuario set mens = :mens where cod = :cod';
  dm.IBQuery1.ParamByName('mens').AsString := copy(mens, 1, 40);
  dm.IBQuery1.ParamByName('cod').AsString  := form22.codusario;
  dm.IBQuery1.ExecSQL;
  dm.IBQuery1.Transaction.Commit;
end;

procedure Tfuncoes.Descomprimir(ArquivoZip: TFileName; DiretorioDestino: string);
var
  NomeSaida: string;
  FileEntrada, FileOut: TFileStream;
  Descompressor: TDecompressionStream;
  NumArq, I, Len, Size: Integer;
  Fim: Byte;
begin
  FileEntrada := TFileStream.Create(ArquivoZip, fmOpenRead and fmShareExclusive);
  Descompressor := TDecompressionStream.Create(FileEntrada);
  Descompressor.Read(NumArq, SizeOf(Integer));
  try
    I := 0;
    while I < NumArq do begin
      Descompressor.Read(Len, SizeOf(Integer));
      SetLength(NomeSaida, Len);
      Descompressor.Read(NomeSaida[1], Len);
      Descompressor.Read(Size, SizeOf(Integer));
      FileOut := TFileStream.Create(
        IncludeTrailingBackslash(DiretorioDestino) + NomeSaida, 
        fmCreate or fmShareExclusive);
      try
        FileOut.CopyFrom(Descompressor, Size);
      finally
        FileOut.Free;
      end;
      Descompressor.Read(Fim, SizeOf(Byte));
      Inc(I);
    end;
  finally
    FreeAndNil(Descompressor);
    FreeAndNil(FileEntrada);
  end;
end;

function Tfuncoes.retornaTipoDoCampo(campo, tabela : String) : String;
begin
  campo  := UpperCase(campo);
  tabela := UpperCase(tabela);
  dm.IBselect.Close;
  dm.IBselect.SQL.Text := 'SELECT r.RDB$FIELD_NAME AS nome,' +
  ' r.RDB$DESCRIPTION AS descricao,' +
  ' f.RDB$FIELD_LENGTH AS tamanho,' +
  ' CASE f.RDB$FIELD_TYPE' +
  ' WHEN 261 THEN ''BLOB'' ' +
  ' WHEN 14 THEN ''CHAR'' ' +
  ' WHEN 40 THEN ''CSTRING'' ' +
  ' WHEN 11 THEN ''D_FLOAT''' +
  ' WHEN 27 THEN ''DOUBLE''' +
  ' WHEN 10 THEN ''FLOAT''' +
  ' WHEN 16 THEN ''INT64''' +
  ' WHEN 8 THEN ''INTEGER''' +
  ' WHEN 9 THEN ''QUAD''' +
  ' WHEN 7 THEN ''SMALLINT''' +
  ' WHEN 12 THEN ''DATE''' +
  ' WHEN 13 THEN ''TIME''' +
  ' WHEN 35 THEN ''TIMESTAMP''' +
  ' WHEN 37 THEN ''VARCHAR''' +
  ' ELSE ''UNKNOWN''' +
  ' END AS tipo' +
  ' FROM RDB$RELATION_FIELDS r' +
  ' LEFT JOIN RDB$FIELDS f ON r.RDB$FIELD_SOURCE = f.RDB$FIELD_NAME' +
  ' WHERE r.RDB$RELATION_NAME='+ QuotedStr(tabela) +' and r.RDB$FIELD_NAME = '+ QuotedStr(campo) ;
  dm.IBselect.Open;

  Result := trim(dm.IBselect.fieldbyname('tipo').AsString);
end;

procedure Tfuncoes.gravaConfigTerminal(const con : String);
var
  arqTerminal : String;
  tmpo : TStringList;
begin
  tmpo := TStringList.Create;
  arqTerminal := caminhoEXE_com_barra_no_final+'config.dat';
  if FileExists(arqTerminal) then
    begin
      tmpo.LoadFromFile(arqTerminal);
    end;

  {arqTerminal := funcoes.GetTheWindowsDirectory+'\conf_ter.dat';

  if FileExists(funcoes.GetTheWindowsDirectory+'\conf_ter.dat') then
    begin
      tmpo.LoadFromFile(funcoes.GetTheWindowsDirectory+'\conf_ter.dat');
    end;}

  tmpo.Values['0'] := con;  
  tmpo.SaveToFile(arqTerminal);
  tmpo.Free;
end;

function Tfuncoes.verificaSeExisteIndiceTrueExiste(const indiceName : String) : boolean;
begin
  Result := false;
  dm.IBselect.Close;
  dm.IBselect.SQL.Clear;
  dm.IBselect.SQL.Add('select rdb$index_name as nome from rdb$indices where rdb$index_name = :nome');
  dm.IBselect.ParamByName('nome').AsString := indiceName;
  dm.IBselect.Open;

  if dm.IBselect.IsEmpty then Result := false
    else Result := true;
  dm.IBselect.Close;
end;

procedure Tfuncoes.redimensionaTelaDbgrid(var dbgrid : TDBGrid);
var
  ini, fim, acc : integer;
begin
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

end;

function Tfuncoes.retornaTamanhoDoCampoBD(const nomeCampo, tabela : String) : Smallint;
begin
  funcoes.iniciaDataset(dm.ibselect, 'select ' + nomeCampo + ' from ' + tabela);
  dm.IBselect.Open;

  Result := 0;
  Result := dm.IBselect.fieldbyname(nomeCampo).Size;
  dm.IBselect.Close;
end;
procedure Tfuncoes.iniciaDataset(var ibquery : TIBQuery; const sql : String);
begin
  ibquery.Close;
  ibquery.SQL.Clear;
  ibquery.SQL.Add(sql);
end;

FUNCTION Tfuncoes.VE_CUSTO(PCOMPRA, PVENDA : Currency; COD : String) : currency;
begin
  Result := PCOMPRA;
  IF PCOMPRA > 0 then
    begin
      exit;
    end;

  funcoes.iniciaDataset(dm.ibquery4, 'select p_compra, p_venda from produto where cod = :cod');
  dm.IBQuery4.ParamByName('cod').AsString := cod;
  dm.IBQuery4.Open;

  if not dm.IBQuery4.IsEmpty then
    begin
      Result := IiF(dm.IBQuery4.FieldByName('p_compra').AsCurrency > 0, dm.IBQuery4.FieldByName('p_compra').AsCurrency, dm.IBQuery4.FieldByName('p_venda').AsCurrency / 2);
      dm.IBQuery4.Close;
      exit;
    end;

  Result := (PVENDA / 2);
end;


procedure Tfuncoes.criaArqTerminal();
var
  arq    : TStringList;
  arqTer : String;
begin
  arqTer := caminhoEXE_com_barra_no_final + 'config.dat';
  if not FileExists(arqTer) then
    begin
      arq := TStringList.Create;
      arq.Add('0=-0- T -1- 1 -2- 2 -3- -4- -5- -6- -7- -8- -9- -10- -11- -12- -');
      arq.SaveToFile(arqTer);
      arq.Free
    end
  else
    begin
      arq.LoadFromFile(arqTer);
      if arq.Values['0'] = '' then
        begin
          arq.Add('0=-0- T -1- 1 -2- 2 -3- -4- -5- -6- -7- -8- -9- -10- -11- -12- -');
        end;

      arq.SaveToFile(arqTer);
      arq.Free
    end;
end;

function Tfuncoes.buscaConfigTerminal(indice : Smallint;const default : String): String;
var
  arq    : TStringList;
  arqTer, tmp : String;
begin
  arqTer := caminhoEXE_com_barra_no_final + '\config.dat';
  //criaArqTerminal(); //cria o arquivo do terminal se não existir

  arq := TStringList.Create;
  //arq.LoadFromFile(arqTer);
  //tmp := arq[0];

  Result := '';
  Result := funcoes.LerConfig(tmp, indice);

  if Result = '' then
    begin
      Result := default;
      tmp := GravarConfig(tmp, default, indice);
      arq[0] := tmp;
      arq.SaveToFile(arqTer);
      arq.Free;
    end;
end;

procedure Tfuncoes.fazBackupDoBD(const rede : boolean);
var
  arq : TStringList;
  pastaServidorControlW, pastaBackupBarraFinal, dia, dBackup, unidade : String;
  add : Smallint;
  ListaArquivos: Array of TFileName;
begin
  SetLength(ListaArquivos, 1);
  if rede then
    begin
      if not FileExists(caminhoEXE_com_barra_no_final + 'CONFIG.DAT') then
        begin
          arq := TStringList.Create;
          arq.Values['pasta_ControlW_servidor'] := '\\'+ ParamStr(1) +'\ControlW\';
          arq.Values['dataBackupBd'] := '01/01/1900';
          arq.SaveToFile(caminhoEXE_com_barra_no_final + 'CONFIG.DAT');
          arq.Free;
        end;

      arq := TStringList.Create;
      add := 0;
      arq.LoadFromFile(caminhoEXE_com_barra_no_final + 'CONFIG.DAT');

      pastaServidorControlW := funcoes.buscaConfigNaPastaDoControlW('pasta_ControlW_servidor', '\\'+ ParamStr(1) +'\ControlW\');
      dBackup               := funcoes.buscaConfigNaPastaDoControlW('dataBackupBd', '01/01/1900');

      if dBackup = FormatDateTime('dd/mm/yyyy', now) then
        begin
          arq.Free;
          exit;
        end;
    end
  else
    begin
      if ParamCount > 0 then pastaServidorControlW := funcoes.buscaConfigNaPastaDoControlW('pasta_ControlW_servidor', '\\'+ ParamStr(1) +'\ControlW\')
        else pastaServidorControlW := 'C:\ControlW\';

      unidade := funcoes.dialogo('generico',0,'ABCDEFGHIJLMNOPKXYZWQRSTUVXZ',50,false,'S',Application.Title,'Confirme a unidade para Recebimento da Remessa:', ConfParamGerais[33]);
      if unidade = '*' then exit;
    end;

  if not DirectoryExists(pastaServidorControlW) then
    begin
      ShowMessage('Backup de BD não foi realizado na pasta:' + #13 +
      arq.Values['pasta_ControlW_servidor'] + #13 + 'Favor corrija o diretório.');
      arq.Free;
      exit;
    end;

  if rede then pastaBackupBarraFinal := caminhoEXE_com_barra_no_final + 'Backup\'
    else pastaBackupBarraFinal := unidade + ':\' + 'Backup\';
  funcoes.CriaDiretorio(pastaBackupBarraFinal);

  dia := FormatDateTime('ddd', now);
  dia := dia + '\';

  funcoes.CriaDiretorio(pastaBackupBarraFinal + dia);

  if rede then
    begin
      if FileExists(pastaBackupBarraFinal + dia + 'bd.fdb') then DeleteFile(pastaBackupBarraFinal + dia + 'bd.fdb');
      CopyFile(pchar(pastaServidorControlW + 'bd.fdb'), pchar(pastaBackupBarraFinal + dia + 'bd.fdb'), true);
      funcoes.GravaConfigNaPastaDoControlW('dataBackupBd', FormatDateTime('dd/mm/yyyy', now));
    end
  else
    begin
      if FileExists(pastaBackupBarraFinal + dia + 'bd.fdb') then DeleteFile(pastaBackupBarraFinal + dia + 'bd.fdb');
      CopyFile(pchar(pastaServidorControlW + 'bd.fdb'), pchar(pastaBackupBarraFinal + dia + 'bd.fdb'), true);
      funcoes.GravaConfigNaPastaDoControlW('dataBackupBd', FormatDateTime('dd/mm/yyyy', now));
      try
        try
          //dm.bd.Connected := false;
          if FileExists(pastaBackupBarraFinal + dia + 'bd.w') then DeleteFile(pastaBackupBarraFinal + dia + 'bd.w');
          ListaArquivos[0] := pastaBackupBarraFinal + dia + 'bd.fdb';

          funcoes.Comprimir(pastaBackupBarraFinal + dia + 'bd.w', ListaArquivos);
          if FileExists(pastaBackupBarraFinal + dia + 'bd.fdb') then DeleteFile(pastaBackupBarraFinal + dia + 'bd.fdb');

          ShowMessage('Cópia de Segurança Efetuada com Sucesso');
        except
          ShowMessage('Ocorreu um Erro no Backup, Favor é necessario fechar o sistema em todos os terminais da rede');
        end;
      finally
        //dm.bd.Connected := true;
      end;
    end;
end;

procedure Tfuncoes.Comprimir(ArquivoCompacto: TFileName; Arquivos: array of TFileName);
var
  FileInName: TFileName;
  FileEntrada, FileSaida: TFileStream;
  Compressor: TCompressionStream;
  NumArq, I, Len, Size: Integer;
  Fim: Byte;
begin
  FileSaida := TFileStream.Create(ArquivoCompacto, fmCreate or fmShareExclusive);
  Compressor := TCompressionStream.Create(clMax, FileSaida);
  NumArq := Length(Arquivos);
  Compressor.Write(NumArq, SizeOf(Integer));
  try
    for I := Low(Arquivos) to High(Arquivos) do begin
      FileEntrada := TFileStream.Create(Arquivos[I], fmOpenRead and fmShareExclusive);
      try
        FileInName := ExtractFileName(Arquivos[I]);
        Len := Length(FileInName);
        Compressor.Write(Len, SizeOf(Integer));
        Compressor.Write(FileInName[1], Len);
        Size := FileEntrada.Size;
        Compressor.Write(Size, SizeOf(Integer));
        Compressor.CopyFrom(FileEntrada, FileEntrada.Size);
        Fim := 0;
        Compressor.Write(Fim, SizeOf(Byte));
      finally
        FileEntrada.Free;
      end;
    end;
  finally
    FreeAndNil(Compressor);
    FreeAndNil(FileSaida);
  end;
end;

procedure Tfuncoes.procuraTimmer(var dataset : TIBQuery; caracter : char;const campo : String);
begin
  buscaTimer := buscaTimer + caracter;
  dataset.Locate(campo, buscaTimer, [loPartialKey, loCaseInsensitive]);
  Timer3.Enabled := false;
  Timer3.Enabled := true;
end;

procedure Tfuncoes.desmarcaVendaPaf(const numvenda : String);
begin
  dm.IBQuery1.Close;
  dm.IBQuery1.SQL.Clear;
  dm.IBQuery1.SQL.Add('update venda set exportado = 0 where nota = :nota');
  dm.IBQuery1.ParamByName('nota').AsString := numvenda;
  dm.IBQuery1.ExecSQL;

  dm.IBQuery1.Close;
  dm.IBQuery1.SQL.Clear;
  dm.IBQuery1.SQL.Add('update item_venda set exportado = 0 where nota = :nota');
  dm.IBQuery1.ParamByName('nota').AsString := numvenda;
  dm.IBQuery1.ExecSQL;

  try
    dm.IBQuery1.Transaction.Commit;
  except
    dm.IBQuery1.Transaction.Rollback;
  end;
end;

function Tfuncoes.addRegSite(emp1 : String; var quer : TIBQuery) : String;
var
  bu, th, cnpj, ende : String;
  SS : TStringStream;
  bb : TWebBrowser;
begin
  Result := '';
  {dm.IBselect.Close;
  dm.IBselect.SQL.Clear;
  dm.IBselect.SQL.Add('select empresa, telres, telcom, ende, bairro, cnpj from registro');
  dm.IBselect.Open;}
  quer.Close;
  quer.SQL.Clear;
  quer.SQL.Add('select empresa, telres, telcom, ende, bairro, cnpj from registro');
  quer.Open;

  th := '';
  if emp1 = '' then emp1 := quer.fieldbyname('empresa').AsString;
  cnpj := StrNum(quer.fieldbyname('cnpj').AsString);
  ende := LeftStr(trocachar(quer.fieldbyname('telres').AsString+ '_' + quer.fieldbyname('telcom').AsString + '_' + quer.fieldbyname('ende').AsString + '_' + quer.fieldbyname('bairro').AsString, ' ', '_'), 195);

  th := 'emp=' + trim(emp1) + '&cnpj='+cnpj+'&ende=' + ende;
  th := trocachar(trocachar(th, '.', ''), ',', '');
  th
   := trocachar(buscaNomeSite+'/si2/add.php?' + th, ' ', '_');
  th := trim(th);

  dm.IBselect.Close;
  try
    IdHTTP1.Request.UserAgent := 'Mozilla/5.0 (Windows NT 5.1; rv:2.0b8) Gecko/20100101 Firefox/4.' +
      '0b8';
    IdHTTP1.HTTPOptions := [hoForceEncodeParams];
    th := IdHTTP1.Get(th);
    Result := th;
    IdHTTP1.Disconnect;
  except
    on e:exception do
      begin
        if Contido('Host not found', e.Message) then
          begin
            th := buscaConfigNaPastaDoControlW('Site_Num', '1');
            GravaConfigNaPastaDoControlW('Site_Num', IntToStr(StrToIntDef(th, 1) + 1));
          end;
      end;
  end;
end;

function Tfuncoes.baixaEstoque(cod : String; quant : currency; destino : integer) : boolean;
var
  tmp  : currency;
  dest : string;
begin
  if destino = 1 then dest := 'quant'
    else dest := 'deposito';

  {dm.IBselect.Close;
  dm.IBselect.SQL.Clear;
  dm.IBselect.SQL.Add('select ' + dest + ' as quant, cod from produto where cod = :cod');
  dm.IBselect.ParamByName('cod').AsString := cod;
  dm.IBselect.Open;

  tmp := dm.IBselect.fieldbyname('quant').AsCurrency;}

  dm.IBQuery1.Close;
  dm.IBQuery1.SQL.Clear;
  dm.IBQuery1.SQL.Add('update produto set ' + dest + ' = ' + dest + ' + :qtd where cod = :cod');
  dm.IBQuery1.ParamByName('qtd').AsCurrency := quant;
  dm.IBQuery1.ParamByName('cod').AsString   := cod;
  dm.IBQuery1.ExecSQL;

  dm.IBQuery1.Transaction.Commit;
end;

procedure Tfuncoes.limpaMemoria();
begin
  ConfParamGerais.Free;
  form22.Pgerais.Free;
end;

function Tfuncoes.ImprimirPedidoVias(qtdVias : Smallint) : boolean;
var
  tmp      : string;
  ini, fim, lin : integer;
begin
  fim := StrToIntDef(funcoes.LerConfig(form22.Pgerais.Values['conf_ter'], 5), 1) - 1;
  if fim > 8 then
    begin
      fim := 1;
    end;

  tmp := form19.RichEdit1.Lines.GetText;

  for ini := 1 to fim do
    begin
      form19.RichEdit1.Lines.Text := form19.RichEdit1.Lines.Text + CRLF + CRLF + tmp;
    end;
end;

function Tfuncoes.voltarLogin(var form : TForm) : boolean;
begin
  form.Close;

  form2.Close;
  form22.Show;
end;

function Tfuncoes.verificaTamnhoCampoBD(tabela, campo : String; tamanhoComparar  : integer) : boolean;
begin
  Result := false;
  dm.IBselect.Close;
  dm.IBselect.SQL.Clear;
  dm.IBselect.SQL.Add('select '+campo+' from ' +tabela +' where ' + campo + ' = ' + QuotedStr('0'));
  dm.IBselect.Open;

  if dm.IBselect.FieldByName(campo).Size = tamanhoComparar then Result := true;

  dm.IBselect.Close;
end;

function Tfuncoes.logar(usu, senha : String) : boolean;
begin
  Result := false;
  dm.IBQuery1.Close;
  dm.IBQuery1.SQL.Clear;
  dm.IBQuery1.SQL.Add('select cod, nome from usuario where (usu = :nome) and (senha = :senha) and excluido = 0');
  dm.IBQuery1.ParamByName('nome').AsString  := funcoes.Criptografar(usu);
  dm.IBQuery1.ParamByName('senha').AsString := funcoes.Criptografar(senha);
  dm.IBQuery1.Open;
  if dm.IBQuery1.IsEmpty then
    begin
      dm.IBQuery1.Close;
      ShowMessage('Usuário ou senha inválidos!!');
      exit;
    end
  else Result := true;

  dm.IBQuery1.Close;
end;

function Tfuncoes.trocaDeUsuario() : boolean;
begin
  Result := false;
  form53 := tform53.Create(self);
  form53.login_muda_as_variaveis_de_usuario(Result);
  form33.Free;
end;

function Tfuncoes.lerConfigIMPRESSORA()   : String;
var
  arq : TStringList;
  imp : integer;
  tp, tmp, arqConfig  : String;
begin
//1 - tipo de impressao *** 0-USB1 1-UBS2 2-LPT1 3-LPT2   ***
  Result := '';
  //arqConfig := funcoes.GetTheWindowsDirectory + '\conf_ter.dat';
  arqConfig := caminhoEXE_com_barra_no_final + 'config.dat';
  arq := TStringList.Create;
  if not FileExists(arqConfig) then
    begin
      criaArqTerminal();
   end;

  if FileExists(arqConfig) then
    begin
      arq.LoadFromFile(arqConfig);
      if ((arq.Values['1'] = '') or (not funcoes.Contido('-0-', arq.Values['1']))) then
        begin
          tmp := '-0- 0 -1- U -2- 5 -3- 5 -4- 10 -5- N -6- -7- -8- -9- -10- -11- ';
          imp := StrToIntDef(funcoes.LerConfig(form22.Pgerais.Values['conf_ter'], 5), 0);
          tmp := GravarConfig(tmp, IntToStr(imp), 0);

          tp  := funcoes.LerConfig(form22.Pgerais.Values['conf_ter'], 6);
          imp := 0;
          if tp = 'I' then      imp := 1
          else if tp = 'P' then imp := 2
          else if tp = 'X' then imp := 3;
          tmp := GravarConfig(tmp, IntToStr(imp), 1);

          imp := StrToIntDef(ConfParamGerais[24], 0); //lin Final
          tmp := GravarConfig(tmp, IntToStr(imp), 2);

          imp := StrToIntDef(ConfParamGerais[23], 0); //col inicial
          tmp := GravarConfig(tmp, IntToStr(imp), 3);

          imp := StrToIntDef(funcoes.LerConfig(form22.Pgerais.Values['conf_ter'], 3), 0);
          tmp := GravarConfig(tmp, IntToStr(imp), 4);

          tp  := funcoes.LerConfig(form22.Pgerais.Values['conf_ter'], 7);
          tmp := GravarConfig(tmp, tp, 6);

          arq.Values['1'] := tmp;
          arq.SaveToFile(arqConfig);
        end
     else //se nao existir
       begin
         arq.SaveToFile(arqConfig);
       end;

      arq.LoadFromFile(arqConfig);
      tmp := arq.Values['1'];
      arq.Free;
    end
  else
    begin
      ShowMessage('O sistema não encontrou o arquivo de configuração deste terminal.' + #13 +
      'Favor, acesse as configurações de terminal e volte novamente. Obrigado' );
      close;
      exit;
    end;

 form22.Pgerais.Values['imp'] := tmp;

 dm.ACBrETQ1.Modelo := TACBrETQModelo(StrToIntDef(LerConfig(form22.Pgerais.Values['imp'], 10), 0));
 dm.ACBrETQ1.Porta  := LerConfig(form22.Pgerais.Values['imp'], 8);

 fonteRelatorioForm19 := StrToIntDef(LerConfig(form22.Pgerais.Values['imp'], 13), 10);
 if LerConfig(form22.Pgerais.Values['imp'], 14) = 'S' then
   NegritoRelatorioForm19 := true
 else
   NegritoRelatorioForm19 := false;  

 Result := tmp;
end;

function Tfuncoes.formataChaveNFE(const chave : String) : String;
var
  fim, soma : integer;
begin
  Result := chave;
  fim  := length(chave);
  if fim <> 44 then exit;
  soma := 5;
  while true do
    begin
      if soma = 55 then break;
      insert('.', Result, soma);
      soma := soma + 5;
    end;
end;

function Tfuncoes.FORM_DATA_YY_MM_DD(data : TDateTime) : String;
begin
  Result := '';
  Result := FormatDateTime('yymmdd', data);
end;


//ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//INFORMAR NUM_NF (C-6) E TIPO (C-2)
//ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
FUNCTION Tfuncoes.CANC_MOV(NUM_NF, TIPO : String) : boolean;
//ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
var
  INFO, PEDIDO : String;
  ini : integer;
  MTT : TStringList;
begin
  MTT := TStringList.Create;
  NUM_NF := funcoes.CompletaOuRepete('', NUM_NF, '0', 7);
  IF TIPO = '90' then TIPO := '99'; //NF-e
  IF TIPO = '91' then TIPO := '98'; //Serie 1
  IF TIPO = '92' then TIPO := '97'; //Serie D
  IF(StrToInt(TIPO) <= 40) then TIPO := STRZERO(StrToInt(TIPO) + 40, 2);

  dm.IBselect.Close;
  dm.IBselect.SQL.Clear;
  dm.IBselect.SQL.Add('select item from fvmt where substring(item from 14 for 7) = :item');
  dm.IBselect.ParamByName('item').AsString := NUM_NF;
  dm.IBselect.Open;

  while not dm.IBselect.Eof do
    begin
      INFO := copy(dm.IBselect.fieldbyname('item').AsString, 1, length(dm.IBselect.fieldbyname('item').AsString) - 2);
      INFO := INFO + TIPO;

      MTT.Add(copy(info, 7, 7));

      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add('update fvmt set item = :item, estado = :est where item = :item1');
      dm.IBQuery1.ParamByName('item').AsString  := INFO;
      dm.IBQuery1.ParamByName('est').AsString   := 'C';
      dm.IBQuery1.ParamByName('item1').AsString := dm.IBselect.fieldbyname('item').AsString;
      dm.IBQuery1.ExecSQL;
      dm.IBselect.Next;
    end;

  try
   if dm.IBQuery1.Transaction.InTransaction then dm.IBQuery1.Transaction.Commit;
  except
  end;

  //CANCELA A EMISSAO DO ARQUIVO DE VENDAS
{  FOR ini := 0 TO MTT.Count -1 do
    begin
      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add('update venda set crc = ' + QuotedStr('') + ' where nota = :nota');
      dm.IBQuery1.ParamByName('nota').AsInteger := StrToIntDef(MTT[ini], 0);
      dm.IBQuery1.ExecSQL;
    end;
}
   try
    if dm.IBQuery1.Transaction.InTransaction then dm.IBQuery1.Transaction.Commit;
    mtt.Free;
  except
  end; 
END;


//ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//DATA (D-6), PEDIDO (C-7), NF (C-6), TIPO (C-2)-> TOTAL 22 BYTES
//DATA (1-6), PEDIDO (7-13), NF (14-20), TIPO (21-22)-> TOTAL 22 BYTES
//TIPO = (90-NFE EMITIDA 91-NF PAPEL EMITIDA 98-NF PAPEL CANCELADA
//99-NFE CANCELADA 01 A 40-NUM_ECF 41 A 80-CUPOM CANCELADO NUM_ECF + 40)
//ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
FUNCTION Tfuncoes.GRAVA_MOV(PEDIDO : String; DATA : tdatetime; NF, TIPO, COD_CLI : String; GRAV_VENDA : boolean) : boolean;
var
  INFO, NUM_PED      : String;
  REG, NUM, ini, fim : integer;
begin
  Result := false;

  PEDIDO := funcoes.CompletaOuRepete('', PEDIDO, '0', 7);//NUM_PED := IF(RIGHT(PEDIDO, 1) = "S", LEFT(PEDIDO, 6) + "1", RIGHT(PEDIDO, 6) + "0")//PEDIDO := IF(RIGHT(PEDIDO, 1) = "S", PEDIDO, RIGHT(PEDIDO, 6) + " ")
  NF     := funcoes.CompletaOuRepete('', NF, '0', 7);
  TIPO   := funcoes.CompletaOuRepete('', trim(tipo), '0', 2);
  INFO   := FORM_DATA_YY_MM_DD(DATA) + PEDIDO + NF + TIPO;

  dm.IBQuery1.Close;
  dm.IBQuery1.SQL.Clear;
  dm.IBQuery1.SQL.Add('update or insert into FVMT(item, data, estado) values(:item, :data, :estado) matching(item)');
  dm.IBQuery1.ParamByName('item').AsString   := INFO;
  dm.IBQuery1.ParamByName('data').AsDate     := DATA;
  dm.IBQuery1.ParamByName('estado').AsString := IfThen(TIPO = '90', 'E', 'C');
  dm.IBQuery1.ExecSQL;
  dm.IBQuery1.Transaction.Commit;
  Result := true;

  //SE ESTA VENDA FOI FEITA PELO PDV ON-LINE, ENTAO OS DADOS DO CUPOM
  //JA ESTAO GRAVADOS NO MOV DE VENDAS, RETORNA SEM GRAVAR

  dm.IBQuery1.Close;
  dm.IBQuery1.SQL.Clear;
  dm.IBQuery1.SQL.Add('update venda set crc = :crc where nota = :nota and crc = ''''');
  dm.IBQuery1.ParamByName('crc').AsString  := NF + TIPO;
  dm.IBQuery1.ParamByName('nota').AsString := PEDIDO;
  dm.IBQuery1.ExecSQL;
  dm.IBQuery1.Transaction.Commit;
end;

function Tfuncoes.NomedoComputador: String;
 var  
  buffer: Array[0..255] of char;
  size: DWord;  
 begin  
  size := 256;
  if GetComputerName (buffer,size) then  
   Result := Buffer  
  else  
   Result := '';  
 end;

procedure Tfuncoes.geraPgerais();
begin
  dm.IBQuery1.Close;
  dm.IBQuery1.SQL.Clear;
  dm.IBQuery1.sql.Add('select * from pgerais order by cod');
  dm.IBQuery1.Open;
  dm.IBQuery1.First;
  ConfParamGerais := tstringlist.Create;
  while not dm.IBQuery1.Eof do
    begin
      ConfParamGerais.Add(dm.IBQuery1.fieldbyname('valor').AsString);
      dm.IBQuery1.Next;
    end;

  try
    if ((ConfParamGerais[35] = '') or (ConfParamGerais[35] = 'S') or (ConfParamGerais[35] = 'N')) then ConfParamGerais[35] := '|Equip.|Marca|Modelo|Série|Técnico|Defeito|';
  except
  end;
  dm.IBQuery1.Close;
end;

procedure Tfuncoes.buscaEquivalencia(codEx : String);
var
  acumu, codigos, cb, eq : string;
  fim : integer;
begin
  dm.produtotemp.Close;
  dm.produtotemp.SQL.Clear;
  dm.produtotemp.SQL.Add('select REFORI AS equiva, cod, codbar from produto where cod = :cod');
  dm.produtotemp.ParamByName('cod').AsString := codEx;
  dm.produtotemp.Open;

  acumu := '';
  acumu := '|' + dm.produtotemp.fieldbyname('codbar').AsString + '|' + dm.produtotemp.fieldbyname('equiva').AsString + '|';
  codigos := '|' + dm.produto.fieldbyname('cod').AsString + '|';

  // abriu o ClientDataSet que irá varrer no OnCreate deste formulário
  // para não ficar criando toda hora

  fim := cdsEquiva.RecordCount;

  funcoes.informacao(0, fim,'Localizando Equivalentes...', true, false, 2);

  cdsEquiva.First;
  while not cdsEquiva.Eof do
    begin
      funcoes.informacao(cdsEquiva.RecNo, fim,'Localizando Equivalentes...', false, false, 2);

      cb := IfThen(trim(cdsEquiva.fieldbyname('codbar').AsString) <> '', '|' + cdsEquiva.fieldbyname('equiva').AsString + '|', '');
      //eq := IfThen(trim(cdsEquiva.fieldbyname('equiva').AsString) <> '', '|' + cdsEquiva.fieldbyname('equiva').AsString + '|', '');
      //eq := IfThen(trim(cdsEquiva.fieldbyname('REFORI').AsString) <> '', '|' + cdsEquiva.fieldbyname('REFORI').AsString + '|', '');

      if ( funcoes.Contido(cb, acumu)) or (funcoes.Contido(eq, acumu)) then
        begin
          if not funcoes.Contido('|' + cdsEquiva.fieldbyname('cod').AsString + '|', codigos) then
            begin
              codigos := codigos + cdsEquiva.fieldbyname('cod').AsString + '|';
              acumu   := acumu   + cdsEquiva.fieldbyname('codbar').AsString + '|' + cdsEquiva.fieldbyname('equiva').AsString + '|';
              cdsEquiva.First;
            end;
        end;

      cdsEquiva.Next;
    end;


  funcoes.informacao(0, fim,'Localizando Equivalentes...', false, true, 2);

  dm.produtotemp.Close;
  dm.produtotemp.SQL.Clear;
  dm.produtotemp.SQL.Add('select  nome as Descricao,quant,p_venda as Preco, refori, codbar, cod from produto where ' +
  //' ('+ QuotedStr(codigos) +' containing (''|'' || cast(cod as varchar(9)) || ''|'')) and (cod <> :cod) order by nome');
  ' ('+ QuotedStr(codigos) +' containing (''|'' || cast(cod as varchar(9)) || ''|''))  order by nome');
  //dm.produtotemp.ParamByName('cod').AsString  := codEx;
  dm.produtotemp.Open;

  funcoes.FormataCampos(dm.produtotemp, 2, '', 2);

  if dm.produtotemp.IsEmpty then
    begin
      dm.produtotemp.Close;
      ShowMessage('Este produto não há equivalências');
      exit;
    end;

  form25 := tform25.Create(self);
  funcoes.CtrlResize(tform(form25));
  form25.DBGrid1.DataSource := dm.dsprodtemp;
  form25.ShowModal;
end;

procedure Tfuncoes.buscaEquivalencia1(codEx : String);
var
  acumu, codigos, cb, eq : string;
  fim, ini : integer;
  ok : boolean;
begin
  if inicio1 = 1 then
    begin
      dm.produtotemp.Close;
      dm.produtotemp.SQL.Clear;
      dm.produtotemp.SQL.Add('select REFORI AS equiva, cod, codbar from produto');
      dm.produtotemp.Open;

      listaProdutos := Tprodutos.Create;
      while not dm.produtotemp.Eof do
        begin
          fim := listaProdutos.Add(TProduto.Create);
          listaProdutos[fim].cod    := dm.produtotemp.fieldbyname('cod').AsInteger;
          listaProdutos[fim].refori := dm.produtotemp.fieldbyname('equiva').AsString;
          listaProdutos[fim].codbar := dm.produtotemp.fieldbyname('codbar').AsString;
          dm.produtotemp.Next;
        end;

      inicio1 := 0;
    end;

  dm.produtotemp.Close;
  dm.produtotemp.SQL.Clear;
  dm.produtotemp.SQL.Add('select REFORI AS equiva, cod, codbar from produto where cod = :cod');
  dm.produtotemp.ParamByName('cod').AsString := codEx;
  dm.produtotemp.Open;

  acumu := '';
  if trim(dm.produtotemp.fieldbyname('codbar').AsString) <> '' then acumu := acumu + '|' + dm.produtotemp.fieldbyname('codbar').AsString + '|';
  if trim(dm.produtotemp.fieldbyname('equiva').AsString) <> '' then acumu := acumu + '|' + dm.produtotemp.fieldbyname('equiva').AsString + '|';
  codigos := '|' + dm.produto.fieldbyname('cod').AsString + '|';

  // abriu o ClientDataSet que irá varrer no OnCreate deste formulário
  // para não ficar criando toda hora

  fim := listaProdutos.Count - 1;

  funcoes.informacao(0, fim,'Localizando Equivalentes...', true, false, 2);

  //cdsEquiva.First;
  //while not cdsEquiva.Eof do
  fim := listaProdutos.Count - 1;
  ini := 0;
  //for ini := 0 to fim do
  while true do
    begin
      if ini = fim then break;
      funcoes.informacao(ini, fim,'Localizando Equivalentes...', false, false, 2);
      ok := false;

      if trim(listaProdutos[ini].codbar) <> '' then
        begin
          if Contido('|'+listaProdutos[ini].codbar + '|', acumu) and (Contido('|' + IntToStr(listaProdutos[ini].cod) + '|', codigos) = false) then
            begin
              codigos := codigos + IntToStr(listaProdutos[ini].cod) + '|';
              acumu   := acumu   + listaProdutos[ini].codbar + '|' + listaProdutos[ini].refori + '|';
              //ini := -1;
              ok := true;
            end;
        end;

      if trim(listaProdutos[ini].refori) <> '' then
        begin
          if Contido('|'+listaProdutos[ini].refori + '|', acumu) and (Contido('|' + IntToStr(listaProdutos[ini].cod) + '|', codigos) = false) then
            begin
              codigos := codigos + IntToStr(listaProdutos[ini].cod) + '|';
              acumu   := acumu   + listaProdutos[ini].codbar + '|' + listaProdutos[ini].refori + '|';
              //ini := -1;
              ok := true;
            end;
        end;

      if ok then
        begin
          ini := -1;
          //ShowMessage(codigos);
        end;
      ini := ini + 1;
    end;


  funcoes.informacao(0, fim,'Localizando Equivalentes...', false, true, 2);

  dm.produtotemp.Close;
  dm.produtotemp.SQL.Clear;
  dm.produtotemp.SQL.Add('select  nome as Descricao,quant,p_venda as Preco, refori, codbar, cod from produto where ' +
  //' ('+ QuotedStr(codigos) +' containing (''|'' || cast(cod as varchar(9)) || ''|'')) and (cod <> :cod) order by nome');
  ' ('+ QuotedStr(codigos) +' containing (''|'' || cast(cod as varchar(9)) || ''|''))  order by nome');
  //dm.produtotemp.ParamByName('cod').AsString  := codEx;
  dm.produtotemp.Open;

  funcoes.FormataCampos(dm.produtotemp, 2, '', 2);

  if dm.produtotemp.IsEmpty then
    begin
      dm.produtotemp.Close;
      ShowMessage('Este produto não há equivalências');
      exit;
    end;

  form25 := tform25.Create(self);
  funcoes.CtrlResize(tform(form25));
  form25.DBGrid1.DataSource := dm.dsprodtemp;
  form25.ShowModal;
end;

procedure Tfuncoes.abreDataSetMemoriaEquivalencias();
begin
  cdsEquiva := TClientDataSet.Create(self);

  dm.produtotemp.Close;
  dm.produtotemp.SQL.Clear;
  //dm.produtotemp.SQL.Add('select equiva, cod, codbar from produto');
  dm.produtotemp.SQL.Add('select REFORI AS equiva, cod, codbar from produto');
  dm.produtotemp.Open;
  dm.produtotemp.FetchAll;

  DataSetProvider1.DataSet := dm.produtotemp;

  cdsEquiva.ProviderName := 'DataSetProvider1';
  cdsEquiva.Open;

  dm.produtotemp.Close;
end;

function formataCurrency(const valor : currency) : String ;
begin
  Result := FormatCurr('#,###,###0.00', valor);
end;

function Tfuncoes.primeiraLetraMaiuscula(const nome : string) : string;
begin
  Result := '';
  Result := UpCase(nome[1]) + copy(nome, 2, length(nome));
end;


procedure Tfuncoes.CriarAtalho(ANomeArquivo, AParametros, ADiretorioInicial,
  ANomedoAtalho, APastaDoAtalho: string);
var
  MeuObjeto: IUnknown;
  MeuSLink: IShellLink;
  MeuPFile: IPersistFile;
  Diretorio: string;
  wNomeArquivo: WideString;
  MeuRegistro: TRegIniFile;
begin

  //Cria e instancia os objetos usados para criar o atalho

  MeuObjeto := CreateComObject(CLSID_ShellLink);

  MeuSLink := MeuObjeto as IShellLink;

  MeuPFile := MeuObjeto as IPersistFile;

  with MeuSLink do

  begin

    SetArguments(PChar(AParametros));

    SetPath(PChar(ANomeArquivo));

    SetWorkingDirectory(PChar(ExtractFilePath(ADiretorioInicial)));

  end;

  //Pega endereço da pasta Desktop do Windows

  MeuRegistro :=

    TRegIniFile.Create('Software\MicroSoft\Windows\CurrentVersion\Explorer');

  Diretorio := MeuRegistro.ReadString('Shell Folders', 'Desktop', '');

  wNomeArquivo := Diretorio + '\' + ANomedoAtalho + '.lnk';

  //Cria de fato o atalho na tela

  MeuPFile.Save(PWChar(wNomeArquivo), False);

  MeuRegistro.Free;

end;

function Tfuncoes.reorganizaProdutos : boolean;
var
  cod, fim : integer;
  stat : Smallint;
begin
  dm.IBselect.Close;
  dm.IBselect.SQL.Clear;
  dm.IBselect.SQL.Add('select cod, p_compra, p_venda, nome from produto');
  dm.IBselect.Open;
  dm.IBselect.FetchAll;
  fim := dm.IBselect.RecordCount;

  if dm.IBQuery1.Transaction.InTransaction then dm.IBQuery1.Transaction.Commit;
  dm.IBQuery1.Transaction.StartTransaction;


  funcoes.informacao(1,2,'AGUARDE... ',true,false,2);
  while not dm.IBselect.Eof do
    begin
      stat := -1;
      cod := dm.IBselect.FieldByName('cod').AsInteger;

      funcoes.informacao(dm.IBselect.RecNo, fim,'AGUARDE... ',false,false,2);

      if ((dm.IBselect.FieldByName('nome').AsString = '') or (dm.IBselect.FieldByName('nome').IsNull)) then
        begin

          dm.IBQuery1.Close;
          dm.IBQuery1.SQL.Clear;
          dm.IBQuery1.SQL.Add('delete from produto where cod = :cod');
          dm.IBQuery1.ParamByName('cod').AsInteger := cod;
          dm.IBQuery1.ExecSQL;
        end
      else if dm.IBselect.FieldByName('p_compra').AsCurrency = dm.IBselect.FieldByName('p_venda').AsCurrency then
        begin
          dm.IBQuery1.Close;
          dm.IBQuery1.SQL.Clear;
          dm.IBQuery1.SQL.Add('update produto set p_compra = :vl where cod = :cod');
          dm.IBQuery1.ParamByName('vl').AsCurrency := arredonda(dm.IBselect.FieldByName('p_venda').AsCurrency / 2, 2);
          dm.IBQuery1.ParamByName('cod').AsInteger := cod;
          dm.IBQuery1.ExecSQL;
        end;

      dm.IBselect.Next;
    end;

  funcoes.informacao(dm.IBselect.RecNo, fim,'AGUARDE... ',false,true,2);  
  if dm.IBQuery1.Transaction.InTransaction then dm.IBQuery1.Transaction.Commit;

  dm.IBselect.Close;
end;

function Tfuncoes.reorganizaClientes : boolean;
var
  cod, fim : integer;
  stat : Smallint;
begin
  dm.IBselect.Close;
  dm.IBselect.SQL.Clear;
  dm.IBselect.SQL.Add('select cod, nome from cliente');
  dm.IBselect.Open;
  dm.IBselect.FetchAll;
  fim := dm.IBselect.RecordCount;

  if dm.IBQuery1.Transaction.InTransaction then dm.IBQuery1.Transaction.Commit;
  dm.IBQuery1.Transaction.StartTransaction;


  funcoes.informacao(1,2,'AGUARDE... ',true,false,2);
  while not dm.IBselect.Eof do
    begin
      stat := -1;
      cod := dm.IBselect.FieldByName('cod').AsInteger;

      funcoes.informacao(dm.IBselect.RecNo, fim,'AGUARDE... ',false,false,2);

      if ((dm.IBselect.FieldByName('nome').AsString = '') or (dm.IBselect.FieldByName('nome').IsNull)) then
        begin
          dm.IBQuery1.Close;
          dm.IBQuery1.SQL.Clear;
          dm.IBQuery1.SQL.Add('delete from cliente where cod = :cod');
          dm.IBQuery1.ParamByName('cod').AsInteger := cod;
          dm.IBQuery1.ExecSQL;
        end;

      dm.IBselect.Next;
    end;

  funcoes.informacao(dm.IBselect.RecNo, fim,'AGUARDE... ',false,true,2);  
  if dm.IBQuery1.Transaction.InTransaction then dm.IBQuery1.Transaction.Commit;

  dm.IBselect.Close;
end;

function Tfuncoes.senhaDodia : boolean;
var
  senha, sen : String;
begin
  Result := true;
  senha := funcoes.dialogo('generico',30,'1234567890'+#8,30,false,'',Application.Title,'Qual a senha do Dia?','');

  sen := IntToStr(StrToIntDef(FormatDateTime('dd', form22.datamov), 1) * StrToIntDef(FormatDateTime('mm', form22.datamov), 1));
  if senha <> sen then
    begin
      ShowMessage('Senha Incorreta');
      Result := false;
    end;
end;


procedure Tfuncoes.somaQTD_produto_ibquery1_sem_commit(cod : integer; var qtd, deposito : currency);
begin
  dm.IBQuery1.Close;
  dm.IBQuery1.SQL.Clear;
  dm.IBQuery1.SQL.Add('update produto set quant = quant + :quant, deposito = deposito + :dep where cod = :cod');
  dm.IBQuery1.ParamByName('quant').AsCurrency := qtd;
  //m.IBQuery1.
  dm.IBQuery1.ExecSQL;
end;

FUNCTION Tfuncoes.BUSCA_EST(COD : integer; var QTD_LOJA, QTD_DEP : currency; var lista : TItensAcumProd) : boolean;
var
  idx : integer;
begin
  idx := lista.Find(cod);
  if idx = -1 then
    begin
      QTD_LOJA := 0;
      QTD_DEP  := 0;
    end
  else
    begin
      QTD_LOJA := lista[idx].quant;
      QTD_DEP  := lista[idx].dep;
    end;

  {if cds1.FindKey([cod]) then
    begin
      QTD_LOJA := cds1.FieldByName('loja').AsCurrency;
      QTD_DEP  := cds1.FieldByName('deposito').AsCurrency;
    end
  else
    begin
      QTD_LOJA := 0;
      QTD_DEP  := 0;
    end;}
end;

FUNCTION Tfuncoes.ATU_ESTOQUE(ACAO : String; var lista : TItensAcumProd; cod1 : integer = 0) : boolean;
var
  QTD, DEP, QTD1, DEP1 : currency;
  COD, fimDataSet, Trans, cont : integer;
begin
  Result := false;
  dm.IBselect.Close;
  dm.IBselect.SQL.Clear;
  if cod = 0 then dm.IBselect.SQL.Add('select cod, quant, deposito from produto')
  else
    begin
      dm.IBselect.SQL.Add('select cod, quant, deposito from produto where cod = :cod');
      dm.IBselect.ParamByName('cod').AsInteger := cod1;
    end;
  dm.IBselect.Open;
  dm.IBselect.FetchAll;

  //DBGrid1.DataSource.DataSet := dm.IBselect;
  //Show;

  fimDataSet := dm.IBselect.RecordCount;
  funcoes.informacao(0, fimDataSet, 'Aguarde, Atualizando estoque...', true, false, 5);

  dm.IBQuery1.Close;
  if dm.IBQuery1.Transaction.InTransaction then dm.IBQuery1.Transaction.Commit;
  dm.IBQuery1.Transaction.StartTransaction;
  trans := 100;
  cont  := 0;

  while not dm.IBselect.Eof do
    begin
      {if cont >= trans then
        begin
          trans := trans + 100;
          if dm.IBQuery1.Transaction.InTransaction then dm.IBQuery1.Transaction.Commit;
        end;}  

      Application.ProcessMessages;
      funcoes.informacao(cont, fimDataSet, 'Aguarde, Atualizando estoque...', false, false, 5);
      COD := dm.IBselect.FieldByName('cod').AsInteger;
      funcoes.BUSCA_EST(COD, QTD, DEP, lista);
      dm.IBQuery1.SQL.Clear;

      IF ACAO = 'ACERTA' then
        begin
          dm.IBQuery1.SQL.Add('update produto set SAL = :qtd, SAD = :dep where cod = :cod');
          QTD := dm.IBselect.fieldbyname('quant').AsCurrency    - (QTD);
          //DEP := dm.IBselect.fieldbyname('deposito').AsCurrency - (DEP);

          dm.IBQuery1.ParamByName('qtd').AsCurrency := QTD;
          dm.IBQuery1.ParamByName('dep').AsCurrency := DEP;
          dm.IBQuery1.ParamByName('cod').AsInteger  := COD;
          dm.IBQuery1.ExecSQL;
        end
      ELSE IF ACAO = 'RECALCULA' then
        begin
          dm.IBQuery1.SQL.Add('update produto set QUANT = SAL + :qtd, DEPOSITO = SAD + :dep where cod = :cod');
          dm.IBQuery1.ParamByName('qtd').AsCurrency := QTD;
          dm.IBQuery1.ParamByName('dep').AsCurrency := DEP;
          dm.IBQuery1.ParamByName('cod').AsInteger := COD;
          dm.IBQuery1.ExecSQL;
        end
      ELSE IF ACAO = 'TRANSPORTA' then
        begin
          dm.IBQuery1.SQL.Add('update produto set SAL = SAL + :qtd, SAD = SAD + :dep where cod = :cod');
          dm.IBQuery1.ParamByName('qtd').AsCurrency := QTD;
          dm.IBQuery1.ParamByName('dep').AsCurrency := DEP;
          dm.IBQuery1.ParamByName('cod').AsInteger := COD;
          dm.IBQuery1.ExecSQL;
        end
      ELSE IF ACAO = 'SOMA' then
        begin
          dm.IBQuery1.SQL.Add('update produto set QUANT = QUANT + :qtd, DEPOSITO = DEPOSITO + :dep where cod = :cod');
          dm.IBQuery1.ParamByName('qtd').AsCurrency := QTD;
          dm.IBQuery1.ParamByName('dep').AsCurrency := DEP;
          dm.IBQuery1.ParamByName('cod').AsInteger := COD;
          dm.IBQuery1.ExecSQL;
        end
      ELSE IF ACAO = 'MINIMO' then
        begin
          dm.IBQuery1.SQL.Add('update produto set ESTOQUE = :qtd, SUGESTAO = :dep where cod = :cod');
          dm.IBQuery1.ParamByName('qtd').AsCurrency := QTD;
          dm.IBQuery1.ParamByName('dep').AsCurrency := DEP;
          dm.IBQuery1.ParamByName('cod').AsInteger := COD;
          dm.IBQuery1.ExecSQL;
        end;


      {ELSE IF ACAO = 'MINIMO' then
        begin
          FIELD->ESTOQUE := ARREDONDA((ABS(QTD) / MOVI) * PER_MIN, 2);
          FIELD->SUGESTAO := MAIOR(0, ABS(DEP) - (FIELD->QUANT + FIELD->DEPOSITO) );
        end;
       }

     dm.IBselect.Next;
     cont := cont + 1;
    end;

   if dm.IBQuery1.Transaction.InTransaction then dm.IBQuery1.Transaction.Commit;
   funcoes.informacao(cont, fimDataSet, 'Aguarde, Atualizando estoque...', false, true, 5);
   Result := true;
end;

function Tfuncoes.verProdutoExisteRetornaNome(const cod : string; var nome : String) : boolean;
begin
  nome := '**Produto não encontrado**';
  Result := false;

  dm.IBselect.Close;
  dm.IBselect.SQL.Clear;
  dm.IBselect.SQL.Add('select nome, cod from produto where cod = :cod');
  dm.IBselect.ParamByName('cod').AsString := cod;
  dm.IBselect.Open;

  if not dm.IBselect.IsEmpty then
    begin
      nome   := dm.IBselect.fieldbyname('nome').AsString;
      Result := true;
    end;

  dm.IBselect.Close;
end;

procedure Tfuncoes.SOMA_EST(const COD : integer;const QTD, DEP : currency;var lista : TItensAcumProd) ;
var
  idx : integer;
begin
  idx := lista.Find(COD);
  if idx = -1 then
    begin
      lista.Add(TacumProd.Create);
      TacumProd(lista.Last).cod   := COD;
      TacumProd(lista.Last).quant := qtd;
      TacumProd(lista.Last).dep   := DEP;
    end
  else
    begin
      lista[idx].quant := lista[idx].quant + qtd;
      lista[idx].dep   := lista[idx].dep   + DEP;
    end;

  {exit;
  if cds1.FindKey([COD]) then
    begin
      cds1.Edit;
      cds1.FieldByName('deposito').AsCurrency := cds1.FieldByName('deposito').AsCurrency + DEP;
      cds1.FieldByName('loja').AsCurrency := cds1.FieldByName('loja').AsCurrency + QTD;
      cds1.Post;
    end
  else
    begin
      cds1.Insert;
      cds1.FieldByName('cod').AsInteger       := COD;
      cds1.FieldByName('deposito').AsCurrency := 0;
      cds1.FieldByName('loja').AsCurrency     := 0;

      cds1.FieldByName('deposito').AsCurrency := cds1.FieldByName('deposito').AsCurrency + DEP;
      cds1.FieldByName('loja').AsCurrency := cds1.FieldByName('loja').AsCurrency + QTD;

      cds1.Post;
    end;}
end;

FUNCTION Tfuncoes.LE_ESTOQUE(PULA_REGISTRO, SO_VENDAS : boolean; var lista : TItensAcumProd;cod1 : integer = 0) : String;
var
  campo : TField;
  ini, fimDataSet, mut, idx, i : integer;
  loja, deposito : currency;
  cdsUnidade : TClientDataSet;
begin
  {cds1 := TClientDataSet.Create(self);
  //DataSource1.DataSet := cds1;

  cds1.FieldDefs.Add('cod', ftInteger);
  cds1.FieldDefs.Add('loja', ftCurrency);
  cds1.FieldDefs.Add('deposito', ftCurrency);
  cds1.CreateDataSet;
  cds1.IndexFieldNames := 'cod';}
  //criou o dataset na memoria com os campos acima e setou um indice por COD para
  // a pesquisa ficar mais rapida

  //Destino 1-Estoque 2-Depósito

  /// INICIO DADOS DE VENDAS ///
  dm.IBselect.Close;
  dm.IBselect.SQL.Clear;
  //dm.IBselect.SQL.Add('select quant, origem, cod from item_venda, venda where cancelado = 0');

  if cod1 = 0 then dm.IBselect.SQL.Add('select i.nota,i.quant, i.origem, i.cod from item_venda i, venda v where v.nota = i.nota and v.cancelado = 0')
   else
     begin
       dm.IBselect.SQL.Add('select i.nota,i.quant, i.origem, i.cod from item_venda i, venda v where v.nota = i.nota and v.cancelado = 0 and i.cod = :cod');
       dm.IBselect.ParamByName('cod').AsInteger := cod1;
     end;

  dm.IBselect.Open;
  dm.IBselect.FetchAll;

  fimDataSet := dm.IBselect.RecordCount;
  funcoes.informacao(0, fimDataSet, 'Aguarde, Verificando vendas...', true, false, 5);
  while not dm.IBselect.Eof do
    begin
      Application.ProcessMessages;
      funcoes.informacao(dm.IBselect.RecNo, fimDataSet, 'Aguarde, Verificando vendas...', false, false, 5);
      loja := 0;
      deposito := 0;
      idx  := 0;

      if dm.IBselect.FieldByName('origem').AsInteger = 2 then deposito := - dm.IBselect.FieldByName('quant').AsCurrency
        else loja := - dm.IBselect.FieldByName('quant').AsCurrency;

     SOMA_EST(dm.IBselect.FieldByName('cod').AsInteger, loja, deposito, lista);
     dm.IBselect.Next;
    end;

  //loja :=
  funcoes.informacao(dm.IBselect.RecNo, fimDataSet, 'Aguarde, Verificando vendas...', false, true, 5);
  /// FIM DADOS DE VENDAS ///


  /// INICIO DADOS DE TRANSFERENCIAS ///
  dm.IBselect.Close;
  dm.IBselect.SQL.Clear;

  if cod1 = 0 then dm.IBselect.SQL.Add('select quant, destino, cod from TRANSFERENCIA')
    else
      begin
        dm.IBselect.SQL.Add('select quant, destino, cod from TRANSFERENCIA where cod = :cod');
        dm.IBselect.ParamByName('cod').AsInteger := cod1;
      end;
  dm.IBselect.Open;
  dm.IBselect.FetchAll;

  fimDataSet := dm.IBselect.RecordCount;
  funcoes.informacao(0, fimDataSet, 'Aguarde, Verificando transferências...', true, false, 5);
  while not dm.IBselect.Eof do
    begin
      funcoes.informacao(dm.IBselect.RecNo, fimDataSet, 'Aguarde, Verificando transferências...', false, false, 5);

      if dm.IBselect.FieldByName('destino').AsInteger = 2 then
        begin
          deposito := dm.IBselect.FieldByName('quant').AsCurrency;
          loja     := - dm.IBselect.FieldByName('quant').AsCurrency;
        end
      else
        begin
          deposito := - dm.IBselect.FieldByName('quant').AsCurrency;
          loja     := dm.IBselect.FieldByName('quant').AsCurrency;
        end;

      SOMA_EST(dm.IBselect.FieldByName('cod').AsInteger, loja, deposito, lista);
      dm.IBselect.Next;
    end;

  funcoes.informacao(dm.IBselect.RecNo, fimDataSet, 'Aguarde, Verificando transferências...', false, true, 5);
  /// FIM DADOS DE TRANSFERENCIAS ///


  /// INICIO DADOS DE ENTRADAS ///

  {cdsUnidade := TClientDataSet.Create(self);

  cdsUnidade.FieldDefs.Add('cod', ftString, 8);
  cdsUnidade.FieldDefs.Add('qtd', ftInteger);
  cdsUnidade.CreateDataSet;
  cdsUnidade.IndexFieldNames := 'cod';

  dm.IBselect.Close;
  dm.IBselect.SQL.Clear;
  dm.IBselect.SQL.Add('select NOME, MULTIPLO from UNID');
  dm.IBselect.Open;

  while not dm.IBselect.Eof do
    begin
      Application.ProcessMessages;
      cdsUnidade.Insert;
      cdsUnidade.FieldByName('cod').AsString  := dm.IBselect.FieldByName('nome').AsString;
      cdsUnidade.FieldByName('qtd').AsInteger := dm.IBselect.FieldByName('MULTIPLO').AsInteger;
      cdsUnidade.Post;

      dm.IBselect.Next;
    end; }

  dm.IBselect.Close;
  dm.IBselect.SQL.Clear;
  if cod1 = 0 then dm.IBselect.SQL.Add('select quant, destino, cod, UNID2, UNID from ITEM_ENTRADA')
    else
      begin
        dm.IBselect.SQL.Add('select quant, destino, cod, UNID2, UNID from ITEM_ENTRADA where cod = :cod');
        dm.IBselect.ParamByName('cod').AsInteger := cod1;
      end;

  dm.IBselect.Open;
  dm.IBselect.FetchAll;

  fimDataSet := dm.IBselect.RecordCount;
  funcoes.informacao(0, fimDataSet, 'Aguarde, Verificando entradas...', true, false, 5);
  while not dm.IBselect.Eof do
    begin
      funcoes.informacao(dm.IBselect.RecNo, fimDataSet, 'Aguarde, Verificando entradas...', false, false, 5);
      loja := 0; deposito := 0;
      //loja := funcoes.verValorUnidade(dm.IBselect.FieldByName('UNID').AsString);

      if dm.IBselect.FieldByName('destino').AsInteger = 2 then
        begin
          deposito := funcoes.verValorUnidade(dm.IBselect.FieldByName('UNID').AsString) * dm.IBselect.FieldByName('quant').AsCurrency;
        end
      else
        begin
          loja     := funcoes.verValorUnidade(dm.IBselect.FieldByName('UNID').AsString) * dm.IBselect.FieldByName('quant').AsCurrency;
        end;


      {if ((dm.IBselect.FieldByName('UNID2').AsString + dm.IBselect.FieldByName('UNID').AsString) <> '') then
        begin
          if cdsUnidade.FindKey([dm.IBselect.FieldByName('UNID2').AsString]) then
            begin
              loja     := loja     * cdsUnidade.fieldbyname('qtd').AsInteger;
              deposito := deposito * cdsUnidade.fieldbyname('qtd').AsInteger;
            end;
        end;}

      SOMA_EST(dm.IBselect.FieldByName('cod').AsInteger, loja, deposito, lista);
      dm.IBselect.Next;
    end;

  //ShowMessage(lista.getText);
  funcoes.informacao(dm.IBselect.RecNo, fimDataSet, 'Aguarde, Verificando entradas...', false, true, 5);
  /// FIM DADOS DE ENTRADAS ///


 //cdsUnidade.Free;
end;

procedure Tfuncoes.VER_ESTOQUE(ACAO, MENS, MENS1 : String; cod : integer = 0);
var
  sim : String;
  lista : TItensAcumProd;
  i : integer;
begin
  sim := funcoes.dialogo('generico',0,'SN'+#8,0,true,'S','Control For Windows','Confirma ' + MENS1 + 'o de Fichas de Estoque ?', '') ;
  if ((sim = '*') or (sim = 'N')) then exit;

  lista := TItensAcumProd.Create;
  try
    LE_ESTOQUE(false, false, lista, cod); //ler os dados de entrada e saida do produto e joga no CDS1
  except
    lista.Free;
    ShowMessage('Ocorreu um erro na leitura dos produtos.');
    exit;
  end;

  //i := lista.Find(2287);
  //ShowMessage('quant='+CurrToStr(lista[i].quant) + #13 + 'dep=' + CurrToStr(lista[i].dep));

  if not ATU_ESTOQUE(ACAO, lista, cod) then
    begin
      ShowMessage('Não foi possível atualizar o estoque');
      lista.Free;
      exit;
    end;

  ShowMessage('Estoque ' + MENS1 + 'ado Com Sucesso');
  lista.Free;
end;

function Tfuncoes.buscaConfigNaPastaDoControlW1(Const config_name : String) : String;
var
  arq : TStringList;
begin
  if not FileExists(caminhoEXE_com_barra_no_final + 'CONFIG.DAT') then
    begin
      arq := TStringList.Create;
      arq.SaveToFile(caminhoEXE_com_barra_no_final + 'CONFIG.DAT');
      arq.Free;
    end;

  Result := '';
  arq := TStringList.Create;
  arq.LoadFromFile(caminhoEXE_com_barra_no_final + 'CONFIG.DAT');

  Result := arq.Values[config_name];
end;


function Tfuncoes.GravaConfigNaPastaDoControlW(Const config_name : String; const default : string) : String;
var
  arq : TStringList;
begin
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


function Tfuncoes.VE_PAIS() : String;
begin
  Result := '1058';
  Result := funcoes.localizar('Localizar País', 'Paises', 'cod, nome', 'cod', 'cod', 'nome', 'nome', false, false, false,'', 300, nil);
end;

function Tfuncoes.CriaDiretorio(const NomeSubDir: string) : boolean;
begin
  try
    if not DirectoryExists(NomeSubDir) then
      ForceDirectories(NomeSubDir);
  except
  end;
end;



function Tfuncoes.buscaConfigNaPastaDoControlW(Const config_name : String; const default : string) : String;
var
  arq : TStringList;
begin
  if not FileExists(caminhoEXE_com_barra_no_final + 'CONFIG.DAT') then
    begin
      arq := TStringList.Create;
      arq.SaveToFile(caminhoEXE_com_barra_no_final + 'CONFIG.DAT');
      arq.Free;
    end;

  arq := TStringList.Create;
  arq.LoadFromFile(caminhoEXE_com_barra_no_final + 'CONFIG.DAT');
  if trim(arq.Values[config_name]) = '' then arq.Values[config_name] := default;

  Result := '';
  Result := arq.Values[config_name];
  arq.SaveToFile(caminhoEXE_com_barra_no_final + 'CONFIG.DAT');
  arq.Free;
end;

procedure Tfuncoes.copiaExecutavel();
var
  execServidor, copia, arqTmp : string;
  bat : TStringList;
  ini : integer;
begin
  if ParamCount > 0 then
    begin
      if funcoes.Contido(':', ParamStr(1)) then execServidor := copy(ParamStr(1), 1, pos(':', ParamStr(1)) -1)
        else execServidor := ParamStr(1);

      if not funcoes.Contido('\', execServidor) then execServidor := '\\' + execServidor;
      execServidor := funcoes.buscaConfigNaPastaDoControlW('compartilhamentoExec', execServidor + '\ControlW\ControlW.exe');

      if not fileexists(execServidor) then
        begin
          ShowMessage('O sistema tentou procurar atualização em:' + #13 +
          execServidor + #13 + 'Mas não conseguiu encontrar,' + #13 + 'Favor, Campartilhe a pasta do ControlW no Servidor' + #13 + ' para que a Atualização Automática Funcione.' );
          exit;
        end;

      //ShowMessage(execServidor+' = '+DateToStr(funcoes.dataDoArquivo(execServidor)) + #13 +ParamStr(0) +' = ' + DateToStr(funcoes.dataDoArquivo(ParamStr(0))));
      if funcoes.dataDoArquivo(execServidor) > funcoes.dataDoArquivo(ParamStr(0)) then
        begin
          //if MessageDlg('Deseja Atualizar o Sistema Agora ?', mtConfirmation, [mbYes, mbNo], 1) = idno then exit;

          if FileExists(caminhoEXE_com_barra_no_final + 'ControlW.old') then DeleteFile(caminhoEXE_com_barra_no_final + 'ControlW.old');
          CopyFile(pchar(execServidor), pchar(caminhoEXE_com_barra_no_final + 'ControlW.old'), true);

          arqTmp := ExtractFileDir(execServidor) + '\';

          bat := funcoes.listaArquivos(arqTmp + '*.dll');

          for ini := 0 to bat.Count -1 do
            begin
              try
                CopyFile(pchar(arqTmp + bat[ini]), pchar(caminhoEXE_com_barra_no_final + bat[ini]), true);
              except
              end;
            end;

          bat := funcoes.listaArquivos(arqTmp + '*.csv');

          for ini := 0 to bat.Count -1 do
            begin
              try
                CopyFile(pchar(arqTmp + bat[ini]), pchar(caminhoEXE_com_barra_no_final + bat[ini]), true);
              except
              end;
            end;

          {bat := TStringList.Create;
          bat.Add('del ControlW.old1');
          bat.Add('rename ControlW.exe ControlW.old1');
          bat.Add('rename ControlW.old ControlW.exe');
          bat.Add('start ControlW.exe');
          bat.Add('exit');

          bat.SaveToFile(caminhoEXE_com_barra_no_final + 'cp.bat');
          bat.Free;       }


          if FileExists(caminhoEXE_com_barra_no_final + 'atualiza.exe') then
            begin
              WinExec(pchar(caminhoEXE_com_barra_no_final + 'atualiza.exe -c'), 0);
              Application.Terminate;
            end;
        end;
    end;
end;

procedure Tfuncoes.mapearLPT1_em_rede();
var
  arq : TStringList;
  tmp, lpt : string;
begin
  tmp := funcoes.buscaConfigNaPastaDoControlW('impress_rede', '\\127.0.0.1\generica');

  if ((tmp = '\\127.0.0.1\generica') or (tmp = '')) then
    begin
      exit;
    end;

  lpt := '';

  if funcoes.LerConfig(form22.Pgerais.Values['imp'], 1) = '2' then lpt := 'LPT1'
    else if funcoes.LerConfig(form22.Pgerais.Values['imp'], 1) = '3' then lpt := 'LPT2';

  if lpt = '' then exit;  

  arq := TStringList.Create;
  arq.Add('@echo off');
  arq.Add('net use ' + lpt + ' /delete');
  arq.Add('net use ' + lpt + ' ' + tmp + ' /y');
  arq.Add('exit');

  arq.SaveToFile(caminhoEXE_com_barra_no_final + 'impress.bat');
  try
    arq.Free;
  except
  end;

  WinExec(pchar(caminhoEXE_com_barra_no_final + 'impress.bat'), SW_HIDE);
  //arq.Free;
end;

function Tfuncoes.dadosAdicSped(xml : String) : tstringlist;
var
  fe : TStringList;
  tmp, chave1 : string;
begin
  // para usar esta funcao o form NfeVenda deve estar criado

  chave1 := funcoes.entraXMLeRetornaChave(xml);
  fe := TStringList.Create;
  fe.Add(Le_Nodo('mod', xml));     //0 tipo
  fe.Add(Le_Nodo('serie', xml));   //1 serie
  fe.Add(Le_Nodo('CFOP', xml));    //2 cfop
  fe.Add(Le_Nodo('modFrete', xml));//3 tipofrete

  tmp := Le_Nodo('ICMSTot', xml);

  fe.Add(StringReplace(Le_Nodo('vSeg', tmp), '.', ',', [rfReplaceAll, rfIgnoreCase]));      //4 totseg
  fe.Add(StringReplace(Le_Nodo('vDesc', tmp), '.', ',', [rfReplaceAll, rfIgnoreCase]));     //5 totdesc
  fe.Add(StringReplace(Le_Nodo('vOutro', tmp), '.', ',', [rfReplaceAll, rfIgnoreCase]));    //6 desp Acessorias
  fe.Add(StringReplace(Le_Nodo('vPIS', tmp), '.', ',', [rfReplaceAll, rfIgnoreCase]));      //7 totpis
  fe.Add(StringReplace(Le_Nodo('vCOFINS', tmp), '.', ',', [rfReplaceAll, rfIgnoreCase]));   //8 totcofins
  fe.Add(StringReplace(Le_Nodo('vICMS', tmp), '.', ',', [rfReplaceAll, rfIgnoreCase]));      //9 CredICMS
  fe.Add(chave1);                                                                                     //10 chave
  fe.Add(StringReplace(Le_Nodo('vFrete', tmp), '.', ',', [rfReplaceAll, rfIgnoreCase]));     //11 totfrete

  fe.Add(Le_Nodo('nNF', xml));     //12 NOTA
  Result := fe;
end;

procedure Tfuncoes.copiaXMLEntrada(const xml, chave : String);
begin
  if not DirectoryExists(caminhoEXE_com_barra_no_final + 'NFE') then
    begin
      ForceDirectories(caminhoEXE_com_barra_no_final + 'NFE');
    end;
  if not DirectoryExists(caminhoEXE_com_barra_no_final + 'NFE\ENT') then
    begin
      ForceDirectories(caminhoEXE_com_barra_no_final + 'NFE\ENT');
    end;

  CopyFile(pansichar(xml), pansichar(caminhoEXE_com_barra_no_final + 'NFE\ENT\' + chave + '-nfe.xml'), true);
  DeleteFile(pansichar(xml));
end;

function Tfuncoes.formataCPF(const cpf : String) : String;
begin
  Result := '';
  Result := Copy(CPF,1,3) + '.' + Copy(CPF,4,3) + '.' + Copy(CPF,7,3) + '-' + Copy(CPF,10,2);
end;

function Tfuncoes.formataCNPJ(Const cnpj : String) : String;
begin
  Result := '';
  Result := Copy(cnpj,1,2) + '.' + Copy(cnpj,3,3) + '.' + Copy(cnpj,6,3) + '/' + Copy(cnpj, 9, 4) + '-' + Copy(cnpj, 13, 2);
end;

function Tfuncoes.verFornecedorStringList(xml : string) : TStringList;
var
  tmp : TStringList;
  t1, cnpj, tipo : string;
begin
  tmp := TStringList.Create;
  t1 := NfeVenda.Le_Nodo('emit', xml);

  //'99.999.999/9999-99'
  cnpj := IfThen(funcoes.Contido('<CNPJ>', xml), Le_Nodo('CNPJ', t1), Le_Nodo('CPF', t1));
  if Length(cnpj) = 14      then
    begin
      cnpj := formataCNPJ(cnpj);
      tipo := '1';
    end
  //else if Length(CPF_CNPJ) = 11 then cnpj := formataCNPJ(CPF_CNPJ)
  else
    begin
      cnpj := formataCNPJ(cnpj);
      tipo := '2';
    end;

  tmp.Add(cnpj);                          //0
  tmp.Add(NfeVenda.Le_Nodo('xNome', t1)); //1
  tmp.Add(NfeVenda.Le_Nodo('xFant', t1)); //2
  tmp.Add(NfeVenda.Le_Nodo('xLgr', t1) + ' ' +NfeVenda.Le_Nodo('nro', t1)); //3
  tmp.Add(NfeVenda.Le_Nodo('xBairro', t1));//4
  tmp.Add(NfeVenda.Le_Nodo('cMun', t1)); //5
  tmp.Add(NfeVenda.Le_Nodo('xMun', t1)); //6
  tmp.Add(NfeVenda.Le_Nodo('UF', t1));   //7
  tmp.Add(NfeVenda.Le_Nodo('CEP', t1));  //8
  tmp.Add(NfeVenda.Le_Nodo('cPais', t1));//9
  tmp.Add(NfeVenda.Le_Nodo('xPais', t1));//10
  tmp.Add(NfeVenda.Le_Nodo('fone', t1)); //11
  tmp.Add(NfeVenda.Le_Nodo('IE', t1));   //12
  tmp.Add(NfeVenda.Le_Nodo('CRT', t1));  //13
  tmp.Add(tipo);  //14
  Result := tmp;
end;

function Tfuncoes.importaXMLnaEntrada : boolean;
var
  camArq, erro, nota, total, chave, forn, tmptot : String;
  dial : TOpenDialog;
  xml : TStringList;
  item : integer;
  txt1, t2, t3 : String;
  item1 : Ptr_nota;
  lista : TList;
  ini, fim : integer;
begin
  dial := TOpenDialog.Create(self);
  dial.Filter := 'Arquivo NFE|*.xml';;
  dial.Execute;
  camArq := '';
  camArq := dial.FileName;
  if Trim(camArq) = '' then exit;

  xml := TStringList.Create;

  dm.ACBrNFe.NotasFiscais.LoadFromFile(camArq);
  try
    xml.LoadFromFile(camArq);
  except
    on e:Exception do
      begin
        ShowMessage('Ocorreu um Erro:' + #13 + e.Message + #13 + 'Tente Novamente.');
        exit;
      end;
  end;

  item := 1;
  t2 := xml.GetText;
  lista := TList.Create;
  erro := '';

  chave := NfeVenda.entraXMLeRetornaChave(t2);
  nota :=  nfevenda.Le_Nodo('nNF', t2);
  forn :=  nfevenda.Le_Nodo('emit', t2);
  forn := copy(nfevenda.Le_Nodo('xNome', forn), 1, 40);
  tmptot := nfevenda.Le_Nodo('ICMSTot', t2);

  total := StringReplace(nfevenda.Le_Nodo('vNF', t2), '.', ',', [rfReplaceAll, rfIgnoreCase]);

  while true do
    begin
      txt1 := '';
      txt1 := nfevenda.Le_Nodo('det nItem="' + IntToStr(item) + '"', t2);

      if txt1 = '' then break; //irá vir vazio quando a funcao nao retorna nada

      // inicio da leitura dos itens do xml
      item1 := new(ptr_nota);
      item1.cod := StrToIntDef(StrNum(nfevenda.Le_Nodo('cProd', txt1)), 0);
      item1.nome := nfevenda.Le_Nodo('xProd', txt1);
      item1.quant := StrToCurrDef(StringReplace(nfevenda.Le_Nodo('qCom', txt1), '.', ',', [rfReplaceAll, rfIgnoreCase]), 0);
      item1.preco := StrToCurrDef(StringReplace(nfevenda.Le_Nodo('vUnTrib', txt1), '.', ',', [rfReplaceAll, rfIgnoreCase]), 0);
      item1.preco1 := item1.preco;
      item1.qtd := item1.quant;
      item1.total := StrToCurrDef(StringReplace(nfevenda.Le_Nodo('vProd', txt1), '.', ',', [rfReplaceAll, rfIgnoreCase]), 0);
      item1.codbar := nfevenda.Le_Nodo('cEAN', txt1);
      item1.unid := nfevenda.Le_Nodo('uTrib', txt1);

      dm.IBselect.Close;
      dm.IBselect.SQL.Clear;
      dm.IBselect.SQL.Add('select cod, unid2 from produto where cod = :cod');
      dm.IBselect.ParamByName('cod').AsInteger := item1.cod;
      dm.IBselect.Open;

      if trim(dm.IBselect.FieldByName('unid2').AsString) <> '' then item1.unid := dm.IBselect.FieldByName('unid2').AsString;
      item1.nota := nfevenda.Le_Nodo('nNF', t2);;
      item1.totNota := StrToCurrDef(StringReplace(nfevenda.Le_Nodo('vNF', t2), '.', ',', [rfReplaceAll, rfIgnoreCase]), 0);
      dm.IBselect.Close;

      lista.Add(item1);
      // fim da leitura dos itens do xml

      item := item + 1;
    end;

  form48 := tform48.Create(self);
  form48.caminhoXML := camArq;

  form48.fornec := verFornecedorStringList(t2); // funcao que popula um stringlist com
                                                // os dados do fornecedor  da nota
  form48.Caption := 'Verificação de Itens de Entrada';

  form48.ClientDataSet1.FieldDefs.Clear;

  form48.ClientDataSet1.FieldDefs.Add('CODBAR', ftString, 15);
  form48.ClientDataSet1.FieldDefs.Add('DESCRICAO_NFE', ftString,40);
  form48.ClientDataSet1.FieldDefs.Add('DESCRICAO_ESTOQUE', ftString,40);
  form48.ClientDataSet1.FieldDefs.Add('CODIGO', ftInteger);
  form48.ClientDataSet1.FieldDefs.Add('mu', ftInteger);

  form48.ClientDataSet1.FieldDefs.Add('QUANT', ftCurrency);
  form48.ClientDataSet1.FieldDefs.Add('PRECO', ftCurrency);
  form48.ClientDataSet1.FieldDefs.Add('PRECO_ESTOQUE', ftCurrency);
  form48.ClientDataSet1.FieldDefs.Add('PRECO_ATUAL', ftCurrency);
  form48.ClientDataSet1.FieldDefs.Add('LUCRO', ftCurrency);
  form48.ClientDataSet1.FieldDefs.Add('TOTAL', ftCurrency);

  form48.ClientDataSet1.FieldDefs.Add('UNIDADE', ftString, 8);
  form48.ClientDataSet1.FieldDefs.Add('UNIDADE1', ftString, 8);
  form48.ClientDataSet1.FieldDefs.Add('UNIDADE_V', ftString, 8);
  form48.ClientDataSet1.FieldDefs.Add('ALIQ', ftString, 8);
  form48.ClientDataSet1.FieldDefs.Add('nota', ftString, 20);

  form48.ClientDataSet1.FieldDefs.Add('totnota', ftCurrency);
  form48.ClientDataSet1.FieldDefs.Add('QTD', ftCurrency);
  form48.ClientDataSet1.FieldDefs.Add('PRECO1', ftCurrency);
  form48.ClientDataSet1.FieldDefs.Add('OK', ftString, 1);


  //form48.DataSource1.DataSet := form48.ClientDataSet1;
  form48.DBGrid1.DataSource := form48.DataSource1;
  //form48.DBGrid1.DataSource.DataSet := form48.ClientDataSet1;

  form48.ClientDataSet1.CreateDataSet;
  form48.ClientDataSet1.LogChanges := false;
  form48.ClientDataSet1.FieldByName('PRECO1').Visible := false;
  form48.ClientDataSet1.FieldByName('QTD').Visible := false;
  form48.ClientDataSet1.FieldByName('totnota').Visible := false;
  form48.ClientDataSet1.FieldByName('nota').Visible := false;
  form48.ClientDataSet1.FieldByName('mu').Visible := false;
  form48.ClientDataSet1.FieldByName('unidade1').Visible := false;

  TCurrencyField(form48.ClientDataSet1.FieldByName('PRECO')).currency := false;
  TCurrencyField(form48.ClientDataSet1.FieldByName('QUANT')).currency := false;
  TCurrencyField(form48.ClientDataSet1.FieldByName('TOTAL')).currency := false;
  TCurrencyField(form48.ClientDataSet1.FieldByName('QUANT')).DisplayFormat := '#,###,###0.00';
  TCurrencyField(form48.ClientDataSet1.FieldByName('PRECO')).DisplayFormat := '#,###,###0.00';
  TCurrencyField(form48.ClientDataSet1.FieldByName('TOTAL')).DisplayFormat := '#,###,###0.00';
  //form33.campobusca := 'DESCRICAO';


  for ini := 0 to lista.Count -1 do
     begin
       item1 := lista.Items[ini];
       form48.ClientDataSet1.Open;
       form48.ClientDataSet1.Insert;
       //form48.ClientDataSet1.fieldbyname('CODIGO').AsInteger := item1.cod;
       form48.ClientDataSet1.fieldbyname('DESCRICAO_NFE').AsString := item1.nome;
       form48.ClientDataSet1.fieldbyname('UNIDADE').AsString := item1.unid;
       form48.ClientDataSet1.fieldbyname('UNIDADE1').AsString := item1.unid;
       form48.ClientDataSet1.fieldbyname('CODBAR').AsString := item1.codbar;
       form48.ClientDataSet1.fieldbyname('nota').AsString := item1.nota;
       form48.ClientDataSet1.fieldbyname('QUANT').AsCurrency := item1.quant;
       form48.ClientDataSet1.fieldbyname('PRECO').AsCurrency := item1.preco;
       form48.ClientDataSet1.fieldbyname('TOTAL').AsCurrency := item1.total;
       form48.ClientDataSet1.fieldbyname('TOTnota').AsCurrency := item1.totNota;
       form48.ClientDataSet1.fieldbyname('QTD').AsCurrency := item1.qtd;
       form48.ClientDataSet1.fieldbyname('PRECO1').AsCurrency := item1.preco1;

       dm.IBselect.Close;
       dm.IBselect.SQL.Clear;
       dm.IBselect.SQL.Add('select cod, nome, unid2 from produto where nome = :cod');
       dm.IBselect.ParamByName('cod').AsString := copy(item1.nome, 1, 40);
       dm.IBselect.Open;

       if dm.IBselect.IsEmpty then
         begin
           dm.IBselect.Close;
           dm.IBselect.SQL.Clear;
           dm.IBselect.SQL.Add('select p.cod, p.nome, p.unid2 from produto p left join codbarras c on (c.cod = p.cod) where (p.codbar = '+ QuotedStr( item1.codbar )+') or (c.codbar = '+QuotedStr( item1.codbar )+')');
           //dm.IBselect.ParamByName('cod').AsString := item1.codbar;
           dm.IBselect.Open;
         end;

       if not dm.IBselect.IsEmpty then
         begin
           form48.ClientDataSet1.fieldbyname('ok').AsString := 'X';
           form48.ClientDataSet1.fieldbyname('codigo').AsString := dm.IBselect.fieldbyname('cod').AsString;
           form48.ClientDataSet1.fieldbyname('descricao_estoque').AsString := dm.IBselect.fieldbyname('nome').AsString;


           if dm.IBselect.fieldbyname('unid2').AsString <> '' then
             begin
               form48.ClientDataSet1.fieldbyname('unidade').AsString := dm.IBselect.fieldbyname('unid2').AsString;
{               dm.IBselect.Close;
               dm.IBselect.SQL.Clear;
               dm.IBselect.SQL.Add('select multiplo from unid where nome = :cod');
               dm.IBselect.ParamByName('cod').AsString := form48.ClientDataSet1.fieldbyname('unidade').AsString;
               dm.IBselect.Open;
               form48.ClientDataSet1.fieldbyname('unidade').AsString := dm.IBselect.fieldbyname('unid2').AsString;
 }            end;

         end
       else erro := 'Produto: ' + item1.nome + ' não encontrado;';

       dm.IBselect.Close;
       dm.IBselect.SQL.Clear;
       dm.IBselect.SQL.Add('select * from unid where nome = :cod');
       dm.IBselect.ParamByName('cod').AsString := form48.ClientDataSet1.fieldbyname('unidade').AsString;
       dm.IBselect.Open;

       if not dm.IBselect.IsEmpty then
         begin
           form48.ClientDataSet1.fieldbyname('mu').AsString := dm.IBselect.fieldbyname('multiplo').AsString;
         end
       else
         begin
           erro := 'Unidade: ' + item1.unid + ' não encontrada.';
           form48.ClientDataSet1.fieldbyname('ok').AsString := '';
         end;

       dm.IBselect.Close;
       form48.ClientDataSet1.Post;

     end;

    form48.xml := xml;
    form48.erro := erro;
    form48.chave := chave;
    form48.nota := nota;

    form48.Label5.Caption := 'Nota: ' + nota;
    form48.Label6.Caption := 'Total R$: ' + FormatCurr('#,###,###0.00', form48.ClientDataSet1.fieldbyname('TOTnota').AsCurrency);
    form48.Label7.Caption := 'Fornecedor: ' + forn;
    form48.ShowModal;
    xml.Free;
    form48.ClientDataSet1.Free;
    form48.Free;
    lista.Free;
end;

function Tfuncoes.importaXMLnaEntrada1 : boolean;
var
  camArq, erro, nota, total, chave, forn, tmptot : String;
  dial : TOpenDialog;
  xml : TStringList;
  item : integer;
  txt1, t2, t3, cnpjFOR, sim, axx : String;
  item1 : Ptr_nota;
  lista : TList;
  ini, fim, cont : integer;
  dataEmissao : TDate;
begin
  {dial := TOpenDialog.Create(self);
  dial.Filter := 'Arquivo NFE|*.xml';;
  dial.Execute;
  camArq := '';
  camArq := dial.FileName;
  if Trim(camArq) = '' then exit;
  }

  camArq := caminhoEXE_com_barra_no_final + 'ENTRADAXML\';
  criaPasta(camArq);
  funcoes.CriarAtalho(camArq, '', 'C:\', 'Entrada de NFe ControlW', 'c:\');

  funcoes.retornobusca := '';
  while true do
    begin
      if buscaXMl(camArq) = false then exit;
      if funcoes.retornobusca = '*' then exit;
      if funcoes.retornobusca <> '' then break;
    end;

  camArq := camArq + funcoes.retornobusca;
  try
    xml := TStringList.Create;
    xml.LoadFromFile(camArq);
  except
    on e:Exception do
      begin
        ShowMessage('Ocorreu um Erro:' + #13 + e.Message + #13 + 'Tente Novamente.');
        exit;
      end;
  end;

  item := 1;
  t2 := xml.GetText;
  //xml.Free;

  lista := TList.Create;
  erro := '';

  chave  := NfeVenda.entraXMLeRetornaChave(t2);
  nota   :=  Le_Nodo('nNF', t2);
  forn   :=  Le_Nodo('emit', t2);

  axx := Le_Nodo('dEmi', t2);
  if axx = '' then axx := LeftStr(Le_Nodo('dhEmi', t2), 10);
  axx := funcoes.dataInglesToBrasil(axx);

  dataEmissao := StrToDateTime(axx);

  cnpjFOR := IfThen(funcoes.Contido('CNPJ', forn), Le_Nodo('CNPJ', forn), Le_Nodo('CPF', forn));
  forn   := copy(nfevenda.Le_Nodo('xNome', forn), 1, 40);

  cnpjFOR := ACHA_CODFORNEC(cnpjFOR, '');
 { if FileExists(caminhoEXE_com_barra_no_final + cnpjFOR + '-' + nota + '.xml') then
    begin
      form48 := tform48.Create(self);
      form48.caminhoXML := camArq;
      form48.ClientDataSet1.LoadFromFile(caminhoEXE_com_barra_no_final + cnpjFOR + '-' + nota + '.xml');
      form48.ClientDataSet1.Open;
      form48.fornec := verFornecedorStringList(t2);
      form48.ShowModal;
      form48.Free;
      exit;
    end;
 } tmptot := nfevenda.Le_Nodo('ICMSTot', t2);

  total := StringReplace(nfevenda.Le_Nodo('vNF', t2), '.', ',', [rfReplaceAll, rfIgnoreCase]);


  funcoes.Mensagem(Application.Title,'Aguarde, Lendo XML...',15,'Arial',false,0, clBlack);
  Application.ProcessMessages;

  cont := 0;
  try
  while true do
    begin
      Application.ProcessMessages;
      txt1 := '';
      txt1 := nfevenda.Le_Nodo('det nItem="' + IntToStr(item) + '"', t2);

      if cont > 200 then break;
      if txt1 = '' then cont := cont + 1 //irá vir vazio quando a funcao nao retorna nada
        else cont := 0;

      if txt1 <> '' then
        begin
          cont := 0;
          // inicio da leitura dos itens do xml
          item1        := new(ptr_nota);
          item1.numProd := item;
          item1.cod     := StrToIntDef(StrNum(nfevenda.Le_Nodo('cProd', txt1)), 0);
          item1.nome    := nfevenda.Le_Nodo('xProd', txt1);
          item1.quant   := StrToCurrDef(StringReplace(nfevenda.Le_Nodo('qCom', txt1), '.', ',', [rfReplaceAll, rfIgnoreCase]), 0);
          item1.preco   := StrToCurrDef(StringReplace(nfevenda.Le_Nodo('vUnTrib', txt1), '.', ',', [rfReplaceAll, rfIgnoreCase]), 0);
          item1.preco1  := StrToCurrDef(StringReplace(nfevenda.Le_Nodo('vDesc', txt1), '.', ',', [rfReplaceAll, rfIgnoreCase]), 0);
          item1.qtd     := item1.quant;
          item1.total   := StrToCurrDef(StringReplace(nfevenda.Le_Nodo('vProd', txt1), '.', ',', [rfReplaceAll, rfIgnoreCase]), 0);
          //item1.total  := item1.total - item1.preco1;
          item1.codbar  := nfevenda.Le_Nodo('cEAN', txt1);
          item1.unid    := nfevenda.Le_Nodo('uTrib', txt1);
          item1.NCM     := nfevenda.Le_Nodo('NCM', txt1);

          dm.IBselect.Close;
          dm.IBselect.SQL.Clear;
          dm.IBselect.SQL.Add('select cod, unid2 from produto where cod = :cod');
          dm.IBselect.ParamByName('cod').AsInteger := item1.cod;
          dm.IBselect.Open;

          if trim(dm.IBselect.FieldByName('unid2').AsString) <> '' then item1.unid := dm.IBselect.FieldByName('unid2').AsString;
          item1.nota := nfevenda.Le_Nodo('nNF', t2);;
          item1.totNota := StrToCurrDef(StringReplace(nfevenda.Le_Nodo('vNF', t2), '.', ',', [rfReplaceAll, rfIgnoreCase]), 0);
          dm.IBselect.Close;

          lista.Add(item1);
        end;
      // fim da leitura dos itens do xml

      item := item + 1;
    end;

    pergunta1.Close;
  except
    pergunta1.Close;
  end;

  form48 := tform48.Create(self);
  form48.caminhoXML := camArq;

  form48.fornec := verFornecedorStringList(t2); // funcao que popula um stringlist com
                                                // os dados do fornecedor  da nota
  Form48.insereFornec;
  //aqui inseriu o fornecedor no banco de dados

  form48.Caption := 'Verificação de Itens de Entrada';

  form48.ClientDataSet1.FieldDefs.Clear;

  form48.ClientDataSet1.FieldDefs.Add('CONT', ftInteger);
  form48.ClientDataSet1.FieldDefs.Add('CODIGO', ftInteger);
  form48.ClientDataSet1.FieldDefs.Add('DESCRICAO_FORNECEDOR', ftString,40);
  form48.ClientDataSet1.FieldDefs.Add('DESCRICAO_ATUAL', ftString,40);
  form48.ClientDataSet1.FieldDefs.Add('PRECO_NFE', ftCurrency);
  form48.ClientDataSet1.FieldDefs.Add('LUCRO', ftCurrency);
  form48.ClientDataSet1.FieldDefs.Add('PRECO_NOVO', ftCurrency);
  form48.ClientDataSet1.FieldDefs.Add('PRECO_COMPRA', ftCurrency);
  form48.ClientDataSet1.FieldDefs.Add('PRECO_ATUAL', ftCurrency);
  form48.ClientDataSet1.FieldDefs.Add('QUANTIDADE_NFE', ftCurrency);
  form48.ClientDataSet1.FieldDefs.Add('QUANTIDADE_ENT', ftCurrency);
  form48.ClientDataSet1.FieldDefs.Add('UNID_NFE', ftString, 8);
  form48.ClientDataSet1.FieldDefs.Add('UNID_ENTRADA', ftString, 8);
  form48.ClientDataSet1.FieldDefs.Add('UNID_VENDA', ftString, 8);
  form48.ClientDataSet1.FieldDefs.Add('ALIQ', ftString, 8);
  form48.ClientDataSet1.FieldDefs.Add('CODBAR', ftString, 15);
  form48.ClientDataSet1.FieldDefs.Add('CODBAR_ATUAL', ftString, 15);
  form48.ClientDataSet1.FieldDefs.Add('REFORI', ftString, 15);
  form48.ClientDataSet1.FieldDefs.Add('REF_NFE', ftString, 20);
  form48.ClientDataSet1.FieldDefs.Add('NCM', ftString, 20);
  form48.ClientDataSet1.FieldDefs.Add('mu', ftInteger);
  form48.ClientDataSet1.FieldDefs.Add('TOTAL', ftCurrency);
  form48.ClientDataSet1.FieldDefs.Add('nota', ftString, 20);
  form48.ClientDataSet1.FieldDefs.Add('totnota', ftCurrency);
  form48.ClientDataSet1.FieldDefs.Add('OK', ftString, 1);
  form48.ClientDataSet1.FieldDefs.Add('data', ftDate);

  form48.DBGrid1.DataSource := form48.DataSource1;

  form48.ClientDataSet1.CreateDataSet;
  FormataCampos(tibquery(form48.ClientDataSet1), 3, '', 3);

  TCurrencyField(form48.ClientDataSet1.FieldByName('PRECO_NFE')).DisplayFormat := '###,##0.000';
  TField(form48.ClientDataSet1.FieldByName('CONT')).DisplayLabel                 := 'Num. Produto';
  TField(form48.ClientDataSet1.FieldByName('CODIGO')).DisplayLabel               := 'Código';
  TField(form48.ClientDataSet1.FieldByName('DESCRICAO_FORNECEDOR')).DisplayLabel := 'Descrição do Fornecedor(F)';
  TField(form48.ClientDataSet1.FieldByName('DESCRICAO_ATUAL')).DisplayLabel      := 'Descrição do Produto Atual';
  TField(form48.ClientDataSet1.FieldByName('PRECO_NFE')).DisplayLabel            := 'Preço(F)';
  TField(form48.ClientDataSet1.FieldByName('LUCRO')).DisplayLabel                := 'Lucro';
  TField(form48.ClientDataSet1.FieldByName('PRECO_NOVO')).DisplayLabel           := 'Preço Novo';
  TField(form48.ClientDataSet1.FieldByName('PRECO_COMPRA')).DisplayLabel         := 'Preço Compra';
  TField(form48.ClientDataSet1.FieldByName('PRECO_ATUAL')).DisplayLabel          := 'Preço Atual';
  TField(form48.ClientDataSet1.FieldByName('QUANTIDADE_NFE')).DisplayLabel       := 'Quantidade';
  TField(form48.ClientDataSet1.FieldByName('UNID_NFE')).DisplayLabel             := 'Unid(F)';
  TField(form48.ClientDataSet1.FieldByName('UNID_ENTRADA')).DisplayLabel         := 'Unid. Entrada';
  TField(form48.ClientDataSet1.FieldByName('UNID_VENDA')).DisplayLabel           := 'Unid. Venda';
  TField(form48.ClientDataSet1.FieldByName('ALIQ')).DisplayLabel                 := 'Aliq.';
  TField(form48.ClientDataSet1.FieldByName('CODBAR')).DisplayLabel               := 'Cod. barras(F)';
  TField(form48.ClientDataSet1.FieldByName('CODBAR_ATUAL')).DisplayLabel         := 'Cód. Barras Atual';
  TField(form48.ClientDataSet1.FieldByName('REFORI')).DisplayLabel               := 'Ref. Original';
  TField(form48.ClientDataSet1.FieldByName('REF_NFE')).DisplayLabel              := 'Ref. Fornecedor(F)';
  TField(form48.ClientDataSet1.FieldByName('NCM')).DisplayLabel                  := 'NCM';

  fim := lista.Count -1;
  funcoes.informacao(0, fim, 'Agurde, Lendo XML...', true, false, 5);
  for ini := 0 to lista.Count -1 do
     begin
       funcoes.informacao(ini, fim, 'Agurde, Lendo XML...', false, false, 5);
       item1 := lista.Items[ini];
       form48.ClientDataSet1.Insert;
       form48.ClientDataSet1.fieldbyname('CONT').AsInteger         := item1.numProd;
       form48.ClientDataSet1.fieldbyname('data').AsDateTime        := dataEmissao;
       form48.ClientDataSet1.fieldbyname('DESCRICAO_FORNECEDOR').AsString := item1.nome;
       form48.ClientDataSet1.fieldbyname('UNID_NFE').AsString      := item1.unid;
       form48.ClientDataSet1.fieldbyname('UNID_ENTRADA').AsString  := '';
       form48.ClientDataSet1.fieldbyname('UNID_VENDA').AsString    := '';
       form48.ClientDataSet1.fieldbyname('CODBAR').AsString        := item1.codbar;
       form48.ClientDataSet1.fieldbyname('nota').AsString          := item1.nota;
       form48.ClientDataSet1.fieldbyname('QUANTIDADE_NFE').AsCurrency       := item1.quant;
       form48.ClientDataSet1.fieldbyname('PRECO_NFE').AsCurrency   := item1.preco;
       form48.ClientDataSet1.fieldbyname('PRECO_COMPRA').AsCurrency:= item1.preco;
       form48.ClientDataSet1.fieldbyname('TOTAL').AsCurrency       := item1.total;
       form48.ClientDataSet1.fieldbyname('TOTnota').AsCurrency     := item1.totNota;
       form48.ClientDataSet1.fieldbyname('NCM').AsString           := item1.NCM;
       //form48.ClientDataSet1.FieldByName('REF_NFE').AsString       := IntToStr(item1.cod) + '|' + item1.codbar;
       form48.ClientDataSet1.FieldByName('REF_NFE').AsString       := IntToStr(item1.cod) + '|' + Form48.fornecedor;

       dm.IBselect.Close;
       dm.IBselect.SQL.Clear;
       dm.IBselect.SQL.Add('select cod, nome, unid2, aliquota, unid, p_venda, codbar, refori from produto where REFNFE = :cod');
       dm.IBselect.ParamByName('cod').AsString := copy(form48.ClientDataSet1.FieldByName('REF_NFE').AsString, 1, 25);
       dm.IBselect.Open;

       axx := '0';

       if dm.IBselect.IsEmpty then
         begin
           if item1.codbar <> '' then
             begin
           dm.IBselect.Close;
           dm.IBselect.SQL.Clear;
           dm.IBselect.SQL.Add('select p.cod, p.nome, p.unid2, p.p_venda, p.codbar, p.aliquota, p.refori, ' +
           ' p.unid from produto p left join codbarras c on (c.cod = p.cod) where (p.codbar = '  + QuotedStr( copy(item1.codbar, 1, 15) )+') or (c.codbar = '+QuotedStr( copy(item1.codbar, 1, 15) )+')');
           dm.IBselect.Open;

           if not dm.IBselect.IsEmpty then
             begin
               axx := '1';
             end;
            end
            else axx := '0'; 
         end
       else axx := '1';

       if axx = '1' then //se achou o produto
         begin
           form48.ClientDataSet1.fieldbyname('codigo').AsString          := dm.IBselect.fieldbyname('cod').AsString;
           form48.ClientDataSet1.fieldbyname('CODBAR_ATUAL').AsString    := dm.IBselect.fieldbyname('codbar').AsString;
           form48.ClientDataSet1.fieldbyname('PRECO_ATUAL').AsCurrency   := dm.IBselect.fieldbyname('p_venda').AsCurrency;
           form48.ClientDataSet1.fieldbyname('ALIQ').AsString            := dm.IBselect.fieldbyname('aliquota').AsString;
           form48.ClientDataSet1.fieldbyname('DESCRICAO_ATUAL').AsString := copy(dm.IBselect.fieldbyname('nome').AsString, 1, 40);
           form48.ClientDataSet1.fieldbyname('REFORI').AsString          := dm.IBselect.fieldbyname('REFORI').AsString;

           if dm.IBselect.fieldbyname('unid2').AsString <> '' then
             begin
               form48.ClientDataSet1.fieldbyname('UNID_ENTRADA').AsString     := dm.IBselect.fieldbyname('unid2').AsString;
               form48.ClientDataSet1.fieldbyname('QUANTIDADE_ENT').AsCurrency := StrToCurr(strnum1(dm.IBselect.fieldbyname('unid2').AsString));
             end;

           form48.ClientDataSet1.fieldbyname('UNID_VENDA').AsString       := dm.IBselect.fieldbyname('unid').AsString;  
         end;

       dm.IBselect.Close;
       form48.ClientDataSet1.Post;

     end;

    funcoes.informacao(0, fim, 'Agurde, Lendo XML...', false, true, 5); 

    sim := funcoes.dialogo('numero',0,'',2,false,'X',Application.Title,'Qual o Lucro %?','100,00');
    if sim = '*' then exit;

    form48.ClientDataSet1.First;

    while not form48.ClientDataSet1.Eof do
      begin
        form48.ClientDataSet1.Edit;
        form48.ClientDataSet1.FieldByName('LUCRO').AsCurrency      := StrToCurrDef(sim, 0);
        form48.ClientDataSet1.FieldByName('PRECO_NOVO').AsCurrency := Arredonda(form48.ClientDataSet1.FieldByName('PRECO_NFE').AsCurrency + (form48.ClientDataSet1.FieldByName('PRECO_NFE').AsCurrency * StrToCurrDef(sim, 0) / 100), 2);
        form48.ClientDataSet1.Post;

        form48.ClientDataSet1.Next;
      end;

    form48.xml   := xml;
    form48.erro  := erro;
    form48.chave := chave;
    form48.nota  := nota;

    form48.Label5.Caption := 'Nota: ' + nota;
    form48.Label6.Caption := 'Total R$: ' + FormatCurr('#,###,###0.00', form48.ClientDataSet1.fieldbyname('TOTnota').AsCurrency);
    form48.Label7.Caption := 'Fornecedor: ' + form48.fornecedor + ' - ' + forn;

    if FileExists(caminhoEXE_com_barra_no_final + cnpjFOR + '-' + nota + '.xml') then
    begin
      form48.ClientDataSet1.Close;
      form48.ClientDataSet1.LoadFromFile(caminhoEXE_com_barra_no_final + cnpjFOR + '-' + nota + '.xml');
    end;

    form48.Width := screen.Width - trunc(screen.Width * 0.1);
    form48.Height := screen.Height - trunc(screen.Height * 0.15);
    form48.DBGrid1.Height := form48.Height - form48.Panel1.Height - 40;
    form48.ShowModal;
    xml.Free;
    form48.ClientDataSet1.Free;
    form48.Free;
    lista.Free;
end;

function Tfuncoes.receberSincronizacaoExtoque1(CaminhoArq : String) : boolean;
var
  //Input: TIBInputRawFile;
  item : Ptr_sinc;
  i, tot, recno : integer;
  linha, sim : String;
  F : TextFile;
  arq, arquivo : TStringList;
  lista : TList;
begin
  Result := false;
  if not FileExists(CaminhoArq) then
    begin
      ShowMessage('Arquivo ' + CaminhoArq + ' Não Encontrado.');
      exit;
    end;

  {try
    AssignFile(F, CaminhoArq);
  except
    ShowMessage('Ocorreu um Erro. Verifique se a Unidade está funcionando corretamente');
    exit;
  end;}

  //Reset(F);
  arquivo := TStringList.Create;

  arquivo.LoadFromFile(CaminhoArq);

  arq     := TStringList.Create;
  lista := TList.Create;

  // 0 - cod
  // 1 - codbar
  // 2 - unid
  // 3 - nome
  // 4 - p_compra
  // 5 - p_venda
  // 6 - aliquota
  // 7 - classif   - NCM
  // 8 - is_pis
  // 9 - cod_ispis
  //10 - grupo
  //11 - p_venda1

  //tot := filesize(F);
  tot := arquivo.Count -1;
  recno := 0;
  funcoes.informacao(0, tot, 'Aguarde, Sincronizando Estoque...', true, false, 5);

  //while not Eof(F) do
  for recno := 0 to arquivo.Count -1 do
    begin
      //recno := recno + 1;
      funcoes.informacao(recno, tot, 'Aguarde, Sincronizando Estoque...', false, false, 5);

      arq.Clear;
      linha := arquivo[recno];

      if Contido('|FORNECEDOR|', LINHA) THEN BREAK;

      le_campos(arq, linha, '|', false);

      dm.IBselect.Close;
      dm.IBselect.SQL.Clear;
      dm.IBselect.SQL.Add('select cod, nome, p_venda from produto where cod = :cod');
      dm.IBselect.ParamByName('cod').AsString := arq.Values['0'];
      dm.IBselect.Open;

      if not dm.IBselect.IsEmpty then
        begin
          if dm.IBselect.FieldByName('p_venda').AsCurrency <> StrToCurrDef(arq.Values['5'], 0) then
            begin
              item                      := new(Ptr_sinc);
              item.cod                  := dm.IBselect.FieldByName('cod').AsInteger;
              item.nome                 := dm.IBselect.FieldByName('nome').AsString;
              item.p_vendaEstoque       := dm.IBselect.FieldByName('p_venda').AsCurrency;
              item.p_vendaSincronizacao := StrToCurrDef(arq.Values['5'], 0);

              lista.Add(item);
            end;
        end;

      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Text := ('update or insert into produto(cod, codbar, unid, nome, p_compra, p_venda, aliquota, classif, is_pis, cod_ispis, grupo, p_venda1) ' +
      'values(:cod, :codbar, :unid, :nome, :p_compra, :p_venda, :aliquota, :classif, :is_pis, :cod_ispis, :grupo, :p_venda1) matching(cod)');
      dm.IBQuery1.ParamByName('cod').AsString        :=  arq.Values['0'];
      dm.IBQuery1.ParamByName('codbar').AsString     :=  arq.Values['1'];
      dm.IBQuery1.ParamByName('unid').AsString       :=  arq.Values['2'];
      dm.IBQuery1.ParamByName('nome').AsString       :=  arq.Values['3'];
      dm.IBQuery1.ParamByName('p_compra').AsCurrency :=  StrToCurrDef(arq.Values['4'], 0);
      dm.IBQuery1.ParamByName('p_venda').AsCurrency  :=  StrToCurrDef(arq.Values['5'], 0);
      dm.IBQuery1.ParamByName('aliquota').AsString   :=  arq.Values['6'];
      dm.IBQuery1.ParamByName('classif').AsString    :=  arq.Values['7'];
      dm.IBQuery1.ParamByName('is_pis').AsString     :=  trim(arq.Values['8']);
      dm.IBQuery1.ParamByName('cod_ispis').AsString  :=  StrNum(arq.Values['9']);
      dm.IBQuery1.ParamByName('grupo').AsString      :=  StrNum(arq.Values['10']);
      dm.IBQuery1.ParamByName('p_venda1').AsCurrency :=  StrToCurrDef(arq.Values['11'], 0);
      try
        dm.IBQuery1.ExecSQL;
      except
        on e:Exception do
          begin
            ShowMessage('ERRO: ' + linha + #13 + e.Message);
          end;
      end;

    end;



  for recno := recno to arquivo.Count -1 do begin
    funcoes.informacao(recno, tot, 'Aguarde, Sincronizando Estoque...', false, false, 5);
    linha := arquivo[recno];
    le_campos(arq, linha, '|', false);

    recebeFornecedores(arq);
  end;

  try
    if dm.IBQuery1.Transaction.InTransaction then dm.IBQuery1.Transaction.Commit;
  except
    ShowMessage('Ocorreu um erro. Tente Novamente');
  end;

  restartGeneratorPelaTabelaMax('produto', 'produto');
  restartGeneratorPelaTabelaMax('fornecedor', 'fornecedor');

  funcoes.informacao(recno, tot, 'Aguarde, Sincronizando Estoque...', false, true, 5);

  if lista.Count > 0 then //encontrou com precos diferentes entao gera relatório
    begin
      sim := funcoes.dialogo('generico',30,'SN', 30, false,'S',Application.Title,'Imprimir relatório de Diferenças em Preços?','S');
      if (sim = '*') then
        begin

          exit;
        end;
      if sim = 'S' then
        begin
          form19.RichEdit1.Clear;
          addRelatorioForm19(funcoes.RelatorioCabecalho(form22.Pgerais.Values['empresa'],'Relatório de Mudanca de Precos de Estoques', 80) );
          addRelatorioForm19(CompletaOuRepete('|','COD|', ' ', 6)+CompletaOuRepete('DESCRICAO','|', ' ', 34) + CompletaOuRepete('','PRECO ATUAL|', ' ', 14) + CompletaOuRepete('','PRECO NOVO|', ' ', 14)  + CompletaOuRepete('','DIFERENCA|', ' ', 12) + CRLF);
          addRelatorioForm19(CompletaOuRepete('','', '-', 80) + CRLF );

          for i := 0 to lista.Count -1 do
            begin
              item := lista[i];
              addRelatorioForm19(funcoes.CompletaOuRepete('', IntToStr(item.cod), ' ', 6) + ' '+funcoes.CompletaOuRepete(LeftStr(item.nome, 33), '', ' ', 33) + funcoes.CompletaOuRepete('', FormatCurr('##,###,###0.000', item.p_vendaEstoque), ' ', 14) + funcoes.CompletaOuRepete('', FormatCurr('##,###,###0.000', item.p_vendaSincronizacao), ' ', 14) + funcoes.CompletaOuRepete('', FormatCurr('0.00', item.p_vendaEstoque - item.p_vendaSincronizacao), ' ', 12) + #13 + #10);
            end;

          addRelatorioForm19(CompletaOuRepete('','', '-', 80) + CRLF );  
          form19.ShowModal;
        end;
    end;


  dm.IBselect.Close;
  dm.IBselect.SQL.Text := 'select max(cod) as venda from produto';
  dm.IBselect.Open;

  i := dm.IBselect.fieldbyname('venda').AsInteger;

  if StrToInt(Incrementa_Generator('produto', 0)) < i then
    begin
      reStartGenerator('produto', i);
    end;

  arquivo.Free;  
  dm.IBselect.Close;  
  arq.Free;
  lista.Free;  
  Result := true;
end;

function Tfuncoes.BrowseForFolder(const browseTitle: String;  const initialFolder: String ='';  mayCreateNewFolder: Boolean = False): String;
var
  browse_info: TBrowseInfo;
  folder: array[0..MAX_PATH] of char;
  find_context: PItemIDList;
const
  BIF_NEWDIALOGSTYLE=$40;
  BIF_NONEWFOLDERBUTTON=$200;
begin
  FillChar(browse_info,SizeOf(browse_info),#0);
  lg_StartFolder := initialFolder;
  browse_info.pszDisplayName := @folder[0];
  browse_info.lpszTitle := PChar(browseTitle);
  browse_info.ulFlags := BIF_RETURNONLYFSDIRS or BIF_NEWDIALOGSTYLE;
  if not mayCreateNewFolder then
    browse_info.ulFlags := browse_info.ulFlags or BIF_NONEWFOLDERBUTTON;

  browse_info.hwndOwner := Application.Handle;
 // if initialFolder <> '' then
 //   browse_info.lpfn := BrowseForFolderCallBack;
  find_context := SHBrowseForFolder(browse_info);
  if Assigned(find_context) then
  begin
    if SHGetPathFromIDList(find_context,folder) then
      result := folder
    else
      result := '';
    GlobalFreePtr(find_context);
  end
  else
    result := '';
end;


function Tfuncoes.BrowseForFolderCallBack(Wnd: HWND; uMsg: UINT; lParam, lpData: LPARAM): Integer stdcall;
var
  lg_StartFolder : String;
begin
   lg_StartFolder := ''; 
  if uMsg = BFFM_INITIALIZED then
    SendMessage(Wnd,BFFM_SETSELECTION, 1, Integer(@lg_StartFolder[1]));
  result := 0;
end;



function Tfuncoes.SincronizarExtoque1(CaminhoArq : String) : boolean;
var
  // Output: TIBOutputRawFile;
   unid, linha, simFornece : string;
   F : TextFile;
   tot : integer;
begin
  simFornece := funcoes.dialogo('generico',0,'SN',20,false,'S',Application.Title,'Exportar Fornecedores ?','N');

  AssignFile(F, (caminhoEXE_com_barra_no_final + 'TEXTO.dat'));
  Rewrite(F);
  dm.IBselect.Close;
  dm.IBselect.SQL.Clear;
  dm.IBselect.SQL.Add('select cod, grupo, codbar, unid, nome, p_compra, p_venda, p_venda1, aliquota, classif, is_pis, cod_ispis from produto');
  dm.IBselect.Open;
  dm.IBselect.FetchAll;
  tot := dm.IBselect.RecordCount;

  try
  // 0 - cod
  // 1 - codbar
  // 2 - unid
  // 3 - nome
  // 4 - p_compra
  // 5 - p_venda
  // 6 - aliquota
  // 7 - classif   - NCM
  // 8 - is_pis
  // 9 - cod_ispis
  //10 - grupo
  //11 - p_venda1
  funcoes.informacao(0, tot, 'Gerando Sincronização...', true, false, 5);

  while not dm.IBselect.Eof do
    begin
      funcoes.informacao(dm.IBselect.RecNo, tot, 'Gerando Sincronização...', false, false, 5);
      linha := '|'+ dm.IBselect.fieldbyname('cod').AsString + '|'+
      dm.IBselect.fieldbyname('codbar').AsString    + '|' +dm.IBselect.fieldbyname('unid').AsString      + '|' +
      dm.IBselect.fieldbyname('nome').AsString      + '|' + dm.IBselect.fieldbyname('p_compra').AsString + '|' +
      dm.IBselect.fieldbyname('p_venda').AsString   + '|' + dm.IBselect.fieldbyname('aliquota').AsString + '|' +
      dm.IBselect.fieldbyname('classif').AsString   + '|' + trim(dm.IBselect.fieldbyname('is_pis').AsString) + '|' +
      trim(dm.IBselect.fieldbyname('cod_ispis').AsString) + '|' + dm.IBselect.fieldbyname('grupo').AsString + '|' +
      dm.IBselect.fieldbyname('p_venda1').AsString + '|';

      //Writeln(F, funcoes.Criptografar(linha));
      Writeln(F, linha);
      dm.IBselect.Next;
    end;
    funcoes.informacao(0, tot, 'Gerando Sincronização...', false, true, 5);
  except
    funcoes.informacao(0, tot, 'Gerando Sincronização...', false, true, 5);
  end;

  if simFornece = 'S' then exportaFornecedores(F);

  //exportaTabela('produto', 'cod, grupo, codbar, unid, nome, p_compra, p_venda, aliquota, classif, is_pis, cod_ispis', F, dm.IBselect);
  //exportaTabela('fornecedor', 'cod,nome, endereco, cep, fone, fax, cidade,estado,contato, obs, bairro, cnpj, ies, cod_mun, suframa, tipo', F, dm.IBselect);

  CloseFile(F);

  try
    DeleteFile(pansichar(CaminhoArq));
    CopyFile(pansichar(caminhoEXE_com_barra_no_final + 'TEXTO.dat'), pansichar(CaminhoArq), true);
    DeleteFile(pansichar(caminhoEXE_com_barra_no_final + 'TEXTO.dat'));
  except
    ShowMessage('Ocorreu um Erro, Verifique:' + #13 + '1 - Se a Unidade foi informada corretamente' + #13 + '2 - Se o pendrive está conectado');
    exit;
  end;

  Result := true;
end;

function Tfuncoes.geraRelFechamento(const cod12 : integer; vendedor : String) : String;
var
  lista : TList;
  item, temp : Ptr_Item;
  i, ret : integer;
  total : currency;
begin
  Result := '';
  if vendedor <> '' then vendedor := ' and (vendedor = '+ vendedor +')';

  form19.RichEdit1.Clear;
  dm.IBselect.Close;
  dm.IBselect.SQL.Clear;
  dm.IBselect.SQL.Add('select codhis, total, vendedor, desconto from venda where  (fechamento = :fech)' + vendedor + ' order by vendedor, codhis');
  dm.IBselect.ParamByName('fech').AsInteger := cod12;
  dm.IBselect.Open;

  lista := TList.Create;
  total := 0;

  while not dm.IBselect.Eof do
    begin
      ret := -1; //inicia com -1 para
      for i := 0 to lista.Count -1 do
        begin
          item := lista[i]; //compara forma de pagamento e vendedor
          if (item.codFormaPagamento = dm.IBselect.FieldByName('codhis').AsInteger) and (item.codVendedor = dm.IBselect.FieldByName('vendedor').AsInteger) then
            begin
              ret := i;
              Break;
            end;
        end;

      if ret = -1 then //ret está -1 porque não foi encontrado o indice deste na lista
        begin
          item := new(ptr_item);
          item.codFormaPagamento := dm.IBselect.FieldByName('codhis').AsInteger;
          item.codVendedor := dm.IBselect.FieldByName('vendedor').AsInteger;
          item.total := dm.IBselect.FieldByName('total').AsCurrency;
          lista.Add(item);
        end
      else
        begin//veio pra ca porque achou o vendedor, forma de pagamento na lista
          item := lista[ret];
          item.total := item.total + dm.IBselect.FieldByName('total').AsCurrency;
          lista[ret] := item;
        end;

      dm.IBselect.Next;
    end;

  addrelatorioform19(#15 + CompletaOuRepete('',  '', '-', 40) + #13 + #10);
  addrelatorioform19(CompletaOuRepete(centraliza(form22.Pgerais.Values['empresa'], ' ', 40),  '', ' ', 40) + #13 + #10);
  addrelatorioform19(CompletaOuRepete(centraliza('FECHAMENTO DE VENDAS: ' + IntToStr(COD12) , ' ', 40),  '', ' ', 40) + #13 + #10);
//  addrelatorioform19(CompletaOuRepete('Data: ' + FormatDateTime('dd/mm/yy', form22.datamov), 'Hora: ' + FormatDateTime('hh:mm:ss', now), ' ', 40) + #13 + #10);
  addrelatorioform19(CompletaOuRepete('',  '', '-', 40) + #13 + #10);
  ret := -1;
  for i := 0 to lista.Count - 1 do
    begin
      item := lista[i];
      if ret <> item.codVendedor then
        begin
          if i <> 0 then addrelatorioform19(CompletaOuRepete('',  '', '-', 40) + #13 + #10);
          form19.richedit1.SelAttributes.Style := [fsBold];
          addrelatorioform19(centraliza('Vendedor: ' + IntToStr(item.codVendedor) + ' - ' + BuscaNomeBD(dm.ibquery1, 'nome', 'vendedor', 'where cod =' + IntToStr(item.codVendedor)) , ' ', 40) + #13 + #10);
          addrelatorioform19(centraliza('DATA: ' + FormatDateTime('dd/mm/yy', Form22.datamov) + '   ' + 'HORA: ' +FormatDateTime('hh:mm:ss', now) , ' ', 40) + #13 + #10);
          addrelatorioform19(CompletaOuRepete('',  '', '-', 40) + #13 + #10);
          form19.Richedit1.SelAttributes.Style := [];
          ret := item.codVendedor;
        end;
       addrelatorioform19(CompletaOuRepete(IntToStr(item.codFormaPagamento) + ' - ' + BuscaNomeBD(dm.ibquery1, 'nome', 'formpagto', 'where cod =' + IntToStr(item.codFormaPagamento)), '', ' ', 20) + ' - ' + CompletaOuRepete('', FormatCurr('#,###,###0.00', item.total), ' ', 13) + #13 + #10);
       total := total + item.total;
    end;
    addrelatorioform19(CompletaOuRepete('',  '', '-', 40) + #13 + #10);
    addrelatorioform19(CompletaOuRepete('Total:...........' + FormatCurr('#,###,###0.00', total),  '', ' ', 40) + #13 + #10);
    addrelatorioform19(CompletaOuRepete('',  '', '-', 40) + #13 + #10);
end;

function Tfuncoes.VerSeExisteGeneratorPeloNome(Const nome : String) : boolean;
begin
  Result := false;
  dm.IBselect.Close;
  dm.IBselect.SQL.Clear;
  dm.IBselect.SQL.Add('select rdb$generator_name from rdb$generators where rdb$generator_name = ' + QuotedStr(nome));
  dm.IBselect.Open;

  if not dm.IBselect.IsEmpty then Result := true;

  dm.IBselect.Close;
end;

function Tfuncoes.verPermissaoDiaria(const ret : String) : String;
begin
  Result := '0';
  dm.IBselect.Close;
  dm.IBselect.SQL.Clear;
  dm.IBselect.SQL.Add('select * from cpd where dd = :dd');
  dm.IBselect.ParamByName('dd').AsString := funcoes.Criptografar(FormatDateTime('dd/mm/yy', Form22.datamov));
  dm.IBselect.Open;

  if ret = '' then
    begin
      if dm.IBselect.IsEmpty then Result := '2'
        else Result := dm.IBselect.fieldbyname('sit').AsString;
      dm.IBselect.Close;
      exit;
    end;

  if dm.IBselect.IsEmpty then
    begin
      if (ret = '01') then
        begin
          dm.IBQuery1.Close;
          dm.IBQuery1.SQL.Clear;
          dm.IBQuery1.SQL.Add('update or insert into cpd(dd, sit) values(:dd, :sit) matching (dd)');
          dm.IBQuery1.ParamByName('dd').AsString := funcoes.Criptografar(FormatDateTime('dd/mm/yy', Form22.datamov));
          dm.IBQuery1.ParamByName('sit').AsInteger := 0;
          dm.IBQuery1.ExecSQL;

        end
      else if (ret = '1') then
        begin
          dm.IBQuery1.Close;
          dm.IBQuery1.SQL.Clear;
          dm.IBQuery1.SQL.Add('update or insert into cpd(dd, sit) values(:dd, :sit) matching (dd)');
          dm.IBQuery1.ParamByName('dd').AsString := funcoes.Criptografar(FormatDateTime('dd/mm/yy', Form22.datamov));
          dm.IBQuery1.ParamByName('sit').AsInteger := 1;
          dm.IBQuery1.ExecSQL;

          Result := '1';
        end;
          try
            if dm.IBQuery1.Transaction.InTransaction then dm.IBQuery1.Transaction.Commit;
          except
            if dm.IBQuery1.Transaction.InTransaction then dm.IBQuery1.Transaction.Rollback;
          end;
        end
      else
        begin
          Result := dm.IBselect.FieldByName('sit').AsString;

          if (ret = '01') then
           begin
             dm.IBQuery1.Close;
             dm.IBQuery1.SQL.Clear;
             dm.IBQuery1.SQL.Add('delete from cpd');
             dm.IBQuery1.ExecSQL;

             dm.IBQuery1.Close;
             dm.IBQuery1.SQL.Clear;
             dm.IBQuery1.SQL.Add('update or insert into cpd(dd, sit) values(:dd, :sit) matching (dd)');
             dm.IBQuery1.ParamByName('dd').AsString := funcoes.Criptografar(FormatDateTime('dd/mm/yy', Form22.datamov));
             dm.IBQuery1.ParamByName('sit').AsInteger := 0;
             dm.IBQuery1.ExecSQL;

             dm.IBQuery1.Transaction.Commit;



             Result := '0';
           end;
        end;

  dm.IBselect.Close;
  dm.IBQuery1.Close;
end;

function Tfuncoes.buscaPorCodigotornaCodigoBarrasValido(const cod : String) : String;
var
  autopeca : boolean;
begin
  Result := '';
  dm.IBQuery3.Close;
  dm.IBQuery3.SQL.Clear;
  dm.IBQuery3.SQL.Add('select cod, codbar from produto where cod = :cod');
  dm.IBQuery3.ParamByName('cod').AsString := cod;
  dm.IBQuery3.Open;

  if not checaCodbar(StrNum(dm.IBQuery3.fieldbyname('codbar').AsString)) then
    begin
      dm.IBQuery4.Close;
      dm.IBQuery4.SQL.Clear;
      dm.IBQuery4.SQL.Add('select * from codbarras where cod = :cod');
      dm.IBQuery4.ParamByName('cod').AsString := cod;
      dm.IBQuery4.Open;

      while not dm.IBQuery4.Eof do
        begin
          if checaCodbar(StrNum(dm.IBQuery4.fieldbyname('codbar').AsString)) then
            begin
              Result := dm.IBQuery4.fieldbyname('codbar').AsString;
              exit;
            end;

          dm.IBQuery4.Next;
        end;

      if Result = '' then
        begin
          Result := DIGEAN('789000' + strzero(dm.IBQuery3.fieldByName('cod').AsInteger, 6));

          if buscaParamGeral(5, 'N') = 'N' then begin
            dm.IBQuery4.Close;
            dm.IBQuery4.SQL.Clear;
            dm.IBQuery4.SQL.Add('update produto set codbar = :codbar where cod = :cod');
            dm.IBQuery4.ParamByName('codbar').AsString := Result;
            dm.IBQuery4.ParamByName('cod').AsInteger := dm.IBQuery3.fieldByName('cod').AsInteger;
            dm.IBQuery4.ExecSQL;
            dm.IBQuery4.Transaction.Commit;
          end;  
        end;
    end
  else
    begin
      Result := dm.IBQuery3.fieldbyname('codbar').AsString;
    end;
end;


function Tfuncoes.buscaCodbarRetornaCodigo(codbar : String; pergunta : boolean = false) : String;
begin
  Result := '';
  if pergunta then
    begin
      codbar := funcoes.dialogo('generico',20,'1234567890'+#8,200, FALSE,'',Application.Title,'Qual o Código de Barras ?','');
      if codbar = '*' then exit;
    end;

  dm.IBselect.Close;
  dm.IBselect.SQL.Clear;                          //'select p.cod from produto p where (p.codbar = :codbar) or (p.cod = (select cod from codbarras where codbar = :codbar))'
  //dm.IBselect.SQL.Add('select p.cod from produto p where (p.codbar = :codbar) or (p.cod = (select cod from codbarras where codbar = :codbar))');
  dm.IBselect.SQL.Add('select p.cod, nome, p.codbar from produto p left join codbarras c on ((c.cod = p.cod)) where (p.codbar like '+QuotedStr('%'+ codbar +'%')+') or ((c.codbar like '+QuotedStr('%'+ codbar +'%')+') )');
  //dm.IBselect.ParamByName('codbar').AsString := codbar;
  dm.IBselect.Open;
  
  if not dm.IBselect.IsEmpty then
    begin
      Result := dm.IBselect.fieldbyname('cod').AsString;
    end
  else ShowMessage('Código de Barras nao Encontrado: ' + codbar);
  dm.IBselect.Close;
end;

function Tfuncoes.checaCodbar(vx_cod : String) : boolean;
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


function Tfuncoes.recuperaChaveNFe(const nota : string) : string;
var
  arq : TStringList;
  fim, i : Smallint;
  tmp : string;
begin
  dm.IBselect.Close;
  dm.IBselect.SQL.Clear;
  dm.IBselect.SQL.Add('select chave from nfe where nota = :nota');
  dm.IBselect.ParamByName('nota').AsString := nota;
  dm.IBselect.Open;

  Result := '';
  tmp := '';

  if dm.IBselect.IsEmpty then
    begin
      dm.IBselect.Close;
      arq := funcoes.listaArquivos(caminhoEXE_com_barra_no_final + 'NFE\EMIT\*.xml');
      fim := arq.Count -1;

      for i := 0 to fim do
        begin
          tmp := copy(arq.Strings[i], 26, 9);
          if StrToIntDef(tmp, 0) = StrToIntDef(nota, 0) then
            begin
              Result := copy(arq.Strings[i], 1, length(arq.Strings[i]) - 8);
              break;
            end;
        end;
    end
  else
    begin
      Result := dm.IBselect.fieldbyname('chave').AsString;
    end;

  dm.IBselect.Close;
end;

function Tfuncoes.listaArquivos(const pasta : String) : tstringlist;
Var
   SearchFile: TSearchRec;
   FindResult: Integer;
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

function Tfuncoes.testaChaveNFE(chave : String) : boolean;
var
  ini, fim : integer;
  total : currency;
  seq, dv, temp : string;
begin
  result := false;
  seq := '';
  seq := '432' + funcoes.CompletaOuRepete('','','98765432',5);
  total := 0;
  
  fim := length(chave) -1;
  for ini := 1 to fim do
      begin
        try
          total := total + StrToCurr(seq[ini]) * StrToCurr(chave[ini]) ;
        except
          result := false;
          exit;
        end;
      end;

    ini := (trunc(total) mod 11);
    ini := 11 - ini;
    if ini > 9 then ini := 0;
    dv := IntToStr(ini);

    if dv = chave[length(chave)] then result := true
     else result := false;

end;

function Tfuncoes.verSeExisteTabela(nome : String) : boolean;
begin
  Result := false;
  dm.IBselect.Close;
  dm.IBselect.SQL.Clear;
  dm.IBselect.SQL.Add('select rdb$relation_name from rdb$relations where (rdb$system_flag = 0) and (rdb$relation_name = ' + QuotedStr(nome) + ')');
  dm.IBselect.Open;

  if dm.IBselect.IsEmpty then Result := false
    else Result := true;

  dm.IBselect.Close;
end;

procedure Tfuncoes.atualizaHoraDoPCapatirDoServidor();
var
  ip : string;
begin
  ip := funcoes.buscaConfigNaPastaDoControlW('IPHora', '\\127.0.0.1');

  if ip = '\\127.0.0.1' then
    begin
      exit;
    end;

  WinExec(pansichar('net time ' + ip + ' /set /y'), SW_HIDE);
end;

function Tfuncoes.atualizaAutomatico() : String;
begin
  ShowMessage(FormatDateTime('dd/MM/YYYY', FileDateToDateTime(FileAge('HTTP:\CONTROLW.ZZ.vc\ControlW.old'))));
end;

procedure Tfuncoes.marcarVendaExportada(nota : String);
begin
  dm.IBQuery1.Close;
  dm.IBQuery1.SQL.Clear;
  dm.IBQuery1.SQL.Add('update venda set exportado = 1 where nota = :nota');
  dm.IBQuery1.ParamByName('nota').AsString := nota;
  dm.IBQuery1.ExecSQL;

  dm.IBQuery1.Transaction.Commit;
end;

function Tfuncoes.verVendedor(numVendedor : String) : String;
var pos : integer;
begin
  Result := '';
  dm.IBQuery3.Close;
  dm.IBQuery3.SQL.Clear;
  dm.IBQuery3.SQL.Add('select nome from vendedor where cod = :cod');
  dm.IBQuery3.ParamByName('cod').AsString := numVendedor;
  dm.IBQuery3.Open;

  Result := strzero(StrToIntDef(numVendedor, 0), 4) + '-' + dm.IBQuery3.fieldbyname('nome').AsString;
  dm.IBQuery3.Close;
end;


function Tfuncoes.gravaVendaSmallPendente(nota1 : string) : string;
  var
   vend, descProd : string;
  qtd, regDav : integer;
  tot : currency;
begin
   //numPedido := funcoes.dialogo('generico',0,'1234567890'+#8,30, true,'',Application.Title,'Informe o Número Da Nota:',nota);
   //if numPedido = '*' then exit;

   dm.IBQuery4.SQL.Clear;
   dm.IBQuery4.SQL.Add('select nota, desconto, data, total, vendedor, exportado from venda where (nota = :nota)');
   dm.IBQuery4.ParamByName('nota').AsString := nota1;
   dm.IBQuery4.Open;

   if dm.IBQuery4.IsEmpty then
     begin
       dm.IBQuery4.Close;
       ShowMessage('Nota ' + nota1 + ' Não Encontrada');
       exit;
     end;

   if dm.IBQuery4.FieldByName('exportado').AsInteger = 1 then
     begin
       descProd := funcoes.dialogo('generico',0,'SN',20,true,'S',Application.Title,'A Nota Já foi Exportada. Deseja Exporta-la Novamente?(S/N)','S');
       if ((descProd = '*') or (descProd = 'N')) then exit;
     end;

   Result := '';
   try
     if not dmSmall.BdSmall.Connected then dmSmall.BdSmall.Connected := true;

     dmSmall.IBQuerySmall.Close;
     dmSmall.IBQuerySmall.SQL.Clear;
     dmSmall.IBQuerySmall.SQL.Add('delete from orcament where cast(pedido as integer) = :nota');
     dmSmall.IBQuerySmall.ParamByName('nota').AsString := nota1;
     dmSmall.IBQuerySmall.ExecSQL;

     dmSmall.IBQuerySmall.Transaction.Commit;

     qtd := 0;
     regDav := StrToIntDef(Incrementa_Generator('SMALL', 0) , 0);
     tot := 0;

     vend := dm.IBQuery4.fieldbyname('vendedor').AsString;
     vend := verVendedor(vend);

     dm.IBQuery3.Close;
     dm.IBQuery3.SQL.Clear;
     dm.IBQuery3.SQL.Add('select cod, quant, total, nota, data, p_venda from item_venda where nota = :nota');
     dm.IBQuery3.ParamByName('nota').AsString := nota1;
     dm.IBQuery3.Open;

     while not dm.IBQuery3.Eof do
       begin
         dmsmall.IBQuerySmall.Close;
         dmSmall.IBQuerySmall.SQL.Clear;
         dmSmall.IBQuerySmall.SQL.Add('update or insert into orcament (registro, codigo, descricao, medida, ' +
         'quantidade, unitario, total, data, tipo, pedido, vendedor )' +
         'values (:registro, :codigo, :descricao, :unMedida, ' +
         ':qtd, :unitario, :total, :data, :tipo, :pedido, :vendedor ) ' +
         'MATCHING (pedido, codigo, total, registro)');

         dm.IBselect.Close;
         dm.IBselect.SQL.Clear;
         dm.IBselect.SQL.Add('select nome, cod, unid from produto where cod = :cod');
         dm.IBselect.ParamByName('cod').AsString := dm.IBQuery3.fieldbyname('cod').AsString;
         dm.IBselect.Open;

         //incrementa numero de registro da tabela orcament
         regDav := regDav + 1;
         //grava cada item de venda na tabela orcament (DAV)

         dmSmall.IBQuerySmall.parambyname('codigo').AsString := strzero(dm.IBQuery3.fieldbyname('cod').AsString, 5);
         dmSmall.IBQuerySmall.parambyname('descricao').AsString := ve_descricao(dm.IBselect.fieldbyname('nome').AsString,
         alltrim(copy(dm.IBselect.fieldbyname('unid').AsString, 1, 3)));
         dmSmall.IBQuerySmall.parambyname('unMedida').AsString := copy(dm.IBselect.fieldbyname('unid').AsString, 1, 3);
         dmSmall.IBQuerySmall.parambyname('qtd').AsCurrency := dm.IBQuery3.fieldbyname('quant').AsCurrency;
         dmSmall.IBQuerySmall.parambyname('total').AsCurrency := abs(dm.IBQuery3.fieldbyname('total').AsCurrency);
         dmSmall.IBQuerySmall.parambyname('data').AsDateTime := dm.IBQuery4.fieldbyname('data').AsDateTime;
         dmSmall.IBQuerySmall.parambyname('tipo').AsString := 'ORCAME';
         dmSmall.IBQuerySmall.parambyname('pedido').AsString := strzero(dm.IBQuery4.fieldbyname('nota').AsString, 10);
         dmSmall.IBQuerySmall.parambyname('unitario').AsCurrency := dm.IBQuery3.fieldbyname('p_venda').AsCurrency;
         dmSmall.IBQuerySmall.parambyname('registro').AsInteger := regDav;

         tot := tot + dm.IBQuery3.fieldbyname('total').AsCurrency;
         dmSmall.IBQuerySmall.ExecSQL;

         dm.IBQuery3.Next;
       end;

       dm.IBselect.Close;

       dmSmall.IBQuerySmall.Close;
       dmSmall.IBQuerySmall.SQL.Clear;
       dmSmall.IBQuerySmall.SQL.Add('update or insert into orcament (registro, codigo, descricao, medida, ' +
       'quantidade, unitario, total, data, tipo, pedido, vendedor )' +
       'values (:registro, :codigo, :descricao, :unMedida, ' +
       ':qtd, :unitario, :total, :data, :tipo, :pedido, :vendedor ) ' +
       'MATCHING (pedido, codigo, total)');

       //incrementa numero de registro da tabela orcament
       regDav := regDav + 1;

       dmSmall.IBQuerySmall.parambyname('descricao').AsString := 'Desconto';
       dmSmall.IBQuerySmall.parambyname('registro').AsInteger := regDav;
       dmSmall.IBQuerySmall.parambyname('total').AsCurrency := abs(tot - dm.IBQuery4.fieldbyname('total').AsCurrency);
       dmSmall.IBQuerySmall.parambyname('data').AsDateTime := dm.IBQuery4.fieldbyname('data').AsDateTime;
       dmSmall.IBQuerySmall.parambyname('tipo').AsString := 'ORCAME';
       dmSmall.IBQuerySmall.parambyname('pedido').AsString := strzero(dm.IBQuery4.fieldbyname('nota').AsString, 10);;
       dmSmall.IBQuerySmall.parambyname('vendedor').AsString := vend;

       dmSmall.IBQuerySmall.ExecSQL;

       // seta o generator para o ultimo registro

     reStartGenerator('SMALL', regDav);
       {dm.IBQuery2.Close;
       dm.IBQuery2.SQL.Clear;
       dm.IBQuery2.SQL.Add('ALTER SEQUENCE SMALL RESTART WITH ' + IntToStr(regDav));
       dm.IBQuery2.ExecSQL;
       dm.IBQuery2.Transaction.Commit;
       }
       dmSmall.IBQuerySmall.Transaction.Commit;
       dmSmall.BdSmall.Connected := false;
       funcoes.marcarVendaExportada(nota1);

       ShowMessage('A nota ' + nota1 + ' Foi Exportada');

     Except
       on E: Exception do
         begin
           gravaErrosNoArquivo(e.Message, 'Funcoes', '210', 'funcoes.gravaVendaSmallPendente');
           Result := e.Message;
           dmSmall.BdSmall.Connected := false;
           ShowMessage('Não foi Possível Exportar o DAV. Verifique as Configurações e Tente Novamente.');
           exit;
         end;
     end;
 end;

function Tfuncoes.incrementaGenSmall(nome, valor : String) : Integer;
begin
  Result := 0;
  dmSmall.BdSmall.Connected := true;
  dmSmall.IBQuery2.Close;
  dmSmall.IBQuery2.SQL.Clear;
  dmSmall.IBQuery2.SQL.Add('select gen_id('+ nome +','+ valor +') as venda from rdb$database');
  //dmSmall.IBQuery2.SQL.Add('ALTER SEQUENCE ' + gen + ' RESTART WITH ' + Valor);
  dmSmall.IBQuery2.Open;

  Result := StrToIntDef(dmSmall.IBQuery2.Fieldbyname('venda').asstring, 0);
  dmSmall.IBQuery2.Close;
end;

procedure Tfuncoes.restartGeneratorSMALL(gen, valor : String);
begin
  dmSmall.BdSmall.Connected := true;
  dmSmall.IBQuery2.Close;
  dmSmall.IBQuery2.SQL.Clear;
  dmSmall.IBQuery2.SQL.Add('ALTER SEQUENCE ' + gen + ' RESTART WITH ' + Valor);
  dmSmall.IBQuery2.ExecSQL;

  dmSmall.IBQuery2.Transaction.Commit;
end;

procedure Tfuncoes.executaCalculadora();
begin
  RxCalculator1.Title := 'ControlW Calculadora';
  RxCalculator1.Execute;
end;

function Tfuncoes.GerarCodigo(Codigo: String; imagem1 : timage) : integer;
const
digitos : array['0'..'9'] of string[5]= ('00110', '10001', '01001', '11000',
'00101', '10100', '01100', '00011', '10010', '01010');
var s : string;
i, j, x, t, tot : Integer;
begin
  // Gerar o valor para desenhar o código de barras
  // Caracter de início
  tot := 0;
  s := '0000';
  for i := 1 to length(codigo) div 2 do
  for j := 1 to 5 do
   s := s + Copy(Digitos[codigo[i * 2 - 1]], j, 1) + Copy(Digitos[codigo[i * 2]], j, 1);
  // Caracter de fim
  s := s + '100';
  // Desenhar em um objeto canvas
  // Configurar os parâmetros iniciais
  x := 0;
  // Pintar o fundo do código de branco
  imagem1.Canvas.Brush.Color := clWhite;
  imagem1.Canvas.Pen.Color := clWhite;
  imagem1.Canvas.Rectangle(0,0, 2000, 79);
  // Definir as cores da caneta
  imagem1.Canvas.Brush.Color := clBlack;
  imagem1.Canvas.Pen.Color := clBlack;
  // Escrever o código de barras no canvas
  for i := 1 to length(s) do
    begin
      // Definir a espessura da barra
      t := strToInt(s[i]) * 2 + 1;
      // Imprimir apenas barra sim barra não (preto/branco - intercalado);
      if i mod 2 = 1 then
      imagem1.Canvas.Rectangle(x, 0, x + t, 79);
      // Passar para a próxima barra
      x := x + t;
      imagem1.Width := x + 10;
    end;
  imagem1.Canvas.Brush.Color := clWhite;
  imagem1.Canvas.Pen.Color := clWhite;
  imagem1.Canvas.Font.Color := clBlack;
  tot := imagem1.Canvas.TextWidth(codigo);
  //centraliza o numero do codigo de barras na imagem
  imagem1.Canvas.TextOut(trunc((x - tot) / 2), 82, Codigo);
  Result := x + 5;
end;


function Tfuncoes.verificaConexaoComInternetSeTiverTRUEsenaoFALSE : boolean;
var
  Flags : Cardinal;
begin
  Result := false;
  if not InternetGetConnectedState(@Flags, 0) then
   Result := false
  else
  if (Flags and INTERNET_CONNECTION_LAN) <> 0 then
   Result := true
  else
  if (Flags and INTERNET_CONNECTION_PROXY) <> 0 then
   Result := true
  else
   Result := true;
end;

function GetFileList(const Path: string): TStringList;
  var
    I: Integer;
    SearchRec: TSearchRec;
  begin
    Result := TStringList.Create;
    try
      I := FindFirst(Path, 0, SearchRec);
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

function Tfuncoes.verEquivalencia(cod : String) : String;
var list1 : TStringList;
ar : string;
i : integer;
begin
  if cod = '' then
    begin
      ShowMessage('Este produto não possui Equivalências');
      exit;
    end;
  ar := '';
  list1 := TStringList.Create;
  list1.Add(cod);

  dm.IBQuery4.Close;
  dm.IBQuery4.SQL.Clear;
  dm.IBQuery4.SQL.Add('select refori, codbar from produto where ((codbar = :cod) or (refori = :cod))');
  dm.IBQuery4.ParamByName('cod').AsString := cod;
  dm.IBQuery4.Open;

  while not dm.IBQuery4.Eof do
    begin
      list1.Add(dm.IBQuery4.fieldbyname('codbar').AsString);

      dm.IBQuery3.Close;
      dm.IBQuery3.SQL.Clear;
      dm.IBQuery3.SQL.Add('select refori, codbar from produto where ((codbar = :cod) or (refori = :cod))');
      dm.IBQuery3.ParamByName('cod').AsString := list1[list1.count -1];
      dm.IBQuery3.Open;

      while not dm.IBQuery3.Eof do
        begin
          list1.Add(dm.IBQuery4.fieldbyname('codbar').AsString);
          dm.IBQuery3.Next;
        end;
      dm.IBQuery4.Next;
    end;

  dm.IBQuery3.Close;
  dm.IBQuery4.Close;
  {while true do
    begin
      dm.IBQuery4.Close;
      dm.IBQuery4.SQL.Clear;
      dm.IBQuery4.SQL.Add('select refori, codbar from produto where  (codbar = :cod)');
      dm.IBQuery4.ParamByName('cod').AsString := list1[list1.count -1];
      dm.IBQuery4.Open;

      if not dm.IBQuery4.IsEmpty then
        begin
          while not dm.IBQuery4.Eof do
            begin
              dm.IBQuery3.Close;
              dm.IBQuery3.SQL.Clear;
              dm.IBQuery3.SQL.Add('select refori, codbar from produto where  (codbar = :cod)');
              dm.IBQuery3.ParamByName('cod').AsString := list1[list1.count -1];
              dm.IBQuery3.Open;

              while not dm.IBQuery4.Eof do
                begin

                end;
              list1.Add(dm.IBQuery4.fieldbyname('codbar').AsString);
              dm.IBQuery4.Next;
            end;
          if dm.IBQuery4.fieldbyname('refori').AsString = '' then break;
        end
      else
        begin
          dm.IBQuery4.Close;
          break;
        end;
    end;    }
  if list1.Count = 1 then
    begin
      ShowMessage('Este produto não possui Equivalências');
      exit;
    end;

  ar := QuotedStr(list1.Strings[0]) + ',';
  for i := 1 to list1.Count -1 do
    begin
      ar := ar + QuotedStr(list1.Strings[i]) + iif(list1.Count -1 = i  ,'',',');
    end;

//  ShowMessage(ar);
  dm.produtotemp.Close;
  dm.produtotemp.SQL.Clear;
  dm.produtotemp.SQL.Add('select codbar, nome as Descricao,p_venda as Preco,quant as estoque,cod, refori as '+ refori1 +' from produto where codbar in ('+ ar +') order by descricao');
  dm.produtotemp.Open;
  funcoes.FormataCampos(dm.produtotemp, 2, '', 2);

  form25 := tform25.Create(self);
  funcoes.CtrlResize(tform(form25));
  form25.DBGrid1.DataSource := dm.dsprodtemp;
  form25.ShowModal;

end;


function Tfuncoes.troca_str(texto, valor, novo : string) : string;
begin
  Result := '';
  if Pos(valor, texto) > 0 then
    begin
      Result := copy(texto, 1 , Pos(valor, texto) -1) + novo + copy(texto, Pos(valor, texto) + length(valor), length(texto));
    end
  else
    begin
      Result := texto;
    end;
end;

FUNCTION Tfuncoes.IMP_CODBAR(const cod : String) : boolean;
VAR
 _CB, _REF, LINHA, QTD, _PV, _COD, imp : String ;
 LIDO, POSI, INI, FIM : integer;
 hand, arqTXT : TStringList;
begin
  QTD := funcoes.dialogo('generico',0,'1234567890'+#8,0,false,'','Control For Windows','Quantas Etiquetas Imprimir ?','3') ;
  if QTD = '*' then exit;

  form39 := tform39.Create(self);
  funcoes.CtrlResize(tform(form39));
  form39.ListBox1.Clear;
  form39.ListBox1.Items.Add('Individual');
  form39.ListBox1.Items.Add('Para Gondola');
  form39.ListBox1.Selected[0] := true;
  form39.Position := poScreenCenter;
  form39.BorderStyle := bsDialog;
  form39.ListBox1.Font.Size := 10;
  form39.Caption := 'Configurações';
  form39.conf := 1;
  form39.ShowModal;
  form39.Free;
  if funcoes.lista1 = '*' then exit;
{  if lista1 = '0' then
    begin

    end
  else
    begin

    end;

}
   dm.IBselect.Close;
   dm.IBselect.SQL.Text := 'select * from produto where cod = :cod';
   dm.IBselect.ParamByName('cod').AsInteger := StrToIntDef(cod, 0);
   dm.IBselect.Open;

   { dm.produto.close;
    dm.produto.SQL.Clear;
    dm.produto.SQL.Add('select cod,nome as Descricao,p_venda as Preco,quant as estoque,refori as '+ refori1 +',deposito,unid,codbar,aplic as Aplicacao,localiza as Localizacao,igual as Equivalente from produto order by nome asc;');

    dm.produto.Open;
    dm.produto.Locate('cod', cod, []);
    funcoes.OrdenaCamposVenda(ConfParamGerais.Strings[1]);
    funcoes.FormataCampos(dm.produto,2,'ESTOQUE',3);}

    HAND := TStringList.Create;
    arqTXT := TStringList.Create;

    _CB := copy(_CB, 1, 12);
    _PV := FormatCurr('#,###,###0.00', dm.IBselect.fieldbyname('p_venda').AsCurrency);
    _COD := dm.IBselect.fieldbyname('cod').AsString;
    _REF := ALLTRIM(dm.IBselect.fieldbyname(refori1).AsString);

    if ConfParamGerais[5] = 'S' then begin
      _CB := dm.IBselect.fieldbyname('codbar').AsString;
    end
    else begin
      _CB := strnum(dm.IBselect.fieldbyname('codbar').AsString);
      if _CB = '0' then _CB := funcoes.buscaPorCodigotornaCodigoBarrasValido(cod);
    end;

   {SET PRINTER TO TEXTO.TXT
    SET DEVICE TO PRINT
    SET PRINT ON
   }

   if not FileExists(IIF(lista1 = '0', caminhoEXE_com_barra_no_final + 'JS000041.dat'  , caminhoEXE_com_barra_no_final + 'JS000042.dat')) then
     begin
       ShowMessage('Arquivo: ' + IIF(lista1 = '0', caminhoEXE_com_barra_no_final + 'JS000041.dat'  , caminhoEXE_com_barra_no_final + 'JS000042.dat') + ' não foi encontrado');
       exit;
     end;

   QTD := IIF(StrToCurrDef(QTD, 0) / 3 = trunc(StrToCurrDef(QTD, 0) / 3), CurrToStr(StrToCurrDef(QTD, 0) / 3), CurrToStr(trunc(StrToCurrDef(QTD, 0) / 3) + 1));

   HANd.LoadFromFile(IIF(lista1 = '0', caminhoEXE_com_barra_no_final + 'JS000041.dat'  , caminhoEXE_com_barra_no_final + 'JS000042.dat'));
   FIM := hand.Count - 1;
   LIDO := 0;
   for lido := 0 to fim do
     begin
      LINHA := hand.Strings[lido];
      IF Length(ALLTRIM(LINHA)) > 0 then
        begin
          if (20 > ini) then ini := 20;
          POSI := pos('PRODUTO', LINHA);
          INI := StrToIntDef(copy(LINHA, POSI + 7, 2), 0);
          LINHA := TROCA_STR(linha,'PRODUTO' + IIF(INI <> 0, copy(LINHA, POSI + 7 , 2), ''), copy(dm.IBselect.fieldbyname('nome').AsString, 1, INI)) ;
          //LINHA := TROCA_STR(LINHA,'PRODUTO', copy(dm.produto.fieldbyname('DESCRICAO').AsString, 1, 20));
          LINHA := TROCA_STR(LINHA,'CODIGO', dm.IBselect.fieldbyname('cod').AsString);
          LINHA := TROCA_STR(LINHA, 'CODBAR', _CB);
          LINHA := TROCA_STR(LINHA, 'PRECO', _PV);
          LINHA := TROCA_STR(LINHA, 'REFORI', _REF);
          LINHA := TROCA_STR(LINHA, 'XQTD', STRZERO(QTD, 4));
          LINHA := TROCA_STR(LINHA, 'xqtd', QTD);
          IF not Contido('//', LINHA) then
            arqTXT.Add(LINHA);
        END;
     end;
   hand.Clear;
   hand := nil;

   imp := LerConfig(form22.Pgerais.values['imp'], 8);
   if dm.IBQuery1.Transaction.InTransaction then dm.IBQuery1.Transaction.Commit;


   if LerConfig(form22.Pgerais.Values['imp'], 9) = 'U' then
     begin
       //imprime.impTxtTAP(arqTXT);
       //arqTXT.SaveToFile('\\127.0.0.1\BTP');
       imprime.ImprimeLivreDireto(1, StrToInt(_COD));
       exit;
     end;

   if imp = '' then imp := 'LPT1';  
   arqTXT.SaveToFile(imp);

   dm.IBselect.Close;

   //CopyFile(Pansichar(caminhoEXE_com_barra_no_final + 'TEXTO.TXT'), 'LPT1', true);
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

function maior(v1, v2 : variant) : variant;
begin
 Result := 0;
 if v1 > v2 then Result := v1
 else Result := v2;
end;

function Tfuncoes.dataDoArquivo(const FileName: string): TDateTime;
begin
  Result := FileDateToDateTime(FileAge(FileName));
end;

function FileAgeCreate(const FileName: string): String;
var
  ff : string;
begin
  Result := FormatDateTime('yy.mm.dd', FileDateToDateTime(FileAge(FileName)));  //copy(ff, 9, 2) + '.' + copy(ff, 4, 2) + '.' + copy(ff, 1, 2);
end;

function Tfuncoes.verificaPermissaoPagamento(const abreTelaBloqueado : boolean = true) : String;
var
  th,tmt : TStringList;
  arquivo1 : TFileStream;
  tst : boolean;
  i,a, dias : integer;
  tft, tmpi : string;
  query : TIBQuery;
begin
 query := TIBQuery.Create(self);
 query.Database := dm.bd;
 Result := '';

 try
   tmpi := '';
   tmpi := funcoes.addRegSite('', query);
   if tmpi = '' then exit;

   tmt := TStringList.Create;

   LE_CAMPOS(tmt, tmpi, '-', true);

   if funcoes.Contido('-4-', tmpi) then
     begin
       Result := '4';
       exit;
     end;

   if funcoes.Contido('-BLOQUEADO-', tmpi) then
     begin
       if funcoes.Contido('-2-', tmpi) then
         begin
           adicionaRegistrosBloqueio;
         end;

       try
         dias   := StrToIntDef(tmt.Values['3'], 15);
         if dias = 0 then dias := 15;
       except
         dias := 15;
       end;

       funcoes.adicionaRegistroDataBloqueio(abreTelaBloqueado, true, dias, query, true);
     end;

   if funcoes.Contido('-DESBLOQUEADO-', tmpi) then
     begin
       funcoes.limpaBloqueado(query);
     end;
     
  except
    pergunta1.Close;
    query.Free;
    Result := 'ERRO';
    exit;
  end;

  query.Free;
end;

procedure Tfuncoes.adicionaConfig(valorQueProvavelmenteExiste, NovoValor : string);
var
  i : integer;
  tmp : string;
begin
  i := 0;
  tmp := '';
  while (i < 1000) do
    begin
     // if Contido(IntToStr(i), valorQueProvavelmenteExiste)
     // tmp :=
      i := i + 1;

    end;
end;

procedure Tfuncoes.converteDados;
var qtd, aliq, fim, atual : integer; cbr, codSeq, _cst, _st, uni, titulo : string;
contagemErroBd : integer;
quant : currency;
begin
  titulo := funcoes.dialogo('generico',30,'1234567890'+#8,30,false,'',Application.Title,'Escolha uma Opção:' + #13 + #10 + '1 - Exclui Produtos SMALLSOFT' + #13 + #10 + '2 - Adiciona 1000 no Estoque','');
  if titulo = '*' then exit;

  try
    dmSmall.BdSmall.Connected := true;
    atual := 0;
    dm.IBselect.Close;
    dm.IBselect.SQL.Clear;
    dm.IBselect.SQL.Add('select cod, nome, unid, codbar, refori, aliquota, p_compra, p_venda, quant from produto');
    dm.IBselect.Open;
    dm.IBselect.FetchAll;

    fim := dm.IBselect.RecordCount;

    if  (titulo = '1') then
      begin
         funcoes.informacao(1,2,'Excluindo... ',true,false,2);
         dmSmall.IBQuerySmall.SQL.Clear;
         dmSmall.IBQuerySmall.SQL.Add('delete from estoque');
         dmSmall.IBQuerySmall.Open;
         dmSmall.IBQuerySmall.Close;
      end;

   // Memo1.Lines.Add('Exportando dados do Control Estoque...');
   funcoes.informacao(1,fim,'Exportando dados do Control Estoque...',true,false,2);
    qtd := 0;
    while (not dm.IBselect.Eof) do
      begin
         qtd := qtd + 1;
         if round(qtd / fim * 100) <> atual then
           begin
             atual := round(qtd / fim * 100);
             funcoes.informacao(dm.IBselect.RecNo, fim,'Exportando dados do Control Estoque...',false,false,2);
             Application.ProcessMessages;
           end;

         //unidade
         uni := trim(copy(dm.IBselect.fieldbyname('unid').asstring, 1, 3));

         //quantidade em estoque
         quant := dm.IBselect.fieldbyname('quant').AsCurrency;
         if quant < 0 then quant := 0;
         //se a quantidade for zero ou menor informa 1000
         if ((quant = 0) or (titulo = '2') ) then quant := quant + 1000.00;

         //código de barras
         cbr := dm.IBselect.fieldbyname('codbar').AsString;
         if ((copy(cbr, 1, 1) = '2') and (length(cbr) <= 9)) then
            begin
              if (copy(cbr, 6, 1) = '1') then uni := 'KU' else uni := 'KG';
              cbr := (copy(cbr, 1, 5) + '00')
            end
           else cbr := copy(cbr, 1, 14);

         cbr := trim(cbr);

         //codSeq := strzero(QueryControlProd.fieldbyname('cod').AsInteger, 5);
          codSeq := dm.ibselect.fieldbyname('cod').AsString;
         _st := dm.IBselect.fieldbyname('aliquota').AsString;
         _st := trim(_st);
         if (_st = '') then _st := '0';
         if (_st = '0') then aliq := 0 else
            if (strtoint(_st) <= 12) then aliq := strtoint(_st) else aliq := 0;

         if (aliq = 10) then
            begin
              _cst := '060';
              _st := 'F';
            end;
         if (aliq = 11) then
            begin
              _cst := '040';
              _st := 'I';
            end;
         if (aliq = 12) then
            begin
              _cst := '041';
              _st := 'N';
            end;
         if (aliq = 1) then
             begin
               _cst := '000';
               _st := '01';
             end;
         if ((aliq = 0) or (aliq = 2) or (_st = '0')) then
            begin
              _cst := '000';
              _st := '02';
            end;
         dmSmall.IBQuerySmall.SQL.Clear;
         dmSmall.IBQuerySmall.SQL.Add('update or insert into estoque (registro, codigo, referencia, ' +
         'medida, descricao, custocompr, preco, qtd_atual, cst, csosn, st)' +
         'values (:cod10, :cod5, :codbar, :unid, :nome, :p_compra, :p_venda, :quant, :cst, :csosn, :st) ' +
         'MATCHING (registro)');
         dmSmall.IBQuerySmall.parambyname('cod10').AsString := '00000' + codSeq;
         dmSmall.IBQuerySmall.parambyname('cod5').AsString := codSeq;
         dmSmall.IBQuerySmall.parambyname('codbar').AsString := cbr;
         dmSmall.IBQuerySmall.parambyname('unid').AsString := uni;
         dmSmall.IBQuerySmall.parambyname('nome').AsString := ve_descricao(dm.IBselect.fieldbyname('nome').asstring, uni);
         dmSmall.IBQuerySmall.parambyname('p_compra').AsCurrency := dm.ibselect.fieldbyname('p_compra').AsCurrency;
         dmSmall.IBQuerySmall.parambyname('p_venda').AsCurrency := dm.ibselect.fieldbyname('p_venda').AsCurrency;
         dmSmall.IBQuerySmall.parambyname('quant').AsCurrency := quant;
         dmSmall.IBQuerySmall.parambyname('cst').AsString := _cst;
         dmSmall.IBQuerySmall.parambyname('csosn').AsString := '101';
         dmSmall.IBQuerySmall.parambyname('st').AsString := _st;
         try
           dmSmall.IBQuerySmall.Open;
         except
         end;
         dm.IBselect.Next;
      end;
    //ShowMessage('Exportação de dados Concluída: ' + inttostr(qtd) + ' itens exportados');
   except
     on E: Exception do
       begin
         ShowMessage('Erro(converteDados): ' +  E.Message);
         contagemErroBd := contagemErroBd + 1;
         dmSmall.BdSmall.Connected := false;
       end;
  end;

  dmSmall.IBQuerySmall.Close;
  dmSmall.BdSmall.Connected := false;
  dm.ibselect.Close;
  funcoes.informacao(0,1,'',false,true,2);
end;

procedure Tfuncoes.atualizaBD;
var
  tt : TStringList;
begin
  tt := TStringList.Create;
  tt.Add('11');
  tt.SaveToFile(caminhoEXE_com_barra_no_final + 'bd0.fdb');
  tt.Free;

  if ParamCount = 0 then
    begin
      tt := TStringList.Create;
      tt.Add('@echo off');
      tt.Add('timeout 1 /nobreak');
      tt.Add('start ' + ' ' + ParamStr(0));
      tt.Add('exit');
      tt.SaveToFile(caminhoEXE_com_barra_no_final + 'exec.bat');
      tt.Free;

      WinExec(pansichar(caminhoEXE_com_barra_no_final + 'exec.bat'), SW_HIDE);
    end;  
  Application.Terminate;
end;

procedure Tfuncoes.adicionarExcecao;
begin
  if messageDlg('Deseja Adcionar Exceção do Firebird no Firewall do Windows?', mtConfirmation, [mbyes, mbNo], 0) = mrYes then
    begin
      WinExec('netsh.exe -c firewall add portopening protocol=TCP port=3050 name=Teste mode=ENABLE scope=SUBNET', SW_HIDE);
    end
  else Application.Terminate;  
end;

function gravaErrosNoArquivo(erro, formulario, linha, funcao : String) : String;
var
  tem : TStringList;
begin
  tem := TStringList.Create;
  if FileExists(caminhoEXE_com_barra_no_final + 'errolog.txt') then
    begin
      tem.LoadFromFile(caminhoEXE_com_barra_no_final + 'errolog.txt');
    end
  else
    begin
      tem.SaveToFile(caminhoEXE_com_barra_no_final + 'errolog.txt');
      tem.LoadFromFile(caminhoEXE_com_barra_no_final + 'errolog.txt');
    end;

  ShowMessage('Ocorreu um Erro: ' + erro);

  tem.Add('--------------------------------------------') ;
  tem.Add('formulario: '+ formulario);
  tem.Add('erro: '+ erro);
  tem.Add('linha: ' + linha);
  tem.Add('função: ' + funcao);
  tem.SaveToFile(caminhoEXE_com_barra_no_final + 'errolog.txt');
end;

function reStartGenerator(nome : string; Valor : integer): String;
begin
  dm.IBQuery4.Close;
  dm.IBQuery4.SQL.Clear;
  dm.IBQuery4.SQL.Add('ALTER SEQUENCE ' + nome + ' RESTART WITH ' + IntToStr(Valor));
  dm.IBQuery4.ExecSQL;

  dm.IBQuery4.Transaction.Commit;
  Result := '';
end;

function MessageText(wmessage: String; flColor: TColor; flBold, flItalic: boolean;WWFormColor:TColor): String;
begin
  Form42 := TForm42.Create(Application);
  form42.defineScreenSave(3,'');
  form42.WindowState := wsNormal;
  form42.Label1.Caption := wmessage;
  form42.Label1.Font.Color := flColor;
  form42.Color := WWFormColor;
  form42.Width := form42.Label1.Width + 40;
  form42.Height := form42.Label1.Height + 100;
  form42.Label1.Top := trunc((form42.Height - form42.Label1.Height) / 2);
  form42.ShowModal;
  form42.Free;
end;

function formataDataDDMMYY(data : tdatetime) : String;
begin
  Result := '';
  Result := FormatDateTime('dd/mm/yy', data);
end;

function verificaSeTemImpressora() : boolean;
begin
  Result := false;
  if printer.Printers.Count > 0 then Result := true
    else Result := false;
end;

function Tfuncoes.verificaCodbar(cod, codbar : string; opcao : smallint) : String;
var
  res      : smallint;
  sim, tes : String;
begin
  Result := '';
  tes := '';
  res := 0;

  dm.IBselect.Close;
  dm.IBselect.SQL.Clear;
  dm.IBselect.Close;
  dm.IBselect.SQL.Clear;
  if opcao = 0 then dm.IBselect.SQL.Add('select c.cod, c.codbar from produto c where ((c.codbar = :cod) and (c.cod <> :cod1))')
    else  dm.IBselect.SQL.Add('select c.cod, c.codbar from produto c where ((c.codbar = :cod))');
      dm.IBselect.ParamByName('cod').AsString := codbar;
  if opcao = 0 then  dm.IBselect.ParamByName('cod1').AsString := cod;
  dm.IBselect.Open;

  if not dm.IBselect.IsEmpty then
    begin
      tes := '1';
      while not dm.IBselect.Eof do
        begin
          Result := Result + ' Código: ' + dm.IBselect.fieldbyname('cod').AsString + ' CodBarras: ' + dm.IBselect.fieldbyname('codbar').AsString + #13 + #10;
          dm.IBselect.Next;
        end;
    end;


  dm.IBselect.Close;
  dm.IBselect.SQL.Clear;
  if opcao = 0 then dm.IBselect.SQL.Add('select c.cod, c.codbar from codbarras c where ((c.codbar = :cod) and (c.cod <> :cod1))')
    else dm.IBselect.SQL.Add('select c.cod, c.codbar from codbarras c where ((c.codbar = :cod))');
  dm.IBselect.ParamByName('cod').AsString := codbar;
  if opcao = 0 then dm.IBselect.ParamByName('cod1').AsString := cod;
  dm.IBselect.Open;

  if not dm.IBselect.IsEmpty then
    begin
      tes := tes + '2';
      while not dm.IBselect.Eof do
        begin
          Result := Result + ' Código: ' + dm.IBselect.fieldbyname('cod').AsString + ' CodBarras: ' + dm.IBselect.fieldbyname('codbar').AsString + #13 + #10;
          dm.IBselect.Next;
        end;
    end;

  if tes = '' then
    begin
      dm.IBselect.Close;
      exit;
    end
  else
    begin
      Result := 'Código de barras já foi cadastrado no produto: ' + #13 + #10 + Result;
    end;

  dm.IBselect.Close;  
  if Result <> '' then
    begin
      ShowMessage(Result);

      {sim := funcoes.dialogo('generico',0,'SN',0,false,'S','Control For Windows','Deseja Excluir essa Referência ?','N');
      if funcoes.Contido('1', sim) then
        begin
          dm.IBQuery2.Close;
          dm.IBQuery2.SQL.Clear;
          dm.IBQuery2.SQL.Add('update produto set codbar = :codbar where cod = :cod');
          dm.IBQuery2.ParamByName('codbar').AsString := '';
          dm.IBQuery2.ParamByName('cod').AsString    := cod;
          dm.IBQuery2.ExecSQL;
        end;

      if funcoes.Contido('2', sim) then
        begin
          dm.IBQuery2.Close;
          dm.IBQuery2.SQL.Clear;
          dm.IBQuery2.SQL.Add('update produto set codbar = :codbar where cod = :cod');
          dm.IBQuery2.ParamByName('codbar').AsString := '';
          dm.IBQuery2.ParamByName('cod').AsString    := cod;
          dm.IBQuery2.ExecSQL;
        end;

      if dm.IBQuery2.Transaction.InTransaction then dm.IBQuery2.Transaction.Commit;}  
    end;

end;

procedure EmptyTList(Var AList: TList);
var
intContador: integer;
begin
for intContador:= (AList.Count-1) Downto 0 do
  begin
    Dispose(AList.Items[intContador]);
    AList.Delete(intContador);
  end;
end;


procedure Tfuncoes.CentralizaNoFormulario(var compo : TWinControl; var send : tform);
begin
  TLabel(compo).Left := trunc((send.Width - TLabel(compo).Width) / 2); 
end;

procedure Tfuncoes.SetRetornoBusca(ret : string);
begin
  retornobusca := ret;
end;

function Incrementa_Generator(Gen_name : string; valor_incremento : integer) : string;
begin
  dm.IBQuery1.Close;
  dm.IBQuery1.SQL.Clear;
  dm.IBQuery1.SQL.Add('select gen_id('+ Gen_name +','+ IntToStr(valor_incremento) +') as venda from rdb$database');
  dm.IBQuery1.Open;

  Result := '';
  Result := dm.IBQuery1.fieldbyname('venda').AsString;

  dm.IBQuery1.Close;
end;


procedure Tfuncoes.MeuKeyPress1(Sender: TObject; var Key: Char);
begin
  if ((Key = #13) or (Key = #27)) then pergunta1.Close;
end;


FUNCTION Tfuncoes.MensagemTextoInput(caption, default : string) : string;
begin
  pergunta1 := Tpergunta1.Create(Self);
  if caption = '' then pergunta1.Caption := Application.Title
    else pergunta1.Caption := caption;
  pergunta1.option := 2;
  pergunta1.gauge1.Visible := false;
  pergunta1.Label1.Visible := false;
  //pergunta1.Label1.Caption := Mensagem;
  pergunta1.Label1.Font.Color := clRed;
  CtrlResize(tform(pergunta1));

  pergunta1.tipo := 'texto';
  pergunta1.memo1 := TMemo.Create(self);
  pergunta1.memo1.Name := 'memo1';
  pergunta1.memo1.Parent := pergunta1;
  pergunta1.memo1.Align := alClient;
  pergunta1.memo1.Text := default;
  pergunta1.memo1.OnKeyPress := MeuKeyPress1;
  pergunta1.ShowModal;
  Result := pergunta1.memo1.Text;
  exit;

  Result := '';
  Result := valordg;
end;

function RetornaValorStringList(var ent : TStringList; estring : string) : string;
var i : integer;
begin
   cont := ent.Count - 1;
   Result := '';
   for i := 0 to cont do
     begin
       if funcoes.Contido(estring,ent.Strings[i]) then
         begin
           Result := ent.Strings[i];
           exit;
         end;
     end;
end;

procedure Tfuncoes.Button1Click(Sender: TObject);
begin
  tform(sender).Close;
end;

FUNCTION Tfuncoes.Mensagem(Caption : String;Mensagem : string; FontSize : integer; fonteLetra : string; btOk : boolean; option : integer; color : TColor) : string;
var label123 : TLabel;
begin
  pergunta1 := Tpergunta1.Create(Self);
  pergunta1.option := option;
  //pergunta1.Gauge1.Progress := 0;
  //pergunta1.Timer1.Enabled := true;
  pergunta1.Caption := Caption;

  pergunta1.Label1.Caption := Mensagem;
  pergunta1.Label1.Font.Color := color;
  CtrlResize(tform(pergunta1));
  pergunta1.Label1.Font.Name := fonteLetra;
  pergunta1.Label1.Font.Size := FontSize;
  pergunta1.Label1.Font.Style := [fsbold];
  pergunta1.Label1.Left := 10;

  //funcoes.CentralizaNoFormulario(twincontrol(pergunta1),tform(pergunta1));

  if pergunta1.Label1.Width + pergunta1.Label1.Left >= pergunta1.Width then pergunta1.Width := pergunta1.Label1.Width + pergunta1.Label1.Left + 15;
  if pergunta1.Label1.Height + pergunta1.Label1.Top + 50 >= pergunta1.Height then pergunta1.Height := pergunta1.Label1.Height + pergunta1.Label1.Top + 50;

  if btOk then
    begin
      pergunta1.Gauge1.Enabled := false;
      pergunta1.Gauge1.Visible := false;
      botao := TsButton.Create(self);
      botao.Name:='Button2';
      botao.Height := 25;
      botao.Width := 72;
      botao.Parent := pergunta1;
      botao.Caption := 'Ok';
      botao.Left := 0;
      botao.Top := (pergunta1.Height - botao.Height) - 30;
      botao.OnClick := pergunta1.sButton1Click;
      botao.Left    := trunc((pergunta1.Width / 2) - botao.Width );
      pergunta1.setButton(botao);
     // funcoes.CentralizaNoFormulario(twincontrol(botao), tform(pergunta1));
    end;
  //pergunta1.Height := 400;
  pergunta1.Label1.AutoSize := true;
  pergunta1.Label1.Left := 20;
  pergunta1.Show;
  {botao.Free;
  pergunta1.Free;
}end;

FUNCTION STR_ALFA(PAR : string) : string;
var
  INI, LIN,fim : integer;
  VALIDO : string;
begin
  valido := ',.-/0123456789ABCDEFGHIJKLMNOPQRSTUVXWYZ';
  Result := '';
  fim := length(PAR);
  FOR INI := 1 TO fim do
    begin
      IF FUNCOES.CONTIDO(UpperCase(PAR[ini]), VALIDO) THEN
         Result := Result + PAR[INI]
      ELSE
        Result := Result + ' ';
    end;
end;

procedure Retorna_Array_de_Numero_de_Notas(var mat : TStringList; notas : string; const separador : String = ' ');
var ini, fim,posi : integer;
begin
  mat := TStringList.Create;
  fim := length(Trim(notas));
  notas := trim(notas);
  posi := 1;
  for ini := 1 to fim do
    begin
      if notas[ini] = separador then
        begin
          mat.Add(copy(notas,posi,ini - posi));
          posi := ini + 1;
        end;
      if (mat.Count <> 0) and (ini = fim) then mat.Add(copy(notas,posi,fim - posi + 1));
    end;
  if mat.Count = 0 then mat.Add(notas);
end;

function VerificaCampoTabela(NomeCampo, tabela : string) : boolean;
var
  texto : string;
  ini : integer;
begin
  Result := false;
  dm.IBselect.Close;
  dm.IBselect.SQL.Clear;
  dm.IBselect.SQL.Add('select * from ' + tabela);
  dm.IBselect.Open;

  for ini := 0 to dm.IBselect.FieldList.Count -1 do
    begin
      if UpperCase(NomeCampo) = UpperCase(dm.IBselect.FieldList[ini].FieldName) then
        begin
          Result := true;
          break;
        end;
    end;

  dm.IBselect.Close;  
 { if funcoes.Contido(UpperCase(NomeCampo),UpperCase(texto)) then
    begin
      dm.IBselect.Close;
      Result := true;
    end
  else
    begin
      dm.IBselect.Close;
      Result := false;
    end;}
end;


procedure Tfuncoes.VerificaVersao_do_bd;
var
  versao_BD  : string;
  tmp, i,  fim : integer;
  alt : boolean;
  arq, pger, unid : TStringList;
begin

  if not FileExists(caminhoEXE_com_barra_no_final + 'bd0.fdb') then exit;

  pger := TStringList.Create;

  pger.Add('0=F');          //0
  pger.Add('1=0123456789'); //1
  pger.Add('2=S');          //2
  pger.Add('3=S');          //3
  pger.Add('4=S');          //4
  pger.Add('5=N');          //5
  pger.Add('6=0,33');       //6
  pger.Add('7=Rota');       //7
  pger.Add('8=1');          //8
  pger.Add('9=S');          //9
  pger.Add('10=3');          //10
  pger.Add('11=0,65');       //11
  pger.Add('12=3,00');       //12
  pger.Add('13=N');          //13
  pger.Add('14=N');          //14
  pger.Add('15=N');          //15
  pger.Add('16=N');          //16
  pger.Add('17=N');          //17
  pger.Add('18=45');         //18
  pger.Add('19=S');          //19
  pger.Add('20=N');          //20
  pger.Add('21=S');          //21
  pger.Add('22=N');          //22
  pger.Add('23=2');          //23
  pger.Add('24=5');          //24
  pger.Add('25=3');          //25
  pger.Add('26=N');          //26
  pger.Add('27=S');          //27
  pger.Add('28=0,00');       //28
  pger.Add('29=0,00');       //29
  pger.Add('30=N');          //30
  pger.Add('31=N');          //31
  pger.Add('32=N');          //32
  pger.Add('33=D');          //33
  pger.Add('34=S');          //34
  pger.Add('35=S');          //35
  pger.Add('36=S');          //36
  pger.Add('37=N');
  pger.Add('38=2');
  pger.Add('39=N');
  pger.Add('40=100,00');
  pger.Add('41=N');
  pger.Add('42=N');
  pger.Add('43=N');
  pger.Add('44=');
  pger.Add('45=');
  pger.Add('46=');
  pger.Add('47=');
  pger.Add('48=');
  pger.Add('49=');
  pger.Add('50=');

  alt := false;
  if not VerificaCampoTabela('TIPO_ITEM','PRODUTO') then
    begin
      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add('ALTER TABLE PRODUTO ADD TIPO_ITEM CHAR(2) DEFAULT ' + QuotedStr(''));
      dm.IBQuery1.ExecSQL;

      alt := true;
    end;

  if VerificaCampoTabela('REP','ITEM_VENDA') then
    begin
      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add('ALTER TABLE ITEM_VENDA DROP REP');
      dm.IBQuery1.ExecSQL;
      alt := true;
    end;

  if VerificaCampoTabela('VENDEDOR','OS_VENDA') = FALSE then
    begin
      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add('ALTER TABLE OS_VENDA ADD VENDEDOR SMALLINT DEFAULT 0 ');
      dm.IBQuery1.ExecSQL;
      dm.IBQuery1.Transaction.Commit;

      DM.IBQuery1.Close;
      dm.IBQuery1.SQL.Text := 'update OS_VENDA set vendedor = 0';
      dm.IBQuery1.ExecSQL;
    end;


  if VerificaCampoTabela('DESCONTO','ITEM_ORCAMENTO') = FALSE then
    begin
      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add('ALTER TABLE ITEM_ORCAMENTO ADD DESCONTO NUMERIC(10, 2) DEFAULT 0 ');
      dm.IBQuery1.ExecSQL;
      dm.IBQuery1.Transaction.Commit;

      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add('UPDATE ITEM_ORCAMENTO SET DESCONTO = 0 WHERE DESCONTO IS NULL');
      dm.IBQuery1.ExecSQL;
      dm.IBQuery1.Transaction.Commit;

      alt := true;
    end;

  if VerificaCampoTabela('CRC','ITEM_VENDA') then
    begin
      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add('ALTER TABLE ITEM_VENDA DROP CRC');
      dm.IBQuery1.ExecSQL;
      alt := true;
    end;

  if VerificaCampoTabela('FECHAMENTO','ITEM_VENDA') then
    begin
      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add('ALTER TABLE ITEM_VENDA DROP FECHAMENTO');
      dm.IBQuery1.ExecSQL;
      alt := true;
    end;

  if VerificaCampoTabela('REGISTRO','ITEM_VENDA') then
    begin
      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add('ALTER TABLE ITEM_VENDA DROP REGISTRO');
      dm.IBQuery1.ExecSQL;
      alt := true;
    end;

  {if not VerificaCampoTabela('CANCELADO','ITEM_VENDA') then
    begin
      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add('ALTER TABLE ITEM_VENDA ADD CANCELADO SMALLINT DEFAULT 0');
      dm.IBQuery1.ExecSQL;
      dm.IBQuery1.Transaction.Commit;

      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add('UPDATE ITEM_VENDA I SET I.CANCELADO = (SELECT CANCELADO FROM VENDA V WHERE V.NOTA = I.NOTA)');
      dm.IBQuery1.ExecSQL;
      dm.IBQuery1.Transaction.Commit;
      alt := true;
    end;}

  {if VerificaCampoTabela('CANCELADO','ITEM_VENDA') then
    begin
      try
      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add('ALTER TABLE ITEM_VENDA DROP CANCELADO');
      dm.IBQuery1.ExecSQL;
      except
      end;
      alt := true;
    end; }

  dm.IBselect.Close;
  dm.IBselect.SQL.Text := 'select * from cliente where ies like ''%-%''';
  dm.IBselect.Open;
  
  if not dm.IBselect.IsEmpty then
    begin
      dm.IBselect.Close;
      dm.IBselect.SQL.Text := 'select * from cliente';
      dm.IBselect.Open;
      dm.IBselect.FetchAll;

      while not dm.IBselect.Eof do
        begin
          if StrNum(dm.IBselect.fieldbyname('ies').AsString) <> dm.IBselect.fieldbyname('ies').AsString then
            begin
              dm.IBQuery1.Close;
              dm.IBQuery1.SQL.Text := 'update cliente set ies = :ies where cod = :cod';
              dm.IBQuery1.ParamByName('ies').AsString  := StrNum(dm.IBselect.fieldbyname('ies').AsString);
              dm.IBQuery1.ParamByName('cod').AsInteger := dm.IBselect.fieldbyname('cod').AsInteger;
              dm.IBQuery1.ExecSQL;
            end;
          dm.IBselect.Next;
        end;
    end;


  if not VerificaCampoTabela('COD','REGISTRO') then
    begin
      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add('ALTER TABLE REGISTRO ADD COD INTEGER DEFAULT 0 ');
      dm.IBQuery1.ExecSQL;
      alt := true;
    end;


  if not VerificaCampoTabela('EXPORTADO','VENDA') then
    begin
      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add('ALTER TABLE VENDA ADD EXPORTADO SMALLINT DEFAULT 0 ');
      dm.IBQuery1.ExecSQL;
      alt := true;
    end;

  if not VerificaCampoTabela('EXPORTADO','ITEM_VENDA') then
    begin
      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add('ALTER TABLE ITEM_VENDA ADD EXPORTADO SMALLINT DEFAULT 0 ');
      dm.IBQuery1.ExecSQL;
      alt := true;
    end;

  {if not VerificaCampoTabela('FECHAMENTO','ITEM_VENDA') then
    begin
      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add('ALTER TABLE ITEM_VENDA ADD FECHAMENTO INTEGER DEFAULT 0');
      dm.IBQuery1.ExecSQL;

      dm.IBQuery1.Transaction.Commit;

      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add('UPDATE ITEM_VENDA SET FECHAMENTO = 0');
      dm.IBQuery1.ExecSQL;
      alt := true;
    end;}

  if not VerificaCampoTabela('FECHAMENTO','VENDA') then
    begin
      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add('ALTER TABLE VENDA ADD FECHAMENTO INTEGER DEFAULT 0');
      dm.IBQuery1.ExecSQL;

      dm.IBQuery1.Transaction.Commit;

      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add('UPDATE VENDA SET FECHAMENTO = 0');
      dm.IBQuery1.ExecSQL;
      alt := true;
    end;

  if not VerificaCampoTabela('PIS','COD_OP') then
    begin
      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add('ALTER TABLE COD_OP ADD PIS CHAR(1) DEFAULT ' + QuotedStr(''));
      dm.IBQuery1.ExecSQL;
      alt := true;
    end;

 { if not VerSeExisteGeneratorPeloNome('DADOSNFE') then
    begin
      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add('CREATE SEQUENCE DADOSNFE');
      dm.IBQuery1.ExecSQL;
      dm.IBQuery1.Transaction.Commit;

      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add('ALTER TABLE SPEDDADOSADIC ADD COD INTEGER DEFAULT 0');
      dm.IBQuery1.ExecSQL;
      dm.IBQuery1.Transaction.Commit;

      DM.IBQuery1.Close;
      dm.IBQuery1.SQL.Text := 'update SPEDDADOSADIC set cod = gen_id(dadosnfe, 1)';
      dm.IBQuery1.ExecSQL;
      dm.IBQuery1.Transaction.Commit;
      alt := true;
    end;}

  if not VerSeExisteGeneratorPeloNome('SMALL') then
    begin
      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add('CREATE SEQUENCE SMALL');
      dm.IBQuery1.ExecSQL;
      alt := true;
    end;

 { if not VerSeExisteGeneratorPeloNome('COD_OP') then
    begin
      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add('CREATE SEQUENCE COD_OP');
      dm.IBQuery1.ExecSQL;
      dm.IBQuery1.Transaction.Commit;

      dm.IBselect.Close;
      dm.IBselect.SQL.Text := 'select max(cod) as cod from cod_op';
      dm.IBselect.Open;
      alt := true;
    end;
  }
    if not VerSeExisteGeneratorPeloNome('SPEDCONTADOR') then
    begin
      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add('CREATE SEQUENCE SPEDCONTADOR');
      dm.IBQuery1.ExecSQL;
      alt := true;
    end;

   if not VerSeExisteGeneratorPeloNome('FECHAMENTO') then
    begin
      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add('CREATE SEQUENCE FECHAMENTO');
      dm.IBQuery1.ExecSQL;

      dm.IBQuery1.Transaction.Commit;

      Incrementa_Generator('FECHAMENTO', 1);
      alt := true;
    end;

  if not VerSeExisteGeneratorPeloNome('NFCE') then
    begin
      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add('CREATE SEQUENCE NFCE');
      dm.IBQuery1.ExecSQL;
      dm.IBQuery1.Transaction.Commit;

      Incrementa_Generator('NFCE', 1);
      alt := true;
    end;

  dm.IBselect.Close;
  if not VerificaCampoTabela('COD','CONTASPAGAR') then
    begin
      dm.IBQuery1.Close;                              
      dm.IBQuery1.SQL.Text := 'ALTER TABLE CONTASPAGAR ADD COD INTEGER DEFAULT 0';
      dm.IBQuery1.ExecSQL;
      dm.IBQuery1.Transaction.Commit;

      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Text := 'update contaspagar set COD = gen_id(SMALL, 1)';
      dm.IBQuery1.ExecSQL;
      dm.IBQuery1.Transaction.Commit;
    end;

  if not VerificaCampoTabela('UNID2','PRODUTO') then
    begin
      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add('ALTER TABLE PRODUTO ADD UNID2 VARCHAR(8) DEFAULT ' + QuotedStr(''));
      dm.IBQuery1.ExecSQL;
      alt := true;
    end;

  if not VerificaCampoTabela('P_VENDA','ITEM_ORCAMENTO') then
    begin
      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add('ALTER TABLE ITEM_ORCAMENTO ' +
      'ADD P_VENDA NUMERIC(10,2) DEFAULT 0');
      dm.IBQuery1.ExecSQL;
    end;

  if not VerificaCampoTabela('UNID2','ITEM_ENTRADA') then
    begin
      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add('ALTER TABLE ITEM_ENTRADA ' +
      'ADD UNID2 VARCHAR(8) ' +
      'DEFAULT ' + QuotedStr(''));
      dm.IBQuery1.ExecSQL;
    end;

  if not VerificaCampoTabela('excluido','produto') then
    begin
      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add('ALTER TABLE produto ' +
      'ADD excluido smallint DEFAULT  0');
      dm.IBQuery1.ExecSQL;
      dm.IBQuery1.Transaction.Commit;

      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Text := 'update produto set excluido = 0';
      dm.IBQuery1.ExecSQL;
      dm.IBQuery1.Transaction.Commit;
    end;

  if not VerificaCampoTabela('excluido','usuario') then
    begin
      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add('ALTER TABLE usuario ' +
      'ADD excluido smallint DEFAULT  0');
      dm.IBQuery1.ExecSQL;
      dm.IBQuery1.Transaction.Commit;

      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Text := 'update usuario set excluido = 0';
      dm.IBQuery1.ExecSQL;
      dm.IBQuery1.Transaction.Commit;
    end;

  if not VerificaCampoTabela('desconto','produto') then
    begin
      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add('ALTER TABLE produto ' +
      'ADD desconto numeric(10, 3) DEFAULT  0');
      dm.IBQuery1.ExecSQL;
      dm.IBQuery1.Transaction.Commit;

      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Text := 'update produto set desconto = 0';
      dm.IBQuery1.ExecSQL;
      dm.IBQuery1.Transaction.Commit;
    end;

  if not VerificaCampoTabela('DATA','NFE') then
    begin
      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add('ALTER TABLE NFE ' +
      'ADD DATA DATE ' +
      'DEFAULT ' + QuotedStr('01.01.1900'));
      dm.IBQuery1.ExecSQL;
      dm.IBQuery1.Transaction.Commit;

      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Text := 'update nfe n set data = (select data from venda v where n.nota = v.nota )';
    end;

  {if verSeExisteTabela('PROMOC') then
    begin
      if VerificaCampoTabela('DOC', 'PROMOC') then
        begin
          if dm.IBselect.Transaction.InTransaction then dm.IBselect.Transaction.Commit;
          dm.IBQuery1.Close;
          dm.IBQuery1.SQL.Text := 'drop table promoc';
          dm.IBQuery1.ExecSQL;
          dm.IBQuery1.Transaction.Commit;
        end;
    end; }

  if NOT verSeExisteTabela('PROMOC') then
    begin
      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Text := 'CREATE TABLE PROMOC (' +
      'COD INTEGER DEFAULT 0 NOT NULL,' +
      'P_VENDA NUMERIC(10,2) DEFAULT 0,' +
      'QUANT NUMERIC(10,2) DEFAULT 0,' +
      'CONT INTEGER DEFAULT 0,' +
      'USUARIO SMALLINT DEFAULT 0,' +
      'DATA DATE DEFAULT ''01.01.1900'',' +
      'VALIDO DATE DEFAULT ''01.01.1900'')';
      dm.IBQuery1.ExecSQL;
      dm.IBQuery1.Transaction.Commit;

      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Text := 'alter table PROMOC' +
      ' add constraint PK_PROMOC ' +
      ' primary key (COD)';
      dm.IBQuery1.ExecSQL;
      dm.IBQuery1.Transaction.Commit;
    end;

  if NOT verSeExisteTabela('PROMOC1') then
    begin
      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Text := 'CREATE TABLE PROMOC1 (' +
      'DOC INTEGER DEFAULT 0 NOT NULL,' +
      'COD INTEGER DEFAULT 0 NOT NULL,' +
      'CODGRU smallint DEFAULT 0 NOT NULL,' +
      'P_VENDA NUMERIC(10,2) DEFAULT 0,' +
      'QUANT NUMERIC(10,2) DEFAULT 0,' +
      //'CONT INTEGER DEFAULT 0,' +
      'USUARIO SMALLINT DEFAULT 0,' +
      'DATA DATE DEFAULT ''01.01.1900'',' +
      'VALIDO DATE DEFAULT ''01.01.1900'',' +
      'tipo varchar(1) DEFAULT '''' )';
      dm.IBQuery1.ExecSQL;
      dm.IBQuery1.Transaction.Commit;

      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Text := 'alter table PROMOC1' +
      ' add constraint PK_PROMOC1 ' +
      ' primary key (DOC)';
      dm.IBQuery1.ExecSQL;
      dm.IBQuery1.Transaction.Commit;

      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Text := 'CREATE SEQUENCE PROMOC1';
      try
        dm.IBQuery1.ExecSQL;
        dm.IBQuery1.Transaction.Commit;
      except
      end;  

      dm.IBselect.Close;
      dm.IBselect.SQL.Text := 'select * from promoc';
      dm.IBselect.Open;

      while not dm.IBselect.Eof do begin
        dm.IBQuery1.Close;
        dm.IBQuery1.SQL.Text := 'insert into promoc1(doc, cod, codgru, p_venda, quant, usuario, data, valido, tipo) ' +
        'values('+Incrementa_Generator('promoc1', 1)+', :cod, :codgru, :p_venda, :quant, :usuario, :data, :valido, :tipo)';
        //dm.IBQuery1.ParamByName('doc').AsInteger    := StrToInt(Incrementa_Generator('promoc1', 1));
        dm.IBQuery1.ParamByName('cod').AsInteger    := dm.IBselect.fieldbyname('cod').AsInteger;
        dm.IBQuery1.ParamByName('codgru').AsInteger := 0;
        dm.IBQuery1.ParamByName('p_venda').AsCurrency := dm.IBselect.fieldbyname('p_venda').AsCurrency;
        dm.IBQuery1.ParamByName('quant').AsCurrency   := dm.IBselect.fieldbyname('quant').AsCurrency;
        dm.IBQuery1.ParamByName('usuario').AsInteger  := dm.IBselect.fieldbyname('usuario').AsInteger;
        dm.IBQuery1.ParamByName('data').AsDate        := dm.IBselect.fieldbyname('data').AsDateTime;
        dm.IBQuery1.ParamByName('valido').AsDate      := dm.IBselect.fieldbyname('valido').AsDateTime;
        dm.IBQuery1.ParamByName('tipo').AsString      := '0';
        dm.IBQuery1.ExecSQL;
        dm.IBselect.Next;
      end;
    end;

  if NOT verSeExisteTabela('CEST') then
    begin
      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Text := 'CREATE TABLE CEST (' +
      'CEST VARCHAR(10) DEFAULT '''' NOT NULL,' +
      'NOME VARCHAR(100) DEFAULT '''')';
      dm.IBQuery1.ExecSQL;
      dm.IBQuery1.Transaction.Commit;
      //'NCM VARCHAR(10) DEFAULT '''',' +

      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Text := 'alter table CEST ' +
      'add constraint PK_CEST ' +
      'primary key (CEST)';
      dm.IBQuery1.ExecSQL;
      dm.IBQuery1.Transaction.Commit;
    end;

  if NOT verSeExisteTabela('NCM_CEST') then
    begin
      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Text := 'CREATE TABLE NCM_CEST (' +
      'NCM VARCHAR(10) DEFAULT '''' NOT NULL,' +
      'CEST VARCHAR(10) DEFAULT '''' NOT NULL)';
      dm.IBQuery1.ExecSQL;
      dm.IBQuery1.Transaction.Commit;
      //'NCM VARCHAR(10) DEFAULT '''',' +

      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Text := 'alter table NCM_CEST ' +
      'add constraint PK_NCM_CEST ' +
      'primary key (NCM, CEST)';
      dm.IBQuery1.ExecSQL;
      dm.IBQuery1.Transaction.Commit;

      atualizaTabelaCest;
    end;

  if NOT verSeExisteTabela('PRODUTO_DELETED') then
    begin
      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add('CREATE TABLE PRODUTO_DELETED ('+
      'COD        INTEGER DEFAULT 0 NOT NULL,' +
      'NOME       VARCHAR(60) DEFAULT '''','+
      'UNID       VARCHAR(6) DEFAULT '''',' +
      'USUARIO    VARCHAR(10) DEFAULT '''',     '+
      'DATA_DELETED       DATE,' +
      'IGUAL      VARCHAR(40) DEFAULT '''',     '+
      'CODBAR     VARCHAR(20) DEFAULT '''',   '+
      'LOCALIZA   VARCHAR(15) DEFAULT '''',   '+
      'FORNEC     INTEGER DEFAULT 0,        '+
      'FABRIC     INTEGER DEFAULT 0,        '+
      'ALIQUOTA   VARCHAR(3) DEFAULT '''',  '+
      'REFORI     VARCHAR(40) DEFAULT '''', '+
      'CLASSIF    VARCHAR(15) DEFAULT '''', '+
      'APLIC      VARCHAR(40) DEFAULT '''', '+
      'GRUPO      INTEGER DEFAULT 0,      '+
      'SERIE      VARCHAR(1) DEFAULT '''',  '+
      'IS_PIS     VARCHAR(1) DEFAULT '''',  '+
      'EMB        VARCHAR(5) DEFAULT '''',  '+
      'DESC_ATAC  VARCHAR(30) DEFAULT '''', '+
      'P_COMPRA   NUMERIC(13,3) DEFAULT 0,'+
      'P_VENDA    NUMERIC(12,3) DEFAULT 0,'+
      'LUCRO      NUMERIC(7,2) DEFAULT 0, '+
      'QUANT      NUMERIC(12,3) DEFAULT 0,'+
      'ESTOQUE    NUMERIC(10,2) DEFAULT 0,'+
      'DEPOSITO   NUMERIC(12,3) DEFAULT 0,'+
      'COMISSAO   NUMERIC(6,2) DEFAULT 0, '+
      'CREDICM    NUMERIC(9,2) DEFAULT 0, '+
      'BASECRED   NUMERIC(6,2) DEFAULT 0, '+
      'DEBICM     NUMERIC(9,2) DEFAULT 0, '+
      'BASEDEB    NUMERIC(6,2) DEFAULT 0, '+
      'FRETE      NUMERIC(6,2) DEFAULT 0, '+
      'ENCARGOS   NUMERIC(15,2) DEFAULT 0,'+
      'FRACAO     NUMERIC(10,6) DEFAULT 0,'+
      'AGREGADO   NUMERIC(6,2) DEFAULT 0, '+
      'SAL        NUMERIC(13,3) DEFAULT 0,'+
      'SAD        NUMERIC(13,3) DEFAULT 0,'+
      'SUGESTAO   NUMERIC(10,2) DEFAULT 0,'+
      'COMPRA     NUMERIC(10,2) DEFAULT 0,'+
      'P_VENDA1   NUMERIC(10,2) DEFAULT 0,'+
      'DEV_ICM    NUMERIC(5,2) DEFAULT 0, '+
      'FILIAL1    NUMERIC(10,2) DEFAULT 0,'+
      'FILIAL2    NUMERIC(10,2) DEFAULT 0,'+
      'UNID2      VARCHAR(8) DEFAULT '''','+
      'COD_ISPIS  CHAR(3) DEFAULT '''','+
      'EQUIVA     VARCHAR(20) DEFAULT '''',' +
      'OBS        VARCHAR(40) DEFAULT '''','+
      'REFNFE     VARCHAR(25) DEFAULT '''',' +
      'TIPO_ITEM  CHAR(2) DEFAULT '''')');
      dm.IBQuery1.ExecSQL;
      dm.IBQuery1.Transaction.Commit;
    end;

  if NOT verSeExisteTabela('FVMT') then
    begin
      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add('CREATE TABLE FVMT (' +
      'ITEM VARCHAR(100))');
      dm.IBQuery1.ExecSQL;
      dm.IBQuery1.Transaction.Commit;
    end;

  if NOT verSeExisteTabela('ALTERACA') then
    begin
      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add('CREATE TABLE ALTERACA (' +
      'COD INTEGER,' +
      'ALTERACAO VARCHAR(100) DEFAULT '''',' +
      'USUARIO VARCHAR(20) DEFAULT '''','+
      'DATA TIMESTAMP)');
      dm.IBQuery1.ExecSQL;

      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add('CREATE SEQUENCE ALTERACA');
      dm.IBQuery1.ExecSQL;
    end;

  if not VerificaCampoTabela('EXPORTADO','NFE') then
    begin
      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add('ALTER TABLE NFE ' +
      'ADD EXPORTADO SMALLINT  DEFAULT 0');
      dm.IBQuery1.ExecSQL;
      dm.IBQuery1.Transaction.Commit;

      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Text := 'update NFE set EXPORTADO = 0';
      dm.IBQuery1.ExecSQL;
      dm.IBQuery1.Transaction.Commit;
    end;

  if not VerificaCampoTabela('DATA','FVMT') then
    begin
      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add('ALTER TABLE FVMT ' +
      'ADD DATA DATE ' +
      'DEFAULT ' + QuotedStr('01.01.1900S'));
      dm.IBQuery1.ExecSQL;
      dm.IBQuery1.Transaction.Commit;

      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add('ALTER TABLE FVMT ' +
      'ADD ESTADO VARCHAR(2) ' +
      'DEFAULT ' + QuotedStr(''));
      dm.IBQuery1.ExecSQL;
      dm.IBQuery1.Transaction.Commit;

      dm.IBselect.Close;
      dm.IBselect.SQL.Text := 'select * from FVMT';
      dm.IBselect.Open;

      while not dm.IBselect.Eof do
        begin
          dm.IBQuery1.Close;
          dm.IBQuery1.SQL.Text := 'update FVMT set data = :data, estado = :est where item = :item';
          dm.IBQuery1.ParamByName('data').AsDate   := converteDataYYMMDDParaTdate(copy(dm.IBselect.fieldbyname('item').AsString, 1, 6));
          dm.IBQuery1.ParamByName('est').AsString  := IfThen(copy(dm.IBselect.fieldbyname('item').AsString, 21, 2) = '90', 'E', 'C');
          dm.IBQuery1.ParamByName('item').AsString := dm.IBselect.fieldbyname('item').AsString;
          dm.IBQuery1.ExecSQL;

          dm.IBselect.Next;
        end;
    end;

  if not VerificaCampoTabela('COD_ISPIS','PRODUTO') then
    begin
      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add('ALTER TABLE PRODUTO ' +
      'ADD COD_ISPIS CHAR(3) ' +
      'DEFAULT ' + QuotedStr(''));
      dm.IBQuery1.ExecSQL;
    end;

  if not VerificaCampoTabela('UNID','ITEM_ENTRADA') then
    begin
      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add('ALTER TABLE ITEM_ENTRADA ' +
      'ADD UNID VARCHAR(8) ' +
      'DEFAULT ' + QuotedStr(''));
      dm.IBQuery1.ExecSQL;
    end;

  if not VerificaCampoTabela('ICMS','COD_OP') then
    begin
      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add('ALTER TABLE COD_OP ADD ICMS CHAR(1) DEFAULT ' + QuotedStr(''));
      dm.IBQuery1.ExecSQL;
      alt := true;
    end;

  if not VerificaCampoTabela('EQUIVA','PRODUTO') then
    begin
      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add('ALTER TABLE PRODUTO ADD EQUIVA VARCHAR(20) DEFAULT ' + QuotedStr(''));
      try
       dm.IBQuery1.ExecSQL;
      except
      end;
    end;

  if not VerificaCampoTabela('SUFRAMA','REGISTRO') then
    begin
      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add('ALTER TABLE REGISTRO ADD SUFRAMA varchar(40) DEFAULT ' + QuotedStr(''));
      dm.IBQuery1.ExecSQL;
    end;

  if not VerificaCampoTabela('CEP','REGISTRO') then
    begin
      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add('ALTER TABLE REGISTRO ADD CEP varchar(12) DEFAULT ' + QuotedStr(''));
      dm.IBQuery1.ExecSQL;
    end;

  if not VerificaCampoTabela('OBS','PRODUTO') then
    begin
      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add('ALTER TABLE PRODUTO ADD OBS varchar(40) DEFAULT ' + QuotedStr(''));
      dm.IBQuery1.ExecSQL;
    end;

  if not VerificaCampoTabela('USUARIO','VENDA') then
    begin
      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add('ALTER TABLE VENDA ADD USUARIO SMALLINT DEFAULT 0');
      dm.IBQuery1.ExecSQL;
      alt := true;
    end;


  if not VerificaCampoTabela('TOTAL','ITEM_ORCAMENTO') then
    begin
      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add('ALTER TABLE ITEM_ORCAMENTO ADD TOTAL NUMERIC(10,2) DEFAULT 0');
      dm.IBQuery1.ExecSQL;

      dm.IBQuery1.Transaction.Commit;
      
      funcoes.iniciaDataset(dm.ibquery1, 'update item_orcamento set total = quant * p_venda where total is null');
      dm.IBQuery1.ExecSQL;
      dm.IBQuery1.Transaction.Commit;
      
      alt := true;
    end;

  if funcoes.retornaTamanhoDoCampoBD('ies', 'cliente') = 14 then
    begin
      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add('alter table cliente alter ies type VARCHAR(22)');
      dm.IBQuery1.ExecSQL;
    end;

  if funcoes.retornaTamanhoDoCampoBD('ende', 'cliente') = 34 then
    begin
      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add('alter table cliente alter ende type VARCHAR(40)');
      dm.IBQuery1.ExecSQL;
    end;

  if funcoes.retornaTamanhoDoCampoBD('contato', 'fornecedor') = 30 then
    begin
      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add('alter table fornecedor alter contato type VARCHAR(40)');
      dm.IBQuery1.ExecSQL;
    end;

  if funcoes.retornaTamanhoDoCampoBD('NOME', 'COD_OP') = 35 then
    begin
      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add('alter table COD_OP alter NOME type VARCHAR(100)');
      dm.IBQuery1.ExecSQL;
    end;

  if funcoes.retornaTamanhoDoCampoBD('CIDADE', 'FORNECEDOR') = 15 then
    begin
      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add('alter table FORNECEDOR alter CIDADE type VARCHAR(30)');
      dm.IBQuery1.ExecSQL;
    end;

  if funcoes.retornaTamanhoDoCampoBD('valor', 'pgerais') = 10 then
    begin
      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add('alter table pgerais alter valor type VARCHAR(100)');
      dm.IBQuery1.ExecSQL;
    end;

  if funcoes.retornaTamanhoDoCampoBD('nome', 'produto') = 40 then
    begin
      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add('alter table produto alter nome type VARCHAR(60)');
      dm.IBQuery1.ExecSQL;
    end;

  if funcoes.retornaTamanhoDoCampoBD('HISTORICO', 'CONTASPAGAR') = 35 then
    begin
      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add('alter table CONTASPAGAR alter HISTORICO type VARCHAR(60)');
      dm.IBQuery1.ExecSQL;
    end;

  if funcoes.retornaTamanhoDoCampoBD('configu', 'usuario') = 50 then
    begin
      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add('alter table usuario alter configu type VARCHAR(200)');
      dm.IBQuery1.ExecSQL;
    end;

  if funcoes.retornaTamanhoDoCampoBD('REFORI', 'PRODUTO') = 15 then
    begin
      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add('alter table PRODUTO alter REFORI type VARCHAR(40)');
      dm.IBQuery1.ExecSQL;
    end;

  if funcoes.retornaTamanhoDoCampoBD('CID', 'CLIENTE') = 18 then
    begin
      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add('alter table CLIENTE alter CID type VARCHAR(28)');
      dm.IBQuery1.ExecSQL;
    end;

  if funcoes.retornaTamanhoDoCampoBD('codbar', 'item_venda') = 15 then
    begin
      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add('alter table item_venda alter codbar type VARCHAR(20)');
      dm.IBQuery1.ExecSQL;
    end;

  if funcoes.retornaTamanhoDoCampoBD('USU', 'USUARIO') = 10 then
    begin
      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add('alter table USUARIO alter USU type VARCHAR(13)');
      dm.IBQuery1.ExecSQL;

      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add('alter table USUARIO alter SENHA type VARCHAR(13)');
      dm.IBQuery1.ExecSQL;
    end;

  if not funcoes.verificaTamnhoCampoBD('produto', 'codbar', 20) then
    begin
      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add('alter table produto alter codbar type VARCHAR(20)');
      dm.IBQuery1.ExecSQL;
    end;

  if retornaTipoDoCampo('grupo', 'produto') = 'VARCHAR' then
    begin
      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Text := 'update produto set grupo = ''0'' where (grupo = '''') or (grupo is null) ';
      dm.IBQuery1.ExecSQL;
      dm.IBQuery1.Transaction.Commit;

      {dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Text := 'alter table PRODUTO alter GRUPO type integer';
      dm.IBQuery1.ExecSQL;
      dm.IBQuery1.Transaction.Commit;}
    end;

   if not VerificaCampoTabela('MENS','USUARIO') then
     begin
       dm.IBQuery1.Close;
       dm.IBQuery1.SQL.Text := 'ALTER TABLE USUARIO ' +
       'ADD MENS VARCHAR(40) ' +
       'DEFAULT ''* * *   NAO  TEM  VALOR  FISCAL    * * *'' ';
       dm.IBQuery1.ExecSQL;
     end;

  if not VerificaCampoTabela('ESTADO','NFE') then
     begin
       dm.IBQuery1.Close;
       dm.IBQuery1.SQL.Text := 'ALTER TABLE NFE ' +
       'ADD ESTADO VARCHAR(2) ' +
       'DEFAULT ''E'' ';
       dm.IBQuery1.ExecSQL;
       dm.IBQuery1.Transaction.Commit;

       dm.IBQuery1.Close;
       dm.IBQuery1.SQL.Text := 'update nfe set estado = ''E''';
       dm.IBQuery1.ExecSQL;
     end;

  if not VerificaCampoTabela('REFNFE','PRODUTO') then
     begin
       dm.IBQuery1.Close;
       dm.IBQuery1.SQL.Text := 'ALTER TABLE PRODUTO ' +
       'ADD REFNFE VARCHAR(25) ' +
       'DEFAULT '''' ';
       dm.IBQuery1.ExecSQL;
     end;

  if not VerificaCampoTabela('FORNEC','ITEM_ENTRADA') then
     begin
       dm.IBQuery1.Close;
       dm.IBQuery1.SQL.Text := 'ALTER TABLE ITEM_ENTRADA ' +
       'ADD FORNEC SMALLINT ' +
       'DEFAULT 0 ';
       dm.IBQuery1.ExecSQL;
       dm.IBQuery1.Transaction.Commit;

       dm.IBQuery1.Close;
       dm.IBQuery1.SQL.Text := 'update item_entrada i set fornec = (select fornec  from entrada f where i.nota = f.nota)';
       dm.IBQuery1.ExecSQL;
     end;

   if not VerificaCampoTabela('COD_ISPIS','COD_OP') then
     begin
       dm.IBQuery1.Close;
       dm.IBQuery1.SQL.Text := 'ALTER TABLE COD_OP ' +
       'ADD COD_ISPIS VARCHAR(3) ' +
       'DEFAULT '''' ';
       dm.IBQuery1.ExecSQL;
       dm.IBQuery1.Transaction.Commit;
     end;

  if NOT verSeExisteTabela('OS_VENDA') then
    begin
      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add('CREATE TABLE OS_VENDA (' +
      'NOTA INTEGER,' +
      'TOTAL NUMERIC(10,2),'  +
      'DATA DATE,' +
      'CLIENTE INTEGER)');
      dm.IBQuery1.ExecSQL;
    end;

  if NOT verSeExisteTabela('ACERTO') then
    begin
      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add('CREATE TABLE ACERTO (' +
      'ACERTO_SEQ INTEGER NOT NULL,' +
      'DOCUMENTO INTEGER DEFAULT 0 NOT NULL,' +
      'DATA DATE DEFAULT ''01.01.1900'','  +
      'CODIGO INTEGER DEFAULT 0 NOT NULL,' +
      'NOME VARCHAR(40) DEFAULT '''',' +
      'QUANT NUMERIC(10,3) DEFAULT 0,' +
      'DEPOSITO NUMERIC(10,3) DEFAULT 0,' +
      'USUARIO INTEGER DEFAULT 0,' +
      'DESCRICAO VARCHAR(20) DEFAULT '''')');
      dm.IBQuery1.ExecSQL;
      dm.IBQuery1.Transaction.Commit;

      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Text := 'alter table ACERTO ' +
      'add constraint PK_ACERTO ' +
      'primary key (ACERTO_SEQ)';
      dm.IBQuery1.ExecSQL;

      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add('CREATE SEQUENCE ACERTO');
      dm.IBQuery1.ExecSQL;

      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add('CREATE SEQUENCE ACERTO_SEQ');
      dm.IBQuery1.ExecSQL;
      dm.IBQuery1.Transaction.Commit;
    end;

  if NOT verSeExisteTabela('SPED_REDUCAOZ') then
    begin
      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Text := ('CREATE TABLE SPED_REDUCAOZ (' +
      'COD INTEGER NOT NULL,' +
      'DATA DATE,' +
      'ECF INTEGER NOT NULL,' +
      'CONT_REINICIO INTEGER,' +
      'CONT_REDUCAOZ INTEGER,' +
      'CONT_OP INTEGER,' +
      'TOT_GERAL NUMERIC(15,2),' +
      'TOT_CANC NUMERIC(15,2),' +
      'TOT_ALIQ01 NUMERIC(15,2),' +
      'TOT_ALIQ02 NUMERIC(15,2),' +
      'TOT_ALIQ03 NUMERIC(15,2),' +
      'TOT_ALIQ04 NUMERIC(15,2),' +
      'TOT_ALIQ05 NUMERIC(15,2),' +
      'TOT_ALIQ06 NUMERIC(15,2),' +
      'TOT_ALIQ07 NUMERIC(15,2),' +
      'TOT_ALIQ08 NUMERIC(15,2),' +
      'TOT_DESC NUMERIC(15,2),' +
      'TOT_FF NUMERIC(15,2),' +
      'TOT_II NUMERIC(15,2),' +
      'TOT_NN NUMERIC(15,2),' +
      'VENDABRUTA NUMERIC(13, 2) )');

      dm.IBQuery1.ExecSQL;
      dm.IBQuery1.Transaction.Commit;

      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add('alter table SPED_REDUCAOZ ' +
      'add constraint PK_SPED_REDUCAOZ ' +
      'primary key (COD)');
      dm.IBQuery1.ExecSQL;
      dm.IBQuery1.Transaction.Commit;

      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add('CREATE SEQUENCE SPED_REDUCAOZ');
      dm.IBQuery1.ExecSQL;
      dm.IBQuery1.Transaction.Commit;
    end;

    if not VerificaCampoTabela('EXPORTADO','SPED_REDUCAOZ') then
    begin
      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add('ALTER TABLE SPED_REDUCAOZ ' +
      'ADD EXPORTADO SMALLINT  DEFAULT 0');
      dm.IBQuery1.ExecSQL;
      dm.IBQuery1.Transaction.Commit;

      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Text := 'update SPED_REDUCAOZ set EXPORTADO = 0';
      dm.IBQuery1.ExecSQL;
      dm.IBQuery1.Transaction.Commit;
    end;
  

  if not VerificaCampoTabela('VENDABRUTA','SPED_REDUCAOZ') then
     begin
       dm.IBQuery1.Close;
       dm.IBQuery1.SQL.Text := 'ALTER TABLE SPED_REDUCAOZ ' +
       'ADD VENDABRUTA NUMERIC(13, 2) ' +
       'DEFAULT 0';
       dm.IBQuery1.ExecSQL;
       dm.IBQuery1.Transaction.Commit;

       dm.IBQuery1.Close;
       dm.IBQuery1.SQL.Text := 'update SPED_REDUCAOZ set VENDABRUTA = TOT_CANC + TOT_ALIQ01 + ' +
       'TOT_ALIQ02 + TOT_ALIQ03 + TOT_ALIQ04 + TOT_ALIQ05 + TOT_ALIQ06 + TOT_ALIQ07 + TOT_ALIQ08 + ' +
       'TOT_FF + TOT_II + TOT_NN';
       dm.IBQuery1.ExecSQL;
     end;

  if NOT verSeExisteTabela('ECF') then
    begin
      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add('CREATE TABLE ECF (' +
      'COD INTEGER NOT NULL,' +
      'MODELO VARCHAR(30),'  +
      'SERIAL VARCHAR(30))');
      dm.IBQuery1.ExecSQL;
      dm.IBQuery1.Transaction.Commit;

      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add('alter table ECF ' +
      ' add constraint PK_ECF ' +
      'primary key (COD)');
      dm.IBQuery1.ExecSQL;
      dm.IBQuery1.Transaction.Commit;

      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add('CREATE SEQUENCE ECF');
      dm.IBQuery1.ExecSQL;
    end;

  if NOT verSeExisteTabela('ENTRADA_TEMP') then
    begin
      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add('CREATE TABLE ENTRADA_TEMP (' +
      'NOTA INTEGER NOT NULL,' +
      'FORNEC INTEGER NOT NULL,'  +
      'DATA DATE,' +
      'CHEGADA DATE,' +
      'TOTAL NUMERIC(10,2),' +
      'CHAVE VARCHAR(50))');
      dm.IBQuery1.ExecSQL;
      dm.IBQuery1.Transaction.Commit;

      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add('alter table ENTRADA_TEMP ' +
      ' add constraint PK_ENTRADA_TEMP ' +
      'primary key (NOTA,FORNEC)');
      dm.IBQuery1.ExecSQL;
    end;
  if NOT verSeExisteTabela('ITEM_ENTRADA_TEMP') then
    begin
      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add('CREATE TABLE ITEM_ENTRADA_TEMP (' +
      'NOTA INTEGER NOT NULL,' +
      'FORNEC INTEGER NOT NULL,'  +
      'NOME_F VARCHAR(40),' +
      'NOME_E VARCHAR(40),' +
      'P_VENDA_F NUMERIC(10,2),' +
      'P_VENDA_E NUMERIC(10,2),' +
      'P_VENDA_A NUMERIC(10,2),' +
      'LUCRO NUMERIC(6,2),' +
      'QUANT NUMERIC(10,3),' +
      'QUANT_E NUMERIC(10,3),' +
      'UNID_F VARCHAR(8),' +
      'UNID_E VARCHAR(8),' +
      'UNID_V VARCHAR(8),' +
      'ALIQ VARCHAR(3),' +
      'CODBAR_F VARCHAR(15),' +
      'CODBAR_E VARCHAR(15),' +
      'REF_ORIGI VARCHAR(20),' +
      'REF_FORNEC VARCHAR(30),' +
      'NCM VARCHAR(10),' +
      'COD INTEGER)');
      dm.IBQuery1.ExecSQL;
      dm.IBQuery1.Transaction.Commit;

      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add('alter table ITEM_ENTRADA_TEMP ' +
      ' add constraint PK_ITEM_ENTRADA_TEMP ' +
      ' primary key (NOTA,FORNEC)');
      dm.IBQuery1.ExecSQL;
    end;

  if NOT verSeExisteTabela('OS_ITENS') then
    begin
      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add('CREATE TABLE OS_ITENS (' +
      'NOTA INTEGER,' +
      'COD INTEGER,'  +
      'QUANT NUMERIC(10,3),' +
      'P_VENDA NUMERIC(10,2),' +
      'TOTAL NUMERIC(10,2))');
      dm.IBQuery1.ExecSQL;
    end;

  if NOT verSeExisteTabela('NFCE') then
   begin
     dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add('CREATE TABLE NFCE (' +
      'CHAVE VARCHAR(50) NOT NULL,' +
      'NOTA INTEGER DEFAULT 0, '+
      'CLIENTE INTEGER DEFAULT 0,' +
      'DATA DATE, ' +
      'ADIC VARCHAR(200) DEFAULT '''')');
      dm.IBQuery1.ExecSQL;
      dm.IBQuery1.Transaction.Commit;

      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add('alter table NFCE' +
      ' add constraint PK_NFCE ' +
      'primary key (CHAVE)');
      dm.IBQuery1.ExecSQL;
      dm.IBQuery1.Transaction.Commit;
   end;

  if not VerificaCampoTabela('EXPORTADO','NFCE') then
    begin
      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add('alter table NFCE ADD EXPORTADO SMALLINT DEFAULT 0');
      dm.IBQuery1.ExecSQL;
      dm.IBQuery1.Transaction.Commit;

      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Text := 'update NFCE set EXPORTADO = 0';
      dm.IBQuery1.ExecSQL;
      dm.IBQuery1.Transaction.Commit;
    end;

  if NOT verSeExisteTabela('JUSTIFICATIVA') then
    begin
      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add('CREATE TABLE JUSTIFICATIVA (' +
      'NOTA INTEGER DEFAULT 0' +
      ',JUSTIFICATIVA VARCHAR(40) DEFAULT '+ QuotedStr('') +
      ',DATA DATE ' +
      ', valor numeric(8, 2) ' +
      ', volumes integer)');
      dm.IBQuery1.ExecSQL;
    end;

  if NOT verSeExisteTabela('SERVICO') then
    begin
      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add('CREATE TABLE SERVICO (' +
      'COD INTEGER DEFAULT 0 NOT NULL,' +
      'DATA DATE DEFAULT ''01.01.1900'',' +
      'NOME VARCHAR(35) DEFAULT '''',' +
      'USUARIO SMALLINT DEFAULT 0,' +
      'CLIENTE INTEGER DEFAULT 0,' +
      'VENDA INTEGER DEFAULT 0,' +
      'EQUIP VARCHAR(40) DEFAULT '''',' +
      'MARCA VARCHAR(15) DEFAULT '''',' +
      'MODELO VARCHAR(15) DEFAULT '''',' +
      'SERIE VARCHAR(20) DEFAULT '''',' +
      'DEFEITO VARCHAR(40) DEFAULT '''',' +
      'TECNICO VARCHAR(15) DEFAULT '''',' +
      'VENDEDOR SMALLINT DEFAULT 0,' +
      'OBS VARCHAR(50) DEFAULT '''',' +
      'SAIDA DATE DEFAULT ''01.01.1900'',' +
      'SITUACAO CHAR(1) DEFAULT '''',' +
      'DIAG VARCHAR(30) DEFAULT '''',' +
      'PARECER VARCHAR(80) DEFAULT '''',' +
      'H_ENT TIME DEFAULT ''00:00:00'',' +
      'H_SAI TIME DEFAULT ''00:00:00'',' +
      'PAGO NUMERIC(10,2) DEFAULT 0,' +
      'ORDEM VARCHAR(7) DEFAULT '''')');
      dm.IBQuery1.ExecSQL;
      dm.IBQuery1.Transaction.Commit;

      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add('alter table SERVICO ' +
      'add constraint PK_SERVICO ' +
      'primary key (COD)');
      dm.IBQuery1.ExecSQL;
      dm.IBQuery1.Transaction.Commit;

      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add('CREATE SEQUENCE SERVICO');
      dm.IBQuery1.ExecSQL;

      dm.IBQuery1.Transaction.Commit;
    end;

  if NOT verSeExisteTabela('MOV_FRE') then
    begin
      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add('CREATE TABLE MOV_FRE (' +
      'NUMDOC INTEGER NOT NULL,' +
      'TRANSP INTEGER DEFAULT 0,' +
      'DATA DATE DEFAULT ''01.01.1900'',' +
      'CHEGADA DATE DEFAULT ''01.01.1900'',' +
      'SERIE CHAR(1) DEFAULT '''',' +
      'IND_FRETE CHAR(1) DEFAULT '''',' +
      'MOD_FRETE CHAR(2) DEFAULT '''',' +
      'COD_CFOP VARCHAR(6) DEFAULT '''',' +
      'VLR_TOTAL NUMERIC(10,2) DEFAULT 0,' +
      'VLR_DESC NUMERIC(10,2) DEFAULT 0,' +
      'VLR_SERV NUMERIC(10,2) DEFAULT 0,' +
      'VLR_BC_ICM NUMERIC(10,2) DEFAULT 0,' +
      'VLR_ICMS NUMERIC(10,2) DEFAULT 0,' +
      'VLR_NT NUMERIC(10,2) DEFAULT 0,' +
      'USUARIO SMALLINT DEFAULT 0)');
      dm.IBQuery1.ExecSQL;
      dm.IBQuery1.Transaction.Commit;


      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add('alter table MOV_FRE' +
      ' add constraint PK_MOV_FRE ' +
      ' primary key (NUMDOC)');
      dm.IBQuery1.ExecSQL;
      dm.IBQuery1.Transaction.Commit;
    end;

  if not VerificaCampoTabela('CHAVECTE','MOV_FRE') then
     begin
       dm.IBQuery1.Close;
       dm.IBQuery1.SQL.Text := 'ALTER TABLE MOV_FRE ' +
       'ADD CHAVECTE VARCHAR(55) ' +
       'DEFAULT '''' ';
       dm.IBQuery1.ExecSQL;
       dm.IBQuery1.Transaction.Commit;
     end;  

  if not VerificaCampoTabela('VENDA','SERVICO') then
    begin
      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add('alter table SERVICO ADD VENDA INTEGER DEFAULT 0');
      dm.IBQuery1.ExecSQL;
    end;

  if not VerificaCampoTabela('COD_MUN','TRANSPORTADORA') then
    begin
      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add('alter table TRANSPORTADORA ADD COD_MUN INTEGER DEFAULT 0');
      dm.IBQuery1.ExecSQL;
    end;

  if not verSeExisteTabela('UNID') then
    begin
      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add('CREATE TABLE UNID (' +
      'NOME VARCHAR(8) NOT NULL,' +
      'MULTIPLO INTEGER DEFAULT 1)');
      dm.IBQuery1.ExecSQL;

      dm.IBQuery1.Transaction.Commit;

      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add('alter table UNID' +
      ' add constraint PK_UNID' +
      ' primary key (NOME);');
      dm.IBQuery1.ExecSQL;
    end;  

  if not VerificaCampoTabela('UNID_ENT','UNID') then
    begin
      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add('alter table UNID ADD UNID_ENT VARCHAR(6) DEFAULT ' + QuotedStr(''));
      dm.IBQuery1.ExecSQL;
      dm.IBQuery1.Transaction.Commit;
    end;

  if not VerificaCampoTabela('UNID_SAI','UNID') then
    begin
      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add('alter table UNID ADD UNID_SAI VARCHAR(6) DEFAULT ' + QuotedStr(''));
      dm.IBQuery1.ExecSQL;
      dm.IBQuery1.Transaction.Commit;

      unid := TStringList.Create;

      unid.Add('UN=UN');
      unid.Add('PC=PC');
      unid.Add('KG=KG');
      unid.Add('PR=PR');
      unid.Add('PAR=PAR');
      unid.Add('GL=GL');
      unid.Add('M=M');
      unid.Add('M2=M2');
      unid.Add('M3=M3');
      unid.Add('LT=LT');
      unid.Add('CT=CT');
      unid.Add('FR=FR');
      unid.Add('L=L');
      unid.Add('SC=SC');
      unid.Add('CX=CX');
      unid.Add('JG=JG');
      unid.Add('CX6=CX6');
      unid.Add('CX12=UN');
      unid.Add('CX24=UN');
      unid.Add('CX48=UN');

      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add('delete from unid');
      dm.IBQuery1.ExecSQL;
      dm.IBQuery1.Transaction.Commit;

      fim := unid.Count -1;
      for i := 0 to fim do
        begin
          tmp := StrToIntDef(funcoes.StrNum(unid.Names[i]), 1);
          if tmp = 0 then tmp := 1;

          dm.IBQuery1.Close;
          dm.IBQuery1.SQL.Text := 'update or insert into unid(nome, multiplo, unid_ent, unid_sai) values(:nome, :multiplo, :unid_ent, :unid_sai) matching (nome)';
          dm.IBQuery1.ParamByName('nome').AsString     := unid.Names[i];
          dm.IBQuery1.ParamByName('multiplo').AsInteger := tmp;
          dm.IBQuery1.ParamByName('unid_ent').AsString := unid.Names[i];
          dm.IBQuery1.ParamByName('unid_sai').AsString := unid.ValueFromIndex[i];
          dm.IBQuery1.ExecSQL;
        end;

      dm.IBQuery1.Transaction.Commit;
    end;

  if NOT verSeExisteTabela('PAISES') then
    begin
      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add('CREATE TABLE PAISES (' +
      'COD INTEGER NOT NULL, ' +
      'NOME VARCHAR(50))');
      dm.IBQuery1.ExecSQL;
      dm.IBQuery1.Transaction.Commit;

      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add('alter table PAISES ' +
      'add constraint PK_PAISES ' +
      'primary key (COD)');
      dm.IBQuery1.ExecSQL;
      dm.IBQuery1.Transaction.Commit;
    end;

  atualizaCFOPs();  

  //copia os dados de paises para o bd do control
  funcoes.iniciaDataset(dm.ibselect, 'select cod from paises');
  dm.IBselect.Open;
  dm.IBselect.FetchAll;

  if dm.IBselect.RecordCount <= 10 then
    begin
      if FileExists(caminhoEXE_com_barra_no_final + 'JS000066.DAT') then
        begin
          arq := TStringList.Create;
          arq.LoadFromFile(caminhoEXE_com_barra_no_final + 'JS000066.DAT');
          tmp := arq.Count - 1;

          for i := 0 to tmp do
            begin
              if trim(copy(arq[i], 1, pos(' ', arq[i]))) <> '' then
                begin
                  dm.IBQuery1.Close;
                  dm.IBQuery1.SQL.Clear;
                  dm.IBQuery1.SQL.Add('update or insert into PAISES(cod, nome) values(:cod, :nome)');
                  dm.IBQuery1.ParamByName('cod').AsString := trim(copy(arq[i], 1, pos(' ', arq[i])));
                  dm.IBQuery1.ParamByName('nome').AsString := trim(copy(arq[i], pos(' ', arq[i]) + 1, length(arq[i])));
                  dm.IBQuery1.ExecSQL;
                end;
            end;
          arq.Free;
        end;
    end;

  dm.IBselect.Close;

  if not verSeExisteTabela('CODBARRAS') then
    begin
      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add('CREATE TABLE CODBARRAS (' +
      'COD INTEGER DEFAULT 0 NOT NULL,' +
      'CODBAR VARCHAR(20) DEFAULT '+ QuotedStr('') +' NOT NULL);');
      dm.IBQuery1.ExecSQL;

      dm.IBQuery1.Transaction.Commit;

      {dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add('alter table CODBARRAS' +
      ' add constraint PK_CODBARRAS' +
      ' primary key (COD,CODBAR);');
      dm.IBQuery1.ExecSQL;
      dm.IBQuery1.Transaction.Commit;}
    end;

  if funcoes.retornaTamanhoDoCampoBD('CODBAR', 'CODBARRAS') = 13 then
    begin
      try
        dm.IBQuery1.Close;
        dm.IBQuery1.SQL.Clear;
        dm.IBQuery1.SQL.Add('alter table CODBARRAS' +
        ' drop constraint PK_CODBARRAS');
        dm.IBQuery1.ExecSQL;
        dm.IBQuery1.Transaction.Commit;
      except
      end;  

      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add('alter table CODBARRAS alter CODBAR type VARCHAR(20)');
      dm.IBQuery1.ExecSQL;
      dm.IBQuery1.Transaction.Commit;

      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add('alter table CODBARRAS' +
      ' add constraint PK_CODBARRAS1' +
      ' primary key (COD,CODBAR);');
      dm.IBQuery1.ExecSQL;
      dm.IBQuery1.Transaction.Commit;
    end;

  if not verSeExisteTabela('CPD') then
    begin
      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add('CREATE TABLE CPD (' +
      'DD VARCHAR(8),' +
      'SIT SMALLINT)');
      dm.IBQuery1.ExecSQL;
    end
   else
     begin
       if not VerificaCampoTabela('DNFC','CPD') then
         begin
           dm.IBQuery1.Close;
           dm.IBQuery1.SQL.Clear;
           dm.IBQuery1.SQL.Add('alter table CPD alter DD type varchar(100)');
           dm.IBQuery1.ExecSQL;

           dm.IBQuery1.Close;
           dm.IBQuery1.SQL.Clear;
           dm.IBQuery1.SQL.Add('ALTER TABLE CPD ADD DNFC varchar(100) DEFAULT ' + QuotedStr(''));
           dm.IBQuery1.ExecSQL;

           dm.IBQuery1.Close;
           dm.IBQuery1.SQL.Clear;
           dm.IBQuery1.SQL.Add('ALTER TABLE CPD ADD DD1 varchar(100) DEFAULT ' + QuotedStr(''));
           dm.IBQuery1.ExecSQL;

           dm.IBQuery1.Close;
           dm.IBQuery1.SQL.Clear;
           dm.IBQuery1.SQL.Add('ALTER TABLE CPD ADD CD smallint');
           dm.IBQuery1.ExecSQL;
         end;
     end;

  if not verSeExisteTabela('SPEDCONTADOR') then
    begin
      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add('CREATE TABLE SPEDCONTADOR (' +
      'COD INTEGER NOT NULL,' +
      'NOME VARCHAR(50) DEFAULT '+ QuotedStr('') +',' +
      'CPF VARCHAR(14) DEFAULT '+ QuotedStr('') +',' +
      'CNPJ VARCHAR(22) DEFAULT '+ QuotedStr('') +',' +
      'ENDE VARCHAR(35) DEFAULT '+ QuotedStr('') +',' +
      'NUMERO VARCHAR(10) DEFAULT '+ QuotedStr('') +',' +
      'EST VARCHAR(3) DEFAULT '+ QuotedStr('') +',' +
      'CID VARCHAR(18) DEFAULT '+ QuotedStr('') +',' +
      'CEP VARCHAR(10) DEFAULT '+ QuotedStr('') +',' +
      'CRC VARCHAR(20) DEFAULT '+ QuotedStr('') +',' +
      'FONE VARCHAR(13) DEFAULT '+ QuotedStr('') +',' +
      'FAX VARCHAR(13) DEFAULT '+ QuotedStr('') +',' +
      'EMAIL VARCHAR(50) DEFAULT '+ QuotedStr('') +',' +
      'BAIRRO VARCHAR(30) DEFAULT '+ QuotedStr('') +')');
      dm.IBQuery1.ExecSQL;

      dm.IBQuery1.Transaction.Commit;

      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add('alter table SPEDCONTADOR ' +
      'add constraint PK_SPEDCONTADOR ' +
      'primary key (COD)');
      dm.IBQuery1.ExecSQL;

      alt := true;
    end;

  if not verSeExisteTabela('SPEDDADOSADIC') then
    begin
      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add('CREATE TABLE SPEDDADOSADIC (NOTA INTEGER NOT NULL,' +
      'FORNEC INTEGER NOT NULL,'+
      'TIPO SMALLINT,' +
      'SERIE SMALLINT,' +
      'CFOP INTEGER,' +
      'TIPOFRETE SMALLINT,' +
      'TOTSEG NUMERIC(10,2),' +
      'TOTDESC NUMERIC(10,2),' +
      'TOTDESCNT NUMERIC(10,2),' +
      'TOTDESPACES NUMERIC(10,2),' +
      'TOTPIS NUMERIC(10,2),' +
      'TOTCONFINS NUMERIC(10,2),' +
      'CREDICMS NUMERIC(10,2),' +
      'CHAVENFE VARCHAR(45),' + 
      'TOTFRETE NUMERIC(10,2))');
      dm.IBQuery1.ExecSQL;

      dm.IBQuery1.Transaction.Commit;

      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add('alter table SPEDDADOSADIC ' +
      'add constraint PK_SPEDDADOSADIC ' +
      'primary key (NOTA,FORNEC)');
      dm.IBQuery1.ExecSQL;

      alt := true;
    end;

  dm.IBQuery1.Close;
  dm.IBQuery1.SQL.Clear;
  dm.IBQuery1.SQL.Add('select max(cod) as cod from pgerais');
  dm.IBQuery1.Open;
  tmp := StrToIntDef(dm.IBQuery1.fieldbyname('cod').asstring, 0);
  if tmp <> 0 then
    begin
      tmp := tmp + 1;
      fim := pger.Count -1;
      for i := tmp to 100 do
        begin
          dm.IBQuery1.Close;
          dm.IBQuery1.SQL.Clear;
          dm.IBQuery1.SQL.Add('insert into pgerais(cod, valor) values(:cod, :valor)');
          dm.IBQuery1.ParamByName('cod').AsInteger := i;
          dm.IBQuery1.ParamByName('valor').AsString := pger.Values[IntToStr(i)];
          dm.IBQuery1.ExecSQL;

          alt := true;
        end;
    end;

  dm.IBselect.Close;
  dm.IBselect.SQL.Text := 'select max(cod) as venda from contaspagar';

  try
    dm.IBselect.Open;
    tmp := 1;
  except
    tmp := -999;
  end;  

  if tmp = 1 then
    begin
      tmp := dm.IBselect.fieldbyname('venda').AsInteger;
      if tmp > StrToInt(Incrementa_Generator('small', 0)) then
        begin
          reStartGenerator('small', tmp + 1);
        end;
    end;

  dm.IBselect.Close;
  dm.IBselect.SQL.Text := 'select max(cod) as venda from vendedor';

  try
    dm.IBselect.Open;
    tmp := 1;
  except
    tmp := -999;
  end;  

  if tmp = 1 then
    begin
      tmp := dm.IBselect.fieldbyname('venda').AsInteger;
      if tmp > StrToInt(Incrementa_Generator('vendedor', 0)) then
        begin
          reStartGenerator('vendedor', tmp + 1);
        end;
    end;

  dm.IBselect.Close;   

  if not verificaSeExisteIndiceTrueExiste('CONTASPAGAR_IDX1') then
    begin
      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add('CREATE DESCENDING INDEX CONTASPAGAR_IDX1' +
      ' ON CONTASPAGAR (DATA)');
      dm.IBQuery1.ExecSQL;
    end;

  {if not verificaSeExisteIndiceTrueExiste('VENDAS_IDX2') then
    begin
      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add('CREATE INDEX VENDAS_IDX2' +
      ' ON VENDA (DATA)');
      dm.IBQuery1.ExecSQL;
    end;}

  {if not verificaSeExisteIndiceTrueExiste('ITEM_VENDA_IDX1') then
    begin
      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add('CREATE INDEX ITEM_VENDA_IDX1' +
      ' ON ITEM_VENDA (DATA)');
      dm.IBQuery1.ExecSQL;
    end;}

  if not verificaSeExisteIndiceTrueExiste('PRODUTO_IDX3') then
    begin
      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add('CREATE INDEX PRODUTO_IDX3' +
      ' ON PRODUTO (REFORI)');
      dm.IBQuery1.ExecSQL;
    end;

  {if not verificaSeExisteIndiceTrueExiste('ITEM_VENDA_IDX2') then
    begin
      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add('CREATE INDEX ITEM_VENDA_IDX2' +
      ' ON ITEM_VENDA (NOTA, COD)');
      dm.IBQuery1.ExecSQL;
    end;}

  if not verificaSeExisteIndiceTrueExiste('CONTASPAGAR_IDX2') then
    begin
      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add('CREATE DESCENDING INDEX CONTASPAGAR_IDX2 ' +
      'ON CONTASPAGAR (VENCIMENTO)');
      dm.IBQuery1.ExecSQL;
    end;

  if not verificaSeExisteIndiceTrueExiste('NFCE_IDX2') then
    begin
      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add('CREATE INDEX NFCE_IDX2 ON NFCE (adic)' );
      dm.IBQuery1.ExecSQL;
    end;

  if not verificaSeExisteIndiceTrueExiste('CONTASRECEBER_IDX1') then
    begin
      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add('CREATE INDEX CONTASRECEBER_IDX1 ' +
      'ON CONTASRECEBER (VENCIMENTO)');
      dm.IBQuery1.ExecSQL;
    end;

  try
    dm.IBQuery1.Close;
    dm.IBQuery1.SQL.Text := ('update produto set p_compra = p_venda / 2 where p_compra < 0');
    dm.IBQuery1.ExecSQL;

    try
      if retornaEscalaDoCampo('p_venda', 'item_venda') <> 3 then
        begin
          dm.IBQuery1.Close;
          dm.IBQuery1.SQL.Clear;
          dm.IBQuery1.SQL.Add('ALTER TABLE item_venda ALTER p_venda TYPE NUMERIC(12,3)');
          dm.IBQuery1.ExecSQL;
        end;
     except
       on e:exception do begin
         MessageDlg('Erro1: ' + e.Message, mtError, [mbok], 1);
       end;
     end;


    if retornaTipoDoCampo('cancelado', 'venda') <> 'SMALLINT' then
      begin
        dm.IBQuery1.Close;
        dm.IBQuery1.SQL.Clear;
        dm.IBQuery1.SQL.Add('alter table venda alter cancelado type smallint');
        dm.IBQuery1.ExecSQL;
      end;  

    if retornaTamanhoDoCampoBD('crc', 'venda') <> 9 then
      begin
        dm.IBQuery1.Close;
        dm.IBQuery1.SQL.Clear;
        dm.IBQuery1.SQL.Add('alter table venda alter CRC type VARCHAR(9)');
        dm.IBQuery1.ExecSQL;
      end;

    if retornaTamanhoDoCampoBD('nome', 'REGISTRO') <> 60 then
      begin
        dm.IBQuery1.Close;
        dm.IBQuery1.SQL.Clear;
        dm.IBQuery1.SQL.Add('alter table REGISTRO alter nome type varchar(60)');
        dm.IBQuery1.ExecSQL;
      end;  

  except
  end;

//jss. cria tabelas para o bloco K
  //cria tabela producao_estoque
  if NOT verSeExisteTabela('PRODUCAO_ESTOQUE') then
    begin
      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Text := 'CREATE TABLE PRODUCAO_ESTOQUE (' +
      'ano_mes VARCHAR(6) DEFAULT '''' NOT NULL, ' +
      'cod integer DEFAULT 0 NOT NULL, ' +
  	  'quant NUMERIC(10,2) DEFAULT 0)' ;

      dm.IBQuery1.ExecSQL;
      dm.IBQuery1.Transaction.Commit;
      dm.IBQuery1.Close;

      dm.IBQuery1.SQL.Text := 'alter table PRODUCAO_ESTOQUE ' +
      'add constraint PK_producao_estoque ' +
      'primary key (ano_mes, cod)';
      dm.IBQuery1.ExecSQL;
      dm.IBQuery1.Transaction.Commit;
    end;

  if not VerSeExisteGeneratorPeloNome('PRODUCAO_ESTOQUE') then
    begin
      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add('CREATE SEQUENCE PRODUCAO_ESTOQUE');
      dm.IBQuery1.ExecSQL;
      alt := true;
    end;

  //cria tabela producao_mov
  if NOT verSeExisteTabela('PRODUCAO_MOV') then
    begin
      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Text := 'CREATE TABLE PRODUCAO_MOV (' +
      'doc integer DEFAULT 0 NOT NULL, ' +
      'data DATE DEFAULT ' + QuotedStr('01.01.1900') + ', ' +
      'cod integer DEFAULT 0 NOT NULL, ' +
      'cod_insumo integer DEFAULT 0 NOT NULL, ' +
      'ano_mes VARCHAR(6) DEFAULT '''' NOT NULL, ' +
	    'quant NUMERIC(10,2) DEFAULT 0)' ;

      dm.IBQuery1.ExecSQL;
      dm.IBQuery1.Transaction.Commit;
      dm.IBQuery1.Close;
	  
      dm.IBQuery1.SQL.Text := 'alter table PRODUCAO_MOV ' +
      'add constraint PK_producao_mov ' +
      'primary key (doc)';
      dm.IBQuery1.ExecSQL;
      dm.IBQuery1.Transaction.Commit;
    end;

  if not VerSeExisteGeneratorPeloNome('PRODUCAO_MOV') then
    begin
      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add('CREATE SEQUENCE PRODUCAO_MOV');
      dm.IBQuery1.ExecSQL;
      alt := true;
    end;

  //cria tabela producao_cad_ins
  if NOT verSeExisteTabela('PRODUCAO_CAD_INS') then
    begin
      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Text := 'CREATE TABLE PRODUCAO_CAD_INS (' +
      'cod integer DEFAULT 0 NOT NULL, ' +
      'cod_insumo integer DEFAULT 0 NOT NULL, ' +
  	  'quant NUMERIC(4,2) DEFAULT 0, ' +
	    'perda NUMERIC(4,2) DEFAULT 0)' ;

      dm.IBQuery1.ExecSQL;
      dm.IBQuery1.Transaction.Commit;
      dm.IBQuery1.Close;

      dm.IBQuery1.SQL.Text := 'alter table PRODUCAO_CAD_INS ' +
      'add constraint PK_producao_cad_ins ' +
      'primary key (cod, cod_insumo)';
      dm.IBQuery1.ExecSQL;
      dm.IBQuery1.Transaction.Commit;
    end;

  if not VerSeExisteGeneratorPeloNome('PRODUCAO_CAD_INS') then
    begin
      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add('CREATE SEQUENCE PRODUCAO_CAD_INS');
      dm.IBQuery1.ExecSQL;
      alt := true;
    end;
//jss. fim bloco que cria tabelas bloco K



  if dm.IBQuery1.Transaction.InTransaction then dm.IBQuery1.Transaction.Commit;

  pger.Free;
  DeleteFile(caminhoEXE_com_barra_no_final + 'bd0.fdb');
  DeleteFile(caminhoEXE_com_barra_no_final + 'exec.bat');
  DeleteFile(caminhoEXE_com_barra_no_final + 'cp.bat');
end;


function ValidaCPF(sCPF: string): boolean;
var
  sDigs, sVal : string;
  iSTot, iSTot2: integer;
  i: integer;
begin
  Result := false;
  if length(sCPF) <> 11 then exit;

  sCPF := Trim(funcoes.StrNum(sCPF));

  if StrToIntDef(scpf, 0) = 0 then exit;

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
       sDigs := sDigs + IntToStr(iif(iSTot < 2, 0, 11 - iSTot));
       iSTot2 := iSTot2 + 2 * StrToInt(sDigs);
       isTot2 := iSTot2 mod 11;
       sDigs := sDigs + IntToStr(iif(iSTot2 < 2, 0, 11 - iSTot2));
       sVal := Copy(sCPF,10,2);
       Result := iif(sDigs = sVal,true,false);
    end;
end;

function iif(lTest:Boolean; vExpr1,vExpr2:Variant):Variant;
begin
  if lTest then
    Result := vExpr1
  else
    Result := vExpr2
end;

function ValidaCNPJ(CNPJ: string): Boolean;
var
  i, digito1, digito2, cont: integer;
begin
  //Deleta a mascara do CPF caso tenho
  CNPJ := funcoes.StrNum(CNPJ);
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

function tfuncoes.IniciaNfe : boolean;
begin
  if not FileExists(GetTheWindowsDirectory+'\system32\libeay32.dll') then
    begin
      CopyFile(pchar('lib\libeay32.dll'),pchar(GetTheWindowsDirectory+'\system32\libeay32.dll'),true);
    end;

  if not FileExists(GetTheWindowsDirectory+'\system32\ssleay32.dll') then
    begin
      CopyFile(pchar('lib\ssleay32.dll'),pchar(GetTheWindowsDirectory+'\system32\ssleay32.dll'),true);
    end;

end;

function tfuncoes.RetornaMaiorTstrings(entra:tstrings) :  string;
var i,len,fim : integer;
begin
  fim := entra.Count -1;
  len := 0;
  Result := '';
  for i := 0 to fim do
    begin
      if length(entra.Strings[i]) > len then
        begin
          Result := entra.Strings[i];
          len := length(entra.Strings[i]);
        end;
    end;
end;


function tfuncoes.StrNum(const entra: string) :  string;
begin
  Result := '';
  for cont := 1 to length(entra) do
    begin
      if Contido(entra[cont],'1234567890') then Result := Result + entra[cont];
    end;
  if Result = '' then Result := '0';
end;

function StrNum(const entra: string) :  string;
begin
  Result := '';
  for cont := 1 to length(entra) do
    begin
      if Contido(entra[cont],'1234567890') then Result := Result + entra[cont];
    end;
  if Result = '' then Result := '0';
end;


procedure tfuncoes.Ibquery_to_clienteDataSet(var ibquer : TIBQuery; var cliente: TClientDataSet);
var i : integer;
begin
  for i := 0 to ibquer.Fields.Count-1 do
  begin
    cliente.FieldDefs.Add(ibquer.FieldDefs.Items[i].Name,ibquer.FieldDefs.Items[i].DataType,ibquer.FieldDefs.Items[i].Size,ibquer.FieldDefs.Items[i].Required);
 end;
  cliente.CreateDataSet;
  cliente.EmptyDataSet;
end;

function RetornaAcessoUsuario : integer;
begin
  Result := Length(form22.Pgerais.Values['acessousu']);
end;

procedure tfuncoes.GeraCarne(nota,tipo : String);
var tudo,numero, sim, PEDI : string;
num : integer;
begin
  sim := funcoes.dialogo('normal',0,'SN',30,false,'S',Application.Title,'Enviar para Impressora?(S/N)' + #13 + #10,'N');
  if (sim = '*') then exit;

  if tipo = '2' then
    begin
      dm.IBselect.Close;
      dm.IBselect.SQL.Clear;
      dm.IBselect.SQL.Add('select * from contasreceber where (nota = '+nota+') and (pago=0) order by vencimento ');
      try
       dm.IBselect.Open;
      except
       dm.IBselect.Close;
       exit;
      end;

      if dm.IBselect.IsEmpty then
        begin
          dm.IBselect.Close;
          ShowMessage('Não Existem Débitos Com Este Número de Pedido!');
          exit;
        end;

      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add('select * from carne where nota='+nota);
      dm.IBQuery1.Open;

      if dm.IBQuery1.IsEmpty then
        begin
          numero := funcoes.novocod('carne');
          dm.IBQuery1.Close;
          dm.IBQuery1.SQL.Clear;
          dm.IBQuery1.SQL.Add('insert into carne(nota,numero) values('+nota+','+numero+')');
          dm.IBQuery1.ExecSQL;
        end
      else numero := dm.IBQuery1.fieldbyname('numero').AsString;

      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add('select cliente.*,rota.nome as NomeRota from cliente,rota where (rota.cod = cliente.rota) and (cliente.cod='+ dm.IBselect.fieldbyname('documento').AsString+')');
      dm.IBQuery1.Open;

      form19.RichEdit1.Clear;
      //funcoes.CharSetRichEdit(form19.RichEdit1);

      dm.IBQuery2.Close;
      dm.IBQuery2.SQL.Clear;
      dm.IBQuery2.SQL.Add('select * from registro');
      dm.IBQuery2.Open;
      addRelatorioForm19('  '+#15+#13+#10);
      num := 0;
      while not dm.IBselect.Eof do
        begin
          if num = 4 then
            begin
              num := 0;
              addRelatorioForm19(' '+#12+#13+#10);
              addRelatorioForm19('  '+#13+#10);
            end;

          addRelatorioForm19('   '+funcoes.CompletaOuRepete(#218,#194,#196,40)+funcoes.CompletaOuRepete('',#191,#196,22)+'   '+funcoes.CompletaOuRepete(#218,#194,#196,40)+funcoes.CompletaOuRepete('',#191,#196,22)+#13+#10);
          addRelatorioForm19('   '+funcoes.CompletaOuRepete(#179+' '+form22.Pgerais.Values['empresa'],#179,' ',40)+funcoes.CompletaOuRepete('PARCELA: '+copy(dm.IBselect.fieldbyname('historico').AsString,length(dm.IBselect.fieldbyname('historico').AsString) - 5,length(dm.IBselect.fieldbyname('historico').AsString)),#179,' ',22)+'   '+funcoes.CompletaOuRepete(#179+' '+form22.Pgerais.Values['empresa'],#179,' ',40)+funcoes.CompletaOuRepete('PARCELA: '+copy(dm.IBselect.fieldbyname('historico').AsString,length(dm.IBselect.fieldbyname('historico').AsString) - 5,length(dm.IBselect.fieldbyname('historico').AsString)),#179,' ',22)+#13+#10);
          addRelatorioForm19('   '+funcoes.CompletaOuRepete(#195,#193,#196,40)+funcoes.CompletaOuRepete('',#180,#196,22)+'   '+funcoes.CompletaOuRepete(#195,#193,#196,40)+funcoes.CompletaOuRepete('',#180,#196,22)+#13+#10);
          //addRelatorioForm19('   '+funcoes.CompletaOuRepete(#179+'  NOME','VALOR R$     '+#179,' ',62)+'   '+funcoes.CompletaOuRepete(#179+'  NOME','VALOR R$     '+#179,' ',62)+#13+#10);
          addRelatorioForm19('   '+funcoes.CompletaOuRepete(#179+' ALUNO(A): '+dm.IBQuery1.fieldbyname('cod').AsString+'-'+dm.IBQuery1.fieldbyname('nome').AsString,#179,' ',62)+'   '+funcoes.CompletaOuRepete(#179+' ALUNO(A): '+dm.IBQuery1.fieldbyname('cod').AsString+'-'+dm.IBQuery1.fieldbyname('nome').AsString,#179,' ',62)+#13+#10);
          addRelatorioForm19('   '+funcoes.CompletaOuRepete(#179,#179,' ',62)+'   '+funcoes.CompletaOuRepete(#179,#179,' ',62)+#13+#10);
          addRelatorioForm19('   '+funcoes.CompletaOuRepete(#179+' MATRICULA: '+copy(dm.IBQuery1.fieldbyname('obs').AsString,1,40),#179,' ',62)+'   '+funcoes.CompletaOuRepete(#179+' MATRICULA: '+copy(dm.IBQuery1.fieldbyname('obs').AsString,1,40),#179,' ',62)+#13+#10);
          addRelatorioForm19('   '+funcoes.CompletaOuRepete(#179,#179,' ',62)+'   '+funcoes.CompletaOuRepete(#179,#179,' ',62)+#13+#10);
          addRelatorioForm19('   '+funcoes.CompletaOuRepete(#179+' CURSO: '+dm.IBQuery1.fieldbyname('nomerota').AsString,#179,' ',62)+'   '+funcoes.CompletaOuRepete(#179+' CURSO: '+dm.IBQuery1.fieldbyname('nomerota').AsString,#179,' ',62)+#13+#10);
          addRelatorioForm19('   '+funcoes.CompletaOuRepete(#179,#179,' ',62)+'   '+funcoes.CompletaOuRepete(#179,#179,' ',62)+#13+#10);
          addRelatorioForm19('   '+funcoes.CompletaOuRepete(#179+' POLO: '+dm.IBQuery2.fieldbyname('cid').AsString+' - '+dm.IBQuery2.fieldbyname('est').AsString,#179,' ',62)+'   '+funcoes.CompletaOuRepete(#179+' POLO: '+dm.IBQuery2.fieldbyname('cid').AsString+' - '+dm.IBQuery2.fieldbyname('est').AsString,#179,' ',62)+#13+#10);
          addRelatorioForm19('   '+funcoes.CompletaOuRepete(#179,#179,' ',62)+'   '+funcoes.CompletaOuRepete(#179,#179,' ',62)+#13+#10);
          addRelatorioForm19('   '+funcoes.CompletaOuRepete(#179+' '+Funcoes.CompletaOuRepete(#218,#191,#196,58),' '#179,' ',62)+'   '+funcoes.CompletaOuRepete(#179+' '+Funcoes.CompletaOuRepete(#218,#191,#196,58),' '#179,' ',62)+#13+#10);
          addRelatorioForm19('   '+funcoes.CompletaOuRepete(#179+' '+Funcoes.CompletaOuRepete(#179+' VENCIMENTO: ',FormatDateTime('dd/mm/yy',dm.IBselect.fieldbyname('vencimento').AsDateTime)+'  '+#179,'.',58),' '#179,' ',62)+'   '+funcoes.CompletaOuRepete(#179+' '+Funcoes.CompletaOuRepete(#179+' VENCIMENTO: ',FormatDateTime('dd/mm/yy',dm.IBselect.fieldbyname('vencimento').AsDateTime)+'  '+#179,'.',58),' '#179,' ',62)+#13+#10);
          addRelatorioForm19('   '+funcoes.CompletaOuRepete(#179+' '+Funcoes.CompletaOuRepete(#179,#179,' ',58),#179,' ',62)+'   '+funcoes.CompletaOuRepete(#179+' '+Funcoes.CompletaOuRepete(#179,#179,' ',58),#179,' ',62)+#13+#10);
          addRelatorioForm19('   '+funcoes.CompletaOuRepete(#179+' '+Funcoes.CompletaOuRepete(#179+' VALOR ATE O VENCIMENTO: ',FormatCurr('#,###,###0.00',dm.IBselect.fieldbyname('valor').AsCurrency)+'  '+#179,'.',58),' '#179,' ',62)+'   '+funcoes.CompletaOuRepete(#179+' '+Funcoes.CompletaOuRepete(#179+' VALOR ATE O VENCIMENTO: ',FormatCurr('#,###,###0.00',dm.IBselect.fieldbyname('valor').AsCurrency)+'  '+#179,'.',58),' '#179,' ',62)+#13+#10);
          addRelatorioForm19('   '+funcoes.CompletaOuRepete(#179+' '+Funcoes.CompletaOuRepete(#179,#179,' ',58),#179,' ',62)+'   '+funcoes.CompletaOuRepete(#179+' '+Funcoes.CompletaOuRepete(#179,#179,' ',58),#179,' ',62)+#13+#10);
          addRelatorioForm19('   '+funcoes.CompletaOuRepete(#179+' '+Funcoes.CompletaOuRepete(#179+' MULTA (2%): ',FormatCurr('#,###,###0.00',Arredonda(dm.IBselect.fieldbyname('valor').AsCurrency * 0.02,2))+'  '+#179,'.',58),' '#179,' ',62)+'   '+funcoes.CompletaOuRepete(#179+' '+Funcoes.CompletaOuRepete(#179+' MULTA (2%): ',FormatCurr('#,###,###0.00',Arredonda(dm.IBselect.fieldbyname('valor').AsCurrency * 0.02,2))+'  '+#179,'.',58),' '#179,' ',62)+#13+#10);
          addRelatorioForm19('   '+funcoes.CompletaOuRepete(#179+' '+Funcoes.CompletaOuRepete(#179,#179,' ',58),#179,' ',62)+'   '+funcoes.CompletaOuRepete(#179+' '+Funcoes.CompletaOuRepete(#179,#179,' ',58),#179,' ',62)+#13+#10);
          addRelatorioForm19('   '+funcoes.CompletaOuRepete(#179+' '+Funcoes.CompletaOuRepete(#179+' CORRECAO ('+ConfParamGerais.Strings[6]+'/dia): ',FormatCurr('#,###,###0.00',Arredonda(dm.IBselect.fieldbyname('valor').AsCurrency * StrToCurr(funcoes.ConverteNumerico(ConfParamGerais.Strings[6])) /100,2))+'  '+#179,'.',58),' '#179,' ',62)+'   '+funcoes.CompletaOuRepete(#179+' '+Funcoes.CompletaOuRepete(#179+' CORRECAO ('+ConfParamGerais.Strings[6]+'/dia): ',FormatCurr('#,###,###0.00',Arredonda(dm.IBselect.fieldbyname('valor').AsCurrency * StrToCurr(funcoes.ConverteNumerico(ConfParamGerais.Strings[6])) /100,2))+'  '+#179,'.',58),' '#179,' ',62)+#13+#10);
          addRelatorioForm19('   '+funcoes.CompletaOuRepete(#179+' '+Funcoes.CompletaOuRepete(#179,#179,' ',58),#179,' ',62)+'   '+funcoes.CompletaOuRepete(#179+' '+Funcoes.CompletaOuRepete(#179,#179,' ',58),#179,' ',62)+#13+#10);
          addRelatorioForm19('   '+funcoes.CompletaOuRepete(#179+' '+Funcoes.CompletaOuRepete(#179+' TOTAL R$: ','___________________  '+#179,'.',58),' '#179,' ',62)+'   '+funcoes.CompletaOuRepete(#179+' '+Funcoes.CompletaOuRepete(#179+' TOTAL R$: ','___________________  '+#179,'.',58),' '#179,' ',62)+#13+#10);
          addRelatorioForm19('   '+funcoes.CompletaOuRepete(#179+' '+Funcoes.CompletaOuRepete(#192,#217,#196,58),#179,' ',62)+'   '+funcoes.CompletaOuRepete(#179+' '+Funcoes.CompletaOuRepete(#192,#217,#196,58),#179,' ',62)+#13+#10);
          addRelatorioForm19('   '+funcoes.CompletaOuRepete(#179+funcoes.centraliza('RECIBO ALUNO',' ',60),#179,' ',62)+'   '+funcoes.CompletaOuRepete(#179+funcoes.centraliza('RECIBO CURSO',' ',60),#179,' ',62)+#13+#10);
          addRelatorioForm19('   '+funcoes.CompletaOuRepete(#192,#217,#196,62)+'   '+funcoes.CompletaOuRepete(#192,#217,#196,62)+#13+#10);
          addRelatorioForm19('   '+#13+#10);
          num := num + 1;
          dm.IBselect.Next;
        end;

       dm.IBselect.Close;
       dm.IBQuery2.Close;
       dm.IBQuery1.Close;
       if sim = 'S' then imprime.textxArq('')
         else form19.ShowModal;
    end
  else if ((tipo = '1') or ((tipo = '3'))) then
    begin
      dm.IBselect.Close;
      dm.IBselect.SQL.Clear;
      dm.IBselect.SQL.Add('select * from contasreceber where (nota = '+nota+') and (pago=0) order by vencimento ');
      try
       dm.IBselect.Open;
      except
       dm.IBselect.Close;
       exit;
      end;

      if dm.IBselect.IsEmpty then
        begin
          dm.IBselect.Close;
          ShowMessage('Não Existem Débitos Com Este Número de Pedido!');
          exit;
        end;

      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add('select * from carne where nota='+nota);
      dm.IBQuery1.Open;

      if dm.IBQuery1.IsEmpty then
        begin
          numero := funcoes.novocod('carne');
          dm.IBQuery1.Close;
          dm.IBQuery1.SQL.Clear;
          dm.IBQuery1.SQL.Add('insert into carne(nota,numero) values('+nota+','+numero+')');
          dm.IBQuery1.ExecSQL;
        end
      else numero := dm.IBQuery1.fieldbyname('numero').AsString;

      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add('select nome, cod from cliente where cod ='+ dm.IBselect.fieldbyname('documento').AsString);
      dm.IBQuery1.Open;

      form19.RichEdit1.Clear;
      funcoes.CharSetRichEdit(form19.RichEdit1);

      dm.IBQuery2.Close;
      dm.IBQuery2.SQL.Clear;
      dm.IBQuery2.SQL.Add('select * from registro');
      dm.IBQuery2.Open;
      addRelatorioForm19('  '+#15+#13+#10);
      num := 0;
      PEDI := LeftStr(dm.IBselect.fieldbyname('historico').AsString, pos('-', dm.IBselect.fieldbyname('historico').AsString) -1);
      while not dm.IBselect.Eof do
        begin
          if num = 4 then
            begin
              num := 0;
              addRelatorioForm19(' '+#12+#13+#10);
              addRelatorioForm19('  '+#13+#10);
            end;

          addRelatorioForm19('   '+funcoes.CompletaOuRepete(#218,#191,#196,62)+'   '+funcoes.CompletaOuRepete(#218,#191,#196,62)+#13+#10);
          addRelatorioForm19('   '+funcoes.CompletaOuRepete(#179+funcoes.centraliza(form22.Pgerais.Values['empresa'],' ',41),dm.IBQuery2.fieldbyname('telres').AsString+'    '+#179,' ',62)+'   '+funcoes.CompletaOuRepete(#179+funcoes.centraliza(form22.Pgerais.Values['empresa'],' ',41),dm.IBQuery2.fieldbyname('telres').AsString+'    '+#179,' ',62)+#13+#10);
          addRelatorioForm19('   '+funcoes.CompletaOuRepete(#179+'  NOME','VALOR R$     '+#179,' ',62)+'   '+funcoes.CompletaOuRepete(#179+'  NOME','VALOR R$     '+#179,' ',62)+#13+#10);
          addRelatorioForm19('   '+funcoes.CompletaOuRepete(#179+' '+funcoes.CompletaOuRepete(#218,#191,#196,39)+funcoes.CompletaOuRepete(#218,#191,#196,19),#179,' ',62)+'   '+funcoes.CompletaOuRepete(#179+' '+funcoes.CompletaOuRepete(#218,#191,#196,39)+funcoes.CompletaOuRepete(#218,#191,#196,19),#179,' ',62)+#13+#10);
          addRelatorioForm19('   '+funcoes.CompletaOuRepete(#179+' '+funcoes.CompletaOuRepete(#179+copy(dm.IBQuery1.fieldbyname('cod').AsString + '-' +dm.IBQuery1.fieldbyname('nome').AsString,1,37),#179,' ',39)+funcoes.CompletaOuRepete(#179,FormatCurr('#,###,###0.00',dm.IBselect.fieldbyname('valor').AsCurrency)+#179,' ',19),#179,' ',62)+'   '+funcoes.CompletaOuRepete(#179+' '+funcoes.CompletaOuRepete(#179+copy(dm.IBQuery1.fieldbyname('cod').AsString + '-' +dm.IBQuery1.fieldbyname('nome').AsString,1,37),#179,' ',39)+funcoes.CompletaOuRepete(#179,FormatCurr('#,###,###0.00',dm.IBselect.fieldbyname('valor').AsCurrency)+#179,' ',19),#179,' ',62)+#13+#10);
          addRelatorioForm19('   '+funcoes.CompletaOuRepete(#179+' '+funcoes.CompletaOuRepete(#192,#217,#196,39)+funcoes.CompletaOuRepete(#192,#217,#196,19),#179,' ',62)+'   '+funcoes.CompletaOuRepete(#179+' '+funcoes.CompletaOuRepete(#192,#217,#196,39)+funcoes.CompletaOuRepete(#192,#217,#196,19),#179,' ',62)+#13+#10);
          addRelatorioForm19('   '+funcoes.CompletaOuRepete(#179+'  VENCIMENTO   PARCELA     CORRECAO R$     TOTAL PAGO R$',#179,' ',62)+'   '+funcoes.CompletaOuRepete(#179+'  VENCIMENTO   PARCELA     CORRECAO R$     TOTAL PAGO R$',#179,' ',62)+#13+#10);
          addRelatorioForm19('   '+funcoes.CompletaOuRepete(#179+' '+funcoes.CompletaOuRepete(#218,#191,#196,10)+'   '+funcoes.CompletaOuRepete(#218,#191,#196,9)+'  '+funcoes.CompletaOuRepete(#218,#191,#196,15)+' '+funcoes.CompletaOuRepete(#218,#191,#196,18),#179,' ',62)+'   '+funcoes.CompletaOuRepete(#179+' '+funcoes.CompletaOuRepete(#218,#191,#196,10)+'   '+funcoes.CompletaOuRepete(#218,#191,#196,9)+'  '+funcoes.CompletaOuRepete(#218,#191,#196,15)+' '+funcoes.CompletaOuRepete(#218,#191,#196,18),#179,' ',62)+#13+#10);
          addRelatorioForm19('   '+funcoes.CompletaOuRepete(#179+' '+funcoes.CompletaOuRepete(#179+FormatDateTime('dd/mm/yy',dm.IBselect.fieldbyname('vencimento').AsDateTime),#179,' ',10)+'   '+funcoes.CompletaOuRepete(#179+copy(dm.IBselect.fieldbyname('historico').AsString,length(dm.IBselect.fieldbyname('historico').AsString) - 5,length(dm.IBselect.fieldbyname('historico').AsString)),#179,' ',9)+'  '+funcoes.CompletaOuRepete(#179,FormatCurr('#,###,###0.00',0)+#179,' ',15)+' '+funcoes.CompletaOuRepete(#179,#179,' ',18),#179,' ',62)+'   '+
          funcoes.CompletaOuRepete(#179+' '+funcoes.CompletaOuRepete(#179+FormatDateTime('dd/mm/yy',dm.IBselect.fieldbyname('vencimento').AsDateTime),#179,' ',10)+'   '+funcoes.CompletaOuRepete(#179+copy(dm.IBselect.fieldbyname('historico').AsString,length(dm.IBselect.fieldbyname('historico').AsString) - 5,length(dm.IBselect.fieldbyname('historico').AsString)),#179,' ',9)+'  '+funcoes.CompletaOuRepete(#179,FormatCurr('#,###,###0.00',0)+#179,' ',15)+' '+funcoes.CompletaOuRepete(#179,#179,' ',18),#179,' ',62)+#13+#10);
          addRelatorioForm19('   '+funcoes.CompletaOuRepete(#179+' '+funcoes.CompletaOuRepete(#192,#217,#196,10)+'   '+funcoes.CompletaOuRepete(#192,#217,#196,9)+'  '+funcoes.CompletaOuRepete(#192,#217,#196,15)+' '+funcoes.CompletaOuRepete(#192,#217,#196,18),#179,' ',62)+'   '+funcoes.CompletaOuRepete(#179+' '+funcoes.CompletaOuRepete(#192,#217,#196,10)+'   '+funcoes.CompletaOuRepete(#192,#217,#196,9)+'  '+funcoes.CompletaOuRepete(#192,#217,#196,15)+' '+funcoes.CompletaOuRepete(#192,#217,#196,18),#179,' ',62)+#13+#10);
          addRelatorioForm19('   '+funcoes.CompletaOuRepete(#179+'     DATA PAGTO            ASSINATURA DO RECEBEDOR',#179,' ',62)+'   '+funcoes.CompletaOuRepete(#179+'     DATA PAGTO            ASSINATURA DO RECEBEDOR',#179,' ',62)+#13+#10);
          addRelatorioForm19('   '+funcoes.CompletaOuRepete(#179+' '+funcoes.CompletaOuRepete(#218,#191,#196,22)+' '+funcoes.CompletaOuRepete(#218,#191,#196,35),#179,' ',62)+'   '+funcoes.CompletaOuRepete(#179+' '+funcoes.CompletaOuRepete(#218,#191,#196,22)+' '+funcoes.CompletaOuRepete(#218,#191,#196,35),#179,' ',62)+#13+#10);
          addRelatorioForm19('   '+funcoes.CompletaOuRepete(#179+' '+funcoes.CompletaOuRepete(#179,#179,' ',22)+' '+funcoes.CompletaOuRepete(#179,#179,' ',35),#179,' ',62)+'   '+funcoes.CompletaOuRepete(#179+' '+funcoes.CompletaOuRepete(#179,#179,' ',22)+' '+funcoes.CompletaOuRepete(#179,#179,' ',35),#179,' ',62)+#13+#10);
          if tipo = '1' then
            begin
               addRelatorioForm19('   '+funcoes.CompletaOuRepete(#179+' '+funcoes.CompletaOuRepete(#179,#179,' ',22)+' '+funcoes.CompletaOuRepete(#179,#179,' ',35),#179,' ',62)+'   '+funcoes.CompletaOuRepete(#179+' '+funcoes.CompletaOuRepete(#179,#179,' ',22)+' '+funcoes.CompletaOuRepete(#179,#179,' ',35),#179,' ',62)+#13+#10);
            end;   
          addRelatorioForm19('   '+funcoes.CompletaOuRepete(#179+' '+funcoes.CompletaOuRepete(#192,#217,#196,22)+' '+funcoes.CompletaOuRepete(#192,#217,#196,35),#179,' ',62)+'   '+funcoes.CompletaOuRepete(#179+' '+funcoes.CompletaOuRepete(#192,#217,#196,22)+' '+funcoes.CompletaOuRepete(#192,#217,#196,35),#179,' ',62)+#13+#10);
          if tipo = '1' then
            begin
              addRelatorioForm19('   '+funcoes.CompletaOuRepete(#179,#179,' ',62)+'   '+funcoes.CompletaOuRepete(#179,#179,' ',62)+#13+#10);
              addRelatorioForm19('   '+funcoes.CompletaOuRepete(#179,#179,' ',62)+'   '+funcoes.CompletaOuRepete(#179,#179,' ',62)+#13+#10);
              addRelatorioForm19('   '+funcoes.CompletaOuRepete(#179,#179,' ',62)+'   '+funcoes.CompletaOuRepete(#179,#179,' ',62)+#13+#10);
            end;  
          addRelatorioForm19('   '+funcoes.CompletaOuRepete(#179+'            QUITAC'+#199+'O CONDICIONADA '+#183+' COMPENSACAO',#179,' ',62)+'   '+funcoes.CompletaOuRepete(#179+'            QUITAC'+#199+'O CONDICIONADA '+#183+' COMPENSACAO',#179,' ',62)+#13+#10);
          addRelatorioForm19('   '+funcoes.CompletaOuRepete(#179+'   Presta'+#135+#229'es Pagas com Atraso Sofrer'+#198+'o Acresc'+#214+'mos de Juros',#179,' ',62)+'   '+funcoes.CompletaOuRepete(#179+'   Presta'+#135+#229'es Pagas com Atraso Sofrer'+#198+'o Acresc'+#214+'mos de Juros',#179,' ',62)+#13+#10);
          addRelatorioForm19('   '+funcoes.CompletaOuRepete(#179+' VENDA: ' + PEDI  + '  CARNE: ' + numero ,#179,' ',62)+'   '+funcoes.CompletaOuRepete(#179+' VENDA: ' + PEDI  + '  CARNE: ' + numero,#179,' ',62)+#13+#10);
          addRelatorioForm19('   '+funcoes.CompletaOuRepete(#192,#217,#196,62)+'   '+funcoes.CompletaOuRepete(#192,#217,#196,62)+#13+#10);
          addRelatorioForm19('   '+#13+#10);
          num := num + 1;
          dm.IBselect.Next;
        end;

       dm.IBselect.Close;
       dm.IBQuery2.Close;
       dm.IBQuery1.Close;

       imprime.negrito := true;
       //imprime.setCofiguracoesImpressora;

       //if sim = 'S' then imprime.textxArq('')
       if sim = 'S' then imprime.textxArq('TEXTO.TXT')
         else form19.ShowModal;
    end;
end;


procedure tfuncoes.Traca_Nome_Rota;
begin
  form2.MainMenu1.Items.Items[5].Items[8].Caption := ConfParamGerais.Strings[7] ;
  form2.MainMenu1.Items.Items[4].Items[1].Items[5].Caption := 'Resumo P/'+ConfParamGerais.Strings[7];
end;

function VerificaAcesso_Se_Nao_tiver_Nenhum_bloqueio_true_senao_false : boolean;
begin
  if Length(form22.Pgerais.Values['acessousu']) > 0 then Result := false
    else Result := true;
end;

function JustificarStrings(ent: string;qtd: integer) : string;
var I : integer;
begin
  Result := ent;
  while length(ent) < qtd  do
    begin
      for i := 0 to length(ent) do
        begin
          if ent[i] = ' ' then insert(' ',ent,i);
          if length(ent) >= qtd then
            begin
              break;
              Result := ent;
              exit;
            end;
        end;
    end;
end;

procedure addRelatorioForm19(Adicionar : string);
begin
  form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((Adicionar))));
end;

procedure GeraParcelamento(codvenda,formpagto,codcliente,nomecliente,vendedor,codgru : string ;parcelas,periodo : integer;vencimento1 : TDateTime;valorp : Currency);
var i : integer;
vencimento : TDateTime;
begin
  for i := 1 to parcelas do
    begin
      if i = 1 then vencimento := vencimento1;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add('insert into contasreceber(nota,codgru,cod,formpagto,datamov,vendedor,data,vencimento,documento,codhis,historico,total,valor) values('+codvenda+',1,'+funcoes.novocod('cpagar')+','+formpagto+',:datamov,'+vendedor+',:data,:vencimento,'+codcliente+',2,:hist,:total,:valor)');
      dm.IBQuery1.ParamByName('datamov').AsDateTime:= form22.datamov;
      if i <> 1 then vencimento := vencimento + periodo;
      dm.IBQuery1.ParamByName('data').AsDateTime := vencimento;
      dm.IBQuery1.ParamByName('vencimento').AsDateTime := vencimento;
      dm.IBQuery1.ParamByName('hist').AsString :=  funcoes.CompletaOuRepete(copy(codvenda +'-'+nomecliente,1,28 ),funcoes.CompletaOuRepete('',IntToStr(i),' ',2)+'/'+funcoes.CompletaOuRepete('',IntToStr(parcelas),' ',2),' ',35);
      dm.IBQuery1.ParamByName('total').AsCurrency := valorp;
      dm.IBQuery1.ParamByName('valor').AsCurrency := valorp;
      try
        dm.IBQuery1.ExecSQL;
      except
        dm.IBQuery1.Transaction.Rollback;
        exit;
      end;
    end;
end;


function tfuncoes.QuebraLinhas(ini,fim,entrada:string; qtdQuebra:integer) : string;
var posi,i,a,fim1,c : integer;
nome,temp : string;
begin

while length(entrada) <> 0 do
  begin
    if Length(ini+entrada+fim) < qtdQuebra then
     begin
       addRelatorioForm19(funcoes.CompletaOuRepete(ini+entrada,fim,' ',qtdQuebra)+#13+#10);
       exit;
     end;

    for i := qtdQuebra -1 downto 1 do
      begin
        if Length(funcoes.CompletaOuRepete(ini+copy(TrimRight(entrada),1,c),fim,' ',qtdQuebra)) < qtdQuebra then
          begin
            c := 0;
            break;
          end;
        if (entrada[i] = ' ') and (i < qtdQuebra)  then
          begin
            c := i;
            break;
          end;
      end;                                                                                          //copy((entrada),1,c-1)
     if Length(funcoes.CompletaOuRepete(ini+copy((entrada),1,c),fim,' ',qtdQuebra)) = qtdQuebra then  addRelatorioForm19(funcoes.CompletaOuRepete(ini+copy((entrada),1,c-1),fim,' ',qtdQuebra)+#13+#10)
      else  addRelatorioForm19(funcoes.CompletaOuRepete(ini+copy(TrimRight(entrada),1,c),fim,' ',qtdQuebra)+#13+#10);
     if c = 0 then delete(entrada,1,length(entrada))
     else  delete(entrada,1,c);
   end;
end;

function tfuncoes.ExisteParcelamento(nota : string) : boolean;
  begin
    dm.IBQuery1.Close;
    dm.IBQuery1.SQL.Clear;
    dm.IBQuery1.SQL.Add('select vencimento,valor from contasreceber where nota='+nota);
    dm.IBQuery1.Open;
    if dm.IBQuery1.IsEmpty then Result := false
     else result := true;
    dm.IBQuery1.Close;
  end;

procedure tfuncoes.ImprimeParcelamento(ini,fim,entrada,nota : string);
begin
  dm.IBQuery1.Close;
  dm.IBQuery1.SQL.Clear;
  dm.IBQuery1.SQL.Add('select vencimento,valor from contasreceber where nota='+nota + ' and pago = 0 order by vencimento');
  dm.IBQuery1.Open;
  dm.IBQuery1.First;
  if dm.IBQuery1.IsEmpty then
    begin
      dm.IBQuery1.Close;
      exit;
    end;

   form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar(('   '+#13+#10))));
   form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((ini+'* * *  PARCELAMENTO  * * *'+fim+#13+#10))));
   form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((ini+'*                        *'+fim+#13+#10))));
   form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((ini+'* ENTRADA:' + funcoes.CompletaOuRepete('',entrada,' ',14)+' *'+fim+#13+#10))));
   while not dm.IBQuery1.Eof do
     begin
       form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((ini+'* '+FormatDateTime('dd/mm/yy',dm.IBQuery1.fieldbyname('vencimento').AsDateTime) + funcoes.CompletaOuRepete('',FormatCurr('#,###,###0.00',dm.IBQuery1.fieldbyname('valor').AsCurrency),' ',14)+' *'+fim+#13+#10 ))));
       dm.IBQuery1.Next;
     end;
   form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((ini+'*                        *'+fim+#13+#10))));
   form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((ini+'* * *  * * * * * * * * * *'+fim+#13+#10))));
   dm.IBQuery1.Close;

end;


procedure tfuncoes.GeraTemas;
var bs : TStream;
fig : TJPEGImage;
begin
  dm.IBselect.Close;
  dm.IBselect.SQL.Clear;
  dm.IBselect.SQL.Add('select * from config_tema');
  dm.IBselect.Open;

  if dm.IBselect.IsEmpty then
    begin
      dm.IBselect.Close;
      exit;
    end;
    
  try
  if Papel_de_Parede = nil then
    begin
      fig := TJPEGImage.Create;
      bs := TStream.Create;
      bs := dm.IBselect.CreateBlobStream(dm.IBselect.FieldByName('papel'),bmRead);
      if bs.Size > 0 then
        Begin
          fig.LoadFromStream(bs);
          Papel_de_Parede := fig;
          Form2.Image1.Picture.Assign(fig);
        end;
      //dm.IBselect.Close;
    end;

  if not dm.IBselect.FieldByName('cor').IsNull then
    begin
      if dm.IBselect.FieldByName('cor').AsInteger = 2 then
        begin
          //form2.Label1.Font.Color := clWhite;
          //form2.Label2.Font.Color := clWhite;
        {  form2.Label3.Font.Color := clWhite;
          form2.Label4.Font.Color := clWhite;
          form2.Label5.Font.Color := clWhite;
          form2.Label6.Font.Color := clWhite;
          form2.Label7.Font.Color := clWhite;
          form2.Label8.Font.Color := clWhite;
          Form2.Label2.Visible := false;
        }end
      else
        begin
       {   form2.Label1.Font.Color := clblack;
          form2.Label2.Font.Color := clBlack;
          form2.Label3.Font.Color := clBlack;
          form2.Label4.Font.Color := clBlack;
          form2.Label5.Font.Color := clBlack;
          form2.Label6.Font.Color := clBlack;
          form2.Label7.Font.Color := clBlack;
          form2.Label8.Font.Color := clBlack;
          Form2.Label2.Visible := false;
        }end;
    end;
//  if not dm.IBselect.FieldByName('nome').IsNull then  form2.Label1.Caption := dm.IBselect.fieldbyname('nome').AsString ;
//  if not dm.IBselect.FieldByName('top').IsNull then form2.Label1.Top := dm.IBselect.fieldbyname('top').AsInteger;
//  if not dm.IBselect.FieldByName('esq').IsNull then form2.Label1.Left := dm.IBselect.fieldbyname('esq').AsInteger;
  except

  end;
end;

function tfuncoes.TimageToFileStream(caminho : string) : TFileStream;
begin
  Result := TFileStream.Create(caminho,fmOpenRead);
end;

function tfuncoes.RetornaMaiorData(v1 : TDateTime; v2 : TDateTime) : TDateTime;
  begin
    if v1 > v2 then Result := v1
      else Result := v2;
  end;


function tfuncoes.OrdenarValoresStringList(var valor_a_Ser_Ordenado : TStringList) : TStringList;
var a,b : integer;
valor : currency;
ok :  boolean;
begin
    for b := 0 to valor_a_Ser_Ordenado.Count do
      begin
        for a := 0 to valor_a_Ser_Ordenado.Count -1 do
          begin
            if StrToCurr(valor_a_Ser_Ordenado.Values[valor_a_Ser_Ordenado.Names[a]]) > valor then
              begin
                valor_a_Ser_Ordenado.Move(a,0);
                valor := StrToCurr(valor_a_Ser_Ordenado.Values[valor_a_Ser_Ordenado.Names[a]]);
              end
            else  valor := StrToCurr(valor_a_Ser_Ordenado.Values[valor_a_Ser_Ordenado.Names[a]]);
          end;
      end;
end;

function Reorganizar : boolean;
var indices : TStringList;
i : integer;
begin
  dm.IBselect.Close;
  dm.IBselect.SQL.Clear;
  dm.IBselect.SQL.Add('select rdb$index_name as nome from rdb$indices where rdb$system_flag is not null and rdb$system_flag = 0');
  dm.IBselect.Open;

  indices := TStringList.Create;

  while not dm.IBselect.Eof do
    begin
      if (not funcoes.Contido('PK', dm.IBselect.FieldByName('nome').AsString)) and ((not funcoes.Contido('$', dm.IBselect.FieldByName('nome').AsString))) and (not funcoes.Contido('UNQ', dm.IBselect.FieldByName('nome').AsString)) then
        begin
          indices.Add(dm.IBselect.FieldByName('nome').AsString);
        end;  
      dm.IBselect.Next;
    end;

  dm.IBselect.Close;  

  For i := 0 to indices.Count -1 do
    begin
      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add('alter index '+indices.Strings[i]+' inactive');
      dm.IBQuery1.ExecSQL;

      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add('alter index '+indices.Strings[i]+' active');
      dm.IBQuery1.ExecSQL;

      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add('SET STATISTICS INDEX '+indices.Strings[i]);
      dm.IBQuery1.ExecSQL;
    end;

    indices.Free;
    funcoes.reorganizaProdutos;
    funcoes.reorganizaClientes;

    try
      if dm.IBQuery1.Transaction.InTransaction then dm.IBQuery1.Transaction.Commit;
      ShowMessage('Reorganizacao Completada!');
    except

    end;
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

function VerificaRegistro(param : integer; var bloq : boolean) : boolean;
var
  ativo,empresa : string;
  temp, t1 : integer;
begin
  Result := false;
  bloq   := false;
  dm.IBselect.Close;
  dm.IBselect.SQL.Clear;
  dm.IBselect.SQL.Add('select empresa, registro from registro');
  dm.IBselect.Open;

  temp := dm.IBselect.FieldByName('registro').AsInteger;
  ativo := '';
  empresa := '';
  empresa := trim(dm.IBselect.FieldByName('empresa').AsString);

  t1 := StringToInteger(empresa);

  if (t1 = 0) then
    begin
      exit;
    end;

      if t1 = temp then
        begin
          Result := true;
          Ativado := true;
          demo := false;

          dm.IBselect.Close;
          dm.IBselect.SQL.Clear;
          dm.IBselect.SQL.Add('select dtr, acesso from acesso where acesso = ''bloq''');
          dm.IBselect.Open;

          if not dm.IBselect.IsEmpty then
            begin
              bloq := true;
            end;

          dm.IBselect.Close;  
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
              dm.IBQuery1.SQL.Add('insert into acesso(acesso,dtr) values('+QuotedStr('ativ')+', :d)');
              dm.IBQuery1.ParamByName('d').AsDateTime := form22.datamov;
              dm.IBQuery1.ExecSQL;
              dm.IBQuery1.Transaction.Commit;
            end;
          dm.IBselect.Close;
          dm.IBselect.SQL.Clear;
          dm.IBselect.SQL.Add('select dtr from acesso where acesso = ''ativ''');
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
end;

Procedure FileCopy( Const sourcefilename, targetfilename: String );
Var
  S, T: TFileStream;
Begin
  S := TFileStream.Create( sourcefilename, fmOpenRead );
  try
    T := TFileStream.Create( targetfilename, fmOpenWrite or fmCreate );
    try
      T.CopyFrom(S, S.Size ) ;
    finally
      T.Free;
    end;
  finally
    S.Free;
  end;
End;

function Arredonda( valor:currency; decimais:integer) : currency;
 begin
   if form22.Pgerais.Values['ARREDONDA'] = 'F' then Result := funcoes.ArredondaFinanceiro(valor,decimais)
   else if form22.Pgerais.Values['ARREDONDA'] = 'T' then Result := funcoes.ArredondaTrunca(valor,decimais);
 end;

function WWMessage(flmessage: String; flType: TMsgDlgType; flbutton: TMsgDlgButtons; flColor: TColor; flBold, flItalic: boolean;WWFormColor:TColor): String;
begin
  with CreateMessageDialog(flmessage , flType ,flbutton) do
  begin
     try
        TLabel(FindComponent('Message')).Font.Color := flColor;
        Color := WWFormColor;
        TLabel(FindComponent('Message')).Font.Name := 'Courier New';
        if flBold then
           TLabel(FindComponent('Message')).Font.Style := [fsBold];
        if flItalic then
           TLabel(FindComponent('Message')).Font.Style := [fsItalic];
       // Width := TLabel(FindComponent('Message')).Width ;
        ShowModal;
      finally
        Free;
    end;
  end;
end;

function tfuncoes.DesCriptografar(wStri: String): String;
var  x , posicao            : Integer;
sim1 : string;
begin
 sim1 := Simbolos[1];
 Result := '';
 for x := 1 to Length(wStri) do
   begin
     posicao := pos(wStri[x],simbolos[2]);
     Result := Result + sim1[posicao];
   end;
end;

function tfuncoes.Criptografar(wStri: String): String;
var  x , posicao            : Integer;
sim2 : string;
begin
 sim2 := Simbolos[2];
 Result := '';
 for x := 1 to Length(wStri) do
   begin
     try
       posicao := pos(wStri[x],simbolos[1]);
       Result := Result + sim2[posicao];
     except
     end;
   end;
end;

function lancaValorMinimo(total:currency;minimo:currency;Msg:string) : currency;
var valor : string;
begin
  valor := '0,00001';
  while strtocurr(valor) < minimo do
   begin
     valor := funcoes.ConverteNumerico(funcoes.dialogo('numero',0,'1234567890,.'+#8,0,false,'ok','Control for Windows:','Qual o Percentual de Desconto (%)?:','0,00%'));
   end;
end;

function retornaPos(valor:string;sub:string;posi:integer) : integer;
begin
 valor := copy(valor,posi,length(valor));
 result := pos(sub,valor)-1;
end;

function GravarConfig(valor:string; AserGravado:string; posi:integer) : string;
var
  p1,p2 : string;
  contNum : integer;
begin
  contNum := Length(IntToStr(posi));
  p1 := '';
  p2 := '';
  // -4- s s s s s
  // p1 = copia do primeiro caractere até exemplo: 4-
  if pos(IntToStr(posi) + '-', valor) > 0 then
    begin
      p1 := copy(valor, 1, pos(IntToStr(posi) + '-', valor) + length(IntToStr(posi)));

      // valor será do 4- em diante
      valor := copy(valor, pos(IntToStr(posi) + '-' , valor) + 2, length(valor));

      //p2 será do "-"  até o final excluindo o valor que continha entre estes valores
      p2 := copy(valor, pos('-', valor) , length(valor));
      if (Trim(p2) = '') or (not (funcoes.Contido('-', p2)) ) then p2 := '-';

      //por fim gravar o novo valor
      Result := p1 + ' ' + AserGravado +  ' ' + p2;
    end
  else
    begin
      //p1 := copy(Trim(valor), length(Trim(valor)) -1, length(Trim(valor)));
      p1 := RightStr(valor, 1);
      if p1 <> '-' then p1 := valor + '-'
        else p1 := valor;

      AserGravado := IntToStr(posi) + '- ' + AserGravado;
      //p2 será do "-"  até o final excluindo o valor que continha entre estes valores
      p2 := '-';
      //por fim gravar o novo valor
      Result := p1 + ' ' + AserGravado +  ' ' + p2;
    end;
end;

function tfuncoes.LerConfig(valor:string;posi:integer) : string;
begin
  result := Trim(copy(valor,pos(inttostr(posi) + '-',valor) + 3,retornaPos(valor,'-', pos(inttostr(posi)+'-',valor)+3)));
  //ShowMessage(Result);
end;

function tfuncoes.RetornaValorConfig(Config:string;posi:integer) : variant;
begin
  result := '';
  ///  result := copy(config,pos('-'+IntToStr(posi)+'-',config)+3,RetornaPos(config,'-',pos('-'+IntToStr(posi)+'-',config)+3));
end;

function tfuncoes.GerarPgeraisList(codUsu: string) : TStringList;
var arr,temp, tmp : TStringList;
begin
 arr := TStringList.Create;

 dm.IBselect.Close;
 dm.IBselect.SQL.Clear;
 dm.IBselect.SQL.Add('select empresa, versao from registro');
 dm.IBselect.Open;
 arr.Add('empresa='+ trim(UpperCase(dm.IBselect.fieldbyname('empresa').AsString)));
 arr.Values['codigo_seq'] := dm.IBselect.fieldbyname('versao').AsString;
 dm.IBselect.Close;

 dm.IBselect.SQL.Clear;
 dm.IBselect.SQL.Add('select * from pgerais where cod = 0');
 dm.IBselect.Open;
 arr.Add('ARREDONDA='+ UpperCase(dm.IBselect.fieldbyname('valor').AsString));
 dm.IBselect.Close;

 dm.IBselect.SQL.Clear;
 dm.IBselect.SQL.Add('select * from usuario where cod=' + codUsu);
 dm.IBselect.Open;

 arr.Add('acessousu=' + funcoes.DesCriptografar(dm.IBselect.fieldbyname('acesso').AsString));
 arr.Add('codvendedor=' + dm.IBselect.fieldbyname('vendedor').AsString);
 arr.Add('configu=' + dm.IBselect.fieldbyname('configu').AsString);


 try
   arr.Add('mens=' + IfThen(dm.IBselect.fieldbyname('mens').IsNull or (dm.IBselect.fieldbyname('mens').AsString = ''), '* * *   NAO  TEM  VALOR  FISCAL    * * *', dm.IBselect.fieldbyname('mens').AsString));
 except
 end;  
 dm.IBselect.Close;

 arr.Add('nota='+ LerConfig(arr.Values['configu'],1));

 dm.IBselect.SQL.Clear;
 dm.IBselect.SQL.Add('select acesso from acesso');
 dm.IBselect.Open;
 arr.Add('acesso=' + dm.IBselect.fieldbyname('acesso').AsString);
 dm.IBselect.Close;

 if FileExists(caminhoEXE_com_barra_no_final + 'config.dat') then
  begin
    temp := TStringList.Create;
    temp.LoadFromFile(caminhoEXE_com_barra_no_final + 'config.dat');

    if temp.Values['0'] = '' then
      begin
        IF FileExists(funcoes.GetTheWindowsDirectory + '\conf_ter.dat') then
          begin
            tmp := TStringList.Create;
            tmp.LoadFromFile(funcoes.GetTheWindowsDirectory + '\conf_ter.dat');
            if tmp.Count > 0 then
              begin
                temp.Values['0'] := tmp.Values['0'];
                temp.Values['1'] := tmp.Values['1'];
                temp.SaveToFile(caminhoEXE_com_barra_no_final + 'config.dat');
              end
            else
              begin
                temp.Values['0'] := '-0-  -1-   -2-   -3- -4- -5- -6- -7- -8- -9- -10- -11- -12- -';
                temp.Values['1'] := '-0-  -1-   -2-   -3- -4- -5- -6- -7- -8- -9- -10- -11- -12- -';
              end;

            tmp.Free;  
          end;
      end;

    arr.Add('conf_ter=' + temp.Values['0']);
    arr.Values['nota'] := LerConfig(arr.Values['conf_ter'],0);

    if arr.Values['nota'] = '' then arr.Values['nota'] := 'T';

    temp.Free;
  end;

  //arr.Values['configu'] := GravarConfig(arr.Values['configu'], '', 2);

 result := arr;
 //arr.Free;
end;

function tfuncoes.CompararStringLists(var v1: tstringlist;var v2 : tstringlist) : boolean;
var i : integer;
begin
  Result := false;
  for i := 0 to v1.Count - 1 do
   begin
     if v1.Strings[i] = v2.Strings[i] then result := true
      else
       begin
        //ShowMessage(v1.Strings[i]+' <> '+v2.Strings[i]+'false');
        result := false;
        break;
       end;
   end;
end;

function tfuncoes.GravaTexT(dire:string;conteudo:string) : boolean;
begin

end;

function tfuncoes.GetTheWindowsDirectory : string;
var
  WinPath: array[0..MAX_PATH + 1] of Char;
begin
  GetWindowsDirectory(WinPath, MAX_PATH);
  Result := WinPath;
end;

function tfuncoes.GeraNota(numNota:string; tipo:string; EnviarImpressora:string; opcao : Smallint) : boolean;
var
 total,sub,entrada,total_item, desco, recebido, troco, tot_item : currency;
 refOriCodbar, tmp, impref, imprefxx : string;
 i, tam, tamDescri, linFIM : integer;
 rece, hora, txt : String;
 listaprod : TItensProduto;
begin
  if tipo='F' then
    begin
      le_Venda(numNota, desco, tmp, listaprod);
      if tmp = 'xx' then
        begin
          ShowMessage('Nota Não Encontrada!');
          exit;
        end;
      imprimeGrafico('', numNota, tmp, listaprod, desco);
    end;

   If tipo = 'D' then tipo := 'T';

   txt  := form22.Pgerais.Values['mens'];

   entrada := 0;
   dm.IBselect.Close;
   dm.IBselect.SQL.Clear;
   if opcao = 1 then
     begin
       dm.IBselect.SQL.Add('select * from venda where nota='+numNota);
       //funcoes.desmarcaVendaPaf(numNota);
     end
     else if opcao = 2 then dm.IBselect.SQL.Add('select * from orcamento where nota='+numNota)
     else
       begin
         dm.IBselect.SQL.Add('select * from compra where nota='+numNota);
         tipo := 'COM';
       end;
   try
    dm.IBselect.Open;
   except
    exit;
   end;
   form19.RichEdit1.Clear;
   if opcao = 1 then entrada := dm.IBselect.fieldbyname('entrada').AsCurrency;

   if funcoes.LerConfig(form22.Pgerais.Values['configu'], 3) = 'S' then
       begin
         txt := funcoes.dialogo('not',70,'',150,false,'','Confirme a Mensagem:',':', txt);
         if txt = '*' then txt := '';
         //txt := 'OBS: ' + txt;
       end;

   if tipo='COM' then
    begin
      hora := funcoes.dialogo('generico',0,'SN',0,false,'S','Control for Windows:','Imprime os Preços das Mercadorias? S/N','S');
      if hora = '*' then exit;

      linFim := StrToIntDef(funcoes.LerConfig(form22.Pgerais.Values['conf_ter'], 9), 50);


      tam := 78;
      total := 0;
      //l := 48;

      if ConfParamGerais[5] = 'S' then
         begin
           tamDescri := 44;
           tam := 78;
         end
       else
         begin
           tamDescri := StrToIntDef(funcoes.LerConfig(form22.Pgerais.Values['conf_ter'], 8), 35);
           tam := tam - 35;
           tam := tam + tamDescri;
         end;

      dm.IBQuery2.Close;
      dm.IBQuery2.SQL.Clear;
      dm.IBQuery2.SQL.Add('select * from registro');
      dm.IBQuery2.Open;
      form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('+','+','-', tam)+#13+#10))));
      form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('| PEDIDO DE COMPRA Nr:'+numNota+'     PAGTO: '+ dm.IBselect.fieldbyname('codhis').AsString +'-'+(funcoes.BuscaNomeBD(dm.ibquery1,'nome','formpagto','where cod='+dm.IBselect.fieldbyname('codhis').AsString)),'EMISSAO: '+ formataDataDDMMYY(dm.IBselect.fieldbyname('data').AsDateTime) +' |',' ', tam)+#13+#10))));
      form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('+','+','-',tam)+#13+#10))));
      form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('| '+dm.IBQuery2.fieldbyname('nome').AsString,'CNPJ: '+dm.IBQuery2.fieldbyname('cnpj').AsString+' |',' ',tam)+#13+#10))));
      form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('| '+dm.IBQuery2.fieldbyname('ende').AsString+'  - '+dm.IBQuery2.fieldbyname('bairro').AsString,'CEP: '+ dm.IBQuery2.fieldbyname('cep').AsString+'|',' ',tam)+#13+#10))));
      form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('| Fone: '+dm.IBQuery2.fieldbyname('telres').AsString+'  Fax: '+dm.IBQuery2.fieldbyname('telcom').AsString+ '  '+ dm.IBQuery2.fieldbyname('cid').AsString+' - '+dm.IBQuery2.fieldbyname('est').AsString,'IE: '+dm.IBQuery2.fieldbyname('ies').AsString+' |',' ',tam)+#13+#10))));
      form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('| Obs: '+dm.IBQuery2.FieldByName('obs').AsString,'SUFRAMA: '+ LeftStr(dm.IBQuery2.fieldbyname('suframa').AsString, 13) +'|',' ',tam)+#13+#10))));
      form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('+','+','-',tam)+#13+#10))));

      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add('select nome, endereco, bairro, estado, cidade, fone, fax, obs, cod from fornecedor where cod =' + dm.IBselect.fieldbyname('cliente').AsString);
      dm.IBQuery1.Open;

     form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('| Fornec: ' + funcoes.CompletaOuRepete(LeftStr(dm.IBQuery1.fieldbyname('nome').AsString, 40),'',' ', 40),'Fone: '+ dm.IBQuery1.fieldbyname('fone').AsString +' |',' ', tam)+#13+#10))));
     form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('| Endereco: ' + dm.IBQuery1.fieldbyname('endereco').AsString + ' - ' + dm.IBQuery1.fieldbyname('bairro').AsString,'Fax: '+ dm.IBQuery1.fieldbyname('fax').AsString +' |',' ', tam)+#13+#10))));
     form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('| Cidade: ' + funcoes.CompletaOuRepete(dm.IBQuery1.fieldbyname('cidade').AsString + ' - ' + dm.IBQuery1.fieldbyname('estado').AsString,'',' ',41),'Codigo: '+ dm.IBQuery1.fieldbyname('cod').AsString +' |',' ', tam) + #13 + #10))));
     form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('| Obs: ' + funcoes.CompletaOuRepete(dm.IBQuery1.fieldbyname('obs').AsString,'',' ',41),' |',' ', tam)+#13+#10))));
     form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('+','+','-', tam)+#13+#10))));

     if ConfParamGerais[5] = 'S' then
       begin
         addRelatorioForm19('|  Referencia   | Unid.  | Qtd.    |'+CompletaOuRepete(' Descricao das Mercadorias', '', ' ', 41)+'|' + CRLF);
         addRelatorioForm19('+---------------+--------+---------+'+ CompletaOuRepete('', '', '-', 41) +'+'+ CRLF);
       end
     else
       begin
         form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar(('|Codigo|Unid|  Qtd.  |'+CompletaOuRepete('    Descricao das Mercadorias      ','', ' ', tamDescri)+'|Unitario|  Total   |'+#13+#10))));
         form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar(('+------+----+--------+'+CompletaOuRepete('-----------------------------------','', '-', tamDescri)+'+--------+----------+'+#13+#10))));
       end;

     dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add('select i.cod, p.nome, p.unid, p.codbar, p.refori, i.p_compra, i.quant  from item_compra i left join produto p on (p.cod = i.cod) where i.nota = :nota ');
      dm.IBQuery1.ParamByName('nota').AsString := StrNum(numNota);
      dm.IBQuery1.Open;

     sub := 0;
     total := 0;
     while not dm.IBQuery1.Eof do
      begin
        tot_item := Arredonda(dm.IBQuery1.fieldbyname('quant').AsCurrency * dm.IBQuery1.fieldbyname('p_compra').AsCurrency, 2);
        total := total + tot_item;
        sub := sub + dm.IBQuery1.fieldbyname('quant').AsCurrency;

     if ConfParamGerais[5] = 'S' then
       begin
         addRelatorioForm19(CompletaOuRepete('|' + dm.IBQuery1.fieldbyname('refori').AsString, '|', ' ', 17) + CompletaOuRepete(dm.IBQuery1.fieldbyname('unid').AsString, '|', ' ', 9) + CompletaOuRepete('', FormatCurr('0.00',dm.IBQuery1.fieldbyname('quant').AsCurrency) + '|', ' ', 10) +
         CompletaOuRepete(LeftStr(dm.IBQuery1.fieldbyname('nome').AsString, 41), '|', ' ', 42) + CRLF);
       end
     else
       begin
         addRelatorioForm19('|'+funcoes.CompletaOuRepete('',dm.IBQuery1.fieldbyname('cod').AsString+'|',' ',7)+funcoes.CompletaOuRepete('',LeftStr(dm.ibquery1.fieldbyname('unid').AsString, 5)+'|',' ',5)+funcoes.CompletaOuRepete('',FormatCurr('0.00',dm.IBQuery1.fieldbyname('quant').AsCurrency)+'|',' ',9)+funcoes.CompletaOuRepete(copy(dm.ibquery1.fieldbyname('nome').AsString,1, tamDescri ),'|',' ', tamDescri + 1)+IfThen(hora = 'S',funcoes.CompletaOuRepete('',FormatCurr('0.00',dm.IBQuery1.fieldbyname('p_compra').AsCurrency)+'|',' ',9), funcoes.CompletaOuRepete('','|','_',9))+IfThen(hora = 'S', funcoes.CompletaOuRepete('',FormatCurr('0.00', tot_item)+'|',' ',11), funcoes.CompletaOuRepete('','|','_',11))+ CRLF);
       end;


        dm.IBQuery1.Next;
      end;
     dm.IBQuery1.Close;
     dm.IBQuery2.Close;
     dm.IBselect.Close;

     if form19.RichEdit1.Lines.Count < 50 then
      begin
        for i := form19.RichEdit1.Lines.Count to linFIM do
         begin
           if ConfParamGerais[5] = 'S' then
             begin
               addRelatorioForm19(CompletaOuRepete('|' , '|', ' ', 17) + CompletaOuRepete('', '|', ' ', 9) + CompletaOuRepete('',  '|', ' ', 10) +
               CompletaOuRepete('', '|', ' ', 42) + CRLF);
             end
           else
             begin
               form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar(('|'+funcoes.CompletaOuRepete('','|',' ',7)+funcoes.CompletaOuRepete('','|',' ',5)+funcoes.CompletaOuRepete('','|',' ', 9)+funcoes.CompletaOuRepete('','|',' ', tamDescri + 1)+funcoes.CompletaOuRepete('','|',' ',9)+funcoes.CompletaOuRepete('','|',' ',11)+#13+#10))));
             end;
         end;
      end;

     form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('+','+','-', tam)+#13+#10))));
     addRelatorioForm19(funcoes.CompletaOuRepete('| Contabil: ' + StrNum(FormatCurr('0.00',total)), '|', ' ', tam) + #13 + #10);
     form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('+','+','-', tam)+#13+#10))));

     try
       if FileExists('C:\TEXTO.txt') then DeleteFile('C:\TEXTO.txt');
       form19.RichEdit1.Lines.SaveToFile('C:\TEXTO.txt');
     except
     end;

     txt := funcoes.dialogo('generico',0,'SN'+#8,0,true,'S','Control For Windows','Imprimir Esta Compra ?S/N:','N') ;
     if txt = 'N' then
       begin
         form19.ShowModal;
         exit;
       end;

      if form22.Pgerais.Values['nota'] = 'T' then
        begin
          SetPrinter(indxImpressoraNFE);
          imprime.imprime1(0, '00');
          exit;
        end;  

      imprime.textx('texto.txt');
      exit;
    end;

   if tipo='D' then
    begin
      if funcoes.LerConfig(form22.Pgerais.Values['conf_ter'], 3) <> '' then
       begin
         imprime.negrito := iif(funcoes.LerConfig(form22.Pgerais.Values['conf_ter'], 4) = 'S', true, false);
         imprime.fontDif := true;
         imprime.tamaFonte := StrToIntDef(funcoes.LerConfig(form22.Pgerais.Values['conf_ter'], 3), 11);
         addRelatorioForm19(' '+ #13 + #10 );
       end;

      form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('','','-',40)+#13+#10))));
      form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('NOTA: '+numNota,'  VENDEDOR: '+dm.IBselect.fieldbyname('vendedor').AsString+'-'+copy(BuscaNomeBD(dm.ibquery1,'nome','vendedor','where cod='+dm.IBselect.fieldbyname('vendedor').AsString),1,10),' ',40)+#13+#10))));
      form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((#13+#10))));
      form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar(('FORMA PAGTO: '+dm.IBselect.fieldbyname('codhis').AsString+'-'+(BuscaNomeBD(dm.ibquery1,'nome','formpagto','where cod='+dm.IBselect.fieldbyname('codhis').AsString))+#13+#10))));
      form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((#13+#10))));
      form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar(('DATA: '+FormatDateTime('DD/MM/YY',dm.IBselect.fieldbyname('data').AsDateTime)+'        VALOR:'+CompletaOuRepete('',FormatCurr('#,###,###0.00',dm.ibselect.fieldbyname('total').AsCurrency),' ',11)+#13+#10))));
      form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('','','-',40)+#13+#10))));

      if EnviarImpressora = 'S' then
       begin
        imprime.textx('');
       end
      else form19.ShowModal;

    end;

   if tipo='L' then
    begin
      tam := 78;
     total := 0;
     dm.IBQuery2.Close;
     dm.IBQuery2.SQL.Clear;
     dm.IBQuery2.SQL.Add('select * from registro');
     dm.IBQuery2.Open;

     refOriCodbar := ' refori ';
     //impref := funcoes.buscaParamGeral(54, 'N');
     impRef := funcoes.LerConfig(form22.Pgerais.Values['configu'], 10);

     try
       if ConfParamGerais[49] = 'S' then refOriCodbar := ' codbar as refori ';
     except
     end;

     form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('+','+','-', tam)+#13+#10))));

     if opcao = 1 then  form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('| PEDIDO Nr:'+dm.IBselect.fieldbyname('nota').AsString+'     PAGTO: '+dm.IBselect.fieldbyname('codhis').AsString+'-'+(BuscaNomeBD(dm.ibquery1,'nome','formpagto','where cod='+dm.IBselect.fieldbyname('codhis').AsString)),'EMISSAO: '+dm.IBselect.fieldbyname('data').AsString+' |',' ',tam)+#13+#10))))
       else if opcao = 2 then form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('| ORCAMENTO Nr:'+dm.IBselect.fieldbyname('nota').AsString+'     PAGTO: '+dm.IBselect.fieldbyname('codhis').AsString+'-'+(BuscaNomeBD(dm.ibquery1,'nome','formpagto','where cod='+dm.IBselect.fieldbyname('codhis').AsString)),'EMISSAO: '+dm.IBselect.fieldbyname('data').AsString+' |',' ',tam)+#13+#10))))
       else form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('| COMPRA Nr:'+dm.IBselect.fieldbyname('nota').AsString+'     PAGTO: '+dm.IBselect.fieldbyname('codhis').AsString+'-'+(BuscaNomeBD(dm.ibquery1,'nome','formpagto','where cod='+dm.IBselect.fieldbyname('codhis').AsString)),'EMISSAO: '+dm.IBselect.fieldbyname('data').AsString+' |',' ',tam)+#13+#10))));

     form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('+','+','-',tam)+#13+#10))));
     form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('| '+form22.Pgerais.Values['empresa'],'CNPJ: '+dm.IBQuery2.fieldbyname('cnpj').AsString+' |',' ',tam)+#13+#10))));
     form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('| '+dm.IBQuery2.fieldbyname('ende').AsString+'  - '+dm.IBQuery2.fieldbyname('bairro').AsString,'|',' ',tam)+#13+#10))));
     form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('| Fone: '+dm.IBQuery2.fieldbyname('telres').AsString+'  Fax: '+dm.IBQuery2.fieldbyname('telcom').AsString+ '  '+ dm.IBQuery2.fieldbyname('cid').AsString+' - '+dm.IBQuery2.fieldbyname('est').AsString,'IE: '+dm.IBQuery2.fieldbyname('ies').AsString+' |',' ', tam)+#13+#10))));
     form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('| Obs: '+dm.IBQuery2.FieldByName('obs').AsString,'|',' ', tam)+#13+#10))));
     form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('+','+','-', tam)+#13+#10))));
     addRelatorioForm19(funcoes.CompletaOuRepete(funcoes.CompletaOuRepete(copy('| Nome: '+ funcoes.BuscaNomeBD(dm.ibquery1,'nome','cliente','where cod=' + dm.IBselect.fieldbyname('cliente').AsString), 1, 38), '', ' ', 39) + funcoes.CompletaOuRepete('|CPF/CNPJ: ' + funcoes.BuscaNomeBD(dm.ibquery1,'cnpj','cliente','where cod=' + dm.IBselect.fieldbyname('cliente').AsString) , '', ' ', 37), '|',' ', tam) + #13 + #10);

     if ConfParamGerais.Strings[27] = 'S' then
       begin
         dm.IBQuery4.Close;
         dm.IBQuery4.SQL.Clear;
         dm.IBQuery4.SQL.Add('select cod, nome, ende, bairro, cid, obs, iif(tipo = 1, cpf, cnpj) as cpf, cnpj, tipo, ies, tel,telres,telcom from cliente where cod = :cod');
         dm.IBQuery4.ParamByName('cod').AsString := dm.IBselect.fieldbyname('cliente').AsString;
         dm.IBQuery4.Open;

         addRelatorioForm19(funcoes.CompletaOuRepete(funcoes.CompletaOuRepete(copy('| Endereco: ' + dm.IBQuery4.fieldbyname('ende').AsString,1, 38), '', ' ', 39) + funcoes.CompletaOuRepete('|INSC. EST.: ' + dm.IBQuery4.fieldbyname('ies').AsString , '', ' ', 37), '|',' ', tam) + #13 + #10);
         addRelatorioForm19(funcoes.CompletaOuRepete(funcoes.CompletaOuRepete(copy('| Bairro: ' + dm.IBQuery4.fieldbyname('bairro').AsString + ' - ' + dm.IBQuery4.fieldbyname('cid').AsString, 1, 38), '', ' ', 39) + funcoes.CompletaOuRepete('|Codigo: ' + dm.IBQuery4.fieldbyname('cod').AsString , '', ' ', 37),'|',' ', tam) + #13 + #10);
         addRelatorioForm19(funcoes.CompletaOuRepete(funcoes.CompletaOuRepete(copy('| Obs: ' + dm.IBQuery4.fieldbyname('obs').AsString, 1, 38) , '', ' ', 39) + funcoes.CompletaOuRepete('|Fone: ' + dm.IBQuery4.fieldbyname('telres').AsString , '', ' ', 37),'|',' ', tam) + #13 + #10);
         dm.IBQuery4.Close;
       end;


     form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('+','+','-',tam)+#13+#10))));
     //form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar(('|Codigo| Unid |  Qtd.   |  Descricao das Mercadorias     |Unitario|   Total  |'+#13+#10))));
     //form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar(('+------+------+---------+--------------------------------+--------+----------+'+#13+#10))));
     //form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar(('|Cod. |  Qtd   |  Descricao das Mercadorias   |  Unit. |  Total  | Localiza  |'+#13+#10))));
     //form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar(('+-----+--------+------------------------------+--------+---------+-----------+'+#13+#10))));

     {addRelatorioForm19('%'+
                        '|Codigo| Unid. | Qtd.   |  Descricao das Mercadorias            | Unitario |   Total   | Referencia      | Localizacao     |' + CRLF);
     addRelatorioForm19('+------+-------+--------+---------------------------------------+----------+-----------+-----------------+-----------------+' + CRLF);}

     addRelatorioForm19('%'+
                        '| Codigo | Unid. | Qtd.   |  Descricao das Mercadorias              | Unitario |   Total   | Referencia      | Localizacao     |' + CRLF);
     addRelatorioForm19('+--------+-------+--------+-----------------------------------------+----------+-----------+-----------------+-----------------+' + CRLF);

     dm.IBQuery2.Close;
     dm.IBQuery2.SQL.Clear;

     if opcao = 1 then dm.IBQuery2.SQL.Add('select cod,p_venda, total, quant from item_venda where nota='+numNota)
       else if opcao = 2 then dm.IBQuery2.SQL.Add('select * from item_orcamento where nota='+numNota)
       else dm.IBQuery2.SQL.Add('select * from item_compra where nota='+numNota);

     dm.IBQuery2.Open;
     dm.IBQuery2.First;
     sub := 0;
     total := 0;
     while not dm.IBQuery2.Eof do
      begin
        dm.IBQuery1.Close;
        dm.IBQuery1.SQL.Clear;
        dm.IBQuery1.SQL.Add('select unid, P_VENDA, P_COMPRA,  codbar, nome, localiza, '+ refOriCodbar +' from produto where cod='+dm.IBQuery2.fieldbyname('cod').AsString);
        dm.IBQuery1.Open;

        sub := sub + dm.IBQuery2.fieldbyname('quant').AsCurrency;

        if opcao = 1 then
          begin
            addRelatorioForm19('|'+funcoes.CompletaOuRepete('', dm.IBQuery2.fieldbyname('cod').AsString+'|',' ',9) +
            funcoes.CompletaOuRepete('',dm.ibquery1.fieldbyname('unid').AsString+'|',' ',8) +
            funcoes.CompletaOuRepete('',formataCurrency(dm.IBQuery2.fieldbyname('quant').AsCurrency) + '|',' ',9) +
            funcoes.CompletaOuRepete(copy(dm.ibquery1.fieldbyname('nome').AsString,1,40
            ),'|',' ',42) +
            funcoes.CompletaOuRepete('',formataCurrency(dm.IBQuery2.fieldbyname('P_VENDA').AsCurrency)+'|',' ',11) +
            funcoes.CompletaOuRepete('',formataCurrency(dm.IBQuery2.fieldbyname('total').AsCurrency)+'|',' ',12)+
            funcoes.CompletaOuRepete(copy(dm.ibquery1.fieldbyname('refori').AsString, 1, 18),'|',' ',18)+
            funcoes.CompletaOuRepete(copy(dm.ibquery1.fieldbyname('localiza').AsString, 1, 18),'|',' ',18)+#13+#10);

            {addRelatorioForm19('|'+funcoes.CompletaOuRepete('', dm.IBQuery2.fieldbyname('cod').AsString+'|',' ',6) +
            funcoes.CompletaOuRepete('',dm.IBQuery2.fieldbyname('quant').AsString + '|',' ',9) +
            funcoes.CompletaOuRepete(copy(dm.ibquery1.fieldbyname('nome').AsString,1,30),'|',' ',31) +
            funcoes.CompletaOuRepete('',dm.ibquery2.fieldbyname('p_venda').AsString+'|',' ',9) +
            funcoes.CompletaOuRepete('',dm.IBQuery2.fieldbyname('total').AsString+'|',' ',10)+
            funcoes.CompletaOuRepete(copy(dm.ibquery1.fieldbyname('localiza').AsString, 1, 12),'|',' ',12)+#13+#10);}
            //form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar(('|'+funcoes.CompletaOuRepete('',dm.IBQuery2.fieldbyname('cod').AsString+'|',' ',7)+funcoes.CompletaOuRepete('',dm.ibquery1.fieldbyname('unid').AsString+'|',' ',7)+funcoes.CompletaOuRepete('',FormatCurr('#,###,###0.00',dm.IBQuery2.fieldbyname('quant').AsCurrency)+'|',' ',10)+funcoes.CompletaOuRepete(copy(dm.ibquery1.fieldbyname('nome').AsString,1,32),'|',' ',33)
            //+funcoes.CompletaOuRepete('',FormatCurr('#,###,###0.00',dm.ibquery2.fieldbyname('p_venda').AsCurrency)+'|',' ',9)+funcoes.CompletaOuRepete('',FormatCurr('#,###,###0.00',dm.IBQuery2.fieldbyname('total').AsCurrency)+'|',' ',11)+#13+#10))));
            total := total + dm.IBQuery2.fieldbyname('total').AsCurrency;
          end
          else if opcao = 2 then
            begin
              if impRef = 'S' then
                begin
                 imprefxx := copy(dm.ibquery1.fieldbyname('refori').AsString, 1, 17);
                end
              else impRefxx := '';

              addRelatorioForm19('|'+funcoes.CompletaOuRepete('', dm.IBQuery2.fieldbyname('cod').AsString+'|',' ',9) +
              funcoes.CompletaOuRepete('',dm.ibquery1.fieldbyname('unid').AsString+'|',' ',8) +
              funcoes.CompletaOuRepete('',formataCurrency(dm.IBQuery2.fieldbyname('quant').AsCurrency) + '|',' ',9) +
              funcoes.CompletaOuRepete(copy(dm.ibquery1.fieldbyname('nome').AsString,1,40),'|',' ',42) +
              funcoes.CompletaOuRepete('',formataCurrency(dm.IBQuery2.fieldbyname('P_VENDA').AsCurrency)+'|',' ',11) +
              funcoes.CompletaOuRepete('',formataCurrency(dm.IBQuery2.fieldbyname('total').AsCurrency)+'|',' ',12)+
              funcoes.CompletaOuRepete(impRefxx,'|',' ',18)+
              funcoes.CompletaOuRepete(copy(dm.ibquery1.fieldbyname('localiza').AsString, 1, 18),'|',' ',18)+#13+#10);

              total := total + dm.IBQuery2.fieldbyname('total').AsCurrency;
              {form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar(('|'+funcoes.CompletaOuRepete('', dm.IBQuery2.fieldbyname('cod').AsString+'|',' ',7)+funcoes.CompletaOuRepete('', dm.ibquery1.fieldbyname('unid').AsString+'|',' ',7)+funcoes.CompletaOuRepete('',FormatCurr('#,###,###0.000',dm.IBQuery2.fieldbyname('quant').AsCurrency)+'|',' ',8)+funcoes.CompletaOuRepete(copy(dm.ibquery1.fieldbyname('nome').AsString,1,34),'|',' ',35)+funcoes.CompletaOuRepete('',FormatCurr('#,###,###0.00',dm.ibquery2.fieldbyname('p_venda').AsCurrency)+'|',' ',9)+funcoes.CompletaOuRepete('',FormatCurr('#,###,###0.00', dm.IBQuery2.fieldbyname('total').AsCurrency)+'|',' ',11)+#13+#10))));
              total := total + dm.IBQuery2.fieldbyname('total').AsCurrency;}
            end
          else
            begin
              form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar(('|' + funcoes.CompletaOuRepete('',dm.IBQuery2.fieldbyname('cod').AsString+'|',' ',7)+funcoes.CompletaOuRepete('',dm.ibquery1.fieldbyname('unid').AsString+'|',' ',7)+funcoes.CompletaOuRepete('',FormatCurr('#,###,###0.000',dm.IBQuery2.fieldbyname('quant').AsCurrency)+'|',' ',8)+funcoes.CompletaOuRepete(copy(dm.ibquery1.fieldbyname('nome').AsString,1,34),'|',' ',35)+funcoes.CompletaOuRepete('',FormatCurr('#,###,###0.00', dm.ibquery1.fieldbyname('p_COMPRA').AsCurrency)+'|',' ',9)+funcoes.CompletaOuRepete('',FormatCurr('#,###,###0.00',Arredonda(dm.ibquery1.fieldbyname('p_COMPRA').AsCurrency * dm.IBQuery2.fieldbyname('quant').AsCurrency,2 ))+'|',' ',11)+#13+#10))));
              total := total + Arredonda(dm.ibquery1.fieldbyname('p_compra').AsCurrency * dm.IBQuery2.fieldbyname('quant').AsCurrency,2 );
            end;
        dm.IBQuery2.Next;
      end;
     dm.IBQuery1.Close;
     if funcoes.ExisteParcelamento(numNota) and (opcao = 1) and (ConfParamGerais.Strings[20] = 'S') then
       begin
         form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar(('|      |      |         |                                |        |          |' + CRLF))));
         funcoes.ImprimeParcelamento('|      |      |         |  ','    |        |          |',FormatCurr('#,###,###0.00',entrada),numNota);
       end;

     addRelatorioForm19('&');  
     if opcao = 1 then
       begin
         form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('|','|','-', tam)+#13+#10))));
         form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('|' + centraliza('* * * * *   R E I M P R E S S A O   * * * * *  USUARIO: ' + form22.codusario + '-' + funcoes.BuscaNomeBD(dm.ibquery3, 'nome', 'usuario', ' where cod = ' + form22.codusario), ' ', tam - 3),'|',' ', tam)+#13+#10))));
       end;

     form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('+','+','-', tam)+#13+#10))));
     form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('|',funcoes.CompletaOuRepete('Sub-Total:',FormatCurr('#,###,###0.00',total),'.',28)+' |',' ', tam)+#13+#10))));
     desco := dm.IBselect.fieldbyname('desconto').AsCurrency;
     if desco > 0 then desco := 0;
     form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('|',funcoes.CompletaOuRepete('Desconto('+FormatCurr('#,###,###0.00',(desco * 100)/ total)+'%):',FormatCurr('#,###,###0.00', desco),'.',28)+' |',' ', tam)+#13+#10))));

     if opcao = 1 then
       begin
        form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('| Volumes: '+funcoes.CompletaOuRepete('',FormatCurr('#,###,###0.00',sub),' ',9),funcoes.CompletaOuRepete('Total:',FormatCurr('#,###,###0.00',dm.IBselect.fieldbyname('total').AsCurrency),'.',28)+' |',' ', tam)+#13+#10))));
        if (funcoes.LerConfig(form22.Pgerais.Values['configu'], 3) = 'S') and (txt <> '') then
          begin
            form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('+','+','-', tam)+#13+#10))));
            form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('|OBS: ' + txt,'|',' ', tam)+#13+#10))));
            try
              funcoes.atualizaMensagemUsuario(txt);
            except
            end;
          end;
       { else
          begin
            form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('+','+','-',80)+#13+#10))));
            form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('|' + txt,'|',' ',80)+#13+#10))));
          end;
       }end
     else if opcao = 2 then form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('| Volumes: '+funcoes.CompletaOuRepete('',FormatCurr('#,###,###0.00',sub),' ',9),funcoes.CompletaOuRepete('Total:',FormatCurr('#,###,###0.00',total),'.',28)+' |',' ', tam)+#13+#10))))
       else form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('| Volumes: '+funcoes.CompletaOuRepete('',FormatCurr('#,###,###0.00',sub),' ',9),funcoes.CompletaOuRepete('Total:',FormatCurr('#,###,###0.00',total),'.',28)+' |',' ', tam)+#13+#10))));

     form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('+','+','-', tam)+#13+#10))));
     form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar(('| Vendedor: '+funcoes.CompletaOuRepete(copy(dm.IBselect.fieldbyname('vendedor').AsString+'-'+BuscaNomeBD(dm.ibquery1,'nome','vendedor','where cod='+dm.IBselect.fieldbyname('vendedor').AsString),1,16),'|',' ',17)+CompletaOuRepete('Recebido Por: ','|',' ',49)+#13+#10))));
     form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar(('| Vencimento: '+CompletaOuRepete(FormatDateTime('DD/MM/YY',dm.IBselect.fieldbyname('data').AsDateTime),'|',' ',15)+CompletaOuRepete('','|',' ',49)+#13+#10))));
     form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('+','+','-', tam)+#13+#10))));

   if EnviarImpressora = 'S' then
       begin
        imprime.textx('texto.txt');
       end
      else form19.ShowModal;


     {total := 0;
     dm.IBQuery2.Close;
     dm.IBQuery2.SQL.Clear;
     dm.IBQuery2.SQL.Add('select * from registro');
     dm.IBQuery2.Open;

     form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('+','+','-',80)+#13+#10))));
     form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('| PEDIDO Nr:'+dm.IBselect.fieldbyname('nota').AsString+'     PAGTO: '+dm.IBselect.fieldbyname('codhis').AsString+'-'+(BuscaNomeBD(dm.ibquery1,'nome','formpagto','where cod='+dm.IBselect.fieldbyname('codhis').AsString)),'EMISSAO: '+dm.IBselect.fieldbyname('data').AsString+' |',' ',80)+#13+#10))));
     form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('+','+','-',80)+#13+#10))));
     form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('| '+form22.Pgerais.Values['empresa'],'CNPJ: '+dm.IBQuery2.fieldbyname('cnpj').AsString+' |',' ',80)+#13+#10))));
     form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('| '+dm.IBQuery2.fieldbyname('ende').AsString+'  - '+dm.IBQuery2.fieldbyname('bairro').AsString,'|',' ',80)+#13+#10))));
     form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('| Fone: '+dm.IBQuery2.fieldbyname('telres').AsString+'  Fax: '+dm.IBQuery2.fieldbyname('telcom').AsString+ '  '+ dm.IBQuery2.fieldbyname('cid').AsString+' - '+dm.IBQuery2.fieldbyname('est').AsString,'IE: '+dm.IBQuery2.fieldbyname('ies').AsString+' |',' ',80)+#13+#10))));
     form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('| Obs: '+dm.IBQuery2.FieldByName('obs').AsString,'|',' ',80)+#13+#10))));
     form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('+','+','-',80)+#13+#10))));
   //  form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete(,'|',' ',35) ,'CPF/CNPJ: ' +  + #13 + #10))));
//     form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('| Nome: '+funcoes.CompletaOuRepete(funcoes.BuscaNomeBD(dm.ibquery1,'nome','cliente','where cod='+dm.IBselect.fieldbyname('cliente').AsString),'|',' ',41),'CPF/CNPJ: '+funcoes.BuscaNomeBD(dm.ibquery1,'cnpj','cliente','where cod='+dm.IBselect.fieldbyname('cliente').AsString)+' |',' ',80)+#13+#10))));
     addRelatorioForm19(funcoes.CompletaOuRepete(funcoes.CompletaOuRepete(copy('| Cliente: ' + dm.IBselect.fieldbyname('cliente').AsString + '-' +funcoes.BuscaNomeBD(dm.ibquery1,'nome','cliente','where cod=' + dm.IBselect.fieldbyname('cliente').AsString), 1, 40), '', ' ', 41) + funcoes.CompletaOuRepete('|CPF/CNPJ: ' + funcoes.BuscaNomeBD( dm.ibquery1, 'cnpj', 'cliente', 'where cod=' + dm.IBselect.fieldbyname('cliente').AsString) , '', ' ', 37), '|',' ',80) + #13 + #10);

     if ConfParamGerais.Strings[27] = 'S' then
       begin
         dm.IBQuery4.Close;
         dm.IBQuery4.SQL.Clear;
         dm.IBQuery4.SQL.Add('select nome, ende, bairro, cid, obs, iif(tipo = 1, cpf, cnpj) as cpf, cnpj, tipo, ies, tel,telres,telcom from cliente where cod = :cod');
         dm.IBQuery4.ParamByName('cod').AsString := dm.IBselect.fieldbyname('cliente').AsString;
         dm.IBQuery4.Open;

         addRelatorioForm19(funcoes.CompletaOuRepete(funcoes.CompletaOuRepete(copy('| Endereco: ' + dm.IBQuery4.fieldbyname('ende').AsString,1,40), '', ' ', 41) + funcoes.CompletaOuRepete('|INSC. EST.: ' + dm.IBQuery4.fieldbyname('cpf').AsString , '', ' ', 37), '|',' ',80) + #13 + #10);
         addRelatorioForm19(funcoes.CompletaOuRepete(funcoes.CompletaOuRepete(copy('| Bairro: ' + dm.IBQuery4.fieldbyname('bairro').AsString + ' - ' + dm.IBQuery4.fieldbyname('cid').AsString, 1, 40), '', ' ', 41) + funcoes.CompletaOuRepete('|Codigo: ' + dm.IBQuery4.fieldbyname('ies').AsString , '', ' ', 37),'|',' ',80) + #13 + #10);
         addRelatorioForm19(funcoes.CompletaOuRepete(funcoes.CompletaOuRepete(copy('| Obs: ' + dm.IBQuery4.fieldbyname('obs').AsString, 1, 40) , '', ' ', 41) + funcoes.CompletaOuRepete('|Fone: ' + dm.IBQuery4.fieldbyname('tel').AsString , '', ' ', 37),'|',' ',80) + #13 + #10);
         form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('+','+','-',80)+#13+#10))));
         dm.IBQuery4.Close;
       end
     else form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('+','+','-',80)+#13+#10))));

     test := 1;
     form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((#15+'| Codigo | Unid. | Qtd. | Descricao das Mercadorias |Unitario|  Total  | Referencia | Localizacao |'+#13+#10))));
     form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar(('+--------+-------+------+---------------------------+--------+---------+------------+-------------+'+#13+#10))));

     dm.IBQuery2.Close;
     dm.IBQuery2.SQL.Clear;
     dm.IBQuery2.SQL.Add('select cod, p_venda, total, quant from item_venda where nota=' + numNota);
     dm.IBQuery2.Open;
     dm.IBQuery2.First;
     sub := 0;
     total := 0;
     while not dm.IBQuery2.Eof do
      begin
        dm.IBQuery1.Close;
        dm.IBQuery1.SQL.Clear;
        dm.IBQuery1.SQL.Add('select unid, codbar, nome, localiza, refori from produto where cod='+dm.IBQuery2.fieldbyname('cod').AsString);
        dm.IBQuery1.Open;
        total := total + dm.IBQuery2.fieldbyname('total').AsCurrency;
        sub := sub + dm.IBQuery2.fieldbyname('quant').AsCurrency;
        form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar(('|'+funcoes.CompletaOuRepete('',dm.IBQuery2.fieldbyname('cod').AsString+'|',' ',9)+funcoes.CompletaOuRepete('',dm.ibquery1.fieldbyname('unid').AsString+'|',' ',8)+funcoes.CompletaOuRepete('',FormatCurr('#,###,###0.000',dm.IBQuery2.fieldbyname('quant').AsCurrency)+'|',' ',7)+funcoes.CompletaOuRepete(copy(dm.ibquery1.fieldbyname('nome').AsString,1,27),'|',' ',28)+funcoes.CompletaOuRepete('',FormatCurr('#,###,###0.00',dm.ibquery2.fieldbyname('p_venda').AsCurrency)+'|',' ',9)+funcoes.CompletaOuRepete('',FormatCurr('#,###,###0.00',dm.IBQuery2.fieldbyname('total').AsCurrency)+'|',' ',10)+funcoes.CompletaOuRepete(copy(dm.IBQuery1.fieldbyname('refori').AsString,1,13),'|',' ',13)+funcoes.CompletaOuRepete(copy(dm.IBQuery1.fieldbyname('localiza').AsString,1,13),'|',' ',14)+#13+#10))));
        dm.IBQuery2.Next;
      end;
     dm.IBQuery1.Close;

     try
       if funcoes.ExisteParcelamento(numNota) and (ConfParamGerais.Strings[20] = 'S') then //(form22.Pgerais.Strings[20] = 'S') then
         begin
           //'|        |       |      |                           |        |         |            |             |'
           form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar(('|        |       |      |                           |        |         |            |             |'))));
           funcoes.ImprimeParcelamento('|        |       |      |',' |        |         |            |             |',FormatCurr('#,###,###0.00', dm.IBselect.fieldbyname('entrada').AsCurrency), numNota);
         end;
     except
       on e:exception do
         begin
           gravaErrosNoArquivo(e.Message, self.Name, '808', 'Nota L - ImprimeNota');
         end;
     end;

     if form19.RichEdit1.Lines.Count < 50 then
      begin
        for i := form19.RichEdit1.Lines.Count to 50 do
         begin
           form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar(('|'+funcoes.CompletaOuRepete('','|',' ',9)+funcoes.CompletaOuRepete('','|',' ',8)+funcoes.CompletaOuRepete('','|',' ',7)+funcoes.CompletaOuRepete('','|',' ',28)+funcoes.CompletaOuRepete('','|',' ',9)+funcoes.CompletaOuRepete('','|',' ',10)+funcoes.CompletaOuRepete('','|',' ',13)+funcoes.CompletaOuRepete('','|',' ',14)+#13+#10))));
         end;
      end;

     form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((#18+funcoes.CompletaOuRepete('+','+','-',80)+#13+#10))));
     form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('|',funcoes.CompletaOuRepete('Sub-Total:',FormatCurr('#,###,###0.00',total),'.',28)+' |',' ',80)+#13+#10))));
     form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('|',funcoes.CompletaOuRepete('Desconto('+FormatCurr('#,###,###0.00',(dm.IBselect.fieldbyname('desconto').AsCurrency * 100)/ total)+'%):',FormatCurr('#,###,###0.00',dm.IBselect.fieldbyname('desconto').AsCurrency),'.',28)+' |',' ',80)+#13+#10))));
     form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('| Volumes: '+funcoes.CompletaOuRepete('',FormatCurr('#,###,###0.00',sub),' ',9),funcoes.CompletaOuRepete('Sub-Total:',FormatCurr('#,###,###0.00',dm.IBselect.fieldbyname('total').AsCurrency),'.',28)+' |',' ',80)+#13+#10))));
     form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('+','+','-',80)+#13+#10))));
     form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar(('| Vendedor: '+funcoes.CompletaOuRepete(copy(dm.IBselect.fieldbyname('vendedor').AsString+'-'+BuscaNomeBD(dm.ibquery1,'nome','vendedor','where cod='+dm.IBselect.fieldbyname('vendedor').AsString),1,16),'|',' ',17)+CompletaOuRepete('Recebido Por: ','|',' ',51)+#13+#10))));
     form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar(('| Vencimento: '+CompletaOuRepete(FormatDateTime('DD/MM/YY',dm.IBselect.fieldbyname('data').AsDateTime),'|',' ',15)+CompletaOuRepete('','|',' ',51)+#13+#10))));
     form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('+','+','-',80)+#13+#10))));
     if EnviarImpressora = 'S' then
       begin
        imprime.textx('texto.txt');
       end
      else form19.ShowModal;  }
    end;


   if tipo='A' then
    begin
     total := 0;
     dm.IBQuery2.Close;
     dm.IBQuery2.SQL.Clear;
     dm.IBQuery2.SQL.Add('select * from registro');
     dm.IBQuery2.Open;

     form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('+','+','-',80)+#13+#10))));
     form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('| PEDIDO Nr:'+dm.IBselect.fieldbyname('nota').AsString+'     PAGTO: '+dm.IBselect.fieldbyname('codhis').AsString+'-'+(BuscaNomeBD(dm.ibquery1,'nome','formpagto','where cod='+dm.IBselect.fieldbyname('codhis').AsString)),'EMISSAO: '+dm.IBselect.fieldbyname('data').AsString+' |',' ',80)+#13+#10))));
     form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('+','+','-',80)+#13+#10))));
     form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('| '+form22.Pgerais.Values['empresa'],'CNPJ: '+dm.IBQuery2.fieldbyname('cnpj').AsString+' |',' ',80)+#13+#10))));
     form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('| '+dm.IBQuery2.fieldbyname('ende').AsString+'  - '+dm.IBQuery2.fieldbyname('bairro').AsString,'|',' ',80)+#13+#10))));
     form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('| Fone: '+dm.IBQuery2.fieldbyname('telres').AsString+'  Fax: '+dm.IBQuery2.fieldbyname('telcom').AsString+ '  '+ dm.IBQuery2.fieldbyname('cid').AsString+' - '+dm.IBQuery2.fieldbyname('est').AsString,'IE: '+dm.IBQuery2.fieldbyname('ies').AsString+' |',' ',80)+#13+#10))));
     form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('| Obs: '+dm.IBQuery2.FieldByName('obs').AsString,'|',' ',80)+#13+#10))));
     form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('+','+','-',80)+#13+#10))));
   //  form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete(,'|',' ',35) ,'CPF/CNPJ: ' +  + #13 + #10))));
//     form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('| Nome: '+funcoes.CompletaOuRepete(funcoes.BuscaNomeBD(dm.ibquery1,'nome','cliente','where cod='+dm.IBselect.fieldbyname('cliente').AsString),'|',' ',41),'CPF/CNPJ: '+funcoes.BuscaNomeBD(dm.ibquery1,'cnpj','cliente','where cod='+dm.IBselect.fieldbyname('cliente').AsString)+' |',' ',80)+#13+#10))));
     addRelatorioForm19(funcoes.CompletaOuRepete(funcoes.CompletaOuRepete(copy('| Cliente: ' + dm.IBselect.fieldbyname('cliente').AsString + '-' +funcoes.BuscaNomeBD(dm.ibquery1,'nome','cliente','where cod=' + dm.IBselect.fieldbyname('cliente').AsString), 1, 40), '', ' ', 41) + funcoes.CompletaOuRepete('|CPF/CNPJ: ' + funcoes.BuscaNomeBD( dm.ibquery1, 'cnpj', 'cliente', 'where cod=' + dm.IBselect.fieldbyname('cliente').AsString) , '', ' ', 37), '|',' ',80) + #13 + #10);

     if ConfParamGerais.Strings[27] = 'S' then
       begin
         dm.IBQuery4.Close;
         dm.IBQuery4.SQL.Clear;
         dm.IBQuery4.SQL.Add('select nome, ende, bairro, cid, obs, iif(tipo = 1, cpf, cnpj) as cpf, cnpj, tipo, ies, tel,telres,telcom from cliente where cod = :cod');
         dm.IBQuery4.ParamByName('cod').AsString := dm.IBselect.fieldbyname('cliente').AsString;
         dm.IBQuery4.Open;

         addRelatorioForm19(funcoes.CompletaOuRepete(funcoes.CompletaOuRepete(copy('| Endereco: ' + dm.IBQuery4.fieldbyname('ende').AsString,1,40), '', ' ', 41) + funcoes.CompletaOuRepete('|INSC. EST.: ' + dm.IBQuery4.fieldbyname('cpf').AsString , '', ' ', 37), '|',' ',80) + #13 + #10);
         addRelatorioForm19(funcoes.CompletaOuRepete(funcoes.CompletaOuRepete(copy('| Bairro: ' + dm.IBQuery4.fieldbyname('bairro').AsString + ' - ' + dm.IBQuery4.fieldbyname('cid').AsString, 1, 40), '', ' ', 41) + funcoes.CompletaOuRepete('|Codigo: ' + dm.IBQuery4.fieldbyname('ies').AsString , '', ' ', 37),'|',' ',80) + #13 + #10);
         addRelatorioForm19(funcoes.CompletaOuRepete(funcoes.CompletaOuRepete(copy('| Obs: ' + dm.IBQuery4.fieldbyname('obs').AsString, 1, 40) , '', ' ', 41) + funcoes.CompletaOuRepete('|Fone: ' + dm.IBQuery4.fieldbyname('tel').AsString , '', ' ', 37),'|',' ',80) + #13 + #10);
         form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('+','+','-',80)+#13+#10))));
         dm.IBQuery4.Close;
       end
     else form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('+','+','-',80)+#13+#10))));
     test := 1;

     form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((#15+'| Codigo | Cod. Barras |Unid. | Qtd. | Descricao das Mercadorias |Desconto |Unitario |   Total   |'+#13+#10))));
     form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar(('+--------+-------------+------+------+---------------------------+---------+---------+-----------+'+#13+#10))));

     dm.IBQuery2.Close;
     dm.IBQuery2.SQL.Clear;
     dm.IBQuery2.SQL.Add('select cod, p_venda, total, quant from item_venda where nota=' + numNota);
     dm.IBQuery2.Open;
     dm.IBQuery2.First;
     sub := 0;
     total := 0;
     while not dm.IBQuery2.Eof do
      begin
        dm.IBQuery1.Close;
        dm.IBQuery1.SQL.Clear;
        dm.IBQuery1.SQL.Add('select unid, codbar, nome, localiza, refori from produto where cod='+dm.IBQuery2.fieldbyname('cod').AsString);
        dm.IBQuery1.Open;
        total := total + dm.IBQuery2.fieldbyname('total').AsCurrency;
        sub := sub + dm.IBQuery2.fieldbyname('quant').AsCurrency;
        form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar(('|'+funcoes.CompletaOuRepete('',dm.IBQuery2.fieldbyname('cod').AsString+'|',' ',9)+funcoes.CompletaOuRepete('',dm.ibquery1.fieldbyname('codbar').AsString+'|',' ',14)+funcoes.CompletaOuRepete('',dm.ibquery1.fieldbyname('unid').AsString+'|',' ',7)+funcoes.CompletaOuRepete('',FormatCurr('#,###,###0.000',dm.IBQuery2.fieldbyname('quant').AsCurrency)+'|',' ',7)+funcoes.CompletaOuRepete(copy(dm.ibquery1.fieldbyname('nome').AsString,1,27),'|',' ',28)+funcoes.CompletaOuRepete('',FormatCurr('#,###,###0.00',0)+'|',' ',10)+funcoes.CompletaOuRepete('',FormatCurr('#,###,###0.00',dm.ibquery2.fieldbyname('p_venda').AsCurrency)+'|',' ',10)+funcoes.CompletaOuRepete('',FormatCurr('#,###,###0.00',dm.IBQuery2.fieldbyname('total').AsCurrency)+'|',' ',12)+#13+#10))));
        dm.IBQuery2.Next;
      end;
     dm.IBQuery1.Close;

     if form19.RichEdit1.Lines.Count < 50 then
      begin
        for i := form19.RichEdit1.Lines.Count to 50 do
         begin
           form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar(('|'+funcoes.CompletaOuRepete('','|',' ',9)+funcoes.CompletaOuRepete('','|',' ',14)+funcoes.CompletaOuRepete('','|',' ',7)+funcoes.CompletaOuRepete('','|',' ',7)+funcoes.CompletaOuRepete('','|',' ',28)+funcoes.CompletaOuRepete('','|',' ',10)+funcoes.CompletaOuRepete('','|',' ',10)+funcoes.CompletaOuRepete('','|',' ',12)+#13+#10))));
         end;
      end;
     form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((#18+#13+#10))));
     form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('+','+','-',80)+#13+#10))));
     form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('|',funcoes.CompletaOuRepete('Sub-Total:',FormatCurr('#,###,###0.00',total),'.',28)+' |',' ',80)+#13+#10))));
     form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('|',funcoes.CompletaOuRepete('Desconto('+FormatCurr('#,###,###0.00',(dm.IBselect.fieldbyname('desconto').AsCurrency * 100)/ total)+'%):',FormatCurr('#,###,###0.00',dm.IBselect.fieldbyname('desconto').AsCurrency),'.',28)+' |',' ',80)+#13+#10))));
     form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('| Volumes: '+funcoes.CompletaOuRepete('',FormatCurr('#,###,###0.00',sub),' ',9),funcoes.CompletaOuRepete('Sub-Total:',FormatCurr('#,###,###0.00',dm.IBselect.fieldbyname('total').AsCurrency),'.',28)+' |',' ',80)+#13+#10))));
     form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('+','+','-',80)+#13+#10))));
     form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar(('| Vendedor: '+funcoes.CompletaOuRepete(copy(dm.IBselect.fieldbyname('vendedor').AsString+'-'+BuscaNomeBD(dm.ibquery1,'nome','vendedor','where cod='+dm.IBselect.fieldbyname('vendedor').AsString),1,16),'|',' ',17)+CompletaOuRepete('Recebido Por: ','|',' ',51)+#13+#10))));
     form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar(('| Vencimento: '+CompletaOuRepete(FormatDateTime('DD/MM/YY',dm.IBselect.fieldbyname('data').AsDateTime),'|',' ',15)+CompletaOuRepete('','|',' ',51)+#13+#10))));
     form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('+','+','-',80)+#13+#10))));

    if EnviarImpressora = 'S' then
       begin
        imprime.textx('texto.txt');
       end
      else form19.ShowModal;

    end;

   if tipo='G' then
    begin
     total := 0;
     dm.IBQuery2.Close;
     dm.IBQuery2.SQL.Clear;
     dm.IBQuery2.SQL.Add('select * from registro');
     dm.IBQuery2.Open;
     {form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('+','+','-',80)+#13+#10))));
     form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('| PEDIDO Nr:'+dm.IBselect.fieldbyname('nota').AsString+'     PAGTO: '+dm.IBselect.fieldbyname('codhis').AsString+'-'+(BuscaNomeBD(dm.ibquery1,'nome','formpagto','where cod='+dm.IBselect.fieldbyname('codhis').AsString)),'EMISSAO: '+dm.IBselect.fieldbyname('data').AsString+' |',' ',80)+#13+#10))));
     form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('+','+','-',80)+#13+#10))));
     form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('| '+form22.Pgerais.Values['empresa'],'CNPJ: '+dm.IBQuery2.fieldbyname('cnpj').AsString+' |',' ',80)+#13+#10))));
     form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('| '+dm.IBQuery2.fieldbyname('ende').AsString+'  - '+dm.IBQuery2.fieldbyname('bairro').AsString,'|',' ',80)+#13+#10))));
     form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('| Fone: '+dm.IBQuery2.fieldbyname('telres').AsString+'  Fax: '+dm.IBQuery2.fieldbyname('telcom').AsString+ '  '+ dm.IBQuery2.fieldbyname('cid').AsString+' - '+dm.IBQuery2.fieldbyname('est').AsString,'IE: '+dm.IBQuery2.fieldbyname('ies').AsString+' |',' ',80)+#13+#10))));
     form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('| Obs: '+dm.IBQuery2.FieldByName('obs').AsString,'|',' ',80)+#13+#10))));
     form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('+','+','-',80)+#13+#10))));
     form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('| Nome: '+funcoes.CompletaOuRepete(funcoes.BuscaNomeBD(dm.ibquery1,'nome','cliente','where cod='+dm.IBselect.fieldbyname('cliente').AsString),'|',' ',41),'CPF/CNPJ: '+funcoes.BuscaNomeBD(dm.ibquery1,'cnpj','cliente','where cod='+dm.IBselect.fieldbyname('cliente').AsString)+' |',' ',80)+#13+#10))));
     form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('+','+','-',80)+#13+#10))));
     form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar(('|Codigo| Unid |  Qtd. |    Descricao das Mercadorias     |Unitario|    Total   |'+#13+#10))));
     form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar(('+------+------+-------+----------------------------------+--------+------------+'+#13+#10))));
      }
      form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('+','+','-',80)+#13+#10))));
     form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('| PEDIDO Nr:'+dm.IBselect.fieldbyname('nota').AsString+'     PAGTO: '+dm.IBselect.fieldbyname('codhis').AsString+'-'+(BuscaNomeBD(dm.ibquery1,'nome','formpagto','where cod='+dm.IBselect.fieldbyname('codhis').AsString)),'EMISSAO: '+dm.IBselect.fieldbyname('data').AsString+' |',' ',80)+#13+#10))));
     form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('+','+','-',80)+#13+#10))));
     form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('| '+form22.Pgerais.Values['empresa'],'CNPJ: '+dm.IBQuery2.fieldbyname('cnpj').AsString+' |',' ',80)+#13+#10))));
     form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('| '+dm.IBQuery2.fieldbyname('ende').AsString+'  - '+dm.IBQuery2.fieldbyname('bairro').AsString,'|',' ',80)+#13+#10))));
     form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('| Fone: '+dm.IBQuery2.fieldbyname('telres').AsString+'  Fax: '+dm.IBQuery2.fieldbyname('telcom').AsString+ '  '+ dm.IBQuery2.fieldbyname('cid').AsString+' - '+dm.IBQuery2.fieldbyname('est').AsString,'IE: '+dm.IBQuery2.fieldbyname('ies').AsString+' |',' ',80)+#13+#10))));
     form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('| Obs: '+dm.IBQuery2.FieldByName('obs').AsString,'|',' ',80)+#13+#10))));
     form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('+','+','-',80)+#13+#10))));
   //  form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete(,'|',' ',35) ,'CPF/CNPJ: ' +  + #13 + #10))));
//     form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('| Nome: '+funcoes.CompletaOuRepete(funcoes.BuscaNomeBD(dm.ibquery1,'nome','cliente','where cod='+dm.IBselect.fieldbyname('cliente').AsString),'|',' ',41),'CPF/CNPJ: '+funcoes.BuscaNomeBD(dm.ibquery1,'cnpj','cliente','where cod='+dm.IBselect.fieldbyname('cliente').AsString)+' |',' ',80)+#13+#10))));
     addRelatorioForm19(funcoes.CompletaOuRepete(funcoes.CompletaOuRepete(copy('| Cliente: ' + dm.IBselect.fieldbyname('cliente').AsString + '-' +funcoes.BuscaNomeBD(dm.ibquery1,'nome','cliente','where cod=' + dm.IBselect.fieldbyname('cliente').AsString), 1, 40), '', ' ', 41) + funcoes.CompletaOuRepete('|CPF/CNPJ: ' + funcoes.BuscaNomeBD( dm.ibquery1, 'cnpj', 'cliente', 'where cod=' + dm.IBselect.fieldbyname('cliente').AsString) , '', ' ', 37), '|',' ',80) + #13 + #10);

     if ConfParamGerais.Strings[27] = 'S' then
       begin
         dm.IBQuery4.Close;
         dm.IBQuery4.SQL.Clear;
         dm.IBQuery4.SQL.Add('select nome, ende, bairro, cid, obs, iif(tipo = 1, cpf, cnpj) as cpf, cnpj, tipo, ies, tel,telres,telcom from cliente where cod = :cod');
         dm.IBQuery4.ParamByName('cod').AsString := dm.IBselect.fieldbyname('cliente').AsString;
         dm.IBQuery4.Open;

         addRelatorioForm19(funcoes.CompletaOuRepete(funcoes.CompletaOuRepete(copy('| Endereco: ' + dm.IBQuery4.fieldbyname('ende').AsString,1,40), '', ' ', 41) + funcoes.CompletaOuRepete('|INSC. EST.: ' + dm.IBQuery4.fieldbyname('cpf').AsString , '', ' ', 37), '|',' ',80) + #13 + #10);
         addRelatorioForm19(funcoes.CompletaOuRepete(funcoes.CompletaOuRepete(copy('| Bairro: ' + dm.IBQuery4.fieldbyname('bairro').AsString + ' - ' + dm.IBQuery4.fieldbyname('cid').AsString, 1, 40), '', ' ', 41) + funcoes.CompletaOuRepete('|Codigo: ' + dm.IBQuery4.fieldbyname('ies').AsString , '', ' ', 37),'|',' ',80) + #13 + #10);
         addRelatorioForm19(funcoes.CompletaOuRepete(funcoes.CompletaOuRepete(copy('| Obs: ' + dm.IBQuery4.fieldbyname('obs').AsString, 1, 40) , '', ' ', 41) + funcoes.CompletaOuRepete('|Fone: ' + dm.IBQuery4.fieldbyname('tel').AsString , '', ' ', 37),'|',' ',80) + #13 + #10);
         form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('+','+','-',80)+#13+#10))));
         dm.IBQuery4.Close;
       end
     else form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('+','+','-',80)+#13+#10))));

     form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar(('|Codigo| Unid |  Qtd. |    Descricao das Mercadorias     |Unitario|    Total   |'+#13+#10))));
     form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar(('+------+------+-------+----------------------------------+--------+------------+'+#13+#10))));


     dm.IBQuery2.Close;
     dm.IBQuery2.SQL.Clear;
     dm.IBQuery2.SQL.Add('select cod, p_venda, total, quant from item_venda where nota=' + numNota);
     dm.IBQuery2.Open;
     dm.IBQuery2.First;
     sub := 0;
     total := 0;
     while not dm.IBQuery2.Eof do
      begin
        dm.IBQuery1.Close;
        dm.IBQuery1.SQL.Clear;
        dm.IBQuery1.SQL.Add('select unid, codbar, nome, localiza, refori from produto where cod='+dm.IBQuery2.fieldbyname('cod').AsString);
        dm.IBQuery1.Open;
        total := total + dm.IBQuery2.fieldbyname('total').AsCurrency;
        sub := sub + dm.IBQuery2.fieldbyname('quant').AsCurrency;
        form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar(('|'+funcoes.CompletaOuRepete('',dm.IBQuery2.fieldbyname('cod').AsString+'|',' ',7)+funcoes.CompletaOuRepete('',dm.ibquery1.fieldbyname('unid').AsString+'|',' ',7)+funcoes.CompletaOuRepete('',FormatCurr('#,###,###0.000',dm.IBQuery2.fieldbyname('quant').AsCurrency)+'|',' ',8)+funcoes.CompletaOuRepete(copy(dm.ibquery1.fieldbyname('nome').AsString,1,34),'|',' ',35)+funcoes.CompletaOuRepete('',FormatCurr('#,###,###0.00',dm.ibquery2.fieldbyname('p_venda').AsCurrency)+'|',' ',9)+funcoes.CompletaOuRepete('',FormatCurr('#,###,###0.00',dm.IBQuery2.fieldbyname('total').AsCurrency)+'|',' ',13)+#13+#10))));
        dm.IBQuery2.Next;
      end;
     dm.IBQuery1.Close;

     try
       if funcoes.ExisteParcelamento(numNota) and (ConfParamGerais.Strings[20] = 'S') then //(form22.Pgerais.Strings[20] = 'S') then
         begin
           form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar(('|      |      |       |                                  |        |            |'))));
           funcoes.ImprimeParcelamento('|      |      |       |    ','    |        |            |', FormatCurr('#,###,###0.00', dm.IBselect.fieldbyname('entrada').AsCurrency) , numNota);
         end;
     except
       on e:exception do
         begin
           gravaErrosNoArquivo(e.Message, 'Form20', '808', 'NotaMedia - ImprimeNota');
         end;
     end;

     if form19.RichEdit1.Lines.Count < 50 then
      begin
        for i := form19.RichEdit1.Lines.Count to 50 do
         begin
           form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar(('|'+funcoes.CompletaOuRepete('','|',' ',7)+funcoes.CompletaOuRepete('','|',' ',7)+funcoes.CompletaOuRepete('','|',' ',8)+funcoes.CompletaOuRepete('','|',' ',35)+funcoes.CompletaOuRepete('','|',' ',9)+funcoes.CompletaOuRepete('','|',' ',13)+#13+#10))));
         end;
      end;


     form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('+','+','-',80)+#13+#10))));
     form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('|',funcoes.CompletaOuRepete('Sub-Total:',FormatCurr('#,###,###0.00',total),'.',28)+' |',' ',80)+#13+#10))));
     form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('|',funcoes.CompletaOuRepete('Desconto('+FormatCurr('#,###,###0.00',(dm.IBselect.fieldbyname('desconto').AsCurrency * 100)/ total)+'%):',FormatCurr('#,###,###0.00',dm.IBselect.fieldbyname('desconto').AsCurrency),'.',28)+' |',' ',80)+#13+#10))));
     form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('| Volumes: '+funcoes.CompletaOuRepete('',FormatCurr('#,###,###0.00',sub),' ',9),funcoes.CompletaOuRepete('Sub-Total:',FormatCurr('#,###,###0.00',dm.IBselect.fieldbyname('total').AsCurrency),'.',28)+' |',' ',80)+#13+#10))));
     form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('+','+','-',80)+#13+#10))));
     form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar(('| Vendedor: '+funcoes.CompletaOuRepete(copy(dm.IBselect.fieldbyname('vendedor').AsString+'-'+BuscaNomeBD(dm.ibquery1,'nome','vendedor','where cod='+dm.IBselect.fieldbyname('vendedor').AsString),1,16),'|',' ',17)+CompletaOuRepete('Recebido Por: ','|',' ',51)+#13+#10))));
     form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar(('| Vencimento: '+CompletaOuRepete(FormatDateTime('DD/MM/YY',dm.IBselect.fieldbyname('data').AsDateTime),'|',' ',15)+CompletaOuRepete('','|',' ',51)+#13+#10))));
     form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('+','+','-',80)+#13+#10))));

     if EnviarImpressora = 'S' then
       begin
        imprime.textx('texto.txt');
       end
      else form19.ShowModal;
    end;

   if tipo='M' then
   begin
     tam := 78;
     total := 0;
     dm.IBQuery2.Close;
     dm.IBQuery2.SQL.Clear;
     dm.IBQuery2.SQL.Add('select * from registro');
     dm.IBQuery2.Open;

     form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('+','+','-', tam)+#13+#10))));

     if opcao = 1 then  form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('| PEDIDO Nr:'+dm.IBselect.fieldbyname('nota').AsString+'     PAGTO: '+dm.IBselect.fieldbyname('codhis').AsString+'-'+(BuscaNomeBD(dm.ibquery1,'nome','formpagto','where cod='+dm.IBselect.fieldbyname('codhis').AsString)),'EMISSAO: '+ FormatDateTime('dd/mm/yy', dm.IBselect.fieldbyname('data').AsDateTime)+ ' ' + FormatDateTime('hh:mm:ss', dm.IBselect.fieldbyname('hora').AsDateTime) +' |',' ',tam)+#13+#10))))
       else if opcao = 2 then form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('| ORCAMENTO Nr:'+dm.IBselect.fieldbyname('nota').AsString+'     PAGTO: '+dm.IBselect.fieldbyname('codhis').AsString+'-'+(BuscaNomeBD(dm.ibquery1,'nome','formpagto','where cod='+dm.IBselect.fieldbyname('codhis').AsString)),'EMISSAO: '+dm.IBselect.fieldbyname('data').AsString+' |',' ',tam)+#13+#10))))
       else form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('| COMPRA Nr:'+dm.IBselect.fieldbyname('nota').AsString+'     PAGTO: '+dm.IBselect.fieldbyname('codhis').AsString+'-'+(BuscaNomeBD(dm.ibquery1,'nome','formpagto','where cod='+dm.IBselect.fieldbyname('codhis').AsString)),'EMISSAO: '+dm.IBselect.fieldbyname('data').AsString+' |',' ',tam)+#13+#10))));

     form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('+','+','-',tam)+#13+#10))));
     form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('| '+form22.Pgerais.Values['empresa'],'CNPJ: '+dm.IBQuery2.fieldbyname('cnpj').AsString+' |',' ',tam)+#13+#10))));
     form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('| '+dm.IBQuery2.fieldbyname('ende').AsString+'  - '+dm.IBQuery2.fieldbyname('bairro').AsString,'|',' ',tam)+#13+#10))));
     form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('| Fone: '+dm.IBQuery2.fieldbyname('telres').AsString+'  Fax: '+dm.IBQuery2.fieldbyname('telcom').AsString+ '  '+ dm.IBQuery2.fieldbyname('cid').AsString+' - '+dm.IBQuery2.fieldbyname('est').AsString,'IE: '+dm.IBQuery2.fieldbyname('ies').AsString+' |',' ', tam)+#13+#10))));
     form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('| Obs: '+dm.IBQuery2.FieldByName('obs').AsString,'|',' ', tam)+#13+#10))));
     form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('+','+','-', tam)+#13+#10))));
     //addRelatorioForm19(funcoes.CompletaOuRepete(funcoes.CompletaOuRepete(copy('| Nome: '+ funcoes.BuscaNomeBD(dm.ibquery1,'nome','cliente','where cod=' + dm.IBselect.fieldbyname('cliente').AsString), 1, 38), '', ' ', 39) + funcoes.CompletaOuRepete('|CPF/CNPJ: ' + funcoes.BuscaNomeBD(dm.ibquery1,'cnpj','cliente','where cod=' + dm.IBselect.fieldbyname('cliente').AsString) , '', ' ', 37), '|',' ', tam) + #13 + #10);
     addRelatorioForm19(funcoes.CompletaOuRepete(funcoes.CompletaOuRepete(copy('| Cliente: ' + iif(ConfParamGerais.Strings[27] = 'N', dm.IBselect.fieldbyname('cliente').AsString + '-', '')  +funcoes.BuscaNomeBD(dm.ibquery1,'nome','cliente','where cod=' + dm.IBselect.fieldbyname('cliente').AsString), 1, 46), '', ' ', 46) +
     funcoes.CompletaOuRepete('|CPF/CNPJ: ' + funcoes.BuscaNomeBD( dm.ibquery1, 'cnpj', 'cliente', 'where cod=' + dm.IBselect.fieldbyname('cliente').AsString) , '', ' ', 29), '|',' ',tam) + #13 + #10);

     dm.IBQuery4.Close;
     dm.IBQuery4.SQL.Clear;
     dm.IBQuery4.SQL.Add('select cod, nome, ende, bairro, cid, obs, iif(tipo = 1, cpf, cnpj) as cpf, cnpj, tipo, ies, tel,telres,telcom from cliente where cod = :cod');
     dm.IBQuery4.ParamByName('cod').AsString := dm.IBselect.fieldbyname('cliente').AsString;
     dm.IBQuery4.Open;

     if ((ConfParamGerais.Strings[27] = 'S') and (dm.IBQuery4.fieldbyname('ende').AsString <> '')) then
       begin
         {dm.IBQuery4.Close;
         dm.IBQuery4.SQL.Clear;
         dm.IBQuery4.SQL.Add('select cod, nome, ende, bairro, cid, obs, iif(tipo = 1, cpf, cnpj) as cpf, cnpj, tipo, ies, tel,telres,telcom from cliente where cod = :cod');
         dm.IBQuery4.ParamByName('cod').AsString := dm.IBselect.fieldbyname('cliente').AsString;
         dm.IBQuery4.Open;}


         addRelatorioForm19(funcoes.CompletaOuRepete(funcoes.CompletaOuRepete(copy('| End: ' + dm.IBQuery4.fieldbyname('ende').AsString,1, 46), '', ' ', 46) + funcoes.CompletaOuRepete('|INSC. EST.: ' + LeftStr(dm.IBQuery4.fieldbyname('ies').AsString, 29) , '', ' ', 29), '|',' ',tam) + #13 + #10);
         addRelatorioForm19(funcoes.CompletaOuRepete(funcoes.CompletaOuRepete(copy('| Bairro: ' + dm.IBQuery4.fieldbyname('bairro').AsString + ' - ' + dm.IBQuery4.fieldbyname('cid').AsString, 1, 46), '', ' ', 46) + funcoes.CompletaOuRepete('|Codigo: ' + dm.IBQuery4.fieldbyname('cod').AsString , '', ' ', 29),'|',' ',tam) + #13 + #10);
         addRelatorioForm19(funcoes.CompletaOuRepete(funcoes.CompletaOuRepete(copy('| Obs: ' + dm.IBQuery4.fieldbyname('obs').AsString, 1, 46) , '', ' ', 46) + funcoes.CompletaOuRepete('|Fone: ' + dm.IBQuery4.fieldbyname('telres').AsString , '', ' ', 29),'|',' ',tam) + #13 + #10);
         {addRelatorioForm19(funcoes.CompletaOuRepete(funcoes.CompletaOuRepete(copy('| Endereco: ' + dm.IBQuery4.fieldbyname('ende').AsString,1, 38), '', ' ', 39) + funcoes.CompletaOuRepete('|INSC. EST.: ' + dm.IBQuery4.fieldbyname('ies').AsString , '', ' ', 37), '|',' ', tam) + #13 + #10);
         addRelatorioForm19(funcoes.CompletaOuRepete(funcoes.CompletaOuRepete(copy('| Bairro: ' + dm.IBQuery4.fieldbyname('bairro').AsString + ' - ' + dm.IBQuery4.fieldbyname('cid').AsString, 1, 38), '', ' ', 39) + funcoes.CompletaOuRepete('|Codigo: ' + dm.IBQuery4.fieldbyname('cod').AsString , '', ' ', 37),'|',' ', tam) + #13 + #10);
         addRelatorioForm19(funcoes.CompletaOuRepete(funcoes.CompletaOuRepete(copy('| Obs: ' + dm.IBQuery4.fieldbyname('obs').AsString, 1, 38) , '', ' ', 39) + funcoes.CompletaOuRepete('|Fone: ' + dm.IBQuery4.fieldbyname('telres').AsString , '', ' ', 37),'|',' ', tam) + #13 + #10);}
         dm.IBQuery4.Close;
       end;

     dm.IBQuery4.Close;

     form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('+','+','-',tam)+#13+#10))));
     form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar(('|Codigo| Unid |  Qtd.   |  Descricao das Mercadorias     |Unitario|   Total  |'+ CRLF))));
     form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar(('+------+------+---------+--------------------------------+--------+----------+'+ CRLF))));

     dm.IBQuery2.Close;
     dm.IBQuery2.SQL.Clear;

     if opcao = 1 then dm.IBQuery2.SQL.Add('select cod,p_venda, total, quant from item_venda where nota='+numNota)
       else if opcao = 2 then dm.IBQuery2.SQL.Add('select * from item_orcamento where nota='+numNota)
       else dm.IBQuery2.SQL.Add('select * from item_compra where nota='+numNota);

     dm.IBQuery2.Open;
     dm.IBQuery2.First;
     sub := 0;
     total := 0;
     while not dm.IBQuery2.Eof do
      begin
        dm.IBQuery1.Close;
        dm.IBQuery1.SQL.Clear;
        dm.IBQuery1.SQL.Add('select unid, P_VENDA, P_COMPRA,  codbar, nome, localiza, refori from produto where cod='+dm.IBQuery2.fieldbyname('cod').AsString);
        dm.IBQuery1.Open;

        sub := sub + dm.IBQuery2.fieldbyname('quant').AsCurrency;

        if opcao = 1 then
          begin
            addRelatorioForm19('|'+funcoes.CompletaOuRepete('',dm.IBQuery2.fieldbyname('cod').AsString+'|',' ',7)+funcoes.CompletaOuRepete('',dm.ibquery1.fieldbyname('unid').AsString+'|',' ',7)+funcoes.CompletaOuRepete('',FormatCurr('#,###,###0.00',dm.IBQuery2.fieldbyname('quant').AsCurrency)+'|',' ',10)+funcoes.CompletaOuRepete(copy(dm.ibquery1.fieldbyname('nome').AsString,1,30),'|',' ',33)+funcoes.CompletaOuRepete('',FormatCurr('0.00',dm.ibquery2.fieldbyname('p_venda').AsCurrency)+'|',' ',9)+funcoes.CompletaOuRepete('',FormatCurr('0.00',dm.IBQuery2.fieldbyname('total').AsCurrency)+'|',' ',11)+ CRLF);
            total := total + dm.IBQuery2.fieldbyname('total').AsCurrency;
          end
          else if opcao = 2 then
            begin
              addRelatorioForm19('|'+funcoes.CompletaOuRepete('', dm.IBQuery2.fieldbyname('cod').AsString+'|',' ',7)+funcoes.CompletaOuRepete('', dm.ibquery1.fieldbyname('unid').AsString+'|',' ',7)+funcoes.CompletaOuRepete('',FormatCurr('#,###,###0.000',dm.IBQuery2.fieldbyname('quant').AsCurrency)+'|',' ',8)+funcoes.CompletaOuRepete(copy(dm.ibquery1.fieldbyname('nome').AsString,1,34),'|',' ',35)+funcoes.CompletaOuRepete('',FormatCurr('0.00',dm.ibquery2.fieldbyname('p_venda').AsCurrency)+'|',' ',9)+funcoes.CompletaOuRepete('',FormatCurr('0.00', dm.IBQuery2.fieldbyname('total').AsCurrency)+'|',' ',11)+ CRLF);
              total := total + dm.IBQuery2.fieldbyname('total').AsCurrency;
            end
          else
            begin
              addRelatorioForm19('|' + funcoes.CompletaOuRepete('',dm.IBQuery2.fieldbyname('cod').AsString+'|',' ',7)+funcoes.CompletaOuRepete('',dm.ibquery1.fieldbyname('unid').AsString+'|',' ',7)+funcoes.CompletaOuRepete('',FormatCurr('#,###,###0.000',dm.IBQuery2.fieldbyname('quant').AsCurrency)+'|',' ',8)+funcoes.CompletaOuRepete(copy(dm.ibquery1.fieldbyname('nome').AsString,1,34),'|',' ',35)+funcoes.CompletaOuRepete('',FormatCurr('0.00', dm.ibquery1.fieldbyname('p_COMPRA').AsCurrency)+'|',' ',9)+funcoes.CompletaOuRepete('',FormatCurr('0.00',Arredonda(dm.ibquery1.fieldbyname('p_COMPRA').AsCurrency * dm.IBQuery2.fieldbyname('quant').AsCurrency,2 ))+'|',' ',11)+ CRLF);
              total := total + Arredonda(dm.ibquery1.fieldbyname('p_compra').AsCurrency * dm.IBQuery2.fieldbyname('quant').AsCurrency,2 );
            end;
            
        dm.IBQuery2.Next;
      end;
      
     dm.IBQuery1.Close;
     if opcao = 1 then
       begin
         if funcoes.ExisteParcelamento(numNota) and (opcao = 1) and (ConfParamGerais.Strings[20] = 'S') then
           begin
             form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar(('|      |      |         |                                |        |          |' + CRLF))));
             funcoes.ImprimeParcelamento('|      |      |         |  ','    |        |          |',FormatCurr('#,###,###0.00',entrada),numNota);
           end;
       end;

     if opcao = 1 then
       begin
         form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('|','|','-', tam)+ CRLF))));
         addRelatorioForm19(funcoes.CompletaOuRepete('|' + centraliza('* * * * *   R E I M P R E S S A O   * * * * *  USUARIO: ' + form22.codusario + '-' + funcoes.BuscaNomeBD(dm.ibquery3, 'nome', 'usuario', ' where cod = ' + form22.codusario), ' ', tam - 3),'|',' ', tam)+ CRLF);
       end;

     form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('+','+','-', tam)+#13+#10))));
     form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('|',funcoes.CompletaOuRepete('Sub-Total:',FormatCurr('#,###,###0.00',total),'.',28)+' |',' ', tam)+#13+#10))));
     desco := dm.IBselect.fieldbyname('desconto').AsCurrency;
     if desco > 0 then desco := 0;
     form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('|',funcoes.CompletaOuRepete('Desconto('+FormatCurr('#,###,###0.00',(desco * 100)/ total)+'%):',FormatCurr('#,###,###0.00', desco),'.',28)+' |',' ', tam)+#13+#10))));

     if opcao = 1 then
       begin
        form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('| Volumes: '+funcoes.CompletaOuRepete('',FormatCurr('#,###,###0.00',sub),' ',9),funcoes.CompletaOuRepete('Total:',FormatCurr('#,###,###0.00',dm.IBselect.fieldbyname('total').AsCurrency),'.',28)+' |',' ', tam)+#13+#10))));
        if (funcoes.LerConfig(form22.Pgerais.Values['configu'], 3) = 'S') and (txt <> '') then
          begin
            form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('+','+','-', tam)+#13+#10))));
            form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('|OBS: ' + txt,'|',' ', tam)+#13+#10))));
            try
              funcoes.atualizaMensagemUsuario(txt);
            except
            end;
          end;
       { else
          begin
            form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('+','+','-',80)+#13+#10))));
            form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('|' + txt,'|',' ',80)+#13+#10))));
          end;
       }end
     else if opcao = 2 then form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('| Volumes: '+funcoes.CompletaOuRepete('',FormatCurr('#,###,###0.00',sub),' ',9),funcoes.CompletaOuRepete('Total:',FormatCurr('#,###,###0.00',total),'.',28)+' |',' ', tam)+#13+#10))))
       else form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('| Volumes: '+funcoes.CompletaOuRepete('',FormatCurr('#,###,###0.00',sub),' ',9),funcoes.CompletaOuRepete('Total:',FormatCurr('#,###,###0.00',total),'.',28)+' |',' ', tam)+#13+#10))));

     form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('+','+','-', tam)+#13+#10))));
     form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar(('| Vendedor: '+funcoes.CompletaOuRepete(copy(dm.IBselect.fieldbyname('vendedor').AsString+'-'+BuscaNomeBD(dm.ibquery1,'nome','vendedor','where cod='+dm.IBselect.fieldbyname('vendedor').AsString),1,16),'|',' ',17)+CompletaOuRepete('Recebido Por: ','|',' ',49)+#13+#10))));

     if dm.IBselect.FieldByName('codhis').AsInteger = 2 then
       begin
         dm.IBQuery1.Close;
         dm.IBQuery1.SQL.Text := 'select vencimento as data from contasreceber where nota = :nota order by vencimento';
         dm.IBQuery1.ParamByName('nota').AsString := dm.IBselect.fieldbyname('nota').AsString;
         dm.IBQuery1.Open;

         form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar(('| Vencimento: '+CompletaOuRepete(FormatDateTime('DD/MM/YY', dm.IBQuery1.fieldbyname('data').AsDateTime),'|',' ',15)+CompletaOuRepete('','|',' ',49)+#13+#10))));
         dm.IBQuery1.Close;
       end;
     form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('+','+','-', tam)+#13+#10))));

   if EnviarImpressora = 'S' then
       begin
        imprime.textx('texto.txt');
       end
      else form19.ShowModal;
 end;

   //se tipo da nota for T(ticket)
  if tipo = 'T' then
   begin
     if ConfParamGerais[32] = 'S' then
       begin
         rece := funcoes.dialogo('numero',0,'SN',0,false,'S','Control for Windows:', 'Qual o valor recebido?',FormatCurr('#,###,###0.00', dm.IBselect.fieldbyname('total').AsCurrency));
         if (rece = '*') or (StrToCurrDef(rece, 0) = 0) then
           begin
             troco := 0;
             recebido := 0;
           end
         else
           begin
             recebido := StrToCurr(rece);
             troco := recebido - dm.IBselect.fieldbyname('total').AsCurrency;
           end;
       end;

     if funcoes.LerConfig(form22.Pgerais.Values['conf_ter'], 3) <> '' then
       begin
         imprime.negrito := iif(funcoes.LerConfig(form22.Pgerais.Values['conf_ter'], 4) = 'S', true, false);
         imprime.fontDif := true;
         imprime.tamaFonte := StrToIntDef(funcoes.LerConfig(form22.Pgerais.Values['conf_ter'], 3), 11);
         addRelatorioForm19(' '+ #13 + #10 );
       end;

     total := 0;
     dm.IBQuery2.Close;
     dm.IBQuery2.SQL.Clear;
     dm.IBQuery2.SQL.Add('select * from registro');
     dm.IBQuery2.Open;

     form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('','','-',40)+#13+#10))));
     form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.centraliza(form22.Pgerais.Values['empresa'],' ',40)+#13+#10))));
     form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('','','-',40)+#13+#10))));
    // form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('','',' ',40)+#13+#10))));
     form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.centraliza(dm.IBQuery2.fieldbyname('ende').AsString+' - '+copy(dm.IBQuery2.fieldbyname('bairro').AsString,1,37-length(dm.IBQuery2.fieldbyname('ende').AsString)),' ',40)+#13+#10))));
     form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.centraliza('FONE: '+dm.IBQuery2.fieldbyname('telres').AsString+'  '+'FAX: '+dm.IBQuery2.fieldbyname('telcom').AsString  ,' ',40)+#13+#10))));

     form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('','','-',40)+#13+#10))));

     if opcao = 1 then hora := dm.IBselect.fieldbyname('hora').AsString
       else hora := FormatDateTime('hh:mm:ss', now);

     form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('DATA: '+dm.IBselect.fieldbyname('data').AsString,'HORA: '+ hora  ,' ',40)+#13+#10))));
     form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('NOTA: '+dm.IBselect.fieldbyname('nota').AsString,'',' ',13)+'  '+'VENDEDOR: '+funcoes.CompletaOuRepete(copy(dm.IBselect.fieldbyname('vendedor').AsString+'-'+BuscaNomeBD(dm.ibquery1,'nome','vendedor','where cod='+dm.IBselect.fieldbyname('vendedor').AsString),1,15),'',' ',15)+#13+#10))));
     form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('FORMA PAGTO: '+dm.IBselect.fieldbyname('codhis').AsString+'-'+copy(BuscaNomeBD(dm.ibquery1,'nome','formpagto','where cod='+dm.IBselect.fieldbyname('codhis').AsString),1,39-length(dm.IBselect.fieldbyname('codhis').AsString)),'',' ',40)+#13+#10))));
     if dm.IBselect.FieldByName('codhis').AsInteger = 2 then
       begin
         dm.IBQuery1.Close;
         dm.IBQuery1.SQL.Text := 'select vencimento as data from contasreceber where nota = :nota order by vencimento';
         dm.IBQuery1.ParamByName('nota').AsString := dm.IBselect.fieldbyname('nota').AsString;
         dm.IBQuery1.Open;

         form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar(('Vencimento: '+CompletaOuRepete(FormatDateTime('DD/MM/YY', dm.IBQuery1.fieldbyname('data').AsDateTime),'',' ', 40)+#13+#10))));
         dm.IBQuery1.Close;
       end;


     if ConfParamGerais.Strings[27] <> 'S' then
       begin
         dm.IBQuery3.Close;
         dm.IBQuery3.SQL.Clear;
         dm.IBQuery3.SQL.Add('select nome from cliente where cod = :cod');
         dm.IBQuery3.ParamByName('cod').AsString := dm.IBselect.fieldbyname('cliente').AsString;
         dm.IBQuery3.Open;
         addRelatorioForm19(funcoes.CompletaOuRepete(copy('CLIENTE: ' + dm.IBselect.fieldbyname('cliente').AsString + '-' +dm.IBQuery3.fieldbyname('nome').AsString, 1, 40) ,'',' ', 40) + #13 + #10);
       end;
     form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('','','-',40)+#13+#10))));
     
     if ConfParamGerais.Strings[27] = 'S' then
       begin
         dm.IBQuery3.Close;
         dm.IBQuery3.SQL.Clear;
         dm.IBQuery3.SQL.Add('select nome,ende, bairro, telres, telcom, obs from cliente where cod = :cod');
         dm.IBQuery3.ParamByName('cod').AsString := dm.IBselect.fieldbyname('cliente').AsString;
         dm.IBQuery3.Open;
         addRelatorioForm19(funcoes.CompletaOuRepete(copy('CLIENTE: ' + dm.IBselect.fieldbyname('cliente').AsString + '-' +dm.IBQuery3.fieldbyname('nome').AsString, 1, 40) ,'',' ', 40) + #13 + #10);

         if dm.IBQuery3.fieldbyname('ende').AsString <> '' then
           begin
             addRelatorioForm19(funcoes.CompletaOuRepete('END: ' + copy(dm.IBQuery3.fieldbyname('ende').AsString, 1,34),'',' ', 40) + #13 + #10);
             addRelatorioForm19(funcoes.CompletaOuRepete('BAIRRO: ' + copy(dm.IBQuery3.fieldbyname('bairro').AsString, 1,34),'',' ', 40) + #13 + #10);
             addRelatorioForm19(funcoes.CompletaOuRepete('FONES: ' + copy(dm.IBQuery3.fieldbyname('telres').AsString + '   ' + dm.IBQuery3.fieldbyname('telcom').AsString, 1,34),'',' ', 40) + #13 + #10);

             addRelatorioForm19('OBS: ' + CRLF);

             funcoes.QuebraLinhas('', '', dm.IBQuery3.fieldbyname('obs').AsString, 40);
           end;  
         //addRelatorioForm19(funcoes.CompletaOuRepete('OBS: ' + copy(dm.IBQuery3.fieldbyname('obs').AsString, 1,34),'',' ', 40) + #13 + #10);
         //addRelatorioForm19('' + #13 + #10);
         form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('','','-',40)+#13+#10))));
         dm.IBQuery3.Close;
       end;

     dm.IBQuery2.Close;
     dm.IBQuery2.SQL.Clear;

     if opcao = 1 then dm.IBQuery2.SQL.Add('select i.cod, i.p_venda, i.total, p.nome, i.quant, p.codbar, p.refori, p.localiza from item_venda i left join produto p on (i.cod = p.cod) where nota = ' + numNota)
       else if opcao = 2 then dm.IBQuery2.SQL.Add('select i.cod, i.p_venda,p.nome, i.quant, p.codbar, p.refori, p.localiza from item_orcamento i left join produto p on (i.cod = p.cod) where nota = ' + numNota)
       else  dm.IBQuery2.SQL.Add('select i.cod, p.p_compra as p_venda, i.quant, p.nome, p.codbar, p.localiza, p.refori from ITEM_COMPRA i left join produto p on (i.cod = p.cod) where nota = ' + numNota);

     dm.IBQuery2.Open;
     dm.IBQuery2.First;

     while not dm.IBQuery2.Eof do
      begin
        tot_item := 0;

        if opcao = 1 then tot_item := dm.IBQuery2.fieldbyname('total').AsCurrency
        else  tot_item := Arredonda(dm.IBQuery2.fieldbyname('p_venda').AsCurrency * dm.IBQuery2.fieldbyname('quant').AsCurrency, 2);

        total := total + tot_item;

        if ConfParamGerais[5] = 'S' then
          begin
            tmp := IfThen(dm.IBQuery2.fieldbyname('refori').AsString = '', dm.IBQuery2.fieldbyname('codbar').AsString, dm.IBQuery2.fieldbyname('refori').AsString);
            addRelatorioForm19(funcoes.CompletaOuRepete(tmp+'-'+copy(dm.IBQuery2.fieldbyname('nome').AsString,1,37 -length(tmp)),'',' ',40) + CRLF);
            addRelatorioForm19(funcoes.CompletaOuRepete(LeftStr(IfThen(trim(dm.IBQuery2.fieldbyname('localiza').AsString) = '', '*', trim(dm.IBQuery2.fieldbyname('localiza').AsString)), 14),'',' ',14)+funcoes.CompletaOuRepete('',FormatCurr('0.00',dm.IBQuery2.fieldbyname('quant').AsCurrency),' ',9)+funcoes.CompletaOuRepete('',FormatCurr('0.00',dm.IBQuery2.fieldbyname('p_venda').AsCurrency) ,' ',8)+
            funcoes.CompletaOuRepete('',FormatCurr('0.00',tot_item) ,' ',9)+CRLF);
          end
        else
          begin
            form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete(dm.IBQuery2.fieldbyname('cod').AsString+'-'+copy(dm.IBQuery2.fieldbyname('nome').AsString,1,37-length(dm.IBQuery2.fieldbyname('cod').AsString)),'',' ',40)+#13+#10))));
            form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('=>QTD:',FormatCurr('0.00',dm.IBQuery2.fieldbyname('quant').AsCurrency),' ',15)+funcoes.CompletaOuRepete('',FormatCurr('0.00',dm.IBQuery2.fieldbyname('p_venda').AsCurrency),' ',13)
            + funcoes.CompletaOuRepete('',FormatCurr('0.00', tot_item) ,' ',12)+#13+#10))));
          end;
        dm.IBQuery2.Next;
      end;
     if total <> dm.IBselect.fieldbyname('total').AsCurrency then
     begin
      form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar(('DESCONTO('+FormatCurr('#,###,###0.00',(dm.IBselect.fieldbyname('desconto').AsCurrency * 100)/ total)+'%) ---------->'+funcoes.CompletaOuRepete('',
      FormatCurr('#,###,###0.00',dm.IBselect.fieldbyname('desconto').AsCurrency),' ',11)+#13+#10))));
     end;

     form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('','','-',40)+#13+#10))));
     form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('TOTAL:. . . . . .',FormatCurr('#,##,###0.00',dm.IBselect.fieldbyname('total').AsCurrency),' ',40)+#13+#10))));
     form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('','','-',40)+#13+#10))));

     if funcoes.LerConfig(form22.Pgerais.Values['configu'], 3) = 'S' then
       begin
         addRelatorioForm19(funcoes.QuebraLinhas('', '', 'OBS: ' + txt, 40));
         if Length(txt) > 0 then form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('','','-',40)+#13+#10))));

         try
           funcoes.atualizaMensagemUsuario(txt);
         except
         end;
       end;

     if ConfParamGerais[32] = 'S' then
       begin
         if recebido <> 0 then
           begin
            // form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('','','-',40)+#13+#10))));
             addRelatorioForm19(funcoes.CompletaOuRepete('Pagto:. . . . . . . . . .', FormatCurr('#,###,###0.00', recebido),' ',40) + #13 + #10);
             addRelatorioForm19(funcoes.CompletaOuRepete('Troco:. . . . . . . . . .', FormatCurr('#,###,###0.00', troco),' ',40) + #13 + #10);
             form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('','','-',40)+#13+#10))));
           end;
       end;

     if opcao = 1 then        form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar(('* * *    R E I M P R E S S A O     * * *'+#13+#10))))
       else if opcao = 2 then form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar(('* * *          ORCAMENTO           * * *'+#13+#10))))
       else                   form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar(('* * *  *  *  *   COMPRA  *  *  *   * * *'+#13+#10))));

     //addRelatorioForm19(funcoes.centraliza('* * * REIMPRESSAO * * *', ' ', 40));  
     form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((' '+#13+#10))));
     if funcoes.ExisteParcelamento(numNota) and (ConfParamGerais.Strings[20] = 'S') then funcoes.ImprimeParcelamento('','',FormatCurr('#,###,###0.00',entrada),numNota);
     dm.IBselect.Close;
     dm.IBQuery2.Close;
     dm.IBQuery1.Close;
     if EnviarImpressora = 'S' then
       begin
        imprime.textx('');
       end
      else form19.ShowModal;

   end;
   //form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar(()));
     dm.IBselect.Close;
     dm.IBQuery2.Close;
     dm.IBQuery1.Close;
 end;


function tfuncoes.lista11() : string;
var pRect:TRect;
begin
try
  form39.Position := poScreenCenter;
  form39.AutoSize := false;
  form39.Height := form39.ListBox1.Items.Count * 20;
  form39.Width := length(RetornaMaiorTstrings(form39.ListBox1.Items)) * form39.ListBox1.Font.Size;
  form39.ShowModal;
  form39.Free;
  result := Trim(lista1);
except
end;
end;

function tfuncoes.lista(var t: TObject; center : boolean) : string;
var pRect:TRect;
begin
try
  if not center then GetWindowRect(tedit(t).Handle, pRect);
  pRect.Top := pRect.Top + 25;
  if center then
    begin
      form39.Position := poScreenCenter;
    end
  else
    begin
      form39.Top := pRect.Top;
      form39.Left := pRect.Left;
    end;

  form39.conf := 99;  
  form39.AutoSize := false;
  form39.Height := form39.ListBox1.Items.Count * 20;
  form39.Width := length(RetornaMaiorTstrings(form39.ListBox1.Items)) * form39.ListBox1.Font.Size;
  form39.ShowModal;
  form39.Free;
  result := Trim(lista1);
except
end;
end;

function tfuncoes.Parcelamento(Total : currency; Cliente : string; prazo : string) : TstringList;
begin
   form38 := tform38.Create(self);
   form38.total := Total;
   form38.vencto.Text := FormatDateTime('dd/mm/yyyy',form22.datamov + iif(strtoint(prazo) = 0, 30, strtoint(prazo)));
   form38.dias.Text := '30';
   form38.qtd.Text := '1';
   if Cliente = '*' then form38.tipo := 2;
   form38.ShowModal;
   form38.Free;
   result := Reparcelamento;
end;

function tfuncoes.DeletaChar(sub:string;texto:string):string;
var i:integer;
begin
  Result :='';
  for i:=1 to length(texto) do
   begin
    //ShowMessage(texto[i]);
    if sub<>texto[i] then Result := Result + texto[i];
   end;
end;

function tfuncoes.trocaChar(texto, velho, novo:string):string;
var i, fim:integer;
begin
  Result :='';
  fim := length(texto);
  for i:=1 to fim do
   begin
    if velho[1] = texto[i] then Result := Result + novo
     else Result := Result + texto[i];
   end;
end;

function tfuncoes.VerAcesso(param:string) : string;
var i,a,posi :integer;
tmf : string;
begin
  Result := '';
  for i := 0 to form2.MainMenu1.Items.Count -1 do
   begin

     posi := pos('-'+IntToStr(i)+'-', form22.Pgerais.Values['acesso']) + 3;

     for a := 0 to form2.MainMenu1.Items[i].Count -1 do
      begin
        if funcoes.Contido('*', form2.MainMenu1.Items[i].Items[a].Caption) then
          begin
            form2.MainMenu1.Items[i].Items[a].Visible := false;
          end
        else
        //if not funcoes.Contido('*', form22.Pgerais.Values['acesso'][posi+a]) then
          begin
            try
              if form22.Pgerais.Values['acesso'][posi+a] = '-' then
                begin
                  Result := form22.Pgerais.Values['acesso'];
                  insert('0', Result, posi + a);
                  form22.Pgerais.Values['acesso'] := Result;
                end;

              if form22.Pgerais.Values['acesso'][posi+a] <> ' ' then
                begin
                  if funcoes.Contido(IntToStr(i), form22.Pgerais.Values['acessousu']) then
                    begin
                      form2.MainMenu1.Items[i].Items[a].Visible := false;
                    end
                  else if length(form22.Pgerais.Values['acessousu']) > StrToInt(form22.Pgerais.Values['acesso'][posi+a]) then
                    begin
                      form2.MainMenu1.Items[i].Items[a].Visible := false;
                    end
                  else
                    begin
                      //ShowMessage('2');
                    end;

                  if param = '0' then form2.MainMenu1.Items[i].Items[a].Visible := true;
                end;
            except
            end;
          end; //fim if contido '*'

      end; //for no itens do menu
   end; //for menus

   //if ConfParamGerais.Strings[17] = 'N' then form2.MainMenu1.Items.Items[0].Items[15].Visible := false
     // else form2.MainMenu1.Items.Items[0].Items[15].Visible := true;

   //if ConfParamGerais.Strings[17] = 'N' then form2.VendanoAtacado1.Visible := false
    //  else form2.VendanoAtacado1.Visible := true;

    if ConfParamGerais.Strings[17] <> 'S' then form2.AcertodeEstoque1.Visible := false; //venda no atacado esta com esse nome
   try
     if ConfParamGerais[39] <> 'S' then  form2.NotaFiscaldeVenda1.Visible := false;
     {if ConfParamGerais[39] = 'S' then
       begin
         form2.NotaFiscaldeVenda1.Visible := true;
         if VerificaAcesso_Se_Nao_tiver_Nenhum_bloqueio_true_senao_false = false then form2.NotaFiscaldeVenda1.Visible := false;
       end;}
   except
   end;

   try
     if (ConfParamGerais[24] <> 'S') then //saida de estoque
       begin
         form2.SadadeEstoque2.Visible := false;
       end;
   except
   end;


   try
     if ConfParamGerais[14] = 'N' then
       begin
         form2.Servios1.Visible := false;
       end;
   except
   end;


   if form22.superUsu = 1 then form2.AvanarNumerao1.Visible := true
    else form2.AvanarNumerao1.Visible := false;

   if form22.superUsu = 1 then form2.avanumNFCe.Visible := true
    else form2.avanumNFCe.Visible := false;

{   if tmf <> '' then
     begin
       dm.IBQuery4.Close;
       dm.IBQuery4.SQL.Clear;
       dm.IBQuery4.SQL.Add('update acesso set acesso = :acesso where acesso <> ''');
       dm.IBQuery4.ParamByName('acesso').AsString := form22.Pgerais.Values['acesso'];
       dm.IBQuery4.ExecSQL;

       //dm.IBQuery4.Transaction.Commit;
     end;
 }
end;

function tfuncoes.GeraAleatorio(valor:integer):string;
var acc:string;
i:integer;
begin
 Randomize;
 acc:='';
 for i:=1 to valor do
  begin
   if length(acc)<valor then acc:=acc+IntToStr(random(99));
   if length(acc)>valor then Delete(acc,length(acc)-1,length(acc));
  end;
 Result := acc;
end;

function tfuncoes.centraliza(valor:string;repetir:string;tamanho:integer):string;
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

function tfuncoes.valorPorExtenso(vlr: real): string;
const
  unidade: array[1..19] of string = ('um', 'dois', 'tres', 'quatro', 'cinco',
             'seis', 'sete', 'oito', 'nove', 'dez', 'onze',
             'doze', 'treze', 'quatorze', 'quinze', 'dezesseis',
             'dezessete', 'dezoito', 'dezenove');
  centena: array[1..9] of string = ('cento', 'duzentos', 'trezentos',
             'quatrocentos', 'quinhentos', 'seiscentos',
             'setecentos', 'oitocentos', 'novecentos');
  dezena: array[2..9] of string = ('vinte', 'trinta', 'quarenta', 'cinquenta',
             'sessenta', 'setenta', 'oitenta', 'noventa');
  qualificaS: array[0..4] of string = ('', 'mil', 'milhao', 'bilhao', 'trilhao');
  qualificaP: array[0..4] of string = ('', 'mil', 'milhoes', 'bilhoes', 'trilhoes');
var
                        inteiro: Int64;
                          resto: real;
  vlrS, s, saux, vlrP, centavos: string;
     n, unid, dez, cent, tam, i: integer;
                    umReal, tem: boolean;
begin
  if (vlr = 0)
     then begin
            valorPorExtenso := 'zero';
            exit;
          end;

  inteiro := trunc(vlr); // parte inteira do valor
  resto := vlr - inteiro; // parte fracionária do valor
  vlrS := inttostr(inteiro);
  if (length(vlrS) > 15)
     then begin
            valorPorExtenso := 'Erro: valor superior a 999 trilhões.';
            exit;
          end;

  s := '';
  centavos := inttostr(round(resto * 100));

// definindo o extenso da parte inteira do valor
  i := 0;
  umReal := false; tem := false;
  while (vlrS <> '0') do
  begin
    tam := length(vlrS);
// retira do valor a 1a. parte, 2a. parte, por exemplo, para 123456789:
// 1a. parte = 789 (centena)
// 2a. parte = 456 (mil)
// 3a. parte = 123 (milhões)
    if (tam > 3)
       then begin
              vlrP := copy(vlrS, tam-2, tam);
              vlrS := copy(vlrS, 1, tam-3);
            end
    else begin // última parte do valor
           vlrP := vlrS;
           vlrS := '0';
         end;
    if (vlrP <> '000')
       then begin
              saux := '';
              if (vlrP = '100')
                 then saux := 'cem'
              else begin
                     n := strtoint(vlrP);        // para n = 371, tem-se:
                     cent := n div 100;          // cent = 3 (centena trezentos)
                     dez := (n mod 100) div 10;  // dez  = 7 (dezena setenta)
                     unid := (n mod 100) mod 10; // unid = 1 (unidade um)
                     if (cent <> 0)
                        then saux := centena[cent];
                     if ((dez <> 0) or (unid <> 0))
                        then begin
                               if ((n mod 100) <= 19)
                                  then begin
                                         if (length(saux) <> 0)
                                            then saux := saux + ' e ' + unidade[n mod 100]
                                         else saux := unidade[n mod 100];
                                       end
                               else begin
                                      if (length(saux) <> 0)
                                         then saux := saux + ' e ' + dezena[dez]
                                      else saux := dezena[dez];
                                      if (unid <> 0)
                                         then if (length(saux) <> 0)
                                                 then saux := saux + ' e ' + unidade[unid]
                                              else saux := unidade[unid];
                                    end;
                             end;
                   end;
              if ((vlrP = '1') or (vlrP = '001'))
                 then begin
                        if (i = 0) // 1a. parte do valor (um real)
                           then umReal := true
                        else saux := saux + ' ' + qualificaS[i];
                      end
              else if (i <> 0)
                      then saux := saux + ' ' + qualificaP[i];
              if (length(s) <> 0)
                 then s := saux + ', ' + s
              else s := saux;
            end;
    if (((i = 0) or (i = 1)) and (length(s) <> 0))
       then tem := true; // tem centena ou mil no valor
    i := i + 1; // próximo qualificador: 1- mil, 2- milhão, 3- bilhão, ...
  end;

  if (length(s) <> 0)
     then begin
            if (umReal)
               then s := s + ' real'
            else if (tem)
                    then s := s + ' reais'
                 else s := s + ' de reais';
          end;
// definindo o extenso dos centavos do valor
  if (centavos <> '0') // valor com centavos
     then begin
            if (length(s) <> 0) // se não é valor somente com centavos
               then s := s + ' e ';
            if (centavos = '1')
               then s := s + 'um centavo'
            else begin
                   n := strtoint(centavos);
                   if (n <= 19)
                      then s := s + unidade[n]
                   else begin                 // para n = 37, tem-se:
                          unid := n mod 10;   // unid = 37 % 10 = 7 (unidade sete)
                          dez := n div 10;    // dez  = 37 / 10 = 3 (dezena trinta)
                          s := s + dezena[dez];
                          if (unid <> 0)
                             then s := s + ' e ' + unidade[unid];
                       end;
                   s := s + ' centavos';
                 end;
          end;
  valorPorExtenso := s;
end;

function tfuncoes.SomaCampoDBGRID(var dataset:tibquery;campo:string;dataini:TDateTime;datafim:TDateTime;dataIgual:TDateTime;NomeCampoDataParaComparar:string): currency;
var i,a,recno: integer;
begin
  result:=0;
  a:=0;

  DataSet.DisableControls;
  recno := dataset.RecNo;
  DataSet.First;
  while not DataSet.Eof do
   begin

    if (dataini <> 0) and (datafim <> 0) then
    begin
      if (DataSet.FieldByName(NomeCampoDataParaComparar).AsDateTime >= dataini) and (DataSet.FieldByName(NomeCampoDataParaComparar).AsDateTime <= datafim) then Result := Result + DataSet.fieldbyname(campo).AsCurrency;
    end

    else if (dataini <> 0) and (datafim = 0) and (dataIgual = 0) then
    begin
       if dataini >= DataSet.FieldByName(NomeCampoDataParaComparar).AsDateTime then
      begin
        Result := Result + DataSet.fieldbyname(campo).AsCurrency;
      end;
    end

   else if (dataIgual <> 0) then
    begin
      //ShowMessage(FormatDateTime('dd/mm/yy',DataSet.FieldByName(NomeCampoDataParaComparar).AsDateTime)+'<>'+FormatDateTime('dd/mm/yy',dataIgual));
      if DateOf(DataSet.FieldByName(NomeCampoDataParaComparar).AsDateTime) = DateOf(dataIgual) then
      begin
        Result := Result + DataSet.fieldbyname(campo).AsCurrency;
      end;
    end

   else if (dataini <> 0) and (datafim = 0) then
    begin
     if DataSet.FieldByName(NomeCampoDataParaComparar).AsDateTime=dataIgual then Result := Result + DataSet.fieldbyname(campo).AsCurrency;
    end


   else if (dataini=0) and (datafim=0) and (dataIgual=0) then
    begin
     result := result + DataSet.fieldbyname(campo).AsCurrency;
    end;

     DataSet.Next;
   end;
   dataset.First;
   dataset.MoveBy(recno-1);
   DataSet.EnableControls;

end;


function tfuncoes.Procura_em_Multiplos_Campos(var data_set : TIBQuery;Campo_separados_por_espaco, valorParaComparar : string) : boolean;
var i:integer;
var b, acc:string;
begin
 Result := false;
 if StrToInt(ContaChar(Campo_separados_por_espaco,' ')) > 0 then
   begin
     while Campo_separados_por_espaco <> '' do
       begin
         if StrToInt(ContaChar(Campo_separados_por_espaco,' ')) > 0 then
           begin
             acc := (copy(Campo_separados_por_espaco,1,pos(' ',Campo_separados_por_espaco) - 1));
             Campo_separados_por_espaco := copy(Campo_separados_por_espaco,pos(' ',Campo_separados_por_espaco) + 1,length(Campo_separados_por_espaco));
           end
         else
           begin
             acc := Campo_separados_por_espaco;
             Campo_separados_por_espaco := '';
           end;
        // ShowMessage(acc);
         if Contido(valorParaComparar, data_set.FieldByName(acc).AsVariant) then Result := true;
       end;
   end
 else if Contido(valorParaComparar, data_set.FieldByName(Campo_separados_por_espaco).AsVariant) then Result := true;
end;

function tfuncoes.ProcuraMultiplos(entradaDataset:string;valorParaComarar:string) : boolean;
var i:integer;
var b,acc:string;
begin
 if StrToInt(ContaChar(valorParaComarar,' ')) > 0 then
 begin
  for i := 0 to StrToInt(ContaChar(valorParaComarar,' ')) do
    begin
      if StrToInt(ContaChar(valorParaComarar,' ')) > 0 then
        begin
          acc := (copy(valorParaComarar,1,pos(' ',valorParaComarar) - 1));
          valorParaComarar := copy(valorParaComarar,pos(' ',valorParaComarar) + 1,length(valorParaComarar));
        end
      else acc := valorParaComarar;
     if pos(acc,entradaDataset)>0 then Result:=true
       else result:=false;
    end;
 end
 else
   begin
     if Contido(valorParaComarar,entradaDataset) then result := true
      else Result:= false;
   end;
end;

function tfuncoes.busca(var dataset:tibquery;busca:string;retorno:string;campobusca:string;camposdataset:string):string;
var
 i   :integer;
 lab : TLabel;
begin
  form33 := tform33.Create(self);
  CtrlResize(tform(form33));
  form33.campobusca := campobusca;
  form33.campolocalizaca := retorno;
  form33.campos   := camposdataset;
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
  form33.ShowModal;

  if UpperCase(campobusca) = 'CODMOV' then lab.Free;
  dataset.Close;
  result := retornobusca;
  form33.Free;
 // a.Close;
 // a.free;
end;



function tfuncoes.localizar(titulo:string;tabela:string;campos:string;retorno:string;esconde:string;localizarPor:string;OrdenarPor:string;editLocaliza:boolean;editavel:boolean;deletar:boolean;condicao:string;tamanho:integer;compnenteAlinhar: TObject):string;
var pRect:TRect;
begin
  Form7 := Tform7.Create(Self);
  if tamanho<>0 then form7.Width:=tamanho;
  //alinhar em baixo do componente
  if compnenteAlinhar <> nil then
   begin
    if tabela = 'contaspagar' then
      begin
        form7.Position := poScreenCenter;
      end
    else
      begin
        GetWindowRect(tedit(compnenteAlinhar).Handle,pRect);
        pRect.Top := pRect.Top + 21;
        form7.Top := pRect.Top;
        if pRect.Left + form7.Width > Screen.Width then form7.Left := Screen.Width - form7.Width
         else form7.Left := pRect.Left;
      end;
   end
  else
   begin
     form7.Position := poScreenCenter;
   end;
  form7.tabela        := tabela;
  form7.campos        := campos;
  form7.Caption       := titulo;
  form7.campolocaliza := localizarPor;
  form7.ordem         := OrdenarPor;
  form7.retorno       := retorno;
  form7.editalvel     := editavel;
  form7.deletar       := deletar;
  form7.formulario    := self;
  form7.esconde       := esconde;
  form7.condicao      := condicao;
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
  form7.Free;
  result := retornoLocalizar;
  retornoLocalizar := '';
end;

function tfuncoes.localizar1(titulo:string;tabela:string;campos:string;retorno:string;esconde:string;localizarPor:string;OrdenarPor:string;editLocaliza:boolean;editavel:boolean;deletar:boolean;campoLocate:string;keyLocate: String;tamanho:integer;compnenteAlinhar: TObject):string;
var pRect:TRect;
begin
  Form7 := Tform7.Create(Self);
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
  form7.formulario:=self;
  form7.esconde:=esconde;
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
  Form7.Free;
  result := retornoLocalizar;
  retornoLocalizar := '';
end;




procedure tfuncoes.ResizeForms;
var i:integer;
begin
  for i:=0 to Application.ComponentCount-1 do
    begin
      if Assigned(Application.Components[i]) then
        begin
          //if Application.Components[i] is TForm then CtrlResize(tform(Application.Components[i].GetParentComponent));
        end;
    end;
end;

procedure tfuncoes.CharSetRichEdit(var rich:TRichEdit);
var
   i : longint;
begin
  Rich.Font.Name := 'Terminal';
  Rich.Font.Size := 9;
  Rich.Font.Charset := OEM_CHARSET;
  Rich.DefAttributes.Name := 'Terminal';
  Rich.DefAttributes.Size := 9;
  Rich.DefAttributes.Charset := OEM_CHARSET;
  Rich.SelAttributes := Rich.DefAttributes;
  i := SendMessage(Rich.Handle, EM_GETLANGOPTIONS, 0, 0);
  i := i and not IMF_AUTOFONT;
  SendMessage(Rich.Handle, EM_SETLANGOPTIONS, 0, i);
end;


function tfuncoes.PosFinal(substr:string;Texto:string):integer;
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

function tfuncoes.ContaChar(estring:string;sub:string):string;
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

Function tfuncoes.ConverteNumerico(valor:string):string;
var i:integer;
begin
  //valor:=FormatCurr('##.###0.00',strtocurr(valor));
  if (valor<>'') then begin
  for i:=1 to length(valor) do
  begin
    if (valor[i]='.') and not ( (i=length(valor)-1) or (i=length(valor)-2) or (i=length(valor)-3)) then  delete(valor,i,1);
    if (valor[i]='.') and ( (i=length(valor)-1) or (i=length(valor)-2) or (i=length(valor)-3)) then valor[i]:=',';
  end;
  result:=valor;
  end
   else result:='0';
end;

procedure tfuncoes.FormataCampos(query:Tibquery;qtdCasasDecimais:integer;CampoFormatoDiferente:string;qtd:integer);
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


procedure tfuncoes.OrdenaCamposVenda(campos:string);
var i, fim:integer;
var nomeCampo:TStringList;
begin
  i := 1;
  nomeCampo:= TStringList.Create;
  nomecampo.Add('0=cod');
  nomecampo.Add('1=descricao');
  nomecampo.Add('2=preco');
  nomecampo.Add('3=estoque');
  nomecampo.Add('4=unid');
  nomecampo.Add('5=codbar');
  nomecampo.Add('6=aplicacao');
  nomecampo.Add('7=' + refori1);
  nomecampo.Add('8=localizacao');
  nomecampo.Add('9=deposito');

  fim := length(campos) + 1;

  while i <> fim do
    begin
      dm.produto.FieldByName(nomeCampo.Values[campos[i]]).Index := i;
      i := i + 1;
    end;

  nomeCampo.Free;  
end;

function tfuncoes.BuscaNomeBD(var query:tibquery;NomeCampo:string;NomeTabela:string;condicao:string) : string;
begin
  query.SQL.Clear;
  query.SQL.Add('select '+NomeCampo+' from '+NomeTabela+' '+condicao);
  try
   query.Open;
  except
  end;

  if query.IsEmpty then Result:='Desconhecido'
    else  Result:= query.fieldbyname(NomeCampo).AsString;
  query.Close;
end;

function tfuncoes.PerguntasRel(var query:tibquery;paramper:string;paramverifica:boolean;valorbd:string;valorstring:string) : boolean;
//var grupo,fornec,fabric:string;
var test:boolean;
begin
if not(paramverifica) then
begin
  if Contido('1',paramper) then form2.grupo :=  funcoes.dialogo('generico',0,'1234567890'+#8,0,false,'','Control For Windows','Se Deseja Separação por GRUPO, Informe um Cód.:','') ;
  if Contido('2',paramper) then if form2.grupo<>'*' then form2.fornec :=funcoes.dialogo('generico',0,'1234567890'+#8,0,false,'','Control For Windows','Se Deseja Separação por FORNECEDOR, Informe um Cód.:','') ;
  if Contido('3',paramper) then if  not Contido('*',form2.grupo+form2.fornec)  then form2.fabric := funcoes.dialogo('generico',0,'1234567890'+#8,0,false,'','Control For Windows','Se Deseja Separação por FABRICANTE, Informe um Cód.:','') ;
end
 else
   begin
     if not Contido('*',form2.fabric+form2.fornec+form2.grupo) and paramverifica then
       begin
         result:=true;
         if Contido('3',paramper) then
         begin
         if (form2.fabric<>'')  then
           begin
            if query.FieldByName('fabric').AsString=form2.fabric  then
              begin
                result:=true;
              end
             else
               begin
                 result:=false;
               end;
           end;
           end;
         end;

         if Contido('1',paramper) then
         begin
         if Result then
         begin
         if (form2.grupo<>'')  then
           begin
            if query.FieldByName('grupo').AsString=form2.grupo  then
              begin
                result:=true;
              end
            else
              begin
               result:=false;
              end;
           end;
         end;
         end;

        if Contido('2',paramper) then
         begin
        if Result then
        begin
        if (form2.fornec<>'') then
           begin
            if query.FieldByName('fornec').AsString=form2.fornec  then
              begin
                 result:=true;
              end
             else
               begin
               result:=false;
               test:=false;
              end;
           end;

         end;
       end;

          if paramper='' then
         begin
          if (form2.fornec='') and (form2.fabric='') and (form2.grupo='') then
            begin
              result:=true;
            end;
         end;
        end;
end;

function Tfuncoes.Contido(substring:string;texto:string):boolean;
begin
  if Pos(substring,texto ) > 0 then result:=true
    else result:=false;
end;

function Contido(substring:string;texto:string):boolean;
begin
  if Pos(substring,texto ) > 0 then result:=true
    else result:=false;
end;


procedure TFuncoes.ExecFile(F: String);
var
r: String;
begin
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
end;



function tfuncoes.grelatoriocima(SQLGrupo:string;SQLFornec:string;SQLFabric:string;SQLCom2Filtros:string;SQLSemFiltros:string;cabecalho:string;NomeDaEmpresa:string;NomeDoRelatorio:string;colunas:string):boolean;
var grupo,fornec,fabric:string;
begin
 grupo := funcoes.dialogo('generico',0,'1234567890'+#8,0,false,'','Control For Windows','Se Deseja Separação por GRUPO, Informe um Cód.:','') ;
 if grupo<>'*' then fornec := funcoes.dialogo('generico',0,'1234567890'+#8,0,false,'','Control For Windows','Se Deseja Separação por FORNECEDOR, Informe um Cód.:','') ;
 if  not Contido('*',grupo+fornec) and  (SQLFabric<>'') then fabric := funcoes.dialogo('generico',0,'1234567890'+#8,0,false,'','Control For Windows','Se Deseja Separação por FABRICANTE, Informe um Cód.:','') ;
   //funcoes.GeraRelatorio('tabela','a');

    //verifica se o grupo nao é branco para poder filtrar por grupo
          if (grupo<>'') and (fornec='') and not Contido('*',fornec+grupo+fabric)  then
             begin
               dm.ProdutoQY.SQL.Clear;
               dm.ProdutoQY.SQL.Add(SQLGrupo);
               dm.ProdutoQY.ParamByName('grupo').AsInteger:=StrToInt(grupo);
               dm.ProdutoQY.Open;
             end;

          if (fornec<>'') and  (grupo='') and not Contido('*',fornec+grupo+fabric) then
             begin
               dm.ProdutoQY.SQL.Clear;
               dm.ProdutoQY.SQL.Add(SQLFornec);
               dm.ProdutoQY.ParamByName('fornec').AsInteger:=StrToInt(fornec);
               dm.ProdutoQY.Open;
             end;

          if (fabric<>'') and (grupo='') and (fornec='') and not Contido('*',fornec+grupo+fabric) then
             begin
               dm.ProdutoQY.SQL.Clear;
               dm.ProdutoQY.SQL.Add(SQLFabric);
               dm.ProdutoQY.ParamByName('fabric').AsInteger:=StrToInt(fornec);
               dm.ProdutoQY.Open;
             end;

           if (fornec<>'') and (grupo<>'')and (fabric<>'') and not Contido('*',fornec+grupo+fabric) then
             begin
               dm.ProdutoQY.SQL.Clear;
               dm.ProdutoQY.SQL.Add(SQLCom2Filtros);
               dm.ProdutoQY.ParamByName('grupo').AsInteger:=StrToInt(grupo);
               dm.ProdutoQY.ParamByName('fornec').AsInteger:=StrToInt(fornec);
               dm.ProdutoQY.Open;
             end;

             if (fornec='') and (grupo='') and (fabric='')  then
             begin
               dm.ProdutoQY.Close;
               dm.ProdutoQY.SQL.Clear;
               dm.ProdutoQY.SQL.Add(SQLSemFiltros);
               dm.ProdutoQY.Open;
             end;


           if not Contido('*',fornec+grupo+fabric) then
             begin
               dm.ProdutoQY.FetchAll;
               //form19.RichEdit1.Clear;
               if cabecalho<>'' then
                 begin
                   form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((cabecalho))));
                 end
               else
                 begin
                   form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.RelatorioCabecalho(NomeDaEmpresa,NomeDoRelatorio,80)))));
                   if colunas<>'' then
                     begin
                       form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((colunas+#13+#10))));
                       form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('',#13+#10,'-',80)))));
                     end;
                   //form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar(())));

                 end;
               end;
              if Contido('*',fornec+grupo+fabric) then result:=true
                else result:=false;
end;

procedure tfuncoes.ResizeLabel(var Sender: TLabel);
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

  //sender.Width := trunc((totwi * sender.Width) + Sender.Width);//Round((TWinControl(Components[i]).Width * wi) div iWidth); //Canvas.TextWidth(TLabel(Components[i]).Caption);
  //sender.Height := trunc((tothe * sender.Height) + sender.Height);//Round((TWinControl(Components[i]).Height * he) div iHeight);  // Canvas.TextHeight(TLabel(Components[i]).Caption)+6;
//  b := TLabel(Components[i]).Font.Size;
  sender.Font.Size := trunc(((totwi / tothe) * sender.Font.Size)); //trunc((totwi * b) + b);;// Round((b * Screen.Width) div iWidth);// Round(TWinControl(Components[i]).Width / (Screen.Width / iWidth));;

 // sender.Left := trunc((sender.Left * wi) div iWidth);//Round((TWinControl(Components[i]).Left * wi) div iWidth);
 // sender.Top := trunc((sender.Top * he) div iHeight);
end;


procedure tfuncoes.CtrlResize(var Sender: TForm);
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
          if Components[i] is TWinControl then
            begin
              TWinControl(Components[i]).Width := trunc(TWinControl(Components[i]).Width * (wi / iWidth));
              TWinControl(Components[i]).Height := Round(TWinControl(Components[i]).Height * (he / iHeight));
              TWinControl(Components[i]).Left := Round(TWinControl(Components[i]).Left * (wi / iWidth));
              TWinControl(Components[i]).Top := Round(TWinControl(Components[i]).Top * (he / iHeight));
            end
          else
            begin
              if Components[i] is TLabel then
               begin
                TLabel(Components[i]).Width := trunc((totwi / tothe) * TLabel(Components[i]).Width);//Round((TWinControl(Components[i]).Width * wi) div iWidth); //Canvas.TextWidth(TLabel(Components[i]).Caption);
                TLabel(Components[i]).Height := trunc((totwi / tothe) * TLabel(Components[i]).Height);//Round((TWinControl(Components[i]).Height * he) div iHeight);  // Canvas.TextHeight(TLabel(Components[i]).Caption)+6;
                b := TLabel(Components[i]).Font.Size;
                TLabel(Components[i]).Font.Size := trunc((totwi / tothe) * b);//trunc((totwi * b) + b);;// Round((b * Screen.Width) div iWidth);// Round(TWinControl(Components[i]).Width / (Screen.Width / iWidth));;

                TLabel(Components[i]).Left := trunc((TWinControl(Components[i]).Left * wi) div iWidth);//Round((TWinControl(Components[i]).Left * wi) div iWidth);
                TLabel(Components[i]).Top := trunc((TWinControl(Components[i]).Top * he) div iHeight);
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


function Tfuncoes.RelatorioCabecalho(NomeEmpresa:string;NomeRelatorio:string;tamanho:integer):string;
var v1:string;
begin
  v1 := CompletaOuRepete('',#13+#10,'-',tamanho+2);
  v1 := v1 + CompletaOuRepete(NomeEmpresa,'DATA: '+FormatDateTime('dd/mm/yy',form22.datamov)+#13+#10,' ',tamanho+2);
  v1 := v1 + CompletaOuRepete(NomeRelatorio,'HORA: '+FormatDateTime('tt',now)+#13+#10,' ',tamanho+2);
  v1 := v1 + CompletaOuRepete('',#13+#10,'-',tamanho+2);
  Result := v1;
end;

function Tfuncoes.CompletaOuRepete(const valorParaCompletar:AnsiString;const ValorFinal:AnsiString;valorParaRepetir:string;contadorDeRepeticao:integer):string;
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
          acc := funcoes.CompletaOuRepete('', '', '*', contadorDeRepeticao);//'*****';
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
          acc := funcoes.CompletaOuRepete('', '', '*', contadorDeRepeticao);//'*****';
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


function Tfuncoes.LerFormPato(index:integer; label1 : string; escSair : boolean; const padrao : string = '') : string;
begin
 form18 := tform18.Create(self);
 form18.option := 0;
 form18.escSair := escSair;
 if label1 = '' then
   begin
     form18.Label1.Visible := false;
     form18.ListBox1.Align := alClient;
   end
 else
   begin
      form18.Label1.Caption := label1;
   end;
 funcoes.CtrlResize(tform(form18));
 funcoes.ResizeLabel(form18.Label1);
 form18.valorlistbox := index;
 form18.padrao := padrao;
 form18.ShowModal;
 form18.Free;
 result := formpato;
end;

procedure informacao(posicao:integer;total:integer;informacao:string;novo:boolean;fechar:boolean;valorprogressao:integer);
begin
 if novo then
   begin
     form23.Label1.Caption := informacao;
     form23.Show;
     form23.ProgressBar1.Position := 0;
     form23.ProgressBar1.Max      := 100;
     form23.vezes                 := valorprogressao;
     exit;
   end;

  if fechar then
    begin
      Form23.Close;
      exit;
    end;

  Application.ProcessMessages;
  if trunc(posicao/(total/100)) >= form23.vezes then
    begin
      form23.ProgressBar1.Position := trunc(posicao/(total/100));
      form23.vezes := form23.vezes + valorprogressao;
    end;
 // form23.Update;
       //form23.Refresh;
end;

procedure Tfuncoes.informacao(posicao:integer;total:integer;informacao:string;novo:boolean;fechar:boolean;valorprogressao:integer);
begin
 if novo then
   begin
     form23.Label1.Caption := informacao;
     form23.Show;
     form23.ProgressBar1.Position := 0;
     form23.ProgressBar1.Max      := 100;
     form23.vezes                 := valorprogressao;
     exit;
   end;

  if fechar then
    begin
      Form23.Close;
      exit;
    end;

  Application.ProcessMessages;
  if trunc(posicao/(total/100)) >= form23.vezes then
    begin
      form23.ProgressBar1.Position := trunc(posicao/(total/100));
      form23.vezes := form23.vezes + valorprogressao;
    end;
 // form23.Update;
       //form23.Refresh;
end;
{
function Tfuncoes.DadosProgres(valor:integer,fator:integer);
var s1,s2:integer;
begin
  if fator='' then
    begin
      if length(IntToStr(valor))=5 then s1:=
    end;
end;
     }




function Tfuncoes.dialogo(tipo:string;maxlengt : integer;ValorEntrada:string;tamanhocampo:integer;obrigatorio1:boolean;trocaletras:string;titulo:string;label1:string;default:string):string;
begin
//se TIPO = NORMAL entao maxlength sera o minimo de caracteres que ira aceitar
  pergunta1 := Tpergunta1.Create(Self);
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
  if tipo='numero' then valordg := ConverteNumerico(valordg);
  result := valordg;
  valordg := '' ;
  pergunta1.DestroyComponents;
  pergunta1.Destroy;
end;

function dialogo(tipo:string;maxlengt : integer;ValorEntrada:string;tamanhocampo:integer;obrigatorio1:boolean;trocaletras:string;titulo:string;label1:string;default:string):string;
begin
//se TIPO = NORMAL entao maxlength sera o minimo de caracteres que ira aceitar
  pergunta1 := Tpergunta1.Create(application);
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
  if tipo='numero' then funcoes.valordg := ConverteNumerico(funcoes.valordg);
  result := funcoes.valordg;
  funcoes.valordg := '' ;
  pergunta1.DestroyComponents;
  pergunta1.Destroy;
end;

function tfuncoes.TiraOuTrocaSubstring(StringDeEntrada:string;ValorTrocar:string;ValorQSeraSubstituido:string):string;
begin
result := StringReplace(StringDeEntrada,ValorTrocar,ValorQSeraSubstituido,[]);
end;

function Tfuncoes.LerIni(valor:string):string;
var arq:TIniFile;
var base:string;
begin
  base:=GetCurrentDir;
  base:=base+'\config.ini';
  arq := TIniFile.Create(base);
  Result:=arq.ReadString('CONFIG',valor,'');
  arq.Free;
end;



function Tfuncoes.LerIniToStringList:TStringList;
var arq:TIniFile;
var base:string;
var arr:TStringList;
begin
  arr:=TStringList.Create;
  base:=GetCurrentDir;
  base:=base+'\config.ini';
  arq := TIniFile.Create(base);

  arq.ReadSectionValues('CONFIG',arr);

  arq.Free;
  end;

function Tfuncoes.LerValorPGerais(NomeConfig:string;arr:TStringList):string;
begin
  Result := arr.Values[NomeConfig];
end;

function Tfuncoes.VerSeExisteConfig:boolean;
var arq:TIniFile;
var base:string;
begin
  base:=GetCurrentDir;
  base:=base+'\config.ini';
  arq := TIniFile.Create(base);

  result:=arq.SectionExists('CONFIG');
  arq.Free;
end;

function Tfuncoes.ArredondaFinanceiro(Value: Currency; Decimals: integer): Currency;
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

function Tfuncoes.ArredondaTrunca(Value: Currency;decimais:integer): Extended;
begin
  Result := Trunca(Value, decimais);
  exit;
  
  if decimais = 2 then Result := trunc(value * 100)/100
     else Result := trunc(value * 1000)/1000;
end;

function Tfuncoes.novocod(gen: string) : string;
begin
  dm.IBQuery1.SQL.Clear;
  dm.IBQuery1.SQL.add('select gen_id('+gen+',1) as cod from RDB$DATABASE');
  dm.IBQuery1.Open;
  Result:=dm.IBQuery1.fieldbyname('cod').AsString;
  dm.IBQuery1.Close;
  dm.IBQuery1.SQL.Clear;
end;

function Tfuncoes.PreparaData(Valor: string): TDateTime;
   var dat: TDateTime;
 begin
    dat:=StrToDate(valor);
    valor:=FormatDateTime('dd/mm/yyyy', dat);
    Result := StrToDateTime(Valor);
 end;





procedure Tfuncoes.FormCreate(Sender: TObject);
begin
    Simbolos[1] := 'ABCDEFGHIJLMNOPQRSTUVXZYWK abcdefghijlmnopqrstuvxzywk1234567890-+=_?/.,<>;:)(*&^%$#@!~áäà';
    Simbolos[2] := 'ÂÀ©Øû×ƒçêùÿ5Üø£úñÑªº¿®¬¼ëèïÙýÄÅÉæÆôÁáâäàåíóÇüé¾¶§÷ÎÏ-+ÌÓß¸°¨·¹³²Õµþîì¡«½WDX2U3BHJKMSZDTQ4';
    //WebBrowser1.Navigate('http://www.slashmanxd.xpg.com.br/emp.txt');

{    if ConfParamGerais[5] = 'S' then //usar recursos de Auto Peças
      begin                          // Gera CDS temporários de equivalências
        Timer1.Enabled := true;
      end;}
  enviandoCupom := false;
  inicio1 := 1;    
end;

procedure Tfuncoes.WebBrowser1DocumentComplete(Sender: TObject;
  const pDisp: IDispatch; var URL: OleVariant);
begin
  Timer2.Enabled := false;
  pergunta1.Close;
end;

procedure Tfuncoes.Timer1Timer(Sender: TObject);
begin
  Timer1.Enabled := false;
  //abreDataSetMemoriaEquivalencias();
end;

function Tfuncoes.checaCodbar1(vx_cod : String) : String;
var
 ut : string;
 vx_ta, vx_soma, vx_ret, vx_i : integer;
 vx_cal : variant;
begin
  Result := '';
  try
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

  if vx_cod = ut then Result := 'T';
  except
  end;
end;

function Tfuncoes.allTrim(const texto : String) : String;
begin
  Result := '';
  Result := StringReplace(texto, ' ', '', [rfReplaceAll, rfIgnoreCase]);
end;

procedure Tfuncoes.Timer3Timer(Sender: TObject);
begin
  buscaTimer     := '';
  Timer3.Enabled := false;
end;

procedure Tfuncoes.lerDestXML(const arqXML : String; var mat : TStringList);
begin

end;

function Tfuncoes.verValorUnidade(unidade : String) : currency;
begin
  Result := StrToCurrDef(strnum1(unidade), 1);
  if Result = 0 then Result := 1;
end;

function ACHA_CODFORNEC(CPF_CNPJ, UF : String) : String;
begin
  Result := '000001';
  if Length(CPF_CNPJ) = 14      then CPF_CNPJ := formataCNPJ(CPF_CNPJ)
  else if Length(CPF_CNPJ) = 11 then CPF_CNPJ := formataCNPJ(CPF_CNPJ)
  else
    begin
      exit;
    end;

  dm.IBQuery2.Close;
  dm.IBQuery2.SQL.Text := 'select cnpj, cod from fornecedor where cnpj = :cnpj';
  dm.IBQuery2.ParamByName('cnpj').AsString := CPF_CNPJ;
  dm.IBQuery2.Open;

  if dm.IBQuery2.IsEmpty then
    begin
      dm.IBQuery2.Close;
      exit;
    end;

  Result := dm.IBQuery2.fieldbyname('cod').AsString;
  dm.IBQuery2.Close;
end;

function Tfuncoes.downloadNFE(chave : String) : boolean;
begin
  
end;

procedure Tfuncoes.WriteToTXT(const arquivo, linha : string);
var
  F : textfile;
begin
  AssignFile(F, arquivo);
  if not FileExists(arquivo) then Rewrite(F)
    else Append(F);
  WriteLn(F, linha);
  CloseFile(F);
end;

function Tfuncoes.insereDadosAdic(const xml : String) : smallint;
var
  tipo, serie, cfop, tipofrete, fornec : string;
  fe, te : TStringList;
begin
  Result := 0;
  ///verFornecedorStringList
  fe := funcoes.dadosAdicSped(xml);
  fe[10] := COPY(StrNum(fe[10]), 1, 44);

  dm.IBselect.Close;
  dm.IBselect.SQL.Text := 'select CHAVENFE from SPEDDADOSADIC where CHAVENFE = :cod';
  dm.IBselect.ParamByName('cod').AsString := StrNum(fe[10]);
  dm.IBselect.Open;

  if not dm.IBselect.IsEmpty then
    begin
      Result := 1;
      MessageDlg('Já Existe Dados Adicionais com essa Chave.', mtError, [mbOK], 0);
      dm.IBselect.Close;
      fe.Free;
      exit;
    end;

  dm.IBselect.Close;  
  tipo := Le_Nodo('emit', xml);
  tipo := IfThen(Contido('CNPJ', tipo), Le_Nodo('CNPJ', tipo), Le_Nodo('CPF', tipo));

  fornec := cadastraFornec(xml);

  dm.IBQuery1.Close;
  dm.IBQuery1.SQL.Clear;
  dm.IBQuery1.SQL.Add('update or insert into SPEDDADOSADIC(nota, fornec, tipo, serie, cfop, tipofrete, totseg, totdesc, TOTDESCNT' +
  ', TOTDESPACES, TOTPIS, TOTCONFINS, CREDICMS, CHAVENFE, TOTFRETE) values(:nota, :fornec, :tipo, :serie, :cfop, :tipofrete, :totseg,' +
  ' :totdesc, :TOTDESCNT, :TOTDESPACES, :TOTPIS, :TOTCONFINS, :CREDICMS, :CHAVENFE, :TOTFRETE) matching(CHAVENFE)');
  dm.IBQuery1.ParamByName('nota').AsString          := fe[12];
  dm.IBQuery1.ParamByName('fornec').AsString        := fornec;
  dm.IBQuery1.ParamByName('tipo').AsString          := fe[0];
  dm.IBQuery1.ParamByName('serie').AsString         := fe[1];
  dm.IBQuery1.ParamByName('cfop').AsString          := fe[2];
  dm.IBQuery1.ParamByName('tipofrete').AsString     := fe[3];
  dm.IBQuery1.ParamByName('totseg').AsCurrency      := StrToCurr(fe[4]);
  dm.IBQuery1.ParamByName('totdesc').AsCurrency     := StrToCurr(fe[5]);
  dm.IBQuery1.ParamByName('TOTDESCNT').AsCurrency   := 0;
  dm.IBQuery1.ParamByName('TOTDESPACES').AsCurrency := StrToCurr(fe[6]);
  dm.IBQuery1.ParamByName('TOTPIS').AsCurrency      := StrToCurr(fe[7]);
  dm.IBQuery1.ParamByName('TOTCONFINS').AsCurrency  := StrToCurr(fe[8]);
  dm.IBQuery1.ParamByName('CREDICMS').AsCurrency    := 0;
  dm.IBQuery1.ParamByName('CHAVENFE').AsString      := StrNum(fe[10]);
  dm.IBQuery1.ParamByName('TOTFRETE').AsCurrency    := StrToCurr(fe[11]);
  dm.IBQuery1.ExecSQL;

  dm.IBQuery1.Transaction.Commit;

  ShowMessage('Dados Adicionais Inserido com Sucesso!' + #13 +
  'Nota: '       + fe[12] + #13 +
  'Fornec: '     + fornec + #13 +
  'Tipo:'        + fe[0] + #13 +
  'Série: '      + fe[1] + #13 +
  'CFOP: '       + fe[2] + #13 +
  'Tipo Frete: ' + fe[3] + #13 +
  'Fornecedor: ' + fornec);
  fe.Free;
end;

function tfuncoes.cadastraFornec(const xml : String) : String;
var
  te  : TStringList;
  cod : String;
begin
  te := verFornecedorStringList(xml);

  dm.IBselect.Close;
  dm.IBselect.SQL.Clear;
  dm.IBselect.SQL.Add('select cod from FORNECEDOR where cnpj = :cnpj' );
  dm.IBselect.ParamByName('cnpj').AsString := te[0];
  dm.IBselect.Open;

  cod := '0';

  if not dm.IBselect.IsEmpty then
    begin
      cod := dm.IBselect.fieldbyname('cod').AsString;
    end
  else
    begin
      cod := Incrementa_Generator('FORNECEDOR', 1);
    end;

  Result := cod;
  dm.IBselect.Close;

  dm.IBQuery4.Close;
  dm.IBQuery4.SQL.Clear;
  dm.IBQuery4.SQL.Add('update or insert into FORNECEDOR(cod, nome, endereco, cep, fone, cidade, estado, bairro, cnpj,'  +
  'ies, cod_mun, tipo) values(:cod, :nome, :endereco, :cep, :fone, :cidade, :estado, :bairro, :cnpj,'  +
  ':ies, :cod_mun, :tipo)' );
  dm.IBQuery4.ParamByName('cod').AsString      := cod;
  dm.IBQuery4.ParamByName('nome').AsString     := copy(te[1], 1, 40);
  dm.IBQuery4.ParamByName('endereco').AsString := copy(te[3], 1, 40);
  dm.IBQuery4.ParamByName('cep').AsString      := copy(te[8], 1, 10);
  dm.IBQuery4.ParamByName('fone').AsString     := copy(te[11], 1, 14);
  dm.IBQuery4.ParamByName('cidade').AsString   := copy(te[6], 1, 14);
  dm.IBQuery4.ParamByName('estado').AsString   := te[7];
  dm.IBQuery4.ParamByName('bairro').AsString   := copy(te[4], 1, 25);
  dm.IBQuery4.ParamByName('cnpj').AsString     := te[0];
  dm.IBQuery4.ParamByName('ies').AsString      := copy(te[12], 1, 14);
  dm.IBQuery4.ParamByName('cod_mun').AsString  := te[5];
  dm.IBQuery4.ParamByName('tipo').AsString     := te[14];
  dm.IBQuery4.ExecSQL;
  dm.IBQuery4.Transaction.Commit;

  //reStartGenerator('fornecedor', StrToInt(cod));
  te.Free;
end;

function Tfuncoes.entraXMLeRetornaChave(ent : String) : string;
var
  tmp : string;
begin
  tmp := Le_Nodo1('infNFe', ent);
  tmp := copy(tmp, pos('Id="', tmp) + 7, pos('">', tmp));
  tmp := copy(tmp, 1, pos('">', tmp) - 1);
  Result := '';
  Result := tmp;
end;

function Tfuncoes.acha_vendaCCF(const ccf_caixa : String) : String;
begin
  Result := '';
  dm.IBselect.Close;
  dm.IBselect.SQL.Text := 'select nota from venda where crc = :crc';
  dm.IBselect.ParamByName('crc').AsString := ccf_caixa;
  dm.IBselect.Open;

  if not dm.IBselect.IsEmpty then Result := dm.IBselect.fieldbyname('nota').AsString;
  dm.IBselect.Close;
end;

function Tfuncoes.buscaProdutoCodCodBar(const cod : String) : String;
begin
  Result := '';
  if length(cod) < 7 then
    begin
      dm.IBselect.Close;
      dm.IBselect.SQL.Text := 'select cod, quant, deposito, nome from produto where cod = :cod';
      dm.IBselect.ParamByName('cod').AsString := cod;
      dm.IBselect.Open;

      if not dm.IBselect.IsEmpty then
         Result := dm.IBselect.fieldbyname('cod').AsString;
    end
  else
    begin
      dm.IBselect.Close;
      dm.IBselect.SQL.Text := 'select p.cod, p.quant, p.deposito, p.nome from produto p left join codbarras c on (c.cod = p.cod) where (p.codbar = '+ QuotedStr( cod )+') or (c.codbar = '+QuotedStr( cod )+')';
      dm.IBselect.Open;

      if not dm.IBselect.IsEmpty then
       Result := dm.IBselect.fieldbyname('cod').AsString;
    end;

  //ShowMessage(Result);
  //dm.IBselect.close;
end;

procedure Tfuncoes.adicionaRegistroDataBloqueio(const mostraMensagem, adicionaBloqueio  : boolean; var dias : integer; var quer : TIBQuery; buscaDiasSite : boolean = false);
var
 too : integer;
 data : TDate;
begin

  quer.Close;
  quer.SQL.Text := 'select * from acesso where (acesso = ''diaBloq'') or (acesso = ''bloq'')';
  quer.Open;

  if quer.IsEmpty then
    begin
      if adicionaBloqueio then
        begin
          quer.Close;
          quer.SQL.Text := 'insert into acesso(acesso, dtr, nfe) values(''bloq'', :data, '+ IntToStr(dias) +')';
          quer.ParamByName('data').AsDate := now;
          quer.ExecSQL;

          quer.Transaction.Commit;

          quer.Close;
          quer.SQL.Text := 'insert into acesso(acesso, dtr, nfe) values(''diaBloq'', :data, '+ IntToStr(dias) +')';
          quer.ParamByName('data').AsDate := now;
          quer.ExecSQL;

          quer.Transaction.Commit;
        end;
    end
  else
    begin
      if buscaDiasSite then
        begin
          quer.Close;
          quer.SQL.Text := 'update acesso set nfe = :nfe where (acesso = ''diaBloq'') or (acesso = ''bloq'')';
          quer.ParamByName('nfe').AsInteger := dias;
          quer.ExecSQL;

          quer.Transaction.Commit;
        end;
    end;

  if mostraMensagem then
    begin
      form58 := tform58.Create(self);

      quer.Close;
      quer.SQL.Text := 'select acesso from acesso where acesso = ''bloq''';
      quer.Open;

      if quer.IsEmpty then
        begin
          quer.Close;
          exit;
        end;

      too := getDiasBloqueioRestantes;

      form58.Label2.Caption := IntToStr(IfThen(too < 0, 0, too)) + ' dias Restantes';
      quer.Close;

      form58.ShowModal;

      if (too < 0) then Application.Terminate;
    end;
end;

function Tfuncoes.buscaDiasBloqueio() : integer;
begin
  dm.IBselect.Close;
  dm.IBselect.SQL.Text := 'select dtr, nfe from acesso where acesso = ''diaBloq''';
  dm.IBselect.Open;

  Result := StrToIntDef( dm.IBselect.fieldbyname('nfe').AsString, diasparabloquear);
end;

procedure Tfuncoes.limpaBloqueado(var quer : TIBQuery);
begin
  dm.IBQuery1.Close;
  dm.IBQuery1.SQL.Text := 'delete from acesso where acesso = ''diaBloq''';
  dm.IBQuery1.ExecSQL;

  dm.IBQuery1.Transaction.Commit;
  dm.IBQuery1.Close;
  dm.IBQuery1.SQL.Text := 'delete from acesso where acesso = ''bloq''';
  dm.IBQuery1.ExecSQL;

  dm.IBQuery1.Transaction.Commit;
end;

procedure TTWThreadVerificaPagamento.Execute;
begin
  if funcoes.verificaConexaoComInternetSeTiverTRUEsenaoFALSE then
    begin
      //SessaoCritica := TCriticalSection.Create;
      try
        funcoes.verificaPermissaoPagamento(false);
      except
      end;
    end;
end;



procedure TTWtheadEnviaCupons1.enviaCupons;
var
  query : TIBQuery;
  forne : String;
  cont, fim : integer;
begin
  query := TIBQuery.Create(Application);
  query.Database := dm.bd;

  query.SQL.Text := 'select nota, chave from NFCE where adic = ''OFF''';
  query.Open;
  query.FetchAll;
  fim := query.RecordCount;
  cont := 0;

  while not query.Eof do
    begin
      cont := cont + 1;
      label1.Caption := IntToStr(cont) + '/' + IntToStr(fim);
      funcoes.enviandoCupom := true;
      try
        //funcoes.Mensagem(Application.Title ,'Aguarde, Enviando NFCe...',15,'Courier New',false,0,clred);
        Application.ProcessMessages;
        Application.ProcessMessages;
        SessaoCritica := TCriticalSection.Create;
        SessaoCritica.Acquire;
        EnviarCupomEletronico2(query.fieldbyname('nota').AsString, forne, false, true, false);
        SessaoCritica.Leave;
      except
        //pergunta1.close;
      end;
      query.Next;
    end;
  funcoes.enviandoCupom := false;
end;

procedure TTWtheadEnviaCupons1.Execute;
begin
  Synchronize(self.enviaCupons);
end;

procedure Tfuncoes.acertarTamanhoDBGRID(var tabela : TDBGrid);
var
  i, acc : integer;
begin
  acc := 0;
  for i:=0 to tabela.Columns.Count-1 do
    begin
       //showme
       acc := acc + tabela.Columns[i].Width;
    end;

  tform(tabela.Owner).Width := acc + 10;
  //tabela.Width := acc;
  //if acc < 299 then self.Width:=acc+10;
end;

{function enviNFCe(const perg : String = '') : boolean;
var
  statu, xmot, cliente, nota : String;
  msg, tpemissao  : integer;
  envi            : boolean;
begin
  envi := true;
  try
    if ConfParamGerais[45] = 'S' then envi := false
      else envi := true;
  except
  end;

  if perg = '' then
    begin
      nota := funcoes.dialogo('not',0,'1234567890'+#8+#32,50,true,'',Application.Title,'Qual a Nota de Venda?','');
      if nota = '*' then exit;
    end
  else nota := perg;

  dm.IBselect.Close;
  dm.IBselect.SQL.Text := 'select nota, cliente from venda where (nota = :nota) and (cancelado = 0)';
  dm.IBselect.ParamByName('nota').AsString := nota;
  dm.IBselect.Open;

  if dm.IBselect.IsEmpty then
    begin
      dm.IBselect.Close;
      ShowMessage('Nota ' + nota + ' Não Encontrada');
      exit;
    end;

  cliente := dm.IBselect.fieldbyname('cliente').AsString;

  dm.IBselect.Close;
  dm.IBselect.SQL.Text := 'select nota, adic from nfce where (nota = :nota)';
  dm.IBselect.ParamByName('nota').AsString := nota;
  dm.IBselect.Open;

  if not dm.IBselect.IsEmpty then
    begin
      if dm.IBselect.FieldByName('adic').AsString = 'OFF' then
        begin
          msg := MessageDlg('Esta NFCe foi emitida em Contigência Offline, Deseja Transmiti-la Agora por meio da Internet?',
                  mtInformation,[mbYes, mbNo, mbCancel],0);
          if msg = idyes then
            begin
              try
                funcoes.Mensagem(Application.Title ,'Aguarde, Enviando NFCe...',15,'Courier New',false,0,clred);
                Application.ProcessMessages;
                Application.ProcessMessages;
                EnviarCupomEletronico(nota, statu, true, false);
              finally
                pergunta1.close;
              end;
            end;
          exit;
        end;

      ShowMessage('A Nota ' +  nota + ' Já foi Transmitida');
      exit;
    end;

  cliente := funcoes.dialogo('generico',0,'1234567890,.'+#8,50,false,'',Application.Title,'Qual o Código do Cliente?',cliente);
  cliente := trim(cliente);

  if  cliente = '*' then exit;
  if (cliente = '') then cliente := funcoes.localizar('Localizar Cliente','cliente','cod,nome,telres,telcom,cnpj as cpfcnpj,bairro','cod','','nome','nome',false,false,false,'',450, nil);
  if (cliente = '*') or (cliente = '') then
    begin
      ShowMessage('Para emitir uma NFCe é necessario um cliente.');
      exit;
    end;

  dm.IBselect.Close;
  dm.IBselect.SQL.Text := 'select cod from cliente where (cod = :cod)';
  dm.IBselect.ParamByName('cod').AsString := cliente;
  dm.IBselect.Open;

  if dm.IBselect.IsEmpty then
    begin
      dm.IBselect.Close;
      ShowMessage('Cliente ' + nota + ' Não Encontrado');
      exit;
    end;


  //if not funcoes.verificaSeExisteVenda(nota) then exit;

  try
    //envi := true;
    funcoes.Mensagem(Application.Title ,'Aguarde, Enviando NFCe...',15,'Courier New',false,0,clred);
    Application.ProcessMessages;
    while true do
      begin

        try
          if EnviarCupomEletronico1(nota, statu, xmot, tpemissao, envi, cliente) then break;
        except
        end;


        if statu = 'OFF' then
          begin
            msg := MessageDlg('Não Houve Comunicação Com Servidor Por Falha Na Conexão E A Nota Não Foi Transmitida.'+chr(10)+chr(13)+
                  'Para Tentar Enviar Novamente, Selecione "SIM" Ou Selecione "NÃO Para Enviar Modo OFFLINE e Transmití-la Mais Tarde.',
                  mtInformation,[mbYes, mbNo, mbCancel],0);
            if msg = IDYES then
              begin

              end
            else if msg = IDNO then
              begin
                dm.ACBrNFe.Configuracoes.Geral.FormaEmissao := teOffLine;
                envi := false;
              end
            else if msg = IDCANCEL then
              begin
                break;
              end;
          end;

        if statu = 'OK' then
          begin
            break;
          end;
      end;
  finally
    pergunta1.Close;
  end;
end;}

function Tfuncoes.verQuntDecimais(const campo, tabela : String) : integer;
begin
end;

procedure LE_CAMPOS(var mat : TStringList;LIN : String;const separador : String; criaMAT : boolean = true);
var
  posi, cont : integer;
  valor : String;
begin
  if criaMAT then mat := TStringList.Create;

  if not Contido(separador, LIN) then
    begin
      mat.Add('0=' + LIN);
      exit;
    end;

  posi := pos(separador, lin) + 1;
  LIN := copy(lin, posi, length(lin));
  mat.Clear;
  cont := -1;

  if not Contido(separador, LIN) then mat.Add('0=' + LIN);

  while true do
    begin
      posi := pos(separador, lin) + 1;
      if ((posi = 0) or (trim(lin) = '')) then break;

      valor := LeftStr(lin, posi - 2);
      cont := cont + 1;
      mat.Add(IntToStr(cont) + '=' + trim(valor));
      if posi = length(lin) then break;
      lin := copy(lin, posi, length(lin));
    end;

  valor := '';
  posi := 0;
  cont := 0;  
end;


procedure completaStringList(var mat : TStringList; qtd : integer);
var
  ini, cont : integer;
begin
  cont := mat.Count;
  for ini := mat.Count to qtd do
    begin
      mat.Add(IntToStr(cont)+ '=');
      cont := cont + 1
    end;
end;


function ContaChar1(estring:string;sub:string): integer;
var
  ini : integer;
begin
  Result := 0;
  for ini := 1 to length(estring) do
    begin
      if estring[ini] = sub then Result := Result +1;
    end;
end;

procedure Tfuncoes.exportaNFCeEmitidas();
var
  ini, fim, num, unidade, csta, tip : string;
  dini, dfim : TDateTime;
  ind, gf, cp, nao : integer;
  cont, tot : Smallint;
  arq, xml : TStringList;
begin
  ini := funcoes.dialogo('data',0,'',2,true,'',Application.Title,'Qual a Data Inicial?', formatadataddmmyy(StartOfTheMonth(form22.datamov)));
  if ini = '*' then exit;

  fim := funcoes.dialogo('data',0,'',2,true,'',Application.Title,'Qual a Data Final?', formatadataddmmyy(endOfTheMonth(form22.datamov)));
  if fim = '*' then exit;

  unidade := funcoes.dialogo('generico',0,'ABCDEFGHIJLMNOPKXYZWQRSTUVXZ',50,false,'S',Application.Title,'Confirme a unidade para Recebimento da Remessa:', ConfParamGerais[33]);
  if unidade = '*' then exit;

  tip := funcoes.dialogo('generico',0,'SNT',50,false,'S',Application.Title,'Emitidas (S), Canceladas (N), Todas (T)', 'T');
  if tip = '*' then exit;

  dini := StrToDateTime(ini);
  dfim := StrToDateTime(fim);

  unidade := unidade + ':\NFCE '+ FormatDateTime('mm-yyyy', dini) +'\';
  funcoes.CriaDiretorio(unidade);

  funcoes.DeleteFolder(unidade + '*.*');

  dm.IBselect.Close;
  if tip = 'T' then
    begin
      dm.IBselect.SQL.Text := 'select chave, adic from nfce where (data >= :ini) and (data <= :fim) ';
      dm.IBselect.ParamByName('ini').AsDate := dini;
      dm.IBselect.ParamByName('fim').AsDate := dfim;
    end
  else
    begin
      dm.IBselect.SQL.Text := 'select chave, adic from nfce where ((data >= :ini) and (data <= :fim) '+ IfThen(tip = 'S', 'and (adic = '''')', 'and (adic = ''CANC'')') +') ';
      dm.IBselect.ParamByName('ini').AsDate := dini;
      dm.IBselect.ParamByName('fim').AsDate := dfim;
    end;

  dm.IBselect.Open;
  dm.IBselect.FetchAll;
  tot  := dm.IBselect.RecordCount;
  cont := 0;
  cp   := 0;
  nao  := 0;

  xml := TStringList.Create;

  funcoes.informacao(0, 0, 'Aguarde, Verificando Arquivos...', true, false, 5);

  while not dm.IBselect.Eof do
    begin
      cont := cont + 1;
      funcoes.informacao(cont, tot, 'Aguarde, Verificando Arquivos...', false, false, 5);
      if FileExists(caminhoEXE_com_barra_no_final + 'NFCe\EMIT\' + dm.IBselect.fieldbyname('chave').AsString + '-nfe.xml') then
        begin
          xml.LoadFromFile(caminhoEXE_com_barra_no_final + 'NFCe\EMIT\' + dm.IBselect.fieldbyname('chave').AsString + '-nfe.xml');
          csta := Le_Nodo('cStat', xml.GetText);
          if dm.IBselect.FieldByName('adic').AsString = 'CANC' then
            begin
              if csta <> '' then
                begin
                  xml.SetText(pchar(substitui_Nodo('cStat', '135', xml.GetText)));
                end;
              xml.SaveToFile(unidade + dm.IBselect.fieldbyname('chave').AsString + '-nfe.xml');
            end
          else
            begin
              if funcoes.Contido(trim(csta), '100-150') then
                begin
                  CopyFile(pchar(caminhoEXE_com_barra_no_final + 'NFCe\EMIT\' + dm.IBselect.fieldbyname('chave').AsString + '-nfe.xml'), pchar(unidade + dm.IBselect.fieldbyname('chave').AsString + '-nfe.xml'), true);
                  cp := cp + 1;
                end;
            end;
        end
      else
        begin
          nao := nao + 1;
        end;

      dm.IBselect.Next;
    end;

   funcoes.informacao(0, 0, 'Aguarde, Verificando Arquivos...', false, true, 5); 
   ShowMessage(strzero(IntToStr(cont), 5) + ' Arquivos Processados' + #13 +strzero(IntToStr(cp), 5) + ' Arquivos Copiados' + #13 + strzero(IntToStr(nao), 5) + ' Arquivos Não Encontrados');
end;

function Tfuncoes.le_configTerminalWindows(posi : integer; padrao : string) : String;
var
  arq : TStringList;
  tmp : string;
begin
  if not FileExists(caminhoEXE_com_barra_no_final + 'config.dat') then
  begin
    criaArqTerminal();
  end;

  arq := TStringList.Create;
  arq.LoadFromFile(caminhoEXE_com_barra_no_final + 'config.dat');
  Result := LerConfig(arq.Values['0'], posi);
  if Result = '' then Result := padrao;
end;

function Tfuncoes.buscaNomeSite() : String;
var
  num : String;
begin
  num := buscaConfigNaPastaDoControlW('Site_Num', '1');
  if num = '1' then Result    := site
  else if num = '2' then Result := site1
  else Result := site2;
end;

procedure Tfuncoes.mostraValorDinheiroTela(const valor : currency);
begin
  form57 := tform57.Create(self);
  form57.Labeldin.Caption := formataCurrency(valor);
  form57.ShowModal;
  form57.Free;
end;

procedure Tfuncoes.ordernaDataSetVenda(const ordem1, valorLocate, sqlVenda : String; var dbgrid99 : TDBGrid; ordem2 : string = ''; ordenaCampos : boolean = true);
var
  orde : String;
begin
  orde := ordem1;
  if orde = '' then orde := 'nome';

  if ordem2 <> '' then orde := ordem2;
  dm.produto.Close;
  dm.produto.SQL.Text := sqlVenda + ' order by ' + orde;
  dm.produto.Open;

  if ordenaCampos then funcoes.OrdenaCamposVenda(ConfParamGerais.Strings[1]);

  if valorLocate <> '' then
    begin
      dm.produto.Locate('cod', valorLocate, []);
    end;

  funcoes.FormataCampos(dm.produto,2,'ESTOQUE',3);
  dbgrid99.SelectedIndex := buscaFieldDBgrid1(orde, dbgrid99);
end;

function tfuncoes.buscaFieldDBgrid(const nome : String; var grid : TDBGrid) : tfield;
var
  ini, fim : integer;
begin
  fim := grid.Columns.Count - 1;
  for ini := 0 to fim do
    begin
      if UpperCase(nome) = UpperCase(grid.Columns.Items[ini].Field.FieldName) then
        begin
          ShowMessage(UpperCase(nome) + #13 + UpperCase(grid.Columns.Items[ini].Field.FieldName));
          Result := grid.Columns.Items[ini].Field;
          exit;
        end;
    end;

  Result := grid.Columns.Items[0].Field;
end;

function tfuncoes.buscaFieldDBgrid1(const nome : String; var grid : TDBGrid) : integer;
var
  ini, fim : integer;
begin
  fim := grid.Columns.Count - 1;
  for ini := 0 to fim do
    begin
      if UpperCase(nome) = UpperCase(grid.Columns.Items[ini].Field.FieldName) then
        begin
          Result := ini;
          exit;
        end;
    end;

  Result := 0;
end;

FUNCTION tfuncoes.VE_CODISPIS(_CODISPIS, _ISPIS : String) : string;
var
  lista, arq : TStringList;
  nome, lin, cod       : String;
  ini, fim : integer;
begin
  lista := TStringList.Create;
  lista.Add('I=TB040314.TXT');
  lista.Add('R=TB040313.TXT');
  lista.Add('M=TB040310.TXT');
  lista.Add('X=TB040315.TXT');
  lista.Add('D=TB040317.TXT');

  nome := lista.Values[trim(_ISPIS)];
  if nome = '' then
    begin
      lista.Free;
      exit;
    end;

  if not FileExists(caminhoEXE_com_barra_no_final + nome) then
    begin
      ShowMessage('Tabela ' + nome + ' Não Encontrada. Consulte o Suporte para Mais Detalhes.');
      lista.Free;
      exit;
    end;

  form33 := tform33.Create(self);
  form33.Caption := 'Tabela de CST PIS/COF';
  form33.ClientDataSet1.FieldDefs.Clear;
  form33.ClientDataSet1.FieldDefs.Add('COD', ftString, 3);
  form33.ClientDataSet1.FieldDefs.Add('DESCRICAO', ftString, 300);
  form33.ClientDataSet1.FieldDefs.Add('DINI', ftDate);
  form33.ClientDataSet1.FieldDefs.Add('DFIM', ftDate);
  form33.ClientDataSet1.FieldDefs.Add('PIS', ftCurrency);
  form33.ClientDataSet1.FieldDefs.Add('COF', ftCurrency);
  form33.ClientDataSet1.CreateDataSet;
  form33.ClientDataSet1.FieldByName('DINI').Visible := false;
  form33.ClientDataSet1.FieldByName('DFIM').Visible := false;
  form33.ClientDataSet1.FieldByName('PIS').Visible := false;
  form33.ClientDataSet1.FieldByName('COF').Visible := false;
  form33.DataSource1.DataSet := form33.ClientDataSet1;
  form33.DBGrid1.DataSource  := form33.DataSource1;
  form33.campobusca := 'cod';

  arq := TStringList.Create;
  arq.LoadFromFile(caminhoEXE_com_barra_no_final + nome);
  form39 := tform39.Create(self);

  fim := arq.Count - 1;
  ini := 0;
  //for ini := 0 to fim do
  while true do
    begin
      if trim(arq[ini]) <> '' then
        begin
          lin := arq[ini];
          form33.ClientDataSet1.Append;
          if Length(StrNum(LeftStr(lin, 3))) = 3 then cod := StrNum(LeftStr(lin, 3));
          form33.ClientDataSet1.FieldByName('COD').AsString := cod;
          if form33.ClientDataSet1.FieldByName('COD').AsString <> '0' then
            begin
              lin := copy(lin, 5, length(lin));
              if Length(StrNum(LeftStr(arq[ini], 3))) = 3 then form33.ClientDataSet1.FieldByName('DESCRICAO').AsString := copy(lin, 1, IfThen(Pos(#9, lin) > 0, Pos(#9, lin), length(lin)))
               else form33.ClientDataSet1.FieldByName('DESCRICAO').AsString := arq[ini];
            end
          else form33.ClientDataSet1.FieldByName('DESCRICAO').AsString := lin;
          form33.ClientDataSet1.Post;
        end;

      if ini = fim then break;
      ini := ini + 1;
    end;

  form33.ClientDataSet1.First;
  form33.ShowModal;
  form33.Free;
  Result := StrNum(retornobusca);
//  Result := IntToStr(StrToIntDef(Result, 0));
  if Result = '0' then Result := '';
end;

function tfuncoes.isCPF(CPF: string): boolean;
var  dig10, dig11: string;
    s, i, r, peso: integer;
begin
  CPF := StrNum(cpf);
// length - retorna o tamanho da string (CPF é um número formado por 11 dígitos)
  if ((CPF = '00000000000') or (CPF = '11111111111') or
      (CPF = '22222222222') or (CPF = '33333333333') or
      (CPF = '44444444444') or (CPF = '55555555555') or
      (CPF = '66666666666') or (CPF = '77777777777') or
      (CPF = '88888888888') or (CPF = '99999999999') or
      (length(CPF) <> 11)) or (StrToIntDef(cpf, 0) = 0)
     then begin
              isCPF := false;
              exit;
            end;

// try - protege o código para eventuais erros de conversão de tipo na função StrToInt
  try
{ *-- Cálculo do 1o. Digito Verificador --* }
    s := 0;
    peso := 10;
    for i := 1 to 9 do
    begin
// StrToInt converte o i-ésimo caractere do CPF em um número
      s := s + (StrToInt(CPF[i]) * peso);
      peso := peso - 1;
    end;
    r := 11 - (s mod 11);
    if ((r = 10) or (r = 11))
       then dig10 := '0'
    else str(r:1, dig10); // converte um número no respectivo caractere numérico

{ *-- Cálculo do 2o. Digito Verificador --* }
    s := 0;
    peso := 11;
    for i := 1 to 10 do
    begin
      s := s + (StrToInt(CPF[i]) * peso);
      peso := peso - 1;
    end;
    r := 11 - (s mod 11);
    if ((r = 10) or (r = 11))
       then dig11 := '0'
    else str(r:1, dig11);

{ Verifica se os digitos calculados conferem com os digitos informados. }
    if ((dig10 = CPF[10]) and (dig11 = CPF[11]))
       then isCPF := true
    else isCPF := false;
  except
    isCPF := false
  end;
end;

Function tfuncoes.testacpf(cpf:string):boolean;
var i:integer;
    Want:char;
    Wvalid:boolean;
    Wdigit1,Wdigit2:integer;
begin
    Result := false;
    if Length(cpf) <> 11 then
      begin
        exit;
      end;
    Wdigit1:=0;
    Wdigit2:=0;
    Want:=cpf[1];//variavel para testar se o cpf é repetido como 111.111.111-11
    Delete(cpf,ansipos('.',cpf),1);  //retira as mascaras se houver
    Delete(cpf,ansipos('.',cpf),1);
    Delete(cpf,ansipos('-',cpf),1);

   //testar se o cpf é repetido como 111.111.111-11
   for i:=1 to length(cpf) do
     begin
       if cpf[i] <> Want then
         begin
            Wvalid:=true;  // se o cpf possui um digito diferente ele passou no primeiro teste
            break
         end;
     end;
       // se o cpf é composto por numeros repetido retorna falso
     if not Wvalid then
       begin
          result:=false;
          exit;
       end;

     //executa o calculo para o primeiro verificador
     for i:=1 to 9 do
       begin
          wdigit1:=Wdigit1+(strtoint(cpf[10-i])*(I+1));
       end;
        Wdigit1:= ((11 - (Wdigit1 mod 11))mod 11) mod 10;
        {formula do primeiro verificador
            soma=1°*2+2°*3+3°*4.. até 9°*10
            digito1 = 11 - soma mod 11
            se digito > 10 digito1 =0
          }

         //verifica se o 1° digito confere
        if IntToStr(Wdigit1) <> cpf[10] then
          begin
             result:=false;
             exit;
          end;


         for i:=1 to 10 do
       begin
          wdigit2:=Wdigit2+(strtoint(cpf[11-i])*(I+1));
       end;
       Wdigit2:= ((11 - (Wdigit2 mod 11))mod 11) mod 10;
         {formula do segundo verificador
            soma=1°*2+2°*3+3°*4.. até 10°*11
            digito1 = 11 - soma mod 11
            se digito > 10 digito1 =0
          }

       // confere o 2° digito verificador
       if IntToStr(Wdigit2) <> cpf[11] then
          begin
             result:=false;
             exit;
          end;

   //se chegar até aqui o cpf é valido
   result:=true;
end;


Function testacpf(cpf:string):boolean;
var i:integer;
    Want:char;
    Wvalid:boolean;
    Wdigit1,Wdigit2:integer;
begin
    Wdigit1:=0;
    Wdigit2:=0;
    Want:=cpf[1];//variavel para testar se o cpf é repetido como 111.111.111-11
    Delete(cpf,ansipos('.',cpf),1);  //retira as mascaras se houver
    Delete(cpf,ansipos('.',cpf),1);
    Delete(cpf,ansipos('-',cpf),1);

   //testar se o cpf é repetido como 111.111.111-11
   for i:=1 to length(cpf) do
     begin
       if cpf[i] <> Want then
         begin
            Wvalid:=true;  // se o cpf possui um digito diferente ele passou no primeiro teste
            break
         end;
     end;
       // se o cpf é composto por numeros repetido retorna falso
     if not Wvalid then
       begin
          result:=false;
          exit;
       end;

     //executa o calculo para o primeiro verificador
     for i:=1 to 9 do
       begin
          wdigit1:=Wdigit1+(strtoint(cpf[10-i])*(I+1));
       end;
        Wdigit1:= ((11 - (Wdigit1 mod 11))mod 11) mod 10;
        {formula do primeiro verificador
            soma=1°*2+2°*3+3°*4.. até 9°*10
            digito1 = 11 - soma mod 11
            se digito > 10 digito1 =0
          }

         //verifica se o 1° digito confere
        if IntToStr(Wdigit1) <> cpf[10] then
          begin
             result:=false;
             exit;
          end;


         for i:=1 to 10 do
       begin
          wdigit2:=Wdigit2+(strtoint(cpf[11-i])*(I+1));
       end;
       Wdigit2:= ((11 - (Wdigit2 mod 11))mod 11) mod 10;
         {formula do segundo verificador
            soma=1°*2+2°*3+3°*4.. até 10°*11
            digito1 = 11 - soma mod 11
            se digito > 10 digito1 =0
          }

       // confere o 2° digito verificador
       if IntToStr(Wdigit2) <> cpf[11] then
          begin
             result:=false;
             exit;
          end;

   //se chegar até aqui o cpf é valido
   result:=true;
end;

procedure tfuncoes.dbgrid1Registro(var dbgrid44 : TDBGrid);
var
  ini, fim : integer;
begin
  ini := dbgrid44.DataSource.DataSet.RecNo;
  keybd_event(VK_NEXT, 0, 0, 0);
  //dm.abortarScroll := true;
  dbgrid44.DataSource.DataSet.RecNo := ini;
  dm.abortarScroll := false;
  exit;
  {for ini := 0 to fim do
    begin
      keybd_event(VK_DOWN, 0, 0, 0);
      Application.ProcessMessages;
    end;}

  SendMessage(DbGrid1.Handle,WM_VSCROLL,SB_Lineup,0);
  dbgrid44.DataSource.DataSet.EnableControls;
end;


procedure Tfuncoes.adicionaRegistrosBloqueio();
var
  ini : integer;
begin
  dm.IBQuery1.Close;

  dm.IBQuery1.SQL.Text := 'update or insert into acesso(acesso, dtr) values(''bloq'', :data) matching(acesso)';
  dm.IBQuery1.ParamByName('data').AsDate := form22.datamov - 50;
  dm.IBQuery1.ExecSQL;

  dm.IBQuery1.Transaction.Commit;
end;

procedure Tfuncoes.aumentaFonte(formula : TForm; dbgridr : boolean; opcao : integer; redimensionar : boolean = false);
var
  ini, fim, tu, idx, acc : integer;
  fi : Smallint;
  form : String;
  arq : TStringList;
  tamDBGR, tam : String;
begin
  {OPCAO
   0 - ler
   1 - aumenta
   2 - diminui
  }

  arq := TStringList.Create;
  if FileExists(caminhoEXE_com_barra_no_final + 'fonte.dat') then
    begin
      arq.LoadFromFile(caminhoEXE_com_barra_no_final + 'fonte.dat');
    end
  else
    begin
      arq.SaveToFile(caminhoEXE_com_barra_no_final + 'fonte.dat');
    end;

  tam := arq.Values[formula.Name];
  idx := 0;


  fim := formula.ComponentCount - 1;
  for ini := 0 to fim do
    begin
      form := UpperCase(formula.Components[ini].ClassName);
      if dbgridr and (not((UpperCase(formula.Components[ini].Name) = 'DBGRID2') and (UpperCase(formula.Name) = 'FORM20'))) then
        begin
          if (form = 'TDBGRID') then
            begin
              idx := ini;
              tu := StrToIntDef(LerConfig(tam, 0), TDBGrid(formula.Components[ini]).Font.Size);
              if opcao = 0 then
                begin
                  TDBGrid(formula.Components[ini]).Font.Size := tu;
                  TDBGrid(formula.Components[ini]).Font.Style := [fsBold];
                end
              else if opcao = 1 then
                begin
                  TDBGrid(formula.Components[ini]).Font.Size := tu + 1;
                  tu := tu + 1;
                end
              else
                begin
                  TDBGrid(formula.Components[ini]).Font.Size := tu - 1;
                  tu := tu - 1;
                end;
              //exit;
            end;
        end
      else
        begin

        end;
    end;

  acc := 0;
  if redimensionar then
    begin
      //if idx <> 0 then
        //begin
          fim := TDBGrid(formula.Components[idx]).Columns.Count -1;
          for ini := 0 to fim do
            begin
              acc := acc + TDBGrid(formula.Components[idx]).Columns[ini].Width;
            end;
          if acc > screen.Width then
            begin
              formula.Width := Screen.Width - trunc(Screen.Width * 0.1);
            end
          else formula.Width := acc + 30;

          formula.Position := poScreenCenter;
          
        //end;
    end;


  tam := '-0- -1- -2- -3- -4- -5- -6- -7- -8-';
  arq.Values[formula.Name] := GravarConfig(tam, IntToStr(tu), 0);
  DeleteFile(caminhoEXE_com_barra_no_final + 'fonte.dat');
  arq.SaveToFile(caminhoEXE_com_barra_no_final + 'fonte.dat');
end;

function Tfuncoes.buscaParamGeral(indice : integer; deafault : String) : String;
begin
  Result := '';
  try
    Result := ConfParamGerais[indice];
    if Result = '' then Result := deafault;
  except
    Result := deafault;
  end;
end;

procedure Tfuncoes.gravaAlteracao(altera : String);
begin
  dm.IBQuery1.Close;
  dm.IBQuery1.SQL.Text := 'insert into alteraca(cod, alteracao, usuario, data)' +
  ' values(gen_id(alteraca, 1), :alteracao, :usuario, :data)';
  dm.IBQuery1.ParamByName('alteracao').AsString := LeftStr(altera, 100);
  dm.IBQuery1.ParamByName('usuario').AsString   := LeftStr(strzero(Form22.codusario, 2) + form22.usuario, 20);
  dm.IBQuery1.ParamByName('data').AsDateTime    := DateOf(form22.datamov) + TimeOf(now);
  try
   dm.IBQuery1.ExecSQL;
   dm.IBQuery1.Transaction.Commit;
  except
  end;
end;

{function calculaVlrAproxImpostos(var lista1 : TList) : currency;
var
  ex, descricao: String;
  tabela: Integer;
  aliqFedNac, aliqFedImp, aliqEst, aliqMun: double;
  ini  : integer;
  item : Item_venda1;
begin
  Result := 0;
  if not FileExists(caminhoEXE_com_barra_no_final + 'IBPT.csv') then exit;
  dm.ACBrIBPTax1.AbrirTabela(caminhoEXE_com_barra_no_final + 'IBPT.csv');

  for ini := 0 to lista1.count -1 do
   begin
     item := lista1.Items[ini];
     if dm.ACBrIBPTax1.Procurar(trim(item.Ncm),ex, descricao, tabela, aliqFedNac, aliqFedImp, aliqEst, aliqMun, true) then
       begin
         item.vlr_imposto := funcoes.ArredondaTrunca((abs(item.total) - abs(item.Desconto)) * (aliqFedNac + aliqEst) / 100, 2);
         Result := Result + item.vlr_imposto;
       end
     else
       begin
         item.vlr_imposto := VE_IMPOSTO(item.p_compra, item.p_venda, item.quant);
         Result := Result + item.vlr_imposto;
       end;
   end;
   
  //dm.ACBrIBPTax1.Procurar()
end;     }

function calculaVlrAproxImpostos1(nota : String) : currency;
var
  ex, descricao: String;
  tabela: Integer;
  aliqFedNac, aliqFedImp, aliqEst, aliqMun: double;
  ini  : integer;
  item : Item_venda1;
begin
{  Result := 0;
  if not FileExists(caminhoEXE_com_barra_no_final + 'IBPT.csv') then exit;
  dm.ACBrIBPTax1.AbrirTabela(caminhoEXE_com_barra_no_final + 'IBPT.csv');

  for ini := 0 to lista1.count -1 do
   begin
     item := lista1.Items[ini];
     if dm.ACBrIBPTax1.Procurar(trim(item.Ncm),ex, descricao, tabela, aliqFedNac, aliqFedImp, aliqEst, aliqMun, true) then
       begin
         item.vlr_imposto := funcoes.ArredondaTrunca((abs(item.total) - abs(item.Desconto)) * (aliqFedNac + aliqEst) / 100, 2);
         Result := Result + item.vlr_imposto;
       end
     else
       begin
         item.vlr_imposto := VE_IMPOSTO(item.p_compra, item.p_venda, item.quant);
         Result := Result + item.vlr_imposto;
       end;
   end;
 }
  //dm.ACBrIBPTax1.Procurar()
end;


function buscaChaveErroDeDuplicidade(erro : String) : String;
var
  ini, fim : integer;
begin
  ini := pos('[chNFe:', erro) + 7;
  fim := pos(']', erro);
  Result := copy(erro, ini, fim - ini);
end;

constructor TTWtheadEnviaCupons1.create(CreateSuspended: Boolean; lab1: TLabel);
begin
 label1 := lab1;
 inherited create(CreateSuspended);
end;


function Tfuncoes.vercCountContigencia() : integer;
begin
  Result := 0;
  dm.IBselect.Close;
  dm.IBselect.SQL.Text := 'select count(*) as qtd from nfce where adic = ''OFF''';
  dm.IBselect.Open;

  Result := dm.IBselect.fieldbyname('qtd').AsInteger;
{  if dtmMain.IBQuery1.fieldbyname('qtd').AsInteger > 0 then
    begin
      //Result := 'Contigência: ' + IntToStr(dtmMain.IBQuery1.fieldbyname('qtd').AsInteger);
    end;}

  dm.IBselect.Close;  
end;


function Tfuncoes.cadastroClienteNFCeRetornaCod(total : currency = 0; cod : integer = 0) : string;
begin
  Result := '';
  if total >= 10000 then
    begin
      Result := '';
      while true do
        begin
          if StrNum(Result) = '0' then
            begin
              if MessageDlg('O Cliente é Obrigatório para Vendas acima de 10mil Reais, Favor Cadastre um Cliente! Deseja Continuar ?', mtInformation, [mbYes, mbNo], 1) = idno then
                begin
                  Result := 'x';
                  exit;
                end;
            end;
          if StrNum(Result) <> '0' then exit;
          if StrNum(Result) = '0' then
            begin
              cadCliNFCe := tcadCliNFCe.create(self);
              cadCliNFCe.cod.Text := IntToStr(cod);

              cadCliNFCe.ShowModal;
              Result := cadCliNFCe.codCliente;
              cadCliNFCe.Free;
            end;
        end;
    end;

  if buscaParamGeral(53, 'S') = 'S' then
    begin
      cadCliNFCe := tcadCliNFCe.create(self);
      cadCliNFCe.ShowModal;
      Result := cadCliNFCe.codCliente;
      cadCliNFCe.Free;
    end
  else
    begin
      CadClienteSimplificado := tCadClienteSimplificado.Create(self);
      CadClienteSimplificado.limpa;
      CadClienteSimplificado.ShowModal;
      Result := CadClienteSimplificado.codCliente;
    end;
end;


function Tfuncoes.buscaVendaNFCe(nnf, serie : String; var chave : String) : String;
var tmp : String;
begin
  Result := '';
  tmp := strzero(nnf, 7) + strzero(serie, 2);
  dm.IBselect.Close;
  dm.IBselect.SQL.Text := 'select nota from venda where crc = :crc';
  dm.IBselect.ParamByName('crc').AsString := tmp;
  dm.IBselect.Open;

  if not dm.IBselect.IsEmpty then
    begin
      Result := dm.IBselect.fieldbyname('nota').AsString;
      dm.IBselect.Close;
      dm.IBselect.SQL.Text := 'select chave from nfce where substring(chave from 26 for 9) = :nnf and substring(chave from 23 for 3) = :serie';
      dm.IBselect.ParamByName('nnf').AsString   := strzero(nnf, 9);
      dm.IBselect.ParamByName('serie').AsString := strzero(serie, 3);
      dm.IBselect.Open;

      if not dm.IBselect.IsEmpty then
        begin
          chave := StrNum(dm.IBselect.fieldbyname('chave').AsString);
          if chave = '0' then chave := '';
        end;
    end;
end;

function Tfuncoes.buscaVendaECF(nnf, serie : String) : String;
begin
  Result := '';
  nnf := strzero(nnf, 6) + strzero(serie, 3);
  dm.IBselect.Close;
  dm.IBselect.SQL.Text := 'select nota from venda where crc = :crc';
  dm.IBselect.ParamByName('crc').AsString := nnf;
  dm.IBselect.Open;

  if not dm.IBselect.IsEmpty then Result := dm.IBselect.fieldbyname('nota').AsString;
end;

procedure Tfuncoes.somenteNumeros(var key : char);
begin
  if Contido(key, '1234567890' + #8 + #13 + #27) = false then
    begin
      key := #0;
    end;
end;


function  Tfuncoes.DeleteFolder(FolderName: String): Boolean;
Var
   SearchFile: TSearchRec;
   FindResult: Integer;
begin
  FindResult := FindFirst(FolderName, 0, SearchFile);
  try
    While FindResult = 0 do
      begin
        Application.ProcessMessages;
        DeleteFile(ExtractFileDir(FolderName) + '\' + SearchFile.Name);
        FindResult := FindNext(SearchFile);
      end;
  finally
    FindClose(SearchFile)
  end;
end;


procedure Tfuncoes.BuscaAplicacao(CONST SQL : sTRING; VAR GRID1 : TDBGrid; ORDENACAMP : BOOLEAN);
var
  busca, metodo : string;
begin
  busca := funcoes.dialogo('normal',3,'',60,true,'','ControlW','Selecionar Por:','');
  if busca = '*' then exit;

  dm.IBQuery2.Close;
  dm.IBQuery2.SQL.Clear;

  //if metodo = '2' then dm.IBQuery2.SQL.Add('select cod,nome as descricao, quant, p_venda as preco, aplic as aplicacao  from produto where (APLIC like '+ QuotedStr('%'+busca+'%') +') ORDER BY APLIC')
    //else if metodo = '1' then dm.IBQuery2.SQL.Add('select cod,nome as descricao, quant, p_venda as preco, aplic as aplicacao from produto where (APLIC like '+ QuotedStr(busca+'%') +') ORDER BY APLIC');
  dm.IBQuery2.SQL.Add('select cod,nome as descricao, quant, p_venda as preco, aplic as aplicacao  from produto where (APLIC like '+ QuotedStr('%'+busca+'%') +') ORDER BY APLIC');
  dm.IBQuery2.Open;

  busca := funcoes.busca(dm.IBQuery2, busca,'', 'cod' , 'descricao');
  if busca = '' then exit;
  funcoes.ordernaDataSetVenda('APLICACAO', busca, SQL, GRID1, '', ORDENACAMP);
  //DBGrid1.DataSource.DataSet.Locate('cod',busca,[loPartialKey]);
end;

function Tfuncoes.getDiasBloqueioRestantes(soDiasParaBloquear : boolean = false) : integer;
begin
  dm.IBselect.Close;
  dm.IBselect.SQL.Text := 'select nfe, dtr from acesso where acesso = ''bloq''';
  dm.IBselect.Open;

  if soDiasParaBloquear then
    begin
      Result := StrToIntDef(dm.IBselect.FieldByName('nfe').AsString, 15);
      dm.IBselect.Close;
      exit;
    end;

  if not dm.IBselect.IsEmpty then
    begin
      Result := trunc(IncDay(dm.IBselect.fieldbyname('dtr').AsDateTime, dm.IBselect.FieldByName('nfe').AsInteger) - now);
    end;

  dm.IBselect.Close;
end;

procedure Tfuncoes.AjustaForm(Formulario : tform);
Const
  nTamOriginal = 800; // Será o 100% da escala
Var 
  nEscala : Double; // Vai me dar o percentual de Transformação escalar
  nPorcento : Integer; // Vai me dar em percentual inteiro o valor 
begin
  if nTamOriginal = Screen.Width then exit;

  nEscala := ((Screen.Width-nTamOriginal)/nTamOriginal);
  nPorcento := Round((nEscala*100) + 100);
  //Formulario.Width := Round(Self.Width * (nEscala+1));
  //  Formulario.Height := Round(Self.Height * (nEscala+1));
  Formulario.ScaleBy(nPorcento,100);
end;


function Tfuncoes.Trunca(const nValor: Currency; const iCasas: Integer): Currency;
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


function Tfuncoes.DSiFileSize(const fileName: string): int64;
var
  fHandle: DWORD;
begin
  fHandle := CreateFile(PChar(fileName), 0, 0, nil, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, 0);
  if fHandle = INVALID_HANDLE_VALUE then Result := -1
  else
    begin
      try
        Int64Rec(Result).Lo := GetFileSize(fHandle, @Int64Rec(Result).Hi);
      finally CloseHandle(fHandle);
      end;
    end;  
end;

function Tfuncoes.insereFornec(var matriz : TStringList) : String;
var
  cod : string;
begin
  dm.IBselect.Close;
  dm.IBselect.SQL.Clear;
  dm.IBselect.SQL.Add('select cod from FORNECEDOR where cnpj = :cnpj' );
  dm.IBselect.ParamByName('cnpj').AsString := matriz[0];
  dm.IBselect.Open;

  Result := '0';

  if not dm.IBselect.IsEmpty then
    begin
      Result := dm.IBselect.fieldbyname('cod').AsString;
    end;

  dm.IBselect.Close;

  if Result = '0' then
    begin
      cod := Incrementa_Generator('FORNECEDOR', 1);
      Result := cod;
    end;

  dm.IBQuery4.Close;
  dm.IBQuery4.SQL.Clear;
  dm.IBQuery4.SQL.Add('update or insert into FORNECEDOR(cod, nome, endereco, cep, fone, cidade, estado, bairro, cnpj,'  +
  'ies, cod_mun, tipo) values(:cod, :nome, :endereco, :cep, :fone, :cidade, :estado, :bairro, :cnpj,'  +
  ':ies, :cod_mun, :tipo)' );
  dm.IBQuery4.ParamByName('cod').AsString      := cod;
  dm.IBQuery4.ParamByName('nome').AsString     := LeftStr(matriz[1], 40);
  dm.IBQuery4.ParamByName('endereco').AsString := LeftStr(matriz[3], 40);
  dm.IBQuery4.ParamByName('cep').AsString      := LeftStr(matriz[8], 10);
  dm.IBQuery4.ParamByName('fone').AsString     := LeftStr(matriz[11], 14);
  dm.IBQuery4.ParamByName('cidade').AsString   := LeftStr(matriz[6], 14);
  dm.IBQuery4.ParamByName('estado').AsString   := matriz[7];
  dm.IBQuery4.ParamByName('bairro').AsString   := LeftStr(matriz[4], 25);
  dm.IBQuery4.ParamByName('cnpj').AsString     := matriz[0];
  dm.IBQuery4.ParamByName('ies').AsString      := matriz[12];
  dm.IBQuery4.ParamByName('cod_mun').AsString  := matriz[5];
  dm.IBQuery4.ParamByName('tipo').AsString     := '2';
  dm.IBQuery4.ExecSQL;
  dm.IBQuery4.Transaction.Commit;

  //reStartGenerator('fornecedor', StrToInt(fornecedor));
end;


procedure Tfuncoes.imprimeGrafico(tipo, nota, vendedor : String; listaProdutos1 : TItensProduto; desconto : currency);
var
  ini : integer;
  total : currency;
begin
  dm.IBselect.Close;
  dm.IBselect.SQL.Text := 'select * from registro';
  dm.IBselect.Open;

  imprime.lNomeFantasia.Caption := form22.Pgerais.Values['empresa'];
  imprime.lRazaoSocial.Caption  := dm.IBselect.fieldbyname('nome').AsString;
  imprime.lEndereco.Caption := dm.IBselect.fieldbyname('ende').AsString + ' ' +
  dm.IBselect.fieldbyname('bairro').AsString + ' ' + dm.IBselect.fieldbyname('telres').AsString + ' ' +
  dm.IBselect.fieldbyname('telcom').AsString;

  dm.IBselect.Close;
  imprime.mLinhaItem.Lines.Clear;
  total := 0;

  for ini := 0 to listaProdutos1.Count -1 do
    begin
      imprime.mLinhaItem.Lines.Add(CompletaOuRepete(LeftStr(listaProdutos1[ini].codbar, 15), '', ' ', 15) + ' ' + CompletaOuRepete(LeftStr(listaProdutos1[ini].nome, 35), '', ' ', 35) + ' ' +
      CompletaOuRepete('', FormatCurr('0.00', listaProdutos1[ini].quant), ' ', 12) + ' ' + CompletaOuRepete('', FormatCurr('0.00', listaProdutos1[ini].preco), ' ', 12) + ' ' + CompletaOuRepete('', FormatCurr('0.00', listaProdutos1[ini].total), ' ', 10));
      total := total + listaProdutos1[ini].total;
    end;

  dm.IBselect.Close;
  dm.IBselect.SQL.Text := 'select cod,nome from vendedor where cod = :cod';
  dm.IBselect.ParamByName('cod').AsString := vendedor;
  dm.IBselect.Open;

  imprime.lQtdTotalItensVal.Caption := IntToStr(listaProdutos1.Count);
  imprime.lTotal.Caption := FormatCurr('0.00', total);
  imprime.ldesconto.Caption := FormatCurr('0.00', desconto);
  imprime.lTitValorPago.Caption := FormatCurr('0.00',total - abs(desconto));
  imprime.ldadosNota.Caption := CompletaOuRepete('Nota: ' + nota, 'Vendedor: ' + dm.IBselect.fieldbyname('cod').AsString + '-' + dm.IBselect.fieldbyname('nome').AsString, ' ', 50);
  imprime.dadosCliente.Visible := false;
  imprime.rlbMensagemContribuinte.Visible := false;

  imprime.rlsbDetItem.Visible   := true;
  imprime.rlbsCabecalho.Visible := true;
  imprime.RLBarcode1.Caption := nota;
  imprime.nota.Caption := 'Venda: ' + nota;


  imprime.rlVenda.Preview;
  //imprime.rlVenda.Print;
end;

procedure Tfuncoes.le_Venda(nota : String; var desconto : currency;var vendedor :String; var listprod : TItensProduto);
var i : integer;
begin
  dm.IBselect.Close;
  dm.IBselect.SQL.Text := 'select desconto, vendedor from venda where nota = :nota';
  dm.IBselect.ParamByName('nota').AsString := nota;
  dm.IBselect.Open;

  if dm.IBselect.IsEmpty then
    begin
      dm.IBselect.Close;
      vendedor := 'xx';
      exit;
    end;

  desconto := dm.IBselect.fieldbyname('desconto').AsCurrency;
  vendedor := dm.IBselect.fieldbyname('vendedor').AsString;

  dm.IBselect.Close;
  dm.IBselect.SQL.Text := 'select i.cod, p.p_venda,p.codbar, i.total, i.quant, p.nome from item_venda i left join produto p on (p.cod = i.cod)'+
  ' where nota = :nota';
  dm.IBselect.ParamByName('nota').AsString := nota;
  dm.IBselect.Open;
  
  listprod := TItensProduto.Create;

  while not dm.IBselect.Eof do
    begin
      i := listprod.Add(TregProd.Create);
      listprod[i].cod := dm.IBselect.fieldbyname('cod').AsInteger;
      listprod[i].nome := dm.IBselect.fieldbyname('nome').AsString;
      listprod[i].codbar := dm.IBselect.fieldbyname('codbar').AsString;
      listprod[i].quant := dm.IBselect.fieldbyname('quant').AsCurrency;
      listprod[i].preco := dm.IBselect.fieldbyname('p_venda').AsCurrency;
      listprod[i].total := dm.IBselect.fieldbyname('total').AsCurrency;
      dm.IBselect.Next;
    end;

  dm.IBselect.Close;  
end;

procedure Tfuncoes.atualizaTabelaCest();
var
  arq, ti, ta : TStringList;
  ini, fim, i, ini1, fim1 : integer;
  atual : string;
begin
  if not FileExists(ExtractFileDir(ParamStr(0)) + '\cest.csv') then exit;

  arq := TStringList.Create;
  ti  := TStringList.Create;
  ta  := TStringList.Create;
  arq.LoadFromFile(ExtractFileDir(ParamStr(0)) + '\cest.csv');

  fim := arq.Count -1;
  i := 0;
  cont := 0;
  for ini := 0 to fim do
    begin
      arq[ini] := ';' + arq[ini] + ';';
      LE_CAMPOS(ti,arq[ini],';', true);
      ti.Values['0'] := StrNum(ti.Values['0']);

      if Contido(',', ti.Values['1']) then ti.Values['1'] := ',' + ti.Values['1'] + ',';

      LE_CAMPOS(ta, ti.Values['1'],',', true);

      //fim1 := ;

      for ini1 := 0 to ta.Count -1 do
        begin
          ta.Values[IntToStr(ini1)] := StrNum(ta.Values[IntToStr(ini1)]);
          try
            if ((ta.Values[IntToStr(ini1)] <> '0') and (ti.Values['0'] <> '0')) then
              begin
                i := i + 1;
                dm.IBQuery1.Close;
                dm.IBQuery1.SQL.Text := 'update or insert into NCM_CEST(ncm, cest) values(:ncm, :cest)';
                dm.IBQuery1.ParamByName('ncm').AsString  := ta.Values[IntToStr(ini1)];
                dm.IBQuery1.ParamByName('cest').AsString := ti.Values['0'];
                dm.IBQuery1.ExecSQL;
              end;  
          except
            on e:exception do
              begin
                ShowMessage(ta.GetText + #13 + '--------------' + #13 + ti.Values['0']);
              end;
          end;
        end;

      if ((ti.Values['2'] <> '') and (StrToIntDef(ti.Values['0'], 0) <> 0)) then
        begin
          dm.IBQuery1.Close;
          dm.IBQuery1.SQL.Text := 'update or insert into cest(cest, nome) values(:cest, :nome)';
          dm.IBQuery1.ParamByName('cest').AsString := ti.Values['0'];
          dm.IBQuery1.ParamByName('nome').AsString := UpperCase(LeftStr(ti.Values['2'],100));
          dm.IBQuery1.ExecSQL;
        end;

      ta.Free;
      ti.Free;
      //ShowMessage(ti.GetText);
    end;

  arq.Free;  
  dm.IBQuery1.Transaction.Commit;  
  ShowMessage('NCMs Inseridos: ' + IntToStr(i));  
end;

procedure Tfuncoes.atualizaCFOPs();
var
  arq, camp : TStringList;
  ini, fim  : integer;
  cods : String;
begin
  if not FileExists(caminhoEXE_com_barra_no_final + 'CFOP.csv') then exit;

  arq  := TStringList.Create;
  camp := TStringList.Create;
  cods := '|';
  arq.LoadFromFile(caminhoEXE_com_barra_no_final + 'CFOP.csv');


  dm.IBselect.Close;
  dm.IBselect.SQL.Text := 'select cod from COD_OP';
  dm.IBselect.Open;

  while NOT dm.IBselect.Eof do
    begin
      cods := cods + dm.IBselect.fieldbyname('cod').AsString + '|';
      dm.IBselect.Next;
    end;


  fim := arq.Count -1;
  funcoes.informacao(0, fim,'Atualizando CFOPs...', true, false, 2);

  for ini := 0 to fim do
    begin
      funcoes.informacao(ini, fim,'Atualizando CFOPs...', false, false, 2);
      arq[ini] := ';' + arq[ini] + ';';
      LE_CAMPOS(camp, arq[ini], ';', false);

      //and (RightStr(StrNum(camp.Values['0']), 1)  <> '0')

      if ((Contido('|' + STRNUM(camp.Values['0']) + '|', cods) = FALSE) and (StrNum(camp.Values['0']) <> '0')) then
        begin
          dm.IBQuery1.Close;
          dm.IBQuery1.SQL.Text := 'update or insert into COD_OP(cod, nome) values(:cod, :nome) matching(cod)';
          dm.IBQuery1.ParamByName('cod').AsInteger := StrToInt(StrNum(camp.Values['0']));
          dm.IBQuery1.ParamByName('nome').AsString := UpperCase(LeftStr(removeCarateresEspeciais(camp.Values['1']), 100));
          dm.IBQuery1.ExecSQL;
        end;
    end;

  if dm.IBQuery1.Transaction.InTransaction then dm.IBQuery1.Transaction.Commit;
  funcoes.informacao(ini, fim,'Atualizando CFOPs...', false, true, 2);
  cods := '';
  camp.Free;
  arq.Free;

  RenameFile(caminhoEXE_com_barra_no_final + 'CFOP.csv', caminhoEXE_com_barra_no_final + 'CFOP1.csv');
end;


function Tfuncoes.buscaUltimaVendaOrcamentoDoUsuario(codUsuario : integer; opcao : Smallint) : String;
begin
  dm.IBselect.Close;
  if opcao = 1 then dm.IBselect.SQL.Text := 'select max(nota)as nota from venda where vendedor = :vend and cancelado = 0'
  else dm.IBselect.SQL.Text := 'select max(nota)as nota from orcamento where vendedor = :vend';
  dm.IBselect.ParamByName('vend').AsInteger := codUsuario;
  dm.IBselect.Open;

  Result := StrNum(dm.IBselect.fieldbyname('nota').AsString);

  if Result = '0' then
    begin
      if opcao =  2 then Result := Incrementa_Generator('orcamento', 0)
        else Result := Incrementa_Generator('venda', 0);
    end;
  dm.IBselect.Close;
end;

procedure Tfuncoes.criaDataSetVirtualProdutosForm33();
begin
  form33.ClientDataSet1.FieldDefs.Clear;
  form33.ClientDataSet1.FieldDefs.Add('CODIGO'   , ftInteger);
  form33.ClientDataSet1.FieldDefs.Add('DESCRICAO', ftString, 40);
  form33.ClientDataSet1.FieldDefs.Add('CODBAR'   , ftString, 15);
  form33.ClientDataSet1.FieldDefs.Add('UNID'     , ftString, 3);
  form33.ClientDataSet1.FieldDefs.Add('P_VENDA'  , ftCurrency);
  form33.ClientDataSet1.FieldDefs.Add('P_COMPRA' ,ftCurrency);
  form33.ClientDataSet1.FieldDefs.Add('QUANT'    ,ftCurrency);
  form33.ClientDataSet1.FieldDefs.Add('NCM'   , ftString, 15);
  form33.ClientDataSet1.FieldDefs.Add('IS_PIS'   , ftString, 1);
  form33.ClientDataSet1.FieldDefs.Add('COD_ISPIS'   , ftString, 3);

  form33.DataSource1.DataSet := form33.ClientDataSet1;
  Form33.DBGrid1.DataSource  := form33.DataSource1;

  form33.ClientDataSet1.CreateDataSet;
  form33.ClientDataSet1.LogChanges := false;
  form33.ClientDataSet1.FieldByName('unid').Visible      := false;
  form33.ClientDataSet1.FieldByName('NCM').Visible       := false;
  form33.ClientDataSet1.FieldByName('IS_PIS').Visible    := false;
  form33.ClientDataSet1.FieldByName('COD_ISPIS').Visible := false;

  TCurrencyField(form33.ClientDataSet1.FieldByName('P_VENDA')).currency       := false;
  TCurrencyField(form33.ClientDataSet1.FieldByName('QUANT')).currency         := false;
  TCurrencyField(form33.ClientDataSet1.FieldByName('P_COMPRA')).currency      := false;
  TCurrencyField(form33.ClientDataSet1.FieldByName('QUANT')).DisplayFormat    := '#,###,###0.00';
  TCurrencyField(form33.ClientDataSet1.FieldByName('P_VENDA')).DisplayFormat  := '#,###,###0.00';
  TCurrencyField(form33.ClientDataSet1.FieldByName('P_COMPRA')).DisplayFormat := '#,###,###0.00';
  form33.campobusca := 'DESCRICAO';
end;


function Tfuncoes.retornaEscalaDoCampo(campo, tabela : String) : Smallint;
begin
  campo  := QuotedStr(UpperCase(campo));
  tabela := QuotedStr(UpperCase(tabela));

  Result := 0;
  dm.IBselect.Close;
  dm.IBselect.SQL.Text := 'SELECT R.RDB$FIELD_NAME AS Nome_Campo,F.RDB$FIELD_LENGTH AS Tamanho_Campo, ' +
  'F.RDB$FIELD_PRECISION AS Precisao_Campo, ABS(F.RDB$FIELD_SCALE) AS Escala_Campo ' +
  'FROM RDB$RELATION_FIELDS R LEFT JOIN RDB$FIELDS F ON R.RDB$FIELD_SOURCE = F.RDB$FIELD_NAME ' +
  'WHERE R.RDB$RELATION_NAME = '+ TABELA +' AND R.RDB$FIELD_NAME = '+ campo +' ORDER BY R.RDB$FIELD_POSITION;';
  DM.IBselect.Open;

  if not dm.IBselect.IsEmpty then
    begin
      Result := dm.IBselect.fieldbyname('Escala_Campo').AsInteger;
    end;

  dm.IBselect.Close;  
end;


function Tfuncoes.manutencaoDeXml(inicia : smallint) : String;
begin
  if inicia = 1 then
    begin
      form33 := tform33.Create(self);
      form33.Caption := 'Manutenção de NFCe F2-Marca Envio';
      form33.ClientDataSet1.FieldDefs.Clear;
      form33.ClientDataSet1.FieldDefs.Add('chave', ftString, 45);
      form33.ClientDataSet1.FieldDefs.Add('serie', ftString, 2);
      form33.ClientDataSet1.FieldDefs.Add('erro', ftString, 50);
      form33.ClientDataSet1.FieldDefs.Add('ok', ftInteger);
      form33.ClientDataSet1.CreateDataSet;
      form33.ClientDataSet1.FieldByName('ok').Visible := false;
      form33.DataSource1.DataSet := form33.ClientDataSet1;
      form33.DBGrid1.DataSource  := form33.DataSource1;
      form33.campobusca := 'nfce';
    end;  
end;

function Tfuncoes.marcaXMLNFCeParaEnvio(chave, erro, serie : String) : boolean;
var
  arq : TStringList;
  data, opcao : String;
begin
  Result := false;
  {
   1 - Inutilizar NFCe
   2 - Provavelmente não tem conserto
   3 - Marcar no BD
  }

  if erro = '1' then
    begin
      Result := true;
      MessageDlg('Esta Rotina Não Foi Implementada! Veja a Numeração e Serie e Inutilize essa NFCe', mtInformation, [mbOK],1);
      exit;
    end
  else if erro = '2' then begin
    dm.IBQuery2.Close;
    dm.IBQuery2.SQL.Text := 'select chave, data from nfce where substring(chave from 23 for 3) = :serie and substring(chave from 26 for 9) = :nnf';
    dm.IBQuery2.ParamByName('serie').AsString := strzero(serie, 3);
    dm.IBQuery2.ParamByName('nnf').AsString   := strzero(chave, 9);
    dm.IBQuery2.Open;

    chave := dm.IBQuery2.fieldbyname('chave').AsString;

    arq := TStringList.Create;
    if FileExists(caminhoEXE_com_barra_no_final + 'NFCE\EMIT\' + chave + '-nfe.xml') then begin
      arq.LoadFromFile(caminhoEXE_com_barra_no_final + 'NFCE\EMIT\' + chave + '-nfe.xml');
      data := LeftStr(Le_Nodo('dhEmi', arq.GetText), 10);
      data  := funcoes.dataInglesToBrasil(data);
      arq.Free;

      if FormatDateTime('dd/mm/yy', StrToDate(data)) <> RightStr(erro, 10) then begin
        if MessageDlg('Deseja Alterar a Data Do Registro para ' + data +' ?', mtConfirmation, [mbYes, mbNo], 1) = idyes then begin
          dm.IBQuery2.Close;
          dm.IBQuery2.SQL.Text := 'update nfce set data = :data where chave = :chave';
          dm.IBQuery2.ParamByName('data').AsDate    := StrToDate(data);
          dm.IBQuery2.ParamByName('chave').AsString := chave;
          dm.IBQuery2.ExecSQL;
          dm.IBQuery2.Transaction.Commit;

          Result := true;
          ShowMessage('Alterado com Sucesso');
        end;
      end;

    end
    else begin
      MessageDlg('XML Não Encontrado em: ' + caminhoEXE_com_barra_no_final + 'NFCE\EMIT\' + chave + '-nfe.xml', mtInformation, [mbOK], 1);
    end;

    exit;
  end
  else if erro = '3' then begin
    if length(chave) <> 44 then begin
      MessageDlg('Chave Inválida! ' + chave, mtInformation, [mbOK],1);
      exit;
    end;

    dm.IBQuery1.Close;
    dm.IBQuery1.SQL.Text := 'update nfce set adic = ''OFF'' where chave = :chave';
    dm.IBQuery1.ParamByName('chave').AsString := chave;
    dm.IBQuery1.ExecSQL;

    dm.IBQuery1.Transaction.Commit;
    Result := true;
    MessageDlg('Esta Chave ' + chave + ' Vai ser Enviada No DavNFCe Novamente!', mtInformation, [mbOK],1);
  end;
end;

function Tfuncoes.criaBackup() : boolean;
var
  arq   : TStringList;
  linha, caminho, dias : String;
  ini, a, b : integer;
begin
  Result := false;
  arq    := TStringList.Create;

  caminho := caminhoEXE_com_barra_no_final + 'backup\bkp_' + FormatDateTime('dd', now) + '_' + FormatDateTime('mm', now) + '_' + FormatDateTime('yyyy', now) + '.bkp';
  criaPasta(caminhoEXE_com_barra_no_final + 'backup\');

  dias := '60';

  dm.IBselect.Close;
  dm.IBselect.SQL.Text := 'select * from produto';
  dm.IBselect.Open;
  dm.IBselect.FetchAll;
  arq.Add('|PRODUTO|');

  a := 0;
  b := dm.IBselect.RecordCount;

  informacao(a, b, 'Lendo Produtos', true, false, 5);

  while not dm.IBselect.Eof do begin
    linha := '|';
    a := a + 1;
    informacao(a, b, 'Lendo Produtos', false, false, 5);
    for ini := 0 to dm.IBselect.FieldCount - 1 do begin
      linha := linha + dm.IBselect.fieldbyname(dm.IBselect.FieldDefs[ini].Name).AsString + '|';
    end;

    arq.Add(linha);
    dm.IBselect.Next;
  end;


  dm.IBselect.Close;
  dm.IBselect.SQL.Text := 'select * from venda where data >= :data';
  dm.IBselect.ParamByName('data').AsDateTime := now - StrToIntDef(dias, 60);
  dm.IBselect.Open;
  dm.IBselect.FetchAll;
  arq.Add('|VENDAS|');

  a := 0;
  b := dm.IBselect.RecordCount;

  informacao(a, b, 'Lendo Vendas', true, false, 5);

  while not dm.IBselect.Eof do begin
    linha := '|';
    a := a + 1;
    informacao(a, b, 'Lendo Vendas', false, false, 5);
    for ini := 0 to dm.IBselect.FieldCount - 1 do begin
      linha := linha + dm.IBselect.fieldbyname(dm.IBselect.FieldDefs[ini].Name).AsString + '|';
    end;

    arq.Add(linha);
    dm.IBselect.Next;
  end;

  dm.IBselect.Close;
  dm.IBselect.SQL.Text := 'select * from item_venda where data >= :data';
  dm.IBselect.ParamByName('data').AsDateTime := (now) - StrToIntDef(dias, 60);
  dm.IBselect.Open;
  dm.IBselect.FetchAll;
  arq.Add('|ITEM_VENDA|');

  a := 0;
  b := dm.IBselect.RecordCount;

  informacao(a, b, 'Lendo Produtos Vendidos', true, false, 5);

  while not dm.IBselect.Eof do begin
    linha := '|';
    a := a + 1;
    informacao(a, b, 'Lendo Produtos Vendidos', false, false, 5);
    for ini := 0 to dm.IBselect.FieldCount - 1 do begin
      linha := linha + dm.IBselect.fieldbyname(dm.IBselect.FieldDefs[ini].Name).AsString + '|';
    end;

    arq.Add(linha);
    dm.IBselect.Next;
  end;

  dm.IBselect.Close;
  dm.IBselect.SQL.Text := 'select * from caixa where cast(data as date) >= :data';
  dm.IBselect.ParamByName('data').AsDateTime := (now) - StrToIntDef(dias, 60);
  dm.IBselect.Open;
  dm.IBselect.FetchAll;
  arq.Add('|CAIXA|');

  a := 0;
  b := dm.IBselect.RecordCount;

  informacao(a, b, 'Lendo Movimento de Caixa', true, false, 5);

  while not dm.IBselect.Eof do begin
    linha := '|';
    a := a + 1;

    informacao(a, b, 'Lendo Movimento de Caixa', false, false, 5);
    for ini := 0 to dm.IBselect.FieldCount - 1 do begin
      linha := linha + dm.IBselect.fieldbyname(dm.IBselect.FieldDefs[ini].Name).AsString + '|';
    end;

    arq.Add(linha);
    dm.IBselect.Next;
  end;

  dm.IBselect.Close;
  arq.SaveToFile(caminho);
  arq.Free;
  informacao(a, b, 'Lendo Vendas', false, true, 5);
  ShowMessage('Backup Criado em: ' + caminho);
end;

function Tfuncoes.exportaTabela(Tabela, CAMPOS : String; var arq : TextFile; var query : TIBQuery) : boolean;
var
  ini, a, b : integer;
  linha : String;
begin
  query.Close;
  query.SQL.Text := 'select '+CAMPOS+' from '+Tabela;
  query.Open;
  query.FetchAll;
  Writeln(arq,'|TABELAX|'+uppercase(Tabela)+'|');
  linha := '|CAMPOX|';

  //if CAMPOS <> '*' then begin
    for ini := 0 to query.FieldCount - 1 do begin
      linha := linha + query.FieldDefs[ini].Name + '|';
    end;
    Writeln(arq,linha);
  //end;

  a := 0;
  b := query.RecordCount;

  informacao(a, b, 'Lendo Tabela ' + UpperCase(Tabela), true, false, 5);

  while not query.Eof do begin
    linha := '||';
    a := a + 1;
    informacao(a, b, 'Lendo Tabela ' + UpperCase(Tabela) +'...', false, false, 5);
    for ini := 0 to query.FieldCount - 1 do begin
      if query.fieldbyname(query.FieldDefs[ini].Name).IsNull then linha := linha + '1' + '|'
      else linha := linha + removeCarateresEspeciais(query.fieldbyname(query.FieldDefs[ini].Name).AsString) + '|';
    end;

    Writeln(arq, linha);
    query.Next;
  end;

  informacao(a, b, 'Lendo Tabela ' + Tabela, false, true, 5);

  a := 0;
  b := 0;
  query.Close;
end;

function Tfuncoes.sincronizarArquivoDeRemessa(caminho : String; var query : TIBQuery) : boolean;
var
  ini, a, b : integer;
  linha, campos, tabela, sql : String;
  lin : TStringList;
  arq : TextFile;
begin
  AssignFile(arq, (caminho));
  Reset(arq);
  lin := TStringList.Create;

  a := 0;
  b := filesize(arq);

  informacao(a, b, 'Sincronizando Tabela ' + UpperCase(Tabela), true, false, 5);

  while not Eof(ARQ) do begin
    Readln(arq, linha);
    //ShowMessage(linha);

    if Contido('|TABELAX|', linha) then begin
      le_campos(lin, linha, '|', false);
      tabela := lin.Values['1'];
      Readln(arq, linha);
      le_campos(lin, linha, '|', false);
      campos := '';
      for ini := 1 to lin.Count -1 do begin
        campos := campos + lin.ValueFromIndex[ini];
        if ini <> lin.Count - 1 then campos := campos + ',';
      end;

      {if tabela = 'FORNECEDOR' then begin
         ShowMessage(lin.GetText);
      end;}

      Readln(arq, linha);

      if a > 10 then
        begin
          informacao(a, b, 'Sincronizando Tabela ' + UpperCase(Tabela), false, true, 5);
          informacao(a, b, 'Sincronizando Tabela ' + UpperCase(Tabela), true, false, 5);
          a := 0;
        end
      else informacao(a, b, 'Sincronizando Tabela ' + UpperCase(Tabela), true, false, 5);
    end;

    a := a + 1;
    informacao(a, b, 'Sincronizando Tabela ' + UpperCase(Tabela) +'...', false, false, 5);

    sql := 'update or insert into ' +  tabela + '(' + campos + ') values (';
    le_campos(lin, linha, '|', false);

    {if tabela = 'FORNECEDOR' then begin
      ShowMessage(lin.GetText);
    end;

    ShowMessage(lin.GetText);}

    for ini := 1 to lin.Count -1 do begin
      if ((tabela = 'FORNECEDOR') and (ini = 16)) then begin
        sql := sql + StrNum(lin.ValueFromIndex[ini]);
      end
      else begin
        if (Contido(',', lin.ValueFromIndex[ini]) and (length(lin.ValueFromIndex[ini]) < 10)) then sql := sql + trocaChar(lin.ValueFromIndex[ini], ',', '.')
          else sql := sql + QuotedStr((lin.ValueFromIndex[ini]));
      end;

      if ini <> lin.Count - 1 then sql := sql + ',';
      
    end;

    sql := sql + ')';

    query.Close;
    query.SQL.Text := sql;

    try
      if lin.Count > 2 then query.ExecSQL;
    except
      WriteToTXT(caminhoEXE_com_barra_no_final + 'arq.txt', sql);
      //ShowMessage(sql);
    end;
  end;

  informacao(a, b, 'Lendo Tabela ' + Tabela, false, true, 5);

  a := 0;
  b := 0;
  query.Close;
end;

function Tfuncoes.verificaSePodeVenderFracionado(cod : integer;unid : String; quant : currency) : boolean;
begin
  Result := true;

  if buscaParamGeral(59, 'S') = 'N' then exit;

  if trim(unid) = '' then begin
    dm.IBselect.Close;
    dm.IBselect.SQL.Text := 'select unid from produto where cod = :cod';
    dm.IBselect.ParamByName('cod').AsInteger := cod;
    dm.IBselect.Open;

    unid := dm.IBselect.fieldbyname('unid').AsString;
    dm.IBselect.Close;
  end;

  if Contido('|' + unid + '|', UnidInteiro) = false then begin
    if trunc(quant) <> quant then begin
      MessageDlg('Nesta Unidade não é permitido a Venda de Quantidade Fracionada. Quant. ' + formataCurrency(quant),
      mtInformation,[mbOK], 1);
      Result := false;
    end;
  end;
end;

function Tfuncoes.exportaFornecedores(var arq : TextFile) : boolean;
var
  linha : String;
  tot : integer;
begin
  dm.IBselect.Close;
  dm.IBselect.SQL.Clear;
  dm.IBselect.SQL.Add('select cod,nome, endereco, cep, fone, fax, cidade,estado,contato, obs, bairro, '+
  'cnpj, ies, cod_mun, suframa, tipo from fornecedor');
  dm.IBselect.Open;
  dm.IBselect.FetchAll;
  tot := dm.IBselect.RecordCount;

  linha := '|TABELAX|FORNECEDOR|';
  Writeln(arq, linha);

  try
  funcoes.informacao(0, tot, 'Exportando Fornecedores...', true, false, 5);

  while not dm.IBselect.Eof do
    begin
      funcoes.informacao(dm.IBselect.RecNo, tot, 'Exportando Fornecedores...', false, false, 5);
      linha := '|'+ dm.IBselect.fieldbyname('cod').AsString + '|'+
      dm.IBselect.fieldbyname('nome').AsString    + '|' +dm.IBselect.fieldbyname('endereco').AsString      + '|' +
      dm.IBselect.fieldbyname('cep').AsString      + '|' + dm.IBselect.fieldbyname('fone').AsString + '|' +
      dm.IBselect.fieldbyname('fax').AsString   + '|' + dm.IBselect.fieldbyname('cidade').AsString + '|' +
      dm.IBselect.fieldbyname('estado').AsString   + '|' + trim(dm.IBselect.fieldbyname('contato').AsString) + '|' +
      trim(dm.IBselect.fieldbyname('obs').AsString) + '|' +dm.IBselect.fieldbyname('bairro').AsString + '|' +
      trim(dm.IBselect.fieldbyname('cnpj').AsString) + '|' +dm.IBselect.fieldbyname('ies').AsString + '|' +
      trim(dm.IBselect.fieldbyname('cod_mun').AsString) + '|' +dm.IBselect.fieldbyname('suframa').AsString + '|' +
      trim(dm.IBselect.fieldbyname('tipo').AsString) + '|';

      //Writeln(F, funcoes.Criptografar(linha));
      Writeln(arq, linha);
      dm.IBselect.Next;
    end;
    funcoes.informacao(0, tot, 'Gerando Sincronização...', false, true, 5);
  except
    funcoes.informacao(0, tot, 'Gerando Sincronização...', false, true, 5);
  end;
end;

function Tfuncoes.recebeFornecedores(var arq : TStringList) : boolean;

begin
  dm.IBQuery1.Close;
  dm.IBQuery1.SQL.Text := ('update or insert into fornecedor(cod,nome, endereco, cep, fone, fax, cidade,estado,contato, obs, bairro, '+
  'cnpj, ies, cod_mun, suframa, tipo)  values(:cod,:nome, :endereco, :cep, :fone, :fax, :cidade,:estado,:contato, :obs, :bairro, '+
  ':cnpj, :ies, :cod_mun, :suframa, :tipo)');
  dm.IBQuery1.ParamByName('cod').AsString          :=  StrNum(arq.Values['0']);
  dm.IBQuery1.ParamByName('nome').AsString         :=  arq.Values['1'];
  dm.IBQuery1.ParamByName('endereco').AsString     :=  arq.Values['2'];
  dm.IBQuery1.ParamByName('cep').AsString          :=  arq.Values['3'];
  dm.IBQuery1.ParamByName('fone').AsString         :=  arq.Values['4'];
  dm.IBQuery1.ParamByName('fax').AsString          :=  arq.Values['5'];
  dm.IBQuery1.ParamByName('cidade').AsString       :=  arq.Values['6'];
  dm.IBQuery1.ParamByName('estado').AsString       :=  arq.Values['7'];
  dm.IBQuery1.ParamByName('contato').AsString      :=  trim(arq.Values['8']);
  dm.IBQuery1.ParamByName('obs').AsString          :=  arq.Values['9'];
  dm.IBQuery1.ParamByName('bairro').AsString       :=  arq.Values['10'];
  dm.IBQuery1.ParamByName('cnpj').AsString         :=  arq.Values['11'];
  dm.IBQuery1.ParamByName('ies').AsString          :=  arq.Values['12'];
  dm.IBQuery1.ParamByName('cod_mun').AsString      :=  StrNum(arq.Values['13']);
  dm.IBQuery1.ParamByName('suframa').AsString      :=  arq.Values['14'];
  dm.IBQuery1.ParamByName('tipo').AsString         :=  StrNum(arq.Values['15']);
  try
    dm.IBQuery1.ExecSQL;
  except
    on e:Exception do
      begin
        ShowMessage('ERRO: ' + arq.GetText + #13 + e.Message);
      end;
  end;
end;


procedure Tfuncoes.restartGeneratorPelaTabelaMax(tabela, generator : String);
var
  genVaue : Integer;
begin
  genVaue := 0;
  dm.IBQuery1.Close;
  dm.IBQuery1.SQL.Text := 'select (max(cod) + 1) as cod from ' + tabela;
  dm.IBQuery1.Open;

  if dm.IBQuery1.IsEmpty = false then genVaue := dm.IBQuery1.fieldbyname('cod').AsInteger;

  dm.IBQuery1.Close;
  dm.IBQuery1.SQL.Text := 'alter sequence ' + generator + ' restart with ' + IntToStr(genVaue);
  if genVaue > 0 then dm.IBQuery1.ExecSQL;

  if dm.IBQuery1.Transaction.InTransaction then dm.IBQuery1.Transaction.Commit; 
end;


function Tfuncoes.emiteNfe(nota : String = ''; simplificado : boolean = false) : boolean;
var
  cOp,tipo,cliente, infoAdi, frete, vFrete, notaNFe,
  th, DEST_NFE, COD_PAIS, _ORIGEM, FIN_NFE, nCF, nCaixa,
  CHAVE_REF, NFE_REF, natOP1, nomeFIN_NFE, DOC_REF, TAG_DOCREF, NUM_ECF, NUM_COO,
  VLR_DESP, ARREDONDA_QTD, UF_EMI, UF_DEST, estorno, coo : string;
  notas : TStringList;
  i, fim : integer;
  existe_vendas, ok : boolean;
begin
  TAG_DOCREF  := '';
  th := '';
  natOP1 := '';
  try
    funcoes.Mensagem(Application.Title,'Aguarde Conectando com o servidor...',12,'Courier New',false,0, clRed);
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

  If simplificado then
    begin
      nota := Incrementa_Generator('venda', 0);
      //nota := IntToStr(StrToIntDef(nota,0) - 1);
    end;

  //if nota = '' then begin
    nota := funcoes.dialogo('not',0,'1234567890'+#8+#32,50,simplificado,'',Application.Title,'Qual a Nota de Venda?',nota);
    if nota = '*' then exit;
  //end;

  if not simplificado then begin
  if nota = '' then
    begin
      nCF := funcoes.dialogo('not',0,'1234567890'+#8+#32,50,true,'',Application.Title,'Qual o Número do Cupom Fiscal ?','');
      if nCF = '*' then exit;

      nCaixa := funcoes.dialogo('not',0,'1234567890'+#8+#32,50,true,'',Application.Title,'Qual o Número do Caixa ?','');
      if nCaixa = '*' then exit;

      if length(nCF)    <> 6 then nCF    := strzero(nCF, 6);
      if length(nCaixa) <> 3 then nCaixa := strzero(nCaixa, 3);

      nota := funcoes.acha_vendaCCF(nCF + nCaixa);
      if nota = '' then
        begin
          nota := funcoes.buscaVendaNFCe(ncf, nCaixa, NFE_REF);
          if length(NFE_REF) = 44 then TAG_DOCREF := '<NFref><refNFe>' + StrNum(NFE_REF) + '</refNFe></NFref>';
        end
      else
        begin
          coo := funcoes.dialogo('not',0,'1234567890'+#8+#32,50,true,'',Application.Title,'Qual o Número do Coo do Cupom ?','');
          if coo = '*' then exit;

          if coo = '' then
            begin
              MessageDlg('Para a Emissão Desta NFe é Necessário Informar o COO do Cupom Fiscal', mtInformation, [mbOK], 1);
              exit;
            end;

          TAG_DOCREF := '<NFref><refECF><mod>2D</mod><nECF>'+ StrNum(nCaixa) +'</nECF><nCOO>'+StrNum(coo)+'</nCOO></refECF></NFref>';
        end;
        
      if nota = '' then
        begin
          ShowMessage('Cupom Fiscal Não Encontrado: ' + nCF);
          exit;
        end
      else
        begin
          ShowMessage('Nota de Pedido: ' + nota);
        end;

      cOp := '5929';
    end;

  dm.IBselect.Close;
  dm.IBselect.SQL.Text := 'select chave from nfce where nota = :nota';
  dm.IBselect.ParamByName('nota').AsInteger := StrToIntDef(nota, 0);
  dm.IBselect.Open;

  if not dm.IBselect.IsEmpty then
    begin
      cOp := '5929';
    end;

  end;   

  existe_vendas := false;

  Retorna_Array_de_Numero_de_Notas(notas , nota);
  fim := notas.Count - 1;
  for i := 0 to fim do
    begin
      dm.IBselect.Close;
      dm.IBselect.SQL.Clear;
      dm.IBselect.SQL.Add('select cliente from venda where (nota = ' + notas.Strings[i] +') and (cancelado = 0)');
      dm.IBselect.Open;

      if not dm.IBselect.IsEmpty then
        begin
          existe_vendas := true;
        end;
    end;

  if not existe_vendas then
    begin
      ShowMessage('Nota Não Encontrada!');
      dm.IBselect.Close;
      exit;
    end;

  if simplificado = false then begin
    if Form22.usuario = 'ADMIN' then notaNFe := funcoes.dialogo('not',0,'1234567890'+#8+#32,50,true,'',Application.Title,'Confirme o Numero da Nota Fiscal?',IntToStr(strtoint(Incrementa_Generator('nfe',0))  ))
    else notaNFe := funcoes.dialogo('noteditavel',0,'EST'+#27,50,true,'S',Application.Title,'Confirme o Numero da Nota Fiscal?', IfThen(IntToStr(strtoint(Incrementa_Generator('nfe',0))) = '0', '1', IntToStr(strtoint(Incrementa_Generator('nfe',0)))) );
  end
  else begin
    notaNFe := Incrementa_Generator('nfe',0);
  end;

  if notaNFe = '*' then exit;

  cliente := '';
  cliente := dm.IBselect.fieldbyname('cliente').AsString;
  dm.IBselect.Close;

  if simplificado = false then begin
    FIN_NFE := funcoes.dialogo('generico',0,'1234',50,true,'S',Application.Title,'Qual a finalidade da NF-e (1-Normal, 2-Complementar, 3-De ajuste, 4-Devolução de Mercadoria)?','1');
    if FIN_NFE = '*' then exit;
  end
  else FIN_NFE := '1';

  CHAVE_REF   := '';
  NFE_REF     := '';
  nomeFIN_NFE := '';
  infoAdi     := '';
  
  if funcoes.Contido(FIN_NFE, '2-3-4') then
    begin
      if FIN_NFE = '2' then nomeFIN_NFE       := 'em complemento'
       else if FIN_NFE = '3' then nomeFIN_NFE := 'de Ajuste'
       else if FIN_NFE = '4' then nomeFIN_NFE := 'de Devolucao'
       else nomeFIN_NFE := 'Referenciada';

      DOC_REF := funcoes.dialogo('generico',0,'1234',50,true,'S',Application.Title,'Será necessario referenciar um documento fiscal para completar esta operacao. '+ #13 + 'Qual o tipo do documento (1-NF-e Emitida, 2-NFC-e Emitida, 3-NF-e de Compra, 4-Cupom Fiscal de ECF)?','1');
      if DOC_REF = '*' then exit;

      if funcoes.Contido(StrNum(DOC_REF), '1') then
        begin
          NFE_REF := funcoes.dialogo('generico',0,'1234567890' + #8,50,true,'',Application.Title,'Qual o numero da NF-e original a ser Complementada/Ajustada/Devolvida ?','');
          if NFE_REF = '*' then exit;

          estorno :=  funcoes.dialogo('generico',0,'SN',50,true,'S',Application.Title,'Nota Fiscal de Estorno ?','S');
          if estorno = '*' then exit;

          NFE_REF := funcoes.recuperaChaveNFe(NFE_REF);
          if Length(StrNum(NFE_REF)) = 44 then
            begin
              TAG_DOCREF := '<NFref><refNFe>' + StrNum(NFE_REF) + '</refNFe></NFref>';
              infoAdi := 'NF-e '+ nomeFIN_NFE +' a NF-e Chave: ' + StrNum(NFE_REF) + ';';
            end;
        end
      else if funcoes.Contido(StrNum(DOC_REF), '23') then
        begin
          NFE_REF := funcoes.dialogo('mask',300, '!0000.0000.0000.0000.0000.0000.0000.0000.0000.0000.0000;1;_', 300, false, '', 'ControlW', 'Informe a Chave:', '');
          if NFE_REF = '*' then exit;

          if FIN_NFE = '3' then
            begin
              natOP1 := funcoes.dialogo('normal',3,'',60,true,'','ControlW','Descrição da Natureza da Operação:','');
              if trim(natOP1) = '' then exit;
              
              if natOP1 = '*' then exit;
            end;

          if Length(StrNum(NFE_REF)) = 44 then
            begin
              TAG_DOCREF := '<NFref><refNFe>' + StrNum(NFE_REF) + '</refNFe></NFref>';
              infoAdi := 'NF-e '+ nomeFIN_NFE +' a NF-e Chave: ' + StrNum(NFE_REF) + ';';
            end;
        end
      else if funcoes.Contido(StrNum(DOC_REF), '4') then
        begin
          NUM_ECF := funcoes.dialogo('not',0,'1234567890'+#8,50,false,'',Application.Title,'Informe o numero do ECF:','');
          if NUM_ECF = '*' then exit;

          NUM_COO := funcoes.dialogo('not',0,'1234567890'+#8,50,false,'',Application.Title,'Informe o numero do COO:','');
          if NUM_COO = '*' then exit;

          TAG_DOCREF := '<NFref><refECF><mod>2D</mod><nECF>' + StrNum(NUM_ECF) + '</nECF>' + '<nCOO>' + StrNum(NUM_COO)+ '</nCOO>' + '</refECF></NFref>';
          infoAdi := 'NF-e '+ nomeFIN_NFE +' do ECF: ' + StrNum(NUM_ECF) + ' COO: ' + StrNum(NUM_COO) +';';
        end;

      {NFE_REF := funcoes.dialogo('not',0,'1234567890'+#8+#32,50,true,'',Application.Title,'Qual o numero da NF-e original a ser Complementada/Ajustada ?','');
      if NFE_REF = '*' then exit;}

      //CHAVE_REF := funcoes.recuperaChaveNFe(NFE_REF);
      CHAVE_REF := StrNum(NFE_REF);
    end;

  if simplificado = false then begin
    tipo := funcoes.dialogo('generico',0,'EST'+#27,50,true,'S',Application.Title,'Nota Fiscal de Entrada, Saída ou Transferência (E/S/T) ?','S');
    if tipo = '*' then exit;

    _ORIGEM := '0';
    _ORIGEM := funcoes.dialogo('generico',0,'012'+#27,50,true,'S',Application.Title,'Qual a Origem da Mercadoria (0-Nacional, 1-Estrangeira, 2-Estrageira Ad. Merc. Interno)?', _origem);

    DEST_NFE := '1';
    DEST_NFE := funcoes.dialogo('generico',0,'12',50,true,'S',Application.Title,'Qual o destino da Mercadoria (1-Mercado Interno 2-Comercio Exterior)?', DEST_NFE);
    if DEST_NFE = '*' then exit;
  end
  else begin
    tipo     := 'S';
    _ORIGEM  := '0';
    DEST_NFE := '1';
  end;


  COD_PAIS := '1058';
  //cOp := '';
  if DEST_NFE = '2' then
    begin
      cOp := '7102';

      dm.IBselect.Close;
      dm.IBselect.SQL.Clear;
      dm.IBselect.SQL.Add('select cod from cod_op where cod = :cod');
      dm.IBselect.ParamByName('cod').AsString := '7102';
      dm.IBselect.Open;

      if dm.IBselect.IsEmpty then
        begin
          dm.IBQuery1.Close;
          dm.IBQuery1.SQL.Clear;
          dm.IBQuery1.SQL.Add('update or insert into cod_op(cod, nome) values(:cod, :nome) matching(cod)');
          dm.IBQuery1.ParamByName('cod').AsString := '7102';
          dm.IBQuery1.ParamByName('nome').AsString := 'VEND MERC AD TERC-COM. EXT.';
          dm.IBQuery1.ExecSQL;

          dm.IBQuery1.Transaction.Commit;
        end;

      dm.IBselect.Close;

      COD_PAIS := funcoes.VE_PAIS();
    end;

  cOp := '5102';  
  if cOp = '' then
    begin
      dm.IBselect.Close;
      dm.IBselect.SQL.Clear;
      dm.IBselect.SQL.Add('select nfe from acesso where substring(acesso from 1 for 1) = ''-''');
      dm.IBselect.Open;

      cOp := dm.IBselect.fieldbyname('nfe').AsString;
      dm.IBselect.Close;
    end;

  if cop = '*' then exit;

  {infoAdi := '';
  if length(StrNum(CHAVE_REF)) = 44 then
    begin
      if FIN_NFE = '2' then nomeFIN_NFE := 'em complemento'
       else if FIN_NFE = '3' then nomeFIN_NFE := 'de Ajuste'
       else if FIN_NFE = '4' then nomeFIN_NFE := 'de Devolução'
       else nomeFIN_NFE := 'Referenciada';

      infoAdi := 'NF-e '+ nomeFIN_NFE +' a NF-e Chave: ' + StrNum(CHAVE_REF) + ';';
    end;}

  if simplificado = false then begin
    infoAdi := funcoes.MensagemTextoInput('Informações Adicionais', infoAdi);
  end;

  while true do begin
    cliente := funcoes.dialogo('generico',0,'1234567890,.'+#8,50,false,'',Application.Title,'Qual o Código do Cliente?',cliente);
    cliente := trim(cliente);
    if cliente = '*' then exit;
    if cliente = '' then cliente := funcoes.localizar('Localizar Cliente','cliente','cod,nome,telres,telcom,cnpj as cpfcnpj,bairro','cod','','nome','nome',false,false,false,'',450, nil);
    if (cliente = '*') then
      begin
        ShowMessage('Para emitir uma NFe é necessario um cliente.');
        exit;
      end;

    if verificaDadosClienteNFe(StrNum(cliente)) then break;
  end;

    dm.IBselect.Close;
    dm.IBselect.SQL.Text := 'select est from registro';
    dm.IBselect.Open;

    UF_EMI := dm.IBselect.fieldbyname('est').AsString;

    dm.IBselect.Close;
    dm.IBselect.SQL.Text := 'select est from cliente where cod = :cod';
    dm.IBselect.ParamByName('cod').AsString := StrNum(cliente);
    dm.IBselect.Open;

    UF_DEST := dm.IBselect.fieldbyname('est').AsString;
    dm.IBselect.Close;

  if DEST_NFE = '2' then cOp := '7102'
  else if (UF_EMI <> UF_DEST) then
    begin
      cOp := '6102'
    end;

  ok := false;
  if simplificado = false then begin
  while not ok do
    begin
      cop := funcoes.dialogo('generico',0,'1234567890,.'+#8,50,false,'',Application.Title,'Qual o Código da Operação?',cOp);
      if cop = '' then cop := funcoes.localizar('Localizar cOP','cod_op','cod,nome','cod','','nome','cod',false,false,false,'',0,nil);
      if cop = '*' then break;

      if ((tipo = 'E') and (funcoes.Contido(LeftStr(cop, 1), '123'))) or ((tipo = 'S') and (funcoes.Contido(LeftStr(cop, 1), '567'))) then
        begin
          ok := true;
        end
      else if ((tipo = 'T') and (funcoes.Contido(LeftStr(cop, 1), '1234567'))) then
        begin
          ok := true;
        end
      else ShowMessage('O código do CFOP é inválido para esta operação. Para entrada use CFOP que ' + #13 +#10 +'se inicie com 1, 2 ou 3. Para saída use CFOP que se inicie com 5, 6 ou 7.');

      if ok then
        begin
          dm.IBQuery2.Close;
          dm.IBQuery2.SQL.Clear;
          dm.IBQuery2.SQL.Add('select * from cod_op where cod = :cod');
          dm.IBQuery2.ParamByName('cod').AsString := funcoes.StrNum(cOp);
          dm.IBQuery2.Open;

          if dm.IBQuery2.IsEmpty then
            begin
              if cop = '5929' then
                begin
                  dm.IBQuery1.Close;
                  dm.IBQuery1.SQL.Text := 'insert into cod_op(cod, nome, pis, icms) values(5929, ''LANCAMENTO REGISTRADO EM ECF'', ''I'', ''I'')';
                  dm.IBQuery1.ExecSQL;
                  dm.IBQuery1.Transaction.Commit;

                  dm.IBQuery2.Close;
                  dm.IBQuery2.SQL.Clear;
                  dm.IBQuery2.SQL.Add('select * from cod_op where cod = :cod');
                  dm.IBQuery2.ParamByName('cod').AsString := funcoes.StrNum(cOp);
                  dm.IBQuery2.Open;

                  natOP1 := 'LANCAMENTO REGISTRADO EM ECF';
                end;
              dm.IBQuery2.Close;
              ShowMessage('Código de Operação '+cop+' Não está Cadastrado.');
              exit;
            end
          else
            begin
              if natOP1 = '' then natOP1 := dm.IBQuery2.fieldbyname('nome').AsString;
              ok := true;
            end;
        end;
    end;

    end
    else begin
      dm.IBQuery2.Close;
      dm.IBQuery2.SQL.Clear;
      dm.IBQuery2.SQL.Add('select * from cod_op where cod = :cod');
      dm.IBQuery2.ParamByName('cod').AsString := funcoes.StrNum(cOp);
      dm.IBQuery2.Open;

      natOP1 := dm.IBQuery2.fieldbyname('nome').AsString;
      //dm.IBQuery2.Close;
    end;



  if estorno = 'S' then
    begin
      natOP1 := '999 - Estorno de NF-e não cancelada no prazo legal';
    end;

  if cop = '*' then exit;

  dm.IBselect.Close;
  dm.IBselect.SQL.Clear;
  dm.IBselect.SQL.Add('select cod from cliente where cod = :cod');
  dm.IBselect.ParamByName('cod').AsString := funcoes.StrNum(cliente);
  dm.IBselect.Open;

  if dm.IBselect.IsEmpty then
    begin
      dm.IBselect.Close;
      ShowMessage('Cliente '+cliente+' Não Encontrado.');
      exit;
    end;

  dm.IBselect.Close;

  nfevenda := tnfevenda.Create(self);
  NfeVenda.dest := cliente;

  if simplificado = false then begin

    if ConfParamGerais.Strings[15] = 'S' then
      begin
        frete := funcoes.dialogo('generico',0,'190,.'+#8,50,false,'',Application.Title,'Frete por Conta do: (0-Emitente 1-Destinatário 9-Sem Frete)?','9');
        if frete = '*' then exit;
        if frete <> '9' then
          begin
            nfevenda.frete := TStringList.Create;
            //nfevenda.frete.Add('');
            nfevenda.frete.Values['0'] := (frete);
            form43 := tform43.Create(self);
            form43.ShowModal;
            vFrete := funcoes.dialogo('numero',0,'190,.'+#8,2,false,'',Application.Title,'Qual o valor do Frete?','0,00');
            if vFrete = '*' then exit;
            if nfevenda.frete = nil then exit;
          end;
      end;

    if ConfParamGerais.Strings[15] = 'S' then
      begin
        try
          NfeVenda.tipo_frete := StrToInt(funcoes.StrNum(frete));
          NfeVenda.TotalFrete := StrToCurr(funcoes.ConverteNumerico(vFrete));
        except
          on e:exception do
            begin
              MessageDlg('Erro: ' + e.Message, mtError, [mbOK], 1);
              exit;
            end;
        end;
      end
    else NfeVenda.tipo_frete := 9;
  end
  else begin
    NfeVenda.tipo_frete := 9;
  end;

  VLR_DESP := '0';

  if simplificado = false then begin
    VLR_DESP := funcoes.dialogo('generico',0,'SN',50,true,'S',Application.Title,'Deseja informar valor de despesas acessorias ?','N');
    if VLR_DESP = '*' then exit;

    if VLR_DESP = 'S' then
      begin
        VLR_DESP := funcoes.dialogo('numero',0,'SN',2,true,'S',Application.Title,'Qual o valor das despesas acessorias ?','0,00');
        if VLR_DESP = '*' then exit;
      end
    else VLR_DESP := '0';
  end;

{  ARREDONDA_QTD := funcoes.dialogo('generico',0,'SN',50,true,'S',Application.Title,'Deseja Forçar Arredondamento para Efetuar a Equivalencia de Totais ?','N');
  if ARREDONDA_QTD = '*' then exit;

  if ARREDONDA_QTD = 'S' then NfeVenda.arredondarQTD := true
    else  NfeVenda.arredondarQTD := false;}

  NfeVenda.UF_EMI  := UF_EMI;
  NfeVenda.UF_DEST := UF_DEST;
  NfeVenda.VLR_DESP := StrToCurrDef(VLR_DESP, 0);
  NfeVenda.codNFe := notaNFe;
  NfeVenda.cod_OP := cop;
  NfeVenda.codPaisDest := COD_PAIS;

  NfeVenda.natOp      := natOP1;
  NfeVenda.cstIcmCfop := dm.IBQuery2.fieldbyname('icms').AsString;
  NfeVenda.cstpisCfop := dm.IBQuery2.fieldbyname('pis').AsString;
  dm.IBQuery2.Close;

  NfeVenda.tipo     := tipo;
  NfeVenda.DEST_NFE := DEST_NFE;
  NfeVenda.infAdic  := infoAdi;
  NfeVenda.notas    := notas;
  NfeVenda._ORIGEM  := _ORIGEM;
  NfeVenda.FIN_NFE1 := FIN_NFE;
  NfeVenda.TAG_DOCREF := TAG_DOCREF;
  nfevenda.NFE_REF  := StrNum(NFE_REF);

  try
    if ConfParamGerais[36] <> 'N' then NfeVenda.GeraXml
      else NfeVenda.GeraXml1;
  except
    on e:exception do
      begin
        MessageDlg('Erro: ' + e.Message, mtError, [mbOK], 1);
        if funcoes.Contido('LENGTH', UpperCase(e.Message)) then
          begin
            //NfeVenda.GeraXml;
          END;
      end;
  end;
  nfevenda.free;
end;

function Tfuncoes.limitar_QTD_Estoque(quant : currency; cod, origem : integer) : boolean;
var
  campo, permitir : string;
begin
  if origem = 1 then campo := 'quant'
    else campo := 'deposito';
  Result := true;

  dm.IBQuery4.Close;
  dm.IBQuery4.SQL.Text := 'select ' + campo + ' from produto where cod = :cod';
  dm.IBQuery4.ParamByName('cod').AsInteger := cod;
  dm.IBQuery4.Open;

  permitir := 'S';
  //permitir := funcoes.LerConfig(form22.Pgerais.Values['configu'], 7);

  if quant > dm.IBQuery4.FieldByName(campo).AsCurrency then
    begin
      if permitir <> 'N' then //permitir venda sem estoque disponivel
        begin
          WWMessage('A Venda Esta Sendo Feita Sem Estoque Disponivel',mtInformation,[mbOK],HexToTColor('FFD700'),true,false,HexToTColor('FE3C3C'));
        end
      else
        begin
          WWMessage('O Produto Nao Tem Estoque Disponivel',mtInformation,[mbOK],HexToTColor('FFD700'),true,false,HexToTColor('B22222'));
          Result := false;
        end;
    end;

  dm.IBQuery4.Close;
end;

procedure Tfuncoes.alinhabdgrid(var bdgrid : TDBGrid);
var
  ini, size1 : integer;
begin
  size1 := screen.Width;
  for ini := 0 to bdgrid.Columns.Count - 1 do begin
    if bdgrid.Columns[ini].Field.DataType = ftInteger then begin
      if size1 = 1024 then begin
        bdgrid.Columns[ini].Width := 50;
      end;
    end;
  end;
end;


end.
