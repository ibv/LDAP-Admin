object ListViewDlg: TListViewDlg
  Left = 263
  Height = 280
  Top = 208
  Width = 504
  ClientHeight = 280
  ClientWidth = 504
  Color = clBtnFace
  ParentFont = True
  Position = poOwnerFormCenter
  LCLVersion = '1.6.0.4'
  object Panel1: TPanel
    Left = 0
    Height = 280
    Top = 0
    Width = 504
    Align = alClient
    BevelOuter = bvNone
    BorderWidth = 8
    ClientHeight = 280
    ClientWidth = 504
    TabOrder = 0
    object ListView: TListView
      Left = 8
      Height = 232
      Top = 8
      Width = 488
      Align = alTop
      Anchors = [akTop, akLeft, akRight, akBottom]
      Columns = <      
        item
          Width = 160
        end      
        item
          Width = 320
        end>
      HideSelection = False
      MultiSelect = True
      ReadOnly = True
      RowSelect = True
      ScrollBars = ssAutoBoth
      TabOrder = 0
      ViewStyle = vsReport
      OnChange = ListViewChange
      OnDblClick = ListViewDblClick
    end
    object OKBtn: TButton
      Left = 332
      Height = 25
      Top = 247
      Width = 75
      Anchors = [akRight, akBottom]
      Caption = '&OK'
      Default = True
      Enabled = False
      ModalResult = 1
      TabOrder = 1
    end
    object CancelBtn: TButton
      Left = 413
      Height = 25
      Top = 247
      Width = 75
      Anchors = [akRight, akBottom]
      Cancel = True
      Caption = '&Cancel'
      ModalResult = 2
      TabOrder = 2
    end
  end
end
