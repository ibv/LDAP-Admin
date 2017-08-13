  {      LDAPAdmin - Pickup.pas
  *      Copyright (C) 2003 - 2014 Tihomir Karlovic
  *
  *      Author: Tihomir Karlovic & Alexander Sokoloff
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

unit Pickup;

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
  Buttons, ExtCtrls, ComCtrls, LDAPClasses, ImgList, Sorter, Math,
  ListViewDlg;

type
  TPopulateColumn = record
    Attribute: string;
    DataType:  TLdapAttributeSortType;
  end;

  TPopulateColumns = array of TPopulateColumn;

  TOnGetImageIndex= procedure(const Entry: TLdapEntry; var ImageIndex: integer) of object;

  TPickupDlg = class(TListViewDlg)
    FilterLbl: TLabel;
    FilterEdit: TEdit;
    procedure         FilterEditChange(Sender: TObject);
    procedure         ListViewData(Sender: TObject; Item: TListItem);
    procedure         FormClose(Sender: TObject; var Action: TCloseAction);
    procedure         FormCreate(Sender: TObject);
  private
    FPopulates:       array of TPopulateColumns;
    FOnGetImageIndex: TOnGetImageIndex;
    FEntries:         TLdapEntryList;
    FShowed:          TList;
    FSelected:        TList;
    FImageIndex:      integer;
    procedure         FillListView;
    procedure         DoSort(SortColumn:  TListColumn; SortAsc: boolean);
    function          GetText(Index: integer; Entry: TLdapEntry): string;
    function          GetSelCount: integer;
    function          GetSelected(Index: integer): TLdapEntry;
  protected
    procedure         DoShow; override;
  public
    constructor       Create(AOwner: TComponent); override;
    destructor        Destroy; override;
    procedure         Populate(const Session: TLDAPSession; const Filter: string; const Attributes: array of string; const Base: string = '');

    property          Entries:  TLdapEntryList read FEntries;
    property          ImageIndex: integer read FImageIndex write FImageIndex;
    property          OnGetImageIndex: TOnGetImageIndex read FOnGetImageIndex write FOnGetImageIndex;
    property          Selected[Index: integer]: TLdapEntry read GetSelected;
    property          SelCount: integer read GetSelCount;
  end;

implementation

{$R *.dfm}

uses {$ifdef mswindows}WinLDAP,{$else} LinLDAP,{$endif} Constant, Main, Connection, SizeGrip;

constructor TPickupDlg.Create(AOwner: TComponent);
begin
  inherited;
  FImageIndex:=-1;
  FEntries:=TLdapEntryList.Create;
  FShowed:=TList.Create;
  FSelected:=TList.Create;
  setlength(FPopulates,0);
end;

destructor TPickupDlg.Destroy;
begin
  FShowed.Free;
  setlength(FPopulates,0);
  FEntries.Free;
  FSelected.Free;
  inherited;
end;

procedure TPickupDlg.DoShow;
begin
  FillListView;
  inherited;
  FSorter.OnSort:=DoSort;
end;

procedure TPickupDlg.Populate(const Session: TLDAPSession; const Filter: string; const Attributes: array of string; const Base: string = '');
var
  i: integer;
  popIdx: integer;
  attrs: PCharArray;
  len: Integer;
  aBase: string;
begin
  popIdx:=length(FPopulates);
  setlength(FPopulates, popIdx+1);
  setlength(FPopulates[popIdx],length(Attributes));
  //////////////////////////////////////////////////////////////////////////////
  for i:=0 to length(Attributes)-1 do begin
    FPopulates[popIdx][i].DataType:=GetAttributeSortType(Attributes[i]);
    FPopulates[popIdx][i].Attribute:=Attributes[i];
  end;
  //////////////////////////////////////////////////////////////////////////////

  with ListView, Columns do
  try
    BeginUpdate;
    for i := Count to length(Attributes) - 1 do
      Add;
    for i := 0 to Min(FColumnNames.Count, Count) - 1 do
      Columns[i].Caption := FColumnNames[i];
  finally
    EndUpdate;
  end;

  attrs := nil;
  len := Length(Attributes);
  if ImageIndex = -1 then
    inc(len);
  if Len > 0 then
  begin
    SetLength(attrs, len + 1);
    attrs[len] := nil;
    if ImageIndex = -1 then
    begin
      dec(len);
      attrs[len] := 'objectclass';
    end;
    repeat
      dec(len);
      attrs[len] := PChar(Attributes[len]);
    until len = 0;
  end;
  if Base = '' then
    aBase := Session.Base
  else
    aBase := Base;
  Session.Search(Filter, aBase, LDAP_SCOPE_SUBTREE, attrs, false, FEntries);
end;

procedure TPickupDlg.FilterEditChange(Sender: TObject);
begin
  FillListView;
end;

function  TPickupDlg.GetText(Index: integer; Entry: TLdapEntry): string;
var
  i: integer;
  s: string;
begin
  result:='';
  for i:=0 to length(FPopulates)-1 do begin
    if Index>length(FPopulates[i])-1 then continue;

    case FPopulates[i][Index].DataType of
      AT_DN:   s:=Entry.DN;
      AT_RDN:  s:=GetRdnFromDn(Entry.DN);
      AT_Path: s:=CanonicalName(GetDirFromDn(Entry.dn));
      else     s:=Entry.AttributesByName[FPopulates[i][Index].Attribute].AsString;
    end;
    if s<>'' then begin
      if result<>'' then result:=result + ', ' + s
      else result:=result + s;
    end;
  end;
end;

procedure TPickupDlg.ListViewData(Sender: TObject; Item: TListItem);
var
  i: integer;
  IcoIndex: integer;
  Entry: TLDapEntry;
begin
  Entry := TLdapEntry(FShowed[Item.Index]);
  Item.Caption:=GetText(0, Entry);
  for i:=1 to ListView.Columns.Count-1 do
    Item.SubItems.Add(GetText(i, Entry));

  IcoIndex:=FImageIndex;
  if assigned(FOnGetImageIndex) then FOnGetImageIndex(Entry, IcoIndex);
  if IcoIndex = -1 then
    IcoIndex := (Entry.Session as TConnection).GetImageIndex(Entry);
  Item.ImageIndex := IcoIndex;
end;

procedure TPickupDlg.FillListView;
var
  i : integer;
  sl: TStringList;

  function Match(Entry: TLdapEntry): boolean;
  var
    i : integer;
    s: string;
  begin
    if sl.Count=0 then begin
      result:=true;
      exit;
    end;
    s := '';
    for i:=0 to ListView.Columns.Count-1 do s:=s+#1+GetText(i, Entry);
    s := AnsiUpperCase(s);

    result := false;
    for i:=0 to sl.Count-1 do
      if Pos(sl[i],s) = 0 then exit;

    result := true;
  end;

begin
  // Checks ////////////////////////////////////////////////////////////////////
  if (FEntries=nil) (*or (FAttributes.Count=0)*) then begin
    ListView.Items.Clear;
    Exit;
  end;
  if ListView.Columns.Count<1 then exit;

  // Prepare Filter ////////////////////////////////////////////////////////////
  sl := TStringList.Create;
  sl.CommaText := AnsiUpperCase(FilterEdit.Text);
  //////////////////////////////////////////////////////////////////////////////
  Screen.Cursor:=crHourGlass;
  ListView.Items.BeginUpdate;

  FShowed.Clear;
  for i:=0 to FEntries.Count-1 do
    if Match(FEntries[i]) then FShowed.Add(FEntries[i]);

  ListView.Items.Count:=FShowed.Count;
  sl.Free;
  ListView.Items.EndUpdate;
  Screen.Cursor:=crDefault;
end;

procedure TPickupDlg.DoSort(SortColumn: TListColumn; SortAsc: boolean);
var
  Attrs: array of string;
  i,n : integer;

begin
  setlength(Attrs, length(FPopulates));
  n:=0;
  for i:=0 to length(FPopulates)-1 do begin
    if length(FPopulates[i])< SortColumn.Index-1 then continue;
    Attrs[n]:=FPopulates[i][SortColumn.Index].Attribute;
    inc(n);
  end;
  setlength(Attrs, n);

  FEntries.Sort(Attrs, SortAsc);
  FillListView;
end;

procedure TPickupDlg.FormClose(Sender: TObject; var Action: TCloseAction);
var
  i: integer;
begin
  // Populate FSelected list ///////////////////////////////////////////////////
  FSelected.Clear;
  if ModalResult<>MrOK then exit;
  for i:=0 to FShowed.Count-1 do
    if ListView.Items[i].Selected then FSelected.Add(FShowed[i]);
end;

function TPickupDlg.GetSelCount: integer;
begin
  result:=FSelected.Count;
end;

function TPickupDlg.GetSelected(Index: integer): TLdapEntry;
begin
  result:=TLdapEntry(FSelected[Index]);
end;

procedure TPickupDlg.FormCreate(Sender: TObject);
begin
  Images := MainFrm.ImageList;
end;

end.
