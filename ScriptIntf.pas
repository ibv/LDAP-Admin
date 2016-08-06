(********************************************************)
(*                                                      *)
(*  Codebot Class Library @ www.codebot.org/delphi      *)
(*                                                      *)
(*  3.01.00 Open Source Released 2011                   *)
(*                                                      *)
(********************************************************)

unit ScriptIntf;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

{$IFnDEF FPC}
uses
  ActiveX, Windows;
{$ELSE}
uses
  LCLIntf, LCLType, LMessages;
{$ENDIF}


const
  (*CATID_ActiveScript: TGUID = (
    D1:$F0B7A1A1; D2:$9847; D3:$11CF; D4:($8F,$20,$00,$80,$5F,$2C,$D0,$64));
  CATID_ActiveScriptParse: TGUID = (
    D1:$F0B7A1A2; D2:$9847; D3:$11CF; D4:($8F,$20,$00,$80,$5F,$2C,$D0,$64));
  CATID_ActiveScriptEncode: TGUID = (
    D1:$F0B7A1A3; D2:$9847; D3:$11CF; D4:($8F,$20,$00,$80,$5F,$2C,$D0,$64));
  IID_IActiveScript: TGUID = (
    D1:$BB1A2AE1; D2:$A4F9; D3:$11CF; D4:($8F,$20,$00,$80,$5F,$2C,$D0,$64));
  IID_IActiveScriptParse: TGUID = (
    D1:$BB1A2AE2; D2:$A4F9; D3:$11CF; D4:($8F,$20,$00,$80,$5F,$2C,$D0,$64));
  IID_IActiveScriptEncode: TGUID = (
    D1:$BB1A2AE3; D2:$A4F9; D3:$11CF; D4:($8F,$20,$00,$80,$5F,$2C,$D0,$64));
  IID_IActiveScriptHostEncode: TGUID = (
    D1:$BEE9B76E; D2:$CFE3; D3:$11D1; D4:($B7,$47,$00,$C0,$4F,$C2,$B0,$85));
  IID_IActiveScriptParseProcedureOld: TGUID = (
    D1:$1CFF0050; D2:$6FDD; D3:$11D0; D4:($93,$28,$00,$A0,$C9,$0D,$CA,$A9));
  IID_IActiveScriptParseProcedure: TGUID = (
    D1:$AA5B6A80; D2:$B834; D3:$11D0; D4:($93,$2F,$00,$A0,$C9,$0D,$CA,$A9));
  IID_IActiveScriptParseProcedure2: TGUID = (
    D1:$71EE5B20; D2:$FB04; D3:$11D1; D4:($B3,$A8,$00,$A0,$C9,$11,$E8,$B2));
  IID_IActiveScriptSite: TGUID = (
    D1:$DB01A1E3; D2:$A42B; D3:$11CF; D4:($8F,$20,$00,$80,$5F,$2C,$D0,$64));
  IID_IActiveScriptSiteWindow: TGUID = (
    D1:$D10F6761; D2:$83E9; D3:$11CF; D4:($8F,$20,$00,$80,$5F,$2C,$D0,$64));
  IID_IActiveScriptSiteInterruptPoll: TGUID = (
    D1:$539698A0; D2:$CDCA; D3:$11CF; D4:($A5,$EB,$00,$AA,$00,$47,$A0,$63));
  IID_IActiveScriptError: TGUID = (
    D1:$EAE1BA61; D2:$A4ED; D3:$11CF; D4:($8F,$20,$00,$80,$5F,$2C,$D0,$64));
  IID_IBindEventHandler: TGUID = (
    D1:$63CDBCB0; D2:$C1B1; D3:$11D0; D4:($93,$36,$00,$A0,$C9,$0D,$CA,$A9));
  IID_IActiveScriptStats: TGUID = (
    D1:$B8DA6310; D2:$E19B; D3:$11D0; D4:($93,$3C,$00,$A0,$C9,$0D,$CA,$A9));
  IID_IActiveScriptProperty: TGUID = (
    D1:$4954E0D0; D2:$FBC7; D3:$11D1; D4:($84,$10,$00,$60,$08,$C3,$FB,$FC));
  IID_ITridentEventSink: TGUID = (
    D1:$1DC9CA50; D2:$06EF; D3:$11D2; D4:($84,$15,$00,$60,$08,$C3,$FB,$FC));*)

