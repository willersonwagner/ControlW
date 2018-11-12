unit untVisualizaNFCe;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, Grids, ActnList,
  XPStyleActnCtrls, ActnMan, StdCtrls, Mask, ToolEdit, ComCtrls, ToolWin,
  DBGrids, DB, untNFCe, OleCtrls, SHDocVw;

type
  TfrmConsultaNotas = class(TForm)
    pnl: TPanel;
    ToolBar1: TToolBar;
    ToolButton2: TToolButton;
    Panel1: TPanel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    edtDataInicial: TDateEdit;
    edtDataFinal: TDateEdit;
    cbx: TComboBox;
    act: TActionManager;
    actImprimir: TAction;
    actAtualizar: TAction;
    actFiltrar: TAction;
    dbGrid: TDBGrid;
    ToolButton1: TToolButton;
    ToolButton3: TToolButton;
    procedure actAtualizarExecute(Sender: TObject);
    procedure dbGridDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure actImprimirExecute(Sender: TObject);
  private
    { Private declarations }
    procedure ConsutarCupons;
  public
    { Public declarations }
  end;

var
  frmConsultaNotas: TfrmConsultaNotas;

implementation

{$R *.dfm}

procedure TfrmConsultaNotas.ConsutarCupons;
var
 sql : string;
begin
 sql := ' SELECT S.NUVENDACFE, C.NMCLIENTE, S.DTEMISSAO,  S.HREMISSAO, S.VLTOTAL , '+
        '        NFE_SITUACAO, NFE_RESULTADO, CHAVEACESSO '+
        ' FROM VENDACFE S, CLIENTE C '+
        ' WHERE S.CDCLIENTE = C.CDCLIENTE  ';


 case cbx.ItemIndex of
  1: // Emitidas
    begin
     sql := sql+' AND S.NFE_SITUACAO = ''Transmitida''';
    end;
  2:
    begin
     sql := sql + ' AND S.NFE_SITUACAO = ''Cancelada''';
    end;
 end;

 if(edtDataInicial.Text <> '  /  /    ' ) and (edtDataFinal.Text <> '  /  /    ') then
  begin
   sql := sql+' AND DTEMISSAO BETWEEN '''+FormatDateTime('dd/mm/yy', edtDataInicial.Date)+''' and '''+
             FormatDateTime('dd/mm/yy', edtDataFinal.Date)+'''';
  end;

 sql := sql+' ORDER BY 1 DESC';

end;
                
procedure TfrmConsultaNotas.actAtualizarExecute(Sender: TObject);
begin
 ConsutarCupons;
end;

procedure TfrmConsultaNotas.dbGridDrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn;
  State: TGridDrawState);
begin
  { if (qryNotas.FieldByName('NFE_SITUACAO').AsString  = 'Transmitida') and
      (qryNotas.FieldByName('NFE_RESULTADO').AsString = 'Processando') then
    begin
     dbGrid.Canvas.Font.Color   := clPurple;
     dbGrid.Canvas.Brush.Color  := clWhite;
     dbGrid.Canvas.Font.Style   := [fsBold];
     dbGrid.Canvas.FillRect(Rect);
     dbGrid.DefaultDrawColumnCell(Rect,DataCol,Column,state);
    end else

 if (qryNotas.FieldByName('NFE_SITUACAO').AsString  = 'Transmitida') and
    (qryNotas.FieldByName('NFE_RESULTADO').AsString = 'Autorizada') then
  begin
   dbGrid.Canvas.Font.Color   := clBlue;
   dbGrid.Canvas.Brush.Color  := clWhite;
   dbGrid.Canvas.Font.Style   := [fsBold];
   dbGrid.Canvas.FillRect(Rect);
   dbGrid.DefaultDrawColumnCell(Rect,DataCol,Column,state);
  end else
    if (qryNotas.FieldByName('NFE_SITUACAO').AsString  = 'Cancelada') and
       (qryNotas.FieldByName('NFE_RESULTADO').AsString = 'Cancelada') then
     begin
      dbGrid.Canvas.Font.Color   := clRed;
      dbGrid.Canvas.Brush.Color  := clWhite;
      dbGrid.Canvas.Font.Style   := [fsBold];
      dbGrid.Canvas.FillRect(Rect);
      dbGrid.DefaultDrawColumnCell(Rect,DataCol,Column,state);
     end else
      begin
       dbGrid.Canvas.Font.Color   := clBlack;
       dbGrid.Canvas.Brush.Color  := clWhite;
       dbGrid.Canvas.Font.Style   := [fsBold];
       dbGrid.Canvas.FillRect(Rect);
       dbGrid.DefaultDrawColumnCell(Rect,DataCol,Column,state);
      end;
  }
end;

procedure TfrmConsultaNotas.actImprimirExecute(Sender: TObject);
begin
 //Imprimir_DANFE_PDF(qry, qryNotas.FieldByName('nuvendacfe').AsString);
 
end;

end.
