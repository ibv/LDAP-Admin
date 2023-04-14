  {      LDAPAdmin - uAccountCopyDlg.pas
  *      Copyright (C) 2005-2016 Alexander Sokoloff
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
  *
  *      Added support for account folders - 16.11.2016, T.Karlovic
  }

unit uAccountCopyDlg;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
  LCLIntf, LCLType,
  SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, Config, ImgList, mormot.core.base;

type
  TAccountCopyDlg = class(TForm)
    Label1:     TLabel;
    NameEd:     TEdit;
    Label2:     TLabel;
    StorageCbx: TComboBox;
    Images:     TImageList;
    OkBtn: TButton;
    CancelBtn: TButton;
    procedure   StorageCbxDrawItem(Control: TWinControl; Index: Integer; Rect: TRect; State: TOwnerDrawState);
    procedure OkBtnClick(Sender: TObject);
  private
    function    GetTarget: TAccountFolder;
    procedure   SetTarget(const Value: TAccountFolder);
    function    GetAccountName: RawUtf8;
    procedure   SetAccountName(const Value: RawUtf8);
  public
    constructor Create(AOwner: TComponent); override;
    property    TargetFolder: TAccountFolder read GetTarget write SetTarget;
    property    AccountName: RawUtf8 read GetAccountName write SetAccountName;
  end;

implementation

uses Constant;

{$R *.dfm}

{ TAccountCopyDlg }

constructor TAccountCopyDlg.Create(AOwner: TComponent);
var
  i, j: integer;

  procedure AddFolder(AFolder: TAccountFolder);
  var
    i: Integer;
  begin
    StorageCbx.Items.AddObject(AFolder.Name, AFolder);
    for i := 0 to Length(AFolder.Items.Folders) - 1 do
      AddFolder(AFolder.Items.Folders[i]);
  end;

begin
  inherited;
  with GlobalConfig do
  for i := 0 to Length(Storages) - 1 do with Storages[i] do
  begin
    StorageCbx.Items.AddObject(Name, Storages[i]);
    for j := 0 to Length(RootFolder.Items.Folders) - 1 do
      AddFolder(RootFolder.Items.Folders[j]);
  end;
end;

function TAccountCopyDlg.GetAccountName: RawUtf8;
begin
  result:=NameEd.Text;
end;

procedure TAccountCopyDlg.SetAccountName(const Value: RawUtf8);
begin
  NameEd.Text:=Value;
end;

function TAccountCopyDlg.GetTarget: TAccountFolder;
begin
  if StorageCbx.ItemIndex = -1 then
    Result:=nil
  else
    Result := ConfigGetFolder(StorageCbx.Items.Objects[StorageCbx.ItemIndex]);
end;

procedure TAccountCopyDlg.SetTarget(const Value: TAccountFolder);
var
  i: integer;
begin
  for i := 0 to StorageCbx.Items.Count - 1 do
    if ConfigGetFolder(StorageCbx.Items.Objects[i]) = Value then
      StorageCbx.ItemIndex := i;
end;

procedure TAccountCopyDlg.StorageCbxDrawItem(Control: TWinControl; Index: Integer; Rect: TRect; State: TOwnerDrawState);
var
  idx: Integer;

  function GetImageIndex: Integer;
  begin
    if Index = 0 then
    begin
      Result := 0;
      exit;
    end;
    if StorageCbx.Items.Objects[Index] is TAccountFolder then
      Result := 2
    else
      Result := 1;
  end;

begin
  StorageCbx.Canvas.FillRect(Rect);
  idx := GetImageIndex;
  Rect.Left := Rect.Left + GetIndent(StorageCbx.Items.Objects[Index]);
  Images.Draw(StorageCbx.Canvas, Rect.Left, Rect.Top, idx);
  Rect.Left := Rect.Left + Images.Width + 6;
  DrawText(StorageCbx.Canvas.Handle, PChar(StorageCbx.Items[Index]), -1, Rect, DT_SINGLELINE or DT_VCENTER or DT_NOPREFIX);
end;

procedure TAccountCopyDlg.OkBtnClick(Sender: TObject);
begin
  if NameEd.Text = '' then raise
    Exception.Create(stAccntNameReq);
end;

end.