// CoClasses that support the IActiveScript interface

  CLSID_VBScript: TGUID = (
    D1:$B54F3741; D2:$5B07; D3:$11CF; D4:($A4,$B0,$00,$AA,$00,$4A,$55,$E8));
  CLSID_JScript: TGUID = (
    D1:$F414C260; D2:$6AC0; D3:$11CF; D4:($B6,$D1,$00,$AA,$00,$BB,$BB,$58));

// IActiveScript.AddNamedItem input flags

const
  SCRIPTITEM_ISVISIBLE             = $00000002;
  SCRIPTITEM_ISSOURCE              = $00000004;
  SCRIPTITEM_GLOBALMEMBERS         = $00000008;
  SCRIPTITEM_ISPERSISTENT          = $00000040;
  SCRIPTITEM_CODEONLY              = $00000200;
  SCRIPTITEM_NOCODE                = $00000400;
  SCRIPTITEM_ALL_FLAGS = SCRIPTITEM_ISSOURCE or SCRIPTITEM_ISVISIBLE or
    SCRIPTITEM_ISPERSISTENT or SCRIPTITEM_GLOBALMEMBERS or SCRIPTITEM_NOCODE or
    SCRIPTITEM_CODEONLY;

// IActiveScript.AddTypeLib input flags

  SCRIPTTYPELIB_ISCONTROL          = $00000010;
  SCRIPTTYPELIB_ISPERSISTENT       = $00000040;
  SCRIPTTYPELIB_ALL_FLAGS = SCRIPTTYPELIB_ISCONTROL or
    SCRIPTTYPELIB_ISPERSISTENT;

// IActiveScriptParse.AddScriptlet and IActiveScriptParse.ParseScriptText input flags

  SCRIPTTEXT_DELAYEXECUTION        = $00000001;
  SCRIPTTEXT_ISVISIBLE             = $00000002;
  SCRIPTTEXT_ISEXPRESSION          = $00000020;
  SCRIPTTEXT_ISPERSISTENT          = $00000040;
  SCRIPTTEXT_HOSTMANAGESSOURCE     = $00000080;
  SCRIPTTEXT_ALL_FLAGS = SCRIPTTEXT_DELAYEXECUTION or SCRIPTTEXT_ISVISIBLE or
    SCRIPTTEXT_ISEXPRESSION or SCRIPTTEXT_ISPERSISTENT or
    SCRIPTTEXT_HOSTMANAGESSOURCE;

// IActiveScriptParseProcedure.ParseProcedureText input flags

  SCRIPTPROC_ISEXPRESSION          = $00000020;
  SCRIPTPROC_HOSTMANAGESSOURCE     = $00000080;
  SCRIPTPROC_IMPLICIT_THIS         = $00000100;
  SCRIPTPROC_IMPLICIT_PARENTS      = $00000200;
  SCRIPTPROC_ALL_FLAGS = SCRIPTPROC_HOSTMANAGESSOURCE or
    SCRIPTPROC_ISEXPRESSION or SCRIPTPROC_IMPLICIT_THIS or
    SCRIPTPROC_IMPLICIT_PARENTS;

// IActiveScriptSite.GetItemInfo input flags

  SCRIPTINFO_IUNKNOWN              = $00000001;
  SCRIPTINFO_ITYPEINFO             = $00000002;
  SCRIPTINFO_ALL_FLAGS = SCRIPTINFO_IUNKNOWN or SCRIPTINFO_ITYPEINFO;

// IActiveScript.Interrupt flags

  SCRIPTINTERRUPT_DEBUG            = $00000001;
  SCRIPTINTERRUPT_RAISEEXCEPTION   = $00000002;
  SCRIPTINTERRUPT_ALL_FLAGS = SCRIPTINTERRUPT_DEBUG or
    SCRIPTINTERRUPT_RAISEEXCEPTION;

// IActiveScriptStats.GetStat values

  SCRIPTSTAT_STATEMENT_COUNT        = 1;
  SCRIPTSTAT_INSTRUCTION_COUNT      = 2;
  SCRIPTSTAT_INTSTRUCTION_TIME      = 3;
  SCRIPTSTAT_TOTAL_TIME             = 4;

