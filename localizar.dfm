object Form7: TForm7
  Left = 618
  Top = 410
  ActiveControl = DBGrid1
  BorderStyle = bsDialog
  Caption = 'Localizar   '
  ClientHeight = 202
  ClientWidth = 359
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Icon.Data = {
    0000010001002020100000000000E80200001600000028000000200000004000
    0000010004000000000080020000000000000000000000000000000000000000
    000000008000008000000080800080000000800080008080000080808000C0C0
    C0000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF000000
    0000000000000000000000000000000111111111111111111111110000000118
    7777777777777777777777000000010000000000000000000000008000000050
    FFFFFFFFFFFFFF7777777F00000007050FFFFFFFFFFF777777FFFF0000000009
    5088888888888888888FFF0000000015950FFFFF7777777FFFFFFF0000000709
    5950888888888888888FFF000000000595990777777777FFFFFFFF0000000019
    5959088888888888888FFF0000000705959907777777FFFFFFFFFF0000000009
    5959088888888888888FFF00000000159599077777FFFFFFFFFFFF0000000709
    5959080888888888888FF0D9D9000005959907F00FFFF000000FF00D9D900019
    5959088050000FFFFF800880D9D0070595990FFF00FFFFFFFFFFFFFF0D900009
    5959088880000008FFFFFFFF09D0001595990FFFF00D0F08FFFFFFFF0D900709
    595908888080D008FFFFFFFF09D0000995990FFFF0F80D08FFFFFFF000000000
    99590000000F80D0FFFFF00000000000099900000000F80D0FFF000000000000
    0099000000000FF0D00000000000000000090000000000000D00000000000000
    000000000000000000D00000000000000000000000000000000D000000000000
    00000000000000000000D00000000000000000000000000000000D0000000000
    0000000000000000000000D0000000000000000000000000000000000000FFFF
    FFFFE000003F8000001F8000000F8000000F0000000F0000000F8000000F0000
    000F0000000F8000000F0000000F0000000F8000000300000001000000008000
    00000000000000000000800000000000000000000001E000001FF07E007FF87F
    00FFFC7F81FFFE7FF8FFFFFFFC7FFFFFFE3FFFFFFF1FFFFFFF8FFFFFFFCF}
  KeyPreview = True
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 359
    Height = 41
    Align = alTop
    TabOrder = 1
    object Label1: TLabel
      Left = 0
      Top = 11
      Width = 56
      Height = 13
      Caption = 'Localizar:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Edit1: TEdit
      Left = 58
      Top = 8
      Width = 129
      Height = 21
      CharCase = ecUpperCase
      TabOrder = 0
      OnChange = Edit1Change
      OnKeyDown = Edit1KeyDown
      OnKeyPress = Edit1KeyPress
    end
  end
  object DBGrid1: TDBGrid
    Left = 0
    Top = 41
    Width = 359
    Height = 161
    Align = alClient
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Courier New'
    Font.Style = []
    Options = [dgTitles, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgCancelOnExit]
    ParentFont = False
    TabOrder = 0
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'MS Sans Serif'
    TitleFont.Style = []
    OnDrawColumnCell = DBGrid1DrawColumnCell
    OnKeyDown = DBGrid1KeyDown
    OnKeyPress = DBGrid1KeyPress
    OnKeyUp = DBGrid1KeyUp
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 1500
    OnTimer = Timer1Timer
    Left = 272
  end
  object DataSource1: TDataSource
    DataSet = ClientDataSet1
    Left = 208
    Top = 80
  end
  object ClientDataSet1: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 136
    Top = 72
  end
end
