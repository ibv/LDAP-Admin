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
  LCLVersion = '2.2.2.0'
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
    ActivePage = GeneralSheet
    Align = alTop
    TabIndex = 0
    TabOrder = 2
    OnChange = PageControlChange
    object GeneralSheet: TTabSheet
      Caption = '&General'
      ClientHeight = 310
      ClientWidth = 401
      ImageIndex = 2
      object Label5: TLabel
        Left = 16
        Height = 15
        Top = 112
        Width = 58
        Caption = 'NT name:'
        ParentColor = False
      end
      object Label3: TLabel
        Left = 16
        Height = 15
        Top = 160
        Width = 54
        Caption = 'Location:'
        ParentColor = False
      end
      object Label1: TLabel
        Left = 16
        Height = 15
        Top = 16
        Width = 102
        Caption = 'Computer &name:'
        ParentColor = False
      end
      object Label2: TLabel
        Left = 16
        Height = 15
        Top = 64
        Width = 72
        Caption = 'D&escription:'
        ParentColor = False
      end
      object samAccountName: TEdit
        Left = 16
        Height = 26
        Top = 128
        Width = 374
        MaxLength = 15
        OnChange = samAccountNameChange
        TabOrder = 2
      end
      object location: TEdit
        Left = 16
        Height = 26
        Top = 176
        Width = 374
        OnChange = EditChange
        TabOrder = 3
      end
      object cbxServerTrustAccount: TCheckBox
        Left = 16
        Height = 21
        Top = 224
        Width = 381
        Caption = 'Assign this computer account as backup domain controller'
        TabOrder = 4
      end
      object cbxNTAccount: TCheckBox
        Left = 16
        Height = 21
        Top = 256
        Width = 416
        Caption = 'Assign this computer account as a pre–Windows 2000 computer'
        TabOrder = 5
      end
      object cn: TEdit
        Left = 16
        Height = 26
        Top = 32
        Width = 374
        MaxLength = 63
        OnChange = cnChange
        TabOrder = 0
      end
      object description: TEdit
        Left = 16
        Height = 26
        Top = 80
        Width = 374
        OnChange = EditChange
        TabOrder = 1
      end
      object Panel1: TPanel
        Left = 0
        Height = 103
        Top = 207
        Width = 401
        Align = alBottom
        BevelOuter = bvNone
        ClientHeight = 103
        ClientWidth = 401
        TabOrder = 6
        Visible = False
        object Label4: TLabel
          Left = 16
          Height = 15
          Top = 4
          Width = 56
          Caption = 'Function:'
          ParentColor = False
        end
        object edFunction: TEdit
          Left = 16
          Height = 26
          Top = 23
          Width = 374
          Enabled = False
          TabOrder = 0
        end
        object cbxTrustForDelegation: TCheckBox
          Left = 16
          Height = 21
          Top = 64
          Width = 234
          Caption = 'Trust this computer for delegation '
          OnClick = cbxTrustForDelegationClick
          TabOrder = 1
        end
      end
    end
    object MembershipSheet: TTabSheet
      Caption = 'Membership'
      ClientHeight = 310
      ClientWidth = 401
      ImageIndex = 2
      object Label34: TLabel
        Left = 8
        Height = 15
        Top = 51
        Width = 68
        Caption = 'Member of:'
        ParentColor = False
      end
      object Label33: TLabel
        Left = 8
        Height = 15
        Top = 8
        Width = 90
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
            Width = 243
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
        Top = 24
        Width = 81
        Caption = '&Set...'
        OnClick = PrimaryGroupBtnClick
        TabOrder = 1
      end
      object edPrimaryGroup: TEdit
        Left = 8
        Height = 26
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
    Left = 24
    Top = 336
  end
end
