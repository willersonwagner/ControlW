unit cadconvenio;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, JsBotao1, ToolWin, ComCtrls, JsEdit1,
  JsEditInteiro1, ExtCtrls, JsEditNumero1;

type
  TForm10 = class(TForm)
    painel: TPanel;
    Label2: TLabel;
    Label1: TLabel;
    cod: JsEditInteiro;
    grupo: JsEdit;
    ToolBar1: TPanel;
    JsBotao1: JsBotao;
    JsBotao2: JsBotao;
    info: TLabel;
    Label3: TLabel;
    porcentagem: JsEditNumero;
    procedure JsBotao1Click(Sender: TObject);
    procedure JsBotao2Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure codKeyPress(Sender: TObject; var Key: Char);
    procedure codEnter(Sender: TObject);
    procedure codKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form10: TForm10;
  ultcod : integer;
implementation

uses Unit1, localizar, func;

{$R *.dfm}

procedure TForm10.JsBotao1Click(Sender: TObject);
begin
 JsEdit.GravaNoBD(self);
end;

procedure TForm10.JsBotao2Click(Sender: TObject);
begin
   JsEdit.ExcluiDoBD(self.Name);
end;

procedure TForm10.FormShow(Sender: TObject);
begin
   JsEdit.SetTabelaDoBd(self,'convenio',dm.IBQuery1);
end;

procedure TForm10.FormClose(Sender: TObject; var Action: TCloseAction);
begin
   JsEdit.LiberaMemoria(self);
end;

procedure TForm10.codKeyPress(Sender: TObject; var Key: Char);
begin
 if key = #27 then Close;
end;

procedure TForm10.codEnter(Sender: TObject);
begin

ultCod := JsEdit.UltimoCodigoDaTabela(self.Name);
  info.Caption := ' F5 - Consulta    Ultimo Código: ' + inttostr(ultCod);

end;

procedure TForm10.codKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
if (Key = 116) then
   begin
    tedit(sender).Text := funcoes.localizar('Localizar Convênios','convenio','cod,grupo','cod','','grupo','grupo',true,false,false,'',300,sender);
   end;

end;

end.
