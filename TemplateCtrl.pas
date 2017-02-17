  {      LDAPAdmin - TemplateCtrl.pas
  *      Copyright (C) 2006-2013 Tihomir Karlovic
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

unit TemplateCtrl;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
{$IFnDEF FPC}
  Windows,
{$ELSE}
  LCLIntf, LCLType,
{$ENDIF}
  Script,
  Classes, Forms, Controls, ComCtrls, StdCtrls, ExtCtrls, Templates, LDAPClasses,
     Graphics, Contnrs, Constant ;

type
  TEventHandler = class
    fEvents: TStringList;
  public
    constructor Create; virtual;
    destructor Destroy; override;
    procedure SetEvents(AControl: TTemplateControl);
    procedure RemoveEvents(AControl: TTemplateControl);
    procedure HandleEvent(Attribute: TLdapAttribute; Event: TEventType);
  end;

  TTemplatePanel = class(TScrollBox)
  private
    fPanel: TTemplateCtrlPanel;
    fControls: TTemplateControlList;
    fAttributes: TTemplateAttributeList;
    fEvents: TTemplateScriptEventList;
    fEntry: TLdapEntry;
    fTemplate: TTemplate;
    fScript: TCustomScript;
    fEventHandler: TEventHandler;
    fHandlerInstalled: Boolean;
    fLeftBorder, fRightBorder: Integer;
    fFixTop: Integer;
    fSpacing, fGroupSpacing: Integer;
    fBreakRequested: Boolean;
    procedure SetTemplate(Template: TTemplate);
    procedure SetEventHandler(AHandler: TeventHandler);
    procedure SetEntry(AEntry: TLdapEntry);
    procedure OnControlChange(Sender: TObject);
    procedure OnControlExit(Sender: TObject);
    procedure ScriptQueryContinue(Sender: TObject; var Allow: Boolean);
  protected
    procedure InstallHandlers;
    procedure RemoveHandlers;
    procedure LoadTemplate; virtual;
    procedure Resize; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure AdjustHeight;
    procedure AdjustControlSizes;
    procedure RefreshData;
    property LdapEntry: TLdapEntry read fEntry write SetEntry;
    property Attributes: TTemplateAttributeList read fAttributes;
    property EventHandler: TEventHandler read fEventHandler write SetEventHandler;
    property Template: TTemplate read fTemplate write SetTemplate;
    property LeftBorder: Integer read fLeftBorder write fLeftBorder;
    property RightBorder: Integer read fRightBorder write fRightBorder;
  end;

  THeaderPanel = class(TPanel)
  private
    FCaptionHeight: integer;
    FBtnRect:       TRect;
    FRolled:        Boolean;
    fTemplatePanel: TTemplatePanel;
    procedure   SetCaptionHeight(const Value: integer);
    procedure   SetRolled(const Value: Boolean);
    procedure   SetTemplatePanel(APanel: TTemplatePanel);
  protected
    procedure   Resize; override;
    procedure   MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
  public
    constructor Create(AOwner: TComponent); override;
    procedure   Paint; override;
    procedure   AdjustHeight;
    property    CaptionHeight: integer read FCaptionHeight write SetCaptionHeight;
    property    Rolled: Boolean read FRolled write SetRolled;
    property    TemplatePanel: TTemplatePanel read fTemplatePanel write SetTemplatePanel;
  end;

  TTemplateBox = class(TScrollBox)
  private
    fEventHandler: TEventHandler;
    fTemplateList: TList;
    fTemplateIndex: Integer;
    fTemplateHeaders: Boolean;
    fFlatPanels: Boolean;
    fShowAll: Boolean;
    fEntry: TLdapEntry;
    function  GetTemplate(Index: Integer): TTemplatePanel;
    function  GetTemplateCount: Integer;
    procedure SetTemplateIndex(AValue: Integer);
    procedure SetTemplateHeaders(AValue: Boolean);
    procedure SetFlatPanels(AValue: Boolean);
    procedure SetShowAll(AValue: Boolean);
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Add(ATemplate: TTemplate);
    procedure Insert(ATemplate: TTemplate; Index: Integer);
    procedure Move(FromIndex, ToIndex: Integer);
    procedure Delete(Index: Integer);
    procedure Display; virtual;
    procedure RefreshData;
    property  Templates[Index: Integer]: TTemplatePanel read GetTemplate;
    property  TemplateCount: Integer read GetTemplateCount;
    property  TemplateIndex: Integer read fTemplateIndex write SetTemplateIndex;
    property  TemplateHeaders: Boolean read fTemplateHeaders write SetTemplateHeaders;
    property  FlatPanels: Boolean read fFlatPanels write SetFlatPanels;
    property  ShowAll: Boolean read fShowAll write SetShowAll;
    property  LdapEntry: TLdapEntry read fEntry write fEntry;
  end;

  TTemplateForm = class(TForm)
  private
    fEntry: TLdapEntry;
    fEventHandler: TEventHandler;
    fTemplatePanels: TList;
    fRdn: string;
    procedure OKBtnClick(Sender: TObject);
    procedure CancelBtnClick(Sender: TObject);
  protected
    procedure KeyPress(var Key: Char); override;
  public
    PageControl: TPageControl;
    constructor Create(AOwner: TComponent; adn: string; ASession: TLDAPSession; Mode: TEditMode); reintroduce;
    destructor  Destroy; override;
    procedure   AddTemplate(ATemplate: TTemplate);
    procedure   LoadMatching;
    class function  HasMatchingTemplates(Entry: TLDapEntry): Boolean;
    property    TemplatePanels: TList read fTemplatePanels;
  end;

implementation

{$I LdapAdmin.inc}

uses SysUtils, Misc, Config, Grids, ParseErr, Dialogs
     {$IFDEF VER_XEH}, System.Types{$ENDIF};

{ TEventHandler }

constructor TEventHandler.Create;
begin
  fEvents := TStringList.Create;
end;

destructor TEventHandler.Destroy;
var
  i: Integer;
begin
  for i := 0 to fEvents.Count - 1 do
    fEvents.Objects[i].Free;
  fEvents.Free;
  inherited;
end;

procedure TEventHandler.SetEvents(AControl: TTemplateControl);
var
  i, idx: Integer;
begin
  if Assigned(AControl.Params) then
  for i := 0 to AControl.Params.Count - 1 do
  begin
    idx := fEvents.IndexOf(AControl.Params[i]);
    if idx = -1 then
      idx := fEvents.AddObject(AControl.Params[i], TList.Create);
    TList(fEvents.Objects[idx]).Add(Pointer(AControl));
  end;
end;

procedure TEventHandler.RemoveEvents(AControl: TTemplateControl);
var
  i, j: Integer;

  procedure Remove(idx: Integer);
  var
    si: Integer;
  begin
    with TList(fEvents.Objects[idx]) do
    begin
      si := IndexOf(Pointer(AControl));
      if si <> -1 then
      begin
        Delete(si);
        if Count = 0 then
          fEvents.Delete(idx);
      end;
    end;
  end;

begin
  for i := 0 to AControl.Params.Count - 1 do
    for j := fEvents.Count - 1 downto 0 do
      Remove(j);
end;

procedure TEventHandler.HandleEvent(Attribute: TLdapAttribute; Event: TEMPLATES.TEventType);
///procedure TEventHandler.HandleEvent(Attribute: TLdapAttribute; Event: TEventType);
var
  idx, i: Integer;
begin
  idx := fEvents.IndexOf(Attribute.Name);
  if idx <> -1 then with TList(fEvents.Objects[idx]) do
    for i := 0 to Count - 1 do
      TTemplateControl(Items[i]).EventProc(Attribute, Event);
end;

{ TTemplatePanel }

procedure TTemplatePanel.OnControlChange(Sender: TObject);
begin
  if (Sender is TTemplateControl) and Assigned(fEntry) and Assigned(TTemplateControl(Sender).TemplateAttribute) then
    fEventHandler.HandleEvent(fEntry.AttributesByName[TTemplateControl(Sender).TemplateAttribute.Name], etChange);
end;

procedure TTemplatePanel.OnControlExit(Sender: TObject);
begin
  if (Sender is TTemplateControl) and Assigned(fEntry) and Assigned(TTemplateControl(Sender).TemplateAttribute) then
    fEventHandler.HandleEvent(fEntry.AttributesByName[TTemplateControl(Sender).TemplateAttribute.Name], etUpdate);
end;

procedure TTemplatePanel.SetTemplate(Template: TTemplate);
begin
  if fTemplate = Template then Exit;
  LockControl(Self, true);
  try
    fTemplate := Template;
    LoadTemplate;
  finally
    LockControl(Self, false);
  end;
end;

procedure TTemplatePanel.SetEventHandler(AHandler: TeventHandler);
begin
  if fEventHandler = AHandler then Exit;
  RemoveHandlers;
  fEventHandler := AHandler;
  InstallHandlers;
end;

procedure TTemplatePanel.SetEntry(AEntry: TLdapEntry);
begin
  if fEntry = AEntry then Exit;
  LockControl(Self, true);
  try
    fEntry := AEntry;
    LoadTemplate;
  finally
    LockControl(Self, false);
  end;
end;

procedure TTemplatePanel.ScriptQueryContinue(Sender: TObject; var Allow: Boolean);
begin

  ///if (GetAsyncKeyState(VK_CANCEL) <> 0) and (MessageBox(Handle, PChar(stAbortScript), PChar(cConfirm), MB_ICONQUESTION + MB_YESNO) = mrYes) then
  if (GetKeyState(VK_CANCEL) <> 0) and (MessageBox(Handle, PChar(stAbortScript), PChar(cConfirm), MB_ICONQUESTION + MB_YESNO) = mrYes) then
  begin
    fBreakRequested := true;
    Allow := false;
  end;
end;

procedure TTemplatePanel.InstallHandlers;
var
  i: Integer;
  NotParented: Boolean;
begin

  if fHandlerInstalled or not (Assigned(fEventHandler) and Assigned(fTemplate)) then Exit;

  for i := 0 to fControls.Count - 1 do with fControls[i] do
  begin
    { Set hooks }
    fEventHandler.SetEvents(fControls[i]);
    { Set event handlers }
    OnChange := OnControlChange;
    OnExit := OnControlExit;
  end;

  fHandlerInstalled := true;

  { Some VCL Controls require visible parents on property access!!! ( like
    TComboBox for access to Items or ItemIndex properties! )               }
  NotParented := not Assigned(Parent);
  if NotParented then
  begin
    Visible := false;
    Parent := Application.MainForm;
  end;
  try
    { Trigger events for all attributes }
    for i := 0 to fEntry.Attributes.Count - 1 do
    begin
      fEventHandler.HandleEvent(fEntry.Attributes[i], etChange);
      fEventHandler.HandleEvent(fEntry.Attributes[i], etUpdate);
    end;
  finally
    if NotParented then
    begin
      Parent := nil;
      Visible := true;
    end;
  end;

end;

procedure TTemplatePanel.RemoveHandlers;
var
  i: Integer;
begin
  if fHandlerInstalled then
  begin
    for i := 0 to fControls.Count - 1 do
      fEventHandler.RemoveEvents(fControls[i]);
    fHandlerInstalled := false;
  end;
end;

procedure TTemplatePanel.LoadTemplate;
var
  Oc: TLdapAttribute;
  Active: Boolean;
  i: Integer;
  NotParented: Boolean;

  { Connect controls to data sources }
  procedure HandleElements(Elements: TObjectList);
  var
    i, j: Integer;
    Element: TObject;
    TemplateControl: TTemplateControl;
    Attribute: TLdapAttribute;
  begin
    for i := 0 to Elements.Count - 1 do
    begin
      Element := Elements[i];
      if Element is TTemplateAttribute then with TTemplateAttribute(Element) do
      begin
        fAttributes.Add(Element);
        Attribute := fEntry.AttributesByName[Name];
        for j := 0 to Controls.Count - 1 do
        begin
          TemplateControl := Controls[j];
          { Set values }
          TemplateControl.UseDefaults := not Active;
          TemplateControl.LdapAttribute := Attribute;
        end;
        HandleElements(Controls);
      end
      else
      if Element is TTemplateControl then
      begin
        if Assigned(fEntry) then
          TTemplateControl(Element).LdapSession := fEntry.Session;      
        fControls.Add(Element);
        HandleElements(TTemplateControl(Element).Elements);
      end
      else
      if Element is TTemplateScriptEvent then
        fEvents.Add(Element);
    end;
  end;

  { Attach datacontrols to driver controls }
  procedure HandleDataControls;
  var
    i, j: Integer;
  begin
    for i := 0 to fControls.Count - 1 do with fControls[i] do
      if DataControlName <> '' then
        for j := 0 to fControls.Count - 1 do
          if (j <> i) and (DataControlName = fControls[j].Name) then
            SetDataControl(fControls[j]);
  end;

begin
  fControls.Clear;
  fAttributes.Clear;
  fPanel.Elements.Clear; // added 27.12.07 --
  with TPanel(fPanel.Control) do
    while ControlCount > 0 do Controls[ControlCount - 1].Free; // --

  if not (Assigned(fTemplate) and Assigned(fEntry)) then
    Exit;

  { Some VCL Controls require visible parents on property access!!! ( like
    TComboBox for access to Items or ItemIndex properties! )               }
  NotParented := not Assigned(Parent);
  if NotParented then
  begin
    Visible := false;
    Parent := Application.MainForm;
  end;
  try
    //TODO - ParseError
    try
      fTemplate.Parse(fPanel, fScript);
      except on E: Exception do
      begin
        E.Message := fTemplate.Name + ': ' + E.Message;
        raise;
      end;
    end;

    Self.Height := fPanel.Control.Height;
    Self.Width := fPanel.Control.Width;

    { If template matches existing objectclasses of the entry we set the flag to
    { avoid setting default values to attributes which are deliberatly left empty }
    Oc := fEntry.AttributesByName['objectclass'];
    Active := Assigned(OC) and Template.Matches(OC);
    { Always add objectclasses }
    with OC do
      for i := 0 to Template.ObjectclassCount - 1 do
        AddValue(Template.Objectclasses[i]);

    HandleElements(fPanel.Elements);
    HandleDataControls;

    if fTemplate.AutoArrangeControls then
      fPanel.ArrangeControls;
    AdjustControlSizes;

    if not Active then InstallHandlers;
    (*
    if Assigned(fScript) then
    try
      fScript.OnQueryContinue := ScriptQueryContinue;    
      fScript.AddScriptlet(CreateWinControlScriptlet(fScript, fPanel.Control as TWinControl, 'form'));
      fScript.AddScriptlet(CreateScriptlet(fScript, fEntry.Session, 'session'));
      fScript.AddScriptlet(CreateScriptlet(fScript, fEntry, 'entry'));
      fScript.Execute;
      for i := 0 to fEvents.Count - 1 do with fEvents[i] do
      try
        FScript.AddEventHandlerCode(CreateComponentScriptlet(FScript, Control.Control) as IObjectScriptlet, Name, Code);
      except
        on E: EScriptException do
          ParseError(mtError, Application.MainForm, Name, E.Message, E.Message2, Code, E.Identifier, E.Line, E.Position);
        on E: Exception do
          raise;
      end;
      { If there is OnRead event installed by the script we trigger it again since }
      { the original OnRead event was triggered before the script was activated. }
      if Assigned(fEntry.OnRead) then fEntry.OnRead(fEntry);
    except
      on E: EScriptException do
      begin
        if fBreakRequested then
          ParseError(mtInformation, Application.MainForm, fTemplate.Name, stUserBreak, '', E.Code, E.Identifier, E.Line, E.Position)
        else
          ParseError(mtError, Application.MainForm, fTemplate.Name, E.Message, E.Message2, E.Code, E.Identifier, E.Line, E.Position);
        Abort;
      end;
      on E: Exception do
        raise;
    end;
    *)
  finally
    if NotParented then
    begin
      Parent := nil;
      Visible := true;
    end;
  end;
end;

procedure TTemplatePanel.Resize;
begin
  inherited;
  ///AdjustControlSizes;
end;

constructor TTemplatePanel.Create(AOwner: TComponent);
begin
  inherited;
  fPanel := TTemplateCtrlPanel.Create(nil);
  TPanel(fPanel.Control).BevelInner := bvNone;
  TPanel(fPanel.Control).BevelOuter := bvNone;
  TPanel(fPanel.Control).Parent := Self;
  fControls := TTemplateControlList.Create;
  fControls.OwnsObjects := false;
  fAttributes := TTemplateAttributeList.Create;
  fAttributes.OwnsObjects := false;
  fEvents := TTemplateScriptEventList.Create;
  fEvents.OwnsObjects := false;
  fLeftBorder := CT_LEFT_BORDER;
  fRightBorder := CT_RIGHT_BORDER;
  fFixTop := CT_FIX_TOP;
  fGroupSpacing := CT_GROUP_SPACING;
  fSpacing := CT_SPACING;
end;

destructor TTemplatePanel.Destroy;
begin
  fScript.Free;
  fPanel.Free;
  fEvents.Free;
  fAttributes.Free;
  fControls.Free;
  inherited;
end;

procedure TTemplatePanel.AdjustHeight;
begin
  if ControlCount > 0 then with Controls[ControlCount - 1] do
    Self.ClientHeight := Top + Height + fSpacing;
end;

procedure TTemplatePanel.AdjustControlSizes;
begin
  if fTemplate.AutoSizeControls then
  begin
    fPanel.Control.Width := ClientWidth*3;
    //fPanel.Control.Width := 550;
    fPanel.AdjustSizes;
  end;
end;

procedure TTemplatePanel.RefreshData;
var
  i: Integer;
begin
  if Assigned(fTemplate) then
    for i := 0 to fControls.Count - 1 do
      fControls[i].Read;
end;

{ THeaderPanel }

constructor THeaderPanel.Create(AOwner: TComponent);
begin
  inherited;
  FCaptionHeight:=21;
  FRolled:=false;
  Canvas.Font.Color:=clWhite;
  Canvas.Font.Style:=[fsBold];
  Canvas.Font.Size:=9;
  Canvas.Pen.Color := Canvas.Font.Color;
end;

procedure THeaderPanel.SetCaptionHeight(const Value: integer);
begin
  FCaptionHeight := Value;
  invalidate;
end;

procedure THeaderPanel.SetRolled(const Value: Boolean);
begin
  FRolled := Value;
  if FRolled then
    Height := FCaptionHeight + 2
  else
    AdjustHeight;
end;

procedure THeaderPanel.SetTemplatePanel(APanel: TTemplatePanel);
begin
  fTemplatePanel := APanel;
  fTemplatePanel.Parent := Self;
  fTemplatePanel.Width := Width;
  AdjustHeight;
end;

procedure THeaderPanel.Paint;
const
  len=3;
var
  TxtRect: TRect;
  p: TPoint;
begin

  // Calc button rect //////////////////////////////////////////////////////////
  FBtnRect.Top:=1;
  FBtnRect.Bottom:=FCaptionHeight;
  FBtnRect.Right:=Width;
  InflateRect(FBtnRect, -3, -3);
  if odd(FBtnRect.Bottom-FBtnRect.Top) then FBtnRect.Top:=FBtnRect.Top-1;
  FBtnRect.Left:=FBtnRect.Right-(FBtnRect.Bottom-FBtnRect.Top);


  //////////////////////////////////////////////////////////////////////////////

  ///Canvas.Brush.Color:=clAppWorkSpace;
  Canvas.Brush.Color:=clBtnShadow;

  Canvas.Font.Color:=clWhite;
  Canvas.Font.Style:=[fsBold];
  Canvas.Font.Size:=9;

  Canvas.FillRect(rect(1, 1, Width, FCaptionHeight));
  TxtRect:=rect(2, 1, FBtnRect.Left-4, FCaptionHeight);
  DrawText(Canvas.Handle, pchar(TemplatePanel.Template.Name), -1, TxtRect, DT_SINGLELINE or DT_VCENTER or DT_NOPREFIX or DT_END_ELLIPSIS);

  // Draw button rectangle /////////////////////////////////////////////////////
  Canvas.Polyline([point(FBtnRect.Left+1, FBtnRect.Top),point(FBtnRect.Right-1, FBtnRect.Top)]);
  Canvas.Polyline([point(FBtnRect.Right-1, FBtnRect.Top+1),point(FBtnRect.Right-1, FBtnRect.Bottom-1)]);
  Canvas.Polyline([point(FBtnRect.Left+1, FBtnRect.Bottom-1),point(FBtnRect.Right-1, FBtnRect.Bottom-1)]);
  Canvas.Polyline([point(FBtnRect.Left, FBtnRect.Top+1),point(FBtnRect.Left, FBtnRect.Bottom-1)]);

  // Draw button sign //////////////////////////////////////////////////////////
  p.x := FBtnRect.Left + (FBtnRect.Right - FBtnRect.Left) div 2;
  p.y := FBtnRect.Top + (FBtnRect.Bottom - FBtnRect.Top) div 2;
  Canvas.Polyline([point(FBtnRect.Left+len, p.Y), point(FBtnRect.Right-len, p.Y)]);
  Canvas.Polyline([point(FBtnRect.Left+len, p.Y-1), point(FBtnRect.Right-len, p.Y-1)]);
  if Rolled then
  begin
    Canvas.Polyline([point(p.X, FBtnRect.Top+len), point(p.X, FBtnRect.Bottom-len)]);
    Canvas.Polyline([point(p.X-1, FBtnRect.Top+len), point(p.X-1, FBtnRect.Bottom-len)]);
  end;
end;

procedure THeaderPanel.AdjustHeight;
begin
  fTemplatePanel.Top := FCaptionHeight;
  fTemplatePanel.AdjustHeight;
  Height := FCaptionHeight + fTemplatePanel.Height;
end;

procedure THeaderPanel.Resize;
begin
  inherited;
  if Assigned(fTemplatePanel) then
    fTemplatePanel.Width := Width;
end;

procedure THeaderPanel.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  inherited;
   if (ssDouble in Shift) or (PtInRect(FBtnRect, point(X,Y))) then
      Rolled:=not Rolled;
end;

{ TTemplateBox }

function TTemplateBox.GetTemplate(Index: Integer): TTemplatePanel;
begin
  Result := THeaderPanel(fTemplateList[Index]).TemplatePanel;
end;

function TTemplateBox.GetTemplateCount: Integer;
begin
  Result := fTemplateList.Count;
end;

procedure TTemplateBox.SetTemplateIndex(AValue: Integer);
begin
  fTemplateIndex := AValue;
  Display;
end;

procedure TTemplateBox.SetTemplateHeaders(AValue: Boolean);
begin
  fTemplateHeaders := AValue;
  Display;
end;

procedure TTemplateBox.SetFlatPanels(AValue: Boolean);
begin
  fFlatPanels := AValue;
  Display;
end;

procedure TTemplateBox.SetShowAll(AValue: Boolean);
begin
  fShowAll := AValue;
  Display;
end;

constructor TTemplateBox.Create(AOwner: TComponent);
begin
  inherited;
  fEventHandler := TEventHandler.Create;
  fTemplateList := TTemplateList.Create;
  TemplateIndex := -1;
  fShowAll := true;
  fTemplateHeaders := true;
end;

destructor  TTemplateBox.Destroy;
var
  i: Integer;
begin
  with fTemplateList do begin
    for i := 0 to Count - 1 do
      THeaderPanel(fTemplateList[i]).Free;
    Free;
  end;
  fEventHandler.Free;
  inherited;
end;

procedure TTemplateBox.Add(ATemplate: TTemplate);
var
  pnl: THeaderPanel;
  TemplatePanel: TTemplatePanel;
begin
  LockControl(Self, true);
  try
    TemplatePanel := TTemplatePanel.Create(Self);
    TemplatePanel.LdapEntry := fEntry;
    TemplatePanel.EventHandler := fEventHandler;
    with TemplatePanel do
    begin
      Template := ATemplate;
      if fFlatPanels then
      begin
        BorderStyle := bsNone;
        RightBorder := LeftBorder;
      end
      else begin
        BorderStyle := bsSingle;
        RightBorder := CT_RIGHT_BORDER;
      end;
    end;

    pnl:=THeaderPanel.Create(self);
    pnl.Parent:=Self;
    pnl.Align := alBottom; // push it to the end
    pnl.Align := alTop;    // then allign on the top of the last panel

    TemplatePanel.Anchors := [akLeft, akRight, akTop];
    pnl.TemplatePanel := TemplatePanel;
    ///TemplatePanel.Anchors := [akLeft, akRight, akTop];
    fTemplateList.Add(pnl);
  finally
    LockControl(Self, false);
  end;
end;

procedure TTemplateBox.Insert(ATemplate: TTemplate; Index: Integer);
var
  TemplatePanel: TTemplatePanel;
begin
  TemplatePanel := TTemplatePanel.Create(Self);
  TemplatePanel.Template := ATemplate;
  fTemplateList.Insert(Index, ATemplate);
end;

procedure TTemplateBox.Move(FromIndex, ToIndex: Integer);
begin
  fTemplateList.Move(FromIndex, ToIndex);
end;

procedure TTemplateBox.Delete(Index: Integer);
begin
  TTemplatePanel(fTemplateList[Index]).Free;
  fTemplateList.Delete(Index);
end;

procedure TTemplateBox.Display;
var
  i: integer;
begin
  try
    LockControl(Self, true);
    for i:=0 to fTemplateList.Count-1 do
      THeaderPanel(fTemplateList[i]).Visible := ((fTemplateIndex = -1) and fShowAll) or (fTemplateIndex=i);
    if fTemplateIndex <> -1 then THeaderPanel(fTemplateList[fTemplateIndex]).Rolled := false;
  finally
    LockControl(Self, false);
  end;
end;

procedure TTemplateBox.RefreshData;
var
  i: Integer;
begin
  for i := 1 to fTemplateList.Count - 1 do
    TTemplatePanel(fTemplateList[i]).Refresh;
end;

{ TTemplateForm }

procedure TTemplateForm.OKBtnClick(Sender: TObject);
var
  i, j: Integer;
  S: TStringList;
  ardn, aval: string;
begin
  try
    if esNew in fEntry.State then
    begin
      S := TStringList.Create;
      try
        for i := 0 to fTemplatePanels.Count - 1 do with TTemplatePanel(fTemplatePanels[i]) do
        begin
          { check required }
          for j := 0 to Attributes.Count - 1 do
            if Attributes[j].Required and fEntry.AttributesByName[Attributes[j].Name].Empty then
              raise Exception.Create(Format(stRequired, [Attributes[j].Name]));
          { designated rdn }
          if Template.Rdn <> '' then
          begin
            aval := fEntry.AttributesByName[Template.Rdn].AsString;
            if aval <> '' then
              S.Add(Template.Rdn + '=' + aval);
          end;
        end;
        if S.Count = 1 then
          ardn := S[0]
        else
          if ComboMessageDlg(cEnterRDN, S.CommaText, ardn) <> mrOk then
            Abort;
        fEntry.Dn := ardn + ',' + fRdn;
      finally
        S.Free;
      end;
    end;
    fEntry.Write;
  except
    ModalResult := mrNone;
    raise;
  end;
  CancelBtnClick(nil); // Close form if not modal
end;

procedure TTemplateForm.CancelBtnClick(Sender: TObject);
begin
  if not (fsModal in FormState) then
    Close;
end;

procedure TTemplateForm.KeyPress(var Key: Char);
begin
  inherited;
  if (Key = #27) then
  begin
    if ActiveControl is TCustomEdit then
      TCustomEdit(ActiveControl).Text := ''
    else
    if ActiveControl is TComboBox then
      TComboBox(ActiveControl).Text := ''
    else
    if ActiveControl is TStringGrid then with TStringGrid(ActiveControl) do
      Cells[Col, Row] := '';
  end;
end;

constructor TTemplateForm.Create(AOwner: TComponent; adn: string; ASession: TLDAPSession; Mode: TEditMode);
var
  Panel: TPanel;
  Btn : TButton;
begin
  inherited CreateNew(AOwner);
  KeyPreview := true;

  fEventHandler := TEventHandler.Create;
  fTemplatePanels := TList.Create;
  fRdn := adn;
  fEntry := TLdapEntry.Create(ASession, adn);
  if Mode = EM_MODIFY then
  begin
    Caption := Format(cEditEntry, [adn]);
    fEntry.Read;
  end
  else
    Caption := cNewEntry;

  Height := GlobalConfig.ReadInteger(rTemplateFormHeight, 540);
  Width := GlobalConfig.ReadInteger(rTemplateFormWidth, 440);
  Position := poOwnerFormCenter;

  Panel := TPanel.Create(Self);
  Panel.Parent := Self;
  Panel.Align := alBottom;
  Panel.Height := 34;

  PageControl := TPageControl.Create(Self);
  PageControl.Parent := Self;
  PageControl.Align := alClient;

  Btn := TButton.Create(Self);
  with Btn do
  begin
    Parent := Panel;
    Top := 4;
    Left := Panel.Width - Width - 4;
    Anchors := [akTop, akRight];
    ModalResult := mrCancel;
    Caption := cCancel;
  end;

  with TButton.Create(Self) do
  begin
    Parent := Panel;
    Top := 4;
    Left := Btn.Left - Width - 8;
    Anchors := [akTop, akRight];
    TabOrder := 0;
    Default := true;
    ModalResult := mrOk;
    Caption := cOk;
    OnClick := OkBtnClick;
  end;
end;

destructor TTemplateForm.Destroy;
begin
  inherited;
  fEventHandler.Free;
  fTemplatePanels.Free;
  fEntry.Free;
  try
    GlobalConfig.WriteInteger(rTemplateFormHeight, Height);
    GlobalConfig.WriteInteger(rTemplateFormWidth, Width);
  except end; // just in case
end;

procedure TTemplateForm.AddTemplate(ATemplate: TTemplate);
var
  Panel: TTemplatePanel;
  TabSheet: TTabSheet;
begin
  Panel := TTemplatePanel.Create(Self);
  Panel.Template := ATemplate;
  Panel.LdapEntry := fEntry;
  Panel.EventHandler := fEventHandler;
  TabSheet := TTabSheet.Create(Self);
  TabSheet.Caption := ATemplate.Name;
  TabSheet.PageControl := PageControl;
  Panel.Parent := TabSheet;
  Panel.Align := alClient;
  fTemplatePanels.Add(Panel);
  if TabSheet.TabIndex = 0 then
    ActiveControl := Panel.FindNextControl(nil, true, true, false);
end;

procedure TTemplateForm.LoadMatching;
var
  Oc: TLdapAttribute;
  i: Integer;
  Template: TTemplate;
begin
  if esNew in fEntry.State then Exit;
  Oc := fEntry.AttributesByName['objectclass'];
  for i := 0 to TemplateParser.Count - 1 do
  begin
    Template := TemplateParser.Templates[i];
    if Assigned(Oc) and Template.Matches(Oc) then
      AddTemplate(Template);
  end;
end;

class function TTemplateForm.HasMatchingTemplates(Entry: TLdapEntry): Boolean;
var
  Oc: TLdapAttribute;
  i: Integer;
begin
  Result := false;
  Oc := Entry.AttributesByName['objectclass'];
  if not Assigned(Oc) then exit;
  for i := 0 to TemplateParser.Count - 1 do
    if TemplateParser.Templates[i].Matches(Oc) then
    begin
      Result := true;
      break;
    end;
end;

end.
