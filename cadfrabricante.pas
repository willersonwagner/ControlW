unit cadfrabricante;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, JsEditTexto1, JsEdit1, JsEditInteiro1,
  ToolWin, ComCtrls, ExtCtrls, JsBotao1;

type
  TForm6 = class(TForm)
    painel: TPanel;
    ToolBar1: TPanel;
    Label2: TLabel;
    Label1: TLabel;
    cod: JsEditInteiro;
    JsBotao1: JsBotao;
    JsBotao2: JsBotao;
    info: TLabel;
    nome: JsEdit;
    procedure codKeyPress(Sender: TObject; var Key: Char);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure codKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure JsBotao1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure JsBotao2Click(Sender: TObject);
    procedure codEnter(Sender: TObject);
    procedure nomeEnter(Sender: TObject);
  private
    { Private declarations }
  public
    valor_a_retornar : string;
    { Public declarations }
  end;

var
  Form6: TForm6;
  ultcod : integer;

implementation

uses Unit1, localizar, func;

{$R *.dfm}

procedure TForm6.codKeyPress(Sender: TObject; var Key: Char);
begin
 if key = #27 then self.Close;
end;

procedure TForm6.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  JsEdit.LiberaMemoria(self);
end;


procedure TForm6.codKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
if (Key = 116) then
 begin
  tedit(sender).Text := funcoes.localizar('Localizar Fabricante','fabricante','cod,nome','cod','','nome','nome',true,false,false,'',300,sender);
 end;
end;

procedure TForm6.JsBotao1Click(Sender: TObject);
begin
  if trim(nome.Text) = '' then begin
    ShowMessage('Campo NOME é obrigatório!');
    nome.SetFocus;
    exit;
  end;

  valor_a_retornar := JsEdit.GravaNoBD(self);
end;

procedure TForm6.FormShow(Sender: TObject);
begin
JsEdit.SetTabelaDoBd(self,'fabricante', dm.IBQuery1);
end;

procedure TForm6.JsBotao2Click(Sender: TObject);
begin
  JsEdit.ExcluiDoBD(self.Name);
end;

procedure TForm6.codEnter(Sender: TObject);
begin

ultCod := JsEdit.UltimoCodigoDaTabela(self.Name);
  info.Caption := ' F5 - Consulta    Ultimo Código: ' + inttostr(ultCod);

end;

procedure TForm6.nomeEnter(Sender: TObject);
begin
  if ((cod.Text <> '') or (cod.Text <> '0')) then
    begin
      valor_a_retornar := cod.Text;
    end;
end;

end.

