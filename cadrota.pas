unit cadrota;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, JsBotao1, ToolWin, ComCtrls, JsEdit1,
  JsEditInteiro1, ExtCtrls;

type
  TForm13 = class(TForm)
    painel: TPanel;
    Label2: TLabel;
    Label1: TLabel;
    cod: JsEditInteiro;
    nome: JsEdit;
    ToolBar1: TPanel;
    JsBotao1: JsBotao;
    JsBotao2: JsBotao;
    info: TLabel;
    Label3: TLabel;
    ulticod: TLabel;
    procedure JsBotao1Click(Sender: TObject);
    procedure JsBotao2Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure codEnter(Sender: TObject);
    procedure codKeyPress(Sender: TObject; var Key: Char);
    procedure codKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form13: TForm13;
  ultcod: integer;

implementation

uses Unit1, localizar, func;

{$R *.dfm}

procedure TForm13.JsBotao1Click(Sender: TObject);
begin
   if trim(nome.Text) = '' then begin
    ShowMessage('Campo NOME é obrigatório!');
    nome.SetFocus;
    exit;
  end;

   JsEdit.GravaNoBD(self);
end;

procedure TForm13.JsBotao2Click(Sender: TObject);
begin
   JsEdit.ExcluiDoBD(self.Name);
end;

procedure TForm13.FormShow(Sender: TObject);
begin
   JsEdit.SetTabelaDoBd(self,'rota',dm.IBQuery1);
end;

procedure TForm13.FormClose(Sender: TObject; var Action: TCloseAction);
begin
   JsEdit.LiberaMemoria(self);
end;

procedure TForm13.codEnter(Sender: TObject);
begin
  ulticod.Caption := IntToStr(JsEdit.UltimoCodigoDaTabela(self.Name));
  info.Caption := ' F5 - Consulta';

end;

procedure TForm13.codKeyPress(Sender: TObject; var Key: Char);
begin
  if key=#27 then close;

end;

procedure TForm13.codKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
if (Key = 116) then
   begin
    tedit(sender).Text := funcoes.localizar('Localizar Rotas de Distribuição','rota','cod,nome','cod','','nome','nome',true,false,false,'',300,NIL);
   end;
end;

end.
