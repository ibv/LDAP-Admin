  {      LDAPAdmin - Alias.pas
  *      Copyright (C) 2013-2016 Tihomir Karlovic
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

unit Alias;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
{$IFnDEF FPC}
  Windows,
{$ELSE}
  LCLIntf, LCLType, LMessages,
{$ENDIF}
  SysUtils, Messages, Classes, Graphics, Controls, EncodedDn,
  StdCtrls, ExtCtrls, Forms, LDAPClasses, Connection, Constant, mormot.core.base;

type
  TAliasDlg = class(TForm)
    Button1: TButton;
    Button2: TButton;
    GroupBox1: TGroupBox;
    edAliasDir: TEdit;
    btnAliasDir: TButton;
    edAliasNameValue: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    GroupBox2: TGroupBox;
    edObjectDN: TEdit;
    Label3: TLabel;
    btnObjDN: TButton;
    Label4: TLabel;
    edAliasDN: TEdit;
    cbAliasNameAttr: TComboBox;
    Label5: TLabel;
    procedure btnObjDNClick(Sender: TObject);
    procedure btnAliasDirClick(Sender: TObject);
    procedure edAliasDNChange(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    procedure edObjectDNChange(Sender: TObject);
  private
    fdn:         RawUtf8;
    fObjectDn:   TEncodedDn;
    fAliasDir:   TEncodedDn;
    fAliasDn:    TEncodedDn;
    fAliasAttr:  TEncodedDn;
    fAliasValue: TEncodedDn;
    fEntry:      TLdapEntry;
    fOnWrite:    TNotifyEvent;
  public
    constructor Create(AOwner: TComponent; dn: RawUtf8; Connection: TConnection; Mode: TEditMode; ObjectPath: Boolean = false); reintroduce;
    property    OnWrite: TNotifyEvent read fOnWrite write fOnWrite;
  end;

var
  AliasDlg: TAliasDlg;

implementation

uses Main;

{$R *.dfm}

constructor TAliasDlg.Create(AOwner: TComponent; dn: RawUtf8; Connection: TConnection; Mode: TEditMode; ObjectPath: Boolean = false);
var
  i, j: Integer;
begin
  inherited Create(AOwner);
  fObjectDn.Attach(edObjectDn);
  fAliasDn.Attach(edAliasDn);
  fAliasDir.Attach(edAliasDir);
  fAliasValue.Attach(edAliasNameValue);
  fAliasAttr.Attach(cbAliasNameAttr);

  fdn := dn;

  if Connection.Schema.Loaded then with Connection.Schema.Attributes do
    for i:= 0 to Count - 1 do with Items[i] do
      for j := 0 to Name.Count - 1 do
      cbAliasNameAttr.Items.Add(Name[j]);

  fEntry := TLDAPEntry.Create(Connection, dn);

  if Mode = EM_MODIFY then
  begin
    fEntry.Read;
    fObjectDN.Encoded := fEntry.AttributesByName['aliasedObjectName'].AsString;
    fAliasAttr.Encoded := GetAttributeFromDn(dn);
    fAliasValue.Encoded := GetNameFromDn(dn);
    fAliasDN.Encoded := dn;
    fAliasDir.Encoded := GetDirFromDN(dn);
    Caption := Format(cPropertiesOf, [edAliasNameValue.Text]);
    Label1.Caption := cParentDir;
  end
  else
  if ObjectPath then
    fObjectDn.Encoded := dn
  else
    fAliasDir.Encoded := dn;
end;

procedure TAliasDlg.btnObjDNClick(Sender: TObject);
var
  s: RawUtf8;
begin
  s := MainFrm.PickEntry(cSelectEntry);
  if s <> '' then
    fObjectDn.Encoded := s;
end;

procedure TAliasDlg.btnAliasDirClick(Sender: TObject);
var
  s: RawUtf8;
begin
  s := MainFrm.PickEntry(cSelectAliasDir);
  if s <> '' then
    fAliasDir.Encoded := s;
end;

procedure TAliasDlg.edAliasDNChange(Sender: TObject);
begin
  if (edAliasDir.Text = '') or (cbAliasNameAttr.Text = '') or (edAliasNameValue.Text = '') then
    fAliasDn.Encoded := ''
  else
    fAliasDn.Encoded := fAliasAttr.Encoded + '=' + fAliasValue.Encoded + ',' + fAliasDir.Encoded;
end;

procedure TAliasDlg.FormClose(Sender: TObject; var Action: TCloseAction);
var
  editMode: Boolean;
begin
  if ModalResult = mrOk then
  begin
    editMode := true;
    if esNew in fEntry.State then
    begin
      editMode := false;
      fEntry.Attributes.Clear;
      with fEntry.Attributes.Add('objectclass') do
      begin
        AddValue('top');
        AddValue('alias');
        AddValue('extensibleObject');
      end;
    end;
    fEntry.dn := fAliasDn.Encoded;
    fEntry.AttributesByName['aliasedObjectName'].AsString := fObjectDN.Encoded;
    fEntry.Write;
    { If editing and dn was changed a copy of the alias object is created at new dn }
    { so we need to delete the original entry effectively moving the entry to new dn }
    if editMode and (fdn <> fEntry.dn) then
      fEntry.Session.DeleteEntry(fdn);
    if Assigned(fOnWrite) then fOnWrite(fEntry);
  end;
  Action := caFree;
end;

procedure TAliasDlg.FormDestroy(Sender: TObject);
begin
  fEntry.Free;
end;

procedure TAliasDlg.edObjectDNChange(Sender: TObject);
begin
  if not edAliasNameValue.Modified then
  begin
    fAliasValue.Verbatim := fObjectDn.Verbatim;
    fAliasValue.Encoded := GetNameFromDn(fObjectDn.Encoded);
  end;
  fAliasAttr.Verbatim := fObjectDn.Verbatim;
  fAliasAttr.Encoded := GetAttributeFromDn(fObjectDn.Encoded);
end;

end.

