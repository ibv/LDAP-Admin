  {      LDAPAdmin - ADObjects.pas
  *      Copyright (C) 2016 Tihomir Karlovic
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

unit ADObjects;

interface

uses
  {$ifdef mswindows}
  Windows, WinLDAP, UITypes, jpeg,
  {$else}
  LinLDAP, forms, graphics, types, Process, Controls,
  {$endif}
  Classes, LDAPClasses, Constant, Connection, ComCtrls;

resourcestring
  stDelPrimaryGroup = '"%s" is currently primary group and can not be deleted.';
  stScript = 'The logon script will be run.';
  stAccountdisable = 'Account is disabled';
  stHomedirRequired = 'The home folder is required.';
  stLockout = 'Account ist locked out.';
  stPasswdNotreqd = 'No password is required.';
  stPasswdCantChange = 'The user cannot change the password.';
  stEncryptedTextPwdAllowed = 'The user can send an encrypted password.';
  stTempDuplicateAccount = 'This is a local user account.';
  stNormalAccount = 'Normal user account.';
  stInterdomainTrustAccount = 'Interdomain trust account.';
  stWorkstationTrustAccount = 'Workstation trust account.';
  stServerTrustAccount = 'Server trust account.';
  stDontExpirePassword = 'Password never expires.';
  stMnsLogonAccount = 'MNS logon account.';
  stSmartcardRequired = 'Smart card login required.';
  stTrustedForDelegation = 'Trusted for delegation';
  stNotDelegated = 'Account can not be delegated.';
  stUseDesKeyOnly = 'Use only DES encryption.';
  stDontReqPreauth = 'Kerberos preauthentication not required.';
  stPasswordExpired = 'Password has expired.';
  stTrustedToAuthFor = 'Enabled for delegation';
  stPartialSecretsAccount = 'Read-only domain controller.';
  stDomainController = 'Domain controller';
  stWkstOrServer = 'Workstation or server';

const
  ///SECURITY_WORLD_SID_AUTHORITY: TSidIdentifierAuthority = (Value: (0, 0, 0, 0, 0, 1));
  ///SECURITY_NT_AUTHORITY : TSidIdentifierAuthority = (Value: (0, 0, 0, 0, 0, 5));
  SECURITY_BUILTIN_DOMAIN_RID = ($00000020);
  DOMAIN_ALIAS_RID_ADMINS = ($00000220);
  SECURITY_WORLD_RID =($00000000);
  SECURITY_PRINCIPAL_SELF_RID = ($0000000A);
  CHANGE_PASSWORD_GUID = '{AB721A53-1E2F-11D0-9819-00AA0040529B}';
  ADS_ACETYPE_ACCESS_DENIED_OBJECT = 6;


  { User Account Control flags }
  UF_SCRIPT                          = $0001;
  UF_ACCOUNTDISABLE                  = $0002;
  UF_HOMEDIR_REQUIRED                = $0008;
  UF_LOCKOUT                         = $0010;
  UF_PASSWD_NOTREQD                  = $0020;
  UF_PASSWD_CANT_CHANGE              = $0040;  //Cannot be set by directly modifying the UserAccountControl attribute
  UF_ENCRYPTED_TEXT_PWD_ALLOWED      = $0080;
  UF_TEMP_DUPLICATE_ACCOUNT          = $0100;
  UF_NORMAL_ACCOUNT                  = $0200;
  UF_INTERDOMAIN_TRUST_ACCOUNT       = $0800;
  UF_WORKSTATION_TRUST_ACCOUNT       = $1000;
  UF_SERVER_TRUST_ACCOUNT            = $2000;
  UF_DONT_EXPIRE_PASSWORD            = $10000;
  UF_MNS_LOGON_ACCOUNT               = $20000;
  UF_SMARTCARD_REQUIRED              = $40000;
  UF_TRUSTED_FOR_DELEGATION          = $80000;
  UF_NOT_DELEGATED                   = $100000;
  UF_USE_DES_KEY_ONLY                = $200000;
  UF_DONT_REQ_PREAUTH                = $400000;
  UF_PASSWORD_EXPIRED                = $800000;
  UF_TRUSTED_TO_AUTH_FOR_DELEGATION  = $1000000;
  UF_PARTIAL_SECRETS_ACCOUNT         = $04000000;

  { Group type }
  GLOBAL_GROUP                    = 2;
  DOMAIN_LOCAL_GROUP              = 4;
  UNIVERSAL_GROUP                 = 8;

  SECURITY_ENABLED                = $80000000;

  ufAccountNeverExpires           = 0;

type
  _COMPUTER_NAME_FORMAT = (
    ComputerNameNetBIOS,
    ComputerNameDnsHostname,
    ComputerNameDnsDomain,
    ComputerNameDnsFullyQualified,
    ComputerNamePhysicalNetBIOS,
    ComputerNamePhysicalDnsHostname,
    ComputerNamePhysicalDnsDomain,
    ComputerNamePhysicalDnsFullyQualified,
    ComputerNameMax);
  {$EXTERNALSYM _COMPUTER_NAME_FORMAT}
  COMPUTER_NAME_FORMAT = _COMPUTER_NAME_FORMAT;
  {$EXTERNALSYM COMPUTER_NAME_FORMAT}
  TComputerNameFormat = COMPUTER_NAME_FORMAT;


type
   _SID_NAME_USE = (
     SidTypeUser = 1,
     SidTypeGroup,
     SidTypeDomain,
     SidTypeAlias,
     SidTypeWellKnownGroup,
     SidTypeDeletedAccount,
     SidTypeInvalid,
     SidTypeUnknown,
     SidTypeComputer,
     SidTypeLabel
   );
   SID_NAME_USE = _SID_NAME_USE;


type
  TADHelper = class
  private
    FConnection: TConnection;
    FDefaultNamingContext: string;
    FConfigurationNamingContext: string;
    FNTDomain: string;
    FDNSRoot: TStringList;
  public
    function    DefaultNamingContext: string;
    function    ConfigurationNamingContext: string;
    function    NTDomain: string;
    function    DNSRoot: TStringList;
    constructor Create(AConnection: TConnection);
    destructor  Destroy; override;
    property    Connection: TConnection read FConnection;
  end;

  TMembershipHelper = class
  private
    FEntry: TLdapEntry;
    FMembers: TStringList;
    FList: TListView;
    FPrimaryGroup: string;
    FOldPrimaryGroup: string;
    fModified: Boolean;
    procedure   UpdateList;
  public
    constructor Create(Entry: TLdapEntry; List: TListView);
    destructor  Destroy; override;
    procedure   Add(dn: string); overload;
    procedure   Add; overload;
    procedure   Delete;
    function    QueryPrimaryGroup: TModalResult;
    procedure   Write;
    property    Members: TStringList read FMembers;
    property    PrimaryGroup: string read FPrimaryGroup;
    property    Modified: Boolean read FModified;
  end;

  TAdObjectHelper = class helper for TLdapEntry
  private
    function  GetSid: string;
    function  GetDomainSid: string;
    function  GetAccountExpires: TDateTime;
    procedure SetAccountExpires(Value: TDateTime);
    function  GetPrimaryGroup: string;
    function  GetJPegImage: TJpegImage;
    procedure SetJPegImage(const Image: TJpegImage);
    function  GetRid: Cardinal;
  public
    procedure AdSetPassword(Pwd: string);
    property  AdSid: string read GetSid;
    property  AdDomainSid: string read GetDomainSid;
    property  AdPrimaryGroup: string read GetPrimaryGroup;
    property  AdAccountExpires: TDateTime read GetAccountExpires write SetAccountExpires;
    property  JPegPhoto: TJPegImage read GetJPegImage write SetJPegImage;
    property  Adrid: Cardinal read GetRid;
  end;

  PSidRec = ^TSidRec;
  TSidRec = record
    Revision: Byte;
    SubAuthorityCount: Byte;
    IdentifierAuthority: array[0..5] of Byte;
    SubAuthority: array[0..255] of DWORD;
  end;

function  DateTimeToWinapiTime(Value: TDateTime): TFileTime;
function  WinapiTimeToDateTime(Value: TFileTime): TDateTime;
function  ObjectSIDToString(sid: PSidRec): string;
function  GetUACstring(Uac: string): string;
{$ifdef mswindows}
function  GetUserCannotChangePassword(Entry: TLdapEntry): Boolean;
procedure SetUserCannotChangePassword(Entry: TLdapEntry; Value: Boolean);
{$endif}
function  WrapGetComputerNameEx(ANameFormat: COMPUTER_NAME_FORMAT): string;
function  GetNetBiosDomain: string;

implementation

{$I LdapAdmin.inc}

uses
  {$IFDEF VARIANTS} variants, {$ENDIF} md4Samba, smbdes, Sysutils, Misc, Config,
  Pickup, Dialogs {$ifdef mswindows},ActiveX, ComObj, ActiveDs_TLB, adsie,AclApi, AccCtrl{$endif};

type
  TSidIdent = (siEveryone, siSelf);

const
    { Password expires values: setting accountExpires attribute to either of
      them means that password never expires }
    WT_AccountNeverExpires1 = '0';
    WT_AccountNeverExpires2 = '9223372036854775807'; //$7FFFFFFFFFFFFFFF;

    GRP_ADD           =  1;
    GRP_DEL           = -1;

function GetUACstring(Uac: string): string;
var
  Flags: Integer;
begin
  Result := '';
  if TryStrToInt(uac, Flags) then
  begin
    if Flags and UF_SCRIPT <> 0 then Result := Result + #10 + stScript;
    if Flags and UF_ACCOUNTDISABLE <> 0 then Result := Result + #10 + stAccountdisable;
    if Flags and UF_HOMEDIR_REQUIRED <> 0 then Result := Result + #10 + stHomedirRequired;
    if Flags and UF_LOCKOUT <> 0 then Result := Result + #10 + stLockout;
    if Flags and UF_PASSWD_NOTREQD <> 0 then Result := Result + #10 + stPasswdNotreqd;
    if Flags and UF_PASSWD_CANT_CHANGE <> 0 then Result := Result + #10 + stPasswdCantChange;
    if Flags and UF_ENCRYPTED_TEXT_PWD_ALLOWED <> 0 then Result := Result + #10 + stEncryptedTextPwdAllowed;
    if Flags and UF_TEMP_DUPLICATE_ACCOUNT <> 0 then Result := Result + #10 + stTempDuplicateAccount;
    if Flags and UF_NORMAL_ACCOUNT <> 0 then Result := Result + #10 + stNormalAccount;
    if Flags and UF_INTERDOMAIN_TRUST_ACCOUNT <> 0 then Result := Result + #10 + stInterdomainTrustAccount;
    if Flags and UF_WORKSTATION_TRUST_ACCOUNT <> 0 then Result := Result + #10 + stWorkstationTrustAccount;
    if Flags and UF_SERVER_TRUST_ACCOUNT <> 0 then Result := Result + #10 + stServerTrustAccount;
    if Flags and UF_DONT_EXPIRE_PASSWORD <> 0 then Result := Result + #10 + stDontExpirePassword;
    if Flags and UF_MNS_LOGON_ACCOUNT <> 0 then Result := Result + #10 + stMnsLogonAccount;
    if Flags and UF_SMARTCARD_REQUIRED <> 0 then Result := Result + #10 + stSmartcardRequired;
    if Flags and UF_TRUSTED_FOR_DELEGATION <> 0 then Result := Result + #10 + stTrustedForDelegation;
    if Flags and UF_NOT_DELEGATED <> 0 then Result := Result + #10 + stNotDelegated;
    if Flags and UF_USE_DES_KEY_ONLY <> 0 then Result := Result + #10 + stUseDesKeyOnly;
    if Flags and UF_DONT_REQ_PREAUTH <> 0 then Result := Result + #10 + stDontReqPreauth;
    if Flags and UF_PASSWORD_EXPIRED <> 0 then Result := Result + #10 + stPasswordExpired;
    if Flags and UF_TRUSTED_TO_AUTH_FOR_DELEGATION <> 0 then Result := Result + #10 + stTrustedToAuthFor;
    if Flags and UF_PARTIAL_SECRETS_ACCOUNT <> 0 then Result := Result + #10 + stPartialSecretsAccount;
  end;
  Delete(Result, 1, 1);
end;

function GetComputerName : string;
var
  c: array[0..127] of Char;
  computer: string;
  sz: dword;
  AProcess: TProcess;
  AStringList: TStringList;

begin
  AProcess := TProcess.Create(nil);
  AStringList := TStringList.Create;
  AProcess.CommandLine := 'hostname';
  AProcess.Options := AProcess.Options + [poWaitOnExit, poUsePipes];
  AProcess.Execute;
  AStringList.LoadFromStream(AProcess.Output);
  Result:=AStringList.Strings[0];
  AStringList.Free;
  AProcess.Free;

end;

function WrapGetComputerNameEx(ANameFormat: COMPUTER_NAME_FORMAT): string;
var
  nSize: DWORD;
begin
  nSize := 1024;
  SetLength(Result, nSize);
  {$ifdef mswindows}
  if GetComputerNameEx(ANameFormat, PWideChar(Result), nSize) then
    SetLength(Result, nSize)
  else
    Result := '';
  {$else}
  Result:= GetComputerName;
  {$endif}
end;

function GetNetBiosDomain: string;
var
  dwDomainSize, dwSidSize, dwComputerSize: DWord;
  ComputerName: Array [0..MAX_PATH] of Char;
  SidNameUse: SID_NAME_USE;
  sid: array[0..512] of Byte;
begin
   dwSidSize := 512;
   dwComputerSize := MAX_PATH;
   dwDomainSize := MAX_PATH;
   {$ifdef mswindows}
   GetComputerName (ComputerName, dwComputerSize);
   {$else}
   ComputerName := GetComputerName;
   {$endif}
   SetLength(Result, dwDomainSize);
   {$ifdef mswindows}
   if not LookupAccountNameW(nil, @ComputerName, @Sid, dwSidSize, PChar(Result), dwDomainSize, SidNameUse) then
     RaiseLastOSError;
   {$else}
    Result:='NONE';
   {$endif}
   SetLength(Result, dwDomainSize);
end;

{$ifdef mswindows}
function GetSidAccountName(ptrSid: PSID): string; overload;
var
  wszAccountName: array[0..MAX_PATH] of Char;
  dwAccountName: DWORD;
  wszDomainName: array[0..MAX_PATH] of Char;
  dwDomainName: DWORD ;
  SidNameUse: SID_NAME_USE;
begin
  dwAccountName := MAX_PATH;
  dwDomainName := MAX_PATH;


  if LookupAccountSid(nil, ptrSid, PChar(@wszAccountName),
        dwAccountName, PChar(@wszDomainName), dwDomainName, SidNameUse) then
  begin
    if StrLen(wszDomainName) > 0 then
    begin
      Result := '\';
      Result := wszDomainName + Result + wszAccountName;
    end
    else
      Result := wszAccountName;
  end
    else
      RaiseLastOSError;

end;


function GetSidAccountName(SidIdent: TSidIdent): string; overload;
var
  pSidAlloc: PSID;
  SidAuth: SID_IDENTIFIER_AUTHORITY;
  SubAuthority: DWORD;
begin
  case SidIdent of
    siEveryone: begin
                  SidAuth := SECURITY_WORLD_SID_AUTHORITY;
                  SubAuthority := SECURITY_WORLD_RID;
                end;
    siSelf:     begin
                  SidAuth := SECURITY_NT_AUTHORITY;
                  SubAuthority := SECURITY_PRINCIPAL_SELF_RID;
                end;
  else
    raise Exception.Create('Invalid identity flag!');
  end;

  if not AllocateAndInitializeSid(SidAuth, 1, SubAuthority, 0, 0, 0, 0, 0, 0, 0, pSidAlloc) then
    RaiseLastOSError;
  Result := GetSidAccountName(psidAlloc);
  LocalFree(NativeUINT(psidAlloc));
end;



function GetObjectACE(iAcl: IADsAccessControlList; pwszObject: string;
                      pwszTrustee: string; var piACE: IADsAccessControlEntry ): HRESULT;
var
  iEnum: IEnumVARIANT;
  ulFetched: ULONG;
  svarACE: OleVariant;
  iACE: IADsAccessControlEntry;
  sbStrTrustee, sbStrObjectType: string;
begin
  if not Assigned(iAcl) and (pwszObject = '') then
  begin
    Result := E_INVALIDARG;
    exit;
  end;

  piACE := nil;

  Result := IDispatch(iAcl._NewEnum).QueryInterface(IEnumVariant, iEnum);

  while Result = 0 do
  begin
    Result := iEnum.Next(1, sVarACE, ulFetched);
    if (ulFetched <= 0) then
      Break;
    if (TVariantArg(sVarACE).vt = VT_DISPATCH) then
    begin
      Result := IDispatch(sVarACE).QueryInterface(IADsAccessControlEntry, iACE);
      if SUCCEEDED(Result) then
        begin
          sbStrObjectType := iACE.ObjectType;
          if AnsiSameText(pwszObject, sbstrObjectType) then
          begin
            sbstrTrustee := iACE.Trustee;
            if AnsiSametext(sbstrTrustee, pwszTrustee) then
              piACE := iACE;
          end;
        end;
    end;
  end;
end;

function GetUserCannotChangePassword(Entry: TLdapEntry): Boolean;
var
  ADsObject: IADs;
  iSecDesc: IADsSecurityDescriptor;
  iACL: IADsAccessControlList;
  iACEEveryone, iACESelf: IADsAccessControlEntry;
  fLdapPath, fUsername, fPassword: string;
  fEveryoneName, fSelfName: string;
begin

  with Entry.Session do
  begin
    fLdapPath := 'LDAP://' + Server + '/' + Entry.dn;
    fUserName := User;
    fPassword := Password;
  end;

  ADOpenObject(fLdapPath, ExtractUsername(fUserName), fPassword, IID_IADs, AdsObject);
  OleCheck(IDispatch(ADsObject.Get('nTSecurityDescriptor')).QueryInterface(IADsSecurityDescriptor, iSecDesc));
  OleCheck(IDispatch(iSecDesc.DiscretionaryAcl).QueryInterface(IADsAccessControlList, iACL));

  fEveryoneName := GetSidAccountName(siEveryone);
  Result := false;
  OleCheck(GetObjectACE(iACL, CHANGE_PASSWORD_GUID, fEveryoneName, iACEEveryone));
  if Assigned(iACEEveryone) and (iACEEveryone.AceType = ADS_ACETYPE_ACCESS_DENIED_OBJECT) then
  begin
    fSelfName := GetSidAccountName(siSelf);
    OleCheck(GetObjectACE(iACL, CHANGE_PASSWORD_GUID, fSelfName, iACESelf));
    if Assigned(iACESelf) and (iACESelf.AceType = ADS_ACETYPE_ACCESS_DENIED_OBJECT) then
      Result := true;
  end;
end;

function CreateACE(bstrTrustee, bstrObjectType: string; lAccessMask, lACEType,
                   lACEFlags, lFlags: Integer): IDispatch;
var
  iDisp: IDispatch;
  iACE: IADsAccessControlEntry;
begin
  iDisp := nil;
  iACE := nil;

  OleCheck(CoCreateInstance(CLASS_AccessControlEntry, nil, CLSCTX_INPROC_SERVER,
                            IID_IADsAccessControlEntry, iACE));
  iACE.Trustee := bstrTrustee;
  iACE.ObjectType := bstrObjectType;
  iACE.AccessMask := lAccessMask;
  iACE.AceType := lACEType;
  iACE.AceFlags := lACEFlags;
  iACE.Flags := lFlags;
  iACE.QueryInterface(IDispatch, iDisp);
  Result := iDisp;
end;

function ReorderACEs(pwszDN: string): HRESULT;
var
  dwResult: DWORD;
  pdacl: ACL;
  psd: PSECURITY_DESCRIPTOR;

begin
  Result := E_FAIL;
  dwResult := GetNamedSecurityInfo(PChar(pwszDN), SE_DS_OBJECT_ALL, DACL_SECURITY_INFORMATION,
                                   nil, nil, @pdAcl, nil, psd);
  if dwResult = ERROR_SUCCESS then
  begin
    dwResult := SetNamedSecurityInfo(PChar(pwszDN), SE_DS_OBJECT_ALL, DACL_SECURITY_INFORMATION,
                                     nil, nil, @pdAcl, nil);
    LocalFree(NativeUInt(psd));
    if dwResult = ERROR_SUCCESS then
      Result := S_OK;
  end;
end;


procedure SetUserCannotChangePassword(Entry: TLdapEntry; Value: Boolean);
var
  ADsObject: IADs;
  iSecurityDescriptor: IADsSecurityDescriptor;
  iACL: IADsAccessControlList;
  iACESelf, iACEEveryone: IADsAccessControlEntry;
  iDispSelf, iDispEveryone: IDispatch;
  sVar: OleVariant;
  fLdapPath, fUsername, fPassword: string;
  fEveryoneName, fSelfName: string;
  fMustReorder: Boolean;

  function GetAcl: Integer;
  begin
    if Value then
      Result := ADS_ACETYPE_ACCESS_DENIED_OBJECT
    else
      Result := ADS_ACETYPE_ACCESS_ALLOWED_OBJECT
  end;

begin
  with Entry.Session do
  begin
    fLdapPath := 'LDAP://' + Server + '/' + Entry.dn;
    fUserName := User;
    fPassword := Password;
  end;

  fEveryoneName := GetSidAccountName(siEveryone);
  fSelfName := GetSidAccountName(siSelf);

  ADOpenObject(fLdapPath, ExtractUsername(fUserName), fPassword, IID_IADs, AdsObject);
  sVar := ADsObject.Get('ntSecurityDescriptor');
  OleCheck(IDispatch(sVar).QueryInterface(IADsSecurityDescriptor, iSecurityDescriptor));
  OleCheck(IDispatch(iSecurityDescriptor.DiscretionaryAcl).QueryInterface(IADsAccessControlList, iACL));

  fMustReorder := false;

  iACEEveryone := nil;
  OleCheck(GetObjectACE(iACL, CHANGE_PASSWORD_GUID, fEveryoneName, iACEEveryone));
  if Assigned(iACEEveryone) then
    iACEEveryone.AceType := GetAcl
  else
  begin
    iDispEveryone := nil;
    iDispEveryone := CreateACE(fEveryoneName, CHANGE_PASSWORD_GUID,
                               ADS_RIGHT_DS_CONTROL_ACCESS, GetAcl, 0,
                               ADS_FLAG_OBJECT_TYPE_PRESENT);

    if Assigned(iDispEveryone) then
    begin
      iACL.AddAce(iDispEveryone); //add the new ACE for everyone
      fMustReorder := true;
    end;
  end;

  { Get the existing ACE for the change password permission for Self. If it
    exists, just modify the existing ACE. If it does not exist, create a new
    one and add it to the ACL.}
  iACESelf := nil;
  OleCheck(GetObjectACE(iACL, CHANGE_PASSWORD_GUID, fSelfName, iACESelf));
  if Assigned(iACESelf) then
    iACESelf.AceType := GetAcl
  else begin
    iDispSelf := nil;
    iDispSelf := CreateACE(fSelfName, CHANGE_PASSWORD_GUID, ADS_RIGHT_DS_CONTROL_ACCESS,
                           GetAcl, 0, ADS_FLAG_OBJECT_TYPE_PRESENT);
    if Assigned(iDispSelf) then
    begin
      iACL.AddAce(iDispSelf); //add the new ACE for self
      fMustReorder := TRUE;
    end;
  end;

  AdsObject.Put('ntSecurityDescriptor', sVar); //update the security descriptor property
  AdsObject.SetInfo;                           //commit the changes

  if fMustReorder then
    ReorderACEs(fLdapPath);
end;


{$endif}


function ExtractUsername(adn: string): string;
begin
  Result := GetNameFromDn(adn);
  if Result = '' then
    Result := adn;
end;





function GetRidFromObjectSid(sid: PSidRec): Cardinal; inline;
begin
  Result := sid.SubAuthority[sid.SubAuthorityCount - 1];
end;

function ObjectSIDToString(sid: PSidRec): string;
var
  i: Cardinal;
begin
  {$ifdef mswindows}
  Result := 'S-' + UIntToStr(sid.Revision) + '-' + UIntToStr(sid.IdentifierAuthority[5]);
  for i := 0 to sid.SubAuthorityCount - 1 do
    Result := Result + '-' + UIntToStr(sid.SubAuthority[i]);
  {$else}
  result:='';
  {$endif}
end;

function GetDomainFromObjectSID(sid: PSidRec): string;
var
  i: Cardinal;
begin
  {$ifdef mswindows}
  Result := 'S-' + UIntToStr(sid.Revision) + '-' + UIntToStr(sid.IdentifierAuthority[5]);
  for i := 0 to sid.SubAuthorityCount - 2 do
    Result := Result + '-' + UIntToStr(sid.SubAuthority[i]);
  {$else}
  result:='';
  {$endif}
end;

function DateTimeToWinapiTime(Value: TDateTime): TFileTime;
var
  st: TSystemTime;
begin
  DateTimeToSystemTime(Value, st);
  ///SystemTimeToFileTime(st, Result);
end;

function WinapiTimeToDateTime(Value: TFileTime): TDateTime;
var
  st: TSystemTime;
begin
  ///FileTimeToSystemTime(Value, st);
  Result := SystemTimeToDateTime(st);
end;

{ TADHelper }

function TADHelper.DefaultNamingContext: string;
begin
  if FDefaultNamingContext = '' then
    FDefaultNamingContext := Connection.Lookup('', sAnyClass,'defaultNamingContext', LDAP_SCOPE_BASE);
  Result := FDefaultNamingContext;
end;

function TADHelper.ConfigurationNamingContext: string;
begin
  if FConfigurationNamingContext = '' then
    FConfigurationNamingContext := Connection.Lookup('', sAnyClass,'configurationNamingContext', LDAP_SCOPE_BASE);
  result := FConfigurationNamingContext;
end;

function TADHelper.NTDomain: string;
begin
  if FNTDomain = '' then
  begin
    FNTDomain := Connection.Lookup('CN=Partitions,' + ConfigurationNamingContext, '(&(objectcategory=Crossref)(ncName=' + DefaultNamingContext + ')(netBIOSName=*))', 'netBIOSName', LDAP_SCOPE_SUBTREE);
  end;
  Result := FNTDomain;
end;

function TADHelper.DNSRoot: TStringList;
var
  EL: TLdapEntryList;
  i, j: Integer;
begin
  if FDNSRoot = nil then
  begin
    FDNSRoot := TStringList.Create;
    EL := TLdapEntryList.Create;
    Connection.Search('(&(objectcategory=Crossref)(ncName='+ DefaultNamingContext  + ')(dnsRoot=*))', 'CN=Partitions,' + ConfigurationNamingContext, LDAP_SCOPE_SUBTREE, ['dnsRoot'], false, EL);
    for i := 0 to EL.Count - 1 do with EL[i].AttributesByName['dnsRoot'] do
    for j := 0 to ValueCount - 1 do
      FDNSRoot.Add(Values[j].AsString);
  end;
  Result := FDNSRoot;
end;

constructor TADHelper.Create(AConnection: TConnection);
begin
  FConnection := AConnection;
end;

destructor TADHelper.Destroy;
begin
  FDnsRoot.Free;
  inherited;
end;

{ TMembershipHelper }

procedure TMembershipHelper.UpdateList;
var
  i: Integer;
  ListItem: TListItem;
begin
  try
    FList.Items.BeginUpdate;
    FList.Items.Clear;
    for i := 0 to FMembers.Count - 1 do
    if Integer(FMembers.Objects[i]) >= 0 then
    begin
      ListItem := FList.Items.Add;
      ListItem.Data := Pointer(i);
      ListItem.Caption := GetNameFromDn(FMembers[i]);
      ListItem.SubItems.Add(GetDirFromDn(FMembers[i]));
      ListItem.ImageIndex := bmSambaGroup;
    end;
    FList.AlphaSort;
  finally
    FList.Items.EndUpdate;
  end;
end;

constructor TMembershipHelper.Create;
var
  i: Integer;
begin
  FEntry := Entry;
  FList := List;
  FMembers := TStringList.Create;
  with Entry.AttributesByName['memberOf'] do
    for i := 0 to ValueCount - 1 do
      FMembers.Add(Values[i].AsString);
  FPrimaryGroup := FEntry.AdPrimaryGroup;
  FOldPrimaryGroup := FPrimaryGroup;
  if FPrimaryGroup <> '' then
  begin
    i := FMembers.IndexOf(FPrimaryGroup);
    if i = -1 then
      FMembers.Add(FPrimaryGroup);
  end;
  UpdateList;
end;

destructor TMembershipHelper.Destroy;
begin
  FMembers.Free;
  inherited;
end;

{ ListItem.Data    -> index of corresponding FMembers entry
  FMembers.Objects -> operation }

procedure TMembershipHelper.Add(dn: string);
var
  ListItem: TListItem;
  idx: Integer;
begin
  idx := FMembers.IndexOf(dn);
  if (idx = -1) or (Integer(FMembers.Objects[idx]) < 0) then
  begin
    FModified := true;
    ListItem := FList.Items.Add;
    ListItem.Caption := GetNameFromDn(dn);
    ListItem.SubItems.Add(GetDirFromDn(dn));
    ListItem.ImageIndex := bmSambaGroup;
    if idx = -1 then
      ListItem.Data := Pointer(FMembers.AddObject(dn, Pointer(GRP_ADD)))
    else begin
      FMembers.Objects[idx] := Pointer(Integer(FMembers.Objects[idx]) + GRP_ADD);
      ListItem.Data := Pointer(idx);
    end;
  end;
end;

procedure TMembershipHelper.Add;
var
  i: Integer;
begin
  with TPickupDlg.Create(nil) do begin
    Caption := cPickGroups;
    ColumnNames := cName + ',' + cDescription;
    Populate(FEntry.Session, '(objectclass=group)', ['cn', 'description']);
    if ShowModal=mrOK then begin
      for i:=0 to SelCount-1 do  begin
        Add(Selected[i].dn);
      end;
      FModified := true;
    end;
    Free;
  end;
end;

procedure TMembershipHelper.Delete;
var
  idx: Integer;
begin
  with FList do
  If Assigned(Selected) then
  begin
    idx := Integer(Selected.Data);
    if FMembers[idx] = FPrimaryGroup then    
    begin
      MessageDlg(Format(stDelPrimaryGroup,
                [Selected.Caption]), mtError, [mbOk], 0);
      exit;
    end;
    Selected.Delete;
    FMembers.Objects[idx] := Pointer(Integer(FMembers.Objects[idx]) + GRP_DEL);
    FModified := true;
    if idx = Items.Count then
      Dec(idx);
    if idx > -1 then
      Items[idx].Selected := true;
  end;
end;

function TMembershipHelper.QueryPrimaryGroup: TModalResult;
begin
  with TPickupDlg.Create(nil) do
  try
    Screen.Cursor := crHourGlass;
    Caption := cPickGroups;
    ColumnNames := cName + ',' + cDescription;
    Populate(FEntry.Session, '(&(objectclass=group)(groupType=-2147483646))', ['cn', 'description']);
    ImageIndex := bmSambaGroup;
    Result := ShowModal;
    if Result = mrOk then
    begin
      FModified := true;
      if Selected[0].Dn = FPrimaryGroup then
        Result := mrCancel
      else begin
        FPrimaryGroup := Selected[0].Dn;
        Add(FPrimaryGroup);
      end;
    end;
  finally
    Screen.Cursor := crDefault;
    Free;
  end;
end;

procedure TMembershipHelper.Write;
var
  i, ip, modop: Integer;

  procedure WriteMember(dn: string; modop: Integer);
  var
    GroupEntry: TLdapEntry;
    MemberAttr: TLdapAttribute;
    MemberValue: string;  
  begin
    GroupEntry := TLdapEntry.Create(FEntry.Session, dn);
    GroupEntry.Read(['member']);
    MemberAttr := GroupEntry.AttributesByName['member'];
    MemberValue := FEntry.dn;
    try
      if modop > 0 then
        MemberAttr.AddValue(MemberValue)
      else
        MemberAttr.DeleteValue(MemberValue);
      GroupEntry.Write;
    finally
      GroupEntry.Free;
    end;
  end;

  procedure SetPrimaryGroup;
  var
    GroupEntry: TLdapEntry;
  begin
    GroupEntry := TLdapEntry.Create(FEntry.Session, FPrimaryGroup);
    try          
      GroupEntry.Read;
      FEntry.AttributesByName['primaryGroupID'].AsString := IntToStr(GroupEntry.Adrid);
    finally
      GroupEntry.Free;
    end;
  end;
  
begin  
  ip := -1;
  for i := 0 to FMembers.Count - 1 do
  begin
    modop := Integer(FMembers.Objects[i]);
    if modop <> 0 then
    begin
      if (FMembers[i] = FOldPrimaryGroup) and (modop < 0) then
      begin
        ip := i;
        continue;
      end;
      WriteMember(FMembers[i], modop);
    end;
  end;
  if FPrimaryGroup <> FOldPrimaryGroup then
    SetPrimaryGroup;
  FEntry.Write;
  if ip <> -1 then
    WriteMember(FMembers[ip], GRP_DEL);
  for i := 0 to FMembers.Count - 1 do
    FMembers.Objects[i] := nil;
  FModified := false;
end;

{ TADObjectHelper }

procedure TADObjectHelper.AdSetPassword(Pwd: string);
var
  val: TLdapAttributeData;
begin
  {$IFDEF UNICODE}
  pwd := '"' + Pwd + '"';
  {$ELSE}
  pwd := '"' + StringToWide(Pwd) + '"';
  {$ENDIF}
  with AttributesByName['unicodePwd'] do begin
    if ValueCount = 0 then
      val := AddValue
    else
      val := Values[0];
    val.SetData(PChar(Pwd), 2*Length(pwd)); // Password must be UTF-16 encoded quoted string
    val.ModOp := LDAP_MOD_REPLACE;          // Force replace operation, API requirement
  end;
end;

function TADObjectHelper.GetAccountExpires: TDateTime;
var
  dt: TFileTime;
  s: string;
begin
  Result := ufAccountNeverExpires;
  s := AttributesByName['accountExpires'].AsString;
  if (s <> '') and (s <> WT_AccountNeverExpires1) and (s <> WT_AccountNeverExpires2) then
  begin
    if TryStrToInt64(s, Int64(dt)) then
      Result := UTCToLocalDateTime(WinApiTimeToDateTime(dt));
  end;
end;

procedure TADObjectHelper.SetAccountExpires(Value: TDateTime);
begin
  with AttributesByName['accountExpires'] do
    if Value = 0 then
      AsString := WT_AccountNeverExpires1
    else
      {$ifdef mswindows}
      AsString := UIntToStr(UInt64(DateTimeToWinApiTime(Value)));
      {$else}
      AsString := IntToStr(UInt64(DateTimeToWinApiTime(LocalDateTimeToUTC(Value))));
      {$endif}
end;

function TADObjectHelper.GetSid: string;
var
  val: TLdapAttributeData;
begin
  val := AttributesByName['objectSid'].Values[0];
  if Assigned(val) then
    Result := ObjectSIDToString(Pointer(val.Data))
  else
    Result := '';
end;

function TADObjectHelper.GetDomainSid: string;
var
  val: TLdapAttributeData;
begin
  val := AttributesByName['objectSid'].Values[0];
  if Assigned(val) then
    Result := GetDomainFromObjectSID(Pointer(val.Data))
  else
    Result := '';
end;

function TADObjectHelper.GetPrimaryGroup: string;
begin
  Result := Session.GetDN(Format('(&(objectclass=group)(ObjectSID=%s-%s))', [AdDomainSid, AttributesByName['primaryGroupId'].AsString]));
end;

function TADObjectHelper.GetJPegImage: TJpegImage;
var
  Value: TLdapAttributeData;
begin
  Result := nil;
  Value := AttributesByName['jpegPhoto'].Values[0];
  if Assigned(Value) and (Value.DataSize > 0) then
  begin
    Result := TJPEGImage.Create;
    StreamCopy(Value.SaveToStream, Result.LoadFromStream);
  end;
end;

procedure TADObjectHelper.SetJPegImage(const Image: TJpegImage);
var
  Attribute: TLdapAttribute;
begin
  Attribute := AttributesByName['jpegPhoto'];
  if not Assigned(Image) then
    Attribute.Delete
  else
  begin
    if Attribute.ValueCount = 0 then
      Attribute.AddValue;
    StreamCopy(Image.SaveToStream, Attribute.Values[0].LoadFromStream);
  end;
end;

function TADObjectHelper.GetRid: Cardinal;
begin
  Result := GetRidFromObjectSID(Pointer(AttributesByName['objectSid'].Values[0].Data));
end;

end.

