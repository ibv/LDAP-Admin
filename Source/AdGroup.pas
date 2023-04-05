  {      LDAPAdmin - AdGroup.pas
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

unit AdGroup;

interface

uses
  Windows,
  Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, ExtCtrls, LDAPClasses, Core, TemplateCtrl, Constant,
  Connection, AdObjects;

type
  TAdGroupDlg = class(TForm)
    Label1: TLabel;
    cn: TEdit;
    Label2: TLabel;
    description: TEdit;
    OkBtn: TButton;
    CancelBtn: TButton;
    PageControl: TPageControl;
    MemberSheet: TTabSheet;
    MemberList: TListView;
    AddUserBtn: TButton;
    RemoveUserBtn: TButton;
    OptionsSheet: TTabSheet;
    Label5: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    samAccountName: TEdit;
    mail: TEdit;
    info: TMemo;
    MembershipSheet: TTabSheet;
    Label34: TLabel;
    MembershipList: TListView;
    RemoveGroupBtn: TButton;
    AddGroupBtn: TButton;
    gbScope: TGroupBox;
    gbType: TGroupBox;
    rbLocal: TRadioButton;
    rbGlobal: TRadioButton;
    rbUniversal: TRadioButton;
    rbSecurity: TRadioButton;
    rbDistribution: TRadioButton;
    ApplyBtn: TButton;
    ///ApplicationEvents1: TApplicationEvents;
    ApplicationEvents1: TApplicationProperties;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure AddUserBtnClick(Sender: TObject);
    procedure RemoveUserBtnClick(Sender: TObject);
    procedure ListViewColumnClick(Sender: TObject; Column: TListColumn);
    procedure ListViewCompare(Sender: TObject; Item1, Item2: TListItem;
      Data: Integer; var Compare: Integer);
    procedure PageControlChange(Sender: TObject);
    procedure EditChange(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure cnChange(Sender: TObject);
    procedure AddGroupBtnClick(Sender: TObject);
    procedure RemoveGroupBtnClick(Sender: TObject);
    procedure rbSecurityClick(Sender: TObject);
    procedure ApplyBtnClick(Sender: TObject);
    procedure ApplicationEvents1Idle(Sender: TObject; var Done: Boolean);
  private
    ParentDn: string;
    Connection: TConnection;
    Entry: TLdapEntry;
    ColumnToSort: Integer;
    Descending: Boolean;
    EventHandler: TEventHandler;
    FMembershipHelper: TMembershipHelper;
    procedure Load;
    procedure Save;
    function  GetGroupType: Cardinal;
    procedure SetGroupType;
    procedure TemplateCbxClick(Sender: TObject);
  public
    constructor Create(AOwner: TComponent; dn: string; Connection: TConnection; Mode: TEditMode; APosixGroup: Boolean = true; AGroupOfUniqueNames: Integer = 0); reintroduce;
    procedure InitiateAction; override;
  end;

var
  AdGroupDlg: TAdGroupDlg;

implementation

uses Pickup, LinLDAP, Input, Main, Templates, Misc, Config;

{$R *.dfm}

const
  ManagedAttributes: array [0..7] of string = (
    'cn',
    'description',
    'groupType',
    'info',
    'mail',
    'member',
    'memberOf',
    'samAccountName');


procedure TAdGroupDlg.Load;
var
  ListItem: TListItem;
  i: Integer;
  val: TLdapAttributeData;
begin
  cn.Text := Entry.AttributesByName['cn'].AsString;
  description.Text := Entry.AttributesByName['description'].AsString;
  samAccountName.Text := Entry.AttributesByName['samAccountName'].AsString;
  mail.Text := Entry.AttributesByName['mail'].AsString;
  info.Text := Entry.AttributesByName['info'].AsString;

  SetGroupType;

  with Entry.AttributesByName['member'] do
    for i := 0 to ValueCount - 1 do
    begin
      ListItem := MemberList.Items.Add;
      val := Values[i];
      ListItem.Caption := GetNameFromDn(val.AsString);
      ListItem.Data := val;
      ListItem.ImageIndex := -1;
    end;

  MemberList.AlphaSort;
  if MemberList.Items.Count > 0 then
  begin
    MemberList.Items[0].Selected := true;
    RemoveUserBtn.Enabled := true;
  end;

  cn.Enabled := false;
  gbType.Enabled := false;
  gbScope.Enabled := false;
  rbLocal.Enabled := rbLocal.Checked;
  rbGlobal.Enabled := rbGlobal.Checked;
  rbUniversal.Enabled := rbUniversal.Checked;
  rbSecurity.Enabled := rbSecurity.Checked;
  rbDistribution.Enabled := rbDistribution.Checked;
  Caption := Format(cPropertiesOf, [cn.Text]);
end;

procedure TAdGroupDlg.cnChange(Sender: TObject);
begin
  if esNew in Entry.State then
    samAccountName.Text := cn.Text;
  EditChange(Sender);
end;

constructor TAdGroupDlg.Create(AOwner: TComponent; dn: string; Connection: TConnection; Mode: TEditMode; APosixGroup: Boolean = true; AGroupOfUniqueNames: Integer = 0);
var
  n: Integer;
  TemplateList: TTemplateList;
  TabSheet: TTabSheet;
  Oc: TLdapAttribute;
  cbx: TCheckBox;
begin
  inherited Create(AOwner);
  MemberList.SmallImages := MainFrm.ImageList;
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
      AddValue('group');
    end;
    MembershipSheet.TabVisible := false;
    cn.Enabled := true;
    rbUniversal.Enabled := false;
  end;

  // Show template extensions
  TemplateList := nil;
  if GlobalConfig.ReadBool(rTemplateExtensions, true) then
    TemplateList := TemplateParser.Extensions['adgroup'];
  if Assigned(TemplateList) then
  begin
    if (Mode = EM_MODIFY) and GlobalConfig.ReadBool(rTemplateAutoload, true) then
      Oc := Entry.AttributesByName['objectclass']
    else
      Oc := nil;
    EventHandler := TEventHandler.Create;
    with TemplateList do
      for n := 0 to Count - 1 do
      begin
        TabSheet := TTabSheet.Create(PageControl);
        TabSheet.Caption := Templates[n].Name;
        TabSheet.PageControl := PageControl;
        TabSheet.Tag := Integer(TTemplatePanel.Create(Self));
        cbx := TCheckBox.Create(TabSheet);
        with TTemplatePanel(TabSheet.Tag) do begin
          Template := Templates[n];
          EventHandler := EventHandler;
          Parent := TabSheet;
          Left := 4;
          Top := 16 + cbx.Height + 4;
          Height := TabSheet.Height - Top;
          Width := TabSheet.Width - 8;
        end;
        with cbx do begin
          Parent := TabSheet;
          Left := 4;
          Top := 16;
          Width := TabSheet.Width - Left;
          if Templates[n].Description <> '' then
            Caption := Templates[n].Description
          else
            Caption := Templates[n].Name;
          OnClick := TemplateCbxClick;
          Checked := Assigned(Oc) and TTemplatePanel(TabSheet.Tag).Template.Matches(Oc);
        end;
      end;
  end;
end;

procedure TAdGroupDlg.InitiateAction;
var
  i: Integer;
  mc: Integer;
  M: TLdapEntry;
begin
  inherited;
  M := TLdapEntry.Create(Connection, '');
  with MemberList do if Assigned(TopItem) then
  try
    mc := TopItem.Index + VisibleRowCount;
    if mc > Items.Count then mc := Items.Count;
    for i := TopItem.Index to mc - 1 do with Items[i] do
      if ImageIndex = -1 then
      begin
        M.dn := TLdapAttributeData(Data).AsString;
        M.Read(['objectclass']);
        ImageIndex := ObjectIdToImage[Connection.DI.ClassifyLdapEntry(M)];
        SubItems.Add(CanonicalName(GetDirFromDN(M.dn)));
      end;
  finally
    M.Free;
  end;
end;

procedure TAdGroupDlg.TemplateCbxClick(Sender: TObject);
var
  i, j: Integer;
  s: string;

  function SafeDelete(const name: string): boolean;
  var
    i: Integer;
    s: string;
  begin
    Result := false;
    s := lowercase(name);
    for i := Low(ManagedAttributes) to High(ManagedAttributes) do
      if s = lowercase(ManagedAttributes[i]) then Exit;
    Result := true;
  end;

begin
  with (Sender as TCheckBox), TTemplatePanel(Parent.Tag) do
  if Checked then
  begin
    LdapEntry := Entry;
    Left := 4;
    Height := MemberSheet.Height - Top;
    Width := (Parent as TTabSheet).Width - 8;
  end
  else begin
    { Handle removing of the template - remove only attributes and
      objectclasses which are not used by builtin registers }
    for i := 0 to Attributes.Count - 1 do with Attributes[i] do
    begin
      if (lowercase(Name) = 'objectclass') then
      begin
        with Entry.AttributesByName['objectclass'] do
        for j := 0 to Template.ObjectclassCount - 1 do
        begin
          s := lowercase(Template.Objectclasses[j]);
          if (s <> 'top') and
             (s <> 'group') then
            DeleteValue(s);
        end;
      end
      else
      if SafeDelete(Name) then
        Entry.AttributesByName[Name].Delete;
    end;
    // Empty the template panel
    LdapEntry := nil;
  end;
end;

procedure TAdGroupDlg.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if ModalResult = mrOk then
    Save;
  Action := caFree;
end;

procedure TAdGroupDlg.Save;
begin
  if cn.Text = '' then
    raise Exception.Create(stGroupNameReq);

  if esNew in Entry.State then
    Entry.dn := 'CN=' + EncodeLdapString(cn.Text) + ',' + ParentDn;

  Entry.AttributesByName['name'].AsString := cn.Text;
  Entry.AttributesByName['groupType'].AsString := IntToStr(GetGroupType);

  if Assigned(FMembershipHelper) then
    FMembershipHelper.Write
  else
    Entry.Write;
end;

procedure TAdGroupDlg.AddGroupBtnClick(Sender: TObject);
begin
  FMembershipHelper.Add;
  RemoveGroupBtn.Enabled := MembershipList.Items.Count > 0;
end;

procedure TAdGroupDlg.AddUserBtnClick(Sender: TObject);
var
  MemberItem: TListItem;
  i: integer;
  Members: TLdapAttribute;
begin
  with TPickupDlg.Create(self) do
  try
    Screen.Cursor := crHourGlass;
    Caption := cPickMembers;
    ColumnNames := cColumnNames;
    Populate(Connection, '(|(objectclass=user)(objectclass=group)(objectclass=computer)(objectclass=inetOrgPerson))', ['cn', PSEUDOATTR_PATH]);
    if ShowModal = mrOk then
    try
      MemberList.Items.BeginUpdate;
      Members := Entry.AttributesByName['member'];
      for i:=0 to SelCount-1 do
      begin
        if Members.IndexOf(Selected[i].dn) <> -1 then
          continue;
        MemberItem := MemberList.Items.Add;
        MemberItem.Caption := Selected[i].AttributesByName['cn'].AsString;
        MemberItem.Data := Members.AddValue;
        TLdapAttributeData(MemberItem.Data).AsString := Selected[i].DN;
        MemberItem.ImageIndex := ObjectIdToImage[Connection.DI.ClassifyLdapEntry(Selected[i])];
        MemberItem.SubItems.Add(CanonicalName(GetDirFromDN(Selected[i].DN)));
      end;
    finally
      MemberList.Items.EndUpdate;
      Screen.Cursor := crDefault;
      if MemberList.Items.Count > 0 then
        RemoveUserBtn.Enabled := true;
    end;
  finally
    Free;
  end;
end;

procedure TAdGroupDlg.ApplicationEvents1Idle(Sender: TObject;
  var Done: Boolean);
var
  E: Boolean;
begin
  E := (esModified in Entry.State) and (cn.Text  <> '') and (samAccountName.Text <> '');
  if Assigned(FMembershipHelper) then
    E := E or FMembershipHelper.Modified;
  ApplyBtn.Enabled := E;
end;

procedure TAdGroupDlg.ApplyBtnClick(Sender: TObject);
var
  NewEntry: Boolean;
begin
  NewEntry := esNew in Entry.State;
  Save;
  if NewEntry then
  begin
    MembershipSheet.TabVisible := true;
    Entry.Read; // Reload, some settings can be forced via Group Policies
    try
      MemberList.Items.BeginUpdate;
      MemberList.Clear;
      Load;
    finally
      MemberList.Items.EndUpdate;
    end;
  end;
end;

procedure TAdGroupDlg.RemoveGroupBtnClick(Sender: TObject);
begin
  FMembershipHelper.Delete;
  if MembershipList.Items.Count = 0 then
    RemoveGroupBtn.Enabled := false;
end;

procedure TAdGroupDlg.RemoveUserBtnClick(Sender: TObject);
var
  idx: Integer;
  Item, Item2: TListItem;
begin
  with MemberList do
  begin
    if Assigned(Selected) then
    try
      MemberList.Items.BeginUpdate;
      Item := Selected;

      repeat
        idx := Item.Index;
        TLdapAttributeData(Item.Data).Delete;
        Entry.AttributesByName['member'].DeleteValue(Item.Caption);
        Item2 := GetNextItem(Item, sdAll, [lisSelected]);
        Item.Delete;
        Item := Item2;
      until Item = nil;

      if idx >= Items.Count then
        idx := Items.Count - 1;
      if idx > -1 then
        Items[idx].Selected := true
      else
        RemoveUserBtn.Enabled := false;
    finally
      MemberList.Items.EndUpdate;
    end;
  end;
end;

procedure TAdGroupDlg.ListViewColumnClick(Sender: TObject; Column: TListColumn);
begin
  if ColumnToSort <> Column.Index then
  begin
    ColumnToSort := Column.Index;
    Descending := false;
  end
  else
    Descending := not Descending;
  (Sender as TCustomListView).AlphaSort;
end;

procedure TAdGroupDlg.ListViewCompare(Sender: TObject; Item1, Item2: TListItem; Data: Integer; var Compare: Integer);
var
  ix: Integer;
begin
  if ColumnToSort = 0 then
    Compare := CompareText(Item1.Caption,Item2.Caption)
  else
  begin
    Compare := -1;
    ix := ColumnToSort - 1;
    if Item1.SubItems.Count > ix then
    begin
      Compare := 1;
      if Item2.SubItems.Count > ix then
        Compare := AnsiCompareText(Item1.SubItems[ix],Item2.SubItems[ix]);
    end;
  end;
  if Descending then
    Compare := - Compare;
end;

procedure TAdGroupDlg.PageControlChange(Sender: TObject);
begin
  if PageControl.ActivePage = MembershipSheet then
  begin
    if not Assigned(FMembershipHelper) then
    try
      Screen.Cursor := crHourGlass;
      PageControl.Repaint;
      begin
        FMembershipHelper := TMembershipHelper.Create(Entry, MembershipList);
        if MembershipList.Items.Count > 0 then
        begin
          MembershipList.Items[0].Selected := true;
          RemoveGroupBtn.Enabled := true;
        end;
      end;
    finally
      Screen.Cursor := crDefault;
    end;
  end
  else
  if PageControl.ActivePageIndex > 2 then
     TTemplatePanel(PageControl.ActivePage.Tag).RefreshData;
end;

procedure TAdGroupDlg.rbSecurityClick(Sender: TObject);
begin
  rbUniversal.Enabled := not rbSecurity.Checked;
  if not rbUniversal.Enabled and rbUniversal.Checked then
  begin
    rbUniversal.Checked := false;
    rbLocal.Checked := true;
  end;
end;

function TAdGroupDlg.GetGroupType: Cardinal;
begin
  if rbGlobal.Checked then
    Result := GLOBAL_GROUP
  else
  if rbUniversal.Checked then
    Result := UNIVERSAL_GROUP
  else
    Result := DOMAIN_LOCAL_GROUP;

  if rbSecurity.Checked then
    Result := Result or SECURITY_ENABLED;
end;

procedure TAdGroupDlg.SetGroupType;
var
  val: Integer;
begin
  val := StrToInt(Entry.AttributesByName['groupType'].AsString);

  if val and SECURITY_ENABLED <> 0 then
    rbSecurity.Checked := true
  else
    rbDistribution.Checked := true;

  case val and not SECURITY_ENABLED of
    GLOBAL_GROUP:    rbGlobal.Checked := true;
    UNIVERSAL_GROUP: rbUniversal.Checked := true;
  else
    {DOMAIN_LOCAL_GROUP}
    rbLocal.Checked := true;
  end;
end;

procedure TAdGroupDlg.EditChange(Sender: TObject);
var
  s: string;
begin
  with Sender as TCustomEdit do
  begin
    s := Trim(Text);
    if Sender is TMemo then
      s := FormatMemoInput(s);
    Entry.AttributesByName[TControl(Sender).Name].AsString := s;
  end;
end;

procedure TAdGroupDlg.FormDestroy(Sender: TObject);
begin
  FMembershipHelper.Free;
  Entry.Free;
end;

end.
