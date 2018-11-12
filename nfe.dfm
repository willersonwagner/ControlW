object NfeVenda: TNfeVenda
  Left = 399
  Top = 154
  Caption = 'Nfe - ControlW'
  ClientHeight = 235
  ClientWidth = 406
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnKeyPress = te
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 16
    Top = 3
    Width = 333
    Height = 20
    Caption = 'Tipo de Funcionamento do ACBR Monitor'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label2: TLabel
    Left = 16
    Top = 72
    Width = 136
    Height = 13
    Caption = 'Caminho da Pasta do ACBR:'
  end
  object Label3: TLabel
    Left = 16
    Top = 120
    Width = 189
    Height = 13
    Caption = 'Caminho da Pasta da NFe do ControlW:'
  end
  object Panel1: TPanel
    Left = 0
    Top = 194
    Width = 406
    Height = 41
    Align = alBottom
    TabOrder = 0
    object Button1: TButton
      Left = 8
      Top = 4
      Width = 75
      Height = 33
      Caption = 'Gravar'
      TabOrder = 0
      OnClick = Button1Click
    end
    object Button2: TButton
      Left = 96
      Top = 4
      Width = 113
      Height = 33
      Caption = 'Restaurar Padr'#227'o'
      TabOrder = 1
      OnClick = Button2Click
    end
    object Button3: TButton
      Left = 216
      Top = 4
      Width = 97
      Height = 33
      Caption = 'Testar'
      TabOrder = 2
      OnClick = Button3Click
    end
  end
  object RadioButton1: TRadioButton
    Left = 16
    Top = 32
    Width = 113
    Height = 17
    Caption = 'Local'
    Checked = True
    TabOrder = 1
    TabStop = True
    OnEnter = RadioButton1Enter
  end
  object RadioButton2: TRadioButton
    Left = 16
    Top = 48
    Width = 113
    Height = 17
    Caption = 'Rede'
    TabOrder = 2
    OnEnter = RadioButton2Enter
  end
  object Edit1: TEdit
    Left = 16
    Top = 88
    Width = 305
    Height = 21
    Enabled = False
    MaxLength = 100
    TabOrder = 3
    Text = '\\NFE\ACBR\'
  end
  object Edit2: TEdit
    Left = 16
    Top = 136
    Width = 305
    Height = 21
    MaxLength = 100
    TabOrder = 4
    Text = '\\NFE\ControlW\'
  end
  object OpenDialog1: TOpenDialog
    Left = 368
    Top = 80
  end
  object TCPServer: TIdTCPServer
    Bindings = <>
    DefaultPort = 0
    Left = 369
    Top = 49
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 1500
    Left = 368
    Top = 112
  end
end
