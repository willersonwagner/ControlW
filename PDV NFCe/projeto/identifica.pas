unit identifica;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TForm8 = class(TForm)
    Memo1: TMemo;
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form8: TForm8;

implementation

{$R *.dfm}

procedure TForm8.FormShow(Sender: TObject);
begin
  if FileExists(ExtractFileDir(ParamStr(0)) + '\inden.txt') then Memo1.Lines.LoadFromFile(ExtractFileDir(ParamStr(0)) + '\inden.txt');
end;

end.
