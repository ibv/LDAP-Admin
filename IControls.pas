  {      LDAPAdmin - IControls.pas
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

unit IControls;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
{$IFnDEF FPC}
  Windows,
{$ELSE}
  LCLIntf, LCLType, LMessages, LCLMessageGlue,
{$ENDIF}
  Controls, Messages, Classes, LDAPClasses, Grids, StdCtrls;

type

  TInplaceClass = class of TInplaceAttribute;

  TInplaceAttribute = class(TWinControl)
  private
    procedure SubClassWndProc(var Message: TMessage);
  protected
    fButtonWidth: Integer;
    fTabExit, fBackpaddle: Boolean;
    fControl: TWinControl;
    fValue: TLdapAttributeData;
    fVisible: Boolean;
    fControlVisible: Boolean;
    fRequired: Boolean;
    fSchemaTag: Boolean;
    procedure SetVisible(AValue: Boolean);
    procedure SetControlVisible(AValue: Boolean);
    procedure SetControlData(AValue: string); virtual; abstract;
    function GetControlData: string; virtual; abstract;
    function GetCellData: string; virtual;
    procedure DoExit; override;
    procedure ControlChange(Sender: TObject); virtual;
  public
    constructor Create(AOwner: TComponent; AValue: TLdapAttributeData); reintroduce; virtual;
    destructor Destroy; override;
    procedure SetFocus; override;
    function Focused: Boolean; override;
    procedure DisplayControl(const ACol, ARow: Integer); virtual;
    procedure Draw(StringGrid: TStringGrid; ACol, ARow: Integer; Rect: TRect; State: TGridDrawState); virtual;
    property Value: TLdapAttributeData read fValue;
    property CellData: string read GetCellData;
    property Visible: Boolean read fVisible write SetVisible;
    property ControlVisible: Boolean read fControlVisible write SetControlVisible;
    property Required: Boolean read fRequired write fRequired;
    property TabExit: Boolean read fTabExit write fTabExit;
    property Backpaddle: Boolean read fBackpaddle;
    property SchemaTag: Boolean read fSchemaTag write fSchemaTag;
    property OnEnter;
    property OnExit;
    property PopupMenu;
    property Enabled;
  end;

  TComboBoxEx = class(TComboBox)
  private
    fOnCloseUp: TNotifyEvent;
    fAutoComplete: Boolean;
    fCanComplete: Boolean;
    procedure CNCommand(var Message: TWMCommand); message CN_COMMAND;
    procedure SetAutoComplete(Value: Boolean);
  protected
    procedure Change; override;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
  public
    constructor Create(AOwner: TComponent); override;
    property OnCloseUp: TNotifyEvent read fOnCloseup write fOnCloseUp;
    property AutoComplete: Boolean read fAutoComplete write SetAutoComplete;
  end;

  TInplaceComboBox = class(TInplaceAttribute)
  private
    function GetControl: TComboBoxEx;
  protected
    procedure SetControlData(AValue: string); override;
    function GetControlData: string; override;
  public
    constructor Create(AOwner: TComponent; AValue: TLdapAttributeData); override;
    procedure Draw(StringGrid: TStringGrid; ACol, ARow: Integer; Rect: TRect; State: TGridDrawState); override;
    property Control: TComboBoxEx read GetControl;
  end;

  TInplaceMemo = class(TInplaceAttribute)
  private
    function GetControl: TMemo;
  protected
    procedure SetControlData(AValue: string); override;
    function GetControlData: string; override;
  public
    procedure DisplayControl(const ACol, ARow: Integer); override;
    constructor Create(AOwner: TComponent; AValue: TLdapAttributeData); override;
    property Control: TMemo read GetControl;
  end;


implementation

uses Graphics, Misc, LAControls;

{ TInplaceAttribute }

procedure TInplaceAttribute.SubClassWndProc(var Message: TMessage);
var
  KeyState: TKeyboardState;

  procedure Scroll(Down: Boolean);
  var
    Param: WPARAM;
  begin
    if not Assigned(Owner) then
      exit;
    if fControl is TMemo then
    begin
      if Down then
        Param := SB_PAGEDOWN
      else
        Param := SB_PAGEUP;
      SendMessage((Owner as TStringGrid).Handle, WM_VSCROLL, Param, 0);
    end
    else
      WndProc(Message);
  end;
  
begin
  with Message do
  case Msg of
    CM_CHILDKEY:
      if WParam = 9 then
      begin
        fTabExit := true;
        ///GetKeyboardState(KeyState);
        //MsgKeyDataToShiftState(KeyData: PtrInt);
        fBackPaddle := KeyState[VK_SHIFT] and $80 <> 0;
      end;
    CM_MOUSEWHEEL: Scroll(WParam > 0);
  else
    WndProc(Message);
  end;
end;

procedure TInplaceAttribute.SetVisible(AValue: Boolean);
begin
  fVisible := AValue;
end;

procedure TInplaceAttribute.SetControlVisible(AValue: Boolean);
begin
  fControlVisible := AVAlue;
  inherited Visible := AValue;
end;

function TInplaceAttribute.GetCellData: string;
begin
  with fValue do
  begin
    if not Assigned(Data) or (DataType = dtText) then
      Result := AsString
    else
      Result := HexMem(Data, DataSize, true);
  end;
end;

procedure TInplaceAttribute.DoExit;
begin
  with Owner as TStringGrid do
    Cells[Col, Row] := GetControlData;
  ControlVisible := false;
  inherited;
end;

procedure TInplaceAttribute.ControlChange(Sender: TObject);
begin
  if ControlVisible and Assigned(fValue) then
    fValue.AsString := GetControlData;
end;

constructor TInplaceAttribute.Create(AOwner: TComponent; AValue: TLdapAttributeData);
begin
  inherited Create(AOwner);
  WindowProc := SubClassWndProc;
  fValue := AValue;
  if Assigned(fControl) then
  begin
    fControl.Parent := Self;
    fControl.Align := alClient;
  end;
  Visible := Assigned(fControl);
  FButtonWidth := GetSystemMetrics(SM_CXVSCROLL);
end;

destructor TInplaceAttribute.Destroy;
begin
  fControl.Free;
  inherited;
end;

procedure TInplaceAttribute.Draw(StringGrid: TStringGrid; ACol, ARow: Integer; Rect: TRect; State: TGridDrawState);
begin
  with StringGrid do begin
    Canvas.TextRect(Rect, Rect.Left + 2, Rect.Top + 2, Cells[ACol, ARow]);
    if gdFocused in State then
      Canvas.DrawFocusRect(Rect);
  end;
end;

procedure TInplaceAttribute.SetFocus;
begin
  if Assigned(fControl) then
    fControl.SetFocus;
end;

function TInplaceAttribute.Focused: Boolean;
begin
  Result := inherited Focused or (fControlVisible and fControl.Focused);
end;

procedure TInplaceAttribute.DisplayControl(const ACol, ARow: Integer);
var
  Rect: TRect;
  lw: Integer;
  StringGrid: TStringGrid;
begin

  if not (Enabled and Assigned(fControl)) then Exit;

  StringGrid := Owner as TStringGrid;
  Parent := StringGrid.Parent;
  
  { In case it's triggerd by mouse down event we simulate mouse up
    because string grid is about to lose the focus to inplace control }
  ///mouse_event(MOUSEEVENTF_LEFTUP, 0, 0, 0, 0);
  LCLSendMouseDownMsg((Parent as TControl),0,0, mbLeft);

  Rect := StringGrid.CellRect(ACol, ARow);
  lw := StringGrid.GridLineWidth;
  Left := Rect.Left + StringGrid.Left + lw;
  Top := Rect.Top + StringGrid.Top + lw;
  Width := (Rect.Right + lw + lw) - Rect.Left;
  Height := (Rect.Bottom + lw + lw) - Rect.Top;

  SetControlData(StringGrid.Cells[ACol, ARow]);
  ControlVisible := True;
  SetFocus;
end;

{ TComboBoxEx }

procedure TComboBoxEx.CNCommand(var Message: TWMCommand);
begin
  inherited;
  if (Message.NotifyCode = CBN_CLOSEUP) and Assigned(fOnCloseup) then
    fOnCloseUp(Self);
end;

procedure TComboBoxEx.SetAutoComplete(Value: Boolean);
begin
  fAutoComplete := Value;
  fCanComplete := Value;
end;

procedure TComboBoxEx.Change;
var
  i, l: Integer;
begin
  inherited;

  if not fAutoComplete then Exit;
  if Text = '' then
    fCanComplete := true;
  if not fCanComplete then Exit;

  ///i := Perform(CB_FINDSTRING, 0, Cardinal(PChar(Text)));
  i := Perform($014C, 0, Cardinal(PChar(Text)));
  ///if i > CB_Err then
  if i > -1 then
  begin
    l := Length(Text);
    ItemIndex := i;
    SelStart  := l;
    SelLength := (Length(Text) - l);
  end;
end;

procedure TComboBoxEx.KeyDown(var Key: Word; Shift: TShiftState);
begin
  inherited;
  if Key in [VK_LEFT, VK_RIGHT, VK_DELETE, VK_BACK] then
    fCanComplete := false;
end;

constructor TComboBoxEx.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  AutoComplete := true;
end;

{ TInplaceComboBox }

function TInplaceComboBox.GetControl: TComboBoxEx;
begin
  Result := TComboBoxEx(fControl);
end;

procedure TInplaceComboBox.SetControlData(AValue: string);
begin
  Control.Text := AValue;
end;

function TInplaceComboBox.GetControlData: string;
begin
  Result := Control.Text;
end;

constructor TInplaceComboBox.Create(AOwner: TComponent; AValue: TLdapAttributeData);
begin
  fControl := TComboBoxEx.Create(Self);
  Control.OnChange := ControlChange;
  inherited;
end;

procedure TInplaceComboBox.Draw(StringGrid: TStringGrid; ACol, ARow: Integer; Rect: TRect; State: TGridDrawState);
var
  R: TRect;
begin
  if not Focused then
  begin
    R := Classes.Rect(Rect.Right - FButtonWidth, Rect.Top, Rect.Right, Rect.Bottom);
    Rect := Classes.Rect(Rect.Left, Rect.Top, Rect.Right - FButtonWidth, Rect.Bottom);
    with StringGrid do begin
      Canvas.Brush.Color := Control.Color;
      Canvas.Font.Color := Control.Font.Color;
      Canvas.TextRect(Rect, Rect.Left + 2, Rect.Top + 2, Cells[ACol, ARow]);
      //DrawFrameControl(Canvas.Handle, R, DFC_SCROLL, DFCS_SCROLLCOMBOBOX);
      DrawComboBtn(Canvas, R, bs_Normal);
    end;
  end;
end;

{ TInplaceMemo }

function TInplaceMemo.GetControl: TMemo;
begin
  Result := TMemo(fControl);
end;

procedure TInplaceMemo.SetControlData(AValue: string);
begin
  Control.Text := AValue;
end;

function TInplaceMemo.GetControlData: string;
begin
  Result := Control.Text;
end;

procedure TInplaceMemo.DisplayControl(const ACol, ARow: Integer);
begin
  if Assigned(fValue) and ((fValue.DataType = dtText) or (fValue.DataType = dtUnknown)) then
    inherited;
end;

constructor TInplaceMemo.Create(AOwner: TComponent; AValue: TLdapAttributeData);
begin
  fControl := TMemo.Create(Self);
  Control.OnChange := ControlChange;
  inherited;
end;

end.
