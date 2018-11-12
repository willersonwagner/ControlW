unit cadecf1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, JsEdit1, JsEditInteiro1, Buttons, JsBotao1, ExtCtrls;

type
  TcadECF = class(TForm)
    cod: JsEditInteiro;
    Label1: TLabel;
    Label2: TLabel;
    MODELO: JsEdit;
    SERIAL: JsEdit;
    Label3: TLabel;
    Panel1: TPanel;
    JsBotao1: JsBotao;
    procedure FormShow(Sender: TObject);
    procedure JsBotao1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  cadECF: TcadECF;

implementation

uses untDtmMain, StrUtils;

{$R *.dfm}

procedure TcadECF.FormShow(Sender: TObject);
begin
  jsedit.SetTabelaDoBd(self, 'ECF', dtmMain.IBQuery3);

//  if not dtmmain.ACBrECF1.Device.Ativo then dtmmain.ACBrECF1.Ativar;
//  cod.Text := dtmMain.ACBrECF1.NumECF;
//  MODELO.Text := LeftStr(dtmMain.ACBrECF1.ModeloStr, 30);
//  SERIAL.Text := LeftStr(dtmMain.ACBrECF1.NumSerie, 30);
end;

procedure TcadECF.JsBotao1Click(Sender: TObject);
begin
  JsEdit.GravaNoBD(self);
end;

procedure TcadECF.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  jsedit.LiberaMemoria(self);
end;

end.
