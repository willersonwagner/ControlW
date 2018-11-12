unit func;

interface

uses
  StdCtrls, Controls, Forms,Windows, Messages, SysUtils,IBQuery, Variants, Classes, Graphics,
  Dialogs,IniFiles,SHELLAPI, db,dbgrids,ComCtrls,richedit,dbclient, IBDatabase,
  IBCustomDataSet, ExtCtrls;



type
  Tfuncoes = class(TForm)
    a: TIBQuery;
    IBTransaction1: TIBTransaction;
    procedure FormCreate(Sender: TObject);

  private
    procedure Button1Click(Sender: TObject);
    procedure MeuKeyPress1(Sender: TObject; var Key: Char);
    { Private declarations }
  public
   //  queryTemp  : TIBQuery;
     lista1 : string;
     valordg:string;
     formpato:string;
     info:string;
     retornobusca:string;
     retornoLocalizar:string;
     ReParcelamento : tstringList;
     OK : BOOLEAN;
     Simbolos : array [0..4] of String;
     function IniciaNfe : boolean;
     function StrNum(const entra: string) :  string;
     function OrdenarValoresStringList(var valor_a_Ser_Ordenado : TStringList) : TStringList;
     function RetornaValorConfig(Config:string;posi:integer) : variant;
     function GerarPgeraisList(codUsu: string) : TStringList;
     function CompararStringLists(var v1: tstringlist;var v2 : tstringlist) : boolean;
     function GravaTexT(dire:string;conteudo:string) : boolean;
     function GetTheWindowsDirectory : string;
     function GeraNota(numNota:string;tipo:string;EnviarImpressora:string;Venda:boolean) : boolean;
     function lista(var t: TObject) : string;
     function Parcelamento(Total : currency; Cliente : string; prazo : string) : TstringList;
     function LerIni(valor:string):string;
     function PreparaData(Valor: string): TDateTime;
     function ArredondaFinanceiro(Value: Currency; Decimals: integer): Currency;
     function novocod(gen: string) : string;
     function VerSeExisteConfig:boolean;
     function dialogo(tipo:string;maxlengt : integer;ValorEntrada:string;tamanhocampo:integer;obrigatorio1:boolean;trocaletras:string;titulo:string;label1:string;default:string):string;
     function ArredondaTrunca(Value: Extended;decimais:integer): Extended;
     function TiraOuTrocaSubstring(StringDeEntrada:string;ValorTrocar:string;ValorQSeraSubstituido:string):string;
     function LerFormPato(index:integer;param : integer) : string;
     function LerIniToStringList:TStringList;
     function LerValorPGerais(NomeConfig:string;arr:TStringList):string;
     function CompletaOuRepete(const valorParaCompletar:AnsiString;const ValorFinal:AnsiString;valorParaRepetir:string;contadorDeRepeticao:integer):string;
     function RelatorioCabecalho(NomeEmpresa:string;NomeRelatorio:string;tamanho:integer):string;
     procedure informacao(posicao:integer;total:integer;informacao:string;novo:boolean;fechar:boolean;valorprogressao:integer);
     procedure CtrlResize(var Sender: TForm); export;
     function grelatoriocima(SQLGrupo:string;SQLFornec:string;SQLFabric:string;SQLCom2Filtros:string;SQLSemFiltros:string;cabecalho:string;NomeDaEmpresa:string;NomeDoRelatorio:string;colunas:string):boolean;
     procedure ExecFile(F: String);
     function Contido(substring:string;texto:string):boolean;
     function PerguntasRel(var query:tibquery;paramper:string;paramverifica:boolean;valorbd:string;valorstring:string) : boolean;
     function BuscaNomeBD(var query:tibquery;NomeCampo:string;NomeTabela:string;condicao:string) : string;
     procedure OrdenaCamposVenda(campos:string);
     procedure FormataCampos(var query:Tibquery;qtdCasasDecimais:integer;CampoFormatoDiferente:string;qtd:integer);
     Function ConverteNumerico(valor:string):string;
     function ContaChar(estring:string;sub:string):string;
     function PosFinal(substr:string;Texto:string):integer;
     procedure CharSetRichEdit(var rich:TRichEdit);
     procedure ResizeForms();
     function localizar(titulo:string;tabela:string;campos:string;retorno:string;esconde:string;localizarPor:string;OrdenarPor:string;editLocaliza:boolean;editavel:boolean;deletar:boolean;condicao:string;tamanho:integer;compnenteAlinhar: TObject):string;
     function busca(var dataset:tibquery;busca:string;retorno:string;campobusca:string;camposdataset:string):string;
     function procuraMultiplos(entradaDataset:string;valorParaComarar:string):boolean;
     function SomaCampoDBGRID(var dataset:tibquery;campo:string;dataini:TDateTime;datafim:TDateTime;dataIgual:TDateTime;NomeCampoDataParaComparar:string): currency;
     function valorPorExtenso(vlr: real): string;
     function centraliza(valor:string;repetir:string;tamanho:integer):string;
     function GeraAleatorio(valor:integer):string;
     function VerAcesso(param:string) : string;
     function DeletaChar(sub:string;texto:string):string;
     function LerConfig(valor:string;posi:integer) : string;
     function Criptografar(wStri: String): String;
     function DesCriptografar(wStri: String): String;
     function RetornaMaiorData(v1 : TDateTime; v2 : TDateTime) : TDateTime;
     function TimageToFileStream(caminho : string) : TFileStream;
     procedure GeraTemas;
     procedure ImprimeParcelamento(ini,fim,entrada,nota : string);
     function ExisteParcelamento(nota : string) : boolean;
     function QuebraLinhas(ini,fim,entrada:string; qtdQuebra:integer) : string;
     procedure Traca_Nome_Rota;
     procedure GeraCarne(nota,tipo : String);
     procedure Ibquery_to_clienteDataSet(var ibquer : TIBQuery; var cliente: TClientDataSet);
     function RetornaMaiorTstrings(entra:tstrings) :  string;
     procedure VerificaVersao_do_bd;
     FUNCTION Mensagem(Mensagem : string; option : integer) : string;
     FUNCTION MensagemTextoInput(caption : string) : string;
     function Procura_em_Multiplos_Campos(var data_set : TIBQuery;Campo_separados_por_espaco, valorParaComparar : string) : boolean;
  end;

var
  funcoes: Tfuncoes;
  cont:integer;
  function Arredonda(valor : currency; decimais:integer) : currency;
  function WWMessage(flmessage: String; flType: TMsgDlgType; flbutton: TMsgDlgButtons; flColor: TColor; flBold, flItalic: boolean;WWFormColor:TColor): String;
  function GravarConfig(valor:string;AserGravado:string;posi:integer) : string;
  function retornaPos(valor:string;sub:string;posi:integer) : integer;
  function lancaValorMinimo(total:currency;minimo:currency;Msg:string) : currency;
  Procedure FileCopy( Const sourcefilename, targetfilename: String );
  function VerificaRegistro(param : integer) : boolean;
  function HexToTColor(sColor : string) : TColor;
  function Reorganizar : boolean;
  procedure GeraParcelamento(codvenda,formpagto,codcliente,nomecliente,vendedor,codgru : string ;parcelas,periodo : integer;vencimento1 : TDateTime;valorp : Currency);
  procedure addRelatorioForm19(Adicionar : string);
  function JustificarStrings(ent: string;qtd: integer) : string;
  function VerificaAcesso_Se_Nao_tiver_Nenhum_bloqueio_true_senao_false : boolean;
  function RetornaAcessoUsuario : integer;
  function StringToInteger(Ent : String) : integer;
  function ValidaCNPJ(CNPJ: string): Boolean;
  function ValidaCPF(sCPF: string): boolean;
  function iif(lTest:Boolean; vExpr1,vExpr2:Variant):Variant;
  function VerificaCampoTabela(NomeCampo, tabela : string) : boolean;
  procedure Retorna_Array_de_Numero_de_Notas(var mat : TStringList; notas : string);
  FUNCTION STR_ALFA(PAR : string) : string;
  function RetornaValorStringList(var ent : TStringList; estring : string) : string;
  function Incrementa_Generator(Gen_name : string; valor_incremento : integer) : string;


implementation


uses Unit1, Math, dialog, formpagtoformulario, StrUtils,
  mensagem,  relatorio, principal, Unit2, localizar,
  buscaSelecao, Menus, Unit38, caixaLista, imprime1,jpeg;

{$R *.dfm}
function Incrementa_Generator(Gen_name : string; valor_incremento : integer) : string;
begin
  dm.IBQuery1.Close;
  dm.IBQuery1.SQL.Clear;
  dm.IBQuery1.SQL.Add('select gen_id('+ Gen_name +','+ IntToStr(valor_incremento) +') as venda from rdb$database');
  dm.IBQuery1.Open;

  Result := '';
  Result := dm.IBQuery1.fieldbyname('venda').AsString;

  dm.IBQuery1.Close;
end;


procedure Tfuncoes.MeuKeyPress1(Sender: TObject; var Key: Char);
begin
  if Key = #27 then pergunta1.Close;
end;


FUNCTION Tfuncoes.MensagemTextoInput(caption : string) : string;
begin
  pergunta1 := Tpergunta1.Create(Self);
  if caption = '' then pergunta1.Caption := Application.Title
    else pergunta1.Caption := caption;
  pergunta1.option := 2;
  pergunta1.gauge1.Visible := false;
  pergunta1.Label1.Visible := false;
  //pergunta1.Label1.Caption := Mensagem;
  pergunta1.Label1.Font.Color := clRed;
  CtrlResize(tform(pergunta1));

  pergunta1.tipo := 'texto';
  pergunta1.memo1 := TMemo.Create(self);
  pergunta1.memo1.Name := 'memo1';
  pergunta1.memo1.Parent := pergunta1;
  pergunta1.memo1.Align := alClient;
  pergunta1.memo1.Text := '';
  pergunta1.memo1.OnKeyPress := MeuKeyPress1;
  pergunta1.ShowModal;

  Result := '';
  Result := valordg;
end;

function RetornaValorStringList(var ent : TStringList; estring : string) : string;
var i : integer;
begin
   cont := ent.Count - 1;
   Result := '';
   for i := 0 to cont do
     begin
       if funcoes.Contido(estring,ent.Strings[i]) then
         begin
           Result := ent.Strings[i];
           exit;
         end;
     end;
end;

procedure Tfuncoes.Button1Click(Sender: TObject);
begin
  pergunta1.Close;
end;

FUNCTION Tfuncoes.Mensagem(Mensagem : string; option : integer) : string;
var
  botao : TButton;
begin
  pergunta1 := Tpergunta1.Create(Self);
  pergunta1.Gauge1.Position := 0;
  pergunta1.Timer1.Enabled := true;
  pergunta1.Caption := Application.Title;
  pergunta1.option := 2;
  pergunta1.Label1.Caption := Mensagem;
  pergunta1.Label1.Font.Color := clRed;
  CtrlResize(tform(pergunta1));
  pergunta1.Label1.Font.Size := 15;
  pergunta1.Label1.Font.Style := [fsbold];
  pergunta1.Label1.Left := 10;
  if pergunta1.Label1.Width + pergunta1.Label1.Left >= pergunta1.Width then pergunta1.Width := pergunta1.Label1.Width + pergunta1.Label1.Left + 15;

  {botao := TButton.Create(self);
  botao.Name:='Button2';
  //botao.Height := 25;
  //botao.Width := 72;
  botao.Parent := pergunta1;
  botao.Caption := 'Fechar';
  botao.Left := 0;
  botao.Top := (pergunta1.Height - botao.Height) - 30;
  botao.OnClick := Button1Click;
  }pergunta1.Show;
{  botao.Free;
  pergunta1.Free;
}end;

FUNCTION STR_ALFA(PAR : string) : string;
var
  INI, LIN,fim : integer;
  VALIDO : string;
begin
  valido := '",.-/0123456789ABCDEFGHIJKLMNOPQRSTUVXWYZ';
  Result := '';
  fim := length(PAR);
  FOR INI := 1 TO fim do
    begin
      IF FUNCOES.CONTIDO(UpperCase(PAR[ini]), VALIDO) THEN
         Result := Result + PAR[INI]
      ELSE
        Result := Result + ' ';
    end;
end;



procedure Retorna_Array_de_Numero_de_Notas(var mat : TStringList; notas : string);
var ini, fim,posi : integer;
begin
  mat := TStringList.Create;
  fim := length(Trim(notas));
  notas := trim(notas);
  posi := 1;
  for ini := 1 to fim do
    begin
      if notas[ini] = ' ' then
        begin
          mat.Add(copy(notas,posi,ini - posi));
          posi := ini + 1;
        end;
      if (mat.Count <> 0) and (ini = fim) then mat.Add(copy(notas,posi,fim - posi + 1));
    end;
  if mat.Count = 0 then mat.Add(notas);  
end;

function VerificaCampoTabela(NomeCampo, tabela : string) : boolean;
var
  texto : string;
begin
  dm.IBselect.Close;
  dm.IBselect.SQL.Clear;
  dm.IBselect.SQL.Add('select * from '+tabela);
  dm.IBselect.Open;
  texto := dm.IBselect.FieldList.Text;
  if funcoes.Contido(UpperCase(NomeCampo),UpperCase(texto)) then
    begin
      dm.IBselect.Close;
      Result := true;
    end
  else
    begin
      dm.IBselect.Close;
      Result := false;
    end;
end;

procedure Tfuncoes.VerificaVersao_do_bd;
var versao_BD  : string;
alt : boolean;
begin
  alt := false;
  dm.IBselect.Close;
  dm.IBselect.SQL.Clear;
  dm.IBselect.SQL.Add('select versao from registro');
  dm.IBselect.Open;
  versao_BD := dm.IBselect.fieldbyname('versao').AsString;
  dm.IBselect.Close;

  if versao_BD <> VersaoExe then
    begin
      if not VerificaCampoTabela('PIS','COD_OP') then
        begin
          dm.IBQuery1.Close;
          dm.IBQuery1.SQL.Clear;
          dm.IBQuery1.SQL.Add('ALTER TABLE COD_OP ADD PIS CHAR(1) DEFAULT ' + QuotedStr(''));
          dm.IBQuery1.ExecSQL;
          alt := true;
        end;

      if not VerificaCampoTabela('ICMS','COD_OP') then
        begin
          dm.IBQuery1.Close;
          dm.IBQuery1.SQL.Clear;
          dm.IBQuery1.SQL.Add('ALTER TABLE COD_OP ADD ICMS CHAR(1) DEFAULT ' + QuotedStr(''));
          dm.IBQuery1.ExecSQL;
          alt := true;
        end;

      if alt then
        begin
          dm.IBQuery1.Transaction.Commit;
        end;
      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add('update registro set versao = :v');
      dm.IBQuery1.ParamByName('v').AsString := VersaoExe;
      dm.IBQuery1.ExecSQL;
      dm.IBQuery1.Transaction.Commit;
    end;
end;


function ValidaCPF(sCPF: string): boolean;
var
  sDigs, sVal : string;
  iSTot, iSTot2: integer;
  i: integer;
begin
  sCPF := Trim(funcoes.StrNum(sCPF));
  iSTot := 0;
  iSTot2 := 0;
  if Length(sCPF) = 11 then
    begin
      for i := 9 downto 1 do
        begin
          iSTot := iSTot + StrToInt(sCPF[i]) * (11 - i);
          iSTot2 := iSTot2 + StrToInt(sCPF[i]) * (12 - i);
        end;
       iSTot := iSTot mod 11;
       sDigs := sDigs + IntToStr(iif(iSTot < 2, 0, 11 - iSTot));
       iSTot2 := iSTot2 + 2 * StrToInt(sDigs);
       isTot2 := iSTot2 mod 11;
       sDigs := sDigs + IntToStr(iif(iSTot2 < 2, 0, 11 - iSTot2));
       sVal := Copy(sCPF,10,2);
       Result := iif(sDigs = sVal,true,false);
    end;
end;

function iif(lTest:Boolean; vExpr1,vExpr2:Variant):Variant;
begin
  if lTest then
    Result := vExpr1
  else
    Result := vExpr2
end;

function ValidaCNPJ(CNPJ: string): Boolean;
var
  i, digito1, digito2, cont: integer;
begin
  //Deleta a mascara do CPF caso tenho
  CNPJ := funcoes.StrNum(CNPJ);
  if (Length(CNPJ) <> 14) then //Verifica se o mesmo possui 14 digitos exatos
    Result := False
  else if (CNPJ = '00000000000000') then //Verifica se todos os digitos são 0
    Result := False
  else
  begin
    digito1 := 0;
    digito2 := 0;
    cont := 2;
    try //Caso ocorra algum erro não previsto retorna False
      for i := 12 downto 1 do
      begin
        if cont = 10 then
          cont := 2;
        digito1 := digito1 + (StrToInt(CNPJ[i]) * cont);
        digito2 := digito2 + (StrToInt(CNPJ[i + 1]) * cont);
        cont := cont + 1;
      end;
      digito2 := digito2 + (StrToInt(CNPJ[1]) * 6);
      if (digito1 mod 11) < 2 then
        digito1 := 0
      else
        digito1 := 11 - (digito1 mod 11);
      if (digito2 mod 11) < 2 then
        digito2 := 0
      else
        digito2 := 11 - (digito2 mod 11);
      if (digito1 <> StrToInt(CNPJ[13])) or (digito2 <> StrToInt(CNPJ[14])) then
        Result := False
      else
        Result := True;
    except
      Result := False;
    end;
  end;
end;

function StringToInteger(Ent : String) : integer;
var
  cont : integer;
  temp : string;
