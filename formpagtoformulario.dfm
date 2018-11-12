object Form18: TForm18
  Left = 343
  Top = 145
  BorderIcons = []
  BorderStyle = bsDialog
  Caption = 'Formas de Pagamento'
  ClientHeight = 219
  ClientWidth = 161
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 0
    Top = 203
    Width = 161
    Height = 16
    Align = alBottom
    Alignment = taCenter
    Caption = 'F8 - Volta a Venda'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Courier New'
    Font.Style = [fsBold]
    ParentFont = False
    ExplicitWidth = 126
  end
  object ListBox1: TListBox
    Left = 0
    Top = 0
    Width = 161
    Height = 203
    Align = alClient
    Columns = 1
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Courier New'
    Font.Style = []
    ItemHeight = 14
    ParentFont = False
    TabOrder = 0
    OnKeyDown = ListBox1KeyDown
    OnKeyPress = ListBox1KeyPress
  end
end
