unit About;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses

  LCLIntf, LCLType, getvers, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
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

uses
  mormot.core.base;

{$IFnDEF FPC}
uses
  Shellapi;
{$ELSE}
{$ENDIF}

{$R *.dfm}

function GetVersionInfo: String;
begin
  result:='n/a';
  GetProgramVersion(Result);
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
