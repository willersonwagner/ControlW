unit param1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, dbclient, db, ibquery;

type
  TForm40 = class(TForm)
    ListBox1: TListBox;
    procedure ListBox1KeyPress(Sender: TObject; var Key: Char);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ListBox1KeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    function buscaParametro : Integer;
    { Private declarations }
  public
    temp,perg,troca,teclas: Tstringlist;
    tipo: Tstringlist;
    { Public declarations }
  end;

var
  Form40: TForm40;

implementation

uses func, principal, Unit1;

{$R *.dfm}

procedure TForm40.ListBox1KeyPress(Sender: TObject; var Key: Char);
var tempo : string;
begin
 if key = #32 then begin
   buscaParametro;
 end;

 if key = #13 then
  begin
    if (ListBox1.ItemIndex = 35) then
      begin
        if temp[35] = '' then temp.Strings[35] := '|Equip.|Marca|Modelo|Série|Técnico|Defeito|';
      end;

    if (ListBox1.ItemIndex = 64) then
      begin
        if temp[64] = '' then temp.Strings[64] := '|VIDRO|BOX  |FORRO|';
      end;

    if ((ListBox1.ItemIndex = 24) or (ListBox1.ItemIndex = 39) or (ListBox1.ItemIndex = 41)) and (form22.usuario <> 'ADMIN') then // Usar saída de estoque
      begin
        ShowMessage('Esta Opção só pode ser modificada pelo usuário administrador');
        exit;
      end;
      
      begin
        if tipo.Values[IntToStr(ListBox1.ItemIndex)] = 'numero' then
          begin
            tempo :=  funcoes.dialogo(tipo.Values[IntToStr(ListBox1.ItemIndex)], 0, teclas.Values[IntToStr(ListBox1.ItemIndex)], 2, false, troca.Values[IntToStr(ListBox1.ItemIndex)], Application.Title, ListBox1.Items.Values[IntToStr(ListBox1.ItemIndex)], temp.Strings[ListBox1.ItemIndex]);
          end
        else  tempo :=  funcoes.dialogo(tipo.Values[IntToStr(ListBox1.ItemIndex)], 0, teclas.Values[IntToStr(ListBox1.ItemIndex)],  30, false,troca.Values[IntToStr(ListBox1.ItemIndex)], Application.Title, ListBox1.Items.Values[IntToStr(ListBox1.ItemIndex)], temp.Strings[ListBox1.ItemIndex]);
      end;
    if tempo <> '*' then temp.Strings[ListBox1.ItemIndex] := tempo;
  end;
 if key = #27 then close;
end;

procedure TForm40.FormShow(Sender: TObject);
var i : integer;
begin
temp := TStringList.Create;
for i := 0 to ConfParamGerais.Count-1 do
 begin
   temp.Add(ConfParamGerais.Strings[i]);
 end;
 for i := temp.Count to ListBox1.Items.Count - 1 do
   begin
     temp.Add('');
   end;
end;

procedure TForm40.FormClose(Sender: TObject; var Action: TCloseAction);
var i : integer;
sim : string;
begin
if temp.Text <> ConfParamGerais.Text then
 begin
  sim := funcoes.dialogo('generico',0,'SN',20,false,'S',Application.Title,'Deseja Salvar as Configurações(S/N)?','S');
  if sim = 'S' then
   begin
    for i := 0 to ListBox1.Count - 1 do
     begin
      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add('update or insert into pgerais(cod, valor) values(:cod, :valor ) matching(cod) ');
      dm.IBQuery1.ParamByName('cod').AsInteger := i;
      dm.IBQuery1.ParamByName('valor').AsString := temp.Strings[i];
      dm.IBQuery1.ExecSQL;
     end;
    dm.IBQuery1.Transaction.Commit;
    ConfParamGerais := temp;
    ConfParamGerais := nil;
    ConfParamGerais := TStringList.Create;
    for i := 0 to temp.Count - 1 do
      begin
        ConfParamGerais.Add(temp.Strings[i]);
      end;
    end;
   end;
end;

procedure TForm40.ListBox1KeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
if (key = 38) and (ListBox1.ItemIndex = 0) then ListBox1.Selected[ListBox1.Items.Count - 1] := true;
if (key = 40) and (ListBox1.ItemIndex = ListBox1.Items.Count - 1) then ListBox1.Selected[0] := true;
end;

function TForm40.buscaParametro : Integer;
var
  busca : String;
  idx   : integer;
  cds   : TClientDataSet;
begin
  busca := funcoes.dialogo('normal',3,'',60,true,'','ControlW','Selecionar Por:','');
  if busca = '*' then exit;

  idx := ListBox1.ItemIndex;
  //ListBox1.Selected[0] := true;

  cds := TClientDataSet.Create(self);

  cds.FieldDefs.Add('COD', ftInteger);
  cds.FieldDefs.Add('NOME', ftString, 70);
  cds.CreateDataSet;
  cds.IndexFieldNames := 'cod';

  for idx := 0 to ListBox1.Count -1 do begin
    if Contido(UpperCase(busca), UpperCase(ListBox1.Items[idx])) then begin
      cds.Append;
      cds.FieldByName('cod').AsInteger := idx;
      cds.FieldByName('nome').AsString := ListBox1.Items[idx];
      cds.Post;
    end;
  end;

  busca := funcoes.busca(tibquery(cds), '', 'cod', 'cod','');
  cds.Free;
  if (busca = '') or (busca = '*') then exit;

  ListBox1.Selected[StrToIntDef(busca, 0)] := true;
end;

end.

