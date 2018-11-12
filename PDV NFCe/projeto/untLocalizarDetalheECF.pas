unit untLocalizarDetalheECF;

interface

uses forms, IB_Components, StdCtrls, ComCtrls, Buttons, Controls, Grids,
  IB_Grid, Classes, ExtCtrls, idglobal, sysutils, dialogs,
  

  P4InfoVarejo_rotinas, P4InfoVarejo_registro, P4InfoVarejo_localizar, P4InfoVarejo_localizarPessoa,
  P4InfoVarejo_ExportarExcel, P4InfoVarejo_constantes;

type
  Tfrmlocalizardetalheecf = class(TForm)
    grd: TIB_Grid;
    qry: TIB_Query;
    dts: TIB_DataSource;
    Bevel1: TBevel;
    Bevel2: TBevel;
    lblduplicata: TLabel;
    lblunidade: TLabel;
    lblnmunidade: TLabel;
    btnfindunidade: TSpeedButton;
    edtnmdetalhe: TEdit;
    edtcdunidade: TEdit;
    Label3: TLabel;
    edtcdcategoria: TEdit;
    btnfindcategoria: TSpeedButton;
    lblnmcategoria: TLabel;
    Label4: TLabel;
    edtReferencia: TEdit;
    BtnOK: TBitBtn;
    BtnCancelar: TBitBtn;
    BitBtn1: TBitBtn;
    rdgTipoFiltragem: TRadioGroup;
    procedure btnOkClick(Sender: TObject);
    procedure grdDblClick(Sender: TObject);
    procedure edtcdunidadeExit(Sender: TObject);
    procedure btnfindunidadeClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure edtcdunidadeKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure edtcdcategoriaExit(Sender: TObject);
    procedure edtcdcategoriaKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure edtcdcategoriaKeyPress(Sender: TObject; var Key: Char);
    procedure btnfindcategoriaClick(Sender: TObject);
    procedure qryAfterScroll(IB_Dataset: TIB_Dataset);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure edtnmdetalheEnter(Sender: TObject);
    procedure edtnmdetalheExit(Sender: TObject);
    procedure edtnmdetalheKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure edtnmdetalheChange(Sender: TObject);
    procedure edtReferenciaChange(Sender: TObject);
  private   { Private declarations }
    cddetalhe,cdalternativo : string;
    procedure FiltrarProduto();
  public    { Public declarations }
  end;

function LocalizarDetalhe:string;overload;
function LocalizarDetalhe(novo:boolean):string;overload;
function LocalizarDetalhe(codigodebarras:string):string;overload;
function LocalizarDetalhe(novo:Boolean;novoa:Boolean):String;overload;

var
  frmlocalizardetalheecf: Tfrmlocalizardetalheecf;

implementation

uses untNovoProduto;

{$R *.DFM}

function LocalizarDetalhe(novo:Boolean;novoa:Boolean):String;
begin
 if frmlocalizardetalheecf = nil then
  frmlocalizardetalheecf := Tfrmlocalizardetalheecf.Create(application);
  frmlocalizardetalheecf.BringToFront;
  frmlocalizardetalheecf.qry.Refresh;
  frmlocalizardetalheecf.show;
  frmlocalizardetalheecf.BringToFront;
//  if frmlocalizardetalheecf.ModalResult = mrok then
//    result := frmlocalizardetalheecf.cdalternativo;
end;

function LocalizarDetalhe(codigodebarras:string):string;
begin
 if frmlocalizardetalheecf = nil then
  frmlocalizardetalheecf := Tfrmlocalizardetalheecf.Create(application);
  frmlocalizardetalheecf.BringToFront;
  frmlocalizardetalheecf.qry.Refresh;
  Application.ProcessMessages;
  frmlocalizardetalheecf.BringToFront;
  frmlocalizardetalheecf.showmodal;
  if frmlocalizardetalheecf.ModalResult = mrok then
   result := frmlocalizardetalheecf.cdalternativo;
end;


