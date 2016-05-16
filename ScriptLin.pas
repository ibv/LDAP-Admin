  {      LDAPAdmin - Script.pas
  *      Copyright (C) 2012-2013 Tihomir Karlovic
  *
  *      Author: Tihomir Karlovic
  *
  *      Parts based on Codebot Class Library 3.01.00
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

unit ScriptLin;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
{$IFnDEF FPC}
  ComObj, ActiveX, Windows,
{$ELSE}
  LCLIntf, LCLType, LMessages,
{$ENDIF}
  ScriptIntf,Messages, SysUtils, Classes, TypInfo,
   Contnrs, Controls;

{$IFDEF VER130}
type
  IInterface = IUnknown;
  PPwideChar = ^PWideChar;
{$ENDIF}

{
type
  TArgList = record
    Arguments: PVariantArgList;
    Count: Integer;
  end;
}
type
  TScriptState = (ssUninitialized, ssInitialized, ssStarted, ssConnected,
    ssDisconnected, ssClosed);

  EScriptException = class(Exception)
  private
    FPosition: Integer;
    FLine: Cardinal;
    FErr1: string;
    FErr2: string;
    FCode: string;
    FScriptError: IInterface;
    function GetIdentifier: string;
  public
    constructor Create(AError: IInterface; const Code: string);
    property Line: Cardinal read FLine;
    property Position: Integer read FPosition;
    property Identifier: string read GetIdentifier;
    property Message: string read FErr1;
    property Message2: string read FErr2;
    property Code: string read FCode;
  end;

  TScriptError = record
    Details: IInterface;
    Error: string;
    Error2: string;
    Line: Cardinal;
    Position: Integer;
   end;

  TScriptActionEvent = procedure(Sender: TObject; const Action: string; var Allow: Boolean) of object;
  TScriptContinueEvent = procedure(Sender: TObject; var Allow: Boolean) of object;
  TScriptErrorEvent = procedure(Sender: TObject; const ScriptError: TScriptError) of object;
  TScriptStateEvent = procedure(Sender: TObject; State: TScriptState) of object;
  TScriptTextEvent = procedure(Sender: TObject; const Text: string) of object;

{ IScriptlet }

  IScriptlet = interface
    ['{268DC9F1-522D-45DD-B3C2-A3E4286E674F}']
    function GetName: string;
    procedure SetName(const Value: string);
    property Name: string read GetName write SetName;
  end;

{ IHostScriptlet }

  IHostScriptlet = interface(IScriptlet)
    ['{2A483AF3-8E9C-4023-AB94-A366C4EEA1F4}']
    procedure SetOnAlert(const Value: TScriptTextEvent);
    function GetOnAlert: TScriptTextEvent;
    function GetOnCreateObject: TScriptActionEvent;
    procedure SetOnCreateObject(const Value: TScriptActionEvent);
    function GetOnEcho: TScriptTextEvent;
    procedure SetOnEcho(const Value: TScriptTextEvent);
    property OnCreateObject: TScriptActionEvent read GetOnCreateObject write SetOnCreateObject;
    property OnAlert: TScriptTextEvent read GetOnAlert write SetOnAlert;
    property OnEcho: TScriptTextEvent read GetOnEcho write SetOnEcho;
  end;

{ IObjectScriptlet }

  IObjectScriptlet = interface(IScriptlet)
    ['{434121D9-BE6A-462C-B8A2-09CD12A4D012}']
    procedure SetObject(Value: TObject);
    function GetObject: TObject;
    property ObjectInstance: TObject read GetObject write SetObject;
  end;

{ IComponentScriptlet }

  IComponentScriptlet = interface(IScriptlet)
    ['{434121D9-BE6A-462C-B8A2-09CD12A4D013}']
    procedure SetComponent(Value: TComponent);
    function GetComponent: TComponent;
    property Component: TComponent read GetComponent write SetComponent;
  end;

  { IWinControlScriptlet }

  IWinControlScriptlet = interface(IScriptlet)
    ['{434121D9-BE6A-462C-B8A2-09CD12A4D014}']
    procedure SetControl(Value: TWinControl);
    function GetControl: TWinControl;
    property Control: TWinControl read GetControl write SetControl;
  end;

  TCustomScript = class;

{ TScripteventHandler }

  TScriptletEventHandler = class
    private
      fScript:    TCustomScript;
      fScriptlet: IObjectScriptlet;
      fDispatch:  IDispatch;
      fDispId:    Integer;
      fOldProc:   TMethod;
      fEventName: string;
      fProcName:  string;
      fEvProcAddr: Pointer;
      procedure   SetEvent(const EventName: string);
      function    GetEvent: string;
      procedure   SetProcName(const ProcName: string);
      function    GetObject: TObject;
      function    GetDispID: Integer;
      procedure   DispatchCall(Params: array of Variant);
    public
      constructor Create(Script: TCustomScript; Scriptlet: IObjectScriptlet; Dispatch: IDispatch = nil);
      destructor  Destroy; override;
      property    EventName: string read GetEvent write SetEvent;
      property    ProcName: string read fProcName write SetProcName;
      property    ObjectInstance: TObject read GetObject;
      property    EventProcAddr: Pointer read fEvProcAddr;
    published     { must be published so that RTTI knows about them }
      ///procedure  TNotifyEventProc(Sender: TObject);
      ///procedure  TKeyPressEventProc(Sender: TObject; var Key: Char);
      ///procedure  TKeyEventProc(Sender: TObject; var Key: Word; Shift: TShiftState);
      ///procedure  TMouseEventProc(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
      ///procedure  TMouseMoveEventProc(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    end;

{ PropertyList }

  TPropertyList = class(TStringList)
    private
      function   GetScriptlet(Index: Integer): IScriptlet;
      procedure  PutScriptlet(Index: Integer; const Scriptlet: IScriptlet);
    public
      destructor Destroy; override;
      procedure  Delete(Index: Integer); override;
      procedure  Clear; override;
      property   Scriptlets[Index: Integer]: IScriptlet read GetScriptlet write PutScriptlet;
  end;

{ TScriptlet }

  TScriptlet = class(TInterfacedObject, IDispatch, IScriptlet)
  private
    FScript:     TCustomScript;
    FMethods:    TStrings;
    FProperties: TPropertyList;
    FName:       string;
  protected
    function     PropertySearch(const PropName: string): Boolean; virtual;
    ///function     OnMethod(MethodIndex: Integer; const Args: TArgList): OleVariant; virtual;
    ///function     OnGetProperty(PropIndex: Integer; const Args: TArgList): OleVariant; virtual;
    ///procedure    OnSetProperty(PropIndex: Integer; const Args: TArgList; const Value: OleVariant); virtual;
    property     Methods: TStrings read FMethods;
    property     Properties: TPropertyList read FProperties;
  protected
    { IDispatch }
    function     GetTypeInfoCount(out Count: Integer): HResult; stdcall;
    function     GetTypeInfo(Index, LocaleID: Integer; out TypeInfo): HResult; stdcall;
    function     GetIDsOfNames(const IID: TGUID; Names: Pointer;
                 NameCount, LocaleID: Integer; DispIDs: Pointer): HResult; stdcall;
    function     Invoke(DispID: Integer; const IID: TGUID; LocaleID: Integer;
                 Flags: Word; var Params; VarResult, ExcepInfo, ArgErr: Pointer): HResult; stdcall;
    { IScriptlet }
    function     GetName: string;
    procedure    SetName(const Value: string);
    public
    constructor  Create(Script: TCustomScript);
    destructor   Destroy; override;
  end;

{ TCustomScript }

  TCustomScript = class
  private
    FSite: IActiveScriptSite;
    FScript: IActiveScript;
    FScriptlets: IInterfaceList;
    FEventHandlers: TObjectList;
    FLines: TStrings;
    FWindowHandle: THandle;
    FOnError: TScriptErrorEvent;
    FOnEnter: TNotifyEvent;
    FOnLeave: TNotifyEvent;
    FOnQueryContinue: TScriptContinueEvent;
    FOnStateChange: TScriptStateEvent;
    function FindScriptlet(const Name: string): IScriptlet;
    function FindEventHandler(AObject: TObject; AEventName: string): TScriptletEventHandler;
    function GetLines: TStrings;
    procedure SetLines(Value: TStrings);
    function GetScript: IDispatch;
    function GetState: TScriptState;
    procedure SetState(Value: TScriptState);
  protected
    function CreateEngine: IActiveScript; virtual; abstract;
    procedure Error(ScriptError: IInterface); virtual;
    procedure Enter; virtual;
    procedure Leave; virtual;
    procedure QueryContinue(var Allow: Boolean); virtual;
    procedure StateChange(State: TScriptState); virtual;
  public
    constructor Create; virtual;
    destructor Destroy; override;
    procedure AddScriptlet(Scriptlet: IScriptlet);
    procedure RemoveScriptlet(Scriptlet: IScriptlet);
    procedure AddEventHandler(Scriptlet: IObjectScriptlet; EventName, ProcName: string);
    procedure AddEventHandlerCode(Scriptlet: IObjectScriptlet; EventName, EventCode: string);
    procedure RemoveEventHandler(AObject: TObject; EventName: string);
    procedure Execute;
    procedure Terminate;
    property Script: IDispatch read GetScript;
    property AScript: IActiveScript read FScript;
    property State: TScriptState read GetState write SetState;
    property WindowHandle: THandle read FWindowHandle write FWindowHandle;
  published
    property Lines: TStrings read GetLines write SetLines;
    property OnError: TScriptErrorEvent read FOnError write FOnError;
    property OnEnter: TNotifyEvent read FOnEnter write FOnEnter;
    property OnLeave: TNotifyEvent read FOnLeave write FOnLeave;
    property OnQueryContinue: TScriptContinueEvent read FOnQueryContinue write FOnQueryContinue;
    property OnStateChange: TScriptStateEvent read FOnStateChange write FOnStateChange;
  end;

{ TJavaScript }

  TJavaScript = class(TCustomScript)
  protected
    function CreateEngine: IActiveScript; override;
  end;

{ TVisualBasicScript }

  TVisualBasicScript = class(TCustomScript)
  protected
    function CreateEngine: IActiveScript; override;
  end;

{ Scriptlet creation routines }

function CreateHostScriptlet(Script: TCustomScript; Alert, Echo: TScriptTextEvent): IHostScriptlet;
function CreateComponentScriptlet(Script: TCustomScript; Component: TComponent; const Name: string = ''): IComponentScriptlet;
function CreateWinControlScriptlet(Script: TCustomScript; Control: TWinControl; const Name: string = ''): IWinControlScriptlet;
function CreateScriptlet(Script: TCustomScript; AObject: TObject; const Name: string): IScriptlet;

implementation

{$I LdapAdmin.inc}

uses {$IFDEF VARIANTS} variants, {$ENDIF} LDAPClasses, Misc, Dialogs, Constant,
     Connection, StdCtrls;

var
  lastScriptExceptionMessage: string;

type
  EIntScriptException = class(Exception)
  private
    FErrCode: Integer;
  public
    constructor Create(const AErrCode: Integer; AErrMessage: string);
    property ErrCode: Integer read FErrCode;
  end;

function StateToEnum(const Value: TScriptState): TOleEnum;
const
  Enums: array[TScriptState] of TOleEnum = (
    SCRIPTSTATE_UNINITIALIZED,
    SCRIPTSTATE_INITIALIZED,
    SCRIPTSTATE_STARTED,
    SCRIPTSTATE_CONNECTED,
    SCRIPTSTATE_DISCONNECTED,
    SCRIPTSTATE_CLOSED);
begin
  Result := Enums[Value];
end;

function EnumToState(const Value: TOleEnum): TScriptState;
begin
  case Value of
    SCRIPTSTATE_INITIALIZED: Result := ssInitialized;
    SCRIPTSTATE_STARTED: Result := ssStarted;
    SCRIPTSTATE_CONNECTED: Result := ssConnected;
    SCRIPTSTATE_DISCONNECTED: Result := ssDisconnected;
    SCRIPTSTATE_CLOSED: Result := ssClosed;
  else
    Result := ssUninitialized;
  end;
end;

{ EScriptException }

function EScriptException.GetIdentifier: string;
var
  i, l: Integer;
begin
  Result := '';
  i := 1;
  l := FLine;
  while l > 0 do
  begin
    while FCode[i] <> #13 do
    begin
      if i = Length(FCode) then
        Exit;
      inc(i);
    end;
    dec(l);
    inc(i);
  end;
  if FCode[i] = #10 then
    inc(i);
  l := i + Position;
  while FCode[l] in ['a'..'z','A'..'Z','-','_','.'] do inc(l);
  Result := Copy(FCode, i + Position, l-i);
end;

constructor EScriptException.Create(AError: IInterface; const Code: string);
var
  I: TExcepInfo;
  C: Cardinal;
begin
  FScriptError := AError;
  FCode := Code;
  with FScriptError as IActiveScriptError do
  begin
    if GetExceptionInfo(I) = S_OK then
      FErr1 := I.bstrDescription;
    if lastScriptExceptionMessage <> '' then
    begin
      FErr2 := lastScriptExceptionMessage;
      lastScriptExceptionMessage := '';
    end;
    GetSourcePosition(C, FLine, FPosition);
  end;
  inherited Create(FErr1);
end;

{ EIntScriptException }

constructor EIntScriptException.Create(const AErrCode: Integer; AErrMessage: string);
begin
  inherited Create(AErrMessage);
  FErrCode := AErrCode;
  lastScriptExceptionMessage := AErrMessage;
end;

{ TScriptletEventHandler }

function TScriptletEventHandler.GetEvent: string;
begin
  Result := fEventName;
end;

procedure TScriptletEventHandler.SetProcName(const ProcName: string);
begin
  fProcName := ProcName;
  fDispId := GetDispID;
end;

procedure TScriptletEventHandler.SetEvent(const EventName: string);
var
  newMethod : TMethod;
  PropInfo: PPropInfo;
begin
  if not Assigned(fScriptlet.ObjectInstance) then
    Exit;

  if fEventName <> '' then // restore original event method
    SetMethodProp(fScriptlet.ObjectInstance, fEventName, fOldProc);

  if EventName='' then
    Exit;

  PropInfo := GetPropInfo(fScriptlet.ObjectInstance.ClassInfo, EventName);
  if not Assigned(PropInfo) then
    raise EIntScriptException.Create(DISP_E_MEMBERNOTFOUND, Format(stScriptNotSupp, [fScriptlet.Name, EventName]));
  if PropInfo.PropType^.Kind <> tkMethod then
    raise EIntScriptException.Create(DISP_E_MEMBERNOTFOUND, Format(stScriptNotEvent, [EventName]));

  fEvProcAddr := self.MethodAddress(PropInfo.PropType^.Name + 'Proc');
  if not Assigned(fEvProcAddr) then
    raise EIntScriptException.Create(DISP_E_MEMBERNOTFOUND, Format(stEvTypeEvTypeErr, [EventName, PropInfo.PropType^.Name]));

  fOldProc := GetMethodProp(fScriptlet.ObjectInstance, EventName);
  newMethod.Code := fEvProcAddr;
  newMethod.Data := Pointer(self);
  SetMethodProp(fScriptlet.ObjectInstance, EventName, newMethod);
  fEventName := EventName;
end;

function TScriptletEventHandler.GetObject: TObject;
begin
  Result := fScriptlet.ObjectInstance;
end;

function TScriptletEventHandler.GetDispID: Integer;
var
  ws: WideString;
begin
  {$IFDEF UNICODE}
  ws := ProcName;
  {$ELSE}
  ws := StringToWide(ProcName);
  {$ENDIF}
  if fDispatch.GetIDsOfNames(GUID_NULL, @PAnsiChar(ws), 1, GetThreadLocale, @Result) <> S_OK then
    raise EIntScriptException.Create(DISP_E_MEMBERNOTFOUND, Format(stScriptNoProc, [ProcName]));
end;

procedure TScriptletEventHandler.DispatchCall(Params: array of Variant);
var
  CallDesc: TCallDesc;
  ParamDesc: array [0..255] of Byte;
  ParamPtr: Pointer;
  TypeIdx: Integer;
  i: Integer;

  procedure AddParam(Param: Variant);
  begin
    CallDesc.ArgTypes[TypeIdx] := TVarData(Param).VType;
    case TVarData(Param).VType of
      varInteger, varBoolean:
        begin
          Integer(ParamPtr^) := Param;
          Inc(Cardinal(ParamPtr), SizeOf(Integer));
        end;
      varString:
        begin
          CallDesc.ArgTypes[TypeIdx] := varStrArg;
          Pointer(ParamPtr^) := TVarData(Param).vString;
          Inc(Cardinal(ParamPtr), SizeOf(Pointer));
        end;
      varDispatch:
        begin
          Pointer(ParamPtr^) := TVarData(Param).vPointer;
          Inc(Cardinal(ParamPtr), SizeOf(Pointer));
        end;
      else
        raise Exception.Create(stScriptParamType);
    end;
    Inc(TypeIdx);
  end;

begin
  { Prepare parameters }
  ParamPtr := @ParamDesc;
  TypeIdx := 0;
  for i := Low(Params) to High(Params) do
    AddParam(Params[i]);

  { Set the rest of the call descriptor }
  with CallDesc do begin
    CallType := DISPATCH_METHOD;
    ArgCount := TypeIdx;
    NamedArgCount := 0;
    Move(ProcName[1], ArgTypes[TypeIdx],Length(ProcName));
    ArgTypes[TypeIdx + Length(ProcName) + 2] := 0;
  end;

  DispatchInvoke(fDispatch, @CallDesc, @fDispID, @ParamDesc, nil);
end;

constructor TScriptletEventHandler.Create(Script: TCustomScript; Scriptlet: IObjectScriptlet; Dispatch: IDispatch = nil);
begin
  inherited Create;
  fScript := Script;
  fScriptlet := Scriptlet;
  if Assigned(Dispatch) then
    fDispatch := Dispatch
  else
    fDispatch := FScript.Script;
end;

{ From JclRTTI.pas, Project JEDI Code Library (JCL) }
function JclSetToInt(const TypeInfo: PTypeInfo; const SetVar): Integer;
var
  BitShift: Integer;
  TmpInt64: Int64;
  EnumMin: Integer;
  EnumMax: Integer;
  ResBytes: Integer;
  CompType: PTypeInfo;
begin
  Result := 0;
  TmpInt64 := 0;
  CompType := GetTypeData(TypeInfo).CompType^;
  EnumMin := GetTypeData(CompType).MinValue;
  EnumMax := GetTypeData(CompType).MaxValue;
  ResBytes := (EnumMax div 8) - (EnumMin div 8) + 1;
  if (EnumMax - EnumMin) > 32 then
    raise EIntScriptException.Create(DISP_E_OVERFLOW, stScriptSetErr );
  BitShift := EnumMin mod 8;
  Move(SetVar, TmpInt64, ResBytes + 1);
  TmpInt64 := TmpInt64 shr BitShift;
  Move(TmpInt64, Result, ResBytes);
end;

procedure TScriptletEventHandler.TNotifyEventProc(Sender: TObject);
begin
  DispatchCall([fScriptlet as IDispatch]);
  if Assigned(fOldProc.Code) then
    TNotifyEvent(fOldProc)(Sender);
end;

procedure TScriptletEventHandler.TKeyPressEventProc(Sender: TObject; var Key: Char);
begin
  DispatchCall([fScriptlet as IDispatch, Key]);
  if Assigned(fOldProc.Code) then
    TKeyPressEvent(fOldProc)(Sender, Key);
end;

procedure TScriptletEventHandler.TKeyEventProc(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  DispatchCall([fScriptlet as IDispatch, Key, JclSetToInt(TypeInfo(TShiftState), Shift)]);
  if Assigned(fOldProc.Code) then
    TKeyEvent(fOldProc)(Sender, Key, Shift);
end;

procedure  TScriptletEventHandler.TMouseEventProc(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  DispatchCall([fScriptlet as IDispatch, Integer(Button), JclSetToInt(TypeInfo(TShiftState), Shift), X, Y]);
  if Assigned(fOldProc.Code) then
    TMouseEvent(fOldProc)(Sender, Button, Shift, X, Y);
end;

procedure TScriptletEventHandler.TMouseMoveEventProc(Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin
  DispatchCall([fScriptlet as IDispatch, JclSetToInt(TypeInfo(TShiftState), Shift), X, Y]);
  if Assigned(fOldProc.Code) then
    TMouseMoveEvent(fOldProc)(Sender, Shift, X, Y);
end;

destructor TScriptletEventHandler.Destroy;
begin
  if (fEventName <> '') and Assigned(fScriptlet.ObjectInstance) then  // restore original event method
    SetMethodProp(fScriptlet.ObjectInstance, fEventName, fOldProc);
  inherited;
end;

{ IActiveScriptSiteStop }

type
  IActiveScriptSiteStop = interface
    ['{167239EE-65C2-47F7-9CF3-EFA15285892F}']
    function Stop: HResult; stdcall;
  end;

{ TScriptSite }

  TScriptSite = class(TInterfacedObject, IActiveScriptSite,
    IActiveScriptSiteWindow, IActiveScriptSiteInterruptPoll,
    IActiveScriptSiteStop)
  private
    FScript: TCustomScript;
  protected
    { IActiveScriptSite }
    function GetLCID(out lcid: LongWord): HResult; stdcall;
    function GetItemInfo(Name: PWideChar; ReturnMask: DWORD;
      out unkItem: IUnknown; out Info: ITypeInfo): HResult; stdcall;
    function GetDocVersionString(out Version: PWideChar): HResult; stdcall;
    function OnScriptTerminate(const varResult: OleVariant;
      const ExcepInfo: TExcepInfo): HResult; stdcall;
    function OnStateChange(ScriptState: TScriptStateEnum): HResult; stdcall;
    function OnScriptError(ScriptError: IActiveScriptError): HResult; stdcall;
    function OnEnterScript: HResult; stdcall;
    function OnLeaveScript: HResult; stdcall;
    { IActiveScriptSiteWindow }
    function GetWindow(out Wnd: HWND): HResult; stdcall;
    function EnableModeless(Enable: BOOL): HResult; stdcall;
    { IActiveScriptSiteInterruptPoll }
    function QueryContinue: HResult; stdcall;
    { IActiveScriptSiteStop }
    function Stop: HResult; stdcall;
  public
    constructor Create(Script: TCustomScript);
  end;

constructor TScriptSite.Create(Script: TCustomScript);
begin
  inherited Create;
  FScript := Script;
end;

{ TScriptSite.IActiveScriptSite }

function TScriptSite.GetLCID(out lcid: LongWord): HResult;
begin
  Result := E_NOTIMPL;
end;

function TScriptSite.GetItemInfo(Name: PWideChar; ReturnMask: DWORD; out unkItem: IUnknown; out Info: ITypeInfo): HResult;
var
  Item: IScriptlet;
  S: string;
begin
  Result := TYPE_E_ELEMENTNOTFOUND;
  if ReturnMask and SCRIPTINFO_IUNKNOWN = SCRIPTINFO_IUNKNOWN then
    unkItem := nil;
  if ReturnMask and SCRIPTINFO_ITYPEINFO = SCRIPTINFO_ITYPEINFO then
    Info := nil;
  if ReturnMask and SCRIPTINFO_IUNKNOWN = SCRIPTINFO_IUNKNOWN then
    if FScript <> nil then
    begin
      S := Name;
      Item := FScript.FindScriptlet(S);
      if Item <> nil then
      begin
        unkItem := Item;
        Result := S_OK;
      end;
    end;
end;

function TScriptSite.GetDocVersionString(out Version: PWideChar): HResult;
begin
  Result := E_NOTIMPL;
end;

function TScriptSite.OnScriptTerminate(const varResult: OleVariant; const ExcepInfo: TExcepInfo): HResult;
begin
  Result := S_OK;
end;

function TScriptSite.OnStateChange(ScriptState: TScriptStateEnum): HResult;
begin
  Result := S_OK;
  if FScript <> nil then
    FScript.StateChange(EnumToState(ScriptState));
end;

function TScriptSite.OnScriptError(ScriptError: IActiveScriptError): HResult;
begin
  Result := S_OK;
  if FScript <> nil then
    FScript.Error(ScriptError);
end;

function TScriptSite.OnEnterScript: HResult;
begin
  Result := S_OK;
  if FScript <> nil then
    FScript.Enter;
end;

function TScriptSite.OnLeaveScript: HResult;
begin
  Result := S_OK;
  if FScript <> nil then
    FScript.Leave;
end;

{ TScriptSite.IActiveScriptSiteWindow }

function TScriptSite.GetWindow(out Wnd: HWND): HResult;
begin
  if (FScript <> nil) and (FScript.WindowHandle <> 0) then
  begin
    Result := S_OK;
    Wnd := FScript.WindowHandle;
  end
  else
  begin
    Result := E_FAIL;
    Wnd := 0;
  end;
end;

function TScriptSite.EnableModeless(Enable: BOOL): HResult;
begin
  Result := S_OK;
end;

{ TScriptSite.IActiveScriptSiteInterruptPoll }

function TScriptSite.QueryContinue: HResult;
var
  Allow: Boolean;
begin
  Result := S_OK;
  Allow := True;
  if (FScript <> nil) then
  begin
    FScript.QueryContinue(Allow);
    if not Allow then
      Result := S_FALSE;
  end;
end;

{ TScriptSite.IActiveScriptSiteStop }

function TScriptSite.Stop: HResult;
begin
  FScript := nil;
  Result := S_OK;
end;

{ TPropertyList }

function TPropertyList.GetScriptlet(Index: Integer): IScriptlet;
begin
{$IFDEF SCRIPTLET_CAST_FIX}
  Result := IScriptlet(Pointer(Objects[Index]));
{$ELSE}
  Result := (Objects[Index] as TScriptlet) as IScriptlet;
{$ENDIF}
end;

procedure TPropertyList.PutScriptlet(Index: Integer; const Scriptlet: IScriptlet);
begin
  {$IFDEF SCRIPTLET_CAST_FIX}
  Objects[Index] :=  TObject(IUnknown(Scriptlet));
  {$ELSE}
  Objects[Index] :=  Scriptlet as TObject;
  {$ENDIF}
  Scriptlet._AddRef;
end;

procedure TPropertyList.Delete(Index: Integer);
begin
  if Assigned(Objects[Index]) then
  {$IFDEF SCRIPTLET_CAST_FIX}
    Iscriptlet(Pointer(Objects[Index]))._Release;
  {$ELSE}
    ((Objects[Index] as TScriptlet) as IScriptlet)._Release;
  {$ENDIF}
  inherited;
end;

procedure TPropertyList.Clear;
var
  i: Integer;
begin
  for I := 0 to Count - 1 do
    if Assigned(Objects[I]) then
    {$IFDEF SCRIPTLET_CAST_FIX}
      Iscriptlet(Pointer(Objects[I]))._Release;
    {$ELSE}
      ((Objects[I] as TScriptlet) as IScriptlet)._Release;
    {$ENDIF}
  inherited;
end;

destructor TPropertyList.Destroy;
begin
  Clear;
  inherited;
end;

{ TScriptlet }

procedure CheckArgumentCount(const Args: TArgList; Min, Max: Integer);
begin
  if Args.Count > Max then
    raise EIntScriptException.Create(DISP_E_BADPARAMCOUNT, stTooManyArgs);
  if Args.Count < Min then
    raise EIntScriptException.Create(DISP_E_BADPARAMCOUNT, stNotEnoughArgs);
end;

function ArgParam(const Args: TArgList; Index: Integer): OleVariant;
begin
  if Index < 0 then
    raise EIntScriptException.Create(DISP_E_BADPARAMCOUNT, Format(stInvalidArgIndex, [Index]));
  if Index >= Args.Count then
    raise EIntScriptException.Create(DISP_E_BADPARAMCOUNT, stNotEnoughArgs);
  Result := OleVariant(Args.Arguments[Args.Count - Index - 1]);
  if VarIsEmpty(Result) then
    raise EIntScriptException.Create(DISP_E_PARAMNOTOPTIONAL, stEmptyArg);
end;

type
  PPInteger = ^PInteger;

const
  BaseMethodDispid = $200;
  BasePropertyDispid = -$200;

constructor TScriptlet.Create(Script: TCustomScript);
begin
  inherited Create;
  FMethods := TStringList.Create;
  FProperties := TPropertyList.Create;
  FScript := Script;
end;

destructor TScriptlet.Destroy;
begin
  FProperties.Free;
  FMethods.Free;
  inherited Destroy;
end;

function TScriptlet.PropertySearch(const PropName: string): Boolean;
begin
  Result := False;
end;

function TScriptlet.OnMethod(MethodIndex: Integer; const Args: TArgList): OleVariant;
begin
  VarClear(Result);
end;

function TScriptlet.OnGetProperty(PropIndex: Integer; const Args: TArgList): OleVariant;
begin
  VarClear(Result);
end;

procedure TScriptlet.OnSetProperty(PropIndex: Integer; const Args: TArgList; const Value: OleVariant);
begin
end;

{ TScriptlet.IDispatch }

function TScriptlet.GetTypeInfo(Index, LocaleID: Integer; out TypeInfo): HResult;
begin
  Pointer(TypeInfo) := nil;
  Result := S_OK;
end;

function TScriptlet.GetTypeInfoCount(out Count: Integer): HResult;
begin
  Count := 0;
  Result := S_OK;
end;

function TScriptlet.GetIDsOfNames(const IID: TGUID; Names: Pointer;
                    NameCount, LocaleID: Integer; DispIDs: Pointer): HResult;
var
  S: WideString;
  I: Integer;
begin
  Result := DISP_E_UNKNOWNNAME;
  if NameCount = 1 then
  begin
    S := UpperCase(PPWideChar(Names)^);
    I := FMethods.IndexOf(S);
    if I > -1 then
    begin
    	PInteger(DispIDs)^ := I + BaseMethodDispid;
    	Result := S_OK;
    end
    else
    begin
      I := FProperties.IndexOf(S);
      if (I < 0) and PropertySearch(S) then
      begin
        FProperties.Add(S);
        I := FProperties.Count - 1;
      end;
      if I > -1 then
      begin
        PInteger(DispIDs)^ := I + BasePropertyDispid;
        Result := S_OK;
      end;
    end;
  end
end;

function TScriptlet.Invoke(DispID: Integer; const IID: TGUID;
  LocaleID: Integer; Flags: Word; var Params; VarResult, ExcepInfo,
  ArgErr: Pointer): HResult;
var
  DispParams: PDispParams;
  Output: POleVariant absolute VarResult;
  ArgList: TArgList;
begin
  DispParams := @Params;
  Output := VarResult;
  ArgList.Count := DispParams.cArgs;
  ArgList.Arguments := DispParams.rgvarg;
  Result := DISP_E_BADINDEX;
  try
    if Flags and DISPATCH_METHOD = DISPATCH_METHOD then
    begin
      Dec(DispId, BaseMethodDispid);
      if (DispId > -1) and (DispId < FMethods.Count) then
      begin
        Result := S_OK;
        if Output <> nil then
          Output^ := OnMethod(DispId, ArgList)
        else
          OnMethod(DispId, ArgList);
      end;
    end
    else if (Flags and DISPATCH_PROPERTYGET + DISPATCH_PROPERTYPUT + DISPATCH_PROPERTYPUTREF)  <> 0 then
    begin
      Dec(DispId, BasePropertyDispid);
      if (DispId > -1) and (DispId < FProperties.Count) then
      begin
        Result := S_OK;
      	if Flags and DISPATCH_PROPERTYGET <> 0  then
          Output^ := OnGetProperty(DispId, ArgList)
        else
        begin
          if DispParams.cArgs > 0 then
            OnSetProperty(DispId, ArgList, OleVariant(DispParams.rgvarg^[0]))
          else
            Result := DISP_E_BADPARAMCOUNT;
        end;
      end;
    end
  except
    on E: EIntScriptException do
      Result := E.ErrCode;
    on E: Exception do
    begin
      Result := E_FAIL;
      lastScriptExceptionMessage := E.Message;
    end;
  end;
end;

{ TScriptlet.IScriptlet }

function TScriptlet.GetName: string;
begin
  Result := FName;
end;

procedure TScriptlet.SetName(const Value: string);
begin
  FName := Value;
end;

{ TCustomScript }

constructor TCustomScript.Create;
begin
  FLines := TStringList.Create;
  FScriptlets := TInterfaceList.Create;
  FEventHandlers := TObjectList.Create;
end;

destructor TCustomScript.Destroy;
begin
  Terminate;
  FLines.Free;
  FEventHandlers.Free;
  inherited Destroy;
end;

function TCustomScript.FindScriptlet(const Name: string): IScriptlet;
var
  S: IScriptlet;
  I: Integer;
begin
  Result := nil;
  for I := 0 to FScriptlets.Count - 1 do
  begin
    S := FScriptlets[I] as IScriptlet;
    if S.Name = Name then
    begin
      Result := S;
      Break;
    end;
  end;
end;

procedure TCustomScript.AddScriptlet(Scriptlet: IScriptlet);
begin
  if FindScriptlet(Scriptlet.Name) = nil then
    FScriptlets.Add(Scriptlet);
end;

procedure TCustomScript.RemoveScriptlet(Scriptlet: IScriptlet);
var
  S: IScriptlet;
begin
  S := FindScriptlet(Scriptlet.Name);
  if S <> nil then
    FScriptlets.Remove(S);
end;

{ Finds en event handler attached to the control. If the event handler was externally
  detached, it will not be returned as it is not connected to the object any more }
function TCustomScript.FindEventHandler(AObject: TObject; AEventName: string): TScriptletEventHandler;
var
  i: Integer;
  M: TMethod;
begin
  Result := nil;
  M := GetMethodProp(AObject, AEventName);
  if M.Code=nil then exit;
  for i := 0 to FEventHandlers.Count - 1 do with TScriptletEventHandler(FEventHandlers[i]) do
    if M.Code = EventProcAddr then
    begin
      Result := FEventHandlers[i] as TScriptletEventHandler;
      break;
    end;
end;

procedure TCustomScript.AddEventHandler(Scriptlet: IObjectScriptlet; EventName, ProcName: string);
var
  sh: TScriptletEventHandler;
begin
  RemoveEventHandler(Scriptlet.ObjectInstance, EventName);
  if ProcName = '' then Exit;
  sh := TScriptletEventHandler.Create(Self, Scriptlet);
  try
    sh.EventName := EventName;
    sh.ProcName := ProcName;
    FEventHandlers.Add(sh);
  except
    sh.Free;
    raise;
  end;
end;

procedure TCustomScript.AddEventHandlerCode(Scriptlet: IObjectScriptlet; EventName, EventCode: string);
var
  Parse: IActiveScriptParseProcedure2;
  sh: TScriptletEventHandler;
  Dispatch: IDispatch;
  Result: HResult;
begin
  Parse := FScript as IActiveScriptParseProcedure2;
  {$IFDEF UNICODE}
  Result := Parse.ParseProcedureText(PWideChar(EventCode), '',
            PWideChar(EventName), '', nil, '', 0, 0, 0, Dispatch);
  {$ELSE}
  Result := Parse.ParseProcedureText(PWideChar(StringToWide(EventCode)), '',
            PWideChar(StringToWide(EventName)), '', nil, '', 0, 0, 0, Dispatch);
  {$ENDIF}
  {if Result <> 0 then
    raise EScriptException.Create(Result, 'Error parsing ' + EventName + ' event procedure!');}
  if Result = S_OK then
  begin
    //RemoveEventHandler(Scriptlet.ObjectInstance, EventName);
    sh := TScriptletEventHandler.Create(Self, Scriptlet, Dispatch);
    try
      sh.EventName := EventName;
      FEventHandlers.Add(sh);
    except
      sh.Free;
      raise;
    end;
  end;
end;

{ Removes and destroys event handler attached to the control.
  If event handler was externaly detached, it will not be removed since it's
  removing would brake the event chain }
procedure TCustomScript.RemoveEventHandler(AObject: TObject; EventName: string);
var
  sh: TScriptletEventHandler;
begin
  sh := FindEventHandler(AObject, EventName);
  if Assigned(sh) then
    FEventHandlers.Remove(sh);
end;

procedure TCustomScript.Execute;
var
  Parse: IActiveScriptParse;
  Text: WideString;
  S: IScriptlet;
  I: Integer;
begin
  Terminate;
  FScript := CreateEngine;
  FSite := TScriptSite.Create(Self);
  OleCheck(FScript.SetScriptSite(FSite));
  for I := 0 to FScriptlets.Count - 1 do
  begin
    S := FScriptlets[I] as IScriptlet;
    Text := S.Name;
    FScript.AddNamedItem(PWideChar(Text), SCRIPTITEM_ISVISIBLE + SCRIPTITEM_GLOBALMEMBERS);
  end;
  Parse := FScript as IActiveScriptParse;
  OleCheck(Parse.InitNew);
  Text := FLines.Text;
  if Parse.ParseScriptText(PWideChar(Text), '', nil, '', 0, 0,
    SCRIPTTEXT_ISVISIBLE, nil, nil) = S_OK then
    OleCheck(FScript.SetScriptState(SCRIPTSTATE_CONNECTED));
end;

procedure TCustomScript.Terminate;
begin
  if FScript <> nil then
    FScript.Close;
  FScript := nil;
  if FSite <> nil then
    (FSite as IActiveScriptSiteStop).Stop;
  FSite := nil;
  FEventHandlers.Clear;
end;

procedure TCustomScript.Error(ScriptError: IInterface);
var
  E: IActiveScriptError;
  S: TScriptError;
  I: TExcepInfo;
  C: Cardinal;
begin
  if Assigned(FOnError) then
  begin
    E := ScriptError as IActiveScriptError;
    S.Details := E;
    if E.GetExceptionInfo(I) = S_OK then
      S.Error := I.bstrDescription;
    if lastScriptExceptionMessage <> '' then
    begin
      S.Error2 := lastScriptExceptionMessage;
      lastScriptExceptionMessage := '';
    end;
    E.GetSourcePosition(C, S.Line, S.Position);
    FOnError(Self, S);
  end
  else
    raise EScriptException.Create(ScriptError, Lines.Text);
end;

procedure TCustomScript.Enter;
begin
  if Assigned(FOnEnter) then
    FOnEnter(Self);
end;

procedure TCustomScript.Leave;
begin
  if Assigned(FOnLeave) then
    FOnLeave(Self);
end;

procedure TCustomScript.QueryContinue(var Allow: Boolean);
begin
  if Assigned(FOnQueryContinue) then
    FOnQueryContinue(Self, Allow);
end;

procedure TCustomScript.StateChange(State: TScriptState);
begin
  if Assigned(FOnStateChange) then
    FOnStateChange(Self, State);
end;

function TCustomScript.GetLines: TStrings;
begin
  Result := FLines;
end;

procedure TCustomScript.SetLines(Value: TStrings);
begin
  FLines.Assign(Value);
end;

function TCustomScript.GetScript: IDispatch;
begin
  Result := nil;
  if FScript = nil then
    Exit;
  OleCheck(FScript.GetScriptDispatch('', Result));
end;

function TCustomScript.GetState: TScriptState;
var
  S: TOleEnum;
begin
  Result := ssUninitialized;
  if (FScript <> nil) and (FScript.GetScriptState(S) = S_OK) then
    Result := EnumToState(S);
end;

procedure TCustomScript.SetState(Value: TScriptState);
begin
  if FScript <> nil then
    FScript.SetScriptState(TOleEnum(Value));
end;

{ TJavaScript }

function TJavaScript.CreateEngine: IActiveScript;
begin
  Result := CreateComObject(CLSID_JScript) as IActiveScript;
end;

{ TVisualBasicScript }

function TVisualBasicScript.CreateEngine: IActiveScript;
begin
  Result := CreateComObject(CLSID_VBScript) as IActiveScript;
end;

{ THost }

type
  THostScriptlet = class(TScriptlet, IHostScriptlet)
  private
    FOnAlert: TScriptTextEvent;
    FOnCreateObject: TScriptActionEvent;
    FOnEcho: TScriptTextEvent;
    procedure Alert(const S: string);
    function CreateObject(const S: string): IDispatch;
    procedure Echo(const S: string);
    function ReadText(const FileName: string): string;
    procedure WriteText(const FileName, Value: string);
  protected
    function OnMethod(MethodIndex: Integer; const Args: TArgList): OleVariant; override;
    { IHostScriptlet }
    procedure SetOnAlert(const Value: TScriptTextEvent);
    function GetOnAlert: TScriptTextEvent;
    function GetOnCreateObject: TScriptActionEvent;
    procedure SetOnCreateObject(const Value: TScriptActionEvent);
    function GetOnEcho: TScriptTextEvent;
    procedure SetOnEcho(const Value: TScriptTextEvent);
  public
    constructor Create(Script: TCustomScript);
  end;

constructor THostScriptlet.Create(Script: TCustomScript);
begin
  inherited;
  SetName('host');
  Methods.Add('prompt');
  Methods.Add('alert');
  Methods.Add('createObject');
  Methods.Add('echo');
  Methods.Add('readText');
  Methods.Add('writeText');
end;

function THostScriptlet.OnMethod(MethodIndex: Integer; const Args: TArgList): OleVariant;

  function Arg(Index: Integer): OleVariant;
  begin
    Result := ArgParam(Args, Index);
  end;

begin
  VarClear(Result);
  case MethodIndex of
    0: Result := InputBox(cUserPrompt,Arg(0),Arg(1));
    1: Alert(Arg(0));
    2: Result := CreateObject(Arg(0));
    3: Echo(Arg(0));
    4: Result := ReadText(Arg(0));
    5: WriteText(Arg(0), Arg(1));
  end;
end;

procedure THostScriptlet.Alert(const S: string);
begin
  if Assigned(FOnAlert) then
    FOnAlert(Self, S)
  else
    ShowMessage(CStrToString(S));
end;

function THostScriptlet.CreateObject(const S: string): IDispatch;
var
  ClassID: TCLSID;
  Allow: Boolean;
begin
  Result := nil;
  Allow := True;
  if Assigned(FOnCreateObject) then
    FOnCreateObject(Self, S, Allow);
  if Allow and (CLSIDFromProgID(PWideChar(S), ClassID) = S_OK) then
    CoCreateInstance(ClassID, nil, CLSCTX_INPROC_SERVER or
      CLSCTX_LOCAL_SERVER, IDispatch, Result);
end;

procedure THostScriptlet.Echo(const S: string);
begin
  if Assigned(FOnEcho) then
    FOnEcho(Self, S);
end;

function THostScriptlet.ReadText(const FileName: string): string;
begin
  Result := FileReadString(FileName);
end;

procedure THostScriptlet.WriteText(const FileName, Value: string);
begin
  FileWriteString(FileName, Value);
end;

{ THostScriptlet.IHostScriptlet }

procedure THostScriptlet.SetOnAlert(const Value: TScriptTextEvent);
begin
  FOnAlert := Value;
end;

function THostScriptlet.GetOnAlert: TScriptTextEvent;
begin
  Result := FOnAlert;
end;

function THostScriptlet.GetOnCreateObject: TScriptActionEvent;
begin
  Result := FOnCreateObject;
end;

procedure THostScriptlet.SetOnCreateObject(const Value: TScriptActionEvent);
begin
  FOnCreateObject := Value;
end;

function THostScriptlet.GetOnEcho: TScriptTextEvent;
begin
  Result := FOnEcho;
end;

procedure THostScriptlet.SetOnEcho(const Value: TScriptTextEvent);
begin
  FOnEcho := Value;
end;

{ TObjectScriptlet }

{ Descendents of TObjectScriptlet should override the GetProperty method rather
 then OnGetPropherty to preserve preprocessing which is done in OnGetProperty }

type
  TObjectScriptlet = class(TScriptlet, IObjectScriptlet)
  private
    FObject: TObject;
    FOwnsObject: Boolean;
  protected
    function PropertySearch(const PropName: string): Boolean; override;
    function OnGetProperty(PropIndex: Integer; const Args: TArgList): OleVariant; override;
    function GetProperty(PropIndex: Integer; const Args: TArgList): OleVariant; virtual;
    procedure OnSetProperty(PropIndex: Integer; const Args: TArgList; const Value: OleVariant); override;
    function AddPropertyScriptlet(AScriptlet: IScriptlet; const PropIndex: Integer): OleVariant;
    { IObjectScriptlet }
    procedure SetObject(Value: TObject);
    function GetObject: TObject;
    property _Object: TObject read FObject;
  public
    constructor Create(Script: TCustomScript; AObject: TObject); reintroduce;
    destructor  Destroy; override;
    property    OwnsObject: Boolean read FOwnsObject write FOwnsObject;
  end;

constructor TObjectScriptlet.Create(Script: TCustomScript; AObject: TObject);
begin
  FObject := AObject;
  inherited Create(Script);
end;

destructor TObjectScriptlet.Destroy;
begin
  if FOwnsObject then
    FObject.Free;
  inherited;
end;

function TObjectScriptlet.PropertySearch(const PropName: string): Boolean;
begin
  Result := False;
  if FObject = nil then
    Exit;
  Result := GetPropInfo(FObject, PropName) <> nil;
end;

function TObjectScriptlet.OnGetProperty(PropIndex: Integer; const Args: TArgList): OleVariant;
begin
  VarClear(Result);
  if (FObject = nil) or (Args.Count > 0) then
    Exit;
  if Assigned(Properties.Objects[PropIndex]) then
  begin
    Result := FProperties.Scriptlets[PropIndex];
    exit;
  end;
  Result := GetProperty(PropIndex, Args);
end;

function TObjectScriptlet.GetProperty(PropIndex: Integer; const Args: TArgList): OleVariant;
var
  PropName: string;
begin
  PropName := Properties[PropIndex];

  if GetPropInfo(FObject, PropName)^.PropType^^.Kind = tkClass then
    Result := AddPropertyScriptlet(CreateScriptlet(FScript, TObject(Integer(GetPropValue(FObject, PropName))), PropName), PropIndex)
  else
    Result := GetPropValue(FObject, PropName);
end;

procedure TObjectScriptlet.OnSetProperty(PropIndex: Integer; const Args: TArgList; const Value: OleVariant);
var
  PropName: string;
  PropInfo: PPropInfo;

  function GetProcName(Code: string): string;
  var
    S: string;
  begin
    S := Copy(Code, Pos(' ', Code) + 1, MaxInt);
    Result := Copy(S, 1, Pos('(', S) - 1);
    if Result = '' then
      raise EIntScriptException.Create(DISP_E_PARAMNOTFOUND, stErrExtMethName);
  end;

begin
  if (FObject = nil) or (Args.Count <> 1) then
    Exit;
  PropName := Properties[PropIndex];
  if VarIsNull(Value) then
  begin
    { Check if the property is event }
    PropInfo := GetPropInfo(FObject.ClassInfo, PropName);
    if Assigned(PropInfo) and (PropInfo.PropType^.Kind = tkMethod) then
    begin
      FScript.RemoveEventHandler(FObject, PropName);
      exit;
    end;
  end;
  If VarType(Value) = varDispatch then
    FScript.AddEventHandler(Self, PropName, GetProcName(Value))
  else
    SetPropValue(FObject, PropName, Value)
end;

function TObjectScriptlet.AddPropertyScriptlet(AScriptlet: IScriptlet; const PropIndex: Integer): OleVariant;
begin
  FProperties.Scriptlets[PropIndex] := AScriptlet;
  Result := AScriptlet;
end;

{ TObjectScriptlet.IObjectScriptlet }

procedure TObjectScriptlet.SetObject(Value: TObject);
begin
  FObject := Value;
end;

function TObjectScriptlet.GetObject: TObject;
begin
  Result := FObject;
end;

{ TComponentScriptlet }

type
  TComponentScriptlet = class(TObjectScriptlet, IComponentScriptlet)
  protected
    function FindComponent(const Name: string): TComponent; virtual;
    function PropertySearch(const PropName: string): Boolean; override;
    function GetProperty(PropIndex: Integer; const Args: TArgList): OleVariant; override;
    { IComponentScriptlet }
    procedure SetComponent(Value: TComponent);
    function GetComponent: TComponent;
    property Component: TComponent read GetComponent;
  end;

function TComponentScriptlet.FindComponent(const Name: string): TComponent;
var
  S: string;
  I: Integer;
begin
  Result := nil;
  if Component = nil then
    Exit;
  S := UpperCase(Name);
  with Component do
  for I := 0 to ComponentCount - 1 do
    if UpperCase(Components[I].Name) = S then
    begin
      Result := Components[I];
      Break;
    end;
end;

function TComponentScriptlet.PropertySearch(const PropName: string): Boolean;
begin
  Result := False;
  if Component = nil then
    Exit;
  Result := (FindComponent(PropName) <> nil) or
    (GetPropInfo(Component, PropName) <> nil);
end;

function TComponentScriptlet.GetProperty(PropIndex: Integer; const Args: TArgList): OleVariant;
var
  PropName: string;
  C: TComponent;
begin
  PropName := Properties[PropIndex];
  C := FindComponent(PropName);
  if C <> nil then
    Result := AddPropertyScriptlet(CreateComponentScriptlet(FScript, C), PropIndex)
  else
    Result := inherited GetProperty(PropIndex, Args);
end;

{ TComponentScriptlet.IComponentScriptlet }

procedure TComponentScriptlet.SetComponent(Value: TComponent);
begin
  SetObject(Value);
  FName := TComponent(Value).Name;
end;

function TComponentScriptlet.GetComponent: TComponent;
begin
  Result := TComponent(_Object);
end;

{ TWinControlScriptlet }

type
  TWinControlScriptlet = class(TComponentScriptlet, IWinControlScriptlet)
  private
    function CreateControl(const Args: TArgList): IScriptlet;
  protected
    function FindComponent(const Name: string): TComponent; override;
    function GetProperty(PropIndex: Integer; const Args: TArgList): OleVariant; override;
    function OnMethod(MethodIndex: Integer; const Args: TArgList): OleVariant; override;
    { IControlScriptlet }
    procedure SetControl(Value: TWinControl);
    function GetControl: TWinControl;
  public
    constructor Create(Script: TCustomScript; Control: TWinControl);
  end;

function TWinControlScriptlet.CreateControl(const Args: TArgList): IScriptlet;
var
  wc: TComponent;
begin
  CheckArgumentCount(Args, 1, 2);
  wc := CreateComponent(ArgParam(Args, 0), _Object as TComponent);
  if wc is TControl then
    TControl(wc).Parent := TWinControl(_Object);
  if Args.Count > 1 then
    wc.Name := ArgParam(Args, 1);
  if wc is TWinControl then
    Result := TWinControlScriptlet.Create(FScript, TWinControl(wc)) as IScriptlet
  else
    Result := TComponentScriptlet.Create(FScript, wc) as IScriptlet;
end;

function TWinControlScriptlet.FindComponent(const Name: string): TComponent;
var
  c: TControl;

  { Recursive find all sub-controls }
  function FindControl(Control: TWinControl; const Name: string): TControl;
  var
    I: Integer;
  begin
    Result := nil;
    for I := 0 to Control.ControlCount - 1 do
    begin
      c := Control.Controls[I];
      if UpperCase(c.Name) = Name then
      begin
        Result := c;
        Break;
      end
      else
      if c is TWinControl then
      begin
        Result := FindControl(c as TWinControl, Name);
        if Assigned(Result) then
          break;
      end;
    end;
  end;

begin
  Result := nil;
  if Component = nil then
    Exit;
  Result := FindControl(Component as TWinControl, UpperCase(Name));
end;

function TWinControlScriptlet.GetProperty(PropIndex: Integer; const Args: TArgList): OleVariant;
var
  PropName: string;
  C: TComponent;
begin
  PropName := Properties[PropIndex];
  C := FindComponent(PropName);
  if C is TWinControl then
    Result := AddPropertyScriptlet(CreateWinControlScriptlet(FScript, TWinControl(C)), PropIndex)
  else
    Result := inherited GetProperty(PropIndex, Args);
end;

procedure TWinControlScriptlet.SetControl(Value: TWinControl);
begin
  SetComponent(Value);
end;

function TWinControlScriptlet.GetControl: TWinControl;
begin
  Result := GetComponent as TWinControl;
end;

function TWinControlScriptlet.OnMethod(MethodIndex: Integer; const Args: TArgList): OleVariant;
begin
  VarClear(Result);
  case MethodIndex of
    0: Result := CreateControl(Args);
    1: TWinControl(_Object).SetFocus;
  end;
end;

constructor TWinControlScriptlet.Create(Script: TCustomScript; Control: TWinControl);
begin
  inherited Create(Script, Control);
  Methods.Add('insertControl');
  Methods.Add('setFocus');
end;

{ TStringsScriptlet }

type
  TStringsScriptlet = class(TObjectScriptlet, IObjectScriptlet)
  private
    FStrings: TStrings;
    function  Add(const Value: string): Integer;
    procedure Delete(const Index: Integer);
    procedure Insert(Index: Integer; const S: string);
    function  IndexOf(const S: string): Integer;
    function  IndexOfName(const Name: string): Integer;
  protected
    function  PropertySearch(const PropName: string): Boolean; override;
    function  GetProperty(PropIndex: Integer; const Args: TArgList): OleVariant; override;
    procedure OnSetProperty(PropIndex: Integer; const Args: TArgList; const Value: OleVariant); override;
    function  OnMethod(MethodIndex: Integer; const Args: TArgList): OleVariant; override;
  public
    constructor Create(Script: TCustomScript; Strings: TStrings);
  end;

function TStringsScriptlet.Add(const Value: string): Integer;
begin
  Result := FStrings.Add(Value);
end;

procedure TStringsScriptlet.Delete(const Index: Integer);
begin
  FStrings.Delete(Index);
end;

procedure TStringsScriptlet.Insert(Index: Integer; const S: string);
begin
  FStrings.Insert(Index, S);
end;

function TStringsScriptlet.IndexOf(const S: string): Integer;
begin
  Result := FStrings.IndexOf(S);
end;

function TStringsScriptlet.IndexOfName(const Name: string): Integer;
begin
  Result := FStrings.IndexOfName(Name);
end;

function TStringsScriptlet.PropertySearch(const PropName: string): Boolean;
begin
  Result := (PropName = 'TEXT') or (PropName = 'COMMATEXT') or
            (PropName = 'COUNT') or IsNumber(PropName);
end;

function TStringsScriptlet.GetProperty(PropIndex: Integer; const Args: TArgList): OleVariant;
var
  PropName: string;

begin
  PropName := Properties[PropIndex];

  if PropName='COUNT' then
    Result := FStrings.Count
  else
  if PropName='TEXT' then
    Result := FStrings.Text
  else
  if PropName='COMMATEXT' then
    Result := FStrings.CommaText
  else
  if IsNumber(PropName) then
    Result := FStrings[StrToInt(PropName)]
end;

procedure TStringsScriptlet.OnSetProperty(PropIndex: Integer; const Args: TArgList; const Value: OleVariant);
var
  PropName: string;
begin
  if not Assigned(FStrings) or (Args.Count <> 1) then
    Exit;
  PropName := Properties[PropIndex];

  if PropName='TEXT' then
    FStrings.Text := Value
  else
  if PropName='COMMATEXT' then
    FStrings.CommaText := Value
  else
  if IsNumber(PropName) then
    FStrings[StrToInt(PropName)] := Value
  else
    raise EIntScriptException.Create(DISP_E_EXCEPTION, stPropReadOnly);  
end;

function TStringsScriptlet.OnMethod(MethodIndex: Integer; const Args: TArgList): OleVariant;

  function Arg(Index: Integer): OleVariant;
  begin
    Result := ArgParam(Args, Index);
  end;

begin
  VarClear(Result);
  case MethodIndex of
    0: Result := Add(Arg(0));
    1: Delete(Arg(0));
    2: Insert(Arg(0), Arg(1));
    3: Result := IndexOf(Arg(0));
    4: Result := IndexOfName(Arg(0));
  end;
end;

constructor TStringsScriptlet.Create(Script: TCustomScript; Strings: TStrings);
begin
  inherited Create(Script, Strings);
  FStrings := Strings;
  Methods.Add('add');
  Methods.Add('deleteAt');
  Methods.Add('insert');
  Methods.Add('indexOf');
  Methods.Add('indexOfName');
end;

{ TLdapEntryListScriptlet }

type
  TLdapEntryListScriptlet = class(TObjectScriptlet, IObjectScriptlet)
  protected
    function PropertySearch(const PropName: string): Boolean; override;
    function GetProperty(PropIndex: Integer; const Args: TArgList): OleVariant; override;
    procedure OnSetProperty(PropIndex: Integer; const Args: TArgList; const Value: OleVariant); override;
  end;

function TLdapEntryListScriptlet.PropertySearch(const PropName: string): Boolean;
begin
  Result := (PropName = 'COUNT') or IsNumber(PropName);
end;

function TLdapEntryListScriptlet.GetProperty(PropIndex: Integer; const Args: TArgList): OleVariant;
var
  PropName: string;
begin
  PropName := Properties[PropIndex];

  if PropName = 'COUNT' then
    Result := TLdapEntryList(_Object).Count
  else
  if IsNumber(PropName) then
    Result := AddPropertyScriptlet(CreateScriptlet(FScript, TLdapEntryList(_Object)[StrToInt(PropName)], PropName), PropIndex)
end;

procedure TLdapEntryListScriptlet.OnSetProperty(PropIndex: Integer; const Args: TArgList; const Value: OleVariant);
begin
  raise EIntScriptException.Create(DISP_E_EXCEPTION, stWritePropRO);
end;

{ TLdapAttributeScriptlet }

type
  TLdapAttributeScriptlet = class(TObjectScriptlet, IObjectScriptlet)
  protected
    function PropertySearch(const PropName: string): Boolean; override;
    function GetProperty(PropIndex: Integer; const Args: TArgList): OleVariant; override;
    function OnMethod(MethodIndex: Integer; const Args: TArgList): OleVariant; override;
    procedure OnSetProperty(PropIndex: Integer; const Args: TArgList; const Value: OleVariant); override;
  public
    constructor Create(Script: TCustomScript; Attribute: TLdapAttribute);
  end;

function TLdapAttributeScriptlet.PropertySearch(const PropName: string): Boolean;
begin
  Result := (PropName = 'VALUE') or (PropName = 'VALUES')
            or IsNumber(PropName) or inherited PropertySearch(PropName);
end;

function TLdapAttributeScriptlet.GetProperty(PropIndex: Integer; const Args: TArgList): OleVariant;
var
  PropName: string;
begin
  PropName := Properties[PropIndex];

  if PropName = 'VALUE' then
    Result := TLdapAttribute(_Object).AsString
  else
  if PropName = 'VALUES' then
    Result := Self as IScriptlet
  else
  if IsNumber(PropName) then
    Result := TLdapAttribute(_Object)[StrToInt(PropName)].AsString
  else
    Result := inherited GetProperty(PropIndex, Args)
end;

procedure TLdapAttributeScriptlet.OnSetProperty(PropIndex: Integer; const Args: TArgList; const Value: OleVariant);
var
  PropName: string;
begin
  if not Assigned(_Object) or (Args.Count <> 1) then
    Exit;
  PropName := Properties[PropIndex];

  if PropName = 'VALUE' then
    TLdapAttribute(_Object).AsString := Value
  else
  if IsNumber(PropName) then
    TLdapAttribute(_Object)[StrToInt(PropName)].AsString := Value
  else
    inherited;
end;

function TLdapAttributeScriptlet.OnMethod(MethodIndex: Integer; const Args: TArgList): OleVariant;
begin
  VarClear(Result);
  case MethodIndex of
    0: TLdapAttribute(_Object).AddValue(string(ArgParam(Args, 0)));
    1: TLdapAttribute(_Object).DeleteValue(string(ArgParam(Args, 0)));
    2: TLdapAttribute(_Object).Values[ArgParam(Args, 0)].Delete;
    3: TLdapAttribute(_Object).IndexOf(string(ArgParam(Args, 0)));
  end;
end;

constructor TLdapAttributeScriptlet.Create(Script: TCustomScript; Attribute: TLdapAttribute);
begin
  inherited Create(Script, Attribute);
  Methods.Add('addValue');
  Methods.Add('deleteValue');
  Methods.Add('deleteValueAt');
  Methods.Add('indexOf');
end;

{ TLdapAttributeListScriptlet }

type
  TLdapAttributeListScriptlet = class(TObjectScriptlet, IObjectScriptlet)
  protected
    function PropertySearch(const PropName: string): Boolean; override;
    function GetProperty(PropIndex: Integer; const Args: TArgList): OleVariant; override;
    procedure OnSetProperty(PropIndex: Integer; const Args: TArgList; const Value: OleVariant); override;
  end;

function TLdapAttributeListScriptlet.PropertySearch(const PropName: string): Boolean;
begin
  Result := (GetName = 'ATTRIBUTESBYNAME') or (PropName = 'COUNT') or IsNumber(PropName);
end;

function TLdapAttributeListScriptlet.GetProperty(PropIndex: Integer; const Args: TArgList): OleVariant;
var
  PropName: string;
begin
  PropName := Properties[PropIndex];

  if GetName = 'ATTRIBUTESBYNAME' then
    Result := AddPropertyScriptlet(CreateScriptlet(FScript, TLdapEntry(_Object).AttributesByName[PropName], PropName), PropIndex)
  else
  if PropName = 'COUNT' then
    Result := TLdapEntry(_Object).Attributes.Count
  else
  if IsNumber(PropName) then
    Result := AddPropertyScriptlet(CreateScriptlet(FScript, TLdapEntry(_Object).Attributes[StrToInt(PropName)], PropName), PropIndex)
end;

procedure TLdapAttributeListScriptlet.OnSetProperty(PropIndex: Integer; const Args: TArgList; const Value: OleVariant);
begin
  raise EIntScriptException.Create(DISP_E_EXCEPTION, stWritePropRO);
end;

function CreateLdapAttributeListScriptlet(Script: TCustomScript; Entry: TLdapEntry; const Name: string): IScriptlet;
begin
  Result := TLdapAttributeListScriptlet.Create(Script, Entry) as IScriptlet;
  Result.Name := Name;
end;

{ TLdapEntryScriptlet }

type
  TLdapEntryScriptlet = class(TObjectScriptlet, IObjectScriptlet)
  protected
    function PropertySearch(const PropName: string): Boolean; override;
    function GetProperty(PropIndex: Integer; const Args: TArgList): OleVariant; override;
    function OnMethod(MethodIndex: Integer; const Args: TArgList): OleVariant; override;
  public
    constructor Create(Script: TCustomScript; Entry: TLdapEntry);
  end;

function TLdapEntryScriptlet.PropertySearch(const PropName: string): Boolean;
begin
  Result := (PropName = 'ATTRIBUTES') or (PropName = 'ATTRIBUTESBYNAME') or
            inherited PropertySearch(PropName);
end;

function TLdapEntryScriptlet.GetProperty(PropIndex: Integer; const Args: TArgList): OleVariant;
var
  PropName: string;
begin
  PropName := Properties[PropIndex];

  if (PropName='ATTRIBUTESBYNAME') or (PropName = 'ATTRIBUTES') then
    Result := AddPropertyScriptlet(CreateLdapAttributeListScriptlet(FScript, TLdapEntry(_Object), PropName), PropIndex)
  else
    Result := inherited GetProperty(PropIndex, Args);
end;

function TLdapEntryScriptlet.OnMethod(MethodIndex: Integer; const Args: TArgList): OleVariant;
begin
  VarClear(Result);
  case MethodIndex of
    0: TLdapEntry(_Object).Read;
    1: TLdapEntry(_Object).Write;
    2: TLdapEntry(_Object).Delete;
  end;
end;

constructor TLdapEntryScriptlet.Create(Script: TCustomScript; Entry: TLdapEntry);
begin
  inherited Create(Script, Entry);
  Methods.Add('read');
  Methods.Add('write');
  Methods.Add('deleteEntry');
end;

{ TLdapSessionScriptlet }

type
  TLdapSessionScriptlet = class(TObjectScriptlet, IObjectScriptlet)
  private
    FSession: TLdapSession;
  function Search(const Args: TArgList): IScriptlet;
  function Lookup(const Args: TArgList): string;
  function CreateEntry(const Args: TArgList): IScriptlet;
  protected
    function  OnMethod(MethodIndex: Integer; const Args: TArgList): OleVariant; override;
  public
    constructor Create(Script: TCustomScript; Session: TLdapSession);
  end;

function TLdapSessionScriptlet.Search(const Args: TArgList): IScriptlet;
var
  Entries: TLdapEntryList;
  es: TLdapEntryListScriptlet;
  attrs: PCharArray;
  sl: TStringList;
  len: Integer;
begin
  CheckArgumentCount(Args, 5, 5);
  sl := TStringList.Create;
  try
    sl.CommaText := ArgParam(Args, 3);
    attrs := nil;
    len := sl.Count;
    if Len > 0 then
    begin
      SetLength(attrs, len + 1);
      attrs[len] := nil;
      repeat
        dec(len);
        attrs[len] := PChar(sl[len]);
      until len = 0;
    end;
    Entries := TLdapEntryList.Create;
    FSession.Search(string(ArgParam(Args, 0)), string(ArgParam(Args, 1)), Integer(ArgParam(Args, 2)), attrs, false, Entries);
    es := TLdapEntryListScriptlet.Create(FScript, Entries);
    es.OwnsObject := true;
    Result := es as IScriptlet;
    Result.Name := 'Search';
  finally
    sl.Free;
  end;
end;

function TLdapSessionScriptlet.Lookup(const Args: TArgList): string;
begin
  CheckArgumentCount(Args, 4, 4);
  Result := FSession.Lookup(string(ArgParam(Args, 0)), string(ArgParam(Args, 1)), string(ArgParam(Args, 2)), Integer(ArgParam(Args, 3)));
end;

function TLdapSessionScriptlet.CreateEntry(const Args: TArgList): IScriptlet;
var
  Entry: TLdapEntry;
  es: TLdapEntryScriptlet;
begin
  CheckArgumentCount(Args, 1, 1);
  Entry := TLdapEntry.Create(FSession, string(ArgParam(Args, 0)));
  try
    es := TLdapEntryScriptlet.Create(FScript, Entry);
    es.OwnsObject := true;
    Result := es as iScriptlet;
  except
    Entry.Free;
    raise;
  end;
end;

function TLdapSessionScriptlet.OnMethod(MethodIndex: Integer; const Args: TArgList): OleVariant;
begin
  VarClear(Result);
  case MethodIndex of
    0: Result := (FSession as TConnection).GetUid;
    1: Result := (FSession as TConnection).GetGid;
    2: Result := Search(Args);
    3: Result := Lookup(Args);
    4: Result := CreateEntry(Args);
  end;
end;

constructor TLdapSessionScriptlet.Create(Script: TCustomScript; Session: TLdapSession);
begin
  inherited Create(Script, Session);
  FSession := Session;
  Methods.Add('GetUid');
  Methods.Add('GetGid');
  Methods.Add('Search');
  Methods.Add('Lookup');
  Methods.Add('CreateEntry');
end;

{ Scriptlet creation routines }

function CreateHostScriptlet(Script: TCustomScript; Alert, Echo: TScriptTextEvent): IHostScriptlet;
begin
  Result := THostScriptlet.Create(Script) as IHostScriptlet;
  Result.OnAlert := Alert;
  Result.OnEcho := Echo;
end;

function CreateComponentScriptlet(Script: TCustomScript; Component: TComponent; const Name: string = ''): IComponentScriptlet;
begin
  Result := TComponentScriptlet.Create(Script, Component) as IComponentScriptlet;
  if Name <> '' then
    Result.Name := Name
  else
    Result.Name := Component.Name;
end;

function CreateWinControlScriptlet(Script: TCustomScript; Control: TWinControl; const Name: string = ''): IWinControlScriptlet;
begin
  Result := TWinControlScriptlet.Create(Script, Control) as IWinControlScriptlet;
  if Name <> '' then
    Result.Name := Name
  else
    Result.Name := Control.Name;
end;

function CreateScriptlet(Script: TCustomScript; AObject: TObject; const Name: string): IScriptlet;
begin
  if AObject is TStrings then
    Result := TStringsScriptlet.Create(Script, TStrings(AObject)) as IScriptlet
  else
  if AObject is TLdapSession then
    Result := TLdapSessionScriptlet.Create(Script, TLdapSession(AObject)) as IScriptlet
  else
  if AObject is TLdapEntry then
    Result := TLdapEntryScriptlet.Create(Script, TLdapEntry(AObject)) as IScriptlet
  else
  if AObject is TLdapAttribute then
    Result := TLdapAttributeScriptlet.Create(Script, TLdapAttribute(AObject)) as IScriptlet
  else
    Result := TObjectScriptlet.Create(Script, AObject) as IObjectScriptlet;
  Result.Name := Name;
end;

end.
