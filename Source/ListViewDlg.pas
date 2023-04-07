  {      LDAPAdmin - ListViewDlg.pas
  *      Copyright (C) 2014 Tihomir Karlovic
  *
  *      Author: Tihomir Karlovic
  *
  *
  * This file is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
  * the Free Software Foundation; either version 2 of the License, or
  * (at your option) any later version.
  *
  * This file is distributed in the hope that it will be useful,
  * but WITHOUT ANY WARRANTY; without even the implied warranty of
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
  * You should have received a copy of the GNU General Public License
  * along with this program; if not, write to the Free Software
  * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA
  }

unit ListViewDlg;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
{$IFnDEF FPC}
  Windows,
{$ELSE}
  LCLIntf, LCLType, LMessages,
{$ENDIF}
  SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ExtCtrls, ComCtrls, LDAPClasses, ImgList, Sorter, Math, mormot.core.base;

type
  TListViewDlg = class(TForm)
    Panel1: TPanel;
    ListView: TListView;
    OKBtn: TButton;
    CancelBtn: TButton;
    procedure         ListViewDblClick(Sender: TObject);
    procedure         ListViewChange(Sender: TObject; Item: TListItem; Change: TItemChange);
  private
    procedure         DoSort(SortColumn:  TListColumn; SortAsc: boolean);
    function          GetColumns: TListColumns;
    function          GetImages: TCustomImageList;
    procedure         SetImages(const Value: TCustomImageList);
    function          GetMultiSelect: boolean;
    procedure         SetMultiSelect(const Value: boolean);
    function          GetColumnNames: RawUtf8;
    procedure         SetColumnNames(AValue: RawUtf8);
  protected
    FSorter:          TListViewSorter;
    FColumnNames:     TStringList;
    procedure         DoShow; override;
  public
    constructor       Create(AOwner: TComponent); override;
    destructor        Destroy; override;

    property          Images: TCustomImageList read GetImages write SetImages;
    property          Columns: TListColumns read GetColumns;
    property          MultiSelect: boolean read GetMultiSelect write SetMultiSelect;
    property          ColumnNames: RawUtf8 read GetColumnNames write SetColumnNames;
  end;

implementation

{$R *.dfm}

uses LinLDAP, Constant, Main, Connection, SizeGrip;

constructor TListViewDlg.Create(AOwner: TComponent);
begin
  inherited;
  FColumnNames := TStringList.Create;
end;

destructor TListViewDlg.Destroy;
begin
  FSorter.Free;
  FColumnNames.Free;
  inherited;
end;

procedure TListViewDlg.DoShow;
begin
  TSizeGrip.Create(Panel1);
  FSorter := TListViewSorter.Create;
  FSorter.ListView := self.ListView;
  FSorter.OnSort := DoSort;
  inherited;
end;

procedure TListViewDlg.ListViewDblClick(Sender: TObject);
begin
  ModalResult := mrOk
end;

function TListViewDlg.GetColumns: TListColumns;
begin
  result := ListView.Columns;
end;

function TListViewDlg.GetImages: TCustomImageList;
begin
  result := ListView.SmallImages;
end;

procedure TListViewDlg.SetImages(const Value: TCustomImageList);
begin
  ListView.SmallImages:=Value;
end;

function TListViewDlg.GetMultiSelect: boolean;
begin
  result := ListView.MultiSelect;
end;

procedure TListViewDlg.setMultiSelect(const Value: boolean);
begin
  ListView.MultiSelect := Value;
end;

procedure TListViewDlg.ListViewChange(Sender: TObject; Item: TListItem; Change: TItemChange);
begin
  OkBtn.Enabled := ListView.SelCount>0;
end;

function TListViewDlg.GetColumnNames: RawUtf8;
begin
  Result := FColumnNames.CommaTExt;
end;

procedure TListViewDlg.SetColumnNames(AValue: RawUtf8);
begin
  FColumnNames.CommaText := AValue;
end;

procedure TListViewDlg.DoSort(SortColumn: TListColumn; SortAsc: boolean);
begin
  ListView.AlphaSort;
end;

end.
