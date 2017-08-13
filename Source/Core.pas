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

uses PropertyObject, LDAPClasses, {$ifdef mswindows}WinLDAP,{$else} LinLDAP,{$endif}Classes;

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

  PropAttrNames: array[eCn..eSeeAlso] of string = (
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
    function  GetMember(Index: Integer): string; virtual;
    function  GetMemberCount: integer; virtual;
  public
    constructor Create(const Entry: TLdapEntry); override;
    procedure AddMember(const AMember: string); virtual;
    procedure RemoveMember(const AMember: string); virtual;
    procedure New; override;
    property Cn: string index eCn read GetString write SetString;
    property Description: string index eDescription read GetString write SetString;
    property BusinessCategory: string index eBusinessCategory read GetString write SetString;
    property OrganizationName: string index eOrganizationName read GetString write SetString;
    property OuName: string index eOuName read GetString write SetString;
    property Owner: string index eOwner read GetString write SetString;
    property SeeAlso: string index eSeeAlso read GetString write SetString;
    property Members[Index: Integer]: string read GetMember;
    property MembersCount: Integer read GetMemberCount;
  end;

  TGroupOfNames = class(TGroupOfUniqueNames)
  protected
    function GetMember(Index: Integer): string; override;
    function GetMemberCount: Integer; override;
  public
    constructor Create(const Entry: TLdapEntry); override;
    procedure AddMember(const AMember: string); override;
    procedure RemoveMember(const AMember: string); override;
    property Members[Index: Integer]: string read GetMember;
    property MembersCount: Integer read GetMemberCount;
  end;

implementation


{ TGroupOfUniqueNames }

function TGroupOfUniqueNames.GetMember(Index: Integer): string;
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

procedure TGroupOfUniqueNames.AddMember(const AMember: string);
begin
  AddToMultiString(eUniqueMember, AMember);
end;

procedure TGroupOfUniqueNames.RemoveMember(const AMember: string);
begin
  RemoveFromMultiString(eUniqueMember, AMember);
end;

procedure TGroupOfUniqueNames.New;
begin
  inherited;
  AddObjectClass(['top']);
end;

{ TGroupOfNames }

function TGroupOfNames.GetMember(Index: Integer): string;
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

procedure TGroupOfNames.AddMember(const AMember: string);
begin
  AddToMultiString(eMember, AMember);
end;

procedure TGroupOfNames.RemoveMember(const AMember: string);
begin
  RemoveFromMultiString(eMember, AMember);
end;

end.
