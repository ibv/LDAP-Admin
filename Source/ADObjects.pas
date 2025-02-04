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
  {$ifdef WINDOWS} Windows, {$endif}
  LinLDAP, forms, graphics, types, Process, Controls,
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
  {$ifdef WINDOWS}
  SECURITY_WORLD_SID_AUTHORITY: TSidIdentifierAuthority = (Value: (0, 0, 0, 0, 0, 1));
  SECURITY_NT_AUTHORITY : TSidIdentifierAuthority = (Value: (0, 0, 0, 0, 0, 5));
  {$endif}
  SECURITY_BUILTIN_DOMAIN_RID = ($00000020);
  DOMAIN_ALIAS_RID_ADMINS = ($00000220);
  SECURITY_WORLD_RID =($00000000);
  SECURITY_PRINCIPAL_SELF_RID = ($0000000A);
  CHANGE_PASSWORD_GUID = '{AB721A53-1E2F-11D0-9819-00AA0040529B}';
  ADS_ACETYPE_ACCESS_DENIED_OBJECT =  6;


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
    procedure   Add(dn:  string); overload;
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
    procedure SetAccountExpires(Value:  TDateTime);
    function  GetPrimaryGroup: string;
    //function  GetJPegImage: TJpegImage;
    //procedure SetJPegImage(const Image: TJpegImage);
    function  GetRid: Cardinal;
  public
    procedure AdSetPassword(Pwd: string);
    property  AdSid: string read GetSid;
    property  AdDomainSid: string read GetDomainSid;
    property  AdPrimaryGroup: string read GetPrimaryGroup;
    property  AdAccountExpires: TDateTime read GetAccountExpires write SetAccountExpires;
    //property  JPegPhoto: TJPegImage read GetJPegImage write SetJPegImage;
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
function  GetUACstring(Uac: string): string;
function  WrapGetComputerNameEx({$ifdef WINDOWS}ANameFormat: Windows.COMPUTER_NAME_FORMAT{$endif}): string;
function  GetNetBiosDomain: string;

implementation

{$I LdapAdmin.inc}
uses
  Sysutils, Misc, Config,
  Pickup, Dialogs, mormot.core.os, mormot.net.ldap, mormot.core.os.security ;

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

function WrapGetComputerNameEx({$ifdef WINDOWS}ANameFormat: Windows.COMPUTER_NAME_FORMAT{$endif}): string;
var
  nSize: DWORD;
begin
  nSize := 1024;
  SetLength(Result, nSize);
  {$ifdef mswindows}
  if GetComputerNameEx(ANameFormat, PChar(Result), @nSize) then
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
  {$ifdef WINDOWS}
  SidNameUse: Windows.SID_NAME_USE;
  {$endif}
  sid: array[0..512] of Byte;
begin
   dwSidSize := 512;
   dwComputerSize := MAX_PATH;
   dwDomainSize := MAX_PATH;
   {$ifdef mswindows}
   Windows.GetComputerName (ComputerName, dwComputerSize);
   {$else}
   ComputerName := GetComputerName;
   {$endif}
   SetLength(Result, dwDomainSize);
   {$ifdef mswindows}
   if not LookupAccountName(nil, @ComputerName, @Sid, dwSidSize, PChar(Result), dwDomainSize, SidNameUse) then
     RaiseLastOSError;
   {$else}
    Result:='NONE';
   {$endif}
   SetLength(Result, dwDomainSize);
end;


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
    FDefaultNamingContext := Connection.Lookup('', sAnyClass,'defaultNamingContext', lssBaseObject);
  Result := FDefaultNamingContext;
end;

function TADHelper.ConfigurationNamingContext: string;
begin
  if FConfigurationNamingContext = '' then
    FConfigurationNamingContext := Connection.Lookup('', sAnyClass,'configurationNamingContext', lssBaseObject);
  result := FConfigurationNamingContext;
end;

function TADHelper.NTDomain: string;
begin
  if FNTDomain = '' then
  begin
    FNTDomain := Connection.Lookup('CN=Partitions,' + ConfigurationNamingContext, '(&(objectcategory=Crossref)(ncName=' + DefaultNamingContext + ')(netBIOSName=*))', 'netBIOSName', lssWholeSubtree);
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
    Connection.Search('(&(objectcategory=Crossref)(ncName='+ DefaultNamingContext  + ')(dnsRoot=*))', 'CN=Partitions,' + ConfigurationNamingContext, lssWholeSubtree, ['dnsRoot'], false, EL);
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
    MemberAttr: LDapClasses.TLdapAttribute;
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
      AsString := IntToStr(UInt64(DateTimeToWinApiTime(LocalDateTimeToUTC(Value))));
end;

function TADObjectHelper.GetSid: string;
var
  val: TLdapAttributeData;
begin
  val := AttributesByName['objectSid'].Values[0];
  if Assigned(val) then
    Result := SidToText(Pointer(val.Data))
  else
    Result := '';
end;

function TADObjectHelper.GetDomainSid: string;
var
  val: TLdapAttributeData;
begin
  val := AttributesByName['objectSid'].Values[0];
  if Assigned(val) then
    Result := SidToText(Pointer(val.Data))
  else
    Result := '';
end;

function TADObjectHelper.GetPrimaryGroup: string;
begin
  Result := Session.GetDN(Format('(&(objectclass=group)(ObjectSID=%s-%s))', [AdDomainSid, AttributesByName['primaryGroupId'].AsString]));
end;

//function TADObjectHelper.GetJPegImage: TJpegImage;
//var
//  Value: TLdapAttributeData;
//begin
//  Result := nil;
//  Value := AttributesByName['jpegPhoto'].Values[0];
//  if Assigned(Value) and (Value.DataSize > 0) then
//  begin
//    Result := TJPEGImage.Create;
//    StreamCopy(Value.SaveToStream, Result.LoadFromStream);
//  end;
//end;
//
//procedure TADObjectHelper.SetJPegImage(const Image: TJpegImage);
//var
//  Attribute: TLdapAttribute;
//begin
//  Attribute := AttributesByName['jpegPhoto'];
//  if not Assigned(Image) then
//    Attribute.Delete
//  else
//  begin
//    if Attribute.ValueCount = 0 then
//      Attribute.AddValue;
//    StreamCopy(Image.SaveToStream, Attribute.Values[0].LoadFromStream);
//  end;
//end;

function TADObjectHelper.GetRid: Cardinal;
begin
  Result := GetRidFromObjectSID(Pointer(AttributesByName['objectSid'].Values[0].Data));
end;

end.

