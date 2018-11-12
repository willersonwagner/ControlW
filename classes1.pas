
unit classes1;

interface

uses controls, Contnrs, dbGrids, Math;

function OrdenaPorCodigoTacumProdASC(Item1, Item2: pointer): Integer;
function OrdenaPorCodigoTacumProdDESC(Item1, Item2: pointer): Integer;
function OrdenaPorQUANTTacumProd(Item1, Item2: pointer): Integer;
function OrdenaPorDEPTacumProdDESC(Item1, Item2: pointer): Integer;

type
   TDBGridC = class(TDBGrid)
   end;

  TChaveDetalhes = class
    codUF      : integer;
    chave      : string[45];
    anoMesYYMM : string[4];
    CNPJ       : String[14];
    modelo     : integer;
    serie      : integer;
    nnf        : integer;
    tpemis     : integer;
    codnf      : integer;
  end;

  TprodutoVendaCodBar = class
    cod    : integer;
    codbar : string[20];
    nome   : String[40];
    quant  : double;
    preco  : currency;
    precoTemp : currency;

  end;

  Tvenda   = class
    nota     : integer;
    cliente  : integer;
    total    : currency;
    desconto : currency;
    totOrigi : currency;
    chave    : string;
    codForma : String;
    codFormaNFCE : String;
    _FORMPG  : string;
    adic     : string;
    data     : tdate;
  end;

  TProduto   = class
    cod      : integer;
    codbar   : string[30];
    refori   : String[30];
  end;

  TacumProd  = class
    cod        : integer;
    notaFiscal : integer;
    quant      : currency;
    dep        : currency;
    val1       : currency;
    val2       : currency;
    unid       : String;
    nota       : String[6];
    data       : tdate;
  end;

  TacumPis = class
    cod    : String[20];
    aliqICM: String[10];
    aliquota : currency;
    pis    : currency;
    cofins : currency;
    icms   : currency;
    Base   : currency;
    total  : currency;
    CFOP   : String;
    CST    : String;
  end;

  TaliqSped   = class
    leng      : String[8];
    CST       : String[2];
    codAliq   : Smallint;
    totECF    : currency;
    totVendas : currency;
  end;

  Tparcela = class
    Vencimento : TDate;
    valor      : currency;
    historico  : string;
  end;


  TUnid = class
    unid_ent  : string;
    unid_sai  : string;
    valor     : currency;
  end;

  TDadosNFe = class
    nota    : integer;
    data    : TDateTime;
    chave   : String[45];
    nNF     : String[10];
    totNota : currency;
    xml     : String;
  end;

  TregProd = class
    cod      : integer;
    codStr   : String;
    temp     : String;
    COD_ISPIS: String;
    nome     : String[40];
    codbar   : String[16];
    CST      : String[3];
    ncm      : String[10];
    CST_PIS  : String;
    CFOP     : String[6];
    quant    : currency;
    aliqCred : currency;
    preco    : currency;
    total    : currency;
    BASE_ICM : currency;
    PERC_ICM : currency;
    TOT_ICM  : currency;
    vPIS     : currency;
    vCOFINS  : currency;
    unid     : String[6];
    unid2    : String[6];
    aliq     : String[4];
    cod_aliq : integer;
    descCom  : currency;
    despAces : currency;
    descNT   : currency;
  end;

  Tprodutos = Class( TObjectList )
    private
      function GetItems(Index: Integer): TProduto;
      procedure SetItems(Index: Integer; const Value: TProduto);
    public
      function Add(AObject: TProduto): Integer;
      function Find(Cod : integer): Integer;
      function getText() : String;
      property Items[Index: Integer]: TProduto read GetItems write SetItems; default;
    End;

  TItensAcumProd = class(TObjectList)
    private
      function GetItems(Index: Integer): TacumProd;
      procedure SetItems(Index: Integer; const Value: TacumProd);
    public
      procedure OrdenarLista(direcao : String = 'ASC');
      function Add(AObject: TacumProd): Integer;
      function Find(Cod : integer): Integer;
      function getText() : String;
      property Items[Index: Integer]: TacumProd read GetItems write SetItems; default;
    End;

  TItensUnid = Class( TObjectList )
    private
      function GetItems(Index: Integer): TUnid;
      procedure SetItems(Index: Integer; const Value: TUnid);
    public
      function Add(AObject: TUnid): Integer;
      function Find(Cod : string): Integer;
      function getText() : String;
      property Items[Index: Integer]: TUnid read GetItems write SetItems; default;
    End;

  TItensPISCOFINS = Class( TObjectList )
    private
      function GetItems(Index: Integer): TacumPis;
      procedure SetItems(Index: Integer; const Value: TacumPis);
    public
      function Add(AObject: TacumPis): Integer;
      function Find(Cod : string): Integer;
      function FindCFOP_CST_ALIQICMS(Cod, aliq : string): Integer;
      function getText() : String;
      property Items[Index: Integer]: TacumPis read GetItems write SetItems; default;
    End;

  TItensProduto = Class( TObjectList )
    private
      function GetItems(Index: Integer): TregProd;
      procedure SetItems(Index: Integer; const Value: TregProd);
    public
      function GetText() : String;
      function GetText_COD_PISCST() : String;
      function Add(AObject: TregProd): Integer;
      function Find(Cod : integer): Integer;
      function FindCodCodbar(Codcodbar : String): Integer;
      function FindCodSTR(Cod : string): Integer;
      function FindCODCSTREG(Cod_CST : String): Integer;
      property Items[Index: Integer]: TregProd read GetItems write SetItems; default;
    End;

  TItensAliqSped = Class( TObjectList )
    private
      function GetItems(Index: Integer): TaliqSped;
      procedure SetItems(Index: Integer; const Value: TaliqSped);
    public
      function Add(AObject: TaliqSped): Integer;
      function Find(Cod : integer): Integer;
      function GetText() : String;
      function getItemText(const index : integer) : string;
      property Items[Index: Integer]: TaliqSped read GetItems write SetItems; default;
    End;

  Item_venda = class
    codbar : String[15];
    cfop : String;
    obs  : String;
    CST_PIS : String;
    cod : integer;
    nome : string;
    unid : string[6];
    codISPIS : string[3];
    quant : currency;
    quant_achado : currency;
    p_venda : currency;
    p_vendaOriginal : currency;
    total : currency;
    total_achado : currency;
    PercICMS : currency;
    VlrICMS : Currency;
    DescICMS : currency;
    Aliq : string[2];
    Reducao : currency;
    DespAcessorias : currency;
    CodAliq : Smallint;
    Total_Preco_Compra : currency; //Preço compra x quantidade
    Pis : string[1];
    Desconto : currency;
    vpis : currency;
    vcofins : currency;
    Ncm : String;
    p_compra : currency;
    Vlr_Frete : currency;
    vlr_imposto : currency;
    base_icm : currency;
  end;

  Item_venda1 = class
    codbar : String[15];
    cod : integer;
    nome : string;
    unid : string[6];
    codISPIS : string[3];
    quant : currency;
    p_venda : currency;
    total : currency;
    PercICMS : currency;
    VlrICMS : Currency;
    DescICMS : currency;
    Aliq : string[2];
    Reducao : currency;
    CodAliq : Smallint;
    Total_Preco_Compra : currency; //Preço compra x quantidade
    Pis : string[1];
    Desconto : currency;
    vpis : currency;
    vcofins : currency;
    Ncm : String;
    p_compra : currency;
    Vlr_Frete : currency;
    vlr_imposto : currency;
    base_icm : currency;
    obs      : String;
  end;

  TOrdem = class
    cod     : integer;
    data    : TDateTime;
    saida   : TDateTime;
    pago    : currency;
    _ent    : String;
    h_saida : String;
    cliente : integer;
    venda   : integer;
    equipe  : string;
    marca   : string;
    modelo  : string;
    defeito : string;
    obs     : string;
    serie   : string;
    tecnico : string;
    usuario : integer;
  end;

