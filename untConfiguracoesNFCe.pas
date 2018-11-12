unit untConfiguracoesNFCe;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, ExtCtrls, Mask,
  Buttons, OleCtrls, ShellAPI, FileCtrl, IniFiles, ACBrPosPrinter, printers,
  untnfce, pcnConversao, TypInfo, JsEdit1, JsEditNumero1;

type
  TfrmConfiguracoesNFe = class(TForm)
    Panel5: TPanel;
    OpenDlg: TOpenDialog;
    BtnOK: TBitBtn;
    BtnCancelar: TBitBtn;
    PageControl1: TPageControl;
    PageControl3: TPageControl;
    TabSheet3: TTabSheet;
    GroupBox3: TGroupBox;
    Label13: TLabel;
    Label14: TLabel;
    btnAbrirCertificadoA1: TSpeedButton;
    Label25: TLabel;
    btnAbrirCertificadoA3: TSpeedButton;
    edtcaminhocert: TEdit;
    edtsenhacert: TEdit;
    edtnumeroseriecert: TEdit;
    TabSheet4: TTabSheet;
    GroupBox6: TGroupBox;
    Label15: TLabel;
    btnAbrirLogomarca: TSpeedButton;
    btnAbrirLog: TSpeedButton;
    edtLogmarcaGeral: TEdit;
    edtSalvarLogGeral: TEdit;
    rdgTipoDANFE: TRadioGroup;
    rdgFormaEmissao: TRadioGroup;
    rdgFinalidade: TRadioGroup;
    TabSheet5: TTabSheet;
    GroupBox7: TGroupBox;
    Label16: TLabel;
    ckVisualizar: TCheckBox;
    cbxUF: TComboBox;
    rdgTipoAmbiente: TRadioGroup;
    GroupBox8: TGroupBox;
    Label17: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    Label20: TLabel;
    edtHostProx: TEdit;
    edtPortaProx: TEdit;
    edtUsuarioProx: TEdit;
    edtSenhaProx: TEdit;
    TabSheet7: TTabSheet;
    GroupBox9: TGroupBox;
    Label38: TLabel;
    Label39: TLabel;
    Label40: TLabel;
    Label41: TLabel;
    Label42: TLabel;
    Label43: TLabel;
    edtSMTPEmail: TEdit;
    edtPortaEmail: TEdit;
    edtUsuarioSMTP: TEdit;
    edtSenhaEmail: TEdit;
    edtAssuntoEmail: TEdit;
    chkSeguroEmail: TCheckBox;
    MemMensagemEmail: TMemo;
    Label1: TLabel;
    edtArquivoPDF: TEdit;
    btnAbrirPDF: TSpeedButton;
    Label2: TLabel;
    edtArquivosNFe: TEdit;
    btnAbrirXML: TSpeedButton;
    TabSheet1: TTabSheet;
    GroupBox1: TGroupBox;
    Label4: TLabel;
    edtnucfop: TEdit;
    edtIDToken: TEdit;
    Label3: TLabel;
    edtToken: TEdit;
    Label5: TLabel;
    TabSheet2: TTabSheet;
    IndxImpCupom: TComboBox;
    Label6: TLabel;
    GroupBox2: TGroupBox;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    RadioButton3: TCheckBox;
    IndxImpNfe: TComboBox;
    Label7: TLabel;
    serie: TEdit;
    Label8: TLabel;
    ComboBox1: TComboBox;
    Label9: TLabel;
    PortaCOM: TEdit;
    Label10: TLabel;
    TabSheet6: TTabSheet;
    conexaoBD: TEdit;
    Label11: TLabel;
    pastaServidor: TEdit;
    Label12: TLabel;
    Panel1: TPanel;
    usarSerivodrRemoto: TCheckBox;
    tipoNFe: TComboBox;
    Label21: TLabel;
    previewNFCe: TCheckBox;
    Label22: TLabel;
    certificadoA3: TCheckBox;
    Panel2: TPanel;
    verificarNotas: TCheckBox;
    GroupBox4: TGroupBox;
    Label23: TLabel;
    LOGOWIDTH: TEdit;
    Label24: TLabel;
    logoheigth: TEdit;
    fonteEnde: TEdit;
    Label26: TLabel;
    FonteOutCampos: TEdit;
    Label27: TLabel;
    chkSalvar: TCheckBox;
    Label28: TLabel;
    fonteRazao: TEdit;
    impDescontoNFCe: TCheckBox;
    RadioButton4: TRadioButton;
    MargemEsquerda: JsEditNumero;
    Label29: TLabel;
    velocidade: TEdit;
    Label30: TLabel;
    procedure sbtnCaminhoCertClick(Sender: TObject);
    procedure sbtnGetCertClick(Sender: TObject);
    procedure BtnOKClick(Sender: TObject);
    procedure BtnCancelarClick(Sender: TObject);
    procedure btnAbrirLogomarcaClick(Sender: TObject);
    procedure btnAbrirLogClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnAbrirPDFClick(Sender: TObject);
    procedure btnAbrirXMLClick(Sender: TObject);
    procedure usarSerivodrRemotoClick(Sender: TObject);
  private
    { Private declarations }
    procedure CarregaDadosArquivo;
    procedure gravaConfig();
  public
    { Public declarations }
  end;

  function Configuracoes_NFCe(token : boolean = false):Boolean;

