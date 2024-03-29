object ConfigDlg: TConfigDlg
  Left = 576
  Height = 435
  Top = 224
  Width = 450
  BorderStyle = bsDialog
  Caption = 'Options'
  ClientHeight = 435
  ClientWidth = 450
  Color = clBtnFace
  OnClose = FormClose
  OnDestroy = FormDestroy
  ParentFont = True
  Position = poMainFormCenter
  ShowHint = True
  LCLVersion = '2.2.2.0'
  object PageControl1: TPageControl
    Left = 0
    Height = 378
    Top = 0
    Width = 450
    ActivePage = TabSheet1
    Align = alClient
    TabIndex = 0
    TabOrder = 0
    object TabSheet1: TTabSheet
      Caption = '&Application'
      ClientHeight = 351
      ClientWidth = 440
      object GroupBox1: TGroupBox
        Left = 8
        Height = 99
        Top = 105
        Width = 425
        Caption = '&LDAP tree'
        ClientHeight = 83
        ClientWidth = 423
        TabOrder = 1
        object cbIdObject: TCheckBox
          Left = 24
          Height = 21
          Top = 6
          Width = 117
          Caption = '&Identify objects'
          OnClick = cbIdObjectClick
          TabOrder = 0
        end
        object cbEnforceContainer: TCheckBox
          Left = 24
          Height = 21
          Top = 30
          Width = 178
          AllowGrayed = True
          Caption = '&Enforce container objects'
          Enabled = False
          State = cbGrayed
          TabOrder = 2
        end
        object cbSmartDelete: TCheckBox
          Left = 240
          Height = 21
          Top = 6
          Width = 102
          Caption = 'Smart &delete'
          TabOrder = 1
        end
        object cbTemplateIcons: TCheckBox
          Left = 240
          Height = 21
          Top = 30
          Width = 113
          Caption = '&Template icons'
          TabOrder = 3
        end
        object cbDisplayEncoded: TCheckBox
          Left = 24
          Height = 21
          Top = 53
          Width = 192
          Caption = 'Do not decode LDAP strings'
          TabOrder = 4
        end
      end
      object GroupBox3: TGroupBox
        Left = 8
        Height = 89
        Top = 8
        Width = 425
        Caption = '&Startup'
        ClientHeight = 73
        ClientWidth = 423
        TabOrder = 0
        object cbConnect: TCheckBox
          Left = 24
          Height = 21
          Top = 3
          Width = 129
          Caption = '&Connect on start:'
          OnClick = cbConnectClick
          TabOrder = 0
        end
        object SetDefBtn: TButton
          Left = 208
          Height = 25
          Top = 29
          Width = 193
          Caption = '&Set as default LDAP browser'
          OnClick = SetDefBtnClick
          TabOrder = 2
        end
        object CheckAssocCbk: TCheckBox
          Left = 25
          Height = 21
          Top = 31
          Width = 181
          Caption = 'Always &check associations'
          TabOrder = 1
        end
      end
      object GroupBox4: TGroupBox
        Left = 8
        Height = 129
        Top = 212
        Width = 425
        Caption = 'Sea&rch'
        ClientHeight = 113
        ClientWidth = 423
        TabOrder = 2
        object Label2: TLabel
          Left = 24
          Height = 15
          Top = 50
          Width = 114
          Caption = '&Quick search filter:'
          ParentColor = False
        end
        object Label4: TLabel
          Left = 24
          Height = 15
          Top = 2
          Width = 33
          Caption = '&Filter:'
          ParentColor = False
        end
        object edQSearch: TEdit
          Left = 24
          Height = 26
          Top = 66
          Width = 377
          TabOrder = 1
        end
        object edSearch: TEdit
          Left = 24
          Height = 26
          Top = 21
          Width = 377
          TabOrder = 0
        end
      end
    end
    object TabSheet2: TTabSheet
      Caption = '&Templates'
      ClientHeight = 351
      ClientWidth = 440
      ImageIndex = 1
      object GroupBox2: TGroupBox
        Left = 8
        Height = 201
        Top = 8
        Width = 425
        Caption = '&Files'
        ClientHeight = 185
        ClientWidth = 423
        TabOrder = 0
        object Label1: TLabel
          Left = 24
          Height = 15
          Top = -1
          Width = 125
          Caption = '&Template directories:'
          FocusControl = TemplateList
          ParentColor = False
        end
        object TemplateList: TListBox
          Left = 24
          Height = 145
          Top = 15
          Width = 305
          ItemHeight = 0
          OnMouseMove = ListMouseMove
          ScrollWidth = 301
          TabOrder = 0
          TopIndex = -1
        end
        object btnAdd: TButton
          Left = 335
          Height = 25
          Top = 16
          Width = 82
          Caption = '&Add...'
          OnClick = btnAddClick
          TabOrder = 1
        end
        object btnDel: TButton
          Left = 335
          Height = 25
          Top = 47
          Width = 82
          Caption = '&Remove'
          OnClick = btnDelClick
          TabOrder = 2
        end
      end
      object GroupBox5: TGroupBox
        Left = 8
        Height = 105
        Top = 224
        Width = 425
        Caption = '&Options'
        ClientHeight = 89
        ClientWidth = 423
        TabOrder = 1
        object cbTemplateExtensions: TCheckBox
          Left = 24
          Height = 21
          Top = 30
          Width = 283
          Caption = 'Allow templates to e&xtend property dialogs'
          TabOrder = 1
        end
        object cbTemplateAutoload: TCheckBox
          Left = 24
          Height = 21
          Top = 6
          Width = 224
          Caption = '&Autoload templates when editing'
          TabOrder = 0
        end
        object cbTemplateProperties: TCheckBox
          Left = 24
          Height = 21
          Top = 54
          Width = 230
          Caption = 'Use templates as property objects'
          TabOrder = 2
        end
      end
    end
    object TabSheet3: TTabSheet
      Caption = '&Localization'
      ClientHeight = 351
      ClientWidth = 440
      ImageIndex = 2
      object GroupBox6: TGroupBox
        Left = 8
        Height = 153
        Top = 8
        Width = 425
        Caption = '&Languages'
        ClientHeight = 137
        ClientWidth = 423
        TabOrder = 0
        object Label5: TLabel
          Left = 24
          Height = 15
          Top = -1
          Width = 90
          Caption = '&File directories:'
          FocusControl = LanguageList
          ParentColor = False
        end
        object LanguageList: TListBox
          Left = 24
          Height = 97
          Top = 15
          Width = 305
          ItemHeight = 0
          OnMouseMove = ListMouseMove
          ScrollWidth = 301
          TabOrder = 0
          TopIndex = -1
        end
        object btnAddLang: TButton
          Left = 335
          Height = 25
          Top = 16
          Width = 82
          Caption = '&Add...'
          OnClick = btnAddLangClick
          TabOrder = 1
        end
        object btnDelLang: TButton
          Left = 335
          Height = 25
          Top = 78
          Width = 81
          Caption = '&Remove'
          OnClick = btnDelLangClick
          TabOrder = 3
        end
        object btnEditLang: TButton
          Left = 335
          Height = 25
          Top = 47
          Width = 82
          Caption = '&Edit'
          OnClick = btnEditLangClick
          TabOrder = 2
        end
      end
      object GroupBox7: TGroupBox
        Left = 8
        Height = 161
        Top = 176
        Width = 425
        Caption = '&Transcoding'
        ClientHeight = 145
        ClientWidth = 423
        TabOrder = 1
        object Label3: TLabel
          Left = 24
          Height = 15
          Top = 3
          Width = 173
          Caption = 'Character transcoding table:'
          ParentColor = False
        end
        object TranscodingTable: TStringGrid
          Left = 24
          Height = 105
          Top = 19
          Width = 385
          ColCount = 2
          DefaultRowHeight = 16
          FixedCols = 0
          FixedRows = 0
          Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goEditing, goAlwaysShowEditor]
          RowCount = 6
          ScrollBars = ssVertical
          TabOrder = 0
          OnSetEditText = TranscodingTableSetEditText
          ColWidths = (
            75
            311
          )
        end
      end
    end
  end
  object Panel1: TPanel
    Left = 0
    Height = 57
    Top = 378
    Width = 450
    Align = alBottom
    ClientHeight = 57
    ClientWidth = 450
    TabOrder = 1
    object OKBtn: TButton
      Left = 143
      Height = 25
      Top = 16
      Width = 75
      Caption = 'OK'
      Default = True
      ModalResult = 1
      TabOrder = 0
    end
    object CancelBtn: TButton
      Left = 231
      Height = 25
      Top = 16
      Width = 75
      Cancel = True
      Caption = 'Cancel'
      ModalResult = 2
      TabOrder = 1
    end
  end
end
