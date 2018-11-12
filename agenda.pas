unit agenda;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, JsBotao1, ToolWin, ComCtrls, JsEdit1,
  JsEditInteiro1, ExtCtrls;

type
  TForm14 = class(TForm)
    painel: TPanel;
    Label2: TLabel;
    Label1: TLabel;
    cod: JsEditInteiro;
    nome: JsEdit;
    ToolBar1: TPanel;
    JsBotao1: JsBotao;
    JsBotao2: JsBotao;
    info: TLabel;
    endereco: JsEdit;
    Label3: TLabel;
    Label4: TLabel;
    cep: JsEdit;
    cidade: JsEdit;
    Label5: TLabel;
    estado: JsEdit;
    Label6: TLabel;
    fone: JsEdit;
    Label7: TLabel;
    fax: JsEdit;
    Label8: TLabel;
    contato: JsEdit;
    tlabel: TLabel;
    obs: JsEdit;
    Label9: TLabel;
    procedure JsBotao1Click(Sender: TObject);
    procedure JsBotao2Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure codKeyPress(Sender: TObject; var Key: Char);
    procedure codEnter(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure codKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form14: TForm14;
  ultcod : integer;

implementation

uses Unit1, localizar, func;

{$R *.dfm}

procedure TForm14.JsBotao1Click(Sender: TObject);
begin
  if trim(nome.Text) = '' then begin
    ShowMessage('Campo NOME é obrigatório!');
    nome.SetFocus;
    exit;
  end;

   JsEdit.GravaNoBD(self);
end;

procedure TForm14.JsBotao2Click(Sender: TObject);
begin
   JsEdit.ExcluiDoBD(self.Name);
end;

procedure TForm14.FormClose(Sender: TObject; var Action: TCloseAction);
begin
      JsEdit.LiberaMemoria(self);
end;

procedure TForm14.codKeyPress(Sender: TObject; var Key: Char);
begin
  if key=#27 then close;
end;

procedure TForm14.codEnter(Sender: TObject);
begin

  ultCod := JsEdit.UltimoCodigoDaTabela(self.Name);
  info.Caption := ' F5 - Consulta    Ultimo Código: ' + inttostr(ultCod);

end;

procedure TForm14.FormShow(Sender: TObject);
begin
JsEdit.SetTabelaDoBd(self,'agenda', dm.IBQuery1);
end;

procedure TForm14.codKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
if (Key = 116) then
   begin
     tedit(sender).Text := funcoes.localizar('Localizar na Agenda','agenda','cod,nome','cod','','nome','nome',true,false,false,'',300,NIL);
   end;

end;

end.
