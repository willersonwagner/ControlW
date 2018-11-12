unit cadcliente;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, JsBotao1, ToolWin, ComCtrls, JsEdit1,
  JsEditInteiro1, ExtCtrls, Mask, JsEditData1, JsEditNumero1, JsEditCNPJ1,
  ActnList, U_Carregando, StrUtils, DB;

type
  TForm16 = class(TForm)
    painel: TPanel;
    Label2: TLabel;
    Label1: TLabel;
    ToolBar1: TPanel;
    JsBotao1: JsBotao;
    JsBotao2: JsBotao;
    info: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    Label20: TLabel;
    Label22: TLabel;
    Label23: TLabel;
    Label24: TLabel;
    Label25: TLabel;
    Label26: TLabel;
    Label27: TLabel;
    Label28: TLabel;
    Label29: TLabel;
    Label30: TLabel;
    Label31: TLabel;
    Label32: TLabel;
    Label33: TLabel;
    Label34: TLabel;
    Label35: TLabel;
    Label36: TLabel;
    Label37: TLabel;
    cod: JsEditInteiro;
    nome: JsEdit;
    tipo: JsEditInteiro;
    ativo: JsEdit;
    Panel1: TPanel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Panel2: TPanel;
    Label10: TLabel;
    Label12: TLabel;
    Label14: TLabel;
    Label13: TLabel;
    Label11: TLabel;
    obs: JsEdit;
    titular: JsEdit;
    nat: JsEdit;
    nac: JsEdit;
    estcv: JsEditInteiro;
    conj: JsEdit;
    Label38: TLabel;
    Label39: TLabel;
    Label40: TLabel;
    tel: JsEdit;
    data: JsEditData;
    prof: JsEdit;
    ocup: JsEdit;
    sal: JsEditNumero;
    faturar: JsEdit;
    prazo: JsEditInteiro;
    lim_compra: JsEditNumero;
    lim_atraso: JsEditNumero;
    pai: JsEdit;
    mae: JsEdit;
    nome1: JsEdit;
    end1: JsEdit;
    tel1: JsEdit;
    nome2: JsEdit;
    end2: JsEdit;
    tel2: JsEdit;
    Label41: TLabel;
    Label42: TLabel;
    ulticod: TLabel;
    Label43: TLabel;
    cnpj: JsEditCNPJ;
    rota: JsEditInteiro;
    ies: JsEdit;
    org: JsEdit;
    telres: JsEdit;
    telcom: JsEdit;
    cod_mun: JsEdit;
    email: JsEdit;
    Label44: TLabel;
    ende: JsEdit;
    bairro: JsEdit;
    cep: JsEdit;
    est: JsEdit;
    cid: JsEdit;
    procedure FormShow(Sender: TObject);
    procedure JsBotao1Click(Sender: TObject);
    procedure JsBotao2Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure codKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure codKeyPress(Sender: TObject; var Key: Char);
    procedure codEnter(Sender: TObject);
    procedure estKeyPress(Sender: TObject; var Key: Char);
    procedure cidKeyPress(Sender: TObject; var Key: Char);
    procedure tipoKeyPress(Sender: TObject; var Key: Char);
    procedure ativoKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ativoKeyPress(Sender: TObject; var Key: Char);
    procedure rotaKeyPress(Sender: TObject; var Key: Char);
    procedure estcvKeyPress(Sender: TObject; var Key: Char);
    procedure cnpjKeyPress(Sender: TObject; var Key: Char);
    procedure nomeEnter(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure cidChange(Sender: TObject);
  private
    codEstado : string;
    componente_a_retornar : JsEdit;
    valor_a_retornar : string;
    procedure verificaCadastroExiste();
    procedure defaultCampos();
    procedure setMask();
    FUNCTION VERIFICA_CONTAS_PENDENTES_TRUE_TEM(): currency;
    function validaDados() : boolean;
    procedure abreDataSet(codestado1 : String);
    { Private declarations }
  public
    procedure setComponente_a_Retornar(componente : jsedit);
    procedure buscaCep(cep1 : String);
    { Public declarations }
  end;

var
  Form16: TForm16;

implementation

uses Unit1, localizar, cadproduto, func, Math, caixaLista, principal,
  vendas, Unit67;

{$R *.dfm}
procedure TForm16.setMask();
begin
 defaultCampos;
 if tipo.Text = '1' then
  begin
    self.Caption := 'Cadastro de Pessoa Fisica';
    Label5.Caption := 'CPF:';
    label7.Caption := 'Cart. Id.:';
    Label43.Visible := true;
    org.Enabled := true;
    org.Visible := true;
    cnpj.EditMask := '!999.999.999-99;1;_';
  end
 else if tipo.Text = '6' then
  begin
    self.Caption := 'Cadastro de Produtor Rural';
    Label5.Caption := 'CPF:';
    Label43.Visible := true;
    org.Enabled := true;
    org.Visible := true;
    label7.Caption := 'Insc. Estadual:';
    org.Enabled := false;
    org.Visible := false;
    Label43.Visible := false;
        //cnpj.Text := '___.___.___-__';
    cnpj.EditMask := '!999.999.999-99;1;_';
  end
 else if tipo.Text = '7' then begin
   label5.Visible := false;
   label6.Visible := false;

   Label7.Caption  := 'ID. Estrangeiro:';
   label11.Caption := 'País:';
   self.Caption := 'Cadastro de Estrangeiro';

   label14.Visible := false;
   est.Enabled := false;
   est.Visible := false;

   cnpj.Visible := false;
   rota.Visible := false;
   org.Enabled := false;
   org.Visible := false;

   rota.Enabled := false;
   rota.Visible := false;

   cnpj.Enabled := false;
   cnpj.Visible := false;
 end
 else
  begin
    self.Caption := 'Cadastro de Pessoa Jurídica';
    Label5.Caption := 'CNPJ:';
    label7.Caption := 'Insc. Estadual:';
    org.Enabled := false;
    org.Visible := false;
    Label43.Visible := false;
    cnpj.EditMask := '!99.999.999/9999-99;1;_';
  end;

end;

procedure TForm16.FormShow(Sender: TObject);
var
  param92 : string;
begin
  param92 := funcoes.buscaParamGeral(92, 'N');

  if param92 = 'S' then Label22.Caption := 'Trabalho:'
   else if param92 = 'X' then Label22.Caption := 'Suframa:';


   Label6.Caption := ConfParamGerais.Strings[7]+':';
   jsedit.SetTabelaDoBd(self,'cliente',dm.IBQuery1);
   ativo.Text := ConfParamGerais.Strings[3];
   if Length(form22.Pgerais.Values['acessousu']) >= 3 then
     begin
       ativo.Enabled := false;
       lim_compra.Enabled := false;
       lim_atraso.Enabled := false;
       ativo.Text         := 'N';
     end
   else
     begin
       ativo.Enabled := true;
       lim_compra.Enabled := true;
       lim_atraso.Enabled := true;
     end;
end;

procedure TForm16.JsBotao1Click(Sender: TObject);
var
  att : boolean;
begin
  if validaDados = false then exit;

  verificaCadastroExiste;
  
  ies.Text := StrNum(ies.Text);
  att := ativo.Enabled;
  ativo.Enabled := true;
  email.Text := LowerCase(email.Text);
  valor_a_retornar := JsEdit.GravaNoBD(self);

  ativo.Enabled := att;
end;

procedure TForm16.JsBotao2Click(Sender: TObject);
var
  val : currency;
begin
   val := VERIFICA_CONTAS_PENDENTES_TRUE_TEM;
   if val > 0 then
     begin
       ShowMessage('Este Usuário nâo pode Ser Excluído' + #13 + 'Contas Não Pagas R$: ' + formataCurrency(val));
       exit;
     end;
   jsedit.ExcluiDoBD(self.Name);
end;

procedure TForm16.FormClose(Sender: TObject; var Action: TCloseAction);
begin
   if componente_a_retornar <> nil then
     begin
        componente_a_retornar.Text := valor_a_retornar;
     end;

   dm.IBQuery2.Close;
   dm.IBQuery1.Close;
   dm.IBselect.Close;
end;

procedure TForm16.FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
var
  key1 : char;
begin
  if key = 120 then begin
    buscaCep(cep.Text);
  end;

  if key = 121 then begin
   try
    form67 := tform67.Create(self);
    if length(strnum(cnpj.Text)) = 11 then form67.cpf.Text  := cnpj.Text;
    if length(strnum(cnpj.Text)) = 14 then form67.cnpj.Text := cnpj.Text;
    form67.ShowModal;
    //ShowMessage(form67.dadosRetorno.GetText);
    if (form67.dadosRetorno[1] <> '') and (form67.dadosRetorno[3] <> '') then begin
      dm.IBselect.Close;
      dm.IBselect.SQL.Text := 'select cod from cliente where cnpj = :cnpj';
      dm.IBselect.ParamByName('cnpj').AsString := form67.dadosRetorno[0];
      dm.IBselect.Open;
      if dm.IBselect.IsEmpty = false then begin
        cod.Text := dm.IBselect.FieldByName('cod').AsString;
        cod.Enabled := true;
        cod.SetFocus;
        jsedit.SelecionaDoBD(self.Name, true);
        exit;
      end;

      nome.SetFocus;

      cod.Enabled  := false;
      if length(strnum(form67.dadosRetorno[0])) = 14 then tipo.Text := '2'
      else tipo.Text := '1';

      key1 := #13;
      tipo.KeyPress(key1);
      cnpj.Text := form67.dadosRetorno[0];
      nome.Text    := UpperCase(form67.dadosRetorno[1]);
      ende.Text    := UpperCase(form67.dadosRetorno[3]);
      bairro.Text  := UpperCase(form67.dadosRetorno[4]);
      cod_mun.Text := UpperCase(form67.dadosRetorno[5]);
      cid.Text     := UpperCase(form67.dadosRetorno[6]);
      est.Text     := UpperCase(form67.dadosRetorno[7]);
      cep.Text     := UpperCase(form67.dadosRetorno[8]);
      telres.Text  := UpperCase(form67.dadosRetorno[9]);
      ies.Text     := UpperCase(form67.dadosRetorno[10]);
    end;
   finally
     form67.Free;
   end;

  end;
end;

procedure TForm16.codKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin

  if (Key = 116) then
    begin

      tedit(sender).Text := funcoes.localizar('Localizar Cliente','cliente','cod,nome,telres,telcom,cnpj as cpfcnpj,bairro','cod','','nome','nome',false,false,false,'',450,NIL);
      key := 0;
    end;
end;

procedure TForm16.codKeyPress(Sender: TObject; var Key: Char);
begin
  if key=#27 then
    begin
      key := #0;
      close;
    end;

  if (key = #13) and (tedit(sender).Text = '') then ativo.Text := ConfParamGerais.Strings[3];

  if (key = #13) then
    begin
      valor_a_retornar := tedit(sender).Text;
    end;
end;

procedure TForm16.codEnter(Sender: TObject);
begin
  ulticod.Caption := IntToStr(JsEdit.UltimoCodigoDaTabela(self.Name));
end;

procedure TForm16.estKeyPress(Sender: TObject; var Key: Char);
var nome : string;
begin
if (key = #13) and  (tedit(sender).Text <> '') then
  begin
    dm.IBselect.Close;
    dm.IBselect.SQL.Clear;
    dm.IBselect.SQL.Add('select * from estados where nome = :nome');
    dm.IBselect.ParamByName('nome').AsString := tedit(sender).Text;
    dm.IBselect.Open;

    if dm.IBselect.IsEmpty then
      begin
        dm.IBselect.Close;
        ShowMessage('Estado Não Encontrado.');
        exit;
      end;
    codEstado := dm.IBselect.fieldByName('cod').AsString;
    abreDataSet(codEstado);
  end;

if (key=#13) and (tedit(sender).Text='') then
  begin
   nome := funcoes.localizar('Localizar Estado','Estados','cod,nome','cod,nome','cod','nome','nome',false,false,false,'',300,NIL);
   tedit(sender).Text := copy(nome,pos('-',nome)+1,length(nome));
   codEstado := copy(nome,1,pos('-',nome)-1);
   abreDataSet(codEstado);
   key := #0;
  end;

end;

procedure TForm16.cidChange(Sender: TObject);
Var
  Aux : Integer;
begin
If cid.Focused Then
  begin
    if Dm.IBcid.Active = false then exit;

    if Dm.IBcid.Locate('Nome',copy(cid.Text,1,cid.SelStart),[loCaseInsensitive,loPartialKey]) then
    begin
      if cid.Text = '' then exit;

      cid.OnChange := nil; // Não ativar o evento agora.
      Aux := cid.SelStart; // Posição do cursor no EditFornecedor
      cid.Text     := Dm.IBcid.FieldByName('Nome').AsString; // Foi o que encontramos pois o codigo só passa por aqui se existe a informação
      cod_mun.Text := Dm.IBcid.FieldByName('cod').AsString;
      cid.SelStart := Aux; // Atualizamos a posição do cursor.
      cid.OnChange := cidChange; // Agora podemos chamar novamente.
    end;
  end;
end;

procedure TForm16.cidKeyPress(Sender: TObject; var Key: Char);
var
  nome : String;
begin
  if (key=#46) then begin
    cid.Text := '';
    exit;
  end;
{if (key=#13) and (tedit(sender).Text <> '') then
  begin
    dm.IBselect.Close;
    dm.IBselect.SQL.Clear;
    dm.IBselect.SQL.Add('select * from municipios_ibge where nome = :nome');
    dm.IBselect.ParamByName('nome').AsString := tedit(sender).Text;
    dm.IBselect.Open;

    if dm.IBselect.IsEmpty then
      begin
        dm.IBselect.Close;
        ShowMessage('Município Não Encontrado.');
        exit;
      end;

    cod_mun.Text := dm.IBselect.fieldByName('cod').AsString;
  end;

}

if (key=#13) and (tedit(sender).Text <> '') then begin
  if (strnum(tipo.Text) = '7') then begin
    key := #0;
    JsBotao1.SetFocus;
    exit;
  end;
end;

if (key=#13) and (tedit(sender).Text = '') then
  begin
    if (strnum(tipo.Text) = '7') then begin
      nome := funcoes.VE_PAIS;
      cod_mun.Text := nome;

      dm.IBselect.Close;
      dm.IBselect.SQL.Text := 'select nome from paises where cod = '  + strnum(nome);
      dm.IBselect.Open;

      if dm.IBselect.IsEmpty then begin
        dm.IBselect.Close;
        ShowMessage('País Desconhecido, Preencha Corretamente!');
        key := #0;
        exit;
      end;
      cid.Text := dm.IBselect.FieldByName('nome').AsString;
      dm.IBselect.Close;

      key := #0;
      JsBotao1.SetFocus;
      exit;
    end;

    cid.OnChange := nil;
    nome := funcoes.localizar('Localizar Municipio','municipios_ibge','cod,nome','cod,nome','','nome','nome',false,false,false,' where cod like('+QuotedStr(codEstado+'%')+')',300,NIL);
    tedit(sender).Text := copy(nome,pos('-',nome)+1,length(nome));
    cod_mun.Text := copy(nome,1,pos('-',nome)-1);
    cid.OnChange := cidChange;


    {dm.IBselect.Close;
    dm.IBselect.SQL.Clear;
    dm.IBselect.SQL.Add('select * from municipios_ibge where nome = :nome');
    dm.IBselect.ParamByName('nome').AsString := tedit(sender).Text;
    dm.IBselect.Open;

    cod_mun.Text := dm.IBselect.fieldByName('cod').AsString;}

    key := #0;
  end;

end;

procedure TForm16.tipoKeyPress(Sender: TObject; var Key: Char);
begin
if (key=#13) and ((tedit(sender).Text='0') or (tedit(sender).Text='')) then
 begin
   form39 := tform39.Create(self);
   form39.ListBox1.Items.Add('1 - PESSOA FÍSICA');
   form39.ListBox1.Items.Add('2 - PESSOA JURÍDICA');
   form39.ListBox1.Items.Add('3 - GOVERNO MUNICIPAL');
   form39.ListBox1.Items.Add('4 - GOVERNO ESTADUAL');
   form39.ListBox1.Items.Add('5 - GOVERNO FEDERAL');
   form39.ListBox1.Items.Add('6 - PRODUTOR RURAL');
   form39.ListBox1.Items.Add('7 - ESTRANGEIRO');
   tedit(sender).Text := funcoes.lista(Sender, false);
   if tedit(sender).Text = '*' then
     begin
       tedit(sender).Text := '0';
       key := #0;
     end;
  //tedit(sender).Text := funcoes.localizar('Tipo de Cliente','tipocli','cod,nome','cod','cod','nome','cod',false,false,false,'',300,sender);
 end;

 setMask();

end;

procedure TForm16.ativoKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
//if key='S' then key := 0;
end;

procedure TForm16.ativoKeyPress(Sender: TObject; var Key: Char);
begin
if (key = #13) and (tedit(sender).Text='') then
 begin
   form39 := tform39.Create(self);
   form39.ListBox1.Items.Add('S - PERMITIR VENDA A PRAZO');
   form39.ListBox1.Items.Add('N - SOMENTE À VISTA');
   form39.ListBox1.Width := 169;
   form39.Width := form39.ListBox1.Width + 15;
   tedit(sender).Text := funcoes.lista(Sender, false);
 end;

if not(funcoes.Contido(UpCase(key), 'SN'+#8+#13+#27))  then key := #0;
if (key = #13) and (tedit(sender).Text = '') then key := #0;
//if tedit(sender).Text='' then if not(((key = char('S')) or (key = char('N'))) ) then key:=#0

end;

procedure TForm16.rotaKeyPress(Sender: TObject; var Key: Char);
begin
if (key=#13) and (tedit(sender).Text='') then
  begin
    if ConfParamGerais[31] = 'S' then
      begin
        tedit(sender).Text := funcoes.localizar('Localizar '+ConfParamGerais.Strings[7],'rota','cod,nome','cod','','nome','nome',false,false,false,'',370,NIL);
      end;
  end;
end;

procedure TForm16.estcvKeyPress(Sender: TObject; var Key: Char);
begin
if (key = #13) and ((tedit(sender).Text='') or (tedit(sender).Text='0')) then
 begin
   form39 := tform39.Create(self);
   form39.ListBox1.Items.Add('1 - SOLTEIRO');
   form39.ListBox1.Items.Add('2 - CASADO');
   form39.ListBox1.Items.Add('3 - DIVORCIADO');
   form39.ListBox1.Items.Add('4 - VIÚVO');
   tedit(sender).Text := funcoes.lista(Sender, false);
 end;
if tedit(sender).Text = '*' then
 begin
  tedit(sender).Text := '';
  key := #0;
 end;

end;

procedure TForm16.setComponente_a_Retornar(componente : jsedit);
begin
  componente_a_retornar := componente;
end;

procedure TForm16.cnpjKeyPress(Sender: TObject; var Key: Char);
var
  tmp, cc : String;
  validado : boolean;
begin

  if key = #13 then
    begin
      {
      form39.ListBox1.Items.Add('1 - PESSOA FÍSICA');
   form39.ListBox1.Items.Add('2 - PESSOA JURÍDICA');
   form39.ListBox1.Items.Add('3 - GOVERNO MUNICIPAL');
   form39.ListBox1.Items.Add('4 - GOVERNO ESTADUAL');
   form39.ListBox1.Items.Add('5 - GOVERNO FEDERAL');
   form39.ListBox1.Items.Add('6 - PRODUTOR RURAL');
      }
      validado := true;
      tmp := funcoes.StrNum(cnpj.Text);
      //if funcoes.tipo.Text, '1-6') then
      if Contido(tipo.Text, '16') then
        begin
          //validado := true;
          //validado := ValidaCPF(tmp);
          validado := funcoes.testacpf(funcoes.StrNum(cnpj.Text));
          cc := 'CPF';
        end
      //else if length(tmp) = 14 then
      else
        begin
          validado := ValidaCNPJ(tmp);
          cc := 'CNPJ'
        end;

      if not validado then
        begin
          MessageDlg(cc + ' Inválido', mtError, [mbok], 1);
          key := #0;
          abort;
          exit;
        end;



      if rota.Visible then rota.SetFocus
      else ies.SetFocus;

      verificaCadastroExiste;

      key := #0;
    end;
end;

procedure TForm16.nomeEnter(Sender: TObject);
begin
  setMask();

  dm.IBselect.Close;
  dm.IBselect.SQL.Clear;
  dm.IBselect.SQL.Add('select cnpj from cliente where cod = :cod');
  dm.IBselect.ParamByName('cod').AsString := cod.Text;
  dm.IBselect.Open;
  cnpj.Text := dm.IBselect.fieldbyname('cnpj').AsString;

  dm.IBselect.Close;
end;

FUNCTION TForm16.VERIFICA_CONTAS_PENDENTES_TRUE_TEM(): currency;
begin
  Result := 0;
  dm.IBselect.Close;
  dm.IBselect.SQL.Text := 'select sum(valor) as valor from contasreceber where pago = 0 and documento = :doc';
  dm.IBselect.ParamByName('doc').AsString := StrNum(cod.Text);
  dm.IBselect.Open;

  if Not dm.IBselect.IsEmpty then Result := dm.IBselect.fieldbyname('valor').AsCurrency;
  dm.IBselect.Close;

end;


function TForm16.validaDados() : boolean;
var
  ie1 : String;
begin
  if funcoes.buscaParamGeral(76, 'S') = 'N' then begin
    Result := true;
    exit;
  end;

  Result := false;
  if nome.Text = '' then
     begin
       ShowMessage('Campo NOME Obrigatório');
       nome.SetFocus;
       exit;
     end;

   if (usaSped) then begin
     if StrNum(tipo.Text) = '7' then begin //se for estrangeiro
       if length(StrNum(ies.Text)) < 4 then begin
         ShowMessage('Identidade de Estrangeiro Invalida!');
         exit;
       end;

     if ende.Text = '' then begin
       ShowMessage('Endereço Inválido!');
       ende.SetFocus;
       exit;
     end;

     if bairro.Text = '' then begin
       ShowMessage('Bairro Inválido!');
       bairro.SetFocus;
       exit;
     end;

     Result := true;
     exit;
   end;


     if (length(StrNum(cnpj.Text)) = 14) then begin
       if not ValidaCNPJ(StrNum(cnpj.Text)) then begin
         ShowMessage('CNPJ Inválido!');
         cnpj.SetFocus;
         exit;
       end;


       ie1 := StrNum(ies.Text);
         if Length(ie1) > 5 then begin
           if not funcoes.Inscricao(ies.Text, est.Text) then begin
             ShowMessage('Inscrição Estadual Inválida!');
             ies.SetFocus;
             exit;
           end;
         end;
     end;

     if (length(StrNum(cnpj.Text)) = 11) then begin
       if not testacpf(StrNum(cnpj.Text)) then begin
         ShowMessage('CPF Inválido!');
         cnpj.SetFocus;
         exit;
       end;

       if tipo.Text = '6' then begin
         ie1 := StrNum(ies.Text);
         if Length(ie1) > 5 then begin
           if not funcoes.Inscricao(ies.Text, est.Text) then begin
             ShowMessage('Inscrição Estadual Inválida!');
             ies.SetFocus;
             exit;
           end;
         end;
       end;
     end;

     if cod_mun.Text = '' then begin
       ShowMessage('Código Municipal Inválido, Procure o estado e cidade pelo ControlW ou Preencha o Código do municipio!');
       est.Text := '';
       est.SetFocus;
       exit;
     end;

     if ende.Text = '' then begin
       ShowMessage('Endereço Inválido!');
       ende.SetFocus;
       exit;
     end;

     if length(bairro.Text) < 2 then begin
       ShowMessage('Bairro Inválido!');
       bairro.SetFocus;
       exit;
     end;

     if cep.Text = '' then begin
       ShowMessage('CEP Inválido!');
       cep.SetFocus;
       exit;
     end;
   end;

  Result := true;
end;

procedure TForm16.defaultCampos();
begin
  label11.Caption := 'Cidade:';
  label7.Caption  := 'Insc. Estadual:';

  label14.Visible := true;
  cnpj.Visible := true;
  rota.Visible := true;
  org.Enabled  := true;
  org.Visible  := true;

  est.Enabled  := true;
  est.Visible  := true;

  rota.Enabled := true;
  rota.Visible := true;

  cnpj.Enabled := true;
  cnpj.Visible := true;

  label5.Visible := true;
  label6.Visible := true;
end;

procedure TForm16.buscaCep(cep1 : String);
var
 i : integer;
begin
  if cep1 = '' then begin
    cep1 := funcoes.dialogo('generico',0,'1234567890,.'+#8,100,false,'',Application.Title,'Qual o CEP?','');
  end;

  if (cep1 = '*') or (cep1 = '') then exit;
  try
    //F_Carregando := TF_Carregando.Create(self);
    F_Carregando.Show;

  try
    dm.ACBrCEP1.BuscarPorCEP(StrNum(cep1));
  except
    on e:exception do begin
      MessageDlg('Ocorreu um Erro: ' + #13 + e.Message, mtError, [mbOK], 1);
      exit;
    end;
  end;

  if dm.ACBrCEP1.Enderecos.Count < 1 then
     ShowMessage( 'Nenhum Endereço encontrado' )
  else
   begin
     For I := 0 to dm.ACBrCEP1.Enderecos.Count-1 do
     begin
       cep.Text     := dm.ACBrCEP1.Enderecos[I].CEP;
       ende.Text    := dm.ACBrCEP1.Enderecos[I].Logradouro;
       bairro.Text  := dm.ACBrCEP1.Enderecos[I].Bairro;
       est.Text     := dm.ACBrCEP1.Enderecos[I].UF;
       cod_mun.Text := dm.ACBrCEP1.Enderecos[I].IBGE_Municipio;
       cid.Text     := dm.ACBrCEP1.Enderecos[I].Municipio;
     end;
   end ;

  finally
    F_Carregando.Close;
  end;
end;


procedure TForm16.verificaCadastroExiste();
var
  sim : string;
begin
  if cod.Text <> '0' then exit;
  if tipo.Text = '7' then exit;
  if strnum(cnpj.Text) = '0' then exit;

  dm.IBselect.Close;
  dm.IBselect.SQL.Text := 'select cod, nome from cliente where cnpj = :cnpj';
  dm.IBselect.ParamByName('cnpj').AsString := cnpj.Text;
  dm.IBselect.Open;

  if dm.IBselect.IsEmpty = false then begin
    sim := leftstr(dm.IBselect.FieldByName('cod').AsString + '-' + dm.IBselect.FieldByName('nome').AsString, 30);
    sim := funcoes.dialogo('generico',0,'SN'+#8,0,false,'S','Control For Windows','Cliente '+sim+' Já Existe, Deseja Recuperar o Cadastro Existente ?S/N:','S') ;

    if sim = 'S' then begin
      cod.Text := dm.IBselect.FieldByName('cod').AsString;
      jsedit.SelecionaDoBD(self.Name);
    end;

  end;
end;

procedure TForm16.abreDataSet(codestado1 : String);
begin
  dm.IBcid.Close;
  dm.IBcid.SQL.Text := 'select cod, nome from municipios_ibge where cod like('+QuotedStr(codEstado1+'%')+')';
  try
   dm.IBcid.Open;
  except
    exit;
  end;
end;

end.






