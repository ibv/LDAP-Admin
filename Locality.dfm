object LocalityDlg: TLocalityDlg
  Left = 260
  Top = 90
  BorderStyle = bsDialog
  Caption = 'Create locality'
  ClientHeight = 357
  ClientWidth = 358
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = True
  Position = poOwnerFormCenter
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
  object l: TEdit
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
    Height = 241
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
      Top = 184
      Width = 75
      Height = 13
      Caption = 'State/&Province:'
    end
    object Label1: TLabel
      Left = 16
      Top = 24
      Width = 56
      Height = 13
      Caption = '&Description:'
    end
    object street: TMemo
      Left = 16
      Top = 96
      Width = 297
      Height = 73
      TabOrder = 1
    end
    object st: TEdit
      Left = 16
      Top = 200
      Width = 209
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
    Top = 320
    Width = 75
    Height = 25
    Caption = '&OK'
    Default = True
    ModalResult = 1
    TabOrder = 2
  end
  object CancelBtn: TButton
    Left = 184
    Top = 320
    Width = 75
    Height = 25
    Cancel = True
    Caption = '&Cancel'
    ModalResult = 2
    TabOrder = 3
  end
end
