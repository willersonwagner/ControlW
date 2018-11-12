object frmControleSaidaProdutoControlado: TfrmControleSaidaProdutoControlado
  Left = 296
  Top = 246
  BorderStyle = bsDialog
  Caption = 'Controle de Cliente/Medicamento de Uso Cont'#237'nuo'
  ClientHeight = 276
  ClientWidth = 598
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = mnm
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object ntb: TNotebook
    Left = 0
    Top = 42
    Width = 598
    Height = 234
    Align = alClient
    TabOrder = 0
    object TPage
      Left = 0
      Top = 0
      Caption = 'Cadastro'
      object Panel1: TPanel
        Left = 0
        Top = 80
        Width = 598
        Height = 154
        Align = alClient
        BevelInner = bvLowered
        BevelOuter = bvNone
        Caption = 'Panel1'
        TabOrder = 1
        object ntbdetalhe: TNotebook
          Left = 1
          Top = 1
          Width = 596
          Height = 152
          Align = alClient
          TabOrder = 0
          object TPage
            Left = 0
            Top = 0
            Caption = 'cadastro'
            object Panel11: TPanel
              Left = 0
              Top = 0
              Width = 596
              Height = 152
              Align = alClient
              BevelInner = bvLowered
              BevelOuter = bvNone
              TabOrder = 0
              object gbxComercial: TGroupBox
                Left = 1
                Top = 1
                Width = 594
                Height = 150
                Align = alClient
                Caption = 'Especifica'#231#245'es'
                TabOrder = 0
                object Label5: TLabel
                  Left = 3
                  Top = 86
                  Width = 114
                  Height = 13
                  Caption = 'Data Prevista Fim Uso..:'
                end
                object Label7: TLabel
                  Left = 284
                  Top = 60
                  Width = 108
                  Height = 13
                  Caption = 'Data Venda................:'
                end
                object Label8: TLabel
                  Left = 3
                  Top = 33
                  Width = 109
                  Height = 13
                  Caption = 'Data Fabrica'#231#227'o.........:'
                end
                object Label10: TLabel
                  Left = 3
                  Top = 60
                  Width = 111
                  Height = 13
                  Caption = 'Lote.............................:'
                end
                object Label11: TLabel
                  Left = 284
                  Top = 86
                  Width = 109
                  Height = 13
                  Caption = 'N'#250'. Dias de Dura'#231#227'o..:'
                end
                object Label23: TLabel
                  Left = 284
                  Top = 33
                  Width = 109
                  Height = 13
                  Caption = 'Data Validade.............:'
                end
                object edtlote: TIB_Edit
                  Left = 114
                  Top = 52
                  Width = 160
                  Height = 21
                  DataField = 'DSLOTE'
                  DataSource = dts
                  Enabled = False
                  TabOrder = 2
                  OnKeyPress = nextcontrol
                end
                object edtdtvenda: TIB_Edit
                  Left = 393
                  Top = 52
                  Width = 158
                  Height = 21
                  DataField = 'DTVENDA'
                  DataSource = dts
                  Enabled = False
                  TabOrder = 3
                  OnKeyPress = nextcontrol
                end
                object edtfabricacao: TIB_Edit
                  Left = 114
                  Top = 25
                  Width = 158
                  Height = 21
                  DataField = 'DTFABRICACAO'
                  DataSource = dts
                  Enabled = False
                  TabOrder = 0
                  OnKeyPress = nextcontrol
                end
                object edtdtprevfimuso: TIB_Edit
                  Left = 114
                  Top = 78
                  Width = 158
                  Height = 21
                  DataField = 'DTPREVFIMUSO'
                  DataSource = dts
                  TabOrder = 4
                  OnKeyPress = nextcontrol
                end
                object edtnudiasduracao: TIB_Edit
                  Left = 393
                  Top = 78
                  Width = 160
                  Height = 21
                  DataField = 'NUDIASDURACAO'
                  DataSource = dts
                  TabOrder = 5
                  OnKeyPress = nextcontrol
                end
                object edtvalidade: TIB_Edit
                  Left = 393
                  Top = 25
                  Width = 158
                  Height = 21
                  DataField = 'DTVALIDADE'
                  DataSource = dts
                  Enabled = False
                  TabOrder = 1
                  OnKeyPress = nextcontrol
                end
              end
            end
          end
        end
      end
      object Panel2: TPanel
        Left = 0
        Top = 0
        Width = 598
        Height = 80
        Align = alTop
        BevelInner = bvLowered
        BevelOuter = bvNone
        TabOrder = 0
        object Label3: TLabel
          Left = 65
          Top = 2
          Width = 32
          Height = 13
          Caption = 'Cliente'
        end
        object Label1: TLabel
          Left = 8
          Top = 3
          Width = 33
          Height = 13
          Caption = 'C'#243'digo'
        end
        object Label4: TLabel
          Left = 65
          Top = 39
          Width = 37
          Height = 13
          Caption = 'Produto'
        end
        object Label6: TLabel
          Left = 8
          Top = 40
          Width = 33
          Height = 13
          Caption = 'C'#243'digo'
        end
        object edtCodigoCliente: TEdit
          Left = 8
          Top = 17
          Width = 56
          Height = 21
          Enabled = False
          TabOrder = 0
        end
        object edtNomeCliente: TEdit
          Left = 65
          Top = 16
          Width = 520
          Height = 23
          Enabled = False
          Font.Charset = ANSI_CHARSET
          Font.Color = clNavy
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          ReadOnly = True
          TabOrder = 1
          OnKeyPress = nextcontrol
        end
        object edtNomeProduto: TEdit
          Left = 66
          Top = 52
          Width = 520
          Height = 23
          Enabled = False
          Font.Charset = ANSI_CHARSET
          Font.Color = clNavy
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          ReadOnly = True
          TabOrder = 2
          OnKeyPress = nextcontrol
        end
        object edtCodigoProduto: TEdit
          Left = 8
          Top = 54
          Width = 56
          Height = 21
          Enabled = False
          TabOrder = 3
        end
      end
    end
  end
  object ToolBar4: TToolBar
    Left = 0
    Top = 19
    Width = 598
    Height = 23
    AutoSize = True
    ButtonWidth = 69
    Caption = 'ToolBar4'
    EdgeInner = esLowered
    EdgeOuter = esNone
    Flat = True
    Images = dtmMain.imlMain
    List = True
    ShowCaptions = True
    TabOrder = 1
    object ToolButton12: TToolButton
      Left = 0
      Top = 0
      Action = actSalvar
    end
    object ToolButton13: TToolButton
      Left = 69
      Top = 0
      Action = actCancelar
    end
  end
  object pnl: TPanel
    Left = 0
    Top = 0
    Width = 598
    Height = 19
    Align = alTop
    Alignment = taLeftJustify
    BevelInner = bvLowered
    BevelOuter = bvNone
    Caption = 'Controle de Cliente/Medicamento de Uso Cont'#237'nuo'
    Color = clInfoBk
    Font.Charset = ANSI_CHARSET
    Font.Color = clNavy
    Font.Height = -15
    Font.Name = 'Arial'
    Font.Style = [fsBold, fsItalic]
    ParentFont = False
    TabOrder = 2
  end
  object act: TActionList
    Images = dtmMain.imlMain
    Left = 348
    Top = 20
    object actNovo: TAction
      Caption = 'Novo'
      ImageIndex = 0
      ShortCut = 16462
    end
    object actSalvar: TAction
      Caption = 'Salvar'
      Enabled = False
      ImageIndex = 2
      ShortCut = 16467
      OnExecute = actSalvarExecute
    end
    object actCancelar: TAction
      Caption = 'Cancelar'
      Enabled = False
      ImageIndex = 4
      ShortCut = 16474
      OnExecute = actCancelarExecute
    end
  end
  object qry: TIB_Query
    DatabaseName = 'P:\BDPAFECF.GDB'
    FieldsCharCase.Strings = (
      'NMCLIENTE=UPPER'
      'RZSOCIAL=UPPER'
      'NMCONJUGE=UPPER'
      'NMPAI=UPPER'
      'NMMAE=UPPER'
      'DSENDERECO=UPPER'
      'NMBAIRRO=UPPER'
      'NMCIDADE=UPPER'
      'CDENTREGADOMICILIO=UPPER'
      'CDCLIENTE=UPPER'
      'DSREFERENCIA=UPPER')
    FieldsDisplayLabel.Strings = (
      'TPPESSOA=Tipo de Pessoa'
      'NMCLIENTE=Nome do Cliente')
    FieldsEditMask.Strings = (
      'NUCPF=999.999.999-99'
      'NUCXPOSTAL=99999'
      'NUCEP=99999-999'
      'NUCNPJ=99.999.999/9999-99'
      'NURAMAL=9999'
      'NUFAX=(99)9999-9999'
      'NUFONE1=(99)9999-9999'
      'NUFONE2=(99)9999-9999')
    FieldsReadOnly.Strings = (
      'CDCLIENTE=TRUE'
      'CDDETALHE=TRUE'
      'DTVENDA=TRUE'
      'DSLOTE=TRUE'
      'DTFABRICACAO=TRUE'
      'DTVALIDADE=TRUE')
    FieldsVisible.Strings = (
      'DTINCLUSAO=FALSE'
      'HRINCLUSAO=FALSE'
      'USUINCLUSAO=FALSE'
      'COMPINCLUSAO=FALSE'
      'DTALTERACAO=FALSE'
      'HRALTERACAO=FALSE'
      'USUALTERACAO=FALSE'
      'COMPALTERACAO=FALSE')
    IB_Connection = dtmMain.conmain
    IB_Transaction = trnCliente
    SQL.Strings = (
      'SELECT CDSAIDAPRODCONTROLADO'
      '     , CDCLIENTE'
      '     , CDDETALHE'
      '     , NUDIASDURACAO'
      '     , DTVENDA'
      '     , DTPREVFIMUSO'
      '     , DSLOTE'
      '     , DTFABRICACAO'
      '     , DTVALIDADE'
      '     , COMPINCLUSAO'
      '     , USUINCLUSAO'
      '     , COMPALTERACAO'
      '     , USUALTERACAO'
      '     , DTINCLUSAO'
      '     , HRINCLUSAO'
      '     , DTALTERACAO'
      '     , HRALTERACAO'
      'FROM SAIDAPRODCONTROLADO'
      'WHERE CDSAIDAPRODCONTROLADO =:CDSAIDAPRODCONTROLADO'
      'FOR UPDATE')
    OnError = qryError
    ColorScheme = True
    DefaultValues.Strings = (
      'CDUF=1'
      'TPPESSOA=J')
    DeleteSQL.Strings = (
      'DELETE FROM SAIDAPRODCONTROLADO'
      'WHERE'
      '   CDSAIDAPRODCONTROLADO = :OLD_CDSAIDAPRODCONTROLADO')
    EditSQL.Strings = (
      'UPDATE SAIDAPRODCONTROLADO SET'
      '   CDCLIENTE     = :CDCLIENTE,'
      '   CDDETALHE     = :CDDETALHE,'
      '   NUDIASDURACAO = :NUDIASDURACAO,'
      '   DTVENDA       = :DTVENDA,'
      '   DTPREVFIMUSO  = :DTPREVFIMUSO,'
      '   DSLOTE        = :DSLOTE,'
      '   DTFABRICACAO  = :DTFABRICACAO,'
      '   DTVALIDADE    = :DTVALIDADE,'
      '   COMPINCLUSAO  = :COMPINCLUSAO,'
      '   USUINCLUSAO   = :USUINCLUSAO,'
      '   COMPALTERACAO = :COMPALTERACAO,'
      '   USUALTERACAO  = :USUALTERACAO,'
      '   DTINCLUSAO    = :DTINCLUSAO,'
      '   HRINCLUSAO    = :HRINCLUSAO,'
      '   DTALTERACAO   = :DTALTERACAO,'
      '   HRALTERACAO   = :HRALTERACAO'
      'WHERE'
      '   CDSAIDAPRODCONTROLADO = :OLD_CDSAIDAPRODCONTROLADO')
    InsertSQL.Strings = (
      
        'INSERT INTO SAIDAPRODCONTROLADO(  CDSAIDAPRODCONTROLADO,  CDCLIE' +
        'NTE,  CDDETALHE,  NUDIASDURACAO,  DTVENDA,  DTPREVFIMUSO,  DSLOT' +
        'E,  DTFABRICACAO,  DTVALIDADE,  COMPINCLUSAO,  USUINCLUSAO,  COM' +
        'PALTERACAO,  USUALTERACAO,  DTINCLUSAO,  HRINCLUSAO,  DTALTERACA' +
        'O,  HRALTERACAO)'
      
        '                        VALUES ( :CDSAIDAPRODCONTROLADO, :CDCLIE' +
        'NTE, :CDDETALHE, :NUDIASDURACAO, :DTVENDA, :DTPREVFIMUSO, :DSLOT' +
        'E, :DTFABRICACAO, :DTVALIDADE, :COMPINCLUSAO, :USUINCLUSAO, :COM' +
        'PALTERACAO, :USUALTERACAO, :DTINCLUSAO, :HRINCLUSAO, :DTALTERACA' +
        'O, :HRALTERACAO)')
    KeyLinks.Strings = (
      'SAIDAPRODCONTROLADO.CDSAIDAPRODCONTROLADO')
    RequestLive = True
    AfterDelete = qryAfterDelete
    BeforeDelete = qryBeforeDelete
    BeforePost = qryBeforePost
    Left = 376
    Top = 20
  end
  object dts: TIB_DataSource
    Dataset = qry
    OnStateChanged = dtsStateChanged
    Left = 404
    Top = 20
  end
  object mnm: TMainMenu
    Images = dtmMain.imlMain
    Left = 320
    Top = 20
    object Registro1: TMenuItem
      Caption = '&Registro'
      GroupIndex = 1
      object Salvar1: TMenuItem
        Action = actSalvar
      end
      object Cancelar1: TMenuItem
        Action = actCancelar
      end
    end
  end
  object trnCliente: TIB_Transaction
    IB_Connection = dtmMain.conmain
    Isolation = tiConcurrency
    Left = 432
    Top = 20
  end
end