const
  SELDIRHELP = 1000;
 

var
  frmConfiguracoesNFe: TfrmConfiguracoesNFe;

implementation

uses ACBrNFe, ACBrNFeConfiguracoes, Math, ACBrDFe,
  ACBrDFeSSL, StrUtils, unit1;

{$R *.dfm}

function Configuracoes_NFCe(token : boolean = false):Boolean;
begin
 Result := false;
 try
  frmConfiguracoesNFe := TfrmConfiguracoesNFe.Create(nil);
  frmConfiguracoesNFe.IndxImpNfe.Items := printer.Printers;
  frmConfiguracoesNFe.IndxImpNfe.ItemIndex := 0;

  frmConfiguracoesNFe.IndxImpCupom.Items := printer.Printers;
  frmConfiguracoesNFe.IndxImpCupom.ItemIndex := 0;
  frmConfiguracoesNFe.Position := poScreenCenter;

  if token then
    begin
      frmConfiguracoesNFe.PageControl3.ActivePageIndex := 1;
    end;


  with frmConfiguracoesNFe do
   begin

    ShowModal;
    if ModalResult = mrok then Result := true;
   end;
 finally
  FreeAndNil(frmConfiguracoesNFe);
 end;
end;

procedure TfrmConfiguracoesNFe.sbtnCaminhoCertClick(Sender: TObject);
begin
 OpenDlg.Title := 'Selecione o Certificado';
 OpenDlg.DefaultExt := '*.pfx';
 OpenDlg.Filter := 'Arquivos PFX (*.pfx)|*.pfx|Todos os Arquivos (*.*)|*.*';
 OpenDlg.InitialDir := ExtractFileDir(application.ExeName);
 if OpenDlg.Execute then
  begin
   edtcaminhocert.Text := OpenDlg.FileName;
  end;
end;

procedure TfrmConfiguracoesNFe.sbtnGetCertClick(Sender: TObject);
begin
 {$IFNDEF ACBrNFeOpenSSL}
    edtnumeroseriecert.Text := dm.ACBrNFe.SSL.SelecionarCertificado;
 {$ENDIF}
end;

procedure TfrmConfiguracoesNFe.BtnOKClick(Sender: TObject);
var
 certificadoCaminho       :String;
 certificadoSenha         :String;
 certificadoNumeroSerie   :String;
 DANFETipo                :integer;
 DANFEFormaEmissao        :integer;
 DANFELogomarca           :String;
 FinalidadeNFe            :Integer;
 ArqLog                   :Boolean;
 CaminhoLog               :String;
 WebUF                    :String;
 WebAmbiente              :integer;
 WebVisualiza             :Boolean;
 ProxHost                 :String;
 ProxPorta                :String;
 ProxUser                 :String;
 ProxSenha                :String;
 EmailHost                :String;
 EmailPorta               :String;
 EmailUsuario             :String;
 EmailSenha               :String;
 EmailAssunto             :String;
 EmailSSL                 :Boolean;
 ArquivosPDF,
 ArquivosNFe              :String;
 CFOP                     :String;
 IdToken                  :String;
 Token                    :String;
 preview                  :boolean;
 tipoImpressao, indxImpressora :integer;
