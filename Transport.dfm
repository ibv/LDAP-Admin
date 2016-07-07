object TransportDlg: TTransportDlg
  Left = 464
  Top = 248
  BorderStyle = bsDialog
  Caption = 'Create Transport Table'
  ClientHeight = 214
  ClientWidth = 313
  Color = clBtnFace
  ParentFont = True
  OldCreateOrder = True
  Position = poScreenCenter
  OnClose = FormClose
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Bevel1: TBevel
    Left = 8
    Top = 8
    Width = 297
    Height = 161
    Shape = bsFrame
  end
  object Label1: TLabel
    Left = 24
    Top = 32
    Width = 34
    Height = 13
    Caption = '&Server:'
  end
  object Label2: TLabel
    Left = 24
    Top = 88
    Width = 48
    Height = 13
    Caption = '&Transport:'
  end
  object OKBtn: TButton
    Left = 79
    Top = 180
    Width = 75
    Height = 25
    Caption = '&OK'
    Default = True
    Enabled = False
    ModalResult = 1
    TabOrder = 2
  end
  object CancelBtn: TButton
    Left = 159
    Top = 180
    Width = 75
    Height = 25
    Cancel = True
    Caption = '&Cancel'
    ModalResult = 2
    TabOrder = 3
  end
  object cn: TEdit
    Left = 24
    Top = 48
    Width = 265
    Height = 21
    TabOrder = 0
    OnChange = AttributeChange
  end
  object transport: TEdit
    Left = 24
    Top = 104
    Width = 265
    Height = 21
    TabOrder = 1
    Text = 'smtp:[]'
    OnChange = AttributeChange
  end
end
