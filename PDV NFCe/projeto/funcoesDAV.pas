unit funcoesDAV;

interface

uses
  Windows, Messages, SysUtils, Classes,
  Graphics, Controls, Forms, Dialogs, StdCtrls, IBQuery, classes1;

  function PosFinal(substr:string;Texto:string):integer;
  function menorInteger(v1, v2 : integer) : integer ;
  function formataCPF(const cpf : String) : String;
  function formataCNPJ(Const cnpj : String) : String;
  procedure LE_XMLNFE(const NuNF : String; var lista : TItensProduto; query : TIBQuery; var dadosNfe : TDadosNFe);
  function menor(v1, v2 : Variant) : Variant ;
  function nome(lin : string; quant : integer) : string ;
  function replicate(lin : string; quant : integer) : string ;
  function space(quant : integer) : string ;
  function leftt(lin : string; quant : integer) : string ;
  function at(ch : string; lin : string) : integer ;
  function right(lin : string; quant : integer) : string ;
  function strzero(num : integer; quant : integer) : string ;overload;
  function strzero(num : string; quant : integer) : string ;overload;
  function alltrim(lin : string) : string ;
  function maiortam(lin1 : string; lin2 : string) : string;
  function wait(tempo : integer) : string;
  function secs(hor : TdateTime) : integer;
  function rat(ch : string; lin : string) : integer ;
  function asc(pos : char) : integer;
  function strnum(num : string) : string;
  function strnum1(num : string) : string;
  function comp_data(dat : String) : String;
  function decomp_data(dat : String) : String;
  function TabelaExisteNoBD(query : TIBQuery; tabela : string) : boolean;
  function form_num(num : currency; qtd : integer) : String;
  function form_data(data : string) : string;
  function Contido(substring:string;texto:string):boolean;
  function testaChaveNFE(chave : String) : boolean;
  function CriaDiretorio(const NomeSubDir: string): boolean;
//  function arredonda(valor : currency) : currency;
  function ve_descricao(descricao : string; unid : string) : string;
  function CompletaOuRepete(const valorParaCompletar:AnsiString;const ValorFinal:AnsiString;valorParaRepetir:string;contadorDeRepeticao:integer):string;
  function ContaChar(estring:string;sub:string):string;
  Function ConverteNumerico(valor:string):string;
  function checaCodbar(vx_cod : String) : boolean;
  FUNCTION DIGEAN(vx_cod : string) : string;
  function maior(v1, v2 : variant) : variant;
  procedure DECOMP_MOV(const LINHA : String; var mat : TStringList);
  function converteDataYYMMDDParaTdate(data : String) : TDate;
  function Le_Nodo1(const nome:string; const texto :string) : String;
  function Le_Nodo(nome:string; const texto :string) : String;
  function RoundTo1(Value: Extended): Extended;

implementation

function Le_Nodo(nome:string; const texto :string) : String;
var
  ini, fim, param : integer;
  temp1 : string;
begin
  ini := 0;
  fim := 0;
  param := 0;
  if Contido(' ', nome) then param := 1; // se veio espaço em braco é porque tem parametros

  ini := pos('<'+nome+'>', texto);
  if ini <= 0 then
    begin
      Result := '';
      exit;
    end;

  ini := ini + length('<'+nome+'>');
  temp1 := copy(texto, ini, length(texto));

  if param = 1 then fim := pos('</'+ trim(copy(nome, 1, pos(' ', nome)))  +'>', temp1)
    else fim := pos('</'+nome+'>', temp1);

  //temp1 := '';
  //fim := fim - ini;
  Result := '' ;
  Result := copy(temp1, 1, fim -1);

end;


function Le_Nodo1(const nome:string; const texto :string) : String;
var
  ini, fim : integer;
begin
  ini := pos('<' + nome, texto);
  fim := pos('</' + nome + '>', texto);

  Result := '';
  Result := copy(texto, ini, fim);
end;

procedure DECOMP_MOV(const LINHA : String; var mat : TStringList);
begin
  {
  PEDIDO := funcoes.CompletaOuRepete('', PEDIDO, '0', 7);//NUM_PED := IF(RIGHT(PEDIDO, 1) = "S", LEFT(PEDIDO, 6) + "1", RIGHT(PEDIDO, 6) + "0")//PEDIDO := IF(RIGHT(PEDIDO, 1) = "S", PEDIDO, RIGHT(PEDIDO, 6) + " ")
  NF     := funcoes.CompletaOuRepete('', NF, '0', 7);
  TIPO   := funcoes.CompletaOuRepete('', trim(tipo), '0', 2);
  INFO := FORM_DATA_YY_MM_DD(DATA) + PEDIDO + NF + TIPO;
  }
  
  if not assigned(mat) then mat := TStringList.Create;
  mat.Clear;
  mat.Add(copy(LINHA, 1, 6));  //0data
  mat.Add(copy(LINHA, 7, 7));  //1pedido
  mat.Add(copy(LINHA, 14, 7)); //2nota
  mat.Add(copy(LINHA, 21, 2)); //3tipo
