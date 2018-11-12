object Form28: TForm28
  Left = 215
  Top = 101
  ClientHeight = 411
  ClientWidth = 722
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnKeyDown = FormKeyDown
  OnKeyPress = FormKeyPress
  PixelsPerInch = 96
  TextHeight = 13
  object Chart1: TChart
    Left = 0
    Top = 0
    Width = 722
    Height = 377
    BackWall.Brush.Style = bsClear
    Legend.TextStyle = ltsRightValue
    Title.Text.Strings = (
      'TChart')
    Title.Visible = False
    BottomAxis.LabelsFormat.Font.Height = -13
    BottomAxis.LabelsFormat.Font.Style = [fsBold]
    LeftAxis.Automatic = False
    LeftAxis.AutomaticMaximum = False
    LeftAxis.AutomaticMinimum = False
    LeftAxis.AxisValuesFormat = '#,##0.###%'
    LeftAxis.ExactDateTime = False
    LeftAxis.Grid.Style = psDashDot
    LeftAxis.Increment = 1.000000000000000000
    LeftAxis.LabelsSeparation = 5
    LeftAxis.LabelStyle = talValue
    LeftAxis.Maximum = 100.000000000000000000
    LeftAxis.Ticks.Style = psDash
    View3D = False
    Align = alClient
    TabOrder = 0
    DefaultCanvas = 'TGDIPlusCanvas'
    ColorPaletteIndex = 13
    object Series1: TBarSeries
      Marks.Style = smsValue
      Marks.Callout.Length = 2
      SeriesColor = 496551
      Title = 'e2eew'
      ValueFormat = '0%'
      MultiBar = mbStacked
      XValues.Name = 'X'
      XValues.Order = loAscending
      YValues.Name = 'Bar'
      YValues.Order = loNone
      object TeeFunction1: TLowTeeFunction
        CalcByValue = False
      end
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 377
    Width = 722
    Height = 34
    Align = alBottom
    TabOrder = 1
    object Label1: TLabel
      Left = 24
      Top = 8
      Width = 86
      Height = 16
      Caption = 'F2 - Imprimir'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
  end
end
