object frmObservacao: TfrmObservacao
  Left = 306
  Top = 160
  BorderStyle = bsDialog
  Caption = 'Observa'#231#227'o - Vinculado'
  ClientHeight = 310
  ClientWidth = 438
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
  object Bevel1: TBevel
    Left = 0
    Top = 246
    Width = 438
    Height = 64
    Align = alBottom
  end
  object BtnOK: TBitBtn
    Left = 160
    Top = 256
    Width = 145
    Height = 41
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    Kind = bkOK
  end
  object ibobservacao: TIB_Memo
    Left = 0
    Top = 0
    Width = 438
    Height = 246
    DataField = 'DSOBSERVACAO'
    DataSource = frmEmissaoCupomFiscal.dts
    Align = alClient
    TabOrder = 0
    AutoSize = False
  end
end