function LocalizarDetalhe(novo:boolean):string;
begin
  if frmlocalizardetalheecf = nil then
   frmlocalizardetalheecf := Tfrmlocalizardetalheecf.Create(application);
   frmlocalizardetalheecf.BringToFront;
   frmlocalizardetalheecf.qry.Refresh;
   frmlocalizardetalheecf.BringToFront;
   frmlocalizardetalheecf.showmodal;
  if frmlocalizardetalheecf.ModalResult = mrok then
    result := frmlocalizardetalheecf.cddetalhe;
end;


function Localizardetalhe:string;
begin
  if frmlocalizardetalheecf = nil then
     frmlocalizardetalheecf := Tfrmlocalizardetalheecf.Create(application);
     frmlocalizardetalheecf.qry.Refresh;
     frmlocalizardetalheecf.BringToFront;
     frmlocalizardetalheecf.showmodal;
  if frmlocalizardetalheecf.ModalResult = mrok then
    result := frmlocalizardetalheecf.cddetalhe;
end;

procedure Tfrmlocalizardetalheecf.btnOkClick(Sender: TObject);
begin
 ModalResult := mrOk;
end;

procedure Tfrmlocalizardetalheecf.grdDblClick(Sender: TObject);
begin
 if qry.RecordCount >= 1 then
  if btnok.enabled then btnOkClick(sender);
end;

procedure Tfrmlocalizardetalheecf.edtcdunidadeExit(Sender: TObject);
var
  cod: string;
begin
  cod := edtCdunidade.text;
  if cod <> '' then
  begin
    if not CodigoExiste('unidade', cod) then
    begin
      messagedlg('Código '+cod+' inexistente na tabela Unidade.', mterror, [mbok], 0);
      edtcdunidade.setfocus;
      abort;
    end
    else
      lblnmunidade.Caption := NomedoCodigo('unidade', cod);
  end
  else
    lblnmunidade.caption := '';
end;

procedure Tfrmlocalizardetalheecf.btnfindunidadeClick(Sender: TObject);
var
  cod : string;
begin
  cod := Localizar('unidade','Unidade');
  if cod <> '' then
  begin
    edtcdunidade.text    := cod;
    lblnmunidade.caption := NomedoCodigo('unidade', cod);
  end;
end;

procedure Tfrmlocalizardetalheecf.FormShow(Sender: TObject);
var
 sql : string;
begin
 edtnmdetalhe.SetFocus;
 edtnmdetalhe.SelectAll;

 sql := ' SELECT CDDETALHE, CDALTERNATIVO, NMDETALHE, VLVENDA, QTESTOQUE, '+
        '        NMALIQUOTA, NMUNIDADE,DSREFERENCIA FROM DETALHE          '+
        ' LEFT JOIN ALIQUOTA ON ALIQUOTA.CDALIQUOTA = DETALHE.CDALIQUOTA  '+
        ' LEFT JOIN UNIDADE  ON UNIDADE.CDUNIDADE   = DETALHE.CDUNIDADE   '+
        ' WHERE CDDETALHE > 0                                             '+
        ' and (bolcomposicao is null) or (bolcomposicao = ''N'')          ';

 sql := sql + 'AND(DETALHE.BOLATIVO is null) or (DETALHE.BOLATIVO = ''S'') ';
 sql := sql + ' order by cdalternativo';
 qry.close;
 qry.sql.clear;
 qry.sql.add(sql);
 qry.open;

 if qry.RecordCount > 0 then
  btnOk.Enabled := true
 else btnOk.Enabled  := false;


end;

procedure Tfrmlocalizardetalheecf.edtcdunidadeKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if key = P4InfoVarejo_keysearch then
    btnfindunidadeClick(sender);
end;

procedure Tfrmlocalizardetalheecf.edtcdcategoriaExit(Sender: TObject);
var
  cod: string;
begin
  cod := edtCdcategoria.text;
  if cod <> '' then
  begin
    if not CodigoExiste('categoria', cod) then
    begin
      messagedlg('Código '+cod+' inexistente na tabela Categoria.', mterror, [mbok], 0);
      edtcdcategoria.setfocus;
      abort;
    end
    else
      lblnmcategoria.Caption := NomedoCodigo('categoria', cod);
  end
  else
    lblnmcategoria.caption := '';
