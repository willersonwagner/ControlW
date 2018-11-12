unit importapedido;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, DBGrids, DB, IBCustomDataSet, IBQuery, StdCtrls, func;

type
  TForm2 = class(TForm)
    DBGrid1: TDBGrid;
    DBGrid2: TDBGrid;
    Label1: TLabel;
    Venda: TIBQuery;
    itens: TIBQuery;
    DataSource1: TDataSource;
    DataSource2: TDataSource;
    procedure DBGrid2CellClick(Column: TColumn);
    procedure FormShow(Sender: TObject);
    procedure DBGrid1KeyPress(Sender: TObject; var Key: Char);
    procedure FormCreate(Sender: TObject);
    procedure DBGrid1KeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure DBGrid1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    procedure abreItens();
    procedure abreVenda(const nota : String);
    procedure importarCupom();
    { Private declarations }
  public
    nota : string;
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation

uses untDtmMain;

{$R *.dfm}
procedure TForm2.abreVenda(const nota : String);
begin
  venda.Open;
  FormataCampos(venda, 2, '',2);
  if nota <> '' then venda.Locate('nota', nota, []);
end;

procedure TForm2.importarCupom();
var
  nota : String;
begin
  {nota := InputBox('NFCe - ControlW', 'Informe o Número da Venda:', '');
  if nota = '' then exit;

  dtmMain.IBQuery1.Close;
  dtmMain.IBOQuery1.SQL.Text := 'select nota from venda where nota = :nota';
  dtmMain.IBOQuery1.ParamByName('nota').AsString := nota;
  try
    dtmMain.IBOQuery1.Open;
  except
    ShowMessage('Ocorreu um erro, Tente Novamente.');
    exit;
  end;
 }
 //dlgTransferenciaCF(venda.fieldbyname('nota').AsString);
end;

procedure TForm2.abreItens();
begin
  itens.Close;
  itens.SQL.Text := 'select i.cod, (select nome from produto p where p.cod = i.cod) as nome, i.p_venda as preco, i.total from item_venda i where nota = :nota';
  try
    itens.ParamByName('nota').AsString := venda.fieldbyname('nota').AsString;
    itens.Open;
  except
  end;
end;

procedure TForm2.DBGrid2CellClick(Column: TColumn);
begin
  abreItens();
end;

procedure TForm2.FormShow(Sender: TObject);
begin
  abreVenda('');
  abreItens();
end;

procedure TForm2.DBGrid1KeyPress(Sender: TObject; var Key: Char);
begin
  if key = #13 then
    begin
      nota := venda.fieldbyname('nota').AsString;
      //importarCupom();
      //abreVenda(nota);
      //abreItens();
      //venda.Locate('nota', nota, []);
      close;
    end;

  if key = #27 then
    begin
      nota := '';
      close;
    end;

end;

procedure TForm2.FormCreate(Sender: TObject);
begin
  nota := '';
end;

procedure TForm2.DBGrid1KeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if ((key = 38) or (key = 40)) then abreItens();
end;

procedure TForm2.DBGrid1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key = 117 then
    begin
      venda.Close;
      venda.Open;
      FormataCampos(venda, 2, '', 2);
      abreItens();

      FormataCampos(itens, 2, '', 2);
    end;
end;

end.
