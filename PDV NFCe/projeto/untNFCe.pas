{$I ACBr.inc}
{*****************************************************************************
** Nome...............: untConfiguracoesNFe.pas                             **
** Autor/Programador..: WILLERSON WAGNER DOS SANTOS SILVA                   **
** Descrição..........: Modulo NF-e                                         **
** Data...............: 15/09/2014                                          **
** Data atualizacao da NFC-e 2.0 02/02/2011                                 **
******************************************************************************}
////////////////////////
{CÓDIGO E RESULTADO DO PROCESSAMENTO DA SOLICITAÇÃO
100 - Autorizado o uso da NF-e
101 - Cancelamento de NF-e homologado
102 - Inutilização de número homologado
103 - Lote recebido com sucesso
104 - Lote processado
105 - Lote em processamento
106 - Lote não localizado
107 - Serviço em Operação
108 - Serviço Paralisado Momentaneamente (curto prazo)
109 - Serviço Paralisado sem Previsão
110 - Uso Denegado
111 - Consulta cadastro com uma ocorrência
112 - Consulta cadastro com mais de uma ocorrência 
///////////////////////
CÓDIGO MOTIVOS DE NÃO ATENDIMENTO DA SOLICITAÇÃO
201 Rejeição: O numero máximo de numeração de NF-e a inutilizar ultrapassou o limite
202 Rejeição: Falha no reconhecimento da autoria ou integridade do arquivo digital
203 Rejeição: Emissor não habilitado para emissão da NF-e
204 Rejeição: Duplicidade de NF-e
205 Rejeição: NF-e está denegada na base de dados da SEFAZ
206 Rejeição: NF-e já está inutilizada na Base de dados da SEFAZ
207 Rejeição: CNPJ do emitente inválido
208 Rejeição: CNPJ do destinatário inválido
209 Rejeição: IE do emitente inválida
210 Rejeição: IE do destinatário inválida
211 Rejeição: IE do substituto inválida
212 Rejeição: Data de emissão NF-e posterior a data de recebimento
213 Rejeição: CNPJ-Base do Emitente difere do CNPJ-Base do Certificado Digital
214 Rejeição: Tamanho da mensagem excedeu o limite estabelecido
215 Rejeição: Falha no schema XML
216 Rejeição: Chave de Acesso difere da cadastrada
217 Rejeição: NF-e não consta na base de dados da SEFAZ
218 Rejeição: NF-e já esta cancelada na base de dados da SEFAZ
219 Rejeição: Circulação da NF-e verificada
220 Rejeição: NF-e autorizada há mais de 7 dias (168 horas)
221 Rejeição: Confirmado o recebimento da NF-e pelo destinatário
222 Rejeição: Protocolo de Autorização de Uso difere do cadastrado
223 Rejeição: CNPJ do transmissor do lote difere do CNPJ do transmissor da consulta
224 Rejeição: A faixa inicial é maior que a faixa final
225 Rejeição: Falha no Schema XML da NFe
226 Rejeição: Código da UF do Emitente diverge da UF autorizadora
227 Rejeição: Erro na Chave de Acesso – Campo ID
228 Rejeição: Data de Emissão muito atrasada
229 Rejeição: IE do emitente não informada
230 Rejeição: IE do emitente não cadastrada
231 Rejeição: IE do emitente não vinculada ao CNPJ
232 Rejeição: IE do destinatário não informada
233 Rejeição: IE do destinatário não cadastrada
234 Rejeição: IE do destinatário não vinculada ao CNPJ
235 Rejeição: Inscrição SUFRAMA inválida
236 Rejeição: Chave de Acesso com dígito verificador inválido
237 Rejeição: CPF do destinatário inválido
238 Rejeição: Cabeçalho – Versão do arquivo XML superior a Versão vigente
239 Rejeição: Cabeçalho – Versão do arquivo XML não suportada
240 Rejeição: Cancelamento/Inutilização – Irregularidade Fiscal do Emitente
241 Rejeição: Um número da faixa já foi utilizado
242 Rejeição: Cabeçalho – Falha no Schema XML
243 Rejeição: XML Mal Formado
244 Rejeição: CNPJ do Certificado Digital difere do CNPJ da Matriz e do CNPJ do
Emitente
245 Rejeição: CNPJ Emitente não cadastrado
246 Rejeição: CNPJ Destinatário não cadastrado
247 Rejeição: Sigla da UF do Emitente diverge da UF autorizadora
248 Rejeição: UF do Recibo diverge da UF autorizadora
249 Rejeição: UF da Chave de Acesso diverge da UF autorizadora
250 Rejeição: UF diverge da UF autorizadora
251 Rejeição: UF/Município destinatário não pertence a SUFRAMA
252 Rejeição: Ambiente informado diverge do Ambiente de recebimento
253 Rejeição: Digito Verificador da chave de acesso composta inválida
254 Rejeição: NF-e complementar não possui NF referenciada
255 Rejeição: NF-e complementar possui mais de uma NF referenciada
256 Rejeição: Uma NF-e da faixa já está inutilizada na Base de dados da SEFAZ
257 Rejeição: Solicitante não habilitado para emissão da NF-e
258 Rejeição: CNPJ da consulta inválido
259 Rejeição: CNPJ da consulta não cadastrado como contribuinte na UF
260 Rejeição: IE da consulta inválida
261 Rejeição: IE da consulta não cadastrada como contribuinte na UF
262 Rejeição: UF não fornece consulta por CPF
263 Rejeição: CPF da consulta inválido
264 Rejeição: CPF da consulta não cadastrado como contribuinte na UF
265 Rejeição: Sigla da UF da consulta difere da UF do Web Service
266 Rejeição: Série utilizada não permitida no Web Service
267 Rejeição: NF Complementar referencia uma NF-e inexistente
268 Rejeição: NF Complementar referencia uma outra NF-e Complementar
269 Rejeição: CNPJ Emitente da NF Complementar difere do CNPJ da NF
Referenciada
270 Rejeição: Código Município do Fato Gerador: dígito inválido
271 Rejeição: Código Município do Fato Gerador: difere da UF do emitente
272 Rejeição: Código Município do Emitente: dígito inválido
273 Rejeição: Código Município do Emitente: difere da UF do emitente
274 Rejeição: Código Município do Destinatário: dígito inválido
275 Rejeição: Código Município do Destinatário: difere da UF do Destinatário
276 Rejeição: Código Município do Local de Retirada: dígito inválido
277 Rejeição: Código Município do Local de Retirada: difere da UF do Local de
Retirada
278 Rejeição: Código Município do Local de Entrega: dígito inválido
279 Rejeição: Código Município do Local de Entrega: difere da UF do Local de Entrega
280 Rejeição: Certificado Transmissor inválido
281 Rejeição: Certificado Transmissor Data Valida3de
282 Rejeição: Certificado Transmissor sem CNPJ
283 Rejeição: Certificado Transmissor – erro Cadeia de Certificação
284 Rejeição: Certificado Transmissor revogado
285 Rejeição: Certificado Transmissor difere ICP-Brasil
286 Rejeição: Certificado Transmissor erro no acesso a LCR
287 Rejeição: Código Município do FG – ISSQN: dígito inválido
288 Rejeição: Código Município do FG – Transporte: dígito inválido
289 Rejeição: Código da UF informada diverge da UF solicitada
290 Rejeição: Certificado Assinatura inválido
291 Rejeição: Certificado Assinatura Data Validade
292 Rejeição: Certificado Assinatura sem CNPJ
293 Rejeição: Certificado Assinatura – erro Cadeia de Certificação
294 Rejeição: Certificado Assinatura revogado
295 Rejeição: Certificado Assinatura difere ICP-Brasil
296 Rejeição: Certificado Assinatura erro no acesso a LCR
297 Rejeição: Assinatura difere do calculado
298 Rejeição: Assinatura difere do padrão do Projeto
299 Rejeição: XML da área de cabeçalho com codificação diferente de UTF-8
401 Rejeição: CPF do remetente inválido
402 Rejeição: XML da área de dados com codificação diferente de UTF-8
403 Rejeição: O grupo de informações da NF-e avulsa é de uso exclusivo do Fisco
404 Rejeição: Uso de prefixo de namespace não permitido
405 Rejeição: Código do país do emitente: dígito inválido
406 Rejeição: Código do país do destinatário: dígito inválido
407 Rejeição: O CPF só pode ser informado no campo emitente para a NF-e avulsa
453 Rejeição: Ano de inutilização não pode ser superior ao Ano atual
454 Rejeição: Ano de inutilização não pode ser inferior a 2006
478 Rejeição: Local da entrega não informado para faturamento direto de veículos
novos
999 Rejeição: Erro não catalogado (informar a mensagem de erro capturado no
tratamento da exceção)         
CÓDIGO MOTIVOS DE DENEGAÇÃO DE USO
301 Uso Denegado : Irregularidade fiscal do emitente
302 Uso Denegado : Irregularidade fiscal do destinatário }


unit untNFCe;

interface

uses IniFiles, comctrls, sysutils, controls, classes,
     ComObj,variants,dialogs, StdCtrls, ShDocVw, Forms,
     pcnConversao, pcnNFeRTXT, ACBrUtil, DateUtils, ACBrNFe, ACBrNFeDANFeESCPOS,
     ACBrNFeDANFEClass, ACBrNFeDANFERave, ACBrDANFCeFortesFr, printers, ACBrNFeDANFERaveCB,

     func, ibquery, classes1, StrUtils, acbrbal;
 //
  procedure imprimirNfce();
  procedure lerVenda(const nota1 : String);
  function Retorna_FinalidadeNFe(svl:string):TpcnFinalidadeNFe;
  function FormataData(data : tdatetime) : string;
  function Retorna_UFComerciante(svl:string):String;
  function Retorna_TipoAmbiente(svl:string):TpcnTipoAmbiente;
  function Retorna_TipoEmissaoNFe(svl:string):TpcnTipoEmissao;
  function FormaPagamento_NFCe(formaPagto:String): TpcnFormaPagamento;
  procedure lerItensDaVenda(var lista : TList; const nota : string);
  FUNCTION NODO_ICMS(var MAT : Item_venda; CSTICM_CFOP, _ORIGE : string; indx : integer) : string;
  FUNCTION NODO_EMIT(CNPJ, RAZAO, FANTASIA, ENDE, BAIRRO, COD_MUN, NOM_MUN, UF, CEP, FONE, IE, CRT : string) : string;
  function GeraXml : String;
  procedure insereNotaBD(var dados : Tvenda);
  Function ProcuraItemNaLista(var lista : TList; cod1 : integer) : integer;
  procedure setPrinter(const indx : integer);
  procedure lerConfigBalanca();
 //
 procedure Verifica_Status_NFe;
 procedure LoadXML(MyMemo: TMemo; MyWebBrowser: TWebBrowser);
 function LerConfiguracaoCFOP():String;
 procedure LerConfiguracaoNFCe();
 procedure LerConfiguracaoNFe();
 procedure lerNodoIde(const codNF : integer);
 procedure lerNodoEmitDest();
 Procedure LerDados_Emit_Dest(codDest : string);
 function RetornaEndeRua(const entra : string) : string;
 function RetornaNumero(const entra : string) : string;
 function verNCM(const cod : integer) : String;
 function Format_num(valor : currency) : string;
 procedure inicializaVariaveis();
 FUNCTION NODO_PISCOFINS(var item1 : Item_venda; CSTPIS_CFOP : string; indx : integer) : string;

 procedure GravarConfiguracao(certificadoCaminho, certificadoSenha, certificadoNumeroSerie:String; FinalidadeNFE, DANFETipo, DANFEFormaEmissao:integer; DANFELogomarca:String;
                              ArqLog:Boolean; CaminhoLog, WebUF:String;  WebAmbiente:integer; WebVisualiza:Boolean; ProxHost, ProxPorta, ProxUser, ProxSenha, EmailHost, EmailPorta, EmailUsuario, EmailSenha,
                              EmailAssunto:String; EmailSSL:Boolean; ArquivosPDF:String; ArquivosNFE:String; CDCFOP:String; idToken, Token:String; idxImpre, tipoImpre : integer; preview : boolean;
                             const portaBalanca, veloBal, tipoBal : string);

 procedure CarregarConfiguracao();
 procedure setQueryNFCe(var Lista : TList);
 procedure lerPathSalvar(var path : String);

 procedure GerarNFCe(nota, NumNFCe, TipoEmissao, TipoAmbiente, UFComerciante, FinalidadeNFe : String);
 function EnviarCupomEletronico(nota : String):Boolean; overload;
 function  EnviarCupomEletronico(nota : String;var Status:String; vAux, vNumLote : String;var MemoResp:TMemo; WBResposta:TWebBrowser;TipoEmissao,TipoAmbiente,UFComerciante, FinalidadeNFe:String):Boolean; Overload;
 function  EnviarCupomEletronico(nota : String; var Status, xmotivo : string;const tipo : integer;const enviar : boolean; const cliente1 : String):Boolean; Overload;
 procedure Imprimir_DANFE_PDF(numeroNota:String);
 function  Cancelamento_NFe(numeroNota:String;MemoResp:TMemo; WBResposta:TWebBrowser):Boolean;  Overload;
 function Cancelamento_NFe(numeroNota:String):Boolean; Overload;
 procedure ConsultarNFe(numeroNota:String);
procedure reimpressaoNFCe(numeroNota:String);
 procedure Carrega_NotaFiscal_ArquivoXML(OpenDialog:TOpenDialog; var NotaFiscal:String; var CFOP:String; var CondPagto:String; var ModeloNF:String; var SerieNF:String; var DtEmissao:TDate; var DtEntSai:TDate;
                                                                 var HrEntSai:TDateTime; var CNPJEmitente:String; var InscEstEmitente:String; var InscMunicEmitente:String; var EnderecoEmitente:String;
                                                                 var NumeroEndEmitente:String; var BairroEmitente:String; var codMunicipoEmitente:String; var NomeMunicipioEmiente:String;
                                                                 var UFEmitente:String; var FoneEmitente:String; var CEPEmitente:String; var CNPJDestinario:String; var codMunicipioDestinario:String;
                                                                 var VlBaseCalculo:String; var VlICMS:String; var VlBaseCalculoST:String; var VlST:String; var VlProduto:String; var VlFrete:String; var VlSeguro:String;
                                                                 var VlDesconto:String; var VlIPI:String; var VlPis:String; var VlCofins:String; var VlOutros:String; var VlNotaFiscal:String;
                                                                 var ListaProdutos:TStrings);

var
 gProxHost,
 gProxPorta,
 gProxUser,
 gProxSenha, DigiVerifi, chaveNF, natOp, ERRO_dados : string;
 venda      : Tvenda;
 lista      : TList;
 codNF    : integer;
 query1, query2, query3 : tibquery;
 dadosEmitente, dadosDest : TStringList;
 TOT_PIS, TOT_COFINS, totalNota, PIS_ST, COFINS_ST, TRIB_ALIQ_COFINS, BASE_ICM,
 VLR_ICM, tot_Geral, TOTICM, TOT_BASEICM, PIS_NT, TRIB_ALIQ_PIS : currency;
 ACBrNFe: TACBrNFe;
 DANFE: TACBrNFeDANFCeFortes;
 DANFE_Rave: TACBrNFeDANFERaveCB;
 BALANCA   : TACBrBAL;
 pgerais : TStringList;
 tipoEmissao : integer;
 pathSalvarControlW, pastaControlW : String;

 indxImpressora         : integer;

 glbCFOP,
 glbNuCheque,
 glbNumeroDAV,
 glbNumeroIP, cliente    : string;
 gTipoEmissao   : string;
 gTipoAmbiente  : string;
 gUFComerciante : String;
 gFinalidadeNFe : String;
 gSmtpHost      : String;
 gSmtpPorta     : String;
 gSmtpUsuario   : String;
 gSmtpSenha     : String;
 gemailAssunto  : String;
 gemailSSL      : Boolean;
 ad_cdserie     : string;
 gArqPDF        : String;
 gArqNFE        : String;
 gSenhaCert     : String;

 //0-normal 1-resumido
 tipoIMPRESSAO : integer;
 contOFFLINE   : boolean;


implementation

uses pcnNFe, Math, DB, ACBrNFeNotasFiscais, pcnEventoNFe;


procedure lerConfigBalanca();
var
  Ini        : TIniFile ;
  arq : TStringList;
  pasta, tipo, velo, porta : String;
