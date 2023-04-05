  {      LDAPAdmin - Locality.pas
  *      Copyright (C) 2003 Tihomir Karlovic
  *
  *      Author: Simon Zsolt
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

unit Locality;

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
  Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, LDAPClasses, Constant;

type
  TLocalityDlg = class(TForm)
    NameLabel: TLabel;
    l: TEdit;
    GroupBox1: TGroupBox;
    Label18: TLabel;
    Label19: TLabel;
    street: TMemo;
    st: TEdit;
    Label1: TLabel;
    description: TEdit;
    OKBtn: TButton;
    CancelBtn: TButton;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
  private
    Entry: TLDAPEntry;
    procedure Save;
  public
    constructor Create(AOwner: TComponent; dn: string; Session: TLDAPSession; Mode: TEditMode); reintroduce;
  end;

var
  LocalityDlg: TLocalityDlg;

implementation

uses Misc, LinLDAP;

{$R *.dfm}

procedure TLocalityDlg.Save;
begin
  if l.Text = '' then
    raise Exception.Create(Format(stReqNoEmpty, [NameLabel.Caption]));
  if esNew in Entry.State then
  begin
    Entry.dn := 'l=' + EncodeLdapString(l.Text) + ',' + Entry.dn;
    with Entry.AttributesByName['objectclass'] do
    begin
      AddValue('top');
      AddValue('locality');
    end;
    Entry.AttributesByName['l'].AddValue(l.Text);
  end;
  Entry.AttributesByName['description'].AsString := description.Text;
  Entry.AttributesByName['st'].AsString := st.Text;
  Entry.AttributesByName['street'].AsString := FormatMemoOutput(street.Text);
  Entry.Write;
end;


constructor TLocalityDlg.Create(AOwner: TComponent; dn: string; Session: TLDAPSession; Mode: TEditMode);
begin
  inherited Create(AOwner);
  Entry := TLDAPEntry.Create(Session, dn);
  if Mode = EM_MODIFY then
  begin
    l.Enabled := False;
    l.text := DecodeLdapString(GetNameFromDn(dn));
    Caption := Format(cPropertiesOf, [l.Text]);
    Entry.Read;
    description.Text := Entry.AttributesByName['description'].AsString;
    st.Text := Entry.AttributesByName['st'].AsString;
    street.Text := FormatMemoInput(Entry.AttributesByName['street'].AsString)
  end;
end;

procedure TLocalityDlg.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if ModalResult = mrOK then
    Save;
  Action := caFree;
end;

procedure TLocalityDlg.FormDestroy(Sender: TObject);
begin
  Entry.Free;
end;

end.
