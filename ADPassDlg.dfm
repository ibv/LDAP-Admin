object ADPassDlg: TADPassDlg
  Left = 411
  Top = 220
  BorderStyle = bsDialog
  Caption = 'Set Password'
  ClientHeight = 82
  ClientWidth = 420
  Color = clBtnFace
  ParentFont = True
  OldCreateOrder = True
  Position = poScreenCenter
  OnCloseQuery = FormCloseQuery
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 12
    Width = 73
    Height = 13
    Caption = '&New password:'
  end
  object Label2: TLabel
    Left = 8
    Top = 44
    Width = 86
    Height = 13
    Caption = '&Confirm password:'
  end
  object Password: TEdit
    Left = 104
    Top = 8
    Width = 217
    Height = 21
    PasswordChar = '*'
    TabOrder = 0
  end
  object OKBtn: TButton
    Left = 334
    Top = 7
    Width = 75
    Height = 25
    Caption = '&OK'
    Default = True
    ModalResult = 1
    TabOrder = 2
  end
  object CancelBtn: TButton
    Left = 334
    Top = 39
    Width = 75
    Height = 25
    Cancel = True
    Caption = '&Cancel'
    ModalResult = 2
    TabOrder = 3
  end
  object Password2: TEdit
    Left = 104
    Top = 40
    Width = 217
    Height = 21
    PasswordChar = '*'
    TabOrder = 1
  end
end
