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
  *               Encode property        - T.Karlovic 05.11.2016
  *               Folders                - T.Karlovic 21.11.2016
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
     strutils, LCLIntf, LCLType, {LazFileUtils,} Buttons, LCLVersion,
     Registry,
     Classes,  SysUtils, LDAPClasses, Xml,
     TextFile, mormot.core.base;

type
  TDirectoryType = (dtAutodetect, dtPosix, dtActiveDirectory);
  TEnumObjects = (eoAccounts, eoFolders, eoAll);

  TAccountFolder = class;
  TConfigStorage = class;
  TConfig = class;
  TAccount = class;
  TGlobalConfig = class;
  TConfigList = class;
  TConfigStorageObjArray = array of TConfigStorage;
  TAccountFolderObjArray = array of TAccountFolder;
  TAccountObjArray = array of TAccount;

  TCustomConfig = class
  public
    procedure     Delete(const Ident: RawUtf8); virtual; abstract;
    function      ValueExist(const Ident: RawUtf8): boolean; virtual; abstract;
    procedure     GetKeyNames(Parent: RawUtf8; var Result: TStrings); virtual; abstract;
    procedure     GetValueNames(Parent: RawUtf8; var Result: TStrings); virtual; abstract;
    function      ReadString(const Ident: RawUtf8; const Default: RawUtf8=''): RawUtf8; virtual; abstract;
    procedure     WriteString(const Ident: RawUtf8; const Value: RawUtf8); virtual; abstract;
    function      ReadInteger(const Ident: RawUtf8; const Default: integer=0): integer; virtual; abstract;
    procedure     WriteInteger(const Ident: RawUtf8; const Value: integer); virtual; abstract;
    procedure     WriteBool(const Ident: RawUtf8; const Value: boolean); virtual; abstract;
    function      ReadBool(const Ident: RawUtf8; const Default: boolean=false): boolean; virtual; abstract;
    function      GetDataSize(const Ident: RawUtf8): Integer; virtual; abstract;
    function      ReadBinaryData(const Ident:  RawUtf8; var Buffer; BufSize: Integer): Integer; virtual; abstract;
    procedure     WriteBinaryData(const Ident: RawUtf8; var Buffer; BufSize: Integer); virtual; abstract;
  end;

  TConfig = class(TCustomConfig)
  private
    FStorage:     TConfigStorage;
    ///FRootPath:    RawUtf8;
    FName:        RawUtf8;
    FParent:      TObject;
    function      Norm(Ident: RawUtf8): RawUtf8;
  protected
    FChanged:     boolean;
    function      GetPath: RawUtf8; virtual;
    procedure     ValidateName(const Value: RawUtf8); virtual;
    procedure     SetName(const Value: RawUtf8); virtual;
  public
    constructor   Create(AParent: TObject; const AName: RawUtf8); reintroduce; virtual;
    procedure     Delete(const Ident: RawUtf8); override;
    procedure     GetKeyNames(Parent: RawUtf8; var Result: TStrings); override;
    procedure     GetValueNames(Parent: RawUtf8; var Result: TStrings); override;
    function      ValueExist(const Ident: RawUtf8): boolean; override;
    function      ReadString(const Ident: RawUtf8; const Default: RawUtf8=''):RawUtf8; override;
    procedure     WriteString(const Ident: RawUtf8; const Value: RawUtf8); override;
    function      ReadInteger(const Ident: RawUtf8; const Default: integer=0): integer; override;
    procedure     WriteInteger(const Ident: RawUtf8; const Value: integer); override;
    function      ReadBool(const Ident: RawUtf8; const Default: boolean=false): boolean; override;
    procedure     WriteBool(const Ident: RawUtf8; const Value: boolean); override;
    function      GetDataSize(const Ident: RawUtf8): Integer; override;
    function      ReadBinaryData(const Ident:  RawUtf8; var Buffer; BufSize: Integer): Integer; override;
    procedure     WriteBinaryData(const Ident: RawUtf8; var Buffer; BufSize: Integer); override;
    property      Changed: boolean read FChanged;
    property      Storage: TConfigStorage read FStorage;
    property      Parent: TObject read FParent;
    property      Name: RawUtf8 read FName write SetName;
    property      Path: RawUtf8 read GetPath;
  end;

  TAccount=class(TConfig)
  private
    FUser:        RawUtf8;
    FPassword:    RawUtf8;
    procedure     SetBase(const Value: RawUtf8); virtual;
    procedure     SetPassword(const Value: RawUtf8); virtual;
    procedure     SetPort(const Value: RawUtf8); virtual;
    procedure     SetServer(const Value: RawUtf8); virtual;
    procedure     SetUser(const Value: RawUtf8); virtual;
    procedure     SetSSL(const Value: boolean); virtual;
    procedure     SetTLS(const Value: boolean); virtual;
    procedure     SetLdapVersion(const Value: integer); virtual;
    function      GetBase: RawUtf8; virtual;
    function      GetLdapVersion: integer; virtual;
    function      GetPassword: RawUtf8; virtual;
    function      GetPort: RawUtf8; virtual;
    function      GetServer: RawUtf8; virtual;
    function      GetUser: RawUtf8; virtual;
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
    function      GetOperationalAttributes: RawUtf8;
    procedure     SetOperationalAttributes(const Value: RawUtf8);
    procedure     ReadCredentials; virtual;
    procedure     WriteCredentials; virtual;
    function      GetDirectoryType: TDirectoryType;
    procedure     SetDirectoryType(Value: TDirectoryType);
  public
    constructor   Create(AParent: TObject; const AName: RawUtf8); override;
    procedure     Assign(const Source: TAccount);
    property      SSL: boolean read GetSSL write SetSSL;
    property      TLS: boolean read GetTLS write SetTLS;
    property      Port: RawUtf8 read GetPort write SetPort;
    property      LdapVersion: integer read GetLdapVersion write SetLdapVersion;
    property      User: RawUtf8 read GetUser write SetUser;
    property      Server: RawUtf8 read GetServer write SetServer;
    property      Base: RawUtf8 read GetBase write SetBase;
    property      Password: RawUtf8 read GetPassword write SetPassword;
    property      TimeLimit: Integer read GetTimeLimit write SetTimeLimit;
    property      SizeLimit: Integer read GetSizeLimit write SetSizeLimit;
    property      PagedSearch: Boolean read GetPagedSearch write SetPagedSearch;
    property      PageSize: Integer read GetPageSize write SetPageSize;
    property      DereferenceAliases: Integer read GetDerefAliases write SetDerefAliases;
    property      ChaseReferrals: Boolean read GetReferrals write SetReferrals;
    property      ReferralHops: Integer read GetReferralHops write SetReferralHops;
    property      OperationalAttrs: RawUtf8 read GetOperationalAttributes write SetOperationalAttributes;
    property      AuthMethod: TLdapAuthMethod read GetAuthMethod write SetAuthMethod;
    property      DirectoryType: TDirectoryType read GetDirectoryType write SetDirectoryType;
  end;

  TFakeAccount=class(TAccount)
  private
    FBase:        RawUtf8;
    FPort:        RawUtf8;
    FServer:      RawUtf8;
    FUser:        RawUtf8;
    FSSL:         boolean;
    FLdapVersion: integer;
    FAuthMethod:  TLdapAuthMethod;
  protected
    procedure     SetBase(const Value: RawUtf8); override;
    procedure     SetPort(const Value: RawUtf8); override;
    procedure     SetServer(const Value: RawUtf8); override;
    procedure     SetUser(const Value: RawUtf8); override;
    procedure     SetSSL(const Value: boolean); override;
    procedure     SetLdapVersion(const Value: integer); override;
    procedure     SetAuthMethod(const Value: TLdapAuthMethod); override;
    function      GetAuthMethod: TLdapAuthMethod; override;
    function      GetBase: RawUtf8; override;
    function      GetLdapVersion: integer; override;
    function      GetPort: RawUtf8; override;
    function      GetServer: RawUtf8; override;
    function      GetUser: RawUtf8; override;
    function      GetSSL: boolean; override;
  end;

  TGlobalConfig=class(TConfig)
  private
    FStorages:    TConfigStorageObjArray;
  public
    constructor   Create(const AStorage: TConfigStorage); reintroduce;
    destructor    Destroy; override;
    procedure     CheckProtocol;
    function      AddStorage(AStorage: TConfigStorage): integer;
    procedure     DeleteStorage(Index: integer);
    function      StorageByName(const Name: RawUtf8): TConfigStorage;
    property      Storages: TConfigStorageObjArray read FStorages;
  end;

  TAccountFolder = class(TConfig)
  private
    FItems:       TConfigList;
  protected
    function      GetPath: RawUtf8; override;
    procedure     ValidateName(const Value: RawUtf8); override;
    procedure     SetName(const Value: RawUtf8); override;
  public
    constructor   Create(AParent: TObject; const AName: RawUtf8); override;
    destructor    Destroy; override;
    function      RootFolder: Boolean;
    property      Items: TConfigList read FItems;
  end;

  TConfigList = class
  private
    FParent:      TObject;
    FStorage:     TConfigStorage;
    FFolders:     TAccountFolderObjArray;
    FAccounts:    TAccountObjArray;
  public
    constructor   Create(AParent: TObject);
    destructor    Destroy; override;
    function      AddAccount(Name: RawUtf8; CreateNew: Boolean = false): TAccount;
    function      AddFolder(Name: RawUtf8; CreateNew: Boolean = false): TAccountFolder;
    procedure     DeleteItem(Item: TConfig);
    function      AccountByName(Name: RawUtf8): TAccount;
    function      FolderByName(Name: RawUtf8): TAccountFolder;
    function      ByName(Name: RawUtf8; Enum: TEnumObjects): TConfig;
    property      Accounts: TAccountObjArray read FAccounts;
    property      Folders: TAccountFolderObjArray read FFolders;
    property      Storage: TConfigStorage read FStorage;
  end;

  TConfigStorage = class
  private
    FRootFolder:  TAccountFolder;
    FChanged:     Boolean;
    FPwdSave:     Boolean;
    function      GetChanged: boolean;
  protected
    function      Norm(Ident: RawUtf8): RawUtf8; virtual;
    function      GetName: RawUtf8; virtual; abstract;
    procedure     LoadAccounts; virtual;

    function      ValueExist(const Ident: RawUtf8): boolean; virtual; abstract;

    procedure     Copy(Parent, SrcName, DestName: RawUtf8); virtual; abstract;
    procedure     New(Parent, Name: RawUtf8); virtual; abstract;
    procedure     Rename(Path, NewName: RawUtf8); virtual; abstract;
    procedure     GetKeyNames(Parent: RawUtf8; var Result: TStrings); virtual; abstract;
    procedure     GetValueNames(Parent: RawUtf8; var Result: TStrings); virtual; abstract;
    procedure     Delete(Ident: RawUtf8); virtual; abstract;

    function      ReadString(Ident: RawUtf8; Default: RawUtf8): RawUtf8; virtual; abstract;
    procedure     WriteString(Ident: RawUtf8; Value: RawUtf8); virtual; abstract;

    function      ReadInteger(Ident: RawUtf8; Default: integer): integer; virtual; abstract;
    procedure     WriteInteger(Ident: RawUtf8; Value: integer); virtual; abstract;

    function      ReadBool(Ident: RawUtf8; Default: boolean): boolean; virtual; abstract;
    procedure     WriteBool(Ident: RawUtf8; Value: boolean); virtual; abstract;

    function      GetDataSize(Ident: RawUtf8): Integer; virtual; abstract;
    function      ReadBinaryData(Ident:  RawUtf8; var Buffer; BufSize: Integer): Integer; virtual; abstract;
    procedure     WriteBinaryData(Ident: RawUtf8; var Buffer; BufSize: Integer); virtual; abstract;
  public
    constructor   Create; reintroduce; virtual;
    destructor    Destroy; override;
    function      ByPath(APath: RawUtf8; Relative: Boolean = false): TConfig;
    property      RootFolder: TAccountFolder read FRootFolder;
    property      Name: RawUtf8 read GetName;
    property      Changed: boolean read GetChanged;
    property      PasswordCanSave: Boolean read FPwdSave write FPwdSave;
  end;

  TRegistryConfigStorage = class(TConfigStorage)
  private
    FRegistry:    TRegistry;
    FRootPath:    RawUtf8;
    function      GetKeyName(Ident: RawUtf8): RawUtf8;
    function      GetValName(Ident: RawUtf8): RawUtf8;
  protected
    function      GetName: RawUtf8; override;
    procedure     Copy(Parent, SrcName, DestName: RawUtf8); override;
    procedure     New(Parent, Name: RawUtf8); override;
    procedure     Rename(Path, NewName: RawUtf8); override;
    procedure     GetKeyNames(Parent: RawUtf8; var Result: TStrings); override;
    procedure     GetValueNames(Parent: RawUtf8; var Result: TStrings); override;
    procedure     Delete(Ident: RawUtf8); override;
    function      ValueExist(const Ident: RawUtf8): boolean; override;

    function      ReadString(Ident: RawUtf8; Default: RawUtf8): RawUtf8; override;
    procedure     WriteString(Ident: RawUtf8; Value: RawUtf8); override;

    function      ReadInteger(Ident: RawUtf8; Default: integer): integer; override;
    procedure     WriteInteger(Ident: RawUtf8; Value: integer); override;

    function      ReadBool(Ident: RawUtf8; Default: boolean): boolean; override;
    procedure     WriteBool(Ident: RawUtf8; Value: boolean); override;

    function      GetDataSize(Ident: RawUtf8): Integer; override;
    function      ReadBinaryData(Ident:  RawUtf8; var Buffer; BufSize: Integer): Integer; override;
    procedure     WriteBinaryData(Ident: RawUtf8; var Buffer; BufSize: Integer); override;

  public
    constructor   Create(const RootKey: HKEY; const ARootPath: RawUtf8); reintroduce;
    destructor    Destroy; override;
  end;

  TXmlConfigStorage=class(TConfigStorage)
  private
    FXml:         TXmlTree;
    FFileName:    RawUtf8;
    procedure     SetFileName(const Value: RawUtf8);
    function      GetEncoding: TFileEncode;
    procedure     SetEncoding(Value: TFileEncode);
  protected
    procedure     New(Parent, Name: RawUtf8); override;
    procedure     Rename(Path, NewName: RawUtf8); override;
    function      GetName: RawUtf8; override;
    procedure     Copy(Parent, SrcName, DestName: RawUtf8); override;
    procedure     GetKeyNames(Parent: RawUtf8; var Result: TStrings); override;
    procedure     GetValueNames(Parent: RawUtf8; var Result: TStrings); override;
    procedure     Delete(Ident: RawUtf8); override;
    function      ValueExist(const Ident: RawUtf8): boolean; override;

    function      ReadString(Ident: RawUtf8; Default: RawUtf8): RawUtf8; override;
    procedure     WriteString(Ident: RawUtf8; Value: RawUtf8); override;

    function      ReadInteger(Ident: RawUtf8; Default: integer): integer; override;
    procedure     WriteInteger(Ident: RawUtf8; Value: integer); override;

    function      ReadBool(Ident: RawUtf8; Default: boolean): boolean; override;
    procedure     WriteBool(Ident: RawUtf8; Value: boolean); override;

    function      GetDataSize(Ident: RawUtf8): Integer; override;
    function      ReadBinaryData(Ident:  RawUtf8; var Buffer; BufSize: Integer): Integer; override;
    procedure     WriteBinaryData(Ident: RawUtf8; var Buffer; BufSize: Integer); override;
  public
    constructor   Create(const AFileName: RawUtf8); reintroduce;
    destructor    Destroy; override;
    property      FileName: RawUtf8 read FFileName write SetFileName;
    property      Encoding: TFileEncode Read GetEncoding write SetEncoding;
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

  L_FOLDER_CHR                 = '{';
  R_FOLDER_CHR                 = '}';

  cfAnsiStrings                = $0000;
  cfUnicodeStrings             = $0001;

  cXmlTrue                    = '1';
  cXmlFalse                   = '0';

