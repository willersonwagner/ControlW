unit untVendaPDV;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, sEdit, func, ExtCtrls, sPanel, jpeg, JsEdit1,
  JsEditNumero1, JsEditInteiro1, Grids, DBGrids, DB, DBClient,
  acbrecf, ComCtrls, ACBrBase, ACBrBAL, untnfceForm, formas, ACBrDevice,
  classes1, ACBrLCB, login, acbrnfe, pcnconversao, SyncObjs, ACBrGAV, printers,
  cadClicompleto, funcoesdav;

type

  TTWtheadEnviaCupons1 = class(TThread)
  private
    timer0 : TTimer;
    label1 : TPanel;
    terminou1 : boolean;
    SessaoCritica: TcriticalSection;
  protected
    procedure Execute; override;
  public
    constructor create(CreateSuspended: Boolean;lab1: TPanel; var terminou : boolean);
  end;

  TForm3 = class(TForm)
    Image1: TImage;
    PainelProduto: TPanel;
    codbar: JsEdit;
    LabelCodBar: TLabel;
    LabelQuantidade: TLabel;
    quant: JsEditNumero;
    labelpreco: TLabel;
    preco: JsEditNumero;
    LabelTotal: TLabel;
    total: JsEditNumero;
    Panel2: TPanel;
    DataSource1: TDataSource;
    RichEdit1: TListBox;
    Timer1: TTimer;
    PainelTotal: TPanel;
    IBClientDataSet1: TClientDataSet;
    IBClientDataSet1cod: TIntegerField;
    IBClientDataSet1codbar: TStringField;
    IBClientDataSet1nome: TStringField;
    IBClientDataSet1quant: TCurrencyField;
    IBClientDataSet1preco: TCurrencyField;
    IBClientDataSet1p_total: TAggregateField;
    Panel4: TPanel;
    IBClientDataSet1aliq: TCurrencyField;
    IBClientDataSet1contador: TIntegerField;
    TimerVenda: TTimer;
    ACBrLCB1: TACBrLCB;
    NomesAjuda: TLabel;
    Button1: TButton;
    IBClientDataSet1precoOrigi: TCurrencyField;
    IBClientDataSet1p_compra: TCurrencyField;
    IBClientDataSet1total: TCurrencyField;
    IBClientDataSet1totalOrigi: TCurrencyField;
    Button2: TButton;
    PainelCaixa: TPanel;
    Panel1: TPanel;
    TimerEnvia: TTimer;
    compGAV: TACBrGAV;
    IBClientDataSet1preco_atacado: TCurrencyField;
    IBClientDataSet1quant_promo: TCurrencyField;
    RichEdit2: TRichEdit;
    Button3: TButton;
    Timer2: TTimer;
    procedure FormShow(Sender: TObject);
    procedure codbarKeyPress(Sender: TObject; var Key: Char);
    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure RichEdit1DrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure codbarKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure quantKeyPress(Sender: TObject; var Key: Char);
    procedure Button1Click(Sender: TObject);
    procedure TimerVendaTimer(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure IBClientDataSet1AfterPost(DataSet: TDataSet);
    procedure TimerEnviaTimer(Sender: TObject);
    procedure codbarKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Button3Click(Sender: TObject);
    procedure Timer2Timer(Sender: TObject);
  private
    dav, EnterHabilitado : boolean;
    recebido, recebido1, troco, entrada, utiLeituraBalanca : currency;
    nota_venda, codhis, receb, obs, crc, corte, codTemp, balArredonda : String;
    formasP, formaPagtoImpressora : TStringList;
    dadosEmpresa : TStringList;
    inicio : smallint;
    TotTributos : currency;
    indice, vendedor, NomeVendedorTemp, tipoArredondaVenda, codECF : string;
    formasPagamento : TClientDataSet;
    cupomAberto, vendendoECF, cupomAberto1, vendeuf2 : boolean;
    arq : TStringList;
    usarOFFLINE : boolean;
    codCliente, valCert, qtdCupom : String;
    enviandoCupom, tecladoOK : boolean;
    cupons : TTWtheadEnviaCupons1;
    procedure vendeVisualTodos();
    function FileAgeCreate(const fileName: string): TDateTime;
    function VerificaAcesso_Se_Nao_tiver_Nenhum_bloqueio_true_senao_false : boolean;
    function buscaClienteCompleto() : Smallint;
    function confirmaPrecoProduto(cod : String;var qtd , valor : String; opcao : smallint; servico : boolean = false) : string;
    procedure atualizaPrecoProduto(codigo : integer; preco1 : currency);
    function verSeExisteTabela(nome : String) : boolean;
    function tudoOK_para_emitir_NFCe() : boolean;
    procedure atualizaGenerator();
    procedure abreGavetaComponente();
    procedure abreGaveta();
    function vercCountContigencia() : String;
    procedure verificaNotasContigencia();
    procedure enviaCuponsPendentes();
    function enviNFCe(const perg : String = ''; cli : String  = ''; vRecebido : currency = 0) : boolean;
    procedure reimprimir();
    procedure aguardaRespostaECF(const intervalo : integer = 100);
    function somaTotalOriginal(somaValorReal : boolean = false; naoSomarCancelados : boolean = true) : Currency;
    procedure setaConfigBalanca();
    procedure setaCoresPDV();
    procedure alinhaComponentes();
    procedure vendeItem();
    procedure vendeItemFila(const codbar1 : string);
    procedure vendeVISUAL();
    function lerPesoBalanca() : currency;
    procedure encerrarVenda(dialogo1 : boolean = true);
    function gravaVenda(cancelado : boolean = false) : boolean;
    function gravaVenda1(cancelado : boolean = false) : boolean;
    procedure verProdutos();
    procedure limpaVenda();
    procedure mostraTroco();
    procedure atualizaCRC(var nota, crc : String);
    function emiteDAV() : boolean;
    procedure fechaDav();
    function lerReceido() : boolean;
    procedure lerFormasParaGravarAVendaPreencheEntrada();
    procedure descarregaFormasDePagamentoImpressora();
    procedure criaDataSetFormas();
    procedure identificaCliente(var codcli : String);
    procedure escreveTotal;
    { Private declarations }
  public
    acessoUsuVenda, configu, usaDLL, CodVendedorTemp : string;
    balOnline, abreLocalizaPesagem, tabelaPROMOC_EXISTE : boolean;
    tot_ge, desconto, descontoItens, tot1 : currency;
    function buscaPreco(codigo : integer; quant1 : currency) : currency;
    procedure inicializarImpressora();
    procedure cancelaVenda(nota2 : string = ''; erro_nfce : boolean = false);
    procedure lancaDesconto(var desc1, tot_g : currency; ConfigUsuario, tipoDesc, acessoUsu : String; precoDefault : currency = 0; CalcularMinimoPrecoTotalOriginal : currency = 0);
    procedure cancelaItemVisual(const num : smallint;const tot_item : currency);
    procedure verificaDavNFCeTravado;
    { Public declarations }
  end;

var
  Form3: TForm3;
Const
  sLineBreak = #13#10;

implementation

uses untDtmMain, ibquery, StrUtils, login1,
  MenuFiscal, consultaProduto, Math, dmecf, configImp, dialog, mens,
  cadCli, importapedido, untConfiguracoesNFCe, untmain;

{$R *.dfm}
procedure TForm3.setaCoresPDV();
var
 cor, cor1, cor2 : string;
  bs : TStream;
  fig : TJPEGImage;
begin

  cor := '-1- #000000 -2- #EEEED1 -';
  dtmMain.IBQuery1.Close;
  dtmMain.IBQuery1.SQL.Text := 'select nome, papel1 from CONFIG_TEMA where top = 1';
  dtmMain.IBQuery1.Open;

  if not dtmMain.IBQuery1.IsEmpty then
    begin
      cor := dtmMain.IBQuery1.fieldbyname('nome').AsString;
      fig := TJPEGImage.Create;
      bs := TStream.Create;
      bs := dtmMain.IBQuery1.CreateBlobStream(dtmMain.IBQuery1.FieldByName('papel1'),bmRead);

      if bs.Size > 0 then
        Begin
          fig.LoadFromStream(bs);
          self.Image1.Picture.Assign(fig);
        end;

      dtmMain.IBQuery1.Close;
      if cor = '' then exit;
    end
  else
    begin
      exit;
      if dtmMain.IBQuery1.fieldbyname('nome').AsString = '' then exit;
      dtmMain.IBQuery1.Close;
      dtmMain.IBQuery1.SQL.Text := 'update CONFIG_TEMA set nome = :nome';
      dtmMain.IBQuery1.ParamByName('nome').AsString := cor;
      dtmMain.IBQuery1.ExecSQL;
      dtmMain.IBQuery1.Transaction.Commit;
    end;
  dtmMain.IBQuery1.Close;

  //cor2 := StringReplace(LerConfig(cor, 2), '#', '', [rfReplaceAll]);
  //cor1 := StringReplace(LerConfig(cor, 1), '#', '', [rfReplaceAll]);
  cor2 := LerConfig(cor, 2); //painel
  cor1 := LerConfig(cor, 1); //fonte

  //ShowMessage(cor + #13 + cor1 + #13 + cor2);

  PainelProduto.Color      := StringToColor(cor2);
  PainelProduto.Font.Color := StringToColor(cor1);

  RichEdit1.Color      := StringToColor(cor2);
  RichEdit1.Font.Color := StringToColor(cor1);

  Panel2.Color      := StringToColor(cor2);
  Panel2.Font.Color := StringToColor(cor1);

  codbar.Color        := StringToColor(cor2);
  codbar.ColorOnEnter := StringToColor(cor2);
  codbar.Font.Color   := StringToColor(cor1);

  quant.Color        := StringToColor(cor2);
  quant.ColorOnEnter := StringToColor(cor2);
  quant.Font.Color   := StringToColor(cor1);

  preco.Color        := StringToColor(cor2);
  preco.ColorOnEnter := StringToColor(cor2);
  preco.Font.Color   := StringToColor(cor1);

  total.Color        := StringToColor(cor2);
  total.ColorOnEnter := StringToColor(cor2);
  total.Font.Color   := StringToColor(cor1);

  Panel4.Color          := StringToColor(cor2);
  Panel4.Font.Color     := StringToColor(cor1);
  NomesAjuda.Font.Color := StringToColor(cor1);
  {PainelProduto.Color      := HexToTColor(cor2);
  PainelProduto.Font.Color := HexToTColor(cor1);

  RichEdit1.Color      := HexToTColor(cor2);
  RichEdit1.Font.Color := HexToTColor(cor1);

  Panel2.Color      := HexToTColor(cor2);
  Panel2.Font.Color := HexToTColor(cor1);

  codbar.Color        := HexToTColor(cor2);
  codbar.ColorOnEnter := HexToTColor(cor2);
  codbar.Font.Color   := HexToTColor(cor1);

  quant.Color        := HexToTColor(cor2);
  quant.ColorOnEnter := HexToTColor(cor2);
  quant.Font.Color   := HexToTColor(cor1);

  preco.Color        := HexToTColor(cor2);
  preco.ColorOnEnter := HexToTColor(cor2);
  preco.Font.Color   := HexToTColor(cor1);

  total.Color        := HexToTColor(cor2);
  total.ColorOnEnter := HexToTColor(cor2);
  total.Font.Color   := HexToTColor(cor1);

  Panel4.Color          := HexToTColor(cor2);
  Panel4.Font.Color     := HexToTColor(cor2);
  NomesAjuda.Font.Color := HexToTColor(cor1);}
end;

procedure TForm3.atualizaCRC(var nota, crc : String);
begin
  dtmMain.IBQuery1.Close;
  dtmMain.IBQuery1.SQL.Text := 'update venda set ok = ''S'', crc = :crc, ENTREGA = ''C'' where nota = :nota' ;
  dtmMain.IBQuery1.ParamByName('nota').AsInteger := StrToIntDef(nota, 0);
  dtmMain.IBQuery1.ParamByName('crc').AsString   := copy(crc, 1, 9);
  dtmMain.IBQuery1.ExecSQL;
  dtmMain.IBQuery1.Transaction.Commit;
end;

function TForm3.emiteDAV() : boolean;
var
 cnpj, aliq, cod_aliq : String;
 erro : boolean;
begin
  erro := false;
  form2 := tform2.Create(self);
  form2.ShowModal;
  nota_venda := form2.nota;
  form2.Venda.Close;
  form2.itens.Close;
  form2.Free;

  if nota_venda = '' then exit;

  try
  dtmMain.IBQuery1.Close;
  dtmMain.IBQuery1.SQL.Text := 'select cliente, total, desconto, codhis, vendedor from venda where nota = :nota';
  dtmMain.IBQuery1.ParamByName('nota').AsString := nota_venda;
  dtmMain.IBQuery1.Open;

  if dtmMain.IBQuery1.IsEmpty then
    begin
      dtmMain.IBQuery1.Close;
      ShowMessage('Nota '+ nota_venda +' não encontrada');
      exit;
    end;

  dtmMain.IBQuery2.Close;
  dtmMain.IBQuery2.SQL.Text := 'select nome from vendedor where cod = :cod';
  dtmMain.IBQuery2.ParamByName('cod').AsString := dtmMain.IBQuery1.fieldbyname('vendedor').AsString;
  dtmMain.IBQuery2.Open;

  if not dtmMain.IBQuery2.IsEmpty then
    begin
      vendedor := dtmMain.IBQuery1.fieldbyname('vendedor').AsString + ' - ' + dtmMain.IBQuery2.fieldbyname('nome').AsString;
    end
  else vendedor := '';  

  dtmMain.IBQuery2.Close;
  dtmMain.IBQuery2.SQL.Text := 'select nome, cnpj, ende from cliente where cod = :cod';
  dtmMain.IBQuery2.ParamByName('cod').AsString := dtmMain.IBQuery1.fieldbyname('cliente').AsString;
  dtmMain.IBQuery2.Open;

  //aqui ja abriu cupom com ou sem os dados do cliente  

  dtmMain.IBQuery2.close;
  dtmMain.IBQuery2.SQL.Text := 'select i.unid,i.cod, i.codbar, i.quant, i.p_venda, p.p_compra as compra, p.p_venda as venda, i.total, p.nome, a.aliq, a.cod as cod_aliq from item_venda i ' +
  '  left join produto p on (p.cod = i.cod) left join aliq a on (a.cod = iif(trim(p.aliquota) = '''', 2, cast(p.aliquota as integer)))' +
  ' where nota = :nota';
  dtmMain.IBQuery2.ParamByName('nota').AsString := nota_venda;
  dtmMain.IBQuery2.Open;

  tot_ge      := 0;
  TotTributos := 0;
  IBClientDataSet1.EmptyDataSet;
  dav := true;

  try
    tecladoOK := false;

  while not dtmMain.IBQuery2.Eof do
    begin
      Application.ProcessMessages;

      cod_aliq := dtmMain.IBQuery2.fieldbyname('cod_aliq').AsString;
      aliq     := Trim(dtmMain.IBQuery2.fieldbyname('aliq').AsString);
      if aliq = '' then aliq := '17,00';

      if cod_aliq = '10' then      aliq := 'FF'
      else if cod_aliq = '11' then aliq := 'II'
      else if cod_aliq = '12' then aliq := 'NN';

      quant.setValor(dtmMain.IBQuery2.FieldByName('quant').AsCurrency);
      preco.setValor(dtmMain.IBQuery2.fieldbyname('p_venda').AsCurrency);
      total.setValor(Arredonda(dtmMain.IBQuery2.fieldbyname('p_venda').AsCurrency * quant.getValor, 2));

      //TotTributos := TotTributos + (((dtmMain.IBQuery2.FieldByName('venda').AsCurrency - dtmMain.IBQuery2.FieldByName('compra').AsCurrency) * dtmMain.IBQuery2.FieldByName('quant').AsCurrency) * (StrToCurrDef(form1.pgerais.Values['40'], 100) / 100));
      TotTributos := TotTributos + VE_IMPOSTO(dtmMain.IBQuery2.FieldByName('compra').AsCurrency, dtmMain.IBQuery2.FieldByName('venda').AsCurrency, dtmMain.IBQuery2.FieldByName('quant').AsCurrency);

      PainelProduto.Caption := dtmMain.IBQuery2.fieldbyname('nome').AsString;

      tot_ge := tot_ge + Arredonda(dtmMain.IBQuery2.fieldbyname('p_venda').AsCurrency * dtmMain.IBQuery2.FieldByName('quant').AsCurrency, 2);
      //totalOrigi
      IBClientDataSet1.Append;
      IBClientDataSet1.FieldByName('codbar').AsString  := dtmMain.IBQuery2.fieldbyname('codbar').AsString;
      IBClientDataSet1.FieldByName('cod').AsString     := dtmMain.IBQuery2.fieldbyname('cod').AsString;
      IBClientDataSet1.FieldByName('nome').AsString    := copy(dtmMain.IBQuery2.fieldbyname('nome').AsString, 1, 40);
      IBClientDataSet1.FieldByName('preco').AsCurrency := dtmMain.IBQuery2.fieldbyname('p_venda').AsCurrency;
      IBClientDataSet1.FieldByName('quant').AsCurrency := quant.getValor;
      IBClientDataSet1.FieldByName('total').AsCurrency := Arredonda(dtmMain.IBQuery2.fieldbyname('p_venda').AsCurrency * dtmMain.IBQuery2.FieldByName('quant').AsCurrency, 2);
      IBClientDataSet1.FieldByName('totalOrigi').AsCurrency := IBClientDataSet1.FieldByName('total').AsCurrency;
      IBClientDataSet1.Post;
      IBClientDataSet1.Last;

      vendeVISUAL();

      PainelTotal.Caption := formataCurrency(tot_ge);

      dtmMain.IBQuery2.Next;
    end;

  finally
    tecladoOK := true;
  end;

  //tot_ge   := tot_ge dtmMain.IBQuery1.fieldbyname('total').AsCurrency;
  recebido := 0;
  desconto := dtmMain.IBQuery1.fieldbyname('desconto').AsCurrency;
  tot_ge   := tot_ge + desconto;
  except
    on e:exception do
      begin
        MessageDlg('Erro: ' + e.Message, mtError, [mbOK], 1);
        exit;
      end;
  end;

  if buscaClienteCompleto = 1 then exit;

  dav := true;
  fechaDav();
end;

procedure TForm3.mostraTroco();
var
  troc : currency;
begin
  if recebido - tot_ge <> 0 then
    begin
      PainelTotal.Caption := formataCurrency(recebido - tot_ge);
      Panel4.Caption      := 'TROCO';
    end;
end;

procedure TForm3.lancaDesconto(var desc1, tot_g : currency; ConfigUsuario, tipoDesc, acessoUsu : String; precoDefault : currency = 0; CalcularMinimoPrecoTotalOriginal : currency = 0);
var
  temp2, temp1, total31, minimo : currency;
  fim,desc : string;
begin
  minimo := IfThen(CalcularMinimoPrecoTotalOriginal <> 0, CalcularMinimoPrecoTotalOriginal, tot_g)
   - Arredonda(((IfThen(CalcularMinimoPrecoTotalOriginal <> 0, CalcularMinimoPrecoTotalOriginal, tot_g) * StrToCurr(LerConfig(Configu,0)))/100),2);
  ///desc1  := 0;

  if ((tipoDesc = '') or (tipoDesc = 'X')) then tipoDesc := 'S';

  if tipoDesc = 'S' then
    begin
      fim := '-999999';
      while true do// ((StrToCurr(fim) < minimo) or not(StrToCurr(fim) > tot_g)) do
        begin
          //dialogoG('numero', 0, '', 2, false, '', 'PDV - ControlW', 'Informe o Valor do Desconto:', '0,00', true);
          fim := dialogoG('numero',0,'', 2,false,'','Control for Windows:','Confirme o Valor Total (Mínimo '+FormatCurr('#,###,###0.00',minimo)+'):', FormatCurr('###,##0.00', IfThen(precoDefault <> 0,precoDefault, tot_g)), true);
          if fim = '*' then
            begin
              fim := CurrToStr(tot_g);
              break;
            end;

          temp1 := StrToCurrDef(fim, 0);
          if (Arredonda(tot_g, 2) = Arredonda(temp1, 2)) then
            begin
              break;
            end;

          if (((temp1 >= minimo) and (temp1 <= tot_g)) or (tot_g = temp1)) then
            begin
              break;
            end;

          if ((temp1 < minimo) and (length(acessoUsu) = 0)) then  break;
        end;

    desc1  := tot_g - StrToCurr(fim);
    tot_g := StrToCurr(fim);

    exit;
  end
 else if tipoDesc = 'N' then
   begin
     //verifica se foi dado desconto por item
     temp1 := StrToCurrDef(LerConfig(ConfigUsuario,0), 0);

     desc := '99999999';
     while StrToCurr(desc) > temp1 do
       begin
         desc := dialogoG('numero',0,'',2,false,'','Control for Windows:','Qual o Percentual de Desconto (Máximo='+ FormatCurr('#,###,###0.00', temp1) +'%) (%)?:','0,00', true);
         if desc = '*' then
           begin
             desc := '0';
             break;
           end;

         if (StrToCurrDef(desc, 0) = temp1) then break;
         if ((StrToCurr(desc) > StrToCurr(LerConfig(ConfigUsuario,0))) and (length(acessoUsu) = 0)) then break;
    end;

  desc1 := Arredonda((tot_g * StrToCurr(desc))/100,2);
  tot_g := tot_g - desc1;
  end;
{ else if ConfParamGerais.Strings[2] = 'X' then
   begin
     temp1 := StrToCurrDef(funcoes.LerConfig(form22.Pgerais.Values['configu'],0), 0);
     desc := '99999999';

     while StrToCurr(desc) > temp1 do
       begin
         desc := funcoes.ConverteNumerico(funcoes.dialogo('numero',0,'1234567890,.'+#8,0,false,'ok','Control for Windows:','Qual o Percentual de Desconto (Máximo='+ FormatCurr('#,###,###0.00', temp1) +'%) (%)?:','0,00'));
         if desc = '*' then
            begin
              desc := '0';
              Break;
            end;
         if (StrToCurrDef(desc, 0) = temp1) then break;
         if ((StrToCurr(desc) = StrToCurr(funcoes.LerConfig(form22.Pgerais.Values['configu'],0))) or (VerificaAcesso_Se_Nao_tiver_Nenhum_bloqueio_true_senao_false)) then break;
       end;

      desconto := Arredonda((total1 * StrToCurr(desc))/100,2);
      total1 := total1 - desconto;
      if StrToCurrDef(desc, 0) <> 0 then
        begin
          fim := '-999999';
          while true do //((StrToCurr(fim) < minimo) or not(StrToCurr(fim) > total1)) do
            begin
              fim := funcoes.ConverteNumerico(funcoes.dialogo('numero',0,'1234567890,.'+#8,0,false,'ok','Control for Windows:','Confirme o Valor Total (Mínimo '+FormatCurr('#,###,###0.00',minimo)+'):',FormatCurr('###,##0.00',total1)));

              if fim = '*' then
                begin
                  fim := CurrToStr(total1);
                  break;
                end;
              temp1 := StrToCurrDef(fim, 1);
              if ((temp1 >= minimo) and (temp1 <= total1)) then break;
              if ((StrToCurr(fim) < minimo) or (VerificaAcesso_Se_Nao_tiver_Nenhum_bloqueio_true_senao_false)) then  break;
            end;
        end
      else fim := CurrToStr(total1);

      desconto := desconto + (total1 - StrToCurr(fim));
      total1 := StrToCurr(fim);
      desco.Caption := iif(desconto < 0, 'Acres', 'Desc')+' R$ '+FormatCurr('#,###,###0.00',desconto)+' R$ '+FormatCurr('#,###,###0.00', total1);

      mostraDesconto(total31, desconto, true);
    exit;
 end;
}
end;


procedure TForm3.limpaVenda();
begin
  codCliente := '';
  RichEdit1.Clear;
  IBClientDataSet1.EmptyDataSet;
  quant.Text := '1,000';
  preco.Text := '0,00';
  total.Text := '0,00';
  codbar.Text := '';
  codbar.SetFocus;
  tot_ge   := 0;
  TotTributos := 0;
  desconto := 0;
  descontoItens := 0;
  recebido := 0;
  entrada  := 0;
  cupomAberto1 := false;

  configu        := form1.configu;
  acessoUsuVenda := form1.acesso;
  formasP.Clear;
end;

procedure TForm3.verProdutos();
begin
  busca(tibquery(IBClientDataSet1), '', 'RET01', '', '');
end;

function TForm3.gravaVenda(cancelado : boolean = false) : boolean;
begin
  Result := false;

  try
  try
     if dtmMain.IBQuery1.Transaction.InTransaction then dtmMain.IBQuery1.Transaction.Commit;
     dtmMain.IBQuery1.Transaction.StartTransaction;
  except
    on e:exception do
      begin
        gravaERRO_LOG('', e.Message, 'Gravando Venda: ' + #13 + 'Nota: ' + StrNum(nota_venda)
        + #13 + 'Total: ' + CurrToStr(tot_ge) + #13 );
      end;
  end;

  try
  nota_venda := Incrementa_Generator('venda', 1);

  dtmMain.IBQuery1.Close;
  dtmMain.IBQuery1.SQL.Clear;
  dtmMain.IBQuery1.SQL.Add('insert into venda(ok,hora,vendedor,cliente,nota,data,total,codhis,desconto,prazo,entrada, EXPORTADO, USUARIO, cancelado, entrega)'+
  ' values(:ok,:hora,:vend,:cliente,:nota,:data,:total,:pagto,:desc,:prazo,:entrada, :exportado, :USUARIO, :cancelado, ''E'')');
  dtmMain.IBQuery1.ParamByName('ok').AsString          := 'S';
  dtmMain.IBQuery1.ParamByName('hora').AsTime          := now;
  dtmMain.IBQuery1.ParamByName('vend').AsInteger       := StrToIntDef(StrNum(CodVendedorTemp), 0);
  dtmMain.IBQuery1.ParamByName('cliente').AsInteger    := 0;
  dtmMain.IBQuery1.ParamByName('nota').AsInteger       := StrToIntDef(StrNum(nota_venda), 0);
  dtmMain.IBQuery1.ParamByName('data').AsDateTime      := now;
  dtmMain.IBQuery1.ParamByName('total').AsCurrency     := tot_ge;
  dtmMain.IBQuery1.ParamByName('pagto').AsInteger      := StrToIntDef(StrNum(codhis), 1);
  dtmMain.IBQuery1.ParamByName('desc').AsCurrency      := desconto;                                                                             //'+codhis+'
  dtmMain.IBQuery1.ParamByName('prazo').AsInteger      := 0;
  dtmMain.IBQuery1.ParamByName('entrada').AsCurrency   := entrada;
  dtmMain.IBQuery1.ParamByName('exportado').AsInteger  := 0;
  dtmMain.IBQuery1.ParamByName('USUARIO').AsInteger    := StrToIntDef(StrNum(form1.codUsuario), 0);
  dtmMain.IBQuery1.ParamByName('cancelado').AsInteger  := IfThen(cancelado ,StrToIntDef(StrNum(form1.codUsuario), 1), 0);


    dtmMain.IBQuery1.ExecSQL;
  except
    on e:exception do
      begin
        gravaERRO_LOG('', e.Message, 'Gravando Venda: ' + #13 + 'Nota: ' + StrNum(nota_venda)
        + #13 + 'Total: ' + CurrToStr(tot_ge) + #13 );
      end;
  end;

  IBClientDataSet1.First;
  while not IBClientDataSet1.Eof do
    begin
      //cod := ClientDataSet1CODIGO.AsString;

      if not Contido('** CANCELADO **', IBClientDataSet1nome.AsString) then
        begin
          try
            dtmMain.IBQuery2.Close;
            dtmMain.IBQuery2.SQL.Clear;
            dtmMain.IBQuery2.SQL.Add('select p_compra, aliquota, unid, codbar from produto where cod = '+StrNum(IBClientDataSet1cod.AsString));
            dtmMain.IBQuery2.Open;
            
          dtmMain.IBQuery1.Close;
          dtmMain.IBQuery1.SQL.Clear;
          dtmMain.IBQuery1.SQL.Add('insert into item_venda(data,nota,COD, QUANT, p_venda,total,origem,p_compra,codbar,aliquota, unid)'+
          ' values(:data,'+StrNum(nota_venda)+',:cod, :quant, :p_venda,:total,1,:p_compra, :codbar,:aliq, :unid)');
          dtmMain.IBQuery1.ParamByName('data').AsDateTime    := now;
          dtmMain.IBQuery1.ParamByName('cod').AsInteger      := IBClientDataSet1.fieldbyname('cod').AsInteger;
          dtmMain.IBQuery1.ParamByName('quant').AsCurrency   := IBClientDataSet1.fieldbyname('quant').AsCurrency;
          dtmMain.IBQuery1.ParamByName('p_venda').AsCurrency := IBClientDataSet1.fieldbyname('preco').AsCurrency;
          dtmMain.IBQuery1.ParamByName('total').AsCurrency   := IBClientDataSet1.fieldbyname('total').AsCurrency;
          dtmMain.IBQuery1.ParamByName('p_compra').AsCurrency := Arredonda(IBClientDataSet1.fieldbyname('quant').AsCurrency * dtmMain.IBQuery2.fieldbyname('p_compra').AsCurrency,2);
          dtmMain.IBQuery1.ParamByName('codbar').AsString     := dtmMain.IBQuery2.fieldbyname('codbar').AsString;
          dtmMain.IBQuery1.ParamByName('aliq').AsString       := copy(dtmMain.IBQuery2.fieldbyname('aliquota').AsString,1 ,2);
          IF StrToIntDef(dtmMain.IBQuery1.ParamByName('aliq').AsString, 0) = 0 THEN dtmMain.IBQuery1.ParamByName('aliq').AsString := '2';
          dtmMain.IBQuery1.ParamByName('unid').AsString       := copy(dtmMain.IBQuery2.fieldbyname('unid').AsString,1,6);
          dtmMain.IBQuery2.Close;

            dtmMain.IBQuery1.ExecSQL;
          except
            on e:exception do
              begin
                gravaERRO_LOG('', e.Message, 'Gravando Item_venda: ' + #13 + 'Cod: ' + StrNum(IBClientDataSet1cod.AsString)
                + #13 + 'Quant: ' + IBClientDataSet1quant.AsString + #13 );
              end;
          end;

          try
          dtmMain.IBQuery1.Close;
          dtmMain.IBQuery1.SQL.Text := 'update produto set quant = quant - :quant where cod = :cod';
          dtmMain.IBQuery1.ParamByName('quant').AsCurrency := IBClientDataSet1.fieldbyname('quant').AsCurrency;
          dtmMain.IBQuery1.ParamByName('cod').AsInteger    := IBClientDataSet1.fieldbyname('cod').AsInteger;
            dtmMain.IBQuery1.ExecSQL;
          except
            on e:exception do
              begin
                gravaERRO_LOG('', e.Message, 'Update Produto: ' + #13 + 'Cod: ' + StrNum(IBClientDataSet1cod.AsString)
                + #13 + 'Quant: ' + IBClientDataSet1quant.AsString + #13 );
              end;
          end;
        end;
        
      IBClientDataSet1.Next;
    end;

  if dtmMain.IBQuery1.Transaction.InTransaction then dtmMain.IBQuery1.Transaction.Commit;
  Result := true;
  Except
    on e : exception do
      begin
        MessageDlg('Erro: ' + e.Message, mtError, [mbOK], 1);
        dtmMain.IBQuery1.Transaction.Rollback;
        exit;
      end;
  end;
end;

function TForm3.gravaVenda1(cancelado : boolean = false) : boolean;
begin
  Result := false;

  try
  if dtmMain.IBQuery1.Transaction.InTransaction then dtmMain.IBQuery1.Transaction.Commit;
  dtmMain.IBQuery1.Transaction.StartTransaction;

  nota_venda := Incrementa_Generator('venda', 1);

  dtmMain.IBQuery1.Close;
  dtmMain.IBQuery1.SQL.Clear;
  dtmMain.IBQuery1.SQL.Add('insert into venda(entrega,crc,ok,hora,vendedor,cliente,nota,data,total,codhis,desconto,prazo,entrada, EXPORTADO, USUARIO, cancelado)'+
  ' values(:entrega,:crc,:ok,:hora,:vend,:cliente,:nota,:data,:total,:pagto,:desc,:prazo,:entrada, :exportado, :USUARIO, :cancelado)');
  dtmMain.IBQuery1.ParamByName('entrega').AsString     := 'E';
  dtmMain.IBQuery1.ParamByName('crc').AsString         := '000000' + strzero(getSerieNFCe, 3);
  dtmMain.IBQuery1.ParamByName('ok').AsString          := 'S';
  dtmMain.IBQuery1.ParamByName('hora').AsTime          := now;
  dtmMain.IBQuery1.ParamByName('vend').AsInteger       := StrToIntDef(StrNum(CodVendedorTemp), 0);
  dtmMain.IBQuery1.ParamByName('cliente').AsInteger    := 0;
  dtmMain.IBQuery1.ParamByName('nota').AsInteger       := StrToIntDef(StrNum(nota_venda), 0);
  dtmMain.IBQuery1.ParamByName('data').AsDateTime      := now;
  dtmMain.IBQuery1.ParamByName('total').AsCurrency     := tot_ge;
  dtmMain.IBQuery1.ParamByName('pagto').AsInteger      := StrToIntDef(StrNum(codhis), 1);
  dtmMain.IBQuery1.ParamByName('desc').AsCurrency      := desconto;                                                                             //'+codhis+'
  dtmMain.IBQuery1.ParamByName('prazo').AsInteger      := 0;
  dtmMain.IBQuery1.ParamByName('entrada').AsCurrency   := entrada;
  dtmMain.IBQuery1.ParamByName('exportado').AsInteger  := 0;
  dtmMain.IBQuery1.ParamByName('USUARIO').AsInteger    := StrToIntDef(StrNum(form1.codUsuario), 0);
  dtmMain.IBQuery1.ParamByName('cancelado').AsInteger  := IfThen(cancelado ,StrToIntDef(StrNum(form1.codUsuario), 1), 0);

  try
    dtmMain.IBQuery1.ExecSQL;
  except
    on e:exception do
      begin
        gravaERRO_LOG('', e.Message, 'Gravando Venda: ' + #13 + 'Nota: ' + StrNum(nota_venda)
        + #13 + 'Total: ' + CurrToStr(tot_ge) + #13 );
      end;
    end;

  IBClientDataSet1.First;
  while not IBClientDataSet1.Eof do
    begin
      dtmMain.IBQuery1.Close;
      dtmMain.IBQuery1.SQL.Clear;
      dtmMain.IBQuery1.SQL.Add('insert into item_venda(data,nota,COD, QUANT, p_venda,total,origem,p_compra,codbar,aliquota, unid) values(:data,'+StrNum(nota_venda)+',:cod, :quant, :p_venda,:total,1,:p_compra, :codbar,:aliq, :unid)');
      dtmMain.IBQuery1.ParamByName('data').AsDateTime    := now;
      dtmMain.IBQuery1.ParamByName('cod').AsInteger      := IBClientDataSet1.fieldbyname('cod').AsInteger;
      dtmMain.IBQuery1.ParamByName('quant').AsCurrency   := IBClientDataSet1.fieldbyname('quant').AsCurrency;
      dtmMain.IBQuery1.ParamByName('p_venda').AsCurrency := IBClientDataSet1.fieldbyname('preco').AsCurrency;
      dtmMain.IBQuery1.ParamByName('total').AsCurrency   := IBClientDataSet1.fieldbyname('total').AsCurrency;

      dtmMain.IBQuery2.Close;
      dtmMain.IBQuery2.SQL.Clear;
      dtmMain.IBQuery2.SQL.Add('select p_compra, aliquota, unid, codbar from produto where cod = '+StrNum(IBClientDataSet1cod.AsString));
      dtmMain.IBQuery2.Open;

      dtmMain.IBQuery1.ParamByName('p_compra').AsCurrency := Arredonda(IBClientDataSet1.fieldbyname('quant').AsCurrency * dtmMain.IBQuery2.fieldbyname('p_compra').AsCurrency,2);
      dtmMain.IBQuery1.ParamByName('codbar').AsString     := dtmMain.IBQuery2.fieldbyname('codbar').AsString;
      dtmMain.IBQuery1.ParamByName('aliq').AsString       := copy(dtmMain.IBQuery2.fieldbyname('aliquota').AsString,1 ,2);
      dtmMain.IBQuery1.ParamByName('unid').AsString       := copy(dtmMain.IBQuery2.fieldbyname('unid').AsString,1,6);
      dtmMain.IBQuery2.Close;

      try
        dtmMain.IBQuery1.ExecSQL;
      except
        on e:exception do
          begin
            gravaERRO_LOG('', e.Message, 'Gravando Item_venda: ' + #13 + 'Cod: ' + StrNum(IBClientDataSet1cod.AsString)
            + #13 + 'Quant: ' + IBClientDataSet1quant.AsString + #13 );
          end;
      end;

      IBClientDataSet1.Next;
    end;

  if dtmMain.IBQuery1.Transaction.InTransaction then dtmMain.IBQuery1.Transaction.Commit;
  Result := true;
  Except
    on e : exception do
      begin
        MessageDlg('Erro: ' + e.Message, mtError, [mbOK], 1);
        dtmMain.IBQuery1.Transaction.Rollback;
        exit;
      end;
  end;
end;

procedure TForm3.encerrarVenda(dialogo1 : boolean = true);
var
  sim, indx, timeout  : integer;
  desc, receb, statu, moti, obs, crc, cli1 : String;
  totalTemp : currency;
  ok : boolean;
begin

  if IBClientDataSet1.IsEmpty then exit;
  if dialogo1 then
    begin
      sim := MessageBox(Handle, 'Deseja Finalizar a Venda?', 'PDV - ControlW' ,MB_YESNO + MB_ICONQUESTION + MB_DEFBUTTON1);
      if sim = idno then exit;
    end;

  tecladoOK := false;
  try
  tot_ge  := somaTotalOriginal(true);

  if tot_ge = 0 then
    begin
      tot_ge := somaTotalOriginal(true, false);
      gravaVenda1(true);
      limpaVenda;
      exit;
    end;

  tot1    := tot_ge;

  if form1.pgerais.Values['37'] = 'S' then
    begin
      totalTemp := somaTotalOriginal();
      lancaDesconto(desconto, tot_ge, configu, form1.pgerais.Values['2'], acessoUsuVenda, 0, totalTemp);
      desconto := - desconto;
    end;

  if buscaClienteCompleto = 1 then exit;
  desconto := desconto + descontoItens;

  if lerReceido() = false then exit;
  {aki leu as formas de pagamento e preencheu o clientdataset com as formas
  de pagamento e totais}

  lerFormasParaGravarAVendaPreencheEntrada;

  if formasPagamento.IsEmpty then exit;

  {cliente := dialogo('generico',0,'1234567890,.'+#8,50,false,'',Application.Title,'Qual o Código do Cliente?', codCliente);
  cliente := trim(cliente);

  if cliente = '0' then
    begin
      identificaCliente(codCliente);
      cliente := StrNum(codCliente);
    end;

  if cliente = '*' then exit;}

  cliente := codCliente;

  //obs := trim('Total Impostos Pagos R$' + formataCurrency(TotTributos) + '('+ formataCurrency((TotTributos / tot1) * 100) +'%)Fonte IBPT');

  mostraTroco();
  recebido1 := recebido;

  try
    abreGaveta;
  except
    on e:exception do
       begin
         MessageDlg('ERRO NA GAVETA!', mtError, [mbOK], 1);
         gravaERRO_LOG('', e.Message, 'abreGaveta Linha 812');
       end;
  end;

  try
  try
  if gravaVenda() then
    begin
      try
        tecladoOK := false;
        ok := enviNFCe(nota_venda, cliente);
      finally
        tecladoOK := true;
      end;
      if ok = false then
        begin
          MessageDlg('Ocorreu Um erro na Venda, Ela está Disponivel para Emissao no F9', mtInformation, [mbOK], 1);
          cancelaVenda(nota_venda, True);
          limpaVenda;
          Exit;
        end;
        
      //verificaNotasContigencia;
      Panel1.Caption := valCert + ' ' + vercCountContigencia;
    end
  else
    begin
      limpaVenda;
      exit;
    end;

  except
    on e:exception do
       begin
         gravaERRO_LOG('', e.Message, 'encerraVenda LINHA 836');
       end;
  end;

  finally
    limpaVenda;
    verificaDavNFCeTravado;
  end;
  finally
    tecladoOK := true;
  end;
end;

function TForm3.lerPesoBalanca() : currency;
var
  pastaControlw : String;
begin
  pastaControlw := ExtractFileDir(ParamStr(0)) + '\';
  try
    mostraMensagem('Aguarde, Lendo Balança...', true);
    dtmMain.ACBrBAL1.ArqLOG := pastaControlw + 'LOG_BAL.TXT';
    Result := 0;
    try
      if dtmMain.ACBrBAL1.Ativo then dtmMain.ACBrBAL1.Desativar;
      dtmMain.ACBrBAL1.Device.Baud := 2400;
      dtmMain.ACBrBAL1.Porta := 'COM3';
      dtmMain.ACBrBAL1.Ativar;
      Result := dtmMain.ACBrBAL1.LePeso();
    except
      on e:exception do
        begin
          ShowMessage('Erro: ' + e.Message);
        end;
    end;
    if Result > 0 then
      begin
        quant.Text := FormatCurr('#,###,###0.000', Result);
        mostraMensagem('Aguarde, Lendo Balança...', false);
        pastaControlw := 'OFF';

        if codbar.Text = '' then
          begin
            codbar.Text := localizar2('Localizar Produto','produto p','p.codbar, P.COD, p.nome,p.quant, p.p_venda as preco ','codbar','cod','nome','nome',false,false,false, ' where (p.codbar like ' + QuotedStr('2%') + ' )', IBClientDataSet1cod.AsString,600 , codbar);
            {if codbar.Text <> '' then
              begin
                dtmMain.IBQuery1.Close;
                dtmMain.IBQuery1.SQL.Text := 'select codbar from produto where cod = :cod';
                dtmMain.IBQuery1.ParamByName('cod').AsInteger := StrToIntDef(codbar.Text, 0);
                dtmMain.IBQuery1.Open;
                codbar.Text := dtmMain.IBQuery1.fieldbyname('codbar').AsString;
                dtmMain.IBQuery1.Close;
              end;}
          end;
      end;
  finally
    if pastaControlw <> 'OFF' then mostraMensagem('Aguarde, Lendo Balança...', false);
  end;
end;


procedure TForm3.vendeVISUAL();
var
  i, fim : integer;
begin
  //IBClientDataSet1.Last;

  if RichEdit1.Items.Count = 0 then
    begin
      RichEdit1.Items.Add(CompletaOuRepete('', '', '-', 50));
      RichEdit1.Items.Add(centraliza(trim(form1.pgerais.Values['empresa']), ' ', 50));
      RichEdit1.Items.Add(CompletaOuRepete('', '', '-', 50));

      Panel4.Caption := 'TOTAL';
    end;

  RichEdit1.Items.Add(CompletaOuRepete('', IntToStr(IBClientDataSet1.RecNo), '0', 3) + '-' + CompletaOuRepete(IBClientDataSet1codbar.AsString, '', ' ', 15) + '  ' +CompletaOuRepete(copy(IBClientDataSet1nome.AsString, 1, 30), '', ' ', 30));
  RichEdit1.Items.Add(CompletaOuRepete('QTD => '+FormatCurr('#,###,###0.000',IBClientDataSet1.fieldbyname('quant').AsCurrency), '', ' ', 16) + CompletaOuRepete(' R$ '+formatacurrency(IBClientDataSet1preco.AsCurrency), '', ' ', 16) + CompletaOuRepete(' Total => '+formatacurrency(IBClientDataSet1total.AsCurrency), '', ' ', 20));

  SendMessage(RichEdit1.Handle, WM_VSCROLL, SB_BOTTOM, 0);

  i := RichEdit1.Items.Count -1;
  RichEdit1.Selected[i]    := true;
  RichEdit1.Selected[i -1] := true;

  RichEdit1.Selected[i - 3] := false;
  RichEdit1.Selected[i - 2] := false;

  //RichEdit1.SelectAll;
end;

procedure TForm3.vendeItem();
var
  aliq, cod_aliq, cbar : string;
  cont : integer;
  prodcodbar : TprodutoVendaCodBar;
  pesquisaCodbar : boolean;
begin
  if codbar.Text = '' then exit;

  cbar := codbar.Text;
  //a variavel abaixo diz se vai pesquisa por codbar
  //se estiver false pesquisa pelo codigo
  pesquisaCodbar := true;

  if ((LeftStr(cbar, 1) = '2') and (Length(cbar) < 13) and (balOnline) and (vendeuf2 = false)) then
    begin
      abreLocalizaPesagem := false;
      Button1Click(self);
      if utiLeituraBalanca < 0  then exit;
    end;

  if ((LeftStr(cbar, 1) = '2') and (Length(cbar) = 13) and (dtmMain.ACBrBAL1.Modelo <> balnenhum)) then
    begin
      prodcodbar     := le_codbar(dtmMain.IBQuery2, cbar, form1.pgerais.Values['38']);
      if prodcodbar.codbar = '*' then
        begin
          ShowMessage('Produto não Encontrado*992*');
          prodcodbar.Free;
          exit;
        end;

      pesquisaCodbar := false;
    end;

  if pesquisaCodbar then
    begin
      dtmMain.IBQuery2.Close;
      dtmMain.IBQuery2.SQL.Text := ('select p.cod, p.nome, p.p_compra, p.p_venda, p.codbar, a.aliq, a.cod as cod1 from produto p '+
      ' left join aliq a on (a.cod = iif(trim(p.aliquota) = '''', 2, cast(p.aliquota as integer))) where  (p.codbar = '+QuotedStr( cbar )+')');
      dtmMain.IBQuery2.Open;
    end
  else
    begin
      dtmMain.IBQuery2.Close;
      dtmMain.IBQuery2.SQL.Text := ('select p.cod, p.p_compra, p.nome, p.p_venda, p.codbar, a.aliq, a.cod as cod1 from produto p left join codbarras c on (c.cod = p.cod)'+
      //' left join aliq a on (a.cod = iif(trim(p.aliquota) = '''', 2, cast(p.aliquota as integer))) where (p.codbar = '+ prodcodbar.codbar+')');
      ' left join aliq a on (a.cod = iif(trim(p.aliquota) = '''', 2, cast(p.aliquota as integer))) where (p.codbar = :cod)');
      dtmMain.IBQuery2.ParamByName('cod').AsString := prodcodbar.codbar;
      dtmMain.IBQuery2.Open;

      quant.Text := FormatCurr('#,###,###0.000', prodcodbar.quant);
    end;

  if dtmMain.IBQuery1.IsEmpty then
    begin
      dtmMain.IBQuery1.Close;
      ShowMessage('Produto Não Encontrado');
      codbar.Text := '';
      exit;
    end;

  preco.setValor(dtmMain.IBQuery1.fieldbyname('p_venda').AsCurrency);
  total.setValor(Arredonda(dtmMain.IBQuery1.fieldbyname('p_venda').AsCurrency * quant.getValor, 2));

  cont := IBClientDataSet1.RecordCount + 1;
  IBClientDataSet1.Append;
  IBClientDataSet1.FieldByName('contador').AsInteger := cont;
  IBClientDataSet1.FieldByName('codbar').AsString    := codbar.Text;
  IBClientDataSet1.FieldByName('cod').AsString       := dtmMain.IBQuery1.fieldbyname('cod').AsString;
  IBClientDataSet1.FieldByName('nome').AsString      := copy(dtmMain.IBQuery1.fieldbyname('nome').AsString, 1, 40);
  IBClientDataSet1.FieldByName('preco').AsCurrency   := dtmMain.IBQuery1.fieldbyname('p_venda').AsCurrency;
  IBClientDataSet1.FieldByName('precoOrigi').AsCurrency   := dtmMain.IBQuery1.fieldbyname('p_venda').AsCurrency;
  IBClientDataSet1.FieldByName('quant').AsCurrency   := quant.getValor;
  IBClientDataSet1.FieldByName('total').AsCurrency   := Arredonda(dtmMain.IBQuery1.fieldbyname('p_venda').AsCurrency * quant.getValor, 2);
  IBClientDataSet1.FieldByName('totalOrigi').AsCurrency := IBClientDataSet1.FieldByName('total').AsCurrency;
  IBClientDataSet1.Post;
  IBClientDataSet1.Last;

  tot_ge := tot_ge + IBClientDataSet1total.AsCurrency;

  PainelProduto.Caption := dtmMain.IBQuery1.fieldbyname('nome').AsString;

  cod_aliq := dtmMain.IBQuery1.fieldbyname('cod1').AsString;
  aliq     := Trim(dtmMain.IBQuery1.fieldbyname('aliq').AsString);
  if aliq = '' then aliq := '17,00';

  if cod_aliq = '10' then aliq := 'FF'
  else if cod_aliq = '11' then aliq := 'II'
  else if cod_aliq = '12' then aliq := 'NN';

  TotTributos := TotTributos + (IBClientDataSet1.FieldByName('total').AsCurrency * (StrToCurrDef(aliq, 0) / 100));
  vendeVISUAL();

  dtmMain.IBQuery1.Close;

  //PainelTotal.Caption := FormatCurr('#,###,###0.00', tot_ge); //FormatCurr('#,###,###0.00', StrToCurr(IBClientDataSet1p_total.AsString));

  codbar.Text := '';
  quant.Text := '1,000';
end;

procedure TForm3.vendeItemFila(const codbar1 : string);
var
  aliq, cod_aliq, cbar, VEND, preco1, qutd  : string;
  cont : integer;
  prec : currency;
  prodcodbar : TprodutoVendaCodBar;
  pesquisaCodbar : boolean;
begin
  if trim(form1.pgerais.Values['38']) = '' then form1.pgerais.Values['38'] := '1';
  //tipo de leitura de codigo de barras 1-preco total 2-quantidade 3-nenhum

  if ((quant.getValor > 20000) or (quant.getValor <= 0)) then
    begin
      MessageDlg('Quantidade Inválida!', mtError, [mbOK], 1);
      quant.SetFocus;
      exit;
    end;

  try
  vendendoECF := true;
  cbar := codbar1;
  if cbar = '' then exit;
  //a variavel abaixo diz se vai pesquisa por codbar
  //se estiver false pesquisa pelo codigo
  pesquisaCodbar := true;


  if ((LeftStr(cbar, 1) = '2') and (Length(cbar) = 5) and (balOnline) and (vendeuf2 = false)) then
    begin
      abreLocalizaPesagem := false;
      Button1Click(self);

      if codTemp = '*' then exit;

      if utiLeituraBalanca < 0  then exit;
    end;

  if ((LeftStr(cbar, 1) = '2') and (Length(cbar) = 13) and (dtmMain.ACBrBAL1.Modelo <> balnenhum) and (form1.pgerais.Values['38'] <> '3')) then
  //if ((LeftStr(cbar, 1) = '2') and (Length(cbar) = 13) and (dtmMain.ACBrBAL1.Modelo <> balnenhum)) then
    begin
      prodcodbar     := le_codbar1(dtmMain.IBQuery2, cbar, form1.pgerais.Values['38']);

      if prodcodbar.codbar <> '*' then
        begin
          pesquisaCodbar := false;
        end
    end;

  if pesquisaCodbar then
    begin
      dtmMain.IBQuery2.Close;
      if length(cbar) = 5 then
        begin
          dtmMain.IBQuery2.SQL.Text := ('select p.cod, p.nome, p.p_compra, p.p_venda, p.codbar, a.aliq, a.cod as cod1 from produto p '+
          ' left join aliq a on (a.cod = iif(trim(p.aliquota) = '''', 2, cast(p.aliquota as integer))) where  (left(p.codbar, 5) = :cbar)');
        end
      else
        begin
          dtmMain.IBQuery2.SQL.Text := ('select p.cod, p.nome, p.p_compra, p.p_venda, p.codbar, a.aliq, a.cod as cod1 from produto p '+
          ' left join aliq a on (a.cod = iif(trim(p.aliquota) = '''', 2, cast(p.aliquota as integer))) where  (p.codbar = :cbar)');
        end;
        
      dtmMain.IBQuery2.ParamByName('cbar').AsString := cbar;
      dtmMain.IBQuery2.Open;
    end
  else
    begin
      dtmMain.IBQuery2.Close;
      dtmMain.IBQuery2.SQL.Text := ('select p.cod, p.p_compra, p.nome, p.p_venda, p.codbar, a.aliq, a.cod as cod1 from produto p '+
      ' left join aliq a on (a.cod = iif(trim(p.aliquota) = '''', 2, cast(p.aliquota as integer))) where (substring(codbar from 1 for 5) = :cod)');
      dtmMain.IBQuery2.ParamByName('cod').AsString := prodcodbar.codbar;
      dtmMain.IBQuery2.Open;

      quant.Text := FormatCurr('#,###,###0.000', prodcodbar.quant);
    end;

  if dtmMain.IBQuery2.IsEmpty then
    begin
      dtmMain.IBQuery2.Close;
      ShowMessage('Produto Não EncontradoA');
      exit;
    end;

  if dtmMain.IBQuery2.fieldbyname('p_venda').AsCurrency = 0 then
    begin
      vendendoECF := false;
      MessageDlg('O Preço do Produto '+ copy(dtmMain.IBQuery2.fieldbyname('nome').AsString, 1, 40) +' pode ser 0', mtError, [mbOK], 1);
      exit;
    end;


  prec := buscaPreco(dtmMain.IBQuery2.fieldbyname('cod').AsInteger, quant.getValor);
  qutd := currtostr(quant.getValor);
  preco1 := currtostr(prec);
  preco.setValor(prec);
  preco1 := confirmaPrecoProduto(dtmMain.IBQuery2.fieldbyname('cod').Asstring, qutd, preco1, 1, false);
  if preco1 = '*' then exit;
  
  prec := strtocurr(preco1);

  preco.setValor(prec);
  total.setValor(Arredonda(prec * quant.getValor, 2));

  if IBClientDataSet1.RecordCount = 0 then
    begin
      if tudoOK_para_emitir_NFCe = false then exit;

      if form1.vendedor = '0' then
        begin
          while true do
            begin
              VEND := '';
              IF Length(trim(CodVendedorTemp)) > 0 then
                begin
                  VEND := 'cod';
                end;

              CodVendedorTemp := localizar1('Localizar Vendedor','vendedor','cod,nome','cod','','nome','nome',false,false,false,vend, IfThen(StrNum(CodVendedorTemp) = '0', '', StrNum(CodVendedorTemp)), 300,nil);
              if CodVendedorTemp = '*' then exit;
              if StrNum(CodVendedorTemp) <> '0' then
                begin
                  dtmMain.IBQuery1.Close;
                  dtmMain.IBQuery1.SQL.Text := 'select cod,nome from vendedor where cod = :cod';
                  dtmMain.IBQuery1.ParamByName('cod').AsString := CodVendedorTemp;
                  dtmMain.IBQuery1.Open;

                  if not dtmMain.IBQuery1.IsEmpty then
                    begin
                      vendedor := dtmMain.IBQuery1.fieldbyname('cod').AsString + ' - ' + dtmMain.IBQuery1.fieldbyname('nome').AsString;
                    end
                  else vendedor := '';
                  dtmMain.IBQuery1.Close;

                  Panel1.Caption := valCert + ' ' + vendedor;
                  Break;
                end;
            end;
        end;
    end;

  cont := IBClientDataSet1.RecordCount + 1;
  IBClientDataSet1.Append;
  IBClientDataSet1.FieldByName('contador').AsInteger := cont;
  IBClientDataSet1.FieldByName('codbar').AsString    := cbar;
  IBClientDataSet1.FieldByName('cod').AsString       := dtmMain.IBQuery2.fieldbyname('cod').AsString;
  IBClientDataSet1.FieldByName('nome').AsString      := copy(dtmMain.IBQuery2.fieldbyname('nome').AsString, 1, 40);
  IBClientDataSet1.FieldByName('preco').AsCurrency   := prec;
  IBClientDataSet1.FieldByName('precoOrigi').AsCurrency   := prec;
  IBClientDataSet1.FieldByName('quant').AsCurrency   := quant.getValor;
  //IBClientDataSet1.FieldByName('total').AsCurrency   := IfThen(pesquisaCodbar = false ,prodcodbar.precoTemp, arredonda(dtmMain.IBQuery2.fieldbyname('p_venda').AsCurrency * quant.getValor, 2));
  IBClientDataSet1.FieldByName('total').AsCurrency   := total.getValor;
  IBClientDataSet1.FieldByName('totalOrigi').AsCurrency := IBClientDataSet1.FieldByName('total').AsCurrency;
  IBClientDataSet1.Post;
  IBClientDataSet1.Last;

  tot_ge := tot_ge + IBClientDataSet1total.AsCurrency;
  if not pesquisaCodbar then
    begin
      prodcodbar.Free;
    end;

  PainelProduto.Caption := dtmMain.IBQuery2.fieldbyname('nome').AsString;

  cod_aliq := dtmMain.IBQuery2.fieldbyname('cod1').AsString;
  aliq     := Trim(dtmMain.IBQuery2.fieldbyname('aliq').AsString);
  if aliq = '' then aliq := '17,00';

  if cod_aliq = '10' then aliq := 'FF'
  else if cod_aliq = '11' then aliq := 'II'
  else if cod_aliq = '12' then aliq := 'NN';

  try
  except
    on e:exception do
      begin
        MessageDlg(e.Message, mtError, [mbOK], 0);
        IBClientDataSet1.Delete;
        exit;
      end;
  end;

  //TotTributos := TotTributos + (((dtmMain.IBQuery2.FieldByName('p_venda').AsCurrency - dtmMain.IBQuery2.FieldByName('p_compra').AsCurrency) * IBClientDataSet1.FieldByName('quant').AsCurrency) * (StrToCurrDef(form1.pgerais.Values['40'], 100) / 100));
  TotTributos := TotTributos + VE_IMPOSTO(dtmMain.IBQuery2.FieldByName('p_compra').AsCurrency, dtmMain.IBQuery2.FieldByName('p_venda').AsCurrency, IBClientDataSet1.FieldByName('quant').AsCurrency);
 
  vendeVISUAL();
  vendeuf2 := false;

  dtmMain.IBQuery2.Close;

  //PainelTotal.Caption := FormatCurr('#,###,###0.00', tot_ge); //FormatCurr('#,###,###0.00', StrToCurr(IBClientDataSet1p_total.AsString));

  codbar.Text := '';
  quant.Text := '1,000';
  finally
    vendendoECF := false;
  end;
