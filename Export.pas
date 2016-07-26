  {      LDAPAdmin - Export.pas
  *      Copyright (C) 2003-2016 Tihomir Karlovic
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

unit Export;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
{$IFnDEF FPC}
  Windows, WinLDAP,
{$ELSE}
  LCLIntf, LCLType, LMessages, LinLDAP,
{$ENDIF}
  SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ExtCtrls, Dialogs, LDAPClasses, ComCtrls, Xml, DlgWrap,
  TextFile;

type
  TExportDlg = class(TForm)
    OKBtn: TButton;
    CancelBtn: TButton;
    Notebook: TNoteBook;
    Page1: TPage;
    Page2: TPage;
    Bevel1: TBevel;
    Label1: TLabel;
    BrowseBtn: TSpeedButton;
    edFileName: TEdit;
    SubDirsCbk: TCheckBox;
    Label2: TLabel;
    ProgressBar: TProgressBar;
    Label3: TLabel;
    ResultLabel: TLabel;
    Label5: TLabel;
    ExportingLabel: TLabel;
    Label4: TLabel;
    cbEncoding: TComboBox;
    Label6: TLabel;
    cbGenerateComments: TCheckBox;
    procedure BrowseBtnClick(Sender: TObject);
    procedure edFileNameChange(Sender: TObject);
    procedure OKBtnClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure SubDirsCbkClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure cbEncodingChange(Sender: TObject);
  private
    SaveDialog:   TSaveDialogWrapper;
    fEntryList:   TLdapEntryList;
    fdnList:      TStringList;
    fCount:       Integer;
    FAttributes:  array of string;
    FScope:       Cardinal;
    Session:      TLDAPSession;
    fTickCount:   Cardinal;
    fTickStep:    Cardinal;
    fEncoding:    TFileEncode;
    procedure     SearchCallback(Sender: TLdapEntryList; var AbortSearch: Boolean);
    procedure     XmlCallback(Node: TXmlNode);
    procedure     Prepare(const Filter: string);
    procedure     WriteToLdif(UnixWrite: Boolean);
    procedure     WriteToDsml;
  public
    constructor   Create(const ASession: TLDAPSession; const CanSubDirs: boolean=true); reintroduce; overload;
    constructor   Create(const adn: string; const ASession: TLDAPSession; AAttributes: array of string; const CanSubDirs: boolean=true); reintroduce; overload;
    procedure     AddDn(const adn: string);
  end;

var
  ExportDlg: TExportDlg;

implementation

uses LDIF, Dsml, Constant;

{$R *.dfm}

function TrimPath(const s: string; const MaxLen: Integer): string;
var
  p, pr: PChar;
begin
  SetString(Result, PChar(s), Length(s));
  if length(Result) <= MaxLen then
    Exit;
  p := PChar(Result);
  p[MaxLen] := #0;

  pr := AnsiStrRScan(p, ',');
  if pr <> nil then
  begin
    SetLength(Result, pr-p+1);
    Result := Result + '..';
  end;
end;

procedure TExportDlg.SearchCallback(Sender: TLdapEntryList; var AbortSearch: Boolean);
var
  t: Cardinal;
begin
  t := GetTickCount64;
  if t > fTickCount then
  begin
    fTickCount := t + fTickStep;
    inc(fTickStep, fTickStep shr 1);
    if ProgressBar.Position < MaxInt * 0.9 then
      ProgressBar.StepIt;
  end;
end;

procedure TExportDlg.XmlCallback(Node: TXmlNode);
begin
  if Node.Name = 'dsml:entry' then
  begin
    ProgressBar.StepIt;
    inc(fCount);
  end;
end;

constructor TExportDlg.Create(const ASession: TLDAPSession; const CanSubDirs: boolean=true);
begin
  inherited Create(nil);
  SaveDialog := TSaveDialogWrapper.Create(Self);
  with SaveDialog do begin
    EncodingCombo := false;
    Filter := 'Ldif file, Windows format (CR/LF) (*.ldif)|*.ldif|Ldif file, Unix format (LF only) (*.ldif)|*.ldif|DSML (*.xml)|*.xml';
    DefaultExt := 'ldif';
    FilterIndex := 1;
  end;
  fEncoding := feUtf8;
  fEntryList := TLdapEntryList.Create;
  fdnList := TStringList.Create;
  Session := ASession;
  SubDirsCbk.Checked:=CanSubDirs;
  SubDirsCbk.Visible:=CanSubDirs;
  SubDirsCbkClick(nil);
end;

constructor TExportDlg.Create(const adn: string; const ASession: TLDAPSession; AAttributes: array of string; const CanSubDirs: boolean=true);
var
  i: Integer;
begin
  Create(ASession, CanSubdirs);
  AddDn(adn);
  setlength(FAttributes, length(AAttributes));
  for i:=0 to length(AAttributes)-1 do FAttributes[i]:=AAttributes[i];
end;

procedure TExportDlg.AddDn(const adn: string);
begin
  fdnList.Add(adn);
end;

procedure TExportDlg.BrowseBtnClick(Sender: TObject);
begin
  SaveDialog.DefaultFolder := ExtractFileDir(edFileName.Text);
  if SaveDialog.Execute then
    edFileName.Text := SaveDialog.FileName;
end;

procedure TExportDlg.cbEncodingChange(Sender: TObject);
begin
  case cbEncoding.ItemIndex of
    0: fEncoding := feAnsi;
    2: fEncoding := feUnicode_LE;
    3: fEncoding := feUnicode_BE;
  else
    fEncoding := feUtf8;
  end;
end;

procedure TExportDlg.Prepare(const Filter: string);
var
  i: Integer;
  s: string;
begin
  fEntryList.Clear;
  fTickStep := 1000;
  fTickCount := GetTickCount64 + fTickStep;
  ProgressBar.Step := MaxInt div 30;
  ProgressBar.Max := MaxInt;
  for i := 0 to fdnList.Count - 1 do
  begin
    s := fdnList[i];
    {$IFDEF VER130}
    { Some strange problem with Delphi5 compiler }
    if Assigned(FAttributes) then
      Session.Search(Filter, s, FScope, FAttributes, false, fEntryList, SearchCallback)
    else
      Session.Search(Filter, s, FScope, nil, false, fEntryList, SearchCallback)
    {$ELSE}
    Session.Search(Filter, s, FScope, FAttributes, false, fEntryList, SearchCallback);
    {$ENDIF}
  end;
  ProgressBar.Step := (MaxInt - ProgressBar.Position) div fEntryList.Count;
end;

procedure TExportDlg.WriteToLdif(UnixWrite: Boolean);
var
  ldif: TLDIFFile;
  i: Integer;
begin
  ldif := TLDIFFile.Create(edFileName.Text, fmWrite);
  ldif.UnixWrite := UnixWrite;
  ldif.Encoding := fEncoding;
  ldif.GenerateComments := cbGenerateComments.Checked;
  try
    Prepare(sANYCLASS);
    fCount := 0;
    for i := 0 to fEntryList.Count - 1 do
    begin
      ldif.WriteRecord(fEntryList[i]);
      inc(fCount);
      ProgressBar.StepIt;
    end;
  finally
    ldif.Free;
  end;
end;

procedure TExportDlg.WriteToDsml;
var
  dsml: TDsmlTree;
begin
  Prepare(sANYCLASS);
  dsml := TDsmlTree.Create(fEntryList);
  dsml.Encoding := fEncoding;
  dsml.GenerateComments := cbGenerateComments.Checked;
  try
    dsml.SaveToFile(edFileName.Text, XmlCallback);
  finally
    dsml.Free;
  end;
end;

procedure TExportDlg.edFileNameChange(Sender: TObject);
begin
  OkBtn.Enabled := edFileName.Text <> '';
end;

procedure TExportDlg.OKBtnClick(Sender: TObject);
begin
  if FileExists(edFileName.Text) and
     (MessageDlg(Format(stFileOverwrite, [edFileName.Text]), mtConfirmation, [mbYes, mbNo], 0) <> mrYes) then Exit;
  Notebook.PageIndex := 1;
  Application.ProcessMessages;
  try
    if lowercase(ExtractFileExt(edFileName.Text)) = '.xml' then
      SaveDialog.FilterIndex := 3;
    case SaveDialog.FilterIndex of
      1, 2: WriteToLdif(SaveDialog.FilterIndex = 2);
      3:    WriteToDsml;
    end;
    ResultLabel.Caption := Format(stExportSuccess, [fCount]);
  except
    OKBtn.Caption := cRetry;
    raise;
  end;
  OKBtn.Visible := false;
  CancelBtn.Caption := cClose;
  CancelBtn.Left := (Width - CancelBtn.Width) div 2;
  CancelBtn.Default := true;
end;

procedure TExportDlg.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action:=CaFree;
end;

procedure TExportDlg.SubDirsCbkClick(Sender: TObject);
begin
  if SubDirsCbk.Checked then
    FScope := LDAP_SCOPE_SUBTREE
  else
    FScope := LDAP_SCOPE_BASE;
end;

procedure TExportDlg.FormDestroy(Sender: TObject);
begin
  fdnList.Free;
  fEntryList.Free;
end;

procedure TExportDlg.FormShow(Sender: TObject);
var
  dn: string;
begin
  if fdnList.Count > 1 then
    dn := Format(stNumObjects, [fdnList.Count])
  else
    dn := TrimPath(fdnList[0], 40);
  ExportingLabel.Caption := dn;
  Label4.Caption := Label4.Caption + ExportingLabel.Caption;
  Label4.Hint := dn;
end;

end.
