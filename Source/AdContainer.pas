  {      LDAPAdmin - AadContainer.pas
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

unit AdContainer;

interface

uses
  Windows, Variants,
  LCLIntf, LCLType,
  Messages, SysUtils, Classes, Graphics,
  Controls, Forms, Dialogs, StdCtrls, Connection, LdapClasses, Constant;

type
  TAdContainerDlg = class(TForm)
    Label1: TLabel;
    cn: TEdit;
    Label2: TLabel;
    description: TEdit;
    OkBtn: TButton;
    CancelBtn: TButton;
    procedure cnChange(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    ParentDn: string;
    FEntry: TLdapEntry;
  public
    constructor Create(AOwner: TComponent; adn: string; AConnection: TConnection; Mode: TEditMode); reintroduce;
  end;

var
  AdContainerDlg: TAdContainerDlg;

implementation

{$R *.dfm}

procedure TAdContainerDlg.cnChange(Sender: TObject);
begin
  OkBtn.Enabled := cn.Text <> '';
end;

constructor TAdContainerDlg.Create(AOwner: TComponent; adn: string; AConnection: TConnection; Mode: TEditMode);
begin
  inherited Create(AOwner);

  FEntry := TLDAPEntry.Create(AConnection, adn);
  ParentDn := adn;

  if Mode = EM_MODIFY then
  begin
    FEntry.Read;
    cn.Text := FEntry.AttributesByName['cn'].AsString;
    description.Text := FEntry.AttributesByName['description'].AsString;
    cn.Enabled := False;
    Caption := Format(cPropertiesOf, [cn.Text]);
  end
  else begin
    with FEntry.AttributesByName['objectclass'] do
    begin
      AddValue('top');
      AddValue('container');
    end;
  end;

end;

procedure TAdContainerDlg.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if ModalResult = mrOk then
  begin
    if cn.Text = '' then
      raise Exception.Create(Format(stReqNoEmpty, [cName]));

    if esNew in FEntry.State then
    begin
      FEntry.dn := 'CN=' + EncodeLdapString(cn.Text) + ',' + ParentDn;
      FEntry.AttributesByName['cn'].AsString := cn.Text;
      FEntry.AttributesByName['description'].AsString := description.Text;
    end;
    FEntry.Write;
  end;
  Action := caFree;
end;

end.
