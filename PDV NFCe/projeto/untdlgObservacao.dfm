object frmdlgObservacao: TfrmdlgObservacao
  Left = 297
  Top = 124
  BorderStyle = bsDialog
  Caption = 'Digita Observa'#231#227'o'
  ClientHeight = 324
  ClientWidth = 423
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
  object Panel1: TPanel
    Left = 0
    Top = 264
    Width = 423
    Height = 60
    Align = alBottom
    TabOrder = 1
    object btnok: TBitBtn
      Left = 88
      Top = 8
      Width = 105
      Height = 33
      Caption = '&OK'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      Kind = bkOK
    end
    object btncancela: TBitBtn
      Left = 240
      Top = 8
      Width = 105
      Height = 33
      Caption = '&Cancelar'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      Kind = bkCancel
    end
  end
  object IB_Memo1: TIB_Memo
    Left = 0
    Top = 0
    Width = 423
    Height = 264
    DataField = 'DSOBSERVACAO'
    DataSource = frmCupomFiscalSAT.dts
    Align = alClient
    Color = 15395562
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlack
    Font.Height = -16
    Font.Name = 'Arial Narrow'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    AutoSize = False
  end
end
