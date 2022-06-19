object SearchFrm: TSearchFrm
  Left = 482
  Height = 409
  Top = 181
  Width = 692
  Caption = 'Search'
  ClientHeight = 409
  ClientWidth = 692
  Color = clBtnFace
  Constraints.MinHeight = 409
  Constraints.MinWidth = 473
  KeyPreview = True
  OnClose = FormClose
  OnCloseQuery = FormCloseQuery
  OnDeactivate = FormDeactivate
  OnDestroy = FormDestroy
  OnKeyPress = FormKeyPress
  ParentFont = True
  Position = poMainFormCenter
  LCLVersion = '2.2.2.0'
  object StatusBar: TStatusBar
    Left = 0
    Height = 16
    Top = 393
    Width = 692
    Panels = <    
      item
        Width = 50
      end    
      item
        Width = 50
      end>
  end
  object Panel1: TPanel
    Left = 0
    Height = 172
    Top = 29
    Width = 692
    Align = alTop
    BorderWidth = 3
    ClientHeight = 172
    ClientWidth = 692
    TabOrder = 1
    object Panel2: TPanel
      Left = 4
      Height = 164
      Top = 4
      Width = 684
      Align = alClient
      BevelOuter = bvNone
      ClientHeight = 164
      ClientWidth = 684
      TabOrder = 0
      object Panel40: TPanel
        Left = 0
        Height = 164
        Top = 0
        Width = 684
        Align = alClient
        BevelOuter = bvNone
        ClientHeight = 164
        ClientWidth = 684
        TabOrder = 0
        object Panel41: TPanel
          Left = 0
          Height = 41
          Top = 0
          Width = 684
          Align = alTop
          BevelOuter = bvNone
          ClientHeight = 41
          ClientWidth = 684
          TabOrder = 0
          object Label5: TLabel
            Left = 8
            Height = 15
            Top = 12
            Width = 31
            Caption = 'Path:'
            ParentColor = False
          end
          object Bevel1: TBevel
            Left = 8
            Height = 10
            Top = 28
            Width = 680
            Anchors = [akTop, akLeft, akRight]
            Shape = bsBottomLine
          end
          object cbBasePath: TComboBox
            Left = 48
            Height = 27
            Top = 5
            Width = 539
            Anchors = [akTop, akLeft, akRight]
            ItemHeight = 0
            TabOrder = 0
          end
          object PathBtn: TButton
            Left = 593
            Height = 23
            Top = 5
            Width = 85
            Anchors = [akTop, akRight]
            Caption = '&Browse...'
            OnClick = PathBtnClick
            TabOrder = 1
          end
        end
        object Panel4: TPanel
          Left = 0
          Height = 123
          Top = 41
          Width = 684
          Align = alClient
          BevelOuter = bvNone
          ClientHeight = 123
          ClientWidth = 684
          TabOrder = 1
          object PageControl: TPageControl
            Left = 0
            Height = 123
            Top = 0
            Width = 587
            ActivePage = TabSheet1
            Align = alClient
            TabIndex = 0
            TabOrder = 0
            object TabSheet1: TTabSheet
              Caption = '&Search'
              ClientHeight = 96
              ClientWidth = 577
              object Label6: TLabel
                Left = 24
                Height = 15
                Top = 0
                Width = 39
                Caption = '&Name:'
                ParentColor = False
              end
              object Label7: TLabel
                Left = 24
                Height = 15
                Top = 44
                Width = 39
                Caption = '&E-Mail:'
                ParentColor = False
              end
              object sbCustom1: TSpeedButton
                Left = 552
                Height = 21
                Top = 16
                Width = 21
                AllowAllUp = True
                Anchors = [akTop, akRight]
                Glyph.Data = {
                  36030000424D3603000000000000360000002800000010000000100000000100
                  1800000000000003000000000000000000000000000000000000000000000000
                  0000000000000000000000000000000000000000000000000000000000000000
                  0000000000000000000000000000000000000000000000000000000000000000
                  0000000000000000000000000000000000000000000000000000000000000000
                  0000000000000000000000006640496640496640496640496640496640496640
                  49664049664049000000000000000000000000000000000000000000664049FF
                  FFFFE0E0E0E3E3E3E7E7E7EAEAEAEDEDEDF0F0F0664049000000000000000000
                  000000000000000000000000664049FFFFFFDEDEDEE1E1E18989898B8B8B8D8D
                  8DEEEEEE664049000000000000000000000000000000000000000000664049FF
                  FFFFDBDBDBDFDFDFE2E2E2E5E5E5E8E8E8ECECEC664049000000000000000000
                  6640496640496640496640496640496640496640496640496640498888888B8B
                  8BE9E9E9664049000000000000000000664049FFFFFFABABABE3E3E3E7E7E7EA
                  EAEAEDEDEDEEEFF065434CDADEDFDEE2E3E3E6E665404A000000000000000000
                  664049FFFFFF0000009D9D9D7C7C7C7D7D7D7D8081E2EBED6A5D6A7E7F8A7E7F
                  8A7F7883664D577FBFFF000000000000000000000000000000000000BCBCBCE4
                  E5E5DDE6E8C7E3EB789AAB7FADBD7FADBD789AAB6D6F7C79D2E8000000000000
                  664049FFFFFF000000A8A8A886868687898A87999EACDDEBA4D3E2D1EFF8D1F0
                  F8AAE3F284D4EB7DD3EB000000000000664049FFFFFFA4A4A4DADADADDDDDDDC
                  DFE0C8DFE5A7DDECCCE8F0F6FAFBF6FAFBCFECF490D9EE7BD2EC000000000000
                  6640498C6F7781616981616981616980646D7F7F8A8CB8CBCCE7EFF6FAFBF6FA
                  FBCFECF491DAEE7BD2EC00000000000066404966404966404966404966404966
                  434D695D6A7898ABA4D1E2D1EFF7D1EFF7AAE2F284D4EB7DD3EB000000000000
                  0000000000000000000000000000007FFFFF79D2E87CD0E984D4ED88D2E788D2
                  E784D4ED7CD0E979D2E800000000000000000000000000000000000000000000
                  00003FBFFF6EC7DD7ACDE679D1E879D1E87ACDE66EC7DD7FBFFF
                }
                GroupIndex = 1
                OnClick = sbCustom1Click
              end
              object sbCustom2: TSpeedButton
                Left = 552
                Height = 21
                Top = 61
                Width = 21
                AllowAllUp = True
                Anchors = [akTop, akRight]
                Glyph.Data = {
                  36030000424D3603000000000000360000002800000010000000100000000100
                  1800000000000003000000000000000000000000000000000000000000000000
                  0000000000000000000000000000000000000000000000000000000000000000
                  0000000000000000000000000000000000000000000000000000000000000000
                  0000000000000000000000000000000000000000000000000000000000000000
                  0000000000000000000000006640496640496640496640496640496640496640
                  49664049664049000000000000000000000000000000000000000000664049FF
                  FFFFE0E0E0E3E3E3E7E7E7EAEAEAEDEDEDF0F0F0664049000000000000000000
                  000000000000000000000000664049FFFFFFDEDEDEE1E1E18989898B8B8B8D8D
                  8DEEEEEE664049000000000000000000000000000000000000000000664049FF
                  FFFFDBDBDBDFDFDFE2E2E2E5E5E5E8E8E8ECECEC664049000000000000000000
                  6640496640496640496640496640496640496640496640496640498888888B8B
                  8BE9E9E9664049000000000000000000664049FFFFFFABABABE3E3E3E7E7E7EA
                  EAEAEDEDEDEEEFF065434CDADEDFDEE2E3E3E6E665404A000000000000000000
                  664049FFFFFF0000009D9D9D7C7C7C7D7D7D7D8081E2EBED6A5D6A7E7F8A7E7F
                  8A7F7883664D577FBFFF000000000000000000000000000000000000BCBCBCE4
                  E5E5DDE6E8C7E3EB789AAB7FADBD7FADBD789AAB6D6F7C79D2E8000000000000
                  664049FFFFFF000000A8A8A886868687898A87999EACDDEBA4D3E2D1EFF8D1F0
                  F8AAE3F284D4EB7DD3EB000000000000664049FFFFFFA4A4A4DADADADDDDDDDC
                  DFE0C8DFE5A7DDECCCE8F0F6FAFBF6FAFBCFECF490D9EE7BD2EC000000000000
                  6640498C6F7781616981616981616980646D7F7F8A8CB8CBCCE7EFF6FAFBF6FA
                  FBCFECF491DAEE7BD2EC00000000000066404966404966404966404966404966
                  434D695D6A7898ABA4D1E2D1EFF7D1EFF7AAE2F284D4EB7DD3EB000000000000
                  0000000000000000000000000000007FFFFF79D2E87CD0E984D4ED88D2E788D2
                  E784D4ED7CD0E979D2E800000000000000000000000000000000000000000000
                  00003FBFFF6EC7DD7ACDE679D1E879D1E87ACDE66EC7DD7FBFFF
                }
                GroupIndex = 2
                OnClick = sbCustom2Click
              end
              object edCustom1: TEdit
                Left = 24
                Height = 26
                Top = 16
                Width = 524
                Anchors = [akTop, akLeft, akRight]
                Color = clInfoBk
                Enabled = False
                TabOrder = 2
              end
              object edName: TEdit
                Left = 24
                Height = 26
                Top = 15
                Width = 524
                Anchors = [akTop, akLeft, akRight]
                TabOrder = 0
              end
              object edCustom2: TEdit
                Left = 24
                Height = 26
                Top = 60
                Width = 524
                Anchors = [akTop, akLeft, akRight]
                Color = clInfoBk
                Enabled = False
                TabOrder = 3
              end
              object edEmail: TEdit
                Left = 24
                Height = 26
                Top = 61
                Width = 524
                Anchors = [akTop, akLeft, akRight]
                TabOrder = 1
              end
            end
            object TabSheet2: TTabSheet
              Caption = '&Custom'
              ClientHeight = 96
              ClientWidth = 577
              ImageIndex = 1
              object Label1: TLabel
                Left = 5
                Height = 15
                Top = 3
                Width = 33
                Caption = 'Filter:'
                ParentColor = False
              end
              object Memo1: TMemo
                Left = 40
                Height = 49
                Top = 5
                Width = 535
                Anchors = [akTop, akLeft, akRight]
                Font.Color = clWindowText
                Font.Height = -12
                Font.Name = 'Courier New'
                ParentFont = False
                TabOrder = 0
              end
              object cbFilters: TComboBox
                Left = 39
                Height = 27
                Top = 57
                Width = 400
                Anchors = [akTop, akLeft, akRight]
                ItemHeight = 0
                OnChange = cbFiltersChange
                OnDropDown = cbFiltersDropDown
                TabOrder = 1
              end
              object SaveFilterBtn: TButton
                Left = 441
                Height = 23
                Top = 61
                Width = 65
                Anchors = [akRight]
                Caption = 'Sa&ve'
                Enabled = False
                OnClick = SaveFilterBtnClick
                TabOrder = 2
              end
              object DeleteFilterBtn: TButton
                Left = 510
                Height = 23
                Top = 61
                Width = 65
                Anchors = [akRight]
                Caption = '&Delete'
                Enabled = False
                OnClick = DeleteFilterBtnClick
                TabOrder = 3
              end
            end
            object TabSheet3: TTabSheet
              Caption = '&Options'
              ClientHeight = 96
              ClientWidth = 577
              ImageIndex = 2
              object Label4: TLabel
                Left = 11
                Height = 15
                Top = 14
                Width = 64
                Alignment = taRightJustify
                Caption = 'Attributes:'
                ParentColor = False
              end
              object Label2: TLabel
                Left = 11
                Height = 15
                Top = 46
                Width = 77
                Alignment = taRightJustify
                Caption = 'Search level:'
                ParentColor = False
              end
              object Label3: TLabel
                Left = 236
                Height = 15
                Top = 46
                Width = 120
                Alignment = taRightJustify
                Caption = 'Dereference aliases:'
                ParentColor = False
              end
              object cbAttributes: TComboBox
                Left = 80
                Height = 27
                Top = 8
                Width = 404
                Anchors = [akTop, akLeft, akRight]
                ItemHeight = 0
                TabOrder = 0
              end
              object edAttrBtn: TButton
                Left = 491
                Height = 23
                Top = 8
                Width = 80
                Anchors = [akTop, akRight]
                Caption = 'Edit...'
                OnClick = edAttrBtnClick
                TabOrder = 1
              end
              object cbSearchLevel: TComboBox
                Left = 93
                Height = 27
                Top = 41
                Width = 130
                ItemHeight = 0
                Items.Strings = (
                  'This entry only'
                  'Next level'
                  'Entire subtree'
                )
                Style = csDropDownList
                TabOrder = 2
              end
              object cbDerefAliases: TComboBox
                Left = 357
                Height = 27
                Top = 41
                Width = 128
                Anchors = [akTop, akLeft, akRight]
                ItemHeight = 0
                Items.Strings = (
                  'Never'
                  'When searching'
                  'When finding'
                  'Always'
                )
                Style = csDropDownList
                TabOrder = 3
              end
            end
            object TabSheet4: TTabSheet
              Caption = '&Regular Expressions'
              ClientHeight = 96
              ClientWidth = 577
              ImageIndex = 3
              object Label8: TLabel
                Left = 6
                Height = 15
                Top = 10
                Width = 61
                Alignment = taRightJustify
                Caption = 'Evaluator:'
                ParentColor = False
              end
              object cbRegExp: TComboBox
                Left = 7
                Height = 27
                Top = 61
                Width = 430
                Anchors = [akTop, akLeft, akRight]
                ItemHeight = 0
                OnChange = cbRegExpChange
                OnDropDown = cbRegExpDropDown
                TabOrder = 4
              end
              object btnSaveRegEx: TButton
                Left = 441
                Height = 23
                Top = 65
                Width = 65
                Anchors = [akRight]
                Caption = 'Sa&ve'
                Enabled = False
                OnClick = btnSaveRegExClick
                TabOrder = 5
              end
              object btnDeleteRegEx: TButton
                Left = 510
                Height = 23
                Top = 65
                Width = 65
                Anchors = [akRight]
                Caption = '&Delete'
                Enabled = False
                OnClick = btnDeleteRegExClick
                TabOrder = 6
              end
              object edRegExp: TEdit
                Left = 70
                Height = 26
                Top = 5
                Width = 502
                Anchors = [akTop, akLeft, akRight]
                TabOrder = 0
              end
              object cbxReGreedy: TCheckBox
                Left = 24
                Height = 21
                Top = 37
                Width = 105
                Caption = 'Greedy mode'
                Checked = True
                State = cbChecked
                TabOrder = 1
              end
              object cbxReCase: TCheckBox
                Left = 141
                Height = 21
                Top = 37
                Width = 108
                Caption = 'Case sensitive'
                Checked = True
                State = cbChecked
                TabOrder = 2
              end
              object cbxReMultiline: TCheckBox
                Left = 264
                Height = 21
                Top = 37
                Width = 136
                Caption = 'Multiline matching'
                TabOrder = 3
              end
            end
          end
          object Panel3: TPanel
            Left = 587
            Height = 123
            Top = 0
            Width = 97
            Align = alRight
            BevelOuter = bvNone
            ClientHeight = 123
            ClientWidth = 97
            TabOrder = 1
            object StartBtn: TBitBtn
              Left = 8
              Height = 25
              Top = 26
              Width = 83
              Action = ActStart
              Caption = 'Sta&rt'
              ParentShowHint = False
              ShowHint = True
              TabOrder = 0
            end
            object ClearAllBtn: TButton
              Left = 8
              Height = 25
              Top = 58
              Width = 83
              Action = ActClearAll
              ParentShowHint = False
              ShowHint = True
              TabOrder = 1
            end
          end
        end
      end
    end
  end
  object ResultPanel: TPanel
    Left = 0
    Height = 192
    Top = 201
    Width = 692
    Align = alClient
    BorderWidth = 3
    TabOrder = 2
  end
  object ToolBar1: TToolBar
    Left = 0
    Height = 29
    Top = 0
    Width = 692
    ButtonHeight = 28
    ButtonWidth = 28
    DisabledImages = MainFrm.ImageList
    Images = MainFrm.ImageList
    ParentShowHint = False
    ShowHint = True
    TabOrder = 3
    object btnSearch: TToolButton
      Left = 1
      Hint = 'Search'
      Top = 2
      Down = True
      Grouped = True
      ImageIndex = 20
      OnClick = btnSearchModifyClick
      Style = tbsCheck
    end
    object btnModify: TToolButton
      Left = 29
      Hint = 'Modify'
      Top = 2
      Grouped = True
      ImageIndex = 38
      OnClick = btnSearchModifyClick
      Style = tbsCheck
    end
    object ToolButton7: TToolButton
      Left = 57
      Height = 28
      Top = 2
      ImageIndex = 6
      Style = tbsSeparator
    end
    object ToolButton1: TToolButton
      Left = 65
      Top = 2
      Action = ActLoad
    end
    object ToolButton6: TToolButton
      Left = 93
      Top = 2
      Action = ActSave
    end
    object ToolButton8: TToolButton
      Left = 121
      Height = 28
      Top = 2
      ImageIndex = 32
      Style = tbsSeparator
    end
    object ToolButton3: TToolButton
      Left = 129
      Top = 2
      Action = ActEdit
    end
    object ToolButton4: TToolButton
      Left = 157
      Top = 2
      Action = ActProperties
    end
    object ToolButton5: TToolButton
      Left = 185
      Top = 2
      Action = ActGoto
    end
    object ToolButton2: TToolButton
      Left = 213
      Height = 28
      Top = 2
      ImageIndex = 19
      Style = tbsSeparator
    end
    object ToolButton9: TToolButton
      Left = 221
      Top = 2
      Action = ActClose
    end
  end
  object PopupMenu1: TPopupMenu
    Images = MainFrm.ImageList
    Left = 32
    Top = 320
    object pbGoto: TMenuItem
      Action = ActGoto
    end
    object Editentry1: TMenuItem
      Action = ActEdit
    end
    object N2: TMenuItem
      Caption = '-'
    end
    object Move1: TMenuItem
      Action = ActMove
    end
    object Copy1: TMenuItem
      Action = ActCopy
    end
    object Delete1: TMenuItem
      Action = ActDelete
    end
    object N3: TMenuItem
      Caption = '-'
    end
    object Save1: TMenuItem
      Action = ActSave
    end
    object Saveselected1: TMenuItem
      Action = ActSaveSelected
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object pbProperties: TMenuItem
      Action = ActProperties
    end
  end
  object ActionList: TActionList
    Images = MainFrm.ImageList
    OnUpdate = ActionListUpdate
    Left = 128
    Top = 320
    object ActStart: TAction
      Caption = '&Start'
      Hint = 'Start searching'
      ImageIndex = 20
      OnExecute = ActStartExecute
    end
    object ActGoto: TAction
      Caption = '&Go to...'
      Hint = 'Find entry in LDAP tree'
      ImageIndex = 30
      OnExecute = ActGotoExecute
    end
    object ActProperties: TAction
      Caption = '&Properties...'
      Hint = 'Edit object properties'
      ImageIndex = 16
      OnExecute = ActPropertiesExecute
    end
    object ActSave: TAction
      Caption = '&Save'
      Hint = 'Save results to file'
      ImageIndex = 31
      OnExecute = ActSaveExecute
    end
    object ActEdit: TAction
      Caption = '&Edit entry...'
      Hint = 'Edit with raw editor'
      ImageIndex = 14
      OnExecute = ActEditExecute
    end
    object ActClose: TAction
      Caption = '&Close'
      Hint = 'Close search window'
      ImageIndex = 18
      OnExecute = ActCloseExecute
    end
    object ActClearAll: TAction
      Caption = 'Clear a&ll'
      Hint = 'Clear all search results'
      OnExecute = ActClearAllExecute
    end
    object ActLoad: TAction
      Caption = '&Load'
      ImageIndex = 48
      OnExecute = ActLoadExecute
    end
    object ActCopy: TAction
      Caption = 'Co&py...'
      OnExecute = ActCopyExecute
    end
    object ActMove: TAction
      Caption = '&Move...'
      OnExecute = ActMoveExecute
    end
    object ActDelete: TAction
      Caption = '&Delete'
      ImageIndex = 12
      OnExecute = ActDeleteExecute
    end
    object ActSaveSelected: TAction
      Caption = 'Save selected...'
      OnExecute = ActSaveExecute
    end
  end
  object OpenDialog: TOpenDialog
    Left = 144
    Top = 409
  end
end
