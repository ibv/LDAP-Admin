object InputDlg: TInputDlg
  Left = 410
  Height = 108
  Top = 260
  Width = 313
  ActiveControl = Edit
  BorderStyle = bsDialog
  Caption = 'Dialog'
  ClientHeight = 108
  ClientWidth = 313
  Color = clBtnFace
  ParentFont = True
  Position = poOwnerFormCenter
  LCLVersion = '1.6.0.4'
  object Prompt: TLabel
    Left = 16
    Height = 1
    Top = 16
    Width = 1
    ParentColor = False
  end
  object OKBtn: TButton
    Left = 79
    Height = 25
    Top = 68
    Width = 75
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 0
  end
  object CancelBtn: TButton
    Left = 159
    Height = 25
    Top = 68
    Width = 75
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 1
  end
  object Edit: TEdit
    Left = 16
    Height = 21
    Top = 32
    Width = 281
    OnChange = EditChange
    TabOrder = 2
  end
end
