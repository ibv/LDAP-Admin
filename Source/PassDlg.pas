  {      LDAPAdmin - Passdlg.pas
  *      Copyright (C) 2003-2013 Tihomir Karlovic
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

unit PassDlg;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
  LCLIntf, LCLType,
  SysUtils, Classes, Graphics, Forms, Controls, StdCtrls, Buttons,
     LDAPClasses, Password, Samba, ExtCtrls, mormot.core.base;

const
  sUserPassword = 'userPassword';

type
  TPasswordDlg = class(TForm)
    Label1: TLabel;
    Password: TEdit;
    OKBtn: TButton;
    CancelBtn: TButton;
    Password2: TEdit;
    Label2: TLabel;
    cbMethod: TComboBox;
    lbMethod: TLabel;
    cbSambaPassword: TCheckBox;
    cbPosixPassword: TCheckBox;
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure cbPosixPasswordClick(Sender: TObject);
  private
    fEntry: TLdapEntry;
    fSamba: TSamba3Account;
    fPasswordAttribute: RawUtf8;
    fDefaultHashType: Integer;
  public
    constructor Create(AOwner: TComponent; Entry: TLdapEntry; const AttributeName: RawUtf8 = sUserPassword); reintroduce;
  end;

var
  PasswordDlg: TPasswordDlg;

implementation

{$R *.dfm}

uses Config, Constant, Connection;

constructor TPasswordDlg.Create(AOwner: TComponent; Entry: TLdapEntry; const AttributeName: RawUtf8 = sUserPassword);
begin
  inherited Create(AOwner);
  if Entry.Attributes.Count <= 1 then
    Entry.Read;
  fPasswordAttribute := AttributeName;
  fDefaultHashType := (Entry.Session as TConnection).Account.ReadInteger(rPosixPwdHashType, Integer(chSha1));
  if (fDefaultHashType < 0) or (fDefaultHashType >= cbMethod.Items.Count) then
    fDefaultHashType := Integer(chSha1);
  cbMethod.ItemIndex := fDefaultHashType;
  fEntry := Entry;
  if (AnsiCompareText(AttributeName, sUserPassword) = 0) and
     (Entry.AttributesByName['objectclass'].IndexOf('sambasamaccount') <> -1) then
  begin
    cbPosixPassword.Visible := true;
    cbSambaPassword.Visible := true;
  end
  else
    cbSambaPassword.Checked := false;
end;

procedure TPasswordDlg.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  if (ModalResult = mrOk) then
  begin
    if Password.Text <> Password2.Text then
      raise Exception.Create(stPassDiff);
    if cbSambaPassword.Checked then
    begin
      fSamba := TSamba3Account.Create(fEntry);
      try
        if (fEntry.Session as TConnection).Account.ReadBool(rSambaLMPasswords) then
          fSamba.LMPasswords := true;
        fSamba.SetUserPassword(Password.Text);
      finally
        fSamba.Free;
      end;
    end;
    if cbPosixPassword.Checked then
      fEntry.AttributesByName[fPasswordAttribute].AsString := GetPasswordString(THashType(cbMethod.ItemIndex), Password.Text);
    if fDefaultHashType <> cbMethod.ItemIndex then
      (fEntry.Session as TConnection).Account.WriteInteger(rPosixPwdHashType, cbMethod.ItemIndex);
  end;
end;

procedure TPasswordDlg.cbPosixPasswordClick(Sender: TObject);
begin
  cbMethod.Enabled := cbPosixPassword.Checked;
end;

end.

