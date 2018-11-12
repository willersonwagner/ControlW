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
unit consulta;

interface

uses
   Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Mask, JsEditData1, StdCtrls, JsEdit1, ExtCtrls, Buttons, dbGrids,
  Grids, DB, DBClient, Provider, IBCustomDataSet,IBQuery,
   ComCtrls, ToolWin, classes1, untnfceForm;
type
  TForm24 = class(TForm)
    DBGrid1: TDBGrid;
    procedure DBGrid1KeyPress(Sender: TObject; var Key: Char);
    procedure FormShow(Sender: TObject);
    procedure DBGrid1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure DBGrid1DrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure FormCreate(Sender: TObject);
    procedure DBGrid1CellClick1(Column: TColumn);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
  private
    procedure BuscaCodBar_F6_AutoPecas(busc4 : String; tipoBusca1 : String = '') ;
    procedure buscaReferencia();
    procedure buscaReferencia1();
    procedure BuscaCodBar_F6_AutoPecas1 ;
    procedure abreDataSetOrdenando();
       { Private declarations }
  public
    sqlVenda : String;
    retorno, BuscaCOd  : string;
    cosultaRetorna : boolean;
    { Public declarations }
  end;

var
  Form24: TForm24;

implementation
uses Unit1,subconsulta, StrUtils, func, principal;

{$R *.dfm}
procedure TForm24.buscaReferencia();
var
  temp, res, busca : string;
  rec : integer;
begin
  busca := funcoes.dialogo('normal',3,'',60,true,'','ControlW','Informe um Código:','');
  if ((busca = '*') or (busca = '')) then exit;

  dm.IBQuery2.Close;
  dm.IBQuery2.SQL.Text := 'select first 1 cod from produto where refori like :nome order by refori';
  dm.IBQuery2.ParamByName('nome').AsString := busca + '%';
  dm.IBQuery2.Open;

  if dm.IBQuery2.IsEmpty then
    begin
      dm.IBQuery2.Close;
      ShowMessage('Nenhum Registro Encontrado!');
      exit;
    end;

  busca := dm.IBQuery2.fieldbyname('cod').AsString;
  funcoes.ordernaDataSetVenda('refori', dm.IBQuery2.fieldbyname('cod').AsString, sqlVenda, DBGrid1, 'REFORI');

  //funcoes.dbgrid1Registro(dbgrid1);
  exit;

  temp := funcoes.dialogo('normal',3,'',60,true,'','ControlW','Selecionar Por:','');
  if temp = '*' then exit;

  res := '';

  dm.produtotemp.Close;
  dm.produtotemp.SQL.Text := ('select codbar, nome as Descricao,p_venda as Preco,quant as estoque,cod, refori from produto where upper(refori) like ('+ QuotedStr('%' + temp + '%') +') order by codbar desc');
  dm.produtotemp.Open;

  funcoes.FormataCampos(dm.produtotemp, 2, '', 2);

  if dm.produtotemp.IsEmpty then
    begin
      dm.produtotemp.Close;
      ShowMessage('Não encontrado');
      exit;
    end;

  dm.produtotemp.Close;
  dm.produtotemp.SQL.Clear;
  dm.produtotemp.SQL.Add('select cod, refori from produto where upper(refori) like ('+ QuotedStr( temp + '%' ) +') order by ' + refori1);
  dm.produtotemp.Open;

  if dm.produtotemp.IsEmpty then
    begin
      dm.produtotemp.Close;
      ShowMessage('Não encontrado');
      exit;
    end;

  res := dm.produtotemp.fieldbyname('cod').AsString;
  funcoes.ordernaDataSetVenda(refori1, res, sqlVenda, DBGrid1);

  exit;
  
  form25 := tform25.Create(self);
  funcoes.CtrlResize(tform(form25));
  form25.DBGrid1.DataSource := dm.dsprodtemp;
  form25.ShowModal;
end;

procedure TForm24.buscaReferencia1();
var
  temp, res : string;
