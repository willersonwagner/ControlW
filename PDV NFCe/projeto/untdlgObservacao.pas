unit untdlgObservacao;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, IB_Controls, Buttons;

type
  TfrmdlgObservacao = class(TForm)
    Panel1: TPanel;
    IB_Memo1: TIB_Memo;
    btnok: TBitBtn;
    btncancela: TBitBtn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  function dlgObservacao():Boolean;

var
  frmdlgObservacao: TfrmdlgObservacao;

implementation

uses untCupomFiscalSAT, untDtmMain;

{$R *.dfm}

function dlgObservacao():Boolean;
begin
 Result := false;
 try
  frmdlgObservacao := TfrmdlgObservacao.Create(nil);
  with frmdlgObservacao do
   begin
    Position := poScreenCenter;
    ShowModal;
    if ModalResult = mrok then Result := true;
   end;
 finally
  FreeAndNil(frmdlgObservacao);
 end;
end;

end.
