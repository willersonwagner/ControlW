object Form40: TForm40
  Left = 338
  Top = 89
  BorderStyle = bsSingle
  Caption = 'Par'#226'metros Gerais - ControlW'
  ClientHeight = 537
  ClientWidth = 800
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  WindowState = wsMaximized
  OnClose = FormClose
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object ListBox1: TListBox
    Left = 0
    Top = 0
    Width = 800
    Height = 537
    Style = lbOwnerDrawVariable
    Align = alClient
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ItemHeight = 15
    ParentFont = False
    TabOrder = 0
    OnKeyPress = ListBox1KeyPress
    OnKeyUp = ListBox1KeyUp
  end
end
