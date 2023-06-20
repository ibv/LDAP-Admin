  {      LDAPAdmin - Cp.pas
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

unit Cp;

{$I LdapAdmin.inc}

interface

{$ifdef WINDOWS}
uses
  Windows;
{$endif}


function GetCodepageName: string;

type
  TCPData = record
    CPID: LongWord;
    CPName: String;
  end;

const
  MaxEncodings = 140;
  { See http://stackoverflow.com/questions/2574289/codepage-id-to-codepage-name-getencoding-equivalent-in-delphi }
  Encodings: Array[0..MaxEncodings - 1] of TCPData =
  (
    (CPID: 37; CPName: 'IBM037'),
    (CPID: 437; CPName: 'IBM437'),
    (CPID: 500; CPName: 'IBM500'),
    (CPID: 708; CPName: 'ASMO-708'),
    (CPID: 720; CPName: 'DOS-720'),
    (CPID: 737; CPName: 'ibm737'),
    (CPID: 775; CPName: 'ibm775'),
    (CPID: 850; CPName: 'ibm850'),
    (CPID: 852; CPName: 'ibm852'),
    (CPID: 855; CPName: 'IBM855'),
    (CPID: 857; CPName: 'ibm857'),
    (CPID: 858; CPName: 'IBM00858'),
    (CPID: 860; CPName: 'IBM860'),
    (CPID: 861; CPName: 'ibm861'),
    (CPID: 862; CPName: 'DOS-862'),
    (CPID: 863; CPName: 'IBM863'),
    (CPID: 864; CPName: 'IBM864'),
    (CPID: 865; CPName: 'IBM865'),
    (CPID: 866; CPName: 'cp866'),
    (CPID: 869; CPName: 'ibm869'),
    (CPID: 870; CPName: 'IBM870'),
    (CPID: 874; CPName: 'windows-874'),
    (CPID: 875; CPName: 'cp875'),
    (CPID: 932; CPName: 'shift_jis'),
    (CPID: 936; CPName: 'gb2312'),
    (CPID: 949; CPName: 'ks_c_5601-1987'),
    (CPID: 950; CPName: 'big5'),
    (CPID: 1026; CPName: 'IBM1026'),
    (CPID: 1047; CPName: 'IBM01047'),
    (CPID: 1140; CPName: 'IBM01140'),
    (CPID: 1141; CPName: 'IBM01141'),
    (CPID: 1142; CPName: 'IBM01142'),
    (CPID: 1143; CPName: 'IBM01143'),
    (CPID: 1144; CPName: 'IBM01144'),
    (CPID: 1145; CPName: 'IBM01145'),
    (CPID: 1146; CPName: 'IBM01146'),
    (CPID: 1147; CPName: 'IBM01147'),
    (CPID: 1148; CPName: 'IBM01148'),
    (CPID: 1149; CPName: 'IBM01149'),
    (CPID: 1200; CPName: 'utf-16'),
    (CPID: 1201; CPName: 'unicodeFFFE'),
    (CPID: 1250; CPName: 'windows-1250'),
    (CPID: 1251; CPName: 'windows-1251'),
    (CPID: 1252; CPName: 'Windows-1252'),
    (CPID: 1253; CPName: 'windows-1253'),
    (CPID: 1254; CPName: 'windows-1254'),
    (CPID: 1255; CPName: 'windows-1255'),
    (CPID: 1256; CPName: 'windows-1256'),
    (CPID: 1257; CPName: 'windows-1257'),
    (CPID: 1258; CPName: 'windows-1258'),
    (CPID: 1361; CPName: 'Johab'),
    (CPID: 10000; CPName: 'macintosh'),
    (CPID: 10001; CPName: 'x-mac-japanese'),
    (CPID: 10002; CPName: 'x-mac-chinesetrad'),
    (CPID: 10003; CPName: 'x-mac-korean'),
    (CPID: 10004; CPName: 'x-mac-arabic'),
    (CPID: 10005; CPName: 'x-mac-hebrew'),
    (CPID: 10006; CPName: 'x-mac-greek'),
    (CPID: 10007; CPName: 'x-mac-cyrillic'),
    (CPID: 10008; CPName: 'x-mac-chinesesimp'),
    (CPID: 10010; CPName: 'x-mac-romanian'),
    (CPID: 10017; CPName: 'x-mac-ukrainian'),
    (CPID: 10021; CPName: 'x-mac-thai'),
    (CPID: 10029; CPName: 'x-mac-ce'),
    (CPID: 10079; CPName: 'x-mac-icelandic'),
    (CPID: 10081; CPName: 'x-mac-turkish'),
    (CPID: 10082; CPName: 'x-mac-croatian'),
    (CPID: 12000; CPName: 'utf-32'),
    (CPID: 12001; CPName: 'utf-32BE'),
    (CPID: 20000; CPName: 'x-Chinese-CNS'),
    (CPID: 20001; CPName: 'x-cp20001'),
    (CPID: 20002; CPName: 'x-Chinese-Eten'),
    (CPID: 20003; CPName: 'x-cp20003'),
    (CPID: 20004; CPName: 'x-cp20004'),
    (CPID: 20005; CPName: 'x-cp20005'),
    (CPID: 20105; CPName: 'x-IA5'),
    (CPID: 20106; CPName: 'x-IA5-German'),
    (CPID: 20107; CPName: 'x-IA5-Swedish'),
    (CPID: 20108; CPName: 'x-IA5-Norwegian'),
    (CPID: 20127; CPName: 'us-ascii'),
    (CPID: 20261; CPName: 'x-cp20261'),
    (CPID: 20269; CPName: 'x-cp20269'),
    (CPID: 20273; CPName: 'IBM273'),
    (CPID: 20277; CPName: 'IBM277'),
    (CPID: 20278; CPName: 'IBM278'),
    (CPID: 20280; CPName: 'IBM280'),
    (CPID: 20284; CPName: 'IBM284'),
    (CPID: 20285; CPName: 'IBM285'),
    (CPID: 20290; CPName: 'IBM290'),
    (CPID: 20297; CPName: 'IBM297'),
    (CPID: 20420; CPName: 'IBM420'),
    (CPID: 20423; CPName: 'IBM423'),
    (CPID: 20424; CPName: 'IBM424'),
    (CPID: 20833; CPName: 'x-EBCDIC-KoreanExtended'),
    (CPID: 20838; CPName: 'IBM-Thai'),
    (CPID: 20866; CPName: 'koi8-r'),
    (CPID: 20871; CPName: 'IBM871'),
    (CPID: 20880; CPName: 'IBM880'),
    (CPID: 20905; CPName: 'IBM905'),
    (CPID: 20924; CPName: 'IBM00924'),
    (CPID: 20932; CPName: 'EUC-JP'),
    (CPID: 20936; CPName: 'x-cp20936'),
    (CPID: 20949; CPName: 'x-cp20949'),
    (CPID: 21025; CPName: 'cp1025'),
    (CPID: 21866; CPName: 'koi8-u'),
    (CPID: 28591; CPName: 'iso-8859-1'),
    (CPID: 28592; CPName: 'iso-8859-2'),
    (CPID: 28593; CPName: 'iso-8859-3'),
    (CPID: 28594; CPName: 'iso-8859-4'),
    (CPID: 28595; CPName: 'iso-8859-5'),
    (CPID: 28596; CPName: 'iso-8859-6'),
    (CPID: 28597; CPName: 'iso-8859-7'),
    (CPID: 28598; CPName: 'iso-8859-8'),
    (CPID: 28599; CPName: 'iso-8859-9'),
    (CPID: 28603; CPName: 'iso-8859-13'),
    (CPID: 28605; CPName: 'iso-8859-15'),
    (CPID: 29001; CPName: 'x-Europa'),
    (CPID: 38598; CPName: 'iso-8859-8-i'),
    (CPID: 50220; CPName: 'iso-2022-jp'),
    (CPID: 50221; CPName: 'csISO2022JP'),
    (CPID: 50222; CPName: 'iso-2022-jp'),
    (CPID: 50225; CPName: 'iso-2022-kr'),
    (CPID: 50227; CPName: 'x-cp50227'),
    (CPID: 51932; CPName: 'euc-jp'),
    (CPID: 51936; CPName: 'EUC-CN'),
    (CPID: 51949; CPName: 'euc-kr'),
    (CPID: 52936; CPName: 'hz-gb-2312'),
    (CPID: 54936; CPName: 'GB18030'),
    (CPID: 57002; CPName: 'x-iscii-de'),
    (CPID: 57003; CPName: 'x-iscii-be'),
    (CPID: 57004; CPName: 'x-iscii-ta'),
    (CPID: 57005; CPName: 'x-iscii-te'),
    (CPID: 57006; CPName: 'x-iscii-as'),
    (CPID: 57007; CPName: 'x-iscii-or'),
    (CPID: 57008; CPName: 'x-iscii-ka'),
    (CPID: 57009; CPName: 'x-iscii-ma'),
    (CPID: 57010; CPName: 'x-iscii-gu'),
    (CPID: 57011; CPName: 'x-iscii-pa'),
    (CPID: 65000; CPName: 'utf-7'),
    (CPID: 65001; CPName: 'utf-8')
  );

{$ifdef mswindows}
{$IFNDEF VER_XEH}
type
  TCpinfoEx = record
    MaxCharSize: UINT;
    DefaultChar: array[0..MAX_DEFAULTCHAR - 1] of Byte;
    LeadByte: array[0..MAX_LEADBYTES - 1] of Byte;
    UnicodeDefaultChar: WideChar;
    Codepage: UINT;
    CodePageName: array[0..MAX_PATH -1] of AnsiChar;
  end;

function GetCPInfoEx(CodePage: UINT; dwFlags: DWORD; var lpCPInfoEx: TCPInfoEx): BOOL; stdcall;
{$ENDIF}
{$endif}

implementation

{$ifdef mswindows}
{$IFNDEF VER_XEH}
function GetCPInfoEx; external kernel32 name 'GetCPInfoExA';
{$ENDIF}
{$endif}


{$ifdef mswindows}
function GetCodepageName: string;
var
  I: Integer;
  CPInfoEx: TCPInfoEx;
begin
  Result := '';
  if GetCPInfoEx(CP_ACP, 0, CPInfoEx) then
    for I := 0 to MaxEncodings - 1 do
      if Encodings[I].CPID = CPInfoEx.Codepage then
      begin
        Result := Encodings[I].CPName;
        break;
      end;
end;
{$else}
function GetCodepageName: string;
begin
  result:= 'utf-8';
end;

{$endif}

end.