begin
 ModalResult := MrOK;
 //
 preview := RadioButton3.Checked;
 //if RadioButton3.Checked then preview                  := true
   //else preview := false;

 tipoImpressao := 0;
 if RadioButton2.Checked then tipoImpressao := 1
 else if RadioButton4.Checked then tipoImpressao := 2;

 indxImpressora           := IndxImpCupom.ItemIndex;
 certificadoCaminho       := edtcaminhocert.Text;
 certificadoSenha         := edtsenhacert.Text;
 certificadoNumeroSerie   := edtnumeroseriecert.Text;
 DANFETipo                := rdgTipoDANFE.ItemIndex;
 DANFEFormaEmissao        := rdgFormaEmissao.ItemIndex;
 DANFELogomarca           := edtLogmarcaGeral.Text;
 FinalidadeNFe            := rdgFinalidade.ItemIndex;
 ArqLog                   := chkSalvar.Checked;
 CaminhoLog               := edtSalvarLogGeral.Text;
 WebUF                    := cbxUF.Text;
 WebAmbiente              := rdgTipoAmbiente.ItemIndex;
 WebVisualiza             := ckVisualizar.Checked;
 ProxHost                 := edtHostProx.Text;
 ProxPorta                := edtPortaProx.Text;
 ProxUser                 := edtUsuarioProx.Text;
 ProxSenha                := edtSenhaProx.Text;
 EmailHost                := edtSMTPEmail.Text;
 EmailPorta               := edtPortaEmail.Text;
 EmailUsuario             := edtUsuarioSMTP.Text;
 EmailSenha               := edtSenhaEmail.Text;
 EmailAssunto             := edtAssuntoEmail.Text;
 EmailSSL                 := chkSeguroEmail.Checked;
 ArquivosPDF              := edtArquivoPDF.Text;
 ArquivosNFe              := edtArquivosNFe.Text;
 CFOP                     := edtnucfop.Text;
 IdToken                  := edtIDToken.Text;
 Token                    := edtToken.Text;
 //

 if pastaServidor.Text = '' then begin
   pastaServidor.Text := 'XX';
 end;

 if verificarNotas.Checked then begin
   if pastaServidor.Text = '' then pastaServidor.Text := 'XX';
 end;

 if pastaServidor.Text <> '' then begin
   query1.Close;
   query1.SQL.Text := 'update nfce set exportado = 1';
   query1.ExecSQL;

   query1.Transaction.Commit;
 end;

 GravarConfiguracao(certificadoCaminho,certificadoSenha,certificadoNumeroSerie, FinalidadeNFe,DANFETipo,DANFEFormaEmissao,DANFELogomarca,ArqLog,CaminhoLog,
                    WebUF,WebAmbiente,WebVisualiza,ProxHost,ProxPorta,ProxUser,ProxSenha,EmailHost,EmailPorta,EmailUsuario,EmailSenha,EmailAssunto,EmailSSL,
                    ArquivosPDF, ArquivosNFe, CFOP, IdToken, Token, indxImpressora, IndxImpNfe.ItemIndex, tipoImpressao, preview, 'COM1', '9600', '6', serie.Text,'1', IntToStr(ComboBox1.ItemIndex), PortaCOM.Text,
                    previewNFCe.Checked);


 gravaConfig;
 LerConfiguracaoNFCe();
end;

procedure TfrmConfiguracoesNFe.BtnCancelarClick(Sender: TObject);
begin
 ModalResult := mrCancel;
end;

