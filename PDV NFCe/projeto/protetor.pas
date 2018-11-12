unit protetor;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls;

type
  TForm4 = class(TForm)
    Timer1: TTimer;
    Image1: TImage;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
  private
    ini, fim : integer;
    { Private declarations }
  public
    lista : TStringList;
    caminho : String;
    { Public declarations }
  end;

var
  Form4: TForm4;

implementation

{$R *.dfm}

procedure TForm4.FormCreate(Sender: TObject);
begin
  ini := 0;
end;

procedure TForm4.FormShow(Sender: TObject);
begin
  fim := lista.Count -1;
  Timer1.Enabled := true;
end;

procedure TForm4.Timer1Timer(Sender: TObject);
begin
  Timer1.Enabled := false;

  ini := ini + 1;
  if ini > fim then ini := 0;

  Image1.Picture.LoadFromFile(caminho + 'papel\' + lista[ini]);
  Timer1.Enabled := true;
end;

procedure TForm4.FormKeyPress(Sender: TObject; var Key: Char);
begin
  close;
end;

end.