begin
  temp := funcoes.dialogo('normal',3,'',60,true,'','ControlW','Selecionar Por:','');
  if temp = '*' then exit;

  res := '';

  dm.produtotemp.Close;
  dm.produtotemp.SQL.Text := ('select codbar, nome as Descricao,p_venda as Preco,quant as estoque,cod, refori from produto where upper(refori) like ('+ QuotedStr('%' + temp + '%') +') order by codbar desc');
  dm.produtotemp.Open;

  funcoes.FormataCampos(dm.produtotemp, 2, '', 2);

  if dm.produtotemp.IsEmpty then
    begin
      dm.produtotemp.Close;
      ShowMessage('Não encontrado');
      exit;
    end;

  dm.produtotemp.Close;
  dm.produtotemp.SQL.Clear;
  dm.produtotemp.SQL.Add('select cod, refori from produto where upper(refori) like ('+ QuotedStr( temp + '%' ) +') order by ' + refori1);
  dm.produtotemp.Open;

  if dm.produtotemp.IsEmpty then
    begin
      dm.produtotemp.Close;
      ShowMessage('Não encontrado');
      exit;
    end;

  res := dm.produtotemp.fieldbyname('cod').AsString;
  funcoes.ordernaDataSetVenda(refori1, res, sqlVenda, DBGrid1);

  exit;
  
  form25 := tform25.Create(self);
  funcoes.CtrlResize(tform(form25));
  form25.DBGrid1.DataSource := dm.dsprodtemp;
  form25.ShowModal;
end;


procedure TForm24.BuscaCodBar_F6_AutoPecas(busc4 : String; tipoBusca1 : String = '') ;
var
  busca, metodo : string;
begin
  if busca = '' then  busca := funcoes.dialogo('normal',3,'',60,true,'','ControlW','Informe um Código:','')
    else busca := busca;
  if ((busca = '*') or (busca = '')) then exit;

  dm.produtotemp.Close;
  dm.produtotemp.SQL.Clear;

  metodo := funcoes.buscaParamGeral(47, '2');

  if metodo = '2' then dm.produtotemp.SQL.Add('select p.codbar,nome as Descricao,p_venda as Preco,quant as estoque,p.cod from produto p left join codbarras c on (c.cod = p.cod) where (p.codbar = '+QuotedStr(busca)+') or (c.codbar = ' + QuotedStr(busca) + ')')
   else if metodo = '1' then dm.produtotemp.SQL.Add('select p.codbar,nome as Descricao,p_venda as Preco,quant as estoque,p.cod from produto p left join codbarras c on (c.cod = p.cod) where (p.codbar = '+QuotedStr(busca)+') or (c.codbar = ' + QuotedStr(busca) + ')');
  //dm.produtotemp.SQL.Add('select p.codbar,nome as Descricao,p_venda as Preco,quant as estoque,p.cod from produto p left join codbarras c on (c.cod = p.cod) where (p.codbar like '+QuotedStr('%'+ busca +'%')+') or (c.codbar like '+QuotedStr('%'+ busca +'%')+')');
  //dm.produtotemp.SQL.Add('select codbar,nome as Descricao,p_venda as Preco,quant as estoque,cod from produto p where (p.codbar like '+QuotedStr('%'+ busca +'%')+') or (p.cod = (select cod from codbarras where codbar like '+QuotedStr('%'+ busca +'%')+'))');

  if tipoBusca1 <> '' then metodo := tipoBusca1;
   if metodo = '3' then dm.produtotemp.SQL.Text := ('select p.codbar,nome as Descricao,p_venda as Preco,quant as estoque,p.cod from produto p left join codbarras c on (c.cod = p.cod) where (p.codbar like '+QuotedStr('%'+ busca +'%')+') or (c.codbar like '+QuotedStr('%'+ busca +'%')+')');

  form25 := TForm25.Create(self);
  funcoes.CtrlResize(tform(form25));
  form25.Caption := 'Consulta de Produto por Código de Barras';
  dm.produtotemp.Open;
  funcoes.FormataCampos(dm.produtotemp, 2, '', 2);
  form25.DBGrid1.DataSource := dm.dsprodtemp;

  if not dm.produtotemp.IsEmpty then
    begin
      form25.ShowModal;
    end
  else ShowMessage('Nenhum resultado encontrado');
  dm.produtotemp.Close;
  dm.produtotemp.SQL.Clear;
  dm.produtotemp.SQL.Add('select codbar,nome as Descricao,p_venda as Preco,quant as estoque,cod from produto order by nome');
  {dm.produtotemp.Close;
  dm.produtotemp.SQL.Clear;
  dm.produtotemp.SQL.Add('select p.codbar,nome as Descricao,p_venda as Preco,quant as estoque,p.cod from produto p left join codbarras c on (c.cod = p.cod) where (p.codbar = '+QuotedStr(busca)+') or (c.codbar = ' + QuotedStr(busca) + ')');
  //dm.produtotemp.SQL.Add('select p.codbar,nome as Descricao,p_venda as Preco,quant as estoque,p.cod from produto p left join codbarras c on (c.cod = p.cod) where (p.codbar like '+QuotedStr('%'+ busca +'%')+') or (c.codbar like '+QuotedStr('%'+ busca +'%')+')');
  //dm.produtotemp.SQL.Add('select codbar,nome as Descricao,p_venda as Preco,quant as estoque,cod from produto p where (p.codbar like '+QuotedStr('%'+ busca +'%')+') or (p.cod = (select cod from codbarras where codbar like '+QuotedStr('%'+ busca +'%')+'))');

  form25 := TForm25.Create(self);
  funcoes.CtrlResize(tform(form25));
  form25.Caption := 'Consulta de Produto por Código de Barras';
  dm.produtotemp.Open;
  funcoes.FormataCampos(dm.produtotemp, 2, '', 2);
  form25.DBGrid1.DataSource := dm.dsprodtemp;

  if not dm.produtotemp.IsEmpty then
    begin
      form25.ShowModal;
    end
  else ShowMessage('Nenhum resultado encontrado');
  dm.produtotemp.Close;
  dm.produtotemp.SQL.Clear;
  dm.produtotemp.SQL.Add('select codbar,nome as Descricao,p_venda as Preco,quant as estoque,cod from produto order by nome');}
