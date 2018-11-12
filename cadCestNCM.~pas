unit cadCestNCM;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, JsBotao1, ExtCtrls, JsEdit1, JsEditInteiro1;

type
  TForm61 = class(TForm)
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    NCM: JsEditInteiro;
    CEST: JsEditInteiro;
    ToolBar1: TPanel;
    info: TLabel;
    JsBotao1: JsBotao;
    JsBotao2: JsBotao;
    procedure FormShow(Sender: TObject);
    procedure JsBotao1Click(Sender: TObject);
    procedure JsBotao2Click(Sender: TObject);
    procedure NCMKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure NCMKeyPress(Sender: TObject; var Key: Char);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure CESTKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form61: TForm61;

implementation

uses Unit1, func;

{$R *.dfm}

procedure TForm61.FormShow(Sender: TObject);
begin
  jsedit.SetTabelaDoBd(self, 'NCM_CEST', dm.ibquery1, 'NCM');
end;

procedure TForm61.JsBotao1Click(Sender: TObject);
begin
  if NCM.Text = '' then
    begin
      ShowMessage('Preenchimento Obrigatório!');
      ncm.SetFocus;
      exit;
    end;

  if CEST.Text = '' then
    begin
      ShowMessage('Preenchimento Obrigatório!');
      CEST.SetFocus;
      exit;
    end;;

  jsedit.GravaNoBD(self, false);
end;

procedure TForm61.JsBotao2Click(Sender: TObject);
begin
  jsedit.ExcluiDoBD(self.Name, 'where ncm = '+ QuotedStr(ncm.Text));
end;

procedure TForm61.NCMKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = 116) then
    begin
      tedit(sender).Text := funcoes.localizar('Localizar NCM CEST','NCM_CEST','ncm, cest','ncm','','ncm','cest',false,false,false,'',300,sender);
    end;
end;

procedure TForm61.NCMKeyPress(Sender: TObject; var Key: Char);
begin
  if key = #27 then close;
  if key = #13 then
    begin
      if tedit(sender).Text = '' then
        begin
          ShowMessage('Preenchimento Obrigatório!');
          Abort;
        end
      else
        begin
          CEST.SetFocus;
          Abort;
        end;
    end;
end;

procedure TForm61.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  jsedit.LiberaMemoria(self);
end;

procedure TForm61.CESTKeyPress(Sender: TObject; var Key: Char);
begin
  if tedit(sender).Text = '' then
    begin
      tedit(sender).Text := funcoes.localizar('Localizar CEST','cest','cest, nome as descricao','cest','','nome','cest',true,false,false,'',300,sender);
    end;
end;

end.
