object Form5: TForm5
  Left = 192
  Top = 103
  Width = 283
  Height = 317
  BorderIcons = []
  Caption = 'Formas de Pagamento'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 56
    Top = 248
    Width = 165
    Height = 24
    Caption = 'F8 - Voltar Venda'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object ListBox1: TListBox
    Left = 0
    Top = 0
    Width = 267
    Height = 241
    Align = alTop
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ItemHeight = 20
    Items.Strings = (
      'Novo '
      'velho'
      'atrasado')
    ParentFont = False
    TabOrder = 0
    OnKeyDown = ListBox1KeyDown
    OnKeyPress = ListBox1KeyPress
  end
end
