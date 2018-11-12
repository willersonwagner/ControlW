unit untFinalizaVenda;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, Grids, StdCtrls, Buttons, Mask, ToolEdit,
  CurrEdit;

type
  TfrmFinalizaVenda = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    BtnFinalizar: TBitBtn;
    BtnCancelar: TBitBtn;
    Label9: TLabel;
    edtTotalproduto: TCurrencyEdit;
    edtDesconto: TCurrencyEdit;
    Label1: TLabel;
    edtAcrescimo: TCurrencyEdit;
    Label3: TLabel;
    BtnCalcAcresDesconto: TSpeedButton;
    Label23: TLabel;
    edtRecebido: TCurrencyEdit;
    edtTroco: TCurrencyEdit;
    Label24: TLabel;
    btnPagamentoParcelado: TSpeedButton;
    btnObservacao: TSpeedButton;
    procedure qryError(Sender: TObject; const ERRCODE: Integer;
      ErrorMessage, ErrorCodes: TStringList; const SQLCODE: Integer;
      SQLMessage, SQL: TStringList; var RaiseException: Boolean);
    procedure grdFormaPagtoKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
    svltroco        : string;
    bolCadCheque,
    bolTefDial,
    bolTefDisc,
    bolTefHiper,
    bolFlagContaCC,
    bolTefDedicado : boolean;
    sTEFDiscado,
    sFlagContaCC,
    sTEFDedicado   : String;
    identificacao  : integer;
    sIdentificacao : String;
    BolPagParcel : Boolean;
    BbolDAV      : Boolean;
    scdvendacfe  : String;
    cdformapagto : TStrings;
    nmformapagto : TStrings;
    function  Abrir(codigo:string):boolean;
    function  Valida_Formas_Pagamento():Boolean;
    procedure Calcular_Fechamento;
    procedure AbrirTabelas;
    procedure Novo;
   procedure DeleteDuplRec;
  public
    function dlgFinalizaVenda(cdVendaCFE:String;pValorTotal:Currency):Boolean;
    { Public declarations }
  end;

var
  frmFinalizaVenda: TfrmFinalizaVenda;

implementation

uses untDtmMain,
     untdlgObservacao;



{$R *.dfm}


function TfrmFinalizaVenda.dlgFinalizaVenda(cdVendaCFE:String;pValorTotal:Currency):Boolean;
begin
end;

procedure TfrmFinalizaVenda.Calcular_Fechamento;
begin
end;

procedure TfrmFinalizaVenda.AbrirTabelas;
begin
end;

function TfrmFinalizaVenda.Abrir(codigo:string):boolean;
begin
end;

procedure TfrmFinalizaVenda.Novo;
begin
end;

procedure TfrmFinalizaVenda.qryError(Sender: TObject;
  const ERRCODE: Integer; ErrorMessage, ErrorCodes: TStringList;
  const SQLCODE: Integer; SQLMessage, SQL: TStringList;
  var RaiseException: Boolean);
begin
 //
end;

procedure TfrmFinalizaVenda.grdFormaPagtoKeyPress(Sender: TObject;
  var Key: Char);
begin
end;

///////////////////////////////////////////////////////////////////////
//                  Pagamento Parcelado !!!!
///////////////////////////////////////////////////////////////////////

function  TfrmFinalizaVenda.Valida_Formas_Pagamento():Boolean;
begin
end;

procedure TfrmFinalizaVenda.DeleteDuplRec;
begin
end;

end.

