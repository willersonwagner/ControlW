{$A8,B-,C+,D+,E-,F-,G+,H+,I+,J-,K-,L+,M-,N+,O+,P+,Q-,R-,S-,T-,U-,V+,W-,X+,Y+,Z1}
{$MINSTACKSIZE $00004000}                                                 
{$MAXSTACKSIZE $00100000}
{$IMAGEBASE $00400000}
{$APPTYPE GUI}
{$WARN SYMBOL_DEPRECATED ON}
{$WARN SYMBOL_LIBRARY ON}
{$WARN SYMBOL_PLATFORM ON}
{$WARN UNIT_LIBRARY ON}
{$WARN UNIT_PLATFORM ON}
{$WARN UNIT_DEPRECATED ON}
{$WARN HRESULT_COMPAT ON}
{$WARN HIDING_MEMBER ON}
{$WARN HIDDEN_VIRTUAL ON}
{$WARN GARBAGE ON}
{$WARN BOUNDS_ERROR ON}
{$WARN ZERO_NIL_COMPAT ON}
{$WARN STRING_CONST_TRUNCED ON}
{$WARN FOR_LOOP_VAR_VARPAR ON}
{$WARN TYPED_CONST_VARPAR ON}
{$WARN ASG_TO_TYPED_CONST ON}
{$WARN CASE_LABEL_RANGE ON}
{$WARN FOR_VARIABLE ON}
{$WARN CONSTRUCTING_ABSTRACT ON}
{$WARN COMPARISON_FALSE ON}
{$WARN COMPARISON_TRUE ON}
{$WARN COMPARING_SIGNED_UNSIGNED ON}
{$WARN COMBINING_SIGNED_UNSIGNED ON}
{$WARN UNSUPPORTED_CONSTRUCT ON}
{$WARN FILE_OPEN ON}
{$WARN FILE_OPEN_UNITSRC ON}
{$WARN BAD_GLOBAL_SYMBOL ON}
{$WARN DUPLICATE_CTOR_DTOR ON}
{$WARN INVALID_DIRECTIVE ON}
{$WARN PACKAGE_NO_LINK ON}
{$WARN PACKAGED_THREADVAR ON}
{$WARN IMPLICIT_IMPORT ON}
{$WARN HPPEMIT_IGNORED ON}
{$WARN NO_RETVAL ON}
{$WARN USE_BEFORE_DEF ON}
{$WARN FOR_LOOP_VAR_UNDEF ON}
{$WARN UNIT_NAME_MISMATCH ON}
{$WARN NO_CFG_FILE_FOUND ON}
{$WARN MESSAGE_DIRECTIVE ON}
{$WARN IMPLICIT_VARIANTS ON}
{$WARN UNICODE_TO_LOCALE ON}
{$WARN LOCALE_TO_UNICODE ON}
{$WARN IMAGEBASE_MULTIPLE ON}
{$WARN SUSPICIOUS_TYPECAST ON}
{$WARN PRIVATE_PROPACCESSOR ON}
{$WARN UNSAFE_TYPE OFF}
{$WARN UNSAFE_CODE OFF}
{$WARN UNSAFE_CAST OFF}
unit nfe;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, SHDocVw,  FileCtrl, DateUtils, IniFiles, OleCtrls,  ExtCtrls, Buttons,
  IdBaseComponent, IdComponent, IdTCPServer, funcoesdav, Classes1, pcnConversao,pcnConversaonfe, untnfceForm, jsedit1,
  IdCustomTCPServer,spedFiscal;

