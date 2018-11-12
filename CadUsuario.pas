unit CadUsuario;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, DBGrids, StdCtrls, ComCtrls, ToolWin, Buttons, JsBotao1,
  JsEdit1, JsEditInteiro1, ExtCtrls;

type
  TForm5 = class(TForm)
    painel: TPanel;
    Label2: TLabel;
    Label1: TLabel;
    cod: JsEditInteiro;
    nome: JsEdit;
    ToolBar1: TPanel;
    JsBotao1: JsBotao;
    JsBotao2: JsBotao;
    info: TLabel;
    vendedor: JsEditInteiro;
    Label3: TLabel;
    Label4: TLabel;
    usu: JsEdit;
    senha: JsEdit;
    Label5: TLabel;
    Label6: TLabel;
    procedure JsBotao1Click(Sender: TObject);
    procedure codKeyPress(Sender: TObject; var Key: Char);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure JsBotao2Click(Sender: TObject);
    procedure codEnter(Sender: TObject);
    procedure codKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure vendedorKeyPress(Sender: TObject; var Key: Char);
    procedure nomeExit(Sender: TObject);
    procedure nomeKeyPress(Sender: TObject; var Key: Char);
    procedure usuKeyPress(Sender: TObject; var Key: Char);
    procedure nomeEnter(Sender: TObject);
  private
    ok : boolean;
    descript : boolean;
    function existeUsuarioTrueExisttir(const cod1 : string) : boolean;
    function verificaSeUsuarioTemMovimentoParaExcluir() : boolean;
    function excluiUsuario() : boolean;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form5: TForm5;
  ultcod : integer;
implementation

uses Unit1, localizar, func, principal;

{$R *.dfm}
procedure TForm5.codKeyPress(Sender: TObject; var Key: Char);
begin
 if key = #27 then self.Close;
 if key = #13 then
   begin

   end;
end;

function TForm5.existeUsuarioTrueExisttir(const cod1 : string) : boolean;
begin
  Result := false;
  dm.IBselect.Close;
  dm.IBselect.SQL.Clear;
  dm.IBselect.SQL.Add('select cod from usuario where usu = :cod');
  dm.IBselect.ParamByName('cod').AsString := funcoes.Criptografar(cod1);
  dm.IBselect.Open;

  Result := not dm.IBselect.IsEmpty;
  dm.IBselect.Close;
end;

procedure TForm5.JsBotao1Click(Sender: TObject);
var
  config : String;
begin
  if true then
    begin
      {dm.IBselect.Close;
      dm.IBselect.SQL.Text := ('select cod, usu from usuario where usu = :usu');
      dm.IBselect.ParamByName('usu').AsString := funcoes.Criptografar(tedit(sender).Text);
      dm.IBselect.Open;
      if not dm.IBselect.IsEmpty then
        begin
          if cod.Text = '0' then
            begin
              WWMessage('O Usuário Informado Já Existe! Por Favor Informe Outro Nome. ',mtInformation,[mbOK],clYellow,true,false,clRed);
              ok := false;
            end;
        end;}


      config := form22.Pgerais.Values['configu'];
      config := GravarConfig(config, '0,00', 0);

      dm.IBselect.Close;
      dm.IBselect.SQL.Clear;
      if vendedor.Text = '' then vendedor.Text := '0';
      if cod.Text = '0' then cod.Text := funcoes.novocod('usuario');
      dm.IBselect.SQL.Add('update or insert into usuario(cod,nome,vendedor,usu,senha,configu) values(:cod,:nome,:vend,:usu,:senha,:configu) matching(cod)');
      dm.IBselect.ParamByName('cod').AsString     := cod.Text;
      dm.IBselect.ParamByName('nome').AsString    := nome.Text;
      dm.IBselect.ParamByName('vend').AsString    := vendedor.Text;
      dm.IBselect.ParamByName('usu').AsString     := funcoes.Criptografar(usu.Text);
      dm.IBselect.ParamByName('senha').AsString   := funcoes.Criptografar(senha.Text);
      dm.IBselect.ParamByName('configu').AsString := config;
      try
        dm.IBselect.ExecSQL;
        dm.IBselect.Transaction.Commit;
        cod.Enabled := true;
        nome.Text     := '';
        senha.Text    := '';
        usu.Text      := '';
        vendedor.Text := '';
        cod.Text := '';
        cod.SetFocus;
      except
        WWMessage('Ocorreu Um Erro e o Usuário Não Foi Gravado.',mtInformation,[mbOK],clYellow,true,false,clRed);
        dm.IBselect.Transaction.Rollback;
      end;
    end
  else
    begin
      WWMessage('Este Usuário Não Pode Ser Gravado!',mtInformation,[mbOK],clYellow,true,false,clRed);
    end;
