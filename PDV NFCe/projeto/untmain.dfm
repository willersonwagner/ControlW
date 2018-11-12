object frmMain: TfrmMain
  Left = -8
  Top = -8
  Align = alClient
  BorderStyle = bsSingle
  Caption = 
    'PLC NFC-e - Sistema de Emiss'#227'o e Transmiss'#227'o de Cupom Fiscal Ele' +
    'tr'#244'nico '
  ClientHeight = 686
  ClientWidth = 1366
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  Menu = mnm
  OldCreateOrder = False
  Position = poScreenCenter
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnKeyPress = FormKeyPress
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object stb: TStatusBar
    Left = 0
    Top = 667
    Width = 1366
    Height = 19
    Panels = <
      item
        Width = 120
      end
      item
        Width = 120
      end
      item
        Width = 500
      end
      item
        Width = 50
      end>
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 1366
    Height = 667
    Align = alClient
    TabOrder = 1
    object Image1: TImage
      Left = 1
      Top = 1
      Width = 1364
      Height = 665
      Align = alClient
      AutoSize = True
      Stretch = True
    end
    object Button1: TButton
      Left = 8
      Top = 8
      Width = 233
      Height = 81
      Caption = 'Enviar Conting'#234'ncia'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -19
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 0
      OnClick = Button1Click
    end
  end
  object mnm: TMainMenu
    Left = 136
    Top = 152
    object Arquivp1: TMenuItem
      Caption = 'Arquivo'
      object Login1: TMenuItem
        Action = actLogin
      end
      object Logoff1: TMenuItem
        Action = actLogoff
      end
      object Fechar1: TMenuItem
        Action = actFechar
      end
      object Sair1: TMenuItem
        Action = actSair
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object Configuraes1: TMenuItem
        Action = actConfiguracoes
        Caption = 'Configura'#231#245'es NFCe'
      end
    end
    object Rotinas: TMenuItem
      Caption = '&Rotinas'
      object EmissodeCupomFiscalEletrnicoCFe1: TMenuItem
        Action = actEmissaoCupomFiscalCFe
        Caption = 'PDV'
      end
      object PDV1: TMenuItem
        Caption = 'Emiss'#227'o de Cupom Fiscal Eletr'#244'nico - CF-e'
        Visible = False
        OnClick = PDV1Click
      end
      object N2: TMenuItem
        Caption = '-'
      end
      object CNFeNoEmitidas1: TMenuItem
        Action = actCNFeNaoEmitidas
        Visible = False
      end
      object ConsultarCupons1: TMenuItem
        Action = actConsultarNFCe
        Visible = False
      end
      object OutrasRotinas1: TMenuItem
        Caption = 'Outras Rotinas'
        object EstadodoServio1: TMenuItem
          Caption = 'Estado do Servi'#231'o'
          OnClick = EstadodoServio1Click
        end
        object AtualizarTabelaIBPT1: TMenuItem
          Caption = 'Atualizar Tabela IBPT'
          OnClick = AtualizarTabelaIBPT1Click
        end
      end
      object ConfigurarECF1: TMenuItem
        Caption = 'Outras Configura'#231#245'es'
        OnClick = ConfigurarECF1Click
      end
      object CadastrodeFormas1: TMenuItem
        Caption = 'Cadastro de Formas'
        OnClick = CadastrodeFormas1Click
      end
      object LimparVendas1: TMenuItem
        Caption = 'Limpar Vendas'
        OnClick = LimparVendas1Click
      end
      object CancelamentodeNFCe1: TMenuItem
        Action = actCancelamentoNFCe
        Caption = 'Informa'#231#245'es do ECF'
        Visible = False
      end
      object ZerarTentativasdeEnvioEsgotadas1: TMenuItem
        Caption = 'Zerar Tentativas de Envio Esgotadas'
        OnClick = ZerarTentativasdeEnvioEsgotadas1Click
      end
    end
    object MenuFiscal1: TMenuItem
      Caption = 'Menu Fiscal'
      Visible = False
      object IdentificaPAFECF1: TMenuItem
        Caption = 'Identifica'#231#227'o do PAF-ECF'
        OnClick = IdentificaPAFECF1Click
      end
      object LeituraX1: TMenuItem
        Caption = 'Leitura X'
        OnClick = LeituraX1Click
      end
      object ReduoZ1: TMenuItem
        Caption = 'Redu'#231#227'o Z'
        OnClick = ReduoZ1Click
      end
      object EspelhoMFD1: TMenuItem
        Caption = 'Espelho MFD'
        object PorData1: TMenuItem
          Caption = 'Por Data'
          OnClick = PorData1Click
        end
        object PorCOO1: TMenuItem
          Caption = 'Por COO'
          OnClick = PorCOO1Click
        end
        object PorReduo2: TMenuItem
          Caption = 'Por Redu'#231#227'o'
          OnClick = PorReduo2Click
        end
      end
      object LeituradaMemriaFiscal1: TMenuItem
        Caption = 'Leitura da Mem'#243'ria Fiscal'
        object PorReduo1: TMenuItem
          Caption = 'Por Redu'#231#227'o'
          OnClick = PorReduo1Click
        end
        object PorData2: TMenuItem
          Caption = 'Por Data'
          OnClick = PorData2Click
        end
        object ImprimePorReduo1: TMenuItem
          Caption = 'Imprime Por Redu'#231#227'o'
          OnClick = ImprimePorReduo1Click
        end
      end
      object Sangria1: TMenuItem
        Caption = 'Sangria'
        OnClick = Sangria1Click
      end
      object Suprimento1: TMenuItem
        Caption = 'Suprimento'
        OnClick = Suprimento1Click
      end
      object LMS1: TMenuItem
        Caption = 'LMFS'
        Visible = False
        OnClick = LMS1Click
      end
      object LMFC1: TMenuItem
        Caption = 'LMFC'
        Visible = False
        OnClick = LMFC1Click
      end
      object LX1: TMenuItem
        Caption = 'LX'
        Visible = False
        OnClick = LX1Click
      end
      object CAT321: TMenuItem
        Caption = 'CAT52'
        Visible = False
        OnClick = CAT321Click
      end
    end
    object ImpressoraFiscal1: TMenuItem
      Caption = 'Impressora Fiscal'
      Visible = False
      object Aliquotas1: TMenuItem
        Caption = 'Aliquotas'
        OnClick = Aliquotas1Click
      end
    end
  end
  object act: TActionManager
    ActionBars.SessionCount = 357
    ActionBars = <
      item
        AutoSize = False
      end
      item
        AutoSize = False
      end
      item
        AutoSize = False
      end
      item
        AutoSize = False
      end
      item
        AutoSize = False
      end
      item
        AutoSize = False
      end
      item
        AutoSize = False
      end>
    PrioritySchedule.Strings = (
      '0=3'
      '1=3'
      '10=23'
      '11=23'
      '12=23'
      '13=23'
      '14=31'
      '15=31'
      '16=31'
      '17=31'
      '18=31'
      '19=31'
      '2=6'
      '20=31'
      '21=31'
      '22=31'
      '23=31'
      '24=31'
      '25=31'
      '3=9'
      '4=12'
      '5=12'
      '6=17'
      '7=17'
      '8=17'
      '9=23')
    Left = 168
    Top = 152
    StyleName = 'XP Style'
    object actLogin: TAction
      Caption = 'Login'
      Hint = 'Login'
      ImageIndex = 84
      ShortCut = 32776
    end
    object actLogoff: TAction
      Caption = 'Logoff'
      Hint = 'Logoff'
      ImageIndex = 90
      ShortCut = 40968
      OnExecute = actLogoffExecute
    end
    object actFechar: TAction
      Caption = 'Fechar'
      Hint = 'Fechar'
      ImageIndex = 92
      ShortCut = 16499
      OnExecute = actFecharExecute
    end
    object actSair: TAction
      Caption = 'Sair'
      Hint = 'Sair'
      ImageIndex = 76
      OnExecute = actSairExecute
    end
    object actEmissaoCupomFiscalCFe: TAction
      Caption = 'Emiss'#227'o de Cupom Fiscal Eletr'#244'nico - CF-e'
      Hint = 'Emiss'#227'o de Cupom Fiscal Eletr'#244'nico - CF-e'
      ImageIndex = 21
      OnExecute = actEmissaoCupomFiscalCFeExecute
    end
    object actConfiguracoes: TAction
      Caption = 'Configura'#231#245'es'
      ImageIndex = 86
      OnExecute = actConfiguracoesExecute
    end
    object actCNFeNaoEmitidas: TAction
      Caption = 'CNF-e N'#227'o Emitidas'
      ImageIndex = 0
      OnExecute = actCNFeNaoEmitidasExecute
    end
    object actCancelamentoNFCe: TAction
      Caption = 'Cancelamento de NFC-e'
      ImageIndex = 28
      OnExecute = actCancelamentoNFCeExecute
    end
    object actConsultarNFCe: TAction
      Caption = 'Consultar Cupons'
      ImageIndex = 7
      OnExecute = actConsultarNFCeExecute
    end
  end
  object OpenDialog: TOpenDialog
    Left = 312
    Top = 40
  end
end
