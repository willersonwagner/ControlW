unit creceberbaixa;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, JsBotao1, ToolWin, ComCtrls, Grids, DBGrids,
  JsEditInteiro1, Mask, JsEditData1, JsEdit1, JsEditNumero1, ExtCtrls, DB,
  DBClient,ibquery;

type
  TForm30 = class(TForm)
    Panel1: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    GroupBox2: TGroupBox;
    nomegrupo: TLabel;
    GroupBox3: TGroupBox;
    nomehis: TLabel;
    ToolBar1: TPanel;
    info: TLabel;
    JsBotao1: JsBotao;
    ClientDataSet1: TClientDataSet;
    DataSource1: TDataSource;
    Label5: TLabel;
    cod: JsEditInteiro;
    codgru: JsEdit;
    vencimento: JsEditData;
    documento: JsEditInteiro;
    GroupBox1: TGroupBox;
    codhis: JsEditInteiro;
    historico: JsEdit;
    valor: JsEditNumero;
    DBGrid1: TDBGrid;
    JsBotao2: JsBotao;
    procedure FormShow(Sender: TObject);
    procedure documentoKeyPress(Sender: TObject; var Key: Char);
    procedure codgruKeyPress(Sender: TObject; var Key: Char);
    procedure JsBotao1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure codhisKeyPress(Sender: TObject; var Key: Char);
    procedure valorKeyPress(Sender: TObject; var Key: Char);
    procedure DBGrid1KeyPress(Sender: TObject; var Key: Char);
    procedure historicoEnter(Sender: TObject);
    procedure codKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure codKeyPress(Sender: TObject; var Key: Char);
    procedure FormCreate(Sender: TObject);
    procedure JsBotao2Click(Sender: TObject);
  private
    localizaHis,localizaGrupo,cliente,nota : string;
    function verificaCreceber() : boolean;
    { Private declarations }
  public
    perguntarParcelas : smallint;
    function verificaSe_e_deVenda() : boolean;
    { Public declarations }
  end;

var
  Form30: TForm30;

implementation

uses func, Unit1, principal;

{$R *.dfm}

procedure TForm30.FormShow(Sender: TObject);
begin
  jsedit.SetTabelaDoBd(self, 'contasreceber', dm.IBQuery1);

 dm.IBselect.SQL.Clear;
 dm.IBselect.SQL.Add('select cod,codgru as grupo,vencimento,documento,documento as nrdocumento,historico,total from contasreceber where (data = :data) and (pago=0)');
 dm.IBselect.ParamByName('data').AsDateTime := form22.datamov;
 dm.IBselect.Open;

 funcoes.Ibquery_to_clienteDataSet(dm.ibselect,clientdataset1);
 funcoes.FormataCampos(tibquery(ClientDataSet1),2,'',2);

 dm.IBselect.Close;
 codgru.Text := '1';
 dm.IBQuery2.SQL.Clear;
 dm.IBQuery2.SQL.Add('select grupo from grupodecaixa where cod = 1');
try
  dm.IBQuery2.Open;
  nomegrupo.Caption := dm.IBQuery2.fieldbyname('grupo').AsString;
  vencimento.Text := FormatDateTime('dd/mm/yyyy',form22.datamov);
  codhis.Text := '2';
  nomehis.Caption := 'REC. CONTA A PRAZO';
except
end;
  dm.IBQuery2.Close; 
end;

procedure TForm30.documentoKeyPress(Sender: TObject; var Key: Char);
begin
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
    cliente := funcoes.localizar('Localizar Cliente','cliente','cod,nome,telres,telcom,cnpj as cpfcnpj,bairro','cod,nome','','nome','nome',false,false,false,'',450,nil);
    TEdit(Sender).Text := copy(cliente,1,pos('-',cliente)-1);
  end;

