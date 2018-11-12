unit untCancelaNFCe;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, OleCtrls, SHDocVw, StdCtrls, Grids, ComCtrls, Buttons,
  ExtCtrls,func;

type
  TfrmCancelaNFCe = class(TForm)
    cod: TEdit;
    Label1: TLabel;
    serial: TEdit;
    Label2: TLabel;
    Button1: TButton;
    Button2: TButton;
    empresa: TEdit;
    Label3: TLabel;
    procedure FormShow(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    Stat : String;
    { Public declarations }
  end;

  function dlgCancelaNFCe():Boolean;

var
  frmCancelaNFCe: TfrmCancelaNFCe;

implementation

uses untDtmMain;

{$R *.dfm}

function dlgCancelaNFCe():Boolean;
begin
 Result := false;
 try
  frmCancelaNFCe := TfrmCancelaNFCe.Create(nil);
  with frmCancelaNFCe do
   begin
    Position := poScreenCenter;
    ShowModal;
    if ModalResult = mrOk then Result := true;
   end;
 finally
  FreeAndNil(frmCancelaNFCe);
 end;

end;

procedure TfrmCancelaNFCe.FormShow(Sender: TObject);
var
  valor : Single;

begin
  Randomize;
  valor := random;
  valor := StrToFloat(((copy(strnum(FloatToStr(valor)), 1, 10))));
  cod.Text := StrNum(FloatToStr(valor)) ;

  dtmMain.IBQuery1.Close;
  dtmMain.IBQuery1.SQL.Text := 'select empresa from registro';
  dtmMain.IBQuery1.Open;

  empresa.Text := dtmMain.IBQuery1.fieldbyname('empresa').AsString;
  dtmMain.IBQuery1.Close;
end;

procedure TfrmCancelaNFCe.Button2Click(Sender: TObject);
begin
  Stat := '*';
  close;
end;

procedure TfrmCancelaNFCe.Button1Click(Sender: TObject);
var
  emp : string;
  t1, t2 : integer;
begin
  if trim(empresa.Text) = '' then
    begin
      ShowMessage('Este banco de Dados não foi registrado para o controlW');
      exit;
    end;

  t2 := trunc(StrToInt(StrNum(cod.Text)) / 37.3);
  if StrNum(serial.Text) <> IntToStr(t2) then
    begin
      ShowMessage('Serial Inválido');
      exit;
    end;

  emp := trim(empresa.Text);
  t1  := StringToInteger(emp);
  t1  := trunc(t1 * 57.3);

  dtmMain.IBQuery1.Close;
  dtmMain.IBQuery1.SQL.Text := 'update registro set versao = :ver';
  dtmMain.IBQuery1.ParamByName('ver').AsString := IntToStr(t1);
  dtmMain.IBQuery1.ExecSQL;
  dtmMain.IBQuery1.Transaction.Commit;

  ShowMessage('Registro efetuado com Sucesso');
  close;
end;

procedure TfrmCancelaNFCe.FormCreate(Sender: TObject);
begin
  Stat := '';
end;

end.
