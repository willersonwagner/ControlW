unit backup;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Grids, DBGrids, Data.DB, Datasnap.DBClient, func;

type
  TForm44 = class(TForm)
    DBGrid1: TDBGrid;
    DBGrid2: TDBGrid;
    Label1: TLabel;
    ClientDataSet1: TClientDataSet;
    DataSource1: TDataSource;
    procedure DBGrid1KeyPress(Sender: TObject; var Key: Char);
    procedure DBGrid1KeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure DBGrid1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure DBGrid2KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure DBGrid2KeyPress(Sender: TObject; var Key: Char);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    function buscaVenda : String;
    function buscaEnrtada : String;
    procedure acertarTamanhoDBGRID1();
    procedure abreDataSet(refresh1 : boolean = false);
    procedure limpaVendas();
    procedure entregaProduto;
    procedure excluiEntrega;
    procedure criaDataSetVendaEntrega;
    { Private declarations }
  public
    retorno : TStringList;
    entrada : boolean;
    listaEntrega : TStringList;
    opcao   : SmallInt;
    nota    : String;
    function getRetorno : TStringList;
    procedure abreDataSetEntrega(refresh1 : boolean = false);
    { Public declarations }
  end;

var
  Form44: TForm44;

implementation


uses Unit1, principal;

{$R *.dfm}
function TForm44.getRetorno : TStringList;
begin
  if funcoes.Contido('entrada', dm.IBselect.SQL.GetText) then
    begin
      retorno := TStringList.Create;
      retorno.Add(DBGrid1.DataSource.DataSet.fieldbyname('nota').AsString);
      exit;
    end;

  retorno := TStringList.Create;
  retorno.Add(DBGrid1.DataSource.DataSet.fieldbyname('formapagto').AsString);
  retorno.Add(DBGrid1.DataSource.DataSet.fieldbyname('total').AsString);
  retorno.Add(DBGrid1.DataSource.DataSet.fieldbyname('nota').AsString);
end;

function TForm44.buscaVenda : String;
begin
  if entrada then
    begin
      dm.IBselect.Close;
      dm.IBselect.SQL.Clear;
      dm.IBselect.SQL.Add('select p.cod, c.nome, p.quant, p.p_compra, p.total from item_entrada p, produto c where (c.cod = p.cod) and (p.nota = :nota)');
      dm.IBselect.ParamByName('nota').AsString := DBGrid1.DataSource.DataSet.fieldbyname('nota').AsString;
      dm.IBselect.Open;
      funcoes.FormataCampos(dm.ibselect, 2,'',2);
      exit;
    end;

  dm.IBselect.Close;
  dm.IBselect.SQL.Clear;
  dm.IBselect.SQL.Add('select p.cod, c.nome, p.quant, p.p_venda, p.total from item_venda p, produto c where (c.cod = p.cod) and (p.nota = :nota)');
  dm.IBselect.ParamByName('nota').AsString := DBGrid1.DataSource.DataSet.fieldbyname('nota').AsString;
  dm.IBselect.Open;
  funcoes.FormataCampos(dm.ibselect, 2,'',2);
end;

procedure TForm44.DBGrid1KeyPress(Sender: TObject; var Key: Char);
var
  nota1 : String;
  kay1 : char;
