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
  LCLVersion = '1.6.0.4'
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
    Width = 136
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
    ClientHeight = 98
    ClientWidth = 197
    TabOrder = 2
    object cbNoExpire: TCheckBox
      Left = 9
      Height = 26
      Top = 5
      Width = 177
      Caption = 'No password expiration'
      TabOrder = 0
    end
    object cbDomTrust: TCheckBox
      Left = 9
      Height = 26
      Top = 29
      Width = 167
      Caption = 'Domain trust account'
      TabOrder = 1
    end
    object cbHomeReq: TCheckBox
      Left = 9
      Height = 26
      Top = 53
      Width = 184
      Caption = 'Home directory required'
      TabOrder = 2
    end
    object cbServerTrust: TCheckBox
      Left = 16
      Height = 26
      Top = 96
      Width = 159
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
    ClientHeight = 98
    ClientWidth = 197
    TabOrder = 5
    object rbNever: TRadioButton
      Left = 16
      Height = 26
      Top = 4
      Width = 66
      Caption = 'Never'
      Checked = True
      OnClick = rbNeverClick
      TabOrder = 0
      TabStop = True
    end
    object rbAt: TRadioButton
      Left = 16
      Height = 26
      Top = 36
      Width = 50
      Caption = 'On:'
      OnClick = rbAtClick
      TabOrder = 1
    end
    object DatePicker: TDateTimePicker
      Left = 80
      Height = 23
      Top = 36
      Width = 97
      CenturyFrom = 1941
      MaxDate = 2958465
      MinDate = -53780
      TabOrder = 2
      Enabled = False
      Color = clBtnFace
      TrailingSeparator = False
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
      Height = 23
      Top = 64
      Width = 79
      CenturyFrom = 1941
      MaxDate = 2958465
      MinDate = -53780
      TabOrder = 3
      Enabled = False
      Color = clBtnFace
      TrailingSeparator = False
      LeadingZeros = True
      Kind = dtkTime
      TimeFormat = tf24
      TimeDisplay = tdHMS
      DateMode = dmComboBox
      Date = 38525
      Time = 0
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
    left = 40
    top = 320
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
