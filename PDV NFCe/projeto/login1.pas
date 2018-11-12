unit login1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, jpeg, ExtCtrls, Buttons, JsBotao1, jsedit1;

type
  TForm53 = class(TForm)
    Label1: TLabel;
    nome: TEdit;
    Label2: TLabel;
    senha: TEdit;
    Image1: TImage;
    JsBotao1: JsBotao;
    procedure FormShow(Sender: TObject);
    procedure nomeKeyPress(Sender: TObject; var Key: Char);
    procedure senhaKeyPress(Sender: TObject; var Key: Char);
    procedure JsBotao1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    logado : boolean;
    function login_muda_as_variaveis_de_usuario(var logou : boolean; var bloqueios, usuarioNome, configu : String) : boolean;
    { Public declarations }
  end;

var
  Form53: TForm53;

implementation

uses func, untDtmMain, untVendaPDV;

{$R *.dfm}
function TForm53.login_muda_as_variaveis_de_usuario(var logou : boolean; var bloqueios, usuarioNome, configu : String) : boolean;
begin
  logado := false;
  ShowModal;
  logou := logado;
  if logado then
    begin
      bloqueios   := dtmMain.ibquery1.fieldbyname('acesso').asstring;
      usuarioNome := dtmMain.ibquery1.fieldbyname('nome').asstring;
      configu     := dtmMain.ibquery1.fieldbyname('configu').asstring;
      dtmMain.ibquery1.Close;
    end;

  nome.Text  := '';
  senha.Text := '';
end;

procedure TForm53.FormShow(Sender: TObject);
begin
  nome.SetFocus;
  logado := false;
end;

procedure TForm53.nomeKeyPress(Sender: TObject; var Key: Char);
begin
  if key = #13 then senha.SetFocus;
  if key = #27 then close;
end;

procedure TForm53.senhaKeyPress(Sender: TObject; var Key: Char);
begin
  if key = #27 then nome.SetFocus;
  if key = #13 then
    begin
      JsBotao1.Click;
    end;
end;

procedure TForm53.JsBotao1Click(Sender: TObject);
begin
  logado := logar(nome.Text, senha.Text);
  if logado then
    begin
      Close;
    end
  else
    begin
      nome.Text  := '';
      senha.Text := '';
      nome.SetFocus;
      dtmMain.ibquery1.Close;
    end;
end;

procedure TForm53.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  //jsedit.LiberaMemoria(self);
end;

end.
