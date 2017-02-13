object AdComputerDlg: TAdComputerDlg
  Left = 396
  Height = 376
  Top = 179
  Width = 411
  BorderStyle = bsDialog
  Caption = 'Create computer'
  ClientHeight = 376
  ClientWidth = 411
  Color = clBtnFace
  OnClose = FormClose
  OnDestroy = FormDestroy
  ParentFont = True
  Position = poMainFormCenter
  LCLVersion = '1.6.2.0'
  object OkBtn: TButton
    Left = 167
    Height = 25
    Top = 343
    Width = 75
    Caption = '&OK'
    Default = True
    ModalResult = 1
    TabOrder = 0
  end
  object CancelBtn: TButton
    Left = 247
    Height = 25
    Top = 343
    Width = 75
    Cancel = True
    Caption = '&Cancel'
    ModalResult = 2
    TabOrder = 1
  end
  object PageControl: TPageControl
    Left = 0
    Height = 337
    Top = 0
    Width = 411
    ActivePage = MembershipSheet
    Align = alTop
    TabIndex = 1
    TabOrder = 2
    OnChange = PageControlChange
    object GeneralSheet: TTabSheet
      Caption = '&General'
      ClientHeight = 300
      ClientWidth = 403
      ImageIndex = 2
      object Label5: TLabel
        Left = 16
        Height = 15
        Top = 112
        Width = 62
        Caption = 'NT name:'
        ParentColor = False
      end
      object Label3: TLabel
        Left = 16
        Height = 15
        Top = 160
        Width = 58
        Caption = 'Location:'
        ParentColor = False
      end
      object Label1: TLabel
        Left = 16
        Height = 15
        Top = 16
        Width = 109
        Caption = 'Computer &name:'
        ParentColor = False
      end
      object Label2: TLabel
        Left = 16
        Height = 15
        Top = 64
        Width = 76
        Caption = 'D&escription:'
        ParentColor = False
      end
      object samAccountName: TEdit
        Left = 16
        Height = 21
        Top = 128
        Width = 374
        MaxLength = 15
        OnChange = samAccountNameChange
        TabOrder = 2
      end
      object location: TEdit
        Left = 16
        Height = 21
        Top = 176
        Width = 374
        OnChange = EditChange
        TabOrder = 3
      end
      object cbxServerTrustAccount: TCheckBox
        Left = 16
        Height = 26
        Top = 224
        Width = 403
        Caption = 'Assign this computer account as backup domain controller'
        TabOrder = 4
      end
      object cbxNTAccount: TCheckBox
        Left = 16
        Height = 26
        Top = 256
        Width = 437
        Caption = 'Assign this computer account as a pre–Windows 2000 computer'
        TabOrder = 5
      end
      object cn: TEdit
        Left = 16
        Height = 21
        Top = 32
        Width = 374
        MaxLength = 63
        OnChange = cnChange
        TabOrder = 0
      end
      object description: TEdit
        Left = 16
        Height = 21
        Top = 80
        Width = 374
        OnChange = EditChange
        TabOrder = 1
      end
      object Panel1: TPanel
        Left = 0
        Height = 103
        Top = 197
        Width = 403
        Align = alBottom
        BevelOuter = bvNone
        ClientHeight = 103
        ClientWidth = 403
        TabOrder = 6
        Visible = False
        object Label4: TLabel
          Left = 16
          Height = 15
          Top = 4
          Width = 57
          Caption = 'Function:'
          ParentColor = False
        end
        object edFunction: TEdit
          Left = 16
          Height = 21
          Top = 23
          Width = 374
          Enabled = False
          TabOrder = 0
        end
        object cbxTrustForDelegation: TCheckBox
          Left = 16
          Height = 26
          Top = 64
          Width = 247
          Caption = 'Trust this computer for delegation '
          OnClick = cbxTrustForDelegationClick
          TabOrder = 1
        end
      end
    end
    object MembershipSheet: TTabSheet
      Caption = 'Membership'
      ClientHeight = 300
      ClientWidth = 403
      ImageIndex = 2
      object Label34: TLabel
        Left = 8
        Height = 15
        Top = 51
        Width = 73
        Caption = 'Member of:'
        ParentColor = False
      end
      object Label33: TLabel
        Left = 8
        Height = 15
        Top = 8
        Width = 94
        Caption = '&Primary group:'
        ParentColor = False
      end
      object MembershipList: TListView
        Left = 8
        Height = 196
        Top = 70
        Width = 385
        Columns = <        
          item
            Caption = 'Name'
            Width = 140
          end        
          item
            Caption = 'Path'
            Width = 224
          end>
        HideSelection = False
        ScrollBars = ssAutoBoth
        TabOrder = 2
        ViewStyle = vsReport
      end
      object RemoveGroupBtn: TButton
        Left = 89
        Height = 25
        Top = 272
        Width = 75
        Caption = '&Remove'
        Enabled = False
        OnClick = RemoveGroupBtnClick
        TabOrder = 4
      end
      object AddGroupBtn: TButton
        Left = 8
        Height = 25
        Top = 272
        Width = 75
        Caption = '&Add'
        OnClick = AddGroupBtnClick
        TabOrder = 3
      end
      object PrimaryGroupBtn: TButton
        Left = 312
        Height = 25
        Top = 22
        Width = 81
        Caption = '&Set...'
        OnClick = PrimaryGroupBtnClick
        TabOrder = 1
      end
      object edPrimaryGroup: TEdit
        Left = 8
        Height = 21
        Top = 24
        Width = 298
        Enabled = False
        TabOrder = 0
      end
    end
  end
  object ApplyBtn: TButton
    Left = 328
    Height = 25
    Top = 343
    Width = 75
    Caption = 'Appl&y'
    Enabled = False
    OnClick = ApplyBtnClick
    TabOrder = 3
  end
  object ApplicationEvents1: TApplicationProperties
    OnIdle = ApplicationEvents1Idle
    left = 24
    top = 336
  end
end
