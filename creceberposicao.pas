unit creceberposicao;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls,IBQuery, Grids, DBGrids, DB, DBClient, Provider,
  DBCtrls, IBCustomDataSet, IBTable;

type
  TForm34 = class(TForm)
    DBGrid1: TDBGrid;
    Panel1: TPanel;
    cliente: TLabel;
    label4: TLabel;
    IBTable1: TIBTable;
    IBTable1CODGRU: TIntegerField;
    IBTable1DOCUMENTO: TIntegerField;
    IBTable1VENCIMENTO: TDateField;
    IBTable1TOTAL: TIBBCDField;
    IBTable1CODHIS: TIntegerField;
    IBTable1HISTORICO: TIBStringField;
    IBTable1PAGO: TIBBCDField;
    IBTable1FORNEC: TIntegerField;
    IBTable1USUARIO: TIntegerField;
    IBTable1VENDEDOR: TIntegerField;
    IBTable1DATAMOV: TDateField;
    IBTable1FORMPAGTO: TSmallintField;
    IBTable1PREVISAO: TDateField;
    IBTable1VALOR: TIBBCDField;
    IBTable1CONT: TSmallintField;
    IBTable1DATA: TDateField;
    IBTable1COD: TIntegerField;
    IBTable1ValorCalc: TCurrencyField;
    DataSource1: TDataSource;
    Label1: TLabel;
    Label2: TLabel;
    Panel2: TPanel;
    Label3: TLabel;
    Label5: TLabel;
    total: TLabel;
    IBTable1SALDO: TIBBCDField;
    ClientDataSet1: TClientDataSet;
    procedure FormShow(Sender: TObject);
    procedure IBTable1CalcFields(DataSet: TDataSet);
    procedure DBGrid1DrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure DBGrid1KeyPress(Sender: TObject; var Key: Char);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure DBGrid1KeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure DBGrid1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
  public
   cont :  integer;
   juros,dias,saldo1 : currency;
   client1, formapagto:string;
   function geraSaldo : boolean;
   procedure geraRecibo();
   function verificaValorNegativo() : boolean;
   procedure copiaContasReceber(var query11 : TIBQuery);
   procedure baixaF10Antigo();
   procedure baixaF10Novo();
    { Public declarations }
  end;

var
  Form34: TForm34;


implementation

uses func, Unit1, principal, relatorio, imprime1, DateUtils, Math;

{$R *.dfm}

function TForm34.verificaValorNegativo() : boolean;
begin
  try
    Result := false;
    DBGrid1.DataSource.DataSet.DisableControls;
    DBGrid1.DataSource.DataSet.First;
    while not DBGrid1.DataSource.DataSet.Eof do
      begin
        If DBGrid1.DataSource.DataSet.FieldByName('valor').AsCurrency < 0 then
          begin
            Result := true;
            break;
          end;
        DBGrid1.DataSource.DataSet.Next;
      end;
  finally
    DBGrid1.DataSource.DataSet.First;
    DBGrid1.DataSource.DataSet.EnableControls;
  end;
end;

procedure TForm34.geraRecibo();
begin

end;


function tform34.geraSaldo : boolean;
begin
  IBTable1.DisableControls;
  IBTable1.First;
  saldo1 := 0;

  while not IBTable1.Eof do
    begin
      IBTable1.Edit;
      saldo1 := saldo1 + TIBQuery(IBTable1).fieldbyname('valorcalc').AsCurrency;
      IBTable1SALDO.AsCurrency := saldo1;
      IBTable1.Post;
      IBTable1.Next;
    end;
  try
   IBTable1.Transaction.Commit;
  except
   IBTable1.Transaction.Rollback;
  end;
  IBTable1.Active := true ;
  IBTable1.First;
  IBTable1.EnableControls;
  funcoes.FormataCampos(tibquery(IBTable1),2,'',2);
  Result := true;
end;

procedure TForm34.FormShow(Sender: TObject);
begin

if cont=1 then
begin
 IBTable1SALDO.Visible := false;

 Panel1.Visible := false;
 try
  total.Caption := CurrToStrF(funcoes.SomaCampoDBGRID(tibquery(ibtable1),'ValorCalc',0,0,0,''),ffnumber,2);
 except
 end;

// self.Height := Screen.Height - trunc(screen.Height * 0.15);

end;
if cont = 2 then
 begin
   //IBTable1.IndexName := 'CONTASRECEBER_IDX1';
   //geraSaldo();
   panel2.Visible := false;
   DBGrid1.DataSource.DataSet.First;
 end;
end;

procedure TForm34.IBTable1CalcFields(DataSet: TDataSet);
var
  d : real;
  i : integer;
  datamaior : TDateTime;
begin
if IBTable1DATA.AsDateTime>=IBTable1VENCIMENTO.AsDateTime then datamaior:=IBTable1DATA.AsDateTime
 else datamaior := IBTable1VENCIMENTO.AsDateTime;
 if cont = 1 then
   begin
    IBTable1ValorCalc.AsCurrency := IBTable1VALOR.AsCurrency
   end
else if cont = 2 then
 begin
    i:=0;
    if form22.datamov > datamaior then
      begin
        d := form22.datamov - datamaior;
        IBTable1ValorCalc.AsCurrency := IBTable1VALOR.AsCurrency + Arredonda((IBTable1VALOR.AsCurrency * (juros/100))*d,2);
      end
    else  IBTable1ValorCalc.AsCurrency := IBTable1VALOR.AsCurrency;
 end
else if cont=3 then IBTable1ValorCalc.AsCurrency :=IBTable1VALOR.AsCurrency;
end;

procedure TForm34.DBGrid1DrawColumnCell(Sender: TObject; const Rect: TRect;
  DataCol: Integer; Column: TColumn; State: TGridDrawState);
begin
if cont=1 then
begin
 if DBGrid1.DataSource.DataSet.RecNo mod 2 = 0 then
  begin
   Dbgrid1.Canvas.Font.Color := clDkGray;
   Dbgrid1.DefaultDrawDataCell(Rect, dbgrid1.columns[datacol].field, State);
  end;
end;
end;

procedure TForm34.DBGrid1KeyPress(Sender: TObject; var Key: Char);
var
   valorbaixado , sim, cod, fatura :string;
   i, a, c, lin            : integer;
   v1 , valorb             : currency;
   _LIQ                    : boolean;
