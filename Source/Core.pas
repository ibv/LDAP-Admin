  {      LDAPAdmin - Core.pas
  *      Copyright (C) 2003-2006 Tihomir Karlovic
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

unit Core;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses PropertyObject, LDAPClasses, Classes, mormot.core.base;

const
    eCn                  = 0;
    eUniqueMember        = 1;
    eMember              = 2;
    eDescription         = 3;
    eBusinessCategory    = 4;
    eOrganizationName    = 5;
    eOuName              = 6;
    eOwner               = 7;
    eSeeAlso             = 8;

  PropAttrNames: array[eCn..eSeeAlso] of RawUtf8 = (
    'cn',
    'uniqueMember',
    'member',
    'description',
    'businessCategory',
    'o',
    'ou',
    'owner',
    'seeAlso'
    );

type
  TGroupOfUniqueNames = class(TPropertyObject)
  protected
    function  GetMember(Index: Integer): RawUtf8; virtual;
    function  GetMemberCount: integer; virtual;
  public
    constructor Create(const Entry: TLdapEntry); override;
    procedure AddMember(const AMember: RawUtf8); virtual;
    procedure RemoveMember(const AMember: RawUtf8); virtual;
    procedure New; override;
    property Cn: RawUtf8 index eCn read GetString write SetString;
    property Description: RawUtf8 index eDescription read GetString write SetString;
    property BusinessCategory: RawUtf8 index eBusinessCategory read GetString write SetString;
    property OrganizationName: RawUtf8 index eOrganizationName read GetString write SetString;
    property OuName: RawUtf8 index eOuName read GetString write SetString;
    property Owner: RawUtf8 index eOwner read GetString write SetString;
    property SeeAlso: RawUtf8 index eSeeAlso read GetString write SetString;
    property Members[Index: Integer]: RawUtf8 read GetMember;
    property MembersCount: Integer read GetMemberCount;
  end;

  TGroupOfNames = class(TGroupOfUniqueNames)
  protected
    function GetMember(Index: Integer): RawUtf8; override;
    function GetMemberCount: Integer; override;
  public
    constructor Create(const Entry: TLdapEntry); override;
    procedure AddMember(const AMember: RawUtf8); override;
    procedure RemoveMember(const AMember: RawUtf8); override;
    property Members[Index: Integer]: RawUtf8 read GetMember;
    property MembersCount: Integer read GetMemberCount;
  end;

implementation


{ TGroupOfUniqueNames }

function TGroupOfUniqueNames.GetMember(Index: Integer): RawUtf8;
begin
  Result := GetMultiString(Index, eUniqueMember);
end;

function TGroupOfUniqueNames.GetMemberCount: Integer;
begin
  Result := GetMultiStringCount(eUniqueMember);
end;

constructor TGroupOfUniqueNames.Create(const Entry: TLdapEntry);
begin
  inherited Create(Entry, 'groupOfUniqueNames', @PropAttrNames);
end;

procedure TGroupOfUniqueNames.AddMember(const AMember: RawUtf8);
begin
  AddToMultiString(eUniqueMember, AMember);
end;

procedure TGroupOfUniqueNames.RemoveMember(const AMember: RawUtf8);
begin
  RemoveFromMultiString(eUniqueMember, AMember);
end;

procedure TGroupOfUniqueNames.New;
begin
  inherited;
  AddObjectClass(['top']);
end;

{ TGroupOfNames }

function TGroupOfNames.GetMember(Index: Integer): RawUtf8;
begin
  Result := GetMultiString(Index, eMember);
end;

function TGroupOfNames.GetMemberCount: Integer;
begin
  Result := GetMultiStringCount(eMember);
end;

constructor TGroupOfNames.Create(const Entry: TLdapEntry);
begin
  inherited Create(Entry, 'groupOfNames', @PropAttrNames);
end;

procedure TGroupOfNames.AddMember(const AMember: RawUtf8);
begin
  AddToMultiString(eMember, AMember);
end;

procedure TGroupOfNames.RemoveMember(const AMember: RawUtf8);
begin
  RemoveFromMultiString(eMember, AMember);
end;

end.