begin
  if not assigned(BALANCA) then exit;

  pasta := copy(ParamStr(0), 1, length(ParamStr(0)) - 3) + 'ini';
  if FilesExists(pasta) then
    begin
      Ini        := TIniFile.Create( pasta );

      porta := ini.ReadString('BALANCA', 'PORTA', 'COM1');
      velo  := ini.ReadString('BALANCA', 'VELO', '9600');
      tipo  := ini.ReadString('BALANCA', 'BALANCA', '0');
      ini.Free;

      BALANCA.Device.Baud  := StrToIntDef(velo, 9600);
      BALANCA.Device.Porta := porta;
      if tipo = '0' then BALANCA.Modelo := balNenhum
      else if tipo = '1' then BALANCA.Modelo := balDigitron
      else if tipo = '2' then BALANCA.Modelo := balFilizola
      else if tipo = '3' then BALANCA.Modelo := balLucasTec
      else if tipo = '4' then BALANCA.Modelo := balMagellan
      else if tipo = '5' then BALANCA.Modelo := balMagna
      else if tipo = '6' then BALANCA.Modelo := balToledo
      else if tipo = '7' then BALANCA.Modelo := balToledo2180
      else if tipo = '8' then BALANCA.Modelo := balUrano
      else if tipo = '8' then BALANCA.Modelo := balUranoPOP;
    end;
end;

procedure lerVenda(const nota1 : String);
begin
  query1.Close;
  query1.SQL.Clear;
  query1.SQL.Add('select v.nota, v.desconto, v.total, v.codhis, v.cliente, (select nome from formpagto f where f.cod = v.codhis) as nome from venda v where v.nota = :nota');
  query1.ParamByName('nota').AsString := nota1;
  query1.Open;

  if not Assigned(venda) then venda := Tvenda.Create;
  venda.total    := query1.fieldbyname('total').AsCurrency;
  venda.desconto := abs(query1.fieldbyname('desconto').AsCurrency);
  venda.cliente  := StrToIntDef(cliente, 1);
  venda.codForma := query1.fieldbyname('codhis').AsString;
  venda._FORMPG  := query1.fieldbyname('nome').AsString;
  venda.nota     := query1.fieldbyname('nota').AsInteger;
  venda.adic     := IfThen(contOFFLINE, 'OFF', '');
  query1.Close;
end;

procedure imprimirNfce();
begin
  try
    SetPrinter(indxImpressora);
    if tipoIMPRESSAO = 0 then ACBrNFe.NotasFiscais.Imprimir
      else ACBrNFe.NotasFiscais.ImprimirResumido;

    if tipoIMPRESSAO = 0 then ACBrNFe.NotasFiscais.ImprimirPDF
      else ACBrNFe.NotasFiscais.ImprimirResumidoPDF;
  except
  end;
end;

procedure lerPathSalvar(var path : String);
begin
  pathSalvarControlW := path;
end;

procedure setPrinter(const indx : integer);
begin
  if printer.Printers.Count = 0 then exit;
  printer.PrinterIndex := indx;
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

procedure setQueryNFCe(var Lista : TList);
var
  fim : integer;
begin
  fim := lista.Count -1;
  if 0 <= fim then query1     := TIBQuery(Lista.Items[0]);
  if 1 <= fim then query2     := TIBQuery(Lista.Items[1]);
  if 2 <= fim then ACBrNFe    := TACBrNFe(Lista.Items[2]);
  if 3 <= fim then pgerais    := TStringList(lista.Items[3]);
  if 4 <= fim then DANFE      := TACBrNFeDANFCeFortes(Lista.Items[4]);
  if 5 <= fim then DANFE_Rave := TACBrNFeDANFERaveCB(lista.Items[5]);
  if 6 <= fim then BALANCA    := TACBrBAL(lista.Items[6]);
end;

procedure insereNotaBD(var dados : Tvenda);
begin
  query1.Close;
  Query1.SQL.Text := 'update or insert into nfce(chave, nota, data, cliente, adic) values(:chave, :nota, :data, :cliente, :adic)';
  Query1.ParamByName('chave').AsString    := dados.chave;
  Query1.ParamByName('nota').AsInteger    := dados.nota;
  Query1.ParamByName('data').AsDate       := now;
  Query1.ParamByName('cliente').AsInteger := dados.cliente;
  Query1.ParamByName('adic').AsString     := dados.adic;
  Query1.ExecSQL;
  Query1.Transaction.Commit;
end;

procedure inicializaVariaveis();
begin
  TOT_PIS     := 0;
  TOT_COFINS  := 0;
  TOTICM      := 0;
  TOT_BASEICM := 0;
  PIS_ST      := 0;
  PIS_NT      := 0;
  tot_Geral   := 0;
end;

FUNCTION NODO_EMIT(CNPJ, RAZAO, FANTASIA, ENDE, BAIRRO, COD_MUN, NOM_MUN, UF, CEP, FONE, IE, CRT : string) : string;
var
  invalido : integer;
  ok : boolean;
begin
  INVALIDO := 0;
  ok := true;
  //OK := VALIDACNPJ(CNPJ);

  IF(NOT OK) then
    begin
      ERRO_dados := 'CNPJ do Emitente Inválido ' + #13;
    end;
 { INVALIDO := invalido + CAMPO_VAZIO(ENDE);
  INVALIDO := invalido + CAMPO_VAZIO(BAIRRO);
  INVALIDO := invalido + CAMPO_VAZIO(COD_MUN);
  INVALIDO := invalido + CAMPO_VAZIO(NOM_MUN);
  INVALIDO := invalido + CAMPO_VAZIO(UF);
  INVALIDO := invalido + CAMPO_VAZIO(CEP);
  }IF INVALIDO <> 0 then
    begin
      ERRO_DADOS := erro_dados + 'Dados do Emitente Incompletos ' + #13;
      exit;
    end;

  Result := '<emit><CNPJ>' + CNPJ + '</CNPJ><xNome>' + RAZAO + '</xNome>' +
  '<xFant>' + (FANTASIA) + '</xFant><enderEmit>' +
  (ENDE) + '<xBairro>' + BAIRRO + '</xBairro><cMun>' +
  COD_MUN + '</cMun><xMun>' + NOM_MUN + '</xMun><UF>' + UF + '</UF>' +
  '<CEP>' + CEP + '</CEP><cPais>1058</cPais><xPais>BRASIL</xPais>' +
  '<fone>' + FONE + '</fone></enderEmit><IE>' + IE + '</IE><CRT>' + CRT + '</CRT></emit>';
end;

function FormataData(data : tdatetime) : string;
begin
  Result := FormatDateTime('YYYY-MM-DD',data);
end;


function GeraXml : String;
var
  Nome_Arquivo, Caminho,arq, test, ce : string;
  ini : integer;
begin
  PIS_ST := 0;
  PIS_NT := 0;
  COFINS_ST := 0;
  {valida := false;
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
}end;


FUNCTION NODO_PISCOFINS(var item1 : Item_venda; CSTPIS_CFOP : string; indx : integer) : string;
VAR
   COF_ALIQ, PIS_ALIQ : string;
  tot, VLR_COFINS, VLR_PIS : currency;
begin
  TOT := item1.total - item1.Desconto;
  //SE FOR OPTANTE DO SIMPLES NACIONAL, NAO USA TAG PIS/COFINS
  IF pgerais.Values['10'] = '1' then
    begin
      with ACBrNFe.NotasFiscais.Items[0].NFe.Det.Items[indx].Imposto do
        begin
          pis.CST := pis01;
          pis.vBC := tot;
          PIS.vPIS := 0;
          COFINS.CST := cof01;
          COFINS.vBC := tot;
          COFINS.pCOFINS := 0;
          COFINS.vCOFINS := 0;
        end;
     { Result := '<PIS><PISAliq><CST>01</CST><vBC>' + FORMAT_NUM(TOT) + '</vBC><pPIS>0.00</pPIS>' +
      '<vPIS>0.00</vPIS></PISAliq></PIS>' +
      '<COFINS><COFINSAliq><CST>01</CST><vBC>' + FORMAT_NUM(TOT) + '</vBC>' +
      '<pCOFINS>0.00</pCOFINS><vCOFINS>0.00</vCOFINS></COFINSAliq></COFINS>';
      }exit;
    end;

  PIS_ALIQ := '<PISAliq><CST>02</CST><vBC>' + FORMAT_NUM(TOT) + '</vBC><pPIS>0.00</pPIS>' +
  '<vPIS>0.00</vPIS></PISAliq>';
  COF_ALIQ := '<COFINSAliq><CST>02</CST><vBC>' + FORMAT_NUM(TOT) + '</vBC>' +
  '<pCOFINS>0.00</pCOFINS><vCOFINS>0.00</vCOFINS></COFINSAliq>';

  //SE O CFOP E ISENTO DE PIS/COFINS
  IF CSTPIS_CFOP = 'I' then
    begin
      with ACBrNFe.NotasFiscais.Items[0].NFe.Det.Items[indx].Imposto do
        begin
          pis.CST    := pis07;
          COFINS.CST := cof07;
          pis.vPIS   := 0;
          COFINS.vCOFINS := 0;
        end;

      PIS_NT := PIS_NT + TOT;
      {Result := '<PIS>' + PIS_ALIQ + '<PISNT><CST>07</CST></PISNT></PIS>' +
      '<COFINS>' + COF_ALIQ + '<COFINSNT><CST>07</CST></COFINSNT></COFINS>';
      }exit;
    end;

  //SE O CFOP NAO E TRIBUTADO POR PIS/COFINS
  IF CSTPIS_CFOP = 'N' then
    begin
      with ACBrNFe.NotasFiscais.Items[0].NFe.Det.Items[indx].Imposto do
        begin
          pis.CST    := pis06;
          COFINS.CST := cof06;
          pis.vPIS   := 0;
          COFINS.vCOFINS := 0;
        end;

      PIS_NT := PIS_NT + TOT;
      Result := '<PIS>' + PIS_ALIQ + '<PISNT><CST>06</CST></PISNT></PIS>' +
      '<COFINS>' + COF_ALIQ + '<COFINSNT><CST>06</CST></COFINSNT></COFINS>' ;
      exit;
    end;

   //SE O CFOP TEM  A ALIQ RED. A ZERO DE PIS/COFINS
   IF CSTPIS_CFOP = 'R' then
     begin
       with ACBrNFe.NotasFiscais.Items[0].NFe.Det.Items[indx].Imposto do
        begin
          pis.CST    := pis02;
          pis.vBC    := tot;
          COFINS.CST := cof02;
          COFINS.vBC := tot;
          pis.pPIS   := 0;
          pis.vPIS   := 0;
          COFINS.vCOFINS := 0;
          COFINS.pCOFINS := 0;
        end;

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
       with ACBrNFe.NotasFiscais.Items[0].NFe.Det.Items[indx].Imposto do
        begin
          pis.CST    := pis04;
          COFINS.CST := cof04;
        end;

       PIS_NT := PIS_NT + TOT;
       Result := '<PIS>' + '<PISNT><CST>04</CST></PISNT></PIS>' +
       '<COFINS>' + '<COFINSNT><CST>04</CST></COFINSNT></COFINS>';
     end;

   //SE O CFOP E ISENTO DE PIS/COFINS
   IF CSTPIS_CFOP = 'X' then
     begin
       with ACBrNFe.NotasFiscais.Items[0].NFe.Det.Items[indx].Imposto do
        begin
          pis.CST    := pis08;
          COFINS.CST := cof08;
        end;

       PIS_NT := PIS_NT + TOT;
       Result := '<PIS><PISNT><CST>08</CST></PISNT></PIS>' +
       '<COFINS><COFINSNT><CST>08</CST></COFINSNT></COFINS>';
    end;

    //SE O CFOP TEM ALIQ DIFERENCIADA
    IF CSTPIS_CFOP = 'D' then
     begin
       with ACBrNFe.NotasFiscais.Items[0].NFe.Det.Items[indx].Imposto do
        begin
          pis.CST    := pis02;
          pis.vBC    := tot;
          COFINS.CST := cof02;
          COFINS.vBC := tot;
          pis.pPIS   := 0;
          pis.vPIS   := 0;
          cofins.pCOFINS := 0;
          cofins.vCOFINS := 0;
        end;

       PIS_NT := PIS_NT + TOT;
       {Result := '<PIS><PISAliq><CST>02</CST><vBC>' + FORMAT_NUM(TOT) + '</vBC><pPIS>0.00</pPIS>' +
       '<vPIS>' + Format_num(0.00) + '</vPIS></PISAliq></PIS>'  +
       '<COFINS><COFINSAliq><CST>02</CST><vBC>' + FORMAT_NUM(TOT) + '</vBC>' +
       '<pCOFINS>0.00</pCOFINS><vCOFINS>' + Format_num(0.00) + '</vCOFINS></COFINSAliq></COFINS>';}
     end;

   //CFOP - SE JA RECOLHEU PIS/COFINS POR SUBSTITUICAO TRIBUTARIA
   IF CSTPIS_CFOP = 'S' then
     begin
       VLR_PIS := ARREDONDA(item1.Total_Preco_Compra * TRIB_ALIQ_PIS /100, 2);
       VLR_COFINS := ARREDONDA(item1.Total_Preco_Compra * TRIB_ALIQ_COFINS /100, 2);
       PIS_ST := PIS_ST + VLR_PIS;
       COFINS_ST := COFINS_ST + VLR_COFINS;

       with ACBrNFe.NotasFiscais.Items[0].NFe.Det.Items[indx].Imposto do
        begin
          pis.CST    := pis02;
          pis.vBC    := tot;
          pis.pPIS   := TRIB_ALIQ_PIS;
          pis.vPIS   := VLR_PIS;
          COFINS.CST := cof02;
          COFINS.vBC := item1.Total_Preco_Compra;
          cofins.pCOFINS := TRIB_ALIQ_COFINS;
          cofins.vCOFINS := VLR_COFINS;
        end;

       {Result := '<PIS>' + PIS_ALIQ + '<PISST><vBC>' + FORMAT_NUM(item1.Total_Preco_Compra) + '</vBC>' +
       '<pPIS>' + FORMAT_NUM(TRIB_ALIQ_PIS) + '</pPIS>' +
       '<vPIS>' + FORMAT_NUM(VLR_PIS) + '</vPIS></PISST></PIS>' +
       '<COFINS>' + COF_ALIQ + '<COFINSST><vBC>' + FORMAT_NUM(item1.Total_Preco_Compra) + '</vBC>' +
       '<pCOFINS>' + FORMAT_NUM(TRIB_ALIQ_COFINS) + '</pCOFINS>' +
       '<vCOFINS>' + FORMAT_NUM(VLR_COFINS) + '</vCOFINS></COFINSST></COFINS>';}
       exit;
     end;

   //SE O PRODUTO E ISENTO DE PIS/COFINS
   IF item1.Pis = 'I' then
     begin
       PIS_NT := PIS_NT + TOT;

       with ACBrNFe.NotasFiscais.Items[0].NFe.Det.Items[indx].Imposto do
        begin
          pis.CST    := pis07;
          pis.vBC    := tot;
          pis.pPIS   := TRIB_ALIQ_PIS;
          pis.vPIS   := 0;
          COFINS.CST := cof02;
          COFINS.vBC := item1.Total_Preco_Compra;
          cofins.pCOFINS := TRIB_ALIQ_COFINS;
          cofins.vCOFINS := 0;
        end;

     //  Result := '<PIS>' + PIS_ALIQ + '<PISNT><CST>07</CST></PISNT></PIS>' +
     //  '<COFINS>' + COF_ALIQ + '<COFINSNT><CST>07</CST></COFINSNT></COFINS>' ;
       exit;
     end;

   //SE O PRODUTO NAO E TRIBUTADO POR PIS/COFINS
   IF item1.Pis = 'N' then
     begin
       PIS_NT := PIS_NT + TOT;
       Result := '<PIS>' + PIS_ALIQ + '<PISNT><CST>06</CST></PISNT></PIS>' +
       '<COFINS>' + COF_ALIQ + '<COFINSNT><CST>06</CST></COFINSNT></COFINS>';
       exit;
     end;

   //SE O PRODUTO TEM  A ALIQ RED. A ZERO DE PIS/COFINS
   IF item1.Pis = 'R' then
     begin
       PIS_NT := PIS_NT + TOT;
       Result := '<PIS><PISAliq><CST>02</CST><vBC>' + FORMAT_NUM(TOT) + '</vBC><pPIS>0.00</pPIS>' +
       '<vPIS>0.00</vPIS></PISAliq></PIS>'  +
       '<COFINS><COFINSAliq><CST>02</CST><vBC>' + FORMAT_NUM(TOT) + '</vBC>' +
       '<pCOFINS>0.00</pCOFINS><vCOFINS>0.00</vCOFINS></COFINSAliq></COFINS>' ;
       exit;
     end;

   //PRODUTO - SE JA RECOLHEU PIS/COFINS POR SUBSTITUICAO TRIBUTARIA
   IF item1.Pis = 'S' then
     begin
       VLR_PIS := ARREDONDA(item1.Total_Preco_Compra * TRIB_ALIQ_PIS /100, 2);
       VLR_COFINS := ARREDONDA(item1.Total_Preco_Compra * TRIB_ALIQ_COFINS /100, 2);
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
     TRIB_ALIQ_PIS    := StrToCurr(pgerais.Values['11']);
     TRIB_ALIQ_COFINS := StrToCurr(pgerais.Values['12']);
   except
     TRIB_ALIQ_COFINS := 0;
     TRIB_ALIQ_COFINS := 0;
   end;
   //REGIME NORMAL - RECOLHIMENTO DE PIS E COFINS
   //CALCULA PIS/COFINS SOBRE O VALOR DO PRODUTO - DESCONTO
   VLR_PIS := ARREDONDA(TOT * TRIB_ALIQ_PIS /100, 2);
   TOT_PIS := TOT_PIS + VLR_PIS;
   VLR_COFINS := ARREDONDA(TOT * TRIB_ALIQ_COFINS /100, 2);
   TOT_COFINS := TOT_COFINS + VLR_COFINS;

   with ACBrNFe.NotasFiscais.Items[0].NFe.Det.Items[indx].Imposto do
     begin
       pis.CST    := pis01;
       pis.vBC    := tot;
       pis.pPIS   := TRIB_ALIQ_PIS;
       pis.vPIS   := VLR_PIS;
       COFINS.CST := cof01;
       COFINS.vBC := item1.Total_Preco_Compra;
       cofins.pCOFINS := TRIB_ALIQ_COFINS;
       cofins.vCOFINS := VLR_COFINS;
     end;

  { Result := '<PIS><PISAliq><CST>01</CST><vBC>' + FORMAT_NUM(TOT) + '</vBC>' +
   '<pPIS>' + FORMAT_NUM(TRIB_ALIQ_PIS) + '</pPIS>' +
   '<vPIS>' + FORMAT_NUM(VLR_PIS) +
   '</vPIS></PISAliq></PIS>' +
   '<COFINS><COFINSAliq><CST>01</CST><vBC>' + FORMAT_NUM(TOT) + '</vBC>' +
   '<pCOFINS>' + FORMAT_NUM(TRIB_ALIQ_COFINS) + '</pCOFINS>' +
   '<vCOFINS>' + FORMAT_NUM(VLR_COFINS) +
   '</vCOFINS></COFINSAliq></COFINS>';
}end;


