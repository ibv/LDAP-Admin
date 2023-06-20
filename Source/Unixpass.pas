
{Conversion of the 'C' password encryption algorythm of the same name}
{12/05/97 - atanas stoyanov  - e-mail : astoyanov@nidlink.com}

unit Unixpass;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

Interface
uses
  SysUtils, mormot.core.base;

function UnixCrypt(salt, key: AnsiString): RawUtf8;

implementation
type unsigned = shortint;
type int      = smallint;
type Punsigned = ^unsigned;
var Passwd : array[0..15] of AnsiChar;

type block = record
              b_data : array[0..63] of unsigned;
             end;
     pblock = ^block;
type ordering = record
                  o_data : array [0..63] of unsigned;
               end;
Pordering = ^ordering;
var key : block;
const InitialTr : ordering =
	 (o_data:(58,50,42,34,26,18,10, 2,60,52,44,36,28,20,12, 4,
     62,54,46,38,30,22,14, 6,64,56,48,40,32,24,16, 8,
     57,49,41,33,25,17, 9, 1,59,51,43,35,27,19,11, 3,
	  61,53,45,37,29,21,13, 5,63,55,47,39,31,23,15, 7 ));

const FinalTr : ordering =
	 (o_data:(40, 8,48,16,56,24,64,32,39, 7,47,15,55,23,63,31,
     38, 6,46,14,54,22,62,30,37, 5,45,13,53,21,61,29,
     36, 4,44,12,52,20,60,28,35, 3,43,11,51,19,59,27,
	  34, 2,42,10,50,18,58,26,33, 1,41, 9,49,17,57,25 ));

const swap   : ordering =
	 (o_data:(33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,
     49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,
      1, 2, 3, 4, 5, 6, 7, 8, 9,10,11,12,13,14,15,16,
	  17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32));

const KeyTr1 : ordering =
	 (o_data:(57,49,41,33,25,17, 9, 1,58,50,42,34,26,18,
     10, 2,59,51,43,35,27,19,11, 3,60,52,44,36,
     63,55,47,39,31,23,15, 7,62,54,46,38,30,22,
	  14, 6,61,53,45,37,29,21,13, 5,28,20,12, 4,0,0,0,0,0,0,0,0));


const KeyTr2 : ordering =
	 (o_data:(14,17,11,24, 1, 5, 3,28,15, 6,21,10,
     23,19,12, 4,26, 8,16, 7,27,20,13, 2,
     41,52,31,37,47,55,30,40,51,45,33,48,
	  44,49,39,56,34,53,46,42,50,36,29,32,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0));

const etr : ordering =
	 (o_data:(32, 1, 2, 3, 4, 5, 4, 5, 6, 7, 8, 9,
      8, 9,10,11,12,13,12,13,14,15,16,17,
     16,17,18,19,20,21,20,21,22,23,24,25,
	  24,25,26,27,28,29,28,29,30,31,32, 1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0));


const ptr : ordering =
	 (o_data:( 16, 7,20,21,29,12,28,17, 1,15,23,26, 5,18,31,10,
		2, 8,24,14,32,27, 3, 9,19,13,30, 6,22,11, 4,25,
                0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 ));

                
