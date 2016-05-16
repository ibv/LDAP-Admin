  {      LDAPAdmin - Sorter.pas
  *      Copyright (C) 2011-2013 Tihomir Karlovic
  *
  *      Author: Tihomir Karlovic & Alexander Sokoloff
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

unit Sorter;

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
  Grids, Controls, Classes, Graphics, ComCtrls;

type
  TLVSorterOnSort=procedure(SortColumn:  TListColumn; SortAsc: boolean) of object;

  TListViewSorter=class
  private
    FListView:      TListView;
    FSortColumn:    TListColumn;
    FSortAsc:       boolean;
    FBmp:           TBitmap;
    FOnColumnClick: TLVColumnClickEvent;
    FOnCustomDraw:  TLVCustomDrawEvent;
    FOnSort:        TLVSorterOnSort;
    procedure       SetSortMark; overload;
    procedure       SetSortMark(Column: TListColumn); overload;
    procedure       SetListView(const Value: TListView);
    procedure       DoCustomDraw(Sender: TCustomListView; const ARect: TRect; var DefaultDraw: Boolean);
    procedure       DoColumnClick(Sender: TObject; Column: TListColumn);
    procedure       DoCompare(Sender: TObject; Item1, Item2: TListItem; Data: Integer; var Compare: Integer);
  public
    constructor     Create; reintroduce;
    destructor      Destroy; override;
    property        ListView: TListView read FListView write SetListView;
    property        SortColumn:  TListColumn read FSortColumn;
    property        SortAsc: boolean read FSortAsc;
    property        OnSort: TLVSorterOnSort read FOnSort write FOnSort;
  end;

  TSGSorterOnSort = procedure(SortColumn:  Integer; SortAsc: boolean) of object;

  TStringGridSorter = class
  private
    fColDown:       Integer;
    fRowDown:       Integer;
    fSortColumn:    Integer;
    fMarkRow:       Integer;
    fSortAsc:       boolean;
    //--fOnDrawCell:    TDrawCellEvent;
    fOnMouseDown:   TMouseEvent;
    fOnMouseUp:     TMouseEvent;
    fOnMouseMove:   TMouseMoveEvent;
    fOnSort:        TSGSorterOnSort;
    fStringGrid:    TStringGrid;
    fTopFix:        Integer;
    fBottomFix:     Integer;
    procedure       SetTopRows(const Value: Integer);
    procedure       SetBottomRows(const Value: Integer);
    procedure       SetStringGrid(const Value: TStringGrid);
    procedure       DoColumnClick;
    procedure       MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure       MouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure       MouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure       DrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect; State: TGridDrawState);
    procedure       SortGrid;
  public
    constructor     Create; reintroduce;
    destructor      Destroy; override;
    property        StringGrid: TStringGrid read fStringGrid write SetStringGrid;
    property        SortColumn:  Integer read fSortColumn;
    property        SortAsc: boolean read FSortAsc;
    property        OnSort: TSGSorterOnSort read fOnSort write fOnSort;
    property        FixedTopRows: Integer read fTopFix write SetTopRows;
    property        FixedBottomRows: Integer read fBottomFix write SetBottomRows;
  end;

implementation

uses
{$IFnDEF FPC}
  CommCtrl,
{$ELSE}
{$ENDIF}
  SysUtils;

{ TListViewSorter }

constructor TListViewSorter.Create;
begin
  inherited Create;
  FSortColumn:=nil;
  FSortAsc:=true;
  FBmp:=TBitmap.Create;
  FBmp.Width:=9;
  FBmp.Height:=5;
end;

destructor TListViewSorter.Destroy;
begin
  ListView:=nil;
  FBmp.Free;
  inherited;
end;

procedure TListViewSorter.DoColumnClick(Sender: TObject; Column: TListColumn);
begin
  if FSortColumn=Column then FSortAsc:=not FSortAsc
  else FSortAsc:=true;

  FSortColumn:=Column;
  SetSortMark;
  if assigned(FOnSort) then FOnSort(FSortColumn, FSortAsc)
  else FListView.AlphaSort;
  if assigned(FOnColumnClick) then FOnColumnClick(Sender, Column);
end;

procedure TListViewSorter.DoCompare(Sender: TObject; Item1, Item2: TListItem; Data: Integer; var Compare: Integer);
begin
  Compare:=0;
  if FSortColumn=nil then exit;
  case FSortColumn.Index of
    0: Compare:=AnsiCompareStr(Item1.Caption,Item2.Caption);
    else begin
          if FSortColumn.Index>Item1.SubItems.Count then exit;
          if FSortColumn.Index>Item2.SubItems.Count then exit;
          Compare:=AnsiCompareStr(
            Item1.SubItems[FSortColumn.Index-1],
            Item2.SubItems[FSortColumn.Index-1]);
         end;
  end;
  if not FSortAsc then Compare:=-Compare;