function Format_num(valor : currency) : string;
begin
  Result := trim(FormatCurr('0.00', valor));
end;

FUNCTION NODO_ICMS(var MAT : Item_venda; CSTICM_CFOP, _ORIGE : string; indx : integer) : string;
var
  tot : currency;
  cod_OP : String;
begin
  tot    := mat.total - mat.Desconto;
  cod_OP := '5102';
  Result := '';
  //se a empresa é optante do simples nacional
  if pgerais.values['10'] = '1' then
    begin
      //EXPORTAÇÃO - CSOSN = 300
      IF Contido(LeftStr(cod_OP, 1), '4-7') then
        begin
          with ACBrNFe.NotasFiscais.Items[0].NFe.Det.Items[indx].Imposto do
            begin
              ICMS.CSOSN := csosn300;
              ICMS.orig  := oeNacional;
            end;
          Result := '<ICMS><ICMSSN102><orig>' + _ORIGE + '</orig><CSOSN>300</CSOSN></ICMSSN102></ICMS>';
          exit;
        end;

      if mat.CodAliq = 10 then
        begin
          with ACBrNFe.NotasFiscais.Items[0].NFe.Det.Items[indx].Imposto do
            begin
              ICMS.CSOSN := csosn500;
              ICMS.orig  := oeNacional;
              ICMS.vBCSTRet := mat.p_compra;
              ICMS.vICMSSTRet := ARREDONDA(mat.p_compra * 0.16, 2);
            end;
        {  Result := '<ICMS><ICMSSN500><orig>' + _ORIGE + '</orig><CSOSN>500</CSOSN>' +
          '<vBCSTRet>' + FormatCurr('0.00',mat.p_compra) + '</vBCSTRet>' +
          '<vICMSSTRet>' + FormatCurr('0.00',ARREDONDA(mat.p_compra * 0.16, 2)) + '</vICMSSTRet>' +
          '</ICMSSN500></ICMS>';
        }  exit;
        end;

      if mat.CodAliq = 11 then
        begin
          with ACBrNFe.NotasFiscais.Items[0].NFe.Det.Items[indx].Imposto do
            begin
              ICMS.CSOSN := csosn102;
              ICMS.orig  := oeNacional;
            end;

          //Result := '<ICMS><ICMSSN102><orig>' + _ORIGE + '</orig><CSOSN>400</CSOSN></ICMSSN102></ICMS>';
          exit;
        end;

      if mat.CodAliq = 12 then
        begin
          with ACBrNFe.NotasFiscais.Items[0].NFe.Det.Items[indx].Imposto do
            begin
              ICMS.CSOSN := csosn102;
              ICMS.orig  := oeNacional;
            end;
          Result := '<ICMS><ICMSSN102><orig>' + _ORIGE + '</orig><CSOSN>300</CSOSN></ICMSSN102></ICMS>';
          exit;
        end;

      if mat.Reducao <> 0 then
        begin
          with ACBrNFe.NotasFiscais.Items[0].NFe.Det.Items[indx].Imposto do
            begin
              ICMS.CSOSN := csosn900;
              ICMS.orig  := oeNacional;
              ICMS.modBC := dbiValorOperacao;
              icms.vBC   := ARREDONDA(tot * mat.Reducao / 100, 2);
              icms.pICMS := mat.p_venda;
              ICMS.vICMS := 0;
              ICMS.vBCST := 0;
              icms.pICMSST := 0;
              icms.vICMSST := 0;
              icms.pCredSN := 0;
              icms.vCredICMSSN := 0;
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

      //TRIBUTACAO NORMAL PELO SIMPLES NACIONAL
      with ACBrNFe.NotasFiscais.Items[0].NFe.Det.Items[indx].Imposto do
        begin
          icms.CSOSN := csosn102;
          icms.orig  := oeNacional;
        end;

      Result := '<ICMS><ICMSSN102><orig>' + _ORIGE + '</orig><CSOSN>102</CSOSN></ICMSSN102></ICMS>';
      exit;
    end;

  //EXPORTAÇÃO - CST = 41
  IF Contido(LeftStr(cod_OP, 1), '4-7') then
    begin
      with ACBrNFe.NotasFiscais.Items[0].NFe.Det.Items[indx].Imposto do
        begin
          icms.CST   := cst41;
          icms.orig  := oeNacional;
        end;
      Result := '<ICMS><ICMS40><orig>' + _ORIGE + '</orig><CST>41</CST></ICMS40></ICMS>';
      exit;
    end;

