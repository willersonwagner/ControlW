unit entrasimples;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Mask, JsEditData1, StdCtrls, Buttons, JsBotao1, ToolWin,
  ComCtrls, JsEdit1, JsEditInteiro1, ExtCtrls, Grids, DBGrids, DBCtrls,
  JsEditNumero1, DB, IBCustomDataSet, DBClient, Provider, Menus, IBQuery,
  IBDatabase;

type
  TForm17 = class(TForm)
    Panel1: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    produto: TLabel;
    codigo: JsEditInteiro;
    fornec: JsEditInteiro;
    data: JsEditData;
    chegada: JsEditData;
    codbar: JsEdit;
    quant: JsEditNumero;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    basedeb: JsEditNumero;
    debicm: JsEditNumero;
    encargos: JsEditNumero;
    frete: JsEditNumero;
    p_compra: JsEditNumero;
    lucro: JsEditNumero;
    p_venda: JsEditNumero;
    ToolBar1: TPanel;
    info: TLabel;
    Label15: TLabel;
    tot: TLabel;
    JsBotao1: JsBotao;
    DBGrid2: TDBGrid;
    Label13: TLabel;
    baseicm: JsEditNumero;
    credicm: JsEditNumero;
    agreg: JsEditNumero;
    IBQuery1: TIBQuery;
    DataSource1: TDataSource;
    IBTransaction2: TIBTransaction;
    procedure Edit11KeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure codigoKeyPress(Sender: TObject; var Key: Char);
    procedure FormShow(Sender: TObject);
    procedure codbarKeyPress(Sender: TObject; var Key: Char);
    procedure codbarKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure codigoKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure fornecKeyPress(Sender: TObject; var Key: Char);
    procedure totalExit(Sender: TObject);
    procedure DBGrid1KeyPress(Sender: TObject; var Key: Char);
    procedure DBGrid1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure p_vendaExit(Sender: TObject);
    procedure DBGrid2KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure DBGrid2Enter(Sender: TObject);
    procedure quantKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure chegadaKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure dataKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure DBGrid2CellClick(Column: TColumn);
    procedure DBGrid2KeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure JsBotao1Click(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure baseicmExit(Sender: TObject);
    procedure lucroKeyPress(Sender: TObject; var Key: Char);
    procedure DBGrid2Exit(Sender: TObject);
    procedure p_vendaKeyPress(Sender: TObject; var Key: Char);
    procedure codigoKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure DBGrid2KeyPress(Sender: TObject; var Key: Char);
    procedure FormCreate(Sender: TObject);

  private
    cont:integer;
    arr:TStringList;
    valores : array[1..13] of currency ;
    codigoProd, notaTemp, fornecTemp : String;
    usarCODBAR, usarValidade : boolean;
    procedure buscaFornecedores(cod1 : String);
    procedure trocaCodigoCodbar;
    function buscaProdutoTabelaRetornaQTD(cod, destino : String) : currency;
    procedure limpaCamposGeral;
    procedure limpaCampos;
    procedure abreDataSet;
    function ver_se_existe_fornecedor(fornec1 : String) : boolean;
    function lertotal(atualizaTotal : boolean = false) : currency;
    procedure ExcluiEntrada;
    function GravaEntradanovo() : boolean;
    function LerNome(parametrogravar:string;parametrobusca:string;cod:string;descricaoin:string):string;
    function preencheCamposProduto(cod : String) : boolean;
    function buscaDadosNota_e_preencheCampos(nota : String) : boolean;
    function verificaProdutoNaEntrada(cod : string) : boolean;
    function alteraDadosProduto : boolean;
    procedure pesquisaEntrada();
    procedure abreCadastro();

    { Private declarations }
  public
    testcampo:string;
    { Public declarations }
  end;

var
  Form17: TForm17;

implementation

uses Unit1, localizar, MaskUtils, Unit2, StrUtils, func,
  principal, cadproduto, backup;

{$R *.dfm}
function TForm17.buscaProdutoTabelaRetornaQTD(cod, destino : String) : currency;
begin
  Result := 0;
  if DBGrid2.DataSource.DataSet.IsEmpty then exit;
  
  try
  DBGrid2.DataSource.DataSet.DisableControls;
  DBGrid2.DataSource.DataSet.First;
  Result := 0;

  while not DBGrid2.DataSource.DataSet.Eof do
    begin
      if (DBGrid2.DataSource.DataSet.FieldByName('cod').AsString = cod) and (DBGrid2.DataSource.DataSet.FieldByName('destino').AsString = destino) then
        begin
          Result := DBGrid2.DataSource.DataSet.FieldByName('quant').AsCurrency;
        end;
      DBGrid2.DataSource.DataSet.Next;
    end;

  finally
    DBGrid2.DataSource.DataSet.First;
    DBGrid2.DataSource.DataSet.EnableControls;
  end;
end;

procedure TForm17.abreCadastro();
begin
  if not DBGrid2.DataSource.DataSet.IsEmpty then
    begin
      dm.IBQuery2.Close;
      dm.IBQuery2.SQL.Text := 'select cod from produto where cod = :cod';
      dm.IBQuery2.ParamByName('cod').AsString := DBGrid2.DataSource.DataSet.fieldbyname('cod').AsString;
      dm.IBQuery2.Open;

      if dm.IBQuery2.IsEmpty then
        begin
          MessageDlg('Este Produto Não Existe no Estoque!', mtError, [mbOK], 1);
          dm.IBQuery2.Close;
          exit;
        end;
        
      dm.IBQuery2.Close;  

      form9 := tform9.Create(self);
      JsEdit.SetTabelaDoBd(form9,'produto',dm.IBQuery1);
      form9.cod.Text := DBGrid2.DataSource.DataSet.fieldbyname('cod').AsString;
      form9.cod.SelecionaDoBD(form9.Name);
      form9.ShowModal;
      JsEdit.LiberaMemoria(form9);
      form9.Free;
    end;
end;

procedure TForm17.pesquisaEntrada();
var
  ds1 : TDataSource;
begin
  //DBGrid2.DataSource := nil;
  dm.IBQuery4.Close;
  dm.IBQuery4.SQL.Clear;
  dm.IBQuery4.SQL.Add('select v.nota, v.fornec as codfornec, (select nome from fornecedor f where f.cod = v.fornec) as fornec, v.data, v.chegada, v.total_nota from entrada v order by v.chegada desc');
  dm.IBQuery4.Open;
  //dm.IBQuery4.FieldByName('fornec1').Visible := false;

  dm.IBselect.Close;
  dm.IBselect.SQL.Clear;
  dm.IBselect.SQL.Add('select p.cod, c.nome, p.quant, p.p_compra, p.total from item_entrada p, produto c where (c.cod = p.cod) and (p.nota = :nota)');
  dm.IBselect.ParamByName('nota').AsString := dm.IBQuery4.fieldbyname('nota').AsString;
  dm.IBselect.Open;

  form44 := tform44.Create(self);
  form44.Caption := 'Entradas';
  form44.Label1.Caption := 'Itens da Entrada';

  ds1 := TDataSource.Create(self);
  ds1.DataSet := dm.IBQuery4;
  funcoes.FormataCampos(dm.ibquery4,2,'',2);
  funcoes.FormataCampos(dm.ibselect,2,'',2);

  form44.DBGrid1.DataSource := ds1;
  form44.DBGrid2.DataSource := dm.ds1;
  form44.ShowModal;
  //form44.Free;
  dm.IBselect.Close;
  dm.IBQuery4.Close;
end;

function TForm17.alteraDadosProduto : boolean;
begin
  Result := false;
  if baseicm.getValor <> valores[1] then Result := true
   else if credicm.getValor <> valores[2] then Result := true
   else if debicm.getValor <> valores[3] then Result := true
   else if basedeb.getValor <> valores[5] then Result := true
   else if encargos.getValor <> valores[6] then Result := true
   else if frete.getValor <> valores[7] then Result := true
   else if p_compra.getValor <> valores[8] then Result := true
   else if lucro.getValor <> valores[9] then Result := true
   else if p_venda.getValor <> valores[10] then Result := true;

  if Result then
    begin
      dm.IBQuery3.Close;
      dm.IBQuery3.SQL.Clear;
      dm.IBQuery3.SQL.Add('update produto set basecred = :basecred, credicm = :credicm, debicm = :debicm, basedeb = :basedeb, encargos = :encargos, frete = :frete, p_compra = :p_compra, lucro = :lucro, p_venda = :p_venda where cod = :cod');
      dm.IBQuery3.ParamByName('basecred').AsCurrency := baseicm.getValor;
      dm.IBQuery3.ParamByName('credicm').AsCurrency  := credicm.getValor;
      dm.IBQuery3.ParamByName('debicm').AsCurrency   := debicm.getValor;
      dm.IBQuery3.ParamByName('basedeb').AsCurrency  := basedeb.getValor;
      dm.IBQuery3.ParamByName('encargos').AsCurrency := encargos.getValor;
      dm.IBQuery3.ParamByName('frete').AsCurrency    := frete.getValor;
      dm.IBQuery3.ParamByName('p_compra').AsCurrency := p_compra.getValor;
      dm.IBQuery3.ParamByName('lucro').AsCurrency    := lucro.getValor;
      dm.IBQuery3.ParamByName('p_venda').AsCurrency  := p_venda.getValor;
      dm.IBQuery3.ParamByName('cod').AsString  := codigoProd;
      try
        dm.IBQuery3.ExecSQL;
        dm.IBQuery3.Transaction.Commit;
      except
        on e : exception do
          begin
            gravaErrosNoArquivo(e.Message,'Entrada de Produtos','151','alteraDadosProduto');
            dm.IBQuery3.Transaction.Rollback;
          end;
      end;
    end;

  {baseicm.Text := dm.IBQuery3.fieldbyname('basecred').AsString;
  valores[1] := dm.IBQuery3.fieldbyname('basecred').AsCurrency;

  credicm.Text := dm.IBQuery3.fieldbyname('credicm').AsString;
  valores[2] := dm.IBQuery3.fieldbyname('credicm').AsCurrency;

  debicm.Text := dm.IBQuery3.fieldbyname('debicm').AsString;
  valores[3] := dm.IBQuery3.fieldbyname('debicm').AsCurrency;

  quant.Text := dm.IBQuery3.fieldbyname('quant').AsString;
  valores[4] := dm.IBQuery3.fieldbyname('quant').AsCurrency;

  basedeb.Text := dm.IBQuery3.fieldbyname('debicm').AsString;
  valores[5] := dm.IBQuery3.fieldbyname('debicm').AsCurrency;

  encargos.Text := dm.IBQuery3.fieldbyname('encargos').AsString;
  valores[6] := dm.IBQuery3.fieldbyname('encargos').AsCurrency;

  frete.Text := dm.IBQuery3.fieldbyname('frete').AsString;
  valores[7] := dm.IBQuery3.fieldbyname('frete').AsCurrency;

  p_compra.Text := dm.IBQuery3.fieldbyname('p_compra').AsString;
  valores[8] := dm.IBQuery3.fieldbyname('p_compra').AsCurrency;

  lucro.Text := dm.IBQuery3.fieldbyname('lucro').AsString;
  valores[9] := dm.IBQuery3.fieldbyname('lucro').AsCurrency;

  p_venda.Text := dm.IBQuery3.fieldbyname('P_venda').AsString;
  valores[10] := dm.IBQuery3.fieldbyname('P_venda').AsCurrency;}
end;

function TForm17.verificaProdutoNaEntrada(cod : string) : boolean;
var
  inde : integer;
  tr : String;
begin
  Result := false;
  dm.IBQuery4.Close;
  dm.IBQuery4.SQL.Clear;
  dm.IBQuery4.SQL.Add('select cod from produto where ((cast(cod as char(20))  = :cod) or (codbar = :codbar))');
  dm.IBQuery4.ParamByName('cod').AsString := cod;
  dm.IBQuery4.ParamByName('codbar').AsString := cod;
  dm.IBQuery4.Open;

  tr := dm.IBQuery4.fieldbyname('cod').AsString;
  dm.IBQuery4.Close;

  if cod <> '' then
    begin
      DBGrid2.DataSource.DataSet.DisableControls;
      if tibquery(DBGrid2.DataSource.DataSet).Locate('cod', tr, []) then
        begin
          tibquery(DBGrid2.DataSource.DataSet).First;
        end;
       tibquery(DBGrid2.DataSource.DataSet).EnableControls;
    end;

end;

function TForm17.buscaDadosNota_e_preencheCampos(nota : String) : boolean;
begin
  dm.IBQuery1.SQL.Clear;
  dm.IBQuery1.SQL.Add('select data,chegada from entrada where (nota = :nota) and (fornec = :fornec)');
  dm.IBQuery1.ParamByName('nota').AsString   := codigo.Text;
  dm.IBQuery1.ParamByName('fornec').AsString := fornec.Text;
  dm.IBQuery1.Open;
  if not dm.IBQuery1.IsEmpty then
    begin
      data.Text := FormatDateTime('dd/mm/yyyy', dm.IBQuery1.fieldbyname('data').AsDateTime);
      chegada.Text := FormatDateTime('dd/mm/yyyy', dm.IBQuery1.fieldbyname('chegada').AsDateTime);
      //fornec.Text := dm.IBQuery1.fieldbyname('fornec').AsString;
      data.SetFocus;
      tot.Caption := FormatCurr('#,##,###0.00',lertotal);
    end
  else
    begin
      data.Text    := FormatDateTime('dd/mm/yyyy', form22.datamov);
      chegada.Text := FormatDateTime('dd/mm/yyyy', form22.datamov);
      limpaCampos;
      //fornec.Text := '';
    end;
 dm.IBQuery1.Close;
end;

function TForm17.preencheCamposProduto(cod : String) : boolean;
begin
  Result := false;

  if usarCODBAR then
    begin
      dm.IBQuery3.Close;
      dm.IBQuery3.SQL.Clear;
      dm.IBQuery3.SQL.Add('select p.cod, nome, AGREGADO,basecred,basedeb,credicm,debicm,p_compra,lucro,p_venda,frete,encargos,quant from produto p left join codbarras c on ((c.cod = p.cod)) where (p.codbar = '+QuotedStr(cod)+') or ((c.codbar = '+QuotedStr(cod)+') and (c.cod = p.cod))');
      dm.IBQuery3.Open;
    end
  else
    begin
      dm.IBQuery3.Close;
      dm.IBQuery3.SQL.Clear;
      dm.IBQuery3.SQL.Add('select cod,nome,AGREGADO,basecred,basedeb,credicm,debicm,p_compra,lucro,p_venda,frete,encargos,quant from produto where (cast(cod as char(16)) = :cod)');
      dm.IBQuery3.ParamByName('cod').AsString := cod;
      dm.IBQuery3.Open;
    end;

  if dm.IBQuery3.IsEmpty then
    begin
      MessageDlg('Código: ' + cod + ' Não Encontrado', mtInformation, [mbok], 1);
      exit;
    end;

      try
  codigoProd := dm.IBQuery3.fieldbyname('cod').AsString;
  produto.Caption := dm.IBQuery3.fieldbyname('nome').AsString;

  baseicm.Text := iif(trim(dm.IBQuery3.fieldbyname('basecred').AsString) = '', '0,00', FormatCurr('#,###,###0.00', dm.IBQuery3.fieldbyname('basecred').AsCurrency));
  valores[1] := iif(trim(dm.IBQuery3.fieldbyname('basecred').AsString) = '', 0, dm.IBQuery3.fieldbyname('basecred').AsCurrency);

  credicm.Text := iif(trim(dm.IBQuery3.fieldbyname('credicm').AsString) = '', '0,00', FormatCurr('#,###,###0.00', dm.IBQuery3.fieldbyname('credicm').AsCurrency));
  valores[2] := iif(trim(dm.IBQuery3.fieldbyname('credicm').AsString) = '', 0, dm.IBQuery3.fieldbyname('credicm').AsCurrency);

  debicm.Text := iif(trim(dm.IBQuery3.fieldbyname('debicm').AsString) = '', '0,00', FormatCurr('#,###,###0.00', dm.IBQuery3.fieldbyname('debicm').AsCurrency));
  valores[3] := iif(trim(dm.IBQuery3.fieldbyname('debicm').AsString) = '', 0, dm.IBQuery3.fieldbyname('debicm').AsCurrency);

  quant.Text := iif(trim(dm.IBQuery3.fieldbyname('quant').AsString) = '', '0,00', FormatCurr('#,###,###0.00', dm.IBQuery3.fieldbyname('quant').AsCurrency));
  valores[4] := iif(trim(dm.IBQuery3.fieldbyname('quant').AsString) = '', 0, dm.IBQuery3.fieldbyname('quant').AsCurrency);

  basedeb.Text := iif(trim(dm.IBQuery3.fieldbyname('basedeb').AsString) = '', '0,00', FormatCurr('#,###,###0.00', dm.IBQuery3.fieldbyname('basedeb').AsCurrency));
  valores[5] := iif(trim(dm.IBQuery3.fieldbyname('basedeb').AsString) = '', 0, dm.IBQuery3.fieldbyname('basedeb').AsCurrency);

  encargos.Text := iif(trim(dm.IBQuery3.fieldbyname('encargos').AsString) = '', '0,00', FormatCurr('#,###,###0.00', dm.IBQuery3.fieldbyname('encargos').AsCurrency));
  valores[6] := iif(trim(dm.IBQuery3.fieldbyname('encargos').AsString) = '', 0, dm.IBQuery3.fieldbyname('encargos').AsCurrency);

  frete.Text := iif(trim(dm.IBQuery3.fieldbyname('frete').AsString) = '', '0,00', FormatCurr('#,###,###0.00', dm.IBQuery3.fieldbyname('frete').AsCurrency));
  valores[7] := iif(trim(dm.IBQuery3.fieldbyname('frete').AsString) = '', 0, dm.IBQuery3.fieldbyname('frete').AsCurrency);

  p_compra.Text := iif(trim(dm.IBQuery3.fieldbyname('p_compra').AsString) = '', '0,00', FormatCurr('#,###,###0.000', dm.IBQuery3.fieldbyname('p_compra').AsCurrency));
  valores[8] := iif(trim(dm.IBQuery3.fieldbyname('p_compra').AsString) = '', 0, dm.IBQuery3.fieldbyname('p_compra').AsCurrency);

  lucro.Text := iif(trim(dm.IBQuery3.fieldbyname('lucro').AsString) = '', '0,00', FormatCurr('#,###,###0.00', dm.IBQuery3.fieldbyname('lucro').AsCurrency));
  valores[9] := iif(trim(dm.IBQuery3.fieldbyname('lucro').AsString) = '', 0, dm.IBQuery3.fieldbyname('lucro').AsCurrency);

  p_venda.Text := iif(trim(dm.IBQuery3.fieldbyname('p_venda').AsString) = '', '0,00', FormatCurr('#,###,###0.000', dm.IBQuery3.fieldbyname('p_venda').AsCurrency));
  valores[10] := iif(trim(dm.IBQuery3.fieldbyname('P_venda').AsString) = '', 0, dm.IBQuery3.fieldbyname('P_venda').AsCurrency);

  agreg.setValor(dm.IBQuery3.fieldbyname('AGREGADO').AsCurrency);

  except
    dm.IBQuery3.Close;
    ShowMessage('ocorreu um erro de conversão, verifique se os campos estão preenchidos corretamente');
    Result := false;
  end;
  Result := true;

  dm.IBQuery3.Close;
end;

function TForm17.ver_se_existe_fornecedor(fornec1 : String) : boolean;
begin
  Result := false;
  dm.IBQuery4.Close;
  dm.IBQuery4.SQL.Clear;
  dm.IBQuery4.SQL.Add('select cod from fornecedor where cod = :cod');
  dm.IBQuery4.ParamByName('cod').AsString := fornec1;
  dm.IBQuery4.Open;
  if not dm.IBQuery4.IsEmpty then
    begin
      dm.IBQuery4.Close;
      Result := true;
      exit;
    end
  else ShowMessage('Fornecedor não encontrado');

  dm.IBQuery4.Close;
  dm.IBQuery4.SQL.Text := 'select nota from entrada where nota = :nota and fornec = :fornec';
  dm.IBQuery4.ParamByName('nota').AsString   := StrNum(codigo.Text);
  dm.IBQuery4.ParamByName('fornec').AsString := StrNum(fornec.Text);
  dm.IBQuery4.Open;
  if not dm.IBQuery4.IsEmpty then
    begin
      dm.IBQuery4.Close;
      Result := true;
      exit;
    end
  else ShowMessage('Fornecedor não encontrado');
end;

procedure TForm17.abreDataSet;
begin
  IBQuery1.Close;
  IBQuery1.SQL.Text := ('select a.cod,  a.nota, p.nome as descricao, a.destino, a.quant, a.p_compra, a.total, c.nome as usuario,' +
  ' a.codentrada, iif(a.validade < ''01.01.2000'', null, a.validade) as validade from ITEM_ENTRADA a ' +
  ' left join produto p on (a.cod = p.cod) ' +
  ' left join usuario c on (a.usuario = c.cod) ' +
  ' where (a.nota = :nota) and (a.fornec = :fornec)');
  IBQuery1.ParamByName('nota').AsString   := codigo.Text;
  IBQuery1.ParamByName('fornec').AsString := fornec.Text;
  IBQuery1.open;
  IBQuery1.FieldByName('codentrada').Visible := false;
  IBQuery1.FieldByName('nota').Visible := false;
  funcoes.FormataCampos(IBQuery1,2,'p_compra',3);

  DBGrid2.DataSource := DataSource1;

  TcurrencyField(IBQuery1.FieldByName('p_compra')).DisplayFormat := '###,##0.000';
end;

procedure TForm17.limpaCampos;
begin
  quant.Text := '0,00';
  credicm.Text := '0,00';
  baseicm.Text := '0,00';
  basedeb.Text := '0,00';
  baseicm.Text := '0,00';
  encargos.Text := '0,00';
  frete.Text := '0,00';
  p_venda.Text := '0,00';
  lucro.Text := '0,00';
  p_compra.Text := '0,00';
  codbar.Text := '';
end;

procedure TForm17.limpaCamposGeral;
begin
  codigo.Text := '';
  fornec.Text := '';
  chegada.Text := '';
  data.Text := '';
  quant.Text := '0,00';
  credicm.Text := '0,00';
  baseicm.Text := '0,00';
  basedeb.Text := '0,00';
  baseicm.Text := '0,00';
  encargos.Text := '0,00';
  frete.Text := '0,00';
  p_venda.Text := '0,00';
  lucro.Text := '0,00';
  p_compra.Text := '0,00';
  codbar.Text := '';
  produto.Caption := '';

  codigo.Enabled := true;
  codigo.SetFocus;
end;

function tform17.lertotal(atualizaTotal : boolean = false) : currency;
var i:integer;
  acc:currency;
begin
 DBGrid2.DataSource.DataSet.Active := true;
 i := DBGrid2.DataSource.DataSet.RecNo;
 DBGrid2.DataSource.DataSet.DisableControls;
 DBGrid2.DataSource.DataSet.First;
 acc := 0;
 while not DBGrid2.DataSource.DataSet.Eof do
   begin
     acc := acc + funcoes.ArredondaFinanceiro(DBGrid2.DataSource.DataSet.fieldbyname('quant').AsCurrency * DBGrid2.DataSource.DataSet.fieldbyname('p_compra').AsCurrency,2);
     DBGrid2.DataSource.DataSet.Next;
    end;

 if atualizaTotal then
   begin
     dm.IBQuery3.Close;
     dm.IBQuery3.SQL.Text := 'update entrada set total_nota = :total where nota = :nota and fornec = :fornec';
     dm.IBQuery3.ParamByName('total').AsCurrency := acc;
     dm.IBQuery3.ParamByName('nota').AsString   := codigo.Text;
     dm.IBQuery3.ParamByName('fornec').AsString := fornec.Text;
     dm.IBQuery3.ExecSQL;
     dm.IBQuery3.Transaction.Commit;
   end;
   result := acc;
   abreDataSet;

   DBGrid2.DataSource.DataSet.RecNo := (i);
   DBGrid2.DataSource.DataSet.EnableControls;
end;

function tform17.LerNome(parametrogravar:string;parametrobusca:string;cod:string;descricaoin:string):string;
begin

  if cont<>1 then
    begin
      arr := TStringList.Create;
      cont:=1;
    end;
  if AnsiContainsText(parametrogravar,'1') then
    begin
      arr.add(cod + '='+descricaoin);
    end;
  if AnsiContainsText(parametrogravar,'2') then
    begin
       arr.Free;
    end;
  if AnsiContainsText(parametrobusca,'1')then
    begin
      try
        Result:= arr.Values[cod];
      except
      end;
      if Result='' then
        begin
          try
            {dm.IBselect.Close;
            dm.IBselect.SQL.Clear;
            dm.IBselect.SQL.Add('select nome from produto where cod='+dm.IBQuery2.fieldbyname('cod').AsString);
            dm.IBselect.Open;
            result := dm.IBselect.fieldbyname('nome').AsString;
            dm.IBselect.Close; }
            if not DBGrid2.DataSource.DataSet.IsEmpty then result := DBGrid2.DataSource.DataSet.fieldbyname('descricao').AsString;
          except
          end;
        end;
    end
    else Result:='';
end;

function TForm17.GravaEntradanovo() : boolean;
var
  campo, cod, nota, tabela, destino, sim, validade : string;
  total, qtd :currency;
begin
  Result := false;
  sim := '';
  qtd := 0;

  //codigoProd é uma variavel de codigo do produto, para que ser for feito entrada
  //por codigo de barras ele preeche essa variavel com o codigo do produto

  if usarValidade then
    begin
      validade := funcoes.dialogo('data',0,'',2,false,'','Entrada Simples','Qual a Data de Validade ?','');
      if validade = '*' then exit;
    end;

  if Length(StrNum(validade)) <> 6 then validade := '01/01/1900';

  destino := funcoes.dialogo('generico',0,'12',0,true,'S','Control For Windows','Destino 1-Loja 2-Depósito','1');
  if destino = '*' then exit;

  try
  if DBGrid2.DataSource.DataSet.RecordCount > 0 then
  begin
  if DBGrid2.DataSource.DataSet.Locate('cod', codigoProd, []) then
    begin
      qtd := buscaProdutoTabelaRetornaQTD(codigoProd, destino);
      if qtd <> 0 then
        begin
          sim := funcoes.dialogo('generico', 0, 'SN', 0, true, 'S', 'Control For Windows', 'Este Produto  já Existe Nesta Nota, Deseja Alterar?SIM ou NÃO (S/N)','S') ;
          if sim = '*' then exit;

          if sim = 'N' then
            begin
              codbar.Text := '';
              codbar.SetFocus;
              exit;
            end
          else
            begin
              funcoes.baixaEstoque(codigoProd, -qtd, StrToInt(destino));
            end;

        end;
    end;
   end; 
   except
   end;


  nota := codigo.Text;
  dm.IBQuery4.SQL.Clear;
  dm.IBQuery4.SQL.Add('select sum(total) as total from item_entrada where nota = :nota and fornec = :fornec'  );
  dm.IBQuery4.ParamByName('nota').AsString   := nota;
  dm.IBQuery4.ParamByName('fornec').AsString := strnum(fornec.text);
  dm.IBQuery4.Open;

  total := dm.IBQuery4.FieldByName('total').AsCurrency;
  dm.IBQuery4.Close;

  dm.IBQuery4.SQL.Clear;
  dm.IBQuery4.SQL.Add('update or insert into entrada(nota, data,chegada,total_nota,fornec) VALUES  (:nota, :data,:chegada,:total_nota,:fornec) matching(nota, fornec) ');
  dm.IBQuery4.ParamByName('nota').AsString         := nota;
  dm.IBQuery4.ParamByName('chegada').AsDateTime    := StrToDate(chegada.Text);
  dm.IBQuery4.ParamByName('total_nota').AsCurrency := funcoes.ArredondaFinanceiro((quant.getValor * p_compra.getValor) + total, 2);
  dm.IBQuery4.ParamByName('data').AsDateTime       := StrToDate(data.Text);
  dm.IBQuery4.ParamByName('fornec').AsString       := fornec.Text;
  try
    dm.IBQuery4.ExecSQL;
  except
  end;

  dm.IBQuery4.Close;
  dm.IBQuery4.SQL.Clear;
  dm.IBQuery4.SQL.Add('update or insert into item_entrada(validade,COD, fornec,codentrada, QUANT, P_COMPRA, DESTINO, USUARIO, NOTA, DATA,total) '+
  'values(:validade,:COD, :fornec,'+funcoes.novocod('entrada')+',:QUANT,'+
  ' :P_COMPRA, :DESTINO, :USUARIO,  :NOTA, :DATA,:total) matching(cod, nota, fornec, destino)');
  dm.IBQuery4.ParamByName('validade').AsDateTime := StrToDate(validade);
  dm.IBQuery4.ParamByName('data').AsDateTime     := StrToDateDef(data.Text, now);
  dm.IBQuery4.ParamByName('cod').AsString        := codigoProd;
  dm.IBQuery4.ParamByName('fornec').AsString     := fornec.Text;
  dm.IBQuery4.ParamByName('nota').AsString       := codigo.Text;
  dm.IBQuery4.ParamByName('quant').AsCurrency    := quant.getValor;
  dm.IBQuery4.ParamByName('P_compra').AsCurrency := p_compra.getValor;
  dm.IBQuery4.ParamByName('destino').AsInteger   := StrToIntDef(destino, 1);
  dm.IBQuery4.ParamByName('usuario').AsString    := form22.codusario;
  dm.IBQuery4.ParamByName('total').AsCurrency    := funcoes.ArredondaFinanceiro(quant.getValor * p_compra.getValor, 2);
  dm.IBQuery4.ExecSQL;
  cod := codbar.Text;

  if destino = '1' then campo := 'quant'
    else campo := 'deposito';

  tabela := 'entrada';

 { dm.IBQuery4.Close;
  dm.IBQuery4.SQL.Clear;

  if sim <> '' then
    begin
      dm.IBQuery4.SQL.Add('update produto set '+campo+'= (('+campo+' - :valor) + :quant) where cod= :cod');
      dm.IBQuery4.ParamByName('valor').AsCurrency := DBGrid2.DataSource.DataSet.fieldbyname('quant').AsCurrency;
    end
  else dm.IBQuery4.SQL.Add('update produto set '+campo+'='+campo+'+ :quant where cod= :cod');

  dm.IBQuery4.ParamByName('quant').AsCurrency  := quant.getValor;
  dm.IBQuery4.ParamByName('cod').AsString := codigoProd;
  try
    dm.IBQuery4.ExecSQL;
    dm.IBQuery4.Transaction.Commit;
  except
  end;
  }

  funcoes.baixaEstoque(codigoProd, quant.getValor, StrToIntDef(destino, 1));

  try
    if dm.IBQuery4.Transaction.InTransaction then dm.IBQuery4.Transaction.Commit;
    if dm.IBQuery1.Transaction.InTransaction then dm.IBQuery1.Transaction.Commit; //gravar quantidade
  except
  end;

  Result := true;

  alteraDadosProduto;

  abreDataSet;
  tot.Caption := CurrToStrf(lertotal,ffcurrency,2);
  limpaCampos;

end;

procedure tform17.ExcluiEntrada;
var
  ult : Smallint;
  nota, cod, campo, unid : string;
  total, quant : currency;
begin
 begin
    if messageDlg('Deseja Excluir?', mtConfirmation, [mbyes, mbNo], 0) = mrYes then
     begin
      if dm.IBQuery1.Transaction.InTransaction then dm.IBQuery1.Transaction.Commit;
      dm.IBQuery1.Transaction.StartTransaction;
      ult := 0;
      nota := DBGrid2.DataSource.DataSet.fieldbyname('nota').AsString;

      dm.IBselect.Close;
      dm.IBselect.SQL.Clear;
      dm.IBselect.SQL.Add('select nota from item_entrada where nota = :nota');
      dm.IBselect.ParamByName('nota').AsString := nota;
      dm.IBselect.Open;
      dm.IBselect.FetchAll;

      if dm.IBselect.RecordCount = 1 then ult := 1;

      cod := DBGrid2.DataSource.DataSet.FieldByName('codentrada').AsString;
      dm.IBselect.Close;
      dm.IBselect.SQL.Clear;
      dm.IBselect.SQL.Add('select total, unid from item_entrada where codentrada = :cod');
      dm.IBselect.ParamByName('cod').AsString := cod;
      dm.IBselect.Open;

      quant := funcoes.verValorUnidade(dm.IBselect.fieldbyname('unid').AsString);

      total := dm.IBselect.fieldbyname('total').AsCurrency;
      dm.IBselect.Close;

      quant := quant * DBGrid2.DataSource.DataSet.fieldbyname('quant').AsCurrency;

      cod   := DBGrid2.DataSource.DataSet.fieldbyname('cod').AsString;
      campo := DBGrid2.DataSource.DataSet.fieldbyname('destino').AsString;

      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add('delete from item_entrada where codentrada = :cod');
      dm.IBQuery1.ParamByName('cod').AsString := DBGrid2.DataSource.DataSet.fieldbyname('codentrada').AsString;
      dm.IBQuery1.ExecSQL;

      if campo = '1' then campo:='quant'
        else campo:='deposito';

      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add('update produto set '+campo+'='+campo+'- :quant where cod='+cod);
      dm.IBQuery1.ParamByName('quant').AsCurrency := quant;
      dm.IBQuery1.ExecSQL;

      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add('update entrada set total_nota = total_nota - :quant where nota='+nota);
      dm.IBQuery1.ParamByName('quant').AsCurrency := total;
      dm.IBQuery1.ExecSQL;

      if ult = 1 then
        begin
          dm.IBQuery1.Close;
          dm.IBQuery1.SQL.Clear;
          dm.IBQuery1.SQL.Add('delete from entrada where ((nota = :nota) and (fornec = :fornec))');
          dm.IBQuery1.ParamByName('nota').AsString   := nota;
          dm.IBQuery1.ParamByName('fornec').AsString := fornec.text;
          dm.IBQuery1.ExecSQL;
        end;
      try
        if dm.IBQuery1.Transaction.InTransaction then dm.IBQuery1.Transaction.Commit;

        if ult = 1 then
          begin
            limpaCamposGeral;
          end;
      except
        WWMessage('Ocorreu Um Erro Inesperado. Tente Novamente!',mtWarning,[mbOK],clYellow,true,false,clred);
        exit;
      end;

      DBGrid2.DataSource.DataSet.Active := false;
      DBGrid2.DataSource.DataSet.Active := true;
      funcoes.FormataCampos(IBQuery1,2,'',2);
      DBGrid2.DataSource.DataSet.FieldByName('codentrada').Visible := false;
      DBGrid2.DataSource.DataSet.FieldByName('nota').Visible       := false;
      lertotal(true);
   end;
  end;


end;


procedure TForm17.Edit11KeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = 116) then tedit(sender).Text := funcoes.localizar('Localizar Produto','produto',' cod,nome ','cod','cod','nome','nome',false,false,false,'',300,sender);
end;



