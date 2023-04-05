  {      LDAPAdmin - Input.pas
  *      Copyright (C) 2003-2016 Tihomir Karlovic
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

unit Input;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
  Windows,Validator,
  LCLIntf, LCLType, LMessages, strutils,
  Messages,SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ExtCtrls;

type
  TInputDlg = class(TForm)
    OKBtn: TButton;
    CancelBtn: TButton;
    Edit: TEdit;
    Prompt: TLabel;
    procedure EditChange(Sender: TObject);
    procedure WMWindowPosChanged(var AMessage: TMessage); message WM_WINDOWPOSCHANGED;
    {$ifdef mswindows}
    procedure WMActivateApp(var AMessage: TMessage); message WM_ACTIVATEAPP;
    {$else}
    procedure WMActivateApp(var AMessage: TMessage); message WM_ACTIVATE;
    {$endif}
  private
    FValidator: TValidateInput;
  public
    { Public declarations }
  end;

function InputDlg(ACaption, APrompt: string; var AValue: string; PasswordChar: Char=#0; AcceptEmpty:Boolean=False; InvalidChars: string = ''): Boolean;

implementation

{$R *.dfm}
uses Misc, Constant {$ifdef mswindows},MMSystem{$endif};


function InputDlg(ACaption, APrompt: string; var AValue: string; PasswordChar: Char=#0; AcceptEmpty:Boolean=False; InvalidChars: string = ''): Boolean;
begin
  Result := false;
  with TInputDlg.Create(Application) do
  begin
    if AcceptEmpty then
      Edit.OnChange := nil
    else
      OKBtn.Enabled := false;
    FValidator.Attach(Edit);
    FValidator.InvalidChars := InvalidChars;
    FValidator.Caption := APrompt;
    Caption := ACaption;
    if not APrompt.EndsWith(':') then
      APrompt := APrompt + ':';
    Prompt.Caption := APrompt;
    Edit.PasswordChar := PasswordChar;
    Edit.Text := AValue;
    if ShowModal = mrOk then
    begin
      AValue := Edit.Text;
      Result := true
    end;
    Free;
  end;
end;

procedure TInputDlg.WMActivateApp(var AMessage: TMessage);
begin
  FValidator.HideHint;
  inherited;
end;
procedure TInputDlg.WMWindowPosChanged(var AMessage: TMessage);
begin
  FValidator.HideHint;
  inherited;
end;

procedure TInputDlg.EditChange(Sender: TObject);
begin
  OkBtn.Enabled := Edit.Text <> '';
end;

end.
