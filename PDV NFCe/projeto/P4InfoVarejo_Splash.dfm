object frmSplash: TfrmSplash
  Left = 744
  Top = 338
  BorderStyle = bsNone
  ClientHeight = 352
  ClientWidth = 600
  Color = clWhite
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clBlack
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Image1: TImage
    Left = 0
    Top = 0
    Width = 600
    Height = 352
    Align = alClient
    ParentShowHint = False
    ShowHint = True
    Stretch = True
  end
  object Label1: TLabel
    Left = 312
    Top = 16
    Width = 252
    Height = 56
    Caption = 'AUTOCOM ECF'
    Color = clWhite
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlack
    Font.Height = -32
    Font.Name = 'Segoe Print'
    Font.Style = []
    ParentColor = False
    ParentFont = False
    Transparent = True
  end
  object Label2: TLabel
    Left = 368
    Top = 72
    Width = 111
    Height = 36
    Caption = 'Iniciando...'
    Color = clWhite
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlack
    Font.Height = -21
    Font.Name = 'Segoe Print'
    Font.Style = []
    ParentColor = False
    ParentFont = False
    Transparent = True
  end
end