end;

procedure TForm24.BuscaCodBar_F6_AutoPecas1 ;
var
 busca, res : string;
begin
  busca := funcoes.dialogo('normal',3,'',60,true,'','ControlW','Informe um Código:','');
  if ((busca = '*') or (busca = '')) then exit;


  dm.produtotemp.Close;
  dm.produtotemp.SQL.Clear;
  dm.produtotemp.SQL.Add('select cod, refori from produto where upper(codbar) like ('+ QuotedStr( busca + '%' ) +') order by codbar');
  dm.produtotemp.Open;

  if dm.produtotemp.IsEmpty then
    begin
      dm.produtotemp.Close;
      ShowMessage('Produto Não encontrado');
      exit;
    end;

  res := dm.produtotemp.fieldbyname('cod').AsString;
  funcoes.ordernaDataSetVenda('codbar', res, sqlVenda, DBGrid1);


  exit;
  dm.produtotemp.Close;
  dm.produtotemp.SQL.Text := ('select p.codbar,nome as Descricao,p_venda as Preco,quant as estoque,p.cod from produto p where (p.codbar like '+QuotedStr(busca+ '%')+') order by p.codbar');
  dm.produtotemp.Open;

  form25 := TForm25.Create(self);
  funcoes.CtrlResize(tform(form25));
  form25.Caption := 'Consulta de Produto por Código de Barras';
  funcoes.FormataCampos(dm.produtotemp, 2, '', 2);
  form25.DBGrid1.DataSource := dm.dsprodtemp;

  if not dm.produtotemp.IsEmpty then
    begin
      form25.ShowModal;
    end
  else ShowMessage('Nenhum resultado encontrado');
  dm.produtotemp.Close;
  dm.produtotemp.SQL.Clear;
  dm.produtotemp.SQL.Add('select codbar,nome as Descricao,p_venda as Preco,quant as estoque,cod from produto order by nome');
end;

procedure TForm24.DBGrid1KeyPress(Sender: TObject; var Key: Char);
var
  teste, busca, metodo, campos :string;
  cont:integer;
