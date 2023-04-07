  {      LDAPAdmin - Templates.pas
  *      Copyright (C) 2006-2017 Tihomir Karlovic
  *
  *      Author: Tihomir Karlovic & Alexander Sokoloff
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

unit Templates;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

{$I LdapAdmin.inc}

uses
  MaskEdit, LCLIntf, LCLType, DateTimePicker,
  SysUtils, Script,
  ComCtrls, mormot.net.ldap, LDAPClasses, Classes, Contnrs, Controls, StdCtrls, ExtCtrls, Xml,
     Forms, Graphics, Grids, Messages, Dialogs,  XmlLoader, mormot.core.base
    {$IFDEF REGEXPR}
    { Note: If you want to compile templates with regex support you'll need }
    { Regexpr.pas unit from TRegeExpr library (http://www.regexpstudio.com) }
    , Regexpr
    {$ENDIF};


const
  TEMPLATE_EXT        = 'ltf';
  FMT_DATE_TIME_UNIX  = 'unix';
  FMT_DATE_TIME_GTZ   = 'gtz';

  CT_LEFT_BORDER      = 8;
  CT_RIGHT_BORDER     = 8;
  CT_FIX_TOP          = 8;
  CT_GROUP_SPACING    = 2;
  CT_SPACING          = 8;

type
  TEventType = (etChange, etUpdate);

  TTemplateAttribute = class;
  TTemplateAttributeValue = class;

  TTControl = class of TTemplateControl;

  { Template Controls }

  TTemplateControl = class
  private
    fControl:     TControl;
    fTemplateAttribute: TTemplateAttribute;
    fLdapAttribute: TLdapAttribute;
    fLdapSession: TLdapSession;
    fControlIndex: Integer;
    fUseDefaults: Boolean;
    fChangeProc:  TNotifyEvent;
    fExitProc:    TNotifyEvent;
    fParentControl: TTemplateControl;
    fElements:    TObjectList;
    fAutoSizeX:    Boolean;
    fAutoSizeY:    Boolean;
    fAutoArrange: Boolean;
    fCaption:     RawUtf8;
    fName:        RawUtf8;
    fDataControlName: RawUtf8;
    fDataControl: TTemplateControl;
    {$IFDEF REGEXPR}
    fRegex:       TRegExpr;
    fRegexMsg:    RawUtf8;
    {$ENDIF}
    procedure     OnChangeProc(Sender: TObject);
    procedure     OnExitProc(Sender: TObject);
    procedure     SetParentControl(AControl: TTemplateControl);
    function      GetLdapSession: TLdapSession;
  protected
    function      GetParams: TStringList; virtual; abstract;
    procedure     SetOnChange(Event: TNotifyEvent); virtual;
    procedure     SetOnExit(Event: TNotifyEvent); virtual;
    procedure     SetLdapAttribute(Attribute: TLdapAttribute); virtual; abstract;
    procedure     LoadProc(XmlNode: TXmlNode); virtual; abstract;
    procedure     Validate; virtual;
    {$IFDEF REGEXPR}
    procedure     RegexEvaluate; virtual;
    {$ENDIF}
  public
    constructor   Create(Attribute: TTemplateAttribute); virtual;
    destructor    Destroy; override;
    procedure     ArrangeControls; virtual;
    procedure     AdjustSizes;
    procedure     EventProc(Attribute: TLdapAttribute; Event: TEventType); virtual; abstract;
    procedure     SetValue(AValue: TTemplateAttributeValue); virtual; abstract;
    procedure     SetDataControl(AControl: TTemplateControl); virtual;
    procedure     Read; virtual; abstract;
    procedure     Write; virtual; abstract;
    procedure     Load(XmlNode: TXmlNode);
    property      Params: TStringList read GetParams;
    property      UseDefaults: Boolean read fUseDefaults write fUseDefaults;
    property      Control: TControl read fControl;
    property      OnChange: TNotifyEvent write SetOnChange;
    property      OnExit: TNotifyEvent write SetOnExit;
    property      TemplateAttribute: TTemplateAttribute read fTemplateAttribute;
    property      LdapAttribute: TLdapAttribute read fLdapAttribute write SetLdapAttribute;
    property      LdapSession: TLdapSession read GetLdapSession write fLdapSession;
    property      ParentControl: TTemplateControl read fParentControl write SetParentControl;
    property      Elements: TObjectList read fElements;
    property      AutoSizeX: Boolean read fAutoSizeX write fAutoSizeX;
    property      AutoSizeY: Boolean read fAutoSizeY write fAutoSizeY;
    property      AutoArrange: Boolean read fAutoArrange write fAutoArrange {SetAutoArrange};
    property      Caption: RawUtf8 read fCaption;
    property      Name: RawUtf8 read fName;
    property      DataControlName: RawUtf8 read fDataControlName;
  end;

  TTemplateSVControl = class(TTemplateControl)
  private
    fLdapValue:   TLdapAttributeData;
    fParams:      TStringList;
  protected
    function      GetParams: TStringList; override;
    procedure     SetLdapAttribute(Attribute: TLdapAttribute); override;
  public
    destructor    Destroy; override;
  end;

  TTemplateMVControl = class(TTemplateControl)
  private
    fParams:      TStringList;
  protected
    {$IFDEF REGEXPR}
    procedure     RegexEvaluate; override;
    {$ENDIF}
    function      GetParams: TStringList; override;
    procedure     SetLdapAttribute(Attribute: TLdapAttribute); override;
  public
    destructor    Destroy; override;
  end;

  TTemplateNoCtrl = class(TTemplateMVControl)
  protected
    procedure     LoadProc(XmlNode: TXmlNode); override;
  public
    procedure     EventProc(Attribute: TLdapAttribute; Event: TEventType); override;
    procedure     SetValue(AValue: TTemplateAttributeValue); override;
    procedure     Read; override;
    procedure     Write; override;
  end;

  TTemplateDriverControl = class(TTemplateControl)
  protected
    function      GetParams: TStringList; override;
    procedure     SetLdapAttribute(Attribute: TLdapAttribute); override;
  public
    procedure     SetValue(AValue: TTemplateAttributeValue); override;
    procedure     Read; override;
    procedure     Write; override;
  end;

  TTemplateCtrlEdit = class(TTemplateSVControl)
  protected
    procedure     LoadProc(XmlNode: TXmlNode); override;
  public
    constructor   Create(Attribute: TTemplateAttribute); override;
    procedure     EventProc(Attribute: TLdapAttribute; Event: TEventType); override;
    procedure     SetValue(AValue: TTemplateAttributeValue); override;
    procedure     Read; override;
    procedure     Write; override;
  end;

  TTemplateCtrlCombo = class(TTemplateSVControl)
  protected
    procedure     LoadProc(XmlNode: TXmlNode); override;
  public
    constructor   Create(Attribute: TTemplateAttribute); override;
    procedure     EventProc(Attribute: TLdapAttribute; Event: TEventType); override;
    procedure     SetValue(AValue: TTemplateAttributeValue); override;
    procedure     Read; override;
    procedure     Write; override;
  end;

  TTemplateCtrlComboList = class(TTemplateSVControl)
  private
    function      IndexOfValue(Value: RawUtf8): Integer;
  protected
    procedure     LoadProc(XmlNode: TXmlNode); override;
  public
    constructor   Create(Attribute: TTemplateAttribute); override;
    procedure     EventProc(Attribute: TLdapAttribute; Event: TEventType); override;
    procedure     SetValue(AValue: TTemplateAttributeValue); override;
    procedure     Read; override;
    procedure     Write; override;
  end;

  TTemplateCtrlComboLookupList = class(TTemplateCtrlComboList)
  private
    fScope:       TLdapsearchScope;
    fSearchFilter: RawUtf8;
    fDisplayAttribute: RawUtf8;
    fValueAttribute: RawUtf8;
    fBase: RawUtf8;
  protected
    procedure     SetLdapAttribute(Attribute: TLdapAttribute); override;
    procedure     LoadProc(XmlNode: TXmlNode); override;
  public
    constructor   Create(Attribute: TTemplateAttribute); override;
  end;

  TTemplateCtrlImage=class(TTemplateSVControl)
  protected
    procedure     LoadProc(XmlNode: TXmlNode); override;
  public
    constructor   Create(Attribute: TTemplateAttribute); override;
    procedure     EventProc(Attribute: TLdapAttribute; Event: TEventType); override;
    procedure     SetValue(AValue: TTemplateAttributeValue); override;
    procedure     Read; override;
    procedure     Write; override;
  end;

  TEditGrid = class(TStringGrid)
  private
    procedure     TabMove;
    procedure     SubClassWndProc(var Message: TMessage);
  protected
    procedure     Resize; override;
  public
    constructor   Create(AOwner: TComponent); override;
  end;

  TTemplateCtrlGrid = class(TTemplateMVControl)
  private
    procedure     MyExitProc(Sender: TObject);
  protected
    procedure     LoadProc(XmlNode: TXmlNode); override;
  public
    constructor   Create(Attribute: TTemplateAttribute); override;
    procedure     EventProc(Attribute: TLdapAttribute; Event: TEventType); override;
    procedure     SetValue(AValue: TTemplateAttributeValue); override;
    procedure     Read; override;
    procedure     Write; override;
  end;

  TTemplateCtrlButton = class(TTemplateSVControl)
  protected
    procedure     LoadProc(XmlNode: TXmlNode); override;
  public
    constructor   Create(Attribute: TTemplateAttribute); override;
    procedure     EventProc(Attribute: TLdapAttribute; Event: TEventType); override;
    procedure     SetValue(AValue: TTemplateAttributeValue); override;
    procedure     Read; override;
    procedure     Write; override;
  end;

  TTemplateCtrlPasswordButton = class(TTemplateCtrlButton)
  private
    procedure     ButtonClick(Sender: TObject);
  public
    constructor   Create(Attribute: TTemplateAttribute); override;
  end;

  TTemplateCtrlTextArea = class(TTemplateSVControl)
  protected
    procedure     LoadProc(XmlNode: TXmlNode); override;
  public
    constructor   Create(Attribute: TTemplateAttribute); override;
    procedure     EventProc(Attribute: TLdapAttribute; Event: TEventType); override;
    procedure     SetValue(AValue: TTemplateAttributeValue); override;
    procedure     Read; override;
    procedure     Write; override;
  end;

  TTemplateCtrlCheckBox = class(TTemplateSVControl)
  private
    fFalse:       RawUtf8;
    fTrue:        RawUtf8;
    fMultivalue:  Boolean;
    function      GetCbState(const AState: RawUtf8): TCheckBoxState;
  protected
    procedure     LoadProc(XmlNode: TXmlNode); override;
  public
    constructor   Create(Attribute: TTemplateAttribute); override;
    procedure     EventProc(Attribute: TLdapAttribute; Event: TEventType); override;
    procedure     SetValue(AValue: TTemplateAttributeValue); override;
    procedure     Read; override;
    procedure     Write; override;
  end;

  TTemplateCtrlPanel = class(TTemplateSVControl)
  protected
    procedure     LoadProc(XmlNode: TXmlNode); override;
  public
    constructor   Create(Attribute: TTemplateAttribute); override;
    procedure     EventProc(Attribute: TLdapAttribute; Event: TEventType); override;
    procedure     SetValue(AValue: TTemplateAttributeValue); override;
    procedure     Read; override;
    procedure     Write; override;
  end;

  TTemplateCtrlTabSheet = class(TTemplateSVControl)
  protected
    procedure     LoadProc(XmlNode: TXmlNode); override;
  public
    constructor   Create(Attribute: TTemplateAttribute); override;
    procedure     EventProc(Attribute: TLdapAttribute; Event: TEventType); override;
    procedure     SetValue(AValue: TTemplateAttributeValue); override;
    procedure     Read; override;
    procedure     Write; override;
  end;

  TTemplateCtrlTabbedPanel = class(TTemplateSVControl)
  protected
    procedure     LoadProc(XmlNode: TXmlNode); override;
  public
    constructor   Create(Attribute: TTemplateAttribute); override;
    destructor    Destroy; override;
    procedure     ArrangeControls; override;
    procedure     EventProc(Attribute: TLdapAttribute; Event: TEventType); override;
    procedure     SetValue(AValue: TTemplateAttributeValue); override;
    procedure     Read; override;
    procedure     Write; override;
  end;

  { TDateTimePickerFixed - fixes the bug where control looses focus to checkbox
    when time field is changed and up-down spin buttons or keyboard are used
    with ShowCheckbox activated. Also adds custom format property for Delphi5  }

  TDateTimePickerFixed = class(TDateTimePicker)
  {$IFDEF TDATETIME_FIX}
  private
    fChanging:    Boolean;
    {$IFDEF VER130}
    fFormat:       RawUtf8;
    procedure      SetFormat(Value: RawUtf8);
    {$ENDIF}
    procedure      CNNotify(var Message: TWMNotify); message CN_NOTIFY;
  protected
    //---function       MsgSetDateTime(Value: TSystemTime): Boolean; override;
    function       MsgSetDateTime(Value: TSystemTime): Boolean;
  public
    {$IFDEF VER130}
    property       Format: RawUtf8 read fFormat write SetFormat;
    {$ENDIF}
  end{$ENDIF};

  TTemplateCtrlDate = class(TTemplateSVControl)
  private
    fDateFormat:  RawUtf8;
    fTimeFormat:  RawUtf8;
    function      GetDisplayFormat: RawUtf8;
    procedure     SetDisplayFormat(Value: RawUtf8);
    function      GetTime(Value: RawUtf8): TDateTime;
    function      GetTimeString: RawUtf8;
    procedure     SetTimeString(Value: RawUtf8);
  protected
    procedure     LoadProc(XmlNode: TXmlNode); override;
  public
    constructor   Create(Attribute: TTemplateAttribute); override;
    procedure     EventProc(Attribute: TLdapAttribute; Event: TEventType); override;
    procedure     SetValue(AValue: TTemplateAttributeValue); override;
    procedure     Read; override;
    procedure     Write; override;
    property      DisplayFormat: RawUtf8 read GetDisplayFormat write SetDisplayFormat;
    property      DateFormat: RawUtf8 read fDateFormat write fDateFormat;
    property      TimeFormat: RawUtf8 read fTimeFormat write fTimeFormat;
    property      AsString: RawUtf8 read GetTimeString write SetTimeString;
  end;

  TTemplateCtrlTime = class(TTemplateCtrlDate)
  public
    constructor   Create(Attribute: TTemplateAttribute); override;
  end;

  TTemplateCtrlDateTime = class(TTemplateCtrlPanel)
  private
    fDate:        TTemplateCtrlDate;
    fTime:        TTemplateCtrlTime;
    fVertical:    Boolean;
    procedure     MyOnChangeProc(Sender: TObject);
    procedure     MyOnResizeProc(Sender: TObject);
    procedure     SetVertical(Value: Boolean);
  protected
    procedure     LoadProc(XmlNode: TXmlNode); override;
    procedure     SetLdapAttribute(Attribute: TLdapAttribute); override;
  public
    constructor   Create(Attribute: TTemplateAttribute); override;
    procedure     EventProc(Attribute: TLdapAttribute; Event: TEventType); override;
    procedure     SetValue(AValue: TTemplateAttributeValue); override;
    procedure     Read; override;
    procedure     Write; override;
    property      Vertical: Boolean read fVertical write SetVertical;
  end;

  TTemplateCtrlPickupDlg = class(TTemplateDriverControl)
  private
    fFilter:      RawUtf8;
    fColumns:     array of RawUtf8;
    fColNames:    array of RawUtf8;
    fReturns:     RawUtf8;
    fBase: RawUtf8;
    procedure     ButtonClick(Sender: TObject);
  protected
    procedure     LoadProc(XmlNode: TXmlNode); override;
  public
    constructor   Create(Attribute: TTemplateAttribute); override;
    procedure     EventProc(Attribute: TLdapAttribute; Event: TEventType); override;
    procedure     SetValue(AValue: TTemplateAttributeValue); override;
    procedure     Read; override;
    procedure     Write; override;
  end;

  TTemplateCtrlNumber = class(TTemplateCtrlEdit)
  protected
    procedure     Validate; override;
  end;

  TTemplateCtrlInteger = class(TTemplateCtrlEdit)
  protected
    procedure     Validate; override;
  end;

  TTemplateCtrlLabel = class(TTemplateSVControl)
  private
    fFixedText:   Boolean;
  protected
    procedure     LoadProc(XmlNode: TXmlNode); override;
  public
    constructor   Create(Attribute: TTemplateAttribute); override;
    procedure     EventProc(Attribute: TLdapAttribute; Event: TEventType); override;
    procedure     SetValue(AValue: TTemplateAttributeValue); override;
    procedure     Read; override;
    procedure     Write; override;
  end;

  TTemplateCtrlList = class(TTemplateMVControl)
  private
    function      GetItemIndex: Integer;
    procedure     SetItemIndex(const Value: Integer);
    function      GetLineCount: Integer;
    function      GetLine(Index: Integer): RawUtf8;
    procedure     SetLine(Index: Integer; const Value: RawUtf8);
  protected
    procedure     LoadProc(XmlNode: TXmlNode); override;
  public
    constructor   Create(Attribute: TTemplateAttribute); override;
    procedure     EventProc(Attribute: TLdapAttribute; Event: TEventType); override;
    procedure     SetValue(AValue: TTemplateAttributeValue); override;
    procedure     Read; override;
    procedure     Write; override;
    procedure     Add(const Value: RawUtf8);
    procedure     Delete(Index: Integer);
    property      ItemIndex: Integer read GetItemIndex write SetItemIndex;
    property      Lines[Index: Integer]: RawUtf8 read GetLine write SetLine;
    property      LineCount: Integer read GetLineCount;
  end;

  TTemplateCtrlListBox = class(TTemplateCtrlPanel)
  private
    fList:        TTemplateCtrlList;
    fVertical:    Boolean;
    fLeft:        Boolean;
    fBtnWidth:    Integer;
    fBtnHeight:   Integer;
    fMaxBtnWidth: Integer;
    fMaxBtnHeight:Integer;
    fMargin:      Integer;
    fBrowseBtn:   TTemplateCtrlPickupDlg;
    fAddBtn:      TButton;
    fEditBtn:     TButton;
    fDeleteBtn:   TButton;
    procedure     MyOnResizeProc(Sender: TObject);
    procedure     MyOnButtonProc(Sender: TObject);
    procedure     ActAdd(Sender: TObject);
    procedure     ActDelete(Sender: TObject);
    procedure     ActEdit(Sender: TObject);
    procedure     ArrangeBox;
    procedure     ArrangeButtons;
    procedure     SetVertical(Value: Boolean);
    procedure     SetLeft(Value: Boolean);
  protected
    procedure     LoadProc(XmlNode: TXmlNode); override;
    procedure     SetLdapAttribute(Attribute: TLdapAttribute); override;
  public
    constructor   Create(Attribute: TTemplateAttribute); override;
    procedure     EventProc(Attribute: TLdapAttribute; Event: TEventType); override;
    procedure     SetValue(AValue: TTemplateAttributeValue); override;
    procedure     Read; override;
    procedure     Write; override;
    property      Vertical: Boolean read fVertical write SetVertical;
    property      Left: Boolean read fLeft write SetLeft;
  end;

  TTemplateCtrlLoadButton = class(TTemplateCtrlButton)
  private
    fFilter: RawUtf8;
    fFilterIndex: Integer;
    procedure     ButtonClick(Sender: TObject);
  protected
    procedure     LoadProc(XmlNode: TXmlNode); override;
  public
    constructor   Create(Attribute: TTemplateAttribute); override;
  end;

  { Template classes }

  TTemplateScriptEvent = class
  private
    fControl: TTemplateControl;
    fNode:      TXmlNode;
    function    GetEventName: RawUtf8;
    function    GetCode: RawUtf8;
  public
    constructor Create(Control: TTemplateControl; Node: TXmlNode);
    property    Control: TTemplateControl read fControl;
    property    Name: RawUtf8 read GetEventName;
    property    Code: RawUtf8 read GetCode;
  end;

  TTemplateControlList = class(TObjectList)
  private
    function      GetControl(Index: Integer): TTemplateControl;
  public
    property      Controls[Index: integer]: TTemplateControl read GetControl; default;
  end;

  TTemplateAttributeList = class(TObjectList)
  private
    function      GetAttribute(Index: Integer): TTemplateAttribute;
  public
    property      Attributes[Index: integer]: TTemplateAttribute read GetAttribute; default;
  end;

  TTemplateScriptEventList = class(TObjectList)
  private
    function      GetEvent(Index: Integer): TTemplateScriptEvent;
  public
    property      Events[Index: integer]: TTemplateScriptEvent read GetEvent; default;
  end;

  TTemplateAttributeValue = class
  private
    FBase64:      Boolean;
    FValue:       RawUtf8;
    FAttribute:   TTemplateAttribute;
    procedure     SetBase64(const Value: Boolean);
    procedure     SetValue(const Value: RawUtf8);
    function      GetString: RawUtf8;
  public
    constructor   Create(AAttribute: TTemplateAttribute);
    procedure     SaveToStream(AStream: TStream);
    property      Base64: Boolean read FBase64 write SetBase64;
    property      Value: RawUtf8 read FValue write SetValue;
    property      AsString: RawUtf8 read GetString;
    property      Attribute: TTemplateAttribute read fAttribute;
  end;

 TTemplateAttribute = class
  private
    FRequired:    Boolean;
    FDescription: RawUtf8;
    FName:        RawUtf8;
    FValues:      TObjectList;
    FControls:    TTemplateControlList;
    FDefaultControlClass: TTControl;
    function      GetValues(Index: Integer): TTemplateAttributeValue;
    function      GetValuesCount: integer;
  public
    constructor   Create(XmlNode: TXmlNode); reintroduce;
    destructor    Destroy; override;
    property      Name: RawUtf8 read FName;
    property      Description: RawUtf8 read FDescription;
    property      Required: Boolean read FRequired;
    property      Values[Index: Integer]: TTemplateAttributeValue read GetValues;
    property      ValuesCount: integer read GetValuesCount;
    property      Controls: TTemplateControlList read fControls;
  end;

 TTemplate = class
  private
    FXmlTree: TXmlTree;
    FDescription: RawUtf8;
    FName:        RawUtf8;
    FFileName:    RawUtf8;
    FRdn:         RawUtf8;
    FAutoArrange: Boolean;
    FAutoSize: Boolean;
    FObjectclass: TTemplateAttribute;
    FExtends:     TStringList;
    FIcon:        TBitmap;
    FImageIndex:  Integer;
    function      GetObjectclasses(Index: Integer): RawUtf8;
    function      GetObjectclassCount: Integer;
  public
    constructor   Create(const AFileName: RawUtf8); reintroduce;
    function      Matches(ObjectClass: TLdapAttribute): Boolean;
    destructor    Destroy; override;
    property      Name: RawUtf8 read FName;
    procedure     Parse(Control: TTemplateControl; out Script: TCustomScript);
    property      Description: RawUtf8 read FDescription;
    property      Objectclasses[Index: Integer]: RawUtf8 read GetObjectclasses;
    property      ObjectclassCount: Integer read GetObjectclassCount;
    property      AutoArrangeControls: Boolean read fAutoArrange;
    property      AutoSizeControls: Boolean read fAutoSize;
    property      Extends: TStringlist read fExtends;
    property      Rdn: RawUtf8 read fRdn;
    property      Icon: TBitmap read FIcon;
    property      XmlTree: TxmlTree read fXmlTree;
    property      ImageIndex: Integer read FImageIndex;
  end;

  TTemplateList = class(TList)
  private
    function      GetItem(Index: Integer): TTemplate;
  public
    property      Templates[Index: Integer]: TTemplate read GetItem; default;
  end;

  TExtensionList = class
  private
    fExtensionList: TStringList;
    function      GetTemplates(Index: RawUtf8): TTemplateList;
  public
    constructor   Create;
    destructor    Destroy; override;
    procedure     Clear;
    procedure     Add(AValue: RawUtf8; ATemplate: TTemplate);
    property      Extensions[Index: RawUtf8]: TTemplateList read GetTemplates; default;
  end;

  TTemplateParser = class(TXmlLoader)
  private
    fExtensionList: TExtensionList;
    fImageList:   TImageList;
    function      GetTemplate(Index: Integer): TTemplate;
    procedure     SetImageList(AList: TImageList);
  public
    constructor   Create; override;
    destructor    Destroy; override;
    procedure     Clear; override;
    function      Parse(const FileName: RawUtf8): TObject; override;
    function      IndexOf(const Name: RawUtf8): Integer;
    property      Templates[Index: Integer]: TTemplate read GetTemplate;
    property      Extensions: TExtensionList read fExtensionList;
    property      ImageList: TImageList read fImageList write SetImageList;
  end;

var
  Iso639LangName: RawUtf8;
  TemplateParser: TTemplateParser;

implementation

uses
   variants,
  Windows,
  WinBase64, {SysUtils,} Misc, Params, Config, Constant,  LinLDAP,
  Connection,Pickup, ParseErr {$IFDEF VER_XEH}, System.UITypes{$ENDIF};

const
  CONTROLS_CLASSES: array[0..21] of TTControl = ( TTemplateCtrlEdit,
                                                  TTemplateCtrlCombo,
                                                  TTemplateCtrlComboList,
                                                  TTemplateCtrlComboLookupList,
                                                  TTemplateCtrlImage,
                                                  TTemplateCtrlGrid,
                                                  TTemplateCtrlButton,
                                                  TTemplateCtrlPasswordButton,
                                                  TTemplateCtrlTextArea,
                                                  TTemplateCtrlCheckBox,
                                                  TTemplateCtrlPanel,
                                                  TTemplateCtrlTabbedPanel,
                                                  TTemplateCtrlDate,
                                                  TTemplateCtrlTime,
                                                  TTemplateCtrlDateTime,
                                                  TTemplateCtrlPickupDlg,
                                                  TTemplateCtrlNumber,
                                                  TTemplateCtrlInteger,
                                                  TTemplateCtrlLabel,
                                                  TTemplateCtrlList,
                                                  TTemplateCtrlListBox,
                                                  TTemplateCtrlLoadButton );
  //DEFAULT_CONTROL_CLASS: TTControl = TTemplateCtrlEdit;

  EVENT_NAMES: RawUtf8 = 'ONCLICK,ONDBLCLICK,ONKEYDOWN,ONKEYPRESS,ONKEYUP,' +
                        'ONCHANGE,ONMOUSEDOWN,ONMOUSEMOVE,ONMOUSEUP,ONRESIZE';

function GetXmlTypeByClass(AClass: TTControl): RawUtf8;
const
  PREFIX='ttemplatectrl';
  LEN=length(PREFIX);
begin
  result:=LowerCase(AClass.ClassName);
  if pos(PREFIX, result)=1 then begin
    delete(result, 1, LEN);
  end
  else result:='';
end;

function GetClassByXmlType(XmlType: RawUtf8): TTControl;
const
  PREFIX='ttemplatectrl';
var
  i: integer;
begin
  result:=nil;
  for i:=0 to high(CONTROLS_CLASSES) do begin
    if LowerCase(CONTROLs_CLASSES[i].ClassName)=PREFIX+XmlType then begin
      result:=CONTROLs_CLASSES[i];
      exit;
    end;
  end;
end;

function GetDefaultXmlType(XmlNode: TXmlNode): TTControl;
var
  XmlType: RawUtf8;
begin
  Result := nil;
  if XmlNode.Name = 'objectclass' then Exit;

  XmlType := XmlNode.Attributes.Values['type'];

  if XmlType = '' then
  begin
    Result := TTemplateNoCtrl;
    exit;
  end;

  if Lowercase(XmlType) = 'text' then
    Result := GetClassByXmlType('edit')
  else
  if Lowercase(XmlType) = 'boolean' then
    Result := GetClassByXmlType('checkbox')
  else
  if Lowercase(XmlType) = 'jpeg' then
    Result := GetClassByXmlType('image')
  else
    Result := GetClassByXmlType(XmlType);

  if Result = nil then
    Result := TTemplateNoCtrl;
end;

function CheckStrToInt(const Value, Tag: RawUtf8): Integer;
begin
  try
    Result := StrToInt(Value);
  except
    on E:EConvertError do
      raise Exception.Create(Format(stInvalidTagValue, [Value, Tag]))
    else
      raise;
  end;
end;

function GetIso639LangName: RawUtf8;
var
  Buffer: array[0..8] of Char;
begin
  {$ifdef mswindows}
  if GetLocaleInfo(SysLocale.DefaultLCID, LOCALE_SISO639LANGNAME, @Buffer, SizeOf(Buffer)) > 0 then
    Result := PChar(@Buffer)
  else
    Result := '';
  {$else}
  Result := SysUtils.GetEnvironmentVariable('LANG');
  {$endif}
end;

function XmlLanguageMatch(XmlNode: TXmlNode): Boolean;
var
  Lang: RawUtf8;
begin
  if Iso639LangName <> '' then
  begin
    Lang := XmlNode.Attributes.Values['lang'];
    if (Lang <> '') and not AnsiSameText(Iso639LangName, Lang) then
    begin
      Result := false;
      Exit;
    end;
  end;
  Result := true;
end;

function CreateScript(XmlNode: TXmlNode): TCustomScript;
var
  XmlType: RawUtf8;
  FileName: RawUtf8;
begin
  XmlType := XmlNode.Attributes.Values['type'];

  if (XmlType = '') or (XmlType='text/javascript') then
    Result := TJavaScript.Create
  else
  if (XmlType = '') or (XmlType='text/vbscript') then
    Result := TVisualBasicScript.Create
  else
    raise Exception.Create(stUnsuppScript + XmlType);

  Filename := XmlNode.Attributes.Values['src'];
  if FileName <> '' then
    Result.Lines.Text := FileReadString(FileName)
  else
    Result.Lines.Text := XmlNode.Content;

  Result.AddScriptlet(CreateHostScriptlet(Result, nil, nil));
end;

function CreateControl(ControlTemplate: TXmlNode; Attribute: TTemplateAttribute): TTemplateControl;
var
  AClass: TTControl;
begin
  AClass := nil;

  if Assigned(ControlTemplate) then
    AClass:=GetClassByXmlType(ControlTemplate.Attributes.Values['type']);

  if Assigned(AClass) then
  begin
    Result := AClass.Create(Attribute);
    Result.Load(ControlTemplate);
  end
  else
    Result := nil;
end;

{ TTemplateMVControl }
function TTemplateMVControl.GetParams: TStringList;
var
  p: PChar;
  Param: RawUtf8;
  i: Integer;
begin
  if not Assigned(fParams) then
  begin
    fParams := TStringList.Create;
    if fUseDefaults then
    begin
      for i := 0 to TemplateAttribute.ValuesCount - 1 do
      begin
        p := PChar(TemplateAttribute.Values[i].AsString);
        Param := GetParameter(p);
        while Param <> '' do begin
          if fParams.IndexOf(Param) = -1 then
            fParams.Add(Param);
          Param := GetParameter(p);
        end;
      end;
    end;
  end;
  Result := fParams;
end;

{$IFDEF REGEXPR}
procedure TTemplateMVControl.RegexEvaluate;
var
  Res: Boolean;
  err, i: Integer;
  val, msg: RawUtf8;
begin
 if Assigned(fLdapAttribute) and (fRegex.Expression <> '') then
 for i := 0 to fLdapAttribute.ValueCount - 1 do
 begin
   val := fLdapAttribute.Values[i].AsString;
   if val = '' then Continue;
   Res := fRegex.Exec(val);
   if not Res then
   begin
     if fControl is TWinControl then
       TWinControl(fControl).SetFocus;
     err := fRegEx.LastError;
     if err <> 0 then
       msg := fRegEx.ErrorMsg(err)
     else
     if fRegexMsg <> '' then
       msg := fRegexMsg
     else
       msg := stRegexFailed;
     raise Exception.Create(msg);
   end;
 end;
end;
{$ENDIF}

procedure TTemplateMVControl.SetLdapAttribute(Attribute: TLdapAttribute);
var
  i: Integer;
begin
  fLdapAttribute := Attribute;
  if UseDefaults then
    for i := 0 to TemplateAttribute.ValuesCount - 1 do
    begin
      if i >= fLdapAttribute.ValueCount then
        fLdapAttribute.AddValue;
      if (fLdapAttribute.Values[i].DataSize = 0) and
            not IsParametrized(TemplateAttribute.Values[i].AsString) then
        fLdapAttribute.Values[i].AsString := TemplateAttribute.Values[i].AsString;
    end;
  Read;
end;

destructor TTemplateMVControl.Destroy;
begin
  fParams.Free;
  inherited;
end;

{ TTemplateSVControl }

function TTemplateSVControl.GetParams: TStringList;
var
  p: PChar;
  Param: RawUtf8;
begin
  if not Assigned(fParams) then
  begin
    fParams := TStringList.Create;
    if fUseDefaults then
    begin
      if fControlIndex < TemplateAttribute.ValuesCount then
      begin
        p := PChar(TemplateAttribute.Values[fControlIndex].AsString);
        Param := GetParameter(p);
        while Param <> '' do begin
          if fParams.IndexOf(Param) = -1 then
            fParams.Add(Param);
          Param := GetParameter(p);
        end;
      end;
    end;
  end;
  Result := fParams;
end;

procedure TTemplateSVControl.SetLdapAttribute(Attribute: TLdapAttribute);
begin
  fLdapAttribute := Attribute;
  if fControlIndex < Attribute.ValueCount then
    fLdapValue := Attribute.Values[fControlIndex]
  else begin
    fLdapValue := Attribute.AddValue;
    if UseDefaults and (fControlIndex < TemplateAttribute.ValuesCount) and
                   not IsParametrized(TemplateAttribute.Values[fControlIndex].AsString) then
       SetValue(TemplateAttribute.Values[fControlIndex]);
  end;
  if fControlIndex >= Attribute.ValueCount then
    raise Exception.Create('Internal error: Control processed out of order!');
  Read;
end;

destructor TTemplateSVControl.Destroy;
begin
  fParams.Free;
  inherited;
end;

{ TTemplateControl }

procedure TTemplateControl.AdjustSizes;
var
  i, j: Integer;
begin
  for i := 0 to Elements.Count - 1 do
    if Elements[i] is TTemplateControl then with TTemplateControl(Elements[i]) do
    begin
      if (ClassName <> 'TTemplateCtrlTabSheet') and AutoSizeX and Assigned(Control) and Assigned(Control.Parent) then
        Control.Width := Control.Parent.ClientWidth - CT_LEFT_BORDER - CT_RIGHT_BORDER;
      AdjustSizes;
    end
    else if Elements[i] is TTemplateAttribute then with TTemplateAttribute(Elements[i]) do
      for j := 0 to Controls.Count - 1 do with Controls[j] do
      begin
        if AutoSizeX and Assigned(Control) and Assigned(Control.Parent) then
          Control.Width := Control.Parent.ClientWidth - CT_LEFT_BORDER - CT_RIGHT_BORDER;
        AdjustSizes;
      end;
end;

function TTemplateControl.GetLdapSession: TLdapSession;
begin
  if not Assigned(fLdapSession) then
  begin
    if Assigned(fLdapAttribute) and Assigned(fLdapAttribute.Entry) then
      fLdapSession := fLdapAttribute.Entry.Session;
  end;
  Result := fLdapSession;
end;

procedure TTemplateControl.OnChangeProc(Sender: TObject);
begin
  Write;
  if Assigned(fChangeProc) then fChangeProc(Self);
end;

procedure TTemplateControl.OnExitProc(Sender: TObject);
begin
  {$IFDEF REGEXPR}
  RegexEvaluate;
  {$ENDIF}
  Validate;
  if Assigned(fExitProc) then fExitProc(Self);
end;

procedure TTemplateControl.SetParentControl(AControl: TTemplateControl);
begin

  if Assigned(AControl) then
  begin
    fParentControl := AControl;
    if Assigned(fControl) and (fParentControl.Control is TWinControl) then
      fControl.Parent := TWinControl(fParentControl.Control);
  end
  else
  if Assigned(fParentControl) then
  begin
    fParentControl := nil;
    if Assigned(fControl) then
      fControl.Parent := nil;
  end;
end;

procedure TTemplateControl.SetDataControl(AControl: TTemplateControl);
begin
  fDataControl := AControl;
end;

procedure TTemplateControl.Load(XmlNode: TXmlNode);
var
  NotParented: boolean;
  i, j: Integer;
  AAttribute: TTemplateAttribute;
  AControl: TTemplateControl;
  Node: TXmlNode;

  function GetColor(const Value, Tag: RawUtf8): TColor;
  var
    c: Cardinal;
  begin
    c := CheckStrToInt(Value, Tag);
    //Reorder bytes to BGR as expected by TColor
    Result := (c shr 16 + c and $00FF00 + c shl 16) and $00FFFFFF;
  end;

  procedure ParseStyle(const Value: RawUtf8);
  var
    style: TFontStyles;
  begin
    style := TLabel(fControl).Font.Style;
    if Pos('bold', Value) > 0 then
       style := style + [fsBold];
    if Pos('italic', Value) > 0 then
       style := style + [fsItalic];
    if Pos('underline', Value) > 0 then
       style := style + [fsUnderline];
    if Pos('strikeout', Value) > 0 then
       style := style + [fsStrikeOut];
    TLabel(fControl).Font.Style := style;
  end;

begin

  if Assigned(XmlNode) then
  begin
    for i:=0 to XmlNode.Count-1 do with XmlNode[i] do
    begin
      {$IFDEF REGEXPR}
      if Name = 'regex' then
      begin
        Node := XmlNode[i].NodeByName('expression');
        if Assigned(Node) then
          fRegex.Expression := Node.Content;
        Node := XmlNode[i].NodeByName('errormessage');
        if Assigned(Node) then
          fRegexMsg := Node.Content;
      end
      else
      {$ENDIF}
      if Name = 'attribute' then
      begin
        AAttribute := TTemplateAttribute.Create(XmlNode[i]);
        fElements.Add(AAttribute);
        for j := 0 to AAttribute.Controls.Count - 1 do
          AAttribute.Controls[j].ParentControl := Self;
      end
      else
      if Name = 'control' then
      begin
        AControl := CreateControl(XmlNode[i], nil);
        if Assigned(AControl) then
        begin
          fElements.Add(AControl);
          AControl.ParentControl := Self;
        end;
      end
      else
      if Name = 'caption' then
      begin
        if XmlLanguageMatch(XmlNode[i]) then
          fCaption := Content
      end
      else
      if Name = 'height' then
      begin
        fControl.Height := CheckStrToInt(Content, Name);
        fAutoSizeY := false;
      end
      else
      if Name = 'width' then
      begin
        fControl.Width := CheckStrToInt(Content, Name);
        fAutoSizeX := false;
      end
      else
      if Name = 'top' then
      begin
        fControl.Top := CheckStrToInt(Content, Name);
        fAutoArrange := false;
      end
      else
      if Name = 'left' then
      begin
        fControl.Left := CheckStrToInt(Content, Name);
        fAutoArrange := false;
      end
      else
      if Name = 'color' then
        TLabel(fControl).Color := GetColor(Content, Name)
      else
      if Name = 'fontcolor' then
        TLabel(fControl).Font.Color := GetColor(Content, Name)
      else
      if Name = 'fontstyle' then
        ParseStyle(Content)
      else
      if Name = 'enabled' then
      begin
        if Content = 'false' then
          fControl.Enabled := false;
      end
      else
      if Name = 'name' then
      begin
        fName := Content;
        fControl.Name := fName;
      end
      else
      if Name = 'autosize' then
      begin
        if Content = 'false' then
          fControl.Enabled := false;
      end
      else
      if Name = 'datacontrol' then
        fDataControlName := Content
      else
      if Name = 'event' then
        if Pos(Uppercase(Attributes.Values['type']), EVENT_NAMES) > 0 then
          fElements.Add(TTemplateScriptEvent.Create(Self, XmlNode[i]));
     end;

    { NotParented:=(fControl.Parent=nil);
      For some reason, if TTemplateCtrlDateTime control is created within
      attribute which itself is placed on a panel control and if TTemplateCtrlDateTime
      control gets its parent set and unset here, it will produce "Control has
      no parent window" exception when parented again:

      if Name = 'attribute' then
      begin
        AAttribute := TTemplateAttribute.Create(XmlNode[i]);
        fElements.Add(AAttribute);
        for j := 0 to AAttribute.Controls.Count - 1 do
          AAttribute.Controls[j].ParentControl := Self; -> exception
      end
      I can't find better solution here }
    NotParented := (fControl.Parent = nil) and not (Self is TTemplateCtrlDateTime);

    if NotParented then begin
      // Prevent "Control has no parent window" exception when Items are set
      fControl.Visible:=false;
      fControl.Parent:=Application.MainForm;
    end;

    LoadProc(XmlNode);

    if NotParented then begin
      fControl.Parent:=nil;
      fControl.Visible:=true;
    end;
  end;

end;

procedure TTemplateControl.SetOnChange(Event: TNotifyEvent);
begin
  fChangeProc := Event;
end;

procedure TTemplateControl.SetOnExit(Event: TNotifyEvent);
begin
  fExitProc := Event;
end;

procedure TTemplateControl.Validate;
begin
end;

{$IFDEF REGEXPR}
procedure TTemplateControl.RegexEvaluate;
var
  Res: Boolean;
  err: Integer;
  msg: RawUtf8;
begin
 if Assigned(fLdapAttribute) and (fRegex.Expression <> '') and (fLdapAttribute.AsString <> '') then
 begin
   Res := fRegex.Exec(fLdapAttribute.AsString);
   if not Res then
   begin
     if fControl is TWinControl then
       TWinControl(fControl).SetFocus;
     err := fRegEx.LastError;
     if err <> 0 then
       msg := fRegEx.ErrorMsg(err)
     else
     if fRegexMsg <> '' then
       msg := fRegexMsg
     else
       msg := stRegexFailed;
     raise Exception.Create(msg);
   end;
 end;
end;
{$ENDIF}

procedure TTemplateControl.ArrangeControls;
var
  Element: TObject;
  TemplateControl: TTemplateControl;
  i, j, YPos: Integer;

  procedure PlaceControl;
  var
    L: TLabel;
    cap: RawUtf8;
  begin
   { Position the control }
    with TemplateControl do
    begin
      if Autoarrange then
      begin
        cap := '';
        { Some controls have thier own captions and don't need labels }
        if not ((Control is TCheckbox) or (Control is TButton)) then
        begin
          if Caption <> '' then
            cap := Caption
          else
          if Assigned(TemplateAttribute) then
          begin
            if TemplateAttribute.Description <> '' then
              cap := TemplateAttribute.Description
            else
              cap := TemplateAttribute.Name;
          end;
        end;
        if cap <> '' then
        begin
          cap := cap + ':';
          L := TLabel.Create(Self.Control);
          L.Caption := cap;
          if Control is TWinControl then
            L.FocusControl := TWinControl(Control);
          L.Left := CT_LEFT_BORDER;
          L.Top := yPos;
          L.Parent := Control.Parent;
          inc(yPos, L.Height + CT_GROUP_SPACING);
        end;
        Control.Left := CT_LEFT_BORDER;
        Control.Top := yPos;
        if Control is TImage then
          (Control as TImage).AutoSize := true;
        inc(yPos, Control.Height + CT_SPACING);
      end;
    end;
  end;

begin
  if not Assigned(fControl) then Exit;
  yPos := CT_FIX_TOP;
  for i := 0 to Elements.Count - 1 do
  begin
    Element := Elements[i];
    if Element is TTemplateAttribute then with TTemplateAttribute(Element) do
    begin
      for j := 0 to Controls.Count - 1 do
      begin
        TemplateControl := Controls[j];
        if not(TemplateControl is TTemplateNoCtrl) then
        begin
          TemplateControl.ArrangeControls;
          PlaceControl;
        end;
      end;
    end
    else
    if Element is TTemplateControl then
    begin
      TemplateControl := TTemplateControl(Element);
      if not(TemplateControl is TTemplateNoCtrl) then with TemplateControl do
      begin
        TemplateControl.ArrangeControls;
        if not Assigned(TemplateAttribute) then
          PlaceControl;
      end;
    end;
  end;
  if AutoSizeY and (yPos > Control.Height) then
    Control.Height := yPos;
end;

constructor TTemplateControl.Create(Attribute: TTemplateAttribute);
begin
  fElements := TObjectList.Create;
  fTemplateAttribute := Attribute;
  fAutoSizeX := true;
  fAutoSizeY := true;
  fAutoArrange := true;
  {$IFDEF REGEXPR}
  fRegex := TRegExpr.Create;
  {$ENDIF}
end;

destructor TTemplateControl.Destroy;
begin
  fElements.Free;
  fControl.Free;
  {$IFDEF REGEXPR}
  fRegex.Free;
  {$ENDIF}
  inherited;
end;

{ TTemplateNoCtrl }

procedure TTemplateNoCtrl.SetValue(AValue: TTemplateAttributeValue);
begin

end;

procedure TTemplateNoCtrl.Read;
begin

end;

procedure TTemplateNoCtrl.Write;
begin

end;

procedure TTemplateNoCtrl.LoadProc(XmlNode: TXmlNode);
begin

end;

procedure TTemplateNoCtrl.EventProc(Attribute: TLdapAttribute; Event: TEventType);
var
  i: Integer;
  s: RawUtf8;
begin
  if (Event = etChange) then with fTemplateAttribute do
    for i := 0 to ValuesCount -  1 do
    begin
      s := FormatValue(Values[i].AsString, Attribute.Entry);
      if not IsParametrized(s) then
      begin
        fLdapAttribute.Values[i].AsString := s;
        if Assigned(fChangeProc) then
          fChangeProc(Self);
      end;
    end;
end;

{ TTemplateDriverControl }

function TTemplateDriverControl.GetParams: TStringList;
begin
  Result := nil;
end;

procedure TTemplateDriverControl.SetLdapAttribute(Attribute: TLdapAttribute);
begin
  fLdapAttribute := Attribute;
end;

procedure TTemplateDriverControl.Read;
begin

end;

procedure TTemplateDriverControl.Write;
begin
end;

procedure TTemplateDriverControl.SetValue(AValue: TTemplateAttributeValue);
begin

end;

{ TTemplateCtrlEdit }

procedure TTemplateCtrlEdit.SetValue(AValue: TTemplateAttributeValue);
begin
  (Control as TMaskEdit).Text := AValue.AsString;
end;

procedure TTemplateCtrlEdit.Read;
begin
  if Assigned(fControl) and Assigned(fLdapValue) then
    (fControl as TMaskEdit).Text := fLdapValue.AsString;
end;

procedure TTemplateCtrlEdit.Write;
begin
  if Assigned(fControl) and Assigned(fLdapValue) then
    fLdapValue.AsString := (fControl as TMaskEdit).Text;
end;

procedure TTemplateCtrlEdit.LoadProc(XmlNode: TXmlNode);
var
  Node: TXmlNode;
begin
  Node:=XmlNode.NodeByName('editmask');
  if Assigned(Node) then TMaskEdit(fControl).EditMask := Node.Content;
end;

procedure TTemplateCtrlEdit.EventProc(Attribute: TLdapAttribute; Event: TEventType);
begin
  with (fControl as TMaskEdit), fTemplateAttribute do
  if (Event = etChange) and not Modified and (ValuesCount > 0) then
    Text := FormatValue(Values[0].AsString, Attribute.Entry);
end;

constructor TTemplateCtrlEdit.Create(Attribute: TTemplateAttribute);
begin
  inherited;
  fControl := TMaskEdit.Create(nil);
  TMaskEdit(fControl).OnChange := OnChangeProc;
  TMaskEdit(fControl).OnExit := OnExitProc;
end;

{ TTemplateCtrlCombo }

procedure TTemplateCtrlCombo.SetValue(AValue: TTemplateAttributeValue);
begin
  with (fControl as TComboBox) do begin
    Text := AValue.AsString;
    OnChange(fControl);
  end;
end;

procedure TTemplateCtrlCombo.Read;
begin
  if Assigned(fControl) and Assigned(fLdapValue) then
    (fControl as TComboBox).Text := fLdapValue.AsString;
end;

procedure TTemplateCtrlCombo.Write;
begin
  if Assigned(fControl) and Assigned(fLdapValue) then
    fLdapValue.AsString := (fControl as TComboBox).Text;
end;

constructor TTemplateCtrlCombo.Create(Attribute: TTemplateAttribute);
begin
  inherited;
  fControl := TComboBox.Create(nil);
  TComboBox(fControl).OnChange := OnChangeProc;
  TComboBox(fControl).OnExit := OnExitProc;
end;

procedure TTemplateCtrlCombo.LoadProc(XmlNode: TXmlNode);
var
  i: integer;
  ItemsNode: TXmlNode;
begin
  ItemsNode:=XmlNode.NodeByName('items');
  if ItemsNode=nil then exit;
  for i:=0 to ItemsNode.Count-1 do
    if ItemsNode[i].Name='item' then TComboBox(fControl).Items.Add(ItemsNode[i].Content);
end;

procedure TTemplateCtrlCombo.EventProc(Attribute: TLdapAttribute; Event: TEventType);
begin
  with (fControl as TComboBox), fTemplateAttribute do
  if (Event = etChange) and (ValuesCount > 0) then
  begin
    Text := FormatValue(Values[0].AsString, Attribute.Entry);
    OnChange(fControl);
    OnExit(fControl);
  end;
end;

{ TTemplateCtrlComboList }

function TTemplateCtrlComboList.IndexOfValue(Value: RawUtf8): Integer;
var
  p: PChar;
begin
  with TcomboBox(fControl) do
  begin
    p := PChar(Value);
    Result := Items.Count - 1;
    while Result >= 0 do begin
      if AnsiStrComp(p, PChar(Items.Objects[Result])) = 0 then
        break;
      dec(Result);
    end;
  end;
end;

procedure TTemplateCtrlComboList.SetValue(AValue: TTemplateAttributeValue);
begin
  with (fControl as TComboBox) do begin
    ItemIndex := IndexOfValue(AValue.AsString);
    OnChange(fControl);
  end;
end;

procedure TTemplateCtrlComboList.Read;
begin
  if Assigned(fControl) and Assigned(fLdapValue) then with (fControl as TComboBox) do
    ItemIndex := IndexOfValue(fLdapValue.AsString);
end;

procedure TTemplateCtrlComboList.Write;
begin
  if Assigned(fControl) and Assigned(fLdapValue) then with (fControl as TComboBox) do
    if ItemIndex <> -1 then
      fLdapValue.AsString := PChar(Items.Objects[ItemIndex]);
end;

constructor TTemplateCtrlComboList.Create(Attribute: TTemplateAttribute);
begin
  inherited;
  fControl := TComboBox.Create(nil);
  with TComboBox(fControl) do begin
    Style := csDropDownList;
    OnChange := OnChangeProc;
    OnExit := OnExitProc;
  end;
end;

procedure TTemplateCtrlComboList.LoadProc(XmlNode: TXmlNode);
var
  i: integer;
  ItemsNode, Node: TXmlNode;
  cap, val: RawUtf8;
begin
  ItemsNode:=XmlNode.NodeByName('items');
  if ItemsNode=nil then exit;
  for i:=0 to ItemsNode.Count-1 do with ItemsNode[i] do
    if Name='item' then
    begin
      cap := '';
      val := '';
      Node := NodeByName('caption', true, Iso639LangName);
      if Assigned(Node) then
        cap := Node.Content;
      Node := NodeByName('value');
      if Assigned(Node) then
        val := Node.Content;
      if cap = '' then cap := val;
      TComboBox(fControl).Items.AddObject(cap, Pointer(StrNew(PChar(val))));
    end;
end;

procedure TTemplateCtrlComboList.EventProc(Attribute: TLdapAttribute; Event: TEventType);
begin
  with (fControl as TComboBox), fTemplateAttribute do
  if (Event = etChange) and (ValuesCount > 0) then
  begin
    Text := FormatValue(Values[0].AsString, Attribute.Entry);
    OnChange(fControl);
    OnExit(fControl);
  end;
end;

{ TTemplateCtrlComboList }

constructor TTemplateCtrlComboLookupList.Create(Attribute: TTemplateAttribute);
begin
  inherited;
  fScope := lssWholeSubtree;
end;

procedure TTemplateCtrlComboLookupList.LoadProc(XmlNode: TXmlNode);
var
  i: Integer;
begin
  for i:=0 to XmlNode.Count-1 do with XmlNode[i] do
    if Name = 'filter' then
      fSearchFilter := Content
    else
    if Name = 'base' then
      fBase := Content
    else
    if Name = 'displayattribute' then
      fDisplayAttribute := Content
    else
    if Name = 'valueattribute' then
      fValueAttribute := Content
    else
    if Name = 'scope' then
    begin
      if Content = 'base' then
        fScope := lssBaseObject
      else
      if Content = 'one' then
        fScope := lssSingleLevel
      else
      if Content = 'sub' then
        fScope := lssWholeSubtree;
    end
    else
    if Name = 'sorted' then
      TComboBox(fControl).Sorted := true;
end;

procedure TTemplateCtrlComboLookupList.SetLdapAttribute(Attribute: TLdapAttribute);
var
  EntryList: TLdapEntryList;
  i: Integer;
  val, cap: RawUtf8;
begin
  inherited;

  if not Assigned(LdapSession) then Exit;

  if fSearchFilter = '' then
    fSearchFilter := sANYCLASS;
  if fBase = '' then
    fBase := LdapSession.Base;
  EntryList := TLdapEntryList.Create;
  try
    LdapSession.Search(fSearchFilter, fBase, fScope, [fDisplayAttribute, fValueAttribute], False, EntryList);
    for i := 0 to EntryList.Count - 1 do with EntryList[i] do
    try
      if fDisplayAttribute <> '' then
        cap := AttributesByName[fDisplayAttribute].AsString
      else
        cap := dn;
      if CompareText(fValueAttribute, fDisplayAttribute) = 0 then
        val := cap
      else
        if fValueAttribute <> '' then
          val := AttributesByName[fValueAttribute].AsString
        else
          val := dn;
      TComboBox(fControl).Items.AddObject(cap, Pointer(StrNew(PChar(val))));
    except end;
    Read;
  finally
    EntryList.Free;
  end;
end;

{ TTemplateCtrlImage }

procedure TTemplateCtrlImage.SetValue(AValue: TTemplateAttributeValue);
var
  ji: TJpegImage;
begin
  with fControl as TImage do begin
   //TODO delete
   ji := Picture.Graphic as TJPEGImage;
   if not Assigned(ji) then
     ji := TJpegImage.Create;
   StreamCopy(AValue.SaveToStream, ji.LoadFromStream);
   Picture.Graphic := ji;
  end;
  Write;
end;

constructor TTemplateCtrlImage.Create(Attribute: TTemplateAttribute);
begin
  inherited;
  fControl := TImage.Create(nil);
end;

procedure TTemplateCtrlImage.Read;
var
  ji: TJpegImage;
begin
  if Assigned(fControl) and Assigned(fLdapValue) and (fLdapValue.DataSize > 0) then with (fControl as TImage) do
  begin
   ji := Picture.Graphic as TJPEGImage;
   if not Assigned(ji) then
     ji := TJpegImage.Create;
   StreamCopy(fLdapValue.SaveToStream, ji.LoadFromStream);
   Picture.Graphic := ji;
  end;
end;

procedure TTemplateCtrlImage.Write;
begin
  if Assigned(fControl) and Assigned(fLdapValue) then with (fControl as TImage) do
    if Assigned(Picture.Graphic) then
     StreamCopy(Picture.Graphic.SaveToStream, fLdapValue.LoadFromStream);
end;

procedure TTemplateCtrlImage.LoadProc(XmlNode: TXmlNode);
begin

end;

procedure TTemplateCtrlImage.EventProc(Attribute: TLdapAttribute; Event: TEventType);
begin

end;

{ TEditGrid }

procedure TEditGrid.TabMove;
var
  r, c, d: Integer;
  KeyState: TKeyboardState;
begin
  ///GetKeyboardState(KeyState);
  if KeyState[VK_SHIFT] and $80 <> 0 then
    d := -1
  else
    d := 1;
  r := Row;
  c := Col;
  c := c + d;
  if c > ColCount - 1 then
  begin
    c := 0;
    r := r + d;
  end
  else
  if c < 0 then
  begin
    c := ColCount - 1;
    r := r + d;
  end;
  if r > RowCount - 1 then
  begin
   if Cells[ColCount - 1, RowCount - 1] <> '' then
      RowCount := r + 1
    else
      r := 0
  end
  else
  if r < 0 then
    r := RowCount - 1;
  Col := c;
  Row := r;
end;

procedure TEditGrid.SubClassWndProc(var Message: TMessage);
begin
  with Message do
  case Msg of
    CM_CHILDKEY:
      if WParam = 13 then
        TabMove;
  else
    WndProc(Message);
  end;
end;

procedure TEditGrid.Resize;
begin
  inherited;
  DefaultColWidth := ClientWidth;
end;

constructor TEditGrid.Create(AOwner: TComponent);
begin
  inherited;
  WindowProc := SubClassWndProc;
  FixedCols := 0;
  FixedRows := 0;
  ColCount := 1;
  RowCount := 5;
  DefaultRowHeight := 18;
  Options := Options + [goEditing, goAlwaysShowEditor];
end;

{ TTemplateCtrlGrid }

procedure TTemplateCtrlGrid.MyExitProc(Sender: TObject);
begin
  OnChangeProc(Sender);
  OnExitProc(sender);
end;

procedure TTemplateCtrlGrid.SetValue(AValue: TTemplateAttributeValue);
var
  i, j: Integer;
begin
  with (Control as TStringGrid) do
  begin
    i := RowCount;
    while i > 0 do
    begin
      if Cells[0, i - 1] <> '' then
        break;
      dec(i);
    end;

    for j := 0 to i - 1 do
      if AnsiCompareText(Cells[0, j], AValue.AsString) = 0 then
        exit;

    if i = RowCount then
      RowCount := RowCount + 1;
    Cells[0, i] := AValue.AsString;
  end;
  OnChangeProc(Self);
end;

procedure TTemplateCtrlGrid.Read;
var
  i: Integer;
begin
  if Assigned(fControl) then with Control as TStringGrid do
  begin
    for i := 0 to RowCount - 1 do Rows[i].Clear;
    if Assigned(fLdapAttribute) then with fLdapAttribute do
    begin
      if RowCount < ValueCount then
        RowCount := ValueCount;
      for i := 0 to ValueCount - 1 do
        Cells[0, i] := Values[i].AsString;
    end;
  end;
end;

procedure TTemplateCtrlGrid.Write;
var
  i: Integer;
begin
  if Assigned(fControl) and Assigned(fLdapAttribute) then with Control as TStringGrid do
  begin
    for i := 0 to RowCount - 1 do
    begin
      if i = fLdapAttribute.ValueCount then
        fLdapAttribute.AddValue;
      fLdapAttribute.Values[i].AsString := Cells[0, i];
    end;
  end;
end;

procedure TTemplateCtrlGrid.LoadProc(XmlNode: TXmlNode);
var
  Node: TXmlNode;
begin
  if not fAutoSizeY then Exit;
  Node:=XmlNode.NodeByName('rows');
  if Assigned(Node) then with TEditGrid(fControl) do
  begin
    RowCount := CheckStrToInt(Node.Content, Node.Name);
    Height := RowCount * (DefaultRowHeight + GridLineWidth) + DefaultRowHeight div 2;
  end;
end;

procedure TTemplateCtrlGrid.EventProc(Attribute: TLdapAttribute; Event: TEventType);
var
  i: Integer;
  s: RawUtf8;
begin
  with (fControl as TEditGrid), fTemplateAttribute do
  if (Event = etChange) and (ValuesCount > 0) then
  begin
    if RowCount < ValuesCount then
      RowCount := ValuesCount;
    for i := 0 to ValuesCount -  1 do
    begin
      s := FormatValue(Values[i].AsString, Attribute.Entry);
      if s <> Cells[0, i] then
        Cells[0, i] := s;
    end;
    Write;
  end;
end;

constructor TTemplateCtrlGrid.Create(Attribute: TTemplateAttribute);
begin
  inherited;
  fControl := TEditGrid.Create(nil);
  TEditGrid(fControl).OnExit := MyExitProc;
end;

{ TTemplateCtrlButton }

procedure TTemplateCtrlButton.SetValue(AValue: TTemplateAttributeValue);
begin
end;

procedure TTemplateCtrlButton.Read;
begin
end;

procedure TTemplateCtrlButton.Write;
begin
end;

procedure TTemplateCtrlButton.LoadProc(XmlNode: TXmlNode);
begin
  if fCaption <> '' then TButton(fControl).Caption := fCaption;
end;

procedure TTemplateCtrlButton.EventProc(Attribute: TLdapAttribute; Event: TEventType);
begin
end;

constructor TTemplateCtrlButton.Create(Attribute: TTemplateAttribute);
begin
  inherited;
  fControl := TButton.Create(nil);
end;

{ TTemplateCtrlPasswordButton }

procedure TTemplateCtrlPasswordButton.ButtonClick(Sender: TObject);
var
  Entry: TLdapEntry;
begin
  if Assigned(fLdapAttribute) then
  begin
    Entry := fLdapAttribute.Entry;
    if Assigned(Entry) and Assigned(Entry.Session) then
      (Entry.Session as TConnection).DI.ChangePassword(Entry);
  end;
end;

constructor TTemplateCtrlPasswordButton.Create(Attribute: TTemplateAttribute);
begin
  inherited;
  with TButton(fControl) do begin
    OnExit := OnExitProc;
    OnClick := ButtonClick;
    Caption := cSetPassword;
  end;
end;

{ TTemplateCtrlTextArea }

procedure TTemplateCtrlTextArea.SetValue(AValue: TTemplateAttributeValue);
begin
  (Control as TMemo).Text := AValue.AsString;
end;

procedure TTemplateCtrlTextArea.Read;
begin
  if Assigned(fControl) and Assigned(fLdapValue) then
    (fControl as TMemo).Text := fLdapValue.AsString;
end;

procedure TTemplateCtrlTextArea.Write;
begin
  if Assigned(fControl) and Assigned(fLdapValue) then
    fLdapValue.AsString := (fControl as TMemo).Text;
end;

procedure TTemplateCtrlTextArea.LoadProc(XmlNode: TXmlNode);
begin

end;

procedure TTemplateCtrlTextArea.EventProc(Attribute: TLdapAttribute; Event: TEventType);
begin
  with (fControl as Tmemo), fTemplateAttribute do
  if (Event = etChange) and not Modified and (ValuesCount > 0) then
    Text := FormatValue(Values[0].AsString, Attribute.Entry);
end;

constructor TTemplateCtrlTextArea.Create(Attribute: TTemplateAttribute);
begin
  inherited;
  fControl := TMemo.Create(nil);
  with TMemo(fControl) do begin
    Scrollbars := ssVertical;
    OnChange := OnChangeProc;
    OnExit := OnExitProc;
  end;
end;

{ TTemplateCtrlCheckBox }

function TTemplateCtrlCheckBox.GetCbState(const AState: RawUtf8): TCheckBoxState;
var
  s: RawUtf8;
begin
  s := AState;
  if s = fTrue then
    Result := cbChecked
  else
  if fMultivalue or (s = fFalse) then
    Result := cbUnChecked
  else
    Result := cbGrayed;
end;

procedure TTemplateCtrlCheckBox.SetValue(AValue: TTemplateAttributeValue);
begin
  (Control as TCheckBox).State := GetCbState(AValue.AsString);
  Write; // explicit call to write since TCheckbox has no OnChange event
end;

procedure TTemplateCtrlCheckBox.Read;

  function GetValue: RawUtf8;
  var
    i: Integer;
  begin
    if fMultivalue and Assigned(fLdapValue.Attribute) then
    begin
      Result := '';
      if (fLdapValue.DataSize = 0) and (fLdapValue.ModOp = LdapOpAdd) then // disable value added by constructor
        fLdapValue.ModOp := LdapOpNoop;
      i := fLdapValue.Attribute.IndexOf(fTrue);
      if i <> -1 then
        Result := fLdapValue.Attribute.Values[i].AsString;
    end
    else
      Result := fLdapValue.AsString;
  end;

begin
  if Assigned(fControl) and Assigned(fLdapValue) then
    (Control as TCheckBox).State := GetCbState(GetValue);
end;

procedure TTemplateCtrlCheckBox.Write;

  procedure SetValue(State: TCheckboxState);
  var
    i: Integer;
  begin
    if fMultivalue and Assigned(fLdapValue.Attribute) then
    begin
      i := fLdapValue.Attribute.IndexOf(fTrue);
      case State of
        cbChecked:   if i = -1 then fLdapValue.Attribute.AddValue(fTrue);
        cbUnchecked: if i <> -1 then fLdapValue.Attribute.DeleteValue(fTrue);
      end;
    end
    else
      case State of
        cbChecked: fLdapValue.AsString := fTrue;
        cbUnchecked: fLdapValue.AsString := fFalse;
      end;
  end;

begin
  if Assigned(fControl) and Assigned(fLdapValue) then
    SetValue((Control as TCheckBox).State);
end;

procedure TTemplateCtrlCheckBox.LoadProc(XmlNode: TXmlNode);
var
  i: Integer;
begin
  if fCaption <> '' then
    TCheckBox(fControl).Caption := fCaption;
  for i:=0 to XmlNode.Count-1 do with XmlNode[i] do begin
    if Name = 'true' then
      fTrue := Content
    else
    if Name = 'false' then
      fFalse := Content
    else
    if Name = 'value' then
    begin
      fTrue := Content;
      fMultivalue := true;
    end;
  end;
end;

procedure TTemplateCtrlCheckBox.EventProc(Attribute: TLdapAttribute; Event: TEventType);
begin

end;

constructor TTemplateCtrlCheckBox.Create(Attribute: TTemplateAttribute);
begin
  inherited;
  fControl := TCheckBox.Create(nil);
  with TCheckBox(fControl) do begin
    if Assigned(TemplateAttribute) then
      if TemplateAttribute.Description <> '' then
        Caption := TemplateAttribute.Description
      else
      if fMultivalue then
        Caption := fTrue
      else
        Caption := TemplateAttribute.Name;
    OnClick := OnChangeProc;
  end;
  fTrue := 'yes';
  fFalse := 'no';
end;

{ TTemplateCtrlPanel }

procedure TTemplateCtrlPanel.SetValue(AValue: TTemplateAttributeValue);
begin

end;

procedure TTemplateCtrlPanel.Read;
begin

end;

procedure TTemplateCtrlPanel.Write;
begin

end;

procedure TTemplateCtrlPanel.LoadProc(XmlNode: TXmlNode);
var
  Node: TXmlNode;
begin
  Node := XmlNode.NodeByName('bevel');
  if not Assigned(Node) then exit;
  with Node, TPanel(fControl) do
  if Content = 'raised' then
  begin
    BevelInner := bvRaised;
    BevelOuter := bvNone;
  end
  else
  if Content = 'lowered' then
  begin
    BevelInner := bvNone;
    BevelOuter := bvLowered;
  end
  else
  if Content = 'frame' then
  begin
    BevelInner := bvRaised;
    BevelOuter := bvLowered;
  end
  else
  if Content = 'none' then
  begin
    BevelInner := bvNone;
    BevelOuter := bvNone;
  end;
end;

procedure TTemplateCtrlPanel.EventProc(Attribute: TLdapAttribute; Event: TEventType);
begin

end;

constructor TTemplateCtrlPanel.Create(Attribute: TTemplateAttribute);
begin
  inherited;
  fControl := TPanel.Create(nil);
end;

{ TTemplateCtrlTabSheet }

procedure TTemplateCtrlTabSheet.SetValue(AValue: TTemplateAttributeValue);
begin

end;

procedure TTemplateCtrlTabSheet.Read;
begin

end;

procedure TTemplateCtrlTabSheet.Write;
begin

end;

procedure TTemplateCtrlTabSheet.LoadProc(XmlNode: TXmlNode);
begin
  TTabSheet(Control).Caption := fCaption;
  fCaption := '';
end;

constructor TTemplateCtrlTabSheet.Create(Attribute: TTemplateAttribute);
begin
  inherited;
  fControl := TTabSheet.Create(nil);
end;

procedure TTemplateCtrlTabSheet.EventProc(Attribute: TLdapAttribute; Event: TEventType);
begin

end;

{ TTemplateCtrlTabbedPanel }

procedure TTemplateCtrlTabbedPanel.SetValue(AValue: TTemplateAttributeValue);
begin

end;

procedure TTemplateCtrlTabbedPanel.Read;
begin

end;

procedure TTemplateCtrlTabbedPanel.Write;
begin

end;

procedure TTemplateCtrlTabbedPanel.LoadProc(XmlNode: TXmlNode);
var
  TabSheet: TTemplateCtrlTabSheet;
  i: Integer;
begin
  for i:=0 to XmlNode.Count-1 do with XmlNode[i] do
  begin
    if Name = 'tab' then
    begin
      TabSheet := TTemplateCtrlTabSheet.Create(nil);

      ///TabSheet.ParentControl := Self;
      //TTabSheet(TabSheet).Parent := TPageControl(fControl);
      TabSheet.fControl.Parent := TWinControl(fControl);
      TabSheet.Load(XmlNode[i]);
      TTabSheet(TabSheet.Control).PageControl := TPageControl(fControl);
      fElements.Add(TabSheet);
    end;
  end;
  { Reset to first page }
  with TPageControl(fControl) do
  begin
    ActivePage := nil;
    ActivePageIndex := 0;
  end;
end;

procedure TTemplateCtrlTabbedPanel.EventProc(Attribute: TLdapAttribute; Event: TEventType);
begin

end;

constructor TTemplateCtrlTabbedPanel.Create(Attribute: TTemplateAttribute);
begin
  inherited;
  fControl := TPageControl.Create(nil);
end;

destructor TTemplateCtrlTabbedPanel.Destroy;
begin
  Control.Visible := false;
  Control.Parent := Application.MainForm;
  inherited;
end;

procedure TTemplateCtrlTabbedPanel.ArrangeControls;
var
  i, MaxHeight, TabHeight: Integer;
begin
  if TPageControl(Control).PageCount = 0 then Exit;
  MaxHeight := TPageControl(Control).Pages[0].Height;
  TabHeight := Control.Height - MaxHeight;
  for i := Elements.Count - 1 downto 0 do if Elements[i] is TTemplateControl then
  with TTemplateControl(Elements[i]) do
  begin
    ParentControl := nil;  { allow tabsheets to resize } 
    ArrangeControls;
    if Control.Height > MaxHeight then
      MaxHeight := Control.Height;
    ParentControl := Self;
  end;
  Control.Height := MaxHeight + TabHeight;
end;

{ TDateTimePickerFixed }

{$IFDEF TDATETIME_FIX}
{$IFDEF VER130}
procedure TDateTimePickerFixed.SetFormat(Value: RawUtf8);
begin
  fFormat := Value;
  ///DateTime_SetFormat(Handle, PChar(fFormat));
end;
{$ENDIF}

procedure TDateTimePickerFixed.CNNotify(var Message: TWMNotify);
begin
{
  if Message.NmHdr^.Code = DTN_DATETIMECHANGE then
  try
    fChanging := true;
    inherited;
  finally
    fChanging := false;
  end;
}
end;

function TDateTimePickerFixed.MsgSetDateTime(Value: TSystemTime): Boolean;
begin
  Result := true;
  if Checked and not fChanging then
  begin
    ///Result := inherited MsgSetDateTime(Value);
    {$IFDEF VER130}
    if Result and (fFormat <> '') then
      ///DateTime_SetFormat(Handle, PChar(fFormat));
    {$ENDIF}
  end;
end;
{$ENDIF}

{ TTemplateCtrlDate }

function TTemplateCtrlDate.GetTime(Value: RawUtf8): TDateTime;

  function ConvertVariant(const Value: RawUtf8): TDateTime;
  var
    aValue: RawUtf8;
  begin
    try
      Result := StrToDateTime(Value);
    except
      on E: EVariantError do
        { try some common variants }
        if Length(Value) = 8 then
        begin
          aValue := Value;
          Insert('-', AValue, 7);
          Insert('-', AValue, 5);
          Result := StrToDateTime(Value);
        end
        else raise;
    end;
  end;

begin
  if Value = '' then
    Result := 0
  else
  if (fDateFormat = FMT_DATE_TIME_UNIX) or (fTimeFormat = FMT_DATE_TIME_UNIX) then
    Result := UnixTimeToDateTime(StrToInt64(Value))
  else
  if (fDateFormat = FMT_DATE_TIME_GTZ) or (fTimeFormat = FMT_DATE_TIME_GTZ) then
    Result := GTZToDateTime(Value)
  else
    Result := ConvertVariant(Value);
end;

function TTemplateCtrlDate.GetDisplayFormat: RawUtf8;
begin
  //Result := TDateTimePickerFixed(fControl).Format;
end;

procedure TTemplateCtrlDate.SetDisplayFormat(Value: RawUtf8);
begin
  ///TDateTimePickerFixed(fControl).Format := Value;
end;

function TTemplateCtrlDate.GetTimeString: RawUtf8;
var
  ldapTime: TDateTime;
  t: RawUtf8;

  function GetDateOrTime(DateTime: TDateTime; DataFormat: RawUtf8; Kind: TDateTimeKind): RawUtf8;
  {$ifdef mswindows}
  var
    Buffer: array [0..256] of byte;
    flags: ULONG;
    p: PChar;
    st: SystemTime;
  begin
    flags := 0;
    p := nil;
    if DataFormat = '' then
      ///flags := LOCALE_NOUSEROVERRIDE
    else
      p := PChar(DataFormat);
    DateTimeToSystemTime(DateTime, st);
    case Kind of
      dtkDate: GetDateFormat(LOCALE_SYSTEM_DEFAULT, flags, @st, p, @Buffer, 256);
      dtkTime: GetTimeFormat(LOCALE_SYSTEM_DEFAULT, flags, @st, p, @Buffer, 256);
    end;
    Result := PChar(@Buffer);
    {$else}
  begin
    case Kind of
      dtkDate: Result:=FormatDateTime('d.m.yyyy',DateTime);
      dtkTime: Result:=FormatDateTime('hh:nn',DateTime);
    end;
    {$endif}
  end;

begin
  Result := '';
  with (Control as TDateTimePicker) do
  begin
    try
      ldapTime := GetTime(fLdapValue.AsString);
    except
      ldapTime := 0;
    end;
    if Checked then
    begin
      if (fDateFormat = FMT_DATE_TIME_UNIX) or (fTimeFormat = FMT_DATE_TIME_UNIX) then
      begin
        case Kind of
          dtkDate: Result := IntToStr(DateTimeToUnixTime(Trunc(DateTime) + Frac(ldapTime)));
          dtkTime: Result := IntToStr(DateTimeToUnixTime(Frac(DateTime) + Max(Trunc(ldapTime), 25569)));
        end;
      end
      else
      if (fDateFormat = FMT_DATE_TIME_GTZ) or (fTimeFormat = FMT_DATE_TIME_GTZ) then
      begin
        case Kind of
          dtkDate: Result := GetDateOrTime(Trunc(DateTime), 'yyyyMMdd', dtkDate) +
                             GetDateOrTime(Frac(ldapTime), 'HHmmssZ', dtkTime);
          dtkTime: Result := GetDateOrTime(Trunc(ldapTime), 'yyyyMMdd', dtkDate) +
                             GetDateOrTime(Frac(DateTime), 'HHmmssZ', dtkTime);
        end;
      end
      else
      begin
        case Kind of
          dtkDate: begin
                     Result := GetDateOrTime(Date, fDateFormat, dtkDate);
                     if Frac(ldapTime) <> 0 then
                     begin
                       if Result <> '' then Result := Result + ' ';
                       Result := Result + GetDateOrTime(ldapTime, fTimeFormat, dtkTime);
                     end;
                   end;
          dtkTime: begin
                     if Trunc(ldapTime) <> 0 then Result := GetDateOrTime(ldapTime, fDateFormat, dtkDate);
                     t := GetDateOrTime(Time, fTimeFormat, dtkTime);
                     if (Result <> '') and (t <> '') then Result := Result + ' ';
                     Result := Result + t;
                   end;
        end;
      end;
    end
    else // not Checked
      if (fDateFormat = FMT_DATE_TIME_UNIX) or (fTimeFormat = FMT_DATE_TIME_UNIX) then
      begin
        case Kind of
          dtkDate: if Frac(ldapTime) <> 0 then
                     Result := IntToStr(DateTimeToUnixTime(25569.0 + Frac(ldapTime)));
          dtkTime: if Trunc(DateTime) <> 0 then
                     Result := IntToStr(DateTimeToUnixTime(Trunc(DateTime)));
        end;
      end
      else
      if (fDateFormat = FMT_DATE_TIME_GTZ) or (fTimeFormat = FMT_DATE_TIME_GTZ) then
      begin
        case Kind of
          dtkDate: if Frac(ldapTime) <> 0 then
                     Result := GetDateOrTime(0, 'yyyyMMdd', dtkDate) +
                               GetDateOrTime(Frac(ldapTime), 'HHmmssZ', dtkTime);
          dtkTime: if Trunc(ldapTime) <> 0 then
                     Result := GetDateOrTime(Trunc(ldapTime), 'yyyyMMdd', dtkDate) +
                               GetDateOrTime(0, 'HHmmssZ', dtkTime);
        end;
      end
      else
      case Kind of
        dtkDate: if Frac(ldapTime) <> 0 then Result := GetDateOrTime(ldapTime, fTimeFormat, dtkTime);
        dtkTime: if Trunc(ldapTime) <> 0 then Result := GetDateOrTime(ldapTime, fDateFormat, dtkDate);
      end;
  end;
end;

procedure TTemplateCtrlDate.SetTimeString(Value: RawUtf8);

  procedure Err;
  var
    s: RawUtf8;
  begin
    with (Control as TDateTimePicker) do begin
      case Kind of
        dtkDate: s := stDateFormat;
        dtkTime: s := stTimeFormat;
      end;
      Checked := false;
    end;
    MessageDlg(Format(stIdentIsnotValid, [Value, s]), mtError, [mbOk], 0);
  end;

begin
  with (Control as TDateTimePicker) do
  if Value = '' then
    Checked := false
  else
  try
    DateTime := GetTime(Value);
      case Kind of
        dtkDate: if Trunc(Date) = 0 then Checked := false;
        dtkTime: if Frac(Time) = 0 then Checked := false;
      end;
    except
      on EConvertError do Err;
      on EVariantError do Err;
      else raise;
    end;
end;

procedure TTemplateCtrlDate.SetValue(AValue: TTemplateAttributeValue);
begin
  AsString := AValue.AsString;
end;

procedure TTemplateCtrlDate.Read;
begin
  if Assigned(fLdapValue) then
    AsString := fLdapValue.AsString;
end;

procedure TTemplateCtrlDate.Write;
begin
  if Assigned(fControl) and Assigned(fLdapValue) then
    fLdapValue.AsString := AsString;
end;

procedure TTemplateCtrlDate.LoadProc(XmlNode: TXmlNode);
var
  i: Integer;
begin
  for i := 0 to XmlNode.Count - 1 do with XmlNode[i] do
    if Name = 'displayformat' then
      DisplayFormat := Content
    else
    if Name = 'dateformat' then
      DateFormat := Content
    else
    if Name = 'timeformat' then
      TimeFormat := Content;
end;

procedure TTemplateCtrlDate.EventProc(Attribute: TLdapAttribute; Event: TEventType);
begin
  with (fControl as TDateTimePicker), fTemplateAttribute do
  if Checked and (Event = etChange) and {***not Modified and} (ValuesCount > 0) then
    AsString := fLdapValue.AsString;
end;

constructor TTemplateCtrlDate.Create(Attribute: TTemplateAttribute);
begin
  inherited;
  fControl := TDateTimePickerFixed.Create(nil);
  with TDateTimePicker(fControl) do begin
    ShowCheckBox := true;
    OnChange := OnChangeProc;
    OnExit := OnExitProc;
  end;
end;

{ TTemplateCtrlTime }

constructor TTemplateCtrlTime.Create(Attribute: TTemplateAttribute);
begin
  inherited;
  TDateTimePicker(fControl).Kind := dtkTime;
end;

{ TTemplateCtrlDateTime }

procedure TTemplateCtrlDateTime.MyOnChangeProc(Sender: TObject);
begin
  if Sender = fDate then
    TDateTimePicker(fTime.Control).Checked := TDateTimePicker(fDate.Control).Checked
  else
    TDateTimePicker(fDate.Control).Checked := TDateTimePicker(fTime.Control).Checked;
  OnChangeProc(Sender);
end;

procedure TTemplateCtrlDateTime.MyOnResizeProc(Sender: TObject);
begin
  if fVertical then
  begin
    fDate.Control.Width := Control.ClientWidth - CT_LEFT_BORDER - CT_RIGHT_BORDER;
    fTime.Control.Width := fDate.Control.Width;
  end
  else begin
    fDate.Control.Width := (Control.ClientWidth  - CT_LEFT_BORDER - CT_RIGHT_BORDER - CT_SPACING) div 2;
    fTime.Control.Left := CT_LEFT_BORDER + fDate.Control.Width + CT_SPACING;
    ftime.Control.Width := fDate.Control.Width;
  end;
end;

procedure TTemplateCtrlDateTime.SetVertical(Value: Boolean);
begin
  fVertical := Value;
  if fVertical then
  begin
    fTime.Control.Left := CT_LEFT_BORDER;
    fTime.Control.Top := fDate.Control.Top + fDate.Control.Height + 4;
  end
  else begin
    fTime.Control.Top := CT_FIX_TOP;
  end;
  fControl.Height := fTime.Control.Top + fTime.Control.Height + CT_SPACING;
end;

procedure TTemplateCtrlDateTime.SetValue(AValue: TTemplateAttributeValue);
begin
  fDate.AsString := AValue.AsString;
  fTime.AsString := AValue.AsString;
end;

procedure TTemplateCtrlDateTime.Read;
begin
  fDate.Read;
  fTime.Read;
end;

procedure TTemplateCtrlDateTime.Write;
begin
  if not (TDateTimePicker(fDate.Control).Checked or TDateTimePicker(fTime.Control).Checked) then
    fLdapValue.AsString := ''
  else begin
    fDate.Write;
    fTime.Write;
  end;
end;

procedure TTemplateCtrlDateTime.LoadProc(XmlNode: TXmlNode);
var
  Node: TXmlNode;
begin
  inherited;
  Node := XmlNode.NodeByName('orientation');
  if Assigned(Node) then
    Vertical := Node.Content = 'vertical';
  fDate.LoadProc(XmlNode);
  fTime.LoadProc(XmlNode);
end;

procedure TTemplateCtrlDateTime.SetLdapAttribute(Attribute: TLdapAttribute);
begin
  inherited;
  fDate.LdapAttribute := Attribute;
  fTime.LdapAttribute := Attribute;
end;

procedure TTemplateCtrlDateTime.EventProc(Attribute: TLdapAttribute; Event: TEventType);
begin
  fDate.EventProc(Attribute, Event);
  ftime.EventProc(Attribute, Event);
end;

constructor TTemplateCtrlDateTime.Create(Attribute: TTemplateAttribute);
begin
  inherited;

  TPanel(fControl).OnResize := MyOnResizeProc;
  TPanel(fControl).BevelInner := bvRaised;
  TPanel(fControl).BevelOuter := bvNone;

  fDate := TTemplateCtrlDate.Create(Attribute);
  fDate.OnChange := MyOnChangeProc;
  fDate.ParentControl := Self;
  fDate.Control.Parent := TPanel(Control);
  fDate.Control.Name := 'date';

  fTime := TTemplateCtrltime.Create(Attribute);
  fTime.OnChange := MyOnChangeProc;
  fTime.ParentControl := Self;
  fTime.Control.Parent := TPanel(Control);
  fTime.Control.Name := 'time';

  fDate.Control.Left := CT_LEFT_BORDER;
  fDate.Control.Top := CT_FIX_TOP;
  fTime.Control.Top := CT_FIX_TOP;
  fControl.Height := fTime.Control.Top + fTime.Control.Height + CT_SPACING;
end;

{ TTemplateCtrlPickupDlg }

procedure TTemplateCtrlPickupDlg.ButtonClick(Sender: TObject);
var
  i, j: Integer;
  Value: TTemplateAttributeValue;
  Attr: TLdapAttribute;
  s: RawUtf8;
begin
  if Assigned(LdapSession) then
  with TPickupDlg.Create(Sender as TControl) do
  try
    Caption := fCaption;
    for i := 0 to High(fColNames) do
      s := s + '"' + fColNames[i] + '"' + ',';
    ColumnNames := s;
    Populate(LdapSession, fFilter, fColumns, fBase);
    if (ShowModal = mrOK) and Assigned(fDataControl) then
    begin
      Value := TTemplateAttributeValue.Create(nil);
      try
        Attr := nil;
        for i:=0 to SelCount-1 do
        begin
          if (fReturns = '') or (fReturns = PSEUDOATTR_DN) then
            Value.fValue := Selected[i].DN
          else
          if fReturns = PSEUDOATTR_RDN then
            Value.fValue := GetRdnFromDn(Selected[i].DN)
          else
          if fReturns = PSEUDOATTR_PATH then
            Value.fValue := CanonicalName(GetDirFromDn(Selected[i].DN))
          else
            Attr := Selected[i].AttributesByName[fReturns];
            
          if Assigned(Attr) then
          begin
            for j := 0 to Attr.ValueCount - 1 do
            begin
              Value.fValue := Attr.Values[j].AsString;
              fDataControl.SetValue(Value);
            end;
          end
          else
            fDataControl.SetValue(Value);
        end;
      finally
        Value.Free;
      end;
    end;
  finally
    Free;
  end;
end;

procedure TTemplateCtrlPickupDlg.SetValue(AValue: TTemplateAttributeValue);
begin

end;

procedure TTemplateCtrlPickupDlg.Read;
begin

end;

procedure TTemplateCtrlPickupDlg.Write;
begin

end;

procedure TTemplateCtrlPickupDlg.LoadProc(XmlNode: TXmlNode);
var
  i: Integer;
  t: RawUtf8;

  procedure SetColumnValues(Node: TXmlNode);
  var
    N: TXmlNode;
  begin
    if not Assigned(Node) then Exit;
    SetLength(fColumns, Length(fColumns) + 1);
    SetLength(fColNames, Length(fColumns));
    N := Node.NodeByName('value');
    if Assigned(N) then
      fColumns[High(fColumns)] := N.Content;
    N := Node.NodeByName('caption', true, Iso639LangName);
    if Assigned(N) then
      fColNames[High(fColNames)] := N.Content;
  end;

begin
  if fCaption <> '' then TButton(fControl).Caption := fCaption;
  for i:=0 to XmlNode.Count-1 do with XmlNode[i] do
  begin
    if Name = 'returns' then
      fReturns := Content
    else
    if Name = 'filter' then
    begin
      t := Attributes.Values['type'];
      if t = 'custom' then
        fFilter := Content
      else
      if t = 'groups' then
        fFilter := sPosixGroups
      else
      if t = 'users' then
        fFilter := sUsers
      else
          raise Exception.CreateFmt('pickupdlg: ' + stInvalidFilter, [t]);
    end
    else
    if Name = 'column' then
      SetColumnValues(XmlNode[i])
    else
    if Name = 'base' then
      fBase := Content;
  end;
  if fReturns <> '' then
  begin
    SetLength(fColumns, Length(fColumns) + 1);
    fColumns[High(fColumns)] := fReturns;
  end;
  if High(fColumns) = -1 then
  begin
    SetLength(fColumns, 2);
    fColumns[0] := PSEUDOATTR_RDN;
    fColumns[1] := PSEUDOATTR_PATH;
    SetLength(fColNames, 2);
    fColNames[0] := 'Entry';
    fColNames[1] := 'Path';
  end;
end;

procedure TTemplateCtrlPickupDlg.EventProc(Attribute: TLdapAttribute; Event: TEventType);
begin

end;

constructor TTemplateCtrlPickupDlg.Create(Attribute: TTemplateAttribute);
begin
  inherited;
  fControl := TButton.Create(nil);
  with TButton(fControl) do begin
    OnExit := OnExitProc;
    OnClick := ButtonClick;
    Caption := cBrowse;
  end;
end;

{ TTemplateCtrlNumber }

procedure TTemplateCtrlNumber.Validate;
begin
  inherited;
  if TEdit(fControl).Text <> '' then
  try
    StrToFloat(TEdit(fControl).Text);
  except
    on E: EConvertError do begin
      if fControl is TWinControl then
        TWinControl(fControl).SetFocus;
      raise Exception.Create(Format(stIdentIsNotValid, [TEdit(fControl).Text, stNumber]));
    end;
  end;
end;

{ TTemplateCtrlInteger }

procedure TTemplateCtrlInteger.Validate;
begin
  inherited;
  if TEdit(fControl).Text <> '' then
  try
    StrToInt(TEdit(fControl).Text);
  except
    on E: EConvertError do begin
      if fControl is TWinControl then
       TWinControl(fControl).SetFocus;
      raise Exception.Create(Format(stIdentIsNotValid, [TEdit(fControl).Text, stInteger]));
    end;
  end;
end;

{ TTemplateCtrlLabel }

procedure TTemplateCtrlLabel.SetValue(AValue: TTemplateAttributeValue);
begin

end;

procedure TTemplateCtrlLabel.Read;
begin
  if not fFixedText and Assigned(fControl) and Assigned(fLdapValue) then
    (fControl as TLabel).Caption := fLdapValue.AsString;
end;

procedure TTemplateCtrlLabel.Write;
begin

end;

procedure TTemplateCtrlLabel.LoadProc(XmlNode: TXmlNode);
var
  Node: TXmlNode;
begin
  Node:=XmlNode.NodeByName('text');
  if Assigned(Node) then
  begin
    TLabel(fControl).Caption := Node.Content;
    fFixedText := true;
  end;
end;

procedure TTemplateCtrlLabel.EventProc(Attribute: TLdapAttribute; Event: TEventType);
begin
  if not fFixedText then // Control setting has priority over attribute setting
    with (fControl as TLabel), fTemplateAttribute do
      if Event = etChange then
        if ValuesCount > 0 then
          Caption := FormatValue(Values[0].AsString, Attribute.Entry);
end;

constructor TTemplateCtrlLabel.Create(Attribute: TTemplateAttribute);
begin
  inherited;
  fControl := TLabel.Create(nil);
end;

{ TTemplateCtrlList }

procedure TTemplateCtrlList.SetValue(AValue: TTemplateAttributeValue);
begin
  if (Control as TListBox).Items.IndexOf(AValue.AsString) = -1 then
  begin
    (Control as TListBox).Items.Add(AValue.AsString);
    OnChangeProc(Self);
  end;
end;

function TTemplateCtrlList.GetLineCount: Integer;
begin
  Result := TListBox(Control).Items.Count;
end;

function TTemplateCtrlList.GetLine(Index: Integer): RawUtf8;
begin
  Result := TListBox(Control).Items[Index];
end;

procedure TTemplateCtrlList.SetLine(Index: Integer; const Value: RawUtf8);
begin
  TListBox(Control).Items[Index] := Value;
  OnChangeProc(Control);
end;

procedure TTemplateCtrlList.Read;
var
  i: Integer;
begin
  if Assigned(fControl) then with Control as TListBox, Items do
  begin
    Clear;
    if Assigned(fLdapAttribute) then with fLdapAttribute do
    for i := 0 to ValueCount - 1 do
      if Values[i].AsString<> '' then Add(Values[i].AsString);
  end;
end;

procedure TTemplateCtrlList.Write;
var
  i: Integer;
begin
  if Assigned(fControl) and Assigned(fLdapAttribute) then with Control as TListBox do
  begin
    for i := 0 to fLdapAttribute.ValueCount - 1 do
      fLdapAttribute.Values[i].Delete;
    for i := 0 to Items.Count - 1 do
      fLdapAttribute.AddValue(Items[i]);
  end;
end;

function TTemplateCtrlList.GetItemIndex: Integer;
begin
  Result := TListBox(fControl).ItemIndex;
end;

procedure TTemplateCtrlList.SetItemIndex(const Value: Integer);
begin
  TListBox(Control).ItemIndex := Value;
end;

procedure TTemplateCtrlList.LoadProc(XmlNode: TXmlNode);
begin

end;

procedure TTemplateCtrlList.EventProc(Attribute: TLdapAttribute; Event: TEventType);
var
  i: Integer;
begin
  with (fControl as TListBox), fTemplateAttribute do
  if (Event = etChange) and (ValuesCount > 0) then
  begin
    Items.Clear;
    for i := 0 to ValuesCount -  1 do
      Items.Add(FormatValue(Values[i].AsString, Attribute.Entry));
    Write;
  end;
end;

constructor TTemplateCtrlList.Create(Attribute: TTemplateAttribute);
begin
  inherited;
  fControl := TListBox.Create(nil);
  TListBox(fControl).OnExit := OnExitProc;
end;

procedure TTemplateCtrlList.Add(const Value: RawUtf8);
begin
  TListBox(Control).Items.Add(Value);
  OnChangeProc(Control);
end;

procedure TTemplateCtrlList.Delete(Index: Integer);
begin
  TListBox(Control).Items.Delete(Index);
  OnChangeProc(Control);
end;

{ TTemplateCtrlListBox }

procedure TTemplateCtrlListBox.MyOnButtonProc(Sender: TObject);
var
  Enabled: boolean;
begin
  Enabled := fList.ItemIndex <> -1;
  if Assigned(fEditBtn) then
    fEditBtn.Enabled := Enabled;
  if Assigned(fDeleteBtn) then
    fDeleteBtn.Enabled := Enabled;
end;

procedure TTemplateCtrlListBox.MyOnResizeProc(Sender: TObject);
begin
  ArrangeBox;
  ArrangeButtons;
end;

procedure TTemplateCtrlListBox.ActAdd(Sender: TObject);
var
  s: String;
begin
  if InputQuery(cAddValue, cValue + ':', s) and (s <> '') then
  begin
    fList.Add(s);
    MyOnButtonProc(Sender);
  end;
end;

procedure TTemplateCtrlListBox.ActDelete(Sender: TObject);
var
  idx: Integer;
begin
  with fList do
  if ItemIndex <> -1 then
  begin
    idx := ItemIndex;
    Delete(idx);
    if idx < LineCount then
      ItemIndex := idx
    else
      ItemIndex := LineCount - 1;
    MyOnButtonProc(Sender);
  end;
end;

procedure TTemplateCtrlListBox.ActEdit(Sender: TObject);
var
  s: String;
begin
  with fList do
  begin
    s := Lines[ItemIndex];
    if InputQuery(cEditValue, cValue + ':', s) then
      Lines[ItemIndex] := s;
  end;
end;

procedure TTemplateCtrlListBox.ArrangeBox;
begin
  if fVertical then
  begin
    if fLeft then
      fList.Control.Left := fMaxBtnWidth + fMargin + CT_SPACING
    else
      fList.Control.Left := fMargin;
    fList.Control.Height := fControl.Height - 2 * fMargin;
    fList.Control.Width := fControl.Width - fMaxBtnWidth - 2 * fMargin - CT_SPACING;
  end
  else begin
    fList.Control.Left := fMargin;
    fList.Control.Height := fControl.Height - fMaxBtnHeight - 2 * fMargin - CT_SPACING;
    fList.Control.Width := fControl.Width - 2 * fMargin;
  end;
end;

procedure TTemplateCtrlListBox.ArrangeButtons;
var
  i: Integer;
  vpos, hpos: Integer;
begin
  if Left then
    hpos := fMargin
  else
    hpos := fControl.Width - fMargin;
  if fVertical then
  begin
    vpos := fMargin;
    with TPanel(fControl) do
    for i := 0 to ControlCount - 1 do
      if Controls[i] is TButton then with TButton(Controls[i]) do
      begin
        Top := vpos;
        if fLeft then
          Left := hpos
        else
          Left := hPos - Width;
        inc(vpos, CT_SPACING + Height);
      end;
  end
  else begin
    vpos := fList.Control.Top + fList.Control.Height + CT_SPACING;
    with TPanel(fControl) do
    if fLeft then
    begin
      for i := 0 to ControlCount - 1 do
        if Controls[i] is TButton then with TButton(Controls[i]) do
        begin
          Top := vpos;
          Left := hpos;
          inc(hpos, CT_SPACING + Width);
        end;
    end
    else
      for i := ControlCount - 1 downto 0 do
        if Controls[i] is TButton then with TButton(Controls[i]) do
        begin
          Top := vpos;
          Left := hpos - Width;
          dec(hpos, CT_SPACING + Width);
        end;
  end;
end;

procedure TTemplateCtrlListBox.SetVertical(Value: Boolean);
begin
  fVertical := Value;
  ArrangeBox;
  ArrangeButtons;
end;

procedure TTemplateCtrlListBox.SetLeft(Value: Boolean);
begin
  fLeft := Value;
  ArrangeBox;
  ArrangeButtons;
end;

procedure TTemplateCtrlListBox.SetValue(AValue: TTemplateAttributeValue);
begin
  fList.SetValue(AValue);
end;

procedure TTemplateCtrlListBox.Read;
begin
  fList.Read;
end;

procedure TTemplateCtrlListBox.Write;
begin
  fList.Write;
end;

procedure TTemplateCtrlListBox.LoadProc(XmlNode: TXmlNode);
var
  i: Integer;

  procedure AssignAction(btn: TButton; const Action: RawUtf8);
  begin
    if Action = 'browse' then
      btn.Caption := cBrowse
    else
    if Action = 'add' then
    begin
      btn.OnClick := ActAdd;
      btn.Caption := cAdd;
      fAddBtn := btn;
    end
    else
    if Action = 'edit' then
    begin
      btn.OnClick := ActEdit;
      btn.Caption := cEdit;
      fEditBtn := btn;
    end
    else
    if Action = 'delete' then
    begin
      btn.OnClick := ActDelete;
      btn.Caption := cDelete;
      fDeleteBtn := btn;
    end;
  end;

  procedure LoadButton(Node: TXmlNode);
  var
    btn: TButton;
    action: RawUtf8;
    Ctrl: TTemplateControl;
  begin
    action := Node.Attributes.Values['type'];
    if action = 'browse' then
    begin
      fBrowseBtn := TTemplateCtrlPickupDlg.Create(nil);
      fBrowseBtn.SetDataControl(fList);
      Ctrl := fBrowseBtn;
    end
    else
      Ctrl := TTemplateCtrlButton.Create(nil);

    fElements.Add(Ctrl);
    Ctrl.AutoArrange := false;
    Ctrl.AutoSizeX := false;
    Ctrl.AutoSizeY := false;
    Ctrl.ParentControl := Self;
    btn := Ctrl.Control as TButton;
    btn.Height := fBtnHeight;
    btn.Width := fBtnWidth;
    if action <> '' then
      AssignAction(btn, action);
    Ctrl.Load(Node);
    {if Assigned(fBrowseBtn) then
      fBrowseBtn.fDataControlName := ''; // prevent user from redirecting the control}

    if btn.Width > fMaxBtnWidth then
      fMaxBtnWidth := btn.Width;
    if btn.Height > fMaxBtnHeight then
      fMaxBtnHeight := btn.Height;
  end;

  procedure LoadButtons(Node: TXmlNode);
  var
    i: Integer;
  begin
    for i := 0 to Node.Count - 1 do with Node[i] do
    begin
      if Name = 'button' then
        LoadButton(Node[i])
      else
      if Name = 'orientation' then
        fVertical := Node[i].Content = 'vertical'
      else
      if Name = 'alignment' then
        fLeft := Node[i].Content = 'left';
    end;
  end;

begin
  inherited;
  for i := 0 to XmlNode.Count - 1 do with XmlNode[i] do
    if Name = 'margin' then
      fMargin := CheckStrToInt(Content, Name)
    else
    if Name = 'buttons' then
      LoadButtons(XmlNode[i]);
  fList.LoadProc(XmlNode);
  fList.Control.Top := fMargin;
  (*{ Instead of the panel, make the list accessible by the assigned name }
  fList.fName := fName;
  fControl.Name := fName + 'Panel';
  fList.Control.Name := fName;
  fName := fName + 'Panel';*)

  { Make the list accessible to scripts }
  fName := fName;
  fControl.Name := fName;
  fList.fName := 'list';
  fList.Control.Name := 'list';

  ArrangeBox;
  ArrangeButtons;
  MyOnButtonProc(nil);
  if Assigned(fEditBtn) then
    (fList.Control as TListBox).OnDblClick := ActEdit;
end;

procedure TTemplateCtrlListBox.SetLdapAttribute(Attribute: TLdapAttribute);
begin
  inherited;
  fList.LdapAttribute := Attribute;
  if Assigned(fBrowseBtn) then
    fBrowseBtn.LdapAttribute := Attribute;
end;

procedure TTemplateCtrlListBox.EventProc(Attribute: TLdapAttribute; Event: TEventType);
begin
  fList.EventProc(Attribute, Event);
end;

constructor TTemplateCtrlListBox.Create(Attribute: TTemplateAttribute);
begin
  inherited;

  TPanel(fControl).OnResize := MyOnResizeProc;
  TPanel(fControl).BevelInner := bvNone;
  TPanel(fControl).BevelOuter := bvLowered;

  fList := TTemplateCtrlList.Create(Attribute);
  fList.ParentControl := Self;
  fList.Control.Parent := TPanel(Control);
  (fList.Control as TListBox).OnClick := MyOnButtonProc;

  fBtnWidth := 75;
  fBtnHeight := 25;
  fMargin := CT_SPACING;

  TPanel(fControl).Height := 2 * fMargin + fList.Control.Height + fBtnHeight;
end;

{ TTemplateCtrlLoadButton }

procedure TTemplateCtrlLoadButton.LoadProc(XmlNode: TXmlNode);
var
  i: Integer;
begin
  inherited;
  for i := 0 to XmlNode.Count - 1 do with XmlNode[i] do
    if Name = 'filter' then
      fFilter := Content
    else
    if Name = 'filterindex' then
      fFilterIndex := CheckStrToInt(Content, Name);
end;

procedure TTemplateCtrlLoadButton.ButtonClick(Sender: TObject);
var
  Value: TTemplateAttributeValue;
  FileStream: TFileStream;
begin
  with TOpenDialog.Create(Sender as TControl) do
  try
    Filter := fFilter;
    FilterIndex := fFilterIndex;
    if Execute then
    begin
      if Assigned(fDataControl) then
      begin
        Value := TTemplateAttributeValue.Create(nil);
        try
          Value.fValue := LoadBase64(FileName);
          Value.Base64 := true;
          fDataControl.SetValue(Value);
        finally
          Value.Free;
        end;
      end;
      if Assigned(fLdapAttribute) then
      begin
        FileStream := TFileStream.Create(FileName, fmOpenRead);
        try
          if fLdapAttribute.ValueCount = 0 then
            fLdapAttribute.AddValue;
          fLdapAttribute.Values[0].LoadFromStream(FileStream);
        finally
          FileStream.Free;
        end;
      end;
    end;
  finally
    Free;
  end;
end;

constructor TTemplateCtrlLoadButton.Create(Attribute: TTemplateAttribute);
begin
  inherited;
  with TButton(fControl) do begin
    OnExit := OnExitProc;
    OnClick := ButtonClick;
  end;
end;

{ TTemplateList }

function TTemplateList.GetItem(Index: Integer): TTemplate;
begin
  Result := Items[Index];
end;

{ TExtensionList }

function TExtensionList.GetTemplates(Index: RawUtf8): TTemplateList;
var
  idx: Integer;
begin
  idx := fExtensionList.IndexOf(Index);
  if idx = -1 then
    Result := nil
  else
    Result := TTemplateList(fExtensionList.Objects[idx]);
end;

constructor TExtensionList.Create;
begin
  fExtensionList := TStringList.Create;
end;

destructor TExtensionList.Destroy;
begin
  Clear;
  fExtensionList.Free;
  inherited;
end;

procedure TExtensionList.Clear;
var
  i: Integer;
begin
  for i := 0 to fExtensionList.Count - 1 do
    fExtensionList.Objects[i].Free;
  fExtensionList.Clear;
end;

procedure TExtensionList.Add(AValue: RawUtf8; ATemplate: TTemplate);
var
  idx: Integer;
begin
  idx := FExtensionList.IndexOf(AValue);
  if idx = -1 then
    idx := FExtensionList.AddObject(AValue, TTemplateList.Create);
  TTemplateList(FExtensionList.Objects[idx]).Add(ATemplate)
end;

{ TTemplateAttributeList }

function TTemplateAttributeList.GetAttribute(Index: Integer): TTemplateAttribute;
begin
  Result := TTemplateAttribute(TObjectList(Self)[Index]);
end;

{ TTemplateControlList }

function TTemplateControlList.GetControl(Index: Integer): TTemplateControl;
begin
  Result := TTemplateControl(TObjectList(Self)[Index]);
end;

{ TTemplateScriptEventList }

function TTemplateScriptEventList.GetEvent(Index: Integer): TTemplateScriptEvent;
begin
  Result := TTemplateScriptEvent(TObjectList(Self)[Index]);
end;

{ TTemplateScriptEvent }

function TTemplateScriptEvent.GetEventName: RawUtf8;
begin
  Result := fNode.Attributes.Values['type'];
end;

function TTemplateScriptEvent.GetCode: RawUtf8;
begin
  Result := fNode.Content;
end;

constructor TTemplateScriptEvent.Create(Control: TTemplateControl; Node: TXmlNode);
begin
  fControl := Control;
  fNode := Node;
end;

{ TTemplateParser }

constructor TTemplateParser.Create;
begin
  inherited;
  fExtensionList := TExtensionList.Create;
end;

destructor TTemplateParser.Destroy;
begin
  Clear;
  fExtensionList.Free;
  inherited;
end;

procedure TTemplateParser.Clear;
begin
  inherited;
end;

function TTemplateParser.Parse(const FileName: RawUtf8): TObject;
var
  i: Integer;
begin
  Result := TTemplate.Create(FileName);
  try
    if Assigned (FImageList) then with TTemplate(Result) do
      if Assigned(Icon) then
        fImageIndex := FImageList.AddMasked(Icon, Icon.TransparentColor);
  except
    on E:EXmlException do
    begin
      ParseError(mtError, Application.MainForm, ExtractFileName(FileName), E.Message, E.Message2, E.XmlText, E.Tag, E.Line, E.Position);
      Exit;
    end;
    on E:Exception do
      raise Exception.Create(ExtractFileName(FileName) +': ' + #13#10 + E.Message);
  end;

  for i := 0 to TTemplate(Result).Extends.Count - 1 do
    fExtensionList.Add(TTemplate(Result).Extends[i], TTemplate(Result));

end;

function TTemplateParser.IndexOf(const Name: RawUtf8): Integer;
begin
  for Result := 0 to Count - 1 do
    if AnsiCompareText(GetTemplate(Result).Name, Name) = 0 then Exit;
  Result := -1;
end;

function TTemplateParser.GetTemplate(Index: Integer): TTemplate;
begin
  Result := fFiles.Objects[Index] as TTemplate;
end;

procedure TTemplateParser.SetImageList(AList: TImageList);
var
  i: Integer;
begin
  fImageList := AList;
  if Assigned(fImageList) then
  begin
    for i := 0 to Count - 1 do with Templates[i] do
      if Assigned(Icon) then
        fImageIndex := AList.AddMasked(Icon, Icon.TransparentColor);
  end
  else begin
    for i := 0 to Count - 1 do with Templates[i] do
      fImageIndex := -1;
  end;
end;


{ TTemplate }

constructor TTemplate.Create(const AFileName: RawUtf8);
var
  i: integer;

  procedure LoadIcon(var Icon: Graphics.TBitmap; Node: TXmlNode);
  var
    Stream: TMemoryStream;
    Buffer: Pointer;
    vLen: Integer;
    FileName, Bitmap, TransColor: RawUtf8;
    i: Integer;
  begin
    for i := 0 to Node.Count - 1 do with Node[i] do
    if Name = 'bitmap' then
      Bitmap := Content
    else
    if Name = 'file' then
      FileName := Content
    else
    if Name = 'transparentcolor' then
      TransColor := Content;

    if (Bitmap = '') and (FileName = '') then Exit;

    Icon := Graphics.TBitmap.Create;
    Icon.Transparent := true;

    if Bitmap <> '' then
    begin
      Stream := TMemoryStream.Create;
      try
        vLen := Length(Bitmap);
        GetMem(Buffer, Base64DecSize(vLen));
        try
          vLen := Base64Decode(Bitmap, Buffer^);
          Stream.WriteBuffer(Buffer^, vLen);
        finally
          FreeMem(Buffer);
        end;
        Stream.Position := 0;
        Icon.LoadFromStream(Stream);
      finally
        Stream.Free;
      end;
    end
    else
      Icon.LoadFromFile(FileName);
    if TransColor <> '' then
      Icon.TransparentColor := $02000000 + CheckStrToInt(TransColor, 'icon/transparentcolor');
  end;

begin
  inherited Create;
  FImageIndex := -1;
  FAutoArrange := true;
  FAutoSize := true;
  FFileName:=AFileName;
  FExtends := TStringList.Create;
  FXmlTree:=TXmlTree.Create;

  FXmlTree.LoadFromFile(AFileName);
  for i:=0 to FXmlTree.Root.Count-1 do with FXmlTree.Root[i] do begin
    if Name='name' then FName:= Content
    else
    if Name='description' then
    begin
      if XmlLanguageMatch(FXmlTree.Root[i]) then
        FDescription:=Content
    end
    else
    if Name='extends' then fExtends.Add(Content)
    else
    if Name='rdn' then fRdn := Content
    else
    if Name='attribute' then
    begin
      with NodeByName('name') do
        if Content = 'objectclass' then
          FObjectClass := TTemplateAttribute.Create(FXmlTree.Root[i]);
    end
    else
    if Name = 'icon' then
      LoadIcon(fIcon, FXmlTree.Root[i])
    else
    if Name = 'autoarrange' then
    begin
      if Content = 'false' then
        FAutoArrange := false;
    end
    else
    if Name = 'autosize' then
    begin
      if Content = 'false' then
        FAutoSize := false;
    end;
  end;
end;

destructor TTemplate.Destroy;
begin
  FXmlTree.Free;
  fObjectclass.Free;
  FExtends.Free;
  inherited;
end;

function TTemplate.GetObjectclasses(Index: Integer): RawUtf8;
begin
  if Index < ObjectclassCount then
    Result := fObjectclass.Values[Index].Value
  else
    Result := '';
end;

function TTemplate.GetObjectclassCount: Integer;
begin
  if Assigned(fObjectclass) then
    Result := fObjectclass.ValuesCount
  else
    Result := 0;
end;

procedure TTemplate.Parse(Control: TTemplateControl; out Script: TCustomScript);
var
  Node: TXmlNode;
  i, j: Integer;
  AAttribute: TTemplateAttribute;
  AControl: TTemplateControl;
begin
  for i:=0 to FXmlTree.Root.Count-1 do
  begin
    Node := FXmlTree.Root[i];
    if Node.Name = 'attribute' then
    begin
      AAttribute := TTemplateAttribute.Create(Node);
      Control.Elements.Add(AAttribute);
      for j := 0 to AAttribute.Controls.Count - 1 do
        AAttribute.Controls[j].ParentControl := Control;
    end
    else
    if Node.Name = 'control' then
    begin
      AControl := CreateControl(Node, nil);
      if Assigned(AControl) then
      begin
        Control.Elements.Add(AControl);
        AControl.ParentControl := Control;
      end;
    end
    else
    if Node.Name = 'script' then
    begin
      if not Assigned(Script) then
        Script := CreateScript(FXmlTree.Root[i])
      else
        Script.Lines.Text := Script.Lines.Text + #10#13 + Node.Content;
    end;

  end;
end;

function TTemplate.Matches(ObjectClass: TLdapAttribute): Boolean;
var
  i: Integer;
begin
  Result := false;
  if ObjectclassCount = 0 then Exit;
  for i := 0 to ObjectclassCount - 1 do
    if ObjectClass.IndexOf(Objectclasses[i]) = -1 then
      Exit;
  Result := true;
end;

{ TTemplateAttribute }

constructor TTemplateAttribute.Create(XmlNode: TXmlNode);
var
  i: integer;
  AValue: TTemplateAttributeValue;
  AControl: TTemplateControl;
begin
  inherited Create;
  FControls:=TTemplateControlList.Create;
  FValues:=TObjectList.Create;
  FDefaultControlClass := GetDefaultXmlType(XmlNode);

  for i:=0 to XmlNode.Count-1 do with XmlNode[i] do begin
    if Name='name'  then FName:=Content
    else
    if Name='description' then
    begin
      if XmlLanguageMatch(XmlNode[i]) then
        FDescription:=Content
    end
    else
    if Name='control' then
    begin
      AControl := CreateControl(XmlNode[i], Self);
      if Assigned(AControl) then
        AControl.fControlIndex := FControls.Add(AControl)
    end
    else
    if Name='value' then begin
      Avalue:=TTemplateAttributeValue.Create(Self);
      AValue.Base64:=(Attributes.Values['encode']='base64');
      AValue.Value:=Content;
      FValues.Add(AValue)
    end
    else
    if Name='required' then
    begin
      if Content <> 'false' then
        FRequired := true;
    end;
  end;

  if (Controls.Count = 0) and Assigned(FDefaultControlClass) then
  begin
    AControl := FDefaultControlClass.Create(Self);
    FControls.Add(AControl);
  end;

end;

destructor TTemplateAttribute.Destroy;
begin
  FControls.Free;
  FValues.Free;
  inherited;
end;

function TTemplateAttribute.GetValues(Index: Integer): TTemplateAttributeValue;
begin
  result:=TTemplateAttributeValue(FValues[Index]);
end;

function TTemplateAttribute.GetValuesCount: integer;
begin
  result:=FValues.Count;
end;

{ TTemplateAttributeValue }

procedure TTemplateAttributeValue.SetBase64(const Value: Boolean);
begin
  FBase64 := Value;
end;

procedure TTemplateAttributeValue.SetValue(const Value: RawUtf8);
begin
  FValue := Value;
end;

function TTemplateAttributeValue.GetString: RawUtf8;
var
  vLen: Integer;
  {$IFDEF UNICODE}
  aOut: AnsiString;
  {$ENDIF}
begin
  if Base64 then
  begin
    vLen := Length(Value);
    {$IFDEF UNICODE}
    SetLength(aOut, Base64decSize(vLen));
    vLen := Base64Decode(AnsiString(Value)[1], vLen, aOut[1]);
    SetLength(aOut, vLen);
    Result := RawUtf8(aOut);
    {$ELSE}
    SetLength(Result, Base64decSize(vLen));
    vLen := Base64Decode(Value[1], vLen, Result[1]);
    SetLength(Result, vLen);
    {$ENDIF}
  end
  else
    Result := Value;
end;

constructor TTemplateAttributeValue.Create(AAttribute: TTemplateAttribute);
begin
  fAttribute := AAttribute;
end;

procedure TTemplateAttributeValue.SaveToStream(AStream: TStream);
var
  Buffer: Pointer;
  vLen: Integer;
begin
  if Base64 then
  begin
    vLen := Length(Value);
    GetMem(Buffer, Base64DecSize(vLen));
    try
      vLen := Base64Decode(Value[1], vLen, Buffer^);
      AStream.WriteBuffer(Buffer^, vLen);
    finally
      FreeMem(Buffer);
    end;
  end
  else
    AStream.WriteBuffer(Value[1], Length(Value));
end;

initialization

  Iso639LangName := GetIso639LangName;

  TemplateParser := TTemplateParser.Create;
  with TemplateParser do
  try
     FileExtension := TEMPLATE_EXT;
    Paths := GlobalConfig.ReadString('TemplateDir');
    AddPath(ExtractFileDir(application.ExeName) + '\*.' + TEMPLATE_EXT);
  except
    on E: Exception do
      MessageDlg(E.Message, mtError, [mbOK], 0);
  end;

finalization

  TemplateParser.Free;

end.

