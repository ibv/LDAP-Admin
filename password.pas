  {      LDAPAdmin - Password.pas
  *      Copyright (C) 2005-2011 Tihomir Karlovic
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

unit Password;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses LDAPClasses{, DECHash};

type
  THashType = (chText, chCrypt, chMd5Crypt, chMd2, chMd4, chMd5, chSha1, chSMD5, chSSHA, chSha256, chSha512, chRipemd);

const
  ///HashClasses: array [chMd2..chRipemd] of TDECHashClass = (
  /// THash_MD2, THash_MD4, THash_MD5, THash_SHA1, THash_MD5, THash_SHA1, THash_SHA256, THash_SHA512, THash_RIPEMD160
  ///);
  IdStrings: array [chText..chRipemd] of string = (
  '','{CRYPT}','{CRYPT}','{MD2}','{MD4}','{MD5}','{SHA}','{SMD5}','{SSHA}','{CRYPT}','{CRYPT}','{RMD160}');

function GetPasswordString(const HashType: THashType; const Password: string): string;

implementation

uses Sysutils, Unixpass, {md5crypt, ShaCrypt,} base64;

function GetSalt(Len: Integer): AnsiString;
const
  SaltChars: array[0..63] of AnsiChar =
    'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789./';
var
  i: Integer;
begin
  Randomize;
  SetLength(Result, Len);
  for i := 1 to Len do
    Result[i] := SaltChars[Random(64)];
end;

function Crypt(const AValue: string): string;
var
  Buff : array[0..30] of char;
begin
  UnixCrypt(PChar(GetSalt(2)), StrPCopy(Buff, AValue));
  Result := StrPas(Buff);
end;

{
function Digest(const HashType: THashType; const Password: string): string;
var
  md: TDECHash;
begin
  md := HashClasses[HashType].Create;
  try
    md.Init;
    md.Calc(Password[1], Length(Password));
    md.Done;
    Result := Base64Encode(md.Digest^, md.DigestSize);
  finally
    md.Free;
  end;
end;

function SaltedDigest(const HashType: THashType; const Password: string): string;
var
  Salt, SaltedKey, Hash: string;
  md: TDECHash;
begin
  Salt := GetSalt(12);
  SaltedKey := Password + Salt;
  md := HashClasses[HashType].Create;
  try
    md.Init;
    md.Calc(SaltedKey[1], Length(SaltedKey));
    md.Done;
    SetString(Hash, PChar(md.Digest), md.DigestSize);
    Result := Base64Encode(Hash + Salt);
  finally
    md.Free;
  end;
end;
}
function GetPasswordString(const HashType: THashType; const Password: string): string;
var
  passwd: string;
begin
  case HashType of
    chText:      passwd := Password;
    chCrypt:     passwd := Crypt(Password);
    ///chMd5Crypt:  passwd := md5_crypt(PChar(Password), PChar(GetSalt(8)));
    ///chSMD5,
    ///chSSHA:      passwd := SaltedDigest(HashType, Password);
    ///chSha256:    passwd := Sha256(Password);
    ///chSha512:    passwd := Sha512(Password);
  else
    ///passwd := Digest(HashType, Password);
  end;
  Result := IdStrings[HashType] + passwd;
end;

end.
