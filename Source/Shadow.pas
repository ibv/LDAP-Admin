  {      LDAPAdmin - Shadow.pas
  *      Copyright (C) 2005 Tihomir Karlovic
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

unit Shadow;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses PropertyObject, LDAPClasses, mormot.core.base;

const
    SHADOW_FLAG          = 0;
    SHADOW_MIN           = 0;
    SHADOW_MAX           = 99999;
    SHADOW_WARNING       = 0;
    SHADOW_INACTIVE      = 99999;
    SHADOW_LAST_CHANGE   = 12011;
    SHADOW_EXPIRE        = 99999;

const
    eUserPassword        = 0;
    eDescription         = 1;
    eShadowFlag          = 2;
    eShadowMin           = 3;
    eShadowMax           = 4;
    eShadowWarning       = 5;
    eShadowInactive      = 6;
    eShadowLastChange    = 7;
    eShadowExpire        = 8;

  PropAttrNames: array[eUserPassword..eShadowExpire] of RawUtf8 = (
    'userPassword',
    'description',
    'shadowFlag',
    'shadowMin',         // min number of days between password changes
    'shadowMax',         // max number of days password is valid
    'shadowWarning',     // numer of days before password expiry to warn user
    'shadowInactive',    // numer of days to allow account to be inactive
    'shadowLastChange',  // last change of shadow info, int value
    'shadowExpire'       // absolute date to expire account counted in days since 1.1.1970
    );

type
  TShadowAccount = class(TPropertyObject)
  public
    constructor Create(const Entry: TLdapEntry); override;
    procedure New; override;
    procedure Remove; override;
    property UserPassword: RawUtf8 index 0 read GetString write SetString;
    property Description: RawUtf8 index 1 read GetString write SetString;
    property ShadowFlag: Integer index 2 read GetInt write SetInt;
    property ShadowMin: Integer index 3 read GetInt write SetInt;
    property ShadowMax: Integer index 4 read GetInt write SetInt;
    property ShadowWarning: Integer index 5 read GetInt write SetInt;
    property ShadowInactive: Integer index 6 read GetInt write SetInt;
    property ShadowLastChange: Integer index 7 read GetInt write SetInt;
    property ShadowExpire: Integer index 8 read GetInt write SetInt;
  end;

implementation


constructor TShadowAccount.Create(const Entry: TLdapEntry);
begin
  inherited Create(Entry, 'shadowAccount', @PropAttrNames);
end;

procedure TShadowAccount.New;
begin
  inherited;
  shadowFlag := SHADOW_FLAG;
  shadowMin := SHADOW_MIN;
  shadowMax := SHADOW_MAX;
  shadowWarning := SHADOW_WARNING;
  shadowInactive := SHADOW_INACTIVE;
  shadowLastChange := SHADOW_LAST_CHANGE;
  shadowExpire := SHADOW_EXPIRE;
end;

procedure TShadowAccount.Remove;
begin
  inherited;
  SetString(eShadowFlag, '');
  SetString(eShadowMin, '');
  SetString(eShadowMax, '');
  SetString(eShadowWarning, '');
  SetString(eShadowInactive, '');
  SetString(eShadowLastChange, '');
  SetString(eShadowExpire, '');
end;

end.
