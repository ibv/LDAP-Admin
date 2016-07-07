  {      LDAPAdmin - TextFile.pas
  *      Copyright (C) 2005-2016 Tihomir Karlovic
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

const
  UTF_16BOM_BE: Word = $FFFE; // actualy $FEFF but reverse because of word read
  UTF_16BOM_LE: Word = $FEFF; // actualy $FFFE;
  UTF_8BOM: array[0..2] of Byte = ($EF, $BB, $BF);

type
  TFileEncode = (feAnsi, feUTF8, feUnicode_BE, feUnicode_LE);

  TTextFile = class(TMemoryStream)
  private
    fUnixWrite: Boolean;
    fEncoding:  TFileEncode;
    fCharSize:  Integer;
    fFileName:  string;
    fMode:      Integer;
    function    IsEof: Boolean;
    procedure   SetEncoding(AEncoding: TFileEncode);
  public
    constructor Create(const FileName: string; Mode: Word);
    destructor  Destroy; override;
    //function    Read(var Buffer; Count: Longint): Longint; override;
    //function    Write(const Buffer; Count: Longint): Longint; override;
    function    GetText: string;
    function    ReadChar: WideChar;
    procedure   WriteChar(AChar: WideChar);
    procedure   WriteString(Value: string);
    function    ReadLn: string;
    procedure   WriteLn(Value: string);
    property    Eof: Boolean read IsEof;
    property    UnixWrite: Boolean read fUnixWrite write fUnixWrite;
    property    CharSize: Integer read fCharSize;
    property    Encoding: TFileEncode read fEncoding write SetEncoding;
  end;

implementation

uses Constant, Misc;

procedure TTextFile.SetEncoding(AEncoding: TFileEncode);
var
  Buffer: string;
begin
  if Position > 0 then
    Buffer := GetText
  else
    Buffer := '';
  Clear;
  fEncoding := AEncoding;
  if Encoding = feUnicode_LE then
  begin
    WriteBuffer(UTF_16BOM_LE, SizeOf(UTF_16BOM_LE));
    fCharSize := 2;
  end
  else
  if Encoding = feUnicode_BE then
  begin
    WriteBuffer(UTF_16BOM_BE, SizeOf(UTF_16BOM_BE));
    fCharSize := 2;
  end
  else
  if Encoding = feUtf8 then
      WriteBuffer(UTF_8BOM, SizeOf(UTF_8BOM));
  if Buffer <> '' then
    WriteString(Buffer);
end;

constructor TTextFile.Create(const FileName: string; Mode: Word);

  procedure ReadHeader;
  var
    NumRead: Integer;
    Bom: Word;
  begin
    NumRead := Read(Bom, 2);
    if NumRead = 2 then
    begin
      if Bom = UTF_16BOM_BE then
      begin
        fEncoding := feUnicode_BE;
        fCharSize := 2; // for now
        exit;
      end;

      if (Bom = UTF_16BOM_LE) then
      begin
        fEncoding := feUnicode_LE;
        fCharSize := 2; // for now
        exit;
      end;

      if Bom = $BBEF then
      begin
        NumRead := Read(Bom, 1);
        if (NumRead = 1) and (Bom and $FF = $BF) then // UTF8 BOM
        begin
          fEncoding := feUTF8;
          exit;
        end;
      end;
    end;
    fCharSize := 1;
    Position := 0;
  end;

begin
  inherited Create;

  fMode := Mode;
  fFileName := FileName;
  fCharSize := 1;
  if Mode = fmOpenRead then
  begin
    LoadFromFile(FileName);
    ReadHeader;
  end
  else
  if Mode = fmCreate then
    Encoding := feUtf8; // Default
end;

destructor TTextFile.Destroy;
begin
  if fMode <> fmOpenRead then
    SaveToFile(fFileName);
  inherited;
end;

function TTextFile.IsEof: Boolean;
begin
  Result := Position = Size;
end;

function TTextFile.GetText: string;
var
  ch: WideChar;
  b: Byte;
  Tmp: String;
  utf8: AnsiString;
begin
  case Encoding of
    feAnsi:       Position := 0;
    feUTF8:       Position := SizeOf(UTF_8BOM);
    feUnicode_BE: Position := SizeOf(UTF_16BOM_BE);
    feUnicode_LE: Position := SizeOf(UTF_16BOM_LE);
  end;
  Tmp := '';
  ch := #0;
  while not EOF do
  begin
    ReadBuffer(ch, CharSize);
    if Encoding = feUnicode_BE then
    begin
      b := Hi(Word(ch));
      Word(ch) := Word(ch) shl 8;
      Word(ch) := Word(ch) or b;
    end;
    if Encoding = feUTF8 then
      utf8 := utf8 + AnsiChar(ch)
    else
      Tmp := Tmp + ch;
  end;
  if Encoding = feUTF8 then
    Result := String(UTF8ToStringLen(PAnsiChar(utf8), Length(utf8)))
  else
    Result := String(Tmp);
end;

function TTextFile.ReadChar: WideChar;
var
  b: Byte;
begin
  Result := #0;
  ReadBuffer(Result, FCharSize);
  if Encoding = feUnicode_BE then
  begin
    b := Hi(Word(Result));
    Word(Result) := Word(Result) shl 8;
    Word(Result) := Word(Result) or b;
  end;
end;

procedure TTextFile.WriteChar(AChar: WideChar);
var
  b: Byte;
  ch: WideChar;
begin
    if Encoding = feUnicode_BE then
    begin
      b := Hi(Word(ch));
      Word(ch) := Word(ch) shl 8;
      Word(ch) := Word(ch) or b;
    end;
  WriteBuffer(AChar, FCharSize);
end;

procedure TTextFile.WriteString(Value: string);
var
  {$IFNDEF UNICODE}
  w: WideString;
  {$ELSE}
  s: AnsiString;
  {$ENDIF}

  procedure Encode_BE(p: PWideChar);
  var
    b: Byte;
  begin
    p := PWideChar(Value);
    while p^ <> #0 do begin
      b := Hi(Word(p^));
      p^ := WideChar((Word(p^) shl 8) or b);
      inc(p);
    end;
  end;

begin
  if (Encoding = feUnicode_LE) or (Encoding = feUnicode_BE) then
  begin
    {$IFNDEF UNICODE}
    w := StringToWide(Value);
    if Encoding = feUnicode_BE then
      Encode_BE(PWideChar(w));
    WriteBuffer(w[1], Length(w));
    {$ELSE}
    if Encoding = feUnicode_BE then
      Encode_BE(PChar(Value));
    WriteBuffer(Value[1], Length(Value) * fCharSize);
    {$ENDIF}
  end
  else begin
    {$IFNDEF UNICODE}
    if Encoding = feUTF8 then
      Value := StringToUTF8Len(PChar(Value), length(Value));
    WriteBuffer(Value[1], Length(Value));
    {$ELSE}
    if Encoding = feUTF8 then
      s := StringToUTF8Len(PChar(Value), length(Value))
    else
      s := RawByteString(Value);
    WriteBuffer(s[1], Length(s));
    {$ENDIF}
  end;
end;

function TTextFile.ReadLn: string;
var
  ch: WideChar;
  b: Byte;
  Tmp: String;
  utf8: AnsiString;
begin
  if Eof then
    raise Exception.Create(stLdifEof);
  Tmp := '';
  ch := #0;
  while not EOF do
  begin
    ReadBuffer(ch, CharSize);
    if Encoding = feUnicode_BE then
    begin
      b := Hi(Word(ch));
      Word(ch) := Word(ch) shl 8;
      Word(ch) := Word(ch) or b;
    end;

    if ch = #10 then
      Break;
    if ch <> #13 then
    begin
      if Encoding = feUTF8 then
        utf8 := utf8 + AnsiChar(ch)
      else
        Tmp := Tmp + ch;
    end;
  end;

  if Encoding = feUTF8 then
    Result := String(UTF8ToStringLen(PAnsiChar(utf8), Length(utf8)))
  else
    Result := String(Tmp);
end;

procedure TTextFile.WriteLn(Value: string);
begin
  if UnixWrite then
    WriteString(Value + #10)
  else
    WriteString(Value + #13#10);
end;

end.
