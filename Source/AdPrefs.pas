  {      LDAPAdmin - AdPrefs.pas
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

unit AdPrefs;

interface

uses
  {$ifdef mswindows}  Windows, {$endif}
  Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, ExtCtrls, Constant, LDAPClasses, Connection;

const
  psCN          = '%f %l';
  psDisplayName = psCN;
  psUPN         = '%f.%l';
  psNTLoginName = psUPN;
  psHomeDrive   = 'H:';
  psHomeDir     = '\home\%u';
  psLoginScript = '%u.cmd';
  psProfilePath = '\\%n\profiles\%u';

type
  TAdPrefDlg = class(TForm)
    Panel1: TPanel;
    OkBtn: TButton;
    CancelBtn: TButton;
    BtnDefault: TButton;
    gbDefaults: TGroupBox;
    lblUPN: TLabel;
    lblNTLogon: TLabel;
    lblCN: TLabel;
    lblDisplayname: TLabel;
    edUPN: TEdit;
    edNTLoginName: TEdit;
    edDisplayName: TEdit;
    edCN: TEdit;
    GroupBox1: TGroupBox;
    lblScript: TLabel;
    lblHomeShare: TLabel;
    lblProfilePath: TLabel;
    lblHomeDrive: TLabel;
    edScript: TEdit;
    edHomeDir: TEdit;
    edProfilePath: TEdit;
    cbHomeDrive: TComboBox;
    cbUpnDomain: TComboBox;
    edNTDomain: TEdit;
    Label1: TLabel;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BtnDefaultClick(Sender: TObject);
  private
    Connection: TConnection;
  public
    constructor Create(AOwner: TComponent; AConnection: TConnection); reintroduce; overload;
  end;

var
  AdPrefDlg: TAdPrefDlg;

implementation

{$I LdapAdmin.inc}

uses
  {$ifdef mswindows}
   WinLdap,
  {$else}
   LinLDAP,
  {$endif}
  ADObjects,
  Pickup, Main,  Config {$IFDEF VER_XEH}, System.UITypes{$ENDIF};

{$R *.dfm}

procedure TAdPrefDlg.BtnDefaultClick(Sender: TObject);
begin
  edCN.Text := psCN;
  edDisplayName.Text := psDisplayName;
  edUPN.Text := psUPN;
  cbHomeDrive.ItemIndex := cbHomeDrive.Items.IndexOf(psHomeDrive);
  edHomeDir.Text := psHomeDir;
  edScript.Text := psLoginScript;
  edProfilePath.Text := psProfilePath;
end;

constructor TAdPrefDlg.Create(AOwner: TComponent; AConnection: TConnection);
var
  i: Integer;
begin
  inherited Create(AOwner);
  Connection := AConnection;
  with Connection.Account do
  begin
    with (Connection.Helper as TAdHelper) do
    for i := 0 to DNSRoot.Count - 1 do
      cbUpnDomain.Items.Add('@' + DNSRoot[i]);
    edCN.Text              := ReadString(rAdCommonName, psCN);
    edDisplayName.Text     := ReadString(rAdDisplayName, psDisplayName);
    edUPN.Text             := ReadString(rAdUserPrincipalName, psUPN);
    cbUPNDomain.ItemIndex  := cbUpnDomain.Items.IndexOf(ReadString(rAdUpnDomain));
    if (cbUPNDomain.Items.Count > 0) and (cbUPNDomain.ItemIndex = -1) then
      cbUPNDomain.ItemIndex  := 0;
    edNTLoginName.Text     := ReadString(rAdNTLoginName, psNTLoginName);
    edNTDomain.Text        := ReadString(rADNTDomain, (Connection.Helper as TAdHelper).NTDomain);
    edHomeDir.Text         := ReadString(rAdHomeDirectory, psHomeDir);
    cbHomeDrive.ItemIndex  := cbHomeDrive.Items.IndexOf(ReadString(rAdHomeDrive, psHomeDrive));
    edScript.Text          := ReadString(rAdLoginScript, psLoginScript);
    edProfilePath.Text     := ReadString(rAdProfilePath, psProfilePath);
  end;
end;

procedure TAdPrefDlg.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if ModalResult = mrOK then
  with Connection.Account do begin
    WriteString (rAdCommonName,       edCN.Text);
    WriteString (rAdDisplayName,      edDisplayName.Text);
    WriteString (rAdUserPrincipalName,edUPN.Text);
    WriteString (rAdUPNDomain,        cbUPNDomain.Text);
    WriteString (rAdNTLoginName,      edNTLoginName.Text);
    WriteString (rAdNTDomain,         edNTDomain.Text);
    WriteString (rAdHomeDirectory,    edHomeDir.Text);
    WriteString (rAdHomeDrive,        cbHomeDrive.Text);
    WriteString (rAdLoginScript,      edScript.Text);
    WriteString (rAdProfilePath,      edProfilePath.Text);
  end;
  Action := caFree;
end;

end.