// IActiveScriptEncode.AddSection input flags

  SCRIPT_ENCODE_SECTION            = $00000001;

  SCRIPT_ENCODE_DEFAULT_LANGUAGE   = $00000001;

// Properties for IActiveScriptProperty

  SCRIPTPROP_NAME                  = $00000000;
  SCRIPTPROP_MAJORVERSION          = $00000001;
  SCRIPTPROP_MINORVERSION          = $00000002;
  SCRIPTPROP_BUILDNUMBER           = $00000003;

  SCRIPTPROP_DELAYEDEVENTSINKING   = $00001000;
  SCRIPTPROP_CATCHEXCEPTION        = $00001001;

  SCRIPTPROP_DEBUGGER              = $00001100;
  SCRIPTPROP_JITDEBUG              = $00001101;

// These properties are defined and available, but are not officially supported.

  SCRIPTPROP_HACK_FIBERSUPPORT     =  $70000000;
  SCRIPTPROP_HACK_TRIDENTEVENTSINK =  $70000001;

type
  TOleEnum = Cardinal;

  tagSCRIPTSTATE = TOleEnum;
  SCRIPTSTATE = tagSCRIPTSTATE;
  TScriptStateEnum = tagSCRIPTSTATE;
  PScriptState = ^TScriptStateEnum;

const
  SCRIPTSTATE_UNINITIALIZED	    = 0;
  SCRIPTSTATE_INITIALIZED	    = 5;
  SCRIPTSTATE_STARTED	            = 1;
  SCRIPTSTATE_CONNECTED	            = 2;
  SCRIPTSTATE_DISCONNECTED	    = 3;
  SCRIPTSTATE_CLOSED	            = 4;

// script thread state values

type
  tagSCRIPTTHREADSTATE = TOleEnum;
  SCRIPTTHREADSTATE = tagSCRIPTTHREADSTATE;
  TScriptThreadState = tagSCRIPTTHREADSTATE;
  PScriptThreadState = ^TScriptThreadState;

const
  SCRIPTTHREADSTATE_NOTINSCRIPT	    = 0;
  SCRIPTTHREADSTATE_RUNNING	    = 1;

// Thread IDs

type
  SCRIPTTHREADID = DWORD;
  TScriptThreadId = SCRIPTTHREADID;

const
  SCRIPTTHREADID_CURRENT = TScriptThreadId(-1);
  SCRIPTTHREADID_BASE    = TScriptThreadId(-2);
  SCRIPTTHREADID_ALL     = TScriptThreadId(-3);

