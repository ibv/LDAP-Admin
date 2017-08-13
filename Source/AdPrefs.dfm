object AdPrefDlg: TAdPrefDlg
  Left = 688
  Height = 416
  Top = 198
  Width = 500
  ActiveControl = edCN
  BorderStyle = bsDialog
  Caption = 'Edit preferences'
  ClientHeight = 416
  ClientWidth = 500
  Color = clBtnFace
  OnClose = FormClose
  ParentFont = True
  Position = poMainFormCenter
  LCLVersion = '1.6.2.0'
  object Panel1: TPanel
    Left = 0
    Height = 57
    Top = 359
    Width = 500
    Align = alBottom
    ClientHeight = 57
    ClientWidth = 500
    TabOrder = 0
    object OkBtn: TButton
      Left = 334
      Height = 25
      Top = 17
      Width = 75
      Caption = '&OK'
      Default = True
      ModalResult = 1
      TabOrder = 1
    end
    object CancelBtn: TButton
      Left = 414
      Height = 25
      Top = 17
      Width = 75
      Caption = '&Cancel'
      ModalResult = 2
      TabOrder = 2
    end
    object BtnDefault: TButton
      Left = 8
      Height = 25
      Top = 17
      Width = 121
      Caption = 'Default values'
      OnClick = BtnDefaultClick
      TabOrder = 0
    end
  end
  object gbDefaults: TGroupBox
    Left = 8
    Height = 193
    Top = 8
    Width = 481
    Caption = 'Account:'
    ClientHeight = 162
    ClientWidth = 477
    TabOrder = 1
    object lblUPN: TLabel
      Left = 33
      Height = 15
      Top = 68
      Width = 84
      Alignment = taRightJustify
      Caption = 'Logon name:'
      ParentColor = False
    end
    object lblNTLogon: TLabel
      Left = 17
      Height = 15
      Top = 100
      Width = 101
      Alignment = taRightJustify
      Caption = 'NT logon name:'
      ParentColor = False
    end
    object lblCN: TLabel
      Left = 15
      Height = 15
      Top = 4
      Width = 104
      Alignment = taRightJustify
      Caption = 'Common name:'
      ParentColor = False
    end
    object lblDisplayname: TLabel
      Left = 26
      Height = 15
      Top = 36
      Width = 91
      Alignment = taRightJustify
      Caption = 'Display name:'
      ParentColor = False
    end
    object Label1: TLabel
      Left = 24
      Height = 15
      Top = 133
      Width = 95
      Alignment = taRightJustify
      Caption = 'Domain name:'
      ParentColor = False
    end
    object edUPN: TEdit
      Left = 120
      Height = 21
      Top = 65
      Width = 161
      TabOrder = 2
    end
    object edNTLoginName: TEdit
      Left = 120
      Height = 21
      Top = 97
      Width = 344
      TabOrder = 4
    end
    object edDisplayName: TEdit
      Left = 120
      Height = 21
      Top = 33
      Width = 344
      TabOrder = 1
    end
    object edCN: TEdit
      Left = 120
      Height = 21
      Top = 1
      Width = 344
      TabOrder = 0
    end
    object cbUpnDomain: TComboBox
      Left = 288
      Height = 27
      Top = 65
      Width = 177
      ItemHeight = 0
      Style = csDropDownList
      TabOrder = 3
    end
    object edNTDomain: TEdit
      Left = 120
      Height = 21
      Top = 130
      Width = 344
      TabOrder = 5
    end
  end
  object GroupBox1: TGroupBox
    Left = 8
    Height = 156
    Top = 207
    Width = 481
    Caption = '&Paths:'
    ClientHeight = 125
    ClientWidth = 477
    TabOrder = 2
    object lblScript: TLabel
      Left = 77
      Height = 15
      Top = 65
      Width = 41
      Alignment = taRightJustify
      Caption = 'Script:'
      ParentColor = False
    end
    object lblHomeShare: TLabel
      Left = 36
      Height = 15
      Top = 2
      Width = 83
      Alignment = taRightJustify
      Caption = 'Home share:'
      ParentColor = False
    end
    object lblProfilePath: TLabel
      Left = 43
      Height = 15
      Top = 98
      Width = 76
      Alignment = taRightJustify
      Caption = 'Profile path:'
      ParentColor = False
    end
    object lblHomeDrive: TLabel
      Left = 41
      Height = 15
      Top = 34
      Width = 78
      Alignment = taRightJustify
      Caption = 'Home drive:'
      ParentColor = False
    end
    object edScript: TEdit
      Left = 120
      Height = 21
      Top = 62
      Width = 345
      TabOrder = 2
    end
    object edHomeDir: TEdit
      Left = 120
      Height = 21
      Top = -1
      Width = 344
      TabOrder = 0
    end
    object edProfilePath: TEdit
      Left = 120
      Height = 21
      Top = 95
      Width = 344
      TabOrder = 3
    end
    object cbHomeDrive: TComboBox
      Left = 120
      Height = 23
      Top = 31
      Width = 65
      ItemHeight = 0
      Items.Strings = (
        'C:'
        'D:'
        'E:'
        'F:'
        'G:'
        'H:'
        'I:'
        'J:'
        'K:'
        'L:'
        'M:'
        'N:'
        'O:'
        'P:'
        'Q:'
        'R:'
        'S:'
        'T:'
        'U:'
        'V:'
        'W:'
        'X:'
        'Y:'
        'Z:'
      )
      Style = csDropDownList
      TabOrder = 1
    end
  end
end
