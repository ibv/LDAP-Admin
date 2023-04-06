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
  Windows,System.Actions,ToolWin,System.Contnrs
{$ELSE}
  LCLIntf, LCLType,Contnrs, Messages,
{$ENDIF}
  SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, StdCtrls, Menus, ImgList, ExtCtrls, Buttons, Config,
  ActnList, DlgWrap;

type
  TPrepareMode = (pmExport, pmImport);
  TCopyAction  = (caNone, caAsk, caAskOnce, caOverwrite, caMerge, caRename, caAbort);

  { TConnListFrm }

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
    ActDeleteStorage: TAction;
    Label1: TLabel;
    ActExport: TAction;
    pbAVExport: TMenuItem;
    N2: TMenuItem;
    ActImport: TAction;
    pbAVImport: TMenuItem;
    TreeView: TTreeView;
    TreeMenu: TPopupMenu;
    ActNewFolder: TAction;
    pbNewFolder: TMenuItem;
    pbRenameFolder: TMenuItem;
    pbDeleteStorage: TMenuItem;
    ActRenameFolder: TAction;
    ActDeleteFolder: TAction;
    pbDeleteFolder: TMenuItem;
    ToolButton3: TToolButton;
    ToolButton9: TToolButton;
    ToolButton10: TToolButton;
    tbImport: TToolButton;
    tbExport: TToolButton;
    StateImages: TImageList;
    N3: TMenuItem;
    pbTVExport: TMenuItem;
    pbTVImport: TMenuItem;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ListViewEditing(Sender: TObject; Item: TListItem;
      var AllowEdit: Boolean);
    procedure ViewStyleChange(Sender: TObject);
    procedure ViewBtnClick(Sender: TObject);
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
    procedure ActDeleteStorageExecute(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure ActImportExecute(Sender: TObject);
    procedure TreeViewChange(Sender: TObject; Node: TTreeNode);
    procedure ActDeleteFolderExecute(Sender: TObject);
    procedure ActNewFolderExecute(Sender: TObject);
    procedure ActRenameFolderExecute(Sender: TObject);
    procedure TreeViewEditing(Sender: TObject; Node: TTreeNode;
      var AllowEdit: Boolean);
    procedure TreeViewEdited(Sender: TObject; Node: TTreeNode; var S: string);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure TreeViewDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure TreeViewDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure AccountsViewStartDrag(Sender: TObject;
      var DragObject: TDragObject);
    procedure AccountsViewSelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure TreeViewContextPopup(Sender: TObject; MousePos: TPoint;
      var Handled: Boolean);
    procedure ActExportExecute(Sender: TObject);
  private
    FStorage: TConfigStorage;
    SaveDialog: TSaveDialogWrapper;
    FImageOffset: Integer;
    FFolderAction: TCopyAction;
    FAccountAction: TCopyAction;
    procedure CopyAccount(ToFolder: TAccountFolder; Name: string; Src: TAccount; Move: Boolean);
    procedure CopyFolder(SourceFolder, DestFolder: TAccountFolder; Move: Boolean);
    function  GetSelection(AStorages: TConfigStorageObjArray; TargetFolder: TAccountFolder; Items: TObjectList; PrepareMode: TPrepareMode; var IncludePasswords: Boolean): Boolean;
    function  GetExportSelection(AStorages: TConfigStorageObjArray; Items: TObjectList; var IncludePasswords: Boolean): Boolean;
    function  ImportSelection(AStorages: TConfigStorageObjArray; TargetFolder: TAccountFolder): Boolean;
    function  GetSelPath(TreeView: TTreeView): string;
    procedure SetSelPath(TreeView: TTreeView; APath: string);
    procedure SetViewStyle(Style: integer);
    procedure RefreshAccountsView;
    procedure RefreshStorageTree(AStorages: TConfigStorageObjArray; TreeView: TTreeView; ImageOffset: Integer; SelectedPath: string);
    function  GetAccount: TAccount;
    procedure GetAccountSelection(AList: TObjectList);
    function  GetCurrentFolder: TAccountFolder;
    procedure Export(Elements: TObjectList; WithPasswords: Boolean); overload;
    procedure Export(AFolder: TAccountFolder); overload;
    procedure Import(AFileName: string);
  public
    constructor Create(AOwner: TComponent); reintroduce;
    property    Account: TAccount read GetAccount;
  end;

  TPrepareDialog = class(TForm)
  protected
    procedure WMWindowPosChanged(var AMessage: TMessage); message WM_WINDOWPOSCHANGED;
    procedure WMActivateApp(var AMessage: TMessage); message WM_ACTIVATE;
  private
    FExporting: Boolean;
    ///FBalloonHint: TBalloonHint;
    procedure CbxPasswordsClick(Sender: TObject);
    procedure CbxTreeClick(Sender: TObject);
    procedure CbxTreeKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  end;

implementation

{$R *.dfm}
{$I LdapAdmin.inc}

uses ConnProp, Constant, Math, uAccountCopyDlg, SizeGrip, Input, Misc, Connection,
  mormot.core.base
     {$IFDEF VER_XEH}, System.Types, System.UITypes{$ENDIF};

const
  CONF_ACCLV_STYLE = 'ConList\ViewStyle';
  CONF_TREE_WIDTH  = 'ConList\TreeWidth';
  CONF_TREE_PATH   = 'ConList\SelPath';
  CONF_FORM_WIDTH  = 'ConList\Width';
  CONF_FORM_HEIGHT = 'ConList\Height';

  { Images }

  oiOffsetSmallImages    = 2;
  oiOffsetLargeImages    = 0;

  imNewAccount           = 0;
  imComputer             = 1;
  imFolderOpen           = 3;

{ TNodeHelper }

const
  cbiUnChecked = 1;
  cbiChecked   = 2;

type
  TNodeHelper = class helper for TTreeNode
  private
    function GetChecked: Boolean;
    procedure SetChecked(Value: Boolean);
  public
    procedure ToggleCheckBox;
    procedure SetPath(Value: Boolean);
    property  Checked: Boolean read GetChecked write SetChecked;
  end;


function TNodeHelper.GetChecked: Boolean;
begin
  Result := StateIndex = cbiChecked;
end;

procedure TNodeHelper.SetChecked(Value: Boolean);
begin
  if Value then
    StateIndex := cbiChecked
  else
    StateIndex := cbiUnChecked
end;

procedure TNodeHelper.ToggleCheckBox;

  procedure SetAll(Node: TTreeNode; Value: Boolean);
  var
    Parent: TTreeNode;
  begin
    Node.Checked := Value;
    Parent := Node;
    Node := Parent.getFirstChild;
    while Assigned(Node) do
    begin
      SetAll(Node, Value);
      Node := Node.GetNextSibling;
    end;
  end;

begin
  if Assigned(Self) then
  try
    TTreeView(Self.TreeView).Items.BeginUpdate;
    if StateIndex = cbiUnchecked then
      StateIndex := cbiChecked
    else
      StateIndex := cbiUnChecked;
    SetAll(Self, Checked);
  finally
    TTreeView(Self.TreeView).Items.EndUpdate;
  end;
end;

procedure TNodeHelper.SetPath(Value: Boolean);
var
  Node: TTreeNode;
begin
  if Assigned(Self) then
  try
    TTreeView(Self.TreeView).Items.BeginUpdate;
    Node := Self.Parent;
    while Assigned(Node) do begin
      Node.Checked := Value;
      Node := Node.Parent;
    end;
  finally
    TTreeView(Self.TreeView).Items.EndUpdate;
  end;
end;

function InitialFolderAction(Elements: TObjectList): TCopyAction; overload;
var
  i, c: Integer;
begin
  c := 0;
  for i := 0 to Elements.Count - 1 do
    if Elements[i] is TAccountFolder then
    begin
      inc(c);
      if c > 1 then
      begin
        Result := caAskOnce;
        exit;
      end;
    end;
    Result := caAsk;
end;

function InitialFolderAction(TreeView: TTreeView): TCopyAction; inline; overload;
begin
  Result := caAsk;
  if TreeView.Items.Count > 1 then
    Result := caAskOnce;
end;


function GetUniqueName(AFolder: TAccountFolder; AName: string; Enum: TEnumObjects): string;
const
  NAME_PATTERN='%s [%d]';
var
  i: Integer;
begin
  i := 2;
  Result := AName;
  with AFolder do
    while Items.ByName(Result, Enum) <> nil do
    begin
      Result := Format(NAME_PATTERN, [AName, i]);
      inc(i);
    end;
end;

{ Tests if there is an existing object with the same name and queries the action.
  If rename action is chosen a unique name in AName variable is returned. If a
  default action is chosen the DefaultAction variable is set accordingly. }

function CheckName(var AName: string; AFolder: TAccountFolder; Enum: TEnumObjects;
                   var AConfig: TConfig; var DefaultAction: TCopyAction): TCopyAction; overload;
var
  cb, Message: string;
  Res: TModalResult;
  c: Boolean;
begin
  Result := DefaultAction;
  if Result <> caRename then
    AConfig := AFolder.Items.ByName(AName, Enum);
  if (Result = caAsk) or (Result = caAskOnce) then
  begin
    Res := mrOk;
    c := false;
    if Assigned(AConfig) then
    begin
      case Enum of
        eoAccounts: begin
                      Message := stAccntExist + ' ' + stOverwriteOrRename;
                      cb := cOverwrite;
                    end;
        eoFolders:  begin
                      Message := stFolderMerge;
                      cb := cMerge;
                    end;
      else
        Assert(false);
      end;
      if Result = caAsk then
        Res := MessageDlgEx(Format(Message, [AName]), mtConfirmation, [mbYes, mbNo, mbCancel], [cb, cRename], [])
      else
        Res := CheckedMessageDlgEx(Format(Message, [AName]), mtConfirmation, [mbYes, mbNo, mbCancel], [cb, cRename], [], stRepeatCopyAction, c);
    end;

    case Res of
      mrOk:  Result := caNone;
      mrYes: case Enum of
               eoAccounts: Result := caOverwrite;
               eoFolders:  Result := caMerge;
             else
               Assert(false);
             end;
      mrNo:  Result := caRename;
    else
      Result := caAbort;
      c := true;
    end;
  end;

  if Result = caRename then
  begin
    AName := GetUniqueName(AFolder, AName, Enum);
    AConfig := nil;
  end;

  if c then
    DefaultAction := Result;
end;

function CheckName(var AName: string; AFolder: TAccountFolder; Enum: TEnumObjects; var AConfig: TConfig): TCopyAction; overload;
var
  Action: TCopyAction;
begin
  Action := caAsk;
  Result := CheckName(AName, AFolder, Enum, AConfig, Action);
end;

{ TBaloonedForm }

procedure TPrepareDialog.WMActivateApp(var AMessage: TMessage);
begin
  ///if Assigned(FBalloonHint) then
  ///  FBalloonHint.HideHint;
  inherited;
end;
procedure TPrepareDialog.WMWindowPosChanged(var AMessage: TMessage);
begin
  ///if Assigned(FBalloonHint) then
  ///  FBalloonHint.HideHint;
  inherited;
end;

procedure TPrepareDialog.CbxPasswordsClick(Sender: TObject);
var
  R: TRect;
begin
  ///
  {
  if not Assigned(FBalloonHint) then
  begin
    FBalloonHint := TBalloonHint.Create(Self);
    FBalloonHint.HideAfter := 5000;
    FBalloonHint.Delay := 0;
    FBalloonHint.Description := stPwdNotEncrypted;
  end;
  }
  with (Sender as TCheckBox) do begin
    if Checked then
    begin
      R := BoundsRect;
      ///R.Width := Height;
      R.TopLeft := Parent.ClientToScreen(R.TopLeft);
      R.BottomRight := Parent.ClientToScreen(R.BottomRight);
    end;
    ///FBalloonHint.ShowHint(R);
  end;
end;

procedure TPrepareDialog.CbxTreeClick(Sender: TObject);
var
  P:TPoint;
begin
  GetCursorPos(P);
  with Sender as TTreeView do
  begin
    P := ScreenToClient(P);
    if (htOnStateIcon in GetHitTestInfoAt(P.X,P.Y)) then
    begin
      Items.BeginUpdate;
      with Selected do begin
        ToggleCheckBox;
        if FExporting and Checked then
          SetPath(true);
      end;
      Items.EndUpdate;
    end;
  end;
end;

procedure TPrepareDialog.CbxTreeKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  with Sender as TTreeView do
    if (Key = VK_SPACE) and Assigned(Selected) then
      Selected.ToggleCheckBox;
end;


{ TConnListFrm }

procedure TConnListFrm.CopyAccount(ToFolder: TAccountFolder; Name: string; Src: TAccount; Move: Boolean);
var
  Account: TAccount;
  Action: TCopyAction;
begin
  Action := CheckName(Name, ToFolder, eoAccounts, TConfig(Account), FAccountAction);
  if Action <> caAbort then
  begin
    if not Assigned(Account) then
      Account := ToFolder.Items.AddAccount(Name, true);
    Account.Assign(Src);
    if Move then
      ConfigGetFolder(src.Parent).Items.DeleteItem(src);
  end;
end;

procedure TConnListFrm.CopyFolder(SourceFolder, DestFolder: TAccountFolder; Move: Boolean);
var
  i: Integer;
  NewFolder: TAccountFolder;
  AName: string;
  Action: TCopyAction;
begin
  AName := SourceFolder.Name;
  Action := CheckName(AName, DestFolder, eoFolders, TConfig(NewFolder), FFolderAction);
  if Action <> caAbort then
  with SourceFolder.Items do
  begin
    if not Assigned(NewFolder) then
      NewFolder := DestFolder.Items.AddFolder(AName, true);
    for i := 0 to length(Folders) - 1 do
      CopyFolder(Folders[i], NewFolder, Move);
    for i := 0 to Length(Accounts) - 1 do
      CopyAccount(NewFolder, Accounts[i].Name, Accounts[i], false);
    if Move then
      ConfigGetFolder(SourceFolder.Parent).Items.DeleteItem(SourceFolder);
  end;
end;

function TConnListFrm.GetSelection(AStorages: TConfigStorageObjArray;
  TargetFolder: TAccountFolder; Items: TObjectList; PrepareMode: TPrepareMode;
  var IncludePasswords: Boolean): Boolean;
var
  Dlg: TPrepareDialog;
  dSrcTree, dDstTree: TTreeView;
  dPanel, LeftPanel, RightPanel: TPanel;
  dOkBtn: TButton;
  dCancelBtn: TButton;
  cbxPasswords: TCheckBox;
  SrcRootNodes, DstRootNodes: TObjectList;
  i: Integer;
  AccountAction, FolderAction: TCopyAction;

  procedure GetListItems(Node: TTreeNode);
  var
    NextNode: TTreeNode;
  begin
    if Node.Checked then
      Items.Add(Node.Data);
    NextNode := Node.GetFirstChild;
    while Assigned(NextNode) do
    begin
      GetListItems(NextNode);
      NextNode := NextNode.GetNextSibling;
    end;
  end;

  function GetFolderName(Value: TObject): string; inline;
  begin
    if Value is TConfigStorage then
      Result := TConfigStorage(Value).Name
    else
      Result := (Value as TAccountFolder).Name;
  end;

  procedure GetTreeItems(Node: TTreeNode; TargetFolder: TAccountFolder);
  var
    NextNode: TTreeNode;
    Cfg: TConfig;

    function AddAccount(AName: string): TAccount;
    var
      Action: TCopyAction;
    begin
      Action := CheckName(AName, TargetFolder, eoAccounts, TConfig(Result), AccountAction);
      if Action = caAbort then
        Abort;
      if not Assigned(Result) then
        Result := TArgetFolder.Items.AddAccount(AName);
    end;

    function AddFolder(AName: string): TAccountFolder;
    var
      Action: TCopyAction;
    begin
      Action := CheckName(AName, TargetFolder, eoFolders, TConfig(Result), FolderAction);
      if Action = caAbort then
        Abort;
      if not Assigned(Result) then
        Result := TargetFolder.Items.AddFolder(AName);
    end;

  begin
    if Node.Checked then
    begin
      Cfg := TAccount(Node.Data);
      if Cfg is TAccount then
        AddAccount(Cfg.Name).Assign(TAccount(Cfg))
      else
        TargetFolder := AddFolder(GetFolderName(Cfg));
    end;

    NextNode := Node.GetFirstChild;
    while Assigned(NextNode) do
    begin
      GetTreeItems(NextNode, TargetFolder);
      NextNode := NextNode.GetNextSibling;
    end;
  end;

  procedure AddAccounts(tv: TTreeView; out RootNodes: TObjectList);
  var
    i: Integer;

    procedure AddChildren(Node: TTreeNode);
    var
      i: Integer;
      Parent: TTreeNode;
    begin
        if Assigned(Node.Data) and not (TObject(Node.Data) is TAccount) then
          with ConfigGetFolder(Node.Data).Items do
          begin
            for i := 0 to Length(Accounts) - 1 do
              with tv.Items.AddChildObject(Node, Accounts[i].Name, Accounts[i]) do
              begin
                ImageIndex := imComputer;
                SelectedIndex := imComputer;
              end;
          end;

      Node.StateIndex := 2;
      Parent := Node;
      Node := Parent.getFirstChild;
      while Assigned(Node) do
      begin
        AddChildren(Node);
        Node := Node.GetNextSibling;
      end;
    end;

  begin
    { Get root nodes }
    for i := 0 to tv.Items.Count - 1 do
      if tv.Items[i].Parent = nil then
        RootNodes.Add(tv.Items[i]);
    { Traverse all root nodes }
    for i := 0 to RootNodes.Count - 1 do
      AddChildren(TTreeNode(RootNodes[i]));
  end;

begin

  Dlg := TPrepareDialog.CreateNew(Self);
  Dlg.FExporting := PrepareMode = pmExport;
  if PrepareMode = pmExport then
    Dlg.Caption := stExportAccounts
  else
    Dlg.Caption := stImportAccounts;
  Dlg.Height := 400;
  Dlg.Width := 500;

  with TPanel.Create(Dlg) do
  begin
    Align := alLeft;
    Width := 8;
    BevelOuter := bvNone;
    Parent := Dlg;
  end;

  with TPanel.Create(Dlg) do
  begin
    Align := alRight;
    Width := 8;
    BevelOuter := bvNone;
    Parent := Dlg;
  end;

  LeftPanel := TPanel.Create(Dlg);
  if PrepareMode = pmExport then
    LeftPanel.Align := alClient
  else begin
    LeftPanel.Align := alLeft;
    LeftPanel.Width := (Dlg.ClientWidth  - 16) div 2;
  end;
  LeftPanel.BevelOuter := bvNone;
  LeftPanel.Left := 8;
  LeftPanel.Parent := Dlg;

  dPanel := TPanel.Create(Dlg);
  with dPanel do begin
    Align := alTop;
    Height := 24;
    BevelOuter := bvNone;
    Parent := LeftPanel;
  end;

  with TLabel.Create(Dlg) do begin
    if PrepareMode = pmExport then
      Caption := stExportSelect
    else
      Caption := stImportSelect;
    Top := dPanel.Height - Height - 2;
    Parent := dPanel;
  end;

  dSrcTree := TTreeView.Create(Dlg);
  dSrcTree.StateImages := StateImages;
  with dSrcTree do begin
    Images := SmallImgs;
    HideSelection := false;
    ReadOnly := true;
    OnClick := Dlg.CbxTreeClick;
    OnKeyDown := Dlg.CbxTreeKeyDown;
    Align := alClient;
    Parent := LeftPanel;
    ScrollBars:=ssAutoBoth;
  end;

  dPanel := TPanel.Create(Dlg);
  dPanel.Parent := Dlg;
  dPanel.Align := alBottom;
  dPanel.Height := 40;
  dPanel.BevelOuter := bvNone;

  TSizeGrip.Create(dPanel);

  dCancelBtn := TButton.Create(Dlg);
  with dCancelBtn do begin
    Anchors := [akRight, akBottom];
    Parent := dPanel;
    Top := 8;
    Left := dPanel.Width - 8 - dCancelBtn.Width;
    ModalResult := mrCancel;
    Caption := cCancel;
    Cancel := true;
  end;

  dOkBtn := TButton.Create(Dlg);
  with dOKBtn do begin
    Anchors := [akRight, akBottom];
    Parent := dPanel;
    Top := 8;
    Left := dCancelBtn.Left - dOkBtn.Width - 8;
    ModalResult := mrOk;
    Caption := cOK;
  end;

  with Dlg do
  try
    Position := poMainFormCenter;
    SrcRootNodes := TObjectList.Create(false);
    try
      dSrcTree.Items.BeginUpdate;
      RefreshStorageTree(AStorages, dSrcTree, oiOffsetSmallImages, cRegistryCfgName);
      AddAccounts(dSrcTree, SrcRootNodes);
      dSrcTree.FullExpand;
      dSrcTree.Items[0].MakeVisible;
      dSrcTree.Items.EndUpdate;

      if PrepareMode = pmImport then
      begin
        with TSplitter.Create(Dlg) do
        begin
          Left := dSrcTree.Width + 1;
          Align := alLeft;
          Parent := Dlg;
        end;

        RightPanel := TPanel.Create(Dlg);
        RightPanel.Align := alClient;
        RightPanel.BevelOuter := bvNone;
        RightPanel.Parent := Dlg;

        dPanel := TPanel.Create(Dlg);
        with dPanel do
        begin
          Align := alTop;
          Height := 24;
          BevelOuter := bvNone;
          Parent := RightPanel;
        end;

        with TLabel.Create(Dlg) do begin
          Caption := stImportTo;
          Top := dPanel.Height - Height - 2;
          Parent := dPanel;
        end;

        dDstTree := TTreeView.Create(Dlg);
        dDstTree.StateImages := StateImages;
        with dDstTree do begin
          Align := alClient;
          HideSelection := false;
          Images := SmallImgs;
          ReadOnly := true;
          OnClick := CbxTreeClick;
          OnKeyDown := CbxTreeKeyDown;
          Parent := RightPanel;
          ScrollBars:=ssAutoBoth;
        end;

        DstRootNodes := TObjectList.Create(false);
        try
          dDstTree.Items.BeginUpdate;
          RefreshStorageTree(GlobalConfig.Storages, dDstTree, oiOffsetSmallImages, GetSelPath(TreeView));
          dDstTree.FullExpand;
          dDstTree.Items[0].MakeVisible;
          dDstTree.Items.EndUpdate;
          Result := ShowModal = mrOk;
        finally
          DstRootNodes.Free;
        end
      end
      else begin
        cbxPasswords := TCheckBox.Create(Dlg);
        with cbxPasswords do begin
          Caption := stPwdInclude;
          ShowHint := true;
          Left := 8;
          Top := (dPanel.Height - Height) div 2;
          Width := dOkBtn.Left - 16;
          Anchors := [akLeft, akTop, akRight];
          OnClick := CBXPasswordsClick;
          Parent := dPanel;
        end;
        Result := ShowModal = mrOk;
        IncludePasswords := cbxPasswords.Checked;
      end;

      if Result then
      begin
        if PrepareMode = pmImport then
        begin
          Assert(Assigned(dDstTree.Selected));
          AccountAction := caAskOnce;
          FolderAction  := caAskOnce;
          TargetFolder := ConfigGetFolder(dDstTree.Selected.Data);
          for i := 0 to SrcRootNodes.Count - 1 do
            GetTreeItems(TTreeNode(SrcRootNodes[i]), TargetFolder);
        end;
        if PrepareMode = pmExport then
        begin
          Assert(Assigned(Items));
          for i := 0 to SrcRootNodes.Count - 1 do
            GetListItems(TTreeNode(SrcRootNodes[i]));
          if PrepareMode = pmImport then
            Items.Insert(0, dDstTree.Selected.Data);
        end;
      end;
    finally
      SrcRootNodes.Free;
    end;
  finally
    dSrcTree.Free;
  end;
end;

function TConnListFrm.GetExportSelection(AStorages: TConfigStorageObjArray;
  Items: TObjectList; var IncludePasswords: Boolean): Boolean;
begin
  Result := GetSelection(AStorages, nil, Items, pmExport, IncludePasswords);
end;

function TConnListFrm.ImportSelection(AStorages: TConfigStorageObjArray;
  TargetFolder: TAccountFolder): Boolean;
var
  IncludePasswords: Boolean;
begin
  IncludePasswords := true;
  Result := GetSelection(AStorages, TargetFolder, nil, pmImport, IncludePasswords);
end;

function TConnListFrm.GetSelPath(TreeView: TTreeView): string;
var
  Node: TTreeNode;
begin
  Result := '';
  Node := TreeView.Selected;
  while Assigned(Node) do
  begin
    ///Result := Result.Insert(0, Node.Text + '\');
    Result := Node.Text + '\' + Result;
    Node := Node.Parent;
  end;
  Result := ExcludeTrailingBackslash(Result);
end;

procedure TConnListFrm.SetSelPath(TreeView: TTreeView; APath: string);
var
  i: Integer;
  Splitted: TStringList;
  Node, Parent: TTreeNode;

  function GetNextRootNode(ANode: TTreeNode): TTreeNode;
  var
    i: Integer;
  begin
    Result := nil;
    with TreeView do
      for i := ANode.AbsoluteIndex + 1 to Items.Count - 1 do
        if Items[i].Parent = nil then
        begin
          Result := Items[i];
          break;
        end;
  end;

begin
  Splitted:=TStringList.Create;
  //ExtractStrings(['/'], [], PChar(APath), Splitted);
  Splitted.Delimiter := '\';
  Splitted.DelimitedText := APath;
  //split(APath, Splitted, '/');
  if not Assigned(Splitted) then
    exit;
  Node := TreeView.Items.GetFirstNode;
  ///i := Low(Splitted);
  i := 0;
  while Assigned(Node) do
  begin
    if AnsiSameText(Node.Text, Splitted[i]) then
    begin
      Node.Selected := true;
      Node.MakeVisible;
      break;
    end;
    Node := GetNextRootNode(Node);
  end;
  if Assigned(Node) then
  begin
    ///while i < High(Splitted) do
    while i < Splitted.count-1 do
    begin
      inc(i);
      Parent := Node;
      Node := Parent.getFirstChild;
      while true do
      begin
        if not Assigned(Node) then
          exit;
        if AnsiSameText(Node.Text, Splitted[i]) then
        begin
          Node.Selected := true;
          Node.MakeVisible;
          break;
        end;
        Node := Node.GetNextSibling;
      end;
    end;
  end;
  if not Assigned(Node) then
    TreeView.Items[0].Selected := true; // Private storage
  Splitted.Free;
end;

constructor TConnListFrm.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  SaveDialog := TSaveDialogWrapper.Create(Self);
  with SaveDialog do
  begin
    Filter := CONNLIST_SAVE_FILTER;
    FilterIndex := 1;
    OverwritePrompt := true;
    DefaultExt := 'lcf';
  end;
  TSizeGrip.Create(Panel1);
  with GlobalConfig do
  begin
    Width := Min(Screen.Width, ReadInteger(CONF_FORM_WIDTH, Width));
    Height := Min(Screen.Height, ReadInteger(CONF_FORM_HEIGHT, Height));
    TreeView.Width := ReadInteger(CONF_TREE_WIDTH, TreeView.Width);
    SetViewStyle(ReadInteger(CONF_ACCLV_STYLE, 1));
    RefreshStorageTree(GlobalConfig.Storages, TreeView, FImageOffset, ReadString(CONF_TREE_PATH, cRegistryCfgName));
  end;
end;

function TConnListFrm.GetAccount: TAccount;
begin
  Result := TAccount(AccountsView.Selected.Data)
end;

procedure TConnListFrm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  with GlobalConfig do begin
    WriteInteger(CONF_FORM_WIDTH, Width);
    WriteInteger(CONF_FORM_HEIGHT, Height);
    WriteInteger(CONF_TREE_WIDTH, TreeView.Width);
    if Assigned(TreeView.Selected) then
      WriteString(CONF_TREE_PATH, GetSelPath(TreeView));
  end;
  if ModalResult <> mrOk then
    exit;
  if (AccountsView.Selected=nil) or (AccountsView.Selected.Data=nil) then
  begin
    ActNewAccountExecute(self);
    Abort;
  end;
end;

procedure TConnListFrm.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if Ord(Key) = VK_ESCAPE then
    Close;
end;

function TConnListFrm.GetCurrentFolder: TAccountFolder;
begin
  if TreeView.Selected.Data = FStorage then
    Result := FStorage.RootFolder
  else
    Result := TAccountFolder(TreeView.Selected.Data);
end;

procedure TConnListFrm.Export(Elements: TObjectList; WithPasswords: Boolean);
var
  XmlStorage: TXmlConfigStorage;
  c: TConfig;
  Account: TAccount;
  Folder: TAccountFolder;
  i, RootOffset: Integer;

begin
  if SaveDialog.Execute then
  begin
    XmlStorage := TXmlConfigStorage.Create('');
    try
      XmlStorage.FileName := SaveDialog.FileName;
      XmlStorage.Encoding := SaveDialog.Encoding;
      XmlStorage.PasswordCanSave := WithPasswords;
      Folder := XmlStorage.RootFolder;
      RootOffset := 1;
      for i := 0 to Elements.Count - 1 do
      begin
        if Elements[i] is TConfigStorage then
        begin
          RootOffset := 1 + Length(ConfigGetFolder(Elements[i]).Name);
          Continue; // skip root folder
        end
        else
        begin
          c := XmlStorage.ByPath(Copy(ExtractFileDir(TConfig(Elements[i]).Path), RootOffset), true); // Find parent
          if Assigned(c) then
            Folder := c as TAccountFolder
          else begin
            Folder := XmlStorage.RootFolder;
            RootOffset := 1 + Length(ExtractFileDir((TConfig(Elements[i]).Path)));
          end;
        end;
        if Elements[i] is TAccount then
        begin
          Account := Folder.Items.AddAccount(TAccount(Elements[i]).Name, true);
          Account.Assign(TAccount(Elements[i]));
        end
        else
          Folder.Items.AddFolder(ConfigGetFolder(Elements[i]).Name, true);
      end;
    finally
      XmlStorage.Free;
    end;
  end;
end;

procedure TConnListFrm.Export(AFolder: TAccountFolder);
var
  XmlStorage: TXmlConfigStorage;
begin
  if SaveDialog.Execute then
  begin
    XmlStorage := TXmlConfigStorage.Create('');
    try
      XmlStorage.FileName := SaveDialog.FileName;
      XmlStorage.Encoding := SaveDialog.Encoding;
      FFolderAction := caNone;
      FAccountAction := caNone;
      CopyFolder(AFolder, xmlStorage.RootFolder, false);
    finally
      XMLStorage.Free;
    end;
  end;
end;

procedure TConnListFrm.Import(AFileName: string);
var
  StorageList: TConfigStorageObjArray;
begin
  if AFileName = '' then
    exit;
  StorageList := nil;
  try
    Screen.Cursor := crHourGlass;
    ObjArrayAdd(StorageList, TXmlConfigStorage.Create(AFileName));
    if ImportSelection(StorageList, GetCurrentFolder) then
      RefreshStorageTree(GlobalConfig.Storages, TreeView, FImageOffset, GetSelPath(TreeView));
  finally
    Screen.Cursor := crDefault;
  end;
end;

procedure TConnListFrm.RefreshAccountsView;
var
  i: integer;
  SelData: pointer;
  items: TConfigList;
  folder: TAccountFolder;
begin
  AccountsView.Items.BeginUpdate;

  if (AccountsView.Selected<>nil) then
    SelData := AccountsView.Selected.Data
  else
    SelData := nil;

  AccountsView.Items.Clear;

  if Assigned(TreeView.Selected) then
  begin
    with AccountsView.Items.Add do
    begin
      Caption := cAddConn;
      Data:=nil;
      ImageIndex := imNewAccount;
    end;

    folder := GetCurrentFolder;
    if Assigned(folder) then
    begin
      items := folder.Items;
      if Assigned(items) and Assigned(items.Accounts) then
      begin
        for i := 0 to Length(items.Accounts) - 1 do
          with AccountsView.Items.Add do
          begin
            Caption := items.Accounts[i].Name;
            Data := items.Accounts[i];
            SubItems.Add(items.Accounts[i].Server);
            SubItems.Add(items.Accounts[i].Base);
            if items.Accounts[i].User = '' then
              SubItems.Add('anonymous')
            else
              SubItems.Add(items.Accounts[i].User);
            ImageIndex := imComputer;
            Selected := (Data = SelData);
          end;
      end;
    end;

  end;
  AccountsView.Items.EndUpdate;
end;

procedure TConnListFrm.RefreshStorageTree(AStorages: TConfigStorageObjArray;
  TreeView: TTreeView; ImageOffset: Integer; SelectedPath: string);
var
  i, img: Integer;
  Node: TTreeNode;

  procedure AddFolders(AStorage: TConfigStorage; ANode: TTreeNode);
  var
    i: Integer;

    procedure AddFolder(AFolder: TAccountFolder; ANode: TTreeNode);
    var
      i: Integer;
      NewNode: TTreeNode;
    begin
      NewNode := TreeView.Items.AddChildObject(ANode, AFolder.Name, AFolder);
      NewNode.ImageIndex := imFolderOpen + ImageOffset;
      NewNode.SelectedIndex := imFolderOpen + ImageOffset;
      for i := 0 to Length(AFolder.Items.Folders) - 1 do
        AddFolder(AFolder.Items.Folders[i], NewNode);
    end;

  begin
    for i := 0 to Length(AStorage.RootFolder.Items.Folders) - 1 do
      AddFolder(AStorage.RootFolder.Items.Folders[i], ANode);
  end;

begin
  TreeView.Items.BeginUpdate;
  TreeView.Items.Clear;

  for i := 0 to Length(AStorages) - 1 do
  begin
    Node := TreeView.Items.AddObject(nil, AStorages[i].Name, AStorages[i]);
    if Astorages[i] is TRegistryConfigStorage then
      img := 0
    else
      img := 1;
    Node.ImageIndex := img + ImageOffset;
    Node.SelectedIndex := img + ImageOffset;
    AddFolders(AStorages[i], Node);
  end;

  SetSelPath(TreeView, SelectedPath);
  TreeView.FullExpand;
  TreeView.Items.EndUpdate;
  Sleep(1);
  Application.ProcessMessages;
  if not Assigned(FStorage) then
    FStorage := TConfigStorage(TreeView.Items.GetFirstNode.Data);
  RefreshAccountsView;
end;

procedure TConnListFrm.AccountsViewDblClick(Sender: TObject);
begin
  if AccountsView.Selected=nil then exit;
  AccountsView.ReadOnly:=true;
  if AccountsView.Selected.Data=nil then ActNewAccountExecute(Self)
  else ModalResult := mrOk;
end;

procedure TConnListFrm.AccountsViewKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key=VK_RETURN then AccountsViewDblClick(AccountsView);
end;

procedure TConnListFrm.AccountsViewSelectItem(Sender: TObject; Item: TListItem; Selected: Boolean);
var
  SelItem: TListItem;
begin
  if AccountsView.SelCount > 1 then
  begin
    if Item.Data = nil then
    begin
      Item.Selected := false;
      exit;
    end;
    SelItem := AccountsView.Selected;
    while SelItem <> nil do begin
      if SelItem.Data = nil then
        SelItem.Selected := false;   // Unselect "New item"
      SelItem:= AccountsView.GetNextItem(SelItem, sdAll, [lisSelected]);
    end;
  end;
end;

procedure TConnListFrm.AccountsViewStartDrag(Sender: TObject; var DragObject: TDragObject);
var
  SelItem: TListItem;
  m: TPoint;
begin
  if Sender = AccountsView then
  begin
    m := AccountsView.ScreenToClient(Mouse.CursorPos);
    SelItem := AccountsView.GetItemAt(m.X, m.Y);
    if Assigned(SelItem) and (SelItem.Data = nil) then
    begin
      CancelDrag; // Do not drag 'New item'
      exit;
    end;
  end;
end;

procedure TConnListFrm.ActNewAccountExecute(Sender: TObject);
var
  Account: TAccount;
begin
  with TConnPropDlg.Create(self, GetCurrentFolder, EM_ADD) do
  begin
    PasswordEnable := FStorage.PasswordCanSave;
    if ShowModal = mrOK then
    begin
      Account := GetCurrentFolder.Items.AddAccount(Name, true);
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
      Account.DirectoryType      := DirectoryType;
    end;
    Free;
  end;
  RefreshAccountsView;
end;

procedure TConnListFrm.ActNewFolderExecute(Sender: TObject);
var
  NewFolder: TAccountFolder;
  Node: TTreeNode;
  s: string;
begin
  s := '';
  Node := TreeView.Selected;
  if Assigned(Node) and InputDlg(cCreateFolder, cFolderName , s, #0, false, '\<>') then
  begin
    s := Trim(s);
    NewFolder := GetCurrentFolder.Items.FolderByName(s);
    if Assigned(NewFolder) then
      raise Exception.CreateFmt(stFolderExists, [s]);
    NewFolder := GetCurrentFolder.Items.AddFolder(s, true);
    with TreeView.Items.AddChildObject(Node, s, NewFolder) do begin
      ImageIndex := imFolderOpen + FImageOffset;
      SelectedIndex := imFolderOpen + FImageOffset;
    end;
    Node.Expand(false);
  end;
end;

procedure TConnListFrm.ActDeleteAccountExecute(Sender: TObject);
var
  List: TObjectList;
  s: string;
  i: Integer;
begin
  if (AccountsView.Selected=nil) or (AccountsView.Selected.Data=nil) then exit;
  if FStorage = nil then
    exit;
  List := TObjectList.Create(false);
  try
    GetAccountSelection(List);
    if List.Count = 1 then
      s := format(stConfirmDelAccnt, [TAccount(AccountsView.Selected.Data).Name])
    else
      s := stDeleteSelected;
    if MessageDlg(s, mtConfirmation, mbYesNo, 0) <> mrYes then
      exit;
    with GetCurrentFolder do
      for i := 0 to List.Count - 1 do
        Items.DeleteItem(TAccount(List[i]));
    RefreshAccountsView;
  finally
    List.Free;
  end;
end;

procedure TConnListFrm.ActDeleteFolderExecute(Sender: TObject);
var
  AConfig: TConfig;
  Msg: string;
begin
  if not (TObject(TreeView.Selected.Data) is TConfig) then
    exit;
  AConfig := TConfig(TreeView.Selected.Data);
  if (AConfig is TAccountFolder) then with TAccountFolder(AConfig) do
  begin
    if ((Length(Items.Folders) > 0) or (Length(Items.Accounts) > 0)) then
      Msg := stFolderNotEmpty
    else
      Msg := stDeleteFolder;
    if MessageDlg(Format(Msg,[AConfig.Name]), mtConfirmation, mbYesNo, 0) <> mrYes then
      exit;
  end;
  GetCurrentFolder.Items.DeleteItem(AConfig);
  TreeView.Selected.Delete;
end;

procedure TConnListFrm.ActionListUpdate(Action: TBasicAction; var Handled: Boolean);
var
  E: Boolean;
begin
  E := (AccountsView.Selected <> nil) and (AccountsView.Selected.Data <> nil) and not (AccountsView.IsEditing or TreeView.IsEditing);
  OkBtn.Enabled := E;
  pbAvExport.Enabled := E;
  ActDeleteAccount.Enabled := E;
  ActRenameAccount.Enabled := E;
  ActCopyAccount.Enabled := E;
  ActPropertiesAccount.Enabled := E;

  E := (TreeView.Selected <> nil) and not TreeView.IsEditing;
  ActDeleteStorage.Enabled := E and (TObject(TreeView.Selected.Data) is TXmlConfigStorage);
  E := E and Assigned(TreeView.Selected) and (TObject(TreeView.Selected.Data) is TAccountFolder);
  ActDeleteFolder.Enabled := E;
  ActRenameFolder.Enabled :=  E;
  pbDeleteStorage.Visible := ActDeleteStorage.Enabled;
  pbDeleteFolder.Visible := E;
  pbRenameFolder.Visible :=  E;
end;

procedure TConnListFrm.ActRenameAccountExecute(Sender: TObject);
begin
  if (AccountsView.Selected=nil) or (AccountsView.Selected.Data=nil) then exit;
  AccountsView.Selected.EditCaption;
end;

procedure TConnListFrm.ActRenameFolderExecute(Sender: TObject);
begin
  TreeView.Selected.EditText;
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
  Dlg: TAccountCopyDlg;
  List: TObjectList;
  i: Integer;

  function MultiName: string;
  begin
    Result := TConfig(List[0]).Name;
    if List.Count = 2 then
      Result := Result + ', ' + TConfig(List[1]).Name
    else
      Result := Result + ',..., ' + TConfig(List[List.Count - 1]).Name;
  end;

begin
  if (AccountsView.Selected=nil) or (AccountsView.Selected.Data=nil) then exit;

  List := TObjectList.Create(false);
  try
    GetAccountSelection(List);
    Dlg := TAccountCopyDlg.Create(self);
    try
      Dlg.TargetFolder := GetCurrentFolder;
      if List.Count = 1 then
      begin
        Dlg.Caption := Format(cCopyTo, [FStorage.Name+'.'+ AccountsView.Selected.Caption]);
        Dlg.AccountName := AccountsView.Selected.Caption;
        Dlg.NameEd.SelectAll;
      end
      else begin
        Dlg.Caption := cCopySelection;
        Dlg.NameEd.Enabled := false;
        Dlg.NameEd.Font.Style := Dlg.NameEd.Font.Style + [fsItalic];
       Dlg.AccountName := MultiName;
      end;

      if Dlg.ShowModal=mrOK then
      begin
        if (List.Count = 1) and Dlg.NameEd.Modified and (List[0] is TConfig) then
        begin
          FAccountAction := caAsk;
          CopyAccount(Dlg.TargetFolder, Dlg.NameEd.Text, TAccount(List[0]), false);
        end
        else begin
          FAccountAction := caAskOnce;
          for i := 0 to List.Count - 1 do
            CopyAccount(Dlg.TargetFolder, TAccount(List[i]).Name, TAccount(List[i]), false);
        end;
        if GetCurrentFolder = Dlg.TargetFolder then
          RefreshAccountsView
        else
          AccountsView.ClearSelection;
      end;
    finally
      Dlg.Free;
    end;
  finally
    List.Free;
  end;
end;

procedure TConnListFrm.GetAccountSelection(AList: TObjectList);
var
  SelItem: TListItem;
begin
    SelItem := AccountsView.Selected;
    repeat
      AList.Add(SelItem.Data);
      SelItem:= AccountsView.GetNextItem(SelItem, sdAll, [lisSelected]);
    until SelItem = nil;
end;

procedure TConnListFrm.ActPropertiesAccountExecute(Sender: TObject);
var
  Account: TAccount;
begin
  if (AccountsView.Selected=nil) or (AccountsView.Selected.Data=nil) then exit;
  Account:=TAccount(AccountsView.Selected.Data);
  with TConnPropDlg.Create(Self, GetCurrentFolder, EM_MODIFY) do begin
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
    DirectoryType      := Account.DirectoryType;

    if ShowModal=mrOK then begin
      Account.Name               := Name;
      Account.Base               := Base;
      Account.SSL                := SSl;
      Account.TLS                := TLS;
      Account.Port               := Port;
      Account.LdapVersion        := LdapVersion;
      Account.User               := User;
      Account.Server             := Server;
      Account.Password           := Password + #0;
      Account.TimeLimit          := Timelimit;
      Account.SizeLimit          := SizeLimit;
      Account.PagedSearch        := PagedSearch;
      Account.PageSize           := PageSize;
      Account.DereferenceAliases := DereferenceAliases;
      Account.ChaseReferrals     := ChaseReferrals;
      Account.ReferralHops       := ReferralHops;
      Account.OperationalAttrs   := OperationalAttrs;
      Account.AuthMethod         := AuthMethod;
      Account.DirectoryType      := DirectoryType;
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
    for i:=1 to Length(GlobalConfig.Storages) - 1 do begin
      if (GlobalConfig.Storages[i] is TXmlConfigStorage) and
         (TXmlConfigStorage(GlobalConfig.Storages[i]).FileName=SaveDialog.FileName) then
      begin
        FStorage := GlobalConfig.Storages[i];
        RefreshAccountsView;
        exit;
      end;
    end;
    FStorage := TXmlConfigStorage.Create('');
    with TXmlConfigStorage(FStorage) do begin
      FileName := SaveDialog.FileName;
      Encoding := SaveDialog.Encoding;
    end;
    GlobalConfig.AddStorage(FStorage);
    RefreshStorageTree(GlobalConfig.Storages, TreeView, FImageOffset, GetSelPath(TreeView));
  end;
end;

procedure TConnListFrm.ActOpenStorageExecute(Sender: TObject);
var
  i: integer;
begin
  if OpenDialog.Execute then begin
    for i:=1 to Length(GlobalConfig.Storages) - 1 do begin
      if (GlobalConfig.Storages[i] is TXmlConfigStorage) and
         (TXmlConfigStorage(GlobalConfig.Storages[i]).FileName=OpenDialog.FileName) then begin
        FStorage:=GlobalConfig.Storages[i];
        RefreshAccountsView;
        exit;
      end;
    end;
    FStorage:=TXmlConfigStorage.Create(OpenDialog.FileName);
    GlobalConfig.AddStorage(FStorage);
    RefreshStorageTree(GlobalConfig.Storages, TreeView, FImageOffset, GetSelPath(TreeView));
  end;
end;

procedure TConnListFrm.ActDeleteStorageExecute(Sender: TObject);
var
  i: integer;
begin
  if FStorage is TXmlConfigStorage then
  begin
  for i := 0 to Length(GlobalConfig.Storages) - 1 do
    if GlobalConfig.Storages[i] = FStorage then begin
      GlobalConfig.DeleteStorage(i);
      break;
    end;
    TreeView.Selected.Delete;
  end;
end;

procedure TConnListFrm.ActExportExecute(Sender: TObject);
var
  Elements: TObjectList;
  IncludePasswords: Boolean;
begin
  Elements := TObjectList.Create(false);
  try
    Screen.Cursor := crHourGlass;
    with TAction(Sender).ActionComponent do
      if Name = 'pbAVExport' then // List view
      begin
        GetAccountSelection(Elements);
        Export(Elements, false);
      end
      else
      if Name = 'pbTVExport' then // Tree view
        Export(GetCurrentFolder)
      else
      if GetExportSelection(GlobalConfig.Storages, Elements, IncludePasswords) then
        Export(Elements, IncludePasswords);
  finally
    Screen.Cursor := crDefault;
    Elements.Free;
  end;
end;

procedure TConnListFrm.ActImportExecute(Sender: TObject);
begin
  if OpenDialog.Execute then
    Import(OpenDialog.FileName);
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
    0:  begin
          AccountsView.ViewStyle:=vsIcon;
          AccountsView.LargeImages:=SmallImgs;
          TreeView.Images := SmallImgs;
          TreeView.Indent := 22;
          FImageOffset := oiOffsetSmallImages;
          TreeView.Repaint;
        end;
    1:  begin
          AccountsView.ViewStyle:=vsIcon;
          AccountsView.LargeImages:=LargeImgs;
          TreeView.Images := StoragesImgs;
          TreeView.Indent := 35;
          FImageOffset := oiOffsetLargeImages;
          TreeView.Repaint;
        end;
    2:  AccountsView.ViewStyle:=vsList;
    3:  AccountsView.ViewStyle:=vsReport;
  end;
  GlobalConfig.WriteInteger(CONF_ACCLV_STYLE, Style);
end;

procedure TConnListFrm.ViewStyleChange(Sender: TObject);
begin
  SetViewStyle(TMenuItem(Sender).Tag);
  RefreshStorageTree(GlobalConfig.Storages, TreeView, FImageOffset, GetSelPath(TreeView));
end;

procedure TConnListFrm.ViewBtnClick(Sender: TObject);
var
  p: TPoint;
begin
  p:=ViewBtn.ClientToScreen(point(0,ViewBtn.Height));
  ViewStyleMenu.Popup(p.X, p.Y);
end;

procedure TConnListFrm.TreeViewChange(Sender: TObject; Node: TTreeNode);
begin
  if Node.Level = 0 then
    FStorage := TConfigStorage(Node.Data)
  else
    FStorage := (TObject(Node.Data) as TAccountFolder).Storage;
  if FStorage is TXmlConfigStorage then
    Label1.Caption := TXmlConfigStorage(FStorage).FileName
  else
    Label1.Caption := '';
  RefreshAccountsView;
end;

procedure TConnListFrm.TreeViewContextPopup(Sender: TObject; MousePos: TPoint; var Handled: Boolean);
var
  Node: TTreeNode;
begin
  Node := TreeView.GetNodeAt(MousePos.X, MousePos.Y);
  if (Node <> nil) then
    Node.Selected := true;
end;

procedure TConnListFrm.TreeViewDragDrop(Sender, Source: TObject; X, Y: Integer);
var
  List: TObjectList;
  i: Integer;
  Move: Boolean;
begin
  if DragDropQuery(Source, TreeView.DropTarget.Text, Move) then
  begin
    if Source = TreeView then
    begin
      FFolderAction := InitialFolderAction(TreeView);
      FAccountAction := caAskOnce;
      CopyFolder(ConfigGetFolder(TreeView.Selected.Data), ConfigGetFolder(TreeView.DropTarget.Data), Move);
      RefreshStorageTree(GlobalConfig.Storages, TreeView, FImageOffset, GetSelPath(TreeView));
    end
    else begin
      List := TObjectList.Create(false);
      try
        GetAccountSelection(List);
        FAccountAction := caAsk;
        if List.Count > 1 then
        FAccountAction := caAskOnce;
        for i := 0 to List.Count - 1 do
          CopyAccount(ConfigGetFolder(TreeView.DropTarget.Data), TAccount(List[i]).Name, TAccount(List[i]), Move);
        RefreshAccountsView;
      finally
        List.Free;
      end;
    end;
  end;
end;

procedure TConnListFrm.TreeViewDragOver(Sender, Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean);

  function IsChildOrParent(DestNode, SourceNode: TTreeNode): Boolean;
  begin
    if SourceNode.Parent = DestNode then
    begin
      Result := true;
      exit;
    end;
    while Assigned(DestNode) do
    begin
      if DestNode = SourceNode then
      begin
        Result := true;
        exit;
      end;
      DestNode := DestNode.Parent;
    end;
    Result := false;
  end;

begin
  if Source is TTreeView then
    Accept := Assigned(TreeView.DropTarget) and not IsChildOrParent(TreeView.DropTarget, TreeView.Selected)
  else
    Accept := Assigned(TreeView.DropTarget) and (TreeView.DropTarget <> TreeView.Selected);
end;

procedure TConnListFrm.TreeViewEdited(Sender: TObject; Node: TTreeNode; var S: string);
begin
  TAccountFolder(Node.Data).Name := s;
end;

procedure TConnListFrm.TreeViewEditing(Sender: TObject; Node: TTreeNode; var AllowEdit: Boolean);
begin
  AllowEdit := Node.Level > 0;
end;

procedure TConnListFrm.FormResize(Sender: TObject);
begin
  RefreshAccountsView;
end;

end.
