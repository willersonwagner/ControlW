unit MenuFiscal;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, func, untnfceForm, funcoesdav;

type
  TForm9 = class(TForm)
    Button2: TButton;
    Button1: TButton;
    Button3: TButton;
    Button4: TButton;
    sangria: TButton;
    suprimento: TButton;
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure sangriaClick(Sender: TObject);
    procedure suprimentoClick(Sender: TObject);
  private
    { Private declarations }
  public
    function geraReducao() : smallint;
    { Public declarations }
  end;

var
  Form9: TForm9;

implementation

uses untmain, untDtmMain, login, Math, untVendaPDV, sangria;

{$R *.dfm}

function TForm9.geraReducao() : smallint;
var
  ini, fim : integer;
  erro : boolean;
  sim  : Smallint;
  sim1 : string;
begin
   sim1 := dialogo('generico',0,'SN',0,true,'S','Control for Windows:','Deseja Emitir a Redução Z, O ECF pode fechar o movimento diário!','N');
   if ((sim1 = '*') or (sim1 = 'N')) then exit;
 // sim := MessageBox(Handle,'Deseja Emitir a Redução Z do dia? Esta Rotina Pode Bloquear o ECF.', 'AUTOCOM ECF', MB_YESNO + MB_ICONQUESTION + MB_DEFBUTTON2);
 // if sim = idno then exit;

  mostraMensagem('Aguarde, Emitindo Redução Z...', true);
  
 { if not dtmMain.ACBrECF1.Device.Ativo then dtmMain.ACBrECF1.Ativar;
  erro := false;

  try
    try
      Application.ProcessMessages;
      dtmMain.ACBrECF1.DadosReducaoZ;
      dtmMain.ACBrECF1.ReducaoZ(now);
      erro := true;
    except
      on e:exception do
        begin
          MessageDlg('Erro: ' + e.Message, mtError, [mbOK], 1);
        end;
    end;
  finally
  end;

  if erro = false then exit;

  dtmMain.IBQuery1.Close;
  dtmMain.IBQuery1.SQL.Text := 'update or insert into SPED_REDUCAOZ(cod, data, ecf, CONT_REINICIO, CONT_REDUCAOZ, CONT_OP, TOT_GERAL, TOT_CANC, TOT_ALIQ01, TOT_ALIQ02, TOT_ALIQ03, TOT_ALIQ04, ' +
  'TOT_ALIQ05, TOT_ALIQ06, TOT_ALIQ07, TOT_ALIQ08, TOT_DESC, TOT_FF, TOT_II, TOT_NN, VENDABRUTA) values('+Incrementa_Generator('SPED_REDUCAOZ', 1)+', :data, :ecf, :CONT_REINICIO, :CONT_REDUCAOZ, :CONT_OP, :TOT_GERAL, :TOT_CANC, :TOT_ALIQ01, :TOT_ALIQ02, :TOT_ALIQ03, :TOT_ALIQ04, ' +
  ':TOT_ALIQ05, :TOT_ALIQ06, :TOT_ALIQ07, :TOT_ALIQ08, :TOT_DESC, :TOT_FF, :TOT_II, :TOT_NN, :VENDABRUTA)';

  dtmMain.IBQuery1.ParamByName('data').AsDate   := now;
  with dtmMain.ACBrECF1.DadosReducaoZClass do
    begin
      dtmMain.IBQuery1.ParamByName('ecf').AsString             := dtmMain.ACBrECF1.NumECF;
      dtmMain.IBQuery1.ParamByName('CONT_REINICIO').AsInteger  := CRO;
      dtmMain.IBQuery1.ParamByName('CONT_REDUCAOZ').AsInteger  := CRZ + 1;
      dtmMain.IBQuery1.ParamByName('CONT_OP').AsInteger        := COO + 1;
      dtmMain.IBQuery1.ParamByName('TOT_GERAL').AsCurrency     := ValorGrandeTotal;
      dtmMain.IBQuery1.ParamByName('TOT_CANC').AsCurrency      := CancelamentoICMS;

      ini := 0;
      fim := ICMS.Count -1;
      while true do
        begin
          if ini <= fim then  dtmMain.IBQuery1.ParamByName('TOT_ALIQ0' + IntToStr(ini + 1)).AsCurrency      := ICMS[ini].Total
            else dtmMain.IBQuery1.ParamByName('TOT_ALIQ0' + IntToStr(ini + 1)).AsCurrency  := 0;

          if ini = fim then break;  
          if ini = 7 then break;
          ini := ini + 1;
        end;

      dtmMain.IBQuery1.ParamByName('TOT_DESC').AsCurrency      := DescontoICMS;
      dtmMain.IBQuery1.ParamByName('TOT_FF').AsCurrency        := SubstituicaoTributariaICMS;
      dtmMain.IBQuery1.ParamByName('TOT_II').AsCurrency        := IsentoICMS;
      dtmMain.IBQuery1.ParamByName('TOT_NN').AsCurrency        := NaoTributadoICMS;
      dtmMain.IBQuery1.ParamByName('VENDABRUTA').AsCurrency    := ValorVendaBruta;
   end;

  dtmMain.IBQuery1.ExecSQL;
  dtmMain.IBQuery1.Transaction.Commit;}
  
  mostraMensagem('Aguarde, Emitindo Redução Z...', false);
  ShowMessage('Redução Z Executada com Sucesso');
