object UserDlg: TUserDlg
  Left = 423
  Height = 497
  Top = 181
  Width = 398
  BorderStyle = bsDialog
  Caption = 'Create User'
  ClientHeight = 497
  ClientWidth = 398
  Color = clBtnFace
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  OnClose = FormClose
  OnCloseQuery = FormCloseQuery
  OnDestroy = FormDestroy
  Position = poMainFormCenter
  LCLVersion = '2.2.2.0'
  object PageControl: TPageControl
    Left = 0
    Height = 442
    Top = 0
    Width = 398
    ActivePage = AccountSheet
    Align = alClient
    MultiLine = True
    TabIndex = 0
    TabOrder = 0
    OnChange = PageControlChange
    OnChanging = PageControlChanging
    OnResize = PageControlResize
    Options = [nboMultiLine]
    object AccountSheet: TTabSheet
      Caption = '&Account'
      ClientHeight = 414
      ClientWidth = 388
      object Label1: TLabel
        Left = 16
        Height = 14
        Top = 16
        Width = 63
        Caption = '&First name:'
        ParentColor = False
      end
      object Label2: TLabel
        Left = 224
        Height = 14
        Top = 16
        Width = 80
        Caption = '&Second name:'
        ParentColor = False
      end
      object Label3: TLabel
        Left = 16
        Height = 14
        Top = 64
        Width = 80
        Caption = '&Display name:'
        ParentColor = False
      end
      object Label4: TLabel
        Left = 16
        Height = 14
        Top = 112
        Width = 61
        Caption = '&Username:'
        ParentColor = False
      end
      object Label5: TLabel
        Left = 160
        Height = 14
        Top = 16
        Width = 40
        Caption = '&Initials:'
        ParentColor = False
      end
      object Label9: TLabel
        Left = 16
        Height = 14
        Top = 160
        Width = 90
        Caption = '&Home Directory:'
        ParentColor = False
      end
      object Label12: TLabel
        Left = 16
        Height = 14
        Top = 208
        Width = 39
        Caption = 'Gecos:'
        ParentColor = False
      end
      object Label14: TLabel
        Left = 208
        Height = 14
        Top = 112
        Width = 63
        Caption = '&Login shell:'
        ParentColor = False
      end
      object GroupBox1: TGroupBox
        Left = 16
        Height = 152
        Top = 256
        Width = 353
        Caption = 'Account properties'
        ClientHeight = 137
        ClientWidth = 351
        TabOrder = 8
        object Bevel1: TBevel
          Left = 176
          Height = 57
          Top = 28
          Width = 9
          Shape = bsLeftLine
        end
        object cbShadow: TCheckBox
          Left = 24
          Height = 23
          Top = 24
          Width = 117
          Caption = 'Shadow Account'
          OnClick = cbShadowClick
          TabOrder = 0
        end
        object cbMail: TCheckBox
          Left = 24
          Height = 23
          Top = 72
          Width = 95
          Caption = 'Mail Account'
          OnClick = cbMailClick
          TabOrder = 2
        end
        object cbSamba: TCheckBox
          Left = 24
          Height = 23
          Top = 48
          Width = 112
          Caption = 'Samba Account'
          OnClick = cbSambaClick
          TabOrder = 1
        end
        object CheckListBox: TCheckListBox
          Left = 200
          Height = 72
          Top = 21
          Width = 137
          BorderStyle = bsNone
          Color = clBtnFace
          Enabled = False
          IntegralHeight = True
          ItemHeight = 24
          OnClick = CheckListBoxClick
          OnClickCheck = CheckListBoxClickCheck
          OnDrawItem = CheckListBoxDrawItem
          Sorted = True
          Style = lbOwnerDrawFixed
          TabOrder = 3
          TopIndex = -1
        end
      end
      object givenName: TEdit
        Left = 16
        Height = 30
        Top = 32
        Width = 137
        OnChange = EditChange
        TabOrder = 0
      end
      object sn: TEdit
        Left = 224
        Height = 30
        Top = 32
        Width = 145
        OnChange = EditChange
        OnExit = snExit
        TabOrder = 2
      end
      object displayName: TEdit
        Left = 16
        Height = 30
        Top = 80
        Width = 353
        OnChange = EditChange
        TabOrder = 3
      end
      object uid: TEdit
        Left = 16
        Height = 30
        Top = 128
        Width = 185
        OnChange = EditChange
        OnExit = uidExit
        TabOrder = 4
      end
      object initials: TEdit
        Left = 160
        Height = 30
        Top = 32
        Width = 57
        OnChange = EditChange
        TabOrder = 1
      end
      object homeDirectory: TEdit
        Left = 16
        Height = 30
        Top = 176
        Width = 353
        OnChange = EditChange
        TabOrder = 6
      end
      object gecos: TEdit
        Left = 16
        Height = 30
        Top = 224
        Width = 353
        OnChange = EditChange
        TabOrder = 7
      end
      object loginShell: TEdit
        Left = 208
        Height = 30
        Top = 128
        Width = 161
        OnChange = EditChange
        TabOrder = 5
      end
    end
    object ShadowSheet: TTabSheet
      Caption = 'Shadow'
      ClientHeight = 414
      ClientWidth = 388
      ImageIndex = 6
      object RadioGroup1: TRadioGroup
        Left = 16
        Height = 89
        Top = 264
        Width = 353
        AutoFill = True
        Caption = '&Account expires'
        ChildSizing.LeftRightSpacing = 6
        ChildSizing.EnlargeHorizontal = crsHomogenousChildResize
        ChildSizing.EnlargeVertical = crsHomogenousChildResize
        ChildSizing.ShrinkHorizontal = crsScaleChilds
        ChildSizing.ShrinkVertical = crsScaleChilds
        ChildSizing.Layout = cclLeftToRightThenTopToBottom
        ChildSizing.ControlsPerLine = 1
        ClientHeight = 74
        ClientWidth = 351
        ItemIndex = 0
        Items.Strings = (
          'Never'
          'On:'
        )
        OnClick = RadioGroup1Click
        TabOrder = 1
      end
      object DateTimePicker: TDateTimePicker
        Left = 72
        Height = 20
        Top = 320
        Width = 85
        CenturyFrom = 1941
        MaxDate = 2958465
        MinDate = -53780
        TabOrder = 2
        Enabled = False
        Color = clBtnFace
        TrailingSeparator = False
        TextForNullDate = 'NULL'
        LeadingZeros = True
        Kind = dtkDate
        TimeFormat = tf24
        TimeDisplay = tdHMS
        DateMode = dmComboBox
        Date = 38076
        Time = 0.771625092602335
        UseDefaultSeparators = True
        HideDateTimeParts = []
        MonthNames = 'Long'
        OnChange = DateTimePickerChange
      end
      object ShadowPropertiesGroup: TGroupBox
        Left = 16
        Height = 233
        Top = 24
        Width = 353
        Caption = 'Shadow Properties'
        ClientHeight = 218
        ClientWidth = 351
        TabOrder = 0
        object Label35: TLabel
          Left = 32
          Height = 14
          Top = 40
          Width = 69
          Caption = 'Min Shadow:'
          ParentColor = False
        end
        object Label37: TLabel
          Left = 200
          Height = 14
          Top = 40
          Width = 95
          Caption = 'Shadow warning:'
          ParentColor = False
        end
        object Label38: TLabel
          Left = 200
          Height = 14
          Top = 96
          Width = 71
          Caption = 'Last change:'
          ParentColor = False
        end
        object Label39: TLabel
          Left = 32
          Height = 14
          Top = 96
          Width = 73
          Caption = 'Max Shadow:'
          ParentColor = False
        end
        object Label40: TLabel
          Left = 32
          Height = 14
          Top = 160
          Width = 95
          Caption = 'Shadow Inactive:'
          ParentColor = False
        end
        object ShadowMin: TEdit
          Left = 32
          Height = 30
          Top = 56
          Width = 121
          OnChange = EditChange
          TabOrder = 0
        end
        object ShadowWarning: TEdit
          Left = 200
          Height = 30
          Top = 56
          Width = 121
          OnChange = EditChange
          TabOrder = 1
        end
        object ShadowInactive: TEdit
          Left = 32
          Height = 30
          Top = 176
          Width = 121
          OnChange = EditChange
          TabOrder = 4
        end
        object ShadowLastChange: TEdit
          Left = 200
          Height = 30
          Top = 112
          Width = 121
          Enabled = False
          TabOrder = 3
        end
        object ShadowMax: TEdit
          Left = 32
          Height = 30
          Top = 112
          Width = 121
          OnChange = EditChange
          TabOrder = 2
        end
      end
    end
    object SambaSheet: TTabSheet
      Caption = '&Samba'
      ClientHeight = 414
      ClientWidth = 388
      ImageIndex = 5
      object Label6: TLabel
        Left = 16
        Height = 14
        Top = 120
        Width = 36
        Caption = 'S&cript:'
        ParentColor = False
      end
      object Label7: TLabel
        Left = 312
        Height = 14
        Top = 72
        Width = 70
        Caption = 'H&ome Drive:'
        ParentColor = False
      end
      object Label8: TLabel
        Left = 16
        Height = 14
        Top = 168
        Width = 66
        Caption = '&Profile path:'
        ParentColor = False
      end
      object Label13: TLabel
        Left = 16
        Height = 14
        Top = 72
        Width = 72
        Caption = '&Home Share:'
        ParentColor = False
      end
      object Label21: TLabel
        Left = 16
        Height = 14
        Top = 216
        Width = 67
        Caption = 'D&escription:'
        ParentColor = False
      end
      object Label36: TLabel
        Left = 16
        Height = 14
        Top = 24
        Width = 47
        Caption = '&Domain:'
        ParentColor = False
      end
      object sambaLogonScript: TEdit
        Left = 16
        Height = 30
        Top = 136
        Width = 353
        OnChange = EditChange
        TabOrder = 3
      end
      object sambaHomeDrive: TComboBox
        Left = 312
        Height = 27
        Top = 88
        Width = 57
        ItemHeight = 0
        Items.Strings = (
          'C:'
          'D:'
          'E:'
          'F:'
          'G:'
          'H:'
          'I:'
          'J:'
          'K:'
          'L:'
          'M:'
          'N:'
          'O:'
          'P:'
          'Q:'
          'R:'
          'S:'
          'T:'
          'U:'
          'V:'
          'W:'
          'X:'
          'Y:'
          'Z:'
        )
        OnChange = sambaHomeDriveChange
        Style = csDropDownList
        TabOrder = 2
      end
      object sambaProfilePath: TEdit
        Left = 16
        Height = 30
        Top = 184
        Width = 353
        OnChange = EditChange
        TabOrder = 4
      end
      object sambaHomePath: TEdit
        Left = 16
        Height = 30
        Top = 88
        Width = 289
        OnChange = EditChange
        TabOrder = 1
      end
      object description: TMemo
        Left = 16
        Height = 57
        Top = 232
        Width = 353
        OnChange = EditChange
        TabOrder = 5
      end
      object cbDomain: TComboBox
        Left = 16
        Height = 29
        Top = 40
        Width = 353
        ItemHeight = 0
        OnChange = cbDomainChange
        Style = csDropDownList
        TabOrder = 0
      end
      object cbPwdMustChange: TCheckBox
        Left = 24
        Height = 23
        Top = 316
        Width = 283
        Caption = 'User &must change the password on next logon'
        OnClick = cbPwdMustChangeClick
        TabOrder = 7
      end
      object cbPwdCantChange: TCheckBox
        Left = 24
        Height = 23
        Top = 296
        Width = 217
        Caption = 'User can &not change the password'
        OnClick = cbPwdCantChangeClick
        TabOrder = 6
      end
      object BtnAdvanced: TButton
        Left = 296
        Height = 25
        Top = 293
        Width = 75
        Caption = '&Advanced...'
        OnClick = BtnAdvancedClick
        TabOrder = 9
      end
      object cbAccntDisabled: TCheckBox
        Left = 24
        Height = 23
        Top = 337
        Width = 132
        Caption = 'Account is &disabled'
        OnClick = cbAccntDisabledClick
        TabOrder = 8
      end
    end
    object MailSheet: TTabSheet
      Caption = '&Mail'
      ClientHeight = 414
      ClientWidth = 388
      ImageIndex = 6
      object Label10: TLabel
        Left = 16
        Height = 14
        Top = 24
        Width = 51
        Caption = 'Maildrop:'
        ParentColor = False
      end
      object Label11: TLabel
        Left = 16
        Height = 14
        Top = 72
        Width = 97
        Caption = 'E-Mail Addresses:'
        ParentColor = False
      end
      object maildrop: TEdit
        Left = 16
        Height = 30
        Top = 40
        Width = 353
        OnChange = EditChange
        TabOrder = 0
      end
      object mail: TListBox
        Left = 16
        Height = 241
        Top = 88
        Width = 353
        ItemHeight = 0
        OnClick = mailClick
        OnDblClick = EditMailBtnClick
        ScrollWidth = 349
        TabOrder = 1
        TopIndex = -1
      end
      object AddMailBtn: TButton
        Left = 16
        Height = 25
        Top = 336
        Width = 75
        Caption = '&Add'
        OnClick = AddMailBtnClick
        TabOrder = 2
      end
      object EditMailBtn: TButton
        Left = 96
        Height = 25
        Top = 336
        Width = 75
        Caption = '&Edit'
        Enabled = False
        OnClick = EditMailBtnClick
        TabOrder = 3
      end
      object DelMailBtn: TButton
        Left = 176
        Height = 25
        Top = 336
        Width = 75
        Caption = '&Remove'
        Enabled = False
        OnClick = DelMailBtnClick
        TabOrder = 4
      end
    end
    object OfficeSheet: TTabSheet
      Caption = '&Business'
      ClientHeight = 414
      ClientWidth = 388
      ImageIndex = 7
      object Label15: TLabel
        Left = 208
        Height = 14
        Top = 208
        Width = 35
        Caption = 'P&ager:'
        ParentColor = False
      end
      object Label18: TLabel
        Left = 16
        Height = 14
        Top = 64
        Width = 37
        Caption = '&Street:'
        ParentColor = False
      end
      object Label19: TLabel
        Left = 16
        Height = 14
        Top = 208
        Width = 84
        Caption = 'State/&Province:'
        ParentColor = False
      end
      object Label22: TLabel
        Left = 208
        Height = 14
        Top = 112
        Width = 39
        Caption = 'P&hone:'
        ParentColor = False
      end
      object Label24: TLabel
        Left = 112
        Height = 14
        Top = 208
        Width = 54
        Caption = '&Zip Code:'
        ParentColor = False
      end
      object Label25: TLabel
        Left = 208
        Height = 14
        Top = 64
        Width = 37
        Caption = '&Office:'
        ParentColor = False
      end
      object Label27: TLabel
        Left = 208
        Height = 14
        Top = 16
        Width = 47
        Caption = 'P&osition:'
        ParentColor = False
      end
      object Label29: TLabel
        Left = 16
        Height = 14
        Top = 16
        Width = 57
        Caption = 'C&ompany:'
        ParentColor = False
      end
      object Label30: TLabel
        Left = 208
        Height = 14
        Top = 160
        Width = 23
        Caption = '&Fax:'
        ParentColor = False
      end
      object Label31: TLabel
        Left = 16
        Height = 14
        Top = 160
        Width = 25
        Caption = '&City:'
        ParentColor = False
      end
      object pager: TEdit
        Left = 208
        Height = 30
        Top = 224
        Width = 161
        OnChange = EditChange
        TabOrder = 9
      end
      object postalAddress: TMemo
        Left = 16
        Height = 73
        Top = 80
        Width = 177
        OnChange = EditChange
        TabOrder = 1
      end
      object st: TEdit
        Left = 16
        Height = 30
        Top = 224
        Width = 89
        OnChange = EditChange
        TabOrder = 3
      end
      object telephoneNumber: TEdit
        Left = 208
        Height = 30
        Top = 128
        Width = 161
        OnChange = EditChange
        TabOrder = 7
      end
      object postalCode: TEdit
        Left = 112
        Height = 30
        Top = 224
        Width = 81
        OnChange = EditChange
        TabOrder = 4
      end
      object physicalDeliveryOfficeName: TEdit
        Left = 208
        Height = 30
        Top = 80
        Width = 161
        OnChange = EditChange
        TabOrder = 6
      end
      object o: TEdit
        Left = 16
        Height = 30
        Top = 32
        Width = 177
        OnChange = EditChange
        TabOrder = 0
      end
      object facsimileTelephoneNumber: TEdit
        Left = 208
        Height = 30
        Top = 176
        Width = 161
        OnChange = EditChange
        TabOrder = 8
      end
      object l: TEdit
        Left = 16
        Height = 30
        Top = 176
        Width = 177
        OnChange = EditChange
        TabOrder = 2
      end
      object title: TEdit
        Left = 208
        Height = 30
        Top = 32
        Width = 161
        OnChange = EditChange
        TabOrder = 5
      end
    end
    object PrivateSheet: TTabSheet
      Caption = '&Personal'
      ClientHeight = 414
      ClientWidth = 388
      ImageIndex = 8
      object Label17: TLabel
        Left = 16
        Height = 14
        Top = 24
        Width = 48
        Caption = '&Address:'
        ParentColor = False
      end
      object Label23: TLabel
        Left = 16
        Height = 14
        Top = 192
        Width = 23
        Caption = '&Fax:'
        ParentColor = False
      end
      object Label26: TLabel
        Left = 16
        Height = 14
        Top = 144
        Width = 39
        Caption = '&Phone:'
        ParentColor = False
      end
      object Label28: TLabel
        Left = 16
        Height = 14
        Top = 240
        Width = 40
        Caption = '&Mobile:'
        ParentColor = False
      end
      object Label41: TLabel
        Left = 224
        Height = 14
        Top = 144
        Width = 36
        Caption = 'Photo:'
        ParentColor = False
      end
      object homePostalAddress: TMemo
        Left = 16
        Height = 89
        Top = 40
        Width = 353
        OnChange = EditChange
        TabOrder = 0
      end
      object otherFacsimiletelephoneNumber: TEdit
        Left = 16
        Height = 30
        Top = 208
        Width = 185
        Color = clBtnFace
        Enabled = False
        TabOrder = 2
      end
      object homePhone: TEdit
        Left = 16
        Height = 30
        Top = 160
        Width = 185
        OnChange = EditChange
        TabOrder = 1
      end
      object mobile: TEdit
        Left = 16
        Height = 30
        Top = 256
        Width = 185
        OnChange = EditChange
        TabOrder = 3
      end
      object ImagePanel: TPanel
        Left = 224
        Height = 169
        Top = 160
        Width = 145
        BevelOuter = bvLowered
        Caption = 'Image'
        ClientHeight = 169
        ClientWidth = 145
        TabOrder = 4
        object Image1: TImage
          Left = 1
          Height = 167
          Top = 1
          Width = 143
          Align = alClient
          Center = True
        end
      end
      object OpenPictureBtn: TButton
        Left = 224
        Height = 25
        Top = 332
        Width = 73
        Caption = 'Open...'
        OnClick = OpenPictureBtnClick
        TabOrder = 5
      end
      object DeleteJpegBtn: TButton
        Left = 304
        Height = 25
        Top = 332
        Width = 67
        Caption = 'Delete'
        Enabled = False
        OnClick = DeleteJpegBtnClick
        TabOrder = 6
      end
    end
    object GroupSheet: TTabSheet
      Caption = '&Membership'
      ClientHeight = 414
      ClientWidth = 388
      ImageIndex = 9
      object Label34: TLabel
        Left = 16
        Height = 14
        Top = 72
        Width = 49
        Caption = 'M&ember:'
        ParentColor = False
      end
      object Label33: TLabel
        Left = 16
        Height = 14
        Top = 24
        Width = 83
        Caption = '&Primary group:'
        ParentColor = False
      end
      object GroupList: TListView
        Left = 16
        Height = 241
        Top = 88
        Width = 353
        Columns = <        
          item
            Caption = 'Name'
            Width = 160
          end        
          item
            Caption = 'Description'
            Width = 250
          end>
        HideSelection = False
        ScrollBars = ssAutoBoth
        TabOrder = 2
        ViewStyle = vsReport
        OnColumnClick = ListViewColumnClick
        OnCompare = ListViewCompare
        OnDeletion = GroupListDeletion
      end
      object AddGroupBtn: TButton
        Left = 16
        Height = 25
        Top = 336
        Width = 75
        Caption = '&Add'
        Enabled = False
        OnClick = AddGroupBtnClick
        TabOrder = 3
      end
      object RemoveGroupBtn: TButton
        Left = 96
        Height = 25
        Top = 336
        Width = 75
        Caption = '&Remove'
        Enabled = False
        OnClick = RemoveGroupBtnClick
        TabOrder = 4
      end
      object PrimaryGroupBtn: TButton
        Left = 312
        Height = 25
        Top = 40
        Width = 59
        Caption = '&Set...'
        OnClick = PrimaryGroupBtnClick
        TabOrder = 1
      end
      object edGidNumber: TEdit
        Left = 16
        Height = 30
        Top = 40
        Width = 289
        Enabled = False
        TabOrder = 0
      end
      object cbxGroups: TComboBox
        Left = 200
        Height = 27
        Top = 336
        Width = 169
        ItemHeight = 0
        Items.Strings = (
          'All groups'
          'Posix groups'
          'Samba groups'
          'Mail groups'
        )
        OnChange = cbxGroupsChange
        Style = csDropDownList
        TabOrder = 5
      end
    end
  end
  object Panel1: TPanel
    Left = 0
    Height = 55
    Top = 442
    Width = 398
    Align = alBottom
    ClientHeight = 55
    ClientWidth = 398
    TabOrder = 1
    object OkBtn: TButton
      Left = 120
      Height = 25
      Top = 16
      Width = 75
      Caption = '&OK'
      Default = True
      ModalResult = 1
      TabOrder = 0
    end
    object CancelBtn: TButton
      Left = 200
      Height = 25
      Top = 16
      Width = 75
      Cancel = True
      Caption = '&Cancel'
      ModalResult = 2
      TabOrder = 1
    end
  end
  object OpenPictureDialog: TOpenPictureDialog
    Left = 336
    Top = 448
  end
end
