unit imprime1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, Printers,
  StdCtrls, ExtCtrls, imprNovo, ComCtrls, Richedit, charprinter, unit1, ACBrETQ, ACBrDevice,
  RLReport, RLBarcode, funcoesdav, RLRichText, Data.DB;

type

  Timprime = class(TForm)
    Image1a: TImage;
    Timer1: TTimer;
    Memo1: TMemo;
    rlVenda: TRLReport;
    rlbRodape: TRLBand;
    RLDraw2: TRLDraw;
    pGap05: TRLPanel;
    lSistema: TRLLabel;
    rlsbDetItem: TRLSubDetail;
    rlbDetItem: TRLBand;
    mLinhaItem: TRLMemo;
    rlbGap: TRLBand;
    rlsbPagamentos: TRLSubDetail;
    rlbPagamento: TRLBand;
    lPagamento: TRLLabel;
    lMeioPagamento: TRLLabel;
    rlbTroco: TRLBand;
    lTitTroco: TRLLabel;
    lTroco: TRLLabel;
    rlbTotal: TRLBand;
    lTitTotal: TRLLabel;
    lTotal: TRLLabel;
    lQtdItens: TRLLabel;
    lQtdTotalItensVal: TRLLabel;
    lTitFormaPagto: TRLLabel;
    lTitValorPago: TRLLabel;
    RLDraw7: TRLDraw;
    rlbsCabecalho: TRLSubDetail;
    rlbDadosCliche: TRLBand;
    pLogoeCliche: TRLPanel;
    lEndereco: TRLMemo;
    imgLogo: TRLImage;
    lNomeFantasia: TRLMemo;
    lRazaoSocial: TRLMemo;
    rlbMensagemContribuinte: TRLBand;
    RLDraw3: TRLDraw;
    lObservacoes: TRLMemo;
    RLPanel1: TRLPanel;
    RLBarcode1: TRLBarcode;
    RLBand1: TRLBand;
    RLDraw4: TRLDraw;
    nota: TRLLabel;
    lCPF_CNPJ1: TRLLabel;
    Desconto: TRLBand;
    RLLabel2: TRLLabel;
    RLLabel3: TRLLabel;
    RLLabel4: TRLLabel;
    ldesconto: TRLLabel;
    dadosCliente: TRLBand;
    lcliente: TRLLabel;
    RLDraw8: TRLDraw;
    dadosNota: TRLBand;
    ldadosNota: TRLLabel;
    RLDraw1: TRLDraw;
    RLDraw5: TRLDraw;
    RLReport1: TRLReport;
    RLBand2: TRLBand;
    RLBand3: TRLBand;
    RLPanel2: TRLPanel;
    RLMemo1: TRLMemo;
    RLMemo2: TRLMemo;
    RLMemo3: TRLMemo;
    RLDraw6: TRLDraw;
    RLLabel1: TRLLabel;
    RLLabel5: TRLLabel;
    RLDraw9: TRLDraw;
    RLDraw10: TRLDraw;
    RLLabel6: TRLLabel;
    RLBand4: TRLBand;
    RLDraw11: TRLDraw;
    RLPanel3: TRLPanel;
    RLLabel7: TRLLabel;
    RLPanel4: TRLPanel;
    RLBarcode2: TRLBarcode;
    RLLabel8: TRLLabel;
    RLReport2: TRLReport;
    RLMemo4: TRLMemo;
    RLPanel5: TRLPanel;
    RLBand5: TRLBand;
    RLBand6: TRLBand;
    RLBand7: TRLBand;
    RLBand8: TRLBand;
    RLLabel9: TRLLabel;
    RLLabel10: TRLLabel;
    RLLabel11: TRLLabel;
    RLLabel12: TRLLabel;
    RLLabel13: TRLLabel;
    RLLabel14: TRLLabel;
    RLLabel15: TRLLabel;
    RLLabel16: TRLLabel;
    DataSource1: TDataSource;
    RLDBText1: TRLDBText;
    RLDBText2: TRLDBText;
    RLDBText3: TRLDBText;
    RLDBText4: TRLDBText;
    RLSystemInfo1: TRLSystemInfo;
    RLDraw12: TRLDraw;
    procedure Timer1Timer(Sender: TObject);
    procedure RLBand7BeforePrint(Sender: TObject; var PrintIt: Boolean);
  private
    tipo : integer;
    procedure MudaTamPapel(PaperSize, Comp, Alt: integer);
    Function PrinterOnLine : Boolean;
    Procedure PrintRichEdit(const Caption: string;const RichEdt: TRichEdit);
    { Private declarations }
  public
    negrito : boolean;
    fontDif, imprimiu : boolean;
    tamaFonte, tamFontePadrao : integer;
    cod, espac_dire, IndexImpressora : String;
    procedure impTxtMatricialUSB(ImplinhasFinal : boolean = true);
    procedure impTxtTAP(var texto : TStringList);
    procedure AtivarACBrETQ ;
    procedure SetPrinterPage(Width, Height : LongInt);
    function setCofiguracoesImpressora() : String;
    procedure textx(arquivo:string; ImplinhasFinal : boolean = true);
    procedure textxArq(arquivo:string; VENDA : BOOLEAN = FALSE);
    procedure setFonte(valor : integer);
    function imprime1(tamFonte : integer = 0; tip : String = ''; ImplinhasFinal : boolean = true) : String;
    function imprimeCANVAS : String;
    procedure verificaConfImp();
    procedure setConfigRichedit();
    procedure ImprimeLivreDireto(qtdVias, cod : integer; tipoEtiqueta : integer = 1);
    procedure completaPagina();
    procedure imprimeRLReport();
    { Public declarations }
  end;

