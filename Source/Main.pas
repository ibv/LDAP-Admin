  {      LDAPAdmin - Main.pas
  *      Copyright (C) 2003-2016 Tihomir Karlovic
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
  LCLIntf, LCLType, LinLDAP, LCLTranslator, LCLVersion,
  SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, Menus, ImgList, StdCtrls, ExtCtrls, Clipbrd, ActnList,
  Config, Connection, Sorter, Posix, Samba,
  LDAPClasses,  uSchemaDlg,    Schema,
  uBetaImgLists, GraphicHint, CustomMenus,  ObjectInfo, mormot.core.base;


type
  TConnectionNode = class
  private
    FConnection: TConnection;
    FTreeView:  TTreeView;
    FRootIndex: Integer;
    FTreeHistory: TTreeHistory;
    FSelected:  RawUtf8;
    FLVSorter:  TListViewSorter;
    procedure   SetRootNode(Value: TTreeNode);
    function    GetRootNode: TTreeNode;
  public
    constructor Create(AConnection: TConnection);
    destructor  Destroy; override;
    property    Connection: TConnection read FConnection;
    property    History: TTreeHistory read FTreeHistory;
    property    Selected: RawUtf8 read FSelected write FSelected;
    property    LVSorter: TListViewSorter read FLVSorter write FLVSorter;
    property    TreeView: TTreeView read FTreeView write FTreeView;
    property    RootNode: TTreeNode read GetRootNode write SetRootNode;
  end;

  TConnectionObjArray = array of TConnectionNode;

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
    ActHelp: TAction;
    Help1: TMenuItem;
    N17: TMenuItem;
    TabControl1: TTabControl;
    ActOpenFile: TAction;
    OpenFile: TOpenDialog;
    N25: TMenuItem;
    Open1: TMenuItem;
    BookmarkBtn: TToolButton;
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
    procedure mbGetTemplatesClick(Sender: TObject);
    procedure UndoBtnClick(Sender: TObject);
    procedure RedoBtnClick(Sender: TObject);
    procedure ActModifySetExecute(Sender: TObject);
    procedure ListPopupPopup(Sender: TObject);
    procedure pbViewCertClick(Sender: TObject);
    procedure pbViewPictureClick(Sender: TObject);
    procedure ValueListViewCustomDrawItem(Sender: TCustomListView;
      Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean);
    procedure ValueListViewInfoTip(Sender: TObject; Item: TListItem;var InfoTip: RawUtf8);
    procedure ActEditValueExecute(Sender: TObject);
    procedure ActAliasExecute(Sender: TObject);
    procedure ActCustomizeMenuExecute(Sender: TObject);
    procedure ActGoToExecute(Sender: TObject);
    procedure ActBookmarkExecute(Sender: TObject);
    procedure ActHelpExecute(Sender: TObject);
    procedure TabControl1Change(Sender: TObject);
    procedure TabControl1Changing(Sender: TObject; var AllowChange: Boolean);
    procedure ActOpenFileExecute(Sender: TObject);
    procedure ValueListViewShowHint(Sender: TObject; HintInfo: PHintInfo);
  private
    Root: TTreeNode;
    fCmdLineAccount: TFakeAccount;
    fConnections: TConnectionObjArray;
    FConnection: TConnection;
    fViewSplitterPos: Integer;
    fLdapTreeWidth: Integer;
    fSearchList: TLdapEntryList;
    fLocateList: TLdapEntryList;
    fTemplateMenu: TCustomMenuItem;
    fTickCount: Cardinal;
    fIdObject: Boolean;
    fEnforceContainer: Boolean;
    fLocatedEntry: Integer;
    fQuickSearchFilter: RawUtf8;
    fTemplateProperties: Boolean;
    fTreeHistory: TTreeHistory;
    fDisabledImages: TBetaDisabledImageList;
    fCacheTreeViews: Boolean;
    procedure ShowEntryList(Visible: Boolean);
    procedure ValueWrite(Sender: TLdapAttributeData);
    procedure EntryWrite(Sender: TObject);
    procedure EntrySortProc(Entry1, Entry2: TLdapEntry; Data: pointer; out Result: Integer);
    procedure SearchCallback(Sender: TLdapEntryList; var AbortSearch: Boolean);
    procedure InitBookmarks;
    procedure InitTemplateMenu;
    procedure InitLanguageMenu;
    procedure InitStatusBar;
    procedure RefreshStatusBar;
    procedure ClassifyEntry(ObjectInfo: TObjectInfo; CNode: TTreeNode);
    procedure RefreshNode(Node: TTreeNode; Expand: Boolean);
    procedure RefreshTree;
    procedure RefreshValueListView(Node: TTreeNode);
    procedure RefreshEntryListView(Node: TTreeNode);
    procedure CopySelection(TargetSession: TLdapSession; TargetDn, TargetRdn: RawUtf8; Move: Boolean);
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
    function  GetConnection(Index: Integer): TConnection;
    function  GetConnectionCount: Integer;
  public
    //--
    function TreeSortProc(Node1, Node2: TTreeNode): Integer;
    //--

    procedure ExpandNode(Node: TTreeNode; Session: TLDAPSession; TView: TTreeView);
    procedure DoCopyMove(List: TStringList; TargetSession: TLdapSession; TargetDn, TargetRdn: RawUtf8; Move: Boolean);
    procedure DoDelete(List: TStringList);
    function  ShowSchema: TSchemaDlg;
    function  PickEntry(const ACaption: RawUtf8): RawUtf8;
    function  LocateEntry(const dn: RawUtf8; const Select: Boolean): TTreeNode;
    procedure EditProperty(AOwner: TControl; ObjectInfo: TObjectInfo);
    procedure ServerConnect(Account: TAccount);
    procedure ServerDisconnect;
    procedure ReadConfig;
    property  DisabledImages: TBetaDisabledImageList read fDisabledImages;
    property  Connections[Index: Integer]: TConnection read GetConnection;
    property  ConnectionCount: Integer read GetConnectionCount;
  end;

var
  MainFrm: TMainFrm;

implementation

{$I LdapAdmin.inc}

uses
  strutils,
  ADObjects,
  EditEntry, ConnList, Search, LdapOp, Constant, Export, Import, Prefs, Misc,
  LdapCopy, BinView, ConfigDlg, Templates, TemplateCtrl,
  Cert, PicView, About, Alias, SizeGrip, CustMenuDlg, Lang, Bookmarks, DBLoad,
  mormot.core.os, mormot.net.ldap;



  {$R *.dfm}
{ TConnectionNode }

procedure TConnectionNode.SetRootNode(Value: TTreeNode);
begin
  FRootIndex := Value.AbsoluteIndex;
end;

function TConnectionNode.GetRootNode: TTreeNode;
begin
  Result := TreeView.Items[FRootIndex];
end;

constructor TConnectionNode.Create(AConnection: TConnection);
begin
  inherited Create;
  FConnection := AConnection;
  FTreeHistory := TTreeHistory.Create;
  FLVSorter := TListViewSorter.Create;
end;

destructor TConnectionNode.Destroy;
begin
  FConnection.Free;
  FTreeHistory.Free;
  FLVSorter.Free;
  inherited;
end;
 
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


{ TMainFrm }

procedure TMainFrm.ValueWrite(Sender: TLdapAttributeData);
begin
  if TObjectInfo(LdapTree.Selected.Data).dn = Sender.Attribute.Entry.dn then
    RefreshValueListView(LdapTree.Selected);
end;

procedure TMainFrm.EntryWrite(Sender: TObject);
var
 Node: TTreeNode;
 Entry: TLdapEntry;
 tgtDn: RawUtf8;
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
    end;
    if ValueListView.Visible then
      RefreshValueListView(LDAPTree.Selected);
    if EntryListView.Visible then
      RefreshEntryListView(LDAPTree.Selected);
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

procedure TMainFrm.InitBookmarks;
begin
  BookmarkBtn.DropdownMenu := FConnection.Bookmarks.Menu;
  if Assigned(BookmarkBtn.DropdownMenu) then
    BookmarkBtn.Style := tbsDropDown
  else
    BookmarkBtn.Style := tbsButton;
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
  if Assigned(FConnection) then with FConnection do
  begin
    ActionMenu.TemplateMenu := fTemplateMenu;
    ActionMenu.AssignItems(mbNew);
    ActionMenu.AssignItems(pbNew);
  end;
end;

procedure TMainFrm.InitLanguageMenu;
var
  i: Integer;
  CurrentLanguage: RawUtf8;

  procedure AddMenuItem(const ACaption: RawUtf8; ATag: Integer; AChecked: Boolean = false);
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
        if ATag <> -1 then
        begin
          LanguageLoader.CurrentLanguage := ATag;
          LanguageLoader.Translator.TranslateForm(Self);
        end;
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

function TMainFrm.PickEntry(const ACaption: RawUtf8): RawUtf8;
var
  DirDlg: TForm;
  ddTree: TTreeView;
  ddPanel:TPanel;
  ddOkBtn: TButton;
  ddCancelBtn: TButton;
  ddRoot: TTreeNode;
begin

  DirDlg := TForm.Create(Self);
  DirDlg.Height := 400;
  DirDlg.Width := 400;

  ddTree := TTreeView.Create(DirDlg);
  ddTree.Parent := DirDlg;
  ddTree.Align := alClient;
  ddTree.Images := ImageList;
  ddTree.ReadOnly := true;
  ddTree.OnExpanding := LDAPTreeExpanding;
  ddTree.OnDeletion := LDapTreeDeletion;
  //
  ddTree.ScrollBars:=ssAutoBoth;
  ddTree.ExpandSignType:=tvestPlusminus;


  ddPanel := TPanel.Create(DirDlg);
  ddPanel.Parent := DirDlg;
  ddPanel.Align := alBottom;
  ddPanel.Height := 34;
  ddPanel.BevelOuter := bvNone;

  TSizeGrip.Create(ddPanel);

  ddOkBtn := TButton.Create(DirDlg);
  ddOkBtn.Parent := ddPanel;
  ddOkBtn.Top := 4;
  ddOkBtn.Left := ddPanel.ClientWidth div 2 - ddOkBtn.Width - 2;
  ddOkBtn.ModalResult := mrOk;
  ddOkBtn.Caption := cOK;

  ddCancelBtn := TButton.Create(DirDlg);
  ddCancelBtn.Parent := ddPanel;
  ddCancelBtn.Top := 4;
  ddCancelBtn.Left := ddOkBtn.Left + ddokBtn.Width + 4;
  ddCancelBtn.ModalResult := mrCancel;
  ddCancelBtn.Caption := cCancel;


  with DirDlg do
  try
    Caption := ACaption;
    Position := poMainFormCenter;
    ddRoot := ddTree.Items.Add(nil, FConnection.Base);
    ddRoot.Data := TObjectInfo.Create(TLdapEntry.Create(FConnection, FConnection.Base));
    ExpandNode(ddRoot, FConnection,ddTree);
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

function TMainFrm.LocateEntry(const dn: RawUtf8; const Select: Boolean): TTreeNode;
var
  sdn: RawUtf8;
  comp: TStringList;
  i: Integer;
  Parent: TTreeNode;
begin
  Parent := Root;
  Result := Parent;
  Parent.Expand(false);
  sdn := System.Copy(dn, 1, Length(dn) - Length(FConnection.Base) - 1);
  comp:=TStringList.Create;
  try
    if ldap_explode_dn(sdn, comp) then
    begin
      for i:=comp.Count-1 Downto 0 do
      begin
        Result := Parent.GetFirstChild;
        while Assigned(Result) do
        begin
          //if AnsiStrIComp(PChar(Result.Text), PChar(comp[i])) = 0 then
          if AnsiCompareText(Result.Text, DecodeLdapString(PChar(comp[i]))) = 0 then
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
    if Select then
    begin
      if Assigned(Result) then
      begin
        Result.Selected := true;
        Result.MakeVisible;
      end
      else
      begin
        Parent.Selected := true;
        Parent.MakeVisible;
      end;
    end;
  finally
    comp.free;
  end;
end;

procedure TMainFrm.ServerConnect(Account: TAccount);
var
  NewConnection: TConnection;
  ConnectionNode: TConnectionNode;
  Dummy: Boolean;
begin
  if not Assigned(Account) then exit;
  Application.ProcessMessages;
  if Account is TDBAccount then
  begin
    NewConnection := LoadDB(Self, TDBAccount(Account));
    if not Assigned(NewConnection) then  // User abort
      exit;
  end
  else
    NewConnection := TConnection.Create(Account);
  Screen.Cursor := crHourGlass;
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
    ConnectionNode := TConnectionNode.Create(NewConnection);
    if fCacheTreeViews then
      fTreeHistory := ConnectionNode.History;
    ObjArrayAdd(FConnections, ConnectionNode);
    ActionMenu.TemplateMenu := fTemplateMenu;
    ActionMenu.OnClick := NewClick;
    TabControl1.Tabs.Add(ExtractFileName(Account.Name));
    if Assigned(LdapTree.Selected) then
      TabControl1Changing(nil, Dummy);
    TabControl1.TabIndex := TabControl1.Tabs.Count - 1;
    TabControl1Change(nil);
    FConnection := NewConnection;
  except
    FreeAndNil(NewConnection);
    Screen.Cursor := crDefault;
    raise;
  end;

  LDAPTree.PopupMenu := EditPopup;

  if Length(fConnections) > 1 then Exit;

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
  idx := TabControl1.TabIndex;
  if idx >= 0 then
  begin
    FConnection.Disconnect;
    ObjArrayDelete(fConnections, idx);
    FConnection := nil;
    TabControl1.Tabs.Delete(idx);
    dec(idx);
    TabControl1.TabIndex := idx;
    { force onchange event }
    TabControl1Change(nil);
  end;
  if Length(fConnections) = 0 then
  begin
    LDAPTree.PopupMenu := nil;
    ListPopup.AutoPopup := false;
    MainFrm.Caption := cAppName;
    LDAPTree.Items.BeginUpdate;
    LDAPTree.Items.Clear;
    LDAPTree.Items.EndUpdate;
    ValueListView.Items.Clear;
    EntryListView.Items.Clear;
    if fCacheTreeViews then
      fTreeHistory := nil
    else
      fTreeHistory.Clear;
    if Visible then
      LDAPTree.SetFocus;
  end;
end;

procedure TMainFrm.InitStatusBar;
var
 s: RawUtf8;
begin
  if (FConnection <> nil) and (FConnection.Connected) then begin
    s := Format(cServer, [FConnection.Server]);
    StatusBar.Panels[1].Style := psOwnerDraw;
    StatusBar.Panels[0].Width := StatusBar.Canvas.TextWidth(s) + 16;
    StatusBar.Panels[0].Text := s;
    s := Format(cUser, [FConnection.User]);
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
  a, b, c, d: Boolean;
begin
  fCacheTreeViews := GlobalConfig.ReadBool(rTabCache, false);
  fQuickSearchFilter := GlobalConfig.ReadString(rQuickSearchFilter, sDEFQUICKSRCH);
  fLocatedEntry := -1;
  a := fIdObject;
  b := fEnforceContainer;
  c := UseTemplateImages;
  d := RawLdapStrings;
  fIdObject := GlobalConfig.ReadBool(rMwLTIdentObject, true);
  fEnforceContainer := GlobalConfig.ReadBool(rMwLTEnfContainer, true);
  RawLdapStrings := GlobalConfig.ReadBool(rEncodedLdapStrings, false);
  fTemplateProperties := GlobalConfig.ReadBool(rTemplateProperties, true);
  UseTemplateImages := GlobalConfig.ReadBool(rUseTemplateImages, false);
  if TemplateParser.ImageList <> ImageList then
    TemplateParser.ImageList := ImageList;
  if Visible then
  begin
    InitTemplateMenu;
    InitLanguageMenu;
    if Assigned(FConnection) and ((a <> fIdObject) or (b <> fEnforceContainer) or
      (c <> UseTemplateImages) or (d <> RawLdapStrings)) then
      RefreshTree;
  end;
end;

procedure TMainFrm.RefreshStatusBar;
var
  s3, s4: RawUtf8;
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
  //Application.ProcessMessages;
end;

function TMainFrm.ShowSchema: TSchemaDlg;
var
  i: Integer;
begin
  for i:=0 to Screen.FormCount-1 do begin
    if (Screen.Forms[i] is TSchemaDlg) and
       (TSchemaDlg(Screen.Forms[i]).Schema.Session = FConnection) then
    begin
      Result := TSchemaDlg(Screen.Forms[i]);
      Result.Show;
      exit;
    end;
  end;
  Result := TSchemaDlg.Create(FConnection);
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

procedure TMainFrm.ExpandNode(Node: TTreeNode; Session: TLDAPSession; TView: TTreeView);
var
  CNode: TTreeNode;
  i: Integer;
  Entry: TLDapEntry;
  ObjectInfo: TObjectInfo;
begin
  FTickCount := GetTickCount64 + 500;
  try
    Session.Search(sAnyClass, TObjectInfo(Node.Data).dn, lssSingleLevel, ['objectClass'], false, fSearchList, SearchCallback);
    for i := 0 to fSearchList.Count - 1 do
    begin
      Entry := fSearchList[i];
      ObjectInfo := TObjectInfo.Create(Entry);
      CNode := TView.Items.AddChildObject(Node, DecodeLdapString(GetRdnFromDn(Entry.dn)), ObjectInfo);
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
      ExpandNode(Node, FConnection,LDAPTree);
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
    Root := LDAPTree.Items.Add(nil, Format('%s [%s]', [FConnection.Base, FConnection.Server]));
    Root.Data := TObjectInfo.Create(TLdapEntry.Create(FConnection, FConnection.Base));
    ExpandNode(Root, FConnection,LDAPTree);
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

  procedure ShowAttrs(Attributes: LDAPClasses.TLdapAttributeList);
  var
    i, j, k: Integer;

    function DataTypeToText(const AType: TDataType): RawUtf8;
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
      for j := 0 to ValueCount - 1 do
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

          with fConnections[TabControl1.TabIndex].Connection do
            if Schema.Loaded then
              for k := 0 to Schema.ObjectClasses.Count - 1 do
              begin
                SchemaAttribute := Schema.ObjectClasses[k].Must.ByName[Attribute.Name];
                if SchemaAttribute <> nil then
                  Break;
              end;
        end;
        ListItem.Data := Attributes[i].Values[j];
      end;
  end;

begin
  if Node = nil then
    exit;
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
  s: RawUtf8;
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
  fConnections := nil;
  fSearchList := TLdapEntryList.Create(false);
  fLocateList := TLdapEntryList.Create;
  if not fCacheTreeViews then
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
  ObjArrayClear(fConnections);
  fSearchList.Free;
  fLocateList.Free;
  if not fCacheTreeViews then
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
    ExpandNode(Node, FConnection, Sender as TTReeView);
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
    if ActEntries.Checked then
    begin
      if (Sender <> nil) and (Node.Count > 0) then
      begin
        if not EntryListView.Visible then
          ShowEntryList(true);
        CanExpand := false;
        LDAPTreeExpanding(Node.TreeView, Node, CanExpand);
        RefreshEntryListView(Node);
      end
      else
      if EntryListView.Visible then
        ShowEntryList(false);
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
    // for treeview event onchange
    Node.Parent.Selected:=true;
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
  //if LdapTree.Focused then
  if LdapTree.Selected <> nil then
  begin
    SelNode := SelectedNode;
    if Assigned(SelNode) then
      List.Add(TObjectInfo(SelNode.Data).dn)
  end
  else
  begin
    SelItem := EntryListView.Selected;
    repeat
      List.Add(TObjectInfo(TTreeNode(SelItem.Data).Data).dn);
      SelItem:= EntryListView.GetNextItem(SelItem, sdAll, [lisSelected]);
    until SelItem = nil;
  end;
end;

procedure TMainFrm.CopySelection(TargetSession: TLdapSession; TargetDn, TargetRdn: RawUtf8; Move: Boolean);
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

procedure TMainFrm.DoCopyMove(List: TStringList; TargetSession: TLdapSession; TargetDn, TargetRdn: RawUtf8; Move: Boolean);
var
  Node: TTreeNode;
  dstdn, seldn: RawUtf8;
  ep: TLVCustomDrawItemEvent;
  i: Integer;

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

  if Move and (FConnection.Version >= LDAP_VERSION3) and (TargetSession = FConnection) and
     not (FConnection is TDBConnection) then
  begin
    for i := 0 to List.Count - 1 do
    begin
      FConnection.RenameEntry(List[i], TargetRdn, TargetDn);
      List.Objects[i] := LDAP_OP_SUCCESS;
    end;
  end
  else
    with TLdapOpDlg.Create(Self, FConnection) do
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
    finally
      Free;
    end;

 if Move then
   RemoveNodes(List);

  if TargetSession = FConnection then
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
  end
  else
  if not (TargetSession is TDBConnection) then
    TargetSession.Free;
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
    if ExecuteCopyDialog(Self, TObjectInfo(Node.Data).dn, cnt, Move, FConnection, TargetData) then
    begin
      Application.ProcessMessages;
      LDAPTree.SetFocus;
      CopySelection(TargetData.Connection, TargetData.Dn, TargetData.Rdn, Move);
    end;
  end;
end;

procedure TMainFrm.DoDelete(List: TStringList);
var
  msg: RawUtf8;
begin
  if List.Count > 1 then
    msg := Format(stConfirmMultiDel, [List.Count])
  else
    msg := Format(stConfirmDel, [DecodeLdapString(List[0])]);

  if MessageDlg(msg, mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  with TLdapOpDlg.Create(Self, FConnection) do
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
  newdn, pdn, temp: RawUtf8;
  i: Integer;

  function ConfirmRename: Boolean;
  var
    cbx: Boolean;
  begin
    Result := true;
    cbx := not GlobalConfig.ReadBool(rRenamePrompt, true);
    if cbx then
      exit;
    temp := Node.Text;
    Node.Text := S;
    if CheckedMessageDlg(Format(stRenameEntry, [S]), mtConfirmation, [mbYes, mbNo], stDoNotShowAgain, cbx) <> mrYes then
    begin
      S := temp;
      Result := false;
    end;
    if cbx then
      GlobalConfig.WriteBool(rRenamePrompt, false);
  end;

begin
  i := Pos('=', S);
  if i = 0 then
  begin
    temp := GetAttributeFromDn(TObjectInfo(LDAPTree.Selected.Data).dn) + '=';
    newdn := temp + EncodeLdapString(S);
    S := temp + S;
  end
  else
    newdn := Copy(S, 1, i - 1) + '=' + EncodeLdapString(Copy(S, i + 1, Length(S) - i));
  pdn := GetDirFromDn(TObjectInfo(LDAPTree.Selected.Data).dn);

  if not ConfirmRename then
    exit;

  if not (FConnection is TDBConnection) and (FConnection.Version >= LDAP_VERSION3) then
    FConnection.RenameEntry(TObjectInfo(LDAPTree.Selected.Data).dn, newdn, pdn)
  else
    with TLdapOpDlg.Create(Self, FConnection) do
    try
      CopyTree(TObjectInfo(LDAPTree.Selected.Data).dn, pdn, newdn, true);
    finally
      Free;
    end;

  TObjectInfo(LDAPTree.Selected.Data).Free;
  LdapTree.Selected.Data := TObjectInfo.Create(TLdapEntry.Create(FConnection, newdn + ',' + pdn));
  ActRefreshExecute(nil);
end;


{
http://forum.lazarus.freepascal.org/index.php?topic=30263.0

For correct Drag&Drop function, you must make changes in the include Lazarus files
"/usr/lib64/lazarus/lcl/include/treeview.inc"
see DragDrop.info
}
procedure TMainFrm.LDAPTreeDragOver(Sender, Source: TObject; X, Y: Integer; State: TDragState; var Accept: Boolean);
var
  srcdn, dstdn: RawUtf8;
begin

  with LdapTree do
  if Assigned(DropTarget) and (DropTarget = GetNodeAt(X, Y)) and IsContainer(DropTarget) then
    dstdn := TObjectInfo(DropTarget.Data).dn
  else
  begin
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
  Move: Boolean;
begin
  if DragDropQuery(Source, LdapTree.DropTarget.Text, Move) then
  begin
    if (Source is TSearchListView)  then
      TSearchListView(Source).CopySelection(FConnection, TObjectInfo(LDAPTree.DropTarget.Data).dn, '', Move)
    else
      CopySelection(FConnection, TObjectInfo(LDAPTree.DropTarget.Data).dn, '', Move)
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

procedure TMainFrm.NewClick(Sender: TObject);
begin
  with Sender as TCustomMenuItem do
  case ActionId of
    aidTemplate: begin
                  NewTemplateClick(Sender);
                  exit;
                end;
    aidEntry:    with TEditEntryFrm.Create(Self, TObjectInfo(LDAPTree.Selected.Data).dn, FConnection, EM_ADD) do
                begin
                  OnWrite := EntryWrite;
                  {$ifndef mswindows}
                  objStringGrid.DeleteRow(1);
                  attrStringGrid.DeleteRow(1);
                  {$endif}
                  Show;
                  Exit;
                end
  else
    if not FConnection.DI.NewProperty(Self, ActionId, TObjectInfo(LDAPTree.Selected.Data).dn) then
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
  Enbl := Assigned(FConnection) and FConnection.Connected;
  ActAlias.Visible := Enbl and Assigned(FConnection.ActionMenu.GetActionItem(aidAlias));
  ActDisconnect.Enabled:= Enbl;
  ActSchema.Enabled:= Enbl and (FConnection.Version >= LDAP_VERSION3);
  ActImport.Enabled:= Enbl;
  ActRefresh.Enabled:=Enbl;
  ActSearch.Enabled:=Enbl;
  ActModifySet.Enabled:=Enbl;
  ActPreferences.Enabled:=Enbl;
  ActCustomizeMenu.Enabled := Enbl;
  ActEntries.Enabled:= Enbl;
  ActValues.Enabled:= Enbl;
  ActLocateEntry.Enabled := Enbl;
  ActBookmark.Enabled := Enbl;

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
  Enbl := Assigned(FConnection) and FConnection.Connected and Assigned(ValueListView.Selected);
  ActViewBinary.Enabled := Enbl;
  ActCopy.Enabled := Enbl;
  ActCopyValue.Enabled := Enbl;
  ActCopyName.Enabled := Enbl;
  ActFindInSchema.Enabled := Enbl;

  mbViewStyle.Enabled := EntryListView.Visible;

  UndoBtn.Enabled := Assigned(fTreeHistory) and fTreeHistory.IsUndo;
  RedoBtn.Enabled := Assigned(fTreeHistory) and fTreeHistory.IsRedo;
  //
  ActConnect.Enabled := true;
  ActExit.Enabled := true;
end;

procedure TMainFrm.ActSchemaExecute(Sender: TObject);
begin
  ShowSchema;
end;

procedure TMainFrm.ActImportExecute(Sender: TObject);
begin
  if TImportDlg.Create(Self, FConnection).ShowModal = mrOk then
    RefreshTree;
end;

procedure TMainFrm.ActExportExecute(Sender: TObject);
var
  SelItem: TListItem;
begin
  with TExportDlg.Create(FConnection) do
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
  case FConnection.DirectoryType of
    dtPosix: TPrefDlg.Create(Self, FConnection).ShowModal;
  end;
end;

procedure TMainFrm.ActAboutExecute(Sender: TObject);
begin
  TAboutDlg.Create(Self).ShowModal;
end;

procedure TMainFrm.ActEditEntryExecute(Sender: TObject);
begin
  if SelectedNode <> nil then
    with TEditEntryFrm.Create(Self, TObjectInfo(SelectedNode.Data).dn, FConnection, EM_MODIFY) do
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
  TSearchFrm.Create(Self, TObjectInfo(LDAPTree.Selected.Data).dn, FConnection).Show;
end;

procedure TMainFrm.EditProperty(AOwner: TControl; ObjectInfo: TObjectInfo);
begin
  case ObjectInfo.ActionId of
    aidNone:
      begin
        with TTemplateForm.Create(AOwner, ObjectInfo.dn, FConnection, EM_MODIFY) do
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
        with TTemplateForm.Create(AOwner, ObjectInfo.dn, FConnection, EM_MODIFY) do
        try
          AddTemplate(ObjectInfo.Template);
          ShowModal;
        finally
          Free;
        end;
      end;
  else
    FConnection.DI.EditProperty(AOwner, FConnection.ActionMenu.GetActionId(ObjectInfo.ObjectId), ObjectInfo.dn);
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

function TMainFrm.IsActPropertiesEnable: Boolean;
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
  if FConnection.DI.ChangePassword(TObjectInfo(SelectedNode.Data).Entry) and ValueListView.Visible then
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
  if (FConnection<>nil) and (FConnection.Connected) and (FConnection.SSL or FConnection.TLS) then
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

procedure TMainFrm.ShowEntryList(Visible: Boolean);
begin
  if Visible then
  begin
    ListViewPanel.Visible := true;
    if TreeViewPanel.Align = alClient then
    begin
      TreeViewPanel.Align := alLeft;
      TreeViewPanel.Width := fLdapTreeWidth;
    end;
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

procedure TMainFrm.ActEntriesExecute(Sender: TObject);
begin
  ActEntries.Checked := not ActEntries.Checked;
  ShowEntryList(ActEntries.Checked);
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
  aproto, auser, apassword, ahost, abase: RawUtf8;
  aport, aversion, i,j:     integer;
  auth: TLdapAuthMethod;
  SessionName, StorageName: RawUtf8;
  AStorage: TConfigStorage;
begin
  InitTemplateMenu;
  InitLanguageMenu;
  GlobalConfig.CheckProtocol;
  // ComandLine params /////////////////////////////////////////////////////////
  if ParamCount <> 0 then
  begin
    aproto:='ldap';
    aport:=StrToInt(LDAP_PORT);
    auser:='';
    apassword:='';
    auth:=AUTH_SIMPLE;
    aversion:=LDAP_VERSION3;
    ParseURL(ParamStr(1), aproto, auser, apassword, ahost, abase, aport, aversion, auth);
    fCmdLineAccount := TFakeAccount.Create(nil, ahost);
    with fCmdLineAccount do
    begin
      Server := ahost;
      Port := IntToStr(aport);
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
      j := Pos('|', SessionName);
      StorageName := Copy(SessionName, 1, i - 1);
      SessionName := Copy(SessionName, i + 1, j-i-1{MaxInt});
      i := Pos('\', StorageName);
      if i>0 then
      begin
        SessionName := Copy(StorageName,i+1,MaxInt) + '\' + SessionName;
        StorageName := Copy(StorageName, 1, i - 1);
      end;
      AStorage := StorageByName(StorageName);
      if Assigned(AStorage) then
        ServerConnect(AStorage.RootFolder.Items.AccountByName(SessionName));
    end;
  end;
end;

procedure TMainFrm.ActOpenFileExecute(Sender: TObject);
var
  Account: TDBAccount;
begin
  if OpenFile.Execute then
  begin
    Account := TDBAccount.Create(nil, OpenFile.FileName);
    Account.Server := OpenFile.FileName;
    Account.FileName := OpenFile.FileName;
    ServerConnect(Account);
  end;
end;

procedure TMainFrm.ValueListViewShowHint(Sender: TObject; HintInfo: PHintInfo);
var
  item: TListItem;
  ControlPoint: TPoint;
begin
  ControlPoint := ValueListView.ScreenToClient(Mouse.CursorPos);
  item := (Sender as TListView).GetItemAt(ControlPoint.X, ControlPoint.Y);
  if Assigned(item) then
    HintInfo^.HintStr :=  TLdapAttributeData(item.Data).AsString ;
end;

procedure TMainFrm.ActOptionsExecute(Sender: TObject);
begin
  if TConfigDlg.Create(Self, FConnection).ShowModal = mrOk then
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

  function Parse(const Param, Val: RawUtf8): RawUtf8;
  var
    p, p1: PChar;
  begin
    Result := '';
    p := PChar(Param);
    while p^ <> #0 do begin
      p1 := p + 1;
      if (p^ = '%') and ((p1^ = 's') or (p1^ = 'S')) then
      begin
        Result := Result + Val;
        p1 := p1 + 1;
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
      FConnection.Search(Parse(fQuickSearchFilter, edSearch.Text), PChar(FConnection.Base), lssWholeSubtree, ['objectclass'], false, fLocateList, SearchCallback);
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
  with TTemplateForm.Create(Self, TObjectInfo(LDAPTree.Selected.Data).dn, FConnection, EM_ADD) do
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
  s: RawUtf8;
begin
  if ValueListView.Selected <> nil then
  begin
    s := ValueListView.Selected.Caption;
    if (ValueListView.Selected.SubItems.Count <> 0) and (AnsiCompareText(s, 'objectclass') = 0) then
      s := ValueListView.Selected.SubItems[0];
    ShowSchema.Search(s, true, false);
  end;
end;

procedure TMainFrm.TabControl1Change(Sender: TObject);
var
  ConnectionNode: TConnectionNode;
begin
  if TabControl1.TabIndex = -1 then exit;

  ConnectionNode := fConnections[TabControl1.TabIndex];
  FConnection := ConnectionNode.Connection;
  if fCacheTreeViews then
    fTreeHistory := ConnectionNode.History
  else
    fTreeHistory.Clear;
  ConnectionNode.LVSorter.ListView := ValueListView;
  with FConnection do
  try
    Screen.Cursor := crHourGlass;
    ActionMenu.AssignItems(mbNew);
    ActionMenu.AssignItems(pbNew);
    //LVSorter.ListView := ValueListView;
    //fTreeHistory.Clear;
    if SearchPanel.Visible then
      edSearchExit(nil);
    LdapTree.Items.BeginUpdate;
    LdapTree.OnChange := nil;
    try
      StatusBar.Tag := 1;
      try
        if fCacheTreeViews and Assigned(ConnectionNode.TreeView) then
        begin
          LDAPTree := ConnectionNode.TreeView;          
          LDAPTree.Parent := TreeViewPanel;
          Root := ConnectionNode.RootNode;
          //Root := LDAPTree.Items[ConnectionNode.FRootIndex];
        end
        else
          RefreshTree;
        if not fCacheTreeViews then
          LocateEntry(ConnectionNode.Selected, true);
      finally
        StatusBar.Tag := 0;
      end;
      LDAPTreeChange(LDAPTree, LDAPTree.Selected);
    except
      on E: ErrLDAP do
      begin
        if (E.ErrorCode = 32) and (FConnection.Base = '') then
        begin
          Root.Text := 'RootDSE';
          Root.Selected := true;
          LDAPTreeChange(LDAPTree, Root);
        end
        else begin
          ValueListView.Items.Clear;
          EntryListview.Items.Clear;
          MessageDlg(E.Message, mtError, [mbOk], 0);
        end;
      end
      else
        raise;
    end;
    LdapTree.OnChange := LDAPTreeChange;
    LdapTree.Items.EndUpdate;
    InitStatusBar;
    InitBookmarks;
  finally
    Screen.Cursor := crDefault;
  end;

end;

procedure TMainFrm.TabControl1Changing(Sender: TObject; var AllowChange: Boolean);
begin
  if TabControl1.TabIndex <> -1 then with fConnections[TabControl1.TabIndex] do
  begin    
    Selected := TObjectInfo(LDAPTree.Selected.Data).dn;
    LVSorter.ListView := nil;
    if not fCacheTreeViews then
      exit;    
    { Save tree state }  
    TreeView := LDAPTree; // TODO SetTree
    RootNode := Root;
    LockControl(TreeViewPanel, true);
    try
      TreeView.Parent := nil;
      { Create new TreeView }
      LDAPTree := TTreeView.Create(Self);
      with LDAPTree do begin
        OnChange := LDAPTreeChange;
        OnContextPopup := LDAPTreeContextPopup;
        OnDblClick := LDAPTreeDblClick;
        OnDeletion := LDAPTreeDeletion;
        OnDragDrop := LDAPTreeDragDrop;
        OnDragOver := LDAPTreeDragOver;
        OnEdited := LDAPTreeEdited;
        OnEndDrag := LDAPTreeEndDrag;
        OnExpanding := LDAPTreeExpanding;
        OnStartDrag := LDAPTreeStartDrag;
        Align := alClient;
        Parent := TreeViewPanel;
        DragCursor := crDefault;
        DragMode := dmAutomatic;
        Font := TreeView.Font;
        HideSelection := False;
        Images := ImageList;
        Indent := 23;
        ParentFont := false;
        DoubleBuffered := true;
      end;
    finally
      LockControl(TreeViewPanel, false);
    end;
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
  TSearchFrm.Create(Self, TObjectInfo(LDAPTree.Selected.Data).dn, FConnection).ShowModify;
end;

procedure TMainFrm.ListPopupPopup(Sender: TObject);
var
  Value: TLdapAttributeData;

  function IsReadOnly(Attribute: LDAPClasses.TLdapAttribute): Boolean;
  const
    OID_STRUCTIRAL_OBJECTCLASS = '2.5.21.9';
  begin
    if FConnection.Schema.Loaded then with FConnection.Schema.Attributes.ByName[Attribute.Name] do
      Result := NoUserModification or (Oid = OID_STRUCTIRAL_OBJECTCLASS)
    else
      Result := Attribute.Entry.OperationalAttributes.IndexOf(Value.Attribute.Name) <> -1;
  end;
  
begin
  pbViewCert.Visible := false;
  pbViewPicture.Visible := false;
  if not Assigned(ValueListView.Selected) then exit;
  Value := ValueListView.Selected.Data;
  ///ActEditValue.Enabled := (Value.DataType = dtText) and
  ///			  (Value.Attribute.Entry.OperationalAttributes.IndexOf(Value.Attribute.Name) = -1) and
  ActEditValue.Enabled := (Value.DataType = dtText) and not IsReadOnly(Value.Attribute) and
			  
                          (lowercase(Value.Attribute.Name) <> 'objectclass') and
                          (GetAttributeFromDn(Value.Attribute.Entry.dn) <> Value.Attribute.Name);
  ActGoto.Enabled := (Value.DataType = dtText) and IsValidDn(Value.AsString);
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

procedure TMainFrm.ValueListViewCustomDrawItem(Sender: TCustomListView;
  Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean);
var
  AttributeData: TLdapAttributeData;
  SubItem: Integer;
  Content: RawUtf8;
  mRect: TRect;
begin
  DefaultDraw := False;
  Sender.Canvas.Font.Style := [];
  Sender.Canvas.Font.Color := clWindowText;

  AttributeData := TLdapAttributeData(Item.Data);
  with AttributeData do
  begin
    if lowercase(Attribute.Name) = 'objectclass' then
    begin
      Sender.Canvas.Font.Style := [fsBold];
      Sender.Canvas.Font.Color := clNavy;
    end
    else
    if Attribute.Entry.OperationalAttributes.AttributeOf(Item.Caption) = Attribute then
      Sender.Canvas.Font.Color := clDkGray
    else if (TabControl1.TabIndex <> -1) and (SchemaAttribute <> nil) then
      Sender.Canvas.Font.Style := [fsBold];

    for SubItem := 0 to item.SubItems.Count do
    begin
      if SubItem = 0 then
      begin
         Content := item.Caption;
         mRect := item.DisplayRect(drLabel);
      end else
      begin
        Content := item.SubItems[SubItem - 1];
        mRect := item.DisplayRectSubItem(SubItem, drLabel);
      end;

      if State * [cdsFocused] <> [] then
      begin
        sender.Canvas.Brush.Color := clHighlight;
        sender.Canvas.Font.Color := clHighlightText;
      end;
      Sender.Canvas.FillRect(mRect);
      Sender.Canvas.TextRect(mRect, mRect.Left + 2, mRect.Top, Content);
    end;
  end;
end;

procedure TMainFrm.ValueListViewInfoTip(Sender: TObject; Item: TListItem; var InfoTip: RawUtf8);
const
  Partials: array[0..8] of RawUtf8 = ('time', 'expires', 'logon', 'logoff', 'last', 'created', 'modify', 'modified', 'change');
var
  n: Int64;
  c: Integer;
  s, Value: RawUtf8;
  ///ST: SystemTime;

  function PartialMatch(const m: RawUtf8): Boolean;
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
  // TODO: extend GetDataType to include directory specific detection by using
  // descendants of TLdapAttributeData in TLdapAttributeList.Add: DI.GetClassType.Create(AName, Self)
  // Rewrite AsString of the ClassType accordingly
  if TLdapAttributeData(Item.Data).DataType = dtJpeg then
  begin
    InfoTip := 'TLdapAttributeDataPtr:'+IntToStr(Integer(Item.Data));
    exit;
  end;
  InfoTip := '';
  try
    Value := Item.SubItems[0];
    s := lowercase(Item.Caption);
    if PosEx(s, 'guid') <> 0 then
    begin
      InfoTip := GuidToString(PGUID(TLdapAttributeData(Item.Data).Data)^);
      exit;
    end;
    if FConnection.DirectoryType = dtActiveDirectory then
    begin
      if s = 'objectsid' then
      begin
        InfoTip := SidToText(PSid(TLdapAttributeData(Item.Data).Data));
        exit;
      end;
      if s ='useraccountcontrol' then
      begin
        InfoTip := GetUacString(TLdapAttributeData(Item.Data).AsString);
        exit;
      end;
    end;
    if PartialMatch(s) then        // Possibly timestamp
    begin
      if Length(Value) >= 10 then  // try GTZ
      try
        InfoTip := DateTimeToStr(GTZToDateTime(Value));
        exit;
      except end;
      Val(Value, n, c);
      if c = 0 then
      try
        if FConnection.DirectoryType = dtActiveDirectory then
          ///InfoTip := DateTimeToStr(WinApiTimeToDateTime(TFileTime(n)))
        else
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
  s: String;
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
  with TAliasDlg.Create(Self, TObjectInfo(SelectedNode.Data).dn, FConnection, EM_ADD, true) do
  begin
    OnWrite := EntryWrite;
    ShowModal;
  end;
end;

procedure TMainFrm.ActCustomizeMenuExecute(Sender: TObject);
var
  Selected: RawUtf8;
begin
  if CustomizeMenu(Self, ImageList, FConnection) then
  try
    LockControl(LdapTree, true);
    FConnection.ActionMenu.AssignItems(mbNew);
    FConnection.ActionMenu.AssignItems(pbNew);
    Selected := TObjectInfo(LDAPTree.Selected.Data).dn;
    RefreshTree;
    LocateEntry(Selected, true);
  finally
    LockControl(LdapTree, false);
  end;
end;

procedure TMainFrm.LanguageExecute(Sender: TObject);
begin
  with (Sender as TMenuItem) do begin
    if Tag = LanguageLoader.CurrentLanguage then exit;
    if LanguageLoader.CurrentLanguage <> -1 then // Always restore first, new file may not cover all strings
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
  s: RawUtf8;
begin
  s := '';
  if Assigned(LDAPTree.Selected) then
    s := TObjectInfo(LDAPTree.Selected.Data).dn;
  with TBookmarkDlg.Create(Self, FConnection.Bookmarks) do
  try
    ShowModal;
  finally
    Free;
  end;
end;

procedure TMainFrm.ActHelpExecute(Sender: TObject);
begin
  OpenURL(PChar('http://www.ldapadmin.org/docs/index.html'));{ *Převedeno z ShellExecute* }
end;

function  TMainFrm.GetConnection(Index: Integer): TConnection;
begin
  Result := fConnections[Index].Connection;
end;

function  TMainFrm.GetConnectionCount: Integer;
begin
  Result := Length(fConnections);
end;

end.

