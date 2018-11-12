unit movcaixaposicao;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Grids, DBGrids;

type
  TForm32 = class(TForm)
    DBGrid1: TDBGrid;
    Panel1: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    total: TLabel;
    procedure DBGrid1KeyPress(Sender: TObject; var Key: Char);
    procedure DBGrid1KeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
  private
    procedure alteraMov();
    procedure deletaPorTipo(Tipo : String);
    procedure desabilitaCampos();
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form32: TForm32;

implementation

uses func, Unit1, DB;

{$R *.dfm}

procedure TForm32.DBGrid1KeyPress(Sender: TObject; var Key: Char);
var a, b:string;
begin
  if key = #13 then
    begin
      if ((DBGrid1.SelectedField.DisplayName = 'ENTRADA') or (DBGrid1.SelectedField.DisplayName = 'SAIDA')) then
        begin
          alteraMov();
        end;
        
      exit;
    end;

  if key=#27 then close;
  if (key = #32) and (DBGrid1.SelectedField.DisplayName = 'HISTORICO') then
    begin
      a := funcoes.dialogo('normal',0,'',150,false,'',Application.Title,'Selecionar Por:','');
      if a <> '*' then
        begin
          dm.IBQuery4.Close;
          dm.IBQuery4.SQL.Clear;
          dm.IBQuery4.SQL.Add('select codgru as grupo,data,documento,historico,entrada,saida,codhis as hist,codmov,codentradasaida from caixa where ((historico like '+ QuotedStr('%' + a + '%') +') and '+
          '(cast(data as date) >= :ini) and (cast(data as date)<=:fim)) order by data');
          dm.IBQuery4.ParamByName('ini').AsDateTime := dm.IBselect.ParamByName('ini').AsDateTime;
          dm.IBQuery4.ParamByName('fim').AsDateTime := dm.IBselect.ParamByName('fim').AsDateTime;
          dm.IBQuery4.Open;

          desabilitaCampos;

          b := funcoes.busca(dm.IBquery4, a, 'historico', 'codmov', '');
          dm.IBselect.Locate('codmov', b,[]) ;

          dm.IBQuery4.Close;
        end;
    end;
end;

procedure TForm32.DBGrid1KeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  codES,codmov,valorquery,doc:string;
  valor,saida, ent : currency;
  i:integer;
begin
i:=0;
if funcoes.Contido(chr(key),'dD') then
begin
  ent   := funcoes.SomaCampoDBGRID(Dm.ibselect,'entrada',0,0, dm.IBselect.fieldbyname('data').AsDateTime,'data');
  saida := funcoes.SomaCampoDBGRID(Dm.ibselect,'saida',0,0,dm.IBselect.fieldbyname('data').AsDateTime,'data');
  DOC := funcoes.CompletaOuRepete('', '', '-', 22) + CRLF + 'Total do Dia '+formataDataDDMMYY(dm.IBselect.fieldbyname('data').AsDateTime)+':' + CRLF + CRLF + 'Entrada=>'+ funcoes.CompletaOuRepete('', formataCurrency(ent), ' ', 13) + '+' + CRLF + 'Saída  =>'+funcoes.CompletaOuRepete('', formataCurrency(saida), ' ', 13) + '-' + CRLF + funcoes.CompletaOuRepete('', '', '-', 22) + CRLF + 'TOTAL  =>' + funcoes.CompletaOuRepete('', formataCurrency(ent - saida), ' ', 13) + CRLF + funcoes.CompletaOuRepete('', '', '-', 22) + CRLF + CRLF;
  funcoes.Mensagem('Total Somatório do dia '+formataDataDDMMYY(dm.IBselect.fieldbyname('data').AsDateTime), doc,9,'Courier New',true,0,clBlack, false);
end;

if funcoes.Contido(chr(key),'tT') then
begin
  ent   := funcoes.SomaCampoDBGRID(dm.ibselect,'entrada',dm.IBselect.fieldbyname('data').AsDateTime,0,0,'data');
  saida := funcoes.SomaCampoDBGRID(dm.ibselect,'saida',dm.IBselect.fieldbyname('data').AsDateTime,0,0,'data');
  DOC := funcoes.CompletaOuRepete('', '', '-', 22) + CRLF + 'Total até Dia '+formataDataDDMMYY(dm.IBselect.fieldbyname('data').AsDateTime)+':' + CRLF + CRLF + 'Entrada=>'+ funcoes.CompletaOuRepete('', formataCurrency(ent), ' ', 13) + '+' + CRLF + 'Saída  =>'+funcoes.CompletaOuRepete('', formataCurrency(saida), ' ', 13) + '-' + CRLF + funcoes.CompletaOuRepete('', '', '-', 22) + CRLF + 'TOTAL  =>' + funcoes.CompletaOuRepete('', formataCurrency(ent - saida), ' ', 13) + CRLF + funcoes.CompletaOuRepete('', '', '-', 22) + CRLF + CRLF;
  funcoes.Mensagem('Total até Dia '+formataDataDDMMYY(dm.IBselect.fieldbyname('data').AsDateTime), doc,9,'Courier New',true,0,clBlack, false);

  //ShowMessage('Total até Dia '+formataDataDDMMYY(dm.IBselect.fieldbyname('data').AsDateTime)+ CRLF +': Entrada->'+CurrToStrF(,ffnumber,2)+ CRLF +'Saída->'+CurrToStrF(,ffnumber,2));
end;

if key = 46 then //delete
  begin
    if RetornaAcessoUsuario > 0 then
      begin
        WWMessage('Somente um Usuário Autorizado Pode Deletar Este Movimento.',mtError,[mbok],clYellow,true,false,clRed);
        exit;
      end;

  IF not dm.IBselect.IsEmpty then
    begin
      if messageDlg('Deseja Excluir?', mtConfirmation, [mbyes, mbNo], 0) = mrYes then
        begin
          if funcoes.Contido('VENDAS DO DIA', dm.IBselect.FieldByName('historico').AsString) then
            begin
              WWMessage('Este Registro Não Pode Ser Excluído', mtWarning,[mbok], HexToTColor('FFD700'),true,false, HexToTColor('B22222'));
              exit;
            end;

          deletaPorTipo(trim(dm.IBselect.FieldByName('tipo').AsString));

          exit;
        end;
    end;
end;

end;

procedure TForm32.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key = 112 then funcoes.executaCalculadora;
end;

procedure TForm32.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  dm.IBselect.Close;
  dm.IBQuery4.Close;
end;

procedure TForm32.FormShow(Sender: TObject);
begin
  DBGrid1.Font.Name := 'Courier New';
  DBGrid1.Font.Style := [fsBold];
end;

procedure TForm32.alteraMov();
var
  entrada, saida, entOld, saiOld : currency;
  enta, valNovo : string;
  ENTSAI : INTEGER;
begin
  EXIT;

  if RetornaAcessoUsuario > 0 then exit;

  if funcoes.Contido('VENDAS DO DIA', DBGrid1.DataSource.DataSet.FieldByName('HISTORICO').AsString) then
    begin
      MessageDlg('Este Registro Não Pode ser Alterado!', mtInformation, [mbOK], 1);
      exit;
    end;

  entrada := 0; saida := 0;
  ENTSAI := -1;
  enta    := DBGrid1.DataSource.DataSet.FieldByName('codmov').AsString;
  entrada := DBGrid1.DataSource.DataSet.FieldByName('entrada').AsCurrency;
  saida   := DBGrid1.DataSource.DataSet.FieldByName('saida').AsCurrency;

  if DBGrid1.DataSource.DataSet.FieldByName('entrada').AsCurrency > 0 then
    begin
      ENTSAI := 1;
      entOld  := DBGrid1.DataSource.DataSet.FieldByName('entrada').AsCurrency;
      entrada := DBGrid1.DataSource.DataSet.FieldByName('entrada').AsCurrency;
      valNovo := funcoes.dialogo('numero',0,'',2,false,'',Application.Title,'Qual o Novo Valor de Entrada?', formataCurrency(entrada));
      if valNovo = '*' then exit;
      entrada := StrToCurrDef(valNovo, DBGrid1.DataSource.DataSet.FieldByName('entrada').AsCurrency);
    end
  else
    begin
      ENTSAI := 2;
      saiOld := DBGrid1.DataSource.DataSet.FieldByName('saida').AsCurrency;
      saida  := DBGrid1.DataSource.DataSet.FieldByName('saida').AsCurrency;
      valNovo := funcoes.dialogo('numero',0,'',2,false,'',Application.Title,'Qual o Novo Valor de Saída?', formataCurrency(saida));
      if valNovo = '*' then exit;
      saida := StrToCurrDef(valNovo, DBGrid1.DataSource.DataSet.FieldByName('saida').AsCurrency);
    end;

  IF ENTSAI = 1 THEN funcoes.gravaAlteracao(DBGrid1.DataSource.DataSet.FieldByName('HISTORICO').AsString + ' DE ' + formataCurrency(entOld) + ' PARA ' + formataCurrency(entrada))
  ELSE funcoes.gravaAlteracao(DBGrid1.DataSource.DataSet.FieldByName('HISTORICO').AsString + ' DE ' + formataCurrency(saiOld) + ' PARA ' + formataCurrency(saida));

  dm.IBQuery1.Close;
  dm.IBQuery1.SQL.Text := 'update caixa set entrada = :ent, saida = :sai where codmov = :cod';
  dm.IBQuery1.ParamByName('ent').AsCurrency := entrada;
  dm.IBQuery1.ParamByName('sai').AsCurrency := saida;
  dm.IBQuery1.ParamByName('cod').AsString   := enta;
  dm.IBQuery1.ExecSQL;
  dm.IBQuery1.Transaction.Commit;

  DBGrid1.DataSource.DataSet.Close;
  DBGrid1.DataSource.DataSet.Open;
  dm.IBselect.FieldByName('codmov').Visible := false;
  dm.IBselect.FieldByName('codentradasaida').Visible:=false;
  dm.IBselect.FieldByName('tipo').Visible:=false;
  funcoes.FormataCampos(dm.ibselect,2,'',2);
  try
    dm.IBselect.DisableControls;
    dm.IBselect.Locate('codmov', enta, []);
  finally
    dm.IBselect.EnableControls;
  end;
end;

procedure TForm32.deletaPorTipo(Tipo : String);
var
  recno : integer;
  valor : currency;
  codmov, codES : String;
begin
  if tipo.IsEmpty then begin
    if dm.IBselect.fieldbyname('entrada').AsCurrency > 0 then begin
      tipo := 'R'
    end
    else tipo := 'P';
  end;

  if tipo = 'R' then begin
    recno  := dm.IBselect.RecNo-1;
    valor  := dm.IBselect.fieldbyname('entrada').AsCurrency;
    codmov := dm.IBselect.fieldbyname('codmov').AsString;
    codES  := dm.IBselect.fieldbyname('codentradasaida').AsString ;

    if codES = '0' then begin
      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Text := ('select * from contasreceber where trim(HISTORICO) = :HIS and vencimento = :venc');
      dm.IBQuery1.ParamByName('HIS').AsString    := trim(dm.IBselect.FieldByName('HISTORICO').AsString);
      dm.IBQuery1.ParamByName('venc').AsDateTime := dm.IBselect.fieldbyname('vencimento').AsDateTime;
      dm.IBQuery1.Open;

      if not dm.IBQuery1.IsEmpty then begin
        if dm.IBQuery2.RecordCount = 1 then begin
          dm.IBQuery2.Close;
          dm.IBQuery2.SQL.Text := ('update contasreceber set pago=0,valor=total,data=vencimento,saldo=0 where trim(HISTORICO) = :HIS and vencimento = :venc');
          dm.IBQuery2.ParamByName('HIS').AsString    := trim(dm.IBselect.FieldByName('HISTORICO').AsString);
          dm.IBQuery2.ParamByName('venc').AsDateTime := dm.IBselect.fieldbyname('vencimento').AsDateTime;
          dm.IBQuery2.ExecSQL;
          dm.IBQuery2.Transaction.Commit;
          dm.IBselect.Open;
          try
            dm.IBQuery2.ExecSQL;
            dm.IBQuery2.Transaction.Commit;
            dm.IBselect.Open;
          except
            on e:exception do begin
              dm.IBQuery2.Transaction.Rollback;
              MessageDlg('Ocorreu um Erro: ' + e.Message, mtInformation, [mbOK], 1);
              exit;
            end;
          end;
        end
        else begin
          dm.IBQuery2.Close;
          dm.IBQuery2.SQL.Clear;
          dm.IBQuery2.SQL.Text := ('update contasreceber set pago=0,valor=valor+:total where trim(HISTORICO) = :HIS and vencimento = :venc');
          dm.IBQuery2.ParamByName('total').AsCurrency := dm.IBselect.fieldbyname('entrada').AsCurrency;
          dm.IBQuery2.ParamByName('HIS').AsString  := trim(dm.IBselect.FieldByName('HISTORICO').AsString);
          dm.IBQuery2.ParamByName('venc').AsDateTime := dm.IBselect.fieldbyname('vencimento').AsDateTime;
          dm.IBQuery2.ExecSQL;
          try
            dm.IBQuery2.Transaction.Commit;
            dm.IBselect.Open;
          except
            on e:exception do begin
              dm.IBQuery2.Transaction.Rollback;
              MessageDlg('Ocorreu um Erro: ' + e.Message, mtInformation, [mbOK], 1);
              exit;
            end;
          end;
        end;
      end;

      dm.IBQuery2.close;
      dm.IBQuery2.SQL.Text := ('delete from caixa where codmov='+codmov);
      try
        dm.IBQuery2.ExecSQL;
        dm.IBQuery2.Transaction.Commit;
        dm.IBselect.Close;
        dm.IBselect.Open;
        dm.IBselect.FieldByName('codmov').Visible:=false;
        funcoes.FormataCampos(dm.ibselect,2,'',2);
        desabilitaCampos;
      except
        on e:exception do begin
          dm.IBQuery2.Transaction.Rollback;
          MessageDlg('Ocorreu um Erro: ' + e.Message, mtInformation, [mbOK], 1);
          exit;
        end;
      end;
      dm.IBselect.DisableControls;
      dm.IBselect.First;
      dm.IBselect.MoveBy(recno);
      dm.IBselect.EnableControls;
      exit;
    end;

    dm.IBQuery1.Close;
    dm.IBQuery1.SQL.Text := ('select * from contasreceber where cod='+dm.IBselect.FieldByName('codentradasaida').AsString);
    dm.IBQuery1.Open;
    if dm.IBQuery1.IsEmpty then begin
      dm.IBQuery2.close;
      dm.IBQuery2.SQL.Text := ('delete from caixa where codmov='+dm.IBselect.fieldbyname('codmov').AsString);
      try
        dm.IBQuery1.Close;
        dm.IBQuery2.ExecSQL;
        dm.IBQuery2.Transaction.Commit;
        dm.IBselect.Close;
        dm.IBselect.Open;
        dm.IBselect.FieldByName('codmov').Visible := false;
        funcoes.FormataCampos(dm.ibselect,2,'',2);
        desabilitaCampos;
      except
        on e:exception do begin
          dm.IBQuery2.Transaction.Rollback;
          MessageDlg('Ocorreu um Erro: ' + e.Message, mtInformation, [mbOK], 1);
          exit;
        end;
      end;
      exit;
    end
    else begin
      if ((dm.IBQuery1.FieldByName('valor').AsCurrency + dm.IBselect.FieldByName('entrada').AsCurrency) >= dm.IBQuery1.FieldByName('total').AsCurrency) and (false) then begin
        dm.IBQuery2.Close;
        dm.IBQuery2.SQL.Text := ('update contasreceber set pago=0,valor=total,data=vencimento,saldo=0 where cod='+codES);
        try
          dm.IBQuery2.ExecSQL;
          dm.IBQuery2.Transaction.Commit;
          dm.IBselect.Open;
        except
          on e:exception do begin
            dm.IBQuery2.Transaction.Rollback;
            MessageDlg('Ocorreu um Erro: ' + e.Message, mtInformation, [mbOK], 1);
            exit;
          end;
        end;
      end
      else begin
        dm.IBQuery2.Close;
        dm.IBQuery2.SQL.Text := 'select * from caixa where historico = :his';
        dm.IBQuery2.ParamByName('his').AsString := trim(dm.IBselect.fieldbyname('historico').AsString);
        dm.IBQuery2.Open;
        dm.IBQuery2.FetchAll;

        if dm.IBQuery2.RecordCount = 1 then begin
          dm.IBQuery2.Close;
          dm.IBQuery2.SQL.Text := ('update contasreceber set pago = 0,valor = total,'+
          'data = vencimento, saldo = 0, datamov = vencimento where cod='+codES);
          dm.IBQuery2.ExecSQL;
          dm.IBQuery2.Transaction.Commit;
          dm.IBselect.Open;
          try
            dm.IBQuery2.ExecSQL;
            dm.IBQuery2.Transaction.Commit;
            dm.IBselect.Open;
          except
            dm.IBQuery2.Transaction.Rollback;
          end;
        end
        else begin
          dm.IBQuery2.Close;
          dm.IBQuery2.SQL.Clear;
          dm.IBQuery2.SQL.Add('update contasreceber set pago=0,valor=valor+:total where cod='+codES);
          dm.IBQuery2.ParamByName('total').AsCurrency := dm.IBselect.fieldbyname('entrada').AsCurrency;
          dm.IBQuery2.ExecSQL;
          try
            dm.IBQuery2.Transaction.Commit;
            dm.IBselect.Open;
          except
            on e:exception do begin
              dm.IBQuery2.Transaction.Rollback;
              MessageDlg('Ocorreu um Erro: ' + e.Message, mtInformation, [mbOK], 1);
              exit;
            end;
          end;
        end;
      end;

      dm.IBQuery2.close;
      dm.IBQuery2.SQL.Text := ('delete from caixa where codmov='+codmov);
      try
        dm.IBQuery2.ExecSQL;
        dm.IBQuery2.Transaction.Commit;
        dm.IBselect.Close;
        dm.IBselect.Open;
        dm.IBselect.FieldByName('codmov').Visible:=false;
        funcoes.FormataCampos(dm.ibselect,2,'',2);
        desabilitaCampos;
      except
        on e:exception do begin
          dm.IBQuery2.Transaction.Rollback;
          MessageDlg('Ocorreu um Erro: ' + e.Message, mtInformation, [mbOK], 1);
          exit;
        end;
      end;
      dm.IBselect.DisableControls;
      dm.IBselect.First;
      dm.IBselect.MoveBy(recno);
      dm.IBselect.EnableControls;
    end;
    exit;
  end;

  if tipo = 'P' then begin
    valor := dm.IBselect.fieldbyname('saida').AsCurrency;
    codmov := dm.IBselect.fieldbyname('codmov').AsString;
    recno  := dm.IBselect.RecNo-1;
    codES  := dm.IBselect.fieldbyname('codentradasaida').AsString ;

    if codES = '0' then begin
      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Text := ('select * from contaspagar where vencimento=:venc and historico = :his');
      dm.IBQuery1.ParamByName('venc').AsDate  := dm.IBselect.fieldbyname('vencimento').AsDateTime ;
      dm.IBQuery1.ParamByName('his').AsString := dm.IBselect.fieldbyname('historico').AsString ;
      dm.IBQuery1.Open;

      if dm.IBQuery1.IsEmpty then begin
        dm.IBQuery2.SQL.Clear;
        dm.IBQuery2.SQL.Add('delete from caixa where codmov='+codmov);
        try
          dm.IBQuery2.ExecSQL;
          dm.IBQuery2.Transaction.Commit;
          dm.IBselect.Close;
          dm.IBselect.Open;
          dm.IBselect.FieldByName('codmov').Visible:=false;
          funcoes.FormataCampos(dm.ibselect,2,'',2);
          desabilitaCampos;
        except
          on e:exception do begin
            dm.IBQuery2.Transaction.Rollback;
            MessageDlg('Ocorreu um Erro: ' + e.Message, mtInformation, [mbOK], 1);
            exit;
          end;
        end;

        exit;
      end
      else begin
        dm.IBQuery1.close;
        dm.IBQuery1.SQL.Text := ('update contaspagar set pago=0,valor = valor + :valor where vencimento=:venc and historico = :his');
        dm.IBQuery1.ParamByName('valor').AsCurrency := valor;
        dm.IBQuery1.ParamByName('venc').AsDate  := dm.IBselect.fieldbyname('vencimento').AsDateTime ;
        dm.IBQuery1.ParamByName('his').AsString := dm.IBselect.fieldbyname('historico').AsString ;
        dm.IBQuery1.ExecSQL;

        dm.IBQuery1.Close;
        dm.IBQuery1.SQL.Text := ('delete from caixa where codmov= '+codmov);
        dm.IBQuery1.ExecSQL;

        try
          dm.IBQuery1.Transaction.Commit;
          dm.IBselect.Close;
          dm.IBselect.Open;
          dm.IBselect.FieldByName('codmov').Visible := false;
          dm.IBselect.FieldByName('codentradasaida').Visible:=false;
          dm.IBselect.FieldByName('tipo').Visible:=false;
          funcoes.FormataCampos(dm.ibselect,2,'',2);
          desabilitaCampos;

        except
          on e:exception do begin
            dm.IBQuery1.Transaction.Rollback;
            MessageDlg('Ocorreu um Erro: ' + e.Message, mtInformation, [mbOK], 1);
            exit;
          end;
        end ;
      end;
      exit;
    end;

    dm.IBQuery1.Close;
    dm.IBQuery1.SQL.Text := ('select * from contaspagar where cod='+codES );
    dm.IBQuery1.Open;
    if dm.IBQuery1.IsEmpty then
      begin
        dm.IBQuery2.SQL.Clear;
        dm.IBQuery2.SQL.Add('delete from caixa where codmov='+codmov);
        try
          dm.IBQuery2.ExecSQL;
          dm.IBQuery2.Transaction.Commit;
          dm.IBselect.Close;
          dm.IBselect.Open;
          dm.IBselect.FieldByName('codmov').Visible:=false;
          funcoes.FormataCampos(dm.ibselect,2,'',2);
          desabilitaCampos;
        except
          on e:exception do begin
            dm.IBQuery2.Transaction.Rollback;
            MessageDlg('Ocorreu um Erro: ' + e.Message, mtInformation, [mbOK], 1);
            exit;
          end;
        end;
    end
    else begin
      dm.IBQuery1.close;
      dm.IBQuery1.SQL.Text := ('update contaspagar set pago=0,valor = valor + :valor where cod='+codES);
      dm.IBQuery1.ParamByName('valor').AsCurrency := valor;
      dm.IBQuery1.ExecSQL;

      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Text := ('delete from caixa where codmov= '+codmov);
      dm.IBQuery1.ExecSQL;

      try
        dm.IBQuery1.Transaction.Commit;
        dm.IBselect.Close;
        dm.IBselect.Open;
        dm.IBselect.FieldByName('codmov').Visible := false;
        dm.IBselect.FieldByName('codentradasaida').Visible:=false;
        dm.IBselect.FieldByName('tipo').Visible:=false;
        funcoes.FormataCampos(dm.ibselect,2,'',2);
        desabilitaCampos;

      except
        on e:exception do begin
          dm.IBQuery1.Transaction.Rollback;
          MessageDlg('Ocorreu um Erro: ' + e.Message, mtInformation, [mbOK], 1);
          exit;
        end;
      end ;
    end;
    exit;
  end;
end;

procedure TForm32.desabilitaCampos();
begin
  dm.IBselect.FieldByName('codentradasaida').Visible := false;
  dm.IBselect.FieldByName('codmov').Visible          := false;
  dm.IBselect.FieldByName('tipo').Visible            := false;
  dm.IBselect.FieldByName('vencimento').Visible      := false;
end;


end.
