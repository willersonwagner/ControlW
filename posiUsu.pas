unit posiUsu;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, DBGrids, StrUtils;

type
  TForm41 = class(TForm)
    DBGrid1: TDBGrid;
    procedure FormShow(Sender: TObject);
    procedure DBGrid1KeyPress(Sender: TObject; var Key: Char);
    procedure DBGrid1KeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form41: TForm41;

implementation

uses Unit1, func, principal, relatorio;

{$R *.dfm}

procedure TForm41.DBGrid1KeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key = 113 then begin
    if form22.usuario <> 'ADMIN' then exit;

    dm.IBQuery4.Close;
    dm.IBQuery4.SQL.Text := 'select cod, nome, usu,senha from usuario';
    dm.IBQuery4.Open;

    form19.RichEdit1.Lines.Clear;

    while not dm.IBQuery4.Eof do begin
      addRelatorioForm19(CompletaOuRepete(dm.IBQuery4.FieldByName('cod').AsString, '', ' ', 3) + ' ' +
      CompletaOuRepete(leftstr(dm.IBQuery4.FieldByName('nome').AsString, 20), '', ' ', 20)  + ' "' +
      CompletaOuRepete(funcoes.DesCriptografar(dm.IBQuery4.FieldByName('usu').AsString), '', ' ', 13) + '"  "' +
      CompletaOuRepete(funcoes.DesCriptografar(dm.IBQuery4.FieldByName('senha').AsString), '', ' ', 13) + '" '+ CRLF);

      dm.IBQuery4.Next;
    end;

    dm.IBQuery4.Close;
    form19.ShowModal;
  end;
end;

procedure TForm41.FormShow(Sender: TObject);
begin
 dm.IBselect.Close;
 dm.IBselect.SQL.Clear;
 dm.IBselect.SQL.Add('select cod,nome, case when (senha<>'') or (senha='')  then '+QuotedStr('********')+' end as usuario, case when (senha<>'') or (senha='')  then '+QuotedStr('********')+' end as senha,char_length(acesso) as nivel from usuario');
 dm.IBselect.Open;
 DBGrid1.DataSource := dm.ds1;
end;

procedure TForm41.DBGrid1KeyPress(Sender: TObject; var Key: Char);
begin
 if (key=#13) or (key=#27) then close;
end;

end.
