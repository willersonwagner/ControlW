unit untObservacao;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls, IB_Controls;

type
  TfrmObservacao = class(TForm)
    Bevel1: TBevel;
    BtnOK: TBitBtn;
    ibobservacao: TIB_Memo;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  function Chama_Observacao():Boolean;

var
  frmObservacao: TfrmObservacao;

implementation

uses untCupomFiscal;

{$R *.dfm}

function Chama_Observacao():Boolean;
begin
 Result := true;
 try
  frmObservacao := TfrmObservacao.Create(nil);
  with frmObservacao do
   begin
    Position := poScreenCenter;
    ShowModal;
    if ModalResult = MrOk then Result := true;
   end;
 finally
  FreeAndNil(frmObservacao);
 end;
end;

end.