end;

function maior(v1, v2 : variant) : variant;
begin
 Result := 0;
 if v1 > v2 then Result := v1
 else Result := v2;
end;

FUNCTION DIGEAN(vx_cod : string) : string;
var
 vx_ta, vx_soma, vx_ret, vx_i : integer;
 vx_cal : variant;
begin
  vx_ta := Length(vx_cod);
  vx_soma := 0;
  vx_ret := 0;
  if Length(vx_cod) <> 12 then
    begin
      Result := vx_cod;
      exit;
    end;
  FOR vx_i := 1 TO vx_ta do
    begin
      vx_cal := StrToInt(copy(vx_cod,vx_i,1));

      IF (vx_i mod 2) = 0 then vx_cal := vx_cal * 3;
      vx_soma := vx_soma + vx_cal;
    end;

    WHILE (vx_soma / 10 <> trunc(vx_soma/10)) do
      begin
        vx_ret := vx_ret + 1;
        vx_soma := vx_soma + 1;
      end;
  Result := (trim(vx_cod) + TRIM(IntToStr(vx_ret)));
end;

function checaCodbar(vx_cod : String) : boolean;
var
 ut : string;
 vx_ta, vx_soma, vx_ret, vx_i : integer;
 vx_cal : variant;
begin
  Result := false;
  ut := vx_cod;
  vx_cod := copy(vx_cod, 1, 12);
  vx_ta := Length(vx_cod);
  vx_soma := 0;
  vx_ret := 0;
  if Length(vx_cod) <> 12 then
    begin
      exit;
    end;

  FOR vx_i := 1 TO vx_ta do
    begin
      vx_cal := StrToInt(copy(vx_cod,vx_i,1));

      IF (vx_i mod 2) = 0 then vx_cal := vx_cal * 3;
      vx_soma := vx_soma + vx_cal;
    end;

    WHILE (vx_soma / 10 <> trunc(vx_soma/10)) do
      begin
        vx_ret := vx_ret + 1;
        vx_soma := vx_soma + 1;
      end;

  vx_cod := (trim(vx_cod) + TRIM(IntToStr(vx_ret)));

  if vx_cod = ut then Result := true;

end;

Function ConverteNumerico(valor:string):string;
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


function ContaChar(estring:string;sub:string):string;
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

function CriaDiretorio(const NomeSubDir: string) : boolean;
begin
  try
    if not DirectoryExists(NomeSubDir) then
      ForceDirectories(NomeSubDir);
  except
  end;
end;

function CompletaOuRepete(const valorParaCompletar:AnsiString;const ValorFinal:AnsiString;valorParaRepetir:string;contadorDeRepeticao:integer):string;
var i:integer;
var acc:string;
  begin
    if length(valorParaCompletar+ValorFinal)<=contadorDeRepeticao then
    begin
    i:=length(ValorFinal);
    acc:='';
    if valorParaCompletar='' then
      begin
        while i < contadorDeRepeticao do
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
         i := length(valorParaCompletar)+length(ValorFinal);
         acc:=valorParaCompletar;
         while i < contadorDeRepeticao do
          begin
            i:=i+1;
            try
              acc:=acc+valorParaRepetir;
            except
            end;
            end;
          if ValorFinal<>'' then result:=acc+ValorFinal
             else result := acc;
      end;
    end
      else
        begin
          acc := CompletaOuRepete('', '', '*', contadorDeRepeticao);//'*****';
          ///acc := valorParaCompletar + acc + ValorFinal;
          i := length(acc);
          while i < contadorDeRepeticao do
          begin
            i:=i+1;
            try
              acc:=acc+valorParaRepetir;
            except
            end;
            end;
          Result := acc;
        end;
  end;

function testaChaveNFE(chave : String) : boolean;
var
  ini, fim : integer;
  total : currency;
  seq, dv, temp : string;
begin
  result := false;
  seq := '';
  seq := '432' + CompletaOuRepete('','','98765432',5);
  total := 0;
  
  fim := length(chave) -1;
  for ini := 1 to fim do
      begin
        try
          total := total + StrToCurr(seq[ini]) * StrToCurr(chave[ini]) ;
        except
          result := false;
          exit;
        end;
      end;

    ini := (trunc(total) mod 11);
    ini := 11 - ini;
    if ini > 9 then ini := 0;
    dv := IntToStr(ini);

    if dv = chave[length(chave)] then result := true
     else result := false;

