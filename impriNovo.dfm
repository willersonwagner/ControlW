object Form50: TForm50
  Left = 334
  Top = 163
  Width = 609
  Height = 376
  Caption = 'Ordens de Servi'#231'os - ControlW'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  Menu = MainMenu1
  OldCreateOrder = False
  Position = poScreenCenter
  OnKeyPress = FormKeyPress
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 0
    Top = 0
    Width = 601
    Height = 36
    Align = alTop
    Alignment = taCenter
    Caption = 'Sistema de Servi'#231'os'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -32
    Font.Name = 'Cooper Black'
    Font.Style = []
    ParentFont = False
  end
  object Label2: TLabel
    Left = 24
    Top = 56
    Width = 6
    Height = 20
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object MainMenu1: TMainMenu
    Left = 16
    Top = 8
    object Lanamentos1: TMenuItem
      Caption = 'Lan'#231'amentos'
      object OrdemdeServio1: TMenuItem
        Caption = 'Ordem de Servi'#231'o'
        OnClick = OrdemdeServio1Click
      end
      object Cancelamentos1: TMenuItem
        Caption = 'Cancelamentos'
      end
      object Reimpresso1: TMenuItem
        Caption = 'Reimpress'#227'o'
      end
      object Oramento1: TMenuItem
        Caption = 'Or'#231'amento'
      end
      object Sada1: TMenuItem
        Caption = 'Sa'#237'da'
      end
    end
    object Consultas1: TMenuItem
      Caption = 'Consultas'
      object OrdemdeServio2: TMenuItem
        Caption = 'Ordem de Servi'#231'o'
        OnClick = OrdemdeServio2Click
      end
      object Encerradas1: TMenuItem
        Caption = 'O. S. Encerradas'
      end
    end
    object Peas1: TMenuItem
      Caption = 'Pe'#231'as'
      object SepararPeas1: TMenuItem
        Caption = 'Separar Pe'#231'as'
      end
    end
    object Relatrios1: TMenuItem
      Caption = 'Relat'#243'rios'
      object RelatrioPendentes1: TMenuItem
        Caption = 'Pendentes'
      end
      object Encerrados1: TMenuItem
        Caption = 'Encerradas'
      end
      object PorSitouDiag1: TMenuItem
        Caption = 'Por Sit. ou Diag.'
      end
      object PorCliente1: TMenuItem
        Caption = 'Por Cliente'
      end
    end
  end
end
