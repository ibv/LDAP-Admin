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

 Ported to Pascal by Tihomir Karlovic 

}

interface

function md5_crypt(pw, salt: PChar): string;

implementation

uses {DECHash,} Sysutils;

const
 itoa64: array[0..63] of Char =		{ 0 ... 63 => ascii - 64 }
	'./0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz';

 magic = '$1$';	                 {
				 * This string is magic for
				 * this algorithm.  Having
				 * it this way, we can get
				 * get better later on
				 }

procedure to64(s: PChar; v: Cardinal; n: Integer);
begin
     while (n > 0) do
     begin
          s^ := itoa64[v and $3f];
          inc(s);
          v := v shr 6;
          dec(n);
     end;
end;

function is_md5_salt(const salt: PChar): Integer;
begin
	//Result :=  not strlcomp(salt, magic, strlen(magic));
	Result :=  not strlcomp(salt, magic, length(magic));
end;

procedure Concat(var s: string; p: Pointer; Count: Integer);
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

function md5_crypt(pw, salt: PChar): string;
var
	passwd: array[0..119] of Char;
        p: PChar;
	final: array[0..15] of Byte;
	pl,i: Integer;
	l: Cardinal;
        ///md1, md2: THash_MD5;
        s1, s2: string;
begin

	///md1 := THash_MD5.Create;
        ///md2 := THash_MD5.Create;

        s1 := pw + magic + salt;
        s2 := '' + pw + salt + pw;
        ///md2.Init;
        ///md2.Calc(s2[1], Length(s2));
        ///md2.Done;

        ///Move(md2.Digest^, final, md2.DigestSize);
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
	FillChar(final,0,sizeof(final));

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

        ///md1.Init;
        ///md1.Calc(s1[1], Length(s1));
        ///md1.Done;

        ///Move(md1.Digest^, final, md1.DigestSize);

       	{/*
	 * and now, just to make sure things don't run too fast
	 * On a 60 Mhz Pentium this takes 34 msec, so you would
	 * need 30 seconds to build a 1000 entry dictionary...
	 */}
	for i:=0 to 999 do
        begin
                s2 := '';
                ///md2.Init;
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
                ///md2.Calc(s2[1], Length(s2));
                ///md2.Done;
                ///Move(md2.Digest^, final, md2.DigestSize);
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
	fillchar(final,0,sizeof(final));

        ///md1.Free;
        ///md2.Free;

	Result := magic + salt + '$' + passwd;
end;

end.
