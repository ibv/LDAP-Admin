  {      LDAPAdmin - Host.pas
  *      Copyright (C) 2003 Tihomir Karlovic
  *
  *      Author: Simon Zsolt
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

unit Host;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
  LCLIntf, LCLType, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, LDAPClasses, Constant, mormot.core.base;

type
  THostDlg = class(TForm)
    NameLabel: TLabel;
    cn: TEdit;
    GroupBox1: TGroupBox;
    OKBtn: TButton;
    CancelBtn: TButton;
    ipHostNumber: TEdit;
    IPLabel: TLabel;
    cnList: TListBox;
    AddHostBtn: TButton;
    EditHostBtn: TButton;
    DelHostBtn: TButton;
    description: TEdit;
    Label2: TLabel;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure AddHostBtnClick(Sender: TObject);
    procedure EditHostBtnClick(Sender: TObject);
    procedure DelHostBtnClick(Sender: TObject);
    procedure cnListClick(Sender: TObject);
    procedure EditChange(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    Entry: TLDAPEntry;
    procedure Save;
  public
    constructor Create(AOwner: TComponent; dn: string; Session: TLDAPSession; Mode: TEditMode); reintroduce;
  private
    procedure HostButtons(Enable: Boolean);
  end;

var
  OuDlg: THostDlg;

implementation

uses Input;

{$R *.dfm}

procedure THostDlg.Save;
begin
  if cn.Text = '' then
    raise Exception.Create(Format(stReqNoEmpty, [cName]));
  if ipHostNumber.Text = '' then
    raise Exception.Create(Format(stReqNoEmpty, [cIpAddress]));
  if esNew in Entry.State then
  begin
    Entry.dn := 'cn=' + EncodeLdapString(cn.Text) + ',' + Entry.dn;
    Entry.AttributesByName['cn'].AddValue(cn.Text);
  end;
  Entry.Write;
end;


constructor THostDlg.Create(AOwner: TComponent; dn: string; Session: TLDAPSession; Mode: TEditMode);
var
  i: Integer;
  attrValue: string;
begin
  inherited Create(AOwner);
  Entry := TLDAPEntry.Create(Session, dn);
  if Mode = EM_MODIFY then
  begin
    Entry.Read;
    cn.Enabled := False;
    cn.Text := DecodeLdapString(GetNameFromDn(dn));
    Caption := Format(cPropertiesOf, [cn.Text]);
    ipHostNumber.Text := Entry.AttributesByName['iphostnumber'].AsString;
    description.Text := Entry.AttributesByName['description'].AsString;
    with Entry.AttributesByName['cn'] do
    for i := 0 to ValueCount - 1 do
    begin
      attrValue := Values[i].AsString;
      if CompareText(attrValue, cn.Text) <> 0 then
        cnList.Items.Add(attrValue);
    end;
  end
  else begin
    with Entry.Attributes.Add('objectclass') do
    begin
      AddValue('top');
      AddValue('device');
      AddValue('ipHost');
    end;
  end;
end;

procedure THostDlg.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if ModalResult = mrOK then
    Save;
  Action := caFree;
end;

procedure THostDlg.HostButtons(Enable: Boolean);
begin
  Enable := Enable and (cnList.ItemIndex > -1);
  DelHostBtn.Enabled := Enable;
  EditHostBtn.Enabled := Enable;
end;

procedure THostDlg.AddHostBtnClick(Sender: TObject);
var
  s: RawUtf8;
begin
  s := '';
  if InputDlg(cAddHost, cHostName, s) and (s <> '') then
  begin
    Entry.AttributesByName['cn'].AddValue(s);
    cnList.Items.Add(s);
    HostButtons(true);
  end;
end;

procedure THostDlg.EditHostBtnClick(Sender: TObject);
var
  s: RawUtf8;
begin
  s := cnList.Items[cnList.ItemIndex];
  if InputDlg(cEditHost, cHostName, s) then
  begin
    with Entry.AttributesByName['cn'] do
      Values[IndexOf(cnList.Items[cnList.ItemIndex])].AsString := s;
    cnList.Items[cnList.ItemIndex] := s;
  end;
end;

procedure THostDlg.DelHostBtnClick(Sender: TObject);
var
  idx: Integer;
begin
  with cnList do begin
    idx := ItemIndex;
    Entry.AttributesByName['cn'].DeleteValue(Items[idx]);
    Items.Delete(idx);
    if idx < Items.Count then
      ItemIndex := idx
    else
      ItemIndex := Items.Count - 1;
    Tag := 1;
    if Items.Count = 0 then
      HostButtons(false);
  end;
end;

procedure THostDlg.cnListClick(Sender: TObject);
begin
  HostButtons(true);
end;

procedure THostDlg.EditChange(Sender: TObject);
begin
  with Sender as TEdit do
    Entry.AttributesByName[Name].AsString := Text;
end;

procedure THostDlg.FormDestroy(Sender: TObject);
begin
  Entry.Free;
end;

end.
