unit formpagtoformulario;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DBCtrls, StdCtrls;

type
  TForm18 = class(TForm)
    ListBox1: TListBox;
    Label1: TLabel;
    procedure FormShow(Sender: TObject);
    procedure ListBox1KeyPress(Sender: TObject; var Key: Char);
    procedure ListBox1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    valorlistbox:integer;
    escSair : boolean;
    option : Smallint;
    padrao : string;
    { Public declarations }
  end;

var
  Form18: TForm18;

implementation

uses Unit1, DB, vendas, func, StrUtils;

{$R *.dfm}


procedure TForm18.FormShow(Sender: TObject);
var
  ini : integer;
  tmp : String;
begin
 //  ShowMessage(Label1.Caption);
 // Label1.Visible := true;
 if option = 0 then
  begin
  if ListBox1.Items.Count = 0 then
  begin
    dm.IBQuery2.Close;
    dm.IBQuery2.SQL.Text := 'select cod, nome from FORMPAGTO order by cod';
    dm.IBQuery2.Open;

    while not (dm.IBQuery2.Eof) do
     begin
        ListBox1.Items.Add(dm.IBQuery2.fieldbyname('cod').AsString+'- '+dm.IBQuery2.fieldbyname('nome').AsString);
        dm.IBQuery2.Next;
     end;

    dm.IBQuery2.Close;
    if valorlistbox <> null then ListBox1.ItemIndex := valorlistbox;
  end;
end;

  if padrao <> '' then
    begin
      for ini := 0 to ListBox1.Count -1 do
        begin
          tmp := ListBox1.Items[ini];
          tmp := LeftStr(tmp, pos('-', tmp) -1);
          tmp := StrNum(tmp);

          if tmp = padrao then
            begin
              ListBox1.Selected[ini] := true;
              break;
            end;
        end;
    end;

  if ListBox1.ItemIndex = -1 then ListBox1.Selected[0] := true;
end;

procedure TForm18.ListBox1KeyPress(Sender: TObject; var Key: Char);
begin
  if key=#13 then
    begin
     funcoes.formpato:=copy(ListBox1.Items.Strings[ListBox1.itemIndex],1,pos('-',ListBox1.Items.Strings[ListBox1.itemIndex])-1);
     close;
    end;
  if escSair then
    begin
      if key=#27 then
        begin
          funcoes.formpato := '*';
          close;
        end;
    end;    
end;

procedure TForm18.ListBox1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key=119 then
  begin
    funcoes.formpato := '*';
    key:=0;
    close;
  end;
end;

procedure TForm18.FormCreate(Sender: TObject);
begin
  funcoes.AjustaForm(self);
end;

end.

