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


{$IFnDEF FPC}
  {$R *.dfm}
{$ELSE}
  {$R *.lfm}
{$ENDIF}

function GetVersionInfo: string;
var VISize:   cardinal;
    VIBuff:   pointer;
    trans:    pointer;
    buffsize: cardinal;
    temp: integer;
    str: pchar;
    LangCharSet: string;
    LanguageInfo: string;

begin
  result:='n/a';
  {$ifdef mswindows}
  VISize := GetFileVersionInfoSize(pchar(Application.exename),buffsize);
  if VISize < 1 then exit;

  VIBuff := AllocMem(VISize);
  GetFileVersionInfo(pchar(Application.exename),cardinal(0),VISize,VIBuff);

  VerQueryValue(VIBuff,'\VarFileInfo\Translation',Trans,buffsize);
  if buffsize >= 4 then
  begin
    temp:=0;
    StrLCopy(@temp, pchar(Trans), 2);
    LangCharSet:=IntToHex(temp, 4);
    StrLCopy(@temp, pchar(Trans)+2, 2);
    LanguageInfo := LangCharSet+IntToHex(temp, 4);

    VerQueryValue(VIBuff,pchar('\StringFileInfo\'+LanguageInfo+'\FileVersion'), pointer(str), buffsize);
    if buffsize > 0 then Result:=str;
  end;

  FreeMem(VIBuff,VISize);
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
   OpenDocument(PChar(label7.Caption)); { *Converted from ShellExecute* }
end;

procedure TAboutDlg.FormCreate(Sender: TObject);
begin
  Label5.Caption:=GetVersionInfo;
end;

end.
