  {      LDAPAdmin - Connprop.pas
  *      Copyright (C) 2003-2012 Tihomir Karlovic
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

unit ConnProp;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
{$IFnDEF FPC}
  Windows, Validator,
{$ELSE}
  LCLIntf, LCLType,
{$ENDIF}
  SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
  Messages, Buttons, ExtCtrls, Config, ComCtrls, LDAPClasses,Constant, Connection,
  mormot.core.base;

type

  { TConnPropDlg }

  TConnPropDlg = class(TForm)
    OKBtn:        TButton;
    CancelBtn:    TButton;
    NameEd:       TEdit;
    Label1:       TLabel;
    AccountBox:   TGroupBox;
    Label4:       TLabel;
    UserEd:       TEdit;
    Label5:       TLabel;
    PasswordEd:   TEdit;
    cbAnonymous: TCheckBox;
    ConnectionBox: TGroupBox;
    Label2:       TLabel;
    ServerEd:     TEdit;
    Label3:       TLabel;
    PortEd:       TEdit;
    VersionCombo: TComboBox;
    Label7:       TLabel;
    Label6:       TLabel;
    FetchDnBtn:   TBitBtn;
    Panel1:       TPanel;
    BaseEd:       TComboBox;
    TestBtn:      TButton;
    Panel2: TPanel;
    ButtonsPnl: TPanel;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    GroupBox1: TGroupBox;
    Label15: TLabel;
    Label14: TLabel;
    edTimeLimit: TEdit;
    Label13: TLabel;
    edSizeLimit: TEdit;
    cbxPagedSearch: TCheckBox;
    edPageSize: TEdit;
    GroupBox2: TGroupBox;
    Label10: TLabel;
    Label11: TLabel;
    cbReferrals: TComboBox;
    edReferralHops: TEdit;
    Label8: TLabel;
    cbDerefAliases: TComboBox;
    TabSheet3: TTabSheet;
    cbxShowAttrs: TCheckBox;
    lbxAttributes: TListBox;
    btnAdd: TButton;
    btnRemove: TButton;
    rbSimpleAuth: TRadioButton;
    rbGssApi: TRadioButton;
    cbSSL: TCheckBox;
    cbSASL: TCheckBox;
    cbTLS: TCheckBox;
    GroupBox3: TGroupBox;
    Label9: TLabel;
    cbDirectoryType: TComboBox;
    procedure     MethodChange(Sender: TObject);
    procedure     cbAnonymousClick(Sender: TObject);
    procedure     FetchDnBtnClick(Sender: TObject);
    procedure     VersionComboChange(Sender: TObject);
    procedure     TestBtnClick(Sender: TObject);
    procedure     ValidateInput(Sender: TObject);
    procedure     cbxPagedSearchClick(Sender: TObject);
    procedure     cbReferralsClick(Sender: TObject);
    procedure     cbxShowAttrsClick(Sender: TObject);
    procedure     btnAddClick(Sender: TObject);
    procedure     btnRemoveClick(Sender: TObject);
    procedure     cbSSLClick(Sender: TObject);
    procedure     cbSASLClick(Sender: TObject);
    procedure     cbTLSClick(Sender: TObject);
    procedure     FormClose(Sender: TObject; var Action: TCloseAction);
    procedure     cbDirectoryTypeChange(Sender: TObject);
    procedure     WMWindowPosChanged(var AMessage: TMessage); message WM_WINDOWPOSCHANGED;
    procedure     WMActivateApp(var AMessage: TMessage); message WM_ACTIVATE;
    procedure     ActiveControlChanged(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    FUser:        RawUtf8;
    FPass:        RawUtf8;
    FPassEnable:  boolean;
    FFolder:      TAccountFolder;
    FEditMode:    TEditMode;
    ///FNameValidator: TValidateInput;
    ///FHostValidator: TValidateInput;
    //FBase:        TEncodedDn; ???
    function      GetBase: RawUtf8;
    procedure     SetBase(const Value: RawUtf8);
    function      GetLdapVersion: integer;
    procedure     SetLdapVersion(const Value: integer);
    function      GetAuthMethod: TLdapAuthMethod;
    procedure     SetAuthMethod(const Value: TLdapAuthMethod);
    function      GetUser: RawUtf8;
    procedure     SetUser(const Value: RawUtf8);
    function      GetPassword: RawUtf8;
    procedure     SetPassword(const Value: RawUtf8);
    function      GetPort: RawUtf8;
    procedure     SetPort(const Value: RawUtf8);
    function      GetServer: RawUtf8;
    procedure     SetServer(const Value: RawUtf8);
    function      GetSSL: boolean;
    procedure     SetSSL(const Value: boolean);
    function      GetTLS: boolean;
    procedure     SetTLS(const Value: boolean);
    function      GetName: RawUtf8;
    function      GetTimeLimit: Integer;
    procedure     SetTimeLimit(const Value: Integer);
    function      GetSizeLimit: Integer;
    procedure     SetSizeLimit(const Value: Integer);
    function      GetPagedSearch: boolean;
    procedure     SetPagedSearch(const Value: boolean);
    function      GetPageSize: Integer;
    procedure     SetPageSize(const Value: Integer);
    function      GetDerefAliases: Integer;
    procedure     SetDerefAliases(const Value: Integer);
    function      GetReferrals: boolean;
    procedure     SetReferrals(const Value: boolean);
    function      GetReferralHops: Integer;
    procedure     SetReferralHops(const Value: Integer);
    function      GetOperationalAttrs: RawUtf8;
    procedure     SetOperationalAttrs(const Value: RawUtf8);
    procedure     SetConnectionName(const Value: RawUtf8);
    procedure     SetPassEnable(const Value: boolean);
    function      GetDirectoryType: TDirectoryType;
    procedure     SetDirectoryType(Value: TDirectoryType);
    function      CustomValidate(Control: TCustomEdit): Integer;
  protected
    procedure     DoShow; override;
  public
    constructor   Create(AOwner: TComponent; AFolder: TAccountFolder; EditMode: TEditMode); reintroduce;
    property      Name: RawUtf8 read GetName write SetConnectionName;
    property      SSL: boolean read GetSSL write SetSSL;
    property      TLS: boolean read GetTLS write SetTLS;
    property      Port: RawUtf8 read GetPort write SetPort;
    property      LdapVersion: integer read GetLdapVersion write SetLdapVersion;
    property      AuthMethod: TLdapAuthMethod read GetAuthMethod write SetAuthMethod;
    property      User: RawUtf8 read GetUser write SetUser;
    property      Server: RawUtf8 read GetServer write SetServer;
    property      Base: RawUtf8 read GetBase write SetBase;
    property      Password: RawUtf8 read GetPassword write SetPassword;
    property      PasswordEnable: boolean read FPassEnable write SetPassEnable;
    property      TimeLimit: Integer read GetTimeLimit write SetTimeLimit;
    property      SizeLimit: Integer read GetSizeLimit write SetSizeLimit;
    property      PagedSearch: Boolean read GetPagedSearch write SetPagedSearch;
    property      PageSize: Integer read GetPageSize write SetPageSize;
    property      DereferenceAliases: Integer read GetDerefAliases write SetDerefAliases;
    property      ChaseReferrals: Boolean read GetReferrals write SetReferrals;
    property      ReferralHops: Integer read GetReferralHops write SetReferralHops;
    property      OperationalAttrs: RawUtf8 read GetOperationalAttrs write SetOperationalAttrs;
    property      DirectoryType: TDirectoryType read GetDirectoryType write SetDirectoryType;
  end;

var
  ConnPropDlg: TConnPropDlg;

implementation

uses LinLDAP, Math, Dialogs, Misc, mormot.net.ldap;

{$R *.dfm}

procedure TConnPropDlg.WMActivateApp(var AMessage: TMessage);
begin
  ///FNameValidator.HideHint;
  ///FHostValidator.HideHint;
  inherited;
end;
procedure TConnPropDlg.WMWindowPosChanged(var AMessage: TMessage);
begin
  ///FNameValidator.HideHint;
  ///FHostValidator.HideHint;
  inherited;
end;

procedure TConnPropDlg.ActiveControlChanged(Sender: TObject);
begin
  ///FNameValidator.HideHint;
  ///FHostValidator.HideHint;
end;

constructor TConnPropDlg.Create(AOwner: TComponent; AFolder: TAccountFolder; EditMode: TEditMode);
begin
  inherited Create(AOwner);
  FFolder := AFolder;
  FEditMode := EditMode;
  Port               := LDAP_PORT;
  LdapVersion        := LDAP_VERSION3;
  TimeLimit          := SESS_TIMEOUT;
  SizeLimit          := SESS_SIZE_LIMIT;
  PagedSearch        := true;
  PageSize           := SESS_PAGE_SIZE;
  ChaseReferrals     := true;
  ReferralHops       := SESS_REFF_HOP_LIMIT;
  DereferenceAliases := LDAP_DEREF_NEVER;
  DirectoryType      := dtAutodetect;
  ///FNameValidator.Attach(NameEd);
  ///FNameValidator.Caption := Label1.Caption;
  ///FNameValidator.InvalidChars := '<>\';
  ///FHostValidator.Attach(ServerEd);
  ///FHostValidator.Caption := cHostName;
  ///FHostValidator.CustomValidate := CustomValidate;
  Screen.OnActiveControlChange := ActiveControlChanged;
end;

procedure TConnPropDlg.DoShow;
begin
  cbAnonymous.Checked:=(UserEd.Text='');
  FetchDnBtn.Enabled:=VersionCombo.Text='3';
  cbxShowAttrs.Checked := OperationalAttrs <> '';
  inherited;
end;

function TConnPropDlg.GetName: RawUtf8;
begin
  result := Trim(NameEd.Text);
end;

procedure TConnPropDlg.SetConnectionName(const Value: RawUtf8);
begin
  NameEd.Text := Trim(Value);
end;

function TConnPropDlg.GetServer: RawUtf8;
begin
  result:=ServerEd.Text;
end;

procedure TConnPropDlg.SetServer(const Value: RawUtf8);
begin
  ServerEd.Text := Trim(Value);
end;

function TConnPropDlg.GetBase: RawUtf8;
begin
  result:=BaseEd.Text;
end;

procedure TConnPropDlg.SetBase(const Value: RawUtf8);
begin
  BaseEd.Text := Trim(Value);
end;

function TConnPropDlg.GetUser: RawUtf8;
begin
  result:=UserEd.Text;
end;

procedure TConnPropDlg.SetUser(const Value: RawUtf8);
begin
  UserEd.Text:=Value;
end;

function TConnPropDlg.GetPassword: RawUtf8;
begin
  result:=PasswordEd.Text;
end;

procedure TConnPropDlg.SetPassword(const Value: RawUtf8);
begin
  PasswordEd.Text:=Value;
end;

function TConnPropDlg.GetLdapVersion: integer;
begin
  result:=StrToInt(VersionCombo.Text);
end;

procedure TConnPropDlg.SetLdapVersion(const Value: integer);
begin
  VersionCombo.ItemIndex := Value - 2;
end;

function TConnPropDlg.GetAuthMethod: TLdapAuthMethod;
begin
  if rbSimpleAuth.Checked then
    Result := AUTH_SIMPLE
  else
  if cbSASL.Checked then
    Result := AUTH_GSS_SASL
  else
    Result := AUTH_GSS;
end;

procedure TConnPropDlg.SetAuthMethod(const Value: TLdapAuthMethod);
begin
  rbSimpleAuth.Checked := Value = AUTH_SIMPLE;
  rbGssApi.Checked := not rbSimpleAuth.Checked;

  if Value = AUTH_SIMPLE then
    rbSimpleAuth.Checked := true
  else begin
    rbSimpleAuth.Checked := false;
    if Value = AUTH_GSS_SASL then
      cbSASL.Checked := true
  end;
  MethodChange(nil);
end;

function TConnPropDlg.GetPort: RawUtf8;
begin
  result:=PortEd.Text;
end;

procedure TConnPropDlg.SetPort(const Value: RawUtf8);
begin
  PortEd.Text:=Value;
end;

function TConnPropDlg.GetSSL: boolean;
begin
  result:= cbSSL.Checked;
end;

function TConnPropDlg.GetTLS: boolean;
begin
  result:= cbTLS.Checked;
end;

procedure TConnPropDlg.SetSSL(const Value: boolean);
begin
  cbSSL.Checked:=Value;
end;

procedure TConnPropDlg.SetTLS(const Value: boolean);
begin
  cbTLS.Checked:=Value;
end;

function TConnPropDlg.GetTimeLimit: Integer;
begin
  Result := StrToInt(edTimeLimit.Text);
end;

procedure TConnPropDlg.SetTimeLimit(const Value: Integer);
begin
  edTimeLimit.Text := IntToStr(Value);
end;

function TConnPropDlg.GetSizeLimit: Integer;
begin
  Result := StrToInt(edSizeLimit.Text);
end;

procedure TConnPropDlg.SetSizeLimit(const Value: Integer);
begin
  edSizeLimit.Text := IntToStr(Value);
end;

function TConnPropDlg.GetPagedSearch: boolean;
begin
  Result := cbxPagedSearch.Checked;
  cbxPagedSearchClick(nil);
end;

procedure TConnPropDlg.SetPagedSearch(const Value: boolean);
begin
  cbxPagedSearch.Checked := Value;
  cbxPagedSearchClick(nil);
end;

function TConnPropDlg.GetPageSize: Integer;
begin
  Result := StrToInt(edPageSize.Text);
end;

procedure TConnPropDlg.SetPageSize(const Value: Integer);
begin
  edPageSize.Text := IntToStr(Value);
end;

function TConnPropDlg.GetDerefAliases: Integer;
begin
  Result := cbDerefAliases.ItemIndex;
end;

procedure TConnPropDlg.SetDerefAliases(const Value: Integer);
begin
  cbDerefAliases.ItemIndex := Value;
end;

function TConnPropDlg.GetReferrals: boolean;
begin
  result := cbReferrals.ItemIndex = 0;
  cbReferralsClick(nil);
end;

procedure TConnPropDlg.SetReferrals(const Value: boolean);
begin
  cbReferrals.ItemIndex := Ord(not Value);
  cbReferralsClick(nil);
end;

function TConnPropDlg.GetReferralHops: Integer;
begin
  Result := StrToInt(edReferralHops.Text);
end;

procedure TConnPropDlg.SetReferralHops(const Value: Integer);
begin
  edReferralHops.Text := IntToStr(Value);
end;

function TConnPropDlg.GetOperationalAttrs: RawUtf8;
begin
  Result := lbxAttributes.Items.CommaText;
end;

procedure TConnPropDlg.SetOperationalAttrs(const Value: RawUtf8);
begin
  lbxAttributes.Items.CommaText := Value;
end;

procedure TConnPropDlg.ValidateInput(Sender: TObject);
begin
  StrToInt((Sender as TEdit).Text);
end;

procedure TConnPropDlg.MethodChange(Sender: TObject);
begin
  if AuthMethod = AUTH_SIMPLE then
  begin
    cbSSL.Enabled := true;
    cbTLS.Enabled := true;
    cbSASL.Checked := false;
    cbSASL.Enabled := false;
    cbAnonymous.Caption := cAnonymousConn;
  end
  else begin
    cbSASL.Enabled := true;
    cbSSL.Enabled := false;
    cbSSL.Checked := false;
    cbTLS.Enabled := false;
    cbTLS.Checked := false;
    cbAnonymous.Caption := cSASLCurrUser;
  end;
end;

procedure TConnPropDlg.cbAnonymousClick(Sender: TObject);
begin
  UserEd.Enabled := not cbAnonymous.Checked;
  PasswordEd.Enabled := not cbAnonymous.Checked;
  Label4.Enabled := not cbAnonymous.Checked;
  Label5.Enabled := not cbAnonymous.Checked;

  if cbAnonymous.Checked then begin
    FUser := UserEd.Text;
    FPass := PasswordEd.Text;
    UserEd.Text := '';
    PasswordEd.Text := '';
  end
  else begin
    UserEd.Text := FUser;
    PasswordEd.Text := FPass;
  end;
end;

procedure TConnPropDlg.cbDirectoryTypeChange(Sender: TObject);
var
  r, w: Boolean;
begin
  if DirectoryType = dtAutodetect then
    exit;
  r := GlobalConfig.ReadBool(rWarnDTAutodetect, false);
  if not r then
  begin
    w := false;
    CheckedMessageDlg(stAutodetectDT, mtWarning, [mbOk], stDoNotShowAgain, w);
    if w then
      GlobalConfig.WriteBool(rWarnDTAutodetect, true);
  end;
end;

procedure TConnPropDlg.FetchDnBtnClick(Sender: TObject);
var
  AList: TLdapEntryList;
  ASession: TLDAPSession;
  i,j: integer;

begin
  ASession := TLDAPSession.Create;
  AList := TLdapEntryList.Create;
  BaseEd.Items.Clear;
  Asession.Server := ServerEd.Text;
  Asession.TLS := TLS;
  Asession.SSL := SSL;
  ASession.AuthMethod := AuthMethod;
  ASession.Port := Port;
  ASession.Version := LDAP_VERSION3;
  ASession.User := UserEd.Text;
  ASession.Password := PasswordEd.Text;

  try
    ASession.Connect;
    ASession.Search('objectClass=*','',lssBaseObject,['namingContexts'],false,AList);
    for i:=0 to AList.Count-1 do
      for j:=0 to AList[i].AttributesByName['namingContexts'].ValueCount-1 do
        BaseEd.Items.Add(AList[i].AttributesByName['namingContexts'].Values[j].AsString);

    if BaseEd.Items.Count > 0 then begin
      BaseEd.Style := csDropDown;
      BaseEd.DroppedDown := true;
      if BaseEd.Text = '' then
        BaseEd.ItemIndex := 0;
    end
    else BaseEd.Style:=csSimple;

    ASession.Disconnect;
  finally
    Asession.Free;
    AList.Free;
  end;
end;

procedure TConnPropDlg.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if (ModalResult = mrOk) then
  begin
    if Name = '' then
      raise Exception.Create(stAccntNameReq);
    if (FEditMode = EM_ADD) and (FFolder.Items.AccountByName(Name) <> nil) then
      raise Exception.CreateFmt(stAccntExist, [Name]);
  end;
end;

procedure TConnPropDlg.FormDestroy(Sender: TObject);
begin
  Screen.OnActiveControlChange := nil;
end;

procedure TConnPropDlg.VersionComboChange(Sender: TObject);
begin
  FetchDnBtn.Enabled := VersionCombo.Text = '3';
end;

procedure TConnPropDlg.TestBtnClick(Sender: TObject);
var
  Asession: TLDAPSession;
begin
  Asession:=TLDAPSession.Create;
  try
    ASession.Server     := self.Server;
    ASession.Port       := self.Port;
    ASession.Version    := self.LdapVersion;
    ASession.Base       := self.Base;
    ASession.User       := self.User;
    ASession.Password   := self.Password;
    ASession.AuthMethod := self.AuthMethod;
    ASession.SSL        := Self.SSL;
    ASession.TLS        := Self.TLS;

    Screen.Cursor:=crHourGlass;
    Asession.Connect;
    Application.MessageBox(PChar(stConnectSuccess), pchar(Application.Title), MB_ICONINFORMATION+ MB_OK);
  finally
    Screen.Cursor:=crDefault;
    Asession.Free;
  end;
end;

procedure TConnPropDlg.SetPassEnable(const Value: boolean);
begin
  FPassEnable := Value;
  PasswordEd.Visible:=Value;
  if Value then
  begin
    Label5.Font.Color := clWindowText;
    Label5.Caption:= cPassword;
  end
  else begin
    Label5.Font.Color := clGrayText;
    Label5.Caption:=stCantStorPass;
  end;
end;

function TConnPropDlg.GetDirectoryType: TDirectoryType;
begin
  case cbDirectoryType.ItemIndex of
    0: Result := dtAutodetect;
    1: Result := dtPosix;
    2: Result := dtActiveDirectory;
  else
    Assert(false);
  end;
end;

procedure TConnPropDlg.SetDirectoryType(Value: TDirectoryType);
begin
  with cbDirectoryType do
  case Value of
    dtAutodetect:      ItemIndex := 0;
    dtPosix:           ItemIndex := 1;
    dtActiveDirectory: ItemIndex := 2;
  else
    Assert(false);
  end;
end;

procedure TConnPropDlg.cbxPagedSearchClick(Sender: TObject);
begin
  if cbxPagedSearch.Checked then
  begin
    edPageSize.Enabled := true;
    edPageSize.Color := clWindow;
  end
  else begin
    edPageSize.Enabled := false;
    edPageSize.Color := clBtnFace;
  end;
end;

procedure TConnPropDlg.cbReferralsClick(Sender: TObject);
begin
  if cbReferrals.ItemIndex = 0 then
  begin
    edReferralHops.Enabled := true;
    edReferralHops.Color := clWindow;
  end
  else begin
    edReferralHops.Enabled := false;
    edReferralHops.Color := clBtnFace;
  end;
end;

procedure TConnPropDlg.cbxShowAttrsClick(Sender: TObject);
begin
  if cbxShowAttrs.Checked then
  begin
    lbxAttributes.Enabled := true;
    lbxAttributes.Color := clWindow;
    btnAdd.Enabled := true;
    btnRemove.Enabled := true;
    if lbxAttributes.Items.Count = 0 then
      lbxAttributes.Items.CommaText := StandardOperationalAttributes;
  end
  else begin
    lbxAttributes.Enabled := false;
    lbxAttributes.Color := clBtnFace;
    btnAdd.Enabled := false;
    btnRemove.Enabled := false;
    lbxAttributes.Clear;
  end;
end;

procedure TConnPropDlg.btnAddClick(Sender: TObject);
var
  s: RawUtf8;
begin
  s := InputBox(cAddAttribute, cAttributeName, '');
  if s <> '' then
  begin
    lbxAttributes.Items.Add(s);
    btnRemove.Enabled := true;
  end;
end;

procedure TConnPropDlg.btnRemoveClick(Sender: TObject);
var
  i: Integer;
begin
  i := lbxAttributes.ItemIndex;
  if i <> -1 then
  begin
    lbxAttributes.Items.Delete(i);
    if i = lbxAttributes.Items.Count then
      dec(i);
    lbxAttributes.ItemIndex := i;
    btnRemove.Enabled := lbxAttributes.ItemIndex <> -1;
  end;
end;

procedure TConnPropDlg.cbSSLClick(Sender: TObject);
begin
  if SSL then
  begin
    PortEd.Text := IntToStr(LDAP_SSL_PORT);
    cbTLS.Checked := false;
  end
  else
    PortEd.Text := LDAP_PORT;
end;

procedure TConnPropDlg.cbSASLClick(Sender: TObject);
begin
  if cbSASL.Checked then
  begin
    cbSSL.Checked := false;
    cbTLS.Checked := false;
  end;
end;

procedure TConnPropDlg.cbTLSClick(Sender: TObject);
begin
  if TLS then
    cbSSL.Checked := false;
end;

function TConnPropDlg.CustomValidate(Control: TCustomEdit): Integer;
var
  i: Integer;
  s, InvalidChars: RawUtf8;
begin
  Result := 0;
  s := Trim(Control.Text);
  InvalidChars := '';
  i := Length(s);
  while i > 0 do begin
    if not (s[i] in ['a'..'z', 'A'..'Z', '0'..'9', '-', '.']) then
    begin
      InvalidChars := InvalidChars + s[i];
      Delete(s, i, 1);
      if Result = 0 then
        Result := i;
    end;
    dec(i);
  end;
  if Result <> 0 then
  begin
    Control.Text := s;
    Control.SelStart := Result - 1;
    ///FHostValidator.InvalidChars := InvalidChars;
  end;
end;

end.
