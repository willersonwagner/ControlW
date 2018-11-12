unit cadproduto;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, JsBotao1, ToolWin, ComCtrls, JsEdit1,
  JsEditInteiro1, ExtCtrls,  JsEditCodLista1, JsEditNumero1, Grids, DBGrids, DB,
  DBClient, ibquery, funcoesdav, untnfceForm;
type
  TForm9 = class(TForm)
    painel: TPanel;
    Label2: TLabel;
    Label1: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    Label20: TLabel;
    Label21: TLabel;
    Label22: TLabel;
    Label24: TLabel;
    Label25: TLabel;
    Label27: TLabel;
    Label28: TLabel;
    Label29: TLabel;
    Label30: TLabel;
    Label31: TLabel;
    Label11: TLabel;
    Label37: TLabel;
    Label36: TLabel;
    Label38: TLabel;
    Label32: TLabel;
    Label39: TLabel;
    Label26: TLabel;
    cod: JsEditInteiro;
    nome: JsEdit;
    fornec: JsEditInteiro;
    fabric: JsEditInteiro;
    grupo: JsEditInteiro;
    p_compra: JsEditNumero;
    GroupBox1: TGroupBox;
    Label7: TLabel;
    Label8: TLabel;
    basecred: JsEditNumero;
    credicm: JsEditNumero;
    GroupBox2: TGroupBox;
    Label9: TLabel;
    Label10: TLabel;
    basedeb: JsEditNumero;
    debicm: JsEditNumero;
    agregado: JsEditNumero;
    frete: JsEditNumero;
    encargos: JsEditNumero;
    lucro: JsEditNumero;
    p_venda: JsEditNumero;
    quant: JsEditNumero;
    deposito: JsEditNumero;
    p_venda1: JsEditNumero;
    comissao: JsEditNumero;
    unid: JsEdit;
    emb: JsEdit;
    estoque: JsEditNumero;
    aliquota: JsEditInteiro;
    dev_icm: JsEditNumero;
    GroupBox3: TGroupBox;
    is_pis: JsEdit;
    COD_ISPIS: JsEdit;
    fracao: JsEditNumero;
    aplic: JsEdit;
    refori: JsEdit;
    classif: JsEdit;
    localiza: JsEdit;
    codbar: JsEdit;
    equiva: JsEdit;
    Edit1: TEdit;
    OBS: JsEdit;
    igual: JsEdit;
    ToolBar1: TPanel;
    Label33: TLabel;
    ulticod: TLabel;
    Label35: TLabel;
    JsBotao1: JsBotao;
    JsBotao2: JsBotao;
    Label34: TLabel;
    TIPO_ITEM: JsEdit;
    desconto: JsEditNumero;
    DescLabel: TLabel;
    DESC_COMP: JsEditNumero;
    Label40: TLabel;
    ICMS_SUBS: JsEditNumero;
    Label23: TLabel;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure JsEditInteiro5Exit(Sender: TObject);
    procedure JsEditInteiro14Exit(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure JsBotao1Click(Sender: TObject);
    procedure JsBotao2Click(Sender: TObject);
    procedure lucKeyPress(Sender: TObject; var Key: Char);
    function porcentagem(v1:extended;v2:extended) : extended;
    procedure codKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure codKeyPress(Sender: TObject; var Key: Char);
    procedure grupoKeyPress(Sender: TObject; var Key: Char);
    procedure fornecKeyPress(Sender: TObject; var Key: Char);
    procedure fabricKeyPress(Sender: TObject; var Key: Char);
    procedure JsEditInteiro1KeyPress(Sender: TObject; var Key: Char);
    procedure codEnter(Sender: TObject);
    procedure is_pisKeyPress(Sender: TObject; var Key: Char);
    procedure aliquotaKeyPress(Sender: TObject; var Key: Char);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure codbarKeyPress(Sender: TObject; var Key: Char);
    procedure basecredExit(Sender: TObject);
    procedure lucroKeyPress(Sender: TObject; var Key: Char);
    procedure p_vendaKeyPress(Sender: TObject; var Key: Char);
    procedure nomeEnter(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure codbarKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure codbarEnter(Sender: TObject);
    procedure codbarExit(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure COD_ISPISKeyPress(Sender: TObject; var Key: Char);
    procedure dev_icmKeyPress(Sender: TObject; var Key: Char);
    procedure TIPO_ITEMKeyPress(Sender: TObject; var Key: Char);
    procedure igualKeyPress(Sender: TObject; var Key: Char);
    procedure Edit1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
   // procedure porcentagem(jsedit a,jsedit b);
  private
    componenteRetorno : JsEdit;
    valorRetorno : string;
    codbar1 : TStringList;
    ok : boolean;
    flag : smallint;
    consultaCompleta : boolean;
    function insereDeleted() : boolean;
    function verificaPodeExcluir() : boolean;
    procedure atualizaCodBarAdicionais(codProd : String);
    function addCodBarStringList(cod, codbar : String) : boolean;
    procedure carregaCodBarAdicionais();
    function verificaCodbarNoProduto(cod, codbar : string) : String;
    procedure atualizaProdSMALLSOFT(codigo : string);
    procedure buscaCodBar;
    function existeCodBar(codBar2 : String) : boolean;
    function addCodBar(cod, codbar : String) : boolean;
    procedure insereIgualProduto(const cod2, igual : String);
    { Private declarations }
  public
    entrada : integer;
    RecuperarCadastro : boolean;
    function CALCPRE(var _LUCRO, _PVENDA, _DEBICM, _BASEDEB, _CREDICM, _PCOMPRA, _FRETE, _ENCARGO, _BASECRED, AGREG : JsEditNumero; icmsSubsti, descComp : currency) : currency;
    function CALCLUCRO1(var _LUCRO, _PVENDA, _DEBICM, _BASEDEB, _CREDICM, _PCOMPRA, _FRETE, _ENCARGO, _BASECRED, AGREG : JsEditNumero; icmsSubsti, descComp : currency; Key : Char) : currency;
    Procedure SetComponenteRetorno(componente : jsedit);
    Function RelSomatoria_T_(var lista1 : Tlist; dini, dfim : String; geral : currency) : AnsiString;
    function getRetorno() : String;
    procedure verificaCaracteres();
    { Public declarations }
  end;

var
  Form9: TForm9;

implementation

uses Math, Unit1, localizar, func, caixaLista, formpagtoformulario,
  buscaSelecao, principal, Unit2, dm1, StrUtils, cadfornecedor,
  cadfrabricante, cadgrupoprod, consulta, Unit60, PROMOC;

{$R *.dfm}
function TForm9.getRetorno() : String;
begin
  Result := valorRetorno;
end;

procedure TForm9.verificaCaracteres();
begin
  nome.Text := funcoes.DeletaChar(#39, nome.Text);
end;

procedure TForm9.atualizaCodBarAdicionais(codProd : String);
var
  ini, fim : smallint;
begin
  fim := codbar1.Count -1;

  for ini := 0 to fim do
    begin
      addCodBar(codProd, codbar1.ValueFromIndex[ini]);
    end;
end;

function TForm9.addCodBarStringList(cod, codbar : String) : boolean;
begin
  codbar1.Add(cod + '=' + codbar);
end;

procedure TForm9.carregaCodBarAdicionais();
begin
  codbar1.Clear;

  dm.IBselect.Close;
  dm.IBselect.SQL.Clear;
  dm.IBselect.SQL.Add('select * from codbarras where cod = :cod');
  dm.IBselect.ParamByName('cod').AsInteger := StrToIntDef(cod.Text, -1);
  dm.IBselect.Open;

  while not dm.IBselect.Eof do
    begin
      codbar1.Add(dm.IBselect.fieldbyname('cod').AsString + '=' + dm.IBselect.fieldbyname('codbar').AsString);
      dm.IBselect.Next;
    end;
  dm.IBselect.Close;
end;

function TForm9.verificaCodbarNoProduto(cod, codbar : string) : String;
var
  tes : smallint;
begin
  Result := '';
  tes := 0;

  dm.IBselect.Close;
  dm.IBselect.SQL.Clear;
  dm.IBselect.SQL.Add('select c.cod, c.codbar from produto c where ((c.codbar = :cod))');
  dm.IBselect.ParamByName('cod').AsString := codbar;
  dm.IBselect.ParamByName('cod1').AsString := cod;
  dm.IBselect.Open;

  if not dm.IBselect.IsEmpty then
    begin
      tes := 1;
    end;

  if tes = 0 then
    begin
      dm.IBselect.Close;
      dm.IBselect.SQL.Clear;
      dm.IBselect.SQL.Add('select c.cod, c.codbar from codbarras c where ((c.codbar = :cod) and (c.cod <> :cod1))');
      dm.IBselect.ParamByName('cod').AsString := codbar;
      dm.IBselect.ParamByName('cod1').AsString := cod;
      dm.IBselect.Open;

      if not dm.IBselect.IsEmpty then
        begin
          tes := 1;
        end;
    end;

  if tes = 0 then
    begin
      dm.IBselect.Close;
      exit;
    end;

  Result := 'Código de barras já foi cadastrado no produto: ' + #13 + #10;
  while not dm.IBselect.Eof do
    begin
      Result := Result + ' Código: ' + dm.IBselect.fieldbyname('cod').AsString + ' CodBarras: ' + dm.IBselect.fieldbyname('codbar').AsString + #13 + #10;
      dm.IBselect.Next;
    end;
  dm.IBselect.Close;
end;

function TForm9.addCodBar(cod, codbar : String) : boolean;
begin
  Result := false;

  dm.IBQuery4.Close;
  dm.IBQuery4.SQL.Clear;
  dm.IBQuery4.SQL.Add('update or insert into CODBARRAS(cod,codbar) values(:cod,:codbar) MATCHING(cod, codbar)');
  dm.IBQuery4.ParamByName('cod').AsString := cod;
  dm.IBQuery4.ParamByName('codbar').AsString := codbar;

  dm.IBQuery4.ExecSQL;
  dm.IBQuery4.Transaction.Commit;
  result := true;
end;

function TForm9.existeCodBar(codBar2 : String) : boolean;
var nome1 : string;
begin
  Result := false;
  if (Length(Trim(codBar2)) = 0) then
    begin
      ShowMessage('Informe um Código Válido.');
      //codbar.SetFocus;
      exit;
    end;

  dm.IBQuery3.Close;
  dm.IBQuery3.SQL.Clear;
  //dm.IBQuery3.SQL.Add('select p.cod, p.codbar, (select nome from produto where cod = p.cod) from codbarras p where (p.codbar = :cod) ');
  dm.IBQuery3.SQL.Add('select p.cod, p.codbar, (c.nome) from codbarras p left join produto c on (p.cod = c.cod) where (p.codbar = :cod) ');
  dm.IBQuery3.ParamByName('cod').AsString := codBar2;
  dm.IBQuery3.Open;

  if dm.IBQuery3.IsEmpty then
    begin
      //dm.IBQuery3.Close;
      //ShowMessage('Nenhum Registro Encontrado');
      //exit;
    end;

  form33 := TForm33.Create(self);
  form33.Caption := 'Lista de Código de Barras';
  //form33.DataSource1.DataSet := dm.IBQuery3;

  form33.ClientDataSet1.FieldDefs.Clear;
  form33.ClientDataSet1.FieldDefs.Add('COD', ftInteger);
  form33.ClientDataSet1.FieldDefs.Add('NOME',ftString,40);
  form33.ClientDataSet1.FieldDefs.Add('CODBAR',ftString,15);

  form33.DataSource1.DataSet := form33.ClientDataSet1;
  //Form33.DBGrid1.DataSource := form33.DataSource1;

  form33.ClientDataSet1.CreateDataSet;
  form33.ClientDataSet1.LogChanges := false;
  form33.campobusca := 'DESCRICAO';

  while not dm.IBQuery3.Eof do
    begin
      form33.ClientDataSet1.Open;
      form33.ClientDataSet1.Insert;
      form33.ClientDataSet1.FieldByName('cod').AsInteger := dm.IBQuery3.fieldbyname('cod').AsInteger;
      form33.ClientDataSet1.FieldByName('nome').AsString := dm.IBQuery3.fieldbyname('nome').AsString;
      form33.ClientDataSet1.FieldByName('CODBAR').AsString := dm.IBQuery3.fieldbyname('CODBAR').AsString;
      form33.ClientDataSet1.Post;
      dm.IBQuery3.Next;
    end;

  //nome1 := dm.IBQuery3.fieldbyname('nome').AsString;
  dm.IBQuery3.Close;
  dm.IBQuery3.SQL.Clear;
  dm.IBQuery3.SQL.Add('select p.cod, p.nome, p.codbar from produto p where p.codbar = :cod ');
  dm.IBQuery3.ParamByName('cod').AsString := codbar2;
  dm.IBQuery3.Open;


  while not dm.IBQuery3.Eof do
    begin
      form33.ClientDataSet1.Open;
      form33.ClientDataSet1.Insert;
      form33.ClientDataSet1.FieldByName('cod').AsInteger := dm.IBQuery3.fieldbyname('cod').AsInteger;
      form33.ClientDataSet1.FieldByName('nome').AsString := dm.IBQuery3.fieldbyname('nome').AsString;
      form33.ClientDataSet1.FieldByName('CODBAR').AsString := dm.IBQuery3.fieldbyname('CODBAR').AsString;
      form33.ClientDataSet1.Post;
      dm.IBQuery3.Next;
    end;

  {form33.ClientDataSet1.Open;
  form33.ClientDataSet1.Insert;
  form33.ClientDataSet1.FieldByName('codigo').AsInteger := dm.IBQuery3.fieldbyname('cod').AsInteger;
  form33.ClientDataSet1.FieldByName('descricao').AsString := dm.IBQuery3.fieldbyname('nome').AsString;
  form33.ClientDataSet1.FieldByName('CODBARRAS').AsString := dm.IBQuery3.fieldbyname('CODBAR').AsString;
  form33.ClientDataSet1.Post;
   }
  dm.IBQuery3.Close;
  Form33.campobusca := 'codbar1';

  form33.ShowModal;
  form33.Free;
  dm.IBQuery3.Close;


 { dm.IBQuery3.Close;
  dm.IBQuery3.SQL.Clear;
  dm.IBQuery3.SQL.Add('select c.cod, (select nome from produto p where (p.cod = c.cod)) , c.codbar from codbarras c where (codbar = :cod) ');
  dm.IBQuery3.ParamByName('cod').AsString := codbar1;
  dm.IBQuery3.Open;
  }
  Result := not dm.IBQuery3.IsEmpty;

  //form33 := TForm33.Create(self);
  //form33.campobusca := 'codbar';
  //form33.DataSource1.DataSet := dm.IBQuery3;
  //form33.ShowModal;
  //form33.Free;
  //dm.IBQuery3.Close;

  //dm.IBQuery3.Close;
end;

procedure TForm9.buscaCodBar();
var
  nome : string;
begin
  if (StrToIntDef(cod.Text, 0) = 0) then
    begin
      ShowMessage('Informe um Código Válido.');
      //cod.SetFocus;
      exit;
    end;

  dm.IBQuery3.Close;
  dm.IBQuery3.SQL.Clear;
  dm.IBQuery3.SQL.Add('select c.cod, (select nome from produto p where (p.cod = c.cod)) , c.codbar from codbarras c where (cod = :cod) ');
  dm.IBQuery3.ParamByName('cod').AsInteger := StrToIntDef(cod.Text, 0);
  dm.IBQuery3.Open;

  if dm.IBQuery3.IsEmpty then
    begin
      dm.IBQuery3.Close;
      ShowMessage('Nenhum Registro Encontrado');
      exit;
    end;


  form33 := TForm33.Create(self);
  form33.Caption := 'Lista de Código de Barras Produto ' + cod.Text;
  form33.DataSource1.DataSet := dm.IBQuery3
  ;

 { form33.ClientDataSet1.FieldDefs.Clear;
  form33.ClientDataSet1.FieldDefs.Add('CODIGO', ftInteger);
  form33.ClientDataSet1.FieldDefs.Add('DESCRICAO',ftString,40);
  form33.ClientDataSet1.FieldDefs.Add('CODBARRAS',ftString,15);

  form33.DataSource1.DataSet := form33.ClientDataSet1;
  //Form33.DBGrid1.DataSource := form33.DataSource1;

  form33.ClientDataSet1.CreateDataSet;
  form33.ClientDataSet1.LogChanges := false;
  form33.campobusca := 'DESCRICAO';

  while not dm.IBQuery3.Eof do
    begin
      form33.ClientDataSet1.Open;
      form33.ClientDataSet1.Insert;
      form33.ClientDataSet1.FieldByName('codigo').AsInteger := dm.IBQuery3.fieldbyname('cod').AsInteger;
      form33.ClientDataSet1.FieldByName('descricao').AsString := dm.IBQuery3.fieldbyname('nome').AsString;
      form33.ClientDataSet1.FieldByName('CODBARRAS').AsString := dm.IBQuery3.fieldbyname('CODBAR').AsString;
      form33.ClientDataSet1.Post;
      dm.IBQuery3.Next;
    end;

  nome := dm.IBQuery3.fieldbyname('nome').AsString;
  dm.IBQuery3.Close;
  dm.IBQuery3.SQL.Clear;
  dm.IBQuery3.SQL.Add('select p.cod, p.nome, p.codbar from produto p where p.cod = :cod ');
  dm.IBQuery3.ParamByName('cod').AsInteger := StrToIntDef(cod.Text, 0);
  dm.IBQuery3.Open;

  form33.ClientDataSet1.Open;
  form33.ClientDataSet1.Insert;
  form33.ClientDataSet1.FieldByName('codigo').AsInteger := dm.IBQuery3.fieldbyname('cod').AsInteger;
  form33.ClientDataSet1.FieldByName('descricao').AsString := dm.IBQuery3.fieldbyname('nome').AsString;
  form33.ClientDataSet1.FieldByName('CODBARRAS').AsString := dm.IBQuery3.fieldbyname('CODBAR').AsString;
  form33.ClientDataSet1.Post;

  dm.IBQuery3.Close;
  }Form33.campobusca := 'codbar';

  form33.ShowModal;
  form33.Free;
  dm.IBQuery3.Close;

end;

function TForm9.CALCLUCRO1(var _LUCRO, _PVENDA, _DEBICM, _BASEDEB, _CREDICM, _PCOMPRA, _FRETE, _ENCARGO, _BASECRED, AGREG : JsEditNumero; icmsSubsti, descComp : currency; Key : Char) : Currency;
var
  _FRE, _ENC, _LUC, _CREDICM1, _PVENDA1, _BASEDEB1, _DEBICM1, _PCOMPRA1, _FRETE1,
  _ENCARGO1, AGREG1, _LUCRO1, icmsSubsti1, descComp1, TMP  : currency;
  _COM : integer;
  MAT1 : array[1..3] of currency;
  arq  : TStringList;
begin
  IF _PCOMPRA.getValor = 0 then exit;

  ARQ := TStringList.Create;

  Result := 0;
  _CREDICM.setValor(ARREDONDA((_PCOMPRA.getValor * _BASECRED.getValor) / 100, 2));
  _LUC := _LUCRO.getValor;
  _COM := StrToIntDef(ConfParamGerais.Strings[25], 1);

  //if cod.Text = '0' then _COM := 1;

  IF (_BASEDEB.getValor + _BASECRED.getValor + _FRETE.getValor + _ENCARGO.getValor + AGREG.getValor + icmsSubsti + descComp) = 0 then begin
    //if (_PCOMPRA.getValor = 0) and (_LUCRO.getValor = 0)  then exit;
    //_PVENDA1 := _PCOMPRA.getValor + (_PCOMPRA.getValor * _LUCRO.getValor /100);
    //_PVENDA.Text := formataCurrency(_PVENDA1);
    //exit;
  end;

  _FRE := ((AGREG.getValor * _PCOMPRA.getValor) / 100);
  _FRE := ((_FRE / _PVENDA.getValor) * 100);
  _ENC := ((_FRETE.getValor * _PCOMPRA.getValor) / 100);
  _ENC := ((_ENC / _PVENDA.getValor) * 100);
  _ENC := _ENC - ((_CREDICM.getValor /_PVENDA.getValor) * 100) + (_ENCARGO.getValor * 1.1) + _BASEDEB.getValor;
  _FRE := ARREDONDA(100 - _FRE - _ENC, 2);
  IF (_LUCRO.getValor > 70) AND (_COM = 3) then
    begin
      ShowMessage('Esta fórmula de calculo de lucro está ajustada para ' +
      'comparar lucro com o Preço de Venda, sendo assim o lucro máximo ' +
      FormatCurr('#,###,###0.00', _FRE) + ' possível para cálculo.' );
//      lucro.Text := FormatCurr('#,###,###0.00', _FRE);
      //_LUCRO := _FRE;
      exit;
    end;

  MAT1[1] := _PCOMPRA.getValor;
  MAT1[2] := _PCOMPRA.getValor - _CREDICM.getValor;
  MAT1[3] := _PVENDA.getValor;

  IF (_LUCRO.getValor <> 0) then
    begin
      _PVENDA.Text := formataCurrency(_PCOMPRA.getValor + ((_PCOMPRA.getValor * _LUCRO.getValor) / 100));
      //_PVENDA.setValor(_PCOMPRA.getValor + ((_PCOMPRA.getValor * _LUCRO.getValor) / 100));
      //_PVENDA.Text := FormatCurr('#,###,###0.00', _PVENDA1);
    end;

  //_PVENDA.setValor(_PVENDA.getValor);
  _BASEDEB1 := _BASEDEB.getValor;
  _PVENDA1  := _PVENDA.getValor;
  _PCOMPRA1 := _PCOMPRA.getValor;
  AGREG1    := AGREG.getValor;
  _FRETE1   := _FRETE.getValor;
  _ENCARGO1 := _ENCARGO.getValor;
  _CREDICM1 := _CREDICM.getValor;
  _DEBICM1  := _DEBICM.getValor; 


  WHILE true do
    begin
      IF _BASEDEB1 <> 0 then begin
        if AGREG1 = 0 then begin
          _DEBICM1 := (ARREDONDA(((_PVENDA1 * _BASEDEB1)/100), 2));
        end
        else begin
          _DEBICM1 := (ARREDONDA(((_PCOMPRA1 + (_PCOMPRA1 * AGREG1/100)) * _BASEDEB1 / 100 ), 2));
        end;
      end;

      _FRE       := ARREDONDA((_PCOMPRA1 * _FRETE1)/100, 2);
      icmsSubsti1 := ARREDONDA((_PCOMPRA1 * icmsSubsti)/100, 2);
      descComp1   := ARREDONDA((_PCOMPRA1 * descComp)/100, 2);

      _ENC := ARREDONDA((_PVENDA1  * _ENCARGO1)/100, 2);
      MAT1[3] := _PVENDA1;
      _LUCRO1 := _PVENDA1 - (_PCOMPRA1 - _CREDICM1 - descComp1) - _DEBICM1 - _FRE - _ENC - icmsSubsti1;

      TMP :=  _LUCRO1;
      _LUCRO1 := (ARREDONDA(_LUCRO1 / MAT1[_COM] * 100, 2));
      //ARQ.Add(CurrToStr(_LUCRO1) + '=' + CurrToStr(_LUC));
      IF _LUCRO1 >= _LUC then Break;
      _PVENDA1 := (_PVENDA1 + 0.001);
   END;

   {ARQ.SaveToFile('ARQ.TXT');
   ShowMessage('--------------------'+#13+ CurrToStr(TMP) + #13 + CurrToStr(MAT1[_COM])+ #13 +
   '_PVENDA1='  + CurrToStr(_PVENDA1) + #13 +
   '_PCOMPRA1=' + CurrToStr(_PCOMPRA1) + #13 +
   '_CREDICM1=' + CurrToStr(_CREDICM1) + #13 +
   'descComp1=' + CurrToStr(descComp1) + #13 +
   '_DEBICM1=' + CurrToStr(_DEBICM1) + #13 +
   '_FRE=' + CurrToStr(_FRE) + #13 +
   '_ENC=' + CurrToStr(_ENC) + #13 +
   'icmsSubsti1=' + CurrToStr(icmsSubsti1));}

   //_PVENDA.setValor(_PVENDA1);
   _PVENDA.Text := formataCurrency(_PVENDA1);
   _LUCRO.setValor(_LUCRO1);
   _DEBICM.setValor(_DEBICM1);
   _LUC := _PVENDA1 - (_PCOMPRA1 - _CREDICM1) - _DEBICM1 - _FRE - _ENC;
   Result := _LUC;

   if _PVENDA.getValor < 0 then _PVENDA.setValor(0);
   if Result < 0 then Result := 0;

end;



function TForm9.CALCPRE(var _LUCRO, _PVENDA, _DEBICM, _BASEDEB, _CREDICM, _PCOMPRA, _FRETE, _ENCARGO, _BASECRED, AGREG : JsEditNumero; icmsSubsti, descComp : currency) : currency;
var
  _FRE, _ENC, _LUC, tmp, precoCompra : currency;
  _COM : integer;
  MAT1 : array[1..3] of currency;
begin
  if _PCOMPRA.getValor = 0 then exit;
  precoCompra := _PCOMPRA.getValor;

  Result := 0;
  _LUC := _LUCRO.getValor;
  IF precoCompra = 0 then begin
     _PCOMPRA.setValor(ARREDONDA(_PVENDA.getValor / 2, 2));
     precoCompra := _PCOMPRA.getValor;
  end;

  _CREDICM.setValor(ARREDONDA((precoCompra * _BASECRED.getValor)/100, 2));

  _COM := StrToIntDef(ConfParamGerais.Strings[25], 1);
 // if cod.Text = '0' then _COM := 1;

  //descComp := 0;
  if descComp <> 0 then descComp := precoCompra * (descComp /100);

  //icmsSubsti := 0;
  if icmsSubsti <> 0 then  icmsSubsti := precoCompra * (icmsSubsti /100);



  //SE NAO TEM PRECO DE VENDA, USA O PRECO DE COMPRA
  _PVENDA.Text := formataCurrency(iif(_PVENDA.getValor = 0, maior(_PVENDA.getvalor, precoCompra), _PVENDA.getValor));

  //_COM := IF(VAL(SUBSTR(CONFIG1, 2, 1)) = 0, 2, VAL(SUBSTR(CONFIG1, 2, 1)))
  MAT1[1] := precoCompra;
  MAT1[2] := precoCompra - _CREDICM.getValor;
  MAT1[3] := _PVENDA.getValor;


  //_PVENDA.setValor(iif(_PVENDA.getValor = 0, maior(_PVENDA.getvalor, precoCompra), _PVENDA.getValor));

  IF _BASEDEB.getValor <> 0 then begin
    if AGREG.getvalor = 0 then begin
      _DEBICM.setValor(ARREDONDA(((_PVENDA.getvalor * _BASEDEB.getvalor)/100), 2));
    end
    else begin
      _DEBICM.setValor(ARREDONDA(((precoCompra + (precoCompra * AGREG.getvalor/100)) * _BASEDEB.getvalor / 100 ), 2));
    end;
    //_DEBICM.setValor(ARREDONDA(IIF(AGREG.getvalor = 0, ((_PVENDA.getvalor * _BASEDEB.getvalor)/100), (_PCOMPRA.getvalor + (_PCOMPRA.getvalor * AGREG.getvalor/100)) * _BASEDEB.getvalor / 100 ), 2));
  end;

  _FRE := 0;
  _ENC := 0;

  if _FRETE.getValor <> 0 then
  _FRE := ARREDONDA((precoCompra * _FRETE.getValor  )/100, 2);

  if _ENCARGO.getValor <> 0 then
  _ENC := ARREDONDA((_PVENDA.getValor  * _ENCARGO.getValor)/100, 2);

  tmp := _PVENDA.getvalor - (precoCompra - _CREDICM.getValor - descComp) - _DEBICM.getValor - _FRE - _ENC - icmsSubsti;


  {ShowMessage('--------------------'+#13+ CurrToStr(TMP) + #13 + CurrToStr(MAT1[_COM])+ #13 +
   '_PVENDA1='  + CurrToStr(_PVENDA.getvalor) + #13 +
   '_PCOMPRA1=' + CurrToStr(precoCompra) + #13 +
   '_CREDICM1=' + CurrToStr(_CREDICM.getValor) + #13 +
   'descComp1=' + CurrToStr(descComp) + #13 +
   '_DEBICM1=' + CurrToStr(_DEBICM.getValor) + #13 +
   '_FRE=' + CurrToStr(_FRE) + #13 +
   '_ENC=' + CurrToStr(_ENC) + #13 +
   'icmsSubsti1=' + CurrToStr(icmsSubsti));  }
  _LUCRO.setValor(tmp);
  _LUC := tmp;


  if MAT1[_COM] > 0 then
  _LUCRO.setValor(ARREDONDA(_LUCRO.getValor / MAT1[_COM] * 100, 2));

  Result := _LUC;

  if Result < 0  then Result := 0;

end;

procedure TForm9.atualizaProdSMALLSOFT(codigo : string);
var qtd, aliq, fim, atual : integer; cbr, codSeq, _cst, _st, uni, titulo : string;
contagemErroBd : integer;
quant : currency;
begin
  try
    dmSmall.BdSmall.Connected := true;
    atual := 0;
    dm.IBselect.Close;
    dm.IBselect.SQL.Clear;
    dm.IBselect.SQL.Add('select cod, nome, unid, codbar, refori, aliquota, p_compra, p_venda, quant from produto where cod = :cod');
    dm.IBselect.ParamByName('cod').AsString := codigo;
    dm.IBselect.Open;

    //unidade
    uni := trim(copy(dm.IBselect.fieldbyname('unid').asstring, 1, 3));

         //quantidade em estoque
    quant := dm.IBselect.fieldbyname('quant').AsCurrency;
    if quant < 0 then quant := 0;
    //se a quantidade for zero ou menor informa 1000
    if (quant = 0) then quant := quant + 1000.00;

    //código de barras
    cbr := dm.IBselect.fieldbyname('codbar').AsString;
    if ((copy(cbr, 1, 1) = '2') and (length(cbr) <= 9)) then
      begin
        if (copy(cbr, 6, 1) = '1') then uni := 'KU' else uni := 'KG';
        cbr := (copy(cbr, 1, 5) + '00')
      end
    else cbr := copy(cbr, 1, 14);

    cbr := trim(cbr);

    //codSeq := strzero(QueryControlProd.fieldbyname('cod').AsInteger, 5);
    codSeq := dm.ibselect.fieldbyname('cod').AsString;
    _st := dm.IBselect.fieldbyname('aliquota').AsString;
    _st := trim(_st);
    if (_st = '') then _st := '0';
    if (_st = '0') then aliq := 0 else
    if (strtoint(_st) <= 12) then aliq := strtoint(_st) else aliq := 0;

    if (aliq = 10) then
      begin
        _cst := '060';
        _st := 'F';
      end;
    if (aliq = 11) then
      begin
        _cst := '040';
        _st := 'I';
      end;
    if (aliq = 12) then
      begin
        _cst := '041';
        _st := 'N';
      end;
    if (aliq = 1) then
      begin
        _cst := '000';
        _st := '01';
      end;
    if ((aliq = 0) or (aliq = 2) or (_st = '0')) then
      begin
        _cst := '000';
        _st := '02';
      end;
    dmSmall.IBQuerySmall.SQL.Clear;
    dmSmall.IBQuerySmall.SQL.Add('update or insert into estoque (registro, codigo, referencia, ' +
    'medida, descricao, custocompr, preco, qtd_atual, cst, csosn, st)' +
    'values (:cod10, :cod5, :codbar, :unid, :nome, :p_compra, :p_venda, :quant, :cst, :csosn, :st) ' +
    'MATCHING (registro)');
    dmSmall.IBQuerySmall.parambyname('cod10').AsString := '00000' + codSeq;
    dmSmall.IBQuerySmall.parambyname('cod5').AsString := codSeq;
    dmSmall.IBQuerySmall.parambyname('codbar').AsString := cbr;
    dmSmall.IBQuerySmall.parambyname('unid').AsString := uni;
    dmSmall.IBQuerySmall.parambyname('nome').AsString := ve_descricao(dm.IBselect.fieldbyname('nome').asstring, uni);
    dmSmall.IBQuerySmall.parambyname('p_compra').AsCurrency := dm.ibselect.fieldbyname('p_compra').AsCurrency;
    dmSmall.IBQuerySmall.parambyname('p_venda').AsCurrency := dm.ibselect.fieldbyname('p_venda').AsCurrency;
    dmSmall.IBQuerySmall.parambyname('quant').AsCurrency := quant;
    dmSmall.IBQuerySmall.parambyname('cst').AsString := _cst;
    dmSmall.IBQuerySmall.parambyname('csosn').AsString := '101';
    dmSmall.IBQuerySmall.parambyname('st').AsString := _st;
    try
      dmSmall.IBQuerySmall.Open;
    except
    end;
  except
    on E: Exception do
      begin
        ShowMessage('Erro(converteDados): ' +  E.Message);
        contagemErroBd := contagemErroBd + 1;
        dmSmall.BdSmall.Connected := false;
      end;
  end;
  dmSmall.IBQuerySmall.Close;
  dmSmall.BdSmall.Connected := false;
  dm.ibselect.Close;
end;

Function TForm9.RelSomatoria_T_(var lista1 : Tlist; dini, dfim : String; geral : currency) : AnsiString;
 var t1 : currency;
 prod, prod1 : Ptr_Produto;
begin
  t1 := 0;
  Result := '';
  Result := 'PERIODO: ' + FormatDateTime('dd/mm/yy',StrToDateTime(DINI)) + ' A ' + FormatDateTime('dd/mm/yy',StrToDateTime(dfim)) + '     Quant.       Preco ' + '                           ' + #13 + #10 ;
  Result := Result + funcoes.CompletaOuRepete('','','-',56) + #13 + #10;
  prod := lista1.Items[0]; //VENDA PROD
  prod1 := lista1.Items[1]; //COMPRA PROD1
  Result := Result + 'TOTAL A PRECO DE COMPRA..:' + funcoes.CompletaOuRepete('',FormatCurr('#,###,###0.00', prod1.tot3), ' ', 13) + funcoes.CompletaOuRepete('',FormatCurr('#,###,###0.00', Arredonda(prod1.tot2 * prod1.tot3, 2)), ' ', 13) + #13 + #10;
  Result := Result + 'TOTAL A PRECO DE VENDA...:' + funcoes.CompletaOuRepete('',FormatCurr('#,###,###0.00', prod.tot3), ' ', 13) + funcoes.CompletaOuRepete('',FormatCurr('#,###,###0.00', Arredonda(prod.tot2 * prod.tot3, 2)), ' ', 13) + #13 + #10;
  t1 := Arredonda(prod1.tot2 * prod1.tot3, 2) - Arredonda(prod.tot2 * prod.tot3, 2);
  Result := Result + 'LUCRO BRUTO S/VENDA......: ------------' + funcoes.CompletaOuRepete('',FormatCurr('#,###,###0.00', t1), ' ', 13) + #13 + #10;
  Result := Result + 'PRECO MEDIO DE COMPRA....: ------------' + funcoes.CompletaOuRepete('',FormatCurr('#,###,###0.00', prod1.tot2), ' ', 13) + #13 + #10;
  Result := Result + 'PRECO MEDIO DE VENDA.....: ------------' + funcoes.CompletaOuRepete('',FormatCurr('#,###,###0.00', prod.tot2), ' ', 13) + #13 + #10;
  Result := Result + 'ESTOQUE A PRECO DE COMPRA:' + funcoes.CompletaOuRepete('',FormatCurr('#,###,###0.00', prod.tot1), ' ', 13) + funcoes.CompletaOuRepete('',FormatCurr('#,###,###0.00', Arredonda( prod.tot1 * prod.qtd_atual, 2)), ' ', 13) + #13 + #10;
  Result := Result + 'ESTOQUE A PRECO MEDIO....:' + funcoes.CompletaOuRepete('',FormatCurr('#,###,###0.00', prod1.tot2), ' ', 13) + funcoes.CompletaOuRepete('',FormatCurr('#,###,###0.00', Arredonda(prod1.tot2 * prod.qtd_atual, 2)), ' ', 13) + #13 + #10;
  Result := Result + funcoes.CompletaOuRepete('','','-',56) + #13 + #10;
  Dispose(prod);
  Dispose(prod1);
end;

Procedure TForm9.SetComponenteRetorno(componente : jsedit);
begin
   componenteRetorno := componente;
end;

procedure TForm9.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if componenteRetorno <> nil then
    begin
      componenteRetorno.Text := valorRetorno;
    end;
end;

procedure TForm9.JsEditInteiro5Exit(Sender: TObject);
begin
  //   num := (((StrTofloat(JsEditInteiro4.Text)* (StrTofloat(JsEditInteiro5.Text)/100)))*1000)/1000;
  //   JsEditInteiro6.Text := FloatToStr(JsEdit.Arredondar(num,2));
end;

procedure TForm9.JsEditInteiro14Exit(Sender: TObject);
begin
 {  if JsEditInteiro7.Text <> '' then
   begin
       num := (((StrTofloat(JsEditInteiro14.Text)* (StrTofloat(JsEditInteiro7.Text)/100)))*1000)/1000;
       JsEditInteiro8.Text:= FloatToStr(JsEdit.Arredondar(num,2));
       JsEditInteiro21.Text :=FloatToStr((StrTofloat(JsEditInteiro6.text)-StrTofloat(JsEditInteiro8.text))+(StrTofloat(JsEditInteiro14.text)-StrTofloat(JsEditInteiro4.text)));
   end;  }

end;

procedure TForm9.FormShow(Sender: TObject);
begin
  ICMS_SUBS.ShowHint := true;
  DESC_COMP.ShowHint := true;
  agregado.ShowHint  := true;
  frete.ShowHint     := true;
  encargos.ShowHint  := true;

  {if funcoes.buscaParamGeral(63, 'N') = 'S' then JsBotao2.Visible := false
  else JsBotao2.Visible := true;}

  if funcoes.buscaParamGeral(66, 'N') = 'S' then begin
    JsBotao2.Visible := false;
  end;

  if RetornaAcessoUsuario > 0 then JsBotao2.Visible := false;

  if funcoes.buscaParamGeral(55, 'N') = 'S' then
    begin
      if RetornaAcessoUsuario = 0 then
        begin
          DescLabel.Visible := true;
          desconto.Visible  := true;
        end
      else
        begin
          DescLabel.Visible := false;
          desconto.Visible  := false;
        end;
    end
  else
    begin
      DescLabel.Visible := false;
      desconto.Visible  := false;
    end;

  //ShowMessage(EStringListError.);  

  if RetornaAcessoUsuario > 2 then
    begin
      comissao.Enabled := false;
    end;

  codbar1 := TStringList.Create;
  JsEdit.SetTabelaDoBd(self,'produto', dm.IBQuery4);

  if RecuperarCadastro = false then unid.Text := 'UN';
  if ConfParamGerais.Strings[26] = 'S' then Label29.Caption := 'NCM:';  // Usar NCM na NFE
  if ConfParamGerais[30] = 'S' then entrada := 1;                       // Cadastro de produtos em serie

  if RecuperarCadastro = false then
    begin
      if Trim(aliquota.Text) = '' then aliquota.Text := IntToStr(StrToIntDef(ConfParamGerais[22], 2));
    end;
  consultaCompleta := false;

  {if funcoes.Contido(ConfParamGerais[10], '3-4') then
    begin
      GroupBox3.Enabled := true;
    end
  else
    begin
      GroupBox3.Enabled := false;
    end;}

  try
    if ConfParamGerais[46] = 'S' then
      begin
        consultaCompleta := true;
      end;
  except
  end;

  if funcoes.buscaParamGeral(90, 'N') = 'S' then begin
    Label28.Caption := 'Equivalência:';
  end;

  ok := true;
  flag := 0;
end;

procedure TForm9.JsBotao1Click(Sender: TObject);
var
  tmp, temp, descr : string;
  novo   : boolean;
begin
  if (trim(classif.Text) <> '') then begin
    if ((length(StrNum(classif.Text)) <> 8) or (procuraNCM_Na_Tabela(StrNum(classif.Text)) = false)) then begin
      MessageDlg('NCM Inválido, Apague esse código ou preencha corretamente!', mtInformation, [mbOK], 1);
      classif.SetFocus;
      exit;
    end;

  end;


  if cod.Text  = '' then cod.Text := '0';
  if unid.Text = '' then unid.Text := 'UN';

  if trim(nome.Text) = '' then
    begin
      nome.SetFocus;
      ShowMessage('Campo DESCRIÇÃO é Obrigatório!');
      exit;
    end;

  unid.Text := trim(unid.Text);

  if Contido('-' + unid.Text + '-', '-M2-M3-') = false then begin
    unid.Text := SomenteLetras(unid.Text);
  end;

  if ((p_venda.getValor = 0) or (lucro.getValor < -10000)) then
    begin
      p_venda.SetFocus;
      lucro.setValor(0);
      ShowMessage('Campo Preço de Venda é Obrigatório!');
      exit;
    end;

  ok := true;
  if ok then
    begin
      //verifica se o codigo de barras está em branco, se estiver preeche com um codigo de barras válido
      if (trim(codbar.Text) = '') then
        begin
          tmp := trim(StrNum(cod.Text));
          codbar.Text := DIGEAN('789000' + funcoes.CompletaOuRepete('',IfThen(tmp = '0',IntToStr(StrToInt(Incrementa_Generator('produto',0)) + 1), tmp) ,'0',6));
        end;

      if ((funcoes.buscaParamGeral(5, 'N') <> 'S') or (funcoes.buscaParamGeral(82, 'N') = 'S')) then begin
        temp := funcoes.verificaCodbar(cod.Text, codbar.Text, 0);
        if temp <> '' then begin
          ShowMessage(temp);
          existeCodBar(codbar.Text);
          codbar.SetFocus;
          exit;
        end;
      end;

      //deleta caracteres especiais
      verificaCaracteres();

      if TIPO_ITEM.Text = '' then
        begin
          TIPO_ITEM.Text := '0';
        end;

      if nome.Text = '' then
         begin
           nome.SetFocus;
           ShowMessage('Preenchimento do NOME do Produto é obrigatório');
           exit;
         end;

      //codUlt := IfThen(cod.Text <> '0', cod.text, '');

      tmp := cod.Text;

      if Trim(aliquota.Text) = '' then aliquota.Text := IntToStr(StrToIntDef(ConfParamGerais[22], 2))
        else aliquota.Text := copy(aliquota.Text, 1, 3);

      if COD.Text = '0' then descr := 'CRIADO POR: ' + form22.codusario + '-' + form22.usuario
        else descr := 'ALTERADO POR: ' + form22.codusario + '-' + form22.usuario;

      codUlt := cod.Text;
      valorRetorno := jsedit.GravaNoBD(self);
      atualizaCodBarAdicionais(valorRetorno);
      insereIgualProduto(valorRetorno, DESCR);

      if ConfParamGerais[30] = 'S' then
        begin
          cod.Text := valorRetorno;
          JsEdit.SelecionaDoBD(self.Name);
          cod.Text      := '';
          codbar.Text   := '';
          quant.Text    := '0,000';
          deposito.Text := '0,000';
        end;
        
      Incrementa_Generator('ATUALIZACADPROD', 1);
      if unid.Text = '' then unid.Text := 'UN';  
    end;
end;

procedure TForm9.JsBotao2Click(Sender: TObject);
VAR
  MSG : string;
begin
  if not VerificaAcesso_Se_Nao_tiver_Nenhum_bloqueio_true_senao_false then
    begin
      MessageDlg('Usuário Não tem Permissão de Usar Essa Rotina!', mtError, [mbOK],1);
      exit;
    end;

  if not verificaPodeExcluir then msg := 'Este Produto Possui Movimento e Não Pode Ser Excluído! Deseja Excluir Mesmo Assim ?'
    else msg := 'Deseja Excluir o Produto: ?' + #13 +
      'Cód: '+cod.Text + #13 + 'Nome: ' + nome.Text;

  if MessageDlg(msg, mtWarning, [mbYes, mbNo], 1) = idyes then
    begin
      if not insereDeleted then
        begin
          exit;
        end;
      end
    else  exit;
end;

function TForm9.porcentagem(v1:extended;v2:extended) : extended;
begin
  result := (v2/100) * v1;
end;

procedure TForm9.lucKeyPress(Sender: TObject; var Key: Char);
begin
  if key=#13 then JsBotao1.SetFocus;
end;

procedure TForm9.codKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = 120) then begin //f10
    if funcoes.FiltraNota(funcoes.notaNFe,funcoes.fornecNFe, true) then begin
      //funcoes.FiltraNota(funcoes.notaNFe,funcoes.fornecNFe, false);
      close;
    end;
  end;

   if (Key = 117) then
     begin
       cod.Text := funcoes.buscaCodbarRetornaCodigo('', true);
       if strnum(trim(cod.Text)) = '0' then exit;
       jsedit.SelecionaDoBD(self.Name );
     end;

   {if (Key = 116) then
     begin
       if consultaCompleta then
         begin
           //form24 := TForm24.Create(self);
           form24.cosultaRetorna := true;
           form24.BuscaCOd := (codUlt
           );
           form24.ShowModal;

           if form24.retorno <> '*' then
             begin
               cod.Text := form24.retorno;
             end;
           //form24.Free;
           exit;
         end;

       tedit(sender).Text := funcoes.localizar1('Localizar Produto','produto','cod, nome,quant, p_venda as preco ','cod','','nome','nome',false,false,false, 'cod', codult,600,nil);
     end; }
end;

procedure TForm9.codKeyPress(Sender: TObject; var Key: Char);
begin
 if key=#27 then self.Close;
end;

procedure TForm9.grupoKeyPress(Sender: TObject; var Key: Char);
var grupo : string;
begin
  if key = #13 then
   begin
     if (tedit(sender).Text = '0') then
      begin
        form3 := tform3.Create(self);
        form3.ShowModal;
        tedit(sender).Text := form3.valor_a_retornar;
        form3.Free;
      end;
   end;

if (key=#13) and (tedit(sender).Text<>'') then
 begin
  grupo := funcoes.localizar1('Localizar Grupo','grupoprod','cod,nome','cod','','nome','nome',true,false,false,'cod', tedit(sender).Text,300,sender);
  if grupo <> '' then
   begin
    tedit(sender).Text := grupo;
   end
 end;

if (key=#13) and (tedit(sender).Text='') then
begin
  tedit(sender).Text := funcoes.localizar('Localizar Grupo','grupoprod','cod,nome','cod','','nome','nome',true,false,false,'',300,sender);
end;
end;

procedure TForm9.fornecKeyPress(Sender: TObject; var Key: Char);
var fornec : string;
begin

if key = #13 then
  begin
    if (tedit(sender).Text = '0') then
      begin
        form8 := tform8.Create(self);
        form8.ShowModal;
        tedit(sender).Text := form8.valor_a_retornar;
        form8.Free;
      end;

    if (tedit(sender).Text <> '') then
      begin
        fornec := funcoes.localizar1('Localizar Fornecedor','fornecedor','cod,nome','cod','','nome','nome',true,false,false,'cod', tedit(sender).Text,300,sender);
        if fornec <> '' then  tedit(sender).Text := fornec;
      end;

    if (tedit(sender).Text='') then
      begin
        tedit(sender).Text := funcoes.localizar('Localizar Fornecedor','fornecedor','cod,nome, cnpj, estado','cod','','nome','nome',true,false,false,'',300, nil);
      end;
  end;
end;

procedure TForm9.fabricKeyPress(Sender: TObject; var Key: Char);
var fabric : string;
begin
 if key = #13 then
   begin
     if (tedit(sender).Text = '0') then
      begin
        form6 := tform6.Create(self);
        form6.ShowModal;
        tedit(sender).Text := form6.valor_a_retornar;
        form6.Free;
      end;
   end;
if (key=#13) and (tedit(sender).Text<>'') then
 begin
  fabric := funcoes.localizar1('Localizar Fabricante','fabricante','cod,nome','cod','','nome','nome',true,false,false,'cod', tedit(sender).Text,300,sender);
  if fabric <> '' then
   begin
    tedit(sender).Text := fabric;
   end
 end;

if (key = #13) and (tedit(sender).Text='') then
  begin
    tedit(sender).Text := funcoes.localizar('Localizar Fabricante','fabricante','cod,nome','cod','','nome','nome',true,false,false,'',300,sender);
  end;
end;

procedure TForm9.JsEditInteiro1KeyPress(Sender: TObject; var Key: Char);
begin
  if key = #27 then close;
  if key = #13 then
    begin
      valorRetorno := tedit(sender).Text;
      if RecuperarCadastro then
        begin
          cod.Enabled := false;
          nome.SetFocus;
          abort;
        end;
    end;
end;

procedure TForm9.codEnter(Sender: TObject);
begin
  ulticod.Caption := IntToStr(JsEdit.UltimoCodigoDaTabela(self.Name));
  if funcoes.buscaParamGeral(10, '2') = '1' then
    begin
      TIPO_ITEM.Enabled := false;
      TIPO_ITEM.Text := '0';
    end;
end;

procedure TForm9.is_pisKeyPress(Sender: TObject; var Key: Char);
begin
key := UpCase(key);
if not funcoes.Contido(key,'IRM'+#13+#27+#8) then key := #0;
if (key = #13) and ((trim(tedit(sender).Text)='') or (tedit(sender).Text='0')) then
 begin
   form39 := tform39.Create(self);
   form39.ListBox1.Items.Add('  - TRIBUTADO');
   form39.ListBox1.Items.Add('I - ISENTO             (07)');
   form39.ListBox1.Items.Add('R - Aliq. Red. Zero    (06)');
   form39.ListBox1.Items.Add('M - Monofásico         (04)');
   form39.ListBox1.Items.Add('X - Sem Incidencia     (08)');
   form39.ListBox1.Items.Add('D - Aliq. Diferenciada (02)');
   tedit(sender).Text := funcoes.lista(Sender, false);
 end;
if tedit(sender).Text = '*' then
 begin
  tedit(sender).Text := '';
  key := #0;
 end;
end;

procedure TForm9.aliquotaKeyPress(Sender: TObject; var Key: Char);
begin
  if (key = #13) and (tedit(sender).Text = '') then
    begin
      tedit(sender).Text := funcoes.localizar('Localizar Aliquota','aliq','cod,aliq,reducao,cst, CSOSN','cod','','cod','cod',false,false,false,'',430,sender);
      if tedit(sender).Text = '' then key := #0;
    end;
end;

{procedure TForm9.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var cod1, dini, dfim, DEST : string;
   fat : integer;
   ini, fim, ret : TDateTime;
   tot, geral, saldo : currency;
   prod : Ptr_Produto;
   lista : TList;
   lab : TLabel;
begin
  if key = 119 then
    begin
      if cod.Text = '' then
        begin
          cod1 := funcoes.dialogo('generico',0,'1234567890,.'+#8,50,false,'',Application.Title,'Qual o Cód do Produto?','');
          if (cod1 = '*') or (cod1 = '') then exit;

          cod.Text := cod1;
        end;

       dm.IBselect.Close;
       dm.IBselect.SQL.Clear;
       dm.IBselect.SQL.Add('select data from venda');
       dm.IBselect.Open;
       dm.IBselect.First;

       ini := dm.IBselect.fieldbyname('data').AsDateTime;
       fim := form22.datamov - 180;

       if ini < fim then ret := ini
         else ret := fim;
       ini := ret;

       dm.IBselect.Last;

       //fim := dm.IBselect.fieldbyname('data').AsDateTime;
       fim := form22.datamov;
       dm.IBselect.Close;


       dini := funcoes.dialogo('data',0,'',2,true,'',Application.Title,'Qual a Data Inicial de Movimento?',formatadataddmmyy(ini));
       if dini = '*' then exit;

       dfim := funcoes.dialogo('data',0,'',2,true,'',Application.Title,'Qual a Data Final de Movimento?',formatadataddmmyy(fim));
       if dfim = '*' then exit;

       cod1 := funcoes.dialogo('generico',0,'123'+#8,50,false,'S',Application.Title,'Qual o Critério de Seleção da Mercadoria (1-Loja 2-Deposito 3-Loja + Deposito)?','');
       if cod1 = '*' then exit;

       if cod1 = '' then
         begin
           cod1 := '*';
           form39 := tform39.Create(self);
           form39.ListBox1.Items.Add('3- LOJA + DEPOSITO');
           form39.ListBox1.Items.Add('1- LOJA');
           form39.ListBox1.Items.Add('2- DEPOSITO');
           form39.Position := poScreenCenter;
           cod1 := funcoes.lista(Sender, false);
           if cod1 = '*' then exit;

         end;

       cod1 := trim(cod1);
       form33 := TForm33.Create(self);

       form33.Caption := 'Ficha do Produto: ' + cod.Text + '-' + funcoes.BuscaNomeBD(dm.ibquery2, 'nome', 'produto','where cod = ' + cod.Text);

       form33.ClientDataSet1.FieldDefs.Add('DATA',ftDate);
       form33.ClientDataSet1.FieldDefs.Add('HISTORICO',ftString,40);
       form33.ClientDataSet1.FieldDefs.Add('PRECO',ftCurrency);
       form33.ClientDataSet1.FieldDefs.Add('QUANT',ftCurrency);
       form33.ClientDataSet1.FieldDefs.Add('SALDO',ftCurrency);
       form33.ClientDataSet1.FieldDefs.Add('cont',ftInteger);

       form33.DataSource1.DataSet := form33.ClientDataSet1;
       Form33.DBGrid1.DataSource := form33.DataSource1;

       form33.ClientDataSet1.CreateDataSet;
       form33.ClientDataSet1.LogChanges := false;

       TCurrencyField(form33.ClientDataSet1.FieldByName('preco')).currency := false;
       TCurrencyField(form33.ClientDataSet1.FieldByName('quant')).currency := false;
       TCurrencyField(form33.ClientDataSet1.FieldByName('saldo')).currency := false;

       with form33.ClientDataSet1.IndexDefs.AddIndexDef do
         begin
           Fields := 'cont';
           Name := 'indice';
         end;

       //form33.ClientDataSet1.IndexName := 'indice';
       tot := 0;
       geral := 0;
       saldo := 0;

       dm.IBselect.Close;
       dm.IBselect.SQL.Clear;
       dm.IBselect.SQL.Add('select sad, sal from produto where cod = :cod');
       dm.IBselect.ParamByName('cod').AsString := cod.Text;
       dm.IBselect.Open;

       if cod1 = '3' then
         begin
           tot := dm.IBselect.fieldbyname('sad').AsCurrency + dm.IBselect.fieldbyname('sal').AsCurrency;
         end
       else if cod1 = '2' then
         begin
           tot := dm.IBselect.fieldbyname('sad').AsCurrency;
         end
       else
         begin
           tot := dm.IBselect.fieldbyname('sal').AsCurrency;
         end;

       form33.ClientDataSet1.Open;
       form33.ClientDataSet1.Edit;
       form33.ClientDataSet1.Insert;
       form33.ClientDataSet1.FieldByName('historico').AsString := 'SALDO ANTERIOR';
       form33.ClientDataSet1.FieldByName('preco').AsCurrency := 0;
       form33.ClientDataSet1.FieldByName('quant').AsCurrency := tot;
       form33.ClientDataSet1.FieldByName('cont').AsInteger := Form33.ClientDataSet1.RecordCount + 1;
       form33.ClientDataSet1.FieldByName('saldo').AsCurrency := tot;
       form33.ClientDataSet1.Post;

       geral := tot; // joga saldo anterior em SALDO

       lista := tlist.Create;
       prod := new(ptr_produto);

       dm.IBselect.Close;
       dm.IBselect.SQL.Clear;
       dm.IBselect.SQL.Add('select i.data,i.p_venda,i.quant,i.total,i.nota,(select nome from formpagto where cod=v.codhis) from item_venda i,venda v where (i.cancelado = 0) and ((i.data>=:ini)and(i.data<=:fim))and(i.nota=v.nota)and(i.cod='+cod.Text+') '+ iif(cod1 = '3', '', 'and (i.origem = '+ cod1 +')') );       dm.IBselect.ParamByName('ini').AsDateTime := StrToDateTime(dini);
       dm.IBselect.ParamByName('fim').AsDateTime := StrToDateTime(dfim);
       dm.IBselect.Open;
       prod.qtd_atual := 0;
       prod.tot1 := 0;
       prod.tot2 := 0;
       prod.tot3 := 0;

       while not dm.IBselect.Eof do
         begin
           geral := geral + (- dm.IBselect.fieldbyname('quant').asCurrency);

           prod.nome := 'TOTAL PRECO DE VENDA: ';
           prod.tot2 := prod.tot2 + Arredonda((dm.IBselect.fieldbyname('quant').asCurrency * dm.IBselect.fieldbyname('p_venda').asCurrency),2);
           prod.tot3 := prod.tot3 + dm.IBselect.fieldbyname('quant').asCurrency;

           form33.ClientDataSet1.Open;
           form33.ClientDataSet1.Edit;
           form33.ClientDataSet1.Insert;
           form33.ClientDataSet1.FieldByName('data').AsDateTime := dm.IBselect.fieldbyname('data').AsDateTime;
           form33.ClientDataSet1.FieldByName('historico').AsString := 'VENDA NOTA ' + dm.IBselect.fieldbyname('nota').AsString + ' ' + dm.IBselect.fieldbyname('nome').AsString ;
           form33.ClientDataSet1.FieldByName('preco').AsCurrency := dm.IBselect.fieldbyname('p_venda').AsCurrency;
           form33.ClientDataSet1.FieldByName('quant').AsCurrency := iif(dm.IBselect.fieldbyname('quant').asCurrency > 0,(-1) * dm.IBselect.fieldbyname('quant').asCurrency, dm.IBselect.fieldbyname('quant').asCurrency );
           form33.ClientDataSet1.FieldByName('saldo').AsCurrency := geral;
           form33.ClientDataSet1.FieldByName('cont').AsInteger := Form33.ClientDataSet1.RecordCount + 1;
           form33.ClientDataSet1.Post;

           dm.IBselect.Next;
         end;
       prod.tot2 := Arredonda(prod.tot2 / prod.tot3, 2);

       dm.IBselect.Close;
       dm.IBselect.SQL.Clear;
       dm.IBselect.SQL.Add('select p_compra, quant, deposito from produto where cod = ' + cod.Text);
       dm.IBselect.Open;

       prod.tot1 := dm.IBselect.fieldbyname('p_compra').AsCurrency;
       prod.qtd_atual := dm.IBselect.fieldbyname('quant').AsCurrency + dm.IBselect.fieldbyname('deposito').AsCurrency;

       dm.IBselect.Close;

       lista.Add(prod);

       dm.IBselect.Close;
       dm.IBselect.SQL.Clear;
       dm.IBselect.SQL.Add('select cod, iif(destino = 2, 1, 2) as origem, data, destino, quant, documento from transferencia where ((data >= :ini) and (data <= :fim)) and (cod = '+ cod.Text +') ' );
       dm.IBselect.ParamByName('ini').AsDateTime := StrToDateTime(dini);
       dm.IBselect.ParamByName('fim').AsDateTime := StrToDateTime(dfim);
       dm.IBselect.Open;

       if cod1 = '3' then cod1 := '12';

       while not dm.IBselect.Eof do
         begin
           if funcoes.Contido(dm.IBselect.fieldbyname('origem').AsString, cod1) then
             begin
               geral := geral - dm.IBselect.fieldbyname('quant').asCurrency;
               DEST := ' LOJA => DEPOSITO';
               fat := -1;

               form33.ClientDataSet1.Open;
               form33.ClientDataSet1.Insert;
               form33.ClientDataSet1.FieldByName('data').AsDateTime := dm.IBselect.fieldbyname('data').AsDateTime;
               form33.ClientDataSet1.FieldByName('historico').AsString := 'TRANSFERENCIA -' + dm.IBselect.fieldbyname('documento').AsString + DEST ;
               form33.ClientDataSet1.FieldByName('preco').AsCurrency := 0;
               form33.ClientDataSet1.FieldByName('quant').AsCurrency := fat * dm.IBselect.fieldbyname('quant').asCurrency ;
               form33.ClientDataSet1.FieldByName('saldo').AsCurrency := geral;
               form33.ClientDataSet1.FieldByName('cont').AsInteger := Form33.ClientDataSet1.RecordCount + 1;
               form33.ClientDataSet1.Post;
             end;

           if funcoes.Contido(dm.IBselect.fieldbyname('destino').AsString, cod1) then
             begin
               geral := geral + dm.IBselect.fieldbyname('quant').asCurrency;
               DEST := ' DEPOSITO => LOJA';
               fat := 1;

               form33.ClientDataSet1.Open;
               form33.ClientDataSet1.Insert;
               form33.ClientDataSet1.FieldByName('data').AsDateTime := dm.IBselect.fieldbyname('data').AsDateTime;
               form33.ClientDataSet1.FieldByName('historico').AsString := 'TRANSFERENCIA -' + dm.IBselect.fieldbyname('documento').AsString + DEST ;
               form33.ClientDataSet1.FieldByName('preco').AsCurrency := 0;
               form33.ClientDataSet1.FieldByName('quant').AsCurrency := fat * dm.IBselect.fieldbyname('quant').asCurrency ;
               form33.ClientDataSet1.FieldByName('saldo').AsCurrency := geral;
               form33.ClientDataSet1.FieldByName('cont').AsInteger := Form33.ClientDataSet1.RecordCount + 1;
               form33.ClientDataSet1.Post;
             end;

           if cod1 = '12' then cod1 := '3';

           if (dm.IBselect.fieldbyname('destino').AsInteger = 1) then
             begin
               geral := geral + dm.IBselect.fieldbyname('quant').asCurrency ;
               form33.ClientDataSet1.Open;
               form33.ClientDataSet1.Insert;
               form33.ClientDataSet1.FieldByName('data').AsDateTime := dm.IBselect.fieldbyname('data').AsDateTime;
               form33.ClientDataSet1.FieldByName('historico').AsString := 'TRANSFERENCIA -' + dm.IBselect.fieldbyname('documento').AsString + 'DEPOSITO => LOJA';
               form33.ClientDataSet1.FieldByName('preco').AsCurrency := 0;
               form33.ClientDataSet1.FieldByName('quant').AsCurrency := dm.IBselect.fieldbyname('quant').asCurrency ;
               form33.ClientDataSet1.FieldByName('saldo').AsCurrency := gerAL;
               form33.ClientDataSet1.FieldByName('cont').AsInteger := Form33.ClientDataSet1.RecordCount + 1;
               form33.ClientDataSet1.Post;
             end;


           if (dm.IBselect.fieldbyname('destino').AsInteger = 2) then
             begin
               geral := geral - dm.IBselect.fieldbyname('quant').asCurrency ;

               form33.ClientDataSet1.Open;
               form33.ClientDataSet1.Insert;
               form33.ClientDataSet1.FieldByName('data').AsDateTime := dm.IBselect.fieldbyname('data').AsDateTime;
               form33.ClientDataSet1.FieldByName('historico').AsString := 'TRANSFERENCIA -' + dm.IBselect.fieldbyname('documento').AsString + '- LOJA => DEPOSITO' ;
               form33.ClientDataSet1.FieldByName('preco').AsCurrency := 0;
               form33.ClientDataSet1.FieldByName('quant').AsCurrency := - dm.IBselect.fieldbyname('quant').asCurrency ;
               form33.ClientDataSet1.FieldByName('saldo').AsCurrency := geral;
               form33.ClientDataSet1.FieldByName('cont').AsInteger := Form33.ClientDataSet1.RecordCount + 1;
               form33.ClientDataSet1.Post;
             end;

           dm.IBselect.Next;
         end;

       if cod1 = '12' then cod1 := '3';

       prod := new(ptr_produto);
       prod.tot1 := 0;
       prod.tot2 := 0;
       prod.tot3 := 0;

       dm.IBselect.Close;
       dm.IBselect.SQL.Clear;
       dm.IBselect.SQL.Add('select cod, data, p_compra, destino, quant, nota from item_entrada where ((data >= :ini) and (data <= :fim)) and (cod = '+ cod.Text +') '+ iif(cod1 = '3', '', 'and (destino = '+ cod1 +')' ));
       dm.IBselect.ParamByName('ini').AsDateTime := StrToDateTime(dini);
       dm.IBselect.ParamByName('fim').AsDateTime := StrToDateTime(dfim);
       dm.IBselect.Open;

       while not dm.IBselect.Eof do
         begin
           geral := geral + dm.IBselect.fieldbyname('quant').AsCurrency;

           //prod.tot1 := prod.tot1 + dm.IBselect.fieldbyname('total').asCurrency;
           prod.tot2 := prod.tot2 + Arredonda((dm.IBselect.fieldbyname('quant').asCurrency * dm.IBselect.fieldbyname('p_compra').asCurrency),2);
           prod.tot3 := prod.tot3 + dm.IBselect.fieldbyname('quant').asCurrency;

           form33.ClientDataSet1.Open;
           form33.ClientDataSet1.Insert;
           form33.ClientDataSet1.FieldByName('data').AsDateTime := dm.IBselect.fieldbyname('data').AsDateTime;
           form33.ClientDataSet1.FieldByName('historico').AsString := 'ENTRADA NOTA     ' + dm.IBselect.fieldbyname('nota').AsString + '   ' + iif(dm.IBselect.fieldbyname('destino').AsInteger = 1, 'LOJA', 'DEPOSITO') ;
           form33.ClientDataSet1.FieldByName('preco').AsCurrency := dm.IBselect.fieldbyname('p_compra').AsCurrency;
           form33.ClientDataSet1.FieldByName('quant').AsCurrency := dm.IBselect.fieldbyname('quant').asCurrency ;
           form33.ClientDataSet1.FieldByName('saldo').AsCurrency := geral;
           form33.ClientDataSet1.FieldByName('cont').AsInteger := Form33.ClientDataSet1.RecordCount + 1;
           form33.ClientDataSet1.Post;

           dm.IBselect.Next;
         end;

       prod.tot2 := Arredonda(prod.tot2 / prod.tot3, 2);
       lista.Add(prod);

       form33.ClientDataSet1.IndexName := 'indice';
       form33.ClientDataSet1.fieldbyname('cont').Visible := false;
       form33.ClientDataSet1.First;

       TCurrencyField(form33.ClientDataSet1.FieldByName('preco')).DisplayFormat := '#,###,###0.00';
       TCurrencyField(form33.ClientDataSet1.FieldByName('quant')).DisplayFormat := '#,###,###0.00';
       TCurrencyField(form33.ClientDataSet1.FieldByName('saldo')).DisplayFormat := '#,###,###0.00';

       form33.txt := RelSomatoria_T_(lista,dini,dfim,geral);
       lab := TLabel.Create(self);
       lab.Name := 'lab';
       lab.Parent := form33;
       lab.Caption := 'I-IMPRIME     T-TOTAL' ;
       lab.Align := alBottom;
       lab.AutoSize := true;
       lab.Font.Style := [fsbold];
       lab.Font.Size := 9;
       funcoes.CtrlResize(tform(form33));
       form33.ShowModal;
       form33.ClientDataSet1.Free;
       form33.Free;
       lab := nil;
    end;
end;
 }
procedure TForm9.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  te : string;
begin
  if (Key = 116) then
     begin
       if consultaCompleta then
         begin
           //form24 := TForm24.Create(self);
           form24.cosultaRetorna := true;
           form24.BuscaCOd := (codUlt);
           form24.ShowModal;

           if form24.retorno <> '*' then
             begin
               cod.Text := form24.retorno;
               if strnum(trim(cod.Text)) = '0' then exit;
               jsedit.SelecionaDoBD(self.Name);
             end;
           //form24.Free;
           exit;
         end;

       cod.Text := funcoes.localizar1('Localizar Produto','produto','cod, nome,quant, p_venda as preco ','cod','','nome','nome',false,false,false, 'cod', codult,600,nil);
       if strnum(trim(cod.Text)) = '0' then exit;
       jsedit.SelecionaDoBD(self.Name);
     end;

  if key = 112 then begin
    if StrToIntDef(cod.Text, 0) <= 0 then exit;
    if form22.usuario <> 'ADMIN' then exit;

    te := funcoes.dialogo('numero', 0, '', 2, false, 'X', Application.Title,
    'Qual a Quantidade ?', '0,00');
    if te = '*' then exit;

    dm.IBQuery1.Close;
    dm.IBQuery1.SQL.Text := 'update produto set quant = :quant where cod = :cod';
    dm.IBQuery1.ParamByName('quant').AsCurrency := StrToCurr(te);
    dm.IBQuery1.ParamByName('cod').AsInteger    := cod.getValor;
    dm.IBQuery1.ExecSQL;
    dm.IBQuery1.Transaction.Commit;

    ShowMessage('Quantidade Alterada!');
  end;

  if key = 113 then
    begin
      if funcoes.buscaParamGeral(17, 'N') = 'N' then begin
        exit;
      end;

      if StrNum(cod.Text) = '0' then begin
        ShowMessage('Abra a Ficha de Um Produto!');
        exit;
      end;

      promocao := Tpromocao.Create(self);
      promocao.doc.Text := '0';
      promocao.cod.Text := cod.Text;
      promocao.cadprod := true;
      promocao.ShowModal;
      promocao.Free;
    end;

  if key = 121 then
    begin
      if not funcoes.senhaDodia then exit;
      funcoes.VER_ESTOQUE('RECALCULA', 'Acertando Fichas de Produtos', 'Recalcul', StrToIntDef(cod.Text, 0));
    end;

  if key = 119 then
    begin
      te := cod.Text;
      funcoes.fichaDoProduto(sender, te, false);
      cod.Text := te;
    end;


end;

procedure TForm9.codbarKeyPress(Sender: TObject; var Key: Char);
var
  temp, sim : string;
begin
  if key = #13 then
    begin
      if tedit(sender).Text <> '' then
        begin
        if ((funcoes.buscaParamGeral(5, 'N') = 'S') and (funcoes.buscaParamGeral(82, 'N') <> 'S')) then
          //if funcoes.buscaParamGeral(5, 'N') = 'S' then
            begin
              ok := true;
              exit;
            end;

          temp := funcoes.verificaCodbar(cod.Text, codbar.Text, 0);
          if temp <> '' then
            begin
              ok := false;
              ShowMessage(temp);
              existeCodBar(codbar.Text);
              //tedit(sender).Text := '';
              Key := #0;
            end
          else
            begin
              ok := true;
            end;
        end;
    end;
end;

procedure TForm9.basecredExit(Sender: TObject);
begin
  if JsEditNumero(sender).getValor <> 0 then
    begin
      credicm.setValor(p_compra.getValor * basecred.getValor / 100);
    end;
end;

procedure TForm9.lucroKeyPress(Sender: TObject; var Key: Char);
begin
  if key = #13 then
    begin
      CALCLUCRO1(lucro, p_venda, debicm, basedeb, credicm, p_compra, frete, encargos, basecred, agregado, ICMS_SUBS.getValor, DESC_COMP.getValor, key);
    end;
end;

procedure TForm9.p_vendaKeyPress(Sender: TObject; var Key: Char);
begin
  if key = #13 then
    begin
      //if StrToCurrDef(funcoes.ConverteNumerico(tedit(sender).Text), 0) = 0 then tedit(sender).Text := p_compra.Text;
    //(_LUCRO, _PVENDA, _DEBICM, _BASEDEB, _CREDICM, _PCOMPRA, _FRETE, _ENCARGO, _BASECRED, AGREG, PAR : CURRENCY)
     edit1.text := FormatCurr('#,###,###0.00', CALCPRE(lucro, p_venda, debicm, basedeb, credicm, p_compra, frete, encargos, basecred, agregado, ICMS_SUBS.getValor, DESC_COMP.getValor));
    end;
  end;

procedure TForm9.nomeEnter(Sender: TObject);
begin
  if ((StrToIntDef(cod.Text, 0) <> 0) and (flag = 0))  then
    begin
      //codUlt := IfThen(cod.Text <> '0', cod.text, '');
      flag := 1;
      carregaCodBarAdicionais(); //carrega na StringList codbar1
    end
  else codbar1.Clear;

  if unid.Text = '' then unid.Text := 'UN';

  if Trim(aliquota.Text) = '' then aliquota.Text := IntToStr(StrToIntDef(ConfParamGerais[22], 2))
    else aliquota.Text := copy(aliquota.Text, 1, 3);
end;

procedure TForm9.FormKeyPress(Sender: TObject; var Key: Char);
begin
  {if ((key = #27)) then
    begin
      cod.Enabled := true;
      cod.Text := '0';
      if not cod.Focused then key := #0;
      cod.SetFocus;
    end;}
end;

procedure TForm9.codbarKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  cod1, ret : string;
begin
  if key = 117 then
    begin
      buscaCodBar();
    end;
  if key = 118 then
    begin
      cod1 := funcoes.dialogo('normal',3,'',60,true,'','ControlW','Informe um Código de Barras:','');
      if cod1 = '*' then exit;
      ret := '';
      ret := funcoes.verificaCodbar(cod.Text, cod1, 0);
      if ret = '' then
        begin
          if addCodBarStringList(cod.Text, cod1) then ShowMessage(cod1 + ' Adicionado com sucesso');
        end
      else
        begin
          ShowMessage(ret);
          existeCodBar(cod1);
        end;
    end;
end;

procedure TForm9.codbarEnter(Sender: TObject);
begin
  Label37.Top := codbar.Top + codbar.Height + 5;
  Label37.Caption := 'F6 - Consulta Cód. Barras' + #13 + 'F7 - Adicionar Cód. Barras'
end;

procedure TForm9.codbarExit(Sender: TObject);
begin
  Label37.Caption := '';
end;

procedure TForm9.FormCreate(Sender: TObject);
begin
  RecuperarCadastro := false;
  if funcoes.buscaParamGeral(17, 'N') = 'S' then begin
    Label35.Caption := Label35.Caption + '/F2-Atacado';
  end;
end;

procedure TForm9.insereIgualProduto(const cod2, igual : String);
begin
  dm.IBQuery1.Close;
  dm.IBQuery1.SQL.Text := 'update produto set igual = :igual where cod = :cod';
  dm.IBQuery1.ParamByName('igual').AsString := igual;
  dm.IBQuery1.ParamByName('cod').AsString := cod2;
  dm.IBQuery1.ExecSQL;
  dm.IBQuery1.Transaction.Commit; 
end;

procedure TForm9.COD_ISPISKeyPress(Sender: TObject; var Key: Char);
begin
  if key = #13 then
    begin
      if trim(tedit(sender).Text) = '' then COD_ISPIS.Text := funcoes.VE_CODISPIS('', is_pis.Text);
      if Contido('|'+tedit(sender).Text + '|', '|100|200|300|400|500|600|700|800|900|') then
        begin
          MessageDlg('Código ' + tedit(sender).Text + ' Inválido!', mtInformation, [mbOK], 1);
          tedit(sender).Text := '';
          key := #0;
        end;
    end;

  if not(key in [#13, #27, #8]) then key := #0;
end;

procedure TForm9.dev_icmKeyPress(Sender: TObject; var Key: Char);
begin
  if key = #13 then
    begin
      key := #0;
      if GroupBox3.Enabled then is_pis.SetFocus
        else fracao.SetFocus;
    end;
end;


function TForm9.verificaPodeExcluir() : boolean;
begin
  Result := true;
  dm.IBselect.Close;
  dm.IBselect.SQL.Text := 'select cod from item_venda where cod = :cod';
  dm.IBselect.ParamByName('cod').AsString := StrNum(cod.Text);
  dm.IBselect.Open;

  if not dm.IBselect.IsEmpty then
    begin
      Result := false;
      dm.IBselect.Close;
      exit;
    end;

  dm.IBselect.Close;
  dm.IBselect.SQL.Text := 'select cod from item_entrada where cod = :cod';
  dm.IBselect.ParamByName('cod').AsString := StrNum(cod.Text);
  dm.IBselect.Open;

  if not dm.IBselect.IsEmpty then
    begin
      Result := false;
      dm.IBselect.Close;
      exit;
    end;

  dm.IBselect.Close;  
end;

procedure TForm9.TIPO_ITEMKeyPress(Sender: TObject; var Key: Char);
begin
key := UpCase(key);
//if not funcoes.Contido(key,'IRM'+#13+#27+#8) then key := #0;
if (key = #13) and (tedit(sender).Text='')  then
  begin
    form39 := tform39.Create(self);
    form39.ListBox1.Items.Add('00 - Mercadoria para Revenda');
    form39.ListBox1.Items.Add('01 - Matéria Prima');
    form39.ListBox1.Items.Add('02 - Embalagem');
    form39.ListBox1.Items.Add('03 - Produto em Processo');
    form39.ListBox1.Items.Add('04 - Produto Acabado');
    form39.ListBox1.Items.Add('05 - Subproduto');
    form39.ListBox1.Items.Add('06 - Produto Intermediário');
    form39.ListBox1.Items.Add('07 - Material de Uso e Consumo');
    form39.ListBox1.Items.Add('08 - Ativo Imobilizado');
    form39.ListBox1.Items.Add('09 - Serviços');
    form39.ListBox1.Items.Add('10 - Outros insumos');
    form39.ListBox1.Items.Add('99 - Outras');
    tedit(sender).Text := funcoes.lista(sender, true);
   {form60 := tform60.Create(self);
   form60.caption := 'Tipo do Item';
   form60.ListBox1.Items.Add('00 – Mercadoria para Revenda  ');
   form60.ListBox1.Items.Add('01 – Matéria-Prima            ');
   form60.ListBox1.Items.Add('02 – Embalagem                ');
   form60.ListBox1.Items.Add('03 – Produto em Processo      ');
   form60.ListBox1.Items.Add('04 – Produto Acabado          ');
   form60.ListBox1.Items.Add('05 – Subproduto               ');
   form60.ListBox1.Items.Add('06 – Produto Intermediário    ');
   form60.ListBox1.Items.Add('07 – Material de Uso e Consumo');
   form60.ListBox1.Items.Add('08 – Ativo Imobilizado        ');
   form60.ListBox1.Items.Add('09 – Serviços                 ');
   form60.ListBox1.Items.Add('10 – Outros insumos           ');
   form60.ListBox1.Items.Add('99 – Outras                   ');
   form60.quantidade_caracteres_a_retornar := 2;
   form60.ShowModal;
   tedit(sender).Text := form60.valor_a_retornar;
   form60.Free;     }
  end;
  if (key = #13) and (tedit(sender).Text <> '')  then
    begin
     tedit(sender).Text := strzero(tedit(sender).Text, 2);
     if not funcoes.contido('-'+tedit(sender).Text + '-', '-00-01-02-03-04-05-06-07-08-09-10-99-') then
       tedit(sender).Text := '';
    end;
end;

function TForm9.insereDeleted() : boolean;
var
  cod1 : integer;
  nome1 : String;
begin
  Result := false;
  cod1 := StrToIntDef(StrNum(cod.Text), 0);

  if cod1 = 0 then
    begin
      MessageDlg('Produto Cód: ' + IntToStr(cod1) + ' é Inválido!', mtInformation, [mbOK], 1);
      exit;
    end;

  if NOT funcoes.verSeExisteTabela('PRODUTO_DELETED') then
    begin
      MessageDlg('O sistema Encontrou Uma Inconsistência, O sistema precisa ser Reiniciado!', mtInformation, [mbOK], 1);
      funcoes.atualizaBD;
      Application.Terminate;
    end;

  dm.IBselect.Close;
  dm.IBselect.SQL.Text := 'select * from produto where cod = :cod';
  dm.IBselect.ParamByName('cod').AsInteger := cod1;
  dm.IBselect.Open;

  nome1 := dm.IBselect.fieldbyname('nome').AsString;

  dm.IBQuery1.Close;
  dm.IBQuery1.SQL.Clear;
  dm.IBQuery1.SQL.Add('update or insert into PRODUTO_DELETED(cod,nome,unid,igual,codbar,localiza,fornec,fabric,aliquota,refori,classif,aplic,grupo,serie,is_pis,emb,desc_atac,p_venda, p_venda1,p_compra,lucro,quant,deposito,comissao,credicm,basecred,');
  dm.IBQuery1.SQL.Add('debicm,basedeb,frete,encargos,fracao,agregado,sal,sad,sugestao,compra, dev_icm, equiva, usuario, DATA_DELETED)');
  dm.IBQuery1.SQL.Add(' values(:cod,:nome,:unid,:igual,:codbar,:localiza,:fornec,:fabric,:aliquota,:refori,:classif,:aplic,:grupo,');
  dm.IBQuery1.SQL.Add(':serie,:is_pis,:emb,:desc_atac,:p_venda, :p_venda1,:p_compra,:lucro,:quant,:deposito,:comissao,:credicm,:basecred,:debicm,:basedeb,:frete,:encargos,:fracao,:agregado,:sal,:sad,:sugestao,:compra,:dev_icm, :equiva, :usuario, :DATA_DELETED) matching(cod)');
  dm.IBQuery1.ParamByName('cod').AsInteger       := dm.IBselect.fieldbyname('cod').AsInteger;
  dm.IBQuery1.ParamByName('nome').AsString       := dm.IBselect.fieldbyname('nome').AsString;
  dm.IBQuery1.ParamByName('unid').AsString       := dm.IBselect.fieldbyname('unid').AsString;
  dm.IBQuery1.ParamByName('igual').AsString      := dm.IBselect.fieldbyname('igual').AsString;
  dm.IBQuery1.ParamByName('codbar').AsString     := dm.IBselect.fieldbyname('codbar').AsString;
  dm.IBQuery1.ParamByName('localiza').AsString   := dm.IBselect.fieldbyname('localiza').AsString;
  dm.IBQuery1.ParamByName('refori').AsString     := dm.IBselect.fieldbyname('refori').AsString;
  dm.IBQuery1.ParamByName('fornec').AsString     := dm.IBselect.fieldbyname('fornec').AsString;
  dm.IBQuery1.ParamByName('fabric').AsString     := dm.IBselect.fieldbyname('fabric').AsString;
  dm.IBQuery1.ParamByName('aliquota').AsString   := dm.IBselect.fieldbyname('aliquota').AsString;
  dm.IBQuery1.ParamByName('classif').AsString    := dm.IBselect.fieldbyname('classif').AsString;
  dm.IBQuery1.ParamByName('aplic').AsString      := dm.IBselect.fieldbyname('aplic').AsString;
  dm.IBQuery1.ParamByName('grupo').AsString      := dm.IBselect.fieldbyname('grupo').AsString;
  dm.IBQuery1.ParamByName('serie').AsString      := dm.IBselect.fieldbyname('serie').AsString;
  dm.IBQuery1.ParamByName('is_pis').AsString     := dm.IBselect.fieldbyname('is_pis').AsString;
  dm.IBQuery1.ParamByName('emb').AsString        := dm.IBselect.fieldbyname('emb').AsString;
  dm.IBQuery1.ParamByName('desc_atac').AsString  := dm.IBselect.fieldbyname('desc_atac').AsString;
  dm.IBQuery1.ParamByName('p_venda').AsCurrency  := dm.IBselect.fieldbyname('p_venda').AsCurrency;
  dm.IBQuery1.ParamByName('p_venda1').AsCurrency := dm.IBselect.fieldbyname('p_venda1').AsCurrency;
  dm.IBQuery1.ParamByName('p_compra').AsCurrency := dm.IBselect.fieldbyname('p_compra').AsCurrency;
  dm.IBQuery1.ParamByName('lucro').AsCurrency    := dm.IBselect.fieldbyname('lucro').AsCurrency;
  dm.IBQuery1.ParamByName('quant').AsCurrency    := dm.IBselect.fieldbyname('quant').AsCurrency;
  dm.IBQuery1.ParamByName('deposito').AsCurrency := dm.IBselect.fieldbyname('deposito').AsCurrency;
  dm.IBQuery1.ParamByName('comissao').AsCurrency := dm.IBselect.fieldbyname('comissao').AsCurrency;
  dm.IBQuery1.ParamByName('credicm').AsCurrency  := dm.IBselect.fieldbyname('credicm').AsCurrency;
  dm.IBQuery1.ParamByName('basecred').AsCurrency := dm.IBselect.fieldbyname('basecred').AsCurrency;
  dm.IBQuery1.ParamByName('debicm').AsCurrency   := dm.IBselect.fieldbyname('debicm').AsCurrency;
  dm.IBQuery1.ParamByName('basedeb').AsCurrency  := dm.IBselect.fieldbyname('basedeb').AsCurrency;
  dm.IBQuery1.ParamByName('frete').AsCurrency    := dm.IBselect.fieldbyname('frete').AsCurrency;
  dm.IBQuery1.ParamByName('encargos').AsCurrency := dm.IBselect.fieldbyname('encargos').AsCurrency;
  dm.IBQuery1.ParamByName('fracao').AsCurrency   := dm.IBselect.fieldbyname('fracao').AsCurrency;
  dm.IBQuery1.ParamByName('agregado').AsCurrency := dm.IBselect.fieldbyname('agregado').AsCurrency;
  dm.IBQuery1.ParamByName('sal').AsCurrency      := dm.IBselect.fieldbyname('sal').AsCurrency;
  dm.IBQuery1.ParamByName('sad').AsCurrency      := dm.IBselect.fieldbyname('sad').AsCurrency;;
  dm.IBQuery1.ParamByName('sugestao').AsCurrency := dm.IBselect.fieldbyname('sugestao').AsCurrency;
  dm.IBQuery1.ParamByName('compra').AsCurrency   := dm.IBselect.fieldbyname('compra').AsCurrency;
  dm.IBQuery1.ParamByName('dev_icm').AsCurrency  := dm.IBselect.fieldbyname('dev_icm').AsCurrency;
  dm.IBQuery1.ParamByName('equiva').AsString     := dm.IBselect.fieldbyname('equiva').AsString;
  dm.IBQuery1.ParamByName('DATA_DELETED').AsDate := FORM22.datamov;
  dm.IBQuery1.ParamByName('usuario').AsString    := StrNum(form22.codusario);
  dm.IBQuery1.ExecSQL;

  dm.IBQuery1.Close;
  dm.IBQuery1.SQL.Text := 'delete from produto where cod = :cod';
  dm.IBQuery1.ParamByName('cod').AsInteger := cod1;
  dm.IBQuery1.ExecSQL;

  try
    dm.IBQuery1.Transaction.Commit;
    funcoes.gravaAlteracao('Produto Excluido Cod: ' + IntToStr(cod1) + 'Nome: ' + nome1, 'PRO');
    JsEdit.LimpaCampos(self.Name);
  except
    on e:exception do
      begin
        MessageDlg('O produto Não Foi Excluído!' + #13 + e.Message, mtError, [mbOK], 1);
      end;
  end;

  dm.IBselect.Close;
end;

procedure TForm9.igualKeyPress(Sender: TObject; var Key: Char);
begin
  if key = #13 then
    begin
      if not desconto.Visible then
        begin
          JsBotao1.SetFocus;
          abort;
        end;
    end;
end;

procedure TForm9.Edit1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = 38) then
    begin
      equiva.SetFocus;
    end;
    //seta abaixo - não passa do primeiro e nem do último para baixo
    if (Key = 40)then OBS.SetFocus;
end;

end.