end;

function Contido(substring:string;texto:string):boolean;
begin
  if Pos(substring,texto ) > 0 then result:=true
    else result:=false;
end;

function menor(v1, v2 : Variant) : Variant ;
begin
  if v1 < v2 then Result := v1
    else Result := v2;
end;

function menorInteger(v1, v2 : integer) : integer ;
begin
  if v1 < v2 then Result := v1
    else Result := v2;
end;


//--------------------------------------------------------
function ve_descricao(descricao : string; unid : string) : string;
var ini, fim, qtd : integer;
begin
  result := trim(descricao);
  //if ((copy(descricao, 27, 1) = 'X') and (copy(descricao, 34, 1) = 'X') and (unid = 'M2')) then
  if (unid = 'M2') then
     result := trim(copy(descricao, 1, 22));
end;


function form_data(data : string) : string;
var ret : string; pos, pos1, num : integer;
begin
  //ano
  ret := copy(data, length(data) - 1, 2);

  //mês
  pos := at('/', data);
  pos1 := rat('/', data);
  num := strtoint(copy(data, pos + 1, pos1 - pos - 1));
  ret := ret + strzero(num, 2);

  //dia
  num := strtoint(copy(data, 1, pos - 1));
  ret := ret + strzero(num, 2);
  result := ret;
  
end;

//--------------------------------------------------------
function form_num(num : currency; qtd : integer) : String;
var ret : string; pos : integer;
begin
 num := num * 100;
 ret := CurrToStr(num);
 pos := at(',', ret);
 if (pos > 0) then ret := copy(ret, 1, pos - 1);
 ret := replicate('0', qtd) + strnum(ret);
 ret := copy(ret, length(ret) - qtd + 1, qtd);
 result := ret;
end;

//---------------------------------------------
function nome(lin : string; quant : integer) : string ;
begin
    result := UPPERCASE(copy(lin + replicate(' ', quant), 1, quant));
end;


//----------------------------------------------------------
function replicate(lin : string; quant : integer) : string ;
var ini : integer;
begin
    result := '';
    for ini := 1 to quant do result := result + lin;
end;

//----------------------------------------------------------
function strzero(num : integer; quant : integer) : string ;
var ret : string;
begin
    ret := replicate('0', quant) + inttostr(num);
    result := copy(ret, length(ret) - quant + 1, quant) ;
end;

//----------------------------------------------------------
function strzero(num : string; quant : integer) : string ;
var ret : string;
begin
    ret := replicate('0', quant) + num;
    result := copy(ret, length(ret) - quant + 1, quant) ;
end;

//-----------------------------------------------------
function space(quant : integer) : string ;
var ini : integer;
begin
    result := '';
    for ini := 1 to quant do result := result + ' ';
end;

//------------------------------------------------------------------
function leftt(lin : string; quant : integer) : string ;
begin
    result := #13;
    if quant > length(lin) then lin := lin + space(quant - length(lin));
    if quant = length(lin) then result := lin;
    if result = #13 then result := copy(lin, 1, quant);
end;

//------------------------------------------------------
function at(ch : string; lin : string) : integer ;
var ini : integer;
begin
    ini := 1;
    result := 0;
    while ini <= length(lin) do
      begin
         if copy(lin, ini, 1) = ch then
            begin
              result := ini;
              break;
            end;
            ini := ini + 1;
      end;
end;

//------------------------------------------------------------------
function right(lin : string; quant : integer) : string ;
begin
    result := #13;
    if quant > length(lin) then lin := space(quant - length(lin)) + lin;
    if quant = length(lin) then result := lin;
    if result = #13 then result :=
    copy(lin, length(lin) - quant + 1, quant);
end;



//----------------------------------------------------------
function alltrim(lin : string) : string ;
var ini3 : integer;
begin
    result := '';
    for ini3 := 1 to length(lin) do
      begin
          if copy(lin, ini3, 1) <> ' ' then
            result := result + copy(lin, ini3, 1);
      end;
end;

//---------------------------------------------
function maiortam(lin1 : string; lin2 : string) : string;
begin
  result := lin2;
  if length(lin1) > length(lin2) then
    result := lin1;
end;


//----------------------------------------------------------
function data : string;
var semana : string;
begin
   semana:= 'DomSegTerQuaQuiSexSáb' ;
   result := copy(semana, ((dayofweek(date)-1) * 3) + 1, 3) + ', ' + datetostr(date) + inttostr(dayofweek(date));
