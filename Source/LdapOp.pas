  {      LDAPAdmin - LdapOp.pas
  *      Copyright (C) 2004-2014 Tihomir Karlovic
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

unit LdapOp;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
{$IFnDEF FPC}
  Windows, WinLDAP,
{$ELSE}
  LCLIntf, LCLType, LMessages, LinLDAP,
{$ENDIF}
  SysUtils, Messages, Classes, Graphics, Controls,
  StdCtrls, ExtCtrls, Forms, ComCtrls, LDAPClasses, Posix, mormot.core.base;

const
  LDAP_OP_SUCCESS = Pointer(1);

type
  TLdapOpDlg = class(TForm)
    CancelBtn: TButton;
    Message: TLabel;
    ProgressBar: TProgressBar;
    PathLabel: TLabel;
  private
    fSrcSession: TLDAPSession;
    fDstSession: TLDAPSession;
    fShowProgress: Boolean;
    fSmartDelete: Boolean;
    fDeleteAll: Boolean;
    fSkipOnOverlap: Boolean;
    function  CheckPathOverlap(const SourceDn, DestDn: RawUtf8): Boolean;
    procedure SetShowProgress(Value: Boolean);
    function  GetDstSession: TLDAPSession;
    procedure Prepare(const dn: RawUtf8); overload;
    procedure Prepare(List: TStringList); overload;
    procedure DeleteLeaf(const Entry: TLdapEntry);
    procedure DeleteChildren(const dn: RawUtf8);
    procedure Copy(const SourceDn, TargetDn: RawUtf8; Move: Boolean);
  public
    constructor Create(AOwner: TComponent; ASession: TLDAPSession); reintroduce;
    procedure CopyTree(const dn, pdn, rdn: RawUtf8; Move: Boolean); overload;
    procedure CopyTree(List: TStringList; const DestDn: RawUtf8; Move: Boolean); overload;
    procedure DeleteTree(const adn: RawUtf8); overload;
    procedure DeleteTree(List: TStringList); overload;
    property SourceSession: TLDAPSession read fSrcSession;
    property DestSession: TLDAPSession read GetDstSession write fDstSession;
    property ShowProgress: Boolean read fShowProgress write SetShowProgress;
    property DeleteAll: Boolean read fDeleteAll write fDeleteAll;
  end;

var
  LdapOpDlg: TLdapOpDlg;

implementation

{$R *.dfm}
{$I LdapAdmin.inc}

uses Misc, Dialogs, Config, Constant, mormot.net.ldap{$IFDEF VER_XEH}, System.UITypes{$ENDIF};

function TLdapOpDlg.CheckPathOverlap(const SourceDn, DestDn: RawUtf8): Boolean;
begin
  Result := (SourceSession <> DestSession) or (System.Copy(DestDn, Length(DestDn) - Length(SourceDn) + 1, MaxInt) <> SourceDn);
  if not (Result or fSkipOnOverlap) then
  case MessageDlgEx(SourceDn +#10#13 + Format(stSkipRecord, [stMoveOverlap]), mtError, [mbYes, mbNo, mbCancel], [cSkip, cSkipAll, cCancel],[]) of
    mrYes:    Exit;
    mrCancel: Abort;
    mrNo:     FSkipOnOverlap := true;
  end;
end;

procedure TLdapOpDlg.SetShowProgress(Value: Boolean);
begin
  fShowProgress := Value;
  ProgressBar.Visible := Value;
end;

function TLdapOpDlg.GetDstSession: TLDAPSession;
begin
  if Assigned(fDstSession) then
    Result := fDstSession
  else
    Result := fSrcSession
end;

procedure TLdapOpDlg.Prepare(const dn: RawUtf8);
var
  EntryList: TLdapEntryList;
begin
  if not fShowProgress then
    Exit;
  Message.Caption := cPreparing;
  Message.Refresh;
  EntryList := TLdapEntryList.Create;
  try
    Screen.Cursor := crAppStart;
    SourceSession.Search(sANYCLASS, dn, lssWholeSubtree, ['objectclass'], false, EntryList{, SearchCallback});
    if ModalResult = mrCancel then
      Abort;
    ProgressBar.Max := EntryList.Count;
  finally
    Screen.Cursor := crDefault;
    EntryList.Free;
  end;
end;

procedure TLdapOpDlg.Prepare(List: TStringList);
var
  EntryList: TLdapEntryList;
  c, i: Integer;
begin
  if not fShowProgress then
    Exit;
  Message.Caption := cPreparing;
  Message.Refresh;
  EntryList := TLdapEntryList.Create;
  try
    Screen.Cursor := crAppStart;
    c := 0;
    for i := 0 to List.Count - 1 do
    begin
      SourceSession.Search(sANYCLASS, List[i], lssWholeSubtree, ['objectclass'], false, EntryList{, SearchCallback});
      if ModalResult = mrCancel then
        Abort;
      inc(c, EntryList.Count);
      EntryList.Clear;
    end;
    ProgressBar.Max := c;
  finally
    Screen.Cursor := crDefault;
    EntryList.Free;
  end;
end;

{ This procedure copies entire subtree to a different location (dn). If Move is
  set to true then the source entries are deleted, effectivly moving the tree }
procedure TLdapOpDlg.Copy(const SourceDn, TargetDn: RawUtf8; Move: Boolean);
var
  EntryList: TLdapEntryList;
  srcEntry, dstEntry: TLDAPEntry;
  i, j: Integer;
  Attr: LDAPClasses.TLdapAttribute;
begin

  { Copy base entry }
  srcEntry := TLDAPEntry.Create(SourceSession, SourceDn);
  if SourceSession <> DestSession then
    dstEntry := TLDAPEntry.Create(DestSession, SourceDn)
  else
    dstEntry := srcEntry;

  with srcEntry do
  try
    Read;
    if SourceSession <> DestSession then
    begin
      for i := 0 to srcEntry.Attributes.Count - 1 do with srcEntry.Attributes[i] do
      begin
        Attr := dstEntry.Attributes.Add(Name);
        for j := 0 to ValueCount - 1 do with Values[j] do
          Attr.AddValue(Data, DataSize);
      end;
    end;
    dstEntry.dn := TargetDn;
    dstEntry.Write;
  finally
    if dstEntry <> srcEntry then
      dstEntry.Free;
    Free;
  end;

  if Move and fSmartDelete then
  begin
    if SourceSession = DestSession then
      { Adjust group references to new dn }
      SourceSession.ModifySet( Format(sMY_DN_GROUPS,[SourceDn]),
                               SourceSession.Base, lssWholeSubtree,
                               ['member', 'uniqueMember'],
                               [SourceDn, SourceDn],
                               [TargetDn, TargetDn],
                               LdapOpReplace)
    else
      { Remove group references }
      SourceSession.ModifySet( Format(sMY_DN_GROUPS,[SourceDn]),
                               SourceSession.Base, lssWholeSubtree,
                               ['member', 'uniqueMember'],
                               [SourceDn, SourceDn],
                               [TargetDn, TargetDn],
                               LdapOpReplace)
    end;

  if fShowProgress then
    ProgressBar.StepIt;

  { Copy subentries }
  EntryList := TLdapEntryList.Create;
  try
    SourceSession.Search(sANYCLASS, SourceDn, lssSingleLevel, nil, false, EntryList);

    if not Visible and  (EntryList.Count > 0) then
      Show;

    for i := 0 to EntryList.Count - 1 do with EntryList[i] do
    begin
      if ModalResult <> mrNone then
        Break;
      PathLabel.Caption := dn;
      Application.ProcessMessages;
      if ModalResult <> mrNone then
        Break;
      Copy(dn, GetRdnFromDn(dn) + ',' + TargetDn, Move);
      if Move then
        Delete;
    end;
  finally
    EntryList.Free;
  end;
end;

{ Deletes one leaf. If the leaf is simple entry it just deletes it, if the leaf
  represents posixAccount it removes memberUid from groups before deleting) }
{$IFDEF VER130}
{$O-}
{$ENDIF}
procedure TLdapOpDlg.DeleteLeaf(const Entry: TLdapEntry);
var
  i: Cardinal;
  uid: RawUtf8;
  oc: LDAPClasses.TLdapAttribute;
begin
  Entry.Delete;
  if fSmartDelete then
  begin
    oc := Entry.AttributesByName['objectclass'];
    for i := 0 to oc.ValueCount - 1 do
    begin
      if CompareText(oc.Values[i].AsString, 'posixaccount') = 0 then with SourceSession do
      begin
        { Remove any references to uid from groups before deleting user itself; }
        //TODO: Entry := TPosixAccount.Create(SourceSession, dn);
        uid := GetNameFromDN(Entry.dn);
        ModifySet(Format(sMY_GROUPS,[uid, Entry.dn]), Base, lssWholeSubtree,
                  ['memberUid', 'uniqueMember', 'member'],
                  [uid, Entry.dn, Entry.dn], [], LdapOpDelete);
        break;
      end;
    end;
  end;
end;
{$IFDEF VER130}
{$O+}
{$ENDIF}

{ This procedure checks for leaf's children and deletes them recursively if
  boolean fDeleteAll is set to true. Otherwise, user is prompted to delete }
procedure TLdapOpDlg.DeleteChildren(const dn: RawUtf8);
var
  EntryList: TLdapEntryList;
  i: Integer;
begin
  EntryList := TLdapEntryList.Create;
  try
    SourceSession.Search(sANYCLASS, dn, lssSingleLevel, ['objectclass'], false, EntryList);
    if not fDeleteAll and (EntryList.Count > 0) then
    begin
      if CheckedMessageDlg(PChar(Format(stDeleteAll, [dn])), mtWarning, [mbYes, mbNo], cSmartDelete, fSmartDelete) <> mrYes then
      begin
        ModalResult := mrCancel;
        Exit;
      end;
      fDeleteAll := true;
      Show;
    end;
    for i := 0 to EntryList.Count - 1 do with EntryList[i] do
    begin
      DeleteChildren(dn);
      if ModalResult <> mrNone then
        Break;
      PathLabel.Caption := dn;
      Application.ProcessMessages;
      if ModalResult <> mrNone then
        Break;
      Delete;
      if fShowProgress then
        ProgressBar.StepIt;
    end;
  finally
    EntryList.Free;
  end;
end;

constructor TLdapOpDlg.Create(AOwner: TComponent; ASession: TLDAPSession);
begin
  inherited Create(AOwner);
  fSrcSession := ASession;
  fSmartDelete := GlobalConfig.ReadBool(rSmartDelete, true);
end;

procedure TLdapOpDlg.CopyTree(const dn, pdn, rdn: RawUtf8; Move: Boolean);
var
  tgtdn: RawUtf8;
begin
  if rdn = '' then
    tgtdn := GetRdnFromDn(dn) + ',' + pdn
  else
    tgtdn := rdn + ',' + pdn;

  if not CheckPathOverlap(dn, tgtdn) then
    exit;
  Prepare(dn);
  if Move then
    Message.Caption := cMoving
  else
    Message.Caption := cCopying;
  ModalResult := mrNone;

  Copy(dn, tgtdn, Move);
  if Move and (ModalResult = mrNone) then // if not interrupted by user
  begin
    SourceSession.DeleteEntry(dn);
    if rdn <> '' then // base entry renamed, adjust posix group references
      with SourceSession do try
      ModifySet(Format(sMY_POSIX_GROUPS,[GetNameFromDn(dn)]), Base, lssWholeSubtree,
                ['memberUid'],
                [GetNameFromDn(dn)],
                [GetNameFromDn(rdn)], LdapOpReplace);
      except
        on E: ErrLDAP do
          MessageDlg(Format(stRefUpdateError, [E.Message]), mtError, [mbOk], 0);
        else
          raise;
      end;
  end;
end;

procedure TLdapOpDlg.CopyTree(List: TStringList; const DestDn: RawUtf8; Move: Boolean);
var
  i: Integer;
  tgtdn: RawUtf8;
begin
  Prepare(List);
  if Move then
    Message.Caption := cMoving
  else
    Message.Caption := cCopying;
  ModalResult := mrNone;
  for i := 0 to List.Count - 1 do
  begin
    tgtdn := GetRdnFromDn(List[i]) + ',' + DestDn;
    if CheckPathOverlap(List[i], tgtdn) then
    begin
      Copy(List[i], tgtdn, Move);
      if ModalResult = mrCancel then
        Break;
      if Move then
        SourceSession.DeleteEntry(List[i]);
      List.Objects[i] := LDAP_OP_SUCCESS;        
    end;
  end;
end;

procedure TLdapOpDlg.DeleteTree(const adn: RawUtf8);
var
  Entry: TLdapEntry;
begin
  Prepare(adn);
  Message.Caption := cDeleting;
  ModalResult := mrNone;
  DeleteChildren(adn);
  if ModalResult = mrNone then
  begin
    Entry := TLdapEntry.Create(SourceSession, adn);
    try
      Entry.Read;
      DeleteLeaf(Entry);
    finally
      Entry.Free;
    end;
  end;
end;

procedure TLdapOpDlg.DeleteTree(List: TStringList);
var
  Entry: TLdapEntry;
  i: Integer;
begin
  ModalResult := mrNone;
  Prepare(List);
  Message.Caption := cDeleting;
  for i := 0 to List.Count - 1 do
  begin
    DeleteChildren(List[i]);
    if fShowProgress then
      ProgressBar.StepIt;
    PathLabel.Caption := List[i];
    Application.ProcessMessages;
    if ModalResult = mrCancel then
      Break;
    Entry := TLdapEntry.Create(SourceSession, List[i]);
    try
      Entry.Read;
      DeleteLeaf(Entry);
      List.Objects[i] := LDAP_OP_SUCCESS;
    finally
      Entry.Free;
    end;
  end;
end;

end.
