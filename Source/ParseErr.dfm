object ParseErrDlg: TParseErrDlg
  Left = 508
  Height = 385
  Top = 266
  Width = 547
  ActiveControl = SrcMemo
  Caption = 'Parse error'
  ClientHeight = 385
  ClientWidth = 547
  Color = clBtnFace
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  OnActivate = FormActivate
  OnClose = FormClose
  LCLVersion = '1.6.0.4'
  object Bevel1: TBevel
    Left = 8
    Height = 57
    Top = 8
    Width = 521
    Anchors = [akTop, akLeft, akRight]
  end
  object TLabel
    Left = 16
    Height = 1
    Top = 16
    Width = 1
    ParentColor = False
  end
  object Label2: TLabel
    Left = 56
    Height = 25
    Top = 32
    Width = 466
    Anchors = [akTop, akLeft, akRight]
    AutoSize = False
    ParentColor = False
    WordWrap = True
  end
  object Image1: TImage
    Left = 16
    Height = 33
    Top = 20
    Width = 33
  end
  object Label1: TLabel
    Left = 56
    Height = 13
    Top = 16
    Width = 465
    AutoSize = False
    ParentColor = False
  end
  object btnClose: TButton
    Left = 454
    Height = 25
    Top = 318
    Width = 75
    Anchors = [akRight, akBottom]
    Caption = '&Close'
    ModalResult = 2
    TabOrder = 0
  end
  object SrcMemo: TMemo
    Left = 8
    Height = 233
    Top = 72
    Width = 521
    Anchors = [akTop, akLeft, akRight, akBottom]
    ReadOnly = True
    ScrollBars = ssAutoVertical
    TabOrder = 1
    WordWrap = False
  end
end