procedure TForm17.codigoKeyPress(Sender: TObject; var Key: Char);
begin
   if key=#27 then
     begin
       DBGrid2.DataSource.DataSet.Close;
       close;
     end;

   if (key = #13) then
     begin
       buscaFornecedores(codigo.Text);
     end;

  { if (key=#13) and (tedit(sender).Text<>'') then
     begin
       try
         abreDataSet;
         buscaDadosNota_e_preencheCampos(codigo.Text);
         tot.Caption := CurrToStrf(lertotal,ffCurrency,2);
       except
         exit;
       end;
   end;
  }
 if (key = #13) and (tedit(sender).Text='') then
   begin
     tedit(sender).Text := funcoes.DeletaChar('/',FormatDateTime('dd/mm/yy',form22.datamov));
    // buscaDadosNota_e_preencheCampos(codigo.Text);
    // abreDataSet;
    // tot.Caption:=CurrToStrf(lertotal,ffCurrency,2);
   end;

end;

procedure TForm17.FormShow(Sender: TObject);
begin
   data.Text := FormatDateTime('dd/mm/yyyy', form22.datamov);
   chegada.Text := FormatDateTime('dd/mm/yyyy', form22.datamov);
   abreDataSet;
   JsEdit.SetTabelaDoBd(self, 'entrada', dm.IBQuery1);
   produto.Width := 0;

   usarValidade := false;
   if funcoes.buscaParamGeral(58, 'N') = 'S' then usarValidade := true;
//   if ConfParamGerais.Strings[13] = 'S' then  Label5.Caption := 'Cod. de Barras:';
end;

procedure TForm17.codbarKeyPress(Sender: TObject; var Key: Char);
begin
   if usarCODBAR = false then
     begin
       funcoes.somenteNumeros(key);
     end;

   if (key=#13) and (tedit(sender).Text='') then
   begin
     form9 := TForm9.Create(self);
     funcoes.CtrlResize(tform(form9));
     form9.SetComponenteRetorno(jsedit(sender));

     //cadastrar Produtos em série
     if ConfParamGerais[30] = 'S' then form9.entrada := 1;
     //cadastrar produtos em série

     form9.ShowModal;
     JsEdit.LiberaMemoria(form9);
     form9.Free;

     if codbar.Text <> '' then
       begin
         if usarCODBAR then
           begin
             trocaCodigoCodbar;
           end;
       end;
     //exit;
     //codbar.Text := funcoes.localizar('Localizar Produto','produto','cod,nome','cod','','nome','nome',FALSE,false,false,'',0,sender);
   end;

  if (key=#13) and (codbar.Text <>'') then
    begin
     { if verificaProdutoNaEntrada(codbar.Text) then
        begin
          key := #0;
          exit;
        end;
      }if not preencheCamposProduto(codbar.Text) then key := #0;
    end;
end;

procedure TForm17.codbarKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  cod : string;
begin
if (Key = 116)  then
   begin
     cod := DBGrid2.DataSource.DataSet.fieldbyname('cod').AsString;
     codbar.Text := funcoes.localizar1('Localizar Produto','produto','cod, nome,quant, p_venda as preco ','cod','','nome','nome',false,false,false,'cod', cod,600,sender);
     if codbar.Text <> '' then
       begin
         if usarCODBAR then
           begin
             trocaCodigoCodbar;
           end;
       end;
   end;
end;

procedure TForm17.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  JsEdit.LiberaMemoria(self);
  DBGrid2.DataSource.DataSet.Close;
  dm.IBQuery1.Close;
  dm.IBselect.Close;
end;

procedure TForm17.codigoKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
if (Key = 119)  then
  begin
    pesquisaEntrada;
    tedit(sender).Text := iif(funcoes.retornoLocalizar = '*', '', funcoes.retornoLocalizar);
    dm.IBselect.Close;
    dm.IBQuery4.Close;
    form44.Free;
  end;
end;

procedure TForm17.fornecKeyPress(Sender: TObject; var Key: Char);
begin
    if (key=#13) then
     begin
       if (tedit(sender).Text = '') then fornec.Text := funcoes.localizar('Localizar Fornecedor','fornecedor','cod,nome','cod','','nome','nome',true,false,false,'',0, nil);
       if (tedit(sender).Text <> '') then
         begin
           if not ver_se_existe_fornecedor(tedit(sender).Text) then
             begin
               key := #0;
               exit;
             end
           else
             begin
               self.Caption := 'Entrada Simples: Fornec => ' + funcoes.BuscaNomeBD(dm.ibquery3, 'nome', 'fornecedor', 'where cod = ' + fornec.Text);
             end;
         end;

       try
         notaTemp   := codigo.Text;
         fornecTemp := fornec.Text;
         abreDataSet;
         buscaDadosNota_e_preencheCampos(codigo.Text);
         tot.Caption := CurrToStrf(lertotal,ffCurrency,2);
       except
         exit;
       end;
       exit;
     end;

  { if (Key = #13) then
     begin
     //  if (fornec.Text='')  then
       if tedit(sender).Text <> '' then
         begin
           if not ver_se_existe_fornecedor(tedit(sender).Text) then key := #0;
         end
       else
         begin
           if key = #13 then key := #0;
         end;
     end;
}
end;

procedure TForm17.totalExit(Sender: TObject);
begin
   fornec.SetFocus;
end;



procedure TForm17.DBGrid1KeyPress(Sender: TObject; var Key: Char);
begin
    if key=#46 then
  begin
   try
     ExcluiEntrada;
   except
     ShowMessage('Não foi possivel efetuar a operação. Tente novamente');
   end;
  end;

end;

procedure TForm17.DBGrid1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key=46 then
  begin
   try
     ExcluiEntrada;
   except
   end;
end;
end;
procedure TForm17.p_vendaExit(Sender: TObject);
begin
  {form9 := tform9.Create(self);
  //form9.CALCLUCRO1(lucro, p_venda, debicm, basedeb, credicm, p_compra, frete, encargos, baseicm, encargos, key);
  form9.CALCPRE(lucro, p_venda, debicm, basedeb, credicm, p_compra, frete, encargos, baseicm, encargos);
  JsEdit.LiberaMemoria(form9);
  form9.Free;
   }
  if testcampo='fornec' then fornec.SetFocus;
  if testcampo='codbar' then codbar.SetFocus;
  //if (testcampo<>'codbar') and (testcampo<>'fornec') then codbar.SetFocus;
end;

procedure TForm17.DBGrid2KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
if key=27 then data.SetFocus;

 if key=46 then
  begin
   try
     ExcluiEntrada;
     tot.Caption := CurrToStrf(LerTotal,ffCurrency,2);
   except
   end;
  end;
  
  if key = 113 then abreCadastro();
end;

procedure TForm17.DBGrid2Enter(Sender: TObject);
begin
  try
    produto.Caption := LerNome('','1',DBGrid2.Columns[0].Field.AsString,'');
  except
  end;

  if not DBGrid2.DataSource.DataSet.IsEmpty then Label13.Caption := 'F2 - Abre Cadastro'
end;

procedure TForm17.quantKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
 if key=116 then DBGrid2.SetFocus;
end;

procedure TForm17.chegadaKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
if key=116 then DBGrid2.SetFocus;
end;

procedure TForm17.dataKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key=116 then DBGrid2.SetFocus;
end;

procedure TForm17.DBGrid2CellClick(Column: TColumn);
begin
  try
    produto.Caption := LerNome('','1',DBGrid2.Columns[0].Field.AsString,'');
  except
  end;
end;

procedure TForm17.DBGrid2KeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
if key=40 then produto.Caption := LerNome('','1',DBGrid2.Columns[0].Field.AsString,'');
if key=38 then produto.Caption := LerNome('','1',DBGrid2.Columns[0].Field.AsString,'');
end;

procedure TForm17.JsBotao1Click(Sender: TObject);
var
  ok : boolean;
begin
   if (codbar.Text = '') and (notaTemp + fornecTemp <> '') then
     begin
       if messageDlg('Deseja ALTERAR os dados da nota '+ notaTemp +' ?', mtConfirmation, [mbyes, mbNo], 0) = mrYes then
         begin
           dm.IBQuery3.Close;
           dm.IBQuery3.SQL.Clear;
           dm.IBQuery3.SQL.Add('update entrada set nota = :nota, fornec = :fornec, data = :data, chegada = :chegada where ((nota = :nota1) and (fornec = :fornec1))');
           dm.IBQuery3.ParamByName('nota').AsString      := codigo.Text;
           dm.IBQuery3.ParamByName('fornec').AsString    := fornec.Text;
           dm.IBQuery3.ParamByName('data').AsDateTime    := StrToDateDef(data.Text, now);
           dm.IBQuery3.ParamByName('chegada').AsDateTime := StrToDateDef(chegada.Text, now);
           dm.IBQuery3.ParamByName('nota1').AsString     := notaTemp;
           dm.IBQuery3.ParamByName('fornec1').AsString   := fornecTemp;
           dm.IBQuery3.ExecSQL;

           dm.IBQuery3.Close;
           dm.IBQuery3.SQL.Clear;
           dm.IBQuery3.SQL.Add('update item_entrada set nota = :nota, fornec = :fornec where ((nota = :nota1) and (fornec = :fornec1))');
           dm.IBQuery3.ParamByName('nota').AsString      := codigo.Text;
           dm.IBQuery3.ParamByName('fornec').AsString    := fornec.Text;
           dm.IBQuery3.ParamByName('nota1').AsString     := notaTemp;
           dm.IBQuery3.ParamByName('fornec1').AsString   := fornecTemp;
           dm.IBQuery3.ExecSQL;

           dm.IBQuery3.Transaction.Commit;
           codigo.Enabled := true;
           notaTemp   := '';
           fornecTemp := '';
           fornec.Text    := '';
           codigo.Text    := '';
           codigo.SetFocus;
         end;
       exit;
     end;

   ok := false;
   if (codigo.Text <> '') and (fornec.Text <> '') and (codbar.Text <> '') then
   begin
     ok := true;

     if not GravaEntradanovo then exit;

     abreDataSet;
     LerNome('1','0',codbar.Text,produto.Caption);
     codbar.SetFocus;
     tot.Caption := CurrToStrf(LerTotal,ffCurrency,2);
     DBGrid2.DataSource.DataSet.Last;
   end;
  if not(fornec.Text <> '') and not(ok) then testcampo := 'fornec';
  if not(codbar.Text <> '') and not(ok) then testcampo := 'codbar';
end;

procedure TForm17.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
   if key = 120 then //F9
     begin
       form2.ReceberNota1.Click;
       exit;
     end;

   if key = 121 then //F10
     begin
       funcoes.importaXMLnaEntrada1;
     end;
     
   if key = 117 then //F6
     begin
       if messageDlg('Deseja ALTERAR os dados da nota?', mtConfirmation, [mbyes, mbNo], 0) = mrYes then
         begin
           dm.IBQuery3.Close;
           dm.IBQuery3.SQL.Clear;
           dm.IBQuery3.SQL.Add('update entrada set fornec = :fornec, data = :data, chegada = :chegada where nota = :nota');
           dm.IBQuery3.ParamByName('fornec').AsString := fornec.Text;
           dm.IBQuery3.ParamByName('data').AsDateTime := StrToDateDef(data.Text, now);
           dm.IBQuery3.ParamByName('chegada').AsDateTime := StrToDateDef(chegada.Text, now);
           dm.IBQuery3.ParamByName('nota').AsString := codigo.Text;
           dm.IBQuery3.ExecSQL;
           dm.IBQuery3.Transaction.Commit;
         end;
     end;
end;

procedure TForm17.baseicmExit(Sender: TObject);
begin
  if JsEditNumero(sender).getValor <> 0 then
    begin
      credicm.setValor(p_compra.getValor * baseicm.getValor / 100);
    end;
end;

procedure TForm17.lucroKeyPress(Sender: TObject; var Key: Char);
begin
  if key = #13 then
    begin
      form9 := tform9.Create(self);
      form9.CALCLUCRO1(lucro, p_venda, debicm, basedeb, credicm, p_compra, frete, encargos, baseicm, agreg, key);
      //CALCLUCRO1(lucro, p_venda, debicm, basedeb, credicm, p_compra, frete, encargos, basecred, agregado, key);
      JsEdit.LiberaMemoria(form9);
      form9.Free;
    end;
end;


procedure TForm17.DBGrid2Exit(Sender: TObject);
begin
  Label13.Caption := '';
end;

procedure TForm17.p_vendaKeyPress(Sender: TObject; var Key: Char);
begin
  if key = #13 then
    begin
      form9 := tform9.Create(self);
     //form9.CALCLUCRO1(lucro, p_venda, debicm, basedeb, credicm, p_compra, frete, encargos, baseicm, encargos, key);
     form9.CALCPRE(lucro, p_venda, debicm, basedeb, credicm, p_compra, frete, encargos, baseicm, encargos);
     JsEdit.LiberaMemoria(form9);
     form9.Free;
     JsBotao1.SetFocus;
    end;
end;

procedure TForm17.codigoKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if not funcoes.Contido(chr(key), '0987654321') then
    BEGIN
      KEY := 0;
    END;  
end;

procedure TForm17.DBGrid2KeyPress(Sender: TObject; var Key: Char);
var
  custo, DATA : String;
begin
  if key = #13 then
    begin
      if DBGrid2.SelectedField.DisplayName = 'VALIDADE' then
        begin
          DATA := '';
          IF NOT  DBGrid2.DataSource.DataSet.fieldbyname('VALIDADE').IsNull THEN
            BEGIN
              DATA := FormatDateTime('dd/mm/yy', DBGrid2.DataSource.DataSet.fieldbyname('VALIDADE').AsDateTime);
            END;

          DATA := funcoes.dialogo('data',0,'',2,true,'',Application.Title,'Qual a Data de Validade ?',data);
          if DATA = '*' then exit;

          dm.IBQuery3.Close;
          dm.IBQuery3.SQL.Text := 'update item_entrada set validade = :validade where (CODENTRADA = :cod)';
          dm.IBQuery3.ParamByName('validade').AsDate  := StrToDate(data);
          dm.IBQuery3.ParamByName('cod').AsString     := DBGrid2.DataSource.DataSet.fieldbyname('CODENTRADA').AsString;
          dm.IBQuery3.ExecSQL;

          dm.IBQuery3.Transaction.Commit;

          abreDataSet;
          tot.Caption := CurrToStrf(lertotal(true),ffcurrency,2);
        end;

      if DBGrid2.SelectedField.DisplayName = 'P_COMPRA' then
        begin
          custo := funcoes.dialogo('numero',0,'',3,false,'',Application.Title,'Qual o Novo Valor de Custo',FormatCurr('#,###,###0.000',
          DBGrid2.DataSource.DataSet.fieldbyname('p_compra').AsCurrency));
          if custo = '*' then exit;

          dm.IBQuery3.Close;
          dm.IBQuery3.SQL.Text := 'update item_entrada set p_compra = :custo, total = quant * :custo where (CODENTRADA = :cod)';
          dm.IBQuery3.ParamByName('custo').AsCurrency := StrToCurr(custo);
          dm.IBQuery3.ParamByName('cod').AsString     := DBGrid2.DataSource.DataSet.fieldbyname('CODENTRADA').AsString;
          dm.IBQuery3.ExecSQL;

          {dm.IBQuery3.Close;
          dm.IBQuery3.SQL.Text := 'update item_entrada set p_compra = :custo where (nota = :nota) and (fornec = :fornec) and (cod = :cod)';
          dm.IBQuery3.ParamByName('custo').AsCurrency := StrToCurr(custo);
          dm.IBQuery3.ParamByName('nota').AsString    := codigo.Text;
          dm.IBQuery3.ParamByName('fornec').AsString  := fornec.Text;
          dm.IBQuery3.ParamByName('cod').AsString     := DBGrid2.DataSource.DataSet.fieldbyname('cod').AsString;
          dm.IBQuery3.ExecSQL;}

          dm.IBQuery3.Transaction.Commit;

          abreDataSet;
          tot.Caption := CurrToStrf(lertotal(true),ffcurrency,2);
        end;
    end;
end;

procedure TForm17.FormCreate(Sender: TObject);
var
  param50 : string;
begin
  param50 := funcoes.buscaParamGeral(50, 'N');
  if param50 = 'S' then usarCODBAR := true
    else usarCODBAR := false;

  {try
    if ConfParamGerais[49] = 'S' then
      begin
        usarCODBAR := true;
      end;
  except
  end;}
end;

procedure TForm17.trocaCodigoCodbar;
begin
  if codbar.Text = '' then exit;

  dm.IBQuery3.Close;
  dm.IBQuery3.SQL.Clear;
  dm.IBQuery3.SQL.Add('select codbar from produto where (cod = '+QuotedStr(codbar.Text)+')');
  dm.IBQuery3.Open;

  if dm.IBQuery3.IsEmpty then
    begin
      dm.IBQuery3.Close;
      dm.IBQuery3.SQL.Clear;
      dm.IBQuery3.SQL.Add('select codbar from codbarras where (cod = '+QuotedStr(codbar.Text)+')');
      dm.IBQuery3.Open;
      if dm.IBQuery3.IsEmpty then
        begin
          MessageDlg('Produto Não Encontrado: ' + codbar.Text, mtInformation, [mbok], 1);
          exit;
        end;
    end;

  codbar.Text := dm.IBQuery3.fieldbyname('codbar').AsString;  
end;


procedure TForm17.buscaFornecedores(cod1 : String);
var
  forn : String;
begin
  if cod1 = '' then exit;

  dm.IBselect.Close;
  dm.IBselect.SQL.Text := 'select e.nota, e.fornec, f.nome, e.total_nota, e.data as emissao, e.chegada from entrada e' +
  ' left join fornecedor f on (e.fornec = f.cod) where e.nota = :nota';
  dm.IBselect.ParamByName('nota').AsInteger := StrToInt(StrNum(cod1));
  dm.IBselect.Open;
  dm.IBselect.FetchAll;

  if dm.IBselect.IsEmpty then
    begin
      dm.IBselect.Close;
      exit;
    end;

  if dm.IBselect.RecordCount > 1 then
    begin
      forn := funcoes.busca(dm.ibselect,'fornec','fornec', 'fornec', 'fornec');
    end
  else
    begin
      forn := dm.IBselect.FieldByName('fornec').AsString;
    end;

  if forn <> '' then fornec.Text := forn;
  dm.IBselect.Close;
end;

end.

