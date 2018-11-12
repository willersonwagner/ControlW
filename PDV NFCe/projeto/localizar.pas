unit localizar;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, DBGrids, StdCtrls, JsEdit1, ExtCtrls, ibquery, ibtable,
  DB, IBCustomDataSet, func;

type
  TForm7 = class(TForm)
    DBGrid1: TDBGrid;
    Edit1: TEdit;
    Label1: TLabel;
    Timer1: TTimer;
    DataSource1: TDataSource;
    procedure Edit1KeyPress(Sender: TObject; var Key: Char);
    procedure DBGrid1KeyPress(Sender: TObject; var Key: Char);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure DBGrid1DrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure DBGrid1KeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Timer1Timer(Sender: TObject);
    procedure Edit1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure DBGrid1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    dataset : tibtable;
    procura : String;
    procedure acertarTamanhoDBGRID();
    procedure abredataSetContasPagar();
    procedure reabredataSetContasPagar();
    procedure deletaContasPagar();
    procedure deletaEntrada();
    procedure deletaTranferencia();
    procedure deletaContasReceber();
    function buscaCodbar() : String;
    { Private declarations }
  public
    query, query1 : TIBQuery;
    deletar:boolean;
    ordem, campoLocate, keyLocate, retLocalizar : string;
    retorno:string;
    esconde:string;
    tabela : string;
    formulario : tForm;
    campos : string;
    condicao:string;
    editlocaliza:boolean;
    cod: JsEdit;
    campolocaliza : string;
    usarBuscaProdutoCodigoSeq : boolean;
    editalvel:boolean;
  end;

var
  Form7: TForm7;
 implementation

uses protetor, StrUtils;

{$R *.dfm}
function TForm7.buscaCodbar() : String;
begin
  Result := DBGrid1.DataSource.DataSet.FieldByName('cod').AsString;
  query1.Close;
  query1.SQL.Text := 'select codbar from produto where cod = :cod';
  query1.ParamByName('cod').AsString := Result;
  query1.Open;

  if StrNum(query1.FieldByName('codbar').AsString) <> '0' then
    begin
      Result := StrNum(query1.FieldByName('codbar').AsString);
      query1.Close;
      exit;
    end;

  query1.Close;
  query1.SQL.Text := 'select codbar from codbar where cod = :cod';
  query1.ParamByName('cod').AsString := Result;
  query1.Open;

  if not query1.IsEmpty then Result := StrNum(query1.FieldByName('codbar').AsString);
  query1.Close;
end;

procedure TForm7.deletaContasReceber();
var
  ren : integer;
begin
{ if dm.IBQuery1.IsEmpty then exit;
 if UpperCase(tabela) <> 'CONTASRECEBER' then exit;

 if not VerificaAcesso_Se_Nao_tiver_Nenhum_bloqueio_true_senao_false then
   begin
     WWMessage('Somente um Usuário Autorizado Pode Cancelar Esta Conta.',mtError,[mbok],clYellow,true,false,clRed);
     exit;
   end;

 if messageDlg('Deseja Excluir '+dm.IBQuery1.fieldbyname('historico').AsString +' ?', mtConfirmation, [mbyes, mbNo], 0) = mrYes then
   begin
     ren := dm.IBQuery1.RecNo;
     dm.IBQuery1.DisableControls;
     try
       dm.IBselect.SQL.Clear;
       dm.IBselect.SQL.Add('delete from contasreceber where cod ='+dm.IBQuery1.fieldbyname('cod').AsString) ;
       try
         dm.IBselect.ExecSQL;
         dm.IBselect.Transaction.Commit;
         dm.IBQuery1.Close;
         dm.IBQuery1.Open;
         dm.IBQuery1.MoveBy(ren - 1);
       except
         dm.IBQuery1.Transaction.Rollback;
         dm.IBQuery1.Close;
         exit;
       end;
     finally
       dm.IBQuery1.EnableControls;
     end;
   end;
}end;

