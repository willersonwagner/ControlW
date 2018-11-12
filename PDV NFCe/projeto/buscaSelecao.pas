unit buscaSelecao;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, DBGrids, DB, DBClient,ibquery;

type
  TForm33 = class(TForm)
    DBGrid1: TDBGrid;
    DataSource1: TDataSource;
    ClientDataSet1: TClientDataSet;
    procedure DBGrid1KeyPress(Sender: TObject; var Key: Char);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure DBGrid1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
  public
    retornoEnter    : String;
    campobusca      : string;
    campolocalizaca : string;
    acessoUsu, configu : String;
    txt : AnsiString;

    { Public declarations }
  end;

var
  Form33: TForm33;

implementation

uses func, untVendaPDV, login1, StrUtils, untDtmMain, login;

{$R *.dfm}

procedure TForm33.DBGrid1KeyPress(Sender: TObject; var Key: Char);
var
  doc : String;
  a, c, b : integer;
  key1    : char;
  val, total, ent, totalDesc : currency;
begin

  if key=#13 then
  begin
    if campolocalizaca = 'RET01' then
      begin
        if DBGrid1.SelectedField.DisplayName = 'preco' then
          begin
            //doc := dialogoG('numero', 0, '', 2, false, '', 'PDV - ControlW', 'Informe o Valor Pago:', formataCurrency(DBGrid1.DataSource.DataSet.FieldByName('preco').AsCurrency), true);
            //if doc = '*' then exit;

            ent := DBGrid1.DataSource.DataSet.FieldByName('precoOrigi').AsCurrency;
            form3.lancaDesconto(total, ent, configu, form1.pgerais.Values['2'], acessoUsu, DBGrid1.DataSource.DataSet.FieldByName('preco').AsCurrency);
            if total = DBGrid1.DataSource.DataSet.FieldByName('precoOrigi').AsCurrency then exit;

            //ShowMessage('Total='+CurrToStr(ent) + #13 + 'Desc=' + CurrToStr(total));

            //total := DBGrid1.DataSource.DataSet.FieldByName('preco').AsCurrency;
            //total := StrToCurr(doc) - total;

            //aqui eu pego o valor original e o valor de desconto
            val := Arredonda(DBGrid1.DataSource.DataSet.FieldByName('quant').AsCurrency * DBGrid1.DataSource.DataSet.FieldByName('precoOrigi').AsCurrency, 2);
            totalDesc := Arredonda(DBGrid1.DataSource.DataSet.FieldByName('quant').AsCurrency * ent, 2);

            total := val - totalDesc;
            total := -total;

            form3.tot_ge := form3.tot_ge + total;
            form3.descontoItens := form3.descontoItens + total;
            Form3.PainelTotal.Caption := formataCurrency(form3.tot_ge);

            DBGrid1.DataSource.DataSet.Edit;
            DBGrid1.DataSource.DataSet.FieldByName('preco').AsCurrency := ent;
            DBGrid1.DataSource.DataSet.FieldByName('total').AsCurrency := totalDesc;
            DBGrid1.DataSource.DataSet.Post;
            //form3.lancaDesconto( DBGrid1.SelectedField.);
          end;
      end;

    if campobusca = '' then exit;
    retornoEnter  := DataSource1.DataSet.fieldbyname(campobusca).AsString;

    //if campobusca <> 'codbar1' then funcoes.SetRetornoBusca(DataSource1.DataSet.fieldbyname(campobusca).AsString);
    self.close;
  end;

  if key = #27 then
    begin
      retornoEnter := '';
      self.close;
    end;
end;

procedure TForm33.FormShow(Sender: TObject);
  var fim, i, tot : integer;
begin
  if campolocalizaca = 'RET01' then
    begin
      acessoUsu := form3.acessoUsuVenda;
      configu   := form3.configu;
    end;
    
  fim := DBGrid1.Columns.Count - 1;
  tot := 0;
  for i := 0 to fim do
    begin
      tot := tot + DBGrid1.Columns.Items[i].Width + 16;
    end;
  if tot <> 0 then self.Width := tot;
end;

procedure TForm33.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if Contido('Ficha' , Caption) then
    begin
      ClientDataSet1.Free;
    end;
end;

