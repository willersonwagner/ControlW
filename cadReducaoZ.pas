unit cadReducaoZ;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, JsBotao1, ExtCtrls, JsEditNumero1, JsEdit1,
  JsEditInteiro1, Mask, JsEditData1, FUNC;

type
  TcadReducao = class(TForm)
    Label1: TLabel;
    Label20: TLabel;
    Label5: TLabel;
    Label3: TLabel;
    Label2: TLabel;
    Label4: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    cod: JsEditInteiro;
    CONT_REDUCAOZ: JsEditInteiro;
    ecf: JsEditInteiro;
    data: JsEditData;
    CONT_REINICIO: JsEditNumero;
    CONT_OP: JsEditNumero;
    TOT_GERAL: JsEditNumero;
    TOT_CANC: JsEditNumero;
    TOT_ALIQ01: JsEditNumero;
    TOT_ALIQ02: JsEditNumero;
    TOT_ALIQ03: JsEditNumero;
    TOT_ALIQ04: JsEditNumero;
    TOT_ALIQ05: JsEditNumero;
    TOT_ALIQ06: JsEditNumero;
    TOT_ALIQ07: JsEditNumero;
    TOT_ALIQ08: JsEditNumero;
    TOT_DESC: JsEditNumero;
    TOT_FF: JsEditNumero;
    TOT_II: JsEditNumero;
    TOT_NN: JsEditNumero;
    ToolBar1: TPanel;
    JsBotao1: JsBotao;
    JsBotao2: JsBotao;
    procedure JsBotao1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure CONT_REDUCAOZKeyPress(Sender: TObject; var Key: Char);
    procedure ecfKeyPress(Sender: TObject; var Key: Char);
    procedure dataKeyPress(Sender: TObject; var Key: Char);
    procedure codKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure JsBotao2Click(Sender: TObject);
  private
    procedure buscaReducao();
    { Private declarations }
  public
    { Public declarations }
  end;

var
  cadReducao: TcadReducao;

implementation

uses Unit1;

{$R *.dfm}

procedure TcadReducao.buscaReducao();
begin
  dm.IBselect.Close;
  dm.IBselect.SQL.Text := 'select cod from SPED_REDUCAOZ where CONT_REDUCAOZ = :data and ecf = :ecf';
  dm.IBselect.ParamByName('data').AsInteger  := StrToIntDef(StrNum(CONT_REDUCAOZ.Text), -1);
  dm.IBselect.ParamByName('ecf').AsInteger   := StrToIntDef(ecf.Text, 0);
  dm.IBselect.Open;

  if dm.IBselect.IsEmpty then
    begin
      cod.Text := '0';
      dm.IBselect.Close;
      exit;
    end
  ELSE
    BEGIN
      cod.Text := dm.IBselect.fieldbyname('cod').AsString;
      JsEdit.SelecionaDoBD(self.Name);
      dm.IBselect.Close;
      exit;
    END;


  //cod.Text := dm.IBselect.fieldbyname('cod').AsString;
  //JsEdit.SelecionaDoBD(self.Name, TRUE, 'WHERE CONT_REDUCAOZ = ' + StrNum(CONT_REDUCAOZ.Text) + ' AND ECF = ' + StrNum(ECF.Text));
  dm.IBselect.Close;
end;

procedure TcadReducao.JsBotao1Click(Sender: TObject);
begin
  if StrNum(cod.Text) = '0' then cod.Text := Incrementa_Generator('SPED_REDUCAOZ', 1);
  //cod.Text := CONT_REDUCAOZ.Text;
  JsEdit.GravaNoBD(self);
end;

procedure TcadReducao.FormShow(Sender: TObject);
begin
  JsEdit.SetTabelaDoBd(self, 'SPED_REDUCAOZ', dm.ibquery1);
end;

procedure TcadReducao.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  JsEdit.LiberaMemoria(self);
end;

procedure TcadReducao.CONT_REDUCAOZKeyPress(Sender: TObject; var Key: Char);
var
  tm1 : string;
begin
  if key = #13 then
    begin
      {cod.Text := CONT_REDUCAOZ.Text;

      if CONT_REDUCAOZ.Text <> '' then
        begin
          if not JsEdit.SelecionaDoBD(self.Name, false, ' CONT_REDUCAOZ = ' + CONT_REDUCAOZ.Text) then
            begin
              tm1 := CONT_REDUCAOZ.Text;
              JsEdit.LimpaCampos(self.Name);
              CONT_REDUCAOZ.Text := tm1;
              data.SetFocus;
            end;
        end;}
    end;
  if key = #27 then Close;
end;

procedure TcadReducao.ecfKeyPress(Sender: TObject; var Key: Char);
begin
  if key = #13 then buscaReducao();
end;

procedure TcadReducao.dataKeyPress(Sender: TObject; var Key: Char);
begin
  if key = #27 then Close;
end;

procedure TcadReducao.codKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  //funcoes.localizar1('Localizar Grupo','grupoprod','cod,nome','cod','','nome','nome',true,false,false,'cod', tedit(sender).Text,300,sender);
  if key = 116 then tedit(sender).Text := funcoes.localizar1('Localizar Reduções', 'SPED_REDUCAOZ', '*', 'cod', '', 'cod', 'cod', true, false, false, 'cod', tedit(sender).Text, 400, nil);
end;

procedure TcadReducao.JsBotao2Click(Sender: TObject);
begin
  JsEdit.ExcluiDoBD(self.Name);
end;

end.
