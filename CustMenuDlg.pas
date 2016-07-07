  {      LDAPAdmin - CustMenuDlg.pas
  *      Copyright (C) 2013 Tihomir Karlovic
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

unit CustMenuDlg;

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
  ComCtrls, Menus, ImgList, ActnList, ExtCtrls, StdCtrls, CustomMenus,
  ToolWin, Connection;

const
  CB_ICON_INDENT =  4;
  CB_TEXT_INDENT = 10;

  oiDisabled     =  0;
  oiTemplate     =  1;

  SCKeys: array[0..9, 0..1] of Byte = (($08,$08),
                                       ($09,$09),
                                       ($0D,$0D),
                                       ($1B,$1B),
                                       ($20,$28),
                                       ($2D,$2E),
                                       ($30,$39),
                                       ($41,$5A),
                                       ($60,$69),
                                       ($70,$7B));


type
  TCustomMenuDlg = class(TForm)
    MainMenu: TMainMenu;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    btnCancel: TButton;
    btnOK: TButton;
    mbTest: TMenuItem;
    PopupMenu: TPopupMenu;
    mbAddItem: TMenuItem;
    mbAddSubmenu: TMenuItem;
    mbDelete: TMenuItem;
    mbAddSeparator: TMenuItem;
    ScrollTimer: TTimer;
    Panel6: TPanel;
    Panel1: TPanel;
    TreeView: TTreeView;
    Panel5: TPanel;
    Panel8: TPanel;
    Label1: TLabel;
    edCaption: TEdit;
    GroupBox1: TGroupBox;
    rbDisabled: TRadioButton;
    rbDefaultAction: TRadioButton;
    rbTemplate: TRadioButton;
    cbTemplate: TComboBox;
    cbDefaultAction: TComboBox;
    ComboText: TStaticText;
    GroupBox2: TGroupBox;
    cbShortcutKey: TComboBox;
    cbCtrl: TCheckBox;
    cbShift: TCheckBox;
    cbAlt: TCheckBox;
    procedure TreeViewChange(Sender: TObject; Node: TTreeNode);
    procedure rbClick(Sender: TObject);
    procedure edCaptionChange(Sender: TObject);
    procedure TreeViewContextPopup(Sender: TObject; MousePos: TPoint;
      var Handled: Boolean);
    procedure PopupMenuPopup(Sender: TObject);
    procedure mbAddItemClick(Sender: TObject);
    procedure mbAddSubmenuClick(Sender: TObject);
    procedure mbAddSeparatorClick(Sender: TObject);
    procedure mbDeleteClick(Sender: TObject);
    procedure TreeViewDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure TreeViewStartDrag(Sender: TObject;
      var DragObject: TDragObject);
    procedure ScrollTimerTimer(Sender: TObject);
    procedure TreeViewEndDrag(Sender, Target: TObject; X, Y: Integer);
    procedure TreeViewDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure cbDefaultActionDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure cbDefaultActionChange(Sender: TObject);
    procedure cbTemplateDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure cbTemplateChange(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure TreeViewChanging(Sender: TObject; Node: TTreeNode;
      var AllowChange: Boolean);
    procedure ComboTextMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure TreeViewCustomDrawItem(Sender: TCustomTreeView;
      Node: TTreeNode; State: TCustomDrawState; var DefaultDraw: Boolean);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
    fImageList: TImageList;
    fActMenu: TCustomActionMenu;
    procedure ActionItemToTreeView(ActionItem: TCustomActionItem; TreeView: TTreeview);
    procedure AddItem(const ActionIndex: Integer; const Caption: string);
    procedure SetNodeIcon(Node: TTreeNode; Item: TCustomActionItem);
    procedure SetOverlayImage(node: TTreeNode; const OverlayIndex: Integer);
    function  ValidateInput: Boolean;
  public
    constructor Create(AOwner: TComponent; AImageList: TImageList; AActionMenu: TCustomActionMenu); reintroduce;
    destructor  Destroy; override;
    procedure AlignMenu;
  end;

function CustomizeMenu(AOwner: TComponent; AImageList: TImageList; Connection: TConnection): Boolean;

implementation

{$I LdapAdmin.inc}

uses Templates, Misc, SizeGrip, Constant{$IFDEF VER_XEH}, System.UITypes{$ENDIF};

{$R *.dfm}

function CustomizeMenu(AOwner: TComponent; AImageList: TImageList; Connection: TConnection): Boolean;
var
  dlg: TCustomMenuDlg;
begin
  Result := false;
  dlg := TCustomMenuDlg.Create(AOwner, AImageList, Connection.ActionMenu);
  if dlg.ShowModal = mrOk then
  begin
    dlg.fActMenu.Clone(Connection.ActionMenu);
    dlg.fActMenu.Save;
    Result := true;
  end;
  dlg.Free;
end;

procedure TCustomMenuDlg.ActionItemToTreeView(ActionItem: TCustomActionItem; TreeView: TTreeview);

  procedure AddItem(anItem: TCustomActionItem; aParentNode: TTreenode);
  var
    node: TTreenode;
    i: Integer;
  begin
    node:= TreeView.Items.AddChildObject(aParentNode, anItem.Caption, anItem);
    SetNodeIcon(node, anItem);
    for i:= 0 to anItem.Count - 1 do
      AddItem(anItem.Items[i], node);
  end;

begin
  TreeView.Items.BeginUpdate;
  try
    TreeView.Items.Clear;
    if Assigned(ActionItem) then
      AddItem(ActionItem, nil);
    TreeView.FullExpand;
  finally
    TreeView.Items.EndUpdate;
  end;
end;

procedure TCustomMenuDlg.AddItem(const ActionIndex: Integer; const Caption: string);
var
  ParentItem, NewItem: TCustomActionItem;
  Node: TTreeNode;
begin
  ParentItem := TCustomActionItem(TreeView.Selected.Data);
  NewItem := TCustomActionItem.Create(ParentItem);
  NewItem.ActionId := ActionIndex;
  NewItem.Caption := Caption;
  Node := TreeView.Items.AddChildObject(TreeView.Selected, '', NewItem);
  SetNodeIcon(Node, NewItem);
  Node.Text := NewItem.Caption;
  Node.Selected := true;
end;

procedure TCustomMenuDlg.SetNodeIcon(Node: TTreeNode; Item: TCustomActionItem);
begin

  if Item.ActionId = aidNodeItem then
  begin
    Node.ImageIndex := bmClassSchema;
    Node.SelectedIndex := bmClassSchema;
  end
  else begin
    Node.ImageIndex := Item.ImageIndex;
    Node.SelectedIndex := Item.ImageIndex;

    Node.OverlayIndex := -1;
    if Item.Enabled then
    begin
      if Item.ActionId = aidTemplate then
        SetOverlayImage(Node, oiTemplate)
    end
    else
      SetOverlayImage(Node, oiDisabled);
  end;
end;

procedure TCustomMenuDlg.SetOverlayImage(node: TTreeNode; const OverlayIndex: Integer);
begin
  if node.ImageIndex <> -1 then
    node.OverlayIndex := OverlayIndex
  else
  case OverlayIndex of
    oiDisabled: begin
                  node.ImageIndex := bmOverlayDisabled;
                  node.SelectedIndex := bmOverlayDisabled;
                end;
    oiTemplate: begin
                  node.ImageIndex := bmOverlayTemplate;
                  node.SelectedIndex := bmOverlayTemplate;
                end;
  end;
end;

function TCustomMenuDlg.ValidateInput: Boolean;
var
  AShortcut: TShortcut;

  function FindShortcut(const AShortcut: TShortcut; AItem: TCustomActionItem): TCustomActionItem;
  var
    i: Integer;
  begin
    if AItem.Shortcut = AShortcut then
      Result := AItem
    else begin
      Result := nil;
      for i:= 0 to AItem.Count - 1 do
      begin
        Result := FindShortcut(AShortcut, AItem.Items[i]);
        if Assigned(Result) then break;
      end;
    end;
  end;

begin
  Result := true;
  if Assigned(TreeView.Selected) then
    with TCustomActionItem(TreeView.Selected.Data) do
    begin
      if ActionId < aidTemplate then
        exit;

      if rbTemplate.Checked and (TemplateName = '') then
      begin
        MessageDlg(stMenuAssignTempl, mtError, [mbOk], 0);
        Result := false;
        exit;
      end;

     ///AShortCut := TextToShortcut(cbShortcutKey.Text);
     if cbCtrl.Checked then AShortCut := AShortCut or scCtrl;
     if cbShift.Checked then AShortCut := AShortCut or scShift;
     if cbAlt.Checked then AShortCut := AShortCut or scAlt;

     if AShortcut <> ShortCut then
     begin
       if (AShortcut <> 0) and (FindShortcut(AShortcut, fActMenu.Items) <> nil) then
       begin
         ///MessageDlg(Format(stDuplicateSC, [ShortCutToText(AShortCut), FindShortcut(AShortcut, fActMenu.Items).Caption]), mtError, [mbOk], 0);
         Result := false;
       end
       else
         ShortCut := AShortCut;
     end;
  end;
end;


constructor TCustomMenuDlg.Create(AOwner: TComponent; AImageList: TImageList; AActionMenu: TCustomActionMenu);
var
  i, j: Integer;
begin
  inherited Create(AOwner);

  TSizeGrip.Create(Panel3);

  fActMenu := TCustomActionMenu.Create(nil);
  AActionMenu.Clone(fActMenu);

  fImageList := TImageList.Create(Self);
  fImageList.AddImages(AImageList);
  fImageList.Overlay(bmOverlayDisabled, oiDisabled);
  fImageList.Overlay(bmOverlayTemplate, oiTemplate);
  TreeView.Images := fImageList;
  MainMenu.Images := fImageList;

  ActionItemToTreeView(fActMenu.Items, TreeView);
  fActMenu.AssignItems(mbTest);

  {Initialize template combo }
  with TemplateParser do
  begin
    if Count = 0 then
      rbTemplate.Enabled := false
    else
    for i := 0 to Count - 1 do
    begin
      if Assigned(Templates[i].Icon) then
        cbTemplate.Items.AddObject(Templates[i].Name, Pointer(Templates[i].ImageIndex))
      else
        cbTemplate.Items.Add(Templates[i].Name);
    end;
  end;

  { Initialize shortcut combo }
  for i := 0 to High(SCKeys) do
    for j := SCKeys[i, 0] to SCKeys[i, 1] do
      ///cbShortcutKey.Items.Add(ShortCutToText(j));

  AlignMenu;
end;

destructor TCustomMenuDlg.Destroy;
begin
  fActMenu.Free;
  inherited Destroy;
end;

procedure TCustomMenuDlg.TreeViewChange(Sender: TObject; Node: TTreeNode);

  procedure GetShortcut(ShortCut: TShortCut);
  begin
    ///cbShortCutKey.Text := ShortcutToText(Shortcut and not (scCtrl or scShift or scAlt));
    cbCtrl.Checked := ShortCut and scCtrl <> 0;
    cbShift.Checked := ShortCut and scShift <> 0;
    cbAlt.Checked := ShortCut and scAlt <> 0;
  end;

begin
  with TCustomActionItem(Node.Data) do
  try
    LockControl(Self, true);
    GroupBox1.Visible := true;
    GroupBox2.Visible := true;
    Panel5.Visible := true;
    edCaption.Text := Caption;
    if not edCaption.Enabled then
    begin
      edCaption.Enabled := true;
      edCaption.Color := clWindow;
    end;
    if ActionId < aidTemplate then
    begin
      GroupBox1.Visible := false;
      GroupBox2.Visible := false;
      if Node.Level = 0 then
        Panel5.Visible := false;
      if ActionId = aidSeparatorItem then
      begin
        edCaption.Enabled := false;
        edCaption.Color := clBtnFace;
      end;
      exit;
    end;
    cbDefaultAction.Visible := DefaultAction = -1;
    if not Enabled then
      rbDisabled.Checked := true
    else
    if ActionId = aidTemplate then
      rbTemplate.Checked := true
    else
      rbDefaultAction.Checked := true;

    GetShortcut(ShortCut);

    if ActionId >= aidTemplate then
      rbClick(nil);
  finally
    LockControl(Self, false);
  end;
end;

procedure TCustomMenuDlg.rbClick(Sender: TObject);
var
  ax: Integer;

  procedure EnableCombo(cb: TComboBox; Enable: boolean);
  begin
    cb.Enabled := Enable;
    if Enable then
      cb.Color := clWindow
    else begin
      cb.ItemIndex := -1;
      cb.Color := clBtnFace;
    end;
  end;

begin

  with TCustomActionItem(TreeView.Selected.Data) do
  try
    LockControl(Self, true);
    ComboText.Visible := false;
    EnableCombo(cbTemplate, rbTemplate.Checked);
    ComboText.Color := cbTemplate.Color;
    EnableCombo(cbDefaultAction, rbDefaultAction.Checked and (DefaultAction = -1));

    Enabled := not rbDisabled.Checked;
    SetNodeIcon(TreeView.Selected, TCustomActionItem(TreeView.Selected.Data));
    if Enabled then
    begin
      ax := ActionId;
      if rbTemplate.Checked then
      begin
        ActionId := aidTemplate;
        cbTemplate.ItemIndex := cbTemplate.Items.IndexOf(TemplateName);
        if (cbTemplate.ItemIndex = -1) and (TemplateName <> '') then
        begin
          ComboText.Caption := TemplateName;
          ComboText.Visible := true;
        end;
      end
      else
      if DefaultAction = -1 then
      begin
        if ActionId = aidTemplate then
        begin
          cbDefaultAction.ItemIndex := 0;
          ActionId := aidEntry;
        end
        else
          cbDefaultAction.ItemIndex := ActionId - aidEntry;
      end
      else
        ActionId := DefaultAction;
      if ax <> ActionId then
        SetNodeIcon(TreeView.Selected, TCustomActionItem(TreeView.Selected.Data));
    end;
    fActMenu.AssignItems(mbTest);
    AlignMenu;
  finally
    LockControl(Self, false);
  end;
end;

procedure TCustomMenuDlg.edCaptionChange(Sender: TObject);
begin
  if Assigned(TreeView.Selected) then
  with TCustomActionItem(TreeView.Selected.Data) do begin
    Caption := edCaption.Text;
    TreeView.Selected.Text := Caption;
  end;
end;

procedure TCustomMenuDlg.AlignMenu;
var
  ///mii: TMenuItemInfo;
  MenuHandle: hMenu;
  Buffer: array[0..79] of Char;
begin
  MenuHandle := Menu.Handle;

  //GET Help Menu Item Info
  ///mii.cbSize := SizeOf(mii) ;
  ///mii.fMask := MIIM_TYPE;
  ///mii.dwTypeData := Buffer;
  ///mii.cch := SizeOf(Buffer) ;
  ///GetMenuItemInfo(MenuHandle, mbTest.Command, false, mii) ;

  //SET Help Menu Item Info
  ///mii.fType := mii.fType or MFT_RIGHTJUSTIFY;
  ///SetMenuItemInfo(MenuHandle, mbTest.Command, false, mii) ;
  // Force menu bar to redraw
  Menu := nil;
  Menu := MainMenu;
end;

procedure TCustomMenuDlg.TreeViewContextPopup(Sender: TObject; MousePos: TPoint; var Handled: Boolean);
var
  Node: TTreeNode;
begin
  Node := TreeView.GetNodeAt(MousePos.X, MousePos.Y);
  if (Node <> nil) then
    Node.Selected := true;
end;

procedure TCustomMenuDlg.PopupMenuPopup(Sender: TObject);
begin
  mbAddItem.Enabled := false;
  mbAddSubmenu.Enabled := false;
  mbAddSeparator.Enabled := false;
  mbDelete.Enabled := false;
  if not Assigned(TreeView.Selected) then exit;
  with TCustomActionItem(TreeView.Selected.Data) do begin
    mbDelete.Enabled := (TreeView.Selected.Level > 0) and (ActionId <= aidTemplate);
    if ActionId = aidNodeItem then
    begin
      mbAddItem.Enabled := true;
      mbAddSubmenu.Enabled := true;
      mbAddSeparator.Enabled := true;
    end;
  end;
end;

procedure TCustomMenuDlg.mbAddItemClick(Sender: TObject);
begin
  if rbTemplate.Enabled then
    AddItem(aidTemplate, cNewItem)
  else
    AddItem(aidEntry, cNewItem);
  fActMenu.AssignItems(mbTest);
  AlignMenu;
end;

procedure TCustomMenuDlg.mbAddSubmenuClick(Sender: TObject);
begin
  AddItem(aidNodeItem, cNewSubmenu);
  fActMenu.AssignItems(mbTest);
  AlignMenu;
end;

procedure TCustomMenuDlg.mbAddSeparatorClick(Sender: TObject);
begin
  AddItem(aidSeparatorItem, '-');
  fActMenu.AssignItems(mbTest);
  AlignMenu;
end;

procedure TCustomMenuDlg.mbDeleteClick(Sender: TObject);
var
  msg: string;

  procedure PreserveStandardItems(Node: TTreeNode);
  var
    i, idx: Integer;
    destNode: TTreeNode;
  begin
    for i := Node.Count - 1 downto 0 do
      PreserveStandardItems(Node[i]);
    idx := TCustomActionItem(Node.Data).DefaultAction;
    if idx >= aidEntry  then // non-deletable items
    begin
      destNode := TreeView.Items[0];
      if destNode.Count > idx - aidEntry then
        Node.MoveTo(destNode[idx - aidEntry], naInsert)
      else
        Node.MoveTo(destNode, naAddChild);
      TCustomActionItem(Node.Data).Move(TCustomActionItem(destNode.Data), idx - aidEntry)
    end;
  end;

begin
  with TCustomActionItem(TreeView.Selected.Data) do
  begin
    if Count = 0 then
      msg := stDeleteMenuItem
    else
      msg := stDeleteSubmenu;
    if MessageDlg(msg, mtConfirmation, [mbYes, mbNo], 0) = mrYes then
    begin
      PreserveStandardItems(TreeView.Selected);
      Parent.Delete(TreeView.Selected.Index);
      fActMenu.AssignItems(mbTest);
      AlignMenu;
      TreeView.Selected.Delete;
    end;
  end;
end;

procedure TCustomMenuDlg.TreeViewDragDrop(Sender, Source: TObject; X, Y: Integer);
var
  DropItem: TCustomActionItem;
begin
  with TreeView do
  begin
    if not Assigned(DropTarget) or (Selected = DropTarget) then exit;

    if TCustomActionItem(DropTarget.Data).ActionId = aidNodeItem then
    begin
      Selected.MoveTo(DropTarget, naAddChildFirst);
      DropItem := TCustomActionItem(DropTarget.Data);
    end
    else begin
      if Selected.AbsoluteIndex < DropTarget.AbsoluteIndex then
      begin
        if DropTarget.GetNextSibling <> nil then
          Selected.MoveTo(DropTarget.GetNextSibling, naInsert)
        else
          Selected.MoveTo(DropTarget, naAdd);
      end
      else
        Selected.MoveTo(DropTarget, naInsert);
      DropItem := TCustomActionItem(DropTarget.Parent.Data)
    end;
    TCustomActionItem(Selected.Data).Move(DropItem, Selected.Index);
    fActMenu.AssignItems(mbTest);
    AlignMenu;
  end;
end;

procedure TCustomMenuDlg.TreeViewStartDrag(Sender: TObject; var DragObject: TDragObject);
begin
  if TreeView.Selected = TreeView.Items[0] then
    abort;
  ScrollTimer.Enabled := True;
end;

procedure TCustomMenuDlg.ScrollTimerTimer(Sender: TObject);
begin
  OnScrollTimer(ScrollTimer, TreeView, ScrollAccMargin);
end;

procedure TCustomMenuDlg.TreeViewEndDrag(Sender, Target: TObject; X, Y: Integer);
begin
  ScrollTimer.Enabled := false;
end;

procedure TCustomMenuDlg.TreeViewDragOver(Sender, Source: TObject; X, Y: Integer; State: TDragState; var Accept: Boolean);
begin
//
end;

procedure TCustomMenuDlg.cbDefaultActionDrawItem(Control: TWinControl; Index: Integer; Rect: TRect; State: TOwnerDrawState);
begin
  cbDefaultAction.Canvas.FillRect(Rect);
  fImageList.Draw(cbDefaultAction.Canvas, Rect.Left + CB_ICON_INDENT, Rect.Top, GetActionImage(Index + aidEntry));
  cbDefaultAction.Canvas.Textout(Rect.Left + fImageList.Width + CB_TEXT_INDENT, Rect.Top, cbDefaultAction.Items[Index]);
end;

procedure TCustomMenuDlg.cbDefaultActionChange(Sender: TObject);
begin
  with TCustomActionItem(TreeView.Selected.Data) do begin
    ActionId := cbDefaultAction.ItemIndex + aidEntry;
    TreeView.Selected.ImageIndex := ImageIndex;
    TreeView.Selected.SelectedIndex := ImageIndex;
  end;
end;

procedure TCustomMenuDlg.cbTemplateDrawItem(Control: TWinControl; Index: Integer; Rect: TRect; State: TOwnerDrawState);
begin
  cbTemplate.Canvas.FillRect(Rect);
  cbTemplate.Canvas.Draw(Rect.Left + 4, Rect.Top, TemplateParser.Templates[Index].Icon); // Indent consistent with list images
  cbTemplate.Canvas.Textout(Rect.Left + fImageList.Width + CB_TEXT_INDENT, Rect.Top, cbTemplate.Items[Index]);
end;

procedure TCustomMenuDlg.cbTemplateChange(Sender: TObject);
begin
  with TCustomActionItem(TreeView.Selected.Data), cbTemplate do
  begin
    ComboText.Visible := false;
    TemplateName := Text;
    SetNodeIcon(TreeView.Selected, TCustomActionItem(TreeView.Selected.Data));
  end;
end;

procedure TCustomMenuDlg.FormResize(Sender: TObject);
///var
  ///pcbi: TComboBoxInfo;
begin
  ///pcbi.cbSize := SizeOf(pcbi);
  ///GetComboBoxInfo(cbTemplate.Handle, pcbi);
  with cbTemplate do
    ///ComboText.SetBounds(Left + pcbi.rcItem.Left,
    ///                    Top + pcbi.rcItem.Top,
    ///                    pcbi.rcItem.Right - pcbi.rcItem.Left,
    ///                    pcbi.rcItem.Bottom - pcbi.rcItem.Top);
end;

procedure TCustomMenuDlg.TreeViewChanging(Sender: TObject; Node: TTreeNode; var AllowChange: Boolean);
begin
  AllowChange := ValidateInput;
end;

procedure TCustomMenuDlg.ComboTextMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbLeft then
    ///cbTemplate.Perform(CB_SHOWDROPDOWN, Integer(true), 0);
end;

procedure TCustomMenuDlg.TreeViewCustomDrawItem(Sender: TCustomTreeView; Node: TTreeNode; State: TCustomDrawState; var DefaultDraw: Boolean);
begin
  with TCustomActionItem(Node.Data) do
  if (TemplateName <> '') and (TemplateParser.IndexOf(TemplateName) = -1) then with Sender.Canvas.Font do
  begin
    Style := [fsItalic];
    Color := clRed;
  end;
end;

procedure TCustomMenuDlg.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose := (ModalResult <> mrOk) or ValidateInput;
end;

end.
