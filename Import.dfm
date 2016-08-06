object ImportDlg: TImportDlg
  Left = 435
  Height = 444
  Top = 238
  Width = 625
  BorderStyle = bsDialog
  Caption = 'Import from LDIF'
  ClientHeight = 444
  ClientWidth = 625
  Color = clBtnFace
  OnActivate = FormActivate
  OnClose = FormClose
  ParentFont = True
  Position = poOwnerFormCenter
  LCLVersion = '1.6.0.4'
  object Bevel1: TBevel
    Left = 8
    Height = 185
    Top = 8
    Width = 609
    Shape = bsFrame
  end
  object OKBtn: TButton
    Left = 463
    Height = 25
    Top = 410
    Width = 75
    Anchors = [akLeft, akBottom]
    Caption = 'OK'
    Default = True
    Enabled = False
    OnClick = OKBtnClick
    TabOrder = 0
  end
  object CancelBtn: TButton
    Left = 543
    Height = 25
    Top = 410
    Width = 75
    Anchors = [akLeft, akBottom]
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    OnClick = CancelBtnClick
    TabOrder = 1
  end
  object Notebook: TNotebook
    Left = 16
    Height = 169
    Top = 16
    Width = 593
    PageIndex = 0
    TabOrder = 2
    TabStop = True
    object page1: TPage
      object Label1: TLabel
        Left = 8
        Height = 15
        Top = 16
        Width = 61
        Caption = '&Filename:'
        FocusControl = edFileName
        ParentColor = False
      end
      object Label6: TLabel
        Left = 8
        Height = 15
        Top = 104
        Width = 161
        Caption = 'Save rejected records to:'
        ParentColor = False
      end
      object btnFileName: TSpeedButton
        Left = 563
        Height = 23
        Top = 31
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
        OnClick = btnFileNameClick
      end
      object btnRejected: TSpeedButton
        Left = 563
        Height = 23
        Top = 119
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
        OnClick = btnRejectedClick
      end
      object edFileName: TEdit
        Left = 8
        Height = 21
        Top = 32
        Width = 553
        OnChange = edFileNameChange
        TabOrder = 0
      end
      object cbStopOnError: TCheckBox
        Left = 8
        Height = 26
        Top = 72
        Width = 120
        Caption = 'Stop on errors'
        Checked = True
        State = cbChecked
        TabOrder = 1
      end
      object edRejected: TEdit
        Left = 8
        Height = 21
        Top = 120
        Width = 553
        TabOrder = 2
      end
    end
    object page2: TPage
      object Label2: TLabel
        Left = 7
        Height = 15
        Top = 56
        Width = 60
        Alignment = taRightJustify
        Caption = 'Progress:'
        FocusControl = ProgressBar
        ParentColor = False
      end
      object Label3: TLabel
        Left = 560
        Height = 15
        Top = 56
        Width = 36
        Caption = '100%'
        ParentColor = False
      end
      object ResultLabel: TLabel
        Left = 8
        Height = 13
        Top = 96
        Width = 577
        Alignment = taCenter
        AutoSize = False
        ParentColor = False
      end
      object Label5: TLabel
        Left = 7
        Height = 15
        Top = 16
        Width = 65
        Alignment = taRightJustify
        Caption = 'Importing:'
        ParentColor = False
      end
      object ImportingLabel: TLabel
        Left = 72
        Height = 13
        Top = 16
        Width = 513
        AutoSize = False
        ParentColor = False
        WordWrap = True
      end
      object errResultLabel: TLabel
        Left = 8
        Height = 13
        Top = 112
        Width = 577
        Alignment = taCenter
        AutoSize = False
        Font.Color = clRed
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        ParentColor = False
        ParentFont = False
      end
      object errLabel: TLabel
        Left = 280
        Height = 13
        Top = 80
        Width = 40
        Alignment = taCenter
        Caption = 'ERROR!'
        Font.Color = clRed
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        ParentColor = False
        ParentFont = False
        Visible = False
      end
      object ProgressBar: TProgressBar
        Left = 72
        Height = 16
        Top = 54
        Width = 481
        Step = 1
        TabOrder = 0
      end
      object DetailBtn: TButton
        Left = 1
        Height = 25
        Top = 144
        Width = 75
        Caption = 'Details >>'
        OnClick = DetailBtnClick
        TabOrder = 1
        Visible = False
      end
    end
  end
  object mbErrors: TMemo
    Left = 8
    Height = 201
    Top = 200
    Width = 609
    ReadOnly = True
    ScrollBars = ssAutoBoth
    TabOrder = 3
    Visible = False
    WordWrap = False
  end
  object OpenDialog: TOpenDialog
    DefaultExt = '.ldif'
    Filter = 'Ldif Files (*.ldif)|*.ldif|All Files (*.*)|*.*'
    left = 56
    top = 224
  end
end
