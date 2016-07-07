object DBLoadDlg: TDBLoadDlg
  Left = 688
  Top = 179
  BorderStyle = bsDialog
  ClientHeight = 124
  ClientWidth = 441
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Message: TLabel
    Left = 16
    Top = 24
    Width = 43
    Height = 13
    Caption = 'Message'
  end
  object PathLabel: TLabel
    Left = 16
    Top = 40
    Width = 417
    Height = 13
    AutoSize = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object CancelBtn: TButton
    Left = 356
    Top = 89
    Width = 75
    Height = 25
    Cancel = True
    Caption = '&Cancel'
    ModalResult = 2
    TabOrder = 0
    OnClick = CancelBtnClick
  end
  object ProgressBar: TProgressBar
    Left = 16
    Top = 59
    Width = 417
    Height = 16
    Step = 1
    TabOrder = 1
  end
end
