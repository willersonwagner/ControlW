unit JsEditInteiro1;

interface

uses
  SysUtils, Classes, Controls, StdCtrls, Graphics, Windows, Messages, Forms, contnrs,
  Dialogs, JsEdit1;

type
  JsEditInteiro = class(JsEdit)
  private
    { Private declarations }
  protected
    { Protected declarations }
  public
    procedure KeyPress(var Key: Char); override;
    function getValor() : integer;
    constructor Create(AOwner:TComponent);override;
  published
    { Published declarations }
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('JsEdit', [JsEditInteiro]);
end;

constructor JsEditInteiro.Create(AOwner: TComponent);
begin
  Inherited Create(AOwner);
  self.TipoDeDado := teNumero;
end;

procedure JsEditInteiro.KeyPress(var Key: Char);
begin
  Inherited;
  if ((Key = #13) and (Self = jsedit.GetPrimeiroCampo(self.Owner.Name)))then
    begin
      self.Enabled := false;
    end
   else
    if not(Key in['0'..'9',#8,#27]) then Key:=#0;
  //Inherited KeyPress(Key);
end;

function JsEditInteiro.getValor() : integer;
begin
  result := 0;
  if Text <> '' then result := strtointdef(Text, 0);
end;


end.
