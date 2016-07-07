  {      SizeGrip.pas
  *      Copyright (C) 2013 Tihomir Karlovic
  *
  *      Based on unit SizeGrip.pas by Volker Siebert
  * ---------------------------------------------------------------------------
  *      http://flocke.vssd.de/prog/code/pascal/sizegrip/
  *      Copyright (C) 2005, 2006 Volker Siebert <flocke@vssd.de>
  *      All rights reserved.

  * Permission is hereby granted, free of charge, to any person obtaining a
  * copy of this software and associated documentation files (the "Software"),
  * to deal in the Software without restriction, including without limitation
  * the rights to use, copy, modify, merge, publish, distribute, sublicense,
  * and/or sell copies of the Software, and to permit persons to whom the
  * Software is furnished to do so, subject to the following conditions:

  * The above copyright notice and this permission notice shall be included in
  * all copies or substantial portions of the Software.

  * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
  * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
  * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
  * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
  * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
  * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
  * DEALINGS IN THE SOFTWARE.
  * ---------------------------------------------------------------------------
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

unit SizeGrip;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

//{$I VER.INC}
{$I ver.inc}

interface

uses
{$IFnDEF FPC}
  Windows,
{$ELSE}
  LCLIntf, LCLType, LMessages, Types,
{$ENDIF}
  Dialogs, Messages, SysUtils, Classes, Graphics, Controls;

type
  TSizeGripStyle = ( sgsClassic, sgsWinXP );

  TSizeGrip = class(TComponent)
  private
    FTargetControl: TWinControl;    // Target control
    FEnabled: boolean;              // Size grip enabled?
    FStyle: TSizeGripStyle;         // Display style?
    FSizeGripRect: TRect;           // Current size grip rectangle
    FOldWndProc: TWndMethod;        // Hooked window procedure
    procedure AttachControl;
    procedure DetachControl;
    procedure SetTargetControl(const Value: TWinControl);
    procedure SetEnabled(const Value: boolean);
    procedure SetNewStyle(const Value: TSizeGripStyle);
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure GetGripRect(var Rect: TRect); virtual;
    procedure PaintIt(DC: HDC; const Rect: TRect); virtual;
    procedure NewWndProc(var Msg: TMessage); virtual;
    procedure InvalidateGrip;
    procedure UpdateGrip;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property Enabled: boolean read FEnabled write SetEnabled default true;
    property TargetControl: TWinControl read FTargetControl write SetTargetControl;
    property Style: TSizeGripStyle read FStyle write SetNewStyle default sgsClassic;
  end;

implementation

{$I LdapAdmin.inc}

{$IFDEF VER_D7H}
uses
{$IFnDEF FPC}
  UxTheme,
{$ELSE}
{$ENDIF}
  Themes{$IFDEF VER_XEH}, System.Types{$ENDIF};
{$ENDIF}

type
  TWinControlAccess = class(TWinControl);

const
  CEmptyRect: TRect = ( Left: 0; Top: 0; Right: 0; Bottom: 0; );

{ TSizeGrip }

constructor TSizeGrip.Create(AOwner: TComponent);
begin
  inherited;

  FEnabled := true;
  FStyle := sgsClassic;

  if AOwner.ComponentState * [csLoading, csReading] = [] then
  begin
    // Automatically take the owner as the target control
    if AOwner is TWinControl then
      TargetControl := TWinControl(AOwner)
    else if AOwner is TControl then
      TargetControl := TControl(AOwner).Parent;
  end;
end;

destructor TSizeGrip.Destroy;
begin
  TargetControl := nil;
  inherited;
end;

procedure TSizeGrip.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited;

  if Operation = opRemove then
    if AComponent = FTargetControl then
      TargetControl := nil;
end;

{ Invalidate the current grip rectangle
}
procedure TSizeGrip.InvalidateGrip;
begin
  if (FTargetControl <> nil) and
     (FSizeGripRect.Right > FSizeGripRect.Left) and
     (FSizeGripRect.Bottom > FSizeGripRect.Top) then
    if FTargetControl.HandleAllocated then
      InvalidateRect(FTargetControl.Handle, @FSizeGripRect, TRUE);
end;

{ Update (and invalidate) the current grip rectangle
}
procedure TSizeGrip.UpdateGrip;
begin
  GetGripRect(FSizeGripRect);
  InvalidateGrip;
end;

{ Attach to FTargetControl: subclass to catch WM_SIZE, WM_ERASEBKGND and
  WM_NCHITTEST.
}
procedure TSizeGrip.AttachControl;
begin
  if @FOldWndProc = nil then
    if ([csDesigning, csDestroying] * ComponentState = []) and
       (FTargetControl <> nil) and
       FEnabled and
       ([csDesigning, csDestroying] * FTargetControl.ComponentState = []) then
    begin
      FOldWndProc := FTargetControl.WindowProc;
      FTargetControl.WindowProc := NewWndProc;
      UpdateGrip;
    end;
end;

{ Detach from FTargetControl: remove subclassing.
}
procedure TSizeGrip.DetachControl;
begin
  if @FOldWndProc <> nil then
  begin
    FTargetControl.WindowProc := FOldWndProc;
    FOldWndProc := nil;

    InvalidateGrip;
    FSizeGripRect := CEmptyRect;
  end;
end;

{ Set the target control
}
procedure TSizeGrip.SetTargetControl(const Value: TWinControl);
begin
  if Value <> FTargetControl then
  begin
    if FTargetControl <> nil then
      FTargetControl.RemoveFreeNotification(Self);

    DetachControl;
    FTargetControl := Value;
    AttachControl;

    if FTargetControl <> nil then
      FTargetControl.FreeNotification(Self);
  end;
end;

{ Toggle enabled / disabled flag
}
procedure TSizeGrip.SetEnabled(const Value: boolean);
begin
  if FEnabled <> Value then
  begin
    DetachControl;
    FEnabled := Value;
    AttachControl;
  end;
end;

{ Toggle new style flag
}
procedure TSizeGrip.SetNewStyle(const Value: TSizeGripStyle);
begin
  if FStyle <> Value then
  begin
    FStyle := Value;
    InvalidateGrip;
  end;
end;

{ The new Window procedure for the attached target control.
}
procedure TSizeGrip.NewWndProc(var Msg: TMessage);
var
  pt: TPoint;
  dc: HDC;
begin
  if (not Assigned(FOldWndProc)) or (FTargetControl = nil) then
    exit;

  case Msg.Msg of
    WM_PAINT: begin
      FOldWndProc(Msg);
      if TWMPaint(Msg).DC = 0 then
      begin
        dc := GetDC(FTargetControl.Handle);
        try
          PaintIt(dc, FSizeGripRect);
        finally
          ReleaseDC(FTargetControl.Handle, dc);
        end;
      end
    end;

    WM_NCHITTEST: begin
      with TWMNcHitTest(Msg) do
        pt := FTargetControl.ScreenToClient(Point(XPos, YPos));
      if not PtInRect(FSizeGripRect, pt) then
        FOldWndProc(TMessage(Msg))
      else if TargetControl.UseRightToLeftScrollBar then
        ///Msg.Result := HTBOTTOMLEFT
      else
        ///Msg.Result := HTBOTTOMRIGHT;
    end;

    WM_SIZE: begin
      InvalidateGrip;
      FOldWndProc(Msg);
      UpdateGrip;
    end;

    else
      FOldWndProc(Msg);
  end;
end;

{ Calculate the size grip's rectangle
}
procedure TSizeGrip.GetGripRect(var Rect: TRect);
var
  Size: TSize;
  bx: Integer;
begin
  if FTargetControl <> nil then
  begin
    Rect := FTargetControl.ClientRect;
    bx := 0;
    {$IFDEF VER_D7H}
    ///if ThemeServices.ThemesEnabled and
       ///(GetThemePartSize(ThemeServices.Theme[teStatus], 0, SP_GRIPPER, 0, nil, TS_TRUE, Size) = S_OK) then
    if ThemeServices.ThemesEnabled then
    begin
      ///if Win32MajorVersion < 6 then
        bx := GetSystemMetrics(SM_CXBORDER);
    end
    else
    {$ENDIF}
    begin
      Size.cx := GetSystemMetrics(SM_CXHSCROLL);
      size.cy := GetSystemMetrics(SM_CYVSCROLL);
    end;

    if TargetControl.UseRightToLeftScrollBar then
    begin
      Rect.Left := Rect.Left + bx;
      Rect.Right := Rect.Left + Size.cx
    end
    else begin
      Rect.Right := Rect.Right - bx;
      Rect.Left := Rect.Right - Size.cx;
    end;
    Rect.Top := Rect.Bottom - Size.cy;
  end
  else
    Rect := CEmptyRect;
end;

{ Paint the size grip
}
procedure TSizeGrip.PaintIt(DC: HDC; const Rect: TRect);
begin
  {$IFDEF VER_D7H}
  ///if ThemeServices.ThemesEnabled and
     ///(DrawThemeBackground(ThemeServices.Theme[teStatus], DC, SP_GRIPPER, 0, Rect, @Rect) = S_OK) then
  if ThemeServices.ThemesEnabled then
     exit;
  {$ENDIF}
  DrawFrameControl(DC, Rect, DFC_SCROLL, DFCS_SCROLLSIZEGRIP);
end;

end.


