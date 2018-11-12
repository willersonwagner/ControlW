unit P4InfoVarejo_Splash;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, jpeg, StdCtrls;

type
  TfrmSplash = class(TForm)
    Image1: TImage;
    Label1: TLabel;
    Label2: TLabel;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

procedure Exibe_Splash();

var
  frmSplash: TfrmSplash;

implementation     

{$R *.dfm}

procedure Exibe_Splash();
begin
 try
  frmSplash := TfrmSplash.Create(nil);
  with frmSplash do
   begin
    Position := poScreenCenter;
    Update;
    Show;
    Application.ProcessMessages;
    Sleep(3000);
    Update;
    Application.ProcessMessages;
    Sleep(3000);
    Application.ProcessMessages;
    ModalResult := mrOk;
   end;
 finally
  FreeAndNil(frmSplash);
 end;
end;

procedure TfrmSplash.FormCreate(Sender: TObject);
var
 diretorio:string;
begin
 diretorio := ExtractFilePath(Application.ExeName);
 if FileExists(diretorio + '\Splash.jpg') then Image1.Picture.LoadFromFile(diretorio + '\Splash.jpg');
end;

end.