const s_boxes : array[0..7,0..63] of unsigned =
   (( 14, 4,13, 1, 2,15,11, 8, 3,10, 6,12, 5, 9, 0, 7,
      0,15, 7, 4,14, 2,13, 1,10, 6,12,11, 9, 5, 3, 8,
      4, 1,14, 8,13, 6, 2,11,15,12, 9, 7, 3,10, 5, 0,
     15,12, 8, 2, 4, 9, 1, 7, 5,11, 3,14,10, 0, 6,13
   ),
   ( 15, 1, 8,14, 6,11, 3, 4, 9, 7, 2,13,12, 0, 5,10,
      3,13, 4, 7,15, 2, 8,14,12, 0, 1,10, 6, 9,11, 5,
      0,14, 7,11,10, 4,13, 1, 5, 8,12, 6, 9, 3, 2,15,
     13, 8,10, 1, 3,15, 4, 2,11, 6, 7,12, 0, 5,14, 9
   ),
   (10, 0, 9,14, 6, 3,15, 5, 1,13,12, 7,11, 4, 2, 8,
     13, 7, 0, 9, 3, 4, 6,10, 2, 8, 5,14,12,11,15, 1,
     13, 6, 4, 9, 8,15, 3, 0,11, 1, 2,12, 5,10,14, 7,
      1,10,13, 0, 6, 9, 8, 7, 4,15,14, 3,11, 5, 2,12
   ),
   (  7,13,14, 3, 0, 6, 9,10, 1, 2, 8, 5,11,12, 4,15,
     13, 8,11, 5, 6,15, 0, 3, 4, 7, 2,12, 1,10,14, 9,
     10, 6, 9, 0,12,11, 7,13,15, 1, 3,14, 5, 2, 8, 4,
      3,15, 0, 6,10, 1,13, 8, 9, 4, 5,11,12, 7, 2,14
   ),
   (  2,12, 4, 1, 7,10,11, 6, 8, 5, 3,15,13, 0,14, 9,
     14,11, 2,12, 4, 7,13, 1, 5, 0,15,10, 3, 9, 8, 6,
      4, 2, 1,11,10,13, 7, 8,15, 9,12, 5, 6, 3, 0,14,
     11, 8,12, 7, 1,14, 2,13, 6,15, 0, 9,10, 4, 5, 3
   ),
   ( 12, 1,10,15, 9, 2, 6, 8, 0,13, 3, 4,14, 7, 5,11,
     10,15, 4, 2, 7,12, 9, 5, 6, 1,13,14, 0,11, 3, 8,
      9,14,15, 5, 2, 8,12, 3, 7, 0, 4,10, 1,13,11, 6,
      4, 3, 2,12, 9, 5,15,10,11,14, 1, 7, 6, 0, 8,13
   ),
   (  4,11, 2,14,15, 0, 8,13, 3,12, 9, 7, 5,10, 6, 1,
     13, 0,11, 7, 4, 9, 1,10,14, 3, 5,12, 2,15, 8, 6,
      1, 4,11,13,12, 3, 7,14,10,15, 6, 8, 0, 5, 9, 2,
      6,11,13, 8, 1, 4,10, 7, 9, 5, 0,15,14, 2, 3,12
   ),
   ( 13, 2, 8, 4, 6,15,11, 1,10, 9, 3,14, 5, 0,12, 7,
      1,15,13, 8,10, 3, 7, 4,12, 5, 6,11, 0,14, 9, 2,
      7,11, 4, 1, 9,12,14, 2, 0, 6,10,13,15, 3, 5, 8,
      2, 1,14, 7, 4,10, 8,13,15,12, 9, 0, 3, 5, 6, 11
   ));

const  rots : array[0..15] of int =
     (1,1,2,2,2,2,2,2,1,2,2,2,2,2,2,1);


procedure transpose(var data : block;var t : ordering;n : int);
var x : block;
begin
  x := data;
  dec(n);
  while(n >= 0) do
  begin
    data.b_data[n] := x.b_data[t.o_data[n]-1];
    dec(n);
  end;

end;

procedure rotate(var key : block);
var p : PAnsiChar;
var ep : PAnsiChar;
var data0 : int;
var data28 : int;
begin
  p  := @key.b_data;
  ep := @(key.b_data[55]);
  data0 :=  key.b_data[0];
  data28 := key.b_data[28];
  while (p < ep) do
  begin
    inc(p);
    (p-1)^ := p^;
  end;
  key.b_data[27] := data0;
  key.b_data[55] := data28;
end;

const  EP : Pordering = @etr;