begin
  temp := '';
  Result := 0;
  for cont := 1 to length(ent) do
    begin
      Result := Result + ord(ent[cont]);
    end;
  temp := IntToStr(Result);
  if Length(temp) > 4 then
    begin
      try
        temp := copy(temp,1,4)
      except
      end;
    end;
end;

function tfuncoes.IniciaNfe : boolean;
begin
  if not FileExists(GetTheWindowsDirectory+'\system32\libeay32.dll') then
    begin
      CopyFile(pchar('lib\libeay32.dll'),pchar(GetTheWindowsDirectory+'\system32\libeay32.dll'),true);
    end;

  if not FileExists(GetTheWindowsDirectory+'\system32\ssleay32.dll') then
    begin
      CopyFile(pchar('lib\ssleay32.dll'),pchar(GetTheWindowsDirectory+'\system32\ssleay32.dll'),true);
    end;

end;

function tfuncoes.RetornaMaiorTstrings(entra:tstrings) :  string;
var i,len,fim : integer;
begin
  fim := entra.Count -1;
  len := 0;
  Result := '';
  for i := 0 to fim do
    begin
      if length(entra.Strings[i]) > len then
        begin
          Result := entra.Strings[i];
          len := length(entra.Strings[i]);
        end;
    end;
end;


function tfuncoes.StrNum(const entra: string) :  string;
begin
  Result := '';
  for cont := 1 to length(entra) do
    begin
      if Contido(entra[cont],'1234567890') then Result := Result + entra[cont];
    end;
  if Result = '' then Result := '0';
end;


procedure tfuncoes.Ibquery_to_clienteDataSet(var ibquer : TIBQuery; var cliente: TClientDataSet);
var i : integer;
begin
  for i := 0 to ibquer.Fields.Count-1 do
  begin
    cliente.FieldDefs.Add(ibquer.FieldDefs.Items[i].Name,ibquer.FieldDefs.Items[i].DataType,ibquer.FieldDefs.Items[i].Size,ibquer.FieldDefs.Items[i].Required);
 end;
  cliente.CreateDataSet;
  cliente.EmptyDataSet;
end;

function RetornaAcessoUsuario : integer;
begin
  Result := Length(form22.Pgerais.Values['acessousu']);
end;

