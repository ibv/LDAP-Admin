  {      LDAPAdmin - Search.pas
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

unit Search;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

{$I LdapAdmin.inc}

interface

uses
    {$IFDEF VER_D7H}
{$IFnDEF FPC}
  Windows, WinLDAP,
{$ELSE}
  LCLIntf, LCLType,
{$ENDIF}
  Themes,{$ENDIF}
    Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
    ComCtrls, StdCtrls, LDAPClasses, Menus, ExtCtrls, Sorter,
    ImgList, ActnList, Buttons, Schema, Contnrs, Connection, Xml,
    DlgWrap, TextFile
    {$IFDEF REGEXPR}
    { Note: If you want to compile templates with regex support you'll need }
    { Regexpr.pas unit from TRegeExpr library (http://www.regexpstudio.com) }
    , Regexpr
    {$ENDIF};

const
  MODPANEL_HEIGHT         = 65;
  MODPANEL_LEFT_IND       =  8;
  MODPANEL_LABEL_TOP      =  8;
  MODPANEL_CTRL_TOP       = 24;
  MODPANEL_CTRL_SPACING   =  8;
  MODPANEL_OP_COMBO_WIDTH = 97;

  SAVE_SEARCH_EXT     = '*.ldif';
  SAVE_MODIFY_EXT     = '*.lab';
  SAVE_MODIFY_LOG_EXT = '*.txt';

  CMOD_XML_ROOT_NAME  = 'changemod';
  CMOD_XML_LDAPOP     = 'ldapop';
  CMOD_XML_MODOP      = 'modop';
  CMOD_XML_ADD        = 'add';
  CMOD_XML_DELETE     = 'delete';
  CMOD_XML_REPLACE    = 'replace';

  CMOD_IDX_ADD        = 0;
  CMOD_IDX_DELETE     = 1;
  CMOD_IDX_REPLACE    = 2;

  TAB_CLOSE_BTN_SIZE  = 14;

type

  TSearchList = class
  private
    FAttributes:  TStringList;
    FEntries:     TLdapEntryList;
    FStatusBar:   TStatusBar;
    procedure     SearchCallback(Sender: TLdapEntryList; var AbortSearch: Boolean);
  protected
  public
    constructor   Create(Session: TLdapSession; ABase, AFilter, AAttributes: string; ASearchLevel, ADerefAliases: Integer; AStatusBar: TStatusBar);
    destructor    Destroy; override;
    property      Attributes: TStringList read FAttributes;
    property      Entries: TLdapEntryList read FEntries;
  end;

  TModBoxState = (mbxNew, mbxReady, mbxRunning, mbxDone);

  TModifyPanel = class(TPanel)
  private
    Ctrls:        array[0..3] of TControl;
  public
    procedure     Save(Node: TXmlNode);
    procedure     Load(Node: TXmlNode);
  end;

  TModifyOp = class
  private
    LdapOperation: Integer;
    AttributeName: string;
    Value1:        string;
    Value2:        string;
  end;

  TModifyBox = class(TScrollBox)
  private
    fSchema:      TLdapSchema;
    fSearchList:  TSearchList;
    fOpList:      TObjectList;
    fSbPanel:     TPanel;
    fProgressBar: TProgressBar;
    //fMemo:        TRichEdit;
    fMemo:        TMemo;
    fCloseButton: TButton;
    fState:       TModBoxState;
    fTimer:       TTimer;
    procedure     DoTimer(Sender: TObject);
    procedure     ButtonClick(Sender: TObject);
    procedure     OpComboChange(Sender: TObject);
    procedure     AddPanel;
    procedure     Reset;
  protected
    procedure     Resize; override;
  public
    constructor   Create(AOwner: TComponent; AConnection: TConnection); reintroduce;
    destructor    Destroy; override;
    procedure     New;
    procedure     Run;
    procedure     Save(const Filename: string; Encoding: TFileEncode);
    procedure     Load(const Filename: string);
    procedure     SaveResults(const Filename: string; Encoding: TFileEncode);
    property      SearchList: TSearchList read fSearchList write fSearchList;
    property      State: TModBoxState read fState;
  end;

  TSearchListView = class(TListView)
  private
    FSearchList:  TSearchList;
    FSorter:      TListViewSorter;
    procedure     SetSearchList(ASearchList: TSearchList);
    procedure     ListViewSort(SortColumn:  TListColumn; SortAsc: boolean);
    procedure     ListViewData(Sender: TObject; Item: TListItem);
    procedure     GetSelection(List: TStringList);
    procedure     RemoveFromList(List: TStringList);
    procedure     AdjustPaths(List: TStringList; TargetDn, TargetRdn: string);
  public
    constructor   Create(AOwner: TComponent); override;
    destructor    Destroy; override;
    procedure     CopySelection(TargetSession: TLdapSession; TargetDn, TargetRdn: string; Move: Boolean); reintroduce;
    procedure     DeleteSelection;
    property      SearchList: TSearchList read fSearchList write SetSearchList;
  end;

  TTabBtnState = (tbsNormal, tbsPushed, tbsHot);

  TResultTabSheet = class(TTabSheet)
  private
    FListView:    TSearchListView;
    FCloseButtonRect: TRect;
    FCloseBtnState: TTabBtnState;
    function      GetCaption: string;
    procedure     SetCaption(Value: string);
  public
    constructor   Create(AOwner: TComponent); override;
    destructor    Destroy; override;
    property      ListView: TSearchListView read FListView;
    property      Caption: string read GetCaption write SetCaption;
  end;

  TResultPageControl = class(TPageControl)
  private
    FTabBtnPad:   string;
    FMouseTab:    TResultTabSheet;
    procedure     CMMouseLeave(var Message: TMessage); message CM_MOUSELEAVE;
    function      GetActiveListView: TSearchListView;
    function      GetActivePage: TResultTabSheet;
    procedure     SetActivePage(Value: TResultTabSheet);
    function      GetTabPadding: string;
  protected
    procedure     MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure     MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure     MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure     Change; override;
    ///procedure     DrawTab(TabIndex: Integer; const Rect: TRect; Active: Boolean); override;
  public
    constructor   Create(AOwner: TComponent); override;
    function      AddPage: TResultTabSheet;
    procedure     RemovePage(Page: TResultTabSheet);
    property      ActiveList: TSearchListView read GetActiveListView;
    property      ActivePage: TResultTabSheet read GetActivePage write SetActivePage;
    property      TabPadding: string read GetTabPadding write FTabBtnPad;
  end;

  {$IFDEF REGEXPR}
  TRegStatement = class
  private
    fRegex:      TRegExpr;
    fArgument:   string;
    fNegate:     Boolean;
  public
    constructor Create;
    destructor  Destroy; override;
    property    Regex: TRegExpr read fRegex;
    property    Argument: string read fArgument write fArgument;
    property    Negate: Boolean read fNegate write fNegate;
  end;

  TSimpleParser = class(TObjectList)
  private
    fStatement: string;
    function      GetItem(Index: Integer): TRegStatement;
    procedure     SetStatement(Value: string);
    function      GetNextExpression(Content: PChar; var Expression: string): Integer;
    procedure     ParseExpression(Expression: string);
    procedure     ParseStatement(Statement: string);
  public
    property Statement: string read fStatement write SetStatement;
    property Items[Index: Integer]: TRegStatement read GetItem; default;
  end;
  {$ENDIF}

  TSearchFrm = class(TForm)
    StatusBar: TStatusBar;
    PopupMenu1: TPopupMenu;
    pbGoto: TMenuItem;
    Panel1: TPanel;
    pbProperties: TMenuItem;
    ActionList: TActionList;
    ActStart: TAction;
    ActGoto: TAction;
    ActProperties: TAction;
    ActSave: TAction;
    ActEdit: TAction;
    ActClose: TAction;
    Editentry1: TMenuItem;
    N1: TMenuItem;
    ResultPanel: TPanel;
    Panel2: TPanel;
    Panel40: TPanel;
    Panel41: TPanel;
    Label5: TLabel;
    cbBasePath: TComboBox;
    PathBtn: TButton;
    Bevel1: TBevel;
    Panel4: TPanel;
    PageControl: TPageControl;
    TabSheet1: TTabSheet;
    Label6: TLabel;
    Label7: TLabel;
    edName: TEdit;
    edEmail: TEdit;
    TabSheet2: TTabSheet;
    Label1: TLabel;
    Memo1: TMemo;
    cbFilters: TComboBox;
    SaveFilterBtn: TButton;
    DeleteFilterBtn: TButton;
    TabSheet3: TTabSheet;
    Label4: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    cbAttributes: TComboBox;
    edAttrBtn: TButton;
    cbSearchLevel: TComboBox;
    cbDerefAliases: TComboBox;
    Panel3: TPanel;
    StartBtn: TBitBtn;
    ToolBar1: TToolBar;
    btnSearch: TToolButton;
    btnModify: TToolButton;
    ToolButton3: TToolButton;
    ToolButton4: TToolButton;
    ToolButton5: TToolButton;
    ToolButton6: TToolButton;
    ToolButton7: TToolButton;
    ToolButton8: TToolButton;
    ToolButton9: TToolButton;
    ActClearAll: TAction;
    ClearAllBtn: TButton;
    TabSheet4: TTabSheet;
    cbRegExp: TComboBox;
    btnSaveRegEx: TButton;
    btnDeleteRegEx: TButton;
    Label8: TLabel;
    edRegExp: TEdit;
    cbxReGreedy: TCheckBox;
    cbxReCase: TCheckBox;
    cbxReMultiline: TCheckBox;
    ActLoad: TAction;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    OpenDialog: TOpenDialog;
    ActCopy: TAction;
    Copy1: TMenuItem;
    ActMove: TAction;
    Move1: TMenuItem;
    N2: TMenuItem;
    ActDelete: TAction;
    Delete1: TMenuItem;
    ActSaveSelected: TAction;
    N3: TMenuItem;
    Save1: TMenuItem;
    Saveselected1: TMenuItem;
    sbCustom1: TSpeedButton;
    sbCustom2: TSpeedButton;
    edCustom1: TEdit;
    edCustom2: TEdit;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    procedure PathBtnClick(Sender: TObject);
    procedure ActStartExecute(Sender: TObject);
    procedure ActGotoExecute(Sender: TObject);
    procedure ActPropertiesExecute(Sender: TObject);
    procedure ActSaveExecute(Sender: TObject);
    procedure ActEditExecute(Sender: TObject);
    procedure ActCloseExecute(Sender: TObject);
    procedure ActionListUpdate(Action: TBasicAction; var Handled: Boolean);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure ListViewDblClick(Sender: TObject);
    procedure edAttrBtnClick(Sender: TObject);
    procedure cbFiltersChange(Sender: TObject);
    procedure SaveFilterBtnClick(Sender: TObject);
    procedure DeleteFilterBtnClick(Sender: TObject);
    procedure cbFiltersDropDown(Sender: TObject);
    procedure FormDeactivate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure btnSearchModifyClick(Sender: TObject);
    procedure ActClearAllExecute(Sender: TObject);
    {$IFNDEF VER_XEH}
    procedure TabSheet2Resize(Sender: TObject);
    procedure TabSheet3Resize(Sender: TObject);
    procedure TabSheet4Resize(Sender: TObject);
    {$ENDIF}
    procedure cbRegExpChange(Sender: TObject);
    procedure cbRegExpDropDown(Sender: TObject);
    procedure btnSaveRegExClick(Sender: TObject);
    procedure btnDeleteRegExClick(Sender: TObject);
    procedure ActLoadExecute(Sender: TObject);
    procedure ActCopyExecute(Sender: TObject);
    procedure ActMoveExecute(Sender: TObject);
    procedure ActDeleteExecute(Sender: TObject);
    procedure sbCustom1Click(Sender: TObject);
    procedure sbCustom2Click(Sender: TObject);
  private
    Connection: TConnection;
    ResultPages: TResultPageControl;
    ModifyBox: TModifyBox;
    fSearchFilter: string;
    {$IFDEF REGEXPR}
    fSimpleParser: TSimpleParser;
    {$ENDIF}
    SaveDialog: TSaveDialogWrapper;
    procedure Search(const Filter, Attributes: string);
    procedure Modify(const Filter, Attributes: string);
    {$IFDEF REGEXPR}
    procedure EvaluateRegex(SearchList: TSearchList);
    {$ENDIF}
    procedure SaveItem(Combo: TComboBox; const RegPath, Content: string);
    procedure DeleteItem(Combo: TComboBox; const RegPath: string);
    procedure ComboDropDown(Combo: TComboBox; const RegPath: string);
    procedure ComboChange(Combo: TComboBox; const RegPath: string; SaveBtn, DeleteBtn: TButton; Edit: TCustomEdit);
    function  GetCustomFilter(var ACaption, AFilter: string): Boolean;
    procedure HandleCustomChange(Btn: TSpeedButton; lbl: TLabel; edInput, edContent: TEdit; RestoreCaption: string);
  public
    constructor Create(AOwner: TComponent; const dn: string; AConnection: TConnection); reintroduce;
    procedure   SessionDisconnect(Sender: TObject);
    procedure   ShowModify;
    procedure CopyMove(Move: Boolean);
  end;

var
  SearchFrm: TSearchFrm;

implementation

{$R *.dfm}

uses
  EditEntry, Constant, Main, Ldif, PickAttr, Config, Dsml, Params, ObjectInfo,
  ParseErr, Misc, LdapCopy, LdapOp, ListViewDlg
  {$IFDEF VER_XEH}, System.Types{$ENDIF};

{$IFDEF VER_XEH}
function FileEncodingToEncodingClass(Encoding: TFileEncode): TEncoding;
begin
  case Encoding of
    feAnsi: Result := TEncoding.Ansi;
    feUnicode_BE: Result := TEncoding.BigEndianUnicode;
    feUnicode_LE: Result := TEncoding.Unicode;
  else
    Result := TEncoding.UTF8;
  end;
end;
{$ENDIF}

{ TSearch }

constructor TSearchList.Create(Session: TLdapSession; ABase, AFilter, AAttributes: string; ASearchLevel, ADerefAliases: Integer; AStatusBar: TStatusBar);
var
  i: integer;
  attrs: array of string;
  CallBackProc: TSearchCallback;
  sdref: Integer;
begin
  FAttributes:=TStringList.Create;
  FAttributes.Sorted := true;
  FAttributes.Duplicates := dupIgnore;
  FAttributes.CommaText := AAttributes;
  FEntries:=TLdapEntryList.Create;

  if Assigned(AStatusBar) then
    CallbackProc := SearchCallback
  else
    CallbackProc := nil;
  sdref := Session.DereferenceAliases;
  Session.DereferenceAliases := ADerefAliases;
  fStatusBar := AStatusBar;
  try
    setlength(attrs, FAttributes.Count+1);
    for i:=0 to FAttributes.Count-1 do
      attrs[i]:=FAttributes[i];
    attrs[FAttributes.Count] := 'objectclass';
    Session.Search(AFilter, ABase, ASearchLevel, attrs, false, FEntries, CallbackProc);
  finally
    Session.DereferenceAliases := sdref;
  end;
  AStatusBar.Panels[1].Text := Format(stCntObjects, [FEntries.Count]);
end;

destructor TSearchList.Destroy;
begin
  FAttributes.Free;
  FEntries.Free;
  inherited;
end;

procedure TSearchList.SearchCallback(Sender: TLdapEntryList; var AbortSearch: Boolean);
begin
  fStatusBar.Panels[1].Text := Format(stRetrieving, [Sender.Count]);
  fStatusBar.Repaint;
  if PeekKey = VK_ESCAPE then
    AbortSearch := true;
end;

{ TModifyPanel }

procedure TModifyPanel.Save(Node: TXmlNode);
var
  sl: TStringList;
begin
  if (Ctrls[1] as TComboBox).Text = '' then
    exit;
  sl := TStringList.Create;
  try
    sl.Add('');
    case (Ctrls[0] as TComboBox).ItemIndex of
      LdapOpAdd:     sl[0] := CMOD_XML_MODOP + '=add';
      LdapOpReplace: sl[0] := CMOD_XML_MODOP + '=replace';
      LdapOpDelete:  sl[0] := CMOD_XML_MODOP + '=delete';
    end;
    with Node.Add(CMOD_XML_LDAPOP, '', sl) do begin
      Add('attribute', (Ctrls[1] as TComboBox).Text);
      Add('value1', (Ctrls[2] as TEdit).Text);
      if (Ctrls[0] as TComboBox).ItemIndex = LdapOpReplace then
        Add('value2', (Ctrls[3] as TEdit).Text);
    end;
  finally
    sl.Free;
  end;
end;

procedure TModifyPanel.Load(Node: TXmlNode);
var
  s: string;
  vNode: TXmlNode;
begin
  if Node.Name <> CMOD_XML_LDAPOP then
    exit;
  if not Assigned(Node.Attributes) or (Node.Attributes.Count = 0) then
    raise Exception.CreateFmt(stMissingOperator, [CMOD_XML_MODOP]);
  s := Copy(Node.Attributes[0], Pos('=', Node.Attributes[0]) + 1, MaxInt);

  with Ctrls[0] as TComboBox do begin
    if s = CMOD_XML_ADD then
      ItemIndex := CMOD_IDX_ADD
    else
    if s = CMOD_XML_DELETE then
      ItemIndex := CMOD_IDX_DELETE
    else
    if s = CMOD_XML_REPLACE then
      ItemIndex := CMOD_IDX_REPLACE
    else
      raise Exception. CreateFmt(stUnsuppOperation, [s]);

    (Self.Parent as TModifyBox).OpComboChange(Ctrls[0]);

    vNode := Node.NodeByName('attribute');
    if Assigned(vNode) then
      (ctrls[1] as TComboBox).Text := vNode.Content;
    vNode := Node.NodeByName('value1');
    if Assigned(vNode) then
      (ctrls[2] as TEdit).Text := vNode.Content;
    if ItemIndex = CMOD_IDX_REPLACE then
    begin
      vNode := Node.NodeByName('value2');
      if Assigned(vNode) then
        (ctrls[3] as TEdit).Text := vNode.Content;
    end;
  end;
end;

{ TModifyBox }

procedure TModifyBox.DoTimer(Sender: TObject);
begin
  if FindDragTarget(Mouse.Cursorpos, false) = fCloseButton then 
    Screen.Cursor := crDefault
  else
    Screen.Cursor := crHourglass;
end;

procedure TModifyBox.ButtonClick(Sender: TObject);
begin
  if fState <> mbxRunning then
    Reset
  else
    fState := mbxDone;
end;

procedure TModifyBox.OpComboChange(Sender: TObject);
var
  i, l: Integer;

  function NewControl(AControl: TControlClass; ACaption: string): TControl;
  var
    i: Integer;
    p: TWinControl;
  begin
    p := TWinControl(Sender).Parent;
    Result := AControl.Create(p);
    with Result do begin
      Left := l;
      Top := MODPANEL_CTRL_TOP;
      Parent := p;
    end;
    with TLabel.Create(p) do begin
      Left := l;
      Top := MODPANEL_LABEL_TOP;
      Caption := ACaption;
      Parent := p;
    end;
    inc(l, Result.Width + MODPANEL_CTRL_SPACING);

    if AControl = TComboBox then
    begin
      TComboBox(Result).DropDownCount := 16;
      TComboBox(Result).Sorted := true;
      if fSchema.Loaded then
        for i := 0 to fSchema.Attributes.Count - 1 do
          TComboBox(Result).Items.Add(fSchema.Attributes[i].Name[0]);
    end;
  end;

begin
  with (Sender as TComboBox) do
  begin
    if Tag = 0 then
    begin
      AddPanel;
      Tag := 1;
    end;

    { Operation combo and it's label are owned by ScrollBox and therefore not freed }
    for i := Parent.ComponentCount - 1 downto 0 do
      Parent.Components[i].Free;

    l := MODPANEL_LEFT_IND + MODPANEL_OP_COMBO_WIDTH + MODPANEL_CTRL_SPACING;
    with TWinControl(Sender).Parent as TModifyPanel do
    case ItemIndex of
      0: begin
           Ctrls[1] := NewControl(TComboBox, cAttribute);
           Ctrls[2] := NewControl(TEdit, cValue);
         end;
      1: begin
           Ctrls[1] := NewControl(TComboBox, cAttribute);
           Ctrls[2] := TEdit(NewControl(TEdit, cValue));
           TEdit(Ctrls[2]).Text := '*';
         end;
      2: begin
           Ctrls[1] := NewControl(TComboBox, cAttribute);
           Ctrls[2] := NewControl(TEdit, cOldValue);
           Ctrls[3] := NewControl(TEdit, cNewValue);
         end;
    end;
  end;
  fState := mbxReady;
end;

procedure TModifyBox.AddPanel;
var
  Panel: TModifyPanel;
begin
  Panel := TModifyPanel.Create(Self);
  Panel.Parent := Self;
  Panel.Align := alBottom;
  Panel.Align := alTop;
  Panel.Height := MODPANEL_HEIGHT;
  Panel.Ctrls[0] := TComboBox.Create(Self);
  with TComboBox(Panel.Ctrls[0]) do
  begin
    Parent := Panel;
    Style := csDropDownList;
    Items.CommaText := cAddDelReplace;
    Width := MODPANEL_OP_COMBO_WIDTH;
    Top := MODPANEL_CTRL_TOP;
    Left := MODPANEL_LEFT_IND;
    OnChange := OpComboChange;
  end;
  with TLabel.Create(Self) do
  begin
    Caption := cOperation;
    Top := MODPANEL_LABEL_TOP;
    Left := MODPANEL_LEFT_IND;
    Parent := Panel;
  end;
end;

procedure TModifyBox.Reset;
var
  i: Integer;
begin
  fSbPanel.Parent := Parent;
  fMemo.Clear;
  fSbPanel.Parent := nil;
  fProgressBar.Position := 0;
  fCloseButton.Caption := cCancel;
  fOpList.Clear;
  FreeAndNil(fSearchList);
  for i := 0 to ControlCount - 1 do
    Controls[i].Visible := true;
  fState := mbxReady;
end;


procedure TModifyBox.Resize;
begin
  inherited;
  if Assigned(fMemo) then fMemo.Height := fSbPanel.Height - 32;
end;

procedure TModifyBox.Run;
var
  i: Integer;
  op: TModifyOp;
  StopOnError: Boolean;

  procedure Add(Entry: TLdapEntry; AName, AValue: string);
  begin
    if AValue <> '' then
      Entry.AttributesByName[AName].AddValue(AValue);
  end;

  procedure Replace(Entry: TLdapEntry; AName, OldValue, NewValue: string);
  var
    i: Integer;
  begin
    if (OldValue = '') or (NewValue = '') then Exit;
    with Entry.AttributesByName[AName] do
    for i := 0 to ValueCount - 1 do
      if Matches(OldValue, Values[i].AsString) then
        Values[i].AsString := NewValue;
  end;

  procedure Delete(Entry: TLdapEntry; AName, AValue: string);
  var
    i: Integer;
  begin
    with Entry.AttributesByName[AName] do
      for i := 0 to ValueCount - 1 do
        if Matches(AValue, Values[i].AsString) then
          Values[i].Delete;
  end;

  procedure DoModify(Entry: TLdapEntry);
  var
    i: Integer;
  begin
    for i := 0 to fOpList.Count - 1 do with TModifyOp(fOpList[i]) do
      if AttributeName <> '' then
        case LdapOperation of
          LdapOpAdd:     Add(Entry, AttributeName, FormatValue(Value1, Entry));
          LdapOpDelete:  Delete(Entry, AttributeName, FormatValue(Value1, Entry));
          LdapOpReplace: Replace(Entry, AttributeName, FormatValue(Value1, Entry), FormatValue(Value2, Entry));
        end;
    if esModified in Entry.State then
    begin
      Entry.Write;
      fMemo.Lines.Add(Entry.dn + ': ' + cModifyOk);
    end
    else
      fMemo.Lines.Add(Entry.dn + ': ' + cModifySkipped);
  end;

begin
  if not Assigned(fSearchList) then Exit;

  for i := ControlCount - 1 downto 0 do with (Controls[i] as TModifyPanel) do
  begin
    if (Ctrls[1] as TComboBox).Text <> '' then
    begin
      op := TModifyOp.Create;
      fOpList.Add(op);
      op.LdapOperation := (Ctrls[0] as TComboBox).ItemIndex;
      op.AttributeName := (Ctrls[1] as TComboBox).Text;
      op.Value1 := (Ctrls[2] as TEdit).Text;
      if op.LdapOperation = LdapOpReplace then
        op.Value2 := (Ctrls[3] as TEdit).Text;
    end;
    Visible := false;
  end;

  fProgressBar.Max := SearchList.Entries.Count;
  fSbPanel.Parent := Self; // show the result panel;
  fSbPanel.Repaint;

  StopOnError := true;
  fState := mbxRunning;
  fTimer.Enabled := true;
  for i := 0 to SearchList.Entries.Count - 1 do
  begin
    try
      DoModify(fSearchList.Entries[i]);
      Application.ProcessMessages;
      if fState <> mbxRunning then Break;
    except
      on E: Exception do begin
        fTimer.Enabled := false;
        ///fMemo.SelAttributes.Color := clRed;
        fMemo.Lines.Add(fSearchList.Entries[i].dn + ': ' + E.Message);
        if StopOnError then
          case MessageDlgEx(Format(stSkipRecord, [E.Message]), mtError, [mbYes, mbNo, mbCancel], [cSkip, cSkipAll, cCancel],[]) of
            mrCancel: break;
            mrNo: StopOnError := false;
          end;
        fTimer.Enabled := true;
      end;
    end;
    fProgressBar.StepIt;
  end;
  fTimer.Enabled := false;
  fState := mbxDone;
  fCloseButton.Caption := cOk;
end;

procedure TModifyBox.Save(const Filename: string; Encoding: TFileEncode);
var
  xmlTree: TXmlTree;
  i: Integer;
begin
  xmlTree := TXmlTree.Create;
  XmlTree.Root.Name := CMOD_XML_ROOT_NAME;
  try
    xmlTree.Encoding := Encoding;
    for i := 0 to ControlCount - 1 do
      (Controls[i] as TModifyPanel).Save(XmlTree.Root);
    xmlTree.SaveToFile(Filename);
  finally
    xmlTree.Free;
  end;
end;

procedure TModifyBox.Load(const Filename: string);
var
  xmlTree: TXmlTree;
  i: Integer;
begin
  xmlTree := TXmlTree.Create;
  try
    xmlTree.LoadFromFile(FileName);
    if xmlTree.Root.Name <> CMOD_XML_ROOT_NAME then
      raise Exception.CreateFmt(stNotLABatchFile, [FileName]);
    New;
    for i:=0 to xmlTree.Root.Count-1 do
      (Controls[ControlCount - 1] as TModifyPanel).Load(xmlTree.Root[i]);
  finally
    xmlTree.Free;
  end;
end;

procedure TModifyBox.SaveResults(const Filename: string; Encoding: TFileEncode);
begin
  {$IFDEF VER_XEH}
  fMemo.Lines.SaveToFile(FileName, FileEncodingToEncodingClass(Encoding));
  {$ELSE}
  fMemo.Lines.SaveToFile(FileName);
  {$ENDIF}
end;

constructor TModifyBox.Create(AOwner: TComponent; AConnection: TConnection);
var
  L: TLabel;
begin
  inherited Create(AOwner);
  fOpList := TObjectList.Create;
  fSchema := AConnection.Schema;
  fTimer := TTimer.Create(Self);
  fTimer.Enabled := false;
  fTimer.Interval := 50;
  fTimer.OnTimer := DoTimer;
  fSbPanel := TPanel.Create(Self);
  with fSbPanel do begin
    Parent := Self;
    Align := alClient;
  end;
  fProgressBar := TProgressBar.Create(fSbPanel);
  fCloseButton := TButton.Create(fSbPanel);
  with fCloseButton do begin
    Parent := fSbPanel;
    Height := 23;
    Width := 65;
    Top := MODPANEL_LABEL_TOP - 4;
    Left := fSBPanel.Width - Width - MODPANEL_LEFT_IND;
    Caption := cCancel;
    Anchors := [akTop, akRight];
    OnClick := ButtonClick;
  end;
  L := TLabel.Create(fSbPanel);
  with L do begin
    Left := MODPANEL_LEFT_IND;
    Top := MODPANEL_LABEL_TOP;
    Caption := cProgress;
    Parent := fSbPanel;
  end;
  with fProgressBar do begin
    Parent := fSbPanel;
    Top := MODPANEL_LABEL_TOP;
    Left := L.Width + 2 * MODPANEL_LEFT_IND;
    Width := fCloseButton.Left - Left - MODPANEL_LEFT_IND;
    Anchors := Anchors + [akRight];
    Step := 1;
  end;
  ///fMemo := TRichEdit.Create(fSbPanel);
  fMemo := TMemo.Create(fSbPanel);
  with fMemo do begin
    Parent := fSbPanel;
    Align := alBottom;
    ScrollBars := ssAutoBoth;
    ReadOnly := true;
  end;
end;

destructor TModifyBox.Destroy;
begin
  fOpList.Free;
  FSearchList.Free;
  inherited;
end;

procedure TModifyBox.New;
begin
  Reset;
  while ControlCount > 0 do Controls[0].Free;
  AddPanel;
  fState := mbxNew;
end;

{ TResultsPageControl }

procedure TResultPageControl.CMMouseLeave(var Message: TMessage);
begin
  if Assigned(FMouseTab) then
    FMouseTab.FCloseBtnState := tbsNormal;
  Repaint;
end;

function TResultPageControl.GetActiveListView: TSearchListView;
begin
  if Assigned(ActivePage) then
    Result := TResultTabSheet(ActivePage).ListView
  else
    Result := nil;
end;

function TResultPageControl.GetActivePage: TResultTabSheet;
begin
  Result := TResultTabSheet(inherited ActivePage);
end;

procedure TResultPageControl.SetActivePage(Value: TResultTabSheet);
begin
  inherited ActivePage := Value;
end;

function TResultPageControl.GetTabPadding: string;
var
  cnt: Integer;
begin
  if FTabBtnPad = '' then
  begin
    ///cnt := Round(TAB_CLOSE_BTN_SIZE / SearchFrm.Canvas.TextWidth(' '));
    cnt := Round(TAB_CLOSE_BTN_SIZE / 15);
    while cnt >= 0 do begin
      FTabBtnPad := FTabBtnPad + ' ';
      dec(cnt);
    end;
  end;
  Result := FTabBtnPad;
end;

procedure TResultPageControl.Change;
begin
  inherited;
  with (ActivePage as TResultTabSheet) do
    if Assigned(ActiveList) then with ActiveList.SearchList do
      fStatusBar.Panels[1].Text := Format(stCntObjects, [FEntries.Count]);
end;
(*
procedure TResultPageControl.DrawTab(TabIndex: Integer; const Rect: TRect; Active: Boolean);
var
  TabSheet: TResultTabSheet;
  TabCaption: TPoint;
  CloseBtnRect: TRect;
  {$IFDEF XPSTYLE}
  CloseBtnDrawDetails: TThemedElementDetails;
  {$ENDIF}
  CloseBtnDrawState: Cardinal;
begin
  TabCaption.Y := Rect.Top + 3;

  if Active then
  begin
    CloseBtnRect.Top := Rect.Top + 4;
    CloseBtnRect.Right := Rect.Right - 5;
    TabCaption.X := Rect.Left + 6;
  end
  else
  begin
    CloseBtnRect.Top := Rect.Top + 3;
    CloseBtnRect.Right := Rect.Right - 5;
    TabCaption.X := Rect.Left + 3;
  end;

  if Pages[TabIndex] is TResultTabSheet then
  begin
    TabSheet := Pages[TabIndex] as TResultTabSheet;

    CloseBtnRect.Bottom := CloseBtnRect.Top + TAB_CLOSE_BTN_SIZE;
    CloseBtnRect.Left := CloseBtnRect.Right - TAB_CLOSE_BTN_SIZE;
    TabSheet.FCloseButtonRect := CloseBtnRect;

    Canvas.FillRect(Rect);
    Canvas.TextOut(TabCaption.X, TabCaption.Y, Pages[TabIndex].Caption);

    {$IFDEF XPSTYLE}
    if ThemeServices.ThemesEnabled then
    begin
      Dec(TabSheet.FCloseButtonRect.Left);
      case TabSheet.FCloseBtnState of
        tbsNormal: CloseBtnDrawDetails := ThemeServices.GetElementDetails(twSmallCloseButtonNormal);
        tbsHot:    CloseBtnDrawDetails := ThemeServices.GetElementDetails(twSmallCloseButtonHot);
        tbsPushed: CloseBtnDrawDetails := ThemeServices.GetElementDetails(twSmallCloseButtonPushed);
      end;
      ThemeServices.DrawElement(Canvas.Handle, CloseBtnDrawDetails, TabSheet.FCloseButtonRect);
    end
    else
    {$ENDIF}
    begin
      case TabSheet.FCloseBtnState of
        tbsNormal: CloseBtnDrawState := DFCS_CAPTIONCLOSE + DFCS_INACTIVE;
        tbsHot:    CloseBtnDrawState := DFCS_CAPTIONCLOSE;
        tbsPushed: CloseBtnDrawState := DFCS_CAPTIONCLOSE + DFCS_PUSHED;
      end;
      Windows.DrawFrameControl(Canvas.Handle,
        TabSheet.FCloseButtonRect, DFC_CAPTION, CloseBtnDrawState);
    end;
  end;
end;
*)
constructor TResultPageControl.Create(AOwner: TComponent);
begin
  inherited;
  OwnerDraw := true;
end;

function TResultPageControl.AddPage: TResultTabSheet;
begin
  result:=TResultTabSheet.Create(self);
  result.PageControl:=self;
end;

procedure TResultPageControl.RemovePage(Page: TResultTabSheet);
begin
  { Removing of the last tab in tab area forces PageControl to redraw it. }
  { Otherwise, traces of text may be left visible due to custom DrawTab.  }
  Page.PageIndex := Page.PageControl.PageCount - 1;
  Page.PageControl:=nil;
  Page.Free;
end;

procedure TResultPageControl.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if (Button = mbLeft) and Assigned(FMouseTab) and
    (FMouseTab.FCloseBtnState = tbsHot) then
  begin
    FMouseTab.FCloseBtnState := tbsPushed;
    Repaint;
  end
  else
    inherited;
end;

procedure TResultPageControl.MouseMove(Shift: TShiftState; X, Y: Integer);
var
  CloseBtnState: TTabBtnState;
  InRect, NeedRepaint: Boolean;
  I: Integer;
  TabSheet: TResultTabSheet;
begin
  InRect := false;
  TabSheet := nil;
  for i := 0 to PageCount - 1 do if Pages[i] is TResultTabSheet then
  begin
    TabSheet := TResultTabSheet(Pages[i]);
    InRect := PtInRect(TabSheet.FCloseButtonRect, Point(X, Y));
    if InRect then
      break;
  end;

  if InRect then
  begin
    if (ssLeft in Shift) then
      CloseBtnState := tbsPushed
    else
      CloseBtnState := tbsHot;
  end
  else
    CloseBtnState := tbsNormal;

  NeedRepaint := false;

  if (TabSheet <> FMouseTab) and Assigned(FMouseTab) and (FMouseTab.FCloseBtnState <> tbsNormal) then
  begin
    FMouseTab.FCloseBtnState := tbsNormal;
    NeedRepaint := true;
  end;

  if Assigned(TabSheet) and (TabSheet.FCloseBtnState <> CloseBtnState) then
  begin
    TabSheet.FCloseBtnState := CloseBtnState;
    NeedRepaint := true;
  end;

  FMouseTab := TabSheet;

  if NeedRepaint then
    Repaint;

  inherited;
end;

procedure TResultPageControl.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if (Button = mbLeft) and Assigned(FMouseTab) and
    (FMouseTab.FCloseBtnState = tbsPushed) then
  begin
    RemovePage(FMouseTab);
    FMouseTab := nil;
    Repaint;
  end
  else
    inherited;
end;

{ TSearchListView }

constructor TSearchListView.Create(AOwner: TComponent);
begin
  inherited;
  FSorter := TListViewSorter.Create;
  FSorter.ListView := Self;
  FSorter.OnSort := ListViewSort;
  ViewStyle:=vsReport;
  ReadOnly:=true;
  RowSelect:=true;
  GridLines:=true;
  OwnerData:=true;
  DoubleBuffered:=true;
  OnData:=ListViewData;
  FullDrag:=true;
  SmallImages:=MainFrm.ImageList;
  Multiselect := true;
  DragMode := dmAutomatic;
  with Columns.Add do begin
    Caption:='DN';
    Width:=150;
    Tag:=-1;
  end;
  ///
  ScrollBars:=ssAutoBoth;
end;

destructor TSearchListView.Destroy;
begin
  inherited;
  FSearchList.Free;
  FSorter.Free;
end;

procedure TSearchListView.GetSelection(List: TStringList);
var
  SelItem: TListItem;
begin
  SelItem := Selected;
  while Assigned(SelItem) do begin
    List.Add(TLdapEntry(SelItem.Data).dn);
    SelItem:= GetNextItem(SelItem, sdAll, [lisSelected]);
  end;
end;

procedure TSearchListView.CopySelection(TargetSession: TLdapSession; TargetDn, TargetRdn: string; Move: Boolean);
var
  List: TStringList;
begin
  List := TStringList.Create;
  try
    GetSelection(List);
    MainFrm.DoCopyMove(List, TargetSession, TargetDn, TargetRdn, Move);
    if Move then
      AdjustPaths(List, TargetDn, TargetRdn);
  finally
    List.Free
  end;
end;

procedure TSearchListView.DeleteSelection;
var
  List: TStringList;
begin
  List := TStringList.Create;
  try
    GetSelection(List);
    MainFrm.DoDelete(List);
    RemoveFromList(List);
  finally
    List.Free
  end;
end;

procedure TSearchListView.ListViewData(Sender: TObject; Item: TListItem);
var
  i: integer;
  Entry: TLdapEntry;
begin
  with SearchList do begin
    Entry := Entries[Item.Index];
    Item.ImageIndex := (Entry.Session as TConnection).GetImageIndex(Entry);
    Item.Caption:=Entry.dn;
    Item.Data := Entry;
    for i:=0 to Attributes.Count-1 do begin
      Item.SubItems.Add(Entry.AttributesByName[Attributes[i]].AsString);
    end;
  end;
end;

procedure TSearchListView.ListViewSort(SortColumn: TListColumn; SortAsc: boolean);
begin
  if not Assigned(SearchList) then exit;
  with SearchList do
  if SortColumn.Tag<0 then Entries.Sort([PSEUDOATTR_DN], SortAsc)
  else Entries.Sort([Attributes[SortColumn.Tag]], SortAsc);
  Repaint;
end;

procedure TSearchListView.SetSearchList(ASearchList: TSearchList);
var
  i, w: integer;
begin
  try
    FSearchList := ASearchList;
    Items.BeginUpdate;
    Columns.BeginUpdate;
    w := Width;
    if FSearchList.Attributes.Count > 0 then
      w := (w - 400) div FSearchList.Attributes.Count;
    if w < 40 then w := 40;
    for i:=0 to FSearchList.Attributes.Count-1 do begin
      if FSearchList.Attributes[i] <> '*' then
      with Columns.Add do begin
        Caption:=FSearchList.Attributes[i];
        Width:=w;
        Tag:=i;
      end;
    end;
    Columns[0].Width := 400;
  finally
    Columns.EndUpdate;
    Items.EndUpdate;
  end;
  Items.Count:=FSearchList.Entries.Count;
end;

procedure TSearchListView.RemoveFromList(List: TStringList);
var
  i, idx: Integer;

  procedure RemoveEntry(var EndIndex: Integer; Value: string);
  var
    i: Integer;
  begin
    with SearchList.Entries do
      for i := 0 to EndIndex do
        if Items[i].dn = Value then
        begin
          EndIndex := i;
          Self.Items[i].Selected := false;
          Delete(i);
          Exit;
        end;
  end;

begin
  idx := Items.Count - 1;
  for i := List.Count - 1 downto 0 do
  if List.Objects[i] = LDAP_OP_SUCCESS then
    RemoveEntry(idx, List[i]);
  Items.Count := SearchList.Entries.Count;
  if idx >= Items.Count then
    idx := Items.Count - 1;
  if idx >= 0 then with Items[idx] do
  begin
    Selected := true;
    Focused := true;
  end;
  Selected.MakeVisible(true);
  Repaint;
end;

procedure TSearchListView.AdjustPaths(List: TStringList; TargetDn, TargetRdn: string);
var
  i, idx: Integer;

  procedure AdjustItem(var StartIndex: Integer; Value: string);
  var
    i: Integer;
    rdn: string;
  begin
    with SearchList.Entries do
      for i := StartIndex to Count - 1 do with Items[i] do
      if dn = Value then
      begin
        StartIndex := i;
        if TargetRdn <> '' then
          rdn := TargetRdn
        else
          rdn := GetRdnFromDn(dn);
        dn := rdn + ',' + TargetDn;
        Exit;
      end;
    end;

begin
  for i := 0 to List.Count - 1 do
  if List.Objects[i] = LDAP_OP_SUCCESS then
    AdjustItem(idx, List[i]);
  Repaint;
end;

{ TResultTabSheet }

function TResultTabSheet.GetCaption: string;
begin
  Result := TTabSheet(Self).Caption;
end;

procedure TResultTabSheet.SetCaption(Value: string);
begin
  if PageControl is TResultPageControl then
    TTabSheet(Self).Caption := Value + TResultPageControl(PageControl).TabPadding
  else
    TTabSheet(Self).Caption := Value;
end;

constructor TResultTabSheet.Create(AOwner: TComponent);
begin
  inherited;
  FListView := TSearchListView.Create(self);
  FListView.Parent := Self;
  FListView.Align := alClient;
end;

destructor TResultTabSheet.Destroy;
begin
  FListView.Free;
  inherited;
end;

{$IFDEF REGEXPR}

{ TRegStatement }

constructor TRegStatement.Create;
begin
  inherited;
  fRegex := TRegExpr.Create;
end;

destructor  TRegStatement.Destroy;
begin
  fRegex.Free;
  inherited Destroy;
end;

{ TSimpleParser }

function TSimpleParser.GetItem(Index: Integer): TRegStatement;
begin
  Result := TRegStatement(TObjectList(Self).Items[Index]);
end;

procedure TSimpleParser.SetStatement(Value: string);
begin
  fStatement := Value;
  Clear;
  ParseStatement(Value);
end;

function TSimpleParser.GetNextExpression(Content: PChar; var Expression: string): Integer;
var
  p, p1: PChar;
  Compound: Boolean;
begin
  Result := 0;
  Expression := '';
  if (Content = nil) or (Content^ = #0) then Exit;
  p := Content;
  Compound := false;

  while p^ in [' ', #13, #10] do p := CharNext(p);
  if p^ = '(' then
  begin
    Compound := true;
    p := CharNext(p);
  end;

  while p^ in [' ', #13, #10] do p := CharNext(p);

  while not (p^ in [#0, #13, #10, '(', ')']) do
  begin
    if p^ = '\' then
    begin
      p1 := CharNext(p);
      if p1^ in ['(', ')'] then
        p := p1;
    end;
    Expression := Expression + p^;
    p := CharNext(p);
  end;

  if p^ = ')' then
  begin
    if not Compound then
      raise Exception.CreateFmt(stRegexError, [Expression + p^, stNoOpeningParenthesis]);
    p := CharNext(p);
  end
  else if Compound then
    raise Exception.CreateFmt(stRegexError, ['(' + Expression, stNoClosingParenthesis]);

  Result := p - Content;
end;

procedure TSimpleParser.ParseExpression(Expression: string);
var
  Head, Tail, Cut: PChar;
  RegStatement: TRegStatement;
  s: string;
begin
  Head := PChar(Expression);
  Tail := Head;
  Cut := Head;
  RegStatement := TRegStatement.Create;
  Add(RegStatement);
  while not (Tail^ in [#0, #13, #10]) do
  begin
    case Tail^ of
      '!': begin
             RegStatement.Negate := true;
             Cut := Tail;
             Tail := CharNext(Tail);
             if Tail^ <> '=' then
               raise Exception.CreateFmt(stRegexError, [Head^, stExpectedButReceived + Tail^ + '"']);
             Continue;
           end;
      '=': begin
             if not RegStatement.Negate then
               Cut := Tail;
             if Cut = Head then
               raise Exception.CreateFmt(stRegexError, [Head, stEmptyArg]);
             { Right trim }
             Cut := CharPrev(Head, Cut);
             if Cut <> Head then
               while Cut^ = ' ' do Cut := CharPrev(Head, Cut);
             SetString(RegStatement.fArgument, Head, Cut - Head + 1);
             Tail := CharNext(Tail);
             break;
           end;
      ' ': begin
             Tail := CharNext(Tail);
             while Tail^ = ' ' do Tail := CharNext(Tail);
             if (Tail^ <> '!') and (Tail^ <> '=') then
               raise Exception.CreateFmt(stInvalidOperator, [Tail^]);
             Continue;
           end;
    end;
    Tail := CharNext(Tail);
  end;

  if Tail^ = #0 then
    raise Exception.CreateFmt(stRegexError, [Head, stMissingOperator]);

  while Tail^ in [' ', #13, #10, '('] do Tail := CharNext(Tail);
  Head := Tail;
  while not (Tail^ in [#0, #13, #10]) do Tail := CharNext(Tail);
  
  SetString(s, Head, Tail - Head);
  RegStatement.Regex.Expression := s;
  RegStatement.Regex.Compile;
end;

procedure TSimpleParser.ParseStatement(Statement: string);
var
  LastPos, Pos: Integer;
  s: string;
begin
  Pos := 1;
  LastPos := Pos;
  while true do
  begin
    Pos := GetNextExpression(PChar(@Statement[LastPos]), s);
    if Pos = 0 then break;
    inc(LastPos, Pos);
    ParseExpression(s);
  end;
end;
{$ENDIF}

{ TSearchForm }

procedure TSearchFrm.Search(const Filter, Attributes: string);
var
  Page: TResultTabSheet;
  SearchList: TSearchList;
begin
  if Assigned(ResultPages.ActivePage) and (ResultPages.ActiveList.Items.Count = 0) then
    Page := ResultPages.ActivePage
  else
    Page := ResultPages.AddPage;
  ResultPages.ActivePage := Page;
  Screen.Cursor := crHourGlass;
  try
    SearchList := TSearchList.Create(Connection,
                                     cbBasePath.Text,
                                     Filter,
                                     Attributes,
                                     cbSearchLevel.ItemIndex,
                                     cbDerefAliases.ItemIndex,
                                     StatusBar);
    {$IFDEF REGEXPR}
    EvaluateRegex(SearchList);
    {$ENDIF}
    Page.ListView.SearchList := SearchList;
    Page.Caption := Filter;
    Page.ListView.PopupMenu := PopupMenu1;
    Page.ListView.OnDblClick := ListViewDblClick;
  finally
    Screen.Cursor := crDefault;
  end;
end;

procedure TSearchFrm.Modify(const Filter, Attributes: string);
var
  attrs: string;
  i: Integer;

  procedure ExtractParams(var attrs: string; p: PChar);
  var
    s: string;
  begin
    repeat
      s := GetParameter(p);
      if (s <> '') then
      begin
       if attrs <> '' then attrs := attrs + ',';
       attrs := attrs + s;
      end
      else
        Break;
    until false;
  end;

begin
  Screen.Cursor := crHourGlass;
  try
    attrs := Attributes;
    for i := 0 to ModifyBox.ControlCount - 1 do with (ModifyBox.Controls[i] as TModifyPanel) do
    begin
      if TComboBox(Ctrls[1]).Text <> '' then
      begin
        if attrs <> '' then attrs := attrs + ',';
        attrs := attrs + TComboBox(Ctrls[1]).Text;
      end;
      ExtractParams(attrs, PChar(TEdit(Ctrls[2]).Text));
      if Assigned(Ctrls[3]) then
        ExtractParams(attrs, PChar(TEdit(Ctrls[3]).Text));
    end;
    ModifyBox.SearchList.Free;
    ModifyBox.SearchList := TSearchList.Create(Connection,
                                               cbBasePath.Text,
                                               Filter,
                                               attrs,
                                               cbSearchLevel.ItemIndex,
                                               cbDerefAliases.ItemIndex,
                                               StatusBar);
    {$IFDEF REGEXPR}
    EvaluateRegex(ModifyBox.SearchList);
    {$ENDIF}
    ModifyBox.Run;
    ActSave.Hint := cSaveBatchProtocol;
    ActLoad.Hint := '';
  finally
    Screen.Cursor := crDefault;
  end;
end;

{$IFDEF REGEXPR}
procedure TSearchFrm.EvaluateRegex(SearchList: TSearchList);
var
  i: Integer;
  s: string;

  function RegMatch(Entry: TLdapEntry): Boolean;
  var
    i, j: Integer;
    Attr: TLdapAttribute;
    t: Boolean;
  begin
    Result := true;
    for i := 0 to fSimpleParser.Count - 1 do with fSimpleParser[i] do
    begin
      t := false;
      Attr := Entry.AttributesByName[Argument];
      with Attr do begin
        for j := 0 to ValueCount - 1 do
        if Regex.Exec(Values[j].AsString) then
        begin
          t := true;
          break;
        end;
        if Negate then t := not t;
      end;
      Result := Result and t;
    end;
  end;

begin
 if (edRegexp.Text <> '') and (fSimpleParser.Count > 0) then
 begin
   s := StatusBar.Panels[1].Text;
   if s[Length(s)] = '.' then s[Length(s)] := ',';
   StatusBar.Panels[1].Text := stRegApplying;
   StatusBar.Repaint;
   for i := SearchList.Entries.Count - 1 downto 0 do
   begin
     if not RegMatch(SearchList.Entries[i]) then
       SearchList.Entries.Delete(i);
   end;
   StatusBar.Panels[1].Text := Format(stRegCntMatching, [s, SearchList.Entries.Count]);
 end;
end;
{$ENDIF}

procedure TSearchFrm.SaveItem(Combo: TComboBox; const RegPath, Content: string);
var
  idx: Integer;
begin
  with Combo do begin
    if Text = '' then Exit;
    idx := Items.IndexOf(Text);
    if idx = - 1 then
      Items.Add(Text);
    Connection.Account.WriteString(RegPath + Text, Content);
  end;
end;

procedure TSearchFrm.DeleteItem(Combo: TComboBox; const RegPath: string);
var
  idx: Integer;
begin
  with cbFilters do begin
    idx := Items.IndexOf(Text);
    if idx <> -1 then
    begin
      Connection.Account.Delete(RegPath + Text);
      Items.Delete(idx);
    end;
  end;
end;

procedure TSearchFrm.ComboDropDown(Combo: TComboBox; const RegPath: string);
var
  FilterNames: TStrings;
  i: Integer;
begin
  if Combo.Tag = 0 then
  begin
    FilterNames := TStringList.Create;
    try
      Connection.Account.GetValueNames(RegPath, FilterNames);
      for i := 0 to FilterNames.Count - 1 do
        Combo.Items.Add(FilterNames[i]);
    finally
      FilterNames.Free;
    end;
    Combo.Tag := 1;
  end;
end;

procedure TSearchFrm.ComboChange(Combo: TComboBox; const RegPath: string; SaveBtn, DeleteBtn: TButton; Edit: TCustomEdit);
var
  idx: Integer;
begin
  with Combo do begin
    SaveBtn.Enabled := Text <> '';
    DeleteBtn.Enabled := SaveFilterBtn.Enabled;
    idx := Items.IndexOf(Text);
    if idx <> -1 then
      Edit.Text := Connection.Account.ReadString(RegPath + Text);
  end;
end;

function TSearchFrm.GetCustomFilter(var ACaption, AFilter: string): Boolean;
var
  sl: TStrings;
  i: Integer;
  Item: TListItem;
begin
  with TListViewDlg.Create(Self) do
  try
    Caption := cPickQuery;
    sl := TStringList.Create;
    try
      Connection.Account.GetValueNames(rSearchCustFilters, sl);
      for i := 0 to sl.Count - 1 do
      begin
        Item := ListView.Items.Add;
        Item.Caption := sl[i];
        Item.Subitems.Add(Connection.Account.ReadString(rSearchCustFilters + sl[i]));
      end;
    finally
      sl.Free;
    end;
    Result := ShowModal = mrOk;
    if Result then
    begin
      ACaption := ListView.Selected.Caption;
      AFilter := ListView.Selected.SubItems[0];
    end;
  finally
    Free;
  end;
end;

procedure TSearchFrm.CopyMove(Move: Boolean);
var
  TargetData: TTargetData;
begin
  with ResultPages, ActiveList do
  if Assigned(ActiveList) and Assigned(ActiveList.Selected) and
     ExecuteCopyDialog(Self, TLdapEntry(Selected.Data).dn, SelCount, Move, Connection, TargetData) then
       CopySelection(TargetData.Connection, TargetData.Dn, TargetData.Rdn, Move);
end;

constructor TSearchFrm.Create(AOwner: TComponent; const dn: string; AConnection: TConnection);
begin
  inherited Create(AOwner);

  {$IFNDEF VER_XEH}
  { Delphi5 and 7 had problems with resizing of TabSheets }
  {$IFDEF VER_D7H}
  if ThemeServices.ThemesEnabled then
  begin
    TabSheet2Resize(nil);
    TabSheet3Resize(nil);
    cbBasePath.Width := PageControl.Left + PageControl.Width - cbBasePath.Left;
    PathBtn.Left := Panel3.Left + StartBtn.Left;
    PathBtn.Height := 25;
    PathBtn.Top := PathBtn.Top - 1;
  end;
  {$ENDIF}
  TabSheet2.OnResize := TabSheet2Resize;
  TabSheet3.OnResize := TabSheet3Resize;
  TabSheet4.OnResize := TabSheet4Resize;
  {$ENDIF}

  Connection := AConnection;
  if dn <> '' then
    cbBasePath.Text := dn
  else
    cbBasePath.Text := Connection.Base;
  ResultPages := TResultPageControl.Create(self);
  ResultPages.Align := alClient;
  ResultPages.Parent := ResultPanel;
  ResultPages.AddPage;
  ResultPages.ActivePage.Caption := cSearchResults;
  fSearchFilter := GlobalConfig.ReadString(rSearchFilter, sDEFSRCH);
  with Connection.Account do begin
    cbBasePath.Items.CommaText := ReadString(rSearchBase, '');
    cbAttributes.Items.CommaText := ReadString(rSearchAttributes, '');
    cbSearchLevel.ItemIndex := ReadInteger(rSearchScope, 2);
    cbDerefAliases.ItemIndex := ReadInteger(rSearchDerefAliases, 0);
    cbxReGreedy.Checked := ReadBool(rSearchRegExGreedy, true);
    cbxReCase.Checked := ReadBool(rSearchRegExCase, true);
    cbxReMultiLine.Checked := ReadBool(rSearchRegExMulti);
    Height := ReadInteger(rSearchHeight, Height);
    Width := ReadInteger(rSearchWidth, Width);
  end;
  AConnection.OnDisconnect.Add(SessionDisconnect);
  StatusBar.Panels[0].Text := Format(cServer, [AConnection.Server]);
  StatusBar.Panels[0].Width := StatusBar.Canvas.TextWidth(StatusBar.Panels[0].Text) + 16;
  ToolBar1.DisabledImages := MainFrm.DisabledImages;
  SaveDialog := TSaveDialogWrapper.Create(Self);
  with SaveDialog do begin
    FilterIndex := 1;
    OverwritePrompt := true;
  end;
end;

procedure TSearchFrm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Connection.OnDisconnect.Delete(SessionDisconnect);
  Action := caFree;
  with Connection.Account do begin
    WriteString(rSearchBase, cbBasePath.Items.CommaText);
    WriteString(rSearchAttributes, cbAttributes.Items.CommaText);
    WriteInteger(rSearchScope, cbSearchLevel.ItemIndex);
    WriteInteger(rSearchDerefAliases, cbDerefAliases.ItemIndex);
    WriteBool(rSearchRegExGreedy, cbxReGreedy.Checked);
    WriteBool(rSearchRegExCase, cbxReCase.Checked);
    WriteBool(rSearchRegExMulti, cbxReMultiLine.Checked);
    WriteInteger(rSearchHeight, Height);
    WriteInteger(rSearchWidth, Width);
  end;
end;

procedure TSearchFrm.SessionDisconnect(Sender: TObject);
begin
  Close;
end;

procedure TSearchFrm.ShowModify;
begin
  btnModify.Down := true;
  btnSearchModifyClick(nil);
  Show;
end;

procedure TSearchFrm.FormDestroy(Sender: TObject);
begin
  ResultPanel.Free;
  ModifyBox.Free;
  {$IFDEF REGEXPR}
  fSimpleParser.Free;
  {$ENDIF}
end;

procedure TSearchFrm.PathBtnClick(Sender: TObject);
var
  s: string;
begin
  s := MainFrm.PickEntry(cSearchBase);
  if s <> '' then
    cbBasePath.Text := s;
end;

procedure TSearchFrm.ActStartExecute(Sender: TObject);
var
  RawFilter1, RawFilter2, Filter, Attributes: string;
  i: Integer;

  function Prepare(const Filter: string): string;
  var
    len: Integer;
  begin
    Result := Trim(Filter);
    if Result = '' then Exit;
    if Result[1] = '''' then
    begin
     len := Length(Result);
      if Result[len] <> '''' then
        raise Exception.Create(stUnclosedStr);
      Result := Copy(Result, 2, len - 2);
    end;
  end;

  procedure ComboHistory(Combo: TComboBox);
  begin
    with Combo do
    if (Text <> '') and (Items.IndexOf(Text) = -1) then
    begin
      if Items.Count > COMBO_HISTORY then
        Items.Delete(COMBO_HISTORY);
      Items.Insert(0, Text);
    end;
  end;

  function CleanWildcards(s: string): string;
  var
    p: PChar;
  begin
    Result := '';
    p := PChar(s);
    while p^ <> #0 do
    begin
      if p^ = '*' then
      begin
        Result := Result + p^;
        while p^ = '*' do
        begin
          p := CharNext(p);
          if p^ = #0 then
            exit;
        end;
      end;
      Result := Result + p^;
      p := CharNext(p);
    end;
  end;

begin
  ComboHistory(cbBasePath);
  ComboHistory(cbAttributes);

  if (PageControl.ActivePageIndex = 0) or ((PageControl.ActivePageIndex <> 1) and (Memo1.Text = '')) then
  begin

    if sbCustom1.Down then
      RawFilter1 := edCustom1.Text
    else
      RawFilter1 := fSearchFilter;

    if edName.Text <> '' then
      RawFilter1 := StringReplace(RawFilter1, '%s', edName.Text, [rfReplaceAll, rfIgnoreCase])
    else
    if not sbCustom1.Down then
      RawFilter1 := '';

    if sbCustom2.Down then
      RawFilter2 := edCustom2.Text
    else
      RawFilter2 := '(mail=*%s*)';

    if edEMail.Text <> '' then
      RawFilter2 := StringReplace(RawFilter2, '%s', edEMail.Text, [rfReplaceAll, rfIgnoreCase])
    else
    if not sbCustom2.Down then
      RawFilter2 := '';

    if (RawFilter1 <> '') and (RawFilter2 <> '') then
      Filter := Format('(&%s%s)', [RawFilter1, RawFilter2])
    else
    if (RawFilter1 = '') and (RawFilter2 = '') then
      Filter := sANYCLASS
    else
      Filter := RawFilter1 + RawFilter2;

    Filter := CleanWildcards(StringReplace(Filter, '%s', '*', [rfReplaceAll, rfIgnoreCase]));
  end
  else
    Filter := Prepare(Memo1.Text);

  Attributes := cbAttributes.Text;

  {$IFDEF REGEXPR}
  if edRegExp.Text <> '' then
  begin
    if not Assigned(fSimpleParser) then
      fSimpleParser := TSimpleParser.Create;

    fSimpleParser.Statement := edRegExp.Text;

    for i := 0 to fSimpleParser.Count - 1 do with fSimpleParser[i] do
    begin
      Regex.ModifierG := cbxReGreedy.Checked;
      Regex.ModifierI := not cbxReCase.Checked;
      Regex.ModifierM := cbxReMultiline.Checked;
      if Attributes <> '' then
        Attributes := Attributes + ',';
      Attributes := Attributes + fSimpleParser[i].Argument;
    end;
  end;
  {$ENDIF}

  ActLoad.Enabled := false;
  ActSave.Enabled := false;
  ActSaveSelected.Enabled := false;

  if btnSearch.Down then
    Search(Filter, Attributes)
  else
    Modify(Filter, Attributes);
end;

procedure TSearchFrm.ActGotoExecute(Sender: TObject);
begin
  with ResultPages, ActiveList do
  if Assigned(ActiveList) and Assigned(Selected) then
    MainFrm.LocateEntry(Selected.Caption, true);
end;

procedure TSearchFrm.ActPropertiesExecute(Sender: TObject);
var
  oi: TObjectInfo;
begin
  with ResultPages, ActiveList do
  if Assigned(ActiveList) and Assigned(Selected) then
  begin
    oi := TObjectInfo.Create(ResultPages.ActiveList.SearchList.Entries[ResultPages.ActiveList.Selected.Index], false);
    try
      MainFrm.EditProperty(Self, oi);
    finally
      oi.Free;
    end;
  end;
end;

procedure TSearchFrm.ActSaveExecute(Sender: TObject);
var
  SelectedOnly: Boolean;

  procedure ToLdif;
  var
    ldif: TLdifFile;
    i: Integer;
  begin
    ldif := TLDIFFile.Create(SaveDialog.FileName, fmWrite);
    ldif.Encoding := SaveDialog.Encoding;
    ldif.UnixWrite := SaveDialog.FilterIndex = 2;
    with ResultPages.ActiveList, SearchList do
    try
      for i := 0 to Entries.Count - 1 do
      if not SelectedOnly or (SelectedOnly and Items[i].Selected) then
        ldif.WriteRecord(Entries[i]);
    finally
      ldif.Free;
    end;
  end;

  procedure ToCSV;
  var
    i: Integer;
    csvList: TStringList;
    s: string;
  begin
    csvList := TStringList.Create;
    with ResultPages.ActivePage.ListView do
    try
      for i := 0 to Items.Count - 1 do with Items[i] do
      if not SelectedOnly or (SelectedOnly and Selected) then
      begin
        s := '"' + Caption + '"';
        if SubItems.Count > 0 then
          s := s + ',' + SubItems.CommaText;
        csvList.Add(s);
      end;
      {$IFDEF VER_XEH}
      csvList.SaveToFile(SaveDialog.FileName, FileEncodingToEncodingClass(SaveDialog.Encoding));
      {$ELSE}
      csvList.SaveToFile(SaveDialog.FileName);
      {$ENDIF}
    finally
      csvList.Free;
    end;
  end;

  procedure ToXml;
  var
    DsmlTree: TDsmlTree;
    EntryList: TLdapEntryList;
    i: Integer;
  begin
    with ResultPages.ActiveList, SearchList do
    if SelectedOnly then
    begin
      EntryList := TLdapEntryList.Create(false);
      for i := 0 to Entries.Count - 1 do
        if Items[i].Selected then
          EntryList.Add(Entries[i]);
    end
    else
      EntryList := Entries;
    try
      DsmlTree := TDsmlTree.Create(EntryList);
      try
        DsmlTree.Encoding := SaveDialog.Encoding;
        DsmlTree.SaveToFile(SaveDialog.FileName);
      finally
        DsmlTree.Free;
      end;
    finally
      if SelectedOnly then
        EntryList.Free;
    end;
  end;

begin
  SelectedOnly := Sender = ActSaveSelected;
  if btnSearch.Down then
  begin
    with ResultPages, ActiveList do
    if Assigned(ActivePage) and (SearchList.Entries.Count > 0) then
    begin
      SaveDialog.Filter := SAVE_SEARCH_FILTER;
      SaveDialog.DefaultExt := SAVE_SEARCH_EXT;
      if SaveDialog.Execute then
      try
        Screen.Cursor := crHourGlass;
        case SaveDialog.FilterIndex of
          1, 2: ToLdif;
          3:    ToCSV;
          4:    ToXml;
        end;
      finally
        Screen.Cursor := crDefault;
      end;
    end;
  end
  else
  if Assigned(ModifyBox) then
  begin
    if ModifyBox.State = mbxDone then
    begin
      SaveDialog.Filter := SAVE_MODIFY_LOG_FILTER;
      SaveDialog.DefaultExt := SAVE_MODIFY_LOG_EXT;
      if SaveDialog.Execute then
        ModifyBox.SaveResults(SaveDialog.FileName, SaveDialog.Encoding);
    end
    else begin
      SaveDialog.Filter := SAVE_MODIFY_FILTER;
      SaveDialog.DefaultExt := SAVE_MODIFY_EXT;
      if SaveDialog.Execute then
        ModifyBox.Save(SaveDialog.FileName, SaveDialog.Encoding);
    end;
  end;
end;

procedure TSearchFrm.ActEditExecute(Sender: TObject);
begin
  with ResultPages, ActiveList do
  if Assigned(ActiveList) and Assigned(Selected) then
    TEditEntryFrm.Create(Self, Selected.Caption, Connection, EM_MODIFY).ShowModal;
end;

procedure TSearchFrm.ActCloseExecute(Sender: TObject);
begin
  Close;
end;

procedure TSearchFrm.ActionListUpdate(Action: TBasicAction; var Handled: Boolean);
var
  Enbl, Modv: Boolean;
begin
  Modv := Assigned(ModifyBox) and ModifyBox.Visible;
  ActStart.Enabled := (not Modv or (ModifyBox.State = mbxReady))
                       and ((PageControl.ActivePageIndex <> 1) or (Memo1.Text <> ''));
  ActClearAll.Enabled := Assigned(ResultPages.ActivePage) and Assigned(ResultPages.ActiveList.SearchList);
  ActLoad.Enabled := Modv and (ModifyBox.State <> mbxDone);
  Enbl := btnSearch.Down and Assigned(ResultPages.ActiveList) and (ResultPages.ActiveList.Items.Count > 0);
  ActSave.Enabled := Enbl or(Modv and ((ModifyBox.State <> mbxNew) or (ModifyBox.State = mbxDone)));
  Enbl := Enbl and ActStart.Enabled and Assigned(ResultPages.ActiveList.Selected);
  ActGoto.Enabled := Enbl;
  ActEdit.Enabled := Enbl;
  ActSaveSelected.Enabled := Enbl;
  if Enbl then
  with TObjectInfo.Create(ResultPages.ActiveList.SearchList.Entries[ResultPages.ActiveList.Selected.Index], false) do begin
    ActProperties.Enabled := Supported;
    Free;
  end
  else
    ActProperties.Enabled := false;
end;

procedure TSearchFrm.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if (Key = #13) and ActStart.Enabled then
  begin
    ActStartExecute(nil);
    Key := #0;
  end;
end;

procedure TSearchFrm.ListViewDblClick(Sender: TObject);
begin
  ActPropertiesExecute(nil);
end;

procedure TSearchFrm.edAttrBtnClick(Sender: TObject);
begin
  with TPickAttributesDlg.Create(Self, Connection.Schema, cbAttributes.Text) do
  begin
    ShowModal;
    cbAttributes.Text := Attributes;
  end;
end;

procedure TSearchFrm.SaveFilterBtnClick(Sender: TObject);
begin
  SaveItem(cbFilters, rSearchCustFilters, Memo1.Text);
end;

procedure TSearchFrm.cbFiltersChange(Sender: TObject);
begin
  ComboChange(cbFilters, rSearchCustFilters, SaveFilterBtn, DeleteFilterBtn, Memo1);
end;

procedure TSearchFrm.DeleteFilterBtnClick(Sender: TObject);
begin
  DeleteItem(cbFilters, rSearchCustFilters);
end;

procedure TSearchFrm.cbFiltersDropDown(Sender: TObject);
begin
  ComboDropDown(cbFilters, rSearchCustFilters);
end;

procedure TSearchFrm.FormDeactivate(Sender: TObject);
begin
  RevealWindow(Self, False, True);
end;

procedure TSearchFrm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose := not (Assigned(ModifyBox) and (ModifyBox.State = mbxRunning));
end;

procedure TSearchFrm.btnSearchModifyClick(Sender: TObject);
begin
  StartBtn.Glyph := nil;
  if btnSearch.Down then
  begin
    if Assigned(ModifyBox) then ModifyBox.Visible := false;
      ResultPanel.Visible := true;
    MainFrm.ImageList.GetBitmap(20, StartBtn.Glyph);
    ActSave.Hint := cSaveSrchResults;
    ActLoad.Hint := '';
  end
  else begin
    if not Assigned(ModifyBox) then
    begin
      ModifyBox := TModifyBox.Create(Self, Connection);
      ModifyBox.Align := alClient;
      ModifyBox.Parent := Self;
      ModifyBox.New;
    end;
    ResultPanel.Visible := false;
    ModifyBox.Visible := true;
    MainFrm.ImageList.GetBitmap(38, StartBtn.Glyph);
    ActSave.Hint := cSaveBatchToFile;
    ActLoad.Hint := cLoadBatchFromFile;
  end;
end;

procedure TSearchFrm.ActClearAllExecute(Sender: TObject);
begin
  LockControl(ResultPages, true);
  with ResultPages do
  try
    while PageCount > 0 do
      RemovePage(ActivePage);
    ResultPages.AddPage;
    ResultPages.ActivePage.Caption := cSearchResults;
  finally
    LockControl(ResultPages, false);
  end;
end;

{$IFNDEF VER_XEH}
procedure TSearchFrm.TabSheet2Resize(Sender: TObject);
begin
  with TabSheet2 do begin
    Memo1.Width := Width - 46;
    DeleteFilterBtn.Left := Width - DeleteFilterBtn.Width - 6;
    SaveFilterBtn.Left := DeleteFilterBtn.Left - SaveFilterBtn.Width - 4;
    cbFilters.Width := SaveFilterBtn.Left - cbFilters.Left - 4;
  end;
end;

procedure TSearchFrm.TabSheet3Resize(Sender: TObject);
begin
  edAttrBtn.Left := TabSheet3.Width - edAttrBtn.Width - 6;
  cbAttributes.Width := edAttrBtn.Left - cbAttributes.Left - 6;
  cbDerefAliases.Width := cbAttributes.Left + cbAttributes.Width - cbDerefAliases.Left;
end;

procedure TSearchFrm.TabSheet4Resize(Sender: TObject);
begin
  with TabSheet2 do begin
    edRegExp.Width := Width - edRegexp.Left - 6;
    btnDeleteRegex.Left := Width - btnDeleteRegex.Width - 6;
    btnSaveRegex.Left := btnDeleteRegex.Left - btnSaveRegex.Width - 4;
    cbRegExp.Width := btnSaveRegex.Left - cbRegExp.Left - 4;
  end;
end;
{$ENDIF}

procedure TSearchFrm.cbRegExpChange(Sender: TObject);
begin
  ComboChange(cbRegExp, rSearchRegEx, btnSaveRegEx, btnDeleteRegEx, edRegExp);
end;

procedure TSearchFrm.cbRegExpDropDown(Sender: TObject);
begin
  ComboDropDown(cbRegExp, rSearchRegEx);
end;

procedure TSearchFrm.btnSaveRegExClick(Sender: TObject);
begin
  SaveItem(cbRegExp, rSearchRegEx, edRegExp.Text);
end;

procedure TSearchFrm.btnDeleteRegExClick(Sender: TObject);
begin
  DeleteItem(cbRegExp, rSearchRegEx);
end;

procedure TSearchFrm.ActLoadExecute(Sender: TObject);
begin
  OpenDialog.Filter := SAVE_MODIFY_FILTER;
  OpenDialog.DefaultExt := SAVE_MODIFY_EXT;
  if OpenDialog.Execute then
  try
    ModifyBox.Load(OpenDialog.FileName);
  except
    on E:EXmlException do
      ParseError(mtError, Application.MainForm, OpenDialog.FileName, E.Message, E.Message2, E.XmlText, E.Tag, E.Line, E.Position);
  end;
end;

procedure TSearchFrm.ActCopyExecute(Sender: TObject);
begin
  CopyMove(false);
end;

procedure TSearchFrm.ActMoveExecute(Sender: TObject);
begin
  CopyMove(true);
end;

procedure TSearchFrm.ActDeleteExecute(Sender: TObject);
begin
  if Assigned(ResultPages.ActiveList) then
    ResultPages.ActiveList.DeleteSelection;
end;

procedure TSearchFrm.HandleCustomChange(Btn: TSpeedButton; lbl: TLabel; edInput, edContent: TEdit; RestoreCaption: string);
var
  Caption, Filter: string;
begin
  if Btn.Down and GetCustomFilter(Caption, Filter) then
  begin
    lbl.Caption := Caption;
    edContent.Text := Filter;
    if Pos('%s', Filter) = 0 then
    begin
      edInput.Visible := false;
      {$IFNDEF VER_XEH}
      edContent.Left := edInput.Left;
      edContent.Width := TabSheet1.Width - 61;
      {$ENDIF}
    end
    else begin
      edInput.Visible := true;
      {$IFDEF VER_XEH}
      edInput.Width := 129;
      edContent.Left := edName.Left + 129 + 4;
      edContent.Width := TabSheet1.Width - 61 - edInput.Width - 4;
      {$ENDIF}
    end;
    exit;
  end;

  lbl.Caption := RestoreCaption + ':';
  btn.Down := false;
  edInput.Visible := true;
  {$IFNDEF VER_XEH}
  edInput.Width := TabSheet1.Width - 61;
  {$ENDIF}
end;

procedure TSearchFrm.sbCustom1Click(Sender: TObject);
begin
  HandleCustomChange(sbCustom1, label6, edName, edCustom1, cName);
end;

procedure TSearchFrm.sbCustom2Click(Sender: TObject);
begin
  HandleCustomChange(sbCustom2, Label7, edEMail, edCustom2, cEMail);
end;

end.
