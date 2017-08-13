  {      LDAPAdmin - Prefs.pas
  *      Copyright (C) 2003-2013 Tihomir Karlovic
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

unit Prefs;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
{$IFnDEF FPC}
  Windows,
{$ELSE}
  LCLIntf, LCLType,
{$ENDIF}
  SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, ExtCtrls, Constant, Samba, LDAPClasses, Connection;

type
  TPrefDlg = class(TForm)
    PageControl: TPageControl;
    tsPosix: TTabSheet;
    tsID: TTabSheet;
    tsSamba: TTabSheet;
    tsMAil: TTabSheet;
    Panel1: TPanel;
    gbDefaults: TGroupBox;
    lblHomeDir: TLabel;
    lblLoginShell: TLabel;
    edHomeDir: TEdit;
    edLoginShell: TEdit;
    gbMailDefaults: TGroupBox;
    lblMD: TLabel;
    lblMA: TLabel;
    edMaildrop: TEdit;
    edMailAddress: TEdit;
    OkBtn: TButton;
    CancelBtn: TButton;
    gbServer: TGroupBox;
    lblNetbios: TLabel;
    edNetbios: TEdit;
    lblDomainName: TLabel;
    cbDomain: TComboBox;
    edDisplayName: TEdit;
    edUsername: TEdit;
    lblUsername: TLabel;
    lblDisplayname: TLabel;
    BtnWizard: TButton;
    gbUserLimits: TGroupBox;
    lblFirstUId: TLabel;
    lblLastUid: TLabel;
    edFirstUID: TEdit;
    edLastUID: TEdit;
    gbGroupLimits: TGroupBox;
    lblFirstGid: TLabel;
    lblLastGid: TLabel;
    edFirstGID: TEdit;
    edLastGID: TEdit;
    gbGroups: TGroupBox;
    lblPosixGroup: TLabel;
    edGroup: TEdit;
    SetBtn: TButton;
    cbxExtendGroups: TCheckBox;
    cbExtendGroups: TComboBox;
    gbID: TRadioGroup;
    //PageControl1: TPageControl;
    //TabSheet1: TTabSheet;
    //TabSheet2: TTabSheet;
    cbxLMPasswords: TCheckBox;
    lblScript: TLabel;
    lblHomeShare: TLabel;
    lblProfilePath: TLabel;
    lblHomeDrive: TLabel;
    edScript: TEdit;
    edHomeShare: TEdit;
    edProfilePath: TEdit;
    cbHomeDrive: TComboBox;
    Bevel1: TBevel;
    rgRid: TRadioGroup;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure SetBtnClick(Sender: TObject);
    procedure PageControlChange(Sender: TObject);
    procedure BtnWizardClick(Sender: TObject);
    procedure cbxExtendGroupsClick(Sender: TObject);
    procedure IDGroupClick(Sender: TObject);
  private
    Connection: TConnection;
    DomList: TDomainList;
  public
    constructor Create(AOwner: TComponent; AConnection: TConnection); reintroduce; overload;
  end;

var
  PrefDlg: TPrefDlg;

implementation

{$I LdapAdmin.inc}

uses Pickup, {$ifdef mswindows}WinLDAP,{$else} LinLDAP,{$endif}PrefWiz, Main, Config
     {$IFDEF VER_XEH}, System.UITypes{$ENDIF};

{$R *.dfm}

constructor TPrefDlg.Create(AOwner: TComponent; AConnection: TConnection);
var
  idx: Integer;
begin
  inherited Create(AOwner);
  Connection := AConnection;
  with Connection.Account do
  begin
    try
      gbID.ItemIndex       := ReadInteger(rPosixIDType, POSIX_ID_RANDOM)
    except end;
    gbID.OnClick           := IDGroupClick;
    edFirstUID.Text        := IntToStr(ReadInteger(rposixFirstUID, FIRST_UID));
    edLastUID.Text         := IntToStr(ReadInteger(rposixLastUID,  LAST_UID));
    edFirstGID.Text        := IntToStr(ReadInteger(rposixFirstGID, FIRST_GID));
    edLastGID.Text         := IntToStr(ReadInteger(rposixLastGID,  LAST_GID));
    edUserName.Text        := ReadString(rposixUserName, '');
    edDisplayName.Text     := ReadString(rinetDisplayName, '');
    edHomeDir.Text         := ReadString(rposixHomeDir, '');
    edLoginShell.Text      := ReadString(rposixLoginShell, '');
    if ReadInteger(rposixGroup, NO_GROUP) <> NO_GROUP then
      edGroup.Text         := Connection.GetDN(Format(sGROUPBYGID, [ReadInteger(rposixGroup, NO_GROUP)]));
    edNetbios.Text         := ReadString(rsambaNetbiosName, '');
    edHomeShare.Text       := ReadString(rsambaHomeShare, '');
    cbHomeDrive.ItemIndex  := cbHomeDrive.Items.IndexOf(ReadString(rsambaHomeDrive, ''));
    edScript.Text          := ReadString(rsambaScript, '');
    edProfilePath.Text     := ReadString(rsambaProfilePath, '');
    cbxLMPasswords.Checked := ReadBool(rSambaLMPasswords);
    rgRid.ItemIndex        := ReadInteger(rSambaRidMethod);
    edMailAddress.Text     := ReadString(rpostfixMailAddress, '');
    edMaildrop.Text        := ReadString(rpostfixMaildrop, '');
    idx := ReadInteger(rPosixGroupOfUnames, 0) - 1;
    if idx >= 0 then
    begin
      cbxExtendGroups.Checked := true;
      cbExtendGroups.ItemIndex := idx;
    end
    else
      cbxExtendGroupsClick(nil);
  end;
end;

procedure TPrefDlg.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if ModalResult = mrOK then
  with Connection.Account do begin
    WriteInteger(rPosixIDType,        gbID.ItemIndex);
    WriteInteger(rposixFirstUID,      StrToInt(edFirstUID.Text));
    WriteInteger(rposixLastUID,       StrToInt(edLastUID.Text));
    WriteInteger(rposixFirstGID,      StrToInt(edFirstGID.Text));
    WriteInteger(rposixLastGID,       StrToInt(edLastGID.Text));
    WriteString (rposixUserName,      edUserName.Text);
    WriteString (rinetDisplayName,    edDisplayName.Text);
    WriteString (rposixHomeDir,       edHomeDir.Text);
    WriteString (rposixLoginShell,    edLoginShell.Text);
    WriteInteger(rposixGroup,         StrToIntDef(Connection.Lookup(edGroup.Text, sANYCLASS, 'gidNumber', LDAP_SCOPE_BASE), NO_GROUP));
    WriteString (rsambaNetbiosName,   edNetbios.Text);
    WriteString (rsambaDomainName,    cbDomain.Text);
    WriteString (rsambaHomeShare,     edHomeShare.Text);
    WriteString (rsambaHomeDrive,     cbHomeDrive.Text);
    WriteString (rsambaScript,        edScript.Text);
    WriteString (rsambaProfilePath,   edProfilePath.Text);
    WriteBool   (rSambaLMPasswords,   cbxLMPasswords.Checked);
    WriteInteger (rsambaRidMethod,    rgRid.ItemIndex);
    WriteString (rpostfixMailAddress, edMailAddress.Text);
    WriteString (rpostfixMaildrop,    edMaildrop.Text);
    WriteInteger(rPosixGroupOfUnames, cbExtendGroups.ItemIndex + 1);
  end;
  Action := caFree;
end;

procedure TPrefDlg.SetBtnClick(Sender: TObject);
begin
  with TPickupDlg.Create(self) do begin
    Caption := cPickGroups;
    ColumnNames := cName + ',' + cDescription;
    Populate(Connection, sPOSIXGROUPS, ['cn', 'description']);
    Images:=MainFrm.ImageList;
    ImageIndex:=bmGroup;

    ShowModal;

    if (SelCount>0) then edGroup.Text:=Selected[0].Dn;

    Free;
  end;
end;

procedure TPrefDlg.PageControlChange(Sender: TObject);
var
  i: Integer;
begin
  if not Assigned(DomList) then
  try
    DomList := TDomainList.Create(Connection);
    with cbDomain do
    begin
      for i := 0 to DomList.Count - 1 do
        Items.Add(DomList.Items[i].DomainName);
      ItemIndex := Items.IndexOf(Connection.Account.ReadString(rSambaDomainName, ''));
      if ItemIndex = -1 then
        ItemIndex := 0;
    end;
  except
  // TODO
  end;
end;

procedure TPrefDlg.BtnWizardClick(Sender: TObject);
begin
  PageControlChange(nil); // Get domain list
  TPrefWizDlg.Create(Self).ShowModal;
end;

procedure TPrefDlg.cbxExtendGroupsClick(Sender: TObject);
begin
  with cbExtendGroups do
  if cbxExtendGroups.Checked then
  begin
    Enabled := true;
    Color := clWindow;
    ItemIndex := 0;
  end
  else begin
    Enabled := false;
    Color := clBtnFace;
    ItemIndex := -1;
  end;
end;

procedure TPrefDlg.IDGroupClick(Sender: TObject);
var
  Msg: string;
begin
  Case gbId.ItemIndex of
    0: Msg := stNoPosixID;
    2: Msg := stSequentialID;
  else
    Msg := '';
  end;
  if Msg <> '' then
    MessageDlg(Msg, mtWarning, [mbOk], 0);
end;

end.
