{ This is a port of SAMBA md4.c file
  T.Karlovic 2002

/*
   Unix SMB/Netbios implementation.
   Version 1.9.
   a implementation of MD4 designed for use in the SMB authentication protocol
   Copyright (C) Andrew Tridgell 1997

   This program is free software; you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation; either version 2 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program; if not, write to the Free Software
   Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
*/

}

unit md4;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses Sysutils;

procedure mdfour(var outval, inval: array of Byte; n: Integer);

implementation

var
  A, B, C, D: Cardinal;

function F(X, Y, Z: Cardinal): Cardinal;
begin
  Result :=  (X and Y) or ((not X) and Z);
end;

function G(X, Y, Z: Cardinal): Cardinal;
begin
  Result := (X and Y) or (X and Z) or (Y and Z);
end;

function H(X, Y, Z: Cardinal): Cardinal;
begin
  Result := X xor Y xor Z;
end;

function lshift(x: Cardinal; s: Integer): Cardinal;
begin
  x := x and $FFFFFFFF;
  Result := ((x shl s) and $FFFFFFFF) or (x shr (32-s));
end;

{ this applies md4 to 64 byte chunks }
procedure mdfour64(var M: array of Cardinal);
var
  j: Integer;
  AA, BB, CC, DD: Cardinal;
  X: array [0..15] of Cardinal;

procedure ROUND1(var a: Cardinal; b,c,d,k,s: Cardinal);
begin
  a := lshift(a + F(b,c,d) + X[k], s)
end;
procedure ROUND2(var a: Cardinal; b,c,d,k,s: Cardinal);
begin
  a := lshift(a + G(b,c,d) + X[k] + Cardinal($5A827999),s);
end;

procedure ROUND3(var a: Cardinal; b,c,d,k,s: Cardinal);
begin
  a := lshift(a + H(b,c,d) + X[k] + Cardinal($6ED9EBA1),s);
end;

begin

	for j := 0 to 15 do
          X[j] := M[j];

	AA := A; BB := B; CC := C; DD := D;

        ROUND1(A,B,C,D,  0,  3);  ROUND1(D,A,B,C,  1,  7);
	ROUND1(C,D,A,B,  2, 11);  ROUND1(B,C,D,A,  3, 19);
        ROUND1(A,B,C,D,  4,  3);  ROUND1(D,A,B,C,  5,  7);
	ROUND1(C,D,A,B,  6, 11);  ROUND1(B,C,D,A,  7, 19);
        ROUND1(A,B,C,D,  8,  3);  ROUND1(D,A,B,C,  9,  7);  
	ROUND1(C,D,A,B, 10, 11);  ROUND1(B,C,D,A, 11, 19);
        ROUND1(A,B,C,D, 12,  3);  ROUND1(D,A,B,C, 13,  7);  
	ROUND1(C,D,A,B, 14, 11);  ROUND1(B,C,D,A, 15, 19);

        ROUND2(A,B,C,D,  0,  3);  ROUND2(D,A,B,C,  4,  5);  
	ROUND2(C,D,A,B,  8,  9);  ROUND2(B,C,D,A, 12, 13);
        ROUND2(A,B,C,D,  1,  3);  ROUND2(D,A,B,C,  5,  5);  
	ROUND2(C,D,A,B,  9,  9);  ROUND2(B,C,D,A, 13, 13);
        ROUND2(A,B,C,D,  2,  3);  ROUND2(D,A,B,C,  6,  5);  
	ROUND2(C,D,A,B, 10,  9);  ROUND2(B,C,D,A, 14, 13);
        ROUND2(A,B,C,D,  3,  3);  ROUND2(D,A,B,C,  7,  5);  
	ROUND2(C,D,A,B, 11,  9);  ROUND2(B,C,D,A, 15, 13);

	ROUND3(A,B,C,D,  0,  3);  ROUND3(D,A,B,C,  8,  9);  
	ROUND3(C,D,A,B,  4, 11);  ROUND3(B,C,D,A, 12, 15);
        ROUND3(A,B,C,D,  2,  3);  ROUND3(D,A,B,C, 10,  9);  
	ROUND3(C,D,A,B,  6, 11);  ROUND3(B,C,D,A, 14, 15);
        ROUND3(A,B,C,D,  1,  3);  ROUND3(D,A,B,C,  9,  9);
	ROUND3(C,D,A,B,  5, 11);  ROUND3(B,C,D,A, 13, 15);
        ROUND3(A,B,C,D,  3,  3);  ROUND3(D,A,B,C, 11,  9);
	ROUND3(C,D,A,B,  7, 11);  ROUND3(B,C,D,A, 15, 15);

	Inc(A, AA); Inc(B, BB); Inc(C, CC); Inc(D, DD);
	
	A := A and $FFFFFFFF; B := B and $FFFFFFFF;
	C := C and $FFFFFFFF; D := D and $FFFFFFFF;

	for j:= 0 to 15 do
          X[j] := 0;
end;

procedure copy64(var M: array of Cardinal; inval: Array of Byte);
var
  i: Integer;
begin
  for i:=0 to 15 do
    M[i] := (inval[i*4+3] shl 24) or (inval[i*4+2] shl 16) or
			(inval[i*4+1] shl 8) or (inval[i*4+0] shl 0);
end;

procedure copy4(var outval: array of Byte; x: Cardinal);
begin
  outval[0] := x and $FF;
  outval[1] := (x shr 8) and $FF;
  outval[2] := (x shr 16) and $FF;
  outval[3] := (x shr 24) and $FF;
end;

{ produce a md4 message digest from data of length n bytes }
procedure mdfour(var outval, inval: array of Byte; n: Integer);
var
  buf: array[0..127] of Byte;
  M: array[0..15] of Cardinal;
  sb: Cardinal;
  i, invc: Integer;
begin
	sb := n * 8;

	A := $67452301;
	B := $efcdab89;
	C := $98badcfe;
	D := $10325476;

        invc := 0;
	while (n > 64) do
        begin
          copy64(M, inval[invc]);
          mdfour64(M);
          Inc(invc, 64);
          Dec(n, 64);
	end;

	for i:=0 to 127 do
          buf[i] := 0;
	//memcpy(buf, in, n);
        Move(inval[invc], buf, n);
	buf[n] := $80;

	if (n <= 55) then
        begin
          copy4(buf[56], sb);
          copy64(M, buf);
          mdfour64(M);
        end
	else begin
          copy4(buf[120], sb);
          copy64(M, buf);
          mdfour64(M);
          copy64(M, buf[64]);
          mdfour64(M);
	end;

	for i:=0 to 127 do
          buf[i] := 0;
	copy64(M, buf);

	copy4(outval, A);
	copy4(outval[4], B);
	copy4(outval[8], C);
	copy4(outval[12], D);

	A := 0;
        B := 0;
        C := 0;
        D := 0;
end;




end.
