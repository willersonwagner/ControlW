object pergunta1: Tpergunta1
  Left = 379
  Top = 169
  BorderIcons = []
  BorderStyle = bsDialog
  Caption = ';'
  ClientHeight = 74
  ClientWidth = 261
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnKeyPress = FormKeyPress
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
