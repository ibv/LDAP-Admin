  {      LDAPAdmin - Transport.pas
  *      Copyright (C) 2003-2005 Tihomir Karlovic
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

unit Transport;

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
  Buttons, ExtCtrls, LDAPClasses, Constant, mormot.core.base;

type
  TTransportDlg = class(TForm)
    OKBtn: TButton;
    CancelBtn: TButton;
    Bevel1: TBevel;
    cn: TEdit;
    Label1: TLabel;
    transport: TEdit;
    Label2: TLabel;
    procedure AttributeChange(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
  private
    dn: RawUtf8;
    Entry: TLDAPEntry;
  public
    constructor Create(AOwner: TComponent; dn: RawUtf8; Session: TLDAPSession; Mode: TEditMode); reintroduce;
  end;

var
  TransportDlg: TTransportDlg;

implementation

{$R *.dfm}

uses LinLDAP;

constructor TTransportDlg.Create(AOwner: TComponent; dn: RawUtf8; Session: TLDAPSession; Mode: TEditMode);
begin
  inherited Create(AOwner);
  Self.dn := dn;
  Entry := TLDAPEntry.Create(Session, dn);
  if Mode = EM_ADD then
  begin
    Entry.AttributesByName['objectclass'].AddValue('top');
    Entry.AttributesByName['objectclass'].AddValue('transportTable');
  end
  else begin
    Entry.Read;
    cn.Enabled := False;
    cn.Text := Entry.AttributesByName['cn'].AsString;
    transport.Text := Entry.AttributesByName['transport'].AsString;
  end;
end;

procedure TTransportDlg.AttributeChange(Sender: TObject);
begin
  OKBtn.Enabled := (cn.Text <> '') and (transport.Modified) and (transport.Text <> '');
  with Sender as TEdit do
    Entry.AttributesByName[Name].AsString := Text;
end;

procedure TTransportDlg.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if ModalResult = mrOk then
  begin
    if esNew in Entry.State then
      Entry.dn := 'cn=' + cn.Text + ',' + Self.dn;
    Entry.Write;
  end;
  Action := caFree;
end;

procedure TTransportDlg.FormDestroy(Sender: TObject);
begin
  Entry.Free;
end;

end.