procedure TForm7.deletaTranferencia();
begin
{  if dm.IBQuery1.IsEmpty then exit;
  if not funcoes.Contido('TRANSFERENCIA',UpperCase(tabela)) then exit;

  if messageDlg('Confirma Exclusão Desta Transferência?', mtConfirmation, [mbyes, mbNo], 0) = mrYes then
    begin
      dm.IBQuery2.Close;
      dm.IBQuery2.SQL.Clear;
      if dm.IBQuery1.FieldByName('destino').AsInteger = 1 then  dm.IBQuery2.SQL.Add('update produto set quant = quant - :q, deposito = deposito + :q where cod='+dm.IBQuery1.fieldbyname('cod').AsString)
        else dm.IBQuery2.SQL.Add('update produto set quant = quant + :q, deposito = deposito - :q where cod='+dm.IBQuery1.fieldbyname('cod').AsString);
      dm.IBQuery2.ParamByName('q').AsCurrency := dm.IBQuery1.fieldbyname('quant').AsCurrency;
      dm.IBQuery2.ExecSQL;

      dm.IBQuery2.Close;
      dm.IBQuery2.SQL.Clear;
      dm.IBQuery2.SQL.Add('delete from transferencia where documento='+dm.IBQuery1.fieldbyname('documento').AsString);

      try
        dm.IBQuery2.ExecSQL;
        dm.IBQuery2.Transaction.Commit;
        dm.IBQuery1.Close;
        dm.IBQuery1.Open;
      except
        dm.IBQuery2.Transaction.Rollback;
        ShowMessage('Ocorreu um Erro Inesperado. Tente Novamente!');
      end;
    end;
}end;

procedure TForm7.deletaEntrada();
var
  val, temp : String;
begin
{  if dm.IBQuery1.IsEmpty then exit;
  if (UpperCase(tabela) <> 'ENTRADA') then exit;

  if messageDlg('Confirma Exclusão Desta Entrada?', mtConfirmation, [mbyes, mbNo], 0) = mrYes then
    begin
      val := dm.IBQuery1.fieldbyname('nota').AsString;

      dm.IBQuery3.Close;
      dm.IBQuery3.SQL.Clear;
      dm.IBQuery3.SQL.Add('select quant, cod, destino from item_entrada where nota = '+ val);
      dm.IBQuery3.Open;

      while not dm.IBQuery3.Eof do
        begin
          if dm.IBQuery3.FieldByName('destino').AsInteger = 1 then  temp := 'quant'
           else temp := 'deposito';

          dm.IBQuery4.Close;
          dm.IBQuery4.SQL.Clear;
          dm.IBQuery4.SQL.Add('update produto set '+ temp +' = '+ temp +' - :qu where cod = :cod');
          dm.IBQuery4.ParamByName('qu').AsCurrency := dm.IBQuery3.fieldbyname('quant').AsCurrency;
          dm.IBQuery4.ParamByName('cod').AsString := dm.IBQuery3.fieldbyname('cod').AsString;
          dm.IBQuery4.ExecSQL;
          dm.IBQuery3.Next;
        end;

      dm.IBQuery4.Close;
      dm.IBQuery4.SQL.Clear;
      dm.IBQuery4.SQL.Add('delete from entrada where nota = :nota');
      dm.IBQuery4.ParamByName('nota').AsString := val;
      dm.IBQuery4.ExecSQL;

      dm.IBQuery4.Close;
      dm.IBQuery4.SQL.Clear;
      dm.IBQuery4.SQL.Add('delete from item_entrada where nota = :nota');
      dm.IBQuery4.ParamByName('nota').AsString := val;
      dm.IBQuery4.ExecSQL;

      dm.IBQuery4.Transaction.Commit;

      dm.IBQuery1.Close;
      dm.IBQuery1.Open;
    end;
}end;

procedure TForm7.deletaContasPagar();
var
  ren : integer;