type
  TNfeVenda = class(TForm)
    OpenDialog1: TOpenDialog;
    TCPServer: TIdTCPServer;
    Timer1: TTimer;
    Panel1: TPanel;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    Label1: TLabel;
    Edit1: TEdit;
    Label2: TLabel;
    Label3: TLabel;
    Edit2: TEdit;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    procedure te(Sender: TObject; var Key: Char);
    procedure FormCreate(Sender: TObject);
    procedure RadioButton2Enter(Sender: TObject);
    procedure RadioButton1Enter(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
  private
    Lista_Itens : TList;
    item : Item_venda;
    qtd, contador : integer;
    xml1 : AnsiString;
    recuperando : boolean;
    erro_dados, pastaNFE_ControlW, retorno_Acbr
    , _EXPORTA, _FORMPG, Caminho, chaveRecuperada, IND_PAG, tipoPessoa, idDest : string;
    i, INVALIDO : integer;
    OK : BOOLEAN;
    TOTICM, TOT_BASEICM, TOT_PIS, TOT_COFINS,BASE_ICM, VLR_ICM, totalNota, totalNota_achado, totImp,
    totalNotaORIGI, totDesc, totDesc1, TRIB_ALIQ_PIS, TRIB_ALIQ_COFINS, TOTvICMSUFDest, TOTvICMSUFRemet : currency;
    dadosEmitente,dadosDest : TStringList;
    valida : boolean;
    COFINS_ST, PIS_ST, PIS_NT, vST : currency;
    aliquotasGrupoDeICMS : TItensPISCOFINS;
    function verificaProtNFe(arquivoXML : String ) : boolean;
    procedure carregaConfigsNFe();
    procedure trataDuplicidadeNFe(erroDup : String; msg : boolean);
    FUNCTION NODO_COBR(MAT : tlist; TOT : currency; _DATA : TDateTime; FORM_PGTO : String) : String;
    function VER_PARCELAS(notas1 : TStringList) : TList;
    function insereNumeracaoNFE_Banco_de_dados(const numero, chave : String) : Boolean;
    function dataInglesToBrasil(const data : String) : string;
    procedure AtualizaCfop(var cfop : string);
    Function NODOXML(NOME, CONTEUDO : string) : string;
    Procedure LerDados_Emit_Dest(codDest : string);
    function FormataData(data : tdatetime) : string;
    FUNCTION FORMAT_DATA(DAT : string) : string;
    function FormataHora(hora : TDateTime) : string;
    function RetornaEndeRua(entra : string) : string;
    function RetornaNumero(const entra : string) : string;
    function FormataCPF_CNPJ(nome : string) : string;
    FUNCTION IND_PRES(FIN_NFE2 : String) : String;
    function GerarNFeTexto(var arq : String) : AnsiString;
    function arrendondaNFe(valor : currency; deci : integer) : currency;
    procedure CriaLista_De_itens_Venda(var lista : Tlist);
    function CampoString(ent : string) : string;
    procedure Fechar_Datasets_limpar_Listas_e_variaveis;
    Function ValidarNfe(Caminho : string) : string;
    Function ProcuraItemNaLista(var lista : TList; cod1 : integer) : integer;
    function NODO_ICMS_UF_DEST(var item1 : Item_venda) : string;
    FUNCTION NODO_RAIZ() : string;
    FUNCTION NODO_NFE() : string;
    function NODO_PAG(MAT : TList) : String;
    FUNCTION NODO_INFNFE(CHAVENF : string) : string;
    FUNCTION NODO_IDE(UF, NUM_NF, FIN_NFE,  COD_CFOP, EXT_CFOP, DAT, FORMPAG, COD_MUNIC, DV_NF : string ) : string;
    FUNCTION NODO_EMIT(CNPJ, RAZAO, FANTASIA, ENDE, BAIRRO, COD_MUN, NOM_MUN, UF, CEP, FONE, IE, CRT : string) : string;
    FUNCTION SUB_NODO_END(ENDE : String) : string;
    FUNCTION NODO_DEST(TIPO, CPF, CNPJ, NOME, ENDE, BAIRRO, COD_MUN, NOM_MUN, UF, CEP, FONE, IE, CODMUN_EMI : String) : string;
    FUNCTION NODO_ITENS(var lista : tlist; CFOP, POS, CSTICM_CFP, CSTPIS_CFP, _ORIGE : string) : string;
    Function LITERAL(ent : string) : string;
    FUNCTION NODO_ICMS(var MAT : Item_venda; CSTICM_CFOP, _ORIGE : string) : string;
    FUNCTION FORMAT_QTD(VALOR : currency) : string;
    FUNCTION NODO_PISCOFINS(var item1 : Item_venda; CSTPIS_CFOP : string) : string;
    FUNCTION NODO_TOTAL(TOTNOTA, TOT_BASEICM, TOT_ICM, TOT_PIS, TOT_COFINS, TOTDESCICM, TOTDESC : currency) : string;
    FUNCTION NODO_TRANSP(var FRETE1 : TStringList) : string;

    procedure insereRegistroDaNotaNaTabelaNFE(numeroNFE, CHAVE, cstat : String; data : TDate; arquivoXML : String);
    procedure insereRegistroDaNotaNaTabelaNFE1(numeroNFE, CHAVE, cstat : String; data : TDate);
    procedure habilitaEditRede();
    procedure desahabilitaEditRede();
    procedure restaurarPadrao();
    procedure gravaInformacoes();
    procedure preecheInformacoes();
    function busca1grava0PastaRedeNoBD(opcao : smallint) : string;
    function verNCM11(const cod : integer) : String;

    function copiaStringList_a_partir_de_um_nome(var lista : TStringList; nome : string;caminho_sai_txt : string) : boolean;

    //function Format_num(valor : currency) : string;
    { Private declarations }
  public
    dest,nota,cod_OP,natOp,cUF_Emit,chaveNF
    , DigiVerifi,tipo, cstIcmCfop,cstpisCfop
    , infAdic, codNFe, nfeTemp, codPaisDest
    , DEST_NFE, _ORIGEM, FIN_NFE1, NFE_REF, TAG_DOCREF : string;
    ICMSSN : currency;
    notas, frete, temp : TStringList;
    espera : boolean;
    tipo_frete, cupom : integer;
    TotalFrete, VLR_DESP : currency;
    pasta_Acbr, UF_EMI, UF_DEST, IND_FINAL, indIEDest, nodoFAT : String;
    //versao : String;
    function abreDataSetIBselectPelaChave(chave : String) : boolean;
    function achaQTD(const preco, total : currency) : currency;
    function GeraXml1
     : String;
    procedure enviarPorEmail(chave : String = '');
    function ExportarNotasEmitidas(nfe : string) : string;
    function ExportarNotasEmitidas1(nfe : string; email : boolean = false; ini : string = ''; fim : string = '') : string;
    function Le_Nodo1(const nome:string; const texto :string) : String;
    function entraXMLeRetornaChave(ent : String) : string;
    function Le_Nodo(nome:string; const texto :string) : String;
    procedure GravarTexto(SalvarComo, Texto:String);
    function tiraDoCaminhoDaNota_Option_1_numero_Option_2_chave(const caminho : String; const option : smallint) : String;
    function RecuperarNota(nfe : string) : string;
    function RecuperarNota1(nfe : string) : string;
    function GRAVA_NODO_PROT_NFE(ARQ_caminho : string) : string;
    function GRAVA_NODO_PROT_NFE1(ARQ_caminho : string) : string;
    function GeraChaveNf : string;
    function CriaDirCaminho(const NomeSubDir: string): boolean;
    function GeraXml : String;
    function Format_num(valor : currency; decimais : smallint = 2) : string;
    FUNCTION Insere_no_Nodo(Nodo, inserir, xml : string) : string;
    FUNCTION CAMPO_VAZIO(ENT : STRING) : Smallint;
    function StatusServico : string;
    function StatusServico1 : string;
    function CancelamentoNFe : string;
    function CancelamentoNFe1 : string;
    function ManifestarNFe(chave, tipo, just : string) : string;
    function ConsultarNFe : string;
    function ConsultarNFe1(nf1 : String = '') : string;
    function cartaDeCorrecao : string;
    function cartaDeCorrecao1 : string;
    function Reimpressao : string;
    function Reimpressao1 : string;
    function IMPRIME_NFE(arqXml : string) : string;
    function IMPRIME_NFE1(arqXml : string) : string;
    function IMPRIME_NFE2(arqXml : string) : string;
    FUNCTION NODO_INFADIC(INFO : string; PIS_NT, PIS_ST, COFINS_ST, _CFOP : currency) : String;
    function Dados_do_Frete : TStringList;
    function substitui_Nodo(nome:string; conteudo : string; const texto :string) : String;
    procedure impremeCCE(const nota : string);
    procedure ReimprimeCCECompleta();
    procedure gravaConfigLocal();
    { Public declarations }

    const
      UF_PARTILHAICMS : String = 'AM\BA\CE\GO\MG\MS\MT\PE\RN\SE\SP\SC';
  end;

var
  NfeVenda: TNfeVenda;

implementation

uses func, principal, Unit1, DB, Math, relatorio, dialog, imprime1,
  StrUtils, pcnEnvEventoNFe, ACBrNFeWebServices, pcnEventoNFe,
  pcnRetEnvEventoNFe, pcnNFe, pcnProcNFe, Unit2, cadproduto;

{$R *.dfm}
function TNfeVenda.verNCM11(const cod : integer) : String;
var
  ncm : String;
begin
  Result := '96089989';

  dm.IBQuery4.Close;
  dm.IBQuery4.SQL.Text := 'select classif, aliquota from produto where cod = :cod';
  dm.IBQuery4.ParamByName('cod').AsInteger := cod;
  dm.IBQuery4.Open;

  if StrToInt(StrNum(dm.IBQuery4.FieldByName('aliquota').AsString)) <> 10 then
    Result := '72189900';

  ncm := StrNum(trim(dm.IBQuery4.FieldByName('classif').AsString));
  if Length(ncm) = 8 then Result := ncm;
  dm.IBQuery4.Close; 
end;

function TNfeVenda.VER_PARCELAS(notas1 : TStringList) : TList;
var
  parc : Tparcela;
  ini, fim, cont : integer;
begin
  Result := TList.Create;
  fim  := notas1.Count -1;
  cont := 1;
  for ini := 0 to fim do
    begin
      dm.IBselect.Close;
      dm.IBselect.SQL.Text := 'select vencimento, total, historico from contasreceber where (nota = :nota) order by vencimento';
      dm.IBselect.ParamByName('nota').AsString := notas1[ini];
      dm.IBselect.Open;

      while not dm.IBselect.Eof do
        begin
          parc := Tparcela.Create;
          if dm.IBselect.fieldbyname('vencimento').AsDateTime < now then parc.Vencimento := now + 1
          else parc.Vencimento := dm.IBselect.fieldbyname('vencimento').AsDateTime;
          parc.valor      := dm.IBselect.fieldbyname('total').AsCurrency;
          parc.historico  :=  strzero(IntToStr(cont), 3);
          cont  := cont + 1;
          //parc.historico  := trim(copy(dm.IBselect.fieldbyname('historico').AsString, length(dm.IBselect.fieldbyname('historico').AsString) -5, length(dm.IBselect.fieldbyname('historico').AsString)));

          //if Length(trim(parc.historico)) < 3 then parc.historico := CompletaOuRepete('', parc.historico, '0', 3);

          Result.Add(parc);
          dm.IBselect.Next;
        end;
    end;
  dm.IBselect.Close;
end;

function TNfeVenda.busca1grava0PastaRedeNoBD(opcao : smallint) : string;
begin
 
end;


procedure TNfeVenda.gravaConfigLocal();
begin
  funcoes.GravaConfigNaPastaDoControlW('USAR_NFE_LOCAL', 'S');
  funcoes.GravaConfigNaPastaDoControlW('PASTA_ACBR', Edit1.Text);
  funcoes.GravaConfigNaPastaDoControlW('PASTA_CONTROL_NFE', Edit2.Text);
//  funcoes.GravaConfigNaPastaDoControlW('PASTA_CONTROL_NFCE', Edit3.Text);
end;

procedure TNfeVenda.preecheInformacoes();
begin
  dm.IBselect.Close;
  dm.IBselect.SQL.Clear;
  dm.IBselect.SQL.Add('select * from CPD where CD = 1');
  dm.IBselect.Open;

  if dm.IBselect.IsEmpty then
    begin
      RadioButton1.Checked := true;
      dm.IBselect.Close;
      exit;
    end;

  if dm.IBselect.FieldByName('SIT').AsInteger = 1 then
    begin
      Edit1.Text := dm.IBselect.FieldByName('DD').AsString;
      Edit2.Text := dm.IBselect.FieldByName('DNFC').AsString;

      RadioButton2.Checked := true;
      habilitaEditRede();
    end;
end;

procedure TNfeVenda.gravaInformacoes();
var
  rede : Boolean;
begin
  rede := false;
  if RadioButton2.Checked then rede := true;
  dm.IBQuery1.Close;
  dm.IBQuery1.SQL.Clear;
  dm.IBQuery1.SQL.Add('update or insert into cpd(CD, DD, DNFC, SIT) values(:CD, :DD, :DNFC, :SIT) matching (cd)');
  dm.IBQuery1.ParamByName('CD').AsString := '1';
  dm.IBQuery1.ParamByName('DD').AsString := IfThen(rede, Edit1.text, ''); // pasta do acbr
  dm.IBQuery1.ParamByName('DNFC').AsString := IfThen(rede, Edit2.text, ''); // pasta NFE do controlw
  dm.IBQuery1.ParamByName('SIT').AsInteger := IfThen(rede, 1, 0); // tipo de uso da Nfe
  dm.IBQuery1.ExecSQL;

  dm.IBQuery1.Transaction.Commit;

  funcoes.GravaConfigNaPastaDoControlW('USAR_NFE_LOCAL', 'N');
end;


procedure TNfeVenda.restaurarPadrao();
begin
  Edit1.Text := 'c:\ACBR\';
  Edit2.Text := caminhoEXE_com_barra_no_final;

  RadioButton1.Checked := true;

  //desahabilitaEditRede();
end;

procedure TNfeVenda.desahabilitaEditRede();
begin
  Edit1.Enabled := false;
  //Edit2.Enabled := false;
end;

procedure TNfeVenda.habilitaEditRede();
begin
  Edit1.Enabled := true;
  Edit2.Enabled := true;
end;

procedure TNfeVenda.ReimprimeCCECompleta();
var
  nf, te : string;
  xml, cce : TStringList;
begin
  te := Incrementa_Generator('nfe', 0);
  te := IntToStr(StrToIntDef(te, 1) -1);
  nf := funcoes.dialogo('generico',40,'1234567890'+#8,40,false,'','Control For Windows','Informe o Número da Nota Fiscal Eletrônica:', te);
  te := nf;
  if nf = '*' then exit;

  impremeCCE(nf);
end;

procedure TNfeVenda.impremeCCE(const nota : string);
var
  te : TStringList;
  xCorrecao, chave, dta, ev, cl : string;
begin
  CriaDirCaminho('NFE\CCE');
  if FileExists(pastaNFE_ControlW + 'NFE\CCE\CCE' + nota + '.txt') then
    begin
      te := TStringList.Create;
      try
        te.LoadFromFile(pastaNFE_ControlW + 'NFE\CCE\CCE' + nota + '.txt');
      except
        te.Free;
        exit;
      end;
      cl :=  #13 + #10;
      xCorrecao := te.Values['xCorrecao'];
      chave := te.Values['chNFe'];
      dta := te.Values['dhEvento'];
      ev := te.Values['nSeqEvento'];
      te.Free;

      form19.RichEdit1.Clear;
      addRelatorioForm19(funcoes.CompletaOuRepete('', '', '-', 60) + cl);
      addRelatorioForm19(funcoes.CompletaOuRepete('Carta de Correcao', '', ' ', 60) + cl);
      addRelatorioForm19(funcoes.CompletaOuRepete('Chave:' + chave, '', ' ', 60) + cl);
      addRelatorioForm19(funcoes.CompletaOuRepete('Data:' + dta, '', ' ', 60) + cl);
      addRelatorioForm19(funcoes.CompletaOuRepete('Evento:' + ev, '', ' ', 60) + cl);
      addRelatorioForm19(funcoes.CompletaOuRepete('Correcao:' , '', ' ', 60) + cl);
      addRelatorioForm19(funcoes.QuebraLinhas('','', xCorrecao, 60));

      addRelatorioForm19(funcoes.CompletaOuRepete('', '', '-', 60) + cl);

      imprime.textx('');

    end
  else ShowMessage('Não Existe CCE da Nota ' + nota); 
end;

function TNfeVenda.dataInglesToBrasil(const data : String) : string;
begin
  Result := '';
  Result := copy(data, 9, 2) + '/' + copy(data, 6, 2) + '/' + copy(data, 1, 4)
end;

function TNfeVenda.entraXMLeRetornaChave(ent : String) : string;
var
  tmp : string;
begin
  tmp := Le_Nodo1('infNFe', ent);
  tmp := copy(tmp, pos('Id="', tmp) + 7, pos('">', tmp));
  tmp := copy(tmp, 1, pos('">', tmp) - 1);
  Result := '';
  Result := tmp;
end;

function TNfeVenda.cartaDeCorrecao : string;
var
  texto, cod_nota,cnpj,nf, just, te, cCmd, nSeqEvento, xCondUso, cod, xCorrecao, crlf : string;
  xml, cce : TStringList;
begin
  crlf := #13 + #10;
  CriaDirCaminho('NFE\CCE');
  te := Incrementa_Generator('nfe', 0);
  te := IntToStr(StrToIntDef(te, 1) -1);
  nf := funcoes.dialogo('generico',40,'1234567890'+#8,40,false,'','Control For Windows','Informe o Número da Nota Fiscal Eletrônica:', te);
  te := nf;
  cod_nota := te;
  if nf = '*' then exit;

  nSeqEvento := '1';
  xCorrecao := '';
  if FileExists(pastaNFE_ControlW + 'NFE\CCE\CCE' + cod_nota + '.txt') then
    begin
      cce := TStringList.Create;
      cce.LoadFromFile(pastaNFE_ControlW + 'NFE\CCE\CCE' + cod_nota + '.txt');
      nSeqEvento := cce.Values['nSeqEvento'];
      if trim(nSeqEvento) = '' then nSeqEvento := '2'
        else nSeqEvento := IntToStr(StrToIntDef(nSeqEvento, 1) + 1);
      xCorrecao := cce.Values['xCorrecao'];
    end;


  nSeqEvento := funcoes.dialogo('generico',40,'1234567890'+#8,40,false,'','Control For Windows','Informe o Número do Evento:', nSeqEvento);
  if nSeqEvento = '*' then exit;


  te := funcoes.StrNum(nf);
  nf := funcoes.recuperaChaveNFe(te);

  if nf = '' then
    begin
      ShowMessage('Não foi Encontrado NFe com este Número de Nota');
      dm.IBselect.Close;
      exit;
    end;

  xCorrecao := funcoes.MensagemTextoInput('Correção da CCE', xCorrecao);
  if ((xCorrecao = '*') or (trim(xCorrecao) = '')) then exit;
  xCorrecao := copy(xCorrecao, 1, 1000);

  {xml := TStringList.Create;
  xml.LoadFromFile(caminhoEXE_com_barra_no_final + 'NFE\EMIT\' + nf + '-nfe.xml');


  te := Le_Nodo('emit', xml.GetText);
   }
  dm.IBselect.Close;
  dm.IBselect.SQL.Clear;
  dm.IBselect.SQL.Add('select cnpj from registro');
  dm.IBselect.Open;

  cnpj:= dm.IBselect.fieldbyname('cnpj').AsString;
  dm.IBselect.Close;

  cnpj := funcoes.StrNum(cnpj);

  xCondUso  := 'A Carta de Correcao e disciplinada pelo paragrafo 1o-A doart. 7o do Convenio'   +
  ' S/N, de 15 de dezembro de 1970 e pode ser utilizada para regularizacao de erro ocorrido na' +
  ' emissao de documento fiscal, desde que o erro nao esteja relacionado com: I - as variaveis' +
  ' que determinam o valor do imposto tais como: base de calculo, aliquota, diferencade preco,' +
  ' quantidade, valor da operacao ou da prestacao; II - a correcao de dados cadastrais que '    +
  'implique mudanca do remetente ou do destinatario; III - a data de emissao ou de saida.';

  //cod := Le_Nodo('nNF', xml.GetText);
  valida := false;
  cCmd := crlf + '[CCE]' + crlf;
  cCmd := cCmd +
  'idLote='+ cod_nota + nSeqEvento + CRLF + // BUG na SEFAZ onde não admite mais de uma CCE por lote
  '[EVENTO'+ strzero('1', 3)+']' + CRLF +
  //'[EVENTO'+ strzero(nSeqEvento, 3)+']' + CRLF +
  'chNFe=' + nf + CRLF +
  //'cOrgao=' + Le_Nodo('cUF', xml.GetText) + CRLF + // cod_mun
  'cOrgao=14' + CRLF + // cod_mun
  'CNPJ='+ cnpj + CRLF +
  'dhEvento=' + FormatDateTime('dd/mm/yy', form22.datamov) + ' ' + FormatDateTime('hh:mm:ss', now) + CRLF +
  'tpEvento=110110' + CRLF +
  'nSeqEvento='+ funcoes.CompletaOuRepete('', nSeqEvento, '0', 2) + CRLF +
  'versaoEvento=' + QuotedStr('1.00') + CRLF +
  'descEvento=' + QuotedStr('Carta de Correção') + CRLF +
  'xCorrecao=' + trim(copy(xCorrecao, 1, length(xCorrecao) -1)) + CRLF +
  'xCondUso=' + xCondUso + crlf;
  //nSeqEvento := nSeqEvento + 1


  texto := 'NFE.CartaDeCorrecao ("'+ cCmd +'")';
  Result := '';
  if not DirectoryExists(pasta_Acbr) then
    begin
      Result  := 'ERRO: Pasta do ACBR não foi encontrada.'+ #13 + #10;
      WWMessage(Result,mtError,[mbok],HexToTColor('FFD700'),true,false,HexToTColor('B22222'));
      exit;
    end;

  contador := 0;
  DeleteFile(pasta_Acbr + 'SAI.txt');
  GravarTexto(pasta_Acbr + 'ENT.txt',texto);

  funcoes.Mensagem(Application.Title ,'Aguarde, Enviando CCE...',15,'Courier New',false,0,clred, false);
  while not valida do
    begin
      Application.ProcessMessages;
        if FileExists(pasta_Acbr + 'SAI.txt') then
        begin
          dadosEmitente := TStringList.Create;
          dadosEmitente.LoadFromFile(pasta_Acbr + 'SAI.txt');
          pergunta1.Visible := false;
          pergunta1.Free;
          Result := dadosEmitente.Text;
          if (funcoes.Contido('OK',Result)) and (not ((funcoes.Contido('ERRO',Result)) or funcoes.Contido('Rejeicao',Result))) then
            begin
              CriaDirCaminho('NFE\CCE');
              GravarTexto(pastaNFE_ControlW + 'NFE\CCE\' +'CCE'+ cod_nota +'.txt',texto);
              impremeCCE(cod_nota);
            end
          else
            begin
              WWMessage(Result,mtError,[mbok],HexToTColor('FFD700'),true,false,HexToTColor('B22222'));
              exit;
            end;
          valida := true;
          break;
        end;

      Sleep(1500);
      contador := contador + 1;
      if contador >= 80 then
        begin
          pergunta1.Visible := false;
          pergunta1.Free;
          ShowMessage('Tempo Esgotado, O Servidor não Obteve Resposta');
          break;
          exit;
        end;
    end;
    contador := 0;
end;

function TNfeVenda.cartaDeCorrecao1 : string;
var
  texto, cod_nota,cnpj,nf, just, te, cCmd, nSeqEvento, xCondUso, cod, xCorrecao, crlf : string;
  xml, cce : TStringList;
  lote     : integer;
  previ   : boolean;
begin
  carregaConfigsNFe();
  crlf := #13 + #10;
  CriaDirCaminho('NFE\CCE');
  te := Incrementa_Generator('nfe', 0);
  te := IntToStr(StrToIntDef(te, 1) -1);
  nf := funcoes.dialogo('generico',100,'1234567890'+#8,100,false,'','Control For Windows','Informe o Número da Nota Fiscal Eletrônica:', te);
  te := nf;
  cod_nota := te;
  if nf = '*' then exit;

  nSeqEvento := '1';
  xCorrecao := '';
  if FileExists(pastaNFE_ControlW + 'NFE\CCE\CCE' + cod_nota + '.txt') then
    begin
      cce := TStringList.Create;
      cce.LoadFromFile(pastaNFE_ControlW + 'NFE\CCE\CCE' + cod_nota + '.txt');
      nSeqEvento := cce.Values['nSeqEvento'];
      if trim(nSeqEvento) = '' then nSeqEvento := '2'
        else nSeqEvento := IntToStr(StrToIntDef(nSeqEvento, 1) + 1);
      xCorrecao := cce.Values['xCorrecao'];
    end;

  nSeqEvento := funcoes.dialogo('generico',40,'1234567890'+#8,40,false,'','Control For Windows','Informe o Número do Evento:', nSeqEvento);
  if nSeqEvento = '*' then exit;

  te := funcoes.StrNum(nf);
  nf := funcoes.recuperaChaveNFe(te);

  if nf = '' then
    begin
      ShowMessage('Não foi Encontrado NFe com este Número de Nota');
      dm.IBselect.Close;
      exit;
    end;

  dm.IBselect.Close;
  dm.IBselect.SQL.Clear;
  dm.IBselect.SQL.Add('select cnpj from registro');
  dm.IBselect.Open;

  cnpj:= dm.IBselect.fieldbyname('cnpj').AsString;
  dm.IBselect.Close;

  cnpj := funcoes.StrNum(cnpj);

  xCondUso  := 'A Carta de Correcao e disciplinada pelo paragrafo 1o-A doart. 7o do Convenio'   +
  ' S/N, de 15 de dezembro de 1970 e pode ser utilizada para regularizacao de erro ocorrido na' +
  ' emissao de documento fiscal, desde que o erro nao esteja relacionado com: I - as variaveis' +
  ' que determinam o valor do imposto tais como: base de calculo, aliquota, diferencade preco,' +
  ' quantidade, valor da operacao ou da prestacao; II - a correcao de dados cadastrais que '    +
  'implique mudanca do remetente ou do destinatario; III - a data de emissao ou de saida.';

  //cod := Le_Nodo('nNF', xml.GetText);
  valida := false;

  xCorrecao := funcoes.MensagemTextoInput('Correção da CCE', xCorrecao);
  if ((xCorrecao = '*') or (trim(xCorrecao) = '')) then exit;
  xCorrecao := copy(xCorrecao, 1, 1000);

  try
    dm.ACBrNFe.NotasFiscais.Clear;
    dm.ACBrNFe.NotasFiscais.LoadFromFile(pastaNFE_ControlW+'\NFE\EMIT\'+ nf +'-nfe.xml');
  except
    on e:exception do
      begin
        MessageDlg('ERRO: ' + e.Message + #13 + ' Tente Novamente.',
                  mtError,[mbOK],0);
        exit;
      end;
  end;

  lote := StrToInt(FormatDateTime('yymmddhhmm', NOW));

  ACBrNFe.EventoNFe.Evento.Clear;
  ACBrNFe.EventoNFe.idLote := lote;
  ACBrNFe.EventoNFe.Evento.Add;

  with ACBrNFe.EventoNFe.Evento[0] do
    begin
      infEvento.dhEvento   := Now;
      infEvento.tpEvento   := teCCe;
      infEvento.nSeqEvento := StrToInt(nSeqEvento);
      infEvento.detEvento.xCorrecao := xCorrecao;
      //InfEvento.detEvento.xCondUso  := xCondUso;
    end;

    funcoes.Mensagem(Application.Title ,'Aguarde, Enviando CCE...',15,'Courier New',false,0,clred, false);
    Application.ProcessMessages;
    try
      try
        ACBrNFe.EnviarEvento(lote);
      except
        on e:exception do
          begin
            MessageDlg(e.Message, mtError, [mbOK], 2);
          end;
      end;
    finally
      pergunta1.Visible := false;
    end;
        cce := TStringList.Create;
        cce.Values['nSeqEvento'] := nSeqEvento;
        cce.Values['xCorrecao']  := xCorrecao;
        cce.SaveToFile(pastaNFE_ControlW + 'NFE\CCE\CCE' + cod_nota + '.txt');
        cce.Free;
        dm.DANFE.PathPDF := caminhoEXE_com_barra_no_final + 'NFE\PDF\';
        previ := DANFE.MostrarPreview;
        DANFE.MostrarPreview := true;
        ACBrNFe.ImprimirEvento;
        ACBrNFe.ImprimirEventoPDF;
        DANFE.MostrarPreview := previ;
end;

function TNfeVenda.tiraDoCaminhoDaNota_Option_1_numero_Option_2_chave(const caminho : String; const option : smallint) : String;
var
  cha : String;
begin
   Result := '';
   cha := copy(caminho, funcoes.PosFinal('\', caminho) + 1, length(caminho)); //pegou a parte do caimnho depois da barra, deixando somente o nome do arquivo e a extensao
   cha := copy(cha, 1, length(cha) - 8); // agora tirou -nfe.xml
   if option = 1 then
     begin
       Result := cha;
       exit;
     end;

   cha := copy(cha, 26, 9); // agora tirou o numero da nota
   Result := cha;
end;

function TNfeVenda.insereNumeracaoNFE_Banco_de_dados(const numero, chave : String) : Boolean;
begin
//  ShowMessage('Nota = ' + numero + #13 + 'Chave = ' + chave);

  dm.IBselect.Close;
  dm.IBselect.SQL.Clear;
  dm.IBselect.SQL.Add('select * from nfe where chave = :chave');
  dm.IBselect.ParamByName('chave').AsString := chave;
  dm.IBselect.Open;

  if (dm.IBselect.IsEmpty) then
    begin
      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add('insert into nfe(nota, chave) values(:nota, :chave)');
      dm.IBQuery1.ParamByName('nota').AsInteger := StrToInt(numero);
      dm.IBQuery1.ParamByName('chave').AsString := chave;

      try
        dm.IBQuery1.ExecSQL;
        dm.IBQuery1.Transaction.Commit;
      except
        on e: exception do
          begin
            gravaErrosNoArquivo(e.Message, 'nfe', '163', 'insereNumeracaoNFE_Banco_de_dados()');
          end;
      end;
    end;
  dm.IBselect.Close;
end;

procedure TNfeVenda.insereRegistroDaNotaNaTabelaNFE(numeroNFE, CHAVE, cstat : String; data : TDate; arquivoXML : String);
var
  esta : String;
begin

  if VerificaCampoTabela('data', 'nfe') and VerificaCampoTabela('estado', 'nfe') then
    begin
      dm.IBQuery3.Close;
      dm.IBQuery3.SQL.Clear;
      dm.IBQuery3.SQL.Add('update or insert into nfe(nota, chave, data, estado, xml) values(:nota, :chave, :data, :estado, :xml) matching(chave)');
      dm.IBQuery3.ParamByName('nota').AsString   := numeroNFE;
      dm.IBQuery3.ParamByName('chave').AsString  := CHAVE;
      dm.IBQuery3.ParamByName('data').AsDate     := data;
      dm.IBQuery3.ParamByName('estado').AsString := cstat;
      dm.IBQuery3.ParamByName('xml').LoadFromFile(arquivoXML, ftBlob);
    end
  else if VerificaCampoTabela('data', 'nfe') and (not VerificaCampoTabela('estado', 'nfe')) then
    begin
      dm.IBQuery3.Close;
      dm.IBQuery3.SQL.Text := ('update or insert into nfe(nota, chave, data, xml) values(:nota, :chave, :data, :xml) matching(chave)');
      dm.IBQuery3.ParamByName('nota').AsString   := numeroNFE;
      dm.IBQuery3.ParamByName('chave').AsString  := CHAVE;
      dm.IBQuery3.ParamByName('data').AsDate     := data;
      dm.IBQuery3.ParamByName('xml').LoadFromFile(arquivoXML, ftBlob);
    end
  else
    begin
      dm.IBQuery3.Close;
      dm.IBQuery3.SQL.Text := ('update or insert into nfe(nota, chave, xml) values(:nota, :chave, :xml) matching(chave)');
      dm.IBQuery3.ParamByName('nota').AsString   := numeroNFE;
      dm.IBQuery3.ParamByName('chave').AsString  := CHAVE;
      dm.IBQuery3.ParamByName('xml').LoadFromFile(arquivoXML, ftBlob);
    end;


  try
    dm.IBQuery3.ExecSQL;
    dm.IBQuery3.Transaction.Commit;
  except
  end;

end;


procedure TNfeVenda.insereRegistroDaNotaNaTabelaNFE1(numeroNFE, CHAVE, cstat : String; data : TDate);
var
  esta : String;
begin
  if VerificaCampoTabela('data', 'nfe') and VerificaCampoTabela('estado', 'nfe') then
    begin
      dm.IBQuery3.Close;
      dm.IBQuery3.SQL.Clear;
      dm.IBQuery3.SQL.Add('update or insert into nfe(nota, chave, data, estado) values(:nota, :chave, :data, :estado) matching(nota)');
      dm.IBQuery3.ParamByName('nota').AsString   := numeroNFE;
      dm.IBQuery3.ParamByName('chave').AsString  := CHAVE;
      dm.IBQuery3.ParamByName('data').AsDate     := data;
      dm.IBQuery3.ParamByName('estado').AsString := cstat;
    end
  else if VerificaCampoTabela('data', 'nfe') and (not VerificaCampoTabela('estado', 'nfe')) then
    begin
      dm.IBQuery3.Close;
      dm.IBQuery3.SQL.Text := ('update or insert into nfe(nota, chave, data) values(:nota, :chave, :data) matching(nota)');
      dm.IBQuery3.ParamByName('nota').AsString   := numeroNFE;
      dm.IBQuery3.ParamByName('chave').AsString  := CHAVE;
      dm.IBQuery3.ParamByName('data').AsDate     := data;
    end
  else
    begin
      dm.IBQuery3.Close;
      dm.IBQuery3.SQL.Text := ('update or insert into nfe(nota, chave) values(:nota, :chave) matching(nota)');
      dm.IBQuery3.ParamByName('nota').AsString   := numeroNFE;
      dm.IBQuery3.ParamByName('chave').AsString  := CHAVE;
    end;

  try
    dm.IBQuery3.ExecSQL;
    dm.IBQuery3.Transaction.Commit;
  except

  end;
end;

function TNfeVenda.substitui_Nodo(nome:string; conteudo : string; const texto :string) : String;
var ini,fim : integer;
begin
  ini := 0;
  fim := 0;
  ini := pos('<'+nome+'>',texto) + length('<'+nome+'>');
  fim := pos('</'+nome+'>',texto);
  fim := fim + length('</'+nome+'>') + 1;
  Result := '' ;
  Result := copy(texto, 1, ini) + conteudo ;
  Result := copy(texto,ini,fim );
end;

function TNfeVenda.ExportarNotasEmitidas(nfe : string) : string;
var
  ini, fim, num, unidade : string;
  dini, dfim : TDateTime;
  ind, gf : integer;
  cont, tot : Smallint;
 // ini1, fim1 : integer;
  arq : TStringList;
begin
  ini := funcoes.dialogo('data',0,'',2,true,'',Application.Title,'Qual a Data Inicial?', formatadataddmmyy(StartOfTheMonth(form22.datamov)));
  if ini = '*' then exit;

  fim := funcoes.dialogo('data',0,'',2,true,'',Application.Title,'Qual a Data Final?', formatadataddmmyy(endOfTheMonth(form22.datamov)));
  if fim = '*' then exit;

  unidade := funcoes.dialogo('generico',0,'ABCDEFGHIJLMNOPKXYZWQRSTUVXZ',50,false,'S',Application.Title,'Confirme a unidade para Recebimento da Remessa:', ConfParamGerais[33]);
  if unidade = '*' then exit;

  dini := StrToDateTime(ini);
  dfim := StrToDateTime(fim);

  unidade := unidade + ':\NFE '+ FormatDateTime('mm-yyyy', dini) +'\';
  funcoes.CriaDiretorio(unidade);

  num := Incrementa_Generator('nfe', 0);
  ind := StrToInt(num) + 1;
  gf  := ind;
  arq := TStringList.Create;
  cont := 0;
  tot  := 0;

  //arq := funcoes.listaArquivos(unidade + '*.*');
  {for ini1 := arq.Count -1 downto 0 do
    begin
      if Copy(arq[ini1], 3, 4) =
    end;}

  funcoes.informacao(0, 0, 'Aguarde, Verificando Arquivos...', true, false, 5);

  while true do
    begin
      funcoes.informacao(gf - ind, gf, 'Aguarde, Verificando Arquivos...', false, false, 5);
      ind := ind - 1;
      num := funcoes.recuperaChaveNFe(IntToStr(ind));
      if num = '' then
        begin
          cont := cont + 1;
        end
        else
          begin
            num := num + '-nfe.xml'; //cria o nome do arquivo

            if FileExists(pastaNFE_ControlW + 'NFE\EMIT\' + num) then
              begin
                arq.LoadFromFile(pastaNFE_ControlW + 'NFE\EMIT\' + num);
                //carrega o arquivo na variavel

                ini := Le_Nodo('dEmi', arq.Text);
                //ler o nodo da data de emissao

                ini := dataInglesToBrasil(ini);
                //muda o formato data yyyy-mm-dd para dd/mm/yyyy

                if ((StrToDateTimeDef(ini, StrToDate('01/01/1991')) >= dini) and (StrToDateTime(ini) <= dfim)) then
                  begin
                    CopyFile(pchar(pastaNFE_ControlW + 'NFE\EMIT\' + num), pchar(unidade + num), true);
                    tot := tot + 1;
                  end
                else
                  begin
                    cont := cont + 1;
                  end;
              end;
          end;

      if ((cont > 9) or (ind = 0)) then break; //sai do while se vier em branco
    end;

   funcoes.informacao(0, 0, 'Aguarde, Verificando Arquivos...', false, true, 5); 
   try
     arq.Free;
   except
   end;

   ShowMessage(IntToStr(tot) + ' Arquivos Copiados');
end;

function TNfeVenda.ExportarNotasEmitidas1(nfe : string; email : boolean = false; ini : string = ''; fim : string = '') : string;
var
  num, unidade, tipo : string;
  dini, dfim : TDateTime;
  ind, gf : integer;
  cont, tot : Smallint;
 // ini1, fim1 : integer;
  arq, lista, listaCANC : TStringList;
begin
  Result := '';

  if ini = '' then begin
    ini := funcoes.dialogo('data',0,'',2,true,'',Application.Title,'Qual a Data Inicial?', formatadataddmmyy(StartOfTheMonth(form22.datamov)));
    if ini = '*' then exit;
  end;

  if fim = '' then begin
    fim := funcoes.dialogo('data',0,'',2,true,'',Application.Title,'Qual a Data Final?', formatadataddmmyy(endOfTheMonth(StrToDate(ini))));
    if fim = '*' then exit;
  end;

  dini := StrToDateTime(ini);
  dfim := StrToDateTime(fim);

  if email = false then begin
    if ConfParamGerais[33] = '' then ConfParamGerais[33] := 'D';
    unidade := funcoes.dialogo('generico',0,'ABCDEFGHIJLMNOPKXYZWQRSTUVXZ',50,false,'S',Application.Title,'Confirme a unidade para Recebimento da Remessa:', ConfParamGerais[33]);
    if unidade = '*' then exit;
    unidade := unidade + ':\NFE '+ FormatDateTime('mm-yyyy', dini);
  end
  else begin
    unidade := caminhoEXE_com_barra_no_final + 'Backup\';
    CriaDiretorio(unidade);
    unidade := unidade + 'NFE ' + FormatDateTime('mm-yyyy', dini);
  end;

  num := Incrementa_Generator('nfe', 0);
  ind := StrToInt(num) + 1;
  gf  := ind;
  arq       := TStringList.Create;
  lista     := TStringList.Create;
  listaCANC := TStringList.Create;
  cont := 0;
  tot  := 0;

  dm.IBselect.Close;
  dm.IBselect.SQL.Text := 'select * from nfe where substring(chave from 3 for 4) = :ini';
      dm.IBselect.ParamByName('ini').AsString := FormatDateTime('yy', StrToDate(ini)) +  FormatDateTime('mm', StrToDate(ini));
  dm.IBselect.Open;
  dm.IBselect.FetchAll;

  if dm.IBselect.IsEmpty then begin
    ShowMessage('Nenhuma NFe Para Copiar!');
    dm.IBselect.Close;
  end;

  gf := dm.IBselect.RecordCount;

  //arq := funcoes.listaArquivos(unidade + '*.*');
  {for ini1 := arq.Count -1 downto 0 do
    begin
      if Copy(arq[ini1], 3, 4) =
    end;}

  funcoes.informacao(0, 0, 'Aguarde, Verificando Arquivos...', true, false, 5);

  while not dm.IBselect.Eof do
    begin
      funcoes.informacao(dm.IBselect.RecNo, gf, 'Aguarde, Verificando Arquivos...', false, false, 5);
     
      num := dm.IBselect.FieldByName('chave').AsString + '-nfe.xml'; //cria o nome do arquivo

      if FileExists(caminhoEXE_com_barra_no_final + 'NFE\EMIT\' + num) then begin
        if dm.IBselect.FieldByName('estado').AsString = 'C' then begin
          listaCANC.Add(caminhoEXE_com_barra_no_final + 'NFE\EMIT\' + num);
        end
        else lista.Add(caminhoEXE_com_barra_no_final + 'NFE\EMIT\' + num);

        {cont := cont + 1;
        CopyFile(pchar(caminhoEXE_com_barra_no_final + 'NFE\EMIT\' + num), pchar(unidade + num), true);}
        tot := tot + 1;
      end;

      dm.IBselect.Next;
    end;

   if lista.Count     > 0 then begin
     funcoes.Zip(lista, unidade + '.zip');
     if RightStr(Result, 1) <> '|' then Result := Result + '|';
     Result := Result + unidade + '.zip' + '|';
   end;

   if listaCANC.Count > 0 then begin
     funcoes.Zip(listaCANC, unidade + '_CANC.zip');
     if RightStr(Result, 1) <> '|' then Result := Result + '|';
     Result := Result + unidade + '_CANC.zip' + '|';
   end;

   funcoes.informacao(0, 0, 'Aguarde, Verificando Arquivos...', false, true, 5);
   try
     arq.Free;
     lista.Free;
     listaCANC.Free;
   except
   end;

   if email = false then ShowMessage(IntToStr(tot) + ' Arquivos Copiados');
end;

function TNfeVenda.RecuperarNota(nfe : string) : string;
var
  texto, just, te : string;
  arq : TStringList;
  i, fim : integer;
  fora : smallint;
begin
  fora := 0;
  if nfe = '' then
    begin
      fora := 1;
      nfe := Incrementa_Generator('nfe', 0);
      nfe := IntToStr(StrToIntDef(nfe, 1) -1);
      nfe := funcoes.dialogo('generico',40,'1234567890'+#8,40,false,'','Control For Windows','Informe o Número da Nota Fiscal Eletrônica:',nfe);
      if nfe = '*' then exit;

      te := funcoes.StrNum(nfe);
      nfe := funcoes.recuperaChaveNFe(te);

      if nfe = '' then
        begin
          ShowMessage('Não foi Encontrado NFe com este Número de Nota');
          exit;
        end;
    end;
  valida := false;

  texto := 'NFE.ConsultarNFe("'+ nfe +'")';
  Result := '';
  if not DirectoryExists(pasta_Acbr) then
    begin
      Result  := 'ERRO: Pasta do ACBR não foi encontrada.'+ #13 + #10;
      WWMessage(Result,mtError,[mbok],HexToTColor('FFD700'),true,false,HexToTColor('B22222'));
      exit;
    end;

  contador := 0;
  DeleteFile(pasta_Acbr + 'SAI.txt');
  GravarTexto(pasta_Acbr+'ENT.txt',texto);
  if not FileExists(pastaNFE_ControlW + 'NFE\EMIT\' + nfe + '-nfe.old') then CopyFile(pchar(pastaNFE_ControlW + 'NFE\EMIT\' + nfe + '-nfe.xml'),pchar(pastaNFE_ControlW + 'NFE\EMIT\' + nfe + '-nfe.old'), true)
   else CopyFile(pchar(pastaNFE_ControlW + 'NFE\EMIT\' + nfe + '-nfe.xml'),pchar(pastaNFE_ControlW + 'NFE\EMIT\' + nfe + '-nfe.old1'), true);

  if fora = 1 then funcoes.Mensagem(Application.Title , 'Aguarde, Recuperando NFe...', 15, 'Courier New', false, 0, clred, false);
  while not valida do
    begin
      Application.ProcessMessages;
      if FileExists(pasta_Acbr + 'SAI.txt') then
        begin
          dadosEmitente := TStringList.Create;
          dadosEmitente.LoadFromFile(pasta_Acbr + 'SAI.txt');
          if fora = 1 then
            begin
              pergunta1.Visible := false;
              pergunta1.Free;
            end;
          Result := dadosEmitente.Text;
          if (funcoes.Contido('OK',Result)) and (not ((funcoes.Contido('ERRO',Result)) or funcoes.Contido('Rejeicao',Result))) then
            begin
              GRAVA_NODO_PROT_NFE(pastaNFE_ControlW + 'NFE\EMIT\' + nfe +'-nfe.xml');

              //se for a ultima nota emitida cancela e incrementa um numero no generator
              if StrToIntDef(funcoes.StrNum(Incrementa_Generator('nfe', 0)), 0) = StrToIntDef(te, 0)  then Incrementa_Generator('nfe', 1);
              IMPRIME_NFE(pastaNFE_ControlW + 'NFE\EMIT\' + nfe +'-nfe.xml');
              //ShowMessage('A Nota Foi Cancelada com Sucesso');
            end
          else
            begin
              WWMessage(Result,mtError,[mbok],HexToTColor('FFD700'),true,false,HexToTColor('B22222'));
              exit;
            end;
          valida := true;
          break;
        end;
      Sleep(1500);
      contador := contador + 1;
      if contador >= 80 then
        begin
          if fora = 1 then
            begin
              pergunta1.Visible := false;
              pergunta1.Free;
            end;
          ShowMessage('Tempo Esgotado, O Servidor não Obteve Resposta');
          break;
          exit;
        end;
    end;
    contador := 0;
end;


function TNfeVenda.RecuperarNota1(nfe : string) : string;
var
  texto, nf, just, nf1, emit, te : string;
begin
  carregaConfigsNFe();
  te := Incrementa_Generator('nfe', 0);
  te := IntToStr(StrToIntDef(te, 1) -1);
  nf := funcoes.dialogo('generico',0,'1234567890'+#8,50,false,'','Control For Windows','Informe o Número da Nota Fiscal Eletrônica:', te);
  if nf = '*' then exit;

  {dm.IBselect.Close;
  dm.IBselect.SQL.Clear;
  dm.IBselect.SQL.Add('select * from nfe where nota = :nota');
  dm.IBselect.ParamByName('nota').AsString := nf;
  dm.IBselect.Open;

  if dm.IBselect.IsEmpty then
    begin
      ShowMessage('Não foi Encontrado NFe com este Número de Nota');
      dm.IBselect.Close;
      exit;
    end
  else
    begin
      nf := dm.IBselect.fieldbyname('chave').AsString;
    end;
  dm.IBselect.Close;
  }

  nf1 := nf;
  nf  := funcoes.recuperaChaveNFe(nf);

  if nf = '' then
    begin
      ShowMessage('Não foi Encontrado NFe com este Número de Nota');
      exit;
    end;

  contador := 0;
  funcoes.Mensagem(Application.Title ,'Aguarde, Consultando NFe...',15,'Courier New',false,0,clred, false);
  Application.ProcessMessages;

  try
    ACBrNFe.NotasFiscais.Clear;
    ACBrNFe.NotasFiscais.LoadFromFile(pastaNFE_ControlW + 'NFE\EMIT\'+ nf +'-nfe.xml');

    if ACBrNFe.Consultar then
      begin
        emit := IntToStr(ACBrNFe.NotasFiscais[0].NFe.procNFe.cStat);
        if Contido('|' + emit + '|',  '|217||613|') then begin
          pergunta1.Visible := false;
          funcoes.Mensagem(Application.Title ,'Aguarde, Enviando NFe...',15,'Courier New',false,0,clred, false);
          try
            ACBrNFe.Enviar(0,false);
          except
            on e:exception do begin
              pergunta1.Visible := false;
              MessageDlg('Erro: ' + e.Message, mtError, [mbOK], 1);
              exit;
            end;
          end;

          if StrToInt(Incrementa_Generator('nfe', 0)) = ACBrNFe.NotasFiscais[0].NFe.Ide.nNF then begin
            Incrementa_Generator('nfe', 1);
          end;

          pergunta1.Visible := false;
          ACBrNFe.NotasFiscais[0].GravarXML(nf +'-nfe.xml', pastaNFE_ControlW + 'NFE\EMIT\');
          imprimirNFe();
          exit;
        end;


        if funcoes.Contido(emit, '110-301-302') then emit := 'D'
        else if funcoes.Contido(emit, '100')    then emit := 'E'
        else if funcoes.Contido(emit, '101-135')then emit := 'C';
        if ACBrNFe.NotasFiscais[0].NFe.procNFe.cStat <= 200 then
          begin
            insereRegistroDaNotaNaTabelaNFE(nf1, nf, emit, ACBrNFe.NotasFiscais[0].NFe.Ide.dEmi, pastaNFE_ControlW + 'NFE\EMIT\' + nf +'-nfe.xml');
          end;
      end;

    if StrToInt(Incrementa_Generator('nfe', 0)) = ACBrNFe.NotasFiscais[0].NFe.Ide.nNF then
      begin
        Incrementa_Generator('nfe', 1);
      end;

    imprimirNFe();
  except
    on e:exception do
      begin
        MessageDlg('ERRO: ' + e.Message + #13 + ' Tente Novamente.',
                  mtError,[mbOK],0);
        exit;
      end;
  end;

  pergunta1.Visible := false;
end;


function TNfeVenda.Reimpressao : string;
var
  texto, nf, just, nfOri : string;
begin
  nf := Incrementa_Generator('nfe', 0);
  nf := IntToStr(StrToIntDef(nf, 1) -1);
  nf := funcoes.dialogo('generico',0,'1234567890'+#8,50,false,'','Control For Windows','Informe o Número da Nota Fiscal Eletrônica:', nf);
  if nf = '*' then exit;

  nfOri := nf;
  nf := funcoes.StrNum(nf);
  nf := funcoes.recuperaChaveNFe(nf);

  if nf = '' then
    begin
      ShowMessage('Nota ' + nfOri + ' Não Encontrada');
      exit;
    end;

  dm.IBselect.Close;

  IMPRIME_NFE(pastaNFE_ControlW + 'NFE\EMIT\' + nf + '-nfe.xml');
end;


procedure TNfeVenda.enviarPorEmail(chave : String = '');
var
 nf, email, ERRO, codCliente, cnpj : string;
 destinatario, mmEmailMsg, arq : Tstrings;
 mbody : tmemo;
begin
  if chave = '' then begin
    nf := Incrementa_Generator('nfe', 0);
    nf := IntToStr(StrToIntDef(nf, 1) -1);
    nf := funcoes.dialogo('generico',0,'1234567890'+#8,200,false,'','Control For Windows','Informe o Número da Nota Fiscal Eletrônica:', nf);
    if nf = '*' then exit;

    dm.IBselect.close;
    dm.IBselect.SQL.Text := 'select * from nfe where nota = :nota';
    dm.IBselect.ParamByName('nota').AsInteger := StrToInt(StrNum(nf));
    dm.IBselect.Open;

    if dm.IBselect.IsEmpty then begin
      ShowMessage('NFe Não Encontrada no Banco de Dados');
      dm.IBselect.Close;
      exit;
    end;

    nf := dm.IBselect.FieldByName('chave').AsString;
  end
  else begin
    nf := chave;
  end;

  arq := TStringList.Create;
  if abreDataSetIBselectPelaChave(nf) then begin
    dm.ACBrNFe.NotasFiscais.LoadFromString(dm.IBselect.FieldByName('xml').AsString);
    arq.Text := dm.IBselect.FieldByName('xml').AsString;
    dm.IBselect.Close;
    if not FileExists(buscaPastaNFe(nf) + '\'+ nf +'-nfe.xml') then begin
      arq.SaveToFile(buscaPastaNFe(nf) + '\'+ nf +'-nfe.xml');
    end;

  end
  else begin
    dm.ACBrNFe.NotasFiscais.LoadFromFile(buscaPastaNFe(nf) + '\'+ nf +'-nfe.xml');
    arq.LoadFromFile(caminhoEXE_com_barra_no_final + 'NFE\EMIT\' + dm.IBselect.FieldByName('chave').AsString + '-nfe.xml');
  end;

  {if FileExists(caminhoEXE_com_barra_no_final + 'NFE\EMIT\' + dm.IBselect.FieldByName('chave').AsString + '-nfe.xml') = false then begin
    ShowMessage('XML ' + dm.IBselect.FieldByName('chave').AsString + '-nfe.xml Não Foi Encontrado!' );
    dm.IBselect.Close;
    exit;
  end;^}

  ACBrNFe.DANFE := DANFE_Rave;
  {ACBrNFe.NotasFiscais.Clear;
  ACBrNFe.NotasFiscais.LoadFromFile(caminhoEXE_com_barra_no_final + 'NFE\EMIT\' + dm.IBselect.FieldByName('chave').AsString + '-nfe.xml');}


  cnpj := Le_Nodo('dest', arq.Text);
  cnpj := IfThen(funcoes.Contido('CNPJ', cnpj), Le_Nodo('CNPJ', cnpj),
    Le_Nodo('CPF', cnpj));

  codCliente := ACHA_CODCLIENTE(cnpj);

  dm.IBselect.Close;
  dm.IBselect.SQL.Text := 'select email from cliente where cod = :cod';
  dm.IBselect.ParamByName('cod').AsInteger := StrToInt(StrNum(codCliente));
  dm.IBselect.Open;

  email := dm.IBselect.FieldByName('email').AsString;
  dm.IBselect.Close;

  if chave = '' then begin
    email :=  dialogo('normal', 400, '', 400, true, '', Application.Title,'Qual o Email do Destinatário ?', email);
    if email = '*' then exit;
  end
  else begin
    if length(email) <= 10 then exit;
  end;

  email := LowerCase(email);
  dm.ACBrMail1.FromName := email;

  dm.IBQuery1.Close;
  dm.IBQuery1.SQL.Text := 'update cliente set email = :email where cod = :cod';
  dm.IBQuery1.ParamByName('email').AsString := LowerCase(email);
  dm.IBQuery1.ParamByName('cod').AsInteger := StrToInt(StrNum(codCliente));
  dm.IBQuery1.ExecSQL;
  dm.IBQuery1.Transaction.Commit;
  funcoes.configuraMail(dm.ACBrMail1);


  destinatario :=  TStringList.Create;
  mmEmailMsg   :=  TStringList.Create;
  destinatario.Add(email);

  dm.ACBrMail1.AddAddress(email, email);
  dm.ACBrMail1.Subject := 'NFe ' + nf + ' ' + LeftStr(form22.Pgerais.Values['empresa'], 25);
  erro := '';


  try
    //funcoes.Mensagem(Application.Title ,'Aguarde, Enviando Email...',15,'Courier New',false,0,clred);
    try
      criaPasta(caminhoEXE_com_barra_no_final + 'NFe\PDF\');

      dm.ACBrMail1.AddAddress(email, email);

      DANFE_Rave.MostrarStatus := false;
      DANFE_Rave.PathPDF := caminhoEXE_com_barra_no_final + 'NFe\PDF\';
      ACBrNFe.NotasFiscais[0].ImprimirPDF;

      mbody := TMemo.Create(self);
      mbody.Parent := self;

      dm.IBselect.Close;
      dm.IBselect.SQL.Text := 'select nome, cnpj from registro';
      dm.IBselect.Open;

      mbody.text := 'NFe ' + nf +
      ' da Empresa '  + dm.IBselect.FieldByName('nome').AsString + ' ' + dm.IBselect.FieldByName('cnpj').AsString;

      //mbody.Text := texto;
      dm.ACBrMail1.IsHTML := false;
      dm.ACBrMail1.Body.Assign(mBody.Lines);
      dm.ACBrMail1.Body.Text := mbody.text;


      AcbrEmail.AddAttachment(caminhoEXE_com_barra_no_final + 'NFe\PDF\' + nf+ '-nfe.pdf');
      AcbrEmail.AddAttachment(buscaPastaNFe(nf) + '\'+ nf +'-nfe.xml');
     dm.ACBrMail1.Send(true);

     while true do begin
       Application.ProcessMessages;
       if dm.execucaoEmail <> 1  then begin
         break;
       end;

       sleep(1000);
     end;

      {ACBrNFe.NotasFiscais.Items[0].EnviarEmail( email, 'NFe ' + nf + ' ' + LeftStr(form22.Pgerais.Values['empresa'], 25),
                                               EmailMsg
                                               , True  // Enviar PDF junto
                                               , destinatario    // Lista com emails que serÃ£o enviado cÃ³pias - TStrings
                                               , nil); // Lista de anexos - TStrings}
    except
      on e:exception do begin
        ShowMessage('Ocorreu um Erro: ' + e.Message);
        ERRO := E.Message;
      end;
    end;
  finally
    //pergunta1.Visible := false;
    destinatario.Free;
    mmEmailMsg.Free;
  end;

  //AcbrEmail.From := '';
  //if erro = '' then ShowMessage('Email Enviado com Sucesso!');
end;

function TNfeVenda.Reimpressao1 : string;
var
  texto, nf, just, nfOri : string;
begin
  nf := Incrementa_Generator('nfe', 0);
  nf := IntToStr(StrToIntDef(nf, 1) -1);
  nf := funcoes.dialogo('generico',0,'1234567890'+#8,50,false,'','Control For Windows','Informe o Número da Nota Fiscal Eletrônica:', nf);
  if nf = '*' then exit;

  nfOri := nf;
  nf := funcoes.StrNum(nf);
  nf := funcoes.recuperaChaveNFe(nf);

  if nf = '' then
    begin
      ShowMessage('Nota ' + nfOri + ' Não Encontrada');
      exit;
    end;

  dm.IBselect.Close;
  if IMPRIME_NFE2(nf) <> '' then exit;

  IMPRIME_NFE1(pastaNFE_ControlW + 'NFE\EMIT\' + IfThen(Contido('-nfe', nf), nf, nf + '-nfe') + '.xml');
end;


function TNfeVenda.copiaStringList_a_partir_de_um_nome(var lista : TStringList; nome : string;caminho_sai_txt : string) : boolean;
 var
   tmp : TStringList;
   i,tmp1 : integer;
begin
   Result := false;
   tmp := TStringList.Create;
   tmp.LoadFromFile(caminho_sai_txt);
   lista := TStringList.Create;
   tmp1 := 0;
   if not funcoes.Contido(nome, tmp.Text) then tmp1 := 1;
   for i := 0 to tmp.Count -1 do
     begin
       if ((funcoes.Contido(nome, tmp.Strings[i])) or (tmp1 <> 0)) then
          begin
            Result := true;
            tmp1 := 2;
            lista.Add(tmp.Strings[i]);
          end;
     end;
   tmp.Free;
end;

procedure TNfeVenda.AtualizaCfop(var cfop : string);
begin
  if trim(cfop) = '' then cfop := '5102';
  dm.IBQuery1.Close;
  dm.IBQuery1.SQL.Clear;
  dm.IBQuery1.SQL.Add('update acesso set nfe = :nfe' +' where substring(acesso from 1 for 1) = ''-''');
  dm.IBQuery1.ParamByName('nfe').AsString := cfop;
  try
    dm.IBQuery1.ExecSQL;
    dm.IBQuery1.Transaction.Commit;
  except
  end;
end;

Function TNfeVenda.ProcuraItemNaLista(var lista : TList; cod1 : integer) : integer;
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

function TNfeVenda.Dados_do_Frete : TStringList;
begin

end;

FUNCTION TNfeVenda.NODO_INFADIC(INFO : string; PIS_NT, PIS_ST, COFINS_ST, _CFOP : currency) : String;
var OBS : string;
begin
  OBS := '';
  //PEGA MENSAGENS DO CFOP, SE TIVEREM
  IF(length(OBS) <> 0) then OBS := OBS + #10;

  totImp := 0;

  if UpperCase(LeftStr(natOp, 5))  = 'VENDA' then
    begin
      totImp := calculaVlrAproxImpostos(Lista_Itens);
      OBS := OBS + 'Valor aprox. Impostos: '+ formataCurrency(totImp) +'('+ formataCurrency(totImp / (totalNota - totDesc) * 100) +'%) Fonte: IBPT ' + ';';
    end;  

  
  IF INFO <> '' THEN INFO := ';' + INFO ;
  OBS := OBS + ' ' + (INFO);

  if funcoes.buscaParamGeral(10, '') = '1' then begin
    if ICMSSN > 0 then begin
      OBS := 'EMPRESA OPTANTE DO SIMPLES NACIONAL;PERMITE O APROVEITAMENTO DO CRÉDITO DE ICMS NO VALOR '+
      'DE R$ '+formataCurrency(ICMSSN)+'; CORRESPONDENTE À ALÍQUOTA DE '+
      formataCurrency(menor(ALIQ_INTEREST(UF_DEST), 17))+'%, NOS TERMOS DO ART.'+
      ' 23 DA LEI COMPLEMENTAR N º 123, DE 2006". (Lei Complementar n '+
      'º123, de 2006, art. 23, §§ 1 º , 2 º e 6 º ; art. 26, inciso I e §'+
      ' 4 º )' + OBS;
    end
    else begin
      OBS := 'EMPRESA OPTANTE DO SIMPLES NACIONAL E NÃO GERA DIREITO A CREDITO DE IPI/ICMS;' + OBS;
    end;
  end;

  if Contido(funcoes.buscaParamGeral(10, ''), '34') then begin
    IF(PIS_NT <> 0) then      OBS := OBS + 'Total de mercadorias nao tributadas por PIS/COFINS: ' + FormatCurr('#,###,###0.00',PIS_NT) + ';';
    IF(PIS_ST <> 0) then      OBS := OBS + ' Total de PIS retido anteriormente por ST: ' + FormatCurr('#,###,###0.00',PIS_ST) + ';';
    IF(COFINS_ST <> 0) then   OBS := OBS + ' Total de COFINS retida anteriormente por ST: ' + FormatCurr('#,###,###0.00',COFINS_ST) + ';';
    IF(TOT_PIS <> 0) then     OBS := OBS + ' PIS recolher: ' + FormatCurr('#,###,###0.00',TOT_PIS) + ';';
    IF(TOT_COFINS <> 0) then  OBS := OBS + ' COFINS a recolher: ' + FormatCurr('#,###,###0.00',TOT_COFINS) + ';';
  end;

  OBS := removeCarateresEspeciais(obs);
  Result := '';
  Result := '<infAdic><infCpl>' + OBS + '</infCpl></infAdic>' + _EXPORTA;
end;


function TNfeVenda.IMPRIME_NFE(arqXml : string) : string;
var
  texto : string;
begin
  contador := 0;
  valida := false;
  texto := 'NFE.ImprimirDanfe('+ arqXml +')';
  Result := '';
  if not DirectoryExists(pasta_Acbr) then
    begin
      Result  := 'ERRO: Pasta do ACBR não foi encontrada.'+ #13 + #10;
      WWMessage(Result,mtError,[mbok],HexToTColor('FFD700'),true,false,HexToTColor('B22222'));
      exit;
    end;

  DeleteFile(pasta_Acbr + 'SAI.txt');
  GravarTexto(pasta_Acbr+'ENT.txt',texto);
  funcoes.Mensagem(Application.Title ,'Aguarde, Imprimindo...',15,'Courier New',false,0,clred, false);
 // funcoes.Mensagem('Aguarde, Imprimindo...',0);
  while not valida do
    begin
      Application.ProcessMessages;
      if FileExists(pasta_Acbr + 'SAI.txt') then
        begin
          dadosEmitente := TStringList.Create;
          dadosEmitente.LoadFromFile(pasta_Acbr + 'SAI.txt');
          pergunta1.Visible := false;
          pergunta1.Free;
          Result := dadosEmitente.Text;
          valida := true;
          break;
        end;
      Sleep(1500);
      contador := contador + 1;
      if contador >= 80 then
        begin
          pergunta1.Visible := false;
          pergunta1.Free;
          ShowMessage('Tempo Esgotado, O Servidor não Obteve Resposta');
          break;
          exit;
        end;
    end;
end;

function TNfeVenda.IMPRIME_NFE1(arqXml : string) : string;
var
  texto : string;
begin
  carregaConfigsNFe;
  contador := 0;
  valida := false;
  Result := '';

  funcoes.Mensagem(Application.Title ,'Aguarde, Imprimindo...',15,'Courier New',false,0,clred, false);
 // while not valida do
 //   begin
 //     Application.ProcessMessages;
      try
        dm.ACBrNFe.NotasFiscais.Clear;
        dm.ACBrNFe.NotasFiscais.LoadFromFile(arqXml, false);

        {///dm.ACBrNFeDANFEFR1.FastFile := 'D:\Fontes Paf\acbrnovo\Exemplos\ACBrDFe\ACBrNFe\Delphi\Report\DANFeSimplificado.fr3';
        //dm.ACBrNFeDANFEFR1.Impressora := 'Doro PDF Writer';
        //dm.ACBrNFeDANFEFR1.TipoDANFE := tiSimplificado;
        dm.ACBrNFeDANFeRL1.TipoDANFE := tiSimplificado;
        dm.ACBrNFeDANFeRL1.Impressora := 'Doro PDF Writer';
        dm.ACBrNFe.DANFE := dm.ACBrNFeDANFeRL1;
        dm.ACBrNFe.NotasFiscais[0].Imprimir;
        exit;
                               }
        imprimirNFe();
        form2.Button1.Click;
      except
        on e:exception do
          begin
            MessageDlg('1310nfe.pas: '+e.Message, mtError, [mbOK],1);
            pergunta1.Visible := false;
            exit;
          end;
      end;

      pergunta1.Visible := false;
      valida := true;
    //end;
end;

function TNfeVenda.IMPRIME_NFE2(arqXml : string) : string;
var
  texto : string;
begin
  Result := '';
  carregaConfigsNFe;
  contador := 0;
  valida := false;
  Result := '';

  funcoes.Mensagem(Application.Title ,'Aguarde, Imprimindo...',15,'Courier New',false,0,clred, false);


 // while not valida do
 //   begin
 //     Application.ProcessMessages;
      try
        dm.IBselect.Close;
        dm.IBselect.SQL.Text := 'select xml from nfe where chave = :chave';
        dm.IBselect.ParamByName('chave').AsString := arqXml;
        dm.IBselect.Open;

        if dm.IBselect.IsEmpty then begin
          ShowMessage('Nenhuma NFe Encontrada!');
          dm.IBselect.Close;
          exit;
        end;

        if dm.IBselect.FieldByName('xml').IsNull then begin
          ShowMessage('Nenhuma NFe Encontrada1!');
          dm.IBselect.Close;
          exit;
        end;

        Result := 'ok';

        dm.ACBrNFe.NotasFiscais.Clear;
        dm.ACBrNFe.NotasFiscais.LoadFromString(dm.IBselect.FieldByName('xml').AsString);
        //dm.ACBrNFe.NotasFiscais.LoadFromFile(arqXml, false);

        {///dm.ACBrNFeDANFEFR1.FastFile := 'D:\Fontes Paf\acbrnovo\Exemplos\ACBrDFe\ACBrNFe\Delphi\Report\DANFeSimplificado.fr3';
        //dm.ACBrNFeDANFEFR1.Impressora := 'Doro PDF Writer';
        //dm.ACBrNFeDANFEFR1.TipoDANFE := tiSimplificado;
        dm.ACBrNFeDANFeRL1.TipoDANFE := tiSimplificado;
        dm.ACBrNFeDANFeRL1.Impressora := 'Doro PDF Writer';
        dm.ACBrNFe.DANFE := dm.ACBrNFeDANFeRL1;
        dm.ACBrNFe.NotasFiscais[0].Imprimir;
        exit;
                               }
        imprimirNFe();
        form2.Button1.Click;
      except
        on e:exception do
          begin
            MessageDlg('1310nfe.pas: '+e.Message, mtError, [mbOK],1);
            pergunta1.Visible := false;
            exit;
          end;
      end;

      pergunta1.Visible := false;
      valida := true;
    //end;
end;


{function TNfeVenda.IMPRIME_NFE1(arqXml : string) : string;
var
  op    : TOpenDialog;
begin
  contador := 0;
  valida := false;
  texto := 'NFE.ImprimirDanfe('+ arqXml +')';
  Result := '';
  op := TOpenDialog.Create(self);
  op.Execute;

  arqXml := op.FileName;

  dm.ACBrNFe.DANFE := dm.ACBrNFeDANFERaveCB1;
  dm.ACBrNFeDANFERaveCB1.MostrarPreview := true;
  dm.ACBrNFeDANFERaveCB1.TipoDANFE := tiRetrato;
  try
    dm.ACBrNFe.NotasFiscais.Clear;
    dm.ACBrNFe.NotasFiscais.LoadFromFile(arqXml);
    dm.ACBrNFe.NotasFiscais.Imprimir();
    dm.ACBrNFe.NotasFiscais.ImprimirPDF();
  except
  end;
  {if not DirectoryExists(pasta_Acbr) then
    begin
      Result  := 'ERRO: Pasta do ACBR não foi encontrada.'+ #13 + #10;
      WWMessage(Result,mtError,[mbok],HexToTColor('FFD700'),true,false,HexToTColor('B22222'));
      exit;
    end;

  //DeleteFile(pasta_Acbr + 'SAI.txt');
  //GravarTexto(pasta_Acbr+'ENT.txt',texto);
  funcoes.Mensagem(Application.Title ,'Aguarde, Imprimindo...',15,'Courier New',false,0,clred);
 // funcoes.Mensagem('Aguarde, Imprimindo...',0);
  while not valida do
    begin

      Application.ProcessMessages;
      if FileExists(pasta_Acbr + 'SAI.txt') then
        begin
          dadosEmitente := TStringList.Create;
          dadosEmitente.LoadFromFile(pasta_Acbr + 'SAI.txt');
          pergunta1.Close;
          pergunta1.Free;
          Result := dadosEmitente.GetText;
          valida := true;
          break;
        end;
      Sleep(1500);
      contador := contador + 1;
      if contador >= 80 then
        begin
          pergunta1.Close;
          pergunta1.Free;
          ShowMessage('Tempo Esgotado, O Servidor não Obteve Resposta');
          break;
          exit;
        end;
    end;
end;
}

function TNfeVenda.GRAVA_NODO_PROT_NFE(ARQ_caminho : string) : string;
var
  texto, NODO_PROT, cStat, nNF, Chave1: string;
  retorno : TStringList;
  txt1 : AnsiString;
begin
  cStat := '';
  valida := false;
  Result := '';
  NODO_PROT := '';
  if not DirectoryExists(pasta_Acbr) then
    begin
      Result  := 'ERRO: Pasta do ACBR não foi encontrada.'+ #13 + #10;
      WWMessage(Result,mtError,[mbok],HexToTColor('FFD700'),true,false,HexToTColor('B22222'));
      exit;
    end;

    dadosEmitente.Free;
    dadosDest := TStringList.Create;
    dadosDest.LoadFromFile(ARQ_caminho);
    nNF    := Le_Nodo('nNF', dadosDest.GetText);
    Chave1 := entraXMLeRetornaChave(dadosDest.GetText);
    dadosDest.Free;

   //arqIni := TIniFile.Create(pasta_Acbr + 'sai.txt');
   dadosEmitente := TStringList.Create;

   if not copiaStringList_a_partir_de_um_nome(retorno,'RETORNO',pasta_Acbr + 'sai.txt') then
     begin
       retorno := TStringList.Create;
       retorno.LoadFromFile(pasta_Acbr + 'sai.txt');
     end;

   if trim(retorno.GetText) = '' then exit;

   cStat := Trim(RETORNO.Values['CStat']);
   cStat := trim(cStat);
   if funcoes.Contido(cStat, '101-135') then cStat := '101';

   if funcoes.Contido(cStat, '100-101') then
     begin
       insereNumeracaoNFE_Banco_de_dados(nNF, Chave1);
     end;

 {      not4 := copy(ARQ_caminho, funcoes.PosFinal('\', ARQ_caminho) + 1, length(ARQ_caminho));
       tmp := copy(not4, 26, 9);

       dm.IBselect.Close;
       dm.IBselect.SQL.Clear;
       dm.IBselect.SQL.Add('select * from nfe where nota = :nota');
       dm.IBselect.ParamByName('nota').AsInteger := StrToIntDef(tmp, 0);
       dm.IBselect.Open;

       if dm.IBselect.IsEmpty then
         begin
           dm.IBQuery1.Close;
           dm.IBQuery1.SQL.Clear;
           dm.IBQuery1.SQL.ad
         end;

     end;
  }

   dadosEmitente.LoadFromFile(ARQ_caminho);
   RETORNO.Values['DhRecbto'] := FormatDateTime('yyyy-mm-dd',StrToDateTimeDef(RETORNO.Values['DhRecbto'], now)) + 'T' + FormatDateTime('hh:mm:ss',StrToDateTimeDef(RETORNO.Values['DhRecbto'], now));

   NODO_PROT := '<protNFe versao="2.00"><infProt><tpAmb>' + RETORNO.Values['TpAmb'] + '</tpAmb>' +
  '<verAplic>' +  RETORNO.Values['VerAplic'] + '</verAplic><chNFe>' + chaveNF + '</chNFe>' +
  '<dhRecbto>' + (RETORNO.Values['DhRecbto']) + '</dhRecbto>' + '<nProt>' + RETORNO.Values['NProt'] +
  '</nProt><digVal>' + RETORNO.Values['DigVal'] + '</digVal>' + '<cStat>' + cStat + '</cStat>' +
  '<xMotivo>' + RETORNO.Values['XMotivo'] + '</xMotivo></infProt></protNFe>';

  Result := dadosEmitente.GetText;
  dadosEmitente.Free;

  if funcoes.Contido('<protNFe', Result) then
    begin
      Result := copy(Result, 1, pos('<protNFe',Result) - 1);
    end;

  if funcoes.Contido('</NFe>', Result) then
    begin
      Result := copy(Result, 1, pos('</NFe>',Result) - 1);
    end;

  if Result[Length(Result)] <> '>' then Result :=  Result + '>';
  Result := Result + NODO_PROT + '</NFe>';
  GravarTexto(ARQ_caminho, Result);

  dadosEmitente := nil;
  retorno := nil;

   {NODO_PROT := '<protNFe versao="2.00"><infProt Id="' + ID + VE_VALOR('NProt', ERRO_DADOS) + ["] + "><tpAmb>" + TIPO_AMB + "</tpAmb>" + ;
  "<verAplic>" + VE_VALOR("VerAplic", ERRO_DADOS) + "</verAplic><chNFe>" + CHAVENFE + "</chNFe>" + ;
  "<dhRecbto>" + DATA_REC + "</dhRecbto>" + "<nProt>" + VE_VALOR("NProt", ERRO_DADOS) + ;
  "</nProt><digVal>" + DIGEST + "</digVal>" + ;
  "<cStat>" + VE_VALOR("CStat", ERRO_DADOS) + "</cStat>" + ;
  "<xMotivo>" + VE_VALOR("XMotivo", ERRO_DADOS) + "</xMotivo></infProt></protNFef>"
    }

end;

function TNfeVenda.GRAVA_NODO_PROT_NFE1(ARQ_caminho : string) : string;
var
  texto, NODO_PROT, cStat, nNF, Chave1, digVal: string;
  retorno : TStringList;
  txt1 : AnsiString;
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

  if funcoes.Contido('<protNFe', Result) then
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

  dm.IBQuery1.Close;
  dm.IBQuery1.SQL.Text := 'update nfe set xml = :xml where chave = :chave';
  dm.IBQuery1.ParamByName('xml').LoadFromFile(ARQ_caminho, ftBlob);
  dm.IBQuery1.ParamByName('chave').AsString := strnum(ACBrNFe.WebServices.EnvEvento.EventoRetorno.retEvento.Items[0].RetInfEvento.chNFe);
  dm.IBQuery1.ExecSQL;
  dm.IBQuery1.Transaction.Commit;

  retorno.Free;
end;


function TNfeVenda.CancelamentoNFe : string;
var
  texto, nf, just, te : string;
begin
  te := Incrementa_Generator('nfe', 0);
  te := IntToStr(StrToIntDef(te, 1) -1);
  nf := funcoes.dialogo('generico',40,'1234567890'+#8,40,false,'','Control For Windows','Informe o Número da Nota Fiscal Eletrônica:',te);
  if nf = '*' then exit;

  te := funcoes.StrNum(nf);
  nf := funcoes.recuperaChaveNFe(te);

  if nf = '' then
    begin
      ShowMessage('Não foi Encontrado NFe com este Número de Nota');
      dm.IBselect.Close;
      exit;
    end;

  while length(just) < 16 do
    begin
      just := funcoes.dialogo('normal',0,'',150,false,'',Application.Title,'Qual a Justificativa?',just);
      if just = '*' then Break;
    end;

  if just = '*' then exit;

  valida := false;

  texto := 'NFE.CANCELARNFE("'+ nf +'","'+ just +'")';
  Result := '';
  if not DirectoryExists(pasta_Acbr) then
    begin
      Result  := 'ERRO: Pasta do ACBR não foi encontrada.'+ #13 + #10;
      WWMessage(Result,mtError,[mbok],HexToTColor('FFD700'),true,false,HexToTColor('B22222'));
      exit;
    end;

  contador := 0;
  DeleteFile(pasta_Acbr + 'SAI.txt');
  GravarTexto(pasta_Acbr+'ENT.txt', texto);
  funcoes.Mensagem(Application.Title ,'Aguarde, Cancelando NFe...',15,'Courier New',false,0,clred);
  while not valida do
    begin
      Application.ProcessMessages;
        if FileExists(pasta_Acbr + 'SAI.txt') then
        begin
          dadosEmitente := TStringList.Create;
          dadosEmitente.LoadFromFile(pasta_Acbr + 'SAI.txt');
          pergunta1.Visible := false;
          pergunta1.Free;
          Result := dadosEmitente.GetText;
          if (funcoes.Contido('OK',Result)) and (not ((funcoes.Contido('ERRO',Result)) or funcoes.Contido('Rejeicao',Result))) then
            begin
              CriaDirCaminho('NFE\CANC');

              if not FileExists(pastaNFE_ControlW + 'NFE\EMIT\' + nf + '-nfe.old') then CopyFile(pchar(pastaNFE_ControlW + 'NFE\EMIT\' + nf + '-nfe.xml'),pchar(pastaNFE_ControlW + 'NFE\EMIT\' + nf + '-nfe.old'), true)
                else CopyFile(pchar(pastaNFE_ControlW + 'NFE\EMIT\' + nf + '-nfe.xml'),pchar(pastaNFE_ControlW + 'NFE\EMIT\' + nf + '-nfe.old1'), true);

              GRAVA_NODO_PROT_NFE(pastaNFE_ControlW + 'NFE\EMIT\' + nf +'-nfe.xml');
              //copia para o xml da nota para o NFE\CANC
              CopyFile(pchar(pastaNFE_ControlW + 'NFE\EMIT\' + nf + '-nfe.xml'),pchar(pastaNFE_ControlW + 'NFE\CANC\' + nf +'-nfe.xml'), true);

              //se for a ultima nota emitida cancela e incrementa um numero no generator
              if StrToIntDef(funcoes.StrNum(Incrementa_Generator('nfe', 0)), 0) = StrToIntDef(te, 0)  then Incrementa_Generator('nfe', 1);
              IMPRIME_NFE(pastaNFE_ControlW + 'NFE\EMIT\' + nf +'-nfe.xml');

              funcoes.CANC_MOV(te, '90');

            end
          else
            begin
              WWMessage(Result,mtError,[mbok],HexToTColor('FFD700'),true,false,HexToTColor('B22222'));
              exit;
            end;
          valida := true;
          break;
        end;

      Sleep(1500);
      contador := contador + 1;
      if contador >= 80 then
        begin
          pergunta1.Visible := false;
          pergunta1.Free;
          ShowMessage('Tempo Esgotado, O Servidor não Obteve Resposta');
          break;
          exit;
        end;
    end;
    contador := 0;
end;

function TNfeVenda.CancelamentoNFe1 : string;
var
  texto, nf, just, te, tmp, nnf, cstat : string;
  data : tdate;
begin
  carregaConfigsNFe();
  te := Incrementa_Generator('nfe', 0);
  te := IntToStr(StrToIntDef(te, 1) -1);
  nf := funcoes.dialogo('generico',100,'1234567890'+#8,100,false,'','Control For Windows','Informe o Número da Nota Fiscal Eletrônica:',te);
  if nf = '*' then exit;

  te := funcoes.StrNum(nf);
  nf := funcoes.recuperaChaveNFe(te);

  if nf = '' then
    begin
      ShowMessage('Não foi Encontrado NFe com este Número de Nota');
      dm.IBselect.Close;
      exit;
    end;

  while length(just) < 16 do
    begin
      just := funcoes.dialogo('normal',0,'',150,false,'',Application.Title,'Qual a Justificativa?',just);
      if just = '*' then Break;
    end;
  if just = '*' then exit;

  valida := false;
  //ACBrNFe.NotasFiscais.Clear;

  contador := 0;
 // DeleteFile(pasta_Acbr + 'SAI.txt');
  //GravarTexto(pasta_Acbr+'ENT.txt', texto);
  dm.ACBrNFe.NotasFiscais.Clear;

  try
    if abreDataSetIBselectPelaChave(nf) then begin
      dm.ACBrNFe.NotasFiscais.LoadFromString(dm.IBselect.FieldByName('xml').AsString);
      dm.IBselect.Close;
    end
    else begin
      dm.ACBrNFe.NotasFiscais.LoadFromFile(buscaPastaNFe(nf) + '\'+ nf +'-nfe.xml');
    end;
  except
    on e:exception do
      begin
        MessageDlg('ERRO: ' + e.Message + #13 + ' Tente Novamente.',
                  mtError,[mbOK],0);
        exit;
      end;
  end;

  //ACBrNFe.Configuracoes.Geral.AtualizarXMLCancelado := true;
  funcoes.Mensagem(Application.Title ,'Aguarde, Cancelando NFe...',15,'Courier New',false,0,clred);
  while not valida do
    begin
      Application.ProcessMessages;
      CriaDirCaminho('NFE\CANC');

      dm.ACBrNFe.EventoNFe.Evento.Clear;
      dm.ACBrNFe.EventoNFe.Evento.Add;
      with ACBrNFe.EventoNFe.Evento[0] do
        begin
          InfEvento.dhEvento        := now;
          infEvento.tpEvento        := teCancelamento;
          infEvento.detEvento.xJust := just;
        end;

      contador := 0;
      try
        dm.ACBrNFe.EnviarEvento(0);
        cStat := IntToStr(ACBrNFe.WebServices.EnvEvento.EventoRetorno.retEvento.Items[0].RetInfEvento.cStat);
      except
        on e:exception do
          begin
            ShowMessage(e.Message);
            exit;
          end;
      end;

      cStat := IntToStr(ACBrNFe.WebServices.EnvEvento.EventoRetorno.retEvento.Items[0].RetInfEvento.cStat);

      if funcoes.Contido(cstat, '101-135-151-573-155') then
        begin
          if not FileExists(pastaNFE_ControlW + 'NFE\EMIT\' + nf + '-nfe.old') then CopyFile(pchar(pastaNFE_ControlW + 'NFE\EMIT\' + nf + '-nfe.xml'),pchar(pastaNFE_ControlW + 'NFE\EMIT\' + nf + '-nfe.old'), true)
            else CopyFile(pchar(pastaNFE_ControlW + 'NFE\EMIT\' + nf + '-nfe.xml'),pchar(pastaNFE_ControlW + 'NFE\EMIT\' + nf + '-nfe.old1'), true);


          tmp   := ACBrNFe.WebServices.EnvEvento.EventoRetorno.retEvento.Items[0].RetInfEvento.xMotivo;
          cstat := IntToStr(ACBrNFe.WebServices.EnvEvento.EventoRetorno.retEvento.Items[0].RetInfEvento.cStat);
          nnf   := IntToStr(ACBrNFe.NotasFiscais[0].NFe.Ide.nNF);
          data  := ACBrNFe.NotasFiscais[0].NFe.Ide.dEmi;

          dm.ACBrNFeDANFeRL1.NFeCancelada := true;
          ACBrNFe.DANFE.NFeCancelada := true;
          imprimirNFe();

          dm.ACBrNFeDANFeRL1.NFeCancelada := false;

          ACBrNFe.DANFE.NFeCancelada := false;

          insereRegistroDaNotaNaTabelaNFE(nnf, nf, 'C', data, pastaNFE_ControlW + 'NFE\EMIT\' + nf + '-nfe.xml');

          GRAVA_NODO_PROT_NFE1(pastaControlW   +'NFE\EMIT\'+ nf +'-nfe.xml');
          funcoes.CANC_MOV(te, '90');

          try
            SendPostData(Form72.IdHTTP1, pastaNFE_ControlW + 'NFE\EMIT\' + nf + '-nfe.xml', 'C', cstat);
          finally

          end;

          ShowMessage('NF-e Cancelada com Sucesso. '+ #13 +'Protocolo '+ ACBrNFe.WebServices.Retorno.Protocolo + #13 + 'xMotivo:' + tmp);
        end
      else
        begin
          try
          cstat := 'cStat:   ' + IntToStr(ACBrNFe.WebServices.EnvEvento.EventoRetorno.retEvento.Items[0].RetInfEvento.cStat) + #13 +
                   'xMotivo: ' + ACBrNFe.WebServices.EnvEvento.EventoRetorno.retEvento.Items[0].RetInfEvento.xMotivo;
          except
          end;
          ShowMessage('Ocorreu um Erro no Cancelamento:' + #13 + cstat + #13 + tmp + IfThen(pos('Duplicidade', tmp) > 0, #13 + #13 + 'Esta Nota já pode ter Sido Cancelada', ''));
        end;

      if StrToIntDef(funcoes.StrNum(Incrementa_Generator('nfe', 0)), 0) = StrToIntDef(te, 0)  then Incrementa_Generator('nfe', 1);
      //IMPRIME_NFE(pastaNFE_ControlW + 'NFE\EMIT\' + nf +'-nfe.xml');

      pergunta1.Visible := false;

      valida := true;
      break;
    end;
    
    contador := 0;
end;


function TNfeVenda.ConsultarNFe : string;
var
  texto, nf, just : string;
begin
  nf := funcoes.dialogo('generico',0,'1234567890'+#8,50,false,'','Control For Windows','Informe o Número da Nota Fiscal Eletrônica:','');
  if nf = '*' then exit;

  dm.IBselect.Close;
  dm.IBselect.SQL.Clear;
  dm.IBselect.SQL.Add('select * from nfe where nota = :nota');
  dm.IBselect.ParamByName('nota').AsString := nf;
  dm.IBselect.Open;

  if dm.IBselect.IsEmpty then
    begin
      ShowMessage('Não foi Encontrado NFe com este Número de Nota');
      dm.IBselect.Close;
      exit;
    end
  else
    begin
      nf := dm.IBselect.fieldbyname('chave').AsString;
    end;
  dm.IBselect.Close;

  valida := false;
  texto := 'NFE.ConsultarNFe("'+ nf +'")';
  Result := '';
  if not DirectoryExists(pasta_Acbr) then
    begin
      Result  := 'ERRO: Pasta do ACBR não foi encontrada.'+ #13 + #10;
      WWMessage(Result,mtError,[mbok],HexToTColor('FFD700'),true,false,HexToTColor('B22222'));
      exit;
    end;

  contador := 0;
  DeleteFile(pasta_Acbr + 'SAI.txt');
  GravarTexto(pasta_Acbr+'ENT.txt',texto);
  funcoes.Mensagem(Application.Title ,'Aguarde, Consultando NFe...',15,'Courier New',false,0,clred);
  //funcoes.Mensagem('Aguarde, Consultando NFe...',0);
  while not valida do
    begin
      Application.ProcessMessages;
        if FileExists(pasta_Acbr + 'SAI.txt') then
        begin
          dadosEmitente := TStringList.Create;
          dadosEmitente.LoadFromFile(pasta_Acbr + 'SAI.txt');
          pergunta1.Visible := false;
          pergunta1.Free;
          Result := dadosEmitente.GetText;
          if  ((funcoes.Contido('ERRO',Result)) or (funcoes.Contido('Rejeicao',Result))) then
            begin
              WWMessage(Result,mtError,[mbok],HexToTColor('FFD700'),true,false,HexToTColor('B22222'));
            end
          else
            begin
              ShowMessage(dadosEmitente.GetText);
            end;
          valida := true;
          break;
        end;
      Sleep(1500);
      contador := contador + 1;
      if contador >= 80 then
        begin
          pergunta1.Visible := false;
          pergunta1.Free;
          ShowMessage('Tempo Esgotado, O Servidor não Obteve Resposta');
          break;
          exit;
        end;
    end;
end;

function TNfeVenda.ConsultarNFe1(nf1 : String = '') : string;
var
  texto, nf, just : string;
begin
  carregaConfigsNFe;
  if nf1 <> '' then begin
    nf := nf1;
  end
  else begin
    nf := funcoes.dialogo('generico',0,'1234567890'+#8,50,false,'','Control For Windows','Informe o Número da Nota Fiscal Eletrônica:','');
    if nf = '*' then exit;

    nf := funcoes.StrNum(nf);
    nf := funcoes.recuperaChaveNFe(nf);
  end;

  {dm.IBselect.Close;
  dm.IBselect.SQL.Clear;
  dm.IBselect.SQL.Add('select * from nfe where nota = :nota');
  dm.IBselect.ParamByName('nota').AsString := nf;
  dm.IBselect.Open;


  if dm.IBselect.IsEmpty then
    begin
      ShowMessage('Não foi Encontrado NFe com este Número de Nota');
      dm.IBselect.Close;
      exit;
    end
  else
    begin
      nf := dm.IBselect.fieldbyname('chave').AsString;
    end;
  dm.IBselect.Close;}

  contador := 0;
  funcoes.Mensagem(Application.Title ,'Aguarde, Consultando NFe...',15,'Courier New',false,0,clred);
  Application.ProcessMessages;

  try
    ACBrNFe.NotasFiscais.Clear;
    ACBrNFe.NotasFiscais.LoadFromFile(pastaNFE_ControlW + 'NFE\EMIT\' + IfThen(Contido('-nfe', nf), nf, nf + '-nfe') + '.xml');

    ACBrNFe.Configuracoes.WebServices.Visualizar := true;
    try
      ACBrNFe.Consultar;
    except
      ACBrNFe.Configuracoes.WebServices.Visualizar := false;
      exit;
    end;


    ACBrNFe.NotasFiscais[0].GravarXML(pastaNFE_ControlW + 'NFE\EMIT\' + IfThen(Contido('-nfe', nf), nf, nf + '-nfe') + '.xml');
    ACBrNFe.Configuracoes.WebServices.Visualizar := false;

    {ShowMessage('Consulta de NFe ' + #13 +
    'Chave: ' + nf + #13 +
    'Protocolo: ' + ACBrNFe.NotasFiscais[0].NFe.procNFe.nProt + #13 +
    'Estado: '    + ACBrNFe.NotasFiscais[0].NFe.procNFe.xMotivo + #13 +
    'cStat: '     + IntToStr(ACBrNFe.NotasFiscais[0].NFe.procNFe.cStat));}
  except
    on e:exception do
      begin
        MessageDlg('ERRO: ' + e.Message + #13 + ' Tente Novamente.',
                  mtError,[mbOK],0);
        exit;
      end;
  end;

  pergunta1.Visible := false;
end;

function TNfeVenda.StatusServico : string;
var
  texto : string;
begin
  valida := false;
  texto := 'NFE.StatusServico';
  Result := '';
  if not DirectoryExists(pasta_Acbr) then
    begin
      Result  := 'ERRO: Pasta do ACBR não foi encontrada.'+ #13 + #10;
      WWMessage(Result,mtError,[mbok],HexToTColor('FFD700'),true,false,HexToTColor('B22222'));
      exit;
    end;

  contador := 0;
  DeleteFile(pasta_Acbr + 'SAI.txt');
  GravarTexto(pasta_Acbr+'ENT.txt',texto);
  funcoes.Mensagem(Application.Title ,'Aguarde, Verificando Status...',15,'Courier New',false,0,clred);
  //funcoes.Mensagem('Aguarde, Verificando Status...',0);
  while not valida do
    begin
      Application.ProcessMessages;
      if FileExists(pasta_Acbr + 'SAI.txt') then
        begin
          dadosEmitente := TStringList.Create;
          dadosEmitente.LoadFromFile(pasta_Acbr + 'SAI.txt');
          pergunta1.Visible := false;
          pergunta1.Free;
          Result := dadosEmitente.GetText;
          valida := true;
          break;
        end;
      Sleep(1500);
      contador := contador + 1;
      if contador >= 80 then
        begin
          pergunta1.Visible := false;
          pergunta1.Free;
          ShowMessage('Tempo Esgotado, O Servidor não Obteve Resposta');
          break;
          exit;
        end;
    end;
end;

function TNfeVenda.StatusServico1 : string;
var
  texto : string;
begin
  carregaConfigsNFe;
  valida := false;

  funcoes.Mensagem(Application.Title ,'Aguarde, Verificando Status...',15,'Courier New',false,0,clred);
  Application.ProcessMessages;

  try
    ACBrNFe.Configuracoes.WebServices.Visualizar := true;
    ACBrNFe.WebServices.StatusServico.Executar;

    ACBrNFe.Configuracoes.WebServices.Visualizar := False;
  except
    on e:exception do
      begin
        ShowMessage('ERRO: ' + e.Message);
        pergunta1.Visible := false;
      end;
  end;

  pergunta1.Visible := false;
end;

Function TNfeVenda.ValidarNfe(Caminho : string) : string;
var
  texto : string;
begin
  Result := '';

  valida := false;
  texto := 'NFE.ValidarNFe('+ Caminho +')';
  if not DirectoryExists(pasta_Acbr) then
    begin
      Result  := 'ERRO: Pasta do ACBR não foi encontrada.'+ #13 + #10;
      WWMessage(Result,mtError,[mbok],HexToTColor('FFD700'),true,false,HexToTColor('B22222'));
      exit;
    end;
  contador := 0;
  DeleteFile(pasta_Acbr + 'SAI.txt');
  GravarTexto(pasta_Acbr+'ENT.txt',texto);
  funcoes.Mensagem(Application.Title ,'Aguarde, Fazendo a Assinatura Digital da Nota...',15,'Courier New',false,0,clred);

  while not valida do
    begin
      Application.ProcessMessages;
        if FileExists(pasta_Acbr + 'SAI.txt') then
        begin
          dadosEmitente.Free;
          dadosEmitente := TStringList.Create;
          dadosEmitente.LoadFromFile(pasta_Acbr + 'SAI.txt');
          if (funcoes.Contido('OK',dadosEmitente.GetText)) and (not ((funcoes.Contido('ERRO:',dadosEmitente.GetText) or funcoes.Contido('Rejeicao',dadosEmitente.GetText)))) then
            begin
              pergunta1.Visible := false;
              pergunta1.Free;
              valida := true;

              dadosEmitente.Clear;
              DeleteFile(pasta_Acbr + 'SAI.txt');
              break;
            end
          else
            begin
              pergunta1.Visible := false;
              Result := '';
              if funcoes.Contido('Rejeicao', Result) then Result := 'A Nota não pode ser Transmitida: ' + #13 + #10 + RetornaValorStringList(dadosEmitente, 'Rejeicao')
               else Result := 'A Nota não pode ser Transmitida: ' + #13 + #10 + RetornaValorStringList(dadosEmitente, 'ERRO');
              WWMessage(Result,mtError,[mbok],HexToTColor('FFD700'),true,false,HexToTColor('B22222'));
              exit;
              break;
            end;
        end;
      Sleep(1500);
      contador := contador + 1;
      if contador >= 80 then
        begin
          pergunta1.Visible := false;
          pergunta1.Free;
          Result := 'Tempo Esgotado, O Servidor não Obteve Resposta';
          ShowMessage(Result);
          break;
          exit;
          contador := 0;
        end;
    end;

  if not valida then exit;

  valida := false;
  texto := 'NFE.EnviarNFe('+ Caminho +', 1,[ 0, 0 ] )';
  DeleteFile(pasta_Acbr + 'SAI.txt');
  GravarTexto(pasta_Acbr+'ENT.txt',texto);
  funcoes.Mensagem(Application.Title ,'Aguarde, Enviando Nota Fiscal Eletrônica...',15,'Courier New',false,0,clred);
 // funcoes.Mensagem('Aguarde, Enviando Nota Fiscal Eletrônica...',0);
 contador := 0;
  while not valida do
    begin
      Application.ProcessMessages;
        if FileExists(pasta_Acbr + 'SAI.txt') then
        begin
          dadosEmitente := TStringList.Create;
          dadosEmitente.LoadFromFile(pasta_Acbr + 'SAI.txt');
          //Result := dadosEmitente.GetText;
          if (funcoes.Contido('OK',dadosEmitente.GetText)) and (not ((funcoes.Contido('ERRO:',dadosEmitente.GetText) or funcoes.Contido('Rejeicao',dadosEmitente.GetText)))) then
            begin
              pergunta1.Visible := false;
              dadosDest := TStringList.Create;
              dadosDest.LoadFromFile(Caminho);
              valida := true;
              Result := '';
              dadosEmitente.Clear;
              //DeleteFile(pasta_Acbr + 'SAI.txt');
              AtualizaCfop(cod_op);
              break;
            end
          else
            begin
          {    if (funcoes.Contido('OK', dadosEmitente.GetText) and (not funcoes.Contido('NProt', dadosEmitente.GetText) and (not funcoes.Contido('Rejeicao', dadosEmitente.GetText)) then
                begin
                    //teste pra fazer
                end;
           }
              pergunta1.Visible := false;
              valida := false;
              Result := 'A Nota Fiscal Eletrônica não Pôde ser Trasmitida' + #13 + #10 + #13 + #10;
              if funcoes.Contido('Rejeicao', dadosEmitente.GetText) then Result := RetornaValorStringList(dadosEmitente, 'Rejeicao')
                 else Result := RetornaValorStringList(dadosEmitente, 'ERRO');
              WWMessage(Result,mtError,[mbok],HexToTColor('FFD700'),true,false,HexToTColor('B22222'));
              Break;
            end;
        end;
      Sleep(1500);
      contador := contador + 1;
      if contador >= 100 then
        begin
          pergunta1.Visible := false;
          pergunta1.Free;
          Result := 'Tempo Esgotado, O Servidor não Obteve Resposta';
          valida := false;
          ShowMessage(Result);
          break;
          exit;
          contador := 0;
        end;
    end;

    if not valida then exit;

    reStartGenerator('nfe', StrToInt(codNFe) + 1);
    Result := '';

    Try
      GRAVA_NODO_PROT_NFE(Caminho);
    Except
      on e : Exception do
        ShowMessage(e.Message);
    end;

    IMPRIME_NFE(Caminho);
end;

procedure TNfeVenda.Fechar_Datasets_limpar_Listas_e_variaveis;
begin
  dm.IBselect.Close;
  dm.IBQuery2.Close;
  dm.IBQuery1.Close;

  dadosEmitente.Free;
  dadosDest.Free;
  Lista_Itens.Free;
end;

function TNfeVenda.CampoString(ent : string) : string;
begin
  Result := '';
  Result := trim(STR_ALFA(ent));
end;

FUNCTION TNfeVenda.NODO_TRANSP(var FRETE1 : TStringList) : string;
var
  CPF_CNPJ, veiculo, VOL, iesTransp : string;
begin
  VOL := '<vol>' + NODOXML('qVol', FRETE1.Values['13']) +
  NODOXML('esp', FRETE1.Values['14']) + NODOXML('marca', FRETE1.Values['15']) +
  NODOXML('nVol', FRETE1.Values['18']) +
  NODOXML('pesoB', FORMAT_NUM(StrToCurrDef(FRETE1.Values['17'], 0))) +
  NODOXML('pesoL', FORMAT_NUM(StrToCurrDef(FRETE1.Values['16'], 0))) + '</vol>';

  IF tipo_frete = 9 then
    begin
      Result := '<transp><modFrete>9</modFrete>'+vol+'</transp>';
      exit;
    end;

  CPF_CNPJ := iif(FRETE1.Values['2'] = '1', '<CPF>' + funcoes.STRNUM(FRETE1.Values['3']) + '</CPF>', '<CNPJ>' + funcoes.STRNUM(FRETE1.Values['3']) + '</CNPJ>');

  iesTransp := funcoes.STRNUM(FRETE1.Values['5']);
  if length(iesTransp) < 5 then iesTransp := '';

  VEICULO := '';
  //if usaNFe4ouMaior = false then begin
    VEICULO := iif(length(Trim(FRETE1.Values['11'])) >= 7, '<veicTransp><placa>' + FRETE1.Values['11'] +
    '</placa><UF>' + FRETE1.Values['12'] + '</UF>'+ IfThen(length(TRIM(FRETE1.Values['10'])) = 0, '', '<RNTC>' + iif(length(TRIM(FRETE1.Values['10'])) = 0, '0', TRIM(FRETE1.Values['10'])) +'</RNTC>') +
    '</veicTransp>', '');
  //end;

  if usaNFe4ouMaior and (UF_EMI <> UF_DEST) then begin
    VEICULO := '';
  end;



  Result := '<transp><modFrete>' + TRIM(IntToStr(tipo_frete)) + '</modFrete><transporta>' +
  CPF_CNPJ + '<xNome>' + removeCarateresEspeciais(TRIM(FRETE1.Values['1'])) + '</xNome>' + IfThen(funcoes.STRNUM(FRETE1.Values['5']) <> '', '<IE>' + iesTransp + '</IE>', '') +
  '<xEnder>' + TRIM(FRETE1.Values['6']) + '</xEnder>' + '<xMun>' + removeCarateresEspeciais(TRIM(FRETE1.Values['7'])) + '</xMun>' +
  '<UF>' + FRETE1.Values['8'] + '</UF>' + '</transporta>' + VEICULO + VOL +  '</transp>';
end;

Function TNfeVenda.NODOXML(NOME, CONTEUDO : string) : string;
begin
  Result := '';
  Result := '<' + NOME + '>' + TRIM(CONTEUDO) + '</' + NOME + '>';
end;


FUNCTION TNfeVenda.NODO_TOTAL(TOTNOTA, TOT_BASEICM, TOT_ICM, TOT_PIS, TOT_COFINS, TOTDESCICM, TOTDESC : currency) : string;
begin
  TOTDESCICM := 0; vst :=0;

  Result := '<total><ICMSTot><vBC>' + FORMAT_NUM(TOT_BASEICM) + '</vBC><vICMS>' + FORMAT_NUM(TOT_ICM) +
  '</vICMS><vBCST>0.00</vBCST><vST>'+Format_num(vst)+'</vST><vProd>' + FORMAT_NUM(TOTNOTA) +
  '</vProd><vFrete>'+ Format_num(TotalFrete) +'</vFrete><vSeg>0.00</vSeg><vDesc>' + FORMAT_NUM(TOTDESCICM + TOTDESC) + '</vDesc>' +
  '<vII>0.00</vII><vIPI>0.00</vIPI><vPIS>' + FORMAT_NUM(TOT_PIS) + '</vPIS><vCOFINS>' +
  FORMAT_NUM(TOT_COFINS) + '</vCOFINS><vOutro>'+FORMAT_NUM(VLR_DESP)+'</vOutro><vNF>' + FORMAT_NUM(TOTNOTA - TOTDESC - TOTDESCICM + iif(tipo_frete <> 9, TotalFrete, 0) + VLR_DESP) +
  '</vNF><vICMSUFDest>'+FORMAT_NUM(TOTvICMSUFDest)+'</vICMSUFDest><vICMSUFRemet>'+FORMAT_NUM(TOTvICMSUFRemet)+'</vICMSUFRemet></ICMSTot></total>';

  totalNota := TOTNOTA - TOTDESC - TOTDESCICM + iif(tipo_frete <> 9, TotalFrete, 0) + VLR_DESP;
  //ShowMessage(CurrToStr(TOTNOTA) + #13 + CurrToStr(TOTDESCICM) + #13 + CurrToStr(totDesc));
end;

FUNCTION tnfevenda.NODO_PISCOFINS(var item1 : Item_venda; CSTPIS_CFOP : string) : string;
VAR
   COF_ALIQ, PIS_ALIQ : string;
  tot, VLR_COFINS, VLR_PIS : currency;
begin
  TOT := item1.total - item1.Desconto;
  //SE FOR OPTANTE DO SIMPLES NACIONAL, NAO USA TAG PIS/COFINS
  IF (Contido(ConfParamGerais.Strings[10], '1-2')) and (trim(item1.Pis) = '')  then begin
    Result := '<PIS><PISAliq><CST>01</CST><vBC>0.00</vBC><pPIS>0.00</pPIS>' +
    '<vPIS>0.00</vPIS></PISAliq></PIS>' +
    '<COFINS><COFINSAliq><CST>01</CST><vBC>0.00</vBC>' +
    '<pCOFINS>0.00</pCOFINS><vCOFINS>0.00</vCOFINS></COFINSAliq></COFINS>';
    exit;
  end;

  PIS_ALIQ := '<PISAliq><CST>02</CST><vBC>' + FORMAT_NUM(TOT) + '</vBC><pPIS>0.00</pPIS>' +
  '<vPIS>0.00</vPIS></PISAliq>';
  COF_ALIQ := '<COFINSAliq><CST>02</CST><vBC>' + FORMAT_NUM(TOT) + '</vBC>' +
  '<pCOFINS>0.00</pCOFINS><vCOFINS>0.00</vCOFINS></COFINSAliq>';

  //SE O CFOP E ISENTO DE PIS/COFINS
  IF CSTPIS_CFOP = 'I' then
    begin
      PIS_NT := PIS_NT + TOT;
      Result := '<PIS>' + PIS_ALIQ + '<PISNT><CST>07</CST></PISNT></PIS>' +
      '<COFINS>' + COF_ALIQ + '<COFINSNT><CST>07</CST></COFINSNT></COFINS>';
      exit;
    end;

  //SE O CFOP NAO E TRIBUTADO POR PIS/COFINS
  IF CSTPIS_CFOP = 'N' then
    begin
      PIS_NT := PIS_NT + TOT;
      Result := '<PIS>' + PIS_ALIQ + '<PISNT><CST>06</CST></PISNT></PIS>' +
      '<COFINS>' + COF_ALIQ + '<COFINSNT><CST>06</CST></COFINSNT></COFINS>' ;
      exit;
    end;

   //SE O CFOP TEM  A ALIQ RED. A ZERO DE PIS/COFINS
   IF CSTPIS_CFOP = 'R' then
     begin
       PIS_NT := PIS_NT + TOT;
       Result := '<PIS><PISAliq><CST>02</CST><vBC>' + FORMAT_NUM(TOT) + '</vBC><pPIS>0.00</pPIS>' +
       '<vPIS>0.00</vPIS></PISAliq></PIS>'  +
       '<COFINS><COFINSAliq><CST>02</CST><vBC>' + FORMAT_NUM(TOT) + '</vBC>' +
       '<pCOFINS>0.00</pCOFINS><vCOFINS>0.00</vCOFINS></COFINSAliq></COFINS>';
       exit;
     end;

   //SE O CFOP NAO E TRIBUTADO POR PIS/COFINS
   IF CSTPIS_CFOP = 'M' then
     begin
       PIS_NT := PIS_NT + TOT;
       Result := '<PIS>' + '<PISNT><CST>04</CST></PISNT></PIS>' +
       '<COFINS>' + '<COFINSNT><CST>04</CST></COFINSNT></COFINS>';
       exit;
     end;

   //SE O CFOP E ISENTO DE PIS/COFINS
   IF CSTPIS_CFOP = 'X' then
     begin
       PIS_NT := PIS_NT + TOT;
       Result := '<PIS><PISNT><CST>08</CST></PISNT></PIS>' +
       '<COFINS><COFINSNT><CST>08</CST></COFINSNT></COFINS>';
       exit;
    end;

    //SE O CFOP TEM ALIQ DIFERENCIADA
    IF CSTPIS_CFOP = 'D' then
     begin
       PIS_NT := PIS_NT + TOT;
       Result := '<PIS><PISAliq><CST>02</CST><vBC>' + FORMAT_NUM(TOT) + '</vBC><pPIS>0.00</pPIS>' +
       '<vPIS>' + Format_num(0.00) + '</vPIS></PISAliq></PIS>'  +
       '<COFINS><COFINSAliq><CST>02</CST><vBC>' + FORMAT_NUM(TOT) + '</vBC>' +
       '<pCOFINS>0.00</pCOFINS><vCOFINS>' + Format_num(0.00) + '</vCOFINS></COFINSAliq></COFINS>';
       exit;
     end;

   //CFOP - SE JA RECOLHEU PIS/COFINS POR SUBSTITUICAO TRIBUTARIA
   IF CSTPIS_CFOP = 'S' then
     begin
       VLR_PIS := arrendondaNFe(item1.Total_Preco_Compra * TRIB_ALIQ_PIS /100, 2);
       VLR_COFINS := arrendondaNFe(item1.Total_Preco_Compra * TRIB_ALIQ_COFINS /100, 2);
       PIS_ST := PIS_ST + VLR_PIS;
       COFINS_ST := COFINS_ST + VLR_COFINS;
       Result := '<PIS>' + PIS_ALIQ + '<PISST><vBC>' + FORMAT_NUM(item1.Total_Preco_Compra) + '</vBC>' +
       '<pPIS>' + FORMAT_NUM(TRIB_ALIQ_PIS) + '</pPIS>' +
       '<vPIS>' + FORMAT_NUM(VLR_PIS) + '</vPIS></PISST></PIS>' +
       '<COFINS>' + COF_ALIQ + '<COFINSST><vBC>' + FORMAT_NUM(item1.Total_Preco_Compra) + '</vBC>' +
       '<pCOFINS>' + FORMAT_NUM(TRIB_ALIQ_COFINS) + '</pCOFINS>' +
       '<vCOFINS>' + FORMAT_NUM(VLR_COFINS) + '</vCOFINS></COFINSST></COFINS>';
       exit;
     end;

   IF ((item1.Pis = 'M') and (length(strnum(item1.codISPIS)) = 3)) then
     begin
       PIS_NT := PIS_NT + TOT;
       Result := '<PIS>' + '<PISNT><CST>04</CST></PISNT></PIS>' +
       '<COFINS>' + '<COFINSNT><CST>04</CST></COFINSNT></COFINS>';
       exit;
     end;


   //SE O PRODUTO E ISENTO DE PIS/COFINS
   IF ((item1.Pis = 'I') and (length(strnum(item1.codISPIS)) = 3)) then
     begin
       PIS_NT := PIS_NT + TOT;
       Result := '<PIS>'  + '<PISNT><CST>07</CST></PISNT></PIS>' +
       '<COFINS>'  + '<COFINSNT><CST>07</CST></COFINSNT></COFINS>' ;
       exit;
     end;

   //SE O PRODUTO NAO E TRIBUTADO POR PIS/COFINS
   IF ((item1.Pis = 'N') and (length(strnum(item1.codISPIS)) = 3)) then
     begin
       PIS_NT := PIS_NT + TOT;
       Result := '<PIS>'  + '<PISNT><CST>06</CST></PISNT></PIS>' +
       '<COFINS>'  + '<COFINSNT><CST>06</CST></COFINSNT></COFINS>';
       exit;
     end;

   //SE O PRODUTO TEM  A ALIQ RED. A ZERO DE PIS/COFINS
   IF ((item1.Pis = 'R') and (length(strnum(item1.codISPIS)) = 3)) then
     begin
       PIS_NT := PIS_NT + TOT;
       Result := '<PIS>' + '<PISNT><CST>06</CST></PISNT></PIS>' +
       '<COFINS>' + '<COFINSNT><CST>06</CST></COFINSNT></COFINS>' ;
       exit;
     end;

   IF ((item1.Pis = 'X') and (length(strnum(item1.codISPIS)) = 3)) then
     begin
       PIS_NT := PIS_NT + TOT;
       Result := '<PIS>' + '<PISNT><CST>08</CST></PISNT></PIS>' +
       '<COFINS>' + '<COFINSNT><CST>08</CST></COFINSNT></COFINS>' ;
       exit;
     end;

   //PRODUTO - SE JA RECOLHEU PIS/COFINS POR SUBSTITUICAO TRIBUTARIA
   IF item1.Pis = 'S' then
     begin
       VLR_PIS := arrendondaNFe(item1.Total_Preco_Compra * TRIB_ALIQ_PIS /100, 2);
       VLR_COFINS := arrendondaNFe(item1.Total_Preco_Compra * TRIB_ALIQ_COFINS /100, 2);
       PIS_ST := PIS_ST + VLR_PIS;
       COFINS_ST := COFINS_ST + VLR_COFINS;

       Result :=  '<PIS>' + PIS_ALIQ + '<PISST><vBC>' + FORMAT_NUM(item1.Total_Preco_Compra) + '</vBC>' +
       '<pPIS>' + FORMAT_NUM(TRIB_ALIQ_PIS) + '</pPIS>' +
       '<vPIS>' + FORMAT_NUM(VLR_PIS) + '</vPIS></PISST></PIS>' +
       '<COFINS>' + COF_ALIQ + '<COFINSST><vBC>' + FORMAT_NUM(item1.Total_Preco_Compra) + '</vBC>' +
       '<pCOFINS>' + FORMAT_NUM(TRIB_ALIQ_COFINS) + '</pCOFINS>' +
       '<vCOFINS>' + FORMAT_NUM(VLR_COFINS) + '</vCOFINS></COFINSST></COFINS>' ;
       exit;
     end;

   try
     TRIB_ALIQ_PIS := StrToCurr(ConfParamGerais.Strings[11]);
     TRIB_ALIQ_COFINS := StrToCurr(ConfParamGerais.Strings[12])
   except
     TRIB_ALIQ_COFINS := 0;
     TRIB_ALIQ_COFINS := 0;
   end;
   //REGIME NORMAL - RECOLHIMENTO DE PIS E COFINS
   //CALCULA PIS/COFINS SOBRE O VALOR DO PRODUTO - DESCONTO
   VLR_PIS := arrendondaNFe(TOT * TRIB_ALIQ_PIS /100, 2);
   TOT_PIS := TOT_PIS + VLR_PIS;
   VLR_COFINS := arrendondaNFe(TOT * TRIB_ALIQ_COFINS /100, 2);
   TOT_COFINS := TOT_COFINS + VLR_COFINS;
   Result := '<PIS><PISAliq><CST>01</CST><vBC>' + FORMAT_NUM(TOT) + '</vBC>' +
   '<pPIS>' + FORMAT_NUM(TRIB_ALIQ_PIS) + '</pPIS>' +
   '<vPIS>' + FORMAT_NUM(VLR_PIS) +
   '</vPIS></PISAliq></PIS>' +
   '<COFINS><COFINSAliq><CST>01</CST><vBC>' + FORMAT_NUM(TOT) + '</vBC>' +
   '<pCOFINS>' + FORMAT_NUM(TRIB_ALIQ_COFINS) + '</pCOFINS>' +
   '<vCOFINS>' + FORMAT_NUM(VLR_COFINS) +
   '</vCOFINS></COFINSAliq></COFINS>';
end;

FUNCTION TNfeVenda.NODO_ICMS(var MAT : Item_venda; CSTICM_CFOP, _ORIGE : string) : string;
var
  tot, icms : currency;
begin
  tot := mat.total - mat.Desconto;
  Result := '';
  item.base_icm := 0;
  //se a empresa é optante do simples nacional
  //if (ConfParamGerais.Strings[10] = '1') and (FIN_NFE1 <> '4') then
  if (ConfParamGerais.Strings[10] = '1') then
    begin
      if ((FIN_NFE1 = '4') and (indIEDest <> '9')) then begin
        icms := item.PercICMS;
        icms := menor(ALIQ_INTEREST(UF_DEST), icms);

        Result := '<ICMS><ICMSSN101><orig>' + _ORIGE + '</orig><CSOSN>101</CSOSN>' +
        '<pCredSN>'+FORMAT_NUM(icms)+'</pCredSN>' +
        '<vCredICMSSN>'+FORMAT_NUM(tot * (icms / 100))+'</vCredICMSSN>' +
        '</ICMSSN101></ICMS>';

        ICMSSN := ICMSSN + (tot * (icms / 100));
        exit;
      end;

      //EXPORTAÇÃO - CSOSN = 300
      IF funcoes.Contido(LeftStr(cod_OP, 1), '4-7') then
        begin
          Result := '<ICMS><ICMSSN102><orig>' + _ORIGE + '</orig><CSOSN>300</CSOSN></ICMSSN102></ICMS>';
          exit;
        end;

      if mat.CodAliq = 10 then begin
          if usaNFe4ouMaior then begin
            Result := '<ICMS><ICMSSN500><orig>' + _ORIGE + '</orig><CSOSN>500</CSOSN>' +
            '<vBCSTRet>' + FORMAT_NUM(mat.p_compra) + '</vBCSTRet>' +
            '<pST>0.16</pST>' +
            '<vICMSSTRet>' + FORMAT_NUM(arrendondaNFe(mat.p_compra * 0.16, 2)) + '</vICMSSTRet>' +
            '</ICMSSN500></ICMS>';
          end
          else begin
            Result := '<ICMS><ICMSSN500><orig>' + _ORIGE + '</orig><CSOSN>500</CSOSN>' +
            '<vBCSTRet>' + FORMAT_NUM(mat.p_compra) + '</vBCSTRet>' +
            '<vICMSSTRet>' + FORMAT_NUM(arrendondaNFe(mat.p_compra * 0.16, 2)) + '</vICMSSTRet>' +
            '</ICMSSN500></ICMS>';
          end;

         exit;
      end;

      if mat.CodAliq = 11 then
        begin
          Result := '<ICMS><ICMSSN102><orig>' + _ORIGE + '</orig><CSOSN>400</CSOSN></ICMSSN102></ICMS>';
          exit;
        end;

      if mat.CodAliq = 12 then
        begin
          Result := '<ICMS><ICMSSN102><orig>' + _ORIGE + '</orig><CSOSN>300</CSOSN></ICMSSN102></ICMS>';
          exit;
        end;

      if mat.Reducao <> 0 then
        begin
          Result := '<ICMS><ICMSSN900><orig>' + _ORIGE + '</orig><CSOSN>900</CSOSN><modBC>3</modBC>' +
          '<vBC>' + FORMAT_NUM(arrendondaNFe(tot * mat.Reducao / 100, 2)) + '</vBC>' +
          '<pRedBC>' + FORMAT_NUM(item.Reducao) + '</pRedBC>' +
          '<pICMS>' + FORMAT_NUM(item.p_venda) + '</pICMS>' +
          '<vICMS>' + FORMAT_NUM(0) + '</vICMS>' +
          '<modBCST>0.00</modBCST><vBCST>0.00</vBCST>' +
          '<pICMSST>0.00</pICMSST><vICMSST>0.00</vICMSST>' +
          '<pCredSN>0.00</pCredSN><vCredICMSSN>0.00</vCredICMSSN>' +
          '</ICMSSN900></ICMS>' ;
          exit;
        end;

      //TRIBUTACAO NORMAL PELO SIMPLES NACIONAL
      Result := '<ICMS><ICMSSN102><orig>' + _ORIGE + '</orig><CSOSN>102</CSOSN></ICMSSN102></ICMS>';
      exit;
    end;

  //EXPORTAÇÃO - CST = 41
  IF funcoes.Contido(LeftStr(cod_OP, 1), '4-7') then
    begin
      Result := '<ICMS><ICMS40><orig>' + _ORIGE + '</orig><CST>41</CST></ICMS40></ICMS>';
      exit;
    end;

  //CFOP SUBSTITUICAO TRIBUTARIA
  IF CSTICM_CFOP = 'S' then
    begin
      Result := '<ICMS><ICMS60><orig>' + _ORIGE + '</orig><CST>60</CST>' +
      '<vBCSTRet>' + FORMAT_NUM(item.Total_Preco_Compra) + '</vBCSTRet>' +
      '<vICMSSTRet>' + FORMAT_NUM(arrendondaNFe(item.Total_Preco_Compra * 0.16, 2)) + '</vICMSSTRet>' +
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
      item.Reducao := 0;
      item.PercICMS := 0;
      item.VlrICMS := 0;
      BASE_ICM := TOT;
      VLR_ICM := 0;
      TOTICM := VLR_ICM;
      TOT_BASEICM := BASE_ICM;

      item.base_icm := BASE_ICM;

      Result := '<ICMS><ICMS20><orig>' + _ORIGE + '</orig><CST>20</CST><modBC>3</modBC>' +
      '<pRedBC>' + FORMAT_NUM(item.Reducao) + '</pRedBC>' +
      '<vBC>' + FORMAT_NUM(item.DescICMS) + '</vBC>' +
      '<pICMS>' + FORMAT_NUM(item.PercICMS) + '</pICMS>' +
      '<vICMS>' + FORMAT_NUM(item.VlrICMS) + '</vICMS></ICMS20></ICMS>';
      exit;
    end;

//TRIBUTACAO DO ICMS EM REGIME NORMAL
//PRODUTO SUBSTITUICAO TRIBUTARIA
IF item.CodAliq = 10 then
  begin
    if usaNFe4ouMaior then begin
      Result := '<ICMS><ICMS60><orig>' + _ORIGE + '</orig><CST>60</CST>' +
      '<vBCSTRet>' + FORMAT_NUM(item.p_compra) + '</vBCSTRet>' +
      '<vICMSSTRet>' + FORMAT_NUM(arrendondaNFe(item.p_compra * 0.16, 2)) + '</vICMSSTRet>' +
      '<pST>16.00</pST></ICMS60></ICMS>';
    end
    else begin
      Result := '<ICMS><ICMS60><orig>' + _ORIGE + '</orig><CST>60</CST>' +
      '<vBCSTRet>' + FORMAT_NUM(item.p_compra) + '</vBCSTRet>' +
      '<vICMSSTRet>' + FORMAT_NUM(arrendondaNFe(item.p_compra * 0.16, 2)) + '</vICMSSTRet>' +
      '</ICMS60></ICMS>';
    end;

    //ShowMessage(Result);
    exit;
  end;

//PRODUTO ISENTO
IF item.CodAliq = 11 then
  begin
   Result := '<ICMS><ICMS40><orig>' + _ORIGE + '</orig><CST>40</CST></ICMS40></ICMS>';
   exit;
  end;

//PRODUTO NAO SE APLICA ICM
IF item.CodAliq = 12 then
  begin
   Result := '<ICMS><ICMS40><orig>' + _ORIGE + '</orig><CST>41</CST></ICMS40></ICMS>';
   exit;
  end;

//PRODUTO TRIBUTADO COM REDUCAO NA BASE DE CALCULO
IF mat.Reducao <> 0 then begin
    BASE_ICM := arrendondaNFe(TOT - (TOT * mat.Reducao / 100), 2);
    VLR_ICM := arrendondaNFe(BASE_ICM * ITEM.PercICMS / 100, 2);
    TOTICM := TOTICM + VLR_ICM;
    TOT_BASEICM := TOT_BASEICM + BASE_ICM;
    item.base_icm := BASE_ICM;
    Result := '<ICMS><ICMS20><orig>' + _ORIGE + '</orig><CST>20</CST><modBC>3</modBC>' +
    '<pRedBC>' + FORMAT_NUM(item.Reducao) + '</pRedBC>' +
    '<vBC>' + FORMAT_NUM(BASE_ICM) + '</vBC>' +
    '<pICMS>' + FORMAT_NUM(item.PercICMS) + '</pICMS>' +
    '<vICMS>' + FORMAT_NUM(VLR_ICM) + '</vICMS></ICMS20></ICMS>';
    exit;
  end;

  //TRIBUTADO INTEGRAL
  BASE_ICM := tot;
  item.base_icm := BASE_ICM;
  VLR_ICM := arrendondaNFe(BASE_ICM * mat.PercICMS / 100, 2);
  TOTICM := TOTICM + VLR_ICM;
  TOT_BASEICM := TOT_BASEICM + BASE_ICM;
  Result := '<ICMS><ICMS00><orig>' + _ORIGE + '</orig><CST>00</CST><modBC>3</modBC>' +
   '<vBC>' + FORMAT_NUM(BASE_ICM) + '</vBC>' +
   '<pICMS>' + FORMAT_NUM(mat.PercICMS) + '</pICMS>' +
   '<vICMS>' + FORMAT_NUM(VLR_ICM) + '</vICMS></ICMS00></ICMS>';
end;

FUNCTION TNfeVenda.NODO_ITENS(var lista : tlist; CFOP, POS, CSTICM_CFP, CSTPIS_CFP, _ORIGE : string) : string;
var
  barras, cfop1, infAdProd : string;
  cont,i : integer;
begin
  CSTPIS_CFP := ConfParamGerais.Strings[10];
  Result := '';
  qtd := 0;
  cont := lista.Count -1;
  for i := 0 to cont do
    begin
      cfop1 := CFOP;
      qtd := qtd + 1;
      item := Lista.Items[i];

      {if ((item.CodAliq = 10) and (cfop1 = '5102')) then begin
        cfop1 := '5405';
        if (FIN_NFE1 = '4') then cfop1 := '5411';
      end;

      if ((item.CodAliq = 10) and (cfop1 = '6102')) then begin
        cfop1 := '6404';
        if (FIN_NFE1 = '4') then cfop1 := '6411';
      end;}

      if (item.CodAliq = 10) then begin
        if funcoes.buscaParamGeral(86, 'S') = 'S' then begin
          if (cfop1 = '5102') then cfop1 := '5405';
          if (cfop1 = '6102') then cfop1 := '6404';

          //se a nota for devolução e de saida
          if ((FIN_NFE1 = '4') and (tipo = 'S')) then begin
            if (LeftStr(cfop1, 1) = '5') then cfop1 := '5411';
            if (LeftStr(cfop1, 1) = '6') then cfop1 := '6411';
          end;
        end;
      end;

      barras := item.codbar;
      if length(barras) <> 13 then barras := '';

      if ((usaNFe4ouMaior) and (LeftStr(barras, 3) <> '789')) then barras := 'SEM GTIN';

      infAdProd := '';

      if funcoes.buscaParamGeral(95, 'N') = 'S' then begin
        if trim(item.obs) <> '' then infAdProd := '<infAdProd>'+item.obs+'</infAdProd>';
      end;

      Result := Result + '<det nItem=' + LITERAL(TRIM(IntToStr(qtd))) + '><prod>' +
      '<cProd>' + strzero(IntToStr(item.cod), 6) + '</cProd><cEAN>' + barras + '</cEAN>' +
      '<xProd>' + CampoString(item.nome) + '</xProd><NCM>' + item.Ncm + '</NCM>'+ve_cest(item.CodAliq, item.Ncm)+'<CFOP>' + CFOP1 + '</CFOP>' +
      '<uCom>' + removeCarateresEspeciais(item.unid) + '</uCom><qCom>' + Format_num(item.quant, 4) + '</qCom><vUnCom>' +
      Format_num(item.p_venda, 8) + '</vUnCom><vProd>' + FORMAT_NUM(item.total) + '</vProd><cEANTrib>'+ barras +'</cEANTrib>' +
      '<uTrib>' + ve_unidTributavel(DEST_NFE, item.Ncm, item.unid) + '</uTrib><qTrib>' + Format_num(item.quant, 4) + '</qTrib><vUnTrib>' +
      Format_num(item.p_venda, 8) + '</vUnTrib>'+ IfThen(item.Vlr_Frete > 0, '<vFrete>'+ Format_num(item.Vlr_Frete)+'</vFrete>', '') + iif(item.Desconto = 0,'','<vDesc>' + FORMAT_NUM(item.Desconto) + '</vDesc>') +
      IfThen(item.DespAcessorias > 0 ,'<vOutro>' + FORMAT_NUM(item.DespAcessorias) + '</vOutro>', '')+'<indTot>1</indTot></prod><imposto>' + NODO_ICMS(item, cstIcmCfop, _ORIGE) + NODO_PISCOFINS(item, cstpisCfop) + NODO_ICMS_UF_DEST(item) + '</imposto>' +
      infAdProd +'</det>'; //NODO_PISCOFINS(MAT, CSTPIS_CFP)

      {Result := Result + '<det nItem=' + LITERAL(TRIM(IntToStr(qtd))) + '><prod>' +
      '<cProd>' + strzero(IntToStr(item.cod), 6) + '</cProd><cEAN>' + barras + '</cEAN>' +
      '<xProd>' + CampoString(item.nome) + '</xProd><NCM>' + item.Ncm + '</NCM>'+ve_cest(item.CodAliq, item.Ncm)+'<CFOP>' + CFOP1 + '</CFOP>' +
      '<uCom>' + removeCarateresEspeciais(item.unid) + '</uCom><qCom>' + FormatCurr('0.0000',item.quant) + '</qCom><vUnCom>' +
      FormatCurr('0.00000000',item.p_venda) + '</vUnCom><vProd>' + FORMAT_NUM(item.total) + '</vProd><cEANTrib></cEANTrib>' +
      '<uTrib>' + item.unid + '</uTrib><qTrib>' + FormatCurr('0.0000',item.quant) + '</qTrib><vUnTrib>' +
      FormatCurr('0.00000000',item.p_venda) + '</vUnTrib>'+ '<vFrete>'+ Format_num(item.Vlr_Frete) +'</vFrete>' + iif(item.Desconto = 0,'<vDesc>0.00</vDesc>','<vDesc>' + FORMAT_NUM(item.Desconto) + '</vDesc>') +
      '<vOutro>' + FORMAT_NUM(item.DespAcessorias) + '</vOutro><indTot>1</indTot></prod><imposto>' + NODO_ICMS(item, cstIcmCfop, _ORIGE) + NODO_PISCOFINS(item, cstpisCfop) + NODO_ICMS_UF_DEST(item) + '</imposto></det>'; //NODO_PISCOFINS(MAT, CSTPIS_CFP)}
    end;
end;

Procedure TNfeVenda.LerDados_Emit_Dest(codDest : string);
 var i : integer;
begin
  dm.IBselect.Close;
  dm.IBselect.SQL.Clear;
  dm.IBselect.SQL.Add('select * from registro');
  dm.IBselect.Open;

  dadosEmitente := TStringList.Create;
  dadosDest := TStringList.Create;

  if recuperando = true then codNFe := Incrementa_Generator('nfe', 0);

  dadosEmitente.Values['cod_mun'] := dm.IBselect.fieldbyname('cod_mun').AsString;
  dadosEmitente.Values['ies']     := funcoes.StrNum(dm.IBselect.fieldbyname('ies').AsString);
  dadosEmitente.Values['razao']   := dm.IBselect.fieldbyname('nome').AsString;
  dadosEmitente.Values['empresa'] := trim(dm.IBselect.fieldbyname('empresa').AsString);
  dadosEmitente.Values['cnpj']    := funcoes.StrNum(dm.IBselect.fieldbyname('cnpj').AsString);
  dadosEmitente.Values['est']     := dm.IBselect.fieldbyname('est').AsString;
  dadosEmitente.Values['ende']    := dm.IBselect.fieldbyname('ende').AsString;
  dadosEmitente.Values['bairro']  := removeCarateresEspeciais(dm.IBselect.fieldbyname('bairro').AsString);
  dadosEmitente.Values['cep']     := funcoes.StrNum(dm.IBselect.fieldbyname('cep').AsString);
  dadosEmitente.Values['telres']  := funcoes.StrNum(dm.IBselect.fieldbyname('telres').AsString);
  dadosEmitente.Values['cid']     := dm.IBselect.fieldbyname('cid').AsString;
  dadosEmitente.Values['nf']      := codNFe;
  nfeTemp := codNFe;

  dm.IBselect.Close;
  dm.IBselect.SQL.Clear;
  dm.IBselect.SQL.Add('select * from cliente where cod = :cod');
  dm.IBselect.ParamByName('cod').AsString := codDest;
  dm.IBselect.Open;

  dadosDest.Values['cod_mun'] := IfThen(trim(dm.IBselect.fieldbyname('cod_mun').AsString) = '', dadosEmitente.Values['cod_mun'], trim(dm.IBselect.fieldbyname('cod_mun').AsString));
  dadosDest.Values['tipo']    := trim(dm.IBselect.fieldbyname('tipo').AsString);
  dadosDest.Values['cnpj']    := funcoes.StrNum(dm.IBselect.fieldbyname('cnpj').AsString);

  IF ((Length(dadosDest.Values['cnpj']) = 11) OR (DEST_NFE = '2')) THEN
    BEGIN
      tipoPessoa := 'F';
      IND_FINAL  := '1';
    END
    ELSE IND_FINAL := '0';

  dadosDest.Values['nome']    := trim(dm.IBselect.fieldbyname('nome').AsString);
  dadosDest.Values['ende']    := trim(dm.IBselect.fieldbyname('ende').AsString);
  dadosDest.Values['est']     := trim(dm.IBselect.fieldbyname('est').AsString);
  dadosDest.Values['bairro']  := removeCarateresEspeciais(dm.IBselect.fieldbyname('bairro').AsString);
  dadosDest.Values['cep']     := funcoes.StrNum(dm.IBselect.fieldbyname('cep').AsString);
  dadosDest.Values['telres']  := funcoes.StrNum(dm.IBselect.fieldbyname('telres').AsString);
  dadosDest.Values['cid']     := trim(dm.IBselect.fieldbyname('cid').AsString);
  dadosDest.Values['ies']     := StrNum(trim(dm.IBselect.fieldbyname('ies').AsString));
  if dadosDest.Values['ies'] = '0' then dadosDest.Values['ies'] := '';

  IF ((Length(dadosDest.Values['cnpj']) = 14) and (length(dadosDest.Values['ies']) < 6)) then begin
    tipoPessoa := 'J';
    IND_FINAL  := '1';
  end;

  dm.IBselect.Close;
end;

FUNCTION TNfeVenda.NODO_DEST(TIPO, CPF, CNPJ, NOME, ENDE, BAIRRO, COD_MUN, NOM_MUN, UF, CEP, FONE, IE, CODMUN_EMI : String) : string;
var
  CPF_CNPJ, idEstrangeiro, tmp, xpais : string;
begin
  tmp := IE;
  if codPaisDest = '' then codPaisDest := '1058';
  INVALIDO := 0;
  tipo := Trim(tipo);
  cpf := StrNum(cpf);
  IF Length(StrNum(cpf)) = 11 then
    begin
      OK := funcoes.testacpf(CPF);
      if codPaisDest = '1058' then
        begin
          if TIPO = '1' then IE := '';

        end;

      CPF_CNPJ := '<CPF>' + CPF + '</CPF>';
    end
  ELSE
    begin
      OK := VALIDACNPJ(CNPJ);
      CPF_CNPJ := '<CNPJ>' + CNPJ + '</CNPJ>';
    end;

  if True then


  //SE O CODIGO DO MUNICIPIO ESTA EM BRANCO, USA O CODIGO DO MUNICIPIO DO EMITENTE
  IF (COD_MUN = '') then COD_MUN := CODMUN_EMI;

  IF NOT OK then ERRO_DADOS := ' CPF/CNPJ do Destinatário Inválido ' + #13;

  {if DEST_NFE <> '2' then begin
  if CAMPO_VAZIO(ENDE) > 0 then begin
    ERRO_dados := ERRO_dados + 'Endereço Inválido ' + #13;
    INVALIDO := invalido + 1;
  end;

  if LENGTH(BAIRRO) < 2 then begin
    ERRO_dados := ERRO_dados + 'Bairro Inválido ' + #13;
    INVALIDO := invalido + 1;
  end;
  if CAMPO_VAZIO(COD_MUN) > 0 then begin
    ERRO_dados := ERRO_dados + 'Código do Municipio Inválido ' + #13;
    INVALIDO := invalido + 1;
  end;
  if CAMPO_VAZIO(NOM_MUN) > 0 then begin
    ERRO_dados := ERRO_dados + 'Nome do Municipio Inválido ' + #13;
    INVALIDO := invalido + 1;
  end;
  if CAMPO_VAZIO(UF) > 0 then begin
    ERRO_dados := ERRO_dados + 'UF Inválida ' + #13;
    INVALIDO := invalido + 1;
  end;
  if CAMPO_VAZIO(CEP) > 0 then begin
    ERRO_dados := ERRO_dados + 'CEP Inválido ' + #13;
    INVALIDO := invalido + 1;
  end;
  end;     }

  {if Length(FONE) < 6 then begin
    ERRO_dados := ERRO_dados + 'TELEFONE Inválido ' + #13;
    INVALIDO := invalido + 1;
  end;}

  {INVALIDO := invalido + CAMPO_VAZIO(BAIRRO);
  INVALIDO := invalido + CAMPO_VAZIO(COD_MUN);
  INVALIDO := invalido + CAMPO_VAZIO(NOM_MUN);
  INVALIDO := invalido + CAMPO_VAZIO(UF);
  INVALIDO := invalido + CAMPO_VAZIO(CEP);}
  IF INVALIDO <> 0 then
    begin
      ERRO_DADOS := 'Dados do DESTINATÁRIO Incompletos ' + #13 + #13 + ERRO_DADOS;
      exit;
    end;

  {INVALIDO := INVALIDO + CAMPO_VAZIO(ENDE);
  INVALIDO := INVALIDO + CAMPO_VAZIO(BAIRRO);
  INVALIDO := INVALIDO + CAMPO_VAZIO(COD_MUN);
  INVALIDO := INVALIDO + CAMPO_VAZIO(NOM_MUN);
  INVALIDO := INVALIDO + CAMPO_VAZIO(UF);
  INVALIDO := INVALIDO + CAMPO_VAZIO(CEP);}
  //IF INVALIDO <> 0 then ERRO_DADOS := ' Dados do Cliente Incompletos ' + #13;

  xpais := 'BRASIL';
  indIEDest := '2';
  if IE = '0' then IE := '';
  if IE = '' then indIEDest := '9';
  if Length(StrNum(CPF_CNPJ)) = 11 then
    begin
      indIEDest := '9';
      if TIPO <> '6' then
        begin
          IE := '';
        end
      else if IE <> '' then indIEDest := '1'; //se for produtor rural
    end;
    
  if Length(StrNum(CPF_CNPJ)) = 14 then
    begin
      indIEDest := '1';
      if length(IE) <= 6 then begin
          indIEDest := '9';
          IND_FINAL := '1';
      end;
    end;

  if DEST_NFE = '2' then
    begin
      INVALIDO := 0;
      erro_dados := '';

      CPF_CNPJ := '<CPF></CPF>';
      indIEDest := '9';
      idEstrangeiro := StrNum(tmp);
      IE := '';

      if codPaisDest <> '1058' then begin
        dm.IBselect.Close;
        dm.IBselect.SQL.Text := 'select nome from paises where cod = ' + strnum(codPaisDest);
        dm.IBselect.Open;

        xpais := dm.IBselect.FieldByName('nome').AsString;
        dm.IBselect.Close;

        if length(trim(idEstrangeiro)) < 5 then begin
          idEstrangeiro := strzero(idEstrangeiro, 5);
        end;

        CPF_CNPJ := '<CPF></CPF><idEstrangeiro>' + idEstrangeiro + '</idEstrangeiro>' ;
      end;
    end;

  if dm.ACBrNFe.Configuracoes.WebServices.Ambiente = taHomologacao then
    begin
      nome := 'NF-E EMITIDA EM AMBIENTE DE HOMOLOGACAO - SEM VALOR FISCAL';
    end;

  if length(xpais) < 5 then xpais := 'BRASIL';


  Result := '<dest>' + CPF_CNPJ + '<xNome>' + CampoString(NOME) + '</xNome><enderDest>' +
  SUB_NODO_END(ENDE) + '<xBairro>' + removeCarateresEspeciais(BAIRRO) +
  '</xBairro><cMun>' + COD_MUN + '</cMun><xMun>' + removeCarateresEspeciais(NOM_MUN) + '</xMun>' +
  '<UF>'  + UF + '</UF><CEP>' + CEP + '</CEP><cPais>'+ codPaisDest +'</cPais>' +
  '<xPais>'+xpais+'</xPais><fone>' + iif(FONE = '0', '', FONE) + '</fone></enderDest>' +
  '<indIEDest>'+ indIEDest +'</indIEDest>'+ IfThen(Contido(indIEDest, '1'), '<IE>' + IE + '</IE>', '') + '</dest>';
end;


FUNCTION TNfeVenda.CAMPO_VAZIO(ENT : STRING) : Smallint;
BEGIN
  IF LENGTH(trim(ENT)) = 0 THEN Result := 1
    ELSE RESULT := 0;
END;

FUNCTION TNfeVenda.NODO_EMIT(CNPJ, RAZAO, FANTASIA, ENDE, BAIRRO, COD_MUN, NOM_MUN, UF, CEP, FONE, IE, CRT : string) : string;
begin
  INVALIDO := 0;
  OK := VALIDACNPJ(CNPJ);

  IF(NOT OK) then
    begin
      ERRO_dados := 'CNPJ do Emitente Inválido ' + #13;
      INVALIDO := invalido + 1;
    end;

  if CAMPO_VAZIO(ENDE) > 0 then begin
    ERRO_dados := ERRO_dados + 'Endereço Inválido ' + #13;
    INVALIDO := invalido + 1;
  end;

  if CAMPO_VAZIO(BAIRRO) > 0 then begin
    ERRO_dados := ERRO_dados + 'Bairro Inválido ' + #13;
    INVALIDO := invalido + 1;
  end;
  if CAMPO_VAZIO(COD_MUN) > 0 then begin
    ERRO_dados := ERRO_dados + 'Código do Municipio Inválido ' + #13;
    INVALIDO := invalido + 1;
  end;
  if CAMPO_VAZIO(NOM_MUN) > 0 then begin
    ERRO_dados := ERRO_dados + 'Nome do Municipio Inválido ' + #13;
    INVALIDO := invalido + 1;
  end;
  if CAMPO_VAZIO(UF) > 0 then begin
    ERRO_dados := ERRO_dados + 'UF Inválida ' + #13;
    INVALIDO := invalido + 1;
  end;
  if CAMPO_VAZIO(CEP) > 0 then begin
    ERRO_dados := ERRO_dados + 'CEP Inválido ' + #13;
    INVALIDO := invalido + 1;
  end;
  if Length(FONE) < 6 then begin
    ERRO_dados := ERRO_dados + 'TELEFONE Inválido ' + #13;
    INVALIDO := invalido + 1;
  end;

  {INVALIDO := invalido + CAMPO_VAZIO(BAIRRO);
  INVALIDO := invalido + CAMPO_VAZIO(COD_MUN);
  INVALIDO := invalido + CAMPO_VAZIO(NOM_MUN);
  INVALIDO := invalido + CAMPO_VAZIO(UF);
  INVALIDO := invalido + CAMPO_VAZIO(CEP);}
  IF INVALIDO <> 0 then
    begin
      ERRO_DADOS := 'Dados do Emitente Incompletos ' + #13 + #13 + ERRO_DADOS;
      exit;
    end;

  Result := '<emit><CNPJ>' + CNPJ + '</CNPJ><xNome>' + CampoString(RAZAO) + '</xNome>' +
  '<xFant>' + CampoString(FANTASIA) + '</xFant><enderEmit>' +
  SUB_NODO_END(ENDE) + '<xBairro>' + removeCarateresEspeciais(BAIRRO) + '</xBairro><cMun>' +
  COD_MUN + '</cMun><xMun>' + removeCarateresEspeciais(NOM_MUN) + '</xMun><UF>' + UF + '</UF>' +
  '<CEP>' + CEP + '</CEP><cPais>1058</cPais><xPais>BRASIL</xPais>' +
  '<fone>' + FONE + '</fone></enderEmit><IE>' + IE + '</IE><CRT>' + CRT + '</CRT></emit>';
end;

procedure TNfeVenda.GravarTexto(SalvarComo, Texto:String);
var
  txt: textfile;
begin
  try
    AssignFile(txt, SalvarComo);
    Rewrite(txt);
    Append(txt);
    WriteLn(txt, Texto);
  finally
    CloseFile(txt);
  end;
end;


FUNCTION TNfeVenda.NODO_RAIZ() : string;
begin
  Result := '<?xml version="1.0" encoding="UTF-8"?><nfeProc versao="'+versaoNFe+'" xmlns="http://www.portalfiscal.inf.br/nfe">' + trim(NODO_NFE)  +  '</nfeProc>';
end;

FUNCTION TNfeVenda.NODO_INFNFE(CHAVENF : string) : string;
var
  dest_ies : string;
  parcelamento : TList;
begin
  parcelamento := VER_PARCELAS(notas);
  IND_PAG := '0';

  try
    if StrToIntDef(StrNum(venda.codForma), 1) = 2 then
      begin
        IND_PAG := '1';
      end
    else IND_PAG := '0'
  except
  end;

  if FIN_NFE1 = '' then FIN_NFE1 := '1';

  Result := '<infNFe versao="'+versaoNFe+'" Id="NFe' + trim(CHAVENF) +'">';

  Result := Result + NODO_IDE('14',dadosEmitente.Values['nf'], FIN_NFE1,natOp,'0', FormataData(form22.datamov), IND_PAG,'1400100', DigiVerifi);
  Result := Result + NODO_EMIT(dadosEmitente.Values['cnpj'],dadosEmitente.Values['razao'],dadosEmitente.Values['empresa'],dadosEmitente.Values['ende'],dadosEmitente.Values['bairro'],dadosEmitente.Values['cod_mun'],dadosEmitente.Values['cid'],dadosEmitente.Values['est'],funcoes.StrNum(dadosEmitente.Values['cep']),dadosEmitente.Values['telres'],dadosEmitente.Values['ies'],ConfParamGerais.Strings[10]);
  Result := Result + NODO_DEST(dadosDest.Values['tipo'],dadosDest.Values['cnpj'],dadosDest.Values['cnpj'],dadosDest.Values['nome'],dadosDest.Values['ende'],dadosDest.Values['bairro'],dadosDest.Values['cod_mun'],dadosDest.Values['cid'],dadosDest.Values['est'],dadosDest.Values['cep'], dadosDest.Values['telres'], dadosDest.Values['ies'], dadosEmitente.Values['cod_mun']);
  Result := Result + NODO_ITENS(lista_itens,cod_OP,'','','', _ORIGEM);
  Result := Result + NODO_TOTAL(totalNota,TOT_BASEICM,TOTICM,TOT_PIS,TOT_COFINS,0,totDesc);
  Result := Result + NODO_TRANSP(frete);
  Result := Result + NODO_PAG(parcelamento);
  Result := Result + NODO_COBR(parcelamento, totalNota, form22.datamov, _FORMPG);
  Result := Result + NODO_INFADIC(infAdic,PIS_NT,PIS_ST,COFINS_ST,0);
  Result := Result + '</infNFe>';
end;

FUNCTION TNfeVenda.Insere_no_Nodo(Nodo, inserir, xml : string) : string;
var tmp : string;
posi : integer;
begin
   posi := 0;
   tmp := '<' + nodo + '>';
   posi := pos(tmp, xml);
   posi := posi + length(tmp);
   xml := copy(xml,1,posi) + inserir + copy(xml,posi,length(xml));
  //Result := '<infNFe versao="2.00"  Id=' + CHAVENF +'>' + '</infNFe>';
end;


FUNCTION TNfeVenda.NODO_NFE() : string;
begin
  Result := '<NFe xmlns="http://www.portalfiscal.inf.br/nfe">' + trim(NODO_INFNFE(GeraChaveNf)) + '</NFe>';
end;

FUNCTION TNfeVenda.FORMAT_DATA(DAT : string) : string;
begin
  Result := '';
  try
    Result := FormatDateTime('YYYY/MM/DD',StrToDate(DAT));
  except
  end;
end;

FUNCTION TNfeVenda.NODO_IDE(UF, NUM_NF, FIN_NFE,  COD_CFOP, EXT_CFOP, DAT, FORMPAG, COD_MUNIC, DV_NF : string ) : string;
var
  TIPO_AMB, dHAtual : string;
begin
  TIPO_AMB := '1';
  if StrNum(cod_OP) = '0' then cod_OP := '5102';
  if funcoes.Contido(LeftStr(cod_OP, 1), '15') then idDest := '1'
  else if funcoes.Contido(LeftStr(cod_OP, 1), '26') then idDest := '2'
  else if funcoes.Contido(LeftStr(cod_OP, 1), '37') then idDest := '3';

  //1-PRODUCAO 2-HOMOLOGACAO
  {Result := '<ide><cUF>' + UF + '</cUF><cNF>' + funcoes.CompletaOuRepete('',nota,'0',8) + '</cNF><natOp>' + COD_CFOP + '</natOp>' +
  '<indPag>' + iif(FORMPAG = '1', '0', '1')   + '</indPag><mod>55</mod><serie>1</serie><nNF>' +
  NUM_NF + '</nNF><dEmi>' + DAT + '</dEmi><dSaiEnt>' + DAT + '</dSaiEnt><hSaiEnt>' + FormatDateTime('tt',now) +
  '</hSaiEnt><tpNF>'+ IfThen(Contido(cod_OP[1], '567'), '1', '0') +'</tpNF><idDest>'+ idDest +'</idDest><cMunFG>' + COD_MUNIC + '</cMunFG>' +
  IfThen(length(NFE_REF) = 44, '<NFref><refNFe>' + NFE_REF + '</refNFe></NFref>', '') + '<tpImp>1</tpImp><tpEmis>1</tpEmis><cDV>' + DV_NF + '</cDV><tpAmb>' + TIPO_AMB + '</tpAmb><finNFe>' +
  FIN_NFE + '</finNFe><indFinal>'+ IfThen(DEST_NFE = '2', '1', '0') +'</indFinal><indPres>' + IND_PRES(FIN_NFE) + '</indPres><procEmi>0</procEmi><verProc>ControlW Versao 1</verProc></ide>';
  Result := trim(Result);}

  if dm.ACBrNFe.Configuracoes.WebServices.Ambiente = taHomologacao then TIPO_AMB := '2'
    else TIPO_AMB := '1';

  dHAtual := getDataHoraAtualXML;

  Result := '<ide><cUF>' + UF + '</cUF><cNF>' + funcoes.CompletaOuRepete('',nota,'0',8) + '</cNF><natOp>' + LeftStr(removeCarateresEspeciais(COD_CFOP), 50) + '</natOp>' +
  '<indPag>' + IND_PAG  + '</indPag><mod>55</mod><serie>1</serie><nNF>' +
  NUM_NF + '</nNF><dhEmi>' + dHAtual + '</dhEmi><dhSaiEnt>' + dHAtual + '</dhSaiEnt>' +
  '<tpNF>'+ IfThen(Contido(cod_OP[1], '567'), '1', '0') +'</tpNF><idDest>'+ idDest +'</idDest><cMunFG>' + COD_MUNIC + '</cMunFG>' +
   '<tpImp>1</tpImp><tpEmis>1</tpEmis><cDV>' + DV_NF +
  '</cDV><tpAmb>' + TIPO_AMB + '</tpAmb><finNFe>' +
  FIN_NFE + '</finNFe><indFinal>'+ IND_FINAL +'</indFinal><indPres>' + IND_PRES(FIN_NFE) + '</indPres><procEmi>0</procEmi><verProc>ControlW Versao 1</verProc>'+TAG_DOCREF +'</ide>';
  Result := trim(Result);

  //IND_FINAL ESTÁ DENTRO DE Procedure LerDados_Emit_Dest(codDest : string);
end;


procedure TNfeVenda.CriaLista_De_itens_Venda(var lista : Tlist);
var
   desc,temp, tot, TOT1, temp1 : currency;
   i, fim, tem : integer;
   aliq : string[3];
   CB : Boolean;
   item : Item_venda;
begin
//venda := Tvenda.Create;
  totalNota := 0;
  totDesc := 0;
  TOT1 := 0;
  totalNotaORIGI := 0;
  lista := TList.Create;

  fim := notas.Count - 1 ;
  for i := 0 to fim do
    begin
      nota := notas.Strings[i];

      lerVenda(nota);

      dm.IBQuery2.Close;
      dm.IBQuery2.SQL.Clear;
      dm.IBQuery2.SQL.Add('select desconto, total, codhis from venda where nota = :nota');
      dm.IBQuery2.ParamByName('nota').AsString := nota;
      dm.IBQuery2.Open;

      _FORMPG := dm.IBQuery2.fieldbyname('codhis').AsString;

      totDesc := totDesc + abs(dm.IBQuery2.fieldbyname('desconto').AsCurrency);
      totalNotaORIGI := totalNotaORIGI + abs(dm.IBQuery2.fieldbyname('total').AsCurrency);
    end;

  totalNota := totalNotaORIGI;
  for i := 0 to fim do
    begin
      query1.Close;
      query1.SQL.Clear;
      query1.SQL.Add('select cod, quant, total, p_venda, aliquota, P_compra, codbar, unid from item_venda where nota = :nota');
      query1.ParamByName('nota').AsString := nota;
      query1.Open;

      while not query1.Eof do
        begin
          nota := notas.Strings[i];

          query2.SQL.Clear;

          if existeCampoTipo_item then query2.SQL.Add('select cod, dev_icm, nome, tipo_item, codbar, unid, aliquota, is_pis, cod_ispis, p_compra, p_venda, obs from produto where cod = :cod')
          else query2.SQL.Add('select cod, dev_icm, nome, codbar, unid, aliquota, is_pis, cod_ispis, p_compra, p_venda, obs from produto where cod = :cod');
          query2.ParamByName('cod').AsString := query1.fieldbyname('cod').AsString;
          query2.Open;

         if not query2.IsEmpty then
           begin
             tem := ProcuraItemNaLista(lista, query1.fieldbyname('cod').AsInteger );
             if tem <> -1 then
               begin
                 item := lista.Items[tem];

                 item.quant := item.quant + abs(query1.fieldbyname('quant').AsCurrency);
                 item.total := item.total + abs(arrendondaNFe(query1.fieldbyname('total').AsCurrency, 2));
               end
             else
               begin
                 item := Item_venda.Create ;
                 CB := false;

                 try
                   cb    := checaCodbar(StrNum(query2.fieldbyname('codbar').AsString));
                 except
                 end;

                 if CB then begin
                  item.codbar := StrNum(query2.fieldbyname('codbar').AsString);
                end;

                if (LeftStr(item.codbar, 3) <> '789') then cb := false;

                if cb = false then begin
                  item.codbar := DIGEAN('789000' + CompletaOuRepete('', query2.fieldbyname('cod').AsString ,'0',6));
                end;

                 item.cod     := query2.fieldbyname('cod').AsInteger;
                 item.nome    := trim(removeCarateresEspeciais(query2.fieldbyname('nome').AsString));
                 item.unid    := removeCarateresEspeciais(IfThen(Trim(query2.fieldbyname('unid').AsString) = '', 'UN', query2.fieldbyname('unid').AsString));
                 item.quant   := abs(query1.fieldbyname('quant').AsCurrency);

                 //if tipo = 'T' then item.p_venda := abs(query2.fieldbyname('p_compra').AsCurrency);
                 ///else item.p_venda := abs(query1.fieldbyname('p_venda').AsCurrency);
                 item.p_venda := abs(IfThen(tipo = 'T', query2.fieldbyname('p_compra').AsCurrency, query1.fieldbyname('p_venda').AsCurrency));
                 item.total   := abs(arrendondaNFe(query1.fieldbyname('total').AsCurrency, 2));
                 totalNota    := totalNota + abs(item.total);

                 item.PercICMS           := 0;
                 item.VlrICMS            := 0;
                 item.DescICMS           := 0;
                 item.Aliq               := query2.fieldbyname('aliquota').AsString;
                 item.Reducao            := 0;
                 item.CodAliq            := StrToIntdef(StrNum(query1.fieldbyname('aliquota').AsString), 2);
                 item.Total_Preco_Compra := arrendondaNFe(query1.fieldbyname('p_compra').AsCurrency * query1.fieldbyname('quant').AsCurrency,2);
                 item.Pis                := query2.fieldbyname('is_pis').AsString;
                 item.codISPIS           := query2.fieldbyname('cod_ispis').AsString;
                 item.Desconto           := 0;
                 item.obs                := query2.fieldbyname('obs').AsString;

                 if existeCampoTipo_item then begin
                   if contido('|'+ query2.fieldbyname('tipo_item').AsString + '|', '|07|09|') then begin
                      item.Aliq               := '12';
                      item.CodAliq            := 12;
                    end;
                 end;

                 item.vlr_imposto        := 0;

                 totImp := totImp + VE_IMPOSTO(query2.FieldByName('p_compra').AsCurrency, query2.FieldByName('p_venda').AsCurrency, query1.fieldbyname('quant').AsCurrency);
                 item.Ncm := verNCM(item.cod);//IfThen((ConfParamGerais.Strings[26] = 'S') AND (StrToIntDef(dm.IBselect.fieldbyname('classif').AsString, 0) <> 0), StrToIntDef(dm.IBselect.fieldbyname('classif').AsString, 0), 98);

                 item.p_compra := query1.fieldbyname('P_compra').AsCurrency;
                 item.Vlr_Frete := 0;
                 aliq := query1.fieldbyname('aliquota').AsString;

                 query2.Close;
                 query2.SQL.Clear;
                 query2.SQL.Add('select * from aliq where cod = :cod');
                 query2.ParamByName('cod').Asinteger := item.CodAliq;
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
                     temp  := query2.fieldbyname('reducao').AsCurrency;
                   end;

                 IF DEST_NFE = '2' then
                   begin
                     temp1 := 4;
                     temp := 0;
                     item.Aliq := '0';
                   end
                 else if UF_EMI <> UF_DEST then
                   begin
                     temp1 := menor(ALIQ_INTEREST(UF_DEST), temp1);
                     temp := 0;
                     item.Aliq := '1';
                   end;

                 if cupom = 1 then begin
                   temp1 := 0;
                   item.Aliq := '12';
                 end;

                 {if FIN_NFE1 = '4' then begin
                   if query2.FieldByName('dev_icm').AsCurrency > 0 then begin
                     item.CodAliq := 0;
                     temp1 := query2.FieldByName('dev_icm').AsCurrency;
                     temp := 0;
                     item.Aliq := '0';
                   end;
                 end;  }

                 item.PercICMS := temp1;
                 item.DescICMS := temp;

                 lista.Add(item);
                 TOT1  := TOT1 + item.total;
               end;
           end //if not query2.IsEmpty then
         else
           begin
             tem := MessageDlg('Produto Não Encontrado:' +#13 +
                        'Código  : ' + query1.fieldbyname('cod').AsString + #13 +
                        'Preço   : ' + query1.fieldbyname('p_venda').AsString + #13 +
                        'CodBar  : ' + query1.fieldbyname('codbar').AsString + #13 +
                        'Aliquota: ' + query1.fieldbyname('aliquota').AsString + #13 +
                        'Unid    : ' + query1.fieldbyname('unid').AsString+ #13 + #13 +
                        'Deseja Abrir Cadastro de Produtos ?', mtConfirmation, [mbYes, mbNo], 1);
             if tem = idyes then
               begin
                 form9 := TForm9.Create(self);
                 form9.RecuperarCadastro := true;
                 form9.cod.Text      := query1.fieldbyname('cod').AsString;
                 form9.p_venda.Text  := FormatCurr('#,###,###0.00', query1.fieldbyname('p_venda').AsCurrency);
                 form9.unid.Text     := query1.fieldbyname('unid').AsString;
                 form9.aliquota.Text := query1.fieldbyname('aliquota').AsString;
                 form9.codbar.Text   := query1.fieldbyname('codbar').AsString;
                 form9.ShowModal;
                 JsEdit.LiberaMemoria(form9);
                 query1.Close;
                 query2.Close;
                 lista.Free;
                 ShowMessage('A NFe Não Foi Gerada. Favor Tente Novamente!');
                 erro_dados := 'ERRO';
                 abort;

                 exit;
               end;
           end;
         query1.Next;
       end;
     end;
   query2.Close;
   query1.Close;


  totalNota := 0;
  totalNota_achado := 0;
  TOT1      := 0;
  fim := lista.Count - 1;
  for i := 0 to lista.Count - 1 do
    begin
      item := lista.Items[i];

      item.total_achado := funcoes.ArredondaFinanceiro(item.p_venda * item.quant,2);
      if item.total_achado > item.total then
        begin
           //so soma os descontos se total da venda > 0, se for igual a zero pode ser saida de estoque
           if TOT1 > 0 then totDesc := totDesc + (item.total_achado - item.total);
        end;

      item.total := funcoes.ArredondaFinanceiro(item.p_venda * item.quant,2);
      totalNota  := totalNota + item.total;
    end;


  TOT1 := totalNota;
  venda.total := totalNota;

  {ShowMessage('totalNota=' + CurrToStr(totalNota) + #13 +
  'totDesc='+ CurrToStr(totDesc));}

   //rateio desconto
   if totDesc > 0 then
     begin
       desc    := totDesc;
       fim := lista.Count - 1;
       for i := 0 to fim do
         begin
           item := lista.Items[i];
           if i = fim then
             begin
               if desc < 0 then desc := 0;
               item.Desconto := Arredonda(desc, 2);
             end
           else
             begin
               temp := Arredonda((item.total /totalNota) * totDesc, 2);

               if temp > desc then
                 begin
                   temp := desc;
                 end;

               item.Desconto := temp;
               desc := desc - temp;
             end;
         end;
     end;

  //calcula o icms
  fim := lista.Count - 1;
  for i := 0 to lista.Count - 1 do
    begin
      item := lista.Items[i];
      tot := item.total - item.Desconto;
      if item.Reducao <> 0 then
        begin
          BASE_ICM := TOT - arrendondaNFe(TOT * (item.Reducao / 100), 2)  + VLR_DESP + TotalFrete;
          VLR_ICM := arrendondaNFe(BASE_ICM * (item.PercICMS / 100), 2);
        end
      else
        begin
          BASE_ICM := TOT + VLR_DESP + TotalFrete;
          VLR_ICM := arrendondaNFe(BASE_ICM * item.PercICMS / 100, 2);
        end;

      if item.CodAliq > 9 then
        begin
          BASE_ICM := 0;
          VLR_ICM := 0;
        end;
     // item.PercICMS := BASE_ICM;
      item.VlrICMS := VLR_ICM;

    end;

   if VLR_DESP > 0 then
     begin
       fim := lista.Count - 1;
       desc := VLR_DESP;
       for i := 0 to fim do
          begin
            item := lista.Items[i];
            if i = fim then
              begin
                item.DespAcessorias := desc;
                break;
              end;

            item.DespAcessorias := (item.total /totalNota) * VLR_DESP;
            desc := desc - item.DespAcessorias;
          end;
     end;

  //rateio do frete
    if tipo_frete <> 9 then
      begin
        if TotalFrete = 0 then exit;
        fim := lista.Count - 1;
        desc := TotalFrete;
        for i := 0 to fim do
          begin
            item := lista.Items[i];
            if i = fim then item.Vlr_Frete := desc;
            item.Vlr_Frete := (item.total /totalNota) * TotalFrete;
            desc := desc - item.Vlr_Frete;
          end;
      end;
end;

function TNfeVenda.Le_Nodo1(const nome:string; const texto :string) : String;
var
  ini, fim : integer;
begin
  ini := pos('<' + nome, texto);
  fim := pos('</' + nome + '>', texto);

  Result := '';
  Result := copy(texto, ini, fim);
end;

function TNfeVenda.Le_Nodo(nome:string; const texto :string) : String;
var
  ini, fim, param : integer;
  temp1 : string;
begin
  ini := 0;
  fim := 0;
  param := 0;
  if funcoes.Contido(' ', nome) then param := 1; // se veio espaço em braco é porque tem parametros

  ini := pos('<'+nome+'>', texto);
  if ini <= 0 then
    begin
      Result := '';
      exit;
    end;

  ini := ini + length('<'+nome+'>');
  temp1 := copy(texto, ini, length(texto));

  if param = 1 then fim := pos('</'+ trim(copy(nome, 1, pos(' ', nome)))  +'>', temp1)
    else fim := pos('</'+nome+'>', temp1);

  //temp1 := '';
  //fim := fim - ini;
  Result := '' ;
  Result := copy(temp1, 1, fim -1);

end;


function TNfeVenda.GeraXml : String;
var
  Nome_Arquivo, Caminho,arq, test, ce : string;
  ini : integer;
begin
  PIS_ST := 0;
  PIS_NT := 0;
  COFINS_ST := 0;
  valida := false;
  try
    LerDados_Emit_Dest(dest);
    CriaLista_De_itens_Venda(lista_itens);
  except
  end;

  IF ((DEST_NFE = '2') AND (LeftStr(cod_OP, 1) = '7')) then
    begin
      _EXPORTA := '<exporta><UFEmbarq>' +  dadosEmitente.Values['est'] + '</UFEmbarq>' +
      '<xLocEmbarq>' + dadosEmitente.Values['cid'] + '</xLocEmbarq></exporta>';
    end;

  CriaDirCaminho('NFE\EMIT');
  Caminho := pastaNFE_ControlW + 'NFE\EMIT\';

  try
    xml1 := NODO_RAIZ; //aqui cria o xml
    EmptyTList(Lista_Itens);
    if erro_dados <> '' then
      begin
        ShowMessage('Erro: '+erro_dados);
        //exit;
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
        erro_dados := dadosEmitente.Text;
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

    //insereRegistroDaNotaNaTabelaNFE(nfeTemp, chaveNF);

    for ini := 0 to notas.Count -1 do
      begin
        funcoes.GRAVA_MOV(notas[ini], Form22.datamov, nfeTemp, '90', dest, false);
      end;

    Fechar_Datasets_limpar_Listas_e_variaveis;
end;

function TNfeVenda.GeraXml1 : String;
var
  Nome_Arquivo, arq, test, ce, ci : string;
  ini, i, csta, dias : integer;
begin
  try
    if verificarValidadeCertificado(false) = false then exit;
  except
      on e:exception do begin
        MessageDlg('Erro3665: ' + e.Message, mtError, [mbOK], 1);
        exit;
      end;
  end;

   carregaConfigsNFe;
   recuperando := false;

  PIS_ST     := 0;
  PIS_NT     := 0;
  TOT_PIS    := 0;
  TOT_COFINS := 0;
  COFINS_ST  := 0;
  ci := '';
  valida := false;

  ICMSSN := 0;

  try
    xml1 := GerarNFeTexto(arq);
  except
    on e:exception do begin
      MessageDlg('Erro3679: ' + e.Message, mtError, [mbOK], 1);
      exit;
    end;
  end;

  if erro_dados = 'ERRO' then exit;
  if ((erro_dados <> '') or (arq = '')) then
    begin
      Fechar_Datasets_limpar_Listas_e_variaveis;
      exit;
    end;

    if FileExists(Caminho + chaveNF + '-nfe'+'.xml') then
      begin
        ACBrNFe.NotasFiscais.Clear;
        ACBrNFe.NotasFiscais.LoadFromFile(Caminho + chaveNF + '-nfe'+'.xml');
        dadosEmitente := TStringList.Create;
        dadosEmitente.LoadFromFile(Caminho + chaveNF + '-nfe'+'.xml');
        erro_dados := dadosEmitente.Text;
        test := Le_Nodo('nProt', erro_dados);
        ce   := Le_Nodo('cStat', erro_dados);
        if funcoes.Contido(ce,'100-101') AND (Length(ce) = 3) AND (Length(test) >= 13) AND (Length(test) <= 15) then begin
            ShowMessage('A nota '+ chaveNF +' já foi emitida.'+ #13 + #10 + #13 + #10 +
            'Numero de Protocolo: ' + test + ' ' + #13 + #10 +
            'Data e Hora de Autorização: ' + Le_Nodo('dhRecbto', ERRO_DADOS) + ' ' + #13 + #10 +
            'Status: ' + Le_Nodo('xMotivo', ERRO_DADOS) + ' ' + #13 + #10 +
            'Use a rotina Utilitários > Nfe > Reimpressão para ' +
            'imprimi-la, se necessário. Para emitir uma nova NF-e entre com um numero ' +
            'diferente deste.');

            insereNumeracaoNFE_Banco_de_dados(nfeTemp, chaveNF);

            if StrToIntDef(funcoes.StrNum(Incrementa_Generator('nfe', 0)), 0) = StrToIntDef(nfeTemp, 0)  then Incrementa_Generator('nfe', 1);
            ACBrNFe.NotasFiscais[0].Imprimir;
            exit;
          end;
      end;

    erro_dados := '';

    try
      dm.ACBrNFe.NotasFiscais.Clear;
      dm.ACBrNFe.NotasFiscais.LoadFromFile(arq);
    except
      on e:exception do begin
        MessageDlg('Erro3718: ' + e.Message, mtError, [mbOK], 1);
        exit;
      end;
    end;

    try
      dm.ACBrNFe.NotasFiscais.Assinar;
    except
      on e:exception do begin
        MessageDlg('Erro3729: ' + e.Message, mtError, [mbOK], 1);
        ACBrNFe.NotasFiscais[0].GravarXML(ExtractFileName(arq),ExtractFileDir(arq) + '\');
        exit;
      end;
    end;

    try
      dm.ACBrNFe.NotasFiscais.Validar;
    except
      on e:exception do begin
        MessageDlg('Erro3877: ' + e.Message, mtError, [mbOK], 1);
        ACBrNFe.NotasFiscais[0].GravarXML(ExtractFileName(arq),ExtractFileDir(arq) + '\');
        exit;
      end;
    end;
   
      i := 0;
      csta := 999;

      funcoes.Mensagem(Application.Title ,'Aguarde, Enviando NFe...',15,'Courier New',false,0,clred);
      Application.ProcessMessages;
      Application.ProcessMessages;
      while true do begin
          if (i >= 5) then
            begin
              MessageDlg('Tentativas de Envio Esgotadas, Verifique a Internet ou outros Problemas que estão Evitando o Envio da NFe' + #13 +
              #13 + erro_dados,mtError,[mbOK],0);
              pergunta1.Visible := false;
              Fechar_Datasets_limpar_Listas_e_variaveis;
              exit;
              //break;
            end;

          try
            dm.ACBrNFe.Enviar(0, false);

            csta := ACBrNFe.WebServices.Retorno.cStat;
            pergunta1.Visible := false;
            break;
          except
            on e:exception do
              begin
                erro_dados := e.Message;
                csta := ACBrNFe.WebServices.Retorno.cStat;

                //ShowMessage('erro=' + e.Message + #13 + 'cStat=' + IntToStr(csta));

                if (Contido('Rejeicao:', e.Message) and (Contido('Duplicidade', e.Message) = false)) then
                  begin

                    MessageDlg('Erro: ' + e.Message + #13 + 'xMotivo= ' + ACBrNFe.WebServices.Retorno.xMotivo + #13 + 'Cstat=' + IntToStr(ACBrNFe.WebServices.Retorno.cStat) + #13 + 'Esta NFe não pode ser transmitida.' + #13 + #13 +'Por Favor Tente Novamente',
                    mtError,[mbOK],0);
                    pergunta1.Visible := false;
                    Fechar_Datasets_limpar_Listas_e_variaveis;
                    exit;
                  end;

                if funcoes.Contido('USO DENEGADO', UpperCase(erro_dados)) THEN
                  begin
                    csta := 301;
                    break;
                  end
                else if funcoes.Contido('DUPLICIDADE DE NF-E', UpperCase(erro_dados)) THEN
                  begin
                    if Contido(' [chNFe:', e.Message) then
                      begin
                        trataDuplicidadeNFe(e.Message, true);

                        erro_dados := '';

                        if chaveNF = chaveRecuperada then
                          begin
                            pergunta1.Visible := false;
                            Fechar_Datasets_limpar_Listas_e_variaveis;
                            MessageDlg('O Sistema Recuperou a NFe com Sucesso!', mtInformation, [mbOK], 1);
                            exit;
                          end;

                        Fechar_Datasets_limpar_Listas_e_variaveis;
                        xml1 := GerarNFeTexto(arq);

                        ACBrNFe.NotasFiscais.Clear;
                        ACBrNFe.NotasFiscais.LoadFromFile(arq);
                      end;
                  end
                else
                  begin
                    //pergunta1.Visible := false;
                    //MessageDlg('Erro: ' + e.Message + #13 + 'xMotivo= ' + ACBrNFe.WebServices.Retorno.xMotivo + #13 + 'Cstat=' + IntToStr(ACBrNFe.WebServices.Retorno.cStat) + #13 + 'Esta NFe não pode ser transmitida.' + #13 + #13 +'Por Favor Tente Novamente',
                    //mtError,[mbOK],0);

                    if Contido('Rejeicao:', e.Message) then
                      begin
                        MessageDlg('Erro: ' + e.Message + #13 + 'xMotivo= ' + ACBrNFe.WebServices.Retorno.xMotivo + #13 + 'Cstat=' + IntToStr(ACBrNFe.WebServices.Retorno.cStat) + #13 + 'Esta NFe não pode ser transmitida.' + #13 + #13 +'Por Favor Tente Novamente',
                        mtError,[mbOK],0);
                        pergunta1.Visible := false;
                        Fechar_Datasets_limpar_Listas_e_variaveis;
                        exit;
                      end;
                    //exit;
                  end;
              end;
          end;

          i := i + 1;
        end;

    if Contido('-' + IntToStr(csta) + '-', '-100-110-205-301-302-') then//((csta = 301) or (csta = 302) or (csta = 110)) then
      begin
        ci := 'E';
        if Contido('-' + IntToStr(csta) + '-', '-110-205-301-302-') then ci := 'D';

        ACBrNFe.NotasFiscais[0].GravarXML(ExtractFileName(arq),ExtractFileDir(arq) + '\');

        reStartGenerator('NFE', ACBrNFe.NotasFiscais[0].NFe.Ide.nNF + 1);
        insereRegistroDaNotaNaTabelaNFE(IntToStr(ACBrNFe.NotasFiscais[0].NFe.Ide.nNF), chaveNF, ci, ACBrNFe.NotasFiscais[0].NFe.Ide.dEmi, arq);
        AtualizaCfop(cod_op);

        funcoes.GRAVA_MOV(IntToStr(ACBrNFe.NotasFiscais[0].NFe.Ide.cNF), Form22.datamov, IntToStr(ACBrNFe.NotasFiscais[0].NFe.Ide.nNF), '90', dest, false, ci);

        SendPostData(Form72.IdHTTP1, arq, 'E', IntToStr(csta));

        //gravaERRO_LOG1('nota=' + nota + #13 + 'buscaCRCdaChave('+chaveNF+')=' + buscaCRCdaChave(chaveNF),'','');
        {dm.IBQuery1.Close;
        dm.IBQuery1.SQL.Text := 'update venda set entrga = ''N'', crc = :crc  where nota = :nota';
        dm.IBQuery1.ParamByName('crc').AsString  := buscaCRCdaChave(chaveNF);
        dm.IBQuery1.ParamByName('nota').AsString := StrNum(nota);

        try
          dm.IBQuery1.ExecSQL;
          dm.IBQuery1.Transaction.Commit;
        except
          on e:exception do begin
            ShowMessage('Erro 3706: ' + e.Message);
          end;
        end;}


        imprimirNFe();

        if funcoes.buscaParamGeral(85, 'S') = 'S' then begin
          enviarPorEmail(chaveNF);
        end;
        csta := 0;
      end;

    if csta > 200 then
      begin
        ShowMessage('NF-e '+ ' Houve uma falha na Validação!'+#13+#10+#13+#10+
                  'Favor Corrigir: ' + dm.ACBrNFe.WebServices.Retorno.xMotivo + #13 +
                  'cStat=' + IntToStr(csta));//+qry.FieldByName('RECIBO_DESCSTATUS').AsString);
        exit;          
      end;

    Fechar_Datasets_limpar_Listas_e_variaveis;
end;

function TNfeVenda.GeraChaveNf : string;
var seq : string;
i : integer;
total, dv : currency;
begin
    Result := '';
    result := IntToStr(14);//cod uf tamanho 02
    Result := Result + FormatDateTime('yymm',form22.datamov); //ano e mes de emissao tamanho 04
    Result := Result + dadosEmitente.Values['cnpj']; //cnpj do emitente tamanho 14
    Result := Result + '55'; // modelo da nf 02
    Result := Result + '001';//serie 03
    Result := Result + funcoes.CompletaOuRepete('',dadosEmitente.Values['nf'],'0',9); //numero nota fiscal 09
    //Result := Result + funcoes.CompletaOuRepete('1',dadosEmitente.Values['nf'],'0',9);
    Result := Result + '1';
    Result := Result + funcoes.CompletaOuRepete('',nota,'0',8);
    seq := '';
    seq := '432' + funcoes.CompletaOuRepete('','','98765432',5);
    total := 0;

    for i := 1 to length(result) do
      begin
        try
          total := total + StrToCurr(seq[i]) * StrToCurr(Result[i]) ;
        except
          result := '*';
          exit;
        end;
      end;

    i := (trunc(total) mod 11);
    i := 11 - i;
    if i > 9 then i := 0;
    DigiVerifi := IntToStr(i);
    Result := Result + intToStr(i);
    //Result := 'NFe' + Result;
    chaveNF := Result;
end;


function TNfeVenda.RetornaEndeRua( entra : string) : string;
var
  tes : String;
begin
  //Result := entra;
  //exit;

  if funcoes.Contido(',',entra) then
    begin
      result := copy(entra,1,funcoes.PosFinal(',',entra)-1);

      tes := copy(entra,funcoes.PosFinal(',',entra) + 1,length(entra));
      if strnum(tes) = '0' then Result := entra;
    end
  else
    begin

      result := copy(entra,1,funcoes.PosFinal(' ',entra)-1);
      tes := copy(entra,funcoes.PosFinal(' ',entra) + 1,length(entra));
      if strnum(tes) = '0' then Result := entra;
    end;
end;

function TNfeVenda.RetornaNumero(const entra : string) : string;
begin
  Result := '';
  if funcoes.Contido(',',entra) then
    begin
      result := copy(entra,funcoes.PosFinal(',',entra) + 1,length(entra));
    end
  else
    begin
      result := copy(entra,funcoes.PosFinal(' ',entra) + 1,length(entra));
    end;

  Result := StrNum(Result);
  if Result = '0' then Result := 'S/N';
end;

function TNfeVenda.FormataCPF_CNPJ(nome : string) : string;
begin
  Result := funcoes.DeletaChar('/',funcoes.DeletaChar('.',funcoes.DeletaChar('-',Trim(nome))));
end;

function TNfeVenda.FormataData(data : tdatetime) : string;
begin
  Result := FormatDateTime('YYYY-MM-DD',data);
end;

function TNfeVenda.FormataHora(hora : tdatetime) : string;
begin
  Result := FormatDateTime('tt',hora);
end;

function TNfeVenda.CriaDirCaminho(const NomeSubDir: string): boolean;
var dir : string;
begin
  dir := pastaNFE_ControlW;
  dir := dir + NomeSubDir;

  if not DirectoryExists(dir) then
    ForceDirectories(dir);
end;

procedure TNfeVenda.FormCreate(Sender: TObject);
begin

  if FileExists(caminhoEXE_com_barra_no_final + 'NCM_UNID.txt') then begin
    arqNCM_UNID := TStringList.Create;
    //arqNCM_UNID.LoadFromFile(caminhoEXE_com_barra_no_final + 'NCM_UNID.txt');
  end;


  cupom := 0;
  {grupo de tributação para calcular a partilha de ICMS}
  aliquotasGrupoDeICMS := TItensPISCOFINS.Create;
  i := aliquotasGrupoDeICMS.Add(TacumPis.Create);
  aliquotasGrupoDeICMS[i].cod    := '2016';
  aliquotasGrupoDeICMS[i].pis    := 40; //vICMSUFDest
  aliquotasGrupoDeICMS[i].cofins := 60; //vICMSUFRemet
  i := aliquotasGrupoDeICMS.Add(TacumPis.Create);
  aliquotasGrupoDeICMS[i].cod    := '2017';
  aliquotasGrupoDeICMS[i].pis    := 60; //vICMSUFDest
  aliquotasGrupoDeICMS[i].cofins := 40; //vICMSUFRemet
  i := aliquotasGrupoDeICMS.Add(TacumPis.Create);
  aliquotasGrupoDeICMS[i].cod    := '2018';
  aliquotasGrupoDeICMS[i].pis    := 80; //vICMSUFDest
  aliquotasGrupoDeICMS[i].cofins := 20; //vICMSUFRemet
  i := aliquotasGrupoDeICMS.Add(TacumPis.Create);
  aliquotasGrupoDeICMS[i].cod    := '2019';
  aliquotasGrupoDeICMS[i].pis    := 100; //vICMSUFDest
  aliquotasGrupoDeICMS[i].cofins := 0; //vICMSUFRemet
  {grupo de tributação para calcular a partilha de ICMS}

  recuperando := false;
  cont := 0;
  pasta_Acbr := IfThen(DirectoryExists('C:\ACBR\'), 'C:\ACBR\', 'C:\ACBrNFeMonitor\');
  pastaNFE_ControlW := caminhoEXE_com_barra_no_final;

  //if funcoes.buscaConfigNaPastaDoControlW1('USAR_NFE_LOCAL') = '' then exit;

  if funcoes.buscaConfigNaPastaDoControlW('USAR_NFE_LOCAL', 'S') = 'S' then
    begin
      RadioButton1.Checked := true;
      edit1.Text := funcoes.buscaConfigNaPastaDoControlW('PASTA_ACBR', pasta_Acbr);
      Edit2.Text := funcoes.buscaConfigNaPastaDoControlW('PASTA_CONTROL_NFE', pastaNFE_ControlW);
      exit;
    end;

  preecheInformacoes();

  if RadioButton2.Checked then
    begin
      If trim(Edit1.Text) <> '' then pasta_Acbr := Edit1.Text;
      if trim(Edit2.Text) <> '' then pastaNFE_ControlW := Edit2.Text;
    end;

end;

procedure TNfeVenda.te(Sender: TObject; var Key: Char);
begin
  if key = #27 then close;
end;

FUNCTION TNfeVenda.SUB_NODO_END(ENDE : String) : string;
var
  num : String;
begin
  num := Trim(CampoString(RetornaNumero(ENDE)));
  if StrNum(num) = '0' then num := '0';
  Result := '<xLgr>' + CampoString(RetornaEndeRua(ENDE)) + '</xLgr>'+
  '<nro>' + num  + '</nro>';
end;

FUNCTION TNfeVenda.FORMAT_QTD(VALOR : currency) : string;
begin
  Result := '';
  Result := FormatCurr('0.000',VALOR);
  Result := funcoes.TiraOuTrocaSubstring(Result,',','.');
end;

Function TNfeVenda.LITERAL(ent : string) : string;
begin
  Result := '';
  Result := '"' + ent + '"';
end;


function TNfeVenda.Format_num(valor : currency; decimais : smallint = 2) : string;
begin
  Result := StringReplace(trim(FormatCurr('0.' + CompletaOuRepete('','','0', decimais), valor)), ',', '.', [rfReplaceAll]);
end;

procedure TNfeVenda.RadioButton2Enter(Sender: TObject);
begin
  ShowMessage('Informe os campos corretamente:' + #13 + '1 - Pasta do ACBr para criação dos arquivos de comunicação' + #13 + 'Ex: \\NFE\ACBR\' + #13 + #13 + '2 - Pasta do ControlW, onde o sistema irá centralizar as informações de NFE' + #13 + 'Ex: \\NFE\CONTROLW\');
  habilitaEditRede();

  preecheInformacoes();

  RadioButton2.Checked := true;
end;

procedure TNfeVenda.RadioButton1Enter(Sender: TObject);
begin
  //desahabilitaEditRede();
end;

procedure TNfeVenda.Button2Click(Sender: TObject);
begin
  restaurarPadrao();
end;

procedure TNfeVenda.Button1Click(Sender: TObject);
begin
  if Edit1.Text[Length(edit1.Text )] <> '\' then Edit1.Text := Edit1.Text + '\';
  if Edit2.Text[Length(edit2.Text )] <> '\' then Edit2.Text := Edit2.Text + '\';

  if RadioButton2.Checked then
    begin
      gravaInformacoes();
      gravaConfigLocal;
    end
  else gravaConfigLocal;

  ShowMessage('Informações atualizadas com sucesso');
end;

procedure TNfeVenda.Button3Click(Sender: TObject);
begin
  if DirectoryExists(edit1.Text) then ShowMessage(edit1.Text + '  TESTE OK')
    else ShowMessage(edit1.Text + '  FALHA!!');

  if DirectoryExists(edit2.Text) then ShowMessage(edit2.Text);
end;

FUNCTION TNfeVenda.NODO_COBR(MAT : tlist; TOT : currency; _DATA : TDateTime; FORM_PGTO : String) : String;
var
  desc, totAtual, valor : currency;
  parc : Tparcela;
  i    : integer;
begin
  Result  := '';
  nodoFAT := '';

  totAtual := totalNota;
  //exit;

  if FIN_NFE1 <> '1' then exit;


  desc    := 0.001;
  //if dm.ACBrNFe.Configuracoes.WebServices.Ambiente = taHomologacao then desc := 0.001
   //else desc := 0;

  if notas.Count > 1 then exit;

  if usaNFe4ouMaior then begin
     nodoFAT := '<fat><nFat>001</nFat><vOrig>'+FORMAT_NUM(totalNota)+'</vOrig><vDesc>'+FORMAT_NUM(desc, 3)+'</vDesc><vLiq>'+FORMAT_NUM(totalNota - desc)+'</vLiq></fat>';
    //nodoFAT := '<fat><nFat>001</nFat><vOrig>'+FORMAT_NUM(totalNota)+'</vOrig><vDesc>0.00</vDesc><vLiq>'+FORMAT_NUM(totalNota)+'</vLiq></fat>';
  end;

  if funcoes.buscaParamGeral(56, 'S') <> 'N'  then
    begin
      if MAT.Count <= 0 then exit;
      Result := '<cobr>' + nodoFAT;
      FOR i := 0 TO mat.Count -1 do
        begin
          parc := MAT.Items[i];
          valor    := parc.valor - desc;

          if i = mat.Count -1 then valor := totAtual;
          totAtual := totAtual   - valor;
          if mat.Count = 1    then valor := totalNota;

          if i > 0 then desc := 0;

          if arrendondaNFe(valor, 2) > 0 then begin
            Result := Result + '<dup><nDup>' + Trim(parc.historico) + '</nDup><dVenc>' +
            FormatDateTime('yyyy-mm-dd',parc.Vencimento) + '</dVenc><vDup>'  +
            FORMAT_NUM(valor) + '</vDup></dup>';
          end;
        end;

      IF MAT.Count = 0 then
        begin
          if TOT > 0 then begin
            Result := Result + '<dup><nDup>' + FORM_PGTO + '</nDup><dVenc>' +
            FormatDateTime('yyyy-mm-dd', _DATA) + '</dVenc><vDup>' +
            FORMAT_NUM(TOT) + '</vDup></dup>';
          end;
        end;

      Result := Result + '</cobr>';
    end;
end;

//???????????????????????????????????
//PREENCHE O CAMPO INDFINAL PRA INDICAR: 
//0=N? se aplica (por exemplo, para a Nota Fiscal complementar ou de ajuste);
//1=Opera?o presencial;
//2=Opera?o n? presencial, pela Internet;
//3=Opera?o n? presencial, Teleatendimento;
//4=NFC-e em opera?o com entrega em domic?io;
//9=Opera?o n? presencial, outros.
//Nota: Para a NFC-e, somente s? aceitas as op?es 1 e 4.1=Opera?o interna;
//???????????????????????????????????
FUNCTION TNfeVenda.IND_PRES(FIN_NFE2 : String) : String;
//???????????????????????????????????
begin
  Result := '1';
  if funcoes.Contido(FIN_NFE2, '2-3') then Result := '0';
end;

function TNfeVenda.GerarNFeTexto(var arq : String) : AnsiString;
begin
  Result := '';
  try
    LerDados_Emit_Dest(dest);
    CriaLista_De_itens_Venda(lista_itens);
  except
  end;

  if erro_dados = 'ERRO' then exit;

  IF DEST_NFE = '2' then
    begin
      _EXPORTA := '<exporta><UFSaidaPais>' +  dadosEmitente.Values['est'] + '</UFSaidaPais>' +
      '<xLocExporta>' + dadosEmitente.Values['cid'] + '</xLocExporta>'+
      '<xLocDespacho>' + dadosEmitente.Values['cid'] + '</xLocDespacho>' + '</exporta>';
    end;

  CriaDirCaminho('NFE\EMIT');
  Caminho := pastaNFE_ControlW + 'NFE\EMIT\';

  try
    Result := NODO_RAIZ; //aqui cria o xml

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
  //GravarTexto(arq + '1', Result);
  GravarTexto(arq, Result);
end;

function TNfeVenda.achaQTD(const preco, total : currency) : currency;
var
  quanti, _ptot : currency;
  cont : integer;
begin
  quanti := arrendondaNFe(total / preco, 4);
  cont   := 0;

  while true do
    begin
      if cont > 500 then
        begin
          quanti := arrendondaNFe(total / preco, 4);
          break;
        end;

      cont := cont + 1;
      _ptot := arrendondaNFe(quanti * preco, 4);

      if arrendondaNFe(_ptot, 2) = total then
        begin
          //ShowMessage(CurrToStr(total) + #13 + CurrToStr(_ptot));
          Break;
        end;

      //ShowMessage(CurrToStr(total) + #13 + CurrToStr(_ptot));
      if _ptot > total then
        begin
          quanti := quanti - 0.0001;
        end
      else if _ptot < total then
        begin
          quanti := quanti + 0.0001;
        end;
    end;


  Result := quanti;
end;

procedure TNfeVenda.trataDuplicidadeNFe(erroDup : String; msg : boolean);
var
  chavb : TChaveDetalhes;
  stat  : String;
  vend  : Tvenda;
begin
  recuperando := true;
  if msg then
    begin
      //MessageDlg('Ocorreu Um Erro de Duplicidade e o Sistem irá recuperar a NFe!', mtWarning, [mbOK], 1);
    end;

  chavb := TChaveDetalhes.Create;
  chavb.chave := buscaChaveErroDeDuplicidade(erroDup);
  Ler_dados_pela_chave(chavb);

  chaveRecuperada := chavb.chave;

  //if chavb.nnf
  {if not FileExists(pastaControlW+ 'nfe\emit\' + chavb.chave + '-nfe.xml')  then
    begin
      reStartGenerator('nfe', chavb.nnf + 1);
      exit;
    end;}

  if chavb.nnf = strtoint(Incrementa_Generator('nfe', 0)) then Incrementa_Generator('nfe', 1);
  //reStartGenerator('nfe', chavb.nnf + 1);

  if FileExists(pastaControlW+ 'nfe\emit\' + chavb.chave + '-nfe.xml') then begin

    ACBrNFe.NotasFiscais.Clear;
    ACBrNFe.NotasFiscais.LoadFromFile(pastaControlW+ 'nfe\emit\' + chavb.chave + '-nfe.xml');

    stat := Le_Nodo('cStat', ACBrNFe.NotasFiscais[0].XML);
    if stat = '' then begin
      try
        ACBrNFe.Consultar;
        stat := IntToStr(acbrnfe.NotasFiscais[0].NFe.procNFe.cStat);
      except
      end;
    end;
  end
  else begin
    MessageDlg('Ocorreu uma Duplicidade!'+ #13 + 'XML Não Encontrado: ' + chavb.chave, mtError, [mbOK], 1);
    gravaERRO_LOG1('', 'Ocorreu uma Duplicidade!'+ #13 + 'XML Não Encontrado: ' + chavb.chave, '');
    exit;
  end;

  vend := Tvenda.Create;
  vend.adic  := '';
  vend.nota  := chavb.codnf;
  vend.chave := chavb.chave;
  if StrToIntDef(stat, 0) <= 200 then
    begin
      insereRegistroDaNotaNaTabelaNFE1(IntToStr(ACBrNFe.NotasFiscais[0].NFe.Ide.nNF), chavb.chave, 'E', ACBrNFe.NotasFiscais[0].NFe.Ide.dEmi);
      AtualizaCfop(cod_op);

      ACBrNFe.NotasFiscais[0].GravarXML(chavb.chave + '-nfe.xml',pastaControlW+ 'nfe\emit\');

      funcoes.GRAVA_MOV(IntToStr(ACBrNFe.NotasFiscais[0].NFe.Ide.cUF), Form22.datamov, IntToStr(ACBrNFe.NotasFiscais[0].NFe.Ide.nNF), '90', dest, false);

      imprimirNFe();
    end;
    
  chavb.Free;
  vend.Free;
end;

procedure TNfeVenda.carregaConfigsNFe();
begin
  ACBrNFe.Configuracoes.Geral.ModeloDF := moNFe;
  ACBrNFe.DANFE := DANFE_Rave;
  vST := 0;
  TOTvICMSUFDest  := 0;
  TOTvICMSUFRemet := 0;

  ACBrNFe.Configuracoes.Geral.CamposFatObrigatorios := true;
end;

function TNfeVenda.arrendondaNFe(valor : currency; deci : integer) : currency;
begin
  Result := ArredondaFinanceiro(valor, deci);
  exit; 
  Result := Arredonda(valor, deci);
end;

function TNfeVenda.NODO_ICMS_UF_DEST(var item1 : Item_venda) : string;
var
  vICMSUFDest, vICMSUFRemet,picmsDest, pIcmsEmit : currency;
  pICMSUFDest, pICMSInter, DIFAL : currency;
  i : integer;
begin
  Result := '';

  if (IND_FINAL <> '1') then exit;
  if UF_DEST = UF_EMI   then exit;
  if DEST_NFE = '2'     then exit;
  if Contido('refNFP', TAG_DOCREF) then exit;


  //IF not Contido(UF_DEST, UF_PARTILHAICMS) then exit;

  i := aliquotasGrupoDeICMS.Find(FormatDateTime('yyyy', now));

  if i = -1 then begin
    picmsDest := 40;
    pIcmsEmit := 60;
  end
  else begin
    picmsDest := aliquotasGrupoDeICMS[i].pis;
    pIcmsEmit := aliquotasGrupoDeICMS[i].cofins;
  end;

  ///ShowMessage('picmsDest=' + CurrToStr(picmsDest) + #13 + 'pIcmsEmit=' + CurrToStr(pIcmsEmit));

  pICMSUFDest := 17;
  //pICMSInter  := ALIQ_INTEREST(UF_DEST);
  pICMSInter  := 12;

  if (picmsDest - pICMSInter) = 0 then exit;
  

  vICMSUFDest  := ArredondaFinanceiro(item.base_icm * pICMSUFDest /100, 2);
  vICMSUFRemet := ArredondaFinanceiro(item.base_icm * pICMSInter  /100, 2);
  DIFAL        := abs(vICMSUFDest - vICMSUFRemet);
  vICMSUFDest  := ArredondaFinanceiro(DIFAL * picmsDest / 100, 2);
  vICMSUFRemet := ArredondaFinanceiro(DIFAL * pIcmsEmit / 100, 2);
  Result := //'';
  '<ICMSUFDest>' +
   '<vBCUFDest>'+ FORMAT_NUM(TOT_BASEICM) +'</vBCUFDest>' +
   '<pFCPUFDest>0.00</pFCPUFDest>' +
   '<pICMSUFDest>'+FORMAT_NUM(pICMSUFDest)+'</pICMSUFDest>'+
   '<pICMSInter>'+FORMAT_NUM(pICMSInter)+'</pICMSInter>' +
   '<pICMSInterPart>'+FORMAT_NUM(picmsDest)+'</pICMSInterPart>' +
   '<vFCPUFDest>0.00</vFCPUFDest>' +
   '<vICMSUFDest>'+FORMAT_NUM(vICMSUFDest)+'</vICMSUFDest>' +
   '<vICMSUFRemet>'+FORMAT_NUM(vICMSUFRemet)+'</vICMSUFRemet>' +
'</ICMSUFDest>';

  TOTvICMSUFDest  := TOTvICMSUFDest  + vICMSUFDest;
  TOTvICMSUFRemet := TOTvICMSUFRemet + vICMSUFRemet;
end;

function TNfeVenda.abreDataSetIBselectPelaChave(chave : String) : boolean;
begin
  Result := false;
  dm.IBselect.Close;
  dm.IBselect.SQL.Text := 'select xml from nfe where chave = :chave';
  dm.IBselect.ParamByName('chave').AsString := chave;
  dm.IBselect.Open;

  if dm.IBselect.IsEmpty then begin
    ShowMessage('Nenhuma NFe Encontrada!');
    dm.IBselect.Close;
    exit;
  end;

  if dm.IBselect.FieldByName('xml').IsNull then begin
    ShowMessage('Nenhuma NFe Encontrada1!');
    dm.IBselect.Close;
    exit;
  end;

  Result := true;
end;


function TNfeVenda.NODO_PAG(MAT : TList) : String;
var
  tpag, detBoleto : string;
  ini : integer;
  parc : Tparcela;
  TOTAL : CURRENCY;
begin
  Result    := '';
  detBoleto := '';

  if usaNFe4ouMaior = false then exit;

  tpag := '01';

  if MAT.Count > 0 then begin
    tpag       := '14';
  end;

  TOTAL  := totalNota;
  if FIN_NFE1 <> '1' then begin
    tpag  := '90';
    TOTAL := 0;
  end;

  //ACBrNFe.NotasFiscais[1].NFe.Cobr.Dup.
  {
    for ini := 0 to MAT.Count -1 do begin
      parc := MAT.Items[ini];
      detBoleto := detBoleto +
      '<detPag>'+
      '<tpag>15</tpag>'+
      '<vpag>' + Format_num(parc.valor) +  '</vpag>' +
      '</detPag>';
    end;

    detBoleto := '<pag>'+ detBoleto+'</pag>';
  end;


  if dm.ACBrNFe.Configuracoes.WebServices.Ambiente = taHomologacao then begin
    Result := detBoleto;
    exit;
  end;                                        }



      Result := '<pag>'+
                '<detPag>'+
                  '<tpag>'+tpag+'</tpag>'+
                  '<vpag>' + Format_num(TOTAL) +  '</vpag>' +
                '</detPag>' +
                '</pag>';

end;


function TNfeVenda.verificaProtNFe(arquivoXML : String ) : boolean;
var
  arq : TStringList;
  tmp : string;
begin
  arq := TStringList.Create;
  arq.LoadFromFile(arquivoXML);
  tmp := trim(Le_Nodo('cStat', arq.Text));

  if tmp = '' then begin
    ACBrNFe.WebServices.Retorno.Executar;

    {ACBrNFe.NotasFiscais.Clear;
    ACBrNFe.NotasFiscais.LoadFromFile(arquivoXML);
    ACBrNFe.Consultar;}
  end;
end;

function TNfeVenda.ManifestarNFe(chave, tipo, just : string) : string;
var
  CNPJ, cstat, tpstring : String;
begin
  dm.IBQuery2.Close;
  dm.IBQuery2.SQL.Text := 'select cnpj from registro';
  dm.IBQuery2.Open;
  CNPJ := dm.IBQuery2.FieldByName('cnpj').AsString;
  dm.IBQuery2.Close;

  ACBrNFe.EventoNFe.Evento.Clear;
  ACBrNFe.EventoNFe.Evento.Add;
  with ACBrNFe.EventoNFe.Evento[0] do begin
    InfEvento.dhEvento        := now;
    if tipo = '0' then begin
      infEvento.tpEvento := teManifDestConfirmacao;
      tpstring           := 'Confirmação da operação';
    end
    else if tipo = '1' then begin
      infEvento.tpEvento := teManifDestCiencia;
      tpstring           := 'Ciência da emissão';
    end
    else if tipo = '2' then begin
      infEvento.tpEvento := teManifDestOperNaoRealizada;
      tpstring           := 'Operação não realizada';
    end
    else if tipo = '3' then begin
      infEvento.tpEvento := teManifDestDesconhecimento;
      tpstring           := 'Desconhecimento da operação';
    end;
    InfEvento.cOrgao   := 91;
    infEvento.chNFe    := Chave;
    infEvento.CNPJ     := CNPJ;
  end;

  //ACBrNFe.Configuracoes.WebServices.Visualizar := true;
  try
    dm.ACBrNFe.EnviarEvento(0);
    cStat := IntToStr(ACBrNFe.WebServices.EnvEvento.EventoRetorno.retEvento.Items[0].RetInfEvento.cStat);
      except
        on e:exception do
          begin
            ShowMessage(e.Message);
            exit;
          end;
      end;

    cStat := IntToStr(ACBrNFe.WebServices.EnvEvento.EventoRetorno.retEvento.Items[0].RetInfEvento.cStat);
    if funcoes.Contido(cstat, '101-135-151-573') then begin
      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Text := 'update NFEDISTRIBUICAO set manifestada = :mani where chave = :chave';
      dm.IBQuery1.ParamByName('mani').AsString  := tipo;
      dm.IBQuery1.ParamByName('chave').AsString := chave;
      dm.IBQuery1.ExecSQL;
      dm.IBQuery1.Transaction.Commit;

      ShowMessage('NFe Manifestada Com Sucesso!' + #13 + 'cStat: ' + cstat + #13 +
      'xMotivo: ' + ACBrNFe.WebServices.EnvEvento.EventoRetorno.retEvento.Items[0].RetInfEvento.xMotivo + #13 +
      'Tipo: ' + tpstring);

      cstat := funcoes.dialogo('generico',0,'SN'+#8,0,false,'S','Control For Windows','Deseja Imprimir o Evento de Manifestação ?S/N:','N') ;
      if cstat = 'S' then begin
        ACBrNFe.DANFE := DANFE_Rave;
        ACBrNFe.ImprimirEvento;
      end;
    end;
end;



end.


