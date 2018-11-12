object frmTransferenciaCupom: TfrmTransferenciaCupom
  Left = 356
  Top = 217
  BorderIcons = []
  BorderStyle = bsDialog
  Caption = 'Transmiss'#227'o de Cupom Eletr'#244'nico'
  ClientHeight = 343
  ClientWidth = 775
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
  object Panel1: TPanel
    Left = 0
    Top = 261
    Width = 775
    Height = 63
    Align = alBottom
    TabOrder = 0
    object btnOK: TBitBtn
      Left = 504
      Top = 16
      Width = 121
      Height = 33
      Caption = '&OK'
      Default = True
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -19
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
    object btnCancelar: TBitBtn
      Left = 640
      Top = 16
      Width = 121
      Height = 33
      Caption = '&Cancelar'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -19
      Font.Name = 'Arial Narrow'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      Kind = bkCancel
    end
  end
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 775
    Height = 261
    ActivePage = tbsWebResposta
    Align = alClient
    TabOrder = 1
    object tbsPrincipal: TTabSheet
      Caption = '&Principal'
    end
    object tbsResposta: TTabSheet
      Caption = '&Resposta'
      ImageIndex = 1
      object MemoResp: TMemo
        Left = 0
        Top = 0
        Width = 767
        Height = 233
        Align = alClient
        ScrollBars = ssVertical
        TabOrder = 0
      end
    end
    object tbsWebResposta: TTabSheet
      Caption = '&WebResposta'
      ImageIndex = 2
      object WBResposta: TWebBrowser
        Left = 0
        Top = 0
        Width = 767
        Height = 233
        Align = alClient
        TabOrder = 0
        ControlData = {
          4C000000464F0000151800000000000000000000000000000000000000000000
          000000004C000000000000000000000001000000E0D057007335CF11AE690800
          2B2E126208000000000000004C0000000114020000000000C000000000000046
          8000000000000000000000000000000000000000000000000000000000000000
          00000000000000000100000000000000000000000000000000000000}
      end
    end
  end
  object stbmain: TStatusBar
    Left = 0
    Top = 324
    Width = 775
    Height = 19
    Panels = <
      item
        Text = 'Forma Emiss'#227'o:'
        Width = 300
      end
      item
        Text = 'Data:'
        Width = 200
      end
      item
        Text = 'Ambiente:'
        Width = 50
      end>
  end
end
