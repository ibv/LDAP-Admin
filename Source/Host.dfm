object HostDlg: THostDlg
  Left = 371
  Height = 425
  Top = 202
  Width = 404
  BorderStyle = bsDialog
  Caption = 'Create host'
  ClientHeight = 425
  ClientWidth = 404
  Color = clBtnFace
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  OnClose = FormClose
  OnDestroy = FormDestroy
  Position = poMainFormCenter
  LCLVersion = '1.6.0.4'
  object NameLabel: TLabel
    Left = 16
    Height = 13
    Top = 16
    Width = 66
    Caption = '&Host name:'
    ParentColor = False
  end
  object IPLabel: TLabel
    Left = 16
    Height = 13
    Top = 64
    Width = 65
    Caption = 'IP &Address:'
    ParentColor = False
  end
  object Label2: TLabel
    Left = 16
    Height = 13
    Top = 112
    Width = 68
    Caption = '&Description:'
    ParentColor = False
  end
  object cn: TEdit
    Left = 16
    Height = 19
    Top = 32
    Width = 369
    TabOrder = 0
  end
  object GroupBox1: TGroupBox
    Left = 16
    Height = 225
    Top = 160
    Width = 369
    Caption = ' Additional host &names: '
    ClientHeight = 196
    ClientWidth = 365
    TabOrder = 3
    object cnList: TListBox
      Left = 8
      Height = 145
      Top = 16
      Width = 353
      ItemHeight = 0
      OnClick = cnListClick
      ScrollWidth = 349
      TabOrder = 0
      TopIndex = -1
    end
    object AddHostBtn: TButton
      Left = 8
      Height = 25
      Top = 168
      Width = 65
      Caption = '&Add'
      OnClick = AddHostBtnClick
      TabOrder = 1
    end
    object EditHostBtn: TButton
      Left = 80
      Height = 25
      Top = 168
      Width = 65
      Caption = '&Edit'
      Enabled = False
      OnClick = EditHostBtnClick
      TabOrder = 2
    end
    object DelHostBtn: TButton
      Left = 152
      Height = 25
      Top = 168
      Width = 65
      Caption = '&Remove'
      Enabled = False
      OnClick = DelHostBtnClick
      TabOrder = 3
    end
  end
  object OKBtn: TButton
    Left = 136
    Height = 25
    Top = 396
    Width = 75
    Caption = '&OK'
    Default = True
    ModalResult = 1
    TabOrder = 4
  end
  object CancelBtn: TButton
    Left = 216
    Height = 25
    Top = 396
    Width = 75
    Cancel = True
    Caption = '&Cancel'
    ModalResult = 2
    TabOrder = 5
  end
  object ipHostNumber: TEdit
    Left = 16
    Height = 19
    Top = 80
    Width = 369
    OnChange = EditChange
    TabOrder = 1
  end
  object description: TEdit
    Left = 16
    Height = 19
    Top = 128
    Width = 369
    OnChange = EditChange
    TabOrder = 2
  end
end
