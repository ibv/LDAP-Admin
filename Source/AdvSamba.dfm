object SambaAdvancedDlg: TSambaAdvancedDlg
  Left = 245
  Height = 425
  Top = 108
  Width = 448
  BorderStyle = bsDialog
  Caption = 'Advanced Samba settings'
  ClientHeight = 425
  ClientWidth = 448
  Color = clBtnFace
  OnClose = FormClose
  ParentFont = True
  Position = poScreenCenter
  LCLVersion = '2.2.2.0'
  object Bevel1: TBevel
    Left = 16
    Height = 209
    Top = 160
    Width = 417
  end
  object Label1: TLabel
    Left = 32
    Height = 15
    Top = 174
    Width = 130
    Caption = 'Allowed workstations:'
    ParentColor = False
  end
  object OKBtn: TButton
    Left = 143
    Height = 25
    Top = 388
    Width = 75
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 0
  end
  object CancelBtn: TButton
    Left = 231
    Height = 25
    Top = 388
    Width = 75
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 1
  end
  object FlagsGroup: TGroupBox
    Left = 232
    Height = 129
    Top = 16
    Width = 201
    Caption = 'Additional Samba flags:'
    ClientHeight = 113
    ClientWidth = 199
    TabOrder = 2
    object cbNoExpire: TCheckBox
      Left = 9
      Height = 21
      Top = 5
      Width = 165
      Caption = 'No password expiration'
      TabOrder = 0
    end
    object cbDomTrust: TCheckBox
      Left = 9
      Height = 21
      Top = 29
      Width = 156
      Caption = 'Domain trust account'
      TabOrder = 1
    end
    object cbHomeReq: TCheckBox
      Left = 9
      Height = 21
      Top = 53
      Width = 172
      Caption = 'Home directory required'
      TabOrder = 2
    end
    object cbServerTrust: TCheckBox
      Left = 9
      Height = 21
      Top = 79
      Width = 149
      Caption = 'Server trust account'
      TabOrder = 3
    end
  end
  object AddBtn: TButton
    Left = 352
    Height = 25
    Top = 190
    Width = 73
    Caption = 'Add...'
    OnClick = AddBtnClick
    TabOrder = 3
  end
  object RemoveBtn: TButton
    Left = 352
    Height = 25
    Top = 230
    Width = 73
    Caption = 'Remove'
    Enabled = False
    OnClick = RemoveBtnClick
    TabOrder = 4
  end
  object GroupBox1: TGroupBox
    Left = 16
    Height = 129
    Top = 17
    Width = 201
    Caption = 'Samba account expires:'
    ClientHeight = 113
    ClientWidth = 199
    TabOrder = 5
    object rbNever: TRadioButton
      Left = 16
      Height = 21
      Top = 4
      Width = 59
      Caption = 'Never'
      Checked = True
      OnClick = rbNeverClick
      TabOrder = 0
      TabStop = True
    end
    object rbAt: TRadioButton
      Left = 16
      Height = 21
      Top = 36
      Width = 45
      Caption = 'On:'
      OnClick = rbAtClick
      TabOrder = 1
    end
    object DatePicker: TDateTimePicker
      Left = 80
      Height = 21
      Top = 36
      Width = 95
      CenturyFrom = 1941
      MaxDate = 2958465
      MinDate = -53780
      TabOrder = 2
      Enabled = False
      Color = clBtnFace
      TrailingSeparator = False
      TextForNullDate = 'NULL'
      LeadingZeros = True
      Kind = dtkDate
      TimeFormat = tf24
      TimeDisplay = tdHMS
      DateMode = dmComboBox
      Date = 38076
      Time = 0.771625092602335
      UseDefaultSeparators = True
      HideDateTimeParts = []
      MonthNames = 'Long'
      CalAlignment = dtaLeft
    end
    object TimePicker: TDateTimePicker
      Left = 80
      Height = 21
      Top = 64
      Width = 77
      CenturyFrom = 1941
      MaxDate = 2958465
      MinDate = -53780
      TabOrder = 3
      Enabled = False
      Color = clBtnFace
      TrailingSeparator = False
      TextForNullDate = 'NULL'
      LeadingZeros = True
      Kind = dtkTime
      TimeFormat = tf24
      TimeDisplay = tdHMS
      DateMode = dmComboBox
      Date = 38525
      UseDefaultSeparators = True
      HideDateTimeParts = []
      MonthNames = 'Long'
      CalAlignment = dtaLeft
    end
  end
  object wsList: TListView
    Left = 32
    Height = 161
    Top = 190
    Width = 305
    Columns = <>
    MultiSelect = True
    ReadOnly = True
    ScrollBars = ssAutoBoth
    SmallImages = ImageList1
    SortType = stText
    TabOrder = 6
    OnSelectItem = wsListSelectItem
  end
  object ImageList1: TImageList
    Left = 40
    Top = 320
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
