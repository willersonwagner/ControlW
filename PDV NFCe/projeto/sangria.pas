unit sangria;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, JsEditNumero1, Vcl.StdCtrls, JsEdit1,
  JsEditInteiro1, Vcl.Buttons, JsBotao1, Vcl.ExtCtrls, untnfceForm, funcoesdav;

type
  TForm13 = class(TForm)
    valor: JsEditNumero;
    Panel1: TPanel;
    JsBotao1: JsBotao;
    Label1: TLabel;
    procedure FormShow(Sender: TObject);
    procedure JsBotao1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure valorKeyPress(Sender: TObject; var Key: Char);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    DATA_HORA : TDateTime;
    USUARIO   : integer;
    Novo      : boolean;
    procedure GravaSangriaSuprimento();
    function buscaSangria() : boolean;
    procedure RelSangria(cod : string);
    { Private declarations }
  public
    tipo : string;
    { Public declarations }
  end;

var
  Form13: TForm13;

implementation

{$R *.dfm}

uses login, frmStatus;

procedure TForm13.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  jsedit.LiberaMemoria(self);
end;

procedure TForm13.FormCreate(Sender: TObject);
begin
  novo := true;
end;

procedure TForm13.FormShow(Sender: TObject);
begin
  if tipo = '' then tipo := '1';
  if tipo = '1' then Label1.Caption := 'Informe o Valor da Sangria:'
    else label1.Caption := 'Informe o Valor do Suprimento:';
end;

procedure TForm13.GravaSangriaSuprimento();
var
  cod : String;
begin
  {
   tipo
   1 - sangria
   2 - suprimento
  }

  cod := Incrementa_Generator('sangria', 1);

  query1.Close;
  query1.SQL.Text := 'update or insert into sangria(cod, DATA_HORA, VALOR, USUARIO, TIPO)' +
  //' values(gen_id(sangria, 1), :DATA_HORA, :VALOR, :USUARIO, :TIPO)';
  ' values('+cod+', :DATA_HORA, :VALOR, :USUARIO, :TIPO)';

  DATA_HORA := now;
  USUARIO   := StrToIntDef(form1.codUsuario, 0);
  
  query1.ParamByName('DATA_HORA').AsDateTime := DATA_HORA;
  query1.ParamByName('USUARIO').AsInteger    := USUARIO;
  query1.ParamByName('TIPO').AsString        := tipo;

  query1.ParamByName('VALOR').AsCurrency     := valor.getValor;

  query1.ExecSQL;
  query1.Transaction.Commit;

  jsedit.LimpaCampos(self.Name);

  RelSangria(cod);
  close;
end;

procedure TForm13.JsBotao1Click(Sender: TObject);
var
  msg : String;
begin
  if valor.getValor = 0 then begin
    valor.SetFocus;
    MessageDlg('Preencha o Valor!', mtInformation, [mbOK], 1);
    exit;
  end;

  if tipo = '1' then msg := 'Tem Certeza que Deseja Lançar Essa Sangria ?'
    else msg := 'Tem Certeza que Deseja Lançar Esse Suprimento ?';

  if MessageDlg(msg, mtConfirmation, [mbYes, mbNo], 1) = idno then exit;

  GravaSangriaSuprimento;
  abort;
end;

procedure TForm13.valorKeyPress(Sender: TObject; var Key: Char);
begin
  if key = #27 then begin
    close;
  end;

  if key = #13 then begin
    JsBotao1.SetFocus;
  end;
end;

function TForm13.buscaSangria() : boolean;
begin
  Result := false;
 { query1.Close;
  query1.SQL.Text := 'Select * from sangria where cod = :cod';
  query1.ParamByName('cod').AsString := strnum(cod.Text);
  query1.Open;

  if not query1.IsEmpty then begin
    DATA_HORA := query1.FieldByName('DATA_HORA').AsDateTime;
    tipo      := query1.FieldByName('tipo').AsString;
    USUARIO   := query1.FieldByName('USUARIO').AsInteger;
    valor.setValor(query1.FieldByName('valor').AsCurrency);

    if tipo = '1' then self.Caption := 'Sangrias PDV'
      else self.Caption := 'Suprimentos PDV';

    Result := true;
    query1.Close;
    valor.SetFocus;
    novo := false;
    exit;
  end;

  valor.setValor(0);
  MessageDlg('Código ' + cod.Text + ' Não Encontrado!', mtInformation, [mbOK], 1);
  cod.Text := '';
  query1.Close; }
end;

procedure TForm13.RelSangria(cod : string);
VAR
  NOME : sTRING;
begin
  query1.Close;
  query1.SQL.Text := 'select u.nome,s.VALOR,s.tipo, s.USUARIO,s.DATA_HORA from sangria s'+
  ' left join usuario u on (u.cod = s.usuario) where s.cod = :cod';
  query1.ParamByName('cod').AsString := cod;
  query1.Open;

  if query1.IsEmpty then begin
    ShowMessage('Consulta Não Obteve Resultados!');
    query1.Close;
    exit;
  end;

  if query1.FieldByName('tipo').AsString = '1' then NOME := 'SANGRIA'
    ELSE NOME := 'SUPRIMENTO';

  mfd := Tmfd.Create(self);
  mfd.RichEdit1.Clear;
  mfd.RichEdit1.Lines.Add(CompletaOuRepete('','', '-', 38));
  mfd.RichEdit1.Lines.Add(CompletaOuRepete('RELATORIO DE ' + NOME,'', ' ', 38));
  mfd.RichEdit1.Lines.Add(CompletaOuRepete('','', '-', 38));
  mfd.RichEdit1.Lines.Add(CompletaOuRepete('DATA: ' + FormatDateTime('DD/MM/YY', QUERY1.FieldByName('DATA_HORA').AsDateTime) + ' ' +
  FormatDateTime('hh:mm', QUERY1.FieldByName('DATA_HORA').AsDateTime),'', ' ', 38));
  mfd.RichEdit1.Lines.Add(CompletaOuRepete('USUARIO: ' + QUERY1.FieldByName('usuario').AsString + ' ' + QUERY1.FieldByName('nome').AsString,'', ' ', 38));
  mfd.RichEdit1.Lines.Add(CompletaOuRepete('','', '-', 38));
  mfd.RichEdit1.Lines.Add(CompletaOuRepete('VALOR R$: ', FormatCurr('#,###,###0.00', query1.FieldByName('valor').AsCurrency), ' ', 38));
  mfd.RichEdit1.Lines.Add(CompletaOuRepete('','', '-', 38));

  mfd.imprime;
  mfd.Free;
  query1.Close;
end;

end.
