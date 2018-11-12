unit cadhiscaixa;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, JsBotao1, ToolWin, ComCtrls, JsEdit1,
  JsEditInteiro1, ExtCtrls, sBitBtn;

type
  TForm12 = class(TForm)
    painel: TPanel;
    Label2: TLabel;
    Label1: TLabel;
    cod: JsEditInteiro;
    grupo: JsEdit;
    ToolBar1: TPanel;
    JsBotao1: JsBotao;
    JsBotao2: JsBotao;
    info: TLabel;
    procedure JsBotao1Click(Sender: TObject);
    procedure JsBotao2Click(Sender: TObject);
    procedure codEnter(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure codKeyPress(Sender: TObject; var Key: Char);
    procedure codKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form12: TForm12;
  ultcod : integer;
implementation

uses Unit1, localizar, func;

{$R *.dfm}

procedure TForm12.JsBotao1Click(Sender: TObject);
begin
  if trim(grupo.Text) = '' then begin
     ShowMessage('Nome Obrigatório');
     GRUPO.SetFocus;
     exit;
   end;
  JsEdit.GravaNoBD(self);
end;

procedure TForm12.JsBotao2Click(Sender: TObject);
begin
  JsEdit.ExcluiDoBD(self.Name);
end;

procedure TForm12.codEnter(Sender: TObject);
begin

ultCod := JsEdit.UltimoCodigoDaTabela(self.Name);
  info.Caption := ' F5 - Consulta    Ultimo Código: ' + inttostr(ultCod);

end;

procedure TForm12.FormShow(Sender: TObject);
begin
  JsEdit.SetTabelaDoBd(self,'hiscaixa',dm.IBQuery1);
end;

procedure TForm12.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  JsEdit.LiberaMemoria(self);
end;

procedure TForm12.codKeyPress(Sender: TObject; var Key: Char);
begin
  if key = #27 then close;
end;

procedure TForm12.codKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
if (Key = 116) then
   begin
  tedit(sender).Text := funcoes.localizar('Localizar Histórico de Caixa','hiscaixa','cod,grupo','cod','','grupo','grupo',true,false,false,'',300,NIL);
   end;
end;

end.