implementation

uses Classes, SysUtils;

{Classe TProdutos}
{function Tprodutos.getItemText(const index : integer) : string;
begin
  Result := Items[index].leng + ' ' + Items[index].CST + ' ' + IntToStr(Items[index].codAliq) + ' ' + CurrToStr(Items[index].totECF) + ' ' + CurrToStr(Items[index].totVendas);
end;}

function Tprodutos.GetItems(Index: Integer): TProduto;
begin
  Result := TProduto(inherited Items[Index]);
end;

procedure Tprodutos.SetItems(Index: Integer;const Value: TProduto);
begin
  inherited Items[Index] := Value; // Capturando o item do pedido
end;

function Tprodutos.Add(AObject: TProduto): Integer;
begin
  Result := inherited Add(AObject); // Adicionando o produto
end;

function Tprodutos.GetText() : String;
var
  ini, fim : integer;
begin
  Result := '';
  fim    := Count -1;
  for ini := 0 to fim do
    begin
      //Result := Result + Items[ini].cod + ' ' + Items[ini].CST + ' ' + IntToStr(Items[ini].codAliq) + ' ' + CurrToStr(Items[ini].totECF) + ' ' + CurrToStr(Items[ini].totVendas) + #13;
    end;
end;

function Tprodutos.Find(Cod : integer): Integer;
var
  ini, fim : integer;
