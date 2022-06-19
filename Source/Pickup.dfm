inherited PickupDlg: TPickupDlg
  OnClose = FormClose
  OnCreate = FormCreate
  inherited Panel1: TPanel
    inherited ListView: TListView
      Height = 231
      Columns = <      
        item
          Width = 160
        end      
        item
          Width = 326
        end>
      OwnerData = True
      OnData = ListViewData
    end
    object FilterLbl: TLabel[3]
      Left = 9
      Height = 15
      Top = 250
      Width = 33
      Anchors = [akLeft, akBottom]
      Caption = '&Filter:'
      FocusControl = FilterEdit
      ParentColor = False
    end
    object FilterEdit: TEdit[4]
      Left = 46
      Height = 31
      Top = 239
      Width = 217
      Anchors = [akLeft, akRight, akBottom]
      OnChange = FilterEditChange
      TabOrder = 3
    end
  end
end
