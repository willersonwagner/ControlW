unit untControleSaidaProdutoControlado;

interface

uses forms, IB_Components, Menus, Classes, ActnList, ComCtrls, ToolWin,
  sysutils, StdCtrls, IB_Grid, IB_Controls, Controls, Mask, ExtCtrls,

  P4InfoVarejo_registro, P4InfoVarejo_form, P4InfoVarejo_Constantes;

type
  TfrmControleSaidaProdutoControlado = class(TForm)
    act: TActionList;
    actNovo: TAction;
    actSalvar: TAction;
    actCancelar: TAction;
    ntb: TNotebook;
    Panel2: TPanel;
    Label3: TLabel;
    qry: TIB_Query;
    dts: TIB_DataSource;
    edtNomeCliente: TEdit;
    Label1: TLabel;
    edtCodigoCliente: TEdit;
    mnm: TMainMenu;
    Registro1: TMenuItem;
    Salvar1: TMenuItem;
    Cancelar1: TMenuItem;
    Panel1: TPanel;
    ntbdetalhe: TNotebook;
    ToolBar4: TToolBar;
    ToolButton12: TToolButton;
    ToolButton13: TToolButton;
    Panel11: TPanel;
    gbxComercial: TGroupBox;
    Label5: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    edtlote: TIB_Edit;
    edtdtvenda: TIB_Edit;
    edtfabricacao: TIB_Edit;
    edtdtprevfimuso: TIB_Edit;
    edtnudiasduracao: TIB_Edit;
    trnCliente: TIB_Transaction;
    pnl: TPanel;
    edtvalidade: TIB_Edit;
    Label23: TLabel;
    Label4: TLabel;
    edtNomeProduto: TEdit;
    edtCodigoProduto: TEdit;
    Label6: TLabel;
    procedure actSalvarExecute(Sender: TObject);
    procedure actCancelarExecute(Sender: TObject);
    procedure qryBeforePost(IB_Dataset: TIB_Dataset);
    procedure dtsStateChanged(Sender: TIB_DataSource;
      ADataset: TIB_Dataset);
    procedure qryError(Sender: TObject; const ERRCODE: Integer;
      ErrorMessage, ErrorCodes: TStringList; const SQLCODE: Integer;
      SQLMessage, SQL: TStringList; var RaiseException: Boolean);
    procedure qryAfterDelete(IB_Dataset: TIB_Dataset);
    procedure qryBeforeDelete(IB_Dataset: TIB_Dataset);
    procedure nextcontrol(Sender: TObject; var Key: Char);
  private      { Private declarations }
  procedure CarregaDadosCliente(cdcliente, cddetalhe, dslote:string;dtfabricacao, dtvalidade:TDate);
  public  { Public declarations }
  end;

function ControleVendaProdutoControlado(cdcliente, cddetalhe, dslote:string;dtfabricacao, dtvalidade:TDate):Boolean;

const
  tbl      = 'SAIDAPRODCONTROLADO';
  exibe    = 'Controle de Cliente/Medicamento de Uso Contínuo';
  artigoI  = 'o';
  artigoII = 'e';
var
  frmControleSaidaProdutoControlado: TfrmControleSaidaProdutoControlado;

implementation

uses untDtmMain;

{$R *.DFM}


function ControleVendaProdutoControlado(cdcliente, cddetalhe, dslote:string;dtfabricacao, dtvalidade:TDate):Boolean;
begin
 Result := false;
 try
  frmControleSaidaProdutoControlado := TfrmControleSaidaProdutoControlado.Create(nil);
  with frmControleSaidaProdutoControlado do
   begin
    Position := poScreenCenter;
    CarregaDadosCliente(cdcliente,cddetalhe,dslote,dtfabricacao,dtvalidade);
    ShowModal;
    if ModalResult = MrOk then Result := true;
   end;
 finally
  FreeAndNil(frmControleSaidaProdutoControlado);
 end;
end;

procedure TfrmControleSaidaProdutoControlado.CarregaDadosCliente(cdcliente, cddetalhe, dslote:string;dtfabricacao, dtvalidade:TDate);
var
 qr         : TIB_Query;
 sql        : string;
 scdcliente : string;
