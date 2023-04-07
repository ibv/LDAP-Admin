  {      LDAPAdmin - BinView.pas
  *      Copyright (C) 2005 Tihomir Karlovic
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

unit BinView;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
  LCLIntf, LCLType, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, Grids, StdCtrls, Menus, mormot.core.base;

const
  scTopRow           = 0;
  scVisibleRows      = 22;

type
  THexView = class(TForm)
    HexGrid: TStringGrid;
    Panel1: TPanel;
    CharGrid: TStringGrid;
    ScrollBar1: TScrollBar;
    Label1: TLabel;
    ValueLabel: TLabel;
    Label3: TLabel;
    BinaryLabel: TLabel;
    Label2: TLabel;
    AddressLabel: TLabel;
    Bevel1: TBevel;
    Button2: TButton;
    PopupMenu: TPopupMenu;
    pbHex: TMenuItem;
    pbDecimal: TMenuItem;
    Label4: TLabel;
    SizeLabel: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure CharGridSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure HexGridSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure ScrollBar1Change(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Button2Click(Sender: TObject);
    procedure HexGridMouseWheelUp(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
    procedure HexGridMouseWheelDown(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
    procedure pbHexClick(Sender: TObject);
  private
    fMemory: TMemoryStream;
    fUpdatingPos: Boolean;
    LastRow: Integer;
    DecimalView: Boolean;
    procedure ShowMemoryWindow;
    procedure ShowCellStatus(const ACol, ARow: Integer);
  public
    procedure LoadFromStream(Stream: TStream);
  end;

var
  HexView: THexView;

implementation

uses Constant;

{$R *.dfm}


procedure THexView.ShowMemoryWindow;
var
  i, j, MemBase, CurOffset: Integer;
  Value: ^Byte;
  nr: integer;
  s: UnicodeString;
  digit:integer;
begin
  MemBase := Cardinal(fMemory.Memory);
  if MemBase = 0 then
    Exit;
  SetString(s, PAnsiChar(fMemory.Memory), fMemory.Size);
  CurOffset :=  ScrollBar1.Position * 16;
  for j := scTopRow to scTopRow + scVisibleRows - 1 do
  begin
    HexGrid.Cells[0, j] := IntTohex(CurOffset, 8);
    for i := 0 to 15 do
    begin
      if CurOffset < fMemory.Size then
      begin
        digit:=2;
        Value := Pointer(MemBase + CurOffset);
        nr :=  Value^;
        if Value^ and $80 = $80 then
        begin
          nr := nr shl 8;
          inc(CurOffset);
          Value := Pointer(MemBase + CurOffset);
          if Value^ = $0 then continue;
          nr:=nr+Value^;
          HexGrid.ColWidths[i+1]:=34;
          digit:=4;
        end;
        if DecimalView then
          HexGrid.Cells[i + 1, j] := Format('%3d', [nr])
        else
          HexGrid.Cells[i + 1, j] := IntToHex(nr, digit);
        ///CharGrid.Cells[i, j] := Char(Value^)
        CharGrid.Cells[i,j] := {UTF8Encode}(s[I+1+j*16]);
      end
      else
      begin
        HexGrid.Cells[i + 1, j] := '';
        CharGrid.Cells[i, j] := '';
      end;
      inc(CurOffset);
    end;
  end;
end;

procedure THexView.ShowCellStatus(const ACol, ARow: Integer);
var
  Offset: Cardinal;
  Value: Byte;

  function Bin(x: Byte): RawUtf8;
  var
    i: Integer;
  begin
    SetLength(Result, 8);
    for i := 1 to 8 do
    begin
      if x and $80 <> 0 then
        Result[i] := '1'
      else
        Result[i] := '0';
      x := x shl 1;
    end;
  end;

begin
  Offset := (ScrollBar1.Position + ARow) * 16 + ACol - 1;
  if Offset + 1 > Cardinal(fMemory.Size) then
  begin
    {AddressLabel.Caption := '';
    ValueLabel.Caption := '';
    BinaryLabel.Caption := '';}
    Exit;
  end;
  AddressLabel.Caption := IntToHex(Offset, 8);
  Value := PByte(Cardinal(fMemory.Memory) + Offset)^;
  if DecimalView then
    ValueLabel.Caption := IntToHex(Value, 2)
  else
    ValueLabel.Caption := IntToStr(Value);
  BinaryLabel.Caption := Bin(Value);
end;

procedure THexView.FormCreate(Sender: TObject);
begin
  fMemory := TMemoryStream.Create;
  HexGrid.ColWidths[0] := 68;
  CharGrid.Row := scTopRow;
  CharGrid.TopRow := scTopRow;
end;

procedure THexView.FormDestroy(Sender: TObject);
begin
  fMemory.Free;
end;

procedure THexView.CharGridSelectCell(Sender: TObject; ACol,
  ARow: Integer; var CanSelect: Boolean);
begin
  if CharGrid.Focused then
  with HexGrid do
  begin
    if Cells[ACol + 1, ARow] = '' then
      Abort;
    fUpdatingPos := true;
    Row := ARow;
    fUpdatingPos := false;
    Col := ACol + 1;
  end;
end;

procedure THexView.HexGridSelectCell(Sender: TObject; ACol, ARow: Integer; var CanSelect: Boolean);
begin
  if not fUpdatingPos and (HexGrid.Cells[ACol, ARow] = '') then Abort;
  if HexGrid.Focused then
  with CharGrid do
  begin
    Row := ARow;
    Col := ACol - 1;
  end;
  ShowCellStatus(ACol, ARow);
end;

procedure THexView.ScrollBar1Change(Sender: TObject);
begin
  ShowMemoryWindow;
  ShowCellStatus(HexGrid.Col, HexGrid.Row);
end;

procedure THexView.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  with ScrollBar1 do
  case Key of
    VK_UP:     begin
                 Position := Position - 1;
                 Key := 0;
               end;
    VK_DOWN:   begin
                 Position := Position + 1;
                 Key := 0;
               end;
    VK_PRIOR:   begin
                 if (ssCtrl in Shift) then
                   Position := 0
                 else
                   Position := Position - PageSize;
                 Key := 0;
               end;
    VK_NEXT:   begin
                 if (ssCtrl in Shift) then
                   Position := Max
                 else
                   Position := Position + PageSize;
                 Key := 0;
               end;
  end;
end;

procedure THexView.Button2Click(Sender: TObject);
begin
  Close;
end;

procedure THexView.HexGridMouseWheelUp(Sender: TObject; Shift: TShiftState; MousePos: TPoint; var Handled: Boolean);
begin
  ScrollBar1.Position := ScrollBar1.Position - 1;
  Handled := true;
end;

procedure THexView.HexGridMouseWheelDown(Sender: TObject; Shift: TShiftState; MousePos: TPoint; var Handled: Boolean);
begin
  ScrollBar1.Position := ScrollBar1.Position + 1;
  Handled := true;
end;

procedure THexView.pbHexClick(Sender: TObject);
begin
  DecimalView := not pbDecimal.Checked;
  pbHex.Checked := not DecimalView;
  pbDecimal.Checked := DecimalView;
  if DecimalView then
    Label1.Caption := cHex
  else
    Label1.Caption := cDecimal;
  ShowCellStatus(HexGrid.Col, HexGrid.Row);
  ShowMemoryWindow;
end;

procedure THexView.LoadFromStream(Stream: TStream);
var
  TrackHeight: integer;
  MinHeight: integer;
begin
  fMemory.LoadFromStream(Stream);
  LastRow := (fMemory.Size div 16);
  if fMemory.Size mod 16 > 0 then
    inc(LastRow);
  if LastRow = 0 then
    Exit;
  with ScrollBar1 do
  begin
    Max := LastRow - 1;
    Position := 0;
    MinHeight := GetSystemMetrics(SM_CYVTHUMB);
    TrackHeight := ClientHeight - 2 * GetSystemMetrics(SM_CYVSCROLL);
    PageSize := TrackHeight div (Max - Min + 1);
    if PageSize < MinHeight then PageSize := MinHeight;
  end;
  HexGrid.Row := 0;
  HexGrid.Col := 1;
  CharGrid.Row := 0;
  CharGrid.Col := 0;
  ShowMemoryWindow;
  SizeLabel.Caption := IntToStr(fMemory.Size) + ' Byte';
  ShowCellStatus(1, 0);
end;

end.
