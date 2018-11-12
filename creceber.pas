unit creceber;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, DBGrids, StdCtrls, Buttons, JsBotao1, ToolWin, ComCtrls,
  JsEditNumero1, JsEditInteiro1, Mask, JsEditData1, JsEdit1, ExtCtrls, DB,
  DBClient,ibquery;

type
  TForm29 = class(TForm)
    Panel1: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    JsEdit3: JsEdit;
    JsEditData1: JsEditData;
    JsEdit1: JsEditInteiro;
    GroupBox1: TGroupBox;
    JsEditInteiro2: JsEditInteiro;
    JsEdit2: JsEdit;
    JsEditNumero1: JsEditNumero;
    DBGrid1: TDBGrid;
    GroupBox2: TGroupBox;
    nomegrupo: TLabel;
    GroupBox3: TGroupBox;
    nomehis: TLabel;
    ToolBar1: TPanel;
    info: TLabel;
    JsBotao1: JsBotao;
    DataSource1: TDataSource;
    ClientDataSet1: TClientDataSet;
    procedure JsEdit3KeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure JsEdit1KeyPress(Sender: TObject; var Key: Char);
    procedure JsBotao1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure JsEdit3Exit(Sender: TObject);
    procedure JsEdit3KeyPress(Sender: TObject; var Key: Char);
    procedure JsEditInteiro2KeyPress(Sender: TObject; var Key: Char);
    procedure JsEditNumero1KeyPress(Sender: TObject; var Key: Char);
    procedure JsEdit2Enter(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure DBGrid1KeyPress(Sender: TObject; var Key: Char);
  private
    cliente,nota : string;
    localizagrupo,localizahis :string;
    function verificaCreceber() : boolean;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form29: TForm29;


implementation

uses func, Unit1, principal;

{$R *.dfm}

procedure TForm29.JsEdit3KeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
 if key=119 then
 begin
  //form7.DBGrid1.Options
  funcoes.localizar('Localizar Contas a Receber','contasreceber','codgru as grupo,vencimento,documento,codhis as nrdocumento,historico,total,cod','','cod','historico','vencimento',true,true,true,' where (pago = 0) ',500,sender);
 end;
end;

procedure TForm29.JsEdit1KeyPress(Sender: TObject; var Key: Char);
begin
if (JsEdit1.Text<>'') and (key=#13) then
  begin
    cliente := funcoes.BuscaNomeBD(dm.ibquery1,'nome','cliente','where cod = '+tedit(sender).Text);
    if cliente = 'Desconhecido' then
      begin
        key := #0;
        Beep;
        WWMessage('Cliente Não Econtrado!',mtError,[mbok],clYellow,true,false,clRed);
      end;
  end;

{ if (JsEdit1.Text<>'') and (key=#13) then
  begin
    dm.IBQuery1.SQL.Clear;
    dm.IBQuery1.SQL.Add('select * from contasreceber where (codgru='+JsEdit3.Text+') and (vencimento=:data) and (documento='+JsEdit1.Text+') and (pago=0)');
    dm.IBQuery1.ParamByName('data').AsDateTime:= funcoes.PreparaData(JsEditData1.Text);
    try
     dm.IBQuery1.Open;
    except
     key:=#0;
     ShowMessage('Caractere inválido!!');
    end;
    if not(dm.IBQuery1.IsEmpty) then
      begin
        key:=#0;
        ShowMessage('A conta já existe!');
      end;
    dm.IBQuery1.Close;
 end;
}

if (TEdit(Sender).Text = '') and  (key=#13) then
  begin
    cliente := funcoes.localizar('Localizar Cliente','cliente','cod,nome','cod,nome','','nome','nome',true,false,false,'',0,sender);
    TEdit(Sender).Text := copy(cliente,1,pos('-',cliente)-1);
  end;

if (TEdit(Sender).Text = '') and (key = #13) then key := #0;

end;

procedure TForm29.JsBotao1Click(Sender: TObject);
var
formpagto,datamov,parcelas,inicial,periodo,vendedor : string;
valorprestacao, valor : currency;
vencimento : tdatetime;
i,cont : integer;
begin
  if not verificaCreceber() then exit;

 try
  parcelas := funcoes.dialogo('not',0,'1234567890'+#8,40,true,'',Application.Title,'Qual a Quantidade de Parcelas?','1');
  if parcelas = '*' then exit;

  periodo := funcoes.dialogo('not',0,'1234567890'+#8,40,true,'',Application.Title,'Qual o Período entre Parcelas?','30');
  if periodo = '*' then exit;

  inicial := funcoes.dialogo('not',0,'1234567890'+#8,40,true,'',Application.Title,'Qual a Parcela Inicial?','1');
  if inicial = '*' then exit;

  formpagto := funcoes.LerFormPato(0,'',true);
  if formpagto = '*' then exit;

  datamov := funcoes.dialogo('data',0,'',0,true,'',Application.Title,'Confirme a Data de Movimento:',formatadataddmmyy(form22.datamov));
  if datamov = '*' then exit;

  vendedor := funcoes.dialogo('generico',0,'1234567890'+#8,50,false,'',Application.Title,'Qual o Vendedor?',form22.Pgerais.Values['codvendedor']);
  if vendedor = '*' then exit;

  valorprestacao := Arredonda(StrToCurr(funcoes.ConverteNumerico(JsEditNumero1.text)) ,2);
  vencimento := StrToDate(JsEditData1.Text);

  //valor := 0;
  //valor := Arredonda(JsEditNumero1.getValor / StrToCurr(parcelas), 2);
 except
   ShowMessage('Houve um Erro de Conversão. Refaça o Parcelamento.');
   exit;
 end;
 for i := StrToInt(inicial) to StrToInt(parcelas) do
 begin
   dm.IBQuery1.SQL.Clear;
   //dm.IBQuery1.SQL.Add('insert into contasreceber(codgru,cod,formpagto,datamov,vendedor,data,vencimento,documento,codhis,historico,total,nota,valor) values(:codgru,'+funcoes.novocod('creceber')+',:form,:datamov,:vend,:data,:vencimento,'+JsEdit1.Text+','+JsEditInteiro2.Text+',:hist,:total,'+nota+',:valor)');
   dm.IBQuery1.SQL.Add('insert into contasreceber(codgru,cod,formpagto,datamov,vendedor,data,vencimento,documento,codhis,historico,total,nota,valor) values(:codgru,'+funcoes.novocod('creceber')+',:form,:datamov,:vend,:data,:vencimento,:documento,:codhis,:hist,:total,0,:valor)');
   dm.IBQuery1.ParamByName('codgru').AsString := JsEdit3.Text;
   dm.IBQuery1.ParamByName('form').AsInteger := StrToInt(formpagto);
   dm.IBQuery1.ParamByName('datamov').AsDateTime:= StrToDate(datamov);
   dm.IBQuery1.ParamByName('vend').AsString := StrNum(vendedor);

   if i = 1 then
    begin
      dm.IBQuery1.ParamByName('vencimento').AsDateTime := vencimento;
      dm.IBQuery1.ParamByName('data').AsDateTime := form22.datamov;
    end
     else
       begin
         vencimento := vencimento + StrToInt(periodo);
         dm.IBQuery1.ParamByName('data').AsDateTime:= form22.datamov;
         dm.IBQuery1.ParamByName('vencimento').AsDateTime := vencimento;
       end;

   dm.IBQuery1.ParamByName('documento').AsString := StrNum(JsEdit1.Text);
   dm.IBQuery1.ParamByName('codhis').AsString := StrNum(JsEditInteiro2.Text);
   dm.IBQuery1.ParamByName('hist').AsString := funcoes.CompletaOuRepete(copy(JsEdit2.Text,1,30),funcoes.CompletaOuRepete('',IntToStr(i),' ',2)+'/'+funcoes.CompletaOuRepete('',parcelas,' ',2),' ',35);
   dm.IBQuery1.ParamByName('total').AsCurrency := valorprestacao;
   dm.IBQuery1.ParamByName('valor').AsCurrency := valorprestacao;
   try
     dm.IBQuery1.ExecSQL;
   except
     ShowMessage('Ocorreu um Conflito nas Transações. Tente Novamente');
     JsEditNumero1.SetFocus;
     dm.IBQuery1.Transaction.Rollback;
   end;
 end;

 try
   dm.IBQuery1.Transaction.Commit;

   ClientDataSet1.Open;
   ClientDataSet1.Insert;
   ClientDataSet1.FieldByName('grupo').AsString := JsEdit3.Text;
   ClientDataSet1.FieldByName('vencimento').AsDateTime := StrToDate(JsEditData1.Text);
   ClientDataSet1.FieldByName('documento').AsString := JsEdit1.Text;
   ClientDataSet1.FieldByName('historico').AsString := funcoes.CompletaOuRepete(copy(JsEdit2.Text,1,28),'1/ 1' ,' ',35);
   ClientDataSet1.FieldByName('total').AsCurrency := StrToCurr(funcoes.ConverteNumerico(JsEditNumero1.text));

   ClientDataSet1.Post;


 except

 end;
   nota := '';
   funcoes.FormataCampos(dm.ibselect,2,'',2);
   JsEdit1.Text := '';
   JsEdit2.Text := '';
   JsEditNumero1.Text :='0,00';
   JsEdit3.SetFocusNoPrimeiroCampo(self.Name);
end;

procedure TForm29.FormClose(Sender: TObject; var Action: TCloseAction);
begin
JsEdit3.LiberaMemoria(self);
dm.IBselect.Close;
dm.IBQuery1.Close;
dm.IBQuery2.Close;
end;

procedure TForm29.FormShow(Sender: TObject);
begin
 dm.IBselect.SQL.Clear;
 dm.IBselect.SQL.Add('select codgru as grupo,vencimento,documento,codhis as nrdocumento,historico,total from contasreceber where (data=:data) and (pago=0)');
 dm.IBselect.ParamByName('data').AsDateTime := form22.datamov;
 dm.IBselect.Open;

 funcoes.Ibquery_to_clienteDataSet(dm.ibselect,clientdataset1);
 funcoes.FormataCampos(tibquery(ClientDataSet1),2,'',2);

 dm.IBselect.Close;

  JsEdit3.Text := '1';
  dm.IBQuery2.SQL.Clear;
  dm.IBQuery2.SQL.Add('select grupo from grupodecaixa where cod=1');
try
  dm.IBQuery2.Open;
  funcoes.FormataCampos(dm.ibselect,2,'',2);
  nomegrupo.Caption := dm.IBQuery2.fieldbyname('grupo').AsString;
  JsEditData1.Text := FormatDateTime('dd/mm/yyyy',form22.datamov);
  JsEditInteiro2.Text := '2';
  nomehis.Caption := 'REC. CONTA A PRAZO';
except
end;
  dm.IBQuery2.Close;
end;

procedure TForm29.JsEdit3Exit(Sender: TObject);
begin
 // JsEdit2.Text := copy(cliente,pos('-',cliente)+1,length(localizaGrupo)) ;
end;

procedure TForm29.JsEdit3KeyPress(Sender: TObject; var Key: Char);
begin
if not funcoes.Contido(key,'2345678901'+#8+#13+#27) then key := #0;
if key=#27 then close;
if (JsEdit3.Text = '') and  (key = #13) then
  begin
    localizaGrupo := funcoes.localizar('Localizar Grupo','grupodecaixa','cod,grupo','cod,grupo','cod','grupo','grupo',false,false,false,'',0,sender);
    JsEdit3.Text := copy(localizaGrupo,1,pos('-',localizaGrupo)-1);
    nomegrupo.Caption:= copy(localizaGrupo,pos('-',localizaGrupo)+1,length(localizaGrupo)) ;
  end;
if (JsEdit3.Text<>'') and  (key=#13) then
  begin
    dm.IBQuery1.SQL.Clear;
    dm.IBQuery1.SQL.Add('select grupo from grupodecaixa where cod='+JsEdit3.Text);
    try
    dm.IBQuery1.Open ;
    if dm.IBQuery1.FieldByName('grupo').AsString <> '' then nomegrupo.Caption:= dm.IBQuery1.FieldByName('grupo').AsString
      else
        begin
          nomegrupo.Caption:='NÃO ENCONTRADO';
          tedit(sender).SetFocus;
          key := #0;
        end;
    except
     ShowMessage('Código Inválido!');
     key:=#0;
     JsEdit3.SetFocus;
     JsEdit3.SelectAll;
    end;
     dm.IBQuery1.Close;
  end;

end;

procedure TForm29.JsEditInteiro2KeyPress(Sender: TObject; var Key: Char);
begin
if (JsEditInteiro2.Text<>'') and  (key=#13) then
  begin
    dm.IBQuery1.SQL.Clear;
    dm.IBQuery1.SQL.Add('select grupo from hiscaixa where cod='+JsEditInteiro2.Text);
    try
    dm.IBQuery1.Open
    except
    end;
    if dm.IBQuery1.FieldByName('grupo').AsString<>'' then nomehis.Caption:= dm.IBQuery1.FieldByName('grupo').AsString
      else nomehis.Caption:='NÃO ENCONTRADO';
    dm.IBQuery1.Close;
   end;

if (JsEditInteiro2.Text='') and  (key=#13) then
  begin
    localizaHis:= funcoes.localizar('Localizar Histórico','hiscaixa','cod,grupo','cod,grupo','cod','grupo','grupo',false,false,false,'',0,sender);
    TEdit(Sender).Text := copy(localizaHis,1,pos('-',localizaHis)-1);
    nomehis.Caption:= copy(localizaHis,pos('-',localizaHis)+1,length(localizaHis)) ;
  end;

end;

procedure TForm29.JsEditNumero1KeyPress(Sender: TObject; var Key: Char);
begin
if (key = #13) and not(StrToFloat(funcoes.ConverteNumerico(tedit(sender).Text)) > 0) then key := #0;
end;

procedure TForm29.JsEdit2Enter(Sender: TObject);
begin
  JsEdit2.Text := copy(cliente, 1, JsEdit2.MaxLength);
end;

procedure TForm29.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
if (key = 116) and (not DBGrid1.Focused) then DBGrid1.SetFocus;
end;

procedure TForm29.DBGrid1KeyPress(Sender: TObject; var Key: Char);
begin
if key = #27 then JsEdit3.SetFocus;
end;


function TForm29.verificaCreceber() : boolean;
begin
  Result := false;

  if JsEdit3.Text = '' then
    begin
      ShowMessage('Grupo Vazio');
      JsEdit3.SetFocus;
      exit;
    end;

  if JsEdit1.Text = '' then
    begin
      ShowMessage('Cliente Vazio');
      JsEdit1.SetFocus;
      exit;
    end;

  if JsEditInteiro2.Text = '' then
    begin
      ShowMessage('Codigo de Histórico Vazio');
      JsEditInteiro2.SetFocus;
      exit;
    end;

  if JsEdit2.Text = '' then
    begin
      ShowMessage('Histórico Vazio');
      JsEdit2.SetFocus;
      exit;
    end;

  if JsEditNumero1.getValor = 0 then
    begin
      ShowMessage('Preencha Valor');
      JsEditNumero1.SetFocus;
      exit;
    end;

  Result := true;  
end;

end.
