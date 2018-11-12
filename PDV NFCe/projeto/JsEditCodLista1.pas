unit JsEditCodLista1;

interface

uses
  SysUtils, Classes, Controls, StdCtrls, JsEdit1, CheckLst, Forms;

type
  JsEditCodLista = class(JsEdit)
  private
    { Private declarations }
  protected
    { Protected declarations }
  public
    procedure KeyPress(var Key: Char); override;
    function getValor() : integer;
    procedure AdicionaLista(Texto : TStrings);
  published
    { Published declarations }
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('JsEdit', [JsEditCodLista]);
end;

procedure JsEditCodLista.KeyPress(var Key: Char);
begin
  Inherited KeyPress(Key);
  if not(Key in['0'..'9', #8, #13]) then Key:=#0;
  if Key = #13 then
    begin

    end;

end;

function JsEditCodLista.getValor() : integer;
begin
  result := strtoint(Text);
end;

procedure JsEditCodLista.AdicionaLista(Texto : TStrings);
begin
   //if ListBox1 = nil then ListBox1 := TCheckListBox.Create(Self);
  // ListBox1.parent := formulario;
   //ListBox1.Items.AddStrings(Texto);
   //ListBox1.Name := 'ListBox1';
   //ListBox1.Left := self.Left;
   //ListBox1.Height := (self.Height * 10);
   //ListBox1.Width := (self.Width * 5);

  // ListBox1.Columns := 4;
   //ListBox1.MultiSelect := false;
   //ListBox1.Sorted := true;
   //ListBox1.Top := self.Top + 20;
   //ListBox1.Visible := true;
   //ListBox1.SetFocus;

end;

end.
