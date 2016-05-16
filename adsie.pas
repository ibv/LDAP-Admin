  {      LDAPAdmin - adsie.pas
  *      Copyright (C) 2012 Tihomir Karlovic
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

unit adsie;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
{$IFnDEF FPC}
  Windows,ActiveDs_TLB,
{$ELSE}
  LCLIntf, LCLType, LMessages,
{$ENDIF}
   SysUtils, Dialogs;

function  ADsGetObject(LdapPath: PWideChar; const riid:TGUID; out ppObject):HRESULT;
function  ADsOpenObject(LdapPath, UserName, Password: PWideChar; Reserved:DWORD; const riid:TGUID; out ppObject):HRESULT;
procedure ADOpenObject(const LdapPath, UserName, Password: WideString; const riid:TGUID; out ppObject);

implementation

uses
{$IFnDEF FPC}
  ComObj,
{$ELSE}
{$ENDIF}
  Constant;

var
  ActiveDSHandle : THandle;
  pADsGetObject:  function(lpszPathName: PWideChar; const riid:TGUID; out ppObject):HRESULT; stdcall;
  pADsOpenObject: function(lpszPathName,
                           lpszUserName,
                           lpszPassword: PWideChar;
                           dwReserved:DWORD;
                           const riid:TGUID;
                           out ppObject):HRESULT; stdcall;


procedure LoadLib;
begin
  ///ActiveDSHandle := LoadLibrary('ActiveDS.dll');
  if (ActiveDSHandle = 0) then
    raise Exception.Create('Cannot load ActiveDS.DLL');
end;

function BindProc(ProcName: string): Pointer;
begin
  if ActiveDSHandle = 0 then
    LoadLib;
  {$IFDEF UNICODE}
  Result := GetProcAddress(ActiveDSHandle, PWideChar(@ProcName[1]));
  {$ELSE}
  ///Result := GetProcAddress(ActiveDSHandle, PAnsiChar(@ProcName[1]));
  {$ENDIF}
  if not Assigned(Result) then
    raise Exception.CreateFmt(stGetProcAddrErr, [ProcName]);
end;

function ADsOpenObject(LdapPath, UserName, Password: PWideChar; Reserved:DWORD; const riid:TGUID; out ppObject):HRESULT;
begin
  if not Assigned(pADsOpenObject) then
    pAdsOpenObject := BindProc('ADsOpenObject');
  Result := pADsOpenObject(LdapPath, UserName, Password, Reserved, riid, ppObject);
end;

function ADsGetObject(LdapPath: PWideChar; const riid:TGUID; out ppObject):HRESULT;
begin
  if not Assigned(pADsGetObject) then
    pAdsGetObject := BindProc('ADsGetObject');
  Result := pADsGetObject(LdapPath, riid, ppObject);
end;

procedure ADOpenObject(const LdapPath, UserName, Password: WideString; const riid:TGUID; out ppObject);
var
  Result: HRESULT;
begin
  if Username <> '' then
    ///result := ADsOpenObject(LPCWSTR(LdapPath), LPCWSTR(Username), LPCWSTR(Password), ADS_SECURE_AUTHENTICATION, riid, ppObject)
  else
    ///result := ADsGetObject(LPCWSTR(LdapPath), riid, ppObject);
  ///OleCheck(Result);
end;

initialization

  ActiveDSHandle := 0;

finalization

  if (ActiveDSHandle <> 0) then
    ///FreeLibrary(ActiveDSHandle);

end.
