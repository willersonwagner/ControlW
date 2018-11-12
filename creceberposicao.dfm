object Form34: TForm34
  Left = 314
  Top = 172
  Caption = 'Contas Receber - Baixa'
  ClientHeight = 354
  ClientWidth = 612
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
  object DBGrid1: TDBGrid
    Left = 0
    Top = 0
    Width = 612
    Height = 288
    Align = alClient
    BiDiMode = bdLeftToRight
    BorderStyle = bsNone
    DataSource = DataSource1
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Courier New'
    Font.Style = []
    Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgCancelOnExit]
    ParentBiDiMode = False
    ParentFont = False
    TabOrder = 0
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'MS Sans Serif'
    TitleFont.Style = []
    OnDrawColumnCell = DBGrid1DrawColumnCell
    OnKeyDown = DBGrid1KeyDown
    OnKeyPress = DBGrid1KeyPress
    OnKeyUp = DBGrid1KeyUp
  end
  object Panel1: TPanel
    Left = 0
    Top = 288
    Width = 612
    Height = 33
    Align = alBottom
    BorderStyle = bsSingle
    TabOrder = 1
    object cliente: TLabel
      Left = 8
      Top = 8
      Width = 5
      Height = 16
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object label4: TLabel
      Left = 512
      Top = 8
      Width = 93
      Height = 13
      Caption = 'Enter/F10-Baixa'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label1: TLabel
      Left = 368
      Top = 8
      Width = 62
      Height = 13
      Caption = 'F2-Imprime'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label2: TLabel
      Left = 437
      Top = 8
      Width = 68
      Height = 13
      Caption = 'F5-Previs'#227'o'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 321
    Width = 612
    Height = 33
    Align = alBottom
    BorderStyle = bsSingle
    TabOrder = 2
    object Label3: TLabel
      Left = 8
      Top = 8
      Width = 212
      Height = 16
      Caption = 'Consulta de Contas a Receber'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label5: TLabel
      Left = 328
      Top = 8
      Width = 134
      Height = 16
      Caption = 'Total a Receber =>'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object total: TLabel
      Left = 464
      Top = 8
      Width = 5
      Height = 16
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
  end
  object IBTable1: TIBTable
    Database = dm.bd
    Transaction = dm.IBTransaction2
    AutoCalcFields = False
    OnCalcFields = IBTable1CalcFields
    BufferChunks = 1000
    CachedUpdates = False
    DefaultIndex = False
    StoreDefs = True
    TableName = 'CONTASRECEBER'
    UniDirectional = False
    Left = 376
    Top = 232
    object IBTable1CODGRU: TIntegerField
      DisplayLabel = 'CAIXA'
      FieldName = 'CODGRU'
    end
    object IBTable1VENCIMENTO: TDateField
      FieldName = 'VENCIMENTO'
    end
    object IBTable1DOCUMENTO: TIntegerField
      FieldName = 'DOCUMENTO'
    end
    object IBTable1TOTAL: TIBBCDField
      FieldName = 'TOTAL'
      Visible = False
      Precision = 18
      Size = 2
    end
    object IBTable1CODHIS: TIntegerField
      FieldName = 'CODHIS'
      Visible = False
    end
    object IBTable1HISTORICO: TIBStringField
      FieldName = 'HISTORICO'
      Size = 35
    end
    object IBTable1PAGO: TIBBCDField
      FieldName = 'PAGO'
      Visible = False
      Precision = 18
      Size = 2
    end
    object IBTable1FORNEC: TIntegerField
      FieldName = 'FORNEC'
      Visible = False
    end
    object IBTable1USUARIO: TIntegerField
      FieldName = 'USUARIO'
      Visible = False
    end
    object IBTable1VENDEDOR: TIntegerField
      FieldName = 'VENDEDOR'
      Visible = False
    end
    object IBTable1DATAMOV: TDateField
      FieldName = 'DATAMOV'
      Visible = False
    end
    object IBTable1FORMPAGTO: TSmallintField
      FieldName = 'FORMPAGTO'
      Visible = False
    end
    object IBTable1PREVISAO: TDateField
      FieldName = 'PREVISAO'
      Visible = False
    end
    object IBTable1VALOR: TIBBCDField
      FieldName = 'VALOR'
      Visible = False
      Precision = 18
      Size = 2
    end
    object IBTable1CONT: TSmallintField
      FieldName = 'CONT'
      Visible = False
    end
    object IBTable1DATA: TDateField
      FieldName = 'DATA'
      Visible = False
    end
    object IBTable1COD: TIntegerField
      FieldName = 'COD'
      Visible = False
    end
    object IBTable1ValorCalc: TCurrencyField
      DisplayLabel = 'VALOR'
      FieldKind = fkCalculated
      FieldName = 'ValorCalc'
      Required = True
      DisplayFormat = '#,###,###0.00'
      EditFormat = '#,###,###0.00'
      currency = False
      Calculated = True
    end
    object IBTable1SALDO: TIBBCDField
      FieldName = 'SALDO'
      Precision = 18
      Size = 2
    end
  end
  object DataSource1: TDataSource
    DataSet = IBTable1
    Left = 424
    Top = 232
  end
  object ClientDataSet1: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 296
    Top = 136
  end
end
