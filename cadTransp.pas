unit cadTransp;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, JsBotao1, Mask, JsEditCNPJ1, JsEdit1,
  JsEditInteiro1, ExtCtrls, JsEditCPF1;

type
  TForm10 = class(TForm)
    painel: TPanel;
    Label2: TLabel;
    Label1: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label16: TLabel;
    Label3: TLabel;
    ToolBar1: TPanel;
    info: TLabel;
    JsBotao1: JsBotao;
    JsBotao2: JsBotao;
    cod: JsEditInteiro;
    nome: JsEdit;
    tipo: JsEditInteiro;
    cnpj: JsEditCNPJ;
    ies: JsEdit;
    suframa: JsEdit;
    endereco: JsEdit;
    bairro: JsEdit;
    cep: JsEdit;
    est: JsEdit;
    cid: JsEdit;
    fone: JsEdit;
    fax: JsEdit;
    obs: JsEdit;
    cod_mun: JsEdit;
    Label15: TLabel;
    procedure JsBotao1Click(Sender: TObject);
    procedure JsBotao2Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure codEnter(Sender: TObject);
    procedure tipoKeyPress(Sender: TObject; var Key: Char);
    procedure estKeyPress(Sender: TObject; var Key: Char);
    procedure cidKeyPress(Sender: TObject; var Key: Char);
    procedure codKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure codKeyPress(Sender: TObject; var Key: Char);
    procedure nomeEnter(Sender: TObject);
  private
    codestado,nome1, retornoCod : string;
    novoCod, ultCod : integer;
    procedure setMask(const tipo : integer);
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form10: TForm10;

implementation

uses Unit1, caixaLista, func;

{$R *.dfm}

procedure TForm10.setMask(const tipo : integer);
begin
  if tipo = 1 then
    begin
      Label6.Caption := 'CPF:';
      cnpj.EditMask := '!999.999.999-99;1;_';
    end
  else
    begin
      Label6.Caption := 'CNPJ:';
      cnpj.EditMask := '!99.999.999/9999-99;1;_';
    end;
end;

procedure TForm10.JsBotao1Click(Sender: TObject);
begin
  retornoCod := JsEdit.GravaNoBD(self);
end;

procedure TForm10.JsBotao2Click(Sender: TObject);
begin
  JsEdit.ExcluiDoBD(self.Name);
end;

procedure TForm10.FormClose(Sender: TObject; var Action: TCloseAction);
begin
   JsEdit.LiberaMemoria(self);
   funcoes.retornoLocalizar := retornoCod;
end;

procedure TForm10.FormShow(Sender: TObject);
begin
  JsEdit.SetTabelaDoBd(self,'transportadora', dm.IBQuery1);
end;

procedure TForm10.codEnter(Sender: TObject);
begin
  ultCod := JsEdit.UltimoCodigoDaTabela(self.Name);
  info.Caption := ' F5 - Consulta    Ultimo Código: ' + inttostr(ultCod);
end;

procedure TForm10.tipoKeyPress(Sender: TObject; var Key: Char);
begin
if (key=#13) then
 begin
   if ((tedit(sender).Text='0') or (tedit(sender).Text='')) then
     begin
       form39 := tform39.Create(self);
       form39.ListBox1.Items.Add('1 - PESSOA FÍSICA');
       form39.ListBox1.Items.Add('2 - PESSOA JURÍDICA');
       tedit(sender).Text := funcoes.lista(Sender, false);
     end;  

   setMask(StrToIntDef(tedit(sender).Text , 2));
   //if cod.Text <> '0' then cnpj.Clear;
  //tedit(sender).Text := funcoes.localizar('Tipo de Cliente','tipocli','cod,nome','cod','cod','nome','cod',false,false,false,'',300,sender);
 end;


{if (key=#13) and (tedit(sender).Text='1') then
  begin
    Label6.Caption := 'CPF:';
    cnpj.EditMask := '!999.999.999-99;1;_';
  end;
if (key=#13) and (tedit(sender).Text='2') then
  begin
    Label6.Caption := 'CNPJ:';
    cnpj.EditMask := '!99.999.999/9999-99;1;_';
  end;
}
end;

procedure TForm10.estKeyPress(Sender: TObject; var Key: Char);
begin
if (key = #13) and  (tedit(sender).Text <> '') then
  begin
    dm.IBselect.Close;
    dm.IBselect.SQL.Clear;
    dm.IBselect.SQL.Add('select * from estados where nome = :nome');
    dm.IBselect.ParamByName('nome').AsString := tedit(sender).Text;
    dm.IBselect.Open;

    if dm.IBselect.IsEmpty then
      begin
        dm.IBselect.Close;
        ShowMessage('Estado Não Encontrado.');
        exit;
      end;
    codEstado := dm.IBselect.fieldByName('cod').AsString;

  end;

if (key=#13) and (tedit(sender).Text='') then
  begin
   nome1 := funcoes.localizar('Localizar Estado','Estados','cod,nome','cod,nome','cod','nome','nome',false,false,false,'',300,NIL);
   tedit(sender).Text := copy(nome1,pos('-',nome1)+1,length(nome1));
   codEstado := copy(nome1,1,pos('-',nome1)-1);
   key := #0;
  end;

end;

procedure TForm10.cidKeyPress(Sender: TObject; var Key: Char);
begin
if (key=#13) and (tedit(sender).Text = '') then
  begin
    tedit(sender).Text := funcoes.localizar('Localizar Municipio','municipios_ibge','cod,nome','cod,nome','','nome','nome',false,false,false,' where cod like('+QuotedStr(codEstado+'%')+')',300,sender);

    if (tedit(sender).Text <> '') then
      begin
        cod_mun.Text := copy(tedit(sender).Text, 1, pos('-', tedit(sender).Text) -1);
        tedit(sender).Text := copy(tedit(sender).Text, pos('-', tedit(sender).Text) + 1, length(tedit(sender).Text));
      end;

   { dm.IBselect.Close;
    dm.IBselect.SQL.Clear;
    dm.IBselect.SQL.Add('select * from municipios_ibge where nome = :nome');
    dm.IBselect.ParamByName('nome').AsString := tedit(sender).Text;
    dm.IBselect.Open;

    cod_mun.Text := dm.IBselect.fieldByName('cod').AsString;
  }  key := #0;
  end;
end;

procedure TForm10.codKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
if (Key = 116) then
   begin
    tedit(sender).Text := funcoes.localizar('Localizar Transportadora','transportadora','cod,nome,cnpj, est as estado','cod','','nome','nome',true,false,false,'',300,sender);
   end;
end;

procedure TForm10.codKeyPress(Sender: TObject; var Key: Char);
begin
  if key = #27 then Close;
  if key = #13 then retornoCod := cod.Text;
end;

procedure TForm10.nomeEnter(Sender: TObject);
begin
  setMask(StrToIntDef(tipo.Text, 1));

  dm.IBselect.Close;
  dm.IBselect.SQL.Clear;
  dm.IBselect.SQL.Add('select cnpj from TRANSPORTADORA where cod = :cod');
  dm.IBselect.ParamByName('cod').AsString := cod.Text;
  dm.IBselect.Open;
  cnpj.Text := dm.IBselect.fieldbyname('cnpj').AsString;

  dm.IBselect.Close;
end;

end.
