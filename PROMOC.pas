unit promoc;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, JsEdit1, JsEditInteiro1, Buttons, JsBotao1, ExtCtrls,
  Grids, DBGrids, JsEditNumero1, Mask, JsEditData1, DB, IBDatabase,
  IBCustomDataSet, IBQuery;

type
  Tpromocao = class(TForm)
    Label4: TLabel;
    Label5: TLabel;
    nomeProduto: TLabel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    DBGrid1: TDBGrid;
    ds: TDataSource;
    IBQuery1: TIBQuery;
    IBTransaction1: TIBTransaction;
    doc: JsEditInteiro;
    tipo: JsEditInteiro;
    cod: JsEditInteiro;
    codgru: JsEditInteiro;
    QUANT: JsEditNumero;
    p_venda: JsEditNumero;
    ToolBar1: TPanel;
    JsBotao1: JsBotao;
    JsBotao2: JsBotao;
    ckproduto: TRadioButton;
    ckgrupo: TRadioButton;
    data: JsEditData;
    USUARIO: JsEditInteiro;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure codKeyPress(Sender: TObject; var Key: Char);
    procedure JsBotao1Click(Sender: TObject);
    procedure p_vendaKeyPress(Sender: TObject; var Key: Char);
    procedure QUANTKeyPress(Sender: TObject; var Key: Char);
    procedure codKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure JsBotao2Click(Sender: TObject);
    procedure tipoKeyPress(Sender: TObject; var Key: Char);
    procedure codEnter(Sender: TObject);
    procedure docKeyPress(Sender: TObject; var Key: Char);
    procedure QUANTEnter(Sender: TObject);
    procedure docKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure ckgrupoClick(Sender: TObject);
    procedure ckprodutoClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure DBGrid1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure DBGrid1KeyPress(Sender: TObject; var Key: Char);
  private
    quant1, deposito1 : currency;
    codi, ultCod, usarAcerto : String;
    codigos : TStringList;
    procedure habilitaCampoCODGRU(opcao : integer = 1);
    procedure abreDataSet(const cod : string = '');
    procedure gravaAcerto();
    procedure deletaPromoc(doc1 : string);
    procedure limpaTela(completo : boolean = false);
    function procuraExiste(const cod1 : String) : boolean;
    procedure adicionaCodigo();
    procedure limpa;
    { Private declarations }
  public
    cadProd : boolean;
    { Public declarations }
  end;

var
  promocao: Tpromocao;

implementation

uses Unit1, principal, func, StrUtils, caixaLista;

{$R *.dfm}
procedure Tpromocao.limpaTela(completo : boolean = false);
begin
end;

procedure Tpromocao.gravaAcerto();
begin
end;

procedure Tpromocao.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  jsedit.LiberaMemoria(self);
end;

procedure Tpromocao.FormCreate(Sender: TObject);
begin
  cadProd := false;
  IBQuery1.Database              := dm.bd;
  IBTransaction1.DefaultDatabase := dm.bd;
end;

procedure Tpromocao.FormShow(Sender: TObject);
begin
  jsedit.SetTabelaDoBd(self, 'PROMOC1', dm.IBQuery1, 'doc');
  abreDataSet('0');

  if cadProd then begin
    cod.SetFocus;
    exit;
  end;

  doc.SetFocus;
end;

procedure Tpromocao.codKeyPress(Sender: TObject; var Key: Char);
VAR
  COD2 : string;
begin
  if key = #13 then
    begin
      cod2 := '';
      if ckproduto.Checked then begin
        if (COD.Text = '') then begin
          COD.Text := funcoes.localizar('Localizar Produto','produto','cod, nome,quant, p_venda as preco, localiza as localizacao','cod','','nome','nome',false,false,false,'',600, nil);
        end;
        COD2 := COD.Text;
      end
      else begin
        codgru.Text := funcoes.localizar('Localizar Grupo de Produtos','grupoprod','cod,nome','cod','','nome','nome',true,false,false,'',300,sender);
        COD2 := codgru.Text;
      end;

      if ((cod.Visible) and (COD.Text = '')) then
        begin
          key := #0;
          exit;
        end;

      if ((codgru.Visible) and (codgru.Text = '')) then begin
        key := #0;
        exit;
      end;

      if (cod2 <> '') then
        begin
          if not procuraExiste(cod2) then
            begin
              key := #0;
              exit;
            end
          else begin
            key := #0;
            quant.SetFocus;
          end;
        end;
    end;
