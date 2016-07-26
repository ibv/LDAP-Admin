  {      LDAPAdmin - Bookmarks.pas
  *      Copyright (C) 2015-2016 Tihomir Karlovic
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

unit Bookmarks;

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
  Buttons, ExtCtrls, ComCtrls, Menus, LdapClasses, Sorter;

type
  TBookmarks = class
  private
    FSession: TLdapSession; // have to use Session here to avoid cicular references
    FMenu: TPopupMenu;
    FBookmarks: TStringList;
    procedure MenuPopup(Sender: TObject);
    procedure BookmarkClick(Sender: TObject);
    function GetItems: TStringList;
    procedure InitMenu;
    function GetImageIndex(Index: Integer): Integer;
  public
    constructor Create(Session: TLdapSession);
    destructor  Destroy; override;
    property Items: TStringList read GetItems;
    property Menu: TPopupMenu read FMenu;
    property Images[Index: Integer]: Integer read GetImageIndex;
  end;

  TBookmarkDlg = class(TForm)
    btnCancel: TButton;
    BookmarkList: TListView;
    btnRemove: TBitBtn;
    btnAdd: TBitBtn;
    btnOk: TButton;
    btnGoto: TBitBtn;
    procedure BookmarkListSelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure btnAddClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnRemoveClick(Sender: TObject);
    procedure BookmarkListClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnGotoClick(Sender: TObject);
    procedure BookmarkListData(Sender: TObject; Item: TListItem);
    procedure BookmarkListDblClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure BookmarkListCustomDrawItem(Sender: TCustomListView;
      Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean);
  private
    FBookmarks: TBookmarks;
    FModified: Boolean;
    FSorter: TListViewSorter;
    procedure SetModified(Value: Boolean);
    procedure ListViewSort(SortColumn:  TListColumn; SortAsc: boolean);
  public
    constructor Create(AOwner: TComponent; Bookmarks: TBookmarks); reintroduce;
    property    Modified: Boolean read fModified write SetModified;
  end;

var
  BookmarkDlg: TBookmarkDlg;

implementation

{$R *.dfm}

uses Main, Constant, Dialogs, Connection, ObjectInfo;

procedure TBookmarks.MenuPopup(Sender: TObject);
var
  i: Integer;
  mi: TMenuItem;
begin
  if FMenu.Items.Count = 0 then
  begin
    FBookmarks.Sorted := true;
    for i := 0 to FBookmarks.Count - 1 do
    begin
      mi := TMenuItem.Create(FMenu);
      mi.OnClick := BookmarkClick;
      mi.Caption := FBookmarks[i];
      mi.ImageIndex := Images[i];
      if mi.ImageIndex = -1 then
        mi.Enabled := false;
      FMenu.Items.Add(mi);
    end;
  end;
end;

procedure TBookmarks.BookmarkClick(Sender: TObject);
begin
  MainFrm.LocateEntry((Sender as TMenuItem).Caption, true);
end;

function TBookmarks.GetItems: TStringList;
begin
  Result := FBookmarks;
end;

procedure TBookmarks.InitMenu;
begin
  if FBookmarks.Count > 0 then
  begin
    if not Assigned(FMenu) then
    begin
      FMenu := TPopupMenu.Create(nil);
      ///FMenu.AutoHotkeys:= maManual;
      FMenu.OnPopup := MenuPopup;
      FMenu.Images := MainFrm.ImageList;
    end
    else
      FMenu.Items.Clear;
  end
  else
    FreeAndNil(FMenu);
end;

function TBookmarks.GetImageIndex(Index: Integer): Integer;
var
  Entry: TLdapEntry;
  oi: TObjectInfo;
begin
  if FBookmarks.Objects[Index] = nil then
  begin
    Entry := TLdapEntry.Create(FSession, FBookmarks[Index]);
    try
      Entry.Read;
      oi := TObjectInfo.Create(Entry, false);
      try
        FBookmarks.Objects[Index] := Pointer(oi.ImageIndex);
      finally
        oi.Free;
      end;
    except;
      FBookmarks.Objects[Index] := Pointer(-1);
    end;
    Entry.Free;
  end;
  Result := Integer(FBookmarks.Objects[Index]);
end;

constructor TBookmarks.Create(Session: TLdapSession);
begin
  FSession := Session;
  FBookmarks := TStringList.Create;
  FBookmarks.CommaText := (Session as TConnection).Account.ReadString(rBookmarks);
  InitMenu;
end;

destructor TBookmarks.Destroy;
begin
  (FSession as TConnection).Account.WriteString(rBookmarks, FBookmarks.CommaText);
  FBookmarks.Free;
  FMenu.Free;
  inherited;
end;

procedure TBookmarkDlg.SetModified(Value: Boolean);
begin
  if Value and not fModified then
  begin
    btnOk.Visible := true;
    btnCancel.Caption := cCancel;
  end;
  fModified := Value;
  BookmarkListClick(nil);
end;

constructor TBookmarkDlg.Create(AOwner: TComponent; Bookmarks: TBookmarks);
var
  ls: TStringList;
  i: Integer;
begin
  inherited Create(AOwner);
  FBookmarks := Bookmarks;
  BookmarkList.Items.Count := FBookmarks.Items.Count;
  BookmarkList.SmallImages := MainFrm.ImageList;
  FSorter := TListViewSorter.Create;
  FSorter.ListView := BookmarkList;
  FSorter.OnSort := ListViewSort;
end;

procedure TBookmarkDlg.BookmarkListClick(Sender: TObject);
begin
  btnRemove.Enabled := BookmarkList.Selected <> nil;
  btnGoto.Enabled := BookmarkList.ItemFocused <> nil;
end;

procedure TBookmarkDlg.BookmarkListCustomDrawItem(Sender: TCustomListView;
  Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean);
begin
  if Item.ImageIndex = -1 then
  begin
    Sender.Canvas.Font.Color := clGrayText;
    Sender.Canvas.Font.Style := Sender.Canvas.Font.Style + [fsItalic];
  end;
end;

procedure TBookmarkDlg.BookmarkListData(Sender: TObject; Item: TListItem);
begin
  Item.Caption := FBookmarks.Items[Item.Index];
  Item.ImageIndex := FBookmarks.Images[Item.Index];
end;

procedure TBookmarkDlg.BookmarkListDblClick(Sender: TObject);
begin
  btnGotoClick(nil);
end;

procedure TBookmarkDlg.BookmarkListSelectItem(Sender: TObject; Item: TListItem; Selected: Boolean);
begin
  btnRemove.Enabled := true;
end;

procedure TBookmarkDlg.FormClose(Sender: TObject; var Action: TCloseAction);
var
  i: Integer;
  s: string;
begin
  if fModified then
  begin
    if ModalResult <> mrOk then
      FBookmarks.Items.CommaText := (FBookmarks.FSession as TConnection).Account.ReadString(rBookmarks); // reset
    FBookmarks.InitMenu;
  end;
end;

procedure TBookmarkDlg.FormDestroy(Sender: TObject);
begin
  FSorter.Free;
end;

procedure TBookmarkDlg.FormShow(Sender: TObject);
begin
  if BookmarkList.Items.Count > 0 then
  begin
    BookmarkList.Items[0].Selected := true;
    BookmarkList.ItemFocused := BookmarkList.Items[0];
  end;
  BookmarkListClick(nil);
end;

procedure TBookmarkDlg.btnAddClick(Sender: TObject);
var
  s: string;
begin
  s := MainFrm.PickEntry(cSearchBase);
  if s <> '' then
  begin
    //BookmarkList.Items.Add.Caption := s;
    FBookmarks.Items.Add(s);
    BookmarkList.Items.Count := FBookmarks.Items.Count;
    Modified := true;
  end;
end;

procedure TBookmarkDlg.btnGotoClick(Sender: TObject);
begin
  MainFrm.LocateEntry(BookmarkList.ItemFocused.Caption, true);
end;

procedure TBookmarkDlg.btnRemoveClick(Sender: TObject);
begin
  //BookmarkList.Selected.Delete;
  FBookmarks.Items.Delete(BookmarkList.ItemIndex);
  BookmarkList.Items.Count := FBookmarks.Items.Count;
  Modified := true;
end;

var
  _gAscending: Boolean;

function  DoSort(List: TStringList; Index1, Index2: Integer): Integer;
begin
  Result := AnsiCompareText(List[Index1], List[Index2]);
  if not _gAscending then
    Result := -Result;
end;

procedure TBookmarkDlg.ListViewSort(SortColumn: TListColumn; SortAsc: boolean);
begin
  _gAscending := SortAsc;
  FBookmarks.Items.Sorted := false;
  FBookmarks.Items.CustomSort(DoSort);
  BookmarkList.Repaint;
end;

end.
