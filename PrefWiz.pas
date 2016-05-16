  {      LDAPAdmin - PrefWiz.pas
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

unit PrefWiz;

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
  ExtCtrls, StdCtrls, ComCtrls, Prefs;

type

  { TPrefWizDlg }

  TPrefWizDlg = class(TForm)
    Notebook: TNotebook;
    btnNext: TButton;
    btnBack: TButton;
    btnCancel: TButton;
    Label1: TLabel;
    ListView1: TListView;
    wedServer: TEdit;
    Label5: TLabel;
    wedMail: TEdit;
    Label8: TLabel;
    wedMaildrop: TEdit;
    Label9: TLabel;
    ListView2: TListView;
    wcbDomain: TComboBox;
    Label6: TLabel;
    Panel1: TPanel;
    Bevel3: TBevel;
    Panel2: TPanel;
    Label2: TLabel;
    Bevel4: TBevel;
    Panel3: TPanel;
    Bevel5: TBevel;
    Label3: TLabel;
    Panel4: TPanel;
    Bevel6: TBevel;
    Label11: TLabel;
    Panel5: TPanel;
    Bevel1: TBevel;
    Label4: TLabel;
    Panel6: TPanel;
    Bevel2: TBevel;
    Label7: TLabel;
    Page1: TPage;
    Page2: TPage;
    Page3: TPage;
    Page4: TPage;
    Page5: TPage;
    procedure btnBackClick(Sender: TObject);
    procedure btnNextClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure NotebookPageChanged(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    PrefDlg: TPrefDlg;
    procedure Finish;
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  PrefWizDlg: TPrefWizDlg;

implementation

uses Constant;

{$IFnDEF FPC}
  {$R *.dfm}
{$ELSE}
  {$R *.dfm}
{$ENDIF}

procedure TPrefWizDlg.btnBackClick(Sender: TObject);
begin
  if Notebook.PageIndex > 0 then
  begin
    Notebook.PageIndex := Notebook.PageIndex - 1;
    btnNext.Caption := cNext + ' >';
    btnNext.Enabled := true;
    if Notebook.PageIndex = 0 then
      btnBack.Enabled := false;
  end;
end;

procedure TPrefWizDlg.btnNextClick(Sender: TObject);
begin
  if Notebook.PageIndex < Notebook.Pages.Count - 1 then
  begin
    Notebook.PageIndex := Notebook.PageIndex + 1;
    btnBack.Enabled := true;
    if Notebook.PageIndex = Notebook.Pages.Count - 1 then
      btnNext.Caption := cFinish;
  end
  else begin
    Finish;
    ModalResult := mrOk;
  end;
end;

procedure TPrefWizDlg.btnCancelClick(Sender: TObject);
begin
    ModalResult := mrCancel;
end;

procedure TPrefWizDlg.NotebookPageChanged(Sender: TObject);
begin
  case Notebook.PageIndex of
    1: ListView1.SetFocus;
    2: ListView2.SetFocus;
    3: wedServer.SetFocus;
    4: wedMail.SetFocus;
  end;
end;

procedure TPrefWizDlg.Finish;
begin
  with PrefDlg do
  begin
    if Assigned(ListView1.Selected) then
    begin
      edUserName.Text := ListView1.Selected.SubItems[1];
      edHomeDir.Text := '/home/%u';
      edScript.Text := '%u.cmd';
      if wedServer.Text <> '' then
        edProfilePath.Text := '\\%n\profiles\%u';
      if wedMail.Text <> '' then
        edMailAddress.Text := '%u@' + wedMail.Text;
      if wedMaildrop.Text <> '' then
        edMaildrop.Text := '%u@' + wedMaildrop.Text;
    end
    else
      edScript.Text := 'common.cmd';

    if Assigned(ListView2.Selected) then
      edDisplayName.Text := ListView2.Selected.SubItems[1];

    if wedServer.Text <> '' then
    begin
      edNetbios.Text := wedServer.Text;
      edHomeShare.Text := '\\%n\%u';
    end;

    if wcbDomain.ItemIndex <> -1 then
      cbDomain.ItemIndex := wcbDomain.ItemIndex;
    cbHomeDrive.ItemIndex := cbHomeDrive.Items.IndexOf('H:');
    edLoginShell.Text := '/bin/false';
  end;
end;

constructor TPrefWizDlg.Create(AOwner: TComponent);
begin
  PrefDlg := AOwner as TPrefDlg;
  inherited Create(AOwner);
  wcbDomain.Items.Text := PrefDlg.cbDomain.Items.Text;
end;

procedure TPrefWizDlg.FormCreate(Sender: TObject);
begin
  ListView1.Items[0].Selected := true;
  ListView2.Items[0].Selected := true;
end;

procedure TPrefWizDlg.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

end.