end;

procedure TForm9.sangriaClick(Sender: TObject);
begin
  form13 := TForm13.Create(self);
  form13.tipo := '1';
  form13.Caption := 'Sangrias PDV';
  form13.ShowModal;
  form13.Free;
end;

procedure TForm9.suprimentoClick(Sender: TObject);
begin
  form13 := TForm13.Create(self);
  form13.tipo := '2';
  form13.Caption := 'Suprimentos PDV';
  form13.ShowModal;
  form13.Free;
end;

procedure TForm9.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if key = #27 then
    begin
      close;
    end;

  if key = '1' then
    begin
      Button2Click(sender);
      exit;
    end;

  if key = '2' then
    begin
      Button1Click(sender);
      exit;
    end;

  if key = '3' then
    begin
      Button3Click(sender);
      exit;
    end;

  if key = '0' then
    begin
      Button4Click(sender);
      exit;
    end;
end;

procedure TForm9.Button2Click(Sender: TObject);
begin
  frmMain.geraRelFechamento();
  close;
end;

procedure TForm9.Button1Click(Sender: TObject);
begin
  frmMain.geraRelFechamento(2);
  close;
end;

procedure TForm9.Button3Click(Sender: TObject);
var
  vend, Justificativa, nota : String;
  canc : integer;
begin
  vend := dialogo('generico',100,'1234567890' + #8,100,false,'','Control for Windows:','Qual o Numero da Nota Fiscal?', '');
  if vend = '*' then exit;

  query1.Close;
  query1.SQL.Text := 'select n.nota, n.chave, v.total from nfce n left join venda v on (v.nota = n.nota) where N.NOTA = :nota';
  query1.ParamByName('nota').AsString := strzero(vend, 9);
  query1.Open;

  if query1.IsEmpty then
    begin
      ShowMessage('Nota ' + vend + ' Não Encontrada!');
      query1.Close;
      exit;
    end
  else
    begin
      nota := query1.fieldbyname('nota').AsString;
      MessageDlg('Encontrada: ' + #13 +
                 'Nota:  ' + COPY(query1.fieldbyname('chave').AsString, 26, 9) + #13 +
                 'Venda: ' + query1.fieldbyname('nota').AsString + #13 +
                 'Chave: ' + query1.fieldbyname('chave').AsString + #13 +
                 'Valor: ' + FormatCurr('0.00', query1.fieldbyname('total').AsCurrency)
                 , mtInformation, [mbOK], 1);
    end;

  Justificativa := '';

  while length(trim(Justificativa)) < 15 do
    begin
      Justificativa := dialogo('normal',0,'',150,true,'',Application.Title,'Qual a Justificativa?',Justificativa);
      if Justificativa = '*' then Break;

      if Length(trim(Justificativa)) < 15 then ShowMessage('Justificativa Deve conter mais do que  14 caracteres');
    end;

  if Justificativa = '*' then exit;

  canc := StrToIntDef(StrNum(form1.codUsuario), 1);
  if Cancelamento_NFe1(vend, Justificativa, canc) then
    begin
      canc := StrToIntDef(StrNum(form1.codUsuario), 1);
      if canc = 0 then canc := 1;

      dtmMain.IBQuery1.Close;
      dtmMain.IBQuery1.SQL.Text := 'update venda set cancelado = :canc where nota = :nota' ;
      dtmMain.IBQuery1.ParamByName('canc').AsInteger := canc;
      dtmMain.IBQuery1.ParamByName('nota').AsInteger := StrToIntDef(nota, 0);
      dtmMain.IBQuery1.ExecSQL;
    end;
end;

procedure TForm9.Button4Click(Sender: TObject);
begin
  //frmMain.geraRelFechamento(3);
  frmMain.gerarel;
  close;
end;

procedure TForm9.FormShow(Sender: TObject);
begin
  Button4.SetFocus;
end;

end.
