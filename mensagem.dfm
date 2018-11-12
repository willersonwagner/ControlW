object Form23: TForm23
  Left = 211
  Top = 154
  AlphaBlend = True
  BorderIcons = []
  BorderStyle = bsNone
  Caption = 'Form23'
  ClientHeight = 114
  ClientWidth = 272
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 273
    Height = 113
    BevelInner = bvLowered
    TabOrder = 0
    object Label1: TLabel
      Left = 24
      Top = 20
      Width = 55
      Height = 20
      Caption = 'Label1'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object ProgressBar1: TProgressBar
      Left = 16
      Top = 64
      Width = 241
      Height = 16
      TabOrder = 0
    end
  end
  object Timer1: TTimer
    Enabled = False
    Left = 176
    Top = 72
  end
  object Timer2: TTimer
    Enabled = False
    Left = 216
    Top = 72
  end
end
