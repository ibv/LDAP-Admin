object AdContainerDlg: TAdContainerDlg
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Create Container'
  ClientHeight = 179
  ClientWidth = 529
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 16
    Top = 26
    Width = 31
    Height = 13
    Caption = 'Name:'
  end
  object Label2: TLabel
    Left = 16
    Top = 72
    Width = 57
    Height = 13
    Caption = 'Description:'
  end
  object cn: TEdit
    Left = 16
    Top = 43
    Width = 497
    Height = 21
    TabOrder = 0
    OnChange = cnChange
  end
  object description: TEdit
    Left = 16
    Top = 89
    Width = 497
    Height = 21
    TabOrder = 1
  end
  object OkBtn: TButton
    Left = 357
    Top = 138
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    Enabled = False
    ModalResult = 1
    TabOrder = 2
  end
  object CancelBtn: TButton
    Left = 438
    Top = 138
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 3
  end
end