begin
  Result := -1;
  fim    := Count -1;
  for ini := 0 to fim do
    begin
      if GetItems(ini).cod = Cod then
        begin
          Result := ini;
          break;
        end;
    end;
end;
{Classe TProdutos}

{Classe TItensAliqSped}
function TItensAliqSped.getItemText(const index : integer) : string;
begin
  Result := Items[index].leng + ' ' + Items[index].CST + ' ' + IntToStr(Items[index].codAliq) + ' ' + CurrToStr(Items[index].totECF) + ' ' + CurrToStr(Items[index].totVendas);
end;

function TItensAliqSped.GetItems(Index: Integer): TaliqSped;
begin
  Result := TaliqSped(inherited Items[Index]);
end;

procedure TItensAliqSped.SetItems(Index: Integer;const Value: TaliqSped);
begin
  inherited Items[Index] := Value; // Capturando o item do pedido
end;

function TItensAliqSped.Add(AObject: TaliqSped): Integer;
begin
  Result := inherited Add(AObject); // Adicionando o produto
end;

function TItensAliqSped.GetText() : String;
var
  ini, fim : integer;
begin
  Result := '';
  fim    := Count -1;
  for ini := 0 to fim do
    begin
      Result := Result + Items[ini].leng + ' ' + Items[ini].CST + ' ' + IntToStr(Items[ini].codAliq) + ' ' + CurrToStr(Items[ini].totECF) + ' ' + CurrToStr(Items[ini].totVendas) + #13;
    end;
end;

function TItensAliqSped.Find(Cod : integer): Integer;
var
  ini, fim : integer;
begin
  Result := -1;
  fim    := Count -1;
  for ini := 0 to fim do
    begin
      if GetItems(ini).codAliq = Cod then
        begin
          Result := ini;
          break;
        end;
    end;
end;
{Classe TItensAliqSped}


{Classe TItensProduto}
function TItensProduto.GetText_COD_PISCST : String;
var
  ini, fim : integer;
begin
  Result := '';
  fim    := Count -1;
  for ini := 0 to fim do
    begin
      Result := Result + '|' + IntToStr(Items[ini].cod) + '|' + Items[ini].CST_PIS + '|' + #13;
    end;
end;


function TItensProduto.GetText() : String;
var
  ini, fim : integer;
begin
  Result := '';
  fim    := Count -1;
  for ini := 0 to fim do
    begin
      Result := Result + '|' + IntToStr(Items[ini].cod) + '|' + CurrToStr(Items[ini].total) + '|' + #13;
    end;
end;

function TItensProduto.GetItems(Index: Integer): TregProd;
begin
  Result := TregProd(inherited Items[Index]);
end;

procedure TItensProduto.SetItems(Index: Integer;const Value: TregProd);
begin
  inherited Items[Index] := Value; // Capturando o item do pedido
end;

function TItensProduto.Add(AObject: TregProd): Integer;
begin
  Result := inherited Add(AObject); // Adicionando o produto
end;

function TItensProduto.FindCODCSTREG(Cod_CST : String): Integer;
var
  ini, fim : integer;
begin
  Result := -1;
  fim    := Count -1;
  for ini := 0 to fim do
    begin
      if GetItems(ini).codbar = Cod_CST then
        begin
          Result := ini;
          break;
        end;
    end;
end;

function TItensProduto.FindCodSTR(Cod : string): Integer;
var
  ini, fim : integer;
begin
  Result := -1;
  fim    := Count -1;
  for ini := 0 to fim do
    begin
      if GetItems(ini).codStr = Cod then
        begin
          Result := ini;
          break;
        end;
    end;
end;

function TItensProduto.Find(Cod : integer): Integer;
var
  ini, fim : integer;
begin
  Result := -1;
  fim    := Count -1;
  for ini := 0 to fim do
    begin
      if GetItems(ini).cod = Cod then
        begin
          Result := ini;
          break;
        end;
    end;
end;

function TItensProduto.FindCodCodbar(Codcodbar : String): Integer;
var
  ini, fim : integer;
begin
  Result := -1;
  fim    := Count -1;
  for ini := 0 to fim do
    begin
      if (IntToStr(GetItems(ini).cod) + GetItems(ini).codbar) = Codcodbar then
        begin
          Result := ini;
          break;
        end;
    end;
end;
{Classe TItensProduto}


{Classe TItensAcumProd}
function OrdenaPorQUANTTacumProd(Item1, Item2: pointer): Integer;
begin
  Result := -CompareValue(TacumProd(Item1).quant, TacumProd(Item2).quant);
