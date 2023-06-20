  {      LDAPAdmin - uBetaImgLists.pas
  *      Copyright (C) 2007 Alexander Sokoloff
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

unit uBetaImgLists;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses ImgList, Controls, Graphics, classes;

type
  TBetaDisabledImageList=class(TImageList)
  private
    FMasterImages: TCustomImageList;
    FMask:    TBitmap;
    FImg:     TBitmap;
    procedure SetMasterImages(const Value: TCustomImageList);
    function CreateBitmap(MasterImage: integer): TBitmap;
  public
    property  MasterImages: TCustomImageList read FMasterImages write SetMasterImages;
  end;

implementation

uses
{$IFnDEF FPC}
  commctrl,
{$ELSE}
{$ENDIF}
  SysUtils;


const
     CLR_NONE    = $1fffffff;
     CLR_DEFAULT = $20000000;

{ TDisabledImageList }

procedure TBetaDisabledImageList.SetMasterImages(const Value: TCustomImageList);
var
  i: integer;
begin
  if FMasterImages=Value then exit;

  if FMask=nil then FMask:=TBitmap.Create;
  if FImg=nil then  FImg:=TBitmap.Create;

  FMasterImages := Value;
  Clear;
  Width:=FMasterImages.Width;
  Height:=FMasterImages.Height;
  FMask.Width:=Width;
  FMask.Height:=Height;
  FImg.Width:=Width;
  FImg.Height:=Height;

  for i:=0 to MasterImages.Count-1 do begin
    self.AddMasked(CreateBitmap(i), clFuchsia);
  end;
end;

function GetRGBColor(Value: TColor): Cardinal;
begin
  Result := ColorToRGB(Value);
  case Result of
    clNone: Result := CLR_NONE;
    clDefault: Result := CLR_DEFAULT;
  end;
end;

function GetColor(Value: Cardinal): TColor;
begin
  case Value of
    CLR_NONE: Result := clNone;
    CLR_DEFAULT: Result := clDefault;
  else
    Result := TColor(Value);
  end;
end;

function TBetaDisabledImageList.CreateBitmap(MasterImage: integer): TBitmap;
const
  RMASK= $000000FF;
  GMASK= $0000FF00;
  BMASK= $00FF0000;
  RC=0.299;
  GC=0.587;
  BC=0.114;
var
  X, Y: integer;
  Bright: byte;
  BgR, BgG, BgB: LongWord;
  Color: TColor;
begin
  result:=Fimg;
  result.Canvas.Brush.Color:=clFuchsia;
  result.Canvas.FillRect(rect(0,0,Width, Height));

  FMask.Canvas.FillRect(rect(0,0,Width, Height));
  FMasterImages.Draw(FMask.Canvas,  0,0, MasterImage, true);

  BgR:=(ColorToRGB(clBtnFace) and RMASK);
  BgG:=(ColorToRGB(clBtnFace) and GMASK) shr 8;
  BgB:=(ColorToRGB(clBtnFace) and BMASK) shr 16;

  for y:=0 to result.Height-1 do begin
    for X:=0 to result.Width-1 do begin
      if (FMask.Canvas.Pixels[X,Y]=FMask.TransparentColor) or
         (FMask.Canvas.Pixels[X,Y]=clWhite) then
        continue;
      Color:=FMask.Canvas.Pixels[X,Y];
      Bright:=round((Color and RMASK) * RC)+(round((Color and GMASK) * GC) shr 8) + (round((Color and BMASK) * BC) shr 16);
      result.Canvas.Pixels[X,Y]:=(Bright + BgR) div 2  +((Bright + BgG) div 2) shl 8 + ((bright + BgB) div 2) shl 16;
    end;
  end;
end;

end.