function  GetIndent(o: TObject): Integer;
procedure RegProtocol(Ext: RawUtf8);
function  ConfigGetFolder(Value: TObject): TAccountFolder; inline;

implementation

{$I LdapAdmin.inc}

uses
{$IFnDEF FPC}
  ComObj,
{$ELSE}
{$ENDIF}
base64,
  Constant, LinLDAP, Dialogs, Forms, StdCtrls, Controls,
  mormot.core.text, mormot.core.buffers {$IFDEF VER_XEH}, System.Types{$ENDIF};


function GetIndent(o: TObject): Integer;
const
  cIndent = 15;
begin
  Result := 0;
  while (o is TConfig) do
  begin
    with TConfig(o) do
    if Parent = Storage then
      break;
    inc(Result, cIndent);
    o := TConfig(o).Parent;
  end;
end;


function ConfigIsFolder(AName: RawUtf8): Boolean; inline;
begin
  Result := StartWithExact(AName, L_FOLDER_CHR) and EndWithExact(AName, R_FOLDER_CHR);
end;

function ConfigUnpackFolder(AName: RawUtf8): RawUtf8; inline;
begin
   Result:=ReplaceStr(Aname, L_FOLDER_CHR, '');
   Result:=ReplaceStr(Result,R_FOLDER_CHR,'');
