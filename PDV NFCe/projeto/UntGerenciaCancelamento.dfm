object frmGerenciaCancelamento: TfrmGerenciaCancelamento
  Left = 444
  Top = 202
  BorderStyle = bsDialog
  Caption = 'Op'#231#245'es Para Cancelamento'
  ClientHeight = 196
  ClientWidth = 391
  Color = clInfoBk
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object RDGOpcaoCancelar: TRadioGroup
    Left = 8
    Top = 8
    Width = 377
    Height = 129
    Caption = 'Op'#231#245'es de Cancelamento'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = []
    ItemIndex = 0
    Items.Strings = (
      'Item Anterior'
      'Item Gen'#233'rico  - Digite o N'#250'mero do Item.....:'
      'Venda')
    ParentFont = False
    TabOrder = 0
    OnClick = RDGOpcaoCancelarClick
  end
  object EdtCancelar: TEdit
    Left = 296
    Top = 56
    Width = 81
    Height = 28
    Enabled = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    MaxLength = 3
    ParentFont = False
    TabOrder = 1
    Text = '0'
    OnExit = EdtCancelarExit
    OnKeyPress = EdtCancelarKeyPress
  end
  object BtnOK: TBitBtn
    Left = 160
    Top = 152
    Width = 97
    Height = 33
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 2
    Kind = bkOK
  end
  object BtnCancelar: TBitBtn
    Left = 272
    Top = 152
    Width = 97
    Height = 33
    Caption = 'Cancelar'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 3
    Kind = bkCancel
  end
end
