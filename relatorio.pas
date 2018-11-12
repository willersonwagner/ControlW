unit relatorio;

interface

uses
  messages, windows, ComObj, ComCtrls, printers,
  Controls, SysUtils, Variants, Classes, Graphics,  Forms,
  Dialogs,Richedit, StdCtrls, CommCtrl, Buttons, ToolWin, ExtCtrls,
  funcoesDAV ;

type
  TForm19 = class(TForm)
    ToolBar1: TPanel;
    BitBtn2: TBitBtn;
    RichEdit1: TRichEdit;
    Label1: TLabel;
    SaveDialog1: TSaveDialog;
    Label2: TLabel;
    BitBtn3: TBitBtn;
    BitBtn4: TBitBtn;
    FindDialog1: TFindDialog;
    Label3: TLabel;
    PrinterSetupDialog1: TPrinterSetupDialog;
    procedure FormShow(Sender: TObject);
    procedure RichEdit1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn4Click(Sender: TObject);
    procedure FindDialog1Find(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure RichEdit1KeyPress(Sender: TObject; var Key: Char);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    PrintDialog1: TPrintDialog;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form19: TForm19;

implementation

uses func, imprime1, principal;

{$R *.dfm}

procedure TForm19.FormShow(Sender: TObject);
begin
  RichEdit1.SetFocus;
  RichEdit1.SelStart := 0;

  if RichEdit1.Font.Name <> 'Terminal' then begin
    RichEdit1.Font.Size := funcoes.fonteRelatorioForm19;
    if funcoes.NegritoRelatorioForm19 then RichEdit1.Font.Style := [fsBold];
  end;
end;

procedure TForm19.RichEdit1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key=114 then BitBtn4Click(sender);
  if (ssCtrl in Shift) and (chr(Key) in ['P', 'p']) then BitBtn1Click(sender);
  if (ssCtrl in Shift) and (chr(Key) in ['S', 's']) then BitBtn2Click(sender);
end;

procedure TForm19.BitBtn1Click(Sender: TObject);
begin
  if PrintDialog1 = nil then
    begin
      ShowMessage('Não existe impressoras instaladas neste computador');
      exit;
    end;


  TRY
      setPrinter(StrToIntDef(funcoes.LerConfig(form22.Pgerais.Values['imp'], 0), 0), funcoes.LerConfig(form22.Pgerais.Values['imp'], 15));
      //printer.PrinterIndex      := StrToIntDef(funcoes.LerConfig(form22.Pgerais.Values['imp'], 0), 0);
    except
    END;

  if not PrintDialog1.execute then exit;
  if ((RichEdit1.Font.Name = 'Terminal') or (RichEdit1.Font.Name = 'Courier New')) then
    begin
      RichEdit1.Lines.SaveToFile(caminhoEXE_com_barra_no_final+'texto.txt');
      imprime.textxArq('%');
    end
  else
    begin
      //imprime.imprime1(0, '11');//nao setar impressora
      imprime.textx('%');//nao setar impressora
    end;
end;

procedure TForm19.BitBtn2Click(Sender: TObject);
begin
  SaveDialog1.Title:='Salvar Relatório';
  SaveDialog1.Filter:='.Txt|*.txt|.Doc|*.doc';
  SaveDialog1.DefaultExt:='txt';
  SaveDialog1.FilterIndex:=1;
  if SaveDialog1.Execute then RichEdit1.Lines.SaveToFile(SaveDialog1.FileName);

end;

procedure TForm19.BitBtn4Click(Sender: TObject);
var i:integer;
begin

  RichEdit1.SelLength := 0;
  RichEdit1.SelStart := 0;
  FindDialog1.Execute;
end;

procedure TForm19.FindDialog1Find(Sender: TObject);
var
  FoundPos,x,
  StartSearch,
  EndSearch :LongInt;
  Options :TSearchTypes;
begin
  StartSearch :=RichEdit1.SelStart +RichEdit1.SelLength;
  EndSearch := Length(RichEdit1.Text);
  Options := [];
  if frMatchCase in FindDialog1.Options then
    Options := [stMatchCase];
  if frWholeWord in FindDialog1.Options then
    Options := Options + [stWholeWord];
  //FoundPos := pos(FindDialog1.FindText,RichEdit1.Text-(RichEdit1.SelStart +RichEdit1.SelLength));
  FoundPos := RichEdit1.FindText(FindDialog1.FindText, StartSearch, EndSearch, Options);
  //if FindDialog1.Options[up]
  if FoundPos <> -1 then
  begin
    RichEdit1.SelStart := FoundPos;
    RichEdit1.SelLength := Length(FindDialog1.FindText);
    //RichEdit1.SetFocus;
    RichEdit1.SelAttributes.Color := ClRed;
    RichEdit1.SelAttributes.Style := [fsBold];
    RichEdit1.Perform(EM_SCROLLCARET,0,SendMessage(RichEdit1.Handle,EM_LINEFROMCHAR,RichEdit1.Selstart,0)+10 );
  end
   else
     begin
          RichEdit1.SelLength := 0;
          RichEdit1.SelStart := 0;

        StartSearch :=RichEdit1.SelStart +RichEdit1.SelLength;
        EndSearch := Length(RichEdit1.Text);
        Options := [];
        if frMatchCase in FindDialog1.Options then
          Options := [stMatchCase];
        if frWholeWord in FindDialog1.Options then
          Options := Options + [stWholeWord];
        FoundPos := RichEdit1.FindText(FindDialog1.FindText, StartSearch, EndSearch, Options);
        if FoundPos <> -1 then
           begin
             RichEdit1.SelStart := FoundPos;
             RichEdit1.SelLength := Length(FindDialog1.FindText);
             RichEdit1.SelAttributes.Color := ClRed;
             RichEdit1.SelAttributes.Style := [fsBold];
             RichEdit1.Perform(EM_SCROLLCARET,0,SendMessage(RichEdit1.Handle,EM_LINEFROMCHAR,RichEdit1.Selstart,0)+10 );
           end;

     end;
end;

procedure TForm19.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  RichEdit1.Clear;
  RichEdit1.Font.Name:='Courier';
  RichEdit1.Font.Size:=10;
  RichEdit1.Font.Charset:=ANSI_CHARSET;
  FindDialog1.CloseDialog;
end;

procedure TForm19.RichEdit1KeyPress(Sender: TObject; var Key: Char);
begin
if key = #27 then close;
end;

procedure TForm19.FormCreate(Sender: TObject);
begin
  if printer.Printers.Count > 0 then PrintDialog1 := TPrintDialog.Create(self)
   else PrintDialog1 := nil;
end;

procedure TForm19.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (ssCtrl in Shift) and (chr(Key) in ['P', 'p']) then BitBtn3.Click;
end;

end.
