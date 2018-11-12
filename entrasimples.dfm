object Form17: TForm17
  Left = 415
  Top = 90
  Caption = 'Entrada Simples'
  ClientHeight = 600
  ClientWidth = 800
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  WindowState = wsMaximized
  OnClose = FormClose
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  OnKeyUp = FormKeyUp
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 800
    Height = 600
    Align = alClient
    TabOrder = 0
    object Label1: TLabel
      Left = 16
      Top = 16
      Width = 38
      Height = 16
      Caption = 'Nota:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label2: TLabel
      Left = 240
      Top = 16
      Width = 65
      Height = 16
      Caption = 'Emissao:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label3: TLabel
      Left = 360
      Top = 16
      Width = 68
      Height = 16
      Caption = 'Chegada:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label4: TLabel
      Left = 128
      Top = 16
      Width = 85
      Height = 16
      Caption = 'Fornecedor:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label5: TLabel
      Left = 472
      Top = 16
      Width = 33
      Height = 16
      Caption = 'Cod.'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label6: TLabel
      Left = 624
      Top = 16
      Width = 85
      Height = 16
      Caption = 'Quantidade:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label7: TLabel
      Left = 344
      Top = 72
      Width = 71
      Height = 16
      Caption = 'Encargos:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label9: TLabel
      Left = 424
      Top = 72
      Width = 41
      Height = 16
      Caption = 'Frete:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label10: TLabel
      Left = 504
      Top = 72
      Width = 44
      Height = 16
      Caption = 'Custo:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label11: TLabel
      Left = 584
      Top = 72
      Width = 43
      Height = 16
      Caption = 'Lucro:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label12: TLabel
      Left = 664
      Top = 72
      Width = 50
      Height = 16
      Caption = 'Venda:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object produto: TLabel
      Left = 16
      Top = 464
      Width = 8
      Height = 29
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -24
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label13: TLabel
      Left = 16
      Top = 424
      Width = 6
      Height = 20
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clMaroon
      Font.Height = -16
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object codigo: JsEditInteiro
      Left = 16
      Top = 32
      Width = 89
      Height = 24
      CharCase = ecUpperCase
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 0
      OnKeyDown = codigoKeyDown
      OnKeyPress = codigoKeyPress
      OnKeyUp = codigoKeyUp
      UsarCadastros = False
      FormularioComp = 'Form17'
      ColorOnEnter = clSkyBlue
      Indice = 0
      TipoDeDado = teNumero
    end
    object fornec: JsEditInteiro
      Left = 128
      Top = 32
      Width = 73
      Height = 24
      CharCase = ecUpperCase
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 1
      OnKeyPress = fornecKeyPress
      UsarCadastros = False
      FormularioComp = 'Form17'
      ColorOnEnter = clSkyBlue
      Indice = 0
      TipoDeDado = teNumero
    end
    object data: JsEditData
      Left = 240
      Top = 32
      Width = 81
      Height = 24
      EditMask = '!99/99/0000;1;_'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      MaxLength = 10
      ParentFont = False
      TabOrder = 2
      Text = '  /  /    '
      OnKeyUp = dataKeyUp
      ValidaCampo = False
      CompletaData = False
      ColorOnEnter = clSkyBlue
    end
    object chegada: JsEditData
      Left = 360
      Top = 32
      Width = 81
      Height = 24
      EditMask = '!99/99/0000;1;_'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      MaxLength = 10
      ParentFont = False
      TabOrder = 3
      Text = '  /  /    '
      OnKeyUp = chegadaKeyUp
      ValidaCampo = False
      CompletaData = False
      ColorOnEnter = clSkyBlue
    end
    object codbar: JsEdit
      Left = 472
      Top = 32
      Width = 113
      Height = 24
      CharCase = ecUpperCase
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 4
      OnEnter = codbarEnter
      OnKeyPress = codbarKeyPress
      OnKeyUp = codbarKeyUp
      UsarCadastros = False
      FormularioComp = 'Form17'
      ColorOnEnter = clSkyBlue
      ValidaCampo = True
      Indice = 0
      TipoDeDado = teNumero
    end
    object quant: JsEditNumero
      Left = 624
      Top = 32
      Width = 89
      Height = 24
      CharCase = ecUpperCase
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 5
      Text = '0,000'
      OnKeyDown = quantKeyDown
      UsarCadastros = False
      FormularioComp = 'Form17'
      ColorOnEnter = clSkyBlue
      Indice = 0
      TipoDeDado = teNumero
      CasasDecimais = 3
    end
    object GroupBox1: TGroupBox
      Left = 8
      Top = 72
      Width = 153
      Height = 49
      Caption = 'Cr'#233'dito ICMS'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 6
      object baseicm: JsEditNumero
        Left = 8
        Top = 20
        Width = 57
        Height = 24
        CharCase = ecUpperCase
        TabOrder = 0
        Text = '0,00'
        OnExit = baseicmExit
        UsarCadastros = False
        FormularioComp = 'Form17'
        ColorOnEnter = clSkyBlue
        Indice = 0
        TipoDeDado = teNumero
        CasasDecimais = 2
      end
      object credicm: JsEditNumero
        Left = 88
        Top = 20
        Width = 57
        Height = 24
        CharCase = ecUpperCase
        TabOrder = 1
        Text = '0,00'
        UsarCadastros = False
        FormularioComp = 'Form17'
        ColorOnEnter = clSkyBlue
        Indice = 0
        TipoDeDado = teNumero
        CasasDecimais = 2
      end
    end
    object GroupBox2: TGroupBox
      Left = 168
      Top = 72
      Width = 153
      Height = 49
      Caption = 'D'#233'bito ICMS'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 7
      object basedeb: JsEditNumero
        Left = 8
        Top = 20
        Width = 57
        Height = 24
        CharCase = ecUpperCase
        TabOrder = 0
        Text = '0,00'
        UsarCadastros = False
        FormularioComp = 'Form17'
        ColorOnEnter = clSkyBlue
        Indice = 0
        TipoDeDado = teNumero
        CasasDecimais = 2
      end
      object debicm: JsEditNumero
        Left = 88
        Top = 20
        Width = 57
        Height = 24
        CharCase = ecUpperCase
        TabOrder = 1
        Text = '0,00'
        UsarCadastros = False
        FormularioComp = 'Form17'
        ColorOnEnter = clSkyBlue
        Indice = 0
        TipoDeDado = teNumero
        CasasDecimais = 2
      end
    end
    object encargos: JsEditNumero
      Left = 344
      Top = 92
      Width = 49
      Height = 24
      CharCase = ecUpperCase
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 8
      Text = '0,00'
      UsarCadastros = False
      FormularioComp = 'Form17'
      ColorOnEnter = clSkyBlue
      Indice = 0
      TipoDeDado = teNumero
      CasasDecimais = 2
    end
    object frete: JsEditNumero
      Left = 424
      Top = 92
      Width = 49
      Height = 24
      CharCase = ecUpperCase
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 9
      Text = '0,00'
      UsarCadastros = False
      FormularioComp = 'Form17'
      ColorOnEnter = clSkyBlue
      Indice = 0
      TipoDeDado = teNumero
      CasasDecimais = 2
    end
    object p_compra: JsEditNumero
      Left = 504
      Top = 92
      Width = 49
      Height = 24
      CharCase = ecUpperCase
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 10
      Text = '0,000'
      UsarCadastros = False
      FormularioComp = 'Form17'
      ColorOnEnter = clSkyBlue
      Indice = 0
      TipoDeDado = teNumero
      CasasDecimais = 3
    end
    object lucro: JsEditNumero
      Left = 584
      Top = 92
      Width = 49
      Height = 24
      CharCase = ecUpperCase
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 11
      Text = '0,00'
      OnKeyPress = lucroKeyPress
      UsarCadastros = False
      FormularioComp = 'Form17'
      ColorOnEnter = clSkyBlue
      Indice = 0
      TipoDeDado = teNumero
      CasasDecimais = 2
    end
    object p_venda: JsEditNumero
      Left = 664
      Top = 92
      Width = 49
      Height = 24
      CharCase = ecUpperCase
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 12
      Text = '0,000'
      OnExit = p_vendaExit
      OnKeyPress = p_vendaKeyPress
      UsarCadastros = False
      FormularioComp = 'Form17'
      ColorOnEnter = clSkyBlue
      Indice = 0
      TipoDeDado = teNumero
      CasasDecimais = 3
    end
    object ToolBar1: TPanel
      Left = 1
      Top = 559
      Width = 798
      Height = 40
      Align = alBottom
      TabOrder = 13
      object info: TLabel
        Left = 120
        Top = 7
        Width = 666
        Height = 13
        Caption = 
          'F8-Consulta/F6-Altera Dados Nota/F5-Consulta Produtos/F9-Recebe ' +
          'Nota/F10-Import. NFE/F11 Recalcular Entradas'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object JsBotao1: JsBotao
        Left = 0
        Top = 2
        Width = 113
        Height = 39
        Caption = 'Gravar Entrada'
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
    object DBGrid2: TDBGrid
      Left = 8
      Top = 136
      Width = 769
      Height = 281
      DataSource = dm.entrada
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgCancelOnExit]
      ParentFont = False
      TabOrder = 14
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'MS Sans Serif'
      TitleFont.Style = []
      OnCellClick = DBGrid2CellClick
      OnEnter = DBGrid2Enter
      OnExit = DBGrid2Exit
      OnKeyDown = DBGrid2KeyDown
      OnKeyPress = DBGrid2KeyPress
      OnKeyUp = DBGrid2KeyUp
    end
    object agreg: JsEditNumero
      Left = 344
      Top = 152
      Width = 49
      Height = 21
      CharCase = ecUpperCase
      TabOrder = 15
      Text = '0,00'
      Visible = False
      AddLista = False
      UsarCadastros = False
      FormularioComp = 'Form17'
      ColorOnEnter = clSkyBlue
      Indice = 0
      TipoDeDado = teNumero
      CasasDecimais = 2
    end
    object Panel2: TPanel
      Left = 576
      Top = 423
      Width = 201
      Height = 57
      TabOrder = 16
      object tot: TLabel
        Left = 1
        Top = 1
        Width = 199
        Height = 23
        Align = alTop
        Alignment = taCenter
        Caption = 'R$ 0,00'
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -21
        Font.Name = 'Courier New'
        Font.Style = [fsBold]
        ParentFont = False
        ExplicitWidth = 91
      end
      object totXML: TLabel
        Left = 1
        Top = 33
        Width = 199
        Height = 23
        Align = alBottom
        Alignment = taCenter
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -21
        Font.Name = 'Courier New'
        Font.Style = [fsBold]
        ParentFont = False
        ExplicitWidth = 13
      end
    end
    object DESC_COMP: JsEditNumero
      Left = 540
      Top = 168
      Width = 67
      Height = 24
      Hint = 'Desconto na Compra'
      CharCase = ecUpperCase
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 17
      Text = '0,00'
      Visible = False
      AddLista = False
      UsarCadastros = False
      FormularioComp = 'Form9'
      ColorOnEnter = clSkyBlue
      Indice = 0
      TipoDeDado = teNumero
      CasasDecimais = 2
    end
    object ICMS_SUBS: JsEditNumero
      Left = 535
      Top = 208
      Width = 72
      Height = 24
      Hint = 'Valor em Porcentagem % de ICMS  de Substitui'#231#227'o Tribut'#225'ria'
      CharCase = ecUpperCase
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 18
      Text = '0,00'
      Visible = False
      AddLista = False
      UsarCadastros = False
      FormularioComp = 'Form9'
      ColorOnEnter = clSkyBlue
      Indice = 0
      TipoDeDado = teNumero
      CasasDecimais = 2
    end
  end
  object IBQuery1: TIBQuery
    Database = dm.bd
    Transaction = IBTransaction2
    BufferChunks = 1000
    CachedUpdates = False
    ParamCheck = True
    Left = 208
    Top = 248
  end
  object DataSource1: TDataSource
    DataSet = IBQuery1
    Left = 128
    Top = 264
  end
  object IBTransaction2: TIBTransaction
    DefaultDatabase = dm.bd
    Params.Strings = (
      'read_committed'
      'rec_version'
      'wait')
    Left = 168
    Top = 183
  end
end
