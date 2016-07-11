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
  LCLIntf, LCLType, LazUtils, LinLDAP, lDapSend, lazutf8,
{$ENDIF}
  Sysutils,  Classes, Events, Constant;

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


type
  ErrLDAP = class(Exception);
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

  TLdapAttributeData = class
  private
    fBerval: record
      Bv_Len: Cardinal;
      Bv_Val: PBytes;
    end;
    fAttribute: TLdapAttribute;
    fEntry: TLdapEntry;
    fModOp: Cardinal;
    //fType: TDataType; there is no need to determine this on per value basis
    fUtf8: Boolean;
    function GetType: TDataType;
    function GetString: string;
    procedure SetString(AValue: string);
    function BervalAddr: PLdapBerval;
  public
    constructor Create(Attribute: TLdapAttribute); virtual;
    function CompareData(P: Pointer; Length: Integer): Boolean;
    procedure SetData(AData: Pointer; ADataSize: Cardinal);
    procedure Delete;
    procedure LoadFromStream(Stream: TStream);
    procedure SaveToStream(Stream: TStream);
    property DataType: TDataType read GetType;
    property AsString: string read GetString write SetString;
    property DataSize: Cardinal read fBerval.Bv_Len;
    property Data: PBytes read fBerval.Bv_Val;
    property Berval: PLdapBerval read BervalAddr;
    property ModOp: Cardinal read fModOp;
    property Attribute: TLdapAttribute read fAttribute;
  end;

  TLdapAttribute = class
  private
    fState: TLdapAttributeStates;
    fName: string;
    fValues: TList;
    fOwnerList: TLdapAttributeList;
    fEntry: TLdapEntry;
    fDataType: TDataType;
    function GetCount: Integer;
    function GetValue(Index: Integer): TLdapAttributeData;
    function GetString: string;
    procedure SetString(AValue: string);
    function GetDataType: TDataType;
    function GetEmpty: Boolean;
  public
    constructor Create(const AName: string; OwnerList: TLdapAttributeList); virtual;
    destructor Destroy; override;
    function  AddValue: TLdapAttributeData; overload;
    procedure AddValue(const AValue: string); overload; virtual;
    procedure AddValue(const AData: Pointer; const ADataSize: Cardinal); overload; virtual;
    procedure DeleteValue(const AValue: string); virtual;
    procedure Delete;
    function IndexOf(const AValue: string): Integer; overload;
    function IndexOf(const AData: Pointer; const ADataSize: Cardinal): Integer; overload;
    property Values[Index: Integer]: TLdapAttributeData read GetValue; default;
  published
    property State: TLdapAttributeStates read fState;
    property Name: string read fName;
    property ValueCount: Integer read GetCount;
    property AsString: string read GetString write SetString;
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
    function Add(const AName: string): TLdapAttribute;
    function IndexOf(const Name: string): Integer;
    function AttributeOf(const Name: string): TLdapAttribute;
    procedure Clear;
    property Items[Index: Integer]: TLdapAttribute read GetNode; default;
    property Count: Integer read GetCount;
  end;

  TLDAPSession = class
  private
    {$ifdef mswindows}
    ldappld: PLDAP;
    {$else}
    ldappld: TLDAPsend;
    {$endif}
    ldapServer: string;
    ldapUser, ldapPassword: string;
    ldapPort: Integer;
    ldapVersion: Integer;
    ldapBase: string;
    ldapSSL: Boolean;
    ldapTLS: Boolean;
    ldapAuthMethod: TLdapAuthMethod;
    fTimeLimit: Integer;
    fSizeLimit: Integer;
    fPagedSearch: Boolean;
    fPageSize: Integer;
    fDerefAliases: Integer;
    fChaseReferrals: Boolean;
    fReferralHops: Integer;
    fOnConnect: TNotifyEvents;
    fOnDisconnect: TNotifyEvents;
    fOperationalAttrs: PCharArray;
    procedure LDAPCheck(const err: ULONG; const Critical: Boolean = true);
    procedure SetServer(Server: string);
    procedure SetUser(User: string);
    procedure SetPassword(Password: string);
    procedure SetPort(Port: Integer);
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
    function  GetOperationalAttrs: string;
    procedure SetOperationalAttrs(const Value: string);
    {$ifdef mswindows}
    procedure ProcessSearchEntry(const plmEntry: PLDAPMessage; Attributes: TLdapAttributeList);
    procedure ProcessSearchMessage(const plmSearch: PLDAPMessage; const NoValues: LongBool; Result: TLdapEntryList);
    {$else}
    procedure ProcessSearchEntry(const plmEntry: TLDAPResult; Attributes: TLdapAttributeList);
    procedure ProcessSearchMessage(const plmSearch: TLDAPsend; const NoValues: LongBool; Result: TLdapEntryList);
    {$endif}
