object HexView: THexView
  Left = 309
  Height = 463
  Top = 236
  Width = 748
  BorderStyle = bsDialog
  Caption = 'HexView'
  ClientHeight = 463
  ClientWidth = 748
  Color = clBtnFace
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  KeyPreview = True
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnKeyDown = FormKeyDown
  LCLVersion = '1.6.0.4'
  object HexGrid: TStringGrid
    Left = 0
    Height = 409
    Top = 0
    Width = 521
    Align = alClient
    ColCount = 17
    DefaultColWidth = 23
    DefaultRowHeight = 18
    FixedRows = 0
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Courier New'
    Font.Pitch = fpFixed
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goDrawFocusSelected]
    ParentFont = False
    PopupMenu = PopupMenu
    RowCount = 22
    ScrollBars = ssNone
    TabOrder = 0
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Courier New'
    TitleFont.Pitch = fpFixed
    OnMouseWheelDown = HexGridMouseWheelDown
    OnMouseWheelUp = HexGridMouseWheelUp
    OnSelectCell = HexGridSelectCell
  end
  object Panel1: TPanel
    Left = 0
    Height = 54
    Top = 409
    Width = 748
    Align = alBottom
    ClientHeight = 54
    ClientWidth = 748
    TabOrder = 1
    object Bevel1: TBevel
      Left = 8
      Height = 30
      Top = 8
      Width = 457
    end
    object Label1: TLabel
      Left = 256
      Height = 13
      Top = 16
      Width = 49
      Alignment = taRightJustify
      Caption = 'Decimal:'
      ParentColor = False
    end
    object ValueLabel: TLabel
      Left = 316
      Height = 1
      Top = 16
      Width = 1
      ParentColor = False
    end
    object Label3: TLabel
      Left = 356
      Height = 13
      Top = 16
      Width = 39
      Alignment = taRightJustify
      Caption = 'Binary:'
      ParentColor = False
    end
    object BinaryLabel: TLabel
      Left = 396
      Height = 1
      Top = 16
      Width = 1
      ParentColor = False
    end
    object Label2: TLabel
      Left = 130
      Height = 13
      Top = 16
      Width = 51
      Alignment = taRightJustify
      Caption = 'Address:'
      ParentColor = False
    end
    object AddressLabel: TLabel
      Left = 188
      Height = 1
      Top = 16
      Width = 1
      ParentColor = False
    end
    object Label4: TLabel
      Left = 26
      Height = 13
      Top = 16
      Width = 27
      Alignment = taRightJustify
      Caption = 'Size:'
      ParentColor = False
    end
    object SizeLabel: TLabel
      Left = 53
      Height = 1
      Top = 16
      Width = 1
      ParentColor = False
    end
    object Button2: TButton
      Left = 616
      Height = 25
      Top = 12
      Width = 75
      Caption = '&Close'
      OnClick = Button2Click
      TabOrder = 0
    end
  end
  object CharGrid: TStringGrid
    Left = 521
    Height = 409
    Top = 0
    Width = 211
    Align = alRight
    ColCount = 16
    DefaultColWidth = 12
    DefaultRowHeight = 18
    FixedCols = 0
    FixedRows = 0
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Courier New'
    Font.Pitch = fpFixed
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goDrawFocusSelected]
    ParentFont = False
    RowCount = 22
    ScrollBars = ssNone
    TabOrder = 2
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Courier New'
    TitleFont.Pitch = fpFixed
    OnMouseWheelDown = HexGridMouseWheelDown
    OnMouseWheelUp = HexGridMouseWheelUp
    OnSelectCell = CharGridSelectCell
  end
  object ScrollBar1: TScrollBar
    Left = 732
    Height = 409
    Top = 0
    Width = 16
    Align = alRight
    Kind = sbVertical
    LargeChange = 8
    Max = 0
    PageSize = 0
    TabOrder = 3
    TabStop = False
    OnChange = ScrollBar1Change
  end
  object PopupMenu: TPopupMenu
    left = 104
    top = 360
    object pbHex: TMenuItem
      Caption = 'Hex view'
      Checked = True
      GroupIndex = 1
      OnClick = pbHexClick
    end
    object pbDecimal: TMenuItem
      Caption = 'Decimal View'
      GroupIndex = 1
      OnClick = pbHexClick
    end
  end
end