end;

procedure TListViewSorter.DoCustomDraw(Sender: TCustomListView; const ARect: TRect; var DefaultDraw: Boolean);
begin
  SetSortMark;
  if assigned(FOnCustomDraw) then FOnCustomDraw(Sender,Arect, DefaultDraw);
end;

procedure TListViewSorter.SetListView(const Value: TListView);
begin
  if FListView<>nil then begin
    FListView.OnColumnClick:=FOnColumnClick;
    FListView.OnCustomDraw:=FOnCustomDraw;
    FListView.OnCompare:= nil;
  end;

  FListView := Value;

  if FListView=nil then exit;
  FOnColumnClick:=FListView.OnColumnClick;
  FOnCustomDraw:=FListView.OnCustomDraw;
  FListView.OnColumnClick:=DoColumnClick;
  FListView.OnCustomDraw:=DoCustomDraw;
  if not assigned(FListView.OnCompare) then FListView.OnCompare:=DoCompare;
end;

procedure TListViewSorter.SetSortMark;
var
  i: integer;
begin
  if FListView=nil then exit;
  for i:=0 to FListView.Columns.Count-1 do
    SetSortMark(FlistView.Columns[i]);
end;

procedure TListViewSorter.SetSortMark(Column: TListColumn);
begin


(*
var
 Align,hHeader: integer;
 HD: HD_ITEM;
begin
  if FListView=nil then exit;
  hHeader := SendMessage(FListView.Handle, LVM_GETHEADER, 0, 0);
  with HD do
  begin
    case Column.Alignment of
      taLeftJustify:  Align := HDF_LEFT;
      taCenter:       Align := HDF_CENTER;
      taRightJustify: Align := HDF_RIGHT;
    else
      Align := HDF_LEFT;
    end;
    mask := HDI_BITMAP or HDI_FORMAT;

    if Column=FSortColumn then begin
      with FBmp.Canvas do begin
        Brush.Color:=clBtnFace;
        FillRect(rect(0,0,Fbmp.Width,FBmp.Height));
        Brush.Color:=clBtnShadow;
        Pen.Color:=Brush.Color;
        if FSortAsc then Polygon([point(0,4),point(4,0), point(8,4)])
        else Polygon([point(0,0),point(4,4), point(8,0)]);
      end;
      hbm:=FBmp.Handle;
      fmt := HDF_STRING or HDF_BITMAP or HDF_BITMAP_ON_RIGHT;
    end
    else fmt := HDF_STRING or Align;

  end;
  SendMessage(hHeader, HDM_SETITEM, Column.Index, Integer(@HD));
*)
end;

{ TStringGridSorter }

constructor TStringGridSorter.Create;
begin
  inherited Create;
  fColDown := -1;
  fSortColumn := -1;
  fSortAsc := true;
end;

destructor TStringGridSorter.Destroy;
begin
  StringGrid := nil;
  inherited;
end;

procedure TStringGridSorter.DoColumnClick;
begin
  if fSortColumn=fColDown then fSortAsc:=not fSortAsc
  else fSortAsc:=true;

  fSortColumn:=fColDown;
  fMarkRow := fRowDown;
  if assigned(fOnSort) then
    fOnSort(fSortColumn, fSortAsc)
  else
    SortGrid;
  fColDown := -1;
end;

procedure TStringGridSorter.DrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect; State: TGridDrawState);
var
  R: TRect;

  procedure DrawSortMark(R: TRect);
  begin
    with StringGrid, Canvas do begin
      with TextExtent(Cells[ACol, ARow]) do
      begin
        R.Top := R.Top + 6;
        R.Left := R.Left + cx + 12;
        R.Right := R.Left + 9;
      end;
      Brush.Color:=clBtnShadow;
      Pen.Color:=Brush.Color;
      if FSortAsc then
        Polygon([point(R.Left, R.Top + 4), point(R.Left + 4, R.Top), point(R.Left + 8, R.Top + 4)])
      else
        Polygon([Point(R.Left, R.Top), point(R.Left + 4, R.Top + 4), point(R.Left + 8, R.Top)]);
    end;
  end;

begin

  //--if assigned(FOnDrawCell) then fOnDrawCell(Sender, ACol, ARow, Rect, State);

  with TStringGrid(Sender) do
  begin
    R := Rect;
    if (ACol = fColDown) then
    begin
      //--if (gdFixed in State) and Ctl3D then
      if (gdFixed in State) then
      begin
        Canvas.Brush.Color := FixedColor;
        Canvas.Font.Color := clWindowText;
        FillRect(Canvas.Handle, Rect, Canvas.Brush.Handle);
        DrawEdge(Canvas.Handle, R, BDR_SUNKENINNER, BF_TOPLEFT);              { black     }
        DrawEdge(Canvas.Handle, R, BDR_SUNKENOUTER, BF_BOTTOMRIGHT);          { btnhilite }
        Dec(R.Bottom);
        Dec(R.Right);
        Inc(R.Top);
        Inc(R.Left);
        DrawEdge(Canvas.Handle, R, BDR_SUNKENINNER, BF_BOTTOM or BF_TOP or BF_RIGHT or BF_LEFT);
        Inc(R.Top, GridLineWidth);
        Inc(R.Left, GridLineWidth);
        Dec(R.Right, GridLineWidth);
        Dec(R.Bottom, GridLineWidth);
        Canvas.TextRect(R, R.Left + 1, R.Top + 1, Cells[ACol, ARow]);
      end;
    end;

    if (ACol = fSortColumn) and (ARow = fMarkRow) then
      DrawSortMark(R);
  end;

