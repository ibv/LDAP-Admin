  {      LDAPAdmin - Params.pas
  *      Copyright (C) 2003-2008 Tihomir Karlovic
  *
  *      Author: Tihomir Karlovic & Alexander Sokoloff
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

unit Params;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses SysUtils, LDAPClasses, Constant;

function GetParameter(var P: PChar): string;
function IsParametrized(s: string): Boolean;
function FormatValue(const AValue: string; Entry: TLdapEntry): string;

implementation

function ScanParam(const p: PChar): PChar;
begin
  Result := p;
  while Result^ <> #0 do
  begin
    case Result^ of
      '\': begin
             inc(Result);
             if not Assigned(Result) then Break;
            end;
      '%': Break;
    end;
    inc(Result);
  end;
end;

function RemoveEsc(const s: string): string;
var
  p, p1, p2: PChar;
begin
  SetLength(Result, Length(s));
  p1 := PChar(s);
  p2 := PChar(Result);
  p := p2;
  while p1^ <> #0 do
  begin
    if p1^ = '\' then
    begin
      inc(p1);
      if p1^ = #0 then
        Break;
    end;
    p2^ := p1^;
    inc(p1);
    inc(p2);
  end;
  SetLength(Result, p2 - p);
end;

function GetParameter(var P: PChar): string;
var
  p1: PChar;
begin
  Result := '';
  P := ScanParam(P);
  if P^ <> #0 then
  begin
    inc(P);
    p1 := ScanParam(P);
    if p1 = #0 then
      raise Exception.Create(stUnclosedParam);
    if p1 - P > 0 then
      SetString(Result, p, p1 - p);
    P := p1 + 1;
  end;
end;

function IsParametrized(s: string): Boolean;
var
  p: PChar;
begin
  p := pChar(s);
  Result := GetParameter(p) <> '';
end;

function FormatValue(const AValue: string; Entry: TLdapEntry): string;
var
  p0, p1, p2: PChar;
  name, val, s: string;
begin
  Result := '';
  p0 := PChar(AValue);
  p1 := ScanParam(p0);
  while p1^ <> #0 do
  begin
    inc(p1);
    p2 := ScanParam(p1);
    if p2 = #0 then
      raise Exception.Create(stUnclosedParam);
    if p2 - p1 > 0 then
    begin
      SetString(name, p1, p2 - p1);
      val := Entry.AttributesByName[name].AsString;
      if val = '' then
      begin
        Result := '';
        Exit;
      end;
      SetString(s, p0, p1 - p0 - 1);
      Result := Result + s + val;
      p0 := p2 + 1;
    end;
    p1 := ScanParam(p2 + 1);
  end;
  Result := RemoveEsc(Result + p0);
end;

end.
 
