  {      LDAPAdmin - ConfigDlg.pas
  *      Copyright (C) 2006 Tihomir Karlovic
  *
  *      Author: Tihomir Karlovic
  *
  *      Modifications:  Ivo Brhel, 2016
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

unit ConfigDlg;

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
  Buttons, ExtCtrls, Dialogs, LDAPClasses, ComCtrls, LAControls, Grids;

type
  TConfigDlg = class(TForm)
    OpenConfig: TOpenDialog;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    GroupBox2: TGroupBox;
    Label1: TLabel;
    TemplateList: TListBox;
    btnAdd: TButton;
    btnDel: TButton;
    GroupBox1: TGroupBox;
    cbIdObject: TCheckBox;
    cbEnforceContainer: TCheckBox;
    GroupBox3: TGroupBox;
    cbConnect: TCheckBox;
    Panel1: TPanel;
    OKBtn: TButton;
    CancelBtn: TButton;
    GroupBox4: TGroupBox;
    Label2: TLabel;
    edQSearch: TEdit;
    GroupBox5: TGroupBox;
    cbTemplateExtensions: TCheckBox;
    cbTemplateAutoload: TCheckBox;
    cbTemplateProperties: TCheckBox;
    SetDefBtn: TButton;
    CheckAssocCbk: TCheckBox;
    cbSmartDelete: TCheckBox;
    TabSheet3: TTabSheet;
    edSearch: TEdit;
    Label4: TLabel;
    cbTemplateIcons: TCheckBox;
    GroupBox6: TGroupBox;
    Label5: TLabel;
    LanguageList: TListBox;
    btnAddLang: TButton;
    btnDelLang: TButton;
    GroupBox7: TGroupBox;
    TranscodingTable: TStringGrid;
    Label3: TLabel;
    procedure btnAddClick(Sender: TObject);
    procedure btnDelClick(Sender: TObject);
    procedure cbConnectClick(Sender: TObject);
    procedure cbIdObjectClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    procedure SetDefBtnClick(Sender: TObject);
    procedure TranscodingTableSetEditText(Sender: TObject; ACol,
      ARow: Integer; const Value: String);
    procedure btnAddLangClick(Sender: TObject);
    procedure btnDelLangClick(Sender: TObject);
    procedure ListMouseMove(Sender: TObject; Shift: TShiftState; X,Y: Integer);
  private
    cbStartupConnection: TLAComboBox;
    procedure cbStartupConnectionDrawItem(Control: TWinControl;
              Index: Integer; Rect: TRect; State: TOwnerDrawState);
    procedure cbStartupConnectionCloseUp(var Index: integer; var CanCloseUp: boolean);
  public
    constructor Create(AOwner: TComponent; ASession: TLdapSession); reintroduce;
  end;

implementation

uses FileCtrl, Config, Templates, Constant, Misc, Main;

{$IFnDEF FPC}
  {$R *.dfm}
{$ELSE}
  {$R *.lfm}
{$ENDIF}

constructor TConfigDlg.Create(AOwner: TComponent; ASession: TLdapSession);
var
  i, j: Integer;
  s: string;
  names: TStrings;
begin
  inherited Create(AOwner);
  cbStartupConnection := TLAComboBox.Create(Self);
  with cbStartupConnection do
  begin
    Parent := GroupBox3;
    Left := cbConnect.Left +  25 + self.Canvas.TextWidth(cbConnect.Caption);
    Top := cbConnect.Top ;
    Width := SetDefBtn.Left + SetDefBtn.Width - Left;
    Height := 21;
    ItemHeight := 16;
    Style := csOwnerDrawFixed;
    Color := clBtnFace;
    Enabled := False;
    OnDrawItem := cbStartupConnectionDrawItem;
    OnCanCloseUp := cbStartupConnectionCloseUp;
  end;
  for i:=0 to GlobalConfig.StoragesCount-1 do with GlobalConfig.Storages[i] do
  begin
    cbStartupConnection.Items.AddObject(Name, GlobalConfig.Storages[i]);
    for j:=0 to AccountsCount-1 do
      cbStartupConnection.Items.AddObject(Accounts[j].Name, Accounts[j]);
  end;
  with GlobalConfig do begin
    LanguageList.Items.CommaText := ReadString(rLanguageDir);
    TemplateList.Items.CommaText := ReadString(rTemplateDir);
    cbTemplateExtensions.Checked := ReadBool(rTemplateExtensions, true);
    cbTemplateAutoload.Checked := ReadBool(rTemplateAutoload, true);
    cbTemplateProperties.Checked := ReadBool(rTemplateProperties, true);
    cbSmartDelete.Checked := ReadBool(rSmartDelete, true);
    cbTemplateIcons.Checked := ReadBool(rUseTemplateImages, false);
    CheckAssocCbk.Checked:= not ReadBool(rDontCheckProto, false);

    s := ReadString(rStartupSession);
    with cbStartupConnection do
      for i := 0 to Items.Count - 1 do with TAccount(Items.Objects[i]) do
      if (Items.Objects[i] is TAccount) and (AnsiCompareText(Storage.Name + ':' + Name, s) = 0) then
      begin
        cbConnect.Checked := true;
        cbStartupConnection.ItemIndex := i;
        Break;
      end;
    cbIdObject.Checked := ReadBool(rMwLTIdentObject, true);
    cbEnforceContainer.Checked := ReadBool(rMwLTEnfContainer, true);
    edSearch.Text := ReadString(rSearchFilter, sDEFSRCH);
    edQSearch.Text := ReadString(rQuickSearchFilter, sDEFQUICKSRCH);
    names := TStringList.Create;
    with TranscodingTable do
    try
      ColWidths[1] := Width - ColWidths[0] - 6;
      Split(ReadString(rLocalTransTable), names, #$1E);
      for i := 0 to names.Count - 1 do
      begin
        Cells[0, FixedRows + i] := Copy(names[i], 1, Pos(#$1F, names[i]) - 1);
        Cells[1, FixedRows + i] := Copy(names[i], Length(Cells[0, FixedRows + i]) + 2, MaxInt);
      end;
    finally
      names.Free;
    end;
  end;
end;

procedure TConfigDlg.btnAddClick(Sender: TObject);
var
  Dir: string;
begin
  if SelectDirectory('','',Dir) then
    TemplateList.Items.Add(Dir);
end;

procedure TConfigDlg.btnDelClick(Sender: TObject);
begin
  with TemplateList do
  if ItemIndex <> -1 then
    Items.Delete(ItemIndex);
end;

procedure TConfigDlg.cbConnectClick(Sender: TObject);
begin
  with cbStartupConnection do
  if cbConnect.Checked then
  begin
    Enabled := true;
    Color := clWindow;
  end
  else begin
    Enabled := false;
    Color := clBtnFace;
    ItemIndex := -1;
  end;
end;

procedure TConfigDlg.cbIdObjectClick(Sender: TObject);
begin
  if cbIdObject.Checked then
  begin
    cbEnforceContainer.Enabled := true;
    cbEnforceContainer.Checked := true;
    cbEnforceContainer.AllowGrayed := false;
  end
  else begin
    cbEnforceContainer.Enabled := false;
    cbEnforceContainer.AllowGrayed := true;
    cbEnforceContainer.State := cbGrayed;
  end;
end;

procedure TConfigDlg.FormClose(Sender: TObject; var Action: TCloseAction);
var
  Account: TAccount;
  i: Integer;
  s: string;
begin
  Action := caFree;
  if ModalResult = mrOk then with GlobalConfig do
  begin
    TemplateParser.Paths := TemplateList.Items.CommaText;
    TemplateParser.AddPath(ExtractFileDir(application.ExeName) + '\*.' + TEMPLATE_EXT);
    WriteBool(rTemplateExtensions, cbTemplateExtensions.Checked);
    WriteBool(rTemplateAutoload, cbTemplateAutoload.Checked);
    WriteBool(rTemplateProperties, cbTemplateProperties.Checked);
    WriteBool(rSmartDelete, cbSmartDelete.Checked);
    WriteBool(rUseTemplateImages, cbTemplateIcons.Checked);
    WriteString(rTemplateDir, TemplateList.Items.CommaText);
    WriteString(rLanguageDir, LanguageList.Items.CommaText);
    WriteBool(rDontCheckProto, not CheckAssocCbk.Checked);
    with cbStartupConnection do
    begin
      if ItemIndex = -1 then
        WriteString(rStartupSession, '')
      else begin
        Account := TAccount(Items.Objects[ItemIndex]);
        WriteString(rStartupSession, Account.Storage.Name + ':' + Account.Name);
      end;
    end;
    WriteBool(rMwLTIdentObject, cbIdObject.Checked);
    WriteBool(rMwLTEnfContainer, cbEnforceContainer.Checked);
    WriteString(rSearchFilter, edSearch.Text);
    WriteString(rQuickSearchFilter, edQSearch.Text);
    s := '';
    with TranscodingTable do
    for i := FixedRows to RowCount - 1 do
      if Cells[0, i] <> '' then
        s := s + Cells[0, i] + #$1F + Cells[1, i] + #$1E;
    if s <> '' then
      WriteString(rLocalTransTable, s)
    else
      Delete(rLocalTransTable);
  end;
end;

procedure TConfigDlg.FormDestroy(Sender: TObject);
begin
  cbStartupConnection.Free;
end;

procedure TConfigDlg.cbStartupConnectionDrawItem(Control: TWinControl;
  Index: Integer; Rect: TRect; State: TOwnerDrawState);
var
  s: string;
  ImageIndex: Integer;
begin
  with cbStartupConnection do
  begin
    Canvas.FillRect(rect);
    if Items.Objects[Index] is TConfigStorage then
    begin
      if Index = 0 then
        ImageIndex := 32
      else
        ImageIndex := 33;
    end
    else begin
      ImageIndex := bmHost;
      Rect.Left:=Rect.Left+20;
    end;
    Rect.Top:=Rect.Top+1;
    Rect.Bottom:=Rect.Bottom-1;
    Rect.Left:=rect.Left+2;
    MainFrm.ImageList.Draw(Canvas, Rect.Left, Rect.Top, ImageIndex);
    Rect.Left := Rect.Left + 20;
    s := Items[Index];
    DrawText(Canvas.Handle, PChar(s), Length(s), Rect, DT_SINGLELINE or DT_VCENTER or DT_NOPREFIX);
  end;
end;

procedure TConfigDlg.cbStartupConnectionCloseUp(var Index: integer; var CanCloseUp: boolean);
begin
  if cbStartupConnection.Items.Objects[Index] is TConfigStorage then
  begin
    Beep;
    CanCloseUp := false;
  end;
end;

procedure TConfigDlg.SetDefBtnClick(Sender: TObject);
begin
  {$ifdef mswindows}
  RegProtocol('LDAP');
  RegProtocol('LDAPS');
  {$endif}
end;

procedure TConfigDlg.TranscodingTableSetEditText(Sender: TObject; ACol, ARow: Integer; const Value: String);
begin
  with TranscodingTable do
  if (ARow = RowCount - 1) and (Cells[ACol, ARow] <> '') then
  begin
    RowCount := RowCount + 1;
    ColWidths[1] := ClientWidth - ColWidths[0] - 1;
  end;
end;

procedure TConfigDlg.btnAddLangClick(Sender: TObject);
var
  Dir: string;
begin
  if SelectDirectory('','',Dir) then
    LanguageList.Items.Add(Dir);
end;

procedure TConfigDlg.btnDelLangClick(Sender: TObject);
begin
  with LanguageList do
  if ItemIndex <> -1 then
    Items.Delete(ItemIndex);
end;

procedure TConfigDlg.ListMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
var
  i: Integer;
begin
  if Sender is TListBox then with TListBox(Sender) do
  begin
    i := ItemAtPos(Point(x, y), true);
    if i <> -1 then
      Hint := Items[i]
    else
      Hint := '';
  end;
end;

end.