{  //CFOP SUBSTITUICAO TRIBUTARIA
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

//TRIBUTACAO DO ICMS EM REGIME NORMAL
//PRODUTO SUBSTITUICAO TRIBUTARIA
IF mat.CodAliq = 10 then
  begin
    with ACBrNFe.NotasFiscais.Items[0].NFe.Det.Items[indx].Imposto do
      begin
        icms.CST   := cst60;
        icms.orig  := oeNacional;
        icms.vBCSTRet := mat.p_compra;
        icms.vICMSSTRet := ARREDONDA(mat.p_compra * 0.16, 2);
      end;

{    Result := '<ICMS><ICMS60><orig>' + _ORIGE + '</orig><CST>60</CST>' +
    '<vBCSTRet>' + FORMAT_NUM(mat.p_compra) + '</vBCSTRet>' +
    '<vICMSSTRet>' + FORMAT_NUM(ARREDONDA(mat.p_compra * 0.16, 2)) + '</vICMSSTRet>' +
    '</ICMS60></ICMS>';
 }   exit;
  end;

//PRODUTO ISENTO
IF mat.CodAliq = 11 then
  begin
    with ACBrNFe.NotasFiscais.Items[0].NFe.Det.Items[indx].Imposto do
      begin
        icms.CST   := cst40;
        icms.orig  := oeNacional;
      end;
   Result := '<ICMS><ICMS40><orig>' + _ORIGE + '</orig><CST>40</CST></ICMS40></ICMS>';
   exit;
  end;

//PRODUTO NAO SE APLICA ICM
IF mat.CodAliq = 12 then
  begin
    with ACBrNFe.NotasFiscais.Items[0].NFe.Det.Items[indx].Imposto do
      begin
        icms.CST   := cst41;
        icms.orig  := oeNacional;
      end;

   Result := '<ICMS><ICMS40><orig>' + _ORIGE + '</orig><CST>41</CST></ICMS40></ICMS>';
   exit;
  end;

//PRODUTO TRIBUTADO COM REDUCAO NA BASE DE CALCULO
IF mat.Reducao <> 0 then
  begin
    BASE_ICM := ARREDONDA(TOT - (TOT * mat.Reducao / 100), 2);
    VLR_ICM := ARREDONDA(BASE_ICM * mat.PercICMS / 100, 2);
    TOTICM := TOTICM + VLR_ICM;
    TOT_BASEICM := TOT_BASEICM + BASE_ICM;

    with ACBrNFe.NotasFiscais.Items[0].NFe.Det.Items[indx].Imposto do
      begin
        icms.CST    := cst20;
        icms.modBC  := dbiValorOperacao;
        icms.orig   := oeNacional;
        icms.pRedBC := mat.Reducao;
        icms.vBC    := BASE_ICM;
        icms.pICMS  := mat.PercICMS;
        icms.vICMS  := VLR_ICM;
      end;

  {  BASE_ICM := ARREDONDA(TOT - (TOT * mat.Reducao / 100), 2);
    VLR_ICM := ARREDONDA(BASE_ICM * mat.PercICMS / 100, 2);
    TOTICM := TOTICM + VLR_ICM;
    TOT_BASEICM := TOT_BASEICM + BASE_ICM;
    Result := '<ICMS><ICMS20><orig>' + _ORIGE + '</orig><CST>20</CST><modBC>3</modBC>' +
    '<pRedBC>' + FORMAT_NUM(mat.Reducao) + '</pRedBC>' +
    '<vBC>' + FORMAT_NUM(BASE_ICM) + '</vBC>' +
    '<pICMS>' + FORMAT_NUM(mat.PercICMS) + '</pICMS>' +
    '<vICMS>' + FORMAT_NUM(VLR_ICM) + '</vICMS></ICMS20></ICMS>';
  }  exit;
  end;

  //TRIBUTADO INTEGRAL
  BASE_ICM := tot;
  VLR_ICM := ARREDONDA(BASE_ICM * mat.PercICMS / 100, 2);
  TOTICM := TOTICM + VLR_ICM;
  TOT_BASEICM := TOT_BASEICM + BASE_ICM;

  with ACBrNFe.NotasFiscais.Items[0].NFe.Det.Items[indx].Imposto do
      begin
        icms.CST    := cst00;
        icms.modBC  := dbiValorOperacao;
        icms.orig   := oeNacional;
        icms.vBC    := BASE_ICM;
        icms.pICMS  := mat.PercICMS;
        icms.vICMS  := VLR_ICM;
      end;

  {Result := '<ICMS><ICMS00><orig>' + _ORIGE + '</orig><CST>00</CST><modBC>3</modBC>' +
   '<vBC>' + FORMAT_NUM(BASE_ICM) + '</vBC>' +
   '<pICMS>' + FORMAT_NUM(mat.PercICMS) + '</pICMS>' +
   '<vICMS>' + FORMAT_NUM(VLR_ICM) + '</vICMS></ICMS00></ICMS>';
}end;

function verNCM(const cod : integer) : String;
begin
  Result := '96089989';

  Query2.Close;
  Query2.SQL.Text := 'select classif from produto where cod = :cod';
  Query2.ParamByName('cod').AsInteger := cod;
  Query2.Open;

  if Length(Query2.FieldByName('classif').AsString) = 8 then Result := Query2.FieldByName('classif').AsString;
  Query2.Close;
end;

function RetornaEndeRua(const entra : string) : string;
begin
  Result := '';
  if Contido(',',entra) then
    begin
      result := copy(entra,1,PosFinal(',',entra)-1);
    end
  else
    begin
      result := copy(entra,1,PosFinal(' ',entra)-1);
    end;
end;

function RetornaNumero(const entra : string) : string;
begin
  Result := '';
  if Contido(',',entra) then
    begin
      result := copy(entra, PosFinal(',',entra) + 1,length(entra));
    end
  else
    begin
      result := copy(entra, PosFinal(' ',entra) + 1,length(entra));
    end;
end;

procedure lerNodoEmitDest();
begin
  with ACBrNFe.NotasFiscais.Items[0].NFe do
    begin
     Emit.CNPJCPF           := dadosEmitente.Values['cnpj'];
     Emit.IE := dadosEmitente.Values['ies'];
     if EMIT.IE = '' then
       begin
         Emit.IE   := 'ISENTO';
         emit.IEST := 'ISENTO';
       end;
     Emit.xNome             := dadosEmitente.Values['razao'];
     Emit.xFant             := dadosEmitente.Values['empresa'];
     Emit.EnderEmit.fone    := dadosEmitente.Values['telres'];
     Emit.EnderEmit.CEP     := 0;
     Emit.EnderEmit.xLgr    := RetornaEndeRua(dadosEmitente.Values['ende']);
     Emit.EnderEmit.nro     := RetornaNumero(dadosEmitente.Values['ende']);
     Emit.EnderEmit.xCpl    := '';
     Emit.EnderEmit.xBairro := dadosEmitente.Values['bairro'];
     Emit.EnderEmit.cMun    := StrToIntDef((dadosEmitente.Values['cod_mun']), 1400100);
     Emit.EnderEmit.xMun    := dadosEmitente.Values['cid'];
     Emit.EnderEmit.UF      := dadosEmitente.Values['est'];
     Emit.enderEmit.cPais   := 1058;
     Emit.enderEmit.xPais   := 'BRASIL';

     if pgerais.Values['10'] = '1' then        Emit.CRT := crtSimplesNacional
       else if pgerais.Values['10'] = '2' then Emit.CRT := crtSimplesExcessoReceita
       else Emit.CRT := crtRegimeNormal;
     // (1-crtSimplesNacional, 2-crtSimplesExcessoReceita, 3-crtRegimeNormal)

     if dadosDest.Values['cod'] = '' then exit;
     if ((dadosDest.Values['tipo'] = '1') or (dadosDest.Values['tipo'] = '6')) then
       begin
         dest.indIEDest := inNaoContribuinte;
       end
     else
       begin
         dest.IE      := dadosDest.Values['ies'];
         if dest.IE = '' then dest.indIEDest := inNaoContribuinte
           else dest.indIEDest := inContribuinte;
       end;

     dest.IE        := '';
     dest.indIEDest := inNaoContribuinte;


     Dest.CNPJCPF := dadosDest.Values['cnpj'];
     Dest.xNome             := dadosDest.Values['nome'];
     Dest.EnderDest.fone    := dadosDest.Values['telres'];
     //if RetiraCaracteresEspeciais(qr.FieldByName('CEPCLIENTE').AsString) = '' then
     Dest.EnderDest.CEP     := 0; //else
   //  Dest.EnderDest.CEP     := StrToInt(RetiraCaracteresEspeciais(qr.FieldByName('CEPCLIENTE').AsString));
     Dest.EnderDest.xLgr    := RetornaEndeRua(dadosDest.Values['ende']);
     Dest.EnderDest.nro     := RetornaNumero(dadosDest.Values['ende']);
     Dest.EnderDest.xCpl    := ' ';
     Dest.EnderDest.xBairro := dadosDest.Values['bairro'];
     //
     if dadosDest.Values['cod_mun'] = '' then dadosDest.Values['cod_mun'] := dadosEmitente.Values['cod_mun'];
     Dest.EnderDest.cMun    := StrToInt(dadosDest.Values['cod_mun']);
     //
     Dest.EnderDest.xMun    := dadosDest.Values['cid'];
     Dest.EnderDest.UF      := dadosDest.Values['est'];
     Dest.EnderDest.cPais   := 1058;
     Dest.EnderDest.xPais   := 'BRASIL';
   end;
end;

Procedure LerDados_Emit_Dest(codDest : string);
 var i : integer;
begin
  Query1.Close;
  Query1.SQL.Clear;
  Query1.SQL.Add('select * from registro');
  Query1.Open;

  dadosEmitente := TStringList.Create;
  dadosDest := TStringList.Create;

  dadosEmitente.Values['cod_mun'] := Query1.fieldbyname('cod_mun').AsString;
  dadosEmitente.Values['ies']     := StrNum(Query1.fieldbyname('ies').AsString);
  dadosEmitente.Values['razao']   := Query1.fieldbyname('nome').AsString;
  dadosEmitente.Values['empresa'] := trim(Query1.fieldbyname('empresa').AsString);
  dadosEmitente.Values['cnpj']    := StrNum(Query1.fieldbyname('cnpj').AsString);
  dadosEmitente.Values['est']     := Query1.fieldbyname('est').AsString;
  dadosEmitente.Values['ende']    := Query1.fieldbyname('ende').AsString;
  dadosEmitente.Values['bairro']  := Query1.fieldbyname('bairro').AsString;
  dadosEmitente.Values['cep']     := StrNum(Query1.fieldbyname('cep').AsString);
  dadosEmitente.Values['telres']  := StrNum(Query1.fieldbyname('telres').AsString);
  dadosEmitente.Values['cid']     := Query1.fieldbyname('cid').AsString;
//  dadosEmitente.Values['nf'] := codNFe;
//  nfeTemp := codNFe;

  Query1.Close;
  Query1.SQL.Clear;
  Query1.SQL.Add('select * from cliente where cod = :cod');
  Query1.ParamByName('cod').AsString := codDest;
  Query1.Open;

  dadosDest.Values['cod']    := '';
  if (not query1.IsEmpty) then
    begin
      dadosDest.Values['cod']     := codDest;
      dadosDest.Values['cod_mun'] := IfThen(trim(Query1.fieldbyname('cod_mun').AsString) = '', dadosEmitente.Values['cod_mun'], trim(Query1.fieldbyname('cod_mun').AsString));
      dadosDest.Values['tipo']    := trim(Query1.fieldbyname('tipo').AsString);
      dadosDest.Values['cnpj']    := StrNum(Query1.fieldbyname('cnpj').AsString);
      dadosDest.Values['nome']    := trim(Query1.fieldbyname('nome').AsString);
      dadosDest.Values['ende']    := trim(Query1.fieldbyname('ende').AsString);
      dadosDest.Values['est']     := trim(Query1.fieldbyname('est').AsString);
      dadosDest.Values['bairro']  := trim(Query1.fieldbyname('bairro').AsString);
      dadosDest.Values['cep']     := StrNum(Query1.fieldbyname('cep').AsString);
      dadosDest.Values['telres']  := StrNum(Query1.fieldbyname('telres').AsString);
      dadosDest.Values['cid']     := trim(Query1.fieldbyname('cid').AsString);
      dadosDest.Values['ies']     := trim(Query1.fieldbyname('ies').AsString);
    end;
    
  Query1.Close;

end;

procedure lerNodoIde(const codNF : integer);
begin

  with ACBrNFe.NotasFiscais.Items[0].NFe do
    begin
     Ide.cNF       := codNF;
     Ide.natOp     := 'VENDA COMSUMIDOR';
     Ide.indPag    := ipVista;
     Ide.modelo    := 65;
     Ide.serie     := 1;
     Ide.nNF       := codNF;
     Ide.dEmi      := Now;
     Ide.dSaiEnt   := Now;
     Ide.hSaiEnt   := Now;
     Ide.tpNF      := tnSaida;
     if contOFFLINE then
       begin
         Ide.tpEmis := teOffLine;
         ide.dhCont := now;
         ide.xJust  := 'NOTA FISCAL EMITIDA EM CONTINGENCIA';
       end
     else Ide.tpEmis := teNormal;

     if pgerais.Values['tpamb'] = '1' then
       begin
         Ide.tpAmb     := taProducao;
       end
     else
       begin
         Ide.tpAmb    := taHomologacao;
         ACBrNFe.Configuracoes.Geral.IdToken := '000001';
         ACBrNFe.Configuracoes.Geral.Token   :=
         Copy(ACBrNFe.NotasFiscais.Items[0].NFe.Emit.CNPJCPF, 1, 8) + IntToStr(YearOf(Now)) + '0001';
       end;
     Ide.finNFe    := fnNormal;
     Ide.tpImp     := tiNFCe;
     Ide.indFinal  := cfConsumidorFinal;
     Ide.indPres   := pcPresencial;

     Ide.cUF       := 14;
     Ide.cMunFG    := StrToIntDef(dadosEmitente.Values['cod_mun'], 1400100);
   //Ide.cMunFG    := 1400100;

     Transp.modFrete := mfSemFrete; // NFC-e não pode ter FRETE
   end;
end;

procedure lerItensDaVenda(var lista : TList; const nota : string);
var
   desc,temp, tot, temp1 : currency;
   i, fim, tem : integer;
   aliq : string[3];
   CB : Boolean;
   item : Item_venda;
   totDesc, totalNotaORIGI : currency;
begin
  venda := Tvenda.Create;
  totalNota := 0;
  totDesc := 0;
  totalNotaORIGI := 0;
  lista := TList.Create;

  {fim := notas.Count - 1 ;
  for i := 0 to fim do
    begin
      nota := notas.Strings[i];
   }

     lerVenda(nota);

     totDesc        := venda.desconto;
     totalNotaORIGI := venda.total;

      query1.Close;
      query1.SQL.Clear;
      query1.SQL.Add('select cod, quant, total, p_venda, aliquota, P_compra from item_venda where nota = :nota');
      query1.ParamByName('nota').AsString := nota;
      query1.Open;

      while not query1.Eof do
        begin

          query2.SQL.Clear;
          query2.SQL.Add('select cod, nome, codbar, unid, aliquota, is_pis from produto where cod = :cod');
          query2.ParamByName('cod').AsString := query1.fieldbyname('cod').AsString;
          query2.Open;
         if not query2.IsEmpty then
         begin

          tem := ProcuraItemNaLista(lista, query1.fieldbyname('cod').AsInteger );
          if tem <> -1 then
            begin
              item := lista.Items[tem];
              item.quant := item.quant + query1.fieldbyname('quant').AsCurrency;
              item.total := item.total + query1.fieldbyname('total').AsCurrency;
              totalNota := totalNota   + query1.fieldbyname('total').AsCurrency;
            end
          else
            begin
              item := Item_venda.Create ;

              CB := false;

              try
                cb    := true;
                cb    := checaCodbar(StrNum(query2.fieldbyname('codbar').AsString));
              except
              end;

              if CB then
                begin
                  item.codbar := StrNum(query2.fieldbyname('codbar').AsString);
                end
              else
                begin
                  item.codbar := DIGEAN('789000' + CompletaOuRepete('', query2.fieldbyname('cod').AsString ,'0',6));
                end;

              item.cod     := query2.fieldbyname('cod').AsInteger;
              item.nome    := trim(query2.fieldbyname('nome').AsString);
              item.unid    := IfThen(Trim(query2.fieldbyname('unid').AsString) = '', 'UN', query2.fieldbyname('unid').AsString);
              item.quant   := query1.fieldbyname('quant').AsCurrency;
              item.p_venda := query1.fieldbyname('p_venda').AsCurrency;
              item.total   := query1.fieldbyname('total').AsCurrency;

              totalNota := totalNota + query1.fieldbyname('total').AsCurrency;

              item.PercICMS           := 0;
              item.VlrICMS            := 0;
              item.DescICMS           := 0;
              item.Aliq               := query2.fieldbyname('aliquota').AsString;
              item.Reducao            := 0;
              item.CodAliq            := StrToIntdef(query1.fieldbyname('aliquota').AsString, 0);
              item.Total_Preco_Compra := Arredonda(query1.fieldbyname('p_compra').AsCurrency * query1.fieldbyname('quant').AsCurrency,2);
              item.Pis                := query2.fieldbyname('is_pis').AsString;
              item.Desconto           := 0;

              item.Ncm := verNCM(item.cod);//IfThen((ConfParamGerais.Strings[26] = 'S') AND (StrToIntDef(dm.IBselect.fieldbyname('classif').AsString, 0) <> 0), StrToIntDef(dm.IBselect.fieldbyname('classif').AsString, 0), 98);

              item.p_compra := query1.fieldbyname('P_compra').AsCurrency;
              item.Vlr_Frete := 0;
              aliq := query1.fieldbyname('aliquota').AsString;

              query2.Close;
              query2.SQL.Clear;
              query2.SQL.Add('select * from aliq where cod = :cod');
              query2.ParamByName('cod').Asinteger := strtointdef(aliq, 0);
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


              item.PercICMS := temp1;
              item.DescICMS := temp;

              lista.Add(item);
          end;
          query1.Next;
       end;
       end;//fim isempity
//     end;
   query2.Close;
   query1.Close;

   //rateio desconto
   if totDesc > 0 then
     begin
       desc := totDesc;
       fim := lista.Count - 1;
       for i := 0 to fim do
         begin
           item := lista.Items[i];
           if i = fim then
             begin
               item.Desconto := desc;
             end
           else
             begin
               temp := (item.total /totalNota) * totDesc;
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
          BASE_ICM := TOT - ARREDONDA(TOT * (item.Reducao / 100), 2);
          VLR_ICM := ARREDONDA(BASE_ICM * (item.PercICMS / 100), 2);
        end
      else
        begin
          BASE_ICM := TOT;
          VLR_ICM := ARREDONDA(TOT * item.PercICMS / 100, 2);
        end;

      if item.CodAliq > 9 then
        begin
          BASE_ICM := 0;
          VLR_ICM := 0;
        end;
     // item.PercICMS := BASE_ICM;
      item.VlrICMS := VLR_ICM;
    end;

end;

procedure LoadXML(MyMemo: TMemo; MyWebBrowser: TWebBrowser);
begin
 MyMemo.Lines.SaveToFile(ExtractFileDir(application.ExeName)+'temp.xml');
 MyWebBrowser.Navigate(ExtractFileDir(application.ExeName)+'temp.xml');
end;

procedure Verifica_Status_NFe;
var
 MemoResp: TMemo;
 MemWeb  : TWebBrowser;
begin
 try
  MemoResp := TMemo.Create(nil);
  MemWeb   := TWebBrowser.Create(nil);
    ACBrNFe.Configuracoes.WebServices.Visualizar := true;
    ACBrNFe.WebServices.StatusServico.Executar;
    ACBrNFe.Configuracoes.WebServices.Visualizar := False;
 finally
  FreeAndNil(MemoResp);
 end;
end;


procedure GravarConfiguracao(certificadoCaminho, certificadoSenha, certificadoNumeroSerie:String;  FinalidadeNFE,  DANFETipo, DANFEFormaEmissao:integer; DANFELogomarca:String;
                             ArqLog:Boolean; CaminhoLog, WebUF:String;  WebAmbiente:integer; WebVisualiza:Boolean; ProxHost, ProxPorta, ProxUser, ProxSenha, EmailHost, EmailPorta, EmailUsuario, EmailSenha,
                             EmailAssunto:String; EmailSSL:Boolean; ArquivosPDF:String; ArquivosNFE:String; CDCFOP:String; idToken, Token:String; idxImpre, tipoImpre : integer; preview : boolean;
                             const portaBalanca, veloBal, tipoBal : string);
var
 IniFile    : String ;
 Ini        : TIniFile ;
 mmEmailMsg : TMemo;
 StreamMemo : TMemoryStream;
begin
 try
  IniFile    := ChangeFileExt(Application.ExeName, '.ini') ;
  Ini        := TIniFile.Create( IniFile );
  mmEmailMsg := TMemo.Create(nil);

  Ini.WriteString('BALANCA', 'PORTA'  ,portaBalanca) ;
  Ini.WriteString('BALANCA', 'VELO'   ,veloBal) ;
  Ini.WriteString('BALANCA', 'BALANCA',tipoBal) ;

  Ini.WriteString('Certificado','Caminho' ,certificadoCaminho) ;
  Ini.WriteString('Certificado','Senha'   ,certificadoSenha) ;
  Ini.WriteString('Certificado','NumSerie',certificadoNumeroSerie) ;
  //
  Ini.WriteInteger('Geral','Finalidade'   ,FinalidadeNFE) ;

  Ini.WriteInteger('Geral','DANFE'        ,DANFETipo) ;
  Ini.WriteInteger('Geral','FormaEmissao' ,DANFEFormaEmissao) ;
  Ini.WriteString('Geral','LogoMarca'     ,DANFELogomarca) ;
  Ini.WriteBool('Geral', 'Salvar'          ,ArqLog) ;

  Ini.WriteInteger('Geral','TipoImpressao'     ,tipoImpre) ;
  Ini.WriteInteger('Geral','idxImpressora'     , idxImpre) ;
  Ini.WriteBool(   'Geral', 'preview'          ,preview) ;

  Ini.WriteString('Geral','PathSalvar'    ,CaminhoLog) ;
  Ini.WriteString('Geral','CFOP'          ,CDCFOP) ;

  Ini.WriteString('Geral','ArquivosPDF'    ,ArquivosPDF) ;
  Ini.WriteString('Geral','ArquivosNFE'    ,ArquivosNFE) ;

  Ini.WriteString('Geral','IDToken'  ,idToken) ;
  Ini.WriteString('Geral','Token'    ,Token) ;


  Ini.WriteString('Certificado','ArquivosPDF',ArquivosPDF) ;
  Ini.WriteString('Certificado','ArquivosNFe',ArquivosNFE) ;
  //
  Ini.WriteString('WebService','UF'        ,WebUF) ;
  Ini.WriteInteger('WebService','Ambiente' ,WebAmbiente) ;
  Ini.WriteBool('WebService','Visualizar'  ,WebVisualiza) ;
  //
  Ini.WriteString( 'Proxy','Host'   ,ProxHost) ;
  Ini.WriteString( 'Proxy','Porta'  ,ProxPorta) ;
  Ini.WriteString( 'Proxy','User'   ,ProxUser) ;
  Ini.WriteString( 'Proxy','Pass'   ,ProxSenha) ;
  //
  Ini.WriteString( 'Email','Host'    ,EmailHost) ;
  Ini.WriteString( 'Email','Port'    ,EmailPorta) ;
  Ini.WriteString( 'Email','User'    ,EmailUsuario) ;
  Ini.WriteString( 'Email','Pass'    ,EmailSenha) ;
  Ini.WriteString( 'Email','Assunto' ,EmailAssunto) ;
  Ini.WriteBool(   'Email','SSL'     ,EmailSSL) ;

  StreamMemo := TMemoryStream.Create;
  mmEmailMsg.Lines.SaveToStream(StreamMemo);
  StreamMemo.Seek(0,soFromBeginning);
  Ini.WriteBinaryStream( 'Email','Mensagem',StreamMemo) ;
  StreamMemo.Free;
  finally
   Ini.Free;
   FreeAndNil(mmEmailMsg);
  end;
end;

function LerConfiguracaoCFOP():String;
var
 Ini     : TIniFile;
 IniFile : String;
begin
 Result := '';
 try
  IniFile    := ChangeFileExt( Application.ExeName, '.ini') ;
  Ini        := TIniFile.Create(IniFile);
  Result     := Ini.ReadString( 'Geral','CFOP' ,'') ;
 finally
  Ini.Free;
 end;
end;

procedure LerConfiguracaoNFCe();
var
 certificadoCaminho     : String;
 certificadoSenha       : String;
 certificadoNumeroSerie : String;
 Finalidade             : integer;
 DANFETipo              : integer;
 DANFEFormaEmissao      : integer;
 DANFELogomarca         : String;
 ArqLog                 : Boolean;
 CaminhoLog             : String;
 WebUF                  : String;
 WebAmbiente            : integer;
 WebVisualiza           : Boolean;
 ProxHost               : String;
 ProxPorta              : String;
 ProxUser               : String;
 ProxSenha              : String;
 EmailHost              : String;
 EmailPorta             : String;
 EmailUsuario           : String;
 EmailSenha             : String;
 EmailAssunto           : String;
 EmailSSL               : Boolean;
 IniFile                : String;
 Ini                    : TIniFile;
 Ok , preview           : Boolean;
 StreamMemo             : TMemoryStream;
 mmEmailMsg             : TMemo;
 TipoAmbiente,
 FinalidadeNFe,
 UFComerciante,
 CDCFOP,
 TipoEmissao,
 ArquivoPDF,
 ArquivoNFE,
 SenhaCertificado       : string;
begin
 if not FileExists(copy(ParamStr(0), 1, length(ParamStr(0)) - 3) + 'ini') then
   begin
     exit;
   end;
 {IniFile    := ChangeFileExt( Application.ExeName, '.ini') ;
 Ini        := TIniFile.Create(IniFile);
 mmEmailMsg := TMemo.Create(nil);
 try
  {
   certificadoCaminho                                      := Ini.ReadString( 'Certificado','Caminho' ,'') ;
   certificadoSenha                                        := Ini.ReadString( 'Certificado','Senha'   ,'') ;
   dtmMain.ACBrNFe.Configuracoes.Certificados.Certificado  := certificadoCaminho;
   dtmMain.ACBrNFe.Configuracoes.Certificados.Senha        := certificadoSenha;
   //
   certificadoNumeroSerie                                  := Ini.ReadString( 'Certificado','NumSerie','') ;
   dtmMain.ACBrNFe.Configuracoes.Certificados.NumeroSerie  := certificadoNumeroSerie;
   certificadoNumeroSerie                                  := dtmMain.ACBrNFe.Configuracoes.Certificados.NumeroSerie;


   SenhaCertificado                                        := Ini.ReadString( 'Certificado','Senha'  ,'') ;
   certificadoNumeroSerie                                  := Ini.ReadString( 'Certificado','NumSerie','') ;
   ACBrNFe.Configuracoes.Certificados.NumeroSerie  := certificadoNumeroSerie;
   certificadoNumeroSerie                                  := ACBrNFe.Configuracoes.Certificados.NumeroSerie;

   DANFEFormaEmissao                                    := Ini.ReadInteger( 'Geral','FormaEmissao',0) ;
   TipoEmissao                                          := IntToStr(DANFEFormaEmissao);
   ArqLog                                               := Ini.ReadBool(   'Geral','Salvar'      ,True) ;


   ArquivoPDF                                           := Ini.ReadString( 'Geral','ArquivosPDF'  ,'') ;
   ArquivoNFE                                           := Ini.ReadString( 'Geral','ArquivosNFE'  ,'') ;
   CDCFOP                                               := Ini.ReadString( 'Geral','CFOP' ,'') ;


   CaminhoLog                                           := Ini.ReadString( 'Geral','PathSalvar'  ,'') ;
   pastaControlW := ExtractFileDir(ParamStr(0)) + '\';

   criaPasta(pastaControlW + 'NFCe\');
   criaPasta(pastaControlW + 'NFCe\EMIT\');
   criaPasta(pastaControlW + 'NFCe\CANC\');
   criaPasta(pastaControlW + 'NFCe\RESP\');
   criaPasta(pastaControlW + 'NFCe\PDF\');
   DANFE.PathPDF                                        := pastaControlW + 'NFCe\PDF\';




   ACBrNFe.Configuracoes.Geral.FormaEmissao     := StrToTpEmis(OK,IntToStr(DANFEFormaEmissao+1));
   ACBrNFe.Configuracoes.Geral.Salvar           := true;
   ACBrNFe.Configuracoes.Geral.PathSalvar       := pastaControlW + 'NFCe\EMIT\';
   ACBrNFe.Configuracoes.Arquivos.PathNFe       := pastaControlW + 'NFCe\EMIT\';
   ACBrNFe.Configuracoes.Arquivos.PathDPEC      := pastaControlW + 'NFCe\RESP\';
   ACBrNFe.Configuracoes.Arquivos.Salvar := false;
   ACBrNFe.Configuracoes.Arquivos.PastaMensal := true;
   ACBrNFe.Configuracoes.Arquivos.AdicionarLiteral := true;
   ACBrNFe.Configuracoes.Arquivos.EmissaoPathNFe := true;
   ACBrNFe.Configuracoes.Geral.PathSchemas := pastaControlW + 'Schemas';
   ACBrNFe.Configuracoes.WebServices.Salvar := true;
   //
   WebUF                                                := Ini.ReadString( 'WebService','UF','MG') ;
   WebAmbiente                                          := Ini.ReadInteger( 'WebService','Ambiente'  ,1) ;

   UFComerciante                                        := WebUF;
   FinalidadeNFe                                        := '0';
   TipoAmbiente                                         := IntToStr(WebAmbiente);
   WebVisualiza                                         :=Ini.ReadBool(    'WebService','Visualizar',False) ;
   ACBrNFe.Configuracoes.WebServices.UF         := WebUF;
   ACBrNFe.Configuracoes.WebServices.Ambiente   := StrToTpAmb(Ok,IntToStr(WebAmbiente));
   ACBrNFe.Configuracoes.WebServices.Visualizar := WebVisualiza;
   gTipoEmissao    := TipoEmissao;
   gTipoAmbiente   := TipoAmbiente;
   gUFComerciante  := UFComerciante;
   gFinalidadeNFe  := FinalidadeNFe;

   //
   ProxHost  := Ini.ReadString( 'Proxy','Host'   ,'') ;
   ProxPorta := Ini.ReadString( 'Proxy','Porta'  ,'') ;
   ProxUser  := Ini.ReadString( 'Proxy','User'   ,'') ;
   ProxSenha := Ini.ReadString( 'Proxy','Pass'   ,'') ;
   //
   gProxHost  := Ini.ReadString( 'Proxy','Host'   ,'') ;
   gProxPorta := Ini.ReadString( 'Proxy','Porta'  ,'') ;
   gProxUser  := Ini.ReadString( 'Proxy','User'   ,'') ;
   gProxSenha := Ini.ReadString( 'Proxy','Pass'   ,'') ;

   indxImpressora := Ini.ReadInteger( 'Geral','idxImpressora'   , 0) ;
   tipoIMPRESSAO  := Ini.ReadInteger( 'Geral','tipoImpre'   , 0) ;
   preview        := ini.ReadBool('Geral', 'preview', false);

   //setPrinter(indxImpressora);
   //seta a impressora padrao de nfe
   //
   ACBrNFe.Configuracoes.WebServices.ProxyHost := ProxHost;
   ACBrNFe.Configuracoes.WebServices.ProxyPort := ProxPorta;
   ACBrNFe.Configuracoes.WebServices.ProxyUser := ProxUser;
   ACBrNFe.Configuracoes.WebServices.ProxyPass := ProxSenha;
   //
   ACBrNFe.Configuracoes.Arquivos.PathNFe  := ExtractFilePath(Application.ExeName);
   ACBrNFe.Configuracoes.Arquivos.PathCan  := ExtractFilePath(Application.ExeName);
   ACBrNFe.Configuracoes.Arquivos.PathInu  := ExtractFilePath(Application.ExeName);
   ACBrNFe.Configuracoes.Arquivos.PathDPEC := ExtractFilePath(Application.ExeName);
   ACBrNFe.Configuracoes.Geral.PathSalvar  := ExtractFilePath(Application.ExeName);
}
   //
{   DANFETipo      := Ini.ReadInteger( 'Geral','DANFE'       ,0) ;
   DANFELogomarca := Ini.ReadString( 'Geral','LogoMarca'   ,'') ;
   //
   if ACBrNFe.DANFE <> nil then
    begin
     ACBrNFe.DANFE.TipoDANFE  := StrToTpImp(OK,IntToStr(DANFETipo+1));
     ACBrNFe.DANFE.Logo       := DANFELogomarca;
    end;
    //
    EmailHost    := Ini.ReadString( 'Email','Host'   ,'') ;
    EmailPorta   := Ini.ReadString('Email','Port'    ,'') ;
    EmailUsuario := Ini.ReadString('Email','User'    ,'') ;
    EmailSenha   := Ini.ReadString('Email','Pass'    ,'') ;
    EmailAssunto := Ini.ReadString('Email','Assunto' ,'') ;
    EmailSSL     := Ini.ReadBool  ('Email','SSL'     ,False) ;
    StreamMemo   := TMemoryStream.Create;
    Ini.ReadBinaryStream( 'Email','Mensagem',StreamMemo) ;
    mmEmailMsg.Lines.LoadFromStream(StreamMemo);
    StreamMemo.Free;

    //if tipoImp = 0 then ACBrNFe.DANFE.TipoDANFE :=

    ACBrNFe.Configuracoes.Geral.AtualizarXMLCancelado := true;
    ACBrNFe.DANFE.MostrarPreview := not preview;
    ACBrNFe.Configuracoes.Geral.ModeloDF := moNFCe;
    ACBrNFe.Configuracoes.Geral.VersaoDF := ve310;
  finally
   Ini.Free;

  } lerConfigBalanca();

//   FreeAndNil(mmEmailMsg);
//  end;
end;

procedure LerConfiguracaoNFe();
var
 certificadoCaminho     : String;
 certificadoSenha       : String;
 certificadoNumeroSerie : String;
 Finalidade             : integer;
 DANFETipo              : integer;
 DANFEFormaEmissao      : integer;
 DANFELogomarca         : String;
 ArqLog                 : Boolean;
 CaminhoLog             : String;
 WebUF                  : String;
 WebAmbiente            : integer;
 WebVisualiza           : Boolean;
 ProxHost               : String;
 ProxPorta              : String;
 ProxUser               : String;
 ProxSenha              : String;
 EmailHost              : String;
 EmailPorta             : String;
 EmailUsuario           : String;
 EmailSenha             : String;
 EmailAssunto           : String;
 EmailSSL               : Boolean;
 IniFile                : String;
 Ini                    : TIniFile;
 Ok , preview           : Boolean;
 StreamMemo             : TMemoryStream;
 mmEmailMsg             : TMemo;
 TipoAmbiente,
 FinalidadeNFe,
 UFComerciante,
 CDCFOP,
 TipoEmissao,
 ArquivoPDF,
 ArquivoNFE,
 SenhaCertificado       : string;
begin
 ACBrNFe.DANFE := DANFE_Rave;
 DANFE_Rave.NFeCancelada := false;

 if not FileExists(copy(ParamStr(0), 1, length(ParamStr(0)) - 3) + 'ini') then
   begin
     exit;
   end;
 IniFile    := ChangeFileExt( Application.ExeName, '.ini') ;
 Ini        := TIniFile.Create(IniFile);
 mmEmailMsg := TMemo.Create(nil);
 try
  {$IFDEF ACBrNFeOpenSSL}
   certificadoCaminho                                      := Ini.ReadString( 'Certificado','Caminho' ,'') ;
   certificadoSenha                                        := Ini.ReadString( 'Certificado','Senha'   ,'') ;
   dtmMain.ACBrNFe.Configuracoes.Certificados.Certificado  := certificadoCaminho;
   dtmMain.ACBrNFe.Configuracoes.Certificados.Senha        := certificadoSenha;
   //
   certificadoNumeroSerie                                  := Ini.ReadString( 'Certificado','NumSerie','') ;
   dtmMain.ACBrNFe.Configuracoes.Certificados.NumeroSerie  := certificadoNumeroSerie;
   certificadoNumeroSerie                                  := dtmMain.ACBrNFe.Configuracoes.Certificados.NumeroSerie;

  {$ELSE}
   SenhaCertificado                                        := Ini.ReadString( 'Certificado','Senha'  ,'') ;
   certificadoNumeroSerie                                  := Ini.ReadString( 'Certificado','NumSerie','') ;
   ACBrNFe.Configuracoes.Certificados.NumeroSerie  := certificadoNumeroSerie;
   certificadoNumeroSerie                                  := ACBrNFe.Configuracoes.Certificados.NumeroSerie;
  {$ENDIF}
   DANFEFormaEmissao                                    := Ini.ReadInteger( 'Geral','FormaEmissao',0) ;
   TipoEmissao                                          := IntToStr(DANFEFormaEmissao);
   ArqLog                                               := Ini.ReadBool(   'Geral','Salvar'      ,True) ;


   ArquivoPDF                                           := Ini.ReadString( 'Geral','ArquivosPDF'  ,'') ;
   ArquivoNFE                                           := Ini.ReadString( 'Geral','ArquivosNFE'  ,'') ;
   CDCFOP                                               := Ini.ReadString( 'Geral','CFOP' ,'') ;


   CaminhoLog                                           := Ini.ReadString( 'Geral','PathSalvar'  ,'') ;
   pastaControlW := ExtractFileDir(ParamStr(0)) + '\';

   criaPasta(pastaControlW + 'NFe\');
   criaPasta(pastaControlW + 'NFe\EMIT\');
   criaPasta(pastaControlW + 'NFe\CANC\');
   criaPasta(pastaControlW + 'NFe\RESP\');
   criaPasta(pastaControlW + 'NFe\PDF\');
   DANFE.PathPDF                                        := pastaControlW + 'NFe\PDF\';

   ACBrNFe.Configuracoes.Geral.FormaEmissao     := StrToTpEmis(OK,IntToStr(DANFEFormaEmissao+1));
   ACBrNFe.Configuracoes.Geral.Salvar           := false;
   ACBrNFe.Configuracoes.Geral.PathSalvar       := pastaControlW + 'NFe\EMIT\';
   ACBrNFe.Configuracoes.Arquivos.PathNFe       := pastaControlW + 'NFe\EMIT\';
   ACBrNFe.Configuracoes.Arquivos.PathCan       := pastaControlW + 'NFe\CANC\';
   ACBrNFe.Configuracoes.Arquivos.PathDPEC      := pastaControlW + 'NFe\RESP\';
   ACBrNFe.Configuracoes.Arquivos.Salvar := false;
   ACBrNFe.Configuracoes.Arquivos.PastaMensal := true;
   ACBrNFe.Configuracoes.Arquivos.AdicionarLiteral := true;
   ACBrNFe.Configuracoes.Arquivos.EmissaoPathNFe := true;
   ACBrNFe.Configuracoes.Geral.PathSchemas := pastaControlW + 'Schemas';
   ACBrNFe.Configuracoes.WebServices.Salvar := true;
   //
   WebUF                                                := Ini.ReadString( 'WebService','UF','RR') ;
   WebAmbiente                                          := Ini.ReadInteger( 'WebService','Ambiente'  ,1) ;

   UFComerciante                                        := WebUF;
   FinalidadeNFe                                        := '0';
   TipoAmbiente                                         := IntToStr(WebAmbiente);
   WebVisualiza                                         :=Ini.ReadBool(    'WebService','Visualizar',False) ;
   ACBrNFe.Configuracoes.WebServices.UF         := WebUF;
   ACBrNFe.Configuracoes.WebServices.Ambiente   := StrToTpAmb(Ok,IntToStr(WebAmbiente));
   ACBrNFe.Configuracoes.WebServices.Visualizar := WebVisualiza;
   gTipoEmissao    := TipoEmissao;
   gTipoAmbiente   := TipoAmbiente;
   gUFComerciante  := UFComerciante;
   gFinalidadeNFe  := FinalidadeNFe;

   //
   ProxHost  := Ini.ReadString( 'Proxy','Host'   ,'') ;
   ProxPorta := Ini.ReadString( 'Proxy','Porta'  ,'') ;
   ProxUser  := Ini.ReadString( 'Proxy','User'   ,'') ;
   ProxSenha := Ini.ReadString( 'Proxy','Pass'   ,'') ;
   //
   gProxHost  := Ini.ReadString( 'Proxy','Host'   ,'') ;
   gProxPorta := Ini.ReadString( 'Proxy','Porta'  ,'') ;
   gProxUser  := Ini.ReadString( 'Proxy','User'   ,'') ;
   gProxSenha := Ini.ReadString( 'Proxy','Pass'   ,'') ;

   indxImpressora := Ini.ReadInteger( 'Geral','idxImpressora'   , 0) ;
   tipoIMPRESSAO  := Ini.ReadInteger( 'Geral','tipoImpre'   , 0) ;
   preview        := ini.ReadBool('Geral', 'preview', false);

   //setPrinter(indxImpressora);
   //seta a impressora padrao de nfe
   //
   ACBrNFe.Configuracoes.WebServices.ProxyHost := ProxHost;
   ACBrNFe.Configuracoes.WebServices.ProxyPort := ProxPorta;
   ACBrNFe.Configuracoes.WebServices.ProxyUser := ProxUser;
   ACBrNFe.Configuracoes.WebServices.ProxyPass := ProxSenha;
   //
{   ACBrNFe.Configuracoes.Arquivos.PathNFe  := ExtractFilePath(Application.ExeName);
   ACBrNFe.Configuracoes.Arquivos.PathCan  := ExtractFilePath(Application.ExeName);
   ACBrNFe.Configuracoes.Arquivos.PathInu  := ExtractFilePath(Application.ExeName);
   ACBrNFe.Configuracoes.Arquivos.PathDPEC := ExtractFilePath(Application.ExeName);
   ACBrNFe.Configuracoes.Geral.PathSalvar  := ExtractFilePath(Application.ExeName);
}
   //
   DANFETipo      := Ini.ReadInteger( 'Geral','DANFE'       ,0) ;
   DANFELogomarca := Ini.ReadString( 'Geral','LogoMarca'   ,'') ;
   //
   if ACBrNFe.DANFE <> nil then
    begin
     ACBrNFe.DANFE.TipoDANFE  := tiRetrato;
     ACBrNFe.DANFE.Logo       := DANFELogomarca;
    end;
    //
    EmailHost    := Ini.ReadString( 'Email','Host'   ,'') ;
    EmailPorta   := Ini.ReadString('Email','Port'    ,'') ;
    EmailUsuario := Ini.ReadString('Email','User'    ,'') ;
    EmailSenha   := Ini.ReadString('Email','Pass'    ,'') ;
    EmailAssunto := Ini.ReadString('Email','Assunto' ,'') ;
    EmailSSL     := Ini.ReadBool  ('Email','SSL'     ,False) ;
    StreamMemo   := TMemoryStream.Create;
    Ini.ReadBinaryStream( 'Email','Mensagem',StreamMemo) ;
    mmEmailMsg.Lines.LoadFromStream(StreamMemo);
    StreamMemo.Free;

    ACBrNFe.Configuracoes.Geral.AtualizarXMLCancelado := true;
    ACBrNFe.Configuracoes.Geral.VersaoDF := ve200;
    ACBrNFe.DANFE := DANFE_Rave;
    ACBrNFe.DANFE.MostrarPreview := not preview;
    ACBrNFe.Configuracoes.Geral.ModeloDF := moNFe;
  finally
   Ini.Free;
   FreeAndNil(mmEmailMsg);
  end;
end;

procedure CarregarConfiguracao();
var
 IniFile               : String;
 Ini                   : TIniFile;
 Ok                    : Boolean;
 StreamMemo            : TMemoryStream;
 mmEmailMsg            : TMemo;
 //
 certificadoCaminho,
 certificadoSenha,
 certificadoNumeroSerie : String;
 Finalidade: integer;
 DANFETipo: integer;
 DANFEFormaEmissao: integer;
 DANFELogomarca: String;
 ArqLog: Boolean;
 CaminhoLog: String;
 WebUF: String;
 WebAmbiente: integer;
 WebVisualiza: Boolean;
 ProxHost: String;
 ProxPorta: String;
 ProxUser: String;
 ProxSenha: String;
 EmailHost: String;
 EmailPorta: String;
 EmailUsuario: String;
 EmailSenha: String;
 EmailAssunto: String;
 EmailSSL:Boolean;
begin
 IniFile    := ChangeFileExt( Application.ExeName, '.ini') ;
 Ini        := TIniFile.Create(IniFile);
 mmEmailMsg := TMemo.Create(nil);
 try
  {$IFDEF ACBrNFeOpenSSL}
   certificadoCaminho                                      := Ini.ReadString( 'Certificado','Caminho' ,'') ;
   certificadoSenha                                        := Ini.ReadString( 'Certificado','Senha'   ,'') ;
   ACBrNFe.Configuracoes.Certificados.Certificado  := certificadoCaminho;
   ACBrNFe.Configuracoes.Certificados.Senha        := certificadoSenha;
  {$ELSE}
   certificadoNumeroSerie                                  := Ini.ReadString( 'Certificado','NumSerie','') ;
   ACBrNFe.Configuracoes.Certificados.NumeroSerie  := certificadoNumeroSerie;
   certificadoNumeroSerie                                  := ACBrNFe.Configuracoes.Certificados.NumeroSerie;
  {$ENDIF}
   ACBrNFe.Configuracoes.Geral.Token            := Ini.ReadString('Geral','Token', '');
   ACBrNFe.Configuracoes.Geral.IdToken          := Ini.ReadString('Geral','IDToken', '');

   DANFEFormaEmissao                                    := Ini.ReadInteger( 'Geral','FormaEmissao',0) ;
   ArqLog                                               := Ini.ReadBool(   'Geral','Salvar'      ,True) ;
   CaminhoLog                                           := Ini.ReadString( 'Geral','PathSalvar'  ,'') ;
   ACBrNFe.Configuracoes.Geral.FormaEmissao     := StrToTpEmis(OK,IntToStr(DANFEFormaEmissao+1));
   ACBrNFe.Configuracoes.Geral.Salvar           := ArqLog;
   ACBrNFe.Configuracoes.Geral.PathSalvar       := CaminhoLog;
   //
   WebUF                                                := Ini.ReadString( 'WebService','UF','MG') ;
   WebAmbiente                                          := Ini.ReadInteger( 'WebService','Ambiente'  ,0) ;

   pgerais.Values['tpamb'] := IntToStr(WebAmbiente);

   WebVisualiza                                         :=Ini.ReadBool(    'WebService','Visualizar',False) ;
   ACBrNFe.Configuracoes.WebServices.UF         := WebUF;
   ACBrNFe.Configuracoes.WebServices.Ambiente   := StrToTpAmb(Ok,IntToStr(WebAmbiente));
   ACBrNFe.Configuracoes.WebServices.Visualizar := WebVisualiza;

   //
   ProxHost  := Ini.ReadString( 'Proxy','Host'   ,'') ;
   ProxPorta := Ini.ReadString( 'Proxy','Porta'  ,'') ;
   ProxUser  := Ini.ReadString( 'Proxy','User'   ,'') ;
   ProxSenha := Ini.ReadString( 'Proxy','Pass'   ,'') ;
   //
   ACBrNFe.Configuracoes.WebServices.ProxyHost := ProxHost;
   ACBrNFe.Configuracoes.WebServices.ProxyPort := ProxPorta;
   ACBrNFe.Configuracoes.WebServices.ProxyUser := ProxUser;
   ACBrNFe.Configuracoes.WebServices.ProxyPass := ProxSenha;
   //
   DANFETipo      := Ini.ReadInteger( 'Geral','DANFE'       ,0) ;
   DANFELogomarca := Ini.ReadString( 'Geral','LogoMarca'   ,'') ;
   if ACBrNFe.DANFE <> nil then
    begin
     ACBrNFe.DANFE.TipoDANFE  := StrToTpImp(OK,IntToStr(DANFETipo+1));
     ACBrNFe.DANFE.Logo       := DANFELogomarca;
    end;
    //
    EmailHost    := Ini.ReadString( 'Email','Host'   ,'') ;
    EmailPorta   := Ini.ReadString( 'Email','Port'   ,'') ;
    EmailUsuario := Ini.ReadString( 'Email','User'   ,'') ;
    EmailSenha   := Ini.ReadString( 'Email','Pass'   ,'') ;
    EmailAssunto := Ini.ReadString( 'Email','Assunto','') ;
    EmailSSL     := Ini.ReadBool(   'Email','SSL'    ,False) ;
    StreamMemo   := TMemoryStream.Create;
    Ini.ReadBinaryStream( 'Email','Mensagem',StreamMemo) ;
    mmEmailMsg.Lines.LoadFromStream(StreamMemo);
    StreamMemo.Free;
  finally
   Ini.Free;
   FreeAndNil(mmEmailMsg);
  end;
end;

function EnviarCupomEletronico(nota : String;var Status:String; vAux, vNumLote : String;var MemoResp:TMemo; WBResposta:TWebBrowser;
                               TipoEmissao,TipoAmbiente,UFComerciante, FinalidadeNFe:String):Boolean;
var
 sql,
 qUsuario,
 para,
 ssChave,
 NumeroRecibo : string;
 Mensagememail: TStrings;
begin
 Status  := '';
 Result  := false;
 ssChave := '';
 inicializaVariaveis();
 try
  Mensagememail := TStringList.Create;
  vAux := nota;
    ACBrNFe.NotasFiscais.Clear;
    /////GERAR NFC-e:
    GerarNFCe(nota, vAux, gTipoEmissao,gTipoAmbiente,gUFComerciante, gFinalidadeNFe);

   try
    ACBrNFe.NotasFiscais.Valida;
    ACBrNFe.NotasFiscais.Assinar;
   except
     on e:exception do
       begin
         MessageDlg('Falha na Validação da Nota: ' + #13 + e.Message + #13, mtError, [mbOK], 1);
         Result := false;
         exit;
       end;
   end;

   try
    ACBrNFe.WebServices.Enviar.Lote := '0';
    ACBrNFe.WebServices.Enviar.Executar;
   except
     On e:Exception do
      begin
        Status := 'OFF';
        MessageDlg('Ocorreu um Erro: ' + #13 + e.Message + #13, mtError, [mbOK], 1);
        Result := false;
        exit;
      end;
    end;
   NumeroRecibo := ACBrNFe.WebServices.Enviar.Recibo;

    MemoResp.Clear;
    MemoResp.Lines.Text := UTF8Encode(ACBrNFe.WebServices.Retorno.RetWS);

    LoadXML(MemoResp, WBResposta);
    ACBrNFe.WebServices.Retorno.Recibo := NumeroRecibo;//qry.FieldByName('RECIBO_NUMERO').AsString;
    ACBrNFe.WebServices.Retorno.Executar;
    ssChave                                            := ACBrNFe.WebServices.Retorno.ChaveNFe;
  if ACBrNFe.WebServices.Retorno.cStat = 100 then
     begin
       Result := true;
       Status := 'OK';
       Incrementa_Generator('NFCE', 1);
       venda.chave := ssChave;
       if ssChave <> '' then insereNotaBD(venda);
     end;

    if ACBrNFe.WebServices.Retorno.cStat > 200 Then
     begin
      ShowMessage('NF-e '+ ' Houve uma falha na Validação!'+#13+#10+#13+#10+
                  'Favor Corrigir: ' + ACBrNFe.WebServices.Retorno.xMotivo);//+qry.FieldByName('RECIBO_DESCSTATUS').AsString);
      Result := false;
      exit;
     end;
     MemoResp.Lines.Text := UTF8Encode(ACBrNFe.WebServices.Retorno.RetWS);
     LoadXML(MemoResp, WBResposta);

     try
      imprimirNfce();
     except
      On Exception do
       begin
        MessageDlg('Verifique se o Acrobat está instalado corretamente.', mtInformation, [mbok],0 );
       end;
     end;
     para := 'wagner.br.xx@gmail.com';

     if ssChave <> '' then  ACBrNFe.NotasFiscais.LoadFromFile(ACBrNFe.Configuracoes.Arquivos.PathNFe + ssChave+'-nfe.xml');
     // envia nf-e por e-mail
     //ShowMessage('NF-e '+qry.FieldByName('NUVENDACFE').AsString+ ' Transmitida com Sucesso!'+#13+#10+#13+#10+
     ShowMessage('NF-e '+ IntToStr(codNF) + ' Transmitida com Sucesso!'+#13+#10+#13+#10+
                 'CHAVE DE ACESSO: '+ssChave+#13+#10+
         //       'Data/Hora da Autorização: ' +qry.FieldByName('DATA_AUTORIZACAO_TEXTO').AsString+#13+#10+#13+#10+
                  'Data/Hora da Autorização: '+ FormatDateTime('', now) +#13+#10+#13+#10+
                 'DANFE impresso com Sucesso!');
     Result := true;
 finally
  FreeAndNil(Mensagememail);
 end;
end;


function EnviarCupomEletronico(nota : String; var Status, xmotivo : string;const tipo : integer;const enviar : boolean; const cliente1 : String):Boolean;
var
 sql,
 qUsuario,
 para,
 ssChave,
 NumeroRecibo : string;
 Mensagememail: TStrings;
begin
 Status  := '';
 Result  := false;
 ssChave := '';
 inicializaVariaveis();
 tipoEmissao := tipo;

 cliente := cliente1;
 try
  Mensagememail := TStringList.Create;
  ACBrNFe.NotasFiscais.Clear;

  if enviar then contOFFLINE := false
    else
      begin
        contOFFLINE := true;
        ACBrNFe.Configuracoes.Geral.FormaEmissao := teOffLine;
        //contigência OFFLINE
      end;
  /////GERAR NFC-e:
  GerarNFCe(nota, cliente, '', '', '', '');

   if enviar then
     begin
       try
         ACBrNFe.NotasFiscais.Valida;
         ACBrNFe.NotasFiscais.Assinar;
       except
         on e:exception do
           begin
             Status := 'vali';
             MessageDlg('Falha na Validação da Nota: ' + #13 + e.Message + #13, mtError, [mbOK], 1);
             Result := false;
             exit;
           end;
       end;

       try
         ACBrNFe.WebServices.Enviar.Lote := '0';
         ACBrNFe.WebServices.Enviar.Executar;
       except
         On e:Exception do
           begin
             Status := 'OFF';
             MessageDlg('Ocorreu um Erro: ' + #13 + e.Message + #13, mtError, [mbOK], 1);
             Result := false;
             exit;
           end;
       end;

       NumeroRecibo := ACBrNFe.WebServices.Enviar.Recibo;

       ACBrNFe.WebServices.Retorno.Recibo := NumeroRecibo;//qry.FieldByName('RECIBO_NUMERO').AsString;
       ACBrNFe.WebServices.Retorno.Executar;
       ssChave                                            := ACBrNFe.WebServices.Retorno.ChaveNFe;
       if ACBrNFe.WebServices.Retorno.cStat = 100 then
         begin
           Status := 'OK';
           Incrementa_Generator('NFCE', 1);
           venda.chave := ssChave;
           insereNotaBD(venda);
         end;

       if ACBrNFe.WebServices.Retorno.cStat > 200 Then
         begin
           Status  := 'vali';
           xmotivo := ACBrNFe.WebServices.Retorno.xMotivo;
           ShowMessage('NF-e '+ ' Houve uma falha na Validação!'+#13+#10+#13+#10+
                  'Favor Corrigir: ' + ACBrNFe.WebServices.Retorno.xMotivo);//+qry.FieldByName('RECIBO_DESCSTATUS').AsString);
           Result := false;
            exit;
         end;
     end
   else
     begin
       try
         ACBrNFe.NotasFiscais.Valida;
         ACBrNFe.NotasFiscais.Assinar;
       except
         on e:exception do
           begin
             Status := 'vali';
             MessageDlg('Falha na Validação da Nota: ' + #13 + e.Message + #13, mtError, [mbOK], 1);
             Result := false;
             exit;
           end;
       end;

       ssChave := ACBrNFe.NotasFiscais.Items[0].NFe.infNFe.ID;
       ssChave := copy(ssChave, 4, length(ssChave));
       venda.adic := 'OFF';
       Incrementa_Generator('NFCE', 1);
       venda.chave := ssChave;
       insereNotaBD(venda);
     end;

     try
      imprimirNfce();
     except
      On Exception do
       begin
        MessageDlg('Verifique se o Acrobat está instalado corretamente.', mtInformation, [mbok],0 );
       end;
     end;
     para := 'wagner.br.xx@gmail.com';
     ACBrNFe.NotasFiscais.Clear;
    // DeleteFile(ACBrNFe.Configuracoes.Geral.PathSalvar + ssChave + '-nfe.xml');

     //if ssChave <> '' then  ACBrNFe.NotasFiscais.LoadFromFile(ACBrNFe.Configuracoes.Geral.PathSalvar + ssChave + '-nfe.xml');
     // envia nf-e por e-mail
     //ShowMessage('NF-e '+qry.FieldByName('NUVENDACFE').AsString+ ' Transmitida com Sucesso!'+#13+#10+#13+#10+
     {ShowMessage('NF-e '+ IntToStr(codNF) + ' Transmitida com Sucesso!'+#13+#10+#13+#10+
                 'CHAVE DE ACESSO: '+ssChave+#13+#10+
         //       'Data/Hora da Autorização: ' +qry.FieldByName('DATA_AUTORIZACAO_TEXTO').AsString+#13+#10+#13+#10+
                  'Data/Hora da Autorização: '+ FormatDateTime('', now) +#13+#10+#13+#10+
                 'DANFE impresso com Sucesso!');
     }Result := true;
 finally
  FreeAndNil(Mensagememail);
 end;
end;

function EnviarCupomEletronico(nota : String):Boolean;
var
 para,
 ssChave,
 NumeroRecibo : string;
 Mensagememail: TStrings;
begin
 Result  := false;
 ssChave := '';
 inicializaVariaveis();

 query1.Close;
 query1.SQL.Text := 'select chave from nfce where nota = :nota';
 query1.ParamByName('nota').AsString := nota;
 query1.Open;

 if query1.IsEmpty then
    begin
      query1.Close;
      ShowMessage('NFCe não encontrada');
      exit;
    end;

 ssChave := query1.fieldbyname('chave').AsString;

 contOFFLINE := false;
 lerVenda(nota);
 
 try
  Mensagememail := TStringList.Create;
  ACBrNFe.NotasFiscais.Clear;

  /////GERAR NFC-e:

  ACBrNFe.NotasFiscais.LoadFromFile(ACBrNFe.Configuracoes.Geral.PathSalvar+ '\' + ssChave + '-nfe.xml');
  //ACBrNFe.NotasFiscais.Items[0].NFe.Ide.dhCont := now;
  //ACBrNFe.NotasFiscais.Items[0].NFe.Ide.xJust  := 'NOTA FISCAL EMITIDA EM CONTINGENCIA';

  try
    ACBrNFe.WebServices.Enviar.Lote := '0';
    ACBrNFe.WebServices.Enviar.Executar;
  except
    On e:Exception do
      begin
        MessageDlg('Ocorreu um Erro: ' + #13 + e.Message + #13, mtError, [mbOK], 1);
        Result := false;
        exit;
      end;
  end;

  NumeroRecibo := ACBrNFe.WebServices.Enviar.Recibo;

  ACBrNFe.WebServices.Retorno.Recibo := NumeroRecibo;//qry.FieldByName('RECIBO_NUMERO').AsString;
  ACBrNFe.WebServices.Retorno.Executar;
  ssChave                                            := ACBrNFe.WebServices.Retorno.ChaveNFe;
  if ACBrNFe.WebServices.Retorno.cStat = 100 then
    begin
      //Incrementa_Generator('NFCE', 1);
      venda.chave := ssChave;
      insereNotaBD(venda);
    end;

  if ACBrNFe.WebServices.Retorno.cStat > 200 Then
    begin
      ShowMessage('NF-e '+ ' Houve uma falha na Validação!'+#13+#10+#13+#10+
      'Favor Corrigir: ' + ACBrNFe.WebServices.Retorno.xMotivo);//+qry.FieldByName('RECIBO_DESCSTATUS').AsString);
      Result := false;
    exit;
    end;

  try
    imprimirNfce();
  except
    On Exception do
      begin
        MessageDlg('Verifique se o Acrobat está instalado corretamente.', mtInformation, [mbok],0 );
      end;
  end;

  ACBrNFe.NotasFiscais.Clear;
    // DeleteFile(ACBrNFe.Configuracoes.Geral.PathSalvar + ssChave + '-nfe.xml');

     //if ssChave <> '' then  ACBrNFe.NotasFiscais.LoadFromFile(ACBrNFe.Configuracoes.Geral.PathSalvar + ssChave + '-nfe.xml');
     // envia nf-e por e-mail
     //ShowMessage('NF-e '+qry.FieldByName('NUVENDACFE').AsString+ ' Transmitida com Sucesso!'+#13+#10+#13+#10+
     {ShowMessage('NF-e '+ IntToStr(codNF) + ' Transmitida com Sucesso!'+#13+#10+#13+#10+
                 'CHAVE DE ACESSO: '+ssChave+#13+#10+
         //       'Data/Hora da Autorização: ' +qry.FieldByName('DATA_AUTORIZACAO_TEXTO').AsString+#13+#10+#13+#10+
                  'Data/Hora da Autorização: '+ FormatDateTime('', now) +#13+#10+#13+#10+
                 'DANFE impresso com Sucesso!');
     }Result := true;
 finally
  FreeAndNil(Mensagememail);
 end;
end;

procedure ConsultarNFe(numeroNota:String);
begin
 //
 query1.Close;
 query1.SQL.Text := 'select chave from nfce where nota = :nota';
 query1.ParamByName('nota').AsString := numeroNota;
 query1.Open;

 if query1.IsEmpty then
    begin
      query1.Close;
      ShowMessage('NFCe não encontrada');
      exit;
    end;

  ACBrNFe.Configuracoes.WebServices.Visualizar := true;
  ACBrNFe.NotasFiscais.Clear;
  ACBrNFe.NotasFiscais.LoadFromFile(ACBrNFe.Configuracoes.Geral.PathSalvar+'\'+query1.FieldByName('chave').AsString+'-nfe.xml');
  ACBrNFe.Consultar;
  ACBrNFe.Configuracoes.WebServices.Visualizar := true;
  try
 {  WBResposta := TWebBrowser.Create(nil);
   MemoResp   := TMemo.Create(nil);
   LoadXML(MemoResp, WBResposta);
  }finally
 //  FreeAndNil(MemoResp);
 //  FreeAndNil(WBResposta);
  end;
  //////////////////////////
  {qry.edit;
  qry.IB_Transaction.StartTransaction;
  qry.FieldByName('RECIBO_PROTOCOLO').AsString := dtmMain.ACBrNFe.WebServices.Retorno.Protocolo;
  qry.FieldByName('RECIBO_NUMERO').AsString    := dtmMain.ACBrNFe.WebServices.Retorno.Recibo;
  qry.FieldByName('NFE_SITUACAO').AsString     := 'Transmitida';
  qry.FieldByName('NFE_RESULTADO').AsString    := 'Autorizada';
  qry.IB_Transaction.CommitRetaining;
  } /////////////////////////////////

end;

procedure Imprimir_DANFE_PDF(numeroNota:String);
var
 ArqPDF,
 nomeArquivo:string;
begin
  query1.Close;
 query1.SQL.Text := 'select chave from nfce where nota = :nota';
 query1.ParamByName('nota').AsString := numeroNota;
 query1.Open;

 if query1.IsEmpty then
    begin
      query1.Close;
      ShowMessage('NFCe não encontrada');
      exit;
    end;

 ACBrNFe.NotasFiscais.Clear;
 nomeArquivo := ACBrNFe.Configuracoes.Geral.PathSalvar+query1.FieldByName('chave').AsString+'-nfe.xml';
 ACBrNFe.NotasFiscais.LoadFromFile(nomeArquivo);

 imprimirNfce();
end;

function Cancelamento_NFe(numeroNota:String; MemoResp:TMemo; WBResposta:TWebBrowser):Boolean;
var
 Chave, idLote, CNPJ, Protocolo, Justificativa, tmp : string;
begin
 Result := false;
 query1.Close;
 query1.SQL.Text := 'select chave from nfce where nota = :nota';
 query1.ParamByName('nota').AsString := numeroNota;
 query1.Open;

 if query1.IsEmpty then
    begin
      query1.Close;
      ShowMessage('NFCe não encontrada');
      exit;
    end;
 {qry.close;
 qry.ParamByName('NUVENDACFE').AsString := numeroNota;
 qry.Open;

 if qry.FieldByName('CHAVEACESSO').IsNull  then ShowMessage('NF-e Ainda não Foi Transmitida ou Autorizada!');
 if qry.FieldByName('CHAVEACESSO').IsNull  then exit;
 if qry.FieldByName('STATUS').AsString      = 'C' then ShowMessage('NF-e já Foi Cancelada!');
 if qry.FieldByName('STATUS').AsString      = 'C' then exit;
  }
 if MessageDlg('Tem Certeza que Deseja Cancelar a Nota Fiscal: '+numeroNota+' ?',mtConfirmation,[mbYes, mbNo],0)= mrYes then
  begin
    Application.ProcessMessages;
    Application.ProcessMessages;

    idLote := '1';
    if not(InputQuery('WebServices Eventos: Cancelamento', 'Justificativa', Justificativa)) then exit;
    ACBrNFe.EventoNFe.Evento.Clear;
    ACBrNFe.EventoNFe.idLote := StrToInt(idLote) ;
    with ACBrNFe.EventoNFe.Evento.Add do
    begin
     infEvento.dhEvento        := now;
     infEvento.tpEvento        := teCancelamento;
     infEvento.detEvento.xJust := Justificativa;
    end;
    ACBrNFe.EnviarEventoNFe(StrToInt(idLote));

    MemoResp.Lines.Text   :=  UTF8Encode(ACBrNFe.WebServices.EnvEvento.RetWS);
    LoadXML(MemoResp, WBResposta);

   tmp := ACBrNFe.WebServices.EnvEvento.EventoRetorno.retEvento.Items[0].RetInfEvento.xMotivo;

   if ACBrNFe.WebServices.EnvEvento.EventoRetorno.retEvento.Items[0].RetInfEvento.cStat < 200 then
     begin
       ShowMessage('NF-e Cancelada com Sucesso. Protocolo '+ ACBrNFe.WebServices.retorno.Protocolo);
       Result := true;
     end
   else
     begin
       ShowMessage('Ocorreu um Erro no Cancelamento:' + #13 + tmp + IfThen(pos('Duplicidade', tmp) > 0, #13 + #13 + 'Esta Nota já pode ter Sido Cancelada', ''));
     end;
   //MemoResp.Lines.Text :=  UTF8Encode(ACBrNFe.WebServices.Cancelamento.RetWS);
   //LoadXML(MemoResp, WBResposta);

  end;
end;

function Cancelamento_NFe(numeroNota:String):Boolean;
var
 Chave, idLote, CNPJ, Protocolo, Justificativa, tmp : string;
begin
 Result := false;
 query1.Close;
 query1.SQL.Text := 'select chave from nfce where nota = :nota';
 query1.ParamByName('nota').AsString := numeroNota;
 query1.Open;

 if query1.IsEmpty then
    begin
      query1.Close;
      ShowMessage('NFCe não encontrada');
      exit;
    end;
 {qry.close;
 qry.ParamByName('NUVENDACFE').AsString := numeroNota;
 qry.Open;

 if qry.FieldByName('CHAVEACESSO').IsNull  then ShowMessage('NF-e Ainda não Foi Transmitida ou Autorizada!');
 if qry.FieldByName('CHAVEACESSO').IsNull  then exit;
 if qry.FieldByName('STATUS').AsString      = 'C' then ShowMessage('NF-e já Foi Cancelada!');
 if qry.FieldByName('STATUS').AsString      = 'C' then exit;
  }
 if MessageDlg('Tem Certeza que Deseja Cancelar a Nota Fiscal: '+numeroNota+' ?',mtConfirmation,[mbYes, mbNo],0)= mrYes then
  begin
    Application.ProcessMessages;
    Application.ProcessMessages;
   ACBrNFe.NotasFiscais.Clear;
   ACBrNFe.NotasFiscais.LoadFromFile(ACBrNFe.Configuracoes.Geral.PathSalvar+'\'+query1.FieldByName('chave').AsString+'-nfe.xml');
    idLote := '1';
    if not(InputQuery('WebServices Eventos: Cancelamento', 'Justificativa', Justificativa)) then exit;
    ACBrNFe.EventoNFe.Evento.Clear;
    ACBrNFe.EventoNFe.idLote := StrToInt(idLote) ;
    with ACBrNFe.EventoNFe.Evento.Add do
    begin
     infEvento.dhEvento        := now;
     infEvento.tpEvento        := teCancelamento;
     infEvento.detEvento.xJust := Justificativa;
    end;
    ACBrNFe.EnviarEventoNFe(StrToInt(idLote));

    //MemoResp.Lines.Text   :=  UTF8Encode(ACBrNFe.WebServices.EnvEvento.RetWS);
    //LoadXML(MemoResp, WBResposta);

   tmp := ACBrNFe.WebServices.EnvEvento.EventoRetorno.retEvento.Items[0].RetInfEvento.xMotivo;

   if ACBrNFe.WebServices.EnvEvento.EventoRetorno.retEvento.Items[0].RetInfEvento.cStat < 200 then
     begin
       ShowMessage('NF-e Cancelada com Sucesso. Protocolo '+ ACBrNFe.WebServices.retorno.Protocolo);
       Result := true;
     end
   else
     begin
       ShowMessage('Ocorreu um Erro no Cancelamento:' + #13 + tmp + IfThen(pos('Duplicidade', tmp) > 0, #13 + #13 + 'Esta Nota já pode ter Sido Cancelada', ''));
     end;
   //MemoResp.Lines.Text :=  UTF8Encode(ACBrNFe.WebServices.Cancelamento.RetWS);
   //LoadXML(MemoResp, WBResposta);

  end;
end;

procedure GerarNFCe(nota, NumNFCe, TipoEmissao, TipoAmbiente, UFComerciante, FinalidadeNFe : String);
var
 qr,qrPg  : tibquery;
 sql      : string;
 sCST,
 idCST    : string;
 sCondPag : string;
 CodUF,
 CodMun   : string;
 bolISSQN : string;
 qry      : TIBQuery;
 ini, fim : integer;
 item     : Item_venda;
 op : TOpenDialog;
begin
  lerItensDaVenda(lista, nota);
  codNF := StrToIntDef(Incrementa_Generator('NFCE', 0), 0);
  if codNF = 0 then codNF := 1;

 ACBrNFe.NotasFiscais.Clear;

 try
 ACBrNFe.NotasFiscais.Clear;
 ACBrNFe.NotasFiscais.Add;

   with ACBrNFe.NotasFiscais.Items[0].NFe do
    begin
     LerDados_Emit_Dest(cliente);
     lerNodoIde(codNF);
     lerNodoEmitDest();

     with pag.Add do
      begin
       tPag := fpDinheiro;
       vPag := venda.total;
      end;

      //Adicionando Produtos
      fim := lista.Count -1;
     for ini := 0 to fim do
      begin
        item := Item_venda(lista.Items[ini]);

        Det.Add;
       with Det.Items[ini] do
        begin
         Prod.nItem    := ini + 1;
         Prod.cProd    := IntToStr(item.cod);
         Prod.cEAN     := item.codbar;
         Prod.xProd    := item.nome;
         Prod.NCM      := item.Ncm;
         Prod.EXTIPI   := '';
         Prod.CFOP     := '5102';
         Prod.uCom     := item.unid;
         Prod.qCom     := item.quant;
         Prod.vUnCom   := item.p_venda;
         Prod.vProd    := item.total;
         Prod.cEANTrib := item.codbar;
         Prod.uTrib    := item.unid;
         Prod.qTrib    := item.quant;
         Prod.vUnTrib  := item.p_venda;
         Prod.vFrete   := 0;
         Prod.vSeg     := 0;
         Prod.vDesc    := item.Desconto;

         tot_Geral     := tot_Geral + (item.total - item.Desconto);

         NODO_ICMS(item, '', '', ini);
         NODO_PISCOFINS(item, '', ini);
         infAdProd     := ' ';
        end;
   end;

     Total.ICMSTot.vBC   := TOT_BASEICM;
     Total.ICMSTot.vICMS := TOTICM;
     Total.ICMSTot.vBCST := 0;
     Total.ICMSTot.vST   := 0;
     Total.ICMSTot.vNF   := venda.total;
     Total.ICMSTot.vProd := totalNota;
     Total.ICMSTot.vFrete:= 0;
     Total.ICMSTot.vSeg  := 0;
     Total.ICMSTot.vDesc := venda.desconto;
     Total.ICMSTot.vIPI  := 0;
     total.ICMSTot.vPIS    := TOT_PIS;
     total.ICMSTot.vCOFINS := TOT_COFINS;
     Total.ICMSTot.vOutro:= 0;
     Transp.modFrete     := mfSemFrete; // NFC-e não pode ter FRETE
     InfAdic.infCpl      :=  '';
     InfAdic.infAdFisco  :=  '';
   //ACBrNFe.NotasFiscais.Items[0].SaveToFile(ExtractFileDir(ParamStr(0)) + '\arq.xml');
  //ShowMessage(dtmMain.ACBrNFe.NotasFiscais.Items[0].);
 {  // Informa as formas de pagamento e seus respectivos valores !!
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
  //FreeAndNil(qr);
 end;
end;

function FormaPagamento_NFCe(formaPagto:String): TpcnFormaPagamento;
begin
 Result := fpDinheiro;

  if (Pos('Cart', formaPagto) > 0) or
    (Pos('cart', formaPagto) > 0) or
    (Pos('CART', formaPagto) > 0) or
    (Pos('cArT', formaPagto) > 0) or
    (Pos('CARt', formaPagto) > 0) then Result := fpCartaoCredito
    else Result := fpDinheiro;

  if (Pos('Val', formaPagto) > 0) or
    (Pos('VAL', formaPagto) > 0) or
    (Pos('val', formaPagto) > 0) or
    (Pos('VAl', formaPagto) > 0) or
    (Pos('VaL', formaPagto) > 0) then Result := fpValePresente
    else Result := fpDinheiro;

 if (Pos('Refeicao', formaPagto) > 0) or
    (Pos('REFEICAO', formaPagto) > 0) or
    (Pos('refeição', formaPagto) > 0) or
    (Pos('REFEIÇÃO', formaPagto) > 0) or
    (Pos('Refeição', formaPagto) > 0) then Result := fpValeRefeicao
    else Result := fpDinheiro;

 if (Pos('Din', formaPagto) > 0) or
    (Pos('DIN', formaPagto) > 0) or
    (Pos('din', formaPagto) > 0) or
    (Pos('DIn', formaPagto) > 0) then Result := fpDinheiro
    else Result := fpDinheiro;

 if (Pos('Cheq', formaPagto) > 0) or
    (Pos('CHEQ', formaPagto) > 0) or
    (Pos('cheq', formaPagto) > 0) or
    (Pos('CHeq', formaPagto) > 0) then Result := fpCheque
    else Result := fpDinheiro;

 if (Pos('Credito', formaPagto) > 0) or
    (Pos('Crédito', formaPagto) > 0) or
    (Pos('credito', formaPagto) > 0) or
    (Pos('crédito', formaPagto) > 0) or
    (Pos('CREDITO', formaPagto) > 0) or
    (Pos('CRÉDITO', formaPagto) > 0) then Result := fpCartaoCredito
    else Result := fpDinheiro;

 if (Pos('Debito', formaPagto) > 0) or
    (Pos('Débito', formaPagto) > 0) or
    (Pos('debito', formaPagto) > 0) or
    (Pos('débito', formaPagto) > 0) or
    (Pos('DEBITO', formaPagto) > 0) or
    (Pos('débito', formaPagto) > 0) then Result := fpCartaoDebito
    else Result := fpDinheiro;


end;


function Retorna_TipoEmissaoNFe(svl:string):TpcnTipoEmissao;
begin
 Result := teNormal;
      if svl = '1' then Result := teContingencia
 else if svl = '2' then Result := teSCAN
 else if svl = '3' then Result := teDPEC
 else if svl = '4' then Result := teFSDA
 else Result := teNormal;
end;

function Retorna_TipoAmbiente(svl:string):TpcnTipoAmbiente;
begin
 if svl = '1' then Result := taProducao
 else Result := taHomologacao;
end;

function Retorna_UFComerciante(svl:string):String;
begin
 Result := svl
end;

procedure reimpressaoNFCe(numeroNota:String);
begin

end;

function Retorna_FinalidadeNFe(svl:string):TpcnFinalidadeNFe;
begin
      if svl = 'COMPLEMENTAR' then Result := fnComplementar
 else if svl = 'AJUSTE'       then Result := fnAjuste
 else Result := fnNormal;
end;



procedure Carrega_NotaFiscal_ArquivoXML(OpenDialog:TOpenDialog; var NotaFiscal:String; var CFOP:String; var CondPagto:String; var ModeloNF:String; var SerieNF:String; var DtEmissao:TDate; var DtEntSai:TDate;
                                                                var HrEntSai:TDateTime; var CNPJEmitente:String; var InscEstEmitente:String; var InscMunicEmitente:String; var EnderecoEmitente:String;
                                                                var NumeroEndEmitente:String; var BairroEmitente:String; var codMunicipoEmitente:String; var NomeMunicipioEmiente:String;
                                                                var UFEmitente:String; var FoneEmitente:String; var CEPEmitente:String; var CNPJDestinario:String; var codMunicipioDestinario:String;
                                                                var VlBaseCalculo:String; var VlICMS:String; var VlBaseCalculoST:String; var VlST:String; var VlProduto:String; var VlFrete:String; var VlSeguro:String;
                                                                var VlDesconto:String; var VlIPI:String; var VlPis:String; var VlCofins:String; var VlOutros:String; var VlNotaFiscal:String;
                                                                var ListaProdutos:TStrings);
var
 i, j, k, n  : integer;
 Nota, Node, NodePai, NodeItem: TTreeNode;
 NFeRTXT: TNFeRTXT;
 nuItem, CodProd, NomeProd,
 qtdProd, vlUnitProd,
 vlTotProd, codEANProd,
 CodNCMProd,CFOPProd, unidadeProd,
 vlFreteProd, vlSeguroProd, vlOutrosProd,
 vlDescontoProd, CSTProd,
 vlBaseCalcICMSProd, vlICMSProd, alICMSProd,
 vlBaseCalcSTProd, vlSTICMSProd, alICMSSTProd,
 vlBaseCalcICMSRedProd, vlICMSRedProd, alICMSRedProd,
 vlBaseCalcIPIProd, vlIPIProd, alIPIProd,
 vlBaseCalcPisProd, vlPisProd, alPisProd,
 vlBaseCalcCofinsProd, vlCofinsProd, alCofinsProd : String;
begin
 with OpenDialog do
  begin
   FileName   :=  '';
   Title      := 'Selecione a NFE';
   DefaultExt := '*-nfe.XML';
   Filter     := 'Arquivos NFE (*-nfe.XML)|*-nfe.XML|Arquivos XML (*.XML)|*.XML|Arquivos TXT (*.TXT)|*.TXT|Todos os Arquivos (*.*)|*.*';
   InitialDir := ACBrNFe.Configuracoes.Geral.PathSalvar;
  end;
  if OpenDialog.Execute then
   begin
    ACBrNFe.NotasFiscais.Clear;
    ACBrNFe.NotasFiscais.Add;
    NFeRTXT := TNFeRTXT.Create(ACBrNFe.NotasFiscais.Items[0].NFe);
    NFeRTXT.CarregarArquivo(OpenDialog.FileName);
    if NFeRTXT.LerTxt then NFeRTXT.Free
     else
      begin
       NFeRTXT.Free;
       //tenta XML
       ACBrNFe.NotasFiscais.Clear;
       try
        ACBrNFe.NotasFiscais.LoadFromFile(OpenDialog.FileName);
       except
        ShowMessage('Arquivo NFC-e Inválido');
        exit;
       end;
      end;

      for n := 0 to ACBrNFe.NotasFiscais.Count -1 do
       begin
        with ACBrNFe.NotasFiscais.Items[n].NFe do
         begin
          NotaFiscal          := IntToStr(Ide.nNF);
          CFOP                := Ide.natOp;
          CondPagto           := IndpagToStr(Ide.indPag);
          ModeloNF            := IntToStr(Ide.modelo);
          SerieNF             := IntToStr(Ide.serie);
          DtEmissao           := (Ide.dEmi);
          DtEntSai            := (Ide.dSaiEnt);
          CNPJEmitente        := Emit.CNPJCPF;
          InscEstEmitente     := Emit.IE;
          InscEstEmitente     := Emit.IEST;
          InscMunicEmitente   := Emit.IM;
          FoneEmitente        := Emit.EnderEmit.fone;
          CEPEmitente         := IntToStr(Emit.EnderEmit.CEP);
          EnderecoEmitente    := Emit.EnderEmit.xLgr;
          NumeroEndEmitente   := Emit.EnderEmit.nro;
          BairroEmitente      := Emit.EnderEmit.xBairro;
          codMunicipoEmitente := IntToStr(Emit.EnderEmit.cMun);
          NomeMunicipioEmiente:= Emit.EnderEmit.xMun;
          UFEmitente          := Emit.EnderEmit.UF;

          // Dados Destinatário !!
          CNPJDestinario         := Dest.CNPJCPF;
          codMunicipioDestinario := IntToStr(Dest.EnderDest.cMun);
          //
           for I := 0 to Det.Count-1 do
            begin
             with Det.Items[I] do
              begin
               nuItem           := IntToStr(Prod.nItem);
               CodProd          := Prod.cProd;
               codEANProd       := Prod.cEAN;
               NomeProd         := Prod.xProd;
               CodNCMProd       := Prod.NCM;
               CFOPProd         := Prod.CFOP;
               unidadeProd      := Prod.uCom;
               qtdProd          := FloatToStr(Prod.qCom);
               vlUnitProd       := FloatToStr(Prod.vUnCom);
               vlTotProd        := FloatToStr(Prod.vProd);
//               vlFreteProd      := FloatToStr(Prod.vFrete);
//               vlSeguroProd     := FloatToStr(Prod.vSeg);
               vlDescontoProd   := FloatToStr(Prod.vDesc);
               //
                with Imposto do
                 begin
                  with ICMS do
                   begin
                    if CST = cst00 then
                     begin
                      vlBaseCalcICMSProd  := FloatToStr(ICMS.vBC);
                      vlICMSProd          := FloatToStr(ICMS.vICMS);
                      alICMSProd          := FloatToStr(ICMS.pICMS);
                     end
                      else if CST = cst10 then
                       begin
                        vlBaseCalcICMSProd := FloatToStr(ICMS.vBC);
                        vlICMSProd         := FloatToStr(ICMS.vICMS);
                        alICMSProd         := FloatToStr(ICMS.pICMS);
                        //
                        vlBaseCalcSTProd   := FloatToStr(ICMS.vBCST);
                        vlSTICMSProd       := FloatToStr(ICMS.vICMSST);
                        alICMSSTProd       := FloatToStr(ICMS.pICMSST);
                       end
                      else if CST = cst20 then
                       begin
                        vlBaseCalcICMSProd := FloatToStr(ICMS.vBC);
                        vlICMSProd         := FloatToStr(ICMS.vICMS);
                        alICMSProd         := FloatToStr(ICMS.pICMS);
                       end
                      else if CST = cst30 then
                       begin
                        vlBaseCalcSTProd   := FloatToStr(ICMS.vBCST);
                        vlSTICMSProd       := FloatToStr(ICMS.vICMSST);
                        alICMSSTProd       := FloatToStr(ICMS.pICMSST);
                       end

                      else if (CST = cst40) or (CST = cst41) or (CST = cst50) then
                       begin
                        // trvwNFe.Items.AddChild(Node,'orig='    +OrigToStr(ICMS.orig));
                        vlBaseCalcICMSProd := FloatToStr(ICMS.vBC);
                        vlICMSProd         := FloatToStr(ICMS.vICMS);
                        alICMSProd         := FloatToStr(ICMS.pICMS);
                       end
                      else if CST = cst51 then
                         begin
                          vlBaseCalcICMSProd := FloatToStr(ICMS.vBC);
                          vlICMSProd         := FloatToStr(ICMS.vICMS);
                          alICMSProd         := FloatToStr(ICMS.pICMS);
                       end
                      else if CST = cst60 then
                       begin
                        vlBaseCalcSTProd   := FloatToStr(ICMS.vBCST);
                        vlSTICMSProd       := FloatToStr(ICMS.vICMSST);
                        alICMSSTProd       := FloatToStr(ICMS.pICMSST);
                       end
                      else if CST = cst70 then
                       begin
                        vlBaseCalcICMSProd := FloatToStr(ICMS.vBC);
                        vlICMSProd         := FloatToStr(ICMS.vICMS);
                        alICMSProd         := FloatToStr(ICMS.pICMS);
                        //
                        vlBaseCalcSTProd   := FloatToStr(ICMS.vBCST);
                        vlSTICMSProd       := FloatToStr(ICMS.vICMSST);
                        alICMSSTProd       := FloatToStr(ICMS.pICMSST);
                       end
                      else if CST = cst90 then
                       begin
                        vlBaseCalcICMSProd := FloatToStr(ICMS.vBC);
                        vlICMSProd         := FloatToStr(ICMS.vICMS);
                        alICMSProd         := FloatToStr(ICMS.pICMS);
                        //
                        vlBaseCalcSTProd   := FloatToStr(ICMS.vBCST);
                        vlSTICMSProd       := FloatToStr(ICMS.vICMSST);
                        alICMSSTProd       := FloatToStr(ICMS.pICMSST);
                       end;
                   end;

                   if (IPI.vBC > 0) then
                    begin
                      with IPI do
                       begin
                        vlBaseCalcIPIProd  := FloatToStr(IPI.vBC);
                        vlIPIProd          := FloatToStr(IPI.vIPI);
                        alIPIProd          := FloatToStr(IPI.pIPI);
                       end;
                    end;

                   if (II.vBc > 0) then
                    begin
                      with II do
                       begin
                       //
                       end;
                    end;

                   with PIS do
                    begin
                      if (CST = pis01) or (CST = pis02) then
                       begin
                        vlBaseCalcPisProd  := FloatToStr(PIS.vBC);
                        vlPisProd          := FloatToStr(PIS.vPIS);
                        alPisProd          := FloatToStr(PIS.pPIS);
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

                   if (PISST.vBc>0) then
                    begin
                      with PISST do
                       begin
                       //
                       end;
                      end;

                   with COFINS do
                    begin
                      if (CST = cof01) or (CST = cof02)   then
                       begin
                        vlBaseCalcCofinsProd := FloatToStr(COFINS.vBC);
                        vlCofinsProd         := FloatToStr(COFINS.vCOFINS);
                        alCofinsProd         := FloatToStr(COFINS.pCOFINS);
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
                   if(COFINSST.vBC > 0) then
                    begin
                      with COFINSST do
                       begin
                       //
                       end;
                    end;
                 end;
             end;
//            if vlFreteProd           = '' then vlFreteProd            := '0';
            if vlSeguroProd          = '' then vlSeguroProd           := '0';
            if vlOutrosProd          = '' then vlOutrosProd           := '0';
            if vlDescontoProd        = '' then vlDescontoProd         := '0';
            if CSTProd               = '' then CSTProd                := '0000';
            if vlBaseCalcICMSProd    = '' then vlBaseCalcICMSProd     := '0';
            if vlICMSProd            = '' then vlICMSProd             := '0';
            if alICMSProd            = '' then alICMSProd             := '0';
            if vlBaseCalcSTProd      = '' then vlBaseCalcSTProd       := '0';
            if vlSTICMSProd          = '' then vlSTICMSProd           := '0';
            if alICMSSTProd          = '' then alICMSSTProd           := '0';
            if vlBaseCalcICMSRedProd = '' then vlBaseCalcICMSRedProd  := '0';
            if vlICMSRedProd         = '' then vlICMSRedProd          := '0';
            if alICMSRedProd         = '' then alICMSRedProd          := '0';
            if vlBaseCalcIPIProd     = '' then vlBaseCalcIPIProd      := '0';
            if vlIPIProd             = '' then vlIPIProd              := '0';
            if alIPIProd             = '' then alIPIProd              := '0';
            if vlBaseCalcPisProd     = '' then vlBaseCalcPisProd      := '0';
            if vlPisProd             = '' then vlPisProd              := '0';
            if alPisProd             = '' then alPisProd              := '0';
            if vlBaseCalcCofinsProd  = '' then vlBaseCalcCofinsProd   := '0';
            if vlCofinsProd          = '' then vlCofinsProd           := '0';
            if alCofinsProd          = '' then alCofinsProd           := '0';

         {    ListaProdutos.Add(Alinha_Esquerda(nuItem,08)+' '+Alinha_Esquerda(CodProd,08)+' '+AjustaString(codEANProd,40)+' '+AjustaString(NomeProd, 60)+' '+AjustaString(CodNCMProd,40)+' '+
                               AjustaString(CFOPProd,10)+' '+AjustaString(unidadeProd,05)+' '+Alinha_Esquerda(qtdProd,08)+' '+Alinha_Esquerda(vlUnitProd,16)+' '+Alinha_Esquerda(vlTotProd,16)+' '+
                               Alinha_Esquerda(vlFreteProd,16)+' '+Alinha_Esquerda(vlSeguroProd,16)+' '+Alinha_Esquerda(vlDescontoProd,16)+' '+Alinha_Esquerda(vlOutrosProd,16)+' '+Alinha_Esquerda(vlBaseCalcICMSProd,16)+' '+
                               Alinha_Esquerda(vlICMSProd,16)+' '+Alinha_Esquerda(alICMSProd,16)+' '+Alinha_Esquerda(vlBaseCalcSTProd,16)+' '+Alinha_Esquerda(vlSTICMSProd,16)+' '+Alinha_Esquerda(alICMSSTProd,16)+' '+
                               Alinha_Esquerda(vlBaseCalcIPIProd,16)+' '+Alinha_Esquerda(vlIPIProd,16)+' '+Alinha_Esquerda(alIPIProd,16)+' '+Alinha_Esquerda(vlBaseCalcPisProd,16)+' '+Alinha_Esquerda(vlIPIProd,16)+' '+
                               Alinha_Esquerda(alPisProd,16)+' '+Alinha_Esquerda(vlBaseCalcCofinsProd,16)+' '+Alinha_Esquerda(vlCofinsProd,16)+' '+Alinha_Esquerda(alCofinsProd,16));
          }end;
       VlBaseCalculo    := FloatToStr(Total.ICMSTot.vBC);
       VlICMS           := FloatToStr(Total.ICMSTot.vICMS);
       VlBaseCalculoST  := FloatToStr(Total.ICMSTot.vBCST);
       VlST             := FloatToStr(Total.ICMSTot.vST);
       VlProduto        := FloatToStr(Total.ICMSTot.vProd);
       VlFrete          := FloatToStr(Total.ICMSTot.vFrete);
       VlSeguro         := FloatToStr(Total.ICMSTot.vSeg);
       VlDesconto       := FloatToStr(Total.ICMSTot.vDesc);
       VlIPI            := FloatToStr(Total.ICMSTot.vIPI);
       VlPis            := FloatToStr(Total.ICMSTot.vPIS);
       VlCofins         := FloatToStr(Total.ICMSTot.vCOFINS);
       VlOutros         := FloatToStr(Total.ICMSTot.vOutro);
       VlNotaFiscal     := FloatToStr(Total.ICMSTot.vNF);
     end;
     end;
  end;
end;



end.