end;

procedure tform3.alinhaComponentes();
var
  wi, he, tmp1 : integer;
begin
  wi := Screen.Width;
  he := Screen.Height;

  if (wi >= 800) and (wi <= 1024) then
    begin
      PainelProduto.Font.Size := 20;
    end;
  //PainelProduto.Left := trunc((wi/2) - (PainelProduto.Width /2));
  tmp1 := trunc( wi * 0.1);
  PainelProduto.Width := wi - tmp1;
  tmp1 := trunc(tmp1 / 2);
  PainelProduto.Left := tmp1;

  PainelTotal.Left := quant.Left;

  PainelTotal.Top   := he - PainelTotal.Height - 20;
  PainelTotal.Width := quant.Width;


  Panel2.Top      := he - Panel2.Height - 20;

  Panel2.Left  := (PainelTotal.Left + PainelTotal.Width) + 10;
  Panel2.Width := (wi - Panel2.Left) - 20;

  RichEdit1.Left := (wi - RichEdit1.Width) - 30;
      if RichEdit1.Left < (codbar.Left + codbar.Width) then
        begin
          tmp1 := wi - (codbar.Left + codbar.Width) -30;
          RichEdit1.Width := tmp1;
          RichEdit1.Left := (wi - RichEdit1.Width) - 15;
          RichEdit1.Font.Size := RichEdit1.Font.Size - 3;
        end;

      if Panel2.Top < (RichEdit1.Top + RichEdit1.Height) then
        begin
          RichEdit1.Height := (Panel2.Top - RichEdit1.Top) - 15;
        end;

      if PainelTotal.Top < (total.Top + total.Height) then
        begin
          LabelCodBar.Top := PainelProduto.Top + PainelProduto.Height + 7;
          codbar.Top      := LabelCodBar.Top + LabelCodBar.Height + 3;

          LabelQuantidade.Top := codbar.Top + codbar.Height + 7;
          quant.Top := LabelQuantidade.Top + LabelQuantidade.Height + 3;

          labelpreco.Top := quant.Top + quant.Height + 7;
          preco.Top      := labelpreco.Top + labelpreco.Height + 3;

          LabelTotal.Top := preco.Top + preco.Height + 7;
          total.Top      := LabelTotal.Top + LabelTotal.Height + 3;

          PainelTotal.Top := he - PainelTotal.Height - 5;
          PainelTotal.Font.Size := PainelTotal.Font.Size - 8;
        end;

  PainelTotal.Font.Size := PainelTotal.Font.Size - 8;

  Panel4.Width := PainelTotal.Width;
  Panel4.Top := PainelTotal.Top - Panel4.Height;
  Panel4.Left := PainelTotal.Left;

  codbar.Top  := LabelCodBar.Top + LabelCodBar.Height;
  codbar.Left := LabelCodBar.Left;
  codbar.Width := quant.Width;

  RichEdit1.Top := PainelProduto.Top + PainelProduto.Height + 10;

  PainelCaixa.Top    := RichEdit1.Top + RichEdit1.Height - Panel1.Height - 10;
  PainelCaixa.Left   := RichEdit1.Left;
  PainelCaixa.Width  := RichEdit1.Width;
  PainelCaixa.Height := Panel2.Top - (RichEdit1.Top + RichEdit1.Height);// - Panel1.Height - 10;

  Panel1.Top  := PainelCaixa.Top + PainelCaixa.Height;
  Panel1.Left := PainelCaixa.Left;
  Panel1.Width := PainelCaixa.Width;

  RichEdit1.Height := PainelCaixa.Top - RichEdit1.Top;

  if wi >= 1024 then
    begin
      PainelCaixa.Font.Size := 20;
    end;

  if (wi = 1024) then
    begin
      RichEdit1.Font.Size := 12;
    end;  

  PainelCaixa.Caption := 'CAIXA ' + CompletaOuRepete('', getSerieNFCe, '0', 2);

  self.Repaint;
  self.Refresh;
