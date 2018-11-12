object frmFinalizaVenda: TfrmFinalizaVenda
  Left = 278
  Top = 159
  BorderIcons = [biHelp]
  BorderStyle = bsDialog
  Caption = 'Finalizar Venda'
  ClientHeight = 440
  ClientWidth = 752
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
    Top = 395
    Width = 752
    Height = 45
    Align = alBottom
    TabOrder = 0
    object BtnFinalizar: TBitBtn
      Left = 79
      Top = 5
      Width = 137
      Height = 33
      Caption = '&Finalizar'
      Default = True
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -21
      Font.Name = 'Arial Narrow'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      Glyph.Data = {
        DE010000424DDE01000000000000760000002800000024000000120000000100
        0400000000006801000000000000000000001000000000000000000000000000
        80000080000000808000800000008000800080800000C0C0C000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
        3333333333333333333333330000333333333333333333333333F33333333333
        00003333344333333333333333388F3333333333000033334224333333333333
        338338F3333333330000333422224333333333333833338F3333333300003342
        222224333333333383333338F3333333000034222A22224333333338F338F333
        8F33333300003222A3A2224333333338F3838F338F33333300003A2A333A2224
        33333338F83338F338F33333000033A33333A222433333338333338F338F3333
        0000333333333A222433333333333338F338F33300003333333333A222433333
        333333338F338F33000033333333333A222433333333333338F338F300003333
        33333333A222433333333333338F338F00003333333333333A22433333333333
        3338F38F000033333333333333A223333333333333338F830000333333333333
        333A333333333333333338330000333333333333333333333333333333333333
        0000}
      NumGlyphs = 2
    end
    object BtnCancelar: TBitBtn
      Left = 279
      Top = 5
      Width = 137
      Height = 33
      Caption = '&Cancelar'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -21
      Font.Name = 'Arial Narrow'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      Kind = bkCancel
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 752
    Height = 19
    Align = alTop
    Alignment = taLeftJustify
    BevelInner = bvLowered
    BevelOuter = bvNone
    Caption = 'Finaliza Venda - Escolha a(s) Forma(s) de Pagamento(s)'
    Color = clInfoBk
    Font.Charset = ANSI_CHARSET
    Font.Color = clNavy
    Font.Height = -17
    Font.Name = 'Arial'
    Font.Style = [fsBold, fsItalic]
    ParentFont = False
    TabOrder = 1
  end
  object Panel3: TPanel
    Left = 0
    Top = 19
    Width = 752
    Height = 376
    Align = alClient
    TabOrder = 2
    object Label9: TLabel
      Left = 1
      Top = 20
      Width = 112
      Height = 19
      Caption = 'Total Produtos'
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlue
      Font.Height = -16
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
    end
    object Label1: TLabel
      Left = 8
      Top = 70
      Width = 104
      Height = 19
      Caption = 'Desconto......:'
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlack
      Font.Height = -16
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
    end
    object Label3: TLabel
      Left = 8
      Top = 120
      Width = 101
      Height = 19
      Caption = 'Acr'#233'scimo.....'
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlack
      Font.Height = -16
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
    end
    object BtnCalcAcresDesconto: TSpeedButton
      Left = 24
      Top = 255
      Width = 240
      Height = 33
      Caption = 'Ca&lcular Acr'#233'scimo / Desconto'
      Flat = True
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      Glyph.Data = {
        F6000000424DF600000000000000760000002800000010000000100000000100
        0400000000008000000000000000000000001000000010000000000000000000
        BF0000BF000000BFBF00BF000000BF00BF00BFBF0000C0C0C000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00777777777777
        7777700000000000000070777777777777707078078078078070707F07F07F07
        F07070777777777777707078078078078070707F07F07F07F070707777777777
        777070700000000077707070FFFFFFF077707070000000007770707777777777
        7770770000000000000777777777777777777777777777777777}
      ParentFont = False
    end
    object Label23: TLabel
      Left = 8
      Top = 167
      Width = 103
      Height = 19
      Caption = 'Recebido......:'
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlue
      Font.Height = -16
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
    end
    object Label24: TLabel
      Left = 8
      Top = 227
      Width = 102
      Height = 19
      Caption = 'Troco.............:'
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlue
      Font.Height = -16
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
    end
    object btnPagamentoParcelado: TSpeedButton
      Left = 24
      Top = 295
      Width = 240
      Height = 33
      Caption = 'Paga&mento Parcelado'
      Flat = True
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      Glyph.Data = {
        06020000424D0602000000000000760000002800000028000000140000000100
        0400000000009001000000000000000000001000000000000000000000000000
        80000080000000808000800000008000800080800000C0C0C000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
        3333333333333333333333333333333333333333333333333333333333333333
        3333333333333333333333333FFFFFFFFFFFFFFFFFFF00000000000000000003
        8888888888888888888F088888088888088888038F33338F33338F33338F0777
        78070708077778038F33338F33338F33338F070008070708077078038F33338F
        33338F33338F077078070708070008038F33338F33338F33338F077778077778
        077778038FFFFF8FFFFF8FFFFF8F000000000000000000038888888888888888
        888F088888088888088888038F33338F33338F33338F07707807000807077803
        8F33338F33338F33338F070078077778070078038F33338F33338F33338F0770
        78070008070778038F33338F33338F33338F077778077778077778038FFFFF8F
        FFFF8FFFFF8F000CCCCCCCCCCCCCCC038888888888888888888F0FFCCCCCCCCC
        CCCCCC038FF8FFFFFFFFFFFFFF8F000000000000000000038888888888888888
        8883333333333333333333333333333333333333333333333333333333333333
        33333333333333333333}
      NumGlyphs = 2
      ParentFont = False
    end
    object btnObservacao: TSpeedButton
      Left = 24
      Top = 338
      Width = 240
      Height = 33
      Caption = 'Digita Observa'#231#227'o'
      Flat = True
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      Glyph.Data = {
        42010000424D4201000000000000760000002800000011000000110000000100
        040000000000CC00000000000000000000001000000010000000000000000000
        BF0000BF000000BFBF00BF000000BF00BF00BFBF0000C0C0C000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00777777777777
        7777700000007777777770000000000000007777747770FFFFFF000000007777
        744770F8888F000000007444444470FFFFFF000000007777744770F8888F0000
        00007777747770FFFFFF000000007777777770F8888F000000007770000070FF
        FFFF000000007770FFF07000000000000000700000F0777777777000000070FF
        F0F0777777777000000070F8F000777777777000000070F8F007777777777000
        000070FF00777777777770000000700007777777777770000000777777777777
        777770000000}
      ParentFont = False
    end
    object edtTotalproduto: TCurrencyEdit
      Left = 114
      Top = 3
      Width = 166
      Height = 43
      TabStop = False
      AutoSize = False
      Color = clBtnFace
      DisplayFormat = '0.00;-0.00'
      Font.Charset = ANSI_CHARSET
      Font.Color = clGreen
      Font.Height = -21
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      ParentShowHint = False
      ReadOnly = True
      ShowHint = True
      TabOrder = 0
      ZeroEmpty = False
    end
    object edtDesconto: TCurrencyEdit
      Left = 111
      Top = 53
      Width = 170
      Height = 43
      AutoSize = False
      DisplayFormat = '0.00;-0.00'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -21
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
      ZeroEmpty = False
    end
    object edtAcrescimo: TCurrencyEdit
      Left = 111
      Top = 103
      Width = 170
      Height = 43
      AutoSize = False
      DisplayFormat = '0.00;-0.00'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -21
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 2
      ZeroEmpty = False
    end
    object edtRecebido: TCurrencyEdit
      Left = 111
      Top = 149
      Width = 170
      Height = 43
      AutoSize = False
      Color = clBtnFace
      DisplayFormat = '0.00;-0.00'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -21
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      FormatOnEditing = True
      ParentFont = False
      ParentShowHint = False
      ReadOnly = True
      ShowHint = True
      TabOrder = 3
      ZeroEmpty = False
    end
    object edtTroco: TCurrencyEdit
      Left = 111
      Top = 202
      Width = 170
      Height = 43
      TabStop = False
      AutoSize = False
      Color = clBtnFace
      DisplayFormat = '0.00;-0.00'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -21
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      ParentShowHint = False
      ReadOnly = True
      ShowHint = True
      TabOrder = 4
      ZeroEmpty = False
    end
  end
end
