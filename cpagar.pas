unit cpagar;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, JsEditNumero1, StdCtrls, Mask, JsEditData1, JsEdit1,
  JsEditInteiro1, Grids, DBGrids, Buttons, JsBotao1, ToolWin, ComCtrls,
  ExtCtrls, DB, IBCustomDataSet, IBQuery;

type
  TForm27 = class(TForm)
    Panel1: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    JsEdit3: JsEdit;
    JsEditData1: JsEditData;
    JsEdit1: JsEdit;
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
    JsBotao1: JsBotao;
    info: TLabel;
    DataSource1: TDataSource;
    IBQuery1: TIBQuery;
    procedure JsEditInteiro1KeyPress(Sender: TObject; var Key: Char);
    procedure JsEdit1KeyPress(Sender: TObject; var Key: Char);
    procedure JsEditInteiro2KeyPress(Sender: TObject; var Key: Char);
    procedure JsBotao1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure JsEdit3KeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure JsEdit3Enter(Sender: TObject);
    procedure JsEditNumero1KeyPress(Sender: TObject; var Key: Char);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure DBGrid1KeyPress(Sender: TObject; var Key: Char);
    procedure JsEdit2KeyPress(Sender: TObject; var Key: Char);
  private
    procedure buscaConta(const cod : String);
    procedure abreDataSet();
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form27: TForm27;
  localizaGrupo:string;
  localizaHis:string;

implementation

uses func, Unit1, localizar, principal;

{$R *.dfm}