end;

procedure TForm3.FormShow(Sender: TObject);
var
  indxImp, velo : integer;
begin
 try
   form1.atualizaTabelaIBPT;
 except
 end;

 vendeuf2 := false;

 dtmMain.IBQuery1.Close;
 dtmMain.IBQuery1.SQL.Text := 'select * from pgerais where cod = 45';
 dtmMain.IBQuery1.Open;

 usarOFFLINE := false;
 if not dtmMain.IBQuery1.IsEmpty then
   begin
     if dtmMain.IBQuery1.FieldByName('valor').AsString = 'S' then usarOFFLINE := true;

     dtmMain.IBQuery1.Close;
     dtmMain.IBQuery1.SQL.Text := 'select count(*) as valor from nfce';
     dtmMain.IBQuery1.Open;

     if dtmMain.IBQuery1.FieldByName('valor').AsInteger = 0 then usarOFFLINE := false;
   end;

 setaCoresPDV();
 acessoUsuVenda := form1.acesso;
 configu        := form1.configu;
 alinhaComponentes();

 balOnline := true;
 abreLocalizaPesagem := true;

 if inicio = 1 then
      begin
        criaDataSetFormas;
        inicio := 0;
        TotTributos := 0;
        verificaNotasContigencia;
        enviandoCupom := false;
        //cupons := TTWtheadEnviaCupons1.create(true, panel1, enviandoCupom);
      end;

 setParametrosACBrECF2(dtmMain.ACBrBAL1, arq);
 corte := arq.Values['corte'];
 if arq.Values['balancaOnline'] = 'S' then balOnline := true
   else balOnline := false;

 abreLocalizaPesagem := true;

 if pgerais.Values['65'] = 'S' then begin
   if screen.width = 800 then nomesajuda.Caption := 'F2-Ler Balança/F3-Cancela Item/F4-Troca Usuário/F5-Consulta Por Nome/F6-Cancelar/'+ #13 +
                                                   'F7-AbreGaveta/F8-Ident. Cliente/F9-DAV/F10-Reimprimir/F11-Menu Fiscal/F12-Consultar Por Cód. Barras'+#13+'/Vendedor: ' + form1.vendedor + '-' + form1.NomeVend
   else  nomesajuda.Caption := 'F2-Ler Balança/F3-Cancela Item/F4-Troca Usuário/F5-Consulta Por Nome/F6-Cancelar Venda/F7-AbreGaveta'+#13+
   'F8-Ident. Cliente/F9-DAV/F10-Reimprimir/F11-Menu Fiscal/F12-Consultar Por Cód. Barras/Vendedor: ' + form1.vendedor + '-' + form1.NomeVend ;
 end
 else begin
   if screen.width = 800 then nomesajuda.Caption := 'F2-Ler Balança/F3-Cancela Item/F4-Troca Usuário/F5-Consulta Por Nome/F6-Cancelar/'+ #13 +
                                                   'F7-AbreGaveta/F8-Ident. Cliente/F9-DAV/F10-Reimprimir/F11-Menu Fiscal/F12-Consultar Por Cód. Barras'+#13+'/Vendedor: ' + form1.vendedor + '-' + form1.NomeVend
   else  nomesajuda.Caption := 'F2-Ler Balança/F3-Cancela Item/F4-Troca Usuário/F5-Consulta Por Nome/F6-Cancelar Venda'+#13+'/F7-AbreGaveta/F8-Ident. Cliente/F9-DAV/F10-Reimprimir/F11-Menu Fiscal/F12-Consultar Por Cód. Barras/Vendedor: ' + form1.vendedor + '-' + form1.NomeVend ;
 end;
  Panel2.Caption := '';//'F2-Ler Balança/F9-DAV/F3-Cancela Item/F6-Cancelar Venda'+#13+'/F5-Consultar/Vendedor: ' + form1.vendedor + '-' + form1.NomeVend ;
  RichEdit1.Clear;
  IBClientDataSet1.CreateDataSet;
  limpaVenda();
  screen.Cursor := crDefault;
  quant.Text := '1,000';

  //dtmMain.ACBrNFe.Configuracoes.Certificados.VerificarValidade;
  valCert        := 'Val. Cert: ' + FormatDateTime('dd/mm/yyyy',dtmMain.ACBrNFe.SSL.CertDataVenc);
  Panel1.Caption := valCert + ' ' + vercCountContigencia;

  dav := false;
  CodVendedorTemp := form1.vendedor;

  tabelaPROMOC_EXISTE := verSeExisteTabela('PROMOC');

  tudoOK_para_emitir_NFCe;

  if ((StrToInt(Incrementa_Generator('NFCE', 0)) < form1.valorSerieNoServidor) ) then
    begin
      if abs((StrToInt(Incrementa_Generator('NFCE', 0)) - form1.valorSerieNoServidor)) > 9 then begin
        PainelProduto.Caption := 'O Sistema Encontrou um Erro na Numeração!';
        CodVendedorTemp := '-999';
      end;
    end;
