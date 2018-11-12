unit dadosTransp;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, JsEdit1, JsEditNumero1, JsEditInteiro1, ExtCtrls;

type
  TForm43 = class(TForm)
    Panel1: TPanel;
    Label10: TLabel;
    GroupBox1: TGroupBox;
    Label6: TLabel;
    qtd: JsEditInteiro;
    Label5: TLabel;
    especie: JsEdit;
    Label8: TLabel;
    liq: JsEditNumero;
    Label9: TLabel;
    bruto: JsEditNumero;
    GroupBox2: TGroupBox;
    Label7: TLabel;
    marca: JsEdit;
    Label3: TLabel;
    placa: JsEdit;
    estado: JsEdit;
    Label4: TLabel;
    GroupBox3: TGroupBox;
    Label1: TLabel;
    codtransp: JsEditInteiro;
    antt: JsEdit;
    Label2: TLabel;
    tipofrete: TEdit;
    Label11: TLabel;
    Label12: TLabel;
    nVol: JsEdit;
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure codtranspKeyPress(Sender: TObject; var Key: Char);
    procedure codtranspKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure tipofreteKeyPress(Sender: TObject; var Key: Char);
    procedure marcaKeyPress(Sender: TObject; var Key: Char);
    procedure anttKeyPress(Sender: TObject; var Key: Char);
    procedure estadoKeyPress(Sender: TObject; var Key: Char);
    procedure qtdKeyPress(Sender: TObject; var Key: Char);
    procedure especieKeyPress(Sender: TObject; var Key: Char);
    procedure brutoKeyPress(Sender: TObject; var Key: Char);
    procedure liqKeyPress(Sender: TObject; var Key: Char);
    procedure nVolKeyPress(Sender: TObject; var Key: Char);
  private
    lista : TStringList;
    procedure preencheDados();
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form43: TForm43;

implementation

uses func, cadTransp, nfe, Unit1, caixaLista;

{$R *.dfm}

procedure TForm43.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if key = #27 then
    begin
      //nfevenda.frete.val;
      tipofrete.Text := '9';
      close;
    end;
end;

procedure TForm43.liqKeyPress(Sender: TObject; var Key: Char);
begin
  if key = #13 then begin
    marca.SetFocus;
    abort;
    exit;
  end;
end;

procedure TForm43.marcaKeyPress(Sender: TObject; var Key: Char);
begin
  if key = #13 then begin
    nvol.SetFocus;
    abort;
    exit;
  end;
end;

procedure TForm43.nVolKeyPress(Sender: TObject; var Key: Char);
begin
  if key = #13 then preencheDados;
end;

procedure TForm43.anttKeyPress(Sender: TObject; var Key: Char);
begin
  if key = #13 then placa.SetFocus;

end;

procedure TForm43.brutoKeyPress(Sender: TObject; var Key: Char);
begin
  if key = #13 then begin
    liq.SetFocus;
    abort;
    exit;
  end;
end;

