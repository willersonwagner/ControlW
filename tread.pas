unit tread;

interface

uses classes, Windows, Messages, SysUtils, Variants, Graphics, Controls, Forms,
  Dialogs, ExtCtrls,IniFiles, StdCtrls, Menus, Buttons, JsBotao1, Vcl.Imaging.jpeg,
  Db, DBTables,  Mask, DBCtrls, ToolWin, ComCtrls;

type
  TTWMinhaThread = class(TThread)
  protected
    procedure Execute; override;
  public

    procedure formatarExecute(Sender: TObject);
  end;

implementation
uses unit1;

procedure TTWMinhaThread.Execute;
begin
  dm.produto.Open;
end;

procedure TTWMinhaThread.formatarExecute(Sender: TObject);
begin
   (dm.produto.FieldByName ('estoque') as tcurrencyfield).displayformat := '###,##0.00';
end;


end.