end;

procedure TForm3.codbarKeyPress(Sender: TObject; var Key: Char);
var
 cbar : String;
 sim  : integer;
begin
  if CodVendedorTemp = 'vvvv' then
    begin
      if key <> #27 then
        begin
          ShowMessage('O sistema Não Pode Emitir NFCe Enquanto o Problema Não for Sanado');
          key := #0;
          exit;
        end;  
    end;

  if key = '*' then
    begin
      key := #0;
      quant.SetFocus;
      exit;
    end;

  Timer1.Enabled := false;
  Timer1.Enabled := true;

  if key = #13 then
    begin
      if tecladoOK = false then exit;
      codbar.Text := LeftStr(codbar.Text, 20);

      TimerEnvia.Enabled := false;
      if codbar.Text = '' then
        begin
          key := #0;
          if IBClientDataSet1.IsEmpty then
            begin
              exit;
            end;        

          sim := MessageDlg('Deseja Finalizar a Venda?', mtConfirmation, [mbYes, mbNo], 1);
          if sim = idno then exit;

          if IBClientDataSet1.IsEmpty then
            begin
              ShowMessage('Não existe produtos para gravar');
              exit;
            end;

          if dav then
            begin
              fechaDav();
              exit;
            end;

          encerrarVenda(false);
        end;

      vendeItemFila(codbar.Text);
      key := #0;
      exit;
    end;

  if key = #27 then
    begin
      if IBClientDataSet1.IsEmpty then
        begin
          close;
          exit;
        end;
    end;
