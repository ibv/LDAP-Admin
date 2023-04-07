  {      LDAPAdmin - GraphicHint.pas
  *      Copyright (C) 2012 Tihomir Karlovic
  *
  *      Author: Tihomir Karlovic
  *
  * Based on code by Horst Kniebusch published on SwissDelphiCenter.ch
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

unit GraphicHint;

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
  Controls, Classes, Graphics, Forms;

type
  TGraphicHintWindow = class(THintWindow)
    constructor Create(AOwner: TComponent); override;
  private
    FInheritedPaint: Boolean;
    FBitmap: TBitmap;
  public
    procedure ActivateHint(Rect: TRect; const AHint: String); override;
  protected
    procedure Paint; override;
  public
    destructor Destroy; override;
  published
    property Caption;
  end;

implementation

uses
{$IFnDEF FPC}
  jpeg,
{$ELSE}
{$ENDIF}
  SysUtils, LDAPClasses, Misc;

constructor TGraphicHintWindow.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FBitmap := TBitmap.Create;
end;

procedure TGraphicHintWindow.Paint;
begin
  if FInheritedPaint then
    inherited
  else
  with Canvas do begin
    //Rectangle(0, 0, FBitmap.Width, FBitmap.Height);
    StretchDraw(ClientRect, FBitmap);
  end;
end;

procedure TGraphicHintWindow.ActivateHint(Rect: TRect; const AHint: String);
var
  h: Integer;
  Value: TLdapAttributeData;
  ji: TJpegImage;
begin
  Caption := AHint;
  if Copy(AHint, 1, 22) <> 'TLdapAttributeDataPtr:' then
  begin
    FInheritedPaint := true;
    OffsetRect(Rect, Mouse.CursorPos.X - Rect.Right, Mouse.CursorPos.Y - Rect.Bottom);
    inherited;
    exit;
  end;
  FInheritedPaint := false;
  Value := Pointer(StrToInt(Copy(AHint, 23, 255)));
  //if Value.DataType = dtJpeg then
  ji := TJpegImage.Create;
  try
    StreamCopy(Value.SaveToStream, ji.LoadFromStream);
    FBitmap.Assign(ji);
    h := Round(FBitmap.Height / FBitmap.Width * 128);
    Rect.TopLeft := Mouse.CursorPos;
    Rect.Right := Rect.Left + 128;
    Rect.Bottom := Rect.Top;
    Rect.Top := Rect.Top - h;
    ///UpdateBoundsRect(Rect);
    if Rect.Top + Height > Screen.DesktopHeight then
      Rect.Top := Screen.DesktopHeight - Height;
    if Rect.Left + Width > Screen.DesktopWidth then
      Rect.Left := Screen.DesktopWidth - Width;
    if Rect.Left < Screen.DesktopLeft then Rect.Left := Screen.DesktopLeft;
    if Rect.Bottom < Screen.DesktopTop then Rect.Bottom := Screen.DesktopTop;
    SetWindowPos(Handle, HWND_TOPMOST, Rect.Left, Rect.Top, Width, Height,
      SWP_SHOWWINDOW or SWP_NOACTIVATE);
    Invalidate;
  except
  end;
  ji.Free;
end;

destructor TGraphicHintWindow.Destroy;
begin
  FBitmap.Free;
  inherited;
end;

end.
