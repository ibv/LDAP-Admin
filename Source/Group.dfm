object GroupDlg: TGroupDlg
  Left = 396
  Height = 478
  Top = 179
  Width = 411
  BorderStyle = bsDialog
  Caption = 'Create Group'
  ClientHeight = 478
  ClientWidth = 411
  Color = clBtnFace
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  OnClose = FormClose
  OnDestroy = FormDestroy
  Position = poMainFormCenter
  LCLVersion = '2.2.2.0'
  object Label1: TLabel
    Left = 16
    Height = 14
    Top = 16
    Width = 73
    Caption = '&Group name:'
    ParentColor = False
  end
  object Label2: TLabel
    Left = 16
    Height = 14
    Top = 64
    Width = 67
    Caption = '&Description:'
    ParentColor = False
  end
  object edName: TEdit
    Left = 16
    Height = 30
    Top = 32
    Width = 377
    OnChange = edNameChange
    TabOrder = 0
  end
  object edDescription: TEdit
    Left = 16
    Height = 30
    Top = 80
    Width = 377
    OnChange = edDescriptionChange
    TabOrder = 1
  end
  object OkBtn: TButton
    Left = 248
    Height = 25
    Top = 446
    Width = 75
    Caption = '&OK'
    Enabled = False
    ModalResult = 1
    TabOrder = 2
  end
  object CancelBtn: TButton
    Left = 328
    Height = 25
    Top = 446
    Width = 75
    Cancel = True
    Caption = '&Cancel'
    ModalResult = 2
    TabOrder = 3
  end
  object PageControl1: TPageControl
    Left = 8
    Height = 321
    Top = 112
    Width = 393
    ActivePage = TabSheet1
    TabIndex = 0
    TabOrder = 4
    OnChange = PageControl1Change
    object TabSheet1: TTabSheet
      Caption = '&Members'
      ClientHeight = 293
      ClientWidth = 383
      object UserList: TListView
        Left = 8
        Height = 249
        Top = 8
        Width = 369
        Columns = <        
          item
            Caption = 'Name'
            Width = 120
          end        
          item
            Caption = 'Path'
            Width = 247
          end>
        HideSelection = False
        MultiSelect = True
        RowSelect = True
        ScrollBars = ssAutoBoth
        TabOrder = 0
        ViewStyle = vsReport
        OnColumnClick = ListViewColumnClick
        OnCompare = ListViewCompare
        OnDeletion = UserListDeletion
      end
      object AddUserBtn: TButton
        Left = 8
        Height = 25
        Top = 259
        Width = 75
        Caption = '&Add'
        OnClick = AddUserBtnClick
        TabOrder = 1
      end
      object RemoveUserBtn: TButton
        Left = 88
        Height = 25
        Top = 259
        Width = 75
        Caption = '&Remove'
        Enabled = False
        OnClick = RemoveUserBtnClick
        TabOrder = 2
      end
    end
    object TabSheet2: TTabSheet
      Caption = '&Samba'
      ClientHeight = 293
      ClientWidth = 383
      ImageIndex = 2
      object Label3: TLabel
        Left = 24
        Height = 14
        Top = 112
        Width = 88
        Caption = 'Samba domain:'
        ParentColor = False
      end
      object Label4: TLabel
        Left = 272
        Height = 14
        Top = 112
        Width = 40
        Caption = 'NT-Rid:'
        ParentColor = False
      end
      object Bevel1: TBevel
        Left = 24
        Height = 9
        Top = 40
        Width = 337
        Shape = bsBottomLine
      end
      object Label5: TLabel
        Left = 24
        Height = 14
        Top = 64
        Width = 80
        Caption = 'Display name:'
        ParentColor = False
      end
      object cbSambaDomain: TComboBox
        Left = 24
        Height = 29
        Top = 128
        Width = 233
        ItemHeight = 0
        OnChange = cbSambaDomainChange
        Style = csDropDownList
        TabOrder = 2
      end
      object RadioGroup1: TRadioGroup
        Left = 24
        Height = 120
        Top = 160
        Width = 337
        AutoFill = True
        Caption = 'Group type:'
        ChildSizing.LeftRightSpacing = 6
        ChildSizing.EnlargeHorizontal = crsHomogenousChildResize
        ChildSizing.EnlargeVertical = crsHomogenousChildResize
        ChildSizing.ShrinkHorizontal = crsScaleChilds
        ChildSizing.ShrinkVertical = crsScaleChilds
        ChildSizing.Layout = cclLeftToRightThenTopToBottom
        ChildSizing.ControlsPerLine = 1
        ClientHeight = 105
        ClientWidth = 335
        ItemIndex = 0
        Items.Strings = (
          'Domain group'
          'Local group'
          'Built-in group:'
        )
        OnClick = RadioGroup1Click
        TabOrder = 4
      end
      object cbBuiltin: TComboBox
        Left = 160
        Height = 27
        Top = 240
        Width = 185
        Color = clBtnFace
        Enabled = False
        ItemHeight = 0
        Items.Strings = (
          'Domain Admins'
          'Domain Users'
          'Domain Guests'
        )
        OnChange = cbBuiltinChange
        Style = csDropDownList
        TabOrder = 5
      end
      object edRid: TEdit
        Left = 272
        Height = 30
        Top = 128
        Width = 89
        OnChange = edRidChange
        TabOrder = 3
      end
      object cbSambaGroup: TCheckBox
        Left = 24
        Height = 23
        Top = 24
        Width = 162
        Caption = 'Samba domain mapping'
        OnClick = cbSambaGroupClick
        TabOrder = 0
      end
      object edDisplayName: TEdit
        Left = 24
        Height = 30
        Top = 80
        Width = 337
        OnChange = edDisplayNameChange
        TabOrder = 1
      end
    end
  end
end