begin
{  if UpperCase(tabela) <> 'CONTASPAGAR' then exit;
  if dataset.IsEmpty then exit;

  if not VerificaAcesso_Se_Nao_tiver_Nenhum_bloqueio_true_senao_false then
    begin
      WWMessage('Somente um Usuário Autorizado Pode Cancelar Esta Conta.',mtError,[mbok],clYellow,true,false,clRed);
      exit;
    end;

  if messageDlg('Deseja Excluir?', mtConfirmation, [mbyes, mbNo], 0) = mrYes then
    begin
      try
        dataset.DisableControls;
        ren := dataset.RecNo;
        dm.IBQuery2.Close;
        dm.IBQuery2.SQL.Clear;
        dm.IBQuery2.SQL.Add('delete from contaspagar where (codgru = :gru) and (documento = :doc) and vencimento = :data');
        dm.IBQuery2.ParamByName('gru').AsString    := dataset.fieldbyname('codgru').AsString;
        dm.IBQuery2.ParamByName('doc').AsString    := dataset.fieldbyname('documento').AsString;
        dm.IBQuery2.ParamByName('data').AsDateTime := dataset.fieldbyname('vencimento').AsDateTime;
        Try
          dm.IBQuery2.ExecSQL;
          dm.IBQuery2.Transaction.Commit;
          reabredataSetContasPagar();
          dataset.MoveBy(ren - 1);
        except
        end;
      finally
        dataset.EnableControls;
      end;
    end;
}end;

procedure TForm7.abredataSetContasPagar();
begin
{  dataset := TIBTable.Create(self);
  dataset.Database  := dm.bd;
  dataset.TableName := UpperCase(tabela);
  dataset.Active := TRUE;
  dataset.Filter   := '(pago = 0)';
  dataset.Filtered := true;
  dataset.IndexName  := 'CONTASPAGAR_IDX2'; //INDICE VENCIMENTO
  dataset.First;

  dataset.FieldByName('fornec').Visible   := false;
  dataset.FieldByName('usuario').Visible  := false;
  dataset.FieldByName('pago').Visible     := false;
  dataset.FieldByName('total').Visible    := false;
  dataset.FieldByName('valor').Index      := 4;

  //dataset.FieldByName('valor').ReadOnly      := true;
  //dataset.FieldByName('vencimento').ReadOnly := true;

  funcoes.FormataCampos(tibquery(dataset), 2, '', 2);

  dm.ds.DataSet := dataset;
}end;

procedure TForm7.reabredataSetContasPagar();
begin
{  dataset.Active := false;
  dataset.Active := true;
  dataset.Filter   := '(pago = 0)';
  dataset.Filtered := true;
  dataset.IndexName  := 'CONTASPAGAR_IDX1'; //INDICE VENCIMENTO

  dataset.FieldByName('fornec').Visible   := false;
  dataset.FieldByName('usuario').Visible  := false;
  dataset.FieldByName('pago').Visible     := false;
  dataset.FieldByName('total').Visible    := false;
  dataset.FieldByName('valor').Index      := 4;

  //dataset.FieldByName('valor').ReadOnly      := true;
  //dataset.FieldByName('vencimento').ReadOnly := true;

  funcoes.FormataCampos(tibquery(dataset), 2, '', 2);

  //dm.ds.DataSet := dataset;
}end;

procedure TForm7.acertarTamanhoDBGRID();
var
  i, acc : integer;
begin
  acc := 0;
  for i:=0 to DBGrid1.Columns.Count-1 do
    begin
       //showme
       acc := acc + DBGrid1.Columns[i].Width;
    end;
  self.Width := acc + 10;
  DBGrid1.Width := acc;
  //if acc < 299 then self.Width:=acc+10;
end;

procedure TForm7.Edit1KeyPress(Sender: TObject; var Key: Char);
begin
   if key = #27 then Close;
   if key = #13 then
   begin
     if tabela = 'contaspagar' then
       begin
         if Edit1.Text = '' then
           begin

             dataset.Filtered := false;
             dataset.Filter   := '(pago = 0)';
             dataset.Filtered := true;
             exit;
           end;
