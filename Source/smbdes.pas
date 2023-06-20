{ This is a port of SAMBA smbdes.c file
  T.Karlovic 2002
}

unit smbdes;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
  mormot.core.base;

procedure E_P16(var p14, p16: array of Byte); overload;
//procedure E_P16(var sp14, sp16: RawUtf8); overload;
function E_P16(inStr: RawUtf8): RawUtf8; overload;

implementation

uses SysUtils;

{/*
   Unix SMB/Netbios implementation.
   Version 1.9.

   a partial implementation of DES designed for use in the
   SMB authentication protocol

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


/* NOTES:

   This code makes no attempt to be fast! In fact, it is a very
   slow implementation

   This code is NOT a complete DES implementation. It implements only
   the minimum necessary for SMB authentication, as used by all SMB
   products (including every copy of Microsoft Windows95 ever sold)

   In particular, it can only do a unchained forward DES pass. This
   means it is not possible to use this code for encryption/decryption
   of data, instead it is only useful as a "hash" algorithm.

   There is no entry point into this code that allows normal DES operation.

   I believe this means that this code does not come under ITAR
   regulations but this is NOT a legal opinion. If you are concerned
   about the applicability of ITAR regulations to this code then you
   should confirm it for yourself (and maybe let me know if you come
   up with a different answer to the one above)
*/}


