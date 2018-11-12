unit consultaOrdem;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, DBGrids, DB, IBCustomDataSet, ibquery, jsedit1, ExtCtrls, classes1;

type
  TForm55 = class(TForm)
    DBGrid1: TDBGrid;
    DataSource1: TDataSource;
    Panel1: TPanel;
    procedure FormShow(Sender: TObject);
    procedure DBGrid1KeyPress(Sender: TObject; var Key: Char);
    procedure FormCreate(Sender: TObject);
    procedure DBGrid1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    procedure abretabela();
    { Private declarations }
  public
    separaPeca, finalizaVenda, orcamento, consulta : boolean;
    retorno, ordem, condicao : String;
    { Public declarations }
  end;

var
  Form55: TForm55;

implementation

uses unit1, func, cadcliente, cadfrabricante, vendas, principal;
{$R *.dfm}

procedure TForm55.abretabela();
begin
  dm.IBQueryServico.Close;
  dm.IBQueryServico.SQL.Text := 'select s.cod, s.data, c.nome as cliente, s.cliente as cliente1, s.equip, s.marca, s.modelo,' +
  's.serie, s.tecnico, s.defeito, s.situacao, s.diag, s.obs, s.h_ent, s.saida, pago, s.vendedor, s.parecer,' +
  's.h_sai, s.ordem, u.nome as usuario from servico s left join cliente c on (s.cliente = c.cod) left join ' +
  'usuario u on (u.cod = s.usuario) ' + condicao + ' ' + ordem;
  dm.IBQueryServico.Open;

  dm.IBQueryServico.FieldByName('cliente1').Visible := false;
  dm.IBQueryServico.FieldByName('saida').Visible    := false;

  funcoes.FormataCampos(dm.IBQueryServico, 2, '', 2);

  DataSource1.DataSet := dm.IBQueryServico;
  DBGrid1.SelectedIndex := funcoes.buscaFieldDBgrid1('cliente', DBGrid1);
  exit;
  DBGrid1.DataSource.DataSet.Close;
  DBGrid1.DataSource.DataSet.Open;
  DBGrid1.DataSource.DataSet.Filtered := true;
  funcoes.FormataCampos(tibquery(DBGrid1.DataSource.DataSet), 2, '', 2);
end;

procedure TForm55.FormShow(Sender: TObject);
begin
  if ordem = '' then ordem := 'order by c.nome';
  abretabela();
end;

procedure TForm55.DBGrid1KeyPress(Sender: TObject; var Key: Char);
var
  h_sai, sim, data, nota, cod : String;
  ordem : TOrdem;
