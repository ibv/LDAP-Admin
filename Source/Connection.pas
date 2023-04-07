  {      LDAPAdmin - Connection.pas
  *      Copyright (C) 2012-2016 Tihomir Karlovic
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

unit Connection;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses Config, Sorter, Schema, LdapClasses, CustomMenus, Controls, Templates,
     LinLDAP, Constant, TextFile, Bookmarks, mormot.core.base, mormot.net.ldap;

const
  { Posix objects }
  oidUnknown           = -1;
  oidEntry             = 0;
  oidRoot              = oidEntry + 1;
  oidPosixUser         = oidRoot + 1;
  oidSambaUser         = oidPosixUser + 1;
  oidComputer          = oidSambaUser + 1;
  oidGroup             = oidComputer + 1;
  oidSambaGroup        = oidGroup + 1;
  oidMailGroup         = oidSambaGroup + 1;
  oidTransportTable    = oidMailGroup + 1;
  oidOU                = oidTransportTable + 1;
  oidHost              = oidOU + 1;
  oidLocality          = oidHost + 1;
  oidGroupOfUN         = oidLocality + 1;
  oidAlias             = oidGroupOfUN + 1;
  oidSudoer            = oidAlias + 1;
  oidSambaDomain       = oidSudoer + 1;
  oidIdPool            = oidSambaDomain + 1;
  { AD objects }
  oidAdUser            = oidIdPool + 1;
  oidADComputer        = oidAdUser + 1;
  oidADContainer       = oidAdComputer + 1;
  oidADGroup           = oidADContainer + 1;
  oidADClassSchema     = oidADGroup + 1;
  oidADAttributeSchema = oidADClassSchema + 1;
  oidADSchema          = oidADAttributeSchema + 1;
  oidADConfiguration   = oidADSchema + 1;

  ObjectIdToImage: array[oidEntry..oidADConfiguration] of Integer = (
                    bmEntry,
                    bmRoot,
                    bmPosixUser,
                    bmSamba3User,
                    bmComputer,
                    bmGroup,
                    bmSambaGroup,
                    bmMailGroup,
                    bmTransport,
                    bmOU,
                    bmHost,
                    bmLocality,
                    bmGrOfUnqNames,
                    bmAlias,
                    bmSudoer,
                    bmSambaDomain,
                    bmIdPool,
                    bmSamba3USer,
                    bmComputer,
                    bmAdContainer,
                    bmADGroup,
                    bmClassSchema,
                    bmAttributeSchema,
                    bmSchema,
                    bmConfiguration);

type
  TConnection = class;

  IDirectoryIdentity = Interface
    function  ClassifyLdapEntry(Entry: TLdapEntry): Integer;
    function  NewProperty(Owner: TControl; const Index: Integer; const dn: RawUtf8): Boolean;
    function  EditProperty(Owner: TControl; const Index: Integer; const dn: RawUtf8): Boolean;
    function  ChangePassword(Entry: TLdapEntry): Boolean;
    function  IsContainer(Index: Integer): Boolean;
    function  CreateMenu: TCustomActionMenu;
  end;

  TConnection = class(TLdapSession)
  private
    FHelper:    TObject;
    FAccount:   TAccount;
    FSchema:    TLdapSchema;
    FDirectoryIdentity: IDirectoryIdentity;
    FActionMenu: TCustomActionMenu;
    FBookmarks: TBookmarks;
    function    GetHelper: TObject;
    function    GetDirectoryType: TDirectoryType;
    function    GetDirectoryIdentity: IDirectoryIdentity;
    function    GetActionMenu: TCustomActionMenu;
    function    GetSchema: TLdapSchema;
    function    GetFreeRandomNumber(const Min, Max: Integer; const Objectclass, id: RawUtf8): Integer;
    function    GetSequentialNumber(const Min, Max: Integer; const Objectclass, id: RawUtf8): Integer;
  public
    constructor Create(Account: TAccount);
    destructor  Destroy; override;
    function    GetObjectId(Entry: TLdapEntry): Integer;
    function    GetImageIndex(Entry: TLdapEntry): Integer;
    function    GetFreeUidNumber(const MinUid, MaxUID: Integer; const Sequential: Boolean): Integer;
    function    GetFreeGidNumber(const MinGid, MaxGid: Integer; const Sequential: Boolean): Integer;
    function    GetUid: Integer;
    function    GetGid: Integer;
    property    Account: TAccount read FAccount;
    property    Schema: TLdapSchema read GetSchema;
    property    DirectoryType: TDirectoryType read GetDirectoryType;
    property    DI: IDirectoryIdentity read GetDirectoryIdentity;
    property    ActionMenu: TCustomActionMenu read GetActionMenu;
    property    Bookmarks: TBookmarks read FBookmarks;
    property    Helper: TObject read GetHelper;
  end;

  { Local LDAP DB }

  TDBAccount=class(TFakeAccount)
  private
    FFileName:  RawUtf8;
  public
    property    FileName: RawUtf8 read FFileName write FFileName;
  end;

  TEntryNode = class(TLdapEntry)
  private
    fChildren: TLdapEntryList;
  public
    constructor Create(const ASession: TLDAPSession; const adn: RawUtf8); override;
    destructor  Destroy; override;
    property    Children: TLdapEntryList read fChildren;
  end;

  TLoadCallback = procedure(BytesRead: Integer; var Abort: Boolean) of object;

  { TDBConnection }

  TDBConnection = class(TConnection)
  private
    Root:       TEntryNode;
    fModified:  Boolean;
    fDestroying: Boolean;
    fEncoding:  TFileEncode;
    function    FindNode(const adn: RawUtf8): TEntryNode;
  protected
    function    ISConnected: Boolean; override;
  public
    constructor Create(Account: TDBAccount; CallbackProc: TLoadCallback = nil);
    destructor  Destroy; override;
    procedure   Search(const Filter, Base: RawUtf8; const Scope: TLdapSearchScope; attrs: TRawByteStringDynArray; const NoValues: LongBool; Result: TLdapEntryList; SearchProc: TSearchCallback = nil); overload; override;
    function    Lookup(sBase, sFilter, sResult: RawUtf8; Scope: TLdapSearchScope): RawUtf8; override;
    function    GetDn(sFilter: RawUtf8): RawUtf8; override;
    procedure   WriteEntry(Entry: TLdapEntry); override;
    procedure   ReadEntry(Entry: TLdapEntry); override;
    procedure   DeleteEntry(const adn: RawUtf8); override;
    procedure   SaveToFile(FileName: RawUtf8);
    procedure   Connect; override;
    procedure   Disconnect; override;
  end;

var
  UseTemplateImages: Boolean;

implementation

uses SysUtils,  User, Host, Locality, Computer, Group, LDIF, Dialogs,
     AdObjects, ADUser, AdGroup, AdComputer, AdContainer,
     {$ifdef mswindows} UiTypes,      {$endif}
     MailGroup, Transport, Ou, Classes, PassDlg, ADPassDlg, Alias, Ast ;

{ IDirectoryIdentity }

type
  TCustomDirectoryIdentity = class(TInterfacedObject)
  private
    FConnection: TConnection;
  public
    constructor Create(Connection: TConnection);
    property    Connection: TConnection read FConnection;
  end;

  TPosixDirectoryIdentity = class(TCustomDirectoryIdentity, IDirectoryIdentity)
  public
    function  ClassifyLdapEntry(Entry: TLdapEntry): Integer;
    function  NewProperty(Owner: TControl; const Index: Integer; const dn: RawUtf8): Boolean;
    function  EditProperty(Owner: TControl; const Index: Integer; const dn: RawUtf8): Boolean;
    function  ChangePassword(Entry: TLdapEntry): Boolean;
    function  IsContainer(Index: Integer): Boolean;
    function  CreateMenu: TCustomActionMenu;
  end;

  TADDirectoryIdentity = class(TCustomDirectoryIdentity, IDirectoryIdentity)
  public
    function  ClassifyLdapEntry(Entry: TLdapEntry): Integer;
    function  NewProperty(Owner: TControl; const Index: Integer; const dn: RawUtf8): Boolean;
    function  EditProperty(Owner: TControl; const Index: Integer; const dn: RawUtf8): Boolean;
    function  ChangePassword(Entry: TLdapEntry): Boolean;
    function  IsContainer(Index: Integer): Boolean;
    function  CreateMenu: TCustomActionMenu;
  end;

function TConnection.GetHelper: TObject;
begin
  if not Assigned(FHelper) then
  begin
    case DirectoryType of
      //dtPosix:           FHelper := TPosixHelper(Self); TODO: Posix helper
      dtActiveDirectory: FHelper := TAdHelper.Create(Self);
    end;
  end;
  Result := FHelper;
end;

function TConnection.GetDirectoryType: TDirectoryType;
begin
  Result := Account.DirectoryType;
  if (Result = dtAutodetect) and Connected then
  begin
    if Lookup('', sAnyClass,'isGlobalCatalogReady', lssBaseObject) <> '' then
      Result := dtActiveDirectory
    else
      Result := dtPosix;
    Account.DirectoryType := Result;
  end;
end;

function TConnection.GetSchema: TLdapSchema;
begin
  if not Assigned(FSchema) then
    FSchema := TLdapSchema.Create(Self);
  Result := FSchema;
end;

function TConnection.GetDirectoryIdentity: IDirectoryIdentity;
begin
  if not Assigned(FDirectoryIdentity) then
  begin
    case DirectoryType of
      dtActiveDirectory: fDirectoryIdentity := TADDirectoryIdentity.Create(Self);
    else
      fDirectoryIdentity := TPosixDirectoryIdentity.Create(Self);
    end;
  end;
  Result := FDirectoryIdentity;
end;

function TConnection.GetActionMenu: TCustomActionMenu;
begin
  if not Assigned(FActionMenu) then
    FActionMenu := DI.CreateMenu;
  Result := FActionMenu;
end;

constructor TConnection.Create(Account: TAccount);
begin
  inherited Create;
  FAccount := Account;
  try
    FBookmarks := TBookmarks.Create(Self);
  except
    on E: Exception do
      MessageDlg(E.Message, mtError, [mbOk], 0);
  end;
end;

destructor TConnection.Destroy;
begin
  try
    FActionMenu.Free;
    FSchema.Free;
    FBookmarks.Free;
  except
    on E: Exception do
      MessageDlg(E.Message, mtError, [mbOk], 0);
  end;
  inherited;
end;

function TConnection.GetObjectId(Entry: TLdapEntry): Integer;
begin
  Result := DI.ClassifyLdapEntry(Entry);
end;

function TConnection.GetImageIndex(Entry: TLdapEntry): Integer;
var
  i: Integer;
begin
  Result := ObjectIdToImage[GetObjectId(Entry)];
  if (Result = bmEntry) and UseTemplateImages then
    for i := 0 to TemplateParser.Count - 1 do with TemplateParser.Templates[i] do
      if (ImageIndex <> -1 ) and Matches(Entry.ObjectClass) then
      begin
        Result := ImageIndex;
        break;
      end;
end;

{ Get random free uidNumber from the pool of available numbers, return -1 if
  no more free numbers are available }
function TConnection.GetFreeRandomNumber(const Min, Max: Integer; const Objectclass, id: RawUtf8): Integer;
var
  i: Integer;
  uidpool: array of Word;
  r, N: Word;
begin
  N := Max - Min + 1;
  SetLength(uidpool, N);
  { Initialize the array }
  for i := 0 to N - 1 do
    uidpool[i] := i;
  Randomize;
  while N > 0 do
  begin
    r := Random(N);
    Result := Min + uidpool[r];
    if Lookup(Base, Format('(&(objectclass=%s)(%s=%d))', [Objectclass, id, Result]), 'objectclass', lssWholeSubtree) = '' then
      exit;
    uidpool[r] := uidpool[N - 1];
    dec(N);
  end;
  Result := -1;
end;

{ Get sequential free uidNumber from the pool of available numbers, return -1 if
  no more free numbers are available }
function TConnection.GetSequentialNumber(const Min, Max: Integer; const Objectclass, id: RawUtf8): Integer;
var
  i, n: Integer;
  SearchList: TLdapEntryList;
begin
  Result := Min;
  SearchList := TLdapEntryList.Create;
  try
    Search(Format('(objectclass=%s)', [Objectclass]), Base, lssSingleLevel, [id], false, SearchList);
    for i := 0 to SearchList.Count - 1 do
    begin
      n := StrToInt(SearchList[i].Attributes[0].AsString);
      if (n <= Max) and (n >= Result) then
      begin
        Result :=  n + 1;
        if Result > Max then
        begin
          Result := -1;
          break;
        end;
      end;
    end;
  finally
    SearchList.Free;
  end;
end;

function TConnection.GetFreeUidNumber(const MinUid, MaxUID: Integer; const Sequential: Boolean): Integer;
begin
  if Sequential then
    Result := GetSequentialNumber(MinUid, MaxUid, 'posixAccount', 'uidNumber')
  else
    Result := GetFreeRandomNumber(MinUid, MaxUid, 'posixAccount', 'uidNumber');
  if Result = -1 then
    raise Exception.Create(Format(stNoMoreNums, ['uidNumber']));
end;

function TConnection.GetFreeGidNumber(const MinGid, MaxGid: Integer; const Sequential: Boolean): Integer;
begin
  if Sequential then
    Result := GetSequentialNumber(MinGid, MaxGid, 'posixGroup', 'gidNumber')
  else
    Result := GetFreeRandomNumber(MinGid, MaxGid, 'posixGroup', 'gidNumber');
  if Result = -1 then
    raise Exception.Create(Format(stNoMoreNums, ['gidNumber']));
end;

function TConnection.GetUid: Integer;
var
  IdType: Integer;
begin
  Result := -1;
  idType := Account.ReadInteger(rPosixIDType, POSIX_ID_RANDOM);
  if idType <> POSIX_ID_NONE then
    Result := GetFreeUidNumber(Account.ReadInteger(rposixFirstUID, FIRST_UID),
                               Account.ReadInteger(rposixLastUID, LAST_UID),
                               IdType = POSIX_ID_SEQUENTIAL);
end;

function TConnection.GetGid: Integer;
var
  IdType: Integer;
begin
  Result := -1;
  idType := Account.ReadInteger(rPosixIDType, POSIX_ID_RANDOM);
  if idType <> POSIX_ID_NONE then
    Result := GetFreeGidNumber(Account.ReadInteger(rposixFirstGid, FIRST_GID),
                               Account.ReadInteger(rposixLastGID, LAST_GID),
                               IdType = POSIX_ID_SEQUENTIAL);
end;

{ TCustomDirectoryIdentity }

constructor TCustomDirectoryIdentity.Create(Connection: TConnection);
begin
  FConnection := Connection;
end;

{ TPosixDirectoryIDentity }

function TPosixDirectoryIdentity.ClassifyLdapEntry(Entry: TLdapEntry): Integer;
var
  Attr: LdapClasses.TLdapAttribute;
  i: integer;
  s: RawUtf8;

  function IsComputer(const s: RawUtf8): Boolean;
  var
    i: Integer;
  begin
    i := Pos(',', s);
    Result := (i > 1) and (s[i - 1] = '$');
  end;

begin
  Result := oidEntry;
  Attr := Entry.Objectclass;
  i := Attr.ValueCount - 1;
  while i >= 0 do
  begin
    s := lowercase(Attr.Values[i].AsString);
    if s = 'organizationalunit' then
      Result := oidOu
    else if s = 'posixaccount' then
    begin
      if Result = oidEntry then // if not yet assigned to Samba account
        Result := oidPosixUser;
    end
    else if s = 'sambasamaccount' then
    begin
      if IsComputer(Entry.dn) then             // it's samba computer account
        Result := oidComputer                  // else
      else                                     // it's samba user account
        Result := oidSambaUser;
    end
    else if s = 'sambagroupmapping' then
      Result := oidSambaGroup
    else if s = 'mailgroup' then
      Result := oidMailGroup
    else if s = 'posixgroup' then
    begin
      if Result = oidEntry then // if not yet assigned to Samba group
        Result := oidGroup;
    end
    else if s = 'groupofuniquenames' then
      Result := oidGroupOfUN
    else if s = 'alias' then
      Result := oidAlias
    else if s = 'transporttable' then
      Result := oidTransportTable
    else if s = 'sudorole' then
      Result := oidSudoer
    else if s = 'iphost' then
      Result := oidHost
    else if s = 'locality' then
      Result := oidLocality
    else if s = 'sambadomain' then
      Result := oidSambaDomain
    else if s = 'sambaunixidpool' then
      Result := oidIdPool;
    Dec(i);
  end;
end;

function  TPosixDirectoryIdentity.NewProperty(Owner: TControl; const Index: Integer; const dn: RawUtf8): Boolean;
begin
  Result := true;
  case Index of
    aidUser:           TUserDlg.Create(Owner, dn, Connection, EM_ADD).ShowModal;
    aidComputer:       TComputerDlg.Create(Owner, dn, Connection, EM_ADD).ShowModal;
    aidGroup:          TGroupDlg.Create(Owner, dn, Connection, EM_ADD, true, Connection.Account.ReadInteger(rPosixGroupOfUnames, 0)).ShowModal;
    aidMailingList:    TMailGroupDlg.Create(Owner, dn, Connection, EM_ADD).ShowModal;
    aidTransportTable: TTransportDlg.Create(Owner, dn, Connection, EM_ADD).ShowModal;
    aidOU:             TOuDlg.Create(Owner, dn, Connection, EM_ADD).ShowModal;
    aidHost:           THostDlg.Create(Owner, dn, Connection, EM_ADD).ShowModal;
    aidLocality:       TLocalityDlg.Create(Owner, dn, Connection, EM_ADD).ShowModal;
    aidGroupOfUN:      TGroupDlg.Create(Owner, dn, Connection, EM_ADD, false, 1).ShowModal;
    aidAlias:          TAliasDlg.Create(Owner, dn, Connection, EM_ADD).ShowModal;
  else
    Result := false;
  end;
end;

function TPosixDirectoryIdentity.EditProperty(Owner: TControl; const Index: Integer; const dn: RawUtf8): Boolean;
begin
  Result := true;
  case Index of
    aidUser:            TUserDlg.Create(Owner, dn, Connection, EM_MODIFY).ShowModal;
    aidGroup,
    aidGroupOfUn:       TGroupDlg.Create(Owner, dn, Connection, EM_MODIFY).ShowModal;
    aidMailingList:     TMailGroupDlg.Create(Owner, dn, Connection, EM_MODIFY).ShowModal;
    aidComputer:        TComputerDlg.Create(Owner, dn, Connection, EM_MODIFY).ShowModal;
    aidTransportTable:  TTransportDlg.Create(Owner, dn, Connection, EM_MODIFY).ShowModal;
    aidOu:              TOuDlg.Create(Owner, dn, Connection, EM_MODIFY).ShowModal;
    aidLocality:        TLocalityDlg.Create(Owner, dn, Connection, EM_MODIFY).ShowModal;
    aidHost:            THostDlg.Create(Owner, dn, Connection, EM_MODIFY).ShowModal;
    aidAlias:           TAliasDlg.Create(Owner, dn, Connection, EM_MODIFY).ShowModal;
  else
    Result := false;
  end;
end;

function TPosixDirectoryIdentity.ChangePassword(Entry: TLdapEntry): Boolean;
begin
  with TPasswordDlg.Create(nil, Entry) do
  try
    if ShowModal = mrOk then
    begin
      Entry.Write;
      Result := true;
    end
    else
      Result := false;
  finally
    Free;
  end;
end;

function TPosixDirectoryIdentity.IsContainer(Index: Integer): Boolean;
begin
  Result := Index in [oidOu, oidLocality, oidEntry, oidRoot];
end;

function TPosixDirectoryIdentity.CreateMenu: TCustomActionMenu;
begin
  Result := TPosixActionMenu.Create(Connection.Account);
end;

{ TADDirectoryIdentity }

function TADDirectoryIdentity.ClassifyLdapEntry(Entry: TLdapEntry): Integer;
var
  Attr: LdapClasses.TLdapAttribute;
  i: integer;
  s: RawUtf8;
begin
  Result := oidEntry;
  Attr := Entry.ObjectClass;
  i := Attr.ValueCount - 1;
  while i >= 0 do
  begin
    s := lowercase(Attr.Values[i].AsString);
    if s = 'organizationalunit' then
      Result := oidOu
    else if s = 'container' then
      Result := oidADContainer
    else if s = 'user' then
    begin
      if Result = oidEntry then // if not yet assigned to computer account
        Result := oidADUser;
    end
    else
    if s = 'computer' then
      Result := oidADComputer
    else if s = 'group' then
      Result := oidADGroup
    else if s = 'locality' then
      Result := oidLocality
    else if s = 'configuration' then
      Result := oidADConfiguration
    else if s = 'classschema' then
      Result := oidADClassSchema
    else if s = 'attributeschema' then
      Result := oidADAttributeSchema
    else if (s = 'dmd') or (s = 'subschema') then
      Result := oidADSchema;
    Dec(i);
  end;

end;

function  TADDirectoryIdentity.NewProperty(Owner: TControl; const Index: Integer; const dn: RawUtf8): Boolean;
begin
  Result := true;
  case Index of
    aidOu:         TOuDlg.Create(Owner, dn, Connection, EM_ADD).ShowModal;
    aidHost:       THostDlg.Create(Owner, dn, Connection, EM_ADD).ShowModal;
    aidLocality:   TLocalityDlg.Create(Owner, dn, Connection, EM_ADD).ShowModal;
    aidAdUser:     TADUserDlg.Create(Owner, dn, Connection, EM_ADD).ShowModal;
    aidAdGroup:    TADGroupDlg.Create(Owner, dn, Connection, EM_ADD).ShowModal;
    aidAdComputer: TADComputerDlg.Create(Owner, dn, Connection, EM_ADD).ShowModal;
    aidAdContainer:TADContainerDlg.Create(Owner, dn, Connection, EM_ADD).ShowModal;
  else
    Result := false;
  end;
end;

function TADDirectoryIdentity.EditProperty(Owner: TControl; const Index: Integer; const dn: RawUtf8): Boolean;
begin
  Result := true;
  case Index of
    oidOu:           TOuDlg.Create(Owner, dn, Connection, EM_MODIFY).ShowModal;
    oidLocality:     TLocalityDlg.Create(Owner, dn, Connection, EM_MODIFY).ShowModal;
    oidHost:         THostDlg.Create(Owner, dn, Connection, EM_MODIFY).ShowModal;
    aidAdUser:       TADUserDlg.Create(Owner, dn, Connection, EM_MODIFY).ShowModal;
    aidAdGroup:      TADGroupDlg.Create(Owner, dn, Connection, EM_MODIFY).ShowModal;
    aidAdComputer:   TADComputerDlg.Create(Owner, dn, Connection, EM_MODIFY).ShowModal;
    aidAdContainer:  TADContainerDlg.Create(Owner, dn, Connection, EM_MODIFY).ShowModal;
  else
    Result := false;
  end;
end;

function TADDirectoryIdentity.ChangePassword(Entry: TLdapEntry): Boolean;
begin
  with TADPassDlg.Create(nil, Entry) do
  try
    Result := ShowModal = mrOk;
  finally
    Free;
  end;
end;

function TADDirectoryIdentity.IsContainer(Index: Integer): Boolean;
begin
  Result := Index in [oidOu, oidLocality, oidEntry, oidRoot, oidADContainer, oidADConfiguration, oidADSchema];
end;

function TADDirectoryIdentity.CreateMenu: TCustomActionMenu;
begin
  Result := TADActionMenu.Create(Connection.Account);
end;

{ Local LDAP DB }

constructor TEntryNode.Create(const ASession: TLDAPSession; const adn: RawUtf8);
begin
  inherited;
  fChildren := TLdapEntryList.Create;
end;

destructor TEntryNode.Destroy;
begin
  fChildren.Free;
  inherited;
end;

{ Finds a matching node for a whole or a part of a dn }
function TDBConnection.FindNode(const adn: RawUtf8): TEntryNode;
var
  i: Integer;
  Parent: TEntryNode;
begin
  Parent := Root;
  Result := nil;
  while Parent <> Result do
  begin
      Result := Parent;
      for i := 0 to Parent.Children.Count - 1 do with Parent.Children[i] do
      begin
        if AnsiSameText(dn, Copy(adn, Length(adn) - Length(dn) + 1, MaxInt)) then
        begin
          Parent := Parent.Children[i] as TEntryNode;
          break; // for i
        end;
      end;
  end;
end;

  { Put all values outputted by LDIF reader in browse mode }
  procedure SetBrowseMode(Entry: TLdapEntry);
  var
    i, j: Integer;
  begin
    for i := 0 to Entry.Attributes.Count - 1 do
    for j := 0 to Entry.Attributes[i].ValueCount - 1 do
      Entry.Attributes[i].Values[j].ModOp := LdapOpRead;
  end;

constructor TDBConnection.Create(Account: TDBAccount; CallbackProc: TLoadCallback = nil);
var
  Entry, Parent: TEntryNode;
  ldFile: TLdifFile;
  Stop: Boolean;
begin
  inherited Create(Account);
  Root := TEntryNode.Create(Self, '');
  Account.LdapVersion := LDAP_VERSION3;
  ldFile := TLDIFFile.Create(Account.FileName, fmRead);
  with ldFile do
  try
    fEncoding := Encoding;
    while not (eof or Stop) do begin
      Entry := TEntryNode.Create(Self, '');
      ReadRecord(Entry);
      if Entry.dn = '' then
      begin
        FreeAndNil(Entry);
        break;
      end;
      if not (esDeleted in Entry.State) then
      begin
        SetBrowseMode(Entry);
        Parent := FindNode(GetDirFromDn(Entry.dn));
        if Assigned(Parent) then
          Parent.Children.Add(Entry);
      end;
      if Assigned(CallbackProc) then
        CallbackProc(NumRead, Stop);
    end;
  finally
    FreeAndNil(ldFile);
  end;
  Account.Base := Base;
end;

destructor TDBConnection.Destroy;
begin
  fDestroying := true;
  inherited; // inherited calls Disconnect()
  Root.Free;
  FHelper.Free;
end;

{ Note: NoValue and attrs are ignored, for the time being all attributes and values are returned }
{ Also: Implement FirstOnly to stop traversing of the tree tree when only one result is expected (usefull for Lookup and GetDn functions }
procedure TDBConnection.Search(const Filter, Base: RawUtf8;
  const Scope: TLdapSearchScope; attrs: TRawByteStringDynArray;
  const NoValues: LongBool; Result: TLdapEntryList; SearchProc: TSearchCallback
  );
var
  BaseNode: TEntryNode;
  FilterNode :TAstNode;
begin
  if Base ='' then
    BaseNode := Root
  else
    BaseNode := FindNode(Base);
  if Assigned(BaseNode) then
  begin
    FilterNode := Parse(Filter);
    FilterNode.ExecuteFilter(Self, BaseNode, Scope, Result);
  end;
end;

  { Need to remove deleted attributes and prevent deleted values from cloning }
  procedure Purify(Entry: TLdapEntry);
  var
    i, j: Integer;
  begin
    for i := Entry.Attributes.Count - 1 downto 0 do
    begin
      if asDeleted in Entry.Attributes[i].State then
        Entry.Attributes.Delete(i)
      else
        for j := 0 to Entry.Attributes[i].ValueCount - 1 do
          if Entry.Attributes[i].Values[j].ModOp = LdapOpDelete then
            Entry.Attributes[i].Values[j].Berval.bv_len := 0;  // Skip when cloning
    end;
  end;


procedure TDBConnection.WriteEntry(Entry: TLdapEntry);
var
  Node, NewNode: TentryNode;
begin
  Purify(Entry);
  if esNew in Entry.State then
  begin
    Node := FindNode(GetDirFromDN(Entry.dn)); // find parent
    if not Assigned(Node) then
      raise Exception.CreateFmt(stDirNotExists, [GetDirFromDN(Entry.dn)]);
    NewNode := TEntryNode.Create(Self, Entry.dn);
    Entry.Clone(NewNode);
    Node.Children.Add(NewNode);
  end
  else begin
    { else update existing node }
    Node := FindNode(Entry.dn);
    if Assigned(Node) then
    begin
      Node.Attributes.Clear;
      Node.OperationalAttributes.Clear;
      Entry.Clone(Node);
      SetBrowseMode(Node);
    end;
  end;
  fModified := true;
end;

procedure TDBConnection.ReadEntry(Entry: TLdapEntry);
var
  Node: TentryNode;
begin
  Node := FindNode(Entry.dn);
  if Assigned(Node) then
    Node.Clone(Entry);
end;

procedure TDBConnection.DeleteEntry(const adn: RawUtf8);
var
  ParentNode: TentryNode;
  i: Integer;
begin
  ParentNode := FindNode(GetDirFromDn(adn));
  if not Assigned(ParentNode) then
    raise Exception.CreateFmt(stPathNotFound, [GetDirFromDn(adn)]);
  i := ParentNode.Children.IndexOf(adn);
  if i = -1 then
    raise Exception.CreateFmt(stObjectNotFound, [adn]);
  if TEntryNode(ParentNode.Children[i]).Children.Count > 0 then
    raise Exception.Create(stNodeHasChildren);
  ParentNode.Children.Delete(i);
end;

procedure TDBConnection.SaveToFile(FileName: RawUtf8);
var
  ldif: TLDIFFile;
  i: Integer;

  procedure WriteNode(ANode: TEntryNode);
  var
    i: Integer;
  begin
    ldif.WriteRecord(ANode);
    for i := 0 to ANode.Children.Count - 1 do
      WriteNode(ANode.Children[i] as TEntryNode);
  end;

begin
  ldif := TLDIFFile.Create(FileName, fmWrite);
  try
    ldif.Encoding := fEncoding;
    { Skip the artificial root }
    for i := 0 to Root.Children.Count - 1 do
      WriteNode(Root.Children[i] as TEntryNode);
  finally
    ldif.Free;
  end;
end;

procedure TDBConnection.Connect;
begin
end;

procedure TDBConnection.Disconnect;
var
  Buttons: TMsgDlgButtons;
begin
  if not Connected then exit;

  if fModified then
  begin
    Buttons := [mbYes, mbNo];
    if not fDestroying then
      Buttons := Buttons + [mbCancel];
    case MessageDlg(Format(stFileModified, [(Account as TDBAccount).FileName]),
                  mtConfirmation, Buttons, 0) of
      mrYes: SaveToFile((Account as TDBAccount).FileName);
      mrCancel: Abort;
    end;
    fModified := false;
  end;
  OnDisconnect.Execute(self);
end;

function TDBConnection.ISConnected: Boolean;
begin
  Result := Assigned(Root);
end;

function TDBConnection.Lookup(sBase, sFilter, sResult: RawUtf8;
  Scope: TLdapSearchScope): RawUtf8;
var
  l: TLdapEntryList;

begin
  l := TLdapEntryList.Create;
  try
    Search(sFilter, sBase, Scope, nil, true, l);
    if l.Count > 0 then
      Result := l[0].AttributesByName[sResult].AsString
    else
      Result := '';
  finally
    l.Free;
  end;
end;

function TDBConnection.GetDn(sFilter: RawUtf8): RawUtf8;
var
  l: TLdapEntryList;

begin
  l := TLdapEntryList.Create;
  try
    Search(sFilter, Base, lssWholeSubtree, nil, true, l);
    if l.Count > 0 then
      Result := l[0].dn
    else
      Result := '';
  finally
    l.Free;
  end;
end;

end.