end;

procedure TForm3.FormCreate(Sender: TObject);
begin
  inicio := 1;
  tot_ge := 0;
//  ECF := dtmMain.ACBrECF1;

  tecladoOK := true;

  dadosEmpresa := TStringList.Create;
  dtmMain.IBQuery1.Close;
  dtmMain.IBQuery1.SQL.Text := 'select cnpj, empresa, ende from registro';
  dtmMain.IBQuery1.Open;

  dadosEmpresa.Values['cnpj']    := dtmMain.IBQuery1.fieldbyname('cnpj').AsString;
  dadosEmpresa.Values['empresa'] := dtmMain.IBQuery1.fieldbyname('empresa').AsString;
  dadosEmpresa.Values['ende']    := dtmMain.IBQuery1.fieldbyname('ende').AsString;
  dtmMain.IBQuery1.Close;

  formasP       := TStringList.Create;
  desconto      := 0;
  descontoItens := 0;
  //criaDataSetFormas;
end;

procedure TForm3.Timer1Timer(Sender: TObject);
begin
  Timer1.Enabled := false;
  if not IBClientDataSet1.IsEmpty then
    begin
      exit;
    end;

  protecaoDeTela;
  Timer1.Enabled := true;
end;

procedure TForm3.Timer2Timer(Sender: TObject);
begin
  Timer2.Enabled := false;
  PainelProduto.Caption := 'Aguarde...';
  try
    Button3.Enabled := false;
    enviNFCe('472', cliente);
    inicio := inicio + 1;
    Panel1.Caption := valCert + ' ' + vercCountContigencia;
    PainelProduto.Caption := 'OK: ' + IntToStr(inicio);
  finally
    Button3.Enabled := true;

    if inicio < 40 then Timer2.Enabled := true;
  end;
end;

procedure TForm3.RichEdit1DrawItem(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);
begin
  RichEdit1.Canvas.Brush.Color := clRed;
end;

procedure TForm3.codbarKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  log : boolean;
  acessoUsu, codbar, cod : String;
begin
  if (Key = 114) then //F3
    begin
      verProdutos();
      configu        := form1.configu;
      acessoUsuVenda := form1.acesso;
      exit;
    end;

  if (Key = 115) then //F4
    begin
      form53.login_muda_as_variaveis_de_usuario(log, acessoUsu, codbar, configu);
      if log then
        begin
          if length(acessoUsu) > 3 then cod := 'Acesso Negado Por Login de Usuário com Bloqueios: ' + codbar
            else
              begin
                cod := 'Acesso Permitido de: ' + codbar;
                acessoUsuVenda := acessoUsu;
              end;

          ShowMessage(cod);
        end;

      exit;
    end;

  if (Key = 113) then //F2
    begin
      vendeuf2 := true;
      Button1Click(sender);
      vendeuf2 := false;
      //lerPesoBalanca();
      exit;
    end;

  if (Key = 120) then //F9
    begin
      emiteDAV();
    end;

  if (Key = 122) then //F11
    begin
      if Length(acessoUsuVenda) >= 3 then
        begin
          MessageDlg('Usuário Bloqueado para Utilizar Esta Rotina', mtError, [mbOK], 1);
          exit;
        end;
        
      form9 := tform9.Create(self);
      form9.ShowModal;
      form9.Free;

      configu        := form1.configu;
      acessoUsuVenda := form1.acesso;
    end;

  if (Key = 123) then //F12
    begin
      form10 := tform10.Create(self);
      form10.ShowModal;
      form10.Free;
    end;

    if (Key = 121) then //F10
    begin
      reimprimir;
    end;

    if (Key = 118) then //F7
    begin
      //ShowMessage(acessoUsuVenda);
      if Length(acessoUsuVenda) > 2 then
        begin
          MessageDlg('Usuário bloqueado para Esta Rotina!', mtError, [mbOK], 1);
          exit;
        end;

      abreGaveta;
      configu        := form1.configu;
      acessoUsuVenda := form1.acesso;
    end;

  if (Key = 117) then //F6
    begin
      if Length(acessoUsuVenda) > 0 then
        begin
          MessageDlg('Usuário bloqueado para Cancelamento de Venda', mtError, [mbOK], 1);
          exit;
        end;

      if MessageBox(Handle, 'Deseja Cancelar esta Venda?', 'PDV - ControlW' ,MB_YESNO + MB_ICONQUESTION + MB_DEFBUTTON2 ) = idyes then
        begin
          gravaVenda(true);
          cancelaVenda();
        end;
      exit;
    end;

  if (Key = 116) then //F5
    begin
      tedit(sender).Text := localizar1('Localizar Produto','produto','cod, nome,quant, p_venda as preco ','cod','','nome','nome',false,false,false, 'cod', IBClientDataSet1cod.AsString,600 ,sender);
      if tedit(sender).Text <> '' then
        begin
          dtmMain.IBQuery1.Close;
          dtmMain.IBQuery1.SQL.Text := 'select codbar from produto where cod = :cod';
          dtmMain.IBQuery1.ParamByName('cod').AsInteger := StrToIntDef(tedit(sender).Text, 0);
          dtmMain.IBQuery1.Open;
          tedit(sender).Text := dtmMain.IBQuery1.fieldbyname('codbar').AsString;
          dtmMain.IBQuery1.Close;
        end;
      exit;  
    end;
