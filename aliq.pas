unit aliq;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, DBGrids, DB,ibquery, IBCustomDataSet, IBTable;

type
  Taliq1 = class(TForm)
    DBGrid1: TDBGrid;
    IBTable1: TIBTable;
    DataSource1: TDataSource;
    procedure FormShow(Sender: TObject);
    procedure DBGrid1KeyPress(Sender: TObject; var Key: Char);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure IBTable1BeforeInsert(DataSet: TDataSet);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  aliq1: Taliq1;

implementation

uses Unit1, func;

{$R *.dfm}

procedure Taliq1.FormShow(Sender: TObject);
begin
  IBTable1.Database := dm.bd;
  IBTable1.TableName := 'ALIQ';
  IBTable1.Open;
  funcoes.FormataCampos(tibquery(ibtable1),2,'',2);
end;

procedure Taliq1.DBGrid1KeyPress(Sender: TObject; var Key: Char);
begin
  IF key = #27 then close;
end;

procedure Taliq1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  IBTable1.Close;
  IBTable1.Free;
end;

procedure Taliq1.IBTable1BeforeInsert(DataSet: TDataSet);
begin
  if DBGrid1.Focused then Abort;
end;

end.
