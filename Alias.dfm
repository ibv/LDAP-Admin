object AliasDlg: TAliasDlg
  Left = 571
  Height = 353
  Top = 303
  Width = 585
  BorderStyle = bsDialog
  Caption = 'Alias'
  ClientHeight = 353
  ClientWidth = 585
  Color = clBtnFace
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  OnClose = FormClose
  OnDestroy = FormDestroy
  Position = poScreenCenter
  LCLVersion = '1.6.0.4'
  object Button1: TButton
    Left = 420
    Height = 25
    Top = 323
    Width = 75
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 2
  end
  object Button2: TButton
    Left = 500
    Height = 25
    Top = 323
    Width = 75
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 3
  end
  object GroupBox1: TGroupBox
    Left = 8
    Height = 200
    Top = 112
    Width = 569
    Caption = 'Alias'
    ClientHeight = 171
    ClientWidth = 565
    TabOrder = 1
    object Label1: TLabel
      Left = 16
      Height = 13
      Top = 2
      Width = 87
      Caption = 'Create alias in:'
      ParentColor = False
    end
    object Label2: TLabel
      Left = 16
      Height = 13
      Top = 72
      Width = 67
      Caption = 'Alias name:'
      ParentColor = False
    end
    object Label4: TLabel
      Left = 16
      Height = 13
      Top = 98
      Width = 49
      Caption = 'Alias dn:'
      ParentColor = False
    end
    object Label5: TLabel
      Left = 176
      Height = 13
      Top = 69
      Width = 9
      Caption = '='
      ParentColor = False
    end
    object edAliasDir: TEdit
      Left = 16
      Height = 19
      Top = 18
      Width = 505
      OnChange = edAliasDNChange
      TabOrder = 0
    end
    object btnAliasDir: TButton
      Left = 530
      Height = 23
      Top = 17
      Width = 24
      Caption = '...'
      OnClick = btnAliasDirClick
      TabOrder = 1
    end
    object edAliasNameValue: TEdit
      Left = 192
      Height = 19
      Top = 66
      Width = 329
      OnChange = edAliasDNChange
      TabOrder = 2
    end
    object edAliasDN: TEdit
      Left = 16
      Height = 19
      Top = 114
      Width = 505
      Enabled = False
      TabOrder = 3
    end
    object cbAliasNameAttr: TComboBox
      Left = 16
      Height = 20
      Top = 66
      Width = 153
      ItemHeight = 0
      OnChange = edAliasDNChange
      Sorted = True
      TabOrder = 4
    end
  end
  object GroupBox2: TGroupBox
    Left = 8
    Height = 89
    Top = 8
    Width = 569
    Caption = 'Object'
    ClientHeight = 60
    ClientWidth = 565
    TabOrder = 0
    object Label3: TLabel
      Left = 16
      Height = 13
      Top = 5
      Width = 51
      Caption = 'Entry dn:'
      ParentColor = False
    end
    object edObjectDN: TEdit
      Left = 16
      Height = 19
      Top = 21
      Width = 505
      OnChange = edObjectDNChange
      TabOrder = 0
    end
    object btnObjDN: TButton
      Left = 530
      Height = 23
      Top = 20
      Width = 24
      Caption = '...'
      OnClick = btnObjDNClick
      TabOrder = 1
    end
  end
end