end;

//----------------------------------------------------------
function wait(tempo : integer) : string;
var inicw : integer;
begin
    inicw := secs(time) + tempo;
    while (secs(time)) < inicw do
      begin

      end;

end;

//----------------------------------------------------------
function secs(hor : TdateTime) : integer;
var hora : string[8];
begin
   hora := right(datetimetostr(hor), 8);
   result := (strtoint(leftt(hora, 2)) * 360) +
             (strtoint(copy(hora, 4, 2)) * 60) +
              strtoint(right(hora, 2))
end;

//------------------------------------------------------
function rat(ch : string; lin : string) : integer ;
var ini : integer;
begin
    ini := length(lin);
    result := 0;
    while ini > 0 do
      begin
         if copy(lin, ini, 1) = ch then
            begin
              result := ini;
              break;
            end;
            ini := ini - 1;
      end;
end;

//--------------------------------------------------------------
function asc(pos : char) : integer;
begin
   result := ord(pos);
end;

//--------------------------------------------------------------
function strnum(num : string) : string;
var
  cont : integer;
begin
  Result := '';
  for cont := 1 to length(num) do
    begin
      if Contido(num[cont], '1234567890') then Result := Result + num[cont];
    end;
  if Result = '' then Result := '0';
end;


function strnum1(num : string) : string;
var
  cont : integer;
begin
  Result := '';
  for cont := 1 to length(num) do
    begin
      if Contido(num[cont], '1234567890,.') then Result := Result + num[cont];
    end;

  num := Result;
  Result := '';
  for cont := 1 to length(num) do
    begin
      if num[cont] = '.' then Result := Result + ','
       ELSE Result := Result + num[cont];
    end;
  if Result = '' then Result := '0';
end;

//--------------------------------------------------------------
function comp_data(dat : String) : String;
var tam, lido, pos : integer; ret : String;
begin
  tam := length(dat);
  lido := 1;
  ret := '';
  if (tam / 2) <> int(tam / 2) then dat := '0' + dat;
  tam := length(dat);
  while lido < tam do
    begin
      pos := strtoint(copy(dat, lido, 2));
      ret := ret + chr(pos + 48);
      lido := lido + 2;
    end;
  result := ret;
end;

//--------------------------------------------------------------
function decomp_data(dat : String) : String;
var tam, pos : integer; ret : string;
begin
  ret := '';
  tam := length(dat);
  for pos := 1 to tam do
    begin
      ret := ret + strzero(ord(dat[pos]) - 48, 2);
    end;
  result := ret;
end;

//--------------------------------------------------------------
function TabelaExisteNoBD(query : TIBQuery; tabela : string) : boolean;
begin
  query.SQL.Clear;
  query.SQL.Add('select rdb$relation_name from rdb$relations where rdb$relation_name = :tabela');
  query.parambyname('tabela').AsString := tabela;
  query.Open;
  result := (not (query.IsEmpty));
  query.Close;
end;


//--------------------------------------------------------------
{function arredonda(valor : currency) : currency;
var centavos : currency;
begin
  result := Int(valor * 100);
  centavos := Frac(result);
  if centavos >= 0.5 then result := result + 1;
  result := result / 100;
end;
 }

function converteDataYYMMDDParaTdate(data : String) : TDate;
begin
  //141013
  data := copy(data, 5, 2) + '/' + copy(data, 3, 2) + '/' + copy(data, 1, 2);
  Result := StrToDateDef(data, now);
end;

procedure LE_XMLNFE(const NuNF : String; var lista : TItensProduto; query : TIBQuery; var dadosNfe : TDadosNFe);
var
  chave, pastaControl, txt1, t2, ICMS, imposto : String;
  item, i1 : integer;
  item1 : TregProd;
  arq   : TStringList;
