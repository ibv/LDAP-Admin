object PrefWizDlg: TPrefWizDlg
  Left = 405
  Height = 306
  Top = 278
  Width = 467
  BorderStyle = bsDialog
  Caption = 'Profile Wizard'
  ClientHeight = 306
  ClientWidth = 467
  Color = clBtnFace
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  OnClose = FormClose
  OnCreate = FormCreate
  Position = poMainFormCenter
  LCLVersion = '1.6.0.4'
  object Panel1: TPanel
    Left = 0
    Height = 50
    Top = 256
    Width = 467
    Align = alBottom
    BevelOuter = bvNone
    ClientHeight = 50
    ClientWidth = 467
    TabOrder = 4
    object Bevel3: TBevel
      Left = 0
      Height = 25
      Top = 0
      Width = 467
      Align = alTop
      Shape = bsTopLine
    end
  end
  object Notebook: TNotebook
    Left = 0
    Height = 256
    Top = 0
    Width = 467
    PageIndex = 0
    Align = alClient
    TabOrder = 0
    TabStop = True
    object page1: TPage
      object Label1: TLabel
        Left = 16
        Height = 13
        Top = 224
        Width = 152
        Caption = 'Click on Next to continue...'
        ParentColor = False
      end
      object Panel2: TPanel
        Left = 0
        Height = 65
        Top = 0
        Width = 467
        Align = alTop
        BevelOuter = bvNone
        ClientHeight = 65
        ClientWidth = 467
        Color = clWindow
        ParentColor = False
        TabOrder = 0
        object Label2: TLabel
          Left = 16
          Height = 13
          Top = 24
          Width = 441
          Caption = 'This wizard helps you to create default preference profile for this connection.'
          ParentColor = False
          WordWrap = True
        end
        object Bevel4: TBevel
          Left = 0
          Height = 25
          Top = 40
          Width = 467
          Align = alBottom
          Shape = bsBottomLine
        end
      end
    end
    object page2: TPage
      object ListView1: TListView
        Left = 16
        Height = 161
        Top = 80
        Width = 433
        Columns = <        
          item
            Caption = 'Type'
            Width = 200
          end        
          item
            Caption = 'Example'
            Width = 70
          end        
          item
            Caption = 'Setting'
            Width = 159
          end>
        Items.LazData = {
          A00100000600000000000000FFFFFFFFFFFFFFFF020000001500000046697273
          74206E616D65202E4C617374206E616D65080000006A6F686E2E646F65050000
          0025662E256C00000000FFFFFFFFFFFFFFFF02000000140000004C617374206E
          616D652E4669727374206E616D6508000000646F652E6A6F686E05000000256C
          2E256600000000FFFFFFFFFFFFFFFF0200000027000000496E697469616C206C
          6574746572206F66206669727374206E616D652C204C617374206E616D650400
          00006A646F65040000002546256C00000000FFFFFFFFFFFFFFFF020000002700
          0000496E697469616C206C6574746572206F66206C617374206E616D652C2046
          69727374206E616D6505000000646A6F686E04000000254C256600000000FFFF
          FFFFFFFFFFFF02000000090000004C617374206E616D6503000000646F650200
          0000256C00000000FFFFFFFFFFFFFFFF020000000A0000004669727374206E61
          6D65040000006A6F686E020000002566FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        }
        ScrollBars = ssAutoBoth
        TabOrder = 0
        ViewStyle = vsReport
      end
      object Panel3: TPanel
        Left = 0
        Height = 65
        Top = 0
        Width = 467
        Align = alTop
        BevelOuter = bvNone
        ClientHeight = 65
        ClientWidth = 467
        Color = clWindow
        ParentColor = False
        TabOrder = 1
        object Bevel5: TBevel
          Left = 0
          Height = 25
          Top = 40
          Width = 467
          Align = alBottom
          Shape = bsBottomLine
        end
        object Label3: TLabel
          Left = 16
          Height = 13
          Top = 24
          Width = 171
          Caption = 'Choose format for username:'
          ParentColor = False
        end
      end
    end
    object page3: TPage
      object ListView2: TListView
        Left = 16
        Height = 161
        Top = 80
        Width = 433
        Columns = <        
          item
            Caption = 'Type'
            Width = 200
          end        
          item
            Caption = 'Example'
            Width = 70
          end        
          item
            Caption = 'Setting'
            Width = 159
          end>
        Items.LazData = {
          EF0000000300000000000000FFFFFFFFFFFFFFFF02000000150000004C617374
          206E616D652C204669727374206E616D6509000000446F652C204A6F686E0600
          0000256C2C20256600000000FFFFFFFFFFFFFFFF020000001500000046697273
          74206E616D652C204C617374206E616D65090000004A6F686E2C20446F650600
          000025662C20256C00000000FFFFFFFFFFFFFFFF0200000027000000496E6974
          69616C206C6574746572206F66206669727374206E616D652C204C617374206E
          616D65060000004A2E20446F650600000025462E20256CFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        }
        ScrollBars = ssAutoBoth
        TabOrder = 0
        ViewStyle = vsReport
      end
      object Panel4: TPanel
        Left = 0
        Height = 65
        Top = 0
        Width = 467
        Align = alTop
        BevelOuter = bvNone
        ClientHeight = 65
        ClientWidth = 467
        Color = clWindow
        ParentColor = False
        TabOrder = 1
        object Bevel6: TBevel
          Left = 0
          Height = 25
          Top = 40
          Width = 467
          Align = alBottom
          Shape = bsBottomLine
        end
        object Label11: TLabel
          Left = 16
          Height = 13
          Top = 24
          Width = 189
          Caption = 'Choose format for display name:'
          ParentColor = False
        end
      end
    end
    object page4: TPage
      object Label5: TLabel
        Left = 60
        Height = 13
        Top = 124
        Width = 132
        Alignment = taRightJustify
        Caption = 'Server NETBIOS name:'
        ParentColor = False
      end
      object Label6: TLabel
        Left = 66
        Height = 13
        Top = 164
        Width = 126
        Alignment = taRightJustify
        Caption = 'Samba domain name:'
        ParentColor = False
      end
      object wedServer: TEdit
        Left = 192
        Height = 19
        Top = 120
        Width = 193
        TabOrder = 0
      end
      object wcbDomain: TComboBox
        Left = 192
        Height = 27
        Top = 160
        Width = 193
        ItemHeight = 0
        Style = csDropDownList
        TabOrder = 1
      end
      object Panel5: TPanel
        Left = 0
        Height = 65
        Top = 0
        Width = 467
        Align = alTop
        BevelOuter = bvNone
        ClientHeight = 65
        ClientWidth = 467
        Color = clWindow
        ParentColor = False
        TabOrder = 2
        object Bevel1: TBevel
          Left = 0
          Height = 25
          Top = 40
          Width = 467
          Align = alBottom
          Shape = bsBottomLine
        end
        object Label4: TLabel
          Left = 16
          Height = 13
          Top = 24
          Width = 280
          Caption = 'Enter Samba NETBIOS server and domain name:'
          ParentColor = False
        end
      end
    end
    object page5: TPage
      object Label8: TLabel
        Left = 120
        Height = 13
        Top = 124
        Width = 72
        Alignment = taRightJustify
        Caption = 'Mail domain:'
        ParentColor = False
      end
      object Label9: TLabel
        Left = 99
        Height = 13
        Top = 164
        Width = 93
        Alignment = taRightJustify
        Caption = 'Maildrop server:'
        ParentColor = False
      end
      object wedMail: TEdit
        Left = 192
        Height = 19
        Top = 120
        Width = 193
        TabOrder = 0
      end
      object wedMaildrop: TEdit
        Left = 192
        Height = 19
        Top = 160
        Width = 193
        TabOrder = 1
      end
      object Panel6: TPanel
        Left = 0
        Height = 65
        Top = 0
        Width = 467
        Align = alTop
        BevelOuter = bvNone
        ClientHeight = 65
        ClientWidth = 467
        Color = clWindow
        ParentColor = False
        TabOrder = 2
        object Bevel2: TBevel
          Left = 0
          Height = 25
          Top = 40
          Width = 467
          Align = alBottom
          Shape = bsBottomLine
        end
        object Label7: TLabel
          Left = 16
          Height = 13
          Top = 24
          Width = 337
          Caption = 'Enter your mail domain and maildrop adress (Postfix only):'
          ParentColor = False
        end
      end
    end
  end
  object btnNext: TButton
    Left = 296
    Height = 25
    Top = 272
    Width = 75
    Caption = '&Next >'
    Default = True
    OnClick = btnNextClick
    TabOrder = 2
  end
  object btnBack: TButton
    Left = 220
    Height = 25
    Top = 272
    Width = 75
    Caption = '< &Back'
    Enabled = False
    OnClick = btnBackClick
    TabOrder = 1
  end
  object btnCancel: TButton
    Left = 384
    Height = 25
    Top = 272
    Width = 75
    Caption = '&Cancel'
    OnClick = btnCancelClick
    TabOrder = 3
  end
end
