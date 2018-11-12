unit CadServ;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Mask, JsEditData1, StdCtrls, JsEdit1, JsEditInteiro1, Buttons,
  JsBotao1, ExtCtrls, classes1, JsEditNumero1;

type
  TForm51 = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    cod: JsEditInteiro;
    cliente: JsEditInteiro;
    nome: JsEdit;
    data: JsEditData;
    usuario: JsEditInteiro;
    h_ent: JsEdit;
    pago: JsEditNumero;
    equip: JsEdit;
    marca: JsEdit;
    modelo: JsEdit;
    serie: JsEdit;
    tecnico: JsEdit;
    defeito: JsEdit;
    obs: JsEdit;
    ToolBar1: TPanel;
    Label33: TLabel;
    ulticod: TLabel;
    JsBotao1: JsBotao;
    JsBotao2: JsBotao;
    vendedor: JsEditInteiro;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure codKeyPress(Sender: TObject; var Key: Char);
    procedure FormShow(Sender: TObject);
    procedure JsBotao1Click(Sender: TObject);
    procedure clienteKeyPress(Sender: TObject; var Key: Char);
    procedure codEnter(Sender: TObject);
    procedure clienteEnter(Sender: TObject);
    procedure codKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure obsKeyPress(Sender: TObject; var Key: Char);
  private
    ret, cap, codigo : String;
    function geraCap : String;
    procedure lerFormulario_e_CriaUmObjetoTordem();
    procedure trocaLabeldosComponentes();
    { Private declarations }
  public
    ordem : TOrdem;
    { Public declarations }
  end;

var
  Form51: TForm51;

implementation

uses Unit1, func, principal, impriNovo, consultaOrdem, cadcliente;

{$R *.dfm}
procedure TForm51.trocaLabeldosComponentes();
begin
  label5.Caption  := form22.nomesServico.Values['1'] + ':';
  label6.Caption  := form22.nomesServico.Values['2'] + ':';
  label7.Caption  := form22.nomesServico.Values['3'] + ':';
  label8.Caption  := form22.nomesServico.Values['4'] + ':';
  label9.Caption  := form22.nomesServico.Values['5'] + ':';
  label10.Caption := form22.nomesServico.Values['6'] + ':';
end;


procedure TForm51.lerFormulario_e_CriaUmObjetoTordem();
begin
  ordem := TOrdem.Create;
  ordem.cliente := StrToIntDef(cliente.text, 0);
  ordem.data    := StrToDate(data.Text);
  ordem.equipe  := trim(equip.Text);
  ordem.marca   := trim(marca.Text);
  ordem.modelo  := trim(modelo.Text);
  ordem.defeito := trim(defeito.Text);
  ordem.obs     := trim(obs.Text);
  ordem.serie   := trim(serie.Text);
  ordem.tecnico := trim(tecnico.Text);
  ordem.usuario := StrToInt(usuario.text);
  ordem._ent    := H_ent.Text;
  ordem.pago    := pago.getValor;
  ordem.venda   := 0;
end;

procedure TForm51.obsKeyPress(Sender: TObject; var Key: Char);
begin
  if key = #13 then
    begin
      JsBotao1.SetFocus;
    end;
end;

function TForm51.geraCap : String;
begin
  Result := 'Cód. O.S.: ' + ret +  #13 + Label5.Caption + ' ' + equip.Text + #13 +
  ' ' ;
end;


procedure TForm51.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  JsEdit.LiberaMemoria(self);
end;

procedure TForm51.codKeyPress(Sender: TObject; var Key: Char);
begin
  if key = #27 then close;
  if key = #13 then
    begin
      data.Text := FormatDateTime('dd/mm/yyyy', form22.datamov);
    end;
end;

procedure TForm51.FormShow(Sender: TObject);
begin
  usuario.Text := form22.codusario;
  jsedit.SetTabelaDoBd(self, 'servico', dm.ibquery1);
  data.Text := FormatDateTime('dd/mm/yyyy', form22.datamov);
  ret := ''; cap := '';

  trocaLabeldosComponentes();
end;

procedure TForm51.JsBotao1Click(Sender: TObject);
var
  sim, vende : string;
