object PickAttributesDlg: TPickAttributesDlg
  Left = 420
  Height = 376
  Top = 207
  Width = 409
  BorderStyle = bsDialog
  Caption = 'Select attributes'
  ClientHeight = 376
  ClientWidth = 409
  Color = clBtnFace
  OnClose = FormClose
  ParentFont = True
  Position = poScreenCenter
  LCLVersion = '1.6.0.4'
  object SrcLabel: TLabel
    Left = 8
    Height = 16
    Top = 8
    Width = 145
    AutoSize = False
    Caption = 'Available:'
    ParentColor = False
  end
  object DstLabel: TLabel
    Left = 224
    Height = 16
    Top = 8
    Width = 145
    AutoSize = False
    Caption = 'Use:'
    ParentColor = False
  end
  object IncludeBtn: TSpeedButton
    Left = 190
    Height = 24
    Top = 32
    Width = 30
    Caption = '>'
    OnClick = IncludeBtnClick
  end
  object IncAllBtn: TSpeedButton
    Left = 190
    Height = 24
    Top = 64
    Width = 30
    Caption = '>>'
    OnClick = IncAllBtnClick
  end
  object ExcludeBtn: TSpeedButton
    Left = 190
    Height = 24
    Top = 96
    Width = 30
    Caption = '<'
    Enabled = False
    OnClick = ExcludeBtnClick
  end
  object ExAllBtn: TSpeedButton
    Left = 190
    Height = 24
    Top = 128
    Width = 30
    Caption = '<<'
    Enabled = False
    OnClick = ExcAllBtnClick
  end
  object OKBtn: TButton
    Left = 127
    Height = 25
    Top = 340
    Width = 75
    Anchors = [akRight, akBottom]
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 0
  end
  object CancelBtn: TButton
    Left = 207
    Height = 25
    Top = 340
    Width = 75
    Anchors = [akRight, akBottom]
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 1
  end
  object SrcList: TListBox
    Left = 8
    Height = 281
    Top = 24
    Width = 177
    ItemHeight = 0
    MultiSelect = True
    ScrollWidth = 173
    Sorted = True
    TabOrder = 2
    TopIndex = -1
  end
  object DstList: TListBox
    Left = 224
    Height = 281
    Top = 24
    Width = 177
    ItemHeight = 0
    MultiSelect = True
    ScrollWidth = 173
    TabOrder = 3
    TopIndex = -1
  end
end
