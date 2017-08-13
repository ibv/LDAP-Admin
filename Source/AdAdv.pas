  {      LDAPAdmin - AdAdv.pas
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

unit AdAdv;

interface

uses
  {$ifdef mswindows}
  Windows, Vcl.Grids, System.UITypes,
  {$else}
  LCLIntf, LCLType,
  {$endif}
  Grids,
  SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ExtCtrls, ComCtrls, LdapClasses, ImgList ;

type
  Tb24 = packed record
    Bytes: array[0..2] of Byte;
  end;

  PLoginTime = ^TLoginTime;
  TLoginTime = record
    Days: array[1..7] of Tb24;
  end;

  TAdAdvancedDlg = class(TForm)
    OKBtn: TButton;
    CancelBtn: TButton;
    ImageList1: TImageList;
    PageControl: TPageControl;
    TabSheet1: TTabSheet;
    wsList: TListView;
    RemoveBtn: TButton;
    AddBtn: TButton;
    Label1: TLabel;
    TabSheet2: TTabSheet;
    TimeGrid: TStringGrid;
    TimeScale: TImage;
    Label2: TLabel;
    Label4: TLabel;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure AddBtnClick(Sender: TObject);
    procedure RemoveBtnClick(Sender: TObject);
    procedure wsListSelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure TimeGridDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure TimeGridSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure TimeGridFixedCellClick(Sender: TObject; ACol, ARow: Integer);
    procedure TimeGridMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure PageControlChange(Sender: TObject);
    procedure TimeGridMouseLeave(Sender: TObject);
  private
    FEntry: TLdapEntry;
    LTAttr: TLdapAttribute;
    LoginTime: TLoginTime;
    TzBias: Integer;
    procedure DisplayCellStatus(ACol, ARow: Integer);
    procedure Skew(var DayOfWeek, Hour: Integer);
    function  IsLoginAllowed(DayOfWeek, Hour: Integer): Boolean;
    procedure ToggleAllowed(DayOfWeek, Hour: Integer);
    procedure SetAllowed(DayOfWeek, Hour: Integer; Value: Boolean);
    procedure InitLoginTime;
    procedure DoCell(ACol, ARow: Integer);
  public
    constructor Create(AOwner: TComponent; Entry: TLdapEntry); reintroduce;
  end;

var
  AdAdvancedDlg: TAdAdvancedDlg;

implementation

uses Pickup, Main, Misc, Constant, DateUtils;

{$R *.dfm}

procedure TAdAdvancedDlg.DisplayCellStatus(ACol, ARow: Integer);
begin
  with TimeGrid do begin
    if (ACol >= FixedCols) and (ARow >= FixedRows) then
      Label2.Caption := Format('%s from %d:00 to %d:00', [TimeGrid.Cells[0, ARow], ACol - 1, ACol]);
  end;
end;

// Valid for |TzBias| < 24;
procedure TAdAdvancedDlg.Skew(var DayOfWeek, Hour: Integer);
begin
  Dec(Hour);  // need it 0-based
  Hour := Hour + TzBias;
  if Hour > 23 then
  begin
    Hour := Hour - 23;
    Inc(DayOfWeek);
    if DayOfWeek = 8 then
      DayOfWeek := 1;
  end
  else
  if Hour < 0 then
  begin
    Hour := 24 + Hour;
    Dec(DayOfWeek);
    if DayOfWeek = 0 then
      DayOfWeek := 7;
  end;
  { TLoginTime is SMTWTFS, DayOfWeek is MTWTFSS - adjust DayOfWeek accordingly }
  Inc(DayOfWeek);
  if DayOfWeek = 8 then
    DayOfWeek := 1;
end;

{ Hour: 1 - 24, DayOfWeek: 1 - 7 }
function TAdAdvancedDlg.IsLoginAllowed(DayOfWeek, Hour: Integer): Boolean;
var
  ByteIndex, BitIndex: Integer;
  val: Integer;
begin
  Skew(DayOfWeek, Hour);
  ByteIndex := Hour shr 3;
  val := LoginTime.Days[DayOfWeek].Bytes[ByteIndex];
  BitIndex := Hour and 7;
  val := val shr BitIndex;
  Result := val and 1 <> 0;
end;

procedure TAdAdvancedDlg.PageControlChange(Sender: TObject);
begin
  if not Assigned(LTAttr) and (PageControl.ActivePageIndex = 1) then
    InitLoginTime;
end;

{ Hour: 1 - 24, DayOfWeek: 1 - 7 }
procedure TAdAdvancedDlg.ToggleAllowed(DayOfWeek, Hour: Integer);
var
  ByteIndex, BitIndex: Integer;
  val, mask: Integer;
begin
  Skew(DayOfWeek, Hour);

  ByteIndex := Hour shr 3;
  BitIndex := Hour and 7;
  mask := 1;
  mask := mask shl BitIndex;
  val := LoginTime.Days[DayOfWeek].Bytes[ByteIndex];
  val := val xor mask;
  LoginTime.Days[DayOfWeek].Bytes[ByteIndex] := val;
end;


{ Hour: 1 - 24, DayOfWeek: 1 - 7 }
procedure TAdAdvancedDlg.SetAllowed(DayOfWeek, Hour: Integer; Value: Boolean);
var
  ByteIndex, BitIndex: Integer;
  val, mask: Integer;
begin
  Skew(DayOfWeek, Hour);

  ByteIndex := Hour shr 3;
  BitIndex := Hour and 7;
  mask := 1;
  mask := mask shl BitIndex;
  val := LoginTime.Days[DayOfWeek].Bytes[ByteIndex];
  if Value then  
    val := val or mask
  else
    val := val and not mask;
  LoginTime.Days[DayOfWeek].Bytes[ByteIndex] := val;
end;

procedure TAdAdvancedDlg.DoCell(ACol, ARow: Integer);
begin
  {$ifdef mswindows}
  if GetAsyncKeyState(VK_LCONTROL) < 0 then
  {$else}
  if GetKeyState(VK_LCONTROL)  < 0 then
  {$endif}
    SetAllowed(ARow, ACol, true)
  else
  {$ifdef mswindows}
  if GetAsyncKeyState(VK_LSHIFT) < 0 then
  {$else}
  if GetKeyState(VK_LSHIFT)  < 0 then
  {$endif}
    SetAllowed(ARow, ACol, false)
  else
    ToggleAllowed(ARow, ACol);
end;

procedure TAdAdvancedDlg.InitLoginTime;
var
  i, tp, te: Integer;
  s: string;
  ///tzi: TTimeZoneInformation;
  err: DWORD;
begin
  { Get time zone bias. This bias does not change with Daylight Savings Time. }
  ///fillchar(tzi, 0, SizeOf(tzi));
  ///err := GetTimeZoneInformation(tzi);
  ///if (err <> TIME_ZONE_ID_UNKNOWN) and (err <> TIME_ZONE_ID_INVALID) then
  ///  TzBias := tzi.Bias div 60;

  LTAttr := FEntry.AttributesByName['logonHours'];
  with LTAttr do
    if ValueCount > 0 then
      LoginTime := PLoginTime(Values[0].Data)^
    else
      FillChar(LoginTime, SizeOf(LoginTime), $FF);

  { Setup grid }
  with TimeGrid do begin
    ColWidths[0] := Width - 2 * 1 {BevelWidth} - 24 * (DefaultColWidth + GridLineWidth) - 2 * GridLineWidth;
    for i := 1 to 6 do
      Cells[0, i] := FormatSettings.LongDayNames[i + 1];
    Cells[0, 7] := FormatSettings.LongDayNames[1];
    { Print hours }
    tp := ColWidths[0] + GridLineWidth + 1 {BevelWidth};
    i := 0;
    while i < 25 do
    begin
      s := IntToStr(i);
      te := TimeScale.Canvas.TextExtent(s).cx div 2;
      TimeScale.Canvas.TextOut(tp - te, 1, s);
      tp := tp + 2 * (DefaultColWidth + GridLineWidth);
      inc(i, 2);
    end;
  end;

end;

constructor TAdAdvancedDlg.Create(AOwner: TComponent; Entry: TLdapEntry);
var
  sl: TStringList;
  i: Integer;
begin
  inherited Create(AOwner);
  FEntry := Entry;

  sl := TStringList.Create;
  try
    sl.CommaText := Entry.AttributesByName['userWorkstations'].AsString;
    for i := 0 to sl.Count - 1 do
      wsList.Items.Add.Caption := sl[i];
  finally
    sl.Free;
  end;
end;

procedure TAdAdvancedDlg.FormClose(Sender: TObject; var Action: TCloseAction);
var
  i: Integer;
  s: string;
  ltVal: TLdapAttributeData;

  function NoTimeConstrains: Boolean;
  var
    i: Integer;
    pb: PByteArray;
  begin
    Result := false;
    pb := @LoginTime;
    for i := 0 to 20 do
         if pb[i] <> $FF then
           exit;
    Result := true;
  end;

begin
  if ModalResult = mrOk then
  begin

    { Workstations }
    s := '';
    for i := 0 to wsList.Items.Count - 1 do
    begin
      if s <> '' then s := s + ',';
      s := s + wsList.Items[i].Caption;
    end;
    FEntry.AttributesByName['userWorkstations'].AsString := s;

    { Logon hours }
    if Assigned(ltAttr) then
    begin
      if NoTimeConstrains then
        ltAttr.Delete
      else begin
        if ltAttr.ValueCount > 0 then
          ltVal := ltAttr.Values[0]
        else
          ltVal := ltAttr.AddValue;
        ltVal.SetData(@LoginTime, SizeOf(LoginTime));
      end;
    end;
  end;

  Action := caFree;
end;

procedure TAdAdvancedDlg.AddBtnClick(Sender: TObject);
var
  i: integer;
  wsname: string;

  function IsPresent(S: string): boolean;
  var
    i: integer;
  begin
    s:=AnsiUpperCase(S);
    result:=true;
    for i:=0 to wsList.Items.Count-1 do
      if AnsiUpperCase(wsList.Items[i].Caption)=S then exit;
    result:=false;
  end;

begin
  with TPickupDlg.Create(self) do
  try
    Screen.Cursor := crHourGlass;
    Caption := cPickAccounts;
    ColumnNames := cColumnNames;
    Populate(FEntry.Session, sADCOMPUTERS, ['cn', PSEUDOATTR_DN]);
    Images := MainFrm.ImageList;
    ImageIndex := bmComputer;
    ShowModal;

    for i:=0 to SelCount-1 do
    begin
      wsname := Selected[i].AttributesByName['cn'].AsString;
      if not IsPresent(wsname) then
        wsList.Items.Add.Caption := wsname;
    end;
  finally
    Screen.Cursor := crDefault;
    Free;
  end;
  RemoveBtn.Enabled:=wsList.Items.Count > 0;
end;

procedure TAdAdvancedDlg.RemoveBtnClick(Sender: TObject);
var
  SelItem, DelItem: TListItem;
begin
  with wsList do
  begin
    SelItem := Selected;
    while Assigned(SelItem) do
    begin
      DelItem := SelItem;
      SelItem := GetNextItem(SelItem, sdAll, [lisSelected]);
      DelItem.Delete;
    end;
  end;
  if wsList.Items.Count = 0 then
    RemoveBtn.Enabled := false;
end;

procedure TAdAdvancedDlg.TimeGridDrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
var
  bc: TColor;
begin
  with TStringGrid(Sender) do
  if (ACol > FixedCols - 1) and (ARow > FixedRows - 1) and 
      IsLoginAllowed(ARow, ACol) then
  begin
    Rect.Left := Rect.Left - (DefaultColWidth - (abs(Rect.Left-Rect.Right) {.Width}));
    bc := Canvas.Brush.Color;
    Canvas.Brush.Color := clBlue;
    Canvas.FillRect(Rect);
    Canvas.Brush.Color := bc;
  end;
end;

procedure TAdAdvancedDlg.TimeGridFixedCellClick(Sender: TObject; ACol,
  ARow: Integer);
var
  i: Integer;

  procedure DoRow(ARow: Integer);
  var
    i: Integer;
  begin
    for i := 1 to 24 do
      DoCell(i, Arow);
  end;

  procedure DoCol(ACol: Integer);
  var
    i: Integer;
  begin
    for i := 1 to 7 do
      DoCell(ACol, i);
  end;

begin
  if ACol = 0 then
  begin  
    if ARow = 0 then
    begin
      for i := 1 to 7 do
        DoRow(i);      
    end
    else
      DoRow(ARow);
  end
  else
  if ARow = 0 then  
    DoCol(ACol);
  TimeGrid.Repaint;
end;

procedure TAdAdvancedDlg.TimeGridMouseLeave(Sender: TObject);
begin
  Label2.Caption := '';
end;

procedure TAdAdvancedDlg.TimeGridMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
var
  aCol, aRow: Integer;
begin
  with TimeGrid do begin
    MouseToCell(X, Y, aCol, aRow);
    DisplayCellStatus(aCol, aRow);
  end;
end;

procedure TAdAdvancedDlg.TimeGridSelectCell(Sender: TObject; ACol,
  ARow: Integer; var CanSelect: Boolean);
begin
  DisplayCellStatus(ACol, ARow);
  {$ifdef mswindos}
  if (GetAsyncKeyState(VK_LBUTTON) < 0) or (GetAsyncKeyState(VK_RBUTTON) < 0) then // it was due to mouse click
  {$else}
  if (GetKeyState(VK_LBUTTON) < 0) or (GetKeyState(VK_RBUTTON) < 0) then // it was due to mouse click
  {$endif}
    DoCell(ACol, ARow);
end;

procedure TAdAdvancedDlg.wsListSelectItem(Sender: TObject; Item: TListItem; Selected: Boolean);
begin
  RemoveBtn.Enabled := Assigned(wsList.Selected);
end;

end.
