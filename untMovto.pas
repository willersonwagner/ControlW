unit untMovto;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, OleCtrls, SHDocVw, StdCtrls, Grids, DBGrids, ExtCtrls,
  Buttons, DB, JsEdit1, JsEditInteiro1, JsBotao1, JsEditNumero1, Mask,
  JsEditData1;

type
  TfrmConhecimentoFrete = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
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
    NUMDOC: JsEditInteiro;
    TRANSP: JsEditInteiro;
    DATA: JsEditData;
    SERIE: JsEditInteiro;
    CHEGADA: JsEditData;
    IND_FRETE: JsEditInteiro;
    COD_CFOP: JsEditInteiro;
    VLR_SERV: JsEditNumero;
    VLR_DESC: JsEditNumero;
    VLR_TOTAL: JsEditNumero;
    VLR_BC_ICM: JsEditNumero;
    VLR_ICMS: JsEditNumero;
    VLR_NT: JsEditNumero;
    MOD_FRETE: JsEditInteiro;
    ToolBar1: TPanel;
    JsBotao1: JsBotao;
    JsBotao2: JsBotao;
    usuario: JsEditInteiro;
    Label15: TLabel;
    chave: TMaskEdit;
    chavecte: JsEdit;
    ALIQICMS: JsEditNumero;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    procedure FormShow(Sender: TObject);
    procedure JsBotao1Click(Sender: TObject);
    procedure TRANSPKeyPress(Sender: TObject; var Key: Char);
    procedure NUMDOCKeyPress(Sender: TObject; var Key: Char);
    procedure IND_FRETEKeyPress(Sender: TObject; var Key: Char);
    procedure MOD_FRETEKeyPress(Sender: TObject; var Key: Char);
    procedure DATAEnter(Sender: TObject);
    procedure TRANSPEnter(Sender: TObject);
    procedure JsBotao2Click(Sender: TObject);
    procedure NUMDOCKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure COD_CFOPKeyPress(Sender: TObject; var Key: Char);
    procedure chaveKeyPress(Sender: TObject; var Key: Char);
  private
    procedure enviar();
    procedure cancelar();
    procedure limpa();
    function validaCFOP() : boolean;
    function adicionaRegistro : boolean;
    { Private declarations }
  public
    nunotafe, motivo : string;
    { Public declarations }
  end;

   function dlgTransferenciaCF(const nota, motivox : String):Boolean;

var
  frmConhecimentoFrete: TfrmConhecimentoFrete;

implementation

uses unit1, func, caixaLista, principal, StrUtils;

{$R *.dfm}
procedure TfrmConhecimentoFrete.cancelar();
begin
end;

procedure TfrmConhecimentoFrete.enviar();
begin
end;

function dlgTransferenciaCF(const nota, motivox : String):Boolean;
begin
end;

procedure TfrmConhecimentoFrete.FormShow(Sender: TObject);
begin
  JsEdit.SetTabelaDoBd(self, 'MOV_FRE', dm.ibquery1, 'NUMDOC, TRANSP');
end;

procedure TfrmConhecimentoFrete.JsBotao1Click(Sender: TObject);
begin
  if not validaCFOP then exit;
  //chavecte.Text := chave.Text;
  adicionaRegistro;
  //JsEdit.GravaNoBD(self, false);
  chave.Text := '';
end;

procedure TfrmConhecimentoFrete.TRANSPKeyPress(Sender: TObject;
  var Key: Char);
begin
  if key = #13 then
    begin
      if tedit(sender).Text = '' then
        begin
          tedit(sender).Text := funcoes.localizar('Localizar Transportadora','transportadora','cod,nome,cnpj, est as estado','cod','','nome','nome',true,false,false,'',300,sender);
        end;

      if tedit(sender).Text <> '' then
        begin
          dm.IBselect.Close;
          dm.IBselect.SQL.Text := 'select cod from TRANSPORTADORA where cod = :cod';
          dm.IBselect.ParamByName('cod').AsString := tedit(sender).Text;
          dm.IBselect.Open;

          if dm.IBselect.IsEmpty then
            begin
              dm.IBselect.Close;
              ShowMessage('Transportadora '+tedit(sender).Text+' não encontrada');
              abort;
              exit;
            end;
            
          dm.IBselect.Close;
          JsEdit.SelecionaDoBD(self.Name, false, ' numdoc = ' + StrNum(NUMDOC.Text) + ' and transp = ' + StrNum(tedit(sender).Text));
          CHAVE.Text := chavecte.Text;
        end;
    end;
