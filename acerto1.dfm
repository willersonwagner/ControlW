object acerto: Tacerto
  Left = 192
  Top = 124
  Caption = 'Acertos de Estoque'
  ClientHeight = 395
  ClientWidth = 776
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
  object Label1: TLabel
    Left = 8
    Top = 32
    Width = 69
    Height = 13
    Caption = 'Documento:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label2: TLabel
    Left = 8
    Top = 8
    Width = 80
    Height = 18
    Caption = '10/10/2015'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial Black'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label3: TLabel
    Left = 96
    Top = 32
    Width = 44
    Height = 13
    Caption = 'C'#243'digo:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label4: TLabel
    Left = 240
    Top = 32
    Width = 51
    Height = 13
    Caption = 'Estoque:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label5: TLabel
    Left = 344
    Top = 32
    Width = 55
    Height = 13
    Caption = 'Dep'#243'sito:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label6: TLabel
    Left = 448
    Top = 32
    Width = 73
    Height = 13
    Caption = 'Justificativa:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object nomeProduto: TLabel
    Left = 8
    Top = 84
    Width = 7
    Height = 24
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -19
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object DOCUMENTO: JsEditInteiro
    Left = 8
    Top = 48
    Width = 73
    Height = 21
    CharCase = ecUpperCase
    TabOrder = 0
    OnKeyPress = DOCUMENTOKeyPress
    OnKeyUp = DOCUMENTOKeyUp
    UsarCadastros = False
    FormularioComp = 'Form9'
    ColorOnEnter = clSkyBlue
    Indice = 0
    TipoDeDado = teNumero
  end
  object CODIGO: JsEditInteiro
    Left = 96
    Top = 48
    Width = 129
    Height = 21
    CharCase = ecUpperCase
    TabOrder = 1
    OnKeyPress = CODIGOKeyPress
    FormularioComp = 'Form9'
    ColorOnEnter = clSkyBlue
    Indice = 0
    TipoDeDado = teNumero
  end
  object QUANT: JsEditNumero
    Left = 240
    Top = 48
    Width = 89
    Height = 21
    CharCase = ecUpperCase
    TabOrder = 2
    Text = '0,000'
    FormularioComp = 'acerto'
    Indice = 0
    TipoDeDado = teNumero
    CasasDecimais = 3
  end
  object DEPOSITO: JsEditNumero
    Left = 344
    Top = 48
    Width = 89
    Height = 21
    CharCase = ecUpperCase
    TabOrder = 3
    Text = '0,000'
    FormularioComp = 'acerto'
    Indice = 0
    TipoDeDado = teNumero
    CasasDecimais = 3
  end
  object NOME: JsEdit
    Left = 448
    Top = 48
    Width = 265
    Height = 21
    CharCase = ecUpperCase
    MaxLength = 40
    TabOrder = 4
    UsarCadastros = False
    FormularioComp = 'Form9'
    ColorOnEnter = clSkyBlue
    Indice = 0
    TipoDeDado = teNumero
  end
  object ToolBar1: TPanel
    Left = 0
    Top = 358
    Width = 776
    Height = 37
    Align = alBottom
    TabOrder = 5
    object Label33: TLabel
      Left = 113
      Top = 10
      Width = 196
      Height = 16
      Caption = 'F5 - Consulta/ Delete -Exclui'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object JsBotao1: JsBotao
      Left = 0
      Top = 2
      Width = 89
      Height = 31
      Caption = 'Gravar'
      Glyph.Data = {
        F6060000424DF606000000000000360000002800000018000000180000000100
        180000000000C0060000EB0A0000EB0A00000000000000000000CCCCCCCACACA
        C8C8C8C4C4C4BEBEBEBABABAB4B4B4AEAEAEA7A7A7A2A2A29E9E9E9E9E9EA2A2
        A2AAAAAAB0B0B0B6B6B6BDBDBDC2C2C2C7C7C7CACACACCCCCCCCCCCCCCCCCCCC
        CCCCCCCCCCC8C8C8BCBCBCB3B3B3ACACACA5A5A59E9E9E969696919191979797
        8C8C8C8D8D8D9393939A9A9AA0A0A0A8A8A8B0B0B0B7B7B7BFBFBFC7C7C7CCCC
        CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCBCBCBC9C9C9C7C7C7C6C6C6C4C4C4C6
        C6C6BFC1C06B9880ADB8B2C7C7C7C3C3C3C3C3C3C5C5C5C6C6C6C8C8C8CACACA
        CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
        CCCCCCCCCCCCCCCCCCCC669D80298355549472C4C9C6CCCCCCCCCCCCCCCCCCCC
        CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
        CCCCCCCCCCCCCCCCCCCCCCCCCCCCCC6A9B822984552C905E2A8959549271C2C7
        C4CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
        CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC739F882886552B955F2B945F
        2C9660298C59599475C7C9C8CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
        CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC79A28C2888562B
        9B622B9B612B9A612B9A612B9C62298F5961977ACBCBCBCCCCCCCCCCCCCCCCCC
        CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC81A6
        922988562BA0642BA1642BA0642BA0642BA0642BA0642BA26529915B63987CCB
        CBCBCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
        CCCCCC88A897278A5527A5652AA6672AA5672AA5672AA5672AA5672AA5672AA5
        672AA76828925B699B80CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
        CCCCCCCCCCCCCCCC8CAA9A3791624AB67F30AF6F24A96626AA6729AB6929AB69
        29AB6929AB6929AB6929AB6A29AC6B27935C6E9D84CCCCCCCCCCCCCCCCCCCCCC
        CCCCCCCCCCCCCCCCCCCCCCCCCC99B0A438916267C69679CFA466C79648BC8130
        B47124B06926B06A28B16C28B16C28B16C28B16C29B26D29B36D27955C75A089
        CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC8FAC9D3C946768CA987BD5A871CF
        A071CFA06FCE9E60C9944FC3893ABD7B2AB77027B66E26B66E25B66D26B66D27
        B76F27B86F27945C7AA28DCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC3F89625DB98A
        83DFB174D3A371D3A16DD19F69D19C69D09B67D09B61D09858CE9247C6853CC2
        7E32BF772CBD7428BC7125BD7025BA6E25935B80A491CCCCCCCCCCCCCCCCCCCC
        CCCCB7C0BB609D7E6FCA9C78DDAA70D6A26CD6A068D49E68D69F59CB91379966
        50BF875CD69856CF9252CF8F49CB8940C98438C77E32C77B2DC3772A955D89A9
        97CCCCCCCCCCCCCCCCCCCCCCCCB7BEB955987468CB9973E0A96CD9A26DDDA55B
        D39639986782A0914A956E4EC38756D9974FD38F4CD18D49D18C47D08B41CE87
        3BD08637CA803197638EAB9BCCCCCCCCCCCCCCCCCCCCCCCCAEBAB44B956E64D0
        9975E7AE5DDA9A349A6596ACA0CCCCCCA9B9B03E93674BCA8A50DB954AD58F47
        D58D43D38B3FD3893DD28739D48734CC8033956297AEA2CCCCCCCCCCCCCCCCCC
        CCCCCCACB9B248966E52CD8F35A06990AA9CCCCCCCCCCCCCCCCCCCA7B8AF3C95
        6749D08D4CDF9546D99042D88D3ED88B3BD78937D68733D98630CF7E36986593
        AD9FCCCCCCCCCCCCCCCCCCCCCCCCA5B7AD36895D83A794CCCCCCCCCCCCCCCCCC
        CCCCCCCCCCCCA0B3A936966546D58D48E49642DE903EDD8D3BDD8B37DC8933DB
        8730E68B29B66F3D8860CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCBDC3BFCCCCCCCC
        CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC9AB0A5339B6443DC8F42E7943DE28E
        3AE28C36E18A34E88D2DC97A43956BB2BCB6CCCCCCCCCCCCCCCCCCCCCCCCCCCC
        CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC95ADA032
        9D6540E3913FEB943AE68F37EA9030D07F409368B8BEBBCCCCCCCCCCCCCCCCCC
        CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
        CCCCCCCCCCCCCC90A99B2EA1663DE5903CF29734D5833B9365B2BAB5CCCCCCCC
        CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
        CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC8DA8992FA76835D484399665ADB6
        B1CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
        CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC82A894
        3D8F64ACB8B1CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
        CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
        CCCCCCCCCCCCCCCCBAC0BCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC}
      TabOrder = 0
      OnClick = JsBotao1Click
    end
  end
  object DBGrid1: TDBGrid
    Left = 0
    Top = 131
    Width = 776
    Height = 227
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
  object DataSource1: TDataSource
    Left = 152
    Top = 80
  end
end
