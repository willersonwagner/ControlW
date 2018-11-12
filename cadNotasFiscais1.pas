unit cadnotasfiscais1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, JsEditTexto1, JsEdit1, JsEditInteiro1,
  ToolWin, ComCtrls, ExtCtrls, JsBotao1, Vcl.Mask, JsEditData1;

type
  TCadNotasFiscais = class(TForm)
    painel: TPanel;
    ToolBar1: TPanel;
    Label1: TLabel;
    cod: JsEditInteiro;
    JsBotao1: JsBotao;
    JsBotao2: JsBotao;
    info: TLabel;
    JsEditInteiro1: JsEditInteiro;
    Label2: TLabel;
    JsEditInteiro2: JsEditInteiro;
    Label3: TLabel;
    JsEditData1: JsEditData;
    Label4: TLabel;
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
  CadNotasFiscais: TCadNotasFiscais;
  ultcod : integer;

implementation

uses Unit1, localizar, func;

{$R *.dfm}

procedure TCadNotasFiscais.codKeyPress(Sender: TObject; var Key: Char);
begin
 if key = #27 then self.Close;
end;

procedure TCadNotasFiscais.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  JsEdit.LiberaMemoria(self);
end;


procedure TCadNotasFiscais.codKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
if (Key = 116) then
 begin
   tedit(sender).Text := funcoes.localizar('Localizar Notas Fiscais','SPED_MOVFISCAIS','cod,nota, data,pedido, ','cod','','pedido','nome',true,false,false,'',300,sender);
 end;
end;

procedure TCadNotasFiscais.JsBotao1Click(Sender: TObject);
begin
  valor_a_retornar := JsEdit.GravaNoBD(self);
end;

procedure TCadNotasFiscais.FormShow(Sender: TObject);
begin
JsEdit.SetTabelaDoBd(self,'SPED_MOVFISCAIS', dm.IBQuery1);
end;

procedure TCadNotasFiscais.JsBotao2Click(Sender: TObject);
begin
  JsEdit.ExcluiDoBD(self.Name);
end;

procedure TCadNotasFiscais.codEnter(Sender: TObject);
begin

ultCod := JsEdit.UltimoCodigoDaTabela(self.Name);
  info.Caption := ' F5 - Consulta    Ultimo Código: ' + inttostr(ultCod);

end;

procedure TCadNotasFiscais.nomeEnter(Sender: TObject);
begin
  if ((cod.Text <> '') or (cod.Text <> '0')) then
    begin
      valor_a_retornar := cod.Text;
    end;
end;

end.