const
  (*SID_IActiveScriptError = '{EAE1BA61-A4ED-11CF-8F20-00805F2CD064}';
  SID_IActiveScriptSite   = '{DB01A1E3-A42B-11CF-8F20-00805F2CD064}';
  SID_IActiveScriptSiteWindow = '{D10F6761-83E9-11CF-8F20-00805F2CD064}';
  SID_IActiveScriptSiteInterruptPoll = '{539698A0-CDCA-11CF-A5EB-00AA0047A063}';
  SID_IActiveScript = '{BB1A2AE1-A4F9-11CF-8F20-00805F2CD064}';
  SID_IActiveScriptParse = '{BB1A2AE2-A4F9-11CF-8F20-00805F2CD064}';
  SID_IActiveScriptParseProcedureOld = '{1CFF0050-6FDD-11D0-9328-00A0C90DCAA9}';
  SID_IActiveScriptParseProcedure = '{AA5B6A80-B834-11D0-932F-00A0C90DCAA9}';
  SID_IActiveScriptParseProcedure2 = '{71EE5B20-FB04-11D1-B3A8-00A0C911E8B2}';
  SID_IActiveScriptEncode = '{BB1A2AE3-A4F9-11CF-8F20-00805F2CD064}';
  SID_IActiveScriptHostEncode = '{BEE9B76E-CFE3-11D1-B747-00C04FC2B085}';
  SID_IBindEventHandler = '{63CDBCB0-C1B1-11D0-9336-00A0C90DCAA9}';
  SID_IActiveScriptStats = '{B8DA6310-E19B-11D0-933C-00A0C90DCAA9}';
  SID_IActiveScriptProperty = '{4954E0D0-FBC7-11D1-8410-006008C3FBFC}';
  SID_ITridentEventSink = '{1DC9CA50-06EF-11D2-8415-006008C3FBFC}';*)
  SCATID_ActiveScript = '{F0B7A1A1-9847-11cf-8F20-00805F2CD064}';
  SCATID_ActiveScriptParse = '{F0B7A1A2-9847-11cf-8F20-00805F2CD064}';
  SID_IActiveScript =        '{BB1A2AE1-A4F9-11cf-8F20-00805F2CD064}';
  {$IFDEF WIN64}
    SID_IActiveScriptParse =  '{C7EF7658-E1EE-480E-97EA-D52CB4D76D17}';
    SID_IActiveScriptParseProcedureOld ='{21F57128-08C9-4638-BA12-22D15D88DC5C}';
    SID_IActiveScriptParseProcedure = '{C64713B6-E029-4CC5-9200-438B72890B6A}';
    SID_IActiveScriptParseProcedure2 = '{FE7C4271-210c-448d-9f54-76dab7047b28}';
    SID_IActiveScriptError =  '{B21FB2A1-5B8F-4963-8C21-21450F84ED7F}';
  {$ELSE}
    SID_IActiveScriptParse =  '{BB1A2AE2-A4F9-11cf-8F20-00805F2CD064}';
    SID_IActiveScriptParseProcedureOld ='{1CFF0050-6FDD-11d0-9328-00A0C90DCAA9}';
    SID_IActiveScriptParseProcedure =   '{AA5B6A80-B834-11d0-932F-00A0C90DCAA9}';
    SID_IActiveScriptParseProcedure2 = '{71EE5B20-FB04-11D1-B3A8-00A0C911E8B2}';
    SID_IActiveScriptError =     '{EAE1BA61-A4ED-11cf-8F20-00805F2CD064}';
  {$ENDIF}
  SID_IActiveScriptSite =        '{DB01A1E3-A42B-11cf-8F20-00805F2CD064}';
  SID_IActiveScriptSiteWindow =  '{D10F6761-83E9-11cf-8F20-00805F2CD064}';
  SID_IActiveScriptSiteInterruptPoll ='{539698A0-CDCA-11CF-A5EB-00AA0047A063}';
  SID_IBindEventHandler =  '{63CDBCB0-C1B1-11d0-9336-00A0C90DCAA9}';
  SID_IActiveScriptStats = '{B8DA6310-E19B-11d0-933C-00A0C90DCAA9}';

{ IActiveScriptError interface }

type
   IActiveScriptError = interface(IUnknown)
     [SID_IActiveScriptError]
     ///function GetExceptionInfo(out ExcepInfo: TExcepInfo): HResult; stdcall;
     function GetSourcePosition(out SourceContext: Cardinal;
       out LineNumber: Cardinal; out CharacterPosition: Integer): HResult; stdcall;
     function GetSourceLineText(out SourceLine: PWideChar): HResult; stdcall;
   end;

{ IActiveScriptSite interface }

  IActiveScriptSite = interface(IUnknown)
    [SID_IActiveScriptSite]
    function GetLCID(out lcid: LongWord): HResult; stdcall;
    ///function GetItemInfo(Name: PWideChar; ReturnMask: DWORD;
    ///  out unkItem: IUnknown; out Info: ITypeInfo): HResult; stdcall;
    function GetDocVersionString(out Version: PWideChar): HResult; stdcall;
    ///function OnScriptTerminate(const varResult: OleVariant;
    ///  const ExcepInfo: TExcepInfo): HResult; stdcall;
    function OnStateChange(ScriptState: TScriptStateEnum): HResult; stdcall;
    function OnScriptError(ScriptError: IActiveScriptError): HResult; stdcall;
    function OnEnterScript: HResult; stdcall;
    function OnLeaveScript: HResult; stdcall;
  end;

{ IActiveScriptSiteWindow interface }

  IActiveScriptSiteWindow = interface(IUnknown)
    [SID_IActiveScriptSiteWindow]
    function GetWindow(out Wnd: HWND): HResult; stdcall;
    function EnableModeless(Enable: BOOL): HResult; stdcall;
  end;

