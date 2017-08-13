  {      LDAPAdmin - DlgWrap.pas
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

unit DlgWrap;

interface

uses Classes, SysUtils, Dialogs, TextFile;

{$I LdapAdmin.inc}
{$IFDEF VER_XEH}
{$DEFINE VISTA_STYLE}
{$ENDIF}

type
  TSaveDialogWrapper = class(TComponent)
  private
    FEncoding: TFileEncode;
    {$IFDEF VISTA_STYLE}
    procedure VistaSaveDialogExecute(Sender: TObject);
    procedure VistaSaveDialogFileOkClick(Sender: TObject; var CanClose: Boolean);
    {$ENDIF}
    function GetDefaultFolder: string;
    function GetDefaultExtension: string;
    function GetFileName: TFileName;
    function GetFilterIndex: Cardinal;
    function GetEncodingCombo: Boolean;
    function GetOverwritePrompt: Boolean;
    procedure SetDefaultFolder(const Value: string);
    procedure SetDefaultExtension(const Value: string);
    procedure SetFileName(const Value: TFileName);
    procedure SetFilterIndex(Index: Cardinal);
    procedure SetFilter(const Value: string);
    procedure SetEncoding(Encoding: TFileEncode);
    procedure SetEncodingCombo(Value: Boolean);
    procedure SetOverwritePrompt(Value: Boolean);
  public
    CommonSaveDialog: TSaveDialog;
    {$IFDEF VISTA_STYLE}
    VistaSaveDialog: TFileSaveDialog;
    {$ENDIF}
    property EncodingCombo: Boolean read GetEncodingCombo write SetEncodingCombo;
    property OverwritePrompt: Boolean read GetOverwritePrompt write SetOverwritePrompt;
    property DefaultExt: string read GetDefaultExtension write SetDefaultExtension;
    property DefaultFolder: string read GetDefaultFolder write SetDefaultFolder;
    property FileName: TFileName read GetFileName write SetFileName;
    property Filter: string write SetFilter;
    property FilterIndex: Cardinal read GetFilterIndex write SetFilterIndex;
    property Encoding: TFileEncode read FEncoding write SetEncoding;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function Execute: Boolean;
  end;

implementation

{$ifdef mswindows}
uses ShlObj;
{$endif}

function GetNext(var p: PChar): string;
var
  p0: PChar;
begin
  p0 := p;
  while (p^ <> #0) and (p^ <> '|') do inc(p);
  SetString(Result, p0, p - p0);
  if p^ = '|' then
    inc(p);
end;

function TSaveDialogWrapper.GetEncodingCombo: Boolean;
begin
  {$IFDEF VISTA_STYLE}
  Result := Assigned(VistaSaveDialog) and Assigned(VistaSaveDialog.OnExecute);
  {$ELSE}
  Result := false;
  {$ENDIF}
end;

procedure TSaveDialogWrapper.SetEncodingCombo(Value: Boolean);
begin
  {$IFDEF VISTA_STYLE}
  if Assigned(VistaSaveDialog) then
  begin
    if Value then
      VistaSaveDialog.OnExecute := VistaSaveDialogExecute
    else
      VistaSaveDialog.OnExecute := nil;
  end;
  {$ENDIF}
end;

function TSaveDialogWrapper.GetOverwritePrompt: Boolean;
begin
  {$IFDEF VISTA_STYLE}
  if Assigned(VistaSaveDialog) then
    Result := fdoOverWritePrompt in VistaSaveDialog.Options
  else
  {$ENDIF}
    Result := ofOverwritePrompt in CommonSaveDialog.Options;
end;

procedure TSaveDialogWrapper.SetOverwritePrompt(Value: Boolean);
begin
  {$IFDEF VISTA_STYLE}
  if Assigned(VistaSaveDialog) then
  begin
    if Value then
      VistaSaveDialog.Options := VistaSaveDialog.Options + [fdoOverWritePrompt]
    else
      VistaSaveDialog.Options := VistaSaveDialog.Options - [fdoOverWritePrompt];
  end
  else {$ENDIF} begin
    if Value then
      CommonSaveDialog.Options := CommonSaveDialog.Options + [ofOverWritePrompt]
    else
      CommonSaveDialog.Options := CommonSaveDialog.Options - [ofOverWritePrompt];
  end;
end;

function TSaveDialogWrapper.GetDefaultFolder: string;
begin
  {$IFDEF VISTA_STYLE}
  if Assigned(VistaSaveDialog) then
    Result := VistaSaveDialog.DefaultFolder
  else
  {$ENDIF}
    Result := '';
end;

function TSaveDialogWrapper.GetDefaultExtension: string;
begin
  {$IFDEF VISTA_STYLE}
  if Assigned(VistaSaveDialog) then
    Result := VistaSaveDialog.DefaultExtension
  else
  {$ENDIF}
    Result := CommonSaveDialog.DefaultExt;
end;

function TSaveDialogWrapper.GetFileName: TFileName;
begin
  {$IFDEF VISTA_STYLE}
  if Assigned(VistaSaveDialog) then
    Result := VistaSaveDialog.FileName
  else
  {$ENDIF}
    Result := CommonSaveDialog.FileName;
end;

function TSaveDialogWrapper.GetFilterIndex: Cardinal;
begin
  {$IFDEF VISTA_STYLE}
  if Assigned(VistaSaveDialog) then
    Result := VistaSaveDialog.FileTypeIndex
  else
  {$ENDIF}
    Result := CommonSaveDialog.FilterIndex;
end;

procedure TSaveDialogWrapper.SetDefaultFolder(const Value: string);
begin
  {$IFDEF VISTA_STYLE}
  if Assigned(VistaSaveDialog) then
    VistaSaveDialog.DefaultFolder := Value;
  {$ENDIF}
end;

procedure TSaveDialogWrapper.SetDefaultExtension(const Value: string);
begin
  {$IFDEF VISTA_STYLE}
  if Assigned(VistaSaveDialog) then
    VistaSaveDialog.DefaultExtension := Value
  else
  {$ENDIF}
    CommonSaveDialog.DefaultExt := Value;
end;

procedure TSaveDialogWrapper.SetFileName(const Value: TFileName);
begin
  {$IFDEF VISTA_STYLE}
  if Assigned(VistaSaveDialog) then
    VistaSaveDialog.FileName := Value
  else
  {$ENDIF}
    CommonSaveDialog.FileName := Value;
end;

procedure TSaveDialogWrapper.SetFilter(const Value: string);
var
  p: PChar;
begin
  {$IFDEF VISTA_STYLE}
  if Assigned(VistaSaveDialog) then
  begin
    VistaSaveDialog.FileTypes.Clear;
    p := PChar(Value);
    while p^ <> #0 do begin
      with VistaSaveDialog.FileTypes.Add do begin
        DisplayName := GetNext(p);
        FileMask := GetNext(p);
      end;
    end;
  end
  else
  {$ENDIF}
    CommonSaveDialog.Filter := Value;
end;

procedure TSaveDialogWrapper.SetFilterIndex(Index: Cardinal);
begin
  {$IFDEF VISTA_STYLE}
  if Assigned(VistaSaveDialog) then
    VistaSaveDialog.FileTypeIndex := Index
  else
  {$ENDIF}
    CommonSaveDialog.FilterIndex := Index;
end;

function TSaveDialogWrapper.Execute: Boolean;
begin
  {$IFDEF VISTA_STYLE}
  if Assigned(VistaSaveDialog) then
    Result := VistaSaveDialog.Execute
  else
  {$ENDIF}
    Result := CommonSaveDialog.Execute;
end;

procedure TSaveDialogWrapper.SetEncoding(Encoding: TFileEncode);
{$IFDEF VISTA_STYLE}
var
  c: IFileDialogCustomize;
{$ENDIF}
begin
  {$IFDEF VISTA_STYLE}
  if not Assigned(VistaSaveDialog) then
    exit;
  FEncoding := Encoding;
  if VistaSaveDialog.Dialog.QueryInterface(IFileDialogCustomize, c) = S_OK then
  case Encoding of
    feAnsi: c.SetSelectedControlItem(2, 1);
    feUtf8: c.SetSelectedControlItem(2, 2);
    feUnicode_LE: c.SetSelectedControlItem(2, 3);
    feUnicode_BE: c.SetSelectedControlItem(2, 4);
  end;
  {$ENDIF}
end;

{$IFDEF VISTA_STYLE}
procedure TSaveDialogWrapper.VistaSaveDialogExecute(Sender: TObject);
var
  c: IFileDialogCustomize;
begin
  if VistaSaveDialog.Dialog.QueryInterface(IFileDialogCustomize, c) = S_OK then
  begin
    c.StartVisualGroup(0, 'Encoding:');
    c.AddComboBox(2);
    c.AddControlItem(2, 1, 'ANSI');
    c.AddControlItem(2, 2, 'UTF-8');
    c.AddControlItem(2, 3, 'Unicode');
    c.AddControlItem(2, 4, 'Unicode Big Endian');
    c.EndVisualGroup;
    c.SetSelectedControlItem(2, 2);
  end;
end;

procedure TSaveDialogWrapper.VistaSaveDialogFileOkClick(Sender: TObject; var CanClose: Boolean);
var
  c: IFileDialogCustomize;
  e: Cardinal;
begin
  if VistaSaveDialog.Dialog.QueryInterface(IFileDialogCustomize, c) = S_OK then
  begin
    c.GetSelectedControlItem(2, e);
    case e of
      1: FEncoding := feAnsi;
      3: FEncoding := feUnicode_LE;
      4: FEncoding := feUnicode_BE;
    else
      FEncoding := feUtf8;
    end;
  end;
end;
{$ENDIF}

constructor TSaveDialogWrapper.Create(AOwner: TComponent);
begin
  inherited;
  FEncoding := feUtf8;
  {$IFDEF VISTA_STYLE}
  if Win32MajorVersion >= 6 then
  begin
    VistaSaveDialog := TFileSaveDialog.Create(Self);
    VistaSaveDialog.OnExecute := VistaSaveDialogExecute;
    VistaSaveDialog.OnFileOkClick := VistaSaveDialogFileOkClick;
  end
  else
  {$ENDIF}
    CommonSaveDialog := TSaveDialog.Create(Self);
end;

destructor TSaveDialogWrapper.Destroy;
begin
  CommonSaveDialog.Free;
  {$IFDEF VISTA_STYLE}
  VistaSaveDialog.Free;
  {$ENDIF}
  inherited;
end;

end.
