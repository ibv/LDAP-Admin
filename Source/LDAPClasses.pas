  {      LDAPAdmin - LDAPClasses.pas
  *      Copyright (C) 2003-2016 Tihomir Karlovic
  *
  *      Author: Tihomir Karlovic
  *
  *      Modifications:  Ivo Brhel, 2016
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

unit LDAPClasses;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

{$M+}

interface

uses
{$IFnDEF FPC}
  Windows,  WinLDAP,
{$ELSE}
  LCLIntf, LCLType, LazUtils, LinLDAP, lazutf8, LazFileUtils,
{$ENDIF}
  Sysutils,  Classes, Events, Constant, mormot.net.ldap, mormot.core.base;

const
  LdapOpRead            = $FFFFFFFF;
  LdapOpNoop            = $FFFFFFFE;
  LdapOpAdd             = LDAP_MOD_ADD;
  LdapOpReplace         = LDAP_MOD_REPLACE;
  LdapOpDelete          = LDAP_MOD_DELETE;

  SESS_TIMEOUT          = 0;
  SESS_SIZE_LIMIT       = 0;
  SESS_PAGE_SIZE        = 100;
  SESS_REFF_HOP_LIMIT   = 32;

  AUTH_SIMPLE           = $00;
  AUTH_GSS              = $01;
  AUTH_GSS_SASL         = $03;

  StandardOperationalAttributes = 'createTimestamp,' +
                                  'modifyTimestamp,' +
                                  'creatorsName,' +
                                  'modifiersName,' +
                                  'subschemaSubentry,' +
                                  'structuralObjectClass,' +
                                  'hasSubordinates,' +
                                  'entryCSN,' +
                                  'entryUUID';

  LdapInvalidChars = ['=','+','"','\',',','>','<','#',';'];
  LdapEscapableChars = LdapInvalidChars + [' ']; // Space is invalid only at the end or the beginning of the sting


type
  ErrLDAP = class(Exception)
  private
    FErrorCode: ULONG;
    FExtErrorCode: ULONG;
  public
    constructor Create(ErrCode, ExtErrCode: ULONG; Msg: RawUtf8);
    property    ErrorCode: ULONG read FErrorCode write FErrorCode;
    property    ExtErrorCode: ULONG read FExtErrorCode write FExtErrorCode;
  end;

  PBytes = array of Byte;
  PCharArray = array of PChar;
  PPLDAPMod = array of PLDAPMod;
  PPLdapBerValA = array of PLdapBerVal;

  TLdapAttributeData = class;
  TLdapAttribute     = class;
  TLdapAttributeList = class;
  TLdapEntry         = class;
  TLdapEntryList     = class;

  TDataType = (dtUnknown, dtText, dtBinary, dtJpeg, dtCert);
  TLdapAttributeStates = set of (asNew, asBrowse, asModified, asDeleted);
  TLdapEntryStates = set of (esNew, esBrowse, esReading, esWriting, esModified, esDeleted);
  TLdapAttributeSortType = (AT_Attribute, AT_DN, AT_RDN, AT_Path);

  TSearchCallback = procedure (Sender: TLdapEntryList; var AbortSearch: Boolean) of object;

  TCompareLdapEntry = procedure(Entry1, Entry2: TLdapEntry; Data: pointer; out Result: Integer) of object;
  TDataNotifyEvent = procedure(Sender: TLdapAttributeData) of object;

  TLdapAuthMethod = Integer;

  { TLdapAttributeData }

  TLdapAttributeData = class
  private
    fBerval: record
      Bv_Len: Cardinal;
      Bv_Val: PBytes;
    end;
    fAttribute: TLdapAttribute;
    fEntry: TLdapEntry;
    fModOp: Cardinal;
    fSchemaAttribute: TObject;
    //fType: TDataType; there is no need to determine this on per value basis
    fUtf8: Boolean;
    function GetType: TDataType;
    function GetString: RawUtf8;
    procedure SetString(AValue: RawUtf8);
    function BervalAddr: PLdapBerval;
  public
    constructor Create(Attribute: TLdapAttribute); virtual;
    function CompareData(P: Pointer; Length: Integer): Boolean;
    procedure SetData(AData: Pointer; ADataSize: Cardinal);
    procedure Delete;
    procedure LoadFromStream(Stream: TStream);
    procedure SaveToStream(Stream: TStream);
    property DataType: TDataType read GetType;
    property AsString: RawUtf8 read GetString write SetString;
    property DataSize: Cardinal read fBerval.Bv_Len;
    property Data: PBytes read fBerval.Bv_Val;
    property Berval: PLdapBerval read BervalAddr;
    property ModOp: Cardinal read fModOp write fModOp;
    property Attribute: TLdapAttribute read fAttribute;
    property SchemaAttribute: TObject read fSchemaAttribute write fSchemaAttribute ;
  end;

  TLdapAttribute = class
  private
    fState: TLdapAttributeStates;
    fName: RawUtf8;
    fValues: TList;
    fOwnerList: TLdapAttributeList;
    fEntry: TLdapEntry;
    fDataType: TDataType;
    function GetCount: Integer;
    function GetValue(Index: Integer): TLdapAttributeData;
    function GetString: RawUtf8;
    procedure SetString(AValue: RawUtf8);
    function GetDataType: TDataType;
    function GetEmpty: Boolean;
  public
    constructor Create(const AName: RawUtf8; OwnerList: TLdapAttributeList); virtual;
    destructor Destroy; override;
    function  AddValue: TLdapAttributeData; overload;
    procedure AddValue(const AValue: RawUtf8); overload; virtual;
    procedure AddValue(const AData: Pointer; const ADataSize: Cardinal); overload; virtual;
    procedure DeleteValue(const AValue: RawUtf8); virtual;
    procedure Delete;
    function IndexOf(const AValue: RawUtf8): Integer; overload;
    function IndexOf(const AData: Pointer; const ADataSize: Cardinal): Integer; overload;
    procedure MoveIndex(Index: Integer);
    property Values[Index: Integer]: TLdapAttributeData read GetValue; default;
  published
    property State: TLdapAttributeStates read fState;
    property Name: RawUtf8 read fName;
    property ValueCount: Integer read GetCount;
    property AsString: RawUtf8 read GetString write SetString;
    property Entry: TLdapEntry read fEntry;
    property DataType: TDataType read GetDataType;
    property Empty: Boolean read GetEmpty;
  end;

  TLdapAttributeList = class
  private
    fList: TList;
    fEntry: TLdapEntry;
    function GetCount: Integer;
    function GetNode(Index: Integer): TLdapAttribute;
  public
    constructor Create(Entry: TLdapEntry); virtual;
    destructor Destroy; override;
    function Add(const AName: RawUtf8): TLdapAttribute;
    //function Insert(const AName: RawUtf8; Index: Integer): TLdapAttribute;
    function IndexOf(const Name: RawUtf8): Integer;
    function AttributeOf(const Name: RawUtf8): TLdapAttribute;
    procedure Clear;
    procedure Delete(Index: Integer);
    property Items[Index: Integer]: TLdapAttribute read GetNode; default;
    property Count: Integer read GetCount;
  end;

  { TLDAPSession }

  TLDAPSession = class
  private
    fTimeLimit: Integer;
    ldappld: TLdapClient;
    ldapVersion: Integer;
    ldapBase: RawUtf8;
    ldapSSL: Boolean;
    ldapAuthMethod: TLdapAuthMethod;
    fSizeLimit: Integer;
    fPagedSearch: Boolean;
    fPageSize: Integer;
    fDerefAliases: Integer;
    fChaseReferrals: Boolean;
    fReferralHops: Integer;
    fOnConnect: TNotifyEvents;
    fOnDisconnect: TNotifyEvents;
    fOperationalAttrs: TRawByteStringDynArray;
    function GetPassword: SpiUtf8;
    function GetPort: RawUtf8;
    function GetServer: RawUtf8;
    function GetSettings: TLdapClientSettings;
    function GetTls: Boolean;
    function GetUser: RawUtf8;
    procedure LDAPCheck(const err: ULONG; const Critical: Boolean = true);
    procedure SetLdapSettings(AValue: TLdapClientSettings);
    procedure SetPassword(AValue: SpiUtf8);
    procedure SetServer(AValue: RawUtf8);
    procedure SetUser(AValue: RawUtf8);
    procedure SetPort(AValue: RawUtf8);
    procedure SetVersion(Version: Integer);
    procedure SetConnect(DoConnect: Boolean);
    procedure SetSSL(Value: Boolean);
    procedure SetTLS(Value: Boolean);
    procedure SetLdapAuthMethod(Method: TLdapAuthMethod);
    procedure SetTimeLimit(const Value: Integer);
    procedure SetSizeLimit(const Value: Integer);
    procedure SetDerefAliases(const Value: Integer);
    procedure SetChaseReferrals(const Value: boolean);
    procedure SetReferralHops(const Value: Integer);
    function  GetOperationalAttrs: RawUtf8;
    procedure SetOperationalAttrs(const Value: RawUtf8);
    procedure ProcessSearchEntry(const plmEntry: TLDAPResult; Attributes: TLdapAttributeList);
    procedure ProcessSearchMessage(const plmSearch: TLdapClient; const NoValues: LongBool; Result: TLdapEntryList);
  protected
    function  ISConnected: Boolean; virtual;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Connect; virtual;
    procedure Disconnect; virtual;
    property pld: TLdapClient read ldappld;
    property Settings: TLdapClientSettings read GetSettings write SetLdapSettings;
    property Server: RawUtf8 read GetServer write SetServer;
    property User: RawUtf8 read GetUser write SetUser;
    property Password: SpiUtf8 read GetPassword write SetPassword;
    property Port: RawUtf8 read GetPort write SetPort;
    property TLS: Boolean read GetTls write SetTLS;
    property Version: Integer read ldapVersion write SetVersion;
    property SSL: Boolean read ldapSSL write SetSSL;
    property AuthMethod: TLdapAuthMethod read ldapAuthMethod write SetLdapAuthMethod;
    property Base: RawUtf8 read ldapBase write ldapBase;
    property TimeLimit: Integer read fTimeLimit write SetTimeLimit;
    property SizeLimit: Integer read fSizeLimit write SetSizeLimit;
    property PagedSearch: Boolean read fPagedSearch write fPagedSearch;
    property PageSize: Integer read fPageSize write fPageSize;
    property DereferenceAliases: Integer read fDerefAliases write SetDerefAliases;
    property ChaseReferrals: Boolean read fChaseReferrals write SetChaseReferrals;
    property ReferralHops: Integer read fReferralHops write SetReferralHops;
    property Connected: Boolean read IsConnected write SetConnect;
    function Lookup(sBase, sFilter, sResult: RawUtf8; Scope: TLdapSearchScope
      ): RawUtf8; virtual;
    function GetDn(sFilter: RawUtf8): RawUtf8; virtual;
    procedure Search(const Filter, Base: RawUtf8; const Scope: TLdapSearchScope; QueryAttrs: array of RawUtf8; const NoValues: LongBool; Result: TLdapEntryList; SearchProc: TSearchCallback = nil); overload;
    procedure Search(const Filter, Base: RawUtf8; const Scope: TLdapSearchScope; attrs: TRawByteStringDynArray; const NoValues: LongBool; Result: TLdapEntryList; SearchProc: TSearchCallback = nil); overload; virtual;
    procedure ModifySet(const Filter, Base: RawUtf8; const Scope: TLdapSearchScope;
      argNames: array of RawUtf8; argVals: array of RawUtf8;
  argNewVals: array of RawUtf8; const ModOp: Cardinal);
    procedure WriteEntry(Entry: TLdapEntry); virtual;
    procedure ReadEntry(Entry: TLdapEntry); overload; virtual;
    procedure ReadEntry(Entry: TLdapEntry; Attributes: TRawByteStringDynArray);
      overload; virtual;
    procedure DeleteEntry(const adn: RawUtf8); virtual;
    function  RenameEntry(const OldDn, NewRdn, NewParent: RawUtf8; FailOnError: Boolean = true): Cardinal;
    property  OnConnect: TNotifyEvents read FOnConnect;
    property  OnDisconnect: TNotifyEvents read FOnDisconnect;
    property  OperationalAttrs: RawUtf8 read GetOperationalAttrs write SetOperationalAttrs;
  end;

  TLDAPEntry = class
  private
    fSession: TLDAPSession;
    fdn: RawUtf8;
    fAttributes: TLdapAttributeList;
    fOperationalAttributes: TLdapAttributeList;
    fObjectClass: TLdapAttribute;
    fState: TLdapEntryStates;
    fOnChangeProc: TDataNotifyEvent;
    fOnRead: TNotifyEvent;
    fOnWrite: TNotifyEvent;
    function GetNamedAttribute(const AName: RawUtf8): TLdapAttribute;
    function GetObjectClass: TLdapAttribute;
  protected
    procedure SetDn(const adn: RawUtf8);
    procedure SetUtf8Dn(const adn: RawUtf8);
    function  GetUtf8Dn: RawUtf8;
  public
    ObjectId: Integer;
    property Session: TLDAPSession read fSession;
    constructor Create(const ASession: TLDAPSession; const adn: RawUtf8); virtual;
    destructor Destroy; override;
    procedure Read; overload; virtual;
    procedure Read(Attributes: TRawByteStringDynArray); overload; virtual;
    procedure Write; virtual;
    procedure Delete; virtual;
    procedure Clone(ToEntry: TLdapEntry); virtual;
    property Attributes: TLdapAttributeList read fAttributes;
    property AttributesByName[const Name: RawUtf8]: TLdapAttribute read GetNamedAttribute;
    property OperationalAttributes: TLdapAttributeList read fOperationalAttributes;
  published
    { dn is internally saved as escaped LDAP RawUtf8, as returned from LDAP server.
      We cannot encode dn on write, since we cannot decide reliably if the
      particular ',' or '=' character should be escaped or not. This means that we
      have to deal with encoding before we assign a value to the dn property which
      is basically only when we deal with a user input. And, since vast majority of
      dn assignments happens internally we have an advantage of no performance impact }
    property dn: RawUtf8 read fdn write SetDn;
    { To avoid perpetual conversions, fdn is internaly coded as UNICODE and not as
      Utf8. The ldap_add_s and ldap_modify_s Windows API functions need no converting,
      since the corresponding API UNICODE functions, which insure propper handling,
      are called. That leavs us with neccessity to convert dn specificaly to UTF8
      for base64 encoding when exporting entry to LDIF or DSML, hence utf8dn property }
    property utf8dn: RawUtf8 read GetUtf8Dn write SetUtf8Dn;
    property State: TLdapEntryStates read fState;
    property OnChange: TDataNotifyEvent read fOnChangeProc write fOnChangeProc;
    property OnRead: TNotifyEvent read fOnRead write fOnRead;
    property OnWrite: TNotifyEvent read fOnWrite write fOnWrite;
    property ObjectClass: TLdapAttribute read GetObjectClass;
  end;

  TLdapEntryList = class
  private
    fList:        TList;
    fOwnsEntries: Boolean;
    function      GetCount: Integer;
    function      GetNode(Index: Integer): TLdapEntry;
  public
    constructor   Create(AOwnsObjects: Boolean = true);
    destructor    Destroy; override;
    procedure     Add(Entry: TLdapEntry);
    procedure     Delete(Index: Integer);
    procedure     Extract(Index: Integer);
    procedure     Clear;
    function      IndexOf(adn: RawUtf8): Integer;
    property      Items[Index: Integer]: TLdapEntry read GetNode; default;
    property      Count: Integer read GetCount;
    procedure     Sort(const Attributes: array of RawUtf8; const Asc: boolean); overload;
    procedure     Sort(const Compare: TCompareLdapEntry; const Asc: boolean; const Data: pointer=nil); overload;
    property      OwnsEntries: Boolean read fOwnsEntries write fOwnsEntries;
  end;

{ Name handling routines }
function  DecodeLdapString(const Src: RawUtf8; const Escape: Char ='\'): RawUtf8;
function  EncodeLdapString(const Src: RawUtf8; const Escape: Char ='\'): RawUtf8;
function  IsValidDn(Value: RawUtf8): Boolean;
function  CanonicalName(dn: RawUtf8): RawUtf8;
procedure SplitRdn(const dn: RawUtf8; var attrib, value: RawUtf8);
function  GetAttributeFromDn(const dn: RawUtf8): RawUtf8;
function  GetNameFromDn(const dn: RawUtf8): RawUtf8;
function  GetRdnFromDn(const dn: RawUtf8): RawUtf8;
function  GetDirFromDn(const dn: RawUtf8): RawUtf8;


function GetAttributeSortType(Attribute: RawUtf8): TLdapAttributeSortType;

const
  PSEUDOATTR_DN         = '*DN*';
  PSEUDOATTR_RDN        = '*RDN*';
  PSEUDOATTR_PATH       = '*PATH*';

var
  RawLdapStrings: Boolean = false;

implementation

{$I LdapAdmin.inc}

uses Misc, Input, Dialogs, Cert, Gss, System.UITypes, HtmlMisc, mormot.net.dns;

{ Name handling routines }

function DecodeLdapString(const Src: RawUtf8; const Escape: Char ='\'): RawUtf8;
var
  i, d, l: Integer;
begin
  Result := Src;
  if RawLdapStrings then
    exit;
  l := Length(Src);
  if l = 0 then
    exit;
  i := 1;
  d := 1;
  while i < l do
  begin
    if Src[i] = Escape then
    begin
      Delete(Result, d, 1);
      inc(i);
      if not (Src[i] in LdapEscapableChars) then
      begin
        HexToBin(PChar(@Src[i]), @Result[d], 1);
        inc(i);
        Delete(Result, d + 1, 1);
      end;
    end;
    inc(d);
    inc(i);
  end;
end;

function EncodeLdapString(const Src: RawUtf8; const Escape: Char ='\'): RawUtf8;
var
  i, d, l: Integer;
begin
  Result := Src;
  if RawLdapStrings then
    exit;
  l := Length(Src);
  if l = 0 then
    exit;
  d := 2;
  for i := 2 to l - 1 do
  begin
    if Src[i] in LdapInvalidChars then
    begin
      Insert(Escape, Result, d);
      inc(d);
    end;
    inc(d);
  end;
  if Src[1] in LdapEscapableChars then
    Insert(Escape, Result, 1);
  if Src[l] in LdapEscapableChars then
    Insert(Escape, Result, Length(Result));
end;


function IsValidDn(Value: RawUtf8): Boolean;
var
  i: Integer;
  comp: TStringList;
begin
  result:=true;
  comp:=TStringList.Create;
  if ldap_explode_dn(PChar(Value), 0, comp) then
  for i:=0 to comp.Count-1 do
  begin
    if StrScan(PChar(comp[i]), '=') = nil then
    begin
      result:=false;
      break;
    end;
  end;
  comp.Free;
end;

function CanonicalName(dn: RawUtf8): RawUtf8;
var
  comp: TStringList;
  i: Integer;
begin
  Result := '';
  comp:=TStringList.Create;
  if ldap_explode_dn(PChar(dn), 1, comp) then
    for i:=0 to comp.Count-1 do
    begin
      Result := Result + comp[i] + '/';
    end;
  comp.Free;
end;

function SkipEscaped(p: PChar): PChar; inline;
begin
  Result := p + 1;
  if Result^ = #0 then
    exit;
  if not (Result^ in LdapEscapableChars) then
  begin
    Result := p + 1;  // skip the two-byte hex code
    if Result^ = #0 then
      exit;
    Result := p + 1;
  end;
end;

procedure SplitRdn(const dn: RawUtf8; var attrib, value: RawUtf8);
var
  p, p0, p1: PChar;
begin
  p := PChar(dn);
  p0 := p;
  while (p^ <> #0) and (p^ <> '=') do
    p := p + 1;
  SetString(attrib, p0, p - p0);
  p := p + 1;
  p1 := p;
  while (p1^ <> #0) and (p1^ <> ',') do
  begin
    if p1^ = '\' then
    begin
      p1 := SkipEscaped(p1);
      if p1^ = #0 then
        break;
    end;
    p1 := p1 + 1;
  end;
  SetString(value, P, P1 - P);
end;

function GetAttributeFromDn(const dn: RawUtf8): RawUtf8;
var
  p, p1: PChar;
begin
  p := PChar(dn);
  p1 := p;
  while (p1^ <> #0) and (p1^ <> '=') do
    p1 := p1 + 1;
  SetString(Result, P, P1 - P);
end;

function GetNameFromDn(const dn: RawUtf8): RawUtf8;
var
  p, p1: PChar;
begin
  p := PChar(dn);
  while (p^ <> #0) and (p^ <> '=') do
    p := p + 1;
  p := p + 1;
  p1 := p;
  while (p1^ <> #0) and (p1^ <> ',') do
  begin
    if p1^ = '\' then
    begin
      p1 := SkipEscaped(p1);
      if p1^ = #0 then
        break;
    end;
    p1 := p1 + 1;
  end;
  SetString(Result, P, P1 - P);
end;

function GetRdnFromDn(const dn: RawUtf8): RawUtf8;
var
  p, p1: PChar;
begin
  p := PChar(dn);
  p1 := p;
  while (p1^ <> #0) and (p1^ <> ',') do
  begin
    if p1^ = '\' then
    begin
      p1 := SkipEscaped(p1);
      if p1^ = #0 then
        break;
    end;
    p1 := p1 + 1;
  end;
  SetString(Result, P, P1 - P);
end;

function GetDirFromDn(const dn: RawUtf8): RawUtf8;
var
  p: PChar;
begin
  p := PChar(dn);
  while (p^ <> #0) do
  begin
    if p^ = '\' then
    begin
      p := SkipEscaped(p);
      if p^ = #0 then
        break;
    end
    else
    if (p^ = ',') then
    begin
      p := p + 1;
      break;
    end;
    p := p + 1;
  end;
  Result := p;
end;

function GetAttributeSortType(Attribute: RawUtf8): TLdapAttributeSortType;
begin
  if Attribute=PSEUDOATTR_DN   then result:=AT_DN   else
  if Attribute=PSEUDOATTR_RDN  then result:=AT_RDN  else
  if Attribute=PSEUDOATTR_PATH then result:=AT_Path else
  result:=AT_Attribute;
end;

{ ErrLdap }

constructor ErrLdap.Create(ErrCode, ExtErrCode: ULONG; Msg: RawUtf8);
begin
  inherited Create(Msg);
  FErrorCode := ErrCode;
  FExtErrorCode := ExtErrCode;
end;

{ TLdapSession }

procedure TLDAPSession.LDAPCheck(const err: ULONG; const Critical: Boolean);
var
  ErrorEx: PChar;
  msg: RawUtf8;
  c: ULONG;
begin
  if (err = LDAP_SUCCESS) then exit;

  if ((ldap_get_option(pld, LDAP_OPT_SERVER_ERROR, @ErrorEx)=LDAP_SUCCESS) and Assigned(ErrorEx)) then
    msg := Format(stLdapErrorEx, [RawLdapErrorString(err), ErrorEx])
  else
    msg := Format(stLdapError, [RawLdapErrorString(err)]);
    c := 0;
    // TODO check with OpenLdap
    if (ldap_get_option(pld, LDAP_OPT_SERVER_EXT_ERROR, @c) = LDAP_SUCCESS) then
      msg := msg + #10 + SysErrorMessage(c);
    //

  if Critical then
    raise ErrLDAP.Create(err, c, msg);
  MessageDlg(msg, mtError, [mbOk], 0);
end;

function TLDAPSession.GetPassword: SpiUtf8;
begin
  Result := Settings.Password;
end;

function TLDAPSession.GetPort: RawUtf8;
begin
  Result := Settings.TargetPort;
end;

function TLDAPSession.GetServer: RawUtf8;
begin
  Result := Settings.TargetHost;
end;

function TLDAPSession.GetSettings: TLdapClientSettings;
begin
  Result := ldappld.Settings;
end;

function TLDAPSession.GetTls: Boolean;
begin
  Result := Settings.Tls;
end;

function TLDAPSession.GetUser: RawUtf8;
begin
  Result := Settings.UserName;
end;

procedure TLDAPSession.SetLdapSettings(AValue: TLdapClientSettings);
begin
  if Settings=AValue then Exit;
  Disconnect;
  ldappld.Settings.Assign(AValue);
end;

procedure TLDAPSession.SetPassword(AValue: SpiUtf8);
begin
  if Password = AValue then Exit;
  Disconnect;
  Settings.Password := AValue;
end;

procedure TLDAPSession.ProcessSearchEntry(const plmEntry: TLDAPResult;
  Attributes: TLdapAttributeList);
var
  Attr: TLdapAttribute;
  i,j: Integer;
  pszAttr:RawUtf8;
  attrData: RawByteString;
  pbe: PBerElement;
  ppBer: PPLdapBerVal;
  data: TLDAPAttributeData;
begin
  // loop thru attributes
  for i := 0 to plmEntry.Attributes.Count - 1 do
  begin
        pszAttr := plmEntry.Attributes.Items[i].AttributeName;
        Attr := Attributes.Add(pszAttr);
        Attr.fState := Attr.fState + [asBrowse];
        for j:=0 to plmEntry.Attributes.Items[i].Count-1 do
        begin
          attrData:= plmEntry.Attributes.Items[i].GetRaw(j);
          ///data:=TLdapAttributeData.Create(Attr);
          Attr.AddValue(@attrData[1],length(attrData));
        end;
  end;
end;

procedure TLDAPSession.ProcessSearchMessage(const plmSearch: TLdapClient; const NoValues: LongBool; Result: TLdapEntryList);
var
  plmEntry: TLDAPResult;
  pszdn: RawUtf8;
  Entry: TLdapEntry;
  i,j : integer;
begin
  if plmSearch=nil then
    exit;
  for i:=0 to plmSearch.SearchResult.Count -1 do
  begin
    pszdn:= plmSearch.SearchResult.Items[i].ObjectName;
    Entry := TLdapEntry.Create(Self, pszdn);
    Result.Add(Entry);
    if not NoValues then
    begin
      Entry.fState := [esReading];
      try
        ProcessSearchEntry(plmSearch.SearchResult.Items[i], Entry.Attributes);
        Entry.fState := Entry.fState + [esBrowse];
      finally
        Entry.fState := Entry.fState - [esReading];
      end;
    end;
  end;
end;

procedure TLDAPSession.Search(const Filter, Base: RawUtf8;
  const Scope: TLdapSearchScope; attrs: TRawByteStringDynArray;
  const NoValues: LongBool; Result: TLdapEntryList; SearchProc: TSearchCallback
  );
var
  Err: Integer;
  HSrch: PLDAPSearch;
  TotalCount: Cardinal;
  Timeout: LDAP_TIMEVAL;
  AbortSearch: Boolean;
begin

  if not fPagedSearch then
  begin
    Err := ldap_search_s(pld, Base, Scope, Filter, attrs);
    if Err = LDAP_SIZELIMIT_EXCEEDED then
      MessageDlg(RawLdapErrorString(err), mtWarning, [mbOk], 0)
    else
      LdapCheck(Err);
    ProcessSearchMessage(pld, NoValues, Result);
    Exit;
  end;

  HSrch := ldap_search_init_page(pld, Base, Scope, Filter, attrs, 60, SizeLimit, NoValues);
  if not Assigned(hsrch) then
  begin
    Err := LdapGetLastError;
    if Err <> LDAP_NOT_SUPPORTED then
      LdapCheck(Err); // raises exception
    fPagedSearch := false;
    LDAPCheck(ldap_search_s(pld, Base, Scope, Filter, attrs));
    ProcessSearchMessage(pld, NoValues, Result);
    Exit;
  end;

  Timeout.tv_sec := 60;
  TotalCount := 1;
  while true do
  begin
    Err := ldap_get_next_page_s(pld, HSrch, Timeout.tv_sec * 1000, fPageSize, TotalCount);
    case Err of
      LDAP_UNAVAILABLE_CRIT_EXTENSION, LDAP_UNWILLING_TO_PERFORM:
          begin
            fPagedSearch := false;
            ldap_search_abandon_page(hsrch);
            LDAPCheck(ldap_search_s(pld, Base, Scope, Filter, attrs));
            ProcessSearchMessage(pld, NoValues, Result);
            Break;
          end;
    LDAP_NO_RESULTS_RETURNED, LDAP_SIZELIMIT_EXCEEDED:
        begin
          if Err = LDAP_SIZELIMIT_EXCEEDED then
          begin
            ProcessSearchMessage(pld, NoValues, Result);
            MessageDlg(RawLdapErrorString(err), mtWarning, [mbOk], 0)
          end;
          LdapCheck(ldap_search_abandon_page(hsrch));
          break;
        end;
    LDAP_SUCCESS:
        begin
          ProcessSearchMessage(pld, NoValues, Result);
          if Assigned(SearchProc) then
          begin
            AbortSearch := false;
            SearchProc(Result, AbortSearch);
            if AbortSearch then
            begin
              LdapCheck(ldap_search_abandon_page(hsrch));
              break;
            end;
          end;
        end
    else
      LdapCheck(Err);
    end;
  end;
end;


procedure TLDAPSession.Search(const Filter, Base: RawUtf8;
  const Scope: TLdapSearchScope; QueryAttrs: array of RawUtf8;
  const NoValues: LongBool; Result: TLdapEntryList; SearchProc: TSearchCallback
  );
var
  RawArray: TRawByteStringDynArray;
  i: Integer;
begin
  RawArray := nil;
  SetLength(RawArray, Length(QueryAttrs));
  for i := 0 to Length(QueryAttrs) - 1 do
    RawArray[i] := QueryAttrs[i];
  Search(Filter, Base, Scope, RawArray, NoValues, Result, SearchProc);
end;

{ Modify set of attributes in every entry set returned by search filter }
procedure TLDAPSession.ModifySet(const Filter, Base: RawUtf8;
  const Scope: TLdapSearchScope; argNames: array of RawUtf8; argVals: array of RawUtf8;
  argNewVals: array of RawUtf8; const ModOp: Cardinal);
var
  List: TLdapEntryList;
  Entry: TLDapEntry;
  h, i: Integer;
begin
  List := TLdapEntryList.Create;
  try
    Search(Filter, Base, Scope, argNames, false, List);
    for i := 0 to List.Count - 1 do
    begin
      Entry := TLdapEntry(List[i]);
      for h := 0 to High(argNames) do with Entry.AttributesByName[argNames[h]] do
      begin
        case ModOp of
          LdapOpDelete:  DeleteValue(argVals[h]);
          LdapOpAdd:     AddValue(argNewVals[h]);
          LdapOpReplace: if IndexOf(argVals[h]) <> -1 then
                         begin
                           DeleteValue(argVals[h]);
                           AddValue(argNewVals[h]);
                         end;
          end;
        Entry.Write;
      end;
    end;
  finally
    List.Free;
  end;
end;

procedure TLDAPSession.WriteEntry(Entry: TLdapEntry);
var
  i,j          : integer;
  AttributeList: TLdapAttributeList;
  Attributes   : mormot.net.ldap.TLdapAttributeList;
  data         : mormot.net.ldap.TLDAPAttribute;


procedure MakeAttrib(AValue: TLdapAttributeData);
begin
  data := Attributes.Find(AValue.fAttribute.Name);
  if data <> nil then
  begin
    data.add(AValue.AsString)
  end
  else
  begin
    data:=Attributes.Add(AValue.fAttribute.Name);
    if not(asDeleted in AttributeList[i].State) then
       data.add(AValue.AsString);
  end;
end;

procedure ValueModOp(AValue: TLdapAttributeData; ModOP: TLDAPModifyOp);
begin
  AValue.ModOp:=0;
  Attributes.Clear;
  MakeAttrib(Avalue);
  if not(esNew in Entry.State) and not pld.Modify(Entry.dn, ModOP, Attributes.Items[0]) then
    LdapCheck(pld.ResultCode);
end;


begin
  Attributes:=mormot.net.ldap.TLDAPAttributeList.Create;
  AttributeList := Entry.Attributes;
  try
    for i := 0 to AttributeList.Count - 1 do
    begin
      {
      if asDeleted in AttributeList[i].State then
      begin
        data:=Attributes.Add;
        data.AttributeName:=AttributeList[i].Name;
        LdapCheck(ldap_modify_s(pld, PChar(Entry.dn), MO_Delete, Attributes[0]))
      end
      else
      }
      if (asModified in AttributeList[i].State) or (asNew in AttributeList[i].State) or
         (asDeleted in AttributeList[i].State) then
      begin
        for j := 0 to AttributeList[i].ValueCount - 1 do
          case AttributeList[i][j].ModOp of
            LDAP_MOD_ADD:     ValueModOp(AttributeList[i][j], lmoAdd);
            LDAP_MOD_DELETE:  ValueModOp(AttributeList[i][j], lmoDelete);
            LDAP_MOD_REPLACE: ValueModOp(AttributeList[i][j],lmoReplace);
          end;
      end;
    end;
    if (esNew in Entry.State) and not pld.Add(Entry.dn, Attributes) then
      LdapCheck(pld.ResultCode);
  finally
  Attributes.Free;
  end;

end;


procedure TLDAPSession.ReadEntry(Entry: TLdapEntry);
  procedure DoRead(attrs: TRawByteStringDynArray; AttributeList: TLdapAttributeList);
  begin
    LDAPCheck(ldap_search_s(pld, Entry.dn, lssBaseObject, sANYCLASS, attrs));
    ProcessSearchEntry(pld.SearchResult.Items[0], AttributeList);
  end;
begin
  DoRead(nil, Entry.Attributes);
  if Assigned(fOperationalAttrs) then
    DoRead(fOperationalAttrs, Entry.OperationalAttributes);
end;

procedure TLDAPSession.ReadEntry(Entry: TLdapEntry; Attributes: TRawByteStringDynArray);
begin
    LDAPCheck(ldap_search_s(pld, entry.dn, lssBaseObject, sANYCLASS, Attributes));
    ProcessSearchEntry(pld.SearchResult.Items[0], Entry.Attributes);
  end;

procedure TLDAPSession.DeleteEntry(const adn: RawUtf8);
begin
  if not pld.Delete(adn) then
    LDAPCheck(pld.ResultCode);
end;

function TLDAPSession.RenameEntry(const OldDn, NewRdn, NewParent: RawUtf8;
  FailOnError: Boolean): Cardinal;
var
  rdn: RawUtf8;
begin

  if Version < LDAP_VERSION3 then
  begin
    Result := LDAP_PROTOCOL_ERROR;
    exit;
  end;

  if NewRdn = '' then
    rdn := GetRdnFromDn(OldDn)
  else
    rdn := NewRdn;

  pld.ModifyDN(OldDn, rdn, NewParent, True);
  Result := pld.ResultCode;

  if FailOnError then
    LdapCheck(Result);
end;

function TLDAPSession.Lookup(sBase, sFilter, sResult: RawUtf8; Scope: TLdapSearchScope): RawUtf8;
var
  plmEntry:  TLDAPResult;
  ppcVals: PPCHAR;
begin
    Result := '';
    // perform search

    LDAPCheck(ldap_search_s(pld, sBase, Scope, sFilter, [sResult]));
    plmEntry := ldap_first_entry(pld);
    if Assigned(plmEntry) then
    begin
      ppcVals := ldap_get_values(pld, plmEntry, sResult);
      if Assigned(ppcVals) then
        Result := pchararray(ppcVals)[0];
    end;
end;

function TLDAPSession.GetDn(sFilter: RawUtf8): RawUtf8;
var
  plmEntry: TLDAPResult;
begin
    Result := '';
    // perform search
    LDAPCheck(ldap_search_s(pld, ldapBase, lssWholeSubtree, sFilter, ['objectclass']));
    plmEntry := ldap_first_entry(pld);
    if Assigned(plmEntry) then
      Result := plmEntry.ObjectName;
end;

procedure TLDAPSession.SetServer(AValue: RawUtf8);
begin
  if Server = AValue then Exit;
  Disconnect;
  Settings.TargetHost := AValue;
end;

procedure TLDAPSession.SetUser(AValue: RawUtf8);
begin
  if User = AValue then Exit;
  Disconnect;
  Settings.UserName := AValue;
end;

procedure TLDAPSession.SetPort(AValue: RawUtf8);
begin
  if Port = AValue then Exit;
  Disconnect;
  settings.TargetPort := AValue;
end;

procedure TLDAPSession.SetTLS(Value: Boolean);
begin
  if TLS = Value then Exit;
  Disconnect;
  settings.Tls := Value;
end;

procedure TLDAPSession.SetVersion(Version: Integer);
begin
  Disconnect;
  ldapVersion := Version;
end;

procedure TLDAPSession.SetSSL(Value: Boolean);
begin
  Disconnect;
  ldapSSL := Value;
end;

procedure TLDAPSession.SetLdapAuthMethod(Method: TLdapAuthMethod);
begin
  Disconnect;
  ldapAuthMethod := Method;
end;

procedure TLDAPSession.SetTimeLimit(const Value: Integer);
begin
  if Value <> fTimeLimit then
  begin
    fTimeLimit := Value;
    if Connected then
      LdapCheck(ldap_set_option(ldappld, LDAP_OPT_TIMELIMIT,@Value), false);
  end;
end;

procedure TLDAPSession.SetSizeLimit(const Value: Integer);
begin
  if Value <> fSizeLimit then
  begin
    fSizeLimit := Value;
    if Connected then
      LdapCheck(ldap_set_option(ldappld, LDAP_OPT_SIZELIMIT,@Value), false);
  end;
end;

procedure TLDAPSession.SetDerefAliases(const Value: Integer);
begin
  if Value <> fDerefAliases then
  begin
    fDerefAliases := Value;
    if Connected then
      LdapCheck(ldap_set_option(ldappld, LDAP_OPT_DEREF,@Value), false);
  end;
end;

procedure TLDAPSession.SetChaseReferrals(const Value: boolean);
var
  v: Pointer;
begin
  if Value <> fChaseReferrals then
  begin
    fChaseReferrals := Value;
    if Connected then
    begin
      if Value then
        v := LDAP_OPT_ON
      else
        v := LDAP_OPT_OFF;
      LdapCheck(ldap_set_option(ldappld, LDAP_OPT_SIZELIMIT, @v), false);
    end;
  end;
end;

procedure TLDAPSession.SetReferralHops(const Value: Integer);
begin
  if Value <> fReferralHops then
  begin
    fReferralHops := Value;
    if Connected then
      LdapCheck(ldap_set_option(ldappld, LDAP_OPT_REFERRAL_HOP_LIMIT,@Value), false);
  end;
end;

function TLDAPSession.GetOperationalAttrs: RawUtf8;
var
  i: Integer;
begin
  if Assigned(fOperationalAttrs) then
  begin
     Result := fOperationalAttrs[Low(fOperationalAttrs)];
     for i := Low(fOperationalAttrs) to High(fOperationalAttrs) do
       Result := Result + ',' +  fOperationalAttrs[i];
  end
  else
    Result := '';
end;

procedure TLDAPSession.SetOperationalAttrs(const Value: RawUtf8);
var
  fStringList: TStringList;
  i: Integer;
begin
  if Value <> '' then
  begin
    fStringList := TStringList.Create;
    with fStringList do
    try
      CommaText := Value;
      SetLength(fOperationalAttrs, Count);
      for i := 0 to Count - 1 do
        fOperationalAttrs[i] := fStringList[i];
    finally
      Free;
    end;
  end
  else
    fOperationalAttrs := nil;
end;

procedure TLDAPSession.SetConnect(DoConnect: Boolean);
begin
  if not Connected then
    Connect;
end;

function TLDAPSession.ISConnected: Boolean;
begin
  Result := Assigned(pld);
end;

constructor TLDAPSession.Create;
begin
  inherited Create;
  ldappld:= TLdapClient.Create;
  ldapAuthMethod := AUTH_SIMPLE;
  ldapVersion := LDAP_VERSION3;
  ldapSSL := false;
  fTimeLimit := SESS_TIMEOUT;
  fSizeLimit := SESS_SIZE_LIMIT;
  fPagedSearch := true;
  fPageSize := SESS_PAGE_SIZE;
  fDerefAliases := LDAP_DEREF_NEVER;
  fChaseReferrals := true;
  fReferralHops := SESS_REFF_HOP_LIMIT;
  fOnConnect := TNotifyEvents.Create;
  fOnDisconnect := TNotifyEvents.Create;
end;

destructor TLDAPSession.Destroy;
begin
  try
    Disconnect;
  except
    on E: exception do MessageDlg(E.Message, mtError, [mbOk], 0);
  end;
  ldappld.free;
  fOnConnect.Free;
  fOnDisconnect.Free;
  OperationalAttrs := ''; // dispose RawUtf8 array
  inherited;
end;

procedure TLDAPSession.Connect;
var
  res: Cardinal;
  v: Pointer;
  tempPassword: SpiUtf8;
begin
  if (User<>'') and (Password='') then
  begin
    tempPassword := '';
    if not InputDlg(cEnterPasswd, Format(stPassFor, [User]), tempPassword, '*', true) then
      Abort
    else
      Password := tempPassword;
  end;
  if ldapSSL then
    TLS := True;
  ldappld.Connect;
  if Assigned(pld) then
  try
    LdapCheck(ldap_set_option(ldappld,LDAP_OPT_PROTOCOL_VERSION,@ldapVersion));
    if ldapSSL or TLS then
    begin
      ///res := ldap_set_option(pld, LDAP_OPT_SERVER_CERTIFICATE, @VerifyCert);
      if (res <> LDAP_SUCCESS) and (res <> LDAP_LOCAL_ERROR) then
        LdapCheck(res);
      CertServerName := PChar(Server);
    end;
    //CertUserAbort := false;
    //if TLS then
    //begin
    //  res := ldap_start_tls_s(ldappld, nil, nil, nil, nil);
    //  if CertUserAbort then
    //    Abort;
    //  LdapCheck(res);
    //end;
    case ldapAuthMethod of
      AUTH_SIMPLE:
          begin
            ldappld.Bind;
            res := ldappld.ResultCode;
          end;
      AUTH_GSS,
      AUTH_GSS_SASL:
          begin
            if ldapAuthMethod = AUTH_GSS_SASL then
              LdapCheck(ldap_set_option(ldappld,LDAP_OPT_ENCRYPT, LDAP_OPT_ON));
            DnsLdapControlers(Server, false, @Settings.KerberosDN);
            ldappld.BindSaslKerberos;
            res:=ldappld.ResultCode;
         end;
    else
      raise Exception.CreateFmt(stUnsupportedAuth, [IntToStr(ldapAuthMethod)]);
    end;

    if CertUserAbort then
      Abort;
    LdapCheck(res);
    if ldapVersion < 3 then
      fPagedSearch := false;
    // set options
    if fTimeLimit <> SESS_TIMEOUT then
      LdapCheck(ldap_set_option(ldappld,LDAP_OPT_TIMELIMIT,@fTimeLimit), false);
    if fSizeLimit <> SESS_SIZE_LIMIT then
      LdapCheck(ldap_set_option(ldappld,LDAP_OPT_SIZELIMIT,@fSizeLimit), false);
    if fDerefAliases <> LDAP_DEREF_NEVER then
      LdapCheck(ldap_set_option(ldappld, LDAP_OPT_DEREF,@fDerefAliases), false);
    if not fChaseReferrals then
    begin
      v := LDAP_OPT_OFF;
      LdapCheck(ldap_set_option(ldappld, LDAP_OPT_SIZELIMIT, @v), false);
    end;
    if fReferralHops <> SESS_REFF_HOP_LIMIT then
      LdapCheck(ldap_set_option(ldappld, LDAP_OPT_REFERRAL_HOP_LIMIT,@fReferralHops), false);
  except
    if not pld.Close then
      LdapCheck(LDAP_OPERATIONS_ERROR, false);
    raise;
  end;
  fOnConnect.Execute(self);
end;

procedure TLDAPSession.Disconnect;
begin
  if Connected then
  begin
    fOnDisconnect.Execute(self);
    ldappld.Close;
  end;
end;

{ TLDapAttributeData }

function TLdapAttributeData.GetType: TDataType;
var
  w: Word;

  function LengthAsStr(P: Pointer; Length: Integer): Cardinal;
  var
    c: Integer;
  begin
    c := Length;
    while (c > 0) do
    begin
      ///if PByte(P)^ = 0 then
      ///  break;
      dec(c);
      inc(PByte(P));
    end;
    Result := Length - c;
  end;


  function IsText2(p:  PAnsiChar; size:integer): boolean;
  const
    SafeChar:     set of AnsiChar = [#$00..#09, #$0B..#$0C, #$0E..#$1f];
  var
    EndBuf: PAnsiChar;
  begin
    Result := true;
    EndBuf := p + Size;
    while (p <> EndBuf) do
    begin
      if (p^ in SafeChar) then
      begin
        Result := false;
        break;
      end;
      Inc(p);
    end;
  end;

  function IsText(p:  PAnsiChar; size:integer): boolean;
  begin
    if not IsText2(p,size) then
      result:=false
    else
      result := FindInvalidUTF8Character(p, size,true) = -1;
  end;

begin
  if (Attribute.fDataType = dtUnknown) and (DataSize > 0) then
  begin
    if (LengthAsStr(Data, DataSize) >= DataSize) then
       if IsText(PChar(Data),DataSize) then
         Attribute.fDataType := dtText
    else
    begin
      w := PWord(Data)^;
      if w = $8230 then   // DER Sequence '30 82'
        Attribute.fDataType := dtCert
      else
      if w = $D8FF then // Exif header 'FF D8'
        Attribute.fDataType := dtJpeg
      else
        Attribute.fDataType := dtBinary;
    end;
  end;
  Result := Attribute.fDataType;
end;

function TLdapAttributeData.GetString: RawUtf8;
var
  tempBuffer: RawUtf8;
begin
  FastSetString(tempBuffer, Data, DataSize);
  AttributeValueMakeReadable(tempBuffer, AttributeNameType(Attribute.Name));
  Result := tempBuffer;
end;

procedure TLdapAttributeData.SetString(AValue: RawUtf8);
var
  s: AnsiString;
begin
  if fUtf8 then
    s := StringToUtf8Len(PChar(AValue), Length(AValue))
  else
    s := AVAlue;
  SetData(PChar(s), Length(s));
end;

procedure TLdapAttributeData.LoadFromStream(Stream: TStream);
var
  p: Pointer;
begin
  with Stream do
  begin
    GetMem(P, Size);
    try
      ReadBuffer(P^, Size);
      SetData(P, Size);
    finally
      FreeMem(P);
    end;
  end;
end;

procedure TLdapAttributeData.SaveToStream(Stream: TStream);
begin
  if Assigned(Self) and (ModOp <> LdapOpNoop) and (ModOp <> LdapOpDelete) then
    ///Stream.WriteBuffer(Berval.bv_val^, fBerval.Bv_Len);
    Stream.WriteBuffer(Pointer(fBerval.Bv_Val)^, fBerval.Bv_Len);
end;

function TLdapAttributeData.BervalAddr: PLdapBerval;
begin
  Result := Addr(fBerval);
end;

constructor TLdapAttributeData.Create(Attribute: TLdapAttribute);
begin
  fAttribute := Attribute;
  fEntry := Attribute.fEntry;
  //fType := dtUnknown;
  {$ifdef mswindows}
  if not (Assigned(fEntry) and Assigned(fEntry.Session) and (fEntry.Session.Version < LDAP_VERSION3)) then
    fUtf8 := true;
  {$else}
  // for linux is utf8 default, no need conversion to ansi
  fUTF8:=false;
  {$endif}
  inherited Create;
end;

//{$IFDEF CPUX64}
function TLdapAttributeData.CompareData(P: Pointer; Length: Integer): Boolean;
begin
  Result := (DataSize = Length) and CompareMem(P, Data, Length);
end;
//{$ELSE}
//function TLDapAttributeData.CompareData(P: Pointer; Length: Integer): Boolean; assembler;
//asm
//        PUSH    ESI
//        MOV     ESI,P
//        MOV     EDX,EAX
//        XOR     EAX,EAX
//        CMP     ECX,[edx + fBerval.Bv_Len]
//        JNE     @@3
//        PUSH    EDI
//        MOV     EDI,[edx + fBerval.Bv_Val]
//        CMP     ESI,EDI
//        JE      @@1
//        REPE    CMPSB
//        JNE     @@2
//@@1:    INC     EAX
//@@2:    POP     EDI
//@@3:    POP     ESI
//end;
//{$ENDIF}

procedure TLdapAttributeData.SetData(AData: Pointer; ADataSize: Cardinal);
var
  i: Integer;
begin
  if ADataSize = 0 then
    Delete
  else
  begin
    fAttribute.fState := fAttribute.fState - [asDeleted];
    if not CompareData(AData, ADataSize) then
    begin
      //fType := dtUnknown;
      fBerval.Bv_Len := ADataSize;
      SetLength(fBerval.Bv_Val, ADataSize);
      Move(AData^, Pointer(fBerval.Bv_Val)^, ADataSize);
      if esReading in fEntry.State then
        fModOp := LdapOpRead
      else
      begin
        if ModOp = LdapOpNoop then
          fModOp := LDAP_MOD_ADD
        else
        if ModOp <> LDAP_MOD_ADD then
        begin
          for i := 0 to fAttribute.ValueCount - 1 do
            fAttribute.Values[i].fModOp := LDAP_MOD_REPLACE;
        end;
        fEntry.fState := fEntry.fState + [esModified];
        fAttribute.fState := fAttribute.fState + [asModified];
      end;
    end
    else begin
      if ModOp = LdapOpNoop then
        fModOp := LDAP_MOD_ADD
      else
      if ModOp = LDAP_MOD_DELETE then
        fModOp := LdapOpRead;
    end;
  end;
  if Assigned(fEntry.OnChange) then fEntry.OnChange(Self);
end;

procedure TLdapAttributeData.Delete;
var
  i: Integer;
begin
  if (fModOp = LdapOpNoop) then Exit;
  if fModOp = LDAP_MOD_ADD then
    fModOp := LdapOpNoop
  else
  begin
    if (fModOp = LdapOpReplace) and (fAttribute.fValues.Count > 1) then
    begin
      fModOp := LdapOpRead;
      with fAttribute do
      begin
        i := fValues.Count - 1;
        while i >= 0 do with Values[i] do
        begin
          if ModOp = LdapOpReplace then
            Exit;
          dec(i);
        end;
      end;
    end;

    fModOp := LDAP_MOD_DELETE;
    fAttribute.fState := fAttribute.fState + [asModified];
    fEntry.fState := fEntry.fState + [esModified];
    { Added to handle attributes with no equality matching rule.
    { Check if all single values are deleted, if so delete attribute as whole. }
    with fAttribute do
    begin
      i := fValues.Count - 1;
      while i >= 0 do with Values[i] do
      begin
        if (ModOp <> LdapOpDelete) and (ModOp <> LdapOpNoop) then
          break;
        dec(i);
      end;
      if i = -1 then
        fAttribute.fState := fAttribute.fState + [asDeleted];
    end;
    { end change }
  end;
  if Assigned(fEntry.OnChange) then fEntry.OnChange(Self);
end;

{ TLdapAttribute }

function TLdapAttribute.GetCount: Integer;
begin
  Result := fValues.Count;
end;

function TLdapAttribute.GetValue(Index: Integer): TLdapAttributeData;
begin
  if fValues.Count > 0 then
    Result := fValues[Index]
  else
    Result := nil;
end;

function TLdapAttribute.AddValue: TLdapAttributeData;
begin
  Result := TLdapAttributeData.Create(Self);
  fValues.Add(Result);
end;

procedure TLdapAttribute.AddValue(const AValue: RawUtf8);
var
  idx: Integer;
  Value: TLdapAttributeData;
begin
  idx := IndexOf(AValue);
  if idx = -1 then
  begin
    Value := TLdapAttributeData.Create(Self);
    fValues.Add(Value);
  end
  else
    Value := TLdapAttributeData(fValues[idx]);
  Value.AsString := AValue;
end;

procedure TLdapAttribute.AddValue(const AData: Pointer; const ADataSize: Cardinal);
var
  idx: Integer;
  Value: TLdapAttributeData;
begin
  idx := IndexOf(AData, ADataSize);
  if idx = -1 then
  begin
    Value := TLdapAttributeData.Create(Self);
    fValues.Add(Value);
  end
  else
    Value := TLdapAttributeData(fValues[idx]);
  Value.SetData(AData, ADataSize);
end;


function TLdapAttribute.GetString: RawUtf8;
begin
  if fValues.Count > 0 then
    Result := TLdapAttributeData(fValues[0]).AsString
  else
    Result := '';
end;

procedure TLdapAttribute.SetString(AValue: RawUtf8);
begin
  // Setting RawUtf8 value(s) to '' means deleting of the attribute
  if AValue = '' then
    Delete
  else
  if fValues.Count = 0 then
    AddValue(AValue)
  else
    TLdapAttributeData(fValues[0]).AsString := PChar(AValue);
end;

function TLdapAttribute.GetDataType: TDataType;
var
  i: Integer;
begin
  if fDataType = dtUnknown then
    for i := 0 to fValues.Count - 1 do
      if TLDapAttributeData(fValues[i]).DataType <> dtUnknown then
        break;
  Result := fDataType;
end;

function TLdapAttribute.GetEmpty: Boolean;
var
  i: Integer;
begin
  Result := false;
  for i := 0 to ValueCount - 1 do
    with Values[i] do
    if (ModOp <> LdapOpNoop) and (ModOp <> LdapOpDelete) and (DataSize <> 0) then
    begin
      Result := true;
      break;
    end;
  Result := not Result;
end;

constructor TLdapAttribute.Create(const AName: RawUtf8; OwnerList: TLdapAttributeList);
begin
  fName := AName;
  fOwnerList := OwnerList;
  fEntry := OwnerList.fEntry;
  fValues := TList.Create;
  fDataType := dtUnknown;
end;

destructor TLdapAttribute.Destroy;
var
  i: Integer;
begin
  for i := 0 to fValues.Count - 1 do
    TLDapAttributeData(fValues[i]).Free;
  fValues.Free;
end;

procedure TLdapAttribute.DeleteValue(const AValue: RawUtf8);
var
  idx: Integer;
begin
  idx := IndexOf(AValue);
  if idx > -1 then
    TLdapAttributeData(fValues[idx]).Delete;
end;

procedure TLdapAttribute.Delete;
var
  i: Integer;
begin
  if asBrowse in State then
  begin
    fState := fState + [asDeleted];
    fEntry.fState := fEntry.fState + [esModified];
  end;
  for i := 0 to fValues.Count - 1 do
    TLdapAttributeData(fValues[i]).Delete;
end;

function TLdapAttribute.IndexOf(const AValue: RawUtf8): Integer;
begin
  Result := fValues.Count - 1;
  while Result >= 0 do begin
    if AnsiCompareText(AValue, TLdapAttributeData(fValues[Result]).AsString) = 0 then
      break;
    dec(Result);
  end;
end;

function TLdapAttribute.IndexOf(const AData: Pointer; const ADataSize: Cardinal): Integer;
begin
  Result := fValues.Count - 1;
  while Result >= 0 do begin
    if TLdapAttributeData(fValues[Result]).CompareData(AData, ADataSize) then
      break;
    dec(Result);
  end;
end;

procedure TLdapAttribute.MoveIndex(Index: Integer);
var
  i: Integer;
begin
  with fEntry.fAttributes.fList do begin
    i := IndexOf(Self);
    if i <> -1 then
      Move(i, Index);
  end;
end;

{ TLdapAttributeList }

function TLdapAttributeList.GetCount: Integer;
begin
  Result := fList.Count;
end;

function TLdapAttributeList.GetNode(Index: Integer): TLdapAttribute;
begin
  Result := TLdapAttribute(fList[Index]);
end;

constructor TLdapAttributeList.Create(Entry: TLdapEntry);
begin
  fEntry := Entry;
  fList := TList.Create;
end;

destructor TLdapAttributeList.Destroy;
var
  i: Integer;
begin
  for i := 0 to fList.Count - 1 do
    TLdapAttribute(fList[i]).Free;
  fList.Free;
  inherited Destroy;
end;

function TLdapAttributeList.Add(const AName: RawUtf8): TLdapAttribute;
begin
  Result := TLdapAttribute.Create(AName, Self);
  fList.Add(Result);
end;

{function TLdapAttributeList.Insert(const AName: RawUtf8; Index: Integer): TLdapAttribute;
begin
  Result := TLdapAttribute.Create(AName, Self);
  fList.Insert(Index, Result);
end;}

function TLdapAttributeList.IndexOf(const Name: RawUtf8): Integer;
begin
  Result := fList.Count - 1;
  while Result >= 0 do
  begin
    if AnsiCompareText(Name, Items[Result].Name) = 0 then
      break;
    dec(Result);
  end;
end;

function TLdapAttributeList.AttributeOf(const Name: RawUtf8): TLdapAttribute;
var
  idx: Integer;
begin
  Result := nil;
  for idx := 0 to fList.Count - 1 do
    if AnsiCompareText(Name, Items[idx].Name) = 0 then
    begin
      Result := Items[idx];
      break;
    end;
end;

procedure TLdapAttributeList.Clear;
var
  i: Integer;
begin
  for i := 0 to fList.Count - 1 do
    TLdapAttribute(fList[i]).Free;
  fList.Clear;
end;

procedure TLdapAttributeList.Delete(Index: Integer);
begin
  fList.Delete(Index);
end;

{ TLdapEntry }

procedure TLDAPEntry.SetDn(const adn: RawUtf8);
var
  attrib, value: RawUtf8;
  i, j: Integer;
begin
  if adn = fdn then
    exit;
  if esBrowse in State then
  begin
    if GetRdnFromDn(adn) <> GetRdnFromDn(fdn) then
    begin
      SplitRDN(adn, attrib, value);
      with AttributesByName[attrib] do
        if AsString <> '' then
          AsString := DecodeLdapString(value);
    end;
    // Reset all flags
    i := Attributes.Count - 1;
    while i >= 0 do with Attributes[i] do
    begin
      fState := [asNew, asModified];
      j := ValueCount - 1;
      while j >= 0 do with Values[j] do
      begin
        if ModOp = LdapOpDelete then
        begin
          Free;
          fValues.Delete(j);
        end
        else
        if ModOp <> LdapOpNoop then
          fModOp := LdapOpAdd;
        dec(j);
      end;
      dec(i);
    end;
    fState := [esNew];
    if Attributes.Count > 0 then
      fState := fState + [esModified];
  end;
  fdn := adn;
end;

procedure TLDAPEntry.SetUtf8Dn(const adn: RawUtf8);
begin
  SetDn(UTF8Decode(adn));
end;

function  TLDAPEntry.GetUtf8Dn: RawUtf8;
begin
  Result := UTF8Encode(dn);
end;

constructor TLDAPEntry.Create(const ASession: TLDAPSession; const adn: RawUtf8);
begin
  inherited Create;
  fdn := adn;
  fSession := ASession;
  fState := [esNew];
  fAttributes := TLdapAttributeList.Create(Self);
  fOperationalAttributes := TLdapAttributeList.Create(Self);
end;

destructor TLDAPEntry.Destroy;
begin
  fAttributes.Free;
  fOperationalAttributes.Free;
  inherited;
end;

procedure TLDAPEntry.Read;
begin
  fAttributes.Clear;
  fObjectClass := nil;
  fOperationalAttributes.Clear;
  fState := [esReading];
  try
    fSession.ReadEntry(Self);
    fState := fState + [esBrowse];
  finally
    fState := fState - [esReading];
  end;
  if Assigned(fOnRead) then fOnRead(Self);
end;

procedure TLDAPEntry.Read(Attributes: TRawByteStringDynArray);
begin
  fAttributes.Clear;
  fObjectClass := nil;
  fOperationalAttributes.Clear;
  fState := [esReading];
  try
    fSession.ReadEntry(Self, Attributes);
    fState := fState + [esBrowse];
  finally
    fState := fState - [esReading];
  end;
  if Assigned(fOnRead) then fOnRead(Self);
end;

procedure TLDAPEntry.Write;
var
  i, j: Integer;
begin
  if esModified in fState then
  begin
    if Assigned(fOnWrite) then fOnWrite(Self);
    Session.WriteEntry(Self);
    { added 05.07.2007 - reset all flags to read state}
    fState := fState - [esModified];
    for i := 0 to Attributes.Count - 1 do with Attributes[i] do
    begin
      fState := fState - [asModified];
      for j := 0 to ValueCount - 1 do
        Values[j].fModOp := LdapOpRead;
    end;
  end;
end;

procedure TLDAPEntry.Delete;
begin
  Session.DeleteEntry(dn);
  fState := fState + [esDeleted];
end;

procedure TLDAPEntry.Clone(ToEntry: TLdapEntry);

  procedure CopyAttrList(FromList, ToList: TLdapAttributeList);
  var
    i, j: Integer;
    attr: TLdapAttribute;
    val: TLdapAttributeData;
  begin
    for i := 0 to FromList.Count - 1 do with FromList[i] do
    begin
      attr := ToList.Add(fName);
      attr.fState := fState;
      attr.fDataType := fDataType;
      for j := 0 to ValueCount - 1 do with Values[j] do
      if DataSize > 0 then
      begin
        val := ToList[i].AddValue;
        val.SetData(Data, DataSize);
        val.fModOp := fModOp;
        val.fUtf8 := fUtf8;
      end;
    end;
  end;

begin
  CopyAttrList(fAttributes, ToEntry.fAttributes);
  CopyAttrList(fOperationalAttributes, ToEntry.fOperationalAttributes);
end;

function TLDAPEntry.GetNamedAttribute(const AName: RawUtf8): TLdapAttribute;
var
  i: Integer;
begin
  i := fAttributes.IndexOf(AName);
  if i < 0 then
    Result := fAttributes.Add(AName)
  else
    Result := fAttributes[i];
end;

function TLDAPEntry.GetObjectClass: TLdapAttribute;
begin
  if not Assigned(FObjectClass) then
    FObjectClass := GetNamedAttribute('objectclass');
  Result := FObjectClass;
end;

{ TLdapEntryList }

function TLdapEntryList.GetCount: Integer;
begin
  Result := fList.Count;
end;

function TLdapEntryList.GetNode(Index: Integer): TLdapEntry;
begin
  Result := TLdapEntry(fList[Index]);
end;

constructor TLdapEntryList.Create(AOwnsObjects: Boolean = true);
begin
  fList := TList.Create;
  fOwnsEntries := AOwnsObjects;
end;

destructor TLdapEntryList.Destroy;
var
  i: Integer;
begin
  if fOwnsEntries then
    for i := 0 to fList.Count - 1 do
      TLdapEntry(fList[i]).Free;
  fList.Free;
  inherited Destroy;
end;

procedure TLdapEntryList.Add(Entry: TLdapEntry);
begin
  fList.Add(Entry);
end;

procedure TLdapEntryList.Delete(Index: Integer);
begin
  TObject(fList[Index]).Free;
  fList.Delete(Index)
end;

procedure TLdapEntryList.Extract(Index: Integer);
begin
  fList.Delete(Index)
end;

procedure TLdapEntryList.Clear;
var
  i: Integer;
begin
  if fOwnsEntries then
    for i := 0 to fList.Count - 1 do
      TLdapEntry(fList[i]).Free;
  fList.Clear;
end;

function TLdapEntryList.IndexOf(adn: RawUtf8): Integer;
begin
  Result := fList.Count - 1;
  while Result >= 0 do
  begin
    if AnsiCompareText(adn, Items[Result].dn) = 0 then
      break;
    dec(Result);
  end;
end;

procedure TLdapEntryList.Sort(const Attributes: array of RawUtf8; const Asc: boolean);
var
  AttrTypes: array of TLdapAttributeSortType;
  i: integer;

  function  DoCompare(Entry1, Entry2: TLdapEntry): Integer;
  var
    i: integer;
  begin
    result := 0;
    for i:=0 to length(AttrTypes)-1 do begin
      case AttrTypes[i] of
        AT_DN:   result:=AnsiCompareStr(Entry1.DN, Entry2.DN);
        AT_RDN:  result:=AnsiCompareStr(GetRdnFromDn(Entry1.DN), GetRdnFromDn(Entry2.DN));
        AT_PATH: result:=AnsiCompareStr(CanonicalName(GetDirFromDn(Entry1.DN)),
                                        CanonicalName(GetDirFromDn(Entry2.DN)));
        else     result:=AnsiCompareStr(Entry1.AttributesByName[Attributes[i]].AsString,
                                         Entry2.AttributesByName[Attributes[i]].AsString)
      end;
      if result<>0 then break;
    end;

    if result=0 then result:=integer(Entry1)-integer(Entry2); // Delete QuickSort instability.
    if not Asc then result:=-result;
  end;

  procedure DoSort(L, R: Integer);
  var
    I, J: Integer;
    E: TLdapEntry;
    T: Pointer;
  begin
    repeat
      I := L;
      J := R;
      E := TLdapEntry(fList[(L + R) shr 1]);
      repeat
        while DoCompare(TLdapEntry(fList[I]), E) < 0 do Inc(I);
        while DoCompare(TLdapEntry(fList[J]), E) > 0 do Dec(J);
        if I <= J then
        begin
          T := fList[I];
          fList[I] := fList[J];
          fList[J] := T;
          Inc(I);
          Dec(J);
        end;
      until I > J;
      if L < J then
        DoSort(L, J);
      L := I;
    until I >= R;
  end;

begin
  if (length(Attributes)=0) or (fList.Count = 0) then exit;
  setlength(AttrTypes, length(Attributes));
  for i:=0 to length(Attributes)-1 do AttrTypes[i]:=GetAttributeSortType(Attributes[i]);

  DoSort(0, fList.Count-1);
end;

procedure TLdapEntryList.Sort(const Compare: TCompareLdapEntry; const Asc: boolean; const Data: pointer=nil);

  function  DoCompare(Entry1, Entry2: TLdapEntry): Integer;
  begin
    Compare(Entry1, Entry2, Data, result);
    if result=0 then result:=integer(Entry1)-integer(Entry2); // Delete QuickSort instability.
    if not Asc then result:=-result;
  end;

  procedure DoSort(L, R: Integer);
  var
    I, J: Integer;
    E: TLdapEntry;
    T: Pointer;
  begin
    repeat
      I := L;
      J := R;
      E := TLdapEntry(fList[(L + R) shr 1]);
      repeat
        while DoCompare(TLdapEntry(fList[I]), E) < 0 do Inc(I);
        while DoCompare(TLdapEntry(fList[J]), E) > 0 do Dec(J);
        if I <= J then
        begin
          T := fList[I];
          fList[I] := fList[J];
          fList[J] := T;
          Inc(I);
          Dec(J);
        end;
      until I > J;
      if L < J then
        DoSort(L, J);
      L := I;
    until I >= R;
  end;

begin
  if fList.Count = 0 then exit;
  DoSort(0, fList.Count-1);
end;

end.
