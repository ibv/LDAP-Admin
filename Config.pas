  {      LDAPAdmin - Config.pas
  *      Copyright (C) 2006 Alexander Sokoloff
  *
  *      Author: Alexander Sokoloff
  *
  *      Changes: Removed Compat Support - T.Karlovic 25.05.2011
  *               Removed FakeAccount    - T.Karlovic 11.06.2012
  *               Unicode Support        - T.Karlovic 11.06.2012
  *               TRegistryConfigStorage.Delete and
  *               TConfig.Delete         - T.Karlovic 09.11.2012
  *               Unicode strings        - T.Karlovic 15.07.2016
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

unit Config;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
{$IFnDEF FPC}
  Windows, FileUtil
{$ELSE}
  LCLIntf, LCLType, LazFileUtils,
{$ENDIF}
  Registry, Classes, Contnrs, SysUtils, LDAPClasses, Xml
  ;


type
  TConfigStorage=class;
  TConfig=class;
  TAccount=class;
  TGlobalConfig=class;

  TCustomConfig=class
  public
    procedure     Delete(const Ident: string); virtual; abstract;
    function      ValueExist(const Ident: string): boolean; virtual; abstract;
    procedure     GetKeyNames(Parent: string; var Result: TStrings); virtual; abstract;
    procedure     GetValueNames(Parent: string; var Result: TStrings); virtual; abstract;
    function      ReadString(const Ident: string; const Default: string=''): string; virtual; abstract;
    procedure     WriteString(const Ident: string; const Value: string); virtual; abstract;
    function      ReadInteger(const Ident: string; const Default: integer=0): integer; virtual; abstract;
    procedure     WriteInteger(const Ident: string; const Value: integer); virtual; abstract;
    procedure     WriteBool(const Ident: string; const Value: boolean); virtual; abstract;
    function      ReadBool(const Ident: string; const Default: boolean=false): boolean; virtual; abstract;
    function      GetDataSize(const Ident: string): Integer; virtual; abstract;
    function      ReadBinaryData(const Ident:  string; var Buffer; BufSize: Integer): Integer; virtual; abstract;
    procedure     WriteBinaryData(const Ident: string; var Buffer; BufSize: Integer); virtual; abstract;
  end;

  TConfig=class(TCustomConfig)
  private
    FStorage:     TConfigStorage;
    FRootPath:    string;
    function      Norm(Ident: string): string;
  protected
    FChanged:     boolean;
  public
    constructor   Create(AStorage: TConfigStorage; const ARootPath: string); reintroduce; virtual;
    destructor    Destroy; override;
    procedure     Delete(const Ident: string); override;
    procedure     GetKeyNames(Parent: string; var Result: TStrings); override;
    procedure     GetValueNames(Parent: string; var Result: TStrings); override;
    function      ValueExist(const Ident: string): boolean; override;
    function      ReadString(const Ident: string; const Default: string=''):string; override;
    procedure     WriteString(const Ident: string; const Value: string); override;
    function      ReadInteger(const Ident: string; const Default: integer=0): integer; override;
    procedure     WriteInteger(const Ident: string; const Value: integer); override;
    function      ReadBool(const Ident: string; const Default: boolean=false): boolean; override;
    procedure     WriteBool(const Ident: string; const Value: boolean); override;
    function      GetDataSize(const Ident: string): Integer; override;
    function      ReadBinaryData(const Ident:  string; var Buffer; BufSize: Integer): Integer; override;
    procedure     WriteBinaryData(const Ident: string; var Buffer; BufSize: Integer); override;
    property      RootPath: string read FRootPath;
    property      Changed: boolean read FChanged;
    property      Storage: TConfigStorage read FStorage;
  end;

  TAccount=class(TConfig)
  private
    FUser:        string;
    FPassword:    string;
    procedure     SetBase(const Value: string); virtual;
    procedure     SetPassword(const Value: string); virtual;
    procedure     SetPort(const Value: integer); virtual;
    procedure     SetServer(const Value: string); virtual;
    procedure     SetUser(const Value: string); virtual;
    procedure     SetSSL(const Value: boolean); virtual;
    procedure     SetTLS(const Value: boolean); virtual;
    procedure     SetLdapVersion(const Value: integer); virtual;
    function      GetName: string; virtual;
    procedure     SetName(const Value: string); virtual;
    function      GetBase: string; virtual;
    function      GetLdapVersion: integer; virtual;
    function      GetPassword: string; virtual;
    function      GetPort: integer; virtual;
    function      GetServer: string; virtual;
    function      GetUser: string; virtual;
    function      GetSSL: boolean; virtual;
    function      GetTLS: boolean; virtual;
    procedure     SetAuthMethod(const Value: TLdapAuthMethod); virtual;
    function      GetAuthMethod: TLdapAuthMethod; virtual;
    function      GetTimeLimit: Integer;
    procedure     SetTimeLimit(const Value: Integer);
    function      GetSizeLimit: Integer;
    procedure     SetSizeLimit(const Value: Integer);
    function      GetPagedSearch: boolean;
    procedure     SetPagedSearch(const Value: boolean);
    function      GetPageSize: Integer;
    procedure     SetPageSize(const Value: Integer);
    function      GetDerefAliases: Integer;
    procedure     SetDerefAliases(const Value: Integer);
    function      GetReferrals: boolean;
    procedure     SetReferrals(const Value: boolean);
    function      GetReferralHops: Integer;
    procedure     SetReferralHops(const Value: Integer);
    function      GetOperationalAttributes: string;
    procedure     SetOperationalAttributes(const Value: string);
    procedure     ReadCredentials; virtual;
    procedure     WriteCredentials; virtual;
  public
    constructor   Create(AStorage: TConfigStorage; const ARootPath: string); override;
    destructor    Destroy; override;
    procedure     Assign(const Source: TAccount);
    property      Name: string read GetName write SetName;
    property      SSL: boolean read GetSSL write SetSSL;
    property      TLS: boolean read GetTLS write SetTLS;
    property      Port: integer read GetPort write SetPort;
    property      LdapVersion: integer read GetLdapVersion write SetLdapVersion;
    property      User: string read GetUser write SetUser;
    property      Server: string read GetServer write SetServer;
    property      Base: string read GetBase write SetBase;
    property      Password: string read GetPassword write SetPassword;
    property      TimeLimit: Integer read GetTimeLimit write SetTimeLimit;
    property      SizeLimit: Integer read GetSizeLimit write SetSizeLimit;
    property      PagedSearch: Boolean read GetPagedSearch write SetPagedSearch;
    property      PageSize: Integer read GetPageSize write SetPageSize;
    property      DereferenceAliases: Integer read GetDerefAliases write SetDerefAliases;
    property      ChaseReferrals: Boolean read GetReferrals write SetReferrals;
    property      ReferralHops: Integer read GetReferralHops write SetReferralHops;
    property      OperationalAttrs: string read GetOperationalAttributes write SetOperationalAttributes;
    property      AuthMethod: TLdapAuthMethod read GetAuthMethod write SetAuthMethod;
  end;

  TFakeAccount=class(TAccount)
  private
    FBase:        string;
    FPort:        integer;
    FServer:      string;
    FUser:        string;
    FSSL:         boolean;
    FLdapVersion: integer;
    FAuthMethod:  TLdapAuthMethod;
  protected
    procedure     SetBase(const Value: string); override;
    procedure     SetPort(const Value: integer); override;
    procedure     SetServer(const Value: string); override;
    procedure     SetUser(const Value: string); override;
    procedure     SetSSL(const Value: boolean); override;
    procedure     SetLdapVersion(const Value: integer); override;
    procedure     SetAuthMethod(const Value: TLdapAuthMethod); override;
    function      GetAuthMethod: TLdapAuthMethod; override;
    function      GetBase: string; override;
    function      GetLdapVersion: integer; override;
    function      GetPort: integer; override;
    function      GetServer: string; override;
    function      GetUser: string; override;
    function      GetSSL: boolean; override;
  end;

  TGlobalConfig=class(TConfig)
  private
    FStorages:    TObjectList;
    function      GetStorages(Index: integer): TConfigStorage;
    function      GetStoragesCount: integer;
  public
    constructor   Create(const AStorage: TConfigStorage); reintroduce;
    destructor    Destroy; override;
    procedure     CheckProtocol;
    property      StoragesCount: integer read GetStoragesCount;
    property      Storages[Index: integer]: TConfigStorage read GetStorages;
    function      AddStorage(AStorage: TConfigStorage): integer;
    procedure     DeleteStorage(Index: integer);
    function      StorageByName(const Name: string): TConfigStorage;
  end;

  TConfigStorage=class
  private
    FAccounts:    TObjectList;
    FChanged:     boolean;
    function      GetAccountsCount: integer;
    function      GetAccounts(Index: integer): TAccount;
    function      GetChanged: boolean;
  protected
    function      Norm(Ident: string): string; virtual;
    function      GetName: string; virtual; abstract;
    procedure     LoadAccounts; virtual;

    function      ValueExist(const Ident: string): boolean; virtual; abstract;

    procedure     Copy(Parent, SrcName, DestName: string); virtual; abstract;
    procedure     SetAccountName(Parent, OldName, NewName: string); virtual; abstract;
    procedure     GetKeyNames(Parent: string; var Result: TStrings); virtual; abstract;
    procedure     GetValueNames(Parent: string; var Result: TStrings); virtual; abstract;
    procedure     Delete(Ident: string); virtual; abstract;

    function      ReadString(Ident: string; Default: string): string; virtual; abstract;
    procedure     WriteString(Ident: string; Value: string); virtual; abstract;

    function      ReadInteger(Ident: string; Default: integer): integer; virtual; abstract;
    procedure     WriteInteger(Ident: string; Value: integer); virtual; abstract;

    function      ReadBool(Ident: string; Default: boolean): boolean; virtual; abstract;
    procedure     WriteBool(Ident: string; Value: boolean); virtual; abstract;

    function      GetDataSize(Ident: string): Integer; virtual; abstract;
    function      ReadBinaryData(Ident:  string; var Buffer; BufSize: Integer): Integer; virtual; abstract;
    procedure     WriteBinaryData(Ident: string; var Buffer; BufSize: Integer); virtual; abstract;
  public
    constructor   Create; reintroduce; virtual;
    destructor    Destroy; override;
    property      Accounts[Index: integer]: TAccount read GetAccounts;
    property      AccountsCount: integer read GetAccountsCount;
    function      AddAccount(Name: string): TAccount;
    procedure     DeleteAccount(Account: TAccount);
    property      Name: string read GetName;
    property      Changed: boolean read GetChanged;
    function      AccountByName(Name: string): TAccount;
    function      PasswordCanSave: boolean; virtual;
  end;

  TRegistryConfigStorage=class(TConfigStorage)
  private
    FRegistry:    TRegistry;
    FRootPath:    string;
    function      GetKeyName(Ident: string): string;
    function      GetValName(Ident: string): string;
  protected
    function      GetName: string; override;
    procedure     Copy(Parent, SrcName, DestName: string); override;
    procedure     SetAccountName(Parent, OldName, NewName: string); override;
    procedure     GetKeyNames(Parent: string; var Result: TStrings); override;
    procedure     GetValueNames(Parent: string; var Result: TStrings); override;
    procedure     Delete(Ident: string); override;
    function      ValueExist(const Ident: string): boolean; override;

    function      ReadString(Ident: string; Default: string): string; override;
    procedure     WriteString(Ident: string; Value: string); override;

    function      ReadInteger(Ident: string; Default: integer): integer; override;
    procedure     WriteInteger(Ident: string; Value: integer); override;

    function      ReadBool(Ident: string; Default: boolean): boolean; override;
    procedure     WriteBool(Ident: string; Value: boolean); override;

    function      GetDataSize(Ident: string): Integer; override;
    function      ReadBinaryData(Ident:  string; var Buffer; BufSize: Integer): Integer; override;
    procedure     WriteBinaryData(Ident: string; var Buffer; BufSize: Integer); override;

  public
    constructor   Create(const RootKey: HKEY; const ARootPath: string); reintroduce;
    destructor    Destroy; override;
    function      PasswordCanSave: boolean; override;
  end;

  TXmlConfigStorage=class(TConfigStorage)
  private
    FXml:         TXmlTree;
    FFileName:    string;
    procedure SetFileName(const Value: string);
  protected
    procedure     SetAccountName(Parent, OldName, NewName: string); override;
    function      GetName: string; override;
    procedure     Copy(Parent, SrcName, DestName: string); override;
    procedure     GetKeyNames(Parent: string; var Result: TStrings); override;
    procedure     GetValueNames(Parent: string; var Result: TStrings); override;
    procedure     Delete(Ident: string); override;
    function      ValueExist(const Ident: string): boolean; override;

    function      ReadString(Ident: string; Default: string): string; override;
    procedure     WriteString(Ident: string; Value: string); override;

    function      ReadInteger(Ident: string; Default: integer): integer; override;
    procedure     WriteInteger(Ident: string; Value: integer); override;

    function      ReadBool(Ident: string; Default: boolean): boolean; override;
    procedure     WriteBool(Ident: string; Value: boolean); override;

    function      GetDataSize(Ident: string): Integer; override;
    function      ReadBinaryData(Ident:  string; var Buffer; BufSize: Integer): Integer; override;
    procedure     WriteBinaryData(Ident: string; var Buffer; BufSize: Integer); override;
  public
    constructor   Create(const AFileName: string); reintroduce;
    destructor    Destroy; override;
    property      FileName: string read FFileName write SetFileName;
  end;

var
  GlobalConfig:  TGlobalConfig;

const
  ACCOUNTS_PREFIX              = 'Accounts';
  CONFIG_PREFIX                = 'Config';
  CONNECT_PREFIX               = 'Connection\';
  CONNECT_SERVER               = CONNECT_PREFIX + 'Server';
  CONNECT_BASE                 = CONNECT_PREFIX + 'Base';
  CONNECT_CREDIT               = CONNECT_PREFIX + 'Credentials';
  CONNECT_PORT                 = CONNECT_PREFIX + 'Port';
  CONNECT_VERSION              = CONNECT_PREFIX + 'Version';
  CONNECT_SSL                  = CONNECT_PREFIX + 'SSL';
  CONNECT_TLS                  = CONNECT_PREFIX + 'TLS';
  CONNECT_AUTH_METHOD          = CONNECT_PREFIX + 'AuthMethod';
  CONNECT_TIME_LIMIT           = CONNECT_PREFIX + 'TimeLimit';
  CONNECT_SIZE_LIMIT           = CONNECT_PREFIX + 'SizeLimit';
  CONNECT_PAGED_SEARCH         = CONNECT_PREFIX + 'PagedSearch';
  CONNECT_PAGE_SIZE            = CONNECT_PREFIX + 'PageSize';
  CONNECT_DEREF_ALIASES        = CONNECT_PREFIX + 'DereferenceAliases';
  CONNECT_CHASE_REFFERALS      = CONNECT_PREFIX + 'ChaseReferrals';
  CONNECT_REFFERAL_HOPS        = CONNECT_PREFIX + 'ReferralHops';
  CONNECT_OPERATIONAL_ATTRS    = CONNECT_PREFIX + 'OperationalAttributes';


  LAC_ROOTNAME                 = 'LDAPAccounts';

  cfAnsiStrings                = $0000;
  cfUnicodeStrings             = $0001;

procedure RegProtocol(Ext: string);

implementation

{$I LdapAdmin.inc}

uses
{$IFnDEF FPC}
  ComObj,
{$ELSE}
{$ENDIF}
  Constant, {$ifdef mswindows}WinLDAP,{$else} LinLDAP,{$endif}Dialogs, Forms, StdCtrls, Controls, WinBase64,
  Math {$IFDEF VER_XEH}, System.Types{$ENDIF};

function CheckProto(Ext: string): boolean;
var
  Reg:  TRegistry;
begin
  Reg:=TRegistry.Create;

  try
    Reg.RootKey := HKEY_CLASSES_ROOT;
    Reg.OpenKey('\'+Ext+'\Shell\Open\Command',True);
    //result:=(Reg.ReadString('')<> ParamStr(0)+' %1');
    result:=(ExtractFileName(Reg.ReadString(''))<> ExtractFileName(ParamStr(0))+' %1');
    Reg.CloseKey;
  finally
    Reg.Free;
  end;
end;

procedure RegProtocol(Ext: string);
var
  Reg:  TRegistry;
  Win32MajorVersion: integer;
begin
  Win32MajorVersion:=5 ;
  ext:='\'+Ext;
  Reg:=TRegistry.Create;

  try
    Reg.RootKey := HKEY_CLASSES_ROOT;

    Reg.OpenKey(ext,True);
    Reg.WriteString('', 'URL:LDAP Protocol');
    Reg.WriteString('URL Protocol','');
    Reg.CloseKey;

    Reg.OpenKey(ext+'\Shell\Open\Command',True);
    Reg.WriteString('',ParamStr(0)+' %1');
    Reg.CloseKey;

    Reg.DeleteKey(ext+'\Shell\Open\ddeexec');

    Reg.OpenKey(ext+'\DefaultIcon',True);
    Reg.WriteString('',ParamStr(0)+',1');
    Reg.CloseKey;
    Reg.Free;
  except
    Reg.Free;
    if Win32MajorVersion > 5 then
      raise Exception.Create(stNeedElevated)
    else
      raise;
  end;
end;

{ TConfig }

constructor TConfig.Create(AStorage: TConfigStorage; const ARootPath: string);
begin
  inherited Create;
  FStorage:=AStorage;
  FRootPath:=Norm(ARootPath);
  FChanged:=false;
end;

destructor TConfig.Destroy;
begin
  inherited;
end;

function TConfig.Norm(Ident: string): string;
begin
  if (length(Ident)>0) and (Ident[1]<>'\') then result:='\'+ExcludeTrailingBackslash(Ident)
  else result:=ExcludeTrailingBackslash(Ident)
end;

procedure TConfig.Delete(const Ident: string);
begin
  if FStorage<>nil then FStorage.Delete(FRootPath+Norm(Ident));
  FChanged:=true;
end;

function TConfig.ReadString(const Ident, Default: string): string;
begin
  result:=default;
  if FStorage<>nil then result:=FStorage.ReadString(FRootPath+Norm(Ident), Default)
end;

procedure TConfig.WriteString(const Ident, Value: string);
begin
  if FStorage<>nil then FStorage.WriteString(FRootPath+Norm(Ident), Value);
  FChanged:=true;
end;

function TConfig.ReadInteger(const Ident: string; const Default: integer): integer;
begin
  result:=default;
  if FStorage<>nil then result:=FStorage.ReadInteger(FRootPath+Norm(Ident), Default)
end;

procedure TConfig.WriteInteger(const Ident: string; const Value: integer);
begin
  if FStorage<>nil then FStorage.WriteInteger(FRootPath+Norm(Ident), Value);
  FChanged:=true;
end;

function TConfig.ReadBool(const Ident: string;  const Default: boolean): boolean;
begin
  result:=default;
  if FStorage<>nil then result:=FStorage.ReadBool(FRootPath+Norm(Ident), Default)
end;

procedure TConfig.WriteBool(const Ident: string; const Value: boolean);
begin
  if FStorage<>nil then FStorage.WriteBool(FRootPath+Norm(Ident), Value);
  FChanged:=true;
end;

function TConfig.GetDataSize(const Ident: string): Integer;
begin
  result:=0;
  if FStorage<>nil then result:=FStorage.GetDataSize(FRootPath+Norm(Ident));
end;

function TConfig.ReadBinaryData(const Ident: string; var Buffer; BufSize: Integer): Integer;
begin
  if FStorage=nil then result:=0
  else result:=FStorage.ReadBinaryData(FRootPath+Norm(Ident), Buffer, BufSize);
end;

procedure TConfig.WriteBinaryData(const Ident: string; var Buffer; BufSize: Integer);
begin
  if FStorage<>nil then FStorage.WriteBinaryData(FRootPath+Norm(Ident), Buffer, BufSize);
  FChanged:=true;
end;

function TConfig.ValueExist(const Ident: string): boolean;
begin
  if FStorage=nil then result:=false
  else result:=FStorage.ValueExist(FRootPath+Norm(Ident));
end;

procedure TConfig.GetKeyNames(Parent: string; var Result: TStrings);
begin
  if FStorage<>nil then FStorage.GetKeyNames(FRootPath+Norm(Parent), Result);
end;

procedure TConfig.GetValueNames(Parent: string; var Result: TStrings);
begin
  if FStorage<>nil then FStorage.GetValueNames(FRootPath+Norm(Parent), Result);
end;

{ TGlobalConfig }

constructor TGlobalConfig.Create(const AStorage: TConfigStorage);
var
  strs: TStrings;
  i: integer;
  stor: TXmlConfigStorage;
begin
  inherited Create(AStorage, CONFIG_PREFIX);
  FStorages:=TObjectList.Create;
  AddStorage(AStorage);

  strs:=TStringList.Create;
  strs.CommaText:=ReadString(rAccountFiles, '');
  for i:=0 to Strs.Count-1 do begin
 //   if not FileExists(strs[i]) then continue;
    stor:=nil;
    try
      stor:=TXmlConfigStorage.Create(strs[i]);
      AddStorage(stor)
    except
      on E: Exception do begin
        stor.Free;
        //MessageBox(application.Handle, pchar(E.Message), pchar(Application.Title), MB_OK+MB_ICONERROR);
        Application.MessageBox(pchar(E.Message), pchar(Application.Title), MB_OK+MB_ICONERROR);
      end;
     end;
  end;
  strs.Free;
end;

destructor TGlobalConfig.Destroy;
var
  strs: TStrings;
  i: integer;
begin
  strs:=TStringList.Create;
  for i:=1 to FStorages.Count-1 do begin
    if Storages[i] is TXmlConfigStorage then strs.Add(TXmlConfigStorage(Storages[i]).FileName);
  end;
  WriteString(rAccountFiles, strs.CommaText);
  strs.Free;
  FStorages.Free;
  inherited;
end;

procedure TGlobalConfig.CheckProtocol;
var
  Form: TForm;
  i: integer;
  NoCheckCbx: TCheckBox;
begin
  {$ifdef mswindows}
  if (not ReadBool(rDontCheckProto)) and ( CheckProto('LDAP') or CheckProto('LDAPS')) then
  {$else}
  if (not ReadBool(rDontCheckProto))  then
  {$endif}
  begin
    Form:=CreateMessageDialog(stExtConfirmAssoc,mtConfirmation, [mbYes, mbNo]);

    NoCheckCbx:=TCheckBox.Create(Form);
    NoCheckCbx.Parent:=Form;
    NoCheckCbx.Caption:=stNoMoreChecks;
    //NoCheckCbx.Width:=200;
    NoCheckCbx.Width:=NoCheckCbx.Parent.Width - NoCheckCbx.Left;
    {$ifdef mswindows}
    for i:=0 to Form.ComponentCount-1 do
    begin
      if Form.Components[i] is TLabel then
      begin
        TLabel(Form.Components[i]).Top:=16;
        NoCheckCbx.Top:=TLabel(Form.Components[i]).Top+TLabel(Form.Components[i]).Height+16;
        NoCheckCbx.Left:=TLabel(Form.Components[i]).Left;
      end;
    end;
    {$endif}

    for i:=0 to Form.ComponentCount-1 do
    begin
      if Form.Components[i] is TButton then
      begin
        TButton(Form.Components[i]).Top:=NoCheckCbx.Top+NoCheckCbx.Height+24;
        Form.ClientHeight:=TButton(Form.Components[i]).Top+TButton(Form.Components[i]).Height+16;
      end;
    end;

    if Form.ShowModal=mrYes then
    begin
      {$ifdef mswindows}
      RegProtocol('LDAP');
      RegProtocol('LDAPS');
      {$endif}
    end;

    WriteBool(rDontCheckProto, NoCheckCbx.Checked);
    Form.Free;
  end;
end;

function TGlobalConfig.GetStorages(Index: integer): TConfigStorage;
begin
  result:=TConfigStorage(FStorages[Index]);
end;

function TGlobalConfig.GetStoragesCount: integer;
begin
  result:=FStorages.Count;
end;

function TGlobalConfig.AddStorage(AStorage: TConfigStorage): integer;
begin
  result:=FStorages.Add(AStorage);
end;

procedure TGlobalConfig.DeleteStorage(Index: integer);
begin
  FStorages.Delete(Index);
end;

function TGlobalConfig.StorageByName(const Name: string): TConfigStorage;
var
  i: Integer;
begin
  for i := FStorages.Count - 1 downto 0 do
    if AnsiCompareText(Name, TConfigStorage(FStorages[i]).Name) = 0 then
    begin
      Result := TConfigStorage(FStorages[i]);
      Exit;
    end;
  Result := nil;
end;

{ TAccount }

constructor TAccount.Create(AStorage: TConfigStorage; const ARootPath: string);
begin
  if ARootPath='' then raise Exception.Create(stAccntNameReq);
  inherited;
  FUser:='';
  FPassword:='';
end;

destructor TAccount.Destroy;
begin
  inherited;
end;

function TAccount.GetBase: string;
begin
 result:=ReadString(CONNECT_BASE, '');
end;

procedure TAccount.SetBase(const Value: string);
begin
  WriteString(CONNECT_BASE, Value);
end;

function TAccount.GetServer: string;
begin
  result:=ReadString(CONNECT_SERVER, '');
end;

procedure TAccount.SetServer(const Value: string);
begin
  WriteString(CONNECT_SERVER, Value);
end;

function TAccount.GetPort: integer;
begin
  result:=ReadInteger(CONNECT_PORT, LDAP_PORT);
end;

procedure TAccount.SetPort(const Value: integer);
begin
  WriteInteger(CONNECT_PORT, Value);
end;

function TAccount.GetLdapVersion: integer;
begin
  result:=ReadInteger(CONNECT_VERSION, 0);
  if (result<>LDAP_VERSION2) and (result<>LDAP_VERSION3) then result := LDAP_VERSION3;
end;

procedure TAccount.SetLdapVersion(const Value: integer);
begin
  WriteInteger(CONNECT_VERSION, Value);
end;

function TAccount.GetSSL: boolean;
begin
  result:=ReadBool(CONNECT_SSL, false);
end;

function TAccount.GetTLS: boolean;
begin
  result:=ReadBool(CONNECT_TLS, false);
end;

procedure TAccount.SetSSL(const Value: boolean);
begin
  WriteBool(CONNECT_SSL, Value);
end;

procedure TAccount.SetTLS(const Value: boolean);
begin
  WriteBool(CONNECT_TLS, Value);
end;

procedure TAccount.SetAuthMethod(const Value: TLdapAuthMethod);
begin
  WriteInteger(CONNECT_AUTH_METHOD, Value);
end;

function TAccount.GetAuthMethod: TLdapAuthMethod;
begin
  result:=ReadInteger(CONNECT_AUTH_METHOD, AUTH_SIMPLE);
end;

function TAccount.GetTimeLimit: Integer;
begin
  result:=ReadInteger(CONNECT_TIME_LIMIT, SESS_TIMEOUT);
end;

procedure TAccount.SetTimeLimit(const Value: Integer);
begin
  WriteInteger(CONNECT_TIME_LIMIT, Value);
end;

function TAccount.GetSizeLimit: Integer;
begin
  result:=ReadInteger(CONNECT_SIZE_LIMIT, SESS_SIZE_LIMIT);
end;

procedure TAccount.SetSizeLimit(const Value: Integer);
begin
  WriteInteger(CONNECT_SIZE_LIMIT, Value);
end;

function TAccount.GetPagedSearch: boolean;
begin
  result:=ReadBool(CONNECT_PAGED_SEARCH, true);
end;

procedure TAccount.SetPagedSearch(const Value: boolean);
begin
  WriteBool(CONNECT_PAGED_SEARCH, Value);
end;

function TAccount.GetPageSize: Integer;
begin
  result:=ReadInteger(CONNECT_PAGE_SIZE, SESS_PAGE_SIZE);
end;

procedure TAccount.SetPageSize(const Value: Integer);
begin
  WriteInteger(CONNECT_PAGE_SIZE, Value);
end;

function TAccount.GetDerefAliases: Integer;
begin
  result:=ReadInteger(CONNECT_DEREF_ALIASES, LDAP_DEREF_NEVER);
end;

procedure TAccount.SetDerefAliases(const Value: Integer);
begin
  WriteInteger(CONNECT_DEREF_ALIASES, Value);
end;

function TAccount.GetReferrals: boolean;
begin
  result:=ReadBool(CONNECT_CHASE_REFFERALS, true);
end;

procedure TAccount.SetReferrals(const Value: boolean);
begin
  WriteBool(CONNECT_CHASE_REFFERALS, Value);
end;

function TAccount.GetReferralHops: Integer;
begin
  result:=ReadInteger(CONNECT_REFFERAL_HOPS, SESS_REFF_HOP_LIMIT);
end;

procedure TAccount.SetReferralHops(const Value: Integer);
begin
  WriteInteger(CONNECT_REFFERAL_HOPS, Value);
end;

function TAccount.GetOperationalAttributes: string;
begin
  result:=ReadString(CONNECT_OPERATIONAL_ATTRS, '');
end;

procedure TAccount.SetOperationalAttributes(const Value: string);
begin
  WriteString(CONNECT_OPERATIONAL_ATTRS, Value);
end;

procedure TAccount.ReadCredentials;
{ Format of credentials:
  Flags ........ 4 byte
  User ......... 4 byte strlen*sizeof(char) + String
  Password ..... 4 byte strlen*sizeof(char) + String }
var
  Buffer: array of byte;
  len: Integer;
  Offset: integer;
  Flags: Integer;

  function RdInteger: Integer;
  begin
    result:=integer((@Buffer[Offset])^);
    inc(Offset, SizeOf(Integer));
  end;

  function RdStr: string;
  var
    StrLen: Integer;
  begin
    StrLen := RdInteger;
    if Flags and cfUnicodeStrings <> 0 then
      SetString(Result, PWideChar(@Buffer[Offset]), StrLen div 2)
    else
      SetString(Result, PAnsiChar(@Buffer[Offset]), StrLen);
    inc(Offset, StrLen);
  end;

begin
  if FStorage=nil then exit;
  FUser:='';
  FPassword:='';
  len:=GetDataSize(CONNECT_CREDIT);
  if len=0 then exit;
  setlength(Buffer, len);
  ReadBinaryData(CONNECT_CREDIT, Buffer[0], len);
  Offset:=0;
  Flags := RdInteger; // Read flags
  FUser:=RdStr;       // Read user name
  FPassword:=RdStr;   // Read password
end;

procedure TAccount.WriteCredentials;
{ Format of credentials:
  Flags ........ 4 byte
  User ......... 4 byte strlen*sizeof(char) + String
  Password ..... 4 byte strlen*sizeof(char) + String   }
var
  Buffer: array of byte;
  len: Integer;

  procedure WrInteger(i: Integer);
  begin
    setlength(Buffer, len+SizeOf(i));
    integer((@Buffer[len])^):=i;
    inc(len, SizeOf(i));
  end;

  procedure WrString(s: WideString);
  var
    size: Integer;
  begin
    size := Length(S)*SizeOf(WideChar);
    WrInteger(size);
    setlength(Buffer, len+size);
    System.Move(Pointer(s)^, Buffer[len], size);
    Inc(len, size);
  end;

begin
  if FStorage=nil then exit;
  len:=0;
  setlength(Buffer,0);
  WrInteger(cfUnicodeStrings);  // Write flags
  WrString(FUser);              // Write user name
                                // Write password, if PasswordCanSave
  if FStorage.PasswordCanSave then WrString(FPassword)
  else WrString('');

  WriteBinaryData(CONNECT_CREDIT, Buffer[0], length(Buffer));
end;

function TAccount.GetUser: string;
begin
  ReadCredentials;
  result:=FUser;
end;

procedure TAccount.SetUser(const Value: string);
begin
  FUser:=Value;
  WriteCredentials;
end;


function TAccount.GetPassword: string;
begin
  ReadCredentials;
  result:=FPassword;
end;

procedure TAccount.SetPassword(const Value: string);
begin
  FPassword:=Value;
  WriteCredentials;
end;

function TAccount.GetName: string;
begin
  result:=ExtractFileName(FRootPath)
end;

procedure TAccount.SetName(const Value: string);
begin
  if Value='' then raise Exception.Create(stAccntNameReq);
  if FStorage<>nil then
    FStorage.SetAccountName(ACCOUNTS_PREFIX, Name, Value);

  FChanged:=true;
  FRootPath:=ACCOUNTS_PREFIX+'\'+Value;
end;

procedure TAccount.Assign(const Source: TAccount);
  procedure DoAssign(Path: string);
  var
    Idents: TStrings;
    i, Err, n: integer;
    s: string;
  begin
    Idents:=TStringList.Create;
    Source.GetValueNames(Path, Idents);
    for i:=0 to Idents.Count-1 do begin
      s:=Source.ReadString(Path+Idents[i]);
      // Check value type //////////////////////////////////////////////////////
      Val(S, n, Err);
      if Err=0 then WriteInteger(Path+Idents[i], n)
      else WriteString(Path+Idents[i], s);
      //////////////////////////////////////////////////////////////////////////
    end;

    Source.GetKeyNames(Path, Idents);
    for i:=0 to Idents.Count-1 do DoAssign(Path+Idents[i]+'\');
    Idents.Free;
  end;

begin
  if (FStorage=nil) or (Source=nil) or (Source.Storage=nil) then exit;
  FStorage.Delete(RootPath);
  DoAssign('\');
end;

{ TConfigStorage }

constructor TConfigStorage.Create;
begin
  inherited Create;
  FAccounts:=TObjectList.Create;
  FChanged:=false;
end;

destructor TConfigStorage.Destroy;
begin
  FAccounts.Free;
  inherited;
end;

function TConfigStorage.Norm(Ident: string): string;
begin
  if (length(Ident)>0) and (Ident[1]<>'\') then result:='\'+ExcludeTrailingBackslash(Ident)
  else result:=ExcludeTrailingBackslash(Ident)
end;

procedure TConfigStorage.LoadAccounts;
var
  names: TStrings;
  Account: TAccount;
  i: integer;
begin
  names:=TStringList.Create;
  GetKeyNames(Norm(ACCOUNTS_PREFIX), names);
  for i:=0 to names.Count-1 do begin
    Account:=TAccount.Create(self, ACCOUNTS_PREFIX+'\'+names[i]);
    FAccounts.Add(Account);
  end;
  names.Free;
end;

function TConfigStorage.GetAccountsCount: integer;
begin
  result:=FAccounts.Count;
end;

function TConfigStorage.GetAccounts(Index: integer): TAccount;
begin
  result:=TAccount(FAccounts[Index]);
end;

function TConfigStorage.AddAccount(Name: string): TAccount;
begin
  if Name='' then raise Exception.Create(stAccntNameReq);
  result:=TAccount.Create(self, ACCOUNTS_PREFIX+'\'+Name);
  FAccounts.Add(result);
  FChanged:=true;
end;

procedure TConfigStorage.DeleteAccount(Account: TAccount);
begin
  Delete(Account.RootPath);
  Account.FStorage:=nil;
  FAccounts.Remove(Account);
  FChanged:=true;
end;

function TConfigStorage.GetChanged: boolean;
var
  i: integer;
begin
  result:=FChanged;
  if result then exit;
  for i:=0 to FAccounts.Count-1 do
    if Accounts[i].Changed then begin
      result:=true;
      exit;
    end;
end;

function TConfigStorage.AccountByName(Name: string): TAccount;
var
  i: integer;
begin
  result:=nil;
  for i:=0 to AccountsCount-1 do
    if AnsiCompareText(Accounts[i].Name, Name)=0 then begin
      result:=Accounts[i];
      exit;
    end;
end;

function TConfigStorage.PasswordCanSave: boolean;
begin
  result:=false;
end;

{ TRegistryConfigStorage }

constructor TRegistryConfigStorage.Create(const RootKey: HKEY; const ARootPath: string);
begin
  inherited Create;
  FrootPath:=Norm(ArootPath);

  FRegistry:=TRegistry.Create;
  FRegistry.RootKey := RootKey;

  LoadAccounts;
end;

destructor TRegistryConfigStorage.Destroy;
begin
  FRegistry.Free;
  inherited;
end;

function TRegistryConfigStorage.GetKeyName(Ident: string): string;
begin
  result:=Norm(ExtractFileDir(Ident));
end;

function TRegistryConfigStorage.GetValName(Ident: string): string;
begin
  result:=ExtractFileName(Ident);
end;

procedure TRegistryConfigStorage.Copy(Parent, SrcName, DestName: string);
var
  i: integer;
  s: string;
  Buffer: PByteArray;
begin
  if not FRegistry.OpenKey(FrootPath+Norm(Parent), false) then exit;
  if FRegistry.ValueExists(SrcName) then begin
    case FRegistry.GetDataType(SrcName) of
      rdInteger:      begin
                        i:=FRegistry.ReadInteger(SrcName);
                        FRegistry.WriteInteger(DestName, i);
                      end;
      rdString,
      rdExpandString: begin
                        s:=FRegistry.ReadString(SrcName);
                        FRegistry.WriteString(DestName, s);
                      end;
      rdBinary:       begin
                        i:=FRegistry.GetDataSize(SrcName);
                        GetMem(Buffer, i);
                        FRegistry.ReadBinaryData(SrcName, Buffer^, i);
                        FRegistry.WriteBinaryData(DestName, Buffer^, i);
                        FreeMem(buffer, i);
                      end;
      rdUnknown:  raise Exception.CreateFmt(stUnknownValueType, [Parent, SrcName]);
    end;
  end;
  FRegistry.CloseKey;
  Fregistry.MoveKey(FRootPath+Norm(Parent)+Norm(SrcName), FRootPath+Norm(Parent)+Norm(DestName), false);
end;

procedure TRegistryConfigStorage.SetAccountName(Parent, OldName, NewName: string);
begin
  FRegistry.MoveKey(FrootPath+Norm(Parent)+Norm(OldName), FrootPath+Norm(Parent)+Norm(NewName), true);
end;

procedure TRegistryConfigStorage.Delete(Ident: string);
var
  s, parent, value: string;

  procedure SplitPath(const s: string; out ParentKey, ValueName: string);
  var
    l, i: Integer;
  begin
    i := Length(S);
    l := i;
    while i > 1 do begin
      if S[i - 1] = '\' then
        break;
      dec(i);
    end;
    ParentKey := System.Copy(S, 1, i - 1);
    ValueName := System.Copy(S, i, l - i + 1);
  end;

begin
  s := FRootPath+Norm(Ident);
  { is it key or value? }
  with FRegistry do
    if OpenKey(s, false) then
    begin
      CloseKey;
      DeleteKey(s);
    end
    else begin
      SplitPath(s, parent, value);
      if OpenKey(parent, false) then
      begin
        DeleteValue(value);
        CloseKey;
      end;
  end;
end;

procedure TRegistryConfigStorage.GetKeyNames(Parent: string; var Result: TStrings);
begin
  if not FRegistry.OpenKey(FRootPath+Norm(Parent), false) then exit;
  FRegistry.GetKeyNames(result);
  FRegistry.CloseKey;
end;

procedure TRegistryConfigStorage.GetValueNames(Parent: string; var Result: TStrings);
begin
  if not FRegistry.OpenKey(FRootPath+Norm(Parent), false) then exit;
  FRegistry.GetValueNames(result);
  FRegistry.CloseKey;
end;

////////////////////////////////////////////////////////////////////////////////
function TRegistryConfigStorage.GetDataSize(Ident: string): Integer;
var
  ValName: string;
begin
  result:=0;
  if not FRegistry.OpenKey(FRootPath+GetKeyName(Ident), false) then exit;

  ValName:=GetValName(Ident);
  case FRegistry.GetDataType(ValName) of
    rdString,
    rdExpandString: result:=Base64DecSize(FRegistry.ReadString(ValName));
    rdInteger:      result:=sizeof(integer);
    rdBinary:       result:=FRegistry.GetDataSize(ValName);
  end;
  FRegistry.CloseKey;
end;

function TRegistryConfigStorage.ReadBinaryData(Ident: string; var Buffer; BufSize: Integer): Integer;
var
  ValName, s: string;
begin
  result:=0;
  if BufSize=0 then exit;
  if not FRegistry.OpenKey(FRootPath+GetKeyName(Ident), false) then exit;

  ValName:=GetValName(Ident);
  case FRegistry.GetDataType(ValName) of
    rdString,
    rdExpandString: begin
                      s:=FRegistry.ReadString(ValName);
                      result:=Base64DecSize(s);
                      Base64Decode(s, Buffer);
                    end;
    rdInteger:      begin
                      result:=sizeof(integer);
                      integer(Buffer):=FRegistry.ReadInteger(ValName);
                    end;
    rdBinary:       result:=FRegistry.ReadBinaryData(ValName, Buffer, BufSize);
  end;
  FRegistry.CloseKey;
end;

procedure TRegistryConfigStorage.WriteBinaryData(Ident: string; var Buffer; BufSize: Integer);
begin
  FRegistry.OpenKey(FRootPath+GetKeyName(Ident), true);
  FRegistry.WriteBinaryData(GetValName(Ident), Buffer, BufSize);
  FRegistry.CloseKey;
end;
////////////////////////////////////////////////////////////////////////////////

function TRegistryConfigStorage.ReadBool(Ident: string; Default: boolean): boolean;
var
  ValName: string;
  BufLen: integer;
  Buffer: PByteArray;
begin
  result:=Default;
  if not FRegistry.OpenKey(FRootPath+GetKeyName(Ident), false) then exit;

  ValName:=GetValName(Ident);
  case FRegistry.GetDataType(ValName) of
    rdString,
    rdExpandString: result:=(UpperCase(FRegistry.ReadString(ValName))='TRUE') or
                            (FRegistry.ReadString(ValName)='1');
    rdInteger:      result:=FRegistry.ReadInteger(ValName)>0;
    rdBinary:       begin
                      BufLen:=FRegistry.GetDataSize(ValName);
                      GetMem(Buffer, BufLen);
                      try
                        FRegistry.ReadBinaryData(ValName, Buffer^, BufLen);
                        result:=integer((@Buffer[0])^)>0
                      finally
                        FreeMem(buffer, BufLen);
                      end;
                    end;
  end;
  FRegistry.CloseKey;
end;

procedure TRegistryConfigStorage.WriteBool(Ident: string; Value: boolean);
begin
  FRegistry.OpenKey(FRootPath+GetKeyName(Ident), true);
  FRegistry.WriteBool(GetValName(Ident), Value);
  FRegistry.CloseKey;
end;
////////////////////////////////////////////////////////////////////////////////

function TRegistryConfigStorage.ReadInteger(Ident: string; Default: integer): integer;
var
  ValName: string;
  BufLen: integer;
  Buffer: PByteArray;
begin
  result:=Default;
  if not FRegistry.OpenKey(FRootPath+GetKeyName(Ident), false) then exit;

  ValName:=GetValName(Ident);
  case FRegistry.GetDataType(ValName) of
    rdString,
    rdExpandString: result:=StrToIntDef(FRegistry.ReadString(ValName), Default);
    rdInteger:      result:=FRegistry.ReadInteger(ValName);
    rdBinary:       begin
                      BufLen:=FRegistry.GetDataSize(ValName);
                      GetMem(Buffer, BufLen);
                      try
                        FRegistry.ReadBinaryData(ValName, Buffer^, BufLen);
                        result:=integer((@Buffer[0])^);
                      finally
                        FreeMem(buffer, BufLen);
                      end;
                    end;
  end;
  FRegistry.CloseKey;
end;

procedure TRegistryConfigStorage.WriteInteger(Ident: string; Value: integer);
begin
  FRegistry.OpenKey(FRootPath+GetKeyName(Ident), true);
  FRegistry.WriteInteger(GetValName(Ident), Value);
  FRegistry.CloseKey;
end;
////////////////////////////////////////////////////////////////////////////////

function TRegistryConfigStorage.ReadString(Ident: string; Default: string): string;
var
  ValName: string;
  BufLen: integer;
  Buffer: PByteArray;
begin
  result:=Default;
  if not FRegistry.OpenKey(FRootPath+GetKeyName(Ident), false) then exit;

  ValName:=GetValName(Ident);
  case FRegistry.GetDataType(ValName) of
    rdString,
    rdExpandString: result:=FRegistry.ReadString(ValName);
    rdInteger:      result:=inttostr(FRegistry.ReadInteger(ValName));
    rdBinary:       begin
                      BufLen:=FRegistry.GetDataSize(ValName);
                      GetMem(Buffer, BufLen);
                      try
                        FRegistry.ReadBinaryData(ValName, Buffer^, BufLen);
                        result:=Base64Encode(Buffer^, BufLen);
                      finally
                        FreeMem(buffer, BufLen);
                      end;
                    end;
  end;
  FRegistry.CloseKey;
end;

procedure TRegistryConfigStorage.WriteString(Ident: string; Value: string);
begin
  FRegistry.OpenKey(FRootPath+GetKeyName(Ident), true);
  FRegistry.WriteString(GetValName(Ident), Value);
  FRegistry.CloseKey;
end;
////////////////////////////////////////////////////////////////////////////////

function TRegistryConfigStorage.GetName: string;
begin
  result:=cRegistryCfgName;
end;

function TRegistryConfigStorage.PasswordCanSave: boolean;
begin
  result:=true;
end;

function TRegistryConfigStorage.ValueExist(const Ident: string): boolean;
begin
  FRegistry.OpenKey(FRootPath+GetKeyName(Ident), true);
  result:=FRegistry.ValueExists(GetValName(Ident));
  FRegistry.CloseKey;
end;


{ TXmlConfigStorage }

constructor TXmlConfigStorage.Create(const AFileName: string);
begin
  inherited Create;
  FFileName:=AFileName;
  FXml:=TXmlTree.Create;
  FXml.CaseSensitive:=false;
  if FileExistsUTF8(AFileName) { *Converted from FileExists* } then begin
    try
      FXml.LoadFromFile(FFileName);
      if FXml.Root.Name<>LAC_ROOTNAME then raise Exception.Create(format(LAC_NOTLAC, [FFileName]));
      LoadAccounts;
    except
      on E: Exception do
        raise Exception.Create(format(E.Message, [FFileName]));
    end
  end
  else begin
    FXml.Root.Name:=LAC_ROOTNAME;
  end;
end;

destructor TXmlConfigStorage.Destroy;
begin
  if Changed then FXml.SaveToFile(FFileName);
  FXml.Free;
  inherited;
end;

procedure TXmlConfigStorage.Copy(Parent, SrcName, DestName: string);
  procedure CopyNode(Src, Dest: TXmlNode);
  var
    i: integer;
  begin
    Dest.Content:=Src.Content;
    for i:=0 to Src.Count-1 do
      CopyNode(Src[i], Dest.Add(Src[i].Name));
  end;

begin
  if not FXml.Exist(Norm(Parent)+inherited Norm(SrcName)) then exit;
  CopyNode(FXml.ByPath(Norm(Parent)+inherited Norm(SrcName)), FXml.ByPath(Norm(Parent)).Add(DestName));
end;

procedure TXmlConfigStorage.Delete(Ident: string);
var
  i: integer;
  Node: TXmlNode;
begin
  if not FXml.Exist(Norm(ExtractFileDir(Ident))) then exit;
  Node:=FXml.ByPath(Norm(ExtractFileDir(Ident)));
  for i:=Node.Count-1 downto 0 do begin
    if Node[i].Name= AnsiLowerCase(ExtractFileName(Ident)) then Node.Delete(i);
  end;
  FChanged:=true;
end;

function TXmlConfigStorage.GetDataSize(Ident: string): Integer;
begin
  if FXml.Exist(Norm(Ident)) then result:=Base64decSize(FXml.ByPath(Norm(Ident)).Content)
  else result:=0;
end;

function TXmlConfigStorage.ReadBinaryData(Ident: string; var Buffer; BufSize: Integer): Integer;
var
  s: string;
begin
  result:=0;
  if FXml.Exist(Norm(Ident)) then begin
    s:=FXml.ByPath(Norm(Ident)).Content;
    result:=Base64Decode(s, Buffer);
  end;
end;

procedure TXmlConfigStorage.WriteBinaryData(Ident: string; var Buffer; BufSize: Integer);
begin
  FXml.ByPath(Norm(Ident)).Content:=Base64Encode(Buffer, BufSize);
end;


function TXmlConfigStorage.ReadBool(Ident: string; Default: boolean): boolean;
var
  s: string;
begin
  s:=trim(LowerCase(ReadString(Ident, '')));
  if s='true' then result:=true
  else if s='false'  then result:=false
  else result:=Default;
end;

procedure TXmlConfigStorage.WriteBool(Ident: string; Value: boolean);
begin
  if Value then WriteString(Ident, 'true')
  else WriteString(Ident, 'false');
end;


function TXmlConfigStorage.ReadInteger(Ident: string; Default: integer): integer;
begin
  result:=StrToIntDef(ReadString(Ident, ''), Default);
end;

procedure TXmlConfigStorage.WriteInteger(Ident: string; Value: integer);
begin
  WriteString(Ident, IntToStr(Value));
end;


function TXmlConfigStorage.ReadString(Ident: string; Default: string): string;
begin
  if FXml.Exist(Norm(Ident)) then result:=FXml.ByPath(Norm(Ident)).Content;
end;

procedure TXmlConfigStorage.WriteString(Ident: string; Value: string);
begin
  FXml.ByPath(Norm(Ident)).Content:=Value;
end;

function TXmlConfigStorage.GetName: string;
begin
  result:=ExtractFileName(FFileName);
end;

procedure TXmlConfigStorage.GetKeyNames(Parent: string; var Result: TStrings);
var
  i: integer;
begin
  if not FXml.Exist(Norm(Parent)) then exit;
  with FXml.ByPath(Norm(Parent)) do begin
    for i:=0 to Count-1 do begin
      if Nodes[i].Count>0 then result.Add(Nodes[i].Name);
    end;
  end;
end;

procedure TXmlConfigStorage.GetValueNames(Parent: string; var Result: TStrings);
var
  i: integer;
begin
  if not FXml.Exist(Norm(Parent)) then exit;
  with FXml.ByPath(Norm(Parent)) do begin
    for i:=0 to Count-1 do begin
      if length(Nodes[i].Content)>0 then result.Add(Nodes[i].Name);
    end;
  end;
end;

procedure TXmlConfigStorage.SetAccountName(Parent, OldName, NewName: string);
begin
  if not FXml.Exist(Norm(Parent)+Norm(OldName)) then exit;
  FXml.ByPath(Norm(Parent)+Norm(OldName)).Name:=NewName;
end;

procedure TXmlConfigStorage.SetFileName(const Value: string);
begin
  FFileName := Value;
  FChanged:=(FXml.Root.Count>0) or FileExistsUTF8(FFileName); { *Converted from FileExists* }
end;

function TXmlConfigStorage.ValueExist(const Ident: string): boolean;
begin
  result:=FXml.Exist(Norm(Ident));
end;


{ TFakeAccount }

function TFakeAccount.GetBase: string;
begin
  result:=FBase;
end;

procedure TFakeAccount.SetBase(const Value: string);
begin
  FBase:=Value;
end;

function TFakeAccount.GetLdapVersion: integer;
begin
  result:=FLdapVersion
end;

procedure TFakeAccount.SetLdapVersion(const Value: integer);
begin
  FLdapVersion:=Value;
end;

procedure TFakeAccount.SetAuthMethod(const Value: TLdapAuthMethod);
begin
  FAuthMethod := Value;
end;

function  TFakeAccount.GetAuthMethod: TLdapAuthMethod;
begin
  REsult := FAuthMethod;
end;

function TFakeAccount.GetPort: integer;
begin
  result:=FPort;
end;

procedure TFakeAccount.SetPort(const Value: integer);
begin
  FPort:=Value;
end;

function TFakeAccount.GetServer: string;
begin
  result:=FServer;
end;

procedure TFakeAccount.SetServer(const Value: string);
begin
  FServer:=Value;
end;

function TFakeAccount.GetSSL: boolean;
begin
  result:=FSSL;
end;

procedure TFakeAccount.SetSSL(const Value: boolean);
begin
  FSSL:=Value;
end;

function TFakeAccount.GetUser: string;
begin
  result:=FUser;
end;

procedure TFakeAccount.SetUser(const Value: string);
begin
  FUser:=Value;
end;


initialization

  GlobalConfig:=TGlobalConfig.Create(TRegistryConfigStorage.Create(HKEY_CURRENT_USER, REG_KEY));

finalization

  GlobalConfig.Free;

end.


