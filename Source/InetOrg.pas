  {      LDAPAdmin - InetOrg.pas
  *      Copyright (C) 2005-2006 Tihomir Karlovic
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

unit InetOrg;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
{$IFnDEF FPC}
  Jpeg,
{$ELSE}
  graphics,  ExtCtrls,
{$ENDIF}
  PropertyObject, LDAPClasses, mormot.core.base;

const
     eCity                          = 00;
     eFacsimileTelephoneNumber      = 01;
     eHomePostalAddress             = 02;
     eHomePhone                     = 03;
     eIPPhone                       = 04;
     ePhoto                         = 05;
     eMobile                        = 06;
     eOrganization                  = 07;
     ePager                         = 08;
     ePhysicalDeliveryOfficeName    = 09;
     ePostalAddress                 = 10;
     ePostalCode                    = 11;
     eState                         = 12;
     eTelephoneNumber               = 13;
     eTitle                         = 14;
     eMail                          = 15;
     eDisplayName                   = 16;
     eCn                            = 17;
     eSn                            = 18;

   PropAttrNames: array [eCity..eSn] of RawUtf8 = (
     'l',
     'facsimileTelephoneNumber',
     'homePostalAddress',
     'homePhone',
     'IPPhone',
     'jpegPhoto',
     'mobile',
     'o',
     'pager',
     'physicalDeliveryOfficeName',
     'postalAddress',
     'postalCode',
     'st',
     'telephoneNumber',
     'title',
     'mail',
     'displayName',
     'cn',
     'sn'
   );

type
  TInetOrgPerson = class(TPropertyObject)
  private
    fImage: TImage;
    function GetImage: TImage;
    procedure SetImage(const Image: TImage);
  public
    constructor Create(const Entry: TLdapEntry); override;
    procedure AddMailAddress(Address: RawUtf8);
    procedure RemoveMailAddress(Address: RawUtf8);
    property Pager: RawUtf8 index ePager read GetString write SetString;
    property PostalAddress: RawUtf8 index ePostalAddress read GetString write SetString;
    property State: RawUtf8 index eState read GetString write SetString;
    property IPPhone: RawUtf8 index eIPPhone read GetString write SetString;
    property TelephoneNumber: RawUtf8 index eTelephoneNumber read GetString write SetString;
    property PostalCode: RawUtf8 index ePostalCode read GetString write SetString;
    property PhysicalDeliveryOfficeName: RawUtf8 index ePhysicalDeliveryOfficeName read GetString write SetString;
    property Title: RawUtf8 index eTitle read GetString write SetString;
    property Organization: RawUtf8 index eOrganization read GetString write SetString;
    property FacsimileTelephoneNumber: RawUtf8 index eFacsimileTelephoneNumber read GetString write SetString;
    property Citty: RawUtf8 index eCity read GetString write SetString;
    property HomePostalAddress: RawUtf8 index eHomePostalAddress read GetString write SetString;
    property HomePhone: RawUtf8 index eHomePhone read GetString write SetString;
    property Mobile: RawUtf8 index eMobile read GetString write SetString;
    property Photo: TImage read GetImage write SetImage;
    property Mail: RawUtf8 index eMail read GetCommaText write SetCommaText;
    property DisplayName: RawUtf8 index eDisplayName read GetString write SetString;
    property Cn: RawUtf8 index eCn read GetString write SetString;
    property Sn: RawUtf8 index eSn read GetString write SetString;
  end;

implementation

uses Misc,
     Classes
     ;

{ TInetOrgPerson }

constructor TInetOrgPerson.Create(const Entry: TLdapEntry);
begin
  inherited Create(Entry, 'inetOrgPerson', @PropAttrNames);
end;

procedure TInetOrgPerson.AddMailAddress(Address: RawUtf8);
begin
  AddToMultiString(eMail, Address);
end;

procedure TInetOrgPerson.RemoveMailAddress(Address: RawUtf8);
begin
  RemoveFromMultiString(eMail, Address);
end;

function TInetOrgPerson.GetImage: TImage;
var
  Value: TLdapAttributeData;
  Stream: TMemoryStream;

begin
  Value := Attributes[ePhoto].Values[0];
  if not Assigned(fImage) then
    fImage := TImage.Create(nil);
  if Assigned(Value) and (Value.DataSize > 0) then
  begin
    if not Assigned(fImage) then
      fImage := TImage.Create(nil);
    Stream := TMemoryStream.Create;
    try
      Value.SaveToStream(Stream);
      Stream.Position := 0;
      fImage.Picture.LoadFromStream(Stream);
    finally
      Stream.Free;
    end;
  end;
  Result := fImage;
end;

procedure TInetOrgPerson.SetImage(const Image: TImage);
var
  Attribute: TLdapAttribute;
  Stream: TMemoryStream;
begin
  Attribute := Attributes[ePhoto];
  if not Assigned(Image) then
    Attribute.Delete
  else
  begin
    if Attribute.ValueCount = 0 then
      Attribute.AddValue;
    Stream := TMemoryStream.Create;
    try
      Image.Picture.SaveToStream(Stream);
      Stream.Position := 0;
      Attribute.Values[0].LoadFromStream(Stream);
    finally
      Stream.Free;
    end;

  end;
end;

end.
