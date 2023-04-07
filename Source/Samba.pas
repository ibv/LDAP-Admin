  {      LDAPAdmin - Samba.pas
  *      Copyright (C) 2003-2014 Tihomir Karlovic
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

unit Samba;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses Classes, PropertyObject, Posix, LDAPClasses, LinLDAP, Constant, Connection, Variants,
   mormot.core.base;

const
  WKRids: array[0..4] of Integer  = (
                                          500,    // Administrator
                                          501,    // Guest
                                          512,    // Domain Admins
                                          513,    // Domain Users
                                          514     // Domain Guests
                                     );

  { TDateTime value equivalent to Unix timestamp of 2147483647 }
  SAMBA_MAX_KICKOFF_TIME          = 50424.134803;

{ TDomainList }

type
  TDomainRec = class
  private
    fSession: TConnection;
  public
    DomainDn: RawUtf8;
    AlgorithmicRIDBase: Integer;
    DomainName: RawUtf8;
    SID: RawUtf8;
    constructor Create(Session: TConnection);
    function    GetNextUnixIdPoolRid: Integer;
    function    GetRidFromUid(uid: Integer): Integer;
  end;

  TDomainList = class(TList)
  private
    fSession:   TLdapSession;
    function    Get(Index: Integer): TDomainRec;
  public
    constructor Create(Session: TLDAPSession);
    destructor  Destroy; override;
    property    Items[Index: Integer]: TDomainRec read Get;
  end;


{ TSambaAccount }

const
    eSambaSID                  = 00;
    eSambaPrimaryGroupSID      = 01;
    eSambaPwdMustChange        = 02;
    eSambaPwdCanChange         = 03;
    eSambaPwdLastSet           = 04;
    eSambaKickoffTime          = 05;
    eSambaLogOnTime            = 06;
    eSambaLogoffTime           = 07;
    eSambaAcctFlags            = 08;
    eSambaNTPassword           = 09;
    eSambaLMPassword           = 10;
    eSambaHomeDrive            = 11;
    eSambaHomePath             = 12;
    eSambaLogonScript          = 13;
    eSambaProfilePath          = 14;
    eSambaUserWorkstations     = 15;
    eSambaDomainName           = 16;
    eSambaPasswordHistory      = 17;
    esambaMungedDial           = 18;
    esambaBadPasswordCount     = 19;
    esambaBadPasswordTime      = 20;
    sambaLogonHours            = 21;
    eSambaGroupType            = 22;
    eInetOrgDisplayName        = 23;

const
  Prop3AttrNames: array[eSambaSid..eInetOrgDisplayName] of RawUtf8 = (
    'sambaSID',
    'sambaPrimaryGroupSID',
    'sambaPwdMustChange',
    'sambaPwdCanChange',
    'sambaPwdLastSet',
    'sambaKickoffTime',
    'sambaLogOnTime',
    'sambaLogoffTime',
    'sambaAcctFlags',
    'sambaNTPassword',
    'sambaLMPassword',
    'sambaHomeDrive',
    'sambaHomePath',
    'sambaLogonScript',
    'sambaProfilePath',
    'sambaUserWorkstations',
    'sambaDomainName',
    'sambaPasswordHistory',
    'sambaMungedDial',
    'sambaBadPasswordCount',
    'sambaBadPasswordTime',
    'sambaLogonHours',
    'sambaGroupType',
    'displayName'
    );

type
  TSamba3Account = class(TPropertyObject)
  private
    fDomainData: TDomainRec;
    fPosixAccount: TPosixAccount;
    fNew: Boolean;
    fSavePwdLastSet: Variant;
    fLMPasswords: Boolean;
    procedure SetSid(Value: Integer);
    procedure SetUidNumber(Value: Integer);
    function  GetUidNumber: Integer;
    procedure SetGidNumber(Value: Integer);
    function  GetGidNumber: Integer;
    procedure SetPwdMustChange(Value: Boolean);
    function  GetPwdMustChange: Boolean;
    procedure SetDomainRec(tdr: TDomainRec);
    procedure SetFlag(Index: Integer; Value: Boolean);
    function  GetFlag(Index: Integer): Boolean;
    function  GetDomainSid: RawUtf8;
    function  GetRid: RawUtf8;
    function  GetDomainName: RawUtf8;
  public
    constructor Create(const Entry: TLdapEntry); override;
    procedure New; override;
    procedure Remove; override;
    procedure SetUserPassword(const Password: RawUtf8); virtual;
    property DomainData: TDomainRec write SetDomainRec;
    property UidNumber: Integer read GetUidNumber write SetUidNumber;
    property GidNumber: Integer read GetGidNumber write SetGidNumber;
    property Sid: RawUtf8 index eSambaSID read GetString;// write SetString;
    property DomainSID: RawUtf8 read GetDomainSid;
    property Rid: RawUtf8 read GetRid;
    property GroupSID: RawUtf8 index eSambaPrimaryGroupSID read GetString write SetString;
    property PwdMustChange: Boolean read GetPwdMustChange write SetPwdMustChange;
    property PwdCanChange: Boolean index eSambaPwdCanChange read GetBool write SetBool;
    property PwdLastSet: TDateTime index eSambaPwdLastSet read GetFromUnixTime;
    property KickoffTime: TDateTime index eSambaKickoffTime read GetFromUnixTime write SetAsUnixTime;
    property LogonTime: Integer index eSambaLogonTime read GetInt;
    property LogoffTime: Integer index eSambaLogoffTime read GetInt;
    property AcctFlags: RawUtf8 index eSambaAcctFlags read GetString;// write Properties[eSambaAcctFlags];
    property NTPassword: RawUtf8 index eSambaNTPassword read GetString;
    property LMPassword: RawUtf8 index eSambaLMPassword read GetString;
    property HomeDrive: RawUtf8 index eSambaHomeDrive read GetString write SetString;
    property HomePath: RawUtf8 index eSambaHomePath read GetString write SetString;
    property LogonScript: RawUtf8 index eSambaLogonScript read GetString write SetString;
    property ProfilePath: RawUtf8 index eSambaProfilePath read GetString write SetString;
    property UserWorkstations: RawUtf8 index eSambaUserWorkstations read GetString write SetString;
    property DomainName: RawUtf8 read GetDomainName;
    property GroupType: RawUtf8 index eSambaGroupType read GetString write SetString;
    property UserAccount: Boolean Index Ord('U') read GetFlag write SetFlag;
    property ComputerAccount: Boolean Index Ord('W') read GetFlag write SetFlag;
    property DomainTrust: Boolean Index Ord('I') read GetFlag write SetFlag;
    property ServerTrust: Boolean Index Ord('S') read GetFlag write SetFlag;
    property Disabled: Boolean Index Ord('D') read GetFlag write SetFlag;
    property RequestHomeDir: Boolean Index Ord('H') read GetFlag write SetFlag;
    property NoPasswordExpiration: Boolean Index Ord('X') read GetFlag write SetFlag;
    property Autolocked: Boolean Index Ord('L') read GetFlag write SetFlag;
    property LMPasswords: Boolean read fLMPasswords write fLMPasswords;
  end;

  TSamba3Computer = class(TSamba3Account)
  private
    function  GetUid: RawUtf8;
    procedure SetUid(Value: RawUtf8);
    function  GetDescription: RawUtf8;
    procedure SetDescription(Value: RawUtf8);
  public
    procedure New; override;
    property ComputerName: RawUtf8 read GetUid write SetUid;
    property Description: RawUtf8 read GetDescription write SetDescription;
  end;

  TSamba3Group = class(TPropertyObject)
  private
    function GetDomainSid: RawUtf8;
    function GetRid: RawUtf8;
  public
    constructor Create(const Entry: TLdapEntry); override;
    procedure New; override;
    procedure Remove; override;
    property GroupType: Integer index eSambaGroupType read GetInt write SetInt;
    property Sid: RawUtf8 index eSambaSID read GetString write SetString;
    property DomainSID: RawUtf8 read GetDomainSid;
    property Rid: RawUtf8 read GetRid;
    property DisplayName: RawUtf8 index eInetOrgDisplayName read GetString write SetString;
  end;

implementation

{$I LdapAdmin.inc}

uses {$IFDEF VARIANTS} variants, {$ENDIF} md4Samba, smbdes, Sysutils, Misc, Config;

const
  CT_ALGORITHMIC_RID   = 0;
  CT_SAMBA_NEXT_RID    = 1;

{ This function is ported from mkntpwd.c written by Anton Roeckseisen (anton@genua.de) }

function PutUniCode(var adst; src: PAnsiChar): Integer;
var
  i,ret: Integer;
  dst: array[0..255] of Byte absolute adst;
begin
  ret := 0;
  i := 0;
  while PByteArray(src)[i] <> 0 do
  begin
    dst[ret] := PByteArray(src)[i];
    inc(ret);
    dst[ret] := 0;
    inc(ret);
    Inc(i);
  end;
  dst[ret] := 0;
  dst[ret+1] := 0;
  Result := ret; { the way they do the md4 hash they don't represent
                    the last null. ie 'A' becomes just 0x41 0x00 - not
                    0x41 0x00 0x00 0x00 }
end;

function HashToHex(Hash: PByteArray; len: Integer): RawUtf8;
var
  i: Integer;
begin
  for i := 0 to len - 1 do
    Result := Result + IntToHex(Hash[i], 2);
end;

{ TDomainRec }

constructor TDomainRec.Create(Session: TConnection);
begin
  inherited Create;;
  fSession := Session;
end;

function TDomainRec.GetNextUnixIdPoolRid: Integer;
var
  Entry: TLdapEntry;
  i, nur, ngr: Integer;
begin
  Result := 999;
  nur := -1;
  ngr := -1;

  Entry := TLdapEntry.Create(fSession, DomainDn);
  with Entry do
  try
    Read; //TODO Read(attr,attr,...);

    for i := 0 to Attributes.Count - 1 do with Attributes[i] do
      if (Values[0].DataSize > 0) then
      try
        if (CompareText('sambaNextRid', Name) = 0) then
          Result := StrToInt(AsString)
        else
        if CompareText('sambaNextRid', Name) = 0 then
          nur := StrToInt(AsString)
        else
        if CompareText('sambaNextRid', Name) = 0 then
          ngr := StrToInt(AsString);
      except
        on E:EConvertError do
        begin
          e.Message := stConvErrSambaRid + #10#13 + e.Message;
          raise;
        end;
      end;

      if nur > Result then
        Result := nur;
      if ngr > Result then
        Result := ngr;

      Inc(Result, 1);
      AttributesByName['sambaNextRid'].AsString := IntToStr(Result);
      Write;
  finally
    Entry.Free;
  end;

end;

function TDomainRec.GetRidFromUid(uid: Integer): Integer;
begin
  if fSession.Account.ReadInteger(rSambaRidMethod) = CT_ALGORITHMIC_RID then
    Result := AlgorithmicRIDBase + 2 * uid
  else
    Result := GetNextUnixIdPoolRid;
end;

{ TDomainList}

constructor TDomainList.Create(Session: TLDAPSession);
var
  tDom: TDomainRec;
  attrs: PCharArray;
  EntryList: TLdapEntryList;
  i: Integer;
begin
  inherited Create;
  fSession := Session;
  // set result fields
  SetLength(attrs, 4);
  attrs[0] := 'sambaDomainName';
  attrs[1] := 'sambaAlgorithmicRIDBase';
  attrs[2] := 'sambaSID';
  attrs[3] := nil;
  EntryList := TLdapEntryList.Create;
  try
    Session.Search('(objectclass=sambadomain)', Session.Base, LDAP_SCOPE_SUBTREE,
                   attrs, false, EntryList);
    for i := 0 to EntryList.Count - 1 do with EntryList[i] do
    begin
      tDom := TDomainRec.Create(Session as TConnection);
      Add(tDom);
      with tDom do
      begin
        DomainDn := dn;
        DomainName := AttributesByName[attrs[0]].AsString;
        try
          AlgorithmicRidBase := StrToInt(AttributesByName[attrs[1]].AsString);
        except
          on E:EConvertError do
            AlgorithmicRidBase := 1000;
          else raise;
        end;
        SID := AttributesByName[attrs[2]].AsString;
      end;
    end;
  finally
    EntryList.Free;
  end;
end;

destructor TDomainList.Destroy;
var
  i: Integer;
begin
  for i := 0 to Count - 1 do
    Items[i].Free;
  inherited Destroy;
end;

function TDomainList.Get(Index: Integer): TDomainRec;
begin
  Result := inherited Items[Index];
end;

{ TSambaAccount }

procedure TSamba3Account.SetSid(Value: Integer);
begin
  if not Assigned(fDomaindata) then
    SetString(eSambaSID, '')
  else
  if IsNull(eSambaSid) or not (asBrowse in Attributes[eSambaSid].State) then
    SetString(eSambaSID, Format('%s-%d', [fDomainData.SID, fDomainData.GetRidFromUid(Value)]))
end;

procedure TSamba3Account.SetDomainRec(tdr: TDomainRec);
begin
  fDomainData := tdr;
  if fNew and Assigned(fDomaindata) then
  begin
    SetString(eSambaDomainName, fDomainData.DomainName);
    if not fPosixAccount.IsNull(eUidNumber) then
      SetSid(UidNumber);
    if IsNull(eSambaPrimaryGroupSID) and not fPosixAccount.IsNull(eGidNumber) then
      SetGidNumber(fPosixAccount.GidNumber)
  end;
end;

procedure TSamba3Account.SetUidNumber(Value: Integer);
begin
  fPosixAccount.UidNumber := Value;
  SetSid(Value);
end;

function TSamba3Account.GetUidNumber: Integer;
begin
  Result := fPosixAccount.UidNumber;
end;

procedure TSamba3Account.SetGidNumber(Value: Integer);
begin
  if Assigned(fDomainData) then
     SetString(eSambaPrimaryGroupSID, fEntry.Session.Lookup(fEntry.Session.Base, Format(sGROUPBYGID, [Value]), 'sambasid', LDAP_SCOPE_SUBTREE))
  else
    SetString(eSambaPrimaryGroupSID, '');
  fPosixAccount.GidNumber := Value;
end;

function TSamba3Account.GetGidNumber: Integer;
begin
  Result := fPosixAccount.GidNumber;
end;

function TSamba3Account.GetFlag(Index: Integer): Boolean;
begin
  Result := Pos(Char(Index), GetString(eSambaAcctFlags)) <> 0;
end;

procedure TSamba3Account.SetFlag(Index: Integer; Value: Boolean);
var
  i: Integer;
  s: RawUtf8;
begin
  s := GetString(eSambaAcctFlags);
  i := Pos(Char(Index), s);
  if Value then // set
  begin
    if i = 0 then
      Insert(Char(Index), s, 2);
  end
  else begin    // unset
    if i <> 0 then
      System.Delete(s, i, 1);
  end;
  SetString(eSambaAcctFlags, s);
end;

function TSamba3Account.GetDomainSid: RawUtf8;
var
  p: Integer;
begin
  p := LastDelimiter('-', Sid);
  Result := System.Copy(Sid, 1, p - 1);
end;

function TSamba3Account.GetRid: RawUtf8;
var
  p: Integer;
begin
  p := LastDelimiter('-', Sid);
  Result := PChar(@Sid[p + 1]);
end;

function TSamba3Account.GetDomainName: RawUtf8;
var
  i: Integer;
begin
  Result := GetString(eSambaDomainName);
  if Result = '' then // try to get domain name from sid
  begin
    with TDomainList.Create(fEntry.Session) do
    try
      for i := 0 to Count - 1 do
        if Items[i].SID = DomainSID then
          Result := Items[i].DomainName;
    finally
      Free;
    end;
  end;
end;

procedure TSamba3Account.SetUserPassword(const Password: RawUtf8);
var
  Passwd: array[0..255] of Byte;
  Hash: array[0..16] of Byte;
  slen: Integer;
begin
  inherited;
  { Get NT Password }
  fillchar(passwd, 255, 0);
  slen := PutUniCode(Passwd, PAnsiChar(AnsiString(Password)));
  fillchar(hash, 17, 0);
  mdfour(hash, Passwd, slen);
  SetString(eSambaNTPassword, HashToHex(@Hash, 16));
  { Get Lanman Password }
  if fLMPasswords then
    SetString(eSambaLMPassword, HashToHex(PByteArray(e_p16(UpperCase(Password))), 16))
  else
    Attributes[eSambaLMPassword].Delete;
  { Set changetime attribute }
  SetAsUnixTime(eSambaPwdLastSet, LocalDateTimeToUTC(Now));
end;

{ There is a change in behaviour Since Samba 3.0.25. To force a user to }
{ change a password the attribute sambaPwdLastSet must be set to 0 }
procedure TSamba3Account.SetPwdMustChange(Value: Boolean);
begin
  if VarIsEmpty(fSavePwdLastSet) then
     fSavePwdLastSet := GetInt(eSambaPwdLastSet);
  if Value then
    SetInt(eSambaPwdLastSet, 0)
  else begin
    if fSavePwdLastSet = 0 then
      Attributes[eSambaPwdLastSet].Delete
    else
      SetInt(eSambaPwdLastSet, fSavePwdLastSet);
  end;
  SetBool(eSambaPwdMustChange, Value);
end;

function  TSamba3Account.GetPwdMustChange: Boolean;
begin
  Result := GetBool(eSambaPwdMustChange);
end;

constructor TSamba3Account.Create(const Entry: TLdapEntry);
begin
  inherited Create(Entry, 'sambaSamAccount', @Prop3AttrNames);
  fPosixAccount := TPosixAccount.Create(Entry);
end;

procedure TSamba3Account.New;
begin
  AddObjectClass(['sambaSamAccount']);
  SetString(eSambaAcctFlags, '[]');
  SetSid(UidNumber);
  fNew := true;
end;

procedure TSamba3Account.Remove;
var
  i: Integer;
begin
  RemoveObjectClass(['sambaSamAccount']);
  for i := eSambaSid to eSambaGroupType do
    SetString(i, '');
end;

{ TSamba3Computer }

function TSamba3Computer.GetUid: RawUtf8;
begin
  Result := fPosixAccount.uid;
end;

procedure TSamba3Computer.SetUid(Value: RawUtf8);
begin
  Value := UpperCase(Value);
  if Value[Length(Value)] <> '$' then
    Value := Value + '$';
  fPosixAccount.Uid := Value;
  fPosixAccount.Cn := Value;
end;

function TSamba3Computer.GetDescription: RawUtf8;
begin
  Result := fPosixAccount.Description;
end;

procedure TSamba3Computer.SetDescription(Value: RawUtf8);
begin
  fPosixAccount.Description := Value;
end;

procedure TSamba3Computer.New;
begin
  inherited;
  AddObjectClass(['top', 'account', 'posixAccount', 'shadowAccount']);
  fPosixAccount.LoginShell := '/bin/false';
  fPosixAccount.HomeDirectory := '/dev/null';
  GidNumber := COMPUTER_GROUP;
  ComputerAccount := true;
end;

{ TSamba3Group }

function TSamba3Group.GetDomainSid: RawUtf8;
var
  p: Integer;
begin
  p := LastDelimiter('-', Sid);
  Result := System.Copy(Sid, 1, p - 1);
end;

function TSamba3Group.GetRid: RawUtf8;
var
  p: Integer;
begin
  p := LastDelimiter('-', Sid);
  Result := PChar(@Sid[p + 1]);
end;

constructor TSamba3Group.Create(const Entry: TLdapEntry);
begin
  inherited Create(Entry, 'sambaGroupMapping', @Prop3AttrNames);
end;

procedure TSamba3Group.New;
begin
  inherited;
  GroupType := 2;
end;

procedure TSamba3Group.Remove;
begin
  inherited;
  SetString(eSambaGroupType, '');
  Sid := '';
  DisplayName := '';
end;

end.

