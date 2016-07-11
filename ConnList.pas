  {      LDAPAdmin - Connlist.pas
  *      Copyright (C) 2003-2016 Tihomir Karlovic
  *
  *      Author: Tihomir Karlovic & Alexander Sokoloff
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

unit ConnList;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
{$IFnDEF FPC}
  Windows,System.Actions,
{$ELSE}
  LCLIntf, LCLType,
{$ENDIF}
  SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, StdCtrls, Menus, ImgList, ExtCtrls, Buttons, Config,
  ActnList, DlgWrap;

type
  TConnListFrm = class(TForm)
    PopupMenu1: TPopupMenu;
    pbNew: TMenuItem;
    pbProperties: TMenuItem;
    pbDelete: TMenuItem;
    N1: TMenuItem;
    SmallImgs: TImageList;
    pbRename: TMenuItem;
    pbCopy: TMenuItem;
    Panel1: TPanel;
    OkBtn: TButton;
    CancelBtn: TButton;
    AccountsView: TListView;
    OpenDialog: TOpenDialog;
    ToolBar2: TToolBar;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    ViewBtn: TToolButton;
    ViewStyleMenu: TPopupMenu;
    vmSmall: TMenuItem;
    vmList: TMenuItem;
    vmTable: TMenuItem;
    LargeImgs: TImageList;
    vmLarge: TMenuItem;
    ToolButton4: TToolButton;
    Panel2: TPanel;
    StoragesImgs: TImageList;
    StoragesList: TListBox;
    Splitter1: TSplitter;
    ActionList: TActionList;
    ActNewAccount: TAction;
    ActDeleteAccount: TAction;
    ToolButton5: TToolButton;
    ToolButton6: TToolButton;
    ToolButton7: TToolButton;
    ActRenameAccount: TAction;
    ActNewStorage: TAction;
    ActOpenStorage: TAction;
    ActCopyAccount: TAction;
    ActPropertiesAccount: TAction;
    ToolButton8: TToolButton;
    ActDeleteStrorage: TAction;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ListViewEditing(Sender: TObject; Item: TListItem;
      var AllowEdit: Boolean);
    procedure ViewStyleChange(Sender: TObject);
    procedure ViewBtnClick(Sender: TObject);
    procedure StoragesListDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure Splitter1Moved(Sender: TObject);
    procedure StoragesListClick(Sender: TObject);
    procedure ActNewAccountExecute(Sender: TObject);
    procedure AccountsViewDblClick(Sender: TObject);
    procedure AccountsViewKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ActDeleteAccountExecute(Sender: TObject);
    procedure ActionListUpdate(Action: TBasicAction;
      var Handled: Boolean);
    procedure ActRenameAccountExecute(Sender: TObject);
    procedure AccountsViewEdited(Sender: TObject; Item: TListItem;
      var S: String);
    procedure ActCopyAccountExecute(Sender: TObject);
    procedure ActPropertiesAccountExecute(Sender: TObject);
    procedure ActNewStorageExecute(Sender: TObject);
    procedure ActOpenStorageExecute(Sender: TObject);
    procedure ViewStyleMenuPopup(Sender: TObject);
    procedure ActDeleteStrorageExecute(Sender: TObject);
    procedure FormResize(Sender: TObject);
  private
    FStorage: TConfigStorage;
    SaveDialog: TSaveDialogWrapper;
    procedure SetViewStyle(Style: integer);
    procedure RefreshAccountsView;
    procedure RefreshStoragesList(ItemIndex: integer=-1);
    function  GetAccount: TAccount;
  public
    constructor Create(AOwner: TComponent); reintroduce;
    property    Account: TAccount read GetAccount;
  end;

implementation

{$R *.dfm}
{$I LdapAdmin.inc}

uses ConnProp, Constant, Math, uAccountCopyDlg, SizeGrip
     {$IFDEF VER_XEH}, System.Types{$ENDIF};

const
  CONF_ACCLV_STYLE='ConList\AccountsView\Style';
  CONF_STORLIST_WIDTH='ConList\StorragesList\Width';
  CONF_STORLIST_INDEX='ConList\StorragesList\Index';


constructor TConnListFrm.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  SaveDialog := TSaveDialogWrapper.Create(Self);
  with SaveDialog do begin
    Filter := CONNLIST_SAVE_FILTER;
    FilterIndex := 1;
    OverwritePrompt := true;
    DefaultExt := 'ltf';
  end;
  TSizeGrip.Create(Panel1);
  StoragesList.Width:=GlobalConfig.ReadInteger(CONF_STORLIST_WIDTH, StoragesList.Width);
  RefreshStoragesList(GlobalConfig.ReadInteger(CONF_STORLIST_INDEX, 0));
  SetViewStyle(GlobalConfig.ReadInteger(CONF_ACCLV_STYLE, 0));
end;

function TConnListFrm.GetAccount: TAccount;
begin
  Result := TAccount(AccountsView.Selected.Data)
end;

procedure TConnListFrm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 GlobalConfig.WriteInteger(CONF_STORLIST_WIDTH, StoragesList.Width);
 GlobalConfig.WriteInteger(CONF_STORLIST_INDEX, StoragesList.ItemIndex);
 if ModalResult <> mrOk then exit;
 if (AccountsView.Selected=nil) or (AccountsView.Selected.Data=nil) then begin
  ActNewAccountExecute(self);
  Abort;
 end;
end;


procedure TConnListFrm.RefreshAccountsView;
var
  i: integer;
  SelData: pointer;
begin
  AccountsView.Items.BeginUpdate;

  if (AccountsView.Selected<>nil) then SelData:=AccountsView.Selected.Data
  else SelData:=nil;

  AccountsView.Items.Clear;

  with AccountsView.Items.Add do begin
    Caption := cAddConn;
    Data:=nil;
    ImageIndex := 0;
  end;

  if FStorage<>nil then begin
    for i:=0 to FStorage.AccountsCount-1 do begin
      with AccountsView.Items.Add do begin
        Caption:=FStorage.Accounts[i].Name;
        Data:=FStorage.Accounts[i];
        SubItems.Add(FStorage.Accounts[i].Server);
        SubItems.Add(FStorage.Accounts[i].Base);
        if FStorage.Accounts[i].User='' then SubItems.Add('anonymous')
        else SubItems.Add(FStorage.Accounts[i].User);
        ImageIndex := 1;
        Selected:=(Data=SelData);
      end;
    end;
  end;
  AccountsView.Items.EndUpdate;
end;

procedure TConnListFrm.RefreshStoragesList(ItemIndex: integer=-1);
var
  i: integer;
begin
  StoragesList.Items.BeginUpdate;
  StoragesList.Items.Clear;
  StoragesList.ItemIndex:=-1;

  for i:=0 to GlobalConfig.StoragesCount-1 do begin
    StoragesList.Items.AddObject(GlobalConfig.Storages[i].Name, GlobalConfig.Storages[i]);
    if FStorage=GlobalConfig.Storages[i] then StoragesList.ItemIndex:=i;
  end;

  if (StoragesList.Items.Count>0) then begin
    if (ItemIndex>-1) and (ItemIndex<StoragesList.Items.Count) then StoragesList.ItemIndex:=ItemIndex;
    if StoragesList.ItemIndex<0 then StoragesList.ItemIndex:=0;
    FStorage:=TConfigStorage(StoragesList.Items.Objects[StoragesList.ItemIndex]);
  end;

  StoragesList.Items.EndUpdate;
  RefreshAccountsView;
end;

procedure TConnListFrm.StoragesListClick(Sender: TObject);
begin
  if FStorage=TConfigStorage(StoragesList.Items.Objects[StoragesList.ItemIndex]) then exit;
  FStorage:=TConfigStorage(StoragesList.Items.Objects[StoragesList.ItemIndex]);
  RefreshAccountsView;
end;

procedure TConnListFrm.AccountsViewDblClick(Sender: TObject);
begin
  if AccountsView.Selected=nil then exit;
  if AccountsView.Selected.Data=nil then ActNewAccountExecute(Self)
  else ModalResult := mrOk;
end;

procedure TConnListFrm.AccountsViewKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key=VK_RETURN then AccountsViewDblClick(AccountsView);
end;

procedure TConnListFrm.ActNewAccountExecute(Sender: TObject);
const
  NAME_PATTERN='%s [%d]';
var
  Account: TAccount;
  AName: string;
  i: integer;
begin
  with TConnPropDlg.Create(self) do begin
    PasswordEnable:=FStorage.PasswordCanSave;

    if ShowModal=mrOK then begin
      if Name='' then Name:=Server+'/'+Base;
      AName:=Name;

      i:=2;
      while FStorage.AccountByName(AName)<>nil do begin
        AName:=format(NAME_PATTERN, [Name, i]);
        inc(i);
      end;

      Account:=FStorage.AddAccount(AName);

      Account.Name               := Name;
      Account.Base               := Base;
      Account.SSL                := SSl;
      Account.TLS                := TLS;
      Account.Port               := Port;
      Account.LdapVersion        := LdapVersion;
      Account.User               := User;
      Account.Server             := Server;
      Account.Password           := Password;
      Account.TimeLimit          := Timelimit;
      Account.SizeLimit          := SizeLimit;
      Account.PagedSearch        := PagedSearch;
      Account.PageSize           := PageSize;
      Account.DereferenceAliases := DereferenceAliases;
      Account.ChaseReferrals     := ChaseReferrals;
      Account.ReferralHops       := ReferralHops;
      Account.OperationalAttrs   := OperationalAttrs;
      Account.AuthMethod         := AuthMethod;
      
    end;
    Free;
  end;
  RefreshAccountsView;
end;

procedure TConnListFrm.ActDeleteAccountExecute(Sender: TObject);
begin
  if (AccountsView.Selected=nil) or (AccountsView.Selected.Data=nil) then exit;
  if FStorage=nil then exit;
  ///if MessageBox(Application.Handle,
  if MessageBox(Handle,
                pchar(format(stConfirmDelAccnt, [TAccount(AccountsView.Selected.Data).Name])),
                pchar(application.Name), MB_ICONQUESTION or MB_YESNO)<>mrYes then exit;
  FStorage.DeleteAccount(TAccount(AccountsView.Selected.Data));
  RefreshAccountsView;
end;

procedure TConnListFrm.ActionListUpdate(Action: TBasicAction; var Handled: Boolean);
begin
  OkBtn.Enabled := (AccountsView.Selected<>nil) and (AccountsView.Selected.Data<>nil) and (not AccountsView.IsEditing);
  ActDeleteAccount.Enabled:=OkBtn.Enabled;
  ActRenameAccount.Enabled:=OkBtn.Enabled;
  ActCopyAccount.Enabled:=OkBtn.Enabled;
  ActPropertiesAccount.Enabled:=OkBtn.Enabled;

  ActDeleteStrorage.Enabled:=(FStorage<>nil) and (FStorage is TXmlConfigStorage);
end;

procedure TConnListFrm.ActRenameAccountExecute(Sender: TObject);
begin
  if (AccountsView.Selected=nil) or (AccountsView.Selected.Data=nil) then exit;
  AccountsView.Selected.EditCaption;
end;

procedure TConnListFrm.ListViewEditing(Sender: TObject; Item: TListItem; var AllowEdit: Boolean);
begin
  AllowEdit:=(Item<>nil) and (Item.Data<>nil);
end;

procedure TConnListFrm.AccountsViewEdited(Sender: TObject; Item: TListItem; var S: String);
begin
  if Item.Data=nil then exit;
  TAccount(Item.Data).Name:=S;
end;

procedure TConnListFrm.ActCopyAccountExecute(Sender: TObject);
var
  Account: TAccount;
  Dlg: TAccountCopyDlg;
begin
  if (AccountsView.Selected=nil) or (AccountsView.Selected.Data=nil) then exit;

  Dlg:=TAccountCopyDlg.Create(self);
  Dlg.Caption:=Format(cCopyTo, [ FStorage.Name+'.'+ AccountsView.Selected.Caption]);
  Dlg.Storage:=FStorage;
  Dlg.AccountName := AccountsView.Selected.Caption;
  Dlg.NameEd.SelectAll;
  if Dlg.ShowModal=mrOK then begin
    Account:=Dlg.Storage.AccountByName(Dlg.AccountName);
    if Account=nil then Account:=Dlg.Storage.AddAccount(Dlg.AccountName);
    Account.Assign(TAccount(AccountsView.Selected.Data));
    RefreshAccountsView;
  end;
  Dlg.Free;
end;

procedure TConnListFrm.ActPropertiesAccountExecute(Sender: TObject);
var
  Account: TAccount;
begin
  if (AccountsView.Selected=nil) or (AccountsView.Selected.Data=nil) then exit;
  Account:=TAccount(AccountsView.Selected.Data);
  with TConnPropDlg.Create(Self) do begin
    Name               := Account.Name;
    Base               := Account.Base;
    SSL                := Account.SSl;
    TLS                := Account.TLS;
    Port               := Account.Port;
    LdapVersion        := Account.LdapVersion;
    User               := Account.User;
    Server             := Account.Server;
    Password           := Account.Password;
    PasswordEnable     := FStorage.PasswordCanSave;
    TimeLimit          := Account.Timelimit;
    SizeLimit          := Account.SizeLimit;
    PagedSearch        := Account.PagedSearch;
    PageSize           := Account.PageSize;
    DereferenceAliases := Account.DereferenceAliases;
    ChaseReferrals     := Account.ChaseReferrals;
    ReferralHops       := Account.ReferralHops;
    OperationalAttrs   := Account.OperationalAttrs;
    AuthMethod         := Account.AuthMethod;

    if ShowModal=mrOK then begin
      Account.Name               := Name;
      Account.Base               := Base;
      Account.SSL                := SSl;
      Account.TLS                := TLS;
      Account.Port               := Port;
      Account.LdapVersion        := LdapVersion;
      Account.User               := User;
      Account.Server             := Server;
      Account.Password           := Password;
      Account.TimeLimit          := Timelimit;
      Account.SizeLimit          := SizeLimit;
      Account.PagedSearch        := PagedSearch;
      Account.PageSize           := PageSize;
      Account.DereferenceAliases := DereferenceAliases;
      Account.ChaseReferrals     := ChaseReferrals;
      Account.ReferralHops       := ReferralHops;
      Account.OperationalAttrs   := OperationalAttrs;
      Account.AuthMethod         := AuthMethod;
    end;
    Free;
  end;
  RefreshAccountsView;
end;

procedure TConnListFrm.ActNewStorageExecute(Sender: TObject);
var
  i: integer;
begin
  if SaveDialog.Execute then begin
    for i:=1 to GlobalConfig.StoragesCount-1 do begin
      if (GlobalConfig.Storages[i] is TXmlConfigStorage) and
         (TXmlConfigStorage(GlobalConfig.Storages[i]).FileName=SaveDialog.FileName) then begin
        FStorage:=GlobalConfig.Storages[i];
        StoragesList.ItemIndex:=i;
        RefreshAccountsView;
        exit;
      end;
    end;
    FStorage:=TXmlConfigStorage.Create('');
    TXmlConfigStorage(FStorage).FileName:=SaveDialog.FileName;
    GlobalConfig.AddStorage(FStorage);
    RefreshStoragesList;
  end;
end;

procedure TConnListFrm.ActOpenStorageExecute(Sender: TObject);
var
  i: integer;
begin
  if OpenDialog.Execute then begin
    for i:=1 to GlobalConfig.StoragesCount-1 do begin
      if (GlobalConfig.Storages[i] is TXmlConfigStorage) and
         (TXmlConfigStorage(GlobalConfig.Storages[i]).FileName=OpenDialog.FileName) then begin
        FStorage:=GlobalConfig.Storages[i];
        StoragesList.ItemIndex:=i;
        RefreshAccountsView;
        exit;
      end;
    end;
    FStorage:=TXmlConfigStorage.Create(OpenDialog.FileName);
    GlobalConfig.AddStorage(FStorage);
    RefreshStoragesList;
  end;
end;

procedure TConnListFrm.ActDeleteStrorageExecute(Sender: TObject);
var
  i: integer;
begin
  if (FStorage=nil) or (FStorage is TRegistryConfigStorage) then exit;
  for i:=0 to GlobalConfig.StoragesCount-1 do
    if GlobalConfig.Storages[i]=FStorage then begin
      GlobalConfig.DeleteStorage(i);
      RefreshStoragesList;
      exit;
    end;
end;

procedure TConnListFrm.ViewStyleMenuPopup(Sender: TObject);
begin
  case AccountsView.ViewStyle of
    vsIcon:   if AccountsView.LargeImages=SmallImgs then ViewStyleMenu.Items[0].Checked:=true
              else ViewStyleMenu.Items[1].Checked:=true;
    vsList:   ViewStyleMenu.Items[2].Checked:=true;
    vsReport: ViewStyleMenu.Items[3].Checked:=true;
  end;
end;

procedure TConnListFrm.SetViewStyle(Style: integer);
begin
  case Style of
    0:  begin AccountsView.ViewStyle:=vsIcon; AccountsView.LargeImages:=SmallImgs; end;
    1:  begin AccountsView.ViewStyle:=vsIcon; AccountsView.LargeImages:=LargeImgs; end;
    2:  AccountsView.ViewStyle:=vsList;
    3:  AccountsView.ViewStyle:=vsReport;
  end;
  GlobalConfig.WriteInteger(CONF_ACCLV_STYLE, Style);
end;

procedure TConnListFrm.ViewStyleChange(Sender: TObject);
begin
  SetViewStyle(TMenuItem(Sender).Tag);
end;

procedure TConnListFrm.ViewBtnClick(Sender: TObject);
var
  p: TPoint;
begin
  p:=ViewBtn.ClientToScreen(point(0,ViewBtn.Height));
  ViewStyleMenu.Popup(p.X, p.Y);
end;

procedure TConnListFrm.StoragesListDrawItem(Control: TWinControl; Index: Integer; Rect: TRect; State: TOwnerDrawState);
var
  X, Y: integer;
begin
  with StoragesList do begin
    Canvas.Brush.Color:=Color;
    Canvas.FillRect(Rect);
    InflateRect(Rect, -2, -4);
    if odSelected in State then begin
      Canvas.Brush.Color:=clBtnFace;
      Canvas.Font.Color:=clBtnText;
      DrawEdge(Canvas.Handle, Rect, BDR_SUNKENOUTER, BF_MIDDLE + BF_RECT);
    end
    else begin
      Canvas.Brush.Color:=Color;
      Canvas.Font.Color:=Font.Color;
    end;

    InflateRect(Rect, -2, -4);
    Y:=Rect.Top;
    X:=(Rect.Right-StoragesImgs.Width) div 2;
    StoragesImgs.Draw(Canvas, X, Y, min(Index, 1));
    DrawText(Canvas.Handle, pchar(Items[Index]), -1, Rect, DT_SINGLELINE or DT_CENTER or DT_BOTTOM );
  end;

end;

procedure TConnListFrm.Splitter1Moved(Sender: TObject);
begin
  StoragesList.Invalidate;
end;

procedure TConnListFrm.FormResize(Sender: TObject);
begin
  RefreshAccountsView;
end;

end.
