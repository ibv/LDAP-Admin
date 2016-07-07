  {      LDAPAdmin - XmlLoader.pas
  *      Copyright (C) 2013 Tihomir Karlovic
  *
  *      Author: Tihomir Karlovic
  *
  *      Modifications:  Ivo Brhel, 2016
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

unit XmlLoader;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses Classes, FileUtil;

type

  TXmlLoader = class
  private
    fFileExtension: string;
    function        GetCount: Integer;
    procedure       SetCommaPaths(Value: string);
  protected
    fFiles:         TStringList;
  public
    constructor     Create; virtual;
    destructor      Destroy; override;
    procedure       Clear;
    function        Parse(const FileName: string): TObject; virtual; abstract;
    procedure       AddPath(Path: string);
    property        Count: Integer read GetCount;
    property        Paths: string write SetCommaPaths;
    property        FileExtension: string read fFileExtension write fFileExtension;
  end;

implementation

uses
{$IFnDEF FPC}
  Consts,
{$ELSE}
{$ENDIF}
  Forms, Xml, SysUtils, ParseErr, Dialogs;

{ TXmlLoader }

constructor TXmlLoader.Create;
begin
  inherited;
  fFiles := TStringList.Create;
end;

destructor TXmlLoader.Destroy;
begin
  Clear;
  fFiles.Free;
  inherited;
end;

procedure TXmlLoader.Clear;
var
  i: Integer;
begin
  with fFiles do begin
    for i := 0 to Count - 1 do
      Objects[i].Free;
    Clear;
  end;
end;

procedure TXmlLoader.AddPath(Path: string);
var
  sr: TSearchRec;
  Dir: string;

  procedure AddFile(name: string);
  begin
    try
      fFiles.AddObject(name, Parse(name));
    except
      on E:EXmlException do
      begin
        ParseError(mtError, Application.MainForm, sr.Name, E.Message, E.Message2, E.XmlText, E.Tag, E.Line, E.Position);
        Exit;
      end;
      on E:Exception do
        raise Exception.Create(Name +': ' + #13#10 + E.Message);
    end;
  end;

begin
  {$ifndef mswindows}
  Path:=StringReplace(path,'\','/',[rfReplaceAll]);
  {$endif}
  if FindFirstUTF8(Path,faArchive,sr) { *Converted from FindFirst* } = 0 then
  begin
    {$ifdef mswindows}
    Dir := ExtractFileDir(Path) + '\';
    {$else}
    Dir := ExtractFileDir(Path) + '/';
    {$endif}
    with fFiles do
    try
      AddFile(Dir + sr.Name);
      while FindNextUTF8(sr) { *Converted from FindNext* } = 0 do
        AddFile(Dir + sr.Name);
    finally
      FindCloseUTF8(sr); { *Converted from FindClose* }
    end;
  end;
end;

function TXmlLoader.GetCount: Integer;
begin
  Result := fFiles.Count;
end;

procedure TXmlLoader.SetCommaPaths(Value: string);
var
  List: TStringList;
  i: Integer;

begin
  List := TStringList.Create;
  try
    List.CommaText := Value;
    Clear;
    for i := 0 to List.Count - 1 do
      AddPath(List[i] + '\*.' + fFileExtension);
  finally
    List.Free;
  end;
end;

end.
