  {      LDAPAdmin - PicView.pas
  *      Copyright (C) 2012 Tihomir Karlovic
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

unit PicView;

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
  Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtDlgs, ExtCtrls, ComCtrls, ToolWin, ImgList, LDAPClasses, ActnList,
  FileUtil;

type
  TViewPicFrmSaveMode = (smLdap, smReference, smNone);

  TViewPicFrm = class(TForm)
    Image1: TImage;
    ToolBar1: TToolBar;
    btnFitToPicture: TToolButton;
    btnResize: TToolButton;
    StatusBar1: TStatusBar;
    ImageList1: TImageList;
    btnCopy: TToolButton;
    btnPaste: TToolButton;
    ActionList1: TActionList;
    ActFitToPicture: TAction;
    ActResize: TAction;
    ActCopy: TAction;
    ActPaste: TAction;
    btnSave: TToolButton;
    ToolButton2: TToolButton;
    ToolButton3: TToolButton;
    ActSave: TAction;
    btnToFile: TToolButton;
    btnFromFile: TToolButton;
    ActSaveToFile: TAction;
    ActLoadFromFile: TAction;
    ToolButton5: TToolButton;
    SaveDialog: TSavePictureDialog;
    OpenDialog: TOpenPictureDialog;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDeactivate(Sender: TObject);
    procedure ActFitToPictureExecute(Sender: TObject);
    procedure ActResizeExecute(Sender: TObject);
    procedure ActCopyExecute(Sender: TObject);
    procedure ActPasteExecute(Sender: TObject);
    procedure ActionList1Update(Action: TBasicAction; var Handled: Boolean);
    procedure ActSaveExecute(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure ActSaveToFileExecute(Sender: TObject);
    procedure ActLoadFromFileExecute(Sender: TObject);
  private
    fEntry: TLdapEntry;
    fValue: TLdapAttributeData;
    fDirty: Boolean;
    fOnWrite: TDataNotifyEvent;
    fSaveMode: TViewPicFrmSaveMode;
  public
    constructor Create(AOwner: TComponent; AValue: TLdapAttributeData; SaveMode: TViewPicFrmSaveMode); reintroduce;
    property OnWrite: TDataNotifyEvent read fOnWrite write fOnWrite;
  end;

var
  ViewPicFrm: TViewPicFrm;

implementation

{$I LdapAdmin.inc}


uses
{$IFnDEF FPC}
  jpeg,
{$ELSE}
{$ENDIF}
  clipbrd, Constant, Misc{$IFDEF VER_XEH}, System.UITypes{$ENDIF};

{$R *.dfm}

constructor TViewPicFrm.Create(AOwner: TComponent; AValue: TLdapAttributeData; SaveMode: TViewPicFrmSaveMode);
var
  ji: TJpegImage;
  Attr: TLdapAttribute;
  i: integer;
begin
  inherited Create(AOwner);
  fSaveMode := SaveMode;
  case SaveMode of
    smReference: fValue := AValue;
    smLdap:      begin
                   fEntry := TLdapEntry.Create(AValue.Attribute.Entry.Session, AValue.Attribute.Entry.dn);
                   fEntry.Read;
                   Attr := fEntry.AttributesByName[AValue.Attribute.Name];
                   i := Attr.IndexOf(AValue.Data, AValue.DataSize);
                   if i = -1 then
                     Abort;
                   fValue := Attr.Values[i];
                   btnSave.Hint := cSaveToLdap;
                 end;
  else
                 ActSave.Visible := false;
                 ActPaste.Visible := false;
                 ToolButton2.Visible := false;
  end;

  ji := TJpegImage.Create;
  try
    StreamCopy(AValue.SaveToStream, ji.LoadFromStream);
    Image1.Picture.Graphic := ji;
    StatusBar1.SimpleText := Format('%dx%d', [Image1.Picture.Width, Image1.Picture.Height]);
    Caption := cViewPic + AValue.Attribute.Name;
    ActFitToPictureExecute(nil);
    btnResize.Down := true;
    ActResizeExecute(nil);
  finally
    ji.Free;
  end;
end;

procedure TViewPicFrm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TViewPicFrm.FormDeactivate(Sender: TObject);
begin
  RevealWindow(Self, True, True);
end;

procedure TViewPicFrm.ActFitToPictureExecute(Sender: TObject);
begin
  LockControl(Self, true);
  btnResize.Down := false;
  try
    Image1.Align := alNone;
    Height := MaxInt;
    Width := MaxInt;
    ClientWidth := Image1.Left + Image1.Width;
    ClientHeight := Image1.Top + Image1.Height + StatusBar1.Height;
  finally
    LockControl(Self, false);
  end;
end;

procedure TViewPicFrm.ActResizeExecute(Sender: TObject);
begin
  LockControl(Self, true);
  try
    if btnResize.Down then
    begin
      Image1.Stretch := true;
      Image1.Align := alClient;
    end
    else begin
      Image1.Stretch := false;
      Image1.Align := alNone;
    end;
  finally
    LockControl(Self, false);
  end;
end;

procedure TViewPicFrm.ActCopyExecute(Sender: TObject);
begin
  Clipboard.Assign(Image1.Picture);
end;

procedure TViewPicFrm.ActPasteExecute(Sender: TObject);
begin
  Image1.Picture.Bitmap.Assign(Clipboard);
  fDirty := true;
end;

procedure TViewPicFrm.ActionList1Update(Action: TBasicAction;
  var Handled: Boolean);
begin
  ActPaste.Enabled := Clipboard.HasFormat(CF_BITMAP);
  ActSave.Enabled := fDirty;
end;

procedure TViewPicFrm.ActSaveExecute(Sender: TObject);
var
  ji: TJpegImage;
begin
  if fDirty then
  begin
    ji := TJpegImage.Create;
    try
      ji.Assign(Image1.Picture.Graphic);
      StreamCopy(ji.SaveToStream, fValue.LoadFromStream);
      if fSaveMode = smLdap then
        fValue.Attribute.Entry.Write;
      fDirty := false;
      if Assigned(fOnWrite) then
        fOnWrite(fValue);
    finally
      ji.Free;
    end;
  end;
  if fSaveMode = smReference then
    Close;
end;

procedure TViewPicFrm.FormDestroy(Sender: TObject);
begin
  fEntry.Free;
end;

procedure TViewPicFrm.ActSaveToFileExecute(Sender: TObject);
begin
  with SaveDialog do
  begin
    if not Execute or (FileExistsUTF8(FileName) { *Converted from FileExists* } and
       (MessageDlg(Format(stFileOverwrite, [FileName]), mtConfirmation, [mbYes, mbNo], 0) <> mrYes)) then Exit;
    Image1.Picture.SaveToFile(FileName);
  end;
end;

procedure TViewPicFrm.ActLoadFromFileExecute(Sender: TObject);
begin
  if not OpenDialog.Execute then Exit;
  Image1.Picture.LoadFromFile(OpenDialog.FileName);
  fDirty := true;
end;

end.