begin
 sql := ' select cdcliente, nmcliente    '+
        ' from cliente                   '+
        ' where cdcliente = '+cdcliente+'';
 try
  qr := TIB_Query.Create(nil);
  qr.SQL.Add(sql);
  qr.Open;
  edtCodigoCliente.Text := qr.FieldByName('cdcliente').AsString;
  edtNomeCliente.Text   := qr.FieldByName('nmcliente').AsString;
  scdcliente            := qr.FieldByName('CDCLIENTE').AsString;

  sql := ' SELECT CDDETALHE, NMDETALHE, BOLCONTROLADO, DSLOTE, DTFABRICACAO, DTVALIDADE  '+
         ' FROM DETALHE D, ESTOQUE E                                                     '+
         ' WHERE D.CDDETALHE  = E.CDDETALHE                                              '+
         ' AND  D.CDDETALHE   = '+cddetalhe+'                                            '+
         ' AND  DSLOTE        = '''+dslote+'''                                           '+
         ' AND  DTVALIDADE    = '''+FormatDateTime(P4InfoVarejo_dtbanco,dtvalidade)+'''  '+
         ' AND  DTFABRICACAO  = '''+FormatDateTime(P4InfoVarejo_dtbanco,dtfabricacao)+'''';

  qr.Close;
  qr.SQL.Clear;
  qr.SQL.Add(sql);
  qr.Open;
  //
  edtCodigoProduto.Text := qr.FieldByName('cddetalhe').AsString;
  edtNomeProduto.Text   := qr.FieldByName('nmdetalhe').AsString;
  scdcliente            := qry.FieldByName('CDCLIENTE').AsString;

  qry.Insert;

  qry.FieldByName('CDDETALHE').AsString  := qr.FieldByName('cddetalhe').AsString;
  qry.FieldByName('DSLOTE').AsString     := qr.FieldByName('dslote').AsString;
  qry.FieldByName('DTFABRICACAO').AsDate := qr.FieldByName('dtfabricacao').AsDate;
  qry.FieldByName('DTVALIDADE').AsDate   := qr.FieldByName('dtvalidade').AsDate;
  qry.FieldByName('DTVENDA').AsDate      := Now;
 finally
  FreeAndNil(qr);
 end;
end;

procedure TfrmControleSaidaProdutoControlado.actSalvarExecute(Sender: TObject);
begin
 trnCliente.CommitRetaining;
 frmControleSaidaProdutoControlado.ModalResult := mrok;
end;

procedure TfrmControleSaidaProdutoControlado.actCancelarExecute(Sender: TObject);
begin
 trnCliente.RollbackRetaining;
 close;
end;

procedure TfrmControleSaidaProdutoControlado.qryBeforePost(IB_Dataset: TIB_Dataset);
begin
 repeat
  IB_Dataset.fields[0].asstring := inttostr(GerarCodigo(IB_Dataset.IB_Connection, tbl));
 until not CodigoExiste(tbl, IB_Dataset.fields[0].asstring);
 registrainformacao(ib_dataset);
end;

procedure TfrmControleSaidaProdutoControlado.dtsStateChanged(Sender: TIB_DataSource;  ADataset: TIB_Dataset);
var
  ativar : boolean;
begin
 if sender.state = dssdelete then exit;
 ativar := false;
      if (sender.state = dssedit)   or (sender.state = dssinsert)   then ativar := false
 else if (sender.State = dssBrowse) or (sender.State = dssPrepared) then ativar := true;
 actSalvar.Enabled    := not ativar;
 actCancelar.Enabled  := not ativar;
end;

procedure TfrmControleSaidaProdutoControlado.qryError(Sender: TObject; const ERRCODE: Integer;
  ErrorMessage, ErrorCodes: TStringList; const SQLCODE: Integer;
  SQLMessage, SQL: TStringList; var RaiseException: Boolean);
begin
 if ErroQuery(sender, errcode, SQLCODE, errormessage, errorcodes, sqlmessage, sql, artigoI, artigoII, exibe) then
  abort;
end;

procedure TfrmControleSaidaProdutoControlado.qryAfterDelete(IB_Dataset: TIB_Dataset);
begin
 trnCliente.Commit;
end;

procedure TfrmControleSaidaProdutoControlado.qryBeforeDelete(IB_Dataset: TIB_Dataset);
begin
 trnCliente.StartTransaction;
end;

procedure TfrmControleSaidaProdutoControlado.nextcontrol(Sender: TObject; var Key: Char);
begin
 if key = #13 then
  begin
   SelectNext(sender as twincontrol, true, true);
   key := #0;
  end;
end;

end.
