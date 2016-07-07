object CustomMenuDlg: TCustomMenuDlg
  Left = 428
  Top = 183
  Width = 695
  Height = 548
  ActiveControl = TreeView
  Caption = 'Customize menu'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = MainMenu
  Position = poMainFormCenter
  OnCloseQuery = FormCloseQuery
  OnResize = FormResize
  PixelsPerInch = 96
  object Panel2: TPanel
    Left = 313
    Top = 0
    Width = 11
    Height = 456
    Align = alRight
    BevelOuter = bvNone
    TabOrder = 0
  end
  object Panel3: TPanel
    Left = 0
    Top = 456
    Width = 687
    Height = 46
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    object btnCancel: TButton
      Left = 597
      Top = 10
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Caption = '&Cancel'
      ModalResult = 2
      TabOrder = 1
    end
    object btnOK: TButton
      Left = 517
      Top = 10
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Caption = '&OK'
      ModalResult = 1
      TabOrder = 0
    end
  end
  object Panel4: TPanel
    Left = 681
    Top = 0
    Width = 6
    Height = 456
    Align = alRight
    BevelOuter = bvNone
    TabOrder = 2
  end
  object Panel6: TPanel
    Left = 0
    Top = 0
    Width = 6
    Height = 456
    Align = alLeft
    BevelOuter = bvNone
    TabOrder = 3
  end
  object Panel1: TPanel
    Left = 324
    Top = 0
    Width = 357
    Height = 456
    Align = alRight
    BevelOuter = bvNone
    TabOrder = 4
    object Panel5: TPanel
      Left = 0
      Top = 0
      Width = 357
      Height = 456
      Align = alClient
      BevelInner = bvLowered
      BevelOuter = bvNone
      TabOrder = 0
      object Panel8: TPanel
        Left = 0
        Top = 0
        Width = 355
        Height = 72
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 0
        object Label1: TLabel
          Left = 14
          Top = 14
          Width = 39
          Height = 13
          Caption = 'Ca&ption:'
        end
        object edCaption: TEdit
          Left = 14
          Top = 30
          Width = 329
          Height = 21
          TabOrder = 0
          OnChange = edCaptionChange
        end
      end
      object GroupBox1: TGroupBox
        Left = 14
        Top = 70
        Width = 329
        Height = 169
        Caption = ' &Action '
        TabOrder = 1
        object rbDisabled: TRadioButton
          Left = 22
          Top = 18
          Width = 105
          Height = 17
          Caption = '&Disabled'
          TabOrder = 0
          OnClick = rbClick
        end
        object rbDefaultAction: TRadioButton
          Left = 22
          Top = 58
          Width = 105
          Height = 17
          Caption = 'Defaul&t action'
          TabOrder = 1
          OnClick = rbClick
        end
        object rbTemplate: TRadioButton
          Left = 22
          Top = 98
          Width = 105
          Height = 17
          Caption = '&Template'
          TabOrder = 2
          OnClick = rbClick
        end
        object cbTemplate: TComboBox
          Left = 126
          Top = 96
          Width = 185
          Height = 22
          Style = csOwnerDrawFixed
          Enabled = False
          ItemHeight = 16
          TabOrder = 3
          OnChange = cbTemplateChange
          OnDrawItem = cbTemplateDrawItem
        end
        object cbDefaultAction: TComboBox
          Left = 126
          Top = 56
          Width = 185
          Height = 22
          Style = csOwnerDrawFixed
          ItemHeight = 16
          TabOrder = 4
          OnChange = cbDefaultActionChange
          OnDrawItem = cbDefaultActionDrawItem
          Items.Strings = (
            'Entry'
            'User'
            'Computer'
            'Group'
            'Mailing list'
            'Transport table'
            'Organizational unit'
            'Group of unique names')
        end
        object ComboText: TStaticText
          Left = 30
          Top = 122
          Width = 4
          Height = 4
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBtnShadow
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsItalic]
          ParentFont = False
          TabOrder = 5
          OnMouseDown = ComboTextMouseDown
        end
      end
      object GroupBox2: TGroupBox
        Left = 14
        Top = 254
        Width = 329
        Height = 89
        Caption = 'Hotkey'
        TabOrder = 2
        object cbShortcutKey: TComboBox
          Left = 198
          Top = 26
          Width = 97
          Height = 21
          ItemHeight = 13
          TabOrder = 0
        end
        object cbCtrl: TCheckBox
          Left = 22
          Top = 26
          Width = 57
          Height = 17
          Caption = 'Ctrl'
          TabOrder = 1
        end
        object cbShift: TCheckBox
          Left = 78
          Top = 26
          Width = 57
          Height = 17
          Caption = 'Shift'
          TabOrder = 2
        end
        object cbAlt: TCheckBox
          Left = 134
          Top = 26
          Width = 57
          Height = 17
          Caption = 'Alt'
          TabOrder = 3
        end
      end
    end
  end
  object TreeView: TTreeView
    Left = 6
    Top = 0
    Width = 307
    Height = 456
    Align = alClient
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
  end
  object MainMenu: TMainMenu
    Left = 48
    Top = 400
    object mbTest: TMenuItem
      Caption = '&Test'
    end
  end
  object PopupMenu: TPopupMenu
    OnPopup = PopupMenuPopup
    Left = 80
    Top = 400
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
    Left = 16
    Top = 400
  end
end
