unit cadformpagto;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, JsBotao1, ToolWin, ComCtrls, JsEdit1,
  JsEditInteiro1, ExtCtrls, JsEditNumero1;

type
  TForm15 = class(TForm)
    painel: TPanel;
    Label2: TLabel;
    Label1: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    tlabel: TLabel;
    Label9: TLabel;
    cod: JsEditInteiro;
    nome: JsEdit;
    ToolBar1: TPanel;
    JsBotao1: JsBotao;
    JsBotao2: JsBotao;
    info: TLabel;
    dinheiro: JsEdit;
    desc_pag: JsEditNumero;
    desc_ant: JsEditNumero;
    codgru: JsEdit;
    codhis: JsEdit;
    reg_caixa: JsEdit;
    prazo: JsEditNumero;
    imp_fiscal: JsEdit;
    procedure JsBotao1Click(Sender: TObject);
    procedure JsBotao2Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure codKeyPress(Sender: TObject; var Key: Char);
    procedure codEnter(Sender: TObject);
    procedure codKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure codgruKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form15: TForm15;
  ultcod : integer;
implementation

uses Unit1, localizar, func, caixaLista, principal;

{$R *.dfm}

procedure TForm15.JsBotao1Click(Sender: TObject);
begin
  if trim(nome.Text) = '' then begin
     ShowMessage('Nome Obrigatório');
     nome.SetFocus;
     exit;
   end;

  if ((cod.Text = '1') or (cod.Text = '2')) and (form22.superUsu <> 1) then
    begin
      MessageDlg('Esta Forma de Pagamentos Não pode Ser Modificada', mtError, [mbOK], 1);
      exit;
    end;

  JsEdit.GravaNoBD(self);
end;

procedure TForm15.JsBotao2Click(Sender: TObject);
begin
   JsEdit.ExcluiDoBD(self.Name);
end;

procedure TForm15.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 JsEdit.LiberaMemoria(self);
end;

procedure TForm15.FormShow(Sender: TObject);
begin
   JsEdit.SetTabelaDoBd(self,'formpagto',dm.IBQuery1);
end;

procedure TForm15.codKeyPress(Sender: TObject; var Key: Char);
begin
if key = #27 then close;
end;

procedure TForm15.codEnter(Sender: TObject);
begin
ultCod := JsEdit.UltimoCodigoDaTabela(self.Name);
  info.Caption := ' F5 - Consulta    Ultimo Código: ' + inttostr(ultCod);

end;

procedure TForm15.codKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
if (Key = 116) then
   begin
     tedit(sender).Text := funcoes.localizar('Localizar Forma de Pagamento','formpagto','cod,nome','cod','','nome','nome',true,false,false,'',300,NIL);
   end;

end;

procedure TForm15.codgruKeyPress(Sender: TObject; var Key: Char);
begin
if (key=#13) and ((tedit(sender).Text='0') or (tedit(sender).Text='')) then
 begin
   form39 := tform39.Create(self);
   form39.ListBox1.Items.Add('01 - Dinheiro');
   form39.ListBox1.Items.Add('02 - Cheque');
   form39.ListBox1.Items.Add('03 - Cartão de Crédito');
   form39.ListBox1.Items.Add('04 - Cartão de Débito');
   form39.ListBox1.Items.Add('05 - Crédito Loja');
   form39.ListBox1.Items.Add('10 - Vale Alimentação');
   form39.ListBox1.Items.Add('11 - Vale Refeição');
   form39.ListBox1.Items.Add('12 - Vale Presente');
   form39.ListBox1.Items.Add('13 - Vale Combustível');
   form39.ListBox1.Items.Add('99 - Outro');
   tedit(sender).Text := funcoes.lista(Sender, false);
   if tedit(sender).Text = '*' then
     begin
       tedit(sender).Text := '0';
       key := #0;
     end;
  //tedit(sender).Text := funcoes.localizar('Tipo de Cliente','tipocli','cod,nome','cod','cod','nome','cod',false,false,false,'',300,sender);
 end;
end;

end.
