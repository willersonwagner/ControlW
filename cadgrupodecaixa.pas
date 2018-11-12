unit cadgrupodecaixa;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, JsEdit1, JsEditInteiro1, ExtCtrls, Buttons, JsBotao1,
  ToolWin, ComCtrls;

type
  TForm11 = class(TForm)
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
    procedure FormShow(Sender: TObject);
    procedure codEnter(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure codKeyPress(Sender: TObject; var Key: Char);
    procedure codKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form11: TForm11;
  ultcod : integer;

implementation

uses Unit1, localizar, func;

{$R *.dfm}

procedure TForm11.JsBotao1Click(Sender: TObject);
begin
   if trim(grupo.Text) = '' then begin
     ShowMessage('Nome Obrigatório');
     grupo.SetFocus;
     exit;
   end;

   JsEdit.GravaNoBD(self);
end;

procedure TForm11.JsBotao2Click(Sender: TObject);
begin
   JsEdit.ExcluiDoBD(self.Name);
end;

procedure TForm11.FormShow(Sender: TObject);
begin
   JsEdit.SetTabelaDoBd(self,'grupodecaixa',dm.IBQuery1);
end;

procedure TForm11.codEnter(Sender: TObject);
begin

ultCod := JsEdit.UltimoCodigoDaTabela(self.Name);
  info.Caption := ' F5 - Consulta    Ultimo Código: ' + inttostr(ultCod);

end;

procedure TForm11.FormClose(Sender: TObject; var Action: TCloseAction);
begin
   JsEdit.LiberaMemoria(self);
end;

procedure TForm11.codKeyPress(Sender: TObject; var Key: Char);
begin
   if key=#27 then close;
end;

procedure TForm11.codKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
if (Key = 116) then
   begin
     tedit(sender).Text := funcoes.localizar('Localizar Grupo de Caixa','grupodecaixa','cod,grupo','cod','','grupo','grupo',true,false,false,'',300,NIL);
   end;
end;

end.
