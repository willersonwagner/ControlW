unit cadnotasfiscais;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, JsEditTexto1, JsEdit1, JsEditInteiro1,
  ToolWin, ComCtrls, ExtCtrls, JsBotao1, Vcl.Mask, JsEditData1;

type
  TCadNotasFiscais1 = class(TForm)
    painel: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    cod: JsEditInteiro;
    nota: JsEditInteiro;
    pedido: JsEditInteiro;
    data: JsEditData;
    ToolBar1: TPanel;
    info: TLabel;
    JsBotao1: JsBotao;
    JsBotao2: JsBotao;
    procedure codKeyPress(Sender: TObject; var Key: Char);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure codKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure JsBotao1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure JsBotao2Click(Sender: TObject);
    procedure codEnter(Sender: TObject);
    procedure nomeEnter(Sender: TObject);
  private
    function validaDados() : boolean;
    { Private declarations }
  public
    valor_a_retornar : string;
    { Public declarations }
  end;

var
  CadNotasFiscais1: TCadNotasFiscais1;
  ultcod : integer;

implementation

uses Unit1, localizar, func;
{$R *.dfm}

procedure TCadNotasFiscais1.codKeyPress(Sender: TObject; var Key: Char);
begin
 if key = #27 then self.Close;
end;

procedure TCadNotasFiscais1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  JsEdit.LiberaMemoria(self);
end;


procedure TCadNotasFiscais1.codKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
if (Key = 116) then
 begin
   tedit(sender).Text := funcoes.localizar('Localizar Notas Fiscais','SPED_MOVFISCAIS','cod,nota, data,pedido ','cod','','pedido','cod',true,false,false,'',300,sender);
 end;
end;

procedure TCadNotasFiscais1.JsBotao1Click(Sender: TObject);
begin
  if not validaDados then exit;
  
  valor_a_retornar := JsEdit.GravaNoBD(self);
end;

procedure TCadNotasFiscais1.FormShow(Sender: TObject);
begin
JsEdit.SetTabelaDoBd(self,'SPED_MOVFISCAIS', dm.IBQuery1);
end;

procedure TCadNotasFiscais1.JsBotao2Click(Sender: TObject);
begin
  JsEdit.ExcluiDoBD(self.Name);
end;

procedure TCadNotasFiscais1.codEnter(Sender: TObject);
begin

ultCod := JsEdit.UltimoCodigoDaTabela(self.Name);
  info.Caption := ' F5 - Consulta    Ultimo Código: ' + inttostr(ultCod);

end;

procedure TCadNotasFiscais1.nomeEnter(Sender: TObject);
begin
  if ((cod.Text <> '') or (cod.Text <> '0')) then
    begin
      valor_a_retornar := cod.Text;
    end;
end;

function TCadNotasFiscais1.validaDados() : boolean;
var
  pedido1, nota1 : integer;
begin
  Result := false;
  pedido1 := StrToInt(strnum(pedido.Text));
  nota1   := StrToInt(strnum(nota.Text));

  dm.IBselect.Close;
  dm.IBselect.SQL.Text := 'select nota, total from venda where nota = :nota';
  dm.IBselect.ParamByName('nota').AsInteger := pedido1;
  dm.IBselect.Open;

  if dm.IBselect.IsEmpty then begin
    dm.IBselect.Close;
    ShowMessage('Venda ' + IntToStr(pedido1) + ' Não Encontrada!');
    pedido.SetFocus;
    exit;
  end;

  ShowMessage('Venda ' + IntToStr(pedido1) + ' Encontrada!' + #13 + 'Valor: ' + formatcurr('#,###,###0.00', dm.IBselect.FieldByName('total').AsCurrency));
  dm.IBselect.Close;

  Result := true;
end;

end.