procedure TfrmConfiguracoesNFe.btnAbrirLogomarcaClick(Sender: TObject);
begin
  OpenDlg.Title      := 'Selecione o Logo';
  OpenDlg.DefaultExt := '*.bmp';
  OpenDlg.Filter     := 'Arquivos BMP (*.bmp)|*.bmp|Todos os Arquivos (*.*)|*.*';
  OpenDlg.InitialDir := ExtractFileDir(application.ExeName);
  if OpenDlg.Execute then
  begin
    edtLogmarcaGeral.Text := OpenDlg.FileName;
  end;
end;

procedure TfrmConfiguracoesNFe.btnAbrirLogClick(Sender: TObject);
var
 Dir: string;
begin
 if Length(edtSalvarLogGeral.Text) <= 0 then Dir := ExtractFileDir(application.ExeName)
 else Dir := edtSalvarLogGeral.Text;
 if SelectDirectory(Dir, [sdAllowCreate, sdPerformCreate, sdPrompt],SELDIRHELP) then edtSalvarLogGeral.Text := Dir;
end;

procedure TfrmConfiguracoesNFe.CarregaDadosArquivo;
var
 IniFile                : String;
 Ini                    : TIniFile;
 Ok                     : Boolean;
 StreamMemo             : TMemoryStream;
 mmEmailMsg             : TMemo;
 ti                     : integer;
 CDCFOP,
 sUF                    : string;
