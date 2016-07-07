object SearchFrm: TSearchFrm
  Left = 482
  Height = 519
  Top = 181
  Width = 561
  Caption = 'Search'
  ClientHeight = 519
  ClientWidth = 561
  Color = clBtnFace
  Constraints.MinHeight = 409
  Constraints.MinWidth = 473
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  KeyPreview = True
  OnClose = FormClose
  OnCloseQuery = FormCloseQuery
  OnDeactivate = FormDeactivate
  OnDestroy = FormDestroy
  OnKeyPress = FormKeyPress
  Position = poMainFormCenter
  LCLVersion = '1.6.0.4'
  object StatusBar: TStatusBar
    Left = 0
    Height = 19
    Top = 500
    Width = 561
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
    Width = 561
    Align = alTop
    BorderWidth = 3
    ClientHeight = 172
    ClientWidth = 561
    TabOrder = 1
    object Panel2: TPanel
      Left = 4
      Height = 164
      Top = 4
      Width = 553
      Align = alClient
      BevelOuter = bvNone
      ClientHeight = 164
      ClientWidth = 553
      TabOrder = 0
      object Panel40: TPanel
        Left = 0
        Height = 164
        Top = 0
        Width = 553
        Align = alClient
        BevelOuter = bvNone
        ClientHeight = 164
        ClientWidth = 553
        TabOrder = 0
        object Panel41: TPanel
          Left = 0
          Height = 49
          Top = 0
          Width = 553
          Align = alTop
          BevelOuter = bvNone
          ClientHeight = 49
          ClientWidth = 553
          TabOrder = 0
          object Label5: TLabel
            Left = 8
            Height = 13
            Top = 12
            Width = 29
            Caption = 'Path:'
            ParentColor = False
          end
          object Bevel1: TBevel
            Left = 8
            Height = 10
            Top = 28
            Width = 549
            Anchors = [akTop, akLeft, akRight]
            Shape = bsBottomLine
          end
          object cbBasePath: TComboBox
            Left = 48
            Height = 20
            Top = 8
            Width = 417
            Anchors = [akTop, akLeft, akRight]
            ItemHeight = 0
            TabOrder = 0
          end
          object PathBtn: TButton
            Left = 472
            Height = 23
            Top = 7
            Width = 81
            Anchors = [akTop, akRight]
            Caption = '&Browse...'
            OnClick = PathBtnClick
            TabOrder = 1
          end
        end
        object Panel4: TPanel
          Left = 0
          Height = 115
          Top = 49
          Width = 553
          Align = alClient
          BevelOuter = bvNone
          ClientHeight = 115
          ClientWidth = 553
          TabOrder = 1
          object PageControl: TPageControl
            Left = 0
            Height = 115
            Top = 0
            Width = 456
            ActivePage = TabSheet1
            Align = alClient
            TabIndex = 0
            TabOrder = 0
            object TabSheet1: TTabSheet
              Caption = '&Search'
              ClientHeight = 80
              ClientWidth = 448
              object Label6: TLabel
                Left = 24
                Height = 13
                Top = 0
                Width = 37
                Caption = '&Name:'
                ParentColor = False
              end
              object Label7: TLabel
                Left = 24
                Height = 13
                Top = 40
                Width = 37
                Caption = '&E-Mail:'
                ParentColor = False
              end
              object sbCustom1: TSpeedButton
                Left = 423
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
                Left = 423
                Height = 21
                Top = 56
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
                Left = 160
                Height = 19
                Top = 16
                Width = 259
                Anchors = [akTop, akLeft, akRight]
                Color = clInfoBk
                Enabled = False
                TabOrder = 2
              end
              object edName: TEdit
                Left = 24
                Height = 19
                Top = 16
                Width = 395
                Anchors = [akTop, akLeft, akRight]
                TabOrder = 0
              end
              object edCustom2: TEdit
                Left = 160
                Height = 19
                Top = 56
                Width = 259
                Anchors = [akTop, akLeft, akRight]
                Color = clInfoBk
                Enabled = False
                TabOrder = 3
              end
              object edEmail: TEdit
                Left = 24
                Height = 19
                Top = 56
                Width = 395
                Anchors = [akTop, akLeft, akRight]
                TabOrder = 1
              end
            end
            object TabSheet2: TTabSheet
              Caption = '&Custom'
              ClientHeight = 80
              ClientWidth = 448
              ImageIndex = 1
              OnResize = TabSheet2Resize
              object Label1: TLabel
                Left = 8
                Height = 13
                Top = 8
                Width = 31
                Caption = 'Filter:'
                ParentColor = False
              end
              object Memo1: TMemo
                Left = 40
                Height = 49
                Top = 8
                Width = 405
                Font.Color = clWindowText
                Font.Height = -12
                Font.Name = 'Courier New'
                ParentFont = False
                TabOrder = 0
              end
              object cbFilters: TComboBox
                Left = 40
                Height = 20
                Top = 60
                Width = 250
                ItemHeight = 0
                OnChange = cbFiltersChange
                OnDropDown = cbFiltersDropDown
                TabOrder = 1
              end
              object SaveFilterBtn: TButton
                Left = 325
                Height = 23
                Top = 59
                Width = 65
                Anchors = []
                Caption = 'Sa&ve'
                Enabled = False
                OnClick = SaveFilterBtnClick
                TabOrder = 2
              end
              object DeleteFilterBtn: TButton
                Left = 377
                Height = 23
                Top = 59
                Width = 65
                Anchors = []
                Caption = '&Delete'
                Enabled = False
                OnClick = DeleteFilterBtnClick
                TabOrder = 3
              end
            end
            object TabSheet3: TTabSheet
              Caption = '&Options'
              ClientHeight = 80
              ClientWidth = 448
              ImageIndex = 2
              OnResize = TabSheet3Resize
              object Label4: TLabel
                Left = 20
                Height = 13
                Top = 12
                Width = 59
                Alignment = taRightJustify
                Caption = 'Attributes:'
                ParentColor = False
              end
              object Label2: TLabel
                Left = 4
                Height = 13
                Top = 52
                Width = 74
                Alignment = taRightJustify
                Caption = 'Search level:'
                ParentColor = False
              end
              object Label3: TLabel
                Left = 256
                Height = 13
                Top = 52
                Width = 119
                Alignment = taRightJustify
                Caption = 'Dereference aliases:'
                ParentColor = False
              end
              object cbAttributes: TComboBox
                Left = 72
                Height = 20
                Top = 8
                Width = 296
                Anchors = [akTop, akLeft, akRight]
                ItemHeight = 0
                TabOrder = 0
              end
              object edAttrBtn: TButton
                Left = 384
                Height = 23
                Top = 8
                Width = 76
                Anchors = [akTop]
                Caption = 'Edit...'
                OnClick = edAttrBtnClick
                TabOrder = 1
              end
              object cbSearchLevel: TComboBox
                Left = 72
                Height = 21
                Top = 48
                Width = 161
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
                Left = 360
                Height = 21
                Top = 48
                Width = 8
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
              ClientHeight = 80
              ClientWidth = 448
              ImageIndex = 3
              OnResize = TabSheet4Resize
              object Label8: TLabel
                Left = 11
                Height = 13
                Top = 10
                Width = 57
                Alignment = taRightJustify
                Caption = 'Evaluator:'
                ParentColor = False
              end
              object cbRegExp: TComboBox
                Left = 64
                Height = 20
                Top = 60
                Width = 250
                ItemHeight = 0
                OnChange = cbRegExpChange
                OnDropDown = cbRegExpDropDown
                TabOrder = 4
              end
              object btnSaveRegEx: TButton
                Left = 329
                Height = 23
                Top = 58
                Width = 65
                Anchors = []
                Caption = 'Sa&ve'
                Enabled = False
                OnClick = btnSaveRegExClick
                TabOrder = 5
              end
              object btnDeleteRegEx: TButton
                Left = 381
                Height = 23
                Top = 58
                Width = 65
                Anchors = []
                Caption = '&Delete'
                Enabled = False
                OnClick = btnDeleteRegExClick
                TabOrder = 6
              end
              object edRegExp: TEdit
                Left = 64
                Height = 19
                Top = 7
                Width = 537
                TabOrder = 0
              end
              object cbxReGreedy: TCheckBox
                Left = 64
                Height = 26
                Top = 35
                Width = 105
                Caption = 'Greedy mode'
                Checked = True
                State = cbChecked
                TabOrder = 1
              end
              object cbxReCase: TCheckBox
                Left = 180
                Height = 26
                Top = 35
                Width = 112
                Caption = 'Case sensitive'
                Checked = True
                State = cbChecked
                TabOrder = 2
              end
              object cbxReMultiline: TCheckBox
                Left = 308
                Height = 26
                Top = 35
                Width = 130
                Caption = 'Multiline matching'
                TabOrder = 3
              end
            end
          end
          object Panel3: TPanel
            Left = 456
            Height = 115
            Top = 0
            Width = 97
            Align = alRight
            BevelOuter = bvNone
            ClientHeight = 115
            ClientWidth = 97
            TabOrder = 1
            object StartBtn: TBitBtn
              Left = 8
              Height = 25
              Top = 20
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
              Top = 52
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
    Height = 299
    Top = 201
    Width = 561
    Align = alClient
    BorderWidth = 3
    TabOrder = 2
  end
  object ToolBar1: TToolBar
    Left = 0
    Height = 29
    Top = 0
    Width = 561
    ButtonHeight = 28
    ButtonWidth = 28
    Caption = 'ToolBar1'
    DisabledImages = MainFrm.ImageList
    Images = MainFrm.ImageList
    ParentShowHint = False
    ShowHint = True
    TabOrder = 3
    object btnSearch: TToolButton
      Left = 1
      Hint = 'Search'
      Top = 2
      Caption = 'Search'
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
      Caption = 'Modify'
      Grouped = True
      ImageIndex = 38
      OnClick = btnSearchModifyClick
      Style = tbsCheck
    end
    object ToolButton7: TToolButton
      Left = 57
      Height = 28
      Top = 2
      Width = 8
      Caption = 'ToolButton7'
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
      Width = 8
      Caption = 'ToolButton8'
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
      Width = 8
      Caption = 'ToolButton2'
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
    left = 48
    top = 424
    object pbGoto: TMenuItem
      Action = ActGoto
      Bitmap.Data = {
        36040000424D3604000000000000360000002800000010000000100000000100
        2000000000000004000064000000640000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000008421FF0084
        21FF008421FF0000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000008421FF42C6
        42FF42C642FF008421FF00000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000008421FF42C6
        42FF42C642FF008421FF008400FF000000000000000000000000008421FF0084
        21FF008421FF008421FF008421FF008421FF008421FF008421FF008421FF42C6
        42FF42C642FF42C642FF008421FF008421FF0000000000000000008421FF0084
        21FF84E7A5FF42E784FF42E784FF42E784FF42E784FF42E784FF42C663FF42C6
        63FF42C663FF42C642FF42C642FF42C642FF008421FF00000000008421FF0084
        21FF84E7A5FF42E784FF42E784FF42E784FF42E784FF42E784FF42C663FF42C6
        63FF42C663FF42C642FF42C642FF42C642FF008421FF008421FF008421FF0084
        21FF84E7A5FF84E7A5FF84E7A5FF84E7A5FF42E784FF42E784FF42E784FF42E7
        84FF42E784FF42C663FF42C663FF42C663FF008421FF008421FF008421FF0084
        21FF008421FF008421FF008421FF008421FF008421FF008421FF008421FF42E7
        84FF42E784FF42E784FF42C663FF008421FF008421FF00000000008421FF0084
        21FF008421FF008421FF008421FF008421FF008421FF008421FF008421FF42E7
        84FF42E784FF42E784FF008421FF008421FF0000000000000000000000000000
        0000000000000000000000000000000000000000000000000000008421FF42E7
        84FF42E784FF008421FF008421FF000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000008421FF0084
        21FF008421FF008421FF00000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000008421FF0084
        21FF008421FF0000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000
      }
    end
    object Editentry1: TMenuItem
      Action = ActEdit
      Bitmap.Data = {
        36040000424D3604000000000000360000002800000010000000100000000100
        200000000000000400006400000064000000000000000000000000000000B584
        84FFB58484FFB58484FFB58484FFB58484FFB58484FFB58484FFB58484FFB584
        84FFB58484FFB58484FFB58484FFB58484FF000000000000000000000000C6A5
        9CFFFFEFD6FFF7E7C6FFF7DEBDFFF7DEB5FFF7D6ADFFF7D6A5FFF7CE9CFFF7CE
        94FFF7CE9CFFF7CE9CFFF7D69CFFB58484FF000000000000000000000000C6A5
        9CFFFFEFDEFF001039FF4A396BFF4A3952FFF7D6B5FFF7D6ADFFF7D6A5FFEFCE
        9CFFEFCE94FFEFCE94FFF7D69CFFB58484FF000000000000000000000000C6AD
        A5FFFFF7E7FF4A3952FF524AADFF4A429CFF4A4252FFF7D6B5FFF7D6ADFFF7D6
        A5FFEFCE9CFFEFCE94FFF7D69CFFB58484FF000000000000000000000000CEAD
        A5FFFFF7EFFF4A4A63FF949CEFFF4A52BDFF4A52ADFF394252FFF7D6B5FFF7D6
        ADFFF7D6A5FFEFCE9CFFF7D69CFFB58484FF000000000000000000000000CEB5
        ADFFFFFFF7FFFFEFE7FF39427BFF8CA5F7FF4A52BDFF525AADFF424A52FFF7D6
        B5FFF7D6ADFFF7D6A5FFF7D69CFFB58484FF000000000000000000000000D6B5
        ADFFFFFFFFFFFFF7EFFFFFEFE7FF4A4A7BFF9C9CEFFF525AC6FF4A5AADFF4252
        7BFFF7D6B5FFF7D6ADFFF7D6A5FFB58484FF000000000000000000000000D6BD
        B5FFFFFFFFFFFFFFF7FFFFF7EFFFFFEFE7FF524A94FF949CEFFF526BC6FF4252
        ADFF4A5294FFF7DEB5FFF7DEADFFB58484FF000000000000000000000000DEBD
        B5FFFFFFFFFFFFFFFFFFFFFFF7FFFFF7EFFFFFEFE7FF5A5A94FFA5B5F7FF5A73
        CEFF5A63BDFF4A4A94FFFFDEB5FFB58484FF000000000000000000000000DEC6
        B5FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF7FFFFF7EFFFFFEFE7FF52528CFFA5AD
        EFFF737BCEFF5A6BBDFF525A94FFB58484FF000000000000000000000000E7C6
        B5FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF7FFFFF7EFFFFFEFE7FF6B5A
        94FFADBDEFFF5A7BBDFF528CBDFF3184C6FF000000000000000000000000E7C6
        B5FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF7FFFFF7EFFFF7E7
        D6FF526394FF6B9CC6FFA5DEFFFF3184C6FF3184C6FF0000000000000000EFCE
        BDFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFE7CE
        CEFFBD8C73FF3184C6FF3184C6FFA5E7FFFF3184C6FF0000000000000000EFCE
        BDFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFE7D6
        D6FFCE9C7BFFFFC673FF3184C6FF3184C6FF000000000000000000000000EFCE
        B5FFFFF7F7FFFFF7F7FFFFF7F7FFFFF7F7FFFFF7F7FFFFF7F7FFFFF7F7FFE7D6
        CEFFC6947BFFCE9C84FF0000000000000000000000000000000000000000EFC6
        B5FFEFCEBDFFEFCEBDFFEFCEBDFFEFCEBDFFEFCEBDFFEFCEBDFFEFCEBDFFDEBD
        B5FFBD847BFF0000000000000000000000000000000000000000
      }
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
      Bitmap.Data = {
        36040000424D3604000000000000360000002800000010000000100000000100
        2000000000000004000064000000640000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000031DEFF0031DEFF000000000031
        DEFF0031DEFF0000000000000000000000000000000000000000000000000000
        00000000000000000000000000000031DEFF0031DEFF00000000000000000031
        DEFF0031DEFF0031DEFF00000000000000000000000000000000000000000000
        000000000000000000000031DEFF0031DEFF0000000000000000000000000031
        DEFF0031DEFF0031DEFF0031DEFF000000000000000000000000000000000000
        0000000000000031DEFF0031DEFF000000000000000000000000000000000000
        00000031EFFF0031DEFF0031DEFF0031DEFF0000000000000000000000000000
        00000031DEFF0031DEFF00000000000000000000000000000000000000000000
        000000000000000000000031DEFF0031DEFF0031DEFF000000000031DEFF0031
        DEFF0031DEFF0000000000000000000000000000000000000000000000000000
        00000000000000000000000000000031DEFF0031E7FF0031E7FF0031EFFF0031
        DEFF000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000031E7FF0031E7FF0031EFFF0000
        0000000000000000000000000000000000000000000000000000000000000000
        00000000000000000000000000000031DEFF0031EFFF0031EFFF0031EFFF0031
        F7FF000000000000000000000000000000000000000000000000000000000000
        000000000000000000000031F7FF0031EFFF0031EFFF00000000000000000031
        F7FF0031FFFF0000000000000000000000000000000000000000000000000000
        0000000000000031FFFF0031EFFF0031FFFF0000000000000000000000000000
        00000031FFFF0031FFFF00000000000000000000000000000000000000000000
        00000031FFFF0031FFFF0031FFFF000000000000000000000000000000000000
        0000000000000031FFFF0031FFFF000000000000000000000000000000000031
        FFFF0031FFFF0031FFFF00000000000000000000000000000000000000000000
        00000000000000000000000000000031FFFF00000000000000000031FFFF0031
        FFFF0031FFFF0000000000000000000000000000000000000000000000000000
        00000000000000000000000000000000000000000000000000000031FFFF0031
        FFFF000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000
      }
    end
    object N3: TMenuItem
      Caption = '-'
    end
    object Save1: TMenuItem
      Action = ActSave
      Bitmap.Data = {
        36040000424D3604000000000000360000002800000010000000100000000100
        2000000000000004000064000000640000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000944239FF944239FFB59C9CFFB59C9CFFB59C9CFFB59C9CFFB59C9CFFB59C
        9CFFB59C9CFF943131FF944239FF000000000000000000000000000000009442
        39FFD66B6BFFC66363FFE7DEDEFF942929FF942929FFE7E7E7FFE7E7E7FFDEDE
        E7FFCECECEFF8C2118FFAD4242FF944239FF0000000000000000000000009442
        39FFD66363FFC65A5AFFEFE7E7FF942929FF942929FFE7E7E7FFE7E7EFFFDEE7
        E7FFCECECEFF8C2121FFAD4242FF944239FF0000000000000000000000009442
        39FFD66363FFC65A5AFFEFE7E7FF942929FF942929FFDEDEDEFFE7E7EFFFE7E7
        E7FFD6D6D6FF8C1818FFAD4242FF944239FF0000000000000000000000009442
        39FFD66363FFC65A5AFFEFE7E7FFEFE7E7FFE7DEDEFFE7DEDEFFDEE7E7FFE7E7
        E7FFD6D6D6FF942929FFB54A4AFF944239FF0000000000000000000000009442
        39FFCE6363FFCE6363FFCE6363FFCE7373FFCE7373FFC66B6BFFC66363FFCE6B
        6BFFCE6363FFC65A5AFFCE6363FF944239FF0000000000000000000000009442
        39FFB55252FFC67B7BFFD69C9CFFD6A5A5FFDEA5A5FFDEA5A5FFD6A59CFFD6A5
        9CFFD6ADA5FFDEADADFFCE6363FF944239FF0000000000000000000000009442
        39FFCE6363FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFCE6363FF944239FF0000000000000000000000009442
        39FFCE6363FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFCE6363FF944239FF0000000000000000000000009442
        39FFCE6363FFFFFFFFFFCECECEFFCECECEFFCECECEFFCECECEFFCECECEFFCECE
        CEFFCECECEFFFFFFFFFFCE6363FF944239FF0000000000000000000000009442
        39FFCE6363FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFCE6363FF944239FF0000000000000000000000009442
        39FFCE6363FFFFFFFFFFCECECEFFCECECEFFCECECEFFCECECEFFCECECEFFCECE
        CEFFCECECEFFFFFFFFFFCE6363FF944239FF0000000000000000000000009442
        39FFCE6363FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFCE6363FF944239FF0000000000000000000000000000
        0000944239FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFF944239FF000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000
      }
    end
    object Saveselected1: TMenuItem
      Action = ActSaveSelected
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object pbProperties: TMenuItem
      Action = ActProperties
      Bitmap.Data = {
        36040000424D3604000000000000360000002800000010000000100000000100
        200000000000000400006400000064000000000000000000000000000000B584
        84FFB58484FFB58484FFB58484FFB58484FFB58484FFB58484FFB58484FFB584
        84FFB58484FFB58484FFB58484FFB58484FF000000000000000000000000C6A5
        9CFFFFEFD6FFF7E7C6FFDEAD84FFDEAD84FFD6A57BFFD6A573FFD69C6BFFD69C
        6BFFD69C6BFFD69C6BFFF7D69CFFB58484FF000000000000000000000000C6A5
        9CFFFFEFDEFF9C3100FF9C3100FF9C3100FF9C3100FF9C3100FF9C3100FF9C31
        00FF9C3100FFD69C6BFFF7D69CFFB58484FF000000000000000000000000C6AD
        A5FFFFF7E7FF9C3100FFFFFFFFFFFFFFFFFFFFFFFFFF8CA5FFFFBDC6FFFFFFFF
        FFFF9C3100FFD69C6BFFF7D69CFFB58484FF000000000000000000000000CEAD
        A5FFFFF7EFFF9C3100FFFFFFFFFFFFFFFFFF7B9CFFFF0031FFFF5A7BFFFFFFFF
        FFFF9C3100FFD69C6BFFF7D69CFFB58484FF000000000000000000000000CEB5
        ADFFFFFFF7FF9C3100FFD6DEFFFF426BFFFF0031FFFF4263FFFF0031FFFFDEE7
        FFFF9C3100FFD6A573FFF7D69CFFB58484FF000000000000000000000000D6B5
        ADFFFFFFFFFF9C3100FF5273FFFF1042FFFFBDCEFFFFEFF7FFFF1842FFFF4A73
        FFFF943100FFD6A57BFFF7D6A5FFB58484FF000000000000000000000000D6BD
        B5FFFFFFFFFF9C3100FFE7EFFFFFDEE7FFFFFFFFFFFFFFFFFFFF9CADFFFF0031
        FFFF63315AFFD6A57BFFF7DEADFFB58484FF000000000000000000000000DEBD
        B5FFFFFFFFFF9C3100FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5273
        FFFF0031FFFFDEAD84FFDEAD84FFB58484FF000000000000000000000000DEC6
        B5FFFFFFFFFF9C3100FF9C3100FF9C3100FF9C3100FF9C3100FF9C3100FF8C31
        10FF2131CEFF0031FFFFD6AD84FFA5635AFF000000000000000000000000E7C6
        B5FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF7FFFFF7EFFFFFEFE7FFFFEF
        DEFFFFEFDEFF0031FFFF0031FFFF0031FFFF000000000000000000000000E7C6
        B5FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF7FFFFF7EFFFF7E7
        D6FFC6A594FFB5948CFFB58C84FF0031FFFF000000000000000000000000EFCE
        BDFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFE7CE
        CEFFBD8C73FFEFB573FFEFA54AFFC6846BFF000000000000000000000000EFCE
        BDFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFE7D6
        D6FFCE9C7BFFFFC673FFCE9473FF00000000000000000000000000000000EFCE
        B5FFFFF7F7FFFFF7F7FFFFF7F7FFFFF7F7FFFFF7F7FFFFF7F7FFFFF7F7FFE7D6
        CEFFC6947BFFCE9C84FF0000000000000000000000000000000000000000EFC6
        B5FFEFCEBDFFEFCEBDFFEFCEBDFFEFCEBDFFEFCEBDFFEFCEBDFFEFCEBDFFDEBD
        B5FFBD847BFF0000000000000000000000000000000000000000
      }
    end
  end
  object ActionList: TActionList
    Images = MainFrm.ImageList
    OnUpdate = ActionListUpdate
    left = 96
    top = 424
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
      Hint = 'Close'
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
    left = 136
    top = 424
  end
end
