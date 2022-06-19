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
  LCLVersion = '2.2.2.0'
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
      ClientHeight = 256
      ClientWidth = 422
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      ParentFont = False
      object Label1: TLabel
        Left = 3
        Height = 14
        Top = 16
        Width = 122
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
      ClientHeight = 256
      ClientWidth = 422
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
        Height = 14
        Top = 215
        Width = 3
        Caption = ' '
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        ParentColor = False
        ParentFont = False
      end
      object Label4: TLabel
        Left = 16
        Height = 14
        Top = 237
        Width = 376
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
        OnDrawCell = TimeGridDrawCell
        OnMouseLeave = TimeGridMouseLeave
        OnMouseMove = TimeGridMouseMove
        OnSelectCell = TimeGridSelectCell
      end
    end
  end
  object ImageList1: TImageList
    Left = 376
    Top = 200
    Bitmap = {
      4C7A010000001000000010000000460200000000000078DA7593EB4FD25118C7
      FD9F7A53EBBD6F7A516C2DB76CD92AE6BCE4D42D2B7336A46232892C0B342FA8
      E1A5CD0B8A5AA2603F588A211741284540C00BD351D3D6665B7D3AE17A25BF67
      7BF6DD79763EDFF39C67E714149C8EDD749AD44694EDF57536DDCB846D363EF5
      F49008AC522013C16090482884C7E92420521A196161B097CF933D44A52E62B3
      CFE97FA822E2F1E7F558F5F9B098F4F83FB492F2F7717C6487DF6EF825C1F711
      48BFA6ABB296C5F7F6BC7CD0E361DFDB01312DEC750B66148EAC42C720638278
      0BE6EA1AE6862D79F9757F803DCF20441A727BD936C26EE7892674A2DE88E371
      3513DD0379F9B498576A7112BCE510BA0F5F55B0A13ED1B507A25EC1D2D352FA
      B56DB233F48C8A9E9D57C07D1356CA724C4E976F81AB88D4AB6B181B34B27CC4
      3647764CF0F60BF05121BC2E9FA8581FCF5CE44B7305DAF27BB27CD4E9626FB0
      0426CEC0D439983ECF8FB91A1243CDCCD437F2ECAA92B6BA26597E27B4C6CEDB
      52FE58CEF2537A446CD48CADAA8ABEC2429A8A959834ADF89D4BB2FCB6783F3E
      A39EA8D54AC06CC66D30D02ED87FD95D5689343E2DCBEEC76264B359BE6D6D71
      78784852E89AF0312B95B42B144CA954CCE85F928EC6F37A6C89B333994C8E3D
      3838202EFC2292C4AC5E4F7B7131536A35568D96E9BE7779F9CC668CB0D74B32
      9924118FB3110E13B4DB71984CF48A19CC0B1FDDED3B0CBF78237B07DFFC0216
      6327AE710B6ED1FBA2F8438E8E0E86544FD0DCA84057552FFBFEFF47C8ED65A0
      C580AAA4923A4509772F5DA7BE4849975AC78AC3758AFD0B3FA5F8D8
    }
  end
end
