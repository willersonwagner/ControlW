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
     pcnConversao, pcnNFeRTXT, ACBrUtil, DateUtils, ACBrNFe,
     ACBrNFeDANFEClass, printers, ACBrNFeDANFeESCPOS,
     func, ibquery, classes1, StrUtils, acbrbal, WINDOWS, funcoesdav,
     ACBrIBPTax, pcnConversaoNFe,
     ACBrDFeSSL, ACBrPosPrinter, ACBrDANFCeFortesFr, ACBrNFeDANFeRL,
     ACBrNFeDANFeRLClass, SyncObjs, ACBrNFeDANFEFR, ACBrMail, IdThreadComponent;

{type
  TTWtheadNFeEnvia = class(TThread)
  private
     acbrnf : TACBrNFe;
     FCritical : TCriticalSection;
     procedure AfterConstruction; override;
  protected
    procedure Execute; override;
    procedure FinalizaSessaoCritica;
  public
    constructor Create(const CreateSuspended : boolean; var acbrnf1 : TACBrNFe);
  end;

  TTWtheadNFeConsulta = class(TThread)
  private
     acbrnf : TACBrNFe;
     FCritical : TCriticalSection;
     procedure AfterConstruction; override;
  protected
    procedure Execute; override;
  public
    constructor Create(const CreateSuspended : boolean; var acbrnf1 : TACBrNFe);
  end;           }



implementation

uses pcnNFe, Math, DB, ACBrNFeNotasFiscais, pcnEventoNFe, pcnEnvEventoNFe,
  ACBrNFeWebServices;


end.