end;

procedure Tpromocao.abreDataSet(const cod : string = '');
begin
  IBQuery1.Close;
  IBQuery1.SQL.Text := 'select doc as documento,IIF(cod > 0, COD, CODGRU) as codigo, quant, p_venda '+ IfThen(tipo.Text <> '0', ' as porcentagem', '') +' from promoc1 where cod = :cod';
  IBQuery1.ParamByName('cod').AsString := StrNum(cod);
  IBQuery1.Open;

  funcoes.FormataCampos(IBQuery1, 3, '', 3);
end;

function Tpromocao.procuraExiste(const cod1 : String) : boolean;
begin
  Result := false;
  {dm.IBselect.Close;
  dm.IBselect.SQL.Text := 'select cod from promoc where cod = :cod';
  dm.IBselect.ParamByName('cod').AsString := StrNum(cod1);
  dm.IBselect.Open;

  if not dm.IBselect.IsEmpty then Result := true;}

  if ckproduto.Checked then begin
    dm.IBselect.Close;
    dm.IBselect.SQL.Text := 'select nome, p_venda from produto where cod = :cod';
    dm.IBselect.ParamByName('cod').AsString := StrNum(cod1);
    dm.IBselect.Open;

    nomeProduto.Caption := trim(dm.IBselect.fieldbyname('nome').AsString) + #13 +
    FormatCurr('#,###,###0.00', dm.IBselect.fieldbyname('p_venda').AsCurrency);
    dm.IBselect.Close;
    Result := true;
  end
  else begin
    dm.IBselect.Close;
    dm.IBselect.SQL.Text := 'select nome from GRUPOPROD where cod = :cod';
    dm.IBselect.ParamByName('cod').AsString := StrNum(cod1);
    dm.IBselect.Open;

    nomeProduto.Caption := 'Grupo: ' + trim(dm.IBselect.fieldbyname('nome').AsString);
    dm.IBselect.Close;
    Result := true;
  end;
end;

procedure Tpromocao.deletaPromoc(doc1 : string);
begin
  if MessageDlg('Deseja Excluir o Registro ' + StrNum(doc1) + ' ?', mtConfirmation, [mbYes, mbNo], 1) = idno then exit;

  dm.IBQuery1.Close;
  dm.IBQuery1.SQL.Text := 'delete from promoc1 where doc = :doc';
  dm.IBQuery1.ParamByName('doc').AsString := StrNum(doc1);
  dm.IBQuery1.ExecSQL;
  dm.IBQuery1.Transaction.Commit;
  limpa;
end;

procedure Tpromocao.adicionaCodigo();
begin
end;

procedure Tpromocao.JsBotao1Click(Sender: TObject);
var
  cod1 : String;
begin
  if quant.getValor = 0 then
    begin
      quant.SetFocus;
      exit;
    end;

  if p_venda.getValor = 0 then
    begin
      p_venda.SetFocus;
      exit;
    end;

  if cod.Text    = '' then cod.Text    := '0';
  if codgru.Text = '' then codgru.Text := '0';

  if StrNum(data.Text) = '0' then data.Text := FormatDateTime('dd/mm/yyyy', form22.datamov);

  USUARIO.Text := FORM22.codusario;
  cod1 := cod.Text;
  jsedit.GravaNoBD(self);
  abreDataSet(cod1);
  if cadProd then begin
    doc.Text  := '0';
    tipo.Text := '1';
    cod.Text  := cod1;
    cod.SetFocus;
  end;
end;

procedure Tpromocao.p_vendaKeyPress(Sender: TObject; var Key: Char);
begin
  if key = #13 then
    begin
      if p_venda.getValor = 0 then
        begin
          p_venda.SetFocus;
          abort;
        end;
    end;

  if key = #13 then JsBotao1.SetFocus;
end;

