{-Test prog for HMACs, we 03.2012}

program t_hmac;

{$i STD.INC}

{$ifdef APPCONS}
  {$apptype console}
{$endif}


uses
  {$ifdef WINCRT}
    WinCRT,
  {$endif}
  hash,hmac,md4,md5,sha1,sha224,sha256,sha384,
  sha512,sha5_256,sha5_224,whirl512,rmd160,
  BTypes, mem_util;


const
  data1 : array[1..8]  of char8 = 'Hi There';
  data2 : array[1..28] of char8 = 'what do ya want for nothing?';
  data6 : array[1..54] of char8 = 'Test Using Larger Than Block-Size Key - Hash Key First';
  data7 : array[1..73] of char8 = 'Test Using Larger Than Block-Size Key and Larger Than One Block-Size Data';

  key2  = 'Jefe';

var
  key6: array[1..80] of char8; {#$aa repeated 80 times}
  key7: array[1..80] of char8; {#$aa repeated 80 times}


{---------------------------------------------------------------------------}
procedure Test_HMAC_MD5;
  {-MD5 test cases from RFC2202}
const
  DigLen = sizeof(TMD5Digest);
const
  key1  : string[16] = #$b#$b#$b#$b#$b#$b#$b#$b#$b#$b#$b#$b#$b#$b#$b#$b;
  dig1  : array[1..16] of byte = ($92, $94, $72, $7a, $36, $38, $bb, $1c,
                                  $13, $f4, $8e, $f8, $15, $8b, $fc, $9d);
const
  dig2  : array[1..16] of byte = ($75, $0c, $78, $3e, $6a, $b0, $b5, $03,
                                  $ea, $a8, $6e, $31, $0a, $5d, $b7, $38);
const
  dig6  : array[1..16] of byte = ($6b, $1a, $b7, $fe, $4b, $d7, $bf, $8f,
                                  $0b, $62, $e6, $ce, $61, $b9, $d0, $cd);
const
  dig7  : array[1..16] of byte = ($6f, $63, $0f, $ad, $67, $cd, $a0, $ee,
                                  $1f, $b1, $f5, $62, $db, $3a, $a5, $3e);

var
  ctx  : THMAC_Context;
  mac  : THashDigest;
  phash: PHashDesc;

begin
  writeln('=========== HMAC MD5 self test cf. RFC 2202');
  phash := FindHash_by_Name('MD5');
  if phash=nil then begin
    writeln('Hash function not found/registered.');
    exit;
  end;
  write('Test  1');
  hmac_inits(ctx, phash, key1);
  hmac_update(ctx, @data1, sizeof(data1));
  hmac_final(ctx, mac);
  if compmem(@mac,  @dig1, DigLen) then writeln('  TRUE')
  else begin
    writeln(' FALSE');
    writeln(' RFC: ', HexStr(@dig1, DigLen));
    writeln('Code: ', HexStr(@mac,  DigLen));
  end;

  write('Test  2');
  hmac_inits(ctx, phash, key2);
  hmac_update(ctx, @data2, sizeof(data2));
  hmac_final(ctx, mac);
  if compmem(@mac,  @dig2, DigLen) then writeln('  TRUE')
  else begin
    writeln(' FALSE');
    writeln(' RFC: ', HexStr(@dig2, DigLen));
    writeln('Code: ', HexStr(@mac,  DigLen));
  end;

  write('Test  6');
  hmac_init(ctx, phash, @key6, sizeof(key6));
  hmac_update(ctx, @data6, sizeof(data6));
  hmac_final(ctx, mac);
  if compmem(@mac,  @dig6, DigLen) then writeln('  TRUE')
  else begin
    writeln(' FALSE');
    writeln(' RFC: ', HexStr(@dig6, DigLen));
    writeln('Code: ', HexStr(@mac , DigLen));
  end;

  write('Test  7');
  hmac_init(ctx, phash, @key7, sizeof(key7));
  hmac_update(ctx, @data7, sizeof(data7));
  hmac_final(ctx, mac);
  if compmem(@mac,  @dig7, DigLen) then writeln('  TRUE')
  else begin
    writeln(' FALSE');
    writeln(' RFC: ', HexStr(@dig7, DigLen));
    writeln('Code: ', HexStr(@mac,  DigLen));
  end;

end;


{---------------------------------------------------------------------------}
procedure Test_RMD160;
  {-Eight tests for HMAC-RIPEMD-160 from Antoon Bosselaers' page}
const
  key: array[1..2] of TRMD160Digest = (
    ($00,$11,$22,$33,$44,$55,$66,$77,$88,$99,$aa,$bb,$cc,$dd,$ee,$ff,$01,$23,$45,$67),
    ($01,$23,$45,$67,$89,$ab,$cd,$ef,$fe,$dc,$ba,$98,$76,$54,$32,$10,$00,$11,$22,$33));
  dig: array[1..8] of TRMD160Digest = (
    {'' (empty string)}
    ($cf,$38,$76,$77,$bf,$da,$84,$83,$e6,$3b,$57,$e0,$6c,$3b,$5e,$cd,$8b,$7f,$c0,$55),
    ($fe,$69,$a6,$6c,$74,$23,$ee,$a9,$c8,$fa,$2e,$ff,$8d,$9d,$af,$b4,$f1,$7a,$62,$f5),
    {'abc'}
    ($f7,$ef,$28,$8c,$b1,$bb,$cc,$61,$60,$d7,$65,$07,$e0,$a3,$bb,$f7,$12,$fb,$67,$d6),
    ($6e,$4a,$fd,$50,$1f,$a6,$b4,$a1,$82,$3c,$a3,$b1,$0b,$d9,$aa,$0b,$a9,$7b,$a1,$82),
    {'message digest'}
    ($f8,$36,$62,$cc,$8d,$33,$9c,$22,$7e,$60,$0f,$cd,$63,$6c,$57,$d2,$57,$1b,$1c,$34),
    ($2e,$06,$6e,$62,$4b,$ad,$b7,$6a,$18,$4c,$8f,$90,$fb,$a0,$53,$33,$0e,$65,$0e,$92),
    {'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789'}
    ($e4,$9c,$13,$6a,$9e,$56,$27,$e0,$68,$1b,$80,$8a,$3b,$97,$e6,$a6,$e6,$61,$ae,$79),
    ($f1,$be,$3e,$e8,$77,$70,$31,$40,$d3,$4f,$97,$ea,$1a,$b3,$a0,$7c,$14,$13,$33,$e2));
  data: array[0..3] of string[80] = ( '', 'abc', 'message digest',
    'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789');
const
  DigLen = sizeof(TRMD160Digest);
var
  i,j,k: integer;
var
  ctx  : THMAC_Context;
  mac  : THashDigest;
  phash: PHashDesc;
begin
  writeln('=========== HMAC RIPEMD-160 from Antoon Bosselaers'' web page');
  phash := FindHash_by_Name('RIPEMD160');
  if phash=nil then begin
    writeln('Hash function not found/registered.');
    exit;
  end;
  for i:=0 to 3 do begin
    for k:=1 to 2 do begin
      j := 2*i+k;
      write('Test ',j);
      hmac_init(ctx, phash, @key[k], sizeof(key[k]));
      hmac_update(ctx, @data[i][1], length(data[i]));
      hmac_final(ctx, mac);
      if compmem(@mac,  @dig[j], DigLen) then writeln('  TRUE')
      else begin
        writeln(' FALSE');
        writeln(' Ref: ', HexStr(@dig[j], DigLen));
        writeln('Code: ', HexStr(@mac,  DigLen));
      end;
    end;
  end;
end;


{---------------------------------------------------------------------------}
procedure Test_HMAC_SHA1;
  {-SHA1 test cases from RFC2202}

const
  DigLen = sizeof(TSHA1Digest);

const
  key1  : string[20] = #$b#$b#$b#$b#$b#$b#$b#$b#$b#$b#$b#$b#$b#$b#$b#$b#$b#$b#$b#$b;
  dig1  : array[1..20] of byte = ($b6, $17, $31, $86, $55, $05, $72, $64, $e2, $8b,
                                  $c0, $b6, $fb, $37, $8c, $8e, $f1, $46, $be, $00);
const
  dig2  : array[1..20] of byte = ($ef, $fc, $df, $6a, $e5, $eb, $2f, $a2, $d2, $74,
                                  $16, $d5, $f1, $84, $df, $9c, $25, $9a, $7c, $79);
const
  dig6  : array[1..20] of byte = ($aa, $4a, $e5, $e1, $52, $72, $d0, $0e, $95, $70,
                                  $56, $37, $ce, $8a, $3b, $55, $ed, $40, $21, $12);
const
  dig7  : array[1..20] of byte = ($e8, $e9, $9d, $0f, $45, $23, $7d, $78, $6d, $6b,
                                  $ba, $a7, $96, $5c, $78, $08, $bb, $ff, $1a, $91);

var
  ctx  : THMAC_Context;
  mac  : THashDigest;
  phash: PHashDesc;

begin
  writeln('=========== HMAC SHA1 self test cf. RFC 2202');
  phash := FindHash_by_Name('SHA1');
  if phash=nil then begin
    writeln('Hash function not found/registered.');
    exit;
  end;
  write('Test  1');
  hmac_inits(ctx, phash, key1);
  hmac_update(ctx, @data1, sizeof(data1));
  hmac_final(ctx, mac);
  if compmem(@mac,  @dig1, DigLen) then writeln('  TRUE')
  else begin
    writeln(' FALSE');
    writeln(' RFC: ', HexStr(@dig1, DigLen));
    writeln('Code: ', HexStr(@mac,  DigLen));
  end;

  write('Test  2');
  hmac_inits(ctx, phash, key2);
  hmac_update(ctx, @data2, sizeof(data2));
  hmac_final(ctx, mac);
  if compmem(@mac,  @dig2, DigLen)  then writeln('  TRUE')
  else begin
    writeln(' FALSE');
    writeln(' RFC: ', HexStr(@dig2, DigLen));
    writeln('Code: ', HexStr(@mac,  DigLen));
  end;

  write('Test  6');
  hmac_init(ctx, phash, @key6, sizeof(key6));
  hmac_update(ctx, @data6, sizeof(data6));
  hmac_final(ctx, mac);
  if compmem(@mac,  @dig6, DigLen) then writeln('  TRUE')
  else begin
    writeln(' FALSE');
    writeln(' RFC: ', HexStr(@dig6, DigLen));
    writeln('Code: ', HexStr(@mac , DigLen));
  end;

  write('Test  7');
  hmac_init(ctx, phash, @key7, sizeof(key7));
  hmac_update(ctx, @data7, sizeof(data7));
  hmac_final(ctx, mac);
  if compmem(@mac,  @dig7, DigLen) then writeln('  TRUE')
  else begin
    writeln(' FALSE');
    writeln(' RFC: ', HexStr(@dig7, DigLen));
    writeln('Code: ', HexStr(@mac,  DigLen));
  end;

end;


{---------------------------------------------------------------------------}
procedure Test_HMAC_SHA256;
  {-SHA256 test cases from draft-ietf-ipsec-ciph-sha-256-01.txt}

var
  key1 : array[1..32] of byte;

const
  DigLen = sizeof(TSHA256Digest);

const
  data1: array[0..2] of char8  = 'abc';
  dig1 : array[0..31] of byte  = ($a2, $1b, $1f, $5d, $4c, $f4, $f7, $3a,
                                  $4d, $d9, $39, $75, $0f, $7a, $06, $6a,
                                  $7f, $98, $cc, $13, $1c, $b1, $6a, $66,
                                  $92, $75, $90, $21, $cf, $ab, $81, $81);
const
  data2: array[1..56] of char8 = 'abcdbcdecdefdefgefghfghighijhijkijkljklmklmnlmnomnopnopq';
  dig2 : array[0..31] of byte  = ($10, $4f, $dc, $12, $57, $32, $8f, $08,
                                  $18, $4b, $a7, $31, $31, $c5, $3c, $ae,
                                  $e6, $98, $e3, $61, $19, $42, $11, $49,
                                  $ea, $8c, $71, $24, $56, $69, $7d, $30);

const
  data3: array[1..112] of char8
       = 'abcdbcdecdefdefgefghfghighijhijkijkljklmklmnlmnomnopnopqabcdbcdecdefdefgefghfghighijhijkijkljklmklmnlmnomnopnopq';
  dig3 : array[0..31] of byte  = ($47, $03, $05, $fc, $7e, $40, $fe, $34,
                                  $d3, $ee, $b3, $e7, $73, $d9, $5a, $ab,
                                  $73, $ac, $f0, $fd, $06, $04, $47, $a5,
                                  $eb, $45, $95, $bf, $33, $a9, $d1, $a3);

const
  data5: array[1..28] of char8 = 'what do ya want for nothing?';
  dig5 : array[0..31] of byte  = ($5b, $dc, $c1, $46, $bf, $60, $75, $4e,
                                  $6a, $04, $24, $26, $08, $95, $75, $c7,
                                  $5a, $00, $3f, $08, $9d, $27, $39, $83,
                                  $9d, $ec, $58, $b9, $64, $ec, $38, $43);
const
  dig9 : array[0..31] of byte = ($69, $53, $02, $5e, $d9, $6f, $0c, $09,
                                 $f8, $0a, $96, $f7, $8e, $65, $38, $db,
                                 $e2, $e7, $b8, $20, $e3, $dd, $97, $0e,
                                 $7d, $dd, $39, $09, $1b, $32, $35, $2f);
const
  dig10: array[0..31] of byte = ($63, $55, $ac, $22, $e8, $90, $d0, $a3,
                                 $c8, $48, $1a, $5c, $a4, $82, $5b, $c8,
                                 $84, $d3, $e7, $a1, $ff, $98, $a2, $fc,
                                 $2a, $c7, $d8, $e0, $64, $c3, $b2, $e6);
var
  i: byte;

var
  ctx  : THMAC_Context;
  mac  : THashDigest;
  phash: PHashDesc;

begin
  writeln('=========== HMAC SHA256 self test cf. IETF Draft');
  phash := FindHash_by_Name('SHA256');
  if phash=nil then begin
    writeln('Hash function not found/registered.');
    exit;
  end;
  write('Test  1');
  for i:=1 to 32 do key1[i] := i;
  hmac_init(ctx, phash, @key1, sizeof(key1));
  hmac_update(ctx, @data1, sizeof(data1));
  hmac_final(ctx, mac);
  if compmem(@mac,  @dig1, DigLen) then writeln('  TRUE')
  else begin
    writeln(' FALSE');
    writeln('IETF: ', HexStr(@dig1, DigLen));
    writeln('Code: ', HexStr(@mac,  DigLen));
  end;

  write('Test  2');
  hmac_init(ctx, phash, @key1, sizeof(key1));
  hmac_update(ctx, @data2, sizeof(data2));
  hmac_final(ctx, mac);
  if compmem(@mac,  @dig2, DigLen) then writeln('  TRUE')
  else begin
    writeln(' FALSE');
    writeln('IETF: ', HexStr(@dig2, DigLen));
    writeln('Code: ', HexStr(@mac,  DigLen));
  end;

  write('Test  3');
  hmac_init(ctx, phash, @key1, sizeof(key1));
  hmac_update(ctx, @data3, sizeof(data3));
  hmac_final(ctx, mac);
  if compmem(@mac,  @dig3, DigLen) then writeln('  TRUE')
  else begin
    writeln(' FALSE');
    writeln('IETF: ', HexStr(@dig3, DigLen));
    writeln('Code: ', HexStr(@mac,  DigLen));
  end;

  write('Test  5');
  hmac_inits(ctx, phash, 'Jefe');
  hmac_update(ctx, @data5, sizeof(data5));
  hmac_final(ctx, mac);
  if compmem(@mac,  @dig5, DigLen) then writeln('  TRUE')
  else begin
    writeln(' FALSE');
    writeln('IETF: ', HexStr(@dig5, DigLen));
    writeln('Code: ', HexStr(@mac,  DigLen));
  end;

  write('Test  9');
  hmac_init(ctx, phash, @key6, sizeof(key6));
  hmac_update(ctx, @data6, sizeof(data6));
  hmac_final(ctx, mac);
  if compmem(@mac,  @dig9, DigLen) then writeln('  TRUE')
  else begin
    writeln(' FALSE');
    writeln('IETF: ', HexStr(@dig10, DigLen));
    writeln('Code: ', HexStr(@mac,   DigLen));
  end;

  write('Test 10');
  hmac_init(ctx, phash, @key7, sizeof(key7));
  hmac_update(ctx, @data7, sizeof(data7));
  hmac_final(ctx, mac);
  if compmem(@mac,  @dig10, DigLen) then writeln('  TRUE')
  else begin
    writeln(' FALSE');
    writeln('IETF: ', HexStr(@dig10, DigLen));
    writeln('Code: ', HexStr(@mac,   DigLen));
  end;
end;


{---------------------------------------------------------------------------}
procedure TSD_Test;
  {-From Tom St.Denis' LibTomCrypt 1.0+, last HMAC entries from hmac_tv.txt}
const
  MinTSDH = _MD4;
  MaxTSDH = _Whirlpool;
type
  TSD_HASH = MinTSDH..MaxTSDH;
const
  digs: array[TSD_HASH] of string[128] = (
            'B4FA8DFD3AD4C88EABC8505D4901B057',  {MD4}
            '09F1503BCD00E3A1B965B66B9609E998',  {MD5}
            'AD090CC9A6B381C0B3D87035274FBC056012A4E6', {RMD160}
            '6560BD2CDE7403083527E597C60988BB1EB21FF1', {SHA1}
            '0FF4DA564729A0E9984E15BC69B00FA2E54711573BEE3AD608F511B5', {SHA224}
            '8B185702392BC1E061414539546904553A62510BC2E9E045892D64DAA6B32A76', {SHA256}
            'AA5D7EA1126BF16DA2897AE036E94D1F96875AD306B19910EFE3F17B7A98F9A4163E4032EFD17DDBF78FE3321047509C', {SHA384}
            '6E6A3CDE12F2CB3A42EC8A5D21B435C4DA4DF6CA7E41537D361D8169158287BF1D2241581DE07F88FE92F5AE4E96EB9C'  {SHA512}
               +'489FC3B258EA3842EA2D511CE883883E',
            '4AABF1C3F24C20FFAA61D6106E32EF1BB7CDEB607354BD4B6251893941730054244E198EECD4943C77082CC9B406A2E1'  {Whirlpool}
               +'2271BCA455DF15D3613336615C36B22E');
  rounds: array[TSD_HASH] of integer = (128,128,128,128,128,128,256,256,128);
label
  _continue;  {TP < 7.0}
var
  ctx  : THMAC_Context;
  mac  : THashDigest;
  tdig : THashDigest;
  phash: PHashDesc;
  key  : THashDigest;
  inbuf: array[0..255] of byte;
  algo : THashAlgorithm;
  ldig : word;
  y,z  : integer;
begin
  writeln('=========== Tests from Tom St.Denis'' LibTomCrypt 1.0+');
  for algo := MinTSDH to MaxTSDH do begin
    phash := FindHash_by_ID(algo);
    if phash=nil then begin
      writeln('Hash function not found/registered.');
      goto _continue;
    end;
    write('HMAC '+phash^.HName+': ':18);
    Hex2Mem(digs[algo],@tdig, sizeof(tdig), ldig);
    if ldig<>phash^.HDigestLen then begin
      writeln('Invalid test digest length');
      goto _continue;
    end;
    for z:=0 to ldig-1 do key[z] := z and 255;
    for y:=0 to rounds[algo] do begin
      for z:=0 to y-1 do inbuf[z] := z and 255;
      hmac_init(ctx, phash, @key, ldig);
      hmac_update(ctx, @inbuf, y);
      hmac_final(ctx, mac);
      move(mac,key,ldig);
    end;
    writeln(compmem(@key, @tdig, ldig));
_continue:
  end;
end;


{Tests for HMAC SHA512/224 and SHA512/256}

{** Note: The test cases from this program are NOT taken from public sources}
{**       at the time of writing. They should be considered preliminary and }
{**       are useful for regression testing. They are confirmed in sci.crypt}
{**       see http://groups.google.com/group/sci.crypt/msg/335e9c0cc3827bc0 }

{---------------------------------------------------------------------------}
procedure Test_HMAC_SHA5_256;
const
  DigLen = sizeof(TSHA5_256Digest);
const
  key1 : array[0..19] of byte = ($0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,
                                 $0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,
                                 $0b,$0b,$0b,$0b);
  key2 : array[0..3]  of byte = ($4a,$65,$66,$65);
  dig1 : TSHA5_256Digest =      ($9f,$91,$26,$c3,$d9,$c3,$c3,$30,
                                 $d7,$60,$42,$5c,$a8,$a2,$17,$e3,
                                 $1f,$ea,$e3,$1b,$fe,$70,$19,$6f,
                                 $f8,$16,$42,$b8,$68,$40,$2e,$ab);
  dig2 : TSHA5_256Digest =      ($6d,$f7,$b2,$46,$30,$d5,$cc,$b2,
                                 $ee,$33,$54,$07,$08,$1a,$87,$18,
                                 $8c,$22,$14,$89,$76,$8f,$a2,$02,
                                 $05,$13,$b2,$d5,$93,$35,$94,$56);
var
  ctx: THMAC_Context;
  mac: THashDigest;
  phash: PHashDesc;
begin
  writeln('HMAC_SHA512_256');
  phash := FindHash_by_Name('SHA512/256');
  if phash=nil then begin
    writeln('Hash function not found/registered.');
    exit;
  end;
  write(' Test 1');
  hmac_init(ctx, phash, @key1, sizeof(key1));
  hmac_update(ctx, @data1, sizeof(data1));
  hmac_final(ctx, mac);
  if compmem(@mac,  @dig1, DigLen) then writeln('  TRUE')
  else begin
    writeln(' FALSE');
    writeln('  Ref: ', HexStr(@dig1, DigLen));
    writeln(' Code: ', HexStr(@mac,  DigLen));
  end;
  write(' Test 2');
  hmac_init(ctx, phash, @key2, sizeof(key2));
  hmac_update(ctx, @data2, sizeof(data2));
  hmac_final(ctx, mac);
  if compmem(@mac,  @dig2, DigLen) then writeln('  TRUE')
  else begin
    writeln(' FALSE');
    writeln('  Ref: ', HexStr(@dig2, DigLen));
    writeln(' Code: ', HexStr(@mac,  DigLen));
  end;
end;


{---------------------------------------------------------------------------}
procedure Test_HMAC_SHA5_224;
const
  DigLen = sizeof(TSHA5_224Digest);

const
  key1 : array[0..19] of byte = ($0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,
                                 $0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,
                                 $0b,$0b,$0b,$0b);
  key2 : array[0..3]  of byte = ($4a,$65,$66,$65);
  dig1 : TSHA5_224Digest =      ($b2,$44,$ba,$01,$30,$7c,$0e,$7a,
                                 $8c,$ca,$ad,$13,$b1,$06,$7a,$4c,
                                 $f6,$b9,$61,$fe,$0c,$6a,$20,$bd,
                                 $a3,$d9,$20,$39);
  dig2 : TSHA5_224Digest =      ($4a,$53,$0b,$31,$a7,$9e,$bc,$ce,
                                 $36,$91,$65,$46,$31,$7c,$45,$f2,
                                 $47,$d8,$32,$41,$df,$b8,$18,$fd,
                                 $37,$25,$4b,$de);
var
  ctx: THMAC_Context;
  mac: THashDigest;
  phash: PHashDesc;
begin
  writeln('HMAC_SHA512/224');
  phash := FindHash_by_Name('SHA512/224');
  if phash=nil then begin
    writeln('Hash function not found/registered.');
    exit;
  end;
  write(' Test 1');
  hmac_init(ctx, phash, @key1, sizeof(key1));
  hmac_update(ctx, @data1, sizeof(data1));
  hmac_final(ctx, mac);
  if compmem(@mac,  @dig1, DigLen) then writeln('  TRUE')
  else begin
    writeln(' FALSE');
    writeln('  Ref: ', HexStr(@dig1, DigLen));
    writeln(' Code: ', HexStr(@mac,  DigLen));
  end;
  write(' Test 2');
  hmac_init(ctx, phash, @key2, sizeof(key2));
  hmac_update(ctx, @data2, sizeof(data2));
  hmac_final(ctx, mac);
  if compmem(@mac,  @dig2, DigLen) then writeln('  TRUE')
  else begin
    writeln(' FALSE');
    writeln('  Ref: ', HexStr(@dig2, DigLen));
    writeln(' Code: ', HexStr(@mac,  DigLen));
  end;
end;


begin
  {$ifdef WINCRT}
    ScreenSize.Y := 50;  {D1: 50 lines screen}
  {$endif}

  fillchar(key6, sizeof(key6), #$aa);
  fillchar(key7, sizeof(key7), #$aa);

  Test_HMAC_MD5;    writeln;
  Test_RMD160;      writeln;
  Test_HMAC_SHA1;   writeln;
  Test_HMAC_SHA256; writeln;
  TSD_Test;
  writeln;
  writeln('=========== Tests for SHA512/224 and SHA512/256');
  Test_HMAC_SHA5_224;
  Test_HMAC_SHA5_256;
end.
