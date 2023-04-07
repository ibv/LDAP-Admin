  {      LDAPAdmin - PickAttr.pas
  *      Copyright (C) 2006 Tihomir Karlovic
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

unit PickAttr;

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
  SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ExtCtrls, CheckLst, Schema, mormot.core.base;

const
  LB_ERR = -1;

type
  TPickAttributesDlg = class(TForm)
    OKBtn: TButton;
    CancelBtn: TButton;
    SrcLabel: TLabel;
    DstLabel: TLabel;
    IncludeBtn: TSpeedButton;
    IncAllBtn: TSpeedButton;
    ExcludeBtn: TSpeedButton;
    ExAllBtn: TSpeedButton;
    SrcList: TListBox;
    DstList: TListBox;
    procedure IncludeBtnClick(Sender: TObject);
    procedure ExcludeBtnClick(Sender: TObject);
    procedure IncAllBtnClick(Sender: TObject);
    procedure ExcAllBtnClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    //FAttrsMaxLen: Integer;
    function GetAttrs: RawUtf8;
  public
    procedure MoveSelected(List: TCustomListBox; Items: TStrings);
    procedure SetItem(List: TListBox; Index: Integer);
    function GetFirstSelection(List: TCustomListBox): Integer;
    procedure SetButtons;
    constructor Create(AOwner: TComponent; ASchema: TLDAPSchema; Attrs: RawUtf8); reintroduce;
    property Attributes: RawUtf8 read GetAttrs;
  end;

var
  PickAttributesDlg: TPickAttributesDlg;

implementation

uses Math;

{$R *.dfm}

function TPickAttributesDlg.GetAttrs: RawUtf8;
var
  i, p: Integer;
begin
  Result := '';
  with DstList do
  begin
    for i := 0 to Items.Count - 1 do
    begin
      if Result <> '' then
        Result := Result + ',';
      p := Pos(',', Items[i]);
      if p > 0 then
        Result := Result + Copy(Items[i], 1, p - 1)
      else
        Result := Result + Items[i];
    end;
  end;
end;

constructor TPickAttributesDlg.Create(AOwner: TComponent; ASchema: TLDAPSchema; Attrs: RawUtf8);
var
  i, idx: Integer;

  function ContainsAt(const L1, L2: TStrings): Integer;
  var
    i: Integer;
  begin
    Result := -1;
    i := L2.Count - 1;
    while (i >= 0) do begin
      Result := L1.IndexOf(L2[i]);
      if Result <> - 1 then
        Break;
      dec(i);
    end;
  end;

begin
  inherited Create(AOwner);
  DstList.Items.CommaText := Attrs;
  with SrcList do begin
    for i :=0 to ASchema.Attributes.Count - 1 do with ASchema, Attributes[i] do
    begin
      idx := ContainsAt(DstList.Items, Attributes[i].Name);
      if idx <> -1 then
      begin
        DstList.Items[idx] := Name.CommaText;
        Continue;
      end;
      Items.Add(Name.CommaText);
    end;
  end;
end;

procedure TPickAttributesDlg.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TPickAttributesDlg.IncludeBtnClick(Sender: TObject);
var
  Index: Integer;
begin
  Index := GetFirstSelection(SrcList);
  MoveSelected(SrcList, DstList.Items);
  SetItem(SrcList, Index);
end;

procedure TPickAttributesDlg.ExcludeBtnClick(Sender: TObject);
var
  Index: Integer;
begin
  Index := GetFirstSelection(DstList);
  MoveSelected(DstList, SrcList.Items);
  SetItem(DstList, Index);
end;

procedure TPickAttributesDlg.IncAllBtnClick(Sender: TObject);
var
  I: Integer;
begin
  for I := 0 to SrcList.Items.Count - 1 do
    DstList.Items.AddObject(SrcList.Items[I],
      SrcList.Items.Objects[I]);
  SrcList.Items.Clear;
  SetItem(SrcList, 0);
end;

procedure TPickAttributesDlg.ExcAllBtnClick(Sender: TObject);
var
  I: Integer;
begin
  for I := 0 to DstList.Items.Count - 1 do
    SrcList.Items.AddObject(DstList.Items[I], DstList.Items.Objects[I]);
  DstList.Items.Clear;
  SetItem(DstList, 0);
end;

procedure TPickAttributesDlg.MoveSelected(List: TCustomListBox; Items: TStrings);
var
  I: Integer;
begin
  for I := List.Items.Count - 1 downto 0 do
    if List.Selected[I] then
    begin
      Items.AddObject(List.Items[I], List.Items.Objects[I]);
      List.Items.Delete(I);
    end;
end;

procedure TPickAttributesDlg.SetButtons;
var
  SrcEmpty, DstEmpty: Boolean;
begin
  SrcEmpty := SrcList.Items.Count = 0;
  DstEmpty := DstList.Items.Count = 0;
  IncludeBtn.Enabled := not SrcEmpty;
  IncAllBtn.Enabled := not SrcEmpty;
  ExcludeBtn.Enabled := not DstEmpty;
  ExAllBtn.Enabled := not DstEmpty;
end;

function TPickAttributesDlg.GetFirstSelection(List: TCustomListBox): Integer;
begin
  for Result := 0 to List.Items.Count - 1 do
    if List.Selected[Result] then Exit;
  Result := LB_ERR;
end;

procedure TPickAttributesDlg.SetItem(List: TListBox; Index: Integer);
var
  MaxIndex: Integer;
begin
  with List do
  begin
    SetFocus;
    MaxIndex := List.Items.Count - 1;
    if Index = LB_ERR then Index := 0
    else if Index > MaxIndex then Index := MaxIndex;
    Selected[Index] := True;
  end;
  SetButtons;
end;


end.
