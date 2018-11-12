unit MovCaixa;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, DBGrids, StdCtrls, Buttons, JsBotao1, ToolWin, ComCtrls,
  JsEditNumero1, JsEditInteiro1, Mask, JsEditData1, JsEdit1, ExtCtrls, DB,
  DBClient,ibquery;

type
  TMovcaixalanc = class(TForm)
    DataSource1: TDataSource;
    ClientDataSet1: TClientDataSet;
    Panel1: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    GroupBox2: TGroupBox;
    nomegrupo: TLabel;
    GroupBox3: TGroupBox;
    nomehis: TLabel;
    JsEdit3: JsEditInteiro;
    JsEditData1: JsEditData;
    JsEdit1: JsEditInteiro;
    GroupBox1: TGroupBox;
    JsEditInteiro2: JsEditInteiro;
    JsEdit2: JsEdit;
    JsEditNumero1: JsEditNumero;
    JsEditNumero2: JsEditNumero;
    DBGrid1: TDBGrid;
    ToolBar1: TPanel;
    JsBotao1: JsBotao;
    procedure JsEdit3KeyPress(Sender: TObject; var Key: Char);
    procedure JsEdit1KeyPress(Sender: TObject; var Key: Char);
    procedure JsEditInteiro2KeyPress(Sender: TObject; var Key: Char);
    procedure JsBotao1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure JsEditNumero1KeyPress(Sender: TObject; var Key: Char);
    procedure JsEditNumero2KeyPress(Sender: TObject; var Key: Char);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure JsEditData1KeyPress(Sender: TObject; var Key: Char);
  private
    codMov : String;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Movcaixalanc: TMovcaixalanc;
  localizaGrupo:string;
  localizaHis:string;

implementation

uses func, Unit1, DateUtils, principal, StrUtils;

{$R *.dfm}

