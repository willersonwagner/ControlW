unit prod;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, DBGrids, StdCtrls, Buttons, ibquery, ComCtrls, ToolWin,
  ExtCtrls, JsEditNumero1, JsEdit1, JsEditInteiro1, Mask, JsEditData1,
  JsBotao1, Data.DB;

type
  TForm21 = class(TForm)
    Panel1: TPanel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    nomeLabel: TLabel;
    DataSource1: TDataSource;
    Label1: TLabel;
    documento: JsEditInteiro;
    data: JsEditData;
    destino: JsEditInteiro;
    cod: JsEditInteiro;
    quant: JsEditNumero;
    descricao: JsEdit;
    DBGrid1: TDBGrid;
    Panel2: TPanel;
    Label7: TLabel;
    JsBotao1: JsBotao;
    procedure FormShow(Sender: TObject);
    procedure destinoKeyPress(Sender: TObject; var Key: Char);
    procedure documentoKeyPress(Sender: TObject; var Key: Char);
    procedure codKeyPress(Sender: TObject; var Key: Char);
    procedure JsBotao1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure quantKeyPress(Sender: TObject; var Key: Char);
    procedure documentoKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure DBGrid1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure dataKeyPress(Sender: TObject; var Key: Char);
    procedure descricaoKeyPress(Sender: TObject; var Key: Char);
    procedure DBGrid1KeyPress(Sender: TObject; var Key: Char);
  private
    procedure abreDataSet();
    procedure limpaCampos(parcial : boolean = true);
    { Private declarations }
  public
    esc : boolean;
    tipo:string;
    sub:string;
    grupo:string;
    fornec:string;
    function GravaTrans : boolean;
    function jaExisteTransferencia(cod, doc : String) : boolean;
    { Public declarations }
  end;

var
  Form21: TForm21;
  sair : boolean;
implementation

uses Unit1, StrUtils, func, subconsulta, principal, caixaLista, vendas;

{$R *.dfm}
function tform21.GravaTrans : boolean;
var
  loja, dep : currency;
