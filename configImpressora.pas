unit configImpressora;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, JsEdit1, JsEditInteiro1, Buttons, JsBotao1, ExtCtrls, printers,
  ComCtrls, ACBrETQ, typinfo,ACBrCargaBal, ACBrBase;

type
  TForm52 = class(TForm)
    ToolBar1: TPanel;
    JsBotao1: JsBotao;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    ComboBox1: TComboBox;
    JsEditInteiro1: JsEditInteiro;
    JsEditInteiro2: JsEditInteiro;
    JsEditInteiro3: JsEditInteiro;
    ComboBox2: TComboBox;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    JsEditInteiro4: JsEditInteiro;
    Label7: TLabel;
    matri: TRadioButton;
    usb: TRadioButton;
    modelo: TComboBox;
    Label8: TLabel;
    distancia: JsEditInteiro;
    impressCodBar: TComboBox;
    Label9: TLabel;
    Label10: TLabel;
    tipoEtiqueta: TComboBox;
    GroupBox1: TGroupBox;
    FonteRelatorioVisual: JsEditInteiro;
    negritoFonteVisual: TCheckBox;
    Label11: TLabel;
    TabSheet3: TTabSheet;
    cbxModelo: TComboBox;
    Label12: TLabel;
    procedure FormShow(Sender: TObject);
    procedure JsBotao1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ComboBox1KeyPress(Sender: TObject; var Key: Char);
    procedure ComboBox2KeyPress(Sender: TObject; var Key: Char);
    procedure JsEditInteiro1KeyPress(Sender: TObject; var Key: Char);
    procedure JsEditInteiro2KeyPress(Sender: TObject; var Key: Char);
    procedure JsEditInteiro4KeyPress(Sender: TObject; var Key: Char);
    procedure JsEditInteiro3KeyPress(Sender: TObject; var Key: Char);
    procedure CheckBox1KeyPress(Sender: TObject; var Key: Char);
    procedure CheckBox2KeyPress(Sender: TObject; var Key: Char);
    procedure JsBotao1KeyPress(Sender: TObject; var Key: Char);
    procedure ComboBox2Exit(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    tmp, arqConfig : String;
    function salvaConfig() :  String;
    procedure preencheFORM(valor : String);
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form52: TForm52;

implementation

uses func, StrUtils, principal;

{$R *.dfm}
procedure TForm52.preencheFORM(valor : String);
begin
 ComboBox1.Items := printer.Printers;
 //ComboBox1.ItemIndex := StrToIntDef(funcoes.LerConfig(valor, 0), 0);
 ComboBox1.Text      := trim(funcoes.LerConfig(valor, 15));

 if ComboBox1.Text = '' then ComboBox1.ItemIndex := 0;

 ComboBox2.ItemIndex := StrToIntDef(funcoes.LerConfig(valor, 1), 0);
 JsEditInteiro1.Text := IntToStr(StrToIntDef(funcoes.LerConfig(valor, 2), 5));
 JsEditInteiro2.Text := IntToStr(StrToIntDef(funcoes.LerConfig(valor, 3), 5));
 JsEditInteiro3.Text := IntToStr(StrToIntDef(funcoes.LerConfig(valor, 4), 11));
 JsEditInteiro4.Text := IntToStr(StrToIntDef(funcoes.LerConfig(valor, 7), 0));

 FonteRelatorioVisual.Text  := IntToStr(StrToIntDef(funcoes.LerConfig(valor, 13), 10));

 if funcoes.LerConfig(valor, 16) = 'S' then negritoFonteVisual.Checked := true;
 if funcoes.LerConfig(valor, 5) = 'S' then CheckBox1.Checked := true;
 if funcoes.LerConfig(valor, 6) = 'S' then CheckBox2.Checked := true;

 if funcoes.LerConfig(valor, 8) <> '' then impressCodBar.Text := funcoes.LerConfig(valor, 8);

 modelo.ItemIndex        := StrToIntDef(funcoes.LerConfig(valor, 10), 0);

 distancia.Text := funcoes.LerConfig(valor, 11);

 tipoEtiqueta.ItemIndex := StrToIntDef(funcoes.LerConfig(valor, 12), 1);
 cbxmodelo.ItemIndex    := StrToIntDef(funcoes.LerConfig(valor, 14), 0);

 if distancia.Text = '' then distancia.Text := '300';

 if funcoes.LerConfig(valor, 9) <> 'U' then matri.Checked := true
   else usb.Checked := true;
end;

{
 0 - indice da impressora
 1 - tipo de impressao *** 0-USB1 1-UBS2 2-LPT1 3-LPT2   ***
 2 - linhas no final
 3 - coluna inicial
 4 - fonte
 5 - negrito
 6 - Fonte Reduzida
 7 - Linhas acima
}

function TForm52.salvaConfig() : String;
var
  arq : TStringList;
  tt  : string;
begin
  tmp := '-0- -1- -2- -3- -4- -5- -6- -7- -8- -9- -10- -11- -12- -13- -14- -15- -16- -17- -18- ' +
  '-19- -20- -';

  arq := TStringList.Create;

  arq.LoadFromFile(arqConfig);
  tmp := GravarConfig(tmp, IntToStr(ComboBox1.ItemIndex), 0);
  tmp := GravarConfig(tmp, IntToStr(ComboBox2.ItemIndex), 1);
  tmp := GravarConfig(tmp, JsEditInteiro1.Text,           2);
  tmp := GravarConfig(tmp, JsEditInteiro2.Text,           3);
  tmp := GravarConfig(tmp, JsEditInteiro3.Text,           4);
  tt := IfThen(CheckBox1.Checked, 'S', 'N');
  tmp := GravarConfig(tmp, tt,                            5);
  tt := IfThen(CheckBox2.Checked, 'S', 'N');
  tmp := GravarConfig(tmp, tt,                            6);

  tmp := GravarConfig(tmp, JsEditInteiro4.Text,           7);
  tmp := GravarConfig(tmp, impressCodBar.Text, 8);
  tmp := GravarConfig(tmp, IfThen(matri.Checked, 'M', 'U')  , 9);
  tmp := GravarConfig(tmp, IntToStr(modelo.ItemIndex), 10);
  tmp := GravarConfig(tmp, distancia.Text, 11);
  tmp := GravarConfig(tmp, IntToStr(tipoEtiqueta.ItemIndex), 12);
  tmp := GravarConfig(tmp, FonteRelatorioVisual.Text, 13);
  tmp := GravarConfig(tmp, IntToStr(cbxmodelo.ItemIndex), 14);
  tmp := GravarConfig(tmp, ComboBox1.Text, 15);

   tt := IfThen(negritoFonteVisual.Checked, 'S', 'N');
  tmp := GravarConfig(tmp, tt,                            16);

  arq.Values['1'] := tmp;
  form22.Pgerais.Values['imp'] := tmp;

  arq.SaveToFile(arqConfig);
  arq.Free;
end;

procedure TForm52.FormShow(Sender: TObject);
begin
  arqConfig := caminhoEXE_com_barra_no_final + funcoes.buscaNomeConfigDat;
  tmp := form22.Pgerais.Values['imp'];
  preencheFORM(tmp);
end;

procedure TForm52.JsBotao1Click(Sender: TObject);
begin
  salvaConfig();
  ShowMessage('Informações atualizadas com sucesso');
end;

procedure TForm52.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  JsEdit.LiberaMemoria(self);
end;

procedure TForm52.ComboBox1KeyPress(Sender: TObject; var Key: Char);
begin
  if key = #27 then close;
  if key = #13 then ComboBox2.SetFocus;
end;

procedure TForm52.ComboBox2KeyPress(Sender: TObject; var Key: Char);
begin
  if key = #13 then JsEditInteiro1.SetFocus;
end;

procedure TForm52.JsEditInteiro1KeyPress(Sender: TObject; var Key: Char);
begin
  if key = #13 then JsEditInteiro2.SetFocus;
end;

procedure TForm52.JsEditInteiro2KeyPress(Sender: TObject; var Key: Char);
begin
  if key = #13 then JsEditInteiro4.SetFocus;
end;

procedure TForm52.JsEditInteiro4KeyPress(Sender: TObject; var Key: Char);
begin
  if key = #13 then JsEditInteiro3.SetFocus;
end;

procedure TForm52.JsEditInteiro3KeyPress(Sender: TObject; var Key: Char);
begin
  if key = #13 then CheckBox1.SetFocus;
end;

procedure TForm52.CheckBox1KeyPress(Sender: TObject; var Key: Char);
begin
  if key = #13 then CheckBox2.SetFocus;
end;

procedure TForm52.CheckBox2KeyPress(Sender: TObject; var Key: Char);
begin
  if key = #13 then JsBotao1.SetFocus;
end;

procedure TForm52.JsBotao1KeyPress(Sender: TObject; var Key: Char);
begin
  if key = #27 then
    begin
      key := #0;
      close;
    end;
end;

procedure TForm52.ComboBox2Exit(Sender: TObject);
var
  imp : String;
begin
  if TComboBox(sender).ItemIndex = 4 then
    begin
      imp := funcoes.buscaConfigNaPastaDoControlW('impress_rede', '\\127.0.0.1\generica');
      if messageDlg('As Impressões serão enviadas para: ' + #13 + imp + #13 + 'Deseja Trocar este Compartilhamento?', mtConfirmation, [mbyes, mbNo], 0) = mrYes then
        begin
          imp := funcoes.dialogo('normal',0,'',0,false,'',application.Title,'Qual o Compartilhamento da Impressora?', imp);
          if imp = '*' then exit;

          funcoes.GravaConfigNaPastaDoControlW('impress_rede', imp);
        end;
    end;
end;

procedure TForm52.FormCreate(Sender: TObject);
Var
  I : TACBrETQModelo ;
  A: TACBrCargaBalModelo;
begin
 modelo.Clear;
 For I := Low(TACBrETQModelo) to High(TACBrETQModelo) do
     modelo.Items.Add( GetEnumName(TypeInfo(TACBrETQModelo), integer(I) ) ) ;

 cbxModelo.Items.Clear ;
  for A := Low(TACBrCargaBalModelo) to High(TACBrCargaBalModelo) do
    cbxModelo.Items.Add( GetEnumName(TypeInfo(TACBrCargaBalModelo), integer(A) ) ) ;

  cbxModelo.ItemIndex := 0;
end;

end.
