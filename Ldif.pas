  {      LDAPAdmin - Ldif.pas
  *      Copyright (C) 2004-2016 Tihomir Karlovic
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

unit Ldif;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
{$IFnDEF FPC}
  Windows,
{$ELSE}
  LCLIntf, LCLType, LMessages, Base64,
{$ENDIF}
  LDAPClasses, TextFile, Classes, SysUtils;

const
  SafeChar:     set of AnsiChar = [#$01..#09, #$0B..#$0C, #$0E..#$7F];
  SafeInitChar: set of AnsiChar = [#$01..#09, #$0B..#$0C, #$0E..#$1F, #$21..#$39, #$3B, #$3D..#$7F];
  MaxLineLength = 80;

type
  TLdifMode =        (fmRead, fmWrite, fmAppend);
  TAttributeOpMode = (amAdd, amModify, amDelete);
  TValueOpMode     = (vmSep, vmAdd, vmReplace, vmDelete);

{ TLDIF
  Uses ReadRecord to fetch and parse one record. Property RecordLines contains
  original Ldif lines of fetched record (without comments).
  Uses WriteRecord to dump one record to file opened for writing.
  Descendant classes are responsible for reading and writing of the data by
  overwriting abstract ReadLine and WriteLine procedures. }

type
  TLDIF = class
  private
    fRecord: TStringList;
    fVersion: Integer;
    fMode: TLdifMode;
    fWrap: Integer;
    fLinesRead: Integer;
    fEof: Boolean;
    FGenerateComments: Boolean;
  protected
    function  IsSafe(const Buffer: PBytes; DataSize: Cardinal): Boolean;
    function  ReadLine: string; virtual; abstract;
    procedure WriteLine(const Line: string); virtual; abstract;
    procedure PutLine(const attrib: string; const Buffer: PBytes; const DataSize: Cardinal);
    procedure FetchRecord; virtual;
    procedure ParseRecord(Entry: TLdapEntry); virtual;
    procedure ReadFromURL(url: string; Value: TLdapAttributeData);
  public
    procedure ReadRecord(Entry: TLdapEntry = nil); virtual;
    procedure WriteRecord(Entry: TLdapEntry); virtual;
    constructor Create; virtual;
    destructor Destroy; override;
    property Version: Integer read fVersion;
    property Wrap: Integer read fWrap write fWrap;
    property RecordLines: TStringList read fRecord;
    property EOF: Boolean read fEof;
    property GenerateComments: Boolean read FGenerateComments write FGenerateComments ;
  end;

  TLDIFFile = class(TLDIF)
  private
    F: TTextFile;
    function  GetNumRead: Integer;
    function  GetUnixWrite: Boolean;
    procedure SetUnixWrite(AValue: Boolean);
    function  GetFileEncoding: TFileEncode;
    procedure SetFileEncoding(AEncoding: TFileEncode);
  protected
    function  ReadLine: string; override;
    procedure WriteLine(const Line: string); override;
  public
    constructor Create(const FileName: string; const Mode: TLdifMode); reintroduce; overload;
    destructor Destroy; override;
    property NumRead: Integer read GetNumRead;
    property UnixWrite: Boolean read GetUnixWrite write SetUnixWrite;
    property Encoding: TFileEncode read GetFileEncoding write SetFileEncoding;
  end;

  TLDIFStringList = class(TLDIF)
  private
    fLines: TStringList;
    fCurrentLine: Integer;
  protected
    function  ReadLine: string; override;
    procedure WriteLine(const Line: string); override;
  public
    constructor Create(const Lines: TStringList; const Mode: TLdifMode); reintroduce; overload;
    property CurrentLine: Integer read fCurrentLine;
  end;

implementation

uses Constant,Misc, WinBase64;

{ TLDIF }

constructor TLDIF.Create;
begin
  fRecord := TStringList.Create;
  fWrap := MaxLineLength;
end;

destructor TLDIF.Destroy;
begin
  fRecord.Free;
  inherited Destroy;
end;

procedure TLDIF.FetchRecord;
var
  Line: string;
begin
  if fEof then
    raise Exception.Create(stLdifEof);
  fRecord.Clear;
  while not fEof do
  begin
    Line := ReadLine;
    inc(fLinesRead);
    if Line = '' then
    begin
      if fRecord.Count = 0 then
        continue
      else
        break;
    end
    else
      if Line[1] = '#' then
        Continue;
    fRecord.AddObject(Line, Pointer(fLinesRead - 1));
  end;
end;

procedure TLDIF.ParseRecord(Entry: TLdapEntry);
var
  i, po: Integer;
  Line, s, url: string;
  atName, atValue: string;
  ChangeType: TAttributeOpMode;
  OpType: TValueOpMode;

function GetNextLine: Boolean;
begin
    if i >= fRecord.Count then
    begin
      Result := false;
      Exit;
    end
    else
      Result := true;

    { Get line to parse }
    Line := fRecord.Strings[i];
    inc(i);
    while (i < fRecord.Count) and (fRecord.Strings[i][1] = ' ') do
    begin
     Line := Line + Copy(fRecord.Strings[i], 2, MaxInt);
     inc(i);
    end;

    { Parse the line }
    if Line = '-' then
    begin
      atName := '-';
      Exit;
    end;

    if Line[1] = ' ' then
        raise Exception.Create(Format(stLdifEFold, [Integer(fRecord.Objects[i])]));

    po := Pos(':', Line);
    if po = 0 then
      raise Exception.Create(Format(stLdifENoCol, [Integer(fRecord.Objects[i])]));

    atName := lowercase(TrimRight(Copy(Line, 1, po - 1)));
    url := '';
    if po = Length(Line) - 1 then
      atValue := ''
    else
    if Line[po + 1] = ':' then
    {$ifdef mswindows}
      atValue := Base64Decode(TrimLeft(Copy(Line, po + 2, MaxInt)))
    {$else}
      atValue:=DecodeStringBase64(TrimLeft(Copy(Line, po + 2, MaxInt)))
    {$endif}
    else
    if Line[po + 1] = '<' then
      url := TrimLeft(Copy(Line, po + 2, MaxInt))
    else
      atValue := TrimLeft(Copy(Line, po + 1, MaxInt));
end;

procedure AddAttrValue;
var
  Attr: TLdapAttribute;
begin
  Attr := Entry.AttributesByName[atName];
  if url <> '' then
    ReadFromUrl(url, Attr.AddValue)
  else
    Attr.AddValue(Pointer(@AnsiString(atValue)[1]), Length(atValue));
end;

begin
  i := 0;
  ChangeType := amAdd;
  while GetNextLine do
  begin

    if Entry.dn = '' then
    begin
      // it has to be dn or version atribute
      if atName = 'dn' then
        Entry.Utf8dn := atValue
      else
      if atName = 'version' then
      try
        fVersion := StrToInt(atValue)
      except
        on E: Exception do
          raise Exception.Create(Format(stLdifEVer, [atValue]));
      end
      else
        raise Exception.Create(Format(stLdifENoDn, [Integer(fRecord.Objects[i]), atName]));
    end
    else
    if atName = 'changetype' then
    begin
      if atValue = 'add' then
        ChangeType := amAdd
      else
      if atValue = 'modify' then
        ChangeType := amModify
      else
      if atValue = 'delete' then
      begin
        Entry.Delete;
      end
      else
        raise Exception.Create(Format(stLdifInvChType, [Integer(fRecord.Objects[i]), atValue]));
    end
    else begin
      case ChangeType of
        amAdd:    AddAttrValue;
        amModify: begin
                    if not (esBrowse in Entry.State) then
                      Entry.Read;
                    OpType := vmSep;
                    repeat
                      case OpType of
                        vmSep:     if atName = 'add' then
                                     OpType := vmAdd
                                   else
                                   if atName = 'replace' then
                                     OpType := vmReplace
                                   else
                                   if atName = 'delete' then
                                     OpType := vmDelete
                                   else
                                     raise Exception.Create(Format(stLdifInvOp, [Integer(fRecord.Objects[i]), atName]));
                        vmAdd:     begin
                                     while GetNextLine and (atName <> '-') do
                                       AddAttrValue;
                                     OpType := vmSep;
                                   end;
                        vmReplace: begin
                                     s := lowercase(atValue);
                                     Entry.AttributesByName[atValue].Delete;
                                     while GetNextLine and (atName <> '-') do begin
                                       if lowercase(atName) <> s then
                                         raise Exception.Create(Format(stLdifNotExpected, [Integer(fRecord.Objects[i]), s, atName]));
                                       AddAttrValue;
                                     end;
                                     OpType := vmSep;
                                   end;
                        vmDelete: begin
                                    s := lowercase(atValue);
                                    GetNextLine;
                                    with Entry.AttributesByName[atValue] do
                                    begin
                                      if atName = '-' then
                                        Delete
                                      else
                                      repeat
                                        if lowercase(atName) = s then
                                          DeleteValue(atValue)
                                        else
                                          raise Exception.Create(Format(stLdifInvAttrName, [Integer(fRecord.Objects[i]), s, Name]));
                                      until not GetNextLine or (atName = '-');
                                    end;
                                    OpType := vmSep;
                                  end;
                      end;
                      until OpType = vmSep;
                  end;
      end;
    end;
  end;
end;

procedure TLDIF.ReadFromURL(url: string; Value: TLdapAttributeData);
var
  i: Integer;
  fs: TFileStream;
begin
  i := Pos('://', url);
  if (i = 0) or (i + 3 >= Length(url)) then
    raise Exception.Create(stLdifInvalidUrl);
  if AnsiStrLIComp(PChar(url), 'file', i - 1) <> 0 then
    raise Exception.Create(stLdifUrlNotSupp);
  if url[i + 3] = '/' then
    inc(i, 3)
  else
    inc(i);
  fs := TFileStream.Create(Copy(url, i{ + 3}, MaxInt), fmOpenRead);
  try
    Value.LoadFromStream(fs);
  finally
    fs.Free;
  end;
end;

{ Tests whether data contains only safe chars }
function TLDIF.IsSafe(const Buffer: PBytes; DataSize: Cardinal): Boolean;
var
  p: PAnsiChar;
  EndBuf: PAnsiChar;
begin
  Result := true;
  p := PAnsiChar(Buffer);
  if not (p^ in SafeInitChar) then
  begin
    Result := false;
    exit;
  end;
  ///EndBuf := PAnsiChar(cardinal(Buffer) + DataSize);
  EndBuf := p + DataSize;
  while (p <> EndBuf) do
  begin
    if not (p^ in SafeChar) then
    begin
      Result := false;
      break;
    end;
    Inc(p);
  end;
end;

{ If neccessary encodes data to base64 coding and dumps the string to file
  wrapping the line so that max length doesn't exceed Wrap count of chars }
procedure TLDIF.PutLine(const attrib: string; const Buffer: PBytes; const DataSize: Cardinal);
var
  p1, len: Integer;
  line, s: string;
begin

  line := attrib + ':';

  if DataSize > 0 then
  begin
    // Check if we need to encode to base64
    if IsSafe(Buffer, DataSize) then
    begin
      SetString(s, PAnsiChar(Buffer), DataSize);
      line := line + ' ' + s
    end
    else
    begin
      {$ifdef mswindows}
      s := string(Base64Encode(Pointer(Buffer)^, DataSize));
      {$else}
      SetString(s, PChar(Buffer), DataSize);
      s:=EncodeStringBase64(s);
      {$endif}
      line := line + ': ' + s;
    end;
  end;

  len := Length(line);
  p1 := 1;
  while p1 <= len do
  begin
    if p1 = 1 then
    begin
      WriteLine(System.Copy(line, p1, fWrap));
      inc(p1, wrap);
    end
    else begin
      WriteLine(' ' + System.Copy(line, P1, fWrap - 1));
      inc(p1, wrap - 1);
    end;
  end;
end;

procedure TLDIF.ReadRecord(Entry: TLdapEntry = nil);
begin
  FetchRecord;
  if Assigned(Entry) then
  begin
    Entry.dn := '';
    Entry.Attributes.Clear;
    ParseRecord(Entry);
  end;
end;

procedure TLDIF.WriteRecord(Entry: TLdapEntry);
var
  i, j: Integer;
begin
  if FGenerateComments then
    WriteLine('# dn: ' + EncodeLdapString(Entry.dn));
  PutLine('dn', @Entry.utf8dn[1], Length(Entry.utf8dn));
  for i := 0 to Entry.Attributes.Count - 1 do with Entry.Attributes[i] do
    for j := 0 to ValueCount - 1 do with Values[j] do
      PutLine(Name, Data, DataSize);
  WriteLine('');
end;

{ TLDIFFile }

function TLDIFFile.GetNumRead: Integer;
begin
  Result := F.Position;
end;

function TLDIFFile.GetUnixWrite: Boolean;
begin
  Result := F.UnixWrite;
end;

procedure TLDIFFile.SetUnixWrite(AValue: Boolean);
begin
  F.UnixWrite := AValue;
end;

function TLDIFFile.GetFileEncoding: TFileEncode;
begin
  Result := F.Encoding;
end;

procedure TLDIFFile.SetFileEncoding(AEncoding: TFileEncode);
begin
  F.Encoding := AEncoding;
end;

function TLDIFFile.ReadLine: string;
begin
  Result := F.ReadLn;
  fEof := F.Eof;
end;

procedure TLDIFFile.WriteLine(const Line: string);
begin
  F.WriteLn(Line);
end;

constructor TLDIFFile.Create(const FileName: string; const Mode: TLdifMode);
begin
  inherited Create;
  fMode := Mode;
  try
    case Mode of
      fmRead:   F := TTextFile.Create(FileName, fmOpenRead);
      fmWrite:  F := TTextFile.Create(FileName, fmCreate);
      fmAppend: begin
                  F := TTextFile.Create(FileName, fmOpenReadWrite);
                  F.Seek(0, soFromEnd);
                end;
    else
      raise Exception.Create(stLdifEInvMode);
    end;
  except
    RaiseLastOSError;
  end;
end;

destructor TLDIFFile.Destroy;
begin
  try
    F.Free;
  except end;
  inherited Destroy;
end;

{ TLDIFStringList }

function TLDIFStringList.ReadLine: string;
begin
  Result := fLines[fCurrentLine];
  inc(fCurrentLine);
end;

procedure TLDIFStringList.WriteLine(const Line: string);
begin
  fLines.Add(Line);
end;

constructor TLDIFStringList.Create(const Lines: TStringList; const Mode: TLdifMode);
begin
  fLines := Lines;
  fMode := Mode;
  inherited Create;
end;

end.

