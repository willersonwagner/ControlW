object frmConfiguracoesNFe: TfrmConfiguracoesNFe
  Left = 591
  Top = 55
  BorderStyle = bsDialog
  Caption = 'Configura'#231#245'es do NFC-e'
  ClientHeight = 588
  ClientWidth = 433
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
  object Panel5: TPanel
    Left = 0
    Top = 531
    Width = 433
    Height = 57
    Align = alBottom
    BevelInner = bvLowered
    BevelOuter = bvLowered
    TabOrder = 1
    object BtnOK: TBitBtn
      Left = 88
      Top = 16
      Width = 97
      Height = 25
      Caption = 'OK'
      Default = True
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
      TabOrder = 0
      OnClick = BtnOKClick
    end
    object BtnCancelar: TBitBtn
      Left = 200
      Top = 16
      Width = 97
      Height = 25
      Cancel = True
      Caption = 'Cancelar'
      Glyph.Data = {
        DE010000424DDE01000000000000760000002800000024000000120000000100
        0400000000006801000000000000000000001000000000000000000000000000
        80000080000000808000800000008000800080800000C0C0C000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
        333333333333333333333333000033338833333333333333333F333333333333
        0000333911833333983333333388F333333F3333000033391118333911833333
        38F38F333F88F33300003339111183911118333338F338F3F8338F3300003333
        911118111118333338F3338F833338F3000033333911111111833333338F3338
        3333F8330000333333911111183333333338F333333F83330000333333311111
        8333333333338F3333383333000033333339111183333333333338F333833333
        00003333339111118333333333333833338F3333000033333911181118333333
        33338333338F333300003333911183911183333333383338F338F33300003333
        9118333911183333338F33838F338F33000033333913333391113333338FF833
        38F338F300003333333333333919333333388333338FFF830000333333333333
        3333333333333333333888330000333333333333333333333333333333333333
        0000}
      NumGlyphs = 2
      TabOrder = 1
      OnClick = BtnCancelarClick
    end
  end
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 433
    Height = 531
    Align = alClient
    TabOrder = 2
  end
  object PageControl3: TPageControl
    Left = 0
    Top = 0
    Width = 433
    Height = 531
    ActivePage = TabSheet4
    Align = alClient
    MultiLine = True
    TabOrder = 0
    object TabSheet4: TTabSheet
      Caption = 'Geral'
      ImageIndex = 1
      object GroupBox6: TGroupBox
        Left = 0
        Top = 0
        Width = 425
        Height = 503
        Align = alClient
        Caption = 'Geral'
        TabOrder = 0
        object Label15: TLabel
          Left = 8
          Top = 217
          Width = 57
          Height = 13
          Caption = 'Logo Marca'
        end
        object btnAbrirLogomarca: TSpeedButton
          Left = 235
          Top = 229
          Width = 23
          Height = 24
          Glyph.Data = {
            76010000424D7601000000000000760000002800000020000000100000000100
            04000000000000010000130B0000130B00001000000000000000000000000000
            800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
            FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF0033333333B333
            333B33FF33337F3333F73BB3777BB7777BB3377FFFF77FFFF77333B000000000
            0B3333777777777777333330FFFFFFFF07333337F33333337F333330FFFFFFFF
            07333337F3FF3FFF7F333330F00F000F07333337F77377737F333330FFFFFFFF
            07333FF7F3FFFF3F7FFFBBB0F0000F0F0BB37777F7777373777F3BB0FFFFFFFF
            0BBB3777F3FF3FFF77773330F00F000003333337F773777773333330FFFF0FF0
            33333337F3FF7F37F3333330F08F0F0B33333337F7737F77FF333330FFFF003B
            B3333337FFFF77377FF333B000000333BB33337777777F3377FF3BB3333BB333
            3BB33773333773333773B333333B3333333B7333333733333337}
          NumGlyphs = 2
          OnClick = btnAbrirLogomarcaClick
        end
        object btnAbrirLog: TSpeedButton
          Left = 235
          Top = 277
          Width = 23
          Height = 24
          Glyph.Data = {
            76010000424D7601000000000000760000002800000020000000100000000100
            04000000000000010000130B0000130B00001000000000000000000000000000
            800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
            FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF0033333333B333
            333B33FF33337F3333F73BB3777BB7777BB3377FFFF77FFFF77333B000000000
            0B3333777777777777333330FFFFFFFF07333337F33333337F333330FFFFFFFF
            07333337F3FF3FFF7F333330F00F000F07333337F77377737F333330FFFFFFFF
            07333FF7F3FFFF3F7FFFBBB0F0000F0F0BB37777F7777373777F3BB0FFFFFFFF
            0BBB3777F3FF3FFF77773330F00F000003333337F773777773333330FFFF0FF0
            33333337F3FF7F37F3333330F08F0F0B33333337F7737F77FF333330FFFF003B
            B3333337FFFF77377FF333B000000333BB33337777777F3377FF3BB3333BB333
            3BB33773333773333773B333333B3333333B7333333733333337}
          NumGlyphs = 2
          OnClick = btnAbrirLogClick
        end
        object Label1: TLabel
          Left = 8
          Top = 305
          Width = 60
          Height = 13
          Caption = 'Arquivo PDF'
        end
        object btnAbrirPDF: TSpeedButton
          Left = 235
          Top = 317
          Width = 23
          Height = 24
          Glyph.Data = {
            76010000424D7601000000000000760000002800000020000000100000000100
            04000000000000010000130B0000130B00001000000000000000000000000000
            800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
            FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF0033333333B333
            333B33FF33337F3333F73BB3777BB7777BB3377FFFF77FFFF77333B000000000
            0B3333777777777777333330FFFFFFFF07333337F33333337F333330FFFFFFFF
            07333337F3FF3FFF7F333330F00F000F07333337F77377737F333330FFFFFFFF
            07333FF7F3FFFF3F7FFFBBB0F0000F0F0BB37777F7777373777F3BB0FFFFFFFF
            0BBB3777F3FF3FFF77773330F00F000003333337F773777773333330FFFF0FF0
            33333337F3FF7F37F3333330F08F0F0B33333337F7737F77FF333330FFFF003B
            B3333337FFFF77377FF333B000000333BB33337777777F3377FF3BB3333BB333
            3BB33773333773333773B333333B3333333B7333333733333337}
          NumGlyphs = 2
          OnClick = btnAbrirPDFClick
        end
        object Label2: TLabel
          Left = 8
          Top = 345
          Width = 92
          Height = 13
          Caption = 'Pasta do ControlW:'
        end
        object btnAbrirXML: TSpeedButton
          Left = 235
          Top = 357
          Width = 23
          Height = 24
          Glyph.Data = {
            76010000424D7601000000000000760000002800000020000000100000000100
            04000000000000010000130B0000130B00001000000000000000000000000000
            800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
            FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF0033333333B333
            333B33FF33337F3333F73BB3777BB7777BB3377FFFF77FFFF77333B000000000
            0B3333777777777777333330FFFFFFFF07333337F33333337F333330FFFFFFFF
            07333337F3FF3FFF7F333330F00F000F07333337F77377737F333330FFFFFFFF
            07333FF7F3FFFF3F7FFFBBB0F0000F0F0BB37777F7777373777F3BB0FFFFFFFF
            0BBB3777F3FF3FFF77773330F00F000003333337F773777773333330FFFF0FF0
            33333337F3FF7F37F3333330F08F0F0B33333337F7737F77FF333330FFFF003B
            B3333337FFFF77377FF333B000000333BB33337777777F3377FF3BB3333BB333
            3BB33773333773333773B333333B3333333B7333333733333337}
          NumGlyphs = 2
          OnClick = btnAbrirXMLClick
        end
        object Label22: TLabel
          Left = 240
          Top = 16
          Width = 111
          Height = 13
          Caption = 'Usar Certificado A3'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object edtLogmarcaGeral: TEdit
          Left = 8
          Top = 233
          Width = 228
          Height = 21
          TabOrder = 3
        end
        object edtSalvarLogGeral: TEdit
          Left = 8
          Top = 281
          Width = 228
          Height = 21
          TabOrder = 4
        end
        object rdgTipoDANFE: TRadioGroup
          Left = 8
          Top = 16
          Width = 161
          Height = 49
          Caption = 'DANFE'
          Columns = 2
          ItemIndex = 0
          Items.Strings = (
            'Retrato'
            'Paisagem')
          TabOrder = 0
        end
        object rdgFormaEmissao: TRadioGroup
          Left = 8
          Top = 72
          Width = 410
          Height = 65
          Caption = 'Forma de Emiss'#227'o'
          Columns = 5
          ItemIndex = 0
          Items.Strings = (
            '1 - Normal'
            '2 - Conting'#234'ncia'
            '3 - SCAN'
            '4 - DPEC'
            '5 - NORMAL'
            '6 - FSDA'
            '7 - SVCRS'
            '8 - SVCSP'
            '9 - OFF Line')
          TabOrder = 1
        end
        object rdgFinalidade: TRadioGroup
          Left = 8
          Top = 146
          Width = 410
          Height = 65
          Caption = 'Fi&nalidade'
          Columns = 4
          ItemIndex = 0
          Items.Strings = (
            'Normal'
            'Complementar'
            'Ajuste')
          TabOrder = 2
        end
        object edtArquivoPDF: TEdit
          Left = 8
          Top = 321
          Width = 228
          Height = 21
          TabOrder = 5
        end
        object edtArquivosNFe: TEdit
          Left = 8
          Top = 361
          Width = 228
          Height = 21
          TabOrder = 6
        end
        object certificadoA3: TCheckBox
          Left = 248
          Top = 40
          Width = 97
          Height = 17
          Caption = 'Certificado A3'
          TabOrder = 7
        end
      end
    end
    object TabSheet3: TTabSheet
      Caption = 'Certificado'
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object GroupBox3: TGroupBox
        Left = 0
        Top = 0
        Width = 425
        Height = 503
        Align = alClient
        Caption = 'Certificado'
        TabOrder = 0
        object Label13: TLabel
          Left = 8
          Top = 16
          Width = 41
          Height = 13
          Caption = 'Caminho'
        end
        object Label14: TLabel
          Left = 8
          Top = 56
          Width = 31
          Height = 13
          Caption = 'Senha'
        end
        object btnAbrirCertificadoA1: TSpeedButton
          Left = 235
          Top = 32
          Width = 23
          Height = 24
          Glyph.Data = {
            76010000424D7601000000000000760000002800000020000000100000000100
            04000000000000010000130B0000130B00001000000000000000000000000000
            800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
            FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF0033333333B333
            333B33FF33337F3333F73BB3777BB7777BB3377FFFF77FFFF77333B000000000
            0B3333777777777777333330FFFFFFFF07333337F33333337F333330FFFFFFFF
            07333337F3FF3FFF7F333330F00F000F07333337F77377737F333330FFFFFFFF
            07333FF7F3FFFF3F7FFFBBB0F0000F0F0BB37777F7777373777F3BB0FFFFFFFF
            0BBB3777F3FF3FFF77773330F00F000003333337F773777773333330FFFF0FF0
            33333337F3FF7F37F3333330F08F0F0B33333337F7737F77FF333330FFFF003B
            B3333337FFFF77377FF333B000000333BB33337777777F3377FF3BB3333BB333
            3BB33773333773333773B333333B3333333B7333333733333337}
          NumGlyphs = 2
          OnClick = sbtnCaminhoCertClick
        end
        object Label25: TLabel
          Left = 8
          Top = 96
          Width = 79
          Height = 13
          Caption = 'N'#250'mero de S'#233'rie'
        end
        object btnAbrirCertificadoA3: TSpeedButton
          Left = 235
          Top = 110
          Width = 23
          Height = 24
          Glyph.Data = {
            76010000424D7601000000000000760000002800000020000000100000000100
            04000000000000010000130B0000130B00001000000000000000000000000000
            800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
            FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF0033333333B333
            333B33FF33337F3333F73BB3777BB7777BB3377FFFF77FFFF77333B000000000
            0B3333777777777777333330FFFFFFFF07333337F33333337F333330FFFFFFFF
            07333337F3FF3FFF7F333330F00F000F07333337F77377737F333330FFFFFFFF
            07333FF7F3FFFF3F7FFFBBB0F0000F0F0BB37777F7777373777F3BB0FFFFFFFF
            0BBB3777F3FF3FFF77773330F00F000003333337F773777773333330FFFF0FF0
            33333337F3FF7F37F3333330F08F0F0B33333337F7737F77FF333330FFFF003B
            B3333337FFFF77377FF333B000000333BB33337777777F3377FF3BB3333BB333
            3BB33773333773333773B333333B3333333B7333333733333337}
          NumGlyphs = 2
          OnClick = sbtnGetCertClick
        end
        object Label3: TLabel
          Left = 8
          Top = 136
          Width = 33
          Height = 13
          Caption = 'IdCSC:'
        end
        object Label5: TLabel
          Left = 8
          Top = 176
          Width = 24
          Height = 13
          Caption = 'CSC:'
        end
        object edtcaminhocert: TEdit
          Left = 8
          Top = 32
          Width = 225
          Height = 21
          TabOrder = 0
        end
        object edtsenhacert: TEdit
          Left = 8
          Top = 72
          Width = 249
          Height = 21
          PasswordChar = '*'
          TabOrder = 1
        end
        object edtnumeroseriecert: TEdit
          Left = 8
          Top = 112
          Width = 225
          Height = 21
          TabOrder = 2
        end
        object edtIDToken: TEdit
          Left = 8
          Top = 152
          Width = 281
          Height = 21
          TabOrder = 3
        end
        object edtToken: TEdit
          Left = 8
          Top = 192
          Width = 281
          Height = 21
          TabOrder = 4
        end
      end
    end
    object TabSheet5: TTabSheet
      Caption = 'WebService'
      ImageIndex = 2
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object GroupBox7: TGroupBox
        Left = 0
        Top = 0
        Width = 425
        Height = 141
        Align = alTop
        Caption = 'WebService'
        TabOrder = 0
        object Label16: TLabel
          Left = 8
          Top = 16
          Width = 121
          Height = 13
          Caption = 'Selecione UF de Destino:'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object ckVisualizar: TCheckBox
          Left = 8
          Top = 118
          Width = 153
          Height = 17
          Caption = 'Visualizar Mensagem'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 0
        end
        object cbxUF: TComboBox
          Left = 8
          Top = 32
          Width = 249
          Height = 24
          Style = csDropDownList
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ItemIndex = 12
          ParentFont = False
          TabOrder = 1
          Text = 'MG'
          Items.Strings = (
            'AC'
            'AL'
            'AP'
            'AM'
            'BA'
            'CE'
            'DF'
            'ES'
            'GO'
            'MA'
            'MT'
            'MS'
            'MG'
            'PA'
            'PB'
            'PR'
            'PE'
            'PI'
            'RJ'
            'RN'
            'RS'
            'RO'
            'RR'
            'SC'
            'SP'
            'SE'
            'TO')
        end
        object rdgTipoAmbiente: TRadioGroup
          Left = 8
          Top = 61
          Width = 297
          Height = 52
          Caption = 'Selecione o Ambiente de Destino'
          Columns = 3
          ItemIndex = 0
          Items.Strings = (
            'Nenhum'
            'Produ'#231#227'o'
            'Homologa'#231#227'o')
          TabOrder = 2
        end
      end
      object GroupBox8: TGroupBox
        Left = 0
        Top = 141
        Width = 425
        Height = 362
        Align = alClient
        Caption = 'Proxy'
        TabOrder = 1
        object Label17: TLabel
          Left = 8
          Top = 16
          Width = 22
          Height = 13
          Caption = 'Host'
        end
        object Label18: TLabel
          Left = 208
          Top = 16
          Width = 25
          Height = 13
          Caption = 'Porta'
        end
        object Label19: TLabel
          Left = 8
          Top = 56
          Width = 36
          Height = 13
          Caption = 'Usu'#225'rio'
        end
        object Label20: TLabel
          Left = 138
          Top = 56
          Width = 31
          Height = 13
          Caption = 'Senha'
        end
        object edtHostProx: TEdit
          Left = 8
          Top = 32
          Width = 193
          Height = 21
          TabOrder = 0
        end
        object edtPortaProx: TEdit
          Left = 208
          Top = 32
          Width = 50
          Height = 21
          TabOrder = 1
        end
        object edtUsuarioProx: TEdit
          Left = 8
          Top = 72
          Width = 123
          Height = 21
          TabOrder = 2
        end
        object edtSenhaProx: TEdit
          Left = 135
          Top = 72
          Width = 123
          Height = 21
          PasswordChar = '*'
          TabOrder = 3
        end
      end
    end
    object TabSheet7: TTabSheet
      Caption = 'Email'
      ImageIndex = 4
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object GroupBox9: TGroupBox
        Left = 0
        Top = 0
        Width = 425
        Height = 503
        Align = alClient
        Caption = 'Email'
        TabOrder = 0
        object Label38: TLabel
          Left = 8
          Top = 16
          Width = 72
          Height = 13
          Caption = 'Servidor SMTP'
        end
        object Label39: TLabel
          Left = 206
          Top = 16
          Width = 25
          Height = 13
          Caption = 'Porta'
        end
        object Label40: TLabel
          Left = 8
          Top = 56
          Width = 36
          Height = 13
          Caption = 'Usu'#225'rio'
        end
        object Label41: TLabel
          Left = 137
          Top = 56
          Width = 31
          Height = 13
          Caption = 'Senha'
        end
        object Label42: TLabel
          Left = 8
          Top = 96
          Width = 121
          Height = 13
          Caption = 'Assunto do email enviado'
        end
        object Label43: TLabel
          Left = 8
          Top = 168
          Width = 95
          Height = 13
          Caption = 'Mensagem do Email'
        end
        object edtSMTPEmail: TEdit
          Left = 8
          Top = 32
          Width = 193
          Height = 21
          TabOrder = 0
        end
        object edtPortaEmail: TEdit
          Left = 206
          Top = 32
          Width = 51
          Height = 21
          TabOrder = 1
        end
        object edtUsuarioSMTP: TEdit
          Left = 8
          Top = 72
          Width = 120
          Height = 21
          TabOrder = 2
        end
        object edtSenhaEmail: TEdit
          Left = 137
          Top = 72
          Width = 120
          Height = 21
          TabOrder = 3
        end
        object edtAssuntoEmail: TEdit
          Left = 8
          Top = 112
          Width = 249
          Height = 21
          TabOrder = 4
        end
        object chkSeguroEmail: TCheckBox
          Left = 10
          Top = 144
          Width = 167
          Height = 17
          Caption = 'SMTP exige conex'#227'o segura'
          TabOrder = 5
        end
        object MemMensagemEmail: TMemo
          Left = 8
          Top = 184
          Width = 393
          Height = 130
          TabOrder = 6
        end
      end
    end
    object TabSheet1: TTabSheet
      Caption = 'Par'#226'metros'
      ImageIndex = 4
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object GroupBox1: TGroupBox
        Left = 0
        Top = 0
        Width = 425
        Height = 503
        Align = alClient
        Caption = 'Valores Padr'#227'o'
        TabOrder = 0
        object Label4: TLabel
          Left = 25
          Top = 35
          Width = 31
          Height = 13
          Caption = 'CFOP:'
        end
        object Label8: TLabel
          Left = 25
          Top = 83
          Width = 35
          Height = 13
          Caption = 'S'#201'RIE:'
        end
        object edtnucfop: TEdit
          Left = 24
          Top = 50
          Width = 97
          Height = 21
          TabOrder = 0
        end
        object serie: TEdit
          Left = 24
          Top = 98
          Width = 97
          Height = 21
          TabOrder = 1
        end
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'Impress'#227'o'
      ImageIndex = 5
      object Label6: TLabel
        Left = 16
        Top = 8
        Width = 127
        Height = 13
        Caption = 'Impressora Padr'#227'o Cupom:'
      end
      object Label7: TLabel
        Left = 16
        Top = 64
        Width = 114
        Height = 13
        Caption = 'Impressora Padr'#227'o NFe:'
      end
      object Label9: TLabel
        Left = 176
        Top = 8
        Width = 177
        Height = 13
        Caption = 'Qual o Modelo da Impressora NFCe ?'
      end
      object Label10: TLabel
        Left = 176
        Top = 64
        Width = 111
        Height = 13
        Caption = 'Porta de Comunica'#231#227'o:'
      end
      object Label21: TLabel
        Left = 16
        Top = 112
        Width = 98
        Height = 13
        Caption = 'Tipo Impress'#227'o NFe:'
      end
      object Label30: TLabel
        Left = 176
        Top = 112
        Width = 56
        Height = 13
        Caption = 'Velocidade:'
      end
      object IndxImpCupom: TComboBox
        Left = 16
        Top = 32
        Width = 145
        Height = 21
        TabOrder = 0
      end
      object GroupBox2: TGroupBox
        Left = 16
        Top = 160
        Width = 345
        Height = 65
        Caption = 'Tipo de Impress'#227'o'
        TabOrder = 1
        object RadioButton1: TRadioButton
          Left = 16
          Top = 28
          Width = 113
          Height = 17
          Caption = 'Normal'
          Checked = True
          TabOrder = 0
          TabStop = True
        end
        object RadioButton2: TRadioButton
          Left = 121
          Top = 28
          Width = 113
          Height = 17
          Caption = 'EscPos'
          TabOrder = 1
        end
        object RadioButton4: TRadioButton
          Left = 216
          Top = 28
          Width = 113
          Height = 17
          Caption = 'Fast Reports'
          TabOrder = 2
        end
      end
      object RadioButton3: TCheckBox
        Left = 22
        Top = 483
        Width = 121
        Height = 17
        Caption = 'Mostar Preview NFe'
        TabOrder = 2
      end
      object IndxImpNfe: TComboBox
        Left = 16
        Top = 80
        Width = 145
        Height = 21
        TabOrder = 3
        Text = 'ComboBox1'
      end
      object ComboBox1: TComboBox
        Left = 176
        Top = 32
        Width = 145
        Height = 21
        ItemIndex = 0
        TabOrder = 4
        Text = 'ppTexto'
        Items.Strings = (
          'ppTexto'
          'ppEscPosEpson'
          'ppEscBematech'
          'ppEscDaruma'
          'ppEscElgin'
          'ppEscDiebold')
      end
      object PortaCOM: TEdit
        Left = 176
        Top = 80
        Width = 121
        Height = 21
        TabOrder = 5
      end
      object tipoNFe: TComboBox
        Left = 16
        Top = 128
        Width = 145
        Height = 21
        TabOrder = 6
        Text = 'ComboBox1'
      end
      object previewNFCe: TCheckBox
        Left = 164
        Top = 483
        Width = 129
        Height = 17
        Caption = 'Mostar Preview NFCe'
        TabOrder = 7
      end
      object GroupBox4: TGroupBox
        Left = 16
        Top = 231
        Width = 345
        Height = 194
        Caption = 'Logo Marca'
        TabOrder = 8
        object Label23: TLabel
          Left = 16
          Top = 21
          Width = 114
          Height = 13
          Caption = 'Tamanho Logo Largura:'
        end
        object Label24: TLabel
          Left = 156
          Top = 21
          Width = 105
          Height = 13
          Caption = 'Tamanho Logo Altura:'
        end
        object Label26: TLabel
          Left = 16
          Top = 63
          Width = 106
          Height = 13
          Caption = 'Tam. Fonte Endere'#231'o:'
        end
        object Label27: TLabel
          Left = 156
          Top = 63
          Width = 115
          Height = 13
          Caption = 'Tam. Fnte Out, Campos:'
        end
        object Label28: TLabel
          Left = 16
          Top = 103
          Width = 123
          Height = 13
          Caption = 'Tam. Fonte Razao Social:'
        end
        object Label29: TLabel
          Left = 156
          Top = 101
          Width = 119
          Height = 13
          Caption = 'Margem Esquerda NFCe:'
        end
        object LOGOWIDTH: TEdit
          Left = 16
          Top = 40
          Width = 121
          Height = 21
          TabOrder = 0
        end
        object logoheigth: TEdit
          Left = 156
          Top = 40
          Width = 121
          Height = 21
          TabOrder = 1
        end
        object fonteEnde: TEdit
          Left = 16
          Top = 78
          Width = 121
          Height = 21
          TabOrder = 2
        end
        object FonteOutCampos: TEdit
          Left = 156
          Top = 78
          Width = 121
          Height = 21
          TabOrder = 3
        end
        object chkSalvar: TCheckBox
          Left = 16
          Top = 161
          Width = 121
          Height = 15
          Caption = 'Expandir Logo'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 4
        end
        object fonteRazao: TEdit
          Left = 16
          Top = 118
          Width = 121
          Height = 21
          TabOrder = 5
        end
        object MargemEsquerda: JsEditNumero
          Left = 156
          Top = 120
          Width = 121
          Height = 21
          CharCase = ecUpperCase
          TabOrder = 6
          Text = '0,00'
          FormularioComp = 'frmConfiguracoesNFe'
          Indice = 0
          CasasDecimais = 2
        end
      end
      object impDescontoNFCe: TCheckBox
        Left = 22
        Top = 460
        Width = 147
        Height = 17
        Caption = 'Imprimir Desconto NFCe'
        TabOrder = 9
      end
      object velocidade: TEdit
        Left = 176
        Top = 128
        Width = 121
        Height = 21
        TabOrder = 10
      end
    end
    object TabSheet6: TTabSheet
      Caption = 'Conex'#227'o'
      ImageIndex = 6
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object Label11: TLabel
        Left = 8
        Top = 72
        Width = 75
        Height = 13
        Caption = 'Conex'#227'o BD:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label12: TLabel
        Left = 8
        Top = 120
        Width = 144
        Height = 13
        Caption = 'Pasta ControlW Servidor:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object conexaoBD: TEdit
        Left = 8
        Top = 88
        Width = 305
        Height = 24
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 0
      end
      object pastaServidor: TEdit
        Left = 8
        Top = 136
        Width = 305
        Height = 24
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 1
      end
      object Panel1: TPanel
        Left = 8
        Top = 16
        Width = 201
        Height = 41
        BevelOuter = bvSpace
        BorderWidth = 3
        BorderStyle = bsSingle
        Color = clMaroon
        TabOrder = 2
        object usarSerivodrRemoto: TCheckBox
          Left = 8
          Top = 8
          Width = 185
          Height = 17
          Caption = 'Usar Conex'#227'o Servidor'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWhite
          Font.Height = -13
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 0
          OnClick = usarSerivodrRemotoClick
        end
      end
      object Panel2: TPanel
        Left = 8
        Top = 192
        Width = 201
        Height = 41
        BevelOuter = bvSpace
        BorderWidth = 3
        BorderStyle = bsSingle
        Color = clGreen
        TabOrder = 3
        object verificarNotas: TCheckBox
          Left = 8
          Top = 8
          Width = 185
          Height = 17
          Caption = 'Verificar Todas NFCes'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWhite
          Font.Height = -13
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 0
        end
      end
    end
  end
  object OpenDlg: TOpenDialog
    DefaultExt = '*-nfe.XML'
    Filter = 
      'Arquivos NFE (*-nfe.XML)|*-nfe.XML|Arquivos XML (*.XML)|*.XML|To' +
      'dos os Arquivos (*.*)|*.*'
    Title = 'Selecione a NFe'
    Left = 328
    Top = 376
  end
end
