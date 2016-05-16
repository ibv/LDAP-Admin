  {      LDAPAdmin - Connection.pas
  *      Copyright (C) 2012-2013 Tihomir Karlovic
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

uses Config, Sorter, Schema, LDAPClasses, CustomMenus, Controls, Templates,
     Constant;

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
                    bmContainer,
                    bmADGroup,
                    bmClassSchema,
                    bmAttributeSchema,
                    bmSchema,
                    bmConfiguration);

type

  TDirectoryType = (dtAutodetect, dtPosix, dtActiveDirectory);

  TConnection = class;

  IDirectoryIdentity = Interface
    function  ClassifyLdapEntry(Entry: TLdapEntry): Integer;
    function  NewProperty(Owner: TControl; const Index: Integer; const dn: string): Boolean;
    function  EditProperty(Owner: TControl; const Index: Integer; const dn: string): Boolean;
    function  ChangePassword(Entry: TLdapEntry): Boolean;
    function  IsContainer(Index: Integer): Boolean;
    function  CreateMenu: TCustomActionMenu;
  end;

  TConnection = class(TLdapSession)
  private
    FAccount:   TAccount;
    FLVSorter:  TListViewSorter;
    FSchema:    TLdapSchema;
    FSelected:  string;
    FDirectoryIdentity: IDirectoryIdentity;
    FActionMenu: TCustomActionMenu;
    function    GetDirectoryType: TDirectoryType;
    function    GetDirectoryIdentity: IDirectoryIdentity;
    function    GetActionMenu: TCustomActionMenu;
    function    GetSchema: TLdapSchema;
    function    GetFreeRandomNumber(const Min, Max: Integer; const Objectclass, id: string): Integer;
    function    GetSequentialNumber(const Min, Max: Integer; const Objectclass, id: string): Integer;
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
    property    LVSorter: TListViewSorter read FLVSorter write FLVSorter;
    property    Schema: TLdapSchema read GetSchema;
    property    Selected: string read FSelected write FSelected;
    property    DirectoryType: TDirectoryType read GetDirectoryType;
    property    DI: IDirectoryIdentity read GetDirectoryIdentity;
    property    ActionMenu: TCustomActionMenu read GetActionMenu;
  end;

var
  UseTemplateImages: Boolean;

implementation

uses SysUtils, {$ifdef mswindows}WinLDAP,{$else} LinLDAP,{$endif}User, Host, Locality, Computer, Group, {TemplateCtrl,}
     MailGroup, Transport, Ou, Classes, PassDlg, ADPassDlg, Alias;

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
    function  NewProperty(Owner: TControl; const Index: Integer; const dn: string): Boolean;
    function  EditProperty(Owner: TControl; const Index: Integer; const dn: string): Boolean;
    function  ChangePassword(Entry: TLdapEntry): Boolean;
    function  IsContainer(Index: Integer): Boolean;
    function  CreateMenu: TCustomActionMenu;
  end;

  TADDirectoryIdentity = class(TCustomDirectoryIdentity, IDirectoryIdentity)
  public
    function  ClassifyLdapEntry(Entry: TLdapEntry): Integer;
    function  NewProperty(Owner: TControl; const Index: Integer; const dn: string): Boolean;
    function  EditProperty(Owner: TControl; const Index: Integer; const dn: string): Boolean;
    function  ChangePassword(Entry: TLdapEntry): Boolean;
    function  IsContainer(Index: Integer): Boolean;
    function  CreateMenu: TCustomActionMenu;
  end;

function TConnection.GetDirectoryType: TDirectoryType;
begin
  Result := TDirectoryType(Account.ReadInteger(rDirectoryType, Integer(dtAutodetect)));
  if (Result = dtAutodetect) and Connected then
  begin
    if Lookup('', sAnyClass,'isGlobalCatalogReady', LDAP_SCOPE_BASE) <> '' then
      Result := dtActiveDirectory
    else
      Result := dtPosix;
    Account.WriteInteger(rDirectoryType, Integer(Result));
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
  FLVSorter := TListViewSorter.Create;
end;

destructor TConnection.Destroy;
begin
  FActionMenu.Free;
  FSchema.Free;
  FLVSorter.Free;
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
function TConnection.GetFreeRandomNumber(const Min, Max: Integer; const Objectclass, id: string): Integer;
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
    if Lookup(Base, Format('(&(objectclass=%s)(%s=%d))', [Objectclass, id, Result]), 'objectclass', LDAP_SCOPE_SUBTREE) = '' then
      exit;
    uidpool[r] := uidpool[N - 1];
    dec(N);
  end;
  Result := -1;
end;

{ Get sequential free uidNumber from the pool of available numbers, return -1 if
  no more free numbers are available }
function TConnection.GetSequentialNumber(const Min, Max: Integer; const Objectclass, id: string): Integer;
var
  attrs: PCharArray;
  i, n: Integer;
  SearchList: TLdapEntryList;
begin
  Result := Min;
  SetLength(attrs, 2);
  attrs[0] := PChar(id);
  attrs[1] := nil;

  SearchList := TLdapEntryList.Create;
  try
    Search(Format('(objectclass=%s)', [Objectclass]), Base, LDAP_SCOPE_ONELEVEL, attrs, false, SearchList);
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
  Attr: TLdapAttribute;
  i: integer;
  s: string;

  function IsComputer(const s: string): Boolean;
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

function  TPosixDirectoryIdentity.NewProperty(Owner: TControl; const Index: Integer; const dn: string): Boolean;
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

function TPosixDirectoryIdentity.EditProperty(Owner: TControl; const Index: Integer; const dn: string): Boolean;
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
  Attr: TLdapAttribute;
  i: integer;
  s: string;
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

function  TADDirectoryIdentity.NewProperty(Owner: TControl; const Index: Integer; const dn: string): Boolean;
begin
  Result := true;
  case Index of
    aidOu:       TOuDlg.Create(Owner, dn, Connection, EM_ADD).ShowModal;
    aidHost:     THostDlg.Create(Owner, dn, Connection, EM_ADD).ShowModal;
    aidLocality: TLocalityDlg.Create(Owner, dn, Connection, EM_ADD).ShowModal;
  else
    Result := false;
  end;
end;

function TADDirectoryIdentity.EditProperty(Owner: TControl; const Index: Integer; const dn: string): Boolean;
begin
  Result := true;
  case Index of
    oidOu:           TOuDlg.Create(Owner, dn, Connection, EM_MODIFY).ShowModal;
    oidLocality:     TLocalityDlg.Create(Owner, dn, Connection, EM_MODIFY).ShowModal;
    oidHost:         THostDlg.Create(Owner, dn, Connection, EM_MODIFY).ShowModal;
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

end.
