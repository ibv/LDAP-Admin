  {      LDAPAdmin - ObjectInfo.pas
  *      Copyright (C) 2013 Tihomir Karlovic
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

unit ObjectInfo;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses LDAPClasses, Templates, mormot.core.base;

const
  idUninitialized = -2;

type
  TObjectInfo = class
  private
    FEntry:     TLdapEntry;
    FOwnsEntry: Boolean;
    FObjectID:  Integer;
    FActionID:  Integer;
    FImageIndex: Integer;
    FTemplate:  TTemplate;
    function    GetObjectID: Integer;
    function    GetImageIndex: Integer;
    function    GetDN: RawUtf8;
    function    GetIsContainer: Boolean;
    function    GetActionId: Integer;
    function    GetSupported: Boolean;
  public
    constructor Create(Entry: TLdapEntry; const OwnsEntry: Boolean = true);
    destructor  Destroy; override;
    property    dn: RawUtf8 read GetDN;
    property    Entry: TLdapEntry read FEntry;
    property    ObjectID: Integer read GetObjectId;
    property    ActionId: Integer  read GetActionId;
    property    ImageIndex: Integer read GetImageIndex;
    property    IsContainer: Boolean read GetIsContainer;
    property    Template: TTemplate read FTemplate;
    property    Supported: Boolean read GetSupported;
  end;

implementation

uses Connection, CustomMenus, Constant;

{ TObjectInfo }

function TObjectInfo.GetActionID: Integer;
begin
  if FActionId = idUninitialized then with (FEntry.Session as TConnection).ActionMenu do
  begin
    { temporary workaround }
    if ObjectId = oidEntry then
    begin
      if Assigned(GetActionTemplate(Entry)) then
        FActionId := aidTemplate
      else
        FActionId := aidNone;
    end
    else
    { end workaround }
    FActionId := GetActionId(ObjectID);
    if FActionId = aidTemplate then
    begin
      FTemplate := GetActionTemplate(FEntry);
      if not Assigned(FTemplate) then
        FActionId := aidNone;
    end;
  end;
  Result := FActionId;
end;

function TObjectInfo.GetSupported: Boolean;
begin
  Result := ActionID <> aidNone;
end;

function TObjectInfo.GetIsContainer: Boolean;
begin
  Result := (fEntry.Session as TConnection).DI.IsContainer(ObjectID);
end;

function TObjectInfo.GetObjectID: Integer;
begin
  if FObjectID = oidUnknown then
    FObjectID := (Entry.Session as TConnection).DI.ClassifyLdapEntry(Entry);
  Result := FObjectID;
end;

function TObjectInfo.GetImageIndex: Integer;
var
  i: Integer;
  Template: TTemplate;
begin
  if FImageIndex = idUninitialized then
  begin
    { temporary workaround }
    if ObjectId = oidEntry then with (FEntry.Session as TConnection).ActionMenu do
    begin
      Template := GetActionTemplate(Entry);
      if Assigned(Template) then
      begin
        FImageIndex := bmTemplateEntry;
        if Template.ImageIndex <> -1 then
          FImageIndex := Template.ImageIndex;
        Result := FImageIndex;
        exit;
      end;
    end;
    { end workaround }
    if (ObjectId = oidEntry) and UseTemplateImages then
    begin
      FImageIndex := bmEntry;
      for i := 0 to TemplateParser.Count - 1 do with TemplateParser.Templates[i] do
        if {(ImageIndex <> -1 ) and} Matches(Entry.ObjectClass) then
        begin
          if ImageIndex = -1 then
            FImageIndex := bmTemplateEntry
          else
            FImageIndex := ImageIndex;
          break;
        end;
    end
    else
      FImageIndex := ObjectIdToImage[ObjectId];
  end;
  Result := FImageIndex;
end;

function TObjectInfo.GetDN: RawUtf8;
begin
  Result := FEntry.DN;
end;

constructor TObjectInfo.Create(Entry: TLdapEntry; const OwnsEntry: Boolean = true);
begin
  FEntry := Entry;
  FOwnsEntry := OwnsEntry;
  FObjectID := oidUnknown;
  FImageIndex := idUninitialized;
  FActionId := idUninitialized;
end;

destructor TObjectInfo.Destroy;
begin
  if FOwnsEntry then
    FEntry.Free;
  inherited Destroy;
end;


end.
