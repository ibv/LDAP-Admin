  {      LDAPAdmin - base64.pas
  *      Copyright (C) 2003-2012 Tihomir Karlovic
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

unit WinBase64;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

const
  CRLF : String = #13#10;

  Base64Set: array[0..63] of AnsiChar =
    'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/';

  Base64InvSet: array [0..255] of Byte =
  (   255, 255, 255, 255, 255, 255, 255, 255,
      255, 255, 255, 255, 255, 255, 255, 255,
      255, 255, 255, 255, 255, 255, 255, 255,
      255, 255, 255, 255, 255, 255, 255, 255,
      255, 255, 255, 255, 255, 255, 255, 255,
      255, 255, 255,  62, 255, 255, 255,  63,
       52,  53,  54,  55,  56,  57,  58,  59,
       60,  61, 255, 255, 255, 255, 255, 255,
      255,   0,   1,   2,   3,   4,   5,   6,
        7,   8,   9,  10,  11,  12,  13,  14,
       15,  16,  17,  18,  19,  20,  21,  22,
       23,  24,  25, 255, 255, 255, 255, 255,
      255,  26,  27,  28,  29,  30,  31,  32,
       33,  34,  35,  36,  37,  38,  39,  40,
       41,  42,  43,  44,  45,  46,  47,  48,
       49,  50,  51, 255, 255, 255, 255, 255,
      255, 255, 255, 255, 255, 255, 255, 255,
      255, 255, 255, 255, 255, 255, 255, 255,
      255, 255, 255, 255, 255, 255, 255, 255,
      255, 255, 255, 255, 255, 255, 255, 255,
      255, 255, 255, 255, 255, 255, 255, 255,
      255, 255, 255, 255, 255, 255, 255, 255,
      255, 255, 255, 255, 255, 255, 255, 255,
      255, 255, 255, 255, 255, 255, 255, 255,
      255, 255, 255, 255, 255, 255, 255, 255,
      255, 255, 255, 255, 255, 255, 255, 255,
      255, 255, 255, 255, 255, 255, 255, 255,
      255, 255, 255, 255, 255, 255, 255, 255,
      255, 255, 255, 255, 255, 255, 255, 255,
      255, 255, 255, 255, 255, 255, 255, 255,
      255, 255, 255, 255, 255, 255, 255, 255,
      255, 255, 255, 255, 255, 255, 255, 255
      );

  Base64InvSet2: array [0..255] of Byte =
  (   255, 255, 255, 255, 255, 255, 255, 255,  255, 255, 255, 255, 255, 255, 255, 255,
      255, 255, 255, 255, 255, 255, 255, 255,  255, 255, 255, 255, 255, 255, 255, 255,
      255, 255, 255, 255, 255, 255, 255, 255,  255, 255, 255,  62, 255, 255, 255,  63,
       52,  53,  54,  55,  56,  57,  58,  59,   60,  61, 255, 255, 254, 255, 255, 255,
      255,   0,   1,   2,   3,   4,   5,   6,    7,   8,   9,  10,  11,  12,  13,  14,
       15,  16,  17,  18,  19,  20,  21,  22,   23,  24,  25, 255, 255, 255, 255, 255,
      255,  26,  27,  28,  29,  30,  31,  32,   33,  34,  35,  36,  37,  38,  39,  40,
       41,  42,  43,  44,  45,  46,  47,  48,   49,  50,  51, 255, 255, 255, 255, 255,
      255, 255, 255, 255, 255, 255, 255, 255,  255, 255, 255, 255, 255, 255, 255, 255,
      255, 255, 255, 255, 255, 255, 255, 255,  255, 255, 255, 255, 255, 255, 255, 255,
      255, 255, 255, 255, 255, 255, 255, 255,  255, 255, 255, 255, 255, 255, 255, 255,
      255, 255, 255, 255, 255, 255, 255, 255,  255, 255, 255, 255, 255, 255, 255, 255,
      255, 255, 255, 255, 255, 255, 255, 255,  255, 255, 255, 255, 255, 255, 255, 255,
      255, 255, 255, 255, 255, 255, 255, 255,  255, 255, 255, 255, 255, 255, 255, 255,
      255, 255, 255, 255, 255, 255, 255, 255,  255, 255, 255, 255, 255, 255, 255, 255,
      255, 255, 255, 255, 255, 255, 255, 255,  255, 255, 255, 255, 255, 255, 255, 255
      );

type
  Tb24 = packed record
    case Value: Boolean of
    True: (Dword: Cardinal);
    False: (Bytes: array[0..3] of Byte);
  end;

function  Base64EncSize(InSize: Cardinal): Cardinal;
function  Base64DecSize(InSize: Cardinal): Cardinal; overload;
procedure Base64Encode(const InBuf; const Length: Cardinal; var OutBuf); overload;
function  Base64Decode(const InBuf; const Length: Cardinal; var OutBuf): Cardinal; overload;
function  Base64Encode(const InStr: AnsiString): AnsiString; overload;
function  Base64Encode(const InBuf; const Length: Cardinal): AnsiString; overload;
function  Base64DecSize(InBuf: AnsiString): Cardinal; overload;
function  Base64Decode(const InBuf: AnsiString; var OutBuf): integer; overload;
function  Base64Decode(const InBuf: AnsiString): AnsiString; overload;

implementation

uses SysUtils;

function Base64encSize(InSize: Cardinal): Cardinal;
begin
  Result := 4 * (InSize div 3);
  if (Insize mod 3) <> 0 then
    Inc(Result, 4);
end;

function Base64decSize(InSize: Cardinal): Cardinal;
begin
  Result := 3 * (InSize div 4) + 3;
end;

procedure Base64Encode(const InBuf; const Length: Cardinal; var OutBuf);
var
  idx, mdx, pad: Integer;
  b24: Cardinal;
  pIn, pOut: PByteArray;
begin

    mdx := Length div 3;
    pad := Length mod 3;

    pIn := @InBuf;
    pOut := @OutBuf;
    for idx := 0 to mdx - 1 do
    begin
        b24 := pIn^[0] shl 16 + pIn^[1] shl 8 + pIn^[2];
        pOut^[3] := Byte(Base64Set[b24 and $3F]);
        b24 := b24 shr 6;
        pOut^[2] := Byte(Base64Set[b24 and $3F]);
        b24 := b24 shr 6;
        pOut^[1] := Byte(Base64Set[b24 and $3F]);
        pOut^[0] := Byte(Base64Set[b24 shr 6]);
        inc(pByte(pIn), 3);
        inc(pByte(pOut), 4);
    end;

    case pad of
      1: begin
           pOut^[0] := Byte(Base64Set[pIn^[0] shr 2]);
           pOut^[1] := Byte(Base64Set[(pIn^[0] shl 4) and $3F]);
           pOut^[2] := Byte('=');
           pOut^[3] := Byte('=');
         end;
      2: begin
           b24 := (pIn^[0] shl 8 + pIn^[1]) shl 2;
           pOut^[2] := Byte(Base64Set[b24 and $3F]);
           b24 := b24 shr 6;
           pOut^[1] := Byte(Base64Set[b24 and $3F]);
           pOut^[0] := Byte(Base64Set[b24 shr 6]);
           pOut^[3] := Byte('=');
         end;
    else
      //raise Exception.Create('This shouldn't happend!');
    end;
end;

function Base64Decode(const InBuf; const Length: Cardinal; var OutBuf): Cardinal;
var
  idx, Chars: Cardinal;
  b24: Tb24;
  Ch: Byte;
  pIn: PByteArray;
  pOut: PByteArray;
begin
  pIn := @InBuf;
  pOut := @OutBuf;
  Chars := 0;
  b24.Dword := 0;
  for idx := 0 to Length - 1 do
  begin
    ch := Base64InvSet[pIn^[idx]];
    if ch <> 255 then
    begin
      b24.Dword := (b24.Dword shl 6) or ch;
      Inc(Chars);
      if Chars = 4 then
      begin
        pOut^[0] := b24.Bytes[2];
        pOut^[1] := b24.Bytes[1];
        pOut^[2] := b24.Bytes[0];
        inc(PByte(pOut), 3);
        b24.Dword := 0;
        Chars := 0;
      end;
    end;
  end;

  case Chars of
    1: begin
         pOut^[0] := b24.Bytes[0];
       end;
    2: begin
         b24.Dword := b24.Dword shr 4;
         pOut^[0] := b24.Bytes[0];
         Chars := 1;
       end;
    3:  begin
         b24.Dword := b24.Dword shl 6;
         pOut^[0] := b24.Bytes[2];
         pOut^[1] := b24.Bytes[1];
         Chars := 2;
       end;
  end;

  Result := Cardinal(pOut) - Cardinal(@OutBuf) + Chars;
end;

////////////////////////////////////////////////////////////////////////////////
function Base64Encode(const InBuf; const Length: Cardinal): AnsiString;
begin
  SetLength(result, Base64encSize(Length));
  if Length=0 then Exit;
  Base64Encode(InBuf, Length, Result[1]);
end;

function Base64Encode(const InStr: AnsiString): AnsiString;
var
  Len: Integer;
begin
  Len := Length(InStr);
  SetLength(Result, Base64encSize(Len));
  if Len=0 then Exit;
  Base64Encode(InStr[1], Len, Result[1]);
end;

function Base64decSize(InBuf: AnsiString): Cardinal; overload;
var
  i: integer;
begin
  Result := 3 * (length(InBuf) div 4);
  if result=0 then exit;

  i:=length(InBuf);
  while InBuf[i]='=' do begin
    dec(result);
    dec(i);
  end;
end;

function Base64Decode(const InBuf: AnsiString; var OutBuf): Integer;
begin
  Result := Base64Decode(InBuf[1], Length(InBuf), Outbuf);
end;

function  Base64Decode(const InBuf: AnsiString): AnsiString;
var
  vLen: Integer;
begin
  SetLength(Result, Base64decSize(Length(InBuf)));
  vLen := Base64Decode(InBuf[1], Length(InBuf), Result[1]);
  SetLength(Result, vLen);
end;

end.
