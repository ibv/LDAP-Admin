  {      LDAPAdmin - ShaCrypt.pas
  *      Copyright (C) 2011 Tihomir Karlovic
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

unit ShaCrypt;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

  { "Unix crypt using SHA-256 and SHA-512", as specified by Ulrich Drepper
    Version 0.4 2008-4-3, http://www.akkadia.org/drepper/SHA-crypt.txt }

interface

const
  ROUNDS_DEFAULT = 5000;
  ROUNDS_MIN     = 1000;
  ROUNDS_MAX     = 999999999;

function Sha256(const Key: string; const Salt: string = ''; Rounds: Integer = ROUNDS_DEFAULT): string;
function Sha512(const Key: string; const Salt: string = ''; Rounds: Integer = ROUNDS_DEFAULT): string;

implementation

uses {DECHash,} SysUtils;

function b64_from_24bit(b2, b1, b0: Byte; n: Integer): string;
const
  CHARS = './0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz';
var
  w: Cardinal;
begin
  w := (b2 shl 16) or (b1 shl 8) or b0;
  Result := '';
  while (n > 0) do begin
      Result := Result + CHARS[(w and $3f) + 1];
      w := w shr 6;
      dec(n);
  end;
end;

{
function GetSha(const Key: string; var Salt: string; var Rounds: Integer; mdc: TDECHashClass; BlockSize: Integer): string;
var
  md: TDECHash;
  Ctx, AltCtx, AltResult, TmpResult, PBytes, SBytes: String;
  cnt: Integer;

  function GetDigest(const Ctx: string): string;
  begin
    md.Init;
    md.Calc(Ctx[1], Length(Ctx));
    md.Done;
    SetString(Result, PChar(md.Digest), md.DigestSize);
  end;

begin

  if Salt='' then
  begin
    Randomize;
    Salt := b64_from_24bit(Random(255), Random(255), Random(255), 4) +
            b64_from_24bit(Random(255), Random(255), Random(255), 4)
  end
  else
    Salt := Copy(Salt, 1, 16);

  if Rounds < ROUNDS_MIN then
    Rounds := ROUNDS_MIN
  else
  if Rounds > ROUNDS_MAX then
    Rounds := ROUNDS_MAX;

  Ctx := Key + Salt;
  AltCtx := Ctx + Key;

  md := mdc.Create;
  try
    AltResult := GetDigest(AltCtx);

    cnt := Length(Key);
    while cnt > BlockSize do begin
      Ctx := Ctx + AltResult;
      Dec(cnt, BlockSize);
    end;
    Ctx := Ctx + Copy(AltResult, 1, cnt);

    cnt := Length(Key);
    while cnt > 0 do begin
      if cnt and $01 <> 0 then
        Ctx := Ctx + AltResult
      else
        Ctx := Ctx + Key;
      cnt := cnt shr 1;
    end;

    AltResult := GetDigest(Ctx);

    // Start computation of P byte sequence.
    AltCtx := '';
    for cnt := 1 to Length(Key) do
      AltCtx := AltCtx + Key;

    TmpResult := GetDigest(AltCtx);

    // Create byte sequence P.
    PBytes := '';
    cnt := Length(Key);
    while cnt >= BlockSize do begin
      PBytes := PBytes + TmpResult;
      Dec(cnt, BlockSize);
    end;
    PBytes := PBytes + Copy(TmpResult, 1, cnt);

    // Start computation of S byte sequence.
    AltCtx := '';
    for cnt := 0 to 16 + Ord(AltResult[1]) - 1 do
      AltCtx := AltCtx + Salt;

    TmpResult := GetDigest(AltCtx);

    // Create byte sequence S.
    SBytes := '';
    cnt := Length(Salt);
    while cnt >= BlockSize do begin
      SBytes := SBytes + TmpResult;
      Dec(cnt, BlockSize);
    end;
    SBytes := SBytes + Copy(TmpResult, 1, cnt);

    for cnt := 0 to Rounds - 1 do
    begin
      // New context
      Ctx := '';

      // Add key or last result.
      if cnt and $01 <> 0 then
        Ctx := Ctx + PBytes
      else
        Ctx := Ctx + AltResult;

      // Add salt for numbers not divisible by 3.
      if cnt mod 3 <> 0 then
        Ctx := Ctx + SBytes;

      // Add key for numbers not divisible by 7.
      if cnt mod 7 <> 0 then
          Ctx := Ctx + PBytes;

      // Add key or last result.
      if cnt and $01 <> 0 then
        Ctx := Ctx + AltResult
      else
        Ctx := Ctx + PBytes;

      // Create intermediate result.
      AltResult := GetDigest(Ctx);
    end;

   Result := AltResult;

  finally
    md.Free;
  end;
end;
}
function Sha256(const Key: string; const Salt: string = ''; Rounds: Integer = ROUNDS_DEFAULT): string;
var
  ASalt, AltResult: string;
  bAltResult: PByteArray;

begin
    ASalt := Salt;
    ///AltResult := GetSha(Key, ASalt, Rounds, THash_SHA256, 32);
    bAltResult := @AltResult[1];
    Result := '$5$';
    if Rounds <> ROUNDS_DEFAULT then
      Result := Result + 'rounds=' + IntToStr(Rounds) + '$';
    Result := Result + ASalt + '$';
    Result := Result + b64_from_24bit(bAltResult[0],  bAltResult[10], bAltResult[20], 4);
    Result := Result + b64_from_24bit(bAltResult[21], bAltResult[1],  bAltResult[11], 4);
    Result := Result + b64_from_24bit(bAltResult[12], bAltResult[22], bAltResult[2],  4);
    Result := Result + b64_from_24bit(bAltResult[3],  bAltResult[13], bAltResult[23], 4);
    Result := Result + b64_from_24bit(bAltResult[24], bAltResult[4],  bAltResult[14], 4);
    Result := Result + b64_from_24bit(bAltResult[15], bAltResult[25], bAltResult[5],  4);
    Result := Result + b64_from_24bit(bAltResult[6],  bAltResult[16], bAltResult[26], 4);
    Result := Result + b64_from_24bit(bAltResult[27], bAltResult[7],  bAltResult[17], 4);
    Result := Result + b64_from_24bit(bAltResult[18], bAltResult[28], bAltResult[8],  4);
    Result := Result + b64_from_24bit(bAltResult[9],  bAltResult[19], bAltResult[29], 4);
    Result := Result + b64_from_24bit(0,              bAltResult[31], bAltResult[30], 3);
end;

function Sha512(const Key: string; const Salt: string = ''; Rounds: Integer = ROUNDS_DEFAULT): string;
var
  ASalt, AltResult: string;
  bAltResult: PByteArray;

begin
    ASalt := Salt;
    ///AltResult := GetSha(Key, ASalt, Rounds, THash_SHA512, 64);
    bAltResult := @AltResult[1];
    Result := '$6$';
    if Rounds <> ROUNDS_DEFAULT then
      Result := Result + 'rounds=' + IntToStr(Rounds) + '$';
    Result := Result + ASalt + '$';

    Result := Result + b64_from_24bit(bAltResult[0],  bAltResult[21], bAltResult[42], 4);
    Result := Result + b64_from_24bit(bAltResult[22], bAltResult[43], bAltResult[1],  4);
    Result := Result + b64_from_24bit(bAltResult[44], bAltResult[2],  bAltResult[23], 4);
    Result := Result + b64_from_24bit(bAltResult[3],  bAltResult[24], bAltResult[45], 4);
    Result := Result + b64_from_24bit(bAltResult[25], bAltResult[46], bAltResult[4],  4);
    Result := Result + b64_from_24bit(bAltResult[47], bAltResult[5],  bAltResult[26], 4);
    Result := Result + b64_from_24bit(bAltResult[6],  bAltResult[27], bAltResult[48], 4);
    Result := Result + b64_from_24bit(bAltResult[28], bAltResult[49], bAltResult[7],  4);
    Result := Result + b64_from_24bit(bAltResult[50], bAltResult[8],  bAltResult[29], 4);
    Result := Result + b64_from_24bit(bAltResult[9],  bAltResult[30], bAltResult[51], 4);
    Result := Result + b64_from_24bit(bAltResult[31], bAltResult[52], bAltResult[10], 4);
    Result := Result + b64_from_24bit(bAltResult[53], bAltResult[11], bAltResult[32], 4);
    Result := Result + b64_from_24bit(bAltResult[12], bAltResult[33], bAltResult[54], 4);
    Result := Result + b64_from_24bit(bAltResult[34], bAltResult[55], bAltResult[13], 4);
    Result := Result + b64_from_24bit(bAltResult[56], bAltResult[14], bAltResult[35], 4);
    Result := Result + b64_from_24bit(bAltResult[15], bAltResult[36], bAltResult[57], 4);
    Result := Result + b64_from_24bit(bAltResult[37], bAltResult[58], bAltResult[16], 4);
    Result := Result + b64_from_24bit(bAltResult[59], bAltResult[17], bAltResult[38], 4);
    Result := Result + b64_from_24bit(bAltResult[18], bAltResult[39], bAltResult[60], 4);
    Result := Result + b64_from_24bit(bAltResult[40], bAltResult[61], bAltResult[19], 4);
    Result := Result + b64_from_24bit(bAltResult[62], bAltResult[20], bAltResult[41], 4);
    Result := Result + b64_from_24bit(0,              0,              bAltResult[63], 2);
end;

end.