const
  perm1:array[0..55] of Integer = (57, 49, 41, 33, 25, 17,  9,
			 1, 58, 50, 42, 34, 26, 18,
			10,  2, 59, 51, 43, 35, 27,
			19, 11,  3, 60, 52, 44, 36,
			63, 55, 47, 39, 31, 23, 15,
			 7, 62, 54, 46, 38, 30, 22,
			14,  6, 61, 53, 45, 37, 29,
			21, 13,  5, 28, 20, 12,  4);

  perm2: array[0..47] of Integer = (14, 17, 11, 24,  1,  5,
                         3, 28, 15,  6, 21, 10,
                        23, 19, 12,  4, 26,  8,
                        16,  7, 27, 20, 13,  2,
                        41, 52, 31, 37, 47, 55,
                        30, 40, 51, 45, 33, 48,
                        44, 49, 39, 56, 34, 53,
                        46, 42, 50, 36, 29, 32);

  perm3: array[0..63] of Integer = (58, 50, 42, 34, 26, 18, 10,  2,
			60, 52, 44, 36, 28, 20, 12,  4,
			62, 54, 46, 38, 30, 22, 14,  6,
			64, 56, 48, 40, 32, 24, 16,  8,
			57, 49, 41, 33, 25, 17,  9,  1,
			59, 51, 43, 35, 27, 19, 11,  3,
			61, 53, 45, 37, 29, 21, 13,  5,
			63, 55, 47, 39, 31, 23, 15,  7);

  perm4: array[0..47] of Integer = (   32,  1,  2,  3,  4,  5,
                            4,  5,  6,  7,  8,  9,
                            8,  9, 10, 11, 12, 13,
                           12, 13, 14, 15, 16, 17,
                           16, 17, 18, 19, 20, 21,
                           20, 21, 22, 23, 24, 25,
                           24, 25, 26, 27, 28, 29,
                           28, 29, 30, 31, 32,  1);

  perm5: array[0..31] of Integer = (      16,  7, 20, 21,
                              29, 12, 28, 17,
                               1, 15, 23, 26,
                               5, 18, 31, 10,
                               2,  8, 24, 14,
                              32, 27,  3,  9,
                              19, 13, 30,  6,
                              22, 11,  4, 25);


  perm6: array[0..63] of Integer =( 40,  8, 48, 16, 56, 24, 64, 32,
                        39,  7, 47, 15, 55, 23, 63, 31,
                        38,  6, 46, 14, 54, 22, 62, 30,
                        37,  5, 45, 13, 53, 21, 61, 29,
                        36,  4, 44, 12, 52, 20, 60, 28,
                        35,  3, 43, 11, 51, 19, 59, 27,
                        34,  2, 42, 10, 50, 18, 58, 26,
                        33,  1, 41,  9, 49, 17, 57, 25);


  sc: array[0..15] of Integer = (1, 1, 2, 2, 2, 2, 2, 2, 1, 2, 2, 2, 2, 2, 2, 1);

  sbox: array[0..7, 0..3, 0..15] of Integer = (
	((14,  4, 13,  1,  2, 15, 11,  8,  3, 10,  6, 12,  5,  9,  0,  7),
	 (0, 15,  7,  4, 14,  2, 13,  1, 10,  6, 12, 11,  9,  5,  3,  8),
	 (4,  1, 14,  8, 13,  6,  2, 11, 15, 12,  9,  7,  3, 10,  5,  0),
	 (15, 12,  8,  2,  4,  9,  1,  7,  5, 11,  3, 14, 10,  0,  6, 13)),

	((15,  1,  8, 14,  6, 11,  3,  4,  9,  7,  2, 13, 12,  0,  5, 10),
	 (3, 13,  4,  7, 15,  2,  8, 14, 12,  0,  1, 10,  6,  9, 11,  5),
	 (0, 14,  7, 11, 10,  4, 13,  1,  5,  8, 12,  6,  9,  3,  2, 15),
	 (13,  8, 10,  1,  3, 15,  4,  2, 11,  6,  7, 12,  0,  5, 14,  9)),

	((10,  0,  9, 14,  6,  3, 15,  5,  1, 13, 12,  7, 11,  4,  2,  8),
	 (13,  7,  0,  9,  3,  4,  6, 10,  2,  8,  5, 14, 12, 11, 15,  1),
	 (13,  6,  4,  9,  8, 15,  3,  0, 11,  1,  2, 12,  5, 10, 14,  7),
	 (1, 10, 13,  0,  6,  9,  8,  7,  4, 15, 14,  3, 11,  5,  2, 12)),

	((7, 13, 14,  3,  0,  6,  9, 10,  1,  2,  8,  5, 11, 12,  4, 15),
	 (13,  8, 11,  5,  6, 15,  0,  3,  4,  7,  2, 12,  1, 10, 14,  9),
	 (10,  6,  9,  0, 12, 11,  7, 13, 15,  1,  3, 14,  5,  2,  8,  4),
	 (3, 15,  0,  6, 10,  1, 13,  8,  9,  4,  5, 11, 12,  7,  2, 14)),

	((2, 12,  4,  1,  7, 10, 11,  6,  8,  5,  3, 15, 13,  0, 14,  9),
	 (14, 11,  2, 12,  4,  7, 13,  1,  5,  0, 15, 10,  3,  9,  8,  6),
	 (4,  2,  1, 11, 10, 13,  7,  8, 15,  9, 12,  5,  6,  3,  0, 14),
	 (11,  8, 12,  7,  1, 14,  2, 13,  6, 15,  0,  9, 10,  4,  5,  3)),

	((12,  1, 10, 15,  9,  2,  6,  8,  0, 13,  3,  4, 14,  7,  5, 11),
	 (10, 15,  4,  2,  7, 12,  9,  5,  6,  1, 13, 14,  0, 11,  3,  8),
	 (9, 14, 15,  5,  2,  8, 12,  3,  7,  0,  4, 10,  1, 13, 11,  6),
	 (4,  3,  2, 12,  9,  5, 15, 10, 11, 14,  1,  7,  6,  0,  8, 13)),

	((4, 11,  2, 14, 15,  0,  8, 13,  3, 12,  9,  7,  5, 10,  6,  1),
	 (13,  0, 11,  7,  4,  9,  1, 10, 14,  3,  5, 12,  2, 15,  8,  6),
	 (1,  4, 11, 13, 12,  3,  7, 14, 10, 15,  6,  8,  0,  5,  9,  2),
	 (6, 11, 13,  8,  1,  4, 10,  7,  9,  5,  0, 15, 14,  2,  3, 12)),

	((13,  2,  8,  4,  6, 15, 11,  1, 10,  9,  3, 14,  5,  0, 12,  7),
	 (1, 15, 13,  8, 10,  3,  7,  4, 12,  5,  6, 11,  0, 14,  9,  2),
	 (7, 11,  4,  1,  9, 12, 14,  2,  0,  6, 10, 13, 15,  3,  5,  8),
	 (2,  1, 14,  7,  4, 10,  8, 13, 15, 12,  9,  0,  3,  5,  6, 11)));

procedure permute(var outbuf, inbuf: array of Byte; var p: array of Integer; n: Integer);
var
  i: Integer;
begin
	for i:=0 to n-1 do
		outbuf[i] := inbuf[p[i]-1];
end;

procedure lshift(var d: array of Byte; count, n: Integer);
var
  outbuf: array [0..63] of Byte;
  i: Integer;
begin
	for i:=0 to n-1 do
		outbuf[i] := d[(i+count) mod n];
	for i:=0 to n-1 do
		d[i] := outbuf[i];
