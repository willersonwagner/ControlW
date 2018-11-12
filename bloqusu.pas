unit bloqusu;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TForm36 = class(TForm)
    ListBox1: TListBox;
    procedure ListBox1KeyPress(Sender: TObject; var Key: Char);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
   codusu,configu,temp:string;
   cont: integer;
   tipo,troca,teclas,maiorQue : TStringList;
    { Public declarations }
  end;

var
  Form36: TForm36;

implementation

uses func, Unit1, principal;

{$R *.dfm}

procedure TForm36.ListBox1KeyPress(Sender: TObject; var Key: Char);
var arr: array [0..6] of string;
 acc:string;
 i:integer;
begin
 if cont= 2 then
  begin
   if key=#27 then close;
   if key = #13 then
    begin
     if ListBox1.ItemIndex = 0 then
       begin
        if maiorQue.Strings[ListBox1.ItemIndex] <> '' then
         begin
          acc := '100';
          while StrToCurr(acc) > StrToInt(maiorQue.Strings[ListBox1.ItemIndex]) do
           begin
            acc := funcoes.dialogo(tipo.Strings[ListBox1.Itemindex],2,teclas.Strings[ListBox1.itemindex],2,false,troca.Strings[ListBox1.itemindex],Application.Title,ListBox1.Items.Strings[ListBox1.itemindex],funcoes.LerConfig(temp,ListBox1.ItemIndex));
            if acc = '*' then exit;
           end;
          temp := GravarConfig(temp,acc,ListBox1.ItemIndex);
         end;
       end
      else
       begin
        temp := funcoes.geraStringConfigUsuario(temp, ListBox1.Count);
        if tipo.Strings[ListBox1.Itemindex] = 'numero' then acc := funcoes.dialogo(tipo.Strings[ListBox1.Itemindex],2,teclas.Strings[ListBox1.itemindex],2,false,troca.Strings[ListBox1.itemindex],Application.Title,ListBox1.Items.Strings[ListBox1.itemindex],funcoes.LerConfig(temp,ListBox1.ItemIndex))
         else
           begin
             acc := funcoes.dialogo(tipo.Strings[ListBox1.Itemindex],2,teclas.Strings[ListBox1.itemindex],20,false,troca.Strings[ListBox1.itemindex],Application.Title,ListBox1.Items.Strings[ListBox1.itemindex],funcoes.LerConfig(temp,ListBox1.ItemIndex));
           end;
        if acc = '*' then exit;
        temp := GravarConfig(temp,acc,ListBox1.ItemIndex);
       end;
  end;
end;

if cont = 1 then
 begin
  if key=#27 then close;
  if key=#13 then
  begin
    arr[0] := 'estoque';
    arr[1] := 'financas';
    arr[2] := 'posicao';
    arr[3] := 'relatorio';
    arr[4] := 'cadastros';
    arr[5] := 'utilitarios';
    arr[6] := 'servicos';
    if not funcoes.Contido('*',ListBox1.Items.Strings[ListBox1.itemIndex]) then
     begin
      ListBox1.Items.Strings[ListBox1.itemIndex] := '* '+ListBox1.Items.Strings[ListBox1.itemIndex];
      acc:='';
      for i:=0 to ListBox1.Items.Count-1 do
       begin
        if funcoes.Contido('*',ListBox1.Items.Strings[i]) then acc := acc+IntToStr(i);
       end;
      dm.IBQuery2.Close;
      dm.IBQuery2.SQL.Clear;
      dm.IBQuery2.SQL.Add('update usuario set acesso='+QuotedStr(funcoes.Criptografar(acc))+' where cod='+codusu);
      dm.IBQuery2.ExecSQL;
      dm.IBQuery2.Transaction.Commit;
     end;
 {   else
     begin
      ListBox1.Items.Strings[ListBox1.itemIndex] := copy(ListBox1.Items.Strings[ListBox1.itemIndex],3,length(ListBox1.Items.Strings[ListBox1.itemIndex]));
      acc:='';
      for i:=0 to ListBox1.Items.Count-1 do
       begin
        if funcoes.Contido('*',ListBox1.Items.Strings[i]) then acc := acc+IntToStr(i);
       end;
      //form22.Pgerais.Values['acesso'] := acc;
     // ShowMessage('2  '+acc);
      dm.IBQuery2.Close;
      dm.IBQuery2.SQL.Clear;
      dm.IBQuery2.SQL.Add('update usuario set acesso='+QuotedStr(acc)+' where cod='+codusu);
      dm.IBQuery2.ExecSQL;
      dm.IBQuery2.Transaction.Commit;
     end;
  }  //ShowMessage(ListBox1.Items.Strings[ListBox1.itemIndex]+'   ARRAY = '+arr[ListBox1.itemindex]);
    //0-estoque 1-financas 2-posicao 3-relatorio 4-cadastros 5-utilitarios 6-serviços
end;
  end;
end;

procedure TForm36.FormShow(Sender: TObject);
begin
if cont=1 then
begin
 ListBox1.ItemIndex :=0;
 ListBox1.SetFocus;
end;
if cont=2 then
begin
  self.WindowState := wsMaximized;
  self.Caption := 'Configurações de Usuário: '+codusu;
  ListBox1.Top := 20;
  ListBox1.Left := 10;
  ListBox1.Width := form36.Width - 30;
  ListBox1.Height := form36.Height - 60;

  maiorQue := TStringList.Create;
  maiorQue.Add('99');
  ListBox1.Selected[0] := true;
  temp := configu;
end;
end;

procedure TForm36.FormClose(Sender: TObject; var Action: TCloseAction);
var sim : string;
begin
if cont = 2 then
begin
if temp <> configu then
 begin
   sim := funcoes.dialogo('generico',0,'SN',20,false,'S',Application.Title,'Deseja Salvar as Configurações (S/N)?','S');
   if sim = 'S' then
    begin
     //ShowMessage(IntToStr(length(temp)) + #13 + temp + #13 + codusu);
     dm.IBQuery2.Close;
     dm.IBQuery2.SQL.Clear;
     dm.IBQuery2.SQL.Add('update usuario set configu= :conf where nome=:nome');
     dm.IBQuery2.ParamByName('conf').AsString := temp;
     dm.IBQuery2.ParamByName('nome').AsString := codusu;
     dm.IBQuery2.ExecSQL;
     dm.IBQuery2.Transaction.Commit;
    end;
 end;
end; 
end;

end.
