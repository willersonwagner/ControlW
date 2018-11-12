object aliq1: Taliq1
  Left = 300
  Top = 217
  Width = 206
  Height = 230
  Caption = 'Sit. Tributaria Nota Fiscal - ControlW'
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
    Width = 190
    Height = 192
    Align = alClient
    BorderStyle = bsNone
    DataSource = DataSource1
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    TitleFont.Charset = ANSI_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Courier New'
    TitleFont.Style = []
    OnKeyPress = DBGrid1KeyPress
  end
  object IBTable1: TIBTable
    BeforeInsert = IBTable1BeforeInsert
    BufferChunks = 1000
    CachedUpdates = False
    Left = 104
    Top = 80
  end
  object DataSource1: TDataSource
    DataSet = IBTable1
    Left = 56
    Top = 96
  end
end