begin
if cont = 1 then if (key=#27) or (key=#13) then close;
if cont = 2 then
begin
 if key = #32 then begin
   dm.IBselect.Close;
   dm.IBselect.SQL.Text := 'select valor from contasreceber where cod = :cod';
   dm.IBselect.ParamByName('cod').AsString := DBGrid1.DataSource.DataSet.FieldByName('cod').AsString;
   dm.IBselect.Open;

   funcoes.Mensagem('ControlW - Contas a Receber', 'Vencimento: ' + formataDataDDMMYY(DBGrid1.DataSource.DataSet.FieldByName('vencimento').AsDateTime) + #13 +
               'Valor:' + CompletaOuRepete('', formataCurrency(dm.IBselect.FieldByName('valor').AsCurrency), ' ', 14) + #13 +
               'Juros:' + CompletaOuRepete('', formataCurrency(DBGrid1.DataSource.DataSet.FieldByName('valor').AsCurrency - dm.IBselect.FieldByName('valor').AsCurrency), ' ', 14),14,'Courier New',true,0,clBlack, false);

   {ShowMessage('Vencimento: ' + formataDataDDMMYY(DBGrid1.DataSource.DataSet.FieldByName('vencimento').AsDateTime) + #13 +
               'Valor:' + CompletaOuRepete('', formataCurrency(dm.IBselect.FieldByName('valor').AsCurrency), ' ', 14) + #13 +
               'Juros:' + CompletaOuRepete('', formataCurrency(DBGrid1.DataSource.DataSet.FieldByName('valor').AsCurrency - dm.IBselect.FieldByName('valor').AsCurrency), ' ', 14));}
 end;

 if key=#27 then Close;

 if key = #13 then
      begin
        c := DBGrid1.DataSource.DataSet.RecNo-1;
        //loop para nao receber valor acima do valor da conta
        valorbaixado := '999999999';
        while StrToCurr(funcoes.ConverteNumerico(valorbaixado)) > DBGrid1.DataSource.DataSet.FieldByName('valor').AsCurrency do
          begin
            try
              valorBaixado := funcoes.ConverteNumerico(funcoes.dialogo('numero',0,'1234567890,.'+#8,2,false,'',Application.Title,'O Valor é R$ '+FormatCurr('#,###,##0.00',DBGrid1.DataSource.DataSet.FieldByName('valor').AsCurrency)+' .Qual o Valor a Ser Baixado?',FormatCurr('#,###,###0.00',DBGrid1.DataSource.DataSet.FieldByName('valor').AsCurrency)));
              if valorbaixado='*' then
                begin
                  break;
                  exit;
                end;
              //se for maior dá uma mensagem que excedeu o valor da conta
              if StrToCurr(funcoes.ConverteNumerico(valorbaixado))>DBGrid1.DataSource.DataSet.FieldByName('valor').AsCurrency then  ShowMessage('Valor Excedeu o Total da Conta!');
              if StrToCurr(valorBaixado) <= 0 then begin
                MessageDlg('Valor Inválido: ' + valorBaixado, mtInformation, [mbOK], 1);
                exit;
              end;

            except
              exit;
            end;
          end;

        try
          if (valorbaixado = '*') or (StrToCurr(valorbaixado) = 0) then exit;
        except
        end;

        if messageDlg('Confirma Baixa de R$ '+valorBaixado+' ?', mtConfirmation, [mbyes, mbNo], 0) = mrYes then sim := 'S'
          else sim := '*';
        //sim := funcoes.dialogo('generico',0,'SN',0,true,'S',Application.Title,'Confirma Baixa de R$ '+valorBaixado+' ?','') ;
        if sim = '*' then exit;
        if (sim = 'S') then
          begin
            formapagto := funcoes.LerFormPato(0,'Contas Receber', false);
            //if strnum(formapagto) = '0' then formapagto := '1';

            valorb := StrToCurr(funcoes.ConverteNumerico(valorbaixado));
            form19.RichEdit1.Clear;

            cod := DBGrid1.DataSource.DataSet.FieldByName('cod').AsString;
            v1 := DBGrid1.DataSource.DataSet.FieldByName('valor').AsCurrency;
            lin := 0;


            if ((Form22.Pgerais.Values['nota'] = 'T') or (Form22.Pgerais.Values['nota'] = 'D')) then
              begin
                form19.RichEdit1.Clear;
                form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar(#13+#10+#15)));
                form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar(funcoes.CompletaOuRepete('+','+','-',40)+#13+#10)));
                form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar('|'+funcoes.centraliza(UpperCase(funcoes.LerValorPGerais('empresa',form22.Pgerais)),' ',38)+'|'+#13+#10)));
                form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar(funcoes.CompletaOuRepete('|','|','-',40)+#13+#10)));
                form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar(funcoes.CompletaOuRepete('|DATA: '+FormatDateTime('dd/mm/yy',form22.datamov)+'          HORA: '+FormatDateTime('tt',now),'|',' ',40)+#13+#10)));
                form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar(funcoes.CompletaOuRepete('+','+','-',40)+#13+#10)));
                form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar(funcoes.CompletaOuRepete('|RECIBO    Valor: '+FormatCurr('#,###,###0.00',valorb),' |',' ',40)+#13+#10)));
                form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar(funcoes.CompletaOuRepete('+','+','-',40)+#13+#10)));
                form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar(funcoes.CompletaOuRepete('|','|',' ',40)+#13+#10)));
                form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar(funcoes.CompletaOuRepete('|RECEBIDO DE:','|',' ',40)+#13+#10)));
                form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar(funcoes.CompletaOuRepete('|'+copy(DBGrid1.DataSource.DataSet.FieldByName('historico').AsString,pos('-',DBGrid1.DataSource.DataSet.FieldByName('historico').AsString)+1,
                length(DBGrid1.DataSource.DataSet.FieldByName('historico').AsString) - 8),'|',' ',40)+#13+#10)));
                form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar(funcoes.CompletaOuRepete('|','|',' ',40)+#13+#10)));
                form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar(funcoes.CompletaOuRepete('|A IMPORTANCIA DE R$ '+FormatCurr('#,###,###0.00',valorb),'|',' ',40)+#13+#10)));
                form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar(funcoes.CompletaOuRepete('|','|',' ',40)+#13+#10)));
                form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar(funcoes.CompletaOuRepete('|REFERENTE:','|',' ',40)+#13+#10)));
                form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar(funcoes.CompletaOuRepete('|','|',' ',40)+#13+#10)));
              end
            else
              begin
                {dm.IBQuery4.Close;
                dm.IBQuery4.SQL.Clear;
                dm.IBQuery4.SQL.Add('select * from registro');
                dm.IBQuery4.Open;

                form19.RichEdit1.Clear;
                addRelatorioForm19(funcoes.CompletaOuRepete('+', '+', '-', 52) + funcoes.CompletaOuRepete('', '+', '-', 18) + #13 + #10);
                addRelatorioForm19(funcoes.CompletaOuRepete('|' + funcoes.centraliza(form22.Pgerais.Values['empresa'], ' ', 50), '|', ' ', 52) + funcoes.CompletaOuRepete(funcoes.centraliza('R E C I B O', ' ', 16) , '|', ' ', 18) + #13 + #10);
                addRelatorioForm19(funcoes.CompletaOuRepete('|' + funcoes.centraliza(dm.IBQuery4.fieldbyname('ende').AsString + ' - ' + dm.IBQuery4.fieldbyname('bairro').AsString, ' ', 50), '|', ' ', 52) + funcoes.CompletaOuRepete(funcoes.centraliza('100', ' ', 16), '|', ' ', 18) + #13 + #10);
                addRelatorioForm19(funcoes.CompletaOuRepete('|' + funcoes.centraliza(dm.IBQuery4.fieldbyname('cnpj').AsString, ' ', 50), '|', ' ', 52) + funcoes.CompletaOuRepete('', '|', ' ', 18) + #13 + #10);                                                                        //funcoes.CompletaOuRepete(funcoes.centraliza('R$ ' + FormatDateTime('#,###,###0.00', valorb)
                addRelatorioForm19(funcoes.CompletaOuRepete('|' + funcoes.centraliza('Fone: ' + dm.IBQuery4.fieldbyname('telres').AsString + ' Fax: ' + dm.IBQuery4.fieldbyname('telcom').AsString, ' ', 50), '|', ' ', 52) + funcoes.CompletaOuRepete(funcoes.centraliza('R$ ' + FormatCurr('#,###,###0.00', valorb), ' ', 16), '|', ' ', 18) + #13 + #10);
                addRelatorioForm19(funcoes.CompletaOuRepete('+', '+', '-', 70) + #13 + #10);}

                dm.IBQuery2.Close;
                       fatura := funcoes.novocod('RECIBO_PAGA');

      dm.IBQuery2.Close;
      dm.IBQuery2.SQL.Text := ('select ende,bairro,cnpj,telres,telcom,cid,est from registro');
      dm.IBQuery2.Open;

      form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete(#218,'',#196,57)+funcoes.CompletaOuRepete(#194,#191,#196,21)+#13+#10))));
      form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete(#179+funcoes.centraliza(form22.Pgerais.Values['empresa'],' ',56),'',' ',57)+funcoes.CompletaOuRepete(#179+'   R E C I B O',#179,' ',21)+#13+#10))));
      form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete(#179+funcoes.centraliza(dm.IBQuery2.fieldbyname('ende').AsString+' - '+dm.IBQuery2.fieldbyname('bairro').AsString,' ',56),'',' ',57)+funcoes.CompletaOuRepete(#179+funcoes.centraliza( fatura,' ',19),#179,' ',21)+#13+#10))));
      form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete(#179+funcoes.centraliza('CNPJ: '+dm.IBQuery2.fieldbyname('cnpj').AsString,' ',56),'',' ',57)+funcoes.CompletaOuRepete(#179,#179,' ',21)+#13+#10))));
      form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete(#179+funcoes.centraliza('FONE: '+dm.IBQuery2.fieldbyname('TELRES').AsString+'   FAX: '+dm.IBQuery2.fieldbyname('TELCOM').AsString,' ',56),'',' ',57)+funcoes.CompletaOuRepete(#179+'R$:'+funcoes.CompletaOuRepete('',FormatCurr('#,###,###0.00', valorb),' ',15),#179,' ',21)+#13+#10))));
      form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete(#195,'',#196,12)+funcoes.CompletaOuRepete('','',#196,9)+funcoes.CompletaOuRepete('','',#196,6)+funcoes.CompletaOuRepete('','',#196,12)+funcoes.CompletaOuRepete('','',#196,12)+funcoes.CompletaOuRepete(''+#196+#196+#196+#196+#196+#196+#193,'',#196,9)+funcoes.CompletaOuRepete('','',#196,6)+funcoes.CompletaOuRepete('',#180,#196,12)+#13+#10))));


      {          addRelatorioForm19(funcoes.CompletaOuRepete('| RECEBEMOS DE ' + copy(IBTable1HISTORICO.AsString, pos('-', IBTable1HISTORICO.AsString) + 1, length(IBTable1HISTORICO.AsString) - 8),'COD.: ' + '100' + '|', ' ', 70) + #13 + #10);
                addRelatorioForm19(funcoes.CompletaOuRepete('+', '+', '-', 70) + #13 + #10);
                addRelatorioForm19(funcoes.CompletaOuRepete('| A IMPORTANCIA DE ' + UpperCase(funcoes.valorPorExtenso(valorb)) ,'|', ' ', 70) + #13 + #10);
                addRelatorioForm19(funcoes.CompletaOuRepete('|','|', ' ', 70) + #13 + #10);
                addRelatorioForm19(funcoes.CompletaOuRepete('| REFERENTE A:' ,'|', ' ', 70) + #13 + #10);}

                form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete(#179+' RECEBEMOS DE '+copy(DBGrid1.DataSource.DataSet.FieldByName('historico').AsString, pos('-', DBGrid1.DataSource.DataSet.FieldByName('historico').AsString) + 1,
                length(DBGrid1.DataSource.DataSet.FieldByName('historico').AsString) - 8),'COD.: ' +DBGrid1.DataSource.DataSet.FieldByName('documento').AsString+#179,' ',78)+#13+#10))));
      form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete(#179,#179,' ',78)+#13+#10))));
      funcoes.QuebraLinhas(#179,#179,' A IMPORTANCIA DE '+ UpperCase(funcoes.valorPorExtenso(valorb)), 78);
      form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete(#179,#179,' ',78)+#13+#10))));
      form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete(#179+' REFERENTE A: ',#179,' ',78)+#13+#10))));


              end;

            if StrToCurr(valorBaixado) = DBGrid1.DataSource.DataSet.FieldByName('valor').AsCurrency then
              begin
                dm.IBQuery2.Close;
                dm.IBQuery2.SQL.Clear;
                dm.IBQuery2.SQL.Add('update contasreceber set valor = :valor, pago = pago + :pago, datamov = :datamov where cod='+cod);
                dm.IBQuery2.ParamByName('valor').AsCurrency := DBGrid1.DataSource.DataSet.FieldByName('valor').AsCurrency - StrToCurr(funcoes.ConverteNumerico(valorBaixado));
                dm.IBQuery2.ParamByName('pago').AsCurrency  := StrToCurr(funcoes.ConverteNumerico(valorBaixado));
                dm.IBQuery2.ParamByName('datamov').AsDate   := form22.datamov;

                //dm.IBQuery2.ParamByName('data').AsDateTime := form22.datamov;
                try
                 dm.IBQuery2.ExecSQL;

                 if ((Form22.Pgerais.Values['nota'] = 'T') or (Form22.Pgerais.Values['nota'] = 'D')) then
                   begin
                     form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar(funcoes.CompletaOuRepete('|'+copy(DBGrid1.DataSource.DataSet.FieldByName('historico').AsString,1,18)+' '+copy(DBGrid1.DataSource.DataSet.FieldByName('historico').AsString,
                     length(DBGrid1.DataSource.DataSet.FieldByName('historico').AsString)-5,length(DBGrid1.DataSource.DataSet.FieldByName('historico').AsString)),
                     FormatCurr('#,###,###0.00',DBGrid1.DataSource.DataSet.FieldByName('valor').AsCurrency)+'|',' ',40)+#13+#10)));
                   end
                 else
                   begin
                     lin := lin + 1;
                     funcoes.QuebraLinhas(#179,#179,' '+FormatDateTime('dd/mm/yy', DBGrid1.DataSource.DataSet.FieldByName('vencimento').AsDateTime)+'  '+ DBGrid1.DataSource.DataSet.FieldByName('historico').AsString +'          '+FormatCurr('#,###,###0.00', valorb),78);
                     //addRelatorioForm19(funcoes.CompletaOuRepete('|' + FormatDateTime('dd/mm/yy', IBTable1DATA.AsDateTime) + ' ' + funcoes.CompletaOuRepete(IBTable1HISTORICO.AsString, FormatCurr('#,###,###0.00',IBTable1ValorCalc.AsCurrency), ' ', 50),'|', ' ', 70) + #13 + #10);
                   end;
                except
                end;
              end
            else if StrToCurr(valorBaixado) < DBGrid1.DataSource.DataSet.FieldByName('valor').AsCurrency then
              begin
              {  if MessageBox(Handle, 'Deseja Liquidar Esta Conta com Valor a Menor ?', pchar(Application.Title), MB_YESNO + MB_ICONQUESTION + MB_DEFBUTTON2) = idyes then _LIQ := true
                   else _LIQ := False;
               }

                _LIQ := false;
                dm.IBQuery2.Close;
                dm.IBQuery2.SQL.Clear;
                if _LIQ then
                  begin
                    {dm.IBQuery2.SQL.Add('update contasreceber set valor = :valor, pago = :pago where cod='+cod);
                    dm.IBQuery2.ParamByName('valor').AsCurrency := IBTable1ValorCalc.AsCurrency - StrToCurr(valorBaixado);
                    //dm.IBQuery2.ParamByName('data').AsDateTime  := form22.datamov;
                    dm.IBQuery2.ParamByName('pago').AsCurrency := IBTable1ValorCalc.AsCurrency - StrToCurr(funcoes.ConverteNumerico(valorBaixado));
                    dm.IBQuery2.ExecSQL;}
                    //dm.IBQuery2.Transaction.Commit;
                  end
                else
                  begin
                    dm.IBQuery2.SQL.Add('update contasreceber set valor = :valor, datamov = :datamov  where cod='+cod);
                    dm.IBQuery2.ParamByName('valor').AsCurrency := DBGrid1.DataSource.DataSet.FieldByName('valor').AsCurrency - StrToCurr(valorBaixado);
                    dm.IBQuery2.ParamByName('datamov').AsDate   := form22.datamov;
                    try
                      dm.IBQuery2.ExecSQL;
                    except
                      on e:exception do begin
                        dm.IBQuery2.Transaction.Rollback;
                        ShowMessage('Erro: ' + e.Message);
                        exit;
                      end;
                    end;
                  end;
                try

                  if ((Form22.Pgerais.Values['nota'] = 'T') or (Form22.Pgerais.Values['nota'] = 'D')) then
                    begin
                      form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar(funcoes.CompletaOuRepete('|'+copy(DBGrid1.DataSource.DataSet.FieldByName('historico').AsString,1,18)+' '+copy(DBGrid1.DataSource.DataSet.FieldByName('historico').AsString,
                      length(DBGrid1.DataSource.DataSet.FieldByName('historico').AsString)-5,length(DBGrid1.DataSource.DataSet.FieldByName('historico').AsString)),FormatCurr('#,###,###0.00',DBGrid1.DataSource.DataSet.FieldByName('valor').AsCurrency)+'|',' ',40)+#13+#10)));
                   end
                 else
                   begin
                     lin := lin + 1;
                     addRelatorioForm19(#179 +funcoes.CompletaOuRepete( FormatDateTime('dd/mm/yy', DBGrid1.DataSource.DataSet.FieldByName('vencimento').AsDateTime) + ' ' + funcoes.CompletaOuRepete(DBGrid1.DataSource.DataSet.FieldByName('historico').AsString, FormatCurr('#,###,###0.00',DBGrid1.DataSource.DataSet.FieldByName('valor').AsCurrency), ' ', 50),'', ' ', 76)+ #179 + #13 + #10);
                   end;
                except
                  on e:exception do begin
                     dm.IBQuery2.Transaction.Rollback;
                     ShowMessage('Erro Inesperado! Tente Novamente' + #13 + e.Message);
                    exit;
                  end;
                end;
              end;

            dm.IBQuery2.Close;
            dm.IBQuery2.SQL.text :=('insert into caixa(formpagto,codgru,codmov,codentradasaida,data,documento,vencimento,codhis,historico'+
            ',entrada,usuario, tipo, fornec) values (:pagto,'+DBGrid1.DataSource.DataSet.FieldByName('codgru').AsString+','+funcoes.novocod('movcaixa')+','+cod+',:data,'+DBGrid1.DataSource.DataSet.FieldByName('documento').AsString+',:venc,2,'+QuotedStr(DBGrid1.DataSource.DataSet.FieldByName('historico').AsString)+',:pago,'+form22.codusario+', ''R'', 1)');
            dm.IBQuery2.ParamByName('pagto').AsString  := strnum(formapagto);
            dm.IBQuery2.ParamByName('data').AsDateTime := DateOf(form22.datamov) + timeof(now);
            dm.IBQuery2.ParamByName('venc').AsDateTime := DBGrid1.DataSource.DataSet.FieldByName('vencimento').AsDateTime;
            dm.IBQuery2.ParamByName('pago').AsCurrency := StrToCurr(funcoes.ConverteNumerico(valorBaixado));

            try
              dm.IBQuery2.ExecSQL;
              dm.IBQuery2.Transaction.Commit;

              if ((Form22.Pgerais.Values['nota'] = 'T') or (Form22.Pgerais.Values['nota'] = 'D')) then
                begin
                  form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar(funcoes.CompletaOuRepete('+','+','-',40)+ #13 + #10)));
               end
              else
                begin
                  dm.IBQuery2.Close;
                  dm.IBQuery2.SQL.Text := ('select ende,bairro,cnpj,telres,telcom,cid,est from registro');
                  dm.IBQuery2.Open;

                  form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete(#179,#179,' ',78)+#13+#10))));
      form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete(#179,#179,' ',78)+#13+#10))));
      form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete(#179,#179,' ',78)+#13+#10))));
      form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete(#179,#179,' ',78)+#13+#10))));
      form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete(#179,#179,' ',78)+#13+#10))));
      form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete(#179,#179,' ',78)+#13+#10))));
      form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete(#179,#179,' ',78)+#13+#10))));
      form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete(#195,#194,#196,30)+funcoes.CompletaOuRepete('',#194,#196,15)+funcoes.CompletaOuRepete('',#180,#196,33)+#13+#10))));
      form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete(#179+' CHEQUE Nr.:',#179,' ',30)+funcoes.CompletaOuRepete(' BANCO:',#179,' ',15)+funcoes.CompletaOuRepete(' CONTA:',#179,' ',33)+#13+#10))));
      form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete(#179,#179,' ',30)+funcoes.CompletaOuRepete('',#179,' ',15)+funcoes.CompletaOuRepete('',#179,' ',33)+#13+#10))));
      form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete(#195+#196+#196+#196+#196+#196+#196+#196+#196+#196+#196+#196+#196+#196+#196+#196+#196+#196+#196+#196+#196+#196+#196+#196+#196+#196+#196+#196+#196+#193,#197,#196,45)+funcoes.CompletaOuRepete('',#180,#196,33)+#13+#10))));
      form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete(#179,#179,' ',45)+funcoes.CompletaOuRepete('',#179,' ',33)+#13+#10))));
      form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete(#179+'   '+dm.IBQuery2.fieldbyname('cid').AsString+' - '+dm.IBQuery2.fieldbyname('est').AsString+', '+FormatDateTime('dd',form22.datamov)+' DE '+UpperCase(FormatDateTime('MMMM',form22.datamov))+' DE '+FormatDateTime('YYYY',form22.datamov),#179,' ',45)+funcoes.CompletaOuRepete('',#179,' ',33)+#13+#10))));
      form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete(#179,#179,' ',45)+funcoes.CompletaOuRepete('            Assinatura',#179,' ',33)+#13+#10))));
      form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete(#192,#193,#196,45)+funcoes.CompletaOuRepete('',#217,#196,33)+#13+#10))));
                  {for lin := lin to 10 do
                    begin
                      addRelatorioForm19(funcoes.CompletaOuRepete('|','|', ' ', 70) + #13 + #10); // pula linhas em branco
                    end;

                 addRelatorioForm19(funcoes.CompletaOuRepete('+','+', '-', 26) + funcoes.CompletaOuRepete('','+', '-', 16) + funcoes.CompletaOuRepete('','+', '-', 28) + #13 + #10);
                 addRelatorioForm19(funcoes.CompletaOuRepete('| CHEQUE N.:' ,'|', ' ', 26) + funcoes.CompletaOuRepete(' BANCO: ','|', ' ', 16) + funcoes.CompletaOuRepete(' CONTA:','|', ' ', 28) + #13 + #10);
                 addRelatorioForm19(funcoes.CompletaOuRepete('|' ,'|', ' ', 26) + funcoes.CompletaOuRepete('','|', ' ', 16) + funcoes.CompletaOuRepete('','|', ' ', 28) + #13 + #10);
                 addRelatorioForm19(funcoes.CompletaOuRepete('+','+', '-', 26) + funcoes.CompletaOuRepete('','+', '-', 16) + funcoes.CompletaOuRepete('','+', '-', 28) + #13 + #10);
                 addRelatorioForm19(funcoes.CompletaOuRepete('|','|', ' ', 42) + funcoes.CompletaOuRepete('','|', ' ', 28) + #13 + #10);
                 addRelatorioForm19(funcoes.CompletaOuRepete('|' + dm.IBQuery4.fieldbyname('cid').AsString + ' - ' + dm.IBQuery4.fieldbyname('est').AsString + ', ' + FormatDateTime('d', Form22.datamov) + ' DE ' + UpperCase(FormatDateTime('mmmm', Form22.datamov)) + ' DE ' + FormatDateTime('yyyy', Form22.datamov)  ,'|', ' ', 42) + funcoes.CompletaOuRepete('','|', ' ', 28) + #13 + #10);
                 addRelatorioForm19(funcoes.CompletaOuRepete('|','|', ' ', 42) + funcoes.CompletaOuRepete('  RECEBIDO POR VENDEDOR','|', ' ', 28) + #13 + #10);
                 addRelatorioForm19(funcoes.CompletaOuRepete('+','+', '-', 42) + funcoes.CompletaOuRepete('','+', '-', 28) + #13 + #10);

                 dm.IBQuery4.Close;}
                end;

              sim := funcoes.valorPorExtenso(abs(valorb));
              sim := UpperCase(copy(sim,1,1))+copy(sim,2,length(sim));
              valorbaixado := '';
              i := 0;
              while i <> length(sim) do
                begin
                  i := i + 1;
                  if sim[i] = ' ' then a := i;
                  valorbaixado := valorbaixado + sim[i];
                    if length(valorbaixado) = 38 then
                      begin
                       //sim := copy(sim,1,i);
                       if ((Form22.Pgerais.Values['nota'] = 'T') or (Form22.Pgerais.Values['nota'] = 'D')) then
                         begin
                           form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar(funcoes.CompletaOuRepete('|'+TrimLeft(copy(valorbaixado,1,a)),'|',' ',40)+#13+#10)));
                         end;
                       valorbaixado := copy(valorbaixado,length(copy(valorbaixado,1,a)),length(valorbaixado));
                      end
                    else if i = length(sim) then
                      begin
                        if ((Form22.Pgerais.Values['nota'] = 'T') or (Form22.Pgerais.Values['nota'] = 'D')) then
                          begin
                            form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar(funcoes.CompletaOuRepete('|'+TrimLeft(valorbaixado),'|',' ',40)+#13+#10)));
                          end;
                      end;
                end;
                
              if ((Form22.Pgerais.Values['nota'] = 'T') or (Form22.Pgerais.Values['nota'] = 'D')) then
                begin
                  form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar(funcoes.CompletaOuRepete('+','+','-',40)+#13+#10)));
                  form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar(funcoes.CompletaOuRepete('|','|',' ',40)+#13+#10)));
                  form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar(funcoes.CompletaOuRepete('|RECEBIDO POR:','|',' ',40)+#13+#10)));
                  form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar(funcoes.CompletaOuRepete('|','|',' ',40)+#13+#10)));
                  form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar(funcoes.CompletaOuRepete('|','|',' ',40)+#13+#10)));
                  form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar(funcoes.CompletaOuRepete('+','+','-',40)+#13+#10)));
                end;


              if dm.IBQuery1.Transaction.InTransaction then dm.IBQuery1.Transaction.Commit;

              copiaContasReceber(dm.IBselect);
              {IBTable1.Active := false;
              IBTable1.Open;
              geraSaldo;
              IBTable1.Active :=true;
              IBTable1.DisableControls;
              IBTable1.First;
              IBTable1.MoveBy(c);
              iBTable1.EnableControls;}



              sim := funcoes.dialogo('generico',0,'SN',0,true,'S',Application.Title,'Deseja Imprimir o Recibo de Pagamento?','N') ;
              if sim = 'S' then
              begin
                funcoes.duplicarRichedit(StrToIntDef(funcoes.buscaParamGeral(87, '1'), 1));

                imprime.setCofiguracoesImpressora;
                imprime.textxArq('texto.txt');
               //imprime.textx('texto.txt');
              end;
              cont := 2;
            except
              on e:exception do begin
                dm.IBQuery2.Transaction.Rollback;
                ShowMessage('Erro Inesperado1! Tente Novamente' +#13 + e.Message);
                exit;
              end;
            end;
          end;
      end;

end;
end;

procedure TForm34.FormClose(Sender: TObject; var Action: TCloseAction);
begin
DBGrid1.DataSource.DataSet.Close;
end;

procedure TForm34.DBGrid1KeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  cli,valorBaixado,sim, cod, codES, fatura:string;
  i,a :integer;
  v1,valorb:currency;
begin
  if cont = 2 then
   begin
    if key = 113 then
     begin

      dm.IBQuery2.Close;
      dm.IBQuery2.SQL.Clear;
      dm.IBQuery2.SQL.Add('select cod,nome,ende,bairro,cid,est,cnpj,ies from cliente where cod='+DBGrid1.DataSource.DataSet.FieldByName('documento').AsString);
      dm.IBQuery2.Open;
      cli := dm.IBQuery2.fieldbyname('nome').AsString;

      form19.RichEdit1.Clear;
      form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('','','-',78)+#13+#10))));
      form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete(funcoes.CompletaOuRepete(funcoes.LerValorPGerais('empresa',form22.Pgerais),'',' ',35)+'EXTRATO DE CONTA',FormatDateTime('dd/mm/yy',form22.datamov),' ',78)+#13+#10))));
      form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('','','-',78)+#13+#10))));
      form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('CLIENTE: '+DBGrid1.DataSource.DataSet.FieldByName('documento').AsString +'-'+cli,FormatDateTime('tt',now),' ',78)+#13+#10))));
      addRelatorioForm19('END.: ' + dm.IBQuery2.fieldbyname('ende').AsString + ' BAIRRO: ' + dm.IBQuery2.fieldbyname('BAIRRO').AsString + CRLF);
      addRelatorioForm19('CIDADE: ' + dm.IBQuery2.fieldbyname('cid').AsString + ' ESTADO: ' + dm.IBQuery2.fieldbyname('est').AsString + CRLF);
      addRelatorioForm19('CPF/CNPJ: ' + dm.IBQuery2.fieldbyname('cnpj').AsString  + CRLF);
      form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('','','-',78)+#13+#10))));
      addRelatorioForm19('VENCIMENTO  HISTORICO                                  VALOR             SALDO'  + CRLF);
      form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('','','-',78)+#13+#10))));

      dm.IBQuery2.Close;
      DBGrid1.DataSource.DataSet.DisableControls;
      i:= DBGrid1.DataSource.DataSet.RecNo-1;
      DBGrid1.DataSource.DataSet.First;

      while not DBGrid1.DataSource.DataSet.Eof do
       begin
        if form19.RichEdit1.Lines.Count >= 55 then
          begin
            form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('','','-',78)+#12+#13+#10))));
            form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('','','-',78)+#13+#10))));
            form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete(funcoes.CompletaOuRepete(funcoes.LerValorPGerais('empresa',form22.Pgerais),'',' ',35)+'EXTRATO DE CONTA',FormatDateTime('dd/mm/yy',form22.datamov),' ',78)+#13+#10))));
            form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('CLIENTE: '+IBTable1DOCUMENTO.AsString +'-'+cli,FormatDateTime('tt',now),' ',78)+#13+#10))));
            form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('','','-',78)+#13+#10))));
          end;
          form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete(FormatDateTime('dd/mm/yy',DBGrid1.DataSource.DataSet.FieldByName('vencimento').AsDateTime),'',' ',12)+funcoes.CompletaOuRepete(DBGrid1.DataSource.DataSet.FieldByName('historico').AsString,'',' ',35)+funcoes.CompletaOuRepete(' ',FormatCurr('#,###,###0.00',DBGrid1.DataSource.DataSet.FieldByName('valor').AsCurrency),' ',13)+'    '+funcoes.CompletaOuRepete(' ',FormatCurr('#,###,###0.00',DBGrid1.DataSource.DataSet.FieldByName('saldo').AsCurrency),' ',14))+#13+#10)));
          DBGrid1.DataSource.DataSet.Next;
       end;
       DBGrid1.DataSource.DataSet.First;
       DBGrid1.DataSource.DataSet.MoveBy(i);
       DBGrid1.DataSource.DataSet.EnableControls;
       form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('','','-',78)+#13+#10))));
       imprime.textx('\texto.txt');
       form19.RichEdit1.Clear;
     end;

  if ((key = 121) or ((form22.usuario = 'ADMIN') and (key = 120))) then begin //f10
    baixaF10Antigo;
  end;
end;



 end;

procedure TForm34.DBGrid1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  data, cod : string;
begin
 if cont=2 then
  begin
    if key = 116 then
      begin
        data := '';
        cod  := DBGrid1.DataSource.DataSet.FieldByName('cod').AsString;
        dm.IBselect.Close;
        dm.IBselect.SQL.Text := 'select previsao from contasreceber where cod = :cod';
        dm.IBselect.ParamByName('cod').AsString := cod;
        dm.IBselect.Open;

        if dm.IBselect.FieldByName('previsao').AsDateTime > StrToDate('01/01/2005') then begin
          data := dm.IBselect.FieldByName('previsao').AsString;
        end;
        dm.IBselect.Close;


        //if IBTable1PREVISAO.AsString <> '01/01/1900'  then data := IBTable1PREVISAO.AsString;
        data := funcoes.dialogo('data',0,'1234567890'+#8,50,true,'',Application.Title,'Qual a Previsão para Pagamento?',data);
        if data = '*' then exit;


        dm.IBQuery1.Close;
        dm.IBQuery1.SQL.Text := 'update contasreceber set previsao = :data where cod = :cod';
        dm.IBQuery1.ParamByName('data').AsDate   := StrToDate(data);
        dm.IBQuery1.ParamByName('cod').AsString  := cod;
        dm.IBQuery1.ExecSQL;
        dm.IBQuery1.Transaction.Commit;

{        DBGrid1.DataSource.DataSet.Open;
        DBGrid1.DataSource.DataSet.Edit;
        DBGrid1.DataSource.DataSet..AsDateTime := StrToDateTime(data);
        IBTable1.Post;}

      end;
  end;
end;

procedure TForm34.copiaContasReceber(var query11 : TIBQuery);
var
  saldo, valor : currency;
  datamaior : TDateTime;
  d : integer;
begin
  //ClientDataSet1.FieldByName('cod').Visible := false;
  ClientDataSet1.FieldByName('cod').Visible      := false;
  ClientDataSet1.FieldByName('previsao').Visible := false;
  ClientDataSet1.FieldByName('datamov').Visible := false;
  ClientDataSet1.FieldByName('codgru').Visible := false;
  ClientDataSet1.FieldByName('previsao').Visible := false;
  funcoes.FormataCampos(tibquery(ClientDataSet1), 2, '', 2);
  ClientDataSet1.EmptyDataSet;

  try
    ClientDataSet1.DisableControls;
  dm.IBselect.Close;
  dm.IBselect.SQL.Text := 'select datamov,codgru, vencimento, documento, historico, previsao, valor, cod, valor as saldo  from contasreceber where ' +
  '(documento='+strnum(client1)+') and (pago=0) order by vencimento';
  dm.IBselect.Open;

  query11 := dm.IBselect;

  query11.First;
  saldo := 0;
  while not query11.Eof do begin
    datamaior := query11.FieldByName('vencimento').AsDateTime;
    valor     := query11.FieldByName('valor').AsCurrency;

    if valor <> 0 then begin
      if query11.FieldByName('datamov').AsDateTime > query11.FieldByName('vencimento').AsDateTime then
        datamaior := query11.FieldByName('datamov').AsDateTime;

      //d := DaysBetween(datamaior, form22.datamov);

      {if ((query11.FieldByName('cod').AsInteger = 48940) or (query11.FieldByName('cod').AsInteger = 48939)) then begin
        ShowMessage('cod='+query11.FieldByName('cod').AsString+#13+'dias=' + IntToStr(d) + #13 + IntToStr(trunc(form22.datamov - datamaior)));
      end;}

      d := trunc(form22.datamov - datamaior);

      //if form22.datamov > datamaior then
      if d > 0 then begin
        valor := valor + Arredonda((valor *( juros /100)) * d,2);
      end;

      saldo := saldo + valor;
      ClientDataSet1.Append;
      ClientDataSet1.FieldByName('codgru').AsInteger      := query11.FieldByName('codgru').AsInteger;
      ClientDataSet1.FieldByName('vencimento').AsDateTime := query11.FieldByName('vencimento').AsDateTime;
      ClientDataSet1.FieldByName('documento').AsInteger   := query11.FieldByName('documento').AsInteger;
      ClientDataSet1.FieldByName('historico').AsString    := query11.FieldByName('historico').AsString;
      ClientDataSet1.FieldByName('valor').AsCurrency      := valor;
      ClientDataSet1.FieldByName('saldo').AsCurrency      := saldo;
      ClientDataSet1.FieldByName('cod').AsInteger         := query11.FieldByName('cod').AsInteger;
      ClientDataSet1.Post;
    end;
    query11.Next;
  end;
  finally
    ClientDataSet1.First;
    ClientDataSet1.EnableControls;
  end;

  ClientDataSet1.FieldByName('cod').Visible := false;
end;


procedure TForm34.baixaF10Antigo();
var
  valorBaixado, sim, fatura, codES : String;
  valorb, v1 : currency;
  i, a : integer;
begin
  //aqui verifica se existe algum valor negativo pq se existir na hora de baixar duplica
  //asentradas em caixa
  if verificaValorNegativo then
    begin
      WWMessage('Foi detectado uma conta negativa, primeiro dê baixa desta conta utilizando ENTER para poder baixar utilizar esta função', mtWarning,[mbok], HexToTColor('FFD700'),true,false, HexToTColor('B22222'));
      exit;
    end;

  valorBaixado := funcoes.ConverteNumerico(funcoes.dialogo('numero',0,'1234567890,.'+#8,2,false,'',Application.Title,'Qual o Valor a Ser Baixado?','0,00'));
  if (valorBaixado = '*') then exit;
  try
    if (StrToCurr(valorBaixado) = 0)  then exit;
  except
    exit;
  end;

  if StrToCurr(valorBaixado) <= 0 then begin
    MessageDlg('Valor Inválido: ' + valorBaixado, mtInformation, [mbOK], 1);
    exit;
  end;

  formapagto := funcoes.LerFormPato(0,'Contas Receber', false);

  sim := funcoes.dialogo('generico',0,'SN',0,false,'S',Application.Title,'Confirma Baixa de R$ '+valorBaixado+' ?','S') ;
  if sim = '*' then exit;
     try
      valorb := StrToCurr(funcoes.ConverteNumerico(valorBaixado));
      v1 := valorb;
     except
       exit;
     end;
   try
      i := DBGrid1.DataSource.DataSet.RecNo-1;
      DBGrid1.DataSource.DataSet.DisableControls;
      DBGrid1.DataSource.DataSet.First;
      form19.RichEdit1.Clear;


      if ((Form22.Pgerais.Values['nota'] = 'T') or (Form22.Pgerais.Values['nota'] = 'D')) then
        begin
          form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar(#13+#10+#15)));
          form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar(funcoes.CompletaOuRepete('+','+','-',40)+#13+#10)));
          form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar('|'+funcoes.centraliza(UpperCase(funcoes.LerValorPGerais('empresa',form22.Pgerais)),' ',38)+'|'+#13+#10)));
          form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar(funcoes.CompletaOuRepete('|','|','-',40)+#13+#10)));
          form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar(funcoes.CompletaOuRepete('|DATA: '+FormatDateTime('dd/mm/yy',form22.datamov)+'          HORA: '+FormatDateTime('tt',now),'|',' ',40)+#13+#10)));
          form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar(funcoes.CompletaOuRepete('+','+','-',40)+#13+#10)));
          form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar(funcoes.CompletaOuRepete('|RECIBO    Valor: '+FormatCurr('#,###,###0.00',valorb),' |',' ',40)+#13+#10)));
          form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar(funcoes.CompletaOuRepete('+','+','-',40)+#13+#10)));
          form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar(funcoes.CompletaOuRepete('|','|',' ',40)+#13+#10)));
          form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar(funcoes.CompletaOuRepete('|RECEBIDO DE:','|',' ',40)+#13+#10)));
          form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar(funcoes.CompletaOuRepete('|'+copy(DBGrid1.DataSource.DataSet.FieldByName('historico').AsString,pos('-',DBGrid1.DataSource.DataSet.FieldByName('historico').AsString)+1,length(DBGrid1.DataSource.DataSet.FieldByName('historico').AsString)-6),'|',' ',40)+#13+#10)));
          form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar(funcoes.CompletaOuRepete('|','|',' ',40)+#13+#10)));
          form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar(funcoes.CompletaOuRepete('|A IMPORTANCIA DE R$ '+FormatCurr('#,###,###0.00',valorb),'|',' ',40)+#13+#10)));
          form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar(funcoes.CompletaOuRepete('|','|',' ',40)+#13+#10)));
          form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar(funcoes.CompletaOuRepete('|REFERENTE:','|',' ',40)+#13+#10)));
          form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar(funcoes.CompletaOuRepete('|','|',' ',40)+#13+#10)));
       end
     else
       begin
         fatura := funcoes.novocod('RECIBO_PAGA');
         dm.IBQuery2.Close;
         dm.IBQuery2.SQL.Text := ('select ende,bairro,cnpj,telres,telcom,cid,est from registro');
         dm.IBQuery2.Open;

         form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete(#218,'',#196,57)+funcoes.CompletaOuRepete(#194,#191,#196,21)+#13+#10))));
         form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete(#179+funcoes.centraliza(form22.Pgerais.Values['empresa'],' ',56),'',' ',57)+funcoes.CompletaOuRepete(#179+'   R E C I B O',#179,' ',21)+#13+#10))));
         form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete(#179+funcoes.centraliza(dm.IBQuery2.fieldbyname('ende').AsString+' - '+dm.IBQuery2.fieldbyname('bairro').AsString,' ',56),'',' ',57)+funcoes.CompletaOuRepete(#179+funcoes.centraliza( fatura,' ',19),#179,' ',21)+#13+#10))));
         form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete(#179+funcoes.centraliza('CNPJ: '+dm.IBQuery2.fieldbyname('cnpj').AsString,' ',56),'',' ',57)+funcoes.CompletaOuRepete(#179,#179,' ',21)+#13+#10))));
         form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete(#179+funcoes.centraliza('FONE: '+dm.IBQuery2.fieldbyname('TELRES').AsString+'   FAX: '+dm.IBQuery2.fieldbyname('TELCOM').AsString,' ',56),'',' ',57)+funcoes.CompletaOuRepete(#179+'R$:'+funcoes.CompletaOuRepete('',FormatCurr('#,###,###0.00', valorb),' ',15),#179,' ',21)+#13+#10))));
         form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete(#195,'',#196,12)+funcoes.CompletaOuRepete('','',#196,9)+funcoes.CompletaOuRepete('','',#196,6)+funcoes.CompletaOuRepete('','',#196,12)+funcoes.CompletaOuRepete('','',#196,12)+funcoes.CompletaOuRepete(''+#196+#196+#196+#196+#196+#196+#193,'',#196,9)+funcoes.CompletaOuRepete('','',#196,6)+
         funcoes.CompletaOuRepete('',#180,#196,12)+#13+#10))));

         {dm.IBQuery4.Close;
         dm.IBQuery4.SQL.Clear;
         dm.IBQuery4.SQL.Add('select * from registro');
         dm.IBQuery4.Open;

         form19.RichEdit1.Clear;
         addRelatorioForm19(funcoes.CompletaOuRepete('+', '+', '-', 52) + funcoes.CompletaOuRepete('', '+', '-', 18) + #13 + #10);
         addRelatorioForm19(funcoes.CompletaOuRepete('|' + funcoes.centraliza(form22.Pgerais.Values['empresa'], ' ', 50), '|', ' ', 52) + funcoes.CompletaOuRepete(funcoes.centraliza('R E C I B O', ' ', 16) , '|', ' ', 18) + #13 + #10);
         addRelatorioForm19(funcoes.CompletaOuRepete('|' + funcoes.centraliza(dm.IBQuery4.fieldbyname('ende').AsString + ' - ' + dm.IBQuery4.fieldbyname('bairro').AsString, ' ', 50), '|', ' ', 52) + funcoes.CompletaOuRepete(funcoes.centraliza('100', ' ', 16), '|', ' ', 18) + #13 + #10);
         addRelatorioForm19(funcoes.CompletaOuRepete('|' + funcoes.centraliza(dm.IBQuery4.fieldbyname('cnpj').AsString, ' ', 50), '|', ' ', 52) + funcoes.CompletaOuRepete('', '|', ' ', 18) + #13 + #10);
         addRelatorioForm19(funcoes.CompletaOuRepete('|' + funcoes.centraliza('Fone: ' + dm.IBQuery4.fieldbyname('telres').AsString + ' Fax: ' + dm.IBQuery4.fieldbyname('telcom').AsString, ' ', 50), '|', ' ', 52) + funcoes.CompletaOuRepete(funcoes.centraliza('R$ ' + FormatCurr('#,###,###0.00', valorb), ' ', 16), '|', ' ', 18) + #13 + #10);
         addRelatorioForm19(funcoes.CompletaOuRepete('+', '+', '-', 70) + #13 + #10);


         addRelatorioForm19(funcoes.CompletaOuRepete('| RECEBEMOS DE ' + copy(IBTable1HISTORICO.AsString, pos('-', IBTable1HISTORICO.AsString) + 1, length(IBTable1HISTORICO.AsString) - 8),'COD.: ' + '100' + '|', ' ', 70) + #13 + #10);
         addRelatorioForm19(funcoes.CompletaOuRepete('+', '+', '-', 70) + #13 + #10);

         addRelatorioForm19(funcoes.CompletaOuRepete('| A IMPORTANCIA DE: ', '|', ' ', 70) + #13 + #10);}

         sim := UpperCase(funcoes.valorPorExtenso(valorb));
         i := 0;
         codES := '';
         {while i <> length(sim) do
           begin
             i := i + 1;
             if sim[i] = ' ' then a := i;
             codES := codES + sim[i];
             if length(codES) = 68 then
               begin
                 addRelatorioForm19(funcoes.CompletaOuRepete('| ' + TrimLeft(copy(codES, 1, a)) , '|', ' ', 70) + #13 + #10);
                 valorbaixado := copy(codES,length(copy(codES,1,a)),length(codES));
               end;
           end;
        if i = length(sim) then
          begin
            addRelatorioForm19(funcoes.CompletaOuRepete('| ' + TrimLeft(codES) ,'|', ' ', 70) + #13 + #10);
          end;}


         //addRelatorioForm19(funcoes.CompletaOuRepete('|','|', ' ', 70) + #13 + #10);
         //addRelatorioForm19(funcoes.CompletaOuRepete('| REFERENTE A:' ,'|', ' ', 70) + #13 + #10);
       end;

      //(valorb<>0)
      while ((not DBGrid1.DataSource.DataSet.Eof) or (valorb <= 0)) do
       begin
        if (valorb <= 0) then break;
        if valorb >= DBGrid1.DataSource.DataSet.FieldByName('valor').AsCurrency then
          begin
            dm.IBQuery1.Close;
            dm.IBQuery1.SQL.Clear;
            dm.IBQuery1.SQL.Add('update contasreceber set valor=0,pago=:valor where cod='+DBGrid1.DataSource.DataSet.FieldByName('cod').AsString);
            dm.IBQuery1.ParamByName('valor').AsCurrency := DBGrid1.DataSource.DataSet.FieldByName('valor').AsCurrency;
            //dm.IBQuery1.ParamByName('data').AsDateTime  := form22.datamov;
            try
             valorb := valorb - DBGrid1.DataSource.DataSet.FieldByName('valor').AsCurrency;
             dm.IBQuery1.ExecSQL;
             dm.IBQuery1.Transaction.Commit;
            except
             dm.IBQuery1.Transaction.Rollback;
             ShowMessage('Erro Inesperado3v! Tente Novamente');
            end;

             dm.IBQuery1.Close;
             dm.IBQuery1.SQL.Clear;
             dm.IBQuery1.SQL.Add('insert into caixa(formpagto,codgru,codmov,codentradasaida,data,documento,vencimento,codhis,historico,entrada,usuario, tipo, fornec)'+
             ' values (:pagto,'+DBGrid1.DataSource.DataSet.FieldByName('codgru').AsString+','+funcoes.novocod('movcaixa')+','+DBGrid1.DataSource.DataSet.FieldByName('cod').AsString+',:data,'+DBGrid1.DataSource.DataSet.FieldByName('documento').AsString+',:venc,2,'+QuotedStr(DBGrid1.DataSource.DataSet.FieldByName('historico').AsString)+',:pago,'+form22.codusario+', ''R'', 1)');
             dm.IBQuery1.ParamByName('pagto').AsString  := strnum(formapagto);
             dm.IBQuery1.ParamByName('data').AsDateTime := DateOf(form22.datamov) + timeof(now);
             dm.IBQuery1.ParamByName('venc').AsDateTime:= DBGrid1.DataSource.DataSet.FieldByName('vencimento').AsDateTime;
             dm.IBQuery1.ParamByName('pago').AsCurrency:= DBGrid1.DataSource.DataSet.FieldByName('valor').AsCurrency;

             try
              dm.IBQuery1.ExecSQL;
             except
               on e:exception do begin
                 MessageDlg('Ocorreu um Erro22: '+ e.Message, mtError, [mbOK],1);
                 exit;
               end;
             end;
          end
         else if (valorb < DBGrid1.DataSource.DataSet.FieldByName('valor').AsCurrency) then
          begin
            //se valorb(valor que o usuario informou a ser dado baixa) menor valor da conta
            dm.IBQuery1.Close;
            dm.IBQuery1.SQL.Clear;
            dm.IBQuery1.SQL.Add('update contasreceber set valor = :valor, datamov = :data where cod='+DBGrid1.DataSource.DataSet.FieldByName('cod').AsString);
            dm.IBQuery1.ParamByName('valor').AsCurrency := DBGrid1.DataSource.DataSet.FieldByName('valor').AsCurrency - valorb;
            dm.IBQuery1.ParamByName('data').AsDate      := form22.datamov;
           try
             dm.IBQuery1.ExecSQL;
             dm.IBQuery1.Transaction.Commit;
           except
             dm.IBQuery1.Transaction.Rollback;
             ShowMessage('Erro Inesperado33! Tente Novamente');
           end;
             dm.IBQuery1.Close;
             dm.IBQuery1.SQL.Text := ('insert into caixa(formpagto,codgru,codmov,codentradasaida,data,documento,vencimento,codhis,historico,entrada,usuario, tipo, fornec)'+
             ' values (:pagto,'+DBGrid1.DataSource.DataSet.FieldByName('CODGRU').AsString+','+funcoes.novocod('movcaixa')+','+DBGrid1.DataSource.DataSet.FieldByName('COD').AsString+',:data,'+DBGrid1.DataSource.DataSet.FieldByName('DOCUMENTO').AsString+',:venc,'+'2'+','+QuotedStr(DBGrid1.DataSource.DataSet.FieldByName('historico').AsString)+',:pago,'+form22.codusario+', ''R'', 1)');
             dm.IBQuery1.ParamByName('pagto').AsString  := strnum(formapagto);
             dm.IBQuery1.ParamByName('data').AsDateTime := DateOf(form22.datamov) + timeof(now);
             dm.IBQuery1.ParamByName('venc').AsDateTime:= DBGrid1.DataSource.DataSet.FieldByName('VENCIMENTO').AsDateTime;
             dm.IBQuery1.ParamByName('pago').AsCurrency:= valorb;
           try
             dm.IBQuery1.ExecSQL;
             dm.IBQuery1.Transaction.Commit;
             if ((Form22.Pgerais.Values['nota'] = 'T') or (Form22.Pgerais.Values['nota'] = 'D')) then
               begin
                 form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar(funcoes.CompletaOuRepete('|'+copy(DBGrid1.DataSource.DataSet.FieldByName('historico').AsString,1,18)+' '+copy(DBGrid1.DataSource.DataSet.FieldByName('historico').AsString,length(DBGrid1.DataSource.DataSet.FieldByName('historico').AsString)-5,length(DBGrid1.DataSource.DataSet.FieldByName('historico').AsString)),FormatCurr('#,###,###0.00',valorb)+'|',' ',40)+#13+#10)));
               end
             else
               begin
                 funcoes.QuebraLinhas(#179,#179,' '+FormatDateTime('dd/mm/yy', DBGrid1.DataSource.DataSet.FieldByName('VENCIMENTO').AsDateTime)+'  '+ DBGrid1.DataSource.DataSet.FieldByName('historico').AsString +'          '+FormatCurr('#,###,###0.00', valorb),78);
                 //addRelatorioForm19(funcoes.CompletaOuRepete('|' + FormatDateTime('dd/mm/yy', IBTable1DATA.AsDateTime) + ' ' + funcoes.CompletaOuRepete(IBTable1HISTORICO.AsString, FormatCurr('#,###,###0.00', valorb), ' ', 50),'|', ' ', 70) + #13 + #10);
               end;
             valorb := 0;
           except
             on e:exception do begin
                 MessageDlg('Ocorreu um Erro111c: '+ e.Message, mtError, [mbOK],1);
                 exit;
               end;
           end;
          end;

        DBGrid1.DataSource.DataSet.Next;
       end;

       if valorb <> 0 then
         begin
           dm.IBQuery1.SQL.Text := ('insert into caixa(formpagto,codgru,codmov,codentradasaida,data,documento,vencimento,codhis,historico,entrada,usuario, tipo, fornec)'+
           ' values (:pagto,'+DBGrid1.DataSource.DataSet.FieldByName('CODGRU').AsString+','+funcoes.novocod('movcaixa')+','+DBGrid1.DataSource.DataSet.FieldByName('COD').AsString+',:data,'+DBGrid1.DataSource.DataSet.FieldByName('historico').AsString+',:venc,2,'+QuotedStr(copy(DBGrid1.DataSource.DataSet.FieldByName('historico').AsString,1,length(DBGrid1.DataSource.DataSet.FieldByName('historico').AsString) - 5))+',:pago,'+form22.codusario+', ''R'', 1)');
           dm.IBQuery1.ParamByName('pagto').AsString  := strnum(formapagto);
           dm.IBQuery1.ParamByName('data').AsDateTime := DateOf(form22.datamov) + TimeOf(now);
           dm.IBQuery1.ParamByName('venc').AsDateTime := form22.datamov;
           dm.IBQuery1.ParamByName('pago').AsCurrency:= valorb;
           try
             if ((Form22.Pgerais.Values['nota'] = 'T') or (Form22.Pgerais.Values['nota'] = 'D')) then
               begin
                 form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar(funcoes.CompletaOuRepete('|'+copy(DBGrid1.DataSource.DataSet.FieldByName('historico').AsString,1,length(DBGrid1.DataSource.DataSet.FieldByName('historico').AsString) - 5),FormatCurr('#,###,###0.00',valorb)+'|',' ',40)+#13+#10)));
               end
             else
               begin
                 funcoes.QuebraLinhas(#179,#179,' '+FormatDateTime('dd/mm/yy', DBGrid1.DataSource.DataSet.FieldByName('vencimento').AsDateTime)+'  '+ DBGrid1.DataSource.DataSet.FieldByName('historico').AsString +'          '+FormatCurr('#,###,###0.00', valorb),78);
                 //addRelatorioForm19(funcoes.CompletaOuRepete('|' + FormatDateTime('dd/mm/yy', IBTable1DATA.AsDateTime) + ' ' + funcoes.CompletaOuRepete(IBTable1HISTORICO.AsString, FormatCurr('#,###,###0.00', valorb), ' ', 50),'|', ' ', 70) + #13 + #10);
               end;
             dm.IBQuery1.ExecSQL;
           except
             on e:exception do begin
                 MessageDlg('Ocorreu um Erro21n: '+ e.Message, mtError, [mbOK],1);
                 exit;
               end;
           end;
         end;

       {IBTable1.First;
       IBTable1.MoveBy(i);
       IBTable1.EnableControls;
       IBTable1.Close;
       IBTable1.Active := true;
       geraSaldo;              }
       if ((Form22.Pgerais.Values['nota'] = 'T') or (Form22.Pgerais.Values['nota'] = 'D')) then
         begin
           form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar(funcoes.CompletaOuRepete('+','+','-',40)+#13+#10)));
         end
       else
         begin
           dm.IBQuery2.Close;
           dm.IBQuery2.SQL.Text := ('select ende,bairro,cnpj,telres,telcom,cid,est from registro');
           dm.IBQuery2.Open;

           form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete(#179,#179,' ',78)+#13+#10))));
           form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete(#179,#179,' ',78)+#13+#10))));
           form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete(#179,#179,' ',78)+#13+#10))));
           form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete(#179,#179,' ',78)+#13+#10))));
           form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete(#179,#179,' ',78)+#13+#10))));
           form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete(#179,#179,' ',78)+#13+#10))));
           form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete(#179,#179,' ',78)+#13+#10))));
           form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete(#195,#194,#196,30)+funcoes.CompletaOuRepete('',#194,#196,15)+funcoes.CompletaOuRepete('',#180,#196,33)+#13+#10))));
           form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete(#179+' CHEQUE Nr.:',#179,' ',30)+funcoes.CompletaOuRepete(' BANCO:',#179,' ',15)+funcoes.CompletaOuRepete(' CONTA:',#179,' ',33)+#13+#10))));
           form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete(#179,#179,' ',30)+funcoes.CompletaOuRepete('',#179,' ',15)+funcoes.CompletaOuRepete('',#179,' ',33)+#13+#10))));
           form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete(#195+#196+#196+#196+#196+#196+#196+#196+#196+#196+#196+#196+#196+#196+#196+#196+#196+#196+#196+#196+#196+#196+#196+#196+#196+#196+#196+#196+#196+#193,#197,#196,45)+funcoes.CompletaOuRepete('',#180,#196,33)+#13+#10))));
           form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete(#179,#179,' ',45)+funcoes.CompletaOuRepete('',#179,' ',33)+#13+#10))));
           form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete(#179+'   '+dm.IBQuery2.fieldbyname('cid').AsString+' - '+dm.IBQuery2.fieldbyname('est').AsString+', '+FormatDateTime('dd',form22.datamov)+' DE '+UpperCase(FormatDateTime('MMMM',form22.datamov))+' DE '+FormatDateTime('YYYY',form22.datamov),#179,' ',45)+funcoes.CompletaOuRepete('',#179,' ',33)+#13+#10))));
           form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete(#179,#179,' ',45)+funcoes.CompletaOuRepete('            Assinatura',#179,' ',33)+#13+#10))));
           form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete(#192,#193,#196,45)+funcoes.CompletaOuRepete('',#217,#196,33)+#13+#10))));
           {dm.IBQuery4.Close;
           dm.IBQuery4.SQL.Clear;
           dm.IBQuery4.SQL.Add('select * from registro');
           dm.IBQuery4.Open;

           addRelatorioForm19(funcoes.CompletaOuRepete('+','+', '-', 26) + funcoes.CompletaOuRepete('','+', '-', 16) + funcoes.CompletaOuRepete('','+', '-', 28) + #13 + #10);
           addRelatorioForm19(funcoes.CompletaOuRepete('| CHEQUE N.:' ,'|', ' ', 26) + funcoes.CompletaOuRepete(' BANCO: ','|', ' ', 16) + funcoes.CompletaOuRepete(' CONTA:','|', ' ', 28) + #13 + #10);
           addRelatorioForm19(funcoes.CompletaOuRepete('|' ,'|', ' ', 26) + funcoes.CompletaOuRepete('','|', ' ', 16) + funcoes.CompletaOuRepete('','|', ' ', 28) + #13 + #10);
           addRelatorioForm19(funcoes.CompletaOuRepete('+','+', '-', 26) + funcoes.CompletaOuRepete('','+', '-', 16) + funcoes.CompletaOuRepete('','+', '-', 28) + #13 + #10);
           addRelatorioForm19(funcoes.CompletaOuRepete('|','|', ' ', 42) + funcoes.CompletaOuRepete('','|', ' ', 28) + #13 + #10);
           addRelatorioForm19(funcoes.CompletaOuRepete('|' + dm.IBQuery4.fieldbyname('cid').AsString + ' - ' + dm.IBQuery4.fieldbyname('est').AsString + ', ' + FormatDateTime('d', Form22.datamov) + ' DE ' + UpperCase(FormatDateTime('mmmm', Form22.datamov)) + ' DE ' + FormatDateTime('yyyy', Form22.datamov)  ,'|', ' ', 42) + funcoes.CompletaOuRepete('','|', ' ', 28) + #13 + #10);
           addRelatorioForm19(funcoes.CompletaOuRepete('|','|', ' ', 42) + funcoes.CompletaOuRepete('  RECEBIDO POR VENDEDOR','|', ' ', 28) + #13 + #10);
           addRelatorioForm19(funcoes.CompletaOuRepete('+','+', '-', 42) + funcoes.CompletaOuRepete('','+', '-', 28) + #13 + #10);}
         end;
       sim := funcoes.valorPorExtenso(v1);
       sim := UpperCase(sim);
       valorbaixado := '';
       i := 0;
       while i <> length(sim) do
         begin
           i := i + 1;
           if sim[i] = ' ' then a := i;
           valorbaixado := valorbaixado + sim[i];
           if length(valorbaixado) = 38 then
             begin
               if ((Form22.Pgerais.Values['nota'] = 'T') or (Form22.Pgerais.Values['nota'] = 'D')) then
                 begin
                   form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar(funcoes.CompletaOuRepete('|'+TrimLeft(copy(valorbaixado,1,a)),'|',' ',40)+#13+#10)));
                 end;
               valorbaixado := copy(valorbaixado,length(copy(valorbaixado,1,a)),length(valorbaixado));
             end
           else if i = length(sim) then
             begin
               if ((Form22.Pgerais.Values['nota'] = 'T') or (Form22.Pgerais.Values['nota'] = 'D')) then form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar(funcoes.CompletaOuRepete('|'+TrimLeft(valorbaixado),'|',' ',40)+#13+#10)));
             end;
         end;
         if ((Form22.Pgerais.Values['nota'] = 'T') or (Form22.Pgerais.Values['nota'] = 'D')) then
           begin
             form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar(funcoes.CompletaOuRepete('+','+','-',40)+#13+#10)));
             form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar(funcoes.CompletaOuRepete('|','|',' ',40)+#13+#10)));
             form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar(funcoes.CompletaOuRepete('|RECEBIDO POR:','|',' ',40)+#13+#10)));
             form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar(funcoes.CompletaOuRepete('|','|',' ',40)+#13+#10)));
             form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar(funcoes.CompletaOuRepete('|','|',' ',40)+#13+#10)));
             form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar(funcoes.CompletaOuRepete('+','+','-',40)+#13+#10)));
           end;
         //IBTable1.Active :=true;

         if dm.IBQuery1.Transaction.InTransaction then dm.IBQuery1.Transaction.Commit;
         copiaContasReceber(dm.IBselect);
         sim := funcoes.dialogo('generico',0,'SN',0,false,'S',Application.Title,'Deseja Imprimir o Recibo de Pagamento?','N') ;

         dm.IBQuery4.Close;

         if sim='S' then
         begin
           imprime.setCofiguracoesImpressora;
           funcoes.duplicarRichedit(StrToIntDef(funcoes.buscaParamGeral(87, '1'), 1));
           imprime.textxArq('texto.txt');
          //form19.RichEdit1.Lines.SaveToFile('texto.txt');
          //imprime.textx(GetCurrentDir+'\texto.txt');
         end;
   finally
     ClientDataSet1.EnableControls;
   end;
end;


procedure TForm34.baixaF10Novo();
begin
  DBGrid1.DataSource.DataSet.DisableControls;
  try
    DBGrid1.DataSource.DataSet.First;

  finally
    DBGrid1.DataSource.DataSet.EnableControls;
  end;
end;

end.
