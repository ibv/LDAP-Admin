object ExportDlg: TExportDlg
  Left = 435
  Height = 212
  Top = 238
  Width = 498
  BorderStyle = bsDialog
  Caption = 'Export'
  ClientHeight = 212
  ClientWidth = 498
  Color = clBtnFace
  OnClose = FormClose
  OnDestroy = FormDestroy
  OnShow = FormShow
  ParentFont = True
  Position = poOwnerFormCenter
  LCLVersion = '3.2.0.0'
  object Bevel1: TBevel
    Left = 8
    Height = 161
    Top = 8
    Width = 481
    Shape = bsFrame
  end
  object OKBtn: TButton
    Left = 335
    Height = 25
    Top = 180
    Width = 75
    Caption = 'OK'
    Default = True
    Enabled = False
    TabOrder = 0
    OnClick = OKBtnClick
  end
  object CancelBtn: TButton
    Left = 415
    Height = 25
    Top = 180
    Width = 75
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 1
  end
  object Notebook: TNotebook
    Left = 16
    Height = 145
    Top = 16
    Width = 465
    PageIndex = 0
    TabOrder = 2
    object page1: TPage
      object PageControl: TPageControl
        Left = 0
        Height = 145
        Top = 0
        Width = 465
        ActivePage = TabSheet1
        Align = alClient
        TabIndex = 0
        TabOrder = 0
        object TabSheet1: TTabSheet
          Caption = 'Export'
          ClientHeight = 116
          ClientWidth = 455
          object Label1: TLabel
            Left = 8
            Height = 15
            Top = 0
            Width = 57
            Caption = '&Filename:'
            FocusControl = edFileName
            ParentColor = False
          end
          object BrowseBtn: TSpeedButton
            Left = 427
            Height = 23
            Top = 15
            Width = 24
            Flat = True
            Glyph.Data = {
              42020000424D4202000000000000420000002800000010000000100000000100
              10000300000000020000120B0000120B00000000000000000000007C0000E003
              00001F0000001F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C
              1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C
              1F7C1F7C1F7C1F7C215E215E215E215E215E215E215E215E215E215E215E215E
              1F7C1F7C1F7C215E84660E73507B2C7B2C7B2C7B2C7B2C7B2C7B2C7B2C7BA76A
              63621F7C1F7C215EE9728766737F4D7B4D7B4D7B4D7B4D7B4D7B4D7B4D7BC86A
              B87B215E1F7C215E4E7B215E957F6F7F6F7F6F7F6F7F6F7F6F7F6F7B6F7BC86A
              B87B215E1F7C215E6F7F6362737B927F907F907F907F907F907F907F907FC96E
              B87B42621F7C215E907FC86E0C6FB57FB17FB17FB17FB17FB17FB17FB17FE96E
              B87BB87B215E215E917F6E7B6462FF7FD87FD87FD87FD87FD87FD87FD87F5373
              FC7FDA7B215E215EB27FB27F4362215E215E215E215E215E215E215E215E215E
              215E215E215E215ED37FD37FD37FD37FD37FD37FD37FD37FD37FD37FD37F215E
              1F7C1F7C1F7C215EFF7FF37FF37FF37FD47FF47FD37FF47FF47FF37FF47F215E
              1F7C1F7C1F7C1F7C215EFF7FF47FF47FF47F215E215E215E215E215E215E1F7C
              1F7C1F7C1F7C1F7C1F7C215E215E215E215E1F7C1F7C1F7C1F7C1F7C1F7C1F7C
              1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C
              1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C
              1F7C1F7C1F7C
            }
            Layout = blGlyphRight
            OnClick = BrowseBtnClick
          end
          object Label4: TLabel
            Left = 8
            Height = 14
            Top = 49
            Width = 49
            Caption = 'Export: '
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = [fsBold]
            ParentColor = False
            ParentFont = False
            ParentShowHint = False
            ShowHint = True
          end
          object Label6: TLabel
            Left = 246
            Height = 15
            Top = 84
            Width = 61
            Alignment = taRightJustify
            Caption = 'Encoding:'
            ParentColor = False
          end
          object edFileName: TEdit
            Left = 8
            Height = 32
            Top = 15
            Width = 417
            TabOrder = 0
            OnChange = edFileNameChange
          end
          object SubDirsCbk: TCheckBox
            Left = 8
            Height = 23
            Top = 73
            Width = 160
            Caption = '&Include subdirectories'
            Checked = True
            State = cbChecked
            TabOrder = 1
            OnClick = SubDirsCbkClick
          end
          object cbEncoding: TComboBox
            Left = 311
            Height = 27
            Top = 78
            Width = 114
            ItemHeight = 0
            ItemIndex = 1
            Items.Strings = (
              'ANSI'
              'UTF-8'
              'Unicode'
              'Unicode Big Endian'
            )
            Style = csDropDownList
            TabOrder = 3
            Text = 'UTF-8'
            OnChange = cbEncodingChange
          end
          object cbGenerateComments: TCheckBox
            Left = 8
            Height = 23
            Top = 92
            Width = 149
            Caption = 'Generate comments'
            TabOrder = 2
          end
        end
        object TabSheet2: TTabSheet
          Caption = 'Custom'
          ClientHeight = 116
          ClientWidth = 455
          ImageIndex = 1
          object Label7: TLabel
            Left = 8
            Height = 15
            Top = 0
            Width = 33
            Caption = 'Filter:'
            ParentColor = False
          end
          object Memo1: TMemo
            Left = 8
            Height = 38
            Top = 17
            Width = 440
            Anchors = [akTop, akLeft, akRight]
            Font.Color = clWindowText
            Font.Height = -12
            Font.Name = 'Courier New'
            Lines.Strings = (
              '(objectclass=*)'
            )
            ParentFont = False
            TabOrder = 0
          end
          object Label8: TLabel
            Left = 8
            Height = 15
            Top = 59
            Width = 64
            Alignment = taRightJustify
            Caption = 'Attributes:'
            ParentColor = False
          end
          object edAttributes: TEdit
            Left = 8
            Height = 32
            Top = 76
            Width = 440
            TabOrder = 1
            OnChange = edFileNameChange
          end
        end
      end
    end
    object page2: TPage
      object Label2: TLabel
        Left = 7
        Height = 15
        Top = 56
        Width = 55
        Alignment = taRightJustify
        Caption = 'Progress:'
        FocusControl = ProgressBar
        ParentColor = False
      end
      object Label3: TLabel
        Left = 424
        Height = 15
        Top = 56
        Width = 35
        Caption = '100%'
        ParentColor = False
      end
      object ResultLabel: TLabel
        Left = 72
        Height = 1
        Top = 88
        Width = 1
        Alignment = taCenter
        ParentColor = False
      end
      object Label5: TLabel
        Left = 7
        Height = 15
        Top = 16
        Width = 63
        Alignment = taRightJustify
        Caption = 'Exporting:'
        ParentColor = False
      end
      object ExportingLabel: TLabel
        Left = 72
        Height = 13
        Top = 16
        Width = 385
        AutoSize = False
        ParentColor = False
        WordWrap = True
      end
      object ProgressBar: TProgressBar
        Left = 72
        Height = 16
        Top = 54
        Width = 345
        Step = 1
        TabOrder = 0
      end
    end
  end
end
