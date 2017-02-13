object AdAdvancedDlg: TAdAdvancedDlg
  Left = 245
  Height = 329
  Top = 108
  Width = 448
  BorderStyle = bsDialog
  Caption = 'Additional settings'
  ClientHeight = 329
  ClientWidth = 448
  Color = clBtnFace
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  OnClose = FormClose
  Position = poScreenCenter
  LCLVersion = '1.6.2.0'
  object OKBtn: TButton
    Left = 136
    Height = 25
    Top = 296
    Width = 81
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 0
  end
  object CancelBtn: TButton
    Left = 223
    Height = 25
    Top = 296
    Width = 82
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 1
  end
  object PageControl: TPageControl
    Left = 8
    Height = 282
    Top = 8
    Width = 432
    ActivePage = TabSheet1
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    ParentFont = False
    TabIndex = 0
    TabOrder = 2
    OnChange = PageControlChange
    object TabSheet1: TTabSheet
      Caption = 'Logon  &to'
      ClientHeight = 247
      ClientWidth = 424
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      ParentFont = False
      object Label1: TLabel
        Left = 3
        Height = 13
        Top = 16
        Width = 124
        Caption = 'Allowed workstations:'
        ParentColor = False
      end
      object wsList: TListView
        Left = 3
        Height = 207
        Top = 35
        Width = 326
        Columns = <>
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        MultiSelect = True
        ParentFont = False
        ReadOnly = True
        ScrollBars = ssAutoBoth
        SmallImages = ImageList1
        SortType = stText
        TabOrder = 0
        OnSelectItem = wsListSelectItem
      end
      object RemoveBtn: TButton
        Left = 335
        Height = 25
        Top = 66
        Width = 86
        Caption = 'Remove'
        Enabled = False
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        OnClick = RemoveBtnClick
        ParentFont = False
        TabOrder = 1
      end
      object AddBtn: TButton
        Left = 335
        Height = 25
        Top = 35
        Width = 86
        Caption = 'Add...'
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        OnClick = AddBtnClick
        ParentFont = False
        TabOrder = 2
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'Logon hours'
      ClientHeight = 247
      ClientWidth = 424
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      ImageIndex = 1
      ParentFont = False
      object TimeScale: TImage
        Left = 16
        Height = 14
        Top = 3
        Width = 405
      end
      object Label2: TLabel
        Left = 16
        Height = 13
        Top = 215
        Width = 4
        Caption = ' '
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        ParentColor = False
        ParentFont = False
      end
      object Label4: TLabel
        Left = 16
        Height = 13
        Top = 237
        Width = 394
        Caption = 'Mouse or Space to toggle, hold Left-Ctrl to allow, Left-Shift to restrict'
        Font.Color = clGrayText
        Font.Height = -11
        Font.Name = 'Tahoma'
        ParentColor = False
        ParentFont = False
      end
      object TimeGrid: TStringGrid
        Left = 16
        Height = 190
        Top = 19
        Width = 393
        ColCount = 25
        DefaultColWidth = 12
        DefaultRowHeight = 22
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine]
        ParentFont = False
        RowCount = 8
        TabOrder = 0
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'Tahoma'
        OnDrawCell = TimeGridDrawCell
        OnMouseLeave = TimeGridMouseLeave
        OnMouseMove = TimeGridMouseMove
        OnSelectCell = TimeGridSelectCell
      end
    end
  end
  object ImageList1: TImageList
    left = 376
    top = 200
    Bitmap = {
      4C69010000001000000010000000000000000000000000000000000000000000
      0000E7E4E4FFE3DBDCFFE5DADAFFDDC9CAFFD6BBBBFFC69F9FFFE0D1D2FF0000
      00000000000000000000000000000000000000000000D3D3D3FFD7D4D4FFCCC3
      C3FFD1C3C3FFC2ADADFFC0A7A1FFCBB39FFFDCC29DFFDEBA90FFA37B81FFD7CC
      D0FF0000000000000000000000000000000000000000D2CFCFFFB1A08FFFD0B9
      91FFE3D0A2FFF9F3BEFFFFFDC9FFFFFAC2FFFFF0ADFFFFE496FF9D6C72FFC7B8
      BEFF0000000000000000000000000000000000000000D3CCCCFFEBCE9AFFFFDE
      8AFFFFE89EFFFFF0AEFFFFF3B4FFFFF0AFFFFFE9A0FFFFDF8CFFA57071FFBCA9
      B1FF0000000000000000000000000000000000000000DAD0D1FFE8CCA7FFFFD7
      7CFFFFDF8CFFFFE598FFFFE79CFFFFE598FFFFE08DFFFFD77EFFBF8470FFB29E
      A6FF0000000000000000000000000000000000000000E4DBDCFFE3C7B3FFFFCE
      6AFFFFD478FFFFD981FFFFDB83FFFFD981FFFFD579FFFFCE6BFFC88667FFA38A
      94FF000000000000000000000000000000000000000000000000CCAEAEFFFFC3
      56FFFFC962FFFFCD69FFFFCE6BFFFFCD69FFFFCA63FFFFC457FFE3955CFF987C
      87FF000000000000000000000000000000000000000000000000D7BBBCFFEEAF
      56FFFFBE4BFFFFC151FFFFC354FFFFC151FFFFBE4BFFF9B74FFFD8896BFF8A6A
      77FF000000000000000000000000000000000000000000000000DCC3C4FFE8A7
      5FFFFFB233FFFFB539FFFFB63BFFF4BC71FFE0A889FFB77A7EFF8E5A65FF9476
      82FF000000000000000000000000000000000000000000000000E6D4D5FFE6A4
      67FFFEB138FFF6C27FFFDEAEA5FFBB6E6EFFA24646FF825B65FFA08791FFD0C3
      C8FF000000000000000000000000000000000000000000000000E5D4D4FFCF98
      8FFFDCB4B4FFD1A5A5FFC99797FF994646FF994646FF9E696CFFC2B0B6FF0000
      00000000000000000000000000000000000000000000EBDEDEFFEEEEEEFFEFE1
      E1FFF2F2F2FFE2E1E1FFD5B4B4FFA56565FF995151FFB58181FFB78F93FFE4DC
      DFFF0000000000000000000000000000000000000000E1D4D4FFE9E9E9FFF2F2
      F2FFECECECFFDFDEDEFFD7C2C2FFBA8F8FFF995B5BFFB58383FFB4878AFFB6A2
      AAFF0000000000000000000000000000000000000000E9DDDEFFD6CECEFFE2E2
      E2FFE0DFDFFFDBD6D6FFD3BEBEFFBFA0A0FFA16E6EFFBD8F8FFF8D646DFFA992
      9BFF000000000000000000000000000000000000000000000000CFBDC0FFB198
      9CFFC4B0B1FFC9B4B4FFC7ADADFFBF9A9AFFA88185FF87606BFF8D6E7AFFC7B8
      BEFF00000000000000000000000000000000000000000000000000000000D4C9
      CEFFA68C97FF815F6CFF76515FFF75505EFF7A5765FF9D838DFFCDBFC4FF0000
      0000000000000000000000000000
    }
  end
end