var
  imprime: Timprime;
  PrintText, F : TextFile;
  test : integer;
  function at(ch : string; lin : string) : integer ;
  function abs_texto(lin : string) : string ;


implementation

uses relatorio, func, principal, StrUtils;


{$R *.DFM}

procedure Timprime.impTxtMatricialUSB(ImplinhasFinal : boolean = true);
var
  Prn : TAdvancedPrinter;
  linha, confImp : string;
  fim, ini : integer;
begin
  confImp := setCofiguracoesImpressora();
  Prn := TAdvancedPrinter.Create;
  Prn.OpenDoc ('Impressão TEXTO.TXT');

  //Prn.SendData(#27'@');

  if funcoes.LerConfig(confImp, 6) = 'S' then Prn.Write(#15); //usar fonte reduzida
//    else Prn.SendData('  ');

  //Prn.SendData('  ');

  fim := form19.RichEdit1.Lines.Count -1;
  funcoes.informacao(0, fim, 'Aguarde, Imprimindo...', true, false, 5 );

  for ini := 0 to fim do
    begin
      funcoes.informacao(ini, fim, 'Aguarde, Imprimindo...', false, false, 5 );
      linha := form19.RichEdit1.Lines[ini];
      //linha := funcoes.CompletaOuRepete('', '', ' ', StrToIntDef(funcoes.LerConfig(confImp, 3), 0)) + Trim(form19.RichEdit1.Lines[ini]);
      linha := abs_texto(linha);
      if length(linha) > 0 then
        begin
          Prn.Write(linha);
          prn.CRLF;
        end;
    end;

  if ImplinhasFinal then begin
    fim := StrToIntDef(funcoes.LerConfig(confImp, 2), 0);
    linha := CRLF;
    //ShowMessage(IntToStr(fim));

    for ini := 0 to fim do begin
      Prn.Write(linha);
    end;
  end
  else begin
    Writeln(PrintText, '-');
    Writeln(PrintText, '-');
  end;

  funcoes.informacao(0, fim, 'Aguarde, Imprimindo...', false, true, 5 );
  test := 0;
  Prn.CloseDoc;
  Prn.Free;
end;

procedure Timprime.setConfigRichedit();
var
  ini : integer;
begin
  printer.Canvas.Font.Charset := OEM_CHARSET;
  Form19.RichEdit1.Font := memo1.Font;
  Form19.RichEdit1.Font.Size:= StrToIntDef(funcoes.LerConfig(form22.Pgerais.Values['imp'], 4), 11);
  if funcoes.LerConfig(form22.Pgerais.Values['imp'], 5) = 'S' then Form19.RichEdit1.Font.Style := [fsbold];

  //for ini := 0 to StrToIntDef(funcoes.LerConfig(form22.Pgerais.Values['imp'], 7), 0) do form19.RichEdit1.Lines.Insert(0, ' ');
  for ini := 0 to StrToIntDef(funcoes.LerConfig(form22.Pgerais.Values['imp'], 2), 0) do addRelatorioForm19(' ' + CRLF);
  form19.RichEdit1.SelStart := 0;
end;

procedure Timprime.verificaConfImp();
var
  arq : TStringList;
begin
  arq := TStringList.Create;
end;

Procedure Timprime.PrintRichEdit(const Caption: string;const RichEdt: TRichEdit);
// Requer a Printers e RichEdit declaradas na clausula uses da unit
var
  Range: TFormatRange;
  LastChar, MaxLen, LogX, LogY, OldMap, ini, fim, lin, he, pag : Integer;
  linha : String;
  cont : integer;
begin
  cont := 0;

  while True do begin
    cont := cont + 1;
    if cont >= 30 then begin
      ShowMessage('A Impressora Está Ocupada!');
      exit;
    end;

    TRY
      setPrinter(StrToIntDef(funcoes.LerConfig(form22.Pgerais.Values['imp'], 0), 0), funcoes.LerConfig(form22.Pgerais.Values['imp'], 15));
      //printer.PrinterIndex      := StrToIntDef(funcoes.LerConfig(form22.Pgerais.Values['imp'], 0), 0);
    except
    END;

    //if printer.Printing = false then break;
    try
      //printer.PrinterIndex      := StrToIntDef(funcoes.LerConfig(form22.Pgerais.Values['imp'], 0), 0);
      Printer.Canvas.Font.Name := 'Courier New';
      printer.Canvas.Font.Size  := StrToIntDef(funcoes.LerConfig(form22.Pgerais.Values['imp'], 4), 11);
      if funcoes.LerConfig(form22.Pgerais.Values['imp'], 5) = 'S' then printer.Canvas.Font.Style := [fsbold];
      PRINTER.Title := Caption;

      printer.BeginDoc;
      Range.hdc := Handle;
      break;
    except
    end;
    Sleep(1000);
  end;

  FillChar(Range, SizeOf(TFormatRange), 0);
  with Printer, Range do
    begin
      hdcTarget := hdc;

      LogX := GetDeviceCaps(Handle, LOGPIXELSX);
      LogY := GetDeviceCaps(Handle, LOGPIXELSY);

     { if IsRectEmpty(RichEdt.PageRect) then
        begin
          rc.right  := PageWidth * 1440 div LogX;
          rc.bottom := PageHeight * 1440 div LogY;
        end
      else
        begin
          rc.left   := RichEdt.PageRect.Left   * 1440 div LogX;
          rc.top    := RichEdt.PageRect.Top    * 1440 div LogY;
          rc.right  := RichEdt.PageRect.Right  * 1440 div LogX;
          rc.bottom := RichEdt.PageRect.Bottom * 1440 div LogY;
        end;


      pag := printer.PageHeight;
      rcPage := rc;
      Title := Caption;
      LastChar := 0;
      MaxLen := RichEdt.GetTextLen;
      chrg.cpMax := -1;
      OldMap := SetMapMode(hdc, MM_TEXT);
      SendMessage(RichEdt.Handle, EM_FORMATRANGE, 0, 0);
      }
      try
        funcoes.informacao(0, MaxLen, 'Aguarde, Imprimindo...', true, false, 5 );
        fim := RichEdt.Lines.Count - 1;

        he := printer.Canvas.TextHeight('s');
        lin := 0;

        for ini :=  0 to fim do
          begin
            funcoes.informacao(ini, fim, 'Aguarde, Imprimindo...', false, false, 5 );
            lin := lin + he;

            linha := RichEdt.Lines[ini];
            linha := abs_texto(linha);
            LINHA := replicate(' ', StrToIntDef(funcoes.LerConfig(form22.Pgerais.Values['imp'], 3), 0)) + LINHA;
            printer.Canvas.TextOut(0, lin, linha);

            if funcoes.Contido(#12, RichEdt.Lines[ini]) then
              begin
                printer.NewPage;
                lin := 0;
              end;
          end;

        printer.EndDoc;
      finally
      funcoes.informacao(0, MaxLen, 'Aguarde, Imprimindo...', false, true, 5 );
     { SendMessage(RichEdt.Handle, EM_FORMATRANGE, 0, 0);
      SetMapMode(hdc, OldMap);
    }end;
  end;
end;


procedure Timprime.RLBand7BeforePrint(Sender: TObject; var PrintIt: Boolean);
begin
  if rlband7.Color = clwhite then rlband7.Color := cl3dlight else
  rlband7.Color := clwhite;
end;

function Timprime.setCofiguracoesImpressora() : String;
var
  tmp      : string;
  ini, fim, impTer : integer;
  ADevice, ADriver, APort: array[0..255] of char;
  DeviceMode: THandle;
  M: PDevMode;
  s: string;
  PaperSize, Alt : integer;
begin
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

  Result := '';
  tmp := form22.Pgerais.Values['imp'];
  Result := tmp;

  printer.Canvas.Font       := Memo1.Font;

  impTer := StrToIntDef(funcoes.LerConfig(form22.Pgerais.Values['conf_ter'], 5), 0);
  if tipo <> 33 then
    begin
      setPrinter(StrToIntDef(funcoes.LerConfig(form22.Pgerais.Values['imp'], 0), 0), funcoes.LerConfig(form22.Pgerais.Values['imp'], 15));
      //printer.PrinterIndex      := StrToIntDef(funcoes.LerConfig(tmp, 0), 0);
    end;

  printer.Canvas.Font.Size  := StrToIntDef(funcoes.LerConfig(tmp, 4), 11);
  if funcoes.LerConfig(tmp, 5) = 'S' then printer.Canvas.Font.Style := [fsbold];
  printer.Canvas.Font.Charset := OEM_CHARSET;

  //for ini := 0 to StrToIntDef(funcoes.LerConfig(tmp, 7), 0) do form19.RichEdit1.Lines.Insert(0,'');

  //fim := Memo1.Lines.Count -1;
  {for ini := 0 to fim do
    begin
      Memo1.Lines[ini] := funcoes.CompletaOuRepete('', '', ' ', StrToIntDef(funcoes.LerConfig(tmp, 3), 2)) + Memo1.Lines[ini];
    end;
   }
  //for ini := 0 to StrToIntDef(funcoes.LerConfig(tmp, 2), 0) do form19.RichEdit1.Lines.Add('');
  form19.RichEdit1.SelStart := 0;
end;

function Timprime.imprimeCANVAS : String;
begin
  //Printer.Title := 'Impressão ControlW';
  setConfigRichedit();
  form19.RichEdit1.Print('Impressão ControlW');
end;

procedure Timprime.SetPrinterPage(Width, Height : LongInt);
var
  Device : array[0..255] of char;
  Driver : array[0..255] of char;
  Port : array[0..255] of char;
  hDMode : THandle;
  PDMode : PDEVMODE;
begin
  Printer.GetPrinter(Device, Driver, Port, hDMode);

  If hDMode <> 0 then
    begin
      pDMode := GlobalLock( hDMode );
      If pDMode <> nil then
        begin
          pDMode^.dmPaperSize := DMPAPER_USER;
          pDMode^.dmPaperWidth := Width;
          pDMode^.dmPaperLength := Height;
          pDMode^.dmFields := pDMode^.dmFields or DM_PAPERSIZE;
          GlobalUnlock( hDMode );
        end;

    end;
end;

function Timprime.imprime1(tamFonte : integer = 0; tip : String = ''; ImplinhasFinal : boolean = true) : String;
var
  linha, arq, tmp, confImp, EscAutoNewPageOff, lpt : string;
  ini, fim : integer;
  ForcFechamento : boolean;
begin
  //1 - tipo de impressao *** 0-USB1 1-UBS2 2-LPT1 3-LPT2   ***

  if arq = '' then arq := 'TEXTO.TXT';

  tmp := form22.Pgerais.Values['conf_ter'];
  if tip = '' then
    begin
      tip := funcoes.LerConfig(confImp, 1);
      confImp := setCofiguracoesImpressora();
    end;

  if tip = '11' then begin
    printer.Canvas.Font.Size  := StrToIntDef(funcoes.LerConfig(form22.Pgerais.Values['imp'], 4), 11);
    if funcoes.LerConfig(form22.Pgerais.Values['imp'], 5) = 'S' then printer.Canvas.Font.Style := [fsbold];
    printer.Canvas.Font.Charset := OEM_CHARSET;

    if funcoes.LerConfig(form22.Pgerais.Values['imp'], 1) = '5' then begin
      impTxtMatricialUSB(ImplinhasFinal);
      tipo := 0;
      exit;
    end;
  end;

  // Ler as configurações do terminal e ver se a impressao é USB ou LPT1
  if tip = '2' then
    begin
      AssignFile(PrintText, 'LPT1');
    end
  else if funcoes.LerConfig(confImp, 1) = '3' then
    begin
      AssignFile(PrintText, 'LPT2');
    end
   else if funcoes.LerConfig(form22.Pgerais.Values['imp'], 1) = '4' then
    begin
      lpt := funcoes.buscaConfigNaPastaDoControlW('impress_rede', '\\127.0.0.1\generica');
      if lpt = '\\127.0.0.1\generica' then
        begin
          ShowMessage('Impressão Direta no Compartilhamento de Rede Não ' + #13 +
          'Está Configurada Corretamente. Contate o Suporte para efetuar a Configuração.');
          exit;
        end;

      AssignFile(PrintText, lpt);
    end
  else
    begin
      if not verificaSeTemImpressora then
        begin
          ShowMessage('Não existe impressora neste computador');
          exit;
        end;
      AssignPrn(PrintText);
    end;

  tamFontePadrao := Printer.Canvas.Font.Size;
  Printer.Canvas.Font.Name := 'Courier New';
  printer.title := 'Impressão Relatório: ' + arq;

  try
    Rewrite(PrintText);
    Writeln(PrintText, '  ');
  except
    //CloseFile(PrintText);
    exit;
  end;

  if funcoes.LerConfig(confImp, 6) = 'S' then
    begin
      Writeln(PrintText, #15 + '  '); //usar fonte reduzida
      printer.Canvas.Font.Size := 7;
    end
  else Writeln(PrintText, '  ');

  Writeln(PrintText, '  ');

  fim := StrToIntDef(funcoes.LerConfig(form22.Pgerais.Values['imp'], 7), 0);

  for ini := 0 to fim do begin
    Writeln(PrintText, ' ');
  end;

  fim := form19.RichEdit1.Lines.Count -1;
  funcoes.informacao(0, fim, 'Aguarde, Imprimindo...', true, false, 5 );

  for ini := 0 to fim do
    begin
      funcoes.informacao(ini, fim, 'Aguarde, Imprimindo...', false, false, 5 );
      linha := funcoes.CompletaOuRepete('', '', ' ', StrToIntDef(funcoes.LerConfig(confImp, 3), 0)) + Trim(form19.RichEdit1.Lines[ini]);
      linha := abs_texto(linha);
      if length(linha) > 0 then Writeln(PrintText, linha);
    end;

  if ImplinhasFinal then begin
    fim := StrToIntDef(funcoes.LerConfig(form22.Pgerais.Values['imp'], 2) , 2);
    fim := fim -1;
    for ini := 0 to fim do begin
      Writeln(PrintText, '-');
    end;
  end
  else begin
    Writeln(PrintText, '-');
    Writeln(PrintText, '-');
  end;

  funcoes.informacao(0, fim, 'Aguarde, Imprimindo...', false, true, 5 );
  test := 0;
  CloseFile(PrintText);
end;

Function Timprime.PrinterOnLine : Boolean;
Const
PrnStInt : Byte = $17;
StRq : Byte = $02;
PrnNum : Word = 0; { 0 para LPT1, 1 para LPT2,
etc. }
Var
nResult : byte;
Begin
Asm
mov ah,StRq;
mov dx,PrnNum;
Int $17;
mov nResult,ah;
end;
PrinterOnLine := (nResult and $80) = $80;
end;

procedure Timprime.setFonte(valor : integer);
begin
  fontDif := TRUE;
  tamaFonte := valor;
end;


procedure timprime.textx(arquivo:string; ImplinhasFinal : boolean = true);
var
  cont : Smallint;
begin
   if arquivo = '%' then tipo := 33;
   //faz isso se escolheu a impressora
   // ai nao seta impressora na impressao

   if funcoes.LerConfig(form22.Pgerais.Values['imp'], 1) = '7' then
    begin
      imprimeRLReport;
      EXIT;
    end;

  if funcoes.LerConfig(form22.Pgerais.Values['imp'], 1) = '6' then
    begin
      PrintRichEdit('IMPRESSAO', FORM19.RichEdit1);
      EXIT;
    end;
  
  if funcoes.LerConfig(form22.Pgerais.Values['imp'], 1) = '5' then
    begin
      impTxtMatricialUSB(ImplinhasFinal);
      tipo := 0;
      exit;
    end;

  if funcoes.LerConfig(form22.Pgerais.Values['imp'], 1) = '1' then
    begin
      imprimeCANVAS(); //richedit1.print(), imprime direto no richedit
      tipo := 0;
      exit;
    end;


  imprime1(0, '',ImplinhasFinal);
  tipo := 0;
  exit;

  imprimiu := false;
  Timer1.Enabled := true;

  cont := 0;
  while true do
    begin
      sleep(100);
      Application.ProcessMessages;
      cont := cont + 1;

      if ((cont > 100) or (imprimiu)) then break;
    end;
  if not imprimiu then ShowMessage('Impressora Não Preparada. Verifique se a impressora está ligada');
end;

procedure timprime.textxArq(arquivo:string; VENDA : BOOLEAN = FALSE);
var
  linha, arq, tmp, confImp : string;
  ini,fim : integer;
  printer1 : TPrinter;
begin

  if arquivo = '@' then begin
    confImp := setCofiguracoesImpressora;
  end;

  //WinExec(pchar(caminhoEXE_com_barra_no_final + 'Imprime.exe ' +  'TEXTO.TXT'), SW_NORMAL);
  //exit;
  if not verificaSeTemImpressora() then
    begin
      ShowMessage('Não existe impressora neste computador');
      exit;
    end;
  arq := caminhoEXE_com_barra_no_final + 'TEXTO.TXT';

  if arquivo <> '%' then
    begin
      if funcoes.LerConfig(tmp, 5) <> '' then begin
         setPrinter(StrToIntDef(funcoes.LerConfig(form22.Pgerais.Values['imp'], 0), 0), funcoes.LerConfig(form22.Pgerais.Values['imp'], 15));
        //printer.PrinterIndex := StrToIntDef(funcoes.LerConfig(tmp, 0), 0); //seta o indice da impressora, so se estiver preenchido
      end;
    end;

  try
   if FileExists(arq) then DeleteFile(arq);
  except
  end;

  //setCofiguracoesImpressora;
  form19.RichEdit1.Lines.SaveToFile(arq);
  AssignPrn(PrintText);
  AssignFile(F, arq);
  Reset(F);
  printer.canvas.font := Memo1.Font;
  Printer.Canvas.Font.Name := 'Courier New';
  //Printer.Canvas.Font.Name := 'Courier';
  Printer.Canvas.Font.Charset := OEM_CHARSET;
  printer.canvas.font.size := 11;

  if negrito then printer.Canvas.Font.Style := [fsBold];

  printer.title := 'Impressão Relatório: ' + arq;
  Rewrite(PrintText);
  Writeln(PrintText, '  ');
  Writeln(PrintText, '  ');
  while not eof(f) do
    begin
      Readln(F, linha);
      if VENDA then linha := funcoes.CompletaOuRepete('', '', ' ', StrToIntDef(funcoes.LerConfig(confImp, 3), 0)) + LINHA;

      linha := abs_texto(linha);
      if length(linha) > 1 then Writeln(PrintText, '  ' + linha);
    end;
  test := 0;

  CloseFile(PrintText);
  CloseFile(f);
  negrito := false;
end;

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

function abs_texto(lin : string) : string ;
var
  ini, fim : integer; atual : string;
begin
    ini := 1;
    result := '';
    if lin = '' then lin := '  ';
    Result := lin;
    {
    for ini := 0 to fim do
    //while ini <= length(lin) do
      begin
         //atual := copy(lin, ini, 1);
         atual := lin[ini];

         if atual = #18 then
            begin
              printer.canvas.font.size := 11;
              //printer.canvas.font.height := 10;
              atual := '';
            end;

         if atual = #15 then
            begin
              if test = 1 then printer.canvas.font.size := 9
               else printer.canvas.font.size := 7;
              //printer.canvas.font.height := 10;
              atual := '';
              test := 0;
            end;

         if atual = #12 then
            begin
               //Printer.NewPage;
            end;
         result := result + atual;
         //ini := ini + 1;
      end; }

   if LeftStr(Trim(lin), 1) = '&' then
     begin
       result := #18 + copy(lin, 2, length(lin));
       //if test = 1 then printer.canvas.font.size := 9
       printer.canvas.font.size := imprime.tamFontePadrao;
     end;

   if LeftStr(Trim(lin), 1) = '%' then
     begin
       result := #15 + copy(lin, 2, length(lin));
       //if test = 1 then printer.canvas.font.size := 9
       printer.canvas.font.size := 7;
     end;

   if funcoes.Contido(#15, lin) then
     begin
       if test = 1 then printer.canvas.font.size := 9
         else printer.canvas.font.size := 7;
     end;

   if funcoes.Contido(#18, lin) then
     begin
       printer.canvas.font.size := 11;
     end;


   {if funcoes.Contido('/n', lin) then
     begin
       printer.NewPage;
       Result := copy(lin, 2, length(lin));
     end;}

   {if funcoes.Contido(#12, lin) then
     begin
       printer.NewPage;
     end;

   if LeftStr(Trim(lin), 1) = #12 then
   begin
     printer.NewPage;
   end;

   if LeftStr(Trim(lin), 1) = '$' then
     begin
       printer.NewPage;
       Result := copy(lin, 2, length(lin));
     end;        }
end;

procedure Timprime.Timer1Timer(Sender: TObject);
begin
  Timer1.Enabled := false;
  imprime1();
  imprimiu := true;
end;

procedure Timprime.MudaTamPapel(PaperSize, Comp, Alt: integer);
var
ADevice, ADriver, APort: array[0..255] of char;
DeviceMode: THandle;
M: PDevMode;
s: string;
begin
// Força o uso de Printer. Se esta linha for removida, a primeira
// invocação falha. Bug da VCL
S := Printer.Printers[Printer.PrinterIndex];
// Pega dados da impressora atual
Printer.GetPrinter(ADevice, ADriver, APort, DeviceMode);
// Pega um ponteiro para DEVMODE
M := GlobalLock(DeviceMode);
try
if M <> nil then
begin
// Muda tamanho do papel
M^.dmFields := DM_PAPERSIZE;
if PaperSize = DMPAPER_USER then
M^.dmFields := M^.dmFields or DM_PAPERLENGTH or DM_PAPERWIDTH;
M^.dmPaperLength := Alt;
M^.dmPaperWidth := Comp;
M^.dmPaperSize := PaperSize;//
// Atualiza
Printer.SetPrinter(ADevice, ADriver, APort, DeviceMode);
end;
finally
GlobalUnlock(DeviceMode);
end;
end;

procedure Timprime.ImprimeLivreDireto(qtdVias, cod : integer; tipoEtiqueta : integer = 1);
var
  Prn : TAdvancedPrinter;
  linha, confImp, nome, codbar, valor, unid : string;
  fim, ini : integer;
  inicio, avanc, atual : integer;
begin
  AtivarACBrETQ;

  tipoEtiqueta := StrToIntDef(funcoes.LerConfig(form22.Pgerais.Values['imp'], 12), 1);
  avanc        := StrToIntDef(funcoes.LerConfig(form22.Pgerais.Values['imp'], 11), 330);
  inicio       := 40;
  atual := 0;

  dm.IBselect.Close;
  dm.IBselect.SQL.Text := 'select * from produto where cod = :cod';
  dm.IBselect.ParamByName('cod').AsInteger := cod;
  dm.IBselect.Open;

  //nome   := Trim(LeftStr(dm.IBselect.fieldbyname('nome').AsString, 10));
  nome   := removeCarateresEspeciais(dm.IBselect.fieldbyname('nome').AsString);
  codbar := trim(dm.IBselect.fieldbyname('codbar').AsString);
  valor  := 'R$ ' + FormatCurr('#,###,###0.00', dm.IBselect.fieldbyname('p_venda').AsCurrency);
  unid   := 'Cod: ' +trim(dm.IBselect.fieldbyname('cod').AsString) + '  ' + valor;
  dm.IBselect.Close;

  if tipoEtiqueta = 1 then
    begin
      nome   := Trim(LeftStr(nome, 22));
      if dm.ACBrETQ1.Modelo = etqPpla then
        begin
          dm.ACBrETQ1.ImprimirTexto(orNormal,  2, 1, 2, 180, 15, nome);
          dm.ACBrETQ1.ImprimirTexto(orNormal,  2, 1, 1, 140, 15, unid);
          dm.ACBrETQ1.ImprimirBarras(orNormal, 'F', '2', '2', 20, 15, codbar, 70);

          dm.ACBrETQ1.ImprimirTexto(orNormal,  2, 1, 2, 180, 315, nome);
          dm.ACBrETQ1.ImprimirTexto(orNormal,  2, 1, 1, 140, 315, unid);
          dm.ACBrETQ1.ImprimirBarras(orNormal, 'F', '2', '2', 20, 315, codbar, 70);

          dm.ACBrETQ1.ImprimirTexto(orNormal,  2, 1, 2, 180, 615, nome);
          dm.ACBrETQ1.ImprimirTexto(orNormal,  2, 1, 1, 140, 615, unid);
          dm.ACBrETQ1.ImprimirBarras(orNormal, 'F', '2', '2', 20, 615, codbar, 70);
        end
      else
        begin
          {
           nome empresa
           | || || | || |
           nome produto
           cod: xxxx R$ 0,00
          }

          nome  := trim(copy(nome, 1, 20));
          nome := StringReplace(nome, '"', '', [rfReplaceAll, rfIgnoreCase]);

          dm.ACBrETQ1.ImprimirTexto(orNormal, 2, 1, 1, 15, inicio, form22.Pgerais.Values['empresa']);
          dm.ACBrETQ1.ImprimirBarras(orNormal, 'E30', '2', '2', 45, inicio, codbar, 080, becSIM);
          dm.ACBrETQ1.ImprimirTexto(orNormal,  1, 1, 1, 150, inicio, nome);
          dm.ACBrETQ1.ImprimirTexto(orNormal, 1, 1, 1, 170, inicio, unid);

          atual := atual + avanc;
          dm.ACBrETQ1.ImprimirTexto(orNormal, 2, 1, 1, 15, inicio + atual, form22.Pgerais.Values['empresa']);
          dm.ACBrETQ1.ImprimirBarras(orNormal, 'E30', '2', '2', 45, inicio + atual, codbar, 080, becSIM);
          dm.ACBrETQ1.ImprimirTexto(orNormal,  1, 1, 1, 150, inicio + atual, nome);
          dm.ACBrETQ1.ImprimirTexto(orNormal, 1, 1, 1, 170, inicio + atual, unid);

          atual := atual + avanc;
          dm.ACBrETQ1.ImprimirTexto(orNormal, 2, 1, 1, 15, inicio + atual, form22.Pgerais.Values['empresa']);
          dm.ACBrETQ1.ImprimirBarras(orNormal, 'E30', '2', '2', 45, inicio + atual, codbar, 080, becSIM);
          dm.ACBrETQ1.ImprimirTexto(orNormal,  1, 1, 1, 150, inicio + atual, nome);
          dm.ACBrETQ1.ImprimirTexto(orNormal, 1, 1, 1, 170, inicio + atual, unid);

          {dm.ACBrETQ1.ImprimirTexto(orNormal, 2, 1, 3, 15, inicio, nome);
          dm.ACBrETQ1.ImprimirTexto(orNormal, 2, 1, 1, 80, inicio, unid);
          dm.ACBrETQ1.ImprimirBarras(orNormal, 'E30', '2', '2', 120, inicio, codbar, 080, becSIM);

          atual := atual + avanc;
          dm.ACBrETQ1.ImprimirTexto(orNormal, 2, 1, 3, 15, inicio + atual, nome);
          dm.ACBrETQ1.ImprimirTexto(orNormal, 2, 1, 1, 80, inicio + atual, unid);
          dm.ACBrETQ1.ImprimirBarras(orNormal, 'E30', '2', '2', 120, inicio + atual, codbar, 080, becSIM);

          atual := atual + avanc;
          dm.ACBrETQ1.ImprimirTexto(orNormal, 2, 1, 3, 15, inicio + atual, nome);
          dm.ACBrETQ1.ImprimirTexto(orNormal, 2, 1, 1, 80, inicio + atual, unid);
          dm.ACBrETQ1.ImprimirBarras(orNormal, 'E30', '2', '2', 120, inicio + atual, codbar, 080, becSIM);}
        end ;
    end
  else if tipoEtiqueta = 0 then //etiqueta simples
    begin
      nome   := Trim(LeftStr(nome, 26));
      if dm.ACBrETQ1.Modelo = etqPpla then
        begin
          dm.ACBrETQ1.ImprimirTexto(orNormal, 2, 2, 2, 190, 5, nome);
          dm.ACBrETQ1.ImprimirTexto(orNormal, 2, 2, 1, 158, 5, unid);
          dm.ACBrETQ1.ImprimirBarras(orNormal, 'F', '2', '2', 32, 0, codbar, 90, becSIM);
          dm.ACBrETQ1.ImprimirTexto(orNormal, 3, 3, 2, 15, 300, 'R$');
          dm.ACBrETQ1.ImprimirTexto(orNormal, 3, 4, 4, 15, 450, valor);
        end
      else
        begin
          dm.ACBrETQ1.ImprimirTexto(orNormal, 2, 2, 2, 15, 55, nome);
          dm.ACBrETQ1.ImprimirTexto(orNormal, 3, 2, 1, 60, 55, unid);
          dm.ACBrETQ1.ImprimirBarras(orNormal, 'E30', '2', '2', 95, 55, codbar, 90, becSIM);
          dm.ACBrETQ1.ImprimirTexto(orNormal, 3, 3, 2, 110, 355, 'R$');
          dm.ACBrETQ1.ImprimirTexto(orNormal, 3, 4, 5, 85, 515, valor);
        end;
    end
  else
    begin
      nome   := Trim(LeftStr(nome, 26));
      if dm.ACBrETQ1.Modelo = etqPpla then
        begin
          dm.ACBrETQ1.IniciarEtiqueta;
          dm.ACBrETQ1.ImprimirTexto(orNormal, 2, 2, 2, 190, 5, nome);
          dm.ACBrETQ1.ImprimirTexto(orNormal, 2, 2, 1, 158, 5, unid);
          dm.ACBrETQ1.ImprimirBarras(orNormal, 'F', '2', '2', 32, 0, codbar, 90, becSIM);
          dm.ACBrETQ1.ImprimirTexto(orNormal, 3, 3, 2, 15, 300, 'R$');
          dm.ACBrETQ1.ImprimirTexto(orNormal, 3, 4, 4, 15, 450, valor);
          dm.ACBrETQ1.FinalizarEtiqueta(1, 600);
        end
      else
        begin
          dm.ACBrETQ1.IniciarEtiqueta;
          dm.ACBrETQ1.ImprimirTexto(orNormal, 2, 2, 2, 15, 55, nome);
          dm.ACBrETQ1.ImprimirTexto(orNormal, 3, 2, 1, 60, 55, unid);
          dm.ACBrETQ1.ImprimirBarras(orNormal, 'E30', '2', '2', 95, 55, codbar, 90, becSIM);
          dm.ACBrETQ1.ImprimirTexto(orNormal, 3, 3, 2, 110, 355, 'R$');
          dm.ACBrETQ1.ImprimirTexto(orNormal, 3, 4, 5, 85, 515, valor);
          dm.ACBrETQ1.FinalizarEtiqueta(1, 600);
        end;
    end;

  dm.ACBrETQ1.Imprimir(qtdVias, 600);
  dm.ACBrETQ1.Desativar;
end;


procedure Timprime.AtivarACBrETQ ;
begin
  if dm.ACBrETQ1.Ativo then dm.ACBrETQ1.Desativar; 
  with dm.ACBrETQ1 do
  begin
     DPI           := dpi203;
     LimparMemoria := true;
     //Modelo := etqEpl2;
     Ativar ;
  end ;
end ;

procedure Timprime.impTxtTAP(var texto : TStringList);
var
  Prn : TAdvancedPrinter;
  ini, fim : integer;
begin
  Prn := TAdvancedPrinter.Create;
  Prn.OpenDoc ('');

  for ini := 0 to texto.Count -1 do
    begin
      Prn.Write(texto[ini]);
    end;

  Prn.CloseDoc;
  Prn.Free;
end;

procedure Timprime.completaPagina();
begin

end;


procedure Timprime.imprimeRLReport();
var
  ini, fim : integer;
  lin : String;
begin
  //dm.
  fim := form19.RichEdit1.Lines.Count -1;
  {RLMemo5.Font := memo1.Font;
  RLMemo5.Font.Size := StrToIntDef(funcoes.LerConfig(form22.Pgerais.Values['imp'], 4), 11);
  if funcoes.LerConfig(form22.Pgerais.Values['imp'], 5) = 'S' then RLMemo5.Font.Style := [fsbold];

  //for ini := 0 to StrToIntDef(funcoes.LerConfig(form22.Pgerais.Values['imp'], 7), 0) do form19.RichEdit1.Lines.Insert(0, ' ');
  //for ini := 0 to StrToIntDef(funcoes.LerConfig(form22.Pgerais.Values['imp'], 2), 0) do addRelatorioForm19(' ' + CRLF);
  form19.RichEdit1.SelStart := 0;

  RLReport2.Margins.LeftMargin := 1;

  funcoes.informacao(0, fim, 'Aguarde, Imprimindo...', true, false, 5 );

  RLMemo5.Lines.Clear;
  for ini := 0 to fim do
    begin
      funcoes.informacao(ini, fim, 'Aguarde, Imprimindo...', false, false, 5 );
      lin := form19.RichEdit1.Lines[ini];
      if funcoes.Contido(#15, lin) then begin
        if test = 1 then RLMemo5.font.size := 9
          else RLMemo5.font.size := 7;
      end;

      RLMemo5.Lines.Text := RLMemo5.Lines.Text + lin;
    end;

  funcoes.informacao(0, fim, 'Aguarde, Imprimindo...', false, true, 5 );
  RLReport2.PrintDialog := true;
  RLReport2.Print; }
end;

end.

