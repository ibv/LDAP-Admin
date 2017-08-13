object MailGroupDlg: TMailGroupDlg
  Left = 399
  Height = 472
  Top = 169
  Width = 410
  BorderStyle = bsDialog
  Caption = 'Create mailing list'
  ClientHeight = 472
  ClientWidth = 410
  Color = clBtnFace
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  OnClose = FormClose
  OnDestroy = FormDestroy
  Position = poMainFormCenter
  LCLVersion = '1.6.0.4'
  object Label1: TLabel
    Left = 16
    Height = 13
    Top = 16
    Width = 75
    Caption = '&Group name:'
    FocusControl = edName
    ParentColor = False
  end
  object Label2: TLabel
    Left = 16
    Height = 13
    Top = 64
    Width = 68
    Caption = '&Description:'
    FocusControl = edDescription
    ParentColor = False
  end
  object edName: TEdit
    Left = 16
    Height = 19
    Top = 32
    Width = 377
    OnChange = edNameChange
    TabOrder = 0
  end
  object edDescription: TEdit
    Left = 16
    Height = 19
    Top = 80
    Width = 377
    OnChange = edDescriptionChange
    TabOrder = 1
  end
  object OkBtn: TButton
    Left = 248
    Height = 25
    Top = 440
    Width = 75
    Caption = '&OK'
    Enabled = False
    ModalResult = 1
    TabOrder = 3
  end
  object CancelBtn: TButton
    Left = 328
    Height = 25
    Top = 440
    Width = 75
    Cancel = True
    Caption = '&Cancel'
    ModalResult = 2
    TabOrder = 4
  end
  object PageControl1: TPageControl
    Left = 8
    Height = 321
    Top = 112
    Width = 393
    ActivePage = TabSheet1
    TabIndex = 0
    TabOrder = 2
    object TabSheet1: TTabSheet
      Caption = '&Members'
      ClientHeight = 286
      ClientWidth = 385
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
            Width = 245
          end>
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
        Top = 258
        Width = 75
        Caption = '&Add'
        OnClick = AddUserBtnClick
        TabOrder = 1
      end
      object RemoveUserBtn: TButton
        Left = 88
        Height = 25
        Top = 258
        Width = 75
        Caption = '&Remove'
        Enabled = False
        OnClick = RemoveUserBtnClick
        TabOrder = 2
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'E-Mail Addresses'
      ClientHeight = 286
      ClientWidth = 385
      ImageIndex = 1
      object Label3: TLabel
        Left = 8
        Height = 13
        Top = 240
        Width = 121
        Caption = 'Mail &routing address:'
        ParentColor = False
      end
      object mail: TListBox
        Left = 8
        Height = 195
        Top = 8
        Width = 369
        ItemHeight = 0
        OnClick = mailClick
        OnDblClick = EditMailBtnClick
        ScrollWidth = 365
        TabOrder = 0
        TopIndex = -1
      end
      object AddMailBtn: TButton
        Left = 8
        Height = 25
        Top = 208
        Width = 65
        Caption = '&Add'
        OnClick = AddMailBtnClick
        TabOrder = 1
      end
      object EditMailBtn: TButton
        Left = 80
        Height = 25
        Top = 208
        Width = 65
        Caption = '&Edit'
        Enabled = False
        OnClick = EditMailBtnClick
        TabOrder = 2
      end
      object DelMailBtn: TButton
        Left = 152
        Height = 25
        Top = 208
        Width = 65
        Caption = '&Remove'
        Enabled = False
        OnClick = DelMailBtnClick
        TabOrder = 3
      end
      object edMailRoutingAddress: TEdit
        Left = 7
        Height = 19
        Top = 256
        Width = 369
        OnChange = edMailRoutingAddressChange
        TabOrder = 4
      end
    end
  end
end
