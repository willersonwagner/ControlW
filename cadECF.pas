unit cadECF;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, JsEdit1, JsEditInteiro1, Buttons, JsBotao1, ExtCtrls;

type
  TcadECF1 = class(TForm)
    Label5: TLabel;
    Label2: TLabel;
    Label1: TLabel;
    cod: JsEditInteiro;
    modelo: JsEdit;
    serial: JsEdit;
    ToolBar1: TPanel;
    info: TLabel;
    JsBotao1: JsBotao;
    JsBotao2: JsBotao;
    procedure FormShow(Sender: TObject);
    procedure JsBotao1Click(Sender: TObject);
    procedure codKeyPress(Sender: TObject; var Key: Char);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  cadECF1: TcadECF1;

implementation

uses Unit1;

{$R *.dfm}

procedure TcadECF1.FormShow(Sender: TObject);
begin
  jsedit.SetTabelaDoBd(self, 'ECF', dm.ibquery1);
end;

procedure TcadECF1.JsBotao1Click(Sender: TObject);
begin
  JsEdit.GravaNoBD(self);
end;

procedure TcadECF1.codKeyPress(Sender: TObject; var Key: Char);
begin
  if key = #27 then Close;
end;

procedure TcadECF1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  JsEdit.LiberaMemoria(self);
end;

end.