end;

procedure Tfrmlocalizardetalheecf.edtcdcategoriaKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if key = P4InfoVarejo_keysearch then
    btnfindcategoriaClick(sender);
end;

procedure Tfrmlocalizardetalheecf.edtcdcategoriaKeyPress(Sender: TObject;
  var Key: Char);
begin
  if not (key in ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9', char(8), char(13)]) then  key := #0;
end;

procedure Tfrmlocalizardetalheecf.btnfindcategoriaClick(Sender: TObject);
var
  cod : string;
begin
  cod := Localizar('categoria','Categoria');
  if cod <> '' then
  begin
    edtcdcategoria.text    := cod;
    lblnmcategoria.caption := NomedoCodigo('categoria', cod);
  end;
end;

procedure Tfrmlocalizardetalheecf.qryAfterScroll(IB_Dataset: TIB_Dataset);
begin
 cddetalhe     := qry.fieldbyname('cddetalhe').asstring;
 cdalternativo := qry.fieldbyname('cdalternativo').asstring;
end;

procedure Tfrmlocalizardetalheecf.FormKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
 if char(key) = #40 then grd.SetFocus;
end;

procedure Tfrmlocalizardetalheecf.edtnmdetalheEnter(Sender: TObject);
begin
 BtnOK.Default := false;     // desabilitar o ModalResult                       // leandro
end;

procedure Tfrmlocalizardetalheecf.edtnmdetalheExit(Sender: TObject);
begin
 BtnOK.Default := true;     // habilitar o ModalResult                          // leandro
end;

procedure Tfrmlocalizardetalheecf.edtnmdetalheKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
// if char(key) = #13 then BitBtn1Click(sender); //no ENTER aponta botao pesquiza // leandro 
end;

procedure Tfrmlocalizardetalheecf.FiltrarProduto();
var
 sql : string;
begin
 sql := ' SELECT CDDETALHE, CDALTERNATIVO, NMDETALHE, VLVENDA, QTESTOQUE, '+
         '        NMALIQUOTA, NMUNIDADE,DSREFERENCIA FROM DETALHE          '+
         ' LEFT JOIN ALIQUOTA ON ALIQUOTA.CDALIQUOTA = DETALHE.CDALIQUOTA  '+
         ' LEFT JOIN UNIDADE  ON UNIDADE.CDUNIDADE   = DETALHE.CDUNIDADE   '+
         ' WHERE CDDETALHE > 0                                             ';
//         ' AND(DETALHE.BOLATIVO is null) or (DETALHE.BOLATIVO = ''S'')     ';

  if edtReferencia.Text  <> '' then sql := sql + ' and dsreferencia like '''+edtReferencia.Text+'%'' ';
  if edtnmdetalhe.text   <> '' then sql := sql + ' and nmdetalhe like '''+edtnmdetalhe.text+'%'' ';
  if edtcdunidade.text   <> '' then sql := sql + ' and detalhe.cdunidade   = '''+edtcdunidade.text+'''';
  if edtcdcategoria.text <> '' then sql := sql + ' and detalhe.cdcategoria = '''+edtcdcategoria.text+'''';

  // 0 -> Somente Produtos Simples !!
  // 1 -> Somente Produtos de Compisição !!
  
       if rdgTipoFiltragem.ItemIndex = 0 then sql := sql+' and (bolcomposicao is null) or (bolcomposicao = ''N'')'
  else if rdgTipoFiltragem.ItemIndex = 1 then sql := sql+' and (bolcomposicao = ''S'')';

  sql := sql + ' order by cdalternativo';
  qry.close;
  qry.sql.clear;
  qry.sql.add(sql);
  qry.open;
  if qry.RecordCount > 0 then
    btnOk.Enabled := true
  else btnOk.Enabled  := false;
end;

procedure Tfrmlocalizardetalheecf.edtnmdetalheChange(Sender: TObject);
begin
 FiltrarProduto();
end;

procedure Tfrmlocalizardetalheecf.edtReferenciaChange(Sender: TObject);
begin
 FiltrarProduto();
end;

end.
