  {      LDAPAdmin - Main.pas
  *      Copyright (C) 2003-2014 Tihomir Karlovic
  *
  *      Author: Tihomir Karlovic
  *
  *      Modifications:  Ivo Brhel, 2016
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

unit Main;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
{$IFnDEF FPC}
  Windows, Tabs, WinLDAP,
{$ELSE}
  LCLIntf, LCLType, LMessages, LinLDAP,
{$ENDIF}
  Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, Menus, ImgList, StdCtrls, ExtCtrls, Clipbrd, ActnList,
  contnrs, Config, Connection,
  Sorter, ToolWin, Posix, Samba,
  LDAPClasses,  uSchemaDlg,    Schema,
  uBetaImgLists, GraphicHint, CustomMenus,  ObjectInfo;


type

  { TMainFrm }

  TMainFrm = class(TForm)
    ToolBar: TToolBar;
    ConnectBtn: TToolButton;
    ToolButton6: TToolButton;
    PropertiesBtn: TToolButton;
    DeleteBtn: TToolButton;
    ToolButton2: TToolButton;
    EditBtn: TToolButton;
    RefreshBtn: TToolButton;
    ExitBtn: TToolButton;
    ImageList: TImageList;
    MainMenu: TMainMenu;
    mbStart: TMenuItem;
    StatusBar: TStatusBar;
    mbConnect: TMenuItem;
    mbDisconnect: TMenuItem;
    N1: TMenuItem;
    mbExit: TMenuItem;
    TreeSplitter: TSplitter;
    mbEdit: TMenuItem;
    mbNew: TMenuItem;
    EditPopup: TPopupMenu;
    pbNew: TMenuItem;
    pbEdit: TMenuItem;
    pbDelete: TMenuItem;
    N2: TMenuItem;
    pbRefresh: TMenuItem;
    N3: TMenuItem;
    pbChangePassword: TMenuItem;
    DisconnectBtn: TToolButton;
    mbEditEntry: TMenuItem;
    mbDeleteEntry: TMenuItem;
    N4: TMenuItem;
    mbRefresh: TMenuItem;
    pbProperties: TMenuItem;
    mbProperties: TMenuItem;
    N5: TMenuItem;
    mbSetpass: TMenuItem;
    N6: TMenuItem;
    pbSearch: TMenuItem;
    mbTools: TMenuItem;
    mbExport: TMenuItem;
    mbImport: TMenuItem;
    N7: TMenuItem;
    mbSearch: TMenuItem;
    N8: TMenuItem;
    mbInfo: TMenuItem;
    N9: TMenuItem;
    mbPreferences: TMenuItem;
    pbCopy: TMenuItem;
    mbCopy: TMenuItem;
    mbMove: TMenuItem;
    pbMove: TMenuItem;
    N10: TMenuItem;
    N11: TMenuItem;
    ScrollTimer: TTimer;
    ActionList: TActionList;
    ActConnect: TAction;
    ActDisconnect: TAction;
    ActExit: TAction;
    ActSchema: TAction;
    ActImport: TAction;
    ActExport: TAction;
    ActPreferences: TAction;
    ActAbout: TAction;
    ActPassword: TAction;
    ActEditEntry: TAction;
    ActCopyEntry: TAction;
    ActMoveEntry: TAction;
    ActDeleteEntry: TAction;
    ActRefresh: TAction;
    ActSearch: TAction;
    ActProperties: TAction;
    ToolButton1: TToolButton;
    SearchBtn: TToolButton;
    SchemaBtn: TToolButton;
    N12: TMenuItem;
    mbSchema: TMenuItem;
    ListPopup: TPopupMenu;
    pbViewBinary: TMenuItem;
    ActViewBinary: TAction;
    ListViewPanel: TPanel;
    ValueListView: TListView;
    EntryListView: TListView;
    ViewSplitter: TSplitter;
    mbView: TMenuItem;
    mbShowValues: TMenuItem;
    mbShowEntires: TMenuItem;
    ActValues: TAction;
    ActEntries: TAction;
    ActIconView: TAction;
    ActListView: TAction;
    N13: TMenuItem;
    mbIconView: TMenuItem;
    mbListView: TMenuItem;
    ActSmallView: TAction;
    mbViewStyle: TMenuItem;
    mbSmallView: TMenuItem;
    ActOptions: TAction;
    mbOptions: TMenuItem;
    TreeViewPanel: TPanel;
    LDAPTree: TTreeView;
    SearchPanel: TPanel;
    edSearch: TEdit;
    Label1: TLabel;
    ActLocateEntry: TAction;
    N15: TMenuItem;
    Locateentry1: TMenuItem;
    ActCopyDn: TAction;
    Copydntoclipboard1: TMenuItem;
    Copydntoclipboard2: TMenuItem;
    ViewEdit: TAction;
    ActCopy: TAction;
    ActCopyValue: TAction;
    ActCopyName: TAction;
    N18: TMenuItem;
    pbViewCopy: TMenuItem;
    pbViewCopyName: TMenuItem;
    pbViewCopyValue: TMenuItem;
    ActRenameEntry: TAction;
    N19: TMenuItem;
    N20: TMenuItem;
    pbRename: TMenuItem;
    N21: TMenuItem;
    N22: TMenuItem;
    mbRename: TMenuItem;
    ActFindInSchema: TAction;
    N23: TMenuItem;
    pbFindInSchema: TMenuItem;
    TabSet1: TTabControl;
    N24: TMenuItem;
    mbGetTemplates: TMenuItem;
    UndoBtn: TToolButton;
    RedoBtn: TToolButton;
    ActModifySet: TAction;
    ModifyBtn: TToolButton;
    Modifyset1: TMenuItem;
    pbViewCert: TMenuItem;
    pbViewPicture: TMenuItem;
    ActEditValue: TAction;
    N14: TMenuItem;
    pbEditValue: TMenuItem;
    ActAlias: TAction;
    mbAlias: TMenuItem;
    Createalias1: TMenuItem;
    ActCustomizeMenu: TAction;
    Customizemenu1: TMenuItem;
    mbLanguage: TMenuItem;
    N16: TMenuItem;
    ActGoTo: TAction;
    Goto1: TMenuItem;
    ActBookmark: TAction;
    Bookmarks1: TMenuItem;
    Bookmarks2: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure LDAPTreeExpanding(Sender: TObject; Node: TTreeNode;
      var AllowExpansion: Boolean);
    procedure LDAPTreeDeletion(Sender: TObject; Node: TTreeNode);
    procedure LDAPTreeChange(Sender: TObject; Node: TTreeNode);
    procedure LDAPTreeContextPopup(Sender: TObject; MousePos: TPoint;
      var Handled: Boolean);
    procedure LDAPTreeDblClick(Sender: TObject);
    procedure LDAPTreeEdited(Sender: TObject; Node: TTreeNode;
      var S: String);
    procedure LDAPTreeDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure LDAPTreeDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure LDAPTreeStartDrag(Sender: TObject;
      var DragObject: TDragObject);
    procedure LDAPTreeEndDrag(Sender, Target: TObject; X, Y: Integer);
    procedure ScrollTimerTimer(Sender: TObject);
    procedure ValueListViewCustomDrawItem(Sender: TCustomListView;
      Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean);
    procedure ActConnectExecute(Sender: TObject);
    procedure ActExitExecute(Sender: TObject);
    procedure ActDisconnectExecute(Sender: TObject);
    procedure ActionListUpdate(Action: TBasicAction; var Handled: Boolean);
    procedure ActSchemaExecute(Sender: TObject);
    procedure ActImportExecute(Sender: TObject);
    procedure ActExportExecute(Sender: TObject);
    procedure ActPreferencesExecute(Sender: TObject);
    procedure ActAboutExecute(Sender: TObject);
    procedure ActEditEntryExecute(Sender: TObject);
    procedure ActDeleteEntryExecute(Sender: TObject);
    procedure ActRefreshExecute(Sender: TObject);
    procedure ActSearchExecute(Sender: TObject);
    procedure ActPropertiesExecute(Sender: TObject);
    procedure ActPasswordExecute(Sender: TObject);
    procedure ActCopyEntryExecute(Sender: TObject);
    procedure ActMoveEntryExecute(Sender: TObject);
    procedure StatusBarDrawPanel(StatusBar: TStatusBar; Panel: TStatusPanel; const Rect: TRect);
    procedure ActViewBinaryExecute(Sender: TObject);
    procedure ActValuesExecute(Sender: TObject);
    procedure ActEntriesExecute(Sender: TObject);
    procedure EntryListViewDblClick(Sender: TObject);
    procedure ActIconViewExecute(Sender: TObject);
    procedure ActListViewExecute(Sender: TObject);
    procedure ActSmallViewExecute(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ActOptionsExecute(Sender: TObject);
    procedure ActLocateEntryExecute(Sender: TObject);
    procedure edSearchExit(Sender: TObject);
    procedure edSearchKeyPress(Sender: TObject; var Key: Char);
    procedure edSearchChange(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure ActCopyDnExecute(Sender: TObject);
    procedure ActCopyExecute(Sender: TObject);
    procedure ActCopyValueExecute(Sender: TObject);
    procedure ActCopyNameExecute(Sender: TObject);
    procedure ActRenameEntryExecute(Sender: TObject);
    procedure ActFindInSchemaExecute(Sender: TObject);
    procedure TabSet1Change(Sender: TObject; NewTab: Integer;
      var AllowChange: Boolean);
    procedure mbGetTemplatesClick(Sender: TObject);
    procedure UndoBtnClick(Sender: TObject);
    procedure RedoBtnClick(Sender: TObject);
    procedure ActModifySetExecute(Sender: TObject);
    procedure ListPopupPopup(Sender: TObject);
    procedure pbViewCertClick(Sender: TObject);
    procedure pbViewPictureClick(Sender: TObject);
    procedure ValueListViewInfoTip(Sender: TObject; Item: TListItem;
      var InfoTip: String);
    procedure ActEditValueExecute(Sender: TObject);
    procedure ActAliasExecute(Sender: TObject);
    procedure ActCustomizeMenuExecute(Sender: TObject);
    procedure ActGoToExecute(Sender: TObject);
    procedure ActBookmarkExecute(Sender: TObject);
  private
    Root: TTreeNode;
    fCmdLineAccount: TFakeAccount;
    fConnections: TObjectList;
    Connection: TConnection;
    fViewSplitterPos: Integer;
    fLdapTreeWidth: Integer;
    fSearchList: TLdapEntryList;
    fLocateList: TLdapEntryList;
    fTemplateMenu: TCustomMenuItem;
    fTickCount: Cardinal;
    fIdObject: Boolean;
    fEnforceContainer: Boolean;
    fLocatedEntry: Integer;
    fQuickSearchFilter: string;
    fTemplateProperties: Boolean;
    fTreeHistory: TTreeHistory;
    fDisabledImages :TBetaDisabledImageList;
    procedure ValueWrite(Sender: TLdapAttributeData);
    procedure EntryWrite(Sender: TObject);
    procedure EntrySortProc(Entry1, Entry2: TLdapEntry; Data: pointer; out Result: Integer);
    procedure SearchCallback(Sender: TLdapEntryList; var AbortSearch: Boolean);
    procedure InitTemplateMenu;
    procedure InitLanguageMenu;
    procedure InitStatusBar;
    procedure RefreshStatusBar;
    procedure ClassifyEntry(ObjectInfo: TObjectInfo; CNode: TTreeNode);
    procedure RefreshNode(Node: TTreeNode; Expand: Boolean);
    procedure RefreshTree;
    procedure RefreshValueListView(Node: TTreeNode);
    procedure RefreshEntryListView(Node: TTreeNode);
    procedure CopySelection(TargetSession: TLdapSession; TargetDn, TargetRdn: string; Move: Boolean);
    procedure GetSelection(List: TStringList);
    procedure RemoveNodes(List: TStringList);
    procedure CopyMove(Move: Boolean);
    procedure Delete;
    function  IsActPropertiesEnable: Boolean;
    function  SelectedNode: TTreeNode;
    function  IsContainer(ANode: TTreeNode): Boolean;
    procedure NewTemplateClick(Sender: TObject);
    procedure NewClick(Sender: TObject);
    procedure LanguageExecute(Sender: TObject);
    //--
    function TreeSortProc(Node1, Node2: TTreeNode): Integer;
    //--
  public
    procedure ExpandNode(Node: TTreeNode; Session: TLDAPSession);
    procedure DoCopyMove(List: TStringList; TargetSession: TLdapSession; TargetDn, TargetRdn: string; Move: Boolean);
    procedure DoDelete(List: TStringList);
    function  ShowSchema: TSchemaDlg;
    function  PickEntry(const ACaption: string): string;
    function  LocateEntry(const dn: string; const Select: Boolean): TTreeNode;
    procedure EditProperty(AOwner: TControl; ObjectInfo: TObjectInfo);
    procedure ServerConnect(Account: TAccount);
    procedure ServerDisconnect;
    procedure ReadConfig;
    property  DisabledImages: TBetaDisabledImageList read fDisabledImages;
  end;

var
  MainFrm: TMainFrm;

implementation

uses
{$IFnDEF FPC}
  Shellapi, Lang,
{$ELSE}
  Lang,
{$ENDIF}
  EditEntry, ConnList, Search, LdapOp, Constant, Export, Import, Prefs, Misc,
     LdapCopy, BinView, Input, ConfigDlg, Templates, TemplateCtrl,
     Cert, PicView, About, Alias, SizeGrip, CustMenuDlg,  Bookmarks;

{$IFnDEF FPC}
  {$R *.dfm}
{$ELSE}
  {$R *.lfm}
{$ENDIF}
{$I LdapAdmin.inc}
{$IFDEF XPSTYLE} {$R Manifest.res} {$ENDIF}



{ ============================== }
// http://forum.lazarus.freepascal.org/index.php/topic,22628.msg133826.html

function TMainFrm.TreeSortProc(Node1, Node2: TTreeNode): Integer;
var
  n1, n2: Integer;
begin
  n1 := Node1.ImageIndex;
  n2 := Node2.ImageIndex;
  if ((n1 = bmOu) and (n2 <> bmOu)) then
    Result := -1
  else
  if ((n2 = bmOu) and (n1 <> bmOu))then
    Result := 1
  else
    //Result := CompareText(Node1.Text, Node2.Text);
    Result := AnsiCompareText(Node1.Text, Node2.Text);
end;

{ ==============================}



procedure TMainFrm.ValueWrite(Sender: TLdapAttributeData);
begin
  if TObjectInfo(LdapTree.Selected.Data).dn = Sender.Attribute.Entry.dn then
    RefreshValueListView(LdapTree.Selected);
end;

procedure TMainFrm.EntryWrite(Sender: TObject);
var
 Node: TTreeNode;
 Entry: TLdapEntry;
 tgtDn: string;
begin
  Node := LdapTree.Selected;
  if Assigned(Node) then
  begin
    Entry := Sender as TLdapEntry;
    if esNew in Entry.State then
    begin
      tgtDn := GetDirFromDn(Entry.dn);
      if TObjectInfo(Node.Data).dn = tgtDn then
        ActRefreshExecute(nil)
      else try
        LdapTree.Items.BeginUpdate;
        RefreshNode(LocateEntry(tgtDn, false), true);
        //LocateEntry(tgtDn, true);
      finally
        LdapTree.Items.EndUpdate;
      end;
    end
    else
    if ValueListView.Visible and (TObjectInfo(Node.Data).dn = Entry.dn) then
        RefreshValueListView(Node);
  end;
end;

procedure TMainFrm.EntrySortProc(Entry1, Entry2: TLdapEntry; Data: pointer; out Result: Integer);
begin
  if Entry1.ObjectId = 0 then
    Entry1.ObjectId := (Entry1.Session as TConnection).DI.ClassifyLdapEntry(Entry1);
  if Entry2.ObjectId = 0 then
    Entry2.ObjectId := (Entry2.Session as TConnection).DI.ClassifyLdapEntry(Entry2);
  if ((Entry1.ObjectId = bmOu) and (Entry2.ObjectId <> bmOu)) then
    Result := -1
  else
  if ((Entry2.ObjectId = bmOu) and (Entry1.ObjectId <> bmOu))then
    Result := 1
  else
    Result := CompareText(Entry1.dn, Entry2.dn);
end;

procedure TMainFrm.SearchCallback(Sender: TLdapEntryList; var AbortSearch: Boolean);
begin
  if GetTickCount64 > FTickCount then
  begin
    Screen.Cursor := crHourGlass;
    StatusBar.Panels[3].Width := 20000;
    StatusBar.Panels[3].Text := Format(stRetrieving, [Sender.Count]);
    StatusBar.Repaint;
  end;
  if PeekKey = VK_ESCAPE then
    AbortSearch := true;
end;

procedure TMainFrm.InitTemplateMenu;
var
  i: Integer;
  Item: TCustomMenuItem;
begin
  FreeAndNil(fTemplateMenu);
  if fTemplateProperties and (TemplateParser.Count > 0) then
  begin
    fTemplateMenu := TCustomMenuItem.Create(Self);
    fTemplateMenu.Caption := cMore;
    for i := 0 to TemplateParser.Count - 1 do
    begin
      Item := TCustomMenuItem.Create(Self);
      Item.Caption := TemplateParser.Templates[i].Name;
      Item.Bitmap := TemplateParser.Templates[i].Icon;
      Item.TemplateName := TemplateParser.Templates[i].Name;
      Item.OnClick := NewTemplateClick;
      fTemplateMenu.Add(Item);
    end;
  end;
  if Assigned(Connection) then with Connection do
  begin
    ActionMenu.TemplateMenu := fTemplateMenu;
    ActionMenu.AssignItems(mbNew);
    ActionMenu.AssignItems(pbNew);
  end;
end;

procedure TMainFrm.InitLanguageMenu;
var
  i: Integer;
  CurrentLanguage: string;

  procedure AddMenuItem(const ACaption: string; ATag: Integer; AChecked: Boolean = false);
  var
    MenuItem: TMenuItem;
  begin
    MenuItem := TMenuItem.Create(Self);
    with MenuItem do begin
      Caption := ACaption;
      Tag := ATag;
      GroupIndex := 1;
      RadioItem := true;
      OnClick := LanguageExecute;
      mbLanguage.Add(MenuItem);
      if CurrentLanguage = ACaption then
      begin
        Checked := true;
        LanguageLoader.CurrentLanguage := ATag;
        LanguageLoader.Translator.TranslateForm(Self);
      end
      else
        Checked := AChecked;
    end;
  end;

begin
  if LanguageLoader.Count = 0 then
  begin
    mbLanguage.Visible := false;
    exit;
  end;

  CurrentLanguage := GlobalConfig.ReadString(rLanguage);

  mbLanguage.Clear;
  mbLanguage.Visible := true;

  AddMenuItem(cEnglish, -1, true);

  with LanguageLoader do
    for i := 0 to Count - 1 do
      AddMenuItem(Languages[i], i);
end;

function TMainFrm.PickEntry(const ACaption: string): string;
var
  DirDlg: TForm;
  ddTree: TTreeView;
  ddPanel:TPanel;
  ddOkBtn: TButton;
  ddCancelBtn: TButton;
  ddRoot: TTreeNode;
begin

  DirDlg := TForm.Create(Self);

  ddTree := TTreeView.Create(DirDlg);
  ddTree.Parent := DirDlg;
  ddTree.Align := alClient;
  ddTree.Images := ImageList;
  ddTree.ReadOnly := true;
  ddTree.OnExpanding := LDAPTreeExpanding;
  ddTree.OnDeletion := LDapTreeDeletion;

  ddPanel := TPanel.Create(DirDlg);
  ddPanel.Parent := DirDlg;
  ddPanel.Align := alBottom;
  ddPanel.Height := 34;
  ddPanel.BevelOuter := bvNone;

  TSizeGrip.Create(ddPanel);

  ddOkBtn := TButton.Create(DirDlg);
  ddOkBtn.Parent := ddPanel;
  ddOkBtn.Top := 4;
  ddOkBtn.Left := 4;
  ddOkBtn.ModalResult := mrOk;
  ddOkBtn.Caption := cOK;

  ddCancelBtn := TButton.Create(DirDlg);
  ddCancelBtn.Parent := ddPanel;
  ddCancelBtn.Top := 4;
  ddCancelBtn.Left := ddOkBtn.Width + 8;
  ddCancelBtn.ModalResult := mrCancel;
  ddCancelBtn.Caption := cCancel;


  with DirDlg do
  try
    Caption := ACaption;
    Position := poMainFormCenter;
    ddRoot := ddTree.Items.Add(nil, Connection.Base);
    ddRoot.Data := TObjectInfo.Create(TLdapEntry.Create(Connection, Connection.Base));
    ExpandNode(ddRoot, Connection);
    ddRoot.ImageIndex := bmRoot;
    ddRoot.SelectedIndex := bmRootSel;
    ddRoot.Expand(false);
    if (ShowModal = mrOk) and Assigned(ddTree.Selected) then
      Result := TObjectInfo(ddTree.Selected.Data).dn
    else
      Result := '';
  finally
    ddTree.Free;
  end;

end;

{$ifdef mswindows}
function TMainFrm.LocateEntry(const dn: string; const Select: Boolean): TTreeNode;
var
  sdn,p: string;
  comp: PPChar;
  i: Integer;
  Parent: TTreeNode;
begin
  Parent := Root;
  Result := Parent;
  Parent.Expand(false);
  sdn := System.Copy(dn, 1, Length(dn) - Length(Connection.Base));
  comp := ldap_explode_dn(PChar(sdn), 0);
  try
    if Assigned(comp) then
    begin
      i := 0;
      while PCharArray(comp)[i] <> nil do inc(i);
      while (i > 0) do
      begin
        dec(i);
        Result := Parent.GetFirstChild;
        while Assigned(Result) do
        begin
          if AnsiStrIComp(PChar(Result.Text), PCharArray(comp)[i]) = 0 then
          begin
            Parent := Result;
            if Select then
              Result.Expand(false);
            break;
          end;
          Result := Result.GetNextChild(Result);
        end;
      end;
    end;
    if Select and Assigned(Result) then
    begin
      Result.Selected := true;
      Result.MakeVisible;
    end;
  finally
    ldap_value_free(comp);
  end;
end;
{$else}

function TMainFrm.LocateEntry(const dn: string; const Select: Boolean): TTreeNode;
var
  sdn: string;
  comp: TStringList;
  i: Integer;
  Parent: TTreeNode;
begin
  Parent := Root;
  Result := Parent;
  Parent.Expand(false);
  sdn := System.Copy(dn, 1, Length(dn) - Length(Connection.Base) - 1);
  comp:=TStringList.Create;
  try
    if ldap_explode_dn(sdn, 0, comp) then
    begin
      for i:=comp.Count-1 Downto 0 do
      begin
        Result := Parent.GetFirstChild;
        while Assigned(Result) do
        begin
          if AnsiStrIComp(PChar(Result.Text), PChar(comp[i])) = 0 then
          begin
            Parent := Result;
            if Select then
              Result.Expand(false);
            break;
          end;
          Result := Result.GetNextChild(Result);
        end;
      end;
    end;
    if Select and Assigned(Result) then
    begin
      Result.Selected := true;
      Result.MakeVisible;
    end;
  finally
    comp.free;
  end;
end;
{$endif}

procedure TMainFrm.ServerConnect(Account: TAccount);
var
  NewConnection: TConnection;
begin
  Application.ProcessMessages;
  Screen.Cursor := crHourGlass;
  NewConnection := TConnection.Create(Account);
  with NewConnection do
  try
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
    fConnections.Add(NewConnection);
    ActionMenu.TemplateMenu := fTemplateMenu;
    ActionMenu.OnClick := NewClick;
    TabSet1.Tabs.Add(Account.Name);
    TabSet1.TabIndex := TabSet1.Tabs.Count - 1;
    Connection := NewConnection;
  except
    FreeAndNil(NewConnection);
    Screen.Cursor := crDefault;
    raise;
  end;

  if fConnections.Count > 1 then Exit;

  LDAPTree.PopupMenu := EditPopup;
  EntryListView.PopupMenu := EditPopup;
  ListPopup.AutoPopup := true;
  try
    fLdapTreeWidth :=  GlobalConfig.ReadInteger(rMwLTWidth);
    LdapTree.Width := fLdapTreeWidth;
  except
    fLdapTreeWidth := LdapTree.Width
  end;
  try
    fViewSplitterPos := GlobalConfig.ReadInteger(rMwViewSplit);
  except
    fViewSplitterPos := ListViewPanel.Height div 2;
  end;
  try
    if Boolean(GlobalConfig.ReadInteger(rMwShowEntries)) <> ActEntries.Checked then
      ActEntriesExecute(nil);
  except end;
  try
    if Boolean(GlobalConfig.ReadInteger(rMwShowValues)) <> ActValues.Checked then
      ActValuesExecute(nil);
  except end;
  try
    EntryListView.ViewStyle := TViewStyle(GlobalConfig.ReadInteger(rEvViewStyle));
    case Ord(EntryListView.ViewStyle) of
      0: ActIconView.Checked := true;
      1: ActSmallView.Checked := true;
      2: ActListView.Checked := true;
    end;
  except end;
end;

procedure TMainFrm.ServerDisconnect;
var
  idx: Integer;
begin
  idx := TabSet1.TabIndex;
  if idx >= 0 then
  begin
    Connection.Disconnect;
    {$ifdef mswindows}
    fConnections.Delete(idx);
    {$else}
    fConnections.Delete(idx-1);
    {$endif}
    Connection := nil;
    TabSet1.Tabs.Delete(idx);
    idx := TabSet1.TabIndex;
    { force onchange event }
    TabSet1.TabIndex := -1;
    TabSet1.TabIndex := idx;
  end;
  if fConnections.Count = 0 then
  begin
    LDAPTree.PopupMenu := nil;
    ListPopup.AutoPopup := false;
    MainFrm.Caption := cAppName;
    LDAPTree.Items.BeginUpdate;
    LDAPTree.Items.Clear;
    LDAPTree.Items.EndUpdate;
    ValueListView.Items.Clear;
    EntryListView.Items.Clear;
    fTreeHistory.Clear;
    if Visible then
      LDAPTree.SetFocus;
  end;
end;

procedure TMainFrm.InitStatusBar;
var
 s: string;
begin
  if (Connection <> nil) and (Connection.Connected) then begin
    s := Format(cServer, [Connection.Server]);
    StatusBar.Panels[1].Style := psOwnerDraw;
    StatusBar.Panels[0].Width := StatusBar.Canvas.TextWidth(s) + 16;
    StatusBar.Panels[0].Text := s;
    s := Format(cUser, [Connection.User]);
    StatusBar.Panels[2].Width := StatusBar.Canvas.TextWidth(s) + 16;
    StatusBar.Panels[2].Text := s;
  end
  else begin
    StatusBar.Panels[1].Style := psText;
    StatusBar.Panels[0].Text := '';
    StatusBar.Panels[1].Text := '';
    StatusBar.Panels[2].Text := '';
    StatusBar.Panels[3].Text := '';
    StatusBar.Panels[4].Text := '';
  end;
end;

procedure TMainFrm.ReadConfig;
var
  a, b, c: Boolean;
begin
  fQuickSearchFilter := GlobalConfig.ReadString(rQuickSearchFilter, sDEFQUICKSRCH);
  fLocatedEntry := -1;
  a := fIdObject;
  b := fEnforceContainer;
  c := UseTemplateImages;
  fIdObject := GlobalConfig.ReadBool(rMwLTIdentObject, true);
  fEnforceContainer := GlobalConfig.ReadBool(rMwLTEnfContainer, true);
  fTemplateProperties := GlobalConfig.ReadBool(rTemplateProperties, true);
  UseTemplateImages := GlobalConfig.ReadBool(rUseTemplateImages, false);
  if TemplateParser.ImageList <> ImageList then
    TemplateParser.ImageList := ImageList;
  if Visible then
  begin
    InitTemplateMenu;
    InitLanguageMenu;
    if Assigned(Connection) and ((a <> fIdObject) or (b <> fEnforceContainer) or (c <> UseTemplateImages)) then
      RefreshTree;
  end;
end;

procedure TMainFrm.RefreshStatusBar;
var
  s3, s4: string;
begin
  if StatusBar.Tag <> 0 then Exit;
  s4 := '';
  if LDAPTree.Selected <> nil then with LDAPTree.Selected do
  begin
    s3 := ' ' + TObjectInfo(Data).dn;
    if (Count=0) or (Integer(Items[0].Data) <> ncDummyNode) then
    begin
      s4 := Format(stCntSubentries, [Count]);
      StatusBar.Panels[3].Width := StatusBar.Canvas.TextWidth(s3) + 16;
    end
    else
      StatusBar.Panels[3].Width := 20000;
  end
  else
    s3 := '';
  StatusBar.Panels[3].Text := s3;
  StatusBar.Panels[4].Text := s4;
  Application.ProcessMessages;
end;

function TMainFrm.ShowSchema: TSchemaDlg;
var
  i: Integer;
begin
  for i:=0 to Screen.FormCount-1 do begin
    if (Screen.Forms[i] is TSchemaDlg) and
       (TSchemaDlg(Screen.Forms[i]).Schema.Session = Connection) then
    begin
      Result := TSchemaDlg(Screen.Forms[i]);
      Result.Show;
      exit;
    end;
  end;
  Result := TSchemaDlg.Create(Connection);
end;

function TMainFrm.SelectedNode: TTreeNode;
begin
  Result := nil;
  if EntryListView.Focused then
  begin
    if Assigned(EntryListView.Selected) then
      Result := EntryListView.Selected.Data;
  end
  else
    Result := LDAPTree.Selected
end;

procedure TMainFrm.ClassifyEntry(ObjectInfo: TObjectInfo; CNode: TTreeNode);
var
  bmIndex: Integer;
begin
  if fidObject then
    bmIndex := ObjectInfo.ImageIndex
  else
    bmIndex := bmEntry;
  CNode.ImageIndex := bmIndex;
  CNode.SelectedIndex := bmIndex;

  { Add dummy node to make node expandable }
  if not CNode.HasChildren and (not fEnforceContainer or ObjectInfo.IsContainer) then
    LDAPTree.Items.AddChildObject(CNode, '', Pointer(ncDummyNode));
end;

function TMainFrm.IsContainer(ANode: TTreeNode): Boolean;
begin
  Result := not fEnforceContainer or TObjectInfo(ANode.Data).IsContainer;
end;

procedure TMainFrm.ExpandNode(Node: TTreeNode; Session: TLDAPSession);
var
  CNode: TTreeNode;
  i: Integer;
  attrs: PCharArray;
  Entry: TLDapEntry;
  ObjectInfo: TObjectInfo;
begin
  FTickCount := GetTickCount64 + 500;
  try
    SetLength(attrs, 2);
    attrs[0] := 'objectclass';
    attrs[1] := nil;
    Session.Search(sAnyClass, TObjectInfo(Node.Data).dn, LDAP_SCOPE_ONELEVEL, attrs, false, fSearchList, SearchCallback);
    for i := 0 to fSearchList.Count - 1 do
    begin
      Entry := fSearchList[i];
      ObjectInfo := TObjectInfo.Create(Entry);
      CNode := LDAPTree.Items.AddChildObject(Node, DecodeDNString(GetRdnFromDn(Entry.dn)), ObjectInfo);
      ClassifyEntry(ObjectInfo, CNode);
    end;
  finally
    RefreshStatusBar;
    fSearchList.Clear;
    ///Node.CustomSort(@TreeSortProc, 0);
    Node.CustomSort(TreeSortProc);
    Screen.Cursor := crDefault;
  end;
end;

procedure TMainFrm.RefreshNode(Node: TTreeNode; Expand: Boolean);
var
  Expanded: Boolean;
begin
  if Assigned(Node) then
  begin
    LDAPTree.Items.BeginUpdate;
    try
      Expanded := Node.Expanded;
      Node.DeleteChildren;
      ExpandNode(Node, Connection);
      if Expanded or Expand then
        Node.Expand(false);
    finally
      LDAPTree.Items.EndUpdate;
    end;
  end;
end;

procedure TMainFrm.RefreshTree;
begin
  LDAPTree.Items.BeginUpdate;
  try
    LDAPTree.Items.Clear;
    if ValueListView.Visible then
      ValueListView.Items.Clear;
    if EntryListView.Visible then
      EntryListView.Items.Clear;
    Root := LDAPTree.Items.Add(nil, Format('%s [%s]', [Connection.Base, Connection.Server]));
    Root.Data := TObjectInfo.Create(TLdapEntry.Create(Connection, Connection.Base));
    ExpandNode(Root, Connection);
    Root.ImageIndex := bmRoot;
    Root.SelectedIndex := bmRootSel;
    Root.Selected := true;
  finally
    LDAPTree.Items.EndUpdate;
  end;
  Root.Expand(false);
end;

procedure TMainFrm.RefreshValueListView(Node: TTreeNode);
var
  ListItem: TListItem;

  procedure ShowAttrs(Attributes: TLdapAttributeList);
  var
    i, j: Integer;

    function DataTypeToText(const AType: TDataTYpe): string;
    begin
      case AType of
        dtText: Result := cText;
        dtBinary: Result := cBinary;
        dtJpeg: Result := cImage;
        dtCert: Result := cCert;
      else
        Result := cUnknown;
      end;
    end;

  begin
    for i := 0 to Attributes.Count - 1 do with Attributes[i] do
    for j := 0 to Attributes[i].ValueCount - 1 do
    begin
      ListItem := ValueListView.Items.Add;
      ListItem.Caption := Name;
      with Values[j] do
      begin
        if DataType = dtText then
          ListItem.SubItems.Add(AsString)
        else
          ListItem.SubItems.Add(HexMem(Data, DataSize, true));
        ListItem.SubItems.Add(DataTypeToText(DataType));
        ListItem.SubItems.Add(IntToStr(DataSize));
      end;
      ListItem.Data := Attributes[i].Values[j];
    end;
  end;

begin
  {$ifndef mswindows}
  if Node = nil then exit;
  {$endif}
  with TObjectInfo(Node.Data).Entry do
  begin
    Read;
    try
      ValueListView.Items.BeginUpdate;
      ValueListView.Items.Clear;
      ShowAttrs(Attributes);
      ShowAttrs(OperationalAttributes);
      //RefreshStatusBar;
    finally
      ValueListView.Items.EndUpdate;
    end;
    RefreshStatusBar;
  end;
end;

procedure TMainFrm.RefreshEntryListView(Node: TTreeNode);
var
  s: string;
  ListItem: TListItem;
  ANode: TTreeNode;
begin
  with EntryListView, Items do
  try
    BeginUpdate;
    Clear;
    ANode := Node.GetFirstChild;
    while Assigned(ANode) do begin
      s := ANode.Text;
      ListItem := Add;
      with ListItem do begin
        Caption := Copy(s, Pos('=', s) + 1, MaxInt);
        Data := ANode;
        ImageIndex := ANode.ImageIndex;
      end;
      ANode := Node.GetNextChild(ANode);
    end;
    finally
      EndUpdate;
    end;
end;

procedure TMainFrm.FormCreate(Sender: TObject);
begin
  LdapTree.DoubleBuffered := true;
  ValueListView.DoubleBuffered := true;
  EntryListView.DoubleBuffered := true;
  fDisabledImages := TBetaDisabledImageList.Create(self);
  fDisabledImages.MasterImages := ImageList;
  ToolBar.DisabledImages := fDisabledImages;
  fConnections := TObjectList.Create;
  fSearchList := TLdapEntryList.Create(false);
  fLocateList := TLdapEntryList.Create;
  fTreeHistory := TTreeHistory.Create;
  TemplateParser.ImageList := ImageList;
  ValueListView.Align := alClient;
  ViewSplitter.Visible := false;
  ReadConfig;
  HintWindowClass := TGraphicHintWindow;
end;

procedure TMainFrm.FormDestroy(Sender: TObject);
begin
  GlobalConfig.WriteInteger(rMwLTWidth, LdapTree.Width);
  GlobalConfig.WriteInteger(rMwShowEntries, Ord(ActEntries.Checked));
  GlobalConfig.WriteInteger(rMwShowValues, Ord(ActValues.Checked));
  GlobalConfig.WriteInteger(rMwViewSplit, ViewSplitter.Top);
  GlobalConfig.WriteInteger(rEvViewStyle, Ord(EntryListView.ViewStyle));
  fDisabledImages.Free;
  fConnections.Free;
  fSearchList.Free;
  fLocateList.Free;
  fTreeHistory.Free;
  fCmdLineAccount.Free;
end;

procedure TMainFrm.LDAPTreeExpanding(Sender: TObject; Node: TTreeNode; var AllowExpansion: Boolean);
begin
  if (Node.Count > 0) and (Integer(Node.Items[0].Data) = ncDummyNode) then
  //if (Node.Count > 0) and (Integer(Node.Data) = ncDummyNode) then
  with (Sender as TTreeView) do
  try
    Items.BeginUpdate;
    Node.Items[0].Delete;
    ExpandNode(Node, Connection);
  finally
    Items.EndUpdate;
  end;
end;

procedure TMainFrm.LDAPTreeDeletion(Sender: TObject; Node: TTreeNode);
begin
  if (Node.Data <> nil) and (Integer(Node.Data) <> ncDummyNode) then
    TObjectInfo(Node.Data).Free;
end;

procedure TMainFrm.LDAPTreeChange(Sender: TObject; Node: TTreeNode);
var
  CanExpand: Boolean;
begin
    { To save memory. But tose are just few kb per entry, is it worth? }
    //if Assigned(fTreeHistory.Current) then TLDapEntry(fTreeHistory.Current.Data).Attributes.Clear;
    fTreeHistory.Current:=LdapTree.Selected;

    // Update Value List
    if ValueListView.Visible then
        RefreshValueListView(Node);

    // Update Attribute List
    if EntryListView.Visible and (Sender <> nil) then
    begin
      CanExpand := false;
      LDAPTreeExpanding(Node.TreeView, Node, CanExpand);
      RefreshEntryListView(Node);
    end;
end;

procedure TMainFrm.LDAPTreeContextPopup(Sender: TObject; MousePos: TPoint; var Handled: Boolean);
var
  Node: TTreeNode;
begin
  Node := LDAPTree.GetNodeAt(MousePos.X, MousePos.Y);
  if (Node <> nil) then
    Node.Selected := true;
end;

procedure TMainFrm.LDAPTreeDblClick(Sender: TObject);
begin
  if LDAPTree.Selected=nil then exit;
  if PtInRect(LDAPTree.Selected.DisplayRect(false), LdapTree.ScreenToClient(Mouse.CursorPos)) and
    not IsContainer(LdapTree.Selected) and IsActPropertiesEnable then
      ActPropertiesExecute(Sender)
end;

procedure TMainFrm.RemoveNodes(List: TStringList);
var
  i: Integer;
  Node: TTreeNode;
  ListItem: TListItem;
begin
  for i := 0 to List.Count - 1 do
  begin
    if List.Objects[i] <> LDAP_OP_SUCCESS then
      Continue;
    Node := LocateEntry(List[i], false);
    {$ifndef mswindows}
    // for treeview event onchange
    Node.Parent.Selected:=true;
    {$endif}
    if Assigned(Node) and (TObjectInfo(Node.Data).dn = List[i]) then
    begin
      if EntryListView.Visible then
      begin
        ListItem := EntryListView.FindData(0, Node, true, false);
        if Assigned(ListItem) then
          ListItem.Delete;
      end;
      Node.Delete;
    end;
  end;
end;

procedure TMainFrm.GetSelection(List: TStringList);
var
  SelItem: TListItem;
  SelNode: TTreeNode;
begin
  if LdapTree.Focused then
  begin
    SelNode := SelectedNode;
    if Assigned(SelNode) then
      List.Add(TObjectInfo(SelNode.Data).dn)
  end
  else begin
    SelItem := EntryListView.Selected;
    repeat
      List.Add(TObjectInfo(TTreeNode(SelItem.Data).Data).dn);
      SelItem:= EntryListView.GetNextItem(SelItem, sdAll, [lisSelected]);
    until SelItem = nil;
  end;
end;

procedure TMainFrm.CopySelection(TargetSession: TLdapSession; TargetDn, TargetRdn: string; Move: Boolean);
var
  List: TStringList;
begin
  List := TStringList.Create;
  try
    GetSelection(List);
    DoCopyMove(List, TargetSession, TargetDn, TargetRdn, Move);
  finally
    List.Free
  end;
end;

procedure TMainFrm.DoCopyMove(List: TStringList; TargetSession: TLdapSession; TargetDn, TargetRdn: string; Move: Boolean);
var
  Node: TTreeNode;
  dstdn, seldn: string;
  ep: TLVCustomDrawItemEvent;

  procedure SafeRefresh(Node: TTreeNode; Expand: Boolean);
  begin
    if Copy(seldn, Length(seldn) - Length(dstdn) + 1, MaxInt) = dstdn then
    begin
      try
        ep := ValueListView.OnCustomDrawItem;
        ValueListView.OnCustomDrawItem := nil;
        RefreshNode(Node, Expand);
      finally
        ValueListView.OnCustomDrawItem := ep;
      end;
      LocateEntry(seldn, true);
      if ValueListView.Visible then
        RefreshValueListView(LdapTree.Selected);
      if EntryListView.Visible then
        RefreshEntryListView(LdapTree.Selected);
    end
    else
      RefreshNode(Node, Expand);
  end;

begin
  with TLdapOpDlg.Create(Self, Connection) do
  try
    ShowProgress := true;
    DestSession := TargetSession;

    if List.Count = 1 then
    begin
      CopyTree(List[0], TargetDn, TargetRdn, Move);
      List.Objects[0] := LDAP_OP_SUCCESS;
    end
    else begin
      Show;
      CopyTree(List, TargetDn, Move);
    end;

    if Move then
      RemoveNodes(List);

  finally
    Free;
    if TargetSession = Connection then
    begin
      LdapTree.Items.BeginUpdate;
      try
        Node := LdapTree.Selected;
        if Assigned(Node) then
          seldn := TObjectInfo(Node.Data).dn
        else
          seldn := '';
        dstdn := TargetDn;
        SafeRefresh(LocateEntry(TargetDn, false), true);
      finally
        LdapTree.Items.EndUpdate;
      end;
    end;
  end;
end;

procedure TMainFrm.CopyMove(Move: Boolean);
var
  Node: TTreeNode;
  cnt: Integer;
  TargetData: TTargetData;
begin
  Node := SelectedNode;
  if Assigned(Node) then
  begin
    cnt := 0;
    if EntryListView.Focused then
      cnt := EntryListView.SelCount;
    if ExecuteCopyDialog(Self, TObjectInfo(Node.Data).dn, cnt, Move, Connection, TargetData) then
      CopySelection(TargetData.Connection, TargetData.Dn, TargetData.Rdn, Move);
  end;
end;

procedure TMainFrm.DoDelete(List: TStringList);
var
  msg: string;
begin
  if List.Count > 1 then
    msg := Format(stConfirmMultiDel, [List.Count])
  else
    msg := Format(stConfirmDel, [List[0]]);

  if MessageDlg(msg, mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  with TLdapOpDlg.Create(Self, Connection) do
  try
    ShowProgress := true;
    if List.Count = 1 then
    begin
      DeleteTree(List[0]);
      if ModalResult = mrNone then
        List.Objects[0] := LDAP_OP_SUCCESS;
    end
    else begin
      Show;
      DeleteTree(List);
    end;
    RemoveNodes(List);
  finally
    Free;
  end;
end;

procedure TMainFrm.Delete;
var
  List: TStringList;
begin
  List := TStringList.Create;
  try
    GetSelection(List);
    DoDelete(List);
  finally
    List.Free;
  end;
end;

procedure TMainFrm.LDAPTreeEdited(Sender: TObject; Node: TTreeNode; var S: String);
var
  newdn, pdn, temp: string;
  i: Integer;
begin
  with TLdapOpDlg.Create(Self, Connection) do
  try
    i := Pos('=', S);
    if i = 0 then
    begin
      temp := GetAttributeFromDn(TObjectInfo(LDAPTree.Selected.Data).dn) + '=';
      newdn := temp + EncodeDNString(S);
      S := temp + S;
    end
    else
      newdn := Copy(S, 1, i - 1) + '=' + EncodeDNString(Copy(S, i + 1, Length(S) - i));
    pdn := GetDirFromDn(TObjectInfo(LDAPTree.Selected.Data).dn);
    CopyTree(TObjectInfo(LDAPTree.Selected.Data).dn, pdn, newdn, true);
    TObjectInfo(LDAPTree.Selected.Data).Free;
    LdapTree.Selected.Data := TObjectInfo.Create(TLdapEntry.Create(Connection, newdn + ',' + pdn));
    ActRefreshExecute(nil);    
  finally
    Free;
  end;
end;

procedure TMainFrm.LDAPTreeDragOver(Sender, Source: TObject; X, Y: Integer; State: TDragState; var Accept: Boolean);
var
  srcdn, dstdn: string;
begin

  with LdapTree do
  if Assigned(DropTarget) and (DropTarget = GetNodeAt(X, Y)) and IsContainer(DropTarget) then
    dstdn := TObjectInfo(DropTarget.Data).dn
  else begin
    Accept := false;
    exit;
  end;

  if Source is TSearchListView then
    srcdn := TLdapEntry(TSearchListView(Source).Selected.Data).dn
  else
    srcdn := TObjectInfo(SelectedNode.Data).dn;

  Accept := Accept and (System.Copy(dstdn, Length(dstdn) - Length(srcdn) + 1, MaxInt) <> srcdn);
end;

procedure TMainFrm.LDAPTreeDragDrop(Sender, Source: TObject; X, Y: Integer);
var
  msg: String;
  cpy: boolean;
begin
  cpy := GetKeyState(VK_CONTROL) < 0;
  if cpy then
    msg := stAskTreeCopy
  else
    msg := stAskTreeMove;

  if Source is TListView then
  begin
    if TListView(Source).SelCount > 1 then
      msg := Format(msg, [Format(stNumObjects, [TListView(Source).SelCount]), LDAPTree.DropTarget.Text])
    else
      msg := Format(msg, [TListView(Source).Selected.Caption, LDAPTree.DropTarget.Text]);
  end
  else
    msg := Format(msg, [TTreeView(Source).Selected.Text, LDAPTree.DropTarget.Text]);

  if MessageDlg(msg, mtConfirmation, [mbOk, mbCancel], 0) = mrOk then
  begin
    if (Source is TSearchListView)  then
      TSearchListView(Source).CopySelection(Connection, TObjectInfo(LDAPTree.DropTarget.Data).dn, '', not cpy)
    else
      CopySelection(Connection, TObjectInfo(LDAPTree.DropTarget.Data).dn, '', not cpy)
  end;
end;

procedure TMainFrm.LDAPTreeStartDrag(Sender: TObject; var DragObject: TDragObject);
begin
  ScrollTimer.Enabled := True;
end;

procedure TMainFrm.LDAPTreeEndDrag(Sender, Target: TObject; X, Y: Integer);
begin
  ScrollTimer.Enabled := False;
end;


procedure TMainFrm.ScrollTimerTimer(Sender: TObject);
begin
  OnScrollTimer(ScrollTimer, LdapTree, ScrollAccMargin);
end;

procedure TMainFrm.ValueListViewCustomDrawItem(Sender: TCustomListView; Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean);
var
  i: Integer;
begin
  with ValueListView.Canvas do
  begin
    if odd(Item.Index) then Brush.Color:=$00f0f0f0;
    with TLdapAttributeData(Item.Data), Font do
    begin
      if lowercase(Attribute.Name) = 'objectclass' then
      begin
        Style := [fsBold];
        Color := clNavy
      end
      else
      if Attribute.Entry.OperationalAttributes.AttributeOf(Item.Caption) = Attribute then
        Color := clDkGray
      else
      ///if TabSet1.TabIndex <> -1 then

      if TabSet1.TabIndex > 0 then
      with TConnection(fConnections[TabSet1.TabIndex-1]) do
        if Schema.Loaded then
        begin
         for i := 0 to Schema.ObjectClasses.Count - 1 do
           if Schema.ObjectClasses[i].Must.ByName[Attribute.Name] <> nil then
           begin
             //Color := clOlive;
             Style := [fsBold];
             Break;
           end;
        end;

    end;
  end;
end;

procedure TMainFrm.NewClick(Sender: TObject);
begin
  with Sender as TCustomMenuItem do
  case ActionId of
    aidTemplate: begin
                  NewTemplateClick(Sender);
                  exit;
                end;
    aidEntry:    with TEditEntryFrm.Create(Self, TObjectInfo(LDAPTree.Selected.Data).dn, Connection, EM_ADD) do
                begin
                  OnWrite := EntryWrite;
                  Show;
                  Exit;
                end
  else
    if not Connection.DI.NewProperty(Self, ActionId, TObjectInfo(LDAPTree.Selected.Data).dn) then
      Exit;
  end;
  ActRefreshExecute(nil);
end;


procedure TMainFrm.ActConnectExecute(Sender: TObject);
begin
  with TConnListFrm.Create(Self) do
  try
    if ShowModal = mrOk then
      ServerConnect(Account);
  finally
    Screen.Cursor := crDefault;
    Destroy;
  end;
end;

procedure TMainFrm.ActDisconnectExecute(Sender: TObject);
begin
  ServerDisconnect;
  InitStatusBar;
end;

procedure TMainFrm.ActExitExecute(Sender: TObject);
begin
  Application.MainForm.Close;
end;

procedure TMainFrm.ActionListUpdate(Action: TBasicAction; var Handled: Boolean);
var
  Enbl: boolean;
begin
  Enbl := Assigned(Connection) and Connection.Connected;
  ActAlias.Visible := Enbl and Assigned(Connection.ActionMenu.GetActionItem(aidAlias));
  ActDisconnect.Enabled:= Enbl;
  ActSchema.Enabled:= Enbl and (Connection.Version >= LDAP_VERSION3);
  ActImport.Enabled:= Enbl;
  ActRefresh.Enabled:=Enbl;
  ActSearch.Enabled:=Enbl;
  ActModifySet.Enabled:=Enbl;
  ActPreferences.Enabled:=Enbl;
  ActCustomizeMenu.Enabled := Enbl;
  ActEntries.Enabled:= Enbl;
  ActValues.Enabled:= Enbl;
  ActLocateEntry.Enabled := Enbl;

  Enbl:=Enbl and (SelectedNode <> nil) and ((LdapTree.Focused or EntryListView.Focused));
  if Enbl then
    ActDeleteEntry.ShortCut := VK_DELETE
  else
    ActDeleteEntry.ShortCut := 0;

  ActExport.Enabled:= Enbl;
  ActPassword.Enabled:=Enbl;
  ActCopyDn.Enabled := Enbl;
  ActEditEntry.Enabled:=Enbl;
  ActCopyEntry.Enabled:=Enbl;
  ActMoveEntry.Enabled:=Enbl;
  ActRenameEntry.Enabled:=Enbl;
  ActDeleteEntry.Enabled:=Enbl;
  ActAlias.Enabled := Enbl;
  ActProperties.Enabled:=Enbl and IsActPropertiesEnable;
  Enbl := Enbl and IsContainer(SelectedNode);
  mbNew.Enabled:=Enbl;
  pbNew.Enabled:=Enbl;
  Enbl := Assigned(Connection) and Connection.Connected and Assigned(ValueListView.Selected);
  ActViewBinary.Enabled := Enbl;
  ActCopy.Enabled := Enbl;
  ActCopyValue.Enabled := Enbl;
  ActCopyName.Enabled := Enbl;
  ActFindInSchema.Enabled := Enbl;

  mbViewStyle.Enabled := EntryListView.Visible;

  UndoBtn.Enabled:=fTreeHistory.IsUndo;
  RedoBtn.Enabled:=fTreeHistory.IsRedo;
end;

procedure TMainFrm.ActSchemaExecute(Sender: TObject);
begin
  ShowSchema;
end;

procedure TMainFrm.ActImportExecute(Sender: TObject);
begin
  if TImportDlg.Create(Self, Connection).ShowModal = mrOk then
    RefreshTree;
end;

procedure TMainFrm.ActExportExecute(Sender: TObject);
var
  SelItem: TListItem;
begin
  with TExportDlg.Create(Connection) do
  begin
    if LdapTree.Focused then
      AddDn(TObjectInfo(SelectedNode.Data).dn)
    else begin
      SelItem := EntryListView.Selected;
      repeat
        AddDN(TObjectInfo(TTreeNode(SelItem.Data).Data).dn);
        SelItem:= EntryListView.GetNextItem(SelItem, sdAll, [lisSelected]);
      until SelItem = nil;
    end;
    ShowModal;
  end;
end;

procedure TMainFrm.ActPreferencesExecute(Sender: TObject);
begin
  TPrefDlg.Create(Self, Connection).ShowModal;
end;

procedure TMainFrm.ActAboutExecute(Sender: TObject);
begin
  TAboutDlg.Create(Self).ShowModal;
end;

procedure TMainFrm.ActEditEntryExecute(Sender: TObject);
begin
  if SelectedNode <> nil then
    with TEditEntryFrm.Create(Self, TObjectInfo(SelectedNode.Data).dn, Connection, EM_MODIFY) do
    begin
      OnWrite := EntryWrite;
      Show;
    end;
end;

procedure TMainFrm.ActDeleteEntryExecute(Sender: TObject);
begin
  Delete;
end;

procedure TMainFrm.ActRefreshExecute(Sender: TObject);
begin
  if Assigned(LDAPTree.Selected) then
  begin
    RefreshNode(LDAPTree.Selected, true);
    if ValueListView.Visible then
      RefreshValueListView(LDAPTree.Selected);
    if EntryListView.Visible then
      RefreshEntryListView(LDAPTree.Selected);
  end;
end;

procedure TMainFrm.ActSearchExecute(Sender: TObject);
begin
  if LDAPTree.Selected = nil then LDAPTree.Selected := LDAPTree.TopItem;
  TSearchFrm.Create(Self, TObjectInfo(LDAPTree.Selected.Data).dn, Connection).Show;
end;

procedure TMainFrm.EditProperty(AOwner: TControl; ObjectInfo: TObjectInfo);
begin
  case ObjectInfo.ActionId of
    aidNone:
      begin
        with TTemplateForm.Create(AOwner, ObjectInfo.dn, Connection, EM_MODIFY) do
        try
          LoadMatching;
          if TemplatePanels.Count > 0 then
            ShowModal;
        finally
          Free;
        end;
      end;
    aidTemplate:
      begin
        with TTemplateForm.Create(AOwner, ObjectInfo.dn, Connection, EM_MODIFY) do
        try
          AddTemplate(ObjectInfo.Template);
          ShowModal;
        finally
          Free;
        end;
      end;
  else
    Connection.DI.EditProperty(AOwner, Connection.ActionMenu.GetActionId(ObjectInfo.ObjectId), ObjectInfo.dn);
  end;
end;

procedure TMainFrm.ActPropertiesExecute(Sender: TObject);
begin
  if SelectedNode <> nil then
  begin
    EditProperty(Self, TObjectInfo(SelectedNode.Data));
    try
      LDAPTreeChange(nil, LDAPTree.Selected);
    except
      { Could be deleted or renamed, so try to refresh parent instead }
      LdapTree.Selected := LDAPTree.Selected.Parent;
      ActRefreshExecute(nil);
    end;
  end;
end;

function TMainFrm.IsActPropertiesEnable: boolean;
var
  Node: TTreeNode;
begin
  Result := false;
  Node := SelectedNode;
  if Node <> nil then
  begin
    Result := TObjectInfo(Node.Data).Supported;
    if not Result and fTemplateProperties {and (TObjectInfo(Node.Data).ObjectId = oidEntry)} then
      Result := TTemplateForm.HasMatchingTemplates(TObjectInfo(SelectedNode.Data).Entry);
  end;
end;

procedure TMainFrm.ActPasswordExecute(Sender: TObject);
begin
  if Connection.DI.ChangePassword(TObjectInfo(SelectedNode.Data).Entry) and ValueListView.Visible then
     RefreshValueListView(SelectedNode);
end;

procedure TMainFrm.ActCopyEntryExecute(Sender: TObject);
begin
  CopyMove(false);
end;

procedure TMainFrm.ActMoveEntryExecute(Sender: TObject);
begin
  CopyMove(true);
end;

procedure TMainFrm.StatusBarDrawPanel(StatusBar: TStatusBar; Panel: TStatusPanel; const Rect: TRect);
begin
  if (Connection<>nil) and (Connection.Connected) and (Connection.SSL or Connection.TLS) then
    ImageList.Draw(StatusBar.Canvas,Rect.Left+2,Rect.Top, bmLocked)
  else
    ImageList.Draw(StatusBar.Canvas,Rect.Left+2,Rect.Top,bmUnlocked);
end;

procedure TMainFrm.ActViewBinaryExecute(Sender: TObject);
begin
  if Assigned(LdapTree.Selected) and Assigned(ValueListView.Selected) then
  with THexView.Create(Self) do
  try
    StreamCopy(TLdapAttributeData(ValueListView.Selected.Data).SaveToStream, LoadFromStream);
    ShowModal;
  finally
    Free;
  end;
end;

procedure TMainFrm.ActValuesExecute(Sender: TObject);
begin
  ActValues.Checked := not ActValues.Checked;
  if ActValues.Checked then
  begin
    ListViewPanel.Visible := true;
    TreeViewPanel.Align := alLeft;
    TreeViewPanel.Width := fLdapTreeWidth;
    TreeSplitter.Visible := true;
    if EntryListView.Visible then
    begin
      ValueListView.Align := alTop;
      ValueListView.Height := fViewSplitterPos + ViewSplitter.Height;
      ViewSplitter.Visible := true;
    end
    else
      ValueListView.Align := alClient;
    ValueListView.Visible := true;
    if Assigned(LDAPTree.Selected) then
      LDAPTreeChange(LDAPTree, LDAPTree.Selected);
  end
  else begin
    if EntryListView.Visible then
    begin
      fViewSplitterPos := ViewSplitter.Top;
    end
    else begin
      TreeSplitter.Visible := false;
      ListViewPanel.Visible := false;
      fLdapTreeWidth := TreeViewPanel.Width;
      TreeViewPanel.Align := alClient;
    end;
    ValueListView.Visible := false;
    ViewSplitter.Visible := false;
  end;
end;

procedure TMainFrm.ActEntriesExecute(Sender: TObject);
begin
  ActEntries.Checked := not ActEntries.Checked;
  if ActEntries.Checked then
  begin
    ListViewPanel.Visible := true;
    TreeViewPanel.Align := alLeft;
    TreeViewPanel.Width := fLdapTreeWidth;
    TreeSplitter.Visible := true;
    EntryListView.Visible := true;
    if ValueListView.Visible then
    begin
      ValueListView.Align := alTop;
      ValueListView.Height := fViewSplitterPos + ViewSplitter.Height;
      ViewSplitter.Top := ValueListView.Height;
      ViewSplitter.Visible := true;
    end;
    if Assigned(LDAPTree.Selected) then
      LDAPTreeChange(LDAPTree, LDAPTree.Selected);
  end
  else begin
    EntryListView.Visible := false;
    ViewSplitter.Visible := false;
    EntryListView.Items.Clear;
    if not ValueListView.Visible then
    begin
      TreeSplitter.Visible := false;
      ListViewPanel.Visible := false;
      fLdapTreeWidth := TreeViewPanel.Width;
      TreeViewPanel.Align := alClient;
    end
    else begin
      fViewSplitterPos := ViewSplitter.Top;
      ValueListView.Align := alClient;
    end;
  end;
end;

procedure TMainFrm.EntryListViewDblClick(Sender: TObject);
var
  Node: TTreeNode;
begin
  Node := SelectedNode;
  if Node=nil then exit;
  with EntryListView do
  begin
    if PtInRect(Selected.DisplayRect(drSelectBounds), ScreenToClient(Mouse.CursorPos)) then
    begin
      if Node.HasChildren then
        Node.Selected := true
      else
      if IsActPropertiesEnable then
        ActPropertiesExecute(Sender);
    end;
  end;
end;

procedure TMainFrm.ActIconViewExecute(Sender: TObject);
begin
  EntryListView.ViewStyle := vsIcon;
  mbIconView.Checked := true;
end;

procedure TMainFrm.ActListViewExecute(Sender: TObject);
begin
  EntryListView.ViewStyle := vsList;
  mbListView.Checked := true;
end;

procedure TMainFrm.ActSmallViewExecute(Sender: TObject);
begin
  EntryListView.ViewStyle := vsSmallIcon;
  mbSmallView.Checked := true;
end;

procedure TMainFrm.FormShow(Sender: TObject);
var
  aproto, auser, apassword, ahost, abase: string;
  aport, aversion, i:     integer;
  auth: TLdapAuthMethod;
  SessionName, StorageName: string;
  AStorage: TConfigStorage;
begin
  InitTemplateMenu;
  InitLanguageMenu;
  GlobalConfig.CheckProtocol;
  // ComandLine params /////////////////////////////////////////////////////////
  if ParamCount <> 0 then
  begin
    aproto:='ldap';
    aport:=LDAP_PORT;
    auser:='';
    apassword:='';
    auth:=AUTH_SIMPLE;
    aversion:=LDAP_VERSION3;
    ParseURL(ParamStr(1), aproto, auser, apassword, ahost, abase, aport, aversion, auth);
    fCmdLineAccount := TFakeAccount.Create(nil, ahost);
    with fCmdLineAccount do
    begin
      Server := ahost;
      Port := aport;
      Base := abase;
      User := auser;
      Password := apassword;
      SSL := aproto='ldaps';
      AuthMethod := auth;
      LdapVersion := aversion;
      ServerConnect(fCmdLineAccount);
    end;
    Exit;
  end;
  // Autostart
  with GlobalConfig do
  begin
    SessionName := ReadString('StartupSession');
    if SessionName <> '' then
    begin
      i := Pos(':', SessionName);
      StorageName := Copy(SessionName, 1, i - 1);
      SessionName := Copy(SessionName, i + 1, MaxInt);
      AStorage := StorageByName(StorageName);
      if Assigned(AStorage) then
        ServerConnect(AStorage.AccountByName(SessionName));
    end;
  end;
end;

procedure TMainFrm.ActOptionsExecute(Sender: TObject);
begin
  if TConfigDlg.Create(Self, Connection).ShowModal = mrOk then
    ReadConfig;
end;

procedure TMainFrm.ActLocateEntryExecute(Sender: TObject);
begin
  if SearchPanel.Visible then
    SearchPanel.Visible := false
  else begin
    SearchPanel.Visible := true;
    edSearch.SetFocus;
  end;
end;

procedure TMainFrm.edSearchExit(Sender: TObject);
begin
  SearchPanel.Visible := false;
  LdapTree.SetFocus;
  fLocatedEntry := -1;
  fLocateList.Clear;
end;

procedure TMainFrm.edSearchKeyPress(Sender: TObject; var Key: Char);

  function Parse(const Param, Val: string): string;
  var
    p, p1: PChar;
  begin
    Result := '';
    p := PChar(Param);
    while p^ <> #0 do begin
      p1 := CharNext(p);
      if (p^ = '%') and ((p1^ = 's') or (p1^ = 'S')) then
      begin
        Result := Result + Val;
        p1 := CharNext(p1);
      end
      else
        Result := Result + p^;
      p := p1;
    end;
  end;

begin
  if Key = #27 then
    LDAPTree.SetFocus
  else
  if Key = #13 then
  try
    if edSearch.Text = '' then
    begin
      Beep;
      Exit;
    end;
    if fLocatedEntry = -1 then
    begin
      Connection.Search(Parse(fQuickSearchFilter, edSearch.Text), PChar(Connection.Base), LDAP_SCOPE_SUBTREE, ['objectclass'], false, fLocateList, SearchCallback);
      fLocateList.Sort(EntrySortProc, true);
    end;
    if fLocateList.Count > 0 then
    begin
      inc(fLocatedEntry);
      if fLocatedEntry > fLocateList.Count - 1 then
        fLocatedEntry := 0;
      LocateEntry(fLocateList[fLocatedEntry].dn, true);
    end;
  finally
    Screen.Cursor := crDefault;
    RefreshStatusBar;
    Key := #0;
  end;
end;

procedure TMainFrm.edSearchChange(Sender: TObject);
begin
  fLocateList.Clear;
  fLocatedEntry := -1;
end;

procedure TMainFrm.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if (Key = #13) and not edSearch.Focused then
  begin
    ActPropertiesExecute(nil);
    Key := #0;
  end;
end;

procedure TMainFrm.NewTemplateClick(Sender: TObject);
var
  i: Integer;
begin
  with Sender as TCustomMenuItem do
  begin
    i := TemplateParser.IndexOf(TemplateName);
    if i = -1 then
      raise Exception.CreateFmt(stMenuLocateTempl, [TemplateName]);
  end;
  with TTemplateForm.Create(Self, TObjectInfo(LDAPTree.Selected.Data).dn, Connection, EM_ADD) do
  try
    AddTemplate(TemplateParser.Templates[i]);
    if ShowModal = mrOk then
      ActRefresh.Execute;
  finally
    Free;
  end;
end;

procedure TMainFrm.ActCopyDnExecute(Sender: TObject);
begin
  Clipboard.AsText := TObjectInfo(SelectedNode.Data).dn;
end;

{function GetClipboardText(Value: TLdapAttributeData): string;
begin
  if Value.DataType = dtText then
    Result := Value.AsString
  else
    Result := Base64Encode(Pointer(Value.Data)^, Value.DataSize)
end;}

procedure TMainFrm.ActCopyExecute(Sender: TObject); begin
  if ValueListView.Selected=nil then exit;
  if ValueListView.Selected.SubItems.Count=0 then ActCopyNameExecute(Sender)
  else Clipboard.SetTextBuf(pchar(ValueListView.Selected.Caption+': ' + GetValueAsText(ValueListView.Selected.Data)));
end;

procedure TMainFrm.ActCopyValueExecute(Sender: TObject); begin
  if ValueListView.Selected=nil then exit;
  if ValueListView.Selected.SubItems.Count=0 then exit;
  Clipboard.SetTextBuf(pchar(GetValueAsText(ValueListView.Selected.Data)));
end;

procedure TMainFrm.ActCopyNameExecute(Sender: TObject); begin
  if ValueListView.Selected=nil then exit;
  Clipboard.SetTextBuf(pchar(ValueListView.Selected.Caption));
end;

procedure TMainFrm.ActRenameEntryExecute(Sender: TObject);
begin
  if Assigned(LdapTree.Selected) then
    LdapTree.Selected.EditText;
end;

procedure TMainFrm.ActFindInSchemaExecute(Sender: TObject);
var
  s: string;
begin
  if ValueListView.Selected <> nil then
  begin
    s := ValueListView.Selected.Caption;
    if (ValueListView.Selected.SubItems.Count <> 0) and (AnsiCompareText(s, 'objectclass') = 0) then
      s := ValueListView.Selected.SubItems[0];
    ShowSchema.Search(s, true, false);
  end;
end;

procedure TMainFrm.TabSet1Change(Sender: TObject; NewTab: Integer; var AllowChange: Boolean);
begin
  if TabSet1.TabIndex <= 0 then exit;

  if TabSet1.TabIndex > 0 then with TConnection(fConnections[TabSet1.TabIndex-1]) do
  begin
    //Selected := TObjectInfo(LDAPTree.Selected.Data).dn;
    LVSorter.ListView := nil;
  end;

  Connection := TConnection(fConnections[TabSet1.TabIndex-1]);
  with Connection do
  begin
    ActPreferences.Visible := DirectoryType <> dtActiveDirectory;
    ActionMenu.AssignItems(mbNew);
    ActionMenu.AssignItems(pbNew);
    LVSorter.ListView := ValueListView;
    fTreeHistory.Clear;
    if SearchPanel.Visible then
      edSearchExit(nil);
    LdapTree.Items.BeginUpdate;
    LdapTree.OnChange := nil;

    try
      StatusBar.Tag := 1;
      try
        RefreshTree;
        LocateEntry(Selected, true);
      finally
        StatusBar.Tag := 0;
      end;
      LDAPTreeChange(LDAPTree, LDAPTree.Selected);
    except
      on E: Exception do
      begin
        ValueListView.Items.Clear;
        EntryListview.Items.Clear;
        MessageDlg(E.Message, mtError, [mbOk], 0);
      end;
    end;

    LdapTree.OnChange := LDAPTreeChange;
    LdapTree.Items.EndUpdate;
    InitStatusBar;
  end;
end;

procedure TMainFrm.mbGetTemplatesClick(Sender: TObject);
begin
  OpenURL('http://www.ldapadmin.org/download/templates'); { *Converted from ShellExecute* }
end;

procedure TMainFrm.UndoBtnClick(Sender: TObject);
begin
  fTreeHistory.Undo;
  fTreeHistory.Current.Selected:=true;
end;

procedure TMainFrm.RedoBtnClick(Sender: TObject);
begin
  fTreeHistory.Redo;
  fTreeHistory.Current.Selected:=true;
end;

procedure TMainFrm.ActModifySetExecute(Sender: TObject);
begin
  if LDAPTree.Selected = nil then LDAPTree.Selected := LDAPTree.TopItem;
  TSearchFrm.Create(Self, TObjectInfo(LDAPTree.Selected.Data).dn, Connection).ShowModify;
end;

procedure TMainFrm.ListPopupPopup(Sender: TObject);
var
  Value: TLdapAttributeData;
begin
  pbViewCert.Visible := false;
  pbViewPicture.Visible := false;
  if not Assigned(ValueListView.Selected) then exit;
  Value := ValueListView.Selected.Data;
  ActEditValue.Enabled := (Value.DataType = dtText) and
                          (Value.Attribute.Entry.OperationalAttributes.IndexOf(Value.Attribute.Name) = -1) and
                          (lowercase(Value.Attribute.Name) <> 'objectclass') and
                          (GetAttributeFromDn(Value.Attribute.Entry.dn) <> Value.Attribute.Name);
  ActGoto.Enabled := IsValidDn(Value.AsString);
  case Value.DataType of
    dtCert: pbViewCert.Visible := true;
    dtJpeg: pbViewPicture.Visible := true;
  end;
end;

procedure TMainFrm.pbViewCertClick(Sender: TObject);
begin
  if Assigned(LdapTree.Selected) and Assigned(ValueListView.Selected) then
    with TLdapAttributeData(ValueListView.Selected.Data) do
      ShowContext(Data, DataSize, ctxAuto);
end;

procedure TMainFrm.pbViewPictureClick(Sender: TObject);
begin
  if Assigned(LdapTree.Selected) and Assigned(ValueListView.Selected) then
    with TViewPicFrm.Create(Self, TLdapAttributeData(ValueListView.Selected.Data), smLdap) do
    begin
      OnWrite := ValueWrite;
      Show;
    end;
end;

procedure TMainFrm.ValueListViewInfoTip(Sender: TObject; Item: TListItem; var InfoTip: String);
const
  Partials: array[0..8] of string = ('time', 'expires', 'logon', 'logoff', 'last', 'created', 'modify', 'modified', 'change');
var
  n: Int64;
  c: Integer;
  s, Value: string;
  ///ST: SystemTime;

  function PartialMatch(const m: string): Boolean;
  var
    i: Integer;
  begin
    Result := false;
    for i := 0 to High(Partials) do
      if Pos(Partials[i], m) > 0 then
      begin
        Result := true;
        Break;
      end;
  end;

begin
  if TLdapAttributeData(Item.Data).DataType = dtJpeg then
  begin
    InfoTip := 'TLdapAttributeDataPtr:'+IntToStr(Integer(Item.Data));
    exit;
  end;
  InfoTip := '';
  try
    Value := Item.SubItems[0];
    if (Length(Value) >= 15) and (Uppercase(Value[Length(Value)]) = 'Z') then // Possibly GTZ
    begin
      InfoTip := DateTimeToStr(GTZToDateTime(Value));
      Exit;
    end;
    s := lowercase(Item.Caption);
    if PartialMatch(s) then        // Possibly timestamp
    begin
      Val(Value, n, c);
      if c = 0 then
      try
        InfoTip := DateTimeToStr(UnixTimeToDateTime(n));
      except
        ///FileTimeToSystemTime(Filetime(n), ST);
        ///InfoTip := DateTimeToStr(SystemTimeToDateTime(ST));
      end;
    end
    else
    if s = 'shadowexpire' then
      InfoTip := DateTimeToStr(25569 + StrToInt(Value));
  except end;
end;

procedure TMainFrm.ActEditValueExecute(Sender: TObject);
var
  Value: TLdapAttributeData;
  s: string;
begin
  if ValueListView.Selected=nil then exit;
  if ValueListView.Selected.SubItems.Count=0 then exit;
  Value := ValueListView.Selected.Data;
  s := Value.AsString;
  if InputQuery(cEditValue, cEnterNewValue, s) then
  begin
    Value.AsString := s;
    try
      Value.Attribute.Entry.Write;
    finally
      RefreshValueListView(LDAPTree.Selected);
    end;
  end;
end;

procedure TMainFrm.ActAliasExecute(Sender: TObject);
begin
  with TAliasDlg.Create(Self, TObjectInfo(SelectedNode.Data).dn, Connection, EM_ADD, true) do
  begin
    OnWrite := EntryWrite;
    ShowModal;
  end;
end;

procedure TMainFrm.ActCustomizeMenuExecute(Sender: TObject);
var
  Selected: string;
begin
  if CustomizeMenu(Self, ImageList, Connection) then
  try
    LockControl(LdapTree, true);
    Connection.ActionMenu.AssignItems(mbNew);
    Connection.ActionMenu.AssignItems(pbNew);
    Selected := TObjectInfo(LDAPTree.Selected.Data).dn;
    RefreshTree;
    LocateEntry(Selected, true);
  finally
    LockControl(LdapTree, false);
  end;
end;

procedure TMainFrm.LanguageExecute(Sender: TObject);
begin

  with (Sender as TMenuItem) do
  begin
    if Tag = LanguageLoader.CurrentLanguage then exit;
    if Tag = -1 then
      LanguageLoader.Translator.RestoreForm(Self);
    LanguageLoader.CurrentLanguage := Tag;
    if Tag <> -1 then
    begin
      LanguageLoader.Translator.TranslateForm(Self);
      GlobalConfig.WriteString(rLanguage, LanguageLoader.Languages[LanguageLoader.CurrentLanguage]);
    end
    else
      GlobalConfig.WriteString(rLanguage, '');
    Checked := true;
  end;

end;

procedure TMainFrm.ActGoToExecute(Sender: TObject);
begin
  LocateEntry(TLdapAttributeData(ValueListView.Selected.Data).AsString, true);
end;

procedure TMainFrm.ActBookmarkExecute(Sender: TObject);
var
  s: string;
begin
  s := '';
  if Assigned(LDAPTree.Selected) then
    s := TObjectInfo(LDAPTree.Selected.Data).dn;
  with TBookmarkDlg.Create(Self, s, Connection) do
  try
    ShowModal;
  finally
    Free;
  end;
end;

end.

