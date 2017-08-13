object TransportDlg: TTransportDlg
  Left = 464
  Height = 214
  Top = 248
  Width = 313
  BorderStyle = bsDialog
  Caption = 'Create Transport Table'
  ClientHeight = 214
  ClientWidth = 313
  Color = clBtnFace
  OnClose = FormClose
  OnDestroy = FormDestroy
  ParentFont = True
  Position = poScreenCenter
  LCLVersion = '1.6.0.4'
  object Bevel1: TBevel
    Left = 8
    Height = 161
    Top = 8
    Width = 297
    Shape = bsFrame
  end
  object Label1: TLabel
    Left = 24
    Height = 15
    Top = 32
    Width = 46
    Caption = '&Server:'
    ParentColor = False
  end
  object Label2: TLabel
    Left = 24
    Height = 15
    Top = 88
    Width = 63
    Caption = '&Transport:'
    ParentColor = False
  end
  object OKBtn: TButton
    Left = 79
    Height = 25
    Top = 180
    Width = 75
    Caption = '&OK'
    Default = True
    Enabled = False
    ModalResult = 1
    TabOrder = 2
  end
  object CancelBtn: TButton
    Left = 159
    Height = 25
    Top = 180
    Width = 75
    Cancel = True
    Caption = '&Cancel'
    ModalResult = 2
    TabOrder = 3
  end
  object cn: TEdit
    Left = 24
    Height = 21
    Top = 48
    Width = 265
    OnChange = AttributeChange
    TabOrder = 0
  end
  object transport: TEdit
    Left = 24
    Height = 21
    Top = 104
    Width = 265
    OnChange = AttributeChange
    TabOrder = 1
    Text = 'smtp:[]'
  end
end