begin
  if key = #27 then close;
  if key = #32 then
    begin

      sim := DBGrid1.SelectedField.DisplayName;
      if ((sim = 'DATA') or (sim = 'H_ENT') or (sim = 'PAGO') or (sim = 'H_SAI')) then exit;

      //if (UpperCase(DBGrid1.SelectedField.DisplayName) = 'CLIENTE') then
      //  begin
          nota := funcoes.dialogo('normal',0,''+ #8 + #13+ #27,0,false,'','Control For Windows','Selecionar por:','');
          if nota = '*' then exit;

          if sim = 'CLIENTE' then sim := 'c.nome'
           else sim := 's.' + sim;

          dm.IBQuery3.Close;
          dm.IBQuery3.SQL.Clear;
          //dm.IBQuery3.SQL.Add('select p.cod, nome, p.codbar from produto p join codbarras c on ((c.cod = p.cod)) where (p.codbar like '+QuotedStr('%'+ acc +'%')+') or (nome like '+ QuotedStr('%'+acc+'%') +') or ((c.codbar like '+QuotedStr('%'+ acc +'%')+') and (c.cod = p.cod))');
          dm.IBQuery3.SQL.Add('select s.cod, s.data, c.nome as cliente, equip, marca from servico s inner join cliente c on (c.cod = s.cliente) where '+ sim +' like ''%'+ nota +'%''');
          dm.IBQuery3.Open;

          if dm.IBQuery3.IsEmpty then
            begin
              dm.IBQuery3.Close;
              ShowMessage(NOTA + ' Não Encontrado');
              exit;
            end;

          sim := funcoes.busca(dm.IBQuery3, nota,'COD NOME CODBAR', 'cod' , '');
          if sim = '' then exit;
          DBGrid1.DataSource.DataSet.Locate('cod', sim, []);
       // end;
    end;

  if key = #13 then
    begin
      if consulta then
        begin
          retorno := DBGrid1.DataSource.DataSet.FieldByName('cod').AsString;
          close;
          exit;
        end;

      if self.separaPeca then
        begin
          cod := DBGrid1.DataSource.DataSet.FieldByName('cod').AsString;
          if DBGrid1.DataSource.DataSet.IsEmpty then exit;

          funcoes.valordg := '';
          if not funcoes.abreVendaSeparaPecasOrdemDeServico(finalizaVenda, orcamento) then exit;

          abretabela();
          DBGrid1.DataSource.DataSet.Locate('cod', cod, []);
            //else ShowMessage('verdade');
          if finalizaVenda then
            begin
              if funcoes.valordg = 'SX' then exit;
              
              data := funcoes.dialogo('data',0,'',0,true,'',Application.Title,'Confirme a Data de Saída:',FormatDateTime('dd/mm/yy', form22.datamov));
              if data = '*' then data := formataDataDDMMYY(form22.datamov);
              //if data = '*' then exit;

              h_sai := funcoes.dialogo('mask',100,'!00:00;1;_',100,false,'','Control For Windows','Confirme a Hora de Saída',FormatDateTime('hh:mm', now));
              if h_sai = '*' then h_sai := FormatDateTime('hh:mm', now);
              //if h_sai = '*' then exit;

              sim := funcoes.dialogo('generico',0,'SN',0,true,'S','Control For Windows','Confirma Impressão da Ordem de Serviço','S') ;
              //if (sim = '*') then exit;


              dm.IBQuery3.Close;
              dm.IBQuery3.SQL.Text := 'update servico set saida = :saida, h_sai = :sai where cod = :cod';
              dm.IBQuery3.ParamByName('saida').AsDate := StrToDateDef(data, form22.datamov);
              dm.IBQuery3.ParamByName('sai').AsTime   := StrToTimeDef(h_sai, now);
              dm.IBQuery3.ParamByName('cod').AsString := cod;
              try
               dm.IBQuery3.ExecSQL;
               dm.IBQuery3.Transaction.Commit;
              except
              end;

              abretabela();

              if sim = 'S' then
                begin
                  if funcoes.lerServicoNoBdEcriaUmObjetoOrdem(cod, ordem) then funcoes.imprimeOrdemDeServico(ordem, false);
                end;
            end;
          exit;
        end;
        
      if DBGrid1.SelectedField.DisplayName = 'CLIENTE' then
        begin
          dm.IBQuery1.Close;
          dm.IBQuery1.SQL.Clear;
          dm.IBQuery1.SQL.Add('select cod from cliente where cod = :cod');
          dm.IBQuery1.ParamByName('cod').AsString := DBGrid1.DataSource.DataSet.FieldByName('cliente1').AsString;
          dm.IBQuery1.Open;

          if dm.IBQuery1.IsEmpty then
            begin
              dm.IBQuery1.Close;
              ShowMessage('Cliente '+ DBGrid1.DataSource.DataSet.FieldByName('cliente1').AsString + ' Não Encontrado');
              exit;
            end;


          form16 := tform16.Create(self);
          funcoes.CtrlResize(tform(form16));
          jsedit.SetTabelaDoBd(form16, 'cliente', dm.IBQuery1);
          form16.cod.Text := DBGrid1.DataSource.DataSet.FieldByName('cliente1').AsString;
          jsedit.SelecionaDoBD(form16.Name);
          form16.ShowModal;
          JsEdit.LiberaMemoria(form16);

          abretabela();
        end;
    end;
end;

procedure TForm55.FormCreate(Sender: TObject);
begin
  separaPeca      := false;
  finalizaVenda   := false;
  orcamento       := false;
  consulta        := false;
  retorno         := '';
end;

procedure TForm55.DBGrid1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  cod, sim : String;
begin
  if key = 114 then
    begin
      cod := DBGrid1.DataSource.DataSet.fieldbyname('cod').AsString;
      dm.IBQuery3.Close;
      dm.IBQuery3.SQL.Text := 'select venda from servico where cod = :cod';
      dm.IBQuery3.ParamByName('cod').AsString := cod;
      dm.IBQuery3.Open;

      cod := dm.IBQuery3.fieldbyname('venda').AsString;
      dm.IBQuery3.Close;
      dm.IBQuery3.SQL.Text := 'select i.cod, p.nome, i.quant, i.p_venda, i.total from item_venda i inner join produto p on (p.cod = i.cod) where i.nota = :nota';
      dm.IBQuery3.ParamByName('nota').AsString := cod;
      dm.IBQuery3.Open;

      sim := funcoes.busca(dm.IBQuery3, cod,'COD NOME CODBAR', 'cod' , '');
      if sim = '' then exit;
      //DBGrid1.DataSource.DataSet.Locate('cod',sim,[loPartialKey]);
    end;
end;

end.

