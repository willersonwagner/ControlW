unit formas;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ibquery;

type
  TForm5 = class(TForm)
    ListBox1: TListBox;
    Label1: TLabel;
    procedure ListBox1KeyPress(Sender: TObject; var Key: Char);
    procedure ListBox1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    valor : String;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form5: TForm5;
  function lerFormasDePagamento(var query : TIBQuery; const cap : String;const ApareceCaption : boolean; var listaPAGTOIMPRESORA : TStringList; const indice : string) : String;

implementation

{$R *.dfm}

function lerFormasDePagamento(var query : TIBQuery; const cap : String;const ApareceCaption : boolean; var listaPAGTOIMPRESORA : TStringList; const indice : string) : String;
begin
  if not Assigned(form5) then
    begin
      form5 := TForm5.Create(Application);
      query.Close;
      query.SQL.Text := 'select cod, nome, codhis from formpagto where codgru <> '''' order by cod';
      query.Open;

      listaPAGTOIMPRESORA := TStringList.Create;

      form5.ListBox1.Clear;
      while not query.Eof do
        begin
          form5.ListBox1.Items.Add(query.fieldbyname('cod').AsString + ' - ' + query.fieldbyname('nome').AsString);
          listaPAGTOIMPRESORA.Values[query.fieldbyname('cod').AsString] := query.fieldbyname('codhis').AsString;
          query.Next;
        end;

      query.Close;
    end
  else
    begin
      if not assigned(listaPAGTOIMPRESORA) then
        begin
          listaPAGTOIMPRESORA := TStringList.Create;
          query.Close;
          query.SQL.Text := 'select cod, codhis from formpagto where codhis <> '''' order by cod';
          query.Open;

          while not query.Eof do
            begin
              listaPAGTOIMPRESORA.Values[query.fieldbyname('cod').AsString] := query.fieldbyname('codhis').AsString;
              query.Next;
            end;
        end;
    end;

  if form5.ListBox1.Count = 0 then
    begin
      form5.ListBox1.Items.Add('1 - Dinheiro');
      listaPAGTOIMPRESORA.Values['1'] := indice;
    end;
    
  form5.ListBox1.ItemIndex := 0;
  form5.ShowModal;
  Result := form5.valor;
  //Result := Form5.ListBox1.Items.Strings[form5.ListBox1.itemindex];
end;

procedure TForm5.ListBox1KeyPress(Sender: TObject; var Key: Char);
begin
  if key = #13 then
    begin
      valor := ListBox1.Items.Strings[ListBox1.itemindex];
      close;
    end;
end;

procedure TForm5.ListBox1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key = 119 then
    begin
      valor := '*';
      close;
    end;
end;

end.
