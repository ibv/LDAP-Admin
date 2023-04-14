  {      LDAPAdmin - Import.pas
  *      Copyright (C) 2004-2014 Tihomir Karlovic
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

unit Import;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
  LCLIntf, LCLType,
  SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ExtCtrls, Dialogs, LDAPClasses, ComCtrls, mormot.core.base;

const
  cwSmall   = 262;
  cwBig     = 473;

type
  TImportDlg = class(TForm)
    OKBtn: TButton;
    CancelBtn: TButton;
    Notebook: TNotebook;
    Bevel1: TBevel;
    Label1: TLabel;
    edFileName: TEdit;
    Label2: TLabel;
    ProgressBar: TProgressBar;
    Label3: TLabel;
    ResultLabel: TLabel;
    Label5: TLabel;
    ImportingLabel: TLabel;
    cbStopOnError: TCheckBox;
    edRejected: TEdit;
    Label6: TLabel;
    OpenDialog: TOpenDialog;
    DetailBtn: TButton;
    mbErrors: TMemo;
    errResultLabel: TLabel;
    errLabel: TLabel;
    btnFileName: TSpeedButton;
    btnRejected: TSpeedButton;
    Page1: Tpage;
    Page2: TPage;
    procedure btnFileNameClick(Sender: TObject);
    procedure edFileNameChange(Sender: TObject);
    procedure OKBtnClick(Sender: TObject);
    procedure DetailBtnClick(Sender: TObject);
    procedure CancelBtnClick(Sender: TObject);
    procedure btnRejectedClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormActivate(Sender: TObject);
  private
    ObjCount: Integer;
    ErrCount: Integer;
    Session: TLDAPSession;
    Stop: Boolean;
    procedure ImportFile(const FileName: RawUtf8);
  public
    constructor Create(AOwner: TComponent; const ASession: TLDAPSession); reintroduce;
  end;

var
  ImportDlg: TImportDlg;

implementation

{$I LdapAdmin.inc}

uses Ldif, TextFile, Constant{$IFDEF VER_XEH}, System.UITypes{$ENDIF};

{$R *.dfm}

constructor TImportDlg.Create(AOwner: TComponent; const ASession: TLDAPSession);
begin
  inherited Create(AOwner);
  Session := ASession;
end;

procedure TImportDlg.btnFileNameClick(Sender: TObject);
begin
  if OpenDialog.Execute then
    edFileName.Text := OpenDialog.FileName;
end;

procedure TImportDlg.ImportFile(const FileName: RawUtf8);
var
  Entry: TLDAPEntry;
  F: File;
  R: TTextFile;
  ldFile: TLdifFile;
  i: Integer;
  StopOnError: Boolean;
  RejectList: Boolean;
begin
  ObjCount := 0;
  ErrCount := 0;
  mbErrors.Clear;

  RejectList := edRejected.Text <> '';
  if RejectList then
  begin
    try
    R := TTextFile.Create(edRejected.Text, fmCreate);
    except
      on E: Exception do
        raise Exception.Create(Format('%s: %s!', [edRejected.Text, E.Message]));
    end;
  end;

  StopOnError := cbStopOnError.Checked;

  try
    Entry := nil;
    ldFile := nil;
    
    System.Assign(F, FileName);
    FileMode := 0;
    Reset(F,1);
    try
      ProgressBar.Max := FileSize(F);
    finally
      CloseFile(F);
    end;

    Entry := TLDAPEntry.Create(Session, '');
    ldFile := TLDIFFile.Create(edFileName.Text, fmRead);
    with ldFile do
    begin
      ProgressBar.Position := 0;
      while not (eof or Stop) do
      try
        ReadRecord(Entry);
        ProgressBar.Position := NumRead;
        if Entry.dn = '' then
          break;
        ImportingLabel.Caption := Entry.dn;
        //Label3.Caption := IntToStr(Trunc((NumRead / ProgressBar.Max) * 100)) + '%';
        if not (esDeleted in Entry.State) then
          Entry.Write;
        inc(ObjCount);
        Application.ProcessMessages;
      except
        on E: Exception do
        begin
          Inc(ErrCount);
          mbErrors.Lines.Add(Entry.dn);
          mbErrors.Lines.Add('  ' + E.Message);
          if RejectList then
          try
            R.WriteLn('# ' + Entry.dn);
            for i := 0 to RecordLines.Count - 1 do
              R.WriteLn(RecordLines[i]);
            R.WriteLn('');
          except
            on E: EInOutError do
              RaiseLastOSError
            else
              raise;
          end;
          if StopOnError then
            case MessageDlg(Format(stSkipRecord, [E.Message]), mtError, [mbIgnore, mbCancel, mbAll], 0) of
              mrCancel: break;
              mrAll: StopOnError := false;
            end;
        end;
      end;
    end;
  finally
    if RejectList then
    try
      R.Free;
    except end;
    FreeAndNil(Entry);
    FreeAndNil(ldFile);
  end;
end;

procedure TImportDlg.edFileNameChange(Sender: TObject);
begin
  OkBtn.Enabled := edFileName.Text <> '';
end;

procedure TImportDlg.OKBtnClick(Sender: TObject);
begin
  OKBtn.Enabled := false;
  Notebook.PageIndex := 1;
  Application.ProcessMessages;
  try
    ImportFile(edFileName.Text);
    ResultLabel.Caption := Format(stLdifSuccess, [ObjCount]);
    if ErrCount > 0 then
    begin
      errLabel.Visible := true;
      errResultLabel.Caption := Format(stLdifFailure, [ErrCount]);
      DetailBtn.Visible := true;
    end;
  except
    OKBtn.Caption := cRetry;
    OKBtn.Enabled := true;
    raise;
  end;
  OKBtn.Visible := false;
  CancelBtn.Caption := cClose;
  CancelBtn.Left := (Width - CancelBtn.Width) div 2;
  CancelBtn.ModalResult := mrOk;
  CancelBtn.Default := true;
end;

procedure TImportDlg.DetailBtnClick(Sender: TObject);
begin
  if mbErrors.Visible then
  begin
    mbErrors.Visible := false;
    Height := cwSmall;
    DetailBtn.Caption := cDetails + ' >>';
  end
  else begin
    mbErrors.Visible := true;
    Height := cwBig;
    DetailBtn.Caption := cDetails + ' <<';
  end;
end;

procedure TImportDlg.CancelBtnClick(Sender: TObject);
begin
  Stop := true;
end;

procedure TImportDlg.btnRejectedClick(Sender: TObject);
begin
  if OpenDialog.Execute then
    edRejected.Text := OpenDialog.FileName;
end;

procedure TImportDlg.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TImportDlg.FormActivate(Sender: TObject);
begin
  Height := cwSmall;
end;

end.
