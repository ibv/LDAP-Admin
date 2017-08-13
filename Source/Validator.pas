  {      LDAPAdmin - Validator.pas
  *      Copyright (C) 2016 Tihomir Karlovic
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

unit Validator;

interface

uses StdCtrls, Controls, Classes
  {$ifndef mswindows}
  , extctrls
  {$endif}
  ;

type
  TFontControl = class(TControl)
  public
    property Font;
  end;

  TCustomValidate = function(Control: TCustomEdit): Integer of object;

  TValidateInput = record
  private
    FControl:  TCustomEdit;
    FOnChange: TNotifyEvent;
    FBalloonHint: TBalloonHint;
    FInvalidChars: string;
    FCaption: string;
    //FOldValue: string;
    FCustomMessage: string;
    FUpdating: Boolean;
    FCustomValidate: TCustomValidate;
    procedure SetControlOnChange(Value: TNotifyEvent);
    function  GetControlOnChange: TNotifyEvent;
    procedure OnControlChange(Sender: TObject);
    function  ValidateText(Value: string): Boolean;
    procedure SetCaption(Value: string);
    procedure BallonHint(Msg: string);
    property  OnChange: TNotifyEvent read GetControlOnChange write SetControlOnChange;
  public
    procedure Attach(Control: TCustomEdit);
    procedure HideHint;
    property InvalidChars: string read FInvalidChars write FInvalidChars;
    property Caption: string read FCaption write SetCaption;
    property CustomValidate: TCustomValidate read FCustomValidate write FCustomValidate;
    property CustomMessage: string read FCustomMessage write FCustomMessage;
  end;


implementation

uses Windows, Constant, SysUtils, MMSystem, Misc, Graphics;

function TValidateInput.ValidateText(Value: string): Boolean;
var
  Pos: Integer;

  procedure ShowMessage;
  var
    Message: string;
    fmt: string;
  begin
    if FCustomMessage <> '' then
      Message := FCustomMessage
    else begin
      if FInvalidChars.Length > 1 then
        fmt := stInvalidChars
      else
        fmt := stInvalidChar;
      Message := Format(fmt, [FCaption, FInvalidChars]);
    end;
    BallonHint(CenterWithSpaces(TFontControl(FControl).Font, Message, 5));
    PlaySound('SYSTEMQUESTION', 0, SND_ASYNC);
  end;

  function DoCheck: Boolean;
  var
    i, Pos: Integer;
  begin
    Result := true;
    if (FInvalidChars <> '') then
    begin
    i := Length(Value);
    while i > 0 do begin
      if FInvalidChars.Contains(Value[i]) then
      begin
        Delete(Value, i, 1);
        if Result then
          Pos := i - 1;
          Result := false;
        end;
        dec(i);
      end;
    end;

    if not Result then
    begin
      FUpdating := true;
      try
        FControl.Text := Value;
        FControl.SelStart := Pos;
      finally
        FUpdating := false;
      end;
      ShowMessage;
    end;
  end;

begin
  { Custom handler }
  if Assigned(FCustomValidate) then
  begin
    try
      FUpdating := true;
      Pos := FCustomValidate(FControl);
    finally
      FUpdating := false;
    end;
    Result := Pos = 0;
    if not Result then
    begin
      ShowMessage;
      exit;
    end;
  end
  else begin
    Result := DoCheck;
    if not Result then
      exit;
  end;

  if Assigned(FBalloonHint) and FBalloonHint.ShowingHint then
    FBalloonHint.HideHint;
end;

procedure TValidateInput.SetCaption(Value: string);
begin
  FCaption := Value;
  if FCaption.EndsWith(':') then
    Delete(FCaption, FCaption.Length, 1);
end;

procedure TValidateInput.BallonHint(Msg: string);
var
  R: TRect;
begin
  if not Assigned(FControl.Parent) then
    exit;
  if not Assigned(FBalloonHint) then
  begin
    FBalloonHint := TBalloonHint.Create(FControl);
    FBalloonHint.HideAfter := 5000;
    FBalloonHint.Delay := 0;
  end;
  FBalloonHint.Description := Msg;
  R := FControl.BoundsRect;
  Inc(R.Left, GetTextExtent(Copy(FControl.Text, 1, FControl.SelStart), TFontControl(FControl).Font).cx);
  R.Width := 4;
  R.TopLeft := FControl.Parent.ClientToScreen(R.TopLeft);
  R.BottomRight := FControl.Parent.ClientToScreen(R.BottomRight);
  FBalloonHint.ShowHint(R);
end;

procedure TValidateInput.SetControlOnChange(Value: TNotifyEvent);
begin
  if FControl is TEdit then
    TEdit(FControl).OnChange := Value
  else
  if FControl is TMemo then
    TMemo(FControl).OnChange := Value;
end;

function TValidateInput.GetControlOnChange: TNotifyEvent;
begin
  if FControl is TEdit then
    Result := TEdit(FControl).OnChange
  else
  if FControl is TMemo then
    Result := TMemo(FControl).OnChange;
end;

procedure TValidateInput.OnControlChange(Sender: TObject);
begin
  if not FUpdating and ValidateText(FControl.Text) then
  begin
    if Assigned(FOnChange) then
      FOnChange(Sender);
  end;
end;

procedure TValidateInput.Attach(Control: TCustomEdit);
begin
  if Assigned(Control) then
  begin
    FControl := Control;
    FOnChange := OnChange;
    OnChange := OnControlChange;
  end;
end;

procedure TValidateInput.HideHint;
begin
  if Assigned(FBalloonHint) and FBalloonHint.ShowingHint then
    FBalloonHint.HideHint;
end;

end.
