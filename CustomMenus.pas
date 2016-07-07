  {      LDAPAdmin - CustomMenus.pas
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

unit CustomMenus;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses Classes, Contnrs, Menus, Templates, Config, LDAPClasses, ObjectInfo, Constant;

type
  PCtrlRec = ^TCtrlRec;
  TCtrlRec = record
    Key: Char;
    Shift: TShiftState;
  end;

const
  aidNone              = -1;
  aidSeparatorItem     =  0; // Menu separator
  aidNodeItem          =  1; // the item is used as a node (submenu) item
  aidTemplate          =  2;
  aidEntry             =  3;
  aidUser              =  4;
  aidComputer          =  5;
  aidGroup             =  6;
  aidMailingList       =  7;
  aidTransportTable    =  8;
  aidOU                =  9;
  aidHost              = 10;
  aidLocality          = 11;
  aidGroupOfUN         = 12;
  aidAlias             = 13;

type
  TCustomMenuItem = class;
  TCustomActionItem = class;

  TActionChangeEvent = procedure(Sender: TCustomActionItem) of object;

  TCustomActionItem = class
  private
    fParent:       TCustomActionItem;
    fItems:        TObjectList;
    fTemplateName: string;
    fCaption:      string;
    fAction:       TBasicAction;
    fShortCut:     TShortCut;
    fEnabled:      Boolean;
    fImageIndex:   Integer;
    fActionId:     Integer;
    fDefaultAction: Integer;
    fOnActionChange: TActionChangeEvent;
    function       GetItem(Index: Integer): TCustomActionItem;
    function       GetCount: Integer;
    function       GetImageIndex: Integer;
    procedure      SetActionId(Value: Integer);
    procedure      SetTemplateName(Value: string);
  public
    constructor    Create(AParent: TCustomActionItem);
    destructor     Destroy; override;
    procedure      CloneTo(MenuItem: TCustomMenuItem);
    procedure      Clone(ActionItem: TCustomActionItem);
    procedure      Add(ActionItem: TCustomActionItem);
    procedure      Delete(Index: Integer);
    procedure      Move(CurIndex, NewIndex: Integer); overload;
    procedure      Move(Dest: TCustomActionItem; Index: Integer); overload;
    function       FindAction(ActionId: Integer): TCustomActionItem;
    function       FindTemplate(Entry: TLdapEntry): TTemplate;
    property       Parent: TCustomActionItem read fParent;
    property       Items[Index: Integer]: TCustomActionItem read GetItem; default;
    property       Count: Integer read GetCount;
    property       TemplateName: string read fTemplateName write SetTemplateName; //fTemplateName;
    property       Caption: string read fCaption write fCaption;
    property       Action: TBasicAction read fAction write fAction;
    property       ShortCut: TShortCut read fShortCut write fShortCut;
    property       Enabled: Boolean read fEnabled write fEnabled;
    property       ImageIndex: Integer read fImageIndex;
    property       ActionId: Integer read fActionId write SetActionId;
    property       DefaultAction: Integer read fDefaultAction;
    property       OnActionChange: TActionChangeEvent read fOnActionChange write fOnActionChange;
  end;

  TCustomActionMenu = class
  private
    FObjectIdToAction: array of Integer;
    fItems:        TCustomActionItem;
    fTemplateMenu: TCustomMenuItem;
    fOnClick:      TNotifyEvent;
    fConfig:       TConfig;
    procedure      SetOnClick(Value: TNotifyEvent);
    procedure      ActionChange(Sender: TCustomActionItem);
  public
    constructor    Create(Config: TConfig); virtual;
    destructor     Destroy; override;
    function       Load: Boolean; virtual;
    procedure      Save; virtual;
    procedure      Clone(ActionMenu: TCustomActionMenu);
    procedure      AddMenuItem(ACaption: string; AActionId: Integer = -1; AShortCut: PCtrlRec = nil);
    procedure      AssignItems(MenuItem: TMenuItem);
    function       GetActionId(const ObjectID: Integer): Integer;
    function       GetActionTemplate(Entry: TLdapEntry): TTemplate;
    function       GetActionItem(Actionid: Integer): TCustomActionItem;
    property       Items: TCustomActionItem read FItems;
    property       TemplateMenu: TCustomMenuItem read fTemplateMenu write fTemplateMenu;
    property       OnClick: TNotifyEvent read fOnClick write SetOnClick;
  end;

  TPosixActionMenu = class(TCustomActionMenu)
  public
    constructor    Create(Config: TConfig); override;
  end;

  TADActionMenu = class(TCustomActionMenu)
  public
    constructor Create(Config: TConfig); override;
  end;

  TCustomMenuItem = class(TMenuItem)
  private
    fTemplateName:  string;
    fActionId:      Integer;
    procedure       SetTemplateName(Value: string);
  public
    procedure       Clone(MenuItem: TCustomMenuItem);
    property        TemplateName: string read fTemplateName write SetTemplateName;
    property        ActionId: Integer read fActionId;
  end;

function GetActionImage(ActionId: Integer): Integer;

implementation

{$I LdapAdmin.inc}

uses Connection, Sysutils {$IFDEF VER_XEH}, System.Types{$ENDIF};

const
  CONF_MENU    =    '\Menu\';

  scCtrlG: TCtrlRec = ( Key: 'G';
                        Shift: [ssCtrl]);
  scCtrlU: TCtrlRec = ( Key: 'U';
                        Shift: [ssCtrl]);
  scCtrlW: TCtrlRec = ( Key: 'W';
                        Shift: [ssCtrl]);
  scCtrlO: TCtrlRec = ( Key: 'O';
                        Shift: [ssCtrl]);


  ActionIdToImage: array[aidSeparatorItem..aidAlias] of Integer = (
                    -1,
                    -1,
                    -1,
                    bmEntry,
                    bmSamba3User,
                    bmComputer,
                    bmGroup,
                    bmMailGroup,
                    bmTransport,
                    bmOU,
                    bmHost,
                    bmLocality,
                    bmGrOfUnqNames,
                    bmAlias);

  ActionIdToObject: array[aidUser..aidAlias] of Integer = (
                    oidSambaUser,
                    oidComputer,
                    oidGroup,
                    oidMailGroup,
                    oidTransportTable,
                    oidOU,
                    oidHost,
                    oidLocality,
                    oidGroupOfUN,
                    oidAlias);

  ObjectIdToAction: array[oidEntry..oidADConfiguration] of Integer = (
                    aidNone,
                    aidNone,
                    aidUser,
                    aidUser,
                    aidComputer,
                    aidGroup,
                    aidGroup,
                    aidMailingList,
                    aidTransportTable,
                    aidOU,
                    aidHost,
                    aidLocality,
                    aidGroupOfUN,
                    aidAlias,
                    aidNone,
                    aidNone,
                    aidNone,
                    aidNone,
                    aidNone,
                    aidNone,
                    aidNone,
                    aidNone,
                    aidNone,
                    aidNone,
                    aidNone);

function GetActionImage(ActionId: Integer): Integer;
begin
  Result := ActionIdToImage[ActionId];
end;

{ TCustomMenuItem }

procedure TCustomMenuItem.SetTemplateName(Value: string);
var
  i: Integer;
begin
  fTemplateName := Value;
  i := TemplateParser.IndexOf(Value);
  if (i <> -1) then
    Bitmap := TemplateParser.Templates[i].Icon;
end;

procedure TCustomMenuItem.Clone(MenuItem: TCustomMenuItem);
var
  newItem: TCustomMenuItem;
  i: Integer;
begin
  if not Assigned(MenuItem) then exit;

  MenuItem.Caption := Caption;
  MenuItem.Action := Action;
  MenuItem.ShortCut := ShortCut;
  MenuItem.Enabled := Enabled;
  MenuItem.Visible := Enabled;
  MenuItem.ImageIndex := ImageIndex;
  MenuItem.fActionId := fActionId;
  MenuItem.Bitmap := Bitmap;
  MenuItem.fTemplateName := TemplateName;
  MenuItem.OnClick := OnClick;
  MenuItem.Clear;
  for i:= 0 to Count - 1 do
  begin
    NewItem := TCustomMenuItem.Create(MenuItem);
    MenuItem.Add(NewItem);
    (Items[i]as TCustomMenuItem).Clone(NewItem);
  end;
end;

{ TCustomActionItem }

function TCustomActionItem.GetItem(Index: Integer): TCustomActionItem;
begin
  Result := TCustomActionItem(FItems[Index]);
end;

function TCustomActionItem.GetImageIndex: Integer;
var
  i: Integer;
begin
  if DefaultAction <> -1 then
    Result := ActionIdToImage[DefaultAction]
  else
  if ActionId = aidTemplate then
  begin
    Result := -1;
    if fTemplateName = '' then exit;
    i := TemplateParser.IndexOf(fTemplateName);
    if i <> -1 then
      Result := TemplateParser.Templates[i].ImageIndex;
  end
  else
    Result := ActionIdToImage[ActionId];
end;

function TCustomActionItem.GetCount: Integer;
begin
  Result := FItems.Count;
end;

procedure TCustomActionItem.SetActionId(Value: Integer);
begin
  if fActionId = Value then exit;
  fActionId := Value;
  fImageIndex := GetImageIndex;
  if Assigned(fOnActionChange) then
    fOnActionChange(Self);
end;

procedure TCustomActionItem.SetTemplateName(Value: string);
begin
  if fActionId <> aidTemplate then
    exit;
  fTemplateName := Value;
  fImageIndex := GetImageIndex;
end;

constructor TCustomActionItem.Create(AParent: TCustomActionItem);
begin
  inherited Create;
  fItems := TObjectList.Create(true);
  fEnabled := true;
  fImageIndex := -1;
  fDefaultAction := -1;
  fParent := AParent;
  if Assigned(AParent) then
  begin
    AParent.Add(Self);
    OnActionChange := Parent.OnActionChange;
  end;
end;

destructor TCustomActionItem.Destroy;
begin
  fItems.Free;
  inherited;
end;

procedure TCustomActionItem.Add(ActionItem: TCustomActionItem);
begin
  fItems.Add(ActionItem);
end;

procedure TCustomActionItem.Delete(Index: Integer);
begin
  fItems.Delete(Index);
end;

procedure TCustomActionItem.Move(CurIndex, NewIndex: Integer);
begin
  fItems.Move(CurIndex, NewIndex);
end;

procedure TCustomActionItem.Move(Dest: TCustomActionItem; Index: Integer);
begin
  Dest.fItems.Insert(Index, Parent.fItems.Extract(Self));
  fParent := Dest;
end;

procedure TCustomActionItem.Clone(ActionItem: TCustomActionItem);
var
  newItem: TCustomActionItem;
  i: Integer;
begin
  if not Assigned(ActionItem) then exit;

  ActionItem.Caption := Caption;
  ActionItem.Action := Action;
  ActionItem.ShortCut := ShortCut;
  ActionItem.Enabled := Enabled;
  ActionItem.fImageIndex := ImageIndex;
  ActionItem.fActionId := fActionId;
  ActionItem.fDefaultAction := fDefaultAction;
  ActionItem.fTemplateName := TemplateName;
  ActionItem.fItems.Clear;
  for i:= 0 to Count - 1 do
  begin
    NewItem := TCustomActionItem.Create(ActionItem);
    Items[i].Clone(NewItem);
  end;
end;

procedure TCustomActionItem.CloneTo(MenuItem: TCustomMenuItem);
var
  newItem: TCustomMenuItem;
  i: Integer;
begin
  if not Assigned(MenuItem) then exit;

  MenuItem.Caption := Caption;
  MenuItem.Action := Action;
  MenuItem.ShortCut := ShortCut;
  MenuItem.Enabled := Enabled;
  MenuItem.Visible := Enabled;
  MenuItem.ImageIndex := ImageIndex;
  MenuItem.fActionId := fActionId;
  MenuItem.TemplateName := TemplateName;
  MenuItem.Clear;
  for i:= 0 to Count - 1 do
  begin
    NewItem := TCustomMenuItem.Create(MenuItem);
    MenuItem.Add(NewItem);
    Items[i].CloneTo(NewItem);
  end;
end;

function TCustomActionItem.FindAction(ActionId: Integer): TCustomActionItem;
var
  i: Integer;
begin
  Result := nil;
  if not Enabled then exit;
  if ActionId = Self.ActionId then
  begin
    Result := Self;
    exit;
  end;
  for i := 0 to fItems.Count - 1 do
  begin
    Result := Items[i].FindAction(ActionId);
    if Assigned(Result) then
      break;
  end;
end;

function TCustomActionItem.FindTemplate(Entry: TLdapEntry): TTemplate;
var
  i, idx: Integer;
begin
  Result := nil;
  if not Enabled then exit;
  if ActionId = aidTemplate then
  begin
    idx := TemplateParser.IndexOf(TemplateName);
    if (idx <> -1) and TemplateParser.Templates[idx].Matches(Entry.ObjectClass) then
    begin
      Result := TemplateParser.Templates[idx];
      exit;
    end;
  end;
  for i := 0 to fItems.Count - 1 do
  begin
    Result := Items[i].FindTemplate(Entry);
    if Assigned(Result) then
      break;
  end;
end;

{ TCustomActionMenu }

procedure TCustomActionMenu.SetOnClick(Value: TNotifyEvent);
begin
  fOnClick := Value;
end;

procedure TCustomActionMenu.ActionChange(Sender: TCustomActionItem);
begin
  case Sender.DefaultAction of
    aidUser:  begin
                    fObjectIdToAction[oidSambaUser] := Sender.ActionId;
                    fObjectIdToAction[oidPosixUser] := Sender.ActionId;
              end;
    aidGroup: begin
                    fObjectIdToAction[oidGroup] := Sender.ActionId;
                    fObjectIdToAction[oidSambaGroup] := Sender.ActionId;
                    fObjectIdToAction[oidGroupOfUN] := Sender.ActionId;
              end;
  else
    if (Sender.DefaultAction >= Low(ActionIdToObject)) and (Sender.DefaultAction <= High(ActionIdToObject)) then
      fObjectIdToAction[ActionIdToObject[Sender.DefaultAction]] := Sender.ActionId;
  end;

end;

procedure TCustomActionMenu.AddMenuItem(ACaption: string; AActionId: Integer = -1; AShortCut: PCtrlRec = nil);
var
  NewItem: TCustomActionItem;
begin
  NewItem := TCustomActionItem.Create(fItems);
  with NewItem do begin
    Caption := aCaption;
    ActionId := AActionId;
    fDefaultAction := AActionId;
    if Assigned(AShortCut) then
      ShortCut := Menus.ShortCut(Ord(AShortCut^.Key), AShortCut^.Shift);
  end;
end;

constructor TCustomActionMenu.Create(Config: TConfig);
begin
  fConfig := Config;
  fItems := TCustomActionItem.Create(nil);
  fItems.ActionId := aidNodeItem;
  fItems.OnActionChange := ActionChange;
  fItems.Caption := mcNew;
  SetLength(FObjectIdToAction, Length(ObjectIdToAction));
  Move(ObjectIdToAction[0], FObjectIdToAction[0], SizeOf(ObjectIdToAction));
end;

destructor TCustomActionMenu.Destroy;
begin
  FItems.Free;
  inherited Destroy;
end;

function TCustomActionMenu.Load: Boolean;

  function ReadItem(ActionItem: TCustomActionItem; Path: string): Boolean;
  var
    i: integer;
    names: TStrings;
    NewItem: TCustomActionItem;
    valPath: string;
  begin

    names := TStringList.Create;
    with fConfig do
    try
      GetKeyNames(Path, names);
      Result := names.Count > 0;
      for i := 0 to names.Count - 1 do
      begin
        valPath := Path + names[i] + '\';
        NewItem := TCustomActionItem.Create(ActionItem);
        with NewItem do
        begin
          Caption := ReadString(valPath + 'Caption');
          ShortCut := ReadInteger(valPath + 'ShortCut');
          Enabled := ReadBool(valPath + 'Enabled');
          fDefaultAction := ReadInteger(valPath + 'DefaultAction'); // Must be read before ActionId
          ActionId := ReadInteger(valPath + 'ActionId');
          TemplateName := ReadString(valPath + 'TemplateName');
        end;
        ReadItem(NewItem, valPath);
      end;
    finally
      names.Free;
    end;
  end;

begin
  if Assigned(fConfig) then
  begin
    FItems.fItems.Clear;
    Result := ReadItem(FItems, CONF_MENU);
  end
  else
    Result := false;
end;

procedure TCustomActionMenu.Save;
var
  i: Integer;

  procedure WriteItem(ActionItem: TCustomActionItem; Path: string);
  var
    i: integer;

  begin
    with fConfig, ActionItem do begin
      WriteString(Path + 'Caption', Caption);
      WriteInteger(Path + 'ShortCut', ShortCut);
      WriteBool(Path + 'Enabled', Enabled);
      WriteInteger(Path + 'ActionId', ActionId);
      WriteInteger(Path + 'DefaultAction', DefaultAction);
      WriteString(Path + 'TemplateName', TemplateName);
      for i:= 0 to Count - 1 do
        WriteItem(Items[i], Path + Format('%.4d', [i]) + '\');
    end;
  end;

begin
  if not Assigned(fConfig) then exit;
  fConfig.Delete(CONF_MENU);
  for i := 0 to Items.Count - 1 do
    WriteItem(Items[i], CONF_MENU + Format('%.4d', [i]) + '\');
end;


procedure TCustomActionMenu.Clone(ActionMenu: TCustomActionMenu);
begin
  ActionMenu.fTemplateMenu := fTemplateMenu;
  ActionMenu.fOnClick := fOnClick;
  ActionMenu.fConfig := fConfig;
  SetLength(ActionMenu.FObjectIdToAction, Length(FObjectIdToAction));
  Move(FObjectIdToAction[0], ActionMenu.FObjectIdToAction[0], Length(FObjectIdToAction)*SizeOf(Integer));
  fItems.Clone(ActionMenu.fItems);
end;

procedure TCustomActionMenu.AssignItems(MenuItem: TMenuItem);
var
  i: Integer;
  NewItem: TCustomMenuItem;

  procedure SetEvent(Item: TCustomMenuItem);
  var
    i: Integer;
  begin
    if Item.ActionId >= aidTemplate then
      Item.OnClick := fOnClick;
    for i:= 0 to Item.Count - 1 do
      SetEvent(Item.Items[i] as TCustomMenuItem);
  end;

begin
  MenuItem.Clear;
  for i := 0 to FItems.Count - 1 do
  begin
    NewItem := TCustomMenuItem.Create(MenuItem);
    MenuItem.Add(NewItem);
    Items[i].CloneTo(NewItem);
    SetEvent(NewItem);
  end;
  if Assigned(fTemplateMenu) then
  begin
    NewItem := TCustomMenuItem.Create(MenuItem);
    NewItem.Caption := '-';
    MenuItem.Add(NewItem);
    NewItem := TCustomMenuItem.Create(MenuItem);
    MenuItem.Add(NewItem);
    fTemplateMenu.Clone(NewItem);
  end;
end;

function TCustomActionMenu.GetActionId(const ObjectID: Integer): Integer;
begin
  Result := FObjectIdToAction[ObjectID];
end;

function TCustomActionMenu.GetActionTemplate(Entry: TLdapEntry): TTemplate;
begin
  Result := Items.FindTemplate(Entry);
end;

function TCustomActionMenu.GetActionItem(Actionid: Integer): TCustomActionItem;
begin
  Result := Items.FindAction(ActionId);
end;

{ TPosixActionMenu }

constructor TPosixActionMenu.Create(Config: TConfig);
begin
  inherited Create(Config);
  if Load then exit;
  AddMenuItem(mcEntry, aidEntry);
  AddMenuItem(mcUser, aidUser, @scCtrlU);
  AddMenuItem(mcComputer, aidComputer, @scCtrlW);
  AddMenuItem(mcGroup, aidGroup, @scCtrlG);
  AddMenuItem(mcMailingList, aidMailingList);
  AddMenuItem(mcTransportTable, aidTransportTable);
  AddMenuItem(mcOU, aidOu, @scCtrlO);
  AddMenuItem(mcHost, aidHost);
  AddMenuItem(mcLocality, aidLocality);
  AddMenuItem(mcGroupOfUN, aidGroupOfUN);
  AddMenuItem(mcAlias, aidAlias);
end;

{ TADActionMenu }

constructor TADActionMenu.Create(Config: TConfig);
begin
  inherited Create(Config);
  if Load then exit;
  AddMenuItem(mcEntry, aidEntry);
  AddMenuItem(mcOU, aidOu, @scCtrlO);
  AddMenuItem(mcHost, aidHost);
  AddMenuItem(mcLocality, aidLocality);
end;

end.
