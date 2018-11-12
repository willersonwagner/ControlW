object Form70: TForm70
  Left = 0
  Top = 0
  Caption = 'Processo - Email'
  ClientHeight = 232
  ClientWidth = 486
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 1
    Width = 108
    Height = 25
    Caption = 'Aguarde...'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -21
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object ProgressBar1: TProgressBar
    Left = 0
    Top = 33
    Width = 486
    Height = 31
    Align = alBottom
    TabOrder = 0
  end
  object Button1: TButton
    Left = 392
    Top = 1
    Width = 92
    Height = 28
    Caption = 'Fechar'
    TabOrder = 1
    OnClick = Button1Click
  end
  object memo1: TRichEdit
    Left = 0
    Top = 64
    Width = 486
    Height = 168
    Align = alBottom
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 2
    Zoom = 100
    OnChange = memo1Change
  end
  object ACBrMail1: TACBrMail
    Host = '127.0.0.1'
    Port = '25'
    SetSSL = False
    SetTLS = False
    Attempts = 3
    DefaultCharset = UTF_8
    IDECharset = CP1252
    Left = 312
    Top = 6
  end
end
