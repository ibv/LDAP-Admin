object ADUserDlg: TADUserDlg
  Left = 423
  Height = 450
  Top = 181
  Width = 394
  BorderStyle = bsDialog
  Caption = 'Create User'
  ClientHeight = 450
  ClientWidth = 394
  Color = clBtnFace
  OnClose = FormClose
  OnCloseQuery = FormCloseQuery
  OnDestroy = FormDestroy
  ParentFont = True
  Position = poMainFormCenter
  LCLVersion = '1.6.2.0'
  object PageControl: TPageControl
    Left = 0
    Height = 395
    Top = 0
    Width = 394
    ActivePage = OptionsSheet
    Align = alClient
    MultiLine = True
    TabIndex = 1
    TabOrder = 0
    OnChange = PageControlChange
    OnChanging = PageControlChanging
    OnResize = PageControlResize
    Options = [nboMultiLine]
    object AccountSheet: TTabSheet
      Caption = '&Account'
      ClientHeight = 358
      ClientWidth = 386
      object Label1: TLabel
        Left = 16
        Height = 15
        Top = 16
        Width = 71
        Caption = '&First name:'
        ParentColor = False
      end
      object Label2: TLabel
        Left = 224
        Height = 15
        Top = 16
        Width = 93
        Caption = '&Second name:'
        ParentColor = False
      end
      object Label3: TLabel
        Left = 16
        Height = 15
        Top = 64
        Width = 91
        Caption = '&Display name:'
        ParentColor = False
      end
      object Label4: TLabel
        Left = 16
        Height = 15
        Top = 208
        Width = 254
        Caption = '&User logon name (user principal name):'
        ParentColor = False
      end
      object Label5: TLabel
        Left = 160
        Height = 15
        Top = 16
        Width = 44
        Caption = '&Initials:'
        ParentColor = False
      end
      object Label21: TLabel
        Left = 16
        Height = 15
        Top = 112
        Width = 76
        Caption = 'D&escription:'
        ParentColor = False
      end
      object Label12: TLabel
        Left = 16
        Height = 15
        Top = 256
        Width = 105
        Caption = '&NT Logon name:'
        ParentColor = False
      end
      object Label10: TLabel
        Left = 16
        Height = 15
        Top = 160
        Width = 71
        Caption = 'Username:'
        ParentColor = False
      end
      object Label13: TLabel
        Left = 16
        Height = 15
        Top = 304
        Width = 63
        Caption = 'Pass&word:'
        ParentColor = False
        Visible = False
      end
      object Label14: TLabel
        Left = 196
        Height = 15
        Top = 304
        Width = 118
        Caption = 'Confirm password:'
        ParentColor = False
        Visible = False
      end
      object givenName: TEdit
        Left = 16
        Height = 21
        Top = 32
        Width = 137
        OnChange = EditChange
        TabOrder = 0
      end
      object sn: TEdit
        Left = 224
        Height = 21
        Top = 32
        Width = 145
        OnChange = EditChange
        OnExit = snExit
        TabOrder = 2
      end
      object displayName: TEdit
        Left = 16
        Height = 21
        Top = 80
        Width = 353
        OnChange = EditChange
        TabOrder = 3
      end
      object userPrincipalName: TEdit
        Left = 16
        Height = 21
        Top = 224
        Width = 174
        OnChange = userPrincipalNameChange
        OnExit = userPrincipalNameExit
        TabOrder = 6
      end
      object initials: TEdit
        Left = 160
        Height = 21
        Top = 32
        Width = 57
        OnChange = EditChange
        TabOrder = 1
      end
      object samAccountName: TEdit
        Left = 196
        Height = 21
        Top = 272
        Width = 173
        OnChange = EditChange
        TabOrder = 8
      end
      object description: TEdit
        Left = 16
        Height = 21
        Top = 128
        Width = 353
        OnChange = EditChange
        TabOrder = 4
      end
      object cbUPNDomain: TComboBox
        Left = 196
        Height = 21
        Top = 224
        Width = 173
        ItemHeight = 0
        OnChange = cbUPNDomainChange
        OnDropDown = cbUPNDomainDropDown
        TabOrder = 7
      end
      object NTDomain: TEdit
        Left = 16
        Height = 21
        Top = 272
        Width = 174
        Enabled = False
        TabOrder = 9
      end
      object cn: TEdit
        Left = 16
        Height = 21
        Top = 176
        Width = 353
        Enabled = False
        OnChange = EditChange
        TabOrder = 5
      end
      object edPassword1: TEdit
        Left = 16
        Height = 21
        Top = 320
        Width = 174
        EchoMode = emPassword
        PasswordChar = '*'
        TabOrder = 10
        Visible = False
      end
      object edPassword2: TEdit
        Left = 196
        Height = 19
        Top = 320
        Width = 173
        EchoMode = emPassword
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        ParentFont = False
        PasswordChar = '*'
        TabOrder = 11
        Visible = False
      end
    end
    object OptionsSheet: TTabSheet
      Caption = 'Account options'
      ClientHeight = 358
      ClientWidth = 386
      ImageIndex = 6
      object rgAccountExpires: TRadioGroup
        Left = 16
        Height = 89
        Top = 238
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
        ClientHeight = 58
        ClientWidth = 349
        ItemIndex = 0
        Items.Strings = (
          'Never'
          'On:'
        )
        OnClick = rgAccountExpiresClick
        TabOrder = 3
      end
      object DatePicker: TDateTimePicker
        Left = 78
        Height = 23
        Top = 294
        Width = 97
        CenturyFrom = 1941
        MaxDate = 2958465
        MinDate = -53780
        TabOrder = 4
        Enabled = False
        Color = clBtnFace
        TrailingSeparator = False
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
        OnChange = DatePickerChange
      end
      object clbxAccountOptions: TCheckListBox
        Left = 16
        Height = 150
        Top = 51
        Width = 353
        Items.Strings = (
          'User must change the password on next logon'
          'User cannot change password'
          'Password never expires'
          'Store password using reversible encryption'
          'Account is disabled'
          'Smartcard is required for interactive logon'
          'Account is enabled for delegation'
          'Account is sensitive and cannot be delegated'
          'Use Kerberos DES encryption'
          'Do not require Kerberos preauthentication'
          'Password is not required'
        )
        ItemHeight = 21
        OnClickCheck = clbxAccountOptionsClickCheck
        TabOrder = 1
        Data = {
          0B0000000000000000000000000000
        }
      end
      object BtnAdditional: TButton
        Left = 277
        Height = 25
        Top = 207
        Width = 92
        Caption = '&Additional...'
        OnClick = BtnAdditionalClick
        TabOrder = 2
      end
      object cbAccountLockout: TCheckBox
        Left = 16
        Height = 26
        Top = 20
        Width = 164
        Caption = 'Account is locked out'
        Enabled = False
        OnClick = cbAccountLockoutClick
        TabOrder = 0
      end
      object TimePicker: TDateTimePicker
        Left = 244
        Height = 23
        Top = 294
        Width = 107
        ShowCheckBox = True
        CenturyFrom = 1941
        MaxDate = 2958465
        MinDate = -53780
        TabOrder = 5
        Enabled = False
        TrailingSeparator = False
        LeadingZeros = True
        Kind = dtkTime
        TimeFormat = tf24
        TimeDisplay = tdHMS
        DateMode = dmComboBox
        Date = 42745
        Time = 0
        UseDefaultSeparators = True
        HideDateTimeParts = []
        MonthNames = 'Long'
        OnChange = TimePickerChange
      end
      object TimeLabel: TStaticText
        Left = 219
        Height = 17
        Top = 298
        Width = 19
        Alignment = taRightJustify
        Caption = 'At:'
        TabOrder = 6
      end
    end
    object ProfileSheet: TTabSheet
      Caption = '&Profile'
      ClientHeight = 358
      ClientWidth = 386
      ImageIndex = 5
      object Label6: TLabel
        Left = 18
        Height = 15
        Top = 80
        Width = 41
        Caption = 'S&cript:'
        ParentColor = False
      end
      object Label7: TLabel
        Left = 312
        Height = 15
        Top = 29
        Width = 80
        Caption = 'H&ome Drive:'
        ParentColor = False
      end
      object Label8: TLabel
        Left = 18
        Height = 15
        Top = 131
        Width = 76
        Caption = '&Profile path:'
        ParentColor = False
      end
      object Label9: TLabel
        Left = 17
        Height = 15
        Top = 29
        Width = 104
        Caption = '&Home Directory:'
        ParentColor = False
      end
      object scriptPath: TEdit
        Left = 17
        Height = 21
        Top = 96
        Width = 353
        OnChange = EditChange
        TabOrder = 2
      end
      object homeDrive: TComboBox
        Left = 312
        Height = 27
        Top = 45
        Width = 57
        ItemHeight = 0
        Items.Strings = (
          ''
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
        OnChange = homeDriveChange
        Style = csDropDownList
        TabOrder = 1
      end
      object profilePath: TEdit
        Left = 18
        Height = 21
        Top = 147
        Width = 353
        OnChange = EditChange
        TabOrder = 3
      end
      object homeDirectory: TEdit
        Left = 18
        Height = 21
        Top = 45
        Width = 288
        OnChange = EditChange
        TabOrder = 0
      end
    end
    object OfficeSheet: TTabSheet
      Caption = '&Business'
      ClientHeight = 358
      ClientWidth = 386
      ImageIndex = 7
      object Label15: TLabel
        Left = 208
        Height = 15
        Top = 192
        Width = 40
        Caption = 'P&ager:'
        ParentColor = False
      end
      object Label18: TLabel
        Left = 16
        Height = 15
        Top = 56
        Width = 44
        Caption = '&Street:'
        ParentColor = False
      end
      object Label19: TLabel
        Left = 16
        Height = 15
        Top = 192
        Width = 97
        Caption = 'State/&Province:'
        ParentColor = False
      end
      object Label22: TLabel
        Left = 208
        Height = 15
        Top = 98
        Width = 44
        Caption = 'P&hone:'
        ParentColor = False
      end
      object Label24: TLabel
        Left = 112
        Height = 15
        Top = 192
        Width = 62
        Caption = '&Zip Code:'
        ParentColor = False
      end
      object Label25: TLabel
        Left = 208
        Height = 15
        Top = 53
        Width = 40
        Caption = '&Office:'
        ParentColor = False
      end
      object Label27: TLabel
        Left = 208
        Height = 15
        Top = 8
        Width = 54
        Caption = 'P&osition:'
        ParentColor = False
      end
      object Label29: TLabel
        Left = 16
        Height = 15
        Top = 8
        Width = 64
        Caption = 'C&ompany:'
        ParentColor = False
      end
      object Label30: TLabel
        Left = 208
        Height = 15
        Top = 144
        Width = 25
        Caption = '&Fax:'
        ParentColor = False
      end
      object Label31: TLabel
        Left = 16
        Height = 15
        Top = 144
        Width = 27
        Caption = '&City:'
        ParentColor = False
      end
      object Label11: TLabel
        Left = 16
        Height = 15
        Top = 242
        Width = 98
        Caption = 'E-Mail Address:'
        ParentColor = False
      end
      object Label16: TLabel
        Left = 16
        Height = 15
        Top = 290
        Width = 66
        Caption = 'Web page:'
        ParentColor = False
      end
      object pager: TEdit
        Left = 208
        Height = 21
        Top = 208
        Width = 161
        OnChange = EditChange
        TabOrder = 9
      end
      object streetAddress: TMemo
        Left = 16
        Height = 64
        Top = 72
        Width = 186
        OnChange = EditChange
        TabOrder = 1
      end
      object st: TEdit
        Left = 16
        Height = 21
        Top = 208
        Width = 89
        OnChange = EditChange
        TabOrder = 3
      end
      object telephoneNumber: TEdit
        Left = 208
        Height = 21
        Top = 115
        Width = 161
        OnChange = EditChange
        TabOrder = 7
      end
      object postalCode: TEdit
        Left = 112
        Height = 21
        Top = 208
        Width = 90
        OnChange = EditChange
        TabOrder = 4
      end
      object physicalDeliveryOfficeName: TEdit
        Left = 208
        Height = 21
        Top = 72
        Width = 161
        OnChange = EditChange
        TabOrder = 6
      end
      object o: TEdit
        Left = 16
        Height = 21
        Top = 24
        Width = 186
        OnChange = EditChange
        TabOrder = 0
      end
      object facsimileTelephoneNumber: TEdit
        Left = 208
        Height = 21
        Top = 160
        Width = 161
        OnChange = EditChange
        TabOrder = 8
      end
      object l: TEdit
        Left = 16
        Height = 21
        Top = 160
        Width = 186
        OnChange = EditChange
        TabOrder = 2
      end
      object title: TEdit
        Left = 208
        Height = 21
        Top = 24
        Width = 161
        OnChange = EditChange
        TabOrder = 5
      end
      object mail: TEdit
        Left = 16
        Height = 21
        Top = 257
        Width = 186
        OnChange = EditChange
        TabOrder = 10
      end
      object wWWHomePage: TEdit
        Left = 16
        Height = 21
        Top = 305
        Width = 353
        OnChange = EditChange
        TabOrder = 11
      end
    end
    object PrivateSheet: TTabSheet
      Caption = '&Personal'
      ClientHeight = 358
      ClientWidth = 386
      ImageIndex = 8
      object Label17: TLabel
        Left = 15
        Height = 15
        Top = 12
        Width = 27
        Caption = '&Info:'
        ParentColor = False
      end
      object Label23: TLabel
        Left = 16
        Height = 15
        Top = 184
        Width = 25
        Caption = '&Fax:'
        ParentColor = False
      end
      object Label26: TLabel
        Left = 16
        Height = 15
        Top = 136
        Width = 44
        Caption = '&Phone:'
        ParentColor = False
      end
      object Label28: TLabel
        Left = 16
        Height = 15
        Top = 232
        Width = 45
        Caption = '&Mobile:'
        ParentColor = False
      end
      object Label41: TLabel
        Left = 224
        Height = 15
        Top = 136
        Width = 41
        Caption = 'Photo:'
        ParentColor = False
      end
      object info: TMemo
        Left = 15
        Height = 89
        Top = 31
        Width = 353
        OnChange = EditChange
        TabOrder = 0
      end
      object otherFacsimiletelephoneNumber: TEdit
        Left = 16
        Height = 21
        Top = 200
        Width = 185
        Color = clBtnFace
        Enabled = False
        OnChange = EditChange
        TabOrder = 2
      end
      object homePhone: TEdit
        Left = 16
        Height = 21
        Top = 155
        Width = 185
        OnChange = EditChange
        TabOrder = 1
      end
      object mobile: TEdit
        Left = 16
        Height = 21
        Top = 251
        Width = 185
        OnChange = EditChange
        TabOrder = 3
      end
      object ImagePanel: TPanel
        Left = 224
        Height = 169
        Top = 152
        Width = 145
        BevelOuter = bvLowered
        Caption = 'JPeg Image'
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
        Top = 324
        Width = 73
        Caption = 'Open...'
        OnClick = OpenPictureBtnClick
        TabOrder = 5
      end
      object DeleteJpegBtn: TButton
        Left = 301
        Height = 25
        Top = 324
        Width = 67
        Caption = 'Delete'
        Enabled = False
        OnClick = DeleteJpegBtnClick
        TabOrder = 6
      end
    end
    object GroupSheet: TTabSheet
      Caption = '&Membership'
      ClientHeight = 358
      ClientWidth = 386
      ImageIndex = 9
      object Label34: TLabel
        Left = 16
        Height = 15
        Top = 56
        Width = 57
        Caption = 'M&ember:'
        ParentColor = False
      end
      object Label33: TLabel
        Left = 16
        Height = 15
        Top = 8
        Width = 94
        Caption = '&Primary group:'
        ParentColor = False
      end
      object GroupList: TListView
        Left = 16
        Height = 241
        Top = 73
        Width = 353
        Columns = <        
          item
            Caption = 'Name'
            Width = 140
          end        
          item
            Caption = 'Path'
            Width = 205
          end>
        HideSelection = False
        ScrollBars = ssAutoBoth
        TabOrder = 2
        ViewStyle = vsReport
        OnColumnClick = ListViewColumnClick
        OnCompare = ListViewCompare
      end
      object AddGroupBtn: TButton
        Left = 16
        Height = 25
        Top = 320
        Width = 75
        Caption = '&Add'
        OnClick = AddGroupBtnClick
        TabOrder = 3
      end
      object RemoveGroupBtn: TButton
        Left = 97
        Height = 25
        Top = 320
        Width = 75
        Caption = '&Remove'
        Enabled = False
        OnClick = RemoveGroupBtnClick
        TabOrder = 4
      end
      object PrimaryGroupBtn: TButton
        Left = 296
        Height = 25
        Top = 22
        Width = 75
        Caption = '&Set...'
        OnClick = PrimaryGroupBtnClick
        TabOrder = 1
      end
      object edPrimaryGroup: TEdit
        Left = 17
        Height = 21
        Top = 24
        Width = 273
        Enabled = False
        TabOrder = 0
      end
    end
    object TemplateSheet: TTabSheet
      Caption = '&Templates'
      ClientHeight = 358
      ClientWidth = 386
      ImageIndex = 7
      object CheckListBox: TCheckListBox
        Left = 3
        Height = 312
        Top = 25
        Width = 380
        ItemHeight = 24
        OnClick = CheckListBoxClick
        OnClickCheck = CheckListBoxClickCheck
        OnDrawItem = CheckListBoxDrawItem
        Sorted = True
        Style = lbOwnerDrawFixed
        TabOrder = 0
        TopIndex = -1
      end
    end
  end
  object Panel1: TPanel
    Left = 0
    Height = 55
    Top = 395
    Width = 394
    Align = alBottom
    ClientHeight = 55
    ClientWidth = 394
    TabOrder = 1
    object OkBtn: TButton
      Left = 119
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
    object ApplyBtn: TButton
      Left = 281
      Height = 25
      Top = 16
      Width = 75
      Caption = 'Appl&y'
      Enabled = False
      OnClick = ApplyBtnClick
      TabOrder = 2
    end
  end
  object OpenPictureDialog: TOpenPictureDialog
    Filter = 'All image files(*.gif;*.jpg;*.jpeg;*.png;*.bmp;*.tif;*.tiff;*.emf;*.wmf)|*.gif;*.jpg;*.jpeg;*.png;*.bmp;*.tif;*.tiff;*.emf;*.wmf|All files (*.*)|*.*|GIF Image (*.gif)|*.gif|JPEG Image File (*.jpg)|*.jpg|JPEG Image File (*.jpeg)|*.jpeg|Portable Network Graphics (*.png)|*.png|Bitmaps (*.bmp)|*.bmp|TIFF Images (*.tif)|*.tif|TIFF Images (*.tiff)|*.tiff|Enhanced Metafiles (*.emf)|*.emf|Metafiles (*.wmf)|*.wmf'
    left = 52
    top = 400
  end
  object ApplicationEvents1: TApplicationProperties
    OnIdle = ApplicationEvents1Idle
    left = 16
    top = 403
  end
end
