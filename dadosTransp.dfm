object Form43: TForm43
  Left = 630
  Top = 196
  BorderIcons = []
  BorderStyle = bsDialog
  Caption = 'Dados do Frete'
  ClientHeight = 325
  ClientWidth = 538
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnKeyPress = FormKeyPress
  PixelsPerInch = 96
  TextHeight = 13
  object Label11: TLabel
    Left = 8
    Top = 8
    Width = 113
    Height = 16
    Caption = 'Frete Por Conta:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Panel1: TPanel
    Left = 0
    Top = 300
    Width = 538
    Height = 25
    Align = alBottom
    TabOrder = 4
    object Label10: TLabel
      Left = 56
      Top = 8
      Width = 80
      Height = 13
      Caption = 'F5 - Consultar'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
  end
  object GroupBox1: TGroupBox
    Left = 0
    Top = 168
    Width = 538
    Height = 132
    Align = alBottom
    Caption = 'Volumes'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 3
    object Label6: TLabel
      Left = 18
      Top = 21
      Width = 70
      Height = 13
      Caption = 'Quantidade:'
    end
    object Label5: TLabel
      Left = 35
      Top = 48
      Width = 50
      Height = 13
      Caption = 'Esp'#233'cie:'
    end
    object Label8: TLabel
      Left = 30
      Top = 102
      Width = 54
      Height = 13
      Caption = 'Peso Liq:'
    end
    object Label9: TLabel
      Left = 19
      Top = 75
      Width = 67
      Height = 13
      Caption = 'Peso Bruto:'
    end
    object Label7: TLabel
      Left = 258
      Top = 6
      Width = 40
      Height = 13
      Caption = 'Marca:'
    end
    object Label12: TLabel
      Left = 258
      Top = 47
      Width = 69
      Height = 13
      Caption = 'Numera'#231#227'o:'
    end
    object qtd: JsEditInteiro
      Left = 94
      Top = 13
      Width = 113
      Height = 21
      CharCase = ecUpperCase
      TabOrder = 0
      OnKeyPress = qtdKeyPress
      FormularioComp = 'Form43'
      Indice = 0
      TipoDeDado = teNumero
    end
    object especie: JsEdit
      Left = 94
      Top = 40
      Width = 113
      Height = 21
      CharCase = ecUpperCase
      TabOrder = 1
      OnKeyPress = especieKeyPress
      FormularioComp = 'Form43'
      Indice = 0
      TipoDeDado = teNumero
    end
    object liq: JsEditNumero
      Left = 92
      Top = 94
      Width = 121
      Height = 21
      CharCase = ecUpperCase
      TabOrder = 3
      Text = '0,00'
      OnKeyPress = liqKeyPress
      FormularioComp = 'Form43'
      Indice = 0
      TipoDeDado = teNumero
      CasasDecimais = 2
    end
    object bruto: JsEditNumero
      Left = 92
      Top = 67
      Width = 121
      Height = 21
      CharCase = ecUpperCase
      TabOrder = 2
      Text = '0,00'
      OnKeyPress = brutoKeyPress
      FormularioComp = 'Form43'
      Indice = 0
      TipoDeDado = teNumero
      CasasDecimais = 2
    end
    object marca: JsEdit
      Left = 258
      Top = 20
      Width = 137
      Height = 21
      CharCase = ecUpperCase
      TabOrder = 4
      OnKeyPress = marcaKeyPress
      FormularioComp = 'Form43'
      Indice = 0
      TipoDeDado = teNumero
    end
    object nVol: JsEdit
      Left = 258
      Top = 64
      Width = 137
      Height = 21
      CharCase = ecUpperCase
      TabOrder = 5
      OnKeyPress = nVolKeyPress
      FormularioComp = 'Form43'
      Indice = 0
      TipoDeDado = teNumero
    end
  end
  object GroupBox2: TGroupBox
    Left = 0
    Top = 104
    Width = 538
    Height = 64
    Align = alBottom
    Caption = 'Dados Ve'#237'culo'
    TabOrder = 2
    object Label3: TLabel
      Left = 8
      Top = 24
      Width = 30
      Height = 13
      Caption = 'Placa:'
    end
    object Label4: TLabel
      Left = 176
      Top = 24
      Width = 36
      Height = 13
      Caption = 'Estado:'
    end
    object placa: JsEdit
      Left = 44
      Top = 17
      Width = 117
      Height = 21
      CharCase = ecUpperCase
      TabOrder = 0
      FormularioComp = 'Form43'
      Indice = 0
      TipoDeDado = teNumero
    end
    object estado: JsEdit
      Left = 216
      Top = 17
      Width = 113
      Height = 21
      CharCase = ecUpperCase
      MaxLength = 2
      TabOrder = 1
      OnKeyPress = estadoKeyPress
      FormularioComp = 'Form43'
      Indice = 0
      TipoDeDado = teNumero
    end
  end
  object GroupBox3: TGroupBox
    Left = 0
    Top = 48
    Width = 538
    Height = 56
    Align = alBottom
    Caption = 'Dados Transportadora'
    TabOrder = 1
    object Label1: TLabel
      Left = 6
      Top = 18
      Width = 61
      Height = 13
      Caption = 'Cod.Transp.:'
    end
    object Label2: TLabel
      Left = 216
      Top = 18
      Width = 68
      Height = 13
      Caption = 'C'#243'digo ANTT:'
    end
    object codtransp: JsEditInteiro
      Left = 82
      Top = 16
      Width = 113
      Height = 21
      CharCase = ecUpperCase
      TabOrder = 0
      OnKeyPress = codtranspKeyPress
      OnKeyUp = codtranspKeyUp
      FormularioComp = 'Form43'
      Indice = 0
      TipoDeDado = teNumero
    end
    object antt: JsEdit
      Left = 290
      Top = 16
      Width = 105
      Height = 21
      CharCase = ecUpperCase
      TabOrder = 1
      OnKeyPress = anttKeyPress
      FormularioComp = 'Form43'
      Indice = 0
      TipoDeDado = teNumero
    end
  end
  object tipofrete: TEdit
    Left = 127
    Top = 5
    Width = 121
    Height = 24
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 0
    OnKeyPress = tipofreteKeyPress
  end
end
