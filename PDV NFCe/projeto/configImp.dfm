object Form6: TForm6
  Left = 510
  Top = 166
  Caption = 'Configura'#231#245'es'
  ClientHeight = 359
  ClientWidth = 273
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label6: TLabel
    Left = 16
    Top = 152
    Width = 85
    Height = 16
    Caption = 'Velocidade:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 273
    Height = 318
    ActivePage = TabSheet1
    Align = alClient
    TabOrder = 0
    object TabSheet1: TTabSheet
      Caption = 'ECF'
      object Label1: TLabel
        Left = 8
        Top = 8
        Width = 83
        Height = 16
        Caption = 'Impressora:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label2: TLabel
        Left = 8
        Top = 48
        Width = 42
        Height = 16
        Caption = 'Porta:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label3: TLabel
        Left = 8
        Top = 88
        Width = 85
        Height = 16
        Caption = 'Velocidade:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label10: TLabel
        Left = 8
        Top = 128
        Width = 146
        Height = 16
        Caption = 'Linhas Entre Cupons:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object ComboBox1: TComboBox
        Left = 8
        Top = 24
        Width = 145
        Height = 21
        TabOrder = 0
        Text = 'ecfBematech'
        Items.Strings = (
          'ecfBematech'
          'ecfDaruma'
          'ecfDataRegis'
          'ecfECFVirtual'
          'ecfEpson'
          'ecfEscECF'
          'ecfFiscNET'
          'ecfICash'
          'ecfMecaf'
          'ecfNaoFiscal'
          'ecfNCR'
          'ecfNenhum'
          'ecfQuattro'
          'ecfSchalter'
          'acfSweda'
          'ecfSwedaSTX'
          'ecfUrano'
          'ecfYanco')
      end
      object porta: TEdit
        Left = 8
        Top = 64
        Width = 121
        Height = 21
        TabOrder = 1
        Text = 'COM1'
      end
      object velocidade: TEdit
        Left = 8
        Top = 104
        Width = 121
        Height = 21
        TabOrder = 2
        Text = '9600'
      end
      object CheckBox1: TCheckBox
        Left = 8
        Top = 176
        Width = 97
        Height = 17
        Caption = 'Abrir Gaveta'
        TabOrder = 3
      end
      object Button1: TButton
        Left = 56
        Top = 240
        Width = 137
        Height = 33
        Caption = 'Testar'
        TabOrder = 4
        OnClick = Button1Click
      end
      object LinhasCupons: TEdit
        Left = 8
        Top = 144
        Width = 121
        Height = 21
        TabOrder = 5
        Text = '7'
      end
      object sinInvertido: TCheckBox
        Left = 8
        Top = 192
        Width = 137
        Height = 17
        Caption = 'Sinal Invertido Gaveta'
        TabOrder = 6
      end
      object corte: TCheckBox
        Left = 8
        Top = 208
        Width = 137
        Height = 17
        Caption = 'For'#231'ar Corte de Papel'
        TabOrder = 7
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'Balan'#231'a'
      ImageIndex = 1
      object Label9: TLabel
        Left = 16
        Top = 88
        Width = 42
        Height = 13
        Caption = 'Balan'#231'a:'
      end
      object Label8: TLabel
        Left = 16
        Top = 48
        Width = 56
        Height = 13
        Caption = 'Velocidade:'
      end
      object Label7: TLabel
        Left = 16
        Top = 8
        Width = 28
        Height = 13
        Caption = 'Porta:'
      end
      object Label5: TLabel
        Left = 16
        Top = 192
        Width = 77
        Height = 13
        Caption = 'Leitura Balan'#231'a:'
      end
      object Label12: TLabel
        Left = 16
        Top = 128
        Width = 81
        Height = 13
        Caption = 'Arredondamento:'
      end
      object TipoBal: TComboBox
        Left = 16
        Top = 104
        Width = 145
        Height = 21
        ItemIndex = 0
        TabOrder = 0
        Text = 'Nenhum'
        Items.Strings = (
          'Nenhum'
          'Digitron'
          'Filizola'
          'LucasTec'
          'Magellan'
          'Magna'
          'Toledo'
          'Toledo2180'
          'Urano'
          'UranoPOP')
      end
      object VeloBal: TEdit
        Left = 16
        Top = 64
        Width = 137
        Height = 21
        CharCase = ecUpperCase
        TabOrder = 1
        Text = '9600'
      end
      object portaBal: TEdit
        Left = 16
        Top = 24
        Width = 137
        Height = 21
        CharCase = ecUpperCase
        TabOrder = 2
        Text = 'COM1'
      end
      object Button3: TButton
        Left = 16
        Top = 240
        Width = 97
        Height = 33
        Caption = 'Testar'
        TabOrder = 3
        OnClick = Button3Click
      end
      object Edit2: TEdit
        Left = 16
        Top = 208
        Width = 145
        Height = 21
        TabOrder = 4
      end
      object balOnline: TCheckBox
        Left = 16
        Top = 168
        Width = 153
        Height = 17
        Caption = 'Usar Balan'#231'a Online'
        TabOrder = 5
      end
      object ComboBox2: TComboBox
        Left = 16
        Top = 144
        Width = 145
        Height = 21
        ItemIndex = 0
        TabOrder = 6
        Text = 'F - Cima'
        Items.Strings = (
          'F - Cima'
          'T - Baixo')
      end
    end
    object TabSheet3: TTabSheet
      Caption = 'Geral'
      ImageIndex = 2
      object Label4: TLabel
        Left = 8
        Top = 8
        Width = 119
        Height = 13
        Caption = 'Intervalo de Itens Venda:'
      end
      object Label11: TLabel
        Left = 8
        Top = 56
        Width = 145
        Height = 13
        Caption = 'Tamanho Fonte Cupom Visual:'
      end
      object Edit1: TEdit
        Left = 8
        Top = 24
        Width = 121
        Height = 21
        TabOrder = 0
        Text = '200'
      end
      object BitBtn1: TBitBtn
        Left = 0
        Top = 248
        Width = 75
        Height = 25
        Caption = 'Cores'
        TabOrder = 1
        OnClick = BitBtn1Click
      end
      object tamFonteCupomVisual: TEdit
        Left = 8
        Top = 72
        Width = 121
        Height = 21
        TabOrder = 2
      end
    end
  end
  object GroupBox1: TGroupBox
    Left = 0
    Top = 318
    Width = 273
    Height = 41
    Align = alBottom
    TabOrder = 1
    object Button2: TButton
      Left = 8
      Top = 10
      Width = 75
      Height = 25
      Caption = 'Gravar'
      TabOrder = 0
      OnClick = Button2Click
    end
  end
end