procedure tfuncoes.GeraCarne(nota,tipo : String);
var tudo,numero : string;
num : integer;
begin
  if tipo = '2' then
    begin
      dm.IBselect.Close;
      dm.IBselect.SQL.Clear;
      dm.IBselect.SQL.Add('select * from contasreceber where (nota = '+nota+') and (pago=0) order by vencimento ');
      try
       dm.IBselect.Open;
      except
       dm.IBselect.Close;
       exit;
      end;

      if dm.IBselect.IsEmpty then
        begin
          dm.IBselect.Close;
          ShowMessage('Não Existem Débitos Com Este Número de Pedido!');
          exit;
        end;

      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add('select * from carne where nota='+nota);
      dm.IBQuery1.Open;

      if dm.IBQuery1.IsEmpty then
        begin
          numero := funcoes.novocod('carne');
          dm.IBQuery1.Close;
          dm.IBQuery1.SQL.Clear;
          dm.IBQuery1.SQL.Add('insert into carne(nota,numero) values('+nota+','+numero+')');
          dm.IBQuery1.ExecSQL;
        end
      else numero := dm.IBQuery1.fieldbyname('numero').AsString;

      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add('select cliente.*,rota.nome as NomeRota from cliente,rota where (rota.cod = cliente.rota) and (cliente.cod='+ dm.IBselect.fieldbyname('documento').AsString+')');
      dm.IBQuery1.Open;

      form19.RichEdit1.Clear;
      funcoes.CharSetRichEdit(form19.RichEdit1);

      dm.IBQuery2.Close;
      dm.IBQuery2.SQL.Clear;
      dm.IBQuery2.SQL.Add('select * from registro');
      dm.IBQuery2.Open;
      addRelatorioForm19('  '+#15+#13+#10);
      num := 0;
      while not dm.IBselect.Eof do
        begin
          if num = 4 then
            begin
              num := 0;
              addRelatorioForm19(' '+#12+#13+#10);
              addRelatorioForm19('  '+#13+#10);
            end;

          addRelatorioForm19('   '+funcoes.CompletaOuRepete(#218,#194,#196,40)+funcoes.CompletaOuRepete('',#191,#196,22)+'   '+funcoes.CompletaOuRepete(#218,#194,#196,40)+funcoes.CompletaOuRepete('',#191,#196,22)+#13+#10);
          addRelatorioForm19('   '+funcoes.CompletaOuRepete(#179+' '+form22.Pgerais.Values['empresa'],#179,' ',40)+funcoes.CompletaOuRepete('PARCELA: '+copy(dm.IBselect.fieldbyname('historico').AsString,length(dm.IBselect.fieldbyname('historico').AsString) - 5,length(dm.IBselect.fieldbyname('historico').AsString)),#179,' ',22)+'   '+funcoes.CompletaOuRepete(#179+' '+form22.Pgerais.Values['empresa'],#179,' ',40)+funcoes.CompletaOuRepete('PARCELA: '+copy(dm.IBselect.fieldbyname('historico').AsString,length(dm.IBselect.fieldbyname('historico').AsString) - 5,length(dm.IBselect.fieldbyname('historico').AsString)),#179,' ',22)+#13+#10);
          addRelatorioForm19('   '+funcoes.CompletaOuRepete(#195,#193,#196,40)+funcoes.CompletaOuRepete('',#180,#196,22)+'   '+funcoes.CompletaOuRepete(#195,#193,#196,40)+funcoes.CompletaOuRepete('',#180,#196,22)+#13+#10);
          //addRelatorioForm19('   '+funcoes.CompletaOuRepete(#179+'  NOME','VALOR R$     '+#179,' ',62)+'   '+funcoes.CompletaOuRepete(#179+'  NOME','VALOR R$     '+#179,' ',62)+#13+#10);
          addRelatorioForm19('   '+funcoes.CompletaOuRepete(#179+' ALUNO(A): '+dm.IBQuery1.fieldbyname('cod').AsString+'-'+dm.IBQuery1.fieldbyname('nome').AsString,#179,' ',62)+'   '+funcoes.CompletaOuRepete(#179+' ALUNO(A): '+dm.IBQuery1.fieldbyname('cod').AsString+'-'+dm.IBQuery1.fieldbyname('nome').AsString,#179,' ',62)+#13+#10);
          addRelatorioForm19('   '+funcoes.CompletaOuRepete(#179,#179,' ',62)+'   '+funcoes.CompletaOuRepete(#179,#179,' ',62)+#13+#10);
          addRelatorioForm19('   '+funcoes.CompletaOuRepete(#179+' MATRICULA: '+copy(dm.IBQuery1.fieldbyname('obs').AsString,1,40),#179,' ',62)+'   '+funcoes.CompletaOuRepete(#179+' MATRICULA: '+copy(dm.IBQuery1.fieldbyname('obs').AsString,1,40),#179,' ',62)+#13+#10);
          addRelatorioForm19('   '+funcoes.CompletaOuRepete(#179,#179,' ',62)+'   '+funcoes.CompletaOuRepete(#179,#179,' ',62)+#13+#10);
          addRelatorioForm19('   '+funcoes.CompletaOuRepete(#179+' CURSO: '+dm.IBQuery1.fieldbyname('nomerota').AsString,#179,' ',62)+'   '+funcoes.CompletaOuRepete(#179+' CURSO: '+dm.IBQuery1.fieldbyname('nomerota').AsString,#179,' ',62)+#13+#10);
          addRelatorioForm19('   '+funcoes.CompletaOuRepete(#179,#179,' ',62)+'   '+funcoes.CompletaOuRepete(#179,#179,' ',62)+#13+#10);
          addRelatorioForm19('   '+funcoes.CompletaOuRepete(#179+' POLO: '+dm.IBQuery2.fieldbyname('cid').AsString+' - '+dm.IBQuery2.fieldbyname('est').AsString,#179,' ',62)+'   '+funcoes.CompletaOuRepete(#179+' POLO: '+dm.IBQuery2.fieldbyname('cid').AsString+' - '+dm.IBQuery2.fieldbyname('est').AsString,#179,' ',62)+#13+#10);
          addRelatorioForm19('   '+funcoes.CompletaOuRepete(#179,#179,' ',62)+'   '+funcoes.CompletaOuRepete(#179,#179,' ',62)+#13+#10);
          addRelatorioForm19('   '+funcoes.CompletaOuRepete(#179+' '+Funcoes.CompletaOuRepete(#218,#191,#196,58),' '#179,' ',62)+'   '+funcoes.CompletaOuRepete(#179+' '+Funcoes.CompletaOuRepete(#218,#191,#196,58),' '#179,' ',62)+#13+#10);
          addRelatorioForm19('   '+funcoes.CompletaOuRepete(#179+' '+Funcoes.CompletaOuRepete(#179+' VENCIMENTO: ',FormatDateTime('dd/mm/yy',dm.IBselect.fieldbyname('vencimento').AsDateTime)+'  '+#179,'.',58),' '#179,' ',62)+'   '+funcoes.CompletaOuRepete(#179+' '+Funcoes.CompletaOuRepete(#179+' VENCIMENTO: ',FormatDateTime('dd/mm/yy',dm.IBselect.fieldbyname('vencimento').AsDateTime)+'  '+#179,'.',58),' '#179,' ',62)+#13+#10);
          addRelatorioForm19('   '+funcoes.CompletaOuRepete(#179+' '+Funcoes.CompletaOuRepete(#179,#179,' ',58),#179,' ',62)+'   '+funcoes.CompletaOuRepete(#179+' '+Funcoes.CompletaOuRepete(#179,#179,' ',58),#179,' ',62)+#13+#10);
          addRelatorioForm19('   '+funcoes.CompletaOuRepete(#179+' '+Funcoes.CompletaOuRepete(#179+' VALOR ATE O VENCIMENTO: ',FormatCurr('#,###,###0.00',dm.IBselect.fieldbyname('valor').AsCurrency)+'  '+#179,'.',58),' '#179,' ',62)+'   '+funcoes.CompletaOuRepete(#179+' '+Funcoes.CompletaOuRepete(#179+' VALOR ATE O VENCIMENTO: ',FormatCurr('#,###,###0.00',dm.IBselect.fieldbyname('valor').AsCurrency)+'  '+#179,'.',58),' '#179,' ',62)+#13+#10);
          addRelatorioForm19('   '+funcoes.CompletaOuRepete(#179+' '+Funcoes.CompletaOuRepete(#179,#179,' ',58),#179,' ',62)+'   '+funcoes.CompletaOuRepete(#179+' '+Funcoes.CompletaOuRepete(#179,#179,' ',58),#179,' ',62)+#13+#10);
          addRelatorioForm19('   '+funcoes.CompletaOuRepete(#179+' '+Funcoes.CompletaOuRepete(#179+' MULTA (2%): ',FormatCurr('#,###,###0.00',Arredonda(dm.IBselect.fieldbyname('valor').AsCurrency * 0.02,2))+'  '+#179,'.',58),' '#179,' ',62)+'   '+funcoes.CompletaOuRepete(#179+' '+Funcoes.CompletaOuRepete(#179+' MULTA (2%): ',FormatCurr('#,###,###0.00',Arredonda(dm.IBselect.fieldbyname('valor').AsCurrency * 0.02,2))+'  '+#179,'.',58),' '#179,' ',62)+#13+#10);
          addRelatorioForm19('   '+funcoes.CompletaOuRepete(#179+' '+Funcoes.CompletaOuRepete(#179,#179,' ',58),#179,' ',62)+'   '+funcoes.CompletaOuRepete(#179+' '+Funcoes.CompletaOuRepete(#179,#179,' ',58),#179,' ',62)+#13+#10);
          addRelatorioForm19('   '+funcoes.CompletaOuRepete(#179+' '+Funcoes.CompletaOuRepete(#179+' CORRECAO ('+ConfParamGerais.Strings[6]+'/dia): ',FormatCurr('#,###,###0.00',Arredonda(dm.IBselect.fieldbyname('valor').AsCurrency * StrToCurr(funcoes.ConverteNumerico(ConfParamGerais.Strings[6])) /100,2))+'  '+#179,'.',58),' '#179,' ',62)+'   '+funcoes.CompletaOuRepete(#179+' '+Funcoes.CompletaOuRepete(#179+' CORRECAO ('+ConfParamGerais.Strings[6]+'/dia): ',FormatCurr('#,###,###0.00',Arredonda(dm.IBselect.fieldbyname('valor').AsCurrency * StrToCurr(funcoes.ConverteNumerico(ConfParamGerais.Strings[6])) /100,2))+'  '+#179,'.',58),' '#179,' ',62)+#13+#10);
          addRelatorioForm19('   '+funcoes.CompletaOuRepete(#179+' '+Funcoes.CompletaOuRepete(#179,#179,' ',58),#179,' ',62)+'   '+funcoes.CompletaOuRepete(#179+' '+Funcoes.CompletaOuRepete(#179,#179,' ',58),#179,' ',62)+#13+#10);
          addRelatorioForm19('   '+funcoes.CompletaOuRepete(#179+' '+Funcoes.CompletaOuRepete(#179+' TOTAL R$: ','___________________  '+#179,'.',58),' '#179,' ',62)+'   '+funcoes.CompletaOuRepete(#179+' '+Funcoes.CompletaOuRepete(#179+' TOTAL R$: ','___________________  '+#179,'.',58),' '#179,' ',62)+#13+#10);
          addRelatorioForm19('   '+funcoes.CompletaOuRepete(#179+' '+Funcoes.CompletaOuRepete(#192,#217,#196,58),#179,' ',62)+'   '+funcoes.CompletaOuRepete(#179+' '+Funcoes.CompletaOuRepete(#192,#217,#196,58),#179,' ',62)+#13+#10);
          addRelatorioForm19('   '+funcoes.CompletaOuRepete(#179+funcoes.centraliza('RECIBO ALUNO',' ',60),#179,' ',62)+'   '+funcoes.CompletaOuRepete(#179+funcoes.centraliza('RECIBO CURSO',' ',60),#179,' ',62)+#13+#10);
          addRelatorioForm19('   '+funcoes.CompletaOuRepete(#192,#217,#196,62)+'   '+funcoes.CompletaOuRepete(#192,#217,#196,62)+#13+#10);
          addRelatorioForm19('   '+#13+#10);
          num := num + 1;
          dm.IBselect.Next;
        end;

       dm.IBselect.Close;
       dm.IBQuery2.Close;
       dm.IBQuery1.Close;
       form19.ShowModal;
    end
  else if tipo = '1' then
    begin


      dm.IBselect.Close;
      dm.IBselect.SQL.Clear;
      dm.IBselect.SQL.Add('select * from contasreceber where (nota = '+nota+') and (pago=0) order by vencimento ');
      try
       dm.IBselect.Open;
      except
       dm.IBselect.Close;
       exit;
      end;

      if dm.IBselect.IsEmpty then
        begin
          dm.IBselect.Close;
          ShowMessage('Não Existem Débitos Com Este Número de Pedido!');
          exit;
        end;

      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add('select * from carne where nota='+nota);
      dm.IBQuery1.Open;

      if dm.IBQuery1.IsEmpty then
        begin
          numero := funcoes.novocod('carne');
          dm.IBQuery1.Close;
          dm.IBQuery1.SQL.Clear;
          dm.IBQuery1.SQL.Add('insert into carne(nota,numero) values('+nota+','+numero+')');
          dm.IBQuery1.ExecSQL;
        end
      else numero := dm.IBQuery1.fieldbyname('numero').AsString;

      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add('select nome from cliente where cod ='+ dm.IBselect.fieldbyname('documento').AsString);
      dm.IBQuery1.Open;

      form19.RichEdit1.Clear;
      funcoes.CharSetRichEdit(form19.RichEdit1);

      dm.IBQuery2.Close;
      dm.IBQuery2.SQL.Clear;
      dm.IBQuery2.SQL.Add('select * from registro');
      dm.IBQuery2.Open;
      addRelatorioForm19('  '+#15+#13+#10);
      num := 0;
      while not dm.IBselect.Eof do
        begin
          if num = 5 then
            begin
              num := 0;
              addRelatorioForm19(' '+#12+#13+#10);
              addRelatorioForm19('  '+#13+#10);
            end;

          addRelatorioForm19('   '+funcoes.CompletaOuRepete(#218,#191,#196,62)+'   '+funcoes.CompletaOuRepete(#218,#191,#196,62)+#13+#10);
          addRelatorioForm19('   '+funcoes.CompletaOuRepete(#179+funcoes.centraliza(form22.Pgerais.Values['empresa'],' ',41),dm.IBQuery2.fieldbyname('telres').AsString+'    '+#179,' ',62)+'   '+funcoes.CompletaOuRepete(#179+funcoes.centraliza(form22.Pgerais.Values['empresa'],' ',41),dm.IBQuery2.fieldbyname('telres').AsString+'    '+#179,' ',62)+#13+#10);
          addRelatorioForm19('   '+funcoes.CompletaOuRepete(#179+'  NOME','VALOR R$     '+#179,' ',62)+'   '+funcoes.CompletaOuRepete(#179+'  NOME','VALOR R$     '+#179,' ',62)+#13+#10);
          addRelatorioForm19('   '+funcoes.CompletaOuRepete(#179+' '+funcoes.CompletaOuRepete(#218,#191,#196,39)+funcoes.CompletaOuRepete(#218,#191,#196,19),#179,' ',62)+'   '+funcoes.CompletaOuRepete(#179+' '+funcoes.CompletaOuRepete(#218,#191,#196,39)+funcoes.CompletaOuRepete(#218,#191,#196,19),#179,' ',62)+#13+#10);
          addRelatorioForm19('   '+funcoes.CompletaOuRepete(#179+' '+funcoes.CompletaOuRepete(#179+copy(dm.IBQuery1.fieldbyname('nome').AsString,1,37),#179,' ',39)+funcoes.CompletaOuRepete(#179,FormatCurr('#,###,###0.00',dm.IBselect.fieldbyname('valor').AsCurrency)+#179,' ',19),#179,' ',62)+'   '+funcoes.CompletaOuRepete(#179+' '+funcoes.CompletaOuRepete(#179+copy(dm.IBQuery1.fieldbyname('nome').AsString,1,37),#179,' ',39)+funcoes.CompletaOuRepete(#179,FormatCurr('#,###,###0.00',dm.IBselect.fieldbyname('valor').AsCurrency)+#179,' ',19),#179,' ',62)+#13+#10);
          addRelatorioForm19('   '+funcoes.CompletaOuRepete(#179+' '+funcoes.CompletaOuRepete(#192,#217,#196,39)+funcoes.CompletaOuRepete(#192,#217,#196,19),#179,' ',62)+'   '+funcoes.CompletaOuRepete(#179+' '+funcoes.CompletaOuRepete(#192,#217,#196,39)+funcoes.CompletaOuRepete(#192,#217,#196,19),#179,' ',62)+#13+#10);
          addRelatorioForm19('   '+funcoes.CompletaOuRepete(#179+'  VENCIMENTO   PARCELA     CORRECAO R$     TOTAL PAGO R$',#179,' ',62)+'   '+funcoes.CompletaOuRepete(#179+'  VENCIMENTO   PARCELA     CORRECAO R$     TOTAL PAGO R$',#179,' ',62)+#13+#10);
          addRelatorioForm19('   '+funcoes.CompletaOuRepete(#179+' '+funcoes.CompletaOuRepete(#218,#191,#196,10)+'   '+funcoes.CompletaOuRepete(#218,#191,#196,9)+'  '+funcoes.CompletaOuRepete(#218,#191,#196,15)+' '+funcoes.CompletaOuRepete(#218,#191,#196,18),#179,' ',62)+'   '+funcoes.CompletaOuRepete(#179+' '+funcoes.CompletaOuRepete(#218,#191,#196,10)+'   '+funcoes.CompletaOuRepete(#218,#191,#196,9)+'  '+funcoes.CompletaOuRepete(#218,#191,#196,15)+' '+funcoes.CompletaOuRepete(#218,#191,#196,18),#179,' ',62)+#13+#10);
          addRelatorioForm19('   '+funcoes.CompletaOuRepete(#179+' '+funcoes.CompletaOuRepete(#179+FormatDateTime('dd/mm/yy',dm.IBselect.fieldbyname('vencimento').AsDateTime),#179,' ',10)+'   '+funcoes.CompletaOuRepete(#179+copy(dm.IBselect.fieldbyname('historico').AsString,length(dm.IBselect.fieldbyname('historico').AsString) - 5,length(dm.IBselect.fieldbyname('historico').AsString)),#179,' ',9)+'  '+funcoes.CompletaOuRepete(#179,FormatCurr('#,###,###0.00',0)+#179,' ',15)+' '+funcoes.CompletaOuRepete(#179,#179,' ',18),#179,' ',62)+'   '+
funcoes.CompletaOuRepete(#179+' '+funcoes.CompletaOuRepete(#179+FormatDateTime('dd/mm/yy',dm.IBselect.fieldbyname('vencimento').AsDateTime),#179,' ',10)+'   '+funcoes.CompletaOuRepete(#179+copy(dm.IBselect.fieldbyname('historico').AsString,length(dm.IBselect.fieldbyname('historico').AsString) - 5,length(dm.IBselect.fieldbyname('historico').AsString)),#179,' ',9)+'  '+funcoes.CompletaOuRepete(#179,FormatCurr('#,###,###0.00',0)+#179,' ',15)+' '+funcoes.CompletaOuRepete(#179,#179,' ',18),#179,' ',62)+#13+#10);
          addRelatorioForm19('   '+funcoes.CompletaOuRepete(#179+' '+funcoes.CompletaOuRepete(#192,#217,#196,10)+'   '+funcoes.CompletaOuRepete(#192,#217,#196,9)+'  '+funcoes.CompletaOuRepete(#192,#217,#196,15)+' '+funcoes.CompletaOuRepete(#192,#217,#196,18),#179,' ',62)+'   '+funcoes.CompletaOuRepete(#179+' '+funcoes.CompletaOuRepete(#192,#217,#196,10)+'   '+funcoes.CompletaOuRepete(#192,#217,#196,9)+'  '+funcoes.CompletaOuRepete(#192,#217,#196,15)+' '+funcoes.CompletaOuRepete(#192,#217,#196,18),#179,' ',62)+#13+#10);
          addRelatorioForm19('   '+funcoes.CompletaOuRepete(#179+'     DATA PAGTO            ASSINATURA DO RECEBEDOR',#179,' ',62)+'   '+funcoes.CompletaOuRepete(#179+'     DATA PAGTO            ASSINATURA DO RECEBEDOR',#179,' ',62)+#13+#10);
          addRelatorioForm19('   '+funcoes.CompletaOuRepete(#179+' '+funcoes.CompletaOuRepete(#218,#191,#196,22)+' '+funcoes.CompletaOuRepete(#218,#191,#196,35),#179,' ',62)+'   '+funcoes.CompletaOuRepete(#179+' '+funcoes.CompletaOuRepete(#218,#191,#196,22)+' '+funcoes.CompletaOuRepete(#218,#191,#196,35),#179,' ',62)+#13+#10);
          addRelatorioForm19('   '+funcoes.CompletaOuRepete(#179+' '+funcoes.CompletaOuRepete(#179,#179,' ',22)+' '+funcoes.CompletaOuRepete(#179,#179,' ',35),#179,' ',62)+'   '+funcoes.CompletaOuRepete(#179+' '+funcoes.CompletaOuRepete(#179,#179,' ',22)+' '+funcoes.CompletaOuRepete(#179,#179,' ',35),#179,' ',62)+#13+#10);
          addRelatorioForm19('   '+funcoes.CompletaOuRepete(#179+' '+funcoes.CompletaOuRepete(#192,#217,#196,22)+' '+funcoes.CompletaOuRepete(#192,#217,#196,35),#179,' ',62)+'   '+funcoes.CompletaOuRepete(#179+' '+funcoes.CompletaOuRepete(#192,#217,#196,22)+' '+funcoes.CompletaOuRepete(#192,#217,#196,35),#179,' ',62)+#13+#10);
          addRelatorioForm19('   '+funcoes.CompletaOuRepete(#179+'            QUITAC'+#199+'O CONDICIONADA '+#183+' COMPENSACAO',#179,' ',62)+'   '+funcoes.CompletaOuRepete(#179+'            QUITAC'+#199+'O CONDICIONADA '+#183+' COMPENSACAO',#179,' ',62)+#13+#10);
          addRelatorioForm19('   '+funcoes.CompletaOuRepete(#179+'   Presta'+#135+#229'es Pagas com Atraso Sofrer'+#198+'o Acresc'+#214+'mos de Juros',#179,' ',62)+'   '+funcoes.CompletaOuRepete(#179+'   Presta'+#135+#229'es Pagas com Atraso Sofrer'+#198+'o Acresc'+#214+'mos de Juros',#179,' ',62)+#13+#10);
          addRelatorioForm19('   '+funcoes.CompletaOuRepete(#179+' '+numero,#179,' ',62)+'   '+funcoes.CompletaOuRepete(#179+' '+numero,#179,' ',62)+#13+#10);
          addRelatorioForm19('   '+funcoes.CompletaOuRepete(#192,#217,#196,62)+'   '+funcoes.CompletaOuRepete(#192,#217,#196,62)+#13+#10);
          addRelatorioForm19('   '+#13+#10);
          num := num + 1;
          dm.IBselect.Next;
        end;

       dm.IBselect.Close;
       dm.IBQuery2.Close;
       dm.IBQuery1.Close;
       form19.ShowModal;

    end;
end;


procedure tfuncoes.Traca_Nome_Rota;
begin
  form2.MainMenu1.Items.Items[5].Items[9].Caption := ConfParamGerais.Strings[7] ;
  form2.MainMenu1.Items.Items[4].Items[1].Items[5].Caption := 'Resumo P/'+ConfParamGerais.Strings[7];
end;

function VerificaAcesso_Se_Nao_tiver_Nenhum_bloqueio_true_senao_false : boolean;
begin
  if Length(form22.Pgerais.Values['acessousu']) > 0 then Result := false
    else Result := true;
end;

function JustificarStrings(ent: string;qtd: integer) : string;
var I : integer;
begin
  Result := ent;
  while length(ent) < qtd  do
    begin
      for i := 0 to length(ent) do
        begin
          ShowMessage(ent);
          if ent[i] = ' ' then insert(' ',ent,i);
          if length(ent) >= qtd then
            begin
              break;
              Result := ent;
              exit;
            end;
        end;
    end;
end;

procedure addRelatorioForm19(Adicionar : string);
begin
  form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((Adicionar))));
end;

procedure GeraParcelamento(codvenda,formpagto,codcliente,nomecliente,vendedor,codgru : string ;parcelas,periodo : integer;vencimento1 : TDateTime;valorp : Currency);
var i : integer;
vencimento : TDateTime;
begin
  for i := 1 to parcelas do
    begin
      if i = 1 then vencimento := vencimento1;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add('insert into contasreceber(nota,codgru,cod,formpagto,datamov,vendedor,data,vencimento,documento,codhis,historico,total,valor) values('+codvenda+',1,'+funcoes.novocod('cpagar')+','+formpagto+',:datamov,'+vendedor+',:data,:vencimento,'+codcliente+',2,:hist,:total,:valor)');
      dm.IBQuery1.ParamByName('datamov').AsDateTime:= form22.datamov;
      if i <> 1 then vencimento := vencimento + periodo;
      dm.IBQuery1.ParamByName('data').AsDateTime := vencimento;
      dm.IBQuery1.ParamByName('vencimento').AsDateTime := vencimento;
      dm.IBQuery1.ParamByName('hist').AsString :=  funcoes.CompletaOuRepete(copy(codvenda +'-'+nomecliente,1,28 ),funcoes.CompletaOuRepete('',IntToStr(i),' ',2)+'/'+funcoes.CompletaOuRepete('',IntToStr(parcelas),' ',2),' ',35);
      dm.IBQuery1.ParamByName('total').AsCurrency := valorp;
      dm.IBQuery1.ParamByName('valor').AsCurrency := valorp;
      try
        dm.IBQuery1.ExecSQL;
      except
        dm.IBQuery1.Transaction.Rollback;
        exit;
      end;
    end;
end;


function tfuncoes.QuebraLinhas(ini,fim,entrada:string; qtdQuebra:integer) : string;
var posi,i,a,fim1,c : integer;
nome,temp : string;
begin

while length(entrada) <> 0 do
  begin
    if Length(ini+entrada+fim) < qtdQuebra then
     begin
       addRelatorioForm19(funcoes.CompletaOuRepete(ini+entrada,fim,' ',qtdQuebra)+#13+#10);
       exit;
     end;

    for i := qtdQuebra -1 downto 1 do
      begin
        if Length(funcoes.CompletaOuRepete(ini+copy(TrimRight(entrada),1,c),fim,' ',qtdQuebra)) < qtdQuebra then
          begin
            c := 0;
            break;
          end;
        if (entrada[i] = ' ') and (i < qtdQuebra)  then
          begin
            c := i;
            break;
          end;
      end;                                                                                          //copy((entrada),1,c-1)
     if Length(funcoes.CompletaOuRepete(ini+copy((entrada),1,c),fim,' ',qtdQuebra)) = qtdQuebra then  addRelatorioForm19(funcoes.CompletaOuRepete(ini+copy((entrada),1,c-1),fim,' ',qtdQuebra)+#13+#10)
      else  addRelatorioForm19(funcoes.CompletaOuRepete(ini+copy(TrimRight(entrada),1,c),fim,' ',qtdQuebra)+#13+#10);
     if c = 0 then delete(entrada,1,length(entrada))
     else  delete(entrada,1,c);
   end;
end;

function tfuncoes.ExisteParcelamento(nota : string) : boolean;
  begin
    dm.IBQuery1.Close;
    dm.IBQuery1.SQL.Clear;
    dm.IBQuery1.SQL.Add('select vencimento,valor from contasreceber where nota='+nota);
    dm.IBQuery1.Open;
    if dm.IBQuery1.IsEmpty then Result := false
     else result := true;
    dm.IBQuery1.Close;
  end;

procedure tfuncoes.ImprimeParcelamento(ini,fim,entrada,nota : string);
begin
  dm.IBQuery1.Close;
  dm.IBQuery1.SQL.Clear;
  dm.IBQuery1.SQL.Add('select vencimento,valor from contasreceber where nota='+nota);
  dm.IBQuery1.Open;
  dm.IBQuery1.First;
  if dm.IBQuery1.IsEmpty then
    begin
      dm.IBQuery1.Close;
      exit;
    end;

   form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar(('   '+#13+#10))));
   form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((ini+'* * *  PARCELAMENTO  * * *'+fim+#13+#10))));
   form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((ini+'*                        *'+fim+#13+#10))));
   form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((ini+'* ENTRADA:' + funcoes.CompletaOuRepete('',entrada,' ',14)+' *'+fim+#13+#10))));
   while not dm.IBQuery1.Eof do
     begin
       form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((ini+'* '+FormatDateTime('dd/mm/yy',dm.IBQuery1.fieldbyname('vencimento').AsDateTime) + funcoes.CompletaOuRepete('',FormatCurr('#,###,###0.00',dm.IBQuery1.fieldbyname('valor').AsCurrency),' ',14)+' *'+fim+#13+#10 ))));
       dm.IBQuery1.Next;
     end;
   form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((ini+'*                        *'+fim+#13+#10))));
   form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((ini+'* * *  * * * * * * * * * *'+fim+#13+#10))));
   dm.IBQuery1.Close;

end;


procedure tfuncoes.GeraTemas;
var bs : TStream;
fig : TJPEGImage;
begin
  dm.IBselect.Close;
  dm.IBselect.SQL.Clear;
  dm.IBselect.SQL.Add('select * from config_tema');
  dm.IBselect.Open;

  if dm.IBselect.IsEmpty then
    begin
      dm.IBselect.Close;
      exit;
    end;

  if Papel_de_Parede = nil then
    begin
      fig := TJPEGImage.Create;
      bs := TStream.Create;
      bs := dm.IBselect.CreateBlobStream(dm.IBselect.FieldByName('papel'),bmRead);
      if bs.Size > 0 then
        Begin
          fig.LoadFromStream(bs);
          Papel_de_Parede := fig;
          Form2.Image1.Picture.Assign(fig);
        end;
      //dm.IBselect.Close;
    end;

  if not dm.IBselect.FieldByName('cor').IsNull then
    begin
      if dm.IBselect.FieldByName('cor').AsInteger = 2 then
        begin
          //form2.Label1.Font.Color := clWhite;
          //form2.Label2.Font.Color := clWhite;
        {  form2.Label3.Font.Color := clWhite;
          form2.Label4.Font.Color := clWhite;
          form2.Label5.Font.Color := clWhite;
          form2.Label6.Font.Color := clWhite;
          form2.Label7.Font.Color := clWhite;
          form2.Label8.Font.Color := clWhite;
          Form2.Label2.Visible := false;
        }end
      else
        begin
       {   form2.Label1.Font.Color := clblack;
          form2.Label2.Font.Color := clBlack;
          form2.Label3.Font.Color := clBlack;
          form2.Label4.Font.Color := clBlack;
          form2.Label5.Font.Color := clBlack;
          form2.Label6.Font.Color := clBlack;
          form2.Label7.Font.Color := clBlack;
          form2.Label8.Font.Color := clBlack;
          Form2.Label2.Visible := false;
        }end;
    end;
//  if not dm.IBselect.FieldByName('nome').IsNull then  form2.Label1.Caption := dm.IBselect.fieldbyname('nome').AsString ;
//  if not dm.IBselect.FieldByName('top').IsNull then form2.Label1.Top := dm.IBselect.fieldbyname('top').AsInteger;
//  if not dm.IBselect.FieldByName('esq').IsNull then form2.Label1.Left := dm.IBselect.fieldbyname('esq').AsInteger;

end;

function tfuncoes.TimageToFileStream(caminho : string) : TFileStream;
begin
  Result := TFileStream.Create(caminho,fmOpenRead);
end;

function tfuncoes.RetornaMaiorData(v1 : TDateTime; v2 : TDateTime) : TDateTime;
  begin
    if v1 > v2 then Result := v1
      else Result := v2;
  end;


function tfuncoes.OrdenarValoresStringList(var valor_a_Ser_Ordenado : TStringList) : TStringList;
var a,b : integer;
valor : currency;
ok :  boolean;
begin
    for b := 0 to valor_a_Ser_Ordenado.Count do
      begin
        for a := 0 to valor_a_Ser_Ordenado.Count -1 do
          begin
            if StrToCurr(valor_a_Ser_Ordenado.Values[valor_a_Ser_Ordenado.Names[a]]) > valor then
              begin
                valor_a_Ser_Ordenado.Move(a,0);
                valor := StrToCurr(valor_a_Ser_Ordenado.Values[valor_a_Ser_Ordenado.Names[a]]);
              end
            else  valor := StrToCurr(valor_a_Ser_Ordenado.Values[valor_a_Ser_Ordenado.Names[a]]);
          end;
      end;
end;

function Reorganizar : boolean;
var indices : TStringList;
i : integer;
begin
  indices := TStringList.Create;
  indices.Add('IDX_ITEM_ENTRADA_1');
  indices.Add('PRODUTO_IDX1');
  indices.Add('PRODUTO_IDX2');

  For i := 0 to indices.Count -1 do
    begin
      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add('alter index '+indices.Strings[i]+' inactive');
      dm.IBQuery1.ExecSQL;

      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add('alter index '+indices.Strings[i]+' active');
      dm.IBQuery1.ExecSQL;

      dm.IBQuery1.Close;
      dm.IBQuery1.SQL.Clear;
      dm.IBQuery1.SQL.Add('SET STATISTICS INDEX '+indices.Strings[i]);
      dm.IBQuery1.ExecSQL;

    end;

    try
      dm.IBQuery1.Transaction.Commit;
      ShowMessage('Reorganizacao Completada!');
    except

    end;
end;

function HexToTColor(sColor : string) : TColor;
begin
   Result :=
     RGB(
       StrToInt('$'+Copy(sColor, 1, 2)),
       StrToInt('$'+Copy(sColor, 3, 2)),
       StrToInt('$'+Copy(sColor, 5, 2))
     ) ;
end;

function VerificaRegistro(param : integer) : boolean;
var
  ativo,empresa : string;
  temp : integer;
begin
  if param = 1 then
    begin
      dm.IBselect.Close;
      dm.IBselect.SQL.Clear;
      dm.IBselect.SQL.Add('select empresa,registro from registro');
      dm.IBselect.Open;
      temp := dm.IBselect.FieldByName('registro').AsInteger;
      ativo := '';
      empresa := '';
      empresa := trim(dm.IBselect.FieldByName('empresa').AsString);
      dm.IBselect.Close;
      if StringToInteger(empresa) = temp then
        begin
          Result := true;
          Ativado := true;
          demo := false;
        end
      else if temp = trunc(StringToInteger(empresa) / 2) then
        begin
          Result := true;
          Ativado := true;
          demo := true;
          dm.IBselect.Close;
          dm.IBselect.SQL.Clear;
          dm.IBselect.SQL.Add('select dtr from acesso where dtr = :d');
          dm.IBselect.ParamByName('d').AsDateTime := form22.datamov;
          dm.IBselect.Open;

          if dm.IBselect.IsEmpty then temp := 1
            else temp := 0;

          if temp = 1 then
            begin
              dm.IBQuery1.Close;
              dm.IBQuery1.SQL.Clear;
              dm.IBQuery1.SQL.Add('insert into acesso(acesso,dtr) values('+QuotedStr('')+', :d)');
              dm.IBQuery1.ParamByName('d').AsDateTime := form22.datamov;
              dm.IBQuery1.ExecSQL;
              dm.IBQuery1.Transaction.Commit;
            end;
          dm.IBselect.Close;
          dm.IBselect.SQL.Clear;
          dm.IBselect.SQL.Add('select dtr from acesso where dtr <> :d');
          dm.IBselect.ParamByName('d').AsDateTime := StrToDate('01/01/1900');
          dm.IBselect.Open;
          dm.IBselect.FetchAll;
          temp := dm.IBselect.RecordCount;
          if temp > 15 then
            begin
              Result := false;
              Ativado := false;
              ShowMessage('Esta Versão de Demonstração Expirou os 15 dias');
            end
          else if temp = 5 then ShowMessage('Falta apenas 10 dias Para está cópia expirar.')
          else if temp = 10 then ShowMessage('Falta apenas 5 dias Para está cópia expirar.');

          dm.IBselect.Close;
          dm.IBQuery1.Close;
        end
      else
        begin
          Result := false;
          Ativado := false;
          demo := false;
        end;
   end;
end;

Procedure FileCopy( Const sourcefilename, targetfilename: String );
Var
  S, T: TFileStream;
Begin
  S := TFileStream.Create( sourcefilename, fmOpenRead );
  try
    T := TFileStream.Create( targetfilename, fmOpenWrite or fmCreate );
    try
      T.CopyFrom(S, S.Size ) ;
    finally
      T.Free;
    end;
  finally
    S.Free;
  end;
End;

function Arredonda( valor:currency; decimais:integer) : currency;
 begin
   if form22.Pgerais.Values['ARREDONDA'] = 'F' then Result := funcoes.ArredondaFinanceiro(valor,decimais)
   else if form22.Pgerais.Values['ARREDONDA'] = 'T' then Result := funcoes.ArredondaTrunca(valor,decimais);
 end;

function WWMessage(flmessage: String; flType: TMsgDlgType; flbutton: TMsgDlgButtons; flColor: TColor; flBold, flItalic: boolean;WWFormColor:TColor): String;
begin
  with CreateMessageDialog(flmessage , flType ,flbutton) do
  begin
     try
        TLabel(FindComponent('Message')).Font.Color := flColor;
        Color := WWFormColor;
        if flBold then
           TLabel(FindComponent('Message')).Font.Style := [fsBold];
        if flItalic then
           TLabel(FindComponent('Message')).Font.Style := [fsItalic];
        ShowModal;
      finally
        Free;
    end;
  end;
end;

function tfuncoes.DesCriptografar(wStri: String): String;
var  x , posicao            : Integer;
sim1 : string;
begin
 sim1 := Simbolos[1];
 Result := '';
 for x := 1 to Length(wStri) do
   begin
     posicao := pos(wStri[x],simbolos[2]);
     Result := Result + sim1[posicao];
   end;
end;

function tfuncoes.Criptografar(wStri: String): String;
var  x , posicao            : Integer;
sim2 : string;
begin
 sim2 := Simbolos[2];
 Result := '';
 for x := 1 to Length(wStri) do
   begin
     try
       posicao := pos(wStri[x],simbolos[1]);
       Result := Result + sim2[posicao];
     except
     end;
   end;
end;

function lancaValorMinimo(total:currency;minimo:currency;Msg:string) : currency;
var valor : string;
begin
  valor := '0,00001';
  while strtocurr(valor) < minimo do
   begin
     valor := funcoes.ConverteNumerico(funcoes.dialogo('numero',0,'1234567890,.'+#8,0,false,'ok','Control for Windows:','Qual o Percentual de Desconto (%)?:','0,00%'));
   end;
end;

function retornaPos(valor:string;sub:string;posi:integer) : integer;
begin
 valor := copy(valor,posi,length(valor));
 result := pos(sub,valor)-1;
end;

function GravarConfig(valor:string;AserGravado:string;posi:integer) : string;
var p1,p2 : string;
begin
  p1 := copy(valor,1,pos('-'+IntToStr(posi)+'-',valor) + 2);
  valor := copy(valor,pos('-'+IntToStr(posi)+'-',valor) + 3,length(valor));
  p2 := copy(valor,pos('-',valor) ,length(valor));
  Result := p1+' '+AserGravado+
  ' '+p2;
end;

function tfuncoes.LerConfig(valor:string;posi:integer) : string;
begin
result := Trim(copy(valor,pos('-'+inttostr(posi)+'-',valor)+3,retornaPos(valor,'-',pos('-'+inttostr(posi)+'-',valor)+3)));
end;

function tfuncoes.RetornaValorConfig(Config:string;posi:integer) : variant;
begin
  result := '';
  ///  result := copy(config,pos('-'+IntToStr(posi)+'-',config)+3,RetornaPos(config,'-',pos('-'+IntToStr(posi)+'-',config)+3));
end;

function tfuncoes.GerarPgeraisList(codUsu: string) : TStringList;
var arr,temp : TStringList;
begin
 arr := TStringList.Create;

 dm.IBselect.Close;
 dm.IBselect.SQL.Clear;
 dm.IBselect.SQL.Add('select empresa from registro');
 dm.IBselect.Open;
 arr.Add('empresa='+ trim(UpperCase(dm.IBselect.fieldbyname('empresa').AsString)));
 dm.IBselect.Close;

 dm.IBselect.SQL.Clear;
 dm.IBselect.SQL.Add('select * from pgerais where cod=0');
 dm.IBselect.Open;
 arr.Add('ARREDONDA='+ UpperCase(dm.IBselect.fieldbyname('valor').AsString));
 dm.IBselect.Close;

 dm.IBselect.SQL.Clear;
 dm.IBselect.SQL.Add('select * from usuario where cod='+codUsu);
 dm.IBselect.Open;
 arr.Add('acessousu='+funcoes.DesCriptografar(dm.IBselect.fieldbyname('acesso').AsString));
 arr.Add('codvendedor='+dm.IBselect.fieldbyname('vendedor').AsString);
 arr.Add('configu='+dm.IBselect.fieldbyname('configu').AsString);
 dm.IBselect.Close;

 arr.Add('nota='+LerConfig(arr.Values['configu'],1));

 dm.IBselect.SQL.Clear;
 dm.IBselect.SQL.Add('select acesso from acesso');
 dm.IBselect.Open;
 arr.Add('acesso='+ dm.IBselect.fieldbyname('acesso').AsString);
 dm.IBselect.Close;

 if FileExists(funcoes.GetTheWindowsDirectory+'\conf_ter.dat') then
  begin
    temp := TStringList.Create;
    temp.LoadFromFile(funcoes.GetTheWindowsDirectory+'\conf_ter.dat');
    arr.Add('conf_ter='+temp.Strings[0]);
    arr.Values['nota'] := LerConfig(arr.Values['conf_ter'],0);
    temp.Destroy;
  end;

 result:=arr;
end;

function tfuncoes.CompararStringLists(var v1: tstringlist;var v2 : tstringlist) : boolean;
var i : integer;
begin
  Result := false;
  for i := 0 to v1.Count - 1 do
   begin
     if v1.Strings[i] = v2.Strings[i] then result := true
      else
       begin
        //ShowMessage(v1.Strings[i]+' <> '+v2.Strings[i]+'false');
        result := false;
        break;
       end;
   end;
end;

function tfuncoes.GravaTexT(dire:string;conteudo:string) : boolean;
begin

end;

function tfuncoes.GetTheWindowsDirectory : string;
var
  WinPath: array[0..MAX_PATH + 1] of Char;
begin
  GetWindowsDirectory(WinPath, MAX_PATH);
  Result := WinPath;
end;

function tfuncoes.GeraNota(numNota:string;tipo:string;EnviarImpressora:string;Venda:boolean) : boolean;
var total,sub,entrada,total_item : currency;
 i : integer;
begin
   dm.IBselect.Close;
   dm.IBselect.SQL.Clear;
   if Venda then dm.IBselect.SQL.Add('select * from venda where nota='+numNota)
     else dm.IBselect.SQL.Add('select * from orcamento where nota='+numNota);
   try
    dm.IBselect.Open;
   except
    exit;
   end;
   form19.RichEdit1.Clear;
   if Venda then entrada := dm.IBselect.fieldbyname('entrada').AsCurrency;

   if tipo='D' then
    begin
      form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('','','-',40)+#13+#10))));
      form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('NOTA: '+numNota,'  VENDEDOR: '+dm.IBselect.fieldbyname('vendedor').AsString+'-'+copy(BuscaNomeBD(dm.ibquery1,'nome','vendedor','where cod='+dm.IBselect.fieldbyname('vendedor').AsString),1,10),' ',40)+#13+#10))));
      form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((#13+#10))));
      form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar(('FORMA PAGTO: '+dm.IBselect.fieldbyname('codhis').AsString+'-'+(BuscaNomeBD(dm.ibquery1,'nome','formpagto','where cod='+dm.IBselect.fieldbyname('codhis').AsString))+#13+#10))));
      form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((#13+#10))));
      form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar(('DATA: '+FormatDateTime('DD/MM/YY',dm.IBselect.fieldbyname('data').AsDateTime)+'        VALOR:'+CompletaOuRepete('',FormatCurr('#,###,###0.00',dm.ibselect.fieldbyname('total').AsCurrency),' ',11)+#13+#10))));
      form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('','','-',40)+#13+#10))));

      if EnviarImpressora = 'S' then
       begin
        imprime.textx('texto.txt');
       end
      else form19.ShowModal;

    end;

   if tipo='L' then
    begin
     total := 0;
     dm.IBQuery2.Close;
     dm.IBQuery2.SQL.Clear;
     dm.IBQuery2.SQL.Add('select * from registro');
     dm.IBQuery2.Open;

     form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('+','+','-',80)+#13+#10))));
     form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('| PEDIDO Nr:'+dm.IBselect.fieldbyname('nota').AsString+'     PAGTO: '+dm.IBselect.fieldbyname('codhis').AsString+'-'+(BuscaNomeBD(dm.ibquery1,'nome','formpagto','where cod='+dm.IBselect.fieldbyname('codhis').AsString)),'EMISSAO: '+dm.IBselect.fieldbyname('data').AsString+' |',' ',80)+#13+#10))));
     form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('+','+','-',80)+#13+#10))));
     form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('| '+form22.Pgerais.Values['empresa'],'CNPJ: '+dm.IBQuery2.fieldbyname('cnpj').AsString+' |',' ',80)+#13+#10))));
     form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('| '+dm.IBQuery2.fieldbyname('ende').AsString+'  - '+dm.IBQuery2.fieldbyname('bairro').AsString,'|',' ',80)+#13+#10))));
     form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('| Fone: '+dm.IBQuery2.fieldbyname('telres').AsString+'  Fax: '+dm.IBQuery2.fieldbyname('telcom').AsString+ '  '+ dm.IBQuery2.fieldbyname('cid').AsString+' - '+dm.IBQuery2.fieldbyname('est').AsString,'IE: '+dm.IBQuery2.fieldbyname('ies').AsString+' |',' ',80)+#13+#10))));
     form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('| Obs: '+dm.IBQuery2.FieldByName('obs').AsString,'|',' ',80)+#13+#10))));
     form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('+','+','-',80)+#13+#10))));
     form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('| Nome: '+funcoes.CompletaOuRepete(funcoes.BuscaNomeBD(dm.ibquery1,'nome','cliente','where cod='+dm.IBselect.fieldbyname('cliente').AsString),'|',' ',41),'CPF/CNPJ: '+funcoes.BuscaNomeBD(dm.ibquery1,'cnpj','cliente','where cod='+dm.IBselect.fieldbyname('cliente').AsString)+' |',' ',80)+#13+#10))));
     form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('+','+','-',80)+#13+#10))));
     test := 1;
     form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((#15+#13+#10))));
     form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar(('| Codigo | Unid. | Qtd. | Descricao das Mercadorias |Unitario|  Total  | Referencia | Localizacao |'+#13+#10))));
     form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar(('+--------+-------+------+---------------------------+--------+---------+------------+-------------+'+#13+#10))));

     dm.IBQuery2.Close;
     dm.IBQuery2.SQL.Clear;
     dm.IBQuery2.SQL.Add('select * from item_venda where nota='+numNota);
     dm.IBQuery2.Open;
     dm.IBQuery2.First;
     sub := 0;
     total := 0;
     while not dm.IBQuery2.Eof do
      begin
        dm.IBQuery1.Close;
        dm.IBQuery1.SQL.Clear;
        dm.IBQuery1.SQL.Add('select * from produto where cod='+dm.IBQuery2.fieldbyname('cod').AsString);
        dm.IBQuery1.Open;
        total := total + dm.IBQuery2.fieldbyname('total').AsCurrency;
        sub := sub + dm.IBQuery2.fieldbyname('quant').AsCurrency;
        form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar(('|'+funcoes.CompletaOuRepete('',dm.IBQuery2.fieldbyname('cod').AsString+'|',' ',9)+funcoes.CompletaOuRepete('',dm.ibquery1.fieldbyname('unid').AsString+'|',' ',8)+funcoes.CompletaOuRepete('',FormatCurr('#,###,###0.000',dm.IBQuery2.fieldbyname('quant').AsCurrency)+'|',' ',7)+funcoes.CompletaOuRepete(copy(dm.ibquery1.fieldbyname('nome').AsString,1,27),'|',' ',28)+funcoes.CompletaOuRepete('',FormatCurr('#,###,###0.00',dm.ibquery1.fieldbyname('p_venda').AsCurrency)+'|',' ',9)+funcoes.CompletaOuRepete('',FormatCurr('#,###,###0.00',dm.IBQuery2.fieldbyname('total').AsCurrency)+'|',' ',10)+funcoes.CompletaOuRepete(copy(dm.IBQuery1.fieldbyname('refori').AsString,1,13),'|',' ',13)+funcoes.CompletaOuRepete(copy(dm.IBQuery1.fieldbyname('localiza').AsString,1,13),'|',' ',14)+#13+#10))));
        dm.IBQuery2.Next;
      end;
     dm.IBQuery1.Close;

     if form19.RichEdit1.Lines.Count < 50 then
      begin
        for i := form19.RichEdit1.Lines.Count to 50 do
         begin
           form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar(('|'+funcoes.CompletaOuRepete('','|',' ',9)+funcoes.CompletaOuRepete('','|',' ',8)+funcoes.CompletaOuRepete('','|',' ',7)+funcoes.CompletaOuRepete('','|',' ',28)+funcoes.CompletaOuRepete('','|',' ',9)+funcoes.CompletaOuRepete('','|',' ',10)+funcoes.CompletaOuRepete('','|',' ',13)+funcoes.CompletaOuRepete('','|',' ',14)+#13+#10))));
         end;
      end;
     form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((#18+#13+#10))));
     form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('+','+','-',80)+#13+#10))));
     form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('|',funcoes.CompletaOuRepete('Sub-Total:',FormatCurr('#,###,###0.00',total),'.',28)+' |',' ',80)+#13+#10))));
     form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('|',funcoes.CompletaOuRepete('Desconto('+FormatCurr('#,###,###0.00',(dm.IBselect.fieldbyname('desconto').AsCurrency * 100)/ total)+'%):',FormatCurr('#,###,###0.00',dm.IBselect.fieldbyname('desconto').AsCurrency),'.',28)+' |',' ',80)+#13+#10))));
     form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('| Volumes: '+funcoes.CompletaOuRepete('',FormatCurr('#,###,###0.00',sub),' ',9),funcoes.CompletaOuRepete('Sub-Total:',FormatCurr('#,###,###0.00',dm.IBselect.fieldbyname('total').AsCurrency),'.',28)+' |',' ',80)+#13+#10))));
     form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('+','+','-',80)+#13+#10))));
     form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar(('| Vendedor: '+funcoes.CompletaOuRepete(copy(dm.IBselect.fieldbyname('vendedor').AsString+'-'+BuscaNomeBD(dm.ibquery1,'nome','vendedor','where cod='+dm.IBselect.fieldbyname('vendedor').AsString),1,16),'|',' ',17)+CompletaOuRepete('Recebido Por: ','|',' ',51)+#13+#10))));
     form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar(('| Vencimento: '+CompletaOuRepete(FormatDateTime('DD/MM/YY',dm.IBselect.fieldbyname('data').AsDateTime),'|',' ',15)+CompletaOuRepete('','|',' ',51)+#13+#10))));
     form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('+','+','-',80)+#13+#10))));
     if EnviarImpressora = 'S' then
       begin
        imprime.textx('texto.txt');
       end
      else form19.ShowModal;
    end;


   if tipo='A' then
    begin
     total := 0;
     dm.IBQuery2.Close;
     dm.IBQuery2.SQL.Clear;
     dm.IBQuery2.SQL.Add('select * from registro');
     dm.IBQuery2.Open;

     form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('+','+','-',80)+#13+#10))));
     form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('| PEDIDO Nr:'+dm.IBselect.fieldbyname('nota').AsString+'     PAGTO: '+dm.IBselect.fieldbyname('codhis').AsString+'-'+(BuscaNomeBD(dm.ibquery1,'nome','formpagto','where cod='+dm.IBselect.fieldbyname('codhis').AsString)),'EMISSAO: '+dm.IBselect.fieldbyname('data').AsString+' |',' ',80)+#13+#10))));
     form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('+','+','-',80)+#13+#10))));
     form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('| '+form22.Pgerais.Values['empresa'],'CNPJ: '+dm.IBQuery2.fieldbyname('cnpj').AsString+' |',' ',80)+#13+#10))));
     form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('| '+dm.IBQuery2.fieldbyname('ende').AsString+'  - '+dm.IBQuery2.fieldbyname('bairro').AsString,'|',' ',80)+#13+#10))));
     form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('| Fone: '+dm.IBQuery2.fieldbyname('telres').AsString+'  Fax: '+dm.IBQuery2.fieldbyname('telcom').AsString+ '  '+ dm.IBQuery2.fieldbyname('cid').AsString+' - '+dm.IBQuery2.fieldbyname('est').AsString,'IE: '+dm.IBQuery2.fieldbyname('ies').AsString+' |',' ',80)+#13+#10))));
     form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('| Obs: '+dm.IBQuery2.FieldByName('obs').AsString,'|',' ',80)+#13+#10))));
     form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('+','+','-',80)+#13+#10))));
     form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('| Nome: '+funcoes.CompletaOuRepete(funcoes.BuscaNomeBD(dm.ibquery1,'nome','cliente','where cod='+dm.IBselect.fieldbyname('cliente').AsString),'|',' ',41),'CPF/CNPJ: '+funcoes.BuscaNomeBD(dm.ibquery1,'cnpj','cliente','where cod='+dm.IBselect.fieldbyname('cliente').AsString)+' |',' ',80)+#13+#10))));
     form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('+','+','-',80)+#13+#10))));
     test := 1;
     form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((#15+#13+#10))));
     form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar(('| Codigo | Cod. Barras |Unid. | Qtd. | Descricao das Mercadorias |Desconto |Unitario |   Total   |'+#13+#10))));
     form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar(('+--------+-------------+------+------+---------------------------+---------+---------+-----------+'+#13+#10))));

     dm.IBQuery2.Close;
     dm.IBQuery2.SQL.Clear;
     dm.IBQuery2.SQL.Add('select * from item_venda where nota='+numNota);
     dm.IBQuery2.Open;
     dm.IBQuery2.First;
     sub := 0;
     total := 0;
     while not dm.IBQuery2.Eof do
      begin
        dm.IBQuery1.Close;
        dm.IBQuery1.SQL.Clear;
        dm.IBQuery1.SQL.Add('select * from produto where cod='+dm.IBQuery2.fieldbyname('cod').AsString);
        dm.IBQuery1.Open;
        total := total + dm.IBQuery2.fieldbyname('total').AsCurrency;
        sub := sub + dm.IBQuery2.fieldbyname('quant').AsCurrency;
        form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar(('|'+funcoes.CompletaOuRepete('',dm.IBQuery2.fieldbyname('cod').AsString+'|',' ',9)+funcoes.CompletaOuRepete('',dm.ibquery1.fieldbyname('codbar').AsString+'|',' ',14)+funcoes.CompletaOuRepete('',dm.ibquery1.fieldbyname('unid').AsString+'|',' ',7)+funcoes.CompletaOuRepete('',FormatCurr('#,###,###0.000',dm.IBQuery2.fieldbyname('quant').AsCurrency)+'|',' ',7)+funcoes.CompletaOuRepete(copy(dm.ibquery1.fieldbyname('nome').AsString,1,27),'|',' ',28)+funcoes.CompletaOuRepete('',FormatCurr('#,###,###0.00',0)+'|',' ',10)+funcoes.CompletaOuRepete('',FormatCurr('#,###,###0.00',dm.ibquery1.fieldbyname('p_venda').AsCurrency)+'|',' ',10)+funcoes.CompletaOuRepete('',FormatCurr('#,###,###0.00',dm.IBQuery2.fieldbyname('total').AsCurrency)+'|',' ',12)+#13+#10))));
        dm.IBQuery2.Next;
      end;
     dm.IBQuery1.Close;

     if form19.RichEdit1.Lines.Count < 50 then
      begin
        for i := form19.RichEdit1.Lines.Count to 50 do
         begin
           form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar(('|'+funcoes.CompletaOuRepete('','|',' ',9)+funcoes.CompletaOuRepete('','|',' ',14)+funcoes.CompletaOuRepete('','|',' ',7)+funcoes.CompletaOuRepete('','|',' ',7)+funcoes.CompletaOuRepete('','|',' ',28)+funcoes.CompletaOuRepete('','|',' ',10)+funcoes.CompletaOuRepete('','|',' ',10)+funcoes.CompletaOuRepete('','|',' ',12)+#13+#10))));
         end;
      end;
     form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((#18+#13+#10))));
     form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('+','+','-',80)+#13+#10))));
     form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('|',funcoes.CompletaOuRepete('Sub-Total:',FormatCurr('#,###,###0.00',total),'.',28)+' |',' ',80)+#13+#10))));
     form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('|',funcoes.CompletaOuRepete('Desconto('+FormatCurr('#,###,###0.00',(dm.IBselect.fieldbyname('desconto').AsCurrency * 100)/ total)+'%):',FormatCurr('#,###,###0.00',dm.IBselect.fieldbyname('desconto').AsCurrency),'.',28)+' |',' ',80)+#13+#10))));
     form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('| Volumes: '+funcoes.CompletaOuRepete('',FormatCurr('#,###,###0.00',sub),' ',9),funcoes.CompletaOuRepete('Sub-Total:',FormatCurr('#,###,###0.00',dm.IBselect.fieldbyname('total').AsCurrency),'.',28)+' |',' ',80)+#13+#10))));
     form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('+','+','-',80)+#13+#10))));
     form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar(('| Vendedor: '+funcoes.CompletaOuRepete(copy(dm.IBselect.fieldbyname('vendedor').AsString+'-'+BuscaNomeBD(dm.ibquery1,'nome','vendedor','where cod='+dm.IBselect.fieldbyname('vendedor').AsString),1,16),'|',' ',17)+CompletaOuRepete('Recebido Por: ','|',' ',51)+#13+#10))));
     form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar(('| Vencimento: '+CompletaOuRepete(FormatDateTime('DD/MM/YY',dm.IBselect.fieldbyname('data').AsDateTime),'|',' ',15)+CompletaOuRepete('','|',' ',51)+#13+#10))));
     form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('+','+','-',80)+#13+#10))));

    if EnviarImpressora = 'S' then
       begin
        imprime.textx('texto.txt');
       end
      else form19.ShowModal;

    end;

   if tipo='G' then
    begin
     total := 0;
     dm.IBQuery2.Close;
     dm.IBQuery2.SQL.Clear;
     dm.IBQuery2.SQL.Add('select * from registro');
     dm.IBQuery2.Open;
     form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('+','+','-',80)+#13+#10))));
     form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('| PEDIDO Nr:'+dm.IBselect.fieldbyname('nota').AsString+'     PAGTO: '+dm.IBselect.fieldbyname('codhis').AsString+'-'+(BuscaNomeBD(dm.ibquery1,'nome','formpagto','where cod='+dm.IBselect.fieldbyname('codhis').AsString)),'EMISSAO: '+dm.IBselect.fieldbyname('data').AsString+' |',' ',80)+#13+#10))));
     form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('+','+','-',80)+#13+#10))));
     form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('| '+form22.Pgerais.Values['empresa'],'CNPJ: '+dm.IBQuery2.fieldbyname('cnpj').AsString+' |',' ',80)+#13+#10))));
     form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('| '+dm.IBQuery2.fieldbyname('ende').AsString+'  - '+dm.IBQuery2.fieldbyname('bairro').AsString,'|',' ',80)+#13+#10))));
     form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('| Fone: '+dm.IBQuery2.fieldbyname('telres').AsString+'  Fax: '+dm.IBQuery2.fieldbyname('telcom').AsString+ '  '+ dm.IBQuery2.fieldbyname('cid').AsString+' - '+dm.IBQuery2.fieldbyname('est').AsString,'IE: '+dm.IBQuery2.fieldbyname('ies').AsString+' |',' ',80)+#13+#10))));
     form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('| Obs: '+dm.IBQuery2.FieldByName('obs').AsString,'|',' ',80)+#13+#10))));
     form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('+','+','-',80)+#13+#10))));
     form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('| Nome: '+funcoes.CompletaOuRepete(funcoes.BuscaNomeBD(dm.ibquery1,'nome','cliente','where cod='+dm.IBselect.fieldbyname('cliente').AsString),'|',' ',41),'CPF/CNPJ: '+funcoes.BuscaNomeBD(dm.ibquery1,'cnpj','cliente','where cod='+dm.IBselect.fieldbyname('cliente').AsString)+' |',' ',80)+#13+#10))));
     form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('+','+','-',80)+#13+#10))));
     form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar(('|Codigo| Unid |  Qtd. |    Descricao das Mercadorias     |Unitario|    Total   |'+#13+#10))));
     form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar(('+------+------+-------+----------------------------------+--------+------------+'+#13+#10))));

     dm.IBQuery2.Close;
     dm.IBQuery2.SQL.Clear;
     dm.IBQuery2.SQL.Add('select * from item_venda where nota='+numNota);
     dm.IBQuery2.Open;
     dm.IBQuery2.First;
     sub := 0;
     total := 0;
     while not dm.IBQuery2.Eof do
      begin
        dm.IBQuery1.Close;
        dm.IBQuery1.SQL.Clear;
        dm.IBQuery1.SQL.Add('select * from produto where cod='+dm.IBQuery2.fieldbyname('cod').AsString);
        dm.IBQuery1.Open;
        total := total + dm.IBQuery2.fieldbyname('total').AsCurrency;
        sub := sub + dm.IBQuery2.fieldbyname('quant').AsCurrency;
        form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar(('|'+funcoes.CompletaOuRepete('',dm.IBQuery2.fieldbyname('cod').AsString+'|',' ',7)+funcoes.CompletaOuRepete('',dm.ibquery1.fieldbyname('unid').AsString+'|',' ',7)+funcoes.CompletaOuRepete('',FormatCurr('#,###,###0.000',dm.IBQuery2.fieldbyname('quant').AsCurrency)+'|',' ',8)+funcoes.CompletaOuRepete(copy(dm.ibquery1.fieldbyname('nome').AsString,1,34),'|',' ',35)+funcoes.CompletaOuRepete('',FormatCurr('#,###,###0.00',dm.ibquery1.fieldbyname('p_venda').AsCurrency)+'|',' ',9)+funcoes.CompletaOuRepete('',FormatCurr('#,###,###0.00',dm.IBQuery2.fieldbyname('total').AsCurrency)+'|',' ',13)+#13+#10))));
        dm.IBQuery2.Next;
      end;
     dm.IBQuery1.Close;

     if form19.RichEdit1.Lines.Count < 50 then
      begin
        for i := form19.RichEdit1.Lines.Count to 50 do
         begin
           form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar(('|'+funcoes.CompletaOuRepete('','|',' ',7)+funcoes.CompletaOuRepete('','|',' ',7)+funcoes.CompletaOuRepete('','|',' ',8)+funcoes.CompletaOuRepete('','|',' ',35)+funcoes.CompletaOuRepete('','|',' ',9)+funcoes.CompletaOuRepete('','|',' ',13)+#13+#10))));
         end;
      end;


     form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('+','+','-',80)+#13+#10))));
     form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('|',funcoes.CompletaOuRepete('Sub-Total:',FormatCurr('#,###,###0.00',total),'.',28)+' |',' ',80)+#13+#10))));
     form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('|',funcoes.CompletaOuRepete('Desconto('+FormatCurr('#,###,###0.00',(dm.IBselect.fieldbyname('desconto').AsCurrency * 100)/ total)+'%):',FormatCurr('#,###,###0.00',dm.IBselect.fieldbyname('desconto').AsCurrency),'.',28)+' |',' ',80)+#13+#10))));
     form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('| Volumes: '+funcoes.CompletaOuRepete('',FormatCurr('#,###,###0.00',sub),' ',9),funcoes.CompletaOuRepete('Sub-Total:',FormatCurr('#,###,###0.00',dm.IBselect.fieldbyname('total').AsCurrency),'.',28)+' |',' ',80)+#13+#10))));
     form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('+','+','-',80)+#13+#10))));
     form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar(('| Vendedor: '+funcoes.CompletaOuRepete(copy(dm.IBselect.fieldbyname('vendedor').AsString+'-'+BuscaNomeBD(dm.ibquery1,'nome','vendedor','where cod='+dm.IBselect.fieldbyname('vendedor').AsString),1,16),'|',' ',17)+CompletaOuRepete('Recebido Por: ','|',' ',51)+#13+#10))));
     form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar(('| Vencimento: '+CompletaOuRepete(FormatDateTime('DD/MM/YY',dm.IBselect.fieldbyname('data').AsDateTime),'|',' ',15)+CompletaOuRepete('','|',' ',51)+#13+#10))));
     form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('+','+','-',80)+#13+#10))));

     if EnviarImpressora = 'S' then
       begin
        imprime.textx('texto.txt');
       end
      else form19.ShowModal;
    end;

   if tipo='M' then
   begin
     total := 0;
     dm.IBQuery2.Close;
     dm.IBQuery2.SQL.Clear;
     dm.IBQuery2.SQL.Add('select * from registro');
     dm.IBQuery2.Open;

     form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('+','+','-',80)+#13+#10))));

     if Venda then  form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('| PEDIDO Nr:'+dm.IBselect.fieldbyname('nota').AsString+'     PAGTO: '+dm.IBselect.fieldbyname('codhis').AsString+'-'+(BuscaNomeBD(dm.ibquery1,'nome','formpagto','where cod='+dm.IBselect.fieldbyname('codhis').AsString)),'EMISSAO: '+dm.IBselect.fieldbyname('data').AsString+' |',' ',80)+#13+#10))))
       else form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('| ORCAMENTO Nr:'+dm.IBselect.fieldbyname('nota').AsString+'     PAGTO: '+dm.IBselect.fieldbyname('codhis').AsString+'-'+(BuscaNomeBD(dm.ibquery1,'nome','formpagto','where cod='+dm.IBselect.fieldbyname('codhis').AsString)),'EMISSAO: '+dm.IBselect.fieldbyname('data').AsString+' |',' ',80)+#13+#10))));

     form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('+','+','-',80)+#13+#10))));
     form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('| '+form22.Pgerais.Values['empresa'],'CNPJ: '+dm.IBQuery2.fieldbyname('cnpj').AsString+' |',' ',80)+#13+#10))));
     form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('| '+dm.IBQuery2.fieldbyname('ende').AsString+'  - '+dm.IBQuery2.fieldbyname('bairro').AsString,'|',' ',80)+#13+#10))));
     form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('| Fone: '+dm.IBQuery2.fieldbyname('telres').AsString+'  Fax: '+dm.IBQuery2.fieldbyname('telcom').AsString+ '  '+ dm.IBQuery2.fieldbyname('cid').AsString+' - '+dm.IBQuery2.fieldbyname('est').AsString,'IE: '+dm.IBQuery2.fieldbyname('ies').AsString+' |',' ',80)+#13+#10))));
     form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('| Obs: '+dm.IBQuery2.FieldByName('obs').AsString,'|',' ',80)+#13+#10))));
     form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('+','+','-',80)+#13+#10))));
     form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('| Nome: '+funcoes.CompletaOuRepete(funcoes.BuscaNomeBD(dm.ibquery1,'nome','cliente','where cod='+dm.IBselect.fieldbyname('cliente').AsString),'|',' ',41),'CPF/CNPJ: '+funcoes.BuscaNomeBD(dm.ibquery1,'cnpj','cliente','where cod='+dm.IBselect.fieldbyname('cliente').AsString)+' |',' ',80)+#13+#10))));
     form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('+','+','-',80)+#13+#10))));
     form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar(('|Codigo| Unid |  Qtd. |    Descricao das Mercadorias     |Unitario|    Total   |'+#13+#10))));
     form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar(('+------+------+-------+----------------------------------+--------+------------+'+#13+#10))));

     dm.IBQuery2.Close;
     dm.IBQuery2.SQL.Clear;
     if Venda then dm.IBQuery2.SQL.Add('select * from item_venda where nota='+numNota)
       else dm.IBQuery2.SQL.Add('select * from item_orcamento where nota='+numNota);
     dm.IBQuery2.Open;
     dm.IBQuery2.First;
     sub := 0;
     total := 0;
     while not dm.IBQuery2.Eof do
      begin
        dm.IBQuery1.Close;
        dm.IBQuery1.SQL.Clear;
        dm.IBQuery1.SQL.Add('select * from produto where cod='+dm.IBQuery2.fieldbyname('cod').AsString);
        dm.IBQuery1.Open;
        sub := sub + dm.IBQuery2.fieldbyname('quant').AsCurrency;
        if venda then
          begin
            form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar(('|'+funcoes.CompletaOuRepete('',dm.IBQuery2.fieldbyname('cod').AsString+'|',' ',7)+funcoes.CompletaOuRepete('',dm.ibquery1.fieldbyname('unid').AsString+'|',' ',7)+funcoes.CompletaOuRepete('',FormatCurr('#,###,###0.000',dm.IBQuery2.fieldbyname('quant').AsCurrency)+'|',' ',8)+funcoes.CompletaOuRepete(copy(dm.ibquery1.fieldbyname('nome').AsString,1,34),'|',' ',35)+funcoes.CompletaOuRepete('',FormatCurr('#,###,###0.00',dm.ibquery1.fieldbyname('p_venda').AsCurrency)+'|',' ',9)+funcoes.CompletaOuRepete('',FormatCurr('#,###,###0.00',dm.IBQuery2.fieldbyname('total').AsCurrency)+'|',' ',13)+#13+#10))));
            total := total + dm.IBQuery2.fieldbyname('total').AsCurrency;
          end
          else
            begin
              form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar(('|'+funcoes.CompletaOuRepete('',dm.IBQuery2.fieldbyname('cod').AsString+'|',' ',7)+funcoes.CompletaOuRepete('',dm.ibquery1.fieldbyname('unid').AsString+'|',' ',7)+funcoes.CompletaOuRepete('',FormatCurr('#,###,###0.000',dm.IBQuery2.fieldbyname('quant').AsCurrency)+'|',' ',8)+funcoes.CompletaOuRepete(copy(dm.ibquery1.fieldbyname('nome').AsString,1,34),'|',' ',35)+funcoes.CompletaOuRepete('',FormatCurr('#,###,###0.00',dm.ibquery1.fieldbyname('p_venda').AsCurrency)+'|',' ',9)+funcoes.CompletaOuRepete('',FormatCurr('#,###,###0.00',Arredonda(dm.ibquery1.fieldbyname('p_venda').AsCurrency * dm.IBQuery2.fieldbyname('quant').AsCurrency,2 ))+'|',' ',13)+#13+#10))));
              total := total + Arredonda(dm.ibquery1.fieldbyname('p_venda').AsCurrency * dm.IBQuery2.fieldbyname('quant').AsCurrency,2 );
            end;
        dm.IBQuery2.Next;
      end;
     dm.IBQuery1.Close;
     if funcoes.ExisteParcelamento(numNota) and Venda then
       begin
         form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar(('|      |      |       |                                  |        |            |'))));
         funcoes.ImprimeParcelamento('|      |      |       |    ','    |        |            |',FormatCurr('#,###,###0.00',entrada),numNota);
       end;
     form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('+','+','-',80)+#13+#10))));
     form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('|',funcoes.CompletaOuRepete('Sub-Total:',FormatCurr('#,###,###0.00',total),'.',28)+' |',' ',80)+#13+#10))));
     form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('|',funcoes.CompletaOuRepete('Desconto('+FormatCurr('#,###,###0.00',(dm.IBselect.fieldbyname('desconto').AsCurrency * 100)/ total)+'%):',FormatCurr('#,###,###0.00',dm.IBselect.fieldbyname('desconto').AsCurrency),'.',28)+' |',' ',80)+#13+#10))));
     if Venda then form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('| Volumes: '+funcoes.CompletaOuRepete('',FormatCurr('#,###,###0.00',sub),' ',9),funcoes.CompletaOuRepete('Total:',FormatCurr('#,###,###0.00',dm.IBselect.fieldbyname('total').AsCurrency),'.',28)+' |',' ',80)+#13+#10))))
       else form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('| Volumes: '+funcoes.CompletaOuRepete('',FormatCurr('#,###,###0.00',sub),' ',9),funcoes.CompletaOuRepete('Total:',FormatCurr('#,###,###0.00',total),'.',28)+' |',' ',80)+#13+#10))));
     form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('+','+','-',80)+#13+#10))));
     form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar(('| Vendedor: '+funcoes.CompletaOuRepete(copy(dm.IBselect.fieldbyname('vendedor').AsString+'-'+BuscaNomeBD(dm.ibquery1,'nome','vendedor','where cod='+dm.IBselect.fieldbyname('vendedor').AsString),1,16),'|',' ',17)+CompletaOuRepete('Recebido Por: ','|',' ',51)+#13+#10))));
     form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar(('| Vencimento: '+CompletaOuRepete(FormatDateTime('DD/MM/YY',dm.IBselect.fieldbyname('data').AsDateTime),'|',' ',15)+CompletaOuRepete('','|',' ',51)+#13+#10))));
     form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('+','+','-',80)+#13+#10))));

   if EnviarImpressora = 'S' then
       begin
        imprime.textx('texto.txt');
       end
      else form19.ShowModal;
 end;
   //se tipo da nota for T(ticket)
  if tipo='T' then
   begin
     total := 0;
     dm.IBQuery2.Close;
     dm.IBQuery2.SQL.Clear;
     dm.IBQuery2.SQL.Add('select * from registro');
     dm.IBQuery2.Open;

     form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('','','-',40)+#13+#10))));
     form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.centraliza(form22.Pgerais.Values['empresa'],' ',40)+#13+#10))));
     form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('','','-',40)+#13+#10))));
     form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('','',' ',40)+#13+#10))));
     form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.centraliza(dm.IBQuery2.fieldbyname('ende').AsString+' - '+copy(dm.IBQuery2.fieldbyname('bairro').AsString,1,37-length(dm.IBQuery2.fieldbyname('ende').AsString)),' ',40)+#13+#10))));
     form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.centraliza('FONE: '+dm.IBQuery2.fieldbyname('telres').AsString+'  '+'FAX: '+dm.IBQuery2.fieldbyname('telcom').AsString  ,' ',40)+#13+#10))));
     form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('','','-',40)+#13+#10))));
     form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('DATA: '+dm.IBselect.fieldbyname('data').AsString,'HORA: '+dm.IBselect.fieldbyname('hora').AsString,' ',40)+#13+#10))));
     form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('NOTA: '+dm.IBselect.fieldbyname('nota').AsString,'',' ',13)+'  '+'VENDEDOR: '+funcoes.CompletaOuRepete(dm.IBselect.fieldbyname('vendedor').AsString+'-'+copy(BuscaNomeBD(dm.ibquery1,'nome','vendedor','where cod='+dm.IBselect.fieldbyname('vendedor').AsString),1,25),'',' ',27)+#13+#10))));
     form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete(dm.IBselect.fieldbyname('cliente').AsString+'-'+copy(BuscaNomeBD(dm.ibquery1,'nome','cliente','where cod='+dm.IBselect.fieldbyname('cliente').AsString),1,39-length(dm.IBselect.fieldbyname('cliente').AsString)),'',' ',40)+#13+#10))));
     form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('FORMA PAGTO: '+dm.IBselect.fieldbyname('codhis').AsString+'-'+copy(BuscaNomeBD(dm.ibquery1,'nome','formpagto','where cod='+dm.IBselect.fieldbyname('codhis').AsString),1,39-length(dm.IBselect.fieldbyname('codhis').AsString)),'',' ',40)+#13+#10))));
     form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('','','-',40)+#13+#10))));
     dm.IBQuery2.Close;
     dm.IBQuery2.SQL.Clear;
     dm.IBQuery2.SQL.Add('select * from item_venda where nota='+numNota);
     dm.IBQuery2.Open;
     dm.IBQuery2.First;
     while not dm.IBQuery2.Eof do
      begin
        total := total + dm.IBQuery2.fieldbyname('total').AsCurrency;
        form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete(dm.IBQuery2.fieldbyname('codbar').AsString+'-'+copy(BuscaNomeBD(dm.ibquery1,'nome','produto','where cod='+dm.IBQuery2.fieldbyname('cod').AsString),1,37-length(dm.IBQuery2.fieldbyname('codbar').AsString)),'',' ',40)+#13+#10))));
        form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('=>QTD:',FormatCurr('#,###,###0.000',dm.IBQuery2.fieldbyname('quant').AsCurrency),' ',13)+funcoes.CompletaOuRepete('R$',FormatCurr('#,###,###0.00',dm.IBQuery2.fieldbyname('p_venda').AsCurrency),' ',13)+funcoes.CompletaOuRepete('R$',FormatCurr('#,###,###0.00',dm.IBQuery2.fieldbyname('total').AsCurrency),' ',14)+#13+#10))));
        dm.IBQuery2.Next;
      end;
     if total <> dm.IBselect.fieldbyname('total').AsCurrency then
     begin
      form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar(('DESCONTO('+FormatCurr('#,###,###0.00',(dm.IBselect.fieldbyname('desconto').AsCurrency * 100)/ total)+'%) ---------->'+funcoes.CompletaOuRepete('',
      FormatCurr('#,###,###0.00',dm.IBselect.fieldbyname('desconto').AsCurrency),' ',11)+#13+#10))));
     end;
     form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('','','-',40)+#13+#10))));
     form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('TOTAL:. . . . . .',FormatCurr('#,##,###0.00',dm.IBselect.fieldbyname('total').AsCurrency),' ',40)+#13+#10))));
     form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('','','-',40)+#13+#10))));
     form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar(('* * *   NAO  TEM  VALOR  FISCAL    * * *'+#13+#10))));
     form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((' '+#13+#10))));
     funcoes.ImprimeParcelamento('','',FormatCurr('#,###,###0.00',entrada),numNota);
     dm.IBselect.Close;
     dm.IBQuery2.Close;
     dm.IBQuery1.Close;
     if EnviarImpressora = 'S' then
       begin
        imprime.textx('texto.txt');
       end
      else form19.ShowModal;

   end;
   //form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar(()));
     dm.IBselect.Close;
     dm.IBQuery2.Close;
     dm.IBQuery1.Close;
 end;
function tfuncoes.lista(var t: TObject) : string;
var pRect:TRect;
begin
 // ShowMessage(IntToStr(form39.ListBox1.Width)+'   form='+IntToStr(form39.Width));
  //form39.ListBox1.
  //Form39.Width := Form39.ListBox1.Width +40;
  GetWindowRect(tedit(t).Handle,pRect);
  pRect.Top := pRect.Top + 25;
 // form39.Left := tedit(tedit(t).Owner).Left + tedit(t).Left;
 // form39.Top := tedit(tedit(t).Owner).Top +  tedit(t).Top +25;
  form39.Top := pRect.Top;
  form39.Left := pRect.Left;
  form39.AutoSize := false;
  form39.Height := form39.ListBox1.Items.Count * 20;
  form39.Width := length(RetornaMaiorTstrings(form39.ListBox1.Items)) * form39.ListBox1.Font.Size;
  //ShowMessage(IntToStr(form39.ListBox1.Items.Count));
  //form39.ScreenToClient(pRect);
  form39.ShowModal;
  form39.Free;
  result := Trim(lista1);
end;


function tfuncoes.Parcelamento(Total : currency; Cliente : string; prazo : string) : TstringList;
begin
   form38 := tform38.Create(self);
   form38.total := Total;
   form38.vencto.Text := DateToStr(form22.datamov + strtoint(prazo));
   form38.dias.Text := '30';
   form38.qtd.Text := '1';
   form38.ShowModal;
   form38.Free;
   result := Reparcelamento;
end;

function tfuncoes.DeletaChar(sub:string;texto:string):string;
var i:integer;
begin
  Result :='';
  for i:=1 to length(texto) do
   begin
    //ShowMessage(texto[i]);
    if sub<>texto[i] then Result := Result + texto[i];
   end;
end;

function tfuncoes.VerAcesso(param:string) : string;
var i,a,posi :integer;
begin
  //ShowMessage(IntToStr(length(form22.Pgerais.Values['acesso'])));
  for i := 0 to form2.MainMenu1.Items.Count -1 do
   begin
     posi := pos('-'+IntToStr(i)+'-',form22.Pgerais.Values['acesso']) + 3;
     for a := 0 to form2.MainMenu1.Items.Items[i].Count -1 do
      begin
       // ShowMessage(IntToStr(i)+'  -  '+IntToStr(a)+'    '+form22.Pgerais.Values['acesso'][posi+a]);
       // if form22.Pgerais.Values['acesso'][posi+a]  = '-' then Insert(' ',form22.Pgerais.Values['acesso'],posi+a);
        try
        if form22.Pgerais.Values['acesso'][posi+a] <> ' ' then
          begin
            if funcoes.Contido(IntToStr(i),form22.Pgerais.Values['acessousu']) then
             begin
              // ShowMessage(IntToStr(i)+'  Contido '+funcoes.LerValorPGerais('acessousu',form22.Pgerais));
               form2.MainMenu1.Items.Items[i].Items[a].Visible := false;
             end
            else if length(form22.Pgerais.Values['acessousu']) > StrToInt(form22.Pgerais.Values['acesso'][posi+a]) then
             begin
              //ShowMessage(IntToStr(length(funcoes.LerValorPGerais('acessousu',form22.Pgerais))));
              form2.MainMenu1.Items.Items[i].Items[a].Visible :=false;
             end;
            if param = '0' then form2.MainMenu1.Items.Items[i].Items[a].Visible := true;
          end;
         except
             ShowMessage('menu='+IntToStr(i)+'  sub='+IntToStr(a)+'  char='+form22.Pgerais.Values['acesso'][posi+a]);
             //ShowMessage(form22.Pgerais.Values['acesso'][posi+a]);
            end;

         //else form2.MainMenu1.Items.Items[i].Items[a].Enabled := true;
      end;
   end;
end;

function tfuncoes.GeraAleatorio(valor:integer):string;
var acc:string;
i:integer;
begin
 Randomize;
 acc:='';
 for i:=1 to valor do
  begin
   if length(acc)<valor then acc:=acc+IntToStr(random(99));
   if length(acc)>valor then Delete(acc,length(acc)-1,length(acc));
  end;
 Result := acc;
end;

function tfuncoes.centraliza(valor:string;repetir:string;tamanho:integer):string;
var i,cont,ch:integer;
acc:string;
begin
  acc:='';
  cont:=1;
  ch := tamanho-length(valor);
  for i:= 1 to ch do
  begin
    acc := acc + repetir;
    if (i>=ch/2) and (cont=1)  then
     begin
      cont:=2;
      acc := acc+valor;
     end;
  end;
  if length(acc)=tamanho then result:=acc
  else
   begin
      for i:= length(acc) to tamanho do
       begin
        acc := acc + repetir;
       end;
      result:=acc ;
   end;
end;

function tfuncoes.valorPorExtenso(vlr: real): string;
const
  unidade: array[1..19] of string = ('um', 'dois', 'tres', 'quatro', 'cinco',
             'seis', 'sete', 'oito', 'nove', 'dez', 'onze',
             'doze', 'treze', 'quatorze', 'quinze', 'dezesseis',
             'dezessete', 'dezoito', 'dezenove');
  centena: array[1..9] of string = ('cento', 'duzentos', 'trezentos',
             'quatrocentos', 'quinhentos', 'seiscentos',
             'setecentos', 'oitocentos', 'novecentos');
  dezena: array[2..9] of string = ('vinte', 'trinta', 'quarenta', 'cinquenta',
             'sessenta', 'setenta', 'oitenta', 'noventa');
  qualificaS: array[0..4] of string = ('', 'mil', 'milhao', 'bilhao', 'trilhao');
  qualificaP: array[0..4] of string = ('', 'mil', 'milhoes', 'bilhoes', 'trilhoes');
var
                        inteiro: Int64;
                          resto: real;
  vlrS, s, saux, vlrP, centavos: string;
     n, unid, dez, cent, tam, i: integer;
                    umReal, tem: boolean;
begin
  if (vlr = 0)
     then begin
            valorPorExtenso := 'zero';
            exit;
          end;

  inteiro := trunc(vlr); // parte inteira do valor
  resto := vlr - inteiro; // parte fracionária do valor
  vlrS := inttostr(inteiro);
  if (length(vlrS) > 15)
     then begin
            valorPorExtenso := 'Erro: valor superior a 999 trilhões.';
            exit;
          end;

  s := '';
  centavos := inttostr(round(resto * 100));

// definindo o extenso da parte inteira do valor
  i := 0;
  umReal := false; tem := false;
  while (vlrS <> '0') do
  begin
    tam := length(vlrS);
// retira do valor a 1a. parte, 2a. parte, por exemplo, para 123456789:
// 1a. parte = 789 (centena)
// 2a. parte = 456 (mil)
// 3a. parte = 123 (milhões)
    if (tam > 3)
       then begin
              vlrP := copy(vlrS, tam-2, tam);
              vlrS := copy(vlrS, 1, tam-3);
            end
    else begin // última parte do valor
           vlrP := vlrS;
           vlrS := '0';
         end;
    if (vlrP <> '000')
       then begin
              saux := '';
              if (vlrP = '100')
                 then saux := 'cem'
              else begin
                     n := strtoint(vlrP);        // para n = 371, tem-se:
                     cent := n div 100;          // cent = 3 (centena trezentos)
                     dez := (n mod 100) div 10;  // dez  = 7 (dezena setenta)
                     unid := (n mod 100) mod 10; // unid = 1 (unidade um)
                     if (cent <> 0)
                        then saux := centena[cent];
                     if ((dez <> 0) or (unid <> 0))
                        then begin
                               if ((n mod 100) <= 19)
                                  then begin
                                         if (length(saux) <> 0)
                                            then saux := saux + ' e ' + unidade[n mod 100]
                                         else saux := unidade[n mod 100];
                                       end
                               else begin
                                      if (length(saux) <> 0)
                                         then saux := saux + ' e ' + dezena[dez]
                                      else saux := dezena[dez];
                                      if (unid <> 0)
                                         then if (length(saux) <> 0)
                                                 then saux := saux + ' e ' + unidade[unid]
                                              else saux := unidade[unid];
                                    end;
                             end;
                   end;
              if ((vlrP = '1') or (vlrP = '001'))
                 then begin
                        if (i = 0) // 1a. parte do valor (um real)
                           then umReal := true
                        else saux := saux + ' ' + qualificaS[i];
                      end
              else if (i <> 0)
                      then saux := saux + ' ' + qualificaP[i];
              if (length(s) <> 0)
                 then s := saux + ', ' + s
              else s := saux;
            end;
    if (((i = 0) or (i = 1)) and (length(s) <> 0))
       then tem := true; // tem centena ou mil no valor
    i := i + 1; // próximo qualificador: 1- mil, 2- milhão, 3- bilhão, ...
  end;

  if (length(s) <> 0)
     then begin
            if (umReal)
               then s := s + ' real'
            else if (tem)
                    then s := s + ' reais'
                 else s := s + ' de reais';
          end;
// definindo o extenso dos centavos do valor
  if (centavos <> '0') // valor com centavos
     then begin
            if (length(s) <> 0) // se não é valor somente com centavos
               then s := s + ' e ';
            if (centavos = '1')
               then s := s + 'um centavo'
            else begin
                   n := strtoint(centavos);
                   if (n <= 19)
                      then s := s + unidade[n]
                   else begin                 // para n = 37, tem-se:
                          unid := n mod 10;   // unid = 37 % 10 = 7 (unidade sete)
                          dez := n div 10;    // dez  = 37 / 10 = 3 (dezena trinta)
                          s := s + dezena[dez];
                          if (unid <> 0)
                             then s := s + ' e ' + unidade[unid];
                       end;
                   s := s + ' centavos';
                 end;
          end;
  valorPorExtenso := s;
end;

function tfuncoes.SomaCampoDBGRID(var dataset:tibquery;campo:string;dataini:TDateTime;datafim:TDateTime;dataIgual:TDateTime;NomeCampoDataParaComparar:string): currency;
var i,a,recno: integer;
begin
  result:=0;
  a:=0;

  DataSet.DisableControls;
  recno := dataset.RecNo;
  DataSet.First;
  while not DataSet.Eof do
   begin

    if (dataini <> 0) and (datafim <> 0) then
    begin
     if (StrToDate(FormatDateTime('dd/mm/yy',DataSet.FieldByName(NomeCampoDataParaComparar).AsDateTime)) >= dataini) and (DataSet.FieldByName(NomeCampoDataParaComparar).AsDateTime<=datafim) then Result := Result + DataSet.fieldbyname(campo).AsCurrency;
    end

    else if (dataini<>0) and (datafim=0) and (dataIgual=0) then
    begin
       if StrToDate(FormatDateTime('dd/mm/yy',dataini)) >= StrToDate(FormatDateTime('dd/mm/yy',DataSet.FieldByName(NomeCampoDataParaComparar).AsDateTime)) then
      begin
        Result := Result + DataSet.fieldbyname(campo).AsCurrency;
      end;
    end

   else if (dataIgual <> 0) then
    begin
      //ShowMessage(FormatDateTime('dd/mm/yy',DataSet.FieldByName(NomeCampoDataParaComparar).AsDateTime)+'<>'+FormatDateTime('dd/mm/yy',dataIgual));
      if StrToDate(FormatDateTime('dd/mm/yy',DataSet.FieldByName(NomeCampoDataParaComparar).AsDateTime)) = StrToDate(FormatDateTime('dd/mm/yy',dataIgual)) then
      begin
        Result := Result + DataSet.fieldbyname(campo).AsCurrency;
      end;
    end

   else if (dataini <> 0) and (tdate(datafim) = 0) then
    begin
     if DataSet.FieldByName(NomeCampoDataParaComparar).AsDateTime=dataIgual then Result := Result + DataSet.fieldbyname(campo).AsCurrency;
    end


   else if (dataini=0) and (datafim=0) and (dataIgual=0) then
    begin
     result := result + DataSet.fieldbyname(campo).AsCurrency;
    end;

     DataSet.Next;
   end;
   dataset.First;
   dataset.MoveBy(recno-1);
   DataSet.EnableControls;

end;


function tfuncoes.Procura_em_Multiplos_Campos(var data_set : TIBQuery;Campo_separados_por_espaco, valorParaComparar : string) : boolean;
var i:integer;
var b, acc:string;
begin
 Result := false;
 if StrToInt(ContaChar(valorParaComparar,' ')) > 0 then
 begin
  for i := 0 to StrToInt(ContaChar(valorParaComparar,' ')) do
    begin
      if StrToInt(ContaChar(valorParaComparar,' ')) > 0 then
        begin
          acc := (copy(valorParaComparar,1,pos(' ',valorParaComparar) - 1));
          valorParaComparar := copy(valorParaComparar,pos(' ',valorParaComparar) + 1,length(valorParaComparar));
        end
      else acc := valorParaComparar;

     if Contido(valorParaComparar, data_set.FieldByName(acc).AsVariant) then Result := true;
    end;
 end
 else
   begin
     if Contido(valorParaComparar, data_set.FieldByName(acc).AsVariant) then Result := true;
   end;
end;

function tfuncoes.Procura_em_Multiplos_Campos(entradaDataset:string;valorParaComarar:string) : boolean;
var i:integer;
var b,acc:string;
begin
 if StrToInt(ContaChar(valorParaComarar,' ')) > 0 then
 begin
  for i:=0 to StrToInt(ContaChar(valorParaComarar,' ')) do
    begin
      if StrToInt(ContaChar(valorParaComarar,' ')) > 0 then
        begin
          acc := (copy(valorParaComarar,1,pos(' ',valorParaComarar) - 1));
          valorParaComarar := copy(valorParaComarar,pos(' ',valorParaComarar) + 1,length(valorParaComarar));
        end
      else acc := valorParaComarar;
     if pos(acc,entradaDataset)>0 then Result:=true
       else result:=false;
    end;
 end
 else
   begin
     if Contido(valorParaComarar,entradaDataset) then result := true
      else Result:= false;
   end;
end;


function tfuncoes.busca(var dataset:tibquery;busca:string;retorno:string;campobusca:string;camposdataset:string):string;
var i:integer;
var ClientDataSet1: TClientDataSet;
begin
  ClientDataSet1 := TClientDataSet.Create(self);
  a := tibquery.Create(self);
  a.Database := dataset.Database;
  a.Transaction := dataset.Database.DefaultTransaction;
  a.SQL.Text := dataset.SQL.GetText;
  a.Params := dataset.Params;
  a.Open;
  if cont <> 1 then
  begin
    a.FetchAll;
    cont:=1;
  end;
  //form33.ClientDataSet1.ClearFields;
  for i := 0 to dataset.Fields.Count-1 do
  begin
    if camposdataset <> '' then
     begin
       if Contido(dataset.FieldDefs.Items[i].Name,UpperCase(camposdataset)) then ClientDataSet1.FieldDefs.Add(dataset.FieldDefs.Items[i].Name,dataset.FieldDefs.Items[i].DataType,dataset.FieldDefs.Items[i].Size,dataset.FieldDefs.Items[i].Required);
     end
    else ClientDataSet1.FieldDefs.Add(dataset.FieldDefs.Items[i].Name,dataset.FieldDefs.Items[i].DataType,dataset.FieldDefs.Items[i].Size,dataset.FieldDefs.Items[i].Required);
 end;
  ClientDataSet1.CreateDataSet;
  ClientDataSet1.EmptyDataSet;
  a.First;
  while not a.Eof do
  begin
    //if Contido(busca, a.Fieldbyname(retorno).Value) then
   if Procura_em_Multiplos_Campos(tibquery(a),busca, a.Fieldbyname(retorno).Value) then
    begin
        ClientDataSet1.Open;
        ClientDataSet1.Insert;
        for i := 0 to a.Fields.Count-1 do
        begin
          if camposdataset <> '' then
           begin
            if Contido(a.FieldDefs.Items[i].Name,UpperCase(camposdataset)) then ClientDataSet1.FieldByName(a.FieldDefs.Items[i].Name).Value := a.fieldbyname(a.FieldDefs.Items[i].Name).Value;
           end
          else ClientDataSet1.FieldByName(a.FieldDefs.Items[i].Name).Value := a.fieldbyname(a.FieldDefs.Items[i].Name).Value;
        end;
        ClientDataSet1.Post;
      end;
    a.Next;
  end;
  form33 := tform33.Create(self);
  CtrlResize(tform(form33));
  form33.campobusca := campobusca;
  form33.campolocalizaca := retorno;
  FormataCampos(tibquery(ClientDataSet1),2,'',2);
  form33.DataSource1.DataSet := ClientDataSet1;
  form33.ShowModal;
  ClientDataSet1.Destroy;
  result:=retornobusca;
  form33.Free;
  a.Close;
  a.Free;
  ClientDataSet1.Close;
  ClientDataSet1.Free;
end;



function tfuncoes.localizar(titulo:string;tabela:string;campos:string;retorno:string;esconde:string;localizarPor:string;OrdenarPor:string;editLocaliza:boolean;editavel:boolean;deletar:boolean;condicao:string;tamanho:integer;compnenteAlinhar: TObject):string;
var pRect:TRect;
begin
  Form7 := Tform7.Create(Self);
  if tamanho<>0 then form7.Width:=tamanho;
  //alinhar em baixo do componente
  if compnenteAlinhar <> nil then
   begin
    GetWindowRect(tedit(compnenteAlinhar).Handle,pRect);
    pRect.Top := pRect.Top + 21;
    form7.Top := pRect.Top;
    if pRect.Left + form7.Width > Screen.Width then form7.Left := Screen.Width - form7.Width
     else form7.Left := pRect.Left;
   end
  else
   begin
     form7.Position := poScreenCenter;
   end;
  form7.tabela :=tabela;
  form7.campos:= campos;
  form7.Caption := titulo;
  form7.campolocaliza:=localizarPor;
  form7.ordem:=OrdenarPor;
  form7.retorno:=retorno;
  form7.editalvel:=editavel;
  form7.deletar:=deletar;
  form7.formulario:=self;
  form7.esconde:=esconde;
  form7.condicao:=condicao;
  if not(editLocaliza) then
   begin
    form7.editlocaliza := true;
    form7.Label1.Visible := false;
    form7.Edit1.Visible := false;
    form7.DBGrid1.Top := 1;
    form7.DBGrid1.Height:=form7.DBGrid1.Height+30;
   end
  else form7.editlocaliza := false;
  Form7.ShowModal;
  result := retornoLocalizar;
  retornoLocalizar := '';
end;



procedure tfuncoes.ResizeForms;
var i:integer;
begin
  for i:=0 to Application.ComponentCount-1 do
    begin
      if Assigned(Application.Components[i]) then
        begin
          //if Application.Components[i] is TForm then CtrlResize(tform(Application.Components[i].GetParentComponent));
        end;
    end;
end;

procedure tfuncoes.CharSetRichEdit(var rich:TRichEdit);
var
   i : longint;
begin
    Rich.Font.Name := 'Terminal';
  Rich.Font.Size := 9;
  Rich.Font.Charset := OEM_CHARSET;
  Rich.DefAttributes.Name := 'Terminal';
  Rich.DefAttributes.Size := 9;
  Rich.DefAttributes.Charset := OEM_CHARSET;
  Rich.SelAttributes := Rich.DefAttributes;
  i := SendMessage(Rich.Handle, EM_GETLANGOPTIONS, 0, 0);
  i := i and not IMF_AUTOFONT;
  SendMessage(Rich.Handle, EM_SETLANGOPTIONS, 0, i);

end;


function tfuncoes.PosFinal(substr:string;Texto:string):integer;
var a,b:integer;
var retorno:string;
begin
 b:=0;
 Result := 0;
 for a:=length(Texto) downto 1 do
   begin
     if (texto[a]=substr) and (b=0) then
      begin
       result:=a;
       b:=1;
      end;
   end;
end;

function tfuncoes.ContaChar(estring:string;sub:string):string;
var i:integer;
begin
 result:='0';
 i:=1;
  while pos(sub,estring)>0 do
  begin
    result:=IntToStr(strtoint(result)+1);
    i:=pos(sub,estring);
    estring:= copy(estring,i+1,length(estring));
  end;
end;

Function tfuncoes.ConverteNumerico(valor:string):string;
var i:integer;
begin
  //valor:=FormatCurr('##.###0.00',strtocurr(valor));
  if (valor<>'') then begin
  for i:=1 to length(valor) do
  begin
    if (valor[i]='.') and not ( (i=length(valor)-1) or (i=length(valor)-2) or (i=length(valor)-3)) then  delete(valor,i,1);
    if (valor[i]='.') and ( (i=length(valor)-1) or (i=length(valor)-2) or (i=length(valor)-3)) then valor[i]:=',';
  end;
  result:=valor;
  end
   else result:='0';
end;

procedure tfuncoes.FormataCampos(var query:Tibquery;qtdCasasDecimais:integer;CampoFormatoDiferente:string;qtd:integer);
var a:integer;
begin
  a:=0;

  while a<>query.FieldCount do
  begin
    if (FieldTypeNames[query.Fields.Fields[a].DataType]='BCD') and (query.Fields[a].FieldName<> CampoFormatoDiferente) then
      begin
        TcurrencyField(query.FieldByName(query.Fields[a].FieldName)).DisplayFormat := '###,##0.'+CompletaOuRepete('','','0',qtdCasasDecimais);
      end;
    if (FieldTypeNames[query.Fields.Fields[a].DataType]='BCD') and (query.Fields[a].FieldName=campoFormatoDiferente) then
      begin
        TcurrencyField(query.FieldByName(query.Fields[a].FieldName)).DisplayFormat := '###,##0.'+CompletaOuRepete('','','0',qtd);
      end;
    a:=a+1;
  end;
end;


procedure tfuncoes.OrdenaCamposVenda(campos:string);
var i:integer;
var nomeCampo:TStringList;
begin
  i:=0;
  nomeCampo:= TStringList.Create;
  nomecampo.Add('0=cod');
  nomecampo.Add('1=descricao');
  nomecampo.Add('2=preco');
  nomecampo.Add('3=estoque');
  nomecampo.Add('4=unid');
  nomecampo.Add('5=codbar');
  nomecampo.Add('6=aplicacao');
  nomecampo.Add('7=refori');
  nomecampo.Add('8=localizacao');
  nomecampo.Add('9=deposito');

  while i<>length(campos) do
    begin
      dm.produto.FieldByName(funcoes.LerValorPGerais(campos[i+1],nomeCampo)).Index:=pos(campos[i+1],campos);
      i:=i+1;
    end;
end;

function tfuncoes.BuscaNomeBD(var query:tibquery;NomeCampo:string;NomeTabela:string;condicao:string) : string;
begin
  query.SQL.Clear;
  query.SQL.Add('select '+NomeCampo+' from '+NomeTabela+' '+condicao);
  try
   query.Open;
  except
  end;

  if query.IsEmpty then Result:='Desconhecido'
    else  Result:= query.fieldbyname(NomeCampo).AsString;
  query.Close;
end;

function tfuncoes.PerguntasRel(var query:tibquery;paramper:string;paramverifica:boolean;valorbd:string;valorstring:string) : boolean;
//var grupo,fornec,fabric:string;
var test:boolean;
begin
if not(paramverifica) then
begin
  if Contido('1',paramper) then form2.grupo :=  funcoes.dialogo('generico',0,'1234567890'+#8,0,false,'','Control For Windows','Se Deseja Separação por GRUPO, Informe um Cód.:','') ;
  if Contido('2',paramper) then if form2.grupo<>'*' then form2.fornec :=funcoes.dialogo('generico',0,'1234567890'+#8,0,false,'','Control For Windows','Se Deseja Separação por FORNECEDOR, Informe um Cód.:','') ;
  if Contido('3',paramper) then if  not Contido('*',form2.grupo+form2.fornec)  then form2.fabric := funcoes.dialogo('generico',0,'1234567890'+#8,0,false,'','Control For Windows','Se Deseja Separação por FABRICANTE, Informe um Cód.:','') ;
end
 else
   begin
     if not Contido('*',form2.fabric+form2.fornec+form2.grupo) and paramverifica then
       begin
         result:=true;
         if Contido('3',paramper) then
         begin
         if (form2.fabric<>'')  then
           begin
            if query.FieldByName('fabric').AsString=form2.fabric  then
              begin
                result:=true;
              end
             else
               begin
                 result:=false;
               end;
           end;
           end;
         end;

         if Contido('1',paramper) then
         begin
         if Result then
         begin
         if (form2.grupo<>'')  then
           begin
            if query.FieldByName('grupo').AsString=form2.grupo  then
              begin
                result:=true;
              end
            else
              begin
               result:=false;
              end;
           end;
         end;
         end;

        if Contido('2',paramper) then
         begin
        if Result then
        begin
        if (form2.fornec<>'') then
           begin
            if query.FieldByName('fornec').AsString=form2.fornec  then
              begin
                 result:=true;
              end
             else
               begin
               result:=false;
               test:=false;
              end;
           end;

         end;
       end;

          if paramper='' then
         begin
          if (form2.fornec='') and (form2.fabric='') and (form2.grupo='') then
            begin
              result:=true;
            end;
         end;
        end;
end;

function Tfuncoes.Contido(substring:string;texto:string):boolean;
begin
  if Pos(substring,texto ) > 0 then result:=true
    else result:=false;
end;


procedure TFuncoes.ExecFile(F: String);
var
r: String;
begin
case ShellExecute(Handle, nil, PChar(F), nil, nil, SW_SHOWNORMAL) of
ERROR_FILE_NOT_FOUND: r := 'The specified file was not found.';
ERROR_PATH_NOT_FOUND: r := 'The specified path was not found.';
ERROR_BAD_FORMAT: r := 'The .EXE file is invalid (non-Win32 .EXE or error in .EXE image).';
SE_ERR_ACCESSDENIED: r := 'Windows 95 only: The operating system denied access to the specified file.';
SE_ERR_ASSOCINCOMPLETE: r := 'The filename association is incomplete or invalid.';
SE_ERR_DDEBUSY: r := 'The DDE transaction could not be completed because other DDE transactions were being processed.';
SE_ERR_DDEFAIL: r := 'The DDE transaction failed.';
SE_ERR_DDETIMEOUT: r := 'The DDE transaction could not be completed because the request timed out.';
SE_ERR_DLLNOTFOUND: r := 'Windows 95 only: The specified dynamic-link library was not found.';
SE_ERR_NOASSOC: r := 'There is no application associated with the given filename extension.';
SE_ERR_OOM: r := 'Windows 95 only: There was not enough memory to complete the operation.';
SE_ERR_SHARE: r := 'A sharing violation occurred.';
else
Exit;
end;
end;



function tfuncoes.grelatoriocima(SQLGrupo:string;SQLFornec:string;SQLFabric:string;SQLCom2Filtros:string;SQLSemFiltros:string;cabecalho:string;NomeDaEmpresa:string;NomeDoRelatorio:string;colunas:string):boolean;
var grupo,fornec,fabric:string;
begin
 grupo := funcoes.dialogo('generico',0,'1234567890'+#8,0,false,'','Control For Windows','Se Deseja Separação por GRUPO, Informe um Cód.:','') ;
 if grupo<>'*' then fornec := funcoes.dialogo('generico',0,'1234567890'+#8,0,false,'','Control For Windows','Se Deseja Separação por FORNECEDOR, Informe um Cód.:','') ;
 if  not Contido('*',grupo+fornec) and  (SQLFabric<>'') then fabric := funcoes.dialogo('generico',0,'1234567890'+#8,0,false,'','Control For Windows','Se Deseja Separação por FABRICANTE, Informe um Cód.:','') ;
   //funcoes.GeraRelatorio('tabela','a');

    //verifica se o grupo nao é branco para poder filtrar por grupo
          if (grupo<>'') and (fornec='') and not Contido('*',fornec+grupo+fabric)  then
             begin
               dm.ProdutoQY.SQL.Clear;
               dm.ProdutoQY.SQL.Add(SQLGrupo);
               dm.ProdutoQY.ParamByName('grupo').AsInteger:=StrToInt(grupo);
               dm.ProdutoQY.Open;
             end;

          if (fornec<>'') and  (grupo='') and not Contido('*',fornec+grupo+fabric) then
             begin
               dm.ProdutoQY.SQL.Clear;
               dm.ProdutoQY.SQL.Add(SQLFornec);
               dm.ProdutoQY.ParamByName('fornec').AsInteger:=StrToInt(fornec);
               dm.ProdutoQY.Open;
             end;

          if (fabric<>'') and (grupo='') and (fornec='') and not Contido('*',fornec+grupo+fabric) then
             begin
               dm.ProdutoQY.SQL.Clear;
               dm.ProdutoQY.SQL.Add(SQLFabric);
               dm.ProdutoQY.ParamByName('fabric').AsInteger:=StrToInt(fornec);
               dm.ProdutoQY.Open;
             end;

           if (fornec<>'') and (grupo<>'')and (fabric<>'') and not Contido('*',fornec+grupo+fabric) then
             begin
               dm.ProdutoQY.SQL.Clear;
               dm.ProdutoQY.SQL.Add(SQLCom2Filtros);
               dm.ProdutoQY.ParamByName('grupo').AsInteger:=StrToInt(grupo);
               dm.ProdutoQY.ParamByName('fornec').AsInteger:=StrToInt(fornec);
               dm.ProdutoQY.Open;
             end;

             if (fornec='') and (grupo='') and (fabric='')  then
             begin
               dm.ProdutoQY.Close;
               dm.ProdutoQY.SQL.Clear;
               dm.ProdutoQY.SQL.Add(SQLSemFiltros);
               dm.ProdutoQY.Open;
             end;


           if not Contido('*',fornec+grupo+fabric) then
             begin
               dm.ProdutoQY.FetchAll;
               //form19.RichEdit1.Clear;
               if cabecalho<>'' then
                 begin
                   form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((cabecalho))));
                 end
               else
                 begin
                   form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.RelatorioCabecalho(NomeDaEmpresa,NomeDoRelatorio,80)))));
                   if colunas<>'' then
                     begin
                       form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((colunas+#13+#10))));
                       form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar((funcoes.CompletaOuRepete('',#13+#10,'-',80)))));
                     end;
                   //form19.RichEdit1.Perform(EM_REPLACESEL, 1, Longint(PChar(())));

                 end;
               end;
              if Contido('*',fornec+grupo+fabric) then result:=true
                else result:=false;
end;


procedure tfuncoes.CtrlResize(var Sender: TForm);
const
iWidth = 800;
iHeight = 600;

var i,b,c : Integer;
begin
with Sender do
for i := 0 to ComponentCount -1 do
  begin
    if Components[i] is TWinControl then
      begin
        TWinControl(Components[i]).Width := Round(TWinControl(Components[i]).Width * (Screen.Width / iWidth));
        TWinControl(Components[i]).Height := Round(TWinControl(Components[i]).Height * (Screen.Height / iHeight));
        TWinControl(Components[i]).Left := Round(TWinControl(Components[i]).Left * (Screen.Width / iWidth));
        TWinControl(Components[i]).Top := Round(TWinControl(Components[i]).Top * (Screen.Height / iHeight));

        if Components[i] is TToolBar then
          begin
            for c:=0 to TToolBar(Components[i]).ButtonCount-1 do
              begin
                if TComponent(TToolBar(Components[i]).Buttons[c]) is TLabel then
                  begin
                    if Tlabel(TToolBar(Components[i]).Buttons[c]).Caption<>'' then
                      begin
                        Tlabel(TToolBar(Components[i]).Buttons[c]).Width := Canvas.TextWidth(Tlabel(TToolBar(Components[i]).Buttons[c]).Caption)+40; // Round(TWinControl(Components[i]).Width * (Screen.Width / iWidth));
                        Tlabel(TToolBar(Components[i]).Buttons[c]).Height := Canvas.TextHeight(Tlabel(TToolBar(Components[i]).Buttons[c]).Caption)+40; // Round(TWinControl(Components[i]).Height * (Screen.Height / iHeight));
                        Tlabel(TToolBar(Components[i]).Buttons[c]).Update;
                        Tlabel(TToolBar(Components[i]).Buttons[c]).Font.Size:=Tlabel(TToolBar(Components[i]).Buttons[c]).Font.Size-1;
                      end;
                  end;
              end;
          end;
      end
else
  begin
    if Components[i] is TLabel then
      begin
        TLabel(Components[i]).Width := Canvas.TextWidth(TLabel(Components[i]).Caption); // Round(TWinControl(Components[i]).Width * (Screen.Width / iWidth));
        TLabel(Components[i]).Height := Canvas.TextHeight(TLabel(Components[i]).Caption)+6; // Round(TWinControl(Components[i]).Height * (Screen.Height / iHeight));
        b:= TLabel(Components[i]).Font.Size;
        TLabel(Components[i]).Font.Size:=TLabel(Components[i]).Font.Size+1;
        TLabel(Components[i]).Font.Size:=b;

        TLabel(Components[i]).Left := Round(TWinControl(Components[i]).Left * (Screen.Width / iWidth));
        TLabel(Components[i]).Top := Round(TWinControl(Components[i]).Top * (Screen.Height / iHeight));
        TLabel(Components[i]).Update;
      end;
    Sender.Refresh;
  end;
end;


Sender.Width := Round(Sender.Width * (Screen.Width / iWidth));
Sender.Height := Round(Sender.Height * (Screen.Height / iHeight));
Sender.Top := Round(Sender.Top * (Screen.Height / iHeight));
Sender.Left := Round(Sender.Left * (Screen.Width / iWidth));
Sender.Font.Size := Round(Sender.Font.Size * (Screen.Height / iHeight));
end;


function Tfuncoes.RelatorioCabecalho(NomeEmpresa:string;NomeRelatorio:string;tamanho:integer):string;
var v1:string;
begin
  v1:=CompletaOuRepete('',#13+#10,'-',tamanho+2);
  v1:=v1+CompletaOuRepete(NomeEmpresa,'DATA: '+FormatDateTime('dd/mm/yy',now)+#13+#10,' ',tamanho+2);
  v1:=v1+CompletaOuRepete(NomeRelatorio,'HORA: '+FormatDateTime('tt',now)+#13+#10,' ',tamanho+2);
  v1:=v1+CompletaOuRepete('',#13+#10,'-',tamanho+2);
  Result:=v1;

end;



function Tfuncoes.CompletaOuRepete(const valorParaCompletar:AnsiString;const ValorFinal:AnsiString;valorParaRepetir:string;contadorDeRepeticao:integer):string;
var i:integer;
var acc:string;
  begin
    if length(valorParaCompletar+ValorFinal)<=contadorDeRepeticao then
    begin
    i:=length(ValorFinal);
    acc:='';
    if valorParaCompletar='' then
      begin
        while i<>contadorDeRepeticao do
          begin
            try
            acc:=acc+valorParaRepetir;
            except
            end;
            i:=i+1;
            end;
          if ValorFinal<>'' then result:=acc+ValorFinal
             else result:=acc;
      end
    else
      begin
         i:=length(valorParaCompletar)+length(ValorFinal);
         acc:=valorParaCompletar;
         while i<>contadorDeRepeticao do
          begin
            i:=i+1;
            try
              acc:=acc+valorParaRepetir;
            except
            end;
            end;
          if ValorFinal<>'' then result:=acc+ValorFinal
             else result:=acc;
      end;
    end
      else
        begin
          acc := '*****';
          i:=length(acc);
          while i<>contadorDeRepeticao do
          begin
            i:=i+1;
            try
              acc:=acc+valorParaRepetir;
            except
            end;
            end;
          Result:=acc;
        end;
  end;




function Tfuncoes.LerFormPato(index:integer;param : integer) : string;
begin
 form18 := tform18.Create(self);
 if param = 0 then
   begin
     form18.Label1.Visible := false;
     form18.ListBox1.Align := alClient;
   end;
 funcoes.CtrlResize(tform(form18));
 form18.valorlistbox := index;
 form18.ShowModal;
 form18.Free;
 result:=formpato;
end;

procedure Tfuncoes.informacao(posicao:integer;total:integer;informacao:string;novo:boolean;fechar:boolean;valorprogressao:integer);
begin
 if novo then
     begin
       form23.Label1.Caption:=informacao;
       form23.Show;
       form23.vezes := valorprogressao;
     end
   else
     begin
       Application.ProcessMessages;
       if trunc(posicao/(total/100)) >= form23.vezes then
         begin
          form23.ProgressBar1.Position := trunc(posicao/(total/100));
          form23.vezes:=form23.vezes+valorprogressao;
         end;
     end;
   if fechar then Form23.Close;

end;
{
function Tfuncoes.DadosProgres(valor:integer,fator:integer);
var s1,s2:integer;
begin
  if fator='' then
    begin
      if length(IntToStr(valor))=5 then s1:=
    end;
end;
     }




function Tfuncoes.dialogo(tipo:string;maxlengt : integer;ValorEntrada:string;tamanhocampo:integer;obrigatorio1:boolean;trocaletras:string;titulo:string;label1:string;default:string):string;
begin
//se TIPO = NORMAL entao maxlength sera o minimo de caracteres que ira aceitar
  pergunta1 := Tpergunta1.Create(Self);
  pergunta1.Gauge1.Visible := false;
  pergunta1.option := 1;
  pergunta1.maxlengt := maxlengt;
  pergunta1.obrigatorio := obrigatorio1;
  pergunta1.Caption := titulo;
  pergunta1.valorPadrao := default;
  pergunta1.valorLabel := label1;
  pergunta1.tempo := true;
  if  tamanhocampo = 0 then pergunta1.tamanhoEdit:=0
    else pergunta1.tamanhoEdit := tamanhocampo;
  pergunta1.botoes := trocaletras;
  pergunta1.tipo := tipo;
  pergunta1.valorTecla := ValorEntrada;
  pergunta1.ShowModal;
  if tipo='numero' then valordg := ConverteNumerico(valordg);
  result := valordg;
  valordg := '' ;
  pergunta1.DestroyComponents;
  pergunta1.Destroy;
end;

function tfuncoes.TiraOuTrocaSubstring(StringDeEntrada:string;ValorTrocar:string;ValorQSeraSubstituido:string):string;
begin
result := StringReplace(StringDeEntrada,ValorTrocar,ValorQSeraSubstituido,[]);
end;

function Tfuncoes.LerIni(valor:string):string;
var arq:TIniFile;
var base:string;
begin
  base:=GetCurrentDir;
  base:=base+'\config.ini';
  arq := TIniFile.Create(base);
  Result:=arq.ReadString('CONFIG',valor,'');
  arq.Free;
end;



function Tfuncoes.LerIniToStringList:TStringList;
var arq:TIniFile;
var base:string;
var arr:TStringList;
begin
  arr:=TStringList.Create;
  base:=GetCurrentDir;
  base:=base+'\config.ini';
  arq := TIniFile.Create(base);

  arq.ReadSectionValues('CONFIG',arr);

  arq.Free;
  end;

function Tfuncoes.LerValorPGerais(NomeConfig:string;arr:TStringList):string;
begin
  Result:=arr.Values[NomeConfig];
end;

function Tfuncoes.VerSeExisteConfig:boolean;
var arq:TIniFile;
var base:string;
begin
  base:=GetCurrentDir;
  base:=base+'\config.ini';
  arq := TIniFile.Create(base);

  result:=arq.SectionExists('CONFIG');
  arq.Free;
end;

function Tfuncoes.ArredondaFinanceiro(Value: Currency; Decimals: integer): Currency;
var
  Factor, Fraction: Currency;
begin
  Factor := IntPower(10, Decimals);
  Value := StrToFloat(FloatToStr(Value * Factor));
  Result := Int(Value);
  Fraction := Frac(Value);
  if Fraction >= 0.5 then
    Result := Result + 1
  else if Fraction <= -0.5 then
    Result := Result - 1;
  Result := Result / Factor;
  end;

function Tfuncoes.ArredondaTrunca(Value: Extended;decimais:integer): Extended;
begin
  if decimais=2 then Result := trunc(value*100)/100
     else Result := trunc(value*1000)/1000;
end;

function Tfuncoes.novocod(gen: string) : string;
begin
  dm.IBQuery1.SQL.Clear;
  dm.IBQuery1.SQL.add('select gen_id('+gen+',1) as cod from RDB$DATABASE');
  dm.IBQuery1.Open;
  Result:=dm.IBQuery1.fieldbyname('cod').AsString;
  dm.IBQuery1.Close;
  dm.IBQuery1.SQL.Clear;
end;

function Tfuncoes.PreparaData(Valor: string): TDateTime;
   var dat: TDateTime;
 begin
    dat:=StrToDate(valor);
    valor:=FormatDateTime('dd/mm/yyyy', dat);
    Result := StrToDateTime(Valor);
 end;





procedure Tfuncoes.FormCreate(Sender: TObject);
begin
    Simbolos[1] := 'ABCDEFGHIJLMNOPQRSTUVXZYWK abcdefghijlmnopqrstuvxzywk1234567890-+=_?/.,<>;:)(*&^%$#@!~áäà';
    Simbolos[2] := 'ÂÀ©Øû×ƒçêùÿ5Üø£úñÑªº¿®¬¼ëèïÙýÄÅÉæÆôÁáâäàåíóÇüé¾¶§÷ÎÏ-+ÌÓß¸°¨·¹³²Õµþîì¡«½WDX2U3BHJKMSZDTQ4';
end;

end.