{ IActiveScriptSiteInterruptPoll interface }

  IActiveScriptSiteInterruptPoll = interface(IUnknown)
    [SID_IActiveScriptSiteInterruptPoll]
    function QueryContinue: HResult; stdcall;
  end;

{ IActiveScript interface }

  IActiveScript = interface(IUnknown)
    [SID_IActiveScript]
    function SetScriptSite(ScriptSite: IActiveScriptSite): HResult; stdcall;
    function GetScriptSite(const IID: TGUID; out Obj): HResult; stdcall;
    function SetScriptState(State: TScriptStateEnum): HResult; stdcall;
    function GetScriptState(out State: TScriptStateEnum): HResult; stdcall;
    function Close: HResult; stdcall;
    function AddNamedItem(Name: PWideChar; Flags: Cardinal): HResult; stdcall;
    ///function AddTypeLib(const TypeLib: TCLSID; Major: Cardinal;
    ///  Minor: Cardinal; Flags: Cardinal): HResult; stdcall;
    function GetScriptDispatch(ItemName: PWideChar; out Disp: IDispatch): HResult; stdcall;
    function GetCurrentScriptThreadID(out Thread: TScriptThreadId): HResult; stdcall;
    function GetScriptThreadID(Win32Thread: THandle; out Thread: TScriptThreadId): HResult; stdcall;
    function GetScriptThreadState(Thread: TScriptThreadId;
      out State: TScriptThreadState): HResult; stdcall;
    ///function InterruptScriptThread(Thread: TScriptThreadId;
    ///  out ExcepInfo: TExcepInfo; Flags: Cardinal): HResult; stdcall;
    function Clone(out Script: IActiveScript): HResult; stdcall;
  end;

{ IActiveScriptParse interface }

  IActiveScriptParse = interface(IUnknown)
    [SID_IActiveScriptParse]
    function InitNew: HResult; stdcall;
    ///function AddScriptlet(DefaultName, Code, ItemName, SubItemName, EventName,
    ///  Delimiter: PWideChar; SourceContextCookie, StartingLineNumber,
    ///  Flags: Cardinal; out Name: PWideChar; out ExcepInfo: TExcepInfo): HResult; stdcall;
    ///function ParseScriptText(Code, ItemName: PWideChar; Context: IUnknown;
    ///   Delimiter: PWideChar; SourceContextCookie, StartingLineNumber, Flags: Cardinal;
    ///   varResult: PVariant; ExcepInfo: PExcepInfo): HResult; stdcall;
  end;

{ IActiveScriptParseProcedure interface }

  ULONG = Cardinal ;

  IActiveScriptParseProcedure = interface(IUnknown)
    [SID_IActiveScriptParseProcedure]
    function ParseProcedureText(
      ///pstrCode: POLESTR;
      ///pstrFormalParams: POLESTR;
      ///pstrProcedureName: POLESTR;
      ///pstrItemName: POLESTR;
      const punkContext: IUnknown;
      ///pstrDelimiter: POLESTR;
      dwSourceContextCookie: DWORD;
      ulStartingLineNumber: ULONG;
      dwFlags: DWORD;
      out ppdisp: IDispatch): HResult; stdcall;
  end;

{ IActiveScriptParseProcedure2 interface }

  IActiveScriptParseProcedure2 = interface(IActiveScriptParseProcedure)
    [SID_IActiveScriptParseProcedure2]
  end;

implementation