procedure TForm33.DBGrid1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  cod, codbar : string;
  log : Boolean;
  codigo : integer;
begin
  if campolocalizaca = 'RET01' then
    begin
      if key = 115 then
        begin
          form53.login_muda_as_variaveis_de_usuario(log, acessoUsu, codbar, configu);
          if log then
            begin
              if length(acessoUsu) > 3 then cod := 'Acesso Negado Por Login de Usuário com Bloqueios: ' + codbar
                else cod := 'Acesso Permitido de: ' + codbar;
              ShowMessage(cod);
            end;
        end;

      if key = 46 then
        begin
          if Length(acessoUsu) > 0 then
            begin
              MessageDlg('Usuário bloqueado para Cancelamento de Item da Venda', mtError, [mbOK], 1);
              exit;
            end;

          if LeftStr(DBGrid1.DataSource.DataSet.fieldbyname('nome').AsString, 15) = '** CANCELADO **' then
            begin
              MessageDlg('Este Produto Já foi Cancelado', mtError, [mbOK], 1);
              exit;
            end;

          if MessageBox(Handle, pchar('Deseja Exluir o Produto?' + #13 + DBGrid1.DataSource.DataSet.fieldbyname('nome').AsString), pchar('PDV - ControlW') ,MB_YESNO + MB_ICONQUESTION + MB_DEFBUTTON2) = idno then exit;


          cod    := DBGrid1.DataSource.DataSet.FieldByName('cod').AsString;
          codigo := StrToInt(cod);
          form3.cancelaItemVisual(DBGrid1.DataSource.DataSet.RecNo, DBGrid1.DataSource.DataSet.fieldbyname('total').AsCurrency);
          DBGrid1.DataSource.DataSet.Edit;
          DBGrid1.DataSource.DataSet.fieldbyname('nome').AsString := copy('** CANCELADO ** '+ DBGrid1.DataSource.DataSet.fieldbyname('nome').AsString, 1, 40);
          DBGrid1.DataSource.DataSet.Post;

          form3.buscaPreco(codigo, 0);

          //configu        := form1.configu;
      //acessoUsuVenda := form1.acesso;
          acessoUsu := form1.acesso;
          configu   := form1.configu;
        end;
    end;

  if campobusca = 'arq' then
    begin
      if key = 119 then //F8 DOWNLOAD XML
        begin
          codbar := dialogo('mask',300, '!0000.0000.0000.0000.0000.0000.0000.0000.0000.0000.0000;1;_', 300, false, '', 'ControlW', 'Informe a Chave:', '');
          if codbar = '*' then exit;
        end;  
      exit;
    end;

{  if ((campobusca = 'codbar') or (campobusca = 'codbar1')) then
    begin
      if key = 46 then
        begin
      if messageDlg('Deseja Excluir?', mtConfirmation, [mbyes, mbNo], 0) = mrYes then
        begin
          cod := DBGrid1.DataSource.DataSet.fieldbyname('cod').AsString;
          codbar := DBGrid1.DataSource.DataSet.fieldbyname('codbar').AsString;

          dm.IBQuery1.Close;
          dm.IBQuery1.SQL.Clear;
          dm.IBQuery1.SQL.Add('delete from codbarras where ((cod = :cod) and (codbar = :codbar))');
          dm.IBQuery1.ParamByName('cod').AsString := cod;
          dm.IBQuery1.ParamByName('codbar').AsString := codbar;
          dm.IBQuery1.ExecSQL;

          dm.IBQuery1.Transaction.Commit;

          dm.IBQuery1.Close;
          dm.IBQuery1.SQL.Clear;
          dm.IBQuery1.SQL.Add('update produto set codbar = '+QuotedStr('')+' where ((cod = :cod) and (codbar = :codbar))');
          dm.IBQuery1.ParamByName('cod').AsString := cod;
          dm.IBQuery1.ParamByName('codbar').AsString := codbar;
          dm.IBQuery1.ExecSQL;

          dm.IBQuery1.Transaction.Commit;

          DBGrid1.DataSource.DataSet.Close;
          DBGrid1.DataSource.DataSet.Open;
          if campobusca = 'codbar1' then close;
        end;
      end;
    end;
}end;

end.