begin
 //IniFile    := ChangeFileExt(Application.ExeName, '.ini');
 if FileExists(ExtractFileDir(ParamStr(0)) + '\ControlW.ini') then
   begin
     IniFile    := ExtractFileDir(ParamStr(0)) + '\ControlW.ini';
     //exit;
   end
 else
   begin
     IniFile    := ChangeFileExt( Application.ExeName, '.ini') ;
   end;
 Ini        := TIniFile.Create(IniFile);
 mmEmailMsg := TMemo.Create(nil);
 try
  {$IFDEF ACBrNFeOpenSSL}
   edtcaminhocert.Text                                  := Ini.ReadString('Certificado','Caminho' ,'') ;
   edtsenhacert.Text                                    := Ini.ReadString('Certificado','Senha'   ,'') ;
   edtnumeroseriecert.Text                              := Ini.ReadString('Certificado','NumSerie','') ;
  {$ELSE}
   edtnumeroseriecert.Text                              := Ini.ReadString('Certificado','NumSerie','') ;
  {$ENDIF}
   edtsenhacert.Text                                    := Ini.ReadString('Certificado','Senha','') ;
   rdgFormaEmissao.ItemIndex                            := Ini.ReadInteger('Geral','FormaEmissao',0) ;
   chkSalvar.Checked                                    := Ini.ReadBool('Geral','Salvar',True) ;
   edtSalvarLogGeral.Text                               := Ini.ReadString('Geral','PathSalvar','') ;
   CDCFOP                                               := Ini.ReadString('Geral','CFOP','') ;
   sUF                                                  := Ini.ReadString('WebService','UF','MG') ;

   cbxUF.ItemIndex                                      := cbxUF.Items.IndexOf(sUF);
   rdgTipoAmbiente.ItemIndex                            := Ini.ReadInteger('WebService','Ambiente',1) ;
   rdgFinalidade.ItemIndex                              := Ini.ReadInteger('Geral','Finalidade',0) ;
   ckVisualizar.Checked                                 := Ini.ReadBool('WebService','Visualizar',False) ;
   //
   edtHostProx.Text                                     := Ini.ReadString('Proxy','Host','') ;
   edtPortaProx.Text                                    := Ini.ReadString('Proxy','Porta','') ;
   edtUsuarioProx.Text                                  := Ini.ReadString('Proxy','User','') ;
   edtSenhaProx.Text                                    := Ini.ReadString('Proxy','Pass','') ;
   rdgTipoDANFE.ItemIndex                               := Ini.ReadInteger('Geral','DANFE',0) ;

   PortaCOM.Text :=                                      portaCOMNFCE;

   edtLogmarcaGeral.Text                                := Ini.ReadString('Geral','LogoMarca','') ;
   //
   edtSMTPEmail.Text                                    := Ini.ReadString('Email','Host','') ;
   edtPortaEmail.Text                                   := Ini.ReadString('Email','Port','') ;
   edtUsuarioSMTP.Text                                  := Ini.ReadString('Email','User','') ;
   edtSenhaEmail.Text                                   := Ini.ReadString('Email','Pass','') ;
   edtAssuntoEmail.Text                                 := Ini.ReadString('Email','Assunto','') ;
   chkSeguroEmail.Checked                               := Ini.ReadBool  ('Email','SSL',False) ;
   //
   edtArquivoPDF.Text                                   := Ini.ReadString('Geral','ArquivosPDF','') ;
   if edtArquivosNFe.Text = '' then edtArquivosNFe.Text := ExtractFileDir(ParamStr(0)) + '\';
   edtArquivosNFe.Text                                  := Ini.ReadString('Geral','ArquivosNFE','') ;
   edtnucfop.Text                                       := CDCFOP;
   edtIDToken.Text                                      := Ini.ReadString('Geral','IDToken', '');
   edtToken.Text                                        := Ini.ReadString('Geral','Token', '');
   serie.Text                                           := Ini.ReadString('Geral','serie', '');

   RadioButton3.Checked                                 := Ini.ReadBool  ('Geral','preview',False) ;
   previewNFCe.Checked                                  := Ini.ReadBool  ('Geral','previewNFCe',False) ;
   IndxImpCupom.ItemIndex                               := Ini.ReadInteger('Geral','idxImpressora',0) ;
   IndxImpNfe.ItemIndex                                 := Ini.ReadInteger('Geral','idxImpressoraNFe',0) ;
   ti                                                   := Ini.ReadInteger('Geral','TipoImpressao',0) ;
   RadioButton1.Checked      := true;
   if ti = 1 then RadioButton2.Checked      := true
   else if ti = 2 then RadioButton4.Checked := true;

   conexaoBD.Text     := Ini.ReadString('SERVER','conexaoBD', '');
   pastaServidor.Text := Ini.ReadString('SERVER','pastaServidor', '');

   if Ini.ReadString('SERVER','usarServidorRemoto', 'N') = 'S' then usarSerivodrRemoto.Checked := true
     else usarSerivodrRemoto.Checked := false;

   FonteOutCampos.Text := Ini.ReadString('SERVER','FonteOutCampos', '10');
   fonteEnde.Text      := Ini.ReadString('SERVER','fonteEnde', '0');
   logoheigth.Text     := Ini.ReadString('SERVER','logoheigth', '1');
   LOGOWIDTH.Text      := Ini.ReadString('SERVER','LOGOWIDTH', '1');
   fonteRazao.Text     := Ini.ReadString('SERVER','fonteRazao', '8');
   MargemEsquerda.Text := Ini.ReadString('SERVER','MargemEsquerda', CurrToStr(DANFE_Fast.MargemEsquerda));
   velocidade.Text     := Ini.ReadString('SERVER','velocidade', '9600');
   impDescontoNFCe.Checked := Ini.ReadBool  ('SERVER','impDescProduto',False) ;


   ComboBox1.ItemIndex := tipoImp;
   tipoNFe.ItemIndex := Ini.ReadInteger('SERVER', 'tipoNFe', 0);

   StreamMemo                                           := TMemoryStream.Create;
   Ini.ReadBinaryStream( 'Email','Mensagem',StreamMemo) ;
   MemMensagemEmail.Lines.LoadFromStream(StreamMemo);
   StreamMemo.Free;
  finally
   Ini.Free;
   FreeAndNil(mmEmailMsg);
  end;
end;

procedure TfrmConfiguracoesNFe.FormShow(Sender: TObject);
Var
  I : TpcnTipoImpressao ;
  A : TACBrPosPrinterModelo;
