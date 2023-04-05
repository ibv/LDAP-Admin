  {      LDAPAdmin - EditEntry.pas
  *      Copyright (C) 2003-2013 Tihomir Karlovic
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

unit EditEntry;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
{$IFnDEF FPC}
  Windows, WinLDAP, FileUtil,System.Actions,
{$ELSE}
  LCLIntf, LCLType, {MouseAndKeyInput,} LazFileUtils, LCLMessageGlue,
{$ENDIF}
  SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, ComCtrls, Grids, LDAPClasses, Constant,
  Menus, ActnList,  IControls, Schema, Templates,
  TemplateCtrl, Sorter, Connection, DlgWrap;

const
  NAMING_VALUE_TAG = -1;

type

  { TEditEntryFrm }

  TEditEntryFrm = class(TForm)
    Panel2: TPanel;
    edDn: TEdit;
    Label1: TLabel;
    StatusBar: TStatusBar;
    ToolBar1: TToolBar;
    ImageList1: TImageList;
    SaveBtn: TToolButton;
    DeleteCellsBtn: TToolButton;
    ToolButton4: TToolButton;
    ExitBtn: TToolButton;
    ToolButton6: TToolButton;
    MainMenu1: TMainMenu;
    mbFile: TMenuItem;
    mbEdit: TMenuItem;
    mbSave: TMenuItem;
    N1: TMenuItem;
    mbExit: TMenuItem;
    mbDeleteRow: TMenuItem;
    N2: TMenuItem;
    mbCut: TMenuItem;
    mbRestore: TMenuItem;
    mbCopy: TMenuItem;
    mbPaste: TMenuItem;
    mbDelete: TMenuItem;
    UndoBtn: TToolButton;
    CutBtn: TToolButton;
    CopyBtn: TToolButton;
    PasteBtn: TToolButton;
    DeleteBtn: TToolButton;
    ToolButton8: TToolButton;
    PopupMenu1: TPopupMenu;
    mbDeleteRow1: TMenuItem;
    N4: TMenuItem;
    mbRestore1: TMenuItem;
    mbCut1: TMenuItem;
    mbCopy1: TMenuItem;
    mbPaste1: TMenuItem;
    mbDelete1: TMenuItem;
    N3: TMenuItem;
    mbLoadFromFile: TMenuItem;
    mbSaveToFile: TMenuItem;
    mbViewBinary: TMenuItem;
    N5: TMenuItem;
    OpenFileDialog: TOpenDialog;
    N8: TMenuItem;
    mbLoadFromFile1: TMenuItem;
    mbSaveToFile1: TMenuItem;
    N9: TMenuItem;
    mbViewBinary1: TMenuItem;
    ActionList1: TActionList;
    ActSave: TAction;
    ActClose: TAction;
    ActDeleteRow: TAction;
    ActUndo: TAction;
    ActCut: TAction;
    ActCopy: TAction;
    ActPaste: TAction;
    ActDelete: TAction;
    ActLoadFile: TAction;
    ActSaveFile: TAction;
    ActBinView: TAction;
    SchemaCheckBtn: TToolButton;
    ActSchemaCheck: TAction;
    PageControl1: TPageControl;
    OcSheet: TTabSheet;
    TemplateSheet: TTabSheet;
    Splitter1: TSplitter;
    attrStringGrid: TStringGrid;
    objStringGrid: TStringGrid;
    cbRdn: TComboBox;
    Label3: TLabel;
    Panel3: TPanel;
    TemplateListBox: TListBox;
    ToolBar2: TToolBar;
    TemplateBtnAdd: TToolButton;
    TemplateBtnDel: TToolButton;
    Splitter2: TSplitter;
    TemplatePopupMenu: TPopupMenu;
    ActFindInSchema: TAction;
    N6: TMenuItem;
    pbFindInSchema: TMenuItem;
    ActPicView: TAction;
    ActCertView: TAction;
    Viewcertificate1: TMenuItem;
    Viewpicture1: TMenuItem;
    ActCopyName: TAction;
    ActCopyValue: TAction;
    Copyattributename1: TMenuItem;
    Copyvalue1: TMenuItem;
    procedure mbSaveClick(Sender: TObject);
    procedure mbExitClick(Sender: TObject);
    procedure mbDeleteRowClick(Sender: TObject);
    procedure PushShortCutClick(Sender: TObject);
    procedure ToolBtnClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure mbLoadFromFileClick(Sender: TObject);
    procedure mbSaveToFileClick(Sender: TObject);
    procedure mbViewBinaryClick(Sender: TObject);
    procedure ActionList1Update(Action: TBasicAction;
      var Handled: Boolean);
    procedure StringGridDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure StringGridSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure StringGridTopLeftChanged(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure StringGridMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Splitter1Moved(Sender: TObject);
    procedure ActSchemaCheckExecute(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure PageControl1Change(Sender: TObject);
    procedure cbRdnDropDown(Sender: TObject);
    procedure TemplateListBoxClick(Sender: TObject);
    procedure TemplateListBoxDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure TemplateBtnAddClick(Sender: TObject);
    procedure TemplateBtnDelClick(Sender: TObject);
    procedure TemplatePopupMenuPopup(Sender: TObject);
    procedure StringGridMouseWheelDown(Sender: TObject; Shift: TShiftState; MousePos: TPoint; var Handled: Boolean);
    procedure StringGridMouseWheelUp(Sender: TObject; Shift: TShiftState; MousePos: TPoint; var Handled: Boolean);
    procedure StringGridMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure ActFindInSchemaExecute(Sender: TObject);
    procedure FormDeactivate(Sender: TObject);
    procedure ActPicViewExecute(Sender: TObject);
    procedure ActCertViewExecute(Sender: TObject);
    procedure ActCopyNameExecute(Sender: TObject);
    procedure ActCopyValueExecute(Sender: TObject);
  private
    fConnection: TConnection;
    Entry: TLDAPEntry;
    ObjectCombo: TInplaceComboBox;
    AttributeCombo: TInplaceComboBox;
    FButtonWidth: Integer;
    fBold: TFont;
    fNeedRefresh: Boolean;
    fTemplatesInited: Boolean;
    fTemplateScrollBox: TTemplateBox;
    fSchema: TLdapSchema;
    fValueSorter: TStringGridSorter;
    fOcSorter: TStringGridSorter;
    fOnWrite: TNotifyEvent;
    SaveDialog: TSaveDialogWrapper;
    procedure DataChange(Sender: TLdapAttributeData);
    procedure PushShortCut(Command: TAction);
    procedure HandleTabExit(InplaceAttribute: TInplaceAttribute);
    procedure InplaceControlExit(Sender: TObject);
    procedure KeyComboEnter(Sender: TObject);
    procedure KeyComboExit(Sender: TObject);
    procedure ObjectComboKeyPress(Sender: TObject; var Key: Char);
    procedure ObjectComboCloseUp(Sender: TObject);
    procedure ResizeMemo(AMemo: TInplaceMemo);
    procedure AddRow(Grid: TStringGrid);
    procedure DeleteRow(Grid: TStringGrid; Index: Integer);
    function  NewInplaceControl(InplaceClass: TInplaceClass; StringGrid: TStringGrid; AValue: TLdapAttributeData; IsRequired: Boolean): TInplaceAttribute;
    procedure RefreshAttributeList(const Autodelete: Boolean);
    procedure InitTemplates;
    procedure AddTemplate(ATemplate: TTemplate);
    procedure DeleteTemplate(ATemplate: TTemplate);
    procedure Load;
    function  NewValue(Attr: TLdapAttribute): TLdapAttributeData;
    procedure TemplatePopupClick(Sender: TObject);
  public
    constructor Create(AOwner: TComponent; const adn: string;
                       AConnection: TConnection; const Mode: TEditMode); reintroduce; overload;
    procedure   SessionDisconnect(Sender: TObject);
    property    OnWrite: TNotifyEvent read fOnWrite write fOnWrite;
  end;

var
  EditEntryFrm: TEditEntryFrm;

implementation

{$I LdapAdmin.inc}

uses BinView, PicView, Cert, Misc, Main, Config, ClipBrd, TextFile
     {$IFDEF VER_XEH}, System.Types, System.UITypes{$ENDIF};

{$R *.dfm}

{ TEditEntryFrm }

procedure TEditEntryFrm.DataChange(Sender: TLdapAttributeData);
var
  i: Integer;
begin
  if not Assigned(fTemplateScrollBox) then Exit;
  with fTemplateScrollBox do
  for i := 0 to TemplateCount - 1 do with Templates[i] do
    if AnsiCompareText(Sender.Attribute.Name, Template.Rdn) = 0 then
    begin
      cbRdn.Text := Template.Rdn + '=' + Sender.AsString;
      Break;
    end;
end;

procedure TEditEntryFrm.PushShortCut(Command: TAction);
var
  vKey, shift: word;
  c: byte;
  ShiftState: TShiftState;
begin
  ShortCutToKey(Command.ShortCut, vKey, ShiftState);
  c := lo(byte(vKey));
  if ssCtrl in ShiftState then
    shift := VK_CONTROL
  else
  if ssShift in ShiftState then
      shift := VK_SHIFT
  else
    shift := 0;

  if shift <> 0 then ;
    ///keybd_event(shift, 1,0,0);                              // press shift key

  ///keybd_event(c, MapVirtualKey(c, 0), 0, 0);                // press key
  ///keybd_event(c, MapVirtualKey(c, 0), KEYEVENTF_KEYUP, 0);  // release key

  if shift <> 0 then  ;
    ///keybd_event(shift, 1, KEYEVENTF_KEYUP, 0);              // release shift key

  Command.ShortCut := 0;                                    // deaktivate accelerator
  Application.ProcessMessages;
  Command.ShortCut := ShortCut(Word(vKey), ShiftState);     // reaktivate accelerator
end;

procedure TEditEntryFrm.HandleTabExit(InplaceAttribute: TInplaceAttribute);
var
  r, c, d: Integer;
begin
  with InplaceAttribute, Owner as TStringGrid do
  begin
    SetFocus;
    if Backpaddle then
      d := -1
    else
      d := 1;
    r := Row;
    c := Col;
    c := c + d;
    if c > ColCount - 1 then
    begin
      c := 0;
      r := r + d;
    end
    else
    if c < 0 then
    begin
      c := ColCount - 1;
      r := r + d;
    end;
    if r > RowCount - 1 then
      r := 0
    else
    if r < 1 then
      r := RowCount - 1;
    Col := c;
    Row := r;
  end;
  InplaceAttribute.TabExit := false;
end;

procedure TEditEntryFrm.InplaceControlExit(Sender: TObject);
begin
  with Sender as TInplaceAttribute do
    if TabExit then HandleTabExit(Sender as TInplaceAttribute);
end;

procedure TEditEntryFrm.KeyComboEnter(Sender: TObject);
begin
  (Sender as TInplaceComboBox).Control.Text := '';
end;

procedure TEditEntryFrm.KeyComboExit(Sender: TObject);
var
   StringGrid: TStringGrid;
   InplaceCombo: TInplaceComboBox;
   s: string;

   function IsRequired(const Name: string): Boolean;
   var
     i, j: Integer;
     Attribute: TLDAPSchemaAttribute;
   begin
     Result := false;
     Attribute := fSchema.Attributes.ByName[Name];
     if not Assigned(Attribute) then
       Exit;
     for i:=0 to fSchema.ObjectClasses.Count-1 do
     for j:=0 to Attribute.Name.Count-1 do
       if (fSchema.OBjectClasses[i].Must.IndexOf(Name[j])>-1) or
          (fSchema.OBjectClasses[i].May.IndexOf(Name[j])>-1) then
       begin
         Result := true;
         Break;
       end;
   end;

begin
  InplaceCombo := (Sender as TInplaceComboBox);
  if InplaceCombo.Control.Text = '' then Exit;
  StringGrid := InplaceCombo.Owner as TStringGrid;
  with StringGrid do
  begin
    if Sender = ObjectCombo then
    begin
      NewValue(Entry.AttributesByName['objectclass']).AsString := InplaceCombo.Control.Text;
      RefreshAttributeList(true);
    end;
    if (Col = 0) and (Cells[Col, Row] <> '') then
    begin
      if Sender = AttributeCombo then
      begin
        s := InplaceCombo.Control.Text;
        Objects[Col + 1, Row] := NewInplaceControl(TInplaceMemo, attrStringGrid, NewValue(Entry.AttributesByName[s]), IsRequired(s)) as TInplaceMemo;
        { Inplace attributes tagged with schema tag will not be automatically deleted }
        if InplaceCombo.Control.Items.IndexOf(s) = -1 then
          TInplaceMemo(Objects[Col + 1, Row]).SchemaTag := true;
      end;
      AddRow(StringGrid);
    end;
    ///if InplaceCombo.TabExit then
      HandleTabExit(InplaceCombo);
  end;
end;

procedure TEditEntryFrm.ObjectComboKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
    fNeedRefresh := true;
end;

procedure TEditEntryFrm.ObjectComboCloseUp(Sender: TObject);
begin
  fNeedRefresh := true;
end;

procedure TEditEntryFrm.ResizeMemo(AMemo: TInplaceMemo);
var
  c, h: Integer;
  StringGrid: TStringGrid;
  s: string;
begin
  with AMemo do
  if ControlVisible then
  begin
    StringGrid := (Owner as TStringGrid);
    h := StringGrid.Canvas.TextHeight('A');
    c := Control.Lines.Count;
    s := Copy(Control.Lines.Text, Length(Control.Lines.Text) - 1, MaxInt);
    if StrRScan(PChar(s), #13) <> nil then
      inc(c);
    ///h := c * h + h div 4 + 4 * BevelWidth;
    h := c * h + h div 4 + 4 * 1;
    if (Top + h > StringGrid.Top + StringGrid.Height) then
      h := StringGrid.Height + StringGrid.Top - Top;
    if h > Height then
      Height := h;
  end;
end;

procedure TEditEntryFrm.AddRow(Grid: TStringGrid);
begin
  with Grid do
  begin
    RowCount := RowCount + 1;
    Objects[0, RowCount - 1] := Objects[0, RowCount - 2];
    Objects[0, RowCount - 2] := nil;
  end;
end;

procedure TEditEntryFrm.DeleteRow(Grid: TStringGrid; Index: Integer);
var
  i: Integer;
begin
  with Grid do
  begin
    i:=0;
    if (grid = attrStringGrid) then  inc(i);
    if Assigned(Objects[i, Index]) then with TInplaceAttribute(Objects[i, Index]) do
    begin
      {if Tag = NAMING_VALUE_TAG then
        raise Exception.Create(stDelNamingAttr);}
      if (Tag = NAMING_VALUE_TAG) and (MessageDlg(Format(stDelNamingAttr, [Cells[0, Index]]), mtWarning, [mbYes, mbCancel], 0) <> mrYes) then
        Abort;
      Value.Delete;
      Free;
    end;
    Rows[Index].Clear;
    if RowCount > {2}3 then
    begin
      for i := Index to RowCount - 2 do
        Rows[i] := Rows[i+1];
      if (Row = Index) and (Index = RowCount - 1) then
        Row := Row - 1;
      Rows[RowCount-1].Clear;
      RowCount := RowCount - 1;
      Col := 0;
    end;
  end;
end;

function TEditEntryFrm.NewInplaceControl(InplaceClass: TInplaceClass; StringGrid: TStringGrid; AValue: TLdapAttributeData; IsRequired: Boolean): TInplaceAttribute;
begin
  Result := InplaceClass.Create(StringGrid, AValue);
  with Result do
  begin
    Required  := IsRequired;
    PopupMenu := PopupMenu1;
    OnExit    := InplaceControlExit;
  end;
end;

constructor TEditEntryFrm.Create(AOwner: TComponent; const adn: string;
                                 AConnection: TConnection; const Mode: TEditMode);
var
  i, j: integer;
begin
  inherited Create(AOwner);

  SaveDialog := TSaveDialogWrapper.Create(Self);
  with SaveDialog do begin
    Filter := stAllFilesFilter;
    FilterIndex := 1;
    OverwritePrompt := true;
  end;

  attrStringGrid.Doublebuffered := true;
  fConnection := AConnection;
  SchemaCheckBtn.Down := AConnection.Account.ReadBool(rEditorSchemaHelp, true);
  fSchema := AConnection.Schema;
  fBold := TFont.Create;
  fBold.Assign(Font);
  fBold.Style := fBold.Style + [fsBold];
  ObjectCombo := NewInplaceControl(TInplaceComboBox, objStringGrid, nil, false) as TInplaceComboBox;
  ObjectCombo.Parent := OCSheet;
  objStringGrid.Objects[0, 1] := ObjectCombo;
  with ObjectCombo do
  begin
    //Control.Color := $00F0F0F0;
    OnEnter := KeyComboEnter;
    OnExit := KeyComboExit;
    Control.OnCloseUp := ObjectComboCloseUp;
    Control.OnKeyPress := ObjectComboKeyPress;
    Control.DropDownCount := 16;
    Control.Sorted := true;
    if fSchema.Loaded then with fSchema.ObjectClasses do
      for i:= 0 to Count - 1 do with Items[i] do
        for j := 0 to Name.Count - 1 do
        Control.Items.Add(Name[j]);
  end;
  AttributeCombo := NewInplaceControl(TInplaceComboBox, attrStringGrid, nil, false) as TInplaceComboBox;
  AttributeCombo.Parent := OCSheet;
  attrStringGrid.Objects[0, 1] := AttributeCombo;
  with AttributeCombo do
  begin
    OnEnter := KeyComboEnter;
    OnExit := KeyComboExit;
    Control.DropDownCount := 16;
    Control.Sorted := true;
  end;
  Entry := TLDAPEntry.Create(AConnection, adn);
  if Mode = EM_MODIFY then
  begin
    Caption := cEditEntry;
    edDn.Enabled := false;
    cbRdn.Enabled := false;
    edDn.Text := GetDirFromDn(adn);
    cbRdn.Text := DecodeLdapString(GetRdnFromDn(adn));
    Load;
  end
  else
  begin
    Caption := cNewEntry;
    edDn.Text := adn;
    Entry.OnChange := DataChange;
    {$ifndef mswindows}
    with objStringGrid do
    begin
      RowCount := 2;
      Rows[1].Clear;
      RowCount := RowCount + 1;
      Objects[0, RowCount - 1] := ObjectCombo;
    end;
    with attrStringGrid do
    begin
      RowCount := 2;
      Rows[1].Clear;
      RowCount := RowCount + 1;
      Objects[0, RowCount - 1] := AttributeCombo;
    end;
    {$endif}
  end;
  with objStringGrid do
  begin
    Cells[0,0] := cObjectclass;
    Cells[0,RowCount-1] := cNew;
  end;
  with attrStringGrid do
  begin
    Cells[0,0] := cAttribute;
    Cells[1,0] := cValue;
    Cells[0,RowCount-1] := cNew;
  end;
  FButtonWidth := GetSystemMetrics(SM_CXVSCROLL);
  edDn.Width := Panel2.Width - edDn.Left - FButtonWidth - 4;
  AConnection.OnDisconnect.Add(SessionDisconnect);
  StatusBar.Panels[0].Text := Format(cServer, [AConnection.Server]);
  StatusBar.Panels[0].Width := StatusBar.Canvas.TextWidth(StatusBar.Panels[0].Text) + 16;
  StatusBar.Panels[1].Text := Format(cPath, [adn]);
  fValueSorter := TStringGridSorter.Create;
  fValueSorter.StringGrid := attrStringGrid;
  fValueSorter.FixedBottomRows := 1;
  fOcSorter := TStringGridSorter.Create;
  fOcSorter.StringGrid := objStringGrid;
  fOcSorter.FixedBottomRows := 1;

  attrStringGrid.OnDrawCell:=StringGridDrawCell;
  objStringGrid.OnDrawCell :=StringGridDrawCell;
  Visible:=true;
end;

procedure TEditEntryFrm.SessionDisconnect(Sender: TObject);
begin
  Close;
end;

procedure TEditEntryFrm.RefreshAttributeList(const Autodelete: Boolean);
var
  i: Integer;
  fRows, fNewRows: TStringList;
  ValueHandled: Boolean;

  function ContainsAt(List1, List2: TStringList): Integer;
  var
    i: Integer;
  begin
    Result := -1;
    for i := 0 to List2.Count - 1 do
    begin
      Result := List1.IndexOf(List2[i]);
      if Result <> - 1 then
        Break;
    end;
  end;

  procedure DoList(AList: TLdapSchemaAttributes; const ARequired: Boolean);
  var
    i, idx, k: Integer;
    SAttr: TLdapSchemaAttribute;
    LAttr: TLdapAttribute;
    s: string;
  begin
    with fRows do begin
      for i := 0 to AList.Count - 1 do
      begin
        SAttr:=AList[i];
        if not Assigned(SAttr) then
          Continue;
        s := SAttr.Name[0];
        if lowercase(s) = 'objectclass' then
          Continue;
        if ContainsAt(fNewRows, SAttr.Name) <> -1 then
          Continue;
        idx := ContainsAt(fRows, SAttr.Name);
        repeat
          if idx = -1 then
          begin
            { ** added because of templates** }
            ValueHandled := false;
            LAttr := Entry.AttributesByName[s];
            if LAttr.ValueCount > 0 then
            begin
              for k := 0 to LAttr.ValueCount - 1 do with LAttr.Values[k] do
              begin
                if (ModOp <> LdapOpNoop) and (ModOp <> LdapOpDelete) then
                begin
                  fNewRows.AddObject(s, NewInplaceControl(TInplaceMemo, attrStringGrid, LAttr.Values[k], ARequired));
                  ValueHandled := true;
                end;
              end;
            end;
            if not ValueHandled then {** added ** }
              fNewRows.AddObject(s, NewInplaceControl(TInplaceMemo, attrStringGrid, NewValue(LAttr), ARequired) as TInplaceMemo);
            Break;
          end
          else begin
            if ARequired then
              TInplaceMemo(Objects[idx]).Required := true;
            fNewRows.AddObject(fRows[idx], Objects[idx]);
            Delete(idx);
          end;
          idx := ContainsAt(fRows, SAttr.Name); // Check for multivalue attributes
        until idx = -1;
      end;
    end;
  end;

  procedure HandleSchema;
  var
    i, j: Integer;
    ObjectClass, Sup: TLdapSchemaClass;
  begin
    with objStringGrid do
    begin
      AttributeCombo.Control.Clear;
      for i := 1 to RowCount - 1 do
      begin
        if Cells[0, i] <> '' then
        begin
          ObjectClass := fSchema.ObjectClasses.ByName[Cells[0, i]];
          if Assigned(ObjectClass) then with ObjectClass do
          begin
            DoList(Must, true);
            DoList(May, false);
            Sup:=Superior;
            while Sup<>nil do begin
              DoList(Sup.Must, true);
              DoList(Sup.May, false);
              Sup:=Sup.Superior;
            end;
            with AttributeCombo.Control.Items do
            begin
              for j := 0 to ObjectClass.Must.Count - 1 do
                if IndexOf(ObjectClass.Must[j].Name[0]) = -1 then
                  Add(ObjectClass.Must[j].Name[0]);
              for j := 0 to ObjectClass.May.Count - 1 do
                if IndexOf(ObjectClass.May[j].Name[0]) = -1 then
                  Add(ObjectClass.May[j].Name[0]);
            end;
          end;
        end;
      end;
    end;

    for i := 0 to fRows.Count - 1 do
      if Assigned(fRows.Objects[i]) then with TInplaceAttribute(fRows.Objects[i]) do
      begin
         if not Autodelete then SchemaTag := true;
         if SchemaTag then
          fNewRows.AddObject(fRows[i], fRows.Objects[i])
        else begin
          Value.Delete;
          Free;
        end;
      end;
  end;

begin
  fRows := TStringList.Create;
  if SchemaCheckBtn.Down and fSchema.Loaded then
    fNewRows := TStringList.Create
  else
    fNewRows := fRows;
  //fNewRows.Sorted := true; doesn't work if list previously sorted
  try
    with attrStringGrid do begin
      if fRows <> fNewRows then
      begin
        for i := 1 to RowCount - 2 do
          fRows.AddObject(Cells[0, i], Objects[1, i]);
      end
      else begin
        for i := 1 to RowCount - 2 do with TInplaceAttribute(Objects[1, i]) do
          if Assigned(Objects[1, i]) and (SchemaTag or (Value.DataSize <> 0)) then
            fRows.AddObject(Cells[0, i], Objects[1, i]);
      end;
      Cols[0].Clear;
      Cols[1].Clear;
      RowCount := 2;
      Cells[0,0] := cAttribute;
      Cells[1,0] := cValue;
    end;

    if fNewRows <> fRows then
      HandleSchema;

    fNewRows.Sorted := true;
    with attrStringGrid do begin
      for i := 0 to fNewRows.Count - 1 do
      begin
        Cells[0, i + 1] := fNewRows[i];
        Cells[1, i + 1] := TInplaceAttribute(fNewRows.Objects[i]).CellData;
        Objects[1, i + 1] := fNewRows.Objects[i];
        RowCount := RowCount + 1;
      end;
      ColWidths[1] := ClientWidth - colWidths[0] - GridLineWidth;
      Objects[0, RowCount - 1] := AttributeCombo;
    end;

  finally
    if fNewRows <> fRows then
      fRows.Free;
    fNewRows.Free;
  end;
end;

procedure TEditEntryFrm.InitTemplates;
var
  i: Integer;
  Item: TMenuItem;
  Template: TTemplate;
  Oc: TLdapAttribute;

begin
  LockControl(TemplateSheet, true);
  Screen.Cursor := crHourGlass;
  try
    fTemplateScrollBox := TTemplateBox.Create(Self);
    with fTemplateScrollBox do
    begin
      FlatPanels := true;
      Align := alClient;
      LdapEntry := Entry;
      Parent := TemplateSheet;
    end;

    if (esBrowse in Entry.State) and GlobalConfig.ReadBool(rTemplateAutoload, true) then
      Oc := Entry.AttributesByName['objectclass']
    else
      Oc := nil;
    for i := 0 to TemplateParser.Count - 1 do
    begin
      Template := TemplateParser.Templates[i];
      Item := TMenuItem.Create(Self);
      with Item do
      begin
        Caption := Template.Name;
        Tag := Integer(Template);
        OnClick := TemplatePopupClick;
      end;
      TemplatePopupMenu.Items.Add(Item);

      if Assigned(Oc) and Template.Matches(Oc) then
        AddTemplate(Template);
    end;
    if TemplateListBox.Items.Count > 1 then
    begin
      ///TemplateListBox.ItemIndex := 0;
      TemplateListBox.ItemIndex := 1;
      TemplateListBoxClick(nil);
    end;
  finally
    Screen.Cursor := crDefault;
    LockControl(TemplateSheet, false);
  end;
  fTemplatesInited := true;
end;

procedure TEditEntryFrm.AddTemplate(ATemplate: TTemplate);
var
  i: Integer;
  Attr: TLdapAttribute;
begin
  fTemplateScrollBox.Add(ATemplate);
  TemplateListBox.Items.AddObject(ATemplate.Name, ATemplate);

  Attr := Entry.AttributesByName['objectclass'];
  for i := 0 to ATemplate.ObjectclassCount - 1 do
    if Attr.IndexOf(ATemplate.Objectclasses[i]) = -1 then
    begin
      NewValue(Attr).AsString := ATemplate.Objectclasses[i];
      with objStringGrid do begin
        AddRow(objStringGrid);
        Cells[0, RowCount - 2] := ATemplate.Objectclasses[i];
      end;
    end;
end;

procedure TEditEntryFrm.DeleteTemplate(ATemplate: TTemplate);
var
  i, idx: Integer;

begin
  for i := 0 to ATemplate.ObjectclassCount - 1 do
  begin
    Entry.AttributesByName['objectclass'].DeleteValue(ATemplate.Objectclasses[i]);
    idx := objStringGrid.Cols[0].IndexOf(ATemplate.Objectclasses[i]);
    if idx <> -1 then
      DeleteRow(objStringGrid, idx);
  end;
  RefreshAttributeList(true);
end;

procedure TEditEntryFrm.Load;
var
  i, j: Integer;
  fAttributes, fObjectclasses: TStringList;

  { Check if the value belongs to naming attribute and disable the control to prevent modifying accordingly }
  function CheckNamingValue(const Value: TLdapAttributeData; const IA: TInplaceAttribute): TInplaceAttribute;
  var
    attr, val: string;
  begin
    Result := IA;
    if Assigned(Value) then
    begin
      SplitRdn(Entry.dn, attr, val);
      if (CompareText(Value.Attribute.Name, attr) = 0) and (CompareText(Value.AsString, DecodeLdapString(val)) = 0) then
      with Result do begin
        Enabled := false;
        Tag := NAMING_VALUE_TAG;
      end;
    end;
  end;

begin
  Entry.Read;
  fAttributes := TStringList.Create;
  fObjectclasses := TStringList.Create;
  for i := 0 to Entry.Attributes.Count - 1 do with Entry.Attributes[i] do
  begin
    if lowercase(Name) = 'objectclass' then
    begin
      for j := 0 to ValueCount - 1 do
        fObjectclasses.AddObject(Values[j].AsString, Values[j]);
    end
    else begin
      for j := 0 to ValueCount - 1 do
        fAttributes.AddObject(Name, Values[j]);
    end;
  end;
  fAttributes.Sorted := true;
  fObjectclasses.Sorted := true;
  with objStringGrid do
  begin
    RowCount := 2;
    Rows[1].Clear;
    for I := 0 to fObjectclasses.Count - 1 do
    begin
      RowCount := RowCount + 1;
      Cells[0, I + 1] := fObjectclasses[I];
    end;
    Objects[0, RowCount - 1] := ObjectCombo;
  end;
  with attrStringGrid do
  begin
    RowCount := 2;
    Rows[1].Clear;
    for I := 0 to fAttributes.Count - 1 do
    begin
      RowCount := RowCount + 1;
      Cells[0, I + 1] := fAttributes[I];
      Objects[1, I + 1] := CheckNamingValue(TLdapAttributeData(fAttributes.Objects[I]), NewInplaceControl(TInplaceMemo, attrStringGrid, TLdapAttributeData(fAttributes.Objects[I]), false));
    end;
    Objects[0, RowCount - 1] := AttributeCombo;
  end;
  fAttributes.Free;
  fObjectclasses.Free;
  RefreshAttributeList(false);
end;


function TEditEntryFrm.NewValue(Attr: TLdapAttribute): TLdapAttributeData;
begin
  if (Attr.ValueCount = 1) and ((Attr.Values[0].DataSize=0) or (Attr.Values[0].ModOp = LdapOpDelete)) then
    Result := Attr.Values[0]
  else
    Result := Attr.AddValue;
end;

procedure TEditEntryFrm.mbSaveClick(Sender: TObject);

  function EncodeRdn(const rdn: string): string;
  var
    i: Integer;
  begin
    i := AnsiPos('=', rdn);
    Result := Copy(rdn, 1, i) + EncodeLdapString(Copy(rdn, i + 1, Length(rdn) - i));
  end;

begin
  if cbRdn.Text = '' then
  begin
    cbRdn.SetFocus;
    raise Exception.Create(stNoRdn);
  end;
  if Assigned(ActiveControl.Parent) and Assigned(ActiveControl.Parent.Parent) then
    TInplaceAttribute(ActiveControl).Parent.Parent.SetFocus; // Force OnExit for TInplacexx and TTemplatexx controls
  if esNew in Entry.State then
    Entry.Dn := EncodeRdn(cbRdn.Text) + ',' + edDn.Text;
  Entry.Write;
  if Assigned(fOnWrite) then fOnWrite(Entry);
  Close;
end;

procedure TEditEntryFrm.mbExitClick(Sender: TObject);
begin
  Close;
end;

procedure TEditEntryFrm.mbDeleteRowClick(Sender: TObject);
var
  StringGrid: TStringGrid;
begin
  if ActiveControl is TStringGrid then
    StringGrid := TStringGrid(ActiveControl)
  else
    StringGrid := ((ActiveControl.Owner as TInplaceAttribute).Owner) as TStringGrid;

  if StringGrid = objStringGrid then
  begin
    Entry.AttributesByName['objectclass'].DeleteValue(StringGrid.Cells[0, StringGrid.Row]);
    DeleteRow(StringGrid, StringGrid.Row);
    RefreshAttributeList(true);
  end
  else
    DeleteRow(StringGrid, StringGrid.Row);
end;

procedure TEditEntryFrm.PushShortCutClick(Sender: TObject);
begin
  if ActCut.Visible then
    PushShortCut(Sender as TAction)
  else
    with attrStringGrid do
      ClipBoard.SetTextBuf(PChar(Cells[0, Row] + ': ' + GetValueAsText(TInplaceAttribute(Objects[1, Row]).Value)));
end;

procedure TEditEntryFrm.ToolBtnClick(Sender: TObject);
begin
  if Sender = UndoBtn then
    PushShortcut(ActUndo)
  else
  if Sender = CutBtn then
    PushShortcut(ActCut)
  else
  if Sender = CopyBtn then
    PushShortcut(ActCopy)
  else
  if Sender = PasteBtn then
    PushShortcut(ActPaste)
  else
  if Sender = DeleteBtn then
    PushShortcut(ActDelete)
end;

procedure TEditEntryFrm.FormDestroy(Sender: TObject);
var
  i: Integer;
begin
  fValueSorter.Free;
  fOcSorter.Free;
  ObjectCombo.Free;
  AttributeCombo.Free;
  fBold.Free;
  fTemplateScrollBox.Free;
  Entry.Free;
  for i := 0 to attrStringGrid.Cols[1].Count - 1 do
    attrStringGrid.Cols[1].Objects[i].Free;
end;

procedure TEditEntryFrm.mbLoadFromFileClick(Sender: TObject);
var
  FileStream: TFileStream;
begin
  if not OpenFileDialog.Execute then Exit;
  FileStream := TFileStream.Create(OpenFileDialog.FileName, fmOpenRead);
  with attrStringGrid do
  try
    if Cells[0, Row] <> '' then
    begin
      FileStream.Position := 0;
      TInplaceAttribute(Objects[1, Row]).Value.LoadFromStream(FileStream);
      SetFocus; // In case focus was on inplace control
      Cells[1, Row] := TInplaceAttribute(Objects[1, Row]).CellData;
    end;
  finally
    FileStream.Free;
  end;
end;

procedure TEditEntryFrm.mbSaveToFileClick(Sender: TObject);
var
  FileStream: TTextFile;
begin
  with attrStringGrid do
    if Assigned(Objects[1, Row]) then
    begin
      with TInplaceAttribute(Objects[1, Row]) do
      begin
        SaveDialog.EncodingCombo := Value.DataType = dtText;
        if SaveDialog.Execute then
        begin
          FileStream := TTextFile.Create(SaveDialog.FileName, fmCreate);
          if Value.DataType <> dtText then
            FileStream.Encoding := feAnsi; // raw bytes for binary data
          try
            Value.SaveToStream(FileStream);
            if Value.DataType = dtText then
              FileStream.Encoding := SaveDialog.Encoding;
          finally
            FileStream.Free;
          end;
        end;
    end;
  end;
end;

procedure TEditEntryFrm.mbViewBinaryClick(Sender: TObject);
begin
  with attrStringGrid do
  if Assigned(Objects[1, Row]) then
  with THexView.Create(Self) do try
    StreamCopy(TInplaceAttribute(Objects[1, Row]).Value.SaveToStream, LoadFromStream);
    ShowModal;
  finally
    Free;
  end;
end;

procedure TEditEntryFrm.ActionList1Update(Action: TBasicAction; var Handled: Boolean);
var
  ac: TComponent;

  procedure DoEditItems(IsText: Boolean; eUndo: Boolean = false; eCut: Boolean = false; eDelete: Boolean = false);
  begin
    ActUndo.Visible := IsText;
    ActCut.Visible := IsText;
    //ActCopy.Visible := IsText;
    ActPaste.Visible := IsText;
    ActDelete.Visible := IsText;
    ActCopyName.Visible := not IsText;
    ActCopyValue.Visible := not IsText;

    if not IsText then exit;

    ActUndo.Enabled := eUndo;
    ActCut.Enabled := eCut;
    ActCopy.Enabled := eCut or not IsText;
    ActPaste.Enabled := true;
    ActDelete.Enabled := eDelete;
  end;

begin
  if fNeedRefresh then // Workaround for CloseUp combo event
  begin
    with objStringGrid do
      Cells[Col, Row] := TInplaceComboBox(Objects[col, row]).Control.Text;
    RefreshAttributeList(true);
    fNeedRefresh := false;
  end;

  ActBinView.Enabled := false;
  ActCertView.Visible := false;
  ActPicView.Visible := false;

  ac := ActiveControl;
  if Assigned(ac) then
  begin
    if ac.Owner is TInplaceAttribute then
    begin
      ac := ac.Owner;
      if ac is TInplaceMemo then
        ResizeMemo(TInplaceMemo(ac));
      ac := ac.Owner;
    end;
    if (ac = attrStringGrid) then
    begin
      ac := TComponent(TStringGrid(ac).Objects[1, TStringGrid(ac).Row]);
      if Assigned(ac) and (TInplaceAttribute(ac).Value.DataSize > 0) then
      begin
        ActBinView.Enabled := true;
        case TInplaceAttribute(ac).Value.DataType of
          dtCert: ActCertView.Visible := true;
          dtJpeg: ActPicView.Visible := true;
        end;
      end;
    end;
  end;

  ActDeleteRow.Enabled := (ActiveControl is TStringGrid) or
                          (Assigned(ActiveControl) and (ActiveControl.Owner is TInplaceAttribute)) and
                          (ActiveControl.Owner <> ObjectCombo) and
                          (ActiveControl.Owner <> AttributeCombo);

  if ActiveControl is TCustomEdit then with TCustomEdit(ActiveControl) do
    DoEditItems(true, CanUndo, SelLength > 0, Text <> '')
  else
  if ActiveControl is TCustomComboBox then with TCustomComboBox(ActiveControl) do
    DoEditItems(true, true, SelLength > 0, Text <> '')
  else
    DoEditItems(false);
end;

procedure TEditEntryFrm.StringGridDrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect; State: TGridDrawState);
var
  R: TRect;
  IA: TInplaceAttribute;
begin
  with TStringGrid(Sender) do
  begin
    ///if (gdFixed in State) and Ctl3D then
    if (gdFixed in State) then
    begin
      Canvas.Brush.Color := FixedColor;
      Canvas.Font.Color := clWindowText;
      FillRect(Canvas.Handle, Rect, Canvas.Brush.Handle);
      R := Rect;
      DrawEdge(Canvas.Handle, R, BDR_RAISEDINNER, BF_BOTTOM or BF_TOP or BF_RIGHT or BF_LEFT);
      Inc(R.Top, GridLineWidth);
      Inc(R.Left, GridLineWidth);
      Dec(R.Right, GridLineWidth);
      Dec(R.Bottom, GridLineWidth);
      Canvas.TextRect(R, R.Left + 1, R.Top + 1, Cells[ACol, ARow]);
    end
    else
    begin
      Canvas.Brush.Color := Color;
      SelectObject(Canvas.Handle, Font.Handle);
      if ACol = 0 then
      begin
        if (Sender = objStringGrid) then
          Canvas.Font.Color := clWindow
        else
        begin
          Canvas.Brush.Color := clBtnFace;
          IA := Objects[1, ARow] as TInplaceAttribute;
          if Assigned(IA) and IA.Required then
            SelectObject(Canvas.Handle, fBold.Handle)
        end;
      end;

      Canvas.FillRect(Rect);

      IA := Objects[ACol, ARow] as TInplaceAttribute;
      if Assigned(IA) then
      begin
        if IA.Required then
          SelectObject(Canvas.Handle, fBold.Handle);
        IA.Draw(Sender as TStringGrid, ACol, ARow, Rect, State)
      end
      else
      begin
        Canvas.TextRect(Rect, Rect.Left + 2, Rect.Top + 2, Cells[ACol, ARow]);
        if gdFocused in State then
          Canvas.DrawFocusRect(Rect);
      end;
    end;
  end;
end;

procedure TEditEntryFrm.StringGridSelectCell(Sender: TObject; ACol, ARow: Integer; var CanSelect: Boolean);
begin
  with Sender as TStringGrid do
    if Assigned(Objects[ACol, ARow]) then
      TInplaceAttribute(Objects[ACol, ARow]).DisplayControl(ACol, ARow);
end;

procedure TEditEntryFrm.StringGridTopLeftChanged(Sender: TObject);
var
  ARow, ACol: Integer;
  ac: TInplaceAttribute;
begin
  with Sender as TStringGrid do
  begin
    for ACol := LeftCol to LeftCol + VisibleColCount - 1 do
    for ARow := TopRow to TopRow + VisibleRowCount - 1 do
    begin
      ac := TInplaceAttribute(Objects[ACol, ARow]);
      if Assigned(ac) and ac.ControlVisible then
        ac.DisplayControl(ACol, ARow);
    end;
  end;
end;

procedure TEditEntryFrm.FormResize(Sender: TObject);
begin
  with ObjStringGrid do
    ColWidths[0] := ClientWidth;
  with AttrStringGrid do
    ColWidths[1] := ClientWidth - colWidths[0] - GridLineWidth;
end;

procedure TEditEntryFrm.StringGridMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  p: Tpoint;
  ACol, ARow: Integer;
  sc: TOnSelectCellEvent;
begin
  with Sender as TStringGrid do
  begin
    MouseToCell(X, Y, ACol, ARow);
    if ssRight in Shift then
    begin
      if (ARow > 0) and (ARow < RowCount) and (ACol >= 0) and (ACol < ColCount) then
      begin
        sc := OnSelectCell;
        try
          OnSelectCell := nil;
          Row := ARow;
          Col := ACol;
        finally
          OnSelectCell := sc;
        end;
        p.x := 0;
        p.y := 0;
        p := ClientToScreen(p);
        PopupMenu1.Popup(X + p.x, y + p.y);
      end;
    end
    else
    if not Focused and (X >= (CellRect(ACol, ARow).Right - FButtonWidth)) then
    begin
      ActiveControl.Repaint;
      //--MouseInput.Click(mbLeft,[],0,0);
      LCLSendMouseDownMsg((sender as TControl),0,0, mbLeft);
    end;
  end;
end;

procedure TEditEntryFrm.Splitter1Moved(Sender: TObject);
begin
  if ActiveControl.Owner is TInplaceAttribute then
    (ActiveControl.Owner.Owner as TStringGrid).SetFocus;
  TemplateListBox.Invalidate;
  FormResize(nil);
end;

procedure TEditEntryFrm.ActSchemaCheckExecute(Sender: TObject);
begin
  if AttributeCombo.Focused then
    attrStringGrid.SetFocus;
  RefreshAttributeList(false);
end;

procedure TEditEntryFrm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
  fConnection.Account.WriteBool(rEditorSchemaHelp, SchemaCheckBtn.Down);
  Entry.Session.OnDisconnect.Delete(SessionDisconnect);
end;

procedure TEditEntryFrm.PageControl1Change(Sender: TObject);
begin
  if (PageControl1.ActivePage = TemplateSheet) then
  begin
    if not fTemplatesInited then
      InitTemplates
    else
      fTemplateScrollBox.RefreshData;
  end
  else
    RefreshAttributeList(false);
end;

procedure TEditEntryFrm.cbRdnDropDown(Sender: TObject);
var
  i: Integer;
  Attr: TLdapAttribute;
begin
  cbRdn.Items.Clear;
  for i := 0 to Entry.Attributes.Count - 1 do
  begin
    Attr := Entry.Attributes[i];
    if (lowercase(Attr.Name) <> 'objectclass') and (Attr.AsString <> '') and (Attr.Values[0].DataType = dtText) then
      cbRdn.Items.Add(Attr.Name + '=' + Attr.AsString);
  end;
end;

procedure TEditEntryFrm.TemplateListBoxClick(Sender: TObject);
begin
  fTemplateScrollBox.TemplateIndex := TemplateListBox.ItemIndex - 1;
end;

procedure TEditEntryFrm.TemplateListBoxDrawItem(Control: TWinControl; Index: Integer; Rect: TRect; State: TOwnerDrawState);
begin
  with TemplateListBox do
  begin
    Canvas.Brush.Color:=Color;
    Canvas.FillRect(Rect);
    InflateRect(Rect, -2, -2);
    if odSelected in State then
    begin
      Canvas.Brush.Color:=clBtnFace;
      Canvas.Font.Color:=clBtnText;
      ///Frame3D(Canvas, Rect, clBtnShadow, clBtnHighLight, BevelWidth);
      Frame3D(Canvas, Rect, clBtnShadow, clBtnHighLight, 1);
    end
    else
    begin
      Canvas.Brush.Color:=Color;
      Canvas.Font.Color:=Font.Color;
    end;
    Canvas.FillRect(Rect);
    DrawText(Canvas.Handle, pchar(Items[Index]), -1, Rect, DT_SINGLELINE or DT_CENTER or DT_VCENTER );
  end;
end;

procedure TEditEntryFrm.TemplateBtnAddClick(Sender: TObject);
var
  p: TPoint;
begin
  p:=TemplateBtnAdd.ClientToScreen(point(0, TemplateBtnAdd.Height));
  TemplateBtnAdd.DropdownMenu.Popup(p.X, p.Y);
end;

procedure TEditEntryFrm.TemplateBtnDelClick(Sender: TObject);
var
  idx: Integer;
begin
  with TemplateListBox do
  if ItemIndex > 0 then
  begin
    DeleteTemplate(TTemplate(Items.Objects[ItemIndex]));
    idx := ItemIndex;
    fTemplateScrollBox.Delete(idx - 1);
    Items.Delete(idx);
    if idx < Items.Count then
      ItemIndex := idx
    else
      ItemIndex := Items.Count - 1;
    TemplateListBoxClick(nil);
  end;
end;

procedure TEditEntryFrm.TemplatePopupMenuPopup(Sender: TObject);
var
  i: integer;
  Item: TMenuItem;
begin
  for i := 0 to TemplatePopupMenu.Items.Count - 1 do
  begin
    Item := TemplatePopupMenu.Items[i];
    if TemplateListBox.Items.IndexOf(Item.Caption) <> -1 then
      Item.Visible := false
    else
      Item.Visible := true;
  end;
end;

procedure TEditEntryFrm.TemplatePopupClick(Sender: TObject);
begin
  AddTemplate(TTemplate(TMenuItem(Sender).Tag));
  TemplateListBox.ItemIndex := TemplateListBox.Items.Count - 1;
  TemplateListBoxClick(nil);
end;

procedure HandleWheelPage(StringGrid: TStringGrid; Up: Boolean);
var
  r, d: Integer;
begin
  with StringGrid do
  begin
    d := Height div DefaultRowHeight - 4;
    if d < 0 then d := 0;
    if Up then d := -d;
    r := TopRow;
    inc(r, d);
    if r + VisibleRowCount > RowCount - 1 then
      r := RowCount - VisibleRowCount;
    if r < 1 then r := 1;
    TopRow := r;
  end;
end;

procedure TEditEntryFrm.StringGridMouseWheelDown(Sender: TObject; Shift: TShiftState; MousePos: TPoint; var Handled: Boolean);
begin
  HandleWheelPage(Sender as TStringGrid, false);
  Handled := true;
end;

procedure TEditEntryFrm.StringGridMouseWheelUp(Sender: TObject; Shift: TShiftState; MousePos: TPoint; var Handled: Boolean);
begin
  HandleWheelPage(Sender as TStringGrid, true);
  Handled := true;
end;

procedure TEditEntryFrm.StringGridMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
var
  ACol, ARow: Integer;
  Item: TLdapSchemaItem;

begin
  if not fSchema.Loaded then Exit;
  with (Sender as TStringGrid) do
  begin
    MouseToCell(X, Y, ACol, ARow);
    if ACol = 0 then
    begin
      if Sender = objStringGrid then
        Item := fSchema.ObjectClasses.ByName[Cells[0, ARow]]
      else
        Item := fSchema.Attributes.ByName[Cells[0, ARow]];
      if Assigned(Item) and (Hint <> Item.Description) then
      begin
        Hint := Item.Description;
        LCLSendMouseUpMsg((Sender as TControl),0,0, mbLeft);
      end;
    end
    else
      Hint := '';
  end;
end;

procedure TEditEntryFrm.ActFindInSchemaExecute(Sender: TObject);
var
  StringGrid: TStringGrid;
  s: string;
begin
  if objStringGrid.Focused then
    StringGrid := objStringGrid
  else
    StringGrid := attrStringGrid;
  s := StringGrid.Cells[0, StringGrid.Row];
  MainFrm.ShowSchema.Search(s, true, false);
end;

procedure TEditEntryFrm.FormDeactivate(Sender: TObject);
begin
  RevealWindow(Self, True, True);
end;

procedure TEditEntryFrm.ActPicViewExecute(Sender: TObject);
begin
  with attrStringGrid do
  if Assigned(Objects[1, Row]) then
    with TViewPicFrm.Create(Self, TInplaceAttribute(Objects[1, Row]).Value, smReference) do
    begin
      ShowModal;
      Cells[1, Row] := TInplaceAttribute(Objects[1, Row]).CellData;
    end;
end;

procedure TEditEntryFrm.ActCertViewExecute(Sender: TObject);
begin
  with attrStringGrid do
  if Assigned(Objects[1, Row]) then
    with TInplaceAttribute(Objects[1, Row]).Value do
        ShowContext(Data, DataSize, ctxAuto);
end;

procedure TEditEntryFrm.ActCopyNameExecute(Sender: TObject);
begin
  with attrStringGrid do ClipBoard.SetTextBuf(PChar(Cells[0, Row]));
end;

procedure TEditEntryFrm.ActCopyValueExecute(Sender: TObject);
begin
  with attrStringGrid do ClipBoard.SetTextBuf(PChar(GetValueAsText(TInplaceAttribute(Objects[1, Row]).Value)));
end;

end.
