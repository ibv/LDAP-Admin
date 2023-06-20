unit md5crypt;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

{
/*
 * ----------------------------------------------------------------------------
 * "THE BEER-WARE LICENSE" (Revision 42):
 * <phk@login.dknet.dk> wrote this file.  As long as you retain this notice you
 * can do whatever you want with this stuff. If we meet some day, and you think
 * this stuff is worth it, you can buy me a beer in return.   Poul-Henning Kamp
 * ----------------------------------------------------------------------------
 */

/*
 * Ported from FreeBSD to Linux, only minimal changes.  --marekm
 */

/*
 * Adapted from shadow-19990607 by Tudor Bosman, tudorb@jm.nu
 */

 Ported to Pascal by Tihomir Karlovic, as is, with all it's weirdness :-)

}

interface

uses
  mormot.core.base;

function md5_crypt_s(pw, salt: AnsiString): RawUtf8;

implementation

uses md5, Hash, Sysutils;

const
 itoa64: array[0..63] of AnsiChar =		{ 0 ... 63 => ascii - 64 }
	'./0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz';

 magic: AnsiString = '$1$';	                 {
				 * This RawUtf8 is magic for
				 * this algorithm.  Having
				 * it this way, we can get
				 * get better later on
				 }

procedure to64(s: PAnsiChar; v: Cardinal; n: Integer);
begin
     while (n > 0) do
     begin
          s^ := itoa64[v and $3f];
          inc(s);
          v := v shr 6;
          dec(n);
     end;
end;

function is_md5_salt(const salt: PAnsiChar): Integer;
begin
	Result :=  not strlcomp(salt, PAnsiChar(magic), strlen(PAnsiChar(magic)));
end;

procedure Concat(var s: AnsiString; p: Pointer; Count: Integer);
var
  l: Integer;
begin
  l := Length(s);
  SetLength(s, l + Count);
  Move(p^, s[l + 1], Count);
end;

{*
 * UNIX password
 *
 * Use MD5 for what it is best at...
 *}

function md5_crypt(pw, salt: PAnsiChar): AnsiString;
var
	passwd: array[0..119] of AnsiChar;
  p: PAnsiChar;
  final: TMD5Digest;
	pl,i: Integer;
	l: Cardinal;
  s1, s2: AnsiString;
begin

        s1 := pw + magic + salt;
        s2 := '' + pw + salt + pw;
        MD5Full(final, @s2[1], Length(s2));

        pl := strlen(pw);
        while pl > 0 do
        begin
          if pl > 16 then
            Concat(s1, @final, 16)
          else
            Concat(s1, @final, pl);
          Dec(pl, 16);
        end;

	//* Don't leave anything around in vm they could use. */
	FillChar(final,sizeof(final),0);

	//* Then something really weird... */
        i := strlen(pw);
        while i > 0 do
        begin
		      if (i and 1 <> 0) then
              s1 := s1 + #0
		      else
              s1 := s1 + pw[0];
          i := i shr 1;
        end;

        MD5Full(final, @s1[1], Length(s1));

       	{/*
	 * and now, just to make sure things don't run too fast
	 * On a 60 Mhz Pentium this takes 34 msec, so you would
	 * need 30 seconds to build a 1000 entry dictionary...
	 */}
	for i:=0 to 999 do
        begin
                s2 := '';
		if i and 1 <> 0 then
                        s2 := s2 + pw
		else
                        Concat(s2, @final, 16);

		if i mod 3 <> 0 then
                        s2 := s2 + salt;

		if i mod 7 <> 0 then
                        s2 := s2 + pw;

		if i and 1 <> 0 then
                        Concat(s2, @final, 16)
		else
                        s2 := s2 + pw;
                MD5Full(final, @s2[1], Length(s2));
	end;

        p := passwd;

	l := (final[ 0] shl 16) or (final[ 6] shl 8) or final[12]; to64(p,l,4); Inc(p, 4);
	l := (final[ 1] shl 16) or (final[ 7] shl 8) or final[13]; to64(p,l,4); Inc(p, 4);
	l := (final[ 2] shl 16) or (final[ 8] shl 8) or final[14]; to64(p,l,4); Inc(p, 4);
	l := (final[ 3] shl 16) or (final[ 9] shl 8) or final[15]; to64(p,l,4); Inc(p, 4);
	l := (final[ 4] shl 16) or (final[10] shl 8) or final[ 5]; to64(p,l,4); Inc(p, 4);
	l :=                    final[11]                ; to64(p,l,2); Inc(p, 2);
	p^ := #0;

	//* Don't leave anything around in vm they could use. */
	fillchar(final,sizeof(final),0);

	Result := magic + salt + '$' + passwd;
end;

function md5_crypt_s(pw, salt: AnsiString): RawUtf8;
begin
  Result := RawUtf8(md5_crypt(PAnsiChar(pw), PAnsiChar(salt)));
end;

end.
