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

uses Classes, PropertyObject, LDAPClasses;

const
    eMaildrop            = 0;
    eMail                = 1;
    eCn                  = 2;
    eMailRoutingAddress  = 3;
    eMember              = 4;
    eDescription         = 5;

  PropAttrNames: array[eMaildrop..eDescription] of string = (
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
    procedure AddAddress(Address: string);
    procedure RemoveAddress(Address: string);
    property Maildrop: string index eMaildrop read GetString write SetString;
    property Addresses[Index: Integer]: string index eMail read GetMultiString;
    property AddressCount: Integer index eMail read GetMultiStringCount;
    property AsCommaText: string index eMail read GetCommaText write SetCommaText;
  end;

type
  TMailGroup = class(TPropertyObject)
  public
    constructor Create(const Entry: TLdapEntry); override;
    procedure Remove; override;
    procedure AddMail(const AMail: string); virtual;
    procedure RemoveMail(const AMail: string); virtual;
    procedure AddMember(const AMember: string); virtual;
    procedure RemoveMember(const AMember: string); virtual;
    property Cn: string index eCn read GetString write SetString;
    property MailRoutingAddress: string index eMailRoutingAddress read GetString write SetString;
    property Description: string index eDescription read GetString write SetString;
    property Addresses[Index: Integer]: string index eMail read GetMultiString;
    property AddressCount: Integer index eMail read GetMultiStringCount;
    property AddressesAsCommaText: string index eMail read GetCommaText write SetCommaText;
    property Members[Index: Integer]: string index eMember read GetMultiString;
    property MemberCount: Integer index eMember read GetMultiStringCount;
    property MembersAsCommaText: string index eMember read GetCommaText write SetCommaText;
  end;


implementation

uses LinLDAP,Sysutils;

{ TMailUser }

procedure TMailUser.AddAddress(Address: string);
begin
  AddToMultiString(eMail, Address);
end;

procedure TMailUser.RemoveAddress(Address: string);
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

procedure TMailGroup.AddMail(const AMail: string);
begin
  AddToMultiString(eMail, AMail);
end;

procedure TMailGroup.RemoveMail(const AMail: string);
begin
  RemoveFromMultiString(eMail, AMail);
end;

procedure TMailGroup.AddMember(const AMember: string);
begin
  AddToMultiString(eMember, AMember);
end;

procedure TMailGroup.RemoveMember(const AMember: string);
begin
  RemoveFromMultiString(eMember, AMember);
end;

end.
