object OuDlg: TOuDlg
  Left = 417
  Top = 158
  BorderStyle = bsDialog
  Caption = 'Create Organizational Unit'
  ClientHeight = 407
  ClientWidth = 358
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnClose = FormClose
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object NameLabel: TLabel
    Left = 16
    Top = 16
    Width = 31
    Height = 13
    Caption = '&Name:'
  end
  object ou: TEdit
    Left = 16
    Top = 32
    Width = 329
    Height = 21
    TabOrder = 0
  end
  object GroupBox1: TGroupBox
    Left = 16
    Top = 64
    Width = 329
    Height = 289
    TabOrder = 1
    object Label18: TLabel
      Left = 16
      Top = 80
      Width = 31
      Height = 13
      Caption = '&Street:'
    end
    object Label19: TLabel
      Left = 16
      Top = 224
      Width = 75
      Height = 13
      Caption = 'State/&Province:'
    end
    object Label24: TLabel
      Left = 232
      Top = 224
      Width = 46
      Height = 13
      Caption = '&Zip Code:'
    end
    object Label31: TLabel
      Left = 16
      Top = 176
      Width = 20
      Height = 13
      Caption = '&City:'
    end
    object Label1: TLabel
      Left = 16
      Top = 24
      Width = 56
      Height = 13
      Caption = '&Description:'
    end
    object postalAddress: TMemo
      Left = 16
      Top = 96
      Width = 297
      Height = 73
      TabOrder = 1
    end
    object st: TEdit
      Left = 16
      Top = 240
      Width = 209
      Height = 21
      TabOrder = 3
    end
    object postalCode: TEdit
      Left = 232
      Top = 240
      Width = 81
      Height = 21
      TabOrder = 4
    end
    object l: TEdit
      Left = 16
      Top = 192
      Width = 297
      Height = 21
      TabOrder = 2
    end
    object description: TEdit
      Left = 16
      Top = 40
      Width = 297
      Height = 21
      TabOrder = 0
    end
  end
  object OKBtn: TButton
    Left = 104
    Top = 368
    Width = 75
    Height = 25
    Caption = '&OK'
    Default = True
    ModalResult = 1
    TabOrder = 2
  end
  object CancelBtn: TButton
    Left = 184
    Top = 368
    Width = 75
    Height = 25
    Cancel = True
    Caption = '&Cancel'
    ModalResult = 2
    TabOrder = 3
  end
end