//         dataset.IndexDefs.Add('indice', 'data', [ixDescending]);
         dataset.Filtered := false;
         dataset.Filter   :='(pago = 0) and (' + campolocaliza + ' like ' + QuotedStr('%' + Edit1.Text + '%') + ')';
         dataset.Filtered := true;


         exit;
       end;

     Query.SQL.Clear;
     if ordem = '' then
       begin
         if condicao <> '' then Query.SQL.Add('select '+campos+' from '+tabela+' '+condicao +' and ('+campolocaliza+' like upper('+ QuotedStr('%'+Edit1.Text+'%')+')) ')
           else query.SQL.Add('select '+campos+' from '+tabela+'  where ('+campolocaliza+' like upper('+ QuotedStr('%'+Edit1.Text+'%')+')) ');
       end
      else
        begin
          if condicao <> '' then Query.SQL.Add('select '+campos+' from '+tabela+' '+condicao +' and ('+campolocaliza+' like upper('+ QuotedStr('%'+Edit1.Text+'%')+')) order by '+ordem)
            else Query.SQL.Add('select '+campos+' from '+tabela+'  where ('+campolocaliza+' like upper('+ QuotedStr('%'+Edit1.Text+'%')+')) order by '+ordem)
        end;

     if Query.SQL.GetText <> '' then
       begin
         Query.Open;
         if Query.IsEmpty then exit
           else
             begin
               FormataCampos(Query,2,'',2);
               DBGrid1.SetFocus;
             end;

       end;
     if esconde <> '' then Query.FieldByName(esconde).Visible:=false;


       { dm.IBQuery1.SQL.Clear;
        dm.IBQuery1.SQL.Add('select '+campos+' from '+tabela+' where '+campolocaliza+' like upper('+ QuotedStr('%'+Edit1.Text+'%')+') order by '+campolocaliza);
        dm.IBQuery1.Open;
        DBGrid1.SetFocus;
  } end;
end;

