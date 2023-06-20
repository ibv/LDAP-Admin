  {      LDAPAdmin - Computer.pas
  *      Copyright (C) 2003-2012 Tihomir Karlovic
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

unit Computer;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
  LCLIntf, LCLType,
  SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ExtCtrls, LDAPClasses, Samba, Posix, Config,
  Constant, Connection, mormot.core.base;

type
  TComputerDlg = class(TForm)
    OKBtn: TButton;
    CancelBtn: TButton;
    Bevel1: TBevel;
    edComputername: TEdit;
    Label1: TLabel;
    edDescription: TEdit;
    Label2: TLabel;
    cbDomain: TComboBox;
    Label3: TLabel;
    procedure edComputernameChange(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
  private
    Connection: TConnection;
    DomList: TDomainList;
    Entry: TLdapEntry;
    Account: TSamba3Computer;
  public
    constructor Create(AOwner: TComponent; adn: RawUtf8; AConnection: TConnection; AMode: TEditMode); reintroduce;
  end;

var
  ComputerDlg: TComputerDlg;

implementation

{$R *.dfm}

constructor TComputerDlg.Create(AOwner: TComponent; adn: RawUtf8; AConnection: TConnection; AMode: TEditMode);
var
  i: Integer;
begin
  inherited Create(AOwner);
  Connection := AConnection;
  Entry := TLdapEntry.Create(AConnection, adn);
  Account := TSamba3Computer.Create(Entry);
  if AMode = EM_MODIFY then
  begin
    Entry.Read;
    with Account do
    begin
      if DomainName <> '' then
        cbDomain.Items.Add(DomainName);
      cbDomain.ItemIndex := 0;
      cbDomain.Enabled := false;
      edDescription.text := Description;
    end;
    edComputername.Enabled := False;
    edComputername.Text := GetNameFromDN(adn);
    Caption := Format(cPropertiesOf, [edComputername.Text]);
  end
  else begin
    DomList := TDomainList.Create(AConnection);
    with cbDomain do
    begin
      for i := 0 to DomList.Count - 1 do
        Items.Add(DomList.Items[i].DomainName);
      ItemIndex := Items.IndexOf(Connection.Account.ReadString(rSambaDomainName));
      if ItemIndex = -1 then
        ItemIndex := 0;
    end;
  end;
end;

procedure TComputerDlg.edComputernameChange(Sender: TObject);
begin
  OKBtn.Enabled := (edComputername.Text <> '') and (cbDomain.ItemIndex <> -1);
end;

procedure TComputerDlg.FormClose(Sender: TObject; var Action: TCloseAction);
var
  uidnr: Integer;
begin
  if ModalResult = mrOk then
  begin
    if esNew in Entry.State then
    begin
      with Account do
      begin
        New;
        ComputerName := edComputername.Text;
        DomainData := DomList.Items[cbDomain.ItemIndex];
        // Acquire next available uidNumber
        uidnr := Connection.GetUid;
        if uidnr <> -1 then
          UidNumber := uidnr;
        GidNumber := COMPUTER_GROUP;
        Entry.dn := 'uid=' + ComputerName + ',' + Entry.dn;
      end;
    end;
    if edDescription.Modified then
      Account.Description := Self.edDescription.Text;
    Entry.Write;
  end;
  Action := caFree;
end;

procedure TComputerDlg.FormDestroy(Sender: TObject);
begin
  Entry.Free;
  Account.Free;
end;

end.