procedure TMovcaixalanc.JsEdit3KeyPress(Sender: TObject; var Key: Char);
begin
if key=#27 then close;
if (JsEdit3.Text='') and  (key=#13) then
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
    if dm.IBQuery1.FieldByName('grupo').AsString<>'' then nomegrupo.Caption:= dm.IBQuery1.FieldByName('grupo').AsString
      else nomegrupo.Caption:='NÃO ENCONTRADO';
    except
     ShowMessage('Código Inválido!');
     key:=#0;
     JsEdit3.SetFocus;
     JsEdit3.SelectAll;
    end;
     dm.IBQuery1.Close;
  end;

end;

procedure TMovcaixalanc.JsEdit1KeyPress(Sender: TObject; var Key: Char);
begin
 if key = #13 then
   begin
     if (JsEdit1.Text <> '') then
       begin
         dm.IBselect.Close;
         dm.IBselect.SQL.Clear;
         dm.IBselect.SQL.Add('select codhis, historico, saida as valor, codmov from caixa where documento = :doc');
         dm.IBselect.ParamByName('doc').AsString := JsEdit1.Text;
         dm.IBselect.Open;

         if not dm.IBselect.IsEmpty then
           begin
             JsEditInteiro2.Text := dm.IBselect.fieldbyname('codhis').AsString;
             JsEdit2.Text        := dm.IBselect.fieldbyname('historico').AsString;
             JsEditNumero2.Text  := formataCurrency(dm.IBselect.fieldbyname('valor').AsCurrency);
             codMov              := dm.IBselect.fieldbyname('codmov').AsString;
           end;

         dm.IBselect.Close;  
       end;

     if (JsEdit1.Text = '') then
       begin
         JsEdit1.Text := funcoes.novocod('cpagar');
         exit;
       end;
   end;

end;

procedure TMovcaixalanc.JsEditInteiro2KeyPress(Sender: TObject; var Key: Char);
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
    localizaHis := funcoes.localizar('Localizar Histórico','hiscaixa','cod,grupo','cod,grupo','','grupo','grupo',false,false,false,'',0,sender);
    TEdit(Sender).Text := copy(localizaHis,1,pos('-',localizaHis)-1);
    nomehis.Caption:= copy(localizaHis,pos('-',localizaHis)+1,length(localizaHis)) ;
  end;

end;

procedure TMovcaixalanc.JsBotao1Click(Sender: TObject);
begin
 if jsedit1.Text = '' then JsEdit1.Text := funcoes.novocod('cpagar'); 

 dm.IBQuery3.Close;
 dm.IBQuery3.SQL.Clear;
 dm.IBQuery3.SQL.Add('update or insert into caixa( usuario,formpagto,codgru ,  CODMOV, data, vencimento, datamov,documento,' +
 'codhis,historico,entrada,saida)          values(:usuario, :forma  ,:codgru, :CODMOV,:data,:vencimento,:datamov,:documento,:codhis,:historico,:entrada,:saida)' +
 ' matching (codmov)');
 dm.IBQuery3.ParamByName('usuario').AsString      := form22.codusario;
 dm.IBQuery3.ParamByName('forma').AsString        := '1';
 dm.IBQuery3.ParamByName('codgru').AsString       := JsEdit3.Text;
 if codMov = '' then codMov := funcoes.novocod('movcaixa');
 dm.IBQuery3.ParamByName('CODMOV').AsString       := codMov;
 codMov            := '';
 dm.IBQuery3.ParamByName('data').AsDateTime       := StrToDate(JsEditData1.Text) + TimeOf(now);
 dm.IBQuery3.ParamByName('vencimento').AsDateTime := StrToDate(JsEditData1.Text);
 dm.IBQuery3.ParamByName('datamov').AsDateTime    := form22.datamov;
 dm.IBQuery3.ParamByName('documento').AsString    := JsEdit1.Text;
 dm.IBQuery3.ParamByName('codhis').AsString       := JsEditInteiro2.Text;
 dm.IBQuery3.ParamByName('historico').AsString    := JsEdit2.Text;
 dm.IBQuery3.ParamByName('entrada').AsCurrency    := JsEditNumero1.getValor;
 dm.IBQuery3.ParamByName('saida').AsCurrency      := JsEditNumero2.getValor;;

try
 dm.IBQuery3.ExecSQL;
 dm.IBQuery3.Transaction.Commit;

 ClientDataSet1.Open;
 ClientDataSet1.Insert;
 //select codgru as grupo,vencimento,documento,codhis as codhis,historico,entrada,saida
 ClientDataSet1.FieldByName('grupo').AsString        := JsEdit3.Text;
 ClientDataSet1.FieldByName('vencimento').AsDateTime := StrToDate(JsEditData1.Text) + TimeOf(now);
 ClientDataSet1.FieldByName('documento').AsString    := JsEdit1.Text;
 ClientDataSet1.FieldByName('codhis').AsString       := JsEditInteiro2.Text;
 ClientDataSet1.FieldByName('historico').AsString    := JsEdit2.Text;
 ClientDataSet1.FieldByName('entrada').AsCurrency    := JsEditNumero1.getValor;
 ClientDataSet1.FieldByName('saida').AsCurrency      := JsEditNumero2.getValor;
 ClientDataSet1.Post;

except
 JsEditNumero1.SetFocus;
end;

 nomegrupo.Caption := '';
 nomehis.Caption   := '';
 codMov            := '';

 JsEdit3.LimpaCampos(self.Name);
 JsEditData1.Text := FormatDateTime('dd/mm/yyyy',form22.datamov);
end;

procedure TMovcaixalanc.FormShow(Sender: TObject);
begin
 dm.IBselect.SQL.Clear;
 dm.IBselect.SQL.Add('select codgru as grupo,vencimento,documento,codhis as codhis,historico,entrada,saida from caixa where (cast(data as date) = :data) ');
 dm.IBselect.ParamByName('data').AsDateTime:= funcoes.PreparaData(FormatDateTime('dd/mm/yyyy',form22.datamov));
 dm.IBselect.Open;

 funcoes.Ibquery_to_clienteDataSet(dm.ibselect,clientdataset1);
 funcoes.FormataCampos(tibquery(ClientDataSet1),2,'',2);
 dm.IBselect.Close;
 //funcoes.FormataCampos((clientdataset1),2,'',2);
 JsEditData1.Text:= FormatDateTime('dd/mm/yyyy',form22.datamov);

 codMov := '';
end;

procedure TMovcaixalanc.JsEditNumero1KeyPress(Sender: TObject; var Key: Char);
begin
  if (key=#13) and (StrToCurr(funcoes.ConverteNumerico(JsEditNumero1.text))<>0) then
  begin
    key:=#0;
    JsBotao1.SetFocus;
  end;
end;

procedure TMovcaixalanc.JsEditNumero2KeyPress(Sender: TObject;
  var Key: Char);
begin
 if (key=#13) and ((JsEditNumero1.Text='0,00') and (JsEditNumero2.Text='0,00')) then key:=#0;

end;

procedure TMovcaixalanc.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
dm.IBselect.Close;
dm.IBQuery1.Close;
JsEdit.LiberaMemoria(self);
end;

procedure TMovcaixalanc.JsEditData1KeyPress(Sender: TObject;
  var Key: Char);
begin
  if key = #13 then JsEdit1.SetFocus;
end;

end.
