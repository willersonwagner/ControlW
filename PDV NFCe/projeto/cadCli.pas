unit cadCli;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, JsBotao1, ExtCtrls, Mask, JsEditCPF1, JsEdit1,
  JsEditInteiro1, func, untnfceForm, Vcl.ComCtrls;

type
  TForm12 = class(TForm)
    ToolBar1: TPanel;
    button: JsBotao;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    cnpj: JsEditCPF;
    Label3: TLabel;
    nome: JsEdit;
    Label1: TLabel;
    Label2: TLabel;
    estran_nome: JsEdit;
    Label4: TLabel;
    estran_ide: JsEditInteiro;
    Label5: TLabel;
    procedure bairroKeyPress(Sender: TObject; var Key: Char);
    procedure buttonKeyPress(Sender: TObject; var Key: Char);
    procedure codKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure buttonClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure numeroKeyPress(Sender: TObject; var Key: Char);
    procedure cnpjKeyPress(Sender: TObject; var Key: Char);
    procedure codKeyPress(Sender: TObject; var Key: Char);
    procedure FormCreate(Sender: TObject);
    procedure nomeKeyPress(Sender: TObject; var Key: Char);
    procedure nomeExit(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure PageControl1Change(Sender: TObject);
    procedure paisKeyPress(Sender: TObject; var Key: Char);
    procedure TabSheet1Show(Sender: TObject);
    procedure TabSheet2Show(Sender: TObject);
    procedure estran_nomeKeyPress(Sender: TObject; var Key: Char);
    procedure estran_nomeExit(Sender: TObject);
    procedure estran_ideKeyPress(Sender: TObject; var Key: Char);
  private
    estrangeiro : boolean;
    codpais : String;
    procedure limpa();
    function insereCliente : String;
    procedure buscaCliente(cpf1 : String);
    procedure montaRetorno(limp : boolean = false; estran : boolean = false);
    { Private declarations }
  public
    codCliente : String;
    { Public declarations }
  end;

var
  Form12: TForm12;

implementation

uses untDtmMain;

{$R *.dfm}

procedure TForm12.limpa();
begin
  if PageControl1.ActivePage = TabSheet1 then begin
    nome.Text := '';
    cnpj.Text := '';
    nome.SetFocus;
  end
  else begin
    estran_nome.Text := '';
    estran_ide.Text  := '';
    //pais.Text := '';
    estran_nome.SetFocus;
  end;
end;

procedure TForm12.bairroKeyPress(Sender: TObject; var Key: Char);
begin
  if key = #27 then
    begin
      key := #0;
      limpa;
    end;

  if key = #13 then
    begin
      button.SetFocus;
    end;  
end;

procedure TForm12.buttonKeyPress(Sender: TObject; var Key: Char);
begin
  if key = #27 then begin
    if PageControl1.ActivePage = TabSheet1 then nome.SetFocus
      else estran_nome.SetFocus;
  end;

  key := #0;
end;

function TForm12.insereCliente : String;
begin
  dtmmain.IBQuery1.Close;
  dtmMain.IBQuery1.SQL.Text := 'insert into';
end;

procedure TForm12.paisKeyPress(Sender: TObject; var Key: Char);
begin
  if key = #27 then
    begin
      limpa;
    end;
    {
  if key = #13 then begin
    if pais.Text = '' then begin
      tedit(sender).Text := localizar1('Localizar País','PAISES','cod,nome','cod','','nome','nome',false,false,false,'','',450, nil);

      if StrToInt(StrNum(pais.Text)) > 0 then begin
        query.Close;
        query.SQL.Text := 'select nome from paises where cod = :cod';
        query.ParamByName('cod').AsString := StrNum(pais.Text);
        query.Open;

        if query.IsEmpty = false then begin
          codpais   := StrNum(pais.Text);
          pais.Text := query.FieldByName('nome').AsString;
          query.Close;
        end;
      end
      else begin
        key := #0;
        abort;
        exit;
      end;
    end;

    button.SetFocus;
  end;          }
end;

procedure TForm12.TabSheet1Show(Sender: TObject);
begin
  nome.SetFocus;
end;

procedure TForm12.TabSheet2Show(Sender: TObject);
begin
  estran_nome.SetFocus;
end;

procedure TForm12.codKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = 116) then
    begin

      tedit(sender).Text := localizar1('Localizar Cliente','cliente','cod,nome,telres,telcom,cnpj as cpfcnpj,bairro','cod','','nome','nome',false,false,false,'','',450, nil);
      key := 0;
    end;
end;

