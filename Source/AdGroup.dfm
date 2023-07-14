object AdGroupDlg: TAdGroupDlg
  Left = 396
  Height = 472
  Top = 179
  Width = 411
  BorderStyle = bsDialog
  Caption = 'Create Group'
  ClientHeight = 472
  ClientWidth = 411
  Color = clBtnFace
  OnClose = FormClose
  OnDestroy = FormDestroy
  ParentFont = True
  Position = poMainFormCenter
  LCLVersion = '2.2.6.0'
  object Label1: TLabel
    Left = 16
    Height = 15
    Top = 7
    Width = 79
    Caption = 'Group &name:'
    ParentColor = False
  end
  object Label2: TLabel
    Left = 16
    Height = 15
    Top = 52
    Width = 72
    Caption = 'D&escription:'
    ParentColor = False
  end
  object cn: TEdit
    Left = 16
    Height = 31
    Top = 23
    Width = 377
    OnChange = cnChange
    TabOrder = 0
  end
  object description: TEdit
    Left = 16
    Height = 31
    Top = 67
    Width = 377
    OnChange = EditChange
    TabOrder = 1
  end
  object OkBtn: TButton
    Left = 167
    Height = 25
    Top = 440
    Width = 75
    Caption = '&OK'
    Default = True
    ModalResult = 1
    TabOrder = 3
  end
  object CancelBtn: TButton
    Left = 247
    Height = 25
    Top = 440
    Width = 75
    Cancel = True
    Caption = '&Cancel'
    ModalResult = 2
    TabOrder = 4
  end
  object PageControl: TPageControl
    Left = 10
    Height = 334
    Top = 100
    Width = 393
    ActivePage = MemberSheet
    TabIndex = 0
    TabOrder = 2
    OnChange = PageControlChange
    object MemberSheet: TTabSheet
      Caption = '&Members'
      ClientHeight = 305
      ClientWidth = 383
      object MemberList: TListView
        Left = 8
        Height = 249
        Top = 16
        Width = 369
        Columns = <        
          item
            Caption = 'Name'
            Width = 120
          end        
          item
            Caption = 'Path'
            Width = 234
          end>
        HideSelection = False
        MultiSelect = True
        RowSelect = True
        ScrollBars = ssAutoBoth
        TabOrder = 0
        ViewStyle = vsReport
        OnColumnClick = ListViewColumnClick
        OnCompare = ListViewCompare
      end
      object AddUserBtn: TButton
        Left = 8
        Height = 25
        Top = 271
        Width = 75
        Caption = '&Add'
        OnClick = AddUserBtnClick
        TabOrder = 1
      end
      object RemoveUserBtn: TButton
        Left = 89
        Height = 25
        Top = 271
        Width = 75
        Caption = '&Remove'
        Enabled = False
        OnClick = RemoveUserBtnClick
        TabOrder = 2
      end
    end
    object OptionsSheet: TTabSheet
      Caption = '&Options'
      ClientHeight = 305
      ClientWidth = 383
      ImageIndex = 2
      object Label5: TLabel
        Left = 8
        Height = 15
        Top = 8
        Width = 58
        Caption = 'NT name:'
        ParentColor = False
      end
      object Label3: TLabel
        Left = 8
        Height = 15
        Top = 53
        Width = 39
        Caption = 'E-Mail:'
        ParentColor = False
      end
      object Label4: TLabel
        Left = 9
        Height = 15
        Top = 96
        Width = 27
        Caption = 'Info:'
        ParentColor = False
      end
      object samAccountName: TEdit
        Left = 8
        Height = 31
        Top = 24
        Width = 366
        OnChange = EditChange
        TabOrder = 0
      end
      object mail: TEdit
        Left = 8
        Height = 31
        Top = 67
        Width = 366
        OnChange = EditChange
        TabOrder = 1
      end
      object info: TMemo
        Left = 8
        Height = 65
        Top = 112
        Width = 366
        OnChange = EditChange
        TabOrder = 2
      end
      object gbScope: TGroupBox
        Left = 9
        Height = 105
        Top = 190
        Width = 176
        Caption = 'Group scope:'
        ClientHeight = 89
        ClientWidth = 174
        TabOrder = 3
        object rbLocal: TRadioButton
          Left = 16
          Height = 23
          Top = 12
          Width = 103
          Caption = 'Domain &local'
          Checked = True
          TabOrder = 0
          TabStop = True
        end
        object rbGlobal: TRadioButton
          Left = 16
          Height = 23
          Top = 35
          Width = 63
          Caption = '&Global'
          TabOrder = 1
        end
        object rbUniversal: TRadioButton
          Left = 16
          Height = 23
          Top = 58
          Width = 81
          Caption = '&Universal'
          TabOrder = 2
        end
      end
      object gbType: TGroupBox
        Left = 196
        Height = 105
        Top = 190
        Width = 178
        Caption = 'Group type:'
        ClientHeight = 89
        ClientWidth = 176
        TabOrder = 4
        object rbSecurity: TRadioButton
          Left = 16
          Height = 23
          Top = 12
          Width = 76
          Caption = '&Security'
          Checked = True
          OnClick = rbSecurityClick
          TabOrder = 0
          TabStop = True
        end
        object rbDistribution: TRadioButton
          Left = 16
          Height = 23
          Top = 36
          Width = 96
          Caption = '&Distribution'
          OnClick = rbSecurityClick
          TabOrder = 1
        end
      end
    end
    object MembershipSheet: TTabSheet
      Caption = 'Membership'
      ClientHeight = 305
      ClientWidth = 383
      ImageIndex = 2
      object Label34: TLabel
        Left = 8
        Height = 15
        Top = 11
        Width = 68
        Caption = 'Member of:'
        ParentColor = False
      end
      object MembershipList: TListView
        Left = 8
        Height = 236
        Top = 30
        Width = 369
        Columns = <        
          item
            Caption = 'Name'
            Width = 140
          end        
          item
            Caption = 'Path'
            Width = 220
          end>
        HideSelection = False
        ScrollBars = ssAutoBoth
        TabOrder = 0
        ViewStyle = vsReport
        OnColumnClick = ListViewColumnClick
        OnCompare = ListViewCompare
      end
      object RemoveGroupBtn: TButton
        Left = 89
        Height = 25
        Top = 272
        Width = 75
        Caption = '&Remove'
        Enabled = False
        OnClick = RemoveGroupBtnClick
        TabOrder = 1
      end
      object AddGroupBtn: TButton
        Left = 8
        Height = 25
        Top = 272
        Width = 75
        Caption = '&Add'
        OnClick = AddGroupBtnClick
        TabOrder = 2
      end
    end
  end
  object ApplyBtn: TButton
    Left = 328
    Height = 25
    Top = 440
    Width = 75
    Caption = 'Appl&y'
    Enabled = False
    OnClick = ApplyBtnClick
    TabOrder = 5
  end
  object ApplicationEvents1: TApplicationProperties
    OnIdle = ApplicationEvents1Idle
    Left = 16
    Top = 440
  end
end
