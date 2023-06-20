program LdapAdmin;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

uses
{$IFnDEF FPC}
{$ELSE}
{$ifdef UNIX}
cthreads,
{$endif}
//cmem,
Interfaces,
DefaultTranslator,
{$ENDIF}
Forms,
Main in 'Main.pas' {MainFrm},
Config in 'Config.pas',
Samba in 'Samba.pas',
Posix in 'Posix.pas',
Postfix in 'Postfix.pas',
InetOrg in 'InetOrg.pas',
Shadow in 'Shadow.pas',
password in 'password.pas',
md5crypt in 'md5crypt.pas',
Templates in 'Templates.pas',
Core in 'Core.pas',
Cert in 'Cert.pas',
Script in 'Script.pas',
adsie in 'adsie.pas',
Lang in 'Lang.pas',
ADUser in 'ADUser.pas' {ADUserDlg},
AdGroup in 'AdGroup.pas' {AdGroupDlg};


{$R *.res}

begin
  Application.Scaled:=True;
  Application.Initialize;
  Application.CreateForm(TMainFrm, MainFrm);
  Application.Run;
end.