begin
  H_ent.Text := funcoes.dialogo('mask',100,'!00:00;1;_',100,false,'','Control For Windows','Confirme a Hora de Entrada',FormatDateTime('hh:mm', now));
  if H_ent.Text = '*' then exit;
  h_ent.Text := h_ent.Text + ':00';

  sim := funcoes.dialogo('generico',0,'SN',0,true,'S','Control For Windows','Confirma Ordem de Serviço','') ;
  if (sim = '*') then exit;

  if (sim = 'N') then
    begin
      jsedit.LimpaCampos(self.Name);
      exit;
    end;

  if strnum(vendedor.Text) = '0' then vendedor.Text := strnum(form22.Pgerais.Values['codvendedor']);

  pago.Text := funcoes.dialogo('numero',0,'',2,true,'S',Application.Title,'Confirme o Valor do Pagamento Antecipado:','0,00');
  if pago.Text = '*' then exit;

  sim := funcoes.dialogo('generico',0,'SN',0,true,'S','Control For Windows','Confirma Impressão da Ordem de Serviço','S') ;
  if (sim = '*') then exit;

  if trim(usuario.Text)  = '' then usuario.text  := form22.codusario;
  if trim(vendedor.Text) = '' then vendedor.text := form22.Pgerais.Values['codvendedor'];

  lerFormulario_e_CriaUmObjetoTordem();
  nome.Enabled := false;
  ret    := jsedit.GravaNoBD(self);
  nome.Enabled := true;
  ordem.cod := StrToInt(ret);

  if sim = 'S' then funcoes.imprimeOrdemDeServico(ordem, false);
  codigo := ret;
end;

procedure TForm51.clienteKeyPress(Sender: TObject; var Key: Char);
begin
  if key = #13 then
    begin
      if tedit(sender).Text = '' then
        begin
          form16 := tform16.Create(self);
          form16.setComponente_a_Retornar(cliente);
          funcoes.CtrlResize(tform(form16));
          form16.ShowModal;
          JsEdit.LiberaMemoria(form16);
          form16.Free;
          key := #0;

          {tedit(sender).Text := funcoes.localizar('Localizar Cliente','cliente','cod,nome,telres,telcom,cnpj as cpfcnpj,bairro','cod','','nome','nome',false,false,false,'',450, nil);
          if tedit(sender).Text = '' then key := #0
            else nome.Text := funcoes.BuscaNomeBD(dm.ibselect, 'nome', 'cliente', 'where cod = ' + cliente.Text);}
          exit;
        end;

      if tedit(sender).Text <> '' then
        begin
          nome.Text := funcoes.BuscaNomeBD(dm.ibselect, 'nome', 'cliente', 'where cod = ' + cliente.Text);
        end;
    end;
end;

procedure TForm51.codEnter(Sender: TObject);
begin
  ulticod.Caption := IntToStr(JsEdit.UltimoCodigoDaTabela(self.Name));
end;

procedure TForm51.clienteEnter(Sender: TObject);
begin
  if cod.Text <> '0' then
    begin
      ret := cod.Text;
      cap := geraCap;
    end;
end;

procedure TForm51.codKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key = 116 then //F5
    begin
      tedit(sender).Text := funcoes.localizar('Localizar Ordem de Serviço','servico s','cod as ordem, (select c.nome from cliente c where s.cliente = c.cod) as nome, equip, marca, modelo, tecnico, defeito, situacao','ordem','','ordem','ordem',false,false,false,'',600, nil);
    end;

  if key = 117 then //F6
    begin
      Form55 := TForm55.Create(self);
      form55.consulta := true;
      form55.ShowModal;
      if form55.retorno = '' then
        begin
          form55.Free;
          exit;
        end;

      cod.Text := Form55.retorno;
      jsedit.SelecionaDoBD(self.Name, false);
      cod.Text := '0';
      data.Text := FormatDateTime('dd/mm/yyyy', form22.datamov);
      cliente.SetFocus;

      form55.Free;
      //tedit(sender).Text := funcoes.localizar('Localizar Equipamento','servico s','cod as ordem, (select c.nome from cliente c where s.cliente = c.cod) as nome, equip, marca, modelo, ','ordem','','ordem','ordem',false,false,false,'',600, nil);
    end;
end;

end.
