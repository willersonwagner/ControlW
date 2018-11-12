unit cadvendedor;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, JsBotao1, ToolWin, ComCtrls, JsEdit1,
  JsEditInteiro1, ExtCtrls;

type
  TForm4 = class(TForm)
    painel: TPanel;
    Label2: TLabel;
    Label1: TLabel;
    cod: JsEditInteiro;
    nome: JsEdit;
    ToolBar1: TPanel;
    JsBotao1: JsBotao;
    JsBotao2: JsBotao;
    info: TLabel;
    procedure JsBotao1Click(Sender: TObject);
    procedure JsBotao2Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure codEnter(Sender: TObject);
    procedure codKeyPress(Sender: TObject; var Key: Char);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure codKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form4: TForm4;
  ultcod: integer;

implementation

uses Unit1, localizar, func;

{$R *.dfm}

procedure TForm4.JsBotao1Click(Sender: TObject);
begin
  if trim(nome.Text) = '' then begin
     ShowMessage('Nome Obrigatório');
     nome.SetFocus;
     exit;
   end;
  JsEdit.GravaNoBD(self);
end;

procedure TForm4.JsBotao2Click(Sender: TObject);
begin
   JsEdit.ExcluiDoBD(self.Name);
end;

procedure TForm4.FormShow(Sender: TObject);
begin
JsEdit.SetTabelaDoBd(self,'vendedor', dm.IBQuery1);
end;

procedure TForm4.codEnter(Sender: TObject);
begin

ultCod := JsEdit.UltimoCodigoDaTabela(self.Name);
  info.Caption := ' F5 - Consulta    Ultimo Código: ' + inttostr(ultCod);

end;

procedure TForm4.codKeyPress(Sender: TObject; var Key: Char);
begin
  if key=#27 then close;
end;

procedure TForm4.FormClose(Sender: TObject; var Action: TCloseAction);
begin
   JsEdit.LiberaMemoria(self);
end;

procedure TForm4.codKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
if (Key = 116) then
 begin
   tedit(sender).Text := funcoes.localizar('Localizar Vendedor','vendedor','cod,nome','cod','','nome','nome',true,false,false,'',300,sender);
 end;

end;

end.
