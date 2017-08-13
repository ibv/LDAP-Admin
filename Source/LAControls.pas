  {      LDAPAdmin - LAControls.pas
  *      Copyright (C) 2006 Alexander Sokoloff
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

unit LAControls;

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
  Messages, Controls, StdCtrls, Classes, Graphics;

type

  TWMDrawItem = TLMDrawItems;

  TBtnState=(bs_Normal, bs_Push, bs_Hot, bs_Disabled);
  TLAComboBox=class;

  TPopupList=class(TCustomListBox)
  private
    FCombo:       TLAComboBox;
    procedure     CNDrawItem(var Message: TWMDrawItem); message CN_DRAWITEM;
    procedure     WMMouseMove(var Message: TLMMouseMove); message WM_MOUSEMOVE;
  protected
    procedure     CreateParams(var Params: TCreateParams); override;
    procedure     CreateWnd; override;
    constructor   Create(AOwner: TLAComboBox); reintroduce;
  end;

  TComboCanCloseUp=procedure(var Index: integer; var CanCloseUp: boolean) of object;

  TLAComboBox=class(TCustomEdit)
  private
    FBtnRect:     TRect;
    FClickRect:   TRect;
    FBtnState:    TBtnState;
    FPickList:    TPopupList;
    FDropDownCount: Integer;
    FItemIndex:   Integer;
    FStyle:       TComboBoxStyle;
    FEdCanvas:    TCanvas;
    FOnDrawItem:  TDrawItemEvent;
    FIsDraw:      boolean;
    FOnCanCloseUp: TComboCanCloseUp;
    FOnDropDown:  TNotifyEvent;
    FOnCloseUp:   TNotifyEvent;
    FOnKeyDown:   TKeyEvent;
    procedure     DrawBtn;
    function      GetDroppedDown: boolean;
    procedure     SetDroppedDown(const Value: boolean);
    function      GetItems: TStrings;
    function      GetItemHt: Integer;
    procedure     SetItemHt(const Value: Integer);
    procedure     SetDropDownCount(const Value: Integer);
    procedure     CMCancelMode(var Message: TCMCancelMode); message CM_CancelMode;
    procedure     WMPaint(var Message: TWMPaint); message WM_PAINT;
    procedure     SetItemIndex(const Value: Integer);
    procedure     SetStyle(const Value: TComboBoxStyle);
    procedure     MouseMsgProc(var Message: TWMLButtonDown);
    procedure     KeyMsgProc(var Message: TWMKeyDown);
    procedure     PickListDrawItem(Control: TWinControl; Index: Integer; Rect: TRect; State: TOwnerDrawState);
    procedure     SetOnDrawItem(const Value: TDrawItemEvent);
    function      GetCanvas: TCanvas;
    function      GetDropDownFont: TFont;
    procedure     SetDropDownFont(const Value: TFont);
  protected
    procedure     ListMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);

    procedure     WndProc(var Message: TMessage); override;
    procedure     CreateWnd; override;
    procedure     CreateParams(var Params: TCreateParams); override;
  public
    constructor   Create(Owner: TComponent); override;
    destructor    Destroy; override;
    procedure     DropDown;
    procedure     CloseUp(Accept: boolean);
    procedure     Invalidate; override;

    property      Items: TStrings read GetItems;
    property      DroppedDown: boolean read GetDroppedDown write SetDroppedDown;
    property      DropDownCount: Integer read FDropDownCount write SetDropDownCount;
    property      ItemHeight: Integer read GetItemHt write SetItemHt;
    property      ItemIndex: Integer read FItemIndex write SetItemIndex;
    property      Style: TComboBoxStyle read FStyle write SetStyle;
    property      Canvas: TCanvas read GetCanvas;
    property      OnDrawItem: TDrawItemEvent read FOnDrawItem write SetOnDrawItem;
    property      OnCanCloseUp: TComboCanCloseUp read FOnCanCloseUp write FOnCanCloseUp;
    property      DropDownFont: TFont read GetDropDownFont write SetDropDownFont;
    property      OnDropDown: TNotifyEvent read FOnDropDown write FOnDropDown;
//    property      OnSelect: TNotifyEvent read FOnSelect write FOnSelect;
    property      OnCloseUp: TNotifyEvent read FOnCloseUp write FOnCloseUp;
    property      OnKeyDown: TKeyEvent read FOnKeyDown write FOnKeyDown;

    property      OnChange;
    property      Color;
    property      BorderStyle;
    property      Font;
    property      OnEnter;
    property      OnExit;

  end;

