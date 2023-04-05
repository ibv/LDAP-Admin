  {      LDAPAdmin - ADUser.pas
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

unit ADUser;

interface

uses
  Windows,WinLDAP, ShellApi,
  LinLDAP,DateTimePicker, Graphics, LCLIntf, LCLType, LMessages,
  Messages, SysUtils, Classes, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, ComCtrls, LDAPClasses,  ImgList, Constant,
  ExtDlgs, TemplateCtrl, CheckLst, Connection, AdObjects;

type
  TWMDropFiles = packed record
    Msg: Cardinal;
    Drop: THANDLE;
    Unused: Longint;
    Result: Longint;
  end;


type
  TADUserDlg = class(TForm)
    PageControl: TPageControl;
    AccountSheet: TTabSheet;
    Panel1: TPanel;
    OkBtn: TButton;
    CancelBtn: TButton;
    givenName: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    sn: TEdit;
    displayName: TEdit;
    Label3: TLabel;
    userPrincipalName: TEdit;
    Label4: TLabel;
    initials: TEdit;
    Label5: TLabel;
    samAccountName: TEdit;
    ProfileSheet: TTabSheet;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    scriptPath: TEdit;
    homeDrive: TComboBox;
    profilePath: TEdit;
    OfficeSheet: TTabSheet;
    Label15: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    Label22: TLabel;
    Label24: TLabel;
    Label25: TLabel;
    Label27: TLabel;
    Label29: TLabel;
    Label30: TLabel;
    Label31: TLabel;
    pager: TEdit;
    streetAddress: TMemo;
    st: TEdit;
    telephoneNumber: TEdit;
    postalCode: TEdit;
    physicalDeliveryOfficeName: TEdit;
    o: TEdit;
    facsimileTelephoneNumber: TEdit;
    l: TEdit;
    PrivateSheet: TTabSheet;
    Label17: TLabel;
    Label23: TLabel;
    Label26: TLabel;
    Label28: TLabel;
    info: TMemo;
    otherFacsimiletelephoneNumber: TEdit;
    homePhone: TEdit;
    mobile: TEdit;
    GroupSheet: TTabSheet;
    Label34: TLabel;
    Label33: TLabel;
    GroupList: TListView;
    AddGroupBtn: TButton;
    RemoveGroupBtn: TButton;
    PrimaryGroupBtn: TButton;
    edPrimaryGroup: TEdit;
    OptionsSheet: TTabSheet;
    rgAccountExpires: TRadioGroup;
    DatePicker: TDateTimePicker;
    ImagePanel: TPanel;
    OpenPictureBtn: TButton;
    Label41: TLabel;
    Image1: TImage;
    OpenPictureDialog: TOpenPictureDialog;
    DeleteJpegBtn: TButton;
    title: TEdit;
    Label21: TLabel;
    description: TEdit;
    TemplateSheet: TTabSheet;
    CheckListBox: TCheckListBox;
    clbxAccountOptions: TCheckListBox;
    Label11: TLabel;
    cbUPNDomain: TComboBox;
    Label9: TLabel;
    homeDirectory: TEdit;
    BtnAdditional: TButton;
    NTDomain: TEdit;
    Label12: TLabel;
    cn: TEdit;
    Label10: TLabel;
    cbAccountLockout: TCheckBox;
    mail: TEdit;
    ApplyBtn: TButton;
    Label13: TLabel;
    edPassword1: TEdit;
    edPassword2: TEdit;
    Label14: TLabel;
    ApplicationEvents1: TApplicationProperties;
    wWWHomePage: TEdit;
    Label16: TLabel;
    TimePicker: TDateTimePicker;
    TimeLabel: TStaticText;
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure PageControlChange(Sender: TObject);
    procedure AddGroupBtnClick(Sender: TObject);
    procedure RemoveGroupBtnClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure PrimaryGroupBtnClick(Sender: TObject);
    procedure snExit(Sender: TObject);
    procedure ListViewColumnClick(Sender: TObject; Column: TListColumn);
    procedure ListViewCompare(Sender: TObject; Item1, Item2: TListItem;
      Data: Integer; var Compare: Integer);
    procedure FormDestroy(Sender: TObject);
    procedure rgAccountExpiresClick(Sender: TObject);
    procedure EditChange(Sender: TObject);
    procedure cbUPNDomainChange(Sender: TObject);
    procedure homeDriveChange(Sender: TObject);
    procedure cbAccountLockoutClick(Sender: TObject);
    procedure TimePickerChange(Sender: TObject);
    procedure OpenPictureBtnClick(Sender: TObject);
    procedure DeleteJpegBtnClick(Sender: TObject);
    procedure BtnAdditionalClick(Sender: TObject);
    procedure CheckListBoxDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure CheckListBoxClickCheck(Sender: TObject);
    procedure CheckListBoxClick(Sender: TObject);
    procedure PageControlResize(Sender: TObject);
    procedure PageControlChanging(Sender: TObject;
      var AllowChange: Boolean);
    procedure ApplyBtnClick(Sender: TObject);
    procedure ApplicationEvents1Idle(Sender: TObject; var Done: Boolean);
    procedure clbxAccountOptionsClickCheck(Sender: TObject);
    procedure userPrincipalNameChange(Sender: TObject);
    procedure cbUPNDomainDropDown(Sender: TObject);
    procedure userPrincipalNameExit(Sender: TObject);
    procedure DatePickerChange(Sender: TObject);
  private
    ParentDn: string;
    Entry: TLdapEntry;
    EventHandler: TEventHandler;
    Connection: TConnection;
    ColumnToSort: Integer;
    Descending: Boolean;
    PageSetup: Boolean;
    AsTop: Integer;
    originalPanelWindowProc : TWndMethod;
    TranscodeList: TStringList;
    MembershipHelper: TMembershipHelper;
    fADH: TADHelper;
    fCanNotChangePwd: Boolean;
    FTimeCheckedState: Boolean;
    function  GetTimePickersValue: TDateTime;
    procedure SetTimePickers(Value: TDateTime);
    procedure PanelWindowProc(var Msg: TMessage);
    procedure PanelImageDrop(var Msg: TWMDROPFILES);
    function  FormatString(const Src: string): string;
    procedure LoadControls(Parent: TWinControl);
    procedure GetDefaults;
    procedure GetAccountFlags;
    procedure SetAccountFlags;
    procedure Load;
    procedure Save;
    procedure CheckSchema;
    procedure SetText(Edit: TCustomEdit; Value: string);
  public
    constructor Create(AOwner: TComponent; adn: string; AConnection: TConnection; Mode: TEditMode); reintroduce;
  end;

var
  ADUserDlg: TADUserDlg;

implementation

{$I LdapAdmin.inc}

uses Pickup, Input, Misc, Main, Templates, Config, adsie,
     AdPrefs, AdAdv  {$IFDEF VER_XEH}, System.UITypes{$ENDIF};

{$R *.dfm}

const
  ManagedAttributes: array [0..33] of string = (
    'accountExpires',
    'cn',
    'description',
    'displayName',
    'facsimileTelephoneNumber',
    'givenName',
    'homeDirectory',
    'homeDrive',
    'homePhone',
    'info',
    'initials',
    'jpegPhoto',
    'l',
    'mail',
    'memberOf',
    'mobile',
    'o',
    'objectSid',
    'otherFacsimiletelephoneNumber',
    'pager',
    'physicalDeliveryOfficeName',
    'postalCode',
    'primaryGroupId',
    'profilePath',
    'samAccountName',
    'scriptPath',
    'sn',
    'st',
    'streetAddress',
    'telephoneNumber',
    'title',
    'userAccountControl',
    'userPrincipalName',
    'wWWHomePage');

    afPwdMustChange     = 0;
    afCanNotChangePwd   = 1;
    afPwdNeverExpires   = 2;
    afAllowEncrypted    = 3;
    afAccountDisabled   = 4;
    afSmartCardRequired = 5;
    afTrustedForDelegation = 6;
    afNotDelegated      = 7;
    afUseDESKeyOnly     = 8;
    afDoNotRequireKerb  = 9;
    afPasswordNotRequired = 10;

{ TADUserDlg }

function TADUserDlg.GetTimePickersValue: TDateTime;
begin
  Result := Trunc(DatePicker.Date);
  if TimePicker.Checked then
    Result := Result + Frac(TimePicker.Time)
  else
    Result := Result + 1;
end;

procedure TADUserDlg.SetTimePickers(Value: TDateTime);
begin
  if Frac(Value) = 0 then
  begin
    TimePicker.DateTime := 0;
    if TimePicker.Checked then
    begin
      TimePicker.Checked := false;
      TimePickerChange(nil);
    end;
    Value := Value - 1;
  end
  else
    TimePicker.DateTime := Value;
  DatePicker.DateTime := Value;
end;

procedure TADUserDlg.PanelWindowProc(var Msg: TMessage) ;
begin
 if Msg.Msg = WM_DROPFILES then
   ///PanelImageDrop(TWMDROPFILES(Msg))
 else
   originalPanelWindowProc(Msg) ;
end;

procedure TADUserDlg.PanelImageDrop(var Msg: TWMDROPFILES) ;
var
   buffer : array[0..MAX_PATH] of char;
begin
   ///DragQueryFile(Msg.Drop, 0, @buffer, sizeof(buffer)) ;
   Image1.Picture.LoadFromFile(buffer) ;
   //Entry.JPegPhoto := Image1.Picture.Graphic as TJpegImage;
   DeleteJpegBtn.Enabled := true;
   ImagePanel.Caption := '';
end;

function TADUserDlg.FormatString(const Src : string) : string;
var
  p, p1: PChar;

  function CheckRange(var p1: PChar; src: string): string;
  var
    p: PChar;
    rg: string;
  begin
    p := CharNext(p1);
    if p^ = '[' then
    begin
      p := CharNext(p);
      p1 := p;
      while p1^ <> ']' do begin
        if p1 = #0 then
          raise Exception.Create(stUnclosedParam);
        p1 := CharNext(p1);
      end;
      SetString(rg, p, p1 - p);
      Result := Copy(src, 1, StrToInt(rg));
    end
    else
      Result := src;
  end;

begin
  Result := '';
  p := PChar(Src);
  while p^ <> #0 do begin
    p1 := CharNext(p);
    if (p^ = '%') then
    begin
      case p1^ of
        'u': Result := Result + cn.Text;
        'f': Result := Result + CheckRange(p1, GivenName.Text);
        'F': Result := Result + GivenName.Text[1];
        'l': Result := Result + CheckRange(p1, Sn.Text);
        'L': Result := Result + Sn.Text[1];
        'n': Result := Result + Connection.Account.ReadString(rAdNTDomain, NTDomain.Text);
      else
        Result := Result + p^ + p1^;
      end;
      p1 := CharNext(p1);
    end
    else
      Result := Result + p^;
    p := p1;
  end;
end;

procedure TADUserDlg.LoadControls(Parent: TWinControl);
var
  Control: TControl;
  i: Integer;
  s: string;
begin
  PageSetup := true;
  for i := 0 to Parent.ControlCount - 1 do
  begin
    Control := Parent.Controls[i];
    s := Entry.AttributesByName[Control.Name].AsString;
    if Control is TCustomEdit then
    begin
      if Control is TMemo then
        s := FormatMemoInput(s);
      TCustomEdit(Control).Text := s;
    end
    else
    if Control is TComboBox then
      with TComboBox(Control) do
        ItemIndex :=  Items.IndexOf(s);
  end;
  PageSetup := false;
end;

procedure TADUserDlg.GetDefaults;
var
  s: string;

  function Transcode(Source: string): string;
  var
    i, l: Integer;
    p: PChar;
  begin
    Result := '';
    p := PChar(Source);
    while p^ <> #0 do begin
      i := TranscodeList.Count - 1;
      while i >= 0 do begin
        l := Pos(#$1F, TranscodeList[i]) - 1;
        if (l >= 0) and (AnsiStrLComp(PChar(TranscodeList[i]), p, l) = 0) then
        begin
          Result := Result + Copy(TranscodeList[i], l + 2, MaxInt);
          p := p + l;
          break;
        end;
        dec(i);
      end;
      if i = -1 then
      begin
        Result := Result + p^;
        p := CharNext(p);
      end;
    end;
  end;

begin
  if sn.Modified or givenName.Modified then
  begin
    if givenName.Text <> '' then
    begin
      s := AnsiLowercase(FormatString(Connection.Account.ReadString(rAdUserPrincipalName, psUPN)));
      SetText(displayName, FormatString(Connection.Account.ReadString(rAdDisplayName, psDisplayName)));
    end
    else begin
      s := AnsiLowercase(sn.Text);
      SetText(displayName, s);
    end;

    if cn.Text = '' then
    begin
      SetText(cn, Transcode(s));
      if samAccountName.Text = '' then
        samAccountName.Text := cn.Text;
      if UserPrincipalName.Text = '' then
        SetText(UserPrincipalName, Transcode(s));
    end;
  end;

  if HomeDirectory.Text = '' then
  begin
    s := Connection.Account.ReadString(rAdHomeDirectory, psHomeDir);
    if (Connection.Account.ReadString(rAdNTDomain) <> '') or (Pos('%n', s) = 0) then
      SetText(HomeDirectory, FormatString(s));
  end;

  if ProfilePath.Text = '' then
  begin
    s := Connection.Account.ReadString(rsambaProfilePath);
    if (Connection.Account.ReadString(rAdNTDomain) <> '') or (Pos('%n', s) = 0) then
        SetText(ProfilePath, FormatString(s));
  end;

  if ScriptPath.Text = '' then
    SetText(ScriptPath, FormatString(Connection.Account.ReadString(rAdLoginScript, psLoginScript)));

  if HomeDrive.ItemIndex = -1 then
    HomeDrive.ItemIndex := HomeDrive.Items.IndexOf(Connection.Account.ReadString(rAdHomeDrive, psHomeDrive));
end;

procedure TADUserDlg.GetAccountFlags;
var
  Flags: Integer;
begin
  Flags := StrToInt(Entry.AttributesByName['userAccountControl'].AsString);
  with clbxAccountOptions do begin
    Checked[afPwdMustChange]        := Entry.AttributesByName['pwdLastSet'].AsString = '0';
    ///fCanNotChangePwd                := GetUserCannotChangePassword(Entry);
    Checked[afCanNotChangePwd]      := fCanNotChangePwd;
    Checked[afPwdNeverExpires]      := Flags and UF_DONT_EXPIRE_PASSWORD <> 0;
    Checked[afAllowEncrypted]       := Flags and UF_ENCRYPTED_TEXT_PWD_ALLOWED <> 0;
    Checked[afAccountDisabled]      := Flags and UF_ACCOUNTDISABLE <> 0;
    Checked[afSmartCardRequired]    := Flags and UF_SMARTCARD_REQUIRED <> 0;
    Checked[afTrustedForDelegation] := Flags and UF_TRUSTED_FOR_DELEGATION <> 0;
    Checked[afNotDelegated]         := Flags and UF_NOT_DELEGATED <> 0;
    Checked[afUseDESKeyOnly]        := Flags and UF_USE_DES_KEY_ONLY <> 0;
    Checked[afDoNotRequireKerb]     := Flags and UF_DONT_REQ_PREAUTH <> 0;
    Checked[afPasswordNotRequired]  := Flags and UF_PASSWD_NOTREQD <> 0;
  end;
end;

procedure TADUserDlg.SetAccountFlags;
const
  Masque = UF_DONT_EXPIRE_PASSWORD + UF_ENCRYPTED_TEXT_PWD_ALLOWED +
           UF_ACCOUNTDISABLE + UF_SMARTCARD_REQUIRED + UF_TRUSTED_FOR_DELEGATION +
           UF_NOT_DELEGATED + UF_USE_DES_KEY_ONLY + UF_DONT_REQ_PREAUTH + UF_PASSWD_NOTREQD;
var
  Flags: Cardinal;
  Attr: TLdapAttribute;

  procedure SetMustChange(Value: Boolean);
  begin
    with Entry.AttributesByName['pwdLastSet'] do
      if Value then
        AsString := '0'
      else begin
        if AsString = '0' then
          AsString := '-1';
    end;
  end;

begin
  Attr := Entry.AttributesByName['userAccountControl'];
  if Attr.AsString <> '' then
    Flags := StrToInt(Attr.AsString) and not Masque
  else
    Flags := 0;
  with clbxAccountOptions do begin
   SetMustChange(Checked[afPwdMustChange]);
   if Checked[afPwdNeverExpires] then Flags := Flags or UF_DONT_EXPIRE_PASSWORD;
   if Checked[afAllowEncrypted] then Flags := Flags or UF_ENCRYPTED_TEXT_PWD_ALLOWED;
   if Checked[afAccountDisabled] then Flags := Flags or UF_ACCOUNTDISABLE;
   if Checked[afSmartCardRequired] then Flags := Flags or UF_SMARTCARD_REQUIRED;
   if Checked[afTrustedForDelegation] then Flags := Flags or UF_TRUSTED_FOR_DELEGATION;
   if Checked[afNotDelegated] then Flags := Flags or UF_NOT_DELEGATED;
   if Checked[afUseDESKeyOnly] then Flags := Flags or UF_USE_DES_KEY_ONLY;
   if Checked[afDoNotRequireKerb] then Flags := Flags or UF_DONT_REQ_PREAUTH;
   if Checked[afPasswordNotRequired] then Flags := Flags or UF_PASSWD_NOTREQD;
  end;
  Attr.AsString := IntToStr(Flags);
end;

procedure TADUserDlg.Save;
begin
  CheckSchema;
  if esNew in Entry.State then
  begin
    Entry.Dn := 'CN=' + EncodeLdapString(cn.Text) + ',' + ParentDn;
    Entry.AdSetPassword(edPassword1.Text);
  end;

  try
    if Assigned(MembershipHelper) then
      MembershipHelper.Write
    else
      Entry.Write;
  except
    on E: ERRLdap do
      if (esNew in Entry.State) and (E.ErrorCode = LDAP_UNWILLING_TO_PERFORM) {$ifdef mswindows} and
         (E.ExtErrorCode = ERROR_GEN_FAILURE) {$endif} then with Entry do
      begin
        if not (Session.SSL or Session.TLS or (Session.AuthMethod = AUTH_GSS_SASL)) then
          raise Exception.Create(stPwdNoEncryption)
        else
          raise;
      end
      else
        raise;
  end;
end;

procedure TADUserDlg.Load;
var
  i: Integer;

  function LockedOut: Boolean;
  var
    s: string;
  begin
    s := Entry.AttributesByName['lockoutTime'].AsString;
    Result := (s <> '') and (s <> '0');
  end;

begin
  LoadControls(AccountSheet);
  LoadControls(OfficeSheet);
  LoadControls(ProfileSheet);
  LoadControls(PrivateSheet);

  if UserPrincipalName.Text <> '' then
  begin
    i := Pos('@', UserPrincipalName.Text);
    if i > 0 then
    begin
      cbUPNDomain.Text := Copy(UserPrincipalName.Text, i);
      SetText(UserPrincipalName, Copy(UserPrincipalName.Text, 1, i - 1));
    end;
  end;

  if fADH.NTDomain <> '' then
    NTDomain.Text := fADH.NTDomain + '\';

  if PageControl.ActivePage = OptionsSheet then
    GetAccountFlags;
  fCanNotChangePwd := clbxAccountOptions.Checked[afCanNotChangePwd];
  cbAccountLockout.Checked := LockedOut;
  cbAccountLockout.Enabled := cbAccountLockout.Checked;

  if Entry.AdAccountExpires <> ufAccountNeverExpires then
  begin
    SetTimePickers(Entry.AdAccountExpires);
    rgAccountExpires.ItemIndex := 1;
  end;

end;

procedure TADUserDlg.CheckSchema;
begin
  try
    if cn.Text = '' then
      raise Exception.Create(Format(stReqNoEmpty, [cUsername]));
    if (esNew in Entry.State) and (edPassword1.Text <> edPassword2.Text) then
      raise Exception.Create(stPassDiff);
    if (UserPrincipalName.Text = '') xor (cbUpnDomain.Text = '') then
    begin
      if cbUpnDomain.Text = '' then
        cbUpnDomain.SetFocus
      else
        UserPrincipalName.SetFocus;
      raise Exception.Create(stUpnIncomplete);
    end;
  except
    PageControl.ActivePage := AccountSheet;
    raise;
  end;
end;

procedure TADUserDlg.clbxAccountOptionsClickCheck(Sender: TObject);
begin
  with clbxAccountOptions do
    if Checked[afPwdMustChange] and Checked[afCanNotChangePwd] then
    begin
      if ItemIndex = afPwdMustChange then
        Checked[afPwdMustChange] := false
      else
        Checked[afCanNotChangePwd] := false;
      raise Exception.CreateFmt(stMutuallyExclusive, [Items[afPwdMustChange], Items[afCanNotChangePwd]]);
    end;
  SetAccountFlags;
end;

procedure TADUserDlg.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  if ModalResult = mrOk then
    Save;
end;

constructor TADUserDlg.Create(AOwner: TComponent; adn: string; AConnection: TConnection; Mode: TEditMode);
var
  i: Integer;
  Oc: TLdapAttribute;
  TemplateList: TTemplateList;
begin
  inherited Create(AOwner);

  FTimeCheckedState := TimePicker.Checked;
  AsTop := AccountSheet.Top;

  Connection := AConnection;
  ParentDn := adn;

  TranscodeList := TStringList.Create;
  Split(GlobalConfig.ReadString(rLocalTransTable, '�'#$1F'ae'#$1E'�'#$1F'oe'#$1E'�'#$1F'ue'#$1E), TranscodeList, #$1E);

  Entry := TLdapEntry.Create(AConnection, adn);

  // Show template extensions

  TemplateList := nil;
  if GlobalConfig.ReadBool(rTemplateExtensions, true) then
    TemplateList := TemplateParser.Extensions['aduser'];
  if Assigned(TemplateList) then
  begin
    EventHandler := TEventHandler.Create;
    with TemplateList do
      for i := 0 to Count - 1 do
        CheckListBox.Items.AddObject(Templates[i].Name, Templates[i]);
    CheckListBox.ItemIndex := 0;
    CheckListBox.Enabled := true;
  end
  else
    TemplateSheet.TabVisible := false;

  fADH := Connection.Helper as TAdHelper;

  if Mode = EM_ADD then
  begin
    GroupSheet.TabVisible := false;
    with Entry.ObjectClass do begin
      AddValue('top');
      AddValue('person');
      AddValue('organizationalPerson');
      AddValue('user');
    { When creating user, UAC flags must be ordered AFTER the unicodePwd attribute
      to be able to create a user with password constrains }
      Entry.Attributes.Add('unicodePwd');
      Entry.AttributesByName['userAccountControl'].AsString := IntToStr(UF_NORMAL_ACCOUNT);
    end;
    cn.Enabled := true;
    label13.Visible := true;
    label14.Visible := true;
    edPassword1.Visible := true;
    edPassword2.Visible := true;
    NTDomain.Text := fADH.NTDomain + '\';
    for i := 0 to fADH.DNSRoot.Count - 1 do
      cbUpnDomain.Items.Add('@' + fADH.DNSRoot[i]);
    cbUPNDomain.ItemIndex  := cbUpnDomain.Items.IndexOf(Connection.Account.ReadString(rAdUpnDomain));
    if (cbUPNDomain.Items.Count > 0) and (cbUPNDomain.ItemIndex = -1) then
      cbUPNDomain.ItemIndex  := 0;
    SetTimePickers(Now);
  end
  else begin
    //Fill out the form
    Entry.Read;
    Load;

    Caption := Format(cPropertiesOf, [cn.Text]);

    if rgAccountExpires.ItemIndex = 0 then
      SetTimePickers(Now);

    // Initialize the template extensions
    if Assigned(TemplateList) and GlobalConfig.ReadBool(rTemplateAutoload, true) then with CheckListBox do
    begin
      Oc := Entry.AttributesByName['objectclass'];
      for i := 0 to Items.Count - 1 do with TTemplate(Items.Objects[i]) do
        if Matches(Oc) then
        begin
          State[i] := cbChecked;
          ItemIndex := i;
          CheckListBoxClickCheck(nil);
        end;
    end;
  end;
  GroupList.SmallImages := MainFrm.ImageList;
  originalPanelWindowProc := ImagePanel.WindowProc;
  ImagePanel.WindowProc := PanelWindowProc;
  ///DragAcceptFiles(ImagePanel.Handle,true) ;
end;

procedure TADUserDlg.PageControlChange(Sender: TObject);
begin
  if PageControl.ActivePage = GroupSheet then
  begin
    if not Assigned(MembershipHelper) then
    try
      Screen.Cursor := crHourGlass;
      PageControl.Repaint;
      MembershipHelper := TMembershipHelper.Create(Entry, GroupList);
      edPrimaryGroup.Text := MembershipHelper.PrimaryGroup;
      if GroupList.Items.Count > 0 then
      begin
        GroupList.Items[0].Selected := true;
        RemoveGroupBtn.Enabled := true;
      end;
    finally
      Screen.Cursor := crDefault;
    end;
  end
  else
  if PageControl.ActivePage = PrivateSheet then
  begin
    if not Assigned(Image1.Picture.Graphic) then
    begin
      //Image1.Picture.Graphic := Entry.JPegPhoto;
      if Assigned(Image1.Picture.Graphic) then
      begin
        DeleteJpegBtn.Enabled := true;
        ImagePanel.Caption := '';
      end;
    end;
  end
  else
  if PageControl.ActivePage = OptionsSheet then
  begin
    PageControl.Repaint;
    GetAccountFlags;
  end
  else
  if PageControl.ActivePageIndex > 6 then
     TTemplatePanel(PageControl.ActivePage.Tag).RefreshData;
end;

procedure TADUserDlg.AddGroupBtnClick(Sender: TObject);
begin
  MembershipHelper.Add;
  RemoveGroupBtn.Enabled := GroupList.Items.Count > 0;
end;

procedure TADUserDlg.RemoveGroupBtnClick(Sender: TObject);
begin
  MembershipHelper.Delete;
  if GroupList.Items.Count = 0 then
    RemoveGroupBtn.Enabled := false;
end;

procedure TADUserDlg.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  MembershipHelper.Free;
  Action := caFree;
end;

procedure TADUserDlg.PrimaryGroupBtnClick(Sender: TObject);
begin
  if MembershipHelper.QueryPrimaryGroup = mrOk then
    edPrimaryGroup.Text := MembershipHelper.PrimaryGroup;
end;

procedure TADUserDlg.snExit(Sender: TObject);
begin
  if esNew in Entry.State then
    GetDefaults;
end;

procedure TADUserDlg.userPrincipalNameChange(Sender: TObject);
begin
  if not PageSetup then
    Entry.AttributesByName['userPrincipalName'].AsString := UserPrincipalName.Text + cbUPNDomain.Text;
end;

procedure TADUserDlg.userPrincipalNameExit(Sender: TObject);
begin
  if UserPrincipalName.Text = '' then
  begin
    cbUPNDomain.Text := '';
    Entry.AttributesByName['userPrincipalName'].AsString := '';
  end;
end;

procedure TADUserDlg.SetText(Edit: TCustomEdit; Value: string);
begin
  Edit.Text := Value;
  Edit.Modified := true;
end;

procedure TADUserDlg.ListViewColumnClick(Sender: TObject; Column: TListColumn);
begin
  if ColumnToSort <> Column.Index then
  begin
    ColumnToSort := Column.Index;
    Descending := false;
  end
  else
    Descending := not Descending;
  (Sender as TCustomListView).AlphaSort;
end;

procedure TADUserDlg.ListViewCompare(Sender: TObject; Item1, Item2: TListItem; Data: Integer; var Compare: Integer);
var
  ix: Integer;
begin
  if ColumnToSort = 0 then
    Compare := CompareText(Item1.Caption,Item2.Caption)
  else
  begin
    Compare := -1;
    ix := ColumnToSort - 1;
    if Item1.SubItems.Count > ix then
    begin
      Compare := 1;
      if Item2.SubItems.Count > ix then
        Compare := AnsiCompareText(Item1.SubItems[ix],Item2.SubItems[ix]);
    end;
  end;
  if Descending then
    Compare := - Compare;
end;

procedure TADUserDlg.FormDestroy(Sender: TObject);
var
  i: Integer;
begin
  Entry.Free;
  TranscodeList.Free;
  with CheckListBox.Items do
    for i := 0 to Count - 1 do
      if Objects[i] is TTabSheet then Objects[i].Free;
  EventHandler.Free;
end;

procedure TADUserDlg.rgAccountExpiresClick(Sender: TObject);
begin
  if rgAccountExpires.ItemIndex = 0 then
  begin
    DatePicker.Enabled := false;
    TimePicker.Enabled := false;
    DatePicker.Color := clBtnFace;
    TimePicker.Color := clBtnFace;
    Entry.AdAccountExpires := 0;
  end
  else begin
    DatePicker.Enabled := true;
    TimePicker.Enabled := true;
    DatePicker.Color := clWindow;
    TimePicker.Color := clWindow;
    Entry.AdAccountExpires := GetTimePickersValue;
  end;
end;

procedure TADUserDlg.EditChange(Sender: TObject);
var
  s: string;
begin
  if not PageSetup then with Sender as TCustomEdit do
  begin
    s := Trim(Text);
    if Sender is TMemo then
      s := FormatMemoInput(s);
    Entry.AttributesByName[TControl(Sender).Name].AsString := s;
  end;
end;

procedure TADUserDlg.cbUPNDomainChange(Sender: TObject);
begin
  Entry.AttributesByName['userPrincipalName'].AsString := UserPrincipalName.Text + cbUPNDomain.Text;
end;

procedure TADUserDlg.cbUPNDomainDropDown(Sender: TObject);
var
  i: Integer;
begin
  if cbUpnDomain.Items.Count = 0 then
    for i := 0 to fADH.DNSRoot.Count - 1 do
      cbUpnDomain.Items.Add('@' + fADH.DNSRoot[i]);
end;

procedure TADUserDlg.homeDriveChange(Sender: TObject);
begin
  Entry.AttributesByName['homeDrive'].AsString := HomeDrive.Text;
end;

procedure TADUserDlg.cbAccountLockoutClick(Sender: TObject);
begin
  if cbAccountLockout.Checked then  // can only be unchecked
    exit;
  Entry.AttributesByName['lockoutTime'].AsString := '0';
end;

procedure TADUserDlg.TimePickerChange(Sender: TObject);
begin
  if TimePicker.Checked then
  begin
    if not FTimeCheckedState then
    begin
      if TimePicker.Time = 0 then
        DatePicker.Date := DatePicker.Date + 1; // Handle change from midnight to 00:00:00 next day
    end;
    ///TimePicker.Format := '';
  end
  else begin
    if FTimeCheckedState and (TimePicker.Time = 0) then
      DatePicker.Date := DatePicker.Date - 1; // Handle change from 00:00:00 to midnight previous day
    ///TimePicker.Format := '''' + cMidnight + '''';
  end;

  FTimeCheckedState := TimePicker.Checked;
  Entry.AdAccountExpires := GetTimePickersValue;
end;

procedure TADUserDlg.OpenPictureBtnClick(Sender: TObject);
begin
  if OpenPictureDialog.Execute then
  begin
    Image1.Picture.LoadFromFile(OpenPictureDialog.FileName);
    try
      //Entry.JPegPhoto := Image1.Picture.Graphic as TJpegImage;
    except
      on E: Exception do
      begin
        //Image1.Picture.Graphic := Entry.JPegPhoto;
        if E is EInvalidCast then
          raise Exception.Create(stImgInvalidForm)
        else
          raise;
      end;
    end;
    DeleteJpegBtn.Enabled := true;
    ImagePanel.Caption := '';
  end;
end;

procedure TADUserDlg.DatePickerChange(Sender: TObject);
begin
  Entry.AdAccountExpires := GetTimePickersValue;
end;

procedure TADUserDlg.DeleteJpegBtnClick(Sender: TObject);
begin
  Image1.Picture.Bitmap.FreeImage;
  //Entry.JPegPhoto := nil;
  DeleteJpegBtn.Enabled := false;
end;

procedure TADUserDlg.ApplicationEvents1Idle(Sender: TObject; var Done: Boolean);
var
  E: Boolean;
begin
  E := (esModified in Entry.State) and (cn.Text  <> '') or
       (clbxAccountOptions.Checked[afCanNotChangePwd] <> fCanNotChangePwd);
  if Assigned(MembershipHelper) then
    E := E or MembershipHelper.Modified;
  ApplyBtn.Enabled := E;
end;

procedure TADUserDlg.ApplyBtnClick(Sender: TObject);
var
  NewEntry: Boolean;
begin
  NewEntry := esNew in Entry.State;
  Save;
  if NewEntry then
  begin
    GroupSheet.TabVisible := true;
    label13.Visible := false;
    label14.Visible := false;
    edPassword1.Visible := false;
    edPassword2.Visible := false;
    Entry.Read; // Reload, some settings can be foreced upon via Group Policies
    Load;
  end;
end;

procedure TADUserDlg.BtnAdditionalClick(Sender: TObject);
begin
  Screen.Cursor := crHourGlass;
  try
    TAdAdvancedDlg.Create(Self, Entry).ShowModal;
  finally
    Screen.Cursor := crDefault;
  end;
end;

procedure TADUserDlg.CheckListBoxDrawItem(Control: TWinControl;
  Index: Integer; Rect: TRect; State: TOwnerDrawState);
var
  Flags: Longint;
begin
  with CheckListBox do begin
    Canvas.Brush.Color := Color;
    Canvas.Font.Color := Font.Color;
    Canvas.FillRect(Rect);
    ///Flags := DrawTextBiDiModeFlags(DT_SINGLELINE or DT_VCENTER or DT_NOPREFIX);
    Inc(Rect.Left, 2);
    DrawText(Canvas.Handle, PChar(Items[Index]), Length(Items[Index]), Rect, Flags);
  end;
end;

procedure TADUserDlg.CheckListBoxClickCheck(Sender: TObject);
var
  Template: TTemplate;
  TabSheet: TTabSheet;
  TemplatePanel: TTemplatePanel;
  i, j: Integer;
  s: string;

  function SafeDelete(const name: string): boolean;
  var
    i: Integer;
    s: string;
  begin
    Result := false;
    s := lowercase(name);
    for i := Low(ManagedAttributes) to High(ManagedAttributes) do
      if s = lowercase(ManagedAttributes[i]) then Exit;
    Result := true;
  end;

begin
  { CheckListBox holds pointers to Templates or TabSheets in its Object array:
    Checked[i] = FALSE:  Objects[i] = Pointer(Template)
    Checked[i] = TRUE:   Objects[i] = Pointer(TTabSheet)
    TabSheet holds pointer to TemplatePanel in its Tag filed.
  }
  with CheckListBox do begin
    Tag := Integer(Sender);
    if State[ItemIndex] <> cbChecked then
    begin
      TabSheet := TTabSheet(Items.Objects[ItemIndex]);
      TemplatePanel := TTemplatePanel(TabSheet.Tag);
      Items.Objects[ItemIndex] := Pointer(TemplatePanel.Template);
      { Handle removing of the template - remove only attributes and
        objectclasses which are not used by builtin registers }
      for i := 0 to TemplatePanel.Attributes.Count - 1 do with TemplatePanel.Attributes[i] do
      begin
        Template := TemplatePanel.Template;
        if (lowercase(Name) = 'objectclass') then
        begin
          with Entry.AttributesByName['objectclass'] do
          for j := 0 to Template.ObjectclassCount - 1 do
          begin
            s := lowercase(Template.Objectclasses[j]);
            if (s <> 'top') and
               (s <> 'person') and
               (s <> 'organizationalperson') and
               (s <> 'user') then
              DeleteValue(s);
          end;
        end
        else
        if SafeDelete(Name) then
          Entry.AttributesByName[Name].Delete;
      end;
      TabSheet.Free;
      Exit;
    end;
    Template := TTemplate(Items.Objects[ItemIndex]);
    TabSheet := TTabSheet.Create(Self);
    TabSheet.Caption := Template.Name;

    TabSheet.PageControl := PageControl;
    TemplatePanel := TTemplatePanel.Create(Self);
    TemplatePanel.Parent := TabSheet;
    TemplatePanel.Align := alClient;
    TemplatePanel.LdapEntry := Entry;
    TemplatePanel.Template := Template;
    TemplatePanel.EventHandler := EventHandler;

    TabSheet.Tag := Integer(TemplatePanel);
    Items.Objects[ItemIndex] := TabSheet;
  end;
end;

procedure TADUserDlg.CheckListBoxClick(Sender: TObject);
begin
  with CheckListBox do begin
    if Tag = 0 then
    begin
      if State[ItemIndex] = cbChecked then
        State[ItemIndex] := cbUnchecked
      else
        State[ItemIndex] := cbChecked;
      CheckListBoxClickCheck(nil);
    end;
    Tag := 0;
  end;
end;

procedure TADUserDlg.PageControlResize(Sender: TObject);
begin
  PageControl.OnResize := nil;
  try
    Height := Height + AccountSheet.Top - AsTop;
    AsTop := AccountSheet.Top;
  finally
    PageControl.OnResize := PageControlResize;
  end;
end;

procedure TADUserDlg.PageControlChanging(Sender: TObject;
  var AllowChange: Boolean);
begin
  if PageControl.ActivePageIndex > 6 then
    Load;
end;

end.

