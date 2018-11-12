unit cadCli;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, JsBotao1, ExtCtrls, Mask, JsEditCPF1, JsEdit1,
  JsEditInteiro1, untnfceForm;

type
  TcadCliNFCe = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label7: TLabel;
    cod: JsEditInteiro;
    nome: JsEdit;
    cnpj: JsEditCPF;
    ende: JsEdit;
    ToolBar1: TPanel;
    button: JsBotao;
    Label4: TLabel;
    bairro: JsEdit;
    tipo: JsEditInteiro;
    procedure bairroKeyPress(Sender: TObject; var Key: Char);
    procedure buttonKeyPress(Sender: TObject; var Key: Char);
    procedure codKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure buttonClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure numeroKeyPress(Sender: TObject; var Key: Char);
    procedure cnpjKeyPress(Sender: TObject; var Key: Char);
    procedure nomeEnter(Sender: TObject);
    procedure codKeyPress(Sender: TObject; var Key: Char);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    procedure limpa();
    function insereCliente : String;
    procedure buscaCliente(cpf1 : String);
    { Private declarations }
  public
    codCliente : String;
    { Public declarations }
  end;

var
  cadCliNFCe: TcadCliNFCe;

implementation

uses unit1, func;

{$R *.dfm}

procedure TcadCliNFCe.limpa();
begin
  codCliente  := '0';
  nome.Text   := '';
  cod.Text    := '';
  cnpj.Text   := '';
  bairro.Text := '';
  tipo.Text   := '';
  ende.Text   := '';
  cod.Enabled := true;
end;

procedure TcadCliNFCe.bairroKeyPress(Sender: TObject; var Key: Char);
begin
  if key = #27 then
    begin
      key := #0;
      limpa;
    end;

  if key = #13 then
    begin
      button.SetFocus;
    end;
end;

procedure TcadCliNFCe.buttonKeyPress(Sender: TObject; var Key: Char);
begin
  key := #0;
end;

function TcadCliNFCe.insereCliente : String;
begin
  //dtmmain.IBQuery1.Close;
  //dtmMain.IBQuery1.SQL.Text := 'insert into';
end;

procedure TcadCliNFCe.codKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = 116) then
    begin

      tedit(sender).Text := funcoes.localizar1('Localizar Cliente','cliente','cod,nome,telres,telcom,cnpj as cpfcnpj,bairro','cod','','nome','nome',false,false,false,'','',450, nil);
      key := 0;
    end;
end;

procedure TcadCliNFCe.buttonClick(Sender: TObject);
begin
  if funcoes.testacpf(StrNum(cnpj.Text)) = false then begin
    MessageDlg('CPF Inválido!', mtError, [mbOK], 1);
    self.limpa;
    cod.SetFocus;
    exit;
  end;

  tipo.Text := '1';
  codCliente := jsedit.GravaNoBD(self);
  close;
end;

procedure TcadCliNFCe.FormShow(Sender: TObject);
begin
  jsedit.SetTabelaDoBd(self, 'cliente', query1);
end;

procedure TcadCliNFCe.numeroKeyPress(Sender: TObject; var Key: Char);
begin
  if key = #13 then button.SetFocus;
end;

procedure TcadCliNFCe.cnpjKeyPress(Sender: TObject; var Key: Char);
begin
  if key = #13 then
    begin
      if not testacpf(cnpj.Text) then
        begin
          MessageDlg('CPF Inválido!', mtError, [mbOK], 1);
          key := #0;
          abort;
          exit;
        end;

      buscaCliente(cnpj.Text);
      ende.SetFocus;
    end;
end;

procedure TcadCliNFCe.nomeEnter(Sender: TObject);
begin
  codCliente := cod.Text;
end;

procedure TcadCliNFCe.codKeyPress(Sender: TObject; var Key: Char);
begin
  if key = #27 then close;
end;

procedure TcadCliNFCe.FormCreate(Sender: TObject);
begin
  codCliente := '0';
end;

procedure TcadCliNFCe.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  jsedit.LiberaMemoria(self);
end;

procedure TcadCliNFCe.buscaCliente(cpf1 : String);
begin
  Query1.Close;
  Query1.SQL.Text := 'select cod, nome, ende, bairro from cliente where cnpj = :cnpj';
  Query1.ParamByName('cnpj').AsString := cpf1;
  Query1.Open;

  if Query1.IsEmpty then
    begin
      Query1.Close;
      exit;
    end;

  cod.Text    := Query1.fieldbyname('cod').AsString;
  NOME.Text   := Query1.fieldbyname('nome').AsString;
  ende.Text   := Query1.fieldbyname('ende').AsString;
  bairro.Text := Query1.fieldbyname('bairro').AsString;
  Query1.Close;
end;

end.
