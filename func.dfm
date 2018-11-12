object funcoes: Tfuncoes
  Left = 608
  Top = 244
  Align = alClient
  BorderStyle = bsDialog
  Caption = 'to'
  ClientHeight = 338
  ClientWidth = 527
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object WebBrowser1: TWebBrowser
    Left = 16
    Top = 32
    Width = 369
    Height = 209
    TabOrder = 0
    ControlData = {
      4C000000232600009A1500000000000000000000000000000000000000000000
      000000004C000000000000000000000001000000E0D057007335CF11AE690800
      2B2E126208000000000000004C0000000114020000000000C000000000000046
      8000000000000000000000000000000000000000000000000000000000000000
      00000000000000000100000000000000000000000000000000000000}
  end
  object DBGrid1: TDBGrid
    Left = 8
    Top = 40
    Width = 483
    Height = 249
    DataSource = DataSource1
    TabOrder = 1
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'MS Sans Serif'
    TitleFont.Style = []
    Visible = False
  end
  object IBTransaction1: TIBTransaction
    Left = 160
    Top = 8
  end
  object Timer2: TTimer
    Enabled = False
    Interval = 600000
    Left = 48
    Top = 32
  end
  object RxCalculator1: TRxCalculator
    Title = 'Calculadora'
    Left = 16
    Top = 32
  end
  object IdFTP1: TIdFTP
    IPVersion = Id_IPv4
    NATKeepAlive.UseKeepAlive = False
    NATKeepAlive.IdleTimeMS = 0
    NATKeepAlive.IntervalMS = 0
    ProxySettings.ProxyType = fpcmNone
    ProxySettings.Port = 0
    ReadTimeout = 0
    Left = 88
    Top = 216
  end
  object DataSource1: TDataSource
    Left = 32
    Top = 104
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 100
    OnTimer = Timer1Timer
    Left = 344
    Top = 40
  end
  object DataSetProvider1: TDataSetProvider
    ResolveToDataSet = True
    Left = 424
    Top = 352
  end
  object Timer3: TTimer
    Enabled = False
    Interval = 1500
    OnTimer = Timer3Timer
    Left = 48
  end
  object IdHTTP1: TIdHTTP
    AllowCookies = False
    ProxyParams.BasicAuthentication = False
    ProxyParams.ProxyPort = 0
    Request.ContentLength = -1
    Request.ContentRangeEnd = 0
    Request.ContentRangeStart = 0
    Request.ContentRangeInstanceLength = -1
    Request.ContentType = 'text/html'
    Request.Accept = 'text/html, */*'
    Request.BasicAuthentication = False
    Request.UserAgent = 'Mozilla/3.0 (compatible; Indy Library)'
    Request.Ranges.Units = 'bytes'
    Request.Ranges = <>
    HTTPOptions = [hoForceEncodeParams]
    Left = 272
  end
  object IdSNTP1: TIdSNTP
    Host = 'time.windows.com'
    Port = 123
    ReceiveTimeout = 5000
    Left = 16
    Top = 216
  end
end
