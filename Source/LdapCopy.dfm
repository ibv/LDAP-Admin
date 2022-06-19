object CopyDlg: TCopyDlg
  Left = 379
  Height = 359
  Top = 256
  Width = 395
  ClientHeight = 359
  ClientWidth = 395
  Color = clBtnFace
  OnDestroy = FormDestroy
  OnResize = FormResize
  ParentFont = True
  Position = poMainFormCenter
  LCLVersion = '2.2.2.0'
  object Panel1: TPanel
    Left = 0
    Height = 41
    Top = 318
    Width = 395
    Align = alBottom
    BevelOuter = bvNone
    ClientHeight = 41
    ClientWidth = 395
    TabOrder = 1
    object OKBtn: TButton
      Left = 226
      Height = 25
      Top = 2
      Width = 75
      Anchors = []
      Caption = 'OK'
      Default = True
      ModalResult = 1
      TabOrder = 0
    end
    object CancelBtn: TButton
      Left = 307
      Height = 25
      Top = 2
      Width = 75
      Anchors = []
      Cancel = True
      Caption = 'Cancel'
      ModalResult = 2
      TabOrder = 1
    end
  end
  object Panel2: TPanel
    Left = 386
    Height = 318
    Top = 0
    Width = 9
    Align = alRight
    BevelOuter = bvNone
    TabOrder = 2
  end
  object Panel3: TPanel
    Left = 0
    Height = 318
    Top = 0
    Width = 386
    Align = alClient
    BevelOuter = bvNone
    ClientHeight = 318
    ClientWidth = 386
    TabOrder = 0
    object Label1: TLabel
      Left = 6
      Height = 15
      Top = 10
      Width = 82
      Caption = 'Target server:'
      ParentColor = False
    end
    object Label2: TLabel
      Left = 6
      Height = 15
      Top = 34
      Width = 76
      Caption = 'Entry Name:'
      ParentColor = False
    end
    object TreeView: TTreeView
      Left = 5
      Height = 225
      Top = 57
      Width = 377
      ExpandSignType = tvestPlusMinus
      Indent = 19
      ReadOnly = True
      ScrollBars = ssAutoBoth
      TabOrder = 1
      OnClick = edNameChange
      OnDeletion = TreeViewDeletion
      OnExpanding = TreeViewExpanding
      Options = [tvoAutoItemHeight, tvoHideSelection, tvoKeepCollapsedNodes, tvoReadOnly, tvoShowButtons, tvoShowLines, tvoShowRoot, tvoToolTips, tvoThemedDraw]
    end
    object edName: TEdit
      Left = 95
      Height = 26
      Top = 31
      Width = 287
      HideSelection = False
      OnChange = edNameChange
      TabOrder = 0
    end
  end
end
