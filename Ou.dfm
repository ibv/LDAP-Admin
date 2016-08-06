object OuDlg: TOuDlg
  Left = 417
  Height = 407
  Top = 158
  Width = 358
  BorderStyle = bsDialog
  Caption = 'Create Organizational Unit'
  ClientHeight = 407
  ClientWidth = 358
  Color = clBtnFace
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  OnClose = FormClose
  OnDestroy = FormDestroy
  Position = poMainFormCenter
  LCLVersion = '1.6.0.4'
  object NameLabel: TLabel
    Left = 16
    Height = 13
    Top = 16
    Width = 37
    Caption = '&Name:'
    ParentColor = False
  end
  object ou: TEdit
    Left = 16
    Height = 19
    Top = 32
    Width = 329
    TabOrder = 0
  end
  object GroupBox1: TGroupBox
    Left = 16
    Height = 289
    Top = 64
    Width = 329
    ClientHeight = 285
    ClientWidth = 325
    TabOrder = 1
    object Label18: TLabel
      Left = 16
      Height = 13
      Top = 80
      Width = 39
      Caption = '&Street:'
      ParentColor = False
    end
    object Label19: TLabel
      Left = 16
      Height = 13
      Top = 224
      Width = 86
      Caption = 'State/&Province:'
      ParentColor = False
    end
    object Label24: TLabel
      Left = 232
      Height = 13
      Top = 224
      Width = 56
      Caption = '&Zip Code:'
      ParentColor = False
    end
    object Label31: TLabel
      Left = 16
      Height = 13
      Top = 176
      Width = 24
      Caption = '&City:'
      ParentColor = False
    end
    object Label1: TLabel
      Left = 16
      Height = 13
      Top = 24
      Width = 68
      Caption = '&Description:'
      ParentColor = False
    end
    object postalAddress: TMemo
      Left = 16
      Height = 73
      Top = 96
      Width = 297
      TabOrder = 1
    end
    object st: TEdit
      Left = 16
      Height = 19
      Top = 240
      Width = 209
      TabOrder = 3
    end
    object postalCode: TEdit
      Left = 232
      Height = 19
      Top = 240
      Width = 81
      TabOrder = 4
    end
    object l: TEdit
      Left = 16
      Height = 19
      Top = 192
      Width = 297
      TabOrder = 2
    end
    object description: TEdit
      Left = 16
      Height = 19
      Top = 40
      Width = 297
      TabOrder = 0
    end
  end
  object OKBtn: TButton
    Left = 104
    Height = 25
    Top = 368
    Width = 75
    Caption = '&OK'
    Default = True
    ModalResult = 1
    TabOrder = 2
  end
  object CancelBtn: TButton
    Left = 184
    Height = 25
    Top = 368
    Width = 75
    Cancel = True
    Caption = '&Cancel'
    ModalResult = 2
    TabOrder = 3
  end
end