protected
    function  ISConnected: Boolean; virtual;    
  public
    constructor Create;
    destructor Destroy; override;
    procedure Connect; virtual;
    procedure Disconnect; virtual;
    {$ifdef mswindows}
    property pld: PLDAP read ldappld;
    {$else}
    property pld: TLDAPsend read ldappld;
    {$endif}
    property Server: string read ldapServer write SetServer;
    property User: string read ldapUser write SetUser;
    property Password: string read ldapPassword write SetPassword;
    property Port: Integer read ldapPort write SetPort;
    property Version: Integer read ldapVersion write SetVersion;
    property SSL: Boolean read ldapSSL write SetSSL;
    property TLS: Boolean read ldapTLS write SetTLS;
    property AuthMethod: TLdapAuthMethod read ldapAuthMethod write SetLdapAuthMethod;
    property Base: string read ldapBase write ldapBase;
    property TimeLimit: Integer read fTimeLimit write SetTimeLimit;
    property SizeLimit: Integer read fSizeLimit write SetSizeLimit;
    property PagedSearch: Boolean read fPagedSearch write fPagedSearch;
    property PageSize: Integer read fPageSize write fPageSize;
    property DereferenceAliases: Integer read fDerefAliases write SetDerefAliases;
    property ChaseReferrals: Boolean read fChaseReferrals write SetChaseReferrals;
    property ReferralHops: Integer read fReferralHops write SetReferralHops;
    property Connected: Boolean read IsConnected write SetConnect;
    function Lookup(sBase, sFilter, sResult: string; Scope: ULONG): string; virtual;
    function GetDn(sFilter: string): string; virtual;
    procedure Search(const Filter, Base: string; const Scope: Cardinal; QueryAttrs: array of string; const NoValues: LongBool; Result: TLdapEntryList; SearchProc: TSearchCallback = nil); overload;
    procedure Search(const Filter, Base: string; const Scope: Cardinal; attrs: PCharArray; const NoValues: LongBool; Result: TLdapEntryList; SearchProc: TSearchCallback = nil); overload; virtual;
    procedure ModifySet(const Filter, Base: string;
                        const Scope: Cardinal;
                        argNames: array of string;
                        argVals: array of string;
                        argNewVals: array of string;
                        const ModOp: Cardinal);
    procedure WriteEntry(Entry: TLdapEntry); virtual;
    procedure ReadEntry(Entry: TLdapEntry); virtual;
    procedure DeleteEntry(const adn: string); virtual;
    property  OnConnect: TNotifyEvents read FOnConnect;
    property  OnDisconnect: TNotifyEvents read FOnDisconnect;
    property  OperationalAttrs: string read GetOperationalAttrs write SetOperationalAttrs;
  end;

  TLDAPEntry = class
  private
    fSession: TLDAPSession;
    fdn: string;
    fAttributes: TLdapAttributeList;
    fOperationalAttributes: TLdapAttributeList;
    fObjectClass: TLdapAttribute;
    fState: TLdapEntryStates;
    fOnChangeProc: TDataNotifyEvent;
    fOnRead: TNotifyEvent;
    fOnWrite: TNotifyEvent;
    function GetNamedAttribute(const AName: string): TLdapAttribute;
    function GetObjectClass: TLdapAttribute;
  protected
    procedure SetDn(const adn: string);
    procedure SetUtf8Dn(const adn: AnsiString);
    function  GetUtf8Dn: AnsiString;
  public
    ObjectId: Integer;
    property Session: TLDAPSession read fSession;
    constructor Create(const ASession: TLDAPSession; const adn: string); virtual;
    destructor Destroy; override;
    procedure Read; virtual;
    procedure Write; virtual;
    procedure Delete; virtual;
    procedure Clone(ToEntry: TLdapEntry); virtual;
    property Attributes: TLdapAttributeList read fAttributes;
    property AttributesByName[const Name: string]: TLdapAttribute read GetNamedAttribute;
    property OperationalAttributes: TLdapAttributeList read fOperationalAttributes;
  published
    property dn: string read fdn write SetDn;
    { To avoid perpetual conversions, fdn is internaly coded as UNICODE and not as
      Utf8. The ldap_add_s and ldap_modify_s Windows API functions need no converting,
      since the corresponding API UNICODE functions, which insure propper handling,
      are called. That leavs us with neccessity to convert dn specificaly to UTF8
      for base64 encoding when exporting entry to LDIF or DSML, hence utf8dn property }
    property utf8dn: {UTF8String} AnsiString read GetUtf8Dn write SetUtf8Dn;
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
    function      IndexOf(adn: string): Integer;
    property      Items[Index: Integer]: TLdapEntry read GetNode; default;
    property      Count: Integer read GetCount;
    procedure     Sort(const Attributes: array of string; const Asc: boolean); overload;
    procedure     Sort(const Compare: TCompareLdapEntry; const Asc: boolean; const Data: pointer=nil); overload;
    property      OwnsEntries: Boolean read fOwnsEntries write fOwnsEntries;
  end;

