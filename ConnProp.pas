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
  Windows,
{$ELSE}
  LCLIntf, LCLType, LMessages,
{$ENDIF}
  SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
     Buttons, ExtCtrls, Config, ComCtrls, LDAPClasses;

type
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
    procedure cbSASLClick(Sender: TObject);
    procedure cbTLSClick(Sender: TObject);
  private
    FUser:        string;
    FPass:        string;
    FPassEnable:  boolean;
    function      GetBase: string;
    procedure     SetBase(const Value: string);
    function      GetLdapVersion: integer;
    procedure     SetLdapVersion(const Value: integer);
    function      GetAuthMethod: TLdapAuthMethod;
    procedure     SetAuthMethod(const Value: TLdapAuthMethod);
    function      GetUser: string;
    procedure     SetUser(const Value: string);
    function      GetPassword: string;
    procedure     SetPassword(const Value: string);
    function      GetPort: integer;
    procedure     SetPort(const Value: integer);
    function      GetServer: string;
    procedure     SetServer(const Value: string);
    function      GetSSL: boolean;
    procedure     SetSSL(const Value: boolean);
    function      GetTLS: boolean;
    procedure     SetTLS(const Value: boolean);
    function      GetName: string;
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
    function      GetOperationalAttrs: string;
    procedure     SetOperationalAttrs(const Value: string);
    procedure     SetConnectionName(const Value: string);
    procedure     SetPassEnable(const Value: boolean);
  protected
    procedure     DoShow; override;
  public
    constructor   Create(AOwner: TComponent); override;
    property      Name: string read GetName write SetConnectionName;
    property      SSL: boolean read GetSSL write SetSSL;
    property      TLS: boolean read GetTLS write SetTLS;
    property      Port: integer read GetPort write SetPort;
    property      LdapVersion: integer read GetLdapVersion write SetLdapVersion;
    property      AuthMethod: TLdapAuthMethod read GetAuthMethod write SetAuthMethod;
    property      User: string read GetUser write SetUser;
    property      Server: string read GetServer write SetServer;
    property      Base: string read GetBase write SetBase;
    property      Password: string read GetPassword write SetPassword;
    property      PasswordEnable: boolean read FPassEnable write SetPassEnable;
    property      TimeLimit: Integer read GetTimeLimit write SetTimeLimit;
    property      SizeLimit: Integer read GetSizeLimit write SetSizeLimit;
    property      PagedSearch: Boolean read GetPagedSearch write SetPagedSearch;
    property      PageSize: Integer read GetPageSize write SetPageSize;
    property      DereferenceAliases: Integer read GetDerefAliases write SetDerefAliases;
    property      ChaseReferrals: Boolean read GetReferrals write SetReferrals;
    property      ReferralHops: Integer read GetReferralHops write SetReferralHops;
    property      OperationalAttrs: string read GetOperationalAttrs write SetOperationalAttrs;
  end;

var
  ConnPropDlg: TConnPropDlg;

implementation

uses {$ifdef mswindows}WinLDAP,{$else} LinLDAP,{$endif} Constant, Math, Dialogs;

{$IFnDEF FPC}
  {$R *.dfm}
{$ELSE}
  {$R *.lfm}
{$ENDIF}

constructor TConnPropDlg.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Port               := LDAP_PORT;
  LdapVersion        := LDAP_VERSION3;
  TimeLimit          := SESS_TIMEOUT;
  SizeLimit          := SESS_SIZE_LIMIT;
  PagedSearch        := true;
  PageSize           := SESS_PAGE_SIZE;
  ChaseReferrals     := true;
  ReferralHops       := SESS_REFF_HOP_LIMIT;
  DereferenceAliases := LDAP_DEREF_NEVER;
end;

procedure TConnPropDlg.DoShow;
begin
  cbAnonymous.Checked:=(UserEd.Text='');
  FetchDnBtn.Enabled:=VersionCombo.Text='3';
  cbxShowAttrs.Checked := OperationalAttrs <> '';
  inherited;
end;

function TConnPropDlg.GetName: string;
begin
  result:=NameEd.Text;
end;

procedure TConnPropDlg.SetConnectionName(const Value: string);
begin
  NameEd.Text:=Value;
end;

function TConnPropDlg.GetServer: string;
begin
  result:=ServerEd.Text;
end;

procedure TConnPropDlg.SetServer(const Value: string);
begin
  ServerEd.Text:=Value;
end;

function TConnPropDlg.GetBase: string;
begin
  result:=BaseEd.Text;
end;

procedure TConnPropDlg.SetBase(const Value: string);
begin
  BaseEd.Text:=Value;
end;

function TConnPropDlg.GetUser: string;
begin
  result:=UserEd.Text;
end;

procedure TConnPropDlg.SetUser(const Value: string);
begin
  UserEd.Text:=Value;
end;

function TConnPropDlg.GetPassword: string;
begin
  result:=PasswordEd.Text;
end;

procedure TConnPropDlg.SetPassword(const Value: string);
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

function TConnPropDlg.GetPort: integer;
begin
  result:=StrToInt(PortEd.Text);
