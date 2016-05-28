  {      LDAPAdmin - Lang.pas
  *      Copyright (C) 2013 Tihomir Karlovic
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

unit Lang;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
    {$ifdef FPC}
    LResources, DelphiReader,
    {$endif}
    Forms, Xml, XmlLoader, Classes;

const
  MAX_STRING_ID = 580;
  LANG_EXT      = 'llf';

type
  ///TMyReader = class(TReader);
  TMyReader = class(TDelphiReader);

  PPatchBlock = ^TPatchBlock;
  TPatchBlock = packed record
    OpCode: Byte;
    RelJump: LongInt; // 4 Bytes even on x64 platforms
  end;

  THookForm =     class(TCustomForm)
    procedure     HookDoCreate;
  end;

  TRedirectCode = class
    fPatchPtr:    PPatchBlock;
    fPatchBlock:  TPatchBlock;
    fSaveBlock:   TPatchBlock;
  public
    procedure     Enable;
    procedure     Disable;
    constructor   Create(OldProc, NewProc: Pointer);
    destructor    Destroy; override;
  end;

  TTranslator =         class
  private
    fXmlTree:     TXmlTree;
    fXmlForms:    TXmlNode;
    fXmlStrings:  TXmlNode;
    fStringTable: array[1..MAX_STRING_ID] of Integer;
    fName:        string;
    fRedirectStr: TRedirectCode;
    fRedirectForm:TRedirectCode;
    function      GetString(Index: Integer): string;
  public
    procedure     Enable;
    procedure     Disable;
    procedure     TranslateForm(Form: TCustomForm);
    procedure     RestoreForm(Form: TCustomForm);
    procedure     LoadFromFile(const FileName: string); // test
    constructor   Create;
    destructor    Destroy; override;
    property      Name: string read fName;
  end;

  TLangLoader =   class(TXmlLoader)
  private
    fCurrentLanguage: Integer;
    fTranslator:  TTranslator;
    function      GetLanguageName(Index: Integer): string;
    procedure     SetCurrentLanguage(Value: Integer);
  public
    constructor   Create; override;
    function      Parse(const FileName: string): TObject; override;
    property      Languages[Index: Integer]: string read GetLanguageName;
    property      CurrentLanguage: Integer read fCurrentLanguage write SetCurrentLanguage;
    property      Translator: TTranslator read fTranslator;
  end;

var
  LanguageLoader: TLangLoader;

implementation

{$I LdapAdmin.inc}

uses
{$IFnDEF FPC}
 {$IFDEF VER130}ComConst,{$ENDIF}{$IFDEF D6UP} RTLConsts, ComConst,
     WinHelpViewer, {$ENDIF}
  Consts, OleConst, ComStrs, jconsts, Windows,
{$ELSE}
  LCLIntf, LCLType, LMessages, RtlConsts,
{$ENDIF}
  TypInfo, Config, SysUtils,
     Dialogs, Constant, Graphics,
     ComCtrls, ExtCtrls, SysConst, StdCtrls, Math, Misc;

function HookLoadResString(ResStringRec: PResStringRec):string;
var
  Buffer: array [0..2047] of Char;
begin
  if ResStringRec = nil then exit;

  ///Result := LanguageLoader.Translator.GetString(ResStringRec.Identifier);

  {if Result = '' then with LanguageLoader.Translator do
  begin
    fRedirectStr.Disable;
    result := LoadResString(ResStringRec);
    fRedirectStr.Enable;
  end;}

  ///if (Result = '') then
  ///  if (ResStringRec.Identifier < 64*1024) then  // direct API call
  ///    SetString(Result, Buffer, LoadString(FindResourceHInstance(ResStringRec.Module^),
  ///              ResStringRec.Identifier, Buffer, SizeOf(Buffer)))
  ///  else
  ///    Result := PChar(ResStringRec.Identifier);
end;

procedure THookForm.HookDoCreate;
begin
  with LanguageLoader.Translator do begin
    fRedirectForm.Disable;
    DoCreate;
    TranslateForm(Self);
    fRedirectForm.Enable;
  end;
end;

{ TRedirectCode }

procedure TRedirectCode.Enable;
begin
  ///fPatchPtr^ := fPatchBlock;
end;

procedure TRedirectCode.Disable;
begin
  ///fPatchPtr^ := fSaveBlock;
end;

constructor TRedirectCode.Create(OldProc, NewProc: Pointer);
var
  OldProtection: Cardinal;
begin

  fPatchPtr := OldProc;
  move(fPatchPtr^, fSaveBlock, SizeOf(TPatchBlock));

  ///if not VirtualProtect(fPatchPtr, SizeOf(TPatchBlock), PAGE_EXECUTE_READWRITE, @OldProtection) then
  ///  RaiseLastWin32Error;

  fPatchBlock.OpCode := $E9;
  fPatchBlock.RelJump := LongInt(NewProc) - LongInt(OldProc) - SizeOf(TPatchBlock);

end;

destructor TRedirectCode.Destroy;
begin
  Disable;
  inherited;
end;

{ TTranslator }

function TTranslator.GetString(Index: Integer): string;
var
  Node: TXmlNode;
begin
  Result := '';
  Index := $10000 - Index;
  if Index < 0 then
    exit;
  if Assigned(fXmlStrings) then
  begin
    Node := fXmlStrings.NodeByName('s' + IntToStr(fStringTable[Index]));
    if Assigned(Node) then
      Result := CStrToString(Node.Content);
  end;
end;

procedure TTranslator.Enable;
begin
  fRedirectStr.Enable;
  fRedirectForm.Enable;
end;

procedure TTranslator.Disable;
begin
  fRedirectStr.Disable;
  fRedirectForm.Disable;
end;

procedure TTranslator.TranslateForm(Form: TCustomForm);
var
  Node: TXmlNode;
  i, j: Integer;
  ct: TComponent;
  nj: TXmlNode;
  obj: TObject;
  PropInfo: PPropInfo;

  procedure DoStrings;
  var
    i: Integer;
  begin
    if ct is TCustomComboBox then with TCustomComboBox(ct) do
    begin
      i := ItemIndex;
      Items.CommaText := nj.Content;
      if i < Items.Count then
        ItemIndex := i
      else
      if Items.Count > 0 then
        ItemIndex := 0;
    end
    else
      TStrings(obj).CommaText := nj.Content
  end;

  procedure DoListColumns(Node: TXmlNode);
  var
    i, j: Integer;
  begin
    if not Assigned(Node) then
      exit;
    with TListColumns(obj) do
    begin
      for i := 0 to Min(Node.Count, Count) - 1 do with Node[i] do
        if Name = 'column' then
          for j := 0 to Count - 1 do with Node[i][j] do
            SetPropValue(Items[i], Name, Content);
    end;
  end;

  procedure DoListItems(Node: TXmlNode);
  var
    i, j: Integer;
  begin
    if not Assigned(Node) then
      exit;
    with TListItems(obj) do
    begin
      for i := 0 to Min(Node.Count, Count) - 1 do with Node[i] do
        if Name = 'item' then
          for j := 0 to Count - 1 do with Node[i][j] do
            if Name = 'caption' then
              TListItem(Item[i]).Caption := Content
            else
            if Name = 'subitems' then
              TStrings(Item[i].Subitems).CommaText := Content;
    end;
  end;

begin
  if not Assigned(fXmlForms) then
    exit;

  Node := fXmlForms.NodeByName(Form.Name);

  if not Assigned(Node) then
    exit;

  for i := 0 to Node.Count - 1 do with Node.Nodes[i] do
  begin
    if Name = 'component' then
    begin
      ct := Form.FindComponent(Attributes.Values['name']);
      if Assigned(ct) then
        for j := 0 to Count - 1 do
        begin
          nj := Nodes[j];
          PropInfo := GetPropInfo(ct, nj.Name);
          ///if Assigned(PropInfo) and (PropInfo^.PropType^^.Kind = tkClass) then
          if Assigned(PropInfo) and (PropInfo^.PropType^.Kind = tkClass) then
          begin
            obj := TObject(Integer(GetPropValue(ct, nj.Name)));
            if obj is TStrings then
              DoStrings
            else
            if obj is TListColumns then
              DoListColumns(NodeByName('columns'))
            else
            if obj is TListItems then
              DoListItems(NodeByName('items'))
          end
          else
            SetPropValue(ct, nj.Name, nj.Content);
        end;
    end
    else
      SetPropValue(Form, Name, Content);
  end;
end;

procedure TTranslator.RestoreForm(Form: TCustomForm);
var
  rs: TResourceStream;
  Node: TXmlNode;
  ///Reader: TReader;
  Reader: TDelphiReader;
  Flags: TFilerFlags;
  Pos: Integer;
  ComponentName: string;


  procedure RestoreProperty(ct: TPersistent; Node: TXmlNode); forward;

  procedure RestoreValue(ct: TPersistent; Node: TXmlNode; const PropName: string);
  var
    i: Integer;
  begin
    case Reader.NextValue of
      { vaList: }
      dvaInt8, dvaInt16, dvaInt32:
        SetPropValue(ct, PropName, IntToStr(Reader.ReadInteger));
      dvaExtended:
        SetPropValue(ct, PropName, FloatToStr(Reader.ReadFloat));
      dvaSingle:
        SetPropValue(ct, PropName, FloatToStr(Reader.ReadSingle));
      dvaCurrency:
        SetPropValue(ct, PropName, FloatToStr(Reader.ReadCurrency));
      dvaDate:
        SetPropValue(ct, PropName, FloatToStr(Reader.ReadDate));
      dvaWString:
        ///SetPropValue(ct, PropName, Reader.ReadWideString);
        SetPropValue(ct, PropName, Reader.ReadString);
      dvaString, dvaLString:
        SetPropValue(ct, PropName, Reader.ReadString);
      dvaIdent, dvaFalse, dvaTrue, dvaNil, dvaNull:
        SetPropValue(ct, PropName, Reader.ReadIdent);
      { vaBinary:
        vaSet: }
      dvaCollection:
        begin
          Reader.ReadValue;
          i := 0;
          while not Reader.EndOfList do
          begin
            if Reader.NextValue in [dvaInt8, dvaInt16, dvaInt32] then
              RestoreValue(ct, Node, PropName);
            if ct is TListView then
            begin
              Reader.CheckValue(dvaList);
              while not Reader.EndOfList do RestoreProperty(TListView(ct).Columns[i], Node[i]);
              Reader.ReadListEnd;
            end
            else
              TMyReader(Reader).SkipValue;
            inc(i);
          end;
          Reader.ReadListEnd;
        end;
      dvaInt64:
        SetPropValue(ct, PropName, IntToStr(Reader.ReadInt64));
    end;
  end;

  procedure RestoreProperty(ct: TPersistent; Node: TXmlNode);
  var
    PropertyName: string;
    i: Integer;
  begin
    PropertyName := Reader.ReadStr;
    for i := 0 to Node.Count - 1 do
      if CompareText(Node.Nodes[i].Name, PropertyName) = 0 then
      begin
        RestoreValue(ct, Node.Nodes[i], PropertyName);
        exit;
      end;
    TMyReader(Reader).SkipValue;
  end;

  procedure RestoreProperties;
  var
    i: Integer;
    ct: TComponent;
    CNode: TXmlNode;
  begin

    Reader.ReadPrefix(Flags, Pos);
    Reader.ReadStr; // class name
    ComponentName := Reader.ReadStr;

    CNode := nil;
    ct := nil;
    for i := 0 to Node.Count - 1 do with Node.Nodes[i] do
      if (Name = 'component') and (Attributes.Values['name'] = ComponentName) then
      begin
        CNode := Node.Nodes[i];
        ct := Form.FindComponent(Attributes.Values['name']);
        break;
      end;

    with TMyReader(Reader) do
    begin
      if not (Assigned(CNode) and Assigned(ct)) then
        while not EndOfList do SkipProperty
      else
        while not EndOfList do RestoreProperty(ct, CNode);
      ReadListEnd;

      while not EndOfList do RestoreProperties;
      ReadListEnd;
    end;
  end;


begin
  if not Assigned(fXmlForms) then
    exit;

  Node := fXmlForms.NodeByName(Form.Name);

  if not Assigned(Node) then
    exit;

  rs := TResourceStream.Create(HInstance, Form.ClassName, RT_RCDATA);
  try
    try
      ///Reader := TReader.Create(rs, 4096);
      Reader := TDelphiReader.Create(rs);
      Reader.ReadSignature;
      RestoreProperties;
    finally
      Reader.Free;
    end;
  finally
    rs.Free;
  end;
end;


procedure TTranslator.LoadFromFile(const FileName: string);
var
  i: Integer;
begin
  fXmlTree.LoadFromFile(FileName);
  for i := 0 to fXmlTree.Root.Count - 1 do with fXmlTree.Root[i] do
    if Name = 'language' then
      fName := Content
    else
    if Name = 'forms' then
      fXmlForms := fXmlTree.Root[i]
    else
    if Name = 'strings' then
      fXmlStrings := fXmlTree.Root[i];
end;

constructor TTranslator.Create;
begin
  inherited;
  fXmlTree:=TXmlTree.Create;
  fXmlTree.Markups := true;
  (*
  fRedirectForm := TRedirectCode.Create(@THookForm.DoCreate, @THookForm.HookDoCreate);
  fRedirectStr := TRedirectCode.Create(@System.LoadResString, @HookLoadResString);

  {$IFDEF VER130}
  fStringTable[$10000 - PResStringRec(@SysConst.SRangeError     ).Identifier] := 463;
  fStringTable[$10000 - PResStringRec(@SysConst.SDivByZero      ).Identifier] := 462;
  fStringTable[$10000 - PResStringRec(@SysConst.SInvalidInput   ).Identifier] := 461;
  fStringTable[$10000 - PResStringRec(@SysConst.SDiskFull       ).Identifier] := 460;
  fStringTable[$10000 - PResStringRec(@SysConst.SEndOfFile      ).Identifier] := 459;
  fStringTable[$10000 - PResStringRec(@SysConst.SAccessDenied   ).Identifier] := 458;
  fStringTable[$10000 - PResStringRec(@SysConst.STooManyOpenFiles).Identifier] := 457;
  fStringTable[$10000 - PResStringRec(@SysConst.SInvalidFilename).Identifier] := 456;
  fStringTable[$10000 - PResStringRec(@SysConst.SFileNotFound   ).Identifier] := 455;
  fStringTable[$10000 - PResStringRec(@SysConst.SInOutError     ).Identifier] := 454;
  fStringTable[$10000 - PResStringRec(@SysConst.SOutOfMemory    ).Identifier] := 453;
  fStringTable[$10000 - PResStringRec(@SysConst.SDateEncodeError).Identifier] := 452;
  fStringTable[$10000 - PResStringRec(@SysConst.STimeEncodeError).Identifier] := 451;
  fStringTable[$10000 - PResStringRec(@SysConst.SInvalidDateTime).Identifier] := 450;
  fStringTable[$10000 - PResStringRec(@SysConst.SInvalidFloat   ).Identifier] := 449;
  fStringTable[$10000 - PResStringRec(@SysConst.SInvalidInteger ).Identifier] := 448;
  fStringTable[$10000 - PResStringRec(@SysConst.SArgumentMissing).Identifier] := 416;
  fStringTable[$10000 - PResStringRec(@SysConst.SInvalidFormat  ).Identifier] := 447;
  fStringTable[$10000 - PResStringRec(@SysConst.SExceptTitle    ).Identifier] := 446;
  fStringTable[$10000 - PResStringRec(@SysConst.SException      ).Identifier] := 445;
  fStringTable[$10000 - PResStringRec(@SysConst.SOperationAborted).Identifier] := 444;
  fStringTable[$10000 - PResStringRec(@SysConst.SPrivilege      ).Identifier] := 443;
  fStringTable[$10000 - PResStringRec(@SysConst.SControlC       ).Identifier] := 442;
  fStringTable[$10000 - PResStringRec(@SysConst.SStackOverflow  ).Identifier] := 441;
  fStringTable[$10000 - PResStringRec(@SysConst.SInvalidCast    ).Identifier] := 438;
  fStringTable[$10000 - PResStringRec(@SysConst.SInvalidPointer ).Identifier] := 437;
  fStringTable[$10000 - PResStringRec(@SysConst.SUnderflow      ).Identifier] := 436;
  fStringTable[$10000 - PResStringRec(@SysConst.SOverflow       ).Identifier] := 435;
  fStringTable[$10000 - PResStringRec(@SysConst.SZeroDivide     ).Identifier] := 434;
  fStringTable[$10000 - PResStringRec(@SysConst.SInvalidOp      ).Identifier] := 433;
  fStringTable[$10000 - PResStringRec(@SysConst.SIntOverflow    ).Identifier] := 432;
  fStringTable[$10000 - PResStringRec(@SysConst.SModuleAccessViolation).Identifier] := 408;
  fStringTable[$10000 - PResStringRec(@SysConst.SAbstractError  ).Identifier] := 407;
  fStringTable[$10000 - PResStringRec(@SysConst.SAssertError    ).Identifier] := 406;
  fStringTable[$10000 - PResStringRec(@SysConst.SSafecallException).Identifier] := 405;
  fStringTable[$10000 - PResStringRec(@SysConst.SIntfCastError  ).Identifier] := 404;
  fStringTable[$10000 - PResStringRec(@SysConst.SAssertionFailed).Identifier] := 403;
  fStringTable[$10000 - PResStringRec(@SysConst.SExternalException).Identifier] := 402;
  fStringTable[$10000 - PResStringRec(@SysConst.SVarArrayBounds ).Identifier] := 421;
  fStringTable[$10000 - PResStringRec(@SysConst.SVarArrayCreate ).Identifier] := 420;
  fStringTable[$10000 - PResStringRec(@SysConst.SWriteAccess    ).Identifier] := 419;
  fStringTable[$10000 - PResStringRec(@SysConst.SReadAccess     ).Identifier] := 418;
  fStringTable[$10000 - PResStringRec(@SysConst.SDispatchError  ).Identifier] := 417;
  fStringTable[$10000 - PResStringRec(@SysConst.SInvalidVarOp   ).Identifier] := 424;
  fStringTable[$10000 - PResStringRec(@SysConst.SInvalidVarCast ).Identifier] := 423;
  fStringTable[$10000 - PResStringRec(@SysConst.SLongMonthNameMar).Identifier] := 393;
  fStringTable[$10000 - PResStringRec(@SysConst.SLongMonthNameFeb).Identifier] := 392;
  fStringTable[$10000 - PResStringRec(@SysConst.SLongMonthNameJan).Identifier] := 391;
  fStringTable[$10000 - PResStringRec(@SysConst.SShortMonthNameDec).Identifier] := 390;
  fStringTable[$10000 - PResStringRec(@SysConst.SShortMonthNameNov).Identifier] := 389;
  fStringTable[$10000 - PResStringRec(@SysConst.SShortMonthNameOct).Identifier] := 388;
  fStringTable[$10000 - PResStringRec(@SysConst.SShortMonthNameSep).Identifier] := 387;
  fStringTable[$10000 - PResStringRec(@SysConst.SShortMonthNameAug).Identifier] := 386;
  fStringTable[$10000 - PResStringRec(@SysConst.SShortMonthNameJul).Identifier] := 385;
  fStringTable[$10000 - PResStringRec(@SysConst.SShortMonthNameJun).Identifier] := 384;
  fStringTable[$10000 - PResStringRec(@SysConst.SShortMonthNameMay).Identifier] := 415;
  fStringTable[$10000 - PResStringRec(@SysConst.SShortMonthNameApr).Identifier] := 414;
  fStringTable[$10000 - PResStringRec(@SysConst.SShortMonthNameMar).Identifier] := 413;
  fStringTable[$10000 - PResStringRec(@SysConst.SShortMonthNameFeb).Identifier] := 412;
  fStringTable[$10000 - PResStringRec(@SysConst.SShortMonthNameJan).Identifier] := 411;
  fStringTable[$10000 - PResStringRec(@SysConst.SShortDayNameSat).Identifier] := 376;
  fStringTable[$10000 - PResStringRec(@SysConst.SShortDayNameFri).Identifier] := 375;
  fStringTable[$10000 - PResStringRec(@SysConst.SShortDayNameThu).Identifier] := 374;
  fStringTable[$10000 - PResStringRec(@SysConst.SShortDayNameWed).Identifier] := 373;
  fStringTable[$10000 - PResStringRec(@SysConst.SShortDayNameTue).Identifier] := 372;
  fStringTable[$10000 - PResStringRec(@SysConst.SShortDayNameMon).Identifier] := 371;
  fStringTable[$10000 - PResStringRec(@SysConst.SShortDayNameSun).Identifier] := 370;
  fStringTable[$10000 - PResStringRec(@SysConst.SLongMonthNameDec).Identifier] := 369;
  fStringTable[$10000 - PResStringRec(@SysConst.SLongMonthNameNov).Identifier] := 368;
  fStringTable[$10000 - PResStringRec(@SysConst.SLongMonthNameOct).Identifier] := 367;
  fStringTable[$10000 - PResStringRec(@SysConst.SLongMonthNameSep).Identifier] := 399;
  fStringTable[$10000 - PResStringRec(@SysConst.SLongMonthNameAug).Identifier] := 398;
  fStringTable[$10000 - PResStringRec(@SysConst.SLongMonthNameJul).Identifier] := 397;
  fStringTable[$10000 - PResStringRec(@SysConst.SLongMonthNameJun).Identifier] := 396;
  fStringTable[$10000 - PResStringRec(@SysConst.SLongMonthNameMay).Identifier] := 395;
  fStringTable[$10000 - PResStringRec(@SysConst.SLongMonthNameApr).Identifier] := 394;
  fStringTable[$10000 - PResStringRec(@Consts.SInvalidImage     ).Identifier] := 306;
  fStringTable[$10000 - PResStringRec(@SysConst.SLongDayNameSat ).Identifier] := 383;
  fStringTable[$10000 - PResStringRec(@SysConst.SLongDayNameFri ).Identifier] := 382;
  fStringTable[$10000 - PResStringRec(@SysConst.SLongDayNameThu ).Identifier] := 381;
  fStringTable[$10000 - PResStringRec(@SysConst.SLongDayNameWed ).Identifier] := 380;
  fStringTable[$10000 - PResStringRec(@SysConst.SLongDayNameTue ).Identifier] := 379;
  fStringTable[$10000 - PResStringRec(@SysConst.SLongDayNameMon ).Identifier] := 378;
  fStringTable[$10000 - PResStringRec(@SysConst.SLongDayNameSun ).Identifier] := 377;
  fStringTable[$10000 - PResStringRec(@Consts.SInvalidTabStyle  ).Identifier] := 333;
  fStringTable[$10000 - PResStringRec(@Consts.SInvalidTabPosition).Identifier] := 332;
  fStringTable[$10000 - PResStringRec(@Consts.SInvalidTabIndex  ).Identifier] := 331;
  fStringTable[$10000 - PResStringRec(@Consts.SInvalidImageSize ).Identifier] := 314;
  fStringTable[$10000 - PResStringRec(@Consts.SNoCanvasHandle   ).Identifier] := 313;
  fStringTable[$10000 - PResStringRec(@Consts.SOutOfResources   ).Identifier] := 312;
  fStringTable[$10000 - PResStringRec(@Consts.SUnknownClipboardFormat).Identifier] := 311;
  fStringTable[$10000 - PResStringRec(@Consts.SUnknownExtension ).Identifier] := 310;
  fStringTable[$10000 - PResStringRec(@Consts.SOleGraphic       ).Identifier] := 309;
  fStringTable[$10000 - PResStringRec(@Consts.SChangeIconSize   ).Identifier] := 308;
  fStringTable[$10000 - PResStringRec(@Consts.SScanLine         ).Identifier] := 307;
  fStringTable[$10000 - PResStringRec(@Consts.SInvalidPixelFormat).Identifier] := 305;
  fStringTable[$10000 - PResStringRec(@Consts.SInvalidMetafile  ).Identifier] := 304;
  fStringTable[$10000 - PResStringRec(@Consts.SInvalidIcon      ).Identifier] := 335;
  fStringTable[$10000 - PResStringRec(@Consts.SInvalidBitmap    ).Identifier] := 334;
  fStringTable[$10000 - PResStringRec(@Consts.SMenuReinserted   ).Identifier] := 299;
  fStringTable[$10000 - PResStringRec(@Consts.SMenuIndexError   ).Identifier] := 298;
  fStringTable[$10000 - PResStringRec(@Consts.SPropertyOutOfRange).Identifier] := 297;
  fStringTable[$10000 - PResStringRec(@Consts.SScrollBarRange   ).Identifier] := 296;
  fStringTable[$10000 - PResStringRec(@Consts.SCannotShowModal  ).Identifier] := 295;
  fStringTable[$10000 - PResStringRec(@Consts.SVisibleChanged   ).Identifier] := 294;
  fStringTable[$10000 - PResStringRec(@Consts.SMDIChildNotVisible).Identifier] := 293;
  fStringTable[$10000 - PResStringRec(@Consts.SParentRequired   ).Identifier] := 291;
  fStringTable[$10000 - PResStringRec(@Consts.SCannotFocus      ).Identifier] := 290;
  fStringTable[$10000 - PResStringRec(@Consts.SWindowClass      ).Identifier] := 289;
  fStringTable[$10000 - PResStringRec(@Consts.SWindowDCError    ).Identifier] := 288;
  fStringTable[$10000 - PResStringRec(@Consts.SImageWriteFail   ).Identifier] := 319;
  fStringTable[$10000 - PResStringRec(@Consts.SImageReadFail    ).Identifier] := 318;
  fStringTable[$10000 - PResStringRec(@Consts.SImageIndexError  ).Identifier] := 317;
  fStringTable[$10000 - PResStringRec(@Consts.SReplaceImage     ).Identifier] := 316;
  fStringTable[$10000 - PResStringRec(@Consts.SInvalidImageList ).Identifier] := 315;
  fStringTable[$10000 - PResStringRec(@Consts.SIgnoreButton     ).Identifier] := 283;
  fStringTable[$10000 - PResStringRec(@Consts.SCloseButton      ).Identifier] := 282;
  fStringTable[$10000 - PResStringRec(@Consts.SHelpButton       ).Identifier] := 281;
  fStringTable[$10000 - PResStringRec(@Consts.SNoButton         ).Identifier] := 280;
  fStringTable[$10000 - PResStringRec(@Consts.SYesButton        ).Identifier] := 279;
  fStringTable[$10000 - PResStringRec(@Consts.SCancelButton     ).Identifier] := 278;
  fStringTable[$10000 - PResStringRec(@Consts.SOKButton         ).Identifier] := 277;
  fStringTable[$10000 - PResStringRec(@Consts.SControlParentSetToSelf).Identifier] := 276;
  fStringTable[$10000 - PResStringRec(@Consts.SNoMDIForm        ).Identifier] := 275;
  fStringTable[$10000 - PResStringRec(@Consts.SGroupIndexTooLow ).Identifier] := 274;
  fStringTable[$10000 - PResStringRec(@Consts.SDeviceOnPort     ).Identifier] := 273;
  fStringTable[$10000 - PResStringRec(@Consts.SInvalidPrinter   ).Identifier] := 272;
  fStringTable[$10000 - PResStringRec(@Consts.SPrinting         ).Identifier] := 303;
  fStringTable[$10000 - PResStringRec(@Consts.SNotPrinting      ).Identifier] := 302;
  fStringTable[$10000 - PResStringRec(@Consts.SNoTimers         ).Identifier] := 301;
  fStringTable[$10000 - PResStringRec(@Consts.SMenuNotFound     ).Identifier] := 300;
  fStringTable[$10000 - PResStringRec(@Consts.SMaskErr          ).Identifier] := 260;
  fStringTable[$10000 - PResStringRec(@Consts.SVBitmaps         ).Identifier] := 259;
  fStringTable[$10000 - PResStringRec(@Consts.SVIcons           ).Identifier] := 258;
  fStringTable[$10000 - PResStringRec(@Consts.SVEnhMetafiles    ).Identifier] := 257;
  fStringTable[$10000 - PResStringRec(@Consts.SVMetafiles       ).Identifier] := 256;
  fStringTable[$10000 - PResStringRec(@Consts.SCannotDragForm   ).Identifier] := 287;
  fStringTable[$10000 - PResStringRec(@Consts.SAllButton        ).Identifier] := 286;
  fStringTable[$10000 - PResStringRec(@Consts.SAbortButton      ).Identifier] := 285;
  fStringTable[$10000 - PResStringRec(@Consts.SRetryButton      ).Identifier] := 284;
  fStringTable[$10000 - PResStringRec(@Consts.SMsgDlgYesToAll   ).Identifier] := 244;
  fStringTable[$10000 - PResStringRec(@Consts.SMsgDlgNoToAll    ).Identifier] := 243;
  fStringTable[$10000 - PResStringRec(@Consts.SMsgDlgAll        ).Identifier] := 242;
  fStringTable[$10000 - PResStringRec(@Consts.SMsgDlgIgnore     ).Identifier] := 241;
  fStringTable[$10000 - PResStringRec(@Consts.SMsgDlgRetry      ).Identifier] := 240;
  fStringTable[$10000 - PResStringRec(@Consts.SMsgDlgAbort      ).Identifier] := 271;
  fStringTable[$10000 - PResStringRec(@Consts.SMsgDlgHelp       ).Identifier] := 270;
  fStringTable[$10000 - PResStringRec(@Consts.SMsgDlgCancel     ).Identifier] := 269;
  fStringTable[$10000 - PResStringRec(@Consts.SMsgDlgOK         ).Identifier] := 268;
  fStringTable[$10000 - PResStringRec(@Consts.SMsgDlgNo         ).Identifier] := 267;
  fStringTable[$10000 - PResStringRec(@Consts.SMsgDlgYes        ).Identifier] := 266;
  fStringTable[$10000 - PResStringRec(@Consts.SMsgDlgConfirm    ).Identifier] := 265;
  fStringTable[$10000 - PResStringRec(@Consts.SMsgDlgInformation).Identifier] := 264;
  fStringTable[$10000 - PResStringRec(@Consts.SMsgDlgError      ).Identifier] := 263;
  fStringTable[$10000 - PResStringRec(@Consts.SMsgDlgWarning    ).Identifier] := 262;
  fStringTable[$10000 - PResStringRec(@Consts.SMaskEditErr      ).Identifier] := 261;
  fStringTable[$10000 - PResStringRec(@Consts.SmkcShift         ).Identifier] := 228;
  fStringTable[$10000 - PResStringRec(@Consts.SmkcDel           ).Identifier] := 227;
  fStringTable[$10000 - PResStringRec(@Consts.SmkcIns           ).Identifier] := 226;
  fStringTable[$10000 - PResStringRec(@Consts.SmkcDown          ).Identifier] := 225;
  fStringTable[$10000 - PResStringRec(@Consts.SmkcRight         ).Identifier] := 224;
  fStringTable[$10000 - PResStringRec(@Consts.SmkcUp            ).Identifier] := 255;
  fStringTable[$10000 - PResStringRec(@Consts.SmkcLeft          ).Identifier] := 254;
  fStringTable[$10000 - PResStringRec(@Consts.SmkcHome          ).Identifier] := 253;
  fStringTable[$10000 - PResStringRec(@Consts.SmkcEnd           ).Identifier] := 252;
  fStringTable[$10000 - PResStringRec(@Consts.SmkcPgDn          ).Identifier] := 251;
  fStringTable[$10000 - PResStringRec(@Consts.SmkcPgUp          ).Identifier] := 250;
  fStringTable[$10000 - PResStringRec(@Consts.SmkcSpace         ).Identifier] := 249;
  fStringTable[$10000 - PResStringRec(@Consts.SmkcEnter         ).Identifier] := 248;
  fStringTable[$10000 - PResStringRec(@Consts.SmkcEsc           ).Identifier] := 247;
  fStringTable[$10000 - PResStringRec(@Consts.SmkcTab           ).Identifier] := 246;
  fStringTable[$10000 - PResStringRec(@Consts.SmkcBkSp          ).Identifier] := 245;
  fStringTable[$10000 - PResStringRec(@Consts.SNoDefaultPrinter ).Identifier] := 208;
  fStringTable[$10000 - PResStringRec(@Consts.SInvalidMemoSize  ).Identifier] := 239;
  fStringTable[$10000 - PResStringRec(@Consts.SDefault          ).Identifier] := 238;
  fStringTable[$10000 - PResStringRec(@Consts.SCannotOpenClipboard).Identifier] := 237;
  fStringTable[$10000 - PResStringRec(@Consts.SIconToClipboard  ).Identifier] := 236;
  fStringTable[$10000 - PResStringRec(@Consts.SInvalidClipFmt   ).Identifier] := 235;
  fStringTable[$10000 - PResStringRec(@Consts.SInsertLineError  ).Identifier] := 234;
  fStringTable[$10000 - PResStringRec(@Consts.sAllFilter        ).Identifier] := 233;
  fStringTable[$10000 - PResStringRec(@Consts.SOutOfRange       ).Identifier] := 232;
  fStringTable[$10000 - PResStringRec(@Consts.srNone            ).Identifier] := 231;
  fStringTable[$10000 - PResStringRec(@Consts.SmkcAlt           ).Identifier] := 230;
  fStringTable[$10000 - PResStringRec(@Consts.SmkcCtrl          ).Identifier] := 229;
  fStringTable[$10000 - PResStringRec(@ComStrs.sTabFailSet      ).Identifier] := 477;
  fStringTable[$10000 - PResStringRec(@ComStrs.sTabFailGetObject).Identifier] := 476;
  fStringTable[$10000 - PResStringRec(@ComStrs.sTabFailRetrieve ).Identifier] := 475;
  fStringTable[$10000 - PResStringRec(@ComStrs.sTabFailDelete   ).Identifier] := 474;
  fStringTable[$10000 - PResStringRec(@ComStrs.sTabFailClear    ).Identifier] := 473;
  fStringTable[$10000 - PResStringRec(@Consts.SDockZoneHasNoCtl ).Identifier] := 217;
  fStringTable[$10000 - PResStringRec(@Consts.SDockZoneNotFound ).Identifier] := 216;
  fStringTable[$10000 - PResStringRec(@Consts.SDockTreeRemoveError).Identifier] := 215;
  fStringTable[$10000 - PResStringRec(@Consts.SDockedCtlNeedsName).Identifier] := 214;
  fStringTable[$10000 - PResStringRec(@Consts.SCannotOpenAVI    ).Identifier] := 213;
  fStringTable[$10000 - PResStringRec(@Consts.SPreviewLabel     ).Identifier] := 212;
  fStringTable[$10000 - PResStringRec(@Consts.SPictureDesc      ).Identifier] := 211;
  fStringTable[$10000 - PResStringRec(@Consts.SPictureLabel     ).Identifier] := 210;
  fStringTable[$10000 - PResStringRec(@Consts.SDuplicateMenus   ).Identifier] := 209;
  fStringTable[$10000 - PResStringRec(@ComStrs.sFailSetCalMaxSelRange).Identifier] := 470;
  fStringTable[$10000 - PResStringRec(@ComStrs.sFailSetCalDateTime).Identifier] := 469;
  fStringTable[$10000 - PResStringRec(@ComStrs.sNeedAllowNone   ).Identifier] := 468;
  fStringTable[$10000 - PResStringRec(@ComStrs.sDateTimeMin     ).Identifier] := 467;
  fStringTable[$10000 - PResStringRec(@ComStrs.sDateTimeMax     ).Identifier] := 466;
  fStringTable[$10000 - PResStringRec(@ComStrs.sInvalidComCtl32 ).Identifier] := 465;
  fStringTable[$10000 - PResStringRec(@ComStrs.sPageIndexError  ).Identifier] := 464;
  fStringTable[$10000 - PResStringRec(@ComStrs.sUDAssociated    ).Identifier] := 486;
  fStringTable[$10000 - PResStringRec(@ComStrs.sRichEditSaveFail).Identifier] := 485;
  fStringTable[$10000 - PResStringRec(@ComStrs.sRichEditLoadFail).Identifier] := 484;
  fStringTable[$10000 - PResStringRec(@ComStrs.sRichEditInsertError).Identifier] := 483;
  fStringTable[$10000 - PResStringRec(@ComStrs.sInvalidOwner    ).Identifier] := 482;
  fStringTable[$10000 - PResStringRec(@ComStrs.sInsertError     ).Identifier] := 481;
  fStringTable[$10000 - PResStringRec(@ComStrs.sInvalidIndex    ).Identifier] := 480;
  fStringTable[$10000 - PResStringRec(@ComStrs.sTabMustBeMultiLine).Identifier] := 479;
  fStringTable[$10000 - PResStringRec(@ComStrs.sTabFailSetObject).Identifier] := 478;
  fStringTable[$10000 - PResStringRec(@Constant.cAttributeName  ).Identifier] := 78;
  fStringTable[$10000 - PResStringRec(@Constant.cAttribute      ).Identifier] := 77;
  fStringTable[$10000 - PResStringRec(@Constant.cAppName        ).Identifier] := 76;
  fStringTable[$10000 - PResStringRec(@Constant.cAnonymousConn  ).Identifier] := 75;
  fStringTable[$10000 - PResStringRec(@Constant.cAddValue       ).Identifier] := 74;
  fStringTable[$10000 - PResStringRec(@Constant.cAddHost        ).Identifier] := 73;
  fStringTable[$10000 - PResStringRec(@Constant.cAddConn        ).Identifier] := 72;
  fStringTable[$10000 - PResStringRec(@Constant.cAddAttribute   ).Identifier] := 71;
  fStringTable[$10000 - PResStringRec(@Constant.cAddAddress     ).Identifier] := 2;
  fStringTable[$10000 - PResStringRec(@Constant.cAdd            ).Identifier] := 1;
  fStringTable[$10000 - PResStringRec(@Constant.XML_UNEXPECTED_CLOSE_TAG).Identifier] := 207;
  fStringTable[$10000 - PResStringRec(@Constant.XML_BAD_CLOSE_TAG).Identifier] := 206;
  fStringTable[$10000 - PResStringRec(@Constant.BAD_XML_DOCUMENT).Identifier] := 205;
  fStringTable[$10000 - PResStringRec(@Constant.LAC_NOTLAC      ).Identifier] := 204;
  fStringTable[$10000 - PResStringRec(@ComStrs.sFailsetCalSelRange).Identifier] := 472;
  fStringTable[$10000 - PResStringRec(@ComStrs.sFailSetCalMinMaxRange).Identifier] := 471;
  fStringTable[$10000 - PResStringRec(@Constant.cEditEntry      ).Identifier] := 62;
  fStringTable[$10000 - PResStringRec(@Constant.cEditAddress    ).Identifier] := 61;
  fStringTable[$10000 - PResStringRec(@Constant.cEdit           ).Identifier] := 60;
  fStringTable[$10000 - PResStringRec(@Constant.cDetails        ).Identifier] := 59;
  fStringTable[$10000 - PResStringRec(@Constant.cDescription    ).Identifier] := 58;
  fStringTable[$10000 - PResStringRec(@Constant.cDeleting       ).Identifier] := 57;
  fStringTable[$10000 - PResStringRec(@Constant.cDelete         ).Identifier] := 56;
  fStringTable[$10000 - PResStringRec(@Constant.cDecimal        ).Identifier] := 55;
  fStringTable[$10000 - PResStringRec(@Constant.cCopyTo         ).Identifier] := 86;
  fStringTable[$10000 - PResStringRec(@Constant.cCopying        ).Identifier] := 85;
  fStringTable[$10000 - PResStringRec(@Constant.cConfirm        ).Identifier] := 84;
  fStringTable[$10000 - PResStringRec(@Constant.cClose          ).Identifier] := 83;
  fStringTable[$10000 - PResStringRec(@Constant.cCert           ).Identifier] := 82;
  fStringTable[$10000 - PResStringRec(@Constant.cCancel         ).Identifier] := 81;
  fStringTable[$10000 - PResStringRec(@Constant.cBrowse         ).Identifier] := 80;
  fStringTable[$10000 - PResStringRec(@Constant.cBinary         ).Identifier] := 79;
  fStringTable[$10000 - PResStringRec(@Constant.cModifyOk       ).Identifier] := 46;
  fStringTable[$10000 - PResStringRec(@Constant.cMaildrop       ).Identifier] := 45;
  fStringTable[$10000 - PResStringRec(@Constant.cIpAddress      ).Identifier] := 44;
  fStringTable[$10000 - PResStringRec(@Constant.cInformation    ).Identifier] := 43;
  fStringTable[$10000 - PResStringRec(@Constant.cImage          ).Identifier] := 42;
  fStringTable[$10000 - PResStringRec(@Constant.cHostName       ).Identifier] := 41;
  fStringTable[$10000 - PResStringRec(@Constant.cHomeDir        ).Identifier] := 40;
  fStringTable[$10000 - PResStringRec(@Constant.cHex            ).Identifier] := 39;
  fStringTable[$10000 - PResStringRec(@Constant.cFinish         ).Identifier] := 70;
  fStringTable[$10000 - PResStringRec(@Constant.cError          ).Identifier] := 69;
  fStringTable[$10000 - PResStringRec(@Constant.cEnterRDN       ).Identifier] := 68;
  fStringTable[$10000 - PResStringRec(@Constant.cEnterPasswd    ).Identifier] := 67;
  fStringTable[$10000 - PResStringRec(@Constant.cEnterNewValue  ).Identifier] := 66;
  fStringTable[$10000 - PResStringRec(@Constant.cEnglish        ).Identifier] := 65;
  fStringTable[$10000 - PResStringRec(@Constant.cEditValue      ).Identifier] := 64;
  fStringTable[$10000 - PResStringRec(@Constant.cEditHost       ).Identifier] := 63;
  fStringTable[$10000 - PResStringRec(@Constant.cParentDir      ).Identifier] := 30;
  fStringTable[$10000 - PResStringRec(@Constant.cOperation      ).Identifier] := 29;
  fStringTable[$10000 - PResStringRec(@Constant.cOldValue       ).Identifier] := 28;
  fStringTable[$10000 - PResStringRec(@Constant.cOk             ).Identifier] := 27;
  fStringTable[$10000 - PResStringRec(@Constant.cObjectclass    ).Identifier] := 26;
  fStringTable[$10000 - PResStringRec(@Constant.cNext           ).Identifier] := 25;
  fStringTable[$10000 - PResStringRec(@Constant.cNewValue       ).Identifier] := 24;
  fStringTable[$10000 - PResStringRec(@Constant.cNewSubmenu     ).Identifier] := 23;
  fStringTable[$10000 - PResStringRec(@Constant.cNewItem        ).Identifier] := 54;
  fStringTable[$10000 - PResStringRec(@Constant.cNewEntry       ).Identifier] := 53;
  fStringTable[$10000 - PResStringRec(@Constant.cNew            ).Identifier] := 52;
  fStringTable[$10000 - PResStringRec(@Constant.cName           ).Identifier] := 51;
  fStringTable[$10000 - PResStringRec(@Constant.cMoving         ).Identifier] := 50;
  fStringTable[$10000 - PResStringRec(@Constant.cMoveTo         ).Identifier] := 49;
  fStringTable[$10000 - PResStringRec(@Constant.cMore           ).Identifier] := 48;
  fStringTable[$10000 - PResStringRec(@Constant.cModifySkipped  ).Identifier] := 47;
  fStringTable[$10000 - PResStringRec(@Constant.cSelectEntry    ).Identifier] := 14;
  fStringTable[$10000 - PResStringRec(@Constant.cSelectAliasDir ).Identifier] := 13;
  fStringTable[$10000 - PResStringRec(@Constant.cSearchResults  ).Identifier] := 12;
  fStringTable[$10000 - PResStringRec(@Constant.cSearchBase     ).Identifier] := 11;
  fStringTable[$10000 - PResStringRec(@Constant.cSaveToLdap     ).Identifier] := 10;
  fStringTable[$10000 - PResStringRec(@Constant.cSASLCurrUSer   ).Identifier] := 9;
  fStringTable[$10000 - PResStringRec(@Constant.cSambaDomain    ).Identifier] := 8;
  fStringTable[$10000 - PResStringRec(@Constant.cRetry          ).Identifier] := 7;
  fStringTable[$10000 - PResStringRec(@Constant.cRegistryCfgName).Identifier] := 38;
  fStringTable[$10000 - PResStringRec(@Constant.cPropertiesOf   ).Identifier] := 37;
  fStringTable[$10000 - PResStringRec(@Constant.cProgress       ).Identifier] := 36;
  fStringTable[$10000 - PResStringRec(@Constant.cPreparing      ).Identifier] := 35;
  fStringTable[$10000 - PResStringRec(@Constant.cPickGroups     ).Identifier] := 34;
  fStringTable[$10000 - PResStringRec(@Constant.cPickAccounts   ).Identifier] := 33;
  fStringTable[$10000 - PResStringRec(@Constant.cPath           ).Identifier] := 32;
  fStringTable[$10000 - PResStringRec(@Constant.cPassword       ).Identifier] := 31;
  fStringTable[$10000 - PResStringRec(@Constant.cWarning        ).Identifier] := 6;
  fStringTable[$10000 - PResStringRec(@Constant.cViewPic        ).Identifier] := 5;
  fStringTable[$10000 - PResStringRec(@Constant.cView           ).Identifier] := 4;
  fStringTable[$10000 - PResStringRec(@Constant.cValue          ).Identifier] := 3;
  fStringTable[$10000 - PResStringRec(@Constant.cUserPrompt     ).Identifier] := 203;
  fStringTable[$10000 - PResStringRec(@Constant.cUsername       ).Identifier] := 202;
  fStringTable[$10000 - PResStringRec(@Constant.cUser           ).Identifier] := 201;
  fStringTable[$10000 - PResStringRec(@Constant.cUnknown        ).Identifier] := 200;
  fStringTable[$10000 - PResStringRec(@Constant.cText           ).Identifier] := 22;
  fStringTable[$10000 - PResStringRec(@Constant.cSurname        ).Identifier] := 21;
  fStringTable[$10000 - PResStringRec(@Constant.cSmtpAddress    ).Identifier] := 20;
  fStringTable[$10000 - PResStringRec(@Constant.cSmartDelete    ).Identifier] := 19;
  fStringTable[$10000 - PResStringRec(@Constant.cSkipAll        ).Identifier] := 18;
  fStringTable[$10000 - PResStringRec(@Constant.cSkip           ).Identifier] := 17;
  fStringTable[$10000 - PResStringRec(@Constant.cSetPassword    ).Identifier] := 16;
  fStringTable[$10000 - PResStringRec(@Constant.cServer         ).Identifier] := 15;
  fStringTable[$10000 - PResStringRec(@Constant.stAccntNameReq  ).Identifier] := 191;
  fStringTable[$10000 - PResStringRec(@Constant.stAccntExist    ).Identifier] := 190;
  fStringTable[$10000 - PResStringRec(@Constant.stAbortScript   ).Identifier] := 189;
  fStringTable[$10000 - PResStringRec(@Constant.stConnectSuccess).Identifier] := 188;
  fStringTable[$10000 - PResStringRec(@Constant.mcAlias         ).Identifier] := 98;
  fStringTable[$10000 - PResStringRec(@Constant.mcGroupOfUN     ).Identifier] := 97;
  fStringTable[$10000 - PResStringRec(@Constant.mcLocality      ).Identifier] := 96;
  fStringTable[$10000 - PResStringRec(@Constant.mcHost          ).Identifier] := 95;
  fStringTable[$10000 - PResStringRec(@Constant.mcOu            ).Identifier] := 94;
  fStringTable[$10000 - PResStringRec(@Constant.mcTransportTable).Identifier] := 93;
  fStringTable[$10000 - PResStringRec(@Constant.mcMailingList   ).Identifier] := 92;
  fStringTable[$10000 - PResStringRec(@Constant.mcGroup         ).Identifier] := 91;
  fStringTable[$10000 - PResStringRec(@Constant.mcComputer      ).Identifier] := 90;
  fStringTable[$10000 - PResStringRec(@Constant.mcUser          ).Identifier] := 89;
  fStringTable[$10000 - PResStringRec(@Constant.mcEntry         ).Identifier] := 88;
  fStringTable[$10000 - PResStringRec(@Constant.mcNew           ).Identifier] := 87;
  fStringTable[$10000 - PResStringRec(@Constant.stDateFormat    ).Identifier] := 179;
  fStringTable[$10000 - PResStringRec(@Constant.stConfirmMultiDel).Identifier] := 178;
  fStringTable[$10000 - PResStringRec(@Constant.stConfirmDelAccnt).Identifier] := 177;
  fStringTable[$10000 - PResStringRec(@Constant.stConfirmDel    ).Identifier] := 176;
  fStringTable[$10000 - PResStringRec(@Constant.stCntSubentries ).Identifier] := 175;
  fStringTable[$10000 - PResStringRec(@Constant.stCntObjects    ).Identifier] := 174;
  fStringTable[$10000 - PResStringRec(@Constant.stClassNotFound ).Identifier] := 173;
  fStringTable[$10000 - PResStringRec(@Constant.stCertSelfSigned).Identifier] := 172;
  fStringTable[$10000 - PResStringRec(@Constant.stCertNotFound  ).Identifier] := 199;
  fStringTable[$10000 - PResStringRec(@Constant.stCertInvalidTime).Identifier] := 198;
  fStringTable[$10000 - PResStringRec(@Constant.stCertInvalidSig).Identifier] := 197;
  fStringTable[$10000 - PResStringRec(@Constant.stCertInvalidName).Identifier] := 196;
  fStringTable[$10000 - PResStringRec(@Constant.stCertConfirmConn).Identifier] := 195;
  fStringTable[$10000 - PResStringRec(@Constant.stCantStorPass  ).Identifier] := 194;
  fStringTable[$10000 - PResStringRec(@Constant.stAskTreeMove   ).Identifier] := 193;
  fStringTable[$10000 - PResStringRec(@Constant.stAskTreeCopy   ).Identifier] := 192;
  fStringTable[$10000 - PResStringRec(@Constant.stInteger       ).Identifier] := 163;
  fStringTable[$10000 - PResStringRec(@Constant.stIdentIsnotValid).Identifier] := 162;
  fStringTable[$10000 - PResStringRec(@Constant.stGroupNameReq  ).Identifier] := 161;
  fStringTable[$10000 - PResStringRec(@Constant.stGroupMailReq  ).Identifier] := 160;
  fStringTable[$10000 - PResStringRec(@Constant.stGidNotSamba   ).Identifier] := 159;
  fStringTable[$10000 - PResStringRec(@Constant.stGetProcAddrErr).Identifier] := 158;
  fStringTable[$10000 - PResStringRec(@Constant.stFileOverwrite ).Identifier] := 157;
  fStringTable[$10000 - PResStringRec(@Constant.stExtConfirmAssoc).Identifier] := 156;
  fStringTable[$10000 - PResStringRec(@Constant.stEvTypeEvTypeErr).Identifier] := 187;
  fStringTable[$10000 - PResStringRec(@Constant.stErrExtMethName).Identifier] := 186;
  fStringTable[$10000 - PResStringRec(@Constant.stEmptyArg      ).Identifier] := 185;
  fStringTable[$10000 - PResStringRec(@Constant.stDuplicateSC   ).Identifier] := 184;
  fStringTable[$10000 - PResStringRec(@Constant.stDelNamingAttr ).Identifier] := 183;
  fStringTable[$10000 - PResStringRec(@Constant.stDeleteSubmenu ).Identifier] := 182;
  fStringTable[$10000 - PResStringRec(@Constant.stDeleteMenuItem).Identifier] := 181;
  fStringTable[$10000 - PResStringRec(@Constant.stDeleteAll     ).Identifier] := 180;
  fStringTable[$10000 - PResStringRec(@Constant.stLdifInvalidUrl).Identifier] := 147;
  fStringTable[$10000 - PResStringRec(@Constant.stLdifFailure   ).Identifier] := 146;
  fStringTable[$10000 - PResStringRec(@Constant.stLdifEVer      ).Identifier] := 145;
  fStringTable[$10000 - PResStringRec(@Constant.stLdifEof       ).Identifier] := 144;
  fStringTable[$10000 - PResStringRec(@Constant.stLdifENoDn     ).Identifier] := 143;
  fStringTable[$10000 - PResStringRec(@Constant.stLdifENoCol    ).Identifier] := 142;
  fStringTable[$10000 - PResStringRec(@Constant.stLdifEInvMode  ).Identifier] := 141;
  fStringTable[$10000 - PResStringRec(@Constant.stLdifEFold     ).Identifier] := 140;
  fStringTable[$10000 - PResStringRec(@Constant.stLdapErrorEx   ).Identifier] := 171;
  fStringTable[$10000 - PResStringRec(@Constant.stLdapError     ).Identifier] := 170;
  fStringTable[$10000 - PResStringRec(@Constant.stInvalidURL    ).Identifier] := 169;
  fStringTable[$10000 - PResStringRec(@Constant.stInvalidTimeFmt).Identifier] := 168;
  fStringTable[$10000 - PResStringRec(@Constant.stInvalidTagValue).Identifier] := 167;
  fStringTable[$10000 - PResStringRec(@Constant.stInvalidFilter ).Identifier] := 166;
  fStringTable[$10000 - PResStringRec(@Constant.stInvalidCmdVer ).Identifier] := 165;
  fStringTable[$10000 - PResStringRec(@Constant.stInvalidArgIndex).Identifier] := 164;
  fStringTable[$10000 - PResStringRec(@Constant.stNoSchema      ).Identifier] := 131;
  fStringTable[$10000 - PResStringRec(@Constant.stNoRdn         ).Identifier] := 130;
  fStringTable[$10000 - PResStringRec(@Constant.stNoPosixID     ).Identifier] := 129;
  fStringTable[$10000 - PResStringRec(@Constant.stNoMoreNums    ).Identifier] := 128;
  fStringTable[$10000 - PResStringRec(@Constant.stNoMoreChecks  ).Identifier] := 127;
  fStringTable[$10000 - PResStringRec(@Constant.stNoActiveConn  ).Identifier] := 126;
  fStringTable[$10000 - PResStringRec(@Constant.stNeedElevated  ).Identifier] := 125;
  fStringTable[$10000 - PResStringRec(@Constant.stMoveOverlap   ).Identifier] := 124;
  fStringTable[$10000 - PResStringRec(@Constant.stMenuLocateTempl).Identifier] := 155;
  fStringTable[$10000 - PResStringRec(@Constant.stMenuAssignTempl).Identifier] := 154;
  fStringTable[$10000 - PResStringRec(@Constant.stLdifUrlNotSupp).Identifier] := 153;
  fStringTable[$10000 - PResStringRec(@Constant.stLdifSuccess   ).Identifier] := 152;
  fStringTable[$10000 - PResStringRec(@Constant.stLdifNotExpected).Identifier] := 151;
  fStringTable[$10000 - PResStringRec(@Constant.stLdifInvOp     ).Identifier] := 150;
  fStringTable[$10000 - PResStringRec(@Constant.stLdifInvChType ).Identifier] := 149;
  fStringTable[$10000 - PResStringRec(@Constant.stLdifInvAttrName).Identifier] := 148;
  fStringTable[$10000 - PResStringRec(@Constant.stScriptNotEvent).Identifier] := 115;
  fStringTable[$10000 - PResStringRec(@Constant.stScriptNoProc  ).Identifier] := 114;
  fStringTable[$10000 - PResStringRec(@Constant.stSchemaNoSubentry).Identifier] := 113;
  fStringTable[$10000 - PResStringRec(@Constant.stSaslSSL       ).Identifier] := 112;
  fStringTable[$10000 - PResStringRec(@Constant.stRetrieving    ).Identifier] := 111;
  fStringTable[$10000 - PResStringRec(@Constant.stResetAutolock ).Identifier] := 110;
  fStringTable[$10000 - PResStringRec(@Constant.stRequired      ).Identifier] := 109;
  fStringTable[$10000 - PResStringRec(@Constant.stReqNoEmpty    ).Identifier] := 108;
  fStringTable[$10000 - PResStringRec(@Constant.stReqMail       ).Identifier] := 139;
  fStringTable[$10000 - PResStringRec(@Constant.stRegexFailed   ).Identifier] := 138;
  fStringTable[$10000 - PResStringRec(@Constant.stPropReadOnly  ).Identifier] := 137;
  fStringTable[$10000 - PResStringRec(@Constant.stPassFor       ).Identifier] := 136;
  fStringTable[$10000 - PResStringRec(@Constant.stPassDiff      ).Identifier] := 135;
  fStringTable[$10000 - PResStringRec(@Constant.stNumObjects    ).Identifier] := 134;
  fStringTable[$10000 - PResStringRec(@Constant.stNumber        ).Identifier] := 133;
  fStringTable[$10000 - PResStringRec(@Constant.stNotEnoughArgs ).Identifier] := 132;
  fStringTable[$10000 - PResStringRec(@Constant.SAVE_SEARCH_FILTER).Identifier] := 106;
  fStringTable[$10000 - PResStringRec(@Constant.stWritePropRO   ).Identifier] := 105;
  fStringTable[$10000 - PResStringRec(@Constant.stUserBreak     ).Identifier] := 104;
  fStringTable[$10000 - PResStringRec(@Constant.stUnsuppScript  ).Identifier] := 103;
  fStringTable[$10000 - PResStringRec(@Constant.stUnsupportedAuth).Identifier] := 102;
  fStringTable[$10000 - PResStringRec(@Constant.stUnknownValueType).Identifier] := 101;
  fStringTable[$10000 - PResStringRec(@Constant.stUnclosedStr   ).Identifier] := 100;
  fStringTable[$10000 - PResStringRec(@Constant.stUnclosedParam ).Identifier] := 99;
  fStringTable[$10000 - PResStringRec(@Constant.stTooManyArgs   ).Identifier] := 123;
  fStringTable[$10000 - PResStringRec(@Constant.stTimeFormat    ).Identifier] := 122;
  fStringTable[$10000 - PResStringRec(@Constant.stStopTLSError  ).Identifier] := 121;
  fStringTable[$10000 - PResStringRec(@Constant.stSkipRecord    ).Identifier] := 120;
  fStringTable[$10000 - PResStringRec(@Constant.stSequentialID  ).Identifier] := 119;
  fStringTable[$10000 - PResStringRec(@Constant.stScriptSetErr  ).Identifier] := 118;
  fStringTable[$10000 - PResStringRec(@Constant.stScriptParamType).Identifier] := 117;
  fStringTable[$10000 - PResStringRec(@Constant.stScriptNotSupp ).Identifier] := 116;
  fStringTable[$10000 - PResStringRec(@OleConst.SNotLicensed    ).Identifier] := 498;
  fStringTable[$10000 - PResStringRec(@OleConst.SInvalidLicense ).Identifier] := 497;
  fStringTable[$10000 - PResStringRec(@OleConst.SNoWindowHandle ).Identifier] := 496;
  fStringTable[$10000 - PResStringRec(@OleConst.SCannotActivate ).Identifier] := 495;
  fStringTable[$10000 - PResStringRec(@ComConst.SVarNotObject   ).Identifier] := 489;
  fStringTable[$10000 - PResStringRec(@ComConst.SNoMethod       ).Identifier] := 488;
  fStringTable[$10000 - PResStringRec(@ComConst.SOleError       ).Identifier] := 487;
  fStringTable[$10000 - PResStringRec(@Constant.SAVE_MODIFY_LOG_FILTER).Identifier] := 107;
  fStringTable[$10000 - PResStringRec(@OleConst.sNoRunningObject).Identifier] := 499;
  {SysConst_SAccessViolation
SysConst_SWin32Error
SysConst_SVarNotArray
SysConst_SUnkWin32Error}
  fStringTable[$10000 - PResStringRec(@Consts.SClassNotFound).Identifier] := 357;
  fStringTable[$10000 - PResStringRec(@Consts.SCantWriteResourceStreamError).Identifier] := 355;
  fStringTable[$10000 - PResStringRec(@Consts.SMemoryStreamError).Identifier] := 349;
  fStringTable[$10000 - PResStringRec(@Consts.SWriteError).Identifier] := 330;
  fStringTable[$10000 - PResStringRec(@Consts.SReadError).Identifier] := 351;
  fStringTable[$10000 - PResStringRec(@Consts.SFOpenError).Identifier] := 365;
  fStringTable[$10000 - PResStringRec(@Consts.SFCreateError).Identifier] := 362;
  fStringTable[$10000 - PResStringRec(@Consts.SAssignError).Identifier] := 353;
  fStringTable[$10000 - PResStringRec(@Consts.SInvalidPropertyElement).Identifier] := 340;
  fStringTable[$10000 - PResStringRec(@Consts.SInvalidPropertyPath).Identifier] := 341;
  fStringTable[$10000 - PResStringRec(@Consts.SInvalidPropertyType).Identifier] := 342;
  fStringTable[$10000 - PResStringRec(@Consts.SInvalidPropertyValue).Identifier] := 343;
  fStringTable[$10000 - PResStringRec(@Consts.SDuplicateClass).Identifier] := 358;
  fStringTable[$10000 - PResStringRec(@Consts.SDuplicateName).Identifier] := 360;
  fStringTable[$10000 - PResStringRec(@Consts.SDuplicateString).Identifier] := 361;
  fStringTable[$10000 - PResStringRec(@Consts.SInvalidName).Identifier] := 338;
  fStringTable[$10000 - PResStringRec(@Consts.SSortedListError).Identifier] := 326;
  fStringTable[$10000 - PResStringRec(@Consts.SListCountError).Identifier] := 347;
  fStringTable[$10000 - PResStringRec(@Consts.SListCapacityError).Identifier] := 346;
  fStringTable[$10000 - PResStringRec(@Consts.SListIndexError).Identifier] := 348;
  fStringTable[$10000 - PResStringRec(@Consts.SResNotFound).Identifier] := 324;
  fStringTable[$10000 - PResStringRec(@Consts.SAncestorNotFound).Identifier] := 352;
  fStringTable[$10000 - PResStringRec(@Consts.SPropertyException).Identifier] := 350;
  fStringTable[$10000 - PResStringRec(@Consts.SReadOnlyProperty).Identifier] := 320;
  fStringTable[$10000 - PResStringRec(@Consts.SUnknownProperty).Identifier] := 329;
  fStringTable[$10000 - PResStringRec(@Consts.SInvalidProperty).Identifier] := 339;
  fStringTable[$10000 - PResStringRec(@Consts.SInvalidStringGridOp).Identifier] := 345;
  fStringTable[$10000 - PResStringRec(@Consts.SFixedRowTooBig).Identifier] := 364;
  fStringTable[$10000 - PResStringRec(@Consts.SFixedColTooBig).Identifier] := 363;
  fStringTable[$10000 - PResStringRec(@Consts.SIndexOutOfRange).Identifier] := 336;
  fStringTable[$10000 - PResStringRec(@Consts.STooManyDeleted).Identifier] := 327;
  fStringTable[$10000 - PResStringRec(@Consts.SGridTooLarge).Identifier] := 366;
  fStringTable[$10000 - PResStringRec(@Consts.SRegCreateFailed).Identifier] := 321;
  fStringTable[$10000 - PResStringRec(@Consts.SRegGetDataFailed).Identifier] := 322;
  fStringTable[$10000 - PResStringRec(@Consts.SRegSetDataFailed).Identifier] := 323;
  fStringTable[$10000 - PResStringRec(@Consts.SInvalidRegType).Identifier] := 344;
  fStringTable[$10000 - PResStringRec(@Consts.SBitsIndexError).Identifier] := 354;
  fStringTable[$10000 - PResStringRec(@Consts.SDuplicateItem).Identifier] := 359;
  fStringTable[$10000 - PResStringRec(@OleConst.SNoMethod).Identifier] := 488;
  fStringTable[$10000 - PResStringRec(@OleConst.SVarNotObject).Identifier] := 489;
  fStringTable[$10000 - PResStringRec(@OleConst.SOleError).Identifier] := 487;
  fStringTable[$10000 - PResStringRec(@JConsts.sJPEGImageFile).Identifier] := 492;
  fStringTable[$10000 - PResStringRec(@JConsts.sChangeJPGSize).Identifier] := 493;
  fStringTable[$10000 - PResStringRec(@JConsts.sJPEGError).Identifier] := 494;
  fStringTable[$10000 - PResStringRec(@Constant.cPickMembers).Identifier] := 503;
  {$ENDIF}
  {$IFDEF VER150}
  fStringTable[$10000 - PResStringRec(@Constant.cAdd).Identifier] := 1;
  fStringTable[$10000 - PResStringRec(@Constant.cAddAddress).Identifier] := 2;
  fStringTable[$10000 - PResStringRec(@Constant.cValue).Identifier] := 3;
  fStringTable[$10000 - PResStringRec(@Constant.cView).Identifier] := 4;
  fStringTable[$10000 - PResStringRec(@Constant.cViewPic).Identifier] := 5;
  fStringTable[$10000 - PResStringRec(@Constant.cWarning).Identifier] := 6;
  fStringTable[$10000 - PResStringRec(@Constant.cRetry).Identifier] := 7;
  fStringTable[$10000 - PResStringRec(@Constant.cSambaDomain).Identifier] := 8;
  fStringTable[$10000 - PResStringRec(@Constant.cSASLCurrUSer).Identifier] := 9;
  fStringTable[$10000 - PResStringRec(@Constant.cSaveToLdap).Identifier] := 10;
  fStringTable[$10000 - PResStringRec(@Constant.cSearchBase).Identifier] := 11;
  fStringTable[$10000 - PResStringRec(@Constant.cSearchResults).Identifier] := 12;
  fStringTable[$10000 - PResStringRec(@Constant.cSelectAliasDir).Identifier] := 13;
  fStringTable[$10000 - PResStringRec(@Constant.cSelectEntry).Identifier] := 14;
  fStringTable[$10000 - PResStringRec(@Constant.cServer).Identifier] := 15;
  fStringTable[$10000 - PResStringRec(@Constant.cSetPassword).Identifier] := 16;
  fStringTable[$10000 - PResStringRec(@Constant.cSkip).Identifier] := 17;
  fStringTable[$10000 - PResStringRec(@Constant.cSkipAll).Identifier] := 18;
  fStringTable[$10000 - PResStringRec(@Constant.cSmartDelete).Identifier] := 19;
  fStringTable[$10000 - PResStringRec(@Constant.cSmtpAddress).Identifier] := 20;
  fStringTable[$10000 - PResStringRec(@Constant.cSurname).Identifier] := 21;
  fStringTable[$10000 - PResStringRec(@Constant.cText).Identifier] := 22;
  fStringTable[$10000 - PResStringRec(@Constant.cNewSubmenu).Identifier] := 23;
  fStringTable[$10000 - PResStringRec(@Constant.cNewValue).Identifier] := 24;
  fStringTable[$10000 - PResStringRec(@Constant.cNext).Identifier] := 25;
  fStringTable[$10000 - PResStringRec(@Constant.cObjectclass).Identifier] := 26;
  fStringTable[$10000 - PResStringRec(@Constant.cOk).Identifier] := 27;
  fStringTable[$10000 - PResStringRec(@Constant.cOldValue).Identifier] := 28;
  fStringTable[$10000 - PResStringRec(@Constant.cOperation).Identifier] := 29;
  fStringTable[$10000 - PResStringRec(@Constant.cParentDir).Identifier] := 30;
  fStringTable[$10000 - PResStringRec(@Constant.cPassword).Identifier] := 31;
  fStringTable[$10000 - PResStringRec(@Constant.cPath).Identifier] := 32;
  fStringTable[$10000 - PResStringRec(@Constant.cPickAccounts).Identifier] := 33;
  fStringTable[$10000 - PResStringRec(@Constant.cPickGroups).Identifier] := 34;
  fStringTable[$10000 - PResStringRec(@Constant.cPreparing).Identifier] := 35;
  fStringTable[$10000 - PResStringRec(@Constant.cProgress).Identifier] := 36;
  fStringTable[$10000 - PResStringRec(@Constant.cPropertiesOf).Identifier] := 37;
  fStringTable[$10000 - PResStringRec(@Constant.cRegistryCfgName).Identifier] := 38;
  fStringTable[$10000 - PResStringRec(@Constant.cHex).Identifier] := 39;
  fStringTable[$10000 - PResStringRec(@Constant.cHomeDir).Identifier] := 40;
  fStringTable[$10000 - PResStringRec(@Constant.cHostName).Identifier] := 41;
  fStringTable[$10000 - PResStringRec(@Constant.cImage).Identifier] := 42;
  fStringTable[$10000 - PResStringRec(@Constant.cInformation).Identifier] := 43;
  fStringTable[$10000 - PResStringRec(@Constant.cIpAddress).Identifier] := 44;
  fStringTable[$10000 - PResStringRec(@Constant.cMaildrop).Identifier] := 45;
  fStringTable[$10000 - PResStringRec(@Constant.cModifyOk).Identifier] := 46;
  fStringTable[$10000 - PResStringRec(@Constant.cModifySkipped).Identifier] := 47;
  fStringTable[$10000 - PResStringRec(@Constant.cMore).Identifier] := 48;
  fStringTable[$10000 - PResStringRec(@Constant.cMoveTo).Identifier] := 49;
  fStringTable[$10000 - PResStringRec(@Constant.cMoving).Identifier] := 50;
  fStringTable[$10000 - PResStringRec(@Constant.cName).Identifier] := 51;
  fStringTable[$10000 - PResStringRec(@Constant.cNew).Identifier] := 52;
  fStringTable[$10000 - PResStringRec(@Constant.cNewEntry).Identifier] := 53;
  fStringTable[$10000 - PResStringRec(@Constant.cNewItem).Identifier] := 54;
  fStringTable[$10000 - PResStringRec(@Constant.cDecimal).Identifier] := 55;
  fStringTable[$10000 - PResStringRec(@Constant.cDelete).Identifier] := 56;
  fStringTable[$10000 - PResStringRec(@Constant.cDeleting).Identifier] := 57;
  fStringTable[$10000 - PResStringRec(@Constant.cDescription).Identifier] := 58;
  fStringTable[$10000 - PResStringRec(@Constant.cDetails).Identifier] := 59;
  fStringTable[$10000 - PResStringRec(@Constant.cEdit).Identifier] := 60;
  fStringTable[$10000 - PResStringRec(@Constant.cEditAddress).Identifier] := 61;
  fStringTable[$10000 - PResStringRec(@Constant.cEditEntry).Identifier] := 62;
  fStringTable[$10000 - PResStringRec(@Constant.cEditHost).Identifier] := 63;
  fStringTable[$10000 - PResStringRec(@Constant.cEditValue).Identifier] := 64;
  fStringTable[$10000 - PResStringRec(@Constant.cEnglish).Identifier] := 65;
  fStringTable[$10000 - PResStringRec(@Constant.cEnterNewValue).Identifier] := 66;
  fStringTable[$10000 - PResStringRec(@Constant.cEnterPasswd).Identifier] := 67;
  fStringTable[$10000 - PResStringRec(@Constant.cEnterRDN).Identifier] := 68;
  fStringTable[$10000 - PResStringRec(@Constant.cError).Identifier] := 69;
  fStringTable[$10000 - PResStringRec(@Constant.cFinish).Identifier] := 70;
  fStringTable[$10000 - PResStringRec(@Constant.cAddAttribute).Identifier] := 71;
  fStringTable[$10000 - PResStringRec(@Constant.cAddConn).Identifier] := 72;
  fStringTable[$10000 - PResStringRec(@Constant.cAddHost).Identifier] := 73;
  fStringTable[$10000 - PResStringRec(@Constant.cAddValue).Identifier] := 74;
  fStringTable[$10000 - PResStringRec(@Constant.cAnonymousConn).Identifier] := 75;
  fStringTable[$10000 - PResStringRec(@Constant.cAppName).Identifier] := 76;
  fStringTable[$10000 - PResStringRec(@Constant.cAttribute).Identifier] := 77;
  fStringTable[$10000 - PResStringRec(@Constant.cAttributeName).Identifier] := 78;
  fStringTable[$10000 - PResStringRec(@Constant.cBinary).Identifier] := 79;
  fStringTable[$10000 - PResStringRec(@Constant.cBrowse).Identifier] := 80;
  fStringTable[$10000 - PResStringRec(@Constant.cCancel).Identifier] := 81;
  fStringTable[$10000 - PResStringRec(@Constant.cCert).Identifier] := 82;
  fStringTable[$10000 - PResStringRec(@Constant.cClose).Identifier] := 83;
  fStringTable[$10000 - PResStringRec(@Constant.cConfirm).Identifier] := 84;
  fStringTable[$10000 - PResStringRec(@Constant.cCopying).Identifier] := 85;
  fStringTable[$10000 - PResStringRec(@Constant.cCopyTo).Identifier] := 86;
  fStringTable[$10000 - PResStringRec(@Constant.mcNew).Identifier] := 87;
  fStringTable[$10000 - PResStringRec(@Constant.mcEntry).Identifier] := 88;
  fStringTable[$10000 - PResStringRec(@Constant.mcUser).Identifier] := 89;
  fStringTable[$10000 - PResStringRec(@Constant.mcComputer).Identifier] := 90;
  fStringTable[$10000 - PResStringRec(@Constant.mcGroup).Identifier] := 91;
  fStringTable[$10000 - PResStringRec(@Constant.mcMailingList).Identifier] := 92;
  fStringTable[$10000 - PResStringRec(@Constant.mcTransportTable).Identifier] := 93;
  fStringTable[$10000 - PResStringRec(@Constant.mcOu).Identifier] := 94;
  fStringTable[$10000 - PResStringRec(@Constant.mcHost).Identifier] := 95;
  fStringTable[$10000 - PResStringRec(@Constant.mcLocality).Identifier] := 96;
  fStringTable[$10000 - PResStringRec(@Constant.mcGroupOfUN).Identifier] := 97;
  fStringTable[$10000 - PResStringRec(@Constant.mcAlias).Identifier] := 98;
  fStringTable[$10000 - PResStringRec(@Constant.stUnclosedParam).Identifier] := 99;
  fStringTable[$10000 - PResStringRec(@Constant.stUnclosedStr).Identifier] := 100;
  fStringTable[$10000 - PResStringRec(@Constant.stUnknownValueType).Identifier] := 101;
  fStringTable[$10000 - PResStringRec(@Constant.stUnsupportedAuth).Identifier] := 102;
  fStringTable[$10000 - PResStringRec(@Constant.stUnsuppScript).Identifier] := 103;
  fStringTable[$10000 - PResStringRec(@Constant.stUserBreak).Identifier] := 104;
  fStringTable[$10000 - PResStringRec(@Constant.stWritePropRO).Identifier] := 105;
  fStringTable[$10000 - PResStringRec(@Constant.SAVE_SEARCH_FILTER).Identifier] := 106;
  fStringTable[$10000 - PResStringRec(@Constant.SAVE_MODIFY_LOG_FILTER).Identifier] := 107;
  fStringTable[$10000 - PResStringRec(@Constant.stReqNoEmpty).Identifier] := 108;
  fStringTable[$10000 - PResStringRec(@Constant.stRequired).Identifier] := 109;
  fStringTable[$10000 - PResStringRec(@Constant.stResetAutolock).Identifier] := 110;
  fStringTable[$10000 - PResStringRec(@Constant.stRetrieving).Identifier] := 111;
  fStringTable[$10000 - PResStringRec(@Constant.stSaslSSL).Identifier] := 112;
  fStringTable[$10000 - PResStringRec(@Constant.stSchemaNoSubentry).Identifier] := 113;
  fStringTable[$10000 - PResStringRec(@Constant.stScriptNoProc).Identifier] := 114;
  fStringTable[$10000 - PResStringRec(@Constant.stScriptNotEvent).Identifier] := 115;
  fStringTable[$10000 - PResStringRec(@Constant.stScriptNotSupp).Identifier] := 116;
  fStringTable[$10000 - PResStringRec(@Constant.stScriptParamType).Identifier] := 117;
  fStringTable[$10000 - PResStringRec(@Constant.stScriptSetErr).Identifier] := 118;
  fStringTable[$10000 - PResStringRec(@Constant.stSequentialID).Identifier] := 119;
  fStringTable[$10000 - PResStringRec(@Constant.stSkipRecord).Identifier] := 120;
  fStringTable[$10000 - PResStringRec(@Constant.stStopTLSError).Identifier] := 121;
  fStringTable[$10000 - PResStringRec(@Constant.stTimeFormat).Identifier] := 122;
  fStringTable[$10000 - PResStringRec(@Constant.stTooManyArgs).Identifier] := 123;
  fStringTable[$10000 - PResStringRec(@Constant.stMoveOverlap).Identifier] := 124;
  fStringTable[$10000 - PResStringRec(@Constant.stNeedElevated).Identifier] := 125;
  fStringTable[$10000 - PResStringRec(@Constant.stNoActiveConn).Identifier] := 126;
  fStringTable[$10000 - PResStringRec(@Constant.stNoMoreChecks).Identifier] := 127;
  fStringTable[$10000 - PResStringRec(@Constant.stNoMoreNums).Identifier] := 128;
  fStringTable[$10000 - PResStringRec(@Constant.stNoPosixID).Identifier] := 129;
  fStringTable[$10000 - PResStringRec(@Constant.stNoRdn).Identifier] := 130;
  fStringTable[$10000 - PResStringRec(@Constant.stNoSchema).Identifier] := 131;
  fStringTable[$10000 - PResStringRec(@Constant.stNotEnoughArgs).Identifier] := 132;
  fStringTable[$10000 - PResStringRec(@Constant.stNumber).Identifier] := 133;
  fStringTable[$10000 - PResStringRec(@Constant.stNumObjects).Identifier] := 134;
  fStringTable[$10000 - PResStringRec(@Constant.stPassDiff).Identifier] := 135;
  fStringTable[$10000 - PResStringRec(@Constant.stPassFor).Identifier] := 136;
  fStringTable[$10000 - PResStringRec(@Constant.stPropReadOnly).Identifier] := 137;
  fStringTable[$10000 - PResStringRec(@Constant.stRegexFailed).Identifier] := 138;
  fStringTable[$10000 - PResStringRec(@Constant.stReqMail).Identifier] := 139;
  fStringTable[$10000 - PResStringRec(@Constant.stLdifEFold).Identifier] := 140;
  fStringTable[$10000 - PResStringRec(@Constant.stLdifEInvMode).Identifier] := 141;
  fStringTable[$10000 - PResStringRec(@Constant.stLdifENoCol).Identifier] := 142;
  fStringTable[$10000 - PResStringRec(@Constant.stLdifENoDn).Identifier] := 143;
  fStringTable[$10000 - PResStringRec(@Constant.stLdifEof).Identifier] := 144;
  fStringTable[$10000 - PResStringRec(@Constant.stLdifEVer).Identifier] := 145;
  fStringTable[$10000 - PResStringRec(@Constant.stLdifFailure).Identifier] := 146;
  fStringTable[$10000 - PResStringRec(@Constant.stLdifInvalidUrl).Identifier] := 147;
  fStringTable[$10000 - PResStringRec(@Constant.stLdifInvAttrName).Identifier] := 148;
  fStringTable[$10000 - PResStringRec(@Constant.stLdifInvChType).Identifier] := 149;
  fStringTable[$10000 - PResStringRec(@Constant.stLdifInvOp).Identifier] := 150;
  fStringTable[$10000 - PResStringRec(@Constant.stLdifNotExpected).Identifier] := 151;
  fStringTable[$10000 - PResStringRec(@Constant.stLdifSuccess).Identifier] := 152;
  fStringTable[$10000 - PResStringRec(@Constant.stLdifUrlNotSupp).Identifier] := 153;
  fStringTable[$10000 - PResStringRec(@Constant.stMenuAssignTempl).Identifier] := 154;
  fStringTable[$10000 - PResStringRec(@Constant.stMenuLocateTempl).Identifier] := 155;
  fStringTable[$10000 - PResStringRec(@Constant.stExtConfirmAssoc).Identifier] := 156;
  fStringTable[$10000 - PResStringRec(@Constant.stFileOverwrite).Identifier] := 157;
  fStringTable[$10000 - PResStringRec(@Constant.stGetProcAddrErr).Identifier] := 158;
  fStringTable[$10000 - PResStringRec(@Constant.stGidNotSamba).Identifier] := 159;
  fStringTable[$10000 - PResStringRec(@Constant.stGroupMailReq).Identifier] := 160;
  fStringTable[$10000 - PResStringRec(@Constant.stGroupNameReq).Identifier] := 161;
  fStringTable[$10000 - PResStringRec(@Constant.stIdentIsnotValid).Identifier] := 162;
  fStringTable[$10000 - PResStringRec(@Constant.stInteger).Identifier] := 163;
  fStringTable[$10000 - PResStringRec(@Constant.stInvalidArgIndex).Identifier] := 164;
  fStringTable[$10000 - PResStringRec(@Constant.stInvalidCmdVer).Identifier] := 165;
  fStringTable[$10000 - PResStringRec(@Constant.stInvalidFilter).Identifier] := 166;
  fStringTable[$10000 - PResStringRec(@Constant.stInvalidTagValue).Identifier] := 167;
  fStringTable[$10000 - PResStringRec(@Constant.stInvalidTimeFmt).Identifier] := 168;
  fStringTable[$10000 - PResStringRec(@Constant.stInvalidURL).Identifier] := 169;
  fStringTable[$10000 - PResStringRec(@Constant.stLdapError).Identifier] := 170;
  fStringTable[$10000 - PResStringRec(@Constant.stLdapErrorEx).Identifier] := 171;
  fStringTable[$10000 - PResStringRec(@Constant.stCertSelfSigned).Identifier] := 172;
  fStringTable[$10000 - PResStringRec(@Constant.stClassNotFound).Identifier] := 173;
  fStringTable[$10000 - PResStringRec(@Constant.stCntObjects).Identifier] := 174;
  fStringTable[$10000 - PResStringRec(@Constant.stCntSubentries).Identifier] := 175;
  fStringTable[$10000 - PResStringRec(@Constant.stConfirmDel).Identifier] := 176;
  fStringTable[$10000 - PResStringRec(@Constant.stConfirmDelAccnt).Identifier] := 177;
  fStringTable[$10000 - PResStringRec(@Constant.stConfirmMultiDel).Identifier] := 178;
  fStringTable[$10000 - PResStringRec(@Constant.stDateFormat).Identifier] := 179;
  fStringTable[$10000 - PResStringRec(@Constant.stDeleteAll).Identifier] := 180;
  fStringTable[$10000 - PResStringRec(@Constant.stDeleteMenuItem).Identifier] := 181;
  fStringTable[$10000 - PResStringRec(@Constant.stDeleteSubmenu).Identifier] := 182;
  fStringTable[$10000 - PResStringRec(@Constant.stDelNamingAttr).Identifier] := 183;
  fStringTable[$10000 - PResStringRec(@Constant.stDuplicateSC).Identifier] := 184;
  fStringTable[$10000 - PResStringRec(@Constant.stEmptyArg).Identifier] := 185;
  fStringTable[$10000 - PResStringRec(@Constant.stErrExtMethName).Identifier] := 186;
  fStringTable[$10000 - PResStringRec(@Constant.stEvTypeEvTypeErr).Identifier] := 187;
  fStringTable[$10000 - PResStringRec(@Constant.stConnectSuccess).Identifier] := 188;
  fStringTable[$10000 - PResStringRec(@Constant.stAbortScript).Identifier] := 189;
  fStringTable[$10000 - PResStringRec(@Constant.stAccntExist).Identifier] := 190;
  fStringTable[$10000 - PResStringRec(@Constant.stAccntNameReq).Identifier] := 191;
  fStringTable[$10000 - PResStringRec(@Constant.stAskTreeCopy).Identifier] := 192;
  fStringTable[$10000 - PResStringRec(@Constant.stAskTreeMove).Identifier] := 193;
  fStringTable[$10000 - PResStringRec(@Constant.stCantStorPass).Identifier] := 194;
  fStringTable[$10000 - PResStringRec(@Constant.stCertConfirmConn).Identifier] := 195;
  fStringTable[$10000 - PResStringRec(@Constant.stCertInvalidName).Identifier] := 196;
  fStringTable[$10000 - PResStringRec(@Constant.stCertInvalidSig).Identifier] := 197;
  fStringTable[$10000 - PResStringRec(@Constant.stCertInvalidTime).Identifier] := 198;
  fStringTable[$10000 - PResStringRec(@Constant.stCertNotFound).Identifier] := 199;
  fStringTable[$10000 - PResStringRec(@Constant.cUnknown).Identifier] := 200;
  fStringTable[$10000 - PResStringRec(@Constant.cUser).Identifier] := 201;
  fStringTable[$10000 - PResStringRec(@Constant.cUsername).Identifier] := 202;
  fStringTable[$10000 - PResStringRec(@Constant.cUserPrompt).Identifier] := 203;
  fStringTable[$10000 - PResStringRec(@Constant.LAC_NOTLAC).Identifier] := 204;
  fStringTable[$10000 - PResStringRec(@Constant.BAD_XML_DOCUMENT).Identifier] := 205;
  fStringTable[$10000 - PResStringRec(@Constant.XML_BAD_CLOSE_TAG).Identifier] := 206;
  fStringTable[$10000 - PResStringRec(@Constant.XML_UNEXPECTED_CLOSE_TAG).Identifier] := 207;
  fStringTable[$10000 - PResStringRec(@Consts.SNoDefaultPrinter).Identifier] := 208;
  fStringTable[$10000 - PResStringRec(@Consts.SDuplicateMenus).Identifier] := 209;
  fStringTable[$10000 - PResStringRec(@Consts.SPictureLabel).Identifier] := 210;
  fStringTable[$10000 - PResStringRec(@Consts.SPictureDesc).Identifier] := 211;
  fStringTable[$10000 - PResStringRec(@Consts.SPreviewLabel).Identifier] := 212;
  fStringTable[$10000 - PResStringRec(@Consts.SCannotOpenAVI).Identifier] := 213;
  fStringTable[$10000 - PResStringRec(@Consts.SDockedCtlNeedsName).Identifier] := 214;
  fStringTable[$10000 - PResStringRec(@Consts.SDockTreeRemoveError).Identifier] := 215;
  fStringTable[$10000 - PResStringRec(@Consts.SDockZoneNotFound).Identifier] := 216;
  fStringTable[$10000 - PResStringRec(@Consts.SDockZoneHasNoCtl).Identifier] := 217;
  fStringTable[$10000 - PResStringRec(@Consts.SMultiSelectRequired).Identifier] := 218;
  fStringTable[$10000 - PResStringRec(@Consts.SSeparator).Identifier] := 219;
  fStringTable[$10000 - PResStringRec(@Consts.SErrorSettingCount).Identifier] := 220;
  fStringTable[$10000 - PResStringRec(@Consts.SListBoxMustBeVirtual).Identifier] := 221;
  fStringTable[$10000 - PResStringRec(@Consts.SNoGetItemEventHandler).Identifier] := 222;
  //fStringTable[$10000 - PResStringRec(@HelpIntfs.hNoTableOfContents).Identifier] := 223;
  fStringTable[$10000 - PResStringRec(@Consts.SmkcRight).Identifier] := 224;
  fStringTable[$10000 - PResStringRec(@Consts.SmkcDown).Identifier] := 225;
  fStringTable[$10000 - PResStringRec(@Consts.SmkcIns).Identifier] := 226;
  fStringTable[$10000 - PResStringRec(@Consts.SmkcDel).Identifier] := 227;
  fStringTable[$10000 - PResStringRec(@Consts.SmkcShift).Identifier] := 228;
  fStringTable[$10000 - PResStringRec(@Consts.SmkcCtrl).Identifier] := 229;
  fStringTable[$10000 - PResStringRec(@Consts.SmkcAlt).Identifier] := 230;
  fStringTable[$10000 - PResStringRec(@Consts.srNone).Identifier] := 231;
  fStringTable[$10000 - PResStringRec(@Consts.SOutOfRange).Identifier] := 232;
  fStringTable[$10000 - PResStringRec(@Consts.sAllFilter).Identifier] := 233;
  fStringTable[$10000 - PResStringRec(@Consts.SInsertLineError).Identifier] := 234;
  fStringTable[$10000 - PResStringRec(@Consts.SInvalidClipFmt).Identifier] := 235;
  fStringTable[$10000 - PResStringRec(@Consts.SIconToClipboard).Identifier] := 236;
  fStringTable[$10000 - PResStringRec(@Consts.SCannotOpenClipboard).Identifier] := 237;
  fStringTable[$10000 - PResStringRec(@Consts.SDefault).Identifier] := 238;
  fStringTable[$10000 - PResStringRec(@Consts.SInvalidMemoSize).Identifier] := 239;
  fStringTable[$10000 - PResStringRec(@Consts.SMsgDlgRetry).Identifier] := 240;
  fStringTable[$10000 - PResStringRec(@Consts.SMsgDlgIgnore).Identifier] := 241;
  fStringTable[$10000 - PResStringRec(@Consts.SMsgDlgAll).Identifier] := 242;
  fStringTable[$10000 - PResStringRec(@Consts.SMsgDlgNoToAll).Identifier] := 243;
  fStringTable[$10000 - PResStringRec(@Consts.SMsgDlgYesToAll).Identifier] := 244;
  fStringTable[$10000 - PResStringRec(@Consts.SmkcBkSp).Identifier] := 245;
  fStringTable[$10000 - PResStringRec(@Consts.SmkcTab).Identifier] := 246;
  fStringTable[$10000 - PResStringRec(@Consts.SmkcEsc).Identifier] := 247;
  fStringTable[$10000 - PResStringRec(@Consts.SmkcEnter).Identifier] := 248;
  fStringTable[$10000 - PResStringRec(@Consts.SmkcSpace).Identifier] := 249;
  fStringTable[$10000 - PResStringRec(@Consts.SmkcPgUp).Identifier] := 250;
  fStringTable[$10000 - PResStringRec(@Consts.SmkcPgDn).Identifier] := 251;
  fStringTable[$10000 - PResStringRec(@Consts.SmkcEnd).Identifier] := 252;
  fStringTable[$10000 - PResStringRec(@Consts.SmkcHome).Identifier] := 253;
  fStringTable[$10000 - PResStringRec(@Consts.SmkcLeft).Identifier] := 254;
  fStringTable[$10000 - PResStringRec(@Consts.SmkcUp).Identifier] := 255;
  fStringTable[$10000 - PResStringRec(@Consts.SVMetafiles).Identifier] := 256;
  fStringTable[$10000 - PResStringRec(@Consts.SVEnhMetafiles).Identifier] := 257;
  fStringTable[$10000 - PResStringRec(@Consts.SVIcons).Identifier] := 258;
  fStringTable[$10000 - PResStringRec(@Consts.SVBitmaps).Identifier] := 259;
  fStringTable[$10000 - PResStringRec(@Consts.SMaskErr).Identifier] := 260;
  fStringTable[$10000 - PResStringRec(@Consts.SMaskEditErr).Identifier] := 261;
  fStringTable[$10000 - PResStringRec(@Consts.SMsgDlgWarning).Identifier] := 262;
  fStringTable[$10000 - PResStringRec(@Consts.SMsgDlgError).Identifier] := 263;
  fStringTable[$10000 - PResStringRec(@Consts.SMsgDlgInformation).Identifier] := 264;
  fStringTable[$10000 - PResStringRec(@Consts.SMsgDlgConfirm).Identifier] := 265;
  fStringTable[$10000 - PResStringRec(@Consts.SMsgDlgYes).Identifier] := 266;
  fStringTable[$10000 - PResStringRec(@Consts.SMsgDlgNo).Identifier] := 267;
  fStringTable[$10000 - PResStringRec(@Consts.SMsgDlgOK).Identifier] := 268;
  fStringTable[$10000 - PResStringRec(@Consts.SMsgDlgCancel).Identifier] := 269;
  fStringTable[$10000 - PResStringRec(@Consts.SMsgDlgHelp).Identifier] := 270;
  fStringTable[$10000 - PResStringRec(@Consts.SMsgDlgAbort).Identifier] := 271;
  fStringTable[$10000 - PResStringRec(@Consts.SInvalidPrinter).Identifier] := 272;
  fStringTable[$10000 - PResStringRec(@Consts.SDeviceOnPort).Identifier] := 273;
  fStringTable[$10000 - PResStringRec(@Consts.SGroupIndexTooLow).Identifier] := 274;
  fStringTable[$10000 - PResStringRec(@Consts.SNoMDIForm).Identifier] := 275;
  fStringTable[$10000 - PResStringRec(@Consts.SControlParentSetToSelf).Identifier] := 276;
  fStringTable[$10000 - PResStringRec(@Consts.SOKButton).Identifier] := 277;
  fStringTable[$10000 - PResStringRec(@Consts.SCancelButton).Identifier] := 278;
  fStringTable[$10000 - PResStringRec(@Consts.SYesButton).Identifier] := 279;
  fStringTable[$10000 - PResStringRec(@Consts.SNoButton).Identifier] := 280;
  fStringTable[$10000 - PResStringRec(@Consts.SHelpButton).Identifier] := 281;
  fStringTable[$10000 - PResStringRec(@Consts.SCloseButton).Identifier] := 282;
  fStringTable[$10000 - PResStringRec(@Consts.SIgnoreButton).Identifier] := 283;
  fStringTable[$10000 - PResStringRec(@Consts.SRetryButton).Identifier] := 284;
  fStringTable[$10000 - PResStringRec(@Consts.SAbortButton).Identifier] := 285;
  fStringTable[$10000 - PResStringRec(@Consts.SAllButton).Identifier] := 286;
  fStringTable[$10000 - PResStringRec(@Consts.SCannotDragForm).Identifier] := 287;
  fStringTable[$10000 - PResStringRec(@Consts.SWindowDCError).Identifier] := 288;
  fStringTable[$10000 - PResStringRec(@Consts.SWindowClass).Identifier] := 289;
  fStringTable[$10000 - PResStringRec(@Consts.SCannotFocus).Identifier] := 290;
  fStringTable[$10000 - PResStringRec(@Consts.SParentRequired).Identifier] := 291;
  fStringTable[$10000 - PResStringRec(@Consts.SParentGivenNotAParent).Identifier] := 292;
  fStringTable[$10000 - PResStringRec(@Consts.SMDIChildNotVisible).Identifier] := 293;
  fStringTable[$10000 - PResStringRec(@Consts.SVisibleChanged).Identifier] := 294;
  fStringTable[$10000 - PResStringRec(@Consts.SCannotShowModal).Identifier] := 295;
  fStringTable[$10000 - PResStringRec(@Consts.SScrollBarRange).Identifier] := 296;
  fStringTable[$10000 - PResStringRec(@Consts.SPropertyOutOfRange).Identifier] := 297;
  fStringTable[$10000 - PResStringRec(@Consts.SMenuIndexError).Identifier] := 298;
  fStringTable[$10000 - PResStringRec(@Consts.SMenuReinserted).Identifier] := 299;
  fStringTable[$10000 - PResStringRec(@Consts.SMenuNotFound).Identifier] := 300;
  fStringTable[$10000 - PResStringRec(@Consts.SNoTimers).Identifier] := 301;
  fStringTable[$10000 - PResStringRec(@Consts.SNotPrinting).Identifier] := 302;
  fStringTable[$10000 - PResStringRec(@Consts.SPrinting).Identifier] := 303;
  fStringTable[$10000 - PResStringRec(@Consts.SInvalidMetafile).Identifier] := 304;
  fStringTable[$10000 - PResStringRec(@Consts.SInvalidPixelFormat).Identifier] := 305;
  fStringTable[$10000 - PResStringRec(@Consts.SInvalidImage).Identifier] := 306;
  fStringTable[$10000 - PResStringRec(@Consts.SScanLine).Identifier] := 307;
  fStringTable[$10000 - PResStringRec(@Consts.SChangeIconSize).Identifier] := 308;
  fStringTable[$10000 - PResStringRec(@Consts.SOleGraphic).Identifier] := 309;
  fStringTable[$10000 - PResStringRec(@Consts.SUnknownExtension).Identifier] := 310;
  fStringTable[$10000 - PResStringRec(@Consts.SUnknownClipboardFormat).Identifier] := 311;
  fStringTable[$10000 - PResStringRec(@Consts.SOutOfResources).Identifier] := 312;
  fStringTable[$10000 - PResStringRec(@Consts.SNoCanvasHandle).Identifier] := 313;
  fStringTable[$10000 - PResStringRec(@Consts.SInvalidImageSize).Identifier] := 314;
  fStringTable[$10000 - PResStringRec(@Consts.SInvalidImageList).Identifier] := 315;
  fStringTable[$10000 - PResStringRec(@Consts.SReplaceImage).Identifier] := 316;
  fStringTable[$10000 - PResStringRec(@Consts.SImageIndexError).Identifier] := 317;
  fStringTable[$10000 - PResStringRec(@Consts.SImageReadFail).Identifier] := 318;
  fStringTable[$10000 - PResStringRec(@Consts.SImageWriteFail).Identifier] := 319;
  fStringTable[$10000 - PResStringRec(@RTLConsts.SReadOnlyProperty).Identifier] := 320;
  fStringTable[$10000 - PResStringRec(@RTLConsts.SRegCreateFailed).Identifier] := 321;
  fStringTable[$10000 - PResStringRec(@RTLConsts.SRegGetDataFailed).Identifier] := 322;
  fStringTable[$10000 - PResStringRec(@RTLConsts.SRegSetDataFailed).Identifier] := 323;
  fStringTable[$10000 - PResStringRec(@RTLConsts.SResNotFound).Identifier] := 324;
  fStringTable[$10000 - PResStringRec(@RTLConsts.SSeekNotImplemented).Identifier] := 325;
  fStringTable[$10000 - PResStringRec(@RTLConsts.SSortedListError).Identifier] := 326;
  fStringTable[$10000 - PResStringRec(@RTLConsts.STooManyDeleted).Identifier] := 327;
  fStringTable[$10000 - PResStringRec(@RTLConsts.SUnknownGroup).Identifier] := 328;
  fStringTable[$10000 - PResStringRec(@RTLConsts.SUnknownProperty).Identifier] := 329;
  fStringTable[$10000 - PResStringRec(@RTLConsts.SWriteError).Identifier] := 330;
  fStringTable[$10000 - PResStringRec(@Consts.SInvalidTabIndex).Identifier] := 331;
  fStringTable[$10000 - PResStringRec(@Consts.SInvalidTabPosition).Identifier] := 332;
  fStringTable[$10000 - PResStringRec(@Consts.SInvalidTabStyle).Identifier] := 333;
  fStringTable[$10000 - PResStringRec(@Consts.SInvalidBitmap).Identifier] := 334;
  fStringTable[$10000 - PResStringRec(@Consts.SInvalidIcon).Identifier] := 335;
  fStringTable[$10000 - PResStringRec(@RTLConsts.SIndexOutOfRange).Identifier] := 336;
  fStringTable[$10000 - PResStringRec(@RTLConsts.SInvalidImage).Identifier] := 337;
  fStringTable[$10000 - PResStringRec(@RTLConsts.SInvalidName).Identifier] := 338;
  fStringTable[$10000 - PResStringRec(@RTLConsts.SInvalidProperty).Identifier] := 339;
  fStringTable[$10000 - PResStringRec(@RTLConsts.SInvalidPropertyElement).Identifier] := 340;
  fStringTable[$10000 - PResStringRec(@RTLConsts.SInvalidPropertyPath).Identifier] := 341;
  fStringTable[$10000 - PResStringRec(@RTLConsts.SInvalidPropertyType).Identifier] := 342;
  fStringTable[$10000 - PResStringRec(@RTLConsts.SInvalidPropertyValue).Identifier] := 343;
  fStringTable[$10000 - PResStringRec(@RTLConsts.SInvalidRegType).Identifier] := 344;
  fStringTable[$10000 - PResStringRec(@RTLConsts.SInvalidStringGridOp).Identifier] := 345;
  fStringTable[$10000 - PResStringRec(@RTLConsts.SListCapacityError).Identifier] := 346;
  fStringTable[$10000 - PResStringRec(@RTLConsts.SListCountError).Identifier] := 347;
  fStringTable[$10000 - PResStringRec(@RTLConsts.SListIndexError).Identifier] := 348;
  fStringTable[$10000 - PResStringRec(@RTLConsts.SMemoryStreamError).Identifier] := 349;
  fStringTable[$10000 - PResStringRec(@RTLConsts.SPropertyException).Identifier] := 350;
  fStringTable[$10000 - PResStringRec(@RTLConsts.SReadError).Identifier] := 351;
  fStringTable[$10000 - PResStringRec(@RTLConsts.SAncestorNotFound).Identifier] := 352;
  fStringTable[$10000 - PResStringRec(@RTLConsts.SAssignError).Identifier] := 353;
  fStringTable[$10000 - PResStringRec(@RTLConsts.SBitsIndexError).Identifier] := 354;
  fStringTable[$10000 - PResStringRec(@RTLConsts.SCantWriteResourceStreamError).Identifier] := 355;
  fStringTable[$10000 - PResStringRec(@RTLConsts.SCheckSynchronizeError).Identifier] := 356;
  fStringTable[$10000 - PResStringRec(@RTLConsts.SClassNotFound).Identifier] := 357;
  fStringTable[$10000 - PResStringRec(@RTLConsts.SDuplicateClass).Identifier] := 358;
  fStringTable[$10000 - PResStringRec(@RTLConsts.SDuplicateItem).Identifier] := 359;
  fStringTable[$10000 - PResStringRec(@RTLConsts.SDuplicateName).Identifier] := 360;
  fStringTable[$10000 - PResStringRec(@RTLConsts.SDuplicateString).Identifier] := 361;
  fStringTable[$10000 - PResStringRec(@RTLConsts.SFCreateErrorEx).Identifier] := 362;
  fStringTable[$10000 - PResStringRec(@RTLConsts.SFixedColTooBig).Identifier] := 363;
  fStringTable[$10000 - PResStringRec(@RTLConsts.SFixedRowTooBig).Identifier] := 364;
  fStringTable[$10000 - PResStringRec(@RTLConsts.SFOpenErrorEx).Identifier] := 365;
  fStringTable[$10000 - PResStringRec(@RTLConsts.SGridTooLarge).Identifier] := 366;
  fStringTable[$10000 - PResStringRec(@SysConst.SLongMonthNameOct).Identifier] := 367;
  fStringTable[$10000 - PResStringRec(@SysConst.SLongMonthNameNov).Identifier] := 368;
  fStringTable[$10000 - PResStringRec(@SysConst.SLongMonthNameDec).Identifier] := 369;
  fStringTable[$10000 - PResStringRec(@SysConst.SShortDayNameSun).Identifier] := 370;
  fStringTable[$10000 - PResStringRec(@SysConst.SShortDayNameMon).Identifier] := 371;
  fStringTable[$10000 - PResStringRec(@SysConst.SShortDayNameTue).Identifier] := 372;
  fStringTable[$10000 - PResStringRec(@SysConst.SShortDayNameWed).Identifier] := 373;
  fStringTable[$10000 - PResStringRec(@SysConst.SShortDayNameThu).Identifier] := 374;
  fStringTable[$10000 - PResStringRec(@SysConst.SShortDayNameFri).Identifier] := 375;
  fStringTable[$10000 - PResStringRec(@SysConst.SShortDayNameSat).Identifier] := 376;
  fStringTable[$10000 - PResStringRec(@SysConst.SLongDayNameSun).Identifier] := 377;
  fStringTable[$10000 - PResStringRec(@SysConst.SLongDayNameMon).Identifier] := 378;
  fStringTable[$10000 - PResStringRec(@SysConst.SLongDayNameTue).Identifier] := 379;
  fStringTable[$10000 - PResStringRec(@SysConst.SLongDayNameWed).Identifier] := 380;
  fStringTable[$10000 - PResStringRec(@SysConst.SLongDayNameThu).Identifier] := 381;
  fStringTable[$10000 - PResStringRec(@SysConst.SLongDayNameFri).Identifier] := 382;
  fStringTable[$10000 - PResStringRec(@SysConst.SLongDayNameSat).Identifier] := 383;
  fStringTable[$10000 - PResStringRec(@SysConst.SShortMonthNameJun).Identifier] := 384;
  fStringTable[$10000 - PResStringRec(@SysConst.SShortMonthNameJul).Identifier] := 385;
  fStringTable[$10000 - PResStringRec(@SysConst.SShortMonthNameAug).Identifier] := 386;
  fStringTable[$10000 - PResStringRec(@SysConst.SShortMonthNameSep).Identifier] := 387;
  fStringTable[$10000 - PResStringRec(@SysConst.SShortMonthNameOct).Identifier] := 388;
  fStringTable[$10000 - PResStringRec(@SysConst.SShortMonthNameNov).Identifier] := 389;
  fStringTable[$10000 - PResStringRec(@SysConst.SShortMonthNameDec).Identifier] := 390;
  fStringTable[$10000 - PResStringRec(@SysConst.SLongMonthNameJan).Identifier] := 391;
  fStringTable[$10000 - PResStringRec(@SysConst.SLongMonthNameFeb).Identifier] := 392;
  fStringTable[$10000 - PResStringRec(@SysConst.SLongMonthNameMar).Identifier] := 393;
  fStringTable[$10000 - PResStringRec(@SysConst.SLongMonthNameApr).Identifier] := 394;
  fStringTable[$10000 - PResStringRec(@SysConst.SLongMonthNameMay).Identifier] := 395;
  fStringTable[$10000 - PResStringRec(@SysConst.SLongMonthNameJun).Identifier] := 396;
  fStringTable[$10000 - PResStringRec(@SysConst.SLongMonthNameJul).Identifier] := 397;
  fStringTable[$10000 - PResStringRec(@SysConst.SLongMonthNameAug).Identifier] := 398;
  fStringTable[$10000 - PResStringRec(@SysConst.SLongMonthNameSep).Identifier] := 399;
  fStringTable[$10000 - PResStringRec(@SysConst.SVarNotImplemented).Identifier] := 400;
  fStringTable[$10000 - PResStringRec(@SysConst.SVarUnexpected).Identifier] := 401;
  fStringTable[$10000 - PResStringRec(@SysConst.SExternalException).Identifier] := 402;
  fStringTable[$10000 - PResStringRec(@SysConst.SAssertionFailed).Identifier] := 403;
  fStringTable[$10000 - PResStringRec(@SysConst.SIntfCastError).Identifier] := 404;
  fStringTable[$10000 - PResStringRec(@SysConst.SSafecallException).Identifier] := 405;
  fStringTable[$10000 - PResStringRec(@SysConst.SAssertError).Identifier] := 406;
  fStringTable[$10000 - PResStringRec(@SysConst.SAbstractError).Identifier] := 407;
  fStringTable[$10000 - PResStringRec(@SysConst.SModuleAccessViolation).Identifier] := 408;
  fStringTable[$10000 - PResStringRec(@SysConst.SOSError).Identifier] := 409;
  fStringTable[$10000 - PResStringRec(@SysConst.SUnkOSError).Identifier] := 410;
  fStringTable[$10000 - PResStringRec(@SysConst.SShortMonthNameJan).Identifier] := 411;
  fStringTable[$10000 - PResStringRec(@SysConst.SShortMonthNameFeb).Identifier] := 412;
  fStringTable[$10000 - PResStringRec(@SysConst.SShortMonthNameMar).Identifier] := 413;
  fStringTable[$10000 - PResStringRec(@SysConst.SShortMonthNameApr).Identifier] := 414;
  fStringTable[$10000 - PResStringRec(@SysConst.SShortMonthNameMay).Identifier] := 415;
  fStringTable[$10000 - PResStringRec(@SysConst.SArgumentMissing).Identifier] := 416;
  fStringTable[$10000 - PResStringRec(@SysConst.SDispatchError).Identifier] := 417;
  fStringTable[$10000 - PResStringRec(@SysConst.SReadAccess).Identifier] := 418;
  fStringTable[$10000 - PResStringRec(@SysConst.SWriteAccess).Identifier] := 419;
  fStringTable[$10000 - PResStringRec(@SysConst.SVarArrayCreate).Identifier] := 420;
  fStringTable[$10000 - PResStringRec(@SysConst.SVarArrayBounds).Identifier] := 421;
  fStringTable[$10000 - PResStringRec(@SysConst.SVarArrayLocked).Identifier] := 422;
  fStringTable[$10000 - PResStringRec(@SysConst.SInvalidVarCast).Identifier] := 423;
  fStringTable[$10000 - PResStringRec(@SysConst.SInvalidVarOp).Identifier] := 424;
  fStringTable[$10000 - PResStringRec(@SysConst.SInvalidVarNullOp).Identifier] := 425;
  fStringTable[$10000 - PResStringRec(@SysConst.SInvalidVarOpWithHResultWithPrefix).Identifier] := 426;
  fStringTable[$10000 - PResStringRec(@SysConst.SVarTypeCouldNotConvert).Identifier] := 427;
  fStringTable[$10000 - PResStringRec(@SysConst.SVarTypeConvertOverflow).Identifier] := 428;
  fStringTable[$10000 - PResStringRec(@SysConst.SVarOverflow).Identifier] := 429;
  fStringTable[$10000 - PResStringRec(@SysConst.SVarInvalid).Identifier] := 430;
  fStringTable[$10000 - PResStringRec(@SysConst.SVarBadType).Identifier] := 431;
  fStringTable[$10000 - PResStringRec(@SysConst.SIntOverflow).Identifier] := 432;
  fStringTable[$10000 - PResStringRec(@SysConst.SInvalidOp).Identifier] := 433;
  fStringTable[$10000 - PResStringRec(@SysConst.SZeroDivide).Identifier] := 434;
  fStringTable[$10000 - PResStringRec(@SysConst.SOverflow).Identifier] := 435;
  fStringTable[$10000 - PResStringRec(@SysConst.SUnderflow).Identifier] := 436;
  fStringTable[$10000 - PResStringRec(@SysConst.SInvalidPointer).Identifier] := 437;
  fStringTable[$10000 - PResStringRec(@SysConst.SInvalidCast).Identifier] := 438;
  fStringTable[$10000 - PResStringRec(@SysConst.SAccessViolationArg3).Identifier] := 439;
  fStringTable[$10000 - PResStringRec(@SysConst.SAccessViolationNoArg).Identifier] := 440;
  fStringTable[$10000 - PResStringRec(@SysConst.SStackOverflow).Identifier] := 441;
  fStringTable[$10000 - PResStringRec(@SysConst.SControlC).Identifier] := 442;
  fStringTable[$10000 - PResStringRec(@SysConst.SPrivilege).Identifier] := 443;
  fStringTable[$10000 - PResStringRec(@SysConst.SOperationAborted).Identifier] := 444;
  fStringTable[$10000 - PResStringRec(@SysConst.SException).Identifier] := 445;
  fStringTable[$10000 - PResStringRec(@SysConst.SExceptTitle).Identifier] := 446;
  fStringTable[$10000 - PResStringRec(@SysConst.SInvalidFormat).Identifier] := 447;
  fStringTable[$10000 - PResStringRec(@SysConst.SInvalidInteger).Identifier] := 448;
  fStringTable[$10000 - PResStringRec(@SysConst.SInvalidFloat).Identifier] := 449;
  fStringTable[$10000 - PResStringRec(@SysConst.SInvalidDateTime).Identifier] := 450;
  fStringTable[$10000 - PResStringRec(@SysConst.STimeEncodeError).Identifier] := 451;
  fStringTable[$10000 - PResStringRec(@SysConst.SDateEncodeError).Identifier] := 452;
  fStringTable[$10000 - PResStringRec(@SysConst.SOutOfMemory).Identifier] := 453;
  fStringTable[$10000 - PResStringRec(@SysConst.SInOutError).Identifier] := 454;
  fStringTable[$10000 - PResStringRec(@SysConst.SFileNotFound).Identifier] := 455;
  fStringTable[$10000 - PResStringRec(@SysConst.SInvalidFilename).Identifier] := 456;
  fStringTable[$10000 - PResStringRec(@SysConst.STooManyOpenFiles).Identifier] := 457;
  fStringTable[$10000 - PResStringRec(@SysConst.SAccessDenied).Identifier] := 458;
  fStringTable[$10000 - PResStringRec(@SysConst.SEndOfFile).Identifier] := 459;
  fStringTable[$10000 - PResStringRec(@SysConst.SDiskFull).Identifier] := 460;
  fStringTable[$10000 - PResStringRec(@SysConst.SInvalidInput).Identifier] := 461;
  fStringTable[$10000 - PResStringRec(@SysConst.SDivByZero).Identifier] := 462;
  fStringTable[$10000 - PResStringRec(@SysConst.SRangeError).Identifier] := 463;
  fStringTable[$10000 - PResStringRec(@ComStrs.sPageIndexError).Identifier] := 464;
  fStringTable[$10000 - PResStringRec(@ComStrs.sInvalidComCtl32).Identifier] := 465;
  fStringTable[$10000 - PResStringRec(@ComStrs.sDateTimeMax).Identifier] := 466;
  fStringTable[$10000 - PResStringRec(@ComStrs.sDateTimeMin).Identifier] := 467;
  fStringTable[$10000 - PResStringRec(@ComStrs.sNeedAllowNone).Identifier] := 468;
  fStringTable[$10000 - PResStringRec(@ComStrs.sFailSetCalDateTime).Identifier] := 469;
  fStringTable[$10000 - PResStringRec(@ComStrs.sFailSetCalMaxSelRange).Identifier] := 470;
  fStringTable[$10000 - PResStringRec(@ComStrs.sFailSetCalMinMaxRange).Identifier] := 471;
  fStringTable[$10000 - PResStringRec(@ComStrs.sFailsetCalSelRange).Identifier] := 472;
  fStringTable[$10000 - PResStringRec(@ComStrs.sTabFailClear).Identifier] := 473;
  fStringTable[$10000 - PResStringRec(@ComStrs.sTabFailDelete).Identifier] := 474;
  fStringTable[$10000 - PResStringRec(@ComStrs.sTabFailRetrieve).Identifier] := 475;
  fStringTable[$10000 - PResStringRec(@ComStrs.sTabFailGetObject).Identifier] := 476;
  fStringTable[$10000 - PResStringRec(@ComStrs.sTabFailSet).Identifier] := 477;
  fStringTable[$10000 - PResStringRec(@ComStrs.sTabFailSetObject).Identifier] := 478;
  fStringTable[$10000 - PResStringRec(@ComStrs.sTabMustBeMultiLine).Identifier] := 479;
  fStringTable[$10000 - PResStringRec(@ComStrs.sInvalidIndex).Identifier] := 480;
  fStringTable[$10000 - PResStringRec(@ComStrs.sInsertError).Identifier] := 481;
  fStringTable[$10000 - PResStringRec(@ComStrs.sInvalidOwner).Identifier] := 482;
  fStringTable[$10000 - PResStringRec(@ComStrs.sRichEditInsertError).Identifier] := 483;
  fStringTable[$10000 - PResStringRec(@ComStrs.sRichEditLoadFail).Identifier] := 484;
  fStringTable[$10000 - PResStringRec(@ComStrs.sRichEditSaveFail).Identifier] := 485;
  fStringTable[$10000 - PResStringRec(@ComStrs.sUDAssociated).Identifier] := 486;
  fStringTable[$10000 - PResStringRec(@ComConst.SOleError).Identifier] := 487;
  fStringTable[$10000 - PResStringRec(@ComConst.SNoMethod).Identifier] := 488;
  fStringTable[$10000 - PResStringRec(@ComConst.SVarNotObject).Identifier] := 489;
  fStringTable[$10000 - PResStringRec(@ComConst.STooManyParams).Identifier] := 490;
  fStringTable[$10000 - PResStringRec(@ComConst.SDCOMNotInstalled).Identifier] := 491;
  fStringTable[$10000 - PResStringRec(@JConsts.sJPEGImageFile).Identifier] := 492;
  fStringTable[$10000 - PResStringRec(@JConsts.sChangeJPGSize).Identifier] := 493;
  fStringTable[$10000 - PResStringRec(@JConsts.sJPEGError).Identifier] := 494;
  fStringTable[$10000 - PResStringRec(@OleConst.SCannotActivate).Identifier] := 495;
  fStringTable[$10000 - PResStringRec(@OleConst.SNoWindowHandle).Identifier] := 496;
  fStringTable[$10000 - PResStringRec(@OleConst.SInvalidLicense).Identifier] := 497;
  fStringTable[$10000 - PResStringRec(@OleConst.SNotLicensed).Identifier] := 498;
  fStringTable[$10000 - PResStringRec(@OleConst.sNoRunningObject).Identifier] := 499;
  //fStringTable[$10000 - PResStringRec(@HelpIntfs.hNothingFound).Identifier] := 500;
  //fStringTable[$10000 - PResStringRec(@HelpIntfs.hNoContext).Identifier] := 501;
  //fStringTable[$10000 - PResStringRec(@HelpIntfs.hNoTopics).Identifier] := 502;
  fStringTable[$10000 - PResStringRec(@Constant.cPickMembers).Identifier] := 503;
  {$ENDIF}
  *)
end;


destructor TTranslator.Destroy;
begin
  fRedirectForm.Free;
  fRedirectStr.Free;
  fXmlTree.Free;
  inherited;
end;

{ TLangLoader }

procedure TLangLoader.SetCurrentLanguage(Value: Integer);
begin
  if (Value < -1) or (Value > Count) then
    raise Exception.CreateFmt(SListIndexError, [Value]);
  if Assigned(fTranslator) then
    fTranslator.Disable;
  fCurrentLanguage := Value;
  if Value = -1 then
    fTranslator := nil
  else begin
    fTranslator := fFiles.Objects[Value] as TTranslator;
    fTranslator.Enable;
  end;
end;

function TLangLoader.GetLanguageName(Index: Integer): string;
begin
  Result := TTranslator(fFiles.Objects[Index]).Name;
end;

function TLangLoader.Parse(const FileName: string): TObject;
begin
  Result := TTranslator.Create;
  TTranslator(Result).LoadFromFile(FileName);
end;

constructor TLangLoader.Create;
begin
  inherited;
  fCurrentLanguage := -1;
end;

initialization

  LanguageLoader := TLangLoader.Create;
  with LanguageLoader do
  try
    FileExtension := LANG_EXT;
    Paths := GlobalConfig.ReadString('LanguageDir');
    {$ifdef mswindows}
    AddPath(ExtractFileDir(application.ExeName) + '\*.' + LANG_EXT);
    {$else}
    AddPath(ExtractFileDir(application.ExeName) + '/*.' + LANG_EXT);
    {$endif}
  except
    on E: Exception do
      MessageDlg(E.Message, mtError, [mbOK], 0);
  end;

finalization

  LanguageLoader.Free;

end.