end;

procedure concat(var outbuf, in1, in2: array of Byte; l1, l2: Integer);
var
  pIn, pOut: ^Byte;
begin
   pIn := @In1;
   pOut := @outbuf;
   while l1 > 0 do
   begin
     pOut^ := pIn^;
     inc(pIn);
     inc(pOut);
     dec(l1);
   end;
   pIn := @In2;
   while l2 > 0 do
   begin
     pOut^ := pIn^;
     inc(pIn);
     inc(pOut);
     dec(l2);
   end;
end;


procedure do_xor(var outbuf, in1, in2: array of Byte; n: Integer);
var
  I: Integer;
begin
	for i:=0 to n-1 do
		outbuf[i] := in1[i] xor in2[i];
end;

procedure dohash(var outbuf, inbuf, key: array of Byte);
var
	i, j, k, m, n: Integer;
	pk1: array[0..55] of Byte;
	c: array[0..27] of Byte;
	d: array[0..27] of Byte;
	cd: array[0..55] of Byte;
	ki: array[0..15,0..47] of Byte;
	pd1: array[0..63] of Byte;
	l: array[0..31] of Byte;
        r: array[0..31] of Byte;
	rl: array[0..63] of Byte;
		er: array[0..47] of Byte;
                erk: array[0..47] of Byte;
		b: array[0..7,0..5] of Byte;
		cb: array[0..31] of Byte;
		pcb: array[0..31] of Byte;
		r2: array[0..31] of Byte;

begin

	permute(pk1, key, perm1, 56);

	for i:=0 to 27 do
		c[i] := pk1[i];
        for i:=0 to 27 do
		d[i] := pk1[i+28];

        for i:=0 to 15 do
        begin
		lshift(c, sc[i], 28);
		lshift(d, sc[i], 28);

		concat(cd, c, d, 28, 28);
		permute(ki[i], cd, perm2, 48);
	end;

	permute(pd1, inbuf, perm3, 64);

	for j:=0 to 31 do
        begin
		l[j] := pd1[j];
		r[j] := pd1[j+32];
	end;

        for i:=0 to 15 do
        begin

		permute(er, r, perm4, 48);

		do_xor(erk, er, ki[i], 48);

		for j:=0 to 7 do
			for k:=0 to 5 do
				b[j,k] := erk[j*6 + k];

		for j:=0 to 7 do
                begin

			m := (b[j][0] shl 1) or b[j][5];

			n := (b[j][1] shl 3) or (b[j][2] shl 2) or (b[j][3] shl 1) or b[j][4];

			for k:=0 to 3 do
                              if (sbox[j][m][n] and (1 shl (3-k))) <> 0 then
				b[j][k] := 1
                              else
                                b[j][k] := 0;
		end;

		for j:=0 to 7 do
			for k:=0 to 3 do
				cb[j*4+k] := b[j][k];
		permute(pcb, cb, perm5, 32);

		do_xor(r2, l, pcb, 32);

		for j:=0 to 31 do
			l[j] := r[j];

		for j:=0 to 31 do
			r[j] := r2[j];
	end;

	concat(rl, r, l, 32, 32);

	permute(outbuf, rl, perm6, 64);
end;

(*static void str_to_key(unsigned char *str,unsigned char *key)
{
	int i;

	key[0] = str[0]>>1;
	key[1] = ((str[0]&0x01)<<6) | (str[1]>>2);
	key[2] = ((str[1]&0x03)<<5) | (str[2]>>3);
	key[3] = ((str[2]&0x07)<<4) | (str[3]>>4);
	key[4] = ((str[3]&0x0F)<<3) | (str[4]>>5);
	key[5] = ((str[4]&0x1F)<<2) | (str[5]>>6);
	key[6] = ((str[5]&0x3F)<<1) | (str[6]>>7);
	key[7] = str[6]&0x7F;
	for (i=0;i<8;i++) {
		key[i] = (key[i]<<1);
	}
}*)
{
procedure str_to_key(var str, key: array of Byte);
var
  i: integer;
begin

  key[0] := str[0] shr 1;
  key[1] := ((str[0] and $01) shl 6) or (str[1] shr 2);
  key[2] := ((str[1] and $03) shl 5) or (str[2] shr 3);
  key[3] := ((str[2] and $07) shl 4) or (str[3] shr 4);
  key[4] := ((str[3] and $0F) shl 3) or (str[4] shr 5);
  key[5] := ((str[4] and $1F) shl 2) or (str[5] shr 6);
  key[6] := ((str[5] and $3F) shl 1) or (str[6] shr 7);
  key[7] := str[6] and $7F;
  for i:=0 to 7 do
    key[i] := key[i] shl 1;
end;
}
procedure str_to_key(str, key: PByteArray);
var
  i: integer;