end;


procedure TForm5.FormShow(Sender: TObject);
begin
JsEdit.SetTabelaDoBd(self,'usuario', dm.IBQuery1);
descript := false;
end;

procedure TForm5.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  JsEdit.LiberaMemoria(self);
end;

procedure TForm5.JsBotao2Click(Sender: TObject);
begin
  if cod.Text = '0' then
    begin
      exit;
    end;

   excluiUsuario();
end;

procedure TForm5.codEnter(Sender: TObject);
begin
  ultCod := JsEdit.UltimoCodigoDaTabela(self.Name);
  info.Caption := ' F5 - Consulta    Ultimo Código: ' + inttostr(ultCod);
  descript := false;
end;

procedure TForm5.codKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
if (Key = 116) then
  begin
    tedit(sender).Text := funcoes.localizar('Localizar Usuário','usuario','cod,nome','cod','','nome','nome',true,false,false,'',300,sender);
  end;

end;

procedure TForm5.vendedorKeyPress(Sender: TObject; var Key: Char);
begin
 if (key=#13) and (tedit(sender).Text='') then
  begin
    tedit(sender).Text := funcoes.localizar('Localizar Vendedor','vendedor','cod,nome','cod','','nome','nome',false,false,false,'',300,sender);
  end;
 if (key=#13) and (tedit(sender).Text<>'') then
  begin
    dm.IBselect.Close;
    dm.IBselect.SQL.Clear;
    dm.IBselect.SQL.Add('select * from vendedor where cod = :cod');
    dm.IBselect.ParamByName('cod').AsString := tedit(sender).Text;
    try
     dm.IBselect.Open;
    except
     exit;
    end;
    if not dm.IBselect.IsEmpty then
     begin
      Label6.Caption := 'Vendedor: '+ dm.IBselect.fieldbyname('nome').AsString;
     end
    else
     begin
       Label6.Caption := 'Vendedor Não Cadastrado!';
     end;
   dm.IBselect.Close;
  end;
end;

procedure TForm5.nomeExit(Sender: TObject);
begin
  if cod.Text = '0' then
    begin
      dm.IBselect.Close;
      dm.IBselect.SQL.Clear;
      dm.IBselect.SQL.Add('select nome from usuario where nome='+QuotedStr(tedit(sender).Text));
      dm.IBselect.Open;
      if not dm.IBselect.IsEmpty then
        begin
          WWMessage('Este Nome de Usuário Informado Já Existe! Por Favor Informe Outro Nome. ',mtInformation,[mbOK],clYellow,true,false,clRed);
          TEdit(sender).SetFocus;
        end
       else ok := true;
      dm.IBselect.Close;
    end;
end;

procedure TForm5.nomeKeyPress(Sender: TObject; var Key: Char);
begin
if key = #27 then ok := true;
end;

procedure TForm5.usuKeyPress(Sender: TObject; var Key: Char);
begin
  if key = #27 then
    begin
      ok := true;
    end;

  if key = #13 then
    begin
      if tedit(sender).Text <> '' then
         begin
           dm.IBselect.Close;
           dm.IBselect.SQL.Text := ('select cod, usu from usuario where usu = :usu');
           dm.IBselect.ParamByName('usu').AsString := funcoes.Criptografar(tedit(sender).Text);
           //dm.IBselect.ParamByName('cod').AsString := cod.Text;
           dm.IBselect.Open;
           if not dm.IBselect.IsEmpty then
             begin
               if cod.Text = '0' then
                 begin
                   WWMessage('O Usuário Informado Já Existe! Por Favor Informe Outro Nome. ',mtInformation,[mbOK],clYellow,true,false,clRed);
                   ok := false;
                   key :=#0;
                 end
               else
                 begin
                   if cod.Text <> dm.IBselect.FieldByName('cod').AsString  then
                     begin
                       WWMessage('O Usuário Informado Já Existe! Por Favor Informe Outro Nome. ',mtInformation,[mbOK],clYellow,true,false,clRed);
                       ok := false;
                       key :=#0;
                     end;
                 end;
             end
           else ok := true;
           dm.IBselect.Close;
         end;
         if not ok then  TEdit(sender).SetFocus;
      end;
  end;


procedure TForm5.nomeEnter(Sender: TObject);
begin
  if descript = false then
    begin
      usu.Text   := funcoes.DesCriptografar(usu.Text);
      senha.Text := funcoes.DesCriptografar(senha.Text);
      descript   := true;
    end;
end;

function TForm5.verificaSeUsuarioTemMovimentoParaExcluir() : boolean;
begin
  Result :=  false;

  dm.IBselect.Close;
  dm.IBselect.SQL.Text := 'select nota from venda where usuario = :usu';
  dm.IBselect.ParamByName('usu').AsString := cod.Text;
  dm.IBselect.Open;

  if not dm.IBselect.IsEmpty then Result := true;
  dm.IBselect.Close;

  dm.IBselect.Close;
  dm.IBselect.SQL.Text := 'select codmov, historico from caixa where usuario = :usu';
  dm.IBselect.ParamByName('usu').AsString := cod.Text;
  dm.IBselect.Open;

  if not dm.IBselect.IsEmpty then Result := true;
  dm.IBselect.Close;
end;

function TForm5.excluiUsuario() : boolean;
var
  cod1 : integer;
  msg  : string; 
begin
  Result := false;
  cod1 := StrToIntDef(StrNum(cod.Text), 0);

  if cod1 = 0 then
    begin
      MessageDlg('Usuário Cód: ' + IntToStr(cod1) + ' é Inválido!', mtInformation, [mbOK], 1);
      exit;
    end;

  if verificaSeUsuarioTemMovimentoParaExcluir then msg := 'O Usuário tem Movimento, Deseja Excluir Mesmo Assim ?'
    else msg := 'Deseja Excluir o Usuário ?';

  if MessageDlg(msg, mtConfirmation, [mbYes, mbNo], 1) = idno then exit;  

  {dm.IBQuery1.Close;
  dm.IBQuery1.SQL.Text := 'update usuario set excluido = :usu where cod = :cod';
  dm.IBQuery1.ParamByName('usu').AsInteger := StrToIntDef(StrNum(form22.codusario), 0);
  dm.IBQuery1.ParamByName('cod').AsInteger := cod1;
  dm.IBQuery1.ExecSQL;}

  dm.IBQuery1.Close;
  dm.IBQuery1.SQL.Text := 'delete from usuario where cod = :cod';
  dm.IBQuery1.ParamByName('cod').AsInteger := cod1;
  dm.IBQuery1.ExecSQL;

  try
    funcoes.gravaAlteracao('Usuario ' + cod.Text + '-' + nome.Text +' Pelo Usuario ' + form22.codusario + '-' + form22.usuario);
    dm.IBQuery1.ExecSQL;
    dm.IBQuery1.Transaction.Commit;

    dm.IBselect.Close;
    dm.IBselect.SQL.Text := 'select nome from usuario where cod = :cod';
    dm.IBselect.ParamByName('cod').AsInteger := cod1;
    dm.IBselect.Open;

    funcoes.gravaAlteracao('Usuario Excluido Cod: ' + IntToStr(cod1) + ' Nome: ' + dm.IBselect.fieldbyname('nome').AsString);
    jsedit.LimpaCampos(self.Name);
  except
    on e:exception do
      begin
        MessageDlg('Ocorreu um Erro na Exclusão: ' + #13 + e.Message, mtError, [mbOK], 1);
      end;
  end;

  dm.IBselect.Close;
end;

end.
