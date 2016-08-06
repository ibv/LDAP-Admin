object ComputerDlg: TComputerDlg
  Left = 385
  Height = 251
  Top = 204
  Width = 313
  ActiveControl = edComputername
  BorderStyle = bsDialog
  Caption = 'Create computer account'
  ClientHeight = 251
  ClientWidth = 313
  Color = clBtnFace
  OnClose = FormClose
  OnDestroy = FormDestroy
  ParentFont = True
  Position = poMainFormCenter
  LCLVersion = '1.6.0.4'
  object Bevel1: TBevel
    Left = 8
    Height = 185
    Top = 8
    Width = 297
    Shape = bsFrame
  end
  object Label1: TLabel
    Left = 24
    Height = 15
    Top = 32
    Width = 105
    Caption = '&Computername:'
    ParentColor = False
  end
  object Label2: TLabel
    Left = 24
    Height = 15
    Top = 128
    Width = 72
    Caption = 'D&escription'
    ParentColor = False
  end
  object Label3: TLabel
    Left = 24
    Height = 15
    Top = 80
    Width = 54
    Caption = '&Domain:'
    ParentColor = False
  end
  object OKBtn: TButton
    Left = 79
    Height = 25
    Top = 212
    Width = 75
    Caption = '&OK'
    Default = True
    Enabled = False
    ModalResult = 1
    TabOrder = 3
  end
  object CancelBtn: TButton
    Left = 159
    Height = 25
    Top = 212
    Width = 75
    Cancel = True
    Caption = '&Cancel'
    ModalResult = 2
    TabOrder = 4
  end
  object edComputername: TEdit
    Left = 24
    Height = 21
    Top = 48
    Width = 265
    MaxLength = 15
    OnChange = edComputernameChange
    TabOrder = 0
  end
  object edDescription: TEdit
    Left = 24
    Height = 21
    Top = 144
    Width = 265
    TabOrder = 2
  end
  object cbDomain: TComboBox
    Left = 24
    Height = 27
    Top = 96
    Width = 265
    ItemHeight = 0
    Style = csDropDownList
    TabOrder = 1
  end
end