end;

procedure TfrmConhecimentoFrete.NUMDOCKeyPress(Sender: TObject;
  var Key: Char);
begin
  if key = #27 then close;
  if key = #13 then
    begin
      if StrNum(NUMDOC.Text) <> '0' then
        begin
          exit;
          //JsEdit.SelecionaDoBD(self.Name, false, ' numdoc = ' + NUMDOC.Text);
        end;
    end;
end;

procedure TfrmConhecimentoFrete.IND_FRETEKeyPress(Sender: TObject;
  var Key: Char);
begin
  if key = #13 then
    begin
      form39 := tform39.Create(self);
      form39.ListBox1.Items.Add('0 - DO EMITENTE');
      form39.ListBox1.Items.Add('1 - DO DESTINATÁRIO/REMETENTE');
      form39.ListBox1.Items.Add('2 - DE TERCEIROS');
      form39.ListBox1.Items.Add('9 - SEM COBRANÇA DE FRETE');
      tedit(sender).Text := funcoes.lista(Sender, false);
    end;
end;

procedure TfrmConhecimentoFrete.MOD_FRETEKeyPress(Sender: TObject;
  var Key: Char);
begin
  if key = #13 then
    begin
      form39 := tform39.Create(self);
      form39.ListBox1.Items.Add('57 - CT-e');
      form39.ListBox1.Items.Add('08 - RODOVIÁRIO');
      form39.ListBox1.Items.Add('09 - AQUAVIÁRIO');
      form39.ListBox1.Items.Add('10 - AEREO');
      tedit(sender).Text := funcoes.lista(Sender, false);

      key := #0;
      if LeftStr(tedit(sender).Text, 2) = '57' then
        begin
          chave.SetFocus;
          exit;
        end;

      if StrNum(tedit(sender).Text) = '0' then
        begin
          abort;
          exit;
        end;


      JsBotao1.SetFocus;
    end;
end;

procedure TfrmConhecimentoFrete.limpa();
begin
  COD_CFOP.Text  := '2353';
  MOD_FRETE.Text := '08';
end;

procedure TfrmConhecimentoFrete.DATAEnter(Sender: TObject);
begin
  jsedit.SelecionaDoBD(self.Name, false, '(NUMDOC = '+ StrNum(NUMDOC.Text) +') and (TRANSP = '+StrNum(TRANSP.Text)+')')
end;

procedure TfrmConhecimentoFrete.TRANSPEnter(Sender: TObject);
begin
  usuario.Text := form22.codusario;
end;

procedure TfrmConhecimentoFrete.JsBotao2Click(Sender: TObject);
begin
  JsEdit.ExcluiDoBD(self.Name, 'numdoc = ' + NUMDOC.Text);
end;

procedure TfrmConhecimentoFrete.NUMDOCKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = 116) then
     begin
       tedit(sender).Text := funcoes.localizar1('Localizar Conhecimentos de Frete',' MOV_FRE m left join TRANSPORTADORA t on (t.cod = m.TRANSP) ','m.NUMDOC, m.transp as cod_transp, t.nome as transportadora, m.cod_cfop as cfop,'+
       ' m.data, m.chegada, m.VLR_TOTAL','NUMDOC','','m.data','m.data',false,false,false, 'NUMDOC', NUMDOC.Text,600,sender);
     end;
end;