if (TEdit(Sender).Text = '') and (key = #13) then key := #0;

if (TEdit(Sender).Text<>'') and (key=#13) then
  begin

    cliente := TEdit(Sender).Text + '-'+  funcoes.BuscaNomeBD(dm.ibquery1,'nome','cliente','where cod = '+tedit(sender).Text);
    if cliente = 'Desconhecido' then
      begin
        key := #0;
        Beep;
        WWMessage('Cliente Não Econtrado!',mtError,[mbok],clYellow,true,false,clRed);
      end;
  end;


end;

procedure TForm30.codgruKeyPress(Sender: TObject; var Key: Char);
begin
if (codgru.Text<>'') and  (key=#13) then
  begin
    dm.IBQuery1.SQL.Clear;
    dm.IBQuery1.SQL.Add('select grupo from grupodecaixa where cod=:cod');
    dm.IBQuery1.ParamByName('cod').AsString := StrNum(codgru.Text);
    try
    dm.IBQuery1.Open ;
    if dm.IBQuery1.FieldByName('grupo').AsString <> '' then nomegrupo.Caption:= dm.IBQuery1.FieldByName('grupo').AsString
      else
        begin
          nomegrupo.Caption:='NÃO ENCONTRADO';
          tedit(sender).SetFocus;
          key := #0;
          abort;
        end;
    except
     ShowMessage('Código Inválido!');
     key:=#0;
     codgru.SetFocus;
     codgru.SelectAll;
     abort;
    end;
     dm.IBQuery1.Close;
  end;

if (codgru.Text='') and  (key=#13) then
  begin
    localizaGrupo := funcoes.localizar('Localizar Grupo','grupodecaixa','cod,grupo','cod,grupo','cod','grupo','grupo',false,false,false,'',0,sender);
    codgru.Text := copy(localizaGrupo,1,pos('-',localizaGrupo)-1);
    nomegrupo.Caption:= copy(localizaGrupo,pos('-',localizaGrupo)+1,length(localizaGrupo)) ;
  end;


end;

procedure TForm30.JsBotao1Click(Sender: TObject);
var
  formpagto,datamov,parcelas,inicial,periodo,vendedor, cod1,
  vende : string;
  valorprestacao : currency;
  vencimento1 : tdatetime;
  i,cont : integer;

begin
  if not verificaCreceber() then exit;
  if verificaSe_e_deVenda then exit;

  if (perguntarParcelas = 1) and (StrToIntDef(cod.Text, 0) = 0) then
    begin
      parcelas := funcoes.dialogo('not',0,'1234567890'+#8,40,true,'',Application.Title,'Qual a Quantidade de Parcelas?','1');
      if parcelas = '*' then exit;

      periodo := funcoes.dialogo('not',0,'1234567890'+#8,40,true,'',Application.Title,'Qual o Período entre Parcelas?','30');
      if periodo = '*' then exit;

      inicial := funcoes.dialogo('not',0,'1234567890'+#8,40,true,'',Application.Title,'Qual a Parcela Inicial?','1');
      if inicial = '*' then exit;

      formpagto := funcoes.LerFormPato(1,'',true);
      if formpagto = '*' then exit;

      datamov := funcoes.dialogo('data',0,'',0,true,'',Application.Title,'Confirme a Data de Movimento:',formatadataddmmyy(form22.datamov));
      if datamov = '*' then exit;

      vendedor := funcoes.dialogo('generico',0,'1234567890'+#8,50,false,'',Application.Title,'Qual o Vendedor?',form22.Pgerais.Values['codvendedor']);
      if vendedor = '*' then exit;

      valorprestacao := Arredonda(valor.getValor, 2);
      vencimento1     := StrToDate(vencimento.Text);

      for i := StrToInt(inicial) to StrToInt(parcelas) do
        begin
          cod1 := funcoes.novocod('creceber');
          dm.IBQuery1.Close;
          dm.IBQuery1.SQL.Text := ('insert into contasreceber(codgru,cod,formpagto,datamov,vendedor,data,vencimento,documento,codhis,historico,total,nota,valor) values(:codgru,:cod,:form,:datamov,:vend,:data,:vencimento,:documento,:codhis,:hist,:total,0,:valor)');
          dm.IBQuery1.ParamByName('codgru').AsString    := StrNum(codgru.Text);
          dm.IBQuery1.ParamByName('cod').AsString       := cod1;
          dm.IBQuery1.ParamByName('form').AsInteger     := StrToInt(StrNum(formpagto));
          dm.IBQuery1.ParamByName('datamov').AsDateTime := StrToDate(datamov);
          dm.IBQuery1.ParamByName('vend').AsString      := StrNum(vendedor);

          {if i = 1 then
            begin
              ShowMessage('iu=' + IntToStr(i));

              dm.IBQuery1.ParamByName('vencimento').AsDateTime := vencimento1;
              dm.IBQuery1.ParamByName('data').AsDateTime       := form22.datamov;
            end
          else }
          if i > 1 then begin
              if StrToInt(periodo) = 30 then vencimento1 := IncMonth(vencimento1)
                else vencimento1 := vencimento1 + StrToInt(periodo);
          end;

          dm.IBQuery1.ParamByName('data').AsDateTime:= form22.datamov;
          dm.IBQuery1.ParamByName('vencimento').AsDateTime := vencimento1;

          dm.IBQuery1.ParamByName('documento').AsString := StrNum(documento.Text);
          dm.IBQuery1.ParamByName('codhis').AsString    := StrNum(codhis.Text);
          dm.IBQuery1.ParamByName('hist').AsString      := funcoes.CompletaOuRepete(copy(historico.Text,1,30),funcoes.CompletaOuRepete('',IntToStr(i),' ',2)+'/'+funcoes.CompletaOuRepete('',parcelas,' ',2),' ',35);
          dm.IBQuery1.ParamByName('total').AsCurrency   := valorprestacao;
          dm.IBQuery1.ParamByName('valor').AsCurrency   := valorprestacao;
          dm.IBQuery1.ExecSQL;

          ClientDataSet1.Open;
          ClientDataSet1.Insert;
          ClientDataSet1.FieldByName('cod').AsInteger         := StrToInt(StrNum(cod1));
          ClientDataSet1.FieldByName('grupo').AsString        := StrNum(codgru.Text);
          ClientDataSet1.FieldByName('vencimento').AsDateTime := vencimento1;
          ClientDataSet1.FieldByName('documento').AsString    := StrNum(documento.Text);
          ClientDataSet1.FieldByName('historico').AsString    := funcoes.CompletaOuRepete(copy(historico.Text,1,30),funcoes.CompletaOuRepete('',IntToStr(i),' ',2)+'/'+funcoes.CompletaOuRepete('',parcelas,' ',2),' ',35);
          ClientDataSet1.FieldByName('total').AsCurrency      := valorprestacao;

          ClientDataSet1.Post;
        end;

        if dm.IBQuery1.Transaction.InTransaction then dm.IBQuery1.Transaction.Commit;
        jsedit.LimpaCampos(self.Name);
      exit;
    end;

  cod1 := cod.Text;
  if cod1 = '0' then cod1 := Incrementa_Generator('creceber', 1);

  vende := funcoes.dialogo('normal',0,'1234567890'+#8,50,true,'',Application.Title,'Qual o Vendedor?',form22.codusario);
  if vende = '*' then exit;
  formpagto := funcoes.LerFormPato(1,'',true);
  if formpagto = '*' then exit;
  datamov := funcoes.dialogo('data',0,'',0,true,'',Application.Title,'Confirme a Data de Movimento:',formatadataddmmyy(form22.datamov));
  if datamov = '*' then exit;
  dm.IBQuery1.Close;
  dm.IBQuery1.SQL.Text :=('update or insert into contasreceber(codgru,cod,formpagto,datamov,vendedor,data,vencimento,documento,codhis,historico,total,valor,nota) values('+StrNum(codgru.Text)+',:cod,:form,:datamov,:vendedor,:data,:vencimento,'+StrNum(documento.Text)+','+StrNum(codhis.Text)+',:his,:total,:valor,0) matching(cod)');
  try
    dm.IBQuery1.ParamByName('cod').Asinteger := strtoint(cod1);
    dm.IBQuery1.ParamByName('form').AsString:= formpagto;
    dm.IBQuery1.ParamByName('datamov').AsDateTime := StrToDate(datamov);
    dm.IBQuery1.ParamByName('vendedor').AsString := vende;
    dm.IBQuery1.ParamByName('data').AsDateTime := form22.datamov;
    dm.IBQuery1.ParamByName('vencimento').AsDateTime := StrToDate(vencimento.Text);
    dm.IBQuery1.ParamByName('his').AsString :=  funcoes.CompletaOuRepete(copy(historico.Text,1,28),'1/ 1' ,' ',35);
    dm.IBQuery1.ParamByName('total').AsCurrency := valor.getValor;
    dm.IBQuery1.ParamByName('valor').AsCurrency := valor.getValor;
  except
    on e:exception do
      begin
        dm.IBQuery1.Close;
        ShowMessage('Ocorreu um Erro de Conversão, Verifique os Campos se estão preechidos corretamente.' + #13 + e.Message);
        exit
      end;
  end;

 try
   dm.IBQuery1.ExecSQL;
   dm.IBQuery1.Transaction.Commit;
   nota := '';
   //'select codgru as grupo,vencimento,documento,documento as nrdocumento,historico,total
   ClientDataSet1.Open;
   ClientDataSet1.Insert;
   ClientDataSet1.FieldByName('cod').AsString          := cod1;
   ClientDataSet1.FieldByName('grupo').AsString        := codgru.Text;
   ClientDataSet1.FieldByName('vencimento').AsDateTime := StrToDate(vencimento.Text);
   ClientDataSet1.FieldByName('documento').AsString    := documento.Text;
   ClientDataSet1.FieldByName('historico').AsString    := funcoes.CompletaOuRepete(copy(historico.Text,1,28),'1/ 1' ,' ',35);
   ClientDataSet1.FieldByName('total').AsCurrency      := valor.getValor;

   ClientDataSet1.Post;
 except
   on e:exception do
     begin
       dm.IBQuery1.Transaction.Rollback;
       ShowMessage('Ocorreu um Erro. Tente Novamente' + #13 + e.Message);
       JsBotao1.SetFocus;
     end;
 end;

 jsedit.LimpaCampos(self.Name);
end;

procedure TForm30.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  JsEdit.LiberaMemoria(self);

  dm.IBselect.Close;
  dm.IBQuery1.Close;
  dm.IBQuery2.Close;

end;

procedure TForm30.codhisKeyPress(Sender: TObject; var Key: Char);
begin
if (codhis.Text<>'') and  (key=#13) then
  begin
    dm.IBQuery1.SQL.Clear;
    dm.IBQuery1.SQL.Add('select grupo from hiscaixa where cod=:cod');
    dm.IBQuery1.Parambyname('cod').asstring := StrNum(codhis.Text);
    try
    dm.IBQuery1.Open
    except
    end;
    if dm.IBQuery1.FieldByName('grupo').AsString<>'' then nomehis.Caption:= dm.IBQuery1.FieldByName('grupo').AsString
      else
        begin
          nomehis.Caption:='NÃO ENCONTRADO';
          key := #0;
          tedit(sender).SetFocus;
        end;
    dm.IBQuery1.Close;
   end;


if (codhis.Text='') and  (key=#13) then
  begin
    localizaHis:= funcoes.localizar('Localizar Histórico','hiscaixa','cod,grupo','cod,grupo','cod','grupo','grupo',false,false,false,'',0,sender);
    TEdit(Sender).Text := copy(localizaHis,1,pos('-',localizaHis)-1);
    nomehis.Caption:= copy(localizaHis,pos('-',localizaHis)+1,length(localizaHis)) ;
  end;

end;

procedure TForm30.valorKeyPress(Sender: TObject; var Key: Char);
begin
if (key = #13) and not(StrToFloat(funcoes.ConverteNumerico(tedit(sender).Text)) > 0) then key := #0;
end;

procedure TForm30.DBGrid1KeyPress(Sender: TObject; var Key: Char);
begin
  if key = #27 then cod.SetFocus;
end;

procedure TForm30.historicoEnter(Sender: TObject);
begin
  if (copy(cliente, 1, historico.MaxLength) <> '') and (historico.Text = '') then historico.Text := copy(cliente, 1, historico.MaxLength);
end;

function TForm30.verificaCreceber() : boolean;
begin
  Result := false;

  if CODGRU.Text = '' then
    begin
      ShowMessage('Grupo Vazio');
      CODGRU.SetFocus;
      exit;
    end;

  if documento.Text = '' then
    begin
      ShowMessage('Cliente Vazio');
      documento.SetFocus;
      exit;
    end;

  if codhis.Text = '' then
    begin
      ShowMessage('Codigo de Histórico Vazio');
      codhis.SetFocus;
      exit;
    end;

  if historico.Text = '' then
    begin
      ShowMessage('Histórico Vazio');
      historico.SetFocus;
      exit;
    end;

  if valor.getValor = 0 then
    begin
      ShowMessage('Preencha Valor');
      valor.SetFocus;
      exit;
    end;

  Result := true;  
end;

procedure TForm30.codKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key = 116 then
    begin
      tedit(sender).Text := funcoes.localizar('Localizar Contas a Receber','contasreceber','codgru as grupo,vencimento,documento,codhis as nrdocumento,historico,total,cod','cod','cod','historico','vencimento',true,false,false,' where (pago = 0) ',500,sender);
    end;
end;

procedure TForm30.codKeyPress(Sender: TObject; var Key: Char);
begin
  IF KEY = #27 then close;
end;

procedure TForm30.FormCreate(Sender: TObject);
begin
  perguntarParcelas := 0;
end;

procedure TForm30.JsBotao2Click(Sender: TObject);
var
  cont : integer;
begin
  if cod.Text = '0' then
    begin
      MessageDlg('Informe um Código de Conta a Receber!', mtInformation, [mbOK], 1);
      if cod.Enabled then cod.SetFocus;
      exit;
    end;

  dm.IBselect.Close;
  dm.IBselect.SQL.Text := 'select * from contasreceber where cod = :cod';
  dm.IBselect.ParamByName('cod').AsString := StrNum(cod.Text);
  dm.IBselect.Open;
  dm.IBselect.FetchAll;

  cont := dm.IBselect.RecordCount;

  if dm.IBselect.IsEmpty then
    begin
      dm.IBselect.Close;
      MessageDlg('Não Existe Conta com Esse Código: ' + cod.Text, mtInformation, [mbOK], 1);
      if cod.Enabled then cod.SetFocus;
      exit;
    end;

  if dm.IBselect.FieldByName('nota').AsInteger > 0 then
    begin
      MessageDlg('Esta Conta Não Pode Ser Excluída: ' + cod.Text + #13 +
      'Venda: ' + dm.IBselect.fieldbyname('nota').AsString, mtInformation, [mbOK], 1);
      if cod.Enabled then cod.SetFocus;
      dm.IBselect.Close;
      exit;
    end;

  if MessageDlg('Foram Encontradas ' + IntToStr(cont) + ' Vendas com o Código: ' + cod.Text +
  #13 + 'Tem Certeza que Desaja Excluir ?', mtInformation, [mbYes, mbNo], 1) = idno then exit;

  dm.IBQuery1.Close;
  dm.IBQuery1.SQL.Text := 'delete from contasreceber where cod = :cod';
  dm.IBQuery1.ParamByName('cod').AsString := StrNum(cod.Text);
  dm.IBQuery1.ExecSQL;
  if dm.IBQuery1.Transaction.InTransaction then dm.IBQuery1.Transaction.Commit;

  dm.IBselect.Close;


  jsedit.LimpaCampos(self.Name);
  cod.SetFocus;
end;

function TForm30.verificaSe_e_deVenda() : boolean;
begin
  Result := false;
  if cod.Text = '0' then
    begin
      exit;
    end;

  dm.IBselect.Close;
  dm.IBselect.SQL.Text := 'select * from contasreceber where cod = :cod';
  dm.IBselect.ParamByName('cod').AsString := StrNum(cod.Text);
  dm.IBselect.Open;
  dm.IBselect.FetchAll;

  cont := dm.IBselect.RecordCount;

  if dm.IBselect.IsEmpty then
    begin
      dm.IBselect.Close;
      MessageDlg('Não Existe Conta com Esse Código: ' + cod.Text, mtInformation, [mbOK], 1);
      if cod.Enabled then cod.SetFocus;
      exit;
    end;

  if dm.IBselect.FieldByName('nota').AsInteger > 0 then begin
      MessageDlg('Por Motivo de Segurança esta conta não pode ser Alterada: ' + cod.Text + #13 +
      'Venda: ' + dm.IBselect.fieldbyname('nota').AsString + #13 +
      'O procedimento correto é efetuar o cancelamento da Venda.', mtInformation, [mbOK], 1);
      if cod.Enabled then cod.SetFocus;
      dm.IBselect.Close;
      Result := true;
      exit;
    end;

 // if MessageDlg('Foram Encontradas ' + IntToStr(cont) + ' Vendas com o Código: ' + cod.Text +
 // #13 + 'Tem Certeza que Desaja Excluir ?', mtInformation, [mbYes, mbNo], 1) = idno then exit;
end;

end.
