  {      LDAPAdmin - Posix.pas
  *      Copyright (C) 2003-2005 Tihomir Karlovic
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

unit Posix;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses PropertyObject, LDAPClasses, LinLDAP, Classes, mormot.core.base;

const
    eUidNumber           = 0;
    eGidNumber           = 1;
    eUid                 = 2;
    eCn                  = 3;
    eUserPassword        = 4;
    eHomeDirectory       = 5;
    eLoginShell          = 6;
    eGecos               = 7;
    eDescription         = 8;
    eMemberUid           = 9;

  PropAttrNames: array[eUidNumber..eMemberUid] of RawUtf8 = (
    'uidNumber',
    'gidNumber',
    'uid',
    'Cn',
    'userPassword',
    'homeDirectory',
    'loginShell',
    'gecos',
    'description',
    'memberUid'
    );

type
  TPosixAccount = class(TPropertyObject)
  public
    constructor Create(const Entry: TLdapEntry); override;
    procedure New; override;
    property uidNumber: Integer index eUidNumber read GetInt write SetInt;
    property gidNumber: Integer index eGidNumber read GetInt write SetInt;
    property uid: RawUtf8 index eUid read GetString write SetString;
    property Cn: RawUtf8 index eCn read GetString write SetString;
    property UserPassword: RawUtf8 index eUserPassword read GetString write SetString;
    property HomeDirectory: RawUtf8 index eHomeDirectory read GetString write SetString;
    property LoginShell: RawUtf8 index eLoginShell read GetString write SetString;
    property Gecos: RawUtf8 index eGecos read GetString write SetString;
    property Description: RawUtf8 index eDescription read GetString write SetString;
  end;

  TPosixGroup = class(TPropertyObject)
  public
    constructor Create(const Entry: TLdapEntry); override;
    procedure AddMember(const AMember: RawUtf8); virtual;
    procedure RemoveMember(const AMember: RawUtf8); virtual;
    procedure New; override;
    property GidNumber: Integer index eGidNumber read GetInt write SetInt;
    property Cn: RawUtf8 index eCn read GetString write SetString;
    property Description: RawUtf8 index eDescription read GetString write SetString;
    property Members[Index: Integer]: RawUtf8 index eMemberUid read GetMultiString;
    property MembersCount: Integer index eMemberUid read GetMultiStringCount;
  end;

implementation

uses Sysutils, base64, Constant;

constructor TPosixAccount.Create(const Entry: TLdapEntry);
begin
  inherited Create(Entry, 'posixAccount', @PropAttrNames);
end;

procedure TPosixAccount.New;
begin
  inherited;
  AddObjectClass(['top']);
end;

{ TPosixGroup }

constructor TPosixGroup.Create(const Entry: TLdapEntry);
begin
  inherited Create(Entry, 'posixGroup', @PropAttrNames);
end;

procedure TPosixGroup.AddMember(const AMember: RawUtf8);
begin
  AddToMultiString(eMemberUid, AMember);
end;

procedure TPosixGroup.RemoveMember(const AMember: RawUtf8);
begin
  RemoveFromMultiString(eMemberUid, AMember);
end;

procedure TPosixGroup.New;
begin
  inherited;
  AddObjectClass(['top']);
end;

end.
