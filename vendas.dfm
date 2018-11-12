object Form20: TForm20
  Left = 193
  Top = 81
  Caption = 'Modo Venda: '
  ClientHeight = 582
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
  OnKeyPress = FormKeyPress
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 800
    Height = 582
    Align = alClient
    TabOrder = 0
    object Label1: TLabel
      Left = 168
      Top = 40
      Width = 45
      Height = 20
      Caption = 'Data:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label2: TLabel
      Left = 312
      Top = 40
      Width = 84
      Height = 20
      Caption = 'Vendedor:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label3: TLabel
      Left = 480
      Top = 40
      Width = 52
      Height = 20
      Caption = 'Prazo:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label4: TLabel
      Left = 624
      Top = 40
      Width = 62
      Height = 20
      Caption = 'Cliente:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label5: TLabel
      Left = 208
      Top = 312
      Width = 124
      Height = 20
      Caption = 'Itens da Venda'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object desco: TLabel
      Left = 604
      Top = 445
      Width = 4
      Height = 18
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial Black'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label7: TLabel
      Left = 8
      Top = 40
      Width = 44
      Height = 20
      Caption = 'Nota:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label8: TLabel
      Left = 512
      Top = 424
      Width = 48
      Height = 16
      Caption = 'Label8'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      Visible = False
    end
    object Label9: TLabel
      Left = 616
      Top = 336
      Width = 78
      Height = 23
      Caption = 'Label9'
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlack
      Font.Height = -21
      Font.Name = 'Courier New'
      Font.Style = [fsBold]
      ParentFont = False
      Visible = False
    end
    object ToolBar1: TPanel
      Left = 1
      Top = 552
      Width = 798
      Height = 29
      Align = alBottom
      BorderWidth = 1
      TabOrder = 0
      object StaticText2: TStaticText
        Left = 2
        Top = 2
        Width = 794
        Height = 25
        Align = alBottom
        AutoSize = False
        Caption = 
          'F8-Alternar Entre Tabelas/F9 - Limpar Items da Venda/F2 - Modo V' +
          'enda/Or'#231'amento/F6 - Busca C'#243'digo de Barras/F3 - Recuperar Or'#231'ame' +
          'nto'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 0
      end
    end
    object JsEditData1: JsEditData
      Left = 216
      Top = 41
      Width = 65
      Height = 21
      Color = clHighlightText
      Enabled = False
      EditMask = '!99/99/0000;1;_'
      MaxLength = 10
      TabOrder = 1
      Text = '  /  /    '
      ValidaCampo = False
      CompletaData = False
      ColorOnEnter = clSkyBlue
    end
    object JsEdit2: JsEditInteiro
      Left = 400
      Top = 41
      Width = 49
      Height = 21
      CharCase = ecUpperCase
      TabOrder = 2
      OnKeyPress = JsEdit2KeyPress
      FormularioComp = 'Form20'
      ColorOnEnter = clSkyBlue
      Indice = 0
      TipoDeDado = teNumero
    end
    object JsEdit1: JsEditInteiro
      Left = 536
      Top = 40
      Width = 65
      Height = 21
      CharCase = ecUpperCase
      TabOrder = 3
      Text = '0'
      OnKeyDown = JsEdit1KeyDown
      OnKeyPress = JsEdit1KeyPress
      OnKeyUp = JsEdit1KeyUp
      FormularioComp = 'Form20'
      ColorOnEnter = clSkyBlue
      Indice = 0
      TipoDeDado = teNumero
    end
    object JsEdit3: JsEditInteiro
      Left = 688
      Top = 41
      Width = 65
      Height = 21
      CharCase = ecUpperCase
      TabOrder = 4
      OnEnter = JsEdit3Enter
      OnExit = JsEdit3Exit
      OnKeyPress = JsEdit3KeyPress
      OnKeyUp = JsEdit3KeyUp
      FormularioComp = 'Form20'
      ColorOnEnter = clSkyBlue
      ValidaCampo = True
      Indice = 0
      TipoDeDado = teNumero
    end
    object DBGrid1: TDBGrid
      Left = 16
      Top = 72
      Width = 793
      Height = 233
      Align = alCustom
      BorderStyle = bsNone
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Courier New'
      Font.Style = [fsBold]
      Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgCancelOnExit]
      ParentFont = False
      TabOrder = 5
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'MS Sans Serif'
      TitleFont.Style = []
      OnDrawColumnCell = DBGrid1DrawColumnCell
      OnEnter = DBGrid1Enter
      OnExit = DBGrid1Exit
      OnKeyDown = DBGrid1KeyDown
      OnKeyPress = DBGrid1KeyPress
      OnKeyUp = DBGrid1KeyUp
    end
    object DBGrid2: TDBGrid
      Left = 9
      Top = 330
      Width = 496
      Height = 181
      BiDiMode = bdLeftToRight
      DataSource = DataSource2
      Enabled = False
      Options = [dgTitles, dgIndicator, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgCancelOnExit]
      ParentBiDiMode = False
      ReadOnly = True
      TabOrder = 6
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'MS Sans Serif'
      TitleFont.Style = []
      StyleElements = [seFont, seClient]
      OnEnter = DBGrid2Enter
      OnExit = DBGrid2Exit
      OnKeyDown = DBGrid2KeyDown
      OnKeyPress = DBGrid2KeyPress
      OnKeyUp = DBGrid2KeyUp
    end
    object JsEditInteiro1: JsEditInteiro
      Left = 56
      Top = 41
      Width = 89
      Height = 21
      CharCase = ecUpperCase
      Enabled = False
      TabOrder = 7
      OnKeyPress = JsEdit2KeyPress
      FormularioComp = 'Form20'
      ColorOnEnter = clSkyBlue
      Indice = 0
      TipoDeDado = teNumero
    end
    object Panel2: TPanel
      Left = 1
      Top = 1
      Width = 798
      Height = 32
      Align = alTop
      BevelInner = bvLowered
      BevelOuter = bvNone
      Ctl3D = False
      ParentCtl3D = False
      TabOrder = 8
      object LabelVenda: TLabel
        Left = 1
        Top = 1
        Width = 796
        Height = 29
        Align = alTop
        Alignment = taCenter
        Caption = 'Venda'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -24
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        ExplicitWidth = 75
      end
    end
    object panelTotal: TPanel
      Left = 520
      Top = 407
      Width = 281
      Height = 105
      BevelOuter = bvNone
      BorderStyle = bsSingle
      Color = clWhite
      Ctl3D = False
      Font.Charset = ANSI_CHARSET
      Font.Color = 2500301
      Font.Height = -64
      Font.Name = 'Arial Black'
      Font.Style = [fsBold]
      ParentCtl3D = False
      ParentFont = False
      TabOrder = 9
      object total: TLabel
        Left = 0
        Top = 0
        Width = 279
        Height = 103
        Align = alClient
        Alignment = taCenter
        Caption = '0,00'
        Font.Charset = ANSI_CHARSET
        Font.Color = 2500301
        Font.Height = -64
        Font.Name = 'Arial Black'
        Font.Style = [fsBold]
        ParentFont = False
        ExplicitWidth = 150
        ExplicitHeight = 90
      end
    end
    object Panel4: TPanel
      Left = 520
      Top = 367
      Width = 281
      Height = 41
      BevelOuter = bvNone
      BorderWidth = 1
      BorderStyle = bsSingle
      Caption = 'Sub-Total'
      Color = 13758190
      Ctl3D = False
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlack
      Font.Height = -27
      Font.Name = 'Arial Black'
      Font.Style = [fsBold]
      ParentCtl3D = False
      ParentFont = False
      TabOrder = 10
    end
    object PanelValores: TPanel
      Left = 520
      Top = 328
      Width = 281
      Height = 41
      BevelOuter = bvNone
      BorderWidth = 1
      BorderStyle = bsSingle
      Color = 13758190
      Ctl3D = False
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = 'Arial Black'
      Font.Style = [fsBold]
      ParentCtl3D = False
      ParentFont = False
      TabOrder = 11
      Visible = False
      object labelValores: TLabel
        Left = 1
        Top = 1
        Width = 277
        Height = 37
        Align = alClient
        ExplicitWidth = 4
        ExplicitHeight = 17
      end
    end
  end
  object DataSource2: TDataSource
    DataSet = ClientDataSet1
    Left = 400
    Top = 184
  end
  object Timer1: TTimer
    Enabled = False
    OnTimer = Timer1Timer
    Left = 368
    Top = 112
  end
  object ClientDataSet1: TClientDataSet
    Aggregates = <>
    AggregatesActive = True
    Params = <>
    AfterPost = ClientDataSet1AfterPost
    AfterDelete = ClientDataSet1AfterDelete
    Left = 320
    Top = 184
    object ClientDataSet1Refori: TStringField
      FieldName = 'Refori'
      Visible = False
    end
    object ClientDataSet1CODIGO: TIntegerField
      FieldName = 'CODIGO'
    end
    object ClientDataSet1grupo: TIntegerField
      FieldName = 'grupo'
    end
    object ClientDataSet1DESCRICAO: TStringField
      FieldName = 'DESCRICAO'
      Size = 40
    end
    object ClientDataSet1QUANT: TCurrencyField
      FieldName = 'QUANT'
      DisplayFormat = '#,###,###0.000'
      EditFormat = '#,###,###0.000'
      currency = False
    end
    object ClientDataSet1PRECO: TCurrencyField
      FieldName = 'PRECO'
      DisplayFormat = '#,###,###0.000'
      EditFormat = '#,###,###0.000'
      currency = False
    end
    object ClientDataSet1TOTAL: TCurrencyField
      FieldName = 'TOTAL'
      DisplayFormat = '#,###,###0.00'
      EditFormat = '#,###,###0.00'
      currency = False
    end
    object ClientDataSet1PRECO_ORIGI: TCurrencyField
      FieldName = 'PRECO_ORIGI'
      Visible = False
      DisplayFormat = '#,###,###0.000'
      EditFormat = '#,###,###0.000'
      currency = False
    end
    object ClientDataSet1TOT_ORIGI2: TCurrencyField
      FieldName = 'TOT_ORIGI'
      currency = False
    end
    object ClientDataSet1cod_seq: TIntegerField
      AutoGenerateValue = arAutoInc
      FieldName = 'cod_seq'
      Visible = False
    end
    object ClientDataSet1minimo: TCurrencyField
      FieldName = 'minimo'
    end
    object ClientDataSet1m2: TIntegerField
      FieldName = 'm2'
      Visible = False
    end
    object ClientDataSet1vendedor: TIntegerField
      FieldName = 'vendedor'
      Visible = False
    end
    object ClientDataSet1estado: TStringField
      FieldName = 'estado'
      Visible = False
      Size = 1
    end
    object ClientDataSet1seqServ: TIntegerField
      FieldName = 'seqServ'
      Visible = False
    end
    object ClientDataSet1p_total: TAggregateField
      DefaultExpression = 'sum(total)'
      FieldName = 'p_total'
      Active = True
      DisplayName = '#,###,###0.000'
      DisplayFormat = '#,###,###0.000'
      Expression = 'sum(total)'
    end
    object ClientDataSet1desc: TAggregateField
      FieldName = 'desc'
      Active = True
      DisplayName = ''
      Expression = 'sum(preco_origi - preco)'
    end
    object ClientDataSet1tot_p_ori: TAggregateField
      FieldName = 'tot_p_ori'
      Visible = True
      Active = True
      DisplayName = ''
      Expression = '(sum(TOT_ORIGI))'
    end
  end
end