procedure TForm27.JsEditInteiro1KeyPress(Sender: TObject; var Key: Char);
begin
if not funcoes.Contido(key,'2345678901'+#8+#13+#27) then key := #0;
if key=#27 then close;
if (JsEdit3.Text='') and  (key=#13) then
  begin
    localizaGrupo := funcoes.localizar('Localizar Grupo','grupodecaixa','cod,grupo','cod,grupo','','grupo','grupo',false,false,false,'',0,sender);
    JsEdit3.Text := copy(localizaGrupo,1,pos('-',localizaGrupo)-1);
    nomegrupo.Caption:= copy(localizaGrupo,pos('-',localizaGrupo)+1,length(localizaGrupo)) ;
  end;
if (JsEdit3.Text<>'') and  (key=#13) then
  begin
    dm.IBQuery1.SQL.Clear;
    dm.IBQuery1.SQL.Add('select grupo from grupodecaixa where cod=:cod');
    dm.IBQuery1.ParamByName('cod').AsString := JsEdit3.Text;
    try
    dm.IBQuery1.Open ;
    if dm.IBQuery1.FieldByName('grupo').AsString<>'' then nomegrupo.Caption:= dm.IBQuery1.FieldByName('grupo').AsString
      else
        begin
          nomegrupo.Caption:='NÃO ENCONTRADO';
          key := #0 ;
        end;
    except
     ShowMessage('Código Inválido!');
     key:=#0;
     JsEdit3.SetFocus;
     JsEdit3.SelectAll;
    end;
     dm.IBQuery1.Close;
  end;
  if (tedit(sender).Text = '') and (key = #13) then key := #0;
end;

procedure TForm27.JsEdit1KeyPress(Sender: TObject; var Key: Char);
begin
 if (key=#13) then
   begin
     if (JsEdit1.Text = '') then
       begin
         JsEdit1.Text := funcoes.novocod('cpagar');
         //JsEdit1.Text := IntToStr(StrToIntDef(Incrementa_Generator('cpagar', 0),1) + 1);
       end;

     buscaConta(JsEdit1.Text);
   end;

end;

procedure TForm27.JsEditInteiro2KeyPress(Sender: TObject; var Key: Char);
begin
if (JsEditInteiro2.Text<>'') and  (key=#13) then
  begin
    dm.IBQuery1.SQL.Clear;
    dm.IBQuery1.SQL.Add('select grupo from hiscaixa where cod = '+JsEditInteiro2.Text);
    try
    dm.IBQuery1.Open
    except
    end;
    if dm.IBQuery1.FieldByName('grupo').AsString<>'' then nomehis.Caption:= dm.IBQuery1.FieldByName('grupo').AsString
      else
        begin
          nomehis.Caption:='NÃO ENCONTRADO';
          key := #0;
        end;
    dm.IBQuery1.Close;
   end;

if (JsEditInteiro2.Text = '') and  (key=#13) then
  begin
    localizaHis:= funcoes.localizar('Localizar Histórico','hiscaixa','cod,grupo','cod,grupo','','grupo','grupo',false,false,false,'',0,sender);
    TEdit(Sender).Text := copy(localizaHis,1,pos('-',localizaHis)-1);
    nomehis.Caption:= copy(localizaHis,pos('-',localizaHis)+1,length(localizaHis)) ;
  end;
if (JsEditInteiro2.Text = '') and  (key=#13) then key := #0;
end;

procedure TForm27.JsBotao1Click(Sender: TObject);
begin
 dm.IBQuery1.Close;
 dm.IBQuery1.SQL.Text := ('update or insert into contaspagar(codgru,data,vencimento,documento,codhis,historico,total,pago,valor)'+
 //' values(:codgru,:data,:vencimento,'+StrNum(Incrementa_Generator('cpagar', 1))+',:codhis,:historico,:total,0,:valor) matching(documento)');
 ' values(:codgru,:data,:vencimento,:documento,:codhis,:historico,:total,0,:valor) matching(documento)');
 dm.IBQuery1.ParamByName('codgru').AsString       := StrNum(JsEdit3.Text);
 dm.IBQuery1.ParamByName('data').AsDateTime       := form22.datamov;
 dm.IBQuery1.ParamByName('vencimento').AsDateTime := StrToDate(JsEditData1.Text);
 //dm.IBQuery1.ParamByName('documento').AsString    := StrNum(Incrementa_Generator('cpagar', 1));
 dm.IBQuery1.ParamByName('documento').AsString    := StrNum(JsEdit1.Text);
 dm.IBQuery1.ParamByName('codhis').AsString       := StrNum(JsEditInteiro2.Text);
 dm.IBQuery1.ParamByName('historico').AsString    := JsEdit2.Text;
 dm.IBQuery1.ParamByName('total').AsCurrency      := JsEditNumero1.getValor;
 dm.IBQuery1.ParamByName('valor').AsCurrency      := dm.IBQuery1.ParamByName('total').AsCurrency;
 try
 dm.IBQuery1.ExecSQL;
 dm.IBQuery1.Transaction.Commit;

 DBGrid1.DataSource.DataSet.Close;
 DBGrid1.DataSource.DataSet.Open;
 except
   JsEditNumero1.SetFocus;
 end;
 
 abreDataSet;
 
 nomegrupo.Caption:='';
 nomehis.Caption:='';

 JsEdit3.LimpaCampos(self.Name);
end;

procedure TForm27.FormShow(Sender: TObject);
begin
 abreDataSet;
end;

procedure TForm27.JsEdit3KeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
 {if key=119 then
 begin
   funcoes.localizar('Localizar Contas a Pagar','contaspagar','codgru as grupo,vencimento,documento,codhis as nrdocumento,historico,total','','','historico','data',true,true,true,'where pago=0',500,sender);
 end;}
end;

procedure TForm27.FormClose(Sender: TObject; var Action: TCloseAction);
begin
JsEdit1.LiberaMemoria(self);
dm.IBselect.Close;
dm.IBQuery1.Close;
end;

procedure TForm27.JsEdit3Enter(Sender: TObject);
begin
 dm.IBselect.Open;
end;

procedure TForm27.JsEditNumero1KeyPress(Sender: TObject; var Key: Char);
begin
if (key = #13) and (StrToFloat(funcoes.ConverteNumerico(tedit(sender).Text)) = 0 ) then key := #0;
end;

procedure TForm27.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  cod : String;
begin
  if (key = 116) and (not DBGrid1.Focused) then DBGrid1.SetFocus;
  if key=119 then
    begin
      cod := funcoes.localizar('Localizar Contas a Pagar','contaspagar','codgru as grupo,vencimento,documento,codhis as nrdocumento,historico,total','documento','documento','historico','data',true,true,true,'where pago=0',500,sender);
      if StrNum(cod) <> '0' then
        begin
          buscaConta(cod);
          JsEdit1.Text := cod;
          JsEdit1.SetFocus;
        end;
    end;
end;

procedure TForm27.DBGrid1KeyPress(Sender: TObject; var Key: Char);
begin
if key = #27 then JsEdit3.SetFocus;
end;

procedure TForm27.JsEdit2KeyPress(Sender: TObject; var Key: Char);
begin
  if ((Key = #13) and (JsEdit2.Text = '') and (JsEditInteiro2.Text = '101')) then
    begin
      JsEdit2.Text := copy(funcoes.localizar('Localizar Fornecedores','fornecedor','cod, nome','nome','','nome','nome',false,false,false,'',0,sender), 1, 35);
    end;
end;

procedure TForm27.buscaConta(const cod : String);
begin
  if cod = '' then exit;

  dm.IBQuery4.Close;
  dm.IBQuery4.SQL.Text := 'select vencimento,codgru,historico, valor, codhis from contaspagar where documento = :cod';
  dm.IBQuery4.ParamByName('cod').AsString := StrNum(cod);
  dm.IBQuery4.Open;

  if dm.IBQuery4.IsEmpty then
    begin
      dm.IBQuery4.Close;
      exit;
    end;

  JsEditInteiro2.Text := dm.IBQuery4.fieldbyname('codhis').AsString;
  JsEdit2.Text        := dm.IBQuery4.fieldbyname('historico').AsString;
  JsEdit3.Text        := dm.IBQuery4.fieldbyname('codgru').AsString;
  JsEditData1.Text    := dm.IBQuery4.fieldbyname('vencimento').AsString;
  JsEditNumero1.setValor(dm.IBQuery4.fieldbyname('valor').AsCurrency);
  dm.IBQuery4.Close;
  abreDataSet;
end;

procedure TForm27.abreDataSet();
begin
  DBGrid1.DataSource := DataSource1;

  IBQuery1.Close;
  IBQuery1.SQL.Text := ('select codgru as grupo,vencimento,documento,codhis as nrdocumento,historico,total from contaspagar where (data=:data) and (pago=0)');
  IBQuery1.ParamByName('data').AsDateTime:= form22.datamov;
  IBQuery1.Open;
end;

end.
