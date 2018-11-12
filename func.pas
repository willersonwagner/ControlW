unit func;

interface

uses
  StdCtrls, Controls, Forms, Windows, Messages, SysUtils, IBQuery, Variants,
  Classes, Graphics,
  Dialogs, IniFiles, SHELLAPI, db, dbgrids, ComCtrls, richedit, dbclient,
  IBDatabase,
  IBCustomDataSet, ExtCtrls, printers, funcoesDAV, OleCtrls,
  SHDocVw, IdComponent, IdTCPConnection, sbutton, IdTCPClient, IdHTTP,
  IdBaseComponent, IdAntiFreezeBase, IdAntiFreeze, WinInet, RxCalc, IdFTP,
  IdTime, ibsql, shlobj, Grids, Registry, ActiveX, ComObj, Provider, jsedit1,
  SyncObjs, IdUDPBase, classes1, IdUDPClient, IdSNTP,
  IdExplicitTLSClientServerBase, ACBrETQ, Vcl.FileCtrl,
  TLHelp32, PsAPI, ACBrCargaBal, pcnConversaoNFe,
  pcnConversao, System.Zip, ACBrMail
  , IdMultipartFormData;

const
  OffsetMemoryStream: Int64 = 0;

type
  Ptr_Item = ^Item_pagamento;

  Item_pagamento = record
    codFormaPagamento: integer;
    codVendedor: integer;
    total: currency;
  end;

  TTWtheadEnviaCupons1 = class(TThread)
  private
    timer0: TTimer;
    label1: TLabel;
    Fcount: integer;
    enviandoCupom: boolean;
    SessaoCritica: TcriticalSection;
  protected
    procedure Execute; override;
  public
    constructor Create(CreateSuspended: boolean; lab1: TLabel); overload;
    procedure enviaCupons;
  end;

  TTWThreadVerificaPagamento = class(TThread)
  private
    SessaoCritica: TcriticalSection;
  protected
    procedure Execute; override;
  public
    constructor Create(const CreateSuspended: boolean);
  end;

  Ptr_sinc = ^Item_sinc;

  Item_sinc = record
    cod: integer;
    nome: String;
    p_vendaEstoque: currency;
    p_vendaSincronizacao: currency;
  end;

  Ptr_nota = ^Item_nota;

  Item_nota = record
    cod: integer;
    codigoFornecedor: String;
    numProd: integer;
    nome: string[40];
    quant: currency;
    qtd: currency;
    preco: currency;
    preco1: currency;
    total: currency;
    p_icms: currency;
    vDeson: currency;
    totNota: currency;
    CSTICMS : String;
    CSTPIS  : String;
    ICMSOSN : string;
    unid: string[8];
    codbar: string[15];
    data: TDateTime;
    nota: string;
    NCM: string;
  end;

type
  Tfuncoes = class(TForm)
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
    IdSNTP1: TIdSNTP;
    procedure FormCreate(Sender: TObject);
    procedure WebBrowser1DocumentComplete(Sender: TObject;
      const pDisp: IDispatch; var URL: OleVariant);
    procedure Timer1Timer(Sender: TObject);
    procedure Timer3Timer(Sender: TObject);
  private
    retornobusca: string;
    texto: String;
    cdsEquiva: TClientDataSet;
    buscaTimer: String;
    listaProdutos: Tprodutos;

    procedure corrigeUnidades();
    procedure SOMA_EST(const cod: integer; const qtd, DEP: currency;
      var lista: TItensAcumProd);
    procedure Button1Click(Sender: TObject);
    procedure MeuKeyPress1(Sender: TObject; var Key: Char);
    FUNCTION BUSCA_EST(cod: integer; var QTD_LOJA, QTD_DEP: currency;
      var lista: TItensAcumProd): boolean;
    procedure atualizaMSGsObsVenda();
    function imprimeOBS_Servico(tipo : String = 'M') : integer;
    { Private declarations }
  public
    inicio1: Smallint;
    cds1: TClientDataSet;
    botao: TsButton;
    lista1, notaNFe, fornecNFe: string;
    valordg: string;
    formpato: string;
    info, infadic: string;
    retornoLocalizar, bloq: string;
    ReParcelamento: tstringList;
    OK: boolean;
    Simbolos: array [0 .. 4] of String;
    enviandoCupom, enviandoBackup: boolean;
    fonteRelatorioForm19: integer;
    NegritoRelatorioForm19, saiComEnter: boolean;
    function VerSeExisteTRIGGERPeloNome(Const nome: String): boolean;
    function primeiroDiaDoMes() : boolean;
    procedure adicionaNFCeNaoEncontrada(num, ser : String);
    function CompletaString(parcial : string) : string;
    procedure atualizaRecebido(recebido : currency; nota : integer);
    procedure verificaLancamentosDuplicadosCaixa(ini, fim : String);
    function buscaAliquotaPadraoParamGerais() : String;
    procedure comparaProdutosComAFicha();
    function buscaAliqPISxml(cst : String; icmsosn : String) : string;
    function buscaAliqICMSxml(cst : String; icmsosn : String) : string;
    procedure verificaregistrosDuplicadosCaixa();
    function buscaConfigEmail(): String;
    procedure AutoSizeDBGrid(const xDBGrid: TDBGrid);
    function Ret_Numero(Key: Char; texto: string;
      EhDecimal: boolean = False): Char;
    function nomeExec(): String;
    function buscaDescontoProduto(const cod: integer): currency;
    function buscaNomeConfigDat(): string;
    procedure duplicarRichedit(vezes: Smallint);
    procedure enviarEmail();
    procedure InutilizarNFCE(nnf: String = '');
    procedure manutencaoNFCe();
    function showListBox(caption, label1: string; lista: TStrings;
      default: String): string;
    procedure enviarSPED_Email;
    procedure arrumaDataRegistroNFCe(dialog: boolean = true);
    procedure enviaXMLsEmail;
    procedure descompactaIBPT;
    function buscaOrigemDaNfe(): string;
    procedure fazBackupMandaPorEmail();
    function retornaConteudoPeloTipo1(var query: TIBQuery;
      nomeCampo: String): String;
    function retornaConteudoPeloTipo(const conteudo: String;
      tipo: TFieldType): String;
    function UnZip(ZipName: string; Destination: string): boolean;
    // Descompacta
    function exportaGenerators(tabela, CAMPOS: String; var arq: TextFile;
      var query: TIBQuery): boolean;
    procedure restaurarbackup();
    function Zip(Files: tstringList; ZipName: String): boolean;
    // Compactaos arquivos
    procedure configuraMail(var mail: TACBrMail; tipo: Smallint = 0);
    procedure adicionaNFes();
    procedure atualizaTabelaIBPT(forcar: boolean = False);
    function buscaVersaoIBPT_Site(tipo: Smallint = 1): String;
    function buscaMSG_Venda(nota1: String): String;
    procedure LimparEntregues(nota: String);
    procedure distribuicaoNFe();
    procedure RelVendasPorVendedor(tipo: String);
    function FileAgeCreate1(const fileName: string): TDateTime;
    function TerminarProcesso(sFile: String): boolean;
    procedure reiniciaDAVNFCe();
    procedure verificaDavNFCeTravado();
    procedure IMPBOLETO_Duplicata();
    function le_Arquivo(CaminhoBoleto: String;
      var temp: TClientDataSet): boolean;
    procedure IMPBOLETO();
    procedure PreencheCSOSN_Aliq();
    procedure enxugaAliquotas();
    function verificaSePodeEmitirNFe(): boolean;
    function geraStringConfigUsuario(var valor: String; count: integer): String;
    procedure imprimeDuplicata(nota: String = '');
    procedure imprimePromissoria(nota: String = '');
    procedure mensagemEnviandoNFCE(const msg: String; abrir, fechar: boolean);
    function verificaNFe(dataIni: String = ''; DataFim: String = '';
      sped: boolean = False): boolean;
    function FiltraNota(var nota, fornec: string;
      inicio: boolean = False): boolean;
    procedure le_promoc1(var text: string);
    procedure criaSerieBD();
    procedure fetchDataSet(var querysql: TIBQuery);
    function GeraCargaTXTBalanca(): boolean;
    function excluiTransferencia(cod, doc: integer): boolean;
    function verificaNFCe(dataIni: String = ''; DataFim: String = '';
      sped: boolean = False): boolean;
    procedure validaDataHora(var dataMo: TDateTime; USUARIO: STRING);
    function listaUnidades: String;
    function ajustaHoraPelaInternet(var dataMov: TDateTime): boolean;
    function listaUnidadesComDescricoes: TStrings;
    function buscaCorBDGRID_Produto(opcao: integer = 0): String;
    function checaEntradasSped(ini, fim: String): boolean;
    procedure recalculaEntradas();
    function excluiAqruivo(arq: String): boolean;
    Function Inscricao(Inscricao, tipo: String): boolean;
    Function Mascara_Inscricao(Inscricao, Estado: String): String;
    function validaCFOP_UF(cfop, UF_DEST, UF_EMIT: String): boolean;
    procedure fechaClientDataSet(var ccds: TClientDataSet);
    procedure alinhabdgrid(var bdgrid: TDBGrid);
    function limitar_QTD_Estoque(quant: currency; cod, origem: integer)
      : boolean;
    function emiteNfe(nota: String = ''; simplificado: boolean = False;
      venda: boolean = False): boolean;
    procedure restartGeneratorPelaTabelaMax(tabela, generator: String);
    function recebeFornecedores(var arq: tstringList): boolean;
    function recebePromoc1(var arq: tstringList; var codigos: String): boolean;
    function exportaFornecedores(var arq: TextFile): boolean;
    function exportaPromoc1(var arq: TextFile): boolean;
    function buscaXMl(const path: String; novo: boolean = true): boolean;
    function BuscaBoletos(): boolean;
    function exportaTabela(tabela, CAMPOS: String; var arq: TextFile;
      var query: TIBQuery): boolean;
    function sincronizarArquivoDeRemessa(caminho: String;
      var query: TIBQuery): boolean;
    function criaBackup(): boolean;
    function marcaXMLNFCeParaEnvio(chave, erro, serie: String): boolean;
    function manutencaoDeXml(inicia: Smallint): String;
    function retornaEscalaDoCampo(campo, tabela: String; NOME_CAMPO : string = ''): Smallint;
    procedure criaDataSetVirtualProdutosForm33();
    function buscaUltimaVendaOrcamentoDoUsuario(codUsuario: integer;
      opcao: Smallint): String;
    procedure atualizaCFOPs(atualizaBD: boolean = true);
    procedure atualizaTabelaCest();
    procedure imprimeGrafico(tipo, nota, vendedor: String;
      listaProdutos1: TItensProduto; desconto: currency);
    function DSiFileSize(const fileName: string): Int64;
    function Trunca(const nValor: currency; const iCasas: integer): currency;
    procedure AjustaForm(Formulario: TForm; nTamOriginal: integer = 800);
    function getDiasBloqueioRestantes(soDiasParaBloquear
      : boolean = False): integer;
    procedure BuscaAplicacao(CONST SQL: sTRING; VAR GRID1: TDBGrid;
      ORDENACAMP: boolean);
    function DeleteFolder(FolderName: String): boolean;
    procedure somenteNumeros(var Key: Char);
    function buscaVendaNFCe(nnf, serie: String; var chave: String): String;
    function buscaVendaECF(nnf, serie: String): String;
    function BrowseForFolderCallBack(Wnd: HWND; uMsg: UINT;
      lParam, lpData: lParam): integer stdcall;
    function cadastroClienteNFCeRetornaCod(total: currency = 0;
      cod: integer = 0): string;
    function vercCountContigencia(): integer;
    procedure gravaAlteracao(altera: String; tipo : String = '');
    function buscaParamGeral(indice: integer; deafault: String): String;
    procedure aumentaFonte(formula: TForm; dbgridr: boolean; opcao: integer;
      redimensionar: boolean = False);
    procedure adicionaRegistrosBloqueio();
    procedure dbgrid1Registro(var dbgrid44: TDBGrid);
    Function testacpf(cpf: string): boolean;
    function isCPF(cpf: string): boolean;
    function lista11: string;
    FUNCTION VE_CODISPIS(_CODISPIS, _ISPIS: String): string;
    function buscaFieldDBgrid1(const nome: String; var grid: TDBGrid): integer;
    function buscaFieldDBgrid(const nome: String; var grid: TDBGrid): tfield;
    procedure ordernaDataSetVenda(const ordem1, valorLocate, sqlVenda: String;
      var dbgrid99: TDBGrid; ordem2: string = ''; ordenaCampos: boolean = true);
    procedure mostraValorDinheiroTela(const valor: currency);
    function buscaNomeSite(): String;
    function le_configTerminalWindows(posi: integer; padrao: string): String;
    function exportaNFCeEmitidas(email: boolean = False; ini: String = '';
      fim: String = ''): string;
    procedure limpaBloqueado(var quer: TIBQuery);
    function buscaDiasBloqueio(): integer;
    procedure adicionaRegistroDataBloqueio(const mostraMensagem,
      adicionaBloqueio: boolean; var dias: integer; var quer: TIBQuery;
      buscaDiasSite: boolean = False);
    procedure acertarTamanhoDBGRID(var tabela: TDBGrid);
    function dataInglesToBrasil(const data: String): string;
    function buscaProdutoCodCodBar(const cod: String): String;
    function acha_vendaCCF(const ccf_caixa: String): String;
    function entraXMLeRetornaChave(ent: String): string;
    function cadastraFornec(const xml: String): String;
    function insereDadosAdic(const xml: String): Smallint;
    procedure WriteToTXT(const arquivo, linha: string);
    function verValorUnidade(unidade: String): currency;
    procedure descamarcaVenda(const numVenda: String);
    function importaXMLnaEntrada1: boolean;
    function cancelamentoDeNota(const nota: String;
      TROCA: boolean = False): String;
    procedure atualizaVendaDaOrdemDeServico(const cos_os, numVenda: string);
    function lerPosString(const valor: String; const sub: String;
      const posi: integer): integer;
    function lerValorPipePrimeiro1(const valor: String;
      const num: integer): String;
    procedure LeNomesServicos();
    function lerServicoNoBdEcriaUmObjetoOrdem(const cod: String;
      var ordem: TOrdem): boolean;
    function abreVendaSeparaPecasOrdemDeServico(const finaliza,
      orcamento: boolean): boolean;
    Function RelSomatoria_T_(var lista1: Tlist; dini, dfim: String;
      geral: currency): AnsiString;
    procedure fichaDoProduto(sende1: TObject; var te: String;
      const centroTipoLOJADEPOSITO: boolean);
    procedure imprimeOrdemDeServico(var ordem: TOrdem; const orcamento: boolean;
      ImprimeNoFimDaVenda: boolean = False);
    procedure atualizaMensagemUsuario(const mens, nota: String);
    procedure Descomprimir(ArquivoZip: TFileName; DiretorioDestino: string);
    procedure Comprimir(ArquivoCompacto: TFileName;
      Arquivos: array of TFileName);
    function retornaTipoDoCampo(campo, tabela: String;
      nomeTipo: string = 'TIPO'): String;
    function verificaSeExisteIndiceTrueExiste(const indiceName: String)
      : boolean;
    procedure iniciaDataset(var IBQuery: TIBQuery; const SQL: String);
    function retornaTamanhoDoCampoBD(const nomeCampo, tabela: String): Smallint;
    FUNCTION VE_CUSTO(PCOMPRA, PVENDA: currency; cod: String): currency;
    procedure desmarcaVendaPaf(const numVenda: String);
    function trocaChar(texto, velho, novo: string): string;
    procedure limpaMemoria();
    function trocaDeUsuario(): boolean;
    function ImprimirPedidoVias(qtdVias: Smallint;
      orcamento: boolean = False): boolean;
    function formataChaveNFE(const chave: String): String;
    function lerConfigIMPRESSORA(): String;
    function allTrim(const texto: String): String;
    function NomedoComputador: String;
    function buscaConfigTerminal(indice: Smallint; const default: String;
      nomeConfig: String = ''): String;
    function reorganizaClientes: boolean;
    procedure geraPgerais();
    procedure abreDataSetMemoriaEquivalencias();
    function primeiraLetraMaiuscula(const nome: string): string;
    function reorganizaProdutos: boolean;
    function VE_PAIS(): String;
    FUNCTION ATU_ESTOQUE(ACAO: String; var lista: TItensAcumProd;
      cod1: integer = 0): boolean;
    function LE_ESTOQUE(PULA_REGISTRO, SO_VENDAS: boolean;
      var lista: TItensAcumProd; cod1: integer = 0): String;
    procedure VER_ESTOQUE(ACAO, mens, MENS1: String; cod: integer = 0);
    function localizar1(titulo: string; tabela: string; CAMPOS: string;
      retorno: string; esconde: string; localizarPor: string;
      OrdenarPor: string; editLocaliza: boolean; editavel: boolean;
      deletar: boolean; campoLocate: string; keyLocate: String;
      tamanho: integer; compnenteAlinhar: TObject): string;
    function CriaDiretorio(const NomeSubDir: string): boolean;
    function dataDoArquivo(const fileName: string): TDateTime;
    function verFornecedorStringList(xml: string;
      consultaCadastro: boolean = False): tstringList;
    function insereFornec(var matriz: tstringList): String;
    procedure copiaExecutavel();
    procedure mapearLPT1_em_rede();
    procedure copiaXMLEntrada(const xml, chave: String);
    function formataCNPJ(Const cnpj: String): String;
    function importaXMLnaEntrada: boolean;
    function SincronizarExtoque1(CaminhoArq: String): boolean;
    function SincronizarExtoque2(CaminhoArq: String): boolean;
    function receberSincronizacaoExtoque1(CaminhoArq: String): boolean;
    function geraRelFechamento(const cod12: integer; vendedor: String): String;
    function recuperaChaveNFe(const nota: string): string;
    function listaArquivos(const pasta: String): tstringList;
    function dadosAdicSped(xml: String): tstringList;
    procedure executaCalculadora();
    function GerarCodigo(Codigo: String; imagem1: TImage): integer;
    function verificaConexaoComInternetSeTiverTRUEsenaoFALSE: boolean;
    function verEquivalencia(cod: String): String;
    procedure converteDados;
    procedure ResizeLabel(var Sender: TLabel);
    procedure adicionarExcecao;
    procedure SetRetornoBusca(ret: string);
    function IniciaNfe: boolean;
    function StrNum(const entra: string): string;
    function OrdenarValoresStringList(var valor_a_Ser_Ordenado: tstringList)
      : tstringList;
    function RetornaValorConfig(Config: string; posi: integer): variant;
    function GerarPgeraisList(codUsu: string): tstringList;
    function CompararStringLists(var v1: tstringList;
      var v2: tstringList): boolean;
    function GetTheWindowsDirectory: string;
    function GeraNota(numNota: string; tipo: string; EnviarImpressora: string;
      opcao: Smallint): boolean;
    procedure le_Venda(nota: String; var desconto: currency;
      var vendedor: String; var listprod: TItensProduto);
    function lista(var t: TObject; center: boolean; conf : integer  = 0): string;
    function Parcelamento(total: currency; Cliente: string; prazo: string)
      : tstringList;
    function LerIni(valor: string): string;
    function PreparaData(valor: string): TDateTime;
    function ArredondaFinanceiro(Value: currency; Decimals: integer): currency;
    function novocod(gen: string): string;
    function VerSeExisteConfig: boolean;
    function VerSeExisteGeneratorPeloNome(Const nome: String): boolean;
    function VerSeExistePROCEDUREPeloNome(Const nome: String): boolean;
    function dialogo(tipo: string; maxlengt: integer; ValorEntrada: string;
      tamanhocampo: integer; obrigatorio1: boolean; trocaletras: string;
      titulo: string; label1: string; default: string): string;
    function ArredondaTrunca(Value: currency; decimais: integer): Extended;
    function TiraOuTrocaSubstring(StringDeEntrada: string; ValorTrocar: string;
      ValorQSeraSubstituido: string): string;
    function LerFormPato(index: integer; label1: string; escSair: boolean;
      const padrao: string = ''): string;
    function LerIniToStringList: tstringList;
    function LerValorPGerais(nomeConfig: string; arr: tstringList): string;
    function CompletaOuRepete(const valorParaCompletar: AnsiString;
      const ValorFinal: AnsiString; valorParaRepetir: string;
      contadorDeRepeticao: integer): string;
    function RelatorioCabecalho(NomeEmpresa: string; NomeRelatorio: string;
      tamanho: integer): string;
    procedure informacao(posicao: integer; total: integer; informacao: string;
      novo: boolean; fechar: boolean; valorprogressao: integer);
    procedure CtrlResize(var Sender: TForm); export;
    function grelatoriocima(SQLGrupo: string; SQLFornec: string;
      SQLFabric: string; SQLCom2Filtros: string; SQLSemFiltros: string;
      cabecalho: string; NomeDaEmpresa: string; NomeDoRelatorio: string;
      colunas: string): boolean;
    procedure ExecFile(F: String);
    function Contido(substring: string; texto: string): boolean;
    function PerguntasRel(var query: TIBQuery; paramper: string;
      paramverifica: boolean; valorbd: string; valorstring: string): boolean;
    function BuscaNomeBD(var query: TIBQuery; nomeCampo: string;
      NomeTabela: string; condicao: string): string;
    procedure OrdenaCamposVenda(CAMPOS: string);
    procedure FormataCampos(query: TIBQuery; qtdCasasDecimais: integer;
      CampoFormatoDiferente: string; qtd: integer);
    Function ConverteNumerico(valor: string): string;
    function ContaChar(estring: string; sub: string): string;
    function PosFinal(substr: string; texto: string): integer;
    procedure CharSetRichEdit(var rich: TRichEdit; tipo: integer = 0);
    function BrowseForFolder(const browseTitle: String;
      const initialFolder: String = '';
      mayCreateNewFolder: boolean = False): String;
    procedure ResizeForms();
    function localizar(titulo: string; tabela: string; CAMPOS: string;
      retorno: string; esconde: string; localizarPor: string;
      OrdenarPor: string; editLocaliza: boolean; editavel: boolean;
      deletar: boolean; condicao: string; tamanho: integer;
      compnenteAlinhar: TObject): string;
    function busca(var dataset: TIBQuery; busca: string; retorno: string;
      campobusca: string; camposdataset: string): string;
    function procuraMultiplos(entradaDataset: string;
      valorParaComarar: string): boolean;
    function SomaCampoDBGRID(var dataset: TIBQuery; campo: string;
      dataIni: TDateTime; DataFim: TDateTime; dataIgual: TDateTime;
      NomeCampoDataParaComparar: string): currency;
    function valorPorExtenso(vlr: real): string;
    function centraliza(valor: string; repetir: string;
      tamanho: integer): string;
    function GeraAleatorio(valor: integer): string;
    function VerAcesso(param: string): string;
    function DeletaChar(sub: string; texto: string): string;
    function LerConfig(valor: string; posi: integer): string;
    function Criptografar(wStri: String): String;
    function DesCriptografar(wStri: String): String;
    function RetornaMaiorData(v1: TDateTime; v2: TDateTime): TDateTime;
    function TimageToFileStream(caminho: string): TFileStream;
    procedure GeraTemas;
    procedure ImprimeParcelamento(ini, fim, entrada, nota: string);
    function ExisteParcelamento(nota: string): boolean;
    function QuebraLinhas(ini, fim, entrada: string;
      qtdQuebra: integer): string;
    procedure Traca_Nome_Rota;
    procedure GeraCarne(nota, tipo: String);
    procedure Ibquery_to_clienteDataSet(var ibquer: TIBQuery;
      var Cliente: TClientDataSet);
    function RetornaMaiorTstrings(entra: TStrings): string;
    procedure VerificaVersao_do_bd;
    FUNCTION Mensagem(caption: String; Mensagem: string; FontSize: integer;
      fonteLetra: string; btOk: boolean; option: integer; color: TColor; fechar : boolean = false): string;
    FUNCTION MensagemTextoInput(caption, default: string): string;
    function Procura_em_Multiplos_Campos(var data_set: TIBQuery;
      Campo_separados_por_espaco, valorParaComparar: string): boolean;
    procedure CentralizaNoFormulario(var compo: TWinControl; var send: TForm);
    function verificaCodbar(cod, codbar: string; opcao: Smallint): String;
    procedure atualizaBD;
    procedure adicionaConfig(valorQueProvavelmenteExiste, NovoValor: string);
    function verificaPermissaoPagamento(const abreTelaBloqueado
      : boolean = true; abrirDialogo : boolean = true): String;
    FUNCTION IMP_CODBAR(const cod: String): boolean;
    FUNCTION IMP_CODBAR1(const cod: String): boolean;
    function troca_str(texto, valor, novo: string): string;
    procedure restartGeneratorSMALL(gen, valor: String);
    function incrementaGenSmall(nome, valor: String): integer;
    function gravaVendaSmallPendente(nota1: string): string;
    function verVendedor(numVendedor: String): String;
    procedure marcarVendaExportada(nota: String);
    function atualizaAutomatico(): String;
    procedure atualizaHoraDoPCapatirDoServidor();
    function verSeExisteTabela(nome: String): boolean;
    function testaChaveNFE(chave: String): boolean;
    function checaCodbar(vx_cod: String): boolean;
    function checaCodbar1(vx_cod: String): String;
    function buscaCodbarRetornaCodigo(codbar: String;
      pergunta: boolean = False): String;
    function buscaPorCodigotornaCodigoBarrasValido(const cod: String): String;
    function verPermissaoDiaria(const ret: String): String;
    function formataCPF(const cpf: String): String;
    function buscaConfigNaPastaDoControlW(Const config_name: String;
      const default: string): String;
    function buscaConfigNaPastaDoControlW1(Const config_name: String;
      gravaVazio: boolean = False): String;
    function GravaConfigNaPastaDoControlW(Const config_name: String;
      const default: string): String;
    function verProdutoExisteRetornaNome(const cod: string;
      var nome: String): boolean;
    procedure somaQTD_produto_ibquery1_sem_commit(cod: integer;
      var qtd, deposito: currency);
    function senhaDodia: boolean;
    procedure CriarAtalho(ANomeArquivo, AParametros, ADiretorioInicial,
      ANomedoAtalho, APastaDoAtalho: string);
    procedure buscaEquivalencia(codEx: String);
    procedure buscaEquivalencia1(codEx: String);
    FUNCTION GRAVA_MOV(PEDIDO: String; data: TDateTime;
      NF, tipo, COD_CLI: String; GRAV_VENDA: boolean;
      Estado: String = ''): boolean;
    FUNCTION CANC_MOV(NUM_NF, tipo: String): boolean;
    function FORM_DATA_YY_MM_DD(data: TDateTime): String;
    function logar(usu, senha: String): boolean;
    function voltarLogin(var form: TForm): boolean;
    function baixaEstoque(cod: String; quant: currency;
      origem: integer; commit : boolean = true): boolean;

    function baixaEstoqueSP(cod: String; quant: currency;
      origem: integer; commit : boolean = true): boolean;

    function ALTERA_CAIXA(codMOV: INTEGER; VALOR: currency;
      ENTRADA1_SAIDA2: integer; commit : boolean = true): boolean;
    function verificaTamnhoCampoBD(tabela, campo: String;
      tamanhoComparar: integer): boolean;
    function addRegSite(emp1: String; var quer: TIBQuery; abrirDialogo : boolean = true): String;
    procedure procuraTimmer(var dataset: TIBQuery; caracter: Char;
      const campo: String);
    procedure fazBackupDoBD(const rede: boolean);
    procedure criaArqTerminal();
    procedure redimensionaTelaDbgrid(var dbgrid: TDBGrid);
    procedure gravaConfigTerminal(const con: String);
    procedure transformaStringList(var li1, li2: tstringList);
    function verificaSeExisteVenda(const nota: string): boolean;
    function verificaSePodeVenderFracionado(cod: integer; unid: String;
      quant: currency): boolean;
  end;

var
  funcoes: Tfuncoes;
  cont: integer;
  refori1, CRLF: string;
  lg_StartFolder: string;
  // function calculaVlrAproxImpostos(var lista1 : TList) : currency;
function buscaChaveErroDeDuplicidade(erro: String): String;
Function testacpf(cpf: string): boolean;
function calculaVlrAproxImpostos1(nota: String): currency;
function ContaChar1(estring: string; sub: string): integer;
function ACHA_CODFORNEC(CPF_CNPJ, UF: String): String;
function ACHA_CODCLIENTE(CPF_CNPJ: String): String;
procedure informacao(posicao: integer; total: integer; informacao: string;
  novo: boolean; fechar: boolean; valorprogressao: integer);
function StrNum(const entra: string): string;
function PosFinal(substr: string; texto: string): integer;
function Contido(substring: string; texto: string): boolean;
function CompletaOuRepete(const valorParaCompletar: AnsiString;
  const ValorFinal: AnsiString; valorParaRepetir: string;
  contadorDeRepeticao: integer): string;
function Arredonda(valor: currency; decimais: integer): currency;
function WWMessage(flmessage: String; flType: TMsgDlgType;
  flbutton: TMsgDlgButtons; flColor: TColor; flBold, flItalic: boolean;
  WWFormColor: TColor): String;
function GravarConfig(valor: string; AserGravado: string;
  posi: integer): string;
function retornaPos(valor: string; sub: string; posi: integer): integer;
function lancaValorMinimo(total: currency; minimo: currency; msg: string)
  : currency;
Procedure FileCopy(Const sourcefilename, targetfilename: String);
function VerificaRegistro(param: integer; var bloq: boolean): boolean;
function HexToTColor(sColor: string): TColor;
function Reorganizar: boolean;
procedure GeraParcelamento(codvenda, formpagto, codcliente, nomecliente,
  vendedor, codgru: string; parcelas, periodo: integer; vencimento1: TDateTime;
  valorp: currency);
procedure addRelatorioForm19(Adicionar: string);
function JustificarStrings(ent: string; qtd: integer): string;
function VerificaAcesso_Se_Nao_tiver_Nenhum_bloqueio_true_senao_false: boolean;
function RetornaAcessoUsuario: integer;
function StringToInteger(ent: String): integer;
function ValidaCNPJ(cnpj: string): boolean;
function ValidaCPF(sCPF: string): boolean;
function iif(lTest: boolean; vExpr1, vExpr2: variant): variant;
function VerificaCampoTabela(nomeCampo, tabela: string): boolean;
procedure Retorna_Array_de_Numero_de_Notas(var mat: tstringList; notas: string;
  const separador: String = ' ');
FUNCTION STR_ALFA(PAR: string): string;
function RetornaValorStringList(var ent: tstringList; estring: string): string;
function Incrementa_Generator(Gen_name: string;
  valor_incremento: integer): string;
procedure EmptyTList(Var AList: Tlist);
function verificaSeTemImpressora(): boolean;
function formataDataDDMMYY(data: TDateTime): String;
function MessageText(wmessage: String; flColor: TColor;
  flBold, flItalic: boolean; WWFormColor: TColor): String;
function reStartGenerator(nome: string; valor: integer): String;
function gravaErrosNoArquivo(erro, Formulario, linha, funcao: String): String;

function maior(v1, v2: variant): variant;
FUNCTION DIGEAN(vx_cod: string): string;
function GetFileList(const path: string): tstringList;
function formataCurrency(const valor: currency): String;
procedure criaPasta(const pasta: String);
function checaCodbar(vx_cod: String): boolean;
function dialogo(tipo: string; maxlengt: integer; ValorEntrada: string;
  tamanhocampo: integer; obrigatorio1: boolean; trocaletras: string;
  titulo: string; label1: string; default: string): string;
procedure LE_CAMPOS(var mat: tstringList; LIN: String; const separador: String;
  criaMAT: boolean = true);
procedure completaStringList(var mat: tstringList; qtd: integer);

// function enviNFCe(const perg : string = '') : boolean;

const
  diasParaBloquear: integer = 14;
  site: String = 'http://controlw.zz.vc';
  site1: String = 'http://controlw.blog.br';
  site2: String = 'http://controlw.blog.br';

implementation

uses Unit1, Math, dialog, formpagtoformulario, StrUtils,
  Mensagem, relatorio, principal, Unit2, localizar,
  buscaSelecao, Menus, Unit38, imprime1, Unit42, dm1,
  subconsulta, vendas, nfe, Unit48, login, DateUtils, zlib, envicupom,
  untnfceForm,
  Unit57, cadCli, cadCli1, dadosTransp, cadproduto, gifAguarde, param,
  caixaLista, unid, Unit69, consultaOrdem, Unit73;

{$R *.dfm}

procedure Tfuncoes.descamarcaVenda(const numVenda: String);
begin
  dm.IBQuery1.Close;
  dm.IBQuery1.SQL.text := 'update venda set exportado = 0 where nota = :nota';
  dm.IBQuery1.ParamByName('nota').AsString := numVenda;
  dm.IBQuery1.ExecSQL;
  if dm.IBQuery1.Transaction.InTransaction then
    dm.IBQuery1.Transaction.Commit;
end;

function Tfuncoes.dataInglesToBrasil(const data: String): string;
begin
  // 2015-01-01
  Result := '';
  Result := copy(data, 9, 2) + '/' + copy(data, 6, 2) + '/' + copy(data, 1, 4);
end;

function Tfuncoes.BuscaBoletos(): boolean;
var
  lista, arq: tstringList;
  ini, fim: integer;
  cnpj, cnpj1, emitNome, cNF, dEMI: string;
begin
  Result := true;

  lista := listaArquivos(caminhoEXE_com_barra_no_final + '*.W');
  arq := tstringList.Create;
  form33 := tform33.Create(self);
  form33.caption := 'Consulta de Formulários';
  form33.ClientDataSet1.FieldDefs.Clear;
  form33.ClientDataSet1.FieldDefs.Add('arq', ftString, 60);
  form33.ClientDataSet1.FieldDefs.Add('ARQUIVO', ftString, 50);
  form33.ClientDataSet1.CreateDataSet;

  form33.ClientDataSet1.EmptyDataSet;
  form33.ClientDataSet1.FieldByName('arq').DisplayLabel := 'Arquivo';
  form33.ClientDataSet1.FieldByName('arq').Visible := true;
  form33.ClientDataSet1.FieldByName('ARQUIVO').Visible := False;
  form33.DataSource1.dataset := form33.ClientDataSet1;
  form33.DBGrid1.DataSource := form33.DataSource1;
  form33.campobusca := 'arq';

  fim := lista.count - 1;
  for ini := 0 to fim do
  begin
    form33.ClientDataSet1.Append;
    form33.ClientDataSet1.FieldByName('arq').AsString := lista[ini];
    form33.ClientDataSet1.Post;
  end;
  // dm.ACBrNFe.NotasFiscais.Clear;
  funcoes.retornobusca := '';
  form33.ShowModal;
  form33.ClientDataSet1.EmptyDataSet;

  form33.ClientDataSet1.Close;
  form33.Free;
  lista.Free;
end;

function Tfuncoes.buscaXMl(const path: String; novo: boolean = true): boolean;
var
  lista, arq: tstringList;
  ini, fim: integer;
  cnpj, cnpj1, emitNome, cNF, dEMI: string;
begin
  Result := true;
  lista := listaArquivos(path + '*.xml');
  arq := tstringList.Create;

  if novo then begin
    form33 := tform33.Create(self);
    form33.caption := 'Consulta de XML - F8 Download de XML';
    form33.ClientDataSet1.FieldDefs.Clear;
    form33.ClientDataSet1.FieldDefs.Add('arq', ftString, 60);
    form33.ClientDataSet1.FieldDefs.Add('ARQUIVO', ftString, 50);
    form33.ClientDataSet1.CreateDataSet;
  end;

  form33.ClientDataSet1.EmptyDataSet;
  form33.ClientDataSet1.FieldByName('arq').Visible := False;
  form33.DataSource1.dataset := form33.ClientDataSet1;
  form33.DBGrid1.DataSource := form33.DataSource1;
  form33.campobusca := 'arq';

  dm.IBselect.Close;
  dm.IBselect.SQL.text := 'select cnpj from registro';
  dm.IBselect.Open;

  cnpj := funcoes.StrNum(dm.IBselect.FieldByName('cnpj').AsString);
  dm.IBselect.Close;
  // dm.ACBrNFe.NotasFiscais.Clear;

  fim := lista.count - 1;
  for ini := 0 to fim do begin
    arq.Clear;
    arq.LoadFromFile(path + lista[ini]);
    cnpj1 := Le_Nodo('dest', arq.text);
    cnpj1 := IfThen(funcoes.Contido('CNPJ', cnpj1), Le_Nodo('CNPJ', cnpj1),
      Le_Nodo('CPF', cnpj1));
    // dm.ACBrNFe.NotasFiscais.LoadFromFile(path + lista[ini]);
    // if cnpj = cnpj1 then
    if true then begin
      cNF := Le_Nodo('nNF', arq.text);
      dEMI := Le_Nodo('dEmi', arq.text);
      emitNome := Le_Nodo('emit', arq.text);
      emitNome := Le_Nodo('xNome', emitNome);
      form33.ClientDataSet1.Insert;
      form33.ClientDataSet1.FieldByName('arq').AsString := lista[ini];
      form33.ClientDataSet1.FieldByName('arquivo').AsString := cNF + ' ' + dEMI
        + ' ' + emitNome;
      form33.ClientDataSet1.Post;
    end;
    // dm.ACBrNFe.NotasFiscais.Clear;
  end;
  funcoes.retornobusca := '';
  if novo then
  begin
    form33.ShowModal;
    form33.ClientDataSet1.EmptyDataSet;

    form33.ClientDataSet1.Close;
    form33.Free;
  end;
  lista.Free;
end;

procedure criaPasta(const pasta: String);
begin
  if not DirectoryExists(pasta) then
    forceDirectories(pasta);
end;

function Tfuncoes.verificaSeExisteVenda(const nota: string): boolean;
begin
  Result := False;
  dm.IBselect.Close;
  dm.IBselect.SQL.text :=
    'select nota from venda where (nota = :nota) and (cancelado = 0)';
  dm.IBselect.ParamByName('nota').AsString := nota;
  dm.IBselect.Open;

  if dm.IBselect.IsEmpty then
  begin
    dm.IBselect.Close;
    ShowMessage('Venda Nº ' + nota + ' Não Encontrada');
    exit;
  end
  else
    Result := true;
  dm.IBselect.Close;
end;

procedure Tfuncoes.transformaStringList(var li1, li2: tstringList);
var
  ini, fim: integer;
begin
  li2 := tstringList.Create;
  fim := li1.count - 1;
  for ini := 0 to fim do
  begin
    li2.Values[IntToStr(ini)] := li1[ini];
  end;
end;

function Tfuncoes.cancelamentoDeNota(const nota: String;
  TROCA: boolean = False): String;
var
  campo, sim, nota1: string;
  data: TDateTime;
  total, entrada: currency;
  enc: boolean;
  origem : integer;
begin
  enc := true;
  nota1 := '0';
  if nota = '' then
  begin
    // nota1 := IntToStr(StrToIntDef(Incrementa_Generator('venda', 0), 1));
    if funcoes.buscaParamGeral(51, 'N') = 'S' then
      nota1 := funcoes.buscaUltimaVendaOrcamentoDoUsuario
        (StrToInt(StrNum(form22.Pgerais.Values['codvendedor'])), 1)
    else
      nota1 := IntToStr(StrToIntDef(Incrementa_Generator('venda', 0), 1));

    nota1 := funcoes.dialogo('generico', 0, '1234567890' + #8, 100, False, '',
      Application.Title, 'Informe o Número Da Nota:', nota1);

    if (nota1 = '*') or (nota1 = '') then
      exit;
  end
  else
    nota1 := nota;

  Result := nota1;

  dm.IBQuery2.Close;
  dm.IBQuery2.SQL.Clear;
  dm.IBQuery2.SQL.Add
    ('select * from venda where (nota = :nota) and (cancelado = 0)');
  dm.IBQuery2.ParamByName('nota').AsString := nota1;
  dm.IBQuery2.Open;

  if dm.IBQuery2.IsEmpty then
  begin
    enc := False;
    dm.IBQuery2.Close;
    // Result := 'CANC';
    // ShowMessage('Nota Não Encontrada!');
    // nota := '*';
    // exit;
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
    sim := funcoes.dialogo('generico', 0, 'SN' + #8, 30, true, 'S',
      Application.Title, 'Deseja Cancelar o Parcelamento da Nota ' + nota1 +
      ' ? Sim ou Não (S/N)?', '');
    if sim = '*' then
      exit;
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
        on e: exception do
        begin
          ShowMessage('Ocorreu um Erro: ' + e.Message + #13 + #10 +
            'Tente Novamente');
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
    if TROCA = False then
      ShowMessage('Nota Não Encontrada!');
    exit;
  end;

  dm.IBQuery1.Close;
  sim := '';
  while sim = '' do
    sim := funcoes.dialogo('generico', 0, 'SN' + #8, 30, False, 'S',
      Application.Title, 'Confirma Cancelamento da Nota ' + nota1 +
      ' ? Sim ou Não (S/N)?', '');
  if (sim = 'N') or (sim = '') or (sim = '*') then
  begin
    dm.IBQuery2.Close;
    exit;
  end;

  if FormatDateTime('dd/mm/yy', dm.IBQuery2.FieldByName('data').AsDateTime) <>
    FormatDateTime('dd/mm/yy', form22.dataMov) then
  begin
    sim := '';
    while sim = '' do
      sim := funcoes.dialogo('generico', 0, 'SN' + #8, 30, False, 'S',
        Application.Title, 'Atenção, a Nota ' + nota1 + ' é do dia ' +
        FormatDateTime('dd/mm/yy', dm.IBQuery2.FieldByName('data').AsDateTime) +
        ', Cancelar Mesmo Assim ? Sim ou Não (S/N)?', '');
    if (sim = 'N') or (sim = '') then
    begin
      dm.IBQuery2.Close;
      exit;
    end;
  end;

  // dm.IBQuery1.Transaction.StartTransaction;


  total := dm.IBQuery2.FieldByName('total').AsCurrency;
  entrada := dm.IBQuery2.FieldByName('entrada').AsCurrency;

  if ((dm.IBQuery2.FieldByName('codhis').AsString = '1') or (entrada > 0)) then
  begin
    dm.IBQuery1.Close;
    dm.IBQuery1.SQL.Clear;
    dm.IBQuery1.SQL.Add
      ('update caixa set entrada = entrada - :ent where (historico like ' +
      QuotedStr('%VENDAS DO DIA%') + ') and (cast(data as date) = :d) ');
    if entrada > 0 then
      total := entrada;
    dm.IBQuery1.ParamByName('ent').AsCurrency := total;
    dm.IBQuery1.ParamByName('d').AsDateTime := dm.IBQuery2.FieldByName('data')
      .AsDateTime;
    dm.IBQuery1.ExecSQL;
  end;

  if (entrada > 0) and (dm.IBQuery2.FieldByName('codhis').AsString <> '1') then
  begin
    dm.IBQuery1.Close;
    dm.IBQuery1.SQL.text := 'delete from caixa where historico like :nome';
    dm.IBQuery1.ParamByName('nome').AsString := nota1 + '-%';
    dm.IBQuery1.ExecSQL;
  end;

  dm.IBQuery1.Close;
  dm.IBQuery1.SQL.Clear;
  dm.IBQuery1.SQL.Add('update venda set cancelado = :canc where nota = :nota');
  dm.IBQuery1.ParamByName('canc').AsString := form22.codusario;
  dm.IBQuery1.ParamByName('nota').AsString := nota1;
  dm.IBQuery1.ExecSQL;

  dm.IBQuery1.Close;
  dm.IBQuery1.SQL.Clear;
  dm.IBQuery1.SQL.Add
    ('update item_venda set cancelado = :canc where nota = :nota');
  dm.IBQuery1.ParamByName('canc').AsString := LeftStr(form22.codusario, 2);
  dm.IBQuery1.ParamByName('nota').AsString := nota1;
  dm.IBQuery1.ExecSQL;

  dm.IBQuery2.Close;
  dm.IBQuery2.SQL.Clear;
  dm.IBQuery2.SQL.Add('select * from item_venda where nota = :nota');
  dm.IBQuery2.ParamByName('nota').AsString := nota1;
  dm.IBQuery2.Open;
  dm.IBQuery2.First;

  while not dm.IBQuery2.Eof do begin
    dm.IBQuery1.Close;
    dm.IBQuery1.SQL.Clear;
    if Contido(dm.IBQuery2.FieldByName('origem').AsString, '01') then
      campo := 'quant'
    else
      campo := 'deposito';

    origem := StrToIntDef(StrNum(dm.IBQuery2.FieldByName('origem').AsString), 1);
    if origem <= 0 then origem := 1;

    funcoes.baixaEstoqueSP(dm.IBQuery2.FieldByName('cod').AsString, dm.IBQuery2.FieldByName('quant').AsCurrency, origem);

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
    ShowMessage('Os Itens da Nota ' + nota1 +
      ' Foram Devolvidos Para o Estoque.');
  except
    dm.IBQuery1.Transaction.Rollback;
    WWMessage('A Venda Não Pode Ser Cancelada. Tente Novamente!', mtError,
      [mbok], clYellow, true, False, clRed);
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

  funcoes.gravaAlteracao('Cancelamento De Venda: ' + nota1, 'CAN');
end;

procedure Tfuncoes.atualizaVendaDaOrdemDeServico(const cos_os,
  numVenda: string);
begin
  dm.IBQuery1.Close;
  dm.IBQuery1.SQL.text := 'update servico set venda = :venda where cod = :cod';
  dm.IBQuery1.ParamByName('venda').AsString := numVenda;
  dm.IBQuery1.ParamByName('cod').AsString := cos_os;
  dm.IBQuery1.ExecSQL;

  dm.IBQuery1.Transaction.Commit;
end;

function Tfuncoes.lerValorPipePrimeiro1(const valor: String;
  const num: integer): String;
var
  ini, fim: integer;
begin
  ini := lerPosString(valor, '|', num) + 1;
  fim := lerPosString(valor, '|', num + 1);
  fim := fim - ini;
  Result := copy(valor, ini, fim);
end;

function Tfuncoes.lerPosString(const valor: String; const sub: String;
  const posi: integer): integer;
var
  ini, fim, cont: integer;
begin
  fim := length(valor);
  cont := 0;
  for ini := 1 to fim do
  begin
    if sub = valor[ini] then
      cont := cont + 1;
    if cont = posi then
      break;
  end;
  Result := ini;
end;

procedure Tfuncoes.LeNomesServicos();
begin
  form22.nomesServico := tstringList.Create;
  form22.nomesServico.Values['1'] := funcoes.lerValorPipePrimeiro1
    (ConfParamGerais[35], 1);
  form22.nomesServico.Values['2'] := funcoes.lerValorPipePrimeiro1
    (ConfParamGerais[35], 2);
  form22.nomesServico.Values['3'] := funcoes.lerValorPipePrimeiro1
    (ConfParamGerais[35], 3);
  form22.nomesServico.Values['4'] := funcoes.lerValorPipePrimeiro1
    (ConfParamGerais[35], 4);
  form22.nomesServico.Values['5'] := funcoes.lerValorPipePrimeiro1
    (ConfParamGerais[35], 5);
  form22.nomesServico.Values['6'] := funcoes.lerValorPipePrimeiro1
    (ConfParamGerais[35], 6);
end;

function Tfuncoes.lerServicoNoBdEcriaUmObjetoOrdem(const cod: String;
  var ordem: TOrdem): boolean;
begin
  Result := False;
  dm.IBselect.Close;
  dm.IBselect.SQL.text :=
    'select venda, h_sai, cod, saida, cliente, data, equip, marca, modelo, defeito, obs, serie, tecnico, usuario, h_ent from servico where cod = :cod';
  dm.IBselect.ParamByName('cod').AsString := cod;
  dm.IBselect.Open;

  if dm.IBselect.IsEmpty then
  begin
    dm.IBselect.Close;
    ShowMessage('Nota ' + cod + ' Não Encontrada');
    exit;
  end;

  ordem := TOrdem.Create;
  ordem.cod := dm.IBselect.FieldByName('cod').AsInteger;
  ordem.saida := dm.IBselect.FieldByName('saida').AsDateTime;
  ordem.Cliente := dm.IBselect.FieldByName('cliente').AsInteger;
  ordem.data := dm.IBselect.FieldByName('data').AsDateTime;
  ordem.equipe := trim(dm.IBselect.FieldByName('equip').AsString);
  ordem.marca := trim(dm.IBselect.FieldByName('marca').AsString);
  ordem.modelo := trim(dm.IBselect.FieldByName('modelo').AsString);
  ordem.defeito := trim(dm.IBselect.FieldByName('defeito').AsString);
  ordem.obs := trim(dm.IBselect.FieldByName('obs').AsString);
  ordem.serie := trim(dm.IBselect.FieldByName('serie').AsString);
  ordem.tecnico := trim(dm.IBselect.FieldByName('tecnico').AsString);
  ordem.USUARIO := dm.IBselect.FieldByName('usuario').AsInteger;
  ordem.venda := IfThen(dm.IBselect.FieldByName('venda').AsString = '', 0,
    dm.IBselect.FieldByName('venda').AsInteger);
  ordem._ent := FormatDateTime('hh:mm', dm.IBselect.FieldByName('h_ent')
    .AsDateTime);
  ordem.h_saida := FormatDateTime('hh:mm', dm.IBselect.FieldByName('h_sai')
    .AsDateTime);
  dm.IBselect.Close;
  Result := true;
end;

function Tfuncoes.abreVendaSeparaPecasOrdemDeServico(const finaliza,
  orcamento: boolean): boolean;
begin
  Result := true;
  form20 := tform20.Create(self);
  form20.tipoV := 'P';
  form20.Saiu := False;
  form20.finaliza := finaliza;

  if finaliza then
  begin
    form20.tipoVenda := 'SF';
  end;

  if not finaliza then
    form20.JsEditInteiro1.text := form55.DBGrid1.DataSource.dataset.FieldByName('cod').AsString;
  form20.separaVendaOrcamento := orcamento;
  if orcamento then
  begin
    form20.Modo_Orcamento := true;
    form20.Modo_Venda := False;
    form20.finaliza := true;
  end
  else
    form20.Modo_Venda := true;
  form20.COD_SERVICO := form55.DBGrid1.DataSource.dataset.FieldByName
    ('cod').AsString;
  form20.JsEdit3.text := form55.DBGrid1.DataSource.dataset.FieldByName
    ('cliente1').AsString;
  form20.JsEdit2.text := form22.Pgerais.Values['codvendedor'];
  // form20.JsEdit2.Text := dm.TabelaOrdemVENDEDOR.AsString;
  form20.separaPecas := true;
  // form20.Modo_Venda  := true;
  funcoes.CtrlResize(TForm(form20));

  form20.LabelVenda.caption := form55.DBGrid1.DataSource.dataset.FieldByName
    ('cliente1').AsString + ' - ' + form55.DBGrid1.DataSource.dataset.
    FieldByName('cliente').AsString;

  form20.ShowModal;
  if form20.Saiu then
    Result := False;
  form20.Free;
end;

Function Tfuncoes.RelSomatoria_T_(var lista1: Tlist; dini, dfim: String;
  geral: currency): AnsiString;
var
  t1: currency;
  prod, prod1: Ptr_Produto;
begin
  t1 := 0;
  Result := '';
  Result := 'PERIODO: ' + FormatDateTime('dd/mm/yy', StrToDateTime(dini)) +
    ' A ' + FormatDateTime('dd/mm/yy', StrToDateTime(dfim)) +
    '     Quant.       Preco ' + '                           ' + #13 + #10;
  Result := Result + funcoes.CompletaOuRepete('', '', '-', 56) + #13 + #10;
  prod := lista1.Items[0]; // VENDA PROD
  prod1 := lista1.Items[1]; // COMPRA PROD1
  Result := Result + 'TOTAL A PRECO DE COMPRA..:' + funcoes.CompletaOuRepete('',
    FormatCurr('#,###,###0.00', prod1.tot3), ' ', 13) + funcoes.CompletaOuRepete
    ('', FormatCurr('#,###,###0.00', Arredonda(prod1.tot2 * prod1.tot3, 2)),
    ' ', 13) + #13 + #10;
  Result := Result + 'TOTAL A PRECO DE VENDA...:' + funcoes.CompletaOuRepete('',
    FormatCurr('#,###,###0.00', prod.tot3), ' ', 13) + funcoes.CompletaOuRepete
    ('', FormatCurr('#,###,###0.00', Arredonda(prod.tot2 * prod.tot3, 2)), ' ',
    13) + #13 + #10;
  t1 := Arredonda(prod1.tot2 * prod1.tot3, 2) -
    Arredonda(prod.tot2 * prod.tot3, 2);
  Result := Result + 'LUCRO BRUTO S/VENDA......: ------------' +
    funcoes.CompletaOuRepete('', FormatCurr('#,###,###0.00', t1), ' ', 13) +
    #13 + #10;
  Result := Result + 'PRECO MEDIO DE COMPRA....: ------------' +
    funcoes.CompletaOuRepete('', FormatCurr('#,###,###0.00', prod1.tot2), ' ',
    13) + #13 + #10;
  Result := Result + 'PRECO MEDIO DE VENDA.....: ------------' +
    funcoes.CompletaOuRepete('', FormatCurr('#,###,###0.00', prod.tot2), ' ',
    13) + #13 + #10;
  Result := Result + 'ESTOQUE A PRECO DE COMPRA:' + funcoes.CompletaOuRepete('',
    FormatCurr('#,###,###0.00', prod.tot1), ' ', 13) + funcoes.CompletaOuRepete
    ('', FormatCurr('#,###,###0.00', Arredonda(prod.tot1 * prod.qtd_atual, 2)),
    ' ', 13) + #13 + #10;
  Result := Result + 'ESTOQUE A PRECO MEDIO....:' + funcoes.CompletaOuRepete('',
    FormatCurr('#,###,###0.00', prod1.tot2), ' ', 13) + funcoes.CompletaOuRepete
    ('', FormatCurr('#,###,###0.00', Arredonda(prod1.tot2 * prod.qtd_atual, 2)),
    ' ', 13) + #13 + #10;
  Result := Result + funcoes.CompletaOuRepete('', '', '-', 56) + #13 + #10;
  Dispose(prod);
  Dispose(prod1);
end;

procedure Tfuncoes.fichaDoProduto(sende1: TObject; var te: String;
  const centroTipoLOJADEPOSITO: boolean);
var
  cod1, dini, dfim, DEST, origem, Codigo, desti, orig: string;
  fat, destino: integer;
  datini, ini, fim, ret: TDateTime;
  tot, geral, saldoAnteriorLoja, saldoAnteriorDeposito: currency;
  prod: Ptr_Produto;
  lista: Tlist;
  lab: TLabel;
  entrada, venda, acerto, transf: currency;
  // lis : TStringList;
begin
  if te = '' then
  begin
    cod1 := funcoes.dialogo('generico', 0, '1234567890,.' + #8, 50, False, '',
      Application.Title, 'Qual o Cód do Produto?', '');
    if (cod1 = '*') or (cod1 = '') then
      exit;

    te := cod1;
  end;

  entrada := 0;
  venda := 0;

  ini := form22.dataMov - 180;
  fim := form22.dataMov;

  dini := funcoes.dialogo('data', 0, '', 2, true, '', Application.Title,
    'Qual a Data Inicial de Movimento?', formataDataDDMMYY(ini));
  if dini = '*' then
    exit;

  dfim := funcoes.dialogo('data', 0, '', 2, true, '', Application.Title,
    'Qual a Data Final de Movimento?', formataDataDDMMYY(fim));
  if dfim = '*' then
    exit;

  cod1 := funcoes.dialogo('generico', 0, '123' + #8, 50, False, 'S',
    Application.Title,
    'Qual o Critério de Seleção da Mercadoria (1-Loja 2-Deposito 3-Loja + Deposito)?',
    '');
  if cod1 = '*' then
    exit;

  if cod1 = '' then
  begin
    cod1 := '*';
    form39 := tform39.Create(self);
    form39.ListBox1.Items.Add('3- LOJA + DEPOSITO');
    form39.ListBox1.Items.Add('1- LOJA');
    form39.ListBox1.Items.Add('2- DEPOSITO');
    form39.Position := poScreenCenter;
    cod1 := funcoes.lista(sende1, centroTipoLOJADEPOSITO);
    if cod1 = '*' then
      exit;

  end;

  cod1 := trim(cod1);
  form33 := tform33.Create(self);

  form33.caption := 'Ficha do Produto: ' + te + '-' +
    funcoes.BuscaNomeBD(dm.IBQuery2, 'nome', 'produto', 'where cod = ' + te);

  form33.ClientDataSet1.FieldDefs.Add('DATA', ftDate);
  form33.ClientDataSet1.FieldDefs.Add('HISTORICO', ftString, 40);
  form33.ClientDataSet1.FieldDefs.Add('PRECO', ftCurrency);
  form33.ClientDataSet1.FieldDefs.Add('QUANT', ftCurrency);
  form33.ClientDataSet1.FieldDefs.Add('SALDO', ftCurrency);
  form33.ClientDataSet1.FieldDefs.Add('cont', ftInteger);

  form33.DataSource1.dataset := form33.ClientDataSet1;
  form33.DBGrid1.DataSource  := form33.DataSource1;

  form33.ClientDataSet1.CreateDataSet;
  form33.ClientDataSet1.LogChanges := False;

  TCurrencyField(form33.ClientDataSet1.FieldByName('preco')).currency := False;
  TCurrencyField(form33.ClientDataSet1.FieldByName('quant')).currency := False;
  TCurrencyField(form33.ClientDataSet1.FieldByName('saldo')).currency := False;

  with form33.ClientDataSet1.IndexDefs.AddIndexDef do
  begin
    Fields := 'cont';
    Name := 'indice';
  end;

  // form33.ClientDataSet1.IndexName := 'indice';
  tot   := 0;
  geral := 0;
  saldoAnteriorLoja := 0;
  saldoAnteriorDeposito := 0;
  datini := StrToDateTime(dini);

  dm.IBselect.Close;
  dm.IBselect.SQL.Clear;
  dm.IBselect.SQL.Add('select sad, sal from produto where cod = :cod');
  dm.IBselect.ParamByName('cod').AsString := te;
  dm.IBselect.Open;
  saldoAnteriorLoja     := dm.IBselect.FieldByName('sal').AsCurrency;
  saldoAnteriorDeposito := dm.IBselect.FieldByName('sad').AsCurrency;

  if cod1 = '3' then
  begin
    cod1 := '0-1-2';
    geral := geral + saldoAnteriorLoja;
    geral := geral + saldoAnteriorDeposito;
  end
  else if cod1 = '1' then
  begin
    geral := geral + saldoAnteriorLoja;
    cod1 := '0-1';
  end
  else if cod1 = '2' then
    geral := geral + saldoAnteriorDeposito;

  origem := QuotedStr(cod1); // origem loja + depósito - valor padrão

  form33.ClientDataSet1.Open;
  form33.ClientDataSet1.Edit;
  form33.ClientDataSet1.Insert;
  form33.ClientDataSet1.FieldByName('data').AsDateTime := datini - 1;
  form33.ClientDataSet1.FieldByName('historico').AsString := 'SALDO ANTERIOR';
  form33.ClientDataSet1.FieldByName('preco').AsCurrency := 0;
  form33.ClientDataSet1.FieldByName('quant').AsCurrency := 0;
  form33.ClientDataSet1.FieldByName('cont').AsInteger :=
    form33.ClientDataSet1.RecordCount + 1;
  form33.ClientDataSet1.FieldByName('saldo').AsCurrency := 0;
  form33.ClientDataSet1.Post;

  // ENTRADAS
  // soma os lançamentos anteriores à data inicial no saldo anterior
  prod := new(Ptr_Produto);
  prod.tot1 := 0;
  prod.tot2 := 0;
  prod.tot3 := 0;

  {dm.IBselect.Close;
  dm.IBselect.SQL.Clear;
  dm.IBselect.SQL.Add
  // ('select cod, p_compra, destino, quant, nota, data, unid from item_entrada where (data < :ini) and (cod = '
  // + te + ') and ' + origem + ' containing cast(destino as varchar(1))');

    ('select i.cod, i.p_compra, i.destino, i.quant, i.nota, i.data, i.unid from item_entrada i, entrada e where ((i.nota = e.nota) and (i.fornec = e.fornec)) and (e.chegada < :ini) and (i.cod ='
    + te + ') and ' + origem + ' containing cast(destino as varchar(1))');
  dm.IBselect.ParamByName('ini').AsDateTime := datini;
  dm.IBselect.Open;

  while not dm.IBselect.Eof do
  begin
    geral := geral + (dm.IBselect.FieldByName('quant').AsCurrency);

    prod.tot2 := prod.tot2 +
      Arredonda((dm.IBselect.FieldByName('quant').AsCurrency *
      dm.IBselect.FieldByName('p_compra').AsCurrency), 2);
    prod.tot3 := prod.tot3 + (dm.IBselect.FieldByName('quant').AsCurrency *
      funcoes.verValorUnidade(dm.IBselect.FieldByName('UNID').AsString));

    destino := dm.IBselect.FieldByName('destino').AsInteger;
    if destino = 0 then
      destino := 1;

    if destino = 1 then begin // loja
      saldoAnteriorLoja := saldoAnteriorLoja +
        (dm.IBselect.FieldByName('quant').AsCurrency * funcoes.verValorUnidade
        (dm.IBselect.FieldByName('UNID').AsString));
    end
    else begin
      saldoAnteriorDeposito := saldoAnteriorDeposito +
        (dm.IBselect.FieldByName('quant').AsCurrency * funcoes.verValorUnidade
        (dm.IBselect.FieldByName('UNID').AsString));
    end;

    dm.IBselect.Next;
  end;

  // VENDAS
  // soma os lançamentos anteriores à data inicial no saldo anterior

  dm.IBselect.Close;
  dm.IBselect.SQL.Clear;
  dm.IBselect.SQL.Add
    ('SELECT SUM(QUANT) AS saldoanterior from item_venda where (data < :ini) and '
    + '(cod = ' + te + ') and (cancelado = 0) and ' + origem +
    ' containing cast(origem as varchar(1))');
  dm.IBselect.ParamByName('ini').AsDateTime := datini;
  dm.IBselect.Open;

  saldoAnteriorLoja := saldoAnteriorLoja - dm.IBselect.FieldByName
    ('saldoanterior').AsCurrency;}


  dm.IBselect.Close;
  dm.IBselect.SQL.Clear;
  dm.IBselect.SQL.Text := 'select o.vendedor,o.p_venda,o.nota,o.cod, o.quant, s.venda, s.data as data1, o.data as data2 from os_itens o left join servico s on (s.COD = o.nota) where o.cod  = :cod and ((s.venda is null) or (S.VENDA = 0))';
  dm.IBselect.ParamByName('cod').AsString := strnum(te);
  dm.IBselect.Open;

  while not dm.IBselect.Eof  do begin
    geral := geral + ( -dm.IBselect.FieldByName('quant').AsCurrency);
    if dm.IBselect.FieldByName('data1').IsNull = false then ret := dm.IBselect.FieldByName('data1').AsDateTime;
    if dm.IBselect.FieldByName('data2').IsNull = false then ret := dm.IBselect.FieldByName('data2').AsDateTime;

    form33.ClientDataSet1.Open;
    form33.ClientDataSet1.Append;
    form33.ClientDataSet1.FieldByName('data').AsDateTime := ret;
    form33.ClientDataSet1.FieldByName('historico').AsString := 'SERVIÇO NOTA ' + dm.IBselect.FieldByName('nota').AsString + ' VEND: ' + dm.IBselect.FieldByName('VENDEDOR').AsString;
    form33.ClientDataSet1.FieldByName('preco').AsCurrency :=
    dm.IBselect.FieldByName('p_venda').AsCurrency;
    form33.ClientDataSet1.FieldByName('quant').AsCurrency := -dm.IBselect.FieldByName('quant').AsCurrency;
    form33.ClientDataSet1.FieldByName('saldo').AsCurrency := geral;
      form33.ClientDataSet1.FieldByName('cont').AsInteger :=
      form33.ClientDataSet1.RecordCount + 1;
      form33.ClientDataSet1.Post;
    dm.IBselect.Next;
  end;




  // pega os lançamentos a partir da data inicial
  dm.IBselect.Close;
  dm.IBselect.SQL.Clear;
  dm.IBselect.SQL.Add
    //('select i.cod, i.p_compra, i.destino, i.quant, i.nota, i.data, i.unid, e.chegada from item_entrada i, entrada e where ((i.nota = e.nota) and (i.fornec = e.fornec)) and (e.chegada >= :ini) and (i.cod ='
    ('select nota, fornec,i.cod, i.p_compra, i.destino, i.quant, i.nota, i.data,'+
    ' i.unid, (select chegada from entrada e where ((i.nota = e.nota) and (i.fornec = e.fornec))) as chegada from item_entrada i where (i.cod ='
    + te + ') and ' + origem + ' containing cast(destino as varchar(1))');
  //dm.IBselect.ParamByName('ini').AsDateTime := datini;
  dm.IBselect.Open;


  entrada := 0;

  while not dm.IBselect.Eof do begin
    geral := geral + (dm.IBselect.FieldByName('quant').AsCurrency);

    prod.tot2 := prod.tot2 +
      Arredonda((dm.IBselect.FieldByName('quant').AsCurrency *
      dm.IBselect.FieldByName('p_compra').AsCurrency), 2);
    prod.tot3 := prod.tot3 + (dm.IBselect.FieldByName('quant').AsCurrency *
      funcoes.verValorUnidade(dm.IBselect.FieldByName('UNID').AsString));

    destino := dm.IBselect.FieldByName('destino').AsInteger;
    if destino = 0 then destino := 1;

    ret := dm.IBselect.FieldByName('chegada').AsDateTime;
    if dm.IBselect.FieldByName('chegada').IsNull then begin
      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Text := 'select chegada from entrada where nota = :nota and fornec = :fornec';
      dm.IBQuery1.ParamByName('nota').AsInteger := dm.IBselect.FieldByName('nota').AsInteger;
      dm.IBQuery1.ParamByName('fornec').AsInteger := dm.IBselect.FieldByName('fornec').AsInteger;
      dm.IBQuery1.Open;

      ret := dm.IBselect.FieldByName('chegada').AsDateTime;
      dm.IBQuery1.Close;
    end;


    if ret < datini then begin //saldo anterior
      if destino = 1 then begin // loja
        saldoAnteriorLoja := saldoAnteriorLoja +
        (dm.IBselect.FieldByName('quant').AsCurrency * funcoes.verValorUnidade
        (dm.IBselect.FieldByName('UNID').AsString));
      end
      else begin
        saldoAnteriorDeposito := saldoAnteriorDeposito +
        (dm.IBselect.FieldByName('quant').AsCurrency * funcoes.verValorUnidade
        (dm.IBselect.FieldByName('UNID').AsString));
      end;
    end
    else begin
      form33.ClientDataSet1.Open;
      form33.ClientDataSet1.Edit;
      form33.ClientDataSet1.Insert;
      form33.ClientDataSet1.FieldByName('data').AsDateTime := ret;
      form33.ClientDataSet1.FieldByName('historico').AsString := 'ENTRADA NOTA ' +
      dm.IBselect.FieldByName('nota').AsString + iif(destino = 1, ' LOJA',
      ' DEPOSITO');
      form33.ClientDataSet1.FieldByName('preco').AsCurrency :=
      dm.IBselect.FieldByName('p_compra').AsCurrency;
      form33.ClientDataSet1.FieldByName('quant').AsCurrency :=
      (dm.IBselect.FieldByName('quant').AsCurrency * funcoes.verValorUnidade
      (dm.IBselect.FieldByName('UNID').AsString));
      form33.ClientDataSet1.FieldByName('saldo').AsCurrency := geral;
      form33.ClientDataSet1.FieldByName('cont').AsInteger :=
      form33.ClientDataSet1.RecordCount + 1;
      form33.ClientDataSet1.Post;
    end;

    dm.IBselect.Next;
  end;

  entrada := prod.tot3;

  dm.IBselect.Close;

  if prod.tot2 > 0 then
    prod.tot2 := Arredonda(prod.tot2 / prod.tot3, 2);

  lista := Tlist.Create;
  lista.Add(prod);

  // pega os lançamentos a partir da data inicial
  dm.IBselect.Close;
  dm.IBselect.SQL.Clear;
  dm.IBselect.SQL.Add
    ('select i.data,i.p_venda,i.quant,i.total,i.nota, i.origem, (select nome from formpagto where cod=v.codhis) '
    + 'from item_venda i,venda v where (v.cancelado = 0) and(i.nota=v.nota) and (i.cod = '
    + te + ') and ' + origem +' containing cast(i.origem as varchar(1)) order by data, nota');
  //dm.IBselect.ParamByName('ini').AsDateTime := datini;
  dm.IBselect.Open;
  prod := new(Ptr_Produto);
  prod.qtd_atual := 0;
  prod.tot1 := 0;
  prod.tot2 := 0;
  prod.tot3 := 0;

  venda := 0;

  while not dm.IBselect.Eof do
  begin
    geral := geral + (-dm.IBselect.FieldByName('quant').AsCurrency);

    prod.nome := 'TOTAL PRECO DE VENDA: ';
    prod.tot2 := prod.tot2 +
      Arredonda((dm.IBselect.FieldByName('quant').AsCurrency *
      dm.IBselect.FieldByName('p_venda').AsCurrency), 2);
    prod.tot3 := prod.tot3 + dm.IBselect.FieldByName('quant').AsCurrency;

    orig := dm.IBselect.FieldByName('origem').AsString;
    if StrNum(orig) = '0' then orig := '1';

    if dm.IBselect.FieldByName('data').AsDateTime < datini then begin //saldo anterior
      if origem = '1' then begin
        saldoAnteriorLoja     := saldoAnteriorLoja - dm.IBselect.FieldByName('quant').AsCurrency;
      end
      else begin
        saldoAnteriorDeposito := saldoAnteriorDeposito - dm.IBselect.FieldByName('quant').AsCurrency;
      end;
    end
    else begin
      form33.ClientDataSet1.Open;
      form33.ClientDataSet1.Edit;
      form33.ClientDataSet1.Insert;
      form33.ClientDataSet1.FieldByName('data').AsDateTime :=
      dm.IBselect.FieldByName('data').AsDateTime;
      form33.ClientDataSet1.FieldByName('historico').AsString := 'VENDA NOTA ' +
      dm.IBselect.FieldByName('nota').AsString + ' ' + dm.IBselect.FieldByName
      ('nome').AsString + iif(dm.IBselect.FieldByName('origem').AsInteger = 1,
      ' LOJA', ' DEPOSITO');
      form33.ClientDataSet1.FieldByName('preco').AsCurrency :=
      dm.IBselect.FieldByName('p_venda').AsCurrency;
      form33.ClientDataSet1.FieldByName('quant').AsCurrency :=
      -dm.IBselect.FieldByName('quant').AsCurrency;
      form33.ClientDataSet1.FieldByName('saldo').AsCurrency := geral;
      form33.ClientDataSet1.FieldByName('cont').AsInteger :=
      form33.ClientDataSet1.RecordCount + 1;
      form33.ClientDataSet1.Post;
    end;

    dm.IBselect.Next;
  end;

  venda := -prod.tot3;

  if prod.tot2 > 0 then
    prod.tot2 := Arredonda(prod.tot2 / prod.tot3, 2);

  dm.IBselect.Close;
  dm.IBselect.SQL.Clear;
  dm.IBselect.SQL.Add
    ('select p_compra, quant, deposito from produto where cod = ' + te);
  dm.IBselect.Open;

  prod.tot1 := dm.IBselect.FieldByName('p_compra').AsCurrency;
  prod.qtd_atual := dm.IBselect.FieldByName('quant').AsCurrency +
    dm.IBselect.FieldByName('deposito').AsCurrency;
  lista.Add(prod);

  dm.IBselect.Close;

  // TRANSFERÊNCIAS
  // soma os lançamentos anteriores à data inicial no saldo anterior
  // primeiro as transferências para LOJA
  dm.IBselect.Close;
  dm.IBselect.SQL.Clear;
  dm.IBselect.SQL.Add
    ('SELECT SUM(QUANT) AS saldoanterior from transferencia where (data < :ini) and'
    + ' (destino = 1) and (cod = ' + te + ')');
  dm.IBselect.ParamByName('ini').AsDateTime := datini;
  dm.IBselect.Open;
  if pos('1', origem) > 0 then
  begin
    saldoAnteriorLoja := saldoAnteriorLoja + dm.IBselect.FieldByName
      ('saldoanterior').AsCurrency;
    saldoAnteriorDeposito := saldoAnteriorDeposito - dm.IBselect.FieldByName
      ('saldoanterior').AsCurrency;
  end;

  // agora as transferências para DEPOSITO
  dm.IBselect.Close;
  dm.IBselect.SQL.Clear;
  dm.IBselect.SQL.Add
    ('SELECT SUM(QUANT) AS saldoanterior from transferencia where (data < :ini) and'
    + ' (destino = 2) and (cod = ' + te + ')');
  dm.IBselect.ParamByName('ini').AsDateTime := datini;
  dm.IBselect.Open;
  if pos('2', origem) > 0 then
  begin
    saldoAnteriorLoja := saldoAnteriorLoja - dm.IBselect.FieldByName
      ('saldoanterior').AsCurrency;
    saldoAnteriorDeposito := saldoAnteriorDeposito + dm.IBselect.FieldByName
      ('saldoanterior').AsCurrency;
  end;

  dm.IBselect.Close;
  dm.IBselect.SQL.Clear;
  dm.IBselect.SQL.Add
    ('select cod, data, destino, quant, documento from transferencia where (data >= :ini) and (cod = '
    + te + ')');
  dm.IBselect.ParamByName('ini').AsDateTime := datini;
  dm.IBselect.Open;

  transf := 0;
  while not dm.IBselect.Eof do
  begin
    // cod1 é a origem da mercadoria(1-loja, 2-depósito)
    desti := '1';
    if (dm.IBselect.FieldByName('destino').AsString = '1') then
      desti := '2';

    // se é pra mostrar o movimento de origem
    if Contido('1', origem) then
    begin
      DEST := ' PARA DEPOSITO';
      fat := -1;

      if dm.IBselect.FieldByName('destino').AsString = '1' then
      begin
        DEST := ' PARA LOJA';
        fat := 1;
      end;

      form33.ClientDataSet1.Insert;
      form33.ClientDataSet1.FieldByName('data').AsDateTime :=
        dm.IBselect.FieldByName('data').AsDateTime;
      form33.ClientDataSet1.FieldByName('historico').AsString :=
        'TRANSFERENCIA ' + dm.IBselect.FieldByName('documento').AsString + DEST;
      form33.ClientDataSet1.FieldByName('preco').AsCurrency := 0;
      form33.ClientDataSet1.FieldByName('quant').AsCurrency :=
        fat * dm.IBselect.FieldByName('quant').AsCurrency;
      form33.ClientDataSet1.FieldByName('saldo').AsCurrency := geral;
      form33.ClientDataSet1.FieldByName('cont').AsInteger :=
        form33.ClientDataSet1.RecordCount + 1;
      form33.ClientDataSet1.Post;

    end;

    // se é pra mostrar o movimento de destino
    if Contido('2', origem) then
    begin
      DEST := ' PARA DEPOSITO';
      fat := 1;
      if dm.IBselect.FieldByName('destino').AsString = '1' then
      begin
        DEST := ' PARA LOJA';
        fat := -1;
      end;

      form33.ClientDataSet1.Insert;
      form33.ClientDataSet1.FieldByName('data').AsDateTime :=
        dm.IBselect.FieldByName('data').AsDateTime;
      form33.ClientDataSet1.FieldByName('historico').AsString :=
        'TRANSFERENCIA ' + dm.IBselect.FieldByName('documento').AsString + DEST;
      form33.ClientDataSet1.FieldByName('preco').AsCurrency := 0;
      form33.ClientDataSet1.FieldByName('quant').AsCurrency :=
        fat * dm.IBselect.FieldByName('quant').AsCurrency;
      form33.ClientDataSet1.FieldByName('saldo').AsCurrency := geral;
      form33.ClientDataSet1.FieldByName('cont').AsInteger :=
        form33.ClientDataSet1.RecordCount + 1;
      form33.ClientDataSet1.Post;

    end;

    transf := transf + (dm.IBselect.FieldByName('quant').AsCurrency);
    dm.IBselect.Next;
  end;

  // ACERTOS DE ESTOQUE
  dm.IBselect.Close;
  dm.IBselect.SQL.Clear;
  dm.IBselect.SQL.Add
    ('SELECT SUM(QUANT) AS saldoantLoja, SUM(deposito) AS saldoantDeposito from acerto where (data < :ini) and (codigo = '
    + te + ')');
  dm.IBselect.ParamByName('ini').AsDateTime := datini;
  dm.IBselect.Open;
  saldoAnteriorLoja := saldoAnteriorLoja + dm.IBselect.FieldByName
    ('saldoantLoja').AsCurrency;
  saldoAnteriorDeposito := saldoAnteriorDeposito + dm.IBselect.FieldByName
    ('saldoantDeposito').AsCurrency;

  dm.IBselect.Close;
  dm.IBselect.SQL.Clear;
  dm.IBselect.SQL.Add('select codigo, data, quant, deposito from acerto where '
    + ' (data >= :ini) and (codigo = ' + te + ')');
  dm.IBselect.ParamByName('ini').AsDateTime := StrToDateTime(dini);
  dm.IBselect.Open;
  dm.IBselect.FetchAll;

  acerto := 0;

  while not dm.IBselect.Eof do
  begin
    if ((dm.IBselect.FieldByName('quant').AsCurrency <> 0) and
      ((pos('1', origem) > 0)) or ((pos('0', origem) > 0))) then
    begin
      geral := geral + dm.IBselect.FieldByName('quant').AsCurrency;
      acerto := acerto + dm.IBselect.FieldByName('quant').AsCurrency;
      form33.ClientDataSet1.Open;
      form33.ClientDataSet1.Insert;
      form33.ClientDataSet1.FieldByName('data').AsDateTime :=
        dm.IBselect.FieldByName('data').AsDateTime;
      form33.ClientDataSet1.FieldByName('historico').AsString :=
        'ACERTO DE ESTOQUE - LOJA';
      form33.ClientDataSet1.FieldByName('preco').AsCurrency := 0;
      form33.ClientDataSet1.FieldByName('quant').AsCurrency :=
        dm.IBselect.FieldByName('quant').AsCurrency;
      form33.ClientDataSet1.FieldByName('saldo').AsCurrency := geral;
      form33.ClientDataSet1.FieldByName('cont').AsInteger :=
        form33.ClientDataSet1.RecordCount + 1;
      form33.ClientDataSet1.Post;
    end;

    if ((dm.IBselect.FieldByName('deposito').AsCurrency <> 0) and
      (pos('2', origem) > 0)) then
    begin
      geral := geral + dm.IBselect.FieldByName('deposito').AsCurrency;
      acerto := acerto + dm.IBselect.FieldByName('deposito').AsCurrency;
      form33.ClientDataSet1.Open;
      form33.ClientDataSet1.Insert;
      form33.ClientDataSet1.FieldByName('data').AsDateTime :=
        dm.IBselect.FieldByName('data').AsDateTime;
      form33.ClientDataSet1.FieldByName('historico').AsString :=
        'ACERTO DE ESTOQUE - DEPOSITO';
      form33.ClientDataSet1.FieldByName('preco').AsCurrency := 0;
      form33.ClientDataSet1.FieldByName('quant').AsCurrency :=
        dm.IBselect.FieldByName('deposito').AsCurrency;
      form33.ClientDataSet1.FieldByName('saldo').AsCurrency := geral;
      form33.ClientDataSet1.FieldByName('cont').AsInteger :=
        form33.ClientDataSet1.RecordCount + 1;
      form33.ClientDataSet1.Post;
    end;
    dm.IBselect.Next;
  end;

  { fim acertos }

  prod := new(Ptr_Produto);
  prod.tot1 := 0;
  prod.tot2 := 0;
  prod.tot3 := 0;

  form33.ClientDataSet1.IndexName := 'indice';
  form33.ClientDataSet1.FieldByName('cont').Visible := False;
  form33.ClientDataSet1.First;

  TCurrencyField(form33.ClientDataSet1.FieldByName('preco')).DisplayFormat :=
    '#,###,###0.00';
  TCurrencyField(form33.ClientDataSet1.FieldByName('quant')).DisplayFormat :=
    '#,###,###0.00';
  TCurrencyField(form33.ClientDataSet1.FieldByName('saldo')).DisplayFormat :=
    '#,###,###0.00';

  form33.ClientDataSet1.First;
  form33.txt := RelSomatoria_T_(lista, dini, dfim, geral);

  geral := 0;
  if pos('0', origem) > 0 then
    geral := geral + saldoAnteriorLoja
  else if pos('1', origem) > 0 then
    geral := geral + saldoAnteriorLoja;
  if pos('2', origem) > 0 then
    geral := geral + saldoAnteriorDeposito;

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
  form33.cod1 := StrToIntDef(te, 0);
  form33.ficha := true;
  form33.saldo := geral;

  form33.txt := form33.txt + #13 + #13 + 'Resumo:' + #13 + #13 + 'Entradas: ' +
    CompletaOuRepete('', FormatCurr('#,###,###0.00', entrada), '.', 12) + #13 +
    'Vendas..: ' + CompletaOuRepete('', FormatCurr('#,###,###0.00', venda), '.',
    12) + #13 + 'Tranf...: ' + CompletaOuRepete('', FormatCurr('#,###,###0.00',
    transf), '.', 12) + #13 + 'Acerto..: ' + CompletaOuRepete('',
    FormatCurr('#,###,###0.00', acerto), '.', 12) + #13 + #13;

  { ShowMessage('entrada=' + CurrToStr(entrada) + #13 + 'Venda=' + CurrToStr(venda) + #13 +
    'Transf=' + CurrToStr(transf) + #13 + 'Acerto=' + CurrToStr(acerto)) ;

    FIM de calcular o saldo }

  lab := TLabel.Create(self);
  lab.Name := 'lab';
  lab.Parent := form33;
  lab.caption := 'I-IMPRIME     T-TOTAL';
  lab.Align := alBottom;
  lab.AutoSize := true;
  lab.Font.Style := [fsbold];
  lab.Font.Size := 9;
  funcoes.CtrlResize(TForm(form33));
  form33.ShowModal;
  // lis.Free;
  form33.ClientDataSet1.Free;
  form33.Free;
  Dispose(prod);
  lista.Free;
  lab := nil;
end;

procedure Tfuncoes.imprimeOrdemDeServico(var ordem: TOrdem;
  const orcamento: boolean; ImprimeNoFimDaVenda: boolean = False);
var
  tot, desc: currency;
  sim, usu, tmp: String;
  i, linhaFimServico: integer;
  cds: TClientDataSet;
begin
  tot := 0;
  form19.RichEdit1.Clear;

  if Contido(form22.Pgerais.Values['nota'], 'TD') then
  begin
    dm.IBselect.Close;
    dm.IBselect.SQL.text := 'select nome from usuario where cod = :cod';
    dm.IBselect.ParamByName('cod').AsInteger := ordem.USUARIO;
    dm.IBselect.Open;

    usu := IntToStr(ordem.USUARIO) + '-' + dm.IBselect.FieldByName
      ('nome').AsString;

    addRelatorioForm19(funcoes.CompletaOuRepete('', '', '-', 40) + #13 + #10);
    addRelatorioForm19(funcoes.centraliza(form22.Pgerais.Values['empresa'], ' ',
      40) + #13 + #10);
    addRelatorioForm19(funcoes.CompletaOuRepete('', '', '-', 40) + #13 + #10);
    addRelatorioForm19(funcoes.CompletaOuRepete('DATA: ' +
      FormatDateTime('dd/mm/yy', form22.dataMov),
      ' HORA: ' + FormatDateTime('hh:mm:ss', now), ' ', 40) + CRLF);
    addRelatorioForm19('Servico: ' + IntToStr(ordem.cod) + '    USUARIO: ' +
      usu + CRLF);
    if ordem.venda > 0 then
      addRelatorioForm19('Venda: ' + IntToStr(ordem.venda) + CRLF);
    addRelatorioForm19(funcoes.CompletaOuRepete('', '', '-', 40) + #13 + #10);

    if ordem.Cliente > 0 then
    begin
      dm.IBselect.Close;
      dm.IBselect.SQL.text :=
        'select nome, ende, bairro, telres, telcom from cliente where cod = :cod';
      dm.IBselect.ParamByName('cod').AsInteger := ordem.Cliente;
      dm.IBselect.Open;

      addRelatorioForm19('NOME: ' + LeftStr(dm.IBselect.FieldByName('nome')
        .AsString, 33) + CRLF);
      addRelatorioForm19('END: ' + LeftStr(dm.IBselect.FieldByName('ende')
        .AsString, 33) + CRLF);
      addRelatorioForm19('BAIRRO: ' + dm.IBselect.FieldByName('bairro')
        .AsString + CRLF);
      addRelatorioForm19('FONES: ' + dm.IBselect.FieldByName('telres').AsString
        + ' ' + dm.IBselect.FieldByName('TELCOM').AsString + CRLF);
      addRelatorioForm19(funcoes.CompletaOuRepete('', '', '-', 40) + CRLF);
    end;

    addRelatorioForm19(CompletaOuRepete(form22.nomesServico.Values['1'] + ':',
      ordem.equipe, '.', 40) + CRLF);
    addRelatorioForm19(CompletaOuRepete(form22.nomesServico.Values['2'] + ':',
      ordem.marca, '.', 40) + CRLF);
    addRelatorioForm19(CompletaOuRepete(form22.nomesServico.Values['3'] + ':',
      ordem.modelo, '.', 40) + CRLF);
    addRelatorioForm19(CompletaOuRepete(form22.nomesServico.Values['4'] + ':',
      ordem.serie, '.', 40) + CRLF);
    addRelatorioForm19(CompletaOuRepete(form22.nomesServico.Values['5'] + ':',
      ordem.tecnico, '.', 40) + CRLF);

    IF length(ordem.obs) > 0 then
    begin
      addRelatorioForm19(funcoes.CompletaOuRepete('', '', '-', 40) + CRLF);
      addRelatorioForm19('OBS: ' + LeftStr(ordem.obs, 35) + CRLF);
      if length(ordem.obs) > 35 then
      begiN
        addRelatorioForm19(copy(ordem.obs, 36, length(ordem.obs)) + CRLF);
      end;
    end;

    addRelatorioForm19(funcoes.CompletaOuRepete('', '', '-', 40) + CRLF);

    if (not orcamento) then
    begin
      if ordem.venda = 0 then
      begin
        dm.IBselect.Close;
        dm.IBselect.SQL.text :=
          'select o.cod, p.nome, 0 as desconto, s.pago, o.quant, o.p_venda,p.codbar, p.refori, p.localiza, o.total from os_itens o left join produto p on (p.cod = o.cod)'
          + 'left join servico s on (s.cod = o.nota) where nota = :nota';
        dm.IBselect.ParamByName('nota').AsInteger := ordem.cod;
        dm.IBselect.Open;
      end
      else
      begin
        dm.IBselect.Close;
        dm.IBselect.SQL.text :=
          'select v.desconto, s.pago, v.desconto, v.total as total1, o.cod,p.codbar, p.refori, p.localiza, p.nome, o.quant, o.p_venda, o.total from item_venda o left join produto p on (p.cod = o.cod) left join venda v on (v.nota = o.nota)'
          + 'left join servico s on (s.cod = :codserv) where o.nota = :nota';
        dm.IBselect.ParamByName('codserv').AsInteger := ordem.cod;
        dm.IBselect.ParamByName('nota').AsInteger := ordem.venda;
        dm.IBselect.Open;
      end;

      if ImprimeNoFimDaVenda then
      begin
        cds := form20.ClientDataSet1;
        cds.First;
        while not cds.Eof do
        begin
          while true do
          begin
            if (cds.FieldByName('estado').AsString = 'I') then
              break;
            if (cds.Eof) then
              exit;
            cds.Next;
          end;

          dm.IBselect.Close;
          dm.IBselect.SQL.text :=
            'select codbar,cod,refori, localiza from produto where cod = :cod';
          dm.IBselect.ParamByName('cod').AsInteger := cds.FieldByName('codigo')
            .AsInteger;
          dm.IBselect.Open;

          tmp := funcoes.buscaParamGeral(74, '1');
          if tmp = '2' then
          begin
            tmp := 'refori';
            tmp := dm.IBselect.FieldByName(tmp).AsString;
          end
          else if tmp = '3' then
          begin
            tmp := 'codbar';
            tmp := dm.IBselect.FieldByName(tmp).AsString;
          end
          else
          begin
            tmp := 'localiza';
            tmp := dm.IBselect.FieldByName(tmp).AsString;
          end;

          addRelatorioForm19
            (funcoes.CompletaOuRepete(dm.IBselect.FieldByName('cod').AsString +
            '-' + copy(cds.FieldByName('descricao').AsString, 1,
            37 - length(dm.IBselect.FieldByName('cod').AsString)), '', ' ',
            40) + CRLF);
          addRelatorioForm19(funcoes.CompletaOuRepete(LeftStr(tmp, 14), '', ' ',
            14) + funcoes.CompletaOuRepete('', FormatCurr('0.00',
            cds.FieldByName('quant').AsCurrency), ' ', 9) +
            funcoes.CompletaOuRepete('', FormatCurr('0.00',
            cds.FieldByName('preco').AsCurrency), ' ', 8) +
            funcoes.CompletaOuRepete('', FormatCurr('0.00',
            cds.FieldByName('total').AsCurrency), ' ', 9) + CRLF);
          dm.IBselect.Close;

          tot := tot + cds.FieldByName('total').AsCurrency;

          cds.Next;
        end;

        tot := form20.total1;
        // desc := form20.desconto;
        desc := 0;
      end
      else
      begin
        while not dm.IBselect.Eof do
        begin
          if ConfParamGerais[5] = 'S' then
          begin

            tmp := funcoes.buscaParamGeral(74, '1');
            if tmp = '2' then
            begin
              tmp := 'refori';
              tmp := dm.IBselect.FieldByName(tmp).AsString;
            end
            else if tmp = '3' then
            begin
              tmp := 'codbar';
              tmp := dm.IBselect.FieldByName(tmp).AsString;
            end
            else
            begin
              tmp := 'localiza';
              tmp := dm.IBselect.FieldByName(tmp).AsString;
            end;

            addRelatorioForm19
              (funcoes.CompletaOuRepete(dm.IBselect.FieldByName('cod').AsString
              + '-' + copy(dm.IBselect.FieldByName('nome').AsString, 1,
              37 - length(dm.IBselect.FieldByName('cod').AsString)), '', ' ',
              40) + CRLF);
            addRelatorioForm19(funcoes.CompletaOuRepete(LeftStr(tmp, 14), '',
              ' ', 14) + funcoes.CompletaOuRepete('', FormatCurr('0.00',
              dm.IBselect.FieldByName('quant').AsCurrency), ' ', 9) +
              funcoes.CompletaOuRepete('', FormatCurr('0.00',
              dm.IBselect.FieldByName('p_venda').AsCurrency), ' ', 8) +
              funcoes.CompletaOuRepete('', FormatCurr('0.00',
              dm.IBselect.FieldByName('total').AsCurrency), ' ', 9) + CRLF);

            { addRelatorioForm19(funcoes.CompletaOuRepete(tmp + '-' +
              copy(dm.IBselect.FieldByName('nome').AsString, 1, 37 - length(tmp)),
              '', ' ', 40) + CRLF);
              addRelatorioForm19
              (funcoes.CompletaOuRepete
              (LeftStr(IfThen(trim(dm.IBselect.FieldByName('localiza').AsString)
              = '', '*', trim(dm.IBselect.FieldByName('localiza').AsString)), 14),
              '', ' ', 15) + funcoes.CompletaOuRepete('', FormatCurr('0.000',
              dm.IBselect.FieldByName('quant').AsCurrency), ' ', 8) +
              funcoes.CompletaOuRepete('', FormatCurr('0.00',
              dm.IBselect.FieldByName('p_venda').AsCurrency), ' ', 8) +
              funcoes.CompletaOuRepete('', FormatCurr('0.00',
              dm.IBselect.FieldByName('total').AsCurrency), ' ', 9) + CRLF); }
          end
          else
          begin
            form19.RichEdit1.Perform(EM_REPLACESEL, 1,
              Longint(PChar((funcoes.CompletaOuRepete(dm.IBselect.FieldByName
              ('cod').AsString + '-' + copy(dm.IBselect.FieldByName('nome')
              .AsString, 1, 37 - length(dm.IBselect.FieldByName('cod').AsString)
              ), '', ' ', 40) + #13 + #10))));
            form19.RichEdit1.Perform(EM_REPLACESEL, 1,
              Longint(PChar((funcoes.CompletaOuRepete('=>QTD:',
              FormatCurr('#,###,###0.000', dm.IBselect.FieldByName('quant')
              .AsCurrency), ' ', 13) + funcoes.CompletaOuRepete('',
              FormatCurr('#,###,###0.00', dm.IBselect.FieldByName('p_venda')
              .AsCurrency) + 'R$', ' ', 13) + funcoes.CompletaOuRepete('',
              FormatCurr('#,###,###0.00', dm.IBselect.FieldByName('total')
              .AsCurrency) + 'R$', ' ', 14) + #13 + #10))));
          end;

          tot := tot + dm.IBselect.FieldByName('total').AsCurrency;
          dm.IBselect.Next;
        end;
        desc := dm.IBselect.FieldByName('desconto').AsCurrency;
        ordem.pago := dm.IBselect.FieldByName('pago').AsCurrency;
      end;
    end;
    // faltou forma de pagamento

    addRelatorioForm19(funcoes.CompletaOuRepete('', '', '-', 40) + CRLF);
    addRelatorioForm19(funcoes.CompletaOuRepete('Sub-Total:',
      FormatCurr('0.00', tot), '.', 40) + CRLF);
    if desc <> 0 then
      addRelatorioForm19(funcoes.CompletaOuRepete('Desconto:',
        FormatCurr('0.00', desc), '.', 40) + CRLF);
    if ordem.pago > 0 then
      addRelatorioForm19(funcoes.CompletaOuRepete('Entrada:',
        FormatCurr('0.00', ordem.pago), '.', 40) + CRLF);
    addRelatorioForm19(funcoes.CompletaOuRepete('', '', '-', 40) + CRLF);
    addRelatorioForm19(funcoes.CompletaOuRepete('Total a Pagar:',
      FormatCurr('0.00', tot - ordem.pago + desc), '.', 40) + CRLF);

    addRelatorioForm19(funcoes.CompletaOuRepete('', '', '-', 40) + CRLF);

    sim := funcoes.dialogo('generico', 20, 'SN', 20, False, 'S',
      Application.Title, 'Enviar para Impressora?(S/N)' + #13 + #10, 'S');
    if (sim = '*') then
      exit;

    if sim = 'S' then
      imprime.textx('')
    else
      form19.ShowModal;

    exit;
  end;

  tot := 0;
  funcoes.CharSetRichEdit(form19.RichEdit1);
  form19.RichEdit1.Clear;
  addRelatorioForm19(funcoes.CompletaOuRepete(#218, #191, #196, 80) + CRLF);
  addRelatorioForm19(funcoes.CompletaOuRepete(#179 + ' ORDEM DE SERVICO Nr.: ' +
    IntToStr(ordem.cod), 'DATA: ' + formataDataDDMMYY(form22.dataMov) + '   ' +
    #179, ' ', 80) + CRLF);
  addRelatorioForm19(funcoes.CompletaOuRepete(#195, #180, #196, 80) + CRLF);

  dm.IBselect.Close;
  dm.IBselect.SQL.text :=
    'select cnpj, ende, telcom, telres, bairro, cid, est, obs from registro';
  dm.IBselect.Open;

  addRelatorioForm19(funcoes.CompletaOuRepete(#179 + ' ' + form22.Pgerais.Values
    ['empresa'], 'CNPJ: ' + dm.IBselect.FieldByName('cnpj').AsString + '   ' +
    #179, ' ', 80) + CRLF);
  addRelatorioForm19(funcoes.CompletaOuRepete(#179 + ' ' +
    dm.IBselect.FieldByName('ende').AsString + ' - ' + dm.IBselect.FieldByName
    ('bairro').AsString, #179, ' ', 80) + CRLF);
  addRelatorioForm19(funcoes.CompletaOuRepete(#179 + ' Tel: ' +
    dm.IBselect.FieldByName('telres').AsString + ' ' + dm.IBselect.FieldByName
    ('cid').AsString + ' - ' + dm.IBselect.FieldByName('est').AsString, #179,
    ' ', 80) + CRLF);
  addRelatorioForm19(funcoes.CompletaOuRepete(#179 + ' Obs: ' +
    dm.IBselect.FieldByName('obs').AsString, #179, ' ', 80) + CRLF);
  addRelatorioForm19(funcoes.CompletaOuRepete(#195, #194, #196, 49) +
    funcoes.CompletaOuRepete('', #180, #196, 31) + CRLF);
  dm.IBselect.Close;

  dm.IBselect.Close;
  dm.IBselect.SQL.text :=
    'select cod,ies, cnpj, nome, ende, telcom, telres, bairro, cid, est, obs from cliente where cod = :cod';
  dm.IBselect.ParamByName('cod').AsInteger := ordem.Cliente;
  dm.IBselect.Open;

  { DADOS DO CLIENTE }
  addRelatorioForm19(funcoes.CompletaOuRepete(#179 + ' Nome: ' +
    dm.IBselect.FieldByName('nome').AsString, #179, ' ', 49) +
    funcoes.CompletaOuRepete('CPF/CNPJ:' + dm.IBselect.FieldByName('cnpj')
    .AsString, #179, ' ', 31) + CRLF);
  addRelatorioForm19(funcoes.CompletaOuRepete(#179 + ' Endereco: ' +
    dm.IBselect.FieldByName('ende').AsString, #179, ' ', 49) +
    funcoes.CompletaOuRepete('INSC. EST.:' + dm.IBselect.FieldByName('ies')
    .AsString, #179, ' ', 31) + CRLF);
  addRelatorioForm19(funcoes.CompletaOuRepete(#179 + ' Bairro: ' +
    dm.IBselect.FieldByName('bairro').AsString + ' ' + dm.IBselect.FieldByName
    ('cid').AsString + '-' + dm.IBselect.FieldByName('est').AsString, #179, ' ',
    49) + funcoes.CompletaOuRepete('CODIGO:' + dm.IBselect.FieldByName('cod')
    .AsString, #179, ' ', 31) + CRLF);
  addRelatorioForm19(funcoes.CompletaOuRepete(#179 + ' Obs: ' +
    dm.IBselect.FieldByName('obs').AsString, #179, ' ', 49) +
    funcoes.CompletaOuRepete('Fone:' + dm.IBselect.FieldByName('telres')
    .AsString, #179, ' ', 31) + CRLF);
  addRelatorioForm19(funcoes.CompletaOuRepete(#195, #197, #196, 49) +
    funcoes.CompletaOuRepete('', #180, #196, 31) + CRLF);
  dm.IBselect.Close;

  { DADOS DA O. S. }
  addRelatorioForm19(funcoes.CompletaOuRepete(#179 + ' ' +
    form22.nomesServico.Values['1'] + ': ' + ordem.equipe, #179, ' ', 49) +
    funcoes.CompletaOuRepete(form22.nomesServico.Values['4'] + ': ' +
    ordem.serie, #179, ' ', 31) + CRLF);
  addRelatorioForm19(funcoes.CompletaOuRepete(#179 + ' ' +
    funcoes.CompletaOuRepete(form22.nomesServico.Values['2'] + ': ' +
    ordem.marca, '', ' ', 23) + ' ' + form22.nomesServico.Values['3'] + ': ' +
    ordem.modelo, #179, ' ', 49) + funcoes.CompletaOuRepete
    (form22.nomesServico.Values['5'] + ': ' + ordem.tecnico, #179, ' ',
    31) + CRLF);
  addRelatorioForm19(funcoes.CompletaOuRepete(#179 + ' ' +
    form22.nomesServico.Values['6'] + ': ' + ordem.defeito, #179, ' ', 49) +
    funcoes.CompletaOuRepete('Usuario: ' + funcoes.BuscaNomeBD(dm.ibquery3,
    'nome', 'usuario', 'where cod = ' + IntToStr(ordem.USUARIO)), #179, ' ',
    31) + CRLF);
  addRelatorioForm19(funcoes.CompletaOuRepete(#179 + ' OBS: ' + ordem.obs, #179,
    ' ', 80)  + CRLF);

  addRelatorioForm19(funcoes.CompletaOuRepete(#195, #194, #196, 8) +
    funcoes.CompletaOuRepete('', #194, #196, 8) + funcoes.CompletaOuRepete('',
    '', #196, 33) + funcoes.CompletaOuRepete('', #194, #196, 8) +
    { aqui começa unitario } funcoes.CompletaOuRepete('', #194, #196, 11) +
    funcoes.CompletaOuRepete('', #180, #196, 12) + CRLF);

  addRelatorioForm19(funcoes.CompletaOuRepete(#179 + 'Codigo', #179, ' ', 8) +
    funcoes.CompletaOuRepete('  Qtd.', #179, ' ', 8) + funcoes.CompletaOuRepete
    (' Descricao', #179, ' ', 41) +
    { aqui começa unitario } funcoes.CompletaOuRepete(' Unitario', #179, ' ',
    11) + funcoes.CompletaOuRepete('   Total', #179, ' ', 12) + CRLF);

  addRelatorioForm19(funcoes.CompletaOuRepete(#195, #197, #196, 8) +
    funcoes.CompletaOuRepete('', #197, #196, 8) + funcoes.CompletaOuRepete('',
    #197, #196, 41) +
    { aqui começa unitario } funcoes.CompletaOuRepete('', #197, #196, 11) +
    funcoes.CompletaOuRepete('', #180, #196, 12) + CRLF);

  if ImprimeNoFimDaVenda then
  begin
    cds := form20.ClientDataSet1;
    cds.First;
    while not cds.Eof do
    begin
      while true do
      begin
        if (cds.FieldByName('estado').AsString = 'I') then
          break;
        if (cds.Eof) then
          exit;
        cds.Next;
      end;

      dm.IBselect.Close;
      dm.IBselect.SQL.text :=
        'select codbar,cod,refori, localiza from produto where cod = :cod';
      dm.IBselect.ParamByName('cod').AsInteger := cds.FieldByName('codigo')
        .AsInteger;
      dm.IBselect.Open;

      tmp := funcoes.buscaParamGeral(74, '1');
      if tmp = '2' then
      begin
        tmp := 'refori';
        tmp := dm.IBselect.FieldByName(tmp).AsString;
      end
      else if tmp = '3' then
      begin
        tmp := 'codbar';
        tmp := dm.IBselect.FieldByName(tmp).AsString;
      end
      else
      begin
        tmp := 'localiza';
        tmp := dm.IBselect.FieldByName(tmp).AsString;
      end;

      addRelatorioForm19(funcoes.CompletaOuRepete(#179,
        dm.IBselect.FieldByName('cod').AsString + #179, ' ', 8) +
        funcoes.CompletaOuRepete('', formataCurrency(cds.FieldByName('quant')
        .AsCurrency) + #179, ' ', 8) + funcoes.CompletaOuRepete
        (copy(cds.FieldByName('descricao').AsString, 1, 39), #179, ' ', 41) +
        { aqui começa unitario } funcoes.CompletaOuRepete('',
        formataCurrency(cds.FieldByName('preco').AsCurrency) + #179, ' ', 11) +
        funcoes.CompletaOuRepete('', formataCurrency(cds.FieldByName('total')
        .AsCurrency) + #179, ' ', 12) + CRLF);

      tot := tot + cds.FieldByName('total').AsCurrency;

      cds.Next;
    end;
  end
  else
  begin
    if (orcamento = False) then
    begin
      if ordem.venda = 0 then
      begin
        dm.IBselect.Close;
        dm.IBselect.SQL.text :=
          'select o.cod, p.nome, o.quant, o.p_venda, o.total from os_itens o left join produto p on (p.cod = o.cod) where nota = :nota';
        dm.IBselect.ParamByName('nota').AsInteger := ordem.cod;
        dm.IBselect.Open;
      end
      else
      begin
        dm.IBselect.Close;
        dm.IBselect.SQL.text :=
          'select v.desconto, v.total as total1, o.cod, p.nome, o.quant, o.p_venda, o.total from item_venda o left join produto p on (p.cod = o.cod) left join venda v on (v.nota = o.nota) where o.nota = :nota';
        dm.IBselect.ParamByName('nota').AsInteger := ordem.venda;
        dm.IBselect.Open;
      end;

      tot := 0;
      while not dm.IBselect.Eof do
      begin
        tot := tot + dm.IBselect.FieldByName('total').AsCurrency;
        addRelatorioForm19(funcoes.CompletaOuRepete(#179,
          dm.IBselect.FieldByName('cod').AsString + #179, ' ', 8) +
          funcoes.CompletaOuRepete('',
          formataCurrency(dm.IBselect.FieldByName('quant').AsCurrency) + #179,
          ' ', 8) + funcoes.CompletaOuRepete
          (copy(dm.IBselect.FieldByName('nome').AsString, 1, 39), #179,
          ' ', 41) +
          { aqui começa unitario } funcoes.CompletaOuRepete('',
          formataCurrency(dm.IBselect.FieldByName('p_venda').AsCurrency) + #179,
          ' ', 11) + funcoes.CompletaOuRepete('',
          formataCurrency(dm.IBselect.FieldByName('total').AsCurrency) + #179,
          ' ', 12) + CRLF);
        dm.IBselect.Next;
      end;

      if (ordem.venda <> 0) then
      begin
        tot := dm.IBselect.FieldByName('total1').AsCurrency;
        if (dm.IBselect.FieldByName('desconto').AsCurrency <> 0) then
        begin
          addRelatorioForm19(funcoes.CompletaOuRepete(#179, #179, ' ', 8) +
            funcoes.CompletaOuRepete('', formataCurrency(0) + #179, ' ', 8) +
            funcoes.CompletaOuRepete('Desconto R$', #179, ' ', 41) +
            { aqui começa unitario } funcoes.CompletaOuRepete('',
            formataCurrency(0) + #179, ' ', 11) + funcoes.CompletaOuRepete('',
            formataCurrency(dm.IBselect.FieldByName('desconto').AsCurrency) +
            #179, ' ', 12) + CRLF);
        end;
      end;

      if dm.IBselect.IsEmpty then
      begin
        linhaFimServico := StrToIntDef(funcoes.LerConfig(form22.Pgerais.Values['conf_ter'], 13), 25);
        for i := 0 to linhaFimServico do begin
          addRelatorioForm19(funcoes.CompletaOuRepete(#179, #179, ' ', 8) +
            funcoes.CompletaOuRepete('', #179, ' ', 8) +
            funcoes.CompletaOuRepete('', #179, ' ', 41) +
            { aqui começa unitario } funcoes.CompletaOuRepete('', #179, ' ', 11)
            + funcoes.CompletaOuRepete('', #179, ' ', 12) + CRLF);
        end;
        // addRelatorioForm19(funcoes.CompletaOuRepete(#179 , #179, ' ', 8) + funcoes.CompletaOuRepete('' , #179, ' ', 8) + funcoes.CompletaOuRepete('', #179, ' ', 41) +
        // {aqui começa unitario} funcoes.CompletaOuRepete('', #179, ' ', 11) + funcoes.CompletaOuRepete('', #179, ' ', 12) + CRLF);
      end;
      dm.IBselect.Close;
    end { fim not orcamento }
    else
    begin
      form20.ClientDataSet1.First;
      while not form20.ClientDataSet1.Eof do
      begin
        addRelatorioForm19(funcoes.CompletaOuRepete(#179,
          form20.ClientDataSet1.FieldByName('codigo').AsString + #179, ' ', 8) +
          funcoes.CompletaOuRepete('',
          formataCurrency(form20.ClientDataSet1.FieldByName('quant').AsCurrency)
          + #179, ' ', 8) + funcoes.CompletaOuRepete
          (form20.ClientDataSet1DESCRICAO.AsString, #179, ' ', 41) +
          { aqui começa unitario } funcoes.CompletaOuRepete('',
          formataCurrency(form20.ClientDataSet1.FieldByName('preco').AsCurrency)
          + #179, ' ', 11) + funcoes.CompletaOuRepete('',
          formataCurrency(form20.ClientDataSet1.FieldByName('total').AsCurrency)
          + #179, ' ', 12) + CRLF);
        form20.ClientDataSet1.Next;
      end;

      if (form20.desconto <> 0) then
      begin
        addRelatorioForm19(funcoes.CompletaOuRepete(#179, #179, ' ', 8) +
          funcoes.CompletaOuRepete('', formataCurrency(0) + #179, ' ', 8) +
          funcoes.CompletaOuRepete('Desconto R$', #179, ' ', 41) +
          { aqui começa unitario } funcoes.CompletaOuRepete('',
          formataCurrency(0) + #179, ' ', 11) + funcoes.CompletaOuRepete('',
          formataCurrency(form20.desconto) + #179, ' ', 12) + CRLF);
      end;
      tot := form20.total1;
    end;
  end;

  addRelatorioForm19(funcoes.CompletaOuRepete(#195, #193, #196, 8) +
    funcoes.CompletaOuRepete('', #193, #196, 8) + funcoes.CompletaOuRepete('',
    #193, #196, 41) +
    { aqui começa unitario } funcoes.CompletaOuRepete('', #193, #196, 11) +
    funcoes.CompletaOuRepete('', #180, #196, 12) + CRLF);


  i := imprimeOBS_Servico();



  addRelatorioForm19(funcoes.CompletaOuRepete(#179 +
    '                          Total:. . . . . . . . . . . . . . . ',
    formataCurrency(tot) + ' ' + #179, ' ', 80) + CRLF);
  addRelatorioForm19(funcoes.CompletaOuRepete(#195, #180, #196, 80) + CRLF);
  addRelatorioForm19(funcoes.CompletaOuRepete(#179 + ' ENTRADA: ' +
    formataDataDDMMYY(ordem.data) + ' AS ' + ordem._ent, '', ' ', 35) +
    funcoes.CompletaOuRepete(' Recebido Por: ', #179, ' ', 45) + CRLF);
  addRelatorioForm19(funcoes.CompletaOuRepete(#179 + ' SAIDA  : ' +
    IfThen(formataDataDDMMYY(ordem.saida) = '01/01/00', '  /  /  ',
    formataDataDDMMYY(ordem.saida)) + ' AS ' + ordem.h_saida, '', ' ', 35) +
    funcoes.CompletaOuRepete('' + IfThen((ordem.venda <> 0) and (not orcamento),
    ' PEDIDO: ' + IntToStr(ordem.venda), ''), #179, ' ', 45) + CRLF);
  addRelatorioForm19(funcoes.CompletaOuRepete(#192, #217, #196, 80) + CRLF);

  sim := funcoes.dialogo('normal', 0, 'SN', 30, False, 'S', Application.Title,
    'Enviar para Impressora?(S/N)' + #13 + #10, 'N');
  if (sim = '*') then
    exit;

  if sim = 'S' then
    // imprime.textx('')
    imprime.textxArq('@')
  else
    form19.ShowModal;
  // imprime.textxArq('');
end;

procedure Tfuncoes.atualizaMensagemUsuario(const mens, nota: String);
begin
  if nota = '' then
    exit;

  if funcoes.buscaParamGeral(73, 'N') = 'S' then
  begin
    if trim(mens) <> '' then
    begin
      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.text := 'select nota from OBS_VENDA where NOTA = :NOTA';
      dm.IBQuery1.ParamByName('NOTA').AsInteger := StrToInt(StrNum(nota));
      dm.IBQuery1.Open;

      if dm.IBQuery1.IsEmpty then
      begin
        if dm.IBQuery1.Transaction.Active then
          dm.IBQuery1.Transaction.Commit;
        dm.IBQuery1.Transaction.StartTransaction;
        dm.IBQuery1.Close;
        dm.IBQuery1.SQL.text :=
          'insert into OBS_VENDA(NOTA, OBS) VALUES(:NOTA, :OBS)';
        dm.IBQuery1.ParamByName('NOTA').AsInteger := StrToInt(StrNum(nota));
        dm.IBQuery1.ParamByName('OBS').AsString := copy(mens, 1, 70);
        dm.IBQuery1.ExecSQL;
        dm.IBQuery1.Transaction.Commit;
      end
      else
      begin
        dm.IBQuery1.Close;
        dm.IBQuery1.SQL.text :=
          'update OBS_VENDA set OBS = :OBS where NOTA = :NOTA';
        dm.IBQuery1.ParamByName('OBS').AsString := copy(mens, 1, 70);
        dm.IBQuery1.ParamByName('NOTA').AsInteger := StrToInt(StrNum(nota));
        dm.IBQuery1.ExecSQL;
      end;
    end;
    exit;
  end;

  form22.Pgerais.Values['mens'] := mens;
  dm.IBQuery1.Close;
  dm.IBQuery1.SQL.text := 'update usuario set mens = :mens where cod = :cod';
  dm.IBQuery1.ParamByName('mens').AsString := copy(mens, 1, 40);
  dm.IBQuery1.ParamByName('cod').AsString := form22.codusario;
  dm.IBQuery1.ExecSQL;
  dm.IBQuery1.Transaction.Commit;
end;

procedure Tfuncoes.Descomprimir(ArquivoZip: TFileName;
  DiretorioDestino: string);
var
  NomeSaida: string;
  FileEntrada, FileOut: TFileStream;
  Descompressor: TDecompressionStream;
  NumArq, i, Len, Size: integer;
  fim: Byte;
begin
  FileEntrada := TFileStream.Create(ArquivoZip, fmOpenRead and
    fmShareExclusive);
  Descompressor := TDecompressionStream.Create(FileEntrada);
  Descompressor.Read(NumArq, SizeOf(integer));
  try
    i := 0;
    while i < NumArq do
    begin
      Descompressor.Read(Len, SizeOf(integer));
      SetLength(NomeSaida, Len);
      Descompressor.Read(NomeSaida[1], Len);
      Descompressor.Read(Size, SizeOf(integer));
      FileOut := TFileStream.Create(IncludeTrailingBackslash(DiretorioDestino) +
        NomeSaida, fmCreate or fmShareExclusive);
      try
        FileOut.CopyFrom(Descompressor, Size);
      finally
        FileOut.Free;
      end;
      Descompressor.Read(fim, SizeOf(Byte));
      Inc(i);
    end;
  finally
    FreeAndNil(Descompressor);
    FreeAndNil(FileEntrada);
  end;
end;

function Tfuncoes.retornaTipoDoCampo(campo, tabela: String;
  nomeTipo: string = 'TIPO'): String;
begin
  campo := UpperCase(campo);
  tabela := UpperCase(tabela);
  dm.IBselect.Close;
  dm.IBselect.SQL.text := 'SELECT r.RDB$FIELD_NAME AS nome,' +
    ' r.RDB$DESCRIPTION AS descricao,' + ' f.RDB$FIELD_LENGTH AS tamanho,' +
    ' CASE f.RDB$FIELD_TYPE' + ' WHEN 261 THEN ''BLOB'' ' +
    ' WHEN 14 THEN ''CHAR'' ' + ' WHEN 40 THEN ''CSTRING'' ' +
    ' WHEN 11 THEN ''D_FLOAT''' + ' WHEN 27 THEN ''DOUBLE''' +
    ' WHEN 10 THEN ''FLOAT''' + ' WHEN 16 THEN ''INT64''' +
    ' WHEN 8 THEN ''INTEGER''' + ' WHEN 9 THEN ''QUAD''' +
    ' WHEN 7 THEN ''SMALLINT''' + ' WHEN 12 THEN ''DATE''' +
    ' WHEN 13 THEN ''TIME''' + ' WHEN 35 THEN ''TIMESTAMP''' +
    ' WHEN 37 THEN ''VARCHAR''' + ' ELSE ''UNKNOWN''' + ' END AS tipo,' +
    'F.RDB$FIELD_SUB_TYPE AS SubTipo_Campo' + ' FROM RDB$RELATION_FIELDS r' +
    ' LEFT JOIN RDB$FIELDS f ON r.RDB$FIELD_SOURCE = f.RDB$FIELD_NAME' +
    ' WHERE r.RDB$RELATION_NAME=' + QuotedStr(tabela) +
    ' and r.RDB$FIELD_NAME = ' + QuotedStr(campo);
  dm.IBselect.Open;

  Result := trim(dm.IBselect.FieldByName(nomeTipo).AsString);
end;

procedure Tfuncoes.gravaConfigTerminal(const con: String);
var
  arqTerminal: String;
  tmpo: tstringList;
begin
  tmpo := tstringList.Create;
  arqTerminal := buscaNomeConfigDat;
  if FileExists(arqTerminal) then
  begin
    tmpo.LoadFromFile(arqTerminal);
  end;

  { arqTerminal := funcoes.GetTheWindowsDirectory+'\conf_ter.dat';

    if FileExists(funcoes.GetTheWindowsDirectory+'\conf_ter.dat') then
    begin
    tmpo.LoadFromFile(funcoes.GetTheWindowsDirectory+'\conf_ter.dat');
    end; }

  tmpo.Values['0'] := con;
  tmpo.SaveToFile(arqTerminal);
  tmpo.Free;
end;

function Tfuncoes.verificaSeExisteIndiceTrueExiste(const indiceName
  : String): boolean;
begin
  Result := False;
  dm.IBselect.Close;
  dm.IBselect.SQL.Clear;
  dm.IBselect.SQL.Add
    ('select rdb$index_name as nome from rdb$indices where rdb$index_name = :nome');
  dm.IBselect.ParamByName('nome').AsString := indiceName;
  dm.IBselect.Open;

  if dm.IBselect.IsEmpty then
    Result := False
  else
    Result := true;
  dm.IBselect.Close;
end;

procedure Tfuncoes.redimensionaTelaDbgrid(var dbgrid: TDBGrid);
var
  ini, fim, acc: integer;
begin
  acc := 0;
  fim := dbgrid.Columns.count - 1;
  for ini := 0 to fim do
  begin
    acc := acc + dbgrid.Columns.Items[ini].Width;
  end;

  dbgrid.Width := acc;
  acc := acc + 30;
  if acc > screen.Width then
    acc := screen.Width - 20;
  TForm(dbgrid.Owner).Width := acc;

end;

function Tfuncoes.retornaTamanhoDoCampoBD(const nomeCampo, tabela: String)
  : Smallint;
begin
  funcoes.iniciaDataset(dm.IBselect, 'select ' + nomeCampo + ' from ' + tabela);
  dm.IBselect.Open;

  Result := 0;
  Result := dm.IBselect.FieldByName(nomeCampo).Size;
  dm.IBselect.Close;
end;

procedure Tfuncoes.iniciaDataset(var IBQuery: TIBQuery; const SQL: String);
begin
  IBQuery.Close;
  IBQuery.SQL.Clear;
  IBQuery.SQL.Add(SQL);
end;

FUNCTION Tfuncoes.VE_CUSTO(PCOMPRA, PVENDA: currency; cod: String): currency;
begin
  Result := PCOMPRA;
  IF PCOMPRA > 0 then
  begin
    exit;
  end;

  funcoes.iniciaDataset(dm.ibquery4,
    'select p_compra, p_venda from produto where cod = :cod');
  dm.ibquery4.ParamByName('cod').AsString := cod;
  dm.ibquery4.Open;

  if not dm.ibquery4.IsEmpty then
  begin
    Result := iif(dm.ibquery4.FieldByName('p_compra').AsCurrency > 0,
      dm.ibquery4.FieldByName('p_compra').AsCurrency,
      dm.ibquery4.FieldByName('p_venda').AsCurrency / 2);
    dm.ibquery4.Close;
    exit;
  end;

  Result := (PVENDA / 2);
end;

procedure Tfuncoes.criaArqTerminal();
var
  arq: tstringList;
  arqTer: String;
begin
  arqTer := caminhoEXE_com_barra_no_final + buscaNomeConfigDat;
  if not FileExists(arqTer) then
  begin
    arq := tstringList.Create;
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
      arq.SaveToFile(arqTer);
    end;

    arq.Free
  end;
end;

function Tfuncoes.buscaConfigTerminal(indice: Smallint; const default: String;
  nomeConfig: String = ''): String;
var
  arq: tstringList;
  arqTer, tmp: String;
begin
  arqTer := caminhoEXE_com_barra_no_final + buscaNomeConfigDat;

  // criaArqTerminal(); //cria o arquivo do terminal se não existir

  arq := tstringList.Create;
  arq.LoadFromFile(arqTer);

  if nomeConfig <> '' then
  begin
    tmp := arq.Values[nomeConfig];
    if tmp = default then
    begin
      arq.Free;
      exit;
    end;

    arq.Values[nomeConfig] := default;
    arq.SaveToFile(arqTer);
    arq.Free;
    exit;
  end;

  tmp := arq.Values['0'];

  Result := '';
  Result := funcoes.LerConfig(tmp, indice);

  if Result = default then
  begin
    arq.Free;
    exit;
  end;

  if Result = '' then
  begin
    Result := default;
    tmp := GravarConfig(tmp, default, indice);
    arq.Values['0'] := tmp;
    arq.SaveToFile(arqTer);
  end;

  arq.Free;
end;

procedure Tfuncoes.fazBackupDoBD(const rede: boolean);
var
  arq, txt: tstringList;
  pastaServidorControlW, pastaBackupBarraFinal, dia, dBackup, unidade: String;
  Add: Smallint;
  listaArquivos: Array of TFileName;
begin
  SetLength(listaArquivos, 1);
  if rede then
  begin
    if not FileExists(caminhoEXE_com_barra_no_final + buscaNomeConfigDat) then
    begin
      arq := tstringList.Create;
      arq.Values['pasta_ControlW_servidor'] := '\\' + ParamStr(1) +
        '\ControlW\';
      arq.Values['dataBackupBd'] := '01/01/1900';
      arq.SaveToFile(caminhoEXE_com_barra_no_final + buscaNomeConfigDat);
      arq.Free;
    end;

    arq := tstringList.Create;
    Add := 0;
    arq.LoadFromFile(caminhoEXE_com_barra_no_final + buscaNomeConfigDat);

    pastaServidorControlW := funcoes.buscaConfigNaPastaDoControlW
      ('pasta_ControlW_servidor', '\\' + ParamStr(1) + '\ControlW\');
    dBackup := funcoes.buscaConfigNaPastaDoControlW('dataBackupBd',
      '01/01/1900');

    if dBackup = FormatDateTime('dd/mm/yyyy', now) then
    begin
      arq.Free;
      exit;
    end;
  end
  else
  begin
    if ParamCount > 0 then
      pastaServidorControlW := funcoes.buscaConfigNaPastaDoControlW
        ('pasta_ControlW_servidor', '\\' + ParamStr(1) + '\ControlW\')
    else
      pastaServidorControlW := 'C:\ControlW\';

    unidade := funcoes.dialogo('generico', 0, 'ABCDEFGHIJLMNOPKXYZWQRSTUVXZ',
      50, False, 'S', Application.Title,
      'Confirme a unidade para Recebimento da Remessa:', ConfParamGerais[33]);
    if unidade = '*' then
      exit;
  end;

  if not DirectoryExists(pastaServidorControlW) then
  begin
    ShowMessage('Backup de BD não foi realizado na pasta:' + #13 + arq.Values
      ['pasta_ControlW_servidor'] + #13 + 'Favor corrija o diretório.');
    arq.Free;
    exit;
  end;

  if rede then
    pastaBackupBarraFinal := caminhoEXE_com_barra_no_final + 'Backup\'
  else
    pastaBackupBarraFinal := unidade + ':\' + 'Backup\';
  funcoes.CriaDiretorio(pastaBackupBarraFinal);

  dia := FormatDateTime('ddd', now);
  dia := dia + '\';

  funcoes.CriaDiretorio(pastaBackupBarraFinal + dia);

  if rede then
  begin
    if FileExists(pastaBackupBarraFinal + dia + 'bd.fdb') then
      DeleteFile(pastaBackupBarraFinal + dia + 'bd.fdb');
    CopyFile(PChar(pastaServidorControlW + 'bd.fdb'),
      PChar(pastaBackupBarraFinal + dia + 'bd.fdb'), true);
    funcoes.GravaConfigNaPastaDoControlW('dataBackupBd',
      FormatDateTime('dd/mm/yyyy', now));
  end
  else
  begin
    if FileExists(pastaBackupBarraFinal + dia + 'bd.fdb') then
      DeleteFile(pastaBackupBarraFinal + dia + 'bd.fdb');
    CopyFile(PChar(pastaServidorControlW + 'bd.fdb'),
      PChar(pastaBackupBarraFinal + dia + 'bd.fdb'), true);
    funcoes.GravaConfigNaPastaDoControlW('dataBackupBd',
      FormatDateTime('dd/mm/yyyy', now));
    try
      try
        // dm.bd.Connected := false;
        if FileExists(pastaBackupBarraFinal + dia + 'bd.w') then
          DeleteFile(pastaBackupBarraFinal + dia + 'bd.w');
        listaArquivos[0] := pastaBackupBarraFinal + dia + 'bd.fdb';

        // funcoes.Comprimir(pastaBackupBarraFinal + dia + 'bd.w', listaArquivos);
        txt := tstringList.Create;
        txt.Add(pastaBackupBarraFinal + dia + 'bd.fdb');
        Zip(txt, pastaBackupBarraFinal + dia + 'bd.zip');
        txt.Free;
        if FileExists(pastaBackupBarraFinal + dia + 'bd.fdb') then
          DeleteFile(pastaBackupBarraFinal + dia + 'bd.fdb');

        ShowMessage('Cópia de Segurança Efetuada com Sucesso');
      except
        ShowMessage
          ('Ocorreu um Erro no Backup, Favor é necessario fechar o sistema em todos os terminais da rede');
      end;
    finally
      // dm.bd.Connected := true;
    end;
  end;
end;

procedure Tfuncoes.Comprimir(ArquivoCompacto: TFileName;
  Arquivos: array of TFileName);
var
  FileInName: TFileName;
  FileEntrada, FileSaida: TFileStream;
  Compressor: TCompressionStream;
  NumArq, i, Len, Size: integer;
  fim: Byte;
begin
  FileSaida := TFileStream.Create(ArquivoCompacto,
    fmCreate or fmShareExclusive);
  Compressor := TCompressionStream.Create(clMax, FileSaida);
  NumArq := length(Arquivos);
  Compressor.Write(NumArq, SizeOf(integer));
  try
    for i := Low(Arquivos) to High(Arquivos) do
    begin
      FileEntrada := TFileStream.Create(Arquivos[i], fmOpenRead and
        fmShareExclusive);
      try
        FileInName := ExtractFileName(Arquivos[i]);
        Len := length(FileInName);
        Compressor.Write(Len, SizeOf(integer));
        Compressor.Write(FileInName[1], Len);
        Size := FileEntrada.Size;
        Compressor.Write(Size, SizeOf(integer));
        Compressor.CopyFrom(FileEntrada, FileEntrada.Size);
        fim := 0;
        Compressor.Write(fim, SizeOf(Byte));
      finally
        FileEntrada.Free;
      end;
    end;
  finally
    FreeAndNil(Compressor);
    FreeAndNil(FileSaida);
  end;
end;

procedure Tfuncoes.procuraTimmer(var dataset: TIBQuery; caracter: Char;
  const campo: String);
begin
  buscaTimer := buscaTimer + caracter;
  dataset.Locate(campo, buscaTimer, [loPartialKey, loCaseInsensitive]);
  Timer3.Enabled := False;
  Timer3.Enabled := true;
end;

procedure Tfuncoes.desmarcaVendaPaf(const numVenda: String);
begin
  dm.IBQuery1.Close;
  dm.IBQuery1.SQL.Clear;
  dm.IBQuery1.SQL.Add('update venda set exportado = 0 where nota = :nota');
  dm.IBQuery1.ParamByName('nota').AsString := numVenda;
  dm.IBQuery1.ExecSQL;

  dm.IBQuery1.Close;
  dm.IBQuery1.SQL.Clear;
  dm.IBQuery1.SQL.Add('update item_venda set exportado = 0 where nota = :nota');
  dm.IBQuery1.ParamByName('nota').AsString := numVenda;
  dm.IBQuery1.ExecSQL;

  try
    dm.IBQuery1.Transaction.Commit;
  except
    dm.IBQuery1.Transaction.Rollback;
  end;
end;

function Tfuncoes.addRegSite(emp1: String; var quer: TIBQuery; abrirDialogo : boolean = true): String;
var
  bu, th, cnpj, ende: String;
  SS: TStringStream;
  bb: TWebBrowser;
  arq: tstringList;
begin

  Result := '';
  { dm.IBselect.Close;
    dm.IBselect.SQL.Clear;
    dm.IBselect.SQL.Add('select empresa, telres, telcom, ende, bairro, cnpj from registro');
    dm.IBselect.Open; }
  quer.Close;
  quer.SQL.Clear;
  quer.SQL.Add
    ('select empresa, telres, telcom, ende, bairro, cnpj from registro');
  quer.Open;

  th := '';
  if emp1 = '' then
    emp1 := quer.FieldByName('empresa').AsString;
  cnpj := StrNum(quer.FieldByName('cnpj').AsString);
  ende := LeftStr(trocaChar(quer.FieldByName('telres').AsString + '_' +
    quer.FieldByName('telcom').AsString + '_' + quer.FieldByName('ende')
    .AsString + '_' + quer.FieldByName('bairro').AsString, ' ', '_'), 195);

  th := 'emp=' + trim(emp1) + '&cnpj=' + cnpj + '&ende=' + ende;
  th := trocaChar(trocaChar(th, '.', ''), ',', '');
  th := trocaChar(buscaNomeSite + '/si2/add.php?' + th, ' ', '_');
  th := trim(th);

  { arq := TStringList.Create;
    arq.Text := th;
    arq.SaveToFile(ExtractFileDir(ParamStr(0) + '\tex.txt')); }

  dm.IBselect.Close;
  try
    IdHTTP1.Request.UserAgent :=
      'Mozilla/5.0 (Windows NT 5.1; rv:2.0b8) Gecko/20100101 Firefox/4.' +
      '0b8';
    IdHTTP1.HTTPOptions := [hoForceEncodeParams];
    th := IdHTTP1.Get(th);
    Result := th;
    IdHTTP1.Disconnect;

    if Contido('DESBLOQUEADO', th) then
    begin
      LE_CAMPOS(arq, th, '|', true);
      dm.IBselect.Close;
      dm.IBselect.SQL.text := 'select * from email';
      dm.IBselect.Open;

      funcoes.limpaBloqueado(query1);

      if ((dm.IBselect.FieldByName('cod').AsString <> arq.Values['7']) and
        (trim(arq.Values['7']) <> '')) then
      begin
        buscaConfigEmail;
      end;

    end;
  except
    on e: exception do
    begin
      if Contido('Host not found', e.Message) then
      begin
        th := buscaConfigNaPastaDoControlW('Site_Num', '1');
        GravaConfigNaPastaDoControlW('Site_Num',
          IntToStr(StrToIntDef(th, 1) + 1));
      end;
    end;
  end;
end;

function Tfuncoes.baixaEstoque(cod: String; quant: currency;
  origem: integer; commit : boolean = true): boolean;
var
  tmp: currency;
  DEST: string;
begin
  if origem = 1 then
    DEST := 'quant'
  else
    DEST := 'deposito';

  while True do begin
    dm.IBQuery1.Close;
    dm.IBQuery1.SQL.Clear;
    dm.IBQuery1.SQL.Add('update produto set ' + DEST + ' = ' + DEST +
    ' + :qtd where cod = :cod');
    dm.IBQuery1.ParamByName('qtd').AsCurrency := quant;
    dm.IBQuery1.ParamByName('cod').AsString   := cod;

    try
      dm.IBQuery1.ExecSQL;
      break;
    except
    end;
  end;

  if commit then begin
    if dm.IBQuery1.Transaction.InTransaction then dm.IBQuery1.Transaction.Commit;
  end;
end;

function Tfuncoes.ALTERA_CAIXA(codMOV: INTEGER; VALOR: currency;
      ENTRADA1_SAIDA2: integer; commit : boolean = true): boolean;
var
  tmp: currency;
  DEST: string;
begin
  while True do begin
    dm.IBQuery1.Close;
    dm.IBQuery1.SQL.Text := 'select * FROM ALTERA_CAIXA(:cod, :VALOR, :ENTRADA)';
    dm.IBQuery1.ParamByName('cod').AsInteger    := codMOV;
    dm.IBQuery1.ParamByName('VALOR').AsCurrency := VALOR;
    dm.IBQuery1.ParamByName('ENTRADA').AsInteger := ENTRADA1_SAIDA2;
    try
      dm.IBQuery1.Open;
      break;
    except
      on e:exception do begin
        ShowMessage(e.Message);
      end;
    end;
  end;

  if commit then begin
    if dm.IBQuery1.Transaction.InTransaction then dm.IBQuery1.Transaction.Commit;
  end;
end;


function Tfuncoes.baixaEstoqueSP(cod: String; quant: currency;
  origem: integer; commit : boolean = true): boolean;
var
  tmp: currency;
  DEST: string;
begin
  if origem = 1 then
    DEST := 'quant'
  else
    DEST := 'deposito';

  while True do begin
    dm.IBQuery1.Close;
    dm.IBQuery1.SQL.Text := 'select * FROM baixaestoque(:cod, :qtd, :origem)';
    dm.IBQuery1.ParamByName('cod').AsString     := cod;
    dm.IBQuery1.ParamByName('qtd').AsCurrency   := quant;
    dm.IBQuery1.ParamByName('origem').AsInteger := origem;
    try
      dm.IBQuery1.Open;
      break;
    except
      on e:exception do begin
        ShowMessage(e.Message);
      end;
    end;
  end;

  if commit then begin
    if dm.IBQuery1.Transaction.InTransaction then dm.IBQuery1.Transaction.Commit;
  end;
end;

procedure Tfuncoes.limpaMemoria();
begin
  ConfParamGerais.Free;
  form22.Pgerais.Free;
end;

function Tfuncoes.ImprimirPedidoVias(qtdVias: Smallint;
  orcamento: boolean = False): boolean;
var
  tmp: string;
  ini, fim, LIN: integer;
begin
  fim := StrToIntDef(funcoes.LerConfig(form22.Pgerais.Values['conf_ter'], 5), 1);
  if fim > 8 then
  begin
    fim := 1;
  end;

  if orcamento then
    fim := 1
  else
  begin
    if not Contido(form22.Pgerais.Values['nota'], 'TE') then
    begin
      funcoes.duplicarRichedit(fim);
      fim := 1;
    end;
  end;

  if form22.Pgerais.Values['nota'] = 'X' then
  begin
    imprime.textxArq('@', true);
    exit;
  end;

  ini := 0;
  // for ini := 0 to fim -1 do begin
  while true do
  begin
    ini := ini + 1;
    if ini = fim then
    begin
      imprime.textx('', true);
      exit;
    end
    else
    begin
      imprime.textx('', False);
    end;
    // form19.RichEdit1.Lines.Text := form19.RichEdit1.Lines.Text + CRLF +
    // CRLF + '' +  tmp;
  end;
end;

function Tfuncoes.voltarLogin(var form: TForm): boolean;
begin
  form.Close;

  form2.Close;
  form22.Show;
end;

function Tfuncoes.verificaTamnhoCampoBD(tabela, campo: String;
  tamanhoComparar: integer): boolean;
begin
  Result := False;
  dm.IBselect.Close;
  dm.IBselect.SQL.Clear;
  dm.IBselect.SQL.Add('select ' + campo + ' from ' + tabela + ' where ' + campo
    + ' = ' + QuotedStr('0'));
  dm.IBselect.Open;

  if dm.IBselect.FieldByName(campo).Size = tamanhoComparar then
    Result := true;

  dm.IBselect.Close;
end;

function Tfuncoes.logar(usu, senha: String): boolean;
begin
  Result := False;
  dm.IBQuery1.Close;
  dm.IBQuery1.SQL.Clear;
  dm.IBQuery1.SQL.Add
    ('select cod, nome from usuario where (usu = :nome) and (senha = :senha) and excluido = 0');
  dm.IBQuery1.ParamByName('nome').AsString := funcoes.Criptografar(usu);
  dm.IBQuery1.ParamByName('senha').AsString := funcoes.Criptografar(senha);
  dm.IBQuery1.Open;
  if dm.IBQuery1.IsEmpty then
  begin
    dm.IBQuery1.Close;
    ShowMessage('Usuário ou senha inválidos!!');
    exit;
  end
  else
    Result := true;

  dm.IBQuery1.Close;
end;

function Tfuncoes.trocaDeUsuario(): boolean;
begin
  Result := False;
  form53 := tform53.Create(self);
  form53.login_muda_as_variaveis_de_usuario(Result);
  form33.Free;
end;

function Tfuncoes.lerConfigIMPRESSORA(): String;
var
  arq: tstringList;
  imp: integer;
  tp, tmp, arqConfig: String;
begin

  // 1 - tipo de impressao *** 0-USB1 1-UBS2 2-LPT1 3-LPT2   ***
  Result := '';
  // arqConfig := funcoes.GetTheWindowsDirectory + '\conf_ter.dat';
  arqConfig := caminhoEXE_com_barra_no_final + buscaNomeConfigDat;
  arq := tstringList.Create;
  if not FileExists(arqConfig) then
  begin
    criaArqTerminal();
  end;

  if FileExists(arqConfig) then
  begin
    arq.LoadFromFile(arqConfig);
    if (arq.Values['1'] = '') then begin
      tmp := '-0- 0 -1- U -2- 5 -3- 5 -4- 10 -5- N -6- -7- -8- -9- -10- -11- ';
      imp := StrToIntDef(funcoes.LerConfig(form22.Pgerais.Values
        ['conf_ter'], 5), 0);
      tmp := GravarConfig(tmp, IntToStr(imp), 0);

      tp := funcoes.LerConfig(form22.Pgerais.Values['conf_ter'], 6);
      imp := 0;
      if tp = 'I' then
        imp := 1
      else if tp = 'P' then
        imp := 2
      else if tp = 'X' then
        imp := 3;
      tmp := GravarConfig(tmp, IntToStr(imp), 1);

      imp := StrToIntDef(ConfParamGerais[24], 0); // lin Final
      tmp := GravarConfig(tmp, IntToStr(imp), 2);

      imp := StrToIntDef(ConfParamGerais[23], 0); // col inicial
      tmp := GravarConfig(tmp, IntToStr(imp), 3);

      imp := StrToIntDef(funcoes.LerConfig(form22.Pgerais.Values
        ['conf_ter'], 3), 0);
      tmp := GravarConfig(tmp, IntToStr(imp), 4);

      tp := funcoes.LerConfig(form22.Pgerais.Values['conf_ter'], 7);
      tmp := GravarConfig(tmp, tp, 6);

      arq.Values['1'] := tmp;
      arq.SaveToFile(arqConfig);
    end;

    tmp := arq.Values['1'];
    arq.Free;
  end
  else
  begin
    ShowMessage
      ('O sistema não encontrou o arquivo de configuração deste terminal.' + #13
      + 'Favor, acesse as configurações de terminal e volte novamente. Obrigado');
    Close;
    exit;
  end;

  form22.Pgerais.Values['imp'] := tmp;

  try
    dm.ACBrCargaBal1.modelo := TACBrCargaBalModelo
      (StrToIntDef(LerConfig(form22.Pgerais.Values['imp'], 14), 0));
  except
  end;

  dm.ACBrETQ1.modelo := TACBrETQModelo
    (StrToIntDef(LerConfig(form22.Pgerais.Values['imp'], 10), 0));
  dm.ACBrETQ1.Porta := LerConfig(form22.Pgerais.Values['imp'], 8);

  fonteRelatorioForm19 :=
    StrToIntDef(LerConfig(form22.Pgerais.Values['imp'], 13), 10);
  if LerConfig(form22.Pgerais.Values['imp'], 16) = 'S' then
    NegritoRelatorioForm19 := true
  else
    NegritoRelatorioForm19 := False;

  Result := tmp;
end;

function Tfuncoes.formataChaveNFE(const chave: String): String;
var
  fim, soma: integer;
begin
  Result := chave;
  fim := length(chave);
  if fim <> 44 then
    exit;
  soma := 5;
  while true do
  begin
    if soma = 55 then
      break;
    Insert('.', Result, soma);
    soma := soma + 5;
  end;
end;

function Tfuncoes.FORM_DATA_YY_MM_DD(data: TDateTime): String;
begin
  Result := '';
  Result := FormatDateTime('yymmdd', data);
end;

// ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
// INFORMAR NUM_NF (C-6) E TIPO (C-2)
// ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
FUNCTION Tfuncoes.CANC_MOV(NUM_NF, tipo: String): boolean;
// ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
var
  info, PEDIDO: String;
  ini: integer;
  MTT: tstringList;
begin
  MTT := tstringList.Create;
  NUM_NF := funcoes.CompletaOuRepete('', NUM_NF, '0', 7);
  IF tipo = '90' then
    tipo := '99'; // NF-e
  IF tipo = '91' then
    tipo := '98'; // Serie 1
  IF tipo = '92' then
    tipo := '97'; // Serie D
  IF (StrToInt(tipo) <= 40) then
    tipo := STRZERO(StrToInt(tipo) + 40, 2);

  dm.IBselect.Close;
  dm.IBselect.SQL.Clear;
  dm.IBselect.SQL.Add
    ('select item from fvmt where substring(item from 14 for 7) = :item');
  dm.IBselect.ParamByName('item').AsString := NUM_NF;
  dm.IBselect.Open;

  while not dm.IBselect.Eof do
  begin
    info := copy(dm.IBselect.FieldByName('item').AsString, 1,
      length(dm.IBselect.FieldByName('item').AsString) - 2);
    info := info + tipo;

    MTT.Add(copy(info, 7, 7));

    dm.IBQuery1.Close;
    dm.IBQuery1.SQL.Clear;
    dm.IBQuery1.SQL.Add
      ('update fvmt set item = :item, estado = :est where item = :item1');
    dm.IBQuery1.ParamByName('item').AsString := info;
    dm.IBQuery1.ParamByName('est').AsString := 'C';
    dm.IBQuery1.ParamByName('item1').AsString :=
      dm.IBselect.FieldByName('item').AsString;
    dm.IBQuery1.ExecSQL;
    dm.IBselect.Next;
  end;

  try
    if dm.IBQuery1.Transaction.InTransaction then
      dm.IBQuery1.Transaction.Commit;
  except
  end;

  // CANCELA A EMISSAO DO ARQUIVO DE VENDAS
  { FOR ini := 0 TO MTT.Count -1 do
    begin
    dm.IBQuery1.Close;
    dm.IBQuery1.SQL.Clear;
    dm.IBQuery1.SQL.Add('update venda set crc = ' + QuotedStr('') + ' where nota = :nota');
    dm.IBQuery1.ParamByName('nota').AsInteger := StrToIntDef(MTT[ini], 0);
    dm.IBQuery1.ExecSQL;
    end;
  }
  try
    if dm.IBQuery1.Transaction.InTransaction then
      dm.IBQuery1.Transaction.Commit;
    MTT.Free;
  except
  end;
END;

// ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
// DATA (D-6), PEDIDO (C-7), NF (C-6), TIPO (C-2)-> TOTAL 22 BYTES
// DATA (1-6), PEDIDO (7-13), NF (14-20), TIPO (21-22)-> TOTAL 22 BYTES
// TIPO = (90-NFE EMITIDA 91-NF PAPEL EMITIDA 98-NF PAPEL CANCELADA
// 99-NFE CANCELADA 01 A 40-NUM_ECF 41 A 80-CUPOM CANCELADO NUM_ECF + 40)
// ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
FUNCTION Tfuncoes.GRAVA_MOV(PEDIDO: String; data: TDateTime;
  NF, tipo, COD_CLI: String; GRAV_VENDA: boolean; Estado: String = ''): boolean;
var
  info, NUM_PED: String;
  REG, num, ini, fim: integer;
begin
  Result := False;

  PEDIDO := funcoes.CompletaOuRepete('', PEDIDO, '0', 7);
  // NUM_PED := IF(RIGHT(PEDIDO, 1) = "S", LEFT(PEDIDO, 6) + "1", RIGHT(PEDIDO, 6) + "0")//PEDIDO := IF(RIGHT(PEDIDO, 1) = "S", PEDIDO, RIGHT(PEDIDO, 6) + " ")
  NF := funcoes.CompletaOuRepete('', NF, '0', 7);
  tipo := funcoes.CompletaOuRepete('', trim(tipo), '0', 2);
  info := FORM_DATA_YY_MM_DD(data) + PEDIDO + NF + tipo;

  if Estado = '' then
  begin
    Estado := IfThen(tipo = '90', 'E', 'C');
  end;

  dm.IBQuery1.Close;
  dm.IBQuery1.SQL.Clear;
  dm.IBQuery1.SQL.Add
    ('update or insert into FVMT(item, data, estado) values(:item, :data, :estado) matching(item)');
  dm.IBQuery1.ParamByName('item').AsString := info;
  dm.IBQuery1.ParamByName('data').AsDate := data;
  dm.IBQuery1.ParamByName('estado').AsString := Estado;
  dm.IBQuery1.ExecSQL;
  dm.IBQuery1.Transaction.Commit;
  Result := true;

  // SE ESTA VENDA FOI FEITA PELO PDV ON-LINE, ENTAO OS DADOS DO CUPOM
  // JA ESTAO GRAVADOS NO MOV DE VENDAS, RETORNA SEM GRAVAR

  dm.IBQuery1.Close;
  dm.IBQuery1.SQL.Clear;
  dm.IBQuery1.SQL.Add
    ('update venda set crc = :crc, entrega = ''N'' where nota = :nota and trim(crc) = ''''');
  dm.IBQuery1.ParamByName('crc').AsString := NF + tipo;
  dm.IBQuery1.ParamByName('nota').AsString := PEDIDO;
  dm.IBQuery1.ExecSQL;
  dm.IBQuery1.Transaction.Commit;
end;

function Tfuncoes.NomedoComputador: String;
var
  buffer: Array [0 .. 255] of Char;
  Size: DWord;
begin
  Size := 256;
  if GetComputerName(buffer, Size) then
    Result := buffer
  else
    Result := '';
end;

procedure Tfuncoes.geraPgerais();
begin
  dm.IBQuery1.Close;
  dm.IBQuery1.SQL.Clear;
  dm.IBQuery1.SQL.Add('select * from pgerais order by cod');
  dm.IBQuery1.Open;
  dm.IBQuery1.First;
  ConfParamGerais := tstringList.Create;
  while not dm.IBQuery1.Eof do
  begin
    ConfParamGerais.Add(dm.IBQuery1.FieldByName('valor').AsString);
    dm.IBQuery1.Next;
  end;

  try
    if ((ConfParamGerais[35] = '') or (ConfParamGerais[35] = 'S') or
      (ConfParamGerais[35] = 'N')) then
      ConfParamGerais[35] := '|Equip.|Marca|Modelo|Série|Técnico|Defeito|';
  except
  end;
  dm.IBQuery1.Close;
end;

procedure Tfuncoes.buscaEquivalencia(codEx: String);
var
  acumu, codigos, cb, eq: string;
  fim: integer;
begin
  dm.produtotemp.Close;
  dm.produtotemp.SQL.Clear;
  dm.produtotemp.SQL.Add
    ('select REFORI AS equiva, cod, codbar from produto where cod = :cod');
  dm.produtotemp.ParamByName('cod').AsString := codEx;
  dm.produtotemp.Open;

  acumu := '';
  acumu := '|' + dm.produtotemp.FieldByName('codbar').AsString + '|' +
    dm.produtotemp.FieldByName('equiva').AsString + '|';
  codigos := '|' + dm.produto.FieldByName('cod').AsString + '|';

  // abriu o ClientDataSet que irá varrer no OnCreate deste formulário
  // para não ficar criando toda hora

  fim := cdsEquiva.RecordCount;

  funcoes.informacao(0, fim, 'Localizando Equivalentes...', true, False, 2);

  cdsEquiva.First;
  while not cdsEquiva.Eof do
  begin
    funcoes.informacao(cdsEquiva.RecNo, fim, 'Localizando Equivalentes...',
      False, False, 2);

    cb := IfThen(trim(cdsEquiva.FieldByName('codbar').AsString) <> '',
      '|' + cdsEquiva.FieldByName('equiva').AsString + '|', '');
    // eq := IfThen(trim(cdsEquiva.fieldbyname('equiva').AsString) <> '', '|' + cdsEquiva.fieldbyname('equiva').AsString + '|', '');
    // eq := IfThen(trim(cdsEquiva.fieldbyname('REFORI').AsString) <> '', '|' + cdsEquiva.fieldbyname('REFORI').AsString + '|', '');

    if (funcoes.Contido(cb, acumu)) or (funcoes.Contido(eq, acumu)) then
    begin
      if not funcoes.Contido('|' + cdsEquiva.FieldByName('cod').AsString + '|',
        codigos) then
      begin
        codigos := codigos + cdsEquiva.FieldByName('cod').AsString + '|';
        acumu := acumu + cdsEquiva.FieldByName('codbar').AsString + '|' +
          cdsEquiva.FieldByName('equiva').AsString + '|';
        cdsEquiva.First;
      end;
    end;

    cdsEquiva.Next;
  end;

  funcoes.informacao(0, fim, 'Localizando Equivalentes...', False, true, 2);

  dm.produtotemp.Close;
  dm.produtotemp.SQL.Clear;
  dm.produtotemp.SQL.Add
    ('select  nome as Descricao,quant,p_venda as Preco, refori, codbar, cod from produto where '
    +
    // ' ('+ QuotedStr(codigos) +' containing (''|'' || cast(cod as varchar(9)) || ''|'')) and (cod <> :cod) order by nome');
    ' (' + QuotedStr(codigos) +
    ' containing (''|'' || cast(cod as varchar(9)) || ''|''))  order by nome');
  // dm.produtotemp.ParamByName('cod').AsString  := codEx;
  dm.produtotemp.Open;

  funcoes.FormataCampos(dm.produtotemp, 2, '', 2);

  if dm.produtotemp.IsEmpty then
  begin
    dm.produtotemp.Close;
    ShowMessage('Este produto não há equivalências');
    exit;
  end;

  form25 := tform25.Create(self);
  funcoes.CtrlResize(TForm(form25));
  form25.DBGrid1.DataSource := dm.dsprodtemp;
  form25.ShowModal;
end;

procedure Tfuncoes.buscaEquivalencia1(codEx: String);
var
  acumu, codigos, cb, eq: string;
  fim, ini: integer;
  OK: boolean;
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
      listaProdutos[fim].cod := dm.produtotemp.FieldByName('cod').AsInteger;
      listaProdutos[fim].refori := dm.produtotemp.FieldByName('equiva')
        .AsString;
      listaProdutos[fim].codbar := dm.produtotemp.FieldByName('codbar')
        .AsString;
      dm.produtotemp.Next;
    end;

    inicio1 := 0;
  end;

  dm.produtotemp.Close;
  dm.produtotemp.SQL.Clear;
  dm.produtotemp.SQL.Add
    ('select REFORI AS equiva, cod, codbar from produto where cod = :cod');
  dm.produtotemp.ParamByName('cod').AsString := codEx;
  dm.produtotemp.Open;

  acumu := '';
  if trim(dm.produtotemp.FieldByName('codbar').AsString) <> '' then
    acumu := acumu + '|' + dm.produtotemp.FieldByName('codbar').AsString + '|';
  if trim(dm.produtotemp.FieldByName('equiva').AsString) <> '' then
    acumu := acumu + '|' + dm.produtotemp.FieldByName('equiva').AsString + '|';
  codigos := '|' + dm.produto.FieldByName('cod').AsString + '|';

  // abriu o ClientDataSet que irá varrer no OnCreate deste formulário
  // para não ficar criando toda hora

  fim := listaProdutos.count - 1;

  funcoes.informacao(0, fim, 'Localizando Equivalentes...', true, False, 2);

  // cdsEquiva.First;
  // while not cdsEquiva.Eof do
  fim := listaProdutos.count - 1;
  ini := 0;
  // for ini := 0 to fim do
  while true do
  begin
    if ini = fim then
      break;
    funcoes.informacao(ini, fim, 'Localizando Equivalentes...', False,
      False, 2);
    OK := False;

    if trim(listaProdutos[ini].codbar) <> '' then
    begin
      if Contido('|' + listaProdutos[ini].codbar + '|', acumu) and
        (Contido('|' + IntToStr(listaProdutos[ini].cod) + '|', codigos) = False)
      then
      begin
        codigos := codigos + IntToStr(listaProdutos[ini].cod) + '|';
        acumu := acumu + listaProdutos[ini].codbar + '|' + listaProdutos[ini]
          .refori + '|';
        // ini := -1;
        OK := true;
      end;
    end;

    if trim(listaProdutos[ini].refori) <> '' then
    begin
      if Contido('|' + listaProdutos[ini].refori + '|', acumu) and
        (Contido('|' + IntToStr(listaProdutos[ini].cod) + '|', codigos) = False)
      then
      begin
        codigos := codigos + IntToStr(listaProdutos[ini].cod) + '|';
        acumu := acumu + listaProdutos[ini].codbar + '|' + listaProdutos[ini]
          .refori + '|';
        // ini := -1;
        OK := true;
      end;
    end;

    if OK then
    begin
      ini := -1;
      // ShowMessage(codigos);
    end;
    ini := ini + 1;
  end;

  funcoes.informacao(0, fim, 'Localizando Equivalentes...', False, true, 2);

  dm.produtotemp.Close;
  dm.produtotemp.SQL.Clear;
  if funcoes.buscaParamGeral(94, '1') = '1' then
    dm.produtotemp.SQL.text :=
      ('select refori, nome as Descricao,quant,p_venda as Preco, codbar, cod from produto where ')
  else
    dm.produtotemp.SQL.text :=
      ('select codbar, nome as Descricao,quant,p_venda as Preco, refori, cod from produto where ');

  dm.produtotemp.SQL.text := dm.produtotemp.SQL.text + ' (' + QuotedStr(codigos)
    + ' containing (''|'' || cast(cod as varchar(9)) || ''|''))  order by nome';
  // dm.produtotemp.ParamByName('cod').AsString  := codEx;
  dm.produtotemp.Open;

  funcoes.FormataCampos(dm.produtotemp, 2, '', 2);

  if dm.produtotemp.IsEmpty then
  begin
    dm.produtotemp.Close;
    ShowMessage('Este produto não há equivalências');
    exit;
  end;

  form25 := tform25.Create(self);
  funcoes.CtrlResize(TForm(form25));

  form25.Width := screen.Width - trunc(screen.Width * 0.05);
  form25.Height := screen.Height - trunc(screen.Height * 0.25);
  form25.DBGrid1.DataSource := dm.dsprodtemp;
  form25.ShowModal;
end;

procedure Tfuncoes.abreDataSetMemoriaEquivalencias();
begin
  cdsEquiva := TClientDataSet.Create(self);

  dm.produtotemp.Close;
  dm.produtotemp.SQL.Clear;
  // dm.produtotemp.SQL.Add('select equiva, cod, codbar from produto');
  dm.produtotemp.SQL.Add('select REFORI AS equiva, cod, codbar from produto');
  dm.produtotemp.Open;
  dm.produtotemp.FetchAll;

  DataSetProvider1.dataset := dm.produtotemp;

  cdsEquiva.ProviderName := 'DataSetProvider1';
  cdsEquiva.Open;

  dm.produtotemp.Close;
end;

function formataCurrency(const valor: currency): String;
begin
  Result := FormatCurr('#,###,###0.00', valor);
end;

function Tfuncoes.primeiraLetraMaiuscula(const nome: string): string;
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
  exit;
  // Cria e instancia os objetos usados para criar o atalho

  MeuObjeto := CreateComObject(CLSID_ShellLink);

  MeuSLink := MeuObjeto as IShellLink;

  MeuPFile := MeuObjeto as IPersistFile;

  with MeuSLink do

  begin

    SetArguments(PChar(AParametros));

    SetPath(PChar(ANomeArquivo));

    SetWorkingDirectory(PChar(ExtractFilePath(ADiretorioInicial)));

  end;

  // Pega endereço da pasta Desktop do Windows

  MeuRegistro :=

    TRegIniFile.Create('Software\MicroSoft\Windows\CurrentVersion\Explorer');

  Diretorio := MeuRegistro.ReadString('Shell Folders', 'Desktop', '');

  wNomeArquivo := Diretorio + '\' + ANomedoAtalho + '.lnk';

  // Cria de fato o atalho na tela

  MeuPFile.Save(PWChar(wNomeArquivo), False);

  MeuRegistro.Free;

end;

function Tfuncoes.reorganizaProdutos: boolean;
var
  cod, fim: integer;
  stat: Smallint;
begin
  dm.IBselect.Close;
  dm.IBselect.SQL.Clear;
  dm.IBselect.SQL.Add('select cod, p_compra, p_venda, nome from produto');
  dm.IBselect.Open;
  dm.IBselect.FetchAll;
  fim := dm.IBselect.RecordCount;

  if dm.IBQuery1.Transaction.InTransaction then
    dm.IBQuery1.Transaction.Commit;
  dm.IBQuery1.Transaction.StartTransaction;

  funcoes.informacao(1, 2, 'AGUARDE... ', true, False, 2);
  while not dm.IBselect.Eof do
  begin
    stat := -1;
    cod := dm.IBselect.FieldByName('cod').AsInteger;

    funcoes.informacao(dm.IBselect.RecNo, fim, 'AGUARDE... ', False, False, 2);

    if ((dm.IBselect.FieldByName('nome').AsString = '') or
      (dm.IBselect.FieldByName('nome').IsNull)) then
    begin

      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add('delete from produto where cod = :cod');
      dm.IBQuery1.ParamByName('cod').AsInteger := cod;
      dm.IBQuery1.ExecSQL;
    end
    else if dm.IBselect.FieldByName('p_compra')
      .AsCurrency = dm.IBselect.FieldByName('p_venda').AsCurrency then
    begin
      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add('update produto set p_compra = :vl where cod = :cod');
      dm.IBQuery1.ParamByName('vl').AsCurrency :=
        Arredonda(dm.IBselect.FieldByName('p_venda').AsCurrency / 2, 2);
      dm.IBQuery1.ParamByName('cod').AsInteger := cod;
      dm.IBQuery1.ExecSQL;
    end;

    dm.IBselect.Next;
  end;

  funcoes.informacao(dm.IBselect.RecNo, fim, 'AGUARDE... ', False, true, 2);
  if dm.IBQuery1.Transaction.InTransaction then
    dm.IBQuery1.Transaction.Commit;

  dm.IBselect.Close;
end;

function Tfuncoes.reorganizaClientes: boolean;
var
  cod, fim: integer;
  stat: Smallint;
begin
  dm.IBselect.Close;
  dm.IBselect.SQL.Clear;
  dm.IBselect.SQL.Add('select cod, nome from cliente');
  dm.IBselect.Open;
  dm.IBselect.FetchAll;
  fim := dm.IBselect.RecordCount;

  if dm.IBQuery1.Transaction.InTransaction then
    dm.IBQuery1.Transaction.Commit;
  dm.IBQuery1.Transaction.StartTransaction;

  funcoes.informacao(1, 2, 'AGUARDE... ', true, False, 2);
  while not dm.IBselect.Eof do
  begin
    stat := -1;
    cod := dm.IBselect.FieldByName('cod').AsInteger;

    funcoes.informacao(dm.IBselect.RecNo, fim, 'AGUARDE... ', False, False, 2);

    if ((dm.IBselect.FieldByName('nome').AsString = '') or
      (dm.IBselect.FieldByName('nome').IsNull)) then
    begin
      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add('delete from cliente where cod = :cod');
      dm.IBQuery1.ParamByName('cod').AsInteger := cod;
      dm.IBQuery1.ExecSQL;
    end;

    dm.IBselect.Next;
  end;

  funcoes.informacao(dm.IBselect.RecNo, fim, 'AGUARDE... ', False, true, 2);
  if dm.IBQuery1.Transaction.InTransaction then
    dm.IBQuery1.Transaction.Commit;

  dm.IBselect.Close;
end;

function Tfuncoes.senhaDodia: boolean;
var
  senha, sen: String;
begin
  Result := true;
  senha := funcoes.dialogo('generico', 30, '1234567890' + #8, 30, False, '',
    Application.Title, 'Qual a senha do Dia?', '');

  sen := IntToStr(StrToIntDef(FormatDateTime('dd', form22.dataMov), 1) *
    StrToIntDef(FormatDateTime('mm', form22.dataMov), 1));

  if senha <> sen then
  begin
    ShowMessage('Senha Incorreta');
    Result := False;
  end;
end;

procedure Tfuncoes.somaQTD_produto_ibquery1_sem_commit(cod: integer;
  var qtd, deposito: currency);
begin
  dm.IBQuery1.Close;
  dm.IBQuery1.SQL.Clear;
  dm.IBQuery1.SQL.Add
    ('update produto set quant = quant + :quant, deposito = deposito + :dep where cod = :cod');
  dm.IBQuery1.ParamByName('quant').AsCurrency := qtd;
  // m.IBQuery1.
  dm.IBQuery1.ExecSQL;
end;

FUNCTION Tfuncoes.BUSCA_EST(cod: integer; var QTD_LOJA, QTD_DEP: currency;
  var lista: TItensAcumProd): boolean;
var
  idx: integer;
begin
  idx := lista.Find(cod);
  if idx = -1 then
  begin
    QTD_LOJA := 0;
    QTD_DEP := 0;
  end
  else
  begin
    QTD_LOJA := lista[idx].quant;
    QTD_DEP := lista[idx].DEP;
  end;
end;

FUNCTION Tfuncoes.ATU_ESTOQUE(ACAO: String; var lista: TItensAcumProd;
  cod1: integer = 0): boolean;
var
  qtd, DEP, QTD1, DEP1: currency;
  cod, fimDataSet, Trans, cont: integer;
begin
  Result := False;
  dm.IBselect.Close;
  dm.IBselect.SQL.Clear;
  if cod1 = 0 then
    dm.IBselect.SQL.Add('select cod, quant, deposito from produto')
  else
  begin
    dm.IBselect.SQL.Add
      ('select cod, quant, deposito from produto where cod = :cod');
    dm.IBselect.ParamByName('cod').AsInteger := cod1;
  end;
  dm.IBselect.Open;
  dm.IBselect.FetchAll;

  // DBGrid1.DataSource.DataSet := dm.IBselect;
  // Show;

  fimDataSet := dm.IBselect.RecordCount;
  funcoes.informacao(0, fimDataSet, 'Aguarde, Atualizando estoque...', true,
    False, 5);

  dm.IBQuery1.Close;
  if dm.IBQuery1.Transaction.InTransaction then
    dm.IBQuery1.Transaction.Commit;
  dm.IBQuery1.Transaction.StartTransaction;
  Trans := 100;
  cont := 0;

  while not dm.IBselect.Eof do
  begin
    { if cont >= trans then
      begin
      trans := trans + 100;
      if dm.IBQuery1.Transaction.InTransaction then dm.IBQuery1.Transaction.Commit;
      end; }

    Application.ProcessMessages;
    funcoes.informacao(cont, fimDataSet, 'Aguarde, Atualizando estoque...',
      False, False, 5);
    cod := dm.IBselect.FieldByName('cod').AsInteger;
    funcoes.BUSCA_EST(cod, qtd, DEP, lista);
    dm.IBQuery1.SQL.Clear;

    IF ACAO = 'ACERTA' then
    begin
      dm.IBQuery1.SQL.Add
        ('update produto set SAL = :qtd, SAD = :dep where cod = :cod');

      // qtd := dm.IBselect.FieldByName('quant').AsCurrency    - (qtd);
      qtd := dm.IBselect.FieldByName('quant').AsCurrency - (qtd);
      DEP := dm.IBselect.FieldByName('deposito').AsCurrency - (DEP);

      dm.IBQuery1.ParamByName('qtd').AsCurrency := qtd;
      dm.IBQuery1.ParamByName('dep').AsCurrency := DEP;
      dm.IBQuery1.ParamByName('cod').AsInteger := cod;
      dm.IBQuery1.ExecSQL;
    end
    ELSE IF ACAO = 'RECALCULA' then
    begin
     {if dm.IBselect.FieldByName('cod').AsInteger = 18 then begin

        ShowMessage( 'cod=' + IntToStr(cod) + #13 + 'quant=' + CurrToStr(qtd) + #13 +
        'dep=' + CurrToStr(DEP));
      end;}


      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.text :=
        ('update produto set QUANT = SAL + :qtd, DEPOSITO = SAD + :dep where cod = :cod');
      dm.IBQuery1.ParamByName('qtd').AsCurrency := qtd;
      dm.IBQuery1.ParamByName('dep').AsCurrency := DEP;
      dm.IBQuery1.ParamByName('cod').AsInteger  := dm.IBselect.FieldByName('cod').AsInteger;
      dm.IBQuery1.ExecSQL;
      dm.IBQuery1.Transaction.Commit;
      // if cod = 3530 then ShowMessage('cod=' + IntToStr(cod) + #13 + CurrToStr(qtd));
    end
    ELSE IF ACAO = 'TRANSPORTA' then
    begin
      dm.IBQuery1.SQL.Add
        ('update produto set SAL = SAL + :qtd, SAD = SAD + :dep where cod = :cod');
      dm.IBQuery1.ParamByName('qtd').AsCurrency := qtd;
      dm.IBQuery1.ParamByName('dep').AsCurrency := DEP;
      dm.IBQuery1.ParamByName('cod').AsInteger := cod;
      dm.IBQuery1.ExecSQL;
    end
    ELSE IF ACAO = 'SOMA' then
    begin
      dm.IBQuery1.SQL.Add
        ('update produto set QUANT = QUANT + :qtd, DEPOSITO = DEPOSITO + :dep where cod = :cod');
      dm.IBQuery1.ParamByName('qtd').AsCurrency := qtd;
      dm.IBQuery1.ParamByName('dep').AsCurrency := DEP;
      dm.IBQuery1.ParamByName('cod').AsInteger := cod;
      dm.IBQuery1.ExecSQL;
    end
    ELSE IF ACAO = 'MINIMO' then
    begin
      dm.IBQuery1.SQL.Add
        ('update produto set ESTOQUE = :qtd, SUGESTAO = :dep where cod = :cod');
      dm.IBQuery1.ParamByName('qtd').AsCurrency := qtd;
      dm.IBQuery1.ParamByName('dep').AsCurrency := DEP;
      dm.IBQuery1.ParamByName('cod').AsInteger := cod;
      dm.IBQuery1.ExecSQL;
    end;

    { ELSE IF ACAO = 'MINIMO' then
      begin
      FIELD->ESTOQUE := ARREDONDA((ABS(QTD) / MOVI) * PER_MIN, 2);
      FIELD->SUGESTAO := MAIOR(0, ABS(DEP) - (FIELD->QUANT + FIELD->DEPOSITO) );
      end;
    }

    dm.IBselect.Next;
    cont := cont + 1;
  end;

  if cont = 100 then
  begin
    ShowMessage(IntToStr(cont));
  end;

  if dm.IBQuery1.Transaction.InTransaction then
    dm.IBQuery1.Transaction.Commit;
  funcoes.informacao(cont, fimDataSet, 'Aguarde, Atualizando estoque...',
    False, true, 5);
  Result := true;
end;

function Tfuncoes.verProdutoExisteRetornaNome(const cod: string;
  var nome: String): boolean;
begin
  nome := '**Produto não encontrado**';
  Result := False;

  dm.IBselect.Close;
  dm.IBselect.SQL.Clear;
  dm.IBselect.SQL.Add('select nome, cod from produto where cod = :cod');
  dm.IBselect.ParamByName('cod').AsString := cod;
  dm.IBselect.Open;

  if not dm.IBselect.IsEmpty then
  begin
    nome := dm.IBselect.FieldByName('nome').AsString;
    Result := true;
  end;

  dm.IBselect.Close;
end;

procedure Tfuncoes.SOMA_EST(const cod: integer; const qtd, DEP: currency;
  var lista: TItensAcumProd);
var
  idx: integer;
begin
  idx := lista.Find(cod);
  if idx = -1 then
  begin
    idx := lista.Add(TacumProd.Create);
    lista[idx].cod := cod;
    lista[idx].quant := qtd;
    lista[idx].DEP := DEP;
  end
  else
  begin
    lista[idx].quant := lista[idx].quant + qtd;
    lista[idx].DEP := lista[idx].DEP + DEP;
  end;

  { exit;
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
    end; }
end;

FUNCTION Tfuncoes.LE_ESTOQUE(PULA_REGISTRO, SO_VENDAS: boolean;
  var lista: TItensAcumProd; cod1: integer = 0): String;
var
  campo: tfield;
  ini, fimDataSet, mut, idx, i: integer;
  loja, deposito: currency;
  cdsUnidade: TClientDataSet;
begin
  dm.IBselect.Close;
  dm.IBselect.SQL.Clear;
  dm.IBselect.SQL.Text := 'select o.cod, o.quant from os_itens o left join servico s on (s.COD = o.nota) where ((s.venda is null) or (S.VENDA = 0))';
  dm.IBselect.Open;

  while not dm.IBselect.Eof  do begin
    loja := 0;
    deposito := 0;
    idx := 0;

    if FALSE then
      deposito := -dm.IBselect.FieldByName('quant').AsCurrency
    else
      loja := -dm.IBselect.FieldByName('quant').AsCurrency;

    SOMA_EST(dm.IBselect.FieldByName('cod').AsInteger, loja, deposito, lista);

    dm.IBselect.Next;
  end;


  // Destino 1-Estoque 2-Depósito

  /// INICIO DADOS DE VENDAS ///
  dm.IBselect.Close;
  dm.IBselect.SQL.Clear;
  // dm.IBselect.SQL.Add('select quant, origem, cod from item_venda, venda where cancelado = 0');

  if cod1 = 0 then
    dm.IBselect.SQL.Add
      ('select i.nota,i.quant, i.origem, i.cod from item_venda i, venda v where v.nota = i.nota and v.cancelado = 0')
  else
  begin
    dm.IBselect.SQL.Add
      ('select i.nota,i.quant, i.origem, i.cod from item_venda i, venda v where v.nota = i.nota and v.cancelado = 0 and i.cod = :cod');
    dm.IBselect.ParamByName('cod').AsInteger := cod1;
  end;

  dm.IBselect.Open;
  dm.IBselect.FetchAll;

  fimDataSet := dm.IBselect.RecordCount;
  funcoes.informacao(0, fimDataSet, 'Aguarde, Verificando vendas...', true,
    False, 5);
  while not dm.IBselect.Eof do
  begin
    Application.ProcessMessages;
    funcoes.informacao(dm.IBselect.RecNo, fimDataSet,
      'Aguarde, Verificando vendas...', False, False, 5);
    loja := 0;
    deposito := 0;
    idx := 0;

    if dm.IBselect.FieldByName('origem').AsInteger = 2 then
      deposito := -dm.IBselect.FieldByName('quant').AsCurrency
    else
      loja := -dm.IBselect.FieldByName('quant').AsCurrency;

    SOMA_EST(dm.IBselect.FieldByName('cod').AsInteger, loja, deposito, lista);
    dm.IBselect.Next;
  end;

  //GravarTexto('d:\texto.txt', lista.getText);
   //ShowMessage('venda=' + #13 + lista.getText);

  // loja :=
  funcoes.informacao(dm.IBselect.RecNo, fimDataSet,
    'Aguarde, Verificando vendas...', False, true, 5);
  /// FIM DADOS DE VENDAS ///

  /// INICIO DADOS DE TRANSFERENCIAS ///
  dm.IBselect.Close;
  dm.IBselect.SQL.Clear;

  if cod1 = 0 then
    dm.IBselect.SQL.Add('select quant, destino, cod from TRANSFERENCIA')
  else
  begin
    dm.IBselect.SQL.Add
      ('select quant, destino, cod from TRANSFERENCIA where cod = :cod');
    dm.IBselect.ParamByName('cod').AsInteger := cod1;
  end;
  dm.IBselect.Open;
  dm.IBselect.FetchAll;

  fimDataSet := dm.IBselect.RecordCount;
  funcoes.informacao(0, fimDataSet, 'Aguarde, Verificando transferências...',
    true, False, 5);
  while not dm.IBselect.Eof do
  begin
    funcoes.informacao(dm.IBselect.RecNo, fimDataSet,
      'Aguarde, Verificando transferências...', False, False, 5);

    if dm.IBselect.FieldByName('destino').AsInteger = 2 then
    begin
      deposito := dm.IBselect.FieldByName('quant').AsCurrency;
      loja := -dm.IBselect.FieldByName('quant').AsCurrency;
    end
    else
    begin
      deposito := -dm.IBselect.FieldByName('quant').AsCurrency;
      loja := dm.IBselect.FieldByName('quant').AsCurrency;
    end;

    SOMA_EST(dm.IBselect.FieldByName('cod').AsInteger, loja, deposito, lista);
    dm.IBselect.Next;
  end;

  // ShowMessage('transf=' + #13 + lista.getText);

  funcoes.informacao(dm.IBselect.RecNo, fimDataSet,
    'Aguarde, Verificando transferências...', False, true, 5);
  /// FIM DADOS DE TRANSFERENCIAS ///

  /// INICIO DADOS DE ENTRADAS ///

  { cdsUnidade := TClientDataSet.Create(self);

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
  if cod1 = 0 then
    dm.IBselect.SQL.Add
      ('select quant, destino, cod, UNID2, UNID from ITEM_ENTRADA')
  else
  begin
    dm.IBselect.SQL.Add
      ('select quant, destino, cod, UNID2, UNID from ITEM_ENTRADA where cod = :cod');
    dm.IBselect.ParamByName('cod').AsInteger := cod1;
  end;

  dm.IBselect.Open;
  dm.IBselect.FetchAll;

  fimDataSet := dm.IBselect.RecordCount;
  funcoes.informacao(0, fimDataSet, 'Aguarde, Verificando entradas...', true,
    False, 5);
  while not dm.IBselect.Eof do
  begin
    funcoes.informacao(dm.IBselect.RecNo, fimDataSet,
      'Aguarde, Verificando entradas...', False, False, 5);
    loja := 0;
    deposito := 0;
    // loja := funcoes.verValorUnidade(dm.IBselect.FieldByName('UNID').AsString);

    if dm.IBselect.FieldByName('destino').AsInteger = 2 then
    begin
      deposito := funcoes.verValorUnidade(dm.IBselect.FieldByName('UNID')
        .AsString) * dm.IBselect.FieldByName('quant').AsCurrency;
    end
    else
    begin
      loja := funcoes.verValorUnidade(dm.IBselect.FieldByName('UNID').AsString)
        * dm.IBselect.FieldByName('quant').AsCurrency;
    end;


    SOMA_EST(dm.IBselect.FieldByName('cod').AsInteger, loja, deposito, lista);

    dm.IBselect.Next;
  end;

  //GravarTexto('d:\texto.txt', lista.getText);
  // ShowMessage('entrada=' + #13 + lista.getText);



  // -----------ACERTOS--------------------------------------------------------------------

  dm.IBselect.Close;
  dm.IBselect.SQL.Clear;
  if cod1 = 0 then
    dm.IBselect.SQL.text := ('select codigo as cod,quant, deposito from acerto')
  else
  begin
    dm.IBselect.SQL.text :=
      ('select codigo as cod,quant, deposito from acerto where codigo = :cod');
    dm.IBselect.ParamByName('cod').AsInteger := cod1;
  end;

  dm.IBselect.Open;
  dm.IBselect.FetchAll;

  fimDataSet := dm.IBselect.RecordCount;
  funcoes.informacao(0, fimDataSet, 'Aguarde, Verificando Acertos...', true,
    False, 5);
  while not dm.IBselect.Eof do
  begin
    funcoes.informacao(dm.IBselect.RecNo, fimDataSet,
      'Aguarde, Verificando entradas...', False, False, 5);
    loja := 0;
    deposito := 0;
    // loja := funcoes.verValorUnidade(dm.IBselect.FieldByName('UNID').AsString);

    deposito := dm.IBselect.FieldByName('deposito').AsCurrency;
    loja := dm.IBselect.FieldByName('quant').AsCurrency;

    SOMA_EST(dm.IBselect.FieldByName('cod').AsInteger, loja, deposito, lista);
    dm.IBselect.Next;
  end;

  //GravarTexto('d:\texto.txt', lista.getText);

  // ShowMessage('acerto=' + #13 + lista.getText);

  // -----------ACERTOS--------------------------------------------------------------------
  // ShowMessage(CurrToStr(lista.Items[lista.Find(5086)].quant));
  funcoes.informacao(dm.IBselect.RecNo, fimDataSet,
    'Aguarde, Verificando entradas...', False, true, 5);
  /// FIM DADOS DE ENTRADAS ///

  // cdsUnidade.Free;
end;

procedure Tfuncoes.VER_ESTOQUE(ACAO, mens, MENS1: String; cod: integer = 0);
var
  sim: String;
  lista: TItensAcumProd;
  i: integer;
begin
  sim := 'S';
  if cod = 0 then
  begin
    sim := funcoes.dialogo('generico', 0, 'SN' + #8, 0, true, 'S',
      'Control For Windows', 'Confirma ' + MENS1 +
      'o de Fichas de Estoque ?', '');
  end;
  if ((sim = '*') or (sim = 'N')) then
    exit;

  lista := TItensAcumProd.Create;
  try
    LE_ESTOQUE(False, False, lista, cod);
    // ler os dados de entrada e saida do produto e joga no CDS1
  except
    lista.Free;
    ShowMessage('Ocorreu um erro na leitura dos produtos.');
    exit;
  end;

  // i := lista.Find(31);
  // ShowMessage('cod=3530' + #13 +'quant='+CurrToStr(lista[i].quant) + #13 + 'dep=' + CurrToStr(lista[i].dep));

  if not ATU_ESTOQUE(ACAO, lista, cod) then
  begin
    ShowMessage('Não foi possível atualizar o estoque');
    lista.Free;
    exit;
  end;

  ShowMessage('Estoque ' + MENS1 + 'ado Com Sucesso');
  lista.Free;
end;

function Tfuncoes.buscaConfigNaPastaDoControlW1(Const config_name: String;
  gravaVazio: boolean = False): String;
var
  arq: tstringList;
begin
  if not FileExists(caminhoEXE_com_barra_no_final + buscaNomeConfigDat) then
  begin
    arq := tstringList.Create;
    arq.SaveToFile(caminhoEXE_com_barra_no_final + buscaNomeConfigDat);
    arq.Free;
  end;

  Result := '';
  arq := tstringList.Create;
  arq.LoadFromFile(caminhoEXE_com_barra_no_final + buscaNomeConfigDat);

  if gravaVazio then
  begin
    if not Contido('pastaMGV5_Balanca', arq.text) then
    begin
      arq.Add('pastaMGV5_Balanca=');
      arq.SaveToFile(caminhoEXE_com_barra_no_final + buscaNomeConfigDat);
    end;
  end;

  Result := arq.Values[config_name];
  arq.Free;
end;

function Tfuncoes.GravaConfigNaPastaDoControlW(Const config_name: String;
  const default: string): String;
var
  arq: tstringList;
begin
  if not FileExists(caminhoEXE_com_barra_no_final + buscaNomeConfigDat) then
  begin
    arq := tstringList.Create;
    arq.SaveToFile(caminhoEXE_com_barra_no_final + buscaNomeConfigDat);
    arq.Free;
  end;

  arq := tstringList.Create;
  arq.LoadFromFile(caminhoEXE_com_barra_no_final + buscaNomeConfigDat);
  arq.Values[config_name] := default;

  Result := '';
  Result := arq.Values[config_name];
  arq.SaveToFile(caminhoEXE_com_barra_no_final + buscaNomeConfigDat);
  arq.Free;
end;

function Tfuncoes.VE_PAIS(): String;
begin
  Result := '1058';
  Result := funcoes.localizar('Localizar País', 'Paises', 'cod, nome', 'cod',
    'cod', 'nome', 'nome', False, False, False, '', 300, nil);
end;

function Tfuncoes.CriaDiretorio(const NomeSubDir: string): boolean;
begin
  try
    if not DirectoryExists(NomeSubDir) then
      forceDirectories(NomeSubDir);
  except
  end;
end;

function Tfuncoes.buscaConfigNaPastaDoControlW(Const config_name: String;
  const default: string): String;
var
  arq: tstringList;
begin
  // asume o valor padrão como valor de retorno
  Result := default;
  // se config.dat não encontrado, cria e retorna o valor default
  if not FileExists(caminhoEXE_com_barra_no_final + buscaNomeConfigDat) then
  begin
    arq := tstringList.Create;
    arq.SaveToFile(caminhoEXE_com_barra_no_final + buscaNomeConfigDat);
    arq.Free;
    exit;
  end;

  arq := tstringList.Create;
  arq.LoadFromFile(caminhoEXE_com_barra_no_final + buscaNomeConfigDat);
  // se o valor do parametro é válido, pega esse valor
  if trim(arq.Values[config_name]) <> '' then
    Result := arq.Values[config_name];
  arq.Free;
end;

procedure Tfuncoes.copiaExecutavel();
var
  execServidor, copia, arqTmp: string;
  bat: tstringList;
  ini: integer;
begin
  if ParamCount > 0 then
  begin
    if funcoes.Contido(':', ParamStr(1)) then
      execServidor := copy(ParamStr(1), 1, pos(':', ParamStr(1)) - 1)
    else
      execServidor := ParamStr(1);

    if not funcoes.Contido('\', execServidor) then
      execServidor := '\\' + execServidor;
    execServidor := funcoes.buscaConfigNaPastaDoControlW('compartilhamentoExec',
      execServidor + '\ControlW\ControlW.exe');

    if not FileExists(execServidor) then
    begin
      ShowMessage('O sistema tentou procurar atualização em:' + #13 +
        execServidor + #13 + 'Mas não conseguiu encontrar,' + #13 +
        'Favor, Campartilhe a pasta do ControlW no Servidor' + #13 +
        ' para que a Atualização Automática Funcione.');
      exit;
    end;

    // ShowMessage(execServidor+' = '+DateToStr(funcoes.dataDoArquivo(execServidor)) + #13 +ParamStr(0) +' = ' + DateToStr(funcoes.dataDoArquivo(ParamStr(0))));
    if funcoes.dataDoArquivo(execServidor) > funcoes.dataDoArquivo(ParamStr(0))
    then
    begin
      // if MessageDlg('Deseja Atualizar o Sistema Agora ?', mtConfirmation, [mbYes, mbNo], 1) = idno then exit;

      if FileExists(caminhoEXE_com_barra_no_final + 'ControlW.old') then
        DeleteFile(caminhoEXE_com_barra_no_final + 'ControlW.old');
      CopyFile(PChar(execServidor),
        PChar(caminhoEXE_com_barra_no_final + 'ControlW.old'), true);

      arqTmp := ExtractFileDir(execServidor) + '\';

      bat := funcoes.listaArquivos(arqTmp + '*.dll');

      for ini := 0 to bat.count - 1 do
      begin
        try
          CopyFile(PChar(arqTmp + bat[ini]),
            PChar(caminhoEXE_com_barra_no_final + bat[ini]), true);
        except
        end;
      end;

      bat := funcoes.listaArquivos(arqTmp + '*.csv');

      for ini := 0 to bat.count - 1 do
      begin
        try
          CopyFile(PChar(arqTmp + bat[ini]),
            PChar(caminhoEXE_com_barra_no_final + bat[ini]), true);
        except
        end;
      end;

      { bat := TStringList.Create;
        bat.Add('del ControlW.old1');
        bat.Add('rename ControlW.exe ControlW.old1');
        bat.Add('rename ControlW.old ControlW.exe');
        bat.Add('start ControlW.exe');
        bat.Add('exit');

        bat.SaveToFile(caminhoEXE_com_barra_no_final + 'cp.bat');
        bat.Free; }

      if FileExists(caminhoEXE_com_barra_no_final + 'atualiza.exe') then
      begin
        WinExec(pansichar(AnsiString(caminhoEXE_com_barra_no_final +
          'atualiza.exe -c')), SW_SHOWNORMAL);
        Application.Terminate;
      end;
    end;
  end;
end;

procedure Tfuncoes.mapearLPT1_em_rede();
var
  arq: tstringList;
  tmp, lpt: string;
begin
  tmp := funcoes.buscaConfigNaPastaDoControlW('impress_rede',
    '\\127.0.0.1\generica');

  if ((tmp = '\\127.0.0.1\generica') or (tmp = '')) then
  begin
    exit;
  end;

  lpt := '';

  if funcoes.LerConfig(form22.Pgerais.Values['imp'], 1) = '2' then
    lpt := 'LPT1'
  else if funcoes.LerConfig(form22.Pgerais.Values['imp'], 1) = '3' then
    lpt := 'LPT2';

  if lpt = '' then
    exit;

  arq := tstringList.Create;
  arq.Add('@echo off');
  arq.Add('net use ' + lpt + ' /delete');
  arq.Add('net use ' + lpt + ' ' + tmp + ' /y');
  arq.Add('exit');

  arq.SaveToFile(caminhoEXE_com_barra_no_final + 'impress.bat');
  try
    arq.Free;
  except
  end;

  WinExec(pansichar(caminhoEXE_com_barra_no_final + 'impress.bat'), SW_HIDE);
  // arq.Free;
end;

function Tfuncoes.dadosAdicSped(xml: String): tstringList;
var
  fe: tstringList;
  tmp, chave1: string;
begin
  // para usar esta funcao o form NfeVenda deve estar criado

  chave1 := funcoes.entraXMLeRetornaChave(xml);
  fe := tstringList.Create;
  fe.Add(Le_Nodo('mod', xml)); // 0 tipo
  fe.Add(Le_Nodo('serie', xml)); // 1 serie
  fe.Add(Le_Nodo('CFOP', xml)); // 2 cfop
  fe.Add(Le_Nodo('modFrete', xml)); // 3 tipofrete

  tmp := Le_Nodo('ICMSTot', xml);

  fe.Add(StringReplace(Le_Nodo('vSeg', tmp), '.', ',',
    [rfReplaceAll, rfIgnoreCase])); // 4 totseg
  fe.Add(StringReplace(Le_Nodo('vDesc', tmp), '.', ',',
    [rfReplaceAll, rfIgnoreCase])); // 5 totdesc
  fe.Add(StringReplace(Le_Nodo('vOutro', tmp), '.', ',',
    [rfReplaceAll, rfIgnoreCase])); // 6 desp Acessorias
  fe.Add(StringReplace(Le_Nodo('vPIS', tmp), '.', ',',
    [rfReplaceAll, rfIgnoreCase])); // 7 totpis
  fe.Add(StringReplace(Le_Nodo('vCOFINS', tmp), '.', ',',
    [rfReplaceAll, rfIgnoreCase])); // 8 totcofins
  fe.Add(StringReplace(Le_Nodo('vICMS', tmp), '.', ',',
    [rfReplaceAll, rfIgnoreCase])); // 9 CredICMS
  fe.Add(chave1); // 10 chave
  fe.Add(StringReplace(Le_Nodo('vFrete', tmp), '.', ',',
    [rfReplaceAll, rfIgnoreCase])); // 11 totfrete
  fe.Add(Le_Nodo('nNF', xml)); // 12 NOTA
  fe.Add(StringReplace(Le_Nodo('vST', tmp), '.', ',',
    [rfReplaceAll, rfIgnoreCase])); // 13 Valor ICMS ST
  fe.Add(StringReplace(Le_Nodo('vICMSDeson', tmp), '.', ',',
    [rfReplaceAll, rfIgnoreCase])); // 14 Valor ICMS Desonerado
  fe.Add(StringReplace(Le_Nodo('vIPI', tmp), '.', ',',
    [rfReplaceAll, rfIgnoreCase])); // 15 Valor ICMS Desonerado
  Result := fe;
end;

procedure Tfuncoes.copiaXMLEntrada(const xml, chave: String);
var
  acc: integer;
begin
  if not DirectoryExists(caminhoEXE_com_barra_no_final + 'NFE') then
  begin
    forceDirectories(caminhoEXE_com_barra_no_final + 'NFE');
  end;
  if not DirectoryExists(caminhoEXE_com_barra_no_final + 'NFE\ENT') then
  begin
    forceDirectories(caminhoEXE_com_barra_no_final + 'NFE\ENT');
  end;

  CopyFile(PChar(xml), PChar(caminhoEXE_com_barra_no_final + 'NFE\ENT\' + chave
    + '-nfe.xml'), true);

  acc := 0;
  while true do
  begin
    if acc > 20 then
      break;
    if DeleteFile(xml) then
      break;
    if not FileExists(xml) then
      break;
    acc := acc + 1;
    sleep(300);
  end;
end;

function Tfuncoes.formataCPF(const cpf: String): String;
begin
  Result := '';
  Result := copy(cpf, 1, 3) + '.' + copy(cpf, 4, 3) + '.' + copy(cpf, 7, 3) +
    '-' + copy(cpf, 10, 2);
end;

function Tfuncoes.formataCNPJ(Const cnpj: String): String;
begin
  Result := '';
  Result := copy(cnpj, 1, 2) + '.' + copy(cnpj, 3, 3) + '.' + copy(cnpj, 6, 3) +
    '/' + copy(cnpj, 9, 4) + '-' + copy(cnpj, 13, 2);
end;

function Tfuncoes.verFornecedorStringList(xml: string;
  consultaCadastro: boolean = False): tstringList;
var
  tmp: tstringList;
  t1, cnpj, tipo: string;
begin
  tmp := tstringList.Create;
  if consultaCadastro = False then
    t1 := NfeVenda.Le_Nodo('emit', xml)
  else
    t1 := NfeVenda.Le_Nodo('infCad', xml);

  // '99.999.999/9999-99'
  cnpj := IfThen(funcoes.Contido('<CNPJ>', xml), Le_Nodo('CNPJ', t1),
    Le_Nodo('CPF', t1));
  if length(cnpj) = 14 then
  begin
    cnpj := formataCNPJ(cnpj);
    tipo := '1';
  end
  // else if Length(CPF_CNPJ) = 11 then cnpj := formataCNPJ(CPF_CNPJ)
  else
  begin
    cnpj := formataCNPJ(cnpj);
    tipo := '2';
  end;

  tmp.Add(cnpj); // 0
  tmp.Add(NfeVenda.Le_Nodo('xNome', t1)); // 1
  tmp.Add(NfeVenda.Le_Nodo('xFant', t1)); // 2
  tmp.Add(NfeVenda.Le_Nodo('xLgr', t1) + ' ' + NfeVenda.Le_Nodo('nro', t1));
  // 3
  tmp.Add(NfeVenda.Le_Nodo('xBairro', t1)); // 4
  tmp.Add(NfeVenda.Le_Nodo('cMun', t1)); // 5
  tmp.Add(NfeVenda.Le_Nodo('xMun', t1)); // 6
  tmp.Add(NfeVenda.Le_Nodo('UF', t1)); // 7
  tmp.Add(NfeVenda.Le_Nodo('CEP', t1)); // 8
  tmp.Add(NfeVenda.Le_Nodo('cPais', t1)); // 9
  tmp.Add(NfeVenda.Le_Nodo('xPais', t1)); // 10
  tmp.Add(NfeVenda.Le_Nodo('fone', t1)); // 11
  tmp.Add(NfeVenda.Le_Nodo('IE', t1)); // 12
  tmp.Add(NfeVenda.Le_Nodo('CRT', t1)); // 13
  tmp.Add(tipo); // 14
  Result := tmp;
end;

function Tfuncoes.importaXMLnaEntrada: boolean;
var
  camArq, erro, nota, total, chave, forn, tmptot: String;
  dial: TOpenDialog;
  xml: tstringList;
  item: integer;
  txt1, t2, t3: String;
  item1: Ptr_nota;
  lista: Tlist;
  ini, fim: integer;
begin
  dial := TOpenDialog.Create(self);
  dial.Filter := 'Arquivo NFE|*.xml';;
  dial.Execute;
  camArq := '';
  camArq := dial.fileName;
  if trim(camArq) = '' then
    exit;

  xml := tstringList.Create;

  dm.ACBrNFe.NotasFiscais.LoadFromFile(camArq);
  try
    xml.LoadFromFile(camArq);
  except
    on e: exception do
    begin
      ShowMessage('Ocorreu um Erro:' + #13 + e.Message + #13 +
        'Tente Novamente.');
      exit;
    end;
  end;

  item := 1;
  t2 := xml.text;
  lista := Tlist.Create;
  erro := '';

  chave := NfeVenda.entraXMLeRetornaChave(t2);
  nota := NfeVenda.Le_Nodo('nNF', t2);
  forn := NfeVenda.Le_Nodo('emit', t2);
  forn := copy(NfeVenda.Le_Nodo('xNome', forn), 1, 40);
  tmptot := NfeVenda.Le_Nodo('ICMSTot', t2);

  total := StringReplace(NfeVenda.Le_Nodo('vNF', t2), '.', ',',
    [rfReplaceAll, rfIgnoreCase]);

  while true do
  begin
    txt1 := '';
    txt1 := NfeVenda.Le_Nodo('det nItem="' + IntToStr(item) + '"', t2);

    if txt1 = '' then
      break; // irá vir vazio quando a funcao nao retorna nada

    // inicio da leitura dos itens do xml
    item1 := new(Ptr_nota);
    item1.cod := StrToIntDef(StrNum(NfeVenda.Le_Nodo('cProd', txt1)), 0);
    item1.nome := NfeVenda.Le_Nodo('xProd', txt1);
    item1.quant := StrToCurrDef(StringReplace(NfeVenda.Le_Nodo('qCom', txt1),
      '.', ',', [rfReplaceAll, rfIgnoreCase]), 0);
    item1.preco := StrToCurrDef(StringReplace(NfeVenda.Le_Nodo('vUnTrib', txt1),
      '.', ',', [rfReplaceAll, rfIgnoreCase]), 0);
    item1.preco1 := item1.preco;
    item1.qtd := item1.quant;
    item1.total := StrToCurrDef(StringReplace(NfeVenda.Le_Nodo('vProd', txt1),
      '.', ',', [rfReplaceAll, rfIgnoreCase]), 0);
    item1.codbar := NfeVenda.Le_Nodo('cEAN', txt1);
    item1.unid := NfeVenda.Le_Nodo('uTrib', txt1);

    dm.IBselect.Close;
    dm.IBselect.SQL.Clear;
    dm.IBselect.SQL.Add('select cod, unid2 from produto where cod = :cod');
    dm.IBselect.ParamByName('cod').AsInteger := item1.cod;
    dm.IBselect.Open;

    if trim(dm.IBselect.FieldByName('unid2').AsString) <> '' then
      item1.unid := dm.IBselect.FieldByName('unid2').AsString;
    item1.nota := NfeVenda.Le_Nodo('nNF', t2);;
    item1.totNota := StrToCurrDef(StringReplace(NfeVenda.Le_Nodo('vNF', t2),
      '.', ',', [rfReplaceAll, rfIgnoreCase]), 0);
    dm.IBselect.Close;

    lista.Add(item1);
    // fim da leitura dos itens do xml

    item := item + 1;
  end;

  form48 := tform48.Create(self);
  form48.caminhoXML := camArq;

  form48.fornec := verFornecedorStringList(t2);
  // funcao que popula um stringlist com
  // os dados do fornecedor  da nota
  form48.caption := 'Verificação de Itens de Entrada';

  form48.ClientDataSet1.FieldDefs.Clear;

  form48.ClientDataSet1.FieldDefs.Add('CODBAR', ftString, 15);
  form48.ClientDataSet1.FieldDefs.Add('DESCRICAO_NFE', ftString, 40);
  form48.ClientDataSet1.FieldDefs.Add('DESCRICAO_ESTOQUE', ftString, 40);
  form48.ClientDataSet1.FieldDefs.Add('CODIGO', ftInteger);
  form48.ClientDataSet1.FieldDefs.Add('mu', ftCurrency);

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

  // form48.DataSource1.DataSet := form48.ClientDataSet1;
  form48.DBGrid1.DataSource := form48.DataSource1;
  // form48.DBGrid1.DataSource.DataSet := form48.ClientDataSet1;

  form48.ClientDataSet1.CreateDataSet;
  form48.ClientDataSet1.LogChanges := False;
  form48.ClientDataSet1.FieldByName('PRECO1').Visible := False;
  form48.ClientDataSet1.FieldByName('QTD').Visible := False;
  form48.ClientDataSet1.FieldByName('totnota').Visible := False;
  form48.ClientDataSet1.FieldByName('nota').Visible := False;
  // form48.ClientDataSet1.FieldByName('mu').Visible := false;
  form48.ClientDataSet1.FieldByName('unidade1').Visible := False;

  TCurrencyField(form48.ClientDataSet1.FieldByName('PRECO')).currency := False;
  TCurrencyField(form48.ClientDataSet1.FieldByName('QUANT')).currency := False;
  TCurrencyField(form48.ClientDataSet1.FieldByName('TOTAL')).currency := False;
  TCurrencyField(form48.ClientDataSet1.FieldByName('QUANT')).DisplayFormat :=
    '#,###,###0.00';
  TCurrencyField(form48.ClientDataSet1.FieldByName('PRECO')).DisplayFormat :=
    '#,###,###0.00';
  TCurrencyField(form48.ClientDataSet1.FieldByName('TOTAL')).DisplayFormat :=
    '#,###,###0.00';
  // form33.campobusca := 'DESCRICAO';

  for ini := 0 to lista.count - 1 do
  begin
    item1 := lista.Items[ini];
    form48.ClientDataSet1.Open;
    form48.ClientDataSet1.Insert;
    // form48.ClientDataSet1.fieldbyname('CODIGO').AsInteger := item1.cod;
    form48.ClientDataSet1.FieldByName('DESCRICAO_NFE').AsString := item1.nome;
    form48.ClientDataSet1.FieldByName('UNIDADE').AsString := item1.unid;
    form48.ClientDataSet1.FieldByName('UNIDADE1').AsString := item1.unid;
    form48.ClientDataSet1.FieldByName('CODBAR').AsString := item1.codbar;
    form48.ClientDataSet1.FieldByName('nota').AsString := item1.nota;
    form48.ClientDataSet1.FieldByName('QUANT').AsCurrency := item1.quant;
    form48.ClientDataSet1.FieldByName('PRECO').AsCurrency := item1.preco;
    form48.ClientDataSet1.FieldByName('TOTAL').AsCurrency := item1.total;
    form48.ClientDataSet1.FieldByName('TOTnota').AsCurrency := item1.totNota;
    form48.ClientDataSet1.FieldByName('QTD').AsCurrency := item1.qtd;
    form48.ClientDataSet1.FieldByName('PRECO1').AsCurrency := item1.preco1;

    dm.IBselect.Close;
    dm.IBselect.SQL.Clear;
    dm.IBselect.SQL.Add
      ('select cod, nome, unid2 from produto where nome = :cod');
    dm.IBselect.ParamByName('cod').AsString := copy(item1.nome, 1, 40);
    dm.IBselect.Open;

    if dm.IBselect.IsEmpty then
    begin
      dm.IBselect.Close;
      dm.IBselect.SQL.Clear;
      dm.IBselect.SQL.Add
        ('select p.cod, p.nome, p.unid2 from produto p left join codbarras c on (c.cod = p.cod) where (p.codbar = '
        + QuotedStr(item1.codbar) + ') or (c.codbar = ' +
        QuotedStr(item1.codbar) + ')');
      // dm.IBselect.ParamByName('cod').AsString := item1.codbar;
      dm.IBselect.Open;
    end;

    if not dm.IBselect.IsEmpty then
    begin
      form48.ClientDataSet1.FieldByName('ok').AsString := 'X';
      form48.ClientDataSet1.FieldByName('codigo').AsString :=
        dm.IBselect.FieldByName('cod').AsString;
      form48.ClientDataSet1.FieldByName('descricao_estoque').AsString :=
        dm.IBselect.FieldByName('nome').AsString;

      if dm.IBselect.FieldByName('unid2').AsString <> '' then begin
        form48.ClientDataSet1.FieldByName('unidade').AsString :=
          dm.IBselect.FieldByName('unid2').AsString;
        { dm.IBselect.Close;
          dm.IBselect.SQL.Clear;
          dm.IBselect.SQL.Add('select multiplo from unid where nome = :cod');
          dm.IBselect.ParamByName('cod').AsString := form48.ClientDataSet1.fieldbyname('unidade').AsString;
          dm.IBselect.Open;
          form48.ClientDataSet1.fieldbyname('unidade').AsString := dm.IBselect.fieldbyname('unid2').AsString;
        } end;

    end
    else
      erro := 'Produto: ' + item1.nome + ' não encontrado;';

    dm.IBselect.Close;
    dm.IBselect.SQL.Clear;
    dm.IBselect.SQL.Add('select * from unid where nome = :cod');
    dm.IBselect.ParamByName('cod').AsString := form48.ClientDataSet1.FieldByName
      ('unidade').AsString;
    dm.IBselect.Open;

    if not dm.IBselect.IsEmpty then
    begin
      form48.ClientDataSet1.FieldByName('mu').AsString :=
        dm.IBselect.FieldByName('multiplo').AsString;
    end;

    dm.IBselect.Close;
    form48.ClientDataSet1.Post;

  end;

  form48.xml := xml;
  form48.erro := erro;
  form48.chave := chave;
  form48.nota := nota;

  form48.Label5.caption := 'Nota: ' + nota;
  form48.Label6.caption := 'Total R$: ' + FormatCurr('#,###,###0.00',
    form48.ClientDataSet1.FieldByName('TOTnota').AsCurrency);
  form48.Label7.caption := 'Fornecedor: ' + forn;
  form48.ShowModal;
  xml.Free;
  form48.ClientDataSet1.Free;
  form48.Free;
  lista.Free;
end;

function Tfuncoes.importaXMLnaEntrada1: boolean;
var
  camArq, erro, nota, total, chave, forn, tmptot: String;
  dial: TOpenDialog;
  xml: tstringList;
  item: integer;
  txt1, t2, t3, cnpjFOR, sim, axx, ICMS, PIS: String;
  item1: Ptr_nota;
  lista: Tlist;
  ini, fim, cont: integer;
  dataEmissao: TDate;
  TOTvICMSDeson_Produtos: currency;
begin
  { dial := TOpenDialog.Create(self);
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
    if buscaXMl(camArq) = False then
      exit;
    if funcoes.retornobusca = '*' then
      exit;
    if funcoes.retornobusca <> '' then
      break;
  end;

  camArq := camArq + funcoes.retornobusca;
  try
    xml := tstringList.Create;
    xml.LoadFromFile(camArq);
  except
    on e: exception do
    begin
      ShowMessage('Ocorreu um Erro:' + #13 + e.Message + #13 +
        'Tente Novamente.');
      exit;
    end;
  end;

  item := 1;
  t2 := xml.text;
  // xml.Free;

  lista := Tlist.Create;
  erro := '';

  chave := NfeVenda.entraXMLeRetornaChave(t2);
  nota := Le_Nodo('nNF', t2);
  forn := Le_Nodo('emit', t2);

  axx := Le_Nodo('dEmi', t2);
  if axx = '' then
    axx := LeftStr(Le_Nodo('dhEmi', t2), 10);
  axx := funcoes.dataInglesToBrasil(axx);

  dataEmissao := StrToDateTime(axx);

  cnpjFOR := IfThen(funcoes.Contido('CNPJ', forn), Le_Nodo('CNPJ', forn),
    Le_Nodo('CPF', forn));
  forn := copy(NfeVenda.Le_Nodo('xNome', forn), 1, 40);

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
  } tmptot := NfeVenda.Le_Nodo('ICMSTot', t2);

  total := StringReplace(NfeVenda.Le_Nodo('vNF', t2), '.', ',',
    [rfReplaceAll, rfIgnoreCase]);

  funcoes.Mensagem(Application.Title, 'Aguarde, Lendo XML...', 15, 'Arial',
    False, 0, clBlack);
  Application.ProcessMessages;

  TOTvICMSDeson_Produtos := 0;

  cont := 0;
  try
    while true do
    begin
      Application.ProcessMessages;
      txt1 := '';
      txt1 := NfeVenda.Le_Nodo('det nItem="' + IntToStr(item) + '"', t2);

      if cont > 200 then
        break;
      if txt1 = '' then
        cont := cont + 1 // irá vir vazio quando a funcao nao retorna nada
      else
        cont := 0;

      if txt1 <> '' then
      begin
        cont := 0;
        // inicio da leitura dos itens do xml

        ICMS    := Le_Nodo('ICMS', txt1);
        PIS     := Le_Nodo('PIS', txt1);

        item1 := new(Ptr_nota);

        item1.ICMSOSN     := '';
        item1.CSTICMS := copy(Le_Nodo('CST', ICMS), 1, 2);
        item1.CSTPIS  := copy(Le_Nodo('CST', PIS), 1, 2);
        if Contido('CSOSN', PIS) then begin
          item1.ICMSOSN := Le_Nodo('CSOSN', PIS);
        end;

        item1.numProd := item;
        item1.cod := StrToIntDef(StrNum(NfeVenda.Le_Nodo('cProd', txt1)), 0);
        item1.codigoFornecedor := StrNum(NfeVenda.Le_Nodo('cProd', txt1));
        item1.nome := NfeVenda.Le_Nodo('xProd', txt1);
        item1.nome := UpperCase(item1.nome);
        item1.quant := StrToCurrDef(StringReplace(NfeVenda.Le_Nodo('qCom',
          txt1), '.', ',', [rfReplaceAll, rfIgnoreCase]), 0);
        item1.preco := StrToCurrDef(StringReplace(NfeVenda.Le_Nodo('vUnCom',
          txt1), '.', ',', [rfReplaceAll, rfIgnoreCase]), 0);
        item1.preco1 := StrToCurrDef(StringReplace(NfeVenda.Le_Nodo('vDesc',
          txt1), '.', ',', [rfReplaceAll, rfIgnoreCase]), 0);
        item1.qtd := item1.quant;
        item1.total := StrToCurrDef(StringReplace(NfeVenda.Le_Nodo('vProd',
          txt1), '.', ',', [rfReplaceAll, rfIgnoreCase]), 0);
        // item1.total  := item1.total - item1.preco1;
        item1.codbar := NfeVenda.Le_Nodo('cEAN', txt1);
        item1.unid := NfeVenda.Le_Nodo('uTrib', txt1);
        item1.p_icms := StrToCurrDef(StringReplace(NfeVenda.Le_Nodo('pICMS',
          txt1), '.', ',', [rfReplaceAll, rfIgnoreCase]), 0);
        item1.NCM := NfeVenda.Le_Nodo('NCM', txt1);
        item1.vDeson :=
          StrToCurrDef(StringReplace(NfeVenda.Le_Nodo('vICMSDeson', txt1), '.',
          ',', [rfReplaceAll, rfIgnoreCase]), 0);

        { TOTvICMSDeson_Produtos := TOTvICMSDeson_Produtos +
          StrToCurrDef(StringReplace(NfeVenda.Le_Nodo('vICMSDeson',
          txt1), '.', ',', [rfReplaceAll, rfIgnoreCase]), 0);

          ShowMessage(IntToStr(item1.cod)+' TOTdesonerado=' + CurrToStr(TOTvICMSDeson_Produtos) + #13 + 'desonerado=' + CurrToStr(StrToCurrDef(StringReplace(NfeVenda.Le_Nodo('vICMSDeson',
          txt1), '.', ',', [rfReplaceAll, rfIgnoreCase]), 0))); }

        dm.IBselect.Close;
        dm.IBselect.SQL.Clear;
        dm.IBselect.SQL.Add('select cod, unid2 from produto where cod = :cod');
        dm.IBselect.ParamByName('cod').AsInteger := item1.cod;
        dm.IBselect.Open;

        if trim(dm.IBselect.FieldByName('unid2').AsString) <> '' then
          item1.unid := dm.IBselect.FieldByName('unid2').AsString;
        item1.nota := NfeVenda.Le_Nodo('nNF', t2);;
        item1.totNota := StrToCurrDef(StringReplace(NfeVenda.Le_Nodo('vNF', t2),
          '.', ',', [rfReplaceAll, rfIgnoreCase]), 0);
        dm.IBselect.Close;

        lista.Add(item1);
      end;
      // fim da leitura dos itens do xml

      item := item + 1;
    end;

    pergunta1.Visible := False;
  except
    pergunta1.Visible := False;
  end;

  form48 := tform48.Create(self);
  form48.caminhoXML := camArq;

  form48.fornec := verFornecedorStringList(t2);
  form48.TOTvICMSDeson_Produtos := TOTvICMSDeson_Produtos;
  // funcao que popula um stringlist com
  // os dados do fornecedor  da nota
  form48.insereFornec;
  // aqui inseriu o fornecedor no banco de dados

  form48.caption := 'Verificação de Itens de Entrada';

  form48.ClientDataSet1.FieldDefs.Clear;

  if buscaParamGeral(5, 'N') = 'S' then
  begin
    // form48.ClientDataSet1.FieldDefs.Add('DESONERADO', ftCurrency);
    form48.ClientDataSet1.FieldDefs.Add('CODBAR_ATUAL', ftString, 15);
    form48.ClientDataSet1.FieldDefs.Add('CODIGO', ftInteger);
    form48.ClientDataSet1.FieldDefs.Add('DESCRICAO_FORNECEDOR', ftString, 40);
    form48.ClientDataSet1.FieldDefs.Add('DESCRICAO_ATUAL', ftString, 40);
    form48.ClientDataSet1.FieldDefs.Add('PRECO_NFE', ftCurrency);
    form48.ClientDataSet1.FieldDefs.Add('LUCRO', ftCurrency);
    form48.ClientDataSet1.FieldDefs.Add('PRECO_NOVO', ftCurrency);
    form48.ClientDataSet1.FieldDefs.Add('PRECO_COMPRA', ftCurrency);
    form48.ClientDataSet1.FieldDefs.Add('PRECO_ATUAL', ftCurrency);
    form48.ClientDataSet1.FieldDefs.Add('QUANTIDADE_NFE', ftCurrency);
    form48.ClientDataSet1.FieldDefs.Add('QUANTIDADE_ENT', ftCurrency);
    form48.ClientDataSet1.FieldDefs.Add('CRED_ICMS', ftCurrency);
    form48.ClientDataSet1.FieldDefs.Add('UNID_NFE', ftString, 8);
    form48.ClientDataSet1.FieldDefs.Add('UNID_ENTRADA', ftString, 8);
    form48.ClientDataSet1.FieldDefs.Add('UNID_VENDA', ftString, 8);
    form48.ClientDataSet1.FieldDefs.Add('ALIQ', ftString, 8);
    form48.ClientDataSet1.FieldDefs.Add('PIS', ftString, 8);
    form48.ClientDataSet1.FieldDefs.Add('COD_ISPIS', ftString, 8);
    form48.ClientDataSet1.FieldDefs.Add('CODBAR', ftString, 15);
    form48.ClientDataSet1.FieldDefs.Add('REFORI', ftString, 15);
    form48.ClientDataSet1.FieldDefs.Add('REF_NFE', ftString, 25);
    form48.ClientDataSet1.FieldDefs.Add('NCM', ftString, 20);
    form48.ClientDataSet1.FieldDefs.Add('mu', ftInteger);
    form48.ClientDataSet1.FieldDefs.Add('TOTAL', ftCurrency);
    form48.ClientDataSet1.FieldDefs.Add('nota', ftString, 20);
    form48.ClientDataSet1.FieldDefs.Add('totnota', ftCurrency);
    form48.ClientDataSet1.FieldDefs.Add('OK', ftString, 1);
    form48.ClientDataSet1.FieldDefs.Add('data', ftDate);
    form48.ClientDataSet1.FieldDefs.Add('CONT', ftInteger);
  end
  else
  begin
    form48.ClientDataSet1.FieldDefs.Add('CONT', ftInteger);
    form48.ClientDataSet1.FieldDefs.Add('CODIGO', ftInteger);
    form48.ClientDataSet1.FieldDefs.Add('DESCRICAO_FORNECEDOR', ftString, 40);
    form48.ClientDataSet1.FieldDefs.Add('DESCRICAO_ATUAL', ftString, 40);
    form48.ClientDataSet1.FieldDefs.Add('PRECO_NFE', ftCurrency);
    form48.ClientDataSet1.FieldDefs.Add('LUCRO', ftCurrency);
    form48.ClientDataSet1.FieldDefs.Add('PRECO_NOVO', ftCurrency);
    form48.ClientDataSet1.FieldDefs.Add('PRECO_COMPRA', ftCurrency);
    form48.ClientDataSet1.FieldDefs.Add('PRECO_ATUAL', ftCurrency);
    form48.ClientDataSet1.FieldDefs.Add('QUANTIDADE_NFE', ftCurrency);
    form48.ClientDataSet1.FieldDefs.Add('QUANTIDADE_ENT', ftCurrency);
    form48.ClientDataSet1.FieldDefs.Add('CRED_ICMS', ftCurrency);
    form48.ClientDataSet1.FieldDefs.Add('UNID_NFE', ftString, 8);
    form48.ClientDataSet1.FieldDefs.Add('UNID_ENTRADA', ftString, 8);
    form48.ClientDataSet1.FieldDefs.Add('UNID_VENDA', ftString, 8);
    form48.ClientDataSet1.FieldDefs.Add('ALIQ', ftString, 8);
    form48.ClientDataSet1.FieldDefs.Add('PIS', ftString, 8);
    form48.ClientDataSet1.FieldDefs.Add('COD_ISPIS', ftString, 8);
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
  end;

  form48.DBGrid1.DataSource := form48.DataSource1;

  form48.ClientDataSet1.CreateDataSet;
  FormataCampos(TIBQuery(form48.ClientDataSet1), 3, '', 3);

  TCurrencyField(form48.ClientDataSet1.FieldByName('PRECO_NFE')).DisplayFormat
    := '###,##0.000';
  tfield(form48.ClientDataSet1.FieldByName('CONT')).DisplayLabel :=
    'Num. Produto';
  tfield(form48.ClientDataSet1.FieldByName('CODIGO')).DisplayLabel := 'Código';
  tfield(form48.ClientDataSet1.FieldByName('DESCRICAO_FORNECEDOR')).DisplayLabel
    := 'Descrição do Fornecedor(F)';
  tfield(form48.ClientDataSet1.FieldByName('DESCRICAO_ATUAL')).DisplayLabel :=
    'Descrição do Produto Atual';
  tfield(form48.ClientDataSet1.FieldByName('PRECO_NFE')).DisplayLabel :=
    'Preço(F)';
  tfield(form48.ClientDataSet1.FieldByName('LUCRO')).DisplayLabel := 'Lucro';
  tfield(form48.ClientDataSet1.FieldByName('PRECO_NOVO')).DisplayLabel :=
    'Preço Novo';
  tfield(form48.ClientDataSet1.FieldByName('PRECO_COMPRA')).DisplayLabel :=
    'Preço Compra';
  tfield(form48.ClientDataSet1.FieldByName('PRECO_ATUAL')).DisplayLabel :=
    'Preço Atual';
  tfield(form48.ClientDataSet1.FieldByName('QUANTIDADE_NFE')).DisplayLabel :=
    'Quantidade';
  tfield(form48.ClientDataSet1.FieldByName('UNID_NFE')).DisplayLabel :=
    'Unid(F)';
  tfield(form48.ClientDataSet1.FieldByName('UNID_ENTRADA')).DisplayLabel :=
    'Unid. Entrada';
  tfield(form48.ClientDataSet1.FieldByName('UNID_VENDA')).DisplayLabel :=
    'Unid. Venda';
  tfield(form48.ClientDataSet1.FieldByName('ALIQ')).DisplayLabel := 'Aliq. ICMS';
  tfield(form48.ClientDataSet1.FieldByName('COD_ISPIS')).DisplayLabel := 'Cód. Natureza PIS';

  tfield(form48.ClientDataSet1.FieldByName('CODBAR')).DisplayLabel :=
    'Cod. barras(F)';
  tfield(form48.ClientDataSet1.FieldByName('CODBAR_ATUAL')).DisplayLabel :=
    'Cód. Barras Atual';
  tfield(form48.ClientDataSet1.FieldByName('REFORI')).DisplayLabel :=
    'Ref. Original';
  tfield(form48.ClientDataSet1.FieldByName('REF_NFE')).DisplayLabel :=
    'Ref. Fornecedor(F)';
  tfield(form48.ClientDataSet1.FieldByName('NCM')).DisplayLabel := 'NCM';

  TOTvICMSDeson_Produtos := 0;
  fim := lista.count - 1;
  funcoes.informacao(0, fim, 'Aguarde, Lendo XML...', true, False, 5);
  for ini := 0 to lista.count - 1 do
  begin
    funcoes.informacao(ini, fim, 'Aguarde, Lendo XML...', False, False, 5);
    item1 := lista.Items[ini];
    form48.ClientDataSet1.Insert;
    form48.ClientDataSet1.FieldByName('CONT').AsInteger := item1.numProd;
    form48.ClientDataSet1.FieldByName('data').AsDateTime := dataEmissao;
    form48.ClientDataSet1.FieldByName('DESCRICAO_FORNECEDOR').AsString :=
      item1.nome;

    form48.ClientDataSet1.FieldByName('ALIQ').AsString := buscaAliqICMSxml(item1.CSTICMS, item1.ICMSOSN);
    form48.ClientDataSet1.FieldByName('PIS').AsString  := buscaAliqPISxml(item1.CSTPIS, item1.CSTPIS);


    TOTvICMSDeson_Produtos := TOTvICMSDeson_Produtos + item1.vDeson;

    // form48.ClientDataSet1.FieldByName('DESONERADO').AsCurrency := item1.vDeson;
    form48.ClientDataSet1.FieldByName('UNID_NFE').AsString := item1.unid;
    form48.ClientDataSet1.FieldByName('UNID_ENTRADA').AsString := '';
    form48.ClientDataSet1.FieldByName('UNID_VENDA').AsString := '';
    form48.ClientDataSet1.FieldByName('CODBAR').AsString := item1.codbar;
    form48.ClientDataSet1.FieldByName('nota').AsString := item1.nota;
    form48.ClientDataSet1.FieldByName('QUANTIDADE_NFE').AsCurrency :=
      item1.quant;
    form48.ClientDataSet1.FieldByName('QUANTIDADE_ENT').AsCurrency :=
      item1.quant;
    form48.ClientDataSet1.FieldByName('PRECO_NFE').AsCurrency := item1.preco;
    form48.ClientDataSet1.FieldByName('PRECO_COMPRA').AsCurrency := item1.preco;
    form48.ClientDataSet1.FieldByName('TOTAL').AsCurrency := item1.total;
    form48.ClientDataSet1.FieldByName('TOTnota').AsCurrency := item1.totNota;
    form48.ClientDataSet1.FieldByName('NCM').AsString := item1.NCM;
    // form48.ClientDataSet1.FieldByName('CRED_ICMS').AsCurrency := item1.p_icms;
    form48.ClientDataSet1.FieldByName('CRED_ICMS').AsCurrency := 0;
    // form48.ClientDataSet1.FieldByName('REF_NFE').AsString       := IntToStr(item1.cod) + '|' + item1.codbar;
    form48.ClientDataSet1.FieldByName('REF_NFE').AsString :=
      item1.codigoFornecedor + '|' + form48.fornecedor;

    dm.IBselect.Close;
    dm.IBselect.SQL.Clear;
    dm.IBselect.SQL.Add
      ('select cod, nome, unid2, aliquota, unid, p_venda, codbar, refori, is_pis, cod_ispis from produto where REFNFE = :cod');
    dm.IBselect.ParamByName('cod').AsString :=
      copy(form48.ClientDataSet1.FieldByName('REF_NFE').AsString, 1, 25);
    dm.IBselect.Open;

    axx := '0';

    if dm.IBselect.IsEmpty then
    begin
      if item1.codbar <> '' then
      begin
        dm.IBselect.Close;
        dm.IBselect.SQL.Clear;
        dm.IBselect.SQL.Add
          ('select p.cod, p.is_pis, p.cod_ispis, p.nome, p.unid2, p.p_venda, p.codbar, p.aliquota, p.refori, '
          + ' p.unid from produto p left join codbarras c on (c.cod = p.cod) where (p.codbar = '
          + QuotedStr(copy(item1.codbar, 1, 15)) + ') or (c.codbar = ' +
          QuotedStr(copy(item1.codbar, 1, 15)) + ')');
        dm.IBselect.Open;

        if not dm.IBselect.IsEmpty then
        begin
          axx := '1';
        end;
      end
      else
        axx := '0';
    end
    else
      axx := '1';

    if axx = '1' then // se achou o produto
    begin
      form48.ClientDataSet1.FieldByName('codigo').AsString :=
        dm.IBselect.FieldByName('cod').AsString;
      form48.ClientDataSet1.FieldByName('CODBAR_ATUAL').AsString :=
        dm.IBselect.FieldByName('codbar').AsString;
      form48.ClientDataSet1.FieldByName('PRECO_ATUAL').AsCurrency :=
        dm.IBselect.FieldByName('p_venda').AsCurrency;
      form48.ClientDataSet1.FieldByName('ALIQ').AsString :=
        dm.IBselect.FieldByName('aliquota').AsString;
      form48.ClientDataSet1.FieldByName('DESCRICAO_ATUAL').AsString :=
        copy(dm.IBselect.FieldByName('nome').AsString, 1, 40);
      form48.ClientDataSet1.FieldByName('REFORI').AsString :=
        dm.IBselect.FieldByName('REFORI').AsString;

      form48.ClientDataSet1.FieldByName('pis').AsString :=
        dm.IBselect.FieldByName('is_pis').AsString;
       form48.ClientDataSet1.FieldByName('cod_ispis').AsString :=
        dm.IBselect.FieldByName('cod_ispis').AsString;

      if dm.IBselect.FieldByName('unid2').AsString <> '' then
      begin
        form48.ClientDataSet1.FieldByName('UNID_ENTRADA').AsString :=
          dm.IBselect.FieldByName('unid2').AsString;
        form48.ClientDataSet1.FieldByName('mu').AsCurrency :=
          verValorUnidade(dm.IBselect.FieldByName('unid2').AsString);

        form48.ClientDataSet1.FieldByName('QUANTIDADE_ENT').AsCurrency :=
          ArredondaFinanceiro(form48.ClientDataSet1.FieldByName('mu').AsInteger
          * form48.ClientDataSet1.FieldByName('QUANTIDADE_NFE').AsCurrency, 3);
      end;

      form48.ClientDataSet1.FieldByName('UNID_VENDA').AsString :=
        dm.IBselect.FieldByName('unid').AsString;
    end;

    dm.IBselect.Close;
    form48.ClientDataSet1.Post;
  end;

  funcoes.informacao(0, fim, 'Aguarde, Lendo XML...', False, true, 5);

  sim := funcoes.dialogo('numero', 0, '', 2, False, 'X', Application.Title,
    'Qual o Lucro %?', '100,00');
  if sim = '*' then
    exit;

  form48.ClientDataSet1.First;

  while not form48.ClientDataSet1.Eof do
  begin
    form48.ClientDataSet1.Edit;
    form48.ClientDataSet1.FieldByName('LUCRO').AsCurrency :=
      StrToCurrDef(sim, 0);
    form48.ClientDataSet1.FieldByName('PRECO_NOVO').AsCurrency :=
      Arredonda(form48.ClientDataSet1.FieldByName('PRECO_NFE').AsCurrency +
      (form48.ClientDataSet1.FieldByName('PRECO_NFE').AsCurrency *
      StrToCurrDef(sim, 0) / 100), 2);
    form48.ClientDataSet1.Post;

    form48.ClientDataSet1.Next;
  end;

  form48.xml := xml;
  form48.erro := erro;
  form48.chave := chave;
  form48.nota := nota;

  form48.Label5.caption := 'Nota: ' + nota;
  form48.Label6.caption := 'Total R$: ' + FormatCurr('#,###,###0.00',
    form48.ClientDataSet1.FieldByName('TOTnota').AsCurrency);
  form48.Label7.caption := 'Fornecedor: ' + form48.fornecedor + ' - ' + forn;

  if FileExists(caminhoEXE_com_barra_no_final + cnpjFOR + '-' + nota + '.xml')
  then
  begin
    form48.ClientDataSet1.Close;
    form48.ClientDataSet1.LoadFromFile(caminhoEXE_com_barra_no_final + cnpjFOR +
      '-' + nota + '.xml');
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

function Tfuncoes.receberSincronizacaoExtoque1(CaminhoArq: String): boolean;
var
  // Input: TIBInputRawFile;
  item: Ptr_sinc;
  i, tot, RecNo: integer;
  linha, sim, promoc1: String;
  F: TextFile;
  arq, arquivo: tstringList;
  lista: Tlist;
begin
  Result := False;
  if not FileExists(CaminhoArq) then
  begin
    ShowMessage('Arquivo ' + CaminhoArq + ' Não Encontrado.');
    exit;
  end;

  { try
    AssignFile(F, CaminhoArq);
    except
    ShowMessage('Ocorreu um Erro. Verifique se a Unidade está funcionando corretamente');
    exit;
    end; }

  // Reset(F);
  arquivo := tstringList.Create;

  arquivo.LoadFromFile(CaminhoArq);

  arq := tstringList.Create;
  lista := Tlist.Create;

  linha := '';

  try
    linha := arquivo[0];
  except
    on e: exception do
    begin
      ShowMessage('Erro: ' + e.Message);
      arq.Free;
      arquivo.Free;
      exit;
    end;
  end;

  if not Contido('|SINCXX1|', linha) then
  begin
    ShowMessage('Arquivo De Sincronização Não Compativel Com esta Versão!');
    arq.Free;
    arquivo.Free;
    exit;
  end;

  LE_CAMPOS(arq, linha, '|', False);

  if MessageDlg('Deseja Receber Esta Sincronização: ' + #13 + 'Data: ' +
    arq.Values['1'] + #13 + 'Usuário: ' + arq.Values['2'], mtConfirmation,
    [mbYes, mbNo], 1) = idno then
  begin
    arq.Free;
    arquivo.Free;
    exit;
  end;


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
  // 10 - grupo
  // 11 - p_venda1
  // 12 - fornec
  // 13 - fabric
  // 14 - localiza
  // 15 - refori
  // 16 - lucro
  // 17 - comissao
  // 18 - credICM
  // 19 - basecred
  // 20 - debicm
  // 21 - basedeb
  // 22 - frete
  // 23 - encargos
  // 24 - agregado
  // 25 - obs
  // 26 - TIPO_ITEM

  // tot := filesize(F);
  tot := arquivo.count - 1;
  RecNo := 1;
  funcoes.informacao(0, tot, 'Aguarde, Sincronizando Estoque...', true,
    False, 5);

  if Contido(arquivo[1], '|TABELAX|PRODUTO|') then
    RecNo := 3;

  // while not Eof(F) do
  for RecNo := RecNo to tot do
  begin
    // recno := recno + 1;
    funcoes.informacao(RecNo, tot, 'Aguarde, Sincronizando Estoque...', False,
      False, 5);

    arq.Clear;
    linha := arquivo[RecNo];

    if Contido('|FORNECEDOR|', linha) THEN
      break;

    if Contido('|PROMOC1|', linha) then
      break;

    LE_CAMPOS(arq, linha, '|', False);


    // ShowMessage('count=' + IntToStr(arq.Count) + #13 + arq.GetText + #13 + #13 + linha);

    dm.IBselect.Close;
    dm.IBselect.SQL.Clear;
    dm.IBselect.SQL.Add
      ('select cod, nome, p_venda from produto where cod = :cod');
    dm.IBselect.ParamByName('cod').AsString := arq.Values['0'];
    dm.IBselect.Open;

    if not dm.IBselect.IsEmpty then
    begin
      if dm.IBselect.FieldByName('p_venda').AsCurrency <>
        StrToCurrDef(arq.Values['5'], 0) then
      begin
        item := new(Ptr_sinc);
        item.cod := dm.IBselect.FieldByName('cod').AsInteger;
        item.nome := dm.IBselect.FieldByName('nome').AsString;
        item.p_vendaEstoque := dm.IBselect.FieldByName('p_venda').AsCurrency;
        item.p_vendaSincronizacao := StrToCurrDef(arq.Values['5'], 0);

        lista.Add(item);
      end;
    end;

    dm.IBQuery1.Close;
    dm.IBQuery1.SQL.text :=
      ('update or insert into produto(cod, codbar, unid, nome, p_compra, p_venda, aliquota, classif, is_pis, cod_ispis, grupo, p_venda1, fornec, fabric, localiza, refori, lucro, comissao,'
      + ' credicm, basecred, debicm, basedeb, frete, encargos, agregado, obs, TIPO_ITEM) values(:cod, :codbar, :unid, :nome, :p_compra, :p_venda, :aliquota, :classif, :is_pis, :cod_ispis,'
      + ' :grupo, :p_venda1, :fornec, :fabric, :localiza, :refori, :lucro, :comissao, :credicm, :basecred, :debicm, :basedeb, :frete, :encargos, :agregado, :obs, :TIPO_ITEM) matching(cod)');
    dm.IBQuery1.ParamByName('cod').AsString := arq.Values['0'];
    dm.IBQuery1.ParamByName('codbar').AsString := arq.Values['1'];
    dm.IBQuery1.ParamByName('unid').AsString := arq.Values['2'];
    dm.IBQuery1.ParamByName('nome').AsString := arq.Values['3'];
    dm.IBQuery1.ParamByName('p_compra').AsCurrency :=
      StrToCurrDef(arq.Values['4'], 0);
    dm.IBQuery1.ParamByName('p_venda').AsCurrency :=
      StrToCurrDef(arq.Values['5'], 0);
    dm.IBQuery1.ParamByName('aliquota').AsString := arq.Values['6'];
    dm.IBQuery1.ParamByName('classif').AsString := arq.Values['7'];
    dm.IBQuery1.ParamByName('is_pis').AsString := trim(arq.Values['8']);
    dm.IBQuery1.ParamByName('cod_ispis').AsString := StrNum(arq.Values['9']);
    dm.IBQuery1.ParamByName('grupo').AsString := StrNum(arq.Values['10']);
    dm.IBQuery1.ParamByName('p_venda1').AsCurrency :=
      StrToCurrDef(arq.Values['11'], 0);
    dm.IBQuery1.ParamByName('fornec').AsString := StrNum(arq.Values['12']);
    dm.IBQuery1.ParamByName('fabric').AsString := StrNum(arq.Values['13']);
    dm.IBQuery1.ParamByName('localiza').AsString := trim(arq.Values['14']);
    dm.IBQuery1.ParamByName('refori').AsString := trim(arq.Values['15']);
    dm.IBQuery1.ParamByName('lucro').AsCurrency :=
      StrToCurrDef(arq.Values['16'], 0);
    dm.IBQuery1.ParamByName('comissao').AsCurrency :=
      StrToCurrDef(arq.Values['17'], 0);
    dm.IBQuery1.ParamByName('credICM').AsCurrency :=
      StrToCurrDef(arq.Values['18'], 0);
    dm.IBQuery1.ParamByName('basecred').AsCurrency :=
      StrToCurrDef(arq.Values['19'], 0);
    dm.IBQuery1.ParamByName('debicm').AsCurrency :=
      StrToCurrDef(arq.Values['20'], 0);
    dm.IBQuery1.ParamByName('basedeb').AsCurrency :=
      StrToCurrDef(arq.Values['21'], 0);
    dm.IBQuery1.ParamByName('frete').AsCurrency :=
      StrToCurrDef(arq.Values['22'], 0);
    dm.IBQuery1.ParamByName('encargos').AsCurrency :=
      StrToCurrDef(arq.Values['23'], 0);
    dm.IBQuery1.ParamByName('agregado').AsCurrency :=
      StrToCurrDef(arq.Values['24'], 0);
    dm.IBQuery1.ParamByName('obs').AsString := trim(arq.Values['25']);
    dm.IBQuery1.ParamByName('TIPO_ITEM').AsString := StrNum(arq.Values['26']);

    try
      dm.IBQuery1.ExecSQL;
    except
      on e: exception do
      begin
        ShowMessage('ERRO: ' + linha + #13 + e.Message);
      end;
    end;
  end;

  for RecNo := RecNo to arquivo.count - 1 do
  begin
    funcoes.informacao(RecNo, tot, 'Aguarde, Sinc. Fornecedoes...', False,
      False, 5);

    linha := arquivo[RecNo];
    if trim(linha) <> '' then
    begin

      if Contido('|PROMOC1|', linha) then
      begin
        break;
      end;

      LE_CAMPOS(arq, linha, '|', False);

      recebeFornecedores(arq);
    end;
  end;

  funcoes.informacao(RecNo, tot, 'Aguarde, Sinc. Fornecedoes...',
    False, true, 5);
  funcoes.informacao(RecNo, tot, 'Aguarde, Sinc. Promoções...', true, False, 5);

  if Contido('|PROMOC1|', linha) then
  begin
    // le_promoc1(promoc1);
    RecNo := RecNo + 1;
  end;

  for RecNo := RecNo to arquivo.count - 1 do
  begin
    funcoes.informacao(RecNo, tot, 'Aguarde, Sinc. Promoções...', False,
      False, 5);

    linha := arquivo[RecNo];

    if trim(linha) <> '' then
    begin
      LE_CAMPOS(arq, linha, '|', False);
      recebePromoc1(arq, promoc1);
    end;
  end;

  try
    if dm.IBQuery1.Transaction.InTransaction then
      dm.IBQuery1.Transaction.Commit;
  except
    on e: exception do
    begin
      ShowMessage('Ocorreu um erro. Tente Novamente: ' + #13 + e.Message);
    end;
  end;

  restartGeneratorPelaTabelaMax('produto', 'produto');
  restartGeneratorPelaTabelaMax('fornecedor', 'fornecedor');
  restartGeneratorPelaTabelaMax('promoc1', 'promoc1');

  funcoes.informacao(RecNo, tot, 'Aguarde, Sincronizando Estoque...',
    False, true, 5);

  if lista.count > 0 then
  // encontrou com precos diferentes entao gera relatório
  begin
    sim := funcoes.dialogo('generico', 30, 'SN', 30, False, 'S',
      Application.Title, 'Imprimir relatório de Diferenças em Preços?', 'S');
    if (sim = '*') then
    begin

      exit;
    end;
    if sim = 'S' then
    begin
      form19.RichEdit1.Clear;
      addRelatorioForm19(funcoes.RelatorioCabecalho(form22.Pgerais.Values
        ['empresa'], 'Relatório de Mudanca de Precos de Estoques', 80));
      addRelatorioForm19(CompletaOuRepete('|', 'COD|', ' ', 6) +
        CompletaOuRepete('DESCRICAO', '|', ' ', 34) + CompletaOuRepete('',
        'PRECO ATUAL|', ' ', 14) + CompletaOuRepete('', 'PRECO NOVO|', ' ', 14)
        + CompletaOuRepete('', 'DIFERENCA|', ' ', 12) + CRLF);
      addRelatorioForm19(CompletaOuRepete('', '', '-', 80) + CRLF);

      for i := 0 to lista.count - 1 do
      begin
        item := lista[i];
        addRelatorioForm19(funcoes.CompletaOuRepete('', IntToStr(item.cod), ' ',
          6) + ' ' + funcoes.CompletaOuRepete(LeftStr(item.nome, 33), '', ' ',
          33) + funcoes.CompletaOuRepete('', FormatCurr('##,###,###0.000',
          item.p_vendaEstoque), ' ', 14) + funcoes.CompletaOuRepete('',
          FormatCurr('##,###,###0.000', item.p_vendaSincronizacao), ' ', 14) +
          funcoes.CompletaOuRepete('', FormatCurr('0.00',
          item.p_vendaEstoque - item.p_vendaSincronizacao), ' ', 12) +
          #13 + #10);
      end;

      addRelatorioForm19(CompletaOuRepete('', '', '-', 80) + CRLF);
      form19.ShowModal;
    end;
  end;

  dm.IBselect.Close;
  dm.IBselect.SQL.text := 'select max(cod) as venda from produto';
  dm.IBselect.Open;

  i := dm.IBselect.FieldByName('venda').AsInteger;

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

function Tfuncoes.BrowseForFolder(const browseTitle: String;
  const initialFolder: String = '';
  mayCreateNewFolder: boolean = False): String;
var
  browse_info: TBrowseInfo;
  folder: array [0 .. MAX_PATH] of Char;
  find_context: PItemIDList;
const
  BIF_NEWDIALOGSTYLE = $40;
  BIF_NONEWFOLDERBUTTON = $200;
begin
  FillChar(browse_info, SizeOf(browse_info), #0);
  lg_StartFolder := initialFolder;
  browse_info.pszDisplayName := @folder[0];
  browse_info.lpszTitle := PChar(browseTitle);
  browse_info.ulFlags := BIF_RETURNONLYFSDIRS or BIF_NEWDIALOGSTYLE;
  if not mayCreateNewFolder then
    browse_info.ulFlags := browse_info.ulFlags or BIF_NONEWFOLDERBUTTON;

  browse_info.hwndOwner := Application.Handle;
  // if initialFolder <> '' then
  // browse_info.lpfn := BrowseForFolderCallBack;
  find_context := SHBrowseForFolder(browse_info);
  if Assigned(find_context) then
  begin
    if SHGetPathFromIDList(find_context, folder) then
      Result := folder
    else
      Result := '';
    GlobalFreePtr(find_context);
  end
  else
    Result := '';
end;

function Tfuncoes.BrowseForFolderCallBack(Wnd: HWND; uMsg: UINT;
  lParam, lpData: lParam): integer stdcall;
var
  lg_StartFolder: String;
begin
  lg_StartFolder := '';
  if uMsg = BFFM_INITIALIZED then
    SendMessage(Wnd, BFFM_SETSELECTION, 1, integer(@lg_StartFolder[1]));
  Result := 0;
end;

function Tfuncoes.SincronizarExtoque1(CaminhoArq: String): boolean;
var
  // Output: TIBOutputRawFile;
  unid, linha, simFornece, simPromoc, paramExporta: string;
  F: TextFile;
  tot: integer;
  camposProd: tstringList;
begin
  simFornece := 'S';

  { simFornece := funcoes.dialogo('generico', 0, 'SN', 20, false, 'S',
    Application.Title, 'Exportar Fornecedores ?', 'N'); }

  AssignFile(F, (caminhoEXE_com_barra_no_final + 'TEXTO.dat'));
  Rewrite(F);

  linha := '|SINCXX1|' + FormatDateTime('dd/mm/yy', now) + ' ' +
    FormatDateTime('hh:mm:ss', now) + '|' + form22.USUARIO + '|';

  Writeln(F, linha);

  dm.IBselect.Close;
  dm.IBselect.SQL.Clear;
  dm.IBselect.SQL.Add('select * from produto');
  dm.IBselect.Open;
  dm.IBselect.FetchAll;
  tot := dm.IBselect.RecordCount;
  camposProd := tstringList.Create;

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
    // 10 - grupo
    // 11 - p_venda1
    // 12 - fornec
    // 13 - fabric
    // 14 - localiza
    // 15 - refori
    // 16 - lucro
    // 17 - comissao
    // 18 - credICM
    // 19 - basecred
    // 20 - debicm
    // 21 - basedeb
    // 22 - frete
    // 23 - encargos
    // 24 - agregado
    // 25 - obs
    // 26 - TIPO_ITEM
    funcoes.informacao(0, tot, 'Gerando Sincronização...', true, False, 5);

    while not dm.IBselect.Eof do
    begin
      funcoes.informacao(dm.IBselect.RecNo, tot, 'Gerando Sincronização...',
        False, False, 5);
      linha := '|' + dm.IBselect.FieldByName('cod').AsString + '|' +
        dm.IBselect.FieldByName('codbar').AsString + '|' +
        dm.IBselect.FieldByName('unid').AsString + '|' + dm.IBselect.FieldByName
        ('nome').AsString + '|' + dm.IBselect.FieldByName('p_compra').AsString +
        '|' + dm.IBselect.FieldByName('p_venda').AsString + '|' +
        dm.IBselect.FieldByName('aliquota').AsString + '|' +
        dm.IBselect.FieldByName('classif').AsString + '|' +
        trim(dm.IBselect.FieldByName('is_pis').AsString) + '|' +
        trim(dm.IBselect.FieldByName('cod_ispis').AsString) + '|' +
        dm.IBselect.FieldByName('grupo').AsString + '|' +
        dm.IBselect.FieldByName('p_venda1').AsString + '|' +
        dm.IBselect.FieldByName('fornec').AsString + '|' +
        dm.IBselect.FieldByName('fabric').AsString + '|' +
        dm.IBselect.FieldByName('localiza').AsString + '|' +
        dm.IBselect.FieldByName('refori').AsString + '|' +
        dm.IBselect.FieldByName('lucro').AsString + '|' +
        dm.IBselect.FieldByName('comissao').AsString + '|' +
        dm.IBselect.FieldByName('credICM').AsString + '|' +
        dm.IBselect.FieldByName('basecred').AsString + '|' +
        dm.IBselect.FieldByName('debicm').AsString + '|' +
        dm.IBselect.FieldByName('basedeb').AsString + '|' +
        dm.IBselect.FieldByName('frete').AsString + '|' +
        dm.IBselect.FieldByName('encargos').AsString + '|' +
        dm.IBselect.FieldByName('agregado').AsString + '|' +
        dm.IBselect.FieldByName('obs').AsString + '|' +
        IfThen(trim(dm.IBselect.FieldByName('TIPO_ITEM').AsString) = '', '00',
        trim(dm.IBselect.FieldByName('TIPO_ITEM').AsString)) + '|';

      // Writeln(F, funcoes.Criptografar(linha));
      Writeln(F, linha);
      dm.IBselect.Next;
    end;
    funcoes.informacao(0, tot, 'Gerando Sincronização...', False, true, 5);
  except
    funcoes.informacao(0, tot, 'Gerando Sincronização...', False, true, 5);
  end;

  if simFornece = 'S' then
    exportaFornecedores(F);

  exportaPromoc1(F);

  // exportaTabela('produto', 'cod, grupo, codbar, unid, nome, p_compra, p_venda, aliquota, classif, is_pis, cod_ispis', F, dm.IBselect);
  // exportaTabela('fornecedor', 'cod,nome, endereco, cep, fone, fax, cidade,estado,contato, obs, bairro, cnpj, ies, cod_mun, suframa, tipo', F, dm.IBselect);

  CloseFile(F);

  try
    if not excluiAqruivo(CaminhoArq) then
      exit;
    CopyFile(PChar(caminhoEXE_com_barra_no_final + 'TEXTO.dat'),
      PChar(CaminhoArq), true);

    excluiAqruivo(caminhoEXE_com_barra_no_final + 'TEXTO.dat');
  except
    ShowMessage('Ocorreu um Erro, Verifique:' + #13 +
      '1 - Se a Unidade foi informada corretamente' + #13 +
      '2 - Se o pendrive está conectado');
    exit;
  end;

  Result := true;
end;

function Tfuncoes.SincronizarExtoque2(CaminhoArq: String): boolean;
var
  // Output: TIBOutputRawFile;
  unid, linha, simFornece, simPromoc, paramExporta: string;
  F: TextFile;
  tot: integer;
  listaArqui: tstringList;
  mbody: TMemo;
begin
  simFornece := 'S';
  dm.execucaoEmail := 1;

  // simFornece := funcoes.dialogo('generico', 0, 'SN', 20, false, 'S',
  // Application.Title, 'Exportar Fornecedores ?', 'N');
  simPromoc := (caminhoEXE_com_barra_no_final + 'BD.txt');
  AssignFile(F, simPromoc);
  Rewrite(F);

  linha := '|SINCXX1|' + FormatDateTime('dd/mm/yy', now) + ' ' +
    FormatDateTime('hh:mm:ss', now) + '|' + form22.USUARIO + '|';

  Writeln(F, linha);

  exportaTabela('produto', '*', F, dm.IBselect);
  exportaTabela('PROMOC1', '*', F, dm.IBselect);
  exportaTabela('CAIXA', '*', F, dm.IBselect);
  exportaTabela('REGISTRO', '*', F, dm.IBselect);

  exportaTabela('ACESSO', '*', F, dm.IBselect);
  exportaTabela('CLIENTE', '*', F, dm.IBselect);

  exportaTabela('FABRICANTE', '*', F, dm.IBselect);
  exportaTabela('FORNECEDOR', '*', F, dm.IBselect);
  exportaTabela('GRUPOPROD', '*', F, dm.IBselect);
  exportaTabela('VENDEDOR', '*', F, dm.IBselect);
  exportaTabela('AGENDA', '*', F, dm.IBselect);
  exportaTabela('USUARIO', '*', F, dm.IBselect);

  exportaTabela('VENDA', '*', F, dm.IBselect);
  exportaTabela('ITEM_VENDA', '*', F, dm.IBselect);

  exportaTabela('ENTRADA', '*', F, dm.IBselect);
  exportaTabela('ITEM_ENTRADA', '*', F, dm.IBselect);

  exportaTabela('CONTASRECEBER', '*', F, dm.IBselect);
  exportaTabela('CONTASPAGAR', '*', F, dm.IBselect);
  exportaTabela('PGERAIS', '*', F, dm.IBselect);
  exportaTabela('NFCE', '*', F, dm.IBselect);
  exportaTabela('NFE', '*', F, dm.IBselect);

  exportaGenerators('GENERATORS', '', F, dm.IBselect);

  CloseFile(F);
  sleep(1000);
  try
    // if not excluiAqruivo(CaminhoArq) then exit;
    // CopyFile(PChar(caminhoEXE_com_barra_no_final + 'TEXTO.dat'),
    // PChar(CaminhoArq), true);

    unid := caminhoEXE_com_barra_no_final + 'BACKUP\BD.zip';
    // excluiAqruivo(caminhoEXE_com_barra_no_final + 'TEXTO.dat');
    CriaDiretorio(caminhoEXE_com_barra_no_final + 'BACKUP\');
    listaArqui := tstringList.Create;
    listaArqui.Add(simPromoc);
    funcoes.Zip(listaArqui, unid);

    configuraMail(dm.ACBrMail1);
    dm.ACBrMail1.AddAttachment(unid, 'Backup');

    // Body da mensagem
    dm.IBselect.Close;
    dm.IBselect.SQL.Clear;
    dm.IBselect.SQL.Add
      ('select empresa,telres,telcom,titular,ende,bairro,cid,est from registro');
    dm.IBselect.Open;

    texto := '';
    texto := texto + 'Empresa: ' + dm.IBselect.FieldByName('empresa').AsString
      + '</br>';
    texto := texto + 'Telefones: ' + dm.IBselect.FieldByName('telres').AsString
      + '  ' + dm.IBselect.FieldByName('telcom').AsString + '</br>';
    texto := texto + 'Titular:' + dm.IBselect.FieldByName('titular').AsString
      + '</br>';
    texto := texto + 'Endereço: ' + dm.IBselect.FieldByName('ende').AsString +
      ' - ' + dm.IBselect.FieldByName('bairro').AsString + '</br>';
    texto := texto + 'Localidade: ' + dm.IBselect.FieldByName('cid').AsString +
      '-' + dm.IBselect.FieldByName('est').AsString + '</br>';
    texto := texto + 'Usuário: ' + form22.USUARIO + '</br>';
    texto := texto + '</br>' + '</br>' + '</br>';
    texto := texto + 'Este e um email automatico gerado por CONTROLW.';

    // dm.ACBrMail1.Body.Text := texto;
    mbody := TMemo.Create(self);
    mbody.Parent := self;
    mbody.text := texto;
    dm.ACBrMail1.IsHTML := true;
    dm.ACBrMail1.Body.Assign(mbody.Lines);
    dm.ACBrMail1.Body.text := texto;

    dm.ACBrMail1.FromName := 'ControlW Sistemas';
    dm.ACBrMail1.Subject := 'Backup ' + trim(dm.IBselect.FieldByName('empresa')
      .AsString) + ' ' + FormataData(now);
    // dm.ACBrMail1.From      := 'controlwsistemas@gmail.com';
    dm.ACBrMail1.AddAddress('controlwsistemas@gmail.com', 'ControlW');
    dm.ACBrMail1.AddAddress('sistemas@controlw.blog.br', 'ControlWBLOG');

    dm.IBselect.Close;
    enviandoBackup := true;
    dm.ACBrMail1.send(true);
    enviandoBackup := False;
  except
    on e: exception do
    begin
      enviandoBackup := False;
      ShowMessage('Ocorreu um Erro, Verifique:' + e.Message);
      exit;
    end;
  end;

  mbody.Free;
  Result := true;
end;

function Tfuncoes.geraRelFechamento(const cod12: integer;
  vendedor: String): String;
var
  lista: Tlist;
  item, temp: Ptr_Item;
  i, ret: integer;
  total: currency;
begin
  Result := '';
  if vendedor <> '' then
    vendedor := ' and (vendedor = ' + vendedor + ')';

  form19.RichEdit1.Clear;
  dm.IBselect.Close;
  dm.IBselect.SQL.Clear;
  dm.IBselect.SQL.Add
    ('select codhis, total, vendedor, desconto from venda where  (fechamento = :fech)'
    + vendedor + ' order by vendedor, codhis');
  dm.IBselect.ParamByName('fech').AsInteger := cod12;
  dm.IBselect.Open;

  lista := Tlist.Create;
  total := 0;

  while not dm.IBselect.Eof do
  begin
    ret := -1; // inicia com -1 para
    for i := 0 to lista.count - 1 do
    begin
      item := lista[i]; // compara forma de pagamento e vendedor
      if (item.codFormaPagamento = dm.IBselect.FieldByName('codhis').AsInteger)
        and (item.codVendedor = dm.IBselect.FieldByName('vendedor').AsInteger)
      then
      begin
        ret := i;
        break;
      end;
    end;

    if ret = -1 then
    // ret está -1 porque não foi encontrado o indice deste na lista
    begin
      item := new(Ptr_Item);
      item.codFormaPagamento := dm.IBselect.FieldByName('codhis').AsInteger;
      item.codVendedor := dm.IBselect.FieldByName('vendedor').AsInteger;
      item.total := dm.IBselect.FieldByName('total').AsCurrency;
      lista.Add(item);
    end
    else
    begin // veio pra ca porque achou o vendedor, forma de pagamento na lista
      item := lista[ret];
      item.total := item.total + dm.IBselect.FieldByName('total').AsCurrency;
      lista[ret] := item;
    end;

    dm.IBselect.Next;
  end;

  addRelatorioForm19(#15 + CompletaOuRepete('', '', '-', 40) + #13 + #10);
  addRelatorioForm19(CompletaOuRepete(centraliza(form22.Pgerais.Values
    ['empresa'], ' ', 40), '', ' ', 40) + #13 + #10);
  addRelatorioForm19(CompletaOuRepete(centraliza('FECHAMENTO DE VENDAS: ' +
    IntToStr(cod12), ' ', 40), '', ' ', 40) + #13 + #10);
  // addrelatorioform19(CompletaOuRepete('Data: ' + FormatDateTime('dd/mm/yy', form22.datamov), 'Hora: ' + FormatDateTime('hh:mm:ss', now), ' ', 40) + #13 + #10);
  addRelatorioForm19(CompletaOuRepete('', '', '-', 40) + #13 + #10);
  ret := -1;
  for i := 0 to lista.count - 1 do
  begin
    item := lista[i];
    if ret <> item.codVendedor then
    begin
      if i <> 0 then
        addRelatorioForm19(CompletaOuRepete('', '', '-', 40) + #13 + #10);
      form19.RichEdit1.SelAttributes.Style := [fsbold];
      addRelatorioForm19(centraliza('Vendedor: ' + IntToStr(item.codVendedor) +
        ' - ' + BuscaNomeBD(dm.IBQuery1, 'nome', 'vendedor',
        'where cod =' + IntToStr(item.codVendedor)), ' ', 40) + #13 + #10);
      addRelatorioForm19(centraliza('DATA: ' + FormatDateTime('dd/mm/yy',
        form22.dataMov) + '   ' + 'HORA: ' + FormatDateTime('hh:mm:ss', now),
        ' ', 40) + #13 + #10);
      addRelatorioForm19(CompletaOuRepete('', '', '-', 40) + #13 + #10);
      form19.RichEdit1.SelAttributes.Style := [];
      ret := item.codVendedor;
    end;
    addRelatorioForm19(CompletaOuRepete(IntToStr(item.codFormaPagamento) + ' - '
      + BuscaNomeBD(dm.IBQuery1, 'nome', 'formpagto',
      'where cod =' + IntToStr(item.codFormaPagamento)), '', ' ', 20) + ' - ' +
      CompletaOuRepete('', FormatCurr('#,###,###0.00', item.total), ' ', 13) +
      #13 + #10);
    total := total + item.total;
  end;
  addRelatorioForm19(CompletaOuRepete('', '', '-', 40) + #13 + #10);
  addRelatorioForm19(CompletaOuRepete('Total:...........' +
    FormatCurr('#,###,###0.00', total), '', ' ', 40) + #13 + #10);
  addRelatorioForm19(CompletaOuRepete('', '', '-', 40) + #13 + #10);
end;


function Tfuncoes.VerSeExistePROCEDUREPeloNome(Const nome: String): boolean;
begin
  Result := False;
  dm.IBselect.Close;
  dm.IBselect.SQL.Clear;
  dm.IBselect.SQL.Add
    ('select * from RDB$PROCEDURES WHERE RDB$PROCEDURE_NAME = '+ QuotedStr(UpperCase(nome)));
  dm.IBselect.Open;

  if not dm.IBselect.IsEmpty then
    Result := true;

  dm.IBselect.Close;
end;

function Tfuncoes.VerSeExisteTRIGGERPeloNome(Const nome: String): boolean;
begin
  Result := False;
  dm.IBselect.Close;
  dm.IBselect.SQL.Clear;
  dm.IBselect.SQL.Add
    ('select * from RDB$triggers where RDB$TRIGGER_NAME = '+ QuotedStr(UpperCase(nome)));
  dm.IBselect.Open;

  if not dm.IBselect.IsEmpty then
    Result := true;

  dm.IBselect.Close;
end;


function Tfuncoes.VerSeExisteGeneratorPeloNome(Const nome: String): boolean;
begin
  Result := False;
  dm.IBselect.Close;
  dm.IBselect.SQL.Clear;
  dm.IBselect.SQL.Add
    ('select rdb$generator_name from rdb$generators where rdb$generator_name = '
    + QuotedStr(nome));
  dm.IBselect.Open;

  if not dm.IBselect.IsEmpty then
    Result := true;

  dm.IBselect.Close;
end;

function Tfuncoes.verPermissaoDiaria(const ret: String): String;
begin
  Result := '0';
  dm.IBselect.Close;
  dm.IBselect.SQL.Clear;
  dm.IBselect.SQL.Add('select * from cpd where dd = :dd');
  dm.IBselect.ParamByName('dd').AsString :=
    funcoes.Criptografar(FormatDateTime('dd/mm/yy', form22.dataMov));
  dm.IBselect.Open;

  if ret = '' then
  begin
    if dm.IBselect.IsEmpty then
      Result := '2'
    else
      Result := dm.IBselect.FieldByName('sit').AsString;
    dm.IBselect.Close;
    exit;
  end;

  if dm.IBselect.IsEmpty then
  begin
    if (ret = '01') then
    begin
      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add
        ('update or insert into cpd(dd, sit) values(:dd, :sit) matching (dd)');
      dm.IBQuery1.ParamByName('dd').AsString :=
        funcoes.Criptografar(FormatDateTime('dd/mm/yy', form22.dataMov));
      dm.IBQuery1.ParamByName('sit').AsInteger := 0;
      dm.IBQuery1.ExecSQL;

    end
    else if (ret = '1') then
    begin
      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add
        ('update or insert into cpd(dd, sit) values(:dd, :sit) matching (dd)');
      dm.IBQuery1.ParamByName('dd').AsString :=
        funcoes.Criptografar(FormatDateTime('dd/mm/yy', form22.dataMov));
      dm.IBQuery1.ParamByName('sit').AsInteger := 1;
      dm.IBQuery1.ExecSQL;

      Result := '1';
    end;
    try
      if dm.IBQuery1.Transaction.InTransaction then
        dm.IBQuery1.Transaction.Commit;
    except
      if dm.IBQuery1.Transaction.InTransaction then
        dm.IBQuery1.Transaction.Rollback;
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
      dm.IBQuery1.SQL.Add
        ('update or insert into cpd(dd, sit) values(:dd, :sit) matching (dd)');
      dm.IBQuery1.ParamByName('dd').AsString :=
        funcoes.Criptografar(FormatDateTime('dd/mm/yy', form22.dataMov));
      dm.IBQuery1.ParamByName('sit').AsInteger := 0;
      dm.IBQuery1.ExecSQL;

      dm.IBQuery1.Transaction.Commit;

      Result := '0';
    end;
  end;

  dm.IBselect.Close;
  dm.IBQuery1.Close;
end;

function Tfuncoes.buscaPorCodigotornaCodigoBarrasValido
  (const cod: String): String;
var
  autopeca: boolean;
begin
  Result := '';
  dm.ibquery3.Close;
  dm.ibquery3.SQL.Clear;
  dm.ibquery3.SQL.Add('select cod, codbar from produto where cod = :cod');
  dm.ibquery3.ParamByName('cod').AsString := cod;
  dm.ibquery3.Open;

  if not checaCodbar(StrNum(dm.ibquery3.FieldByName('codbar').AsString)) then
  begin
    dm.ibquery4.Close;
    dm.ibquery4.SQL.Clear;
    dm.ibquery4.SQL.Add('select * from codbarras where cod = :cod');
    dm.ibquery4.ParamByName('cod').AsString := cod;
    dm.ibquery4.Open;

    while not dm.ibquery4.Eof do
    begin
      if checaCodbar(StrNum(dm.ibquery4.FieldByName('codbar').AsString)) then
      begin
        Result := dm.ibquery4.FieldByName('codbar').AsString;
        exit;
      end;

      dm.ibquery4.Next;
    end;

    if Result = '' then
    begin
      Result := DIGEAN('789000' + STRZERO(dm.ibquery3.FieldByName('cod')
        .AsInteger, 6));

      if buscaParamGeral(5, 'N') = 'N' then
      begin
        dm.ibquery4.Close;
        dm.ibquery4.SQL.Clear;
        dm.ibquery4.SQL.Add
          ('update produto set codbar = :codbar where cod = :cod');
        dm.ibquery4.ParamByName('codbar').AsString := Result;
        dm.ibquery4.ParamByName('cod').AsInteger :=
          dm.ibquery3.FieldByName('cod').AsInteger;
        dm.ibquery4.ExecSQL;
        dm.ibquery4.Transaction.Commit;
      end;
    end;
  end
  else
  begin
    Result := dm.ibquery3.FieldByName('codbar').AsString;
  end;
end;

function Tfuncoes.buscaCodbarRetornaCodigo(codbar: String;
  pergunta: boolean = False): String;
begin
  Result := '';
  if pergunta then
  begin
    codbar := funcoes.dialogo('generico', 20, '1234567890' + #8, 200, False, '',
      Application.Title, 'Qual o Código de Barras ?', '');
    if codbar = '*' then
      exit;
  end;

  dm.IBselect.Close;
  dm.IBselect.SQL.Clear;
  // 'select p.cod from produto p where (p.codbar = :codbar) or (p.cod = (select cod from codbarras where codbar = :codbar))'
  // dm.IBselect.SQL.Add('select p.cod from produto p where (p.codbar = :codbar) or (p.cod = (select cod from codbarras where codbar = :codbar))');
  dm.IBselect.SQL.Add
    ('select p.cod, nome, p.codbar from produto p left join codbarras c on ((c.cod = p.cod)) where (p.codbar like '
    + QuotedStr('%' + codbar + '%') + ') or ((c.codbar like ' +
    QuotedStr('%' + codbar + '%') + ') )');
  // dm.IBselect.ParamByName('codbar').AsString := codbar;
  dm.IBselect.Open;

  if not dm.IBselect.IsEmpty then
  begin
    Result := dm.IBselect.FieldByName('cod').AsString;
  end
  else
    ShowMessage('Código de Barras nao Encontrado: ' + codbar);
  dm.IBselect.Close;
end;

function Tfuncoes.checaCodbar(vx_cod: String): boolean;
var
  ut: string;
  vx_ta, vx_soma, vx_ret, vx_i: integer;
  vx_cal: variant;
begin
  Result := False;
  ut := vx_cod;
  vx_cod := copy(vx_cod, 1, 12);
  vx_ta := length(vx_cod);
  vx_soma := 0;
  vx_ret := 0;
  if length(vx_cod) <> 12 then
  begin
    exit;
  end;

  FOR vx_i := 1 TO vx_ta do
  begin
    vx_cal := StrToInt(copy(vx_cod, vx_i, 1));

    IF (vx_i mod 2) = 0 then
      vx_cal := vx_cal * 3;
    vx_soma := vx_soma + vx_cal;
  end;

  WHILE (vx_soma / 10 <> trunc(vx_soma / 10)) do
  begin
    vx_ret := vx_ret + 1;
    vx_soma := vx_soma + 1;
  end;

  vx_cod := (trim(vx_cod) + trim(IntToStr(vx_ret)));

  if vx_cod = ut then
    Result := true;

end;

function checaCodbar(vx_cod: String): boolean;
var
  ut: string;
  vx_ta, vx_soma, vx_ret, vx_i: integer;
  vx_cal: variant;
begin
  Result := False;
  vx_cod := trim(vx_cod);
  ut := vx_cod;
  vx_cod := copy(vx_cod, 1, 12);
  vx_ta := length(vx_cod);
  vx_soma := 0;
  vx_ret := 0;
  if length(vx_cod) <> 12 then
  begin
    exit;
  end;

  if StrNum(vx_cod) = '000000000000' then
  begin
    exit;
  end;

  FOR vx_i := 1 TO vx_ta do
  begin
    vx_cal := StrToInt(copy(vx_cod, vx_i, 1));

    IF (vx_i mod 2) = 0 then
      vx_cal := vx_cal * 3;
    vx_soma := vx_soma + vx_cal;
  end;

  WHILE (vx_soma / 10 <> trunc(vx_soma / 10)) do
  begin
    vx_ret := vx_ret + 1;
    vx_soma := vx_soma + 1;
  end;

  vx_cod := (trim(vx_cod) + trim(IntToStr(vx_ret)));

  if vx_cod = ut then
    Result := true;

end;

function Tfuncoes.recuperaChaveNFe(const nota: string): string;
var
  arq: tstringList;
  fim, i: Smallint;
  tmp: string;
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
    arq := funcoes.listaArquivos(caminhoEXE_com_barra_no_final +
      'NFE\EMIT\*.xml');
    fim := arq.count - 1;

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
    Result := dm.IBselect.FieldByName('chave').AsString;
  end;

  dm.IBselect.Close;
end;

function Tfuncoes.listaArquivos(const pasta: String): tstringList;
Var
  SearchFile: TSearchRec;
  FindResult: integer;
begin
  Result := tstringList.Create;
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

function Tfuncoes.testaChaveNFE(chave: String): boolean;
var
  ini, fim: integer;
  total: currency;
  seq, dv, temp: string;
begin
  Result := False;
  seq := '';
  seq := '432' + funcoes.CompletaOuRepete('', '', '98765432', 5);
  total := 0;

  fim := length(chave) - 1;
  for ini := 1 to fim do
  begin
    try
      total := total + StrToCurr(seq[ini]) * StrToCurr(chave[ini]);
    except
      Result := False;
      exit;
    end;
  end;

  ini := (trunc(total) mod 11);
  ini := 11 - ini;
  if ini > 9 then
    ini := 0;
  dv := IntToStr(ini);

  if dv = chave[length(chave)] then
    Result := true
  else
    Result := False;

end;

function Tfuncoes.verSeExisteTabela(nome: String): boolean;
begin
  Result := False;
  dm.IBselect.Close;
  dm.IBselect.SQL.Clear;
  dm.IBselect.SQL.Add
    ('select rdb$relation_name from rdb$relations where (rdb$system_flag = 0) and (rdb$relation_name = '
    + QuotedStr(nome) + ')');
  dm.IBselect.Open;

  if dm.IBselect.IsEmpty then
    Result := False
  else
    Result := true;

  dm.IBselect.Close;
end;

procedure Tfuncoes.atualizaHoraDoPCapatirDoServidor();
var
  ip: string;
  SystemTime: TSystemTime;
  data: TDateTime;
begin
  ip := funcoes.buscaConfigNaPastaDoControlW('IPHora', '\\127.0.0.1');

  if ip = '\\127.0.0.1' then
  begin
    exit;
  end;

  dm.ibquery4.Close;
  dm.ibquery4.SQL.text :=
    'SELECT CAST (''NOW'' AS TIMESTAMP) as DATA FROM RDB$DATABASE';
  dm.ibquery4.Open;

  data := dm.ibquery4.FieldByName('DATA').AsDateTime;

  SystemTime.wYear   := YearOf(data);
  SystemTime.wMonth  := MonthOf(data);
  SystemTime.wDay    := DayOf(data);
  SystemTime.wHour   := HourOf(data);
  SystemTime.wMinute := MinuteOf(data);
  SystemTime.wSecond := SecondOf(data);
  SetLocalTime(SystemTime);

  dm.ibquery4.Close;

  // Label1.Caption := IBQuery1.fieldbyname('DATA').AsString;

  // WinExec(pansichar(ansistring('net time ' + ip + ' /set /y')), SW_HIDE);
end;

function Tfuncoes.atualizaAutomatico(): String;
begin
  ShowMessage(FormatDateTime('dd/MM/YYYY',FileDateToDateTime(FileAge('HTTP:\CONTROLW.ZZ.vc\ControlW.old'))));
end;

procedure Tfuncoes.marcarVendaExportada(nota: String);
begin
  dm.IBQuery1.Close;
  dm.IBQuery1.SQL.Clear;
  dm.IBQuery1.SQL.Add('update venda set exportado = 1 where nota = :nota');
  dm.IBQuery1.ParamByName('nota').AsString := nota;
  dm.IBQuery1.ExecSQL;

  dm.IBQuery1.Transaction.Commit;
end;

function Tfuncoes.verVendedor(numVendedor: String): String;
var
  pos: integer;
begin
  Result := '';
  dm.ibquery3.Close;
  dm.ibquery3.SQL.Clear;
  dm.ibquery3.SQL.Add('select nome from vendedor where cod = :cod');
  dm.ibquery3.ParamByName('cod').AsString := numVendedor;
  dm.ibquery3.Open;

  Result := STRZERO(StrToIntDef(numVendedor, 0), 4) + '-' +
    dm.ibquery3.FieldByName('nome').AsString;
  dm.ibquery3.Close;
end;

function Tfuncoes.gravaVendaSmallPendente(nota1: string): string;
var
  vend, descProd: string;
  qtd, regDav: integer;
  tot: currency;
begin
  // numPedido := funcoes.dialogo('generico',0,'1234567890'+#8,30, true,'',Application.Title,'Informe o Número Da Nota:',nota);
  // if numPedido = '*' then exit;

  dm.ibquery4.SQL.Clear;
  dm.ibquery4.SQL.Add
    ('select nota, desconto, data, total, vendedor, exportado from venda where (nota = :nota)');
  dm.ibquery4.ParamByName('nota').AsString := nota1;
  dm.ibquery4.Open;

  if dm.ibquery4.IsEmpty then
  begin
    dm.ibquery4.Close;
    ShowMessage('Nota ' + nota1 + ' Não Encontrada');
    exit;
  end;

  if dm.ibquery4.FieldByName('exportado').AsInteger = 1 then
  begin
    descProd := funcoes.dialogo('generico', 0, 'SN', 20, true, 'S',
      Application.Title,
      'A Nota Já foi Exportada. Deseja Exporta-la Novamente?(S/N)', 'S');
    if ((descProd = '*') or (descProd = 'N')) then
      exit;
  end;

  Result := '';
  try
    if not dmSmall.BdSmall.Connected then
      dmSmall.BdSmall.Connected := true;

    dmSmall.IBQuerySmall.Close;
    dmSmall.IBQuerySmall.SQL.Clear;
    dmSmall.IBQuerySmall.SQL.Add
      ('delete from orcament where cast(pedido as integer) = :nota');
    dmSmall.IBQuerySmall.ParamByName('nota').AsString := nota1;
    dmSmall.IBQuerySmall.ExecSQL;

    dmSmall.IBQuerySmall.Transaction.Commit;

    qtd := 0;
    regDav := StrToIntDef(Incrementa_Generator('SMALL', 0), 0);
    tot := 0;

    vend := dm.ibquery4.FieldByName('vendedor').AsString;
    vend := verVendedor(vend);

    dm.ibquery3.Close;
    dm.ibquery3.SQL.Clear;
    dm.ibquery3.SQL.Add
      ('select cod, quant, total, nota, data, p_venda from item_venda where nota = :nota');
    dm.ibquery3.ParamByName('nota').AsString := nota1;
    dm.ibquery3.Open;

    while not dm.ibquery3.Eof do
    begin
      dmSmall.IBQuerySmall.Close;
      dmSmall.IBQuerySmall.SQL.Clear;
      dmSmall.IBQuerySmall.SQL.Add
        ('update or insert into orcament (registro, codigo, descricao, medida, '
        + 'quantidade, unitario, total, data, tipo, pedido, vendedor )' +
        'values (:registro, :codigo, :descricao, :unMedida, ' +
        ':qtd, :unitario, :total, :data, :tipo, :pedido, :vendedor ) ' +
        'MATCHING (pedido, codigo, total, registro)');

      dm.IBselect.Close;
      dm.IBselect.SQL.Clear;
      dm.IBselect.SQL.Add
        ('select nome, cod, unid from produto where cod = :cod');
      dm.IBselect.ParamByName('cod').AsString :=
        dm.ibquery3.FieldByName('cod').AsString;
      dm.IBselect.Open;

      // incrementa numero de registro da tabela orcament
      regDav := regDav + 1;
      // grava cada item de venda na tabela orcament (DAV)

      dmSmall.IBQuerySmall.ParamByName('codigo').AsString :=
        STRZERO(dm.ibquery3.FieldByName('cod').AsString, 5);
      dmSmall.IBQuerySmall.ParamByName('descricao').AsString :=
        ve_descricao(dm.IBselect.FieldByName('nome').AsString,
        allTrim(copy(dm.IBselect.FieldByName('unid').AsString, 1, 3)));
      dmSmall.IBQuerySmall.ParamByName('unMedida').AsString :=
        copy(dm.IBselect.FieldByName('unid').AsString, 1, 3);
      dmSmall.IBQuerySmall.ParamByName('qtd').AsCurrency :=
        dm.ibquery3.FieldByName('quant').AsCurrency;
      dmSmall.IBQuerySmall.ParamByName('total').AsCurrency :=
        abs(dm.ibquery3.FieldByName('total').AsCurrency);
      dmSmall.IBQuerySmall.ParamByName('data').AsDateTime :=
        dm.ibquery4.FieldByName('data').AsDateTime;
      dmSmall.IBQuerySmall.ParamByName('tipo').AsString := 'ORCAME';
      dmSmall.IBQuerySmall.ParamByName('pedido').AsString :=
        STRZERO(dm.ibquery4.FieldByName('nota').AsString, 10);
      dmSmall.IBQuerySmall.ParamByName('unitario').AsCurrency :=
        dm.ibquery3.FieldByName('p_venda').AsCurrency;
      dmSmall.IBQuerySmall.ParamByName('registro').AsInteger := regDav;

      tot := tot + dm.ibquery3.FieldByName('total').AsCurrency;
      dmSmall.IBQuerySmall.ExecSQL;

      dm.ibquery3.Next;
    end;

    dm.IBselect.Close;

    dmSmall.IBQuerySmall.Close;
    dmSmall.IBQuerySmall.SQL.Clear;
    dmSmall.IBQuerySmall.SQL.Add
      ('update or insert into orcament (registro, codigo, descricao, medida, ' +
      'quantidade, unitario, total, data, tipo, pedido, vendedor )' +
      'values (:registro, :codigo, :descricao, :unMedida, ' +
      ':qtd, :unitario, :total, :data, :tipo, :pedido, :vendedor ) ' +
      'MATCHING (pedido, codigo, total)');

    // incrementa numero de registro da tabela orcament
    regDav := regDav + 1;

    dmSmall.IBQuerySmall.ParamByName('descricao').AsString := 'Desconto';
    dmSmall.IBQuerySmall.ParamByName('registro').AsInteger := regDav;
    dmSmall.IBQuerySmall.ParamByName('total').AsCurrency :=
      abs(tot - dm.ibquery4.FieldByName('total').AsCurrency);
    dmSmall.IBQuerySmall.ParamByName('data').AsDateTime :=
      dm.ibquery4.FieldByName('data').AsDateTime;
    dmSmall.IBQuerySmall.ParamByName('tipo').AsString := 'ORCAME';
    dmSmall.IBQuerySmall.ParamByName('pedido').AsString :=
      STRZERO(dm.ibquery4.FieldByName('nota').AsString, 10);;
    dmSmall.IBQuerySmall.ParamByName('vendedor').AsString := vend;

    dmSmall.IBQuerySmall.ExecSQL;

    // seta o generator para o ultimo registro

    reStartGenerator('SMALL', regDav);
    { dm.IBQuery2.Close;
      dm.IBQuery2.SQL.Clear;
      dm.IBQuery2.SQL.Add('ALTER SEQUENCE SMALL RESTART WITH ' + IntToStr(regDav));
      dm.IBQuery2.ExecSQL;
      dm.IBQuery2.Transaction.Commit;
    }
    dmSmall.IBQuerySmall.Transaction.Commit;
    dmSmall.BdSmall.Connected := False;
    funcoes.marcarVendaExportada(nota1);

    ShowMessage('A nota ' + nota1 + ' Foi Exportada');

  Except
    on e: exception do
    begin
      gravaErrosNoArquivo(e.Message, 'Funcoes', '210',
        'funcoes.gravaVendaSmallPendente');
      Result := e.Message;
      dmSmall.BdSmall.Connected := False;
      ShowMessage
        ('Não foi Possível Exportar o DAV. Verifique as Configurações e Tente Novamente.');
      exit;
    end;
  end;
end;

function Tfuncoes.incrementaGenSmall(nome, valor: String): integer;
begin
  Result := 0;
  dmSmall.BdSmall.Connected := true;
  dmSmall.IBQuery2.Close;
  dmSmall.IBQuery2.SQL.Clear;
  dmSmall.IBQuery2.SQL.Add('select gen_id(' + nome + ',' + valor +
    ') as venda from rdb$database');
  // dmSmall.IBQuery2.SQL.Add('ALTER SEQUENCE ' + gen + ' RESTART WITH ' + Valor);
  dmSmall.IBQuery2.Open;

  Result := StrToIntDef(dmSmall.IBQuery2.FieldByName('venda').AsString, 0);
  dmSmall.IBQuery2.Close;
end;

procedure Tfuncoes.restartGeneratorSMALL(gen, valor: String);
begin
  dmSmall.BdSmall.Connected := true;
  dmSmall.IBQuery2.Close;
  dmSmall.IBQuery2.SQL.Clear;
  dmSmall.IBQuery2.SQL.Add('ALTER SEQUENCE ' + gen + ' RESTART WITH ' + valor);
  dmSmall.IBQuery2.ExecSQL;

  dmSmall.IBQuery2.Transaction.Commit;
end;

procedure Tfuncoes.executaCalculadora();
begin
  RxCalculator1.Title := 'ControlW Calculadora';
  RxCalculator1.Execute;
end;

function Tfuncoes.GerarCodigo(Codigo: String; imagem1: TImage): integer;
const
  digitos: array ['0' .. '9'] of string[5] = ('00110', '10001', '01001',
    '11000', '00101', '10100', '01100', '00011', '10010', '01010');
var
  s: string;
  i, j, x, t, tot: integer;
begin
  // Gerar o valor para desenhar o código de barras
  // Caracter de início
  tot := 0;
  s := '0000';
  for i := 1 to length(Codigo) div 2 do
    for j := 1 to 5 do
      s := s + copy(digitos[Codigo[i * 2 - 1]], j, 1) +
        copy(digitos[Codigo[i * 2]], j, 1);
  // Caracter de fim
  s := s + '100';
  // Desenhar em um objeto canvas
  // Configurar os parâmetros iniciais
  x := 0;
  // Pintar o fundo do código de branco
  imagem1.Canvas.Brush.color := clWhite;
  imagem1.Canvas.Pen.color := clWhite;
  imagem1.Canvas.Rectangle(0, 0, 2000, 79);
  // Definir as cores da caneta
  imagem1.Canvas.Brush.color := clBlack;
  imagem1.Canvas.Pen.color := clBlack;
  // Escrever o código de barras no canvas
  for i := 1 to length(s) do
  begin
    // Definir a espessura da barra
    t := StrToInt(s[i]) * 2 + 1;
    // Imprimir apenas barra sim barra não (preto/branco - intercalado);
    if i mod 2 = 1 then
      imagem1.Canvas.Rectangle(x, 0, x + t, 79);
    // Passar para a próxima barra
    x := x + t;
    imagem1.Width := x + 10;
  end;
  imagem1.Canvas.Brush.color := clWhite;
  imagem1.Canvas.Pen.color := clWhite;
  imagem1.Canvas.Font.color := clBlack;
  tot := imagem1.Canvas.TextWidth(Codigo);
  // centraliza o numero do codigo de barras na imagem
  imagem1.Canvas.TextOut(trunc((x - tot) / 2), 82, Codigo);
  Result := x + 5;
end;

function Tfuncoes.verificaConexaoComInternetSeTiverTRUEsenaoFALSE: boolean;
var
  Flags: Cardinal;
begin
  Result := False;
  if not InternetGetConnectedState(@Flags, 0) then
    Result := False
  else if (Flags and INTERNET_CONNECTION_LAN) <> 0 then
    Result := true
  else if (Flags and INTERNET_CONNECTION_PROXY) <> 0 then
    Result := true
  else
    Result := true;
end;

function GetFileList(const path: string): tstringList;
var
  i: integer;
  SearchRec: TSearchRec;
begin
  Result := tstringList.Create;
  try
    i := FindFirst(path, 0, SearchRec);
    while i = 0 do
    begin
      Result.Add(SearchRec.Name);
      i := FindNext(SearchRec);
    end;
  except
    Result.Free;
    raise;
  end;
end;

function Tfuncoes.verEquivalencia(cod: String): String;
var
  list1: tstringList;
  ar: string;
  i: integer;
begin
  if cod = '' then
  begin
    ShowMessage('Este produto não possui Equivalências');
    exit;
  end;
  ar := '';
  list1 := tstringList.Create;
  list1.Add(cod);

  dm.ibquery4.Close;
  dm.ibquery4.SQL.Clear;
  dm.ibquery4.SQL.Add
    ('select refori, codbar from produto where ((codbar = :cod) or (refori = :cod))');
  dm.ibquery4.ParamByName('cod').AsString := cod;
  dm.ibquery4.Open;

  while not dm.ibquery4.Eof do
  begin
    list1.Add(dm.ibquery4.FieldByName('codbar').AsString);

    dm.ibquery3.Close;
    dm.ibquery3.SQL.Clear;
    dm.ibquery3.SQL.Add
      ('select refori, codbar from produto where ((codbar = :cod) or (refori = :cod))');
    dm.ibquery3.ParamByName('cod').AsString := list1[list1.count - 1];
    dm.ibquery3.Open;

    while not dm.ibquery3.Eof do
    begin
      list1.Add(dm.ibquery4.FieldByName('codbar').AsString);
      dm.ibquery3.Next;
    end;
    dm.ibquery4.Next;
  end;

  dm.ibquery3.Close;
  dm.ibquery4.Close;
  { while true do
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
    end; }
  if list1.count = 1 then
  begin
    ShowMessage('Este produto não possui Equivalências');
    exit;
  end;

  ar := QuotedStr(list1.Strings[0]) + ',';
  for i := 1 to list1.count - 1 do
  begin
    ar := ar + QuotedStr(list1.Strings[i]) + iif(list1.count - 1 = i, '', ',');
  end;

  // ShowMessage(ar);
  dm.produtotemp.Close;
  dm.produtotemp.SQL.Clear;
  dm.produtotemp.SQL.Add
    ('select codbar, nome as Descricao,p_venda as Preco,quant as estoque,cod, refori as '
    + refori1 + ' from produto where codbar in (' + ar +
    ') order by descricao');
  dm.produtotemp.Open;
  funcoes.FormataCampos(dm.produtotemp, 2, '', 2);

  form25 := tform25.Create(self);
  funcoes.CtrlResize(TForm(form25));
  form25.DBGrid1.DataSource := dm.dsprodtemp;
  form25.ShowModal;

end;

function Tfuncoes.troca_str(texto, valor, novo: string): string;
begin
  Result := '';
  if pos(valor, texto) > 0 then
  begin
    Result := copy(texto, 1, pos(valor, texto) - 1) + novo +
      copy(texto, pos(valor, texto) + length(valor), length(texto));
  end
  else
  begin
    Result := texto;
  end;
end;

FUNCTION DIGEAN(vx_cod: string): string;
var
  vx_ta, vx_soma, vx_ret, vx_i: integer;
  vx_cal: variant;
begin
  vx_ta := length(vx_cod);
  vx_soma := 0;
  vx_ret := 0;
  if length(vx_cod) <> 12 then
  begin
    Result := vx_cod;
    exit;
  end;
  FOR vx_i := 1 TO vx_ta do
  begin
    vx_cal := StrToInt(copy(vx_cod, vx_i, 1));

    IF (vx_i mod 2) = 0 then
      vx_cal := vx_cal * 3;
    vx_soma := vx_soma + vx_cal;
  end;

  WHILE (vx_soma / 10 <> trunc(vx_soma / 10)) do
  begin
    vx_ret := vx_ret + 1;
    vx_soma := vx_soma + 1;
  end;
  Result := (trim(vx_cod) + trim(IntToStr(vx_ret)));
end;

function maior(v1, v2: variant): variant;
begin
  Result := 0;
  if v1 > v2 then
    Result := v1
  else
    Result := v2;
end;

function Tfuncoes.dataDoArquivo(const fileName: string): TDateTime;
begin
  Result := FileDateToDateTime(FileAge(fileName));
end;

function FileAgeCreate(const fileName: string): String;
var
  ff: string;
begin
  Result := FormatDateTime('yy.mm.dd', FileDateToDateTime(FileAge(fileName)));
  // copy(ff, 9, 2) + '.' + copy(ff, 4, 2) + '.' + copy(ff, 1, 2);
end;

function Tfuncoes.verificaPermissaoPagamento(const abreTelaBloqueado
  : boolean = true; abrirDialogo : boolean = true): String;
var
  th, tmt: tstringList;
  arquivo1: TFileStream;
  tst: boolean;
  i, a, dias: integer;
  tft, tmpi: string;
  query: TIBQuery;
begin
  query := TIBQuery.Create(self);
  query.Database := dm.bd;
  Result := '';

  try
    tmpi := '';
    tmpi := funcoes.addRegSite('', query, abrirDialogo);

    if tmpi = '' then
      exit;

    if funcoes.Contido('-4-', tmpi) then
    begin
      Result := '4';
      exit;
    end;

    if funcoes.Contido('-6-', tmpi) then
    begin
      funcoes.limpaBloqueado(query1);
    end;

    if funcoes.Contido('-BLOQUEADO-', tmpi) then
    begin
      if funcoes.Contido('-2-', tmpi) then
      begin
        adicionaRegistrosBloqueio;
      end;

      try
        dias := StrToIntDef(tmt.Values['3'], 15);
        if dias = 0 then
          dias := 15;
      except
        dias := 15;
      end;

      funcoes.adicionaRegistroDataBloqueio(abreTelaBloqueado, true, dias,
        query, true);
    end;

    if funcoes.Contido('-DESBLOQUEADO-', tmpi) then
    begin
      funcoes.limpaBloqueado(query);
    end;

  except
    try
     pergunta1.close;
    finally
    end;
    query.Free;
    Result := 'ERRO';
    exit;
  end;

  query.Free;
end;

procedure Tfuncoes.adicionaConfig(valorQueProvavelmenteExiste,
  NovoValor: string);
var
  i: integer;
  tmp: string;
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
var
  qtd, aliq, fim, atual: integer;
  cbr, codSeq, _cst, _st, uni, titulo: string;
  contagemErroBd: integer;
  quant: currency;
begin
  titulo := funcoes.dialogo('generico', 30, '1234567890' + #8, 30, False, '',
    Application.Title, 'Escolha uma Opção:' + #13 + #10 +
    '1 - Exclui Produtos SMALLSOFT' + #13 + #10 +
    '2 - Adiciona 1000 no Estoque', '');
  if titulo = '*' then
    exit;

  try
    dmSmall.BdSmall.Connected := true;
    atual := 0;
    dm.IBselect.Close;
    dm.IBselect.SQL.Clear;
    dm.IBselect.SQL.Add
      ('select cod, nome, unid, codbar, refori, aliquota, p_compra, p_venda, quant from produto');
    dm.IBselect.Open;
    dm.IBselect.FetchAll;

    fim := dm.IBselect.RecordCount;

    if (titulo = '1') then
    begin
      funcoes.informacao(1, 2, 'Excluindo... ', true, False, 2);
      dmSmall.IBQuerySmall.SQL.Clear;
      dmSmall.IBQuerySmall.SQL.Add('delete from estoque');
      dmSmall.IBQuerySmall.Open;
      dmSmall.IBQuerySmall.Close;
    end;

    // Memo1.Lines.Add('Exportando dados do Control Estoque...');
    funcoes.informacao(1, fim, 'Exportando dados do Control Estoque...', true,
      False, 2);
    qtd := 0;
    while (not dm.IBselect.Eof) do
    begin
      qtd := qtd + 1;
      if round(qtd / fim * 100) <> atual then
      begin
        atual := round(qtd / fim * 100);
        funcoes.informacao(dm.IBselect.RecNo, fim,
          'Exportando dados do Control Estoque...', False, False, 2);
        Application.ProcessMessages;
      end;

      // unidade
      uni := trim(copy(dm.IBselect.FieldByName('unid').AsString, 1, 3));

      // quantidade em estoque
      quant := dm.IBselect.FieldByName('quant').AsCurrency;
      if quant < 0 then
        quant := 0;
      // se a quantidade for zero ou menor informa 1000
      if ((quant = 0) or (titulo = '2')) then
        quant := quant + 1000.00;

      // código de barras
      cbr := dm.IBselect.FieldByName('codbar').AsString;
      if ((copy(cbr, 1, 1) = '2') and (length(cbr) <= 9)) then
      begin
        if (copy(cbr, 6, 1) = '1') then
          uni := 'KU'
        else
          uni := 'KG';
        cbr := (copy(cbr, 1, 5) + '00')
      end
      else
        cbr := copy(cbr, 1, 14);

      cbr := trim(cbr);

      // codSeq := strzero(QueryControlProd.fieldbyname('cod').AsInteger, 5);
      codSeq := dm.IBselect.FieldByName('cod').AsString;
      _st := dm.IBselect.FieldByName('aliquota').AsString;
      _st := trim(_st);
      if (_st = '') then
        _st := '0';
      if (_st = '0') then
        aliq := 0
      else if (StrToInt(_st) <= 12) then
        aliq := StrToInt(_st)
      else
        aliq := 0;

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
      dmSmall.IBQuerySmall.SQL.Add
        ('update or insert into estoque (registro, codigo, referencia, ' +
        'medida, descricao, custocompr, preco, qtd_atual, cst, csosn, st)' +
        'values (:cod10, :cod5, :codbar, :unid, :nome, :p_compra, :p_venda, :quant, :cst, :csosn, :st) '
        + 'MATCHING (registro)');
      dmSmall.IBQuerySmall.ParamByName('cod10').AsString := '00000' + codSeq;
      dmSmall.IBQuerySmall.ParamByName('cod5').AsString := codSeq;
      dmSmall.IBQuerySmall.ParamByName('codbar').AsString := cbr;
      dmSmall.IBQuerySmall.ParamByName('unid').AsString := uni;
      dmSmall.IBQuerySmall.ParamByName('nome').AsString :=
        ve_descricao(dm.IBselect.FieldByName('nome').AsString, uni);
      dmSmall.IBQuerySmall.ParamByName('p_compra').AsCurrency :=
        dm.IBselect.FieldByName('p_compra').AsCurrency;
      dmSmall.IBQuerySmall.ParamByName('p_venda').AsCurrency :=
        dm.IBselect.FieldByName('p_venda').AsCurrency;
      dmSmall.IBQuerySmall.ParamByName('quant').AsCurrency := quant;
      dmSmall.IBQuerySmall.ParamByName('cst').AsString := _cst;
      dmSmall.IBQuerySmall.ParamByName('csosn').AsString := '101';
      dmSmall.IBQuerySmall.ParamByName('st').AsString := _st;
      try
        dmSmall.IBQuerySmall.Open;
      except
      end;
      dm.IBselect.Next;
    end;
    // ShowMessage('Exportação de dados Concluída: ' + inttostr(qtd) + ' itens exportados');
  except
    on e: exception do
    begin
      ShowMessage('Erro(converteDados): ' + e.Message);
      contagemErroBd := contagemErroBd + 1;
      dmSmall.BdSmall.Connected := False;
    end;
  end;

  dmSmall.IBQuerySmall.Close;
  dmSmall.BdSmall.Connected := False;
  dm.IBselect.Close;
  funcoes.informacao(0, 1, '', False, true, 2);
end;

procedure Tfuncoes.atualizaBD;
var
  tt: tstringList;
  parametros: String;
begin
  tt := tstringList.Create;
  tt.Add('11');
  tt.SaveToFile(caminhoEXE_com_barra_no_final + 'bd0.fdb');
  tt.Free;

  parametros := ParamStr(1) + ' ' + ParamStr(2);
  parametros := trim(parametros);

  { if ParamCount = 0 then
    begin
    ShellExecute(handle,'open',PChar(ExtractFileDir(ParamStr(0)) + '\C.exe'), pwidechar(parametros),'',SW_SHOWNORMAL);
    tt := tstringList.Create;
    tt.Add('@echo off');
    tt.Add('timeout 1 /nobreak');
    tt.Add('start ' + ' ' + ParamStr(0));
    tt.Add('exit');
    tt.SaveToFile(caminhoEXE_com_barra_no_final + 'exec.bat');
    tt.Free;

    WinExec(pansichar(caminhoEXE_com_barra_no_final + 'exec.bat'), SW_HIDE);
    end; }

  ShellExecute(Handle, 'open', PChar(ExtractFileDir(ParamStr(0)) + '\' +
    ExtractFileName(ParamStr(0))), pwidechar(parametros), '', SW_SHOWNORMAL);
  Application.Terminate;
end;

procedure Tfuncoes.adicionarExcecao;
begin
  if MessageDlg('Deseja Adcionar Exceção do Firebird no Firewall do Windows?',
    mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  begin
    WinExec('netsh.exe -c firewall add portopening protocol=TCP port=3050 name=Teste mode=ENABLE scope=SUBNET',
      SW_HIDE);
  end
  else
    Application.Terminate;
end;

function gravaErrosNoArquivo(erro, Formulario, linha, funcao: String): String;
var
  tem: tstringList;
begin
  tem := tstringList.Create;
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

  tem.Add('--------------------------------------------');
  tem.Add('formulario: ' + Formulario);
  tem.Add('erro: ' + erro);
  tem.Add('linha: ' + linha);
  tem.Add('função: ' + funcao);
  tem.SaveToFile(caminhoEXE_com_barra_no_final + 'errolog.txt');
end;

function reStartGenerator(nome: string; valor: integer): String;
begin
  dm.ibquery4.Close;
  dm.ibquery4.SQL.Clear;
  dm.ibquery4.SQL.Add('ALTER SEQUENCE ' + nome + ' RESTART WITH ' +
    IntToStr(valor));
  dm.ibquery4.ExecSQL;

  dm.ibquery4.Transaction.Commit;
  Result := '';
end;

function MessageText(wmessage: String; flColor: TColor;
  flBold, flItalic: boolean; WWFormColor: TColor): String;
begin
  Form42 := TForm42.Create(Application);
  Form42.defineScreenSave(3, '');
  Form42.WindowState := wsNormal;
  Form42.label1.caption := wmessage;
  Form42.label1.Font.color := flColor;
  Form42.color := WWFormColor;
  Form42.Width := Form42.label1.Width + 40;
  Form42.Height := Form42.label1.Height + 100;
  Form42.label1.Top := trunc((Form42.Height - Form42.label1.Height) / 2);
  Form42.ShowModal;
  Form42.Free;
end;

function formataDataDDMMYY(data: TDateTime): String;
begin
  Result := '';
  Result := FormatDateTime('dd/mm/yy', data);
end;

function verificaSeTemImpressora(): boolean;
begin
  Result := False;
  if printer.printers.count > 0 then
    Result := true
  else
    Result := False;
end;

function Tfuncoes.verificaCodbar(cod, codbar: string; opcao: Smallint): String;
var
  res: Smallint;
  sim, tes: String;
begin
  Result := '';
  tes := '';
  res := 0;

  dm.IBselect.Close;
  dm.IBselect.SQL.Clear;
  dm.IBselect.Close;
  dm.IBselect.SQL.Clear;
  if opcao = 0 then
    dm.IBselect.SQL.Add
      ('select c.cod, c.codbar from produto c where ((c.codbar = :cod) and (c.cod <> :cod1))')
  else
    dm.IBselect.SQL.Add
      ('select c.cod, c.codbar from produto c where ((c.codbar = :cod))');
  dm.IBselect.ParamByName('cod').AsString := codbar;
  if opcao = 0 then
    dm.IBselect.ParamByName('cod1').AsString := cod;
  dm.IBselect.Open;

  if not dm.IBselect.IsEmpty then
  begin
    tes := '1';
    while not dm.IBselect.Eof do
    begin
      Result := Result + ' Código: ' + dm.IBselect.FieldByName('cod').AsString +
        ' CodBarras: ' + dm.IBselect.FieldByName('codbar').AsString + #13 + #10;
      dm.IBselect.Next;
    end;
  end;

  dm.IBselect.Close;
  dm.IBselect.SQL.Clear;
  if opcao = 0 then
    dm.IBselect.SQL.Add
      ('select c.cod, c.codbar from codbarras c where ((c.codbar = :cod) and (c.cod <> :cod1))')
  else
    dm.IBselect.SQL.Add
      ('select c.cod, c.codbar from codbarras c where ((c.codbar = :cod))');
  dm.IBselect.ParamByName('cod').AsString := codbar;
  if opcao = 0 then
    dm.IBselect.ParamByName('cod1').AsString := cod;
  dm.IBselect.Open;

  if not dm.IBselect.IsEmpty then
  begin
    tes := tes + '2';
    while not dm.IBselect.Eof do
    begin
      Result := Result + ' Código: ' + dm.IBselect.FieldByName('cod').AsString +
        ' CodBarras: ' + dm.IBselect.FieldByName('codbar').AsString + #13 + #10;
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
    Result := 'Código de barras já foi cadastrado no produto: ' + #13 +
      #10 + Result;
  end;

  dm.IBselect.Close;
  if Result <> '' then
  begin
    ShowMessage(Result);

    { sim := funcoes.dialogo('generico',0,'SN',0,false,'S','Control For Windows','Deseja Excluir essa Referência ?','N');
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

      if dm.IBQuery2.Transaction.InTransaction then dm.IBQuery2.Transaction.Commit; }
  end;

end;

procedure EmptyTList(Var AList: Tlist);
var
  intContador: integer;
begin
  for intContador := (AList.count - 1) Downto 0 do
  begin
    Dispose(AList.Items[intContador]);
    AList.Delete(intContador);
  end;
end;

procedure Tfuncoes.CentralizaNoFormulario(var compo: TWinControl;
  var send: TForm);
begin
  TLabel(compo).Left := trunc((send.Width - TLabel(compo).Width) / 2);
end;

procedure Tfuncoes.SetRetornoBusca(ret: string);
begin
  retornobusca := ret;
end;

function Incrementa_Generator(Gen_name: string;
  valor_incremento: integer): string;
begin
  dm.IBQuery1.Close;
  dm.IBQuery1.SQL.Clear;
  dm.IBQuery1.SQL.Add('select gen_id(' + Gen_name + ',' +
    IntToStr(valor_incremento) + ') as venda from rdb$database');
  dm.IBQuery1.Open;

  Result := '';
  Result := dm.IBQuery1.FieldByName('venda').AsString;

  dm.IBQuery1.Close;
end;

procedure Tfuncoes.MeuKeyPress1(Sender: TObject; var Key: Char);
begin
  if saiComEnter then
  begin
    if (Key = #13) then
      pergunta1.Close;
  end;

  if (Key = #27) then
    pergunta1.Close;
end;

FUNCTION Tfuncoes.MensagemTextoInput(caption, default: string): string;
begin

  //if NOT Assigned(pergunta1) then
  pergunta1 := Tpergunta1.Create(self);
  if caption = '' then
    pergunta1.caption := Application.Title
  else
    pergunta1.caption := caption;
  pergunta1.option := 2;
  pergunta1.gauge1.Visible := False;
  pergunta1.label1.Visible := False;
  // pergunta1.Label1.Caption := Mensagem;
  pergunta1.label1.Font.color := clRed;
  CtrlResize(TForm(pergunta1));

  pergunta1.tipo := 'texto';
  pergunta1.memo1 := TMemo.Create(self);
  //pergunta1.memo1.Name := 'memo1';
  pergunta1.memo1.Parent := pergunta1;
  pergunta1.memo1.Align := alClient;
  pergunta1.memo1.text := default;

  if default = 'XX' then
  begin
    pergunta1.memo1.text := '';
    saiComEnter := False;
  end;

  pergunta1.memo1.OnKeyPress := MeuKeyPress1;

  pergunta1.ShowModal;

  saiComEnter := true;
  Result := pergunta1.memo1.text;

  TRY

  FINALLY

  END;
  exit;

  Result := '';
  Result := valordg;
end;

function RetornaValorStringList(var ent: tstringList; estring: string): string;
var
  i: integer;
begin
  cont := ent.count - 1;
  Result := '';
  for i := 0 to cont do
  begin
    if funcoes.Contido(estring, ent.Strings[i]) then
    begin
      Result := ent.Strings[i];
      exit;
    end;
  end;
end;

procedure Tfuncoes.Button1Click(Sender: TObject);
begin
  TForm(Sender).Close;
end;

FUNCTION Tfuncoes.Mensagem(caption: String; Mensagem: string; FontSize: integer;
  fonteLetra: string; btOk: boolean; option: integer; color: TColor; fechar : boolean = false): string;
var
  label123: TLabel;
begin
  if fechar then begin
    try
      pergunta1.Close;
      pergunta1.Free;
    finally

    end;
    exit;
  end;

  {try
  if assigned(pergunta1) then begin
  if pergunta1.Showing then  begin
    funcoes.Mensagem(Application.Title, '', 15, '',False, 0, clBlack, true);
    pergunta1.Free;
  end;
  end;
  finally

  end;}


  //if NOT Assigned(pergunta1) then
  pergunta1 := Tpergunta1.Create(self);
  
  pergunta1.option := option;
  // pergunta1.Gauge1.Progress := 0;
  // pergunta1.Timer1.Enabled := true;
  pergunta1.caption := caption;

  pergunta1.label1.caption := Mensagem;
  pergunta1.label1.Font.color := color;
  CtrlResize(TForm(pergunta1));
  pergunta1.label1.Font.Name := fonteLetra;
  pergunta1.label1.Font.Size := FontSize;
  pergunta1.label1.Font.Style := [fsbold];
  pergunta1.label1.Left := 10;

  // funcoes.CentralizaNoFormulario(twincontrol(pergunta1),tform(pergunta1));

  if pergunta1.label1.Width + pergunta1.label1.Left >= pergunta1.Width then
    pergunta1.Width := pergunta1.label1.Width + pergunta1.label1.Left + 15;
  if pergunta1.label1.Height + pergunta1.label1.Top + 50 >= pergunta1.Height
  then
    pergunta1.Height := pergunta1.label1.Height + pergunta1.label1.Top + 50;

  if btOk then
  begin
    pergunta1.gauge1.Enabled := False;
    pergunta1.gauge1.Visible := False;
    botao := TsButton.Create(self);
    //botao.Name := 'Button2';
    botao.Height := 25;
    botao.Width := 72;
    botao.Parent := pergunta1;
    botao.caption := 'Ok';
    botao.Left := 0;
    botao.Top := (pergunta1.Height - botao.Height) - 30;
    botao.OnClick := pergunta1.sButton1Click;
    botao.Left := trunc((pergunta1.Width / 2) - botao.Width);
    pergunta1.setButton(botao);
    // funcoes.CentralizaNoFormulario(twincontrol(botao), tform(pergunta1));
  end;
  // pergunta1.Height := 400;
  pergunta1.label1.AutoSize := true;
  pergunta1.label1.Left := 20;
  pergunta1.Show;

  TRY
  //pergunta1.DestroyComponents;
  //pergunta1.Destroy;
  //pergunta1.Free;
  FINALLY

  END;
  { botao.Free;
    pergunta1.Free;
  } end;

FUNCTION STR_ALFA(PAR: string): string;
var
  ini, LIN, fim: integer;
  VALIDO: string;
begin
  VALIDO := ',.-/0123456789ABCDEFGHIJKLMNOPQRSTUVXWYZ';
  Result := '';
  fim := length(PAR);
  FOR ini := 1 TO fim do
  begin
    IF funcoes.Contido(UpperCase(PAR[ini]), VALIDO) THEN
      Result := Result + PAR[ini]
    ELSE
      Result := Result + ' ';
  end;
end;

procedure Retorna_Array_de_Numero_de_Notas(var mat: tstringList; notas: string;
  const separador: String = ' ');
var
  ini, fim, posi: integer;
begin
  mat := tstringList.Create;
  fim := length(trim(notas));
  notas := trim(notas);
  posi := 1;
  for ini := 1 to fim do
  begin
    if notas[ini] = separador then
    begin
      mat.Add(copy(notas, posi, ini - posi));
      posi := ini + 1;
    end;
    if (mat.count <> 0) and (ini = fim) then
      mat.Add(copy(notas, posi, fim - posi + 1));
  end;
  if mat.count = 0 then
    mat.Add(notas);
end;

function VerificaCampoTabela(nomeCampo, tabela: string): boolean;
var
  texto: string;
  ini: integer;
begin
  Result := False;
  dm.IBselect.Close;
  dm.IBselect.SQL.Clear;
  dm.IBselect.SQL.Add('select * from ' + tabela);
  dm.IBselect.Open;

  for ini := 0 to dm.IBselect.FieldList.count - 1 do
  begin
    if UpperCase(nomeCampo) = UpperCase(dm.IBselect.FieldList[ini].FieldName)
    then
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
    end; }
end;

procedure Tfuncoes.VerificaVersao_do_bd;
var
  versao_BD, msg: string;
  tmp, i, fim: integer;
  alt: boolean;
  arq, pger, unid: tstringList;
  versao: currency;
begin
  if not FileExists(caminhoEXE_com_barra_no_final + 'bd0.fdb') then
    exit;

  try
    corrigeUnidades;
  finally

  end;

  pger := tstringList.Create;

  pger.Add('0=F'); // 0
  pger.Add('1=0123456789'); // 1
  pger.Add('2=S'); // 2
  pger.Add('3=S'); // 3
  pger.Add('4=S'); // 4
  pger.Add('5=N'); // 5
  pger.Add('6=0,33'); // 6
  pger.Add('7=Rota'); // 7
  pger.Add('8=1'); // 8
  pger.Add('9=S'); // 9
  pger.Add('10=3'); // 10
  pger.Add('11=0,65'); // 11
  pger.Add('12=3,00'); // 12
  pger.Add('13=N'); // 13
  pger.Add('14=N'); // 14
  pger.Add('15=N'); // 15
  pger.Add('16=N'); // 16
  pger.Add('17=N'); // 17
  pger.Add('18=45'); // 18
  pger.Add('19=S'); // 19
  pger.Add('20=N'); // 20
  pger.Add('21=S'); // 21
  pger.Add('22=N'); // 22
  pger.Add('23=2'); // 23
  pger.Add('24=5'); // 24
  pger.Add('25=3'); // 25
  pger.Add('26=N'); // 26
  pger.Add('27=S'); // 27
  pger.Add('28=0,00'); // 28
  pger.Add('29=0,00'); // 29
  pger.Add('30=N'); // 30
  pger.Add('31=N'); // 31
  pger.Add('32=N'); // 32
  pger.Add('33=D'); // 33
  pger.Add('34=S'); // 34
  pger.Add('35=S'); // 35
  pger.Add('36=S'); // 36
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

  alt := False;

  try
    dm.IBselect.Close;
    dm.IBselect.SQL.text :=
      'select nota from speddadosadic where toticms_deson > 0 and totdesc > 0';
    dm.IBselect.Open;

    if not dm.IBselect.IsEmpty then
    begin
      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.text :=
        'update speddadosadic s set s.totdescnt = s.totdescnt + s.totdesc,' +
        's.totdesc = 0 where s.toticms_deson > 0 and s.totdesc > 0';
      dm.IBQuery1.ExecSQL;
    end;
  except
  end;

  if not VerificaCampoTabela('VERSAO1', 'REGISTRO') then
  begin
    dm.IBQuery1.Close;
    dm.IBQuery1.SQL.text :=
      ('ALTER TABLE REGISTRO ' + 'ADD VERSAO1 NUMERIC(3, 2) DEFAULT 0 ');
    dm.IBQuery1.ExecSQL;
    dm.IBQuery1.Close;
    dm.IBQuery1.Transaction.Commit;

    dm.IBQuery1.Close;
    dm.IBQuery1.SQL.text := 'update REGISTRO set VERSAO1 = 0';
    dm.IBQuery1.ExecSQL;
    dm.IBQuery1.Transaction.Commit;
  end;

  dm.IBselect.Close;
  dm.IBselect.SQL.text := 'select versao1 from registro';
  dm.IBselect.Open;

  versao := dm.IBselect.FieldByName('versao1').AsCurrency;

  { dm.IBselect.Close;
    dm.IBselect.SQL.Text := 'select v.nota from venda v where ((select count(*) from nfe n where v.nota = ' +
    'cast(substring(n.chave from 36 for 8) as integer)) > 0) and trim(v.entrega) = '''' ';
    dm.IBselect.Open;

    if dm.IBselect.IsEmpty = false then begin
    dm.IBQuery1.Close;
    dm.IBQuery1.SQL.Text := 'update venda v set entrega = ''N'' where(select count(*) from nfe n ' +
    'where v.nota = cast(substring(n.chave from 36 for 8) as integer)) > 0  and trim(v.entrega) = '''' ';
    dm.IBQuery1.ExecSQL;
    end; }

  if versao <= 0 then
  begin

    if not VerificaCampoTabela('NOME', 'ITEM_ORCAMENTO') then
    begin
      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.text :=
        ('ALTER TABLE ITEM_ORCAMENTO ' + 'ADD NOME VARCHAR(40) DEFAULT '''' ');
      dm.IBQuery1.ExecSQL;
      dm.IBQuery1.Close;
      dm.IBQuery1.Transaction.Commit;

      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.text := 'update ITEM_ORCAMENTO set nome = ''''';
      dm.IBQuery1.ExecSQL;
      dm.IBQuery1.Transaction.Commit;
    end;

    if not VerificaCampoTabela('NOME', 'ITEM_VENDA') then
    begin
      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.text :=
        ('ALTER TABLE ITEM_VENDA ' + 'ADD NOME VARCHAR(40) DEFAULT '''' ');
      dm.IBQuery1.ExecSQL;
      dm.IBQuery1.Close;
      dm.IBQuery1.Transaction.Commit;

      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.text := 'update ITEM_VENDA set nome = ''''';
      dm.IBQuery1.ExecSQL;
      dm.IBQuery1.Transaction.Commit;
    end;

    if not VerificaCampoTabela('VENDEDOR', 'ITEM_VENDA') then
    begin
      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.text :=
        ('ALTER TABLE ITEM_VENDA ' + 'ADD VENDEDOR VARCHAR(3) DEFAULT '''' ');
      dm.IBQuery1.ExecSQL;
      dm.IBQuery1.Close;
      dm.IBQuery1.Transaction.Commit;

      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.text :=
        'UPDATE ITEM_VENDA I SET VENDEDOR = (SELECT VENDEDOR FROM VENDA V WHERE V.NOTA = I.NOTA)';
      dm.IBQuery1.ExecSQL;
      dm.IBQuery1.Transaction.Commit;
    end;

    if not VerificaCampoTabela('CRED_ICMS', 'ITEM_ENTRADA') then
    begin
      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.text :=
        ('ALTER TABLE ITEM_ENTRADA ' +
        'ADD CRED_ICMS NUMERIC(15,6) DEFAULT 0 ');
      dm.IBQuery1.ExecSQL;
      dm.IBQuery1.Close;
      dm.IBQuery1.Transaction.Commit;

      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.text := 'update ITEM_ENTRADA set CRED_ICMS = 0';
      dm.IBQuery1.ExecSQL;
      dm.IBQuery1.Transaction.Commit;
    end;

    if not VerificaCampoTabela('DATA_MOV', 'REGISTRO') then
    begin
      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add('ALTER TABLE REGISTRO ' + 'ADD DATA_MOV DATE ' +
        'DEFAULT ' + QuotedStr('01.01.1900'));
      dm.IBQuery1.ExecSQL;
      dm.IBQuery1.Close;
      dm.IBQuery1.Transaction.Commit;

      // pega a data atual do BD
      dm.IBselect.Close;
      dm.IBselect.SQL.Clear;
      dm.IBselect.SQL.Add('select current_date as data from rdb$database');
      dm.IBselect.Open;

      // atualiza a data de movimento pra a data atual do bd
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add('update registro set data_mov = :datamov');
      dm.IBQuery1.ParamByName('datamov').AsDateTime :=
        dm.IBselect.FieldByName('data').AsDateTime;
      dm.IBQuery1.ExecSQL;
      dm.IBQuery1.Close;

      dm.IBselect.Close;
      dm.IBQuery1.Transaction.Commit;
      alt := true;
    end;

    if not VerificaCampoTabela('DESC_COMP', 'PRODUTO') then
    begin
      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add
        ('ALTER TABLE PRODUTO ADD DESC_COMP NUMERIC(10, 3) DEFAULT 0');
      dm.IBQuery1.ExecSQL;
      dm.IBQuery1.Transaction.Commit;

      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.text := 'update PRODUTO set DESC_COMP = 0';
      dm.IBQuery1.ExecSQL;
      dm.IBQuery1.Transaction.Commit;

      alt := true;
    end;

    if not VerificaCampoTabela('ICMS_SUBS', 'PRODUTO') then
    begin
      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add
        ('ALTER TABLE PRODUTO ADD ICMS_SUBS NUMERIC(10, 3) DEFAULT 0');
      dm.IBQuery1.ExecSQL;
      dm.IBQuery1.Transaction.Commit;

      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.text := 'update PRODUTO set ICMS_SUBS = 0';
      dm.IBQuery1.ExecSQL;
      dm.IBQuery1.Transaction.Commit;

      alt := true;
    end;

    // jss. Cria campo QTD_COMP no cadastro de produtos
    if not VerificaCampoTabela('QTD_COMP', 'PRODUTO') then
    begin
      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add
        ('ALTER TABLE PRODUTO ADD QTD_COMP NUMERIC(6, 3) DEFAULT 0');
      dm.IBQuery1.ExecSQL;
      dm.IBQuery1.Transaction.Commit;

      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.text := 'update PRODUTO set QTD_COMP = 0';
      dm.IBQuery1.ExecSQL;
      dm.IBQuery1.Transaction.Commit;

      alt := true;
    end;

    if not VerificaCampoTabela('CSOSN', 'ALIQ') then
    begin
      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add
        ('ALTER TABLE ALIQ ADD CSOSN VARCHAR(12) DEFAULT '''' ');
      dm.IBQuery1.ExecSQL;
      dm.IBQuery1.Transaction.Commit;

      enxugaAliquotas;
      PreencheCSOSN_Aliq;

      alt := true;
    end;

    if not VerificaCampoTabela('TIPO', 'CAIXA') then
    begin
      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add
        ('ALTER TABLE CAIXA ADD TIPO VARCHAR(1) DEFAULT '''' ');
      dm.IBQuery1.ExecSQL;
      dm.IBQuery1.Transaction.Commit;

      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.text := 'update CAIXA set TIPO = ''''';
      dm.IBQuery1.ExecSQL;
      dm.IBQuery1.Transaction.Commit;

      alt := true;
    end;

    if not VerificaCampoTabela('PAPEL1', 'CONFIG_TEMA') then
    begin
      try
        dm.IBQuery1.Close;
        dm.IBQuery1.SQL.Clear;
        dm.IBQuery1.SQL.Add
          ('ALTER TABLE CONFIG_TEMA ADD PAPEL1 BLOB SUB_TYPE 0 SEGMENT SIZE 4096');
        dm.IBQuery1.ExecSQL;
        dm.IBQuery1.Transaction.Commit;

        dm.IBQuery1.Close;
        dm.IBQuery1.SQL.text := 'update config_tema set papel1 = papel';
        dm.IBQuery1.ExecSQL;
        dm.IBQuery1.Transaction.Commit;
      finally
      end;
    end;

    if not VerificaCampoTabela('XML', 'ENTRADA') then
    begin
      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add
        ('ALTER TABLE ENTRADA ADD XML VARCHAR(1) DEFAULT ''''');
      dm.IBQuery1.ExecSQL;
      dm.IBQuery1.Transaction.Commit;

      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.text := 'update ENTRADA set XML = ''''';
      dm.IBQuery1.ExecSQL;
      dm.IBQuery1.Transaction.Commit;
    end;

    if not VerificaCampoTabela('TIPO_ITEM', 'PRODUTO') then
    begin
      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add('ALTER TABLE PRODUTO ADD TIPO_ITEM CHAR(2) DEFAULT ' +
        QuotedStr(''));
      dm.IBQuery1.ExecSQL;

      alt := true;
    end;

    if not VerificaCampoTabela('TOTICMSST', 'SPEDDADOSADIC') then
    begin
      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add
        ('ALTER TABLE SPEDDADOSADIC ADD TOTICMSST NUMERIC(10,2) DEFAULT 0');
      dm.IBQuery1.ExecSQL;
      dm.IBQuery1.Transaction.Commit;

      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.text := 'update SPEDDADOSADIC set TOTICMSST = 0';
      dm.IBQuery1.ExecSQL;
    end;

    if not VerificaCampoTabela('CREDICMS_REAIS', 'SPEDDADOSADIC') then
    begin
      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add
        ('ALTER TABLE SPEDDADOSADIC ADD CREDICMS_REAIS NUMERIC(10,2) DEFAULT 0');
      dm.IBQuery1.ExecSQL;
      dm.IBQuery1.Transaction.Commit;

      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.text := 'update SPEDDADOSADIC set CREDICMS_REAIS = 0';
      dm.IBQuery1.ExecSQL;
    end;

    if not VerificaCampoTabela('TOTICMS_DESON', 'SPEDDADOSADIC') then
    begin
      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add
        ('ALTER TABLE SPEDDADOSADIC ADD TOTICMS_DESON NUMERIC(10,2) DEFAULT 0');
      dm.IBQuery1.ExecSQL;
      dm.IBQuery1.Transaction.Commit;

      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.text := 'update SPEDDADOSADIC set TOTICMS_DESON = 0';
      dm.IBQuery1.ExecSQL;
    end;

    if VerificaCampoTabela('REP', 'ITEM_VENDA') then
    begin
      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add('ALTER TABLE ITEM_VENDA DROP REP');
      dm.IBQuery1.ExecSQL;
      alt := true;
    end;

    if VerificaCampoTabela('DESCONTO', 'ITEM_ORCAMENTO') = False then
    begin
      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add
        ('ALTER TABLE ITEM_ORCAMENTO ADD DESCONTO NUMERIC(10, 2) DEFAULT 0 ');
      dm.IBQuery1.ExecSQL;
      dm.IBQuery1.Transaction.Commit;

      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add
        ('UPDATE ITEM_ORCAMENTO SET DESCONTO = 0 WHERE DESCONTO IS NULL');
      dm.IBQuery1.ExecSQL;
      dm.IBQuery1.Transaction.Commit;

      alt := true;
    end;

    if VerificaCampoTabela('CRC', 'ITEM_VENDA') then
    begin
      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add('ALTER TABLE ITEM_VENDA DROP CRC');
      dm.IBQuery1.ExecSQL;
      alt := true;
    end;

    if VerificaCampoTabela('FECHAMENTO', 'ITEM_VENDA') then
    begin
      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add('ALTER TABLE ITEM_VENDA DROP FECHAMENTO');
      dm.IBQuery1.ExecSQL;
      alt := true;
    end;

    if VerificaCampoTabela('REGISTRO', 'ITEM_VENDA') then
    begin
      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add('ALTER TABLE ITEM_VENDA DROP REGISTRO');
      dm.IBQuery1.ExecSQL;
      alt := true;
    end;

    if not VerificaCampoTabela('CANCELADO', 'ITEM_VENDA') then
    begin
      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add
        ('ALTER TABLE ITEM_VENDA ADD CANCELADO SMALLINT DEFAULT 0');
      dm.IBQuery1.ExecSQL;
      dm.IBQuery1.Transaction.Commit;

      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add
        ('UPDATE ITEM_VENDA I SET I.CANCELADO = (SELECT CANCELADO FROM VENDA V WHERE V.NOTA = I.NOTA)');
      dm.IBQuery1.ExecSQL;
      dm.IBQuery1.Transaction.Commit;
      alt := true;
    end
    else
    begin
      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.text :=
        'update item_venda i set i.cancelado = (select left(cancelado, 2)  from venda v where v.nota = i.nota)';
      dm.IBQuery1.ExecSQL;
    end;

    { if VerificaCampoTabela('CANCELADO','ITEM_VENDA') then
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
    dm.IBselect.SQL.text := 'select * from cliente where ies like ''%-%''';
    dm.IBselect.Open;

    if not dm.IBselect.IsEmpty then
    begin
      dm.IBselect.Close;
      dm.IBselect.SQL.text := 'select * from cliente';
      dm.IBselect.Open;
      dm.IBselect.FetchAll;

      while not dm.IBselect.Eof do
      begin
        if StrNum(dm.IBselect.FieldByName('ies').AsString) <>
          dm.IBselect.FieldByName('ies').AsString then
        begin
          dm.IBQuery1.Close;
          dm.IBQuery1.SQL.text :=
            'update cliente set ies = :ies where cod = :cod';
          dm.IBQuery1.ParamByName('ies').AsString :=
            StrNum(dm.IBselect.FieldByName('ies').AsString);
          dm.IBQuery1.ParamByName('cod').AsInteger :=
            dm.IBselect.FieldByName('cod').AsInteger;
          dm.IBQuery1.ExecSQL;
        end;
        dm.IBselect.Next;
      end;
    end;

    if not VerificaCampoTabela('COD', 'REGISTRO') then
    begin
      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add('ALTER TABLE REGISTRO ADD COD INTEGER DEFAULT 0 ');
      dm.IBQuery1.ExecSQL;
      alt := true;
    end;

    if not VerificaCampoTabela('EXPORTADO', 'VENDA') then
    begin
      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add
        ('ALTER TABLE VENDA ADD EXPORTADO SMALLINT DEFAULT 0 ');
      dm.IBQuery1.ExecSQL;
      alt := true;
    end;

    if not VerificaCampoTabela('EXPORTADO', 'ITEM_VENDA') then
    begin
      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add
        ('ALTER TABLE ITEM_VENDA ADD EXPORTADO SMALLINT DEFAULT 0 ');
      dm.IBQuery1.ExecSQL;
      alt := true;
    end;

    { if not VerificaCampoTabela('FECHAMENTO','ITEM_VENDA') then
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
      end; }

    if not VerificaCampoTabela('FECHAMENTO', 'VENDA') then
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

    if not VerificaCampoTabela('PIS', 'COD_OP') then
    begin
      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add('ALTER TABLE COD_OP ADD PIS CHAR(1) DEFAULT ' +
        QuotedStr(''));
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
      end; }

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
    if not VerificaCampoTabela('COD', 'CONTASPAGAR') then
    begin
      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.text :=
        'ALTER TABLE CONTASPAGAR ADD COD INTEGER DEFAULT 0';
      dm.IBQuery1.ExecSQL;
      dm.IBQuery1.Transaction.Commit;

      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.text := 'update contaspagar set COD = gen_id(SMALL, 1)';
      dm.IBQuery1.ExecSQL;
      dm.IBQuery1.Transaction.Commit;
    end;

    if not VerificaCampoTabela('UNID2', 'PRODUTO') then
    begin
      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add('ALTER TABLE PRODUTO ADD UNID2 VARCHAR(8) DEFAULT ' +
        QuotedStr(''));
      dm.IBQuery1.ExecSQL;
      alt := true;
    end;

    if not VerificaCampoTabela('P_VENDA', 'ITEM_ORCAMENTO') then
    begin
      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add('ALTER TABLE ITEM_ORCAMENTO ' +
        'ADD P_VENDA NUMERIC(10,2) DEFAULT 0');
      dm.IBQuery1.ExecSQL;
    end;

    if not VerificaCampoTabela('UNID2', 'ITEM_ENTRADA') then
    begin
      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add('ALTER TABLE ITEM_ENTRADA ' + 'ADD UNID2 VARCHAR(8) '
        + 'DEFAULT ' + QuotedStr(''));
      dm.IBQuery1.ExecSQL;
    end;

    if not VerificaCampoTabela('excluido', 'produto') then
    begin
      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add('ALTER TABLE produto ' +
        'ADD excluido smallint DEFAULT  0');
      dm.IBQuery1.ExecSQL;
      dm.IBQuery1.Transaction.Commit;

      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.text := 'update produto set excluido = 0';
      dm.IBQuery1.ExecSQL;
      dm.IBQuery1.Transaction.Commit;
    end;

    if not VerificaCampoTabela('excluido', 'usuario') then
    begin
      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add('ALTER TABLE usuario ' +
        'ADD excluido smallint DEFAULT  0');
      dm.IBQuery1.ExecSQL;
      dm.IBQuery1.Transaction.Commit;

      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.text := 'update usuario set excluido = 0';
      dm.IBQuery1.ExecSQL;
      dm.IBQuery1.Transaction.Commit;
    end;

    if not VerificaCampoTabela('desconto', 'produto') then
    begin
      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add('ALTER TABLE produto ' +
        'ADD desconto numeric(10, 3) DEFAULT  0');
      dm.IBQuery1.ExecSQL;
      dm.IBQuery1.Transaction.Commit;

      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.text := 'update produto set desconto = 0';
      dm.IBQuery1.ExecSQL;
      dm.IBQuery1.Transaction.Commit;
    end;

    if not VerificaCampoTabela('DATA', 'NFE') then
    begin
      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add('ALTER TABLE NFE ' + 'ADD DATA DATE ' + 'DEFAULT ' +
        QuotedStr('01.01.1900'));
      dm.IBQuery1.ExecSQL;
      dm.IBQuery1.Transaction.Commit;

      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.text :=
        'update nfe n set data = (select data from venda v where n.nota = v.nota )';
    end;

    { if verSeExisteTabela('PROMOC') then
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

    if NOT verSeExisteTabela('OBS_VENDA') then
    begin
      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.text := 'CREATE TABLE OBS_VENDA (' +
        'NOTA INTEGER NOT NULL,OBS VARCHAR(70))';
      dm.IBQuery1.ExecSQL;
      dm.IBQuery1.Transaction.Commit;

      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.text := 'alter table OBS_VENDA ' +
        'add constraint PK_OBS_VENDA primary key (NOTA)';
      dm.IBQuery1.ExecSQL;
    end;

    if NOT verSeExisteTabela('NFEDISTRIBUICAO') then
    begin
      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.text := 'CREATE TABLE NFEDISTRIBUICAO (' +
        'CHAVE VARCHAR(45) NOT NULL, CNPJ VARCHAR(22), DATA DATE, NOME VARCHAR(50),'
        + 'VALOR NUMERIC(10,2), IE VARCHAR(25), TPNF VARCHAR(2), NSU VARCHAR(30), SIT VARCHAR(2))';
      dm.IBQuery1.ExecSQL;
      dm.IBQuery1.Transaction.Commit;

      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.text := 'alter table NFEDISTRIBUICAO ' +
        'add constraint PK_NFEDISTRIBUICAO primary key (CHAVE)';
      dm.IBQuery1.ExecSQL;
    end;

    if NOT verSeExisteTabela('CONT_ENTREGA') then
    begin
      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.text := 'CREATE TABLE CONT_ENTREGA (' +
        'NOTA INTEGER NOT NULL,COD INTEGER NOT NULL,DATA_ENTREGA DATE,' +
        'USUARIO SMALLINT, NUMDOC INTEGER NOT NULL, QUANT numeric(10, 3))';
      dm.IBQuery1.ExecSQL;
      dm.IBQuery1.Transaction.Commit;

      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.text := 'alter table CONT_ENTREGA ' +
        'add constraint PK_CONT_ENTREGA primary key (NUMDOC)';
      dm.IBQuery1.ExecSQL;

      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.text := 'create sequence CONT_ENTREGA ';
      dm.IBQuery1.ExecSQL;
    end;

    if not VerificaCampoTabela('ENT_AGORA', 'CONT_ENTREGA') then
    begin
      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add('ALTER TABLE CONT_ENTREGA ADD ENT_AGORA VARCHAR(1) ' +
        'DEFAULT ' + QuotedStr(''));
      dm.IBQuery1.ExecSQL;
    end;

    if NOT verSeExisteTabela('INUTILIZACAO') then
    begin
      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.text := 'CREATE TABLE INUTILIZACAO (' +
        'COD INTEGER NOT NULL, INICIO INTEGER,FIM INTEGER,' +
        'TIPO VARCHAR(3) DEFAULT '''', DATA DATE, SERIE VARCHAR(3) DEFAULT '''')';
      dm.IBQuery1.ExecSQL;
      dm.IBQuery1.Transaction.Commit;

      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.text := 'alter table INUTILIZACAO ' +
        'add constraint PK_INUTILIZACAO primary key (COD)';
      dm.IBQuery1.ExecSQL;

      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.text := 'create sequence INUTILIZACAO ';
      dm.IBQuery1.ExecSQL;
    end;

    if NOT verSeExisteTabela('SANGRIA') then
    begin
      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.text := 'CREATE TABLE SANGRIA (' +
        'COD INTEGER NOT NULL, DATA_HORA TIMESTAMP DEFAULT ''01.01.1900'',' +
        'VALOR NUMERIC(15,2) DEFAULT 0, USUARIO SMALLINT, TIPO VARCHAR(1) DEFAULT ''1'','
        + 'exportado VARCHAR(1) DEFAULT ''0'')';
      dm.IBQuery1.ExecSQL;
      dm.IBQuery1.Transaction.Commit;

      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.text := 'alter table SANGRIA ' +
        'add constraint PK_SANGRIA primary key (COD)';
      dm.IBQuery1.ExecSQL;

      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.text := 'create sequence SANGRIA ';
      dm.IBQuery1.ExecSQL;
    end;

    if NOT verSeExisteTabela('SPED_MOVFISCAIS') then
    begin
      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.text := 'CREATE TABLE SPED_MOVFISCAIS (' +
        'COD INTEGER DEFAULT 0 NOT NULL,' + 'NOTA INTEGER DEFAULT 0,' +
        'PEDIDO INTEGER DEFAULT 0,' + 'DATA DATE DEFAULT ''01.01.1900'')';
      dm.IBQuery1.ExecSQL;
      dm.IBQuery1.Transaction.Commit;

      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.text := 'alter table SPED_MOVFISCAIS ' +
        'add constraint PK_SPED_MOVFISCAIS ' + 'primary key (COD)';
      dm.IBQuery1.ExecSQL;

      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.text := 'create sequence SPED_MOVFISCAIS ';
      dm.IBQuery1.ExecSQL;
    end;

    if NOT verSeExisteTabela('PROMOC') then
    begin
      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.text := 'CREATE TABLE PROMOC (' +
        'COD INTEGER DEFAULT 0 NOT NULL,' + 'P_VENDA NUMERIC(10,2) DEFAULT 0,' +
        'QUANT NUMERIC(10,2) DEFAULT 0,' + 'CONT INTEGER DEFAULT 0,' +
        'USUARIO SMALLINT DEFAULT 0,' + 'DATA DATE DEFAULT ''01.01.1900'',' +
        'VALIDO DATE DEFAULT ''01.01.1900'')';
      dm.IBQuery1.ExecSQL;
      dm.IBQuery1.Transaction.Commit;

      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.text := 'alter table PROMOC' +
        ' add constraint PK_PROMOC ' + ' primary key (COD)';
      dm.IBQuery1.ExecSQL;
      dm.IBQuery1.Transaction.Commit;
    end;

    if NOT verSeExisteTabela('PROMOC1') then
    begin
      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.text := 'CREATE TABLE PROMOC1 (' +
        'DOC INTEGER DEFAULT 0 NOT NULL,' + 'COD INTEGER DEFAULT 0 NOT NULL,' +
        'CODGRU smallint DEFAULT 0 NOT NULL,' +
        'P_VENDA NUMERIC(10,2) DEFAULT 0,' + 'QUANT NUMERIC(10,2) DEFAULT 0,' +
      // 'CONT INTEGER DEFAULT 0,' +
        'USUARIO SMALLINT DEFAULT 0,' + 'DATA DATE DEFAULT ''01.01.1900'',' +
        'VALIDO DATE DEFAULT ''01.01.1900'',' +
        'tipo varchar(1) DEFAULT '''' )';
      dm.IBQuery1.ExecSQL;
      dm.IBQuery1.Transaction.Commit;

      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.text := 'alter table PROMOC1' +
        ' add constraint PK_PROMOC1 ' + ' primary key (DOC)';
      dm.IBQuery1.ExecSQL;
      dm.IBQuery1.Transaction.Commit;

      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.text := 'CREATE SEQUENCE PROMOC1';
      try
        dm.IBQuery1.ExecSQL;
        dm.IBQuery1.Transaction.Commit;
      except
      end;

      dm.IBselect.Close;
      dm.IBselect.SQL.text := 'select * from promoc';
      dm.IBselect.Open;

      while not dm.IBselect.Eof do
      begin
        dm.IBQuery1.Close;
        dm.IBQuery1.SQL.text :=
          'insert into promoc1(doc, cod, codgru, p_venda, quant, usuario, data, valido, tipo) '
          + 'values(' + Incrementa_Generator('promoc1', 1) +
          ', :cod, :codgru, :p_venda, :quant, :usuario, :data, :valido, :tipo)';
        // dm.IBQuery1.ParamByName('doc').AsInteger    := StrToInt(Incrementa_Generator('promoc1', 1));
        dm.IBQuery1.ParamByName('cod').AsInteger :=
          dm.IBselect.FieldByName('cod').AsInteger;
        dm.IBQuery1.ParamByName('codgru').AsInteger := 0;
        dm.IBQuery1.ParamByName('p_venda').AsCurrency :=
          dm.IBselect.FieldByName('p_venda').AsCurrency;
        dm.IBQuery1.ParamByName('quant').AsCurrency :=
          dm.IBselect.FieldByName('quant').AsCurrency;
        dm.IBQuery1.ParamByName('usuario').AsInteger :=
          dm.IBselect.FieldByName('usuario').AsInteger;
        dm.IBQuery1.ParamByName('data').AsDate :=
          dm.IBselect.FieldByName('data').AsDateTime;
        dm.IBQuery1.ParamByName('valido').AsDate :=
          dm.IBselect.FieldByName('valido').AsDateTime;
        dm.IBQuery1.ParamByName('tipo').AsString := '0';
        dm.IBQuery1.ExecSQL;
        dm.IBselect.Next;
      end;
    end;

    if NOT verSeExisteTabela('CEST') then
    begin
      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.text := 'CREATE TABLE CEST (' +
        'CEST VARCHAR(10) DEFAULT '''' NOT NULL,' +
        'NOME VARCHAR(100) DEFAULT '''')';
      dm.IBQuery1.ExecSQL;
      dm.IBQuery1.Transaction.Commit;
      // 'NCM VARCHAR(10) DEFAULT '''',' +

      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.text := 'alter table CEST ' + 'add constraint PK_CEST ' +
        'primary key (CEST)';
      dm.IBQuery1.ExecSQL;
      dm.IBQuery1.Transaction.Commit;
    end;

    if NOT verSeExisteTabela('NCM_CEST') then
    begin
      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.text := 'CREATE TABLE NCM_CEST (' +
        'NCM VARCHAR(10) DEFAULT '''' NOT NULL,' +
        'CEST VARCHAR(10) DEFAULT '''' NOT NULL)';
      dm.IBQuery1.ExecSQL;
      dm.IBQuery1.Transaction.Commit;
      // 'NCM VARCHAR(10) DEFAULT '''',' +

      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.text := 'alter table NCM_CEST ' +
        'add constraint PK_NCM_CEST ' + 'primary key (NCM, CEST)';
      dm.IBQuery1.ExecSQL;
      dm.IBQuery1.Transaction.Commit;

      atualizaTabelaCest;
    end;

    if NOT verSeExisteTabela('PRODUTO_DELETED') then
    begin
      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add('CREATE TABLE PRODUTO_DELETED (' +
        'COD        INTEGER DEFAULT 0 NOT NULL,' +
        'NOME       VARCHAR(60) DEFAULT '''',' +
        'UNID       VARCHAR(6) DEFAULT '''',' +
        'USUARIO    VARCHAR(10) DEFAULT '''',     ' + 'DATA_DELETED       DATE,'
        + 'IGUAL      VARCHAR(40) DEFAULT '''',     ' +
        'CODBAR     VARCHAR(20) DEFAULT '''',   ' +
        'LOCALIZA   VARCHAR(15) DEFAULT '''',   ' +
        'FORNEC     INTEGER DEFAULT 0,        ' +
        'FABRIC     INTEGER DEFAULT 0,        ' +
        'ALIQUOTA   VARCHAR(3) DEFAULT '''',  ' +
        'REFORI     VARCHAR(40) DEFAULT '''', ' +
        'CLASSIF    VARCHAR(15) DEFAULT '''', ' +
        'APLIC      VARCHAR(40) DEFAULT '''', ' +
        'GRUPO      INTEGER DEFAULT 0,      ' +
        'SERIE      VARCHAR(1) DEFAULT '''',  ' +
        'IS_PIS     VARCHAR(1) DEFAULT '''',  ' +
        'EMB        VARCHAR(5) DEFAULT '''',  ' +
        'DESC_ATAC  VARCHAR(30) DEFAULT '''', ' +
        'P_COMPRA   NUMERIC(13,3) DEFAULT 0,' +
        'P_VENDA    NUMERIC(12,3) DEFAULT 0,' +
        'LUCRO      NUMERIC(7,2) DEFAULT 0, ' +
        'QUANT      NUMERIC(12,3) DEFAULT 0,' +
        'ESTOQUE    NUMERIC(10,2) DEFAULT 0,' +
        'DEPOSITO   NUMERIC(12,3) DEFAULT 0,' +
        'COMISSAO   NUMERIC(6,2) DEFAULT 0, ' +
        'CREDICM    NUMERIC(9,2) DEFAULT 0, ' +
        'BASECRED   NUMERIC(6,2) DEFAULT 0, ' +
        'DEBICM     NUMERIC(9,2) DEFAULT 0, ' +
        'BASEDEB    NUMERIC(6,2) DEFAULT 0, ' +
        'FRETE      NUMERIC(6,2) DEFAULT 0, ' +
        'ENCARGOS   NUMERIC(15,2) DEFAULT 0,' +
        'FRACAO     NUMERIC(10,6) DEFAULT 0,' +
        'AGREGADO   NUMERIC(6,2) DEFAULT 0, ' +
        'SAL        NUMERIC(13,3) DEFAULT 0,' +
        'SAD        NUMERIC(13,3) DEFAULT 0,' +
        'SUGESTAO   NUMERIC(10,2) DEFAULT 0,' +
        'COMPRA     NUMERIC(10,2) DEFAULT 0,' +
        'P_VENDA1   NUMERIC(10,2) DEFAULT 0,' +
        'DEV_ICM    NUMERIC(5,2) DEFAULT 0, ' +
        'FILIAL1    NUMERIC(10,2) DEFAULT 0,' +
        'FILIAL2    NUMERIC(10,2) DEFAULT 0,' +
        'UNID2      VARCHAR(8) DEFAULT '''',' +
        'COD_ISPIS  CHAR(3) DEFAULT '''',' +
        'EQUIVA     VARCHAR(20) DEFAULT '''',' +
        'OBS        VARCHAR(40) DEFAULT '''',' +
        'REFNFE     VARCHAR(25) DEFAULT '''',' +
        'TIPO_ITEM  CHAR(2) DEFAULT '''')');
      dm.IBQuery1.ExecSQL;
      dm.IBQuery1.Transaction.Commit;
    end;

    if NOT verSeExisteTabela('FVMT') then
    begin
      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add('CREATE TABLE FVMT (' + 'ITEM VARCHAR(100))');
      dm.IBQuery1.ExecSQL;
      dm.IBQuery1.Transaction.Commit;
    end;

    if NOT verSeExisteTabela('ALTERACA') then
    begin
      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add('CREATE TABLE ALTERACA (' + 'COD INTEGER,' +
        'ALTERACAO VARCHAR(100) DEFAULT '''',' +
        'USUARIO VARCHAR(20) DEFAULT '''',' + 'DATA TIMESTAMP)');
      dm.IBQuery1.ExecSQL;

      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add('CREATE SEQUENCE ALTERACA');
      dm.IBQuery1.ExecSQL;
    end;

    if not VerificaCampoTabela('EXPORTADO', 'NFE') then
    begin
      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add('ALTER TABLE NFE ' +
        'ADD EXPORTADO SMALLINT  DEFAULT 0');
      dm.IBQuery1.ExecSQL;
      dm.IBQuery1.Transaction.Commit;

      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.text := 'update NFE set EXPORTADO = 0';
      dm.IBQuery1.ExecSQL;
      dm.IBQuery1.Transaction.Commit;
    end;

    if not VerificaCampoTabela('DATA', 'FVMT') then
    begin
      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add('ALTER TABLE FVMT ' + 'ADD DATA DATE ' + 'DEFAULT ' +
        QuotedStr('01.01.1900'));
      dm.IBQuery1.ExecSQL;
      dm.IBQuery1.Transaction.Commit;

      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add('ALTER TABLE FVMT ' + 'ADD ESTADO VARCHAR(2) ' +
        'DEFAULT ' + QuotedStr(''));
      dm.IBQuery1.ExecSQL;
      dm.IBQuery1.Transaction.Commit;

      dm.IBselect.Close;
      dm.IBselect.SQL.text := 'select * from FVMT';
      dm.IBselect.Open;

      while not dm.IBselect.Eof do
      begin
        dm.IBQuery1.Close;
        dm.IBQuery1.SQL.text :=
          'update FVMT set data = :data, estado = :est where item = :item';
        dm.IBQuery1.ParamByName('data').AsDate :=
          converteDataYYMMDDParaTdate
          (copy(dm.IBselect.FieldByName('item').AsString, 1, 6));
        dm.IBQuery1.ParamByName('est').AsString :=
          IfThen(copy(dm.IBselect.FieldByName('item').AsString, 21, 2) = '90',
          'E', 'C');
        dm.IBQuery1.ParamByName('item').AsString :=
          dm.IBselect.FieldByName('item').AsString;
        dm.IBQuery1.ExecSQL;

        dm.IBselect.Next;
      end;
    end;

    if not VerificaCampoTabela('COD_ISPIS', 'PRODUTO') then
    begin
      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add('ALTER TABLE PRODUTO ' + 'ADD COD_ISPIS CHAR(3) ' +
        'DEFAULT ' + QuotedStr(''));
      dm.IBQuery1.ExecSQL;
    end;

    if not VerificaCampoTabela('UNID', 'ITEM_ENTRADA') then
    begin
      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add('ALTER TABLE ITEM_ENTRADA ' + 'ADD UNID VARCHAR(8) ' +
        'DEFAULT ' + QuotedStr(''));
      dm.IBQuery1.ExecSQL;
    end;

    if not VerificaCampoTabela('ICMS', 'COD_OP') then
    begin
      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add('ALTER TABLE COD_OP ADD ICMS CHAR(1) DEFAULT ' +
        QuotedStr(''));
      dm.IBQuery1.ExecSQL;
      alt := true;
    end;

    if not VerificaCampoTabela('EQUIVA', 'PRODUTO') then
    begin
      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add('ALTER TABLE PRODUTO ADD EQUIVA VARCHAR(20) DEFAULT '
        + QuotedStr(''));
      try
        dm.IBQuery1.ExecSQL;
      except
      end;
    end;

    if not VerificaCampoTabela('SUFRAMA', 'REGISTRO') then
    begin
      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add
        ('ALTER TABLE REGISTRO ADD SUFRAMA varchar(40) DEFAULT ' +
        QuotedStr(''));
      dm.IBQuery1.ExecSQL;
    end;

    if not VerificaCampoTabela('CEP', 'REGISTRO') then
    begin
      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add('ALTER TABLE REGISTRO ADD CEP varchar(12) DEFAULT ' +
        QuotedStr(''));
      dm.IBQuery1.ExecSQL;
    end;

    if not VerificaCampoTabela('OBS', 'PRODUTO') then
    begin
      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add('ALTER TABLE PRODUTO ADD OBS varchar(40) DEFAULT ' +
        QuotedStr(''));
      dm.IBQuery1.ExecSQL;
    end;

    if not VerificaCampoTabela('USUARIO', 'VENDA') then
    begin
      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add('ALTER TABLE VENDA ADD USUARIO SMALLINT DEFAULT 0');
      dm.IBQuery1.ExecSQL;
      alt := true;
    end;

    if not VerificaCampoTabela('TOTAL', 'ITEM_ORCAMENTO') then
    begin
      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add
        ('ALTER TABLE ITEM_ORCAMENTO ADD TOTAL NUMERIC(10,2) DEFAULT 0');
      dm.IBQuery1.ExecSQL;

      dm.IBQuery1.Transaction.Commit;

      funcoes.iniciaDataset(dm.IBQuery1,
        'update item_orcamento set total = quant * p_venda where total is null');
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

    if funcoes.retornaTamanhoDoCampoBD('HISTORICO', 'CAIXA') = 35 then
    begin
      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add('alter table CAIXA alter HISTORICO type VARCHAR(60)');
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
      dm.IBQuery1.SQL.Add
        ('alter table fornecedor alter contato type VARCHAR(40)');
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
      dm.IBQuery1.SQL.Add
        ('alter table FORNECEDOR alter CIDADE type VARCHAR(30)');
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
      dm.IBQuery1.SQL.Add
        ('alter table CONTASPAGAR alter HISTORICO type VARCHAR(60)');
      dm.IBQuery1.ExecSQL;
    end;

    if funcoes.retornaTamanhoDoCampoBD('configu', 'usuario') = 50 then begin
      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add
        ('alter table usuario alter configu type VARCHAR(200)');
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
      dm.IBQuery1.SQL.Add
        ('alter table item_venda alter codbar type VARCHAR(20)');
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
      dm.IBQuery1.SQL.text :=
        'update produto set grupo = ''0'' where (grupo = '''') or (grupo is null) ';
      dm.IBQuery1.ExecSQL;
      dm.IBQuery1.Transaction.Commit;

      { dm.IBQuery1.Close;
        dm.IBQuery1.SQL.Text := 'alter table PRODUTO alter GRUPO type integer';
        dm.IBQuery1.ExecSQL;
        dm.IBQuery1.Transaction.Commit; }
    end;

    if not VerificaCampoTabela('MENS', 'USUARIO') then
    begin
      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.text := 'ALTER TABLE USUARIO ' + 'ADD MENS VARCHAR(40) ' +
        'DEFAULT ''* * *   NAO  TEM  VALOR  FISCAL    * * *'' ';
      dm.IBQuery1.ExecSQL;
      dm.IBQuery1.Transaction.Commit;
    end;

    { if not VerificaCampoTabela('MENSORC', 'USUARIO') then
      begin
      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Text := 'ALTER TABLE USUARIO ' + 'ADD MENSORC VARCHAR(60) ' +
      'DEFAULT ''* * *   NAO  TEM  VALOR  FISCAL    * * *'' ';
      dm.IBQuery1.ExecSQL;
      dm.IBQuery1.Transaction.Commit;

      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Text := 'update usuario set MENSORC = MENS';
      dm.IBQuery1.ExecSQL;
      dm.IBQuery1.Transaction.Commit;
      end; }

    if not VerificaCampoTabela('ESTADO', 'NFE') then
    begin
      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.text := 'ALTER TABLE NFE ' + 'ADD ESTADO VARCHAR(2) ' +
        'DEFAULT ''E'' ';
      dm.IBQuery1.ExecSQL;
      dm.IBQuery1.Transaction.Commit;

      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.text := 'update nfe set estado = ''E''';
      dm.IBQuery1.ExecSQL;
    end;

    if not VerificaCampoTabela('REFNFE', 'PRODUTO') then
    begin
      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.text := 'ALTER TABLE PRODUTO ' + 'ADD REFNFE VARCHAR(25) '
        + 'DEFAULT '''' ';
      dm.IBQuery1.ExecSQL;
    end;

    if not VerificaCampoTabela('FORNEC', 'ITEM_ENTRADA') then
    begin
      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.text := 'ALTER TABLE ITEM_ENTRADA ' +
        'ADD FORNEC SMALLINT ' + 'DEFAULT 0 ';
      dm.IBQuery1.ExecSQL;
      dm.IBQuery1.Transaction.Commit;

      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.text :=
        'update item_entrada i set fornec = (select fornec  from entrada f where i.nota = f.nota)';
      dm.IBQuery1.ExecSQL;
    end;

    if not VerificaCampoTabela('COD_ISPIS', 'COD_OP') then
    begin
      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.text := 'ALTER TABLE COD_OP ' +
        'ADD COD_ISPIS VARCHAR(3) ' + 'DEFAULT '''' ';
      dm.IBQuery1.ExecSQL;
      dm.IBQuery1.Transaction.Commit;
    end;

    if NOT verSeExisteTabela('OS_VENDA') then
    begin
      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add('CREATE TABLE OS_VENDA (' + 'NOTA INTEGER,' +
        'TOTAL NUMERIC(10,2),' + 'DATA DATE,' + 'CLIENTE INTEGER)');
      dm.IBQuery1.ExecSQL;
      dm.IBQuery1.Transaction.Commit;
    end;

    if VerificaCampoTabela('VENDEDOR', 'OS_VENDA') = False then
    begin
      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add
        ('ALTER TABLE OS_VENDA ADD VENDEDOR SMALLINT DEFAULT 0 ');
      dm.IBQuery1.ExecSQL;
      dm.IBQuery1.Transaction.Commit;

      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.text := 'update OS_VENDA set vendedor = 0';
      dm.IBQuery1.ExecSQL;
    end;

    if NOT verSeExisteTabela('ACERTO') then
    begin
      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add('CREATE TABLE ACERTO (' +
        'ACERTO_SEQ INTEGER NOT NULL,' + 'DOCUMENTO INTEGER DEFAULT 0 NOT NULL,'
        + 'DATA DATE DEFAULT ''01.01.1900'',' +
        'CODIGO INTEGER DEFAULT 0 NOT NULL,' + 'NOME VARCHAR(40) DEFAULT '''','
        + 'QUANT NUMERIC(10,3) DEFAULT 0,' + 'DEPOSITO NUMERIC(10,3) DEFAULT 0,'
        + 'USUARIO INTEGER DEFAULT 0,' + 'DESCRICAO VARCHAR(20) DEFAULT '''')');
      dm.IBQuery1.ExecSQL;
      dm.IBQuery1.Transaction.Commit;

      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.text := 'alter table ACERTO ' +
        'add constraint PK_ACERTO ' + 'primary key (ACERTO_SEQ)';
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
      dm.IBQuery1.SQL.text :=
        ('CREATE TABLE SPED_REDUCAOZ (' + 'COD INTEGER NOT NULL,' + 'DATA DATE,'
        + 'ECF INTEGER NOT NULL,' + 'CONT_REINICIO INTEGER,' +
        'CONT_REDUCAOZ INTEGER,' + 'CONT_OP INTEGER,' +
        'TOT_GERAL NUMERIC(15,2),' + 'TOT_CANC NUMERIC(15,2),' +
        'TOT_ALIQ01 NUMERIC(15,2),' + 'TOT_ALIQ02 NUMERIC(15,2),' +
        'TOT_ALIQ03 NUMERIC(15,2),' + 'TOT_ALIQ04 NUMERIC(15,2),' +
        'TOT_ALIQ05 NUMERIC(15,2),' + 'TOT_ALIQ06 NUMERIC(15,2),' +
        'TOT_ALIQ07 NUMERIC(15,2),' + 'TOT_ALIQ08 NUMERIC(15,2),' +
        'TOT_DESC NUMERIC(15,2),' + 'TOT_FF NUMERIC(15,2),' +
        'TOT_II NUMERIC(15,2),' + 'TOT_NN NUMERIC(15,2),' +
        'VENDABRUTA NUMERIC(13, 2) )');

      dm.IBQuery1.ExecSQL;
      dm.IBQuery1.Transaction.Commit;

      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add('alter table SPED_REDUCAOZ ' +
        'add constraint PK_SPED_REDUCAOZ ' + 'primary key (COD)');
      dm.IBQuery1.ExecSQL;
      dm.IBQuery1.Transaction.Commit;

      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add('CREATE SEQUENCE SPED_REDUCAOZ');
      dm.IBQuery1.ExecSQL;
      dm.IBQuery1.Transaction.Commit;
    end;

    if not VerificaCampoTabela('EXPORTADO', 'SPED_REDUCAOZ') then
    begin
      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add('ALTER TABLE SPED_REDUCAOZ ' +
        'ADD EXPORTADO SMALLINT  DEFAULT 0');
      dm.IBQuery1.ExecSQL;
      dm.IBQuery1.Transaction.Commit;

      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.text := 'update SPED_REDUCAOZ set EXPORTADO = 0';
      dm.IBQuery1.ExecSQL;
      dm.IBQuery1.Transaction.Commit;
    end;

    if not VerificaCampoTabela('VENDABRUTA', 'SPED_REDUCAOZ') then
    begin
      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.text := 'ALTER TABLE SPED_REDUCAOZ ' +
        'ADD VENDABRUTA NUMERIC(13, 2) ' + 'DEFAULT 0';
      dm.IBQuery1.ExecSQL;
      dm.IBQuery1.Transaction.Commit;

      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.text :=
        'update SPED_REDUCAOZ set VENDABRUTA = TOT_CANC + TOT_ALIQ01 + ' +
        'TOT_ALIQ02 + TOT_ALIQ03 + TOT_ALIQ04 + TOT_ALIQ05 + TOT_ALIQ06 + TOT_ALIQ07 + TOT_ALIQ08 + '
        + 'TOT_FF + TOT_II + TOT_NN';
      dm.IBQuery1.ExecSQL;
    end;

    if NOT verSeExisteTabela('ECF') then
    begin
      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add('CREATE TABLE ECF (' + 'COD INTEGER NOT NULL,' +
        'MODELO VARCHAR(30),' + 'SERIAL VARCHAR(30))');
      dm.IBQuery1.ExecSQL;
      dm.IBQuery1.Transaction.Commit;

      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add('alter table ECF ' + ' add constraint PK_ECF ' +
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
        'NOTA INTEGER NOT NULL,' + 'FORNEC INTEGER NOT NULL,' + 'DATA DATE,' +
        'CHEGADA DATE,' + 'TOTAL NUMERIC(10,2),' + 'CHAVE VARCHAR(50))');
      dm.IBQuery1.ExecSQL;
      dm.IBQuery1.Transaction.Commit;

      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add('alter table ENTRADA_TEMP ' +
        ' add constraint PK_ENTRADA_TEMP ' + 'primary key (NOTA,FORNEC)');
      dm.IBQuery1.ExecSQL;
    end;
    if NOT verSeExisteTabela('ITEM_ENTRADA_TEMP') then
    begin
      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add('CREATE TABLE ITEM_ENTRADA_TEMP (' +
        'NOTA INTEGER NOT NULL,' + 'FORNEC INTEGER NOT NULL,' +
        'NOME_F VARCHAR(40),' + 'NOME_E VARCHAR(40),' +
        'P_VENDA_F NUMERIC(10,2),' + 'P_VENDA_E NUMERIC(10,2),' +
        'P_VENDA_A NUMERIC(10,2),' + 'LUCRO NUMERIC(6,2),' +
        'QUANT NUMERIC(10,3),' + 'QUANT_E NUMERIC(10,3),' + 'UNID_F VARCHAR(8),'
        + 'UNID_E VARCHAR(8),' + 'UNID_V VARCHAR(8),' + 'ALIQ VARCHAR(3),' +
        'CODBAR_F VARCHAR(15),' + 'CODBAR_E VARCHAR(15),' +
        'REF_ORIGI VARCHAR(20),' + 'REF_FORNEC VARCHAR(30),' +
        'NCM VARCHAR(10),' + 'COD INTEGER)');
      dm.IBQuery1.ExecSQL;
      dm.IBQuery1.Transaction.Commit;

      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add('alter table ITEM_ENTRADA_TEMP ' +
        ' add constraint PK_ITEM_ENTRADA_TEMP ' + ' primary key (NOTA,FORNEC)');
      dm.IBQuery1.ExecSQL;
    end;

    if NOT verSeExisteTabela('OS_ITENS') then
    begin
      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add('CREATE TABLE OS_ITENS (' + 'NOTA INTEGER,' +
        'COD INTEGER,' + 'QUANT NUMERIC(10,3),' + 'P_VENDA NUMERIC(10,2),' +
        'TOTAL NUMERIC(10,2))');
      dm.IBQuery1.ExecSQL;
      dm.IBQuery1.Transaction.Commit;
    end;

    if not VerificaCampoTabela('VENDEDOR', 'ITEM_ORCAMENTO') then
    begin
      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.text :=
        'ALTER TABLE ITEM_ORCAMENTO ADD VENDEDOR VARCHAR(3) ' + 'DEFAULT '''' ';
      dm.IBQuery1.ExecSQL;
      dm.IBQuery1.Transaction.Commit;

      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.text :=
        'UPDATE ITEM_ORCAMENTO I SET VENDEDOR = (SELECT VENDEDOR FROM ORCAMENTO V WHERE V.NOTA = I.NOTA)';
      dm.IBQuery1.ExecSQL;
    end;

    if not VerificaCampoTabela('VENDEDOR', 'OS_ITENS') then
    begin
      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.text := 'ALTER TABLE OS_ITENS ADD VENDEDOR VARCHAR(3) ' +
        'DEFAULT '''' ';
      dm.IBQuery1.ExecSQL;
      dm.IBQuery1.Transaction.Commit;

      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.text :=
        'UPDATE os_itens I SET VENDEDOR = (SELECT VENDEDOR FROM os_venda V WHERE V.NOTA = I.NOTA)';
      dm.IBQuery1.ExecSQL;
    end;

    if NOT verSeExisteTabela('NFCE') then
    begin
      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add('CREATE TABLE NFCE (' + 'CHAVE VARCHAR(50) NOT NULL,'
        + 'NOTA INTEGER DEFAULT 0, ' + 'CLIENTE INTEGER DEFAULT 0,' +
        'DATA DATE, ' + 'ADIC VARCHAR(200) DEFAULT '''')');
      dm.IBQuery1.ExecSQL;
      dm.IBQuery1.Transaction.Commit;

      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add('alter table NFCE' + ' add constraint PK_NFCE ' +
        'primary key (CHAVE)');
      dm.IBQuery1.ExecSQL;
      dm.IBQuery1.Transaction.Commit;
    end;

    if not VerificaCampoTabela('EXPORTADO', 'NFCE') then
    begin
      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add('alter table NFCE ADD EXPORTADO SMALLINT DEFAULT 0');
      dm.IBQuery1.ExecSQL;
      dm.IBQuery1.Transaction.Commit;

      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.text := 'update NFCE set EXPORTADO = 0';
      dm.IBQuery1.ExecSQL;
      dm.IBQuery1.Transaction.Commit;
    end;

    if NOT verSeExisteTabela('JUSTIFICATIVA') then
    begin
      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add('CREATE TABLE JUSTIFICATIVA (' +
        'NOTA INTEGER DEFAULT 0' + ',JUSTIFICATIVA VARCHAR(40) DEFAULT ' +
        QuotedStr('') + ',DATA DATE ' + ', valor numeric(8, 2) ' +
        ', volumes integer)');
      dm.IBQuery1.ExecSQL;
    end;

    if NOT verSeExisteTabela('SERVICO') then
    begin
      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add('CREATE TABLE SERVICO (' +
        'COD INTEGER DEFAULT 0 NOT NULL,' + 'DATA DATE DEFAULT ''01.01.1900'','
        + 'NOME VARCHAR(35) DEFAULT '''',' + 'USUARIO SMALLINT DEFAULT 0,' +
        'CLIENTE INTEGER DEFAULT 0,' + 'VENDA INTEGER DEFAULT 0,' +
        'EQUIP VARCHAR(40) DEFAULT '''',' + 'MARCA VARCHAR(15) DEFAULT '''',' +
        'MODELO VARCHAR(15) DEFAULT '''',' + 'SERIE VARCHAR(20) DEFAULT '''',' +
        'DEFEITO VARCHAR(40) DEFAULT '''',' +
        'TECNICO VARCHAR(15) DEFAULT '''',' + 'VENDEDOR SMALLINT DEFAULT 0,' +
        'OBS VARCHAR(50) DEFAULT '''',' + 'SAIDA DATE DEFAULT ''01.01.1900'',' +
        'SITUACAO CHAR(1) DEFAULT '''',' + 'DIAG VARCHAR(30) DEFAULT '''',' +
        'PARECER VARCHAR(80) DEFAULT '''',' + 'H_ENT TIME DEFAULT ''00:00:00'','
        + 'H_SAI TIME DEFAULT ''00:00:00'',' + 'PAGO NUMERIC(10,2) DEFAULT 0,' +
        'ORDEM VARCHAR(7) DEFAULT '''')');
      dm.IBQuery1.ExecSQL;
      dm.IBQuery1.Transaction.Commit;

      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add('alter table SERVICO ' + 'add constraint PK_SERVICO '
        + 'primary key (COD)');
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
      dm.IBQuery1.SQL.Add('CREATE TABLE MOV_FRE (' + 'NUMDOC INTEGER NOT NULL,'
        + 'TRANSP INTEGER DEFAULT 0,' + 'DATA DATE DEFAULT ''01.01.1900'',' +
        'CHEGADA DATE DEFAULT ''01.01.1900'',' + 'SERIE CHAR(1) DEFAULT '''',' +
        'IND_FRETE CHAR(1) DEFAULT '''',' + 'MOD_FRETE CHAR(2) DEFAULT '''',' +
        'COD_CFOP VARCHAR(6) DEFAULT '''',' +
        'VLR_TOTAL NUMERIC(10,2) DEFAULT 0,' +
        'VLR_DESC NUMERIC(10,2) DEFAULT 0,' +
        'VLR_SERV NUMERIC(10,2) DEFAULT 0,' +
        'VLR_BC_ICM NUMERIC(10,2) DEFAULT 0,' +
        'VLR_ICMS NUMERIC(10,2) DEFAULT 0,' + 'VLR_NT NUMERIC(10,2) DEFAULT 0,'
        + 'USUARIO SMALLINT DEFAULT 0)');
      dm.IBQuery1.ExecSQL;
      dm.IBQuery1.Transaction.Commit;

      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add('alter table MOV_FRE' + ' add constraint PK_MOV_FRE '
        + ' primary key (NUMDOC)');
      dm.IBQuery1.ExecSQL;
      dm.IBQuery1.Transaction.Commit;
    end;

    if not VerificaCampoTabela('CHAVECTE', 'MOV_FRE') then
    begin
      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.text := 'ALTER TABLE MOV_FRE ' +
        'ADD CHAVECTE VARCHAR(55) ' + 'DEFAULT '''' ';
      dm.IBQuery1.ExecSQL;
      dm.IBQuery1.Transaction.Commit;
    end;

    if not VerificaCampoTabela('VENDA', 'SERVICO') then
    begin
      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add('alter table SERVICO ADD VENDA INTEGER DEFAULT 0');
      dm.IBQuery1.ExecSQL;
    end;

    if not VerificaCampoTabela('COD_MUN', 'TRANSPORTADORA') then
    begin
      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add
        ('alter table TRANSPORTADORA ADD COD_MUN INTEGER DEFAULT 0');
      dm.IBQuery1.ExecSQL;
    end;

    if not verSeExisteTabela('UNID') then
    begin
      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add('CREATE TABLE UNID (' + 'NOME VARCHAR(8) NOT NULL,' +
        'MULTIPLO INTEGER DEFAULT 1)');
      dm.IBQuery1.ExecSQL;

      dm.IBQuery1.Transaction.Commit;

      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add('alter table UNID' + ' add constraint PK_UNID' +
        ' primary key (NOME);');
      dm.IBQuery1.ExecSQL;
    end;

    if not VerificaCampoTabela('UNID_ENT', 'UNID') then
    begin
      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add('alter table UNID ADD UNID_ENT VARCHAR(6) DEFAULT ' +
        QuotedStr(''));
      dm.IBQuery1.ExecSQL;
      dm.IBQuery1.Transaction.Commit;
    end;

    if not VerificaCampoTabela('UNID_SAI', 'UNID') then
    begin
      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add('alter table UNID ADD UNID_SAI VARCHAR(6) DEFAULT ' +
        QuotedStr(''));
      dm.IBQuery1.ExecSQL;
      dm.IBQuery1.Transaction.Commit;

      unid := tstringList.Create;

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

      fim := unid.count - 1;
      for i := 0 to fim do
      begin
        tmp := StrToIntDef(funcoes.StrNum(unid.Names[i]), 1);
        if tmp = 0 then
          tmp := 1;

        dm.IBQuery1.Close;
        dm.IBQuery1.SQL.text :=
          'update or insert into unid(nome, multiplo, unid_ent, unid_sai) values(:nome, :multiplo, :unid_ent, :unid_sai) matching (nome)';
        dm.IBQuery1.ParamByName('nome').AsString := unid.Names[i];
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
      dm.IBQuery1.SQL.Add('CREATE TABLE PAISES (' + 'COD INTEGER NOT NULL, ' +
        'NOME VARCHAR(50))');
      dm.IBQuery1.ExecSQL;
      dm.IBQuery1.Transaction.Commit;

      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add('alter table PAISES ' + 'add constraint PK_PAISES ' +
        'primary key (COD)');
      dm.IBQuery1.ExecSQL;
      dm.IBQuery1.Transaction.Commit;
    end;

    atualizaCFOPs();

    // copia os dados de paises para o bd do control
    funcoes.iniciaDataset(dm.IBselect, 'select cod from paises');
    dm.IBselect.Open;
    dm.IBselect.FetchAll;

    if dm.IBselect.RecordCount <= 10 then
    begin
      if FileExists(caminhoEXE_com_barra_no_final + 'JS000066.DAT') then
      begin
        arq := tstringList.Create;
        arq.LoadFromFile(caminhoEXE_com_barra_no_final + 'JS000066.DAT');
        tmp := arq.count - 1;

        for i := 0 to tmp do
        begin
          if trim(copy(arq[i], 1, pos(' ', arq[i]))) <> '' then
          begin
            dm.IBQuery1.Close;
            dm.IBQuery1.SQL.Clear;
            dm.IBQuery1.SQL.Add
              ('update or insert into PAISES(cod, nome) values(:cod, :nome)');
            dm.IBQuery1.ParamByName('cod').AsString :=
              trim(copy(arq[i], 1, pos(' ', arq[i])));
            dm.IBQuery1.ParamByName('nome').AsString :=
              trim(copy(arq[i], pos(' ', arq[i]) + 1, length(arq[i])));
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
        'COD INTEGER DEFAULT 0 NOT NULL,' + 'CODBAR VARCHAR(20) DEFAULT ' +
        QuotedStr('') + ' NOT NULL);');
      dm.IBQuery1.ExecSQL;

      dm.IBQuery1.Transaction.Commit;

      { dm.IBQuery1.Close;
        dm.IBQuery1.SQL.Clear;
        dm.IBQuery1.SQL.Add('alter table CODBARRAS' +
        ' add constraint PK_CODBARRAS' +
        ' primary key (COD,CODBAR);');
        dm.IBQuery1.ExecSQL;
        dm.IBQuery1.Transaction.Commit; }
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
      dm.IBQuery1.SQL.Add
        ('alter table CODBARRAS alter CODBAR type VARCHAR(20)');
      dm.IBQuery1.ExecSQL;
      dm.IBQuery1.Transaction.Commit;

      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add('alter table CODBARRAS' +
        ' add constraint PK_CODBARRAS1' + ' primary key (COD,CODBAR);');
      dm.IBQuery1.ExecSQL;
      dm.IBQuery1.Transaction.Commit;
    end;

    if not verSeExisteTabela('CPD') then
    begin
      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add('CREATE TABLE CPD (' + 'DD VARCHAR(8),' +
        'SIT SMALLINT)');
      dm.IBQuery1.ExecSQL;
    end
    else
    begin
      if not VerificaCampoTabela('DNFC', 'CPD') then
      begin
        dm.IBQuery1.Close;
        dm.IBQuery1.SQL.Clear;
        dm.IBQuery1.SQL.Add('alter table CPD alter DD type varchar(100)');
        dm.IBQuery1.ExecSQL;

        dm.IBQuery1.Close;
        dm.IBQuery1.SQL.Clear;
        dm.IBQuery1.SQL.Add('ALTER TABLE CPD ADD DNFC varchar(100) DEFAULT ' +
          QuotedStr(''));
        dm.IBQuery1.ExecSQL;

        dm.IBQuery1.Close;
        dm.IBQuery1.SQL.Clear;
        dm.IBQuery1.SQL.Add('ALTER TABLE CPD ADD DD1 varchar(100) DEFAULT ' +
          QuotedStr(''));
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
        'COD INTEGER NOT NULL,' + 'NOME VARCHAR(50) DEFAULT ' + QuotedStr('') +
        ',' + 'CPF VARCHAR(14) DEFAULT ' + QuotedStr('') + ',' +
        'CNPJ VARCHAR(22) DEFAULT ' + QuotedStr('') + ',' +
        'ENDE VARCHAR(35) DEFAULT ' + QuotedStr('') + ',' +
        'NUMERO VARCHAR(10) DEFAULT ' + QuotedStr('') + ',' +
        'EST VARCHAR(3) DEFAULT ' + QuotedStr('') + ',' +
        'CID VARCHAR(18) DEFAULT ' + QuotedStr('') + ',' +
        'CEP VARCHAR(10) DEFAULT ' + QuotedStr('') + ',' +
        'CRC VARCHAR(20) DEFAULT ' + QuotedStr('') + ',' +
        'FONE VARCHAR(13) DEFAULT ' + QuotedStr('') + ',' +
        'FAX VARCHAR(13) DEFAULT ' + QuotedStr('') + ',' +
        'EMAIL VARCHAR(50) DEFAULT ' + QuotedStr('') + ',' +
        'BAIRRO VARCHAR(30) DEFAULT ' + QuotedStr('') + ')');
      dm.IBQuery1.ExecSQL;

      dm.IBQuery1.Transaction.Commit;

      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add('alter table SPEDCONTADOR ' +
        'add constraint PK_SPEDCONTADOR ' + 'primary key (COD)');
      dm.IBQuery1.ExecSQL;

      alt := true;
    end;

    if not verSeExisteTabela('SPEDDADOSADIC') then
    begin
      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add('CREATE TABLE SPEDDADOSADIC (NOTA INTEGER NOT NULL,' +
        'FORNEC INTEGER NOT NULL,' + 'TIPO SMALLINT,' + 'SERIE SMALLINT,' +
        'CFOP INTEGER,' + 'TIPOFRETE SMALLINT,' + 'TOTSEG NUMERIC(10,2),' +
        'TOTDESC NUMERIC(10,2),' + 'TOTDESCNT NUMERIC(10,2),' +
        'TOTDESPACES NUMERIC(10,2),' + 'TOTPIS NUMERIC(10,2),' +
        'TOTCONFINS NUMERIC(10,2),' + 'CREDICMS NUMERIC(10,2),' +
        'CHAVENFE VARCHAR(45),' + 'TOTFRETE NUMERIC(10,2))');
      dm.IBQuery1.ExecSQL;

      dm.IBQuery1.Transaction.Commit;

      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add('alter table SPEDDADOSADIC ' +
        'add constraint PK_SPEDDADOSADIC ' + 'primary key (NOTA,FORNEC)');
      dm.IBQuery1.ExecSQL;

      alt := true;
    end;

    dm.IBQuery1.Close;
    dm.IBQuery1.SQL.Clear;
    dm.IBQuery1.SQL.Add('select max(cod) as cod from pgerais');
    dm.IBQuery1.Open;
    tmp := StrToIntDef(dm.IBQuery1.FieldByName('cod').AsString, 0);
    if tmp <> 0 then
    begin
      tmp := tmp + 1;
      fim := pger.count - 1;
      for i := tmp to 100 do
      begin
        dm.IBQuery1.Close;
        dm.IBQuery1.SQL.Clear;
        dm.IBQuery1.SQL.Add
          ('insert into pgerais(cod, valor) values(:cod, :valor)');
        dm.IBQuery1.ParamByName('cod').AsInteger := i;
        dm.IBQuery1.ParamByName('valor').AsString := pger.Values[IntToStr(i)];
        dm.IBQuery1.ExecSQL;

        alt := true;
      end;
    end;

    dm.IBselect.Close;
    dm.IBselect.SQL.text := 'select max(cod) as venda from contaspagar';

    try
      dm.IBselect.Open;
      tmp := 1;
    except
      tmp := -999;
    end;

    if tmp = 1 then
    begin
      tmp := dm.IBselect.FieldByName('venda').AsInteger;
      if tmp > StrToInt(Incrementa_Generator('small', 0)) then
      begin
        reStartGenerator('small', tmp + 1);
      end;
    end;

    dm.IBselect.Close;
    dm.IBselect.SQL.text := 'select max(cod) as venda from vendedor';

    try
      dm.IBselect.Open;
      tmp := 1;
    except
      tmp := -999;
    end;

    if tmp = 1 then
    begin
      tmp := dm.IBselect.FieldByName('venda').AsInteger;
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

    { if not verificaSeExisteIndiceTrueExiste('VENDAS_IDX2') then
      begin
      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add('CREATE INDEX VENDAS_IDX2' +
      ' ON VENDA (DATA)');
      dm.IBQuery1.ExecSQL;
      end; }

    { if not verificaSeExisteIndiceTrueExiste('ITEM_VENDA_IDX1') then
      begin
      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add('CREATE INDEX ITEM_VENDA_IDX1' +
      ' ON ITEM_VENDA (DATA)');
      dm.IBQuery1.ExecSQL;
      end; }

    if not verificaSeExisteIndiceTrueExiste('PRODUTO_IDX3') then
    begin
      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add('CREATE INDEX PRODUTO_IDX3' + ' ON PRODUTO (REFORI)');
      dm.IBQuery1.ExecSQL;
    end;

    { if not verificaSeExisteIndiceTrueExiste('ITEM_VENDA_IDX2') then
      begin
      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add('CREATE INDEX ITEM_VENDA_IDX2' +
      ' ON ITEM_VENDA (NOTA, COD)');
      dm.IBQuery1.ExecSQL;
      end; }

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
      dm.IBQuery1.SQL.Add('CREATE INDEX NFCE_IDX2 ON NFCE (adic)');
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

    if retornaEscalaDoCampo('p_compra', 'ITEM_entrada') <> 6 then
    begin
      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add
        ('ALTER TABLE ITEM_entrada ALTER p_compra TYPE NUMERIC(15,6)');
      dm.IBQuery1.ExecSQL;
    end;

    if retornaEscalaDoCampo('quant', 'ITEM_entrada') <> 6 then
    begin
      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add
        ('ALTER TABLE ITEM_entrada ALTER quant TYPE NUMERIC(15,6)');
      dm.IBQuery1.ExecSQL;
    end;

    if retornaEscalaDoCampo('p_venda', 'ITEM_ORCAMENTO') <> 3 then
    begin
      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add
        ('ALTER TABLE ITEM_ORCAMENTO ALTER p_venda TYPE NUMERIC(12,3)');
      dm.IBQuery1.ExecSQL;
    end;

    try
      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.text :=
        ('update produto set p_compra = p_venda / 2 where p_compra < 0');
      dm.IBQuery1.ExecSQL;

      try
        if retornaEscalaDoCampo('p_venda', 'item_venda') <> 3 then
        begin
          dm.IBQuery1.Close;
          dm.IBQuery1.SQL.Clear;
          dm.IBQuery1.SQL.Add
            ('ALTER TABLE item_venda ALTER p_venda TYPE NUMERIC(12,3)');
          dm.IBQuery1.ExecSQL;
        end;
      except
        on e: exception do
        begin
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

    // jss. cria tabelas para o bloco K
    // cria tabela producao_estoque
    if NOT verSeExisteTabela('PRODUCAO_ESTOQUE') then
    begin
      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.text := 'CREATE TABLE PRODUCAO_ESTOQUE (' +
        'ano_mes VARCHAR(6) DEFAULT '''' NOT NULL, ' +
        'cod integer DEFAULT 0 NOT NULL, ' + 'quant NUMERIC(10,2) DEFAULT 0)';

      dm.IBQuery1.ExecSQL;
      dm.IBQuery1.Transaction.Commit;
      dm.IBQuery1.Close;

      dm.IBQuery1.SQL.text := 'alter table PRODUCAO_ESTOQUE ' +
        'add constraint PK_producao_estoque ' + 'primary key (ano_mes, cod)';
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

    // cria tabela producao_mov
    if NOT verSeExisteTabela('PRODUCAO_MOV') then
    begin
      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.text := 'CREATE TABLE PRODUCAO_MOV (' +
        'doc integer DEFAULT 0 NOT NULL, ' + 'data DATE DEFAULT ' +
        QuotedStr('01.01.1900') + ', ' + 'cod integer DEFAULT 0 NOT NULL, ' +
        'cod_insumo integer DEFAULT 0 NOT NULL, ' +
        'ano_mes VARCHAR(6) DEFAULT '''' NOT NULL, ' +
        'quant NUMERIC(10,2) DEFAULT 0)';

      dm.IBQuery1.ExecSQL;
      dm.IBQuery1.Transaction.Commit;
      dm.IBQuery1.Close;

      dm.IBQuery1.SQL.text := 'alter table PRODUCAO_MOV ' +
        'add constraint PK_producao_mov ' + 'primary key (doc)';
      dm.IBQuery1.ExecSQL;
      dm.IBQuery1.Transaction.Commit;
    end;

    // jss. Cria campo QUANT_CONSUMIDA na tabela PRODUCAO_MOV
    if not VerificaCampoTabela('QUANT_CONSUMIDA', 'PRODUCAO_MOV') then
    begin
      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add
        ('ALTER TABLE PRODUCAO_MOV ADD QUANT_CONSUMIDA NUMERIC(10, 2) DEFAULT 0');
      dm.IBQuery1.ExecSQL;
      alt := true;
      dm.IBQuery1.Transaction.Commit;

      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.text := 'update PRODUCAO_MOV set QUANT_CONSUMIDA = 0';
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

    // cria tabela producao_cad_ins
    if NOT verSeExisteTabela('PRODUCAO_CAD_INS') then
    begin
      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.text := 'CREATE TABLE PRODUCAO_CAD_INS (' +
        'cod integer DEFAULT 0 NOT NULL, ' +
        'cod_insumo integer DEFAULT 0 NOT NULL, ' +
        'quant NUMERIC(4,2) DEFAULT 0, ' + 'perda NUMERIC(4,2) DEFAULT 0)';

      dm.IBQuery1.ExecSQL;
      dm.IBQuery1.Transaction.Commit;
      dm.IBQuery1.Close;

      dm.IBQuery1.SQL.text := 'alter table PRODUCAO_CAD_INS ' +
        'add constraint PK_producao_cad_ins ' + 'primary key (cod, cod_insumo)';
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
    // jss. fim bloco que cria tabelas bloco K

    dm.IBQuery1.Close;
    dm.IBQuery1.SQL.text := 'update registro set versao1 = 0.1';
    dm.IBQuery1.ExecSQL;
    versao := 0.1;
  end;

  if versao <= 0.1 then
  begin
    if funcoes.retornaTamanhoDoCampoBD('nome', 'cliente') = 40 then
    begin
      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add('alter table cliente alter nome type VARCHAR(60)');
      dm.IBQuery1.ExecSQL;
    end;

    if funcoes.retornaTamanhoDoCampoBD('obs', 'cliente') = 50 then
    begin
      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add('alter table cliente alter obs type VARCHAR(60)');
      dm.IBQuery1.ExecSQL;
    end;

    if not VerificaCampoTabela('XML', 'NFE') then
    begin
      try
        dm.IBQuery1.Close;
        dm.IBQuery1.SQL.text :=
          'ALTER TABLE NFE ADD XML BLOB SUB_TYPE 1 SEGMENT SIZE 4096 ';
        dm.IBQuery1.ExecSQL;
        dm.IBQuery1.Transaction.Commit;
      finally

      end;
    end;

    adicionaNFes;

    if NOT verSeExisteTabela('EMAIL') then
    begin
      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.text :=
        'CREATE TABLE EMAIL (COD INTEGER NOT NULL,EMAIL VARCHAR(150),SENHA VARCHAR(150),'
        + 'PORTA VARCHAR(10),NOME VARCHAR(50),SETSSL VARCHAR(1),SETTLS VARCHAR(1), HOST VARCHAR(150))';
      dm.IBQuery1.ExecSQL;
      dm.IBQuery1.Transaction.Commit;

      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.text :=
        'alter table EMAIL add constraint PK_EMAIL primary key (COD)';
      dm.IBQuery1.ExecSQL;
      dm.IBQuery1.Transaction.Commit;

      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.text :=
        'insert into EMAIL (COD, email, senha, porta, nome, setssl, settls, HOST) values('
        + '1, ''sistemas@controlw.blog.br'', ''controlw123'', ''587'', ''ControlW Sistemas'', ''0'', ''1'', ''mx1.hostinger.com.br'')';
      dm.IBQuery1.ExecSQL;
    end;

    if not VerificaCampoTabela('codseq', 'os_itens') then
    begin
      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add('ALTER TABLE os_itens ADD codseq integer ' +
        'DEFAULT 0');
      dm.IBQuery1.ExecSQL;

      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add('CREATE SEQUENCE ositens');
      dm.IBQuery1.ExecSQL;

      dm.IBQuery1.Transaction.Commit;
      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add('update os_itens set codseq = gen_id(ositens, 1)');
      dm.IBQuery1.ExecSQL;
    end;

    if not VerificaCampoTabela('ENT_AGORA', 'CONT_ENTREGA') then
    begin
      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add('ALTER TABLE CONT_ENTREGA ADD ENT_AGORA VARCHAR(1) ' +
        'DEFAULT ' + QuotedStr(''));
      dm.IBQuery1.ExecSQL;
    end;

    if not VerificaCampoTabela('DATA_bACKUP', 'REGISTRO') then
    begin
      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add('ALTER TABLE REGISTRO ADD DATA_bACKUP DATE ' +
        'DEFAULT ' + QuotedStr('01.01.1900'));
      dm.IBQuery1.ExecSQL;
    end;

    if not VerificaCampoTabela('NOTA', 'ACESSO') then
    begin
      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add('ALTER TABLE ACESSO ADD NOTA INTEGER ' + 'DEFAULT ' +
        QuotedStr('0'));
      dm.IBQuery1.ExecSQL;
    end;

    if not VerificaCampoTabela('MANIFESTADA', 'NFEDISTRIBUICAO') then
    begin
      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add
        ('ALTER TABLE NFEDISTRIBUICAO ADD MANIFESTADA VARCHAR(1) ' + 'DEFAULT '
        + QuotedStr(''));
      dm.IBQuery1.ExecSQL;
    end;

    if not VerificaCampoTabela('ALIQICMS', 'MOV_FRE') then
    begin
      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add('ALTER TABLE MOV_FRE ADD ALIQICMS NUMERIC(10, 3) ' +
        'DEFAULT 0');
      dm.IBQuery1.ExecSQL;
    end;

    if funcoes.retornaTamanhoDoCampoBD('obs', 'produto') = 40 then
    begin
      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add('alter table produto alter obs type VARCHAR(80)');
      dm.IBQuery1.ExecSQL;
    end;

    if funcoes.retornaTamanhoDoCampoBD('configu', 'usuario') = 50 then begin
      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add
        ('alter table usuario alter configu type VARCHAR(200)');
      dm.IBQuery1.ExecSQL;
    end;

    if not VerificaCampoTabela('DATA', 'OS_ITENS') then begin
      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add('ALTER TABLE OS_ITENS ADD DATA TIMESTAMP');
      dm.IBQuery1.ExecSQL;
      dm.IBQuery1.Transaction.Commit;

      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add('UPDATE OS_ITENS O SET DATA = (SELECT DATA FROM SERVICO S WHERE O.nota = S.cod)');
      dm.IBQuery1.ExecSQL;
    end;


    if retornaTipoDoCampo('chegada', 'entrada') = 'DATE' then begin
      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add('alter table entrada alter chegada type TIMESTAMP');
      dm.IBQuery1.ExecSQL;
    end;

    if not VerificaCampoTabela('tipo', 'venda') then begin
      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add('ALTER TABLE venda ADD tipo varchar(3) default '''' ');
      dm.IBQuery1.ExecSQL;
      dm.IBQuery1.Transaction.Commit;
    end;

    if not VerificaCampoTabela('TIPO', 'ALTERACA') then begin
      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add('ALTER TABLE ALTERACA ADD tipo varchar(3) default '''' ');
      dm.IBQuery1.ExecSQL;
      dm.IBQuery1.Transaction.Commit;

      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Text := ('update ALTERACA set tipo = '''' ');
      dm.IBQuery1.ExecSQL;
      dm.IBQuery1.Transaction.Commit;
    end;


    if not VerSeExistePROCEDUREPeloNome('BAIXAESTOQUE') then begin
      //dm.IBScript1.Close;
      dm.IBScript1.Script.Text := ('CREATE PROCEDURE baixaEstoque(cod integer, quant numeric(10, 4), origem integer) returns (nota integer) as' +
      ' DECLARE VARIABLE tipo VARCHAR(25); BEGIN ' +
      ' nota = 1; '+
      ' IF (origem = 2) THEN BEGIN ' +
      ' update produto set DEPOSITO = DEPOSITO + :quant where cod = :cod;' +
      ' END ELSE BEGIN ' +
      ' update produto set quant = quant + :quant where cod = :cod; ' +
      ' END '+
      ' SUSPEND;' +
      'END;');
      dm.IBScript1.ExecuteScript;
      //dm.IBQuery1.Transaction.Commit;
    end;


    if not VerSeExistePROCEDUREPeloNome('ALTERA_CAIXA') then begin
      //dm.IBScript1.Close;
      dm.IBScript1.Script.Text := ('CREATE PROCEDURE ALTERA_CAIXA(cod integer, valor numeric(10, 4), entrada integer) returns (nota integer) as' +
      ' DECLARE VARIABLE tipo VARCHAR(25); BEGIN ' +
      ' nota = 1; '+
      ' IF (entrada = 1) THEN BEGIN ' +
      ' update caixa set entrada = entrada + :valor where codmov = :cod; ' +
      ' END ELSE BEGIN ' +
      ' update caixa set saida   = saida + :valor where codmov = :cod; ' +
      ' END '+
      ' SUSPEND;' +
      'END;');
      dm.IBScript1.ExecuteScript;
      //dm.IBQuery1.Transaction.Commit;
    end;

    if funcoes.retornaTamanhoDoCampoBD('tel', 'cliente') = 8 then begin
      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add
        ('alter table cliente alter tel type VARCHAR(15)');
      dm.IBQuery1.ExecSQL;
    end;

    if funcoes.retornaTamanhoDoCampoBD('SERIE', 'MOV_FRE') = 1 then begin
      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add
        ('alter table MOV_FRE alter SERIE type VARCHAR(4)');
      dm.IBQuery1.ExecSQL;
    end;


    if not VerificaCampoTabela('RECEBIDO', 'NFCE') then begin
      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add('ALTER TABLE NFCE ADD RECEBIDO NUMERIC(4, 2) default 0');
      dm.IBQuery1.ExecSQL;
      dm.IBQuery1.Transaction.Commit;
    end;


    if not VerificaCampoTabela('RECEBIDO', 'VENDA') then begin
      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add('ALTER TABLE VENDA ADD RECEBIDO NUMERIC(12, 2) default 0');
      dm.IBQuery1.ExecSQL;
      dm.IBQuery1.Transaction.Commit;
    end;

    if retornaEscalaDoCampo('recebido', 'nfce', 'PRECISAO') = 4 then begin
      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add('ALTER TABLE nfce alter RECEBIDO type NUMERIC(12, 2)');
      dm.IBQuery1.ExecSQL;
      dm.IBQuery1.Transaction.Commit;
    end;

    if verificaSeExisteIndiceTrueExiste('PK_MOV_FRE') then begin
      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add('update RDB$RELATION_FIELDS set RDB$NULL_FLAG = 1 where (RDB$FIELD_NAME = ''TRANSP'') and (RDB$RELATION_NAME = ''MOV_FRE'')');
      dm.IBQuery1.ExecSQL;
      dm.IBQuery1.Transaction.Commit;

      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add('ALTER TABLE MOV_FRE DROP CONSTRAINT PK_MOV_FRE, ADD PRIMARY KEY (NUMDOC, TRANSP)');
      dm.IBQuery1.ExecSQL;
      dm.IBQuery1.Transaction.Commit;
    end;

    if funcoes.retornaTamanhoDoCampoBD('OBS', 'OBS_VENDA') = 70 then begin
      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add
        ('alter table OBS_VENDA alter OBS type VARCHAR(800)');
      dm.IBQuery1.ExecSQL;
      dm.IBQuery1.Transaction.Commit;
    end;

    if funcoes.retornaTamanhoDoCampoBD('VENDEDOR', 'ITEM_VENDA') = 3 then begin
      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add
        ('alter table ITEM_VENDA alter VENDEDOR type VARCHAR(6)');
      dm.IBQuery1.ExecSQL;
      dm.IBQuery1.Transaction.Commit;
    end;

    if not VerificaCampoTabela('TIPO', 'ITEM_VENDA') then begin
      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add('ALTER TABLE ITEM_VENDA ADD TIPO varchar(3) default '''' ');
      dm.IBQuery1.ExecSQL;
      dm.IBQuery1.Transaction.Commit;
    end;

    try
    if not VerSeExisteTRIGGERPeloNome('ALTERA_PRODUTO') then begin
      //dm.IBScript1.Close;
      dm.IBScript1.Script.Text := ('CREATE TRIGGER altera_produto FOR item_venda ' +
      ' ACTIVE BEFORE INSERT POSITION 0 AS BEGIN ' +
      ' if (new.tipo = ''P'') then exit;'+
      ' if (new.origem <= 1) then begin ' +
      ' update produto set quant = quant - new.quant where cod = new.cod; ' +
      ' end else begin ' +
      ' update produto set deposito = deposito - new.quant where cod = new.cod; ' +
      ' END '+
      ' END;');
      dm.IBScript1.ExecuteScript;
      //dm.IBQuery1.Transaction.Commit;
    end;
    finally

    end;

    //VerificaVersao_do_bd
  end;

  if not VerificaCampoTabela('TENTATIVA', 'NFCE') then begin
    dm.IBQuery1.Close;
    dm.IBQuery1.SQL.Text := ('ALTER TABLE NFCE ADD TENTATIVA SMALLINT DEFAULT 0');
    dm.IBQuery1.ExecSQL;
    dm.IBQuery1.Transaction.Commit;

    dm.IBQuery1.Close;
    dm.IBQuery1.SQL.Text := ('update nfce set TENTATIVA = 0 WHERE ADIC = ''OFF''');
    dm.IBQuery1.ExecSQL;
  end;

  if not VerificaCampoTabela('USUARIO', 'NFCE') then begin
    dm.IBQuery1.Close;
    dm.IBQuery1.SQL.Text := ('ALTER TABLE NFCE ADD USUARIO SMALLINT DEFAULT 0');
    dm.IBQuery1.ExecSQL;
    dm.IBQuery1.Transaction.Commit;

    dm.IBQuery1.Close;
    dm.IBQuery1.SQL.Text := ('update nfce set USUARIO = 0 WHERE ADIC = ''OFF''');
    dm.IBQuery1.ExecSQL;
  end;

  if versao <= 0.2 then
  begin

  end;

  if dm.IBQuery1.Transaction.InTransaction then
    dm.IBQuery1.Transaction.Commit;

  pger.Free;

  atualizaMSGsObsVenda;

  DeleteFile(caminhoEXE_com_barra_no_final + 'bd0.fdb');
  DeleteFile(caminhoEXE_com_barra_no_final + 'exec.bat');
  DeleteFile(caminhoEXE_com_barra_no_final + 'cp.bat');
end;

function ValidaCPF(sCPF: string): boolean;
var
  sDigs, sVal: string;
  iSTot, iSTot2: integer;
  i: integer;
begin
  Result := False;
  if length(sCPF) <> 11 then
    exit;

  sCPF := trim(funcoes.StrNum(sCPF));

  if StrToIntDef(sCPF, 0) = 0 then
    exit;

  iSTot := 0;
  iSTot2 := 0;
  if length(sCPF) = 11 then
  begin
    for i := 9 downto 1 do
    begin
      iSTot := iSTot + StrToInt(sCPF[i]) * (11 - i);
      iSTot2 := iSTot2 + StrToInt(sCPF[i]) * (12 - i);
    end;
    iSTot := iSTot mod 11;
    sDigs := sDigs + IntToStr(iif(iSTot < 2, 0, 11 - iSTot));
    iSTot2 := iSTot2 + 2 * StrToInt(sDigs);
    iSTot2 := iSTot2 mod 11;
    sDigs := sDigs + IntToStr(iif(iSTot2 < 2, 0, 11 - iSTot2));
    sVal := copy(sCPF, 10, 2);
    Result := iif(sDigs = sVal, true, False);
  end;
end;

function iif(lTest: boolean; vExpr1, vExpr2: variant): variant;
begin
  if lTest then
    Result := vExpr1
  else
    Result := vExpr2
end;

function ValidaCNPJ(cnpj: string): boolean;
var
  i, digito1, digito2, cont: integer;
begin
  // Deleta a mascara do CPF caso tenho
  cnpj := funcoes.StrNum(cnpj);
  if (length(cnpj) <> 14) then // Verifica se o mesmo possui 14 digitos exatos
  begin
    Result := False;
    exit;
  end
  else if (cnpj = '00000000000000') then // Verifica se todos os digitos são 0
    Result := False
  else
  begin
    digito1 := 0;
    digito2 := 0;
    cont := 2;
    try // Caso ocorra algum erro não previsto retorna False
      for i := 12 downto 1 do
      begin
        if cont = 10 then
          cont := 2;
        digito1 := digito1 + (StrToInt(cnpj[i]) * cont);
        digito2 := digito2 + (StrToInt(cnpj[i + 1]) * cont);
        cont := cont + 1;
      end;
      digito2 := digito2 + (StrToInt(cnpj[1]) * 6);
      if (digito1 mod 11) < 2 then
        digito1 := 0
      else
        digito1 := 11 - (digito1 mod 11);
      if (digito2 mod 11) < 2 then
        digito2 := 0
      else
        digito2 := 11 - (digito2 mod 11);
      if (digito1 <> StrToInt(cnpj[13])) or (digito2 <> StrToInt(cnpj[14])) then
        Result := False
      else
        Result := true;
    except
      Result := False;
    end;
  end;
end;

function StringToInteger(ent: String): integer;
var
  cont: integer;
  temp: string;
begin
  temp := '';
  Result := 0;
  for cont := 1 to length(ent) do
  begin
    Result := Result + ord(ent[cont]);
  end;
end;

function Tfuncoes.IniciaNfe: boolean;
begin
  if not FileExists(GetTheWindowsDirectory + '\system32\libeay32.dll') then
  begin
    CopyFile(PChar('lib\libeay32.dll'),
      PChar(GetTheWindowsDirectory + '\system32\libeay32.dll'), true);
  end;

  if not FileExists(GetTheWindowsDirectory + '\system32\ssleay32.dll') then
  begin
    CopyFile(PChar('lib\ssleay32.dll'),
      PChar(GetTheWindowsDirectory + '\system32\ssleay32.dll'), true);
  end;

end;

function Tfuncoes.RetornaMaiorTstrings(entra: TStrings): string;
var
  i, Len, fim: integer;
begin
  fim := entra.count - 1;
  Len := 0;
  Result := '';
  for i := 0 to fim do
  begin
    if length(entra.Strings[i]) > Len then
    begin
      Result := entra.Strings[i];
      Len := length(entra.Strings[i]);
    end;
  end;
end;

function Tfuncoes.StrNum(const entra: string): string;
begin
  Result := '';
  for cont := 1 to length(entra) do
  begin
    if Contido(entra[cont], '1234567890') then
      Result := Result + entra[cont];
  end;
  if Result = '' then
    Result := '0';
end;

function StrNum(const entra: string): string;
begin
  Result := '';
  for cont := 1 to length(entra) do
  begin
    if Contido(entra[cont], '1234567890') then
      Result := Result + entra[cont];
  end;
  if Result = '' then
    Result := '0';
end;

procedure Tfuncoes.Ibquery_to_clienteDataSet(var ibquer: TIBQuery;
  var Cliente: TClientDataSet);
var
  i: integer;
begin
  for i := 0 to ibquer.Fields.count - 1 do
  begin
    Cliente.FieldDefs.Add(ibquer.FieldDefs.Items[i].Name,
      ibquer.FieldDefs.Items[i].DataType, ibquer.FieldDefs.Items[i].Size,
      ibquer.FieldDefs.Items[i].Required);
  end;
  Cliente.CreateDataSet;
  Cliente.EmptyDataSet;
end;

function RetornaAcessoUsuario: integer;
begin
  Result := length(form22.Pgerais.Values['acessousu']);
end;

procedure Tfuncoes.GeraCarne(nota, tipo: String);
var
  tudo, numero, sim, PEDI: string;
  num: integer;
begin
  sim := funcoes.dialogo('normal', 0, 'SN', 30, False, 'S', Application.Title,
    'Enviar para Impressora?(S/N)' + #13 + #10, 'N');
  if (sim = '*') then
    exit;

  if tipo = '2' then
  begin
    dm.IBselect.Close;
    dm.IBselect.SQL.Clear;
    dm.IBselect.SQL.Add('select * from contasreceber where (nota = ' + nota +
      ') and (pago=0) order by vencimento ');
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
    dm.IBQuery1.SQL.Add('select * from carne where nota=' + nota);
    dm.IBQuery1.Open;

    if dm.IBQuery1.IsEmpty then
    begin
      numero := funcoes.novocod('carne');
      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add('insert into carne(nota,numero) values(' + nota + ','
        + numero + ')');
      dm.IBQuery1.ExecSQL;
    end
    else
      numero := dm.IBQuery1.FieldByName('numero').AsString;

    dm.IBQuery1.Close;
    dm.IBQuery1.SQL.Clear;
    dm.IBQuery1.SQL.Add
      ('select cliente.*,rota.nome as NomeRota from cliente,rota where (rota.cod = cliente.rota) and (cliente.cod='
      + dm.IBselect.FieldByName('documento').AsString + ')');
    dm.IBQuery1.Open;

    form19.RichEdit1.Clear;
    // funcoes.CharSetRichEdit(form19.RichEdit1);

    dm.IBQuery2.Close;
    dm.IBQuery2.SQL.Clear;
    dm.IBQuery2.SQL.Add('select * from registro');
    dm.IBQuery2.Open;
    addRelatorioForm19('  ' + #15 + #13 + #10);
    num := 0;
    while not dm.IBselect.Eof do
    begin
      if num = 4 then
      begin
        num := 0;
        addRelatorioForm19(' ' + #12 + #13 + #10);
        addRelatorioForm19('  ' + #13 + #10);
      end;

      addRelatorioForm19('   ' + funcoes.CompletaOuRepete(#218, #194, #196, 40)
        + funcoes.CompletaOuRepete('', #191, #196, 22) + '   ' +
        funcoes.CompletaOuRepete(#218, #194, #196, 40) +
        funcoes.CompletaOuRepete('', #191, #196, 22) + #13 + #10);
      addRelatorioForm19('   ' + funcoes.CompletaOuRepete(#179 + ' ' +
        form22.Pgerais.Values['empresa'], #179, ' ', 40) +
        funcoes.CompletaOuRepete('PARCELA: ' +
        copy(dm.IBselect.FieldByName('historico').AsString,
        length(dm.IBselect.FieldByName('historico').AsString) - 5,
        length(dm.IBselect.FieldByName('historico').AsString)), #179, ' ', 22) +
        '   ' + funcoes.CompletaOuRepete(#179 + ' ' + form22.Pgerais.Values
        ['empresa'], #179, ' ', 40) + funcoes.CompletaOuRepete('PARCELA: ' +
        copy(dm.IBselect.FieldByName('historico').AsString,
        length(dm.IBselect.FieldByName('historico').AsString) - 5,
        length(dm.IBselect.FieldByName('historico').AsString)), #179, ' ', 22) +
        #13 + #10);
      addRelatorioForm19('   ' + funcoes.CompletaOuRepete(#195, #193, #196, 40)
        + funcoes.CompletaOuRepete('', #180, #196, 22) + '   ' +
        funcoes.CompletaOuRepete(#195, #193, #196, 40) +
        funcoes.CompletaOuRepete('', #180, #196, 22) + #13 + #10);
      // addRelatorioForm19('   '+funcoes.CompletaOuRepete(#179+'  NOME','VALOR R$     '+#179,' ',62)+'   '+funcoes.CompletaOuRepete(#179+'  NOME','VALOR R$     '+#179,' ',62)+#13+#10);
      addRelatorioForm19('   ' + funcoes.CompletaOuRepete(#179 + ' ALUNO(A): ' +
        dm.IBQuery1.FieldByName('cod').AsString + '-' + dm.IBQuery1.FieldByName
        ('nome').AsString, #179, ' ', 62) + '   ' + funcoes.CompletaOuRepete
        (#179 + ' ALUNO(A): ' + dm.IBQuery1.FieldByName('cod').AsString + '-' +
        dm.IBQuery1.FieldByName('nome').AsString, #179, ' ', 62) + #13 + #10);
      addRelatorioForm19('   ' + funcoes.CompletaOuRepete(#179, #179, ' ', 62) +
        '   ' + funcoes.CompletaOuRepete(#179, #179, ' ', 62) + #13 + #10);
      addRelatorioForm19('   ' + funcoes.CompletaOuRepete(#179 + ' MATRICULA: '
        + copy(dm.IBQuery1.FieldByName('obs').AsString, 1, 40), #179, ' ', 62) +
        '   ' + funcoes.CompletaOuRepete(#179 + ' MATRICULA: ' +
        copy(dm.IBQuery1.FieldByName('obs').AsString, 1, 40), #179, ' ', 62) +
        #13 + #10);
      addRelatorioForm19('   ' + funcoes.CompletaOuRepete(#179, #179, ' ', 62) +
        '   ' + funcoes.CompletaOuRepete(#179, #179, ' ', 62) + #13 + #10);
      addRelatorioForm19('   ' + funcoes.CompletaOuRepete(#179 + ' CURSO: ' +
        dm.IBQuery1.FieldByName('nomerota').AsString, #179, ' ', 62) + '   ' +
        funcoes.CompletaOuRepete(#179 + ' CURSO: ' + dm.IBQuery1.FieldByName
        ('nomerota').AsString, #179, ' ', 62) + #13 + #10);
      addRelatorioForm19('   ' + funcoes.CompletaOuRepete(#179, #179, ' ', 62) +
        '   ' + funcoes.CompletaOuRepete(#179, #179, ' ', 62) + #13 + #10);
      addRelatorioForm19('   ' + funcoes.CompletaOuRepete(#179 + ' POLO: ' +
        dm.IBQuery2.FieldByName('cid').AsString + ' - ' +
        dm.IBQuery2.FieldByName('est').AsString, #179, ' ', 62) + '   ' +
        funcoes.CompletaOuRepete(#179 + ' POLO: ' + dm.IBQuery2.FieldByName
        ('cid').AsString + ' - ' + dm.IBQuery2.FieldByName('est').AsString,
        #179, ' ', 62) + #13 + #10);
      addRelatorioForm19('   ' + funcoes.CompletaOuRepete(#179, #179, ' ', 62) +
        '   ' + funcoes.CompletaOuRepete(#179, #179, ' ', 62) + #13 + #10);
      addRelatorioForm19('   ' + funcoes.CompletaOuRepete(#179 + ' ' +
        funcoes.CompletaOuRepete(#218, #191, #196, 58), ' '#179, ' ', 62) +
        '   ' + funcoes.CompletaOuRepete(#179 + ' ' + funcoes.CompletaOuRepete
        (#218, #191, #196, 58), ' '#179, ' ', 62) + #13 + #10);
      addRelatorioForm19('   ' + funcoes.CompletaOuRepete(#179 + ' ' +
        funcoes.CompletaOuRepete(#179 + ' VENCIMENTO: ',
        FormatDateTime('dd/mm/yy', dm.IBselect.FieldByName('vencimento')
        .AsDateTime) + '  ' + #179, '.', 58), ' '#179, ' ', 62) + '   ' +
        funcoes.CompletaOuRepete(#179 + ' ' + funcoes.CompletaOuRepete(#179 +
        ' VENCIMENTO: ', FormatDateTime('dd/mm/yy',
        dm.IBselect.FieldByName('vencimento').AsDateTime) + '  ' + #179, '.',
        58), ' '#179, ' ', 62) + #13 + #10);
      addRelatorioForm19('   ' + funcoes.CompletaOuRepete(#179 + ' ' +
        funcoes.CompletaOuRepete(#179, #179, ' ', 58), #179, ' ', 62) + '   ' +
        funcoes.CompletaOuRepete(#179 + ' ' + funcoes.CompletaOuRepete(#179,
        #179, ' ', 58), #179, ' ', 62) + #13 + #10);
      addRelatorioForm19('   ' + funcoes.CompletaOuRepete(#179 + ' ' +
        funcoes.CompletaOuRepete(#179 + ' VALOR ATE O VENCIMENTO: ',
        FormatCurr('#,###,###0.00', dm.IBselect.FieldByName('valor').AsCurrency)
        + '  ' + #179, '.', 58), ' '#179, ' ', 62) + '   ' +
        funcoes.CompletaOuRepete(#179 + ' ' + funcoes.CompletaOuRepete(#179 +
        ' VALOR ATE O VENCIMENTO: ', FormatCurr('#,###,###0.00',
        dm.IBselect.FieldByName('valor').AsCurrency) + '  ' + #179, '.', 58),
        ' '#179, ' ', 62) + #13 + #10);
      addRelatorioForm19('   ' + funcoes.CompletaOuRepete(#179 + ' ' +
        funcoes.CompletaOuRepete(#179, #179, ' ', 58), #179, ' ', 62) + '   ' +
        funcoes.CompletaOuRepete(#179 + ' ' + funcoes.CompletaOuRepete(#179,
        #179, ' ', 58), #179, ' ', 62) + #13 + #10);
      addRelatorioForm19('   ' + funcoes.CompletaOuRepete(#179 + ' ' +
        funcoes.CompletaOuRepete(#179 + ' MULTA (2%): ',
        FormatCurr('#,###,###0.00', Arredonda(dm.IBselect.FieldByName('valor')
        .AsCurrency * 0.02, 2)) + '  ' + #179, '.', 58), ' '#179, ' ', 62) +
        '   ' + funcoes.CompletaOuRepete(#179 + ' ' + funcoes.CompletaOuRepete
        (#179 + ' MULTA (2%): ', FormatCurr('#,###,###0.00',
        Arredonda(dm.IBselect.FieldByName('valor').AsCurrency * 0.02, 2)) + '  '
        + #179, '.', 58), ' '#179, ' ', 62) + #13 + #10);
      addRelatorioForm19('   ' + funcoes.CompletaOuRepete(#179 + ' ' +
        funcoes.CompletaOuRepete(#179, #179, ' ', 58), #179, ' ', 62) + '   ' +
        funcoes.CompletaOuRepete(#179 + ' ' + funcoes.CompletaOuRepete(#179,
        #179, ' ', 58), #179, ' ', 62) + #13 + #10);
      addRelatorioForm19('   ' + funcoes.CompletaOuRepete(#179 + ' ' +

        funcoes.CompletaOuRepete(#179 + ' CORRECAO (' + ConfParamGerais.Strings
        [6] + '/dia): ', FormatCurr('#,###,###0.00',
        Arredonda(dm.IBselect.FieldByName('valor').AsCurrency *
        StrToCurr(funcoes.ConverteNumerico(ConfParamGerais.Strings[6])) / 100,
        2)) + '  ' + #179, '.', 58), ' '#179, ' ', 62) + '   ' +

        funcoes.CompletaOuRepete(#179 + ' ' + funcoes.CompletaOuRepete(#179 +
        ' CORRECAO (' + ConfParamGerais.Strings[6] + '/dia): ',
        FormatCurr('#,###,###0.00', Arredonda(dm.IBselect.FieldByName('valor')
        .AsCurrency * StrToCurr(funcoes.ConverteNumerico(ConfParamGerais.Strings
        [6])) / 100, 2)) + '  ' + #179, '.', 58), ' '#179, ' ', 62) +
        #13 + #10);
      addRelatorioForm19('   ' + funcoes.CompletaOuRepete(#179 + ' ' +
        funcoes.CompletaOuRepete(#179, #179, ' ', 58), #179, ' ', 62) + '   ' +
        funcoes.CompletaOuRepete(#179 + ' ' + funcoes.CompletaOuRepete(#179,
        #179, ' ', 58), #179, ' ', 62) + #13 + #10);
      addRelatorioForm19('   ' + funcoes.CompletaOuRepete(#179 + ' ' +
        funcoes.CompletaOuRepete(#179 + ' TOTAL R$: ', '___________________  ' +
        #179, '.', 58), ' '#179, ' ', 62) + '   ' + funcoes.CompletaOuRepete
        (#179 + ' ' + funcoes.CompletaOuRepete(#179 + ' TOTAL R$: ',
        '___________________  ' + #179, '.', 58), ' '#179, ' ', 62) +
        #13 + #10);
      addRelatorioForm19('   ' + funcoes.CompletaOuRepete(#179 + ' ' +
        funcoes.CompletaOuRepete(#192, #217, #196, 58), #179, ' ', 62) + '   ' +
        funcoes.CompletaOuRepete(#179 + ' ' + funcoes.CompletaOuRepete(#192,
        #217, #196, 58), #179, ' ', 62) + #13 + #10);
      addRelatorioForm19('   ' + funcoes.CompletaOuRepete(#179 +
        funcoes.centraliza('RECIBO ALUNO', ' ', 60), #179, ' ', 62) + '   ' +
        funcoes.CompletaOuRepete(#179 + funcoes.centraliza('RECIBO CURSO', ' ',
        60), #179, ' ', 62) + #13 + #10);
      addRelatorioForm19('   ' + funcoes.CompletaOuRepete(#192, #217, #196, 62)
        + '   ' + funcoes.CompletaOuRepete(#192, #217, #196, 62) + #13 + #10);
      addRelatorioForm19('   ' + #13 + #10);
      num := num + 1;
      dm.IBselect.Next;
    end;

    dm.IBselect.Close;
    dm.IBQuery2.Close;
    dm.IBQuery1.Close;
    if sim = 'S' then
      imprime.textxArq('')
    else
      form19.ShowModal;
  end
  else if ((tipo = '1') or ((tipo = '3'))) then
  begin
    dm.IBselect.Close;
    dm.IBselect.SQL.Clear;
    dm.IBselect.SQL.Add('select * from contasreceber where (nota = ' + nota +
      ') and (pago=0) order by vencimento ');
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
    dm.IBQuery1.SQL.Add('select * from carne where nota=' + nota);
    dm.IBQuery1.Open;

    if dm.IBQuery1.IsEmpty then
    begin
      numero := funcoes.novocod('carne');
      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add('insert into carne(nota,numero) values(' + nota + ','
        + numero + ')');
      dm.IBQuery1.ExecSQL;
    end
    else
      numero := dm.IBQuery1.FieldByName('numero').AsString;

    dm.IBQuery1.Close;
    dm.IBQuery1.SQL.Clear;
    dm.IBQuery1.SQL.Add('select nome, cod from cliente where cod =' +
      dm.IBselect.FieldByName('documento').AsString);
    dm.IBQuery1.Open;

    form19.RichEdit1.Clear;
    funcoes.CharSetRichEdit(form19.RichEdit1);

    dm.IBQuery2.Close;
    dm.IBQuery2.SQL.Clear;
    dm.IBQuery2.SQL.Add('select * from registro');
    dm.IBQuery2.Open;
    addRelatorioForm19('  ' + #15 + #13 + #10);
    num := 0;
    PEDI := LeftStr(dm.IBselect.FieldByName('historico').AsString,
      pos('-', dm.IBselect.FieldByName('historico').AsString) - 1);

    { if tipo = '1' then num := 4
      else num := 5; }

    while not dm.IBselect.Eof do
    begin
      if ((num = 5) and (tipo = '3')) then
      begin
        num := 0;
        addRelatorioForm19(' ' + #12 + #13 + #10);
        addRelatorioForm19('  ' + #13 + #10);
      end;

      if ((num = 4) and (tipo = '1')) then
      begin
        num := 0;
        addRelatorioForm19(' ' + #12 + #13 + #10);
        addRelatorioForm19('  ' + #13 + #10);
      end;

      addRelatorioForm19('   ' + funcoes.CompletaOuRepete(#218, #191, #196, 62)
        + '   ' + funcoes.CompletaOuRepete(#218, #191, #196, 62) + #13 + #10);
      addRelatorioForm19('   ' + funcoes.CompletaOuRepete(#179 +
        funcoes.centraliza(form22.Pgerais.Values['empresa'], ' ', 41),
        dm.IBQuery2.FieldByName('telres').AsString + '    ' + #179, ' ', 62) +
        '   ' + funcoes.CompletaOuRepete(#179 + funcoes.centraliza
        (form22.Pgerais.Values['empresa'], ' ', 41),
        dm.IBQuery2.FieldByName('telres').AsString + '    ' + #179, ' ', 62) +
        #13 + #10);
      addRelatorioForm19('   ' + funcoes.CompletaOuRepete(#179 + '  NOME',
        'VALOR R$     ' + #179, ' ', 62) + '   ' + funcoes.CompletaOuRepete
        (#179 + '  NOME', 'VALOR R$     ' + #179, ' ', 62) + #13 + #10);
      addRelatorioForm19('   ' + funcoes.CompletaOuRepete(#179 + ' ' +
        funcoes.CompletaOuRepete(#218, #191, #196, 39) +
        funcoes.CompletaOuRepete(#218, #191, #196, 19), #179, ' ', 62) + '   ' +
        funcoes.CompletaOuRepete(#179 + ' ' + funcoes.CompletaOuRepete(#218,
        #191, #196, 39) + funcoes.CompletaOuRepete(#218, #191, #196, 19), #179,
        ' ', 62) + #13 + #10);
      addRelatorioForm19('   ' + funcoes.CompletaOuRepete(#179 + ' ' +
        funcoes.CompletaOuRepete(#179 + copy(dm.IBQuery1.FieldByName('cod')
        .AsString + '-' + dm.IBQuery1.FieldByName('nome').AsString, 1, 37),
        #179, ' ', 39) + funcoes.CompletaOuRepete(#179,
        FormatCurr('#,###,###0.00', dm.IBselect.FieldByName('valor').AsCurrency)
        + #179, ' ', 19), #179, ' ', 62) + '   ' + funcoes.CompletaOuRepete
        (#179 + ' ' + funcoes.CompletaOuRepete(#179 +
        copy(dm.IBQuery1.FieldByName('cod').AsString + '-' +
        dm.IBQuery1.FieldByName('nome').AsString, 1, 37), #179, ' ', 39) +
        funcoes.CompletaOuRepete(#179, FormatCurr('#,###,###0.00',
        dm.IBselect.FieldByName('valor').AsCurrency) + #179, ' ', 19), #179,
        ' ', 62) + #13 + #10);
      addRelatorioForm19('   ' + funcoes.CompletaOuRepete(#179 + ' ' +
        funcoes.CompletaOuRepete(#192, #217, #196, 39) +
        funcoes.CompletaOuRepete(#192, #217, #196, 19), #179, ' ', 62) + '   ' +
        funcoes.CompletaOuRepete(#179 + ' ' + funcoes.CompletaOuRepete(#192,
        #217, #196, 39) + funcoes.CompletaOuRepete(#192, #217, #196, 19), #179,
        ' ', 62) + #13 + #10);
      addRelatorioForm19('   ' + funcoes.CompletaOuRepete(#179 +
        '  VENCIMENTO   PARCELA    CORRECAO(' + ConfParamGerais.Strings[6] +
        '%)  TOTAL PAGO R$', #179, ' ', 62) + '   ' + funcoes.CompletaOuRepete
        (#179 + '  VENCIMENTO   PARCELA    CORRECAO(' + ConfParamGerais.Strings
        [6] + '%)  TOTAL PAGO R$', #179, ' ', 62) + #13 + #10);
      addRelatorioForm19('   ' + funcoes.CompletaOuRepete(#179 + ' ' +
        funcoes.CompletaOuRepete(#218, #191, #196, 10) + '   ' +
        funcoes.CompletaOuRepete(#218, #191, #196, 9) + '  ' +
        funcoes.CompletaOuRepete(#218, #191, #196, 15) + ' ' +
        funcoes.CompletaOuRepete(#218, #191, #196, 18), #179, ' ', 62) + '   ' +
        funcoes.CompletaOuRepete(#179 + ' ' + funcoes.CompletaOuRepete(#218,
        #191, #196, 10) + '   ' + funcoes.CompletaOuRepete(#218, #191, #196,
        9) + '  ' + funcoes.CompletaOuRepete(#218, #191, #196, 15) + ' ' +
        funcoes.CompletaOuRepete(#218, #191, #196, 18), #179, ' ', 62) +
        #13 + #10);
      addRelatorioForm19('   ' + funcoes.CompletaOuRepete(#179 + ' ' +
        funcoes.CompletaOuRepete(#179 + FormatDateTime('dd/mm/yy',
        dm.IBselect.FieldByName('vencimento').AsDateTime), #179, ' ', 10) +
        '   ' + funcoes.CompletaOuRepete(#179 +
        copy(dm.IBselect.FieldByName('historico').AsString,
        length(dm.IBselect.FieldByName('historico').AsString) - 5,
        length(dm.IBselect.FieldByName('historico').AsString)), #179, ' ',
        9) + '  ' + funcoes.CompletaOuRepete(#179, FormatCurr('#,###,###0.00',
        Arredonda(dm.IBselect.FieldByName('valor').AsCurrency *
        StrToCurr(funcoes.ConverteNumerico(ConfParamGerais.Strings[6])) / 100,
        2)) + #179, ' ', 15) + ' ' + funcoes.CompletaOuRepete(#179, #179, ' ',
        18), #179, ' ', 62) + '   ' + funcoes.CompletaOuRepete(#179 + ' ' +
        funcoes.CompletaOuRepete(#179 + FormatDateTime('dd/mm/yy',
        dm.IBselect.FieldByName('vencimento').AsDateTime), #179, ' ', 10) +
        '   ' + funcoes.CompletaOuRepete(#179 +
        copy(dm.IBselect.FieldByName('historico').AsString,
        length(dm.IBselect.FieldByName('historico').AsString) - 5,
        length(dm.IBselect.FieldByName('historico').AsString)), #179, ' ',
        9) + '  ' + funcoes.CompletaOuRepete(#179, FormatCurr('#,###,###0.00',
        Arredonda(dm.IBselect.FieldByName('valor').AsCurrency *
        StrToCurr(funcoes.ConverteNumerico(ConfParamGerais.Strings[6])) / 100,
        2)) + #179, ' ', 15) + ' ' + funcoes.CompletaOuRepete(#179, #179, ' ',
        18), #179, ' ', 62) + #13 + #10);
      addRelatorioForm19('   ' + funcoes.CompletaOuRepete(#179 + ' ' +
        funcoes.CompletaOuRepete(#192, #217, #196, 10) + '   ' +
        funcoes.CompletaOuRepete(#192, #217, #196, 9) + '  ' +
        funcoes.CompletaOuRepete(#192, #217, #196, 15) + ' ' +
        funcoes.CompletaOuRepete(#192, #217, #196, 18), #179, ' ', 62) + '   ' +
        funcoes.CompletaOuRepete(#179 + ' ' + funcoes.CompletaOuRepete(#192,
        #217, #196, 10) + '   ' + funcoes.CompletaOuRepete(#192, #217, #196,
        9) + '  ' + funcoes.CompletaOuRepete(#192, #217, #196, 15) + ' ' +
        funcoes.CompletaOuRepete(#192, #217, #196, 18), #179, ' ', 62) +
        #13 + #10);
      addRelatorioForm19('   ' + funcoes.CompletaOuRepete(#179 +
        '     DATA PAGTO            ASSINATURA DO RECEBEDOR', #179, ' ', 62) +
        '   ' + funcoes.CompletaOuRepete(#179 +
        '     DATA PAGTO            ASSINATURA DO RECEBEDOR', #179, ' ', 62) +
        #13 + #10);
      addRelatorioForm19('   ' + funcoes.CompletaOuRepete(#179 + ' ' +
        funcoes.CompletaOuRepete(#218, #191, #196, 22) + ' ' +
        funcoes.CompletaOuRepete(#218, #191, #196, 35), #179, ' ', 62) + '   ' +
        funcoes.CompletaOuRepete(#179 + ' ' + funcoes.CompletaOuRepete(#218,
        #191, #196, 22) + ' ' + funcoes.CompletaOuRepete(#218, #191, #196, 35),
        #179, ' ', 62) + #13 + #10);
      addRelatorioForm19('   ' + funcoes.CompletaOuRepete(#179 + ' ' +
        funcoes.CompletaOuRepete(#179, #179, ' ', 22) + ' ' +
        funcoes.CompletaOuRepete(#179, #179, ' ', 35), #179, ' ', 62) + '   ' +
        funcoes.CompletaOuRepete(#179 + ' ' + funcoes.CompletaOuRepete(#179,
        #179, ' ', 22) + ' ' + funcoes.CompletaOuRepete(#179, #179, ' ', 35),
        #179, ' ', 62) + #13 + #10);
      if tipo = '1' then
      begin
        addRelatorioForm19('   ' + funcoes.CompletaOuRepete(#179 + ' ' +
          funcoes.CompletaOuRepete(#179, #179, ' ', 22) + ' ' +
          funcoes.CompletaOuRepete(#179, #179, ' ', 35), #179, ' ', 62) + '   '
          + funcoes.CompletaOuRepete(#179 + ' ' + funcoes.CompletaOuRepete(#179,
          #179, ' ', 22) + ' ' + funcoes.CompletaOuRepete(#179, #179, ' ', 35),
          #179, ' ', 62) + #13 + #10);
      end;
      addRelatorioForm19('   ' + funcoes.CompletaOuRepete(#179 + ' ' +
        funcoes.CompletaOuRepete(#192, #217, #196, 22) + ' ' +
        funcoes.CompletaOuRepete(#192, #217, #196, 35), #179, ' ', 62) + '   ' +
        funcoes.CompletaOuRepete(#179 + ' ' + funcoes.CompletaOuRepete(#192,
        #217, #196, 22) + ' ' + funcoes.CompletaOuRepete(#192, #217, #196, 35),
        #179, ' ', 62) + #13 + #10);
      if tipo = '1' then
      begin
        addRelatorioForm19('   ' + funcoes.CompletaOuRepete(#179, #179, ' ', 62)
          + '   ' + funcoes.CompletaOuRepete(#179, #179, ' ', 62) + #13 + #10);
        addRelatorioForm19('   ' + funcoes.CompletaOuRepete(#179, #179, ' ', 62)
          + '   ' + funcoes.CompletaOuRepete(#179, #179, ' ', 62) + #13 + #10);
        addRelatorioForm19('   ' + funcoes.CompletaOuRepete(#179, #179, ' ', 62)
          + '   ' + funcoes.CompletaOuRepete(#179, #179, ' ', 62) + #13 + #10);
      end;
      addRelatorioForm19('   ' + funcoes.CompletaOuRepete(#179 +
        '            QUITAC' + #199 + 'O CONDICIONADA ' + #183 + ' COMPENSACAO',
        #179, ' ', 62) + '   ' + funcoes.CompletaOuRepete(#179 +
        '            QUITAC' + #199 + 'O CONDICIONADA ' + #183 + ' COMPENSACAO',
        #179, ' ', 62) + #13 + #10);
      addRelatorioForm19('   ' + funcoes.CompletaOuRepete(#179 + '   Presta' +
        #135 + #229'es Pagas com Atraso Sofrer' + #198 + 'o Acresc' + #214 +
        'mos de Juros', #179, ' ', 62) + '   ' + funcoes.CompletaOuRepete(#179 +
        '   Presta' + #135 + #229'es Pagas com Atraso Sofrer' + #198 +
        'o Acresc' + #214 + 'mos de Juros', #179, ' ', 62) + #13 + #10);
      addRelatorioForm19('   ' + funcoes.CompletaOuRepete(#179 + ' VENDA: ' +
        PEDI + '  CARNE: ' + numero, #179, ' ', 62) + '   ' +
        funcoes.CompletaOuRepete(#179 + ' VENDA: ' + PEDI + '  CARNE: ' +
        numero, #179, ' ', 62) + #13 + #10);
      addRelatorioForm19('   ' + funcoes.CompletaOuRepete(#192, #217, #196, 62)
        + '   ' + funcoes.CompletaOuRepete(#192, #217, #196, 62) + #13 + #10);
      addRelatorioForm19('   ' + #13 + #10);
      num := num + 1;
      dm.IBselect.Next;
    end;

    dm.IBselect.Close;
    dm.IBQuery2.Close;
    dm.IBQuery1.Close;

    imprime.negrito := true;
    // imprime.setCofiguracoesImpressora;

    // if sim = 'S' then imprime.textxArq('')
    if sim = 'S' then
      imprime.textxArq('TEXTO.TXT')
    else
      form19.ShowModal;
  end;
end;

procedure Tfuncoes.Traca_Nome_Rota;
begin
  form2.MainMenu1.Items.Items[5].Items[8].caption := ConfParamGerais.Strings[7];
  form2.MainMenu1.Items.Items[4].Items[1].Items[5].caption := 'Resumo P/' +
    ConfParamGerais.Strings[7];
end;

function VerificaAcesso_Se_Nao_tiver_Nenhum_bloqueio_true_senao_false: boolean;
begin
  if length(form22.Pgerais.Values['acessousu']) > 0 then
    Result := False
  else
    Result := true;
end;

function JustificarStrings(ent: string; qtd: integer): string;
var
  i: integer;
begin
  Result := ent;
  while length(ent) < qtd do
  begin
    for i := 0 to length(ent) do
    begin
      if ent[i] = ' ' then
        Insert(' ', ent, i);
      if length(ent) >= qtd then
      begin
        break;
        Result := ent;
        exit;
      end;
    end;
  end;
end;

procedure addRelatorioForm19(Adicionar: string);
begin
  form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((Adicionar))));
end;

procedure GeraParcelamento(codvenda, formpagto, codcliente, nomecliente,
  vendedor, codgru: string; parcelas, periodo: integer; vencimento1: TDateTime;
  valorp: currency);
var
  i: integer;
  vencimento: TDateTime;
begin
  for i := 1 to parcelas do
  begin
    if i = 1 then
      vencimento := vencimento1;
    dm.IBQuery1.SQL.Clear;
    dm.IBQuery1.SQL.Add
      ('insert into contasreceber(nota,codgru,cod,formpagto,datamov,vendedor,data,vencimento,documento,codhis,historico,total,valor) values('
      + codvenda + ',1,' + funcoes.novocod('cpagar') + ',' + formpagto +
      ',:datamov,' + vendedor + ',:data,:vencimento,' + codcliente +
      ',2,:hist,:total,:valor)');
    dm.IBQuery1.ParamByName('datamov').AsDateTime := form22.dataMov;
    if i <> 1 then
      vencimento := vencimento + periodo;
    dm.IBQuery1.ParamByName('data').AsDateTime := vencimento;
    dm.IBQuery1.ParamByName('vencimento').AsDateTime := vencimento;
    dm.IBQuery1.ParamByName('hist').AsString :=
      funcoes.CompletaOuRepete(copy(codvenda + '-' + nomecliente, 1, 28),
      funcoes.CompletaOuRepete('', IntToStr(i), ' ', 2) + '/' +
      funcoes.CompletaOuRepete('', IntToStr(parcelas), ' ', 2), ' ', 35);
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

function Tfuncoes.QuebraLinhas(ini, fim, entrada: string;
  qtdQuebra: integer): string;
var
  posi, i, a, fim1, c: integer;
  nome, temp: string;
begin

  while length(entrada) <> 0 do
  begin
    if length(ini + entrada + fim) < qtdQuebra then
    begin
      addRelatorioForm19(funcoes.CompletaOuRepete(ini + entrada, fim, ' ',
        qtdQuebra) + #13 + #10);
      exit;
    end;

    for i := qtdQuebra - 1 downto 1 do
    begin
      if length(funcoes.CompletaOuRepete(ini + copy(TrimRight(entrada), 1, c),
        fim, ' ', qtdQuebra)) < qtdQuebra then
      begin
        c := 0;
        break;
      end;
      if (entrada[i] = ' ') and (i < qtdQuebra) then
      begin
        c := i;
        break;
      end;
    end; // copy((entrada),1,c-1)
    if length(funcoes.CompletaOuRepete(ini + copy((entrada), 1, c), fim, ' ',
      qtdQuebra)) = qtdQuebra then
      addRelatorioForm19(funcoes.CompletaOuRepete(ini + copy((entrada), 1,
        c - 1), fim, ' ', qtdQuebra) + #13 + #10)
    else
      addRelatorioForm19(funcoes.CompletaOuRepete(ini + copy(TrimRight(entrada),
        1, c), fim, ' ', qtdQuebra) + #13 + #10);
    if c = 0 then
      Delete(entrada, 1, length(entrada))
    else
      Delete(entrada, 1, c);
  end;
end;

function Tfuncoes.ExisteParcelamento(nota: string): boolean;
begin
  Result := False;
  if nota = '' then
    exit;

  dm.IBQuery1.Close;
  dm.IBQuery1.SQL.Clear;
  dm.IBQuery1.SQL.Add
    ('select vencimento,valor from contasreceber where nota=' + nota);
  dm.IBQuery1.Open;
  if dm.IBQuery1.IsEmpty then
    Result := False
  else
    Result := true;
  dm.IBQuery1.Close;
end;

procedure Tfuncoes.ImprimeParcelamento(ini, fim, entrada, nota: string);
begin
  if StrNum(nota) = '0' then
    exit;

  dm.IBQuery1.Close;
  dm.IBQuery1.SQL.Clear;
  dm.IBQuery1.SQL.Add('select vencimento,valor from contasreceber where nota=' +
    nota + ' and pago = 0 order by vencimento');
  dm.IBQuery1.Open;
  dm.IBQuery1.First;
  if dm.IBQuery1.IsEmpty then
  begin
    dm.IBQuery1.Close;
    exit;
  end;

  form19.RichEdit1.Perform(EM_REPLACESEL, 1,
    Longint(PChar((ini + '* * *  PARCELAMENTO  * * *' + fim + #13 + #10))));
  // form19.RichEdit1.Perform(EM_REPLACESEL, 1,  Longint(PChar((ini + '*                        *' + fim + #13 + #10))));
  form19.RichEdit1.Perform(EM_REPLACESEL, 1,
    Longint(PChar((ini + '* ENTRADA:' + funcoes.CompletaOuRepete('', entrada,
    ' ', 14) + ' *' + fim + #13 + #10))));
  while not dm.IBQuery1.Eof do
  begin
    form19.RichEdit1.Perform(EM_REPLACESEL, 1,
      Longint(PChar((ini + '* ' + FormatDateTime('dd/mm/yy',
      dm.IBQuery1.FieldByName('vencimento').AsDateTime) +
      funcoes.CompletaOuRepete('', FormatCurr('#,###,###0.00',
      dm.IBQuery1.FieldByName('valor').AsCurrency), ' ', 14) + ' *' + fim + #13
      + #10))));
    dm.IBQuery1.Next;
  end;
  // form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((ini + '*                        *' + fim + #13 + #10))));
  form19.RichEdit1.Perform(EM_REPLACESEL, 1,
    Longint(PChar((ini + '* * *  * * * * * * * * * *' + fim + #13 + #10))));
  dm.IBQuery1.Close;

end;

procedure Tfuncoes.GeraTemas;
var
  bs: TStream;
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

  if FileExists(caminhoEXE_com_barra_no_final + funcoes.nomeExec + '.jpg') then
  begin

    form2.Image1.Picture.LoadFromFile(caminhoEXE_com_barra_no_final +
      funcoes.nomeExec + '.jpg');
  end
  else
  begin
    try
      bs := TStream.Create;
      bs := dm.IBselect.CreateBlobStream
        (dm.IBselect.FieldByName('papel1'), bmRead);
      if bs.Size > 0 then
        form2.Image1.Picture.Graphic.LoadFromStream(bs);
      bs.Free;
    except
      exit;
    end;
  end;

  if not dm.IBselect.FieldByName('cor').IsNull then
  begin
    if dm.IBselect.FieldByName('cor').AsInteger = 2 then
    begin
      // form2.Label1.Font.Color := clWhite;
      // form2.Label2.Font.Color := clWhite;
      { form2.Label3.Font.Color := clWhite;
        form2.Label4.Font.Color := clWhite;
        form2.Label5.Font.Color := clWhite;
        form2.Label6.Font.Color := clWhite;
        form2.Label7.Font.Color := clWhite;
        form2.Label8.Font.Color := clWhite;
        Form2.Label2.Visible := false;
      } end
    else
    begin
      { form2.Label1.Font.Color := clblack;
        form2.Label2.Font.Color := clBlack;
        form2.Label3.Font.Color := clBlack;
        form2.Label4.Font.Color := clBlack;
        form2.Label5.Font.Color := clBlack;
        form2.Label6.Font.Color := clBlack;
        form2.Label7.Font.Color := clBlack;
        form2.Label8.Font.Color := clBlack;
        Form2.Label2.Visible := false;
      } end;
  end;
  // if not dm.IBselect.FieldByName('nome').IsNull then  form2.Label1.Caption := dm.IBselect.fieldbyname('nome').AsString ;
  // if not dm.IBselect.FieldByName('top').IsNull then form2.Label1.Top := dm.IBselect.fieldbyname('top').AsInteger;
  // if not dm.IBselect.FieldByName('esq').IsNull then form2.Label1.Left := dm.IBselect.fieldbyname('esq').AsInteger;

end;

function Tfuncoes.TimageToFileStream(caminho: string): TFileStream;
begin
  Result := TFileStream.Create(caminho, fmOpenRead);
end;

function Tfuncoes.RetornaMaiorData(v1: TDateTime; v2: TDateTime): TDateTime;
begin
  if v1 > v2 then
    Result := v1
  else
    Result := v2;
end;

function Tfuncoes.OrdenarValoresStringList(var valor_a_Ser_Ordenado
  : tstringList): tstringList;
var
  a, b: integer;
  valor: currency;
  OK: boolean;
begin
  for b := 0 to valor_a_Ser_Ordenado.count do
  begin
    for a := 0 to valor_a_Ser_Ordenado.count - 1 do
    begin
      if StrToCurr(valor_a_Ser_Ordenado.Values[valor_a_Ser_Ordenado.Names[a]]) > valor
      then
      begin
        valor_a_Ser_Ordenado.Move(a, 0);
        valor := StrToCurr(valor_a_Ser_Ordenado.Values
          [valor_a_Ser_Ordenado.Names[a]]);
      end
      else
        valor := StrToCurr(valor_a_Ser_Ordenado.Values
          [valor_a_Ser_Ordenado.Names[a]]);
    end;
  end;
end;

function Reorganizar: boolean;
var
  indices: tstringList;
  i: integer;
begin
  dm.IBselect.Close;
  dm.IBselect.SQL.Clear;
  dm.IBselect.SQL.Add
    ('select rdb$index_name as nome from rdb$indices where rdb$system_flag is not null and rdb$system_flag = 0');
  dm.IBselect.Open;

  indices := tstringList.Create;

  while not dm.IBselect.Eof do
  begin
    if (not funcoes.Contido('PK', dm.IBselect.FieldByName('nome').AsString)) and
      ((not funcoes.Contido('$', dm.IBselect.FieldByName('nome').AsString))) and
      (not funcoes.Contido('UNQ', dm.IBselect.FieldByName('nome').AsString))
    then
    begin
      indices.Add(dm.IBselect.FieldByName('nome').AsString);
    end;
    dm.IBselect.Next;
  end;

  dm.IBselect.Close;

  For i := 0 to indices.count - 1 do
  begin
    dm.IBQuery1.Close;
    dm.IBQuery1.SQL.Clear;
    dm.IBQuery1.SQL.Add('alter index ' + indices.Strings[i] + ' inactive');
    dm.IBQuery1.ExecSQL;

    dm.IBQuery1.Close;
    dm.IBQuery1.SQL.Clear;
    dm.IBQuery1.SQL.Add('alter index ' + indices.Strings[i] + ' active');
    dm.IBQuery1.ExecSQL;

    dm.IBQuery1.Close;
    dm.IBQuery1.SQL.Clear;
    dm.IBQuery1.SQL.Add('SET STATISTICS INDEX ' + indices.Strings[i]);
    dm.IBQuery1.ExecSQL;
  end;

  indices.Free;
  funcoes.reorganizaProdutos;
  funcoes.reorganizaClientes;

  try
    if dm.IBQuery1.Transaction.InTransaction then
      dm.IBQuery1.Transaction.Commit;
    ShowMessage('Reorganizacao Completada!');
  except

  end;
end;

function HexToTColor(sColor: string): TColor;
begin
  Result := RGB(StrToInt('$' + copy(sColor, 1, 2)),
    StrToInt('$' + copy(sColor, 3, 2)), StrToInt('$' + copy(sColor, 5, 2)));
end;

function VerificaRegistro(param: integer; var bloq: boolean): boolean;
var
  ativo, empresa: string;
  temp, t1: integer;
begin
  Result := False;
  bloq := False;
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
    demo := False;

    dm.IBselect.Close;
    dm.IBselect.SQL.Clear;
    dm.IBselect.SQL.Add
      ('select dtr, acesso from acesso where acesso = ''bloq''');
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
    dm.IBselect.ParamByName('d').AsDateTime := form22.dataMov;
    dm.IBselect.Open;

    if dm.IBselect.IsEmpty then
    begin
      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add('insert into acesso(acesso,dtr, nota) values(' +
        QuotedStr('ativ') + ', :d, 0)');
      dm.IBQuery1.ParamByName('d').AsDateTime := form22.dataMov;
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
      Result := False;
      Ativado := False;
      ShowMessage('Esta Versão de Demonstração Expirou os 15 dias');
    end
    else if temp = 5 then
      ShowMessage('Falta apenas 10 dias Para está cópia expirar.')
    else if temp >= 10 then
      ShowMessage('Falta apenas ' + IntToStr(15 - temp) +
        ' dias Para está cópia expirar.');

    dm.IBselect.Close;
    dm.IBQuery1.Close;
  end
  else
  begin
    Result := False;
    Ativado := False;
    demo := False;
  end;
end;

Procedure FileCopy(Const sourcefilename, targetfilename: String);
Var
  s, t: TFileStream;
Begin
  s := TFileStream.Create(sourcefilename, fmOpenRead);
  try
    t := TFileStream.Create(targetfilename, fmOpenWrite or fmCreate);
    try
      t.CopyFrom(s, s.Size);
    finally
      t.Free;
    end;
  finally
    s.Free;
  end;
End;

function Arredonda(valor: currency; decimais: integer): currency;
begin
  if form22.Pgerais.Values['ARREDONDA'] = 'F' then
    Result := funcoes.ArredondaFinanceiro(valor, decimais)
  else if form22.Pgerais.Values['ARREDONDA'] = 'T' then
    Result := funcoes.ArredondaTrunca(valor, decimais);
end;

function WWMessage(flmessage: String; flType: TMsgDlgType;
  flbutton: TMsgDlgButtons; flColor: TColor; flBold, flItalic: boolean;
  WWFormColor: TColor): String;
begin
  with CreateMessageDialog(flmessage, flType, flbutton) do
  begin
    try
      TLabel(FindComponent('Message')).Font.color := flColor;
      color := WWFormColor;
      TLabel(FindComponent('Message')).Font.Name := 'Courier New';
      if flBold then
        TLabel(FindComponent('Message')).Font.Style := [fsbold];
      if flItalic then
        TLabel(FindComponent('Message')).Font.Style := [fsItalic];
      // Width := TLabel(FindComponent('Message')).Width ;
      ShowModal;
    finally
      Free;
    end;
  end;
end;

function Tfuncoes.DesCriptografar(wStri: String): String;
var
  x, posicao: integer;
  sim1: string;
begin
  sim1 := Simbolos[1];
  Result := '';
  for x := 1 to length(wStri) do
  begin
    posicao := pos(wStri[x], Simbolos[2]);
    Result := Result + sim1[posicao];
  end;
end;

function Tfuncoes.Criptografar(wStri: String): String;
var
  x, posicao: integer;
  sim2: string;
begin
  sim2 := Simbolos[2];
  Result := '';
  for x := 1 to length(wStri) do
  begin
    try
      posicao := pos(wStri[x], Simbolos[1]);
      Result := Result + sim2[posicao];
    except
    end;
  end;
end;

function lancaValorMinimo(total: currency; minimo: currency; msg: string)
  : currency;
var
  valor: string;
begin
  valor := '0,00001';
  while StrToCurr(valor) < minimo do
  begin
    valor := funcoes.ConverteNumerico(funcoes.dialogo('numero', 0,
      '1234567890,.' + #8, 0, False, 'ok', 'Control for Windows:',
      'Qual o Percentual de Desconto (%)?:', '0,00%'));
  end;
end;

function retornaPos(valor: string; sub: string; posi: integer): integer;
begin
  valor := copy(valor, posi, length(valor));
  if Contido(sub, valor) = false then Result := pos('-', valor) - 1
  else Result := pos(sub, valor) - 1;
end;

function GravarConfig(valor: string; AserGravado: string;
  posi: integer): string;
var
  p1, p2: string;
  contNum: integer;
begin
  contNum := length(IntToStr(posi));
  p1 := '';
  p2 := '';
  // -4- s s s s s
  // p1 = copia do primeiro caractere até exemplo: 4-
  if pos('-' + IntToStr(posi) + '-', valor) > 0 then
  begin
    p1 := copy(valor, 1, pos('-' + IntToStr(posi) + '-', valor) +
      length(IntToStr(posi)) + 1);

    // valor será do 4- em diante
    valor := copy(valor, pos('-' + IntToStr(posi) + '-', valor) +
      length(IntToStr(posi)) + 2, length(valor));

    // p2 será do "-"  até o final excluindo o valor que continha entre estes valores
    p2 := copy(valor, pos('-', valor), length(valor));
    if (trim(p2) = '') or (not(funcoes.Contido('-', p2))) then
      p2 := '-';

    // por fim gravar o novo valor
    Result := p1 + ' ' + AserGravado + ' ' + p2;
  end
  else
  begin
    // p1 := copy(Trim(valor), length(Trim(valor)) -1, length(Trim(valor)));
    p1 := RightStr(valor, 1);
    if p1 <> '-' then
      p1 := valor + '-'
    else
      p1 := valor;

    AserGravado := IntToStr(posi) + '-' + AserGravado;
    // p2 será do "-"  até o final excluindo o valor que continha entre estes valores
    p2 := '-';
    // por fim gravar o novo valor
    Result := p1 + ' ' + AserGravado + ' ' + p2;
  end;
end;

function Tfuncoes.LerConfig(valor: string; posi: integer): string;
var
  fim : integer;
  temp : String;
begin
  Result := trim(copy(valor, pos(IntToStr(posi) + '-', valor) + 3,
    retornaPos(valor, '-' + IntToStr(posi + 1), pos(IntToStr(posi) + '-',
    valor) + 3)));
  {fim := pos(IntToStr(posi + 1) + '-', valor);
  if fim <= 0 then begin
    temp := copy(valor, pos(IntToStr(posi) + '-', valor) + 3, length(valor));

    fim := PosFinal('-', valor) -2;
  end;


  Result := trim(copy(valor, pos(IntToStr(posi) + '-', valor) + 3, fim));}

  Result := trim(Result);
  // ShowMessage(Result);
end;

function Tfuncoes.RetornaValorConfig(Config: string; posi: integer): variant;
begin
  Result := '';
  /// result := copy(config,pos('-'+IntToStr(posi)+'-',config)+3,RetornaPos(config,'-',pos('-'+IntToStr(posi)+'-',config)+3));
end;

function Tfuncoes.GerarPgeraisList(codUsu: string): tstringList;
var
  arr, temp, tmp: tstringList;
begin
  arr := tstringList.Create;

  dm.IBselect.Close;
  dm.IBselect.SQL.Clear;
  dm.IBselect.SQL.Add('select empresa, versao from registro');
  dm.IBselect.Open;
  arr.Add('empresa=' + trim(UpperCase(dm.IBselect.FieldByName('empresa')
    .AsString)));
  arr.Values['codigo_seq'] := dm.IBselect.FieldByName('versao').AsString;
  dm.IBselect.Close;

  dm.IBselect.SQL.Clear;
  dm.IBselect.SQL.Add('select * from pgerais where cod = 0');
  dm.IBselect.Open;
  arr.Add('ARREDONDA=' + UpperCase(dm.IBselect.FieldByName('valor').AsString));
  dm.IBselect.Close;

  dm.IBselect.SQL.Clear;
  dm.IBselect.SQL.Add('select * from usuario where cod=' + codUsu);
  dm.IBselect.Open;

  arr.Add('acessousu=' + funcoes.DesCriptografar
    (dm.IBselect.FieldByName('acesso').AsString));
  arr.Add('codvendedor=' + dm.IBselect.FieldByName('vendedor').AsString);
  arr.Add('configu=' + dm.IBselect.FieldByName('configu').AsString);

  try
    arr.Add('mens=' + IfThen(dm.IBselect.FieldByName('mens').IsNull or
      (dm.IBselect.FieldByName('mens').AsString = ''),
      '* * *   NAO  TEM  VALOR  FISCAL    * * *',
      dm.IBselect.FieldByName('mens').AsString));
    arr.Add('mensORC=' + funcoes.buscaParamGeral(67, ''));
  except
  end;
  dm.IBselect.Close;

  arr.Add('nota=' + LerConfig(arr.Values['configu'], 1));

  dm.IBselect.SQL.Clear;
  dm.IBselect.SQL.Add('select acesso from acesso');
  dm.IBselect.Open;
  arr.Add('acesso=' + dm.IBselect.FieldByName('acesso').AsString);
  dm.IBselect.Close;

  if FileExists(caminhoEXE_com_barra_no_final + buscaNomeConfigDat) then begin
    temp := tstringList.Create;
    temp.LoadFromFile(caminhoEXE_com_barra_no_final + buscaNomeConfigDat);

    if temp.Values['0'] = '' then begin
      temp.Values['0'] := '-0- T -1- 1 -2- 2 -3- -4- -5- -6- -7- -8- -9- -10- -11- -12- -13- -14- -15- -16- -17- -18- -19- -20-';
      temp.SaveToFile(caminhoEXE_com_barra_no_final + buscaNomeConfigDat);
    end;

    arr.Add('BDRemoto=' + temp.Values['BDRemoto']);
    if ((contido(':', dm.bd.DatabaseName)) and (temp.Values['BDRemoto'] <> dm.bd.DatabaseName))  then begin
      buscaConfigTerminal(0, dm.bd.DatabaseName, 'BDRemoto');
    end;

    arr.Add('conf_ter=' + temp.Values['0']);
  end;

    if arr.Values['nota'] = '' then arr.Values['nota'] := 'T';
    arr.Values['nota'] := LerConfig(arr.Values['conf_ter'], 0);

    temp.Free;
  
  Result := arr;
end;

function Tfuncoes.CompararStringLists(var v1: tstringList;
  var v2: tstringList): boolean;
var
  i: integer;
begin
  Result := False;
  for i := 0 to v1.count - 1 do
  begin
    if v1.Strings[i] = v2.Strings[i] then
      Result := true
    else
    begin
      // ShowMessage(v1.Strings[i]+' <> '+v2.Strings[i]+'false');
      Result := False;
      break;
    end;
  end;
end;

function Tfuncoes.GetTheWindowsDirectory: string;
var
  WinPath: array [0 .. MAX_PATH + 1] of Char;
begin
  GetWindowsDirectory(WinPath, MAX_PATH);
  Result := WinPath;
end;

function Tfuncoes.GeraNota(numNota: string; tipo: string;
  EnviarImpressora: string; opcao: Smallint): boolean;
var
  total, sub, entrada, total_item, desco, recebido, troco, tot_item: currency;
  refOriCodbar, tmp, impref, imprefxx, codigo1: string;
  i, tam, tamDescri, linFIM: integer;
  rece, hora, txt, nome: String;
  controleEntrega: boolean;
  listaprod: TItensProduto;
begin
  controleEntrega := False;
  if tipo = 'DX' then
  begin
    tipo := 'D';
    controleEntrega := true;
  end;

  if ((tipo = 'TE') or (tipo = 'ME')) then
  begin
    opcao := 4; // controle de entrega
  end;

  if (tipo = 'ET') then begin
    opcao := 4; // controle de entrega
    tipo  := 'E';
  end;

  if tipo = 'F' then
  begin
    le_Venda(numNota, desco, tmp, listaprod);
    if tmp = 'xx' then
    begin
      ShowMessage('Nota Não Encontrada!');
      exit;
    end;
    imprimeGrafico('', numNota, tmp, listaprod, desco);
  end;

  If (tipo = 'D') and (controleEntrega = False) then
    tipo := 'T';

  txt := form22.Pgerais.Values['mens'];
  if funcoes.buscaParamGeral(73, 'N') = 'S' then
  begin
    txt := buscaMSG_Venda(numNota);
  end;

  entrada := 0;
  dm.IBselect.Close;
  dm.IBselect.SQL.Clear;
  if opcao = 1 then
  begin
    dm.IBselect.SQL.Add('select * from venda where nota=' + numNota);
    // funcoes.desmarcaVendaPaf(numNota);
  end
  else if opcao = 2 then
  begin
    dm.IBselect.SQL.Add('select * from orcamento where nota=' + numNota);
    txt := form22.Pgerais.Values['mensORC'];
  end
  else if opcao = 3 then
  begin
    dm.IBselect.SQL.Add('select * from compra where nota=' + numNota);
    tipo := 'COM';
  end
  else if opcao = 4 then
  begin
    dm.IBselect.SQL.Add('select * from venda where nota=' + numNota);
  end;

  try
    dm.IBselect.Open;
  except
    on e: exception do
    begin
      ShowMessage('Erro10715: ' + e.Message);
      exit;
    end;
  end;

  if controleEntrega = False then
    form19.RichEdit1.Clear;

  if opcao = 1 then
    entrada := dm.IBselect.FieldByName('entrada').AsCurrency;

  if controleEntrega = False then
  begin
    if funcoes.LerConfig(form22.Pgerais.Values['configu'], 3) = 'S' then
    begin
      txt := funcoes.dialogo('not', 70, '', 200, False, '',
        'Mensagem do Pedido', 'Confirme:', txt);
      if txt = '*' then
        txt := '';
    end;
  end;

  if tipo = 'COM' then
  begin
    hora := funcoes.dialogo('generico', 0, 'SN', 0, False, 'S',
      'Control for Windows:', 'Imprime os Preços das Mercadorias? S/N', 'N');
    if hora = '*' then
      exit;

    linFIM := StrToIntDef(funcoes.LerConfig(form22.Pgerais.Values
      ['conf_ter'], 9), 50);

    tam := 78;
    total := 0;
    // l := 48;

    if ConfParamGerais[5] = 'S' then
    begin
      tamDescri := 44;
      tam := 78;
    end
    else
    begin
      tamDescri := StrToIntDef
        (funcoes.LerConfig(form22.Pgerais.Values['conf_ter'], 8), 35);
      tam := tam - 35;
      tam := tam + tamDescri;
    end;

    dm.IBQuery2.Close;
    dm.IBQuery2.SQL.Clear;
    dm.IBQuery2.SQL.Add('select * from registro');
    dm.IBQuery2.Open;
    form19.RichEdit1.Perform(EM_REPLACESEL, 1,
      Longint(PChar((funcoes.CompletaOuRepete('+', '+', '-', tam) + #13
      + #10))));
    form19.RichEdit1.Perform(EM_REPLACESEL, 1,
      Longint(PChar((funcoes.CompletaOuRepete('| PEDIDO DE COMPRA Nr:' + numNota
      + '     PAGTO: ' + dm.IBselect.FieldByName('codhis').AsString + '-' +
      (funcoes.BuscaNomeBD(dm.IBQuery1, 'nome', 'formpagto',
      'where cod=' + dm.IBselect.FieldByName('codhis').AsString)),
      'EMISSAO: ' + formataDataDDMMYY(dm.IBselect.FieldByName('data')
      .AsDateTime) + ' |', ' ', tam) + #13 + #10))));
    form19.RichEdit1.Perform(EM_REPLACESEL, 1,
      Longint(PChar((funcoes.CompletaOuRepete('+', '+', '-', tam) + #13
      + #10))));
    form19.RichEdit1.Perform(EM_REPLACESEL, 1,
      Longint(PChar((funcoes.CompletaOuRepete('| ' + dm.IBQuery2.FieldByName
      ('nome').AsString, 'CNPJ: ' + dm.IBQuery2.FieldByName('cnpj').AsString +
      ' |', ' ', tam) + #13 + #10))));
    form19.RichEdit1.Perform(EM_REPLACESEL, 1,
      Longint(PChar((funcoes.CompletaOuRepete('| ' + dm.IBQuery2.FieldByName
      ('ende').AsString + '  - ' + dm.IBQuery2.FieldByName('bairro').AsString,
      'CEP: ' + dm.IBQuery2.FieldByName('cep').AsString + '|', ' ', tam) + #13
      + #10))));
    form19.RichEdit1.Perform(EM_REPLACESEL, 1,
      Longint(PChar((funcoes.CompletaOuRepete('| Fone: ' +
      dm.IBQuery2.FieldByName('telres').AsString + '  Cel: ' +
      dm.IBQuery2.FieldByName('telcom').AsString + '  ' +
      dm.IBQuery2.FieldByName('cid').AsString + ' - ' + dm.IBQuery2.FieldByName
      ('est').AsString, 'IE: ' + dm.IBQuery2.FieldByName('ies').AsString + ' |',
      ' ', tam) + #13 + #10))));
    form19.RichEdit1.Perform(EM_REPLACESEL, 1,
      Longint(PChar((funcoes.CompletaOuRepete('| Obs: ' +
      dm.IBQuery2.FieldByName('obs').AsString,
      'SUFRAMA: ' + LeftStr(dm.IBQuery2.FieldByName('suframa').AsString,
      13) + '|', ' ', tam) + #13 + #10))));
    form19.RichEdit1.Perform(EM_REPLACESEL, 1,
      Longint(PChar((funcoes.CompletaOuRepete('+', '+', '-', tam) + #13
      + #10))));

    dm.IBQuery1.Close;
    dm.IBQuery1.SQL.Clear;
    dm.IBQuery1.SQL.Add
      ('select nome, endereco, bairro, estado, cidade, fone, fax, obs, cod from fornecedor where cod ='
      + dm.IBselect.FieldByName('cliente').AsString);
    dm.IBQuery1.Open;

    form19.RichEdit1.Perform(EM_REPLACESEL, 1,
      Longint(PChar((funcoes.CompletaOuRepete('| Fornec: ' +
      funcoes.CompletaOuRepete(LeftStr(dm.IBQuery1.FieldByName('nome').AsString,
      40), '', ' ', 40), 'Fone: ' + dm.IBQuery1.FieldByName('fone').AsString +
      ' |', ' ', tam) + #13 + #10))));

    form19.RichEdit1.Perform(EM_REPLACESEL, 1,
      Longint(PChar((funcoes.CompletaOuRepete('| Endereco: ' +
      dm.IBQuery1.FieldByName('endereco').AsString + '-' +
      dm.IBQuery1.FieldByName('bairro').AsString,
      'Fax: ' + dm.IBQuery1.FieldByName('fax').AsString + ' |', ' ', tam) + #13
      + #10))));
    form19.RichEdit1.Perform(EM_REPLACESEL, 1,
      Longint(PChar((funcoes.CompletaOuRepete('| Cidade: ' +
      funcoes.CompletaOuRepete(dm.IBQuery1.FieldByName('cidade').AsString +
      ' - ' + dm.IBQuery1.FieldByName('estado').AsString, '', ' ', 41),
      'Codigo: ' + dm.IBQuery1.FieldByName('cod').AsString + ' |', ' ',
      tam) + #13 + #10))));
    form19.RichEdit1.Perform(EM_REPLACESEL, 1,
      Longint(PChar((funcoes.CompletaOuRepete('| Obs: ' +
      funcoes.CompletaOuRepete(LeftStr(dm.IBQuery1.FieldByName('obs').AsString,
      40), '', ' ', 41), ' |', ' ', tam) + #13 + #10))));
    form19.RichEdit1.Perform(EM_REPLACESEL, 1,
      Longint(PChar((funcoes.CompletaOuRepete('+', '+', '-', tam) + #13
      + #10))));

    if ConfParamGerais[5] = 'S' then
    begin
      addRelatorioForm19
        ('|  Referencia      |Unid | Qtd.    | Descricao das Mercadorias               |'
        + CRLF);
      addRelatorioForm19('+------------------+-----+---------+' +
        CompletaOuRepete('', '', '-', 41) + '+' + CRLF);
    end
    else
    begin
      form19.RichEdit1.Perform(EM_REPLACESEL, 1,
        Longint(PChar(('|Codigo|Unid|  Qtd.  |' +
        CompletaOuRepete('    Descricao das Mercadorias      ', '', ' ',
        tamDescri) + '|Unitario|  Total   |' + #13 + #10))));
      form19.RichEdit1.Perform(EM_REPLACESEL, 1,
        Longint(PChar(('+------+----+--------+' +
        CompletaOuRepete('-----------------------------------', '', '-',
        tamDescri) + '+--------+----------+' + #13 + #10))));
    end;

    dm.IBQuery1.Close;
    dm.IBQuery1.SQL.Clear;
    dm.IBQuery1.SQL.Add
      ('select i.cod, p.nome, p.unid, p.codbar, p.refori, i.p_compra, i.quant  from item_compra i left join produto p on (p.cod = i.cod) where i.nota = :nota ');
    dm.IBQuery1.ParamByName('nota').AsString := StrNum(numNota);
    dm.IBQuery1.Open;

    sub := 0;
    total := 0;
    while not dm.IBQuery1.Eof do
    begin
      tot_item := Arredonda(dm.IBQuery1.FieldByName('quant').AsCurrency *
        dm.IBQuery1.FieldByName('p_compra').AsCurrency, 2);
      total := total + tot_item;
      sub := sub + dm.IBQuery1.FieldByName('quant').AsCurrency;

      if ConfParamGerais[5] = 'S' then
      begin
        addRelatorioForm19
        // (CompletaOuRepete('|' + dm.IBQuery1.FieldByName('refori').AsString,
          (CompletaOuRepete('|' + dm.IBQuery1.FieldByName('codbar').AsString,
          '|', ' ', 20) + CompletaOuRepete(dm.IBQuery1.FieldByName('unid')
          .AsString, '|', ' ', 6) + CompletaOuRepete('', FormatCurr('0.00',
          dm.IBQuery1.FieldByName('quant').AsCurrency) + '|', ' ', 10) +
          CompletaOuRepete(LeftStr(dm.IBQuery1.FieldByName('nome').AsString,
          41), '|', ' ', 42) + CRLF);
      end
      else
      begin
        addRelatorioForm19('|' + funcoes.CompletaOuRepete('',
          dm.IBQuery1.FieldByName('cod').AsString + '|', ' ', 7) +
          funcoes.CompletaOuRepete('', LeftStr(dm.IBQuery1.FieldByName('unid')
          .AsString, 5) + '|', ' ', 5) + funcoes.CompletaOuRepete('',
          FormatCurr('0.00', dm.IBQuery1.FieldByName('quant').AsCurrency) + '|',
          ' ', 9) + funcoes.CompletaOuRepete
          (copy(dm.IBQuery1.FieldByName('nome').AsString, 1, tamDescri), '|',
          ' ', tamDescri + 1) + IfThen(hora = 'S', funcoes.CompletaOuRepete('',
          FormatCurr('0.00', dm.IBQuery1.FieldByName('p_compra').AsCurrency) +
          '|', ' ', 9), funcoes.CompletaOuRepete('', '|', '_', 9)) +
          IfThen(hora = 'S', funcoes.CompletaOuRepete('', FormatCurr('0.00',
          tot_item) + '|', ' ', 11), funcoes.CompletaOuRepete('', '|', '_',
          11)) + CRLF);
      end;

      dm.IBQuery1.Next;
    end;
    dm.IBQuery1.Close;
    dm.IBQuery2.Close;
    dm.IBselect.Close;

    if form19.RichEdit1.Lines.count < 50 then
    begin
      for i := form19.RichEdit1.Lines.count to linFIM do
      begin
        if ConfParamGerais[5] = 'S' then
        begin
          addRelatorioForm19(CompletaOuRepete('|', '|', ' ', 20) +
            CompletaOuRepete('', '|', ' ', 6) + CompletaOuRepete('', '|', ' ',
            10) + CompletaOuRepete('', '|', ' ', 42) + CRLF);
        end
        else
        begin
          form19.RichEdit1.Perform(EM_REPLACESEL, 1,
            Longint(PChar(('|' + funcoes.CompletaOuRepete('', '|', ' ',
            7) + funcoes.CompletaOuRepete('', '|', ' ',
            5) + funcoes.CompletaOuRepete('', '|', ' ',
            9) + funcoes.CompletaOuRepete('', '|', ' ', tamDescri + 1) +
            funcoes.CompletaOuRepete('', '|', ' ', 9) + funcoes.CompletaOuRepete
            ('', '|', ' ', 11) + #13 + #10))));
        end;
      end;
    end;

    form19.RichEdit1.Perform(EM_REPLACESEL, 1,
      Longint(PChar((funcoes.CompletaOuRepete('+', '+', '-', tam) + #13
      + #10))));
    if hora = 'S' then
    begin
      addRelatorioForm19(funcoes.CompletaOuRepete('| Total: ',
        FormatCurr('#,###,###0.00', total) + '|', ' ', tam) + #13 + #10);
    end
    else
    begin
      addRelatorioForm19(funcoes.CompletaOuRepete('| Contabil: ' +
        StrNum(FormatCurr('0.00', total)), '|', ' ', tam) + #13 + #10);
    end;
    form19.RichEdit1.Perform(EM_REPLACESEL, 1,
      Longint(PChar((funcoes.CompletaOuRepete('+', '+', '-', tam) + #13
      + #10))));

    try
      if FileExists('C:\TEXTO.txt') then
        DeleteFile('C:\TEXTO.txt');
      form19.RichEdit1.Lines.SaveToFile('C:\TEXTO.txt');
    except
    end;

    txt := funcoes.dialogo('generico', 0, 'SN' + #8, 0, true, 'S',
      'Control For Windows', 'Imprimir Esta Compra ?S/N:', 'N');
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

  if tipo = 'D' then
  begin

    if funcoes.LerConfig(form22.Pgerais.Values['conf_ter'], 3) <> '' then
    begin
      imprime.negrito :=
        iif(funcoes.LerConfig(form22.Pgerais.Values['conf_ter'], 4) = 'S',
        true, False);
      imprime.fontDif := true;
      imprime.tamaFonte :=
        StrToIntDef(funcoes.LerConfig(form22.Pgerais.Values
        ['conf_ter'], 3), 11);
      addRelatorioForm19(' ' + #13 + #10);
    end;

    if form22.Pgerais.Values['nota'] <> 'T' then
      tam := 78
    else
      tam := 40;

    if form22.Pgerais.Values['nota'] = 'E' then
    begin
      tam := 30;
      addRelatorioForm19(funcoes.CompletaOuRepete('', '', '-', tam) + CRLF);
      addRelatorioForm19(funcoes.CompletaOuRepete('NOTA: ' + numNota,
        FormatDateTime('DD/MM/YY', dm.IBselect.FieldByName('data').AsDateTime),
        ' ', tam) + CRLF);
      addRelatorioForm19('PAGTO: ' + dm.IBselect.FieldByName('codhis').AsString
        + '-' + (funcoes.BuscaNomeBD(dm.IBQuery1, 'nome', 'formpagto',
        'where cod=' + dm.IBselect.FieldByName('codhis').AsString)) + CRLF);
      addRelatorioForm19('VALOR:' + funcoes.CompletaOuRepete('',
        FormatCurr('0.00', dm.IBselect.FieldByName('total').AsCurrency), ' ',
        11) + CRLF);
      addRelatorioForm19(funcoes.CompletaOuRepete('', '', '-', tam) + CRLF);
      exit;
    end;

    addRelatorioForm19(funcoes.CompletaOuRepete('+', '+', '-', tam) +
      #13 + #10);
    addRelatorioForm19(funcoes.CompletaOuRepete('|NOTA: ' + numNota,
      '  VENDEDOR: ' + dm.IBselect.FieldByName('vendedor').AsString + '-' +
      copy(BuscaNomeBD(dm.IBQuery1, 'nome', 'vendedor',
      'where cod=' + dm.IBselect.FieldByName('vendedor').AsString), 1, 10) +
      '|', ' ', tam) + #13 + #10);
    addRelatorioForm19(funcoes.CompletaOuRepete('+', '+', '-', tam) +
      #13 + #10);

    addRelatorioForm19(CompletaOuRepete('|FORMA PAGTO: ' +
      dm.IBselect.FieldByName('codhis').AsString + '-' +
      (BuscaNomeBD(dm.IBQuery1, 'nome', 'formpagto',
      'where cod=' + dm.IBselect.FieldByName('codhis').AsString)), '|', ' ',
      tam) + #13 + #10);

    addRelatorioForm19(CompletaOuRepete('|DATA: ' + FormatDateTime('DD/MM/YY',
      dm.IBselect.FieldByName('data').AsDateTime),
      'VALOR:' + CompletaOuRepete('', FormatCurr('#,###,###0.00',
      dm.IBselect.FieldByName('total').AsCurrency), ' ', 11) + '|', ' ', tam) +
      #13 + #10);
    addRelatorioForm19(funcoes.CompletaOuRepete('+', '+', '-', tam) +
      #13 + #10);

    if controleEntrega then
      exit;

    if EnviarImpressora = 'S' then
    begin
      imprime.textx('');
    end
    else
      form19.ShowModal;

  end;

  if tipo = 'L' then
  begin
    tam := 78;
    total := 0;
    dm.IBQuery2.Close;
    dm.IBQuery2.SQL.Clear;
    dm.IBQuery2.SQL.Add('select * from registro');
    dm.IBQuery2.Open;

    form19.RichEdit1.Perform(EM_REPLACESEL, 1,
      Longint(PChar((funcoes.CompletaOuRepete('', '', '-', tam) + CRLF))));
    addRelatorioForm19
      ('*  *    *    *    *   S E M    V A L O R    F I S C A L   *    *    *     *  *'
      + CRLF);

    refOriCodbar := ' refori ';
    // impref := funcoes.buscaParamGeral(54, 'N');
    impref := funcoes.LerConfig(form22.Pgerais.Values['configu'], 10);

    try
      if ConfParamGerais[49] = 'S' then
        refOriCodbar := ' codbar as refori ';
    except
    end;

    form19.RichEdit1.Perform(EM_REPLACESEL, 1,
      Longint(PChar((funcoes.CompletaOuRepete('+', '+', '-', tam) + #13
      + #10))));

    if opcao = 1 then
      form19.RichEdit1.Perform(EM_REPLACESEL, 1,
        Longint(PChar((funcoes.CompletaOuRepete('| PEDIDO Nr:' +
        dm.IBselect.FieldByName('nota').AsString + '     PAGTO: ' +
        dm.IBselect.FieldByName('codhis').AsString + '-' +
        (BuscaNomeBD(dm.IBQuery1, 'nome', 'formpagto',
        'where cod=' + dm.IBselect.FieldByName('codhis').AsString)),
        'EMISSAO: ' + dm.IBselect.FieldByName('data').AsString + ' |', ' ',
        tam) + #13 + #10))))
    else if opcao = 2 then
      form19.RichEdit1.Perform(EM_REPLACESEL, 1,
        Longint(PChar((funcoes.CompletaOuRepete('| ORCAMENTO Nr:' +
        dm.IBselect.FieldByName('nota').AsString + '     PAGTO: ' +
        dm.IBselect.FieldByName('codhis').AsString + '-' +
        (BuscaNomeBD(dm.IBQuery1, 'nome', 'formpagto',
        'where cod=' + dm.IBselect.FieldByName('codhis').AsString)),
        'EMISSAO: ' + dm.IBselect.FieldByName('data').AsString + ' |', ' ',
        tam) + #13 + #10))))
    else
      form19.RichEdit1.Perform(EM_REPLACESEL, 1,
        Longint(PChar((funcoes.CompletaOuRepete('| COMPRA Nr:' +
        dm.IBselect.FieldByName('nota').AsString + '     PAGTO: ' +
        dm.IBselect.FieldByName('codhis').AsString + '-' +
        (BuscaNomeBD(dm.IBQuery1, 'nome', 'formpagto',
        'where cod=' + dm.IBselect.FieldByName('codhis').AsString)),
        'EMISSAO: ' + dm.IBselect.FieldByName('data').AsString + ' |', ' ',
        tam) + #13 + #10))));

    form19.RichEdit1.Perform(EM_REPLACESEL, 1,
      Longint(PChar((funcoes.CompletaOuRepete('+', '+', '-', tam) + #13
      + #10))));
    form19.RichEdit1.Perform(EM_REPLACESEL, 1,
      Longint(PChar((funcoes.CompletaOuRepete('| ' + form22.Pgerais.Values
      ['empresa'], 'CNPJ: ' + dm.IBQuery2.FieldByName('cnpj').AsString + ' |',
      ' ', tam) + #13 + #10))));
    form19.RichEdit1.Perform(EM_REPLACESEL, 1,
      Longint(PChar((funcoes.CompletaOuRepete('| ' + dm.IBQuery2.FieldByName
      ('ende').AsString + '  - ' + dm.IBQuery2.FieldByName('bairro').AsString,
      '|', ' ', tam) + #13 + #10))));
    form19.RichEdit1.Perform(EM_REPLACESEL, 1,
      Longint(PChar((funcoes.CompletaOuRepete('| Fone: ' +
      dm.IBQuery2.FieldByName('telres').AsString + '  Cel: ' +
      dm.IBQuery2.FieldByName('telcom').AsString + '  ' +
      dm.IBQuery2.FieldByName('cid').AsString + ' - ' + dm.IBQuery2.FieldByName
      ('est').AsString, 'IE: ' + dm.IBQuery2.FieldByName('ies').AsString + ' |',
      ' ', tam) + #13 + #10))));
    form19.RichEdit1.Perform(EM_REPLACESEL, 1,
      Longint(PChar((funcoes.CompletaOuRepete('| Obs: ' +
      dm.IBQuery2.FieldByName('obs').AsString, '|', ' ', tam) + #13 + #10))));
    form19.RichEdit1.Perform(EM_REPLACESEL, 1,
      Longint(PChar((funcoes.CompletaOuRepete('+', '+', '-', tam) + #13
      + #10))));
    addRelatorioForm19(funcoes.CompletaOuRepete(funcoes.CompletaOuRepete
      (copy('| Nome: ' + funcoes.BuscaNomeBD(dm.IBQuery1, 'nome', 'cliente',
      'where cod=' + dm.IBselect.FieldByName('cliente').AsString), 1, 38), '',
      ' ', 39) + funcoes.CompletaOuRepete('|CPF/CNPJ: ' +
      funcoes.BuscaNomeBD(dm.IBQuery1, 'cnpj', 'cliente',
      'where cod=' + dm.IBselect.FieldByName('cliente').AsString), '', ' ', 37),
      '|', ' ', tam) + #13 + #10);

    if ConfParamGerais.Strings[27] = 'S' then
    begin
      dm.ibquery4.Close;
      dm.ibquery4.SQL.Clear;
      dm.ibquery4.SQL.Add
        ('select cod, nome, ende, bairro, cid, obs, iif(tipo = 1, cpf, cnpj) as cpf, cnpj, tipo, ies, tel,telres,telcom from cliente where cod = :cod');
      dm.ibquery4.ParamByName('cod').AsString :=
        dm.IBselect.FieldByName('cliente').AsString;
      dm.ibquery4.Open;

      addRelatorioForm19(funcoes.CompletaOuRepete
        (funcoes.CompletaOuRepete(copy('| Endereco: ' + dm.ibquery4.FieldByName
        ('ende').AsString, 1, 38), '', ' ', 39) + funcoes.CompletaOuRepete
        ('|INSC. EST.: ' + dm.ibquery4.FieldByName('ies').AsString, '', ' ',
        37), '|', ' ', tam) + #13 + #10);
      addRelatorioForm19(funcoes.CompletaOuRepete
        (funcoes.CompletaOuRepete(copy('| Bairro: ' + dm.ibquery4.FieldByName
        ('bairro').AsString + ' - ' + dm.ibquery4.FieldByName('cid').AsString,
        1, 38), '', ' ', 39) + funcoes.CompletaOuRepete('|Codigo: ' +
        dm.ibquery4.FieldByName('cod').AsString, '', ' ', 37), '|', ' ', tam) +
        #13 + #10);
      addRelatorioForm19(funcoes.CompletaOuRepete
        (funcoes.CompletaOuRepete(copy('| Obs: ' + dm.ibquery4.FieldByName
        ('obs').AsString, 1, 38), '', ' ', 39) + funcoes.CompletaOuRepete
        ('|Fone: ' + dm.ibquery4.FieldByName('telres').AsString, '', ' ', 37),
        '|', ' ', tam) + #13 + #10);
      dm.ibquery4.Close;
    end;

    form19.RichEdit1.Perform(EM_REPLACESEL, 1,
      Longint(PChar((funcoes.CompletaOuRepete('+', '+', '-', tam) + #13
      + #10))));
    // form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar(('|Codigo| Unid |  Qtd.   |  Descricao das Mercadorias     |Unitario|   Total  |'+#13+#10))));
    // form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar(('+------+------+---------+--------------------------------+--------+----------+'+#13+#10))));
    // form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar(('|Cod. |  Qtd   |  Descricao das Mercadorias   |  Unit. |  Total  | Localiza  |'+#13+#10))));
    // form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar(('+-----+--------+------------------------------+--------+---------+-----------+'+#13+#10))));

    { addRelatorioForm19('%'+
      '|Codigo| Unid. | Qtd.   |  Descricao das Mercadorias            | Unitario |   Total   | Referencia      | Localizacao     |' + CRLF);
      addRelatorioForm19('+------+-------+--------+---------------------------------------+----------+-----------+-----------------+-----------------+' + CRLF); }

    addRelatorioForm19
      ('%' + '| Codigo | Unid. | Qtd.     |  Descricao das Mercadorias              | Unitario|   Total  | Referencia      | Localizacao     |'
      + CRLF);
    addRelatorioForm19
      ('+--------+-------+----------+-----------------------------------------+---------+----------+-----------------+-----------------+'
      + CRLF);

    dm.IBQuery2.Close;
    dm.IBQuery2.SQL.Clear;

    if opcao = 1 then
      dm.IBQuery2.SQL.Add
        ('select cod,p_venda, total, quant from item_venda where nota='
        + numNota)
    else if opcao = 2 then
      dm.IBQuery2.SQL.Add('select * from item_orcamento where nota=' + numNota)
    else if opcao = 3 then
      dm.IBQuery2.SQL.Add('select * from item_compra where nota=' + numNota)
    else if opcao = 4 then
    begin
      dm.IBQuery2.SQL.Add
        ('select e.cod, e.quant, i.p_venda, i.total from CONT_ENTREGA e left join '
        + 'item_venda i on (i.nota = e.nota and i.cod = e.cod) where e.ENT_AGORA = ''X'' and e.nota ='
        + numNota);
    end;

    dm.IBQuery2.Open;
    dm.IBQuery2.First;
    sub := 0;
    total := 0;
    while not dm.IBQuery2.Eof do
    begin
      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add
        ('select unid, P_VENDA, P_COMPRA,  codbar, nome, localiza, ' +
        refOriCodbar + ' from produto where cod=' + dm.IBQuery2.FieldByName
        ('cod').AsString);
      dm.IBQuery1.Open;

      sub := sub + dm.IBQuery2.FieldByName('quant').AsCurrency;

      if opcao = 1 then
      begin
        addRelatorioForm19('|' + funcoes.CompletaOuRepete('',
          dm.IBQuery2.FieldByName('cod').AsString + '|', ' ', 9) +
          funcoes.CompletaOuRepete('', dm.IBQuery1.FieldByName('unid').AsString
          + '|', ' ', 8) + funcoes.CompletaOuRepete('', FormatCurr('0.00',
          dm.IBQuery2.FieldByName('quant').AsCurrency) + '|', ' ', 11) +
          funcoes.CompletaOuRepete(copy(dm.IBQuery1.FieldByName('nome')
          .AsString, 1, 40), '|', ' ', 42) + funcoes.CompletaOuRepete('',
          FormatCurr('0.00', dm.IBQuery2.FieldByName('P_VENDA').AsCurrency) +
          '|', ' ', 10) + funcoes.CompletaOuRepete('', FormatCurr('0.00',
          dm.IBQuery2.FieldByName('total').AsCurrency) + '|', ' ', 11) +
          funcoes.CompletaOuRepete(copy(dm.IBQuery1.FieldByName('refori')
          .AsString, 1, 18), '|', ' ', 18) + funcoes.CompletaOuRepete
          (copy(dm.IBQuery1.FieldByName('localiza').AsString, 1, 18), '|', ' ',
          18) + #13 + #10);

        { addRelatorioForm19('|'+funcoes.CompletaOuRepete('', dm.IBQuery2.fieldbyname('cod').AsString+'|',' ',6) +
          funcoes.CompletaOuRepete('',dm.IBQuery2.fieldbyname('quant').AsString + '|',' ',9) +
          funcoes.CompletaOuRepete(copy(dm.ibquery1.fieldbyname('nome').AsString,1,30),'|',' ',31) +
          funcoes.CompletaOuRepete('',dm.ibquery2.fieldbyname('p_venda').AsString+'|',' ',9) +
          funcoes.CompletaOuRepete('',dm.IBQuery2.fieldbyname('total').AsString+'|',' ',10)+
          funcoes.CompletaOuRepete(copy(dm.ibquery1.fieldbyname('localiza').AsString, 1, 12),'|',' ',12)+#13+#10); }
        // form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar(('|'+funcoes.CompletaOuRepete('',dm.IBQuery2.fieldbyname('cod').AsString+'|',' ',7)+funcoes.CompletaOuRepete('',dm.ibquery1.fieldbyname('unid').AsString+'|',' ',7)+funcoes.CompletaOuRepete('',FormatCurr('#,###,###0.00',dm.IBQuery2.fieldbyname('quant').AsCurrency)+'|',' ',10)+funcoes.CompletaOuRepete(copy(dm.ibquery1.fieldbyname('nome').AsString,1,32),'|',' ',33)
        // +funcoes.CompletaOuRepete('',FormatCurr('#,###,###0.00',dm.ibquery2.fieldbyname('p_venda').AsCurrency)+'|',' ',9)+funcoes.CompletaOuRepete('',FormatCurr('#,###,###0.00',dm.IBQuery2.fieldbyname('total').AsCurrency)+'|',' ',11)+#13+#10))));
        total := total + dm.IBQuery2.FieldByName('total').AsCurrency;
      end
      else if opcao = 2 then
      begin
        if impref = 'S' then
        begin
          imprefxx := copy(dm.IBQuery1.FieldByName('refori').AsString, 1, 17);
        end
        else
          imprefxx := '';

        addRelatorioForm19('|' + funcoes.CompletaOuRepete('',
          dm.IBQuery2.FieldByName('cod').AsString + '|', ' ', 9) +
          funcoes.CompletaOuRepete('', dm.IBQuery1.FieldByName('unid').AsString
          + '|', ' ', 8) + funcoes.CompletaOuRepete('',
          formataCurrency(dm.IBQuery2.FieldByName('quant').AsCurrency) + '|',
          ' ', 9) + funcoes.CompletaOuRepete
          (copy(dm.IBQuery1.FieldByName('nome').AsString, 1, 40), '|', ' ', 42)
          + funcoes.CompletaOuRepete('',
          formataCurrency(dm.IBQuery2.FieldByName('P_VENDA').AsCurrency) + '|',
          ' ', 11) + funcoes.CompletaOuRepete('',
          formataCurrency(dm.IBQuery2.FieldByName('total').AsCurrency) + '|',
          ' ', 12) + funcoes.CompletaOuRepete(imprefxx, '|', ' ', 18) +
          funcoes.CompletaOuRepete(copy(dm.IBQuery1.FieldByName('localiza')
          .AsString, 1, 18), '|', ' ', 18) + #13 + #10);

        total := total + dm.IBQuery2.FieldByName('total').AsCurrency;
        { form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar(('|'+funcoes.CompletaOuRepete('', dm.IBQuery2.fieldbyname('cod').AsString+'|',' ',7)+funcoes.CompletaOuRepete('', dm.ibquery1.fieldbyname('unid').AsString+'|',' ',7)+funcoes.CompletaOuRepete('',FormatCurr('#,###,###0.000',dm.IBQuery2.fieldbyname('quant').AsCurrency)+'|',' ',8)+funcoes.CompletaOuRepete(copy(dm.ibquery1.fieldbyname('nome').AsString,1,34),'|',' ',35)+funcoes.CompletaOuRepete('',FormatCurr('#,###,###0.00',dm.ibquery2.fieldbyname('p_venda').AsCurrency)+'|',' ',9)+funcoes.CompletaOuRepete('',FormatCurr('#,###,###0.00', dm.IBQuery2.fieldbyname('total').AsCurrency)+'|',' ',11)+#13+#10))));
          total := total + dm.IBQuery2.fieldbyname('total').AsCurrency; }
      end
      else
      begin
        form19.RichEdit1.Perform(EM_REPLACESEL, 1,
          Longint(PChar(('|' + funcoes.CompletaOuRepete('',
          dm.IBQuery2.FieldByName('cod').AsString + '|', ' ',
          7) + funcoes.CompletaOuRepete('', dm.IBQuery1.FieldByName('unid')
          .AsString + '|', ' ', 7) + funcoes.CompletaOuRepete('',
          FormatCurr('#,###,###0.000', dm.IBQuery2.FieldByName('quant')
          .AsCurrency) + '|', ' ', 8) + funcoes.CompletaOuRepete
          (copy(dm.IBQuery1.FieldByName('nome').AsString, 1, 34), '|', ' ',
          35) + funcoes.CompletaOuRepete('', FormatCurr('#,###,###0.00',
          dm.IBQuery1.FieldByName('p_COMPRA').AsCurrency) + '|', ' ',
          9) + funcoes.CompletaOuRepete('', FormatCurr('#,###,###0.00',
          Arredonda(dm.IBQuery1.FieldByName('p_COMPRA').AsCurrency *
          dm.IBQuery2.FieldByName('quant').AsCurrency, 2)) + '|', ' ', 11) + #13
          + #10))));
        total := total + Arredonda(dm.IBQuery1.FieldByName('p_compra')
          .AsCurrency * dm.IBQuery2.FieldByName('quant').AsCurrency, 2);
      end;
      dm.IBQuery2.Next;
    end;
    dm.IBQuery1.Close;
    if funcoes.ExisteParcelamento(numNota) and (opcao = 1) and
      (ConfParamGerais.Strings[20] = 'S') then
    begin
      form19.RichEdit1.Perform(EM_REPLACESEL, 1,
        Longint(PChar
        (('|      |      |         |                                |        |          |'
        + CRLF))));
      funcoes.ImprimeParcelamento('|      |      |         |  ',
        '    |        |          |', FormatCurr('#,###,###0.00',
        entrada), numNota);
    end;

    addRelatorioForm19('&');
    if opcao = 1 then
    begin
      form19.RichEdit1.Perform(EM_REPLACESEL, 1,
        Longint(PChar((funcoes.CompletaOuRepete('|', '|', '-', tam) + #13
        + #10))));
      form19.RichEdit1.Perform(EM_REPLACESEL, 1,
        Longint(PChar((funcoes.CompletaOuRepete('|' +
        centraliza('* * * * *   R E I M P R E S S A O   * * * * *  USUARIO: ' +
        form22.codusario + '-' + funcoes.BuscaNomeBD(dm.ibquery3, 'nome',
        'usuario', ' where cod = ' + form22.codusario), ' ', tam - 3), '|', ' ',
        tam) + #13 + #10))));
    end;

    form19.RichEdit1.Perform(EM_REPLACESEL, 1,
      Longint(PChar((funcoes.CompletaOuRepete('+', '+', '-', tam) + #13
      + #10))));
    form19.RichEdit1.Perform(EM_REPLACESEL, 1,
      Longint(PChar((funcoes.CompletaOuRepete('|',
      funcoes.CompletaOuRepete('Sub-Total:', FormatCurr('#,###,###0.00', total),
      '.', 28) + ' |', ' ', tam) + #13 + #10))));
    desco := dm.IBselect.FieldByName('desconto').AsCurrency;
    if desco > 0 then
      desco := 0;
    form19.RichEdit1.Perform(EM_REPLACESEL, 1,
      Longint(PChar((funcoes.CompletaOuRepete('|',
      funcoes.CompletaOuRepete('Desconto(' + FormatCurr('#,###,###0.00',
      (desco * 100) / total) + '%):', FormatCurr('#,###,###0.00', desco), '.',
      28) + ' |', ' ', tam) + #13 + #10))));

    if opcao = 1 then
    begin
      form19.RichEdit1.Perform(EM_REPLACESEL, 1,
        Longint(PChar((funcoes.CompletaOuRepete('| Volumes: ' +
        funcoes.CompletaOuRepete('', FormatCurr('#,###,###0.00', sub), ' ', 9),
        funcoes.CompletaOuRepete('Total:', FormatCurr('#,###,###0.00',
        dm.IBselect.FieldByName('total').AsCurrency), '.', 28) + ' |', ' ',
        tam) + #13 + #10))));
      if (funcoes.LerConfig(form22.Pgerais.Values['configu'], 3) = 'S') and
        (txt <> '') then
      begin
        form19.RichEdit1.Perform(EM_REPLACESEL, 1,
          Longint(PChar((funcoes.CompletaOuRepete('+', '+', '-', tam) + #13
          + #10))));
        form19.RichEdit1.Perform(EM_REPLACESEL, 1,
          Longint(PChar((funcoes.CompletaOuRepete('|OBS: ' + txt, '|', ' ',
          tam) + #13 + #10))));
        try
          funcoes.atualizaMensagemUsuario(txt, numNota);
        except
        end;
      end;
      { else
        begin
        form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('+','+','-',80)+#13+#10))));
        form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('|' + txt,'|',' ',80)+#13+#10))));
        end;
      } end
    else if opcao = 2 then
      form19.RichEdit1.Perform(EM_REPLACESEL, 1,
        Longint(PChar((funcoes.CompletaOuRepete('| Volumes: ' +
        funcoes.CompletaOuRepete('', FormatCurr('#,###,###0.00', sub), ' ', 9),
        funcoes.CompletaOuRepete('Total:', FormatCurr('#,###,###0.00', total),
        '.', 28) + ' |', ' ', tam) + #13 + #10))))
    else
      form19.RichEdit1.Perform(EM_REPLACESEL, 1,
        Longint(PChar((funcoes.CompletaOuRepete('| Volumes: ' +
        funcoes.CompletaOuRepete('', FormatCurr('#,###,###0.00', sub), ' ', 9),
        funcoes.CompletaOuRepete('Total:', FormatCurr('#,###,###0.00', total),
        '.', 28) + ' |', ' ', tam) + #13 + #10))));

    form19.RichEdit1.Perform(EM_REPLACESEL, 1,
      Longint(PChar((funcoes.CompletaOuRepete('+', '+', '-', tam) + #13
      + #10))));
    form19.RichEdit1.Perform(EM_REPLACESEL, 1,
      Longint(PChar(('| Vendedor: ' + funcoes.CompletaOuRepete
      (copy(dm.IBselect.FieldByName('vendedor').AsString + '-' +
      BuscaNomeBD(dm.IBQuery1, 'nome', 'vendedor',
      'where cod=' + dm.IBselect.FieldByName('vendedor').AsString), 1, 16), '|',
      ' ', 17) + CompletaOuRepete('Recebido Por: ', '|', ' ', 49) + #13
      + #10))));
    form19.RichEdit1.Perform(EM_REPLACESEL, 1,
      Longint(PChar(('| Vencimento: ' + CompletaOuRepete(FormatDateTime
      ('DD/MM/YY', dm.IBselect.FieldByName('data').AsDateTime), '|', ' ',
      15) + CompletaOuRepete('', '|', ' ', 49) + #13 + #10))));
    form19.RichEdit1.Perform(EM_REPLACESEL, 1,
      Longint(PChar((funcoes.CompletaOuRepete('+', '+', '-', tam) + #13
      + #10))));

    if EnviarImpressora = 'S' then
    begin
      imprime.textx('texto.txt');
    end
    else
      form19.ShowModal;

    { total := 0;
      dm.IBQuery2.Close;
      dm.IBQuery2.SQL.Clear;
      dm.IBQuery2.SQL.Add('select * from registro');
      dm.IBQuery2.Open;

      form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('+','+','-',80)+#13+#10))));
      form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('| PEDIDO Nr:'+dm.IBselect.fieldbyname('nota').AsString+'     PAGTO: '+dm.IBselect.fieldbyname('codhis').AsString+'-'+(BuscaNomeBD(dm.ibquery1,'nome','formpagto','where cod='+dm.IBselect.fieldbyname('codhis').AsString)),'EMISSAO: '+dm.IBselect.fieldbyname('data').AsString+' |',' ',80)+#13+#10))));
      form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('+','+','-',80)+#13+#10))));
      form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('| '+form22.Pgerais.Values['empresa'],'CNPJ: '+dm.IBQuery2.fieldbyname('cnpj').AsString+' |',' ',80)+#13+#10))));
      form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('| '+dm.IBQuery2.fieldbyname('ende').AsString+'  - '+dm.IBQuery2.fieldbyname('bairro').AsString,'|',' ',80)+#13+#10))));
      form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('| Fone: '+dm.IBQuery2.fieldbyname('telres').AsString+'       '+dm.IBQuery2.fieldbyname('telcom').AsString+ '  '+ dm.IBQuery2.fieldbyname('cid').AsString+' - '+dm.IBQuery2.fieldbyname('est').AsString,'IE: '+dm.IBQuery2.fieldbyname('ies').AsString+' |',' ',80)+#13+#10))));
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
      else form19.ShowModal; }
  end;

  if tipo = 'A' then
  begin
    total := 0;
    dm.IBQuery2.Close;
    dm.IBQuery2.SQL.Clear;
    dm.IBQuery2.SQL.Add('select * from registro');
    dm.IBQuery2.Open;

    form19.RichEdit1.Perform(EM_REPLACESEL, 1,
      Longint(PChar((funcoes.CompletaOuRepete('+', '+', '-', 80) + #13
      + #10))));
    form19.RichEdit1.Perform(EM_REPLACESEL, 1,
      Longint(PChar((funcoes.CompletaOuRepete('| PEDIDO Nr:' +
      dm.IBselect.FieldByName('nota').AsString + '     PAGTO: ' +
      dm.IBselect.FieldByName('codhis').AsString + '-' +
      (BuscaNomeBD(dm.IBQuery1, 'nome', 'formpagto',
      'where cod=' + dm.IBselect.FieldByName('codhis').AsString)),
      'EMISSAO: ' + dm.IBselect.FieldByName('data').AsString + ' |', ' ',
      80) + #13 + #10))));
    form19.RichEdit1.Perform(EM_REPLACESEL, 1,
      Longint(PChar((funcoes.CompletaOuRepete('+', '+', '-', 80) + #13
      + #10))));
    form19.RichEdit1.Perform(EM_REPLACESEL, 1,
      Longint(PChar((funcoes.CompletaOuRepete('| ' + form22.Pgerais.Values
      ['empresa'], 'CNPJ: ' + dm.IBQuery2.FieldByName('cnpj').AsString + ' |',
      ' ', 80) + #13 + #10))));
    form19.RichEdit1.Perform(EM_REPLACESEL, 1,
      Longint(PChar((funcoes.CompletaOuRepete('| ' + dm.IBQuery2.FieldByName
      ('ende').AsString + '  - ' + dm.IBQuery2.FieldByName('bairro').AsString,
      '|', ' ', 80) + #13 + #10))));
    form19.RichEdit1.Perform(EM_REPLACESEL, 1,
      Longint(PChar((funcoes.CompletaOuRepete('| Fone: ' +
      dm.IBQuery2.FieldByName('telres').AsString + '  Cel: ' +
      dm.IBQuery2.FieldByName('telcom').AsString + '  ' +
      dm.IBQuery2.FieldByName('cid').AsString + ' - ' + dm.IBQuery2.FieldByName
      ('est').AsString, 'IE: ' + dm.IBQuery2.FieldByName('ies').AsString + ' |',
      ' ', 80) + #13 + #10))));
    form19.RichEdit1.Perform(EM_REPLACESEL, 1,
      Longint(PChar((funcoes.CompletaOuRepete('| Obs: ' +
      dm.IBQuery2.FieldByName('obs').AsString, '|', ' ', 80) + #13 + #10))));
    form19.RichEdit1.Perform(EM_REPLACESEL, 1,
      Longint(PChar((funcoes.CompletaOuRepete('+', '+', '-', 80) + #13
      + #10))));
    // form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete(,'|',' ',35) ,'CPF/CNPJ: ' +  + #13 + #10))));
    // form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('| Nome: '+funcoes.CompletaOuRepete(funcoes.BuscaNomeBD(dm.ibquery1,'nome','cliente','where cod='+dm.IBselect.fieldbyname('cliente').AsString),'|',' ',41),'CPF/CNPJ: '+funcoes.BuscaNomeBD(dm.ibquery1,'cnpj','cliente','where cod='+dm.IBselect.fieldbyname('cliente').AsString)+' |',' ',80)+#13+#10))));
    addRelatorioForm19(funcoes.CompletaOuRepete(funcoes.CompletaOuRepete
      (copy('| Cliente: ' + dm.IBselect.FieldByName('cliente').AsString + '-' +
      funcoes.BuscaNomeBD(dm.IBQuery1, 'nome', 'cliente',
      'where cod=' + dm.IBselect.FieldByName('cliente').AsString), 1, 40), '',
      ' ', 41) + funcoes.CompletaOuRepete('|CPF/CNPJ: ' +
      funcoes.BuscaNomeBD(dm.IBQuery1, 'cnpj', 'cliente',
      'where cod=' + dm.IBselect.FieldByName('cliente').AsString), '', ' ', 37),
      '|', ' ', 80) + #13 + #10);

    if ConfParamGerais.Strings[27] = 'S' then
    begin
      dm.ibquery4.Close;
      dm.ibquery4.SQL.Clear;
      dm.ibquery4.SQL.Add
        ('select nome, ende, bairro, cid, obs, iif(tipo = 1, cpf, cnpj) as cpf, cnpj, tipo, ies, tel,telres,telcom from cliente where cod = :cod');
      dm.ibquery4.ParamByName('cod').AsString :=
        dm.IBselect.FieldByName('cliente').AsString;
      dm.ibquery4.Open;

      addRelatorioForm19(funcoes.CompletaOuRepete
        (funcoes.CompletaOuRepete(copy('| Endereco: ' + dm.ibquery4.FieldByName
        ('ende').AsString, 1, 40), '', ' ', 41) + funcoes.CompletaOuRepete
        ('|INSC. EST.: ' + dm.ibquery4.FieldByName('cpf').AsString, '', ' ',
        37), '|', ' ', 80) + #13 + #10);
      addRelatorioForm19(funcoes.CompletaOuRepete
        (funcoes.CompletaOuRepete(copy('| Bairro: ' + dm.ibquery4.FieldByName
        ('bairro').AsString + ' - ' + dm.ibquery4.FieldByName('cid').AsString,
        1, 40), '', ' ', 41) + funcoes.CompletaOuRepete('|Codigo: ' +
        dm.ibquery4.FieldByName('ies').AsString, '', ' ', 37), '|', ' ', 80) +
        #13 + #10);
      addRelatorioForm19(funcoes.CompletaOuRepete
        (funcoes.CompletaOuRepete(copy('| Obs: ' + dm.ibquery4.FieldByName
        ('obs').AsString, 1, 40), '', ' ', 41) + funcoes.CompletaOuRepete
        ('|Fone: ' + dm.ibquery4.FieldByName('tel').AsString, '', ' ', 37), '|',
        ' ', 80) + #13 + #10);
      form19.RichEdit1.Perform(EM_REPLACESEL, 1,
        Longint(PChar((funcoes.CompletaOuRepete('+', '+', '-', 80) + #13
        + #10))));
      dm.ibquery4.Close;
    end
    else
      form19.RichEdit1.Perform(EM_REPLACESEL, 1,
        Longint(PChar((funcoes.CompletaOuRepete('+', '+', '-', 80) + #13
        + #10))));
    test := 1;

    form19.RichEdit1.Perform(EM_REPLACESEL, 1,
      Longint(PChar((#15 +
      '| Codigo | Cod. Barras |Unid. | Qtd. | Descricao das Mercadorias |Desconto |Unitario |   Total   |'
      + #13 + #10))));
    form19.RichEdit1.Perform(EM_REPLACESEL, 1,
      Longint(PChar
      (('+--------+-------------+------+------+---------------------------+---------+---------+-----------+'
      + #13 + #10))));

    dm.IBQuery2.Close;
    dm.IBQuery2.SQL.Clear;
    dm.IBQuery2.SQL.Add
      ('select cod, p_venda, total, quant from item_venda where nota='
      + numNota);
    dm.IBQuery2.Open;
    dm.IBQuery2.First;
    sub := 0;
    total := 0;
    while not dm.IBQuery2.Eof do
    begin
      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add
        ('select unid, codbar, nome, localiza, refori from produto where cod=' +
        dm.IBQuery2.FieldByName('cod').AsString);
      dm.IBQuery1.Open;
      total := total + dm.IBQuery2.FieldByName('total').AsCurrency;
      sub := sub + dm.IBQuery2.FieldByName('quant').AsCurrency;
      form19.RichEdit1.Perform(EM_REPLACESEL, 1,
        Longint(PChar(('|' + funcoes.CompletaOuRepete('',
        dm.IBQuery2.FieldByName('cod').AsString + '|', ' ',
        9) + funcoes.CompletaOuRepete('', dm.IBQuery1.FieldByName('codbar')
        .AsString + '|', ' ', 14) + funcoes.CompletaOuRepete('',
        dm.IBQuery1.FieldByName('unid').AsString + '|', ' ',
        7) + funcoes.CompletaOuRepete('', FormatCurr('#,###,###0.000',
        dm.IBQuery2.FieldByName('quant').AsCurrency) + '|', ' ',
        7) + funcoes.CompletaOuRepete(copy(dm.IBQuery1.FieldByName('nome')
        .AsString, 1, 27), '|', ' ', 28) + funcoes.CompletaOuRepete('',
        FormatCurr('#,###,###0.00', 0) + '|', ' ',
        10) + funcoes.CompletaOuRepete('', FormatCurr('#,###,###0.00',
        dm.IBQuery2.FieldByName('p_venda').AsCurrency) + '|', ' ',
        10) + funcoes.CompletaOuRepete('', FormatCurr('#,###,###0.00',
        dm.IBQuery2.FieldByName('total').AsCurrency) + '|', ' ', 12) + #13
        + #10))));
      dm.IBQuery2.Next;
    end;
    dm.IBQuery1.Close;

    if form19.RichEdit1.Lines.count < 50 then
    begin
      for i := form19.RichEdit1.Lines.count to 50 do
      begin
        form19.RichEdit1.Perform(EM_REPLACESEL, 1,
          Longint(PChar(('|' + funcoes.CompletaOuRepete('', '|', ' ',
          9) + funcoes.CompletaOuRepete('', '|', ' ',
          14) + funcoes.CompletaOuRepete('', '|', ' ',
          7) + funcoes.CompletaOuRepete('', '|', ' ',
          7) + funcoes.CompletaOuRepete('', '|', ' ',
          28) + funcoes.CompletaOuRepete('', '|', ' ',
          10) + funcoes.CompletaOuRepete('', '|', ' ',
          10) + funcoes.CompletaOuRepete('', '|', ' ', 12) + #13 + #10))));
      end;
    end;
    form19.RichEdit1.Perform(EM_REPLACESEL, 1,
      Longint(PChar((#18 + #13 + #10))));
    form19.RichEdit1.Perform(EM_REPLACESEL, 1,
      Longint(PChar((funcoes.CompletaOuRepete('+', '+', '-', 80) + #13
      + #10))));
    form19.RichEdit1.Perform(EM_REPLACESEL, 1,
      Longint(PChar((funcoes.CompletaOuRepete('|',
      funcoes.CompletaOuRepete('Sub-Total:', FormatCurr('#,###,###0.00', total),
      '.', 28) + ' |', ' ', 80) + #13 + #10))));
    form19.RichEdit1.Perform(EM_REPLACESEL, 1,
      Longint(PChar((funcoes.CompletaOuRepete('|',
      funcoes.CompletaOuRepete('Desconto(' + FormatCurr('#,###,###0.00',
      (dm.IBselect.FieldByName('desconto').AsCurrency * 100) / total) + '%):',
      FormatCurr('#,###,###0.00', dm.IBselect.FieldByName('desconto')
      .AsCurrency), '.', 28) + ' |', ' ', 80) + #13 + #10))));
    form19.RichEdit1.Perform(EM_REPLACESEL, 1,
      Longint(PChar((funcoes.CompletaOuRepete('| Volumes: ' +
      funcoes.CompletaOuRepete('', FormatCurr('#,###,###0.00', sub), ' ', 9),
      funcoes.CompletaOuRepete('Sub-Total:', FormatCurr('#,###,###0.00',
      dm.IBselect.FieldByName('total').AsCurrency), '.', 28) + ' |', ' ',
      80) + #13 + #10))));
    form19.RichEdit1.Perform(EM_REPLACESEL, 1,
      Longint(PChar((funcoes.CompletaOuRepete('+', '+', '-', 80) + #13
      + #10))));
    form19.RichEdit1.Perform(EM_REPLACESEL, 1,
      Longint(PChar(('| Vendedor: ' + funcoes.CompletaOuRepete
      (copy(dm.IBselect.FieldByName('vendedor').AsString + '-' +
      BuscaNomeBD(dm.IBQuery1, 'nome', 'vendedor',
      'where cod=' + dm.IBselect.FieldByName('vendedor').AsString), 1, 16), '|',
      ' ', 17) + CompletaOuRepete('Recebido Por: ', '|', ' ', 51) + #13
      + #10))));
    form19.RichEdit1.Perform(EM_REPLACESEL, 1,
      Longint(PChar(('| Vencimento: ' + CompletaOuRepete(FormatDateTime
      ('DD/MM/YY', dm.IBselect.FieldByName('data').AsDateTime), '|', ' ',
      15) + CompletaOuRepete('', '|', ' ', 51) + #13 + #10))));
    form19.RichEdit1.Perform(EM_REPLACESEL, 1,
      Longint(PChar((funcoes.CompletaOuRepete('+', '+', '-', 80) + #13
      + #10))));

    if EnviarImpressora = 'S' then
    begin
      imprime.textx('texto.txt');
    end
    else
      form19.ShowModal;

  end;

  if tipo = 'G' then
  begin
    total := 0;
    dm.IBQuery2.Close;
    dm.IBQuery2.SQL.Clear;
    dm.IBQuery2.SQL.Add('select * from registro');
    dm.IBQuery2.Open;
    { form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('+','+','-',80)+#13+#10))));
      form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('| PEDIDO Nr:'+dm.IBselect.fieldbyname('nota').AsString+'     PAGTO: '+dm.IBselect.fieldbyname('codhis').AsString+'-'+(BuscaNomeBD(dm.ibquery1,'nome','formpagto','where cod='+dm.IBselect.fieldbyname('codhis').AsString)),'EMISSAO: '+dm.IBselect.fieldbyname('data').AsString+' |',' ',80)+#13+#10))));
      form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('+','+','-',80)+#13+#10))));
      form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('| '+form22.Pgerais.Values['empresa'],'CNPJ: '+dm.IBQuery2.fieldbyname('cnpj').AsString+' |',' ',80)+#13+#10))));
      form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('| '+dm.IBQuery2.fieldbyname('ende').AsString+'  - '+dm.IBQuery2.fieldbyname('bairro').AsString,'|',' ',80)+#13+#10))));
      form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('| Fone: '+dm.IBQuery2.fieldbyname('telres').AsString+'       '+dm.IBQuery2.fieldbyname('telcom').AsString+ '  '+ dm.IBQuery2.fieldbyname('cid').AsString+' - '+dm.IBQuery2.fieldbyname('est').AsString,'IE: '+dm.IBQuery2.fieldbyname('ies').AsString+' |',' ',80)+#13+#10))));
      form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('| Obs: '+dm.IBQuery2.FieldByName('obs').AsString,'|',' ',80)+#13+#10))));
      form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('+','+','-',80)+#13+#10))));
      form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('| Nome: '+funcoes.CompletaOuRepete(funcoes.BuscaNomeBD(dm.ibquery1,'nome','cliente','where cod='+dm.IBselect.fieldbyname('cliente').AsString),'|',' ',41),'CPF/CNPJ: '+funcoes.BuscaNomeBD(dm.ibquery1,'cnpj','cliente','where cod='+dm.IBselect.fieldbyname('cliente').AsString)+' |',' ',80)+#13+#10))));
      form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('+','+','-',80)+#13+#10))));
      form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar(('|Codigo| Unid |  Qtd. |    Descricao das Mercadorias     |Unitario|    Total   |'+#13+#10))));
      form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar(('+------+------+-------+----------------------------------+--------+------------+'+#13+#10))));
    }
    form19.RichEdit1.Perform(EM_REPLACESEL, 1,
      Longint(PChar((funcoes.CompletaOuRepete('+', '+', '-', 80) + #13
      + #10))));
    form19.RichEdit1.Perform(EM_REPLACESEL, 1,
      Longint(PChar((funcoes.CompletaOuRepete('| PEDIDO Nr:' +
      dm.IBselect.FieldByName('nota').AsString + '     PAGTO: ' +
      dm.IBselect.FieldByName('codhis').AsString + '-' +
      (BuscaNomeBD(dm.IBQuery1, 'nome', 'formpagto',
      'where cod=' + dm.IBselect.FieldByName('codhis').AsString)),
      'EMISSAO: ' + dm.IBselect.FieldByName('data').AsString + ' |', ' ',
      80) + #13 + #10))));
    form19.RichEdit1.Perform(EM_REPLACESEL, 1,
      Longint(PChar((funcoes.CompletaOuRepete('+', '+', '-', 80) + #13
      + #10))));
    form19.RichEdit1.Perform(EM_REPLACESEL, 1,
      Longint(PChar((funcoes.CompletaOuRepete('| ' + form22.Pgerais.Values
      ['empresa'], 'CNPJ: ' + dm.IBQuery2.FieldByName('cnpj').AsString + ' |',
      ' ', 80) + #13 + #10))));
    form19.RichEdit1.Perform(EM_REPLACESEL, 1,
      Longint(PChar((funcoes.CompletaOuRepete('| ' + dm.IBQuery2.FieldByName
      ('ende').AsString + '  - ' + dm.IBQuery2.FieldByName('bairro').AsString,
      '|', ' ', 80) + #13 + #10))));
    form19.RichEdit1.Perform(EM_REPLACESEL, 1,
      Longint(PChar((funcoes.CompletaOuRepete('| Fone: ' +
      dm.IBQuery2.FieldByName('telres').AsString + '  Cel: ' +
      dm.IBQuery2.FieldByName('telcom').AsString + '  ' +
      dm.IBQuery2.FieldByName('cid').AsString + ' - ' + dm.IBQuery2.FieldByName
      ('est').AsString, 'IE: ' + dm.IBQuery2.FieldByName('ies').AsString + ' |',
      ' ', 80) + #13 + #10))));
    form19.RichEdit1.Perform(EM_REPLACESEL, 1,
      Longint(PChar((funcoes.CompletaOuRepete('| Obs: ' +
      dm.IBQuery2.FieldByName('obs').AsString, '|', ' ', 80) + #13 + #10))));
    form19.RichEdit1.Perform(EM_REPLACESEL, 1,
      Longint(PChar((funcoes.CompletaOuRepete('+', '+', '-', 80) + #13
      + #10))));
    // form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete(,'|',' ',35) ,'CPF/CNPJ: ' +  + #13 + #10))));
    // form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('| Nome: '+funcoes.CompletaOuRepete(funcoes.BuscaNomeBD(dm.ibquery1,'nome','cliente','where cod='+dm.IBselect.fieldbyname('cliente').AsString),'|',' ',41),'CPF/CNPJ: '+funcoes.BuscaNomeBD(dm.ibquery1,'cnpj','cliente','where cod='+dm.IBselect.fieldbyname('cliente').AsString)+' |',' ',80)+#13+#10))));
    addRelatorioForm19(funcoes.CompletaOuRepete(funcoes.CompletaOuRepete
      (copy('| Cliente: ' + dm.IBselect.FieldByName('cliente').AsString + '-' +
      funcoes.BuscaNomeBD(dm.IBQuery1, 'nome', 'cliente',
      'where cod=' + dm.IBselect.FieldByName('cliente').AsString), 1, 40), '',
      ' ', 41) + funcoes.CompletaOuRepete('|CPF/CNPJ: ' +
      funcoes.BuscaNomeBD(dm.IBQuery1, 'cnpj', 'cliente',
      'where cod=' + dm.IBselect.FieldByName('cliente').AsString), '', ' ', 37),
      '|', ' ', 80) + #13 + #10);

    if ConfParamGerais.Strings[27] = 'S' then
    begin
      dm.ibquery4.Close;
      dm.ibquery4.SQL.Clear;
      dm.ibquery4.SQL.Add
        ('select nome, ende, bairro, cid, obs, iif(tipo = 1, cpf, cnpj) as cpf, cnpj, tipo, ies, tel,telres,telcom from cliente where cod = :cod');
      dm.ibquery4.ParamByName('cod').AsString :=
        dm.IBselect.FieldByName('cliente').AsString;
      dm.ibquery4.Open;

      addRelatorioForm19(funcoes.CompletaOuRepete
        (funcoes.CompletaOuRepete(copy('| Endereco: ' + dm.ibquery4.FieldByName
        ('ende').AsString, 1, 40), '', ' ', 41) + funcoes.CompletaOuRepete
        ('|INSC. EST.: ' + dm.ibquery4.FieldByName('cpf').AsString, '', ' ',
        37), '|', ' ', 80) + #13 + #10);
      addRelatorioForm19(funcoes.CompletaOuRepete
        (funcoes.CompletaOuRepete(copy('| Bairro: ' + dm.ibquery4.FieldByName
        ('bairro').AsString + ' - ' + dm.ibquery4.FieldByName('cid').AsString,
        1, 40), '', ' ', 41) + funcoes.CompletaOuRepete('|Codigo: ' +
        dm.ibquery4.FieldByName('ies').AsString, '', ' ', 37), '|', ' ', 80) +
        #13 + #10);
      addRelatorioForm19(funcoes.CompletaOuRepete
        (funcoes.CompletaOuRepete(copy('| Obs: ' + dm.ibquery4.FieldByName
        ('obs').AsString, 1, 40), '', ' ', 41) + funcoes.CompletaOuRepete
        ('|Fone: ' + dm.ibquery4.FieldByName('tel').AsString, '', ' ', 37), '|',
        ' ', 80) + #13 + #10);
      form19.RichEdit1.Perform(EM_REPLACESEL, 1,
        Longint(PChar((funcoes.CompletaOuRepete('+', '+', '-', 80) + #13
        + #10))));
      dm.ibquery4.Close;
    end
    else
      form19.RichEdit1.Perform(EM_REPLACESEL, 1,
        Longint(PChar((funcoes.CompletaOuRepete('+', '+', '-', 80) + #13
        + #10))));

    form19.RichEdit1.Perform(EM_REPLACESEL, 1,
      Longint(PChar
      (('|Codigo| Unid |  Qtd.   |    Descricao das Mercadorias     |Unitario|    Total |'
      + #13 + #10))));
    form19.RichEdit1.Perform(EM_REPLACESEL, 1,
      Longint(PChar
      (('+------+------+---------+----------------------------------+--------+----------+'
      + #13 + #10))));

    dm.IBQuery2.Close;
    dm.IBQuery2.SQL.Clear;
    dm.IBQuery2.SQL.Add
      ('select cod, p_venda, total, quant from item_venda where nota='
      + numNota);
    dm.IBQuery2.Open;
    dm.IBQuery2.First;
    sub := 0;
    total := 0;
    while not dm.IBQuery2.Eof do
    begin
      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add
        ('select unid, codbar, nome, localiza, refori from produto where cod=' +
        dm.IBQuery2.FieldByName('cod').AsString);
      dm.IBQuery1.Open;
      total := total + dm.IBQuery2.FieldByName('total').AsCurrency;
      sub := sub + dm.IBQuery2.FieldByName('quant').AsCurrency;
      form19.RichEdit1.Perform(EM_REPLACESEL, 1,
        Longint(PChar(('|' + funcoes.CompletaOuRepete('',
        dm.IBQuery2.FieldByName('cod').AsString + '|', ' ',
        7) + funcoes.CompletaOuRepete('', dm.IBQuery1.FieldByName('unid')
        .AsString + '|', ' ', 7) + funcoes.CompletaOuRepete('',
        FormatCurr('0.000', dm.IBQuery2.FieldByName('quant').AsCurrency) + '|',
        ' ', 10) + funcoes.CompletaOuRepete(copy(dm.IBQuery1.FieldByName('nome')
        .AsString, 1, 34), '|', ' ', 35) + funcoes.CompletaOuRepete('',
        FormatCurr('#,###,###0.00', dm.IBQuery2.FieldByName('p_venda')
        .AsCurrency) + '|', ' ', 9) + funcoes.CompletaOuRepete('',
        FormatCurr('#,###,###0.00', dm.IBQuery2.FieldByName('total').AsCurrency)
        + '|', ' ', 11) + #13 + #10))));
      dm.IBQuery2.Next;
    end;
    dm.IBQuery1.Close;

    try
      if funcoes.ExisteParcelamento(numNota) and
        (ConfParamGerais.Strings[20] = 'S') then
      // (form22.Pgerais.Strings[20] = 'S') then
      begin
        form19.RichEdit1.Perform(EM_REPLACESEL, 1,
          Longint(PChar
          (('|      |      |         |                                  |        |          |'))
          ));
        funcoes.ImprimeParcelamento('|      |      |         |    ',
          '    |        |          |', FormatCurr('#,###,###0.00',
          dm.IBselect.FieldByName('entrada').AsCurrency), numNota);
      end;
    except
      on e: exception do
      begin
        gravaErrosNoArquivo(e.Message, 'Form20', '808',
          'NotaMedia - ImprimeNota');
      end;
    end;

    if form19.RichEdit1.Lines.count < 50 then
    begin
      for i := form19.RichEdit1.Lines.count to 50 do
      begin
        form19.RichEdit1.Perform(EM_REPLACESEL, 1,
          Longint(PChar(('|' + funcoes.CompletaOuRepete('', '|', ' ',
          7) + funcoes.CompletaOuRepete('', '|', ' ',
          7) + funcoes.CompletaOuRepete('', '|', ' ',
          10) + funcoes.CompletaOuRepete('', '|', ' ',
          35) + funcoes.CompletaOuRepete('', '|', ' ',
          9) + funcoes.CompletaOuRepete('', '|', ' ', 11) + #13 + #10))));
      end;
    end;

    form19.RichEdit1.Perform(EM_REPLACESEL, 1,
      Longint(PChar((funcoes.CompletaOuRepete('+', '+', '-', 80) + #13
      + #10))));
    form19.RichEdit1.Perform(EM_REPLACESEL, 1,
      Longint(PChar((funcoes.CompletaOuRepete('|',
      funcoes.CompletaOuRepete('Sub-Total:', FormatCurr('#,###,###0.00', total),
      '.', 28) + ' |', ' ', 80) + #13 + #10))));
    form19.RichEdit1.Perform(EM_REPLACESEL, 1,
      Longint(PChar((funcoes.CompletaOuRepete('|',
      funcoes.CompletaOuRepete('Desconto(' + FormatCurr('#,###,###0.00',
      (dm.IBselect.FieldByName('desconto').AsCurrency * 100) / total) + '%):',
      FormatCurr('#,###,###0.00', dm.IBselect.FieldByName('desconto')
      .AsCurrency), '.', 28) + ' |', ' ', 80) + #13 + #10))));
    form19.RichEdit1.Perform(EM_REPLACESEL, 1,
      Longint(PChar((funcoes.CompletaOuRepete('| Volumes: ' +
      funcoes.CompletaOuRepete('', FormatCurr('#,###,###0.00', sub), ' ', 9),
      funcoes.CompletaOuRepete('Sub-Total:', FormatCurr('#,###,###0.00',
      dm.IBselect.FieldByName('total').AsCurrency), '.', 28) + ' |', ' ',
      80) + #13 + #10))));
    form19.RichEdit1.Perform(EM_REPLACESEL, 1,
      Longint(PChar((funcoes.CompletaOuRepete('+', '+', '-', 80) + #13
      + #10))));
    form19.RichEdit1.Perform(EM_REPLACESEL, 1,
      Longint(PChar(('| Vendedor: ' + funcoes.CompletaOuRepete
      (copy(dm.IBselect.FieldByName('vendedor').AsString + '-' +
      BuscaNomeBD(dm.IBQuery1, 'nome', 'vendedor',
      'where cod=' + dm.IBselect.FieldByName('vendedor').AsString), 1, 16), '|',
      ' ', 17) + CompletaOuRepete('Recebido Por: ', '|', ' ', 51) + #13
      + #10))));
    form19.RichEdit1.Perform(EM_REPLACESEL, 1,
      Longint(PChar(('| Vencimento: ' + CompletaOuRepete(FormatDateTime
      ('DD/MM/YY', dm.IBselect.FieldByName('data').AsDateTime), '|', ' ',
      15) + CompletaOuRepete('', '|', ' ', 51) + #13 + #10))));
    form19.RichEdit1.Perform(EM_REPLACESEL, 1,
      Longint(PChar((funcoes.CompletaOuRepete('+', '+', '-', 80) + #13
      + #10))));

    if EnviarImpressora = 'S' then
    begin
      imprime.textx('texto.txt');
    end
    else
      form19.ShowModal;
  end;

  if (tipo = 'X') then
  begin
    tam := 78;
    total := 0;
    dm.IBQuery2.Close;
    dm.IBQuery2.SQL.Clear;
    dm.IBQuery2.SQL.Add('select * from registro');
    dm.IBQuery2.Open;

    addRelatorioForm19(funcoes.CompletaOuRepete(#218, #191, #196, tam) + CRLF);
    addRelatorioForm19
      (#179 + '  *    *    *    *   S E M    V A L O R    F I S C A L   *    *    *     *  '
      + #179 + CRLF);

    addRelatorioForm19(funcoes.CompletaOuRepete(#195, #180, #196, tam) + CRLF);

    if ((opcao = 1) or (opcao = 4)) then
    begin
      form19.RichEdit1.Perform(EM_REPLACESEL, 1,
        Longint(PChar((funcoes.CompletaOuRepete(#179 + ' PEDIDO Nr:' +
        dm.IBselect.FieldByName('nota').AsString + '     PAGTO: ' +
        dm.IBselect.FieldByName('codhis').AsString + '-' +
        (BuscaNomeBD(dm.IBQuery1, 'nome', 'formpagto',
        'where cod=' + dm.IBselect.FieldByName('codhis').AsString)),
        'EMISSAO: ' + FormatDateTime('dd/mm/yy', dm.IBselect.FieldByName('data')
        .AsDateTime) + ' ' + FormatDateTime('hh:mm:ss',
        dm.IBselect.FieldByName('hora').AsDateTime) + ' ' + #179, ' ',
        tam) + #13 + #10))));
    end
    else if opcao = 2 then
      form19.RichEdit1.Perform(EM_REPLACESEL, 1,
        Longint(PChar((funcoes.CompletaOuRepete(#179 + ' ORCAMENTO Nr:' +
        dm.IBselect.FieldByName('nota').AsString + '     PAGTO: ' +
        dm.IBselect.FieldByName('codhis').AsString + '-' +
        (BuscaNomeBD(dm.IBQuery1, 'nome', 'formpagto',
        'where cod=' + dm.IBselect.FieldByName('codhis').AsString)),
        'EMISSAO: ' + dm.IBselect.FieldByName('data').AsString + ' ' + #179,
        ' ', tam) + #13 + #10))))
    else
      form19.RichEdit1.Perform(EM_REPLACESEL, 1,
        Longint(PChar((funcoes.CompletaOuRepete(#179 + ' COMPRA Nr:' +
        dm.IBselect.FieldByName('nota').AsString + '     PAGTO: ' +
        dm.IBselect.FieldByName('codhis').AsString + '-' +
        (BuscaNomeBD(dm.IBQuery1, 'nome', 'formpagto',
        'where cod=' + dm.IBselect.FieldByName('codhis').AsString)),
        'EMISSAO: ' + dm.IBselect.FieldByName('data').AsString + ' ' + #179,
        ' ', tam) + #13 + #10))));

    addRelatorioForm19(funcoes.CompletaOuRepete(#195, #180, #196, tam) + CRLF);

    form19.RichEdit1.Perform(EM_REPLACESEL, 1,
      Longint(PChar((funcoes.CompletaOuRepete(#179 + ' ' + form22.Pgerais.Values
      ['empresa'], 'CNPJ: ' + dm.IBQuery2.FieldByName('cnpj').AsString + ' ' +
      #179, ' ', tam) + #13 + #10))));
    form19.RichEdit1.Perform(EM_REPLACESEL, 1,
      Longint(PChar((funcoes.CompletaOuRepete(#179 + ' ' +
      dm.IBQuery2.FieldByName('ende').AsString + '  - ' +
      dm.IBQuery2.FieldByName('bairro').AsString, #179, ' ', tam) + #13
      + #10))));

    form19.RichEdit1.Perform(EM_REPLACESEL, 1,
      Longint(PChar((funcoes.CompletaOuRepete(#179 + ' Fone: ' +
      dm.IBQuery2.FieldByName('telres').AsString + '  Cel: ' +
      dm.IBQuery2.FieldByName('telcom').AsString + '  ' +
      dm.IBQuery2.FieldByName('cid').AsString + ' - ' + dm.IBQuery2.FieldByName
      ('est').AsString, 'IE: ' + dm.IBQuery2.FieldByName('ies').AsString + ' ' +
      #179, ' ', tam) + #13 + #10))));
    form19.RichEdit1.Perform(EM_REPLACESEL, 1,
      Longint(PChar((funcoes.CompletaOuRepete(#179 + ' Obs: ' +
      dm.IBQuery2.FieldByName('obs').AsString, #179, ' ', tam) + #13 + #10))));

    addRelatorioForm19(funcoes.CompletaOuRepete(#195, #194, #196, 47) +
      funcoes.CompletaOuRepete('', #180, #196, 31) + CRLF);

    // addRelatorioForm19(funcoes.CompletaOuRepete(funcoes.CompletaOuRepete(copy('| Nome: '+ funcoes.BuscaNomeBD(dm.ibquery1,'nome','cliente','where cod=' + dm.IBselect.fieldbyname('cliente').AsString), 1, 38), '', ' ', 39) + funcoes.CompletaOuRepete('|CPF/CNPJ: ' + funcoes.BuscaNomeBD(dm.ibquery1,'cnpj','cliente','where cod=' + dm.IBselect.fieldbyname('cliente').AsString) , '', ' ', 37), '|',' ', tam) + #13 + #10);
    addRelatorioForm19(funcoes.CompletaOuRepete(funcoes.CompletaOuRepete
      (copy(#179 + ' Cliente: ' + iif(ConfParamGerais.Strings[27] = 'N',
      dm.IBselect.FieldByName('cliente').AsString + '-',
      '') + funcoes.BuscaNomeBD(dm.IBQuery1, 'nome', 'cliente',
      'where cod=' + dm.IBselect.FieldByName('cliente').AsString), 1, 46), '',
      ' ', 46) + funcoes.CompletaOuRepete(#179 + 'CPF/CNPJ: ' +
      funcoes.BuscaNomeBD(dm.IBQuery1, 'cnpj', 'cliente',
      'where cod=' + dm.IBselect.FieldByName('cliente').AsString), '', ' ', 29),
      #179, ' ', tam) + #13 + #10);

    dm.ibquery4.Close;
    dm.ibquery4.SQL.Clear;
    dm.ibquery4.SQL.Add
      ('select cod, nome, ende, bairro, cid, obs, iif(tipo = 1, cpf, cnpj) as cpf, cnpj, tipo, ies, tel,telres,telcom from cliente where cod = :cod');
    dm.ibquery4.ParamByName('cod').AsString :=
      dm.IBselect.FieldByName('cliente').AsString;
    dm.ibquery4.Open;

    if ((ConfParamGerais.Strings[27] = 'S') and
      (dm.ibquery4.FieldByName('ende').AsString <> '')) then
    begin
      { dm.IBQuery4.Close;
        dm.IBQuery4.SQL.Clear;
        dm.IBQuery4.SQL.Add('select cod, nome, ende, bairro, cid, obs, iif(tipo = 1, cpf, cnpj) as cpf, cnpj, tipo, ies, tel,telres,telcom from cliente where cod = :cod');
        dm.IBQuery4.ParamByName('cod').AsString := dm.IBselect.fieldbyname('cliente').AsString;
        dm.IBQuery4.Open; }

      addRelatorioForm19(funcoes.CompletaOuRepete
        (funcoes.CompletaOuRepete(copy(#179 + ' End: ' + dm.ibquery4.FieldByName
        ('ende').AsString, 1, 46), '', ' ', 46) + funcoes.CompletaOuRepete(#179
        + 'INSC. EST.: ' + LeftStr(dm.ibquery4.FieldByName('ies').AsString, 29),
        '', ' ', 29), #179, ' ', tam) + #13 + #10);
      addRelatorioForm19(funcoes.CompletaOuRepete
        (funcoes.CompletaOuRepete(copy(#179 + ' Bairro: ' +
        dm.ibquery4.FieldByName('bairro').AsString + ' - ' +
        dm.ibquery4.FieldByName('cid').AsString, 1, 46), '', ' ', 46) +
        funcoes.CompletaOuRepete(#179 + 'Codigo: ' + dm.ibquery4.FieldByName
        ('cod').AsString, '', ' ', 29), #179, ' ', tam) + #13 + #10);

      if length(trim(dm.ibquery4.FieldByName('obs').AsString)) <= 39 then
      begin
        addRelatorioForm19
          (funcoes.CompletaOuRepete(funcoes.CompletaOuRepete(copy(#179 +
          ' Obs: ' + dm.ibquery4.FieldByName('obs').AsString, 1, 46), '', ' ',
          46) + funcoes.CompletaOuRepete(#179 + 'Fone: ' +
          dm.ibquery4.FieldByName('telres').AsString, '', ' ', 29), #179, ' ',
          tam) + #13 + #10);
        { addRelatorioForm19(funcoes.CompletaOuRepete(funcoes.CompletaOuRepete(copy('| Endereco: ' + dm.IBQuery4.fieldbyname('ende').AsString,1, 38), '', ' ', 39) + funcoes.CompletaOuRepete('|INSC. EST.: ' + dm.IBQuery4.fieldbyname('ies').AsString , '', ' ', 37), '|',' ', tam) + #13 + #10);
          addRelatorioForm19(funcoes.CompletaOuRepete(funcoes.CompletaOuRepete(copy('| Bairro: ' + dm.IBQuery4.fieldbyname('bairro').AsString + ' - ' + dm.IBQuery4.fieldbyname('cid').AsString, 1, 38), '', ' ', 39) + funcoes.CompletaOuRepete('|Codigo: ' + dm.IBQuery4.fieldbyname('cod').AsString , '', ' ', 37),'|',' ', tam) + #13 + #10);
          addRelatorioForm19(funcoes.CompletaOuRepete(funcoes.CompletaOuRepete(copy('| Obs: ' + dm.IBQuery4.fieldbyname('obs').AsString, 1, 38) , '', ' ', 39) + funcoes.CompletaOuRepete('|Fone: ' + dm.IBQuery4.fieldbyname('telres').AsString , '', ' ', 37),'|',' ', tam) + #13 + #10); }
        dm.ibquery4.Close;
      end
      else
      begin
        fornecNFe := 'XX';

        addRelatorioForm19
          (funcoes.CompletaOuRepete(funcoes.CompletaOuRepete(#179, '', ' ',
          46) + funcoes.CompletaOuRepete(#179 + 'Fone: ' +
          dm.ibquery4.FieldByName('telres').AsString, '', ' ', 29), #179, ' ',
          tam) + #13 + #10);
        addRelatorioForm19(funcoes.CompletaOuRepete(#179 + ' Obs: ' +
          dm.ibquery4.FieldByName('obs').AsString, '', ' ', tam - 1) +
          #179 + CRLF);

        dm.ibquery4.Close;
      end;
    end;

    dm.ibquery4.Close;

    // addRelatorioForm19(funcoes.CompletaOuRepete(#195, #180, #196, tam) + CRLF);
    // addRelatorioForm19(funcoes.CompletaOuRepete(#195, #193, #196, 47) + funcoes.CompletaOuRepete('', #180, #196, 31) + CRLF);

    if funcoes.buscaParamGeral(63, 'N') = 'S' then
    begin
      if fornecNFe <> 'XX' then
      begin
        addRelatorioForm19(CompletaOuRepete(#195, #194, #196, 7) +
          CompletaOuRepete('', #194, #196, 4) + CompletaOuRepete('', #194, #196,
          9) + CompletaOuRepete('', #193, #196, 27) + CompletaOuRepete('', #194,
          #196, 11) + CompletaOuRepete('', #194, #196, 9) + CompletaOuRepete('',
          #180, #196, 11) + CRLF);
      end
      else
      begin
        addRelatorioForm19(CompletaOuRepete(#195, #194, #196, 7) +
          CompletaOuRepete('', #194, #196, 4) + CompletaOuRepete('', #194, #196,
          9) + CompletaOuRepete('', '', #196, 27) + CompletaOuRepete('', #194,
          #196, 11) + CompletaOuRepete('', #194, #196, 9) + CompletaOuRepete('',
          #180, #196, 11) + CRLF);
      end;

      form19.RichEdit1.Perform(EM_REPLACESEL, 1,
        Longint(PChar((#179 + 'Cod. ' + #179 + 'Un ' + #179 + '  Qtd.  ' + #179
        + '   Descricao das Mercadorias         ' + #179 + '  Unit. ' + #179 +
        '  Total   ' + #179 + #13 + #10))));

      addRelatorioForm19(CompletaOuRepete(#195, #197, #196, 7) +
        CompletaOuRepete('', #197, #196, 4) + CompletaOuRepete('', #197, #196,
        9) + CompletaOuRepete('', #197, #196, 38) + CompletaOuRepete('', #197,
        #196, 9) + CompletaOuRepete('', #180, #196, 11) + CRLF);
    end
    else
    begin
      if fornecNFe <> 'XX' then
      begin
        addRelatorioForm19(CompletaOuRepete(#195, #194, #196, 8) +
          CompletaOuRepete('', #194, #196, 5) + CompletaOuRepete('', #194, #196,
          10) + CompletaOuRepete('', #193, #196, 24) + CompletaOuRepete('',
          #194, #196, 11) + CompletaOuRepete('', #194, #196, 9) +
          CompletaOuRepete('', #180, #196, 11) + CRLF);
      end
      else
      begin
        addRelatorioForm19(CompletaOuRepete(#195, #194, #196, 8) +
          CompletaOuRepete('', #194, #196, 5) + CompletaOuRepete('', #194, #196,
          10) + CompletaOuRepete('', '', #196, 24) + CompletaOuRepete('', #194,
          #196, 11) + CompletaOuRepete('', #194, #196, 9) + CompletaOuRepete('',
          #180, #196, 11) + CRLF);
      end;

      form19.RichEdit1.Perform(EM_REPLACESEL, 1,
        Longint(PChar((#179 + 'Codigo' + #179 + 'Unid' + #179 + '   Qtd.  ' +
        #179 + '  Descricao das Mercadorias       ' + #179 + 'Unitario' + #179 +
        '   Total  ' + #179 + #13 + #10))));
      // form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar(('+------+----+-----------+--------------------------------+--------+----------+'+#13+#10))));
      addRelatorioForm19(CompletaOuRepete(#195, #197, #196, 8) +
        CompletaOuRepete('', #197, #196, 5) + CompletaOuRepete('', #197, #196,
        10) + CompletaOuRepete('', #197, #196, 35) + CompletaOuRepete('', #197,
        #196, 9) + CompletaOuRepete('', #180, #196, 11) + CRLF);
    end;
    { form19.RichEdit1.Perform(EM_REPLACESEL, 1,
      Longint(PChar
      (('|Codigo| Unid |  Qtd.   |  Descricao das Mercadorias     |Unitario|   Total  |'
      + CRLF))));
      form19.RichEdit1.Perform(EM_REPLACESEL, 1,
      Longint(PChar
      (('+------+------+---------+--------------------------------+--------+----------+'
      + CRLF)))); }

    dm.IBQuery2.Close;
    dm.IBQuery2.SQL.Clear;

    if opcao = 1 then
      dm.IBQuery2.SQL.Add
        ('select cod,p_venda, total, quant, nome from item_venda where nota='
        + numNota)
    else if opcao = 2 then
      dm.IBQuery2.SQL.Add('select * from item_orcamento where nota=' + numNota)
    else if opcao = 3 then
      dm.IBQuery2.SQL.Add('select * from item_compra where nota=' + numNota)
    else if opcao = 4 then
    begin
      dm.IBQuery2.SQL.Add
        ('select e.cod, i.p_venda, i.total, iif(char_length(i.nome) = 0, p.nome, i.nome) as nome, '
        + 'e.quant, p.codbar, p.refori, p.localiza  from CONT_ENTREGA e left join '
        + 'item_venda i on (i.nota = e.nota and i.cod = e.cod) left join produto p on (i.cod = p.cod) '
        + 'where e.ENT_AGORA = ''X'' and e.nota = ' + numNota);
    end;

    dm.IBQuery2.Open;
    dm.IBQuery2.First;
    sub := 0;
    total := 0;
    while not dm.IBQuery2.Eof do
    begin
      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add
        ('select unid, P_VENDA, P_COMPRA,  codbar, nome, localiza, refori from produto where cod='
        + dm.IBQuery2.FieldByName('cod').AsString);
      dm.IBQuery1.Open;

      sub := sub + dm.IBQuery2.FieldByName('quant').AsCurrency;

      if ((opcao = 1) or (opcao = 4)) then
      begin
        nome := trim(dm.IBQuery2.FieldByName('nome').AsString);
        if nome = '' then
          nome := dm.IBQuery1.FieldByName('nome').AsString;
        nome := trim(nome);

        if funcoes.buscaParamGeral(63, 'N') = 'S' then
        begin
          form19.RichEdit1.Perform(EM_REPLACESEL, 1,
            Longint(PChar((#179 + '' + funcoes.CompletaOuRepete('',
            dm.IBQuery2.FieldByName('cod').AsString + #179, ' ',
            6) + funcoes.CompletaOuRepete('',
            LeftStr(dm.IBQuery1.FieldByName('unid').AsString, 3) + #179, ' ',
            4) + funcoes.CompletaOuRepete('', FormatCurr('0.00',
            dm.IBQuery2.FieldByName('quant').AsCurrency) + #179, ' ',
            9) + funcoes.CompletaOuRepete(copy(nome, 1, 37), #179, ' ',
            38) + funcoes.CompletaOuRepete('', FormatCurr('0.00',
            dm.IBQuery2.FieldByName('p_venda').AsCurrency) + #179, ' ',
            9) + funcoes.CompletaOuRepete('', FormatCurr('0.00',
            dm.IBQuery2.FieldByName('total').AsCurrency) + #179, ' ', 11) + #13
            + #10))));
        end
        else
        begin
          addRelatorioForm19(#179 + funcoes.CompletaOuRepete('',
            dm.IBQuery2.FieldByName('cod').AsString + #179, ' ', 7) +
            funcoes.CompletaOuRepete('', LeftStr(dm.IBQuery1.FieldByName('unid')
            .AsString, 4) + #179, ' ', 5) + funcoes.CompletaOuRepete('',
            FormatCurr('0.00', dm.IBQuery2.FieldByName('quant').AsCurrency) +
            #179, ' ', 10) + funcoes.CompletaOuRepete(LeftStr(nome, 34), #179,
            ' ', 35) + funcoes.CompletaOuRepete('', FormatCurr('0.00',
            dm.IBQuery2.FieldByName('p_venda').AsCurrency) + #179, ' ', 9) +
            funcoes.CompletaOuRepete('', FormatCurr('0.00',
            dm.IBQuery2.FieldByName('total').AsCurrency) + #179, ' ',
            11) + CRLF);
        end;
        total := total + dm.IBQuery2.FieldByName('total').AsCurrency;
      end
      else if opcao = 2 then
      begin
        nome := trim(dm.IBQuery2.FieldByName('nome').AsString);
        if nome = '' then
          nome := dm.IBQuery1.FieldByName('nome').AsString;
        nome := trim(nome);

        if funcoes.buscaParamGeral(63, 'N') = 'S' then
        begin
          form19.RichEdit1.Perform(EM_REPLACESEL, 1,
            Longint(PChar((#179 + funcoes.CompletaOuRepete('',
            dm.IBQuery2.FieldByName('cod').AsString + #179, ' ',
            6) + funcoes.CompletaOuRepete('',
            LeftStr(dm.IBQuery1.FieldByName('unid').AsString, 3) + #179, ' ',
            4) + funcoes.CompletaOuRepete('', FormatCurr('0.00',
            dm.IBQuery2.FieldByName('quant').AsCurrency) + #179, ' ',
            9) + funcoes.CompletaOuRepete(copy(nome, 1, 37), #179, ' ',
            38) + funcoes.CompletaOuRepete('', FormatCurr('0.00',
            dm.IBQuery2.FieldByName('p_venda').AsCurrency) + #179, ' ',
            9) + funcoes.CompletaOuRepete('', FormatCurr('0.00',
            dm.IBQuery2.FieldByName('total').AsCurrency) + #179, ' ', 11) + #13
            + #10))));
        end
        else
        begin
          addRelatorioForm19(#179 + funcoes.CompletaOuRepete('',
            dm.IBQuery2.FieldByName('cod').AsString + #179, ' ', 7) +
            funcoes.CompletaOuRepete('', LeftStr(dm.IBQuery1.FieldByName('unid')
            .AsString, 4) + #179, ' ', 5) + funcoes.CompletaOuRepete('',
            FormatCurr('0.00', dm.IBQuery2.FieldByName('quant').AsCurrency) +
            #179, ' ', 10) + funcoes.CompletaOuRepete
            (copy(dm.IBQuery1.FieldByName('nome').AsString, 1, 34), #179, ' ',
            35) + funcoes.CompletaOuRepete('', FormatCurr('0.00',
            dm.IBQuery2.FieldByName('p_venda').AsCurrency) + #179, ' ', 9) +
            funcoes.CompletaOuRepete('', FormatCurr('0.00',
            dm.IBQuery2.FieldByName('total').AsCurrency) + #179, ' ',
            11) + CRLF);
        end;
        total := total + dm.IBQuery2.FieldByName('total').AsCurrency;
      end
      else
      begin
        addRelatorioForm19(#179 + funcoes.CompletaOuRepete('',
          dm.IBQuery2.FieldByName('cod').AsString + #179, ' ', 7) +
          funcoes.CompletaOuRepete('', dm.IBQuery1.FieldByName('unid').AsString
          + #179, ' ', 7) + funcoes.CompletaOuRepete('',
          FormatCurr('#,###,###0.000', dm.IBQuery2.FieldByName('quant')
          .AsCurrency) + #179, ' ', 8) + funcoes.CompletaOuRepete
          (copy(dm.IBQuery1.FieldByName('nome').AsString, 1, 34), #179, ' ', 35)
          + funcoes.CompletaOuRepete('', FormatCurr('0.00',
          dm.IBQuery1.FieldByName('p_COMPRA').AsCurrency) + #179, ' ', 9) +
          funcoes.CompletaOuRepete('', FormatCurr('0.00',
          Arredonda(dm.IBQuery1.FieldByName('p_COMPRA').AsCurrency *
          dm.IBQuery2.FieldByName('quant').AsCurrency, 2)) + #179, ' ',
          11) + CRLF);
        total := total + Arredonda(dm.IBQuery1.FieldByName('p_compra')
          .AsCurrency * dm.IBQuery2.FieldByName('quant').AsCurrency, 2);
      end;

      dm.IBQuery2.Next;
    end;

    dm.IBQuery1.Close;
    if opcao = 1 then
    begin
      if funcoes.ExisteParcelamento(numNota) and (opcao = 1) and
        (ConfParamGerais.Strings[20] = 'S') then
      begin
        if funcoes.buscaParamGeral(63, 'N') = 'S' then
        begin
          addRelatorioForm19(#179 + '     ' + #179 + '   ' + #179 + '        ' +
            #179 + '                                     ' + #179 + '        ' +
            #179 + '          ' + #179 + CRLF);
          funcoes.ImprimeParcelamento(#179 + '     ' + #179 + '   ' + #179 +
            '        ' + #179 + '  ', '         ' + #179 + '        ' + #179 +
            '          ' + #179, FormatCurr('#,###,###0.00', entrada), numNota);
        end
        else
        begin
          addRelatorioForm19(#179 + '      ' + #179 + '    ' + #179 +
            '         ' + #179 + '                                  ' + #179 +
            '        ' + #179 + '          ' + #179 + CRLF);
          funcoes.ImprimeParcelamento(#179 + '      ' + #179 + '    ' + #179 +
            '         ' + #179 + '  ', '      ' + #179 + '        ' + #179 +
            '          ' + #179, FormatCurr('#,###,###0.00', entrada), numNota);
        end;
      end;
    end;

    if opcao = 4 then
    begin
      addRelatorioForm19(funcoes.CompletaOuRepete(#195, #180, #196,
        tam) + CRLF);
      addRelatorioForm19(funcoes.CompletaOuRepete(#179 +
        centraliza
        ('* * * * *   E N T R E G A  D E  P R O D U T O S   * * * * *  ', ' ',
        tam - 3), #179, ' ', tam) + CRLF);
      addRelatorioForm19(funcoes.CompletaOuRepete(#195, #180, #196,
        tam) + CRLF);
    end;

    if tipo = 'X' then
    begin
      if funcoes.buscaParamGeral(63, 'N') = 'S' then
      begin
        addRelatorioForm19(CompletaOuRepete(#195, #193, #196, 7) +
          CompletaOuRepete('', #193, #196, 4) + CompletaOuRepete('', #193, #196,
          9) + CompletaOuRepete('', '', #196, 27) + CompletaOuRepete('', #193,
          #196, 11) + CompletaOuRepete('', #193, #196, 9) + CompletaOuRepete('',
          #180, #196, 11) + CRLF);
      end
      else
      begin
        addRelatorioForm19(CompletaOuRepete(#195, #193, #196, 8) +
          CompletaOuRepete('', #193, #196, 5) + CompletaOuRepete('', #193, #196,
          10) + CompletaOuRepete('', '', #196, 24) + CompletaOuRepete('', #193,
          #196, 11) + CompletaOuRepete('', #193, #196, 9) + CompletaOuRepete('',
          #180, #196, 11) + CRLF);
      end;

      if opcao = 1 then
      begin
        // form19.RichEdit1.Perform(EM_REPLACESEL, 1,
        // Longint(PChar((funcoes.CompletaOuRepete('|', '|', '-', tam) + CRLF))));
        addRelatorioForm19(funcoes.CompletaOuRepete(#179 +
          centraliza('* * * * *   R E I M P R E S S A O   * * * * *  USUARIO: '
          + form22.codusario + '-' + funcoes.BuscaNomeBD(dm.ibquery3, 'nome',
          'usuario', ' where cod = ' + form22.codusario), ' ', tam - 3), #179,
          ' ', tam) + CRLF);

        addRelatorioForm19(funcoes.CompletaOuRepete(#195, #180, #196,
          tam) + CRLF);
      end;

    end;

    if opcao <> 4 then
    begin

      form19.RichEdit1.Perform(EM_REPLACESEL, 1,
        Longint(PChar((funcoes.CompletaOuRepete(#179,
        funcoes.CompletaOuRepete('Sub-Total:', FormatCurr('#,###,###0.00',
        total), '.', 28) + ' ' + #179, ' ', tam) + #13 + #10))));

      desco := dm.IBselect.FieldByName('desconto').AsCurrency;
      if desco > 0 then
        desco := 0;
      form19.RichEdit1.Perform(EM_REPLACESEL, 1,
        Longint(PChar((funcoes.CompletaOuRepete(#179,
        funcoes.CompletaOuRepete('Desconto(' + FormatCurr('#,###,###0.00',
        (desco * 100) / total) + '%):', FormatCurr('#,###,###0.00', desco), '.',
        28) + ' ' + #179, ' ', tam) + #13 + #10))));
    end;

    if opcao = 1 then
    begin
      form19.RichEdit1.Perform(EM_REPLACESEL, 1,
        Longint(PChar((funcoes.CompletaOuRepete(#179 + ' Volumes: ' +
        funcoes.CompletaOuRepete('', FormatCurr('#,###,###0.00', sub), ' ', 9),
        funcoes.CompletaOuRepete('Total:', FormatCurr('#,###,###0.00',
        dm.IBselect.FieldByName('total').AsCurrency), '.', 28) + ' ' + #179,
        ' ', tam) + #13 + #10))));

      if (funcoes.LerConfig(form22.Pgerais.Values['configu'], 3) = 'S') and
        (txt <> '') then
      begin

        addRelatorioForm19(funcoes.CompletaOuRepete(#195, #180, #196,
          tam) + CRLF);

        form19.RichEdit1.Perform(EM_REPLACESEL, 1,
          Longint(PChar((funcoes.CompletaOuRepete(#179 + 'OBS: ' + txt, #179,
          ' ', tam) + #13 + #10))));

        try
          funcoes.atualizaMensagemUsuario(txt, numNota);
        except
        end;
      end;
      { else
        begin
        form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('+','+','-',80)+#13+#10))));
        form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('|' + txt,'|',' ',80)+#13+#10))));
        end;
      } end
    else if opcao = 2 then
    begin
      form19.RichEdit1.Perform(EM_REPLACESEL, 1,
        Longint(PChar((funcoes.CompletaOuRepete(#179 + ' Volumes: ' +
        funcoes.CompletaOuRepete('', FormatCurr('#,###,###0.00', sub), ' ', 9),
        funcoes.CompletaOuRepete('Total:', FormatCurr('#,###,###0.00',
        total + desco), '.', 28) + ' ' + #179, ' ', tam) + #13 + #10))));
      if (txt <> '') then
      begin

        addRelatorioForm19(funcoes.CompletaOuRepete(#195, #180, #196,
          tam) + CRLF);
        addRelatorioForm19(funcoes.CompletaOuRepete(#179 + ' ' + txt, #179, ' ',
          tam) + #13 + #10);
      end;
    end
    else
      form19.RichEdit1.Perform(EM_REPLACESEL, 1,
        Longint(PChar((funcoes.CompletaOuRepete(#179 + ' Volumes: ' +
        funcoes.CompletaOuRepete('', FormatCurr('#,###,###0.00', sub), ' ', 9),
        funcoes.CompletaOuRepete('Total:', FormatCurr('#,###,###0.00', total),
        '.', 28) + ' ' + #179, ' ', tam) + #13 + #10))));

    addRelatorioForm19(funcoes.CompletaOuRepete(#195, #180, #196, tam) + CRLF);



    form19.RichEdit1.Perform(EM_REPLACESEL, 1,
      Longint(PChar((#179 + ' Vendedor: ' + funcoes.CompletaOuRepete
      (copy(dm.IBselect.FieldByName('vendedor').AsString + '-' +
      BuscaNomeBD(dm.IBQuery1, 'nome', 'vendedor',
      'where cod=' + dm.IBselect.FieldByName('vendedor').AsString), 1, 16),
      #179, ' ', 17) + CompletaOuRepete('Recebido Por: ', #179, ' ', 49) + #13
      + #10))));


    if dm.IBselect.FieldByName('codhis').AsInteger = 2 then
    begin
      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.text :=
        'select vencimento as data from contasreceber where nota = :nota order by vencimento';
      dm.IBQuery1.ParamByName('nota').AsString :=
        dm.IBselect.FieldByName('nota').AsString;
      dm.IBQuery1.Open;

      form19.RichEdit1.Perform(EM_REPLACESEL, 1,
        Longint(PChar((#179 + ' Vencimento: ' +
        CompletaOuRepete(FormatDateTime('DD/MM/YY',
        dm.IBQuery1.FieldByName('data').AsDateTime), #179, ' ',
        15) + CompletaOuRepete('', #179, ' ', 49) + #13 + #10))));
      dm.IBQuery1.Close;
    end;

    addRelatorioForm19(funcoes.CompletaOuRepete(#192, #217, #196, tam) + CRLF);

    if opcao = 4 then
    begin
      funcoes.LimparEntregues(numNota);
    end;

    if EnviarImpressora = 'S' then
    begin
      imprime.textxArq('@', true);
    end
    else
    begin
      funcoes.CharSetRichEdit(form19.RichEdit1);
      form19.ShowModal;
    end;
  end;

  if ((tipo = 'M') or (tipo = 'ME')) then
  begin
    tam := 78;
    total := 0;
    dm.IBQuery2.Close;
    dm.IBQuery2.SQL.Clear;
    dm.IBQuery2.SQL.Add('select * from registro');
    dm.IBQuery2.Open;

    form19.RichEdit1.Perform(EM_REPLACESEL, 1,
      Longint(PChar((funcoes.CompletaOuRepete('', '', '-', tam) + CRLF))));
    addRelatorioForm19
      ('*  *    *    *    *   S E M    V A L O R    F I S C A L   *    *    *     *  *'
      + CRLF);

    form19.RichEdit1.Perform(EM_REPLACESEL, 1,
      Longint(PChar((funcoes.CompletaOuRepete('+', '+', '-', tam) + #13
      + #10))));

    if ((opcao = 1) or (opcao = 4)) then
    begin
      form19.RichEdit1.Perform(EM_REPLACESEL, 1,
        Longint(PChar((funcoes.CompletaOuRepete('| PEDIDO Nr:' +
        dm.IBselect.FieldByName('nota').AsString + '     PAGTO: ' +
        dm.IBselect.FieldByName('codhis').AsString + '-' +
        (BuscaNomeBD(dm.IBQuery1, 'nome', 'formpagto',
        'where cod=' + dm.IBselect.FieldByName('codhis').AsString)),
        'EMISSAO: ' + FormatDateTime('dd/mm/yy', dm.IBselect.FieldByName('data')
        .AsDateTime) + ' ' + FormatDateTime('hh:mm:ss',
        dm.IBselect.FieldByName('hora').AsDateTime) + ' |', ' ', tam) + #13
        + #10))));
    end
    else if opcao = 2 then
      form19.RichEdit1.Perform(EM_REPLACESEL, 1,
        Longint(PChar((funcoes.CompletaOuRepete('| ORCAMENTO Nr:' +
        dm.IBselect.FieldByName('nota').AsString + '     PAGTO: ' +
        dm.IBselect.FieldByName('codhis').AsString + '-' +
        (BuscaNomeBD(dm.IBQuery1, 'nome', 'formpagto',
        'where cod=' + dm.IBselect.FieldByName('codhis').AsString)),
        'EMISSAO: ' + dm.IBselect.FieldByName('data').AsString + ' |', ' ',
        tam) + #13 + #10))))
    else
      form19.RichEdit1.Perform(EM_REPLACESEL, 1,
        Longint(PChar((funcoes.CompletaOuRepete('| COMPRA Nr:' +
        dm.IBselect.FieldByName('nota').AsString + '     PAGTO: ' +
        dm.IBselect.FieldByName('codhis').AsString + '-' +
        (BuscaNomeBD(dm.IBQuery1, 'nome', 'formpagto',
        'where cod=' + dm.IBselect.FieldByName('codhis').AsString)),
        'EMISSAO: ' + dm.IBselect.FieldByName('data').AsString + ' |', ' ',
        tam) + #13 + #10))));

    form19.RichEdit1.Perform(EM_REPLACESEL, 1,
      Longint(PChar((funcoes.CompletaOuRepete('+', '+', '-', tam) + #13
      + #10))));
    form19.RichEdit1.Perform(EM_REPLACESEL, 1,
      Longint(PChar((funcoes.CompletaOuRepete('| ' + form22.Pgerais.Values
      ['empresa'], 'CNPJ: ' + dm.IBQuery2.FieldByName('cnpj').AsString + ' |',
      ' ', tam) + #13 + #10))));
    form19.RichEdit1.Perform(EM_REPLACESEL, 1,
      Longint(PChar((funcoes.CompletaOuRepete('| ' + dm.IBQuery2.FieldByName
      ('ende').AsString + '  - ' + dm.IBQuery2.FieldByName('bairro').AsString,
      '|', ' ', tam) + #13 + #10))));
    form19.RichEdit1.Perform(EM_REPLACESEL, 1,
      Longint(PChar((funcoes.CompletaOuRepete('| Fone: ' +
      dm.IBQuery2.FieldByName('telres').AsString + '  Cel: ' +
      dm.IBQuery2.FieldByName('telcom').AsString + '  ' +
      dm.IBQuery2.FieldByName('cid').AsString + ' - ' + dm.IBQuery2.FieldByName
      ('est').AsString, 'IE: ' + dm.IBQuery2.FieldByName('ies').AsString + ' |',
      ' ', tam) + #13 + #10))));
    form19.RichEdit1.Perform(EM_REPLACESEL, 1,
      Longint(PChar((funcoes.CompletaOuRepete('| Obs: ' +
      dm.IBQuery2.FieldByName('obs').AsString, '|', ' ', tam) + #13 + #10))));
    form19.RichEdit1.Perform(EM_REPLACESEL, 1,
      Longint(PChar((funcoes.CompletaOuRepete('+', '+', '-', tam) + #13
      + #10))));
    // addRelatorioForm19(funcoes.CompletaOuRepete(funcoes.CompletaOuRepete(copy('| Nome: '+ funcoes.BuscaNomeBD(dm.ibquery1,'nome','cliente','where cod=' + dm.IBselect.fieldbyname('cliente').AsString), 1, 38), '', ' ', 39) + funcoes.CompletaOuRepete('|CPF/CNPJ: ' + funcoes.BuscaNomeBD(dm.ibquery1,'cnpj','cliente','where cod=' + dm.IBselect.fieldbyname('cliente').AsString) , '', ' ', 37), '|',' ', tam) + #13 + #10);
    addRelatorioForm19(funcoes.CompletaOuRepete(funcoes.CompletaOuRepete
      (copy('| Cliente: ' + iif(ConfParamGerais.Strings[27] = 'N',
      dm.IBselect.FieldByName('cliente').AsString + '-',
      '') + funcoes.BuscaNomeBD(dm.IBQuery1, 'nome', 'cliente',
      'where cod=' + dm.IBselect.FieldByName('cliente').AsString), 1, 46), '',
      ' ', 46) + funcoes.CompletaOuRepete('|CPF/CNPJ: ' +
      funcoes.BuscaNomeBD(dm.IBQuery1, 'cnpj', 'cliente',
      'where cod=' + dm.IBselect.FieldByName('cliente').AsString), '', ' ', 29),
      '|', ' ', tam) + #13 + #10);

    dm.ibquery4.Close;
    dm.ibquery4.SQL.Clear;
    dm.ibquery4.SQL.Add
      ('select cod, nome, ende, bairro, cid, obs, iif(tipo = 1, cpf, cnpj) as cpf, cnpj, tipo, ies, tel,telres,telcom from cliente where cod = :cod');
    dm.ibquery4.ParamByName('cod').AsString :=
      dm.IBselect.FieldByName('cliente').AsString;
    dm.ibquery4.Open;

    if ((ConfParamGerais.Strings[27] = 'S') and
      (dm.ibquery4.FieldByName('ende').AsString <> '')) then
    begin
      { dm.IBQuery4.Close;
        dm.IBQuery4.SQL.Clear;
        dm.IBQuery4.SQL.Add('select cod, nome, ende, bairro, cid, obs, iif(tipo = 1, cpf, cnpj) as cpf, cnpj, tipo, ies, tel,telres,telcom from cliente where cod = :cod');
        dm.IBQuery4.ParamByName('cod').AsString := dm.IBselect.fieldbyname('cliente').AsString;
        dm.IBQuery4.Open; }

      addRelatorioForm19(funcoes.CompletaOuRepete
        (funcoes.CompletaOuRepete(copy('| End: ' + dm.ibquery4.FieldByName
        ('ende').AsString, 1, 46), '', ' ', 46) + funcoes.CompletaOuRepete
        ('|INSC. EST.: ' + LeftStr(dm.ibquery4.FieldByName('ies').AsString, 29),
        '', ' ', 29), '|', ' ', tam) + #13 + #10);
      addRelatorioForm19(funcoes.CompletaOuRepete
        (funcoes.CompletaOuRepete(copy('| Bairro: ' + dm.ibquery4.FieldByName
        ('bairro').AsString + ' - ' + dm.ibquery4.FieldByName('cid').AsString,
        1, 46), '', ' ', 46) + funcoes.CompletaOuRepete('|Codigo: ' +
        dm.ibquery4.FieldByName('cod').AsString, '', ' ', 29), '|', ' ', tam) +
        #13 + #10);

      if length(trim(dm.ibquery4.FieldByName('obs').AsString)) <= 39 then
      begin
        addRelatorioForm19
          (funcoes.CompletaOuRepete(funcoes.CompletaOuRepete(copy('| Obs: ' +
          dm.ibquery4.FieldByName('obs').AsString, 1, 46), '', ' ', 46) +
          funcoes.CompletaOuRepete('|Fone: ' + dm.ibquery4.FieldByName('telres')
          .AsString, '', ' ', 29), '|', ' ', tam) + #13 + #10);
      end
      else
      begin
        addRelatorioForm19
          (funcoes.CompletaOuRepete(funcoes.CompletaOuRepete('|', '', ' ',
          46) + funcoes.CompletaOuRepete('|Fone: ' + dm.ibquery4.FieldByName
          ('telres').AsString, '', ' ', 29), '|', ' ', tam) + #13 + #10);
        addRelatorioForm19(funcoes.CompletaOuRepete('| Obs: ' +
          dm.ibquery4.FieldByName('obs').AsString, '|', ' ', tam) + #13 + #10);
      end;
      dm.ibquery4.Close;
    end;

    dm.ibquery4.Close;

    form19.RichEdit1.Perform(EM_REPLACESEL, 1,
      Longint(PChar((funcoes.CompletaOuRepete('+', '+', '-', tam) + #13
      + #10))));

    if funcoes.buscaParamGeral(63, 'N') = 'S' then
    begin
      form19.RichEdit1.Perform(EM_REPLACESEL, 1,
        Longint(PChar
        (('|Cod. |Un |  Qtd.  |   Descricao das Mercadorias         |  Unit. |  Total   |'
        + #13 + #10))));
      form19.RichEdit1.Perform(EM_REPLACESEL, 1,
        Longint(PChar
        (('+-----+---+--------+-------------------------------------+--------+----------+'
        + #13 + #10))));
    end
    else
    begin
      form19.RichEdit1.Perform(EM_REPLACESEL, 1,
        Longint(PChar
        (('|Codigo|Unid|   Qtd.    |  Descricao das Mercadorias     |Unitario|   Total  |'
        + #13 + #10))));
      form19.RichEdit1.Perform(EM_REPLACESEL, 1,
        Longint(PChar
        (('+------+----+-----------+--------------------------------+--------+----------+'
        + #13 + #10))));
    end;
    { form19.RichEdit1.Perform(EM_REPLACESEL, 1,
      Longint(PChar
      (('|Codigo| Unid |  Qtd.   |  Descricao das Mercadorias     |Unitario|   Total  |'
      + CRLF))));
      form19.RichEdit1.Perform(EM_REPLACESEL, 1,
      Longint(PChar
      (('+------+------+---------+--------------------------------+--------+----------+'
      + CRLF)))); }

    dm.IBQuery2.Close;
    dm.IBQuery2.SQL.Clear;

    if opcao = 1 then
      dm.IBQuery2.SQL.Add
        ('select cod,p_venda, total, quant, nome from item_venda where nota='
        + numNota)
    else if opcao = 2 then
      dm.IBQuery2.SQL.Add('select * from item_orcamento where nota=' + numNota)
    else if opcao = 3 then
      dm.IBQuery2.SQL.Add('select * from item_compra where nota=' + numNota)
    else if opcao = 4 then
    begin
      dm.IBQuery2.SQL.Add
        ('select e.cod, i.p_venda, i.total, iif(char_length(i.nome) = 0, p.nome, i.nome) as nome, '
        + 'e.quant, p.codbar, p.refori, p.localiza  from CONT_ENTREGA e left join '
        + 'item_venda i on (i.nota = e.nota and i.cod = e.cod) left join produto p on (i.cod = p.cod) '
        + 'where e.ENT_AGORA = ''X'' and e.nota = ' + numNota);
    end;

    dm.IBQuery2.Open;
    dm.IBQuery2.First;
    sub := 0;
    total := 0;
    while not dm.IBQuery2.Eof do
    begin
      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add
        ('select unid, P_VENDA, P_COMPRA,  codbar, nome, localiza, refori from produto where cod='
        + dm.IBQuery2.FieldByName('cod').AsString);
      dm.IBQuery1.Open;

      sub := sub + dm.IBQuery2.FieldByName('quant').AsCurrency;

      if ((opcao = 1) or (opcao = 4)) then
      begin
        nome := trim(dm.IBQuery2.FieldByName('nome').AsString);
        if nome = '' then
          nome := dm.IBQuery1.FieldByName('nome').AsString;
        nome := trim(nome);

        if funcoes.buscaParamGeral(63, 'N') = 'S' then
        begin
          form19.RichEdit1.Perform(EM_REPLACESEL, 1,
            Longint(PChar(('|' + funcoes.CompletaOuRepete('',
            dm.IBQuery2.FieldByName('cod').AsString + '|', ' ',
            6) + funcoes.CompletaOuRepete('',
            LeftStr(dm.IBQuery1.FieldByName('unid').AsString, 3) + '|', ' ',
            4) + funcoes.CompletaOuRepete('', FormatCurr('0.00',
            dm.IBQuery2.FieldByName('quant').AsCurrency) + '|', ' ',
            9) + funcoes.CompletaOuRepete(copy(nome, 1, 37), '|', ' ',
            38) + funcoes.CompletaOuRepete('', FormatCurr('0.00',
            dm.IBQuery2.FieldByName('p_venda').AsCurrency) + '|', ' ',
            9) + funcoes.CompletaOuRepete('', FormatCurr('0.00',
            dm.IBQuery2.FieldByName('total').AsCurrency) + '|', ' ', 11) + #13
            + #10))));
        end
        else
        begin
          addRelatorioForm19('|' + funcoes.CompletaOuRepete('',
            dm.IBQuery2.FieldByName('cod').AsString + '|', ' ', 7) +
            funcoes.CompletaOuRepete('', dm.IBQuery1.FieldByName('unid')
            .AsString + '|', ' ', 7) + funcoes.CompletaOuRepete('',
            FormatCurr('#,###,###0.00', dm.IBQuery2.FieldByName('quant')
            .AsCurrency) + '|', ' ', 10) + funcoes.CompletaOuRepete(copy(nome,
            1, 30), '|', ' ', 33) + funcoes.CompletaOuRepete('',
            FormatCurr('0.00', dm.IBQuery2.FieldByName('p_venda').AsCurrency) +
            '|', ' ', 9) + funcoes.CompletaOuRepete('', FormatCurr('0.00',
            dm.IBQuery2.FieldByName('total').AsCurrency) + '|', ' ',
            11) + CRLF);
        end;
        total := total + dm.IBQuery2.FieldByName('total').AsCurrency;
      end
      else if opcao = 2 then
      begin
        nome := trim(dm.IBQuery2.FieldByName('nome').AsString);
        if nome = '' then
          nome := dm.IBQuery1.FieldByName('nome').AsString;
        nome := trim(nome);

        if funcoes.buscaParamGeral(63, 'N') = 'S' then
        begin
          form19.RichEdit1.Perform(EM_REPLACESEL, 1,
            Longint(PChar(('|' + funcoes.CompletaOuRepete('',
            dm.IBQuery2.FieldByName('cod').AsString + '|', ' ',
            6) + funcoes.CompletaOuRepete('',
            LeftStr(dm.IBQuery1.FieldByName('unid').AsString, 3) + '|', ' ',
            4) + funcoes.CompletaOuRepete('', FormatCurr('0.00',
            dm.IBQuery2.FieldByName('quant').AsCurrency) + '|', ' ',
            9) + funcoes.CompletaOuRepete(copy(nome, 1, 37), '|', ' ',
            38) + funcoes.CompletaOuRepete('', FormatCurr('0.00',
            dm.IBQuery2.FieldByName('p_venda').AsCurrency) + '|', ' ',
            9) + funcoes.CompletaOuRepete('', FormatCurr('0.00',
            dm.IBQuery2.FieldByName('total').AsCurrency) + '|', ' ', 11) + #13
            + #10))));
        end
        else
        begin
          addRelatorioForm19('|' + funcoes.CompletaOuRepete('',
            dm.IBQuery2.FieldByName('cod').AsString + '|', ' ', 7) +
            funcoes.CompletaOuRepete('', LeftStr(dm.IBQuery1.FieldByName('unid')
            .AsString, 4) + '|', ' ', 5) + funcoes.CompletaOuRepete('',
            FormatCurr('0.00', dm.IBQuery2.FieldByName('quant').AsCurrency) +
            '|', ' ', 10) + funcoes.CompletaOuRepete
            (copy(dm.IBQuery1.FieldByName('nome').AsString, 1, 34), '|', ' ',
            35) + funcoes.CompletaOuRepete('', FormatCurr('0.00',
            dm.IBQuery2.FieldByName('p_venda').AsCurrency) + '|', ' ', 9) +
            funcoes.CompletaOuRepete('', FormatCurr('0.00',
            dm.IBQuery2.FieldByName('total').AsCurrency) + '|', ' ',
            11) + CRLF);
        end;
        total := total + dm.IBQuery2.FieldByName('total').AsCurrency;
      end
      else
      begin
        addRelatorioForm19('|' + funcoes.CompletaOuRepete('',
          dm.IBQuery2.FieldByName('cod').AsString + '|', ' ', 7) +
          funcoes.CompletaOuRepete('', dm.IBQuery1.FieldByName('unid').AsString
          + '|', ' ', 7) + funcoes.CompletaOuRepete('',
          FormatCurr('#,###,###0.000', dm.IBQuery2.FieldByName('quant')
          .AsCurrency) + '|', ' ', 8) + funcoes.CompletaOuRepete
          (copy(dm.IBQuery1.FieldByName('nome').AsString, 1, 34), '|', ' ', 35)
          + funcoes.CompletaOuRepete('', FormatCurr('0.00',
          dm.IBQuery1.FieldByName('p_COMPRA').AsCurrency) + '|', ' ', 9) +
          funcoes.CompletaOuRepete('', FormatCurr('0.00',
          Arredonda(dm.IBQuery1.FieldByName('p_COMPRA').AsCurrency *
          dm.IBQuery2.FieldByName('quant').AsCurrency, 2)) + '|', ' ',
          11) + CRLF);
        total := total + Arredonda(dm.IBQuery1.FieldByName('p_compra')
          .AsCurrency * dm.IBQuery2.FieldByName('quant').AsCurrency, 2);
      end;

      dm.IBQuery2.Next;
    end;

    dm.IBQuery1.Close;
    if opcao = 1 then
    begin
      if funcoes.ExisteParcelamento(numNota) and (opcao = 1) and
        (ConfParamGerais.Strings[20] = 'S') then
      begin
        form19.RichEdit1.Perform(EM_REPLACESEL, 1,
          Longint(PChar
          (('|      |      |         |                                |        |          |'
          + CRLF))));
        funcoes.ImprimeParcelamento('|      |      |         |  ',
          '    |        |          |', FormatCurr('#,###,###0.00',
          entrada), numNota);
      end;
    end;

    if opcao = 4 then
    begin
      addRelatorioForm19(funcoes.CompletaOuRepete('|', '|', '-', tam) + CRLF);
      addRelatorioForm19(funcoes.CompletaOuRepete('|' +
        centraliza
        ('* * * * *   E N T R E G A  D E  P R O D U T O S   * * * * *  ', ' ',
        tam - 3), '|', ' ', tam) + CRLF);
      addRelatorioForm19(funcoes.CompletaOuRepete('|', '|', '-', tam) + CRLF);
    end;

    if opcao = 1 then
    begin
      if tipo = 'M' then
      begin
        form19.RichEdit1.Perform(EM_REPLACESEL, 1,
          Longint(PChar((funcoes.CompletaOuRepete('|', '|', '-',
          tam) + CRLF))));
        addRelatorioForm19(funcoes.CompletaOuRepete('|' +
          centraliza('* * * * *   R E I M P R E S S A O   * * * * *  USUARIO: '
          + form22.codusario + '-' + funcoes.BuscaNomeBD(dm.ibquery3, 'nome',
          'usuario', ' where cod = ' + form22.codusario), ' ', tam - 3), '|',
          ' ', tam) + CRLF);
      end;

    end;

    if opcao <> 4 then
    begin
      form19.RichEdit1.Perform(EM_REPLACESEL, 1,
        Longint(PChar((funcoes.CompletaOuRepete('+', '+', '-', tam) + #13
        + #10))));
      form19.RichEdit1.Perform(EM_REPLACESEL, 1,
        Longint(PChar((funcoes.CompletaOuRepete('|',
        funcoes.CompletaOuRepete('Sub-Total:', FormatCurr('#,###,###0.00',
        total), '.', 28) + ' |', ' ', tam) + #13 + #10))));
      desco := dm.IBselect.FieldByName('desconto').AsCurrency;
      if desco > 0 then
        desco := 0;


      if desco <> 0 then begin
      form19.RichEdit1.Perform(EM_REPLACESEL, 1,
        Longint(PChar((funcoes.CompletaOuRepete('|',
        funcoes.CompletaOuRepete('Desconto(' + FormatCurr('#,###,###0.00',
        (desco * 100) / total) + '%):', FormatCurr('#,###,###0.00', desco), '.',
        28) + ' |', ' ', tam) + #13 + #10))));
      end;
    end;

    if opcao = 1 then
    begin
      form19.RichEdit1.Perform(EM_REPLACESEL, 1,
        Longint(PChar((funcoes.CompletaOuRepete('| Volumes: ' +
        funcoes.CompletaOuRepete('', FormatCurr('#,###,###0.00', sub), ' ', 9),
        funcoes.CompletaOuRepete('Total:', FormatCurr('#,###,###0.00',
        dm.IBselect.FieldByName('total').AsCurrency), '.', 28) + ' |', ' ',
        tam) + #13 + #10))));
      if (funcoes.LerConfig(form22.Pgerais.Values['configu'], 3) = 'S') and
        (txt <> '') then
      begin
        form19.RichEdit1.Perform(EM_REPLACESEL, 1,
          Longint(PChar((funcoes.CompletaOuRepete('+', '+', '-', tam) + #13
          + #10))));
        form19.RichEdit1.Perform(EM_REPLACESEL, 1,
          Longint(PChar((funcoes.CompletaOuRepete('|OBS: ' + txt, '|', ' ',
          tam) + #13 + #10))));

        try
          funcoes.atualizaMensagemUsuario(txt, numNota);
        except
        end;
      end;
       end
    else if opcao = 2 then
    begin
      form19.RichEdit1.Perform(EM_REPLACESEL, 1,
        Longint(PChar((funcoes.CompletaOuRepete('| Volumes: ' +
        funcoes.CompletaOuRepete('', FormatCurr('#,###,###0.00', sub), ' ', 9),
        funcoes.CompletaOuRepete('Total:', FormatCurr('#,###,###0.00',
        total + desco), '.', 28) + ' |', ' ', tam) + #13 + #10))));
      if (txt <> '') then
      begin
        form19.RichEdit1.Perform(EM_REPLACESEL, 1,
          Longint(PChar((funcoes.CompletaOuRepete('+', '+', '-', tam) + #13
          + #10))));
        form19.RichEdit1.Perform(EM_REPLACESEL, 1,
          Longint(PChar((funcoes.CompletaOuRepete('| ' + txt, '|', ' ',
          tam) + #13 + #10))));
      end;
    end
    else
      form19.RichEdit1.Perform(EM_REPLACESEL, 1,
        Longint(PChar((funcoes.CompletaOuRepete('| Volumes: ' +
        funcoes.CompletaOuRepete('', FormatCurr('#,###,###0.00', sub), ' ', 9),
        funcoes.CompletaOuRepete('Total:', FormatCurr('#,###,###0.00', total),
        '.', 28) + ' |', ' ', tam) + #13 + #10))));

    form19.RichEdit1.Perform(EM_REPLACESEL, 1,
      Longint(PChar((funcoes.CompletaOuRepete('+', '+', '-', tam) + #13
      + #10))));
    form19.RichEdit1.Perform(EM_REPLACESEL, 1,
      Longint(PChar(('| Vendedor: ' + funcoes.CompletaOuRepete
      (copy(dm.IBselect.FieldByName('vendedor').AsString + '-' +
      BuscaNomeBD(dm.IBQuery1, 'nome', 'vendedor',
      'where cod=' + dm.IBselect.FieldByName('vendedor').AsString), 1, 16), '|',
      ' ', 17) + CompletaOuRepete('Recebido Por: ', '|', ' ', 49) + #13
      + #10))));

    if dm.IBselect.FieldByName('codhis').AsInteger = 2 then
    begin
      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.text :=
        'select vencimento as data from contasreceber where nota = :nota order by vencimento';
      dm.IBQuery1.ParamByName('nota').AsString :=
        dm.IBselect.FieldByName('nota').AsString;
      dm.IBQuery1.Open;

      form19.RichEdit1.Perform(EM_REPLACESEL, 1,
        Longint(PChar(('| Vencimento: ' + CompletaOuRepete(FormatDateTime
        ('DD/MM/YY', dm.IBQuery1.FieldByName('data').AsDateTime), '|', ' ',
        15) + CompletaOuRepete('', '|', ' ', 49) + #13 + #10))));
      dm.IBQuery1.Close;
    end;
    form19.RichEdit1.Perform(EM_REPLACESEL, 1,
      Longint(PChar((funcoes.CompletaOuRepete('+', '+', '-', tam) + #13
      + #10))));

    if opcao = 1 then
    begin
      if funcoes.buscaParamGeral(88, 'N') = 'S' then
      begin
        addRelatorioForm19(' ' + CRLF);
        addRelatorioForm19(' ' + CRLF);
        GeraNota(numNota, 'DX', 'N', opcao);
      end;
    end;

    if opcao = 4 then
    begin
      funcoes.LimparEntregues(numNota);
    end;

    if EnviarImpressora = 'S' then
    begin
      imprime.textx('texto.txt');
    end
    else
      form19.ShowModal;
  end;

  if tipo = 'V' then
  begin
    tam := 78;
    total := 0;
    dm.IBQuery2.Close;
    dm.IBQuery2.SQL.Clear;
    dm.IBQuery2.SQL.Add('select * from registro');
    dm.IBQuery2.Open;

    form19.RichEdit1.Perform(EM_REPLACESEL, 1,
      Longint(PChar((funcoes.CompletaOuRepete('+', '+', '-', tam) + #13
      + #10))));

    if opcao = 1 then
      form19.RichEdit1.Perform(EM_REPLACESEL, 1,
        Longint(PChar((funcoes.CompletaOuRepete('| PEDIDO Nr:' +
        dm.IBselect.FieldByName('nota').AsString + '     PAGTO: ' +
        dm.IBselect.FieldByName('codhis').AsString + '-' +
        (BuscaNomeBD(dm.IBQuery1, 'nome', 'formpagto',
        'where cod=' + dm.IBselect.FieldByName('codhis').AsString)),
        'EMISSAO: ' + FormatDateTime('dd/mm/yy', dm.IBselect.FieldByName('data')
        .AsDateTime) + ' ' + FormatDateTime('hh:mm:ss',
        dm.IBselect.FieldByName('hora').AsDateTime) + ' |', ' ',
        tam) + #13 + #10))))
    else if opcao = 2 then
      form19.RichEdit1.Perform(EM_REPLACESEL, 1,
        Longint(PChar((funcoes.CompletaOuRepete('| ORCAMENTO Nr:' +
        dm.IBselect.FieldByName('nota').AsString + '     PAGTO: ' +
        dm.IBselect.FieldByName('codhis').AsString + '-' +
        (BuscaNomeBD(dm.IBQuery1, 'nome', 'formpagto',
        'where cod=' + dm.IBselect.FieldByName('codhis').AsString)),
        'EMISSAO: ' + dm.IBselect.FieldByName('data').AsString + ' |', ' ',
        tam) + #13 + #10))))
    else
      form19.RichEdit1.Perform(EM_REPLACESEL, 1,
        Longint(PChar((funcoes.CompletaOuRepete('| COMPRA Nr:' +
        dm.IBselect.FieldByName('nota').AsString + '     PAGTO: ' +
        dm.IBselect.FieldByName('codhis').AsString + '-' +
        (BuscaNomeBD(dm.IBQuery1, 'nome', 'formpagto',
        'where cod=' + dm.IBselect.FieldByName('codhis').AsString)),
        'EMISSAO: ' + dm.IBselect.FieldByName('data').AsString + ' |', ' ',
        tam) + #13 + #10))));

    form19.RichEdit1.Perform(EM_REPLACESEL, 1,
      Longint(PChar((funcoes.CompletaOuRepete('+', '+', '-', tam) + #13
      + #10))));
    form19.RichEdit1.Perform(EM_REPLACESEL, 1,
      Longint(PChar((funcoes.CompletaOuRepete('| ' + form22.Pgerais.Values
      ['empresa'], 'CNPJ: ' + dm.IBQuery2.FieldByName('cnpj').AsString + ' |',
      ' ', tam) + #13 + #10))));
    form19.RichEdit1.Perform(EM_REPLACESEL, 1,
      Longint(PChar((funcoes.CompletaOuRepete('| ' + dm.IBQuery2.FieldByName
      ('ende').AsString + '  - ' + dm.IBQuery2.FieldByName('bairro').AsString,
      '|', ' ', tam) + #13 + #10))));
    form19.RichEdit1.Perform(EM_REPLACESEL, 1,
      Longint(PChar((funcoes.CompletaOuRepete('| Fone: ' +
      dm.IBQuery2.FieldByName('telres').AsString + '  Cel: ' +
      dm.IBQuery2.FieldByName('telcom').AsString + '  ' +
      dm.IBQuery2.FieldByName('cid').AsString + ' - ' + dm.IBQuery2.FieldByName
      ('est').AsString, 'IE: ' + dm.IBQuery2.FieldByName('ies').AsString + ' |',
      ' ', tam) + #13 + #10))));
    form19.RichEdit1.Perform(EM_REPLACESEL, 1,
      Longint(PChar((funcoes.CompletaOuRepete('| Obs: ' +
      dm.IBQuery2.FieldByName('obs').AsString, '|', ' ', tam) + #13 + #10))));
    form19.RichEdit1.Perform(EM_REPLACESEL, 1,
      Longint(PChar((funcoes.CompletaOuRepete('+', '+', '-', tam) + #13
      + #10))));
    // addRelatorioForm19(funcoes.CompletaOuRepete(funcoes.CompletaOuRepete(copy('| Nome: '+ funcoes.BuscaNomeBD(dm.ibquery1,'nome','cliente','where cod=' + dm.IBselect.fieldbyname('cliente').AsString), 1, 38), '', ' ', 39) + funcoes.CompletaOuRepete('|CPF/CNPJ: ' + funcoes.BuscaNomeBD(dm.ibquery1,'cnpj','cliente','where cod=' + dm.IBselect.fieldbyname('cliente').AsString) , '', ' ', 37), '|',' ', tam) + #13 + #10);
    addRelatorioForm19(funcoes.CompletaOuRepete(funcoes.CompletaOuRepete
      (copy('| Cliente: ' + iif(ConfParamGerais.Strings[27] = 'N',
      dm.IBselect.FieldByName('cliente').AsString + '-',
      '') + funcoes.BuscaNomeBD(dm.IBQuery1, 'nome', 'cliente',
      'where cod=' + dm.IBselect.FieldByName('cliente').AsString), 1, 46), '',
      ' ', 46) + funcoes.CompletaOuRepete('|CPF/CNPJ: ' +
      funcoes.BuscaNomeBD(dm.IBQuery1, 'cnpj', 'cliente',
      'where cod=' + dm.IBselect.FieldByName('cliente').AsString), '', ' ', 29),
      '|', ' ', tam) + #13 + #10);

    dm.ibquery4.Close;
    dm.ibquery4.SQL.Clear;
    dm.ibquery4.SQL.Add
      ('select cod, nome, ende, bairro, cid, obs, iif(tipo = 1, cpf, cnpj) as cpf, cnpj, tipo, ies, tel,telres,telcom from cliente where cod = :cod');
    dm.ibquery4.ParamByName('cod').AsString :=
      dm.IBselect.FieldByName('cliente').AsString;
    dm.ibquery4.Open;

    if ((ConfParamGerais.Strings[27] = 'S') and
      (dm.ibquery4.FieldByName('ende').AsString <> '')) then
    begin
      { dm.IBQuery4.Close;
        dm.IBQuery4.SQL.Clear;
        dm.IBQuery4.SQL.Add('select cod, nome, ende, bairro, cid, obs, iif(tipo = 1, cpf, cnpj) as cpf, cnpj, tipo, ies, tel,telres,telcom from cliente where cod = :cod');
        dm.IBQuery4.ParamByName('cod').AsString := dm.IBselect.fieldbyname('cliente').AsString;
        dm.IBQuery4.Open; }

      addRelatorioForm19(funcoes.CompletaOuRepete
        (funcoes.CompletaOuRepete(copy('| End: ' + dm.ibquery4.FieldByName
        ('ende').AsString, 1, 46), '', ' ', 46) + funcoes.CompletaOuRepete
        ('|INSC. EST.: ' + LeftStr(dm.ibquery4.FieldByName('ies').AsString, 29),
        '', ' ', 29), '|', ' ', tam) + #13 + #10);
      addRelatorioForm19(funcoes.CompletaOuRepete
        (funcoes.CompletaOuRepete(copy('| Bairro: ' + dm.ibquery4.FieldByName
        ('bairro').AsString + ' - ' + dm.ibquery4.FieldByName('cid').AsString,
        1, 46), '', ' ', 46) + funcoes.CompletaOuRepete('|Codigo: ' +
        dm.ibquery4.FieldByName('cod').AsString, '', ' ', 29), '|', ' ', tam) +
        #13 + #10);
      addRelatorioForm19(funcoes.CompletaOuRepete
        (funcoes.CompletaOuRepete(copy('| Obs: ' + dm.ibquery4.FieldByName
        ('obs').AsString, 1, 46), '', ' ', 46) + funcoes.CompletaOuRepete
        ('|Fone: ' + dm.ibquery4.FieldByName('telres').AsString, '', ' ', 29),
        '|', ' ', tam) + #13 + #10);
      { addRelatorioForm19(funcoes.CompletaOuRepete(funcoes.CompletaOuRepete(copy('| Endereco: ' + dm.IBQuery4.fieldbyname('ende').AsString,1, 38), '', ' ', 39) + funcoes.CompletaOuRepete('|INSC. EST.: ' + dm.IBQuery4.fieldbyname('ies').AsString , '', ' ', 37), '|',' ', tam) + #13 + #10);
        addRelatorioForm19(funcoes.CompletaOuRepete(funcoes.CompletaOuRepete(copy('| Bairro: ' + dm.IBQuery4.fieldbyname('bairro').AsString + ' - ' + dm.IBQuery4.fieldbyname('cid').AsString, 1, 38), '', ' ', 39) + funcoes.CompletaOuRepete('|Codigo: ' + dm.IBQuery4.fieldbyname('cod').AsString , '', ' ', 37),'|',' ', tam) + #13 + #10);
        addRelatorioForm19(funcoes.CompletaOuRepete(funcoes.CompletaOuRepete(copy('| Obs: ' + dm.IBQuery4.fieldbyname('obs').AsString, 1, 38) , '', ' ', 39) + funcoes.CompletaOuRepete('|Fone: ' + dm.IBQuery4.fieldbyname('telres').AsString , '', ' ', 37),'|',' ', tam) + #13 + #10); }
      dm.ibquery4.Close;
    end;

    dm.ibquery4.Close;

    form19.RichEdit1.Perform(EM_REPLACESEL, 1,
      Longint(PChar((funcoes.CompletaOuRepete('+', '+', '-', tam) + #13
      + #10))));
    form19.RichEdit1.Perform(EM_REPLACESEL, 1,
      Longint(PChar
      (('|Codigo| Unid |  Qtd.   |  Descricao das Mercadorias     |Unitario|   Total  |'
      + CRLF))));
    form19.RichEdit1.Perform(EM_REPLACESEL, 1,
      Longint(PChar
      (('+------+------+---------+--------------------------------+--------+----------+'
      + CRLF))));

    dm.IBQuery2.Close;
    dm.IBQuery2.SQL.Clear;

    if opcao = 1 then
      dm.IBQuery2.SQL.Add
        ('select cod,p_venda, total, quant, nome from item_venda where nota='
        + numNota)
    else if opcao = 2 then
      dm.IBQuery2.SQL.Add('select * from item_orcamento where nota=' + numNota)
    else
      dm.IBQuery2.SQL.Add('select * from item_compra where nota=' + numNota);

    dm.IBQuery2.Open;
    dm.IBQuery2.First;
    sub := 0;
    total := 0;
    while not dm.IBQuery2.Eof do
    begin
      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add
        ('select unid, P_VENDA, P_COMPRA,  codbar, nome, localiza, refori from produto where cod='
        + dm.IBQuery2.FieldByName('cod').AsString);
      dm.IBQuery1.Open;

      sub := sub + dm.IBQuery2.FieldByName('quant').AsCurrency;

      if opcao = 1 then
      begin
        nome := trim(dm.IBQuery2.FieldByName('nome').AsString);
        if nome = '' then
          nome := dm.IBQuery1.FieldByName('nome').AsString;

        addRelatorioForm19('|' + funcoes.CompletaOuRepete('',
          dm.IBQuery2.FieldByName('cod').AsString + '|', ' ', 7) +
          funcoes.CompletaOuRepete('', dm.IBQuery1.FieldByName('unid').AsString
          + '|', ' ', 7) + funcoes.CompletaOuRepete('',
          FormatCurr('#,###,###0.00', dm.IBQuery2.FieldByName('quant')
          .AsCurrency) + '|', ' ', 10) + funcoes.CompletaOuRepete(copy(nome, 1,
          30), '|', ' ', 33) + funcoes.CompletaOuRepete('', FormatCurr('0.00',
          dm.IBQuery2.FieldByName('p_venda').AsCurrency) + '|', ' ', 9) +
          funcoes.CompletaOuRepete('', FormatCurr('0.00',
          dm.IBQuery2.FieldByName('total').AsCurrency) + '|', ' ', 11) + CRLF);
        total := total + dm.IBQuery2.FieldByName('total').AsCurrency;
      end
      else if opcao = 2 then
      begin
        addRelatorioForm19('|' + funcoes.CompletaOuRepete('',
          dm.IBQuery2.FieldByName('cod').AsString + '|', ' ', 7) +
          funcoes.CompletaOuRepete('', dm.IBQuery1.FieldByName('unid').AsString
          + '|', ' ', 7) + funcoes.CompletaOuRepete('',
          FormatCurr('#,###,###0.000', dm.IBQuery2.FieldByName('quant')
          .AsCurrency) + '|', ' ', 8) + funcoes.CompletaOuRepete
          (copy(dm.IBQuery1.FieldByName('nome').AsString, 1, 34), '|', ' ', 35)
          + funcoes.CompletaOuRepete('', FormatCurr('0.00',
          dm.IBQuery2.FieldByName('p_venda').AsCurrency) + '|', ' ', 9) +
          funcoes.CompletaOuRepete('', FormatCurr('0.00',
          dm.IBQuery2.FieldByName('total').AsCurrency) + '|', ' ', 11) + CRLF);
        total := total + dm.IBQuery2.FieldByName('total').AsCurrency;
      end
      else
      begin
        addRelatorioForm19('|' + funcoes.CompletaOuRepete('',
          dm.IBQuery2.FieldByName('cod').AsString + '|', ' ', 7) +
          funcoes.CompletaOuRepete('', dm.IBQuery1.FieldByName('unid').AsString
          + '|', ' ', 7) + funcoes.CompletaOuRepete('',
          FormatCurr('#,###,###0.000', dm.IBQuery2.FieldByName('quant')
          .AsCurrency) + '|', ' ', 8) + funcoes.CompletaOuRepete
          (copy(dm.IBQuery1.FieldByName('nome').AsString, 1, 34), '|', ' ', 35)
          + funcoes.CompletaOuRepete('', FormatCurr('0.00',
          dm.IBQuery1.FieldByName('p_COMPRA').AsCurrency) + '|', ' ', 9) +
          funcoes.CompletaOuRepete('', FormatCurr('0.00',
          Arredonda(dm.IBQuery1.FieldByName('p_COMPRA').AsCurrency *
          dm.IBQuery2.FieldByName('quant').AsCurrency, 2)) + '|', ' ',
          11) + CRLF);
        total := total + Arredonda(dm.IBQuery1.FieldByName('p_compra')
          .AsCurrency * dm.IBQuery2.FieldByName('quant').AsCurrency, 2);
      end;

      dm.IBQuery2.Next;
    end;

    dm.IBQuery1.Close;
    if opcao = 1 then
    begin
      if funcoes.ExisteParcelamento(numNota) and (opcao = 1) and
        (ConfParamGerais.Strings[20] = 'S') then
      begin
        form19.RichEdit1.Perform(EM_REPLACESEL, 1,
          Longint(PChar
          (('|      |      |         |                                |        |          |'
          + CRLF))));
        funcoes.ImprimeParcelamento('|      |      |         |  ',
          '    |        |          |', FormatCurr('#,###,###0.00',
          entrada), numNota);
      end;
    end;

    if opcao = 1 then
    begin
      form19.RichEdit1.Perform(EM_REPLACESEL, 1,
        Longint(PChar((funcoes.CompletaOuRepete('|', '|', '-', tam) + CRLF))));
      addRelatorioForm19(funcoes.CompletaOuRepete('|' +
        centraliza('* * * * *   R E I M P R E S S A O   * * * * *  USUARIO: ' +
        form22.codusario + '-' + funcoes.BuscaNomeBD(dm.ibquery3, 'nome',
        'usuario', ' where cod = ' + form22.codusario), ' ', tam - 3), '|', ' ',
        tam) + CRLF);
    end;

    form19.RichEdit1.Perform(EM_REPLACESEL, 1,
      Longint(PChar((funcoes.CompletaOuRepete('+', '+', '-', tam) + #13
      + #10))));
    form19.RichEdit1.Perform(EM_REPLACESEL, 1,
      Longint(PChar((funcoes.CompletaOuRepete('|',
      funcoes.CompletaOuRepete('Sub-Total:', FormatCurr('#,###,###0.00', total),
      '.', 28) + ' |', ' ', tam) + #13 + #10))));
    desco := dm.IBselect.FieldByName('desconto').AsCurrency;
    if desco > 0 then
      desco := 0;
    form19.RichEdit1.Perform(EM_REPLACESEL, 1,
      Longint(PChar((funcoes.CompletaOuRepete('|',
      funcoes.CompletaOuRepete('Desconto(' + FormatCurr('#,###,###0.00',
      (desco * 100) / total) + '%):', FormatCurr('#,###,###0.00', desco), '.',
      28) + ' |', ' ', tam) + #13 + #10))));

    if opcao = 1 then
    begin
      form19.RichEdit1.Perform(EM_REPLACESEL, 1,
        Longint(PChar((funcoes.CompletaOuRepete('| Volumes: ' +
        funcoes.CompletaOuRepete('', FormatCurr('#,###,###0.00', sub), ' ', 9),
        funcoes.CompletaOuRepete('Total:', FormatCurr('#,###,###0.00',
        dm.IBselect.FieldByName('total').AsCurrency), '.', 28) + ' |', ' ',
        tam) + #13 + #10))));
      if (funcoes.LerConfig(form22.Pgerais.Values['configu'], 3) = 'S') and
        (txt <> '') then
      begin
        form19.RichEdit1.Perform(EM_REPLACESEL, 1,
          Longint(PChar((funcoes.CompletaOuRepete('+', '+', '-', tam) + #13
          + #10))));
        form19.RichEdit1.Perform(EM_REPLACESEL, 1,
          Longint(PChar((funcoes.CompletaOuRepete('|OBS: ' + txt, '|', ' ',
          tam) + #13 + #10))));
        try
          funcoes.atualizaMensagemUsuario(txt, numNota);
        except
        end;
      end;
      { else
        begin
        form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('+','+','-',80)+#13+#10))));
        form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('|' + txt,'|',' ',80)+#13+#10))));
        end;
      } end
    else if opcao = 2 then
      form19.RichEdit1.Perform(EM_REPLACESEL, 1,
        Longint(PChar((funcoes.CompletaOuRepete('| Volumes: ' +
        funcoes.CompletaOuRepete('', FormatCurr('#,###,###0.00', sub), ' ', 9),
        funcoes.CompletaOuRepete('Total:', FormatCurr('#,###,###0.00', total),
        '.', 28) + ' |', ' ', tam) + #13 + #10))))
    else
      form19.RichEdit1.Perform(EM_REPLACESEL, 1,
        Longint(PChar((funcoes.CompletaOuRepete('| Volumes: ' +
        funcoes.CompletaOuRepete('', FormatCurr('#,###,###0.00', sub), ' ', 9),
        funcoes.CompletaOuRepete('Total:', FormatCurr('#,###,###0.00', total),
        '.', 28) + ' |', ' ', tam) + #13 + #10))));

    form19.RichEdit1.Perform(EM_REPLACESEL, 1,
      Longint(PChar((funcoes.CompletaOuRepete('+', '+', '-', tam) + #13
      + #10))));
    form19.RichEdit1.Perform(EM_REPLACESEL, 1,
      Longint(PChar(('| Vendedor: ' + funcoes.CompletaOuRepete
      (copy(dm.IBselect.FieldByName('vendedor').AsString + '-' +
      BuscaNomeBD(dm.IBQuery1, 'nome', 'vendedor',
      'where cod=' + dm.IBselect.FieldByName('vendedor').AsString), 1, 16), '|',
      ' ', 17) + CompletaOuRepete('Recebido Por: ', '|', ' ', 49) + #13
      + #10))));

    if dm.IBselect.FieldByName('codhis').AsInteger = 2 then
    begin
      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.text :=
        'select vencimento as data from contasreceber where nota = :nota order by vencimento';
      dm.IBQuery1.ParamByName('nota').AsString :=
        dm.IBselect.FieldByName('nota').AsString;
      dm.IBQuery1.Open;

      form19.RichEdit1.Perform(EM_REPLACESEL, 1,
        Longint(PChar(('| Vencimento: ' + CompletaOuRepete(FormatDateTime
        ('DD/MM/YY', dm.IBQuery1.FieldByName('data').AsDateTime), '|', ' ',
        15) + CompletaOuRepete('', '|', ' ', 49) + #13 + #10))));
      dm.IBQuery1.Close;
    end;
    form19.RichEdit1.Perform(EM_REPLACESEL, 1,
      Longint(PChar((funcoes.CompletaOuRepete('+', '+', '-', tam) + #13
      + #10))));

    if EnviarImpressora = 'S' then
    begin
      imprime.textx('texto.txt');
    end
    else
      form19.ShowModal;
  end;

  // se tipo da nota for T(ticket)
  if ((tipo = 'T') or (tipo = 'TE')) then
  begin
    if (tipo = 'T') then
    begin
      if ((ConfParamGerais[32] = 'S') and (opcao = 1)) then
      begin
        rece := dm.IBselect.FieldByName('recebido').AsString;
        {rece := funcoes.dialogo('numero', 0, 'SN', 0, False, 'S',
          'Control for Windows:', 'Qual o valor recebido?',
          FormatCurr('#,###,###0.00', dm.IBselect.FieldByName('total')
          .AsCurrency));}
        if (rece = '*') or (StrToCurrDef(rece, 0) = 0) then
        begin
          troco := 0;
          recebido := 0;
        end
        else
        begin
          recebido := StrToCurr(rece);
          troco := recebido - dm.IBselect.FieldByName('total').AsCurrency;
        end;
      end;
    end;

    addRelatorioForm19('* S E M    V A L O R    F I S C A L  *' + CRLF);

    if funcoes.LerConfig(form22.Pgerais.Values['conf_ter'], 3) <> '' then
    begin
      imprime.negrito :=
        iif(funcoes.LerConfig(form22.Pgerais.Values['conf_ter'], 4) = 'S',
        true, False);
      imprime.fontDif := true;
      imprime.tamaFonte :=
        StrToIntDef(funcoes.LerConfig(form22.Pgerais.Values
        ['conf_ter'], 3), 11);
      addRelatorioForm19(' ' + #13 + #10);
    end;

    total := 0;
    dm.IBQuery2.Close;
    dm.IBQuery2.SQL.Clear;
    dm.IBQuery2.SQL.Add('select * from registro');
    dm.IBQuery2.Open;

    form19.RichEdit1.Perform(EM_REPLACESEL, 1,
      Longint(PChar((funcoes.CompletaOuRepete('', '', '-', 40) + #13 + #10))));

    if opcao = 4 then
    begin
      addRelatorioForm19(centraliza('PEDIDO DE ENTREGA', ' ', 40) + CRLF);
    end;

    form19.RichEdit1.Perform(EM_REPLACESEL, 1,
      Longint(PChar((funcoes.centraliza(form22.Pgerais.Values['empresa'], ' ',
      40) + #13 + #10))));
    form19.RichEdit1.Perform(EM_REPLACESEL, 1,
      Longint(PChar((funcoes.CompletaOuRepete('', '', '-', 40) + #13 + #10))));
    // form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('','',' ',40)+#13+#10))));
    addRelatorioForm19
      (funcoes.centraliza(LeftStr(dm.IBQuery2.FieldByName('ende').AsString +
      ' - ' + (dm.IBQuery2.FieldByName('bairro').AsString), 38), ' ',
      40) + CRLF);

    form19.RichEdit1.Perform(EM_REPLACESEL, 1,
      Longint(PChar((funcoes.centraliza('FONE: ' + dm.IBQuery2.FieldByName
      ('telres').AsString + '  ' + '     ' + dm.IBQuery2.FieldByName('telcom')
      .AsString, ' ', 40) + #13 + #10))));

    form19.RichEdit1.Perform(EM_REPLACESEL, 1,
      Longint(PChar((funcoes.CompletaOuRepete('', '', '-', 40) + #13 + #10))));

    if opcao = 1 then
      hora := dm.IBselect.FieldByName('hora').AsString
    else
      hora := FormatDateTime('hh:mm:ss', now);

    form19.RichEdit1.Perform(EM_REPLACESEL, 1,
      Longint(PChar((funcoes.CompletaOuRepete('DATA: ' + dm.IBselect.FieldByName
      ('data').AsString, 'HORA: ' + hora, ' ', 40) + #13 + #10))));
    form19.RichEdit1.Perform(EM_REPLACESEL, 1,
      Longint(PChar((funcoes.CompletaOuRepete('NOTA: ' + dm.IBselect.FieldByName
      ('nota').AsString, '', ' ', 13) + '  ' + 'VENDEDOR: ' +
      funcoes.CompletaOuRepete(copy(dm.IBselect.FieldByName('vendedor').AsString
      + '-' + BuscaNomeBD(dm.IBQuery1, 'nome', 'vendedor',
      'where cod=' + dm.IBselect.FieldByName('vendedor').AsString), 1, 15), '',
      ' ', 15) + #13 + #10))));
    form19.RichEdit1.Perform(EM_REPLACESEL, 1,
      Longint(PChar((funcoes.CompletaOuRepete('FORMA PAGTO: ' +
      dm.IBselect.FieldByName('codhis').AsString + '-' +
      copy(BuscaNomeBD(dm.IBQuery1, 'nome', 'formpagto',
      'where cod=' + dm.IBselect.FieldByName('codhis').AsString), 1,
      39 - length(dm.IBselect.FieldByName('codhis').AsString)), '', ' ',
      40) + #13 + #10))));
    if dm.IBselect.FieldByName('codhis').AsInteger = 2 then
    begin
      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.text :=
        'select vencimento as data from contasreceber where nota = :nota order by vencimento';
      dm.IBQuery1.ParamByName('nota').AsString :=
        dm.IBselect.FieldByName('nota').AsString;
      dm.IBQuery1.Open;

      form19.RichEdit1.Perform(EM_REPLACESEL, 1,
        Longint(PChar(('Vencimento: ' + CompletaOuRepete(FormatDateTime
        ('DD/MM/YY', dm.IBQuery1.FieldByName('data').AsDateTime), '', ' ',
        40) + #13 + #10))));
      dm.IBQuery1.Close;
    end;

    if ConfParamGerais.Strings[27] <> 'S' then
    begin
      dm.ibquery3.Close;
      dm.ibquery3.SQL.Clear;
      dm.ibquery3.SQL.Add('select nome from cliente where cod = :cod');
      dm.ibquery3.ParamByName('cod').AsString :=
        dm.IBselect.FieldByName('cliente').AsString;
      dm.ibquery3.Open;
      addRelatorioForm19(funcoes.CompletaOuRepete
        (copy('CLIENTE: ' + dm.IBselect.FieldByName('cliente').AsString + '-' +
        dm.ibquery3.FieldByName('nome').AsString, 1, 40), '', ' ', 40) +
        #13 + #10);
    end;
    form19.RichEdit1.Perform(EM_REPLACESEL, 1,
      Longint(PChar((funcoes.CompletaOuRepete('', '', '-', 40) + #13 + #10))));

    if ConfParamGerais.Strings[27] = 'S' then
    begin
      dm.ibquery3.Close;
      dm.ibquery3.SQL.Clear;
      dm.ibquery3.SQL.Add
        ('select nome,ende, bairro, telres, telcom, obs from cliente where cod = :cod');
      dm.ibquery3.ParamByName('cod').AsString :=
        dm.IBselect.FieldByName('cliente').AsString;
      dm.ibquery3.Open;
      addRelatorioForm19(funcoes.CompletaOuRepete
        (copy('CLIENTE: ' + dm.IBselect.FieldByName('cliente').AsString + '-' +
        dm.ibquery3.FieldByName('nome').AsString, 1, 40), '', ' ', 40) +
        #13 + #10);

      if dm.ibquery3.FieldByName('ende').AsString <> '' then
      begin
        addRelatorioForm19(funcoes.CompletaOuRepete('END: ' +
          copy(dm.ibquery3.FieldByName('ende').AsString, 1, 34), '', ' ', 40) +
          #13 + #10);
        addRelatorioForm19(funcoes.CompletaOuRepete('BAIRRO: ' +
          copy(dm.ibquery3.FieldByName('bairro').AsString, 1, 34), '', ' ', 40)
          + #13 + #10);
        addRelatorioForm19(funcoes.CompletaOuRepete('FONES: ' +
          copy(dm.ibquery3.FieldByName('telres').AsString + '   ' +
          dm.ibquery3.FieldByName('telcom').AsString, 1, 34), '', ' ', 40) +
          #13 + #10);

        addRelatorioForm19('OBS: ' + CRLF);

        funcoes.QuebraLinhas('', '', dm.ibquery3.FieldByName('obs')
          .AsString, 40);
      end;
      // addRelatorioForm19(funcoes.CompletaOuRepete('OBS: ' + copy(dm.IBQuery3.fieldbyname('obs').AsString, 1,34),'',' ', 40) + #13 + #10);
      // addRelatorioForm19('' + #13 + #10);
      form19.RichEdit1.Perform(EM_REPLACESEL, 1,
        Longint(PChar((funcoes.CompletaOuRepete('', '', '-', 40) + #13
        + #10))));
      dm.ibquery3.Close;
    end;

    dm.IBQuery2.Close;
    dm.IBQuery2.SQL.Clear;

    if opcao = 1 then
      dm.IBQuery2.SQL.Add
        ('select i.cod, i.p_venda, i.total, iif(i.nome = '''', p.nome, i.nome) as nome, i.quant, p.codbar, p.refori, p.localiza from item_venda i left join produto p on (i.cod = p.cod) where nota = '
        + numNota)
    else if opcao = 2 then
      dm.IBQuery2.SQL.Add
        ('select i.cod, i.p_venda,p.nome, i.quant, p.codbar, p.refori, p.localiza from item_orcamento i left join produto p on (i.cod = p.cod) where nota = '
        + numNota)
    else if opcao = 3 then
      dm.IBQuery2.SQL.Add
        ('select i.cod, p.p_compra as p_venda, i.quant, p.nome, p.codbar, p.localiza, p.refori from ITEM_COMPRA i left join produto p on (i.cod = p.cod) where nota = '
        + numNota)
    else if opcao = 4 then
      dm.IBQuery2.SQL.Add
        ('select e.cod, i.p_venda, i.total, iif(char_length(i.nome) = 0, p.nome, i.nome) as nome, '
        + 'e.quant, p.codbar, p.refori, p.localiza  from CONT_ENTREGA e left join '
        + 'item_venda i on (i.nota = e.nota and i.cod = e.cod) left join produto p on (i.cod = p.cod) '
        + 'where e.ENT_AGORA = ''X'' and e.nota = ' + numNota);

    dm.IBQuery2.Open;
    dm.IBQuery2.First;

    while not dm.IBQuery2.Eof do
    begin
      tot_item := 0;

      if opcao = 1 then
        tot_item := dm.IBQuery2.FieldByName('total').AsCurrency
      else
        tot_item := Arredonda(dm.IBQuery2.FieldByName('p_venda').AsCurrency *
          dm.IBQuery2.FieldByName('quant').AsCurrency, 2);

      total := total + tot_item;

      if ConfParamGerais[5] = 'S' then
      begin
        impref := funcoes.buscaParamGeral(74, '1');
        if impref = '2' then
          tmp := 'refori'
        else if impref = '3' then
          tmp := 'codbar'
        else
          tmp := 'localiza';

        tmp := dm.IBQuery2.FieldByName(tmp).AsString;
        codigo1 := dm.IBQuery2.FieldByName('cod').AsString;

        if opcao = 2 then
        begin
          if funcoes.LerConfig(form22.Pgerais.Values['configu'], 10) = 'N' then
            tmp := dm.IBQuery2.FieldByName('localiza').AsString;
        end
        else
        begin
          if impref = '4' then
          begin
            codigo1 := dm.IBQuery2.FieldByName('refori').AsString;
            if trim(codigo1) = '' then codigo1 := dm.IBQuery2.fieldbyname('cod').AsString;

            //if trim(codigo1) = '' then codigo1 := dm.IBQuery2.fieldbyname('codbar').AsString;
            //if trim(codigo1) = '' then codigo1 := dm.IBselect.fieldbyname('cod').AsString;

            if trim(tmp) = '' then
              tmp := dm.IBQuery2.FieldByName('codbar').AsString;

            tmp := dm.IBQuery2.FieldByName('localiza').AsString;
          end;
        end;

        if tmp = '' then
          tmp := '-->';

        addRelatorioForm19
          (funcoes.CompletaOuRepete(copy(codigo1 + '-' + dm.IBQuery2.FieldByName
          ('nome').AsString, 1, 40), '', ' ', 40) + CRLF);
        addRelatorioForm19(funcoes.CompletaOuRepete(LeftStr(trim(tmp), 14), '',
          ' ', 14) + funcoes.CompletaOuRepete('', FormatCurr('0.00',
          dm.IBQuery2.FieldByName('quant').AsCurrency), ' ', 9) +
          funcoes.CompletaOuRepete('', FormatCurr('0.00',
          dm.IBQuery2.FieldByName('p_venda').AsCurrency), ' ', 8) +
          funcoes.CompletaOuRepete('', FormatCurr('0.00', tot_item), ' ',
          9) + CRLF);
      end
      else
      begin
        form19.RichEdit1.Perform(EM_REPLACESEL, 1,
          Longint(PChar((funcoes.CompletaOuRepete(dm.IBQuery2.FieldByName('cod')
          .AsString + '-' + copy(dm.IBQuery2.FieldByName('nome').AsString, 1,
          37 - length(dm.IBQuery2.FieldByName('cod').AsString)), '', ' ',
          40) + #13 + #10))));
        form19.RichEdit1.Perform(EM_REPLACESEL, 1,
          Longint(PChar((funcoes.CompletaOuRepete('=>QTD:', FormatCurr('0.00',
          dm.IBQuery2.FieldByName('quant').AsCurrency), ' ',
          15) + funcoes.CompletaOuRepete('', FormatCurr('0.00',
          dm.IBQuery2.FieldByName('p_venda').AsCurrency), ' ',
          13) + funcoes.CompletaOuRepete('', FormatCurr('0.00', tot_item), ' ',
          12) + #13 + #10))));
      end;
      dm.IBQuery2.Next;
    end;

    if funcoes.buscaParamGeral(81, 'N') = 'N' then
    begin
      if dm.IBselect.FieldByName('desconto').AsCurrency < 0 then
      begin
        form19.RichEdit1.Perform(EM_REPLACESEL, 1,
          Longint(PChar(('VOCE ECONOMIZOU(' + FormatCurr('#,###,###0.00',
          // (dm.IBselect.FieldByName('desconto').AsCurrency * 100) / (dm.IBselect.FieldByName('total').AsCurrency -dm.IBselect.FieldByName('desconto').AsCurrency)) +
          (dm.IBselect.FieldByName('desconto').AsCurrency * 100) / (total)) +
          '%) --->' + funcoes.CompletaOuRepete('', FormatCurr('#,###,###0.00',
          dm.IBselect.FieldByName('desconto').AsCurrency), ' ', 11) + #13
          + #10))));
      end;
      addRelatorioForm19(funcoes.CompletaOuRepete('', '', '-', 40) + #13 + #10);
    end
    else
    begin
      addRelatorioForm19(funcoes.CompletaOuRepete('', '', '-', 40) + #13 + #10);
      addRelatorioForm19(funcoes.CompletaOuRepete('SUBTOTAL:',
        FormatCurr('#,##,###0.00', dm.IBselect.FieldByName('total').AsCurrency -
        dm.IBselect.FieldByName('desconto').AsCurrency), '.', 40) + CRLF);
      addRelatorioForm19(funcoes.CompletaOuRepete('DESCONTO(' +
        FormatCurr('#,###,###0.00',
        // (dm.IBselect.FieldByName('desconto').AsCurrency * 100) / (dm.IBselect.FieldByName('total').AsCurrency -dm.IBselect.FieldByName('desconto').AsCurrency)) +
        (dm.IBselect.FieldByName('desconto').AsCurrency * 100) / (total)) +
        '%):', FormatCurr('#,##,###0.00', dm.IBselect.FieldByName('desconto')
        .AsCurrency), '.', 40) + CRLF);
    end;
    addRelatorioForm19(funcoes.CompletaOuRepete('TOTAL:',
      FormatCurr('#,##,###0.00', dm.IBselect.FieldByName('total').AsCurrency),
      '.', 40) + CRLF);
    form19.RichEdit1.Perform(EM_REPLACESEL, 1,
      Longint(PChar((funcoes.CompletaOuRepete('', '', '-', 40) + #13 + #10))));

    if ConfParamGerais[32] = 'S' then
    begin
      if recebido <> 0 then
      begin
        // form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('','','-',40)+#13+#10))));
        addRelatorioForm19(funcoes.CompletaOuRepete('Pagto:. . . . . . . . . .',
          FormatCurr('#,###,###0.00', recebido), ' ', 40) + #13 + #10);
        addRelatorioForm19(funcoes.CompletaOuRepete('Troco:. . . . . . . . . .',
          FormatCurr('#,###,###0.00', troco), ' ', 40) + #13 + #10);
        form19.RichEdit1.Perform(EM_REPLACESEL, 1,
          Longint(PChar((funcoes.CompletaOuRepete('', '', '-', 40) + #13
          + #10))));
      end;
    end;

    if opcao = 1 then
    begin
      if funcoes.LerConfig(form22.Pgerais.Values['configu'], 3) = 'S' then
      begin
        addRelatorioForm19(funcoes.QuebraLinhas('', '', 'OBS: ' + txt, 40));
        if length(txt) > 0 then
          form19.RichEdit1.Perform(EM_REPLACESEL, 1,
            Longint(PChar((funcoes.CompletaOuRepete('', '', '-', 40) + #13
            + #10))));

        try
          funcoes.atualizaMensagemUsuario(txt, numNota);
        except
        end;
      end;
      form19.RichEdit1.Perform(EM_REPLACESEL, 1,
        Longint(PChar(('* * *    R E I M P R E S S A O     * * *' + #13
        + #10))));
    end
    else if opcao = 2 then
    begin
      if (txt <> '') then
      begin
        addRelatorioForm19(funcoes.QuebraLinhas('', '', txt, 40));
        form19.RichEdit1.Perform(EM_REPLACESEL, 1,
          Longint(PChar((funcoes.CompletaOuRepete('', '', '-', 40) + #13
          + #10))));
      end;
      form19.RichEdit1.Perform(EM_REPLACESEL, 1,
        Longint(PChar(('* * *          ORCAMENTO           * * *' + #13
        + #10))));
    end
    else if opcao = 3 then
    begin
      form19.RichEdit1.Perform(EM_REPLACESEL, 1,
        Longint(PChar(('* * *  *  *  *   COMPRA  *  *  *   * * *' + #13
        + #10))));
    end
    else if opcao = 4 then
    begin
      form19.RichEdit1.Perform(EM_REPLACESEL, 1,
        Longint(PChar(('* * *  *  *PRODUTOS ENTREGUES* *   * * *' + #13
        + #10))));
    end;


    // addRelatorioForm19(funcoes.centraliza('* * * REIMPRESSAO * * *', ' ', 40));

    if tipo = 'T' then
    begin
      form19.RichEdit1.Perform(EM_REPLACESEL, 1,
        Longint(PChar((' ' + #13 + #10))));
      if funcoes.ExisteParcelamento(numNota) and
        (ConfParamGerais.Strings[20] = 'S') then
        funcoes.ImprimeParcelamento('', '', FormatCurr('#,###,###0.00',
          entrada), numNota);
    end;

    if tipo = 'TE' then
    begin
      addRelatorioForm19(CompletaOuRepete('', '', ' ', 40) + CRLF);
      addRelatorioForm19(CompletaOuRepete('', '', ' ', 40) + CRLF);
      addRelatorioForm19(CompletaOuRepete('', '', ' ', 40) + CRLF);
      addRelatorioForm19(CompletaOuRepete('', '', '-', 40) + CRLF);
      addRelatorioForm19(CompletaOuRepete('          RECEBIDO POR:', '', ' ',
        40) + CRLF);
      addRelatorioForm19(CompletaOuRepete('', '', '-', 40) + CRLF);
    end;

    dm.IBselect.Close;
    dm.IBQuery2.Close;
    dm.IBQuery1.Close;

    if opcao = 4 then
    begin
      funcoes.LimparEntregues(numNota);
    end;

    if opcao = 1 then
    begin
      if funcoes.buscaParamGeral(88, 'N') = 'S' then
      begin
        addRelatorioForm19(' ' + CRLF);
        addRelatorioForm19(' ' + CRLF);
        GeraNota(numNota, 'DX', 'N', opcao);
      end;
    end;

    if EnviarImpressora = 'S' then
    begin
      imprime.textx('');
    end
    else
      form19.ShowModal;

  end;

  // se tipo da nota for T(ticket)
  if (tipo = 'E') then
  begin
    recebido := dm.IBselect.FieldByName('recebido').AsCurrency;

    tam := 30;
    addRelatorioForm19('* * * SEM VALOR FISCAL * * *' + CRLF);

    if funcoes.LerConfig(form22.Pgerais.Values['conf_ter'], 3) <> '' then
    begin
      imprime.negrito :=
        iif(funcoes.LerConfig(form22.Pgerais.Values['conf_ter'], 4) = 'S',
        true, False);
      imprime.fontDif := true;
      imprime.tamaFonte :=
        StrToIntDef(funcoes.LerConfig(form22.Pgerais.Values
        ['conf_ter'], 3), 11);
      addRelatorioForm19(' ' + #13 + #10);
    end;

    total := 0;
    dm.IBQuery2.Close;
    dm.IBQuery2.SQL.Clear;
    dm.IBQuery2.SQL.Add('select * from registro');
    dm.IBQuery2.Open;

    form19.RichEdit1.Perform(EM_REPLACESEL, 1,
      Longint(PChar((funcoes.CompletaOuRepete('', '', '-', tam) + #13 + #10))));


    if opcao = 4 then
    begin
      addRelatorioForm19(centraliza('PEDIDO DE ENTREGA', ' ', tam) + CRLF);
      addRelatorioForm19(funcoes.CompletaOuRepete('', '', '-', tam) + CRLF);
    end;

    addRelatorioForm19(funcoes.centraliza(form22.Pgerais.Values['empresa'], ' ',
      30) + CRLF);
    addRelatorioForm19(funcoes.CompletaOuRepete('', '', '-', tam) + CRLF);
    // form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('','',' ',40)+#13+#10))));
    addRelatorioForm19(LeftStr(dm.IBQuery2.FieldByName('ende').AsString,
      tam) + CRLF);
    addRelatorioForm19(LeftStr(dm.IBQuery2.FieldByName('bairro').AsString,
      tam) + CRLF);
    addRelatorioForm19
      (funcoes.centraliza(LeftStr('TEL: ' + dm.IBQuery2.FieldByName('telres')
      .AsString + ' ' + dm.IBQuery2.FieldByName('telcom').AsString, tam), ' ',
      tam) + CRLF);
    addRelatorioForm19(funcoes.CompletaOuRepete('', '', '-', tam) + #13 + #10);

    if opcao = 1 then
      hora := dm.IBselect.FieldByName('hora').AsString
    else
      hora := FormatDateTime('hh:mm:ss', now);

    addRelatorioForm19(funcoes.CompletaOuRepete(dm.IBselect.FieldByName('data')
      .AsString, hora, ' ', tam) + #13 + #10);

    addRelatorioForm19(funcoes.CompletaOuRepete
      (LeftStr('NOTA: ' + dm.IBselect.FieldByName('nota').AsString + ' ' +
      'VEND: ' + dm.IBselect.FieldByName('vendedor').AsString + '-' +
      funcoes.BuscaNomeBD(dm.IBQuery1, 'nome', 'vendedor',
      'where cod=' + dm.IBselect.FieldByName('vendedor').AsString), tam), '',
      ' ', tam) + #13 + #10);

    addRelatorioForm19(funcoes.CompletaOuRepete('PAGTO: ' +
      dm.IBselect.FieldByName('codhis').AsString + '-' +
      copy(funcoes.BuscaNomeBD(dm.IBQuery1, 'nome', 'formpagto',
      'where cod=' + dm.IBselect.FieldByName('codhis').AsString), 1, 20), '',
      ' ', tam) + #13 + #10);

    if dm.IBselect.FieldByName('codhis').AsInteger = 2 then
    begin
      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.text :=
        'select vencimento as data from contasreceber where nota = :nota order by vencimento';
      dm.IBQuery1.ParamByName('nota').AsString :=
        dm.IBselect.FieldByName('nota').AsString;
      dm.IBQuery1.Open;

      form19.RichEdit1.Perform(EM_REPLACESEL, 1,
        Longint(PChar(('Vencto: ' + CompletaOuRepete(FormatDateTime('DD/MM/YY',
        dm.IBQuery1.FieldByName('data').AsDateTime), '', ' ', tam) + #13
        + #10))));
      dm.IBQuery1.Close;
    end;

    if ConfParamGerais.Strings[27] <> 'S' then
    begin
      dm.ibquery3.Close;
      dm.ibquery3.SQL.Clear;
      dm.ibquery3.SQL.Add('select nome from cliente where cod = :cod');
      dm.ibquery3.ParamByName('cod').AsString :=
        dm.IBselect.FieldByName('cliente').AsString;
      dm.ibquery3.Open;

      addRelatorioForm19(funcoes.CompletaOuRepete('', '', '-', tam) + CRLF);
      addRelatorioForm19(funcoes.CompletaOuRepete(LeftStr('CLIENTE: ' +
        dm.IBselect.FieldByName('cliente').AsString + '-' +
        dm.ibquery3.FieldByName('nome').AsString, tam), '', ' ', tam) + CRLF);
    end;

    addRelatorioForm19(funcoes.CompletaOuRepete('', '', '-', tam) + CRLF);

    if ConfParamGerais.Strings[27] = 'S' then
    begin
      dm.ibquery3.Close;
      dm.ibquery3.SQL.Clear;
      dm.ibquery3.SQL.Add
        ('select nome,ende, bairro, telres, telcom, obs from cliente where cod = :cod');
      dm.ibquery3.ParamByName('cod').AsString :=
        dm.IBselect.FieldByName('cliente').AsString;
      dm.ibquery3.Open;

      addRelatorioForm19(funcoes.CompletaOuRepete(LeftStr('CLIENTE: ' +
        dm.IBselect.FieldByName('cliente').AsString + '-' +
        dm.ibquery3.FieldByName('nome').AsString, tam), '', ' ', tam) + CRLF);

      if dm.ibquery3.FieldByName('ende').AsString <> '' then
      begin
        if length(trim(dm.ibquery3.FieldByName('ende').AsString)) + 5 > tam then
        begin
          addRelatorioForm19('ENDERECO: ' + CRLF);
          addRelatorioForm19(funcoes.QuebraLinhas('', '',
            dm.ibquery3.FieldByName('ende').AsString, tam));
        end
        else
          addRelatorioForm19
            (funcoes.CompletaOuRepete(LeftStr('END: ' + dm.ibquery3.FieldByName
            ('ende').AsString, tam), '', ' ', tam) + #13 + #10);

        addRelatorioForm19
          (funcoes.CompletaOuRepete(LeftStr('BAIRRO: ' + dm.ibquery3.FieldByName
          ('bairro').AsString, tam), '', ' ', tam) + #13 + #10);
        addRelatorioForm19
          (funcoes.CompletaOuRepete(LeftStr('FONES: ' + dm.ibquery3.FieldByName
          ('telres').AsString + ' ' + dm.ibquery3.FieldByName('telcom')
          .AsString, tam), '', ' ', tam) + #13 + #10);

        if trim(dm.ibquery3.FieldByName('obs').AsString) <> '' then
        begin
          addRelatorioForm19('OBS: ' + CRLF);
          addRelatorioForm19(funcoes.QuebraLinhas('', '',
            dm.ibquery3.FieldByName('obs').AsString, tam));
        end;
      end;

      addRelatorioForm19(funcoes.CompletaOuRepete('', '', '-', tam) + CRLF);
      dm.ibquery3.Close;
    end;

    dm.IBQuery2.Close;
    dm.IBQuery2.SQL.Clear;

    if opcao = 1 then
      dm.IBQuery2.SQL.Add
        ('select i.cod, i.p_venda, i.total, iif(i.nome = '''', p.nome, i.nome) as nome, i.quant, p.codbar, p.refori, p.localiza from item_venda i left join produto p on (i.cod = p.cod) where nota = '
        + numNota)
    else if opcao = 2 then
      dm.IBQuery2.SQL.Add
        ('select i.cod, i.p_venda,p.nome, i.quant, p.codbar, p.refori, p.localiza from item_orcamento i left join produto p on (i.cod = p.cod) where nota = '
        + numNota)
    else if opcao = 3 then
      dm.IBQuery2.SQL.Add
        ('select i.cod, p.p_compra as p_venda, i.quant, p.nome, p.codbar, p.localiza, p.refori from ITEM_COMPRA i left join produto p on (i.cod = p.cod) where nota = '
        + numNota)
    else if opcao = 4 then
      dm.IBQuery2.SQL.Add
        ('select e.cod, i.p_venda, i.total, iif(char_length(i.nome) = 0, p.nome, i.nome) as nome, '
        + 'e.quant, p.codbar, p.refori, p.localiza  from CONT_ENTREGA e left join '
        + 'item_venda i on (i.nota = e.nota and i.cod = e.cod) left join produto p on (i.cod = p.cod) '
        + 'where e.ENT_AGORA = ''X'' and e.nota = ' + numNota);

    dm.IBQuery2.Open;
    dm.IBQuery2.First;

    while not dm.IBQuery2.Eof do
    begin
      tot_item := 0;

      if opcao = 1 then
        tot_item := dm.IBQuery2.FieldByName('total').AsCurrency
      else
        tot_item := Arredonda(dm.IBQuery2.FieldByName('p_venda').AsCurrency *
          dm.IBQuery2.FieldByName('quant').AsCurrency, 2);

      total := total + tot_item;

      addRelatorioForm19(funcoes.CompletaOuRepete
        (LeftStr(dm.IBQuery2.FieldByName('cod').AsString + '-' +
        dm.IBQuery2.FieldByName('nome').AsString, tam), '', ' ', tam) +
        #13 + #10);
      addRelatorioForm19(funcoes.CompletaOuRepete('QTD:', FormatCurr('0.00',
        dm.IBQuery2.FieldByName('quant').AsCurrency), ' ', 11) +
        funcoes.CompletaOuRepete('', FormatCurr('0.00',
        dm.IBQuery2.FieldByName('p_venda').AsCurrency), ' ', 9) +
        funcoes.CompletaOuRepete('', FormatCurr('0.00', tot_item), ' ', 10) +
        #13 + #10);

      dm.IBQuery2.Next;
    end;

    addRelatorioForm19(funcoes.CompletaOuRepete('', '', '-', tam) + #13 + #10);
    addRelatorioForm19(funcoes.CompletaOuRepete('SUBTOTAL:',
      FormatCurr('0.00', dm.IBselect.FieldByName('total').AsCurrency -
      dm.IBselect.FieldByName('desconto').AsCurrency), '.', tam) + CRLF);
    addRelatorioForm19(funcoes.CompletaOuRepete('DESCONTO(' + FormatCurr('0.00',
      (dm.IBselect.FieldByName('desconto').AsCurrency * 100) / (total)) + '%):',
      FormatCurr('0.00', dm.IBselect.FieldByName('desconto').AsCurrency), '.',
      tam) + CRLF);

    addRelatorioForm19(funcoes.CompletaOuRepete('TOTAL:', FormatCurr('0.00',
      dm.IBselect.FieldByName('total').AsCurrency), '.', tam) + CRLF);
    addRelatorioForm19(funcoes.CompletaOuRepete('', '', '-', tam) + #13 + #10);

    if ConfParamGerais[32] = 'S' then
    begin
      if recebido <> 0 then
      begin
        // form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('','','-',40)+#13+#10))));
        addRelatorioForm19(funcoes.CompletaOuRepete('Pagto:. . . .',
          FormatCurr('0.00', recebido), '.', tam) + #13 + #10);
        addRelatorioForm19(funcoes.CompletaOuRepete('Troco:. . . .',
          FormatCurr('0.00', recebido - dm.IBselect.FieldByName('total').AsCurrency), '.', tam) + #13 + #10);
        form19.RichEdit1.Perform(EM_REPLACESEL, 1,
          Longint(PChar((funcoes.CompletaOuRepete('', '', '-', tam) + #13
          + #10))));
      end;
    end;

    if opcao = 1 then
    begin
      if funcoes.LerConfig(form22.Pgerais.Values['configu'], 3) = 'S' then
      begin
        addRelatorioForm19(funcoes.QuebraLinhas('', '', 'OBS: ' + txt, tam));
        if length(txt) > 0 then
          form19.RichEdit1.Perform(EM_REPLACESEL, 1,
            Longint(PChar((funcoes.CompletaOuRepete('', '', '-', tam) + #13
            + #10))));

        try
          funcoes.atualizaMensagemUsuario(txt, numNota);
        except
        end;
      end;
      form19.RichEdit1.Perform(EM_REPLACESEL, 1,
        Longint(PChar(('* *R E I M P R E S S A O* *' + #13 + #10))));
    end
    else if opcao = 2 then
    begin
      if (txt <> '') then
      begin
        addRelatorioForm19(funcoes.QuebraLinhas('', '', txt, tam));
        form19.RichEdit1.Perform(EM_REPLACESEL, 1,
          Longint(PChar((funcoes.CompletaOuRepete('', '', '-', tam) + #13
          + #10))));
      end;
      form19.RichEdit1.Perform(EM_REPLACESEL, 1,
        Longint(PChar(('* *      ORCAMENTO      * *' + #13 + #10))));
    end
    else if opcao = 3 then
    begin
      form19.RichEdit1.Perform(EM_REPLACESEL, 1,
        Longint(PChar(('* *        COMPRA       * *' + #13 + #10))));
    end
    else if opcao = 4 then
    begin
      form19.RichEdit1.Perform(EM_REPLACESEL, 1,
        Longint(PChar(('*  * PRODUTOS ENTREGUES * *' + #13 + #10))));
    end;

    dm.IBselect.Close;
    dm.IBQuery2.Close;
    dm.IBQuery1.Close;

    if opcao = 4 then
    begin
      funcoes.LimparEntregues(numNota);
    end;

    if opcao = 1 then
    begin
      if funcoes.buscaParamGeral(88, 'N') = 'S' then
      begin
        addRelatorioForm19(' ' + CRLF);
        addRelatorioForm19(' ' + CRLF);
        GeraNota(numNota, 'DX', 'N', opcao);
      end;
    end;

    if EnviarImpressora = 'S' then
    begin
      imprime.textx('');
    end
    else
      form19.ShowModal;

  end;

  // form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar(()));
  dm.IBselect.Close;
  dm.IBQuery2.Close;
  dm.IBQuery1.Close;
end;

function Tfuncoes.lista11: string;
var
  pRect: TRect;
begin
  try
    form39.Position := poScreenCenter;
    form39.AutoSize := False;
    form39.Height := form39.ListBox1.Items.count * 20;
    form39.Width := length(RetornaMaiorTstrings(form39.ListBox1.Items)) *
      form39.ListBox1.Font.Size;
    form39.ShowModal;
    form39.Free;
    Result := trim(lista1);
  except
  end;
end;

function Tfuncoes.lista(var t: TObject; center: boolean; conf : integer = 0): string;
var
  pRect: TRect;
begin
  Result := '';
  try
    if not center then
      GetWindowRect(tedit(t).Handle, pRect);
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

    if conf  = 0 then form39.conf := 99;
    form39.AutoSize := False;
    form39.Height   := form39.ListBox1.Items.count * 20;
    form39.Width    := length(RetornaMaiorTstrings(form39.ListBox1.Items)) *
      form39.ListBox1.Font.Size;
    form39.ShowModal;
    form39.Free;
    Result := trim(lista1);
  except
  end;
end;

function Tfuncoes.Parcelamento(total: currency; Cliente: string; prazo: string)
  : tstringList;
begin
  form38 := tform38.Create(self);
  form38.total := total;
  form38.vencto.text := FormatDateTime('dd/mm/yyyy',
    form22.dataMov + iif(StrToInt(prazo) = 0, 30, StrToInt(prazo)));
  form38.dias.text := '30';
  form38.qtd.text := '1';
  if Cliente = '*' then
    form38.tipo := 2;
  form38.ShowModal;
  form38.Free;
  Result := ReParcelamento;
end;

function Tfuncoes.DeletaChar(sub: string; texto: string): string;
var
  i: integer;
begin
  Result := '';
  for i := 1 to length(texto) do
  begin
    // ShowMessage(texto[i]);
    if sub <> texto[i] then
      Result := Result + texto[i];
  end;
end;

function Tfuncoes.trocaChar(texto, velho, novo: string): string;
var
  i, fim: integer;
begin
  Result := '';
  fim := length(texto);
  for i := 1 to fim do
  begin
    if velho[1] = texto[i] then
      Result := Result + novo
    else
      Result := Result + texto[i];
  end;
end;

function Tfuncoes.VerAcesso(param: string): string;
var
  i, a, posi: integer;
  tmf: string;
begin
  Result := '';

  if form22.USUARIO = 'ADMIN' then
  begin
    form2.ExecutarComando1.Visible := true;
    form2.ManutenoNFCe1.Visible := true;
  end
  else
  begin
    form2.ExecutarComando1.Visible := False;
    form2.ManutenoNFCe1.Visible := False;
  end;

  for i := 0 to form2.MainMenu1.Items.count - 1 do
  begin

    posi := pos('-' + IntToStr(i) + '-', form22.Pgerais.Values['acesso']) + 3;

    for a := 0 to form2.MainMenu1.Items[i].count - 1 do
    begin
      if funcoes.Contido('*', form2.MainMenu1.Items[i].Items[a].caption) then
      begin
        form2.MainMenu1.Items[i].Items[a].Visible := False;
      end
      else
      // if not funcoes.Contido('*', form22.Pgerais.Values['acesso'][posi+a]) then
      begin
        try
          if form22.Pgerais.Values['acesso'][posi + a] = '-' then
          begin
            Result := form22.Pgerais.Values['acesso'];
            Insert('0', Result, posi + a);
            form22.Pgerais.Values['acesso'] := Result;
          end;

          if form22.Pgerais.Values['acesso'][posi + a] <> ' ' then
          begin
            if funcoes.Contido(IntToStr(i), form22.Pgerais.Values['acessousu'])
            then
            begin
              form2.MainMenu1.Items[i].Items[a].Visible := False;
            end
            // else if length(form22.Pgerais.Values['acessousu']) >
            // StrToInt(form22.Pgerais.Values['acesso'][posi + a]) then
            else if length(form22.Pgerais.Values['acessousu']) >
              StrToInt(form22.Pgerais.Values['acesso'][posi + a]) then
            begin
              form2.MainMenu1.Items[i].Items[a].Visible := False;
            end
            else
            begin
              // ShowMessage('2');
            end;

            if param = '0' then
              form2.MainMenu1.Items[i].Items[a].Visible := true;
          end;
        except
        end;
      end; // fim if contido '*'

    end; // for no itens do menu
  end; // for menus

  // if ConfParamGerais.Strings[17] = 'N' then form2.MainMenu1.Items.Items[0].Items[15].Visible := false
  // else form2.MainMenu1.Items.Items[0].Items[15].Visible := true;

  // if ConfParamGerais.Strings[17] = 'N' then form2.VendanoAtacado1.Visible := false
  // else form2.VendanoAtacado1.Visible := true;

  if ConfParamGerais.Strings[17] <> 'S' then
    form2.AcertodeEstoque1.Visible := False;
  // venda no atacado esta com esse nome
  try
    if ConfParamGerais[39] <> 'S' then
      form2.NotaFiscaldeVenda1.Visible := False;
  except
  end;

  try
    if (ConfParamGerais[24] <> 'S') then // saida de estoque
    begin
      form2.SadadeEstoque2.Visible := False;
    end;
  except
  end;

  try
    if ConfParamGerais[14] = 'N' then
    begin
      form2.Servios1.Visible := False;
    end;
  except
  end;

  if form22.superUsu = 1 then
    form2.AvanarNumerao1.Visible := true
  else
    form2.AvanarNumerao1.Visible := False;

  if form22.superUsu = 1 then
    form2.avanumNFCe.Visible := true
  else
    form2.avanumNFCe.Visible := False;

  { if form2.Nfe1.Visible = false then begin
    for I := 0 to form2.Nfe1.Count -1 do begin
    form2.Nfe1.Items[i].Visible := false;
    end;
    form2.EnviarporEmail1.Visible := true;
    form2.Utilitarios1.Visible    := true;
    form2.Nfe1.Visible := true;
    end;
    if tmf <> '' then
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

function Tfuncoes.GeraAleatorio(valor: integer): string;
var
  acc: string;
  i: integer;
begin
  Randomize;
  acc := '';
  for i := 1 to 10 do
  begin
    acc := acc + IntToStr(random(99));
    { if length(acc) < valor then
      acc := acc + IntToStr(random(99));
      if length(acc) > valor then
      Delete(acc, length(acc) - 1, length(acc)); }
  end;
  Result := acc;
  Result := LeftStr(Result, 9);
end;

function Tfuncoes.centraliza(valor: string; repetir: string;
  tamanho: integer): string;
var
  i, cont, ch: integer;
  acc: string;
begin
  acc := '';
  cont := 1;
  ch := tamanho - length(valor);
  for i := 1 to ch do
  begin
    acc := acc + repetir;
    if (i >= ch / 2) and (cont = 1) then
    begin
      cont := 2;
      acc := acc + valor;
    end;
  end;
  if length(acc) = tamanho then
    Result := acc
  else
  begin
    for i := length(acc) to tamanho do
    begin
      acc := acc + repetir;
    end;
    Result := acc;
  end;
end;

function Tfuncoes.valorPorExtenso(vlr: real): string;
const
  unidade: array [1 .. 19] of string = ('um', 'dois', 'tres', 'quatro', 'cinco',
    'seis', 'sete', 'oito', 'nove', 'dez', 'onze', 'doze', 'treze', 'quatorze',
    'quinze', 'dezesseis', 'dezessete', 'dezoito', 'dezenove');
  centena: array [1 .. 9] of string = ('cento', 'duzentos', 'trezentos',
    'quatrocentos', 'quinhentos', 'seiscentos', 'setecentos', 'oitocentos',
    'novecentos');
  dezena: array [2 .. 9] of string = ('vinte', 'trinta', 'quarenta',
    'cinquenta', 'sessenta', 'setenta', 'oitenta', 'noventa');
  qualificaS: array [0 .. 4] of string = ('', 'mil', 'milhao', 'bilhao',
    'trilhao');
  qualificaP: array [0 .. 4] of string = ('', 'mil', 'milhoes', 'bilhoes',
    'trilhoes');
var
  inteiro: Int64;
  resto: real;
  vlrS, s, saux, vlrP, centavos: string;
  n, unid, dez, cent, tam, i: integer;
  umReal, tem: boolean;
begin
  if (vlr = 0) then
  begin
    valorPorExtenso := 'zero';
    exit;
  end;

  inteiro := trunc(vlr); // parte inteira do valor
  resto := vlr - inteiro; // parte fracionária do valor
  vlrS := IntToStr(inteiro);
  if (length(vlrS) > 15) then
  begin
    valorPorExtenso := 'Erro: valor superior a 999 trilhões.';
    exit;
  end;

  s := '';
  centavos := IntToStr(round(resto * 100));

  // definindo o extenso da parte inteira do valor
  i := 0;
  umReal := False;
  tem := False;
  while (vlrS <> '0') do
  begin
    tam := length(vlrS);
    // retira do valor a 1a. parte, 2a. parte, por exemplo, para 123456789:
    // 1a. parte = 789 (centena)
    // 2a. parte = 456 (mil)
    // 3a. parte = 123 (milhões)
    if (tam > 3) then
    begin
      vlrP := copy(vlrS, tam - 2, tam);
      vlrS := copy(vlrS, 1, tam - 3);
    end
    else
    begin // última parte do valor
      vlrP := vlrS;
      vlrS := '0';
    end;
    if (vlrP <> '000') then
    begin
      saux := '';
      if (vlrP = '100') then
        saux := 'cem'
      else
      begin
        n := StrToInt(vlrP); // para n = 371, tem-se:
        cent := n div 100; // cent = 3 (centena trezentos)
        dez := (n mod 100) div 10; // dez  = 7 (dezena setenta)
        unid := (n mod 100) mod 10; // unid = 1 (unidade um)
        if (cent <> 0) then
          saux := centena[cent];
        if ((dez <> 0) or (unid <> 0)) then
        begin
          if ((n mod 100) <= 19) then
          begin
            if (length(saux) <> 0) then
              saux := saux + ' e ' + unidade[n mod 100]
            else
              saux := unidade[n mod 100];
          end
          else
          begin
            if (length(saux) <> 0) then
              saux := saux + ' e ' + dezena[dez]
            else
              saux := dezena[dez];
            if (unid <> 0) then
              if (length(saux) <> 0) then
                saux := saux + ' e ' + unidade[unid]
              else
                saux := unidade[unid];
          end;
        end;
      end;
      if ((vlrP = '1') or (vlrP = '001')) then
      begin
        if (i = 0) // 1a. parte do valor (um real)
        then
          umReal := true
        else
          saux := saux + ' ' + qualificaS[i];
      end
      else if (i <> 0) then
        saux := saux + ' ' + qualificaP[i];
      if (length(s) <> 0) then
        s := saux + ', ' + s
      else
        s := saux;
    end;
    if (((i = 0) or (i = 1)) and (length(s) <> 0)) then
      tem := true; // tem centena ou mil no valor
    i := i + 1; // próximo qualificador: 1- mil, 2- milhão, 3- bilhão, ...
  end;

  if (length(s) <> 0) then
  begin
    if (umReal) then
      s := s + ' real'
    else if (tem) then
      s := s + ' reais'
    else
      s := s + ' de reais';
  end;
  // definindo o extenso dos centavos do valor
  if (centavos <> '0') // valor com centavos
  then
  begin
    if (length(s) <> 0) // se não é valor somente com centavos
    then
      s := s + ' e ';
    if (centavos = '1') then
      s := s + 'um centavo'
    else
    begin
      n := StrToInt(centavos);
      if (n <= 19) then
        s := s + unidade[n]
      else
      begin // para n = 37, tem-se:
        unid := n mod 10; // unid = 37 % 10 = 7 (unidade sete)
        dez := n div 10; // dez  = 37 / 10 = 3 (dezena trinta)
        s := s + dezena[dez];
        if (unid <> 0) then
          s := s + ' e ' + unidade[unid];
      end;
      s := s + ' centavos';
    end;
  end;
  valorPorExtenso := s;
end;

function Tfuncoes.SomaCampoDBGRID(var dataset: TIBQuery; campo: string;
  dataIni: TDateTime; DataFim: TDateTime; dataIgual: TDateTime;
  NomeCampoDataParaComparar: string): currency;
var
  i, a, RecNo: integer;
begin
  Result := 0;
  a := 0;

  dataset.DisableControls;
  RecNo := dataset.RecNo;
  dataset.First;
  while not dataset.Eof do
  begin

    if (dataIni <> 0) and (DataFim <> 0) then
    begin
      if (dataset.FieldByName(NomeCampoDataParaComparar).AsDateTime >= dataIni)
        and (dataset.FieldByName(NomeCampoDataParaComparar).AsDateTime <=
        DataFim) then
        Result := Result + dataset.FieldByName(campo).AsCurrency;
    end

    else if (dataIni <> 0) and (DataFim = 0) and (dataIgual = 0) then
    begin
      if dataIni >= dataset.FieldByName(NomeCampoDataParaComparar).AsDateTime
      then
      begin
        Result := Result + dataset.FieldByName(campo).AsCurrency;
      end;
    end

    else if (dataIgual <> 0) then
    begin
      // ShowMessage(FormatDateTime('dd/mm/yy',DataSet.FieldByName(NomeCampoDataParaComparar).AsDateTime)+'<>'+FormatDateTime('dd/mm/yy',dataIgual));
      if DateOf(dataset.FieldByName(NomeCampoDataParaComparar).AsDateTime)
        = DateOf(dataIgual) then
      begin
        Result := Result + dataset.FieldByName(campo).AsCurrency;
      end;
    end

    else if (dataIni <> 0) and (DataFim = 0) then
    begin
      if dataset.FieldByName(NomeCampoDataParaComparar).AsDateTime = dataIgual
      then
        Result := Result + dataset.FieldByName(campo).AsCurrency;
    end

    else if (dataIni = 0) and (DataFim = 0) and (dataIgual = 0) then
    begin
      Result := Result + dataset.FieldByName(campo).AsCurrency;
    end;

    dataset.Next;
  end;
  dataset.First;
  dataset.MoveBy(RecNo - 1);
  dataset.EnableControls;

end;

function Tfuncoes.Procura_em_Multiplos_Campos(var data_set: TIBQuery;
  Campo_separados_por_espaco, valorParaComparar: string): boolean;
var
  i: integer;
var
  b, acc: string;
begin
  Result := False;
  if StrToInt(ContaChar(Campo_separados_por_espaco, ' ')) > 0 then
  begin
    while Campo_separados_por_espaco <> '' do
    begin
      if StrToInt(ContaChar(Campo_separados_por_espaco, ' ')) > 0 then
      begin
        acc := (copy(Campo_separados_por_espaco, 1,
          pos(' ', Campo_separados_por_espaco) - 1));
        Campo_separados_por_espaco := copy(Campo_separados_por_espaco,
          pos(' ', Campo_separados_por_espaco) + 1,
          length(Campo_separados_por_espaco));
      end
      else
      begin
        acc := Campo_separados_por_espaco;
        Campo_separados_por_espaco := '';
      end;
      // ShowMessage(acc);
      if Contido(valorParaComparar, data_set.FieldByName(acc).AsVariant) then
        Result := true;
    end;
  end
  else if Contido(valorParaComparar,
    data_set.FieldByName(Campo_separados_por_espaco).AsVariant) then
    Result := true;
end;

function Tfuncoes.procuraMultiplos(entradaDataset: string;
  valorParaComarar: string): boolean;
var
  i: integer;
var
  b, acc: string;
begin
  if StrToInt(ContaChar(valorParaComarar, ' ')) > 0 then
  begin
    for i := 0 to StrToInt(ContaChar(valorParaComarar, ' ')) do
    begin
      if StrToInt(ContaChar(valorParaComarar, ' ')) > 0 then
      begin
        acc := (copy(valorParaComarar, 1, pos(' ', valorParaComarar) - 1));
        valorParaComarar := copy(valorParaComarar, pos(' ', valorParaComarar) +
          1, length(valorParaComarar));
      end
      else
        acc := valorParaComarar;
      if pos(acc, entradaDataset) > 0 then
        Result := true
      else
        Result := False;
    end;
  end
  else
  begin
    if Contido(valorParaComarar, entradaDataset) then
      Result := true
    else
      Result := False;
  end;
end;

function Tfuncoes.busca(var dataset: TIBQuery; busca: string; retorno: string;
  campobusca: string; camposdataset: string): string;
var
  i: integer;
  lab: TLabel;
  Panel1: TPanel;
begin
  form33 := tform33.Create(self);
  CtrlResize(TForm(form33));
  form33.campobusca := campobusca;
  form33.campolocalizaca := retorno;
  form33.CAMPOS := camposdataset;
  FormataCampos(dataset, 2, '', 2);

  form33.DataSource1.dataset := dataset;
  if campobusca = 'item_entradaV' then
  begin
    form33.caption :=
      'Revisar Produtos De Entrada |F2 - Marcar | F6 - Desmarcar Todos';
  end;

  form33.DataSource1.dataset := dataset;
  if UpperCase(campobusca) = 'CODMOV' then
  begin
    Panel1 := TPanel.Create(form33);
    Panel1.Height := 50;
    Panel1.Font.Style := [fsbold];
    Panel1.Font.Height := 18;
    Panel1.caption := 'I - Imprime,  T - Total';;
    Panel1.Parent := form33;
    form33.DBGrid1.Align := alClient;
    Panel1.Align := alBottom;

    { form33.DBGrid1.Align := alTop;
      form33.DBGrid1.Height := form33.Height - 50;

      lab := TLabel.Create(form33);
      lab.Parent := form33;
      lab.Top := form33.DBGrid1.Height + 5;
      lab.Left := 10;
      lab.Caption := 'I - Imprime,  T - Total';
      lab.Font.Style := [fsbold]; }
  end;
  form33.ShowModal;

  if UpperCase(campobusca) = 'CODMOV' then
    Panel1.Free;
  dataset.Close;
  Result := retornobusca;
  form33.Free;
  // a.Close;
  // a.free;
end;

function Tfuncoes.localizar(titulo: string; tabela: string; CAMPOS: string;
  retorno: string; esconde: string; localizarPor: string; OrdenarPor: string;
  editLocaliza: boolean; editavel: boolean; deletar: boolean; condicao: string;
  tamanho: integer; compnenteAlinhar: TObject): string;
var
  pRect: TRect;
begin
  // Form7 := Tform7.Create(self);
  form7.Width := 365;
  form7.Height := 230;

  if tamanho <> 0 then
    form7.Width := tamanho;
  // alinhar em baixo do componente
  if compnenteAlinhar <> nil then
  begin
    if tabela = 'contaspagar' then
    begin
      form7.Position := poScreenCenter;
    end
    else
    begin
      GetWindowRect(tedit(compnenteAlinhar).Handle, pRect);
      pRect.Top := pRect.Top + 21;
      form7.Top := pRect.Top;
      if pRect.Left + form7.Width > screen.Width then
        form7.Left := screen.Width - form7.Width
      else
        form7.Left := pRect.Left;
    end;
  end
  else
  begin
    form7.Position := poScreenCenter;
  end;

  form7.campoLocate := '';
  form7.keyLocate := '';
  form7.tabela := tabela;
  form7.CAMPOS := CAMPOS;
  form7.caption := titulo;
  form7.campolocaliza := localizarPor;
  form7.ordem := OrdenarPor;
  form7.retorno := retorno;
  form7.editalvel := editavel;
  form7.deletar := deletar;
  form7.Formulario := self;
  form7.esconde := esconde;
  form7.condicao := condicao;
  if editLocaliza = False then
  begin
    form7.editLocaliza := False;
    form7.label1.Visible := False;
    form7.Edit1.Visible := False;
    form7.DBGrid1.Top := 1;
    form7.DBGrid1.Height := form7.DBGrid1.Height + 30;
  end
  else
  begin
    form7.editLocaliza := true;
    form7.editLocaliza := true;
    form7.label1.Visible := true;
    form7.Edit1.Visible := true;
  end;

  if tabela = 'contaspagar' then
  begin
    form7.Panel1.Visible := true;
    form7.editLocaliza := true;
    form7.label1.Visible := true;
    form7.Edit1.Visible := true;
  end;
  // Form7.Visible := true;

  if form7.Visible then
  begin
    form7.Visible := False;
    form7.Close;
  end;

  form7.ShowModal;
  // Form7.Show;
  // Form7.Free;
  Result := retornoLocalizar;
  retornoLocalizar := '';
end;

function Tfuncoes.localizar1(titulo: string; tabela: string; CAMPOS: string;
  retorno: string; esconde: string; localizarPor: string; OrdenarPor: string;
  editLocaliza: boolean; editavel: boolean; deletar: boolean;
  campoLocate: string; keyLocate: String; tamanho: integer;
  compnenteAlinhar: TObject): string;
var
  pRect: TRect;
begin
  // Form7 := Tform7.Create(self);
  if tamanho <> 0 then
    form7.Width := tamanho;
  // alinhar em baixo do componente
  if compnenteAlinhar <> nil then
  begin
    GetWindowRect(tedit(compnenteAlinhar).Handle, pRect);
    pRect.Top := pRect.Top + 21;
    form7.Top := pRect.Top;
    if pRect.Left + form7.Width > screen.Width then
      form7.Left := screen.Width - form7.Width
    else
      form7.Left := pRect.Left;
  end
  else
  begin
    form7.Position := poScreenCenter;
  end;
  form7.tabela := tabela;

  funcoes.aumentaFonte(form7, true, 0, true);

  form7.CAMPOS := CAMPOS;
  form7.caption := titulo;
  form7.campolocaliza := localizarPor;
  form7.ordem := OrdenarPor;
  form7.retorno := retorno;
  form7.editalvel := editavel;
  form7.deletar := deletar;
  form7.Formulario := self;
  form7.esconde := esconde;
  form7.campoLocate := campoLocate;
  form7.keyLocate := keyLocate;
  { if not(editLocaliza) then
    begin
    Form7.editLocaliza := true;
    Form7.label1.Visible := false;
    Form7.Edit1.Visible := false;
    //Form7.DBGrid1.Top := 1;
    //Form7.DBGrid1.Height := Form7.DBGrid1.Height + 30;
    Form7.DBGrid1.Align := alClient;
    end
    else
    begin
    Form7.editLocaliza   := false;
    Form7.label1.Visible := true;
    Form7.Edit1.Visible  := true;
    end; }

  if (editLocaliza) then
  begin
    form7.editLocaliza := true;
    form7.label1.Visible := true;
    form7.Edit1.Visible := true;
    form7.Panel1.Visible := true;
    // Form7.DBGrid1.Top := 1;
    // Form7.DBGrid1.Height := Form7.DBGrid1.Height + 30;
  end
  else
  begin
    form7.editLocaliza := False;
    form7.label1.Visible := False;
    form7.Edit1.Visible := False;
    form7.Panel1.Visible := False;
    form7.DBGrid1.Align := alClient;
  end;

  if UpperCase(tabela) = 'PRODUTO' then begin
    form7.campoLocate := 'cod';
    form7.keyLocate   := codUlt;
  end;

  form7.ShowModal;
  if UpperCase(tabela) = 'PRODUTO' then begin
    codUlt := retornoLocalizar;
  end;

  // Form7.Free;
  Result := retornoLocalizar;
  retornoLocalizar := '';
end;

procedure Tfuncoes.ResizeForms;
var
  i: integer;
begin
  for i := 0 to Application.ComponentCount - 1 do
  begin
    if Assigned(Application.Components[i]) then
    begin
      // if Application.Components[i] is TForm then CtrlResize(tform(Application.Components[i].GetParentComponent));
    end;
  end;
end;

procedure Tfuncoes.CharSetRichEdit(var rich: TRichEdit; tipo: integer = 0);
var
  i: Longint;
begin
  if tipo = 0 then
    rich.Font.Name := 'Terminal'
  else
    rich.Font.Name := 'Courier New';
  rich.Font.Size := 9;
  rich.Font.Charset := OEM_CHARSET;
  rich.DefAttributes.Name := 'Terminal';
  rich.DefAttributes.Size := 9;
  rich.DefAttributes.Charset := OEM_CHARSET;
  rich.SelAttributes := rich.DefAttributes;
  i := SendMessage(rich.Handle, EM_GETLANGOPTIONS, 0, 0);
  i := i and not IMF_AUTOFONT;
  SendMessage(rich.Handle, EM_SETLANGOPTIONS, 0, i);
end;

function Tfuncoes.PosFinal(substr: string; texto: string): integer;
var
  a, b: integer;
var
  retorno: string;
begin
  b := 0;
  Result := 0;
  for a := length(texto) downto 1 do
  begin
    if (texto[a] = substr) and (b = 0) then
    begin
      Result := a;
      b := 1;
    end;
  end;
end;

function PosFinal(substr: string; texto: string): integer;
var
  a, b: integer;
var
  retorno: string;
begin
  b := 0;
  Result := 0;
  for a := length(texto) downto 1 do
  begin
    if (texto[a] = substr) and (b = 0) then
    begin
      Result := a;
      b := 1;
    end;
  end;
end;

function Tfuncoes.ContaChar(estring: string; sub: string): string;
var
  i: integer;
begin
  Result := '0';
  i := 1;
  while pos(sub, estring) > 0 do
  begin
    Result := IntToStr(StrToInt(Result) + 1);
    i := pos(sub, estring);
    estring := copy(estring, i + 1, length(estring));
  end;
end;

Function Tfuncoes.ConverteNumerico(valor: string): string;
var
  i: integer;
begin
  // valor:=FormatCurr('##.###0.00',strtocurr(valor));
  if (valor <> '') then
  begin
    for i := 1 to length(valor) do
    begin
      if (valor[i] = '.') and not((i = length(valor) - 1) or
        (i = length(valor) - 2) or (i = length(valor) - 3)) then
        Delete(valor, i, 1);
      if (valor[i] = '.') and
        ((i = length(valor) - 1) or (i = length(valor) - 2) or
        (i = length(valor) - 3)) then
        valor[i] := ',';
    end;
    Result := valor;
  end
  else
    Result := '0';
end;

procedure Tfuncoes.FormataCampos(query: TIBQuery; qtdCasasDecimais: integer;
  CampoFormatoDiferente: string; qtd: integer);
var
  a: integer;
begin
  a := 0;

  while a <> query.FieldCount do
  begin
    if (FieldTypeNames[query.Fields.Fields[a].DataType] = 'BCD') and
      (query.Fields[a].FieldName <> CampoFormatoDiferente) then
    begin
      TCurrencyField(query.FieldByName(query.Fields[a].FieldName)).DisplayFormat
        := '###,##0.' + CompletaOuRepete('', '', '0', qtdCasasDecimais);
    end;
    if (FieldTypeNames[query.Fields.Fields[a].DataType] = 'BCD') and
      (query.Fields[a].FieldName = CampoFormatoDiferente) then
    begin
      TCurrencyField(query.FieldByName(query.Fields[a].FieldName)).DisplayFormat
        := '###,##0.' + CompletaOuRepete('', '', '0', qtd);
    end;
    a := a + 1;
  end;
end;

procedure Tfuncoes.OrdenaCamposVenda(CAMPOS: string);
var
  i, fim: integer;
var
  nomeCampo: tstringList;
begin
  i := 1;
  nomeCampo := tstringList.Create;
  nomeCampo.Add('0=cod');
  nomeCampo.Add('1=descricao');
  nomeCampo.Add('2=preco');
  nomeCampo.Add('3=estoque');
  nomeCampo.Add('4=unid');
  nomeCampo.Add('5=codbar');
  nomeCampo.Add('6=aplicacao');
  nomeCampo.Add('7=' + refori1);
  nomeCampo.Add('8=localizacao');
  nomeCampo.Add('9=deposito');

  fim := length(CAMPOS) + 1;

  while i <> fim do
  begin
    try
      dm.produto.FieldByName(nomeCampo.Values[CAMPOS[i]]).index := i;
    except
    end;
    i := i + 1;
  end;

  nomeCampo.Free;
end;

function Tfuncoes.BuscaNomeBD(var query: TIBQuery; nomeCampo: string;
  NomeTabela: string; condicao: string): string;
begin
  query.SQL.Clear;
  query.SQL.Add('select ' + nomeCampo + ' from ' + NomeTabela + ' ' + condicao);
  try
    query.Open;
  except
  end;

  if query.IsEmpty then
    Result := 'Desconhecido'
  else
    Result := query.FieldByName(nomeCampo).AsString;
  query.Close;
end;

function Tfuncoes.PerguntasRel(var query: TIBQuery; paramper: string;
  paramverifica: boolean; valorbd: string; valorstring: string): boolean;
// var grupo,fornec,fabric:string;
var
  test: boolean;
begin
  if not(paramverifica) then
  begin
    if Contido('1', paramper) then
      form2.grupo := funcoes.dialogo('generico', 100, '1234567890' + #8, 100,
        False, '', 'Control For Windows',
        'Se Deseja Separação por GRUPO, Informe um Cód.:', '');
    if Contido('2', paramper) then
      if form2.grupo <> '*' then
        form2.fornec := funcoes.dialogo('generico', 100, '1234567890' + #8, 100,
          False, '', 'Control For Windows',
          'Se Deseja Separação por FORNECEDOR, Informe um Cód.:', '');
    if Contido('3', paramper) then
      if not Contido('*', form2.grupo + form2.fornec) then
        form2.fabric := funcoes.dialogo('generico', 100, '1234567890' + #8, 100,
          False, '', 'Control For Windows',
          'Se Deseja Separação por FABRICANTE, Informe um Cód.:', '');
  end
  else
  begin
    if not Contido('*', form2.fabric + form2.fornec + form2.grupo) and paramverifica
    then
    begin
      Result := true;
      if Contido('3', paramper) then
      begin
        if (form2.fabric <> '') then
        begin
          if query.FieldByName('fabric').AsString = form2.fabric then
          begin
            Result := true;
          end
          else
          begin
            Result := False;
          end;
        end;
      end;
    end;

    if Contido('1', paramper) then
    begin
      if Result then
      begin
        if (form2.grupo <> '') then
        begin
          if query.FieldByName('grupo').AsString = form2.grupo then
          begin
            Result := true;
          end
          else
          begin
            Result := False;
          end;
        end;
      end;
    end;

    if Contido('2', paramper) then
    begin
      if Result then
      begin
        if (form2.fornec <> '') then
        begin
          if query.FieldByName('fornec').AsString = form2.fornec then
          begin
            Result := true;
          end
          else
          begin
            Result := False;
            test := False;
          end;
        end;

      end;
    end;

    if paramper = '' then
    begin
      if (form2.fornec = '') and (form2.fabric = '') and (form2.grupo = '') then
      begin
        Result := true;
      end;
    end;
  end;
end;

function Tfuncoes.Contido(substring: string; texto: string): boolean;
begin
  if pos(substring, texto) > 0 then
    Result := true
  else
    Result := False;
end;

function Contido(substring: string; texto: string): boolean;
begin
  if pos(substring, texto) > 0 then
    Result := true
  else
    Result := False;
end;

procedure Tfuncoes.ExecFile(F: String);
var
  r: String;
begin
  case ShellExecute(Handle, nil, PChar(F), nil, nil, SW_SHOWNORMAL) of
    ERROR_FILE_NOT_FOUND:
      r := 'The specified file was not found.';
    ERROR_PATH_NOT_FOUND:
      r := 'The specified path was not found.';
    ERROR_BAD_FORMAT:
      r := 'The .EXE file is invalid (non-Win32 .EXE or error in .EXE image).';
    SE_ERR_ACCESSDENIED:
      r := 'Windows 95 only: The operating system denied access to the specified file.';
    SE_ERR_ASSOCINCOMPLETE:
      r := 'The filename association is incomplete or invalid.';
    SE_ERR_DDEBUSY:
      r := 'The DDE transaction could not be completed because other DDE transactions were being processed.';
    SE_ERR_DDEFAIL:
      r := 'The DDE transaction failed.';
    SE_ERR_DDETIMEOUT:
      r := 'The DDE transaction could not be completed because the request timed out.';
    SE_ERR_DLLNOTFOUND:
      r := 'Windows 95 only: The specified dynamic-link library was not found.';
    SE_ERR_NOASSOC:
      r := 'There is no application associated with the given filename extension.';
    SE_ERR_OOM:
      r := 'Windows 95 only: There was not enough memory to complete the operation.';
    SE_ERR_SHARE:
      r := 'A sharing violation occurred.';
  else
    exit;
  end;
end;

function Tfuncoes.grelatoriocima(SQLGrupo: string; SQLFornec: string;
  SQLFabric: string; SQLCom2Filtros: string; SQLSemFiltros: string;
  cabecalho: string; NomeDaEmpresa: string; NomeDoRelatorio: string;
  colunas: string): boolean;
var
  grupo, fornec, fabric: string;
begin
  grupo := funcoes.dialogo('generico', 0, '1234567890' + #8, 0, False, '',
    'Control For Windows',
    'Se Deseja Separação por GRUPO, Informe um Cód.:', '');
  if grupo <> '*' then
    fornec := funcoes.dialogo('generico', 0, '1234567890' + #8, 0, False, '',
      'Control For Windows',
      'Se Deseja Separação por FORNECEDOR, Informe um Cód.:', '');
  if not Contido('*', grupo + fornec) and (SQLFabric <> '') then
    fabric := funcoes.dialogo('generico', 0, '1234567890' + #8, 0, False, '',
      'Control For Windows',
      'Se Deseja Separação por FABRICANTE, Informe um Cód.:', '');
  // funcoes.GeraRelatorio('tabela','a');

  // verifica se o grupo nao é branco para poder filtrar por grupo
  if (grupo <> '') and (fornec = '') and
    not Contido('*', fornec + grupo + fabric) then
  begin
    dm.ProdutoQY.SQL.Clear;
    dm.ProdutoQY.SQL.Add(SQLGrupo);
    dm.ProdutoQY.ParamByName('grupo').AsInteger := StrToInt(grupo);
    dm.ProdutoQY.Open;
  end;

  if (fornec <> '') and (grupo = '') and
    not Contido('*', fornec + grupo + fabric) then
  begin
    dm.ProdutoQY.SQL.Clear;
    dm.ProdutoQY.SQL.Add(SQLFornec);
    dm.ProdutoQY.ParamByName('fornec').AsInteger := StrToInt(fornec);
    dm.ProdutoQY.Open;
  end;

  if (fabric <> '') and (grupo = '') and (fornec = '') and
    not Contido('*', fornec + grupo + fabric) then
  begin
    dm.ProdutoQY.SQL.Clear;
    dm.ProdutoQY.SQL.Add(SQLFabric);
    dm.ProdutoQY.ParamByName('fabric').AsInteger := StrToInt(fornec);
    dm.ProdutoQY.Open;
  end;

  if (fornec <> '') and (grupo <> '') and (fabric <> '') and
    not Contido('*', fornec + grupo + fabric) then
  begin
    dm.ProdutoQY.SQL.Clear;
    dm.ProdutoQY.SQL.Add(SQLCom2Filtros);
    dm.ProdutoQY.ParamByName('grupo').AsInteger := StrToInt(grupo);
    dm.ProdutoQY.ParamByName('fornec').AsInteger := StrToInt(fornec);
    dm.ProdutoQY.Open;
  end;

  if (fornec = '') and (grupo = '') and (fabric = '') then
  begin
    dm.ProdutoQY.Close;
    dm.ProdutoQY.SQL.Clear;
    dm.ProdutoQY.SQL.Add(SQLSemFiltros);
    dm.ProdutoQY.Open;
  end;

  if not Contido('*', fornec + grupo + fabric) then
  begin
    dm.ProdutoQY.FetchAll;
    // form19.RichEdit1.Clear;
    if cabecalho <> '' then
    begin
      form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((cabecalho))));
    end
    else
    begin
      form19.RichEdit1.Perform(EM_REPLACESEL, 1,
        Longint(PChar((funcoes.RelatorioCabecalho(NomeDaEmpresa,
        NomeDoRelatorio, 80)))));
      if colunas <> '' then
      begin
        form19.RichEdit1.Perform(EM_REPLACESEL, 1,
          Longint(PChar((colunas + #13 + #10))));
        form19.RichEdit1.Perform(EM_REPLACESEL, 1,
          Longint(PChar((funcoes.CompletaOuRepete('', #13 + #10, '-', 80)))));
      end;
      // form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar(())));

    end;
  end;
  if Contido('*', fornec + grupo + fabric) then
    Result := true
  else
    Result := False;
end;

procedure Tfuncoes.ResizeLabel(var Sender: TLabel);
const
  iWidth = 800;
  iHeight = 600;
var
  i, b, wi, he: integer;
  totwi, tothe: double;
begin
  wi := screen.Width;
  he := screen.Height;

  totwi := wi / iWidth;
  tothe := he / iHeight;

  // sender.Width := trunc((totwi * sender.Width) + Sender.Width);//Round((TWinControl(Components[i]).Width * wi) div iWidth); //Canvas.TextWidth(TLabel(Components[i]).Caption);
  // sender.Height := trunc((tothe * sender.Height) + sender.Height);//Round((TWinControl(Components[i]).Height * he) div iHeight);  // Canvas.TextHeight(TLabel(Components[i]).Caption)+6;
  // b := TLabel(Components[i]).Font.Size;
  Sender.Font.Size := trunc(((totwi / tothe) * Sender.Font.Size));
  // trunc((totwi * b) + b);;// Round((b * Screen.Width) div iWidth);// Round(TWinControl(Components[i]).Width / (Screen.Width / iWidth));;

  // sender.Left := trunc((sender.Left * wi) div iWidth);//Round((TWinControl(Components[i]).Left * wi) div iWidth);
  // sender.Top := trunc((sender.Top * he) div iHeight);
end;

procedure Tfuncoes.CtrlResize(var Sender: TForm);
const
  iWidth = 800;
  iHeight = 600;
var
  i, b, wi, he: integer;
  totwi, tothe: double;
begin
  if buscaParamGeral(68, 'N') = 'S' then
    exit;

  wi := screen.Width;
  he := screen.Height;

  totwi := wi / iWidth;
  tothe := he / iHeight;

  with Sender do
  begin
    for i := 0 to ComponentCount - 1 do
    begin
      if Components[i] is TWinControl then
      begin
        TWinControl(Components[i]).Width :=
          trunc(TWinControl(Components[i]).Width * (wi / iWidth));
        TWinControl(Components[i]).Height :=
          round(TWinControl(Components[i]).Height * (he / iHeight));
        TWinControl(Components[i]).Left :=
          round(TWinControl(Components[i]).Left * (wi / iWidth));
        TWinControl(Components[i]).Top :=
          round(TWinControl(Components[i]).Top * (he / iHeight));
      end
      else
      begin
        if Components[i] is TLabel then
        begin
          TLabel(Components[i]).Width :=
            trunc((totwi / tothe) * TLabel(Components[i]).Width);
          // Round((TWinControl(Components[i]).Width * wi) div iWidth); //Canvas.TextWidth(TLabel(Components[i]).Caption);
          TLabel(Components[i]).Height :=
            trunc((totwi / tothe) * TLabel(Components[i]).Height);
          // Round((TWinControl(Components[i]).Height * he) div iHeight);  // Canvas.TextHeight(TLabel(Components[i]).Caption)+6;
          b := TLabel(Components[i]).Font.Size;
          TLabel(Components[i]).Font.Size := trunc((totwi / tothe) * b);
          // trunc((totwi * b) + b);;// Round((b * Screen.Width) div iWidth);// Round(TWinControl(Components[i]).Width / (Screen.Width / iWidth));;

          TLabel(Components[i]).Left :=
            trunc((TWinControl(Components[i]).Left * wi) div iWidth);
          // Round((TWinControl(Components[i]).Left * wi) div iWidth);
          TLabel(Components[i]).Top :=
            trunc((TWinControl(Components[i]).Top * he) div iHeight);
          TLabel(Components[i]).Update;
        end;
        Sender.Refresh;
      end;
    end;

    Sender.Width := round(Sender.Width * (wi / iWidth));
    Sender.Height := round(Sender.Height * (he / iHeight));
    Sender.Top := round(Sender.Top * (screen.Height / iHeight));
    Sender.Left := round(Sender.Left * (wi / iWidth));
    Sender.Font.Size := round(Sender.Font.Size * (he / iHeight));

  end;
end;

function Tfuncoes.RelatorioCabecalho(NomeEmpresa: string; NomeRelatorio: string;
  tamanho: integer): string;
var
  v1: string;
begin
  v1 := CompletaOuRepete('', #13 + #10, '-', tamanho + 2);
  v1 := v1 + CompletaOuRepete(NomeEmpresa, 'DATA: ' + FormatDateTime('dd/mm/yy',
    form22.dataMov) + #13 + #10, ' ', tamanho + 2);
  v1 := v1 + CompletaOuRepete(NomeRelatorio, 'HORA: ' + FormatDateTime('tt',
    now) + #13 + #10, ' ', tamanho + 2);
  v1 := v1 + CompletaOuRepete('', #13 + #10, '-', tamanho + 2);
  Result := v1;
end;

function Tfuncoes.CompletaOuRepete(const valorParaCompletar: AnsiString;
  const ValorFinal: AnsiString; valorParaRepetir: string;
  contadorDeRepeticao: integer): string;
var
  i: integer;
var
  acc: string;
begin
  if length(valorParaCompletar + ValorFinal) <= contadorDeRepeticao then
  begin
    i := length(ValorFinal);
    acc := '';
    if valorParaCompletar = '' then
    begin
      while i < contadorDeRepeticao do
      begin
        try
          acc := acc + valorParaRepetir;
        except
        end;
        i := i + 1;
      end;
      if ValorFinal <> '' then
        Result := acc + ValorFinal
      else
        Result := acc;
    end
    else
    begin
      i := length(valorParaCompletar) + length(ValorFinal);
      acc := valorParaCompletar;
      while i < contadorDeRepeticao do
      begin
        i := i + 1;
        try
          acc := acc + valorParaRepetir;
        except
        end;
      end;
      if ValorFinal <> '' then
        Result := acc + ValorFinal
      else
        Result := acc;
    end;
  end
  else
  begin
    acc := funcoes.CompletaOuRepete('', '', '*', contadorDeRepeticao);
    // '*****';
    /// acc := valorParaCompletar + acc + ValorFinal;
    i := length(acc);
    while i < contadorDeRepeticao do
    begin
      i := i + 1;
      try
        acc := acc + valorParaRepetir;
      except
      end;
    end;
    Result := acc;
  end;
end;

function CompletaOuRepete(const valorParaCompletar: AnsiString;
  const ValorFinal: AnsiString; valorParaRepetir: string;
  contadorDeRepeticao: integer): string;
var
  i: integer;
var
  acc: string;
begin
  if length(valorParaCompletar + ValorFinal) <= contadorDeRepeticao then
  begin
    i := length(ValorFinal);
    acc := '';
    if valorParaCompletar = '' then
    begin
      while i < contadorDeRepeticao do
      begin
        try
          acc := acc + valorParaRepetir;
        except
        end;
        i := i + 1;
      end;
      if ValorFinal <> '' then
        Result := acc + ValorFinal
      else
        Result := acc;
    end
    else
    begin
      i := length(valorParaCompletar) + length(ValorFinal);
      acc := valorParaCompletar;
      while i < contadorDeRepeticao do
      begin
        i := i + 1;
        try
          acc := acc + valorParaRepetir;
        except
        end;
      end;
      if ValorFinal <> '' then
        Result := acc + ValorFinal
      else
        Result := acc;
    end;
  end
  else
  begin
    acc := funcoes.CompletaOuRepete('', '', '*', contadorDeRepeticao);
    // '*****';
    /// acc := valorParaCompletar + acc + ValorFinal;
    i := length(acc);
    while i < contadorDeRepeticao do
    begin
      i := i + 1;
      try
        acc := acc + valorParaRepetir;
      except
      end;
    end;
    Result := acc;
  end;
end;

function Tfuncoes.LerFormPato(index: integer; label1: string; escSair: boolean;
  const padrao: string = ''): string;
begin
  form18 := tform18.Create(self);
  form18.option := 0;
  form18.escSair := escSair;
  if label1 = '' then
  begin
    form18.label1.Visible := False;
    form18.ListBox1.Align := alClient;
  end
  else
  begin
    form18.label1.caption := label1;
  end;
  funcoes.CtrlResize(TForm(form18));
  funcoes.ResizeLabel(form18.label1);
  form18.valorlistbox := index;
  form18.padrao := padrao;
  form18.ShowModal;
  form18.Free;
  Result := formpato;
end;

procedure informacao(posicao: integer; total: integer; informacao: string;
  novo: boolean; fechar: boolean; valorprogressao: integer);
begin
  if novo then
  begin
    form23.label1.caption := informacao;
    form23.Show;
    form23.ProgressBar1.Position := 0;
    form23.ProgressBar1.Max := 100;
    form23.vezes := valorprogressao;
    exit;
  end;

  if fechar then
  begin
    form23.Close;
    exit;
  end;

  Application.ProcessMessages;
  if trunc(posicao / (total / 100)) >= form23.vezes then
  begin
    form23.ProgressBar1.Position := trunc(posicao / (total / 100));
    form23.vezes := form23.vezes + valorprogressao;
  end;
  // form23.Update;
  // form23.Refresh;
end;

procedure Tfuncoes.informacao(posicao: integer; total: integer;
  informacao: string; novo: boolean; fechar: boolean; valorprogressao: integer);
begin
  if novo then
  begin
    form23.label1.caption := informacao;
    form23.Show;
    form23.ProgressBar1.Position := 0;
    form23.ProgressBar1.Max := 100;
    form23.vezes := valorprogressao;
    exit;
  end;

  if fechar then
  begin
    form23.Close;
    exit;
  end;

  Application.ProcessMessages;
  if trunc(posicao / (total / 100)) >= form23.vezes then
  begin
    form23.ProgressBar1.Position := trunc(posicao / (total / 100));
    form23.vezes := form23.vezes + valorprogressao;
  end;
  // form23.Update;
  // form23.Refresh;
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

function Tfuncoes.dialogo(tipo: string; maxlengt: integer; ValorEntrada: string;
  tamanhocampo: integer; obrigatorio1: boolean; trocaletras: string;
  titulo: string; label1: string; default: string): string;
begin
  // se TIPO = NORMAL entao maxlength sera o minimo de caracteres que ira aceitar

  if (tipo = 'generico') and (Contido('1234567890', ValorEntrada)) then
  begin
    if maxlengt <= 100 then
      maxlengt := 100;
    if tamanhocampo <= 100 then
      tamanhocampo := 100;
  end;

  //if NOT Assigned(pergunta1) then
  pergunta1 := Tpergunta1.Create(self);
  pergunta1.gauge1.Visible := False;
  pergunta1.option := 1;
  pergunta1.maxlengt := maxlengt;
  pergunta1.obrigatorio := obrigatorio1;
  pergunta1.caption := titulo;
  pergunta1.valorPadrao := default;
  pergunta1.valorLabel := label1;
  pergunta1.tempo := true;
  if tamanhocampo = 0 then
    pergunta1.tamanhoEdit := 0
  else
    pergunta1.tamanhoEdit := tamanhocampo;
  pergunta1.botoes := trocaletras;
  pergunta1.tipo := tipo;
  pergunta1.valorTecla := ValorEntrada;
  pergunta1.ShowModal;
  if tipo = 'numero' then
    valordg := ConverteNumerico(valordg);
  Result := valordg;
  valordg := '';
  TRY
  //pergunta1.DestroyComponents;
  //pergunta1.Destroy;
  //pergunta1.Free;
  FINALLY

  END;
end;

function dialogo(tipo: string; maxlengt: integer; ValorEntrada: string;
  tamanhocampo: integer; obrigatorio1: boolean; trocaletras: string;
  titulo: string; label1: string; default: string): string;
begin
  // se TIPO = NORMAL entao maxlength sera o minimo de caracteres que ira aceitar
  pergunta1 := Tpergunta1.Create(Application);
  pergunta1.gauge1.Visible := False;
  pergunta1.option := 1;
  pergunta1.maxlengt := maxlengt;
  pergunta1.obrigatorio := obrigatorio1;
  pergunta1.caption := titulo;
  pergunta1.valorPadrao := default;
  pergunta1.valorLabel := label1;
  pergunta1.tempo := true;
  if tamanhocampo = 0 then
    pergunta1.tamanhoEdit := 0
  else
    pergunta1.tamanhoEdit := tamanhocampo;
  pergunta1.botoes := trocaletras;
  pergunta1.tipo := tipo;
  pergunta1.valorTecla := ValorEntrada;
  pergunta1.ShowModal;
  if tipo = 'numero' then
    funcoes.valordg := ConverteNumerico(funcoes.valordg);
  Result := funcoes.valordg;
  funcoes.valordg := '';
  pergunta1.DestroyComponents;
  pergunta1.Destroy;
end;

function Tfuncoes.TiraOuTrocaSubstring(StringDeEntrada: string;
  ValorTrocar: string; ValorQSeraSubstituido: string): string;
begin
  Result := StringReplace(StringDeEntrada, ValorTrocar,
    ValorQSeraSubstituido, []);
end;

function Tfuncoes.LerIni(valor: string): string;
var
  arq: TIniFile;
var
  base: string;
begin
  base := GetCurrentDir;
  base := base + '\config.ini';
  arq := TIniFile.Create(base);
  Result := arq.ReadString('CONFIG', valor, '');
  arq.Free;
end;

function Tfuncoes.LerIniToStringList: tstringList;
var
  arq: TIniFile;
var
  base: string;
var
  arr: tstringList;
begin
  arr := tstringList.Create;
  base := GetCurrentDir;
  base := base + '\config.ini';
  arq := TIniFile.Create(base);

  arq.ReadSectionValues('CONFIG', arr);

  arq.Free;
end;

function Tfuncoes.LerValorPGerais(nomeConfig: string; arr: tstringList): string;
begin
  Result := arr.Values[nomeConfig];
end;

function Tfuncoes.VerSeExisteConfig: boolean;
var
  arq: TIniFile;
var
  base: string;
begin
  base := GetCurrentDir;
  base := base + '\config.ini';
  arq := TIniFile.Create(base);

  Result := arq.SectionExists('CONFIG');
  arq.Free;
end;

function Tfuncoes.ArredondaFinanceiro(Value: currency; Decimals: integer)
  : currency;
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

function Tfuncoes.ArredondaTrunca(Value: currency; decimais: integer): Extended;
begin
  Result := Trunca(Value, decimais);
  exit;

  if decimais = 2 then
    Result := trunc(Value * 100) / 100
  else
    Result := trunc(Value * 1000) / 1000;
end;

function Tfuncoes.novocod(gen: string): string;
begin
  dm.IBQuery1.SQL.Clear;
  dm.IBQuery1.SQL.Add('select gen_id(' + gen + ',1) as cod from RDB$DATABASE');
  dm.IBQuery1.Open;
  Result := dm.IBQuery1.FieldByName('cod').AsString;
  dm.IBQuery1.Close;
  dm.IBQuery1.SQL.Clear;
end;

function Tfuncoes.PreparaData(valor: string): TDateTime;
var
  dat: TDateTime;
begin
  dat := StrToDate(valor);
  valor := FormatDateTime('dd/mm/yyyy', dat);
  Result := StrToDateTime(valor);
end;

procedure Tfuncoes.FormCreate(Sender: TObject);
begin
  saiComEnter := true;
  Simbolos[1] :=
    'ABCDEFGHIJLMNOPQRSTUVXZYWK abcdefghijlmnopqrstuvxzywk1234567890-+=_?/.,<>;:)(*&^%$#@!~áäà';
  Simbolos[2] :=
    'ÂÀ©Øû×ƒçêùÿ5Üø£úñÑªº¿®¬¼ëèïÙýÄÅÉæÆôÁáâäàåíóÇüé¾¶§÷ÎÏ-+ÌÓß¸°¨·¹³²Õµþîì¡«½WDX2U3BHJKMSZDTQ4';
  // WebBrowser1.Navigate('http://www.slashmanxd.xpg.com.br/emp.txt');

  { if ConfParamGerais[5] = 'S' then //usar recursos de Auto Peças
    begin                          // Gera CDS temporários de equivalências
    Timer1.Enabled := true;
    end; }
  enviandoCupom := False;
  enviandoBackup := False;
  inicio1 := 1;
end;

procedure Tfuncoes.WebBrowser1DocumentComplete(Sender: TObject;
  const pDisp: IDispatch; var URL: OleVariant);
begin
  Timer2.Enabled := False;
  //funcoes.Mensagem(Application.Title, '', 15, '',False, 0, clBlack, true);
end;

procedure Tfuncoes.Timer1Timer(Sender: TObject);
begin
  Timer1.Enabled := False;
  // abreDataSetMemoriaEquivalencias();
end;

function Tfuncoes.checaCodbar1(vx_cod: String): String;
var
  ut: string;
  vx_ta, vx_soma, vx_ret, vx_i: integer;
  vx_cal: variant;
begin
  Result := '';
  try
    ut := vx_cod;
    vx_cod := copy(vx_cod, 1, 12);
    vx_ta := length(vx_cod);
    vx_soma := 0;
    vx_ret := 0;
    if length(vx_cod) <> 12 then
    begin
      exit;
    end;

    FOR vx_i := 1 TO vx_ta do
    begin
      vx_cal := StrToInt(copy(vx_cod, vx_i, 1));

      IF (vx_i mod 2) = 0 then
        vx_cal := vx_cal * 3;
      vx_soma := vx_soma + vx_cal;
    end;

    WHILE (vx_soma / 10 <> trunc(vx_soma / 10)) do
    begin
      vx_ret := vx_ret + 1;
      vx_soma := vx_soma + 1;
    end;

    vx_cod := (trim(vx_cod) + trim(IntToStr(vx_ret)));

    if vx_cod = ut then
      Result := 'T';
  except
  end;
end;

function Tfuncoes.allTrim(const texto: String): String;
begin
  Result := '';
  Result := StringReplace(texto, ' ', '', [rfReplaceAll, rfIgnoreCase]);
end;

procedure Tfuncoes.Timer3Timer(Sender: TObject);
begin
  buscaTimer := '';
  Timer3.Enabled := False;
end;

function Tfuncoes.verValorUnidade(unidade: String): currency;
begin
  if Contido('-' + unidade + '-', '-M2-M3-') then
  begin
    Result := 1;
    exit;
  end;

  Result := StrToCurrDef(strnum1(unidade), 1);
  if Result = 0 then
    Result := 1;
end;

function ACHA_CODCLIENTE(CPF_CNPJ: String): String;
begin
  Result := '';
  CPF_CNPJ := trim(CPF_CNPJ);
  if length(CPF_CNPJ) = 14 then
    CPF_CNPJ := formataCNPJ(CPF_CNPJ)
  else if length(CPF_CNPJ) = 11 then
    CPF_CNPJ := formataCPF(CPF_CNPJ)
  else
  begin
    exit;
  end;

  dm.IBQuery2.Close;
  dm.IBQuery2.SQL.text := 'select email, cod from cliente where cnpj = :cnpj';
  dm.IBQuery2.ParamByName('cnpj').AsString := CPF_CNPJ;
  dm.IBQuery2.Open;

  if dm.IBQuery2.IsEmpty then
  begin
    dm.IBQuery2.Close;
    exit;
  end;

  Result := dm.IBQuery2.FieldByName('cod').AsString;
  dm.IBQuery2.Close;
end;

function ACHA_CODFORNEC(CPF_CNPJ, UF: String): String;
begin
  Result := '000001';
  if length(CPF_CNPJ) = 14 then
    CPF_CNPJ := formataCNPJ(CPF_CNPJ)
  else if length(CPF_CNPJ) = 11 then
    CPF_CNPJ := formataCNPJ(CPF_CNPJ)
  else
  begin
    exit;
  end;

  dm.IBQuery2.Close;
  dm.IBQuery2.SQL.text := 'select cnpj, cod from fornecedor where cnpj = :cnpj';
  dm.IBQuery2.ParamByName('cnpj').AsString := CPF_CNPJ;
  dm.IBQuery2.Open;

  if dm.IBQuery2.IsEmpty then
  begin
    dm.IBQuery2.Close;
    exit;
  end;

  Result := dm.IBQuery2.FieldByName('cod').AsString;
  dm.IBQuery2.Close;
end;

procedure Tfuncoes.WriteToTXT(const arquivo, linha: string);
var
  F: TextFile;
begin
  AssignFile(F, arquivo);
  if not FileExists(arquivo) then
    Rewrite(F)
  else
    Append(F);
  Writeln(F, linha);
  CloseFile(F);
end;

function Tfuncoes.insereDadosAdic(const xml: String): Smallint;
var
  tipo, serie, cfop, tipofrete, fornec: string;
  fe, te: tstringList;
  TOTvICMSDeson_Produtos: currency;
begin
  Result := 0;
  /// verFornecedorStringList
  fe := funcoes.dadosAdicSped(xml);
  fe[10] := copy(StrNum(fe[10]), 1, 44);

  dm.IBselect.Close;
  dm.IBselect.SQL.text :=
    'select CHAVENFE from SPEDDADOSADIC where CHAVENFE = :cod';
  dm.IBselect.ParamByName('cod').AsString := StrNum(fe[10]);
  dm.IBselect.Open;

  if not dm.IBselect.IsEmpty then
  begin
    Result := 1;
    MessageDlg('Já Existe Dados Adicionais com essa Chave.', mtError,
      [mbok], 0);
    dm.IBselect.Close;
    fe.Free;
    exit;
  end;

  dm.IBselect.Close;
  tipo := Le_Nodo('emit', xml);
  tipo := IfThen(Contido('CNPJ', tipo), Le_Nodo('CNPJ', tipo),
    Le_Nodo('CPF', tipo));

  fornec := cadastraFornec(xml);

  dm.IBQuery1.Close;
  dm.IBQuery1.SQL.Clear;
  dm.IBQuery1.SQL.Add
    ('update or insert into SPEDDADOSADIC(nota, fornec, tipo, serie, cfop, tipofrete, totseg, totdesc, TOTDESCNT'
    + ', TOTDESPACES, TOTPIS, TOTCONFINS, CREDICMS, CHAVENFE, TOTFRETE, TOTICMSST, TOTICMS_DESON) values(:nota, :fornec, :tipo, :serie, :cfop, :tipofrete, :totseg,'
    + ' :totdesc, :TOTDESCNT, :TOTDESPACES, :TOTPIS, :TOTCONFINS, :CREDICMS, :CHAVENFE, :TOTFRETE, :TOTICMSST, :TOTICMS_DESON) matching(CHAVENFE)');
  dm.IBQuery1.ParamByName('nota').AsString := fe[12];
  dm.IBQuery1.ParamByName('fornec').AsString := fornec;
  dm.IBQuery1.ParamByName('tipo').AsString := fe[0];
  dm.IBQuery1.ParamByName('serie').AsString := fe[1];
  dm.IBQuery1.ParamByName('cfop').AsString := fe[2];
  dm.IBQuery1.ParamByName('tipofrete').AsString := fe[3];
  dm.IBQuery1.ParamByName('totseg').AsCurrency := StrToCurr(fe[4]);
  dm.IBQuery1.ParamByName('totdesc').AsCurrency := StrToCurr(fe[5]);
  dm.IBQuery1.ParamByName('TOTDESCNT').AsCurrency := 0;
  dm.IBQuery1.ParamByName('TOTDESPACES').AsCurrency := StrToCurr(fe[6]) +
    StrToCurr(fe[15]);
  dm.IBQuery1.ParamByName('TOTPIS').AsCurrency := StrToCurr(fe[7]);
  dm.IBQuery1.ParamByName('TOTCONFINS').AsCurrency := StrToCurr(fe[8]);
  dm.IBQuery1.ParamByName('CREDICMS').AsCurrency := 0;
  dm.IBQuery1.ParamByName('CHAVENFE').AsString := StrNum(fe[10]);
  dm.IBQuery1.ParamByName('TOTFRETE').AsCurrency := StrToCurr(fe[11]);
  dm.IBQuery1.ParamByName('TOTICMSST').AsCurrency := StrToCurr(fe[13]);

  TOTvICMSDeson_Produtos := 0;
  if StrToCurrDef(fe[14], 0) > 0 then
  begin
    TOTvICMSDeson_Produtos := StrToCurrDef(fe[14], 0);
  end;

  dm.IBQuery1.ParamByName('TOTICMS_DESON').AsCurrency := TOTvICMSDeson_Produtos;
  dm.IBQuery1.ExecSQL;

  dm.IBQuery1.Transaction.Commit;

  ShowMessage('Dados Adicionais Inserido com Sucesso!' + #13 + 'Nota: ' + fe[12]
    + #13 + 'Fornec: ' + fornec + #13 + 'Tipo:' + fe[0] + #13 + 'Série: ' +
    fe[1] + #13 + 'CFOP: ' + fe[2] + #13 + 'Tipo Frete: ' + fe[3] + #13 +
    'Fornecedor: ' + fornec);
  fe.Free;
end;

function Tfuncoes.cadastraFornec(const xml: String): String;
var
  te: tstringList;
  cod: String;
begin
  te := verFornecedorStringList(xml);

  dm.IBselect.Close;
  dm.IBselect.SQL.Clear;
  dm.IBselect.SQL.Add('select cod from FORNECEDOR where cnpj = :cnpj');
  dm.IBselect.ParamByName('cnpj').AsString := te[0];
  dm.IBselect.Open;

  cod := '0';

  if not dm.IBselect.IsEmpty then
  begin
    cod := dm.IBselect.FieldByName('cod').AsString;
  end
  else
  begin
    cod := Incrementa_Generator('FORNECEDOR', 1);
  end;

  Result := cod;
  dm.IBselect.Close;

  dm.ibquery4.Close;
  dm.ibquery4.SQL.Clear;
  dm.ibquery4.SQL.Add
    ('update or insert into FORNECEDOR(cod, nome, endereco, cep, fone, cidade, estado, bairro, cnpj,'
    + 'ies, cod_mun, tipo) values(:cod, :nome, :endereco, :cep, :fone, :cidade, :estado, :bairro, :cnpj,'
    + ':ies, :cod_mun, :tipo)');
  dm.ibquery4.ParamByName('cod').AsString := cod;
  dm.ibquery4.ParamByName('nome').AsString := copy(te[1], 1, 40);
  dm.ibquery4.ParamByName('endereco').AsString := copy(te[3], 1, 40);
  dm.ibquery4.ParamByName('cep').AsString := copy(te[8], 1, 10);
  dm.ibquery4.ParamByName('fone').AsString := copy(te[11], 1, 14);
  dm.ibquery4.ParamByName('cidade').AsString := copy(te[6], 1, 14);
  dm.ibquery4.ParamByName('estado').AsString := te[7];
  dm.ibquery4.ParamByName('bairro').AsString := copy(te[4], 1, 25);
  dm.ibquery4.ParamByName('cnpj').AsString := te[0];
  dm.ibquery4.ParamByName('ies').AsString := copy(te[12], 1, 14);
  dm.ibquery4.ParamByName('cod_mun').AsString := te[5];
  dm.ibquery4.ParamByName('tipo').AsString := te[14];
  dm.ibquery4.ExecSQL;
  dm.ibquery4.Transaction.Commit;

  // reStartGenerator('fornecedor', StrToInt(cod));
  te.Free;
end;

function Tfuncoes.entraXMLeRetornaChave(ent: String): string;
var
  tmp: string;
begin
  tmp := Le_Nodo1('infNFe', ent);
  tmp := copy(tmp, pos('Id="', tmp) + 7, pos('">', tmp));
  tmp := copy(tmp, 1, pos('">', tmp) - 1);
  Result := '';
  Result := tmp;
end;

function Tfuncoes.acha_vendaCCF(const ccf_caixa: String): String;
begin
  Result := '';
  dm.IBselect.Close;
  dm.IBselect.SQL.text := 'select nota from venda where crc = :crc';
  dm.IBselect.ParamByName('crc').AsString := ccf_caixa;
  dm.IBselect.Open;

  if not dm.IBselect.IsEmpty then
    Result := dm.IBselect.FieldByName('nota').AsString;
  dm.IBselect.Close;
end;

function Tfuncoes.buscaProdutoCodCodBar(const cod: String): String;
begin
  Result := '';
  if length(cod) < 7 then
  begin
    dm.IBselect.Close;
    dm.IBselect.SQL.text :=
      'select cod, quant, deposito, nome from produto where cod = :cod';
    dm.IBselect.ParamByName('cod').AsString := cod;
    dm.IBselect.Open;

    if not dm.IBselect.IsEmpty then
      Result := dm.IBselect.FieldByName('cod').AsString;
  end
  else
  begin
    dm.IBselect.Close;
    dm.IBselect.SQL.text :=
      'select p.cod, p.quant, p.deposito, p.nome from produto p left join codbarras c on (c.cod = p.cod) where (p.codbar = '
      + QuotedStr(cod) + ') or (c.codbar = ' + QuotedStr(cod) + ')';
    dm.IBselect.Open;

    if not dm.IBselect.IsEmpty then
      Result := dm.IBselect.FieldByName('cod').AsString;
  end;

  // ShowMessage(Result);
  // dm.IBselect.close;
end;

procedure Tfuncoes.adicionaRegistroDataBloqueio(const mostraMensagem,
  adicionaBloqueio: boolean; var dias: integer; var quer: TIBQuery;
  buscaDiasSite: boolean = False);
var
  too: integer;
  data: TDate;
begin

  quer.Close;
  quer.SQL.text :=
    'select * from acesso where (acesso = ''diaBloq'') or (acesso = ''bloq'')';
  quer.Open;

  if quer.IsEmpty then
  begin
    if adicionaBloqueio then
    begin
      quer.Close;
      quer.SQL.text :=
        'insert into acesso(acesso, dtr, nfe, nota) values(''bloq'', :data, ' +
        IntToStr(dias) + ', 0)';
      quer.ParamByName('data').AsDate := now;
      quer.ExecSQL;

      quer.Transaction.Commit;

      quer.Close;
      quer.SQL.text :=
        'insert into acesso(acesso, dtr, nfe nota) values(''diaBloq'', :data, '
        + IntToStr(dias) + ', 0)';
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
      quer.SQL.text :=
        'update acesso set nfe = :nfe where (acesso = ''diaBloq'') or (acesso = ''bloq'')';
      quer.ParamByName('nfe').AsInteger := dias;
      quer.ExecSQL;

      quer.Transaction.Commit;
    end;
  end;

  if mostraMensagem then
  begin
    form58 := tform58.Create(self);

    quer.Close;
    quer.SQL.text := 'select acesso from acesso where acesso = ''bloq''';
    quer.Open;

    if quer.IsEmpty then
    begin
      quer.Close;
      exit;
    end;

    too := getDiasBloqueioRestantes;

    form58.Label2.caption := IntToStr(IfThen(too < 0, 0, too)) +
      ' dias Restantes';
    quer.Close;

    form58.ShowModal;

    if (too < 0) then
      Application.Terminate;
  end;
end;

function Tfuncoes.buscaDiasBloqueio(): integer;
begin
  dm.IBselect.Close;
  dm.IBselect.SQL.text :=
    'select dtr, nfe from acesso where acesso = ''diaBloq''';
  dm.IBselect.Open;

  Result := StrToIntDef(dm.IBselect.FieldByName('nfe').AsString,
    diasParaBloquear);
end;

procedure Tfuncoes.limpaBloqueado(var quer: TIBQuery);
begin
  dm.IBQuery1.Close;
  dm.IBQuery1.SQL.text := 'delete from acesso where acesso = ''diaBloq''';
  dm.IBQuery1.ExecSQL;

  dm.IBQuery1.Transaction.Commit;
  dm.IBQuery1.Close;
  dm.IBQuery1.SQL.text := 'delete from acesso where acesso = ''bloq''';
  dm.IBQuery1.ExecSQL;

  dm.IBQuery1.Transaction.Commit;
end;

procedure TTWThreadVerificaPagamento.Execute;
begin
  if funcoes.verificaConexaoComInternetSeTiverTRUEsenaoFALSE then
  begin
    SessaoCritica := TcriticalSection.Create;
    SessaoCritica.Enter;
    try
      try
        funcoes.verificaPermissaoPagamento(False);
      except
      end;
    finally
      SessaoCritica.Leave;
    end;
  end;
end;

procedure TTWtheadEnviaCupons1.enviaCupons;
var
  query: TIBQuery;
  forne: String;
  cont, fim: integer;
begin
  query := TIBQuery.Create(Application);
  query.Database := dm.bd;

  query.SQL.text := 'select nota, chave from NFCE where adic = ''OFF''';
  query.Open;
  query.FetchAll;
  fim := query.RecordCount;
  cont := 0;

  while not query.Eof do
  begin
    cont := cont + 1;
    label1.caption := IntToStr(cont) + '/' + IntToStr(fim);
    funcoes.enviandoCupom := true;
    try
      // funcoes.Mensagem(Application.Title ,'Aguarde, Enviando NFCe...',15,'Courier New',false,0,clred);
      Application.ProcessMessages;
      Application.ProcessMessages;
      SessaoCritica := TcriticalSection.Create;
      SessaoCritica.Acquire;
      EnviarCupomEletronico2(query.FieldByName('nota').AsString,
        query.FieldByName('chave').AsString, form19.RichEdit1, forne, False,
        true, False);
      SessaoCritica.Leave;
    except
    end;
    query.Next;
  end;
  funcoes.enviandoCupom := False;
end;

procedure TTWtheadEnviaCupons1.Execute;
begin
  Synchronize(self.enviaCupons);
end;

procedure Tfuncoes.acertarTamanhoDBGRID(var tabela: TDBGrid);
var
  i, acc: integer;
begin
  acc := 0;
  for i := 0 to tabela.Columns.count - 1 do
  begin
    // showme
    acc := acc + tabela.Columns[i].Width;
  end;

  TForm(tabela.Owner).Width := acc + 10;
  // tabela.Width := acc;
  // if acc < 299 then self.Width:=acc+10;
end;

{ function enviNFCe(const perg : String = '') : boolean;
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
  funcoes.Mensagem(Application.Title, '', 15, '',False, 0, clBlack, true);
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
  funcoes.Mensagem(Application.Title, '', 15, '',False, 0, clBlack, true);
  end;
  end; }

procedure LE_CAMPOS(var mat: tstringList; LIN: String; const separador: String;
  criaMAT: boolean = true);
var
  posi, cont: integer;
  valor: String;
begin
  if criaMAT then
    mat := tstringList.Create;

  if not Contido(separador, LIN) then
  begin
    mat.Add('0=' + LIN);
    exit;
  end;

  posi := pos(separador, LIN) + 1;
  LIN := copy(LIN, posi, length(LIN));
  mat.Clear;
  cont := -1;

  if not Contido(separador, LIN) then
    mat.Add('0=' + LIN);

  while true do
  begin
    posi := pos(separador, LIN) + 1;
    if ((posi = 0) or (trim(LIN) = '')) then
      break;

    valor := LeftStr(LIN, posi - 2);
    cont := cont + 1;
    mat.Add(IntToStr(cont) + '=' + trim(valor));
    if posi = length(LIN) then
      break;
    LIN := copy(LIN, posi, length(LIN));
  end;

  valor := '';
  posi := 0;
  cont := 0;
end;

procedure completaStringList(var mat: tstringList; qtd: integer);
var
  ini, cont: integer;
begin
  cont := mat.count;
  for ini := mat.count to qtd do
  begin
    mat.Add(IntToStr(cont) + '=');
    cont := cont + 1
  end;
end;

function ContaChar1(estring: string; sub: string): integer;
var
  ini: integer;
begin
  Result := 0;
  for ini := 1 to length(estring) do
  begin
    if estring[ini] = sub then
      Result := Result + 1;
  end;
end;

function Tfuncoes.exportaNFCeEmitidas(email: boolean = False; ini: String = '';
  fim: String = ''): string;
var
  num, unidade, csta, tip: string;
  dini, dfim: TDateTime;
  ind, gf, cp, nao: integer;
  cont, tot: Smallint;
  arq, xml, lista, listaCANC, SemCstat: tstringList;
begin
  Result := '';

  if form22.dataMov <= StrToDate('01/01/2000') then
    form22.dataMov := now;

  if ini = '' then
  begin
    ini := funcoes.dialogo('data', 0, '', 2, true, '', Application.Title,
      'Qual a Data Inicial?',
      formataDataDDMMYY(StartOfTheMonth(IncMonth(now, -1))));
    if ini = '*' then
      exit;
  end;

  if fim = '' then
  begin
    fim := funcoes.dialogo('data', 0, '', 2, true, '', Application.Title,
      'Qual a Data Final?', formataDataDDMMYY(endOfTheMonth(StrToDate(ini))));
    if fim = '*' then
      exit;
  end;

  dini := StrToDateTime(ini);
  dfim := StrToDateTime(fim);

  if email = False then
  begin
    unidade := funcoes.dialogo('generico', 0, 'ABCDEFGHIJLMNOPKXYZWQRSTUVXZ',
      50, False, 'S', Application.Title,
      'Confirme a unidade para Recebimento da Remessa:', ConfParamGerais[33]);
    if unidade = '*' then
      exit;

    unidade := unidade + ':\NFCE ' + FormatDateTime('mm-yyyy', dini);
  end
  else
  begin
    unidade := caminhoEXE_com_barra_no_final + 'Backup\';
    CriaDiretorio(unidade);
    unidade := unidade + 'NFCE ' + FormatDateTime('mm-yyyy', dini);
  end;

  dm.IBselect.Close;
  dm.IBselect.SQL.text :=
    'select * from nfce where substring(chave from 3 for 4) = :ini';
  dm.IBselect.ParamByName('ini').AsString := FormatDateTime('yy', StrToDate(ini)
    ) + FormatDateTime('mm', StrToDate(ini));
  dm.IBselect.Open;
  dm.IBselect.FetchAll;

  if dm.IBselect.IsEmpty then
  begin
    ShowMessage('Nenhuma NFCe Encontrada!');
    dm.IBselect.Close;
    exit;
  end;

  tot := dm.IBselect.RecordCount;
  cont := 0;
  cp := 0;
  nao := 0;

  xml := tstringList.Create;
  lista := tstringList.Create;
  listaCANC := tstringList.Create;
  SemCstat := tstringList.Create;

  funcoes.informacao(0, 0, 'Aguarde, Verificando Arquivos...', true, False, 5);

  while not dm.IBselect.Eof do
  begin
    cont := cont + 1;
    funcoes.informacao(cont, tot, 'Aguarde, Verificando Arquivos...', False,
      False, 5);
    if FileExists(buscaPastaNFCe(dm.IBselect.FieldByName('chave').AsString) +
      dm.IBselect.FieldByName('chave').AsString + '-nfe.xml') then
    begin
      xml.LoadFromFile(buscaPastaNFCe(dm.IBselect.FieldByName('chave').AsString)
        + dm.IBselect.FieldByName('chave').AsString + '-nfe.xml');
      csta := Le_Nodo('cStat', xml.text);

      if dm.IBselect.FieldByName('adic').AsString = 'CANC' then
      begin
        if csta <> '' then
        begin
          xml.SetText(PChar(substitui_Nodo('cStat', '135', xml.text)));
        end;
        listaCANC.Add(buscaPastaNFCe(dm.IBselect.FieldByName('chave').AsString)
          + dm.IBselect.FieldByName('chave').AsString + '-nfe.xml');
        cp := cp + 1;
      end
      else
      begin
        if funcoes.Contido(trim(csta), '100-150') then
        begin
          lista.Add(buscaPastaNFCe(dm.IBselect.FieldByName('chave').AsString) +
            dm.IBselect.FieldByName('chave').AsString + '-nfe.xml');
          cp := cp + 1;
        end
        else
        begin
          SemCstat.Add(dm.IBselect.FieldByName('chave').AsString);
        end;
      end;
    end
    else
    begin
      nao := nao + 1;
    end;

    dm.IBselect.Next;
  end;

  if lista.count > 0 then
  begin
    funcoes.Zip(lista, unidade + '.zip');
    if RightStr(Result, 1) <> '|' then
      Result := Result + '|';
    Result := Result + unidade + '.zip' + '|';
  end;
  if listaCANC.count > 0 then
  begin
    funcoes.Zip(listaCANC, unidade + '_CANC.zip');
    if RightStr(Result, 1) <> '|' then
      Result := Result + '|';
    Result := Result + unidade + '_CANC.zip' + '|';
  end;

  lista.Free;
  listaCANC.Free;
  xml.Free;
  funcoes.informacao(0, 0, 'Aguarde, Verificando Arquivos...', False, true, 5);

  if email = False then
  begin
    ShowMessage(STRZERO(IntToStr(tot), 5) + ' Registros Retornados' + #13 +
      STRZERO(IntToStr(cont), 5) + ' Arquivos Processados' + #13 +
      STRZERO(IntToStr(cp), 5) + ' Arquivos Copiados' + #13 +
      STRZERO(IntToStr(nao), 5) + ' Arquivos Não Encontrados' + #13 + #13 +
      'Sem Cstat:' + #13 + IfThen(SemCstat.count > 0, SemCstat.text, ''));
  end;
end;

function Tfuncoes.le_configTerminalWindows(posi: integer;
  padrao: string): String;
var
  arq: tstringList;
  tmp: string;
begin
  if not FileExists(caminhoEXE_com_barra_no_final + buscaNomeConfigDat) then
  begin
    criaArqTerminal();
  end;

  arq := tstringList.Create;
  arq.LoadFromFile(caminhoEXE_com_barra_no_final + buscaNomeConfigDat);
  Result := LerConfig(arq.Values['0'], posi);
  if Result = '' then
    Result := padrao;
end;

function Tfuncoes.buscaNomeSite(): String;
var
  num: String;
begin
  num := buscaConfigNaPastaDoControlW('Site_Num', '1');
  if StrToInt(StrNum(num)) > 3 then
  begin
    num := '1';
    GravaConfigNaPastaDoControlW('Site_Num', StrNum(num));
  end;

  if num = '1' then
    Result := site
  else if num = '2' then
    Result := site1
  else
    Result := site2;
end;

procedure Tfuncoes.mostraValorDinheiroTela(const valor: currency);
begin
  form57 := tform57.Create(self);
  form57.Labeldin.caption := formataCurrency(valor);
  form57.ShowModal;
  form57.Free;
end;

procedure Tfuncoes.ordernaDataSetVenda(const ordem1, valorLocate,
  sqlVenda: String; var dbgrid99: TDBGrid; ordem2: string = '';
  ordenaCampos: boolean = true);
var
  orde: String;
begin
  orde := ordem1;
  if orde = '' then
    orde := 'nome';

  if ordem2 <> '' then
    orde := ordem2;
  dm.produto.Close;
  dm.produto.SQL.text := sqlVenda + ' order by ' + orde;
  dm.produto.Open;

  if ordenaCampos then
    funcoes.OrdenaCamposVenda(ConfParamGerais.Strings[1]);

  if valorLocate <> '' then
  begin
    dm.produto.Locate('cod', valorLocate, []);
  end;

  funcoes.FormataCampos(dm.produto, 2, 'ESTOQUE', 3);
  dbgrid99.SelectedIndex := buscaFieldDBgrid1(orde, dbgrid99);
end;

function Tfuncoes.buscaFieldDBgrid(const nome: String;
  var grid: TDBGrid): tfield;
var
  ini, fim: integer;
begin
  fim := grid.Columns.count - 1;
  for ini := 0 to fim do
  begin
    if UpperCase(nome) = UpperCase(grid.Columns.Items[ini].Field.FieldName) then
    begin
      ShowMessage(UpperCase(nome) + #13 + UpperCase(grid.Columns.Items[ini]
        .Field.FieldName));
      Result := grid.Columns.Items[ini].Field;
      exit;
    end;
  end;

  Result := grid.Columns.Items[0].Field;
end;

function Tfuncoes.buscaFieldDBgrid1(const nome: String;
  var grid: TDBGrid): integer;
var
  ini, fim: integer;
begin
  fim := grid.Columns.count - 1;
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

FUNCTION Tfuncoes.VE_CODISPIS(_CODISPIS, _ISPIS: String): string;
var
  lista, arq: tstringList;
  nome, LIN, cod: String;
  ini, fim: integer;
begin
  lista := tstringList.Create;
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
    ShowMessage('Tabela ' + nome +
      ' Não Encontrada. Consulte o Suporte para Mais Detalhes.');
    lista.Free;
    exit;
  end;

  form33 := tform33.Create(self);
  form33.caption := 'Tabela de CST PIS/COF';
  form33.ClientDataSet1.FieldDefs.Clear;
  form33.ClientDataSet1.FieldDefs.Add('COD', ftString, 3);
  form33.ClientDataSet1.FieldDefs.Add('DESCRICAO', ftString, 300);
  form33.ClientDataSet1.FieldDefs.Add('DINI', ftDate);
  form33.ClientDataSet1.FieldDefs.Add('DFIM', ftDate);
  form33.ClientDataSet1.FieldDefs.Add('PIS', ftCurrency);
  form33.ClientDataSet1.FieldDefs.Add('COF', ftCurrency);
  form33.ClientDataSet1.CreateDataSet;
  form33.ClientDataSet1.FieldByName('DINI').Visible := False;
  form33.ClientDataSet1.FieldByName('DFIM').Visible := False;
  form33.ClientDataSet1.FieldByName('PIS').Visible := False;
  form33.ClientDataSet1.FieldByName('COF').Visible := False;
  form33.DataSource1.dataset := form33.ClientDataSet1;
  form33.DBGrid1.DataSource := form33.DataSource1;
  form33.campobusca := 'cod';

  arq := tstringList.Create;
  arq.LoadFromFile(caminhoEXE_com_barra_no_final + nome);
  form39 := tform39.Create(self);

  fim := arq.count - 1;
  ini := 0;
  // for ini := 0 to fim do
  while true do
  begin
    if trim(arq[ini]) <> '' then
    begin
      LIN := arq[ini];
      form33.ClientDataSet1.Append;
      if length(StrNum(LeftStr(LIN, 3))) = 3 then
        cod := StrNum(LeftStr(LIN, 3));
      form33.ClientDataSet1.FieldByName('COD').AsString := cod;
      if form33.ClientDataSet1.FieldByName('COD').AsString <> '0' then
      begin
        LIN := copy(LIN, 5, length(LIN));
        if length(StrNum(LeftStr(arq[ini], 3))) = 3 then
          form33.ClientDataSet1.FieldByName('DESCRICAO').AsString :=
            copy(LIN, 1, IfThen(pos(#9, LIN) > 0, pos(#9, LIN), length(LIN)))
        else
          form33.ClientDataSet1.FieldByName('DESCRICAO').AsString := arq[ini];
      end
      else
        form33.ClientDataSet1.FieldByName('DESCRICAO').AsString := LIN;
      form33.ClientDataSet1.Post;
    end;

    if ini = fim then
      break;
    ini := ini + 1;
  end;

  form33.ClientDataSet1.First;
  form33.ShowModal;
  form33.Free;
  Result := StrNum(retornobusca);
  // Result := IntToStr(StrToIntDef(Result, 0));
  if Result = '0' then
    Result := '';
end;

function Tfuncoes.isCPF(cpf: string): boolean;
var
  dig10, dig11: string;
  s, i, r, peso: integer;
begin
  cpf := StrNum(cpf);
  // length - retorna o tamanho da string (CPF é um número formado por 11 dígitos)
  if ((cpf = '00000000000') or (cpf = '11111111111') or (cpf = '22222222222') or
    (cpf = '33333333333') or (cpf = '44444444444') or (cpf = '55555555555') or
    (cpf = '66666666666') or (cpf = '77777777777') or (cpf = '88888888888') or
    (cpf = '99999999999') or (length(cpf) <> 11)) or (StrToIntDef(cpf, 0) = 0)
  then
  begin
    isCPF := False;
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
      s := s + (StrToInt(cpf[i]) * peso);
      peso := peso - 1;
    end;
    r := 11 - (s mod 11);
    if ((r = 10) or (r = 11)) then
      dig10 := '0'
    else
      str(r: 1, dig10); // converte um número no respectivo caractere numérico

    { *-- Cálculo do 2o. Digito Verificador --* }
    s := 0;
    peso := 11;
    for i := 1 to 10 do
    begin
      s := s + (StrToInt(cpf[i]) * peso);
      peso := peso - 1;
    end;
    r := 11 - (s mod 11);
    if ((r = 10) or (r = 11)) then
      dig11 := '0'
    else
      str(r: 1, dig11);

    { Verifica se os digitos calculados conferem com os digitos informados. }
    if ((dig10 = cpf[10]) and (dig11 = cpf[11])) then
      isCPF := true
    else
      isCPF := False;
  except
    isCPF := False
  end;
end;

Function Tfuncoes.testacpf(cpf: string): boolean;
var
  i: integer;
  Want: Char;
  Wvalid: boolean;
  Wdigit1, Wdigit2: integer;
begin
  Result := False;
  if length(cpf) <> 11 then
  begin
    exit;
  end;
  Wdigit1 := 0;
  Wdigit2 := 0;
  Want := cpf[1];
  // variavel para testar se o cpf é repetido como 111.111.111-11
  Delete(cpf, ansipos('.', cpf), 1); // retira as mascaras se houver
  Delete(cpf, ansipos('.', cpf), 1);
  Delete(cpf, ansipos('-', cpf), 1);

  // testar se o cpf é repetido como 111.111.111-11
  for i := 1 to length(cpf) do
  begin
    if cpf[i] <> Want then
    begin
      Wvalid := true;
      // se o cpf possui um digito diferente ele passou no primeiro teste
      break
    end;
  end;
  // se o cpf é composto por numeros repetido retorna falso
  if not Wvalid then
  begin
    Result := False;
    exit;
  end;

  // executa o calculo para o primeiro verificador
  for i := 1 to 9 do
  begin
    Wdigit1 := Wdigit1 + (StrToInt(cpf[10 - i]) * (i + 1));
  end;
  Wdigit1 := ((11 - (Wdigit1 mod 11)) mod 11) mod 10;
  { formula do primeiro verificador
    soma=1°*2+2°*3+3°*4.. até 9°*10
    digito1 = 11 - soma mod 11
    se digito > 10 digito1 =0
  }

  // verifica se o 1° digito confere
  if IntToStr(Wdigit1) <> cpf[10] then
  begin
    Result := False;
    exit;
  end;

  for i := 1 to 10 do
  begin
    Wdigit2 := Wdigit2 + (StrToInt(cpf[11 - i]) * (i + 1));
  end;
  Wdigit2 := ((11 - (Wdigit2 mod 11)) mod 11) mod 10;
  { formula do segundo verificador
    soma=1°*2+2°*3+3°*4.. até 10°*11
    digito1 = 11 - soma mod 11
    se digito > 10 digito1 =0
  }

  // confere o 2° digito verificador
  if IntToStr(Wdigit2) <> cpf[11] then
  begin
    Result := False;
    exit;
  end;

  // se chegar até aqui o cpf é valido
  Result := true;
end;

Function testacpf(cpf: string): boolean;
var
  i: integer;
  Want: Char;
  Wvalid: boolean;
  Wdigit1, Wdigit2: integer;
begin
  Wdigit1 := 0;
  Wdigit2 := 0;
  Want := cpf[1];
  // variavel para testar se o cpf é repetido como 111.111.111-11
  Delete(cpf, ansipos('.', cpf), 1); // retira as mascaras se houver
  Delete(cpf, ansipos('.', cpf), 1);
  Delete(cpf, ansipos('-', cpf), 1);

  // testar se o cpf é repetido como 111.111.111-11
  for i := 1 to length(cpf) do
  begin
    if cpf[i] <> Want then
    begin
      Wvalid := true;
      // se o cpf possui um digito diferente ele passou no primeiro teste
      break
    end;
  end;
  // se o cpf é composto por numeros repetido retorna falso
  if not Wvalid then
  begin
    Result := False;
    exit;
  end;

  // executa o calculo para o primeiro verificador
  for i := 1 to 9 do
  begin
    Wdigit1 := Wdigit1 + (StrToInt(cpf[10 - i]) * (i + 1));
  end;
  Wdigit1 := ((11 - (Wdigit1 mod 11)) mod 11) mod 10;
  { formula do primeiro verificador
    soma=1°*2+2°*3+3°*4.. até 9°*10
    digito1 = 11 - soma mod 11
    se digito > 10 digito1 =0
  }

  // verifica se o 1° digito confere
  if IntToStr(Wdigit1) <> cpf[10] then
  begin
    Result := False;
    exit;
  end;

  for i := 1 to 10 do
  begin
    Wdigit2 := Wdigit2 + (StrToInt(cpf[11 - i]) * (i + 1));
  end;
  Wdigit2 := ((11 - (Wdigit2 mod 11)) mod 11) mod 10;
  { formula do segundo verificador
    soma=1°*2+2°*3+3°*4.. até 10°*11
    digito1 = 11 - soma mod 11
    se digito > 10 digito1 =0
  }

  // confere o 2° digito verificador
  if IntToStr(Wdigit2) <> cpf[11] then
  begin
    Result := False;
    exit;
  end;

  // se chegar até aqui o cpf é valido
  Result := true;
end;

procedure Tfuncoes.dbgrid1Registro(var dbgrid44: TDBGrid);
var
  ini, fim: integer;
begin
  ini := dbgrid44.DataSource.dataset.RecNo;
  keybd_event(VK_NEXT, 0, 0, 0);
  // dm.abortarScroll := true;
  dbgrid44.DataSource.dataset.RecNo := ini;
  dm.abortarScroll := False;
  exit;
  { for ini := 0 to fim do
    begin
    keybd_event(VK_DOWN, 0, 0, 0);
    Application.ProcessMessages;
    end; }

  SendMessage(DBGrid1.Handle, WM_VSCROLL, SB_Lineup, 0);
  dbgrid44.DataSource.dataset.EnableControls;
end;

procedure Tfuncoes.adicionaRegistrosBloqueio();
var
  ini: integer;
begin
  dm.IBQuery1.Close;

  dm.IBQuery1.SQL.text :=
    'update or insert into acesso(acesso, dtr) values(''bloq'', :data) matching(acesso)';
  dm.IBQuery1.ParamByName('data').AsDate := form22.dataMov - 50;
  dm.IBQuery1.ExecSQL;

  dm.IBQuery1.Transaction.Commit;
end;

procedure Tfuncoes.aumentaFonte(formula: TForm; dbgridr: boolean;
  opcao: integer; redimensionar: boolean = False);
var
  ini, fim, tu, idx, acc: integer;
  fi: Smallint;
  form: String;
  arq: tstringList;
  tamDBGR, tam: String;
begin
  { OPCAO
    0 - ler
    1 - aumenta
    2 - diminui
  }

  arq := tstringList.Create;
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
    if dbgridr and (not((UpperCase(formula.Components[ini].Name) = 'DBGRID2')
      and (UpperCase(formula.Name) = 'FORM20'))) then
    begin
      if (form = 'TDBGRID') then
      begin
        idx := ini;
        tu := StrToIntDef(LerConfig(tam, 0), TDBGrid(formula.Components[ini])
          .Font.Size);
        if opcao = 0 then
        begin
          TDBGrid(formula.Components[ini]).Font.Size := tu;
          TDBGrid(formula.Components[ini]).Font.Style := [fsbold];
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
        // exit;
      end;
    end
    else
    begin

    end;
  end;

  acc := 0;
  if redimensionar then
  begin
    // if idx <> 0 then
    // begin
    fim := TDBGrid(formula.Components[idx]).Columns.count - 1;
    for ini := 0 to fim do
    begin
      acc := acc + TDBGrid(formula.Components[idx]).Columns[ini].Width;
    end;
    if acc > screen.Width then
    begin
      formula.Width := screen.Width - trunc(screen.Width * 0.1);
    end
    else
      formula.Width := acc + 30;

    formula.Position := poScreenCenter;

    // end;
  end;

  tam := '-0- -1- -2- -3- -4- -5- -6- -7- -8-';
  arq.Values[formula.Name] := GravarConfig(tam, IntToStr(tu), 0);
  DeleteFile(caminhoEXE_com_barra_no_final + 'fonte.dat');
  arq.SaveToFile(caminhoEXE_com_barra_no_final + 'fonte.dat');
end;

function Tfuncoes.buscaParamGeral(indice: integer; deafault: String): String;
begin
  Result := '';
  try
    Result := ConfParamGerais[indice];
    if Result = '' then
      Result := deafault;
  except
    Result := deafault;
  end;
end;

procedure Tfuncoes.gravaAlteracao(altera: String; tipo : String = '');
begin
  dm.IBQuery1.Close;
  dm.IBQuery1.SQL.text := 'insert into alteraca(cod, alteracao, usuario, data, tipo)'
    + ' values(gen_id(alteraca, 1), :alteracao, :usuario, :data, :tipo)';
  dm.IBQuery1.ParamByName('alteracao').AsString := LeftStr(altera, 100);
  dm.IBQuery1.ParamByName('usuario').AsString :=
    LeftStr(STRZERO(form22.codusario, 2) + form22.USUARIO, 20);
  dm.IBQuery1.ParamByName('data').AsDateTime := DateOf(form22.dataMov) +
    TimeOf(now);
  dm.IBQuery1.ParamByName('tipo').AsString := tipo;
  try
    dm.IBQuery1.ExecSQL;
    dm.IBQuery1.Transaction.Commit;
  except
  end;
end;

{ function calculaVlrAproxImpostos(var lista1 : TList) : currency;
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
  end; }

function calculaVlrAproxImpostos1(nota: String): currency;
var
  ex, descricao: String;
  tabela: integer;
  aliqFedNac, aliqFedImp, aliqEst, aliqMun: double;
  ini: integer;
  item: Item_venda1;
begin
  { Result := 0;
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
  // dm.ACBrIBPTax1.Procurar()
end;

function buscaChaveErroDeDuplicidade(erro: String): String;
var
  ini, fim: integer;
begin
  ini := pos('[chNFe:', erro) + 7;
  fim := pos(']', erro);
  Result := copy(erro, ini, fim - ini);
end;

constructor TTWtheadEnviaCupons1.Create(CreateSuspended: boolean; lab1: TLabel);
begin
  label1 := lab1;
  inherited Create(CreateSuspended);
end;

function Tfuncoes.vercCountContigencia(): integer;
begin
  Result := 0;
  dm.IBselect.Close;
  dm.IBselect.SQL.text :=
    'select count(*) as qtd from nfce where adic = ''OFF''';
  dm.IBselect.Open;

  Result := dm.IBselect.FieldByName('qtd').AsInteger;
  { if dtmMain.IBQuery1.fieldbyname('qtd').AsInteger > 0 then
    begin
    //Result := 'Contigência: ' + IntToStr(dtmMain.IBQuery1.fieldbyname('qtd').AsInteger);
    end; }

  dm.IBselect.Close;
end;

function Tfuncoes.cadastroClienteNFCeRetornaCod(total: currency = 0;
  cod: integer = 0): string;
begin
  Result := '';
  if total >= 10000 then
  begin
    Result := '';
    while true do
    begin
      if StrNum(Result) = '0' then
      begin
        if MessageDlg
          ('O Cliente é Obrigatório para Vendas acima de 10mil Reais, Favor Cadastre um Cliente! Deseja Continuar ?',
          mtInformation, [mbYes, mbNo], 1) = idno then
        begin
          Result := 'x';
          exit;
        end;
      end;
      if StrNum(Result) <> '0' then
        exit;
      if StrNum(Result) = '0' then
      begin
        cadCliNFCe := tcadCliNFCe.Create(self);
        cadCliNFCe.cod.text := IntToStr(cod);

        cadCliNFCe.ShowModal;
        Result := cadCliNFCe.codcliente;
        cadCliNFCe.Free;
      end;
    end;
  end;

  if buscaParamGeral(53, 'S') = 'S' then
  begin
    cadCliNFCe := tcadCliNFCe.Create(self);
    cadCliNFCe.ShowModal;
    Result := cadCliNFCe.codcliente;
    cadCliNFCe.Free;
  end
  else
  begin
    CadClienteSimplificado := tCadClienteSimplificado.Create(self);
    CadClienteSimplificado.limpa;
    CadClienteSimplificado.ShowModal;
    Result := CadClienteSimplificado.codcliente;
  end;
end;

function Tfuncoes.buscaVendaNFCe(nnf, serie: String; var chave: String): String;
var
  tmp: String;
begin
  Result := '';
  tmp := STRZERO(nnf, 7) + STRZERO(serie, 2);
  dm.IBselect.Close;
  dm.IBselect.SQL.text := 'select nota from venda where crc = :crc';
  dm.IBselect.ParamByName('crc').AsString := tmp;
  dm.IBselect.Open;

  if not dm.IBselect.IsEmpty then
  begin
    Result := dm.IBselect.FieldByName('nota').AsString;
    dm.IBselect.Close;
    dm.IBselect.SQL.text :=
      'select chave from nfce where substring(chave from 26 for 9) = :nnf and substring(chave from 23 for 3) = :serie';
    dm.IBselect.ParamByName('nnf').AsString := STRZERO(nnf, 9);
    dm.IBselect.ParamByName('serie').AsString := STRZERO(serie, 3);
    dm.IBselect.Open;

    if not dm.IBselect.IsEmpty then
    begin
      chave := StrNum(dm.IBselect.FieldByName('chave').AsString);
      if chave = '0' then
        chave := '';
    end;
  end;
end;

function Tfuncoes.buscaVendaECF(nnf, serie: String): String;
begin
  Result := '';
  nnf := STRZERO(nnf, 6) + STRZERO(serie, 3);
  dm.IBselect.Close;
  dm.IBselect.SQL.text := 'select nota from venda where crc = :crc';
  dm.IBselect.ParamByName('crc').AsString := nnf;
  dm.IBselect.Open;

  if not dm.IBselect.IsEmpty then
    Result := dm.IBselect.FieldByName('nota').AsString;
end;

procedure Tfuncoes.somenteNumeros(var Key: Char);
begin
  if Contido(Key, '1234567890' + #8 + #13 + #27) = False then
  begin
    Key := #0;
  end;
end;

function Tfuncoes.DeleteFolder(FolderName: String): boolean;
Var
  SearchFile: TSearchRec;
  FindResult: integer;
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

procedure Tfuncoes.BuscaAplicacao(CONST SQL: sTRING; VAR GRID1: TDBGrid;
  ORDENACAMP: boolean);
var
  busca, metodo: string;
begin
  busca := funcoes.dialogo('normal', 3, '', 60, true, '', 'ControlW',
    'Selecionar Por:', '');
  if busca = '*' then
    exit;

  dm.IBQuery2.Close;
  dm.IBQuery2.SQL.Clear;

  // if metodo = '2' then dm.IBQuery2.SQL.Add('select cod,nome as descricao, quant, p_venda as preco, aplic as aplicacao  from produto where (APLIC like '+ QuotedStr('%'+busca+'%') +') ORDER BY APLIC')
  // else if metodo = '1' then dm.IBQuery2.SQL.Add('select cod,nome as descricao, quant, p_venda as preco, aplic as aplicacao from produto where (APLIC like '+ QuotedStr(busca+'%') +') ORDER BY APLIC');
  dm.IBQuery2.SQL.Add
    ('select cod,nome as descricao, quant, p_venda as preco, aplic as aplicacao  from produto where (APLIC like '
    + QuotedStr('%' + busca + '%') + ') ORDER BY APLIC');
  dm.IBQuery2.Open;

  busca := funcoes.busca(dm.IBQuery2, busca, '', 'cod', 'descricao');
  if busca = '' then
    exit;
  funcoes.ordernaDataSetVenda('APLICACAO', busca, SQL, GRID1, '', ORDENACAMP);
  // DBGrid1.DataSource.DataSet.Locate('cod',busca,[loPartialKey]);
end;

function Tfuncoes.getDiasBloqueioRestantes(soDiasParaBloquear
  : boolean = False): integer;
begin
  dm.IBselect.Close;
  dm.IBselect.SQL.text := 'select nfe, dtr from acesso where acesso = ''bloq''';
  dm.IBselect.Open;

  if soDiasParaBloquear then
  begin
    Result := StrToIntDef(dm.IBselect.FieldByName('nfe').AsString, 15);
    dm.IBselect.Close;
    exit;
  end;

  if not dm.IBselect.IsEmpty then
  begin
    Result := trunc(IncDay(dm.IBselect.FieldByName('dtr').AsDateTime,
      dm.IBselect.FieldByName('nfe').AsInteger) - now);
  end;

  dm.IBselect.Close;
end;

procedure Tfuncoes.AjustaForm(Formulario: TForm; nTamOriginal: integer = 800);
Var
  nEscala: double; // Vai me dar o percentual de Transformação escalar
  nPorcento: integer; // Vai me dar em percentual inteiro o valor
begin
  if buscaParamGeral(68, 'N') = 'S' then
    exit;

  if nTamOriginal = screen.Width then
    exit;

  if Formulario.Name = 'dadosAdicSped' then
  begin
    nTamOriginal := 950;
  end;

  nEscala := ((screen.Width - nTamOriginal) / nTamOriginal);
  nPorcento := round((nEscala * 100) + 100);
  // Formulario.Width := Round(Self.Width * (nEscala+1));
  // Formulario.Height := Round(Self.Height * (nEscala+1));
  Formulario.ScaleBy(nPorcento, 100);
end;

function Tfuncoes.Trunca(const nValor: currency; const iCasas: integer)
  : currency;
begin
  Result := nValor;

  if iCasas <= 0 then
    Result := trunc(nValor)
  else if iCasas = 1 then
    Result := trunc(nValor * 10) / 10
  else if iCasas = 2 then
    Result := trunc(nValor * 100) / 100
  else if iCasas = 3 then
    Result := trunc(nValor * 1000) / 1000
  else if iCasas = 4 then
    Result := trunc(nValor * 10000) / 10000;
end;

function Tfuncoes.DSiFileSize(const fileName: string): Int64;
var
  fHandle: DWord;
begin
  fHandle := CreateFile(PChar(fileName), 0, 0, nil, OPEN_EXISTING,
    FILE_ATTRIBUTE_NORMAL, 0);
  if fHandle = INVALID_HANDLE_VALUE then
    Result := -1
  else
  begin
    try
      Int64Rec(Result).Lo := GetFileSize(fHandle, @Int64Rec(Result).Hi);
    finally
      CloseHandle(fHandle);
    end;
  end;
end;

function Tfuncoes.insereFornec(var matriz: tstringList): String;
var
  cod: string;
begin
  dm.IBselect.Close;
  dm.IBselect.SQL.Clear;
  dm.IBselect.SQL.Add('select cod from FORNECEDOR where cnpj = :cnpj');
  dm.IBselect.ParamByName('cnpj').AsString := matriz[0];
  dm.IBselect.Open;

  Result := '0';

  if not dm.IBselect.IsEmpty then
  begin
    Result := dm.IBselect.FieldByName('cod').AsString;
  end;

  dm.IBselect.Close;

  if Result = '0' then
  begin
    cod := Incrementa_Generator('FORNECEDOR', 1);
    Result := cod;
  end;

  dm.ibquery4.Close;
  dm.ibquery4.SQL.Clear;
  dm.ibquery4.SQL.Add
    ('update or insert into FORNECEDOR(cod, nome, endereco, cep, fone, cidade, estado, bairro, cnpj,'
    + 'ies, cod_mun, tipo) values(:cod, :nome, :endereco, :cep, :fone, :cidade, :estado, :bairro, :cnpj,'
    + ':ies, :cod_mun, :tipo)');
  dm.ibquery4.ParamByName('cod').AsString := cod;
  dm.ibquery4.ParamByName('nome').AsString := LeftStr(matriz[1], 40);
  dm.ibquery4.ParamByName('endereco').AsString := LeftStr(matriz[3], 40);
  dm.ibquery4.ParamByName('cep').AsString := LeftStr(matriz[8], 10);
  dm.ibquery4.ParamByName('fone').AsString := LeftStr(matriz[11], 14);
  dm.ibquery4.ParamByName('cidade').AsString := LeftStr(matriz[6], 14);
  dm.ibquery4.ParamByName('estado').AsString := matriz[7];
  dm.ibquery4.ParamByName('bairro').AsString := LeftStr(matriz[4], 25);
  dm.ibquery4.ParamByName('cnpj').AsString := matriz[0];
  dm.ibquery4.ParamByName('ies').AsString := matriz[12];
  dm.ibquery4.ParamByName('cod_mun').AsString := matriz[5];
  dm.ibquery4.ParamByName('tipo').AsString := '2';
  dm.ibquery4.ExecSQL;
  dm.ibquery4.Transaction.Commit;

  // reStartGenerator('fornecedor', StrToInt(fornecedor));
end;

procedure Tfuncoes.imprimeGrafico(tipo, nota, vendedor: String;
  listaProdutos1: TItensProduto; desconto: currency);
var
  ini: integer;
  total: currency;
begin
  dm.IBselect.Close;
  dm.IBselect.SQL.text := 'select * from registro';
  dm.IBselect.Open;

  imprime.lNomeFantasia.caption := form22.Pgerais.Values['empresa'];
  imprime.lRazaoSocial.caption := dm.IBselect.FieldByName('nome').AsString;
  imprime.lEndereco.caption := dm.IBselect.FieldByName('ende').AsString + ' ' +
    dm.IBselect.FieldByName('bairro').AsString + ' ' + dm.IBselect.FieldByName
    ('telres').AsString + ' ' + dm.IBselect.FieldByName('telcom').AsString;

  dm.IBselect.Close;
  imprime.mLinhaItem.Lines.Clear;
  total := 0;

  for ini := 0 to listaProdutos1.count - 1 do
  begin
    imprime.mLinhaItem.Lines.Add
      (CompletaOuRepete(LeftStr(listaProdutos1[ini].codbar, 15), '', ' ', 15) +
      ' ' + CompletaOuRepete(LeftStr(listaProdutos1[ini].nome, 35), '', ' ', 35)
      + ' ' + CompletaOuRepete('', FormatCurr('0.00',
      listaProdutos1[ini].quant), ' ', 12) + ' ' + CompletaOuRepete('',
      FormatCurr('0.00', listaProdutos1[ini].preco), ' ', 12) + ' ' +
      CompletaOuRepete('', FormatCurr('0.00', listaProdutos1[ini].total),
      ' ', 10));
    total := total + listaProdutos1[ini].total;
  end;

  dm.IBselect.Close;
  dm.IBselect.SQL.text := 'select cod,nome from vendedor where cod = :cod';
  dm.IBselect.ParamByName('cod').AsString := vendedor;
  dm.IBselect.Open;

  imprime.lQtdTotalItensVal.caption := IntToStr(listaProdutos1.count);
  imprime.lTotal.caption := FormatCurr('0.00', total);
  imprime.ldesconto.caption := FormatCurr('0.00', desconto);
  imprime.lTitValorPago.caption := FormatCurr('0.00', total - abs(desconto));
  imprime.ldadosNota.caption := CompletaOuRepete('Nota: ' + nota,
    'Vendedor: ' + dm.IBselect.FieldByName('cod').AsString + '-' +
    dm.IBselect.FieldByName('nome').AsString, ' ', 50);
  imprime.dadosCliente.Visible := true;
  imprime.rlbMensagemContribuinte.Visible := False;

  imprime.rlsbDetItem.Visible := true;
  imprime.rlbsCabecalho.Visible := true;
  imprime.RLBarcode1.caption := nota;
  imprime.nota.caption := 'Venda: ' + nota;

  imprime.rlVenda.Preview;
  // imprime.rlVenda.Print;
end;

procedure Tfuncoes.le_Venda(nota: String; var desconto: currency;
  var vendedor: String; var listprod: TItensProduto);
var
  i: integer;
begin
  dm.IBselect.Close;
  dm.IBselect.SQL.text :=
    'select desconto, vendedor from venda where nota = :nota';
  dm.IBselect.ParamByName('nota').AsString := nota;
  dm.IBselect.Open;

  if dm.IBselect.IsEmpty then
  begin
    dm.IBselect.Close;
    vendedor := 'xx';
    exit;
  end;

  desconto := dm.IBselect.FieldByName('desconto').AsCurrency;
  vendedor := dm.IBselect.FieldByName('vendedor').AsString;

  dm.IBselect.Close;
  dm.IBselect.SQL.text :=
    'select i.cod, p.p_venda,p.codbar, i.total, i.quant, p.nome from item_venda i left join produto p on (p.cod = i.cod)'
    + ' where nota = :nota';
  dm.IBselect.ParamByName('nota').AsString := nota;
  dm.IBselect.Open;

  listprod := TItensProduto.Create;

  while not dm.IBselect.Eof do
  begin
    i := listprod.Add(TregProd.Create);
    listprod[i].cod := dm.IBselect.FieldByName('cod').AsInteger;
    listprod[i].nome := dm.IBselect.FieldByName('nome').AsString;
    listprod[i].codbar := dm.IBselect.FieldByName('codbar').AsString;
    listprod[i].quant := dm.IBselect.FieldByName('quant').AsCurrency;
    listprod[i].preco := dm.IBselect.FieldByName('p_venda').AsCurrency;
    listprod[i].total := dm.IBselect.FieldByName('total').AsCurrency;
    dm.IBselect.Next;
  end;

  dm.IBselect.Close;
end;

procedure Tfuncoes.atualizaTabelaCest();
var
  arq, ti, ta: tstringList;
  ini, fim, i, ini1, fim1: integer;
  atual: string;
begin
  if not FileExists(ExtractFileDir(ParamStr(0)) + '\cest.csv') then
    exit;

  arq := tstringList.Create;
  ti := tstringList.Create;
  ta := tstringList.Create;
  arq.LoadFromFile(ExtractFileDir(ParamStr(0)) + '\cest.csv');

  fim := arq.count - 1;
  i := 0;
  cont := 0;
  for ini := 0 to fim do
  begin
    arq[ini] := ';' + arq[ini] + ';';
    LE_CAMPOS(ti, arq[ini], ';', true);
    ti.Values['0'] := StrNum(ti.Values['0']);

    if Contido(',', ti.Values['1']) then
      ti.Values['1'] := ',' + ti.Values['1'] + ',';

    LE_CAMPOS(ta, ti.Values['1'], ',', true);

    // fim1 := ;

    for ini1 := 0 to ta.count - 1 do
    begin
      ta.Values[IntToStr(ini1)] := StrNum(ta.Values[IntToStr(ini1)]);
      try
        if ((ta.Values[IntToStr(ini1)] <> '0') and (ti.Values['0'] <> '0')) then
        begin
          i := i + 1;
          dm.IBQuery1.Close;
          dm.IBQuery1.SQL.text :=
            'update or insert into NCM_CEST(ncm, cest) values(:ncm, :cest)';
          dm.IBQuery1.ParamByName('ncm').AsString := ta.Values[IntToStr(ini1)];
          dm.IBQuery1.ParamByName('cest').AsString := ti.Values['0'];
          dm.IBQuery1.ExecSQL;
        end;
      except
        on e: exception do
        begin
          ShowMessage(ta.text + #13 + '--------------' + #13 + ti.Values['0']);
        end;
      end;
    end;

    if ((ti.Values['2'] <> '') and (StrToIntDef(ti.Values['0'], 0) <> 0)) then
    begin
      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.text :=
        'update or insert into cest(cest, nome) values(:cest, :nome)';
      dm.IBQuery1.ParamByName('cest').AsString := ti.Values['0'];
      dm.IBQuery1.ParamByName('nome').AsString :=
        UpperCase(LeftStr(ti.Values['2'], 100));
      dm.IBQuery1.ExecSQL;
    end;

    ta.Free;
    ti.Free;
    // ShowMessage(ti.GetText);
  end;

  arq.Free;
  dm.IBQuery1.Transaction.Commit;
  ShowMessage('NCMs Inseridos: ' + IntToStr(i));
end;

procedure Tfuncoes.atualizaCFOPs(atualizaBD: boolean = true);
var
  arq, camp: tstringList;
  ini, fim: integer;
  cods: String;
begin
  if not FileExists(caminhoEXE_com_barra_no_final + 'CFOP.csv') then
    exit;

  arq := tstringList.Create;
  camp := tstringList.Create;
  cods := '|';
  arq.LoadFromFile(caminhoEXE_com_barra_no_final + 'CFOP.csv');

  dm.IBselect.Close;
  dm.IBselect.SQL.text := 'select cod from COD_OP';
  dm.IBselect.Open;

  while NOT dm.IBselect.Eof do
  begin
    cods := cods + dm.IBselect.FieldByName('cod').AsString + '|';
    dm.IBselect.Next;
  end;

  fim := arq.count - 1;
  funcoes.informacao(0, fim, 'Atualizando CFOPs...', true, False, 2);

  for ini := 0 to fim do
  begin
    funcoes.informacao(ini, fim, 'Atualizando CFOPs...', False, False, 2);
    arq[ini] := ';' + arq[ini] + ';';
    LE_CAMPOS(camp, arq[ini], ';', False);

    // and (RightStr(StrNum(camp.Values['0']), 1)  <> '0')

    if ((Contido('|' + StrNum(camp.Values['0']) + '|', cods) = False) and
      (StrNum(camp.Values['0']) <> '0')) or (atualizaBD = False) then
    begin
      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.text :=
        'update or insert into COD_OP(cod, nome) values(:cod, :nome) matching(cod)';
      dm.IBQuery1.ParamByName('cod').AsInteger :=
        StrToInt(StrNum(camp.Values['0']));
      dm.IBQuery1.ParamByName('nome').AsString :=
        UpperCase(LeftStr(removeCarateresEspeciais(camp.Values['1']), 100));
      dm.IBQuery1.ExecSQL;
    end;
  end;

  if dm.IBQuery1.Transaction.InTransaction then
    dm.IBQuery1.Transaction.Commit;
  funcoes.informacao(ini, fim, 'Atualizando CFOPs...', False, true, 2);
  cods := '';
  camp.Free;
  arq.Free;

  RenameFile(caminhoEXE_com_barra_no_final + 'CFOP.csv',
    caminhoEXE_com_barra_no_final + 'CFOP1.csv');
end;

function Tfuncoes.buscaUltimaVendaOrcamentoDoUsuario(codUsuario: integer;
  opcao: Smallint): String;
begin
  dm.IBselect.Close;
  if opcao = 1 then
    dm.IBselect.SQL.text :=
      'select max(nota)as nota from venda where vendedor = :vend and cancelado = 0'
  else
    dm.IBselect.SQL.text :=
      'select max(nota)as nota from orcamento where vendedor = :vend';
  dm.IBselect.ParamByName('vend').AsInteger := codUsuario;
  dm.IBselect.Open;

  Result := StrNum(dm.IBselect.FieldByName('nota').AsString);

  if Result = '0' then
  begin
    if opcao = 2 then
      Result := Incrementa_Generator('orcamento', 0)
    else
      Result := Incrementa_Generator('venda', 0);
  end;
  dm.IBselect.Close;
end;

procedure Tfuncoes.criaDataSetVirtualProdutosForm33();
begin
  form33.ClientDataSet1.FieldDefs.Clear;
  form33.ClientDataSet1.FieldDefs.Add('CODIGO', ftInteger);
  form33.ClientDataSet1.FieldDefs.Add('DESCRICAO', ftString, 40);
  form33.ClientDataSet1.FieldDefs.Add('CODBAR', ftString, 15);
  form33.ClientDataSet1.FieldDefs.Add('UNID', ftString, 3);
  form33.ClientDataSet1.FieldDefs.Add('P_VENDA', ftCurrency);
  form33.ClientDataSet1.FieldDefs.Add('P_COMPRA', ftCurrency);
  form33.ClientDataSet1.FieldDefs.Add('QUANT', ftCurrency);
  form33.ClientDataSet1.FieldDefs.Add('NCM', ftString, 15);
  form33.ClientDataSet1.FieldDefs.Add('IS_PIS', ftString, 1);
  form33.ClientDataSet1.FieldDefs.Add('COD_ISPIS', ftString, 3);

  form33.DataSource1.dataset := form33.ClientDataSet1;
  form33.DBGrid1.DataSource := form33.DataSource1;

  form33.ClientDataSet1.CreateDataSet;
  form33.ClientDataSet1.LogChanges := False;
  form33.ClientDataSet1.FieldByName('unid').Visible := False;
  form33.ClientDataSet1.FieldByName('NCM').Visible := False;
  form33.ClientDataSet1.FieldByName('IS_PIS').Visible := False;
  form33.ClientDataSet1.FieldByName('COD_ISPIS').Visible := False;

  TCurrencyField(form33.ClientDataSet1.FieldByName('P_VENDA')).currency
    := False;
  TCurrencyField(form33.ClientDataSet1.FieldByName('QUANT')).currency := False;
  TCurrencyField(form33.ClientDataSet1.FieldByName('P_COMPRA'))
    .currency := False;
  TCurrencyField(form33.ClientDataSet1.FieldByName('QUANT')).DisplayFormat :=
    '#,###,###0.00';
  TCurrencyField(form33.ClientDataSet1.FieldByName('P_VENDA')).DisplayFormat :=
    '#,###,###0.00';
  TCurrencyField(form33.ClientDataSet1.FieldByName('P_COMPRA')).DisplayFormat :=
    '#,###,###0.00';
  form33.campobusca := 'DESCRICAO';
end;

function Tfuncoes.retornaEscalaDoCampo(campo, tabela: String; NOME_CAMPO : string = ''): Smallint;
begin
  campo := QuotedStr(UpperCase(campo));
  tabela := QuotedStr(UpperCase(tabela));

  if NOME_CAMPO = '' then NOME_CAMPO := 'Escala_Campo';

  Result := 0;
  dm.IBselect.Close;
  dm.IBselect.SQL.text :=
    'SELECT R.RDB$FIELD_NAME AS Nome_Campo,F.RDB$FIELD_LENGTH AS Tamanho_Campo, '
    + 'F.RDB$FIELD_PRECISION AS PRECISAO, ABS(F.RDB$FIELD_SCALE) AS Escala_Campo '
    + 'FROM RDB$RELATION_FIELDS R LEFT JOIN RDB$FIELDS F ON R.RDB$FIELD_SOURCE = F.RDB$FIELD_NAME '
    + 'WHERE R.RDB$RELATION_NAME = ' + tabela + ' AND R.RDB$FIELD_NAME = ' +
    campo + ' ORDER BY R.RDB$FIELD_POSITION;';
  dm.IBselect.Open;

  if not dm.IBselect.IsEmpty then
  begin
    Result := dm.IBselect.FieldByName(NOME_CAMPO).AsInteger;
  end;

  dm.IBselect.Close;
end;

function Tfuncoes.manutencaoDeXml(inicia: Smallint): String;
begin
  if inicia = 1 then
  begin
    form33 := tform33.Create(self);
    form33.caption := 'Manutenção de NFCe F2-Marca Envio';
    form33.ClientDataSet1.FieldDefs.Clear;
    form33.ClientDataSet1.FieldDefs.Add('chave', ftString, 45);
    form33.ClientDataSet1.FieldDefs.Add('serie', ftString, 2);
    form33.ClientDataSet1.FieldDefs.Add('erro', ftString, 50);
    form33.ClientDataSet1.FieldDefs.Add('ok', ftInteger);
    form33.ClientDataSet1.CreateDataSet;
    form33.ClientDataSet1.FieldByName('ok').Visible := False;
    form33.DataSource1.dataset := form33.ClientDataSet1;
    form33.DBGrid1.DataSource := form33.DataSource1;
    form33.campobusca := 'nfce';
  end;
end;

function Tfuncoes.marcaXMLNFCeParaEnvio(chave, erro, serie: String): boolean;
var
  arq: tstringList;
  data, opcao: String;
begin
  Result := False;
  {
    1 - Inutilizar NFCe
    2 - Provavelmente não tem conserto
    3 - Marcar no BD
  }

  if erro = '1' then
  begin
    Result := true;
    adicionaNFCeNaoEncontrada(chave, serie);

    {MessageDlg
      ('Esta Rotina Não Foi Implementada! Veja a Numeração e Serie e Inutilize essa NFCe',
      mtInformation, [mbok], 1);}
    exit;
  end
  else if erro = '2' then
  begin
    dm.IBQuery2.Close;
    dm.IBQuery2.SQL.text :=
      'select chave, data from nfce where substring(chave from 23 for 3) = :serie and substring(chave from 26 for 9) = :nnf';
    dm.IBQuery2.ParamByName('serie').AsString := STRZERO(serie, 3);
    dm.IBQuery2.ParamByName('nnf').AsString := STRZERO(chave, 9);
    dm.IBQuery2.Open;

    chave := dm.IBQuery2.FieldByName('chave').AsString;

    arq := tstringList.Create;
    if FileExists(buscaPastaNFCe(chave) + chave + '-nfe.xml') then
    begin
      arq.LoadFromFile(buscaPastaNFCe(chave) + chave + '-nfe.xml');
      data := LeftStr(Le_Nodo('dhEmi', arq.text), 10);
      data := funcoes.dataInglesToBrasil(data);
      arq.Free;

      if FormatDateTime('dd/mm/yy', StrToDate(data)) <> RightStr(erro, 10) then
      begin
        if MessageDlg('Deseja Alterar a Data Do Registro para ' + data + ' ?',
          mtConfirmation, [mbYes, mbNo], 1) = idyes then
        begin
          dm.IBQuery2.Close;
          dm.IBQuery2.SQL.text :=
            'update nfce set data = :data where chave = :chave';
          dm.IBQuery2.ParamByName('data').AsDate := StrToDate(data);
          dm.IBQuery2.ParamByName('chave').AsString := chave;
          dm.IBQuery2.ExecSQL;
          dm.IBQuery2.Transaction.Commit;

          Result := true;
          ShowMessage('Alterado com Sucesso');
        end;
      end;

    end
    else
    begin
      MessageDlg('XML Não Encontrado em: ' + buscaPastaNFCe(chave) + chave +
        '-nfe.xml', mtInformation, [mbok], 1);
    end;

    exit;
  end
  else if erro = '3' then
  begin
    if length(chave) <> 44 then
    begin
      MessageDlg('Chave Inválida! ' + chave, mtInformation, [mbok], 1);
      exit;
    end;

    dm.IBQuery1.Close;
    dm.IBQuery1.SQL.text :=
      'update nfce set adic = ''OFF'' where chave = :chave';
    dm.IBQuery1.ParamByName('chave').AsString := chave;
    dm.IBQuery1.ExecSQL;

    dm.IBQuery1.Transaction.Commit;
    Result := true;
    MessageDlg('Esta Chave ' + chave + ' Vai ser Enviada No DavNFCe Novamente!',
      mtInformation, [mbok], 1);
  end;
end;

function Tfuncoes.criaBackup(): boolean;
var
  arq: tstringList;
  linha, caminho, dias: String;
  ini, a, b: integer;
begin
  Result := False;
  arq := tstringList.Create;

  caminho := caminhoEXE_com_barra_no_final + 'backup\bkp_' +
    FormatDateTime('dd', now) + '_' + FormatDateTime('mm', now) + '_' +
    FormatDateTime('yyyy', now) + '.bkp';
  criaPasta(caminhoEXE_com_barra_no_final + 'backup\');

  dias := '60';

  dm.IBselect.Close;
  dm.IBselect.SQL.text := 'select * from produto';
  dm.IBselect.Open;
  dm.IBselect.FetchAll;
  arq.Add('|PRODUTO|');

  a := 0;
  b := dm.IBselect.RecordCount;

  informacao(a, b, 'Lendo Produtos', true, False, 5);

  while not dm.IBselect.Eof do
  begin
    linha := '|';
    a := a + 1;
    informacao(a, b, 'Lendo Produtos', False, False, 5);
    for ini := 0 to dm.IBselect.FieldCount - 1 do
    begin
      linha := linha + dm.IBselect.FieldByName(dm.IBselect.FieldDefs[ini].Name)
        .AsString + '|';
    end;

    arq.Add(linha);
    dm.IBselect.Next;
  end;

  dm.IBselect.Close;
  dm.IBselect.SQL.text := 'select * from venda where data >= :data';
  dm.IBselect.ParamByName('data').AsDateTime := now - StrToIntDef(dias, 60);
  dm.IBselect.Open;
  dm.IBselect.FetchAll;
  arq.Add('|VENDAS|');

  a := 0;
  b := dm.IBselect.RecordCount;

  informacao(a, b, 'Lendo Vendas', true, False, 5);

  while not dm.IBselect.Eof do
  begin
    linha := '|';
    a := a + 1;
    informacao(a, b, 'Lendo Vendas', False, False, 5);
    for ini := 0 to dm.IBselect.FieldCount - 1 do
    begin
      linha := linha + dm.IBselect.FieldByName(dm.IBselect.FieldDefs[ini].Name)
        .AsString + '|';
    end;

    arq.Add(linha);
    dm.IBselect.Next;
  end;

  dm.IBselect.Close;
  dm.IBselect.SQL.text := 'select * from item_venda where data >= :data';
  dm.IBselect.ParamByName('data').AsDateTime := (now) - StrToIntDef(dias, 60);
  dm.IBselect.Open;
  dm.IBselect.FetchAll;
  arq.Add('|ITEM_VENDA|');

  a := 0;
  b := dm.IBselect.RecordCount;

  informacao(a, b, 'Lendo Produtos Vendidos', true, False, 5);

  while not dm.IBselect.Eof do
  begin
    linha := '|';
    a := a + 1;
    informacao(a, b, 'Lendo Produtos Vendidos', False, False, 5);
    for ini := 0 to dm.IBselect.FieldCount - 1 do
    begin
      linha := linha + dm.IBselect.FieldByName(dm.IBselect.FieldDefs[ini].Name)
        .AsString + '|';
    end;

    arq.Add(linha);
    dm.IBselect.Next;
  end;

  dm.IBselect.Close;
  dm.IBselect.SQL.text :=
    'select * from caixa where cast(data as date) >= :data';
  dm.IBselect.ParamByName('data').AsDateTime := (now) - StrToIntDef(dias, 60);
  dm.IBselect.Open;
  dm.IBselect.FetchAll;
  arq.Add('|CAIXA|');

  a := 0;
  b := dm.IBselect.RecordCount;

  informacao(a, b, 'Lendo Movimento de Caixa', true, False, 5);

  while not dm.IBselect.Eof do
  begin
    linha := '|';
    a := a + 1;

    informacao(a, b, 'Lendo Movimento de Caixa', False, False, 5);
    for ini := 0 to dm.IBselect.FieldCount - 1 do
    begin
      linha := linha + dm.IBselect.FieldByName(dm.IBselect.FieldDefs[ini].Name)
        .AsString + '|';
    end;

    arq.Add(linha);
    dm.IBselect.Next;
  end;

  dm.IBselect.Close;
  arq.SaveToFile(caminho);
  arq.Free;
  informacao(a, b, 'Lendo Vendas', False, true, 5);
  ShowMessage('Backup Criado em: ' + caminho);
end;

function Tfuncoes.exportaTabela(tabela, CAMPOS: String; var arq: TextFile;
  var query: TIBQuery): boolean;
var
  ini, a, b: integer;
  linha: String;
begin
  query.Close;
  query.SQL.text := 'select ' + CAMPOS + ' from ' + tabela;

  if tabela = 'CAIXA' then
  begin
    query.SQL.text := query.SQL.text +
      ' where  cast(data as date) >= (current_date - 60)';
  end;

  if ((tabela = 'CONTASRECEBER') or (tabela = 'CONTASPAGAR')) then
  begin
    query.SQL.text := query.SQL.text + ' where PAGO = 0';
  end;

  if ((tabela = 'VENDA') or (tabela = 'ITEM_VENDA')) then
  begin
    query.SQL.text := query.SQL.text + ' where data >= (current_date - ' +
      buscaParamGeral(80, '15') + ')';
  end;

  if ((tabela = 'ENTRADA') or (tabela = 'ITEM_ENTRADA')) then
  begin
    query.SQL.text := query.SQL.text + ' where DATA >= (current_date - ' +
      IntToStr(trunc(StrToInt(buscaParamGeral(80, '15')) * 4)) + ')';
  end;

  query.Open;
  query.FetchAll;
  Writeln(arq, '|TABELAX|' + UpperCase(tabela) + '|');
  linha := '|CAMPOX|';

  for ini := 0 to query.FieldCount - 1 do
  begin
    linha := linha + query.FieldDefs[ini].Name + '|';
  end;

  Writeln(arq, linha);

  a := 0;
  b := query.RecordCount;

  informacao(a, b, 'Lendo Tabela ' + UpperCase(tabela), true, False, 5);

  while not query.Eof do
  begin
    linha := '|';
    a := a + 1;
    informacao(a, b, 'Lendo Tabela ' + UpperCase(tabela) + '...', False,
      False, 5);

    for ini := 0 to query.FieldCount - 1 do
    begin
      linha := linha + retornaConteudoPeloTipo1(query,
        query.FieldDefs[ini].Name) + '|';
      { if (UpperCase(tabela) = 'CAIXA') and (query.FieldDefs[ini].Name = 'DATA') then begin
        linha := linha + FormatDateTime('mm/dd/yyyy hh:mm:ss', query.FieldByName(query.FieldDefs[ini].Name).AsDateTime) + '|';
        end
        else if (Contido('-' + query.FieldDefs[ini].Name + '-', '-DATA-CHEGADA-DATAMOV-VENCIMENTO-PREVISAO-')) then begin
        try
        if query.FieldByName(query.FieldDefs[ini].Name).IsNull then linha := linha + '01/01/1900' + '|'
        else linha := linha + FormatDateTime('mm/dd/yyyy', query.FieldByName(query.FieldDefs[ini].Name).AsDateTime) + '|';
        except
        on e:exception do begin
        ShowMessage('tabela=' + tabela + #13 + 'campo=' + query.FieldDefs[ini].Name + #13 + 'erro: '+ e.Message);
        end;
        end;
        end
        else begin
        if (query.FieldDefs[ini].Name = 'HORA') then begin
        linha := linha + FormatDateTime('hh:mm:ss', query.FieldByName(query.FieldDefs[ini].Name).AsDateTime) + '|';
        end
        else linha := linha + retornaConteudoPeloTipo(removeCarateresEspeciais(query.FieldByName(query.FieldDefs[ini].Name).AsString), query.FieldDefs[ini].DataType) + '|';
        end; }
    end;

    Writeln(arq, linha);
    query.Next;
  end;

  informacao(a, b, 'Lendo Tabela ' + tabela, False, true, 5);

  a := 0;
  b := 0;
  query.Close;
end;

function Tfuncoes.exportaGenerators(tabela, CAMPOS: String; var arq: TextFile;
  var query: TIBQuery): boolean;
var
  ini, a, b: integer;
  linha: String;
begin
  Result := False;
  query.Close;
  query.SQL.text :=
    'select R.RDB$GENERATOR_NAME as nome from rdb$generators R where rdb$system_flag = 0 and not(rdb$generator_name like ''%$%'')';
  query.Open;
  query.FetchAll;

  Writeln(arq, '|TABELAX|GENERATOR|');
  linha := '|CAMPOX|GENERATOR_NAME|VALUE|';
  Writeln(arq, linha);
  // end;

  a := 0;
  b := query.RecordCount;

  informacao(a, b, 'Lendo Tabela ' + UpperCase(tabela), true, False, 5);

  while not query.Eof do
  begin
    linha := '|';
    a := a + 1;
    informacao(a, b, 'Lendo Tabela ' + UpperCase(tabela) + '...', False,
      False, 5);

    dm.ibquery3.Close;
    dm.ibquery3.SQL.text := 'select gen_id(' + query.FieldByName('nome')
      .AsString + ', 0) as venda from rdb$database';
    dm.ibquery3.Open;

    linha := '|' + trim(query.FieldByName('nome').AsString) + '|' +
      dm.ibquery3.FieldByName('venda').AsString + '|';

    Writeln(arq, linha);
    query.Next;
  end;

  informacao(a, b, 'Lendo Tabela ' + tabela, False, true, 5);

  a := 0;
  b := 0;
  dm.ibquery3.Close;
  query.Close;
end;

function Tfuncoes.sincronizarArquivoDeRemessa(caminho: String;
  var query: TIBQuery): boolean;
var
  ini, a, b: integer;
  linha, CAMPOS, tabela, SQL: String;
  LIN: tstringList;
  arq: TextFile;
begin
  AssignFile(arq, (caminho));
  Reset(arq);
  LIN := tstringList.Create;

  a := 0;
  b := filesize(arq);

  informacao(a, b, 'Sincronizando Tabela ' + UpperCase(tabela), true, False, 5);

  while not Eof(arq) do
  begin
    Readln(arq, linha);
    // ShowMessage(linha);

    if Contido('|TABELAX|', linha) then
    begin
      LE_CAMPOS(LIN, linha, '|', False);
      tabela := LIN.Values['1'];
      Readln(arq, linha);
      LE_CAMPOS(LIN, linha, '|', False);
      CAMPOS := '';
      for ini := 1 to LIN.count - 1 do
      begin
        CAMPOS := CAMPOS + LIN.ValueFromIndex[ini];
        if ini <> LIN.count - 1 then
          CAMPOS := CAMPOS + ',';
      end;

      { if tabela = 'FORNECEDOR' then begin
        ShowMessage(lin.GetText);
        end; }

      Readln(arq, linha);

      if a > 10 then
      begin
        informacao(a, b, 'Sincronizando Tabela ' + UpperCase(tabela),
          False, true, 5);
        informacao(a, b, 'Sincronizando Tabela ' + UpperCase(tabela), true,
          False, 5);
        a := 0;
      end
      else
        informacao(a, b, 'Sincronizando Tabela ' + UpperCase(tabela), true,
          False, 5);
    end;

    a := a + 1;
    informacao(a, b, 'Sincronizando Tabela ' + UpperCase(tabela) + '...', False,
      False, 5);

    SQL := 'update or insert into ' + tabela + '(' + CAMPOS + ') values (';
    LE_CAMPOS(LIN, linha, '|', False);

    { if tabela = 'FORNECEDOR' then begin
      ShowMessage(lin.GetText);
      end;

      ShowMessage(lin.GetText); }

    for ini := 1 to LIN.count - 1 do
    begin
      if ((tabela = 'FORNECEDOR') and (ini = 16)) then
      begin
        SQL := SQL + StrNum(LIN.ValueFromIndex[ini]);
      end
      else
      begin
        if (Contido(',', LIN.ValueFromIndex[ini]) and
          (length(LIN.ValueFromIndex[ini]) < 10)) then
          SQL := SQL + trocaChar(LIN.ValueFromIndex[ini], ',', '.')
        else
          SQL := SQL + QuotedStr((LIN.ValueFromIndex[ini]));
      end;

      if ini <> LIN.count - 1 then
        SQL := SQL + ',';

    end;

    SQL := SQL + ')';

    query.Close;
    query.SQL.text := SQL;

    try
      if LIN.count > 2 then
        query.ExecSQL;
    except
      WriteToTXT(caminhoEXE_com_barra_no_final + 'arq.txt', SQL);
      // ShowMessage(sql);
    end;
  end;

  informacao(a, b, 'Lendo Tabela ' + tabela, False, true, 5);

  a := 0;
  b := 0;
  query.Close;
end;

function Tfuncoes.verificaSePodeVenderFracionado(cod: integer; unid: String;
  quant: currency): boolean;
begin
  Result := true;

  if buscaParamGeral(59, 'S') = 'N' then
    exit;

  if trim(unid) = '' then
  begin
    dm.IBselect.Close;
    dm.IBselect.SQL.text := 'select unid from produto where cod = :cod';
    dm.IBselect.ParamByName('cod').AsInteger := cod;
    dm.IBselect.Open;

    unid := dm.IBselect.FieldByName('unid').AsString;
    if trim(unid) = '' then unid := 'UN';

    dm.IBselect.Close;
  end;

  if Contido('|' + unid + '|', UnidInteiro) = False then
  begin
    if trunc(quant) <> quant then
    begin
      MessageDlg
        ('Nesta Unidade não é permitido a Venda de Quantidade Fracionada. Quant. '
        + formataCurrency(quant), mtInformation, [mbok], 1);
      Result := False;
    end;
  end;
end;

function Tfuncoes.exportaFornecedores(var arq: TextFile): boolean;
var
  linha: String;
  tot: integer;
begin
  dm.IBselect.Close;
  dm.IBselect.SQL.Clear;
  dm.IBselect.SQL.Add
    ('select cod,nome, endereco, cep, fone, fax, cidade,estado,contato, obs, bairro, '
    + 'cnpj, ies, cod_mun, suframa, tipo from fornecedor');
  dm.IBselect.Open;
  dm.IBselect.FetchAll;
  tot := dm.IBselect.RecordCount;

  linha := '|TABELAX|FORNECEDOR|';
  Writeln(arq, linha);

  try
    funcoes.informacao(0, tot, 'Exportando Fornecedores...', true, False, 5);

    while not dm.IBselect.Eof do
    begin
      funcoes.informacao(dm.IBselect.RecNo, tot, 'Exportando Fornecedores...',
        False, False, 5);
      linha := '|' + dm.IBselect.FieldByName('cod').AsString + '|' +
        dm.IBselect.FieldByName('nome').AsString + '|' + dm.IBselect.FieldByName
        ('endereco').AsString + '|' + dm.IBselect.FieldByName('cep').AsString +
        '|' + dm.IBselect.FieldByName('fone').AsString + '|' +
        dm.IBselect.FieldByName('fax').AsString + '|' + dm.IBselect.FieldByName
        ('cidade').AsString + '|' + dm.IBselect.FieldByName('estado').AsString +
        '|' + trim(dm.IBselect.FieldByName('contato').AsString) + '|' +
        trim(dm.IBselect.FieldByName('obs').AsString) + '|' +
        dm.IBselect.FieldByName('bairro').AsString + '|' +
        trim(dm.IBselect.FieldByName('cnpj').AsString) + '|' +
        dm.IBselect.FieldByName('ies').AsString + '|' +
        trim(dm.IBselect.FieldByName('cod_mun').AsString) + '|' +
        dm.IBselect.FieldByName('suframa').AsString + '|' +
        trim(dm.IBselect.FieldByName('tipo').AsString) + '|';

      // Writeln(F, funcoes.Criptografar(linha));
      Writeln(arq, linha);
      dm.IBselect.Next;
    end;
    funcoes.informacao(0, tot, 'Gerando Sincronização...', False, true, 5);
  except
    funcoes.informacao(0, tot, 'Gerando Sincronização...', False, true, 5);
  end;
end;

function Tfuncoes.recebeFornecedores(var arq: tstringList): boolean;
begin
  dm.IBQuery1.Close;
  dm.IBQuery1.SQL.text :=
    ('update or insert into fornecedor(cod,nome, endereco, cep, fone, fax, cidade,estado,contato, obs, bairro, '
    + 'cnpj, ies, cod_mun, suframa, tipo)  values(:cod,:nome, :endereco, :cep, :fone, :fax, :cidade,:estado,:contato, :obs, :bairro, '
    + ':cnpj, :ies, :cod_mun, :suframa, :tipo)');
  dm.IBQuery1.ParamByName('cod').AsString := StrNum(arq.Values['0']);
  dm.IBQuery1.ParamByName('nome').AsString := arq.Values['1'];
  dm.IBQuery1.ParamByName('endereco').AsString := arq.Values['2'];
  dm.IBQuery1.ParamByName('cep').AsString := arq.Values['3'];
  dm.IBQuery1.ParamByName('fone').AsString := arq.Values['4'];
  dm.IBQuery1.ParamByName('fax').AsString := arq.Values['5'];
  dm.IBQuery1.ParamByName('cidade').AsString := arq.Values['6'];
  dm.IBQuery1.ParamByName('estado').AsString := arq.Values['7'];
  dm.IBQuery1.ParamByName('contato').AsString := trim(arq.Values['8']);
  dm.IBQuery1.ParamByName('obs').AsString := arq.Values['9'];
  dm.IBQuery1.ParamByName('bairro').AsString := arq.Values['10'];
  dm.IBQuery1.ParamByName('cnpj').AsString := arq.Values['11'];
  dm.IBQuery1.ParamByName('ies').AsString := arq.Values['12'];
  dm.IBQuery1.ParamByName('cod_mun').AsString := StrNum(arq.Values['13']);
  dm.IBQuery1.ParamByName('suframa').AsString := arq.Values['14'];
  dm.IBQuery1.ParamByName('tipo').AsString := StrNum(arq.Values['15']);
  try
    dm.IBQuery1.ExecSQL;
  except
    on e: exception do
    begin
      ShowMessage('ERRO: ' + arq.text + #13 + e.Message);
    end;
  end;
end;

function Tfuncoes.recebePromoc1(var arq: tstringList;
  var codigos: String): boolean;
begin
  if ((StrToCurrDef(arq.Values['3'], 0) <= 0) or (StrToCurrDef(arq.Values['4'],
    0) <= 0)) then
    exit;
  if Contido('|PROMOC1|', arq.text) then
    exit;

  dm.IBQuery1.Close;
  dm.IBQuery1.SQL.text :=
    ('update or insert into PROMOC1(doc,cod, CODGRU, P_VENDA, QUANT,TIPO) ' +
    ' values(:doc,:cod, :CODGRU, :P_VENDA, :QUANT,:TIPO)');
  dm.IBQuery1.ParamByName('doc').AsString := StrNum(arq.Values['0']);
  dm.IBQuery1.ParamByName('cod').AsString := StrNum(arq.Values['1']);
  dm.IBQuery1.ParamByName('CODGRU').AsString := StrNum(arq.Values['2']);
  dm.IBQuery1.ParamByName('P_VENDA').AsCurrency :=
    StrToCurrDef(arq.Values['3'], 0);
  dm.IBQuery1.ParamByName('QUANT').AsCurrency :=
    StrToCurrDef(arq.Values['4'], 0);
  dm.IBQuery1.ParamByName('TIPO').AsString := arq.Values['5'];
  try
    dm.IBQuery1.ExecSQL;
  except
    on e: exception do
    begin
      ShowMessage('ERRO: ' + arq.text + #13 + e.Message);
    end;
  end;
end;

function Tfuncoes.exportaPromoc1(var arq: TextFile): boolean;
var
  linha: String;
  tot: integer;
begin
  dm.IBselect.Close;
  dm.IBselect.SQL.Clear;
  dm.IBselect.SQL.Add
    ('select doc,cod, CODGRU, P_VENDA, QUANT,TIPO from PROMOC1');
  dm.IBselect.Open;
  dm.IBselect.FetchAll;
  tot := dm.IBselect.RecordCount;

  linha := '|TABELAX|PROMOC1|';
  Writeln(arq, linha);

  try
    funcoes.informacao(0, tot, 'Exportando Promoções...', true, False, 5);

    while not dm.IBselect.Eof do
    begin
      funcoes.informacao(dm.IBselect.RecNo, tot, 'Exportando Promoções...',
        False, False, 5);

      linha := '|' + dm.IBselect.FieldByName('doc').AsString + '|' +
        dm.IBselect.FieldByName('cod').AsString + '|' + dm.IBselect.FieldByName
        ('CODGRU').AsString + '|' + dm.IBselect.FieldByName('P_VENDA').AsString
        + '|' + dm.IBselect.FieldByName('QUANT').AsString + '|' +
        dm.IBselect.FieldByName('TIPO').AsString + '|';

      Writeln(arq, linha);
      dm.IBselect.Next;
    end;
    funcoes.informacao(0, tot, 'Gerando Sincronização...', False, true, 5);
  except
    funcoes.informacao(0, tot, 'Gerando Sincronização...', False, true, 5);
  end;
end;

procedure Tfuncoes.restartGeneratorPelaTabelaMax(tabela, generator: String);
var
  genVaue: integer;
begin
  genVaue := 0;
  dm.IBQuery1.Close;
  dm.IBQuery1.SQL.text := 'select (max(cod)) as cod from ' + tabela;
  dm.IBQuery1.Open;

  if dm.IBQuery1.IsEmpty = False then
    genVaue := dm.IBQuery1.FieldByName('cod').AsInteger;

  dm.IBQuery1.Close;
  dm.IBQuery1.SQL.text := 'alter sequence ' + generator + ' restart with ' +
    IntToStr(genVaue);
  if genVaue > 0 then
    dm.IBQuery1.ExecSQL;

  if dm.IBQuery1.Transaction.InTransaction then
    dm.IBQuery1.Transaction.Commit;
end;

function Tfuncoes.emiteNfe(nota: String = ''; simplificado: boolean = False;
  venda: boolean = False): boolean;
var
  cOp, tipo, Cliente, infoAdi, frete, vFrete, notaNFe, th, DEST_NFE, COD_PAIS,
    _ORIGEM, FIN_NFE, nCF, nCaixa, CHAVE_REF, NFE_REF, natOP1, nomeFIN_NFE,
    DOC_REF, TAG_DOCREF, NUM_ECF, NUM_COO, VLR_DESP, ARREDONDA_QTD, UF_EMI,
    UF_DEST, estorno, coo, adicTemp, tipoCliente, ies: string;
  notas: tstringList;
  i, fim, cupom: integer;
  existe_vendas, OK, exterior: boolean;
  nfeRefLista: tstringList;
begin
  setVersaoNFe;

  TAG_DOCREF := '';
  th := '';
  natOP1 := '';
  cupom := 0;
  infoAdi := '';
  adicTemp := '';
  try
    funcoes.Mensagem(Application.Title, 'Aguarde Conectando com o servidor...',
      12, 'Courier New', False, 0, clRed);
    th := funcoes.verificaPermissaoPagamento;
    if th = '4' then
    begin
      funcoes.Mensagem(Application.Title, '', 15, '',False, 0, clBlack, true);
      ShowMessage('Sistema Não Liberado para Emissao de Notas Fiscais');
      exit;
    end;
    funcoes.Mensagem(Application.Title, '', 15, '',False, 0, clBlack, true);
  except
    funcoes.Mensagem(Application.Title, '', 15, '',False, 0, clBlack, true);
  end;

  If simplificado then
  begin
    if not venda then
    begin
      if nota = '' then
        nota := Incrementa_Generator('venda', 0);
    end;
    // nota := IntToStr(StrToIntDef(nota,0) - 1);
  end;

  // if nota = '' then begin

  if not venda then
  begin
    nota := funcoes.dialogo('not', 100, '1234567890' + #8 + #32, 100,
      simplificado, '', Application.Title, 'Qual a Nota de Venda?', nota);

    if nota = '*' then
      exit;
  end;
  // end;

  if not simplificado then
  begin
    if nota = '' then
    begin
      nCF := funcoes.dialogo('not', 0, '1234567890' + #8 + #32, 50, true, '',
        Application.Title, 'Qual o Número do Cupom Fiscal ?', '');
      if nCF = '*' then
        exit;

      nCaixa := funcoes.dialogo('not', 0, '1234567890' + #8 + #32, 50, true, '',
        Application.Title, 'Qual o Número do Caixa ?', '');
      if nCaixa = '*' then
        exit;

      if length(nCF) <> 6 then
        nCF := STRZERO(nCF, 6);
      if length(nCaixa) <> 3 then
        nCaixa := STRZERO(nCaixa, 3);

      nota := funcoes.acha_vendaCCF(nCF + nCaixa);
      if nota = '' then
      begin
        nota := funcoes.buscaVendaNFCe(nCF, nCaixa, NFE_REF);
        if length(NFE_REF) = 44 then
        begin
          TAG_DOCREF := '<NFref><refNFe>' + StrNum(NFE_REF) +
            '</refNFe></NFref>';
          cupom := 1;
          adicTemp :=
            'NF-e emitida de mercadorias que ja sairam do documento fiscal: ' +
            StrNum(NFE_REF) + ';';
        end;
      end
      else
      begin
        coo := funcoes.dialogo('not', 0, '1234567890' + #8 + #32, 50, true, '',
          Application.Title, 'Qual o Número do Coo do Cupom ?', '');
        if coo = '*' then
          exit;

        if coo = '' then
        begin
          MessageDlg
            ('Para a Emissão Desta NFe é Necessário Informar o COO do Cupom Fiscal',
            mtInformation, [mbok], 1);
          exit;
        end;

        TAG_DOCREF := '<NFref><refECF><mod>2D</mod><nECF>' + StrNum(nCaixa) +
          '</nECF><nCOO>' + StrNum(coo) + '</nCOO></refECF></NFref>';
        cupom := 1;
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
    dm.IBselect.SQL.text := 'select chave from nfce where nota = :nota';
    dm.IBselect.ParamByName('nota').AsInteger := StrToIntDef(nota, 0);
    dm.IBselect.Open;

    if not dm.IBselect.IsEmpty then
    begin
      cOp := '5929';
    end;

  end;

  existe_vendas := False;

  Retorna_Array_de_Numero_de_Notas(notas, nota);
  fim := notas.count - 1;
  for i := 0 to fim do
  begin
    dm.IBselect.Close;
    dm.IBselect.SQL.Clear;
    dm.IBselect.SQL.Add('select cliente from venda where (nota = ' +
      notas.Strings[i] + ') and (cancelado = 0)');
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

  if simplificado = False then
  begin
    if form22.USUARIO = 'ADMIN' then
      notaNFe := funcoes.dialogo('not', 0, '1234567890' + #8 + #32, 50, true,
        '', Application.Title, 'Confirme o Numero da Nota Fiscal?',
        IntToStr(StrToInt(Incrementa_Generator('nfe', 0))))
    else
      notaNFe := funcoes.dialogo('noteditavel', 0, 'EST' + #27, 50, true, 'S',
        Application.Title, 'Confirme o Numero da Nota Fiscal?',
        IfThen(IntToStr(StrToInt(Incrementa_Generator('nfe', 0))) = '0', '1',
        IntToStr(StrToInt(Incrementa_Generator('nfe', 0)))));
  end
  else
  begin
    notaNFe := Incrementa_Generator('nfe', 0);
  end;

  if notaNFe = '*' then
    exit;

  Cliente := '';
  Cliente := dm.IBselect.FieldByName('cliente').AsString;
  dm.IBselect.Close;

  dm.IBselect.Close;
  dm.IBselect.SQL.text := 'select tipo from cliente where cod = :cod';
  dm.IBselect.ParamByName('cod').AsInteger := StrToInt(StrNum(Cliente));
  dm.IBselect.Open;

  tipoCliente := dm.IBselect.FieldByName('tipo').AsString;
  dm.IBselect.Close;

  DEST_NFE := '1';
  if tipoCliente = '7' then
  begin
    DEST_NFE := '2';
  end;

  if simplificado = False then
  begin
    FIN_NFE := funcoes.dialogo('generico', 0, '1234', 50, true, 'S',
      Application.Title,
      'Qual a finalidade da NF-e (1-Normal, 2-Complementar, 3-De ajuste, 4-Devolução de Mercadoria)?',
      '1');
    if FIN_NFE = '*' then
      exit;
  end
  else
    FIN_NFE := '1';

  CHAVE_REF := '';
  NFE_REF := '';
  nomeFIN_NFE := '';

  if funcoes.Contido(FIN_NFE, '2-3-4') then
  begin
    if FIN_NFE = '2' then
      nomeFIN_NFE := 'em complemento'
    else if FIN_NFE = '3' then
      nomeFIN_NFE := 'de Ajuste'
    else if FIN_NFE = '4' then
      nomeFIN_NFE := 'de Devolucao'
    else
      nomeFIN_NFE := 'Referenciada';

    DOC_REF := funcoes.dialogo('generico', 0, '12345', 50, true, 'S',
      Application.Title,
      'Será necessario referenciar um documento fiscal para completar esta operacao. '
      + #13 + 'Qual o tipo do documento (1-NF-e Emitida, 2-NFC-e Emitida, 3-NF-e de Compra, 4-Cupom Fiscal de ECF, 5-Produtor Rural)?',
      '1');
    if DOC_REF = '*' then
      exit;

    if funcoes.Contido(StrNum(DOC_REF), '1') then
    begin
      NFE_REF := funcoes.dialogo('generico', 0, '1234567890' + #8, 50, true, '',
        Application.Title,
        'Qual o numero da NF-e original a ser Complementada/Ajustada/Devolvida ?',
        '');
      if NFE_REF = '*' then
        exit;

      estorno := funcoes.dialogo('generico', 0, 'SN', 50, true, 'S',
        Application.Title, 'Nota Fiscal de Estorno ?', 'S');
      if estorno = '*' then
        exit;

      NFE_REF := funcoes.recuperaChaveNFe(NFE_REF);
      if length(StrNum(NFE_REF)) = 44 then
      begin
        TAG_DOCREF := '<NFref><refNFe>' + StrNum(NFE_REF) + '</refNFe></NFref>';
        infoAdi := 'NF-e ' + nomeFIN_NFE + ' a NF-e Chave: ' +
          StrNum(NFE_REF) + ';';
      end;
    end
    else if funcoes.Contido(StrNum(DOC_REF), '23') then
    begin

      { NFE_REF := funcoes.dialogo('mask', 300,
        '!0000.0000.0000.0000.0000.0000.0000.0000.0000.0000.0000;1;_', 300,
        false, '', 'ControlW', 'Informe a Chave:', '');
        if NFE_REF = '*' then
        exit; }

      NFE_REF := funcoes.MensagemTextoInput
        ('Nota de Devolução. É Obrigatório informar as chaves das NFes que Deseja Devolver.', 'XX');
      nfeRefLista := tstringList.Create;
      nfeRefLista.text := NFE_REF;

      if trim(nfeRefLista.text) = '' then
      begin
        ShowMessage('Preencha a Chave da Nota que deseja Devolver!');
        exit;
      end;

      if FIN_NFE = '3' then
      begin
        natOP1 := funcoes.dialogo('normal', 3, '', 60, true, '', 'ControlW',
          'Descrição da Natureza da Operação:', '');
        if trim(natOP1) = '' then
          exit;

        if natOP1 = '*' then
          exit;
      end;

      TAG_DOCREF := '';

      if nfeRefLista.count > 0 then
      begin
        for i := 0 to nfeRefLista.count - 1 do
        begin
          NFE_REF := nfeRefLista[i];
          if length(StrNum(NFE_REF)) = 44 then
          begin
            TAG_DOCREF := TAG_DOCREF + '<NFref><refNFe>' + StrNum(NFE_REF) +
              '</refNFe>' + '</NFref>';
            infoAdi := infoAdi + StrNum(NFE_REF) + ';';
            // infoAdi := 'NF-e ' + nomeFIN_NFE + ' a NF-e Chave: ' +
            // StrNum(NFE_REF) + ';';
          end;
        end;

        if TAG_DOCREF <> '' then
        begin
          infoAdi := 'NF-e ' + nomeFIN_NFE + ' a NF-e Chave: ' + infoAdi;
        end;

      end;
    end
    else if funcoes.Contido(StrNum(DOC_REF), '4') then
    begin
      NUM_ECF := funcoes.dialogo('not', 0, '1234567890' + #8, 50, False, '',
        Application.Title, 'Informe o numero do ECF:', '');
      if NUM_ECF = '*' then
        exit;

      NUM_COO := funcoes.dialogo('not', 0, '1234567890' + #8, 50, False, '',
        Application.Title, 'Informe o numero do COO:', '');
      if NUM_COO = '*' then
        exit;

      TAG_DOCREF := '<NFref><refECF><mod>2D</mod><nECF>' + StrNum(NUM_ECF) +
        '</nECF>' + '<nCOO>' + StrNum(NUM_COO) + '</nCOO>' +
        '</refECF></NFref>';
      infoAdi := 'NF-e ' + nomeFIN_NFE + ' do ECF: ' + StrNum(NUM_ECF) +
        ' COO: ' + StrNum(NUM_COO) + ';';
    end
    else if funcoes.Contido(StrNum(DOC_REF), '5') then
    begin
      form73.ShowModal;
      if form73.nnf.text = '' then
      begin
        ShowMessage('Numero da Nota Fiscal Inválido!');
        exit;
      end;

      if form73.serie.text = '' then
      begin
        ShowMessage('Serie da Nota Fiscal Inválida!');
        exit;
      end;

      { NUM_ECF := funcoes.dialogo('not', 0, '1234567890' + #8, 50, false, '',
        Application.Title, 'Informe o numero do ECF:', '');
        if NUM_ECF = '*' then
        exit;

        NUM_COO := funcoes.dialogo('not', 0, '1234567890' + #8, 50, false, '',
        Application.Title, 'Informe o numero do COO:', '');
        if NUM_COO = '*' then
        exit;

        TAG_DOCREF := '<NFref><refECF><mod>2D</mod><nECF>' + StrNum(NUM_ECF) +
        '</nECF>' + '<nCOO>' + StrNum(NUM_COO) + '</nCOO>' +
        '</refECF></NFref>';
        infoAdi := 'NF-e ' + nomeFIN_NFE + ' do ECF: ' + StrNum(NUM_ECF) +
        ' COO: ' + StrNum(NUM_COO) + ';'; }
    end;

    { NFE_REF := funcoes.dialogo('not',0,'1234567890'+#8+#32,50,true,'',Application.Title,'Qual o numero da NF-e original a ser Complementada/Ajustada ?','');
      if NFE_REF = '*' then exit; }

    // CHAVE_REF := funcoes.recuperaChaveNFe(NFE_REF);
    CHAVE_REF := StrNum(NFE_REF);

  end;

  if simplificado = False then
  begin
    tipo := funcoes.dialogo('generico', 0, 'EST' + #27, 50, true, 'S',
      Application.Title,
      'Nota Fiscal de Entrada, Saída ou Transferência (E/S/T) ?', 'S');
    if tipo = '*' then
      exit;

    _ORIGEM := '0';

    if FIN_NFE = '4' then
    begin
      _ORIGEM := funcoes.dialogo('generico', 0, '0123' + #27, 50, true, 'S',
        Application.Title,
        'Qual a Origem da Mercadoria (0-Nacional, 1-Estrangeira,' +
        ' 2-Estrageira Ad. Merc. Interno,' + #13 +
        '3-Nacional, mercadoria ou bem com Conteúdo de' +
        ' Importação superior a 40% (quarenta por cento))?', _ORIGEM);
    end
    else
    begin
      _ORIGEM := funcoes.dialogo('generico', 0, '012' + #27, 50, true, 'S',
        Application.Title,
        'Qual a Origem da Mercadoria (0-Nacional, 1-Estrangeira, 2-Estrageira Ad. Merc. Interno)?',
        _ORIGEM);
    end;

    if _ORIGEM = '*' then
      exit;

    { _ORIGEM := funcoes.dialogo('generico', 0, '012' + #27, 50, true, 'S',
      Application.Title,
      'Qual a Origem da Mercadoria '+#13+
      '0-Nacional '+#13 +
      '1-Estrangeira'+#13+
      '2-Estrageira Ad. Merc. Interno'+#13 +
      '3-Nacional, mercadoria ou bem com Conteúdo de Importação superior a 40% (quarenta por cento)'+#13 +
      ')?',
      _ORIGEM); }

    DEST_NFE := funcoes.dialogo('generico', 0, '12', 50, true, 'S',
      Application.Title,
      'Qual o destino da Mercadoria (1-Mercado Interno 2-Comercio Exterior)?',
      DEST_NFE);
    if DEST_NFE = '*' then
      exit;
  end
  else
  begin
    tipo := 'S';
    _ORIGEM := '0';
    DEST_NFE := '1';
  end;

  COD_PAIS := '1058';
  // cOp := '';
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
      dm.IBQuery1.SQL.Add
        ('update or insert into cod_op(cod, nome) values(:cod, :nome) matching(cod)');
      dm.IBQuery1.ParamByName('cod').AsString := '7102';
      dm.IBQuery1.ParamByName('nome').AsString := 'VEND MERC AD TERC-COM. EXT.';
      dm.IBQuery1.ExecSQL;

      dm.IBQuery1.Transaction.Commit;
    end;

    dm.IBselect.Close;

    COD_PAIS := funcoes.VE_PAIS();
  end;

  // if simplificado then cOp := '5102';
  cOp := buscaParamGeral(96, '5102');
  if ((trim(cOp) = '') or (length(cOp) <> 4) or (LeftStr(cOp, 1) <> '5')) then
    cOp := '5102';

  if cOp = '' then
  begin
    dm.IBselect.Close;
    dm.IBselect.SQL.Clear;
    dm.IBselect.SQL.Add
      ('select nfe from acesso where substring(acesso from 1 for 1) = ''-''');
    dm.IBselect.Open;

    cOp := dm.IBselect.FieldByName('nfe').AsString;
    dm.IBselect.Close;
  end;

  if cOp = '*' then
    exit;

  { infoAdi := '';
    if length(StrNum(CHAVE_REF)) = 44 then
    begin
    if FIN_NFE = '2' then nomeFIN_NFE := 'em complemento'
    else if FIN_NFE = '3' then nomeFIN_NFE := 'de Ajuste'
    else if FIN_NFE = '4' then nomeFIN_NFE := 'de Devolução'
    else nomeFIN_NFE := 'Referenciada';

    infoAdi := 'NF-e '+ nomeFIN_NFE +' a NF-e Chave: ' + StrNum(CHAVE_REF) + ';';
    end; }

  if simplificado = False then
  begin
    infoAdi := funcoes.MensagemTextoInput('Informações Adicionais', infoAdi);
  end;



  while true do
  begin
    Cliente := funcoes.dialogo('generico', 0, '1234567890,.' + #8, 50, False,
      '', Application.Title, 'Qual o Código do Cliente?', Cliente);

    Cliente := trim(Cliente);
    if Cliente = '*' then
      exit;
    if Cliente = '' then
      Cliente := funcoes.localizar('Localizar Cliente', 'cliente',
        'cod,nome,telres,telcom,cnpj as cpfcnpj,bairro', 'cod', '', 'nome',
        'nome', False, False, False, '', 450, nil);
    if (Cliente = '*') then
    begin
      ShowMessage('Para emitir uma NFe é necessario um cliente.');
      exit;
    end;

    exterior := False;
    if DEST_NFE = '2' then
      exterior := true;

    if verificaDadosClienteNFe(StrNum(Cliente), exterior) then
      break;
  end;

  dm.IBselect.Close;
  dm.IBselect.SQL.text := 'select est from registro';
  dm.IBselect.Open;

  UF_EMI := dm.IBselect.FieldByName('est').AsString;

  dm.IBselect.Close;
  dm.IBselect.SQL.text :=
    'select cnpj, ies, est, cod_mun from cliente where cod = :cod';
  dm.IBselect.ParamByName('cod').AsString := StrNum(Cliente);
  dm.IBselect.Open;

  if DOC_REF = '5' then
  begin
    ies := StrNum(dm.IBselect.FieldByName('ies').AsString);
    if length(ies) < 5 then
      ies := 'ISENTO';

    TAG_DOCREF := '<NFref><refNFP><cUF>' +
      LeftStr(dm.IBselect.FieldByName('cod_mun').AsString, 2) + '</cUF>' +
      '<AAMM>' + FormatDateTime('yymm', now) + '</AAMM><CPF>' +
      StrNum(dm.IBselect.FieldByName('cnpj').AsString) + '</CPF>' + '<IE>' + ies
      + '</IE><mod>04</mod>' + '<serie>' + form73.serie.text + '</serie><nNF>' +
      form73.nnf.text + '</nNF></refNFP></NFref>';
  end;

  UF_DEST := dm.IBselect.FieldByName('est').AsString;
  dm.IBselect.Close;

  if DEST_NFE = '2' then
    cOp := '7102'
  else if (UF_EMI = UF_DEST) then
  begin
    if cupom = 1 then
      cOp := '5929';
    if FIN_NFE = '4' then
      cOp := '5202';
  end
  else if (UF_EMI <> UF_DEST) then
  begin
    cOp := '6102';
    cOp := buscaParamGeral(97, '6102');
    if ((trim(cOp) = '') or (length(cOp) <> 4) or (LeftStr(cOp, 1) <> '6')) then
      cOp := '6102';

    if FIN_NFE = '4' then
      cOp := '6202';
    // if cupom = 1 then cOp := '6929';
  end;

  OK := False;
  if simplificado = False then
  begin
    while not OK do
    begin
      cOp := funcoes.dialogo('generico', 0, '1234567890,.' + #8, 50, False, '',
        Application.Title, 'Qual o Código da Operação?', cOp);
      if cOp = '' then
        cOp := funcoes.localizar('Localizar cOP', 'cod_op', 'cod,nome', 'cod',
          '', 'nome', 'cod', False, False, False, '', 0, nil);
      if cOp = '*' then
        break;

      if ((tipo = 'E') and (funcoes.Contido(LeftStr(cOp, 1), '123'))) or
        ((tipo = 'S') and (funcoes.Contido(LeftStr(cOp, 1), '567'))) then
      begin
        OK := funcoes.validaCFOP_UF(cOp, UF_DEST, UF_EMI);
        // ok := true;
      end
      else if ((tipo = 'T') and (funcoes.Contido(LeftStr(cOp, 1), '1234567')))
      then
      begin
        OK := funcoes.validaCFOP_UF(cOp, UF_DEST, UF_EMI);
        // ok := true;
      end
      else
        ShowMessage
          ('O código do CFOP é inválido para esta operação. Para entrada use CFOP que '
          + #13 + #10 +
          'se inicie com 1, 2 ou 3. Para saída use CFOP que se inicie com 5, 6 ou 7.');

      if OK then
      begin
        dm.IBQuery2.Close;
        dm.IBQuery2.SQL.Clear;
        dm.IBQuery2.SQL.Add('select * from cod_op where cod = :cod');
        dm.IBQuery2.ParamByName('cod').AsString := funcoes.StrNum(cOp);
        dm.IBQuery2.Open;

        if dm.IBQuery2.IsEmpty then
        begin
          if cOp = '5929' then
          begin
            dm.IBQuery1.Close;
            dm.IBQuery1.SQL.text :=
              'insert into cod_op(cod, nome, pis, icms) values(5929, ''LANCAMENTO REGISTRADO EM ECF'', ''I'', ''I'')';
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
          ShowMessage('Código de Operação ' + cOp + ' Não está Cadastrado.');
          exit;
        end
        else
        begin
          if natOP1 = '' then
            natOP1 := dm.IBQuery2.FieldByName('nome').AsString;
          OK := true;
        end;
      end;
    end;

  end
  else
  begin
    dm.IBQuery2.Close;
    dm.IBQuery2.SQL.Clear;
    dm.IBQuery2.SQL.Add('select * from cod_op where cod = :cod');
    dm.IBQuery2.ParamByName('cod').AsString := funcoes.StrNum(cOp);
    dm.IBQuery2.Open;

    natOP1 := dm.IBQuery2.FieldByName('nome').AsString;
    // dm.IBQuery2.Close;
  end;

  if estorno = 'S' then
  begin
    natOP1 := '999 - Estorno de NF-e não cancelada no prazo legal';
  end;

  if cOp = '*' then
    exit;

  dm.IBselect.Close;
  dm.IBselect.SQL.Clear;
  dm.IBselect.SQL.Add('select cod from cliente where cod = :cod');
  dm.IBselect.ParamByName('cod').AsString := funcoes.StrNum(Cliente);
  dm.IBselect.Open;

  if dm.IBselect.IsEmpty then
  begin
    dm.IBselect.Close;
    ShowMessage('Cliente ' + Cliente + ' Não Encontrado.');
    exit;
  end;

  dm.IBselect.Close;

  infoAdi := adicTemp + infoAdi;

  NfeVenda := tnfevenda.Create(self);
  NfeVenda.cupom := cupom;
  NfeVenda.DEST := Cliente;
  NfeVenda.frete := tstringList.Create;
  NfeVenda.frete.Values['0'] := '9';

  if simplificado = False then
  begin
    if ConfParamGerais.Strings[15] = 'S' then
    begin
      frete := funcoes.dialogo('generico', 0, '190,.' + #8, 50, False, '',
        Application.Title,
        'Frete por Conta do: (0-Emitente 1-Destinatário 9-Sem Frete)?', '9');
      if frete = '*' then
        exit;
      // nfevenda.frete.Add('');
      NfeVenda.frete.Values['0'] := (frete);
      vFrete := '0';

      if StrNum(frete) <> '9' then
      begin
        form43 := tform43.Create(self);
        funcoes.AjustaForm(form43);

        form43.tipofrete.text := StrNum(frete);
        form43.ShowModal;

        if Contido(form43.tipofrete.text, '091') then
          frete := form43.tipofrete.text;

        if form43.tipofrete.text <> '9' then
          vFrete := funcoes.dialogo('numero', 0, '190,.' + #8, 2, False, '',
            Application.Title, 'Qual o valor do Frete?', '0,00');
        if vFrete = '*' then
          exit;
        if NfeVenda.frete = nil then
          exit;
      end;

      try
        NfeVenda.tipo_frete := StrToInt(funcoes.StrNum(frete));
        NfeVenda.TotalFrete := 0;

        if frete <> '9' then
          NfeVenda.TotalFrete := StrToCurr(funcoes.ConverteNumerico(vFrete));
      except
        on e: exception do
        begin
          MessageDlg('Erro: ' + e.Message, mtError, [mbok], 1);
          exit;
        end;
      end;
    end
    else
      NfeVenda.tipo_frete := 9;
  end
  else
  begin
    NfeVenda.tipo_frete := 9;
  end;

  if not(NfeVenda.tipo_frete in [0, 1, 9]) then
    NfeVenda.tipo_frete := 9;

  VLR_DESP := '0';

  if simplificado = False then
  begin
    VLR_DESP := funcoes.dialogo('generico', 0, 'SN', 50, true, 'S',
      Application.Title, 'Deseja informar valor de despesas acessorias ?', 'N');
    if VLR_DESP = '*' then
      exit;

    if VLR_DESP = 'S' then
    begin
      VLR_DESP := funcoes.dialogo('numero', 0, 'SN', 2, true, 'S',
        Application.Title, 'Qual o valor das despesas acessorias ?', '0,00');
      if VLR_DESP = '*' then
        exit;
    end
    else
      VLR_DESP := '0';
  end;

  { ARREDONDA_QTD := funcoes.dialogo('generico',0,'SN',50,true,'S',Application.Title,'Deseja Forçar Arredondamento para Efetuar a Equivalencia de Totais ?','N');
    if ARREDONDA_QTD = '*' then exit;

    if ARREDONDA_QTD = 'S' then NfeVenda.arredondarQTD := true
    else  NfeVenda.arredondarQTD := false; }

  NfeVenda.UF_EMI := UF_EMI;
  NfeVenda.UF_DEST := UF_DEST;
  NfeVenda.VLR_DESP := StrToCurrDef(VLR_DESP, 0);
  NfeVenda.codNFe := notaNFe;
  NfeVenda.cod_OP := cOp;
  NfeVenda.codPaisDest := COD_PAIS;

  NfeVenda.natOp := natOP1;
  NfeVenda.cstIcmCfop := dm.IBQuery2.FieldByName('icms').AsString;
  NfeVenda.cstpisCfop := dm.IBQuery2.FieldByName('pis').AsString;
  dm.IBQuery2.Close;

  NfeVenda.tipo := tipo;
  NfeVenda.DEST_NFE := DEST_NFE;
  NfeVenda.infAdic := infoAdi;
  NfeVenda.notas := notas;
  NfeVenda._ORIGEM := _ORIGEM;
  NfeVenda.FIN_NFE1 := FIN_NFE;
  NfeVenda.TAG_DOCREF := TAG_DOCREF;
  NfeVenda.NFE_REF := StrNum(NFE_REF);

  try
    if ConfParamGerais[36] <> 'N' then
      NfeVenda.GeraXml
    else
      NfeVenda.GeraXml1;
  except
    on e: exception do
    begin
      MessageDlg('Erro: ' + e.Message, mtError, [mbok], 1);
      if funcoes.Contido('LENGTH', UpperCase(e.Message)) then
      begin
        // NfeVenda.GeraXml;
      END;
    end;
  end;
  NfeVenda.Free;
end;

function Tfuncoes.limitar_QTD_Estoque(quant: currency;
  cod, origem: integer): boolean;
var
  campo, permitir: string;
begin
  if origem = 1 then
    campo := 'quant'
  else
    campo := 'deposito';
  Result := true;

  dm.ibquery4.Close;
  dm.ibquery4.SQL.text := 'select ' + campo + ' from produto where cod = :cod';
  dm.ibquery4.ParamByName('cod').AsInteger := cod;
  dm.ibquery4.Open;

  permitir := 'S';
  // permitir := funcoes.LerConfig(form22.Pgerais.Values['configu'], 7);

  if quant > dm.ibquery4.FieldByName(campo).AsCurrency then
  begin
    if permitir <> 'N' then // permitir venda sem estoque disponivel
    begin
      WWMessage('A Venda Esta Sendo Feita Sem Estoque Disponivel',
        mtInformation, [mbok], HexToTColor('FFD700'), true, False,
        HexToTColor('FE3C3C'));
    end
    else
    begin
      WWMessage('O Produto Nao Tem Estoque Disponivel', mtInformation, [mbok],
        HexToTColor('FFD700'), true, False, HexToTColor('B22222'));
      Result := False;
    end;
  end;

  dm.ibquery4.Close;
end;

procedure Tfuncoes.alinhabdgrid(var bdgrid: TDBGrid);
var
  ini, size1: integer;
begin
  size1 := screen.Width;
  for ini := 0 to bdgrid.Columns.count - 1 do
  begin
    if bdgrid.Columns[ini].Field.DataType = ftInteger then
    begin
      if size1 = 1024 then
      begin
        bdgrid.Columns[ini].Width := 50;
      end;
    end;
  end;
end;

procedure Tfuncoes.fechaClientDataSet(var ccds: TClientDataSet);
begin
  ccds.Active := False;
  // ccds.Close;
  // ccds.free;
end;

function Tfuncoes.validaCFOP_UF(cfop, UF_DEST, UF_EMIT: String): boolean;
begin
  Result := true;
  if ((Contido(LeftStr(cfop, 1), '26')) and (UF_DEST = UF_EMIT)) then
  begin
    Result := False;
    MessageDlg
      ('CFOP Inválido para NFe para Destinatário do mesmo Estado do Emitente!' +
      #13 + 'UF Destinatário: ' + UF_DEST + #13 + 'UF Emitente:     ' + UF_EMIT
      + #13 + 'Para essa Operação deve usar CFOP Iniciado em 1 ou 5.',
      mtInformation, [mbok], 1);
  end;

  if ((Contido(LeftStr(cfop, 1), '15')) and (UF_DEST <> UF_EMIT)) then
  begin
    Result := False;
    MessageDlg('CFOP Inválido para NFe Interestadual!' + #13 +
      'UF Destinatário: ' + UF_DEST + #13 + 'UF Emitente:     ' + UF_EMIT + #13
      + 'Para essa Operação deve usar CFOP Iniciado em 2 ou 6.', mtInformation,
      [mbok], 1);
  end;
end;

Function Tfuncoes.Inscricao(Inscricao, tipo: String): boolean;
Var

  Contador: ShortInt;
  Casos: ShortInt;
  digitos: ShortInt;

  Tabela_1: String;
  Tabela_2: String;
  Tabela_3: String;

  Base_1: String;
  Base_2: String;
  Base_3: String;

  Valor_1: ShortInt;

  Soma_1: integer;
  Soma_2: integer;

  Erro_1: ShortInt;
  Erro_2: ShortInt;
  Erro_3: ShortInt;

  Posicao_1: string;
  Posicao_2: String;

  tabela: String;
  Rotina: String;
  Modulo: ShortInt;
  peso: String;

  Digito: ShortInt;

  Resultado: String;
  retorno: boolean;

Begin
  Result := true;
  exit;
  Try

    Tabela_1 := ' ';
    Tabela_2 := ' ';
    Tabela_3 := ' ';

    { }                                                                                                                 { }
    { Valores possiveis para os digitos (j) }
    { }
    { 0 a 9 = Somente o digito indicado. }
    { N = Numeros 0 1 2 3 4 5 6 7 8 ou 9 }
    { A = Numeros 1 2 3 4 5 6 7 8 ou 9 }
    { B = Numeros 0 3 5 7 ou 8 }
    { C = Numeros 4 ou 7 }
    { D = Numeros 3 ou 4 }
    { E = Numeros 0 ou 8 }
    { F = Numeros 0 1 ou 5 }
    { G = Numeros 1 7 8 ou 9 }
    { H = Numeros 0 1 2 ou 3 }
    { I = Numeros 0 1 2 3 ou 4 }
    { J = Numeros 0 ou 9 }
    { K = Numeros 1 2 3 ou 9 }
    { }
    { -------------------------------------------------------- }
    { }
    { Valores possiveis para as rotinas (d) e (g) }
    { }
    { A a E = Somente a Letra indicada. }
    { 0 = B e D }
    { 1 = C e E }
    { 2 = A e E }
    { }
    { -------------------------------------------------------- }
    { }
    { C T  F R M  P  R M  P }
    { A A  A O O  E  O O  E }
    { S M  T T D  S  T D  S }
    { }
    { a b  c d e  f  g h  i  jjjjjjjjjjjjjj }
    { 0000000001111111111222222222233333333 }
    { 1234567890123456789012345678901234567 }

    IF tipo = 'AC' Then
      Tabela_1 := '1.09.0.E.11.01. .  .  .     01NNNNNNX.14.00';
    IF tipo = 'AC' Then
      Tabela_2 := '2.13.0.E.11.02.E.11.01. 01NNNNNNNNNXY.13.14';
    IF tipo = 'AL' Then
      Tabela_1 := '1.09.0.0.11.01. .  .  .     24BNNNNNX.14.00';
    IF tipo = 'AP' Then
      Tabela_1 := '1.09.0.1.11.01. .  .  .     03NNNNNNX.14.00';
    IF tipo = 'AP' Then
      Tabela_2 := '2.09.1.1.11.01. .  .  .     03NNNNNNX.14.00';
    IF tipo = 'AP' Then
      Tabela_3 := '3.09.0.E.11.01. .  .  .     03NNNNNNX.14.00';
    IF tipo = 'AM' Then
      Tabela_1 := '1.09.0.E.11.01. .  .  .     0CNNNNNNX.14.00';
    IF tipo = 'BA' Then
      Tabela_1 := '1.08.0.E.10.02.E.10.03.      NNNNNNYX.14.13';
    IF tipo = 'BA' Then
      Tabela_2 := '2.08.0.E.11.02.E.11.03.      NNNNNNYX.14.13';
    IF tipo = 'CE' Then
      Tabela_1 := '1.09.0.E.11.01. .  .  .     0NNNNNNNX.14.13';
    IF tipo = 'DF' Then
      Tabela_1 := '1.13.0.E.11.02.E.11.01. 07DNNNNNNNNXY.13.14';
    IF tipo = 'ES' Then
      Tabela_1 := '1.09.0.E.11.01. .  .  .     0ENNNNNNX.14.00';
    IF tipo = 'GO' Then
      Tabela_1 := '1.09.1.E.11.01. .  .  .     1FNNNNNNX.14.00';
    IF tipo = 'GO' Then
      Tabela_2 := '2.09.0.E.11.01. .  .  .     1FNNNNNNX.14.00';
    IF tipo = 'MA' Then
      Tabela_1 := '1.09.0.E.11.01. .  .  .     12NNNNNNX.14.00';
    IF tipo = 'MT' Then
      Tabela_1 := '1.11.0.E.11.01. .  .  .   NNNNNNNNNNX.14.00';
    IF tipo = 'MS' Then
      Tabela_1 := '1.09.0.E.11.01. .  .  .     28NNNNNNX.14.00';
    IF tipo = 'MG' Then
      Tabela_1 := '1.13.0.2.10.10.E.11.11. NNNNNNNNNNNXY.13.14';
    IF tipo = 'PA' Then
      Tabela_1 := '1.09.0.E.11.01. .  .  .     15NNNNNNX.14.00';
    IF tipo = 'PB' Then
      Tabela_1 := '1.09.0.E.11.01. .  .  .     16NNNNNNX.14.00';
    IF tipo = 'PR' Then
      Tabela_1 := '1.10.0.E.11.09.E.11.08.    NNNNNNNNXY.13.14';
    IF tipo = 'PE' Then
      Tabela_1 := '1.14.1.E.11.07. .  .  .18ANNNNNNNNNNX.14.00';
    IF tipo = 'PI' Then
      Tabela_1 := '1.09.0.E.11.01. .  .  .     19NNNNNNX.14.00';
    IF tipo = 'RJ' Then
      Tabela_1 := '1.08.0.E.11.08. .  .  .      GNNNNNNX.14.00';
    IF tipo = 'RN' Then
      Tabela_1 := '1.09.0.0.11.01. .  .  .     20HNNNNNX.14.00';
    IF tipo = 'RS' Then
      Tabela_1 := '1.10.0.E.11.01. .  .  .    INNNNNNNNX.14.00';
    IF tipo = 'RO' Then
      Tabela_1 := '1.09.1.E.11.04. .  .  .     ANNNNNNNX.14.00';
    IF tipo = 'RO' Then
      Tabela_2 := '2.14.0.E.11.01. .  .  .NNNNNNNNNNNNNX.14.00';
    IF tipo = 'RR' Then
      Tabela_1 := '1.09.0.D.09.05. .  .  .     24NNNNNNX.14.00';
    IF tipo = 'SC' Then
      Tabela_1 := '1.09.0.E.11.01. .  .  .     NNNNNNNNX.14.00';
    IF tipo = 'SP' Then
      Tabela_1 := '1.12.0.D.11.12.D.11.13.  NNNNNNNNXNNY.11.14';
    IF tipo = 'SP' Then
      Tabela_2 := '2.12.0.D.11.12. .  .  .  NNNNNNNNXNNN.11.00';
    IF tipo = 'SE' Then
      Tabela_1 := '1.09.0.E.11.01. .  .  .     NNNNNNNNX.14.00';
    IF tipo = 'TO' Then
      Tabela_1 := '1.11.0.E.11.06. .  .  .   29JKNNNNNNX.14.00';

    IF tipo = 'CNPJ' Then
      Tabela_1 := '1.14.0.E.11.21.E.11.22.NNNNNNNNNNNNXY.13.14';
    IF tipo = 'CPF' Then
      Tabela_1 := '1.11.0.E.11.31.E.11.32.   NNNNNNNNNXY.13.14';

    { Deixa somente os numeros }

    Base_1 := '';

    For Contador := 1 TO 30 Do
      IF pos(copy(Inscricao, Contador, 1), '0123456789') <> 0 Then
        Base_1 := Base_1 + copy(Inscricao, Contador, 1);

    { Repete 3x - 1 para cada caso possivel }

    Casos := 0;

    Erro_1 := 0;
    Erro_2 := 0;
    Erro_3 := 0;

    While Casos < 3 Do
    Begin

      Casos := Casos + 1;

      IF Casos = 1 Then
        tabela := Tabela_1;
      IF Casos = 2 Then
        Erro_1 := Erro_3;
      IF Casos = 2 Then
        tabela := Tabela_2;
      IF Casos = 3 Then
        Erro_2 := Erro_3;
      IF Casos = 3 Then
        tabela := Tabela_3;

      Erro_3 := 0;

      IF copy(tabela, 1, 1) <> ' ' Then
      Begin

        { Verifica o Tamanho }

        IF length(trim(Base_1)) <> (StrToInt(copy(tabela, 3, 2))) Then
          Erro_3 := 1;

        IF Erro_3 = 0 Then
        Begin

          { Ajusta o Tamanho }

          Base_2 := copy('              ' + Base_1,
            length('              ' + Base_1) - 13, 14);

          { Compara com valores possivel para cada uma da 14 posições }

          Contador := 0;

          While (Contador < 14) AND (Erro_3 = 0) Do
          Begin

            Contador := Contador + 1;

            Posicao_1 := copy(copy(tabela, 24, 14), Contador, 1);
            Posicao_2 := copy(Base_2, Contador, 1);

            IF (Posicao_1 = ' ') AND (Posicao_2 <> ' ') Then
              Erro_3 := 1;
            IF (Posicao_1 = 'N') AND (pos(Posicao_2, '0123456789') = 0) Then
              Erro_3 := 1;
            IF (Posicao_1 = 'A') AND (pos(Posicao_2, '123456789') = 0) Then
              Erro_3 := 1;
            IF (Posicao_1 = 'B') AND (pos(Posicao_2, '03578') = 0) Then
              Erro_3 := 1;
            IF (Posicao_1 = 'C') AND (pos(Posicao_2, '47') = 0) Then
              Erro_3 := 1;
            IF (Posicao_1 = 'D') AND (pos(Posicao_2, '34') = 0) Then
              Erro_3 := 1;
            IF (Posicao_1 = 'E') AND (pos(Posicao_2, '08') = 0) Then
              Erro_3 := 1;
            IF (Posicao_1 = 'F') AND (pos(Posicao_2, '015') = 0) Then
              Erro_3 := 1;
            IF (Posicao_1 = 'G') AND (pos(Posicao_2, '1789') = 0) Then
              Erro_3 := 1;
            IF (Posicao_1 = 'H') AND (pos(Posicao_2, '0123') = 0) Then
              Erro_3 := 1;
            IF (Posicao_1 = 'I') AND (pos(Posicao_2, '01234') = 0) Then
              Erro_3 := 1;
            IF (Posicao_1 = 'J') AND (pos(Posicao_2, '09') = 0) Then
              Erro_3 := 1;
            IF (Posicao_1 = 'K') AND (pos(Posicao_2, '1239') = 0) Then
              Erro_3 := 1;
            IF (Posicao_1 <> Posicao_2) AND
              (pos(Posicao_1, '0123456789') > 0) Then
              Erro_3 := 1;

          End;

          { Calcula os Digitos }

          Rotina := ' ';
          digitos := 000;
          Digito := 000;

          While (digitos < 2) AND (Erro_3 = 0) Do
          Begin

            digitos := digitos + 1;

            { Carrega peso }

            peso := copy(tabela, 5 + (digitos * 8), 2);

            IF peso <> '  ' Then
            Begin

              Rotina := copy(tabela, 0 + (digitos * 8), 1);
              Modulo := StrToInt(copy(tabela, 2 + (digitos * 8), 2));

              IF peso = '01' Then
                peso := '06.05.04.03.02.09.08.07.06.05.04.03.02.00';
              IF peso = '02' Then
                peso := '05.04.03.02.09.08.07.06.05.04.03.02.00.00';
              IF peso = '03' Then
                peso := '06.05.04.03.02.09.08.07.06.05.04.03.00.02';
              IF peso = '04' Then
                peso := '00.00.00.00.00.00.00.00.06.05.04.03.02.00';
              IF peso = '05' Then
                peso := '00.00.00.00.00.01.02.03.04.05.06.07.08.00';
              IF peso = '06' Then
                peso := '00.00.00.09.08.00.00.07.06.05.04.03.02.00';
              IF peso = '07' Then
                peso := '05.04.03.02.01.09.08.07.06.05.04.03.02.00';
              IF peso = '08' Then
                peso := '08.07.06.05.04.03.02.07.06.05.04.03.02.00';
              IF peso = '09' Then
                peso := '07.06.05.04.03.02.07.06.05.04.03.02.00.00';
              IF peso = '10' Then
                peso := '00.01.02.01.01.02.01.02.01.02.01.02.00.00';
              IF peso = '11' Then
                peso := '00.03.02.11.10.09.08.07.06.05.04.03.02.00';
              IF peso = '12' Then
                peso := '00.00.01.03.04.05.06.07.08.10.00.00.00.00';
              IF peso = '13' Then
                peso := '00.00.03.02.10.09.08.07.06.05.04.03.02.00';
              IF peso = '21' Then
                peso := '05.04.03.02.09.08.07.06.05.04.03.02.00.00';
              IF peso = '22' Then
                peso := '06.05.04.03.02.09.08.07.06.05.04.03.02.00';
              IF peso = '31' Then
                peso := '00.00.00.10.09.08.07.06.05.04.03.02.00.00';
              IF peso = '32' Then
                peso := '00.00.00.11.10.09.08.07.06.05.04.03.02.00';

              { Multiplica }

              Base_3 := copy(('0000000000000000' + trim(Base_2)),
                length(('0000000000000000' + trim(Base_2))) - 13, 14);

              Soma_1 := 0;
              Soma_2 := 0;

              For Contador := 1 To 14 Do
              Begin

                Valor_1 := (StrToInt(copy(Base_3, Contador, 01)) *
                  StrToInt(copy(peso, Contador * 3 - 2, 2)));

                Soma_1 := Soma_1 + Valor_1;

                IF Valor_1 > 9 Then
                  Valor_1 := Valor_1 - 9;

                Soma_2 := Soma_2 + Valor_1;

              End;

              { Ajusta valor da soma }

              IF pos(Rotina, 'A2') > 0 Then
                Soma_1 := Soma_2;
              IF pos(Rotina, 'B0') > 0 Then
                Soma_1 := Soma_1 * 10;
              IF pos(Rotina, 'C1') > 0 Then
                Soma_1 := Soma_1 + (5 + 4 * StrToInt(copy(tabela, 6, 1)));

              { Calcula o Digito }

              IF pos(Rotina, 'D0') > 0 Then
                Digito := Soma_1 Mod Modulo;
              IF pos(Rotina, 'E12') > 0 Then
                Digito := Modulo - (Soma_1 Mod Modulo);

              IF Digito < 10 Then
                Resultado := IntToStr(Digito);
              IF Digito = 10 Then
                Resultado := '0';
              IF Digito = 11 Then
                Resultado := copy(tabela, 6, 1);

              { Verifica o Digito }

              IF (copy(Base_2, StrToInt(copy(tabela, 36 + (digitos * 3), 2)), 1)
                <> Resultado) Then
                Erro_3 := 1;

            End;

          End;

        End;

      End;

    End;

    { Retorna o resultado da Verificação }

    retorno := False;

    IF (trim(Tabela_1) <> '') AND (Erro_1 = 0) Then
      retorno := true;
    IF (trim(Tabela_2) <> '') AND (Erro_2 = 0) Then
      retorno := true;
    IF (trim(Tabela_3) <> '') AND (Erro_3 = 0) Then
      retorno := true;

    IF trim(Inscricao) = 'ISENTO' Then
      retorno := true;

    Result := retorno;

  Except

    Result := False;

  End;

End;

{ Mascara_Inscricao __________________________________ }

Function Tfuncoes.Mascara_Inscricao(Inscricao, Estado: String): String;
Var

  Mascara: String;

  Contador_1: integer;
  Contador_2: integer;

Begin

  IF Estado = 'AC' Then
    Mascara := '**.***.***/***-**';
  IF Estado = 'AL' Then
    Mascara := '*********';
  IF Estado = 'AP' Then
    Mascara := '*********';
  IF Estado = 'AM' Then
    Mascara := '**.***.***-*';
  IF Estado = 'BA' Then
    Mascara := '******-**';
  IF Estado = 'CE' Then
    Mascara := '********-*';
  IF Estado = 'DF' Then
    Mascara := '***********-**';
  IF Estado = 'ES' Then
    Mascara := '*********';
  IF Estado = 'GO' Then
    Mascara := '**.***.***-*';
  IF Estado = 'MA' Then
    Mascara := '*********';
  IF Estado = 'MT' Then
    Mascara := '**********-*';
  IF Estado = 'MS' Then
    Mascara := '*********';
  IF Estado = 'MG' Then
    Mascara := '***.***.***/****';
  IF Estado = 'PA' Then
    Mascara := '**-******-*';
  IF Estado = 'PB' Then
    Mascara := '********-*';
  IF Estado = 'PR' Then
    Mascara := '********-**';
  IF Estado = 'PE' Then
    Mascara := '**.*.***.*******-*';
  IF Estado = 'PI' Then
    Mascara := '*********';
  IF Estado = 'RJ' Then
    Mascara := '**.***.**-*';
  IF Estado = 'RN' Then
    Mascara := '**.***.***-*';
  IF Estado = 'RS' Then
    Mascara := '***/*******';
  IF Estado = 'RO' Then
    Mascara := '***.*****-*';
  IF Estado = 'RR' Then
    Mascara := '********-*';
  IF Estado = 'SC' Then
    Mascara := '***.***.***';
  IF Estado = 'SP' Then
    Mascara := '***.***.***.***';
  IF Estado = 'SE' Then
    Mascara := '*********-*';
  IF Estado = 'TO' Then
    Mascara := '***********';

  Contador_2 := 1;

  Result := '';

  Mascara := Mascara + '****';

  For Contador_1 := 1 To length(Mascara) Do
  Begin

    IF copy(Mascara, Contador_1, 1) = '*' Then
      Result := Result + copy(Inscricao, Contador_2, 1);
    IF copy(Mascara, Contador_1, 1) <> '*' Then
      Result := Result + copy(Mascara, Contador_1, 1);

    IF copy(Mascara, Contador_1, 1) = '*' Then
      Contador_2 := Contador_2 + 1;

  End;

  Result := trim(Result);

End;

function Tfuncoes.excluiAqruivo(arq: String): boolean;
var
  acc: integer;
begin
  Result := False;
  acc := 0;
  while true do
  begin
    acc := acc + 1;
    if acc > 20 then
      break;

    if not FileExists(arq) then
    begin
      Result := true;
      exit;
    end;

    if DeleteFile(arq) then
    begin
      Result := true;
      exit;
    end;
    sleep(300);
  end;

  MessageDlg('O arquivo ' + arq + ' Está em Uso e Não Pode Ser Excluido!',
    mtWarning, [mbok], 1);
end;

procedure Tfuncoes.recalculaEntradas();
begin
  query1.Close;
  query1.SQL.text :=
    'UPDATE ITEM_ENTRADA I SET I.P_COMPRA = I.TOTAL / I.QUANT WHERE I.NOTA= (SELECT NOTA FROM ENTRADA E WHERE E.NOTA = I.NOTA AND I.FORNEC = E.FORNEC)';
  query1.ExecSQL;
  query1.Transaction.Commit;
  ShowMessage('Entradas Recalculadas com Sucesso!');
end;

function Tfuncoes.checaEntradasSped(ini, fim: String): boolean;
var
  tot_adic: currency;
  totreg: integer;
begin
  Result := False;
  dm.ibquery4.Close;
  dm.ibquery4.SQL.text :=
    ('select i.nota,i.fornec,sum(i.total) as total, e.total_nota from item_entrada i left join '
    + 'entrada e on (e.nota = i.nota and i.fornec = e.fornec) where e.chegada >= :dataini AND e.chegada <= :datafim '
    + 'and (((select tipo from speddadosadic s where s.nota = i.nota and s.fornec = i.fornec) = 55) '
    + 'or ((select nota from speddadosadic s where s.nota = i.nota and s.fornec = i.fornec) is null)) and e.xml = ''S'''
    + 'group by i.nota, i.fornec, e.total_nota');
  { FORMATACAO DA DATA PARA ddmmyy }
  dm.ibquery4.ParamByName('dataini').AsDateTime := StrToDate(ini);
  dm.ibquery4.ParamByName('datafim').AsDateTime := StrToDate(fim);
  dm.ibquery4.Open;
  dm.ibquery4.FetchAll;
  totreg := dm.ibquery4.RecordCount;

  form33 := tform33.Create(self);
  form33.caption := 'ERROS DE NOTAS DE ENTRADA ***** F2 Resolver *****';
  form33.ClientDataSet1.FieldDefs.Clear;
  form33.ClientDataSet1.FieldDefs.Add('NOTA', ftInteger);
  form33.ClientDataSet1.FieldDefs.Add('FORNEC', ftInteger);
  form33.ClientDataSet1.FieldDefs.Add('ERRO', ftString, 100);
  form33.ClientDataSet1.FieldDefs.Add('OK', ftInteger);
  form33.ClientDataSet1.CreateDataSet;
  form33.ClientDataSet1.FieldByName('ok').Visible := False;
  form33.DataSource1.dataset := form33.ClientDataSet1;
  form33.DBGrid1.DataSource := form33.DataSource1;
  form33.campobusca := 'nfce1';

  while not dm.ibquery4.Eof do
  begin
    tot_adic := 0;
    informacao(dm.ibquery4.RecNo, totreg, 'Verificando Entradas...', False,
      False, 5);
    dm.IBselect.Close;
    dm.IBselect.SQL.text :=
      'select (s.TOTSEG + s.TOTFRETE + s.TOTICMSST + s.TOTDESPACES - ( s.TOTDESCNT + s.TOTDESC + s.TOTICMS_DESON)) '
      + 'as total from SPEDDADOSADIC s  where nota = :nota and fornec = :fornec';
    dm.IBselect.ParamByName('nota').AsInteger := dm.ibquery4.FieldByName('nota')
      .AsInteger;
    dm.IBselect.ParamByName('fornec').AsInteger :=
      dm.ibquery4.FieldByName('fornec').AsInteger;
    dm.IBselect.Open;

    if dm.IBselect.IsEmpty then
    begin
      form33.ClientDataSet1.Append;
      form33.ClientDataSet1.FieldByName('nota').AsInteger :=
        dm.ibquery4.FieldByName('nota').AsInteger;
      form33.ClientDataSet1.FieldByName('fornec').AsInteger :=
        dm.ibquery4.FieldByName('fornec').AsInteger;
      form33.ClientDataSet1.FieldByName('erro').AsString :=
        '4: Dados Adicionais Não Encontrado';
      form33.ClientDataSet1.Post;
    end
    else
    begin
      tot_adic := dm.IBselect.FieldByName('total').AsCurrency;
      if abs(dm.ibquery4.FieldByName('total_nota').AsCurrency -
        (dm.ibquery4.FieldByName('total').AsCurrency + tot_adic)) > 5 then
      begin
        form33.ClientDataSet1.Append;
        form33.ClientDataSet1.FieldByName('nota').AsInteger :=
          dm.ibquery4.FieldByName('nota').AsInteger;
        form33.ClientDataSet1.FieldByName('fornec').AsInteger :=
          dm.ibquery4.FieldByName('fornec').AsInteger;
        form33.ClientDataSet1.FieldByName('erro').AsString :=
          '5: Total da Nota não confere com o Total do XML, difereça: ' +
          formataCurrency(abs(dm.ibquery4.FieldByName('total_nota').AsCurrency -
          (dm.ibquery4.FieldByName('total').AsCurrency + tot_adic)));
        form33.ClientDataSet1.Post;
      end;
    end;

    dm.ibquery4.Next;
  end;

  if form33.ClientDataSet1.IsEmpty = False then
  begin
    form33.ShowModal;
  end
  else
    Result := true;

  form33.Free;
end;

function Tfuncoes.buscaCorBDGRID_Produto(opcao: integer = 0): String;
begin
  if opcao = 0 then
  begin // cores das linhas
    //Result := buscaConfigTerminal(10, '$00F5F5F5');
    Result := funcoes.LerConfig(form22.Pgerais.Values['conf_ter'], 10);
    if Trim(Result) = '' then Result := '$00F5F5F5';

    if Result = 'clBlack' then
      Result := '$00F5F5F5';
  end;

  if opcao = 1 then
  begin // cor quando estiver selecionado
    //Result := buscaConfigTerminal(11, 'clBlack');
    Result := funcoes.LerConfig(form22.Pgerais.Values['conf_ter'], 11);
    if Trim(Result) = '' then Result := 'clBlack';
  end;

  if opcao = 2 then
  begin // cor da fonte
    //Result := buscaConfigTerminal(12, 'clwhite');
    Result := funcoes.LerConfig(form22.Pgerais.Values['conf_ter'], 12);
    if Trim(Result) = '' then Result := 'clwhite';
    if ((Result = '') or (Result = 'clblack')) then
      Result := 'clwhite';
  end;

end;

function Tfuncoes.listaUnidades: String;
var
  // i: integer;
  // Drive: TDriveType;
  lista: String;
  DriveNum: integer;
  LetraDrive: Char;
  DriveBits: set of 0 .. 25;
  TipoDrive: TDriveType;
begin
  lista := '';
  integer(DriveBits) := GetLogicalDrives;
  for DriveNum := 0 to 25 do
  begin
    if not(DriveNum in DriveBits) then
      Continue;
    LetraDrive := UpCase(Char(DriveNum + ord('a')));
    TipoDrive := TDriveType(GetDriveType(PChar(LetraDrive + ':')));

    case TipoDrive of
      dtFloppy:
        lista := lista + LetraDrive + '/';
        // Lista.Add (LetraDrive + ': - Pendrive');
      // dtFixed  : Lista := Lista + LetraDrive + '-';//Lista.Add (LetraDrive + ': - Disco rígido');
      // dtCDROM  : Lista.Add ('Drive ' + LetraDrive + ': - CD-ROM ');
      // dtRAM    : Lista.Add ('Drive ' + LetraDrive + ': - RAM Disk ');
      // dtNetwork: Lista.Add ('Drive ' + LetraDrive + ': - Drive de rede');
    end;
  end;
  Result := lista;

  // ShowMessage(lista.GetText);
end;

function Tfuncoes.listaUnidadesComDescricoes: TStrings;
var
  // i: integer;
  // Drive: TDriveType;
  lista: tstringList;
  DriveNum: integer;
  LetraDrive: Char;
  DriveBits: set of 0 .. 25;
  TipoDrive: TDriveType;
begin
  lista := tstringList.Create;
  integer(DriveBits) := GetLogicalDrives;
  for DriveNum := 0 to 25 do
  begin
    if not(DriveNum in DriveBits) then
      Continue;
    LetraDrive := UpCase(Char(DriveNum + ord('a')));
    TipoDrive := TDriveType(GetDriveType(PChar(LetraDrive + ':')));

    case TipoDrive of
      dtFloppy:
        lista.Add(LetraDrive + ': - Pendrive');
      // dtFixed  : Lista := Lista + LetraDrive + '-';//Lista.Add (LetraDrive + ': - Disco rígido');
      // dtCDROM  : Lista.Add ('Drive ' + LetraDrive + ': - CD-ROM ');
      // dtRAM    : Lista.Add ('Drive ' + LetraDrive + ': - RAM Disk ');
      // dtNetwork: Lista.Add ('Drive ' + LetraDrive + ': - Drive de rede');
    end;
  end;
  Result := lista;

  // ShowMessage(lista.GetText);
end;

function Tfuncoes.ajustaHoraPelaInternet(var dataMov: TDateTime): boolean;
var
  data: TDateTime;
  SystemTime: TSystemTime;
  cont: integer;
begin
  Result := False;
  cont := 0;
  funcoes.Mensagem(Application.Title, 'Aguarde, Buscando Data...', 15,
    'Courier New', False, 0, clRed);
  Application.ProcessMessages;
  try
    while true do
    begin
      Application.ProcessMessages;
      if cont > 2 then
      begin
        // ShowMessage('Tentativas de Atualização de Hora Esgotados e Não Possivel atualizar a Hora!');
        exit;
      end;

      cont := cont + 1;

      try
        data := IdSNTP1.DateTime;
      except
        on e: exception do
        begin
          // ShowMessage('Erro Na Atualização da Hora data := IdSNTP1.DateTime: ' + e.Message);
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
          // ShowMessage('Erro Na Atualização da Hora:  data > StrToDate(01/01/2016):' + e.Message);
        end;
      end;
    end;

    try
      if data < StrToDate('01/01/2016') then
      begin
        // ShowMessage('Tentativas de Atualização de Hora Esgotados e Não Possivel atualizar a Hora! Linha 1083');
        exit;
      end;
    except
      on e: exception do
      begin
        // ShowMessage('Erro Na Atualização da Hora:  data > StrToDate(01/01/2016):' + e.Message);
      end;
    end;
  finally
    pergunta1.option := 2;
    funcoes.Mensagem(Application.Title, '', 15, '',False, 0, clBlack, true);
  end;

  Result := true;
  dataMov := data;

  SystemTime.wYear := YearOf(data);
  SystemTime.wMonth := MonthOf(data);
  SystemTime.wDay := DayOf(data);
  SystemTime.wHour := HourOf(data);
  SystemTime.wMinute := MinuteOf(data);
  SystemTime.wSecond := SecondOf(data);
  SetLocalTime(SystemTime);
end;

procedure Tfuncoes.validaDataHora(var dataMo: TDateTime; USUARIO: STRING);
var
  ultDataMov, dataAtual, dataBd: TDateTime;
  temp, somenteHora, BomDia: String;
  hora: TTime;
begin
  { dataMo := now;

    dm.IBselect.Close;
    dm.IBselect.SQL.Text := ('select current_date as data from rdb$database');
    dm.IBselect.Open;
    dataBd := dm.IBselect.fieldbyname('data').AsDateTime;


    dm.IBselect.Close;
    dm.IBselect.SQL.Text := ('select data from venda where nota = :nota');
    dm.IBselect.ParamByName('nota').AsString := Incrementa_Generator('venda', 0);
    dm.IBselect.Open;

    ultDataMov := dm.IBselect.FieldByName('data').AsDateTime;

    if abs(ultDataMov - datamo) > abs(ultDataMov - dataBd) then dataMo := dataBd;
    dm.IBselect.Close;

    somenteHora := FormatDateTime('h', now);
    if StrToFloat(somenteHora) > 6 then BomDia  := 'Bom Dia ';
    if StrToFloat(somenteHora) > 12 then BomDia := 'Boa Tarde ';
    if StrToFloat(somenteHora) > 18 then BomDia := 'Boa Noite ';
    ShowMessage(BomDia + usuario + ' - ' + FormatDateTime('dddddd', datAmo));
    exit; }

  { if FileExists(caminhoEXE_com_barra_no_final + 'ControlW.ini') then begin
    dataMo := now;
    exit;
    end; }

  // pega a data atual de movimento
  dm.IBselect.Close;
  dm.IBselect.SQL.Clear;
  dm.IBselect.SQL.Add('select data_mov from registro');
  try
    dm.IBselect.Open;
    if dm.IBselect.IsEmpty then
      ultDataMov := now
    else
      ultDataMov := dm.IBselect.FieldByName('data_mov').AsDateTime;
  except
    ultDataMov := now;
  end;

  if DateOf(dm.IBselect.FieldByName('data_mov').AsDateTime) <> DateOf(now) then
  begin
    if ajustaHoraPelaInternet(form22.dataMov) then
    begin
      if dm.IBQuery1.Transaction.InTransaction then
        dm.IBQuery1.Transaction.Commit;
      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.text := ('update registro set data_mov = :datamov');
      dm.IBQuery1.ParamByName('datamov').AsDateTime := form22.dataMov;
      try
        dm.IBQuery1.ExecSQL;
        dm.IBQuery1.Transaction.Commit;
      except
      end;

      BomDia := funcoes.verificaPermissaoPagamento(false, false);
     
      exit;
    end;
  end;

  dm.IBselect.Close;

  // salva a ultDataMov em dataAtual
  dataAtual := ultDataMov;

  // pega a data atual do BD
  dm.IBselect.Close;
  dm.IBselect.SQL.text := ('select current_date as data from rdb$database');
  dm.IBselect.Open;
  dataBd := dm.IBselect.FieldByName('data').AsDateTime;

  // se a data atual do bd for maior que a data atual de movimento
  // e essa data for até 30 dias maior, adianta automático pra a data do bd
  if ((dataBd > ultDataMov) and ((dataBd - ultDataMov) <= 5)) then
    ultDataMov := dataBd;

  // se a data de relógio é maior que a ultima data de movimento
  // e essa data for até 30 dias maior, adianta automático pra a data de relógio
  if ((now > ultDataMov) and ((now - ultDataMov) <= 5)) then
    ultDataMov := now;

  // somente o usuário admin vai poder alterar a data de movimento
  if (form22.USUARIO = 'ADMIN') then
  begin
    temp := funcoes.dialogo('data', 0, '', 0, true, '', Application.Title,
      'Confirme a Data de Movimento:', FormatDateTime('dd/mm/yy', ultDataMov));
    if temp <> '*' then
      ultDataMov := StrToDateDef(temp, ultDataMov);
  end;

  // atualiza a data do sistema
  dataMo := ultDataMov;

  // atualiza a data de movimento atual
  if (ultDataMov <> dataAtual) then
  begin
    if dm.IBQuery1.Transaction.InTransaction then
      dm.IBQuery1.Transaction.Commit;
    dm.IBQuery1.Close;
    dm.IBQuery1.SQL.text := ('update registro set data_mov = :datamov');
    dm.IBQuery1.ParamByName('datamov').AsDateTime := ultDataMov;
    try
      dm.IBQuery1.ExecSQL;
      dm.IBQuery1.Transaction.Commit;
    except
    end;
  end;

  somenteHora := FormatDateTime('h', now);
  if StrToFloat(somenteHora) > 6 then
    BomDia := 'Bom Dia ';
  if StrToFloat(somenteHora) > 12 then
    BomDia := 'Boa Tarde ';
  if StrToFloat(somenteHora) > 18 then
    BomDia := 'Boa Noite ';
  ShowMessage(BomDia + USUARIO + ' - ' + FormatDateTime('dddddd', dataMo));
end;

function Tfuncoes.verificaNFCe(dataIni: String = ''; DataFim: String = '';
  sped: boolean = False): boolean;
var
  arq: tstringList;
  semProtocolo, pulos, erro, acc, puloInutilizado : String;
  cont, serie, fi, i: integer;
begin
  if dataIni = '' then
  begin
    dataIni := dialogo('data', 0, '', 2, true, '', Application.Title,
      'Confirme a Data Inicial:', FormatDateTime('dd/mm/yy',
      StartOfTheMonth(IncMonth(form22.dataMov, -1))));
    if dataIni = '*' then
      exit;
  end;

  if DataFim = '' then
  begin
    DataFim := FormatDateTime('dd/mm/yy',
      endOfTheMonth(StrToDateTime(dataIni)));
    DataFim := dialogo('data', 0, '', 2, true, '', Application.Title,
      'Confirme a Data Final:', DataFim);
    if DataFim = '*' then
      exit;
  end;

  dm.IBselect.Close;
  dm.IBselect.SQL.text := 'select * from nfce where chave = '''' ';
  dm.IBselect.Open;
  dm.IBselect.FetchAll;

  if not dm.IBselect.IsEmpty then
  begin
    i := dm.IBselect.RecordCount;
    if MessageDlg
      ('Foram Encontrados Registros de NFCe Inválidos! Deseja Excluir ?',
      mtConfirmation, [mbYes, mbNo], 1) = idyes then
    begin
      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.text := 'delete from nfce where trim(chave) = '''' ';
      dm.IBQuery1.ExecSQL;
      dm.IBQuery1.Transaction.Commit;

      ShowMessage('Registros Excluídos: ' + IntToStr(i));
    end;
  end;

  arrumaDataRegistroNFCe(False);

  dm.IBselect.Close;
  dm.IBselect.SQL.text :=
    'select nota,chave, cast(substring(chave from 26 for 9) as integer) as nnf, cast(substring(chave from 23 for 3) as integer)'
    + ' as serie from nfce where chave <> '''' and data >= :ini and data <= :fim '
    + 'order by cast(substring(chave from 23 for 3) as integer),cast(substring(chave from 26 for 9) as integer)';
  dm.IBselect.ParamByName('ini').AsDate := StrToDate(dataIni);
  dm.IBselect.ParamByName('fim').AsDate := StrToDate(DataFim);
  dm.IBselect.Open;
  dm.IBselect.FetchAll;

  semProtocolo := '';
  acc := '';
  cont := 0;
  serie := 99999;
  form19.RichEdit1.Lines.Clear;
  i := 0;
  puloInutilizado := '';

  fi := dm.IBselect.RecordCount;
  funcoes.informacao(i, fi, 'Aguarde, Gerando Relatório...', true, False, 5);

  form33 := tform33.Create(self);
  form33.ClientDataSet1.FieldDefs.Clear;
  form33.ClientDataSet1.FieldDefs.Add('CHAVE', ftString, 45);
  form33.ClientDataSet1.FieldDefs.Add('SERIE', ftInteger);
  form33.ClientDataSet1.FieldDefs.Add('ERRO', ftString, 40);
  form33.ClientDataSet1.FieldDefs.Add('OK', ftInteger);
  form33.ClientDataSet1.CreateDataSet;
  form33.ClientDataSet1.LogChanges := False;
  form33.ClientDataSet1.FieldByName('ok').Visible := False;
  arq := tstringList.Create;

  while not dm.IBselect.Eof do
  begin
    i := i + 1;

    funcoes.informacao(i, fi, 'Aguarde, Gerando Relatório...', False, False, 5);

    if serie <> dm.IBselect.FieldByName('serie').AsInteger then
    begin
      if serie <> 99999 then
      begin
        try
          addRelatorioForm19(CompletaOuRepete('', '', '-', 80) + CRLF);
          addRelatorioForm19(CompletaOuRepete('Relatorio de Pendencia de NFCe '
            + dataIni + ' a ' + DataFim + ' Serie: ' + IntToStr(serie), '', ' ',
            80) + CRLF);
          addRelatorioForm19(CompletaOuRepete('', '', '-', 80) + CRLF);

          acc := acc + pulos + semProtocolo;
          addRelatorioForm19('Saltos NNF: ' + pulos + CRLF);
          addRelatorioForm19('Sem Protocolo :' + CRLF);

          addRelatorioForm19(semProtocolo + CRLF);
        except
          on e: exception do
          begin
            ShowMessage(e.Message + #13 + semProtocolo);
          end;
        end;

        pulos := '';
        semProtocolo := '';
      end;

      serie := dm.IBselect.FieldByName('serie').AsInteger;
      cont := dm.IBselect.FieldByName('nnf').AsInteger;
    end;

    while true do
    begin
      if dm.IBselect.Eof then
        break;
      if cont <> dm.IBselect.FieldByName('nnf').AsInteger then
      begin
        erro := '';

        dm.IBQuery2.Close;
        dm.IBQuery2.SQL.text :=
          'select chave, data from nfce where substring(chave from 23 for 3) = :serie and substring(chave from 26 for 9) = :nnf';
        dm.IBQuery2.ParamByName('serie').AsString := STRZERO(serie, 3);
        dm.IBQuery2.ParamByName('nnf').AsString := STRZERO(cont, 9);
        dm.IBQuery2.Open;

        if dm.IBQuery2.IsEmpty then
        begin
          erro := '1: Não Existe Essa Numeração No BD!';

          dm.IBQuery2.Close;
          dm.IBQuery2.SQL.text :=
          'select * from INUTILIZACAO where inicio <= '+IntToStr(cont)+' and'+
          ' fim >= '+IntToStr(cont)+' and serie = '+IntToStr(serie);
          //dm.IBQuery2.ParamByName('ini').AsInteger  := cont;
          //dm.IBQuery2.ParamByName('fim').AsInteger  := cont;
          //dm.IBQuery2.ParamByName('serie').AsInteger := serie;
          dm.IBQuery2.Open;
          dm.IBQuery2.FetchAll;

          if dm.IBQuery2.IsEmpty = false then begin
            erro            := '9:Essa Numeração já se Encontra Inutilizada No BD!';
            puloInutilizado := puloInutilizado + IntToStr(cont)+ '-Inutilizado ' + FormatDateTime('dd/mm/yyyy',dm.IBQuery2.FieldByName('data').AsDateTime) + #13;
          end
          else begin
            acc := acc + IntToStr(cont) + ' - ';
            pulos := pulos + IntToStr(cont) + ' - ';
          end
        end
        else
        begin
          erro := '2: NFCe Encontrada no dia ' + FormatDateTime('dd/mm/yy',
            dm.IBQuery2.FieldByName('data').AsDateTime);
        end;

        dm.IBQuery2.Close;

        if erro <> '' then
        begin

          form33.ClientDataSet1.Append;
          form33.ClientDataSet1.FieldByName('chave').AsString := IntToStr(cont);
          form33.ClientDataSet1.FieldByName('erro').AsString := erro;
          form33.ClientDataSet1.FieldByName('SERIE').AsInteger := serie;
          form33.ClientDataSet1.FieldByName('ok').AsInteger := 0;
          form33.ClientDataSet1.Post;
        end;
      end
      else
        break;

      if cont < dm.IBselect.FieldByName('nnf').AsInteger then
        cont := cont + 1
      else
        dm.IBselect.Next;
    end;

    if FileExists(buscaPastaNFCe(dm.IBselect.FieldByName('chave').AsString) +
      dm.IBselect.FieldByName('chave').AsString + '-nfe.xml') then
    begin
      try
        arq.LoadFromFile(buscaPastaNFCe(dm.IBselect.FieldByName('chave')
          .AsString) + dm.IBselect.FieldByName('chave').AsString + '-nfe.xml');

        if Le_Nodo('cStat', arq.text) = '' then
        begin
          semProtocolo := semProtocolo + ' Sem Protocolo1: ' +
            dm.IBselect.FieldByName('chave').AsString + CRLF;

          erro := '3: Sem Protocolo na NFCe';

          form33.ClientDataSet1.Insert;
          form33.ClientDataSet1.FieldByName('chave').AsString :=
            dm.IBselect.FieldByName('chave').AsString;
          form33.ClientDataSet1.FieldByName('erro').AsString := erro;
          form33.ClientDataSet1.FieldByName('SERIE').AsInteger := serie;
          form33.ClientDataSet1.FieldByName('ok').AsInteger := 0;
          form33.ClientDataSet1.Post;
          acc := acc + erro;
        end;

        arq.Clear;
      except
        on e: exception do
        begin
          ShowMessage(e.Message + #13 + dm.IBselect.FieldByName('chave')
            .AsString);
        end;
      end;
    end
    else
    begin
      semProtocolo := semProtocolo + ' XML Nao Encontrado: ' +
        dm.IBselect.FieldByName('chave').AsString + CRLF;
      acc := acc + ' XML Nao Encontrado: ' + dm.IBselect.FieldByName('chave')
        .AsString + CRLF;
    end;

    cont := cont + 1;
    dm.IBselect.Next;
  end;

  addRelatorioForm19(CompletaOuRepete('', '', '-', 80) + CRLF);
  addRelatorioForm19(CompletaOuRepete('Relatorio de Pendencia de NFCe ' +
    dataIni + ' a ' + DataFim + ' Serie: ' + IntToStr(serie), '', ' ',
    80) + CRLF);
  addRelatorioForm19(CompletaOuRepete('', '', '-', 80) + CRLF);

  addRelatorioForm19('Saltos NNF: ' + pulos + CRLF + puloInutilizado+ CRLF+ CRLF);
  addRelatorioForm19('Sem Protocolo :' + CRLF);

  addRelatorioForm19(semProtocolo + CRLF);

  funcoes.informacao(i, fi, 'Aguarde, Gerando Relatório...', False, true, 5);
  pulos := '';
  semProtocolo := '';

  Result := true;

  if not form33.ClientDataSet1.IsEmpty then
  begin
    form33.DataSource1.dataset := form33.ClientDataSet1;
    form33.DBGrid1.DataSource := form33.DataSource1;
    form33.campobusca := 'nfce';
    form33.ShowModal;
  end;

  form33.ClientDataSet1.Free;
  form33.Free;

  Result := true;

  if sped then
  begin
    if acc <> '' then
    begin
      form19.ShowModal;
      if MessageDlg
        ('Foram Encontrados Erros Nas NFCes, Deseja Continuar Assim Mesmo ?',
        mtConfirmation, [mbYes, mbNo], 1) = idno then
      begin
        Result := False;
        exit;
      end
      else
        exit;
    end;
  end
  else
  begin
    form19.ShowModal;
  end;

  if acc <> '' then
  begin
    Result := False;
  end;
end;

function Tfuncoes.verificaNFe(dataIni: String = ''; DataFim: String = '';
  sped: boolean = False): boolean;
var
  arq: tstringList;
  semProtocolo, pulos, erro, acc: String;
  cont, serie, fi, i: integer;
begin

  if dataIni = '' then
  begin
    dataIni := dialogo('data', 0, '', 2, true, '', Application.Title,
      'Confirme a Data Inicial:', FormatDateTime('dd/mm/yy',
      StartOfTheMonth(IncMonth(form22.dataMov, -1))));
    if dataIni = '*' then
      exit;
  end;

  if DataFim = '' then
  begin
    DataFim := FormatDateTime('dd/mm/yy',
      endOfTheMonth(StrToDateTime(dataIni)));

    DataFim := dialogo('data', 0, '', 2, true, '', Application.Title,
      'Confirme a Data Final:', DataFim);
    if DataFim = '*' then
      exit;
  end;

  dm.IBselect.Close;
  dm.IBselect.SQL.text := 'select * from nfe where chave = '''' ';
  dm.IBselect.Open;
  dm.IBselect.FetchAll;

  if not dm.IBselect.IsEmpty then
  begin
    i := dm.IBselect.RecordCount;
    if MessageDlg
      ('Foram Encontrados Registros de NFe Inválidos! Deseja Excluir ?',
      mtConfirmation, [mbYes, mbNo], 1) = idyes then
    begin
      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.text := 'delete from nfe where trim(chave) = '''' ';
      dm.IBQuery1.ExecSQL;
      dm.IBQuery1.Transaction.Commit;

      ShowMessage('Registros Excluídos: ' + IntToStr(i));
    end;

  end;

  dm.IBselect.Close;
  dm.IBselect.SQL.text :=
    'select nota,chave, cast(substring(chave from 26 for 9) as integer) as nnf, cast(substring(chave from 23 for 3) as integer)'
    + ' as serie,xml from nfe where chave <> '''' and data >= :ini and data <= :fim '
    + 'order by cast(substring(chave from 23 for 3) as integer),cast(substring(chave from 26 for 9) as integer)';
  dm.IBselect.ParamByName('ini').AsDate := StrToDate(dataIni);
  dm.IBselect.ParamByName('fim').AsDate := StrToDate(DataFim);
  dm.IBselect.Open;
  dm.IBselect.FetchAll;

  arq := tstringList.Create;
  semProtocolo := '';
  acc := '';
  cont := 0;
  serie := 99999;
  form19.RichEdit1.Lines.Clear;
  i := 0;

  fi := dm.IBselect.RecordCount;
  funcoes.informacao(i, fi, 'Aguarde, Gerando Relatório...', true, False, 5);

  form33 := tform33.Create(self);
  form33.ClientDataSet1.FieldDefs.Clear;
  form33.ClientDataSet1.FieldDefs.Add('CHAVE', ftString, 45);
  form33.ClientDataSet1.FieldDefs.Add('SERIE', ftInteger);
  form33.ClientDataSet1.FieldDefs.Add('ERRO', ftString, 40);
  form33.ClientDataSet1.FieldDefs.Add('OK', ftInteger);
  form33.ClientDataSet1.CreateDataSet;
  form33.ClientDataSet1.LogChanges := False;
  form33.ClientDataSet1.FieldByName('ok').Visible := False;

  while not dm.IBselect.Eof do
  begin
    i := i + 1;

    funcoes.informacao(i, fi, 'Aguarde, Gerando Relatório...', False, False, 5);

    if serie <> dm.IBselect.FieldByName('serie').AsInteger then
    begin
      if serie <> 99999 then
      begin
        addRelatorioForm19(CompletaOuRepete('', '', '-', 80) + CRLF);
        addRelatorioForm19(CompletaOuRepete('Relatorio de Pendencia de NFCe ' +
          dataIni + ' a ' + DataFim + ' Serie: ' + IntToStr(serie), '', ' ',
          80) + CRLF);
        addRelatorioForm19(CompletaOuRepete('', '', '-', 80) + CRLF);

        acc := acc + pulos + semProtocolo;
        addRelatorioForm19('Saltos NNF: ' + pulos + CRLF);
        addRelatorioForm19('Sem Protocolo :' + CRLF);

        addRelatorioForm19(semProtocolo + CRLF);

        pulos := '';
        semProtocolo := '';
      end;

      serie := dm.IBselect.FieldByName('serie').AsInteger;
      cont := dm.IBselect.FieldByName('nnf').AsInteger;
    end;

    { if dm.IBselect.FieldByName('nnf').AsInteger = 6 then
      begin
      //ShowMessage(IntToStr(cont) + ' / ' + dm.IBselect.FieldByName('nnf').AsString);
      end; }

    while true do
    begin
      // ShowMessage(IntToStr(cont) + ' / ' + dm.IBselect.FieldByName('nnf').AsString);
      if dm.IBselect.Eof then
        break;
      if cont <> dm.IBselect.FieldByName('nnf').AsInteger then
      begin

        // pulos := pulos + IntToStr(dm.IBselect.FieldByName('nnf').AsInteger - 1) + ' - ';
        pulos := pulos + IntToStr(cont) + ' - ';
        acc := acc + IntToStr(cont) + ' - ';

        { dm.IBQuery2.Close;
          dm.IBQuery2.SQL.Text := 'select chave, data from nfce where substring(chave from 23 for 3) = :serie and substring(chave from 26 for 9) = :nnf';
          dm.IBQuery2.ParamByName('serie').AsString := strzero(serie, 3);
          dm.IBQuery2.ParamByName('nnf').AsString   := strzero(cont, 9);
          dm.IBQuery2.Open;

          if dm.IBQuery2.IsEmpty then begin
          erro := '1: Não Existe Essa Numeração No BD!';
          end
          else begin
          erro := '2: NFCe Encontrada no dia ' + FormatDateTime('dd/mm/yy', dm.IBQuery2.fieldbyname('data').AsDateTime);
          end;

          dm.IBQuery2.Close;

          if LeftStr(erro, 1) = '1' then begin

          form33.ClientDataSet1.Append;
          form33.ClientDataSet1.FieldByName('chave').AsString  := IntToStr(cont);
          form33.ClientDataSet1.FieldByName('erro').AsString   := erro;
          form33.ClientDataSet1.FieldByName('SERIE').AsInteger := serie;
          form33.ClientDataSet1.FieldByName('ok').AsInteger    := 0;
          form33.ClientDataSet1.Post;
          end; }
      end
      else
        break;

      // ShowMessage('cont=' + IntToStr(cont) + #13 +'NNF=' + dm.IBselect.FieldByName('nnf').AsString);

      if cont < dm.IBselect.FieldByName('nnf').AsInteger then
        cont := cont + 1
      else
        dm.IBselect.Next;
    end;

    if FileExists(caminhoEXE_com_barra_no_final + 'NFE\EMIT\' +
      dm.IBselect.FieldByName('chave').AsString + '-nfe.xml') = False then
    begin
      arq.text := dm.IBselect.FieldByName('xml').AsString;
      if arq.text <> '' then
        arq.SaveToFile(caminhoEXE_com_barra_no_final + 'NFE\EMIT\' +
          dm.IBselect.FieldByName('chave').AsString + '-nfe.xml');
    end;

    if FileExists(caminhoEXE_com_barra_no_final + 'NFE\EMIT\' +
      dm.IBselect.FieldByName('chave').AsString + '-nfe.xml') then
    begin
      arq.LoadFromFile(caminhoEXE_com_barra_no_final + 'NFE\EMIT\' +
        dm.IBselect.FieldByName('chave').AsString + '-nfe.xml');

      if Le_Nodo('cStat', arq.text) = '' then
      begin
        semProtocolo := semProtocolo + ' Sem Protocolo: ' +
          dm.IBselect.FieldByName('chave').AsString + CRLF;

        erro := '20: Sem Protocolo na NFe';

        form33.ClientDataSet1.Append;
        form33.ClientDataSet1.FieldByName('chave').AsString :=
          dm.IBselect.FieldByName('chave').AsString;
        form33.ClientDataSet1.FieldByName('erro').AsString := erro;
        form33.ClientDataSet1.FieldByName('SERIE').AsInteger := serie;
        form33.ClientDataSet1.FieldByName('ok').AsInteger := 0;
        form33.ClientDataSet1.Post;
        acc := acc + erro;
      end;
    end
    else
    begin
      semProtocolo := semProtocolo + ' XML Nao Encontrado: ' +
        dm.IBselect.FieldByName('chave').AsString + CRLF;
      acc := acc + semProtocolo;

    end;

    cont := cont + 1;
    // cont  := dm.IBselect.FieldByName('nnf').AsInteger + 1;
    dm.IBselect.Next;
  end;

  addRelatorioForm19(CompletaOuRepete('', '', '-', 80) + CRLF);
  addRelatorioForm19(CompletaOuRepete('Relatorio de Pendencia de NFe ' + dataIni
    + ' a ' + DataFim + ' Serie: ' + IntToStr(serie), '', ' ', 80) + CRLF);
  addRelatorioForm19(CompletaOuRepete('', '', '-', 80) + CRLF);

  addRelatorioForm19('Saltos NNF: ' + pulos + CRLF);
  addRelatorioForm19('Sem Protocolo :' + CRLF);

  addRelatorioForm19(semProtocolo + CRLF);

  funcoes.informacao(i, fi, 'Aguarde, Gerando Relatório...', False, true, 5);
  pulos := '';
  semProtocolo := '';

  Result := true;

  if not form33.ClientDataSet1.IsEmpty then
  begin
    form33.DataSource1.dataset := form33.ClientDataSet1;
    form33.DBGrid1.DataSource := form33.DataSource1;
    form33.campobusca := 'nfe';
    form33.Caption    := 'Pendências de NFe F2-Resolver';
    form33.ShowModal;
  end;

  form33.ClientDataSet1.Free;
  form33.Free;

  Result := true;

  if sped then
  begin
    if acc <> '' then
    begin
      form19.ShowModal;
      if MessageDlg
        ('Foram Encontrados Erros Nas NFes, Deseja Continuar Assim Mesmo ?',
        mtConfirmation, [mbYes, mbNo], 1) = idno then
      begin
        Result := False;
        exit;
      end
      else
        exit;
    end;
  end
  else
  begin
    form19.ShowModal;
  end;

  if acc <> '' then
  begin
    Result := False;
  end;
end;

function Tfuncoes.excluiTransferencia(cod, doc: integer): boolean;
begin
  Result := False;
  dm.IBselect.Close;
  dm.IBselect.SQL.text :=
    'select cod,destino, quant from transferencia where cod = :cod and documento = :doc ';
  dm.IBselect.ParamByName('cod').AsInteger := cod;
  dm.IBselect.ParamByName('doc').AsInteger := doc;
  dm.IBselect.Open;

  dm.IBQuery2.Close;
  dm.IBQuery2.SQL.Clear;
  if dm.IBselect.FieldByName('destino').AsInteger = 1 then
    dm.IBQuery2.SQL.Add
      ('update produto set quant = quant - :q, deposito = deposito + :q where cod='
      + dm.IBselect.FieldByName('cod').AsString)
  else
    dm.IBQuery2.SQL.Add
      ('update produto set quant = quant + :q, deposito = deposito - :q where cod='
      + dm.IBselect.FieldByName('cod').AsString);

  dm.IBQuery2.ParamByName('q').AsCurrency := dm.IBselect.FieldByName('quant')
    .AsCurrency;
  dm.IBQuery2.ExecSQL;

  dm.IBQuery2.Close;
  dm.IBQuery2.SQL.Clear;
  dm.IBQuery2.SQL.Add
    ('delete from transferencia where documento= :doc and cod = :cod');
  dm.IBQuery2.ParamByName('doc').AsInteger := doc;
  dm.IBQuery2.ParamByName('cod').AsInteger := cod;
  dm.IBQuery2.ExecSQL;

  try
    dm.IBQuery2.Transaction.Commit;
    Result := true;
  except
    dm.IBQuery2.Transaction.Rollback;
    ShowMessage('Ocorreu um Erro Inesperado. Tente Novamente!');
  end;

  dm.IBselect.Close;
end;

function Tfuncoes.GeraCargaTXTBalanca(): boolean;
var
  ini, fim: integer;
  balItem: TACBrCargaBalItem;
  pasta: String;
begin
  dm.ACBrCargaBal1.Produtos.Clear;
  dm.IBselect.Close;
  dm.IBselect.SQL.text :=
    'select * from produto where left(codbar, 1) = ''2'' and char_length(codbar) <= 7 and char_length(codbar) >= 5';
  dm.IBselect.Open;
  dm.IBselect.FetchAll;
  fim := dm.IBselect.RecordCount;
  ini := 0;

  informacao(ini, fim, dm.ACBrCargaBal1.ModeloStr + ', Aguarde...', true,
    False, 5);
  while not dm.IBselect.Eof do
  begin
    informacao(ini, fim, dm.ACBrCargaBal1.ModeloStr + ', Aguarde...', False,
      False, 5);
    ini := ini + 1;
    balItem := dm.ACBrCargaBal1.Produtos.new;
    balItem.ModeloEtiqueta := 1;
    balItem.tipo := tpvPeso;
    balItem.Codigo :=
      StrToIntDef(copy(dm.IBselect.FieldByName('codbar').AsString, 2, 4), 0);

    // Codigo          := ini;
    balItem.descricao := dm.IBselect.FieldByName('nome').AsString;

    balItem.ValorVenda := dm.IBselect.FieldByName('p_venda').AsCurrency;
    balItem.Validade :=
      StrToIntDef(copy(dm.IBselect.FieldByName('codbar').AsString, 6, 2), 15);
    balItem.Tecla := 0;
    balItem.Receita := dm.IBselect.FieldByName('nome').AsString;
    // Nutricional     := Format('Informação Nutricional do item %d', [I]);;

    balItem.Nutricional.Codigo :=
      StrToIntDef(copy(dm.IBselect.FieldByName('codbar').AsString, 2, 4), 0);
    balItem.Nutricional.qtd := 1;
    balItem.Nutricional.UndPorcao := tpGramas;
    balItem.Nutricional.PartInteira := 1;
    balItem.Nutricional.PartDecimal := tpPara12;
    balItem.Nutricional.MedCaseira := tpColherSopa;
    balItem.Nutricional.ValorEnergetico := 20;
    balItem.Nutricional.Carboidrato := 2;
    balItem.Nutricional.Proteina := 3;
    balItem.Nutricional.GorduraTotal := 4;
    balItem.Nutricional.GorduraSaturada := 5;
    balItem.Nutricional.GorduraTrans := 6;
    balItem.Nutricional.Fibra := 7;
    balItem.Nutricional.Sodio := 8;

    balItem.Setor.Codigo := 1;
    balItem.Setor.descricao := 'GERAL';
    { with dm.ACBrCargaBal1.Produtos.New do
      begin
      ModeloEtiqueta  := 1;
      Tipo            := tpvPeso;
      Codigo          := StrToIntDef(copy(dm.IBselect.FieldByName('codbar').AsString, 2, 5), 0);

      //Codigo          := ini;
      Descricao       := dm.IBselect.FieldByName('nome').AsString;
      ValorVenda      := dm.IBselect.FieldByName('p_venda').AsCurrency;
      Validade        := StrToIntDef(copy(dm.IBselect.FieldByName('codbar').AsString, 6, 2), 15);
      Tecla           := 0;
      Receita         := dm.IBselect.FieldByName('nome').AsString;
      //        Nutricional     := Format('Informação Nutricional do item %d', [I]);;

      Nutricional.Codigo := StrToIntDef(copy(dm.IBselect.FieldByName('codbar').AsString, 2, 5), 0);
      Nutricional.Qtd := 1;
      Nutricional.UndPorcao := tpGramas;
      Nutricional.PartInteira := 1;
      Nutricional.PartDecimal:= tpPara12;
      Nutricional.MedCaseira := tpColherSopa;
      Nutricional.ValorEnergetico := 20;
      Nutricional.Carboidrato := 2;
      Nutricional.Proteina := 3;
      Nutricional.GorduraTotal:= 4;
      Nutricional.GorduraSaturada:=5;
      Nutricional.GorduraTrans := 6;
      Nutricional.Fibra := 7;
      Nutricional.Sodio :=8;

      Setor.Codigo    := 1;
      Setor.Descricao := 'GERAL';
      end; }

    dm.IBselect.Next;
  end;

  informacao(ini, fim, dm.ACBrCargaBal1.ModeloStr + ', Aguarde...',
    False, true, 5);

  pasta := buscaConfigNaPastaDoControlW1('pastaMGV5_Balanca', true);
  if pasta <> '' then
  begin
    if RightStr(pasta, 1) <> '\' then
      pasta := pasta + '\';
  end;

  if pasta = '' then
    pasta := caminhoEXE_com_barra_no_final + 'Balanca\';

  if not DirectoryExists(pasta) then
    forceDirectories(pasta);

  dm.ACBrCargaBal1.GerarArquivos(pasta);
  dm.ACBrCargaBal1.Produtos.Clear;
  dm.IBselect.Close;

  ShowMessage('Arquivos Gerados em: ' + pasta);
end;

procedure Tfuncoes.fetchDataSet(var querysql: TIBQuery);
begin
  try
  Mensagem('Abrindo Tabela', 'Aguarde, Abrindo Tabela...', 25, 'Courier New',
    False, 0, clRed);
  finally

  end;
  Application.ProcessMessages;
  querysql.FetchAll;


    Mensagem('', '', 25, 'Courier New',False, 0, clRed, true);
end;

procedure Tfuncoes.criaSerieBD();
var
  nomeGenerator: String;
begin
  nomeGenerator := 'NFCE';
  if ((serie2 > 1) and (ParamCount > 0)) then
  begin
    nomeGenerator := 'NFCE' + IntToStr(serie2);
    if not VerSeExisteGeneratorPeloNome(nomeGenerator) then
    begin
      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add('CREATE SEQUENCE ' + nomeGenerator);
      dm.IBQuery1.ExecSQL;
      dm.IBQuery1.Transaction.Commit;
      MessageDlg('Sequência ' + nomeGenerator + ' Criada Com Sucesso!',
        mtInformation, [mbok], 1);
    end;
  end
  else
  begin
    ShowMessage('A Serie ' + IntToStr(serie2) + ' Não Pôde ser Criada!');
  end;

end;

procedure Tfuncoes.le_promoc1(var text: string);
begin
  text := '-';
  dm.ibquery4.Close;
  dm.ibquery4.SQL.text := 'select cod, quant, p_venda from promoc1';
  dm.ibquery4.Open;
  dm.ibquery4.FetchAll;

  while not dm.ibquery4.Eof do
  begin
    text := text + dm.ibquery4.FieldByName('cod').AsString +
      dm.ibquery4.FieldByName('quant').AsString + dm.ibquery4.FieldByName
      ('p_venda').AsString + '-';
    dm.ibquery4.Next;
  end;

  dm.ibquery4.Close;
end;

function Tfuncoes.FiltraNota(var nota, fornec: string;
  inicio: boolean = False): boolean;
begin
  Result := False;

  if inicio then
  begin
    if nota = '' then
    begin
      nota := funcoes.dialogo('generico', 100, '1234567890' + #8, 100, False,
        '', 'Control For Windows', 'Informe o Número da NFe:', '');
    end;
    if ((nota = '') or (nota = '*')) then
    begin
      nota := '';
      exit;
    end;

    dm.IBselect.Close;
    dm.IBselect.SQL.text :=
      'select e.nota, e.fornec, f.nome, e.total_nota, e.data as emissao, e.chegada from entrada e '
      + ' left join fornecedor f on (e.fornec = f.cod) where e.nota = :nota';
    dm.IBselect.ParamByName('nota').AsString := StrNum(nota);
    dm.IBselect.Open;
    dm.IBselect.FetchAll;

    if dm.IBselect.RecordCount = 1 then
      fornec := dm.IBselect.FieldByName('fornec').AsString
    else if dm.IBselect.RecordCount > 1 then
    begin
      fornec := funcoes.busca(dm.IBselect, 'fornec', 'fornec', 'fornec',
        'fornec');
    end
    else
    begin
      ShowMessage('Nota de Entrada ' + nota + ' Não Encontrada!');
      nota := '';
      fornec := '';
      dm.IBselect.Close;
      exit;
    end;
    if ((fornec = '') or (fornec = '*')) then
    begin
      nota := '';
      fornec := '';
      exit;
    end;

    Result := true;
    exit;
  end;

  dm.IBQuery2.Close;
  dm.IBQuery2.SQL.text :=
    'select i.cod, p.nome, i.quant, i.p_compra from item_entrada i ' +
    ' left join produto p on (i.cod = p.cod) where i.nota = :nota and i.fornec = :fornec';
  dm.IBQuery2.ParamByName('nota').AsString := StrNum(nota);
  dm.IBQuery2.ParamByName('fornec').AsString := StrNum(fornec);
  dm.IBQuery2.Open;

  TCurrencyField(dm.IBQuery2.FieldByName('quant')).DisplayFormat :=
    '#,###,##0.00';
  TCurrencyField(dm.IBQuery2.FieldByName('p_compra')).DisplayFormat :=
    '#,###,##0.00';
  // FormataCampos(dm.ibquery2, 2, '', 2);

  funcoes.busca(dm.IBQuery2, '', '', 'item_entradaV', '');
end;

procedure Tfuncoes.mensagemEnviandoNFCE(const msg: String;
  abrir, fechar: boolean);
begin
  if abrir then
  begin
    form65 := tform65.Create(self);
    try
      form65.RxGIFAnimator1.Image.LoadFromFile(ExtractFileDir(ParamStr(0)) +
        '\c.gif');
      form65.label1.caption := msg;
      form65.RxGIFAnimator1.Animate := true;
    except
    end;
    form65.Show;
  end;

  if fechar then
  begin
    form65.Close;
    form65.Free;
  end;
end;

procedure Tfuncoes.imprimePromissoria(nota: String = '');
var
  tudo: string;
  num: integer;
begin
  if nota = '' then
  begin
    nota := funcoes.dialogo('not', 0, '0123456789' + #8, 50, true, '',
      Application.Title, 'Qual o Número da Nota de Pedido?', '');
    if (nota = '*') or (nota = '') then
      exit;
  end;

  dm.IBselect.Close;
  dm.IBselect.SQL.Clear;
  dm.IBselect.SQL.Add
    ('select * from contasreceber where pago = 0 and nota = ' + nota);
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
  dm.IBQuery1.SQL.Add
    ('select nome,ende,bairro,est,cnpj from cliente where cod =' +
    dm.IBselect.FieldByName('documento').AsString);
  dm.IBQuery1.Open;

  form19.RichEdit1.Clear;
  funcoes.CharSetRichEdit(form19.RichEdit1);

  dm.IBQuery2.Close;
  dm.IBQuery2.SQL.Clear;
  dm.IBQuery2.SQL.Add('select * from registro');
  dm.IBQuery2.Open;
  num := 0;
  while not dm.IBselect.Eof do
  begin
    if num = 3 then
    begin
      num := 0;
      addRelatorioForm19(' ' + #12 + #13 + #10);
      addRelatorioForm19(' ' + #13 + #10);
      addRelatorioForm19(' ' + #13 + #10);
      addRelatorioForm19(' ' + #13 + #10);
    end;
    addRelatorioForm19(funcoes.CompletaOuRepete(#218, '', #196, 57) +
      funcoes.CompletaOuRepete(#194, #191, #196, 21) + #13 + #10);
    addRelatorioForm19(funcoes.CompletaOuRepete(#179 +
      '           N O T A     P R O M I S S O R I A', '', ' ', 57) +
      funcoes.CompletaOuRepete(#179 + funcoes.CompletaOuRepete('R$:',
      FormatCurr('#,###,###0.00', dm.IBselect.FieldByName('valor').AsCurrency),
      ' ', 19), #179, ' ', 21) + #13 + #10);
    addRelatorioForm19(funcoes.CompletaOuRepete(#195, '', #196, 57) +
      funcoes.CompletaOuRepete(#193, #180, #196, 21) + #13 + #10);
    tudo := '    ' + UpperCase('AOS ' + FormatDateTime('dd',
      dm.IBselect.FieldByName('vencimento').AsDateTime) + ' DO MES DE ' +
      FormatDateTime('mmmm', dm.IBselect.FieldByName('vencimento').AsDateTime) +
      ' DO ANO DE ' + FormatDateTime('YYYY',
      dm.IBselect.FieldByName('vencimento').AsDateTime) + ' PAGAREMOS A ' +
      form22.Pgerais.Values['empresa'] + ' CNPJ: ' + dm.IBQuery2.FieldByName
      ('cnpj').AsString + ' A IMPORTANCIA DE ' + funcoes.valorPorExtenso
      (dm.IBselect.FieldByName('valor').AsCurrency) +
      '. POR ESTA UNICA VIA DE NOTA PROMISSORIA, NA PRACA DE ' +
      dm.IBQuery2.FieldByName('cid').AsString + ' - ' + dm.IBQuery2.FieldByName
      ('est').AsString);
    funcoes.QuebraLinhas(#179, #179, tudo + '.', 78);
    addRelatorioForm19(funcoes.CompletaOuRepete(#195, #180, #196, 78) +
      #13 + #10);
    addRelatorioForm19(funcoes.CompletaOuRepete(#179 + ' EMITENTE: ' +
      dm.IBQuery1.FieldByName('nome').AsString,
      copy(dm.IBselect.FieldByName('historico').AsString,
      length(dm.IBselect.FieldByName('historico').AsString) - 5,
      length(dm.IBselect.FieldByName('historico').AsString)) + #179, ' ', 78) +
      #13 + #10);
    addRelatorioForm19(funcoes.CompletaOuRepete(#179 + ' ENDE.: ' +
      dm.IBQuery1.FieldByName('ENDE').AsString + ' - ' + dm.IBQuery1.FieldByName
      ('BAIRRO').AsString, #179, ' ', 78) + #13 + #10);
    addRelatorioForm19(funcoes.CompletaOuRepete(#179 + ' CPF.: ' +
      dm.IBQuery1.FieldByName('CNPJ').AsString, #179, ' ', 78) + #13 + #10);
    addRelatorioForm19(funcoes.CompletaOuRepete(#195, #180, #196, 78) +
      #13 + #10);
    addRelatorioForm19(funcoes.CompletaOuRepete(#179, #179, ' ', 78) +
      #13 + #10);
    addRelatorioForm19(funcoes.CompletaOuRepete(#179, #179, ' ', 78) +
      #13 + #10);
    addRelatorioForm19(funcoes.CompletaOuRepete(#179 +
      '      Assinatura do Emitente', dm.IBQuery2.FieldByName('cid').AsString +
      ' - ' + dm.IBQuery2.FieldByName('est').AsString + ', ' +
      FormatDateTime('dd', form22.dataMov) + ' DE ' +
      UpperCase(FormatDateTime('MMMM', form22.dataMov)) + ' DE ' +
      FormatDateTime('YYYY', form22.dataMov) + #179, ' ', 78) + #13 + #10);
    addRelatorioForm19(funcoes.CompletaOuRepete(#192, #217, #196, 78) +
      #13 + #10);
    addRelatorioForm19('   ' + #13 + #10);
    addRelatorioForm19(' ' + #13 + #10);
    addRelatorioForm19(' ' + #13 + #10);
    num := num + 1;
    dm.IBselect.Next;
  end;
  dm.IBselect.Close;
  dm.IBQuery2.Close;
  dm.IBQuery1.Close;
  form19.ShowModal;
end;

procedure Tfuncoes.imprimeDuplicata(nota: String = '');
var
  valor: currency;
  pag: integer;
  sim: String;
begin
  if nota = '' then
  begin
    nota := funcoes.dialogo('not', 0, '0123456789' + #8, 50, true, '',
      Application.Title, 'Qual o Número da Nota de Pedido?', '');
    if (nota = '*') or (nota = '') then
      exit;
  end;

  sim := funcoes.dialogo('normal', 0, 'SN', 30, False, 'S', Application.Title,
    'Enviar para Impressora?(S/N)' + #13 + #10, 'N');
  if (sim = '*') then
    exit;

  dm.IBQuery2.Close;
  dm.IBQuery2.SQL.Clear;
  dm.IBQuery2.SQL.Add('select ende,bairro,cnpj,telres,telcom from registro');
  dm.IBQuery2.Open;

  dm.IBselect.Close;
  dm.IBselect.SQL.Clear;
  dm.IBselect.SQL.Add
    ('select * from contasreceber where pago = 0 and nota = ' + nota);
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
  dm.IBQuery1.SQL.Add('select * from cliente where cod =' +
    dm.IBselect.FieldByName('documento').AsString);
  dm.IBQuery1.Open;

  form19.RichEdit1.Clear;
  funcoes.CharSetRichEdit(form19.RichEdit1);
  // form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('','','-',80)+#13+#10))));
  pag := 0;
  while not dm.IBselect.Eof do
  begin
    if pag = 2 then
    begin
      form19.RichEdit1.Perform(EM_REPLACESEL, 1,
        Longint(PChar(('  '#12 + #13 + #10))));
      pag := 0;
    end;
    form19.RichEdit1.Perform(EM_REPLACESEL, 1,
      Longint(PChar((funcoes.CompletaOuRepete(#218, '', #196,
      57) + funcoes.CompletaOuRepete(#194, #191, #196, 21) + #13 + #10))));
    form19.RichEdit1.Perform(EM_REPLACESEL, 1,
      Longint(PChar((funcoes.CompletaOuRepete(#179, '', ' ',
      57) + funcoes.CompletaOuRepete(#179 + ' NAT. DA OPERACAO', #179, ' ',
      21) + #13 + #10))));
    form19.RichEdit1.Perform(EM_REPLACESEL, 1,
      Longint(PChar((funcoes.CompletaOuRepete(#179 +
      funcoes.centraliza(form22.Pgerais.Values['empresa'], ' ', 56), '', ' ',
      57) + funcoes.CompletaOuRepete(#179 + '  VENDA A PRAZO', #179, ' ',
      21) + #13 + #10))));
    form19.RichEdit1.Perform(EM_REPLACESEL, 1,
      Longint(PChar((funcoes.CompletaOuRepete(#179 +
      funcoes.centraliza(dm.IBQuery2.FieldByName('ende').AsString + ' - ' +
      dm.IBQuery2.FieldByName('bairro').AsString, ' ', 56), '', ' ',
      57) + funcoes.CompletaOuRepete(#195, #180, #196, 21) + #13 + #10))));
    form19.RichEdit1.Perform(EM_REPLACESEL, 1,
      Longint(PChar((funcoes.CompletaOuRepete(#179 + funcoes.centraliza('CNPJ: '
      + dm.IBQuery2.FieldByName('cnpj').AsString, ' ', 56), '', ' ',
      57) + funcoes.CompletaOuRepete(#179 + ' DATA DE EMISSAO ', #179, ' ',
      21) + #13 + #10))));
    form19.RichEdit1.Perform(EM_REPLACESEL, 1,
      Longint(PChar((funcoes.CompletaOuRepete(#179 + funcoes.centraliza('FONE: '
      + dm.IBQuery2.FieldByName('TELRES').AsString + '        ' +
      dm.IBQuery2.FieldByName('TELCOM').AsString, ' ', 56), '', ' ',
      57) + funcoes.CompletaOuRepete(#179 + '     ' + FormatDateTime('dd/mm/yy',
      form22.dataMov), #179, ' ', 21) + #13 + #10))));
    form19.RichEdit1.Perform(EM_REPLACESEL, 1,
      Longint(PChar((funcoes.CompletaOuRepete(#192, '', #196,
      57) + funcoes.CompletaOuRepete(#193, #217, #196, 21) + #13 + #10))));
    form19.RichEdit1.Perform(EM_REPLACESEL, 1,
      Longint(PChar((funcoes.CompletaOuRepete(#218, #191, #196,
      12) + funcoes.CompletaOuRepete(#218, #194, #196,
      10) + funcoes.CompletaOuRepete('', #194, #196,
      13) + funcoes.CompletaOuRepete('', #194, #196,
      12) + funcoes.CompletaOuRepete('', #194, #196,
      11) + funcoes.CompletaOuRepete('', #194, #196,
      12) + funcoes.CompletaOuRepete('', #191, #196, 8) + #13 + #10))));
    form19.RichEdit1.Perform(EM_REPLACESEL, 1,
      Longint(PChar((funcoes.CompletaOuRepete(#179 + ' EMITENTE ', #179, ' ',
      12) + funcoes.CompletaOuRepete(#179 + ' FATURA ', #179, ' ',
      10) + funcoes.CompletaOuRepete('    VALOR', #179, ' ',
      13) + funcoes.CompletaOuRepete(' DUPLICATA ', #179, ' ',
      12) + funcoes.CompletaOuRepete('VENCIMENTO', #179, ' ',
      11) + funcoes.CompletaOuRepete(' JUROS R$', #179, ' ',
      12) + funcoes.CompletaOuRepete(' MULTA ', #179, ' ', 8) + #13 + #10))));
    form19.RichEdit1.Perform(EM_REPLACESEL, 1,
      Longint(PChar((funcoes.CompletaOuRepete(#179, #179, ' ',
      12) + funcoes.CompletaOuRepete(#195, #197, #196,
      10) + funcoes.CompletaOuRepete('', #197, #196,
      13) + funcoes.CompletaOuRepete('', #197, #196,
      12) + funcoes.CompletaOuRepete('', #197, #196,
      11) + funcoes.CompletaOuRepete('', #197, #196,
      12) + funcoes.CompletaOuRepete('', #180, #196, 8) + #13 + #10))));
    form19.RichEdit1.Perform(EM_REPLACESEL, 1,
      Longint(PChar((funcoes.CompletaOuRepete(#179 + '', #179, ' ',
      12) + funcoes.CompletaOuRepete(#179 + funcoes.centraliza(nota, ' ', 8),
      #179, ' ', 10) + funcoes.CompletaOuRepete('', FormatCurr('#,###,###0.00',
      dm.IBselect.FieldByName('valor').AsCurrency) + #179, ' ',
      13) + funcoes.CompletaOuRepete(funcoes.centraliza
      (copy(dm.IBselect.FieldByName('historico').AsString,
      length(dm.IBselect.FieldByName('historico').AsString) - 5,
      length(dm.IBselect.FieldByName('historico').AsString)), ' ', 11), #179,
      ' ', 12) + funcoes.CompletaOuRepete(' ' + FormatDateTime('dd/mm/yy',
      dm.IBselect.FieldByName('vencimento').AsDateTime) + ' ', #179, ' ',
      11) + funcoes.CompletaOuRepete('', FormatCurr('#,###,###0.00',
      Arredonda(dm.IBselect.FieldByName('valor').AsCurrency *
      StrToCurr(funcoes.ConverteNumerico(ConfParamGerais.Strings[6])) / 100,
      2)) + '/dia' + #179, ' ', 12) + funcoes.CompletaOuRepete('',
      FormatCurr('#,###,###0.00', Arredonda(dm.IBselect.FieldByName('valor')
      .AsCurrency * 0.02, 2)) + #179, ' ', 8) + #13 + #10))));
    form19.RichEdit1.Perform(EM_REPLACESEL, 1,
      Longint(PChar((funcoes.CompletaOuRepete(#179, #179, ' ',
      12) + funcoes.CompletaOuRepete(#192, #193, #196,
      10) + funcoes.CompletaOuRepete('', #193, #196,
      13) + funcoes.CompletaOuRepete('', #193, #196,
      12) + funcoes.CompletaOuRepete('', #193, #196,
      11) + funcoes.CompletaOuRepete('', #193, #196,
      12) + funcoes.CompletaOuRepete('', #217, #196, 8) + #13 + #10))));

    form19.RichEdit1.Perform(EM_REPLACESEL, 1,
      Longint(PChar((funcoes.CompletaOuRepete(#179, #179, ' ',
      12) + funcoes.CompletaOuRepete(#218 + #196 + #196 + #196 +
      'DADOS DO SACADO', #191, #196, 66) + #13 + #10))));
    // form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete(#179,#179,' ',12)+funcoes.CompletaOuRepete(#179+ '  NOME: '+dm.IBQuery1.fieldbyname('nome').AsString,#179,' ',66)+#13+#10))));
    addRelatorioForm19(funcoes.CompletaOuRepete(#179, #179, ' ', 12) +
      funcoes.CompletaOuRepete(#179 + 'NOME: ' + dm.IBQuery1.FieldByName('nome')
      .AsString, #179, ' ', 66) + #13 + #10);
    form19.RichEdit1.Perform(EM_REPLACESEL, 1,
      Longint(PChar((funcoes.CompletaOuRepete(#179, #179, ' ',
      12) + funcoes.CompletaOuRepete(#179 + 'END.: ' + dm.IBQuery1.FieldByName
      ('ende').AsString + ' - ' + dm.IBQuery1.FieldByName('bairro').AsString,
      #179, ' ', 66) + #13 + #10))));
    // form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete(#179,#179,' ',12)+funcoes.CompletaOuRepete(#179+ '  MUNICIPIO: '+dm.IBQuery1.fieldbyname('cid').AsString+' - '+dm.IBQuery1.fieldbyname('est').AsString ,#179,' ',66)+#13+#10))));
    form19.RichEdit1.Perform(EM_REPLACESEL, 1,
      Longint(PChar((funcoes.CompletaOuRepete(#179, #179, ' ',
      12) + funcoes.CompletaOuRepete(#179 + 'MUNICIPIO: ' +
      dm.IBQuery1.FieldByName('cid').AsString + ' - ' + dm.IBQuery1.FieldByName
      ('est').AsString + ' CEP: ' + dm.IBQuery1.FieldByName('CEP').AsString,
      #179, ' ', 66) + #13 + #10))));
    form19.RichEdit1.Perform(EM_REPLACESEL, 1,
      Longint(PChar((funcoes.CompletaOuRepete(#179, #179, ' ',
      12) + funcoes.CompletaOuRepete(#179 + 'PRACA DE PAGTO: ' +
      dm.IBQuery1.FieldByName('cid').AsString + ' - ' + dm.IBQuery1.FieldByName
      ('est').AsString, #179, ' ', 66) + #13 + #10))));
    form19.RichEdit1.Perform(EM_REPLACESEL, 1,
      Longint(PChar((funcoes.CompletaOuRepete(#179, #179, ' ',
      12) + funcoes.CompletaOuRepete(#179 + 'CPF/CNPJ: ' +
      dm.IBQuery1.FieldByName('CNPJ').AsString + ' TEL:' +
      dm.IBQuery1.FieldByName('telres').AsString, #179, ' ', 66) + #13
      + #10))));
    form19.RichEdit1.Perform(EM_REPLACESEL, 1,
      Longint(PChar((funcoes.CompletaOuRepete(#179, #179, ' ',
      12) + funcoes.CompletaOuRepete(#192, #217, #196, 66) + #13 + #10))));
    form19.RichEdit1.Perform(EM_REPLACESEL, 1,
      Longint(PChar((funcoes.CompletaOuRepete(#179, #179, ' ',
      12) + funcoes.CompletaOuRepete(#218 + #196 + #196 + #196 +
      'VALOR POR EXTENSO', #191, #196, 66) + #13 + #10))));
    funcoes.QuebraLinhas(funcoes.CompletaOuRepete(#179, #179, ' ', 12) + #179,
      #179, UpperCase(funcoes.valorPorExtenso(dm.IBselect.FieldByName('valor')
      .AsCurrency)), 78);
    form19.RichEdit1.Perform(EM_REPLACESEL, 1,
      Longint(PChar((funcoes.CompletaOuRepete(#179, #179, ' ',
      12) + funcoes.CompletaOuRepete(#195, #180, #196, 66) + #13 + #10))));
    form19.RichEdit1.Perform(EM_REPLACESEL, 1,
      Longint(PChar((funcoes.CompletaOuRepete(#179, #179, ' ',
      12) + funcoes.CompletaOuRepete(#179 +
      '      RECONHECO A EXATIDAO DESTA DUPLICATA DE VENDA MERCANTIL NA', #179,
      ' ', 66) + #13 + #10))));
    form19.RichEdit1.Perform(EM_REPLACESEL, 1,
      Longint(PChar((funcoes.CompletaOuRepete(#179, #179, ' ',
      12) + funcoes.CompletaOuRepete(#179 +
      'IMPORTANCIA ACIMA QUE PAGAREI A EMPRESA EMITENTE DA MESMA  OU  A', #179,
      ' ', 66) + #13 + #10))));
    form19.RichEdit1.Perform(EM_REPLACESEL, 1,
      Longint(PChar((funcoes.CompletaOuRepete(#179, #179, ' ',
      12) + funcoes.CompletaOuRepete(#179 +
      'SUA ORDEM NA PRACA E VENCIMENTO ACIMA MENCIONADOS.', #179, ' ', 66) + #13
      + #10))));
    form19.RichEdit1.Perform(EM_REPLACESEL, 1,
      Longint(PChar((funcoes.CompletaOuRepete(#179, #179, ' ',
      12) + funcoes.CompletaOuRepete(#179, #179, ' ', 66) + #13 + #10))));
    form19.RichEdit1.Perform(EM_REPLACESEL, 1,
      Longint(PChar((funcoes.CompletaOuRepete(#179, #179, ' ',
      12) + funcoes.CompletaOuRepete(#179 + '  ACEITE: ' +
      FormatDateTime('dd/mm/yy', form22.dataMov), #179, ' ', 66) + #13
      + #10))));
    form19.RichEdit1.Perform(EM_REPLACESEL, 1,
      Longint(PChar((funcoes.CompletaOuRepete(#192, #217, #196,
      12) + funcoes.CompletaOuRepete(#192 + #196 + #196 + #196 + #196 + #196 +
      #196 + #196 + #196 + #196 + #196 + #196 + #196 + #196 + #196 + #196 + #196
      + #196 + #196 + #196 + #196 + #196 + #196 + #196 + #196 + #196 + #196 +
      #196 + #196 + #196 + 'Assinatura do Sacado', #217, #196, 66) + #13
      + #10))));
    dm.IBselect.Next;
    pag := pag + 1;
    if pag = 1 then
    begin
      form19.RichEdit1.Perform(EM_REPLACESEL, 1,
        Longint(PChar(('  ' + #13 + #10))));
      form19.RichEdit1.Perform(EM_REPLACESEL, 1,
        Longint(PChar(('  ' + #13 + #10))));
      form19.RichEdit1.Perform(EM_REPLACESEL, 1,
        Longint(PChar(('  ' + #13 + #10))));
    end;
  end;
  dm.IBselect.Close;
  dm.IBQuery2.Close;
  dm.IBQuery1.Close;
  if sim = 'S' then
    imprime.textxArq('')
  else
    form19.ShowModal;
end;

function Tfuncoes.geraStringConfigUsuario(var valor: String;
  count: integer): String;
var
  ini: integer;
begin
  Result := '-';
  for ini := 0 to count - 1 do
  begin
    Result := Result + IntToStr(ini) + '- ' + LerConfig(valor, ini) + ' -';
  end;
end;

function Tfuncoes.verificaSePodeEmitirNFe(): boolean;
begin
  Result := False;
  if (ACBrNFe.SSL.NumeroSerie = '') then
    exit;
  Result := true;
end;

procedure Tfuncoes.enxugaAliquotas();
var
  aliqs: tstringList;
  ini: integer;
begin
  dm.IBselect.Close;
  dm.IBselect.SQL.text := 'select cod from aliq where cod < 10 and cod > 3';
  dm.IBselect.Open;

  aliqs := tstringList.Create;
  aliqs.Clear;

  while not dm.IBselect.Eof do
  begin
    aliqs.Add(dm.IBselect.FieldByName('cod').AsString);
    dm.IBselect.Next;
  end;

  for ini := 0 to aliqs.count - 1 do
  begin
    dm.IBQuery1.Close;
    dm.IBQuery1.SQL.text := 'select cod from produto where aliquota = :aliq';
    dm.IBQuery1.ParamByName('aliq').AsString := aliqs[ini];
    dm.IBQuery1.Open;
    if dm.IBQuery1.IsEmpty then
    begin
      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.text := 'delete from aliq where cod = :cod';
      dm.IBQuery1.ParamByName('cod').AsString := aliqs[ini];
      dm.IBQuery1.ExecSQL;
    end;
  end;

  aliqs.Free;
  if dm.IBQuery1.Transaction.InTransaction then
    dm.IBQuery1.Transaction.Commit;
end;

procedure Tfuncoes.PreencheCSOSN_Aliq();
var
  aliqs: tstringList;
  ini: integer;
  CSOSN: String;
begin
  dm.IBselect.Close;
  dm.IBselect.SQL.text := 'select cod, cst from aliq';
  dm.IBselect.Open;

  aliqs := tstringList.Create;
  aliqs.Add('00=101/102/103');
  aliqs.Add('60=500');
  aliqs.Add('40=400');
  aliqs.Add('41=300');

  while not dm.IBselect.Eof do
  begin
    CSOSN := aliqs.Values[trim(dm.IBselect.FieldByName('cst').AsString)];
    if CSOSN = '' then
      CSOSN := '101/102/103';

    dm.IBQuery1.Close;
    dm.IBQuery1.SQL.text := 'update aliq set CSOSN = :CSOSN where cod = :cod';
    dm.IBQuery1.ParamByName('CSOSN').AsString := CSOSN;
    dm.IBQuery1.ParamByName('cod').AsString :=
      dm.IBselect.FieldByName('cod').AsString;
    dm.IBQuery1.ExecSQL;
    dm.IBselect.Next;
  end;

  aliqs.Free;
  if dm.IBQuery1.Transaction.InTransaction then
    dm.IBQuery1.Transaction.Commit;
end;

procedure Tfuncoes.IMPBOLETO();
var
  nota, sim, NOMEARQ, _NF, _JUR1, _MUL1, temp, _DUP, linhaString, valor: String;
  arq, tmp: tstringList;
  ini, linha, linhaAtual: integer;
  _JUR, _MUL, RED: currency;
  lista1: TItensAcumProd;
  dataset: TClientDataSet;
begin
  BuscaBoletos;
  if funcoes.retornobusca = '*' then
    exit;

  NOMEARQ := caminhoEXE_com_barra_no_final + funcoes.retornobusca;

  nota := funcoes.dialogo('not', 0, '0123456789' + #8 + #32, 50, true, '',
    Application.Title, 'Qual o Número da Nota de Pedido?', '');
  if (nota = '*') then
    exit;

  nota := '-' + StringReplace(nota, ' ', '-',
    [rfReplaceAll, rfIgnoreCase]) + '-';

  _NF := funcoes.dialogo('not', 0, '0123456789' + #8, 50, False, '',
    Application.Title, 'Qual o Numero da Nota Fiscal ?', '');
  if (_NF = '*') then
    exit;

  _JUR1 := funcoes.dialogo('numero', 0, '', 2, False, 'X', Application.Title,
    'Qual a Taxa de Juros por Dia de Atraso ?', '0,00');
  if (_JUR1 = '*') then
    exit;

  _JUR := StrToCurrDef(_JUR1, 0);

  _MUL1 := funcoes.dialogo('numero', 0, '', 2, False, 'X', Application.Title,
    'Qual a Multa por Atraso ?', '0,00');
  if (_MUL1 = '*') then
    exit;

  _MUL := StrToCurrDef(_MUL1, 0);

  sim := funcoes.dialogo('normal', 0, 'SN', 30, False, 'S', Application.Title,
    'Enviar para Impressora?(S/N)' + #13 + #10, 'S');
  if (sim = '*') then
    exit;

  dm.IBselect.Close;
  dm.IBselect.SQL.text :=
    'select valor, total, vencimento, documento, historico, nota' +
    ' from contasreceber where pago = 0 and documento <> 0';
  // dm.IBselect.SQL.Text := 'select valor, total, vencimento, documento from contasreceber where pago = 0 and documento <> 0 and substring(historico from 1 for position(''-'', historico) -1) = :nota';
  // dm.IBselect.ParamByName('nota').AsString := nota;
  dm.IBselect.Open;

  lista1 := TItensAcumProd.Create;

  while not dm.IBselect.Eof do
  begin
    temp := '-' + copy(dm.IBselect.FieldByName('historico').AsString, 1,
      pos('-', dm.IBselect.FieldByName('historico').AsString) - 1) + '-';

    if Contido(temp, nota) then
    begin
      ini := lista1.Add(TacumProd.Create);
      lista1[ini].unid := '';
      lista1[ini].nota := STRZERO(dm.IBselect.FieldByName('nota').AsString, 6);
      lista1[ini].data := dm.IBselect.FieldByName('vencimento').AsDateTime;
      lista1[ini].quant := dm.IBselect.FieldByName('valor').AsCurrency;
      lista1[ini].val1 := lista1[ini].quant * _JUR / 100;
      lista1[ini].val2 := lista1[ini].quant * _MUL / 100;

      cod_OP := dm.IBselect.FieldByName('documento').AsString;
    end;

    dm.IBselect.Next;
  end;

  if lista1.count = 0 then
  begin
    MessageDlg('Nota ' + nota + ' Não Encontrada!', mtError, [mbok], 1);
    lista1.Free;
    dm.IBselect.Close;
    exit;
  end;

  for ini := 0 to lista1.count - 1 do
  begin
    lista1[ini].unid := STRZERO(ini + 1, 2) + '/' + STRZERO(lista1.count, 2);
  end;

  dm.IBselect.Close;
  dm.IBselect.SQL.text :=
    'select nome, ende,est, cid, cep, cnpj, ies, bairro, telres from' +
    ' cliente where cod = :cod';
  dm.IBselect.ParamByName('cod').AsString := cod_OP;
  dm.IBselect.Open;

  if dm.IBselect.IsEmpty then
  begin
    ShowMessage('Cliente ' + cod_OP + ' Não Encontrado!');
    dm.IBselect.Close;
    lista1.Free;
    exit;
  end;

  arq := tstringList.Create;
  tmp := tstringList.Create;
  arq.Add('NOTA=' + nota);
  arq.Add('CODCLI=' + STRZERO(cod_OP, 6));
  arq.Add('DATA=' + FormatDateTime('dd/mm/yy', form22.dataMov));
  arq.Add('NOME=' + dm.IBselect.FieldByName('nome').AsString);
  arq.Add('BAIRRO=' + dm.IBselect.FieldByName('BAIRRO').AsString);
  arq.Add('TELRES=' + dm.IBselect.FieldByName('TELRES').AsString);
  arq.Add('ENDERECO=' + dm.IBselect.FieldByName('ende').AsString);
  arq.Add('CIDADE=' + dm.IBselect.FieldByName('cid').AsString);
  arq.Add('ESTADO=' + dm.IBselect.FieldByName('est').AsString);
  arq.Add('CEP=' + dm.IBselect.FieldByName('cep').AsString);
  arq.Add('CNPJ=' + StrNum(dm.IBselect.FieldByName('cnpj').AsString));
  arq.Add('IES=' + dm.IBselect.FieldByName('ies').AsString);
  arq.Add('NOTAFISCAL=' + _NF);
  arq.Add('EMPRESA=' + form22.Pgerais.Values['empresa']);

  le_Arquivo(NOMEARQ, dataset);
  dataset.IndexFieldNames := 'LINHA;COLUNA';

  for ini := 0 to 50 do
  begin
    tmp.Add(IntToStr(ini) + '=' + CompletaOuRepete('', '', ' ', 130));
  end;

  tmp.Values['0'] := #15;

  dataset.First;
  while not dataset.Eof do
  begin
    if Contido(LeftStr(dataset.FieldByName('conteudo').AsString, 5),
      'REDUZ/AUMEN') then
    begin
      RED := 0;
      break;
    end;
    dataset.Next;
  end;
  dataset.First;

  if dataset.FieldByName('DUPLICATA').AsString <> '' then
  begin
    _DUP := dataset.FieldByName('DUPLICATA').AsString;
    _DUP := funcoes.dialogo('not', 0, '0123456789' + #8, 50, False, '',
      Application.Title, 'Qual o Numero de Sequencia ?', _DUP);
    if (_DUP = '*') then
      exit;

    _DUP := STRZERO(_DUP, 6);
  end;

  form19.RichEdit1.Clear;
  linha := 1;
  linhaAtual := dataset.FieldByName('linha').AsInteger;

  for ini := 0 to lista1.count - 1 do
  begin
    dataset.First;
    arq.Values['nota'] := lista1[ini].nota;
    arq.Values['DUPLICATA'] := STRZERO(_DUP, 6);
    arq.Values['PARCELA'] := lista1[ini].unid;
    arq.Values['VALOR'] := formataCurrency(lista1[ini].quant);
    arq.Values['VENCIMENTO'] := FormatDateTime('dd/mm/yy', lista1[ini].data);
    arq.Values['EXTENSO'] := CurrToStr(lista1[ini].quant);
    arq.Values['JUROS'] := formataCurrency(lista1[ini].val1);
    arq.Values['MULTA'] := formataCurrency(lista1[ini].val2);

    while not dataset.Eof do
    begin
      IF dataset.FieldByName('nome').AsString = 'EXTENSO' then
      begin

      end
      ELSE IF dataset.FieldByName('nome').AsString = 'FINAL' then
      begin

      end
      ELSE IF dataset.FieldByName('nome').AsString = 'COMANDO' then
      begin

      end
      ELSE IF dataset.FieldByName('nome').AsString = 'COMANDOX' then
      begin

      end
      else
      begin
        valor := arq.Values[dataset.FieldByName('nome').AsString];
        // if trim(valor) = '' then valor := dataSet.FieldByName('nome').AsString;
        if dataset.FieldByName('conteudo').AsString <> '' then
          valor := dataset.FieldByName('conteudo').AsString;

        linhaString := tmp.Values[dataset.FieldByName('linha').AsString];
        Insert(valor, linhaString, dataset.FieldByName('coluna').AsInteger + 1);
        tmp.Values[dataset.FieldByName('linha').AsString] := linhaString;
        // ShowMessage('linha=' + dataSet.FieldByName('linha').AsString + #13 + #13 +
        // TMP.Text);
      end;

      // ShowMessage(arq.GetText);
      linhaAtual := dataset.FieldByName('linha').AsInteger;
      dataset.Next;
    end;

    for linha := 0 to linhaAtual do
    begin
      addRelatorioForm19(LeftStr(tmp.ValueFromIndex[linha], 130) + CRLF);
      tmp[linha] := IntToStr(linha) + '=' + CompletaOuRepete('', '', ' ', 130);
    end;

  end;

  tmp.Free;
  arq.Free;
  form19.RichEdit1.Lines[0] := '%';

  // if sim = 'S' then imprime.impTxtMatricialUSB()
  if sim = 'S' then
    imprime.textx('')
  else
    form19.ShowModal;

  // funcoes.CharSetRichEdit(form19.richedit1);
  // form19.ShowModal;

  { form33 := tform33.Create(self);
    form33.DataSource1.DataSet := dataSet;
    form33.DBGrid1.DataSource  := form33.DataSource1;
    form33.ShowModal; }

  dm.IBselect.Close;
end;

procedure Tfuncoes.IMPBOLETO_Duplicata();
var
  nota, sim, NOMEARQ, _NF, _JUR1, _MUL1, temp, _DUP, linhaString, valor: String;
  arq, tmp: tstringList;
  ini, linha, linhaAtual, tamanho: integer;
  _JUR, _MUL, RED, total: currency;
  lista1: TItensAcumProd;
  dataset: TClientDataSet;
begin
  BuscaBoletos;
  if funcoes.retornobusca = '*' then
    exit;

  NOMEARQ := caminhoEXE_com_barra_no_final + funcoes.retornobusca;

  nota := funcoes.dialogo('not', 0, '0123456789' + #8 + #32, 50, true, '',
    Application.Title, 'Qual o Número da Nota de Pedido?', '');
  if (nota = '*') then
    exit;

  nota := '-' + StringReplace(nota, ' ', '-',
    [rfReplaceAll, rfIgnoreCase]) + '-';

  _NF := funcoes.dialogo('not', 0, '0123456789' + #8, 50, False, '',
    Application.Title, 'Qual o Numero da Nota Fiscal ?', '');
  if (_NF = '*') then
    exit;

  _JUR1 := funcoes.dialogo('numero', 0, '', 2, False, 'X', Application.Title,
    'Qual a Taxa de Juros por Dia de Atraso ?', '0,00');
  if (_JUR1 = '*') then
    exit;

  _JUR := StrToCurrDef(_JUR1, 0);

  _MUL1 := funcoes.dialogo('numero', 0, '', 2, False, 'X', Application.Title,
    'Qual a Multa por Atraso ?', '0,00');
  if (_MUL1 = '*') then
    exit;

  _MUL := StrToCurrDef(_MUL1, 0);

  sim := funcoes.dialogo('normal', 0, 'SN', 30, False, 'S', Application.Title,
    'Enviar para Impressora?(S/N)' + #13 + #10, 'S');
  if (sim = '*') then
    exit;

  dm.IBselect.Close;
  dm.IBselect.SQL.text :=
    'select valor, total, vencimento, documento, historico, nota' +
    ' from contasreceber where pago = 0 and documento <> 0';
  // dm.IBselect.SQL.Text := 'select valor, total, vencimento, documento from contasreceber where pago = 0 and documento <> 0 and substring(historico from 1 for position(''-'', historico) -1) = :nota';
  // dm.IBselect.ParamByName('nota').AsString := nota;
  dm.IBselect.Open;

  lista1 := TItensAcumProd.Create;
  total := 0;
  tamanho := 135;

  while not dm.IBselect.Eof do
  begin
    temp := '-' + copy(dm.IBselect.FieldByName('historico').AsString, 1,
      pos('-', dm.IBselect.FieldByName('historico').AsString) - 1) + '-';

    if Contido(temp, nota) then
    begin
      ini := lista1.Add(TacumProd.Create);
      lista1[ini].unid := '';
      lista1[ini].nota := STRZERO(dm.IBselect.FieldByName('nota').AsString, 6);
      lista1[ini].data := dm.IBselect.FieldByName('vencimento').AsDateTime;
      lista1[ini].quant := dm.IBselect.FieldByName('valor').AsCurrency;
      lista1[ini].val1 := lista1[ini].quant * _JUR / 100;
      lista1[ini].val2 := lista1[ini].quant * _MUL / 100;

      total := total + lista1[ini].quant;

      cod_OP := dm.IBselect.FieldByName('documento').AsString;
    end;

    dm.IBselect.Next;
  end;

  if lista1.count = 0 then
  begin
    MessageDlg('Nota ' + nota + ' Não Encontrada!', mtError, [mbok], 1);
    lista1.Free;
    dm.IBselect.Close;
    exit;
  end;

  for ini := 0 to lista1.count - 1 do
  begin
    lista1[ini].unid := STRZERO(ini + 1, 2) + '/' + STRZERO(lista1.count, 2);
  end;

  dm.IBselect.Close;
  dm.IBselect.SQL.text :=
    'select nome, ende,est, cid, cep, cnpj, ies, bairro, telres from' +
    ' cliente where cod = :cod';
  dm.IBselect.ParamByName('cod').AsString := cod_OP;
  dm.IBselect.Open;

  if dm.IBselect.IsEmpty then
  begin
    ShowMessage('Cliente ' + cod_OP + ' Não Encontrado!');
    dm.IBselect.Close;
    lista1.Free;
    exit;
  end;

  arq := tstringList.Create;
  tmp := tstringList.Create;
  arq.Add('NOTA=' + nota);
  arq.Add('CODCLI=' + STRZERO(cod_OP, 6));
  arq.Add('DATA=' + formataDataDDMMYY(form22.dataMov));
  arq.Add('NOME=' + dm.IBselect.FieldByName('nome').AsString);
  arq.Add('BAIRRO=' + dm.IBselect.FieldByName('BAIRRO').AsString);
  arq.Add('TELRES=' + dm.IBselect.FieldByName('TELRES').AsString);
  arq.Add('ENDERECO=' + dm.IBselect.FieldByName('ende').AsString);
  arq.Add('CIDADE=' + dm.IBselect.FieldByName('cid').AsString);
  arq.Add('ESTADO=' + dm.IBselect.FieldByName('est').AsString);
  arq.Add('CEP=' + dm.IBselect.FieldByName('cep').AsString);
  arq.Add('CNPJ=' + StrNum(dm.IBselect.FieldByName('cnpj').AsString));
  arq.Add('IES=' + dm.IBselect.FieldByName('ies').AsString);
  arq.Add('NOTAFISCAL=' + _NF);
  arq.Add('EMPRESA=' + form22.Pgerais.Values['empresa']);
  arq.Add('TOTAL=' + formataCurrency(total));

  le_Arquivo(NOMEARQ, dataset);
  dataset.IndexFieldNames := 'LINHA;COLUNA';

  for ini := 0 to 50 do
  begin
    tmp.Add(IntToStr(ini) + '=' + CompletaOuRepete('', '', ' ', tamanho));
  end;

  tmp.Values['0'] := #15;

  dataset.First;
  while not dataset.Eof do
  begin
    if Contido(LeftStr(dataset.FieldByName('conteudo').AsString, 5),
      'REDUZ/AUMEN') then
    begin
      RED := 0;
      break;
    end;
    dataset.Next;
  end;
  dataset.First;

  if dataset.FieldByName('DUPLICATA').AsString <> '' then
  begin
    _DUP := dataset.FieldByName('DUPLICATA').AsString;
    _DUP := funcoes.dialogo('not', 0, '0123456789' + #8, 50, False, '',
      Application.Title, 'Qual o Numero de Sequencia ?', _DUP);
    if (_DUP = '*') then
      exit;

    _DUP := STRZERO(_DUP, 6);
  end;

  form19.RichEdit1.Clear;
  linha := 1;
  linhaAtual := dataset.FieldByName('linha').AsInteger;
  dataset.First;
  arq.Values['DUPLICATA'] := STRZERO(_DUP, 6);

  for ini := 0 to lista1.count - 1 do
  begin
    arq.Values['nota'] := lista1[ini].nota;
    arq.Values['PARC' + IntToStr(ini + 1)] := lista1[ini].unid;
    arq.Values['VALOR' + IntToStr(ini + 1)] :=
      formataCurrency(lista1[ini].quant);
    arq.Values['VENCTO' + IntToStr(ini + 1)] :=
      formataDataDDMMYY(lista1[ini].data);
    arq.Values['EXTENSO'] := CurrToStr(lista1[ini].quant);
    arq.Values['JUROS'] := formataCurrency(lista1[ini].val1);
    arq.Values['MULTA'] := formataCurrency(lista1[ini].val2);
  end;

  while not dataset.Eof do
  begin
    IF dataset.FieldByName('nome').AsString = 'EXTENSO' then
    begin

    end
    ELSE IF dataset.FieldByName('nome').AsString = 'FINAL' then
    begin

    end
    ELSE IF dataset.FieldByName('nome').AsString = 'COMANDO' then
    begin

    end
    ELSE IF dataset.FieldByName('nome').AsString = 'COMANDOX' then
    begin

    end
    else
    begin
      valor := arq.Values[dataset.FieldByName('nome').AsString];
      // if trim(valor) = '' then valor := dataSet.FieldByName('nome').AsString;
      if dataset.FieldByName('conteudo').AsString <> '' then
        valor := dataset.FieldByName('conteudo').AsString;

      linhaString := tmp.Values[dataset.FieldByName('linha').AsString];
      Insert(valor, linhaString, dataset.FieldByName('coluna').AsInteger + 1);
      tmp.Values[dataset.FieldByName('linha').AsString] := linhaString;
      // ShowMessage('linha=' + dataSet.FieldByName('linha').AsString + #13 + #13 +
      // TMP.Text);
    end;

    // ShowMessage(arq.GetText);
    linhaAtual := dataset.FieldByName('linha').AsInteger;
    dataset.Next;
  end;

  for linha := 0 to linhaAtual do
  begin
    addRelatorioForm19(LeftStr(tmp.ValueFromIndex[linha], tamanho) + CRLF);
    tmp[linha] := IntToStr(linha) + '=' + CompletaOuRepete('', '', ' ',
      tamanho);
  end;

  tmp.Free;
  arq.Free;
  form19.RichEdit1.Lines[0] := '%';
  funcoes.CharSetRichEdit(form19.RichEdit1);
  // imprime.textx('');

  if sim = 'S' then
  begin
    imprime.impTxtMatricialUSB;
  end
  else
    form19.ShowModal;

  { form33 := tform33.Create(self);
    form33.DataSource1.DataSet := dataSet;
    form33.DBGrid1.DataSource  := form33.DataSource1;
    form33.ShowModal; }

  dm.IBselect.Close;
end;

function Tfuncoes.le_Arquivo(CaminhoBoleto: String;
  var temp: TClientDataSet): boolean;
var
  arq: tstringList;
  ini: integer;
begin
  Result := False;
  if FileExists(CaminhoBoleto) = False then
    exit;

  temp := TClientDataSet.Create(self);
  temp.FieldDefs.Add('LINHA', ftInteger);
  temp.FieldDefs.Add('COLUNA', ftInteger);
  temp.FieldDefs.Add('NOME', ftString, 15);
  temp.FieldDefs.Add('CONTEUDO', ftString, 140);
  temp.FieldDefs.Add('DUPLICATA', ftString, 16);
  temp.CreateDataSet;

  arq := tstringList.Create;
  arq.LoadFromFile(CaminhoBoleto);

  for ini := 0 to arq.count - 1 do
  begin
    temp.Insert;
    temp.FieldByName('LINHA').AsInteger :=
      StrToIntDef(LerConfig(arq[ini], 0), 0);
    temp.FieldByName('COLUNA').AsInteger :=
      StrToIntDef(LerConfig(arq[ini], 1), 0);
    temp.FieldByName('NOME').AsString := trim(LerConfig(arq[ini], 2));
    temp.FieldByName('CONTEUDO').AsString := trim(LerConfig(arq[ini], 3));
    temp.FieldByName('DUPLICATA').AsString := trim(LerConfig(arq[ini], 4));
    temp.Post;
  end;

  arq.Free;
end;

constructor TTWThreadVerificaPagamento.Create(const CreateSuspended: boolean);
begin
  self.FreeOnTerminate := true;
  inherited Create(CreateSuspended);
end;

procedure Tfuncoes.verificaDavNFCeTravado();
var
  horaAtual: TDateTime;
  arq: tstringList;
begin
  if not FileExists(ExtractFileDir(ParamStr(0)) + '\arquivo.dat') then
    exit;

  horaAtual := now;
  horaAtual := horaAtual - FileAgeCreate1(ExtractFileDir(ParamStr(0)) +
    '\arquivo.dat');

  if StrToIntDef(FormatDateTime('n', horaAtual), 0) >= 5 then
    reiniciaDAVNFCe;
end;

procedure Tfuncoes.reiniciaDAVNFCe();
var
  arq: tstringList;
begin
  arq := tstringList.Create;
  arq.SaveToFile(ExtractFileDir(ParamStr(0)) + '\davXXX.rca');
  arq.Free;
  TerminarProcesso('DavNfce.exe');
  if ParamCount > 0 then
  begin
    ShellExecute(Handle, 'open',
      PChar(ExtractFileDir(ParamStr(0)) + '\DavNFCe.exe'),
      pwidechar(ParamStr(1) + ':' + ParamStr(2)), '', SW_SHOWNORMAL);
  end
  else
    ShellExecute(Handle, 'open',
      PChar(ExtractFileDir(ParamStr(0)) + '\DavNFCe.exe'), '', '',
      SW_SHOWNORMAL);
end;

function Tfuncoes.TerminarProcesso(sFile: String): boolean;
var
  verSystem: TOSVersionInfo;
  hdlSnap, hdlProcess: THandle;
  bPath, bLoop: Bool;
  peEntry: TProcessEntry32;
  arrPid: Array [0 .. 1023] of DWord;
  iC: DWord;
  k, iCount: integer;
  arrModul: Array [0 .. 299] of Char;
  hdlModul: HMODULE;
begin
  Result := False;
  if ExtractFileName(sFile) = sFile then
    bPath := False
  else
    bPath := true;
  verSystem.dwOSVersionInfoSize := SizeOf(TOSVersionInfo);
  GetVersionEx(verSystem);
  if verSystem.dwPlatformId = VER_PLATFORM_WIN32_WINDOWS then
  begin
    hdlSnap := CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
    peEntry.dwSize := SizeOf(peEntry);
    bLoop := Process32First(hdlSnap, peEntry);
    while integer(bLoop) <> 0 do
    begin
      if bPath then
      begin
        if CompareText(peEntry.szExeFile, sFile) = 0 then
        begin
          TerminateProcess(OpenProcess(PROCESS_TERMINATE, False,
            peEntry.th32ProcessID), 0);
          Result := true;
        end;
      end
      else
      begin
        if CompareText(ExtractFileName(peEntry.szExeFile), sFile) = 0 then
        begin
          TerminateProcess(OpenProcess(PROCESS_TERMINATE, False,
            peEntry.th32ProcessID), 0);
          Result := true;
        end;
      end;
      bLoop := Process32Next(hdlSnap, peEntry);
    end;
    CloseHandle(hdlSnap);
  end
  else if verSystem.dwPlatformId = VER_PLATFORM_WIN32_NT then
  begin
    EnumProcesses(@arrPid, SizeOf(arrPid), iC);
    iCount := iC div SizeOf(DWord);
    for k := 0 to Pred(iCount) do
    begin
      hdlProcess := OpenProcess(PROCESS_QUERY_INFORMATION or PROCESS_VM_READ,
        False, arrPid[k]);
      if (hdlProcess <> 0) then
      begin
        EnumProcessModules(hdlProcess, @hdlModul, SizeOf(hdlModul), iC);
        GetModuleFilenameEx(hdlProcess, hdlModul, arrModul, SizeOf(arrModul));
        if bPath then
        begin
          if CompareText(arrModul, sFile) = 0 then
          begin
            TerminateProcess(OpenProcess(PROCESS_TERMINATE or
              PROCESS_QUERY_INFORMATION, False, arrPid[k]), 0);
            Result := true;
          end;
        end
        else
        begin
          if CompareText(ExtractFileName(arrModul), sFile) = 0 then
          begin
            TerminateProcess(OpenProcess(PROCESS_TERMINATE or
              PROCESS_QUERY_INFORMATION, False, arrPid[k]), 0);
            Result := true;
          end;
        end;
        CloseHandle(hdlProcess);
      end;
    end;
  end;
end;

function Tfuncoes.FileAgeCreate1(const fileName: string): TDateTime;
begin
  Result := FileDateToDateTime(FileAge(fileName));
end;

procedure Tfuncoes.RelVendasPorVendedor(tipo: String);
var
  ini, fim, h1, h3, vend, vendAnt, sim, no, prodTodos, h2, ordem: string;
  totalGeral, desc, totVend, volumes: currency;
  i, l, tam, tmp, fim1: integer;
  val: array [1 .. 3] of currency;
  Produtos: TItensProduto;
begin
  vend := '';
  h1 := '';

  vend := funcoes.dialogo('generico', 30, '1234567890' + #8, 30, False, '',
    Application.Title, 'Qual o Código do Vendedor?', '');
  if (vend = '*') then
    exit;

  fornecNFe := funcoes.dialogo('generico', 100, '1234567890' + #8, 100, False,
    '', Application.Title, 'Qual o Código do Fornecedor?', '');
  if (fornecNFe = '*') then
    exit;

  if vend <> '' then
  begin
    dm.IBselect.Close;
    dm.IBselect.SQL.Clear;
    dm.IBselect.SQL.Add('select cod from vendedor where cod = :cod');
    dm.IBselect.ParamByName('cod').AsString := vend;
    dm.IBselect.Open;

    if dm.IBselect.IsEmpty then
    begin
      ShowMessage('Cliente Não Encontrado!');
      dm.IBselect.Close;
      exit;
    end;
    dm.IBselect.Close;
  end;

  ini := funcoes.dialogo('data', 0, '', 2, true, '', Application.Title,
    'Qual a Data Inicial?', '');
  if ini = '*' then
    exit;
  fim := funcoes.dialogo('data', 0, '', 2, true, '', Application.Title,
    'Qual a Data Final?', '');
  if fim = '*' then
    exit;

  sim := funcoes.dialogo('generico', 0, 'SN', 20, False, 'S', Application.Title,
    'Imprimir Preço das Mercadorias?', 'N');
  if sim = '*' then
    exit;

  prodTodos := funcoes.dialogo('generico', 0, 'TSN', 20, False, 'S',
    Application.Title,
    'Imprimir Somente Produtos (S-A vista N-APrazo T-Todos)', 'T');
  if prodTodos = '*' then
    exit;

  ordem := funcoes.dialogo('generico', 0, '12', 20, False, 'S',
    Application.Title, 'Qual a Ordem (1-Código 2-DESCRICAO)', '1');
  if ordem = '*' then
    exit;

  h2 := '';
  h3 := '';
  if prodTodos = 'S' then
    h2 := ' and (v.codhis <> 2) '
  else if prodTodos = 'N' then
    h2 := ' and (v.codhis = 2) ';

  if fornecNFe <> '' then
    h3 := ' and (p.fornec = ' + StrNum(fornecNFe) + ') ';

  if vend <> '' then
    h1 := ' and (v.vendedor =' + vend + ')';
  i := 55;

  { dm.IBselect.SQL.Clear;
    dm.IBselect.SQL.Add('select v.nota, v.prazo, v.codhis, i.total, i.quant, i.cod, i.p_venda,v.prazo, v.vendedor, v.desconto' +
    ' from item_venda i, venda v where (i.nota = v.nota) and (v.cancelado = 0) and ((v.data >= :dini) and (v.data <= :dfim)) '+h1+' order by v.vendedor, v.nota, i.cod');
    dm.IBselect.ParamByName('dini').AsDateTime := StrToDateTimeDef(ini, form22.datamov);
    dm.IBselect.ParamByName('dfim').AsDateTime := StrToDateTimeDef(fim, form22.datamov);
    dm.IBselect.Open;
    dm.IBselect.FetchAll; }

  if ordem = '2' then
  begin
    dm.IBselect.Close;
    dm.IBselect.SQL.text :=
      ('select i.quant, i.cod, i.p_venda, i.total, v.vendedor, p.nome' +
      ' from item_venda i left join produto p on (p.cod = i.cod) left join venda v on (i.nota = v.nota)'
      + ' where (v.cancelado = 0) and ((i.data >= :dini) and (i.data <= :dfim)) '
      + h1 + h2 + h3 + ' order by v.vendedor, p.nome');
  end
  else
  begin
    dm.IBselect.Close;
    dm.IBselect.SQL.text :=
      ('select i.quant, i.cod, i.p_venda, i.total, v.vendedor' +
      ' from item_venda i left join venda v on (i.nota = v.nota)  left join produto p on (p.cod = i.cod) '
      + ' where (v.cancelado = 0) and ((i.data >= :dini) and (i.data <= :dfim)) '
      + h1 + h2 + h3 + ' order by v.vendedor, i.cod');
  end;

  dm.IBselect.ParamByName('dini').AsDateTime :=
    StrToDateTimeDef(ini, form22.dataMov);
  dm.IBselect.ParamByName('dfim').AsDateTime :=
    StrToDateTimeDef(fim, form22.dataMov);
  dm.IBselect.Open;
  dm.IBselect.FetchAll;

  if dm.IBselect.IsEmpty then
  begin
    dm.IBselect.Close;
    ShowMessage('Nenhum Resultado na Pesquisa');
    exit;
  end;

  Produtos := TItensProduto.Create;
  if vend = '' then
    vend := dm.IBselect.FieldByName('vendedor').AsString;
  no := 'xxx';
  desc := 0;
  totalGeral := 0;
  totVend := 0;
  volumes := 0;

  tam := 80;

  if Contido(tipo, 'TD') then
  begin
    tam := 40;
  end;

  form19.RichEdit1.Clear;

  funcoes.informacao(0, 0, 'Aguarde, Gerando Relatório...', true, False, 5);
  fim1 := dm.IBselect.RecordCount;

  while true do
  begin
    if dm.IBselect.Eof then
    begin
      if tipo = 'M' then
      begin
        form19.RichEdit1.Perform(EM_REPLACESEL, 1,
          Longint(PChar((funcoes.CompletaOuRepete('', '', '-', tam) + #13
          + #10))));
        form19.RichEdit1.Perform(EM_REPLACESEL, 1,
          Longint(PChar((funcoes.CompletaOuRepete('TOTAL GERAL ===>>',
          formataCurrency(volumes), '.', 63) + funcoes.CompletaOuRepete(' ',
          formataCurrency(totalGeral), ' ', 17) + #13 + #10))));
        form19.RichEdit1.Perform(EM_REPLACESEL, 1,
          Longint(PChar((funcoes.CompletaOuRepete('', '', '-', tam) + #13
          + #10))));
      end
      else
      begin
        form19.RichEdit1.Perform(EM_REPLACESEL, 1,
          Longint(PChar((funcoes.CompletaOuRepete('', '', '-', tam) + #13
          + #10))));
        form19.RichEdit1.Perform(EM_REPLACESEL, 1,
          Longint(PChar((funcoes.CompletaOuRepete('TOTAIS:',
          formataCurrency(volumes) + ' ' + formataCurrency(totalGeral), ' ',
          tam) + #13 + #10))));
        form19.RichEdit1.Perform(EM_REPLACESEL, 1,
          Longint(PChar((funcoes.CompletaOuRepete('', '', '-', tam) + #13
          + #10))));
      end;
      funcoes.informacao(dm.IBselect.RecNo, fim1,
        'Aguarde, Gerando Relatório...', False, true, 5);
      Produtos.Free;
      dm.IBselect.Close;
      dm.IBQuery2.Close;
      form19.ShowModal;
      exit;
    end;

    while not dm.IBselect.Eof do
    begin
      if Produtos.count = 0 then
      begin
        addRelatorioForm19(funcoes.CompletaOuRepete('', '', '-', tam) +
          #13 + #10);
        addRelatorioForm19
          (funcoes.CompletaOuRepete(LeftStr(funcoes.LerValorPGerais('empresa',
          form22.Pgerais), 25), 'DATA: ' + FormatDateTime('dd/mm/yy', now), ' ',
          tam) + #13 + #10);
        addRelatorioForm19(funcoes.CompletaOuRepete('VENDAS DE: ' +
          FormatDateTime('dd/mm/yy', StrToDateDef(ini, form22.dataMov)) + ' A '
          + FormatDateTime('dd/mm/yy', StrToDateDef(fim, form22.dataMov)), '',
          ' ', tam) + #13 + #10);
        addRelatorioForm19('VENDEDOR: ' + vend + ' - ' +
          copy(funcoes.BuscaNomeBD(dm.IBQuery1, 'nome', 'vendedor',
          'where cod = ' + vend), 1, 15) + #13 + #10);
        addRelatorioForm19(funcoes.CompletaOuRepete('', '', '-', tam) +
          #13 + #10);
        if tam > 40 then
        begin
          addRelatorioForm19
            ('  COD  NOME                                               QUANT            TOTAL'
            + #13 + #10);
          addRelatorioForm19(funcoes.CompletaOuRepete('', '', '-', tam) +
            #13 + #10);
        end;
      end;

      funcoes.informacao(dm.IBselect.RecNo, fim1,
        'Aguarde, Gerando Relatório...', False, False, 5);
      if vend <> dm.IBselect.FieldByName('vendedor').AsString then
      begin
        vend := dm.IBselect.FieldByName('vendedor').AsString;
        break;
      end;

      vendAnt := dm.IBselect.FieldByName('vendedor').AsString;

      { if no <> dm.IBselect.fieldbyname('nota').AsString then
        begin
        desc := desc + dm.IBselect.fieldbyname('desconto').AsCurrency;
        no   := dm.IBselect.fieldbyname('nota').AsString;
        end; }

      tmp := Produtos.Find(dm.IBselect.FieldByName('cod').AsInteger);
      if tmp = -1 then
      begin
        tmp := Produtos.Add(TregProd.Create);
        Produtos[tmp].cod := dm.IBselect.FieldByName('cod').AsInteger;
        dm.IBQuery2.Close;
        dm.IBQuery2.SQL.text := 'select nome from produto where cod = :cod';
        dm.IBQuery2.ParamByName('cod').AsInteger := Produtos[tmp].cod;
        dm.IBQuery2.Open;
        Produtos[tmp].nome :=
          copy(dm.IBQuery2.FieldByName('nome').AsString, 1, 40);
        Produtos[tmp].quant := dm.IBselect.FieldByName('quant').AsCurrency;
        // produtos[tmp].total := dm.IBselect.fieldbyname('total').AsCurrency;
        Produtos[tmp].total := dm.IBselect.FieldByName('total').AsCurrency;
      end
      else
      begin
        Produtos[tmp].quant := Produtos[tmp].quant + dm.IBselect.FieldByName
          ('quant').AsCurrency;
        // produtos[tmp].total := produtos[tmp].total + dm.IBselect.fieldbyname('total').AsCurrency;
        Produtos[tmp].total := Produtos[tmp].total + dm.IBselect.FieldByName
          ('total').AsCurrency;
      end;

      dm.IBselect.Next;
    end;

    totVend := 0;
    i := Produtos.count - 1;
    val[1] := 0;
    val[3] := 0;
    for tmp := 0 to i do
    begin
      if tam = 80 then
      begin
        addRelatorioForm19(funcoes.CompletaOuRepete('',
          IntToStr(Produtos[tmp].cod), ' ', 6) + '-' + funcoes.CompletaOuRepete
          (copy(Produtos[tmp].nome, 1, 40), '', ' ', 40) +
          funcoes.CompletaOuRepete('', FormatCurr('#,###,###0.00',
          Produtos[tmp].quant), ' ', 16) + funcoes.CompletaOuRepete('',
          FormatCurr('#,###,###0.00', Produtos[tmp].total), ' ', 17) +
          #13 + #10);
      end
      else
      begin
        addRelatorioForm19
          (funcoes.CompletaOuRepete(copy(IntToStr(Produtos[tmp].cod) + '-' +
          Produtos[tmp].nome, 1, 37), '', ' ', 37) + funcoes.CompletaOuRepete
          ('', FormatCurr('0', Produtos[tmp].quant), ' ', 3) + #13 + #10);
      end;

      val[1] := val[1] + Produtos[tmp].total;
      val[3] := val[3] + Produtos[tmp].quant;
      totalGeral := totalGeral + Produtos[tmp].total;
    end;

    val[1] := val[1] + desc;

    dm.IBQuery2.Close;
    dm.IBQuery2.SQL.text :=
      'select sum(v.desconto) as desc from venda v where cancelado = 0 and v.data >= :ini and v.data <= :fim and v.vendedor = :vend'
      + h2;
    dm.IBQuery2.ParamByName('ini').AsDateTime :=
      StrToDateTimeDef(ini, form22.dataMov);
    dm.IBQuery2.ParamByName('fim').AsDateTime :=
      StrToDateTimeDef(fim, form22.dataMov);
    dm.IBQuery2.ParamByName('vend').AsString := vendAnt;
    dm.IBQuery2.Open;

    desc := StrToCurrDef(dm.IBQuery2.FieldByName('desc').AsString, 0);
    dm.IBQuery2.Close;
    totalGeral := totalGeral + desc;

    if tam = 80 then
    begin
      if desc <> 0 then
        addRelatorioForm19(funcoes.CompletaOuRepete('', '0', ' ', 6) + '-' +
          funcoes.CompletaOuRepete('DESCONTO', '', ' ', 40) +
          funcoes.CompletaOuRepete('', FormatCurr('#,###,###0.00', 0), ' ', 16)
          + funcoes.CompletaOuRepete('', FormatCurr('#,###,###0.00', desc), ' ',
          17) + #13 + #10);
      // addRelatorioForm19(funcoes.CompletaOuRepete('', '0',' ',6) + '-' + funcoes.CompletaOuRepete('DESCONTO','',' ',30) +  funcoes.CompletaOuRepete('',FormatCurr('#,###,###0.00',desc),' ',22) + #13 + #10);
    end
    else
    begin
      if desc <> 0 then
        addRelatorioForm19(funcoes.CompletaOuRepete('', '0', ' ', 5) + '-' +
          funcoes.CompletaOuRepete('DESCONTO', '', ' ', 24) +
          funcoes.CompletaOuRepete('', FormatCurr('0.00', desc), ' ', 10) +
          #13 + #10);
    end;

    val[1] := val[1] + desc;

    volumes := volumes + val[3];

    if tipo = 'M' then
    begin
      form19.RichEdit1.Perform(EM_REPLACESEL, 1,
        Longint(PChar((funcoes.CompletaOuRepete('', '', '-', tam) + #13
        + #10))));
      form19.RichEdit1.Perform(EM_REPLACESEL, 1,
        Longint(PChar((funcoes.CompletaOuRepete('VOLUMES: ',
        formataCurrency(val[3]), '.', 63) + funcoes.CompletaOuRepete(' ',
        formataCurrency(val[1]), ' ', 17) + #13 + #10))));
      // form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('VOLUMES: ' + formataCurrency(val[3]) + '    Total R$: ' + formataCurrency(val[1]),'',' ',tam)+#13+#10))));
      form19.RichEdit1.Perform(EM_REPLACESEL, 1,
        Longint(PChar((funcoes.CompletaOuRepete('', '', '-', tam) + #13
        + #10))));
    end
    else
    begin
      form19.RichEdit1.Perform(EM_REPLACESEL, 1,
        Longint(PChar((funcoes.CompletaOuRepete('', '', '-', tam) + #13
        + #10))));
      form19.RichEdit1.Perform(EM_REPLACESEL, 1,
        Longint(PChar((funcoes.CompletaOuRepete('VOLUMES: ' +
        formataCurrency(val[3]), 'Total R$: ' + formataCurrency(val[1]), ' ',
        tam) + #13 + #10))));
      form19.RichEdit1.Perform(EM_REPLACESEL, 1,
        Longint(PChar((funcoes.CompletaOuRepete('', '', '-', tam) + #13
        + #10))));
    end;
    { form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('','','-',tam)+#13+#10))));
      form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('VOLUMES: ' + formataCurrency(val[3]) + '    Total R$: ' + formataCurrency(val[1]),'',' ',tam)+#13+#10))));
      form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('','','-',tam)+ #13+ #10)))); }

    desc := 0;
    Produtos.Clear;
  end;

  { dm.IBselect.Close;
    dm.IBselect.SQL.Clear;
    dm.IBselect.SQL.Add('select i.cod, p.nome, v.vendedor, sum(i.quant) as quant, sum(i.total) as total from item_venda i left join produto ' +
    'p on (i.cod = p.cod) left join venda v on (v.nota = i.nota) where ((v.cancelado = 0) and (v.data >= :v1) and (v.data<=:v2)) '+ h1 +' group by i.cod, p.nome, v.vendedor order by v.vendedor,i.cod');
    dm.IBselect.ParamByName('v1').AsDateTime := StrToDate(ini);
    dm.IBselect.ParamByName('v2').AsDateTime := StrToDate(fim);
    dm.IBselect.Open;
    dm.IBselect.FetchAll;
  }

  tam := 80;

  if vend = '' then
    vend := dm.IBselect.FieldByName('vendedor').AsString;

  if (tipo = 'T') or (tipo = 'D') then
  begin
    tam := 45;
  end;

  form19.RichEdit1.Clear;
  addRelatorioForm19(funcoes.CompletaOuRepete('', '', '-', tam) + #13 + #10);
  addRelatorioForm19(funcoes.CompletaOuRepete(funcoes.LerValorPGerais('empresa',
    form22.Pgerais), 'DATA: ' + FormatDateTime('dd/mm/yy', now), ' ', tam) +
    #13 + #10);
  addRelatorioForm19(funcoes.CompletaOuRepete('VENDAS DE: ' +
    FormatDateTime('dd/mm/yy', StrToDateDef(ini, form22.dataMov)) + ' A ' +
    FormatDateTime('dd/mm/yy', StrToDateDef(fim, form22.dataMov)),
    'HORA: ' + FormatDateTime('tt', now) + '', ' ', tam) + #13 + #10);
  addRelatorioForm19('VENDEDOR: ' + vend + ' - ' +
    copy(funcoes.BuscaNomeBD(dm.IBQuery1, 'nome', 'vendedor',
    'where cod = ' + vend), 1, 15) + #13 + #10);
  addRelatorioForm19(funcoes.CompletaOuRepete('', '', '-', tam) + #13 + #10);

  if tam = 80 then
  begin
    addRelatorioForm19
      ('  DATA    COD   DESCRICAO                            QUANT        PRECO DE VENDA'
      + #13 + #10);
  end
  else
  begin
    addRelatorioForm19('DATA    COD   DESCRICAO              QUANT' +
      #13 + #10);
  end;

  form19.RichEdit1.Perform(EM_REPLACESEL, 1,
    Longint(PChar((funcoes.CompletaOuRepete('', '', '-', tam) + #13 + #10))));
  l := 0;
  totalGeral := 0;
  val[1] := 0;
  val[2] := 0;
  val[3] := 0;

  while not dm.IBselect.Eof do
  begin
    if vend <> dm.IBselect.FieldByName('vendedor').AsString then
    begin

      if val[3] <> 0 then
      begin
        if vend <> '' then
          h1 := ' and (v.vendedor =' + vend + ')';
        desc := 0;

        dm.IBQuery2.Close;
        dm.IBQuery2.SQL.Clear;
        dm.IBQuery2.SQL.Add
          ('select sum(desconto) as soma from venda v where (v.cancelado = 0) and ((v.data >= :v1) and (v.data<=:v2)) '
          + h1);
        dm.IBQuery2.ParamByName('v1').AsDateTime := StrToDate(ini);
        dm.IBQuery2.ParamByName('v2').AsDateTime := StrToDate(fim);
        dm.IBQuery2.Open;

        if not dm.IBQuery2.IsEmpty then
          desc := dm.IBQuery2.FieldByName('soma').AsCurrency;
        val[2] := desc;
        if tam = 80 then
        begin
          if desc <> 0 then
            addRelatorioForm19(funcoes.CompletaOuRepete('', '0', ' ', 6) + '-' +
              funcoes.CompletaOuRepete('Desconto', '', ' ', 30) +
              funcoes.CompletaOuRepete('', FormatCurr('#,###,###0.00', 0), ' ',
              21) + funcoes.CompletaOuRepete('', FormatCurr('#,###,###0.00',
              val[2]), ' ', 22) + #13 + #10);
        end
        else
        begin
          if desc <> 0 then
            addRelatorioForm19(funcoes.CompletaOuRepete('', '0', ' ', 6) + '-' +
              funcoes.CompletaOuRepete('Desconto', '', ' ', 20) +
              funcoes.CompletaOuRepete('', FormatCurr('#,###,###0.00', 0), ' ',
              14) + funcoes.CompletaOuRepete('', FormatCurr('#,###,###0.00',
              val[2]), ' ', 9) + #13 + #10);
        end;
      end;

      val[1] := val[1] + desc;
      form19.RichEdit1.Perform(EM_REPLACESEL, 1,
        Longint(PChar((funcoes.CompletaOuRepete('', '', '-', tam) + #13
        + #10))));
      form19.RichEdit1.Perform(EM_REPLACESEL, 1,
        Longint(PChar((funcoes.CompletaOuRepete('VOLUMES:' +
        funcoes.CompletaOuRepete('', FormatCurr('#,###,###0', val[3]), ' ',
        14) + ' VENDAS:' + funcoes.CompletaOuRepete('',
        FormatCurr('#,###,###0.00', val[1]), ' ', 14), '', ' ', tam) + #13
        + #10))));
      form19.RichEdit1.Perform(EM_REPLACESEL, 1,
        Longint(PChar((funcoes.CompletaOuRepete('', '', '-', tam) + #13 + #10
        + #12))));

      vend := dm.IBselect.FieldByName('vendedor').AsString;

      form19.RichEdit1.Perform(EM_REPLACESEL, 1,
        Longint(PChar(('  ' + #13 + #10))));
      form19.RichEdit1.Perform(EM_REPLACESEL, 1,
        Longint(PChar(('  ' + #13 + #10))));

      form19.RichEdit1.Perform(EM_REPLACESEL, 1,
        Longint(PChar((funcoes.CompletaOuRepete('', '', '-', tam) + #13
        + #10))));
      form19.RichEdit1.Perform(EM_REPLACESEL, 1,
        Longint(PChar((funcoes.CompletaOuRepete(funcoes.LerValorPGerais
        ('empresa', form22.Pgerais), 'DATA: ' + FormatDateTime('dd/mm/yy', now),
        ' ', tam) + #13 + #10))));
      // form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('VENDAS DE: ' + FormatDateTime('dd/mm/yy',StrToDateDef(ini, form22.datamov)) + ' A ' + FormatDateTime('dd/mm/yy',StrToDateDef(fim, form22.datamov)) + ' VENDEDOR: ' + VEND + ' - ' + copy(funcoes.BuscaNomeBD(dm.ibquery1, 'nome', 'vendedor', 'where cod = ' + vend), 1, 15),'HORA: ' + FormatDateTime('tt',now)+'|',' ', tam)+#13+#10))));
      // form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('','','-',tam)+#13+#10))));
      form19.RichEdit1.Perform(EM_REPLACESEL, 1,
        Longint(PChar((funcoes.CompletaOuRepete('VENDAS DE: ' +
        FormatDateTime('dd/mm/yy', StrToDateDef(ini, form22.dataMov)) + ' A ' +
        FormatDateTime('dd/mm/yy', StrToDateDef(fim, form22.dataMov)),
        'HORA: ' + FormatDateTime('tt', now) + '', ' ', tam) + #13 + #10))));
      addRelatorioForm19('VENDEDOR: ' + vend + ' - ' +
        copy(funcoes.BuscaNomeBD(dm.IBQuery1, 'nome', 'vendedor',
        'where cod = ' + vend), 1, 15) + #13 + #10);
      if tam = 80 then
      begin
        addRelatorioForm19
          ('  DATA    COD   DESCRICAO                            QUANT        PRECO DE VENDA'
          + #13 + #10);
      end
      else
      begin
        addRelatorioForm19('DATA    COD   DESCRICAO              QUANT' +
          #13 + #10);
      end;

      addRelatorioForm19(funcoes.CompletaOuRepete('', '', '-', tam) +
        #13 + #10);

      val[1] := 0;
      val[2] := 0;
      val[3] := 0;
    end;

    if l >= 55 then
    begin
      l := 0;
      form19.RichEdit1.Perform(EM_REPLACESEL, 1,
        Longint(PChar((funcoes.CompletaOuRepete('', '', '-', tam) + #13 + #10
        + #12))));
      form19.RichEdit1.Perform(EM_REPLACESEL, 1,
        Longint(PChar(('  ' + #13 + #10))));
      form19.RichEdit1.Perform(EM_REPLACESEL, 1,
        Longint(PChar(('  ' + #13 + #10))));
      form19.RichEdit1.Perform(EM_REPLACESEL, 1,
        Longint(PChar((funcoes.CompletaOuRepete('', '', '-', tam) + #13
        + #10))));
      form19.RichEdit1.Perform(EM_REPLACESEL, 1,
        Longint(PChar((funcoes.CompletaOuRepete(funcoes.LerValorPGerais
        ('empresa', form22.Pgerais), 'DATA: ' + FormatDateTime('dd/mm/yy', now),
        ' ', tam) + #13 + #10))));
      // form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('VENDAS DE: ' + FormatDateTime('dd/mm/yy',StrToDateDef(ini, form22.datamov)) + ' A ' + FormatDateTime('dd/mm/yy',StrToDateDef(fim, form22.datamov)) + ' VENDEDOR: ' + VEND + ' - ' + copy(funcoes.BuscaNomeBD(dm.ibquery1, 'nome', 'vendedor', 'where cod = ' + vend), 1, 15),'HORA: ' + FormatDateTime('tt',now)+'|',' ',tam)+#13+#10))));
      // form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('','','-',tam)+#13+#10))));
      form19.RichEdit1.Perform(EM_REPLACESEL, 1,
        Longint(PChar((funcoes.CompletaOuRepete('VENDAS DE: ' +
        FormatDateTime('dd/mm/yy', StrToDateDef(ini, form22.dataMov)) + ' A ' +
        FormatDateTime('dd/mm/yy', StrToDateDef(fim, form22.dataMov)),
        'HORA: ' + FormatDateTime('tt', now) + '', ' ', tam) + #13 + #10))));
      addRelatorioForm19('VENDEDOR: ' + vend + ' - ' +
        copy(funcoes.BuscaNomeBD(dm.IBQuery1, 'nome', 'vendedor',
        'where cod = ' + vend), 1, 15) + #13 + #10);
      if tam = 80 then
      begin
        addRelatorioForm19
          ('  DATA    COD   DESCRICAO                            QUANT        PRECO DE VENDA'
          + #13 + #10);
      end
      else
      begin
        addRelatorioForm19('DATA    COD   DESCRICAO              QUANT' +
          #13 + #10);
      end;
      addRelatorioForm19(funcoes.CompletaOuRepete('', '', '-', tam) +
        #13 + #10);
    end;

    val[3] := val[3] + dm.IBselect.FieldByName('QUANT').AsCurrency;

    if tam = 80 then
    begin
      addRelatorioForm19(funcoes.CompletaOuRepete('',
        dm.IBselect.FieldByName('cod').AsString, ' ', 6) + '-' +
        funcoes.CompletaOuRepete(copy(dm.IBselect.FieldByName('nome').AsString,
        1, 30), '', ' ', 30) + funcoes.CompletaOuRepete('',
        FormatCurr('#,###,###0.00', dm.IBselect.FieldByName('quant')
        .AsCurrency), ' ', 21) + IfThen(sim = 'N', '',
        funcoes.CompletaOuRepete('', FormatCurr('#,###,###0.00',
        dm.IBselect.FieldByName('total').AsCurrency), ' ', 22)) + #13 + #10);
    end
    else
    begin
      addRelatorioForm19(funcoes.CompletaOuRepete('',
        dm.IBselect.FieldByName('cod').AsString, ' ', 5) + '-' +
        funcoes.CompletaOuRepete(copy(dm.IBselect.FieldByName('nome').AsString,
        1, 35), '', ' ', 35) + IfThen(sim = 'N', funcoes.CompletaOuRepete('',
        FormatCurr('#,###,###0', dm.IBselect.FieldByName('quant').AsCurrency),
        ' ', 4), funcoes.CompletaOuRepete('', FormatCurr('#,###,###0',
        dm.IBselect.FieldByName('total').AsCurrency), ' ', 4)) + #13 + #10);
      // funcoes.CompletaOuRepete('',FormatCurr('#,###,###0', dm.IBselect.fieldbyname('quant').AsCurrency),' ', 4) + #13 + #10);
    end;

    val[1] := val[1] + dm.IBselect.FieldByName('total').AsCurrency;
    totalGeral := totalGeral + dm.IBselect.FieldByName('total').AsCurrency;
    l := l + 1;
    dm.IBselect.Next;
  end;

  if tipo = 'M' then
  begin
    form19.RichEdit1.Perform(EM_REPLACESEL, 1,
      Longint(PChar((funcoes.CompletaOuRepete('', '', '-', tam) + #13 + #10))));
    form19.RichEdit1.Perform(EM_REPLACESEL, 1,
      Longint(PChar((funcoes.CompletaOuRepete('VOLUMES:',
      formataCurrency(val[3] + val[2]), '.', 56) + funcoes.CompletaOuRepete
      ('Total R$: ', formataCurrency(totalGeral), ' ', 24) + #13 + #10))));
    form19.RichEdit1.Perform(EM_REPLACESEL, 1,
      Longint(PChar((funcoes.CompletaOuRepete('', '', '-', tam) + #13 + #10))));
  end
  else
  begin
    form19.RichEdit1.Perform(EM_REPLACESEL, 1,
      Longint(PChar((funcoes.CompletaOuRepete('', '', '-', tam) + #13 + #10))));
    form19.RichEdit1.Perform(EM_REPLACESEL, 1,
      Longint(PChar((funcoes.CompletaOuRepete('VOLUMES: ' + formataCurrency(val
      [3] + val[2]) + '    Total R$: ' + formataCurrency(totalGeral), '', ' ',
      tam) + #13 + #10))));
    form19.RichEdit1.Perform(EM_REPLACESEL, 1,
      Longint(PChar((funcoes.CompletaOuRepete('', '', '-', tam) + #13 + #10))));
  end;
  form19.ShowModal;
end;

procedure Tfuncoes.corrigeUnidades();
var
  ini, fim: integer;
begin
  if not verSeExisteTabela('UNID') then
    exit;

  dm.IBselect.Close;
  dm.IBselect.SQL.text := 'select cod, unid from produto';
  dm.IBselect.Open;
  dm.IBselect.FetchAll;
  fim := dm.IBselect.RecordCount;

  informacao(dm.IBselect.RecNo, fim, 'Aguarde, Atualizando Unidades...', true,
    False, 5);

  while not dm.IBselect.Eof do
  begin
    informacao(dm.IBselect.RecNo, fim, 'Aguarde, Atualizando Unidades...',
      False, False, 5);

    if SomenteLetras(dm.IBselect.FieldByName('unid').AsString) <>
      trim(dm.IBselect.FieldByName('unid').AsString) then
    begin
      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.text :=
        'update produto set unid = :unid where cod = :cod';
      dm.IBQuery1.ParamByName('unid').AsString :=
        SomenteLetras(dm.IBselect.FieldByName('unid').AsString);
      dm.IBQuery1.ParamByName('cod').AsInteger := dm.IBselect.FieldByName('cod')
        .AsInteger;
      dm.IBQuery1.ExecSQL;
    end;

    dm.IBselect.Next;
  end;

  dm.IBselect.Close;
  dm.IBselect.Close;
  dm.IBselect.SQL.text := 'select unid_ent, unid_sai, nome from UNID';
  dm.IBselect.Open;
  dm.IBselect.FetchAll;
  fim := dm.IBselect.RecordCount;
  informacao(dm.IBselect.RecNo, fim, 'Aguarde, Atualizando Unidades...', true,
    False, 5);

  while not dm.IBselect.Eof do
  begin
    informacao(dm.IBselect.RecNo, fim, 'Aguarde, Atualizando Unidades...',
      False, False, 5);

    if SomenteLetras(dm.IBselect.FieldByName('unid_sai').AsString) <>
      trim(dm.IBselect.FieldByName('unid_sai').AsString) then
    begin
      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add
        ('update unid set unid_sai = :unid_sai where nome = :nome');
      dm.IBQuery1.ParamByName('unid_sai').AsString :=
        SomenteLetras(dm.IBselect.FieldByName('unid_sai').AsString);
      dm.IBQuery1.ParamByName('nome').AsString :=
        dm.IBselect.FieldByName('nome').AsString;
      dm.IBQuery1.ExecSQL;
    end;

    dm.IBselect.Next;
  end;

  informacao(dm.IBselect.RecNo, fim, 'Aguarde, Atualizando Unidades...',
    False, true, 5);
  informacao(dm.IBselect.RecNo, fim, 'Aguarde, Encerrando Transação...', true,
    False, 5);
  if dm.IBQuery1.Transaction.InTransaction then
    dm.IBQuery1.Transaction.Commit;
  informacao(dm.IBselect.RecNo, fim, 'Aguarde, Encerrando Transação...',
    False, true, 5);

end;

procedure Tfuncoes.distribuicaoNFe();
var
  cnpj, UltNSU, sStat: string[20];
  sChave, CODestado, msgERRO, Impresso, sTemMais: String;
  dataset: TClientDataSet;
  i, fim: integer;
  lista: tstringList;
begin
  dataset := TClientDataSet.Create(self);
  dataset.FieldDefs.Add('NOME', ftString, 50);
  dataset.FieldDefs.Add('CPFCNPJ', ftString, 22);
  dataset.FieldDefs.Add('EMISSAO', ftDate);
  dataset.FieldDefs.Add('CHAVE', ftString, 45);
  dataset.FieldDefs.Add('VALOR', ftCurrency);
  dataset.FieldDefs.Add('NOTA', ftInteger);
  dataset.FieldDefs.Add('SERIE', ftInteger);
  dataset.FieldDefs.Add('IE', ftString, 45);
  dataset.FieldDefs.Add('TIPONF', ftString, 10);
  dataset.FieldDefs.Add('SIT', ftString, 12);
  dataset.FieldDefs.Add('MANI', ftString, 1);
  dataset.CreateDataSet;
  dataset.IndexFieldNames := 'EMISSAO';

  ACBrNFe.Configuracoes.geral.ModeloDF := moNFe;
  // ACBrNFe.Configuracoes.WebServices.Ambiente := taProducao;
  // ACBrNFe.Configuracoes.Arquivos.PathSalvar := caminhoEXE_com_barra_no_final+'NFe\ent\';
  // ACBrNFe.Configuracoes.Geral.Salvar := true;

  dm.IBselect.Close;
  dm.IBselect.SQL.text := 'select chave from NFEDISTRIBUICAO';
  try
    dm.IBselect.Open;
  except
    on e: exception do
    begin
      MessageDlg('Ocorreu Um Erro na Abertura da Tabela NFEDISTRIBUICAO:' + #13
        + e.Message, mtError, [mbok], 1);
      exit;
    end;
  end;

  if dm.IBselect.IsEmpty then
  begin
    dm.IBselect.Close;
    dm.IBQuery1.Close;
    dm.IBQuery1.SQL.text :=
      'update pgerais set valor = ''0'' where cod = 10000';
    dm.IBQuery1.ExecSQL;
    dm.IBQuery1.Transaction.Commit;
  end;

  dm.IBselect.Close;
  dm.IBselect.SQL.text :=
    'select cnpj, substring(cod_mun from 1 for 2) as codest from registro';
  dm.IBselect.Open;
  cnpj := StrNum(dm.IBselect.FieldByName('cnpj').AsString);
  CODestado := dm.IBselect.FieldByName('codest').AsString;

  dm.IBselect.Close;
  dm.IBselect.SQL.text := 'select valor from pgerais where cod = 10000';
  dm.IBselect.Open;
  UltNSU := '0';
  if dm.IBselect.IsEmpty = False then
    UltNSU := StrNum(dm.IBselect.FieldByName('valor').AsString);
  dm.IBselect.Close;

  funcoes.Mensagem(Application.Title, 'Aguarde, Conectando...', 15, 'Arial',
    False, 0, clBlack);
  Application.ProcessMessages;
  i := 0;

  while true do
  begin
    Inc(i);
    if i = 4 then
      break;
    Application.ProcessMessages;
    try
      ACBrNFe.DistribuicaoDFe(StrToInt(CODestado), cnpj, UltNSU, '');
      msgERRO := 'OK';
      funcoes.Mensagem(Application.Title, '', 15, '',False, 0, clBlack, true);
      break;
    except
      on e: exception do
      begin
        msgERRO := e.Message;
      end;
    end;
  end;

  if (i = 4) then
  begin
    funcoes.Mensagem(Application.Title, '', 15, '',False, 0, clBlack, true);
    MessageDlg('O Sistema Não Conseguiu Comunicar com a Sefaz, ERRO: ' + #13 +
      #13 + msgERRO, mtError, [mbok], 1);
    exit;
  end;

  sStat := IntToStr(ACBrNFe.WebServices.DistribuicaoDFe.retDistDFeInt.cStat);

  if sStat = '137' then
    sTemMais := 'N'
  else
    sTemMais := 'S';

  lista := tstringList.Create;

  dm.IBselect.Close;
  dm.IBselect.SQL.text := 'select chave from NFEDISTRIBUICAO';
  dm.IBselect.Open;

  while not dm.IBselect.Eof do
  begin
    lista.Add(dm.IBselect.FieldByName('chave').AsString + '=X');
    dm.IBselect.Next;
  end;

  fim := ACBrNFe.WebServices.DistribuicaoDFe.retDistDFeInt.docZip.count - 1;

  for i := 0 to fim do
  begin
    if ACBrNFe.WebServices.DistribuicaoDFe.retDistDFeInt.docZip.Items[i]
      .resNFe.chNFe <> '' then
    begin
      UltNSU := ACBrNFe.WebServices.DistribuicaoDFe.retDistDFeInt.docZip.
        Items[i].NSU;
      sChave := ACBrNFe.WebServices.DistribuicaoDFe.retDistDFeInt.docZip.Items
        [i].resNFe.chNFe;

      dataset.Append;
      dataset.FieldByName('nome').AsString :=
        LeftStr(ACBrNFe.WebServices.DistribuicaoDFe.retDistDFeInt.docZip.Items
        [i].resNFe.xNome, 50);
      dataset.FieldByName('CPFCNPJ').AsString :=
        (ACBrNFe.WebServices.DistribuicaoDFe.retDistDFeInt.docZip.Items[i]
        .resNFe.CNPJCPF);
      dataset.FieldByName('EMISSAO').AsDateTime :=
        (ACBrNFe.WebServices.DistribuicaoDFe.retDistDFeInt.docZip.Items[i]
        .resNFe.dhEmi);
      dataset.FieldByName('CHAVE').AsString := sChave;
      dataset.FieldByName('VALOR').AsCurrency :=
        ACBrNFe.WebServices.DistribuicaoDFe.retDistDFeInt.docZip.Items[i]
        .resNFe.vNF;
      dataset.FieldByName('NOTA').AsInteger := StrToInt(copy(sChave, 26, 9));
      dataset.FieldByName('SERIE').AsInteger := StrToInt(copy(sChave, 23, 3));
      dataset.FieldByName('IE').AsString :=
        (ACBrNFe.WebServices.DistribuicaoDFe.retDistDFeInt.docZip.Items[i]
        .resNFe.IE);

      case ACBrNFe.WebServices.DistribuicaoDFe.retDistDFeInt.docZip.Items[i]
        .resNFe.tpNF of
        tnEntrada:
          dataset.FieldByName('TIPONF').AsString := 'ENTRADA';
        tnSaida:
          dataset.FieldByName('TIPONF').AsString := 'SAIDA';
      end;

      if ACBrNFe.WebServices.DistribuicaoDFe.retDistDFeInt.docZip.Items[i]
        .resNFe.cSitNFe = snAutorizado then
      begin
        Impresso := 'A';
        dataset.FieldByName('SIT').AsString := 'AUTORIZADO';
      end
      else if ACBrNFe.WebServices.DistribuicaoDFe.retDistDFeInt.docZip.Items[i]
        .resNFe.cSitNFe = snDenegado then
      begin
        Impresso := 'D';
        dataset.FieldByName('SIT').AsString := 'DENEGADO';
      end
      else if ACBrNFe.WebServices.DistribuicaoDFe.retDistDFeInt.docZip.Items[i]
        .resNFe.cSitNFe = snCancelado then
      begin
        Impresso := 'C';
        dataset.FieldByName('SIT').AsString := 'CANCELADO';
      end;

      { dm.IBselect.Close;
        dm.IBselect.SQL.Text := 'select MANIFESTADA from NFEDISTRIBUICAO where chave = :chave';
        dm.IBselect.ParamByName('chave').AsString := sChave;
        dm.IBselect.Open;
        dataSet.FieldByName('MANI').AsString := dm.IBselect.FieldByName('MANIFESTADA').AsString;
        dm.IBselect.Close; }

      if lista.Values[sChave] = '' then
      begin
        dm.IBQuery1.Close;
        dm.IBQuery1.SQL.text :=
          'insert into NFEDISTRIBUICAO(chave, CNPJ, DATA, NOME, valor, ie, tpnf, NSU, SIT)'
          + 'values(:chave, :CNPJ, :DATA, :NOME, :valor, :ie, :tpnf, :NSU, :SIT)';
        dm.IBQuery1.ParamByName('chave').AsString := sChave;
        dm.IBQuery1.ParamByName('CNPJ').AsString :=
          dataset.FieldByName('CPFCNPJ').AsString;
        dm.IBQuery1.ParamByName('DATA').AsDate := dataset.FieldByName('EMISSAO')
          .AsDateTime;
        dm.IBQuery1.ParamByName('NOME').AsString :=
          dataset.FieldByName('nome').AsString;
        dm.IBQuery1.ParamByName('valor').AsCurrency :=
          dataset.FieldByName('VALOR').AsCurrency;
        dm.IBQuery1.ParamByName('ie').AsString :=
          dataset.FieldByName('IE').AsString;

        case ACBrNFe.WebServices.DistribuicaoDFe.retDistDFeInt.docZip.Items[i]
          .resNFe.tpNF of
          tnEntrada:
            dm.IBQuery1.ParamByName('tpnf').AsString := 'E';
          tnSaida:
            dm.IBQuery1.ParamByName('tpnf').AsString := 'S';
        end;
        dm.IBQuery1.ParamByName('NSU').AsString := UltNSU;
        dm.IBQuery1.ParamByName('SIT').AsString := Impresso;
        dm.IBQuery1.ExecSQL;
      end;

      dataset.Post;
    end;
  end;

  if sStat = '138' then
  begin
    dm.IBQuery1.Close;
    dm.IBQuery1.SQL.text :=
      'update or insert into pgerais(cod, valor) values(10000, :valor) matching(cod)';
    dm.IBQuery1.ParamByName('valor').AsString := StrNum(UltNSU);
    dm.IBQuery1.ExecSQL;

    dm.IBQuery1.Close;
    dm.IBQuery1.SQL.text :=
      'update or insert into pgerais(cod, valor) values(10001, :valor) matching(cod)';
    dm.IBQuery1.ParamByName('valor').AsString :=
      formataDataDDMMYY(form22.dataMov) + ' ' + FormatDateTime('HH:mm', now);
    dm.IBQuery1.ExecSQL;

    dm.IBQuery1.Transaction.Commit;
  end;

  if dm.IBQuery1.Transaction.InTransaction then
    dm.IBQuery1.Transaction.Commit;

  if sStat = '138' then
    ShowMessage(IntToStr(fim) + ' Consultas Realizadas e tem mais Documentos')
  else
    ShowMessage(IntToStr(fim) +
      ' Consultas Realizadas e não tem mais Documentos.');

  { form33 := TForm33.Create(self);
    form33.DataSource1.DataSet := dataSet;
    form33.ShowModal;
    form33.Free; }

  lista.Free;
  dataset.Free;
end;

procedure Tfuncoes.LimparEntregues(nota: String);
begin
  dm.IBQuery1.Close;
  dm.IBQuery1.SQL.text :=
    'update CONT_ENTREGA set ENT_AGORA = '''' where nota = :nota';
  dm.IBQuery1.ParamByName('nota').AsString := StrNum(nota);
  dm.IBQuery1.ExecSQL;
  dm.IBQuery1.Transaction.Commit;
end;

function Tfuncoes.buscaMSG_Venda(nota1: String): String;
begin
  Result := '';
  dm.IBselect.Close;
  dm.IBselect.SQL.text := 'select OBS from OBS_VENDA where nota = :nota';
  dm.IBselect.ParamByName('nota').AsInteger := StrToInt(StrNum(nota1));
  dm.IBselect.Open;

  if dm.IBselect.IsEmpty = False then
    Result := trim(dm.IBselect.FieldByName('obs').AsString);
  dm.IBselect.Close;
end;

function Tfuncoes.buscaVersaoIBPT_Site(tipo: Smallint = 1): String;
var
  th, msg: String;
  fileDownload: TFileStream;
begin
  Result := '';
  if tipo = 1 then
    msg := 'Lendo Atualizações, Aguarde...'
  else
    msg := 'Atualizando Tabela IBPT, Aguarde...';

  funcoes.Mensagem(Application.Title, msg, 12, 'Courier New', False, 0, clRed);

  try
    if tipo = 1 then
      th := buscaNomeSite + '/si2/ibptver.php'
    else
      th := buscaNomeSite + '/si2/IBPT.zip';
    dm.IBselect.Close;
    try
      IdHTTP1.Request.UserAgent :=
        'Mozilla/5.0 (Windows NT 5.1; rv:2.0b8) Gecko/20100101 Firefox/4.' +
        '0b8';
      IdHTTP1.HTTPOptions := [hoForceEncodeParams];
      if tipo <> 1 then
      begin
        try
          fileDownload := TFileStream.Create(caminhoEXE_com_barra_no_final +
            'IBPT.zip', fmCreate);
          IdHTTP1.Get(th, fileDownload);
        finally
          FreeAndNil(fileDownload);
        end;
      end
      else
        th := IdHTTP1.Get(th);
      Result := th;
      IdHTTP1.Disconnect;
    except
      on e: exception do
      begin
        if Contido('Host not found', e.Message) then
        begin
          th := buscaConfigNaPastaDoControlW('Site_Num', '1');
          GravaConfigNaPastaDoControlW('Site_Num',
            IntToStr(StrToIntDef(th, 1) + 1));
        end;
      end;
    end;
  finally
    funcoes.Mensagem(Application.Title, '', 15, '',False, 0, clBlack, true);
  end;
end;

procedure Tfuncoes.atualizaTabelaIBPT(forcar: boolean = False);
var
  versaoSite, data, ibpt: String;
  arq: tstringList;
  arquivo: TFileName;
begin
  if ACBrNFe.SSL.NumeroSerie = '' then
    exit;
  data := buscaConfigNaPastaDoControlW('VersaoIBPT', '01/01/1900');

  if forcar = False then
  begin
    if ((trunc(form22.dataMov - StrToDate(data)) < 10) or (primeiroDiaDoMes and (StrToDate(data) <> DateOf(now)))) then
      exit;
  end;

  if FileExists(ExtractFileDir(ParamStr(0)) + '\IBPT.csv') = False then
    data := '01/01/2000';

  versaoSite := buscaVersaoIBPT_Site;
  if versaoSite = '' then
  begin
    ShowMessage('Versao do WebService Não Encontrada!');
    exit;
  end;

  if length(versaoSite) > 20 then
  begin
    ShowMessage('Versao do WebService Inválida!' + #13 + 'Versão: ' +
      versaoSite);
    exit;
  end;

  if buscaVersaoIBPT_Local <> versaoSite then
  begin
    ibpt := buscaVersaoIBPT_Site(2);

    descompactaIBPT;
  end
  else
  begin
    ShowMessage('A Tabela do IBPT está atualizada:' + #13 + 'Versao Local: ' +
      buscaVersaoIBPT_Local + #13 + 'Versao Site.: ' + versaoSite);
    GravaConfigNaPastaDoControlW('VersaoIBPT', FormatDateTime('dd/mm/yyyy',
      form22.dataMov));
  end;
end;

procedure Tfuncoes.adicionaNFes();
begin
  dm.IBselect.Close;
  dm.IBselect.SQL.text := 'select * from nfe where xml is null';
  dm.IBselect.Open;

  while not dm.IBselect.Eof do
  begin
    if FileExists(caminhoEXE_com_barra_no_final + 'nfe\emit\' +
      dm.IBselect.FieldByName('chave').AsString + '-nfe.xml') then
    begin
      { dm.ACBrNFe.NotasFiscais.Clear;
        dm.ACBrNFe.NotasFiscais.LoadFromFile(caminhoEXE_com_barra_no_final + 'nfe\emit\' + dm.IBselect.FieldByName('chave').AsString + '-nfe.xml');
        dm.ACBrNFe.NotasFiscais[0].GravarStream(xml); }

      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.text := 'update nfe set xml = :xml where chave = :chave';
      dm.IBQuery1.ParamByName('xml').LoadFromFile(caminhoEXE_com_barra_no_final
        + 'nfe\emit\' + dm.IBselect.FieldByName('chave').AsString +
        '-nfe.xml', ftBlob);
      dm.IBQuery1.ParamByName('chave').AsString :=
        dm.IBselect.FieldByName('chave').AsString;
      dm.IBQuery1.ExecSQL;
    end;

    dm.IBselect.Next;
  end;

  if dm.IBQuery1.Transaction.InTransaction then
    dm.IBQuery1.Transaction.Commit;
  dm.IBselect.Close;
end;

procedure Tfuncoes.configuraMail(var mail: TACBrMail; tipo: Smallint = 0);
begin
  tipo := 1;
  if tipo = 0 then
  begin
    dm.ACBrMail1.Clear;
    dm.ACBrMail1.Host := 'smtp.gmail.com';
    dm.ACBrMail1.Username := 'controlwsistemas@gmail.com';
    dm.ACBrMail1.FromName := 'ControlW Sistemas';
    dm.ACBrMail1.From := 'controlwsistemas@gmail.com';
    dm.ACBrMail1.Password := 'controlw12345';
    dm.ACBrMail1.Port := '587';
    dm.ACBrMail1.SetSSL := False;
    dm.ACBrMail1.SetTLS := true;
  end
  else if tipo = 1 then
  begin
    dm.IBselect.Close;
    dm.IBselect.SQL.text := 'select * from email';
    dm.IBselect.Open;

    dm.ACBrMail1.Host := dm.IBselect.FieldByName('host').AsString;
    dm.ACBrMail1.Username := dm.IBselect.FieldByName('email').AsString;
    dm.ACBrMail1.FromName := dm.IBselect.FieldByName('nome').AsString;
    dm.ACBrMail1.From := dm.IBselect.FieldByName('email').AsString;
    dm.ACBrMail1.Password := dm.IBselect.FieldByName('senha').AsString;
    dm.ACBrMail1.Port := dm.IBselect.FieldByName('porta').AsString;
    dm.ACBrMail1.SetSSL := iif(dm.IBselect.FieldByName('setssl').AsString = '1',
      true, False);
    dm.ACBrMail1.SetTLS := iif(dm.IBselect.FieldByName('settls').AsString = '1',
      true, False);
    dm.IBselect.Close;
    { dm.ACBrMail1.Host := 'mx1.hostinger.com.br';
      dm.ACBrMail1.Username := 'sistemas@controlw.blog.br';
      dm.ACBrMail1.FromName := 'sistemas@controlw.blog.br';
      dm.ACBrMail1.From     := 'sistemas@controlw.blog.br';
      dm.ACBrMail1.Password := 'controlw123';
      dm.ACBrMail1.Port     := '587';
      dm.ACBrMail1.SetSSL   := false;
      dm.ACBrMail1.SetTLS   := true; }
  end;
end;

function Tfuncoes.Zip(Files: tstringList; ZipName: String): boolean;
// Compactaos arquivos
var
  i: integer;
  Zipper: TZipFile;
begin
  Zipper := TZipFile.Create();
  try
    Zipper.Open(ZipName, zmWrite);
    for i := 0 to Files.count - 1 do
    begin
      if FileExists(Files[i]) then
        Zipper.Add(Files[i]);
    end;
    Zipper.Close;
  finally
    FreeAndNil(Zipper);
  end;
  Result := true;
end;

function Tfuncoes.UnZip(ZipName: string; Destination: string): boolean;
// Descompacta no Diretorio informado
var
  UnZipper: TZipFile;
begin
  UnZipper := TZipFile.Create();
  try
    UnZipper.Open(ZipName, zmRead);
    UnZipper.ExtractAll(Destination);
    UnZipper.Close;
  finally
    FreeAndNil(UnZipper);
  end;
  Result := true;
end;

procedure Tfuncoes.restaurarbackup();
var
  op: TOpenDialog;
  arq, CAMPOS, temp, sqls: tstringList;
  i, fim, a, f1: integer;
  tabela, linha, SQL, valor, erros: String;
begin
  op := TOpenDialog.Create(self);
  if op.Execute = False then
    exit;

  arq    := tstringList.Create;
  sqls   := tstringList.Create;
  CAMPOS := tstringList.Create;
  temp   := tstringList.Create;
  i := 0;
  tabela := '';
  arq.LoadFromFile(op.fileName);
  fim := arq.count - 1;

  dm.IBQuery2.Close;
  dm.IBQuery2.SQL.text := 'delete from REGISTRO';
  dm.IBQuery2.ExecSQL;
  dm.IBQuery2.Close;
  dm.IBQuery2.SQL.text := 'delete from ACESSO';
  dm.IBQuery2.ExecSQL;
  dm.IBQuery2.Transaction.Commit;

  funcoes.informacao(1, fim, 'Restaurando Backup...', true, False, 2);
  while true do
  begin
    if i >= fim then
      break;

    linha := arq[i];
    if Contido('TABELAX', linha) then
    begin
      temp.Clear;
      LE_CAMPOS(temp, linha, '|', False);
      tabela := temp.Values['1'];
      i := i + 1;
      linha := arq[i];
    end;

    funcoes.informacao(i, fim, 'Restaurando ' + tabela + ' ...', False,
      False, 2);

    if Contido('CAMPOX', linha) then
    begin
      CAMPOS.Clear;
      linha := copy(linha, 7, length(linha));
      LE_CAMPOS(CAMPOS, linha, '|', False);
      f1 := CAMPOS.count - 1;
      i := i + 1;
      linha := arq[i];

      if Contido('TABELAX', linha) then
        i := i - 1;
    end;

    if tabela = 'GENERATOR' then
    begin
      temp.Clear;
      LE_CAMPOS(temp, linha, '|', False);

      if VerSeExisteGeneratorPeloNome(temp.Values['0']) then
      begin
        dm.IBQuery2.Close;
        dm.IBQuery2.SQL.text := 'CREATE SEQUENCE ' + temp.Values['0'];
        try
          dm.IBQuery2.ExecSQL;
          dm.IBQuery2.Transaction.Commit;
        except
        end;
      end;

      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.text := 'ALTER SEQUENCE ' + temp.Values['0'] +
        ' RESTART WITH ' + temp.Values['1'];
      sqls.Add(dm.IBQuery1.SQL.text+ ';');
      try
        dm.IBQuery1.ExecSQL;
      except
        on e: exception do
        begin
          ShowMessage('Erro: ' + e.Message + #13 + #13 + dm.IBQuery1.SQL.text);
          erros := erros + e.Message;
        end;
      end;
    end
    else
    begin
      if (tabela <> '') and (CAMPOS.count > 0) and
        ((not Contido('TABELAX', linha)) and (not Contido('CAMPOX', linha)))
      then
      begin
        if Contido(tabela,
          'CAIXA-REGISTRO-ACESSO-ITEM_VENDA-CONTASRECEBER-CONTASPAGAR') then
          SQL := 'insert into ' + tabela + '('
        else
          SQL := 'update or insert into ' + tabela + '(';

        if tabela = 'VENDA' then
          SQL := 'update or insert into ' + tabela + '(';

        for a := 0 to f1 do
        begin
          if a = f1 then
            SQL := SQL + CAMPOS.Values[IntToStr(a)]
          else
            SQL := SQL + CAMPOS.Values[IntToStr(a)] + ',';
        end;

        SQL := SQL + ') values(';

        LE_CAMPOS(temp, linha, '|', False);
        for a := 0 to f1 do
        begin
          // valor := QuotedStr(temp.Values[inttostr(a)]);
          valor := (temp.Values[IntToStr(a)]);
          valor := trocaChar(valor, ',', '.');

          if a = f1 then
            SQL := SQL + valor
          else
            SQL := SQL + valor + ',';
        end;

        SQL := SQL + ')';

        if tabela = 'VENDA' then
        begin
          SQL := SQL + ' matching(nota)';
        end;

        if ((tabela = 'ENTRADA')) then
        begin
          SQL := SQL + ' matching(nota, FORNEC)';
        end;

        if ((tabela = 'ITEM_ENTRADA')) then
        begin
          SQL := SQL + ' matching(nota, FORNEC, COD)';
        end;

        if ((tabela = 'PGERAIS')) then
        begin
          SQL := SQL + ' matching(COD)';
        end;

        if Contido(tabela, 'ACESSO-REGISTRO') then
        begin
          dm.IBQuery2.Close;
          dm.IBQuery2.SQL.text := 'delete from ' + tabela;
          dm.IBQuery2.ExecSQL;
          dm.IBQuery2.Transaction.Commit;

          //CAMPOS.Clear;
          //CAMPOS.text := SQL;
          //CAMPOS.SaveToFile(caminhoEXE_com_barra_no_final + 'sql'+tabela+'.txt');
        end;

        dm.IBQuery1.Close;
        dm.IBQuery1.SQL.text := SQL;

        sqls.Add(dm.IBQuery1.SQL.text + ';');
        try
          dm.IBQuery1.ExecSQL;
        except
          on e: exception do
          begin
            if MessageDlg('tabela=' + tabela + #13 + #13 + CAMPOS.GetText + #13
              + #13 + SQL + #13 + #13 + e.Message, mtInformation, [mbYes, mbNo],
              1) = idyes then
            begin
              CAMPOS.Clear;
              CAMPOS.text := SQL;
              CAMPOS.SaveToFile(caminhoEXE_com_barra_no_final + 'sql.txt');
              funcoes.informacao(1, fim, 'Restaurando Backup...', False, true, 2);
              CAMPOS.Free;
              temp.Free;
              arq.Free;
              exit;
            end;
          end;
        end;
      end; // if (tabela <> '') and (campos.Count > 0) and ((not Contido('TABELAX', linha)) and (not Contido('CAMPOX', linha))) then begin
    end;

    i := i + 1;
  end;

  funcoes.informacao(1, fim, 'Restaurando Backup...', False, true, 2);

  //sqls.SaveToFile(caminhoEXE_com_barra_no_final + 'sqlsBD.txt');
  sqls.Free;
  CAMPOS.Free;
  temp.Free;
  arq.Free;
  ShowMessage('Backup Recuperado Com Sucesso!');
end;

function Tfuncoes.retornaConteudoPeloTipo(const conteudo: String;
  tipo: TFieldType): String;
begin
  Result := '';
  if tipo = ftInteger then
  begin
    Result := StrNum(conteudo);
  end
  else if ((tipo = ftCurrency) or (tipo = ftBCD)) then
  begin
    Result := trocaChar(conteudo, ',', '.');
  end
  else if (tipo = ftDateTime) then
  begin
    Result := trocaChar(conteudo, ',', '.');
  end
  else
    Result := QuotedStr(conteudo);
end;

function Tfuncoes.retornaConteudoPeloTipo1(var query: TIBQuery;
  nomeCampo: string): String;
begin
  Result := '';

  if query.FieldByName(nomeCampo).DataType = ftSmallint then
  begin
    Result := StrNum(query.FieldByName(nomeCampo).AsString);
  end
  else if query.FieldByName(nomeCampo).DataType = ftInteger then
  begin
    Result := StrNum(query.FieldByName(nomeCampo).AsString);
  end
  else if (query.FieldByName(nomeCampo).DataType IN [ftCurrency, ftBCD, ftFloat])
  then
  begin
    Result := trocaChar(query.FieldByName(nomeCampo).AsString, ',', '.');
    if Result = '' then
      Result := '0';
  end
  else if (query.FieldByName(nomeCampo).DataType = ftDateTime) then
  begin
    Result := QuotedStr(FormatDateTime('mm/dd/yyyy hh:mm:ss',
      query.FieldByName(nomeCampo).AsDateTime));
  end
  else if (query.FieldByName(nomeCampo).DataType = ftDate) then
  begin
    Result := QuotedStr(FormatDateTime('mm/dd/yyyy',
      query.FieldByName(nomeCampo).AsDateTime));
  end
  else if (query.FieldByName(nomeCampo).DataType = ftTime) then
  begin
    Result := QuotedStr(FormatDateTime('hh:mm:ss', query.FieldByName(nomeCampo)
      .AsDateTime));
  end
  else
    Result := trocaChar(QuotedStr(trim(query.FieldByName(nomeCampo).AsString)),
      '|', '*');
end;

procedure Tfuncoes.fazBackupMandaPorEmail();
var
  versaoSite: String;
begin
  if dm.execucaoEmail = 1 then
    exit;

  dm.IBselect.Close;
  dm.IBselect.SQL.text := 'select max(data_backup) as data from registro';
  dm.IBselect.Open;

  if trunc(form22.dataMov - dm.IBselect.FieldByName('data').AsDateTime) < 5 then
    exit;
  dm.IBselect.Close;

  versaoSite := buscaVersaoIBPT_Site;
  if versaoSite = '' then
  begin
    // ShowMessage('Versao do WebService Não Encontrada!');
    exit;
  end;

  if length(versaoSite) > 20 then
  begin
    // ShowMessage('Versao do WebService Inválida!' + #13 + 'Versão: ' + versaoSite);
    exit;
  end;

  dm.IBQuery1.Close;
  dm.IBQuery1.SQL.text := 'update registro set data_backup = :data';
  dm.IBQuery1.ParamByName('data').AsDate := form22.dataMov;
  dm.IBQuery1.ExecSQL;
  dm.IBQuery1.Transaction.Commit;

  try
    funcoes.SincronizarExtoque2('');
  except
    on e: exception do
    begin
      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.text := 'update registro set data_backup = :data - 6';
      dm.IBQuery1.ParamByName('data').AsDate := form22.dataMov;
      dm.IBQuery1.ExecSQL;
      dm.IBQuery1.Transaction.Commit;
    end;
  end;
end;

function Tfuncoes.buscaOrigemDaNfe(): string;
begin
  Result := '';
  form33 := tform33.Create(self);
  form33.caption := 'Consulta de Formulários';
  form33.ClientDataSet1.FieldDefs.Clear;
  form33.ClientDataSet1.FieldDefs.Add('CODIGO', ftInteger);
  form33.ClientDataSet1.FieldDefs.Add('DESCRICAO', ftString, 70);
  form33.ClientDataSet1.CreateDataSet;
end;

FUNCTION Tfuncoes.IMP_CODBAR(const cod: String): boolean;
VAR
  _CB, _REF, linha, qtd, _PV, _COD, imp: String;
  LIDO, posi, ini, fim, tam, tam1: integer;
  hand, arqTXT: tstringList;
begin
  qtd := funcoes.dialogo('generico', 0, '1234567890' + #8, 0, False, '',
    'Control For Windows', 'Quantas Etiquetas Imprimir ?', '3');
  if qtd = '*' then
    exit;

  form39 := tform39.Create(self);
  funcoes.CtrlResize(TForm(form39));
  form39.ListBox1.Clear;
  form39.ListBox1.Items.Add('Individual');
  form39.ListBox1.Items.Add('Para Gondola');
  form39.ListBox1.Selected[0] := true;
  form39.Position := poScreenCenter;
  form39.BorderStyle := bsDialog;
  form39.ListBox1.Font.Size := 10;
  form39.caption := 'Configurações';
  form39.conf := 1;
  form39.ShowModal;
  form39.Free;
  if funcoes.lista1 = '*' then
    exit;
  { if lista1 = '0' then
    begin

    end
    else
    begin

    end;

  }
  dm.IBselect.Close;
  dm.IBselect.SQL.text := 'select * from produto where cod = :cod';
  dm.IBselect.ParamByName('cod').AsInteger := StrToIntDef(cod, 0);
  dm.IBselect.Open;

  { dm.produto.close;
    dm.produto.SQL.Clear;
    dm.produto.SQL.Add('select cod,nome as Descricao,p_venda as Preco,quant as estoque,refori as '+ refori1 +',deposito,unid,codbar,aplic as Aplicacao,localiza as Localizacao,igual as Equivalente from produto order by nome asc;');

    dm.produto.Open;
    dm.produto.Locate('cod', cod, []);
    funcoes.OrdenaCamposVenda(ConfParamGerais.Strings[1]);
    funcoes.FormataCampos(dm.produto,2,'ESTOQUE',3); }

  hand := tstringList.Create;
  arqTXT := tstringList.Create;

  _CB := copy(_CB, 1, 12);
  _PV := FormatCurr('#,###,###0.00', dm.IBselect.FieldByName('p_venda')
    .AsCurrency);
  _COD := dm.IBselect.FieldByName('cod').AsString;
  _REF := allTrim(dm.IBselect.FieldByName(refori1).AsString);

  if ConfParamGerais[5] = 'S' then
  begin
    _CB := dm.IBselect.FieldByName('codbar').AsString;
  end
  else
  begin
    _CB := StrNum(dm.IBselect.FieldByName('codbar').AsString);
    if _CB = '0' then
      _CB := funcoes.buscaPorCodigotornaCodigoBarrasValido(cod);
  end;

  { SET PRINTER TO TEXTO.TXT
    SET DEVICE TO PRINT
    SET PRINT ON
  }

  if not FileExists(iif(lista1 = '0', caminhoEXE_com_barra_no_final +
    'JS000041.dat', caminhoEXE_com_barra_no_final + 'JS000042.dat')) then
  begin
    ShowMessage('Arquivo: ' + iif(lista1 = '0', caminhoEXE_com_barra_no_final +
      'JS000041.dat', caminhoEXE_com_barra_no_final + 'JS000042.dat') +
      ' não foi encontrado');
    exit;
  end;

  qtd := iif(StrToCurrDef(qtd, 0) / 3 = trunc(StrToCurrDef(qtd, 0) / 3),
    CurrToStr(StrToCurrDef(qtd, 0) / 3),
    CurrToStr(trunc(StrToCurrDef(qtd, 0) / 3) + 1));

  hand.LoadFromFile(iif(lista1 = '0', caminhoEXE_com_barra_no_final +
    'JS000041.dat', caminhoEXE_com_barra_no_final + 'JS000042.dat'));
  fim := hand.count - 1;
  LIDO := 0;
  for LIDO := 0 to fim do
  begin
    linha := (hand.Strings[LIDO]);
    if (20 > ini) then
      ini := 20;

    posi := pos('PRODUTO', linha);
    ini := StrToIntDef(copy(linha, posi + 7, 2), 0);

    if Contido('PRODUTO', linha) then
    begin
      tam1 := StrToIntDef(copy(linha, pos('PRODUTO', linha) + 7, 2), 20);
      linha := troca_str(linha, copy(linha, pos('PRODUTO', linha), 9),
        copy(dm.IBselect.FieldByName('nome').AsString, 1, tam1));
    end;

    { linha := troca_str(linha, 'PRODUTO' + iif(ini <> 0, copy(linha, pos('NOME', linha) + 6,
      2), ''), copy(dm.IBselect.FieldByName('nome').AsString, 1, ini)); }

    if Contido('NOMEX', linha) then
    begin
      tam1 := StrToIntDef(copy(linha, pos('NOMEX', linha) + 5, 2), 20);
      linha := troca_str(linha, copy(linha, pos('NOMEX', linha), 7),
        copy(dm.IBselect.FieldByName('nome').AsString, tam + 1, tam1));
    end;

    if Contido('NOME', linha) then
    begin
      tam := StrToIntDef(copy(linha, pos('NOME', linha) + 4, 2), 20);
      linha := troca_str(linha, copy(linha, pos('NOME', linha), 6),
        copy(dm.IBselect.FieldByName('nome').AsString, 1, tam));
    end;

    // LINHA := TROCA_STR(LINHA,'PRODUTO', copy(dm.produto.fieldbyname('DESCRICAO').AsString, 1, 20));
    linha := troca_str(linha, 'CODIGO', dm.IBselect.FieldByName('cod')
      .AsString);
    linha := troca_str(linha, 'CODBAR', _CB);
    linha := troca_str(linha, 'PRECO', _PV);
    linha := troca_str(linha, 'REFORI', _REF);
    linha := troca_str(linha, 'XQTD', STRZERO(qtd, 4));
    linha := troca_str(linha, 'xqtd', qtd);
    linha := troca_str(linha, 'EMPRESA', form22.Pgerais.Values['empresa']);

    IF not Contido('//', linha) then
    begin
      if trim(linha) <> '' then
        arqTXT.Add(linha);
    end;
  END;

  hand.Clear;
  hand := nil;

  arqTXT.SaveToFile(caminhoEXE_com_barra_no_final + 'CODBAR.TXT');

  imp := LerConfig(form22.Pgerais.Values['imp'], 8);
  if dm.IBQuery1.Transaction.InTransaction then
    dm.IBQuery1.Transaction.Commit;

  if LerConfig(form22.Pgerais.Values['imp'], 9) = 'U' then
  begin
    // imprime.impTxtTAP(arqTXT);
    // arqTXT.SaveToFile('\\127.0.0.1\BTP');
    imprime.ImprimeLivreDireto(1, StrToInt(_COD));
    exit;
  end;

  if imp = '' then
    imp := 'LPT1';

  posi := trunc(StrToIntDef(qtd, 3) / 3);
  if (StrToCurrDef(qtd, 0) / 3) <> Int(StrToCurrDef(qtd, 0) / 3) then
    posi := posi + 1;

  // for tam1 := 1 to posi do begin
  try
    arqTXT.SaveToFile(imp);
  except
    on e: exception do
    begin
      ShowMessage('Erro: ' + e.Message);
    end;
  end;
  // end;

  dm.IBselect.Close;

  // CopyFile(Pansichar(caminhoEXE_com_barra_no_final + 'TEXTO.TXT'), 'LPT1', true);
end;

FUNCTION Tfuncoes.IMP_CODBAR1(const cod: String): boolean;
VAR
  _CB, _REF, linha, qtd, _PV, _COD, imp: String;
  LIDO, posi, ini, fim: integer;
  hand, arqTXT: tstringList;
begin
  qtd := funcoes.dialogo('generico', 0, '1234567890' + #8, 0, False, '',
    'Control For Windows', 'Quantas Etiquetas Imprimir ?', '3');
  if qtd = '*' then
    exit;

  form39 := tform39.Create(self);
  funcoes.CtrlResize(TForm(form39));
  form39.ListBox1.Clear;
  form39.ListBox1.Items.Add('Individual');
  form39.ListBox1.Items.Add('Para Gondola');
  form39.ListBox1.Selected[0] := true;
  form39.Position := poScreenCenter;
  form39.BorderStyle := bsDialog;
  form39.ListBox1.Font.Size := 10;
  form39.caption := 'Configurações';
  form39.conf := 1;
  form39.ShowModal;
  form39.Free;
  if funcoes.lista1 = '*' then
    exit;
  { if lista1 = '0' then
    begin

    end
    else
    begin

    end;

  }
  dm.IBselect.Close;
  dm.IBselect.SQL.text := 'select * from produto where cod = :cod';
  dm.IBselect.ParamByName('cod').AsInteger := StrToIntDef(cod, 0);
  dm.IBselect.Open;

  { dm.produto.close;
    dm.produto.SQL.Clear;
    dm.produto.SQL.Add('select cod,nome as Descricao,p_venda as Preco,quant as estoque,refori as '+ refori1 +',deposito,unid,codbar,aplic as Aplicacao,localiza as Localizacao,igual as Equivalente from produto order by nome asc;');

    dm.produto.Open;
    dm.produto.Locate('cod', cod, []);
    funcoes.OrdenaCamposVenda(ConfParamGerais.Strings[1]);
    funcoes.FormataCampos(dm.produto,2,'ESTOQUE',3); }

  hand := tstringList.Create;
  arqTXT := tstringList.Create;

  _CB := copy(_CB, 1, 12);
  _PV := FormatCurr('#,###,###0.00', dm.IBselect.FieldByName('p_venda')
    .AsCurrency);
  _COD := dm.IBselect.FieldByName('cod').AsString;
  _REF := allTrim(dm.IBselect.FieldByName(refori1).AsString);

  if ConfParamGerais[5] = 'S' then
  begin
    _CB := dm.IBselect.FieldByName('codbar').AsString;
  end
  else
  begin
    _CB := StrNum(dm.IBselect.FieldByName('codbar').AsString);
    if _CB = '0' then
      _CB := funcoes.buscaPorCodigotornaCodigoBarrasValido(cod);
  end;

  { SET PRINTER TO TEXTO.TXT
    SET DEVICE TO PRINT
    SET PRINT ON
  }

  if not FileExists(iif(lista1 = '0', caminhoEXE_com_barra_no_final +
    'JS000041.dat', caminhoEXE_com_barra_no_final + 'JS000042.dat')) then
  begin
    ShowMessage('Arquivo: ' + iif(lista1 = '0', caminhoEXE_com_barra_no_final +
      'JS000041.dat', caminhoEXE_com_barra_no_final + 'JS000042.dat') +
      ' não foi encontrado');
    exit;
  end;

  qtd := iif(StrToCurrDef(qtd, 0) / 3 = trunc(StrToCurrDef(qtd, 0) / 3),
    CurrToStr(StrToCurrDef(qtd, 0) / 3),
    CurrToStr(trunc(StrToCurrDef(qtd, 0) / 3) + 1));

  hand.LoadFromFile(iif(lista1 = '0', caminhoEXE_com_barra_no_final +
    'JS000041.dat', caminhoEXE_com_barra_no_final + 'JS000042.dat'));
  fim := hand.count - 1;
  LIDO := 0;
  for LIDO := 0 to fim do
  begin
    linha := hand.Strings[LIDO];
    IF length(allTrim(linha)) > 0 then
    begin
      if (20 > ini) then
        ini := 20;
      posi := pos('PRODUTO', linha);
      ini := StrToIntDef(copy(linha, posi + 7, 2), 0);
      linha := troca_str(linha, 'PRODUTO' + iif(ini <> 0, copy(linha, posi + 7,
        2), ''), copy(dm.IBselect.FieldByName('nome').AsString, 1, ini));
      // LINHA := TROCA_STR(LINHA,'PRODUTO', copy(dm.produto.fieldbyname('DESCRICAO').AsString, 1, 20));
      linha := troca_str(linha, 'CODIGO', dm.IBselect.FieldByName('cod')
        .AsString);
      linha := troca_str(linha, 'CODBAR', _CB);
      linha := troca_str(linha, 'PRECO', _PV);
      linha := troca_str(linha, 'REFORI', _REF);
      linha := troca_str(linha, 'XQTD', STRZERO(qtd, 4));
      linha := troca_str(linha, 'xqtd', qtd);
      IF not Contido('//', linha) then
        arqTXT.Add(linha);
    END;
  end;
  hand.Clear;
  hand := nil;

  imp := LerConfig(form22.Pgerais.Values['imp'], 8);
  if dm.IBQuery1.Transaction.Active then
    dm.IBQuery1.Transaction.Commit;

  if LerConfig(form22.Pgerais.Values['imp'], 9) = 'U' then
  begin
    // imprime.impTxtTAP(arqTXT);
    // arqTXT.SaveToFile('\\127.0.0.1\BTP');
    imprime.ImprimeLivreDireto(1, StrToInt(_COD));
    exit;
  end;

  if imp = '' then
    imp := 'LPT1';

  arqTXT.SaveToFile(caminhoEXE_com_barra_no_final + 'CODBAR1.TXT');
  arqTXT.SaveToFile(imp);

  dm.IBselect.Close;

  // CopyFile(Pansichar(caminhoEXE_com_barra_no_final + 'TEXTO.TXT'), 'LPT1', true);
end;

procedure Tfuncoes.descompactaIBPT;
var
  arquivo: TFileName;
begin
  if FileExists(caminhoEXE_com_barra_no_final + 'IBPT.zip') then
  begin
    TerminarProcesso('DavNfce.exe');
    arquivo := caminhoEXE_com_barra_no_final + 'IBPT.zip';
    UnZip(caminhoEXE_com_barra_no_final + 'IBPT.zip',
      caminhoEXE_com_barra_no_final);
    excluiAqruivo(caminhoEXE_com_barra_no_final + 'IBPT.zip');
    GravaConfigNaPastaDoControlW('VersaoIBPT', FormatDateTime('dd/mm/yyyy',
      form22.dataMov));
  end;
end;

procedure Tfuncoes.enviaXMLsEmail;
var
  ini, fim, email, arquivs: String;
  lista: tstringList;
  i: integer;
  mbody: TMemo;
begin
  lista := tstringList.Create;
  ini := '';
  fim := '';

  if form22.dataMov <= StrToDate('01/01/2000') then
    form22.dataMov := now;

  ini := funcoes.dialogo('data', 0, '', 2, true, '', Application.Title,
    'Qual a Data Inicial?',
    formataDataDDMMYY(StartOfTheMonth(IncMonth(now, -1))));
  if ini = '*' then
    exit;

  fim := funcoes.dialogo('data', 0, '', 2, true, '', Application.Title,
    'Qual a Data Final?', formataDataDDMMYY(endOfTheMonth(StrToDate(ini))));
  if fim = '*' then
    exit;

  if funcoes.verificaNFe(ini, fim, true) = False then
  begin
    exit;
  end;

  if funcoes.verificaNFCe(ini, fim, true) = False then
  begin
    exit;
  end;

  dm.IBselect.Close;
  dm.IBselect.SQL.text := 'select email from SPEDCONTADOR where cod = 1';
  dm.IBselect.Open;

  email := LowerCase(dm.IBselect.FieldByName('email').AsString);

  email := dialogo('normal', 500, '', 500, true, '', Application.Title,
    'Qual o Email do Destinatário ?', email);
  if email = '*' then
    exit;

  arquivs := funcoes.exportaNFCeEmitidas(true, ini, fim);

  NfeVenda := tnfevenda.Create(self);
  arquivs := arquivs + NfeVenda.ExportarNotasEmitidas1('', true, ini, fim);
  NfeVenda.Free;

  configuraMail(dm.ACBrMail1);

  email := LowerCase(email);
  dm.ACBrMail1.FromName := email;

  LE_CAMPOS(lista, arquivs, '|', False);

  for i := 0 to lista.count - 1 do
  begin
    if trim(lista.Values[IntToStr(i)]) <> '' then
    begin
      if FileExists(trim(lista.Values[IntToStr(i)])) then
      begin
        dm.ACBrMail1.AddAttachment(trim(lista.Values[IntToStr(i)]),
          'Anexo ' + IntToStr(i + 1));
      end;
    end;
  end;

  dm.IBselect.Close;
  dm.IBselect.SQL.text := 'select nome, cnpj from registro';
  dm.IBselect.Open;

  texto := 'XMLs de Notas Emitidas no periodo de ' + FormatDateTime('mm-yyyy',
    StrToDate(ini)) + ' da Empresa ' + dm.IBselect.FieldByName('nome').AsString
    + ' ' + dm.IBselect.FieldByName('cnpj').AsString;

  mbody := TMemo.Create(self);
  mbody.Parent := self;
  mbody.text := texto;

  dm.ACBrMail1.IsHTML := true;
  dm.ACBrMail1.Body.Assign(mbody.Lines);
  dm.ACBrMail1.Body.text := texto;

  dm.ACBrMail1.FromName := 'ControlW Sistemas';
  dm.ACBrMail1.Subject := 'XMLs ' + FormatDateTime('mm-yyyy', StrToDate(ini)) +
    ' ' + dm.IBselect.FieldByName('nome').AsString;
  dm.ACBrMail1.AddAddress(email, 'ControlW');
  dm.ACBrMail1.AddAddress('controlwsistemas@gmail.com', 'ControlW');
  dm.IBselect.Close;

  dm.ACBrMail1.send(true);

  // funcoes.mensagemEnviandoNFCE('Aguarde, Enviando EMAIL...', true, false);
  while true do
  begin
    Application.ProcessMessages;
    if dm.execucaoEmail <> 1 then
    begin
      break;
    end;

    sleep(1000);
  end;

  // funcoes.mensagemEnviandoNFCE('Aguarde, Enviando EMAIL...', false, true);
end;

procedure Tfuncoes.arrumaDataRegistroNFCe(dialog: boolean = true);
var
  chave: String;
  dia, mes, ano: Word;
  cont: integer;
  data: TDateTime;
begin
  dm.IBselect.Close;
  dm.IBselect.SQL.text := 'select * from nfce where (data < ''01.01.1900'') or'
    + ' (data is null) or (substring(chave from 3 for 4) <> ' +
    'right(extract(year from data), 2)||lpad(extract(month from data), 2, ''0''))';
  dm.IBselect.Open;

  if dm.IBselect.IsEmpty then
  begin
    if dialog then
      ShowMessage('NFCes Verificadas: 0');
    dm.IBselect.Close;
    exit;
  end;
  cont := 0;
  data := StrToDate('01/01/1900');

  while not dm.IBselect.Eof do
  begin
    chave := dm.IBselect.FieldByName('chave').AsString;
    if LeftStr(chave, 3) = 'NFe' then
      chave := copy(chave, 4, length(chave));

    cont := cont + 1;
    if chave <> '' then
    begin
      dia := 1;
      ano := YearOf(now);

      if copy(chave, 3, 2) <> RightStr(IntToStr(ano), 2) then
      begin
        ano := StrToIntDef('20' + copy(chave, 3, 2), ano);
      end;

      mes := StrToInt(copy(chave, 5, 2));
      data := EncodeDate(ano, mes, dia);

      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.text :=
        'update nfce set data = :data where (chave = :chave)';
      dm.IBQuery1.ParamByName('data').AsDate := data;
      dm.IBQuery1.ParamByName('chave').AsString :=
        dm.IBselect.FieldByName('chave').AsString;
      dm.IBQuery1.ExecSQL;
    end;

    dm.IBselect.Next;
  end;

  if dialog then
    ShowMessage('NFCes Verificadas: ' + IntToStr(cont));
  if dm.IBQuery1.Transaction.InTransaction then
    dm.IBQuery1.Transaction.Commit;
end;

procedure Tfuncoes.enviarSPED_Email;
var
  email, mes, ano: String;
  lista1: TStrings;
  list1: tstringList;
  mbody: TMemo;
begin
  lista1 := tstringList.Create;
  lista1.Add('2007');
  lista1.Add('2008');
  lista1.Add('2009');
  lista1.Add('2010');
  lista1.Add('2011');
  lista1.Add('2012');
  lista1.Add('2013');
  lista1.Add('2014');
  lista1.Add('2015');
  lista1.Add('2016');
  lista1.Add('2017');
  lista1.Add('2018');
  lista1.Add('2019');
  lista1.Add('2020');
  lista1.Add('2021');
  lista1.Add('2022');

  ano := funcoes.showListBox('ControlW', 'Informe o Ano:', lista1,
    FormatDateTime('yyyy', IncMonth(form22.dataMov, -1)));
  if ano = '' then
    exit;

  lista1.Add('01');
  lista1.Add('02');
  lista1.Add('03');
  lista1.Add('04');
  lista1.Add('05');
  lista1.Add('06');
  lista1.Add('07');
  lista1.Add('08');
  lista1.Add('09');
  lista1.Add('10');
  lista1.Add('11');
  lista1.Add('12');

  mes := funcoes.showListBox('ControlW', 'Informe o Mês:', lista1,
    FormatDateTime('mm', IncMonth(form22.dataMov, -1)));
  if mes = '' then
    exit;

  lista1.Free;

  ano := RightStr(ano, 2);
  if FileExists(caminhoEXE_com_barra_no_final + 'SPED\SPED' + mes + ano +
    '.txt') = False then
  begin
    ShowMessage('Arquivo Não Encontrado!' + #13 + caminhoEXE_com_barra_no_final
      + 'SPED\SPED' + mes + ano + '.txt');
  end;

  dm.IBselect.Close;
  dm.IBselect.SQL.text := 'select email from SPEDCONTADOR where cod = 1';
  dm.IBselect.Open;

  email := LowerCase(dm.IBselect.FieldByName('email').AsString);

  email := dialogo('normal', 500, '', 500, true, '', Application.Title,
    'Qual o Email do Destinatário ?', email);
  if email = '*' then
    exit;

  configuraMail(dm.ACBrMail1);

  email := LowerCase(email);
  // dm.ACBrMail1.FromName := email;

  list1 := tstringList.Create;
  if FileExists(caminhoEXE_com_barra_no_final + 'SPED\SPED' + mes + ano + '.txt')
  then
  begin
    list1.Add(caminhoEXE_com_barra_no_final + 'SPED\SPED' + mes + ano + '.txt');
  end;

  if FileExists(caminhoEXE_com_barra_no_final + 'SPED\SPIS' + mes + ano + '.txt')
  then
  begin
    list1.Add(caminhoEXE_com_barra_no_final + 'SPED\SPIS' + mes + ano + '.txt');
  end;

  Zip(list1, caminhoEXE_com_barra_no_final + 'SPED\SPED' + mes + ano + '.zip');
  dm.ACBrMail1.AddAttachment(caminhoEXE_com_barra_no_final + 'SPED\SPED' + mes +
    ano + '.zip', 'SPED' + mes + ano + '.zip');

  dm.IBselect.Close;
  dm.IBselect.SQL.text := 'select nome, cnpj from registro';
  dm.IBselect.Open;

  texto := 'SPED FISCAL  ' + mes + '/20' + ano + ' da Empresa ' +
    dm.IBselect.FieldByName('nome').AsString + ' ' + dm.IBselect.FieldByName
    ('cnpj').AsString;

  mbody := TMemo.Create(self);
  mbody.Parent := self;
  mbody.text := texto;
  dm.ACBrMail1.IsHTML := true;
  dm.ACBrMail1.Body.Assign(mbody.Lines);
  dm.ACBrMail1.Body.text := texto;

  dm.ACBrMail1.FromName := 'ControlW Sistemas';

  // ShowMessage(dm.ACBrMail1.FromName + #13 +
  // dm.ACBrMail1.From);
  dm.ACBrMail1.Subject := 'SPED FISCAL  ' + mes + '/20' + ano + ' ' +
    dm.IBselect.FieldByName('nome').AsString;
  dm.ACBrMail1.AddAddress(email, 'ControlW');
  dm.ACBrMail1.AddAddress('controlwsistemas@gmail.com', 'ControlW');
  // dm.ACBrMail1.AddAddress(email, 'ControlW');
  dm.IBselect.Close;

  dm.ACBrMail1.send(true);

  // funcoes.mensagemEnviandoNFCE('Aguarde, Enviando EMAIL...', true, false);
  while true do
  begin
    Application.ProcessMessages;
    if dm.execucaoEmail <> 1 then
    begin
      break;
    end;

    sleep(1000);
  end;

  // DeleteFile(caminhoEXE_com_barra_no_final + 'SPED\SPED' + mes + ano + '.zip');
  // funcoes.mensagemEnviandoNFCE('Aguarde, Enviando EMAIL...', false, true);
end;

function Tfuncoes.showListBox(caption, label1: string; lista: TStrings;
  default: String): string;
var
  s: Array [0 .. 255] of Char;
  i: integer;
begin
  Result := '';
  form69 := tform69.Create(self);
  form69.caption := caption;
  form69.label1.caption := label1;
  form69.ListBox1.Items := lista;
  form69.ListBox1.AutoComplete := true;

  if default <> '' then
  begin
    for i := 0 to form69.ListBox1.Items.count - 1 do
    begin
      if form69.ListBox1.Items[i] = default then
      begin
        form69.ListBox1.ItemIndex := i;
        break;
      end;
    end;
  end;

  form69.ShowModal;
  Result := form69.ListBox1.Items[form69.ListBox1.ItemIndex];
  form69.Free;
end;

procedure Tfuncoes.manutencaoNFCe();
var
  dini, dfim, tipo: string;
begin
  dini := dialogo('data', 0, '', 2, true, '', Application.Title,
    'Confirme a Data Inicial:', FormatDateTime('dd/mm/yy',
    StartOfTheMonth(IncMonth(form22.dataMov, -1))));
  if dini = '*' then
    exit;

  dfim := FormatDateTime('dd/mm/yy', endOfTheMonth(StrToDateTime(dini)));
  dfim := dialogo('data', 0, '', 2, true, '', Application.Title,
    'Confirme a Data Final:', dfim);
  if dfim = '*' then
    exit;

  tipo := funcoes.dialogo('generico', 50, '123', 50, true, 'S',
    Application.Title,
    'Qual o tipo ? (1-Não Enviadas 2-Enviadas 3-Todos)', '1');
  if tipo = '*' then
    exit;

  if tipo = '1' then
    tipo := '(adic = ''OFF'') and '
  else if tipo = '2' then
    tipo := '(adic = '''') and '
  else
    tipo := '';

  dm.IBselect.Close;
  dm.IBselect.SQL.text := 'select * from nfce where ' + tipo +
    ' data >= :ini and data <= :fim';
  dm.IBselect.ParamByName('ini').AsDate := StrToDate(dini);
  dm.IBselect.ParamByName('fim').AsDate := StrToDate(dfim);
  dm.IBselect.Open;

  form33 := tform33.Create(self);
  form33.DBGrid1.DataSource := dm.ds1;
  form33.campolocalizaca := 'nfceX';
  form33.ShowModal;
  form33.Free;
end;

procedure Tfuncoes.InutilizarNFCE(nnf: String = '');
var
  Justificativa, numIni, numFim, _ser: String;
begin
  numIni := nnf;
  numIni := funcoes.dialogo('not', 100, '1234567890' + #8 + #32, 100, true, '',
    Application.Title, 'Qual a Numeração Inicial ?', numIni);
  if numIni = '*' then
    exit;

  numFim := nnf;
  numFim := funcoes.dialogo('not', 100, '1234567890' + #8 + #32, 100, true, '',
    Application.Title, 'Qual a Numeração Final ?', numFim);
  if numFim = '*' then
    exit;

  _ser := funcoes.dialogo('not', 0, '1234567890' + #8 + #32, 50, true, '',
    Application.Title, 'Qual a Série ?', getSerieNFCe);
  if _ser = '*' then
    exit;

  Justificativa := '';

  while length(trim(Justificativa)) < 15 do
  begin
    Justificativa := dialogo('normal', 0, '', 150, true, '', Application.Title,
      'Qual a Justificativa?', Justificativa);
    if Justificativa = '*' then
      break;

    if length(trim(Justificativa)) < 15 then
      ShowMessage('Justificativa Deve conter mais do que  14 caracteres');
  end;

  if Justificativa = '*' then
    exit;

  funcoes.Mensagem(Application.Title, 'Aguarde...', 15, 'Courier New', False,
    2, clRed);
  Application.ProcessMessages;

  try
    inutilizacaoNFCE(StrToInt(numIni), StrToInt(numFim), 65, Justificativa,
      StrToInt(_ser));
  except
    on e: exception do
    begin
      ShowMessage(e.Message);
      funcoes.Mensagem(Application.Title, '', 15, '',False, 0, clBlack, true);
      exit;
    end;
  end;
  funcoes.Mensagem(Application.Title, '', 15, '',False, 0, clBlack, true);
end;

procedure Tfuncoes.enviarEmail();
begin

end;

procedure Tfuncoes.duplicarRichedit(vezes: Smallint);
var
  texto: String;
  ini, LinhasPag, cont, acc: integer;
const
  avancoPag: Char = #12;
begin
  if vezes = 1 then
    exit;

  LinhasPag := 62;
  texto := form19.RichEdit1.text;
  cont := form19.RichEdit1.Lines.count;
  acc := 0;
  ini := 1;

  if form22.Pgerais.Values['nota'] = 'X' then
  begin
    while true do
    begin
      acc := acc + cont;
      ini := ini + 1;
      if acc + cont > LinhasPag then
      begin
        form19.RichEdit1.text := form19.RichEdit1.text + avancoPag +
          CRLF + texto;
        acc := 0;
      end
      else
        form19.RichEdit1.text := form19.RichEdit1.text + CRLF + texto;

      if ini = vezes then
        break;
    end;
    exit;
  end;

  for ini := 1 to vezes - 1 do
  begin
    form19.RichEdit1.text := form19.RichEdit1.text + CRLF + texto;
  end;
end;

function Tfuncoes.buscaNomeConfigDat(): string;
begiN
  Result := UpperCase(ExtractFileName(ParamStr(0)));
  Result := copy(Result, 1, length(Result) - 4);
  if Result <> 'CONTROLW' then
  begin
    Result := 'CONFIG-' + Result + '.DAT';
    if not FileExists(caminhoEXE_com_barra_no_final + Result) then
    begin
      CopyFile(PChar(caminhoEXE_com_barra_no_final + 'CONFIG.DAT'),
        PChar(caminhoEXE_com_barra_no_final + Result), true);
    end;
  end
  else
    Result := 'CONFIG.DAT';
end;

function Tfuncoes.buscaDescontoProduto(const cod: integer): currency;
begin
  Result := 0;
  dm.IBQuery1.Close;
  dm.IBQuery1.SQL.text := 'select desconto from produto where cod = ' +
    IntToStr(cod);
  dm.IBQuery1.Open;

  if dm.IBQuery1.IsEmpty then
    exit;
  Result := dm.IBQuery1.FieldByName('desconto').AsCurrency;
end;

function Tfuncoes.nomeExec(): String;
begin
  Result := '';
  Result := UpperCase(ExtractFileName(ParamStr(0)));
  Result := copy(Result, 1, length(Result) - 4);
end;

function Tfuncoes.Ret_Numero(Key: Char; texto: string;
  EhDecimal: boolean = False): Char;
begin
  if not EhDecimal then
  begin
    { Chr(8) = Back Space }
    if not(Key in ['0' .. '9', Chr(8)]) then
      Key := #0
  end
  else
  begin
    if not(Key in ['0' .. '9', Chr(8)]) then
      Key := #0;
  end;

  Result := Key;
end;

procedure Tfuncoes.AutoSizeDBGrid(const xDBGrid: TDBGrid);
var
  i, TotalWidht, VarWidth, QtdTotalColuna: integer;
  xColumn: TColumn;
begin
  // Largura total de todas as colunas antes de redimensionar
  TotalWidht := 0;
  // Como dividir todo o espaço extra na grade
  VarWidth := 0;
  // Quantas colunas devem ser auto-redimensionamento
  QtdTotalColuna := 0;

  for i := 0 to -1 + xDBGrid.Columns.count do
  begin
    TotalWidht := TotalWidht + xDBGrid.Columns[i].Width;
    if xDBGrid.Columns[i].Field.Tag <> 0 then
      Inc(QtdTotalColuna);
  end;

  // Adiciona 1px para a linha de separador de coluna
  if dgColLines in xDBGrid.Options then
    TotalWidht := TotalWidht + xDBGrid.Columns.count;

  // Adiciona a largura da coluna indicadora
  if dgIndicator in xDBGrid.Options then
    TotalWidht := TotalWidht + IndicatorWidth;

  // width vale "Left"
  VarWidth := xDBGrid.ClientWidth - TotalWidht;

  // Da mesma forma distribuir VarWidth para todas as colunas auto-resizable
  if QtdTotalColuna > 0 then
    VarWidth := VarWidth div QtdTotalColuna;

  for i := 0 to -1 + xDBGrid.Columns.count do
  begin
    xColumn := xDBGrid.Columns[i];
    if xColumn.Field.Tag <> 0 then
    begin
      xColumn.Width := xColumn.Width + VarWidth;
      if xColumn.Width < xColumn.Field.Tag then
        xColumn.Width := xColumn.Field.Tag;
    end;
  end;
end;

function Tfuncoes.buscaConfigEmail(): String;
var
  th, msg, cod: String;
  fileDownload: TFileStream;
  arq: tstringList;
begin
  Result := '';
  msg := 'Buscando dados de Email, Aguarde...';

  //funcoes.Mensagem(Application.Title, msg, 12, 'Courier New', False, 0, clRed);

  try
    th := buscaNomeSite + '/si2/email.php';
    dm.IBselect.Close;
    try
      IdHTTP1.Request.UserAgent :=
        'Mozilla/5.0 (Windows NT 5.1; rv:2.0b8) Gecko/20100101 Firefox/4.' +
        '0b8';
      IdHTTP1.HTTPOptions := [hoForceEncodeParams];
      th := IdHTTP1.Get(th);
      Result := th;
      IdHTTP1.Disconnect;
    except
      on e: exception do
      begin
        //funcoes.Mensagem(Application.Title, '', 15, '',False, 0, clBlack, true);
        if Contido('Host not found', e.Message) then
        begin
          th := buscaConfigNaPastaDoControlW('Site_Num', '1');
          GravaConfigNaPastaDoControlW('Site_Num',
            IntToStr(StrToIntDef(th, 1) + 1));
        end;
        exit;
      end;
    end;
  finally
    //funcoes.Mensagem(Application.Title, '', 15, '',False, 0, clBlack, true);
  end;

  th := DeletaChar('$', th);
  arq := tstringList.Create;

  LE_CAMPOS(arq, th, '|', False);

  dm.IBselect.Close;
  dm.IBselect.SQL.text := 'select * from email';
  dm.IBselect.Open;

  cod := dm.IBselect.FieldByName('cod').AsString;

  if ((cod <> arq.Values['0']) and (trim(arq.Values['0']) <> '') and (Length(trim(arq.Values['1'])) > 10)) then
  begin
    dm.IBQuery1.Close;
    dm.IBQuery1.SQL.text :=
      'update email set cod = :cod, email = :email, senha = :senha,' +
      'porta = :porta, nome = :nome, setssl = :setssl, settls = :settls, host = :host';
    dm.IBQuery1.ParamByName('cod').AsString := arq.Values['0'];
    dm.IBQuery1.ParamByName('email').AsString := arq.Values['1'];
    dm.IBQuery1.ParamByName('senha').AsString := arq.Values['2'];
    dm.IBQuery1.ParamByName('porta').AsString := arq.Values['3'];
    dm.IBQuery1.ParamByName('nome').AsString := arq.Values['4'];
    dm.IBQuery1.ParamByName('setssl').AsString := arq.Values['5'];
    dm.IBQuery1.ParamByName('settls').AsString := arq.Values['6'];
    dm.IBQuery1.ParamByName('host').AsString := arq.Values['7'];
    try
      dm.IBQuery1.ExecSQL;
      dm.IBQuery1.Transaction.Commit;
    except
      on e: exception do
      begin
        ShowMessage('Ocorreu um Erro na atualização do Email: ' + e.Message);
        arq.Free;
        exit;
      end;
    end;

    //funcoes.Mensagem(Application.Title, '', 15, '',False, 0, clBlack, true);
  end
  else
  begin
    // ShowMessage('Versao do Email Já está Atualizada!' + #13 + #13 + arq.GetText);
  end;
end;


procedure Tfuncoes.verificaregistrosDuplicadosCaixa();
var
  dini, dfim, acc, codigos : String;
begin
  dini := funcoes.dialogo('data', 0, '', 2, true, '', Application.Title,
    'Qual a Data Inicial de Movimento?', '');
  if dini = '*' then
    exit;

  dfim := funcoes.dialogo('data', 0, '', 2, true, '', Application.Title,
    'Qual a Data Final de Movimento?', '');
  if dfim = '*' then
    exit;

  dm.IBselect.Close;
  dm.IBselect.SQL.Text := 'select codmov,(data||vencimento||historico||entrada) as valor from caixa where entrada > 0 and cast(data as date) >= :ini and' +
  ' cast(data as date) <= :fim';
  dm.IBselect.ParamByName('ini').AsDate := StrToDate(dini);
  dm.IBselect.ParamByName('ini').AsDate := StrToDate(dfim);
  dm.IBselect.Open;

  acc     := '';
  codigos := '-';

  while not dm.IBselect.Eof do begin
    if Contido(dm.IBselect.FieldByName('valor').AsString, acc) = false then begin
      acc := acc + dm.IBselect.FieldByName('valor').AsString;
    end
    else begin
      codigos := codigos + dm.IBselect.FieldByName('codmov').AsString + '-';
    end;


    dm.IBselect.Next;
  end;

  gravaERRO_LOG1('','cod. ' +codigos, '');
  ShowMessage('acabou');
end;

function Tfuncoes.buscaAliqICMSxml(cst : String; icmsosn : String) : string;
begin
  Result := buscaAliquotaPadraoParamGerais;
  //IF      cst = '41' then Result := '11'

  IF cst = '40' then Result := '12'
  else IF cst = '60' then Result := '10'
  else IF cst = '10' then Result := '10'
  else IF cst = '30' then Result := '10';
end;

function Tfuncoes.buscaAliqPISxml(cst : String; icmsosn : String) : string;
begin
  Result := '';
  IF      cst = '04' then Result := 'M'
  else IF cst = '06' then Result := 'R';
  //else IF cst = '07' then Result := 'M';
end;


procedure Tfuncoes.comparaProdutosComAFicha();
var
  lista, estoque: TItensAcumProd;
  cod, tot  : integer;
  qtd, dep : currency;
begin
  cod := 0;
  lista := TItensAcumProd.Create;
  LE_ESTOQUE(False, False, lista, cod);

  dm.IBselect.Close;
  dm.IBselect.SQL.Text := 'select cod, quant, deposito from produto';
  dm.IBselect.Open;
  tot := 0;

  form19.RichEdit1.Clear;

  addRelatorioForm19(CompletaOuRepete('', '', '-', 35) + CRLF);
  addRelatorioForm19('CODIGO   DEP ESTOQUR-DEP FICHA    QTD EST.-QTD FICHA'+ CRLF);
  addRelatorioForm19(CompletaOuRepete('', '', '-', 35) + CRLF);

  while not dm.IBselect.Eof do begin
    cod := lista.Find(dm.IBselect.FieldByName('cod').AsInteger);

    if cod = -1 then begin
      qtd  := 0;
      dep  := 0;
    end
    else begin
      qtd := lista[cod].quant;
      dep := lista[cod].dep;
    end;

      tot := tot + 1;
      if ((dm.IBselect.FieldByName('deposito').AsCurrency <> dep) or (dm.IBselect.FieldByName('quant').AsCurrency <> qtd)) then begin
        addRelatorioForm19(IntToStr(cod)+'='+CompletaOuRepete(dm.IBselect.FieldByName('cod').AsString, '', ' ', 10) + ' '  + CompletaOuRepete(CurrToStr(dep) + '='+ CurrToStr(dm.IBselect.FieldByName('deposito').AsCurrency), '', ' ', 20)+
        ' ' + CurrToStr(qtd) + '='+ CurrToStr(dm.IBselect.FieldByName('quant').AsCurrency) + CRLF);
      end
      else begin
        //addRelatorioForm19(CompletaOuRepete(dm.IBselect.FieldByName('cod').AsString, '', ' ', 10) + ' '  + CompletaOuRepete(CurrToStr(lista[cod].dep) + '='+ CurrToStr(dm.IBselect.FieldByName('deposito').AsCurrency), '', ' ', 20)+
       // ' ' + CurrToStr(lista[cod].quant) + '='+ CurrToStr(dm.IBselect.FieldByName('quant').AsCurrency) + CRLF);
      end;

    dm.IBselect.Next;
  end;

  addRelatorioForm19(CompletaOuRepete('', '', '-', 35) + CRLF);
  lista.Free;
  form19.ShowModal;
end;


function Tfuncoes.buscaAliquotaPadraoParamGerais() : String;
begin
  Result := IntToStr(StrToIntDef(ConfParamGerais[22], 2));
  if Result = '0' then begin
    Result := '2';
  end;
end;

procedure Tfuncoes.verificaLancamentosDuplicadosCaixa(ini, fim : String);
var
  acc, tmp : String;
begin
  dm.IBselect.Close;
  dm.IBselect.SQL.Text := 'select * from caixa where cast(data as date ) >= :ini and cast(data as date ) <= :fim';
  dm.IBselect.ParamByName('ini').AsDate := StrToDate(ini);
  dm.IBselect.ParamByName('fim').AsDate := StrToDate(fim);
  dm.IBselect.Open;
  acc := '';

  while not dm.IBselect.Eof do begin
    tmp := dm.IBselect.FieldByName('documento').AsString + dm.IBselect.FieldByName('vencimento').AsString + dm.IBselect.FieldByName('historico').AsString + dm.IBselect.FieldByName('entrada').AsString +
    dm.IBselect.FieldByName('CODENTRADASAIDA').AsString;

    if not Contido(tmp, acc) then acc := acc + tmp
    else begin
      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Text := 'delete from caixa where codmov = :codmov';
      dm.IBQuery1.ParamByName('codmov').AsString := dm.IBselect.FieldByName('codmov').AsString;
      dm.IBQuery1.ExecSQL;
    end;

    dm.IBselect.Next;
  end;


  dm.IBselect.Close;
  dm.IBselect.SQL.Text := 'select * from caixa where tipo = '''' and vencimento = ''01.01.1900'' and documento > 0';
  dm.IBselect.Open;

  if dm.IBselect.IsEmpty = false then begin
    dm.IBQuery1.Close;
    dm.IBQuery1.SQL.Text := 'update caixa set tipo = ''E'' where tipo = '''' and vencimento = ''01.01.1900'' and documento > 0';
    dm.IBQuery1.ExecSQL;
  end;

  if dm.IBQuery1.Transaction.InTransaction then dm.IBQuery1.Transaction.Commit;
  acc := '';
end;

procedure Tfuncoes.atualizaRecebido(recebido : currency; nota : integer);
begin
  dm.IBQuery1.Close;
  dm.IBQuery1.SQL.Text := 'update venda set recebido = :recebido where nota = :nota';
  dm.IBQuery1.ParamByName('recebido').AsCurrency := recebido;
  dm.IBQuery1.ParamByName('nota').AsInteger      := nota;
  try
    dm.IBQuery1.ExecSQL;
    dm.IBQuery1.Transaction.Commit;
  except
    on e:exception do begin
      MessageDlg('erro26068: ' + IntToStr(nota), mtError, [mbOK], 1);
    end;
  end;
end;

function Tfuncoes.CompletaString(parcial : string) : string;
var ini : integer; atual, ret,acc: string;
begin
   atual := FormatDateTime('dd/mm/yyyy', form22.datamov);
   ret := '';
   acc := '';

 if Length(Trim(parcial))<>10 then
  begin
   if (Length(Trim(parcial))>7) and (Length(parcial)<=10) and (parcial<>'  /  /    ') then
    begin
     ret := copy(parcial,PosFinal('/',parcial)+1,length(parcial));
     Delete(parcial,length(parcial)-3,length(parcial));
    //parcial := parcial + copy(atual,PosFinal('/',atual)+1,PosFinal('/',atual)+3);
     acc := copy(atual,PosFinal('/',atual)+1,PosFinal('/',atual)+3);
     acc := acc[1]+ acc[2];
     parcial := parcial +acc+ ret;
     ret := parcial;
    end;

  for ini := 1 to length(atual) do
   begin
     if parcial[ini] = ' ' then
       ret := ret + copy(atual, ini, 1)
     else
       ret := ret + copy(parcial, ini, 1);
   end;
   result := ret;
 end
else result := parcial;

end;

procedure Tfuncoes.adicionaNFCeNaoEncontrada(num, ser : String);
var
  tmp : String;
  arq : TStringList;
begin
  tmp := achaXML_NFCePeloNumero(num, ser);
  if tmp = '' then begin
    ShowMessage('NFCe Não Encontrada!');
    exit;
  end;

  arq := TStringList.Create;
  arq.LoadFromFile(tmp);

  dm.IBQuery1.Close;
  dm.IBQuery1.SQL.Text := 'insert into nfce(chave,nota, data, adic) values(:chave, :nota, :data, :adic)';
  dm.IBQuery1.ParamByName('chave').AsString := copy(ExtractFileName(tmp), 1, 44);
  dm.IBQuery1.ParamByName('nota').AsString  := copy(dm.IBQuery1.ParamByName('chave').AsString, 37, 7);
  dm.IBQuery1.ParamByName('data').AsDate    := StrToDate(dataInglesToBrasil(leftstr(Le_Nodo('dhEmi', arq.Text), 10)));
  dm.IBQuery1.ParamByName('adic').AsString  := 'OFF';
  dm.IBQuery1.ExecSQL;
  dm.IBQuery1.Transaction.Commit;
  arq.free;

  ShowMessage('NFCe ' + copy(ExtractFileName(tmp), 1, 44) + ' Adicionada com Sucesso!');
end;


function Tfuncoes.primeiroDiaDoMes() : boolean;
begin
  Result := false;
  if  StrToInt(FormatDateTime('dd', now)) = 1 then Result := true;
end;


procedure Tfuncoes.atualizaMSGsObsVenda();
var
  arq, lista : TStringList;
  cod : String;
  ini : integer;
begin
  lista := listaArquivos(caminhoEXE_com_barra_no_final + '*.msg');
  if lista.Count = 0 then begin
    lista.Free;
    exit;
  end;

  for ini := 0 to lista.Count -1 do begin
    arq := TStringList.Create;
    arq.LoadFromFile(caminhoEXE_com_barra_no_final + lista[ini]);

    cod := arq[0];
    arq.Delete(0);
    dm.IBQuery1.Close;
    dm.IBQuery1.SQL.Text := 'update or insert into OBS_VENDA(nota, obs) values('+cod+', :txt)';
    dm.IBQuery1.ParamByName('txt').AsString := arq.Text;
    dm.IBQuery1.ExecSQL;
    dm.IBQuery1.Transaction.Commit;

    arq.Free;

    DeleteFile(caminhoEXE_com_barra_no_final + lista[ini]);
  end;
end;

function Tfuncoes.imprimeOBS_Servico(tipo : String = 'M') : integer;
var
  arq : TStringList;
  ini : integer;
begin
  Result := 0;
  if tipo = 'M' then begin
    dm.IBselect.Close;
    dm.IBselect.SQL.Text := 'select * from obs_venda where nota = -1';
    dm.IBselect.Open;

    if dm.IBselect.IsEmpty then begin
      dm.IBselect.Close;
      exit;
    end;

    arq      := TStringList.Create;
    arq.Text := dm.IBselect.FieldByName('obs').AsString;
    dm.IBselect.Close;

    for ini := 0 to arq.Count -1 do begin
      addRelatorioForm19(funcoes.CompletaOuRepete(#179+ arq[ini],#179, ' ', 80) + CRLF);
    end;

    Result := arq.Count;
   
    addRelatorioForm19(funcoes.CompletaOuRepete(#179,#179, ' ', 80) + CRLF);
    arq.Free;
  end;
end;


end.
