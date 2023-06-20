  {      LDAPAdmin - Postfix.pas
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

unit Postfix;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses Classes, PropertyObject, LDAPClasses, mormot.core.base;

const
    eMaildrop            = 0;
    eMail                = 1;
    eCn                  = 2;
    eMailRoutingAddress  = 3;
    eMember              = 4;
    eDescription         = 5;

  PropAttrNames: array[eMaildrop..eDescription] of RawUtf8 = (
    'maildrop',
    'mail',
    'cn',
    'mailroutingaddress',
    'member',
    'description'
    );

type
  TMailUser = class(TPropertyObject)
  public
    constructor Create(const Entry: TLdapEntry); override;
    procedure Remove; override;
    procedure AddAddress(Address: RawUtf8);
    procedure RemoveAddress(Address: RawUtf8);
    property Maildrop: RawUtf8 index eMaildrop read GetString write SetString;
    property Addresses[Index: Integer]: RawUtf8 index eMail read GetMultiString;
    property AddressCount: Integer index eMail read GetMultiStringCount;
    property AsCommaText: RawUtf8 index eMail read GetCommaText write SetCommaText;
  end;

type
  TMailGroup = class(TPropertyObject)
  public
    constructor Create(const Entry: TLdapEntry); override;
    procedure Remove; override;
    procedure AddMail(const AMail: RawUtf8); virtual;
    procedure RemoveMail(const AMail: RawUtf8); virtual;
    procedure AddMember(const AMember: RawUtf8); virtual;
    procedure RemoveMember(const AMember: RawUtf8); virtual;
    property Cn: RawUtf8 index eCn read GetString write SetString;
    property MailRoutingAddress: RawUtf8 index eMailRoutingAddress read GetString write SetString;
    property Description: RawUtf8 index eDescription read GetString write SetString;
    property Addresses[Index: Integer]: RawUtf8 index eMail read GetMultiString;
    property AddressCount: Integer index eMail read GetMultiStringCount;
    property AddressesAsCommaText: RawUtf8 index eMail read GetCommaText write SetCommaText;
    property Members[Index: Integer]: RawUtf8 index eMember read GetMultiString;
    property MemberCount: Integer index eMember read GetMultiStringCount;
    property MembersAsCommaText: RawUtf8 index eMember read GetCommaText write SetCommaText;
  end;


implementation

uses Sysutils;

{ TMailUser }

procedure TMailUser.AddAddress(Address: RawUtf8);
begin
  AddToMultiString(eMail, Address);
end;

procedure TMailUser.RemoveAddress(Address: RawUtf8);
begin
  RemoveFromMultiString(eMail, Address);
end;

constructor TMailUser.Create(const Entry: TLdapEntry);
begin
  inherited Create(Entry, 'mailUser', @PropAttrNames);
end;

procedure TMailUser.Remove;
begin
  inherited;
  SetProperty(eMail, '');
  Maildrop := '';
end;

{ TMailGroup }

constructor TMailGroup.Create(const Entry: TLdapEntry);
begin
  inherited Create(Entry, 'mailGroup', @PropAttrNames);
end;

procedure TMailGroup.Remove;
begin
  inherited;
  SetProperty(eMail, '');
  SetProperty(eMember, '');
end;

procedure TMailGroup.AddMail(const AMail: RawUtf8);
begin
  AddToMultiString(eMail, AMail);
end;

procedure TMailGroup.RemoveMail(const AMail: RawUtf8);
begin
  RemoveFromMultiString(eMail, AMail);
end;

procedure TMailGroup.AddMember(const AMember: RawUtf8);
begin
  AddToMultiString(eMember, AMember);
end;

procedure TMailGroup.RemoveMember(const AMember: RawUtf8);
begin
  RemoveFromMultiString(eMember, AMember);
end;

end.
