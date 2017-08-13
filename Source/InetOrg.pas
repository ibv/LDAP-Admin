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
  graphics,
{$ENDIF}
  PropertyObject, LDAPClasses;

const
     eCity                          = 00;
     eFacsimileTelephoneNumber      = 01;
     eHomePostalAddress             = 02;
     eHomePhone                     = 03;
     eIPPhone                       = 04;
     eJPegPhoto                     = 05;
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

   PropAttrNames: array [eCity..eSn] of string = (
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
    fJpegImage: TJpegImage;
    function GetJPegImage: TJpegImage;
    procedure SetJPegImage(const Image: TJpegImage);
  public
    constructor Create(const Entry: TLdapEntry); override;
    procedure AddMailAddress(Address: string);
    procedure RemoveMailAddress(Address: string);
    property Pager: string index ePager read GetString write SetString;
    property PostalAddress: string index ePostalAddress read GetString write SetString;
    property State: string index eState read GetString write SetString;
    property IPPhone: string index eIPPhone read GetString write SetString;
    property TelephoneNumber: string index eTelephoneNumber read GetString write SetString;
    property PostalCode: string index ePostalCode read GetString write SetString;
    property PhysicalDeliveryOfficeName: string index ePhysicalDeliveryOfficeName read GetString write SetString;
    property Title: string index eTitle read GetString write SetString;
    property Organization: string index eOrganization read GetString write SetString;
    property FacsimileTelephoneNumber: string index eFacsimileTelephoneNumber read GetString write SetString;
    property Citty: string index eCity read GetString write SetString;
    property HomePostalAddress: string index eHomePostalAddress read GetString write SetString;
    property HomePhone: string index eHomePhone read GetString write SetString;
    property Mobile: string index eMobile read GetString write SetString;
    property JPegPhoto: TJPegImage read GetJPegImage write SetJPegImage;
    property Mail: string index eMail read GetCommaText write SetCommaText;
    property DisplayName: string index eDisplayName read GetString write SetString;
    property Cn: string index eCn read GetString write SetString;
    property Sn: string index eSn read GetString write SetString;
  end;

implementation

uses Misc;

{ TInetOrgPerson }

constructor TInetOrgPerson.Create(const Entry: TLdapEntry);
begin
  inherited Create(Entry, 'inetOrgPerson', @PropAttrNames);
end;

procedure TInetOrgPerson.AddMailAddress(Address: string);
begin
  AddToMultiString(eMail, Address);
end;

procedure TInetOrgPerson.RemoveMailAddress(Address: string);
begin
  RemoveFromMultiString(eMail, Address);
end;

function TInetOrgPerson.GetJPegImage: TJpegImage;
var
  Value: TLdapAttributeData;
begin
  Value := Attributes[eJpegPhoto].Values[0];
  if Assigned(Value) and (Value.DataSize > 0) then
  begin
    if not Assigned(fJpegImage) then
      fJpegImage := TJPEGImage.Create;
    StreamCopy(Value.SaveToStream, fJpegImage.LoadFromStream);      
  end;
  Result := fJPegImage;
end;

procedure TInetOrgPerson.SetJPegImage(const Image: TJpegImage);
var
  Attribute: TLdapAttribute;
begin
  Attribute := Attributes[eJpegPhoto];
  if not Assigned(Image) then
    Attribute.Delete
  else
  begin
    if Attribute.ValueCount = 0 then
      Attribute.AddValue;
    StreamCopy(Image.SaveToStream, Attribute.Values[0].LoadFromStream);
  end;
end;

end.
