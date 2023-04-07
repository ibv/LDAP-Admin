  {      LDAPAdmin - ADPassdlg.pas
  *      Copyright (C) 2012-2016 Tihomir Karlovic
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

unit ADPassDlg;

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
  SysUtils, Classes, Graphics, Forms, Controls, StdCtrls, Buttons,
  LDAPClasses, mormot.core.base;

type
  TADPassDlg = class(TForm)
    Label1: TLabel;
    Password: TEdit;
    OKBtn: TButton;
    CancelBtn: TButton;
    Password2: TEdit;
    Label2: TLabel;
    cbxPwdNeverExpires: TCheckBox;
    cbxPwdMustChange: TCheckBox;
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
    fEntry: TLdapEntry;
  public
    constructor Create(AOwner: TComponent; Entry: TLdapEntry); reintroduce;
  end;

var
  PasswordDlg: TADPassDlg;

implementation

{$R *.dfm}
{.$DEFINE USE_ADSIE}



uses
{$IFDEF USE_ADSIE}
  ActiveDs_TLB, adsie,
{$ELSE}
  AdObjects,
  {$IFnDEF FPC}
  WinLdap
  {$ENDIF}
  LinLDAP, mormot.net.ldap,
{$ENDIF}
  Constant {$IFNDEF UNICODE}, Misc{$ENDIF};

constructor TADPassDlg.Create(AOwner: TComponent; Entry: TLdapEntry);
begin
  inherited Create(AOwner);
  fEntry := Entry;
  {$IFDEF USE_ADSIE}
  with Entry.Session do
  begin
    fLdapPath := 'LDAP://' + Server + '/' + Entry.dn;
    fUserName := User;
    fPassword := Password;
  end;
  {$ENDIF}
end;

procedure TADPassDlg.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
{$IFDEF USE_ADSIE}
var
  User: IADSUser;
begin
  if (ModalResult = mrOk) then
  begin
    if Password.Text <> Password2.Text then
      raise Exception.Create(stPassDiff);
    try
      ADOpenObject(fLdapPath, fUserName, fPassword, IID_IADsUser, User);
      User.setpassword(Password.Text);
    finally
      User := nil;
    end;
  end;
end;
{$ELSE}
var
  uacValue: RawUtf8;
  uacFlags: Cardinal;
begin
  if (ModalResult = mrOk) then
  begin
    if Password.Text <> Password2.Text then
      raise Exception.Create(stPassDiff);

    fEntry.AdSetPassword(Password.Text);

    if cbxPwdNeverExpires.Checked then
    begin
      uacValue := fEntry.Session.Lookup(fEntry.dn, 'objectclass=user', 'userAccountControl', lssBaseObject);
      uacFlags := UF_DONT_EXPIRE_PASSWORD;
      if uacValue <> '' then
        uacFlags := uacFlags or StrToInt(uacValue);
      fEntry.AttributesByName['userAccountControl'].AsString := IntToStr(uacFlags);
    end;

    if cbxPwdMustChange.Checked then with fEntry.AttributesByName['pwdLastSet'] do
    begin
      AsString := '0';
      { Order of execution is important, pwdLastSet must be modifed after the UnicodePwd was set }
      MoveIndex(fEntry.Attributes.Count - 1);
    end;

    try
      fEntry.Write;
    except
      on E: ERRLdap do
        if (E.ErrorCode = LDAP_UNWILLING_TO_PERFORM) then with fEntry do
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
end;
{$ENDIF}

end.

