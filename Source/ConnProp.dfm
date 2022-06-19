object ConnPropDlg: TConnPropDlg
  Left = 355
  Height = 377
  Top = 237
  Width = 434
  ActiveControl = NameEd
  BorderStyle = bsDialog
  BorderWidth = 8
  Caption = 'Connection properties'
  ClientHeight = 377
  ClientWidth = 434
  Color = clBtnFace
  ParentFont = True
  Position = poOwnerFormCenter
  LCLVersion = '2.2.2.0'
  object Panel1: TPanel
    Left = 8
    Height = 34
    Top = 8
    Width = 418
    Align = alTop
    BevelOuter = bvNone
    ClientHeight = 34
    ClientWidth = 418
    TabOrder = 0
    object Label1: TLabel
      Left = 0
      Height = 15
      Top = 9
      Width = 110
      Caption = 'Connection name:'
      ParentColor = False
    end
    object NameEd: TEdit
      Left = 112
      Height = 26
      Top = 2
      Width = 304
      Anchors = [akTop, akLeft, akRight]
      TabOrder = 0
    end
  end
  object Panel2: TPanel
    Left = 8
    Height = 294
    Top = 42
    Width = 418
    Align = alClient
    BevelOuter = bvNone
    ClientHeight = 294
    ClientWidth = 418
    TabOrder = 1
    object PageControl1: TPageControl
      Left = 0
      Height = 294
      Top = 0
      Width = 418
      ActivePage = TabSheet1
      Align = alClient
      TabIndex = 0
      TabOrder = 0
      object TabSheet1: TTabSheet
        Caption = 'General'
        ClientHeight = 267
        ClientWidth = 408
        object AccountBox: TGroupBox
          Left = 8
          Height = 99
          Top = 153
          Width = 409
          Caption = ' Account '
          ClientHeight = 83
          ClientWidth = 407
          TabOrder = 1
          object Label4: TLabel
            Left = 8
            Height = 15
            Top = 5
            Width = 65
            Caption = 'Username:'
            ParentColor = False
          end
          object Label5: TLabel
            Left = 8
            Height = 15
            Top = 33
            Width = 60
            Caption = 'Password:'
            ParentColor = False
            ParentFont = False
          end
          object UserEd: TEdit
            Left = 88
            Height = 26
            Top = -2
            Width = 306
            TabOrder = 0
          end
          object PasswordEd: TEdit
            Left = 88
            Height = 26
            Hint = 'This storage does not allow to keep the password'
            Top = 28
            Width = 306
            EchoMode = emPassword
            ParentShowHint = False
            PasswordChar = '*'
            ShowHint = True
            TabOrder = 1
          end
          object cbAnonymous: TCheckBox
            Left = 8
            Height = 21
            Top = 58
            Width = 166
            Caption = 'Anonymous connection'
            OnClick = cbAnonymousClick
            TabOrder = 2
          end
        end
        object ConnectionBox: TGroupBox
          Left = 8
          Height = 138
          Top = 8
          Width = 409
          Caption = ' Connection: '
          ClientHeight = 122
          ClientWidth = 407
          TabOrder = 0
          object Label2: TLabel
            Left = 8
            Height = 15
            Top = 9
            Width = 31
            Caption = 'Host:'
            ParentColor = False
          end
          object Label3: TLabel
            Left = 205
            Height = 15
            Top = 9
            Width = 28
            Alignment = taRightJustify
            Caption = 'Port:'
            ParentColor = False
          end
          object Label7: TLabel
            Left = 286
            Height = 15
            Top = 9
            Width = 47
            Caption = 'Version:'
            ParentColor = False
          end
          object Label6: TLabel
            Left = 8
            Height = 15
            Top = 38
            Width = 32
            Caption = 'Base:'
            ParentColor = False
          end
          object ServerEd: TEdit
            Left = 50
            Height = 26
            Top = 2
            Width = 149
            TabOrder = 0
          end
          object PortEd: TEdit
            Left = 236
            Height = 26
            Top = 1
            Width = 45
            OnExit = ValidateInput
            TabOrder = 1
            Text = '389'
          end
          object VersionCombo: TComboBox
            Left = 336
            Height = 27
            Top = 1
            Width = 61
            ItemHeight = 0
            Items.Strings = (
              '2'
              '3'
            )
            OnChange = VersionComboChange
            Style = csDropDownList
            TabOrder = 2
          end
          object FetchDnBtn: TBitBtn
            Left = 296
            Height = 25
            Top = 34
            Width = 101
            Caption = 'Fetch DNs'
            OnClick = FetchDnBtnClick
            TabOrder = 4
          end
          object BaseEd: TComboBox
            Left = 50
            Height = 27
            Top = 34
            Width = 231
            ItemHeight = 0
            Style = csSimple
            TabOrder = 3
          end
          object rbSimpleAuth: TRadioButton
            Left = 50
            Height = 21
            Top = 66
            Width = 157
            Caption = 'Simple authentication'
            Checked = True
            OnClick = MethodChange
            TabOrder = 5
            TabStop = True
          end
          object rbGssApi: TRadioButton
            Left = 50
            Height = 21
            Top = 87
            Width = 72
            Caption = 'GSS-API'
            OnClick = MethodChange
            TabOrder = 6
          end
          object cbSSL: TCheckBox
            Left = 224
            Height = 21
            Top = 66
            Width = 47
            Caption = 'SSL'
            OnClick = cbSSLClick
            TabOrder = 7
          end
          object cbSASL: TCheckBox
            Left = 224
            Height = 21
            Top = 87
            Width = 55
            Caption = 'SASL'
            OnClick = cbSASLClick
            TabOrder = 8
          end
          object cbTLS: TCheckBox
            Left = 286
            Height = 21
            Top = 66
            Width = 46
            Caption = 'TLS'
            OnClick = cbTLSClick
            TabOrder = 9
          end
        end
      end
      object TabSheet2: TTabSheet
        Caption = '&Options'
        ClientHeight = 267
        ClientWidth = 408
        ImageIndex = 1
        object GroupBox1: TGroupBox
          Left = 8
          Height = 246
          Top = 3
          Width = 198
          Caption = 'Search'
          ClientHeight = 244
          ClientWidth = 196
          TabOrder = 0
          object Label15: TLabel
            Left = 24
            Height = 15
            Top = 116
            Width = 59
            Caption = 'Page size:'
            ParentColor = False
          end
          object Label14: TLabel
            Left = 24
            Height = 15
            Top = 0
            Width = 63
            Caption = 'Time limit:'
            ParentColor = False
          end
          object Label13: TLabel
            Left = 24
            Height = 15
            Top = 46
            Width = 58
            Caption = 'Size limit:'
            ParentColor = False
          end
          object Label8: TLabel
            Left = 24
            Height = 15
            Top = 172
            Width = 120
            Caption = 'Dereference aliases:'
            ParentColor = False
          end
          object edTimeLimit: TEdit
            Left = 24
            Height = 26
            Top = 15
            Width = 81
            OnExit = ValidateInput
            TabOrder = 0
          end
          object edSizeLimit: TEdit
            Left = 24
            Height = 26
            Top = 62
            Width = 81
            OnExit = ValidateInput
            TabOrder = 1
          end
          object cbxPagedSearch: TCheckBox
            Left = 24
            Height = 21
            Top = 93
            Width = 105
            Caption = 'Paged search'
            OnClick = cbxPagedSearchClick
            TabOrder = 2
          end
          object edPageSize: TEdit
            Left = 24
            Height = 26
            Top = 136
            Width = 81
            OnExit = ValidateInput
            TabOrder = 3
          end
          object cbDerefAliases: TComboBox
            Left = 24
            Height = 27
            Top = 186
            Width = 161
            ItemHeight = 0
            Items.Strings = (
              'Never'
              'When searching'
              'When finding'
              'Always'
            )
            Style = csDropDownList
            TabOrder = 4
          end
        end
        object GroupBox2: TGroupBox
          Left = 207
          Height = 149
          Top = 3
          Width = 198
          Caption = 'Referrals'
          ClientHeight = 147
          ClientWidth = 196
          TabOrder = 1
          object Label10: TLabel
            Left = 16
            Height = 15
            Top = 0
            Width = 93
            Caption = 'Chase referrals:'
            ParentColor = False
          end
          object Label11: TLabel
            Left = 16
            Height = 15
            Top = 58
            Width = 83
            Caption = 'Referral hops:'
            ParentColor = False
          end
          object cbReferrals: TComboBox
            Left = 16
            Height = 27
            Top = 14
            Width = 137
            ItemHeight = 0
            Items.Strings = (
              'Enable'
              'Disable'
            )
            OnClick = cbReferralsClick
            Style = csDropDownList
            TabOrder = 0
          end
          object edReferralHops: TEdit
            Left = 16
            Height = 26
            Top = 73
            Width = 81
            OnExit = ValidateInput
            TabOrder = 1
          end
        end
        object GroupBox3: TGroupBox
          Left = 207
          Height = 88
          Top = 160
          Width = 198
          Caption = 'Directory'
          ClientHeight = 86
          ClientWidth = 196
          TabOrder = 2
          object Label9: TLabel
            Left = 21
            Height = 15
            Top = 14
            Width = 90
            Alignment = taRightJustify
            Caption = 'Directory type:'
            ParentColor = False
          end
          object cbDirectoryType: TComboBox
            Left = 16
            Height = 27
            Top = 29
            Width = 169
            ItemHeight = 0
            Items.Strings = (
              'Autodetect'
              'Posix Directory'
              'Active Directory'
            )
            OnChange = cbDirectoryTypeChange
            OnClick = cbReferralsClick
            Style = csDropDownList
            TabOrder = 0
          end
        end
      end
      object TabSheet3: TTabSheet
        Caption = '&Attributes'
        ClientHeight = 267
        ClientWidth = 408
        ImageIndex = 2
        object cbxShowAttrs: TCheckBox
          Left = 16
          Height = 21
          Top = 3
          Width = 195
          Caption = '&Show operational attributes:'
          OnClick = cbxShowAttrsClick
          TabOrder = 0
        end
        object lbxAttributes: TListBox
          Left = 16
          Height = 217
          Top = 27
          Width = 305
          Color = clBtnFace
          Enabled = False
          ItemHeight = 0
          ScrollWidth = 301
          TabOrder = 1
          TopIndex = -1
        end
        object btnAdd: TButton
          Left = 328
          Height = 25
          Top = 27
          Width = 75
          Caption = '&Add'
          Enabled = False
          OnClick = btnAddClick
          TabOrder = 2
        end
        object btnRemove: TButton
          Left = 328
          Height = 25
          Top = 59
          Width = 75
          Caption = '&Remove'
          Enabled = False
          OnClick = btnRemoveClick
          TabOrder = 3
        end
      end
    end
  end
  object ButtonsPnl: TPanel
    Left = 8
    Height = 33
    Top = 336
    Width = 418
    Align = alBottom
    BevelOuter = bvNone
    ClientHeight = 33
    ClientWidth = 418
    TabOrder = 2
    object OKBtn: TButton
      Left = 262
      Height = 25
      Top = 8
      Width = 75
      Anchors = [akRight, akBottom]
      Caption = 'OK'
      ModalResult = 1
      TabOrder = 1
    end
    object CancelBtn: TButton
      Left = 342
      Height = 25
      Top = 8
      Width = 75
      Anchors = [akRight, akBottom]
      Caption = '&Cancel'
      ModalResult = 2
      TabOrder = 2
    end
    object TestBtn: TButton
      Left = 2
      Height = 25
      Top = 8
      Width = 119
      Anchors = [akLeft, akBottom]
      Caption = 'Test connection'
      OnClick = TestBtnClick
      TabOrder = 0
    end
  end
end
