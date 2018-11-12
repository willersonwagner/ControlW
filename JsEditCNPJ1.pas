unit JsEditCNPJ1;

interface

uses
  SysUtils, Classes, Controls, StdCtrls, Graphics, Windows, Messages, Forms, contnrs,
  Dialogs, Buttons, Mask, JsEdit1;

type
  JsEditCNPJ = class(TMaskEdit)
   private
    valida : boolean;
  protected
    { Protected declarations }
  public
    constructor Create(AOwner: TComponent);override;
    procedure KeyPress(var Key: Char);override;
    procedure KeyDown(var Key: Word; shift : TShiftState);override;
    function ValidaCPF() : boolean;
    function CompletaString(parcial : string) : string;
  published
    property ValidaCampo :boolean read valida write valida default false;
  end;

procedure Register;

implementation
var lista : TObjectList; primeiroCampo : TObject;

procedure Register;
begin
  RegisterComponents('JsEdit', [JsEditCNPJ]);
end;

constructor JsEditCNPJ.Create(AOwner: TComponent);
begin
  Inherited;
  JsEdit.AdicionaComponente(Self);
  Self.EditMask := '!99.999.999/9999-99;1;_';
  lista := JsEdit.GetLista();
end;

procedure JsEditCNPJ.KeyPress(var Key: Char);
var ok : boolean;
begin
  if (Key = #27) then
    begin
      JsEdit.LimpaCampos(self.Owner.Name);
    end;

  inherited KeyPress(Key);
  //if ((Key <> #13) and (Key <> #27) and (Key <> #8)) then
  //   inherited KeyPress(Key);
  {if Key = #8 then
     begin
       Text := '__.___.___/___-___';
       ReformatText(EditMask);
       key := #0;
     end;}
  ok := true;
  if (Key = #13) then
     begin
       if (Self.Text = '  .   .   /   -  ') then
          begin
            //se valida campo, não deixa passar em branco
            if (Self.valida) then
               begin
                 ok := false;
                 ShowMessage('Campo de preenchimento obrigatório');
                 Self.SetFocus;
               end;
          end
        else
          if (not validaCPF) then
             begin
               ShowMessage('CPF Inválido, favor digitar novamente');
               Self.SelectAll;
               Self.SetFocus;
               ok := false;
               Key := #0;
             end;

       if ok then
          PostMessage((Owner as TWinControl).Handle, WM_NEXTDLGCTL, 0, 0)
  end;

  if (Self.Text = '') then Self.Text := '__.___.___/___-___';
end;

function JsEditCNPJ.validaCPF() : boolean;
begin
  result := True;
end;

procedure JsEditCNPJ.KeyDown(var Key: Word; shift : TShiftState);
begin
    {if Key = 46 then
       begin
         Text := '__.___.___/___-___';
         ReformatText(EditMask);
         key := 0;
       end;}
    //teclas PgUp e PgDown - passam o foco para o çprimeiro botão

    if ((Key = 33) or (Key = 34)) then
       JsEdit.SetFocusNoPrimeiroBotao;
    //seta acima - sobe até o primeiro componente
    if (Key = 38) then
       begin
         if TEdit(lista.First).Enabled then primeiroCampo := lista.First else
            primeiroCampo := lista.Items[1];
         if (self <> primeiroCampo) then
            PostMessage((Owner as TWinControl).Handle, WM_NEXTDLGCTL, 1, 0);
            //ShowMessage(JsEdit.ConteudoDelimitado(self));
       end;
    //seta abaixo - não passa do primeiro e nem do último para baixo
    if ((Key = 40) and (self <> lista.Last)) then
        PostMessage((Owner as TWinControl).Handle, WM_NEXTDLGCTL, 0, 0);
        
  inherited KeyDown(key, shift);
end;

function JsEditCNPJ.CompletaString(parcial : string) : string;
var ini : integer; atual, ret : string;
begin
   atual := datetostr(date);
   ret := '';
   for ini := 1 to length(atual) do
     begin
       if (copy(parcial, ini, 1) = ' ') then
          ret := ret + copy(atual, ini, 1)
         else
          ret := ret + copy(parcial, ini, 1);
     end;
   result := ret;
end;

end.


