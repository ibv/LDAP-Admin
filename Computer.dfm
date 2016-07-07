object ComputerDlg: TComputerDlg
  Left = 385
  Top = 204
  ActiveControl = edComputername
  BorderStyle = bsDialog
  Caption = 'Create computer account'
  ClientHeight = 251
  ClientWidth = 313
  Color = clBtnFace
  ParentFont = True
  OldCreateOrder = True
  Position = poMainFormCenter
  OnClose = FormClose
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Bevel1: TBevel
    Left = 8
    Top = 8
    Width = 297
    Height = 185
    Shape = bsFrame
  end
  object Label1: TLabel
    Left = 24
    Top = 32
    Width = 265
    Height = 13
    Caption = '&Computername:'
  end
  object Label2: TLabel
    Left = 24
    Top = 128
    Width = 265
    Height = 13
    Caption = 'D&escription'
  end
  object Label3: TLabel
    Left = 24
    Top = 80
    Width = 265
    Height = 13
    Caption = '&Domain:'
  end
  object OKBtn: TButton
    Left = 79
    Top = 212
    Width = 75
    Height = 25
    Caption = '&OK'
    Default = True
    Enabled = False
    ModalResult = 1
    TabOrder = 3
  end
  object CancelBtn: TButton
    Left = 159
    Top = 212
    Width = 75
    Height = 25
    Cancel = True
    Caption = '&Cancel'
    ModalResult = 2
    TabOrder = 4
  end
  object edComputername: TEdit
    Left = 24
    Top = 48
    Width = 265
    Height = 21
    MaxLength = 15
    TabOrder = 0
    OnChange = edComputernameChange
  end
  object edDescription: TEdit
    Left = 24
    Top = 144
    Width = 265
    Height = 21
    TabOrder = 2
  end
  object cbDomain: TComboBox
    Left = 24
    Top = 96
    Width = 265
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 1
  end
end
