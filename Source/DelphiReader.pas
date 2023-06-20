{
 Author: Mattias Gaertner

 *****************************************************************************
 *                                                                           *
 *  This file is part of the Lazarus Component Library (LCL)                 *
 *                                                                           *
 *  See the file COPYING.modifiedLGPL, included in this distribution,        *
 *  for details about the copyright.                                         *
 *                                                                           *
 *  This program is distributed in the hope that it will be useful,          *
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of           *
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.                     *
 *                                                                           *
 *****************************************************************************

  Abstract:
    This unit maintains and stores all lazarus resources in the global list
    named LazarusResources and provides methods and types to stream components.

    A lazarus resource is an ansistring, with a name and a valuetype. Both, name
    and valuetype, are ansistrings as well.
    Lazarus resources are normally included via an include directive in the
    initialization part of a unit. To create such include files use the
    BinaryToLazarusResourceCode procedure.
    To create a LRS file from an LFM file use the LFMtoLRSfile function which
    transforms the LFM text to binary format and stores it as Lazarus resource
    include file.


    This file is part of LResources.pas
}

unit DelphiReader;

{$mode objfpc}{$H+}

{ $DEFINE WideStringLenDoubled}

interface

uses
 Classes, SysUtils, LCLStrConsts, LREsources;

//------------------------------------------------------------------------------
// Delphi object streams

type
  TDelphiValueType = (dvaNull, dvaList, dvaInt8, dvaInt16, dvaInt32, dvaExtended,
    dvaString, dvaIdent, dvaFalse, dvaTrue, dvaBinary, dvaSet, dvaLString,
    dvaNil, dvaCollection, dvaSingle, dvaCurrency, dvaDate, dvaWString,
    dvaInt64, dvaUTF8String);
    
  TDelphiReader = class
  private
    FStream: TStream;
  protected
    procedure SkipBytes(Count: Integer);
    procedure SkipSetBody;
    procedure SkipProperty;
  public
    constructor Create(Stream: TStream);
    procedure ReadSignature;
    procedure Read(out Buf; Count: Longint);
    function ReadInteger: Longint;
    function ReadValue: TDelphiValueType;
    function NextValue: TDelphiValueType;
    function ReadStr: string;
    function EndOfList: Boolean;
    procedure SkipValue;
    procedure CheckValue(Value: TDelphiValueType);
    procedure ReadListEnd;
    procedure ReadPrefix(var Flags: TFilerFlags; var AChildPos: Integer); virtual;
    function ReadFloat: Extended;
    function ReadSingle: Single;
    function ReadCurrency: Currency;
    function ReadDate: TDateTime;
    function ReadString: string;
    //function ReadWideString: WideString;
    function ReadInt64: Int64;
    function ReadIdent: string;
  end;

  TDelphiWriter = class
  private
    FStream: TStream;
  public
    constructor Create(Stream: TStream);
    procedure Write(const Buf; Count: Longint);
  end;

implementation
  
{ TDelphiReader }

procedure ReadError(Msg: string);
begin
  raise EReadError.Create(Msg);
end;

procedure PropValueError;
begin
  ReadError(rsInvalidPropertyValue);
end;

procedure TDelphiReader.SkipBytes(Count: Integer);
begin
  FStream.Position:=FStream.Position+Count;
end;

procedure TDelphiReader.SkipSetBody;
begin
  while ReadStr <> '' do ;
end;

procedure TDelphiReader.SkipProperty;
begin
  ReadStr; { Skips property name }
  SkipValue;
end;

constructor TDelphiReader.Create(Stream: TStream);
begin
  FStream:=Stream;
end;

procedure TDelphiReader.ReadSignature;
var
  Signature: TFilerSignature;
begin
  Signature:='1234';
  Read(Signature[1], length(Signature));
  if Signature<>FilerSignature then
    ReadError(rsInvalidStreamFormat);
end;

procedure TDelphiReader.Read(out Buf; Count: Longint);
begin
  FStream.Read(Buf,Count);
end;

function TDelphiReader.ReadInteger: Longint;
var
  S: Shortint;
  I: Smallint;
begin
  case ReadValue of
    dvaInt8:
      begin
        Read(S, SizeOf(Shortint));
        Result := S;
      end;
    dvaInt16:
      begin
        Read(I, SizeOf(I));
        Result := I;
      end;
    dvaInt32:
      Read(Result, SizeOf(Result));
  else
    Result:=0;
    PropValueError;
  end;
end;

function TDelphiReader.ReadValue: TDelphiValueType;
var b: byte;
begin
  Read(b,1);
  Result:=TDelphiValueType(b);
end;

function TDelphiReader.NextValue: TDelphiValueType;
begin
  Result := ReadValue;
  FStream.Position:=FStream.Position-1;
end;

function TDelphiReader.ReadStr: string;
var
  L: Byte;
begin
  Read(L, SizeOf(Byte));
  SetLength(Result, L);
  if L>0 then
    Read(Result[1], L);
end;

function TDelphiReader.EndOfList: Boolean;
begin
  Result := (ReadValue = dvaNull);
  FStream.Position:=FStream.Position-1;
end;

