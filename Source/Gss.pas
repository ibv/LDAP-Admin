unit Gss;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
  LCLIntf, LCLType;


type
  ULONG = Cardinal ;

  PSEC_WINNT_AUTH_IDENTITY = ^SEC_WINNT_AUTH_IDENTITY;
  SEC_WINNT_AUTH_IDENTITY = record
    User: PChar;
    UserLength: ULONG;
    Domain: PChar;
    DomainLength: ULONG;
    Password: PChar;
    PasswordLength: ULONG;
    Flags: ULONG;
  end;

const
  SEC_WINNT_AUTH_IDENTITY_ANSI    = 1;
  SEC_WINNT_AUTH_IDENTITY_UNICODE = 2;

implementation

end.
 
