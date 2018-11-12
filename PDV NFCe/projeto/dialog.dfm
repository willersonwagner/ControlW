object pergunta1: Tpergunta1
  Left = 381
  Top = 170
  BorderIcons = []
  BorderStyle = bsDialog
  Caption = 'pergunta1'
  ClientHeight = 74
  ClientWidth = 261
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
  object Label1: TLabel
    Left = 8
    Top = 16
    Width = 53
    Height = 13
    Caption = 'Selecionar:'
  end
  object Gauge1: TGauge
    Left = 0
    Top = 46
    Width = 261
    Height = 28
    Align = alBottom
    Progress = 0
    Visible = False
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 300
    OnTimer = Timer1Timer
    Left = 152
    Top = 32
  end
end