begin
  if entrada then begin
    if key = #13 then begin
      funcoes.retornoLocalizar := DBGrid1.DataSource.DataSet.FieldByName('nota').AsString;
      close;
    end;

    if key = #27  then begin
      funcoes.retornoLocalizar := '';
      close;
    end;
  end;

  key := UpCase(key);

  if opcao = 2 then begin //entrega de produtos
     if key = #13 then begin
       entregaProduto;
       exit;
     end;

      if key = #27 then begin
        close;
        exit;
      end;
    exit;
  end;

  if opcao = 1 then begin //busca venda pra gerar cupom
    if key = 'C' then begin
      nota1 := DBGrid1.DataSource.DataSet.fieldbyname('nota').AsString;

      try
        form22.enviNFCe(nota1);

      except
      end;

      abreDataSet();
      funcoes.FormataCampos(dm.ibquery2,2,'',2);

      DBGrid1.DataSource.DataSet.Locate('nota', nota1, []);
      buscaVenda;
    end;

    if key = #27 then begin
      funcoes.retornoLocalizar := '*';
     // dm.IBQuery2.Close;
      dm.IBselect.Close;
      close;
    end;


    if key = #13 then begin
      funcoes.retornoLocalizar := DBGrid1.DataSource.DataSet.fieldbyname('nota').AsString;
      if funcoes.retornoLocalizar = '' then
        begin
          abreDataSet(true);
          exit;
        end;
      getRetorno;
      //dm.IBQuery2.Close;
      dm.IBselect.Close;
      close;
    end;
  end;
end;

