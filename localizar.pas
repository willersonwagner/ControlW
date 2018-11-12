unit localizar;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, DBGrids, StdCtrls, JsEdit1, ExtCtrls, ibquery, ibtable,
  DB, IBCustomDataSet, principal, funcoesdav, Datasnap.DBClient;

type
  TForm7 = class(TForm)
    DBGrid1: TDBGrid;
    Timer1: TTimer;
    Panel1: TPanel;
    Label1: TLabel;
    Edit1: TEdit;
    DataSource1: TDataSource;
    ClientDataSet1: TClientDataSet;
    procedure Edit1KeyPress(Sender: TObject; var Key: Char);
    procedure DBGrid1KeyPress(Sender: TObject; var Key: Char);
    procedure ib(Sender: TObject);
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
    procedure FormShow(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
  private
    dataset : tibtable;
    procedure acertarTamanhoDBGRID();
    procedure abredataSetContasPagar();
    procedure reabredataSetContasPagar();
    procedure deletaContasPagar();
    procedure deletaEntrada();
    procedure deletaTranferencia();
    procedure deletaContasReceber();
    procedure deletaOrcamento();
    { Private declarations }
  public
  deletar:boolean;
  ordem, campoLocate, keyLocate : string;
  retorno, procura:string;
  esconde:string;
  tabela : string;
  formulario : tForm;
  campos : string;
  condicao:string;
  editlocaliza:boolean;
  cod: JsEdit;
  campolocaliza : string;
  editalvel:boolean;
    procedure criaDataSetPAISES();
  end;

var
  Form7: TForm7;
 implementation

uses Unit1, func, cadfornecedor, cadvendedor, StrUtils, Unit2;


{$R *.dfm}
procedure TForm7.deletaContasReceber();
var
  ren : integer;
begin
 if dm.IBQuery1.IsEmpty then exit;
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
end;

procedure TForm7.deletaTranferencia();
begin
  if dm.IBQuery1.IsEmpty then exit;
  if not funcoes.Contido('TRANSFERENCIA',UpperCase(tabela)) then exit;

  if messageDlg('Confirma Exclusão Desta Transferência?', mtConfirmation, [mbyes, mbNo], 0) = mrYes then
    begin
      FUNCOES.excluiTransferencia(dm.IBQuery1.fieldbyname('cod').AsInteger,dm.IBQuery1.fieldbyname('documento').AsInteger);
      dm.IBQuery1.Close;
      dm.IBQuery1.Open;
      {dm.IBQuery2.Close;
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
      end;   }
    end;
end;

procedure TForm7.deletaEntrada();
var
  val, temp : String;
begin
  if dm.IBQuery1.IsEmpty then exit;
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
end;

procedure TForm7.deletaContasPagar();
var
  ren : integer;
begin
  if UpperCase(tabela) <> 'CONTASPAGAR' then exit;
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
        dm.IBQuery2.SQL.Add('delete from contaspagar where (cod = :cod)');
        dm.IBQuery2.ParamByName('cod').AsString    := dataset.fieldbyname('cod').AsString;
        {dm.IBQuery2.SQL.Add('delete from contaspagar where (codgru = :gru) and (documento = :doc) and (vencimento = :data)');
        dm.IBQuery2.ParamByName('gru').AsString    := dataset.fieldbyname('codgru').AsString;
        dm.IBQuery2.ParamByName('doc').AsString    := dataset.fieldbyname('documento').AsString;
        dm.IBQuery2.ParamByName('data').AsDateTime := dataset.fieldbyname('vencimento').AsDateTime;}
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
end;

procedure TForm7.abredataSetContasPagar();
begin
  dataset := TIBTable.Create(self);
  dataset.Database  := dm.bd;
  dataset.TableName := UpperCase(tabela);
  dataset.Active := TRUE;
  dataset.Filter   := '(pago = 0)';
  dataset.Filtered := true;
  dataset.IndexName  := 'CONTASPAGAR_IDX2'; //INDICE VENCIMENTO
  dataset.First;

  dataset.FieldByName('fornec').Visible   := false;
  //dataset.FieldByName('usuario').Visible  := false;
  dataset.FieldByName('pago').Visible     := false;
  dataset.FieldByName('total').Visible    := false;
  dataset.FieldByName('valor').Index      := 4;

  //dataset.FieldByName('valor').ReadOnly      := true;
  //dataset.FieldByName('vencimento').ReadOnly := true;

 // funcoes.FormataCampos(tibquery(dataset), 2, '', 2);

  dm.ds.DataSet := dataset;
end;

procedure TForm7.reabredataSetContasPagar();
begin
  dataset.Active := false;
  dataset.Active := true;
  dataset.Filter   := '(pago = 0)';
  dataset.Filtered := true;
  dataset.IndexName  := 'CONTASPAGAR_IDX1'; //INDICE VENCIMENTO

  dataset.FieldByName('fornec').Visible   := false;
  //dataset.FieldByName('usuario').Visible  := false;
  dataset.FieldByName('pago').Visible     := false;
  dataset.FieldByName('total').Visible    := false;
  dataset.FieldByName('valor').Index      := 4;

  //dataset.FieldByName('valor').ReadOnly      := true;
  //dataset.FieldByName('vencimento').ReadOnly := true;

  funcoes.FormataCampos(tibquery(dataset), 2, '', 2);

  //dm.ds.DataSet := dataset;
end;

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
     if UpperCase(tabela) = 'MENU' then
       begin
         DBGrid1.SetFocus;
         exit;
       end;


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

     dm.IBQuery1.SQL.Clear;
     if ordem = '' then
       begin
         if condicao <> '' then dm.IBQuery1.SQL.Add('select '+campos+' from '+tabela+' '+condicao +' and ('+campolocaliza+' like upper('+ QuotedStr('%'+Edit1.Text+'%')+')) ')
           else dm.IBQuery1.SQL.Add('select '+campos+' from '+tabela+'  where ('+campolocaliza+' like upper('+ QuotedStr('%'+Edit1.Text+'%')+')) ');
       end
      else
        begin
          if condicao <> '' then dm.IBQuery1.SQL.Add('select '+campos+' from '+tabela+' '+condicao +' and ('+campolocaliza+' like upper('+ QuotedStr('%'+Edit1.Text+'%')+')) order by '+ordem)
            else dm.IBQuery1.SQL.Add('select '+campos+' from '+tabela+'  where ('+campolocaliza+' like upper('+ QuotedStr('%'+Edit1.Text+'%')+')) order by '+ordem)
        end;

     if dm.IBQuery1.SQL.GetText <> '' then
       begin
         dm.IBQuery1.Open;
         if dm.IBQuery1.IsEmpty then exit
           else
             begin
               funcoes.FormataCampos(dm.ibquery1,2,'',2);
               DBGrid1.SetFocus;
             end;

       end;
     if esconde <> '' then dm.IBQuery1.FieldByName(esconde).Visible:=false;


       { dm.IBQuery1.SQL.Clear;
        dm.IBQuery1.SQL.Add('select '+campos+' from '+tabela+' where '+campolocaliza+' like upper('+ QuotedStr('%'+Edit1.Text+'%')+') order by '+campolocaliza);
        dm.IBQuery1.Open;
        DBGrid1.SetFocus;
  } end;
end;

procedure TForm7.DBGrid1KeyPress(Sender: TObject; var Key: Char);
var i:integer;
var acc, mm, metodo:string;
begin
  if key = '+' then
    begin
      funcoes.aumentaFonte(self, true, 1, true);
    end;

  if key = '-' then
    begin
      funcoes.aumentaFonte(self, true, 2, true);
    end;

  key := UpCase(key);
  {if (tabela = 'contaspagar') and (not funcoes.Contido(key, #27 + #13)) then
    begin
      //sai pq não tem o que fazer aqui
      exit;
    end;}

  if key = #13 then begin
    if UpperCase(tabela) = 'PRODUTO' then begin
      if Contido('VALIDADE', UpperCase(campos)) then begin
        i   := DBGrid1.DataSource.DataSet.FieldByName('cod').AsInteger;
        mm  := LeftStr(DBGrid1.DataSource.DataSet.FieldByName('codbar').AsString, 5);
        acc := DBGrid1.DataSource.DataSet.FieldByName('validade').AsString;
        acc := funcoes.dialogo('generico',50,'0123456789'+ #8,50,false,'','Control For Windows','Qual a Validade ?', acc);
        if acc = '*' then exit;
        acc := LeftStr(acc, 2);
        acc := strzero(acc, 2);
        if StrToIntDef(acc, 0) <= 0 then acc := '';
        

        dm.IBQuery3.Close;
        dm.IBQuery3.SQL.Text := 'update produto set codbar = :codbar where cod = :cod';
        dm.IBQuery3.ParamByName('codbar').AsString := mm + acc;
        dm.IBQuery3.ParamByName('cod').AsInteger   := i;
        dm.IBQuery3.ExecSQL;

        dm.IBQuery3.Transaction.Commit;
        DBGrid1.DataSource.DataSet.Close;
        DBGrid1.DataSource.DataSet.Open;
        DBGrid1.DataSource.DataSet.Locate('cod', i, []);
        exit;
      end;
    end;
  end;

 if UpperCase(tabela) = 'MENU' then
   begin
     if key = #13 then
       begin
         funcoes.retornoLocalizar := DBGrid1.DataSource.DataSet.fieldbyname('cod').AsString;
         close;
         exit;
       end;
   end;

if (key = #32) and (UpperCase(tabela) = 'PRODUTO') then
  begin
    if DBGrid1.SelectedField.DisplayLabel = 'COD' then begin
      if funcoes.buscaParamGeral(65, 'N') = 'S' then begin
        acc := funcoes.dialogo('normal',0,''+ #8 + #13+ #27,0,false,'','Control For Windows','Qual o Código ?','');
        if acc = '*' then exit;

        {dm.IBQuery3.close;
        dm.IBQuery3.SQL.Text := ('select p.cod, nome, p.codbar from produto p left join codbarras c on (c.cod = p.cod) where (p.cod like '+QuotedStr(acc)+') order by nome');
        dm.IBQuery3.Open;

        if dm.IBQuery3.IsEmpty then begin
          dm.IBQuery3.Close;
          ShowMessage(acc + ' Não Encontrado');
          exit;
        end;

        mm := funcoes.busca(dm.IBQuery3, acc,'COD NOME CODBAR', 'cod' , '');
        if mm = '' then exit;}
        dm.IBQuery1.Locate('cod',strnum(acc),[loPartialKey]);
        exit;
      end;
    end;


    acc := funcoes.dialogo('normal',0,''+ #8 + #13+ #27,0,false,'','Control For Windows','Selecionar por:','');
    if acc = '*' then exit;

    metodo := funcoes.buscaParamGeral(47, '2');

    dm.IBQuery3.Close;
    dm.IBQuery3.SQL.Clear;
    if metodo = '2' then dm.IBQuery3.SQL.Add('select p.cod, nome, p.codbar from produto p left join codbarras c on (c.cod = p.cod) where (p.codbar like '+QuotedStr('%'+ acc +'%')+') or (nome like '+QuotedStr('%'+ acc +'%')+') or (c.codbar like '+QuotedStr('%'+ acc +'%')+') order by nome')
     else if metodo = '1' then dm.IBQuery3.SQL.Add('select p.cod, nome, p.codbar from produto p left join codbarras c on (c.cod = p.cod) where (p.codbar like '+QuotedStr(acc +'%')+') or (nome like '+QuotedStr(acc +'%')+') or (c.codbar like '+QuotedStr(acc +'%')+') order by nome')
     else dm.IBQuery3.SQL.Add('select p.cod, nome, p.codbar from produto p left join codbarras c on (c.cod = p.cod) where (p.codbar like '+QuotedStr('%'+ acc +'%')+') or (nome like '+QuotedStr('%'+ acc +'%')+') or (c.codbar like '+QuotedStr('%'+ acc +'%')+') order by nome');
    dm.IBQuery3.Open;

    if dm.IBQuery3.IsEmpty then
      begin
        dm.IBQuery3.Close;
        ShowMessage(acc + ' Não Encontrado');
        exit;
      end;

    mm := funcoes.busca(dm.IBQuery3, acc,'COD NOME CODBAR', 'cod' , '');
    if mm = '' then exit;
    dm.IBQuery1.Locate('cod',mm,[loPartialKey]);
  end;

if (key = #32) and (UpperCase(tabela) = 'CLIENTE') then
  begin
    metodo := funcoes.buscaParamGeral(47, '2');
    acc := funcoes.dialogo('normal',0,''+ #8 + #13+ #27,0,false,'','Control For Windows','Selecionar por:','');
    if acc = '*' then exit;

    dm.IBQuery2.Close;
    dm.IBQuery2.SQL.Clear;
    if metodo = '2' then dm.IBQuery2.SQL.Add('select cod,nome, telres, ende as endereco from cliente where (nome like '+ QuotedStr('%'+acc+'%') +') or (telres like ' + QuotedStr('%'+acc+'%') +') or (telcom like '+ QuotedStr('%'+acc+'%') +') or (ende like '+ QuotedStr('%'+acc+'%') +') or (cnpj like '+ QuotedStr('%'+acc+'%') +') ORDER BY NOME')
      else if metodo = '1' then dm.IBQuery2.SQL.Add('select cod,nome, ende as endereco, telres from cliente where (nome like '+ QuotedStr(acc+'%') +') or (telres like ' + QuotedStr(acc+'%') +') or (telcom like '+ QuotedStr(acc+'%') +') or (ende like '+ QuotedStr(acc+'%') +') or (cnpj like '+ QuotedStr(acc+'%') +') ORDER BY NOME');
    dm.IBQuery2.Open;

    if dm.IBQuery2.IsEmpty then
      begin
        dm.IBQuery2.Close;
        ShowMessage(acc + ' Não Encontrado');
        exit;
      end;

    mm := funcoes.busca(dm.IBQuery2, acc,'NOME TELRES TELCOM BAIRRO', 'cod' , '');
    if mm = '' then exit;
    dm.IBQuery1.Locate('cod',mm,[loPartialKey]);
end;

if ((ord(key))>=65) and (((ord(key)))<=95) then
begin
   if procura = '' then procura := UpperCase(key)
    else procura := procura + UpperCase(key);
    Timer1.Enabled:=false;
    if procura <> '' then
   begin
     Timer1.Enabled := true;
   end;
   
 DBGrid1.DataSource.DataSet.Locate(campolocaliza,procura,[loCaseInsensitive, loPartialKey]);
end;

if key=#13 then
  begin
   if UpperCase(tabela) = 'CONTASPAGAR' then
     begin
       funcoes.retornoLocalizar := DBGrid1.DataSource.DataSet.fieldbyname(retorno).AsString;
       close;
       exit;
     end;

   i:=0;
   acc:='';
   if formulario = form8 then form8.cod.Text := DBGrid1.SelectedField.Value
   else if formulario = form4 then form4.cod.Text := DBGrid1.SelectedField.Value
   else if formulario = funcoes then
    begin
     if not(editalvel) then
      begin
       if retorno<>'' then
        begin
         if StrToInt(funcoes.ContaChar(retorno,','))>0 then
           begin
             acc:=acc+DBGrid1.DataSource.DataSet.FieldByName(trim(copy(retorno,1,pos(',',retorno)-1))).AsString;
             acc:=acc+'-';
             acc:= acc+DBGrid1.DataSource.DataSet.FieldByName(trim(copy(retorno,pos(',',retorno)+1,length(retorno)))).AsString;
             funcoes.retornoLocalizar:= acc;
           end
         else
           begin
             funcoes.retornoLocalizar:= DBGrid1.DataSource.DataSet
             .fieldbyname(retorno).AsString;
           end;
        end;
     { else
        begin
          if retorno <> '' then funcoes.retornoLocalizar:= dm.IBQuery1.fieldbyname(retorno).AsString;
        end;}
     end;
   end;
   if retorno<>'' then
     begin
       Close;
       dm.IBQuery1.Close;
     end;
  end;
if (key=#27) and (Edit1.Visible) then Edit1.SetFocus;
if (key=#27) and not(Edit1.Visible) then close;
end;

procedure TForm7.ib(Sender: TObject);
var
  i, acc  : integer;
begin
   i:=0;
   acc:=0;
   DBGrid1.Width := self.Width - 10;
   dm.IBQuery1.Close;
   dm.IBQuery1.SQL.Clear;
   DBGrid1.DataSource := dm.ds;
   dm.ds.DataSet := dm.IBQuery1;

   if UpperCase(tabela) = 'CONTASPAGAR' then
     begin
       abredataSetContasPagar();
       acertarTamanhoDBGRID();
       self.Height := 400;
       DBGrid1.Height := 340;
       exit;
     end;

   If not Edit1.Visible then
    begin
     Edit1.Text :='';
     if ordem='' then dm.IBQuery1.SQL.Add('select '+campos+' from '+tabela+' order by '+campolocaliza)
     else  dm.IBQuery1.SQL.Add('select '+campos+' from '+tabela+' '+condicao +' order by '+ordem);
     dm.IBQuery1.Open;

     DBGrid1.DataSource.DataSet := dm.IBQuery1;

     funcoes.FormataCampos(dm.ibquery1,2,'',2);
     if esconde<>'' then dm.IBQuery1.FieldByName(esconde).Visible:=false;
     for i:=0 to DBGrid1.Columns.Count-1 do
      begin
       acc := acc + DBGrid1.Columns[i].Width;
      end;
     if acc < 299 then
       begin
         self.Width := acc + 10;
       end;
     DBGrid1.Align := alClient;
    end
    else
     begin
      Edit1.SetFocus;
     if ordem='' then dm.IBQuery1.SQL.Add('select '+campos+' from '+tabela+' order by '+campolocaliza+' asc')
     else  dm.IBQuery1.SQL.Add('select '+campos+' from '+tabela+' '+condicao +' order by '+ordem);
     dm.IBQuery1.Open;

     DBGrid1.DataSource.DataSet := dm.IBQuery1;
     funcoes.FormataCampos(dm.ibquery1,2,'',2);
       DBGrid1.Align := alBottom;
     end;
     if (tabela = 'orcamento') or (tabela = 'compra') or (tabela = 'entrada') then dm.IBQuery1.Last;

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

   funcoes.redimensionaTelaDbgrid(dbgrid1);
   try
     funcoes.aumentaFonte(self, true, 0, true);
   except
   end;  
end;

procedure TForm7.FormCreate(Sender: TObject);
begin
  campolocaliza := 'nome';
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
                try
                  Brush.Color := StringToColor(funcoes.buscaCorBDGRID_Produto); // Cor da célula
                except
                  Brush.Color := HexToTColor('F5F5F5');
                end;
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
  dm.IBQuery1.Close;
  if tabela = 'contaspagar' then
    begin
      if dataset.Transaction.InTransaction then dataset.Transaction.Commit;
      dataset.Free;
    end;

  if UpperCase(tabela) = 'PAISES' then begin

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
        deletaOrcamento;
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
      funcoes.IMP_CODBAR(cod);
      DBGrid1.DataSource.DataSet.Open;
      funcoes.FormataCampos(tibquery(DBGrid1.DataSource.DataSet), 2,'ESTOQUE',3);
      DBGrid1.DataSource.DataSet.Locate('cod', cod, []);
      DBGrid1.DataSource.DataSet.EnableControls;
    end;
  end;
end;

procedure TForm7.FormShow(Sender: TObject);
var
  i, acc  : integer;
begin
   Edit1.Text := '';
   i:=0;
   acc:=0;

   //self.DBGrid1.Height := self.Height - DBGrid1.Top - 20;

   if UpperCase(tabela) = 'MENU' then
     begin
       Edit1.SetFocus;
       form2.DataSource1.DataSet.Filtered := FALSE;
       form2.DataSource1.DataSet.First;
       DBGrid1.DataSource := form2.DataSource1;
       //DBGrid1.Align := alBottom;
       exit;
     end;


   DBGrid1.Width := self.Width - 10;
   dm.IBQuery1.Close;
   dm.IBQuery1.SQL.Clear;
   DBGrid1.DataSource := dm.ds;
   dm.ds.DataSet := dm.IBQuery1;


   if UpperCase(tabela) = 'CONTASPAGAR' then
     begin
       abredataSetContasPagar();
       acertarTamanhoDBGRID();
       self.Height := 400;
       DBGrid1.Height := 340;
       self.Height := Screen.Height - trunc(screen.Height * 0.15);
       self.DBGrid1.Height := self.Height - DBGrid1.Top - 20;
       exit;
     end;

   //If not Edit1.Visible then begin
   If editlocaliza = false then begin
     Panel1.Visible := false;

     Edit1.Text :='';
     if ordem='' then dm.IBQuery1.SQL.Text := ('select '+campos+' from '+tabela+ ' '+ condicao + ' ' + IfThen(campolocaliza <> '',' order by '+campolocaliza, '') )
     else  dm.IBQuery1.SQL.Text := ('select '+campos+' from '+tabela+' '+condicao +  ' order by '+ordem);

     try
     dm.IBQuery1.Open;
     except
       on e:exception do begin
         ShowMessage('erro757: ' + e.Message);
       end;
     end;

     DBGrid1.DataSource.DataSet := dm.IBQuery1;

     funcoes.FormataCampos(dm.ibquery1,2,'',2);
     if esconde<>'' then dm.IBQuery1.FieldByName(esconde).Visible:=false;
     for i:=0 to DBGrid1.Columns.Count-1 do
      begin
        acc := acc + DBGrid1.Columns[i].Width;
      end;
     if acc < 299 then
       begin
         self.Width := acc + 10;
       end;
     DBGrid1.Align := alClient;
    end
    else
     begin
       Panel1.Align := alTop;
       Panel1.Visible := true;
       DBGrid1.Align := alClient;
       Edit1.SetFocus;
       {edit1.Enabled := true;
       edit1.Visible := true;
       if edit1.Visible then Edit1.SetFocus;}

       if ordem='' then dm.IBQuery1.SQL.Text := 'select '+campos+' from '+tabela+ IfThen(campolocaliza <> '', ' order by '+campolocaliza+ ' asc', '')
        else  dm.IBQuery1.SQL.Add('select '+campos+' from '+tabela+' '+condicao +' order by '+ordem);

       dm.IBQuery1.Open;


       DBGrid1.DataSource.DataSet := dm.IBQuery1;
       funcoes.FormataCampos(dm.ibquery1,2,'',2);

       //DBGrid1.Align := alBottom;
     end;
     if (tabela = 'orcamento') or (tabela = 'compra') or (tabela = 'entrada') then dm.IBQuery1.Last;

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

   funcoes.redimensionaTelaDbgrid(dbgrid1);

   if UpperCase(tabela) = 'CONTASPAGAR' then
     BEGIN
       self.Height := Screen.Height - trunc(screen.Height * 0.15);
     END;

   if UpperCase(tabela) = 'PRODUTO' then
     begin
       //DBGrid1.Align := alClient;
       self.Height := Screen.Height - trunc(screen.Height * 0.15);
     end;

   if UpperCase(tabela) = 'CLIENTE' then
     begin
       //DBGrid1.Align := alClient;
       self.Height := Screen.Height - trunc(screen.Height * 0.15);
     end;

  {if Edit1.Visible then begin
    DBGrid1.Top := Edit1.Top + Edit1.Height + 10;
  end;}

  if UpperCase(tabela) = 'PAISES' then begin
    criaDataSetPAISES;
  end;


  if self.Top + self.Height > screen.Height then begin
    if self.Position = poScreenCenter then exit;
    self.Height := (screen.Height - self.Top) - 20;
  end;
end;

procedure TForm7.deletaOrcamento();
var
  val : String;
begin
  if dm.IBQuery1.IsEmpty then exit;
  if UpperCase(tabela) <> 'ORCAMENTO' then exit;

  if messageDlg('Deseja Excluir Este Orçamento R$ '+ formataCurrency(dm.IBQuery1.fieldbyname('total').AsCurrency) +' ?', mtConfirmation, [mbyes, mbNo], 0) = mrno then exit;

  val := dm.IBQuery1.fieldbyname('nota').AsString;

  dm.IBQuery4.Close;
  dm.IBQuery4.SQL.Clear;
  dm.IBQuery4.SQL.Add('delete from orcamento where nota = :nota');
  dm.IBQuery4.ParamByName('nota').AsString := val;
  dm.IBQuery4.ExecSQL;

  dm.IBQuery4.Close;
  dm.IBQuery4.SQL.Clear;
  dm.IBQuery4.SQL.Add('delete from ITEM_ORCAMENTO where nota = :nota');
  dm.IBQuery4.ParamByName('nota').AsString := val;
  dm.IBQuery4.ExecSQL;

  dm.IBQuery4.Transaction.Commit;

  dm.IBQuery1.Close;
  dm.IBQuery1.Open;
  funcoes.FormataCampos(dm.IBQuery1, 2, '', 2);

  dm.IBQuery1.Last;
end;

procedure TForm7.Edit1Change(Sender: TObject);
begin
  if UpperCase(tabela) = 'MENU' then
    begin
      if Edit1.Text = '' then
        begin
          form2.ClientDataSet1.Filtered := false;
          exit;
        end;

      form2.ClientDataSet1.Filter   :=   'nome like ''%' + Edit1.Text + '%''';
      form2.ClientDataSet1.Filtered := true;
    end;
end;

procedure TForm7.criaDataSetPAISES();
begin

  try
    if ClientDataSet1.IsEmpty = false then begin
      ClientDataSet1.First;
      DBGrid1.DataSource := DataSource1;
      exit;
    end;
  except

  end;

  dm.IBselect.Close;
  dm.IBselect.SQL.Text := 'select * from paises order by nome';
  dm.IBselect.Open;

  funcoes.Ibquery_to_clienteDataSet(dm.IBselect, ClientDataSet1);
  ClientDataSet1.Append;
  ClientDataSet1.FieldByName('cod').AsInteger := 8508;
  ClientDataSet1.FieldByName('nome').AsString  := 'VENEZUELA';
  ClientDataSet1.Post;

  ClientDataSet1.Append;
  ClientDataSet1.FieldByName('cod').AsInteger := 3379;
  ClientDataSet1.FieldByName('nome').AsString  := 'GUIANA INGLESA';
  ClientDataSet1.Post;


  while not dm.IBselect.Eof do begin
    if not Contido('-'+dm.IBselect.fieldbyname('cod').asstring+ '-','-3379-8508-') then begin
      ClientDataSet1.Append;
      ClientDataSet1.FieldByName('cod').AsInteger := dm.IBselect.fieldbyname('cod').AsInteger;
      ClientDataSet1.FieldByName('nome').AsString  := dm.IBselect.fieldbyname('nome').AsString;
      ClientDataSet1.Post;
    end;

    dm.IBselect.Next;
  end;

  DBGrid1.DataSource := DataSource1;
  ClientDataSet1.First;
end;

end.