procedure DrawComboBtn(Canvas: TCanvas; Rect: TRect; BtnState: TBtnState);

implementation
{$I LdapAdmin.inc}
(*{$DEFINE XPSTYLE}

{$IFDEF VER100} {$UNDEF XPSTYLE} {$ENDIF} //Delphi 3
{$IFDEF VER120} {$UNDEF XPSTYLE} {$ENDIF} //Delphi 4
{$IFDEF VER130} {$UNDEF XPSTYLE} {$ENDIF} //Delphi 5
{$IFDEF VER140} {$UNDEF XPSTYLE} {$ENDIF} //Delphi 6*)


uses Forms, SysUtils,
{$IFDEF VER_XEH}System.Types, {$ENDIF}
{$IFDEF XPSTYLE}
 Themes,
{$ENDIF}
Math;

procedure DrawComboBtn(Canvas: TCanvas; Rect: TRect; BtnState: TBtnState);
var
  uState: Cardinal;
begin
  {$IFDEF XPSTYLE}
  if ThemeServices.ThemesEnabled then begin
    Rect.Left:=rect.Left+1;
    Rect.Top:=Rect.Top-1;
    Rect.Right:=Rect.Right+1;
    Rect.Bottom:=Rect.Bottom+1;
    case BtnState of
      bs_Disabled:  ThemeServices.DrawElement(Canvas.Handle, ThemeServices.GetElementDetails(tcDropDownButtonDisabled), Rect);
      bs_Hot:       ThemeServices.DrawElement(Canvas.Handle, ThemeServices.GetElementDetails(tcDropDownButtonHot),      Rect);
      bs_Normal:    ThemeServices.DrawElement(Canvas.Handle, ThemeServices.GetElementDetails(tcDropDownButtonNormal),   Rect);
      bs_Push:      ThemeServices.DrawElement(Canvas.Handle, ThemeServices.GetElementDetails(tcDropDownButtonPressed),  Rect);
    end;
    exit;
  end;
  {$ENDIF}

  case BtnState of
    bs_Disabled:  uState:=DFCS_INACTIVE;
    bs_Hot:       uState:=DFCS_HOT;
    bs_Push:      uState:=DFCS_FLAT;
    else          uState:=0;
  end;

  DrawFrameControl(Canvas.Handle, Rect, DFC_SCROLL, DFCS_SCROLLCOMBOBOX or uState);
end;


{ TPopupList }

constructor TPopupList.Create(AOwner: TLAComboBox);
begin
  inherited Create(AOwner);
  FCombo:=AOwner;
end;


procedure TPopupList.CNDrawItem(var Message: TWMDrawItem);
var
  State: TOwnerDrawState;
  Sel, Enbl: boolean;
begin
  with Message.DrawItemStruct^ do
  begin
    {$ifdef mswindows}
    State := TOwnerDrawState(LongRec(itemState).Lo);
    Canvas.Handle := hDC;
    {$else}
    State := TOwnerDrawState(itemState);
    Canvas.Handle :=  GetDC(0);
    {$endif}
    Canvas.Font := Font;
    Canvas.Brush := Brush;
    Sel:=(Integer(itemID) >= 0) and (odSelected in State);
    Enbl := true;
    if assigned(FCombo.OnCanCloseUp) then
      FCombo.OnCanCloseUp(Integer(itemID), Enbl);
    if Sel then
    begin
      Canvas.Brush.Color := clHighlight;
      Canvas.Font.Color := clHighlightText
    end
    else
    if not Enbl then
      Canvas.Font.Color := clGray;
    if Integer(itemID) >= 0 then
      DrawItem(itemID, rcItem, State) else
      Canvas.FillRect(rcItem);
    Canvas.Handle := 0;
  end;
end;


procedure TPopupList.CreateParams(var Params: TCreateParams);
begin
  inherited;
  with Params do begin
    Style:=Style or WS_BORDER;
    ExStyle:=WS_EX_TOOLWINDOW or WS_EX_TOPMOST;
    ///WindowClass.style:=CS_SAVEBITS;
  end;
end;

procedure TPopupList.CreateWnd;
begin
  inherited CreateWnd;
  ///windows.SetParent(Handle, 0);
  SetParent(self);
  CallWindowProc(DefWndProc, Handle, WM_SETFOCUS, 0, 0);
end;


procedure TPopupList.WMMouseMove(var Message: TWMMouseMove);
begin
  inherited;
  ItemIndex:= ItemAtPos(point(Message.XPos, Message.YPos), true);
end;

{ TLAComboBox }

constructor TLAComboBox.Create(Owner: TComponent);
begin
  inherited;
  Width:=145;
  FStyle:=csDropDown;
  FEdCanvas := TControlCanvas.Create;
  TControlCanvas(FEdCanvas).Control := Self;

  FPickList:=TPopupList.Create(self);
  FPickList.OnMouseUp:=ListMouseUp;
  FPickList.Visible:=false;
  ///FPickList.Parent:=self;
  FPickList.Parent:=nil;
  FPickList.ItemHeight:=13;
  FPickList.Style:=lbOwnerDrawFixed;
  FItemIndex := -1;

  FDropDownCount:=8;
  FBtnState:=bs_Normal;
end;

destructor TLAComboBox.Destroy;
begin
  FPickList.Free;
  FEdCanvas.Free;
  inherited;
end;

procedure TLAComboBox.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  Params.Style := Params.Style or ES_MULTILINE or WS_CLIPCHILDREN;
end;

procedure TLAComboBox.CreateWnd;
begin
  inherited CreateWnd;


end;

procedure TLAComboBox.Invalidate;
var
  Loc: TRect;
begin
  inherited;

  if Style=csSimple then
  begin
    FBtnRect:=rect(1,1,0,0);
    FClickRect:=rect(1,1,0,0);
    exit;
  end;

  Loc:=rect(1,1,ClientWidth - GetSystemMetrics(SM_CXHTHUMB) - 2,ClientHeight + 1);
  FBtnRect:=rect(Loc.Right+2,0,ClientWidth,ClientHeight);

  case Style of
    csDropDown:     begin
                      FClickRect:=FBtnRect;
                      ///SendMessage(Handle, EM_SETRECTNP, 0, LongInt(@Loc));
                      SendMessage(Handle, $00B4, 0, LongInt(@Loc));
                    end;
    else            begin
                      FClickRect:=ClientRect;
                      OffsetRect(Loc, 0, height+2);
                      ///SendMessage(Handle, EM_SETRECTNP, 0, LongInt(@Loc));
                      SendMessage(Handle, $00B4, 0, LongInt(@Loc));
                    end;
  end;
  OnDrawItem:=OnDrawItem;

  ///SendMessage(Handle, EM_GETRECT, 0, LongInt(@Loc));  {debug}
  SendMessage(Handle, $00B2, 0, LongInt(@Loc));

end;


procedure TLAComboBox.MouseMsgProc(var Message: TWMLButtonDown);
begin
  if Style=csSimple then exit;

  if PtInRect(FClickRect, point(Message.XPos, Message.YPos)) then begin
    if( Message.Keys and MK_LBUTTON>0) then begin
      FBtnState:=bs_Push;
      if (Message.Msg=WM_LBUTTONDOWN) or (Message.Msg=WM_LBUTTONDBLCLK) then DroppedDown:=not DroppedDown;
    end
    else FBtnState:=bs_Hot;

    Cursor:=crArrow
  end
  else begin
    FBtnState:=bs_Normal;
    Cursor:=crDefault;
  end;
end;

procedure TLAComboBox.KeyMsgProc(var Message: TWMKeyDown);
var
  Shift: TShiftState;
begin
  Shift:=KeyDataToShiftState(Message.KeyData);
  if Assigned(FOnKeyDown) then FOnKeyDown(self, Message.CharCode, Shift);
  if Message.CharCode=0 then exit;
  if Style=csSimple then exit;


  case Message.CharCode of
    VK_UP,
    VK_DOWN:    if ssAlt in Shift then begin
                  if DroppedDown then CloseUp(true)
                  else DropDown;
                  Message.CharCode:=0;
                end
                else begin
                  case Message.CharCode of
                    VK_UP:    ItemIndex:=max(1, ItemIndex-1);
                    VK_DOWN:  ItemIndex:=min(Items.Count-1, ItemIndex+1);
                  end;
                  Message.CharCode:=0;
                end;
    VK_ESCAPE,
    VK_RETURN:  if DroppedDown and not (ssAlt in Shift) then begin
                  CloseUp(Message.CharCode=VK_RETURN);
                  Message.CharCode:=0;
                end;
  end;

  if DroppedDown then begin
    FPickList.Perform(Message.Msg, TMessage(Message).WParam, TMessage(Message).LParam);
    Message.CharCode:=0;
  end;

  if (Style<>csSimple) and (Style<>csDropDown) then Message.CharCode:=0;
end;

procedure TLAComboBox.WndProc(var Message: TMessage);
var
  AState: TBtnState;
begin
   AState:=FBtnState;
   case Message.Msg of
    WM_KEYDOWN,
    WM_SYSKEYDOWN,
    WM_CHAR:          begin
                        KeyMsgProc(TWMKeyDown(Message));
                        if (TWMKeyDown(Message).CharCode=0)  or
                           (TWMKeyDown(Message).CharCode=13) then exit;
                      end;
    WM_SETFOCUS:      Invalidate;
    WM_KILLFOCUS:     begin
                        CloseUp(false);
                        Invalidate;
                      end;
    WM_PAINT:         begin
                        inherited;
                        DrawBtn;
                        exit;
                      end;
    ///WM_ENABLE:      if Message.WParam=0 then FBtnState:=bs_Disabled
    $000A:      if Message.WParam=0 then FBtnState:=bs_Disabled
                    else FBtnState:=bs_Normal;
    WM_MOUSELEAVE:  FBtnState:=bs_Normal;

    ///WM_CONTEXTMENU: if (Style<>csSimple) and (Style<>csDropDown) then Message.Result:=1; 
    $007B: if (Style<>csSimple) and (Style<>csDropDown) then Message.Result:=1;
    WM_LBUTTONDBLCLK,
    WM_MOUSEMOVE,
    WM_LBUTTONUP,
    WM_LBUTTONDOWN:  MouseMsgProc(TWMLbuttonDown(Message));
    WM_SIZE:         Invalidate;
    end;
    inherited;
    if AState<>FBtnState then DrawBtn;
end;

procedure TLAComboBox.DrawBtn;
var
  p: TPoint;
  ABtnState: TBtnState;
begin
  if Style=csSimple then exit;

  p:=ScreenToClient(Mouse.CursorPos);

  if Enabled then begin
    ABtnState:=bs_Normal;
    if PtInRect(FBtnRect, P) then begin
      if HiWord(GetKeyState(VK_LBUTTON))>0 then ABtnState:=bs_Push
      else ABtnState:=bs_Hot;
    end;
  end
  else ABtnState:=bs_Disabled;

  DrawComboBtn(FEdCanvas, FBtnRect, ABtnState);
end;


procedure TLAComboBox.ListMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  CloseUp(PtInRect(FPickList.ClientRect, point(X,Y)));
end;

procedure TLAComboBox.DropDown;
var
  P: Tpoint;
  Y, H: integer;
begin
  if FPickList.Visible then exit;

  FPickList.ItemIndex:=ItemIndex;
  if Style=csDropDown then begin
    if (ItemIndex>-1) and (FPickList.Items[ItemIndex]<>Text) then
      FPickList.ItemIndex:=FPickList.Items.IndexOf(Text);
  end;

  P:=Parent.ClientToScreen(Point(Left, Top));
  Y:=P.Y+Height;
  H:= max(1, min(FPickList.Items.Count, DropDownCount)) * ItemHeight;
  if Y+H>Screen.Height then Y:=P.Y-H-2;
  try
    SetWindowPos(FPickList.Handle, HWND_TOP, P.X, Y, Width, H, {SWP_NOSIZE or} SWP_NOACTIVATE or SWP_SHOWWINDOW);
  except
  end;
  FPickList.ClientHeight:= max(1, min(FPickList.Items.Count, DropDownCount)) * ItemHeight;


  FPickList.Visible:=true;

  SetFocus;
  Invalidate;
  if assigned(FOnDropDown) then FOnDropDown(self);
end;

procedure TLAComboBox.CloseUp(Accept: boolean);
var
  Index: integer;
  CanClose: boolean;
begin
  if not DroppedDown then exit;
  if not FPickList.Visible then exit;
  Index:=FPickList.ItemIndex;
  if Accept and assigned(FOnCanCloseUp) then begin
    CanClose:=true;
    FOnCanCloseUp(Index, CanClose);
    if not CanClose then exit;
  end;

  if GetCapture<>0 then SendMessage(GetCapture, WM_CANCELMODE, 0, 0);
  try
    ///SetWindowPos(FPickList.Handle, 0,0,0,0,0, SWP_NOZORDER or SWP_NOMOVE or SWP_NOACTIVATE or SWP_HIDEWINDOW);
  except
  end;
  if Accept then ItemIndex:=Index;
  FPickList.Visible:=false;
  SetFocus;
  Invalidate;
  SelectAll;
  if Assigned(FOnCloseUp) then FOnCloseUp(self);
end;

function TLAComboBox.GetDroppedDown: boolean;
begin
  result:=FPickList.Visible;
end;

procedure TLAComboBox.SetDroppedDown(const Value: boolean);
begin
  if Value then DropDown
  else CloseUp(false);
end;

function TLAComboBox.GetItems: TStrings;
begin
  result:=FPickList.Items;
end;

function TLAComboBox.GetItemHt: Integer;
begin
  result:=FPickList.ItemHeight;
end;

procedure TLAComboBox.SetItemHt(const Value: Integer);
begin
  FPickList.ItemHeight:=Value;
end;

procedure TLAComboBox.SetDropDownCount(const Value: Integer);
begin
  FDropDownCount := Value;
end;

procedure TLAComboBox.CMCancelMode(var Message: TCMCancelMode);
begin
  if (Message.Sender<>self) and (Message.Sender<>FPickList) then CloseUp(false);
end;

procedure TLAComboBox.SetItemIndex(const Value: Integer);
begin
  FItemIndex:=Value;
  FPickList.ItemIndex:=Value;
  if FItemIndex>-1 then Text:=FPickList.Items[FItemIndex];
end;

procedure TLAComboBox.SetStyle(const Value: TComboBoxStyle);
begin
  FStyle := Value;
  if ItemIndex<0 then Text:=''
  else Text:=Items[ItemIndex];
  RecreateWnd(Self);{ *Převedeno z RecreateWnd* }

end;

procedure TLAComboBox.WMPaint(var Message: TWMPaint);
var
  ARect: TRect;
  State: TOwnerDrawState;
begin
  inherited;
  if (Style=csSimple) or (Style=csDropDown) then exit;

  ARect:=ClientRect;
  Arect.Right:=FBtnRect.Left;
  InflateRect(Arect, -2, -2);


  FEdCanvas.Font:=Font;
  if Focused and not DroppedDown then begin
    FEdCanvas.Font.Color:=clHighlightText;
    FEdCanvas.Brush.Color:=clHighlight;
    FEdCanvas.FillRect(ARect);
    State:=[odFocused]
  end
  else
  begin
    FEdCanvas.Brush.Color:=Color;
    State := [];
  end;

  if (Style<>csDropDownList) and assigned(FOnDrawItem) and (ItemIndex <> -1) then begin
    FIsDraw:=true;
    FOnDrawItem(self, ItemIndex, ClientRect, [odComboBoxEdit] + State);
    FIsDraw:=false;
  end
  else begin
    DrawText(FEdCanvas.Handle, pchar(Text), -1, ARect, DT_EDITCONTROL);
  end;

  if Focused and not DroppedDown then begin
    InflateRect(Arect, 1, 1);
    FEdCanvas.DrawFocusRect(ARect);
  end;
end;

procedure TLAComboBox.SetOnDrawItem(const Value: TDrawItemEvent);
begin
  FOnDrawItem := Value;
  if ((Style=csOwnerDrawFixed) or (Style=csOwnerDrawVariable)) and assigned(FOnDrawItem) then
    FPickList.OnDrawItem:=PickListDrawItem;
end;


procedure TLAComboBox.PickListDrawItem(Control: TWinControl; Index: Integer; Rect: TRect; State: TOwnerDrawState);
begin
  if assigned(FOnDrawItem) then FOnDrawItem(self, Index, Rect, State);
end;

function TLAComboBox.GetCanvas: TCanvas;
begin
  if FIsDraw then result:=FEdCanvas
  else result:=FPickList.Canvas;
end;

function TLAComboBox.GetDropDownFont: TFont;
begin
  result:=FPickList.Font;
end;

procedure TLAComboBox.SetDropDownFont(const Value: TFont);
begin
  FPickList.Font:=Value;
end;


end.
