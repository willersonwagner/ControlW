object Form16: TForm16
  Left = 568
  Top = 83
  Caption = 'Cadastro de Clientes'
  ClientHeight = 578
  ClientWidth = 743
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  WindowState = wsMaximized
  OnClose = FormClose
  OnKeyUp = FormKeyUp
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object painel: TPanel
    Left = 0
    Top = 0
    Width = 743
    Height = 541
    Align = alClient
    TabOrder = 0
    object Label2: TLabel
      Left = 96
      Top = 2
      Width = 37
      Height = 13
      Caption = 'Nome:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label1: TLabel
      Left = 8
      Top = 2
      Width = 44
      Height = 13
      Caption = 'C'#243'digo:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label3: TLabel
      Left = 480
      Top = 2
      Width = 30
      Height = 13
      Caption = 'Tipo:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label4: TLabel
      Left = 592
      Top = 2
      Width = 34
      Height = 13
      Caption = 'Ativo:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label15: TLabel
      Left = 8
      Top = 168
      Width = 30
      Height = 13
      Caption = 'OBS:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label16: TLabel
      Left = 224
      Top = 208
      Width = 117
      Height = 20
      Caption = 'Pessoa F'#237'sica:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label17: TLabel
      Left = 8
      Top = 216
      Width = 37
      Height = 13
      Caption = 'Nome:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label18: TLabel
      Left = 416
      Top = 216
      Width = 29
      Height = 13
      Caption = 'Nat.:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label19: TLabel
      Left = 552
      Top = 216
      Width = 32
      Height = 13
      Caption = 'Nac.:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label20: TLabel
      Left = 8
      Top = 256
      Width = 55
      Height = 13
      Caption = 'Est. Civil:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label22: TLabel
      Left = 104
      Top = 256
      Width = 51
      Height = 13
      Caption = 'C'#244'njuge:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label23: TLabel
      Left = 544
      Top = 256
      Width = 55
      Height = 13
      Caption = 'Telefone:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label24: TLabel
      Left = 8
      Top = 296
      Width = 55
      Height = 13
      Caption = 'Dt Nasc.:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label25: TLabel
      Left = 88
      Top = 296
      Width = 57
      Height = 13
      Caption = 'Profiss'#227'o:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label26: TLabel
      Left = 224
      Top = 296
      Width = 47
      Height = 13
      Caption = 'Fun'#231#227'o:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label27: TLabel
      Left = 368
      Top = 296
      Width = 42
      Height = 13
      Caption = 'Renda:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label28: TLabel
      Left = 464
      Top = 296
      Width = 45
      Height = 13
      Caption = 'Faturar:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label29: TLabel
      Left = 520
      Top = 296
      Width = 37
      Height = 13
      Caption = 'Prazo:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label30: TLabel
      Left = 568
      Top = 296
      Width = 47
      Height = 13
      Caption = 'Compra:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label31: TLabel
      Left = 640
      Top = 296
      Width = 41
      Height = 13
      Caption = 'Atraso:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label32: TLabel
      Left = 8
      Top = 336
      Width = 18
      Height = 13
      Caption = 'Pai:'
    end
    object Label33: TLabel
      Left = 360
      Top = 336
      Width = 24
      Height = 13
      Caption = 'M'#227'e:'
    end
    object Label34: TLabel
      Left = 8
      Top = 384
      Width = 37
      Height = 13
      Caption = 'Nome:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label35: TLabel
      Left = 232
      Top = 376
      Width = 103
      Height = 20
      Caption = 'Refer'#234'ncias:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label36: TLabel
      Left = 360
      Top = 384
      Width = 31
      Height = 13
      Caption = 'End.:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label37: TLabel
      Left = 544
      Top = 384
      Width = 55
      Height = 13
      Caption = 'Telefone:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label38: TLabel
      Left = 8
      Top = 424
      Width = 37
      Height = 13
      Caption = 'Nome:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label39: TLabel
      Left = 360
      Top = 424
      Width = 31
      Height = 13
      Caption = 'End.:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label40: TLabel
      Left = 544
      Top = 424
      Width = 55
      Height = 13
      Caption = 'Telefone:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label41: TLabel
      Left = 8
      Top = 464
      Width = 35
      Height = 13
      Caption = 'Email:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label44: TLabel
      Left = 372
      Top = 465
      Width = 59
      Height = 13
      Caption = 'C'#243'd Mun.:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object cod: JsEditInteiro
      Left = 8
      Top = 16
      Width = 65
      Height = 24
      CharCase = ecUpperCase
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 0
      OnEnter = codEnter
      OnKeyPress = codKeyPress
      OnKeyUp = codKeyUp
      FormularioComp = 'Form16'
      ColorOnEnter = clSkyBlue
      Indice = 1
      TipoDeDado = teNumero
    end
    object nome: JsEdit
      Left = 96
      Top = 16
      Width = 353
      Height = 24
      CharCase = ecUpperCase
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      MaxLength = 60
      ParentFont = False
      TabOrder = 1
      OnEnter = nomeEnter
      FormularioComp = 'Form16'
      ColorOnEnter = clSkyBlue
      ValidaCampo = True
      Indice = 2
      TipoDeDado = teNumero
    end
    object tipo: JsEditInteiro
      Left = 480
      Top = 16
      Width = 57
      Height = 24
      CharCase = ecUpperCase
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      MaxLength = 40
      ParentFont = False
      TabOrder = 2
      Text = '0'
      OnKeyPress = tipoKeyPress
      FormularioComp = 'Form16'
      ColorOnEnter = clSkyBlue
      Indice = 0
      TipoDeDado = teNumero
    end
    object ativo: JsEdit
      Left = 592
      Top = 16
      Width = 33
      Height = 24
      CharCase = ecUpperCase
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      MaxLength = 1
      ParentFont = False
      TabOrder = 3
      Text = 'N'
      OnKeyDown = ativoKeyDown
      OnKeyPress = ativoKeyPress
      FormularioComp = 'Form16'
      ColorOnEnter = clSkyBlue
      Indice = 0
      TipoDeDado = teNumero
    end
    object Panel1: TPanel
      Left = 8
      Top = 40
      Width = 313
      Height = 129
      BorderStyle = bsSingle
      TabOrder = 4
      object Label5: TLabel
        Left = 8
        Top = 2
        Width = 36
        Height = 13
        Caption = 'CNPJ:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label6: TLabel
        Left = 200
        Top = 2
        Width = 32
        Height = 13
        Caption = 'Rota:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label7: TLabel
        Left = 8
        Top = 40
        Width = 86
        Height = 13
        Caption = 'Insc. Estadual:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label8: TLabel
        Left = 8
        Top = 80
        Width = 33
        Height = 13
        Caption = 'Fone:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label9: TLabel
        Left = 168
        Top = 80
        Width = 44
        Height = 13
        Caption = 'Celular:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label43: TLabel
        Left = 200
        Top = 40
        Width = 39
        Height = 13
        Caption = 'Org'#227'o:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        Visible = False
      end
      object cnpj: JsEditCNPJ
        Left = 8
        Top = 16
        Width = 137
        Height = 24
        EditMask = '!99.999.999/9999-99;1;_'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        MaxLength = 18
        ParentFont = False
        TabOrder = 0
        Text = '  .   .   /    -  '
        OnKeyPress = cnpjKeyPress
      end
      object rota: JsEditInteiro
        Left = 200
        Top = 16
        Width = 49
        Height = 24
        CharCase = ecUpperCase
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        MaxLength = 2
        ParentFont = False
        TabOrder = 1
        OnKeyPress = rotaKeyPress
        FormularioComp = 'Form16'
        ColorOnEnter = clSkyBlue
        Indice = 0
        TipoDeDado = teNumero
      end
      object ies: JsEdit
        Left = 8
        Top = 56
        Width = 177
        Height = 24
        CharCase = ecUpperCase
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        MaxLength = 22
        ParentFont = False
        TabOrder = 2
        FormularioComp = 'Form16'
        ColorOnEnter = clSkyBlue
        Indice = 0
        TipoDeDado = teNumero
      end
      object org: JsEdit
        Left = 200
        Top = 56
        Width = 81
        Height = 24
        CharCase = ecUpperCase
        Enabled = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        MaxLength = 10
        ParentFont = False
        TabOrder = 3
        Visible = False
        FormularioComp = 'Form16'
        ColorOnEnter = clSkyBlue
        Indice = 0
        TipoDeDado = teNumero
      end
      object telres: JsEdit
        Left = 8
        Top = 96
        Width = 129
        Height = 24
        CharCase = ecUpperCase
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        MaxLength = 13
        ParentFont = False
        TabOrder = 4
        FormularioComp = 'Form16'
        ColorOnEnter = clSkyBlue
        Indice = 0
        TipoDeDado = teNumero
      end
      object telcom: JsEdit
        Left = 168
        Top = 96
        Width = 137
        Height = 24
        CharCase = ecUpperCase
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        MaxLength = 13
        ParentFont = False
        TabOrder = 5
        FormularioComp = 'Form16'
        ColorOnEnter = clSkyBlue
        Indice = 0
        TipoDeDado = teNumero
      end
    end
    object Panel2: TPanel
      Left = 328
      Top = 40
      Width = 369
      Height = 129
      BorderStyle = bsSingle
      TabOrder = 5
      object Label10: TLabel
        Left = 8
        Top = 8
        Width = 31
        Height = 13
        Caption = 'End.:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label12: TLabel
        Left = 248
        Top = 8
        Width = 38
        Height = 13
        Caption = 'Bairro:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label14: TLabel
        Left = 160
        Top = 64
        Width = 44
        Height = 13
        Caption = 'Estado:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label13: TLabel
        Left = 8
        Top = 64
        Width = 27
        Height = 13
        Caption = 'Cep:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label11: TLabel
        Left = 216
        Top = 64
        Width = 44
        Height = 13
        Caption = 'Cidade:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object ende: JsEdit
        Left = 8
        Top = 24
        Width = 233
        Height = 24
        CharCase = ecUpperCase
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        MaxLength = 40
        ParentFont = False
        TabOrder = 0
        FormularioComp = 'Form16'
        ColorOnEnter = clSkyBlue
        Indice = 0
        TipoDeDado = teNumero
      end
      object bairro: JsEdit
        Left = 248
        Top = 24
        Width = 97
        Height = 24
        CharCase = ecUpperCase
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        MaxLength = 18
        ParentFont = False
        TabOrder = 1
        FormularioComp = 'Form16'
        ColorOnEnter = clSkyBlue
        Indice = 0
        TipoDeDado = teNumero
      end
      object cep: JsEdit
        Left = 8
        Top = 80
        Width = 129
        Height = 24
        CharCase = ecUpperCase
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        MaxLength = 10
        ParentFont = False
        TabOrder = 2
        FormularioComp = 'Form16'
        ColorOnEnter = clSkyBlue
        Indice = 0
        TipoDeDado = teNumero
      end
      object est: JsEdit
        Left = 160
        Top = 80
        Width = 33
        Height = 24
        CharCase = ecUpperCase
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        MaxLength = 2
        ParentFont = False
        TabOrder = 3
        OnKeyPress = estKeyPress
        FormularioComp = 'Form16'
        ColorOnEnter = clSkyBlue
        Indice = 0
        TipoDeDado = teNumero
      end
      object cid: JsEdit
        Left = 216
        Top = 80
        Width = 129
        Height = 24
        CharCase = ecUpperCase
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        MaxLength = 18
        ParentFont = False
        TabOrder = 4
        OnChange = cidChange
        OnKeyPress = cidKeyPress
        FormularioComp = 'Form16'
        ColorOnEnter = clSkyBlue
        Indice = 0
        TipoDeDado = teNumero
      end
    end
    object obs: JsEdit
      Left = 8
      Top = 184
      Width = 689
      Height = 21
      CharCase = ecUpperCase
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      MaxLength = 60
      ParentFont = False
      TabOrder = 6
      FormularioComp = 'Form16'
      ColorOnEnter = clSkyBlue
      Indice = 0
      TipoDeDado = teNumero
    end
    object titular: JsEdit
      Left = 8
      Top = 232
      Width = 377
      Height = 24
      CharCase = ecUpperCase
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      MaxLength = 40
      ParentFont = False
      TabOrder = 7
      FormularioComp = 'Form16'
      ColorOnEnter = clSkyBlue
      Indice = 0
      TipoDeDado = teNumero
    end
    object nat: JsEdit
      Left = 416
      Top = 232
      Width = 113
      Height = 24
      CharCase = ecUpperCase
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      MaxLength = 13
      ParentFont = False
      TabOrder = 8
      FormularioComp = 'Form16'
      ColorOnEnter = clSkyBlue
      Indice = 0
      TipoDeDado = teNumero
    end
    object nac: JsEdit
      Left = 552
      Top = 232
      Width = 145
      Height = 24
      CharCase = ecUpperCase
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      MaxLength = 13
      ParentFont = False
      TabOrder = 9
      FormularioComp = 'Form16'
      ColorOnEnter = clSkyBlue
      Indice = 0
      TipoDeDado = teNumero
    end
    object estcv: JsEditInteiro
      Left = 8
      Top = 272
      Width = 57
      Height = 24
      CharCase = ecUpperCase
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 10
      Text = '0'
      OnKeyPress = estcvKeyPress
      FormularioComp = 'Form16'
      ColorOnEnter = clSkyBlue
      Indice = 0
      TipoDeDado = teNumero
    end
    object conj: JsEdit
      Left = 104
      Top = 272
      Width = 385
      Height = 24
      CharCase = ecUpperCase
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      MaxLength = 40
      ParentFont = False
      TabOrder = 11
      FormularioComp = 'Form16'
      ColorOnEnter = clSkyBlue
      Indice = 0
      TipoDeDado = teNumero
    end
    object tel: JsEdit
      Left = 544
      Top = 272
      Width = 153
      Height = 24
      CharCase = ecUpperCase
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      MaxLength = 15
      ParentFont = False
      TabOrder = 12
      FormularioComp = 'Form16'
      ColorOnEnter = clSkyBlue
      Indice = 0
      TipoDeDado = teNumero
    end
    object data: JsEditData
      Left = 8
      Top = 312
      Width = 73
      Height = 24
      EditMask = '!99/99/0000;1;_'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      MaxLength = 10
      ParentFont = False
      TabOrder = 13
      Text = '  /  /    '
      ValidaCampo = False
      CompletaData = False
      ColorOnEnter = clSkyBlue
    end
    object prof: JsEdit
      Left = 88
      Top = 312
      Width = 121
      Height = 24
      CharCase = ecUpperCase
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      MaxLength = 15
      ParentFont = False
      TabOrder = 14
      FormularioComp = 'Form16'
      ColorOnEnter = clSkyBlue
      Indice = 0
      TipoDeDado = teNumero
    end
    object ocup: JsEdit
      Left = 224
      Top = 312
      Width = 129
      Height = 24
      CharCase = ecUpperCase
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      MaxLength = 15
      ParentFont = False
      TabOrder = 15
      FormularioComp = 'Form16'
      ColorOnEnter = clSkyBlue
      Indice = 0
      TipoDeDado = teNumero
    end
    object sal: JsEditNumero
      Left = 368
      Top = 312
      Width = 81
      Height = 24
      CharCase = ecUpperCase
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 16
      Text = '0,00'
      FormularioComp = 'Form16'
      ColorOnEnter = clSkyBlue
      Indice = 0
      TipoDeDado = teNumero
      CasasDecimais = 2
    end
    object faturar: JsEdit
      Left = 464
      Top = 312
      Width = 41
      Height = 24
      CharCase = ecUpperCase
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      MaxLength = 1
      ParentFont = False
      TabOrder = 17
      FormularioComp = 'Form16'
      ColorOnEnter = clSkyBlue
      Indice = 0
      TipoDeDado = teNumero
    end
    object prazo: JsEditInteiro
      Left = 512
      Top = 312
      Width = 49
      Height = 24
      CharCase = ecUpperCase
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 18
      Text = '0'
      FormularioComp = 'Form16'
      ColorOnEnter = clSkyBlue
      Indice = 0
      TipoDeDado = teNumero
    end
    object lim_compra: JsEditNumero
      Left = 568
      Top = 312
      Width = 65
      Height = 24
      CharCase = ecUpperCase
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 19
      Text = '0,00'
      FormularioComp = 'Form16'
      ColorOnEnter = clSkyBlue
      Indice = 0
      TipoDeDado = teNumero
      CasasDecimais = 2
    end
    object lim_atraso: JsEditNumero
      Left = 640
      Top = 312
      Width = 49
      Height = 24
      CharCase = ecUpperCase
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 20
      Text = '0,00'
      FormularioComp = 'Form16'
      ColorOnEnter = clSkyBlue
      Indice = 0
      TipoDeDado = teNumero
      CasasDecimais = 2
    end
    object pai: JsEdit
      Left = 8
      Top = 352
      Width = 337
      Height = 24
      CharCase = ecUpperCase
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      MaxLength = 40
      ParentFont = False
      TabOrder = 21
      FormularioComp = 'Form16'
      ColorOnEnter = clSkyBlue
      Indice = 0
      TipoDeDado = teNumero
    end
    object mae: JsEdit
      Left = 360
      Top = 352
      Width = 337
      Height = 24
      CharCase = ecUpperCase
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      MaxLength = 40
      ParentFont = False
      TabOrder = 22
      FormularioComp = 'Form16'
      ColorOnEnter = clSkyBlue
      Indice = 0
      TipoDeDado = teNumero
    end
    object nome1: JsEdit
      Left = 8
      Top = 400
      Width = 337
      Height = 24
      CharCase = ecUpperCase
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      MaxLength = 35
      ParentFont = False
      TabOrder = 23
      FormularioComp = 'Form16'
      ColorOnEnter = clSkyBlue
      Indice = 0
      TipoDeDado = teNumero
    end
    object end1: JsEdit
      Left = 360
      Top = 400
      Width = 169
      Height = 24
      CharCase = ecUpperCase
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      MaxLength = 35
      ParentFont = False
      TabOrder = 24
      FormularioComp = 'Form16'
      ColorOnEnter = clSkyBlue
      Indice = 0
      TipoDeDado = teNumero
    end
    object tel1: JsEdit
      Left = 544
      Top = 400
      Width = 153
      Height = 24
      CharCase = ecUpperCase
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      MaxLength = 8
      ParentFont = False
      TabOrder = 25
      FormularioComp = 'Form16'
      ColorOnEnter = clSkyBlue
      Indice = 0
      TipoDeDado = teNumero
    end
    object nome2: JsEdit
      Left = 8
      Top = 440
      Width = 337
      Height = 24
      CharCase = ecUpperCase
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      MaxLength = 35
      ParentFont = False
      TabOrder = 26
      FormularioComp = 'Form16'
      ColorOnEnter = clSkyBlue
      Indice = 0
      TipoDeDado = teNumero
    end
    object end2: JsEdit
      Left = 360
      Top = 440
      Width = 169
      Height = 24
      CharCase = ecUpperCase
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      MaxLength = 35
      ParentFont = False
      TabOrder = 27
      FormularioComp = 'Form16'
      ColorOnEnter = clSkyBlue
      Indice = 0
      TipoDeDado = teNumero
    end
    object tel2: JsEdit
      Left = 544
      Top = 440
      Width = 153
      Height = 24
      CharCase = ecUpperCase
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      MaxLength = 8
      ParentFont = False
      TabOrder = 28
      FormularioComp = 'Form16'
      ColorOnEnter = clSkyBlue
      Indice = 0
      TipoDeDado = teNumero
    end
    object cod_mun: JsEdit
      Left = 368
      Top = 477
      Width = 121
      Height = 24
      CharCase = ecUpperCase
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 29
      FormularioComp = 'Form16'
      ColorOnEnter = clSkyBlue
      Indice = 0
      TipoDeDado = teNumero
    end
    object email: JsEdit
      Left = 8
      Top = 477
      Width = 337
      Height = 24
      CharCase = ecLowerCase
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      MaxLength = 35
      ParentFont = False
      TabOrder = 30
      FormularioComp = 'Form16'
      ColorOnEnter = clSkyBlue
      Indice = 0
      TipoDeDado = teNumero
    end
  end
  object ToolBar1: TPanel
    Left = 0
    Top = 541
    Width = 743
    Height = 37
    Align = alBottom
    TabOrder = 1
    object info: TLabel
      Left = 169
      Top = 10
      Width = 214
      Height = 16
      Caption = 'F5-Consulta F9-Busca Por CEP'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      Layout = tlCenter
    end
    object Label42: TLabel
      Left = 397
      Top = 10
      Width = 97
      Height = 16
      Caption = '    Ultimo Cod:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      Layout = tlCenter
    end
    object ulticod: TLabel
      Left = 535
      Top = 10
      Width = 5
      Height = 16
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      Layout = tlCenter
    end
    object JsBotao1: JsBotao
      Left = 0
      Top = 2
      Width = 89
      Height = 31
      Caption = 'Gravar'
      Glyph.Data = {
        F6060000424DF606000000000000360000002800000018000000180000000100
        180000000000C0060000EB0A0000EB0A00000000000000000000CCCCCCCACACA
        C8C8C8C4C4C4BEBEBEBABABAB4B4B4AEAEAEA7A7A7A2A2A29E9E9E9E9E9EA2A2
        A2AAAAAAB0B0B0B6B6B6BDBDBDC2C2C2C7C7C7CACACACCCCCCCCCCCCCCCCCCCC
        CCCCCCCCCCC8C8C8BCBCBCB3B3B3ACACACA5A5A59E9E9E969696919191979797
        8C8C8C8D8D8D9393939A9A9AA0A0A0A8A8A8B0B0B0B7B7B7BFBFBFC7C7C7CCCC
        CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCBCBCBC9C9C9C7C7C7C6C6C6C4C4C4C6
        C6C6BFC1C06B9880ADB8B2C7C7C7C3C3C3C3C3C3C5C5C5C6C6C6C8C8C8CACACA
        CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
        CCCCCCCCCCCCCCCCCCCC669D80298355549472C4C9C6CCCCCCCCCCCCCCCCCCCC
        CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
        CCCCCCCCCCCCCCCCCCCCCCCCCCCCCC6A9B822984552C905E2A8959549271C2C7
        C4CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
        CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC739F882886552B955F2B945F
        2C9660298C59599475C7C9C8CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
        CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC79A28C2888562B
        9B622B9B612B9A612B9A612B9C62298F5961977ACBCBCBCCCCCCCCCCCCCCCCCC
        CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC81A6
        922988562BA0642BA1642BA0642BA0642BA0642BA0642BA26529915B63987CCB
        CBCBCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
        CCCCCC88A897278A5527A5652AA6672AA5672AA5672AA5672AA5672AA5672AA5
        672AA76828925B699B80CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
        CCCCCCCCCCCCCCCC8CAA9A3791624AB67F30AF6F24A96626AA6729AB6929AB69
        29AB6929AB6929AB6929AB6A29AC6B27935C6E9D84CCCCCCCCCCCCCCCCCCCCCC
        CCCCCCCCCCCCCCCCCCCCCCCCCC99B0A438916267C69679CFA466C79648BC8130
        B47124B06926B06A28B16C28B16C28B16C28B16C29B26D29B36D27955C75A089
        CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC8FAC9D3C946768CA987BD5A871CF
        A071CFA06FCE9E60C9944FC3893ABD7B2AB77027B66E26B66E25B66D26B66D27
        B76F27B86F27945C7AA28DCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC3F89625DB98A
        83DFB174D3A371D3A16DD19F69D19C69D09B67D09B61D09858CE9247C6853CC2
        7E32BF772CBD7428BC7125BD7025BA6E25935B80A491CCCCCCCCCCCCCCCCCCCC
        CCCCB7C0BB609D7E6FCA9C78DDAA70D6A26CD6A068D49E68D69F59CB91379966
        50BF875CD69856CF9252CF8F49CB8940C98438C77E32C77B2DC3772A955D89A9
        97CCCCCCCCCCCCCCCCCCCCCCCCB7BEB955987468CB9973E0A96CD9A26DDDA55B
        D39639986782A0914A956E4EC38756D9974FD38F4CD18D49D18C47D08B41CE87
        3BD08637CA803197638EAB9BCCCCCCCCCCCCCCCCCCCCCCCCAEBAB44B956E64D0
        9975E7AE5DDA9A349A6596ACA0CCCCCCA9B9B03E93674BCA8A50DB954AD58F47
        D58D43D38B3FD3893DD28739D48734CC8033956297AEA2CCCCCCCCCCCCCCCCCC
        CCCCCCACB9B248966E52CD8F35A06990AA9CCCCCCCCCCCCCCCCCCCA7B8AF3C95
        6749D08D4CDF9546D99042D88D3ED88B3BD78937D68733D98630CF7E36986593
        AD9FCCCCCCCCCCCCCCCCCCCCCCCCA5B7AD36895D83A794CCCCCCCCCCCCCCCCCC
        CCCCCCCCCCCCA0B3A936966546D58D48E49642DE903EDD8D3BDD8B37DC8933DB
        8730E68B29B66F3D8860CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCBDC3BFCCCCCCCC
        CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC9AB0A5339B6443DC8F42E7943DE28E
        3AE28C36E18A34E88D2DC97A43956BB2BCB6CCCCCCCCCCCCCCCCCCCCCCCCCCCC
        CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC95ADA032
        9D6540E3913FEB943AE68F37EA9030D07F409368B8BEBBCCCCCCCCCCCCCCCCCC
        CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
        CCCCCCCCCCCCCC90A99B2EA1663DE5903CF29734D5833B9365B2BAB5CCCCCCCC
        CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
        CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC8DA8992FA76835D484399665ADB6
        B1CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
        CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC82A894
        3D8F64ACB8B1CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
        CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
        CCCCCCCCCCCCCCCCBAC0BCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC}
      TabOrder = 0
      OnClick = JsBotao1Click
    end
    object JsBotao2: JsBotao
      Left = 89
      Top = 2
      Width = 80
      Height = 31
      Caption = 'Excluir'
      Glyph.Data = {
        F6060000424DF606000000000000360000002800000018000000180000000100
        180000000000C0060000EB0A0000EB0A00000000000000000000CCCCCCCCCCCC
        CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
        CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
        CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC3C3C3CCCCCCCCCCCCCCCCCC
        CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC3C3C3CCCCCCCCCCCCCCCC
        CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC86868610102262
        6262CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC626262101022
        868686CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC7979
        790000410202E50000675C5C5CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC5C
        5C5C0000670202E5000041797979CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
        CCCCCC6A6A6A0000500505FB0A0AFF0606FF00006C555555CCCCCCCCCCCCCCCC
        CCCCCCCC54545400006C0606FF0A0AFF0505FB0000506A6A6ACCCCCCCCCCCCCC
        CCCCCCCCCCCCCCCC6666660000610909FF0F0FFF0E0EFE0F0FFF0A0AFF000074
        4D4D4DCCCCCCCCCCCC4D4D4D0000740A0AFF0F0FFF0E0EFE0F0FFF0909FF0000
        62666666CCCCCCCCCCCCCCCCCCCCCCCC3D3D3E0000CA0E0EFF1616FA1313FA13
        13FA1515FC0E0EFF00007C4E4E4E4E4E4E00007C0E0EFF1515FC1313FA1313FA
        1616FA0E0EFF0000CA3D3D3ECCCCCCCCCCCCCCCCCCCCCCCC9999990000350000
        E91212FF1D1DF61A1AF71A1AF71B1BF91414FF00007B00007B1414FF1B1BF91A
        1AF71A1AF71D1DF61212FF0000E9000035999999CCCCCCCCCCCCCCCCCCCCCCCC
        CCCCCC86868600002F0000DE1616FF2424F32020F32020F32222F41919FF1919
        FF2222F42020F32020F32424F31616FF0000DF00002F868686CCCCCCCCCCCCCC
        CCCCCCCCCCCCCCCCCCCCCCCCCCCC8686860000280000D21B1BFC2C2CF12727F0
        2727F02929F12929F12727F02727F02C2CF11B1BFC0000D2000028868686CCCC
        CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC89898903032600
        00C51D1DF13131EE2F2FED2F2FED2F2FED2F2FED3131EE1D1DF10000C6030326
        898989CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
        CCCCCCCC7E7E7E00001D0707E03838EF3838EB3838EB3838EB3838EB3838EF07
        07E100001D7E7E7ECCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
        CCCCCCCCCCCCCCCCCCB9B9B92D2D3109099E3B3BF14343E94141E94141E94141
        E94141E94343E93B3BF109099E2D2D31BABABACCCCCCCCCCCCCCCCCCCCCCCCCC
        CCCCCCCCCCCCCCCCCCCCCCCCCCCCB4B4B41D1D240C0CA44646FA4E4EE64A4AE6
        4A4AE64F4FE74F4FE74A4AE64A4AE64E4EE64646FA0C0CA41D1D24B4B4B4CCCC
        CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCAFAFAF1818231010A95151F758
        58E55454E55454E55D5DE73232E63232E65D5DE75454E55454E55858E55151F7
        1010A9181823AFAFAFCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCAAAAAA1212211515
        AF5D5DF56262E45E5EE45E5EE46767E63A3AEA0000A20000A23A3AEA6767E65E
        5EE45E5EE46262E45D5DF51515AF121221AAAAAACCCCCCCCCCCCCCCCCCB3B3B3
        0C0C282020B76C6CF46C6CE36868E46969E47373E64040E90000A80303140303
        140000AB4040E87373E56969E46868E46C6CE36C6CF42020B70C0C28B3B3B3CC
        CCCCCCCCCCB1B1B100002A2424DC7B7BE97777E37474E38080E54646E60000A6
        0303179A9A9A9A9A9A03031B0000B14646E68080E47474E37777E37B7BEA2424
        DC00002AB1B1B1CCCCCCCCCCCCCCCCCC7878780000372828D98787E99090E64D
        4DE40000AC020219929292CCCCCCCCCCCC9292920202200000BA4D4DE39090E5
        8787EA2828D9000036787878CCCCCCCCCCCCCCCCCCCCCCCCCCCCCC6E6E6E0000
        423737DE5454E50000B803031E929292CCCCCCCCCCCCCCCCCCCCCCCC92929203
        03250000C75454E63737DC0000406E6E6ECCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
        CCCCCCCCCCCC6767670000540000C9040426959595CCCCCCCCCCCCCCCCCCCCCC
        CCCCCCCCCCCCCC95959504042E0000D200004F676767CCCCCCCCCCCCCCCCCCCC
        CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC5E5E5E10101F959595CCCCCCCCCCCC
        CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC95959510101F5E5E5ECCCCCCCCCC
        CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC3C3C3CC
        CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC3C3C3
        CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
        CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
        CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC}
      TabOrder = 1
      OnClick = JsBotao2Click
    end
  end
end
