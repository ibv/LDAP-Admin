object HexView: THexView
  Left = 246
  Top = 168
  BorderStyle = bsDialog
  Caption = 'HexView'
  ClientHeight = 467
  ClientWidth = 700
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnKeyDown = FormKeyDown
  PixelsPerInch = 96
  TextHeight = 13
  object HexGrid: TStringGrid
    Left = 0
    Top = 0
    Width = 473
    Height = 421
    Align = alClient
    ColCount = 17
    DefaultColWidth = 24
    DefaultRowHeight = 18
    RowCount = 22
    FixedRows = 0
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Courier New'
    Font.Pitch = fpFixed
    Font.Style = []
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goDrawFocusSelected]
    ParentFont = False
    PopupMenu = PopupMenu
    ScrollBars = ssNone
    TabOrder = 0
    OnMouseWheelDown = HexGridMouseWheelDown
    OnMouseWheelUp = HexGridMouseWheelUp
    OnSelectCell = HexGridSelectCell
  end
  object Panel1: TPanel
    Left = 0
    Top = 421
    Width = 700
    Height = 46
    Align = alBottom
    TabOrder = 1
    object Bevel1: TBevel
      Left = 8
      Top = 8
      Width = 457
      Height = 30
    end
    object Label1: TLabel
      Left = 272
      Top = 16
      Width = 41
      Height = 13
      Alignment = taRightJustify
      Caption = 'Decimal:'
    end
    object ValueLabel: TLabel
      Left = 316
      Top = 16
      Width = 3
      Height = 13
    end
    object Label3: TLabel
      Left = 360
      Top = 16
      Width = 32
      Height = 13
      Alignment = taRightJustify
      Caption = 'Binary:'
    end
    object BinaryLabel: TLabel
      Left = 396
      Top = 16
      Width = 3
      Height = 13
    end
    object Label2: TLabel
      Left = 144
      Top = 16
      Width = 41
      Height = 13
      Alignment = taRightJustify
      Caption = 'Address:'
    end
    object AddressLabel: TLabel
      Left = 188
      Top = 16
      Width = 3
      Height = 13
    end
    object Label4: TLabel
      Left = 26
      Top = 16
      Width = 23
      Height = 13
      Alignment = taRightJustify
      Caption = 'Size:'
    end
    object SizeLabel: TLabel
      Left = 53
      Top = 16
      Width = 3
      Height = 13
    end
    object Button2: TButton
      Left = 616
      Top = 12
      Width = 75
      Height = 25
      Caption = '&Close'
      TabOrder = 0
      OnClick = Button2Click
    end
  end
  object CharGrid: TStringGrid
    Left = 473
    Top = 0
    Width = 211
    Height = 421
    Align = alRight
    ColCount = 16
    DefaultColWidth = 12
    DefaultRowHeight = 18
    FixedCols = 0
    RowCount = 22
    FixedRows = 0
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Courier New'
    Font.Pitch = fpFixed
    Font.Style = []
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goDrawFocusSelected]
    ParentFont = False
    ScrollBars = ssNone
    TabOrder = 2
    OnMouseWheelDown = HexGridMouseWheelDown
    OnMouseWheelUp = HexGridMouseWheelUp
    OnSelectCell = CharGridSelectCell
  end
  object ScrollBar1: TScrollBar
    Left = 684
    Top = 0
    Width = 16
    Height = 421
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
    Left = 72
    Top = 384
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