end;

procedure TForm3.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if not IBClientDataSet1.IsEmpty then
    begin
      if MessageBox(Handle, 'Existe uma Venda Aberta, Deseja Cancelar esta Venda e Sair?', 'PDV - ControlW' ,MB_YESNO + MB_ICONQUESTION + MB_DEFBUTTON2 ) = idno then exit
        else
          begin
//            dtmMain.ACBrECF1.CancelaCupom;
            IBClientDataSet1.EmptyDataSet;
            RichEdit1.Clear;
            //JsEdit.LiberaMemoria(self);
          end;
    end;
  //else  ;;JsEdit.LiberaMemoria(self);

//  formasPagamento.Free;
end;

procedure TForm3.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if quant.Focused then exit;
  if not codbar.Focused then codbar.SetFocus;
end;

procedure TForm3.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if quant.Focused then exit;
  if not codbar.Focused then codbar.SetFocus;
end;

procedure TForm3.fechaDav();
var
  fechou : boolean;
begin
  fechou := false;
  {a funcao ler os valores recebido por forma de pagamento e preenche o clientdataset}
  if not lerReceido() then exit;

  obs := trim('Total Impostos Pagos R$' + formataCurrency(TotTributos) + '('+ formataCurrency((TotTributos / tot_ge) * 100) +'%)Fonte IBPT');
  mostraTroco();
  recebido1 := recebido;

  cliente := dialogo('generico',0,'1234567890,.'+#8,50,false,'',Application.Title,'Qual o Código do Cliente ?', codCliente);
  cliente := trim(cliente);

  if cliente = '0' then
    begin
      identificaCliente(codCliente);
      cliente := codCliente;
      //cliente := StrNum(codCliente);
    end;

  try
    tecladoOK := false;
  if enviNFCe(nota_venda, cliente) then
    begin
      dtmMain.IBQuery1.Close;
      dtmMain.IBQuery1.SQL.Text := 'update venda set ok = ''S'' where nota = :nota';
      dtmMain.IBQuery1.ParamByName('nota').AsString := nota_venda;
      dtmMain.IBQuery1.ExecSQL;
      dtmMain.IBQuery1.Transaction.Commit;
    end
  else
    begin
      //cancelaVenda(nota_venda, true);
    end;
  finally
    tecladoOK := true;
  end;

  //mostraTroco();
  limpaVenda;

  codbar.Text := '';
  quant.Text := '1,000';

  dav := false;
end;

procedure TForm3.quantKeyPress(Sender: TObject; var Key: Char);
begin
  if key = #13 then codbar.SetFocus;
  if key = #27 then codbar.SetFocus;

end;

procedure TForm3.Button1Click(Sender: TObject);
var
  key : char;
  erro1 : smallint;
  nomeTemp : String;
begin
  if dtmMain.ACBrBAL1.Ativo then dtmMain.ACBrBAL1.Desativar;
  dtmMain.ACBrBAL1.Modelo := balToledo;
  //dtmMain.ACBrBAL1.Device.Baud := 2400;
  dtmMain.ACBrBAL1.Device.Baud := 2400;
  dtmMain.ACBrBAL1.Porta := arq.Values['portabal'];
  dtmMain.ACBrBAL1.Ativar;

  dtmMain.IBQuery3.Close;
  dtmMain.IBQuery3.SQL.Text := 'select cod, nome, codbar from produto where (codbar like :cod)';
  dtmMain.IBQuery3.ParamByName('cod').AsString := codbar.Text + '%';
  dtmMain.IBQuery3.Open;

  if dtmMain.IBQuery3.IsEmpty then
    begin
      dtmMain.IBQuery3.Close;
      codTemp := '*';
      ShowMessage('Produto Não EncontradoX');
      exit;
    end;

  //codbar.Text := dtmMain.IBQuery3.fieldbyname('codbar').AsString;
  codTemp  := dtmMain.IBQuery3.fieldbyname('cod').AsString;
  nomeTemp := dtmMain.IBQuery3.fieldbyname('nome').AsString;
  dtmMain.IBQuery3.Close;
  erro1 := 0;

  PainelProduto.Caption := 'Lendo Balança...';
  codbar.Enabled := false;

  mostraMensagem(nomeTemp + #13 + 'Peso Balança: 0,000', true);
  try
  while true do
    begin
      Application.ProcessMessages;
      if erro1 > 25 then
        begin
          MessageDlg('Comunicação com a Balança Instável', mtError, [mbOK], 1);
          quant.Text := '1,000';
          utiLeituraBalanca := -1;
          codbar.Enabled := true;
          //mostraMensagem('Peso Balança: 0,000', false);
          exit;
        end;

      quant.Text := FormatCurr('#,###,###0.000', dtmMain.ACBrBAL1.LePeso());

      if quant.getValor = -9 then
        begin
          quant.Text := '1,000';
          utiLeituraBalanca := -9;
          MessageDlg('Comunicação com a Balança não disponível', mtError, [mbOK], 1);
          quant.SetFocus;
          codbar.Enabled := true;
          //mostraMensagem('Peso Balança: 0,000', false);
          exit;
        end;

      if quant.getValor > 0 then
        begin
          utiLeituraBalanca := quant.getValor;
          mensagem.Label1.Caption := nomeTemp + #13 + 'Peso Balança: ' + quant.Text;
          mensagem.Label1.Refresh;
          mensagem.Label1.Repaint;
          sleep(1000);
          codbar.Enabled := true;
          Break;
        end;

      {if quant.getValor < 0 then
        begin
          quant.Text := '1,000';
          exit;
        end;}

      Sleep(200);
      erro1 := erro1 + 1;  
    end;
  finally
    codbar.Enabled := true;
    PainelProduto.Caption := '';
    mostraMensagem('Peso Balança: ' + quant.Text, false);
  end;

 if not abreLocalizaPesagem then
   begin
     abreLocalizaPesagem := true;
     exit;
   end;

  if codbar.Text = '' then
    begin
      codbar.Text := localizar2('Localizar Produto','produto p','p.codbar, P.COD, p.nome,p.quant, p.p_venda as preco ','codbar','cod','nome','nome',false,false,false, ' where (p.codbar like ' + QuotedStr('2%') + ' )', IBClientDataSet1cod.AsString,600 , codbar);
    end
  else
    begin
      key := #13;
      codbarKeyPress(sender, key);
    end;

  exit;
  codbar.Text := '2006900005808';
  key := #13;
  codbarKeyPress(sender, key);
end;

function TForm3.lerReceido() :boolean;
var
  totTemp1, totTemp2 : currency;
begin
  //mostraMensagem('Aguarde...', true);
  recebido := 0;
  Result := false;
  formasPagamento.EmptyDataSet;
  {totTemp2 := ecf.Subtotal + desconto;

  {if tot_ge < totTemp2 then
    begin
      totTemp1 := totTemp2;
    end
  else totTemp1 := tot_ge;}
  //totTemp1 := tot_ge + desconto;
  totTemp1 := tot_ge;

  //mostraMensagem('Aguarde...', false);

  while true do
    begin
      //receb := dialogoG('numero', 0, '', 2, false, '', 'PDV - ControlW', 'Informe o Valor Pago:', formataCurrency(tot_ge), true);
      receb := dialogoG('numero', 0, '', 2, false, '', 'PDV - ControlW', 'Informe o Valor Pago:', formataCurrency(totTemp1), true);
      if receb = '*' then
        begin
          formasPagamento.EmptyDataSet;
          exit;
        end;

      //recebido := recebido + StrToCurr(receb);
      totTemp1 := totTemp1 - StrToCurr(receb);
      recebido := recebido + StrToCurr(receb);

      codhis := lerFormasDePagamento(dtmmain.ibquery1, '', true, formaPagtoImpressora, indice);
      if codhis = '*' then
        begin
          formasPagamento.EmptyDataSet;
          exit;
        end;

      codhis := lerForma(codhis, 0);
      if formasPagamento.FindKey([codhis]) then
        begin
          formasPagamento.Edit;
          formasPagamento.FieldByName('total').AsCurrency := formasPagamento.FieldByName('total').AsCurrency + StrToCurr(receb);
          formasPagamento.Post;
        end
      else
        begin
          formasPagamento.Insert;
          formasPagamento.FieldByName('cod').AsString     := codhis;
          formasPagamento.FieldByName('indImp').AsString  := formaPagtoImpressora.Values[codhis];
          formasPagamento.FieldByName('total').AsCurrency := StrToCurr(receb);
          formasPagamento.Post;
        end;

      if ((recebido >= totTemp1) or (Arredonda(totTemp1 - recebido, 2) <= 0)) then
        begin
          Result := true;
          break;
        end;
    end;
end;

procedure TForm3.lerFormasParaGravarAVendaPreencheEntrada();
begin
  formasPagamento.First;
  entrada := 0;
  if formasPagamento.RecordCount = 1 then
    begin
      codhis := formasPagamento.FieldByName('cod').AsString;
      exit;
    end;

  while not formasPagamento.Eof do
    begin
      codhis := formasPagamento.FieldByName('cod').AsString;
      if formasPagamento.FieldByName('cod').AsInteger = 1 then
        begin
          entrada := entrada + formasPagamento.FieldByName('total').AsCurrency;
        end
      else
        begin
          codhis := formasPagamento.FieldByName('cod').AsString;
        end;
      formasPagamento.Next;
    end;
end;

procedure TForm3.descarregaFormasDePagamentoImpressora();
begin
  formasPagamento.First;
  while not formasPagamento.Eof do
    begin
      //ecf.EfetuaPagamento(formasPagamento.FieldByName('indImp').AsString, formasPagamento.FieldByName('total').AsCurrency, '');
      formasPagamento.Next;
    end;
end;

procedure TForm3.criaDataSetFormas();
begin
  formasPagamento := TClientDataSet.Create(self);
  formasPagamento.FieldDefs.Add('cod'   , ftSmallint);
  formasPagamento.FieldDefs.Add('total' , ftCurrency);
  formasPagamento.FieldDefs.Add('indImp', ftString, 3);
  formasPagamento.IndexFieldNames := 'cod';
  formasPagamento.CreateDataSet;
end;

procedure TForm3.cancelaItemVisual(const num : smallint;const tot_item : currency);
var
  ini, fim : integer;
  num1 : String;
begin
  //ECF.CancelaItemVendido(num);
  tot_ge := tot_ge - tot_item;
  PainelTotal.Caption := formataCurrency(tot_ge);
  num1 := CompletaOuRepete('', IntToStr(num), '0', 3);
  fim := RichEdit1.Count -1;
  for ini := 0 to fim do
    begin
      if copy(RichEdit1.Items[ini], 1, 3) = num1 then
        begin
          RichEdit1.Items[ini]     := '** CANCELADO **' + RichEdit1.Items[ini];
          RichEdit1.Items[ini + 1] := '** CANCELADO **' + RichEdit1.Items[ini + 1];
        end;
    end;
end;

procedure TForm3.TimerVendaTimer(Sender: TObject);
begin
  TimerVenda.Enabled := false;
  try
//    if not ((vendendoECF) or (dtmMain.ACBrECF1.AguardandoResposta)) then
 if true then
      begin
        codTemp := ACBrLCB1.LerFila;
        codTemp := trim(codTemp);
        vendeItemFila(codTemp);
      end;
  finally
    TimerVenda.Enabled := (ACBrLCB1.FilaCount > 0);
  end;
end;

procedure TForm3.setaConfigBalanca();
var
  arq : TStringList;
  tipo : String;
begin
  arq := TStringList.Create;
  if not FileExists(ExtractFileDir(ParamStr(0)) + '\ConfECF.ini') then exit;
  arq.LoadFromFile(ExtractFileDir(ParamStr(0)) + '\ConfECF.ini');

  if dtmMain.ACBrBAL1.Ativo then dtmMain.ACBrBAL1.Desativar;
  tipo  := arq.Values['tipoBal'];

  //dtmMain.ACBrBAL1.Porta := trim(arq.Values['portabal']);
  //dtmMain.ACBrBAL1.Device.Baud := StrToIntDef(trim(arq.Values['velobal']), 9600);

  if tipo = '0' then dtmMain.ACBrBAL1.Modelo := balNenhum
  else if tipo = '1' then dtmMain.ACBrBAL1.Modelo := balDigitron
  else if tipo = '2' then dtmMain.ACBrBAL1.Modelo := balFilizola
  else if tipo = '3' then dtmMain.ACBrBAL1.Modelo := balLucasTec
  else if tipo = '4' then dtmMain.ACBrBAL1.Modelo := balMagellan
  else if tipo = '5' then dtmMain.ACBrBAL1.Modelo := balMagna
  else if tipo = '6' then dtmMain.ACBrBAL1.Modelo := balToledo
  else if tipo = '7' then dtmMain.ACBrBAL1.Modelo := balToledo2180
  else if tipo = '8' then dtmMain.ACBrBAL1.Modelo := balUrano
  else if tipo = '8' then dtmMain.ACBrBAL1.Modelo := balUranoPOP;

  arq.Free;
  try
    //dtmMain.ACBrBAL1.MonitorarBalanca := true;
    if not dtmMain.ACBrBAL1.Ativo then dtmMain.ACBrBAL1.Ativar;
    //if not dtmMain.ACBrBAL1.Ativo then dtmMain.ACBrBAL1.Ativar;
    //ShowMessage(FormatCurr('#,###,###0.000', dtmMain.ACBrBAL1.LePeso()));
    //if dtmMain.ACBrBAL1.Ativo then ShowMessage('ativo' + #13 + dtmMain.ACBrBAL1.ModeloStr);
  except
    on e:exception do
      begin
        ShowMessage('erro: ' + e.Message);
      end;
  end;
end;

procedure TForm3.Button2Click(Sender: TObject);
var
  key : char;
begin
  codbar.Text := '7898924902011';
  key := #13;
  codbarKeyPress(sender, key);
{  if dtmMain.ACBrBAL1.Ativo then dtmMain.ACBrBAL1.Desativar;
  dtmMain.ACBrBAL1.MonitorarBalanca := true;
  quant.Text := FormatCurr('#,###,###0.000', dtmMain.ACBrBAL1.LePeso());}
end;

procedure TForm3.Button3Click(Sender: TObject);
begin
  verificaDavNFCeTravado;
  //Timer2.Enabled := not Timer2.Enabled;
end;

function TForm3.somaTotalOriginal(somaValorReal : boolean = false; naoSomarCancelados : boolean = true) : Currency;
begin

  try
  IBClientDataSet1.DisableControls;
  IBClientDataSet1.First;
  Result := 0;
  while not IBClientDataSet1.Eof do
    begin
      if naoSomarCancelados = true then
        begin
          if ((not Contido('** CANCELADO **', IBClientDataSet1nome.AsString)))  then
            begin
              //Result := Result + Arredonda(IBClientDataSet1.fieldbyname('quant').AsCurrency * IBClientDataSet1.fieldbyname(IfThen(somaValorReal, 'preco', 'precoOrigi')).AsCurrency, 2, tipoArredondaVenda);
             if somaValorReal then Result := Result + IBClientDataSet1.fieldbyname('total').AsCurrency
               else Result := Result + IBClientDataSet1.fieldbyname('totalOrigi').AsCurrency;
            end;
        end
      else
        begin
          if somaValorReal then Result := Result + IBClientDataSet1.fieldbyname('total').AsCurrency
            else Result := Result + IBClientDataSet1.fieldbyname('totalOrigi').AsCurrency;
        end;

      IBClientDataSet1.Next;
    end;

 finally
   IBClientDataSet1.EnableControls;
 end;
end;

procedure TForm3.cancelaVenda(nota2 : string = ''; erro_nfce : boolean = false);
begin
  if nota2 <> '' then
    begin
      if erro_nfce = false then
         begin
           dtmMain.IBQuery1.Close;
           dtmMain.IBQuery1.SQL.Text := 'update venda set cancelado = :canc where nota = :nota';
           dtmMain.IBQuery1.ParamByName('canc').AsInteger := StrToIntDef(StrNum(form1.codUsuario), 0);;
           dtmMain.IBQuery1.ParamByName('nota').AsString := StrNum(nota2);
           dtmMain.IBQuery1.ExecSQL;
         end
       else
         begin
           dtmMain.IBQuery1.Close;
           dtmMain.IBQuery1.SQL.Text := 'update venda set ok = '''' where nota = :nota';
           dtmMain.IBQuery1.ParamByName('nota').AsString := StrNum(nota2);
           dtmMain.IBQuery1.ExecSQL;
           dtmMain.IBQuery1.Transaction.Commit;
         end;
           
      exit;
    end;

  limpaVenda;
end;

procedure TForm3.aguardaRespostaECF(const intervalo : integer = 100);
begin
  while true do
    begin
      break;
      //if not ecf.AguardandoResposta then break;
      //sleep(intervalo);
    end;
end;

function TForm3.enviNFCe(const perg : String = ''; cli : String = ''; vRecebido : currency = 0) : boolean;
var
  statu, xmot, cliente, nota, obs, vend : String;
  msg, tpemissao, acc  : integer;
  envi, enviarOFFlineAgora, imp   : boolean;
  totTrib, tot1 : currency;
begin
  DANFE.NFeCancelada := false;

  if not verificaSePodeEmitirContigencia then exit;

  Result := false;
  envi := false;
  enviarOFFlineAgora := false;

  if form1.pgerais.Values['45'] = 'S' then envi := false
    else envi := true;

  if perg = '' then
    begin
      nota := dialogo('not',0,'1234567890'+#8+#32,50,true,'',Application.Title,'Qual a Nota de Venda?','');
      if nota = '*' then exit;
    end
  else nota := perg;

  dtmMain.IBQuery4.Close;
  dtmMain.IBQuery4.SQL.Text := 'select nota, cliente, vendedor, total from venda where (nota = :nota) and (cancelado = 0)';
  dtmMain.IBQuery4.ParamByName('nota').AsString := nota;
  dtmMain.IBQuery4.Open;

  if dtmMain.IBQuery4.IsEmpty then
    begin
      dtmMain.IBQuery4.Close;
      ShowMessage('Nota ' + nota + ' Não Encontrada');
      exit;
    end;

  //if Contido('-', cliente) = false then cli := dtmMain.IBQuery4.fieldbyname('cliente').AsString;
  vend    := dtmMain.IBQuery4.fieldbyname('vendedor').AsString;
  tot1    := dtmMain.IBQuery4.fieldbyname('total').AsCurrency;

  dtmMain.IBQuery4.Close;
  dtmMain.IBQuery4.SQL.Text := 'select nome from vendedor where (cod = :nota)';
  dtmMain.IBQuery4.ParamByName('nota').AsString := vend;
  dtmMain.IBQuery4.Open;

  vend := vend + '-' + dtmMain.IBQuery4.fieldbyname('nome').AsString;

  dtmMain.IBQuery4.Close;
  dtmMain.IBQuery4.SQL.Text := 'select nota, adic from nfce where (nota = :nota)';
  dtmMain.IBQuery4.ParamByName('nota').AsString := nota;
  dtmMain.IBQuery4.Open;

  if not dtmMain.IBQuery4.IsEmpty then
    begin
      {if dtmMain.IBQuery4.FieldByName('adic').AsString = 'OFF' then
        begin
          Result := true;
          msg := MessageDlg('Esta NFCe foi emitida em Contigência Offline, Deseja Transmiti-la Agora por meio da Internet?',
                  mtInformation,[mbYes, mbNo, mbCancel],0);
          if msg = idyes then
            begin
              try
                mensagemEnviandoNFCE('Aguarde, Enviando NFCe1...', true, false);
                //mostraTroco(Application.Title ,'Aguarde, Enviando NFCe...',15,'Courier New',false,0,clred);
                Application.ProcessMessages;
                Application.ProcessMessages;
                if EnviarCupomEletronico2(nota, '', RichEdit2, statu, true, false) then Result := true;
              finally
                mensagemEnviandoNFCE('Aguarde, Enviando NFCe1...', false, true);
              end;
            end;
          exit;
        end;

      ShowMessage('A Nota ' +  nota + ' Já foi Transmitida');
      Result := true;
      exit; }
    end;

  cliente := cli;

  if  cliente = '*' then
    begin
      exit;
      cliente := '0';
    end;

  obs := '';

  if tipoIMPRESSAO = 0 then imp := false
   else imp := true;

  obs := 'PEDIDO: ' + nota + ';' + 'VENDEDOR: ' + vend + ';' + obs;
  if codCliente <> '' then obs := obs;

  try
  try
    statu := '';
    if Button3.Visible = false then
    mensagemEnviandoNFCE('Aguarde, Enviando NFCe...', true, false);
    acc := 0;
    Application.ProcessMessages;
    Application.ProcessMessages;

    Result := EnviarCupomEletronicoTitular(nota, statu, xmot, tpemissao, envi, cliente, obs, '', '',TRUE, recebido1, imp);
    if Result = true then
      begin
        atualizaGenerator();
      end;
  except
    on e:exception do
      begin
        gravaERRO_LOG1('','ERRO: ' + e.Message +#13+ 'LINHA: 21117' + #13 + 'Metodo: enviNFCe', '');
        MessageDlg('ERRO: ' + e.Message, mtError, [mbOK], 1);
      end;
  end;
  finally
    if Button3.Visible = false then
    mensagemEnviandoNFCE('Aguarde, Enviando NFCe...', false, true);
  end;
end;

procedure TForm3.identificaCliente(var codcli : String);
begin
  form12 := TForm12.Create(self);
  form12.ShowModal;
  codCliente := form12.codCliente;
  jsedit.LiberaMemoria(form12);
  form12.Free;
end;


procedure TForm3.escreveTotal;
begin

end;

procedure TForm3.IBClientDataSet1AfterPost(DataSet: TDataSet);
begin
  tot_ge := somaTotalOriginal(true);
  PainelTotal.Caption := formataCurrency(tot_ge);
end;

procedure TForm3.TimerEnviaTimer(Sender: TObject);
begin
  TimerEnvia.Enabled := false;
  //enviaCuponsPendentes;
  {if enviandoCupom = false then
    begin
      cupons.Execute;
    end;}

  //TimerEnvia.Enabled := true;
end;

procedure TForm3.enviaCuponsPendentes();
var
  esta : string;
  envi : boolean;
  ok, totEnvia   : integer;
begin
  dtmMain.IBQuery1.Close;
  dtmMain.IBQuery1.SQL.Text := 'select nota, chave, data from nfce where adic = ''OFF''';
  dtmMain.IBQuery1.Open;
  dtmMain.IBQuery1.FetchAll;

  if dtmMain.IBQuery1.IsEmpty then exit;

  Panel1.Caption := valCert + ' ' + 'Contigência: ' + IntToStr(dtmMain.IBQuery1.RecordCount);

  ok := 0;
  while not dtmMain.IBQuery1.Eof do
    begin
      ok := ok + 1;
      Application.ProcessMessages;
      Application.ProcessMessages;
      envi := false;

      try
        envi := EnviarCupomEletronico2(dtmMain.IBQuery1.FieldByName('nota').AsString, dtmMain.IBQuery1.FieldByName('chave').AsString, RichEdit2, esta, false, true, false);
      except
        on e:exception do
          begin
          end;
      end;

      if envi then
        begin
          totEnvia := totEnvia + 1;
        end
      else
        begin
        //  RichEdit1.Lines.Add('Estado: ERRO => ' + esta);
        end;

      break;
    end;
end;

procedure TForm3.verificaNotasContigencia();
begin
  EXIT;
  TimerEnvia.Enabled := false;
  dtmMain.IBQuery1.Close;
  dtmMain.IBQuery1.SQL.Text := 'select nota from nfce where adic = ''OFF''';
  dtmMain.IBQuery1.Open;
  dtmMain.IBQuery1.FetchAll;

  if not dtmMain.IBQuery1.IsEmpty then
    begin
      dtmMain.IBQuery1.Close;
      //TimerEnvia.Enabled := true;
    end;

end;


function TForm3.vercCountContigencia() : String;
begin
  Result := '';
  dtmMain.IBQuery1.Close;
  dtmMain.IBQuery1.SQL.Text := 'select count(*) as qtd from nfce where adic = ''OFF'' and substring(chave from 23 for 3) = :serie';
  dtmMain.IBQuery1.ParamByName('serie').AsString := strzero(getSerieNFCe, 3);
  dtmMain.IBQuery1.Open;

  if dtmMain.IBQuery1.fieldbyname('qtd').AsInteger > 0 then
    begin
      Result := 'Contigência: ' + IntToStr(dtmMain.IBQuery1.fieldbyname('qtd').AsInteger);
    end;

  dtmMain.IBQuery1.Close;
end;

procedure TTWtheadEnviaCupons1.Execute;
var
  query99 : TIBQuery;
  forne : String;
  cont, fim : integer;
begin
  terminou1 := true;
  query99 := TIBQuery.Create(Application);
  query99.Database := dtmMain.bd;

  query99.SQL.Text := 'select nota, chave from NFCE where adic = ''OFF''';
  query99.Open;
  query99.FetchAll;
  fim := query99.RecordCount;
  cont := 0;

  while not query99.Eof do
    begin
      cont := cont + 1;
      if pos('-', label1.Caption) > 0 then label1.Caption := copy(label1.Caption, 1, pos('-', label1.Caption)) + ' - Enviando: ' + IntToStr(cont) + '/' + IntToStr(fim)
       else label1.Caption := label1.Caption + ' - Enviando: ' + IntToStr(cont) + '/' + IntToStr(fim);

      try
        //funcoes.Mensagem(Application.Title ,'Aguarde, Enviando NFCe...',15,'Courier New',false,0,clred);
        Application.ProcessMessages;
        Application.ProcessMessages;
        EnviarCupomEletronico2(query99.fieldbyname('nota').AsString, query99.fieldbyname('chave').AsString, form3.RichEdit2, forne, false, true, false);
      except
        //pergunta1.close;
      end;
      query99.Next;
    end;

  query99.Close;  
  terminou1 := false;
end;

constructor TTWtheadEnviaCupons1.create(CreateSuspended: Boolean; lab1: TPanel; var terminou : boolean);
begin
 label1 := lab1;
 terminou1 := terminou;
 inherited create(CreateSuspended);
end;


procedure TForm3.abreGaveta();
var
 F : TextFile;
 imp : String;
 cont : integer;
begin
  if portaCOMNFCE = '' then exit;

  try
    if tipoIMPRESSAO = 1 then
      begin
        inicializarImpressora;

        cont := 0;
        while True do begin
          cont := cont + 1;
          try
            dtmMain.ACBrPosPrinter1.AbrirGaveta;
            break;
          finally
          end;

          if cont = 10 then begin
            break;
          end;
        end;
      end
     else abreGavetaComponente;
  except
    on e:exception do
      begin
        MessageDlg('Erro: ' + e.Message, mtError, [mbOK], 1);
        exit;
      end;
  end;

  exit;
  try
   AssignFile(F, portaCOMNFCE);
  except
    exit;
  end;
  Rewrite(F);

  if tipoImp = 1 then
    begin
     Writeln(F,#027+ #112+ #000+ #010+ #100''); // Abrir Gaveta Epson
    end;

  if tipoImp = 0 then
    begin
      //Writeln(F,#27 + #118 + #140);  //BEMATECH
      //Writeln(F,#27#118);
      Writeln(F, #29 + #249 + #32 + #0 + #27 + #116 + #8 + #27 + #118 + #140) //bematech
    end;
  if tipoImp = 2 then  Writeln(F,#27 + 'v' + #118);  //elgin
  if tipoImp = 3 then Writeln(F,#027+ #112+ #000+ #010+ #100''); // Abrir Gaveta Epson
  CloseFile(F);
end;

procedure TForm3.abreGavetaComponente();
var
 F : TextFile;
 imp : String;
begin
  try
    compGAV.Porta := portaCOMNFCE;
    compGAV.Modelo := gavImpressoraComum;
  if tipoImp = 1 then
    begin
      compGAV.StrComando :=  #027+ #112+ #000+ #010+ #100'';// Abrir Gaveta Epson
    end;

  if tipoImp = 0 then
    begin
      //compGAV.StrComando :=  #29','#249','#32','#0','#27','#116','#8','#27','#118','#140;// Abrir Gaveta Epson
      compGAV.StrComando :=  #27 + #64 + #29 + #249 + #32 + #0 + #27 + #116 + #8 + #27 + #118 + #110;// Abrir Impressora Bematech
    end;
  //if tipoImp = 2 then  Writeln(F,#27 + 'v' + #100);  //elgin
  //if tipoImp = 3 then Writeln(F,#027+ #112+ #000+ #010+ #100''); // Abrir Gaveta Epson

  compGAV.Ativar;
  compGAV.GAV.AbreGaveta;
  compGAV.Desativar;
  compGAV.Device.Desativar;

  except
    on e:exception do
      begin
        MessageDlg('Erro: ' + e.Message, mtError, [mbOK], 1);
        exit;
      end;
  end;

end;


procedure TForm3.codbarKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = 119) then //F7
    begin
      identificaCliente(codcliente);
    end;
end;

procedure TForm3.reimprimir();
var
  pedido    : String;
  impFortes : boolean;
begin
  //pedido := dialogo('generico',0,'1234567890'+#8,50,false,'',Application.Title,'Qual o Numero da Venda ?', Incrementa_Generator('venda', 0));
  pedido := dialogo('generico',0,'1234567890'+#8,50,false,'',Application.Title,'Qual o Numero da Venda ?', IntToStr(strtoint(Incrementa_Generator('nfce', 0)) -1));
  if pedido = '*' then exit;

  impFortes := false;

  if tipoIMPRESSAO <> 1 then impFortes := true;

  try
    if impFortes = false then begin
      dtmMain.ACBrPosPrinter1.Desativar;
      dtmMain.ACBrPosPrinter1.Porta := portaCOMNFCE;
      if dtmMain.ACBrPosPrinter1.Device.Ativo = false then dtmMain.ACBrPosPrinter1.Ativar;
      if dtmMain.ACBrPosPrinter1.Inicializada = false then dtmMain.ACBrPosPrinter1.Inicializar;
    end;
  except
    on e:exception do
      begin
        MessageDlg('ERRO: ' + e.Message, mtError, [mbOK], 1);
      end;
  end;
  
  Imprimir_DANFE_PDF(pedido, pedido, impFortes, getSerieNFCe);
end;


procedure TForm3.atualizaGenerator();
var
  gen1 : String;
begin
  if dtmMain.BD_Servidor.DatabaseName = '' then exit;

  if not dtmMain.conectaBD_Servidor then exit;

  gen1 := Incrementa_Generator('nfce', 0);
  reStartGenerator1('NFCE' + getSerieNFCe, StrToIntDef(gen1, 0), dtmMain.IBQueryServer1);
  dtmMain.BD_Servidor.Connected := false;
end;

function TForm3.tudoOK_para_emitir_NFCe() : boolean;
begin
  Result := false;
  if ((dtmMain.ACBrNFe.Configuracoes.Geral.IdCSC = '') or (dtmMain.ACBrNFe.Configuracoes.Geral.CSC = '')) then
    begin
      MessageDlg('Informações de QrCode Não Encontradas. Preencha CSC e o IdCSC da NFCe!' + #13 +
      'Esta Informação é gerada na area de Serviços do Portal da NFCe do estado vigente.', mtError, [mbOK], 1);
      Configuracoes_NFCe(true);
      exit;
    end;

  Result := true;
end;

function TForm3.buscaClienteCompleto() : Smallint;
begin
  Result := 0;
  if tot_ge <= 5000 then exit;

  while true do
    begin
      cadCliNFCe := TcadCliNFCe.Create(self);
      cadCliNFCe.ShowModal;
      codCliente := cadCliNFCe.codCliente;
      cadCliNFCe.Free;
      if codCliente <> '0' then Break
        else
          begin
            if MessageDlg('O Cliente é Obrigatório para Vendas acima de 10mil Reais, Favor Cadastre um Cliente! Deseja Continuar ?', mtInformation, [mbYes, mbNo], 1) = idno then
              begin
                Result := 1;
                break;
              end;
          end;
    end;
end;

function TForm3.buscaPreco(codigo : integer; quant1 : currency) : currency;
var
  prec, qtd, porc : currency;
  tipo : String;
begin
  Result := 0;
  dtmMain.IBQuery1.Close;
  dtmMain.IBQuery1.SQL.Text := 'select p_venda from produto where cod = :cod';
  dtmMain.IBQuery1.ParamByName('cod').AsInteger := codigo;
  dtmMain.IBQuery1.Open;

  if dtmMain.IBQuery1.IsEmpty then
    begin
      dtmMain.IBQuery1.Close;
      exit;
    end;

  prec := dtmMain.IBQuery1.fieldbyname('p_venda').AsCurrency;

  Result := prec;
  if tabelaPROMOC_EXISTE = false then exit;

  dtmMain.IBQuery1.Close;
  dtmMain.IBQuery1.SQL.Text := 'select cod, quant, p_venda, tipo from promoc1 where cod = :cod order by quant';
  dtmMain.IBQuery1.ParamByName('cod').AsInteger := codigo;
  dtmMain.IBQuery1.Open;

  if dtmMain.IBQuery1.IsEmpty then
    begin
      dtmMain.IBQuery1.Close;
      exit;
    end;

  qtd := 0;

  IBClientDataSet1.First;
  while not IBClientDataSet1.Eof do
    begin
      if ((codigo = IBClientDataSet1cod.AsInteger) and (Contido('** CANCELADO **', IBClientDataSet1nome.AsString) = false)) then
        begin
          qtd := qtd + IBClientDataSet1quant.AsCurrency;
        end;

      IBClientDataSet1.Next;
    end;

  qtd := qtd + quant1;

  if qtd >= dtmMain.IBQuery1.fieldbyname('quant').AsCurrency then
    begin
      porc := dtmMain.IBQuery1.fieldbyname('p_venda').AsCurrency;
      tipo := dtmMain.IBQuery1.fieldbyname('tipo').AsString;
    end
  else begin
    porc := 0;
    tipo := '1';
  end;

  if tipo <> '0' then begin
    if porc > 0 then begin
      prec := prec -(prec * (porc / 100));
      prec := Arredonda(prec, 2);
    end;
  end;

  atualizaPrecoProduto(codigo, prec);

  vendeVisualTodos;
  dtmMain.IBQuery1.Close;  
  Result := prec;
end;


function TForm3.verSeExisteTabela(nome : String) : boolean;
begin
  Result := false;
  dtmMain.IBQuery1.Close;
  dtmMain.IBQuery1.SQL.Clear;
  dtmMain.IBQuery1.SQL.Add('select rdb$relation_name from rdb$relations where (rdb$system_flag = 0) and (rdb$relation_name = ' + QuotedStr(nome) + ')');
  dtmMain.IBQuery1.Open;

  if dtmMain.IBQuery1.IsEmpty then Result := false
    else Result := true;

  dtmMain.IBQuery1.Close;
end;

procedure TForm3.atualizaPrecoProduto(codigo : integer; preco1 : currency);
begin
  IBClientDataSet1.First;
  while not IBClientDataSet1.Eof do
    begin
      if ((codigo = IBClientDataSet1cod.AsInteger) and (IBClientDataSet1preco.AsCurrency <> preco1)) then
        begin
          IBClientDataSet1.Edit;
          IBClientDataSet1preco.AsCurrency := preco1;
          IBClientDataSet1total.AsCurrency := Arredonda(preco1 * IBClientDataSet1quant.AsCurrency, 2);
          IBClientDataSet1.Post;
          IBClientDataSet1.First;
        end;

      IBClientDataSet1.Next;
    end;

  IBClientDataSet1.First;  
end;



function TForm3.confirmaPrecoProduto(cod : String;var qtd , valor : String; opcao : smallint; servico : boolean = false) : string;
var
  porcDesc, p_venda,temp1, p_vendatemp, minimo : currency;
  tipoDesconto, podeDarAcrescimo, campo, fim, desc : String;
  atacado : boolean;
begin
  Result := valor;

    if form1.pgerais.Values['37'] = 'S' then exit;

  tipoDesconto     := LerConfig(configu, 2);
  if contido(tipoDesconto, 'SP') = false then exit;

  valor  := '0';
  Result := '0';
  atacado := false;

  if opcao = 0 then
    begin
      qtd := dialogo('numero',3,'SN',3,false,'S','Control for Windows:','Quantidade:','0,000');
      if ((qtd = '*') or (StrToCurrDef(qtd,0) = 0)) then
        begin
          valor  := '*';
          Result := valor;
          exit;
        end;
    end;

  campo := 'p_venda';
  if atacado then campo := 'p_venda1 as p_venda';

  query1.Close;
  query1.SQL.Clear;
  query1.SQL.Add('select desconto, '+campo+'  from produto where cod = :cod');
  query1.ParamByName('cod').AsString := cod;
  query1.Open;

  porcDesc    := StrToCurrDef(LerConfig(configu,0), 0);
  p_venda     := query1.fieldbyname('p_venda').AsCurrency;
  p_vendatemp := p_venda;


  {if p(55, 'N') = 'S' then
    begin
      if dm.IBselect.fieldbyname('desconto').AsCurrency > 0 then
        begin
           porcDesc := dm.IBselect.fieldbyname('desconto').AsCurrency;
        end;
    end;   }

  //calcula o minimo a partir do preco com o desconto maximo configurado na conta do usuario
  minimo := Arredonda(p_venda - ((p_venda * porcDesc)/100), 2);

  query1.Close;
  if trim(tipoDesconto) = '' then tipoDesconto := 'S';
  //podeDarAcrescimo := LerConfig(configu, 8);
  podeDarAcrescimo := 'S';

  if servico then
    begin
      tipoDesconto     := 'S';
      podeDarAcrescimo := 'S';
    end;


  if tipoDesconto = 'S' then
    begin
      fim := '-999999';
      while true do
        begin
          fim := dialogoG('numero',3,'1234567890,.'+#8,3,false,'ok','Control for Windows:','Confirme o Preço(Minimo: R$ '+ FormatCurr('#,###,###0.00',minimo) + ':',FormatCurr('###,##0.000',p_venda), true);
          if fim = '*' then
            begin
              Result := fim;
              exit;
            end;

          temp1 := StrToCurrDef(fim, 0);

          if ((podeDarAcrescimo = 'S') and (temp1 > p_venda) )then
            begin
              break;
            end;

          if (((temp1 >= minimo) and (temp1 <= p_venda)) or ((temp1 > p_venda) and VerificaAcesso_Se_Nao_tiver_Nenhum_bloqueio_true_senao_false)) then
            begin
              break;
            end;

          if ((temp1 < minimo) and (VerificaAcesso_Se_Nao_tiver_Nenhum_bloqueio_true_senao_false)) then
            begin
              break;
            end;
        end;

    Result := CurrToStr(temp1);
    valor  := CurrToStr(temp1);
    exit;
  end
 else if tipoDesconto = 'P' then
   begin
     desc := '99999999';
     while true do
       begin
         desc := dialogoG('numero',0,'1234567890,.'+#8,0,false,'ok','Control for Windows:','Qual o Percentual de Desconto (Máximo='+ FormatCurr('#,###,###0.000', porcDesc) + '%) (%)?:','0,000', true);
         if desc = '*' then
           begin
             Result := desc;
             exit;
           end;

         if (StrToCurrDef(desc, 0) = porcDesc) then break;
         //if ((StrToCurr(desc) > porcDesc) and (VerificaAcesso_Se_Nao_tiver_Nenhum_bloqueio_true_senao_false)) then break;

         if (StrToCurr(desc) <= porcDesc)then break;
       end;

    temp1 := StrToCurrDef(desc, 0);
    Result := CurrToStr(Arredonda(p_venda-(p_venda * temp1 /100), 2));
    valor := Result;
    exit;
  end
 else if tipoDesconto = 'X' then
   begin
     desc := '99999999';
     while true do
       begin
         desc := dialogoG('numero',0,'1234567890,.'+#8,0,false,'ok','Control for Windows:','Qual o Percentual de Desconto (Máximo='+ FormatCurr('#,###,###0.000', porcDesc) + '%) (%)?:','0,000', true);
         if desc = '*' then
           begin
             Result := desc;
             exit;
           end;

         if (StrToCurrDef(desc, 0) = porcDesc) then break;
         //if ((StrToCurr(desc) > porcDesc) and (VerificaAcesso_Se_Nao_tiver_Nenhum_bloqueio_true_senao_false)) then break;

         if (StrToCurr(desc) <= porcDesc)then break;
       end;

    temp1 := StrToCurrDef(desc, 0);
    if temp1 = 0 then p_vendatemp := p_vendatemp
      else p_vendatemp := Arredonda(p_venda-(p_venda * temp1 /100), 2);

    fim := '-999999';
      while true do
        begin
          //funcoes.dialogo('numero',3,'1234567890,.'+#8,3,false,'ok','Control for Windows:','Confirme o Preço(Minimo: R$ '+ FormatCurr('#,###,###0.00',minimo) + ':',FormatCurr('###,##0.000',p_venda));
          fim := dialogoG('numero',3,'1234567890,.'+#8,3,false,'ok','Control for Windows:','Confirme o Preço(Minimo: R$ '+ FormatCurr('#,###,###0.000',minimo) + ':',FormatCurr('###,##0.000',p_vendatemp), true);
          if fim = '*' then
            begin
              Result := fim;
              exit;
            end;

          temp1 := StrToCurrDef(fim, 0);

//          ShowMessage('minimo=' + CurrToStr(minimo) + #13 + 'p_vendatemp=' +  CurrToStr(p_vendatemp) + 'p_venda=' + CurrToStr(p_venda) +
//          #13 + 'temp1=' + CurrToStr(temp1));

          if ((podeDarAcrescimo = 'S') and (temp1 > p_venda) )then break;
          {if (((temp1 >= minimo) and (temp1 <= p_venda)) or ((temp1 > p_venda) and VerificaAcesso_Se_Nao_tiver_Nenhum_bloqueio_true_senao_false), true) then
            begin
              break;
            end;}
          //if ((temp1 < minimo) and (VerificaAcesso_Se_Nao_tiver_Nenhum_bloqueio_true_senao_false)) then  break;

        end;

    Result := CurrToStr(temp1);
    valor := Result;
    exit;
 end
else
  begin
    Result := '*';
    exit;
  end;

  Result := valor;
end;

function TForm3.VerificaAcesso_Se_Nao_tiver_Nenhum_bloqueio_true_senao_false : boolean;
begin
  if Length(acessoUsuVenda) > 0 then Result := false
    else Result := true;
end;

procedure TForm3.verificaDavNFCeTravado;
var
  horaAtual : TDateTime;
  arq : TStringList;
begin
  if not FileExists(ExtractFileDir(ParamStr(0)) + '\arquivo.dat') then exit;

  horaAtual := now;
  horaAtual := horaAtual - FileAgeCreate(ExtractFileDir(ParamStr(0)) + '\arquivo.dat');

  if StrToIntDef(FormatDateTime('n', horaAtual), 0) >= 5 then frmMain.reiniciaDAVNFCe;
end;

function TForm3.FileAgeCreate(const fileName: string): TDateTime;
begin
  Result := FileDateToDateTime(FileAge(fileName));
end;

procedure TForm3.inicializarImpressora();
var
  cont : integer;
begin
  cont := 0;
  while true do begin
    cont := cont + 1;
    try
      if dtmMain.ACBrPosPrinter1.Ativo = false then begin
        dtmMain.ACBrPosPrinter1.Ativar;
        Break;
      end;
    except
    end;

    if cont = 5 then begin
      Break;
    end;
  end;


  cont := 0;
  while true do begin
    cont := cont + 1;
    try
      if dtmMain.ACBrPosPrinter1.Inicializada = false then begin
        dtmMain.ACBrPosPrinter1.Inicializar;
        Break;
      end;
    except
    end;

    if cont = 5 then begin
      Break;
    end;
  end;
end;

procedure TForm3.vendeVisualTodos();
begin
  RichEdit1.Clear;
  IBClientDataSet1.First;
  while not IBClientDataSet1.Eof do begin
    vendeVISUAL;
    IBClientDataSet1.Next;
  end;

  IBClientDataSet1.First;
end;

end.

