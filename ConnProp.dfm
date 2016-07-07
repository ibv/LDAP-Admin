object ConnPropDlg: TConnPropDlg
  Left = 697
  Height = 417
  Top = 277
  Width = 434
  BorderStyle = bsDialog
  BorderWidth = 8
  Caption = 'Connection properties'
  ClientHeight = 417
  ClientWidth = 434
  Color = clBtnFace
  ParentFont = True
  Position = poOwnerFormCenter
  LCLVersion = '1.6.0.4'
  object Panel2: TPanel
    Left = 8
    Height = 334
    Top = 42
    Width = 418
    Align = alClient
    BevelOuter = bvNone
    ClientHeight = 334
    ClientWidth = 418
    TabOrder = 0
    object PageControl1: TPageControl
      Left = 0
      Height = 334
      Top = 0
      Width = 418
      ActivePage = TabSheet1
      Align = alClient
      TabIndex = 0
      TabOrder = 0
      object TabSheet1: TTabSheet
        Caption = 'General'
        ClientHeight = 297
        ClientWidth = 410
        object AccountBox: TGroupBox
          Left = 1
          Height = 134
          Top = 158
          Width = 409
          Caption = ' Account '
          ClientHeight = 103
          ClientWidth = 405
          TabOrder = 1
          object Label4: TLabel
            Left = 6
            Height = 15
            Top = 14
            Width = 71
            Caption = 'Username:'
            ParentColor = False
          end
          object Label5: TLabel
            Left = 6
            Height = 15
            Top = 46
            Width = 63
            Caption = 'Password:'
            ParentColor = False
          end
          object UserEd: TEdit
            Left = 86
            Height = 21
            Top = 10
            Width = 306
            TabOrder = 0
          end
          object PasswordEd: TEdit
            Left = 86
            Height = 21
            Hint = 'This storage does not allow to keep the password'
            Top = 42
            Width = 306
            EchoMode = emPassword
            ParentShowHint = False
            PasswordChar = '*'
            ShowHint = True
            TabOrder = 1
          end
          object cbAnonymous: TCheckBox
            Left = 6
            Height = 26
            Top = 74
            Width = 178
            Caption = 'Anonymous connection'
            OnClick = cbAnonymousClick
            TabOrder = 2
          end
        end
        object ConnectionBox: TGroupBox
          Left = 1
          Height = 152
          Top = 0
          Width = 409
          Caption = ' Connection: '
          ClientHeight = 121
          ClientWidth = 405
          TabOrder = 0
          object Label2: TLabel
            Left = 3
            Height = 15
            Top = 14
            Width = 34
            Caption = 'Host:'
            ParentColor = False
          end
          object Label3: TLabel
            Left = 195
            Height = 15
            Top = 14
            Width = 30
            Caption = 'Port:'
            ParentColor = False
          end
          object Label7: TLabel
            Left = 284
            Height = 15
            Top = 14
            Width = 51
            Caption = 'Version:'
            ParentColor = False
          end
          object Label6: TLabel
            Left = 3
            Height = 15
            Top = 46
            Width = 36
            Caption = 'Base:'
            ParentColor = False
          end
          object ServerEd: TEdit
            Left = 38
            Height = 21
            Top = 10
            Width = 158
            TabOrder = 0
          end
          object PortEd: TEdit
            Left = 223
            Height = 21
            Top = 10
            Width = 61
            OnExit = ValidateInput
            TabOrder = 1
            Text = '389'
          end
          object VersionCombo: TComboBox
            Left = 334
            Height = 23
            Top = 9
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
            Left = 294
            Height = 23
            Top = 42
            Width = 101
            Caption = 'Fetch DNs'
            OnClick = FetchDnBtnClick
            TabOrder = 4
          end
          object BaseEd: TComboBox
            Left = 38
            Height = 21
            Top = 42
            Width = 247
            ItemHeight = 0
            TabOrder = 3
          end
          object rbSimpleAuth: TRadioButton
            Left = 38
            Height = 26
            Top = 74
            Width = 168
            Caption = 'Simple authentication'
            Checked = True
            OnClick = MethodChange
            TabOrder = 5
            TabStop = True
          end
          object rbGssApi: TRadioButton
            Left = 38
            Height = 26
            Top = 95
            Width = 81
            Caption = 'GSS-API'
            OnClick = MethodChange
            TabOrder = 6
          end
          object cbSSL: TCheckBox
            Left = 222
            Height = 26
            Top = 74
            Width = 53
            Caption = 'SSL'
            OnClick = cbSSLClick
            TabOrder = 7
          end
          object cbSASL: TCheckBox
            Left = 222
            Height = 26
            Top = 95
            Width = 62
            Caption = 'SASL'
            OnClick = cbSASLClick
            TabOrder = 8
          end
          object cbTLS: TCheckBox
            Left = 270
            Height = 26
            Top = 74
            Width = 51
            Caption = 'TLS'
            OnClick = cbTLSClick
            TabOrder = 9
          end
        end
      end
      object TabSheet2: TTabSheet
        Caption = '&Options'
        ClientHeight = 297
        ClientWidth = 410
        ImageIndex = 1
        object GroupBox1: TGroupBox
          Left = 1
          Height = 168
          Top = 0
          Width = 409
          Caption = 'Search'
          ClientHeight = 137
          ClientWidth = 405
          TabOrder = 0
          object Label15: TLabel
            Left = 238
            Height = 15
            Top = 90
            Width = 64
            Caption = 'Page size:'
            ParentColor = False
          end
          object Label14: TLabel
            Left = 30
            Height = 15
            Top = 10
            Width = 66
            Caption = 'Time limit:'
            ParentColor = False
          end
          object Label13: TLabel
            Left = 30
            Height = 15
            Top = 50
            Width = 62
            Caption = 'Size limit:'
            ParentColor = False
          end
          object Label8: TLabel
            Left = 30
            Height = 15
            Top = 90
            Width = 131
            Caption = 'Dereference aliases:'
            ParentColor = False
          end
          object edTimeLimit: TEdit
            Left = 30
            Height = 21
            Top = 24
            Width = 81
            OnExit = ValidateInput
            TabOrder = 0
          end
          object edSizeLimit: TEdit
            Left = 30
            Height = 21
            Top = 64
            Width = 81
            OnExit = ValidateInput
            TabOrder = 1
          end
          object cbxPagedSearch: TCheckBox
            Left = 238
            Height = 26
            Top = 50
            Width = 114
            Caption = 'Paged search'
            OnClick = cbxPagedSearchClick
            TabOrder = 2
          end
          object edPageSize: TEdit
            Left = 238
            Height = 21
            Top = 104
            Width = 81
            OnExit = ValidateInput
            TabOrder = 3
          end
          object cbDerefAliases: TComboBox
            Left = 30
            Height = 23
            Top = 104
            Width = 161
            Anchors = [akTop, akLeft, akRight]
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
          Left = 1
          Height = 91
          Top = 181
          Width = 409
          Caption = 'Refferals'
          ClientHeight = 60
          ClientWidth = 405
          TabOrder = 1
          object Label10: TLabel
            Left = 30
            Height = 15
            Top = 10
            Width = 101
            Caption = 'Chase referrals:'
            ParentColor = False
          end
          object Label11: TLabel
            Left = 246
            Height = 15
            Top = 10
            Width = 87
            Caption = 'Referral hops:'
            ParentColor = False
          end
          object cbReferrals: TComboBox
            Left = 30
            Height = 27
            Top = 24
            Width = 169
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
            Left = 246
            Height = 21
            Top = 24
            Width = 137
            OnExit = ValidateInput
            TabOrder = 1
          end
        end
      end
      object TabSheet3: TTabSheet
        Caption = '&Attributes'
        ClientHeight = 297
        ClientWidth = 410
        ImageIndex = 2
        object cbxShowAttrs: TCheckBox
          Left = 16
          Height = 26
          Top = 16
          Width = 208
          Caption = '&Show operational attributes:'
          OnClick = cbxShowAttrsClick
          TabOrder = 0
        end
        object lbxAttributes: TListBox
          Left = 16
          Height = 217
          Top = 40
          Width = 305
          Color = clBtnFace
          Enabled = False
          ItemHeight = 0
          ScrollWidth = 301
          TabOrder = 1
          TopIndex = -1
        end
        object btnAdd: TButton
          Left = 336
          Height = 25
          Top = 40
          Width = 75
          Caption = '&Add'
          Enabled = False
          OnClick = btnAddClick
          TabOrder = 2
        end
        object btnRemove: TButton
          Left = 336
          Height = 25
          Top = 72
          Width = 75
          Caption = '&Remove'
          Enabled = False
          OnClick = btnRemoveClick
          TabOrder = 3
        end
      end
    end
  end
  object Panel1: TPanel
    Left = 8
    Height = 34
    Top = 8
    Width = 418
    Align = alTop
    BevelOuter = bvNone
    ClientHeight = 34
    ClientWidth = 418
    TabOrder = 1
    object Label1: TLabel
      Left = 0
      Height = 15
      Top = 4
      Width = 117
      Caption = 'Connection name:'
      ParentColor = False
    end
    object NameEd: TEdit
      Left = 91
      Height = 21
      Top = 0
      Width = 323
      Anchors = [akTop, akLeft, akRight]
      TabOrder = 0
    end
  end
  object ButtonsPnl: TPanel
    Left = 8
    Height = 33
    Top = 376
    Width = 418
    Align = alBottom
    BevelOuter = bvNone
    ClientHeight = 33
    ClientWidth = 418
    TabOrder = 2
    object OKBtn: TButton
      Left = 260
      Height = 25
      Top = 6
      Width = 75
      Anchors = [akRight, akBottom]
      Caption = 'OK'
      Default = True
      ModalResult = 1
      TabOrder = 1
    end
    object CancelBtn: TButton
      Left = 340
      Height = 25
      Top = 6
      Width = 75
      Anchors = [akRight, akBottom]
      Cancel = True
      Caption = '&Cancel'
      ModalResult = 2
      TabOrder = 2
    end
    object TestBtn: TButton
      Left = 0
      Height = 25
      Top = 6
      Width = 119
      Anchors = [akLeft, akBottom]
      Caption = 'Test connection'
      OnClick = TestBtnClick
      TabOrder = 0
    end
  end
end