procedure TForm44.DBGrid1KeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  cod : String;
begin

  if key = 113 then begin
    if entrada then begin
      if DBGrid1.SelectedField.DisplayLabel = 'NOTA' then BEGIN
        cod := funcoes.dialogo('generico',100,'1234567890'+#8,100,true,'','Control For Windows','Qual o Numero da Nota ?','');
        if cod = '*' then exit;
        if strnum(cod) = '0' then exit;

        dm.IBQuery1.Close;
        dm.IBQuery1.SQL.Text := 'update entrada set nota = :nota where nota = :nota1 and fornec = :fornec';
        dm.IBQuery1.ParamByName('nota').AsInteger   := StrToIntDef(strnum(cod),0);
        dm.IBQuery1.ParamByName('nota1').AsInteger  := DBGrid1.DataSource.DataSet.FieldByName('nota').AsInteger;
        dm.IBQuery1.ParamByName('fornec').AsInteger := DBGrid1.DataSource.DataSet.FieldByName('codfornec').AsInteger;
        dm.IBQuery1.ExecSQL;

        dm.IBQuery1.Close;
        dm.IBQuery1.SQL.Text := 'update item_entrada set nota = :nota where nota = :nota1 and fornec = :fornec';
        dm.IBQuery1.ParamByName('nota').AsInteger   := StrToIntDef(strnum(cod),0);
        dm.IBQuery1.ParamByName('nota1').AsInteger  := DBGrid1.DataSource.DataSet.FieldByName('nota').AsInteger;
        dm.IBQuery1.ParamByName('fornec').AsInteger := DBGrid1.DataSource.DataSet.FieldByName('codfornec').AsInteger;
        dm.IBQuery1.ExecSQL;

        try
          dm.IBQuery1.Transaction.Commit;
        except
          on e:exception do begin
            dm.IBQuery1.Transaction.Rollback;
            ShowMessage('Ocorreu um erro na Alteração: ' + e.Message);
            exit;
          end;
        end;

        ShowMessage('Numeração de Nota de Entrada Alterada Com Sucesso!');
        dm.IBQuery4.Close;
        dm.IBQuery4.Open;
        funcoes.FormataCampos(dm.ibquery4,2,'',2);
        funcoes.FormataCampos(dm.ibselect,2,'',2);
      END;

      if DBGrid1.SelectedField.DisplayLabel = 'CODFORNEC' then BEGIN
        cod := funcoes.dialogo('generico',100,'1234567890'+#8,100,true,'','Control For Windows','Qual o Cód. do Fornecedor ?','');
        if cod = '*' then exit;
        if strnum(cod) = '0' then exit;

        dm.IBQuery1.Close;
        dm.IBQuery1.SQL.Text := 'update entrada set fornec = :nota where nota = :nota1 and fornec = :fornec';
        dm.IBQuery1.ParamByName('nota').AsInteger   := StrToIntDef(strnum(cod),0);
        dm.IBQuery1.ParamByName('nota1').AsInteger  := DBGrid1.DataSource.DataSet.FieldByName('nota').AsInteger;
        dm.IBQuery1.ParamByName('fornec').AsInteger := DBGrid1.DataSource.DataSet.FieldByName('codfornec').AsInteger;
        dm.IBQuery1.ExecSQL;

        dm.IBQuery1.Close;
        dm.IBQuery1.SQL.Text := 'update item_entrada set fornec = :nota where nota = :nota1 and fornec = :fornec';
        dm.IBQuery1.ParamByName('nota').AsInteger   := StrToIntDef(strnum(cod),0);
        dm.IBQuery1.ParamByName('nota1').AsInteger  := DBGrid1.DataSource.DataSet.FieldByName('nota').AsInteger;
        dm.IBQuery1.ParamByName('fornec').AsInteger := DBGrid1.DataSource.DataSet.FieldByName('codfornec').AsInteger;
        dm.IBQuery1.ExecSQL;

        try
          dm.IBQuery1.Transaction.Commit;
        except
          on e:exception do begin
            dm.IBQuery1.Transaction.Rollback;
            ShowMessage('Ocorreu um erro na Alteração: ' + e.Message);
            exit;
          end;
        end;


        ShowMessage('Numeração de Nota de Entrada Alterada Com Sucesso!');

        dm.IBQuery4.Close;
        dm.IBQuery4.Open;
        funcoes.FormataCampos(dm.ibquery4,2,'',2);
        funcoes.FormataCampos(dm.ibselect,2,'',2);
      END;
    end;
  end;

  if opcao = 1 then begin
    if (key = 38) or (key = 40) then buscaVenda;
    if key = 116 then begin
      abreDataSet(true);
    end;
  end;

end;

procedure TForm44.DBGrid1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key = 119 then DBGrid2.SetFocus;
end;

procedure TForm44.DBGrid2KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key = 119 then DBGrid1.SetFocus;
  if opcao = 2 then begin
    if key = 46 then begin
      excluiEntrega;
      exit;
    end;
  end;

end;

procedure TForm44.DBGrid2KeyPress(Sender: TObject; var Key: Char);
begin
  if key = #27 then DBGrid1.SetFocus;
end;

procedure TForm44.FormCreate(Sender: TObject);
begin
  entrada := false;
end;

procedure TForm44.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if ((ssCtrl in Shift) and (chr(Key) in [#46])) then begin
    limpaVendas;
  end;
end;

procedure TForm44.FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
var
  cod : String;
begin
  if opcao = 2 then begin
    if key = 115 then begin
      cod := form22.Pgerais.Values['nota'];
      if funcoes.Contido(cod, 'TDE') then cod := 'TE'
       else cod := 'ME';

      if form22.Pgerais.Values['nota'] = 'E' then cod := 'ET';
       

      funcoes.GeraNota(nota, cod, 'S', 4);
      abreDataSetEntrega();
    end;
  end;
end;

procedure TForm44.FormShow(Sender: TObject);
begin
  acertarTamanhoDBGRID1();
end;

procedure TForm44.acertarTamanhoDBGRID1();
var
  i, acc : integer;
begin
  acc := 0;
  for i:=0 to DBGrid1.Columns.Count-1 do
    begin
       //showme
       acc := acc + DBGrid1.Columns[i].Width;
    end;
    
  self.Width := acc + 80;
  DBGrid1.Width := acc;
  //if acc < 299 then self.Width:=acc+10;
end;

procedure TForm44.abreDataSetEntrega(refresh1 : boolean = false);
begin
  if refresh1 then
    begin
      criaDataSetVendaEntrega;
      DBGrid2.DataSource.DataSet.Open;

      TCurrencyField(dm.IBQuery2.FieldByName('quant')).DisplayFormat
        := '###,##0.00';
      TCurrencyField(ClientDataSet1.FieldByName('quant')).DisplayFormat
        := '###,##0.00';

      dm.IBQuery2.FieldByName('numdoc').Visible := false;
      exit;
    end;

  criaDataSetVendaEntrega;
 
  dm.IBQuery2.Close;
  dm.IBQuery2.SQL.Text := 'select i.nota, i.DATA_ENTREGA, i.cod, p.nome, i.quant, i.numdoc from CONT_ENTREGA ' +
  'i left join produto p on (i.cod = p.cod) where i.nota = :nota';
  dm.IBQuery2.ParamByName('nota').AsString := nota;
  dm.IBQuery2.Open;

  dm.IBQuery2.FieldByName('numdoc').Visible := false;

  TCurrencyField(dm.IBQuery2.FieldByName('quant')).DisplayFormat
        := '###,##0.00';
  TCurrencyField(ClientDataSet1.FieldByName('quant')).DisplayFormat
        := '###,##0.00';
  DBGrid2.DataSource := dm.entrada;
end;

procedure TForm44.abreDataSet(refresh1 : boolean = false);
begin
  if refresh1 then
    begin
      DBGrid1.DataSource.DataSet.Close;
      DBGrid1.DataSource.DataSet.Open;
      funcoes.FormataCampos(dm.ibquery2,2,'',2);
      buscaVenda;
      exit;
    end;

  dm.IBQuery2.Close;
  dm.IBQuery2.SQL.Text := ('select v.nota, v.data, v.codhis as formapagto, a.nome as vendedor, v.desconto, v.total from venda v left join  vendedor a on (v.vendedor = a.cod) where (v.cancelado = 0) and ((v.ok = '+ QuotedStr('') +') or (v.ok = '+ QuotedStr('N') +' )) order by v.nota desc');
  dm.IBQuery2.Open;
end;

procedure TForm44.limpaVendas();
begin
  if MessageDlg('Deseja Remover todas as Vendas Desta Lista ?', mtConfirmation, [mbYes, mbNo], 1) = idno then exit;

  dm.IBQuery1.Close;
  dm.IBQuery1.SQL.Text := 'update venda set ok = ''S'' where ((ok = '''') or (ok = ''N''))';
  dm.IBQuery1.ExecSQL;
  dm.IBQuery1.Transaction.Commit;

  abreDataSet(true);
end;

procedure TForm44.entregaProduto;
var
  quant : string;
begin
  if DBGrid1.DataSource.DataSet.FieldByName('quant').AsCurrency = 0 then begin
    MessageDlg('Esse Produto Já foi Entregue!', mtInformation, [mbok], 1);
    exit;
  end;

  quant := funcoes.dialogo('numero',2,'SN',2,true,'S','Control for Windows:','Quantidade:', formataCurrency(DBGrid1.DataSource.DataSet.FieldByName('quant').AsCurrency));
  if quant = '*' then exit;

  if (StrToCurr(quant) > DBGrid1.DataSource.DataSet.FieldByName('quant').AsCurrency) or (StrToCurr(quant) <= 0) then begin
    MessageDlg('Quantidade Inválida!', mtError, [mbOK], 1);
    exit;
  end;

  dm.IBQuery1.Close;
  dm.IBQuery1.SQL.Text := 'insert into CONT_ENTREGA(NUMDOC, NOTA, COD, DATA_ENTREGA, QUANT, USUARIO, ENT_AGORA) values' +
  '(gen_id(CONT_ENTREGA, 1), :NOTA, :COD, :DATA_ENTREGA, :QUANT, :USUARIO, ''X'')';
  dm.IBQuery1.ParamByName('nota').AsString := DBGrid1.DataSource.DataSet.FieldByName('nota').AsString;
  dm.IBQuery1.ParamByName('cod').AsString  := DBGrid1.DataSource.DataSet.FieldByName('cod').AsString;
  dm.IBQuery1.ParamByName('DATA_ENTREGA').AsDate := form22.datamov;
  dm.IBQuery1.ParamByName('QUANT').AsCurrency    := StrToCurr(quant);
  dm.IBQuery1.ParamByName('USUARIO').AsString    := form22.codusario;
  dm.IBQuery1.ExecSQL;
  dm.IBQuery1.Transaction.Commit;

  listaEntrega.Values[DBGrid1.DataSource.DataSet.FieldByName('cod').AsString] :=
  CurrToStr(StrToCurrDef(listaEntrega.Values[DBGrid1.DataSource.DataSet.FieldByName('cod').AsString], 0) + StrToCurr(quant));

  abreDataSetEntrega;
end;

procedure TForm44.criaDataSetVendaEntrega;
var
  lista : TStringList;
begin
  lista := TStringList.Create;

  ClientDataSet1.Close;
  ClientDataSet1.FieldDefs.Clear;

  dm.IBselect.Close;
  dm.IBselect.SQL.Text := 'select i.cod, i.quant from CONT_ENTREGA i where i.nota = :nota';
  dm.IBselect.ParamByName('nota').AsString := nota;
  dm.IBselect.Open;

  while not dm.IBselect.Eof do begin
    lista.Values[dm.IBselect.FieldByName('cod').AsString] :=
    CurrToStr(StrToCurrDef(lista.Values[dm.IBselect.FieldByName('cod').AsString], 0) +
    dm.IBselect.FieldByName('quant').Ascurrency);
    //lista.Add(dm.IBselect.FieldByName('cod').AsString  + '=' + dm.IBselect.FieldByName('quant').AsString);
    dm.IBselect.Next;
  end;

  dm.IBselect.Close;
  dm.IBselect.SQL.Text := 'select i.nota, i.data, i.cod, p.nome, i.quant from item_venda i'+
  ' left join produto p on (p.cod = i.cod) where i.nota = :nota';
  dm.IBselect.ParamByName('nota').AsString := nota;
  dm.IBselect.Open;

  funcoes.Ibquery_to_clienteDataSet(dm.IBselect, ClientDataSet1);

  while not dm.IBselect.Eof do begin
    if dm.IBselect.FieldByName('quant').AsCurrency - StrToCurrDef(lista.Values[dm.IBselect.FieldByName('cod').AsString], 0) > 0 then begin
      ClientDataSet1.Insert;
      ClientDataSet1.FieldByName('nota').AsString    := dm.IBselect.FieldByName('nota').AsString;
      ClientDataSet1.FieldByName('data').AsDateTime  := dm.IBselect.FieldByName('data').AsDateTime;
      ClientDataSet1.FieldByName('cod').AsString     := dm.IBselect.FieldByName('cod').AsString;
      ClientDataSet1.FieldByName('nome').AsString    := dm.IBselect.FieldByName('nome').AsString;
      ClientDataSet1.FieldByName('quant').AsCurrency := dm.IBselect.FieldByName('quant').AsCurrency - StrToCurrDef(lista.Values[dm.IBselect.FieldByName('cod').AsString], 0);
      ClientDataSet1.Post;
    end;

      dm.IBselect.Next;
  end;

  ClientDataSet1.Active := true;
  dm.IBselect.Close;
  DataSource1.DataSet := ClientDataSet1;
  DBGrid1.DataSource  := DataSource1;
  lista.free;
end;

procedure TForm44.excluiEntrega;
var
  sim : string;
begin
  sim := funcoes.dialogo('generico',0,'SN'+#8,0,false,'S','Control For Windows','Deseja Excluir','N') ;
  if ((sim = '*') or (sim <> 'S')) then exit;

  dm.IBQuery1.Close;
  dm.IBQuery1.SQL.Text := 'delete from CONT_ENTREGA where numdoc = :cod';
  dm.IBQuery1.ParamByName('cod').AsString := DBGrid2.DataSource.DataSet.FieldByName('numdoc').AsString;
  dm.IBQuery1.ExecSQL;
  dm.IBQuery1.Transaction.Commit;

  abreDataSetEntrega;
  DBGrid1.SetFocus;
end;

function TForm44.buscaEnrtada : String;
begin

end;

end.