begin
  if key = #13 then
    begin
      if cosultaRetorna then
        begin
          retorno := dm.produto.fieldbyname('cod').AsString;
          codUlt  := retorno;
          close;
        end;
    end;

  if key = #27 then
    begin
      retorno := '*';
      close;
    end;
  key := UpCase(key);

  if ((ord(key)) >= 65) and (((ord(key))) <= 95) and (DBGrid1.SelectedField.DisplayLabel = 'DESCRICAO') then
    begin
      funcoes.procuraTimmer(dm.produto, key, 'descricao');
    end;

  If (key =#32) and (DBGrid1.SelectedField.DisplayLabel='CODBAR') then
  begin
    if ConfParamGerais[5] = 'S' then
      begin
        BuscaCodBar_F6_AutoPecas1;
        exit;
      end;

    BuscaCodBar_F6_AutoPecas('');
    exit;

  //  busca := funcoes.dialogo('normal',0,'',0,false,'','Control For Windows','Informe um Código','');
   // dm.produto.Locatefbu('cod', funcoes.buscaCodbarRetornaCodigo(busca) , []);
   // DBGrid1.SetFocus;
  end;

  If (key =#32) and (DBGrid1.SelectedField.DisplayLabel='APLICACAO') then
  begin
    if ConfParamGerais.Strings[5] = 'S' then
      begin
        FUNCOES.BuscaAplicacao(sqlVenda, DBGrid1, TRUE);
        exit;
      end;
  end;

  If (key =#32) and (DBGrid1.SelectedField.DisplayLabel='COD') then
  begin
        busca := funcoes.dialogo('normal',0,'',0,false,'','Control For Windows','Informe um Código','');
        if busca = '*' then exit;
        //funcoes.ordernaDataSetVenda('cod', busca, sqlVenda, DBGrid1);
        if not dm.produto.Locate('cod',busca,[loCaseInsensitive]) then
          begin
            ShowMessage('Produto Não Encontrado!');
          end;
        DBGrid1.SetFocus;
  end;


 if key=#27 then
  begin
    close;
  end;
 if (key=#32) and (DBGrid1.SelectedField.DisplayLabel='DESCRICAO') then
   begin

     metodo := funcoes.buscaParamGeral(47, '2');

     busca := funcoes.dialogo('normal',3,'',60,true,'','ControlW','Selecionar Por:','');
     if busca = '*' then exit;

     dm.IBQuery2.Close;
     dm.IBQuery2.SQL.Clear;

     if funcoes.buscaParamGeral(61, 'N') = 'S' then campos := 'refori,nome as descricao, quant, p_venda as preco, codbar,cod'
     else if funcoes.buscaParamGeral(61, 'N') = 'C' then campos := 'codbar,nome as descricao, quant, p_venda as preco, codbar,cod'
     else campos := 'cod,nome as descricao, quant, p_venda as preco, codbar';

     if metodo = '2' then dm.IBQuery2.SQL.Add('select '+campos+' from produto where (nome like '+ QuotedStr('%'+busca+'%') +') ORDER BY NOME')
       else if metodo = '1' then dm.IBQuery2.SQL.Add('select '+campos+' from produto where (nome like '+ QuotedStr(busca+'%') +') ORDER BY NOME');
     //dm.IBQuery2.SQL.Add('select cod,nome as descricao, quant, p_venda as preco, codbar from produto where (nome like '+ QuotedStr('%'+busca+'%') +') ORDER BY NOME');
     dm.IBQuery2.Open;

     busca := funcoes.busca(dm.IBQuery2, busca,'NOME', 'cod' , 'descricao');
     if busca = '' then exit;
     funcoes.ordernaDataSetVenda('descricao', busca, sqlVenda, DBGrid1);
     //DBGrid1.DataSource.DataSet.Locate('cod',busca,[loPartialKey]);
   end;

   If (key = #32) and (DBGrid1.SelectedField.DisplayLabel='REFORI') then
     begin
       buscaReferencia;
     end;

end;

procedure TForm24.FormShow(Sender: TObject);
var
  cont:integer;
  sim : String;
begin
  dm.produto.close;
  dm.produto.SQL.Clear;
  sim := 'N';
  try
    sim := ConfParamGerais.Strings[43];
  except
    sim := 'N';
  end;

  if sim = 'S' then
    begin
      dm.produto.SQL.Add('select cod,nome as Descricao,p_venda as Preco,quant as estoque,refori as '+ refori1 +',deposito,unid,codbar,aplic as Aplicacao,localiza as Localizacao,igual as Equivalente, p_compra as custo from produto order by nome asc;');
      sqlVenda := 'select cod,nome as Descricao,p_venda as Preco,quant as estoque,refori as '+ refori1 +',deposito,unid,codbar,aplic as Aplicacao,localiza as Localizacao,igual as Equivalente, p_compra as custo from produto';
    end
   else
     begin
       dm.produto.SQL.Add('select cod,nome as Descricao,p_venda as Preco,quant as estoque,refori as '+ refori1 +',deposito,unid,codbar,aplic as Aplicacao,localiza as Localizacao,igual as Equivalente from produto order by nome asc;');
       sqlVenda := 'select cod,nome as Descricao,p_venda as Preco,quant as estoque,refori as '+ refori1 +',deposito,unid,codbar,aplic as Aplicacao,localiza as Localizacao,igual as Equivalente from produto';

       if ((sim = 'C') and (RetornaAcessoUsuario = 0)) then begin
         dm.produto.SQL.Text := ('select cod,nome as Descricao,p_venda as Preco,quant as estoque,refori as '+ refori1 +',deposito,unid,codbar,aplic as Aplicacao,localiza as Localizacao, p_compra as custo from produto order by nome');
         sqlVenda := 'select cod,nome as Descricao,p_venda as Preco,quant as estoque,refori as '+ refori1 +',deposito,unid,codbar,aplic as Aplicacao,localiza as Localizacao, p_compra as custo from produto';
       end;
     end;

  dm.produto.Open;
  funcoes.fetchDataSet(dm.produto);

  if strnum(BuscaCOd) <> '' then dm.produto.Locate('cod', strnum(BuscaCOd), []);


  funcoes.OrdenaCamposVenda(ConfParamGerais.Strings[1]);
  funcoes.FormataCampos(dm.produto,2,'ESTOQUE',3);
  DBGrid1.DataSource := dm.dsprod;
  cont := 1;

  funcoes.aumentaFonte(self, true, 0);
end;

procedure TForm24.DBGrid1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var cod:string;
begin
  if (ssCtrl in Shift) and (chr(Key) in ['P', 'p']) then
    begin
      funcoes.IMP_CODBAR(DBGrid1.DataSource.DataSet.fieldbyname('cod').AsString);
    end;

  if key = 120 then //120 = F9 abre tela de equivalência
   begin
     if ConfParamGerais[5] = 'S' then
       begin
         funcoes.buscaEquivalencia1(dm.produto.fieldbyname('cod').AsString);
         exit;
       end;
   end;

  if key = 123 then //120 = F9 abre tela de equivalência
   begin
     abreDataSetOrdenando;
   end;

if key = 117 then
  begin
      BuscaCodBar_F6_AutoPecas('', '3');
      exit;
  end;


 if key=116 then
  begin
    cod:=dm.produto.fieldbyname('cod').AsString;
    dm.produto.close;
    dm.produto.Open;
    funcoes.fetchDataSet(dm.produto);
    funcoes.FormataCampos(dm.produto,2,'ESTOQUE',3);
    dm.produto.Locate('cod',cod,[]);
  end;

end;

procedure TForm24.DBGrid1DrawColumnCell(Sender: TObject; const Rect: TRect;
  DataCol: Integer; Column: TColumn; State: TGridDrawState);
begin
  if (gdSelected in State) then Begin // Se o estado da célula não é selecionado
    DBGrid1.Canvas.Brush.Color := StringToColor(funcoes.buscaCorBDGRID_Produto(1)); // Cor da célula
    DBGrid1.Canvas.Font.Color  := StringToColor(funcoes.buscaCorBDGRID_Produto(2)); // Cor da célula
    DBGrid1.Canvas.FillRect (Rect); // Pinta a célula
    DBGrid1.DefaultDrawColumnCell(Rect, DataCol, Column, State);
  End;
if DBGrid1.DataSource.DataSet.RecNo mod 2 = 0 then
  begin
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


procedure TForm24.FormCreate(Sender: TObject);
begin
  cosultaRetorna := false;
  BuscaCOd       := '';
end;

procedure TForm24.DBGrid1CellClick1(Column: TColumn);
var
    SavePlace: TBookmark;
    PrevValue: Variant;
    x, i:Integer;
 begin
  {  x := TStringGrid(DBGrid1).VisibleRowCount div 2-
        TStringGrid(DBGrid1).Row;
    with dm.produto do
    begin
      DisableControls;
      MoveBy(x);
      SavePlace := GetBookmark;
      try
         with DBGrid1 do begin
           for i:=0 to SelectedRows.Count-1 do begin
             GotoBookmark(pointer(SelectedRows.Items[i]));
           end;
         end;
      finally
        GotoBookmark(SavePlace);
        FreeBookmark(SavePlace);
     end;
     MoveBy(-x);
     EnableControls;
   end;  }

end;


procedure TForm24.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if key = '+' then
    begin
      funcoes.aumentaFonte(self, true, 1);
    end;

  if key = '-' then
    begin
      funcoes.aumentaFonte(self, true, 2);
    end;
end;


procedure TForm24.abreDataSetOrdenando();
var
  cod, campo : String;
begin
  if dm.produto.Active then begin
    cod   := dm.produto.FieldByName('cod').AsString;
    campo := DBGrid1.SelectedField.DisplayName;
  end;

  dm.produto.Close;
  dm.produto.SQL.Text := sqlVenda + ' ORDER BY ' + campo;
  dm.produto.Open;

  dm.produto.Locate('cod', cod, []);
  funcoes.OrdenaCamposVenda(ConfParamGerais.Strings[1]);
  funcoes.FormataCampos(dm.produto,2,'ESTOQUE',3);

  DBGrid1.SelectedIndex := funcoes.buscaFieldDBgrid1(campo, DBGrid1);
end;

end.
