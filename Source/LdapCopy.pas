  {      LDAPAdmin - Copy.pas
  *      Copyright (C) 2005-2016 Tihomir Karlovic
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

unit LdapCopy;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
{$IFnDEF FPC}
  CommCtrl, Windows,
{$ELSE}
  LCLIntf, LCLType, LMessages,
{$ENDIF}
  SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ExtCtrls, ComCtrls, LDAPClasses, LAControls,LinLDAP,
  ImgList, Connection;

type

  TTargetData = record
    Connection: TConnection;
    Dn: string;
    Rdn: string;
  end;

  TExpandNodeProc = procedure (Node: TTreeNode; Session: TLDAPSession; TView: TTreeView) of object;

  { TCopyDlg }

  TCopyDlg = class(TForm)
    Panel1: TPanel;
    OKBtn: TButton;
    CancelBtn: TButton;
    Panel2: TPanel;
    Panel3: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    TreeView: TTreeView;
    edName: TEdit;
    procedure cbConnectionsChange(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure TreeViewExpanding(Sender: TObject; Node: TTreeNode;
      var AllowExpansion: Boolean);
    procedure edNameChange(Sender: TObject);
    procedure cbConnectionsDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure TreeViewDeletion(Sender: TObject; Node: TTreeNode);
    procedure FormResize(Sender: TObject);
  private
    ///cbConnections: TLAComboBox;
    cbConnections: TComboBox;
    RdnAttribute: string;
    MainConnectionIdx: Integer;
    fExpandNode: TExpandNodeProc;
    ///fSortProc: TTVCompare;
    ddRoot: TTreeNode;
    procedure cbConnectionsCloseUp(var Index: integer; var CanCloseUp: boolean);
    function  GetTgtDn: string;
    function  GetTgtRdn: string;
    function  GetTgtConnection: TConnection;
  public
    constructor Create(AOwner: TComponent;
                       dn: string;
                       Count: Integer;
                       Move: Boolean;
                       Connection: TConnection); reintroduce;
    property TargetDn: string read GetTgtDn;
    property TargetRdn: string read GetTgtRdn;
    property TargetConnection: TConnection read GetTgtConnection;
  end;

var
  CopyDlg: TCopyDlg;

function ExecuteCopyDialog(Owner: TComponent; dn: string; Count: Integer; Move: Boolean; Connection: TConnection; out TargetData: TTargetData): Boolean;

implementation

{$R *.dfm}

uses Registry, Config, SizeGrip, Constant, ObjectInfo, Misc, Main;

function ExecuteCopyDialog(Owner: TComponent; dn: string; Count: Integer; Move: Boolean; Connection: TConnection; out TargetData: TTargetData): Boolean;
begin
    with TCopyDlg.Create(Owner, dn, Count, Move, Connection) do
    try
      ShowModal;
      if ModalResult = mrOk then
      begin
        with TargetData do
        begin
          Connection := TargetConnection;
          Dn := TargetDn;
          Rdn := TargetRdn;
        end;
        Result := true;
      end
      else
        Result := false;
    finally
      Free;
    end;
end;

{ TCopyDlg }

procedure TCopyDlg.cbConnectionsCloseUp(var Index: integer; var CanCloseUp: boolean);
begin
  with cbConnections.Items do
  if (Objects[Index] is TConfigStorage) or (Objects[Index] is TAccountFolder) then
    CanCloseUp := false;
end;

function TCopyDlg.GetTgtDn: string;
begin
  Result := TObjectInfo(TreeView.Selected.Data).dn;
end;

function TCopyDlg.GetTgtRdn: string;
begin
  Result := RdnAttribute + '=' + edName.Text;
end;

function TCopyDlg.GetTgtConnection: TConnection;
begin
  with cbConnections, Items do
  if (Objects[ItemIndex] is TConnection) then
    Result := TConnection(Objects[ItemIndex])
  else
    Result := nil;
end;

constructor TCopyDlg.Create(AOwner: TComponent;
                            dn: string;
                            Count: Integer;
                            Move: Boolean;
                            Connection: TConnection);
var
  v, tgt: string;
  i,j: integer;

  procedure DoAddFolder(AFolder: TAccountFolder);
  var
    i: Integer;
  begin
    with cbConnections.Items, AFolder.Items do begin
      AddObject(AFolder.Name, AFolder);
      for i := 0 to Accounts.Count - 1 do
        AddObject(Accounts[i].Name, Accounts[i]);
      for i := 0 to Folders.Count - 1 do
        DoAddFolder(Folders[i]);
    end;
  end;

  function GetActiveIndex(Account: TAccount): Integer;
  begin
    with cbConnections.Items do
    begin
      Result := Count - 1;
      while Result > 0 do begin
        if Account = Objects[Result] then
          break;
        dec(Result);
      end;
    end;
  end;

begin
  inherited Create(AOwner);
  TSizeGrip.Create(Panel1);
  OkBtn.Enabled := false;
  ///cbConnections := TLAComboBox.Create(Self);
  cbConnections := TComboBox.Create(Self);
  with cbConnections do
  begin
    Parent := Panel3;
    Left := edName.Left;
    Top := 8;
    Width := edName.Width;
    Height := 22;
    Style := csOwnerDrawFixed;
    //Style := csDropDown;
    ItemHeight := 16;
    TabOrder := 0;
    OnChange := cbConnectionsChange;
    OnDrawItem := cbConnectionsDrawItem;
    ///OnCanCloseUp := cbConnectionsCloseUp;
  end;

  with GlobalConfig do
  for i := 0 to Storages.Count - 1 do with Storages[i] do
  begin
    cbConnections.Items.AddObject(Name, Storages[i]);
    for j := 0 to RootFolder.Items.Accounts.Count -1 do
      cbConnections.Items.AddObject(RootFolder.Items.Accounts[j].Name, RootFolder.Items.Accounts[j]);
    for j := 0 to RootFolder.Items.Folders.Count - 1 do
      DoAddFolder(RootFolder.Items.Folders[j]);
  end;

  for i := 0 to MainFrm.ConnectionCount - 1 do
    if MainFrm.Connections[i] is TDBConnection then with TDBConnection(MainFrm.Connections[i]) do
      cbConnections.Items.InsertObject(0, Account.Name, MainFrm.Connections[i]);

  SplitRdn(GetRdnFromDn(dn), RdnAttribute, v);
  edName.Text := v;

  MainConnectionIdx := GetActiveIndex(Connection.Account);
  if MainConnectionIdx = -1 then
  begin
    MainConnectionIdx := 0;
    cbConnections.Items.Insert(0, cCurrentConn);
  end;
  cbConnections.Items.Objects[MainConnectionIdx] := Connection;
  fExpandNode := MainFrm.ExpandNode;
  ///fSortProc := @TreeSortProc;
  ///fSortProc := MainFrm.TreeSortProc;
  TreeView.Images := MainFrm.ImageList;
  cbConnections.ItemIndex := MainConnectionIdx;
  cbConnections.OnChange(Self);

  if Count > 1 then
  begin
    edName.Visible := false;
    label2.Visible := false;
    tgt := Format(stNumObjects, [Count])
  end
  else
    tgt := '"' + dn + '"';

  if Move then
    Caption := Format(cMoveTo, [tgt])
  else
    Caption := Format(cCopyTo, [tgt]);
end;

procedure TCopyDlg.cbConnectionsChange(Sender: TObject);
var
  Connection: TConnection;
  Account: TAccount;
begin
  TreeView.Items.Clear;
  TreeView.Repaint;
  OkBtn.Enabled := false;
  Connection := TargetConnection;
  if not Assigned(Connection) then
  begin
    Account := TAccount(cbConnections.Items.Objects[cbConnections.ItemIndex]);
    Connection := TConnection.Create(Account);
    with Connection do
    try
      Screen.Cursor := crHourGlass;
      Server             := Account.Server;
      Base               := Account.Base;
      User               := Account.User;
      Password           := Account.Password;
      SSL                := Account.SSL;
      TLS                := Account.TLS;
      Port               := Account.Port;
      Version            := Account.LdapVersion;
      TimeLimit          := Account.TimeLimit;
      SizeLimit          := Account.SizeLimit;
      PagedSearch        := Account.PagedSearch;
      PageSize           := Account.PageSize;
      DereferenceAliases := Account.DereferenceAliases;
      ChaseReferrals     := Account.ChaseReferrals;
      ReferralHops       := Account.ReferralHops;
      OperationalAttrs   := Account.OperationalAttrs;
      AuthMethod         := Account.AuthMethod;
      Connect;
      cbConnections.Items.Objects[cbConnections.ItemIndex] := Connection;
    except
      Screen.Cursor := crDefault;
      Connection.Free;
      raise;
    end;
  end;
  Screen.Cursor := crHourGlass;
  try
    ddRoot := TreeView.Items.Add(nil, Format('%s [%s]', [Connection.Base, Connection.Server]));
    ddRoot.Data := TObjectInfo.Create(TLdapEntry.Create(Connection, Connection.Base));
  fExpandNode(ddRoot, Connection, TreeView);
    ddRoot.ImageIndex := bmRoot;
    ddRoot.SelectedIndex := bmRoot;
  ///TreeView.CustomSort(@fSortProc, 0);
  TreeView.CustomSort(MainFrm.TreeSortProc);
  ddRoot.Expand(false);
  finally
    Screen.Cursor := crDefault;
  end;
end;

procedure TCopyDlg.FormDestroy(Sender: TObject);
var
  i: Integer;
begin
  with cbConnections.Items do
  for i := 0 to Count - 1 do
    if (i <> MainConnectionIdx) and (Objects[i] is TConnection) and
       (Objects[i] <> TargetConnection) then
      Objects[i].Free;
end;

procedure TCopyDlg.TreeViewExpanding(Sender: TObject; Node: TTreeNode;
  var AllowExpansion: Boolean);
begin
  ///if (Node.Count > 0) and (Integer(Node.Item[0].Data) = ncDummyNode) then
  if (Node.Count > 0) and (Integer(Node.Items[0].Data) = ncDummyNode) then
  with (Sender as TTreeView) do
  try
    Items.BeginUpdate;
    ///Node.Item[0].Delete;
    Node.Items[0].Delete;
    fExpandNode(Node, TargetConnection,Sender as TTreeView);
    ///CustomSort(@fSortProc, 0);
    CustomSort(MainFrm.TreeSortProc);
  finally
    Items.EndUpdate;
  end;
end;

procedure TCopyDlg.edNameChange(Sender: TObject);
begin
  OKBtn.Enabled := (edName.Text <> '') and Assigned(TreeView.Selected);
end;

procedure TCopyDlg.cbConnectionsDrawItem(Control: TWinControl;
  Index: Integer; Rect: TRect; State: TOwnerDrawState);
var
  s: string;
  ImageIndex, Indent: Integer;

  function GetImageIndex(o: TObject): Integer;
  begin
    if o is TConfigStorage then
    begin
      if o is TRegistryConfigStorage then
        Result := bmRegistry
      else
        Result := bmFileStorage;
    end
    else
    if o is TAccountFolder then
      Result := bmEntry
    else
      Result := bmHost;
  end;

begin
  with cbConnections do
  begin
    if Items.Objects[Index] is TConnection then
      Indent := GetIndent(TConnection(Items.Objects[Index]).Account)
    else
      Indent := GetIndent(Items.Objects[Index]);
    Inc(Rect.Left, Indent);
    ImageIndex := GetImageIndex(Items.Objects[Index]);
    TreeView.Images.Draw(Canvas, Rect.Left, Rect.Top, ImageIndex);
    Rect.Left := Rect.Left + 20;
    s := Items[Index];
    DrawText(Canvas.Handle, PChar(s), Length(s), Rect, DT_SINGLELINE or DT_VCENTER or DT_NOPREFIX);
  end;
end;

procedure TCopyDlg.TreeViewDeletion(Sender: TObject; Node: TTreeNode);
begin
  if (Node.Data <> nil) and (Integer(Node.Data) <> ncDummyNode) then
    TObjectInfo(Node.Data).Free;
end;

procedure TCopyDlg.FormResize(Sender: TObject);
begin
  edName.Width := Panel3.Width - edName.Left;
  cbConnections.Width := edName.Width;
  TreeView.Width := Panel3.Width - TreeView.Left;
  TreeView.Height := Panel3.Height - TreeView.Top;
  CancelBtn.Left := Panel3.Width - CancelBtn.Width;
  OkBtn.Left := CancelBtn.Left - OkBtn.Width - 5;
end;

end.
