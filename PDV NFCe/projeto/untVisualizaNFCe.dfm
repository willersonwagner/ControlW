object frmConsultaNotas: TfrmConsultaNotas
  Left = 366
  Top = 211
  Width = 928
  Height = 480
  Caption = 'frmConsultaNotas'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  WindowState = wsMaximized
  PixelsPerInch = 96
  TextHeight = 13
  object pnl: TPanel
    Left = 0
    Top = 0
    Width = 920
    Height = 19
    Align = alTop
    Alignment = taLeftJustify
    BevelInner = bvLowered
    BevelOuter = bvNone
    Caption = 'Consulta Todas NFC-e '
    Color = clInfoBk
    Font.Charset = ANSI_CHARSET
    Font.Color = clNavy
    Font.Height = -17
    Font.Name = 'Arial'
    Font.Style = [fsBold, fsItalic]
    ParentFont = False
    TabOrder = 0
  end
  object ToolBar1: TToolBar
    Left = 0
    Top = 19
    Width = 920
    Height = 26
    AutoSize = True
    Caption = 'ToolBar1'
    EdgeBorders = [ebLeft, ebTop, ebRight, ebBottom]
    Flat = True
    Images = dtmMain.imlMain
    TabOrder = 1
    object ToolButton2: TToolButton
      Left = 0
      Top = 0
      Action = actAtualizar
    end
    object ToolButton1: TToolButton
      Left = 23
      Top = 0
      Width = 34
      Caption = 'ToolButton1'
      ImageIndex = 13
      Style = tbsSeparator
    end
    object ToolButton3: TToolButton
      Left = 57
      Top = 0
      Action = actImprimir
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 45
    Width = 920
    Height = 41
    Align = alTop
    TabOrder = 2
    object Label10: TLabel
      Left = 501
      Top = 16
      Width = 56
      Height = 13
      Caption = 'Data Inicial:'
    end
    object Label11: TLabel
      Left = 691
      Top = 16
      Width = 56
      Height = 13
      Caption = 'Data Inicial:'
    end
    object Label12: TLabel
      Left = 9
      Top = 16
      Width = 62
      Height = 13
      Caption = 'Informa'#231#227'o..:'
    end
    object edtDataInicial: TDateEdit
      Left = 557
      Top = 8
      Width = 121
      Height = 21
      NumGlyphs = 2
      TabOrder = 0
    end
    object edtDataFinal: TDateEdit
      Left = 747
      Top = 8
      Width = 121
      Height = 21
      NumGlyphs = 2
      TabOrder = 1
    end
    object cbx: TComboBox
      Left = 73
      Top = 8
      Width = 400
      Height = 21
      ItemHeight = 13
      TabOrder = 2
      Text = '< Selecione uma Op'#231#227'o >'
      Items.Strings = (
        'Todos Cupon'
        'Somente Emitidos'
        'Somente Cancelados')
    end
  end
  object dbGrid: TDBGrid
    Left = 0
    Top = 86
    Width = 920
    Height = 367
    Align = alClient
    DefaultDrawing = False
    TabOrder = 3
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'MS Sans Serif'
    TitleFont.Style = []
    OnDrawColumnCell = dbGridDrawColumnCell
    Columns = <
      item
        Expanded = False
        FieldName = 'NUVENDACFE'
        Title.Caption = 'N'#186' Cupom'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'NMCLIENTE'
        Title.Caption = 'Cliente'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'DTEMISSAO'
        Title.Caption = 'Data Emiss'#227'o'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'HREMISSAO'
        Title.Caption = 'Hora Emiss'#227'o'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'VLTOTAL'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'NFE_SITUACAO'
        Title.Caption = 'Status'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'NFE_RESULTADO'
        Title.Caption = 'Resultado'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'CHAVEACESSO'
        Title.Caption = 'Chave'
        Visible = True
      end>
  end
  object act: TActionManager
    Images = dtmMain.imlMain
    Left = 304
    Top = 8
    StyleName = 'XP Style'
    object actImprimir: TAction
      Caption = 'Imprimir'
      ImageIndex = 3
      OnExecute = actImprimirExecute
    end
    object actAtualizar: TAction
      Caption = 'Atualizar'
      ImageIndex = 12
      OnExecute = actAtualizarExecute
    end
    object actFiltrar: TAction
      Caption = 'Filtar'
      ImageIndex = 13
    end
  end
end
