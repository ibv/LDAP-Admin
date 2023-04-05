  {      LDAPAdmin - uSchemaDlg.pas
  *      Copyright (C) 2005 Alexander Sokoloff
  *
  *      Author: Alexander Sokoloff
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

unit uSchemaDlg;

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
  SysUtils, Graphics, Forms, Buttons, Classes, Controls, ComCtrls, ExtCtrls,
  ImgList, Schema, StdCtrls, LDAPClasses, Messages, Menus, Clipbrd, ShellCtrls;

type

  TTreeHistory=class
  private
    FCurrent:       TTreeNode;
    FUndo:          TList;
    FRedo:          TList;
    procedure       SetCurrent(const Value: TTreeNode);
    function        GetIsRedo: boolean;
    function        GetIsUndo: boolean;
  public
    constructor     Create; reintroduce;
    destructor      Destroy; override;
    procedure       Undo;
    procedure       Redo;
    procedure       Clear;
    property        Current: TTreeNode read FCurrent write SetCurrent;
    property        IsUndo: boolean read GetIsUndo;
    property        IsRedo: boolean read GetIsRedo;
  end;


  TSchemaDlg = class(TForm)
    Tree:           TTreeView;
    ImageList1:     TImageList;
    Splitter1:      TSplitter;
    View:           TTreeView;
    PopupMenu:      TPopupMenu;
    pmCopy:         TMenuItem;
    StatusBar:      TStatusBar;
    Tabs:           TTabControl;
    pmOpenNewTab:   TMenuItem;
    N1:             TMenuItem;
    pmOpen:         TMenuItem;
    pmUndo:         TMenuItem;
    Panel1: TPanel;
    UndoBtn: TSpeedButton;
    RedoBtn: TSpeedButton;
    Label1: TLabel;
    btnSave: TSpeedButton;
    Bevel2: TBevel;
    btnClose: TSpeedButton;
    Bevel3: TBevel;
    SearchEdit: TEdit;
    WholeWordsCbx: TCheckBox;
    procedure       TreeChange(Sender: TObject; Node: TTreeNode);
    procedure       SearchEditKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure       ViewMouseMove(Sender: TObject; Shift: TShiftState; X,  Y: Integer);
    procedure       ViewAdvancedCustomDrawItem(Sender: TCustomTreeView; Node: TTreeNode; State: TCustomDrawState; Stage: TCustomDrawStage; var PaintImages, DefaultDraw: Boolean);
    procedure       UndoBtnClick(Sender: TObject);
    procedure       RedoBtnClick(Sender: TObject);
    procedure       FormClose(Sender: TObject; var Action: TCloseAction);
    procedure       pmCopyClick(Sender: TObject);
    procedure       ViewContextPopup(Sender: TObject; MousePos: TPoint; var Handled: Boolean);
    procedure       TabsChange(Sender: TObject);
    procedure       ViewMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure       TabsMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure       TabsMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure       TabsMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure       pmOpenClick(Sender: TObject);
    procedure       pmOpenNewTabClick(Sender: TObject);
    procedure       PopupMenuPopup(Sender: TObject);
    function        GetNodeAt(X, Y: Integer): TTreeNode;
    procedure       pmUndoClick(Sender: TObject);
    function        GetLinkRect(Node: TTreeNode): TRect;
    procedure       btnSaveClick(Sender: TObject);
    procedure FormDeactivate(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
  private
    FSchema:        TLDAPSchema;
    FLastSerched:   string;
    function        AddValue(const Name: string; Value: string; const Parent: TTreeNode=nil): TTreeNode; overload;
    function        AddValue(const Name: string; Value: integer): TTreeNode; overload;
    function        AddValue(const Name: string; Value: boolean): TTreeNode; overload;
    function        AddValue(const Name: string; const Value: TLdapSchemaItem; const AsString: string; const Parent: TTreeNode=nil): TTreeNode; overload;
    procedure       AddValues(const Name: string; const Values: TLdapSchemaItems; const AsString: string; const Parent: TTreeNode=nil); overload;
    procedure       AddValues(const Name: string; const Values: TStringList; const Parent: TTreeNode=nil); overload;

    procedure       ShowObjectClass(const ObjClass: TLDAPSchemaClass);
    procedure       ShowAttribute(const Attribute: TLDAPSchemaAttribute);
    procedure       ShowSyntax(const Syntax: TLDAPSchemaSyntax);
    procedure       ShowMatchingRule(const MatchingRule: TLDAPSchemaMatchingRule);
    procedure       ShowMatchingRuleUse(const MatchingRuleUse: TLDAPSchemaMatchingRuleUse);
    //procedure       WmGetSysCommand(var Message :TMessage); Message WM_SYSCOMMAND;
    function        AddTab(TreeNode: TTreeNode): integer;
    procedure       GoToLink(Node: TTreeNode; InNewTab: boolean);
  public
    constructor     Create(const ASession: TLDAPSession); reintroduce;
    destructor      Destroy; override;
    procedure       SessionDisconnect(Sender: TObject);
    function        Search(const SearchStr: string; const WholeWords: boolean; const InNewTab: boolean): TTreeNode;
    property        Schema: TLdapSchema read FSchema;
  end;

implementation

{$I LdapAdmin.inc}

uses Math, Export,LinLDAP, Constant, Misc{$IFDEF VER_XEH}, System.Types{$ENDIF};

const
  FOLDER_IMG          = 0;
  CLASS_IMG           = 1;
  SYNTAX_IMG          = 2;
  ATTRIBUTE_IMG       = 3;
  MATCHINGRULE_IMG    = 4;
  MATCHINGRULEUSE_IMG = 5;


{$R *.dfm}

{ TSchemaDlg }

constructor TSchemaDlg.Create(const ASession: TLDAPSession);

  procedure AddSchemaItems(Item: TLdapSchemaItems; Caption: string; Img: integer);
  var
    i: integer;
    ParentNode: TTreeNode;

  begin
    ParentNode:=Tree.Items.Add(nil, Caption);
    ParentNode.ImageIndex:=FOLDER_IMG;
    ParentNode.SelectedIndex:=FOLDER_IMG;
    for i:=0 to Item.Count-1 do
    begin
      with Tree.Items.AddChild(ParentNode,Item[i].Name.CommaText) do
      begin
        Data:=pointer(Item[i]);
        ImageIndex:=img;
        SelectedIndex:=ImageIndex;
      end;
    end;
    ParentNode.AlphaSort;
  end;

begin
  inherited Create(Application.MainForm);

  FSchema:=TLDAPSchema.Create(ASession);
  if not FSchema.Loaded then raise Exception.Create(stNoSchema);

  AddSchemaItems(FSchema.OBjectClasses,    'Object Classes',    CLASS_IMG);
  AddSchemaItems(FSchema.Attributes,       'Attribute Types',   ATTRIBUTE_IMG);
  AddSchemaItems(FSchema.Syntaxes,         'Syntaxes',          SYNTAX_IMG);
  AddSchemaItems(FSchema.MatchingRules,    'Matching Rules',    MATCHINGRULE_IMG);
  AddSchemaItems(FSchema.MatchingRuleUses, 'Matching Rule Use', MATCHINGRULEUSE_IMG);

  if Tree.Items.Count>0 then Tree.Items[0].Selected:=true;

  ASession.OnDisconnect.Add(SessionDisconnect);

  StatusBar.Panels[0].Text := Format(cServer, [ASession.Server]);
  StatusBar.Panels[0].Width := StatusBar.Canvas.TextWidth(StatusBar.Panels[0].Text) + 16;

  Show;
end;

destructor TSchemaDlg.Destroy;
var
  i: integer;
begin
  for i:=0 to Tabs.Tabs.Count-1 do
    if Tabs.Tabs.Objects[i] is TTreeHistory then TTreeHistory(Tabs.Tabs.Objects[i]).Free;

  inherited;
  FSchema.Free;
end;

procedure TSchemaDlg.SessionDisconnect(Sender: TObject);
begin
  Close;
end;

procedure TSchemaDlg.TreeChange(Sender: TObject; Node: TTreeNode);
begin
  if Tree.Selected=nil then exit;
  if not(Tabs.Tabs.Objects[Tabs.TabIndex] is TTreeHistory) then Tabs.Tabs.Objects[Tabs.TabIndex]:=TTreeHistory.Create;

  begin
    Tabs.Tabs.Strings[Tabs.TabIndex]:=Tree.Selected.Text;
    ///TTreeHistory(Tabs.Tabs.Objects[Tabs.TabIndex]).Current:=Tree.Selected;
    ///UndoBtn.Enabled:=TTreeHistory(Tabs.Tabs.Objects[Tabs.TabIndex]).IsUndo;
    ///RedoBtn.Enabled:=TTreeHistory(Tabs.Tabs.Objects[Tabs.TabIndex]).IsRedo;
  end;

  View.Items.BeginUpdate;
  View.Items.Clear;
  if (TObject(Tree.Selected.Data) is TLDAPSchemaClass) then ShowObjectClass(TLDAPSchemaClass(Tree.Selected.Data));
  if (TObject(Tree.Selected.Data) is TLDAPSchemaAttribute) then ShowAttribute(TLDAPSchemaAttribute(Tree.Selected.Data));
  if (TObject(Tree.Selected.Data) is TLDAPSchemaSyntax) then ShowSyntax(TLDAPSchemaSyntax(Tree.Selected.Data));
  if (TObject(Tree.Selected.Data) is TLDAPSchemaMatchingRule) then ShowMatchingRule(TLDAPSchemaMatchingRule(Tree.Selected.Data));
  if (TObject(Tree.Selected.Data) is TLDAPSchemaMatchingRuleUse) then ShowMatchingRuleUse(TLDAPSchemaMatchingRuleUse(Tree.Selected.Data));

  View.FullExpand;
  if View.Items.Count>0 then View.Items[0].Selected:=true;
  View.Items.EndUpdate;

  if Tree.Selected.Parent=nil then begin
    StatusBar.Panels[1].Text:=' '+Tree.Selected.Text;
    StatusBar.Panels[2].Text:=' '+inttostr(Tree.Selected.Count)+ ' items';
  end
  else begin
    StatusBar.Panels[1].Text:=' '+Tree.Selected.Parent.Text;
    StatusBar.Panels[2].Text:=' '+Tree.Selected.Text;
  end;

end;

function TSchemaDlg.Search(const SearchStr: string; const WholeWords: boolean; const InNewTab: boolean): TTreeNode;
  function DoSearch(Start: TTreeNode; Pattern: string): TTreeNode;
  begin
    result:=Start;
    while result <> nil do begin
      if pos(Pattern,','+UpperCase(result.Text)+',')>0 then exit;
      result:= result.GetNext;
    end;
  end;

var
  s: string;
begin
  s:=Trim(UpperCase(SearchStr));
  if WholeWords then s:=','+s+',';


  if S<>FLastSerched then begin
    result:=DoSearch(Tree.Items.GetFirstNode, s);
    FLastSerched:=s;
  end
  else begin
    result:=DoSearch(Tree.Selected.GetNext, s);
    if result=nil then
      result:=DoSearch(Tree.Items.GetFirstNode, s);
  end;

  if result<>nil then begin
    if InNewTab then Tabs.TabIndex:=AddTab(result);
    result.Selected:=true;
  end;
end;

procedure TSchemaDlg.SearchEditKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  case KEY of
    VK_RETURN: Search(SearchEdit.Text, WholeWordsCbx.Checked, Trim(UpperCase(SearchEdit.Text))<>FLastSerched);
  end;
end;

function TSchemaDlg.GetNodeAt(X, Y: Integer): TTreeNode;
begin
  result:=View.GetNodeAt(X,Y);
  if (result<>nil) and (not PtInRect(result.DisplayRect(true), Point(X,Y))) then
    result:=nil;
end;

procedure TSchemaDlg.ViewMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
var
  Node: TTreeNode;
begin
  Node:=GetNodeAt(X,Y);
  if (Node=nil) then begin
    View.Cursor:=crDefault;
    exit;
  end;

  if ssLeft in Shift then begin
    View.Cursor:=crDefault;
    Node.Selected:=true;
    Node.Focused:=true;
    exit;
  end;

  if PtInRect(GetLinkRect(Node), point(X, Y)) then View.Cursor:=crHandPoint
  else View.Cursor:=crDefault;
end;

function TSchemaDlg.GetLinkRect(Node: TTreeNode): TRect;
var
  n: integer;
begin
  if (Node=nil) or (Node.Data=nil) then begin
    result:=rect(0,0,0,0);
    exit;
  end;

  result:=Node.DisplayRect(true);
  n:=pos(':', Node.Text);
  if n>0 then
    result.Left:=result.Left+Node.TreeView.Canvas.TextWidth(copy(Node.Text, 1, n+1));
end;

procedure TSchemaDlg.ViewAdvancedCustomDrawItem(Sender: TCustomTreeView; Node: TTreeNode; State: TCustomDrawState;Stage: TCustomDrawStage; var PaintImages, DefaultDraw: Boolean);
var
  rect: TRect;
  n: integer;
begin
  if (Node.Parent=nil) and (Node.Index=0) then View.Canvas.Font.Style:=[fsBold];
  if Stage<> cdPostPaint then exit;
  if integer(Node.Data)>0 then
  begin
    if not (cdsFocused in State) then View.Canvas.Font.Color:=clBlue;
    View.Canvas.Font.Style:=[fsUnderline];
    rect:=GetLinkRect(Node);
    n:=pos(':', Node.Text);
    if n>0 then inc(n,2);
	  //logs('|'+copy(Node.Text, n, length(Node.Text)));
    ///View.Canvas.TextRect(Rect, Rect.Left+1, Rect.Top+1, copy(Node.Text, n, length(Node.Text)));
 	  View.Canvas.TextRect(Rect, Rect.Left+3, Rect.Top+1, copy(Node.Text, n, length(Node.Text)));
  end;
end;

procedure TSchemaDlg.UndoBtnClick(Sender: TObject);
begin
  if not (Tabs.Tabs.Objects[Tabs.TabIndex] is TTreeHistory) then exit;
  with Tabs.Tabs.Objects[Tabs.TabIndex] as TTreeHistory do begin
    Undo;
    Current.Selected:=true;
  end;
end;

procedure TSchemaDlg.RedoBtnClick(Sender: TObject);
begin
  if not (Tabs.Tabs.Objects[Tabs.TabIndex] is TTreeHistory) then exit;
  with Tabs.Tabs.Objects[Tabs.TabIndex] as TTreeHistory do begin
    Redo;
    Current.Selected:=true;
  end;
end;

function TSchemaDlg.AddValue(const Name: string; Value: string; const Parent: TTreeNode=nil): TTreeNode;
var
  s: string;
begin
  if Name<>'' then
    s := ': '
  else
    s := '';
  result:=View.Items.AddChild(Parent, Name + s + Value);
  result.ImageIndex:=-1;
  result.SelectedIndex:=-1;
  result.StateIndex:=-1;
end;

function TSchemaDlg.AddValue(const Name: string; const Value: TLdapSchemaItem; const AsString: string; const Parent: TTreeNode=nil): TTreeNode;
var
  s: string;
begin
  if Name<>'' then
    s := ': '
  else
    s := '';
  if Value<>nil then result:=View.Items.AddChildObject(Parent, Name + s + Value.Name.CommaText, Value)
  else result:=AddValue(Name, AsString, Parent);
  result.ImageIndex:=-1;
  result.SelectedIndex:=-1;
  result.StateIndex:=-1;
end;

procedure TSchemaDlg.AddValues(const Name: string; const Values: TLdapSchemaItems; const AsString: string; const Parent: TTreeNode=nil);
var
  i: integer;
begin
  for i:=0 to Values.Count-1 do AddValue(Name, Values[i], AsString, Parent);
  Parent.AlphaSort;
end;

procedure TSchemaDlg.AddValues(const Name: string; const Values: TStringList; const Parent: TTreeNode=nil);
var
  i: integer;
begin
  for i:=0 to Values.Count-1 do AddValue(Name, Values[i], Parent);
  Parent.AlphaSort;
end;

function TSchemaDlg.AddValue(const Name: string; Value: integer): TTreeNode;
begin
  result:=AddValue(Name,inttostr(Value));
end;

function TSchemaDlg.AddValue(const Name: string; Value: boolean): TTreeNode;
begin
  if Value then result:=AddValue(Name,'Yes')
  else result:=AddValue(Name,'No');
end;

procedure TSchemaDlg.ShowObjectClass(const ObjClass: TLDAPSchemaClass);
var
  Node, Node2: TTreeNode;
  Sup:  TLDAPSchemaClass;
begin
   with ObjClass do begin
    case Name.Count of
      0: AddValue('Name','');
      1: AddValue('Name',Name[0]);
      else begin
        Node:=AddValue('Names','');
        AddValues('', Name, Node);
      end;
    end;
    AddValue('Description',Description);
    AddValue('Oid',Oid);

    case Kind of
      lck_Abstract:   AddValue('Kind','Abstract');
      lck_Auxiliary:  AddValue('Kind','Auxiliary');
      lck_Structural: AddValue('Kind','Structural');
    end;

    AddValue('Superior', Superior, SuperiorAsStr);

    Node:=AddValue('Must','');
    Node.ImageIndex:=1;
    Node.SelectedIndex:=1;
    AddValues('', Must, '', Node);

    Sup:=Superior;
    while Sup<>nil do begin
      if Sup.Must.Count>0 then begin
        Node2:=AddValue('Inherited from', Sup, '',  Node);
        AddValues('', Sup.Must, '', Node2);
      end;
      Sup:=Sup.Superior;
    end;

    Node:=AddValue('May','');
    Node.ImageIndex:=1;
    Node.SelectedIndex:=1;
    AddValues('', May, '', Node);

    Sup:=Superior;
    while Sup<>nil do begin
      if Sup.May.Count>0 then begin
        Node2:=AddValue('Inherited from', Sup, '', Node);
        AddValues('', Sup.May, '', Node2);
      end;
      Sup:=Sup.Superior;
    end;

  end;
end;

procedure TSchemaDlg.ShowAttribute(const Attribute: TLDAPSchemaAttribute);
var
  Node: TTreeNode;
begin
  with Attribute do begin
   case Name.Count of
      0: AddValue('Name','');
      1: AddValue('Name',Name[0]);
      else begin
        Node:=AddValue('Names','');
        Node.ImageIndex:=1;
        Node.SelectedIndex:=1;
        AddValues('', Name, Node);
      end;
   end;
    AddValue('Description',Description);
    AddValue('Oid',Oid);
    AddValue('Single Value',SingleValue);
    AddValue('Syntax', Syntax, SyntaxAsStr);

    if Attribute.Length>0 then AddValue('Length',Length)
    else AddValue('Length','undefined');

    AddValue('Superior', Superior, SubstrAsStr);
    AddValue('Collective', Collective);
    AddValue('Obsolete', Obsolete);
    AddValue('No user modification' ,NoUserModification);

    case Attribute.Usage of
      au_directoryOperation:   AddValue('Usage','Directory operation');
      au_distributedOperation: AddValue('Usage','Distributed operation');
      au_dSAOperation:         AddValue('Usage','DSA operation');
      au_userApplications:     AddValue('Usage','User applications');
    end;

   AddValue('Ordering',  Ordering, OrderingAsStr);
   AddValue('Equality',  Equality, EqualityAsStr);
   AddValue('Substring', Substr,   SubstrAsStr);

    Node:=AddValue('Classes which use','');
    Node.ImageIndex:=1;
    Node.SelectedIndex:=1;
    AddValues('', WhichUse, '', Node);

  end;
end;

procedure TSchemaDlg.ShowSyntax(const Syntax: TLDAPSchemaSyntax);
begin
  with Syntax do begin
    AddValue('Oid',Oid);
    AddValue('Description',Description);
  end;
end;

procedure TSchemaDlg.ShowMatchingRule(const MatchingRule: TLDAPSchemaMatchingRule);
begin
  with MatchingRule do begin
    AddValue('Name', Name.CommaText);
    AddValue('Description', Description);
    AddValue('Oid', Oid);
    AddValue('Obsolete', Obsolete);
    AddValue('Syntax', Syntax, SyntaxAsStr);
  end;
end;

procedure TSchemaDlg.ShowMatchingRuleUse(const MatchingRuleUse: TLDAPSchemaMatchingRuleUse);
var
  Node: TTreeNode;
begin
  with MatchingRuleUse do begin
    AddValue('Name',Name.CommaText);
    AddValue('Description',Description);
    AddValue('Oid',Oid);
    AddValue('Obsolete',Obsolete);
    Node:=AddValue('Applies OIDs','');
    AddValues('', Applies, '', Node);
  end;
end;

procedure TSchemaDlg.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action:=caFree;
  FSchema.Session.OnDisconnect.Delete(SessionDisconnect);
end;

{
procedure TSchemaDlg.WmGetSysCommand(var Message: TMessage);
begin
  if (Message.WParam = SC_MINIMIZE) then Hide
  else inherited;
end;
}
procedure TSchemaDlg.pmCopyClick(Sender: TObject);
begin
  if View.Selected<>nil then Clipboard.SetTextBuf(pchar(View.Selected.Text));
end;

procedure TSchemaDlg.pmOpenClick(Sender: TObject);
begin
  GoToLink(View.Selected,false);
end;

procedure TSchemaDlg.pmOpenNewTabClick(Sender: TObject);
begin
  GoToLink(View.Selected,true);
end;

procedure TSchemaDlg.ViewContextPopup(Sender: TObject; MousePos: TPoint; var Handled: Boolean);
var
  Node: TTreeNode;
begin
  Node:=View.GetNodeAt(MousePos.X,MousePos.Y);
  if Node<>nil then begin
    Node.Selected:=true;
    Node.Focused:=true;
  end;
end;

function TSchemaDlg.AddTab(TreeNode: TTreeNode): integer;
var
  i: integer;
  TreeHistory: TTreeHistory;
begin
  if TreeNode=nil then begin
    result:=Tabs.TabIndex;
    exit;
  end;

  for i:=0 to Tabs.Tabs.Count-1 do begin
    if (Tabs.Tabs.Objects[i] is TTreeHistory) and (TTreeHistory(Tabs.Tabs.Objects[i]).Current=TreeNode) then begin
      result:=i;
      exit;
    end;
  end;

  if Tree.Items.GetFirstNode=Tree.Selected then begin
    result:=Tabs.TabIndex;
    exit;
  end;

  TreeHistory:=TTreeHistory.Create;
  TreeHistory.Current:=TreeNode;
  result:=Tabs.Tabs.AddObject(TreeNode.Text, TreeHistory);
end;

procedure TSchemaDlg.TabsChange(Sender: TObject);
begin
  if Tabs.Tabs.Objects[Tabs.TabIndex] is TTreeHistory then begin
    if TTreeHistory(Tabs.Tabs.Objects[Tabs.TabIndex]).Current<>nil then TTreeHistory(Tabs.Tabs.Objects[Tabs.TabIndex]).Current.Selected:=true;
  end;
end;

procedure TSchemaDlg.ViewMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if not PtInRect(GetLinkRect(GetNodeAt(X, Y)), point(X,Y)) then exit;
  if ssMiddle in Shift then GoToLink(GetNodeAt(X,Y), true);
  if ssLeft   in Shift then GoToLink(GetNodeAt(X,Y), false);
end;

procedure TSchemaDlg.GoToLink(Node: TTreeNode; InNewTab: boolean);
var
  N: TTreeNode;
begin
  if (Node=nil) or (Node.Data=nil) then exit;

  N:=Tree.Items.GetFirstNode;
  while N<>nil do begin
    if N.Data=Node.Data then begin
      N.Selected:=true;
      exit;
    end;
    N:=N.getNext;
  end;
end;

procedure TSchemaDlg.TabsMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  Tabs.Tabs.Move(Tabs.TabIndex,Tabs.IndexOfTabAt(X,Y));
  Tabs.Cursor:=crDefault;
end;

procedure TSchemaDlg.TabsMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin
  if (ssLeft in Shift) and (Tabs.Tabs.Count>1) then Tabs.Cursor:=crDrag
  else Tabs.Cursor:=crDefault;
end;

procedure TSchemaDlg.TabsMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  Idx: integer;
begin
  if (ssDouble in Shift) and (Tabs.Tabs.Count>1) then begin
    Idx:=Tabs.TabIndex;
    if Tabs.Tabs.Objects[Idx] is TTreeHistory then TTreeHistory(Tabs.Tabs.Objects[Idx]).Free;
    Tabs.Tabs.Delete(Idx);
    if Idx<Tabs.Tabs.Count then
      Tabs.TabIndex := Idx
     else
      Tabs.TabIndex := Tabs.Tabs.Count-1;
    Tabs.OnChange(self);
  end;
end;

procedure TSchemaDlg.PopupMenuPopup(Sender: TObject);
begin
  pmCopy.Enabled:=View.Selected<>nil;
  pmOpen.Enabled:=(View.Selected<>nil) and (View.Selected.Data<>nil);
  pmOpenNewTab.Enabled:=pmOpen.Enabled;
end;

procedure TSchemaDlg.pmUndoClick(Sender: TObject);
begin
  UndoBtnClick(self);
end;


{ TTreeHistory }

constructor TTreeHistory.Create;
begin
  inherited;
  FUndo:=TList.Create;
  FRedo:=TList.Create;
end;

destructor TTreeHistory.Destroy;
begin
  FUndo.Free;
  FRedo.Free;
  inherited;
end;

procedure TTreeHistory.SetCurrent(const Value: TTreeNode);
begin
  if FCurrent=Value then exit;
  if FCurrent<>nil then FUndo.Insert(0,FCurrent);
  FCurrent := Value;
  FRedo.Clear;
end;

procedure TTreeHistory.Undo;
begin
  if not IsUndo then exit;
  if FCurrent<>nil then FRedo.Insert(0,FCurrent);
  FCurrent:=TTreeNode(FUndo[0]);
  FUndo.Delete(0);
end;

procedure TTreeHistory.Redo;
begin
  if not ISRedo then exit;
  if FCurrent<>nil then FUndo.Insert(0,FCurrent);
  FCurrent:=TTreeNode(FRedo[0]);
  FRedo.Delete(0);
end;

procedure TTreeHistory.Clear;
begin
  FUndo.Clear;
  FRedo.Clear;
  FCurrent := nil;
end;

function TTreeHistory.GetIsUndo: boolean;
begin
  result:=FUndo.Count>0;
end;

function TTreeHistory.GetIsRedo: boolean;
begin
  result:=FRedo.Count>0;
end;

procedure TSchemaDlg.btnSaveClick(Sender: TObject);
begin
  TExportDlg.Create(FSchema.Dn, FSchema.Session, ['ldapSyntaxes', 'attributeTypes', 'objectclasses', 'matchingRules', 'matchingRuleUse'], false).ShowModal;
end;

procedure TSchemaDlg.FormDeactivate(Sender: TObject);
begin
  RevealWindow(Self, False, False);
end;

procedure TSchemaDlg.btnCloseClick(Sender: TObject);
begin
  Close;
end;

end.

