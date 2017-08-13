  {      LDAPAdmin - AdComputer.pas
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

unit AdComputer;

interface

uses
  SysUtils, Controls, Forms, LDAPClasses, Constant, Connection, AdObjects,
  ComCtrls, StdCtrls, Classes {$ifdef mswindows},Vcl.AppEvnts, Vcl.ExtCtrls{$else}, ExtCtrls{$endif};

type
  TAdComputerDlg = class(TForm)
    OkBtn: TButton;
    CancelBtn: TButton;
    PageControl: TPageControl;
    GeneralSheet: TTabSheet;
    Label5: TLabel;
    Label3: TLabel;
    samAccountName: TEdit;
    location: TEdit;
    MembershipSheet: TTabSheet;
    Label34: TLabel;
    MembershipList: TListView;
    RemoveGroupBtn: TButton;
    AddGroupBtn: TButton;
    cbxServerTrustAccount: TCheckBox;
    cbxNTAccount: TCheckBox;
    Label1: TLabel;
    Label2: TLabel;
    cn: TEdit;
    description: TEdit;
    PrimaryGroupBtn: TButton;
    edPrimaryGroup: TEdit;
    Label33: TLabel;
    ApplyBtn: TButton;
    ApplicationEvents1: TApplicationProperties;
    Panel1: TPanel;
    Label4: TLabel;
    edFunction: TEdit;
    cbxTrustForDelegation: TCheckBox;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure PageControlChange(Sender: TObject);
    procedure EditChange(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure cnChange(Sender: TObject);
    procedure AddGroupBtnClick(Sender: TObject);
    procedure RemoveGroupBtnClick(Sender: TObject);
    procedure samAccountNameChange(Sender: TObject);
    procedure PrimaryGroupBtnClick(Sender: TObject);
    procedure ApplyBtnClick(Sender: TObject);
    procedure ApplicationEvents1Idle(Sender: TObject; var Done: Boolean);
    procedure cbxTrustForDelegationClick(Sender: TObject);
  private
    ParentDn: string;
    Connection: TConnection;
    Entry: TLdapEntry;
    FFlags: Cardinal;
    FMembershipHelper: TMembershipHelper;
    procedure Load;
    procedure Save;
  public
    constructor Create(AOwner: TComponent; dn: string; Connection: TConnection; Mode: TEditMode); reintroduce;
  end;

implementation


{$R *.dfm}

procedure TAdComputerDlg.Load;
begin
  cn.Text := Entry.AttributesByName['cn'].AsString;
  description.Text := Entry.AttributesByName['description'].AsString;
  ///samAccountName.Text := Entry.AttributesByName['samAccountName'].AsString.TrimRight(['$']);
  location.Text := Entry.AttributesByName['location'].AsString;

  FFlags := StrToInt(Entry.AttributesByName['userAccountControl'].AsString);
  if FFlags and UF_SERVER_TRUST_ACCOUNT <> 0 then
    edFunction.Text := stDomainController
  else
  if FFlags and UF_WORKSTATION_TRUST_ACCOUNT <> 0 then
    edFunction.Text := stWkstOrServer;

  if FFlags and UF_TRUSTED_FOR_DELEGATION <> 0 then
    cbxTrustForDelegation.Checked := true;

  Panel1.Visible := true;
  cn.Enabled := false;
  samAccountName.Enabled := false;

  Caption := Format(cPropertiesOf, [cn.Text]);
end;

procedure TAdComputerDlg.ApplicationEvents1Idle(Sender: TObject;
  var Done: Boolean);
var
  E: Boolean;
begin
  E := (esModified in Entry.State) and (cn.Text  <> '') and (samAccountName.Text <> '');
  if Assigned(FMembershipHelper) then
    E := E or FMembershipHelper.Modified;
  ApplyBtn.Enabled := E;
end;

procedure TAdComputerDlg.ApplyBtnClick(Sender: TObject);
var
  NewEntry: Boolean;
begin
  NewEntry := esNew in Entry.State;
  Save;
  if NewEntry then
  begin
    MembershipSheet.TabVisible := true;
    Entry.Read; // Reload, some settings can be forced via Group Policies
    Load;
  end;
end;

procedure TAdComputerDlg.cbxTrustForDelegationClick(Sender: TObject);
begin
  if cbxTrustForDelegation.Checked then
    FFlags := FFlags or UF_TRUSTED_FOR_DELEGATION
  else
    FFlags := FFlags and not UF_TRUSTED_FOR_DELEGATION;
  {$ifdef mswindows}
  Entry.AttributesByName['userAccountControl'].AsString := UIntToStr(FFlags);
  {$else}
  Entry.AttributesByName['userAccountControl'].AsString := IntToStr(FFlags);
  {$endif}
end;

procedure TAdComputerDlg.cnChange(Sender: TObject);
begin
  samAccountName.Text := cn.Text;
  EditChange(Sender);
end;

constructor TAdComputerDlg.Create(AOwner: TComponent; dn: string; Connection: TConnection; Mode: TEditMode);
begin
  inherited Create(AOwner);
  ParentDn := dn;
  Self.Connection := Connection;
  Entry := TLdapEntry.Create(Connection, dn);
  if Mode = EM_MODIFY then
  begin
    Entry.Read;
    Load;
  end
  else begin
    with Entry.ObjectClass do begin
      AddValue('top');
      AddValue('person');
      AddValue('organizationalPerson');
      AddValue('user');
      AddValue('computer');
      FFlags := UF_PASSWD_NOTREQD;
    end;
    cn.Enabled := true;
    MembershipSheet.TabVisible := false;
  end;
end;

procedure TAdComputerDlg.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if ModalResult = mrOk then
    Save;
  Action := caFree;
end;

procedure TAdComputerDlg.Save;
begin
  if cn.Text = '' then
    raise Exception.Create(stGroupNameReq);

  if esNew in Entry.State then
  begin
    Entry.dn := 'CN=' + EncodeLdapString(cn.Text) + ',' + ParentDn;
    Entry.AttributesByName['name'].AsString := cn.Text;
    if cbxServerTrustAccount.Checked then
      FFlags := FFlags or UF_SERVER_TRUST_ACCOUNT
    else
      FFlags := FFlags or UF_WORKSTATION_TRUST_ACCOUNT;
    {$ifdef mswindows}
    Entry.AttributesByName['userAccountControl'].AsString := UIntToStr(FFlags);
    {$else}
    Entry.AttributesByName['userAccountControl'].AsString := IntToStr(FFlags);
    {$endif}
  end;

  if cbxNTAccount.Checked then
    Entry.AdSetPassword(LowerCase(Copy(samAccountName.Text, 1, 14)));

  if Assigned(FMembershipHelper) then
    FMembershipHelper.Write
  else
    Entry.Write;
end;

procedure TAdComputerDlg.AddGroupBtnClick(Sender: TObject);
begin
  FMembershipHelper.Add;
  RemoveGroupBtn.Enabled := MembershipList.Items.Count > 0;
end;

procedure TAdComputerDlg.RemoveGroupBtnClick(Sender: TObject);
begin
  FMembershipHelper.Delete;
  if MembershipList.Items.Count = 0 then
    RemoveGroupBtn.Enabled := false;
end;

procedure TAdComputerDlg.samAccountNameChange(Sender: TObject);
begin
  Entry.AttributesByName['samAccountName'].AsString := Uppercase(Trim(samAccountName.Text)) + '$';
end;

procedure TAdComputerDlg.PageControlChange(Sender: TObject);
begin
  if PageControl.ActivePage = MembershipSheet then
  begin
    if not Assigned(FMembershipHelper) then
    try
      Screen.Cursor := crHourGlass;
      PageControl.Repaint;
      begin
        FMembershipHelper := TMembershipHelper.Create(Entry, MembershipList);
        edPrimaryGroup.Text := FMembershipHelper.PrimaryGroup;
        if MembershipList.Items.Count > 0 then
        begin
          MembershipList.Items[0].Selected := true;
          RemoveGroupBtn.Enabled := true;
        end;
      end;
    finally
      Screen.Cursor := crDefault;
    end;
  end;
end;

procedure TAdComputerDlg.PrimaryGroupBtnClick(Sender: TObject);
begin
  if FMembershipHelper.QueryPrimaryGroup = mrOk then
    edPrimaryGroup.Text := FMembershipHelper.PrimaryGroup;
end;

procedure TAdComputerDlg.EditChange(Sender: TObject);
var
  s: string;
begin
  with Sender as TCustomEdit do
  begin
    s := Trim(Text);
    Entry.AttributesByName[TControl(Sender).Name].AsString := s;
  end;
end;

procedure TAdComputerDlg.FormDestroy(Sender: TObject);
begin
  FMembershipHelper.Free;
  Entry.Free;
end;

end.