procedure Tpromocao.QUANTKeyPress(Sender: TObject; var Key: Char);
begin
  if key = #13 then
    begin
      if quant.getValor = 0 then
        begin
          quant.SetFocus;
          abort;
        end;
    end;
end;

procedure Tpromocao.codKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key = 116 then
    begin
      //COD.Text := funcoes.localizar('Localizar Promoção','promoc pr left join produto p on (p.cod = pr.cod)','p.cod, p.nome, pr.quant, pr.p_venda as preco','cod','','nome','nome',false,false,false,'',600, nil);
    end;
end;

procedure Tpromocao.DBGrid1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  cod1 : String;
begin
  if key = 46 then begin
    cod1 := cod.Text;
    doc.Text := IBQuery1.FieldByName('documento').AsString;
    JsBotao2.Click;

    if cadProd then begin
      doc.Text  := '0';
      tipo.Text := '1';
      cod.Text  := cod1;
      cod.SetFocus;
    end;
  end;
end;

procedure Tpromocao.DBGrid1KeyPress(Sender: TObject; var Key: Char);
begin
  if key = #27 then cod.SetFocus;
end;

procedure Tpromocao.JsBotao2Click(Sender: TObject);
var
  cod1 : String;
begin
  if doc.Text = '0' then begin
    ShowMessage('Preencha um numero de Documento, para excluir entre na tabela e Pressione DELETE');
    exit;
  end;

  deletaPromoc(doc.Text);

  if cadProd then abreDataSet(cod.Text);
end;

procedure Tpromocao.tipoKeyPress(Sender: TObject; var Key: Char);
begin
  if (key = #13)then begin
    form39 := tform39.Create(self);
    form39.ListBox1.Items.Add('1 - Porcentagem');
    {form39.ListBox1.Items.Add('0 - Preço de Venda');
    form39.ListBox1.Items.Add('1 - Porcentagem');
    form39.ListBox1.Items.Add('2 - Porcentagem e Grupo');}
    tedit(sender).Text := funcoes.lista(Sender, false);
    if tedit(sender).Text = '*' then begin
      tedit(sender).Text := '0';
      key := #0;
    end;

    if tedit(sender).Text <> '' then begin
      key := #0;

      if cod.Visible then cod.SetFocus;
      if codgru.Visible then codgru.SetFocus;

    end;
  end;


end;

procedure Tpromocao.codEnter(Sender: TObject);
begin
  if tipo.Text = '0' then Label5.Caption := 'Preço'
    else Label5.Caption := 'Porcentagem %'
end;

procedure Tpromocao.docKeyPress(Sender: TObject; var Key: Char);
begin
  if key = #27 then close;
  if key = #13 then begin
    //jsedit.SelecionaDoBD(self.Name, true, 'where doc = ' + strnum(doc.Text));
  end;
end;

procedure Tpromocao.QUANTEnter(Sender: TObject);
begin
  abreDataSet(cod.Text);
end;

procedure Tpromocao.docKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key = 116 then
    begin
      doc.Text := funcoes.localizar('Localizar Promoção','promoc1 pr left join produto p on (p.cod = pr.cod)','pr.doc,p.cod, p.nome, pr.quant, pr.p_venda as preco','doc','','nome','nome',false,false,false,'',600, nil);
    end;
end;

procedure Tpromocao.ckgrupoClick(Sender: TObject);
begin
  habilitaCampoCODGRU(2);
  Label1.Caption := 'Grupo:';
end;

procedure Tpromocao.ckprodutoClick(Sender: TObject);
begin
  if self.FindComponent('cod') = nil then begin
    habilitaCampoCODGRU(1);
    Label1.Caption := 'Cód. Produto:';
  end;
end;

procedure Tpromocao.habilitaCampoCODGRU(opcao : integer = 1);
begin
  if opcao = 1 then begin
     codgru.Visible := false;
     cod.Visible    := true;
  end
  else begin
    cod.Visible := false;
    codgru.Left := cod.Left;
    codgru.Top  := cod.Top;
    codgru.Visible := true;
  end;
end;

procedure Tpromocao.limpa;
begin
  doc.Text := '';
  cod.Text := '';
  QUANT.setValor(0);
  p_venda.setValor(0);
  doc.Enabled := true;
  doc.SetFocus;
end;

end.
