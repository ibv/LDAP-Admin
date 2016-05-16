  {      LDAPAdmin - TextFile.pas
  *      Copyright (C) 2005-2014 Tihomir Karlovic
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

unit TextFile;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses SysUtils, Classes;

type
  TTextFile = class(TFileStream)
  private
    fUnixWrite: Boolean;
    fUtf8:      Boolean;
    fUnicode:   Boolean;
    function    IsEof: Boolean;
  public
    constructor Create(const FileName: string; Mode: Word);
    function    ReadLn: string;
    procedure   WriteLn(Value: string);
    property    Eof: Boolean read IsEof;
    property    UnixWrite: Boolean read fUnixWrite write fUnixWrite;
    property    Utf8: Boolean read fUtf8 write fUtf8;
    property    Unicode: Boolean read fUnicode write fUnicode;
  end;

implementation

uses Constant, Misc;

constructor TTextFile.Create(const FileName: string; Mode: Word);
const
  UTF_16BOM_BE: Word = $FEFF;
  UTF_16BOM_LE: Word = $FFFE;
  UTF_8BOM: array[0..2] of Byte = ($EF, $BB, $BF);

  procedure ReadHeader;
  var
    NumRead: Integer;
    Bom: Word;
  begin
    NumRead := Read(Bom, 2);
    if NumRead = 2 then
    begin
      if (Bom = UTF_16BOM_BE) or (Bom = UTF_16BOM_LE) then
      begin
        fUnicode := true;
        exit;
      end;
      if Bom = $BBEF then
      begin
        NumRead := Read(Bom, 1);
        if (NumRead = 1) and (Bom and $FF = $BF) then // UTF8 BOM
        begin
          utf8 := true;
          exit;
        end;
      end;
    end;
    Position := 0;
  end;

begin
  inherited;

  if Mode = fmOpenRead then
    ReadHeader
  else
  if Mode = fmCreate then
  begin
    if Unicode then
      WriteBuffer(UTF_16BOM_BE, SizeOf(UTF_16BOM_BE))
    else
    if Utf8 then
      WriteBuffer(UTF_8BOM, SizeOf(UTF_8BOM));
  end;
end;

function TTextFile.IsEof: Boolean;
begin
  Result := Position = Size;
end;

function TTextFile.ReadLn: string;
var
  ch: Word;
  Len: Integer;
begin
  if Eof then
    raise Exception.Create(stLdifEof);
  Result := '';
  if Unicode then
    Len := 2
  else begin
    Len := 1;
    ch := 0;
  end;
  while not EOF do
  begin
    ReadBuffer(ch, Len);
    if (ch = 13) or (ch = 10) then
    begin
      if ch = 13 then SetPosition(Position+1);
      Break;
    end;
      Result := Result + AnsiChar(ch);
      if Unicode then
        Result := Result + AnsiChar(Hi(ch));
  end;
  if Result = '' then
    exit;
  if Unicode then
    Result := WideStringToUtf8Len(PWideChar(Result), Length(Result) div 2)
  else
  if utf8 then
    Result := UTF8ToStringLen(PChar(Result), Length(Result));
end;

procedure TTextFile.WriteLn(Value: string);
var
  len: Integer;
  w: WideString;
begin
  len := Length(Value) + 1;
  SetLength(Value, len + Ord(not UnixWrite));
  if not UnixWrite then
  begin
    Value[Len] := #13;
    inc(Len);
  end;
  Value[Len] := #10;
  if fUnicode then
  begin
    w := StringToWide(Value);
    Write(w[1], Length(w));
  end
  else begin
    if fUtf8 then
      Value := StringToUTF8Len(PChar(Value), length(Value));
    Write(Value[1], Length(Value));
  end;
end;

end.
