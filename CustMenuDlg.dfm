object CustomMenuDlg: TCustomMenuDlg
  Left = 428
  Height = 548
  Top = 183
  Width = 695
  ActiveControl = TreeView
  Caption = 'Customize menu'
  ClientHeight = 529
  ClientWidth = 695
  Color = clBtnFace
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Menu = MainMenu
  OnCloseQuery = FormCloseQuery
  OnResize = FormResize
  Position = poMainFormCenter
  LCLVersion = '1.6.0.4'
  object Panel2: TPanel
    Left = 321
    Height = 483
    Top = 0
    Width = 11
    Align = alRight
    BevelOuter = bvNone
    TabOrder = 0
  end
  object Panel3: TPanel
    Left = 0
    Height = 46
    Top = 483
    Width = 695
    Align = alBottom
    BevelOuter = bvNone
    ClientHeight = 46
    ClientWidth = 695
    TabOrder = 1
    object btnCancel: TButton
      Left = 605
      Height = 25
      Top = 10
      Width = 75
      Anchors = [akTop, akRight]
      Caption = '&Cancel'
      ModalResult = 2
      TabOrder = 1
    end
    object btnOK: TButton
      Left = 525
      Height = 25
      Top = 10
      Width = 75
      Anchors = [akTop, akRight]
      Caption = '&OK'
      ModalResult = 1
      TabOrder = 0
    end
  end
  object Panel4: TPanel
    Left = 689
    Height = 483
    Top = 0
    Width = 6
    Align = alRight
    BevelOuter = bvNone
    TabOrder = 2
  end
  object Panel6: TPanel
    Left = 0
    Height = 483
    Top = 0
    Width = 6
    Align = alLeft
    BevelOuter = bvNone
    TabOrder = 3
  end
  object Panel1: TPanel
    Left = 332
    Height = 483
    Top = 0
    Width = 357
    Align = alRight
    BevelOuter = bvNone
    ClientHeight = 483
    ClientWidth = 357
    TabOrder = 4
    object Panel5: TPanel
      Left = 0
      Height = 483
      Top = 0
      Width = 357
      Align = alClient
      BevelInner = bvLowered
      BevelOuter = bvNone
      ClientHeight = 483
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
          Left = 14
          Height = 13
          Top = 14
          Width = 47
          Caption = 'Ca&ption:'
          ParentColor = False
        end
        object edCaption: TEdit
          Left = 14
          Height = 19
          Top = 30
          Width = 329
          OnChange = edCaptionChange
          TabOrder = 0
        end
      end
      object GroupBox1: TGroupBox
        Left = 14
        Height = 169
        Top = 70
        Width = 329
        Caption = ' &Action '
        ClientHeight = 140
        ClientWidth = 325
        TabOrder = 1
        object rbDisabled: TRadioButton
          Left = 22
          Height = 26
          Top = 18
          Width = 77
          Caption = '&Disabled'
          Checked = True
          OnClick = rbClick
          TabOrder = 0
        end
        object rbDefaultAction: TRadioButton
          Left = 22
          Height = 26
          Top = 58
          Width = 106
          Caption = 'Defaul&t action'
          OnClick = rbClick
          TabOrder = 1
        end
        object rbTemplate: TRadioButton
          Left = 22
          Height = 26
          Top = 98
          Width = 79
          Caption = '&Template'
          OnClick = rbClick
          TabOrder = 2
        end
        object cbTemplate: TComboBox
          Left = 126
          Height = 27
          Top = 96
          Width = 185
          Enabled = False
          ItemHeight = 16
          OnChange = cbTemplateChange
          OnDrawItem = cbTemplateDrawItem
          Style = csOwnerDrawFixed
          TabOrder = 3
        end
        object cbDefaultAction: TComboBox
          Left = 126
          Height = 27
          Top = 56
          Width = 185
          ItemHeight = 16
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
          Left = 30
          Height = 4
          Top = 122
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
        Left = 14
        Height = 89
        Top = 254
        Width = 329
        Caption = 'Hotkey'
        ClientHeight = 60
        ClientWidth = 325
        TabOrder = 2
        object cbShortcutKey: TComboBox
          Left = 198
          Height = 20
          Top = 26
          Width = 97
          ItemHeight = 0
          TabOrder = 0
        end
        object cbCtrl: TCheckBox
          Left = 22
          Height = 26
          Top = 26
          Width = 50
          Caption = 'Ctrl'
          TabOrder = 1
        end
        object cbShift: TCheckBox
          Left = 78
          Height = 26
          Top = 26
          Width = 57
          Caption = 'Shift'
          TabOrder = 2
        end
        object cbAlt: TCheckBox
          Left = 134
          Height = 26
          Top = 26
          Width = 45
          Caption = 'Alt'
          TabOrder = 3
        end
      end
    end
  end
  object TreeView: TTreeView
    Left = 6
    Height = 483
    Top = 0
    Width = 315
    Align = alClient
    DefaultItemHeight = 16
    DragCursor = crDefault
    DragMode = dmAutomatic
    HideSelection = False
    Indent = 19
    PopupMenu = PopupMenu
    ReadOnly = True
    ScrollBars = ssAutoBoth
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
    left = 48
    top = 400
    object mbTest: TMenuItem
      Caption = '&Test'
    end
  end
  object PopupMenu: TPopupMenu
    OnPopup = PopupMenuPopup
    left = 80
    top = 400
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
    left = 16
    top = 400
  end
end
