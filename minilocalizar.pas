unit minilocalizar;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Menus, ExtCtrls,
   VclTee.TeeGDIPlus, VCLTee.TeEngine, VCLTee.TeeProcs, VCLTee.Chart,
  VCLTee.TeeFunci, VCLTee.Series;

type
  TForm28 = class(TForm)
    Chart1: TChart;
    Series1: TBarSeries;
    TeeFunction1: TLowTeeFunction;
    Panel1: TPanel;
    Label1: TLabel;
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form28: TForm28;

implementation

{$R *.dfm}

procedure TForm28.FormKeyPress(Sender: TObject; var Key: Char);
begin
if key=#27 then close;

end;

procedure TForm28.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
if key=113 then
 begin
   Chart1.PrintProportional :=true;
   Chart1.PrintLandscape;
 end;
end;

end.
