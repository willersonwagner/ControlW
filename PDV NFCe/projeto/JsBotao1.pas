unit JsBotao1;

interface

uses
  SysUtils, Classes, Controls, StdCtrls, Graphics, Windows, Messages, Forms, contnrs, JsEdit1, Buttons, Dialogs;

type
  JsBotao = class(TBitBtn)
  private
    { Private declarations }
  protected
    { Protected declarations }
  public
    constructor Create(AOwner:TComponent);override;
    procedure KeyPress(var Key: Char); override;
    procedure KeyDown(var Key: Word; shift : TShiftState);override;
    procedure KeyUp(var Key: Word; shift : TShiftState);override;
  published
    { Published declarations }
  end;

procedure Register;

implementation


procedure Register;
begin
  RegisterComponents('JsEdit', [JsBotao]);
end;

constructor JsBotao.Create(AOwner: TComponent);
begin
  Inherited;
  JsEdit.AdicionaBotao(Self);
end;

procedure JsBotao.KeyPress(var Key: Char);
begin
  inherited KeyPress(Key);
  if (Key = #27) then JsEdit.Limpacampos(self.Owner.Name);
end;

procedure JsBotao.KeyDown(var Key: Word; shift : TShiftState);
begin
  inherited KeyDown(Key, shift);
  if key = 34 then self.Click;
  if (Key = 38) then
    begin
       PostMessage((Owner as TWinControl).Handle, WM_NEXTDLGCTL, 1, 0);
    end;
  if (Key = 40) then
    PostMessage((Owner as TWinControl).Handle, WM_NEXTDLGCTL, 0, 0);
end;

procedure JsBotao.KeyUp(var Key: Word; shift : TShiftState);
begin
  inherited;
    if (Key = 38) then
        PostMessage((Owner as TWinControl).Handle, WM_NEXTDLGCTL, 1, 0);
end;

end.