end;

procedure TConnPropDlg.SetPort(const Value: integer);
begin
  PortEd.Text:=IntToStr(Value);
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

function TConnPropDlg.GetOperationalAttrs: string;
begin
  Result := lbxAttributes.Items.CommaText;
end;

procedure TConnPropDlg.SetOperationalAttrs(const Value: string);
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
    cbSASL.Checked := false;
    cbSASL.Enabled := false;
    cbAnonymous.Caption := cAnonymousConn;
  end
  else begin
    cbSASL.Enabled := true;
    cbAnonymous.Caption := cSASLCurrUser;
  end;
end;

procedure TConnPropDlg.cbAnonymousClick(Sender: TObject);
begin
  UserEd.Enabled:=not cbAnonymous.Checked;
  PasswordEd.Enabled:=not cbAnonymous.Checked;
  Label4.Enabled:=not cbAnonymous.Checked;
  Label5.Enabled:=not cbAnonymous.Checked;

  if cbAnonymous.Checked then begin
    FUser:=UserEd.Text;
    FPass:=PasswordEd.Text;
    UserEd.Text:='';
    PasswordEd.Text:='';
  end
  else begin
    UserEd.Text:=FUser;
    PasswordEd.Text:=FPass;
  end;
end;

(*
procedure TConnPropDlg.FetchDnBtnClick(Sender: TObject);
var
  AList: TStringList;
  ASession: TLDAPSession;
  i,j: integer;

begin
  ASession:=TLDAPSession.Create;
  AList:=TStringList.Create;
  BaseEd.Items.Clear;
  Asession.Server:=ServerEd.Text;
  Asession.SSL:=SSL;
  ASession.AuthMethod:=AuthMethod;
  ASession.Port:= Port;
  ASession.Version:=LDAP_VERSION3;
  ASession.User := UserEd.Text;
  ASession.Password := PasswordEd.Text;


  try
    ASession.Connect;
    ASession.Search('objectClass=*','',LDAP_SCOPE_BASE,['namingContexts'],false,AList);
    for i:=0 to AList.Count-1 do
        begin
            BaseEd.Items.Add(AList[i]);
        end;
    {
    if BaseEd.Items.Count>0 then begin
      BaseEd.Style:=csDropDown;
      BaseEd.DroppedDown:=true;
      //if BaseEd.Text='' then BaseEd.ItemIndex:=0;
    end
    else BaseEd.Style:=csSimple;
    }
    BaseEd.ItemIndex:=0;
    ASession.Disconnect;
  finally
    Asession.Free;
    AList.Free;
  end;
end;
*)


procedure TConnPropDlg.FetchDnBtnClick(Sender: TObject);
var
  AList: TLdapEntryList;
  ASession: TLDAPSession;
  i,j: integer;

begin
  ASession:=TLDAPSession.Create;
  AList:=TLdapEntryList.Create;
  BaseEd.Items.Clear;
  Asession.Server:=ServerEd.Text;
  Asession.SSL:=SSL;
  ASession.AuthMethod:=AuthMethod;
  ASession.Port:= Port;
  ASession.Version:=LDAP_VERSION3;
  ASession.User := UserEd.Text;
  ASession.Password := PasswordEd.Text;

  try
    ASession.Connect;
    ASession.Search('objectClass=*','',LDAP_SCOPE_BASE,['namingContexts'],false,AList);
    for i:=0 to AList.Count-1 do
      for j:=0 to AList[i].AttributesByName['namingContexts'].ValueCount-1 do
        BaseEd.Items.Add(AList[i].AttributesByName['namingContexts'].Values[j].AsString);
    {
    if BaseEd.Items.Count>0 then begin
      BaseEd.Style:=csDropDown;
      BaseEd.DroppedDown:=true;
      if BaseEd.Text='' then BaseEd.ItemIndex:=0;
    end
    else BaseEd.Style:=csSimple;
    }
    BaseEd.ItemIndex:=0;
    ASession.Disconnect;
  finally
    Asession.Free;
    AList.Free;
  end;
end;



procedure TConnPropDlg.VersionComboChange(Sender: TObject);
begin
  FetchDnBtn.Enabled:=VersionCombo.Text='3';
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
  if Value then Label5.Caption:= cPassword
  else Label5.Caption:=stCantStorPass;
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
  s: string;
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
    PortEd.Text := IntToStr(LDAP_SSL_PORT)
  else
    PortEd.Text := IntToStr(LDAP_PORT);
  cbTLS.Enabled := not SSL;
  cbSasl.Enabled := not SSL;
end;

procedure TConnPropDlg.cbSASLClick(Sender: TObject);
begin
  if cbSASL.Checked then
  begin
    cbSSL.Checked := false;
    cbTLS.Checked := false;
  end;
  cbSSL.Enabled := not cbSASL.Checked;
  cbTLS.Enabled := cbSSL.Enabled;
end;

procedure TConnPropDlg.cbTLSClick(Sender: TObject);
begin
  cbSSL.Enabled := not TLS;
  cbSASL.Enabled := not TLS;
end;

end.
