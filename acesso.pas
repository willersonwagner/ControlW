unit acesso;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TForm37 = class(TForm)
    ListBox1: TListBox;
    Label1: TLabel;
    Label2: TLabel;
    ListBox2: TListBox;
    procedure ListBox1Enter(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ListBox1KeyPress(Sender: TObject; var Key: Char);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ListBox2KeyPress(Sender: TObject; var Key: Char);
    procedure ListBox2Enter(Sender: TObject);
  private
    acesso,alterado : string;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form37: TForm37;

implementation

uses Unit2, func, Unit1;

{$R *.dfm}
procedure TForm37.ListBox1Enter(Sender: TObject);
begin
Label2.Caption := 'Use as setas para se movimentar entre'+#13+'as seções e pressione ENTER para entrar'+#13+'nas rotinas de cada seção. No quadro ao'+#13+'lado, pressione ENTER para modificar o'+#13+'de cada rotina';
end;

procedure TForm37.FormShow(Sender: TObject);
var i:integer;
begin
 ListBox1.SetFocus;
 for i:=0 to form2.MainMenu1.Items.Count-1 do
  begin
    ListBox1.Items.Add(funcoes.DeletaChar('&',Form2.MainMenu1.Items.Items[i].Caption));
  end;
  dm.IBQuery2.Close;
  dm.IBQuery2.SQL.Clear;
  dm.IBQuery2.SQL.Add('select acesso from acesso');
  dm.IBQuery2.Open;
  acesso := dm.IBQuery2.FieldByName('acesso').AsString;
  dm.IBQuery2.Close;
  alterado := acesso;
  ListBox1.Selected[0] := true;
end;

procedure TForm37.ListBox1KeyPress(Sender: TObject; var Key: Char);
var i,posi:integer;
a:string;
begin
 if (key=#13) and (ListBox1.ItemIndex>-1) then
  begin
    posi := pos('-'+IntToStr(ListBox1.ItemIndex)+'-',acesso) + 3;
    //ShowMessage(acesso[posi]);
    ListBox2.Clear;
    for i:= 0 to Form2.MainMenu1.Items.Items[ListBox1.ItemIndex].Count -1 do
     begin
       ListBox2.Items.Add(acesso[posi+i]+'-'+funcoes.DeletaChar('&',Form2.MainMenu1.Items.Items[ListBox1.itemindex].Items[i].Caption));
     end;
    if ListBox2.Items.Count>0 then
     begin
      ListBox2.SetFocus;
      ListBox2.Selected[0] := true;
     end;
  end;

if key=#27 then
 begin
  ListBox1.Clear;
  Close;
 end;
end;

procedure TForm37.FormClose(Sender: TObject; var Action: TCloseAction);
begin
ListBox1.Clear;
ListBox2.Clear;
end;

procedure TForm37.ListBox2KeyPress(Sender: TObject; var Key: Char);
var char1,sim: string;
begin
 if key=#27 then
  begin
   if alterado<>acesso then
    begin
     sim := funcoes.dialogo('generico',0,'SN',30,false,'S',Application.Title,'Deseja Salvar as Alterações?','S');
     if sim='S' then
      begin
       dm.IBQuery2.Close;
       dm.IBQuery2.SQL.Clear;
       dm.IBQuery2.SQL.Add('update acesso set acesso='+QuotedStr(alterado) +' where substring(acesso from 1 for 1) = ''-''');
       dm.IBQuery2.ExecSQL;
       dm.IBQuery2.Transaction.Commit;
       dm.IBQuery2.Close;
       ListBox2.Clear;
       ListBox1.SetFocus;
       acesso := alterado;
      end
     else
      begin
       alterado := acesso;
       ListBox2.Clear;
       ListBox1.SetFocus;
      end;
    end
   else
    begin
     ListBox2.Clear;
     ListBox1.SetFocus;
    end;
  end;
 if (key=#13) and (ListBox2.ItemIndex>-1) then
  begin
   char1 := funcoes.dialogo('generico',0,'1234567890'+#8+#32,30,false,'S',Application.Title,'Confirme o Nível de Acesso',ListBox2.Items.Strings[ListBox2.itemindex][1]);
   if char1<>'*' then
    begin
     if char1='' then char1 := ' ';
     ListBox2.Items.Strings[ListBox2.ItemIndex] := char1  + copy(ListBox2.Items.ValueFromIndex[ListBox2.ItemIndex],1,length(ListBox2.Items.ValueFromIndex[ListBox2.ItemIndex]));
     char1 := ListBox2.Items.Strings[ListBox2.itemindex][1];
     alterado[(pos('-'+IntToStr(ListBox1.ItemIndex)+'-',alterado) + 3)+ListBox2.ItemIndex] := char1[1];
    end;
  end;
end;

procedure TForm37.ListBox2Enter(Sender: TObject);
begin
Label2.Caption := 'O nivel de acesso de uma rotina é a'+#13+'quantidade de bloqueios que um usuário'+#13+'pode ter para usá-la. Um exemplo, a ro-'+#13+'tina cancelamento de nota tem tem nivel'+#13+'0, isto é, apenas usuários com 0 blo-'+#13+'queios podem usá-la. Se o nivel estiver'+#13+'em branco, a rotina fica sempre aberta.';
end;

end.
