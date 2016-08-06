  {      LDAPAdmin - Ou.pas
  *      Copyright (C) 2003 Tihomir Karlovic
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

unit Ou;

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
  TOuDlg = class(TForm)
    NameLabel: TLabel;
    ou: TEdit;
    GroupBox1: TGroupBox;
    Label18: TLabel;
    Label19: TLabel;
    Label24: TLabel;
    Label31: TLabel;
    postalAddress: TMemo;
    st: TEdit;
    postalCode: TEdit;
    l: TEdit;
    Label1: TLabel;
    description: TEdit;
    OKBtn: TButton;
    CancelBtn: TButton;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
  private
    Entry: TLDAPEntry;
    ParentDn: string;
    procedure Save;
  public
    constructor Create(AOwner: TComponent; dn: string; Session: TLDAPSession; Mode: TEditMode); reintroduce;
  end;

var
  OuDlg: TOuDlg;

implementation

uses {$ifdef mswindows}WinLDAP,{$else} LinLDAP,{$endif} Misc;

{$R *.dfm}

procedure TOuDlg.Save;
var
  C: Integer;
  Component: TComponent;
  s: string;
begin
  if ou.Text = '' then
    raise Exception.Create(Format(stReqNoEmpty, [cName]));

  if esNew in Entry.State then
  begin
    Entry.dn := 'ou=' + EncodeLdapString(ou.Text) + ',' + ParentDn;
    with Entry.AttributesByName['objectclass'] do
    begin
      AddValue('top');
      AddValue('organizationalUnit');
    end;
    Entry.AttributesByName['ou'].AddValue(ou.Text);
  end;

  for C := 0 to GroupBox1.ControlCount - 1 do
  begin
    Component := GroupBox1.Controls[c];
    if (Component is TCustomEdit) and (TCustomEdit(Component).Modified) then
    begin
      if Component is TMemo then
        s := FormatMemoOutput(TMemo(Component).Text)
      else
        s := TEdit(Component).Text;
      Entry.AttributesByName[Component.Name].AsString := s;
    end;
  end;

  Entry.Write;
end;


constructor TOuDlg.Create(AOwner: TComponent; dn: string; Session: TLDAPSession; Mode: TEditMode);
var
  C: Integer;
begin
  inherited Create(AOwner);
  ParentDn := dn;
  Entry := TLDAPEntry.Create(Session, dn);
  if Mode = EM_MODIFY then
  begin
    ou.Enabled := False;
    ou.text := GetNameFromDn(dn);
    Caption := Format(cPropertiesOf, [ou.Text]);
    Entry.Read;
    for C := 0 to ComponentCount - 1 do
    begin
      if Components[C] is TEdit then with TEdit(Components[C]) do
        Text := Entry.AttributesByName[Name].AsString;
    end;
    postalAddress.Text := FormatMemoInput(Entry.AttributesByName['postalAddress'].AsString);
  end;
end;

procedure TOuDlg.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if ModalResult = mrOK then
    Save;
  Action := caFree;
end;

procedure TOuDlg.FormDestroy(Sender: TObject);
begin
  Entry.Free;
end;

end.
