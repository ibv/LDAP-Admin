object LocalityDlg: TLocalityDlg
  Left = 260
  Height = 357
  Top = 90
  Width = 358
  BorderStyle = bsDialog
  Caption = 'Create locality'
  ClientHeight = 357
  ClientWidth = 358
  Color = clBtnFace
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  OnClose = FormClose
  OnDestroy = FormDestroy
  Position = poOwnerFormCenter
  LCLVersion = '1.6.0.4'
  object NameLabel: TLabel
    Left = 16
    Height = 13
    Top = 16
    Width = 37
    Caption = '&Name:'
    ParentColor = False
  end
  object l: TEdit
    Left = 16
    Height = 19
    Top = 32
    Width = 329
    TabOrder = 0
  end
  object GroupBox1: TGroupBox
    Left = 16
    Height = 241
    Top = 64
    Width = 329
    ClientHeight = 237
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
      Top = 184
      Width = 86
      Caption = 'State/&Province:'
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
    object street: TMemo
      Left = 16
      Height = 73
      Top = 96
      Width = 297
      TabOrder = 1
    end
    object st: TEdit
      Left = 16
      Height = 19
      Top = 200
      Width = 209
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
    Top = 320
    Width = 75
    Caption = '&OK'
    Default = True
    ModalResult = 1
    TabOrder = 2
  end
  object CancelBtn: TButton
    Left = 184
    Height = 25
    Top = 320
    Width = 75
    Cancel = True
    Caption = '&Cancel'
    ModalResult = 2
    TabOrder = 3
  end
end
