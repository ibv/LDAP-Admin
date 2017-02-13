object ADPassDlg: TADPassDlg
  Left = 411
  Height = 142
  Top = 220
  Width = 420
  BorderStyle = bsDialog
  Caption = 'Set Password'
  ClientHeight = 142
  ClientWidth = 420
  Color = clBtnFace
  OnCloseQuery = FormCloseQuery
  ParentFont = True
  Position = poScreenCenter
  Visible = False
  object Label1: TLabel
    Left = 8
    Height = 15
    Top = 12
    Width = 95
    Caption = '&New password:'
    ParentColor = False
  end
  object Label2: TLabel
    Left = 8
    Height = 15
    Top = 44
    Width = 118
    Caption = '&Confirm password:'
    ParentColor = False
  end
  object Password: TEdit
    Left = 104
    Height = 21
    Top = 8
    Width = 217
    EchoMode = emPassword
    PasswordChar = '*'
    TabOrder = 0
  end
  object OKBtn: TButton
    Left = 334
    Height = 25
    Top = 7
    Width = 75
    Caption = '&OK'
    Default = True
    ModalResult = 1
    TabOrder = 2
  end
  object CancelBtn: TButton
    Left = 334
    Height = 25
    Top = 39
    Width = 75
    Cancel = True
    Caption = '&Cancel'
    ModalResult = 2
    TabOrder = 3
  end
  object Password2: TEdit
    Left = 104
    Height = 21
    Top = 40
    Width = 217
    EchoMode = emPassword
    PasswordChar = '*'
    TabOrder = 1
  end
  object cbxPwdNeverExpires: TCheckBox
    Left = 104
    Height = 26
    Top = 67
    Width = 177
    Caption = 'Password never expires'
    TabOrder = 4
  end
  object cbxPwdMustChange: TCheckBox
    Left = 104
    Height = 26
    Top = 90
    Width = 296
    Caption = 'User must change password on next login'
    TabOrder = 5
  end
end
