object Form1: TForm1
  Left = 253
  Top = 239
  Caption = 'Atualiza'#231#227'o ControlW'
  ClientHeight = 210
  ClientWidth = 294
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
    Left = 72
    Top = 10
    Width = 163
    Height = 16
    Caption = 'Baixando Atualiza'#231#227'o...'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    Visible = False
  end
  object Gauge1: TGauge
    Left = 0
    Top = 188
    Width = 294
    Height = 22
    Align = alBottom
    Progress = 0
    ExplicitTop = 191
    ExplicitWidth = 271
  end
  object lConnectionInfo: TLabel
    Left = 211
    Top = 32
    Width = 75
    Height = 13
    Alignment = taRightJustify
    Caption = 'Connection Info'
    Color = clBtnFace
    ParentColor = False
    Visible = False
  end
  object Memo1: TMemo
    Left = 0
    Top = 56
    Width = 294
    Height = 132
    Align = alBottom
    TabOrder = 0
  end
  object Button1: TButton
    Left = 91
    Top = 129
    Width = 75
    Height = 25
    Caption = 'Button1'
    TabOrder = 1
    Visible = False
    OnClick = Button1Click
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 500
    OnTimer = Timer1Timer
    Left = 144
    Top = 8
  end
  object IdHTTP1: TIdHTTP
    OnWorkEnd = IdHTTP1WorkEnd
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
    Left = 224
    Top = 8
  end
  object IdAntiFreeze1: TIdAntiFreeze
    Left = 104
    Top = 8
  end
  object Timer2: TTimer
    Enabled = False
    OnTimer = Timer2Timer
    Left = 32
  end
  object Timer3: TTimer
    Enabled = False
    OnTimer = Timer3Timer
    Top = 24
  end
  object ACBrDownload: TACBrDownload
    SizeRecvBuffer = 4096
    Proxy.ProxyTimeout = 90000
    FTP.FtpTimeout = 300000
    Protocolo = protHTTP
    OnHookStatus = HookStatus
    OnHookMonitor = ACBrDownloadHookMonitor
    Left = 168
    Top = 48
  end
end
