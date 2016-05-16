  {      LDAPAdmin - Copy.pas
  *      Copyright (C) 2005-2014 Tihomir Karlovic
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
  Buttons, ExtCtrls, ComCtrls, LDAPClasses, {$ifdef mswindows}WinLDAP,{$else} LinLDAP,{$endif}LAControls,
  ImgList, Connection;

type

  TTargetData = record
    Connection: TConnection;
    Dn: string;
    Rdn: string;
  end;

  TExpandNodeProc = procedure (Node: TTreeNode; Session: TLDAPSession) of object;

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
    cbConnections: TLAComboBox;
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

{$IFnDEF FPC}
  {$R *.dfm}
{$ELSE}
  {$R *.lfm}
{$ENDIF}

uses Config, SizeGrip, Constant, ObjectInfo, Main;

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
  if cbConnections.Items.Objects[Index] is TConfigStorage then
  begin
    Beep;
    CanCloseUp := false;
  end;
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
begin
  inherited Create(AOwner);
  TSizeGrip.Create(Panel1);
  OkBtn.Enabled := false;
  cbConnections := TLAComboBox.Create(Self);
  with cbConnections do
  begin
    Parent := Panel3;
    Left := edName.Left;
    Top := 8;
    Width := edName.Width;
    Height := 22;
    ///Style := csOwnerDrawFixed;
    Style := csDropDown;
    ItemHeight := 16;
    TabOrder := 0;
    OnChange := cbConnectionsChange;
    OnDrawItem := cbConnectionsDrawItem;
    OnCanCloseUp := cbConnectionsCloseUp;
  end;
  for i:=0 to GlobalConfig.StoragesCount-1 do
  begin
    cbConnections.Items.AddObject(GlobalConfig.Storages[i].Name, GlobalConfig.Storages[i]);
    for j:=0 to GlobalConfig.Storages[i].AccountsCount-1 do
      cbConnections.Items.AddObject(GlobalConfig.Storages[i].Accounts[j].Name, GlobalConfig.Storages[i].Accounts[j]);
  end;

  SplitRdn(GetRdnFromDn(dn), RdnAttribute, v);
  edName.Text := v;
  MainConnectionIdx := cbConnections.Items.IndexOf(Connection.Account.Name);
  if MainConnectionIdx = -1 then
    raise Exception.Create(stNoActiveConn);
  cbConnections.Items.Objects[MainConnectionIdx] := Connection;
  fExpandNode := MainFrm.ExpandNode;
  ///fSortProc := @TreeSortProc;
  TreeView.Images := MainFrm.ImageList;
  cbConnections.ItemIndex := MainConnectionIdx;

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
      Server   := Account.Server;
      Base     := Account.Base;
      User     := Account.User;
      Password := Account.Password;
      SSL      := Account.SSL;
      Port     := Account.Port;
      Version  := Account.ldapVersion;
      Connect;
      cbConnections.Items.Objects[cbConnections.ItemIndex] := Connection;
    finally
      Screen.Cursor := crDefault;
    end;
  end;
  ddRoot := TreeView.Items.Add(nil, Format('%s [%s]', [Connection.Base, Connection.Server]));
  ddRoot.Data := TObjectInfo.Create(TLdapEntry.Create(Connection, Connection.Base));
  fExpandNode(ddRoot, Connection);
  ddRoot.ImageIndex := bmRoot;
  ddRoot.SelectedIndex := bmRoot;
  ///TreeView.CustomSort(@fSortProc, 0);
  ddRoot.Expand(false);
end;

procedure TCopyDlg.FormDestroy(Sender: TObject);
var
  i: Integer;
begin
  with cbConnections.Items do
  for i := 0 to Count - 1 do
    if (i <> MainConnectionIdx) and (Objects[i] is TConnection)then
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
    fExpandNode(Node, TargetConnection);
    ///CustomSort(@fSortProc, 0);
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
  ImageIndex: Integer;
begin
  with cbConnections do
  begin
    {
    Canvas.FillRect(rect);
    if Items.Objects[Index] is TConfigStorage then
    begin
      if Index = 0 then
        ImageIndex := 32
      else
        ImageIndex := 33;
    end
    else
    begin
      ImageIndex := bmHost;
      Rect.Left:=Rect.Left+20;
    end;
    Rect.Top:=Rect.Top+1;
    Rect.Bottom:=Rect.Bottom-1;
    Rect.Left:=rect.Left+2;
    TreeView.Images.Draw(Canvas, Rect.Left, Rect.Top, ImageIndex);
    Rect.Left := Rect.Left + 20;
    }
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
