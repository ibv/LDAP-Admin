inherited PickupDlg: TPickupDlg
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  inherited Panel1: TPanel
    object FilterLbl: TLabel[0]
      Left = 9
      Top = 252
      Width = 28
      Height = 13
      Anchors = [akLeft, akBottom]
      Caption = '&Filter:'
      FocusControl = FilterEdit
    end
    inherited ListView: TListView
      OwnerData = True
      OnData = ListViewData
    end
    object FilterEdit: TEdit
      Left = 36
      Top = 249
      Width = 217
      Height = 21
      Anchors = [akLeft, akRight, akBottom]
      TabOrder = 3
      OnChange = FilterEditChange
    end
  end
end