begin

  key^[0] := str^[0] shr 1;
  key^[1] := ((str^[0] and $01) shl 6) or (str^[1] shr 2);
  key^[2] := ((str^[1] and $03) shl 5) or (str^[2] shr 3);
  key^[3] := ((str^[2] and $07) shl 4) or (str^[3] shr 4);
  key^[4] := ((str^[3] and $0F) shl 3) or (str^[4] shr 5);
  key^[5] := ((str^[4] and $1F) shl 2) or (str^[5] shr 6);
  key^[6] := ((str^[5] and $3F) shl 1) or (str^[6] shr 7);
  key^[7] := str^[6] and $7F;
  for i:=0 to 7 do
    key^[i] := key^[i] shl 1;
end;



procedure smbhash(outbuf, inbuf, key: PByteArray);
var
  i: Integer;
  outb: array [0..63] of Byte;
  inb: array [0..63] of Byte;
  keyb: array [0..63] of Byte;
  key2: array [0..7] of Byte;

begin

	str_to_key(key, @key2);

	{for i:=0 to 63 do
        begin
          if
		inb[i] = (in[i/8] & (1<<(7-(i%8)))) ? 1 : 0;
		keyb[i] = (key2[i/8] & (1<<(7-(i%8)))) ? 1 : 0;
		outb[i] = 0;
	}
	for i:=0 to 63 do
        begin
          if (inbuf[i div 8] and (1 shl (7-(i mod 8)))) <> 0 then
            inb[i] := 1
          else
           inb[i] := 0;

          if (key2[i div 8] and (1 shl (7-(i mod 8)))) <> 0 then
            keyb[i] :=  1
           else
            keyb[i] :=  0;
          outb[i] := 0;
	end;


	dohash(outb, inb, keyb);

	for i:=0 to 7 do
		outbuf[i] := 0;

	for i:=0 to 63 do
        begin
		if (outb[i] <> 0) then
			outbuf[i div 8] := outbuf[i div 8] or (1 shl (7-(i mod 8)));
	end;
end;

procedure E_P16(var p14, p16: array of Byte);
const
  sp8: array [0..7] of Byte = ($4b, $47, $53, $21, $40, $23, $24, $25);
begin

	smbhash(@p16, @sp8, @p14);
	smbhash(@p16[8], @sp8, @p14[7]);
end;

{procedure E_P16(var sp14, sp16: RawUtf8);
const
  sp8: array [0..7] of Byte = ($4b, $47, $53, $21, $40, $23, $24, $25);
var
  p16: array [0..15] of Byte;
  p14: array [0..13] of Byte;
  i: Integer;
begin
  fillchar(p16, SizeOf(p16), 0);
  fillchar(p14, SizeOf(p14), 0);
  for i := 0 to Length(sp14)-1 do
    p14[i] := Byte(sp14[i+1]);

	smbhash(@p16, @sp8, @p14);
	smbhash(@p16[8], @sp8, @p14[7]);

  for i := 0 to 15 do
    sp16[i+1] := Char(p16[i]);

end;}

function E_P16(inStr: RawUtf8): RawUtf8;
const
  sp8: array [0..7] of Byte = ($4b, $47, $53, $21, $40, $23, $24, $25);
var
  i: Integer;
begin
  for I := Length(InStr) to 14 do
    InStr := InStr + #0;
  SetLength(Result, 16);
  smbhash(@Result[1], @sp8, @inStr[1]);
  smbhash(@Result[9], @sp8, @InStr[8]);

end;


(*void E_P24(unsigned char *p21, unsigned char *c8, unsigned char *p24)
{
	smbhash(p24, c8, p21);
	smbhash(p24+8, c8, p21+7);
	smbhash(p24+16, c8, p21+14);
}

void cred_hash1(unsigned char *out,unsigned char *in,unsigned char *key)
{
	unsigned char buf[8];

	smbhash(buf, in, key);
	smbhash(out, buf, key+9);
}

void cred_hash2(unsigned char *out,unsigned char *in,unsigned char *key)
{
	unsigned char buf[8];
	static unsigned char key2[8];

	smbhash(buf, in, key);
	key2[0] = key[7];
	smbhash(out, buf, key2);
}*)



end.