end;

procedure TStringGridSorter.MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  ACol, ARow: Integer;
begin
  if ssLeft in Shift then with Sender as TStringGrid do
  begin
    If GetCapture = 0 then
      SetCapture(StringGrid.Handle) ;
    MouseToCell(X, Y, ACol, ARow);
    if (ARow >= 0) and (ARow < FixedRows) and (ACol >= 0) and (ACol < ColCount) then
    begin
        fColDown := ACol;
        fRowDown := ARow;
        Repaint;
    end;
  end;
  if Assigned(fOnMouseDown) then fOnMouseDown(Sender, Button, Shift, X, Y);
end;

procedure TStringGridSorter.MouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if fColDown <> -1 then
  begin
    ReleaseCapture;
    DoColumnClick;
    StringGrid.Repaint;
  end;
  if Assigned(fOnMouseUp) then fOnMouseUp(Sender, Button, Shift, X, Y);
end;

procedure TStringGridSorter.MouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
var
  ACol, ARow: Integer;
begin
  if (ssLeft in Shift) and (fColDown <> -1) then with StringGrid do
  begin
    if PtInRect(Rect(0, 0, Width, Height), Point(x, y)) then
    begin
      MouseToCell(X, Y, ACol, ARow);
      if (ACol <> fColDown) or (ARow <> fRowDown) then
      begin
        fColDown := -1;
        ReleaseCapture;
        Repaint;
      end;
    end
    else begin
      fColDown := -1;
      ReleaseCapture;
      Repaint;
    end;
  end;
  if Assigned(fOnMouseMove) then fOnMouseMove(Sender, Shift, X, Y);
end;

procedure TStringGridSorter.SetTopRows(const Value: Integer);
begin
  if Value < 0 then
    fTopFix := 0
  else
    fTopFix := Value;
end;

procedure TStringGridSorter.SetBottomRows(const Value: Integer);
begin
  with StringGrid do
  if Value > RowCount then
    fBottomFix := RowCount
  else
    fBottomFix := Value;
end;

procedure TStringGridSorter.SetStringGrid(const Value: TStringGrid);
begin
  if fStringGrid <> nil then
  begin
    fStringGrid.OnMouseDown := fOnMouseDown;
    fStringGrid.OnMouseUp := fOnMouseUp;
    fStringGrid.OnMouseMove := fOnMouseMove;
    //--fStringGrid.OnDrawCell := fOnDrawCell;
  end;

  fStringGrid := Value;

  if not Assigned(fStringGrid) then exit;

  fOnMouseDown := fStringGrid.OnMouseDown;
  fOnMouseUp := fStringGrid.OnMouseUp;
  fOnMouseMove := fStringGrid.OnMouseMove;
  //--fOnDrawCell := fStringGrid.OnDrawCell;
  fStringGrid.OnMouseDown := MouseDown;
  fStringGrid.OnMouseUp := MouseUp;
  fStringGrid.OnMouseMove := MouseMove;
  fStringGrid.OnDrawCell := DrawCell;
end;

procedure TStringGridSorter.SortGrid;

  procedure QuickSort(Left, Right: Integer; S: TStrings);
   var
    i, j, n: Integer;
    Pivot: string;

    function SCompare(const S1, S2: string): Integer;
    begin
      Result := AnsiCompareStr(S1, S2);
      if not fSortAsc then Result := -Result;
    end;

  begin
    i := Left;
    j := Right;
    Pivot := S[(i + j) shr 1];
    repeat
      while SCompare(S[i], Pivot) < 0 do Inc(i);
      while SCompare(S[j], Pivot) > 0 do Dec(j);
      if i <= j then
      begin
        with StringGrid do
          for n := 0 to ColCount - 1 do
            Cols[n].Exchange(i, j);
        Inc(i);
        Dec(j);
      end;
    until i > j;
    if j > Left then QuickSort(Left, j, S);
    if i < Right then QuickSort(i, Right, S);
  end;

begin
  with StringGrid do
  begin
    QuickSort(FixedRows + fTopFix, RowCount - fBottomFix - 1, Cols[fSortColumn]);
    Repaint;
  end;
end;

end.