(*{ IActiveScriptParseProcedureOld interface }

  IActiveScriptParseProcedureOld = interface(IUnknown)
    [SID_IActiveScriptParseProcedureOld]
    function ParseProcedureText(
          /* [in] */ LPCOLESTR pstrCode,
          /* [in] */ LPCOLESTR pstrFormalParams,
          /* [in] */ LPCOLESTR pstrItemName,
          /* [in] */ IUnknown *punkContext,
          /* [in] */ LPCOLESTR pstrDelimiter,
          /* [in] */ DWORD dwSourceContextCookie,
          /* [in] */ ULONG ulStartingLineNumber,
          /* [in] */ DWORD dwFlags,
          /* [out] */ IDispatch **ppdisp): HResult; stdcall;
  end;

{ IActiveScriptParseProcedure interface }

  IActiveScriptParseProcedure = interface(IUnknown)
    [SID_IActiveScriptParseProcedure]
    function ParseProcedureText(
          /* [in] */ LPCOLESTR pstrCode,
          /* [in] */ LPCOLESTR pstrFormalParams,
          /* [in] */ LPCOLESTR pstrProcedureName,
          /* [in] */ LPCOLESTR pstrItemName,
          /* [in] */ IUnknown *punkContext,
          /* [in] */ LPCOLESTR pstrDelimiter,
          /* [in] */ DWORD dwSourceContextCookie,
          /* [in] */ ULONG ulStartingLineNumber,
          /* [in] */ DWORD dwFlags,
          /* [out] */ IDispatch **ppdisp): HResult; stdcall;
  end;

{ IActiveScriptParseProcedure2 interface }

  IActiveScriptParseProcedure2 = interface(IActiveScriptParseProcedure)
    [SID_IActiveScriptParseProcedure2]
  end;

{ IActiveScriptEncode interface }

  IActiveScriptEncode = interface(IUnknown)
    [SID_IActiveScriptEncode]
    function EncodeSection(
          /* [in] */ LPCOLESTR pchIn,
          /* [in] */ DWORD cchIn,
          /* [out][in] */ LPOLESTR pchOut,
          /* [in] */ DWORD cchOut,
          /* [out][in] */ DWORD *pcchRet): HResult; stdcall;
    function DecodeScript(
          /* [in] */ LPCOLESTR pchIn,
          /* [in] */ DWORD cchIn,
          /* [out][in] */ LPOLESTR pchOut,
          /* [in] */ DWORD cchOut,
          /* [out][in] */ DWORD *pcchRet): HResult; stdcall;
    function GetEncodeProgId(
          /* [out][in] */ BSTR *pbstrOut): HResult; stdcall;
  end;

{ IActiveScriptHostEncode interface }

  IActiveScriptHostEncode = interface(IUnknown)
    [SID_IActiveScriptHostEncode]
    function EncodeScriptHostFile(
          /* [in] */ BSTR bstrInFile,
          /* [out][in] */ BSTR *pbstrOutFile,
          /* [in] */ unsigned long cFlags,
          /* [in] */ BSTR bstrDefaultLang): HResult; stdcall;
  end;

{ IBindEventHandler interface }

  IBindEventHandler = interface(IUnknown)
    [SID_IBindEventHandler]
    function BindHandler(
          /* [in] */ LPCOLESTR pstrEvent,
          /* [in] */ IDispatch *pdisp): HResult; stdcall;
  end;

{ IActiveScriptStats interface }

  IActiveScriptStats = interface(IUnknown)
    [SID_IActiveScriptStats]
    function GetStat(
          /* [in] */ DWORD stid,
          /* [out] */ ULONG *pluHi,
          /* [out] */ ULONG *pluLo): HResult; stdcall;
    function GetStatEx(
          /* [in] */ REFGUID guid,
          /* [out] */ ULONG *pluHi,
          /* [out] */ ULONG *pluLo): HResult; stdcall;
    function ResetStats: HResult; stdcall;
  end;

{ IActiveScriptProperty interface }

  IActiveScriptProperty = interface(IUnknown)
    [SID_IActiveScriptProperty]
    function GetProperty(
          /* [in] */ DWORD dwProperty,
          /* [in] */ VARIANT *pvarIndex,
          /* [out] */ VARIANT *pvarValue): HResult; stdcall;
    function SetProperty(
          /* [in] */ DWORD dwProperty,
          /* [in] */ VARIANT *pvarIndex,
          /* [in] */ VARIANT *pvarValue): HResult; stdcall;
  end;

{ ITridentEventSink interface }

  ITridentEventSink = interface(IUnknown)
    [SID_ITridentEventSink]
    function FireEvent(
          /* [in] */ LPCOLESTR pstrEvent,
          /* [in] */ DISPPARAMS *pdp,
          /* [out] */ VARIANT *pvarRes,
          /* [out] */ EXCEPINFO *pei): HResult; stdcall;
  end; *)

end.