begin
  lista.Clear;

  query.Close;
  query.SQL.Text := 'select chave from nfe where nota = :nota';
  query.ParamByName('nota').AsString := NuNF;
  query.Open;

  if query.IsEmpty then
    begin
      ShowMessage('vazio');
      query.Close;
      exit;
    end;

  chave := query.fieldbyname('chave').AsString;
  query.Close;

  pastaControl := ExtractFileDir(ParamStr(0)) + '\';
  if FileExists(pastaControl + 'NFE\EMIT\' + chave + '-nfe.xml') then
    begin
      arq := TStringList.Create;
      arq.LoadFromFile(pastaControl + 'NFE\EMIT\' + chave + '-nfe.xml');
      t2 := arq.GetText;
      arq.Free;
      item := 1;

      if not Assigned(dadosNfe) then dadosNfe := TDadosNFe.Create;
      dadosNfe.nota    := StrToIntDef(NuNF, 0);
      dadosNfe.chave   := chave;
      dadosNfe.totNota := StrToCurrDef(StringReplace(Le_Nodo('vNF', t2), '.', ',', [rfReplaceAll, rfIgnoreCase]), 0);
      dadosNfe.xml     := t2;
      i1 := 1;

      while true do
         begin
           txt1 := '';
           txt1 := Le_Nodo('det nItem="' + IntToStr(i1) + '"', t2);

           if txt1 = '' then break; //irá vir vazio quando a funcao nao retorna nada

           ICMS    := Le_Nodo('ICMS', txt1);

           // inicio da leitura dos itens do xml
           item := lista.Add(TregProd.Create) ;
           lista[item].cod       := StrToIntDef(Le_Nodo('cProd', txt1), 0);
           lista[item].nome      := Le_Nodo('xProd', txt1);
           lista[item].quant     := StrToCurrDef(StringReplace(Le_Nodo('qCom', txt1), '.', ',', [rfReplaceAll, rfIgnoreCase]), 0);
           lista[item].preco     := StrToCurrDef(StringReplace(Le_Nodo('vUnTrib', txt1), '.', ',', [rfReplaceAll, rfIgnoreCase]), 0);
           lista[item].total     := StrToCurrDef(StringReplace(Le_Nodo('vProd', txt1), '.', ',', [rfReplaceAll, rfIgnoreCase]), 0);
           lista[item].codbar    := Le_Nodo('cEAN', txt1);
           lista[item].unid      := Le_Nodo('uTrib', txt1);
           lista[item].CST       := copy(Le_Nodo('CST', ICMS), 1, 2);
           lista[item].CST_PIS   := copy(Le_Nodo('CST', Le_Nodo('PIS', txt1)), 1, 2);
           lista[item].descCom   := StrToCurrDef(StringReplace(Le_Nodo('vDesc', txt1), '.', ',', [rfReplaceAll, rfIgnoreCase]), 0);
           lista[item].total     := lista[item].total - lista[item].descCom;
           lista[item].BASE_ICM  := StrToCurrDef(StringReplace(Le_Nodo('vBC', ICMS), '.', ',', [rfReplaceAll, rfIgnoreCase]), 0);
           lista[item].PERC_ICM  := StrToCurrDef(StringReplace(Le_Nodo('pICMS', ICMS), '.', ',', [rfReplaceAll, rfIgnoreCase]), 0);
           lista[item].TOT_ICM   := StrToCurrDef(StringReplace(Le_Nodo('vICMS', ICMS), '.', ',', [rfReplaceAll, rfIgnoreCase]), 0);
           lista[item].CFOP      := Le_Nodo('CFOP', t2);
           lista[item].vPIS      := StrToCurrDef(StringReplace(Le_Nodo('vPIS', Le_Nodo('PISAliq', txt1)), '.', ',', [rfReplaceAll, rfIgnoreCase]), 0);
           lista[item].vCOFINS   := StrToCurrDef(StringReplace(Le_Nodo('vCOFINS', Le_Nodo('COFINSAliq', txt1)), '.', ',', [rfReplaceAll, rfIgnoreCase]), 0);

           //_VPIS := LE_NODOXML("vPIS", LE_NODOXML("PISAliq", DESC)) )
          // _VCOFINS := Le_Nodo("vCOFINS", LE_NODOXML("COFINSAliq", DESC)))
           // fim da leitura dos itens do xml

           //lista[item-1].cod
           i1 := i1 + 1;
         end;
    end;
end;

{function arredonda(valor : currency; dec : integer) : currency;
begin
  Result := valor;
end;
}
function formataCNPJ(Const cnpj : String) : String;
begin
  Result := '';
  Result := Copy(cnpj,1,2) + '.' + Copy(cnpj,3,3) + '.' + Copy(cnpj,6,3) + '/' + Copy(cnpj, 9, 4) + '-' + Copy(cnpj, 13, 2);
end;

function formataCPF(const cpf : String) : String;
begin
  Result := '';
  Result := Copy(CPF,1,3) + '.' + Copy(CPF,4,3) + '.' + Copy(CPF,7,3) + '-' + Copy(CPF,10,2);
end;

function PosFinal(substr:string;Texto:string):integer;
var
  a, b:integer;
  retorno:string;
begin
 Result := 0;
 for a :=length(Texto) downto 1 do
   begin
     if (texto[a] = substr) then
      begin
        result := a;
        Break;
      end;
   end;
end;

function RoundTo1(Value: Extended): Extended;
begin
  Result := trunc(value * 100)/100;
end;


end.