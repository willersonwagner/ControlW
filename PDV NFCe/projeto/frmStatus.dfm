object mfd: Tmfd
  Left = 361
  Top = 170
  BorderIcons = []
  BorderStyle = bsDialog
  BorderWidth = 3
  Caption = 'Leitura de MFD'
  ClientHeight = 370
  ClientWidth = 682
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  OnKeyDown = FormKeyDown
  OnKeyPress = FormKeyPress
  PixelsPerInch = 96
  TextHeight = 13
  object RichEdit1: TRichEdit
    Left = 0
    Top = 0
    Width = 682
    Height = 329
    Align = alTop
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Courier New'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    Zoom = 100
    OnKeyPress = RichEdit1KeyPress
  end
  object BitBtn1: TBitBtn
    Left = 16
    Top = 336
    Width = 89
    Height = 33
    Caption = 'Imprimir'
    TabOrder = 1
    OnClick = BitBtn1Click
  end
  object BitBtn2: TBitBtn
    Left = 120
    Top = 337
    Width = 89
    Height = 33
    Caption = 'Salvar'
    TabOrder = 2
    OnClick = BitBtn2Click
  end
end
