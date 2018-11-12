unit JsEditTexto1;

interface

uses
  SysUtils, Classes, JsEdit1;

type
  JsEditTexto = class(JsEdit)
  private
    { Private declarations }
  protected
    { Protected declarations }
  public
    { Public declarations }
  published
    { Published declarations }
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('JsEdit', [JsEditTexto]);
end;

end.
 