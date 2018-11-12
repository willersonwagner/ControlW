unit cadCodOp;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, JsBotao1, ToolWin, ComCtrls, JsEdit1,
  JsEditInteiro1, ExtCtrls, JsEditNumero1;

type
  TCadCP = class(TForm)
    painel: TPanel;
    Label2: TLabel;
    Label1: TLabel;
    cod: JsEdit;
    nome: JsEdit;
    ToolBar1: TPanel;
    JsBotao1: JsBotao;
    JsBotao2: JsBotao;
    info: TLabel;
    JsEdit1: JsEdit;
    Label3: TLabel;
    JsEdit2: JsEdit;
    Label4: TLabel;
    procedure JsBotao1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure codKeyPress(Sender: TObject; var Key: Char);
    procedure codEnter(Sender: TObject);
    procedure codKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure JsBotao2Click(Sender: TObject);
    procedure JsEdit1KeyPress(Sender: TObject; var Key: Char);
    procedure JsEdit2KeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  CadCP: TCadCP;
  ultcod : integer;
implementation

uses Unit1, localizar, func, caixaLista;

{$R *.dfm}

procedure TCadCP.JsBotao1Click(Sender: TObject);
begin
  dm.IBQuery2.Close;
  dm.IBQuery2.SQL.Clear;
  dm.IBQuery2.SQL.Add('update or insert into cod_op(cod,nome, pis, icms) values(:cod,:nome,:pis, :icms) matching(cod) ');
  dm.IBQuery2.ParamByName('cod').AsString  := cod.Text;
  dm.IBQuery2.ParamByName('nome').AsString := nome.Text;
  dm.IBQuery2.ParamByName('pis').AsString  := JsEdit2.Text;
  dm.IBQuery2.ParamByName('icms').AsString := JsEdit1.Text;
  try
    dm.IBQuery2.ExecSQL;
    dm.IBQuery2.Transaction.Commit;
    JsEdit.LimpaCampos(tedit(Sender).Owner.Name);
  except
    dm.IBQuery2.Transaction.Rollback;
    ShowMessage('Ocorreu um Erro Inesperado. Tente Novamente!');
  end;

end;

procedure TCadCP.FormShow(Sender: TObject);
begin
   JsEdit.SetTabelaDoBd(self,'cod_op',dm.IBQuery1);
end;

procedure TCadCP.FormClose(Sender: TObject; var Action: TCloseAction);
begin
   JsEdit.LiberaMemoria(self);
end;

procedure TCadCP.codKeyPress(Sender: TObject; var Key: Char);
begin
 if key = #27 then Close;
 if (key = #13) and (tedit(sender).Text <> '') then
   begin
     dm.IBselect.Close;
     dm.IBselect.SQL.Clear;
     dm.IBselect.SQL.Add('select nome, pis, icms from cod_op where cod = :cod');
     dm.IBselect.ParamByName('cod').AsString := cod.Text;
     dm.IBselect.Open;
     nome.Text    := dm.IBselect.fieldbyname('nome').AsString;
     JsEdit2.Text := dm.IBselect.fieldbyname('pis').AsString;
     JsEdit1.Text := dm.IBselect.fieldbyname('icms').AsString;
     dm.IBselect.Close;
   end;
 if (not funcoes.Contido(key,'1234567890'+#13+#8))  Then key := #0;
end;

procedure TCadCP.codEnter(Sender: TObject);
begin
  //ultCod := JsEdit.UltimoCodigoDaTabela(self.Name);
  //info.Caption := ' F5 - Consulta    Ultimo Código: ' + inttostr(ultCod);
end;

procedure TCadCP.codKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
if (Key = 116) then
   begin
      tedit(sender).Text := funcoes.localizar('Localizar Cod Operações','cod_op','cod,nome','cod','','nome','cod',true,false,false,'',500,sender);
   end;

end;

procedure TCadCP.JsBotao2Click(Sender: TObject);
begin
  JsEdit.ExcluiDoBD(tedit(sender).Owner.Name);
end;

procedure TCadCP.JsEdit1KeyPress(Sender: TObject; var Key: Char);
begin
key := UpCase(key);
if not funcoes.Contido(key,'SIN'+#13+#27+#8) then key := #0;
if (key = #13) and ((
(tedit(sender).Text)='') or (tedit(sender).Text='0')) then
 begin
   form39 := tform39.Create(self);
   form39.ListBox1.Items.Add('  - TRIBUTADO');
   form39.ListBox1.Items.Add('N - NÃO TRIBUTADO');
   form39.ListBox1.Items.Add('I - ISENTO');
   form39.ListBox1.Items.Add('S - SUBSTITUIÇÃO');
   tedit(sender).Text := funcoes.lista(Sender, false);
 end;
if tedit(sender).Text = '*' then
 begin
  tedit(sender).Text := '';
  key := #0;
 end;
end;

procedure TCadCP.JsEdit2KeyPress(Sender: TObject; var Key: Char);
begin
key := UpCase(key);
if not funcoes.Contido(key,'IMXR'+#13+#27+#8) then key := #0;
if (key = #13) and ((tedit(sender).Text='') or (tedit(sender).Text='0')) then
 begin
   form39 := tform39.Create(self);
   form39.ListBox1.Items.Add('  - TRIBUTADO');
   form39.ListBox1.Items.Add('I - ISENTO             (07)');
   form39.ListBox1.Items.Add('R - Aliq. Red. Zero    (06)');
   form39.ListBox1.Items.Add('M - Monofásico         (04)');
   form39.ListBox1.Items.Add('X - Sem Incidencia     (08)');
   tedit(sender).Text := funcoes.lista(Sender, false);
 end;
if tedit(sender).Text = '*' then
 begin
  tedit(sender).Text := '';
  key := #0;
 end;
end;

end.
