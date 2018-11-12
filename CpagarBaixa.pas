unit CpagarBaixa;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, DBGrids, StdCtrls, Buttons, JsBotao1, ToolWin, ComCtrls,
  ExtCtrls;

type
  TForm31 = class(TForm)
    DBGrid1: TDBGrid;
    Panel1: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    total: TLabel;
    procedure DBGrid1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure DBGrid1KeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form31: TForm31;

implementation

uses Unit1, func, IBQuery, principal, DB, DateUtils;

{$R *.dfm}

procedure TForm31.DBGrid1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  confirma, sim, data, documento, liquidar, caixa, codPAG, formpagto :string;
  saida : currency;
  datamov : tdatetime;
begin
 if ((key = 121) or ((form22.usuario = 'ADMIN') and (key = 120))) then
   begin
     if not dm.IBselect.IsEmpty then
       begin
        datamov := form22.datamov;
        sim := funcoes.dialogo('generico',0,'SN',0,false,'S',Application.Title,'Confirma Baixa Desta Conta?','S');
        if (sim = 'N') or (sim = '*') then exit;

        confirma := funcoes.dialogo('numero',0,'1234567890,.'+#8,2,false,'',Application.Title,'Confirme o Valor Pago:',FormatCurr('#,###,###0.00',dm.IBselect.fieldbyname('valor').AsCurrency));
        if (confirma = '*') or (StrToCurr(funcoes.ConverteNumerico(confirma)) = 0) then exit;

        caixa := dm.IBselect.fieldbyname('codgru').AsString;
        caixa := funcoes.dialogo('generico', 50,'1234567890' + #8, 50,false,'',Application.Title,'Deseja lançar em qual Grupo de Caixa', caixa);
        if caixa = '*' then exit;

        codPAG := dm.IBselect.fieldbyname('cod').AsString;

        dm.IBQuery4.Close;
        dm.IBQuery4.SQL.Clear;
        dm.IBQuery4.SQL.Add('select cod from GRUPODECAIXA where cod = :cod');
        dm.IBQuery4.ParamByName('cod').AsString := caixa;
        dm.IBQuery4.Open;

        if dm.IBQuery4.IsEmpty then ShowMessage('Grupo de Caixa ' + caixa + ' Não Encontrado');

        if ((caixa = '') or (dm.IBQuery4.IsEmpty)) then
          begin
            caixa := funcoes.localizar('Localizar Grupo','grupodecaixa','cod,grupo','cod','','grupo','grupo',false,false,false,'',0, nil);
          end;

        dm.IBQuery4.Close;  
        if ((caixa = '') or (StrToIntDef(caixa, 0) = 0)) then exit;

        data := funcoes.dialogo('data',0,'',2,true,'',Application.Title,'Confirme a Data de Pagamento:', formatadataddmmyy(datamov));
        if data = '*' then exit;

        //formpagto := funcoes.LerFormPato(0,'Contas Receber', false);
        formpagto := '1';

         dm.IBQuery1.Close;
         dm.IBQuery1.SQL.Clear;
         if StrToCurr(funcoes.ConverteNumerico(confirma)) < dm.IBselect.FieldByName('valor').AsCurrency then
           begin
             sim := funcoes.dialogo('generico',0,'SN',0,false,'S',Application.Title,'Deseja Liquidar Esta Conta Com Valor Menor?','N');
             if sim = '*' then exit;
             if (sim = 'N') then
               begin
                 dm.IBQuery1.SQL.Add('update contaspagar set  valor = :reduzido where (cod='+dm.IBselect.fieldbyname('cod').AsString+')');
                 dm.IBQuery1.ParamByName('reduzido').AsCurrency := dm.IBselect.fieldbyname('valor').AsCurrency - strtocurr(funcoes.ConverteNumerico(confirma));
                 //dm.IBQuery1.ParamByName('venc').AsDateTime := dm.IBselect.fieldbyname('vencimento').AsDateTime;
               end
             else
               begin
                 dm.IBQuery1.SQL.Add('update contaspagar set pago = :pago,  valor = :reduzido where (cod='+dm.IBselect.fieldbyname('cod').AsString+')');
                 dm.IBQuery1.ParamByName('pago').AsCurrency := strtocurr(funcoes.ConverteNumerico(confirma));
                 dm.IBQuery1.ParamByName('reduzido').AsCurrency := dm.IBselect.fieldbyname('valor').AsCurrency - strtocurr(funcoes.ConverteNumerico(confirma));
                 //dm.IBQuery1.ParamByName('venc').AsDateTime := dm.IBselect.fieldbyname('vencimento').AsDateTime;
                 {dm.IBQuery1.SQL.Add('update contaspagar set pago = :pago,  valor = :reduzido where (documento='+dm.IBselect.fieldbyname('documento').AsString+') and (codgru='+dm.IBselect.fieldbyname('codgru').AsString+') and vencimento=:venc');
                 dm.IBQuery1.ParamByName('pago').AsCurrency := strtocurr(funcoes.ConverteNumerico(confirma));
                 dm.IBQuery1.ParamByName('reduzido').AsCurrency := dm.IBselect.fieldbyname('valor').AsCurrency - strtocurr(funcoes.ConverteNumerico(confirma));
                 dm.IBQuery1.ParamByName('venc').AsDateTime := dm.IBselect.fieldbyname('vencimento').AsDateTime;}
               end;
           end
         else
           begin
             dm.IBQuery1.SQL.Add('update contaspagar set pago = total, valor = :reduzido where (cod='+dm.IBselect.fieldbyname('cod').AsString+')');
             //dm.IBQuery1.ParamByName('pago').AsCurrency:= StrToCurr(funcoes.ConverteNumerico(confirma));
             dm.IBQuery1.ParamByName('reduzido').AsCurrency := dm.IBselect.fieldbyname('valor').AsCurrency - strtocurr(funcoes.ConverteNumerico(confirma));
             //dm.IBQuery1.ParamByName('venc').AsDateTime := dm.IBselect.fieldbyname('vencimento').AsDateTime;
           end;

     try
       dm.IBQuery1.ExecSQL;
     except
       ShowMessage('Ocorreu um Erro Inesperado. Por Favor Tente Novamente');
       exit;
     end;
       
     dm.IBQuery2.Close;
     dm.IBQuery2.SQL.Clear;
     dm.IBQuery2.SQL.Add('select * from contaspagar where (cod='+dm.IBselect.fieldbyname('cod').AsString+')');
     //dm.IBQuery2.ParamByName('venc').AsDateTime := dm.IBselect.fieldbyname('vencimento').AsDateTime ;
     try
       dm.IBQuery2.Open;
     except
     end;

     datamov := StrToDateDef(data, form22.datamov);

     dm.IBQuery3.Close;
     dm.IBQuery3.SQL.Text := ('insert into caixa(formpagto, fornec, codgru, codmov,data,documento,vencimento,codhis,historico,saida,usuario,codentradasaida, tipo)' +
     ' values (:formpagto,1, :codgru, :codmov,:data,:documento,:venc,:codhis,:historico,:saida,:usuario,:codentradasaida, ''P'')');
     dm.IBQuery3.ParamByName('formpagto').AsString := strnum(formpagto);
     dm.IBQuery3.ParamByName('codgru').AsString := caixa;
     dm.IBQuery3.ParamByName('codmov').AsString := funcoes.novocod('movcaixa');
     dm.IBQuery3.ParamByName('data').AsDateTime := DateOf(datamov) + TimeOf(now);
     dm.IBQuery3.ParamByName('documento').AsString := dm.IBQuery2.fieldbyname('documento').AsString;
     dm.IBQuery3.ParamByName('venc').AsDateTime := dm.IBselect.fieldbyname('vencimento').AsDateTime;
     dm.IBQuery3.ParamByName('codhis').AsString := dm.IBQuery2.fieldbyname('codhis').AsString;
     //dm.IBQuery3.ParamByName('historico').AsString := copy(dm.IBQuery2.fieldbyname('historico').AsString, 1, 35);
     dm.IBQuery3.ParamByName('historico').AsString := dm.IBQuery2.fieldbyname('historico').AsString;
     dm.IBQuery3.ParamByName('saida').AsCurrency := StrToCurr(funcoes.ConverteNumerico(confirma));
     dm.IBQuery3.ParamByName('usuario').AsString := form22.codusario;
     dm.IBQuery3.ParamByName('codentradasaida').AsString := codPAG;
     dm.IBQuery3.ExecSQL;
     try
       dm.IBQuery3.Transaction.Commit;
       if dm.IBQuery1.Transaction.InTransaction then dm.IBQuery1.Transaction.Commit;
     except
       dm.IBQuery3.Transaction.Rollback;
       ShowMessage('Ocorreu um Erro e a Transacao Nao foi Concluida. Tente Novamente');
       exit;
     end;

     dm.IBQuery2.close;
     dm.IBselect.Close;
     dm.IBselect.Open;
     funcoes.FormataCampos(dm.ibselect,2,'valor',2);
     //dm.IBselect.FieldByName('documento').Visible := false;
     dm.IBselect.FieldByName('usuario').Visible := false;
     dm.IBselect.FieldByName('codgru').Visible := false;
     dm.IBselect.FieldByName('cod').Visible := false;
     total.Caption := CurrToStrF(funcoes.SomaCampoDBGRID(Dm.ibselect,'valor',0,0,0,''),ffCurrency,2);
  end;

  end;
 end;


procedure TForm31.FormShow(Sender: TObject);
begin

try
  total.Caption   := CurrToStrF(funcoes.SomaCampoDBGRID(Dm.ibselect,'valor',0,0,0,''),ffCurrency,2);
  DBGrid1.Options := [dgTitles, dgColLines, dgRowLines, dgTabs, dgIndicator];
except
end;

end;

procedure TForm31.DBGrid1KeyPress(Sender: TObject; var Key: Char);
var a:string;
begin
  if (key=#32) and (dbgrid1.SelectedField.DisplayLabel = 'HISTORICO') then
    begin
      a := funcoes.dialogo('normal',0,'',150, TRUE,'',Application.Title,'selecionar Por:','');
      if (a = '*') or (a = '') then exit;

      dm.IBQuery2.Close;
      dm.IBQuery2.SQL.Clear;
      dm.IBQuery2.SQL.Add('select documento, codhis, historico, valor from contaspagar where (pago = 0) and ((vencimento >= :ini) and (vencimento <= :fim)) and (historico like :his)');
      dm.IBQuery2.ParamByName('ini').AsDateTime := dm.IBselect.parambyname('ini').AsDateTime;
      dm.IBQuery2.ParamByName('fim').AsDateTime := dm.IBselect.parambyname('fim').AsDateTime;
      dm.IBQuery2.ParamByName('his').AsString := '%' + a + '%';
      dm.IBQuery2.Open;

      a := funcoes.busca(dm.ibquery2, a, 'HISTORICO', 'documento', '');
      if a = '' then
        begin
          dm.IBQuery2.Close;
          exit;
        end;

      dm.IBQuery2.Close;
      if StrToIntDef(a, 0) = 0 then exit;
      dm.IBselect.Locate('DOCUMENTO', StrToInt(a), []);
      exit;
    end;

    if key = #27 then close;
end;

end.

