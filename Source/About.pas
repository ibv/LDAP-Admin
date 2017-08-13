unit About;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses

{$IFnDEF FPC}
  Windows,
{$ELSE}
  LCLIntf, LCLType, LMessages, getvers,
{$ENDIF}
  Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls;


	
type
  TAboutDlg = class(TForm)
    Label1: TLabel;
    BtnClose: TButton;
    Panel1: TPanel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Image1: TImage;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Label7Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  AboutDlg: TAboutDlg;

implementation

{$IFnDEF FPC}
uses
  Shellapi;
{$ELSE}
{$ENDIF}

{$R *.dfm}

function GetVersionInfo: string;
type
  PLandCodepage = ^TLandCodepage;
  TLandCodepage = record
    wLanguage,
    wCodePage: word;
  end;
var
  dummy,
  len: cardinal;
  buf, pntr: pointer;
  lang: string;
begin
  result:='n/a';
  {$ifdef mswindows}
  len := GetFileVersionInfoSize(PChar(Application.ExeName), dummy);
  if len = 0 then
    RaiseLastOSError;
  GetMem(buf, len);
  try
    if not GetFileVersionInfo(PChar(Application.ExeName), 0, len, buf) then
      RaiseLastOSError;

    if not VerQueryValue(buf, '\VarFileInfo\Translation\', pntr, len) then
      RaiseLastOSError;

    lang := Format('%.4x%.4x', [PLandCodepage(pntr)^.wLanguage, PLandCodepage(pntr)^.wCodePage]);

    if VerQueryValue(buf, PChar('\StringFileInfo\' + lang + '\FileVersion'), pntr, len){ and (@len <> nil)} then
      result := PChar(pntr);
  finally
    FreeMem(buf);
  end;
  {$else}
  GetProgramVersion (Result);
  {$endif}

end;

procedure TAboutDlg.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TAboutDlg.Label7Click(Sender: TObject);
begin
   OpenDocument(PChar(label7.Caption));{ *Převedeno z ShellExecute* }
end;

procedure TAboutDlg.FormCreate(Sender: TObject);
begin
  Label5.Caption:=GetVersionInfo;
end;

end.
