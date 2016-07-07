  {      LDAPAdmin - AdvSamba.pas
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

unit AdvSamba;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
{$IFnDEF FPC}
  Windows,
{$ELSE}
  LCLIntf, LCLType, LMessages, DateTimePicker,
{$ENDIF}
  SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ExtCtrls, ComCtrls, Samba, LDAPClasses, ImgList;

type
  TSambaAdvancedDlg = class(TForm)
    OKBtn: TButton;
    CancelBtn: TButton;
    FlagsGroup: TGroupBox;
    cbNoExpire: TCheckBox;
    cbDomTrust: TCheckBox;
    cbHomeReq: TCheckBox;
    cbServerTrust: TCheckBox;
    AddBtn: TButton;
    RemoveBtn: TButton;
    Bevel1: TBevel;
    Label1: TLabel;
    GroupBox1: TGroupBox;
    rbNever: TRadioButton;
    rbAt: TRadioButton;
    DatePicker: TDateTimePicker;
    TimePicker: TDateTimePicker;
    wsList: TListView;
    ImageList1: TImageList;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure rbNeverClick(Sender: TObject);
    procedure rbAtClick(Sender: TObject);
    procedure AddBtnClick(Sender: TObject);
    procedure RemoveBtnClick(Sender: TObject);
    procedure wsListSelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
  private
    fSession: TLdapSession;
    fSambaAccount: TSamba3Account;
    fSNoExp: Boolean;
    fSDomTrust: Boolean;
    fSHomeRq: Boolean;
    fSServTrust: Boolean;
    fSWorkstation: string;
    fSExpDate: TDateTime;
  public
    constructor Create(const AOwner: TComponent; const Session: TLdapSession; const SambaAccount: TSamba3Account); reintroduce; overload;
  end;

var
  SambaAdvancedDlg: TSambaAdvancedDlg;

implementation

uses Pickup, Main, Misc, Constant;

{$R *.dfm}

constructor TSambaAdvancedDlg.Create(const AOwner: TComponent; const Session: TLdapSession; const SambaAccount: TSamba3Account);
var
  sl: TStringList;
  i: Integer;
begin
  inherited Create(AOwner);
  fSession := Session;
  fSambaAccount := SambaAccount;
  with SambaAccount do
  begin
    fSNoExp := NoPasswordExpiration;
    fSDomTrust := DomainTrust;
    fSHomeRq := RequestHomeDir;
    fSServTrust := ServerTrust;
    fSWorkstation := UserWorkstations;
    fsExpDate := KickoffTime;
    if (fsExpDate = -1) or (fsExpDate >= SAMBA_MAX_KICKOFF_TIME) then
      DatePicker.DateTime := Date
    else begin
      DatePicker.Date := fsExpDate;
      TimePicker.Time := fsExpDate;
      rbAt.Checked := true;
    end;
    cbNoExpire.Checked := NoPasswordExpiration;
    cbDomTrust.Checked := DomainTrust;
    cbHomeReq.Checked := RequestHomeDir;
    cbServerTrust.Checked := ServerTrust;
    sl := TStringList.Create;
    try
      sl.CommaText := UserWorkstations;
      for i := 0 to sl.Count - 1 do
        wsList.Items.Add.Caption := sl[i];
    finally
      sl.Free;
    end;
  end;
end;

procedure TSambaAdvancedDlg.FormClose(Sender: TObject; var Action: TCloseAction);
var
  i: Integer;
  s: string;
begin
  with fSambaAccount do
  if ModalResult = mrOk then
  begin
    s := '';
    for i := 0 to wsList.Items.Count - 1 do
    begin
      if s <> '' then s := s + ',';
      s := s + wsList.Items[i].Caption;
    end;
    UserWorkstations := s;

    if rbNever.Checked then
      KickoffTime := SAMBA_MAX_KICKOFF_TIME
    else
      KickoffTime := LocalDateTimeToUTC(Trunc(DatePicker.Date) + Frac(TimePicker.DateTime));

    NoPasswordExpiration := cbNoExpire.Checked;
    DomainTrust := cbDomTrust.Checked;
    RequestHomeDir := cbHomeReq.Checked;
    ServerTrust := cbServerTrust.Checked;
  end
  else begin
    NoPasswordExpiration := fSNoExp;
    DomainTrust := fSDomTrust;
    RequestHomeDir := fSHomeRq;
    ServerTrust := fSServTrust;
    UserWorkstations := fSWorkstation;
    if fSExpDate <> -1 then
      KickoffTime := fSExpDate;
  end;
  Action := caFree;
end;

procedure TSambaAdvancedDlg.rbNeverClick(Sender: TObject);
begin
  rbAt.Checked := false;
  DatePicker.Enabled := false;
  DatePicker.Color := clBtnFace;
  TimePicker.Enabled := false;
  TimePicker.Color := clBtnFace;
end;

procedure TSambaAdvancedDlg.rbAtClick(Sender: TObject);
begin
  rbNever.Checked := false;
  DatePicker.Enabled := True;
  DatePicker.Color := clWindow;
  TimePicker.Enabled := true;
  TimePicker.Color := clWindow;
end;

procedure TSambaAdvancedDlg.AddBtnClick(Sender: TObject);
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
var
  i: integer;
  wsname: string;
begin
  with TPickupDlg.Create(self) do begin
    Caption := cPickAccounts;
    ColumnNames := 'Name,DN';
    Populate(fSession, sCOMPUTERS, ['uid', PSEUDOATTR_DN]);
    Images:=MainFrm.ImageList;
    ImageIndex:=bmComputer;
    ShowModal;

    for i:=0 to SelCount-1 do
    begin
      wsname := Selected[i].AttributesByName['uid'].AsString;
      wsname := Copy(wsname, 1, Length(wsname) - 1);
      if not IsPresent(wsname) then
        wsList.Items.Add.Caption := wsname;
    end;
    Free;
  end;
  RemoveBtn.Enabled:=wsList.Items.Count > 0;
end;

procedure TSambaAdvancedDlg.RemoveBtnClick(Sender: TObject);
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

procedure TSambaAdvancedDlg.wsListSelectItem(Sender: TObject; Item: TListItem; Selected: Boolean);
begin
  RemoveBtn.Enabled := Assigned(wsList.Selected);
end;

end.
