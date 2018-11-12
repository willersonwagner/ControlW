unit cadFormaPagto;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, JsBotao1, ExtCtrls, JsEdit1, JsEditInteiro1, func;

type
  TcadFormas = class(TForm)
    cod: JsEditInteiro;
    nome: JsEdit;
    Panel1: TPanel;
    JsBotao1: JsBotao;
    Label1: TLabel;
    Label2: TLabel;
    codgru: JsEdit;
    Label3: TLabel;
    Memo1: TMemo;
    Label4: TLabel;
    Label5: TLabel;
    procedure FormShow(Sender: TObject);
    procedure JsBotao1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure codKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  cadFormas: TcadFormas;

implementation

uses untDtmMain, ACBrECF;

{$R *.dfm}

procedure TcadFormas.FormShow(Sender: TObject);
var
  ini, fim : integer;
begin
  jsedit.SetTabelaDoBd(self, 'formpagto', dtmMain.IBQuery3);
  Memo1.Clear;

  Memo1.Lines.Add('01 - Dinheiro');
  Memo1.Lines.Add('02 - Cheque');
  Memo1.Lines.Add('03 - Cartão de Crédito');
  Memo1.Lines.Add('04 - Cartão de Débito');
  Memo1.Lines.Add('05 - Crédito Loja');
  Memo1.Lines.Add('10 - Vale Alimentação');
  Memo1.Lines.Add('11 - Vale Refeição');
  Memo1.Lines.Add('12 - Vale Presente');
  Memo1.Lines.Add('13 - Vale Combustível');
  Memo1.Lines.Add('99 - Outro');

  Label5.Caption := 'Preencha o Código da Forma de Pagamento' + #13 +
                    'em cada Forma que vc deseje Usar neste sistema!' + #13 +
                    'Cuidado ao preencher os indices incorretamente.'
end;

procedure TcadFormas.JsBotao1Click(Sender: TObject);
begin
  JsEdit.GravaNoBD(self);
end;

procedure TcadFormas.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  jsedit.LiberaMemoria(self);
end;

procedure TcadFormas.codKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key = 116 then
    begin
      tedit(sender).Text := localizar1('Localizar Form Pagto','formpagto','cod, nome','cod','','nome','nome',false,false,false, '', '',600 ,sender);
    end;
end;


end.