{ Name handling routines }
function  DecodeLdapString(const Src: string; const Escape: Char ='\'): string;
function  EncodeLdapString(const Src: string; const Escape: Char ='\'): string;
function  IsValidDn(Value: string): Boolean;
function  CanonicalName(dn: string): string;
procedure SplitRdn(const dn: string; var attrib, value: string);
function  GetAttributeFromDn(const dn: string): string;
function  GetNameFromDn(const dn: string): string;
function  GetRdnFromDn(const dn: string): string;
function  GetDirFromDn(const dn: string): string;


function GetAttributeSortType(Attribute: string): TLdapAttributeSortType;

const
  PSEUDOATTR_DN         = '*DN*';
  PSEUDOATTR_RDN        = '*RDN*';
  PSEUDOATTR_PATH       = '*PATH*';

implementation

{$I LdapAdmin.inc}

uses Misc, Input, Dialogs, Cert, Gss{$IFDEF VER_XEH}, System.UITypes{$ENDIF};

{ Name handling routines }

function DecodeLdapString(const Src: string; const Escape: Char ='\'): string;
var
  p0, p, p1, pr: PChar;
begin
  p := PChar(Src);
  p1 := StrScan(p, Escape);
  if p1 = nil then
  begin
    Result := Src;
    exit;
  end;
  SetLength(Result, length(Src));
  pr := PChar(Result);
  p0 := pr;
  while p^ <> #0 do
  begin
    p1 := CharNext(p);
    if p^ = Escape then
    begin
      p := p1;
      if not (p^ in LdapInvalidChars) then
      begin
        p1 := CharNext(p);
        p1 := CharNext(p1);
        HexToBin(p, pr, p1-p);
        pr := CharNext(pr);
      end;
      p := p1;
      continue;
    end;
    pr^:= p^;
    p := p1;
    pr := CharNext(pr);
  end;
  SetLength(Result, pr - p0);
end;

function EncodeLdapString(const Src: string; const Escape: Char ='\'): string;
var
  p0, p: PChar;
begin
  p := PChar(Src);
  p0 := p;
  Result := '';
  while (p^ <> #0) do
  begin
    if p^ in LdapInvalidChars then
    begin
      Result := Result + Copy(p0, 1, p - p0) + Escape + p^;
      p := CharNext(p);
      p0 := p;
    end
    else
      p := CharNext(p);
  end;
  Result := Result + Copy(p0, 1, Length(Src));
end;


{$ifdef mswindows}
function IsValidDn(Value: string): Boolean;
var
  i: Integer;
  comp: PPChar;
begin
  i := 0;
  comp := ldap_explode_dn(PChar(Value), 0);
  if Assigned(comp) then
  while PCharArray(comp)[i] <> nil do
  begin
    if StrScan(PCharArray(comp)[i], '=') = nil then
      break;
    inc(i);
  end;
  Result := PCharArray(comp)[i] = nil;
  ldap_value_free(comp);
end;

function CanonicalName(dn: string): string;
var
  comp: PPChar;
  i: Integer;
begin
  Result := '';
  comp := ldap_explode_dn(PChar(dn), 1);
  i := 0;
  if Assigned(comp) then
  while PCharArray(comp)[i] <> nil do
  begin
    Result := Result + PCharArray(comp)[i] + '/';
    inc(i);
  end;
  ldap_value_free(comp);
end;
{$else}
function IsValidDn(Value: string): Boolean;
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

function CanonicalName(dn: string): string;
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
{$endif}

procedure SplitRdn(const dn: string; var attrib, value: string);
var
  p, p0, p1: PChar;
begin
  p := PChar(dn);
  p0 := p;
  while (p^ <> #0) and (p^ <> '=') do
    p := CharNext(p);
  SetString(attrib, p0, p - p0);
  p := CharNext(p);
  p1 := p;
  while (p1^ <> #0) and (p1^ <> ',') do
  begin
    if p1^ = '\' then
    begin
      p1 := CharNext(p1);
      if p1^ = #0 then
        break;
    end;
    p1 := CharNext(p1);
  end;
  SetString(value, P, P1 - P);
end;

function GetAttributeFromDn(const dn: string): string;
var
  p, p1: PChar;
begin
  p := PChar(dn);
  p1 := p;
  while (p1^ <> #0) and (p1^ <> '=') do
    p1 := CharNext(p1);
  SetString(Result, P, P1 - P);
end;

function GetNameFromDn(const dn: string): string;
var
  p, p1: PChar;
begin
  p := PChar(dn);
  while (p^ <> #0) and (p^ <> '=') do
    p := CharNext(p);
  p := CharNext(p);
  p1 := p;
  while (p1^ <> #0) and (p1^ <> ',') do
  begin
    if p1^ = '\' then
    begin
      p1 := CharNext(p1);
      if p1^ = #0 then
        break;
    end;
    p1 := CharNext(p1);
  end;
  SetString(Result, P, P1 - P);
end;

function GetRdnFromDn(const dn: string): string;
var
  p, p1: PChar;
begin
  p := PChar(dn);
  p1 := p;
  while (p1^ <> #0) and (p1^ <> ',') do
  begin
    if p1^ = '\' then
    begin
      p1 := CharNext(p1);
      if p1^ = #0 then
        break;
    end;
    p1 := CharNext(p1);
  end;
  SetString(Result, P, P1 - P);
end;

function GetDirFromDn(const dn: string): string;
var
  p: PChar;
begin
  p := PChar(dn);
  while (p^ <> #0) do
  begin
    if p^ = '\' then
    begin
      p := CharNext(p);
      if p^ = #0 then
        break;
    end
    else
    if (p^ = ',') then
    begin
      p := CharNext(p);
      break;
    end;
    p := CharNext(p);
  end;
  Result := p;
end;

function GetAttributeSortType(Attribute: string): TLdapAttributeSortType;
begin
  if Attribute=PSEUDOATTR_DN   then result:=AT_DN   else
  if Attribute=PSEUDOATTR_RDN  then result:=AT_RDN  else
  if Attribute=PSEUDOATTR_PATH then result:=AT_Path else
  result:=AT_Attribute;
end;

{ TLdapSession }

procedure TLdapSession.LDAPCheck(const err: ULONG; const Critical: Boolean = true);
var
  ErrorEx: PChar;
  msg: string;
begin
  if (err = LDAP_SUCCESS) then exit;
  if ((ldap_get_option(pld, LDAP_OPT_SERVER_ERROR, @ErrorEx)=LDAP_SUCCESS) and Assigned(ErrorEx)) then
  begin
    {$ifdef mswindows}
    msg := Format(stLdapErrorEx, [ldap_err2string(err), ErrorEx]);
    {$else}
    msg := Format(stLdapErrorEx, [ldap_err2string(pld,err), ErrorEx]);
    {$endif}
    ldap_memfree(ErrorEx);
  end
  else
  {$ifdef mswindows}
    msg := Format(stLdapError, [ldap_err2string(err)]);
  {$else}
    msg := Format(stLdapError, [ldap_err2string(pld,err)]);
  {$endif}
  if Critical then
    raise ErrLDAP.Create(msg);
  MessageDlg(msg, mtError, [mbOk], 0);
end;

{$ifdef mswidnows}
procedure TLdapSession.ProcessSearchEntry(const plmEntry: PLDAPMessage; Attributes: TLdapAttributeList);
{$else}
procedure TLdapSession.ProcessSearchEntry(const plmEntry: TLDAPResult; Attributes: TLdapAttributeList);
{$endif}
var
  Attr: TLdapAttribute;
  i,j: Integer;
  pszAttr:string;
  pszdn: string;
  pbe: PBerElement;
  ppBer: PPLdapBerVal;
  data: TLDAPAttributeData;
begin
  // loop thru attributes
  {$ifdef mswindows}
  pszAttr := ldap_first_attribute(pld, plmEntry, pbe);
  while Assigned(pszAttr) do
  begin
    Attr := Attributes.Add(pszattr);
    Attr.fState := Attr.fState + [asBrowse];
    // get value
    ppBer := ldap_get_values_len(pld, plmEntry, pszAttr);
    if Assigned(ppBer) then
    try
      i := 0;
      while Assigned(PPLdapBervalA(ppBer)[i]) do
      begin
        Attr.AddValue(PPLdapBervalA(ppBer)[i]^.bv_val, PPLdapBervalA(ppBer)[i]^.bv_len);
        Inc(I);
      end;
    finally
      LDAPCheck(ldap_value_free_len(ppBer), false);
    end;
    ber_free(pbe, 0);
    pszAttr := ldap_next_attribute(pld, plmEntry, pbe);
  end;
  {$else}
  for i := 0 to plmEntry.Attributes.Count - 1 do
  begin
        pszAttr := plmEntry.Attributes[i].AttributeName;

        Attr := Attributes.Add(pszAttr);
        Attr.fState := Attr.fState + [asBrowse];

        for j:=0 to plmEntry.Attributes[i].Count-1 do
        begin

          pszdn:= plmEntry.Attributes[i][j];

          data:=TLdapAttributeData.Create(Attr);
          if plmEntry.Attributes[i].IsBinary then
             data:=@pszdn[1]
          else
             data.AsString:=trim(pszdn);

          Attr.AddValue(data.Data,data.DataSize);

        end;

  end;
  {$endif}
end;

{$ifdef mswindows}
procedure TLDAPSession.ProcessSearchMessage(const plmSearch: PLDAPMessage; const NoValues: LongBool; Result: TLdapEntryList);
{$else}
procedure TLDAPSession.ProcessSearchMessage(const plmSearch: TLDAPsend; const NoValues: LongBool; Result: TLdapEntryList);
{$endif}
var
  {$ifdef mswindows}
  plmEntry: PLDAPMessage;
  pszdn: PChar;
  {$else}
  plmEntry: TLDAPResult;
  pszdn: string;
  {$endif}
  Entry: TLdapEntry;
  i,j : integer;
begin
  try
    {$ifdef mswindows}
    // loop thru entries
    plmEntry := ldap_first_entry(pld, plmSearch);
    while Assigned(plmEntry) do
    begin
      pszdn := ldap_get_dn(pld, plmEntry);
      Entry := TLdapEntry.Create(Self, pszdn);
      Result.Add(Entry);
      if not NoValues then
      begin
        Entry.fState := [esReading];
        try
          ProcessSearchEntry(plmEntry, Entry.Attributes);
          Entry.fState := Entry.fState + [esBrowse]; 
        finally
          Entry.fState := Entry.fState - [esReading];
        end;
      end;
      if Assigned(pszdn) then
        ldap_memfree(pszdn);
      plmEntry := ldap_next_entry(pld, plmEntry);
    end;
    {$else}
    if plmSearch=nil then exit;
    for i:=0 to plmSearch.SearchResult.Count -1 do
    begin
      pszdn:= plmSearch.SearchResult[i].ObjectName;
      Entry := TLdapEntry.Create(Self, pszdn);
      Result.Add(Entry);
      if not NoValues then
      begin
        Entry.fState := [esReading];
        try
          ProcessSearchEntry(plmSearch.SearchResult[i], Entry.Attributes);
          Entry.fState := Entry.fState + [esBrowse];
        finally
          Entry.fState := Entry.fState - [esReading];
        end;
      end;
    end;
    {$endif}
  finally
    // free search results
    {$ifdef mswindows}
    LDAPCheck(ldap_msgfree(plmSearch), false);
    {$endif}
  end;
end;

procedure TLDAPSession.Search(const Filter, Base: string; const Scope: Cardinal; attrs: PCharArray; const NoValues: LongBool; Result: TLdapEntryList; SearchProc: TSearchCallback = nil);
var
  {$ifdef mswindows}
  plmSearch: PLDAPMessage;
  {$else}
  plmSearch: TLDAPsend;
  {$endif}
  Err: Integer;
  ServerControls: PLDAPControl;
  ClientControls: PLDAPControl;
  SortKeys: PLDAPSortKey;
  HSrch: PLDAPSearch;
  TotalCount: Cardinal;
  Timeout: LDAP_TIMEVAL;
  AbortSearch: Boolean;
begin

  if not fPagedSearch then
  begin
    Err := ldap_search_s(pld, PChar(Base), Scope, PChar(Filter), PChar(attrs), Ord(NoValues), plmSearch);
    if Err = LDAP_SIZELIMIT_EXCEEDED then
    {$ifdef mswindows}
      MessageDlg(ldap_err2string(err), mtWarning, [mbOk], 0)
    {$else}
      MessageDlg(ldap_err2string(pld,err), mtWarning, [mbOk], 0)
    {$endif}
    else
      LdapCheck(Err);
    {$ifdef mswindows}
    ProcessSearchMessage(pld, NoValues, Result);
    {$else}
    ProcessSearchMessage(pld, NoValues, Result);
    //ProcessSearchMessage(plmSearch, NoValues, Result);
    {$endif}
    exit;
  end;

  ServerControls:=nil;
  ClientControls:=nil;
  SortKeys:=nil;
  hsrch:=ldap_search_init_page(pld, PChar(Base), Scope, PChar(Filter), PChar(attrs), Ord(NoValues),
                                   ServerControls, ClientControls, 60, SizeLimit, SortKeys);
  if not Assigned(hsrch) then
  begin
    Err := LdapGetLastError;
    if Err <> LDAP_NOT_SUPPORTED then
      LdapCheck(Err); // raises exception
    fPagedSearch := false;
    LdapCheck(ldap_search_s(pld, PChar(Base), Scope, PChar(Filter), PChar(attrs), Ord(NoValues), plmSearch)); // try ordinary search
    ProcessSearchMessage(pld, NoValues, Result);
    Exit;
  end;

  Timeout.tv_sec := 60;
  TotalCount := 1;
  while true do
  begin
    Err := ldap_get_next_page_s(pld, hsrch, Timeout, fPageSize, TotalCount, plmSearch);
    case Err of
      LDAP_UNAVAILABLE_CRIT_EXTENSION, LDAP_UNWILLING_TO_PERFORM:
          begin
            fPagedSearch := false;
            ldap_search_abandon_page(hsrch);
            LdapCheck(ldap_search_s(pld, PChar(Base), Scope, PChar(Filter), PChar(attrs), Ord(NoValues), plmSearch)); // try ordinary search
            ProcessSearchMessage(pld, NoValues, Result);
            Break;
          end;
    LDAP_NO_RESULTS_RETURNED, LDAP_SIZELIMIT_EXCEEDED:
        begin
          if Err = LDAP_SIZELIMIT_EXCEEDED then
          begin
            ProcessSearchMessage(pld, NoValues, Result);
            {$ifdef mswindows}
            MessageDlg(ldap_err2string(err), mtWarning, [mbOk], 0)
            {$else}
            MessageDlg(ldap_err2string(pld,err), mtWarning, [mbOk], 0);
            {$endif}
          end;
          LdapCheck(ldap_search_abandon_page(hsrch));
          break;
        end;
    LDAP_SUCCESS:
        begin
          if not Assigned(plmSearch) then
            Continue;
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


procedure TLdapSession.Search(const Filter, Base: string; const Scope: Cardinal; QueryAttrs: array of string; const NoValues: LongBool; Result: TLdapEntryList; SearchProc: TSearchCallback = nil);
var
  attrs: PCharArray;
  len: Integer;
begin
  attrs := nil;
  len := Length(QueryAttrs);
  if Len > 0 then
  begin
    SetLength(attrs, len + 1);
    attrs[len] := nil;
    repeat
      dec(len);
      attrs[len] := PChar(QueryAttrs[len]);
    until len = 0;
  end;
  Search(Filter, Base, Scope, attrs, NoValues, Result, SearchProc);
end;

{ Modify set of attributes in every entry set returned by search filter }
procedure TLdapSession.ModifySet(const Filter, Base: string;
                                 const Scope: Cardinal;
                                 argNames: array of string;
                                 argVals: array of string;
                                 argNewVals: array of string;
                                 const ModOp: Cardinal);
var
  List: TLdapEntryList;
  attrs: PCharArray;
  Entry: TLDapEntry;
  h, i: Integer;
begin
  List := TLdapEntryList.Create;
  try
    h := High(argNames);
    SetLength(attrs, h + 2);
    for i := 0 to High(argNames) do
      attrs[i] := PChar(argNames[i]);
    attrs[h + 1] := nil;
    Search(Filter, Base, Scope, attrs, false, List);
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

{$ifdef mswindows}
procedure TLDAPSession.WriteEntry(Entry: TLdapEntry);
var
  i, j, acnt, addidx, delidx, repidx: Integer;
  attrs: PPLDapMod;
  AttributeList: TLdapAttributeList;

  procedure ValueModOp(AValue: TLdapAttributeData; var idx: Integer);
  var
    pix: Integer;
  begin
    if idx < 0 then  // new entry
    begin
      if acnt = High(attrs) then            // we need trailing NULL
        SetLength(attrs, acnt + 10);        // expand array if neccessary
      idx := acnt;
      GetMem(attrs[acnt], SizeOf(LDAPMod));
      with attrs[acnt]^ do
      begin
        mod_op := AValue.ModOp or LDAP_MOD_BVALUES;
        mod_type := PChar(AValue.fAttribute.Name);
        modv_bvals := nil;        // MUST be nil before call to SetLength!
        SetLength(PPLdapBervalA(modv_bvals), 2);
        PPLdapBervalA(modv_bvals)[0] := AValue.BerVal;
        PPLdapBervalA(modv_bvals)[1] := nil;   // trailing NULL
      end;
      Inc(acnt);
    end
    else
    begin
      with attrs[idx]^ do
      begin
        pix := Length(PPLdapBervalA(modv_bvals));
        PPLdapBervalA(modv_bvals)[pix - 1] := AValue.BerVal;
        Setlength(PPLdapBervalA(modv_bvals), pix + 1);
        PPLdapBervalA(modv_bvals)[pix] := nil;  // trailing NULL
      end;
    end;
  end;

  procedure DeleteAll(const AttributeName: string);
  begin
    if acnt = High(attrs) then            // we need trailing NULL
      SetLength(attrs, acnt + 10);        // expand array if neccessary
    GetMem(attrs[acnt], SizeOf(LDAPMod));
    with attrs[acnt]^ do
    begin
      mod_op := LDAP_MOD_DELETE;
      mod_type := PChar(AttributeName);
      modv_bvals := nil;
    end;
    Inc(acnt);
  end;

begin
  AttributeList := Entry.Attributes; // for faster access
  SetLength(attrs, 10); // TODO ModopCount, acnt -> ModopCount
  acnt := 0;
  try
    for i := 0 to AttributeList.Count - 1 do
    begin
      if asDeleted in AttributeList[i].State then
        DeleteAll(AttributeList[i].Name)
      else
      if asModified in AttributeList[i].State then
      begin
        addidx := -1;
        delidx := -1;
        repidx := -1;
        for j := 0 to AttributeList[i].ValueCount - 1 do
          case AttributeList[i][j].ModOp of
            LDAP_MOD_ADD:     ValueModop(AttributeList[i][j], addidx);
            LDAP_MOD_DELETE:  ValueModop(AttributeList[i][j], delidx);
            LDAP_MOD_REPLACE: ValueModop(AttributeList[i][j], repidx);
          end;
      end;
    end;
    attrs[acnt] := nil;  // trailing NULL
    if acnt > 0 then
    begin
      if esNew in Entry.State then
        ///LdapCheck(ldap_add_s(pld, PChar(Entry.dn), PLDAPMod(attrs)))
        LdapCheck(ldap_add_s(pld, PChar(Entry.dn), attrs))
      else
        LdapCheck(ldap_modify_s(pld, PChar(Entry.dn), PLDAPMod(attrs)));
    end;
  finally
    for i := 0 to acnt - 1 do
      FreeMem(attrs[i]);
  end;
end;

{$else}
procedure TLDAPSession.WriteEntry(Entry: TLdapEntry);
var
  i,j          : integer;
  AttributeList: TLdapAttributeList;
  Attributes   : LDAPSend.TLDAPAttributeList;
  data         : LDAPSend.TLDAPAttribute;


procedure MakeAttrib(AValue: TLdapAttributeData);
begin
  data := Attributes.Find(AValue.fAttribute.Name);
  if data <> nil then
  begin
    data.add(AValue.AsString)
  end
  else
  begin
    data:=Attributes.Add;
    data.AttributeName:=AValue.fAttribute.Name;
    if not(asDeleted in AttributeList[i].State) then
       data.add(AValue.AsString);
  end;
end;

procedure ValueModOp(AValue: TLdapAttributeData; ModOP: TLDAPModifyOp);
begin
  MakeAttrib(AttributeList[i][j]);
  if not(esNew in Entry.State) then LdapCheck(ldap_modify_s(pld, PChar(Entry.dn), ModOP, Attributes[0]));
end;


begin
  Attributes:=LDAPSend.TLDAPAttributeList.Create;
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
            LDAP_MOD_ADD:     ValueModOp(AttributeList[i][j],MO_Add);
            LDAP_MOD_DELETE:  ValueModOp(AttributeList[i][j],MO_Delete);
            LDAP_MOD_REPLACE: ValueModOp(AttributeList[i][j],MO_Replace);
          end;
      end;
    end;
    if esNew in Entry.State then
        LdapCheck(ldap_add_s(pld, PChar(Entry.dn), Attributes));
  finally
  Attributes.Free;
  end;

end;
{$endif}

procedure TLDAPSession.ReadEntry(Entry: TLdapEntry);
var
  {$ifdef mswindows}
  plmEntry: PLDAPMessage;
  {$else}
  plmEntry: TLDAPsend;
  {$endif}

  procedure DoRead(attrs: PCharArray; AttributeList: TLdapAttributeList);
  begin
    LdapCheck(ldap_search_s(pld, PChar(Entry.dn), LDAP_SCOPE_BASE, sANYCLASS, PChar(attrs), 0, plmEntry));
    try
      if Assigned(plmEntry) then
         ProcessSearchEntry(plmEntry.SearchResult[0], AttributeList);
    finally
      // free search results
      ///LDAPCheck(ldap_msgfree(plmEntry), false);
    end;
  end;

begin
  DoRead(nil, Entry.Attributes);
  if Assigned(fOperationalAttrs) then
    DoRead(fOperationalAttrs, Entry.OperationalAttributes);
end;

procedure TLdapSession.DeleteEntry(const adn: string);
begin
  LdapCheck(ldap_delete_s(pld, PChar(adn)));
end;

function TLDAPSession.Lookup(sBase, sFilter, sResult: string; Scope: ULONG): string;
var
  {$ifdef mswindows}
  plmSearch, plmEntry: PLDAPMessage;
  {$else}
  plmSearch: TLDAPsend;
  plmEntry:  TLDAPResult;
  {$endif}
  attrs: PCharArray;
  ppcVals: PPCHAR;
begin
    // set result to sResult only
    SetLength(attrs, 2);
    attrs[0] := PChar(sResult);
    attrs[1] := nil;
    Result := '';
    // perform search
    LdapCheck(ldap_search_s(pld, PChar(sBase), Scope, PChar(sFilter), PChar(attrs), 0, plmSearch));
    try
      plmEntry := ldap_first_entry(pld, plmSearch);
      if Assigned(plmEntry) then
      begin
        ppcVals := ldap_get_values(pld, plmEntry, attrs[0]);
        try
          if Assigned(ppcVals) then
            Result := pchararray(ppcVals)[0];
        finally
          ///LDAPCheck(ldap_value_free(ppcVals), false);
        end;
      end;
    finally
      // free search results
      ///LDAPCheck(ldap_msgfree(plmSearch), false);
    end;
end;

function TLDAPSession.GetDn(sFilter: string): string;
var
  {$ifdef mswindows}
  plmSearch, plmEntry: PLDAPMessage;
  {$else}
  plmSearch: TLDAPsend;
  plmEntry: TLDAPResult;
  {$endif}
  attrs: PCharArray;
begin
    // set result to dn only
    SetLength(attrs, 2);
    attrs[0] := 'objectclass';
    attrs[1] := nil;
    Result := '';
    // perform search
    LdapCheck(ldap_search_s(pld, PChar(ldapBase), LDAP_SCOPE_SUBTREE, PChar(sFilter), PChar(attrs), 1, plmSearch));
    try
      plmEntry := ldap_first_entry(pld, plmSearch);
      if Assigned(plmEntry) then
        Result := ldap_get_dn(pld, plmEntry);
    finally
      // free search results
      ///LDAPCheck(ldap_msgfree(plmSearch), false);
    end;
end;

procedure TLDAPSession.SetServer(Server: string);
begin
  Disconnect;
  ldapServer := Server;
end;

procedure TLDAPSession.SetUser(User: string);
begin
  Disconnect;
  ldapUser := User;
end;

procedure TLDAPSession.SetPassword(Password: string);
begin
  Disconnect;
  ldapPassword := Password;
end;

procedure TLDAPSession.SetPort(Port: Integer);
begin
  Disconnect;
  ldapPort := Port;
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

procedure TLDAPSession.SetTLS(Value: Boolean);
begin
  if Connected and (Value <> ldapTLS) then
  begin
    if Value then
      LdapCheck(ldap_start_tls_s(ldappld, nil, nil, nil, nil))
    else
    if not ldap_stop_tls_s(ldappld) then
    begin
      MessageDlg(stStopTLSError, mtError, [mbOk], 0);
      Disconnect;
    end;
  end;
  ldapTLS := Value;
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

function TLDAPSession.GetOperationalAttrs: string;
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

procedure TLDAPSession.SetOperationalAttrs(const Value: string);
var
  fStringList: TStringList;
  i: Integer;
begin
  for i := Low(fOperationalAttrs) to High(fOperationalAttrs) do
    StrDispose(fOperationalAttrs[i]);
  if Value <> '' then
  begin
    fStringList := TStringList.Create;
    with fStringList do
    try
      CommaText := Value;
      SetLength(fOperationalAttrs, Count + 1);
      fOperationalAttrs[Count] := nil;
      for i := 0 to Count - 1 do
        fOperationalAttrs[i] := StrNew(PChar(fStringList[i]));
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

function TLDAPSession.IsConnected: Boolean;
begin
  Result := Assigned(pld);
end;

constructor TLDAPSession.Create;
begin
  inherited Create;
  {$ifndef mswindows}
  ldappld:= TLDAPsend.Create;
  {$endif}
  ldapAuthMethod := AUTH_SIMPLE;
  ldapPort := LDAP_PORT;
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
  {$ifndef mswindows}
  ldappld.free;
  {$endif}
  fOnConnect.Free;
  fOnDisconnect.Free;
  OperationalAttrs := ''; // dispose string array
  inherited;
end;

procedure TLDAPSession.Connect;
var
  res: Cardinal;
  v: Pointer;
  ident: SEC_WINNT_AUTH_IDENTITY;
begin
  if (ldapUser<>'') and (ldapPassword='') then
    if not InputDlg(cEnterPasswd, Format(stPassFor, [ldapUser]), ldapPassword, '*', true) then Abort;
  {$ifdef mswindows}
  if ldapSSL then
    ldappld := ldap_sslinit(PChar(ldapServer), ldapPort,1)
  else
    ldappld := ldap_init(PChar(ldapServer), ldapPort);
  {$else}
  if ldapSSL then
    ldap_sslinit(ldappld, ldapServer, ldapPort,1)
  else
    ldap_init(ldappld,ldapServer, ldapPort);
  {$endif}
  if Assigned(pld) then
  try
    LdapCheck(ldap_set_option(ldappld,LDAP_OPT_PROTOCOL_VERSION,@ldapVersion));
    if ldapSSL or ldapTLS then
    begin
      ///res := ldap_set_option(pld, LDAP_OPT_SERVER_CERTIFICATE, @VerifyCert);
      if (res <> LDAP_SUCCESS) and (res <> LDAP_LOCAL_ERROR) then
        LdapCheck(res);
      CertServerName := PChar(ldapServer);
    end;
    CertUserAbort := false;
    if ldapTLS then
      LdapCheck(ldap_start_tls_s(ldappld, nil, nil, nil, nil));
    case ldapAuthMethod of
      AUTH_SIMPLE:   res := ldap_simple_bind_s(ldappld, PChar(ldapUser), PChar(ldapPassword));
      AUTH_GSS,
      AUTH_GSS_SASL: begin
                       if (ldapUser <> '') or (ldapPassword <> '') then
                       begin
                         ident.User := PChar(ldapUser);
                         ident.UserLength := Length(ldapUser);
                         ident.Domain := '';
                         ident.DomainLength := 0;
                         ident.Password := PChar(ldapPassword);
                         ident.PasswordLength := Length(ldapPassword);
                         {$IFDEF UNICODE}
                         ident.Flags := SEC_WINNT_AUTH_IDENTITY_UNICODE;
                         {$ELSE}
                         ident.Flags := SEC_WINNT_AUTH_IDENTITY_ANSI;
                         {$ENDIF}
                         v := @ident;
                       end
                       else
                         v := nil;
                       if ldapAuthMethod = AUTH_GSS_SASL then
                         LdapCheck(ldap_set_option(ldappld,LDAP_OPT_ENCRYPT, LDAP_OPT_ON));
                       res := ldap_bind_s(ldappld, nil, v, LDAP_AUTH_NEGOTIATE);
                     end;
    else
      raise Exception.Create('Invalid authentication method!');
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
    // close connection
    LdapCheck(ldap_unbind_s(pld), false);
    //ldappld := nil;
    raise;
  end;
  fOnConnect.Execute(self);
end;

procedure TLDAPSession.Disconnect;
begin
  if Connected then
  begin
    fOnDisconnect.Execute(self);
    //LdapCheck(ldap_unbind_s(pld), false);
    ldappld.Logout;
    //ldappld := nil;
  end;
end;

{ TLDapAttributeData }

function TLDapAttributeData.GetType: TDataType;
var
  w: Word;

  {$IFDEF CPUX64}
  function LengthAsStr(P: Pointer; Length: Integer): Cardinal;
  var
    c: Integer;
  begin
    c := Length;
    while (c > 0) do
    begin
      if PByte(P)^ = 0 then
        break;
      dec(c);
      inc(PByte(P));
    end;
    Result := Length - c;
  end;
  {$ELSE}
  function LengthAsStr(P: Pointer; Length: Integer): Cardinal; assembler;
  asm
        PUSH    EDI
        MOV     EDI,EAX
        MOV     ECX,EDX
        SUB     EAX,EAX
        REPNE   SCASB
        MOV     EAX,EDX
        SUB     EAX,ECX
        POP     EDI
  end;
  {$ENDIF}

  function IsText(p:  PAnsiChar): boolean;
  var
    dt: TSysCharSet;
    charlen: integer;
  begin
    {
    result:=false;
    while True do
       case p^ of
            #0: begin result:=true;break; end; //done, okay if past the end of the string
            #8, #10, #12, #13, ' '..#$7E: inc(p); //okay
            #$C0..#$DF: inc(p); //2 bytes
            #$E0..#$EF: inc(p); //3 bytes
            #$F0..#$F4: inc(p); //4 bytes
       else exit(False); //not valid text
    end;
    }

    result:=true;
    repeat
      CharLen := UTF8CharacterLength(p);
      if CharLen=0 then
      begin
        result:=false;
        break;
      end;
      inc(p,CharLen);
    until (CharLen=0) or (p^ = #0);

    //result:= not(IsEmptyStr(p,dt));
  end;

begin
  if (Attribute.fDataType = dtUnknown) and (DataSize > 0) then
  begin
    if (LengthAsStr(Data, DataSize) >= DataSize)   then
    {$IFDEF WINDOWS}
    //if (LengthAsStr(Data, DataSize) >= DataSize) and
      if (MultiByteToWideChar( CP_UTF8, 8{MB_ERR_INVALID_CHARS}, PAnsiChar(Data), DataSize, nil, 0) <> 0) then
       Attribute.fDataType := dtText
    {$ELSE}
       if IsText(PAnsiChar(Data)) then Attribute.fDataType := dtText
    {$ENDIF}
    else begin
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

function TLDapAttributeData.GetString: string;
begin
  if Assigned(Self) and (ModOp <> LdapOpNoop) and (ModOp <> LdapOpDelete) then
  begin
    if fUtf8 then
      Result := UTF8ToStringLen(PAnsiChar(Data), DataSize)
    else
      System.SetString(Result, PAnsiChar(Data), DataSize);
  end
  else
    Result := '';
end;

procedure TLDapAttributeData.SetString(AValue: string);
var
  s: AnsiString;
begin
  if fUtf8 then
    s := StringToUtf8Len(PChar(AValue), Length(AValue))
  else
    s := AVAlue;
  SetData(PChar(s), Length(s));
end;

procedure TLDapAttributeData.LoadFromStream(Stream: TStream);
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

procedure TLDapAttributeData.SaveToStream(Stream: TStream);
begin
  if Assigned(Self) and (ModOp <> LdapOpNoop) and (ModOp <> LdapOpDelete) then
    Stream.WriteBuffer(Berval.bv_val, fBerval.Bv_Len);
end;

function TLDapAttributeData.BervalAddr: PLdapBerval;
begin
  Result := Addr(fBerval);
end;

constructor TLDapAttributeData.Create(Attribute: TLdapAttribute);
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



{$IFDEF CPUX64}
function TLDapAttributeData.CompareData(P: Pointer; Length: Integer): Boolean;
begin
  Result := (DataSize = Length) and CompareMem(P, Data, Length);
end;
{$ELSE}
function TLDapAttributeData.CompareData(P: Pointer; Length: Integer): Boolean; assembler;
asm
        PUSH    ESI
        MOV     ESI,P
        MOV     EDX,EAX
        XOR     EAX,EAX
        CMP     ECX,[edx + fBerval.Bv_Len]
        JNE     @@3
        PUSH    EDI
        MOV     EDI,[edx + fBerval.Bv_Val]
        CMP     ESI,EDI
        JE      @@1
        REPE    CMPSB
        JNE     @@2
@@1:    INC     EAX
@@2:    POP     EDI
@@3:    POP     ESI
end;
{$ENDIF}



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

procedure TLDapAttributeData.Delete;
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

procedure TLdapAttribute.AddValue(const AValue: string);
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


function TLdapAttribute.GetString: string;
begin
  if fValues.Count > 0 then
    Result := TLdapAttributeData(fValues[0]).AsString
  else
    Result := '';
end;

procedure TLdapAttribute.SetString(AValue: string);
begin
  // Setting string value(s) to '' means deleting of the attribute
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

constructor TLdapAttribute.Create(const AName: string; OwnerList: TLdapAttributeList);
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

procedure TLdapAttribute.DeleteValue(const AValue: string);
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

function TLdapAttribute.IndexOf(const AValue: string): Integer;
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

function TLdapAttributeList.Add(const AName: string): TLdapAttribute;
begin
  Result := TLdapAttribute.Create(AName, Self);
  fList.Add(Result);
end;

function TLdapAttributeList.IndexOf(const Name: string): Integer;
begin
  Result := fList.Count - 1;
  while Result >= 0 do
  begin
    if AnsiCompareText(Name, Items[Result].Name) = 0 then
      break;
    dec(Result);
  end;
end;

function TLdapAttributeList.AttributeOf(const Name: string): TLdapAttribute;
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

{ TLdapEntry }

procedure TLDAPEntry.SetDn(const adn: string);
var
  attrib, value: string;
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

procedure TLDAPEntry.SetUtf8Dn(const adn: AnsiString);
begin
  SetDn(UTF8Decode(adn));
end;

function  TLDAPEntry.GetUtf8Dn: AnsiString;
begin
  Result := UTF8Encode(dn);
end;

constructor TLDAPEntry.Create(const ASession: TLDAPSession; const adn: string);
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

function TLDAPEntry.GetNamedAttribute(const AName: string): TLdapAttribute;
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

function TLdapEntryList.IndexOf(adn: string): Integer;
begin
  Result := fList.Count - 1;
  while Result >= 0 do
  begin
    if AnsiCompareText(adn, Items[Result].dn) = 0 then
      break;
    dec(Result);
  end;
end;

procedure TLdapEntryList.Sort(const Attributes: array of string; const Asc: boolean);
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
