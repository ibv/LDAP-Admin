object DBLoadDlg: TDBLoadDlg
  Left = 688
  Height = 124
  Top = 179
  Width = 441
  BorderStyle = bsDialog
  ClientHeight = 124
  ClientWidth = 441
  Color = clBtnFace
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  FormStyle = fsStayOnTop
  Position = poScreenCenter
  LCLVersion = '1.6.0.4'
  object Message: TLabel
    Left = 16
    Height = 13
    Top = 24
    Width = 51
    Caption = 'Message'
    ParentColor = False
  end
  object PathLabel: TLabel
    Left = 16
    Height = 13
    Top = 40
    Width = 417
    AutoSize = False
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentColor = False
    ParentFont = False
  end
  object CancelBtn: TButton
    Left = 356
    Height = 25
    Top = 89
    Width = 75
    Cancel = True
    Caption = '&Cancel'
    ModalResult = 2
    OnClick = CancelBtnClick
    TabOrder = 0
  end
  object ProgressBar: TProgressBar
    Left = 16
    Height = 16
    Top = 59
    Width = 417
    Step = 1
    TabOrder = 1
  end
end