end;

function OrdenaPorCodigoTacumProdASC(Item1, Item2: pointer): Integer;
begin
  Result := CompareValue(TacumProd(Item1).cod, TacumProd(Item2).cod);
end;

function OrdenaPorCodigoTacumProdDESC(Item1, Item2: pointer): Integer;
begin
  Result := -CompareValue(TacumProd(Item1).cod, TacumProd(Item2).cod);
end;

function OrdenaPorDEPTacumProdDESC(Item1, Item2: pointer): Integer;
begin
  Result := -CompareValue(TacumProd(Item1).dep, TacumProd(Item2).dep);
end;

procedure TItensAcumProd.OrdenarLista(direcao : String = 'ASC');
begin
  Sort(OrdenaPorCodigoTacumProdASC);
end;

function TItensAcumProd.GetItems(Index: Integer): TacumProd;
begin
  Result := TacumProd(inherited Items[Index]);
end;

procedure TItensAcumProd.SetItems(Index: Integer;const Value: TacumProd);
begin
  inherited Items[Index] := Value; // Capturando o item do pedido
end;

function TItensAcumProd.Add(AObject: TacumProd): Integer;
begin
  Result := inherited Add(AObject); // Adicionando o produto
end;

function TItensAcumProd.Find(Cod : integer): Integer;
var
  ini, fim : integer;
begin
  Result := -1;
  fim    := Count -1;
  for ini := 0 to fim do
    begin
      if GetItems(ini).cod = Cod then
        begin
          Result := ini;
          break;
        end;
    end;
end;

function TItensAcumProd.getText() : String;
var
  ini : integer;
begin
  Result := '';
  for ini := 0 to Count -1 do
    begin
      Result := Result +'|'+ IntToStr(Items[ini].cod) + '|' + CurrToStr(Items[ini].quant)+ '|' + CurrToStr(Items[ini].dep)+'|' + #13;
    end;
end;
{Classe TItensAcumProd}


function TItensUnid.GetItems(Index: Integer): TUnid;
begin
  Result := TUnid(inherited Items[Index]);
end;

procedure TItensUnid.SetItems(Index: Integer;const Value: TUnid);
begin
  inherited Items[Index] := Value; // Capturando o item do pedido
end;

function TItensUnid.Add(AObject: TUnid): Integer;
begin
  Result := inherited Add(AObject); // Adicionando o produto
end;

function TItensUnid.Find(Cod : String): Integer;
var
  ini, fim : integer;
begin
  Result := -1;
  fim    := Count -1;
  for ini := 0 to fim do
    begin
      if GetItems(ini).unid_ent = Cod then
        begin
          Result := ini;
          break;
        end;
    end;
end;

function TItensUnid.getText() : String;
var
  ini : integer;
begin
  Result := '';
  for ini := 0 to Count -1 do
    begin
      Result := Result + Items[ini].unid_ent + ' ' + CurrToStr(Items[ini].valor) + #13;
    end;
end;
{Classe TItensUnid}

function TItensPISCOFINS.GetItems(Index: Integer): TacumPis;
begin
  Result := TacumPis(inherited Items[Index]);
end;

procedure TItensPISCOFINS.SetItems(Index: Integer;const Value: TacumPis);
begin
  inherited Items[Index] := Value; // Capturando o item do pedido
end;

function TItensPISCOFINS.Add(AObject: TacumPis): Integer;
begin
  Result := inherited Add(AObject); // Adicionando o produto
end;

function TItensPISCOFINS.Find(Cod : String): Integer;
var
  ini, fim : integer;
begin
  Result := -1;
  fim    := Count -1;
  for ini := 0 to fim do
    begin
      if GetItems(ini).cod = Cod then
        begin
          Result := ini;
          break;
        end;
    end;
end;

function TItensPISCOFINS.FindCFOP_CST_ALIQICMS(Cod, aliq : string): Integer;
var
  ini, fim : integer;
begin
  Result := -1;
  fim    := Count -1;
  for ini := 0 to fim do
    begin
      if ((GetItems(ini).cod = Cod) and (GetItems(ini).aliqICM = aliq)) then
        begin
          Result := ini;
          break;
        end;
    end;
end;


function TItensPISCOFINS.getText() : String;
var
  ini : integer;
begin
  Result := '';
  for ini := 0 to Count -1 do
    begin
      Result := Result + Items[ini].cod + '|' + CurrToStr(Items[ini].pis) + '|' + CurrToStr(Items[ini].cofins) + '|' +  Items[ini].CST +
      '|'+CurrToStr(Items[ini].total) + #13;
    end;
end;


end.