procedure TForm43.codtranspKeyPress(Sender: TObject; var Key: Char);
begin
  if (key = #13) and (tedit(sender).Text = '') then
    begin
      form10 := tform10.Create(self);
      form10.ShowModal;
      codtransp.Text := funcoes.retornoLocalizar;
    end;

  if (key = #13) and (tedit(sender).Text = '') then
    begin
      key := #0;
      ShowMessage('Campo Transportadora Obrigatório');
    end;
    
  if (key = #13) and (tedit(sender).Text <> '') then
    begin
      key := #0;
      antt.SetFocus;
      abort;
    end;

end;

procedure TForm43.codtranspKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
if (Key = 116) then
   begin
    tedit(sender).Text := funcoes.localizar('Localizar Transportadora','transportadora','cod,nome,cnpj, est as estado','cod','','nome','nome',true,false,false,'',300,sender);
   end;
end;

procedure TForm43.especieKeyPress(Sender: TObject; var Key: Char);
begin
  if key = #13 then begin
    bruto.SetFocus;
    abort;
    exit;
  end;
end;

procedure TForm43.estadoKeyPress(Sender: TObject; var Key: Char);
begin
  if key = #13 then begin
    qtd.SetFocus;
    abort;
  end;
end;

procedure TForm43.tipofreteKeyPress(Sender: TObject; var Key: Char);
begin
  if (key = #13) then begin
   if tedit(sender).Text = '' then begin
     form39 := tform39.Create(self);
     form39.ListBox1.Items.Add('1 - Emitente');
     form39.ListBox1.Items.Add('2 - Destinatário');
     form39.ListBox1.Items.Add('9 - Sem Frete');
     tedit(sender).Text := funcoes.lista(Sender, false);
     if tedit(sender).Text = '*' then begin
       tedit(sender).Text := '';
       key := #0;
       exit;
     end;
   end;

   if tedit(sender).Text <> '' then begin
     if tedit(sender).Text = '9' then begin
       GroupBox3.Enabled := false;
       placa.SetFocus;
     end
     else begin
       GroupBox3.Enabled := true;
       codtransp.SetFocus;
     end;
   end;
  end;
end;

procedure TForm43.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  jsedit.LiberaMemoria(self);
end;

procedure TForm43.preencheDados();
begin
{if codtransp.Text = '' then
     begin
       ShowMessage('Preencha o Cód. da transportadora.');
       exit;
     end;}

      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add('select * from transportadora where cod= :cod');
      dm.IBQuery1.ParamByName('cod').AsString := strnum(codtransp.Text);
      dm.IBQuery1.Open;

      {if dm.IBQuery1.IsEmpty then
        begin
          dm.IBQuery1.Close;
          ShowMessage('A Transportadora '+ codtransp.Text + ' Não foi Encontrado');
          exit;
        end;}

      //ja adicionou o tipo do frete e criou a lista

      //1
      nfevenda.frete.Values['1'] := (trim(dm.IBQuery1.fieldbyname('nome').AsString));
      nfevenda.frete.Values['2'] := (dm.IBQuery1.fieldbyname('tipo').AsString);
      nfevenda.frete.Values['3'] := (funcoes.StrNum(dm.IBQuery1.fieldbyname('cnpj').AsString));
      nfevenda.frete.Values['4'] := (funcoes.StrNum(dm.IBQuery1.fieldbyname('cpf').AsString));
      nfevenda.frete.Values['5'] := (funcoes.StrNum(dm.IBQuery1.fieldbyname('ies').AsString));
      nfevenda.frete.Values['6'] := (dm.IBQuery1.fieldbyname('endereco').AsString);
      nfevenda.frete.Values['7'] := (dm.IBQuery1.fieldbyname('cid').AsString);
      nfevenda.frete.Values['8'] := (dm.IBQuery1.fieldbyname('est').AsString);
      nfevenda.frete.Values['9'] := (copy(dm.IBQuery1.fieldbyname('fone').AsString,1,12));
      //9


      nfevenda.frete.Values['10'] := (antt.Text);
      nfevenda.frete.Values['11'] := (placa.Text);
      nfevenda.frete.Values['12'] := (estado.Text);
      nfevenda.frete.Values['13'] := (qtd.Text);
      nfevenda.frete.Values['14'] := (especie.Text);
      nfevenda.frete.Values['15'] := (marca.Text);
      nfevenda.frete.Values['16'] := (funcoes.ConverteNumerico(liq.Text));
      nfevenda.frete.Values['17'] := (funcoes.ConverteNumerico(bruto.Text));
      nfevenda.frete.Values['18'] := (nVol.Text);
      //nfevenda.temp.Add(codtransp.Text);
      dm.IBQuery1.Close;
      close;
end;

procedure TForm43.qtdKeyPress(Sender: TObject; var Key: Char);
begin
  if key = #13 then begin
    especie.SetFocus;
    abort;
    exit;
  end;
end;

end.

