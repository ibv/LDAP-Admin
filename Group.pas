  {      LDAPAdmin - Group.pas
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

unit Group;

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
  Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, ExtCtrls, Samba, Posix, LDAPClasses, Core, TemplateCtrl,
  Constant, Connection;

type
  TGroupDlg = class(TForm)
    Label1: TLabel;
    edName: TEdit;
    Label2: TLabel;
    edDescription: TEdit;
    OkBtn: TButton;
    CancelBtn: TButton;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    UserList: TListView;
    AddUserBtn: TButton;
    RemoveUserBtn: TButton;
    TabSheet2: TTabSheet;
    cbSambaDomain: TComboBox;
    Label3: TLabel;
    RadioGroup1: TRadioGroup;
    cbBuiltin: TComboBox;
    edRid: TEdit;
    Label4: TLabel;
    cbSambaGroup: TCheckBox;
    Bevel1: TBevel;
    edDisplayName: TEdit;
    Label5: TLabel;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure AddUserBtnClick(Sender: TObject);
    procedure RemoveUserBtnClick(Sender: TObject);
    procedure UserListDeletion(Sender: TObject; Item: TListItem);
    procedure ListViewColumnClick(Sender: TObject; Column: TListColumn);
    procedure ListViewCompare(Sender: TObject; Item1, Item2: TListItem;
      Data: Integer; var Compare: Integer);
    procedure PageControl1Change(Sender: TObject);
    procedure cbSambaDomainChange(Sender: TObject);
    procedure RadioGroup1Click(Sender: TObject);
    procedure cbBuiltinChange(Sender: TObject);
    procedure cbSambaGroupClick(Sender: TObject);
    procedure edNameChange(Sender: TObject);
    procedure edDescriptionChange(Sender: TObject);
    procedure edDisplayNameChange(Sender: TObject);
    procedure edRidChange(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    ParentDn: string;
    Connection: TConnection;
    Entry: TLdapEntry;
    PosixGroup: TPosixGroup;
    SambaGroup: TSamba3Group;
    GroupOfUniqueNames: TGroupOfUniqueNames;
    IsSambaGroup: Boolean;
    ColumnToSort: Integer;
    Descending: Boolean;
    DomList: TDomainList;
    EventHandler: TEventHandler;
    procedure EnableControls(const Controls: array of TControl; Color: TColor; Enable: Boolean);
    procedure Load;
    function FindDataString(dstr: PChar): Boolean;
    procedure Save;
    function GetGroupType: Integer;
    procedure TemplateCbxClick(Sender: TObject);
  public
    constructor Create(AOwner: TComponent; dn: string; Connection: TConnection; Mode: TEditMode; APosixGroup: Boolean = true; AGroupOfUniqueNames: Integer = 0); reintroduce;
    procedure InitiateAction; override;
  end;

var
  GroupDlg: TGroupDlg;

implementation

uses Pickup, {$ifdef mswindows}WinLDAP,{$else} LinLDAP,{$endif} Input, Main, Templates, Misc, Config;

{$IFnDEF FPC}
  {$R *.dfm}
{$ELSE}
  {$R *.lfm}
{$ENDIF}

procedure TGroupDlg.EnableControls(const Controls: array of TControl; Color: TColor; Enable: Boolean);
var
  Control: TControl;
  i: Integer;
begin
  for i := Low(Controls) to High(Controls) do
  begin
    Control := Controls[i];
    if Assigned(Control) then
    begin
      if Control is TEdit then
        TEdit(Control).Color := Color
      else
      if Control is TComboBox then
        TComboBox(Control).Color := Color;
      if Control is TMemo then
        TMemo(Control).Color := Color;
      Control.Enabled := Enable;
    end;
  end;
end;

{ Note: Item.Caption = uid, Item.Data = dn }
procedure TGroupDlg.Load;
var
  ListItem: TListItem;
  i: Integer;
begin
  Entry.Read;
  with Entry.AttributesByName['objectclass'] do begin
    IsSambaGroup := IndexOf('sambagroupmapping') <> -1;
    if IndexOf('posixgroup') <> -1 then
      PosixGroup := TPosixGroup.Create(Entry);
    if IndexOf('groupofuniquenames') <> -1 then
      GroupOfUniqueNames := TGroupOfUniqueNames.Create(Entry)
    else
    if IndexOf('groupofnames') <> -1 then
      GroupOfUniqueNames := TGroupOfNames.Create(Entry)
  end;
  edName.Text := Entry.AttributesByName['cn'].AsString;
  edDescription.Text := Entry.AttributesByName['description'].AsString;
  if Assigned(GroupOfUniqueNames) then
    for i := 0 to GroupOfUniqueNames.MembersCount - 1 do
    begin
      ListItem := UserList.Items.Add;
      ListItem.Caption := GroupOfUniqueNames.Members[i];
      ListItem.Data := StrNew(PChar(ListItem.Caption));
      ListItem.SubItems.Add(CanonicalName(GetDirFromDN(PChar(ListItem.Data))));
    end
  else
    for i := 0 to PosixGroup.MembersCount - 1 do
    begin
      ListItem := UserList.Items.Add;
      ListItem.Caption := PosixGroup.Members[i];
    end;
  if UserList.Items.Count > 0 then
    RemoveUserBtn.Enabled := true;
end;

constructor TGroupDlg.Create(AOwner: TComponent; dn: string; Connection: TConnection; Mode: TEditMode; APosixGroup: Boolean = true; AGroupOfUniqueNames: Integer = 0);
var
  n: Integer;
  TemplateList: TTemplateList;
  TabSheet: TTabSheet;
  Oc: TLdapAttribute;
begin
  inherited Create(AOwner);
  ParentDn := dn;
  Self.Connection := Connection;
  Entry := TLdapEntry.Create(Connection, dn);
  if Mode = EM_MODIFY then
  begin
    Load;
    if not Assigned(PosixGroup) then
      TabSheet2.TabVisible := false
    else
    if IsSambaGroup then
    begin
      //SambaGroup := TSamba3Group.Create(Entry); -> happens in cbSambaGroupOnCheck
      cbSambaGroup.Checked := true;
      with RadioGroup1 do
      case SambaGroup.GroupType of
        2: ItemIndex := 0;
        4: ItemIndex := 1;
        5: begin
             ItemIndex := 2;
             n := StrToInt(SambaGroup.Rid) - 512;
             if (n >=0) and (n < cbBuiltin.Items.Count) then
               cbBuiltin.ItemIndex := n
             else
               cbBuiltin.ItemIndex := -1;
           end;
      end;
      edRid.Text := SambaGroup.Rid;
      edRid.Enabled := false;
      edDisplayName.Text := SambaGroup.DisplayName;
    end;
    edName.Enabled := false;
    Caption := Format(cPropertiesOf, [edName.Text]);
    UserList.AlphaSort;
  end
  else begin
    if APosixGroup then
    begin
      PosixGroup := TPosixGroup.Create(Entry);
      PosixGroup.New;
    end;
    case AGroupOfUniqueNames of
      1: GroupOfUniqueNames := TGroupOfUniqueNames.Create(Entry);
      2: GroupOfUniqueNames := TGroupOfNames.Create(Entry);
    end;
    if Assigned(GroupOfUniqueNames) then
      GroupOfUniqueNames.New;
  end;

  // Show template extensions
  TemplateList := nil;
  if GlobalConfig.ReadBool(rTemplateExtensions, true) then
    TemplateList := TemplateParser.Extensions['group'];
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
        TabSheet := TTabSheet.Create(PageControl1);
        TabSheet.Caption := Templates[n].Name;
        TabSheet.PageControl := PageControl1;
        TabSheet.Tag := Integer(TTemplatePanel.Create(Self));
        with TTemplatePanel(TabSheet.Tag) do begin
          Template := Templates[n];
          EventHandler := EventHandler;
          Parent := TabSheet;
          Left := 4;
          Top := cbSambaGroup.Top + cbSambaGroup.Height + 4;
          Height := TabSheet2.Height - Top;
          Width := TabSheet.Width - 8;
        end;
        with TCheckBox.Create(TabSheet) do begin
          Parent := TabSheet;
          Left := 4;
          Top := cbSambaGroup.Top;
          Width := Bevel1.Width;
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

procedure TGroupDlg.InitiateAction;
var
  i: Integer;
  mc: Integer;
begin
  inherited;
  with UserList do if Assigned(TopItem) then
  begin
    mc := TopItem.Index + VisibleRowCount;
    if mc > Items.Count then mc := Items.Count;
    for i := TopItem.Index to mc - 1 do
      if not Assigned(Items[i].Data) then
      begin
        Items[i].Data := StrNew(PChar(Connection.GetDN(Format(sACCNTBYUID, [Items[i].Caption]))));
        Items[i].SubItems.Add(CanonicalName(GetDirFromDN(PChar(Items[i].Data))));
      end;
  end;
end;

procedure TGroupDlg.TemplateCbxClick(Sender: TObject);
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
    if Assigned(GroupOfUniqueNames) then
      for i := Low(Core.PropAttrNames) to High(Core.PropAttrNames) do
        if s = lowercase(Core.PropAttrNames[i]) then Exit;
    for i := Low(Posix.PropAttrNames) to High(Posix.PropAttrNames) do
      if s = lowercase(Posix.PropAttrNames[i]) then Exit;
    Result := true;
  end;

begin
  with (Sender as TCheckBox), TTemplatePanel(Parent.Tag) do
  if Checked then
  begin
    LdapEntry := Entry;
    Left := 4;
    Top := cbSambaGroup.Top + cbSambaGroup.Height + 4;
    Height := TabSheet2.Height - Top;
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
             (s <> 'posixgroup') and
             not (Assigned(GroupOfUniqueNames) and (s = GroupOfUniqueNames.Objectclass)) then
          begin
            DeleteValue(s);
            if Assigned(SambaGroup) and (AnsiCompareText(s, SambaGroup.Objectclass) = 0) then
              cbSambaGroup.Checked := false
          end;
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

procedure TGroupDlg.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if ModalResult = mrOk then
    Save;
  Action := caFree;
end;

procedure TGroupDlg.Save;
var
  gidNr: Integer;
begin
  if edName.Text = '' then
    raise Exception.Create(stGroupNameReq);
  if cbSambaGroup.Checked and Assigned(DomList) and (cbSambaDomain.ItemIndex = -1) then
    raise Exception.Create(Format(stReqNoEmpty, [cSambaDomain]));
  if Assigned(PosixGroup) and (esNew in Entry.State) then
  begin
    gidNr := Connection.GetGid;
    if gidNr <> -1 then
    begin
      PosixGroup.GidNumber := gidNr;
      edRidChange(nil);  // Update sambaSid
    end;
  end;
  Entry.Write;
end;

function TGroupDlg.FindDataString(dstr: PChar): Boolean;
var
  i: Integer;
begin
  Result := false;
  for i := 0 to UserList.Items.Count - 1 do
    if AnsiStrComp(UserList.Items[i].Data, dstr) = 0 then
    begin
      Result := true;
      break;
    end;
end;

procedure TGroupDlg.AddUserBtnClick(Sender: TObject);
var
  UserItem: TListItem;
  i: integer;
begin
  with TPickupDlg.Create(self) do
  try
    Caption := cPickMembers;
    ColumnNames := cColumnNames;
    Populate(Connection, sUSERS, ['uid', PSEUDOATTR_PATH]);
    if ShowModal = mrOk then
    try
      UserList.Items.BeginUpdate;
      for i:=0 to SelCount-1 do begin
        if FindDataString(PChar(Selected[i].dn)) then continue;

        UserItem := UserList.Items.Add;
        UserItem.Data := StrNew(pchar(Selected[i].DN));
        UserItem.SubItems.Add(CanonicalName(GetDirFromDN(Selected[i].DN)));
        if Assigned(GroupOfUniqueNames) then
        begin
          GroupOfUniqueNames.AddMember(Selected[i].DN);
          UserItem.Caption := selected[i].DN;
        end
        else begin
          PosixGroup.AddMember(GetNameFromDN(Selected[i].DN));
          UserItem.Caption := selected[i].AttributesByName['uid'].AsString;
        end;
      end;
    finally
      UserList.Items.EndUpdate;
      if UserList.Items.Count > 0 then
        RemoveUserBtn.Enabled := true;
    end;
  finally
    Free;
  end;
end;

procedure TGroupDlg.RemoveUserBtnClick(Sender: TObject);
var
  idx: Integer;
  Item, Item2: TListItem;
begin
  with UserList do
  begin
    if Assigned(Selected) then
    try
      UserList.Items.BeginUpdate;
      Item := Selected;
      repeat
        idx := Item.Index;
        if Assigned(GroupOfUniqueNames) then
          GroupOfUniqueNames.RemoveMember(Item.Caption)
        else
          PosixGroup.RemoveMember(Item.Caption);
        Item2 := GetNextItem(Item, sdAll, [lisSelected]);
        Item.Delete;
        Item := Item2;
      until Item = nil;

      OkBtn.Enabled := true;
      if idx >= Items.Count then
        idx := Items.Count - 1;
      if idx > -1 then
        Items[idx].Selected := true
      else
        RemoveUserBtn.Enabled := false;
    finally
      UserList.Items.EndUpdate;
    end;
  end;
end;

procedure TGroupDlg.UserListDeletion(Sender: TObject; Item: TListItem);
begin
  if Assigned(Item.Data) then
    StrDispose(PChar(Item.Data));
end;

procedure TGroupDlg.ListViewColumnClick(Sender: TObject; Column: TListColumn);
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

procedure TGroupDlg.ListViewCompare(Sender: TObject; Item1, Item2: TListItem; Data: Integer; var Compare: Integer);
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

procedure TGroupDlg.PageControl1Change(Sender: TObject);
var
  i: Integer;
begin
  if not Assigned(DomList) then
  try
    DomList := TDomainList.Create(Connection);
    with cbSambaDomain do
    begin
      if Assigned(SambaGroup) and not (esNew in Entry.State) then
      begin
        if RadioGroup1.ItemIndex = 2 then
          EnableControls([cbBuiltin], clWindow, false);
        i := DomList.Count - 1;
        while (i >= 0) do begin
          if SambaGroup.DomainSid = DomList.Items[i].SID then
          begin
            Items.Add(DomList.Items[i].DomainName);
            ItemIndex := 0;
            break;
          end;
          dec(i);
        end;
        cbSambaGroup.Checked := true;
      end
      else
      begin
        EnableControls([edDisplayName, cbSambaDomain, edRid, RadioGroup1, cbBuiltin], clBtnFace, false);
        cbSambaGroup.Enabled := DomList.Count > 0;
        for i := 0 to DomList.Count - 1 do
          Items.Add(DomList.Items[i].DomainName);
        ItemIndex := Items.IndexOf(Connection.Account.ReadString(rSambaDomainName));
      end;
    end;
  except
  // TODO
  end;
end;

procedure TGroupDlg.cbSambaDomainChange(Sender: TObject);
begin
  if Assigned(PosixGroup) and (PosixGroup.gidNumber <> 0) and (cbSambaDomain.ItemIndex <> -1) then
  begin
    RadioGroup1.Enabled := true;
    if cbBuiltin.ItemIndex = -1 then
      edRid.Text := IntToStr(DomList.Items[cbSambaDomain.ItemIndex].GetRidFromUid(PosixGroup.gidNumber));
  end
  else
    edRid.Text := '';
end;

procedure TGroupDlg.RadioGroup1Click(Sender: TObject);
begin
  if RadioGroup1.ItemIndex = 2 then
  begin
    EnableControls([cbBuiltin], clWindow, true);
    EnableControls([edRid], clWindow, false);
    cbBuiltin.ItemIndex := 0;
    cbBuiltinChange(nil);
  end
  else begin
    EnableControls([cbBuiltin], clBtnFace, false);
    EnableControls([edRid], clWindow, true);
    cbBuiltin.ItemIndex := -1;
    cbSambaDomainChange(nil); // Refresh RID
  end;
  SambaGroup.GroupType := GetGroupType;
end;

procedure TGroupDlg.cbBuiltinChange(Sender: TObject);
begin
  if cbBuiltin.ItemIndex <> -1 then
    edRid.Text := IntToStr(WKRids[cbBuiltin.ItemIndex + 2]);
end;

function TGroupDlg.GetGroupType: Integer;
begin
  case RadioGroup1.ItemIndex of
    1: Result := 4;
    2: Result := 5;
  else
    Result := 2;
  end;
end;

procedure TGroupDlg.cbSambaGroupClick(Sender: TObject);
var
  Color: TColor;
  Enable: Boolean;
begin
  if cbSambaGroup.Checked then
  begin
    SambaGroup := TSamba3Group.Create(Entry);
    if not SambaGroup.Activated then
      SambaGroup.New;
    Color := clWindow;
    Enable := not IsSambaGroup;
  end
  else begin
    RadioGroup1.ItemIndex := 0;
    SambaGroup.Remove;
    IsSambaGroup := false;
    FreeAndNil(SambaGroup);
    cbSambaDomain.ItemIndex := -1;
    edDisplayName.Text := '';
    edRid.Text := '';
    Color := clBtnFace;
    Enable := false;
  end;
  RadioGroup1.Enabled := false;
  EnableControls([edDisplayName, cbSambaDomain, edRid], Color, Enable);
  if RadioGroup1.ItemIndex = 2 then
    cbBuiltin.Color := Color;
  if Assigned(SambaGroup) then
  begin
    if edDisplayName.Text = '' then
      edDisplayName.Text := Entry.AttributesByName['cn'].AsString;
    cbSambaDomainChange(nil); // Refresh Rid
  end;
end;

procedure TGroupDlg.edNameChange(Sender: TObject);
begin
  if esNew in Entry.State then
    Entry.Dn := 'cn=' + edName.Text + ',' + ParentDn;
  Entry.AttributesByName['cn'].AsString := edName.Text;
  OkBtn.Enabled := edName.Text <> '';
end;

procedure TGroupDlg.edDescriptionChange(Sender: TObject);
begin
  Entry.AttributesByName['description'].AsString := edDescription.Text;
  OkBtn.Enabled := edName.Text <> '';
end;

procedure TGroupDlg.edDisplayNameChange(Sender: TObject);
begin
  if Assigned(SambaGroup) then
  begin
    SambaGroup.DisplayName := edDisplayName.Text;
    OkBtn.Enabled := edName.Text <> '';
  end;
end;

procedure TGroupDlg.edRidChange(Sender: TObject);
var
  arid: string;
begin
  if Assigned(SambaGroup) and Assigned(DomList) then
  begin
    arid := edRid.Text;
    if arid = '' then
      arid := IntToStr(DomList.Items[cbSambaDomain.ItemIndex].GetRidFromUid(PosixGroup.gidNumber));
    SambaGroup.Sid := Format('%s-%s', [DomList.Items[cbSambaDomain.ItemIndex].SID, arid]);
    OkBtn.Enabled := edName.Text <> '';
  end;
end;

procedure TGroupDlg.FormDestroy(Sender: TObject);
begin
  Entry.Free;
  PosixGroup.Free;
  GroupOfUniqueNames.Free;
  DomList.Free;
end;

end.