procedure f(i : int;var key : block;var a : block;var x : block);
var e, ikey, y : block;
var k : int;
var p, q, r : PAnsiChar;
var xb,ri   : int;
begin
  e := a;
  transpose(e,EP^,48);
  for k := rots[i] downto 1 do rotate(key);
  ikey := key;
  transpose(ikey,KeyTr2,48);
  p := @(y.b_data[48]);
  q := @(e.b_data[48]);
  r := @(ikey.b_data[48]);
  while (p > @y.b_data) do
  begin
    dec(p);
    dec(q);
    dec(r);
    p^ := AnsiChar(int(q^) XOR int(r^)); //^
  end;
  q := @x.b_data;
  for k := 0 to 7 do
  begin
    ri := unsigned(p^) SHL  5;
    inc(p);
    ri := ri + (unsigned(p^) SHL  3);
    inc(p);
    ri := ri + (unsigned(p^) SHL 2);
    inc(p);
    ri := ri + (unsigned(p^) SHL 1);
    inc(p);
    ri := ri + unsigned(p^);
    inc(p);
    ri := ri + (unsigned(p^) SHL 4);
    inc(p);
    xb := s_boxes[k][ri];

    q^ := AnsiChar((xb SHR 3) AND 1);
    inc(q);
    q^ := AnsiChar((xb SHR 2) AND 1);
    inc(q);
    q^ := AnsiChar((xb SHR 1) AND 1);
    inc(q);
    q^ := AnsiChar(xb  AND 1);
    inc(q);
  end;
  transpose(x,ptr,32);
end;

procedure setkey(k : PAnsiChar);
begin
  key := pblock(k)^;
  transpose(key,KeyTr1,56);
end;

procedure myencrypt(blck : PAnsiChar;edflag : int);
var p : PBlock;
var i : int;
var j : int;
var k : int;
var b, x : block;
begin
  p := pblock( blck );
  transpose(p^,InitialTr,64);
  for i := 15 downto 0 do
  begin
    if edflag <> 0 then
      j := i else j := 15 - i;
    b := p^;
    for k :=31 downto 0 do
    begin
      p^.b_data[k] := b.b_data[k+32];
    end;
    f(j,key,p^,x);
    for k :=31 downto 0 do
    begin
      p^.b_data[k+32] := b.b_data[k] XOR x.b_data[k];
    end;
  end;
  transpose(p^,swap,64);
  transpose(p^,FinalTr,64);
end;

procedure mycrypt(pw : PAnsiChar;salt : PAnsiChar;Result : PAnsiChar);

var pwb : array [0..65] of AnsiChar;

var  p : PAnsiChar;
var  new_etr : ordering;
var  i : int ;
var  j : int ;
var  c : AnsiChar;
var  t : int;
var temp : int;
var  ci : int;
begin
  p := pwb;
  while (pw^ <> #0)  AND ( p < @pwb[64]) do
  begin
     j := 6;
     while (j >= 0) do
     begin
       p^ := AnsiChar((int(pw^) SHR j) AND 01);
       inc(p);
       dec(j);
     end;
     inc(pw);
     p^ := #0;
     inc(p);
  end;
  while (p < @pwb[64]) do
  begin
    p^ := #0;
    inc(p);
  end;
  p := pwb;
  setkey(p);
  while(p <= @pwb[65]) do
  begin
    p^ := #0;
    inc(p);
  end;
  new_etr :=etr;
  EP := @new_etr;
  for i := 0 to 1 do
  begin
    c := salt^;
    inc(salt);
    result[i] := c;
    if (c >'Z') then c := AnsiChar(int(c) - (6+7+ int('.'))) else
       if (c > '9') then  c := AnsiChar(int(c) - (7+ int('.')))
        else c := AnsiChar(int(c) - int('.'));
    for j :=0 to 5 do
    begin
      if((int(c) SHR j) AND 01) <> 0 then
      begin
        t := 6*i + j;
        temp := new_etr.o_data[t];
        new_etr.o_data[t] := new_etr.o_data[t+24];
	new_etr.o_data[t+24] := temp;
      end;
    end;
  end;
  if (result[1] = #0) then result[1] := result[0];

  for i :=0 to 24 do myencrypt(pwb,0);

  EP := @etr;
  p  := pwb;
  pw := result+2;
  while p <= @pwb[65] do
  begin
    ci := 0;
    j := 6;
    while j <> 0 do
    begin
      ci := ci SHL 1;
      ci := ci OR INT(p^);
      inc(p);
      dec(j);
    end;
    ci := ci + int('.');
    if (ci > int('9')) then  ci := ci + 7;
    if (ci > int('Z')) then ci := ci + 6;
    pw^:= AnsiChar(ci);
    inc(pw)
  end;
  //*pw=0;
end;


function UnixCrypt(Salt, Key: AnsiString): RawUtf8;
begin
  mycrypt(PAnsiChar(key), PAnsiChar(salt), Passwd);
  Result := Passwd;
end;

end.