end;

function ConfigPackFolder(AName: RawUtf8): RawUtf8; inline;
begin
  Result := L_FOLDER_CHR + AName + R_FOLDER_CHR;
end;

function ConfigGetFolder(Value: TObject): TAccountFolder; inline;
begin
  if Value is TConfigStorage then
    Result := TConfigStorage(Value).RootFolder
  else
    Result := Value as TAccountFolder;
end;

function CheckProto(Ext: RawUtf8): boolean;
var
  Reg:  TRegistry;
begin
  Reg:=TRegistry.Create;

  try
    Reg.RootKey := HKEY_CLASSES_ROOT;
    Reg.OpenKey('\'+Ext+'\Shell\Open\Command',True);
    result:=(ExtractFileName(Reg.ReadString(''))<> ExtractFileName(ParamStr(0))+' %1');
    Reg.CloseKey;
  finally
    Reg.Free;
  end;
end;

procedure RegProtocol(Ext: RawUtf8);
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

constructor TConfig.Create(AParent: TObject; const AName: RawUtf8);
begin
  ValidateName(AName);

  inherited Create;

  FName := AName;
  FParent := AParent;
  if FParent is TConfigStorage then
    FStorage := TConfigStorage(FParent)
  else
  if FParent is TAccountFolder then
    FStorage := TConfig(FParent).Storage;
end;

function TConfig.GetPath: RawUtf8;
begin
  Result := Name;
  if Parent is TConfig then
    Result := TConfig(Parent).Path + '\' + Result
end;

procedure TConfig.ValidateName(const Value: RawUtf8);
begin
  if Value = '' then raise
     Exception.Create(stAccntNameReq);
end;

procedure TConfig.SetName(const Value: RawUtf8);
begin
  if FName <> Value then
  begin
    ValidateName(Value);
    if FStorage<>nil then
      FStorage.Rename(Path, Value);
    FName := Value;
    FChanged:=true;
  end;
end;

function TConfig.Norm(Ident: RawUtf8): RawUtf8;
begin
  if (length(Ident)>0) and (Ident[1]<>'\') then result:='\'+ExcludeTrailingBackslash(Ident)
  else result:=ExcludeTrailingBackslash(Ident)
end;

procedure TConfig.Delete(const Ident: RawUtf8);
begin
  if FStorage<>nil then FStorage.Delete(Path+Norm(Ident));
  FChanged:=true;
end;

function TConfig.ReadString(const Ident, Default: RawUtf8): RawUtf8;
begin
  result:=default;
  if FStorage<>nil then result:=FStorage.ReadString(Path+Norm(Ident), Default)
end;

procedure TConfig.WriteString(const Ident, Value: RawUtf8);
begin
  if FStorage<>nil then FStorage.WriteString(Path+Norm(Ident), Value);
  FChanged:=true;
end;

function TConfig.ReadInteger(const Ident: RawUtf8; const Default: integer): integer;
begin
  result:=default;
  if FStorage<>nil then result:=FStorage.ReadInteger(Path+Norm(Ident), Default)
end;

procedure TConfig.WriteInteger(const Ident: RawUtf8; const Value: integer);
begin
  if FStorage<>nil then FStorage.WriteInteger(Path+Norm(Ident), Value);
  FChanged:=true;
end;

function TConfig.ReadBool(const Ident: RawUtf8;  const Default: boolean): boolean;
begin
  result:=default;
  if FStorage<>nil then result:=FStorage.ReadBool(Path+Norm(Ident), Default)
end;

procedure TConfig.WriteBool(const Ident: RawUtf8; const Value: boolean);
begin
  if FStorage<>nil then FStorage.WriteBool(Path+Norm(Ident), Value);
  FChanged:=true;
end;

function TConfig.GetDataSize(const Ident: RawUtf8): Integer;
begin
  result:=0;
  if FStorage<>nil then result:=FStorage.GetDataSize(Path+Norm(Ident));
end;

function TConfig.ReadBinaryData(const Ident: RawUtf8; var Buffer; BufSize: Integer): Integer;
begin
  if FStorage=nil then result:=0
  else result:=FStorage.ReadBinaryData(Path+Norm(Ident), Buffer, BufSize);
end;

procedure TConfig.WriteBinaryData(const Ident: RawUtf8; var Buffer; BufSize: Integer);
begin
  if FStorage<>nil then FStorage.WriteBinaryData(Path+Norm(Ident), Buffer, BufSize);
  FChanged:=true;
end;

function TConfig.ValueExist(const Ident: RawUtf8): boolean;
begin
  if FStorage=nil then result:=false
  else result:=FStorage.ValueExist(Path+Norm(Ident));
end;

procedure TConfig.GetKeyNames(Parent: RawUtf8; var Result: TStrings);
begin
  if FStorage<>nil then FStorage.GetKeyNames(Path+Norm(Parent), Result);
end;

procedure TConfig.GetValueNames(Parent: RawUtf8; var Result: TStrings);
begin
  if FStorage<>nil then FStorage.GetValueNames(Path+Norm(Parent), Result);
end;

{ TGlobalConfig }

constructor TGlobalConfig.Create(const AStorage: TConfigStorage);
var
  strs: TStrings;
  i: integer;
  stor: TXmlConfigStorage;
begin
  inherited Create(AStorage, CONFIG_PREFIX);
  FStorages := nil;
  AddStorage(AStorage);

  strs:=TStringList.Create;
  strs.CommaText:=ReadString(rAccountFiles, '');
  for i:=0 to Strs.Count-1 do
  begin
    stor:=nil;
    try
      stor:=TXmlConfigStorage.Create(strs[i]);
      AddStorage(stor)
    except
      on E: Exception do
      begin
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
  for i:=1 to Length(FStorages) - 1 do begin
    if Storages[i] is TXmlConfigStorage then strs.Add(TXmlConfigStorage(Storages[i]).FileName);
  end;
  WriteString(rAccountFiles, strs.CommaText);
  strs.Free;
  inherited;
end;

procedure TGlobalConfig.CheckProtocol;
var
  Form: TForm;
  i: integer;
  NoCheckCbx: TCheckBox;
begin
   if (not ReadBool(rDontCheckProto)) and ( CheckProto('LDAP') or CheckProto('LDAPS')) then
   begin
    Form:=CreateMessageDialog(stExtConfirmAssoc,mtConfirmation, [mbYes, mbNo]);

    NoCheckCbx:=TCheckBox.Create(Form);
    NoCheckCbx.Parent:=Form;
    NoCheckCbx.Caption:=stNoMoreChecks;
    NoCheckCbx.Width:=NoCheckCbx.Parent.Width - NoCheckCbx.Left;
    for i:=0 to Form.ComponentCount-1 do begin
      {$ifdef mswindows}
      if Form.Components[i] is TLabel then begin
        TLabel(Form.Components[i]).Top:=16;
        NoCheckCbx.Top:=TLabel(Form.Components[i]).Top+TLabel(Form.Components[i]).Height+16;
        NoCheckCbx.Left:=TLabel(Form.Components[i]).Left;
      end;
      {$else}
      if Form.Components[i] is TBitBtn then begin
        NoCheckCbx.Top:=Form.Height-(NoCheckCbx.Height+32);
        NoCheckCbx.Left:=46;
      end;
      {$endif}
    end;
    for i:=0 to Form.ComponentCount-1 do begin
    {$ifdef mswindows}
      if Form.Components[i] is TButton then begin
        TButton(Form.Components[i]).Top:=NoCheckCbx.Top+NoCheckCbx.Height+24;
        Form.ClientHeight:=TButton(Form.Components[i]).Top+TButton(Form.Components[i]).Height+16;
      end;
    {$else}
      if Form.Components[i] is TBitBtn then begin
        TBitBtn(Form.Components[i]).Top:=NoCheckCbx.Top+NoCheckCbx.Height+24;
        Form.ClientHeight:=TBitBtn(Form.Components[i]).Top+TBitBtn(Form.Components[i]).Height+16;
      end;
    {$endif}
    end;

    if Form.ShowModal=mrYes then begin
      RegProtocol('LDAP');
      RegProtocol('LDAPS');
    end;

    WriteBool(rDontCheckProto, NoCheckCbx.Checked);
    Form.Free;
  end;
end;

function TGlobalConfig.AddStorage(AStorage: TConfigStorage): integer;
begin
  Result := ObjArrayAdd(FStorages, AStorage);
end;

procedure TGlobalConfig.DeleteStorage(Index: integer);
begin
  ObjArrayDelete(FStorages, Index);
end;

function TGlobalConfig.StorageByName(const Name: RawUtf8): TConfigStorage;
var
  i: Integer;
begin
  for i := Length(FStorages) - 1 downto 0 do
    if AnsiCompareText(Name, TConfigStorage(FStorages[i]).Name) = 0 then
    begin
      Result := TConfigStorage(FStorages[i]);
      Exit;
    end;
  Result := nil;
end;

{ TAccount }

constructor TAccount.Create(AParent: TObject; const AName: RawUtf8);
begin
  if AName = '' then
    raise Exception.Create(stAccntNameReq);

  inherited;
end;

function TAccount.GetBase: RawUtf8;
begin
 result:=ReadString(CONNECT_BASE, '');
end;

procedure TAccount.SetBase(const Value: RawUtf8);
begin
  WriteString(CONNECT_BASE, Value);
end;

function TAccount.GetServer: RawUtf8;
begin
  result:=ReadString(CONNECT_SERVER, '');
end;

procedure TAccount.SetServer(const Value: RawUtf8);
begin
  WriteString(CONNECT_SERVER, Value);
end;

function TAccount.GetPort: RawUtf8;
begin
  result:=ReadString(CONNECT_PORT, LDAP_PORT);
end;

procedure TAccount.SetPort(const Value: RawUtf8);
begin
  WriteString(CONNECT_PORT, Value);
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

function TAccount.GetOperationalAttributes: RawUtf8;
begin
  result:=ReadString(CONNECT_OPERATIONAL_ATTRS, '');
end;

procedure TAccount.SetOperationalAttributes(const Value: RawUtf8);
begin
  WriteString(CONNECT_OPERATIONAL_ATTRS, Value);
end;


procedure TAccount.ReadCredentials;
{ Format of credentials:
  Flags ........ 4 byte
  User ......... 4 byte strlen*sizeof(char) + RawUtf8
  Password ..... 4 byte strlen*sizeof(char) + RawUtf8 }
var
  Buffer: array of byte;
  len,lcver: Integer;
  Offset: integer;
  Flags: Integer;
  st: RawUtf8;
  stBin: RawByteString;
  list: TStringList;



  function RdInteger: Integer;
  begin
    result:=integer((@Buffer[Offset])^);
    inc(Offset, SizeOf(Integer));
  end;

  function RdStr: RawUtf8;
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
  try
    st:= lcl_version;
    st:=StringReplace(st,'.','',[rfReplaceAll]);
    if st<>'' then
      lcver:=StrToInt(st);
  // for Lazarus < 1.7
  ///if (lcl_major >= 1)  and (lcl_minor < 7) then
  if lcver < 1800 then
  begin
    len:=GetDataSize(CONNECT_CREDIT);
    if len=0 then exit;
    setlength(Buffer, len);
    ReadBinaryData(CONNECT_CREDIT, Buffer[0], len);
    Offset:=0;
    Flags := RdInteger; // Read flags
    FUser:=RdStr;       // Read user name
    FPassword:=RdStr;   // Read password
  end
  else
  begin
    st:=ReadString(CONNECT_CREDIT);
    List:=TStringList.Create;
    stBin := Base64ToBin(st);
    if pos('|',stBin) < 0 then
      exit;
    ExtractStrings(['|'], [], PChar(stBin), list);
    if list.Count < 2 then
      exit;
    Flags := StrToInt(list[0]);
    FUser := list[1] ;
    FPassword := list[2];
    List.Free;
  end;
  finally
  end;
end;


procedure TAccount.WriteCredentials;
{ Format of credentials:
  Flags ........ 4 byte
  User ......... 4 byte strlen*sizeof(char) + RawUtf8
  Password ..... 4 byte strlen*sizeof(char) + RawUtf8   }
var
  Buffer: array of byte;
  len,lcver: Integer;
  st : RawUtf8;

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
    // for Lazarus < 1.7
  //if (lcl_major >= 1)  and (lcl_minor < 7) then
  st:= lcl_version;
  st:=StringReplace(st,'.','',[rfReplaceAll]);
  if st<>'' then
    lcver:=StrToInt(st);
  if lcver < 1800 then
  begin
    setlength(Buffer,0);
    WrInteger(cfUnicodeStrings);  // Write flags
    WrString(FUser);              // Write user name
                                // Write password, if PasswordCanSave
    if FStorage.PasswordCanSave then WrString(FPassword)
    else WrString('');

    WriteBinaryData(CONNECT_CREDIT, Buffer[0], length(Buffer));
  end
  else
  begin
    st:=IntToStr(cfUnicodeStrings)+'|'+FUser+'|';
    if FStorage.PasswordCanSave then
      st:=st+FPassword+'|'
    else
      st:=st+'|';

    WriteString(CONNECT_CREDIT, EncodeStringBase64(st));
  end;
end;


function TAccount.GetDirectoryType: TDirectoryType;
begin
  Result := TDirectoryType(ReadInteger(rDirectoryType, Integer(dtAutodetect)));
end;

procedure TAccount.SetDirectoryType(Value: TDirectoryType);
begin
  WriteInteger(rDirectoryType, Integer(Value));
end;

function TAccount.GetUser: RawUtf8;
begin
  ReadCredentials;
  result:=FUser;
end;

procedure TAccount.SetUser(const Value: RawUtf8);
begin
  FUser:=Value;
  WriteCredentials;
end;


function TAccount.GetPassword: RawUtf8;
begin
  ReadCredentials;
  result:=FPassword;
end;

procedure TAccount.SetPassword(const Value: RawUtf8);
begin
  FPassword:=Value;
  WriteCredentials;
end;

procedure TAccount.Assign(const Source: TAccount);
  procedure DoAssign(Path: RawUtf8);
  var
    Idents: TStrings;
    i, Err, n: integer;
    s: RawUtf8;
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
  FStorage.Delete(Path);
  DoAssign('\');
end;

{ TAccountFolder }

constructor TAccountFolder.Create(AParent: TObject; const AName: RawUtf8);
begin
  inherited;
  FItems := TConfigList.Create(Self);
end;

destructor TAccountFolder.Destroy;
begin
  FItems.Free;
  inherited;
end;

function TAccountFolder.RootFolder: Boolean;
begin
  Result := FParent is TConfigStorage;
end;

function TAccountFolder.GetPath: RawUtf8;
begin
  Result := Name;
  if Parent is TConfig then
    Result := TConfig(Parent).Path + '\' + ConfigPackFolder(Result)
end;

procedure TAccountFolder.ValidateName(const Value: RawUtf8);
begin
  if Value = '' then
    raise Exception.Create(stAccntNameReq);
  if PosEx(Value, '\') <> 0 then
    raise Exception.CreateFmt(stInvalidChr, ['\', Value]);
end;

procedure TAccountFolder.SetName(const Value: RawUtf8);
begin
  if FName <> Value then
  begin
    ValidateName(Value);
    if FStorage<>nil then
      FStorage.Rename(Path, ConfigPackFolder(Value));
    FName := Value;
    FChanged:=true;
  end;
end;

{ TConfigList }

{ Although, tehnically, TConfigList is account parent, parent field points to
  the parent of the list, since that is object we are interested in }
function TConfigList.AddAccount(Name: RawUtf8; CreateNew: Boolean = false): TAccount;
begin
  Result := TAccount.Create(FParent, Name);
  if CreateNew then
  begin
    Result.Storage.New(TAccountFolder(FParent).Path, Name);
    FStorage.FChanged := true;
  end;
  ObjArrayAdd(FAccounts, Result);
end;

{ CreateNew - creates a database entry as well (a key) }
function TConfigList.AddFolder(Name: RawUtf8; CreateNew: Boolean = false): TAccountFolder;
begin
  Result := TAccountFolder.Create(FParent, Name);
  if CreateNew then
  begin
    Result.Storage.New(TAccountFolder(FParent).Path, ConfigPackFolder(Name));
    FStorage.FChanged := true;
  end;
  ObjArrayAdd(FFolders, Result);
end;

procedure TConfigList.DeleteItem(Item: TConfig);
var
  AFolder: TAccountFolder;
begin

  FStorage.Delete(Item.Path);
  AFolder := ConfigGetFolder(Item.Parent);
  if Item is TAccount then
    ObjArrayDelete(AFolder.Items.fAccounts, TAccount(Item))
  else
    ObjArrayDelete(AFolder.Items.fFolders, TAccountFolder(Item));
  FStorage.FChanged:=true;
end;

function TConfigList.AccountByName(Name: RawUtf8): TAccount;
var
  i: integer;
  folder: RawUtf8;
begin
  result:=nil;
  folder:='';
  i := Pos('\', Name);
  if i>0 then
  begin
   folder:=Copy(Name, 1, i-1);
   Name  :=Copy(Name, i+1, maxInt);
  end;
  if Folder <>'' then
    result := FolderByName(Folder).FItems.AccountByName(Name)
  else
  for i := 0 to Length(FAccounts) - 1 do
    if AnsiCompareText(Accounts[i].Name, Name)=0 then begin
      Result := Accounts[i];
      exit;
    end;
end;

function TConfigList.FolderByName(Name: RawUtf8): TAccountFolder;
var
  i: integer;
begin
  Result := nil;
  for i := 0 to Length(Folders) - 1 do
    if AnsiSameText(Folders[i].Name, Name) then
    begin
      Result := Folders[i];
      exit;
    end;
end;

function TConfigList.ByName(Name: RawUtf8; Enum: TEnumObjects): TConfig;
begin
  if (Enum = eoAll) or (Enum = eoFolders) then
  begin
    Result := FolderByName(Name);
    if Assigned(Result) then
      exit;
  end;
  if (Enum = eoAll) or (Enum = eoAccounts) then
    Result := AccountByName(Name);
end;

constructor TConfigList.Create(AParent: TObject);
begin
  FFolders := nil;
  FAccounts := nil;
  FParent := AParent;
  FStorage := TConfig(FParent).Storage;
end;

destructor TConfigList.Destroy;
begin
  ObjArrayClear(FFolders);
  ObjArrayClear(FAccounts);
  inherited;
end;

{ TConfigStorage }

constructor TConfigStorage.Create;
begin
  inherited Create;
  FRootFolder := TAccountFolder.Create(Self, ACCOUNTS_PREFIX);
end;

destructor TConfigStorage.Destroy;
begin
  FRootFolder.Free;
  inherited;
end;

function TConfigStorage.Norm(Ident: RawUtf8): RawUtf8;
begin
  if (length(Ident)>0) and (Ident[1]<>'\') then result:='\'+ExcludeTrailingBackslash(Ident)
  else result:=ExcludeTrailingBackslash(Ident)
end;

procedure TConfigStorage.LoadAccounts;

  procedure LoadKey(AFolder: TAccountFolder);
  var
    Names: TStrings;
    i: integer;
  begin
    Names := TStringList.Create;
    GetKeyNames(AFolder.Path, names);

    for i := 0 to Names.Count - 1 do
    begin
      if ConfigIsFolder(Names[i]) then
      begin
        LoadKey(AFolder.Items.AddFolder(ConfigUnpackFolder(Names[i])));
        Continue;
      end;
      AFolder.Items.AddAccount(Names[i]);
    end;
    names.Free;
  end;

begin
  LoadKey(FRootFolder);
end;


function TConfigStorage.GetChanged: boolean;
var
  i: integer;
begin
  Result := FChanged or RootFolder.Changed;
  if Result then
    exit;
  with RootFolder.Items do
  begin
    for i := 0 to Length(Accounts) - 1 do
      if Accounts[i].Changed then
      begin
        Result := true;
        exit;
      end;
    for i := 0 to Length(Folders) - 1 do
      if Folders[i].Changed then
      begin
        Result := true;
        exit;
      end;
  end;
end;

function TConfigStorage.ByPath(APath: RawUtf8; Relative: Boolean = false): TConfig;
var
  i, l, h: Integer;
  Splitted: array of String;
  AFolder: TAccountFolder;
begin
  Result := nil;
  if APath = '' then
    exit;
  if APath[1] = '\' then
    System.Delete(APath, 1, 1);
  if APath = '' then
    exit;
  Splitted := String(APath).Split(['\']);
  h := High(Splitted);
  l := Low(Splitted);
  AFolder := RootFolder;
  if Relative then
    dec(l)
  else begin
    if AFolder.Name <> Splitted[l] then
      exit;
  end;
  Result := AFolder;
  for i := l + 1 to h - 1 do
  begin
    if ConfigIsFolder(Splitted[i]) then
      AFolder := AFolder.Items.FolderByName(ConfigUnpackFolder(Splitted[i]));
    Result := AFolder;
    if not Assigned(Result) then
      exit;
  end;
  if ConfigIsFolder(Splitted[h]) then
    Result := AFolder.Items.FolderByName(ConfigUnpackFolder(Splitted[h]));
end;

{ TRegistryConfigStorage }

constructor TRegistryConfigStorage.Create(const RootKey: HKEY; const ARootPath: RawUtf8);
begin
  inherited Create;
  FPwdSave := true;
  FrootPath := Norm(ArootPath);
  FRegistry := TRegistry.Create;
  FRegistry.RootKey := RootKey;
  LoadAccounts;
end;

destructor TRegistryConfigStorage.Destroy;
begin
  FRegistry.Free;
  inherited;
end;

function TRegistryConfigStorage.GetKeyName(Ident: RawUtf8): RawUtf8;
begin
  result:=Norm(ExtractFileDir(Ident));
end;

function TRegistryConfigStorage.GetValName(Ident: RawUtf8): RawUtf8;
begin
  result:=ExtractFileName(Ident);
end;

procedure TRegistryConfigStorage.Copy(Parent, SrcName, DestName: RawUtf8);
var
  i: integer;
  s: RawUtf8;
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

procedure TRegistryConfigStorage.New(Parent, Name: RawUtf8);
begin
  FRegistry.CreateKey(FrootPath + Norm(Parent) + Norm(Name));
end;

procedure TRegistryConfigStorage.Rename(Path, NewName: RawUtf8);
begin
  FRegistry.MoveKey(FrootPath + Norm(Path), FrootPath + Norm(ExtractFileDir(Path)) + Norm(NewName), true);
end;

procedure TRegistryConfigStorage.Delete(Ident: RawUtf8);
var
  s, parent, value: RawUtf8;

  procedure SplitPath(const s: RawUtf8; out ParentKey, ValueName: RawUtf8);
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

procedure TRegistryConfigStorage.GetKeyNames(Parent: RawUtf8; var Result: TStrings);
begin
  if not FRegistry.OpenKey(FRootPath+Norm(Parent), false) then exit;
  FRegistry.GetKeyNames(result);
  FRegistry.CloseKey;
end;

procedure TRegistryConfigStorage.GetValueNames(Parent: RawUtf8; var Result: TStrings);
begin
  if not FRegistry.OpenKey(FRootPath+Norm(Parent), false) then exit;
  FRegistry.GetValueNames(result);
  FRegistry.CloseKey;
end;

////////////////////////////////////////////////////////////////////////////////
function TRegistryConfigStorage.GetDataSize(Ident: RawUtf8): Integer;
var
  ValName, B64Val: RawUtf8;
begin
  result:=0;
  if not FRegistry.OpenKey(FRootPath+GetKeyName(Ident), false) then exit;

  ValName:=GetValName(Ident);
  case FRegistry.GetDataType(ValName) of
    rdString,
    rdExpandString:
      begin
        B64Val := FRegistry.ReadString(ValName);
        result := Base64ToBinLength(@B64Val[1], Length(B64Val));
      end;
    rdInteger:      result:=sizeof(integer);
    rdBinary:       result:=FRegistry.GetDataSize(ValName);
  end;
  FRegistry.CloseKey;
end;

function TRegistryConfigStorage.ReadBinaryData(Ident: RawUtf8; var Buffer; BufSize: Integer): Integer;
var
  ValName, s: RawUtf8;
begin
  result:=0;
  if BufSize=0 then exit;
  if not FRegistry.OpenKey(FRootPath+GetKeyName(Ident), false) then exit;

  ValName:=GetValName(Ident);
  case FRegistry.GetDataType(ValName) of
    rdString,
    rdExpandString: begin
                      s:=FRegistry.ReadString(ValName);
                      result:= Base64ToBinLength(@s[1], length(s));
                      Base64ToBin(s, PChar(Buffer), BufSize);
                    end;
    rdInteger:      begin
                      result:=sizeof(integer);
                      integer(Buffer):=FRegistry.ReadInteger(ValName);
                    end;
    rdBinary:       result:=FRegistry.ReadBinaryData(ValName, Buffer, BufSize);
  end;
  FRegistry.CloseKey;
end;

procedure TRegistryConfigStorage.WriteBinaryData(Ident: RawUtf8; var Buffer; BufSize: Integer);
begin
  FRegistry.OpenKey(FRootPath+GetKeyName(Ident), true);
  FRegistry.WriteBinaryData(GetValName(Ident), Buffer, BufSize);
  FRegistry.CloseKey;
end;
////////////////////////////////////////////////////////////////////////////////

function TRegistryConfigStorage.ReadBool(Ident: RawUtf8; Default: boolean): boolean;
var
  ValName: RawUtf8;
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

procedure TRegistryConfigStorage.WriteBool(Ident: RawUtf8; Value: boolean);
begin
  FRegistry.OpenKey(FRootPath+GetKeyName(Ident), true);
  FRegistry.WriteBool(GetValName(Ident), Value);
  FRegistry.CloseKey;
end;
////////////////////////////////////////////////////////////////////////////////

function TRegistryConfigStorage.ReadInteger(Ident: RawUtf8; Default: integer): integer;
var
  ValName: RawUtf8;
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

procedure TRegistryConfigStorage.WriteInteger(Ident: RawUtf8; Value: integer);
begin
  FRegistry.OpenKey(FRootPath+GetKeyName(Ident), true);
  FRegistry.WriteInteger(GetValName(Ident), Value);
  FRegistry.CloseKey;
end;
////////////////////////////////////////////////////////////////////////////////

function TRegistryConfigStorage.ReadString(Ident: RawUtf8; Default: RawUtf8): RawUtf8;
var
  ValName: RawUtf8;
  BufLen: integer;
  Buffer: PByteArray;
  s: RawUtf8;
begin
  result:=Default;
  s := FRootPath + GetKeyName(Ident);
  if not FRegistry.OpenKey(s, false) then
    exit;

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
                        result := BinToBase64(PChar(Buffer), BufLen);
                      finally
                        FreeMem(buffer, BufLen);
                      end;
                    end;
  end;
  FRegistry.CloseKey;
end;

procedure TRegistryConfigStorage.WriteString(Ident: RawUtf8; Value: RawUtf8);
begin
  FRegistry.OpenKey(FRootPath+GetKeyName(Ident), true);
  FRegistry.WriteString(GetValName(Ident), Value);
  FRegistry.CloseKey;
end;
////////////////////////////////////////////////////////////////////////////////

function TRegistryConfigStorage.GetName: RawUtf8;
begin
  result:=cRegistryCfgName;
end;

function TRegistryConfigStorage.ValueExist(const Ident: RawUtf8): boolean;
begin
  FRegistry.OpenKey(FRootPath+GetKeyName(Ident), true);
  result:=FRegistry.ValueExists(GetValName(Ident));
  FRegistry.CloseKey;
end;


{ TXmlConfigStorage }

constructor TXmlConfigStorage.Create(const AFileName: RawUtf8);
begin
  inherited Create;
  FFileName := AFileName;
  FXml := TXmlTree.Create;
  FXml.CaseSensitive:=false;
  if FileExists(AFileName) then begin
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

procedure TXmlConfigStorage.Copy(Parent, SrcName, DestName: RawUtf8);
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

procedure TXmlConfigStorage.Delete(Ident: RawUtf8);
var
  i: integer;
  Node: TXmlNode;
begin
  if not FXml.Exist(Norm(ExtractFileDir(Ident))) then exit;
  Node:=FXml.ByPath(Norm(ExtractFileDir(Ident)));
  for i:=Node.Count-1 downto 0 do begin
    if AnsiSameText(Node[i].Name, ExtractFileName(Ident)) then
      Node.Delete(i);
  end;
  FChanged:=true;
end;

function TXmlConfigStorage.GetDataSize(Ident: RawUtf8): Integer;
var
  b64: RawUtf8;
begin
  b64 := FXml.ByPath(Norm(Ident)).Content;
  if FXml.Exist(Norm(Ident)) then
    result:=Base64ToBinLength(@b64[1], length(b64))
  else
    result:=0;
end;

function TXmlConfigStorage.ReadBinaryData(Ident: RawUtf8; var Buffer; BufSize: Integer): Integer;
var
  s: RawUtf8;
begin
  result:=0;
  if FXml.Exist(Norm(Ident)) then begin
    s:=FXml.ByPath(Norm(Ident)).Content;
    result:= Ord(Base64ToBin(s, PChar(Buffer), BufSize));
  end;
end;

procedure TXmlConfigStorage.WriteBinaryData(Ident: RawUtf8; var Buffer; BufSize: Integer);
begin
  FXml.ByPath(Norm(Ident)).Content:=BinToBase64(PChar(Buffer), BufSize);
end;


function TXmlConfigStorage.ReadBool(Ident: RawUtf8; Default: boolean): boolean;
var
  s: RawUtf8;
begin
  s := Trim(LowerCase(ReadString(Ident, '')));
  if s = cXmlTrue then
    Result:=true
  else
    if s = cXmlFalse  then
      Result:=false
  else
    Result := Default;
end;

procedure TXmlConfigStorage.WriteBool(Ident: RawUtf8; Value: boolean);
begin
  if Value then
    WriteString(Ident, cXmlTrue)
  else
    WriteString(Ident, cXmlFalse);
end;


function TXmlConfigStorage.ReadInteger(Ident: RawUtf8; Default: integer): integer;
begin
  result:=StrToIntDef(ReadString(Ident, ''), Default);
end;

procedure TXmlConfigStorage.WriteInteger(Ident: RawUtf8; Value: integer);
begin
  WriteString(Ident, IntToStr(Value));
end;


function TXmlConfigStorage.ReadString(Ident: RawUtf8; Default: RawUtf8): RawUtf8;
begin
  if FXml.Exist(Norm(Ident)) then result:=FXml.ByPath(Norm(Ident)).Content;
end;

procedure TXmlConfigStorage.WriteString(Ident: RawUtf8; Value: RawUtf8);
begin
  FXml.ByPath(Norm(Ident)).Content:=Value;
end;

function TXmlConfigStorage.GetName: RawUtf8;
begin
  result:=ExtractFileName(FFileName);
end;

procedure TXmlConfigStorage.GetKeyNames(Parent: RawUtf8; var Result: TStrings);
var
  i: integer;
begin
  if not FXml.Exist(Norm(Parent)) then exit;
  with FXml.ByPath(Norm(Parent)) do begin
    for i:=0 to Count-1 do begin
      Result.Add(Nodes[i].Name);
    end;
  end;
end;

procedure TXmlConfigStorage.GetValueNames(Parent: RawUtf8; var Result: TStrings);
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

procedure TXmlConfigStorage.New(Parent, Name: RawUtf8);
var
  Splitted: array of String;
  i: Integer;
  ParentNode, Node: TXmlNode;
begin
  if Parent[1] = '\' then
    System.Delete(Parent, 1, 1);
  Splitted := String(Parent).Split(['\']);
  ParentNode := FXml.Root;
  Node := ParentNode;
  for i := Low(Splitted) to High(Splitted) do
  begin
    Node := ParentNode.NodeByName(Splitted[i]);
    if not Assigned(Node) then
      Node := ParentNode.Add(Splitted[i]);
    ParentNode := Node;
  end;
  Node.Add(Name);
end;

procedure TXmlConfigStorage.Rename(Path, NewName: RawUtf8);
begin
  if not FXml.Exist(Norm(Path)) then exit;
  FXml.ByPath(Norm(Path)).Name:=NewName;
end;

procedure TXmlConfigStorage.SetFileName(const Value: RawUtf8);
begin
  FFileName := Value;
  FChanged:=(FXml.Root.Count>0) or FileExists(FFileName);
end;

function TXmlConfigStorage.GetEncoding: TFileEncode;
begin
  Result := FXml.Encoding;
end;

procedure TXmlConfigStorage.SetEncoding(Value: TFileEncode);
begin
  FXml.Encoding := Value;
end;

function TXmlConfigStorage.ValueExist(const Ident: RawUtf8): boolean;
begin
  result:=FXml.Exist(Norm(Ident));
end;


{ TFakeAccount }

function TFakeAccount.GetBase: RawUtf8;
begin
  result:=FBase;
end;

procedure TFakeAccount.SetBase(const Value: RawUtf8);
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

function TFakeAccount.GetPort: RawUtf8;
begin
  result:=FPort;
end;

procedure TFakeAccount.SetPort(const Value: RawUtf8);
begin
  FPort:=Value;
end;

function TFakeAccount.GetServer: RawUtf8;
begin
  result:=FServer;
end;

procedure TFakeAccount.SetServer(const Value: RawUtf8);
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

function TFakeAccount.GetUser: RawUtf8;
begin
  result:=FUser;
end;

procedure TFakeAccount.SetUser(const Value: RawUtf8);
begin
  FUser:=Value;
end;


initialization

  GlobalConfig := TGlobalConfig.Create(TRegistryConfigStorage.Create(HKEY_CURRENT_USER, REG_KEY));


finalization

  GlobalConfig.Free;

end.


