object PasswordDlg: TPasswordDlg
  Left = 411
  Height = 124
  Top = 220
  Width = 420
  BorderStyle = bsDialog
  Caption = 'Set Password'
  ClientHeight = 124
  ClientWidth = 420
  Color = clBtnFace
  OnCloseQuery = FormCloseQuery
  ParentFont = True
  Position = poScreenCenter
  LCLVersion = '1.6.0.4'
  object Label1: TLabel
    Left = 35
    Height = 15
    Top = 12
    Width = 95
    Caption = '&New password:'
    ParentColor = False
  end
  object Label2: TLabel
    Left = 12
    Height = 15
    Top = 44
    Width = 118
    Caption = '&Confirm password:'
    ParentColor = False
  end
  object lbMethod: TLabel
    Left = 5
    Height = 15
    Top = 76
    Width = 125
    Caption = 'Encryption method:'
    ParentColor = False
  end
  object Password: TEdit
    Left = 129
    Height = 21
    Top = 8
    Width = 209
    EchoMode = emPassword
    PasswordChar = '*'
    TabOrder = 0
  end
  object OKBtn: TButton
    Left = 339
    Height = 25
    Top = 7
    Width = 75
    Caption = '&OK'
    Default = True
    ModalResult = 1
    TabOrder = 5
  end
  object CancelBtn: TButton
    Left = 339
    Height = 25
    Top = 39
    Width = 75
    Cancel = True
    Caption = '&Cancel'
    ModalResult = 2
    TabOrder = 6
  end
  object Password2: TEdit
    Left = 129
    Height = 21
    Top = 40
    Width = 209
    EchoMode = emPassword
    PasswordChar = '*'
    TabOrder = 1
  end
  object cbMethod: TComboBox
    Left = 133
    Height = 27
    Top = 72
    Width = 129
    DropDownCount = 12
    ItemHeight = 0
    Items.Strings = (
      'Plain text'
      'Unix Crypt'
      'MD5 Crypt'
      'MD4'
      'MD5'
      'SHA1'
      'SMD5'
      'SSHA'
      'SHA-256 Crypt'
      'SHA-512 Crypt'
      'RIPEMD-160'
    )
    Style = csDropDownList
    TabOrder = 2
  end
  object cbSambaPassword: TCheckBox
    Left = 268
    Height = 26
    Top = 96
    Width = 138
    Caption = '&Samba password'
    Checked = True
    State = cbChecked
    TabOrder = 4
    Visible = False
  end
  object cbPosixPassword: TCheckBox
    Left = 268
    Height = 26
    Top = 72
    Width = 125
    Caption = '&Posix password'
    Checked = True
    OnClick = cbPosixPasswordClick
    State = cbChecked
    TabOrder = 3
    Visible = False
  end
end