procedure TForm12.estran_ideKeyPress(Sender: TObject; var Key: Char);
begin
  if key = #27 then
    begin
      limpa;
    end;

  if key = #13 then begin
    if length(strnum(estran_ide.Text))  < 5 then begin
      MessageDlg('Identidade Inválida!', mtError, [mbOK], 1);
      key := #0;
      exit;
    end;

    button.SetFocus;
  end;
end;

procedure TForm12.estran_nomeExit(Sender: TObject);
begin
  if estran_nome.Text = '' then begin
    estran_nome.Text := 'ESTRANGEIRO';
  end;
end;

procedure TForm12.estran_nomeKeyPress(Sender: TObject; var Key: Char);
begin
  if key = #27 then
    begin
      montaRetorno(true);
      close;
    end;

  if key = #13 then begin
    estran_ide.SetFocus;
  end;
end;

procedure TForm12.buttonClick(Sender: TObject);
begin
  montaRetorno(FALSE, estrangeiro);
  //codCliente := jsedit.GravaNoBD(self);
  close;
end;

procedure TForm12.FormShow(Sender: TObject);
begin
  jsedit.SetTabelaDoBd(self, 'cliente', dtmMain.IBQuery1);
end;

procedure TForm12.numeroKeyPress(Sender: TObject; var Key: Char);
begin
  if key = #13 then button.SetFocus;
end;

procedure TForm12.PageControl1Change(Sender: TObject);
begin
  if PageControl1.ActivePage = TabSheet1  then begin
    estrangeiro := true;
  end
  else begin
    estrangeiro := false;
  end;
end;

procedure TForm12.cnpjKeyPress(Sender: TObject; var Key: Char);
begin
  if key = #27 then
    begin
      limpa;
    end;

  if key = #13 then
    begin
      if not testacpf(cnpj.Text) then
        begin
          MessageDlg('CPF Inválido!', mtError, [mbOK], 1);
          key := #0;
          abort;
          exit;
        end
      else
        begin
          key := #0;
          buscaCliente(cnpj.Text);
          montaRetorno();
          button.SetFocus;
        end;
    end;
end;

procedure TForm12.codKeyPress(Sender: TObject; var Key: Char);
begin
  if key = #27 then close;
end;

procedure TForm12.FormCreate(Sender: TObject);
begin
  codCliente := '';
  estrangeiro := false;
end;

procedure TForm12.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key = 113 then begin
    if PageControl1.ActivePage = TabSheet1  then begin
      PageControl1.ActivePage := TabSheet2;
      estrangeiro := true;
    end
    else begin
      PageControl1.ActivePage := TabSheet1;
      estrangeiro := false;
    end;
  end;
end;

procedure TForm12.buscaCliente(cpf1 : String);
begin
  dtmMain.IBQuery1.Close;
  dtmMain.IBQuery1.SQL.Text := 'select cod, nome, ende, bairro from cliente where cnpj = :cnpj';
  dtmMain.IBQuery1.ParamByName('cnpj').AsString := cpf1;
  dtmMain.IBQuery1.Open;

  if dtmMain.IBQuery1.IsEmpty then
    begin
      dtmMain.IBQuery1.Close;
      exit;
    end;

  //cod.Text    := dtmMain.IBQuery1.fieldbyname('cod').AsString;
  NOME.Text   := dtmMain.IBQuery1.fieldbyname('nome').AsString;
  //ende.Text   := dtmMain.IBQuery1.fieldbyname('ende').AsString;
  //bairro.Text := dtmMain.IBQuery1.fieldbyname('bairro').AsString;
  dtmMain.IBQuery1.Close;
end;

procedure TForm12.montaRetorno(limp : boolean = false; estran : boolean = false);
begin
  if limp then
    begin
      codCliente := '';
      exit;
    end;

  if estran then begin
    if length(nome.Text) < 2 then nome.Text := 'Estrangeiro';
    codCliente := 'nome=' + estran_nome.Text + #13 +
    'cpf=' + estran_ide.Text + #13 +
    'estx=1' + #13 +
    'codpais=' + strnum(codpais);
    exit;
  end;

  if length(nome.Text) < 2 then nome.Text := 'Venda ao Consumidor';
  codCliente := 'nome=' + nome.Text + #13 +
  'cpf=' + cnpj.Text;
end;

procedure TForm12.nomeKeyPress(Sender: TObject; var Key: Char);
begin
  if key = #27 then
    begin
      montaRetorno(true);
      close;
    end;

  if key = #13 then begin
    cnpj.SetFocus;
    key := #0;
  end;
end;

procedure TForm12.nomeExit(Sender: TObject);
begin
  if length(nome.Text) < 2 then nome.Text := 'Venda ao Consumidor';
end;

end.
