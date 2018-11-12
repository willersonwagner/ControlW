unit login;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Vcl.Imaging.jpeg, ExtCtrls, Buttons, JsBotao1, jsedit1;

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
    function login_muda_as_variaveis_de_usuario(var logou : boolean) : boolean;
    { Public declarations }
  end;

var
  Form53: TForm53;

implementation

uses principal, func, Unit1;

{$R *.dfm}
function TForm53.login_muda_as_variaveis_de_usuario(var logou : boolean) : boolean;
var
  desc : String;
  vl, descUsu   : currency;
begin
  ShowModal;
  logou := logado;
  if logado then
    begin
      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add('select configu, cod from usuario where (usu = :nome) and (senha = :senha) and excluido = 0');
      dm.IBQuery1.ParamByName('nome').AsString  := funcoes.Criptografar(nome.Text);
      dm.IBQuery1.ParamByName('senha').AsString := funcoes.Criptografar(senha.Text);

      try
        dm.IBQuery1.Open;
      except
        on e:Exception do begin
          ShowMessage('57Ocorreu um erro: '+ e.Message);
          exit;
        end;
      end;


      if not dm.IBQuery1.IsEmpty then
        begin
          desc     := funcoes.LerConfig(dm.IBQuery1.fieldbyname('configu').AsString, 0);
          vl       := StrToCurr(desc);
          descUsu  := StrToCurr(funcoes.LerConfig(form22.Pgerais.Values['configu'], 0));
          while true do
            begin
              desc := funcoes.dialogo('numero',0,'',2,true,'S',Application.Title,'Qual o Desconto Máximo (max. '+ formataCurrency(vl) +'%)?', desc);
              if desc = '*' then
                begin
                  desc := CurrToStr(descUsu);
                  break;
                end;
              if StrToCurr(desc) <= vl then break;
            end;
            
          form22.Pgerais.Values['configu'] := dm.IBQuery1.fieldbyname('configu').AsString;
          if desc <> '*' then  form22.Pgerais.Values['configu'] := GravarConfig(form22.Pgerais.Values['configu'], desc, 0);

          ShowMessage('Venda Liberada para desconto de até ' + formataCurrency(StrToCurr(desc)) + '%');
        end;

      dm.IBQuery1.Close;
    end;

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
  logado := funcoes.logar(nome.Text, senha.Text);
  if logado then
    begin
      Close;
    end
  else
    begin
      nome.Text  := '';
      senha.Text := '';
      nome.SetFocus;
    end;
end;

procedure TForm53.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  jsedit.LiberaMemoria(self);
end;

end.

