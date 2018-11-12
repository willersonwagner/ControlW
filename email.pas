unit email;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, ACBrBase, ACBrMail,
  Vcl.ComCtrls;

type
  TForm70 = class(TForm)
    ACBrMail1: TACBrMail;
    Label1: TLabel;
    ProgressBar1: TProgressBar;
    Button1: TButton;
    memo1: TRichEdit;
    procedure Button1Click(Sender: TObject);
    procedure memo1Change(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form70: TForm70;

implementation

{$R *.dfm}

procedure TForm70.Button1Click(Sender: TObject);
begin
  close;
end;

procedure TForm70.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  memo1.Clear;
end;

procedure TForm70.memo1Change(Sender: TObject);
begin
  memo1.SelStart := Length(memo1.Text);
  SendMessage(memo1.Handle, WM_VSCROLL, SB_BOTTOM, 0);
  Application.ProcessMessages;
end;

end.
