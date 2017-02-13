object AdGroupDlg: TAdGroupDlg
  Left = 396
  Top = 179
  BorderStyle = bsDialog
  Caption = 'Create Group'
  ClientHeight = 472
  ClientWidth = 411
  Color = clBtnFace
  ParentFont = True
  OldCreateOrder = True
  Position = poMainFormCenter
  OnClose = FormClose
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 16
    Top = 11
    Width = 62
    Height = 13
    Caption = 'Group &name:'
  end
  object Label2: TLabel
    Left = 16
    Top = 54
    Width = 57
    Height = 13
    Caption = 'D&escription:'
  end
  object cn: TEdit
    Left = 16
    Top = 27
    Width = 377
    Height = 21
    TabOrder = 0
    OnChange = cnChange
  end
  object description: TEdit
    Left = 16
    Top = 70
    Width = 377
    Height = 21
    TabOrder = 1
    OnChange = EditChange
  end
  object OkBtn: TButton
    Left = 167
    Top = 440
    Width = 75
    Height = 25
    Caption = '&OK'
    Default = True
    ModalResult = 1
    TabOrder = 3
  end
  object CancelBtn: TButton
    Left = 247
    Top = 440
    Width = 75
    Height = 25
    Cancel = True
    Caption = '&Cancel'
    ModalResult = 2
    TabOrder = 4
  end
  object PageControl: TPageControl
    Left = 10
    Top = 100
    Width = 393
    Height = 334
    ActivePage = MemberSheet
    TabOrder = 2
    OnChange = PageControlChange
    object MemberSheet: TTabSheet
      Caption = '&Members'
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object MemberList: TListView
        Left = 8
        Top = 16
        Width = 369
        Height = 249
        Columns = <
          item
            Caption = 'Name'
            Width = 120
          end
          item
            Caption = 'Path'
            Width = 220
          end>
        HideSelection = False
        MultiSelect = True
        RowSelect = True
        TabOrder = 0
        ViewStyle = vsReport
        OnColumnClick = ListViewColumnClick
        OnCompare = ListViewCompare
      end
      object AddUserBtn: TButton
        Left = 8
        Top = 271
        Width = 75
        Height = 25
        Caption = '&Add'
        TabOrder = 1
        OnClick = AddUserBtnClick
      end
      object RemoveUserBtn: TButton
        Left = 89
        Top = 271
        Width = 75
        Height = 25
        Caption = '&Remove'
        Enabled = False
        TabOrder = 2
        OnClick = RemoveUserBtnClick
      end
    end
    object OptionsSheet: TTabSheet
      Caption = '&Options'
      ImageIndex = 2
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object Label5: TLabel
        Left = 8
        Top = 10
        Width = 46
        Height = 13
        Caption = 'NT name:'
      end
      object Label3: TLabel
        Left = 8
        Top = 54
        Width = 32
        Height = 13
        Caption = 'E-Mail:'
      end
      object Label4: TLabel
        Left = 9
        Top = 96
        Width = 24
        Height = 13
        Caption = 'Info:'
      end
      object samAccountName: TEdit
        Left = 8
        Top = 26
        Width = 366
        Height = 21
        TabOrder = 0
        OnChange = EditChange
      end
      object mail: TEdit
        Left = 8
        Top = 69
        Width = 366
        Height = 21
        TabOrder = 1
        OnChange = EditChange
      end
      object info: TMemo
        Left = 8
        Top = 112
        Width = 366
        Height = 65
        TabOrder = 2
        OnChange = EditChange
      end
      object gbScope: TGroupBox
        Left = 9
        Top = 190
        Width = 176
        Height = 105
        Caption = 'Group scope:'
        TabOrder = 3
        object rbLocal: TRadioButton
          Left = 16
          Top = 24
          Width = 157
          Height = 17
          Caption = 'Domain &local'
          Checked = True
          TabOrder = 0
          TabStop = True
        end
        object rbGlobal: TRadioButton
          Left = 16
          Top = 47
          Width = 157
          Height = 17
          Caption = '&Global'
          TabOrder = 1
        end
        object rbUniversal: TRadioButton
          Left = 16
          Top = 70
          Width = 113
          Height = 17
          Caption = '&Universal'
          TabOrder = 2
        end
      end
      object gbType: TGroupBox
        Left = 196
        Top = 190
        Width = 178
        Height = 105
        Caption = 'Group type:'
        TabOrder = 4
        object rbSecurity: TRadioButton
          Left = 16
          Top = 24
          Width = 159
          Height = 17
          Caption = '&Security'
          Checked = True
          TabOrder = 0
          TabStop = True
          OnClick = rbSecurityClick
        end
        object rbDistribution: TRadioButton
          Left = 16
          Top = 48
          Width = 153
          Height = 17
          Caption = '&Distribution'
          TabOrder = 1
          OnClick = rbSecurityClick
        end
      end
    end
    object MembershipSheet: TTabSheet
      Caption = 'Membership'
      ImageIndex = 2
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object Label34: TLabel
        Left = 8
        Top = 11
        Width = 55
        Height = 13
        Caption = 'Member of:'
      end
      object MembershipList: TListView
        Left = 8
        Top = 30
        Width = 369
        Height = 236
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
        TabOrder = 0
        ViewStyle = vsReport
        OnColumnClick = ListViewColumnClick
        OnCompare = ListViewCompare
      end
      object RemoveGroupBtn: TButton
        Left = 89
        Top = 272
        Width = 75
        Height = 25
        Caption = '&Remove'
        Enabled = False
        TabOrder = 1
        OnClick = RemoveGroupBtnClick
      end
      object AddGroupBtn: TButton
        Left = 8
        Top = 272
        Width = 75
        Height = 25
        Caption = '&Add'
        TabOrder = 2
        OnClick = AddGroupBtnClick
      end
    end
  end
  object ApplyBtn: TButton
    Left = 328
    Top = 440
    Width = 75
    Height = 25
    Caption = 'Appl&y'
    Enabled = False
    TabOrder = 5
    OnClick = ApplyBtnClick
  end
  object ApplicationEvents1: TApplicationProperties
    OnIdle = ApplicationEvents1Idle
    Left = 16
    Top = 440
  end
end
