  {      LDAPAdmin - ADPassdlg.pas
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
     LDAPClasses;

type
  TADPassDlg = class(TForm)
    Label1: TLabel;
    Password: TEdit;
    OKBtn: TButton;
    CancelBtn: TButton;
    Password2: TEdit;
    Label2: TLabel;
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
    fEntry: TLdapEntry;
    fLdapPath: WideString;
    fUsername: wideString;
    fPassword: WideString;
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
  {$IFnDEF FPC}
  AdObjects,
  {$ENDIF}
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
  Pwd: Widestring;
  val: TLdapAttributeData;
begin
  if (ModalResult = mrOk) then
  begin
    if Password.Text <> Password2.Text then
      raise Exception.Create(stPassDiff);
    ///fEntry.SetPassword(Password.Text);
    ///fEntry.Write;
  end;
end;
{$ENDIF}

end.

