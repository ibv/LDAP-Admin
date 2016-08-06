object ADPassDlg: TADPassDlg
  Left = 411
  Height = 82
  Top = 220
  Width = 420
  BorderStyle = bsDialog
  Caption = 'Set Password'
  ClientHeight = 82
  ClientWidth = 420
  Color = clBtnFace
  OnCloseQuery = FormCloseQuery
  ParentFont = True
  Position = poScreenCenter
  LCLVersion = '1.6.0.4'
  object Label1: TLabel
    Left = 24
    Height = 15
    Top = 12
    Width = 95
    Caption = '&New password:'
    ParentColor = False
  end
  object Label2: TLabel
    Left = 1
    Height = 15
    Top = 44
    Width = 118
    Caption = '&Confirm password:'
    ParentColor = False
  end
  object Password: TEdit
    Left = 120
    Height = 21
    Top = 8
    Width = 217
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
    TabOrder = 2
  end
  object CancelBtn: TButton
    Left = 339
    Height = 25
    Top = 38
    Width = 75
    Cancel = True
    Caption = '&Cancel'
    ModalResult = 2
    TabOrder = 3
  end
  object Password2: TEdit
    Left = 120
    Height = 21
    Top = 40
    Width = 217
    EchoMode = emPassword
    PasswordChar = '*'
    TabOrder = 1
  end
end