begin

  dm.IBQuery1.Close;
  dm.IBQuery1.SQL.Clear;
  //dm.IBQuery1.SQL.Add('insert into transferencia(data,destino,documento,cod,quant,descricao,usuario) values(:data,'+destino.Text+',gen_id(transferencia, 1),'+cod.Text+',:quant,'+QuotedStr(descricao.Text)+','+form22.codusario+')');
  dm.IBQuery1.SQL.Add('insert into transferencia(data,destino,documento,cod,quant,'+
  'descricao,usuario) values(:data,:destino,:doc,:cod'+
  ',:quant,:nome,'+StrNum(form22.codusario)+')');
  dm.IBQuery1.ParamByName('data').AsDateTime  := StrToDateDef(data.Text, form22.datamov);
  dm.IBQuery1.ParamByName('destino').AsString := StrNum(destino.Text);
  dm.IBQuery1.ParamByName('doc').AsString     := StrNum(documento.Text);
  dm.IBQuery1.ParamByName('cod').AsString     := StrNum(cod.Text);
  dm.IBQuery1.ParamByName('quant').AsCurrency := quant.getValor;
  dm.IBQuery1.ParamByName('nome').AsString    := descricao.Text;
  dm.IBQuery1.ExecSQL;

  if StrToIntDef(destino.Text, 1) = 2 then
    begin
      loja := - quant.getValor;
      dep  :=   quant.getValor;
    end
  else
    begin
      loja :=  quant.getValor;
      dep  := -  quant.getValor;
    end;

  dm.IBQuery1.Close;
  dm.IBQuery1.SQL.Clear;
  dm.IBQuery1.SQL.Add('update produto set quant = quant + :q, deposito = deposito + :d where cod = :cod');
  dm.IBQuery1.ParamByName('q').AsCurrency  := loja;
  dm.IBQuery1.ParamByName('d').AsCurrency  := dep;
  dm.IBQuery1.ParamByName('cod').AsInteger := StrToIntDef(cod.Text, 0);
  dm.IBQuery1.ExecSQL;

  try
    dm.IBQuery1.Transaction.Commit;
  except
    on e:exception do begin
      ShowMessage('Ocorreu um Erro Indesperado e a Transacao nao pode ser concluida.' + #13 + e.Message);
      dm.IBQuery1.Transaction.Rollback;
      exit;
    end;
  end;
  //JsEdit.LimpaCampos(self.Name);

  limpaCampos;
  //data.Text := FormatDateTime('dd/mm/yyyy',form22.datamov);
  destino.SetFocus;
  Result := true;

  abreDataSet;
end;

procedure TForm21.FormShow(Sender: TObject);
begin
  data.Text := FormatDateTime('dd/mm/yyyy', form22.datamov);
  abreDataSet;
end;

procedure TForm21.descricaoKeyPress(Sender: TObject; var Key: Char);
begin
if key = #27 then limpaCampos(false);
end;

procedure TForm21.destinoKeyPress(Sender: TObject; var Key: Char);
begin
if key = #27 then limpaCampos(false);
if (key=#13) and ((tedit(sender).Text='0') or (tedit(sender).Text='')) then
 begin
   form39 := tform39.Create(self);
   form39.ListBox1.Items.Add('1 - LOJA');
   form39.ListBox1.Items.Add('2 - DEPOSITO');
   tedit(sender).Text := funcoes.lista(Sender, false);
   if tedit(sender).Text = '*' then
     begin
       tedit(sender).Text := '';
       key := #0;
     end;
  //tedit(sender).Text := funcoes.localizar('Tipo de Cliente','tipocli','cod,nome','cod','cod','nome','cod',false,false,false,'',300,sender);
 end;

end;

procedure TForm21.documentoKeyPress(Sender: TObject; var Key: Char);
begin
  if key = #27 then CLOSE;

  if (key = #13) then begin
    if(tedit(sender).Text = '') then begin
      tedit(sender).Text := IntToStr(StrToInt(Incrementa_Generator('transferencia', 0)) + 1);
    end;

    abreDataSet;
    key := #0;
    data.SetFocus;
  end;
end;

procedure TForm21.documentoKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
if key = 119 then
    begin
       funcoes.localizar('Localizar Transferencia','transferencia,produto','data,destino,documento,transferencia.cod,nome,transferencia.quant','documento','','documento','documento',true,false,true,' where produto.cod = transferencia.cod',600,nil);
    end;
end;

procedure TForm21.codKeyPress(Sender: TObject; var Key: Char);
var
  nome : string;
begin
  if key = #27 then limpaCampos(false);
  if key = #27 then key := #0;
  if (key = #13) then
    begin
      if (tedit(sender).Text = '') then begin
        tedit(sender).Text := funcoes.localizar('Localizar Produto','produto','cod,nome,quant as loja,deposito, codbar','cod','','nome','nome',false,false,false,'',590,nil);
        abreDataSet;
      end;
      if (tedit(sender).Text = '') then
        begin
          key := #0;
          exit;
        end;
      if (tedit(sender).Text <> '') then
        begin
          nome := '';
          nome := '';
          if funcoes.verProdutoExisteRetornaNome(tedit(sender).Text, nome) then nomeLabel.Caption := nome
            else
              begin
                nomeLabel.Caption := '**Produto não encontrado**';
                key := #0;
              end;

          if jaExisteTransferencia(cod.Text,'') then begin
            ShowMessage('Esse Produto Já Foi Lançado, Favor Exclua e Lance Novamente!');
            cod.Text := '';
            key := #0;
          end;
        end;
    end;

end;

procedure TForm21.dataKeyPress(Sender: TObject; var Key: Char);
begin
  if key = #27 then limpaCampos(false);
end;

procedure TForm21.DBGrid1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key = 46 then begin
    if funcoes.excluiTransferencia(DBGrid1.DataSource.DataSet.FieldByName('cod').AsInteger,DBGrid1.DataSource.DataSet.FieldByName('documento').AsInteger) then begin
      abreDataSet;
      ShowMessage('Transferência Excluida Com Sucesso!');
    end;
  end;
end;

procedure TForm21.DBGrid1KeyPress(Sender: TObject; var Key: Char);
begin
  if key = #27 then cod.SetFocus;
end;

procedure TForm21.JsBotao1Click(Sender: TObject);
var
  origem : integer;
begin
  if jaExisteTransferencia(cod.Text,'') then begin
    ShowMessage('Esse Produto Já Foi Lançado, Favor Exclua e Lance Novamente!');
    cod.Text := '';
    cod.SetFocus;
    exit;
  end;

  origem := 1;
  if destino.Text = '1' then origem := 2;
  if funcoes.limitar_QTD_Estoque(quant.getValor, StrToIntDef(cod.Text, 0), origem) then GravaTrans;
end;

procedure TForm21.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  JsEdit.LiberaMemoria(self);

end;

procedure TForm21.quantKeyPress(Sender: TObject; var Key: Char);
begin
esc := false;
if key = #27 then limpaCampos(false);

if key = #13 then
    begin
      if quant.getValor <= 0 then
        begin
          tedit(sender).SetFocus;
          key := #0;
        end;
    end;
end;

procedure TForm21.abreDataSet();
begin
  dm.IBQuery3.Close;
  dm.IBQuery3.SQL.Text := 'select t.cod, t.documento, p.nome as descricao, iif(destino = 1, ''LOJA'', ''DEPOSITO'') as destino, t.quant as quatidade, ' +
  'u.nome as usuario from TRANSFERENCIA t left join produto p on (t.cod = p.cod) left join usuario u on (u.cod = t.usuario) ' +
  ' where t.documento = :doc ';
  dm.IBQuery3.ParamByName('doc').AsString := strnum(documento.Text);
  dm.IBQuery3.Open;

  dm.IBQuery3.FieldByName('documento').Visible := false;

  funcoes.FormataCampos(dm.IBQuery3, 2, '', 2);

  DataSource1.DataSet := dm.IBQuery3;
  DBGrid1.DataSource := DataSource1;
end;

procedure TForm21.limpaCampos(parcial : boolean = true);
begin
  if parcial then begin
    //destino.Text := '';
    cod.Text := '';
    quant.Text := '0,000';
    descricao.Text := '';
    exit;
  end;

  data.Text := '';
  documento.Text := '';
  documento.SetFocus;
end;


function TForm21.jaExisteTransferencia(cod, doc : String) : boolean;
begin
  Result := false;
  if DBGrid1.DataSource.DataSet.Locate('cod', cod, [])  then begin
    Result := true;
  end;
end;

end.
