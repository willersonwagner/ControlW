unit consultaProduto;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, JsEditNumero1, StdCtrls, JsEdit1, JsEditInteiro1, jpeg, ExtCtrls;

type
  TForm10 = class(TForm)
    Image1: TImage;
    codbar: JsEdit;
    nome: JsEditInteiro;
    quant: JsEditNumero;
    Panel1: TPanel;
    procedure codbarKeyPress(Sender: TObject; var Key: Char);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
  private
    procedure pesquisaProduto();
    procedure alinhaComponentes();
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form10: TForm10;

implementation

uses untDtmMain;

{$R *.dfm}
procedure TForm10.alinhaComponentes();
begin
  if screen.Width <= 800 then
    begin
      self.Width := 800;
      nome.Width := 770;
      nome.Font.Size := 24;
    end;
end;

procedure TForm10.pesquisaProduto();
var
  cbar : String;
begin
  cbar := codbar.Text;

  dtmMain.IBQuery1.Close;
  dtmMain.IBQuery1.SQL.Text := ('select p.cod, p.nome, p.p_venda from produto p left join codbarras c on (c.cod = p.cod)'+
  '  where  (p.codbar like '+QuotedStr( cbar )+') or (c.codbar = '+QuotedStr( cbar )+')');
  dtmMain.IBQuery1.Open;

  if dtmMain.IBQuery1.IsEmpty then
    begin
      dtmMain.IBQuery1.Close;
      nome.Text  := 'Produto Não Encontrado';
      quant.Text := '0,00';
      exit;
    end;

  nome.Text  := dtmMain.IBQuery1.fieldbyname('nome').AsString;
  quant.Text := FormatCurr('#,###,###0.00', dtmMain.IBQuery1.fieldbyname('p_venda').AsCurrency);
  codbar.SelectAll;
  dtmMain.IBQuery1.Close;
end;

procedure TForm10.codbarKeyPress(Sender: TObject; var Key: Char);
begin
  if key = #27 then close;
  if key = #13 then
    begin
      pesquisaProduto;
    end;
end;

procedure TForm10.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  jsedit.LiberaMemoria(self);
end;

procedure TForm10.FormShow(Sender: TObject);
begin
  alinhaComponentes();
end;

end.
