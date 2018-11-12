object Form21: TForm21
  Left = 209
  Top = 449
  Caption = 'Transfer'#234'ncia - ControlW'
  ClientHeight = 403
  ClientWidth = 643
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 643
    Height = 403
    Align = alClient
    TabOrder = 0
    object Label2: TLabel
      Left = 240
      Top = 24
      Width = 49
      Height = 16
      Caption = 'Destino:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Label3: TLabel
      Left = 16
      Top = 24
      Width = 72
      Height = 16
      Caption = 'Documento:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Label4: TLabel
      Left = 352
      Top = 24
      Width = 47
      Height = 16
      Caption = 'C'#243'digo:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Label5: TLabel
      Left = 480
      Top = 16
      Width = 38
      Height = 16
      Caption = 'Quant:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Label6: TLabel
      Left = 16
      Top = 80
      Width = 65
      Height = 16
      Caption = 'Descri'#231#227'o:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object nomeLabel: TLabel
      Left = 304
      Top = 96
      Width = 7
      Height = 24
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -19
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label1: TLabel
      Left = 134
      Top = 24
      Width = 32
      Height = 16
      Caption = 'Data:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object documento: JsEditInteiro
      Left = 16
      Top = 40
      Width = 81
      Height = 21
      CharCase = ecUpperCase
      TabOrder = 0
      OnKeyPress = documentoKeyPress
      OnKeyUp = documentoKeyUp
      FormularioComp = 'Form21'
      ColorOnEnter = clSkyBlue
      Indice = 0
      TipoDeDado = teNumero
    end
    object data: JsEditData
      Left = 134
      Top = 40
      Width = 73
      Height = 21
      EditMask = '!99/99/0000;1;_'
      MaxLength = 10
      TabOrder = 1
      Text = '  /  /    '
      OnKeyPress = dataKeyPress
      ValidaCampo = False
      CompletaData = False
      ColorOnEnter = clSkyBlue
    end
    object destino: JsEditInteiro
      Left = 240
      Top = 40
      Width = 81
      Height = 21
      CharCase = ecUpperCase
      TabOrder = 2
      OnKeyPress = destinoKeyPress
      FormularioComp = 'Form21'
      ColorOnEnter = clSkyBlue
      Indice = 0
      TipoDeDado = teNumero
    end
    object cod: JsEditInteiro
      Left = 352
      Top = 40
      Width = 81
      Height = 21
      CharCase = ecUpperCase
      TabOrder = 3
      OnKeyPress = codKeyPress
      FormularioComp = 'Form21'
      ColorOnEnter = clSkyBlue
      Indice = 0
      TipoDeDado = teNumero
    end
    object quant: JsEditNumero
      Left = 480
      Top = 40
      Width = 73
      Height = 21
      CharCase = ecUpperCase
      TabOrder = 4
      Text = '0,00'
      OnKeyPress = quantKeyPress
      FormularioComp = 'Form21'
      ColorOnEnter = clSkyBlue
      Indice = 0
      TipoDeDado = teNumero
      CasasDecimais = 2
    end
    object descricao: JsEdit
      Left = 16
      Top = 96
      Width = 273
      Height = 21
      CharCase = ecUpperCase
      MaxLength = 20
      TabOrder = 5
      OnKeyPress = descricaoKeyPress
      FormularioComp = 'Form21'
      ColorOnEnter = clSkyBlue
      Indice = 0
      TipoDeDado = teNumero
    end
    object DBGrid1: TDBGrid
      Left = 1
      Top = 144
      Width = 641
      Height = 216
      Align = alBottom
      DataSource = DataSource1
      TabOrder = 6
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'MS Sans Serif'
      TitleFont.Style = []
      OnKeyDown = DBGrid1KeyDown
      OnKeyPress = DBGrid1KeyPress
    end
    object Panel2: TPanel
      Left = 1
      Top = 360
      Width = 641
      Height = 42
      Align = alBottom
      BevelInner = bvRaised
      BevelOuter = bvSpace
      TabOrder = 7
      object Label7: TLabel
        Left = 96
        Top = 16
        Width = 91
        Height = 16
        Caption = 'F8 - Consulta'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object JsBotao1: JsBotao
        Left = 8
        Top = 5
        Width = 75
        Height = 33
        Caption = 'Gravar'
        Glyph.Data = {
          F6060000424DF606000000000000360000002800000018000000180000000100
          180000000000C0060000EB0A0000EB0A00000000000000000000FFFFFFFDFDFD
          FAFAFAF5F5F5EDEDEDE8E8E8E1E1E1D9D9D9D1D1D1CBCBCBC5C5C5C5C5C5CACA
          CAD4D4D4DCDCDCE4E4E4ECECECF2F2F2F9F9F9FDFDFDFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFAFAFAEBEBEBE0E0E0D7D7D7CECECEC5C5C5BCBCBCB5B5B5BDBDBD
          AFAFAFB0B0B0B8B8B8C0C0C0C8C8C8D2D2D2DCDCDCE5E5E5EFEFEFF9F9F9FFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFEFEFBFBFBF9F9F9F7F7F7F5F5F5F8
          F8F8EFF0F081AE96D7E2DCF9F9F9F4F4F4F4F4F4F6F6F6F8F8F8FAFAFAFDFDFD
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFF7AB09329835562A280F4F9F6FFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF7FB0972984552C905E2A895962A07FF2F7
          F4FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF8AB79F2886552B955F2B945F
          2C9660298C5969A485F8FAF9FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF93BCA62888562B
          9B622B9B612B9A612B9A612B9C62298F5973A98CFEFEFEFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF9EC2
          AF2988572BA0642BA1642BA0642BA0642BA0642BA0642BA26529915B76AB8FFE
          FEFEFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFA7C7B6288A5627A5652AA6672AA5672AA5672AA5672AA5672AA5672AA5
          672AA76828925B7EAF95FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFADCBBB3992634AB67F30AF6F24A96626AA6729AB6929AB69
          29AB6929AB6929AB6929AB6A29AC6B27935C84B39AFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFBDD4C83A946567C69679CFA466C79648BC8130
          B47124B06926B06A28B16C28B16C28B16C28B16C29B26D29B36D27955C8DB8A1
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFB0CDBE40986A68CA987BD5A871CF
          A071CFA06FCE9E60C9944FC3893ABD7B2AB77027B66E26B66E25B66D26B66D27
          B76F27B86F27945C94BBA7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF47916A5DB98A
          83DFB174D3A371D3A16DD19F69D19C69D09B67D09B61D09858CE9247C6853CC2
          7E32BF772CBD7428BC7125BD7025BA6E25935B9CC0ADFFFFFFFFFFFFFFFFFFFF
          FFFFE4EDE86BA8896FCA9C78DDAA70D6A26CD6A068D49E68D69F59CB91379966
          50BF875CD69856CF9252CF8F49CB8940C98438C77E32C77B2DC3772A955EA7C7
          B6FFFFFFFFFFFFFFFFFFFFFFFFE5ECE75EA27E68CB9973E0A96CD9A26DDDA55B
          D3963B9B6AA1BFAF549E784EC38756D9974FD38F4CD18D49D18C47D08B41CE87
          3BD08637CA80319763AECBBBFFFFFFFFFFFFFFFFFFFFFFFFD9E5DF529D7564D0
          9975E7AE5DDA9A369B67B9D0C4FFFFFFD2E2D943986C4BCA8A50DB954AD58F47
          D58D43D38B3FD3893DD28739D48734CC80359764BAD1C5FFFFFFFFFFFFFFFFFF
          FFFFFFD6E3DC4F9D7452CD8F37A26AB2CCBEFFFFFFFFFFFFFFFFFFD0E0D74199
          6C49D08D4CDF9546D99042D88D3ED88B3BD78937D68733D98630CF7E3B9C69B4
          CFC1FFFFFFFFFFFFFFFFFFFFFFFFCDDFD53B8F62A1C4B1FFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFC6D9CF39996746D58D48E49642DE903EDD8D3BDD8B37DC8933DB
          8730E68B29B66F458F67FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBF1EEFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFBED5C9359C6643DC8F42E7943DE28E
          3AE28C36E18A34E88D2DC97A4B9E74DDE7E1FFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFB8D0C333
          9E6740E3913FEB943AE68F37EA9030D07F479B6FE5EBE8FFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFB1CABD2EA1663DE5903CF29734D58341996BDEE5E1FFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFADC8B92FA76935D4843E9B6AD7E0
          DBFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF9FC5B1
          45966BD5E1DBFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFE7EEEAFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF}
        TabOrder = 0
        OnClick = JsBotao1Click
      end
    end
  end
  object DataSource1: TDataSource
    Left = 352
    Top = 112
  end
end
