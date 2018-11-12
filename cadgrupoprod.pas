unit cadgrupoprod;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, JsBotao1, ToolWin, ComCtrls, JsEdit1,
  JsEditInteiro1, ExtCtrls;

type
  TForm3 = class(TForm)
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    cod: JsEditInteiro;
    nome: JsEdit;
    ToolBar1: TPanel;
    JsBotao1: JsBotao;
    JsBotao2: JsBotao;
    info: TLabel;
    procedure JsBotao1Click(Sender: TObject);
    procedure JsBotao2Click(Sender: TObject);
    procedure codKeyPress(Sender: TObject; var Key: Char);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure codEnter(Sender: TObject);
    procedure codKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure nomeEnter(Sender: TObject);
  private
    { Private declarations }
  public
    valor_a_retornar : string;
    { Public declarations }
  end;

var
  Form3: TForm3;
  ultcod : integer;
implementation

uses Unit1, localizar, func;

{$R *.dfm}

procedure TForm3.JsBotao1Click(Sender: TObject);
begin
  if trim(nome.Text) = '' then begin
    ShowMessage('Campo NOME é obrigatório!');
    nome.SetFocus;
    exit;
  end;

  valor_a_retornar := JsEdit.GravaNoBD(self);
end;

procedure TForm3.JsBotao2Click(Sender: TObject);
begin
  JsEdit.ExcluiDoBD(self.Name);
end;

procedure TForm3.codKeyPress(Sender: TObject; var Key: Char);
begin
 if key = #27 then close;
end;

procedure TForm3.FormShow(Sender: TObject);
begin
  JsEdit.SetTabelaDoBd(self,'grupoprod',dm.IBQuery1);
end;

procedure TForm3.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  JsEdit.LiberaMemoria(self);
end;

procedure TForm3.codEnter(Sender: TObject);
begin

ultCod := JsEdit.UltimoCodigoDaTabela(self.Name);
  info.Caption := ' F5 - Consulta    Ultimo Código: ' + inttostr(ultCod);

end;

procedure TForm3.codKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
if (Key = 116) then
 begin
  tedit(sender).Text := funcoes.localizar('Localizar Grupo de Produtos','grupoprod','cod,nome','cod','','nome','nome',true,false,false,'',300,sender);
 end;
end;
procedure TForm3.nomeEnter(Sender: TObject);
begin
  if ((cod.Text <> '') or (cod.Text <> '0')) then
    begin
      valor_a_retornar := cod.Text;
    end;
end;

end.
