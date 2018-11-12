unit UntGerenciaCancelamento;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Buttons;

type
  TfrmGerenciaCancelamento = class(TForm)
    RDGOpcaoCancelar: TRadioGroup;
    EdtCancelar: TEdit;
    BtnOK: TBitBtn;
    BtnCancelar: TBitBtn;
    procedure EdtCancelarKeyPress(Sender: TObject; var Key: Char);
    procedure RDGOpcaoCancelarClick(Sender: TObject);
    procedure EdtCancelarExit(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

function Chama_Cancelamentos(var iItem:integer; var retorno:integer):Integer;

var
 valorRetorno:integer;

var
  frmGerenciaCancelamento: TfrmGerenciaCancelamento;

implementation

{$R *.dfm}

function Chama_Cancelamentos(var iItem:integer; var retorno:integer):Integer;
begin
 Result  := 0;
 iItem   := 0;
 retorno := 0;
 try
  frmGerenciaCancelamento  := TfrmGerenciaCancelamento.Create(nil);
  with frmGerenciaCancelamento do
   begin
    Position := poScreenCenter;
    ShowModal;
    if ModalResult = mrOk then
     begin
      retorno := RDGOpcaoCancelar.ItemIndex;
      if RDGOpcaoCancelar.ItemIndex = 1 then
       begin
        iItem := StrToInt(EdtCancelar.Text);
        retorno := 1;
       end;
     end else retorno := -1;
   end;
   Result := retorno;
 finally
  FreeAndNil(frmGerenciaCancelamento);
 end;
end;

procedure TfrmGerenciaCancelamento.EdtCancelarKeyPress(Sender: TObject;
  var Key: Char);
begin
 if not(Key in['0'..'9',#8,#10,#13]) then
  Key := #0;
end;

procedure TfrmGerenciaCancelamento.RDGOpcaoCancelarClick(Sender: TObject);
begin
 if RDGOpcaoCancelar.ItemIndex = 1 then
  begin
   EdtCancelar.Enabled := true;
   EdtCancelar.Text    := '';
  end else
   begin
    EdtCancelar.Enabled := false;
    EdtCancelar.Text    := '';
   end;
end;

procedure TfrmGerenciaCancelamento.EdtCancelarExit(Sender: TObject);
begin
 if RDGOpcaoCancelar.ItemIndex  = 1 then
  begin
   if EdtCancelar.Text = '' then
    begin
     MessageDlg('Informe o Número do Item a Ser Cancelado.',mtInformation,[MbOk],0);
     EdtCancelar.SetFocus;
     ModalResult := mrNone;
     exit;
    end;
  end;
end;

end.