function TfrmConhecimentoFrete.validaCFOP() : boolean;
begin
  Result := false;
  {if funcoes.Contido(copy(COD_CFOP.Text, 1, 1), '123') then
    begin
      Result := true;
    end;}

  if Contido(LeftStr(COD_CFOP.Text, 1), '123') = false then
    begin
      ShowMessage('O CFOP deve começar com 1, 2 ou 3');
      COD_CFOP.SetFocus;
      exit;
    end;

  if trim(serie.Text) = '' then begin
    ShowMessage('Série Inválida!');
    serie.SetFocus;
    exit;
  end;

  if VLR_SERV.getValor = 0 then begin
    ShowMessage('Valor do Frete Inválido!');
    VLR_SERV.SetFocus;
    exit;
  end;

  if VLR_TOTAL.getValor = 0 then begin
    ShowMessage('Total do Frete Inválido!');
    VLR_TOTAL.SetFocus;
    exit;
  end;



  Result := true;
end;

procedure TfrmConhecimentoFrete.COD_CFOPKeyPress(Sender: TObject;
  var Key: Char);
begin
  if key = #13 then
    begin
     if not validaCFOP then
       begin
         key := #0;
         abort;
       end;
    end;
end;

procedure TfrmConhecimentoFrete.chaveKeyPress(Sender: TObject;
  var Key: Char);
begin
  if key = #13 then JsBotao1.SetFocus;
  if key = #27 then jsedit.LimpaCampos(self.Name); 
end;

function TfrmConhecimentoFrete.adicionaRegistro : boolean;
begin
  dm.IBQuery1.Close;
  dm.IBQuery1.SQL.Text := 'update or insert into MOV_FRE(NUMDOC,TRANSP,DATA,' +
  'CHEGADA,SERIE,IND_FRETE,MOD_FRETE,COD_CFOP,VLR_TOTAL,VLR_DESC,VLR_SERV,VLR_BC_ICM, ' +
  'VLR_ICMS,VLR_NT,USUARIO,CHAVECTE, ALIQICMS) values' +
  '(:NUMDOC,:TRANSP,:DATA,:CHEGADA,:SERIE,:IND_FRETE,:MOD_FRETE,:COD_CFOP,'+
  ':VLR_TOTAL,:VLR_DESC,:VLR_SERV,:VLR_BC_ICM,:VLR_ICMS,:VLR_NT,:USUARIO,:CHAVECTE, :ALIQICMS)'  +
  ' matching(numdoc, transp)';
  dm.IBQuery1.ParamByName('NUMDOC').AsInteger    := NUMDOC.getValor;
  dm.IBQuery1.ParamByName('TRANSP').AsInteger    := TRANSP.getValor;
  dm.IBQuery1.ParamByName('DATA').AsDate         := DATA.getData;
  dm.IBQuery1.ParamByName('CHEGADA').AsDate      := CHEGADA.getData;
  dm.IBQuery1.ParamByName('SERIE').AsInteger     := SERIE.getValor;
  dm.IBQuery1.ParamByName('IND_FRETE').AsInteger := IND_FRETE.getValor;
  dm.IBQuery1.ParamByName('MOD_FRETE').AsInteger := MOD_FRETE.getValor;
  dm.IBQuery1.ParamByName('COD_CFOP').AsInteger  := COD_CFOP.getValor;
  dm.IBQuery1.ParamByName('VLR_TOTAL').AsCurrency := VLR_TOTAL.getValor;
  dm.IBQuery1.ParamByName('VLR_DESC').AsCurrency  := VLR_DESC.getValor;
  dm.IBQuery1.ParamByName('VLR_SERV').AsCurrency  := VLR_SERV.getValor;
  dm.IBQuery1.ParamByName('VLR_BC_ICM').AsCurrency := VLR_BC_ICM.getValor;
  dm.IBQuery1.ParamByName('VLR_ICMS').AsCurrency   := VLR_ICMS.getValor;
  dm.IBQuery1.ParamByName('VLR_NT').AsCurrency    := VLR_NT.getValor;
  dm.IBQuery1.ParamByName('USUARIO').AsInteger    := USUARIO.getValor;
  dm.IBQuery1.ParamByName('CHAVECTE').AsString   := CHAVE.Text;
  dm.IBQuery1.ParamByName('ALIQICMS').AsCurrency   := ALIQICMS.getValor;
  dm.IBQuery1.ExecSQL;
  dm.IBQuery1.Transaction.Commit;

  JsEdit.LimpaCampos(self.Name);

end;



end.