procedure TForm7.DBGrid1KeyPress(Sender: TObject; var Key: Char);
var i:integer;
var acc, mm:string;
begin
  key := UpCase(key);
  if (tabela = 'contaspagar') and (not Contido(key, #27 + #13)) then
    begin
      //sai pq não tem o que fazer aqui
      exit;
    end;

if (key = #32) and Contido('PRODUTO', UpperCase(tabela)) then
  begin
   if (DBGrid1.SelectedField.DisplayName = 'COD') then acc := 'Informe o Código:'
     else acc := 'Selecionar por:';

   acc := dialogo('normal',0,''+ #8 + #13+ #27,0,false,'','Control For Windows',acc,'');
    if acc = '*' then exit;

    if ((DBGrid1.SelectedField.DisplayName = 'COD') and (usarBuscaProdutoCodigoSeq)) then
      begin
        if not Query.Locate('cod', acc, []) then ShowMessage('Código ' + acc + ' Não Encontrado');
        exit;
      end;

    query1.Close;
    //dm.IBQuery3.SQL.Add('select p.cod, nome, p.codbar from produto p join codbarras c on ((c.cod = p.cod)) where (p.codbar like '+QuotedStr('%'+ acc +'%')+') or (nome like '+ QuotedStr('%'+acc+'%') +') or ((c.codbar like '+QuotedStr('%'+ acc +'%')+') and (c.cod = p.cod))');

    if UpperCase(tabela) = 'PRODUTO P' then query1.SQL.Text := ('select p.cod, nome, p.codbar from produto p left join codbarras c on (c.cod = p.cod) '+ IfThen(condicao = '','where', condicao + ' and ') +' (nome like '+QuotedStr('%'+ acc +'%')+') order by nome')
    else query1.SQL.Text := ('select p.cod, nome, p.codbar, p.p_venda from produto p left join codbarras c on (c.cod = p.cod) '+ IfThen(condicao = '','where', condicao + ' and ') +'  (p.codbar like '+QuotedStr('%'+ acc +'%')+') or (nome like '+QuotedStr('%'+ acc +'%')+') or (c.codbar like '+QuotedStr('%'+ acc +'%')+') order by nome');
    query1.Open;

    if query1.IsEmpty then
      begin
        query1.Close;
        ShowMessage(acc + ' Não Encontrado');
        exit;
      end;

    mm := busca(query1, acc,'COD NOME CODBAR', 'cod' , '');
    if mm = '' then exit;
    Query.Locate('cod',mm,[loPartialKey]);
end;

if (key = #32) and (UpperCase(tabela) = 'CLIENTE') then
  begin
    acc := dialogo('normal',0,''+ #8 + #13+ #27,0,false,'','Control For Windows','Selecionar por:','');
    if acc = '*' then exit;

    query.Close;
    query.SQL.Clear;
    query.SQL.Add('select cod,nome, telres from cliente where (nome like '+ QuotedStr('%'+acc+'%') +') or (telres like ' + QuotedStr('%'+acc+'%') +') or (telcom like '+ QuotedStr('%'+acc+'%') +') or (cnpj like '+ QuotedStr('%'+acc+'%') +') ORDER BY NOME');
    query.Open;

    if query.IsEmpty then
      begin
        query.Close;
        ShowMessage(acc + ' Não Encontrado');
        exit;
      end;

    mm := busca(query, acc,'NOME TELRES TELCOM BAIRRO', 'cod' , '');
    if mm = '' then exit;
    query.Locate('cod',mm,[loPartialKey]);
end;

if ((ord(key))>=65) and (((ord(key)))<=95) then
begin
   if procura = '' then procura := UpperCase(key)
    else procura := procura + UpperCase(key);
    Timer1.Enabled := false;
    if procura <> '' then
   begin
     Timer1.Enabled := true;
   end;
   
 Query.Locate(campolocaliza,procura,[loCaseInsensitive, loPartialKey]);
end;



if key=#13 then
  begin
   i:=0;
   acc:='';

   if UpperCase(retorno) = 'CODBAR' then
     begin
       retLocalizar := buscaCodbar;
       Query.Close;
       Close;
       exit;
     end;
   retLocalizar := Query.fieldbyname(retorno).AsString;
{   if formulario = form8 then form8.cod.Text := DBGrid1.SelectedField.Value
   else if formulario = form4 then form4.cod.Text := DBGrid1.SelectedField.Value
   else if formulario = funcoes then
    begin
     if not(editalvel) then
      begin
       if retorno<>'' then
        begin
         if StrToInt(funcoes.ContaChar(retorno,','))>0 then
           begin
               acc:=acc+dm.IBQuery1.FieldByName(copy(retorno,1,pos(',',retorno)-1)).AsString;
               acc:=acc+'-';
               acc:= acc+dm.IBQuery1.FieldByName(copy(retorno,pos(',',retorno)+1,length(retorno))).AsString;
               funcoes.retornoLocalizar:= acc;
           end
         else
           begin
             funcoes.retornoLocalizar:= dm.IBQuery1.fieldbyname(retorno).AsString;
           end;
        end;
     end;
   end;
 }
   if retorno<>'' then
     begin
       Close;
       Query.Close;
     end;
  end;
if (key=#27) and (Edit1.Visible) then Edit1.SetFocus;
if (key=#27) and not(Edit1.Visible) then close;
end;

procedure TForm7.FormShow(Sender: TObject);
var
  i, acc  : integer;
begin
   i:=0;
   acc:=0;
   DBGrid1.Width := self.Width - 10;
   Query.Close;
   Query.SQL.Clear;

   DataSource1.DataSet := query;
   //DBGrid1.DataSource := dm.ds;
   //dm.ds.DataSet := Query;

   {if UpperCase(tabela) = 'CONTASPAGAR' then
     begin
       abredataSetContasPagar();
       acertarTamanhoDBGRID();
       self.Height := 400;
       DBGrid1.Height := 340;
       exit;
     end;
    }
   If not Edit1.Visible then
    begin
     Edit1.Text :='';
     if ordem='' then query.SQL.Add('select '+campos+' from '+tabela+' order by '+campolocaliza)
     else  query.SQL.Add('select '+campos+' from '+tabela+' '+condicao +' order by '+ordem);
     query.Open;

     DBGrid1.DataSource.DataSet := query;

     FormataCampos(query,2,'',2);
     if esconde<>'' then query.FieldByName(esconde).Visible:=false;
     for i:=0 to DBGrid1.Columns.Count-1 do
      begin
       acc := acc + DBGrid1.Columns[i].Width;
      end;
     if acc < 299 then self.Width:=acc+10;

    end
    else
     begin
      Edit1.SetFocus;
     if ordem='' then query.SQL.Add('select '+campos+' from '+tabela+' order by '+campolocaliza+' asc')
     else  query.SQL.Add('select '+campos+' from '+tabela+' '+condicao +' order by '+ordem);
     query.Open;

     DBGrid1.DataSource.DataSet := query;
     FormataCampos(query,2,'',2);
     end;
    // if (tabela = 'orcamento') or (tabela = 'compra') or (tabela = 'entrada') then query.Last;

     if trim(campoLocate) <> '' then
       begin
         if DBGrid1.DataSource.DataSet.Locate(campoLocate, keyLocate, []) then  DBGrid1.SetFocus;
       end;

   if UpperCase(tabela) = 'CONTASRECEBER' then
     begin
       acertarTamanhoDBGRID();
       self.Height := 400;
       DBGrid1.Height := 340;
     end;

   redimensionaTelaDbgrid(dbgrid1);

   if UpperCase(tabela) = 'CLIENTE' then
     begin
       self.Height := screen.Height - trunc(Screen.Height * 0.15);
     end;
end;

procedure TForm7.FormCreate(Sender: TObject);
begin
  campolocaliza := 'nome';
  usarBuscaProdutoCodigoSeq := false;
end;

procedure TForm7.DBGrid1DrawColumnCell(Sender: TObject; const Rect: TRect;
  DataCol: Integer; Column: TColumn; State: TGridDrawState);
begin
  if DBGrid1.DataSource.DataSet.RecNo mod 2 = 0 then
  begin
    if not(Odd(DBGrid1.DataSource.DataSet.RecNo)) then // Se não for par
      if not (gdSelected in State) then Begin // Se o estado da célula não é selecionado
        with DBGrid1 do Begin
            with Canvas do Begin
     //           Brush.Color := HexToTColor('F5F5F5'); // Cor da célula
                //Brush.Color := HexToTColor('7093DB'); // Cor da célula
                //Brush.Color := HexToTColor('81DAF5');
                 FillRect (Rect); // Pinta a célula
            End; // with Canvas
             DefaultDrawDataCell (Rect, Column.Field, State) // Reescreve o valor que vem do banco
        End // With DBGrid1
    End // if not (gdSelected in State)
  end;
end;

procedure TForm7.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  query.Close;
  if tabela = 'contaspagar' then
    begin
      if dataset.Transaction.InTransaction then dataset.Transaction.Commit;
      dataset.Free;
    end;
end;

procedure TForm7.DBGrid1KeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
if deletar then
  begin
    if key=46 then
      begin
        deletaEntrada();
        deletaTranferencia();
        deletaContasReceber();
        deletaContasPagar();
      end;
   end;   
end;

procedure TForm7.Timer1Timer(Sender: TObject);
begin
  procura := '';
  Timer1.Enabled := false;
end;

procedure TForm7.Edit1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
if (key = 40) or (key = 34) then DBGrid1.SetFocus;
end;

procedure TForm7.DBGrid1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  cod : string;
begin
if (DBGrid1.DataSource.DataSet.RecNo = 1) and (key = 38) and (Edit1.Visible) then edit1.SetFocus;
if (UpperCase(tabela) = 'PRODUTO') then
  begin
    if (ssCtrl in Shift) and (chr(Key) in ['P', 'p']) then
    begin
      DBGrid1.DataSource.DataSet.DisableControls;
      cod := DBGrid1.DataSource.DataSet.fieldbyname('cod').AsString;
      //funcoes.IMP_CODBAR(cod);
      DBGrid1.DataSource.DataSet.Open;
      FormataCampos(tibquery(DBGrid1.DataSource.DataSet), 2,'ESTOQUE',3);
      DBGrid1.DataSource.DataSet.Locate('cod', cod, []);
      DBGrid1.DataSource.DataSet.EnableControls;
    end;
  end;
end;

end.