procedure TDelphiReader.SkipValue;

  procedure SkipList;
  begin
    while not EndOfList do SkipValue;
    ReadListEnd;
  end;

  procedure SkipBinary(BytesPerUnit: Integer);
  var
    Count: Longint;
  begin
    Read(Count, SizeOf(Count));
    SkipBytes(Count * BytesPerUnit);
  end;

  procedure SkipCollection;
  begin
    while not EndOfList do
    begin
      if NextValue in [dvaInt8, dvaInt16, dvaInt32] then SkipValue;
      SkipBytes(1);
      while not EndOfList do SkipProperty;
      ReadListEnd;
    end;
    ReadListEnd;
  end;

begin
  case ReadValue of
    dvaNull: { no value field, just an identifier };
    dvaList: SkipList;
    dvaInt8: SkipBytes(SizeOf(Byte));
    dvaInt16: SkipBytes(SizeOf(Word));
    dvaInt32: SkipBytes(SizeOf(LongInt));
    dvaExtended: SkipBytes(SizeOf(Extended));
    dvaString, dvaIdent: ReadStr;
    dvaFalse, dvaTrue: { no value field, just an identifier };
    dvaBinary: SkipBinary(1);
    dvaSet: SkipSetBody;
    dvaLString: SkipBinary(1);
    dvaCollection: SkipCollection;
    dvaSingle: SkipBytes(Sizeof(Single));
    dvaCurrency: SkipBytes(SizeOf(Currency));
    dvaDate: SkipBytes(Sizeof(TDateTime));
    dvaWString: SkipBinary(Sizeof(WideChar));
    dvaInt64: SkipBytes(Sizeof(Int64));
    dvaUTF8String: SkipBinary(1);
  end;
end;

procedure TDelphiReader.CheckValue(Value: TDelphiValueType);
begin
  if ReadValue <> Value then
  begin
    FStream.Position:=FStream.Position-1;
    SkipValue;
    PropValueError;
  end;
end;

procedure TDelphiReader.ReadListEnd;
begin
  CheckValue(dvaNull);
end;

procedure TDelphiReader.ReadPrefix(var Flags: TFilerFlags;
  var AChildPos: Integer);
var
  Prefix: Byte;
begin
  Flags := [];
  if Byte(NextValue) and $F0 = $F0 then
  begin
    Prefix := Byte(ReadValue);
    if (Prefix and ObjStreamMaskInherited)>0 then
      Include(Flags,ffInherited);
    if (Prefix and ObjStreamMaskChildPos)>0 then
      Include(Flags,ffChildPos);
    if (Prefix and ObjStreamMaskInline)>0 then
      Include(Flags,ffInline);
    if ffChildPos in Flags then AChildPos := ReadInteger;
  end;
end;

function TDelphiReader.ReadFloat: Extended;
begin
  if ReadValue = dvaExtended then
    Read(Result, SizeOf(Result))
  else begin
    FStream.Position:=FStream.Position-1;
    Result := ReadInteger;
  end;
end;

function TDelphiReader.ReadSingle: Single;
begin
  if ReadValue = dvaSingle then
    Read(Result, SizeOf(Result))
  else begin
    FStream.Position:=FStream.Position-1;
    Result := ReadInteger;
  end;
end;

function TDelphiReader.ReadCurrency: Currency;
begin
  if ReadValue = dvaCurrency then
    Read(Result, SizeOf(Result))
  else begin
    FStream.Position:=FStream.Position-1;
    Result := ReadInteger;
  end;
end;

function TDelphiReader.ReadDate: TDateTime;
begin
  if ReadValue = dvaDate then
    Read(Result, SizeOf(Result))
  else begin
    FStream.Position:=FStream.Position-1;
    Result := ReadInteger;
  end;
end;

function TDelphiReader.ReadString: string;
var
  L: Integer;
begin
  Result := '';
  if NextValue in [dvaWString, dvaUTF8String] then begin
    ReadError('TDelphiReader.ReadString: WideString and UTF8String are not implemented yet');
    //Result := ReadWideString;
  end else
  begin
    L := 0;
    case ReadValue of
      dvaString:
        Read(L, SizeOf(Byte));
      dvaLString:
        Read(L, SizeOf(Integer));
    else
      PropValueError;
    end;
    SetLength(Result, L);
    Read(Pointer(Result)^, L);
  end;
end;

function TDelphiReader.ReadInt64: Int64;
begin
  if NextValue = dvaInt64 then
  begin
    ReadValue;
    Read(Result, Sizeof(Result));
  end
  else
    Result := ReadInteger;
end;

function TDelphiReader.ReadIdent: string;
var
  L: Byte;
begin
  case ReadValue of
    dvaIdent:
      begin
        Read(L, SizeOf(Byte));
        SetLength(Result, L);
        Read(Result[1], L);
      end;
    dvaFalse:
      Result := 'False';
    dvaTrue:
      Result := 'True';
    dvaNil:
      Result := 'nil';
    dvaNull:
      Result := 'Null';
  else
    Result:='';
    PropValueError;
  end;
end;

{ TDelphiWriter }

{ MultiByte Character Set (MBCS) byte type }
type
  TMbcsByteType = (mbSingleByte, mbLeadByte, mbTrailByte);

function ByteType(const S: string; Index: Integer): TMbcsByteType;
begin
  Result := mbSingleByte;
  { ToDo:
    if SysLocale.FarEast then
      Result := ByteTypeTest(PChar(S), Index-1);
  }
end;

constructor TDelphiWriter.Create(Stream: TStream);
begin
  FStream:=Stream;
end;

procedure TDelphiWriter.Write(const Buf; Count: Longint);
begin
  FStream.Write(Buf,Count);
end;

end.
