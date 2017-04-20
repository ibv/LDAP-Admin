object CustomMenuDlg: TCustomMenuDlg
  Left = 428
  Height = 510
  Top = 183
  Width = 679
  ActiveControl = TreeView
  Caption = 'Customize menu'
  ClientHeight = 510
  ClientWidth = 679
  Color = clBtnFace
  Menu = MainMenu
  OnCloseQuery = FormCloseQuery
  OnResize = FormResize
  ParentFont = True
  Position = poMainFormCenter
  Visible = False
  object Panel2: TPanel
    Left = 305
    Height = 464
    Top = 0
    Width = 11
    Align = alRight
    BevelOuter = bvNone
    TabOrder = 0
  end
  object Panel3: TPanel
    Left = 0
    Height = 46
    Top = 464
    Width = 679
    Align = alBottom
    BevelOuter = bvNone
    ClientHeight = 46
    ClientWidth = 679
    TabOrder = 1
    object btnCancel: TButton
      Left = 599
      Height = 25
      Top = 12
      Width = 75
      Anchors = [akTop, akRight]
      Caption = '&Cancel'
      ModalResult = 2
      TabOrder = 2
    end
    object btnOK: TButton
      Left = 519
      Height = 25
      Top = 12
      Width = 75
      Anchors = [akTop, akRight]
      Caption = '&OK'
      Enabled = False
      ModalResult = 1
      TabOrder = 1
    end
    object btnReset: TButton
      Left = 439
      Height = 25
      Top = 12
      Width = 75
      Caption = '&Reset'
      OnClick = btnResetClick
      TabOrder = 0
    end
  end
  object Panel4: TPanel
    Left = 673
    Height = 464
    Top = 0
    Width = 6
    Align = alRight
    BevelOuter = bvNone
    TabOrder = 2
  end
  object Panel6: TPanel
    Left = 0
    Height = 464
    Top = 0
    Width = 6
    Align = alLeft
    BevelOuter = bvNone
    TabOrder = 3
  end
  object Panel1: TPanel
    Left = 316
    Height = 464
    Top = 0
    Width = 357
    Align = alRight
    BevelOuter = bvNone
    ClientHeight = 464
    ClientWidth = 357
    TabOrder = 4
    object Panel5: TPanel
      Left = 0
      Height = 464
      Top = 0
      Width = 357
      Align = alClient
      BevelInner = bvLowered
      BevelOuter = bvNone
      ClientHeight = 464
      ClientWidth = 357
      TabOrder = 0
      object Panel8: TPanel
        Left = 1
        Height = 72
        Top = 1
        Width = 355
        Align = alTop
        BevelOuter = bvNone
        ClientHeight = 72
        ClientWidth = 355
        TabOrder = 0
        object Label1: TLabel
          Left = 16
          Height = 15
          Top = 16
          Width = 53
          Caption = 'Ca&ption:'
          ParentColor = False
        end
        object edCaption: TEdit
          Left = 16
          Height = 21
          Top = 32
          Width = 329
          OnChange = edCaptionChange
          TabOrder = 0
        end
      end
      object GroupBox1: TGroupBox
        Left = 16
        Height = 169
        Top = 72
        Width = 329
        Caption = ' &Action '
        ClientHeight = 138
        ClientWidth = 325
        TabOrder = 1
        object rbDisabled: TRadioButton
          Left = 24
          Height = 26
          Top = 4
          Width = 83
          Caption = '&Disabled'
          Checked = True
          OnClick = rbClick
          TabOrder = 0
        end
        object rbDefaultAction: TRadioButton
          Left = 24
          Height = 26
          Top = 44
          Width = 117
          Caption = 'Defaul&t action'
          OnClick = rbClick
          TabOrder = 1
        end
        object rbTemplate: TRadioButton
          Left = 24
          Height = 26
          Top = 84
          Width = 86
          Caption = '&Template'
          OnClick = rbClick
          TabOrder = 2
        end
        object cbTemplate: TComboBox
          Left = 128
          Height = 27
          Top = 82
          Width = 185
          Enabled = False
          ItemHeight = 0
          OnChange = cbTemplateChange
          OnDrawItem = cbTemplateDrawItem
          Style = csOwnerDrawFixed
          TabOrder = 3
        end
        object cbDefaultAction: TComboBox
          Left = 128
          Height = 27
          Top = 42
          Width = 185
          ItemHeight = 0
          Items.Strings = (
            'Entry'
            'User'
            'Computer'
            'Group'
            'Mailing list'
            'Transport table'
            'Organizational unit'
            'Group of unique names'
          )
          OnChange = cbDefaultActionChange
          OnDrawItem = cbDefaultActionDrawItem
          Style = csOwnerDrawFixed
          TabOrder = 4
        end
        object ComboText: TStaticText
          Left = 32
          Height = 4
          Top = 136
          Width = 4
          Font.Color = clBtnShadow
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsItalic]
          OnMouseDown = ComboTextMouseDown
          ParentFont = False
          TabOrder = 5
        end
      end
      object GroupBox2: TGroupBox
        Left = 16
        Height = 89
        Top = 256
        Width = 329
        Caption = 'Hotkey'
        ClientHeight = 58
        ClientWidth = 325
        TabOrder = 2
        object cbShortcutKey: TComboBox
          Left = 200
          Height = 21
          Top = 18
          Width = 97
          ItemHeight = 0
          OnChange = cbCtrlClick
          TabOrder = 0
        end
        object cbCtrl: TCheckBox
          Left = 24
          Height = 26
          Top = 18
          Width = 50
          Caption = 'Ctrl'
          OnClick = cbCtrlClick
          TabOrder = 1
        end
        object cbShift: TCheckBox
          Left = 80
          Height = 26
          Top = 18
          Width = 57
          Caption = 'Shift'
          OnClick = cbCtrlClick
          TabOrder = 2
        end
        object cbAlt: TCheckBox
          Left = 136
          Height = 26
          Top = 18
          Width = 45
          Caption = 'Alt'
          OnClick = cbCtrlClick
          TabOrder = 3
        end
      end
    end
  end
  object TreeView: TTreeView
    Left = 6
    Height = 464
    Top = 0
    Width = 299
    Align = alClient
    DefaultItemHeight = 18
    DragCursor = crDefault
    DragMode = dmAutomatic
    HideSelection = False
    Indent = 19
    PopupMenu = PopupMenu
    ReadOnly = True
    TabOrder = 5
    OnChange = TreeViewChange
    OnChanging = TreeViewChanging
    OnContextPopup = TreeViewContextPopup
    OnCustomDrawItem = TreeViewCustomDrawItem
    OnDragDrop = TreeViewDragDrop
    OnDragOver = TreeViewDragOver
    OnEndDrag = TreeViewEndDrag
    OnStartDrag = TreeViewStartDrag
    Options = [tvoAutoItemHeight, tvoKeepCollapsedNodes, tvoReadOnly, tvoShowButtons, tvoShowLines, tvoShowRoot, tvoToolTips, tvoThemedDraw]
  end
  object MainMenu: TMainMenu
    left = 96
    top = 352
    object mbTest: TMenuItem
      Caption = '&Test'
    end
  end
  object PopupMenu: TPopupMenu
    OnPopup = PopupMenuPopup
    left = 160
    top = 352
    object mbAddItem: TMenuItem
      Caption = 'Add &item'
      OnClick = mbAddItemClick
    end
    object mbAddSubmenu: TMenuItem
      Caption = 'Add &submenu'
      OnClick = mbAddSubmenuClick
    end
    object mbAddSeparator: TMenuItem
      Caption = 'Add &separator'
      OnClick = mbAddSeparatorClick
    end
    object mbDelete: TMenuItem
      Caption = 'Delete...'
      OnClick = mbDeleteClick
    end
  end
  object ScrollTimer: TTimer
    Enabled = False
    OnTimer = ScrollTimerTimer
    left = 32
    top = 352
  end
  object ApplicationEvents1: TApplicationProperties
    OnIdle = ApplicationEvents1Idle
    left = 144
    top = 408
  end
end
