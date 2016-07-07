  {      LDAPAdmin - DBLoad.pas
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

unit DBLoad;

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
  Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, Connection;

type
  TDBLoadDlg = class(TForm)
    CancelBtn: TButton;
    Message: TLabel;
    ProgressBar: TProgressBar;
    PathLabel: TLabel;
    procedure CancelBtnClick(Sender: TObject);
  private
    fAbort: Boolean;
    fNumObjects: Integer;
    fFileName: string;
    procedure CallbackProc(BytesRead: Integer; var Abort: Boolean);
  public
    { Public declarations }
  end;

function LoadDB(Owner: TComponent; Account: TDBAccount): TConnection;

implementation

{$R *.dfm}

function LoadDB(Owner: TComponent; Account: TDBAccount): TConnection;
var
  F: File;
  ACursor: TCursor;
begin
  Result := nil;
  ACursor := Screen.Cursor;
  with TDBLoadDlg.Create(Owner) do
  try
    Screen.Cursor := crAppStart;
    Show;
    fFileName := Account.FileName;
    System.Assign(F, Account.FileName);
    FileMode := 0;
    Reset(F,1);
    try
      ProgressBar.Max := FileSize(F);
    finally
      CloseFile(F);
    end;
    Result := TDBConnection.Create(TDBAccount(Account), CallbackProc);
    if fAbort then
      FreeAndNil(Result);
  finally
    Screen.Cursor := ACursor;
    Free;
  end;
end;

procedure TDBLoadDlg.CallbackProc(BytesRead: Integer; var Abort: Boolean);
begin
  Abort := fAbort;
  inc(fNumObjects);
  Message.Caption := Format('Parsing file %s: %d objects loaded', [fFileName, fNumObjects]);
  ProgressBar.Position := BytesRead;
  Application.ProcessMessages;
end;

procedure TDBLoadDlg.CancelBtnClick(Sender: TObject);
begin
  fAbort := true;
end;

end.
