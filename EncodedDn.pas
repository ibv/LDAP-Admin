  {      LDAPAdmin - EncodedDn.pas
  *      Copyright (C) 2016 Tihomir Karlovic
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

unit EncodedDn;

{$IFDEF FPC}
  {$MODE Delphi}
  {$H+}
{$ENDIF}

interface

uses Controls, Classes;

type
  TEncodedDn = record
  private
    FEncoded: string;
    FVerbatim: Boolean;
    FControl:  TControl;
    FOnChange: TNotifyEvent;
    procedure SetControlOnChange(Value: TNotifyEvent);
    function  GetControlOnChange: TNotifyEvent;
    procedure SetControlText(Value: string);
    function  GetControlText: string;
    procedure OnControlChange(Sender: TObject);
    procedure SetEncoded(Value: string);
    procedure _SetDisplay(Value: string);
    procedure SetDisplay(Value: string);
    function  GetDisplay: string;
    function  GetDisplayAttribute: string;
    procedure SetDisplayAttribute(Value: string);
    property  OnChange: TNotifyEvent read GetControlOnChange write SetControlOnChange;
  public
    procedure Attach(Control: TControl);
    property Encoded: string read FEncoded write SetEncoded;
    property Display: string read GetDisplay write SetDisplay;
    property Verbatim: Boolean read FVerbatim write FVerbatim;
  end;


implementation

uses
  {$IFnDEF FPC}
  Windows,
  {$ELSE}
  Misc,
  {$ENDIF}
  LdapClasses, StdCtrls;

{ Encodes Dn, treating successive ',' or '=' characters as part of the value.
  A string prefixed with @ character is taken verbatim therefore allowing for
  user escaped strings to be passed as litterals. }
function EncodeDn(adn: string): string;
var
  p, p0, pe: PChar;
  a, v: string;
begin
  p := PChar(adn);
  if p^ = '@' then
  begin
    Result := Copy(adn, 2, MaxInt);
    exit;
  end;
  p0 := p;
  pe := nil;
  Result := '';
  while true do begin
    case p^ of
      '=': if pe = nil then
             pe := p
           else begin
             while not (p^ in [',', #0]) do
               p := CharNext(p);
             continue;
           end;
      ',',
      #0 : if pe = nil then  // premature end or there is a comma in the value
           begin
             if p^ = ',' then
               Insert('\', Result, Length(Result));  // escape comma
             SetString(a, p0, p - p0);
             Result := Result + EncodeLdapString(a); // add rest of the value
             if p^ = #0 then
               exit;
             Result := Result + ',';
             p0 := p + 1;
           end
           else begin
             SetString(a, p0, pe - p0);
             SetString(v, pe + 1, p - pe -1);
             Result := Result + EncodeLdapString(a) + '=' + EncodeLdapString(v);
             if p^ = #0 then
               exit;
             Result := Result + ',';
             p0 := p + 1;
             pe := nil;
           end;
    end;
    p := CharNext(p);
  end;
end;

procedure TEncodedDn.SetControlOnChange(Value: TNotifyEvent);
begin
  if FControl is TEdit then
    TEdit(FControl).OnChange := Value
  else
  if FControl is TComboBox then
    TComboBox(Fcontrol).OnChange := Value;
end;

function TEncodedDn.GetControlOnChange: TNotifyEvent;
begin
  if FControl is TEdit then
    Result := TEdit(FControl).OnChange
  else
  if FControl is TComboBox then
    Result := TComboBox(Fcontrol).OnChange;
end;

procedure TEncodedDn.SetControlText(Value: string);
begin
  if FControl is TEdit then
    TEdit(FControl).Text := Value
  else
  if FControl is TComboBox then
    TComboBox(Fcontrol).Text := Value;
end;

function TEncodedDn.GetControlText: string;
begin
  if FControl is TEdit then
    Result := TEdit(FControl).Text
  else
  if FControl is TComboBox then
    Result := TComboBox(Fcontrol).Text;
end;

procedure TEncodedDn.OnControlChange(Sender: TObject);
begin
  if GetControlText <> Display then // prevents recursive calls
    Display := GetControlText;
  if Assigned(FOnChange) then
    FOnChange(Sender);
end;

procedure TEncodedDn.SetEncoded(Value: string);
begin
  FEncoded := Value;
  if Assigned(FControl) then
    SetControlText(Display);
end;

procedure TEncodedDn._SetDisplay(Value: string);
begin
  if Value = '' then
  begin
    FEncoded := '';
    exit;
  end;
  if Value[1] = '@' then
  begin
    FVerbatim := true;
    FEncoded := Copy(Value, 2, MaxInt);
  end
  else begin
    FVerbatim := false;
    FEncoded := EncodeDn(Value);
  end;
end;

procedure TEncodedDn.SetDisplay(Value: string);
begin
  _SetDisplay(Value);
  if Assigned(FControl) then
    SetControlText(Display);
end;

function TEncodedDn.GetDisplay;
begin
  if FVerbatim then
    Result := '@' + FEncoded
  else
    Result := DecodeLdapString(FEncoded);
end;

function TEncodedDn.GetDisplayAttribute: string;
begin
  Result := GetAttributeFromDn(FEncoded);
  if FVerbatim then
    Insert('@', Result, 1)
  else
    Result := DecodeLdapString(Result);
end;

procedure TEncodedDn.SetDisplayAttribute(Value: string);
var
  dir: string;
begin
  if (Value <> '') and (Value[1] = '@') then
  begin
    FVerbatim := true;
    Value := Copy(Value, 2, MaxInt)
  end
  else begin
    FVerbatim := false;
    Value := EncodeLdapString(Value);
  end;
  dir := GetDirFromDn(FEncoded);
  FEncoded := Value + '=' + GetNameFromDn(FEncoded);
  if dir = '' then
    exit;
  FEncoded := FEncoded + ',' + dir;
end;

procedure TEncodedDn.Attach(Control: TControl);
begin
  if Assigned(Control) then
  begin
    FControl  := Control;
    FOnChange := OnChange;
    ///OnChange  := OnControlChange;
  end;
end;

end.