begin

 tipoNFe.Clear;
 For I := Low(TpcnTipoImpressao) to High(TpcnTipoImpressao) do
     tipoNFe.Items.Add( GetEnumName(TypeInfo(TpcnTipoImpressao), integer(I) ) ) ;

 ComboBox1.Clear;
 For A := Low(TACBrPosPrinterModelo) to High(TACBrPosPrinterModelo) do
     ComboBox1.Items.Add( GetEnumName(TypeInfo(TACBrPosPrinterModelo), integer(A) ) ) ;

 tipoNFe.ItemIndex := 0;

 CarregaDadosArquivo;

 if pastaServidor.Text <> '' then verificarNotas.Checked := true;

 if MargemEsquerda.getValor = 0 then begin
   MargemEsquerda.setValor(DANFE_Fast.MargemEsquerda);
 end;
end;

procedure TfrmConfiguracoesNFe.btnAbrirPDFClick(Sender: TObject);
var
 Dir: string;
begin
 if Length(edtArquivoPDF.Text) <= 0 then Dir := ExtractFileDir(application.ExeName)
 else Dir := edtArquivoPDF.Text;
 if SelectDirectory(Dir, [sdAllowCreate, sdPerformCreate, sdPrompt],SELDIRHELP) then edtArquivoPDF.Text := Dir;
end;

procedure TfrmConfiguracoesNFe.btnAbrirXMLClick(Sender: TObject);
var
 Dir: string;
begin
 if Length(edtArquivosNFe.Text) <= 0 then Dir := ExtractFileDir(application.ExeName)
 else Dir := edtArquivosNFe.Text;
 if SelectDirectory(Dir, [sdAllowCreate, sdPerformCreate, sdPrompt],SELDIRHELP) then edtArquivosNFe.Text := Dir;
end;

procedure TfrmConfiguracoesNFe.gravaConfig();
var
  IniFile, tmp : String;
  Ini        : TIniFile ;
begin
  if FileExists(ExtractFileDir(ParamStr(0)) + '\ControlW.ini') then
   begin
     IniFile    := ExtractFileDir(ParamStr(0)) + '\ControlW.ini';
   end
 else
   begin
     IniFile    := ChangeFileExt( Application.ExeName, '.ini') ;
   end;

  tmp := IfThen(usarSerivodrRemoto.Checked, 'S', 'N');
  Ini        := TIniFile.Create( IniFile );
  Ini.WriteString('SERVER', 'conexaoBD', conexaoBD.Text);
  Ini.WriteString('SERVER', 'pastaServidor', pastaServidor.Text);
  Ini.WriteString('SERVER', 'usarServidorRemoto', tmp);
  Ini.WriteString('SERVER', 'tipoNFe', IntToStr(tipoNFe.ItemIndex));
  Ini.WriteBool('SERVER', 'usarCertiA3', certificadoA3.Checked);

  if FonteOutCampos.Text = '' then FonteOutCampos.Text := '10';
  Ini.WriteInteger('SERVER', 'FonteOutCampos', StrToIntDef(FonteOutCampos.Text, 10));
  Ini.WriteInteger('SERVER', 'fonteEnde', StrToIntDef(fonteEnde.Text, 0));
  Ini.WriteInteger('SERVER', 'logoheigth', StrToIntDef(logoheigth.Text, 1));
  Ini.WriteInteger('SERVER', 'LOGOWIDTH'   , StrToIntDef(LOGOWIDTH.Text, 1));
  Ini.WriteInteger('SERVER', 'fonteRazao'   , StrToIntDef(fonteRazao.Text, 8));
  Ini.WriteString('SERVER', 'ImpNFCe'   , IndxImpCupom.Text);
  Ini.WriteString('SERVER', 'ImpNFe'    , IndxImpNfe.Text);
  Ini.WriteBool('SERVER', 'impDescProduto' , impDescontoNFCe.Checked);
  Ini.WriteString('SERVER', 'MargemEsquerda'    , MargemEsquerda.Text);
  Ini.WriteString('SERVER', 'velocidade'    , velocidade.Text);
  ini.Free;

end;

procedure TfrmConfiguracoesNFe.usarSerivodrRemotoClick(Sender: TObject);
begin
  if conexaoBD.Text = '' then conexaoBD.Text := 'servidor:c:\controlw\bd.fdb';
  if pastaServidor.Text = '' then pastaServidor.Text := '\\servidor\controlw\';
end;

end.
