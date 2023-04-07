  {      LDAPAdmin - Schema.pas
  *      Copyright (C) 2005 Alexander Sokoloff
  *
  *      Author: Alexander Sokoloff
  *
  *      Changes: Removed Global Schema - T.Karlovic 11.06.2012
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

unit Schema;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses Classes, LDAPClasses, LinLDAP, SysUtils, Contnrs, mormot.core.base;

type
  TAttributeUsage=(au_userApplications, au_directoryOperation, au_distributedOperation, au_dSAOperation);

  TLDAPSchema=class;
  TLDAPSchemaAttributes=class;
  TLDAPSchemaClasses=class;
  TLDAPSchemaSyntax=class;
  TLDAPSchemaMatchingRule=class;
  TLDAPSchemaMatchingRuleUse=class;

  TLdapSchemaItem=class
  private
    FSchema:      TLDAPSchema;
    FOid:         RawUtf8;
    FName:        TStringList;
    FDescription: RawUtf8;
  protected
    procedure     Load(const LDAPString: RawUtf8); virtual; abstract;
  public
    constructor   Create(const ASchema: TLdapSchema; const LDAPString: RawUtf8); reintroduce; virtual;
    destructor    Destroy; override;
    property      Oid: RawUtf8 read FOid;
    property      Description: RawUtf8 read FDescription;
    property      Name: TStringList read FName;
  end;

  TLdapSchemaItemClass = class of TLdapSchemaItem;

  TLdapSchemaItems=class(TObjectList)
  private
    FSchema:      TLDAPSchema;
    function      GetItems(Index: integer): TLdapSchemaItem;
  protected
    function      GetItemClass: TLdapSchemaItemClass; virtual; abstract;
    procedure     Load(const Attribute: TLdapAttribute);
    procedure     SliceByName(const Str: RawUtf8; result: TLdapSchemaItems);
  public
    constructor   Create(const ASchema: TLdapSchema; AOwnsObjects: Boolean=true); reintroduce;
    property      Schema: TLDAPSchema read FSchema;
    function      IndexOf(const Name: RawUtf8): integer; reintroduce;
    property      Items[Index: integer]: TLdapSchemaItem read GetItems; default;
  end;

  TLDAPSchemaAttribute=class(TLDAPSchemaItem)
  private
    FCollective:          boolean;
    FNoUserModification:  boolean;
    FSingleValue:         boolean;
    FObsolete:            boolean;
    FLength:              integer;
    FSyntaxAsStr:         RawUtf8;
    FSuperiorAsStr:       RawUtf8;
    FSuperior:            TLdapSchemaAttribute;
    FUsage:               TAttributeUsage;
    FOrderingAsStr:       RawUtf8;
    FEqualityAsStr:       RawUtf8;
    FSubstrAsStr:         RawUtf8;
    FOrdering:            TLDAPSchemaMatchingRuleUse;
    FEquality:            TLDAPSchemaMatchingRuleUse;
    FSubstr:              TLDAPSchemaMatchingRule;
    FSyntax:              TLDAPSchemaSyntax;
    FWhichUse:            TLdapSchemaClasses;
    function              GetWhichUse: TLdapSchemaClasses;
    function              GetSyntax: TLDAPSchemaSyntax;
    function              GetSuperior: TLdapSchemaAttribute;
    function              GetOrdering: TLDAPSchemaMatchingRuleUse;

    function              GetSubstr: TLDAPSchemaMatchingRule;
    function              GetEquality: TLDAPSchemaMatchingRuleUse;

  public
    constructor           Create(const Schema: TLdapSchema; const LDAPString: RawUtf8); override;
    destructor            Destroy; override;
    property              Obsolete: boolean read FObsolete;
    property              SuperiorAsStr: RawUtf8 read FSuperiorAsStr;
    property              Superior: TLdapSchemaAttribute read GetSuperior;

    property              EqualityAsStr: RawUtf8 read FEqualityAsStr;
    property              OrderingAsStr: RawUtf8 read FOrderingAsStr;
    property              SubstrAsStr: RawUtf8 read FSubstrAsStr;
    property              Ordering: TLDAPSchemaMatchingRuleUse read GetOrdering;
    property              Equality: TLDAPSchemaMatchingRuleUse read GetEquality;
    property              Substr: TLDAPSchemaMatchingRule read GetSubstr;

    property              Syntax: TLDAPSchemaSyntax read GetSyntax;
    property              SyntaxAsStr: RawUtf8 read FSyntaxAsStr;
    property              SingleValue: boolean read FSingleValue;
    property              Collective: boolean read FCollective;
    property              NoUserModification: boolean read FNoUserModification;
    property              Usage: TAttributeUsage read FUsage;
    property              Length: integer read FLength;
    property              WhichUse: TLdapSchemaClasses read GetWhichUse;
  end;

  TLDAPClassKind=(lck_Abstract, lck_Structural, lck_Auxiliary);

  TLDAPSchemaClass=class(TLDAPSchemaItem)
  private
    FObsolete:            boolean;
    FKind:                TLDAPClassKind;
    FSuperiorAsStr:       RawUtf8;
    FMustStr:             RawUtf8;
    FMayStr:              RawUtf8;
    FMay:                 TLDAPSchemaAttributes;
    FMust:                TLDAPSchemaAttributes;
    FSuperior:            TLdapSchemaClass;
    function              GetMust: TLDAPSchemaAttributes;
    function              GetMay: TLDAPSchemaAttributes;
    function              GetSuperior: TLdapSchemaClass;
  public
    constructor           Create(const ASchema: TLdapSchema; const LDAPString: RawUtf8); override;
    destructor            Destroy; override;
    property              Obsolete: boolean read FObsolete;
    property              Superior: TLdapSchemaClass read GetSuperior;
    property              SuperiorAsStr: RawUtf8 read FSuperiorAsStr;
    property              Kind: TLDAPClassKind read FKind;
    property              Must: TLDAPSchemaAttributes read GetMust;
    property              May: TLDAPSchemaAttributes read GetMay;
  end;

  TLDAPSchemaSyntax=class(TLDAPSchemaItem)
  public
    constructor           Create(const ASchema: TLdapSchema; const LDAPString: RawUtf8); override;
  end;

  TLDAPSchemaMatchingRule=class(TLDAPSchemaItem)
  private
    FObsolete:            boolean;
    FSyntaxAsStr:         RawUtf8;
    FSyntax:              TLdapSchemaSyntax;
    function              GetSyntax: TLdapSchemaSyntax;
  public
    constructor           Create(const ASchema: TLdapSchema; const LDAPString: RawUtf8); override;
    property              Obsolete: boolean read FObsolete;
    property              SyntaxAsStr: RawUtf8 read FSyntaxAsStr;
    property              Syntax: TLdapSchemaSyntax read GetSyntax;
  end;

  TLDAPSchemaMatchingRuleUse=class(TLDAPSchemaItem)
  private
    FObsolete:            boolean;
    FAppliesStr:          RawUtf8;
    FApplies:             TLDAPSchemaAttributes;
    function              GetApplies: TLDAPSchemaAttributes;
  public
    constructor           Create(const ASchema: TLdapSchema; const LDAPString: RawUtf8); override;
    destructor            Destroy; override;
    property              Description: RawUtf8 read FDescription;
    property              Obsolete: boolean read FObsolete;
    property              Applies: TLDAPSchemaAttributes read GetApplies;
  end;

  TLDAPSchemaAttributes=class(TLdapSchemaItems)
  private
    function              GetItems(Index: Integer): TLDAPSchemaAttribute;
    function              GetByName(Name: RawUtf8): TLDAPSchemaAttribute;
  protected
    function              GetItemClass: TLdapSchemaItemClass; override;
  public
    property              Items[Index: integer]: TLDAPSchemaAttribute read GetItems; default;
    property              ByName[Index: RawUtf8]: TLDAPSchemaAttribute read GetByName;
  end;

  TLDAPSchemaClasses=class(TLdapSchemaItems)
  private
    function              GetItems(Index: Integer): TLDAPSchemaClass;
    function              GetByName(Index: RawUtf8): TLdapSchemaClass;
  protected
    function              GetItemClass: TLdapSchemaItemClass; override;
  public
    property              Items[Index: integer]: TLDAPSchemaClass read GetItems; default;
    property              ByName[Index: RawUtf8]: TLDAPSchemaClass read GetByName;
  end;

  TLDAPSchemaSyntaxes=class(TLdapSchemaItems)
  private
    function              GetItems(Index: Integer): TLDAPSchemaSyntax;
  protected
    function              GetItemClass: TLdapSchemaItemClass; override;
  public
    property              Items[Index: integer]: TLDAPSchemaSyntax read GetItems; default;
  end;

  TLDAPSchemaMatchingRules=class(TLdapSchemaItems)
  private
    function              GetItems(Index: Integer): TLDAPSchemaMatchingRule;
  protected
    function              GetItemClass: TLdapSchemaItemClass; override;
  public
    property              Items[Index: integer]: TLDAPSchemaMatchingRule read GetItems; default;
  end;

  TLDAPSchemaMatchingRuleUses=class(TLdapSchemaItems)
  private
    function              GetItems(Index: Integer): TLDAPSchemaMatchingRuleUse;
  protected
    function              GetItemClass: TLdapSchemaItemClass; override;
  public
    property              Items[Index: integer]: TLDAPSchemaMatchingRuleUse read GetItems; default;
  end;

  TLDAPSchema=class
  private
    FSession:             TLDAPSession;
    FAttributes:          TLDAPSchemaAttributes;
    FObjectClasses:       TLDAPSchemaClasses;
    FSyntaxes:            TLDAPSchemaSyntaxes;
    FMatchingRules:       TLDAPSchemaMatchingRules;
    FMatchingRuleUses:    TLDAPSchemaMatchingRuleUses;
    FLoaded:              boolean;
    FDn:                  RawUtf8;
    procedure             Load;
  public
    constructor           Create(const ASession: TLDAPSEssion); reintroduce;
    destructor            Destroy; override;
    procedure             Clear;
    property              Session: TLDAPSession read FSession;
    property              DN: RawUtf8 read Fdn;
    property              ObjectClasses: TLDAPSchemaClasses read FObjectClasses;
    property              Attributes: TLDAPSchemaAttributes read FAttributes;
    property              Syntaxes: TLDAPSchemaSyntaxes read FSyntaxes;
    property              MatchingRules: TLDAPSchemaMatchingRules read FMatchingRules;
    property              MatchingRuleUses: TLDAPSchemaMatchingRuleUses read FMatchingRuleUses;
    property              Loaded: boolean read FLoaded;
  end;


implementation

uses TypInfo, Constant;


{ Procedures }

function PosChar(const Pattern: char; S: RawUtf8; Offset: cardinal=1): integer;
var
  i: integer;
begin
  for i:=Offset to length(S) do
    if S[i]=Pattern then begin
      result:=i;
      exit;
    end;
  result:=0;
end;

function GetOid(const S: RawUtf8): RawUtf8;
var
  n: integer;
begin
  n:=PosChar(' ',S,3);
  result:=copy(S,3,n-3);
end;

function GetString(const S, Name: RawUtf8): RawUtf8;
var
  n1,n2: integer;
  EndChar: char;
begin
  result:='';
  n1:=Pos(' '+name+' ',S);
  if n1<1 then exit;

  inc(n1,length(name)+2);
  case S[n1] of
    '(':  begin
            EndChar:=')';
            inc(n1);
          end;
    '''': begin
            EndChar:='''';
            inc(n1);
          end;
    else  EndChar:=' ';
  end;

  n2:=PosChar(EndChar,S,n1);

  result:=trim(copy(S,n1,n2-n1));
  if length(result)>0 then begin
    if result[1]='''' then delete(result,1,1);
    if result[length(result)]='''' then delete(result,length(result),1);
    result:=StringReplace(result,''' ''',',',[rfReplaceAll]);
    result:=StringReplace(result,' $ '  ,',',[rfReplaceAll]);
  end;
end;

function GetBoolean(const S, Name: RawUtf8): boolean;
begin
  result:=Pos(' '+name+' ',S)>0;
end;

{ TLDAPSchemaItem }

constructor TLDAPSchemaItem.Create(const ASchema: TLdapSchema; const LDAPString: RawUtf8);
begin
  inherited Create;
  FSchema:=ASchema;
  FName:=TStringList.Create;
  FName.CommaText:=GetString(LDAPString,'NAME');
  FDescription:=GetString(LDAPString,'DESC');
  FOid:=GetOid(LDAPString);
end;

destructor TLDAPSchemaItem.Destroy;
begin
  FName.Free;
  inherited;
end;


{ TLDAPSchemaAttribute }

constructor TLDAPSchemaAttribute.Create(const Schema: TLdapSchema; const LDAPString: RawUtf8);
var
  n: integer;
  s: RawUtf8;
begin
  inherited;

  FObsolete:=GetBoolean(LDAPString,'OBSOLETE');
  FSuperiorAsStr:=GetString(LDAPString,'SUP');
  FCollective:=GetBoolean(LDAPString,'COLLECTIVE');
  FNoUserModification:=GetBoolean(LDAPString,'NO-USER-MODIFICATION');
  FSingleValue:=GetBoolean(LDAPString,'SINGLE-VALUE');
  FSyntaxAsStr:=GetString(LDAPString,'SYNTAX');
  n:=pos('{',FsyntaxAsStr);
  if n>0 then begin
    FLength:=StrToIntDef(copy(FSyntaxAsStr,n+1,system.length(FSyntaxAsStr)-n-1),0);
    setlength(FSyntaxAsStr,n-1);
  end else FLength:=0;

  s:=GetString(LDAPString,'USAGE');
  if s='directoryOperation'   then FUsage:=au_directoryOperation   else
  if s='distributedOperation' then FUsage:=au_distributedOperation else
  if s='dSAOperation'         then FUsage:=au_dSAOperation
  else FUsage:=au_userApplications;

  FOrderingAsStr:=GetString(LDAPString,'ORDERING');
  FEqualityAsStr:=GetString(LDAPString,'EQUALITY');
  FSubstrAsStr:=GetString(LDAPString,'SUBSTR');
end;

destructor TLDAPSchemaAttribute.Destroy;
begin
  FWhichUse.Free;
end;

function TLDAPSchemaAttribute.GetOrdering: TLDAPSchemaMatchingRuleUse;
var
  idx: integer;
begin
  if FOrdering=nil then begin
    idx:=FSchema.MatchingRuleUses.IndexOf(FOrderingAsStr);
    if idx>-1 then FOrdering:=FSchema.MatchingRuleUses[idx];
  end;
  result:=FOrdering;
end;

function TLDAPSchemaAttribute.GetEquality: TLDAPSchemaMatchingRuleUse;
var
  idx: integer;
begin
  if FEquality=nil then begin
    idx:=FSchema.MatchingRuleUses.IndexOf(FEqualityAsStr);
    if idx>-1 then FEquality:=FSchema.MatchingRuleUses[idx];
  end;
  result:=FEquality;
end;


function TLDAPSchemaAttribute.GetSubstr: TLDAPSchemaMatchingRule;
var
  idx: integer;
begin
  if FSubstr=nil then begin
    idx:=FSchema.MatchingRules.IndexOf(FSubstrAsStr);
    if idx>-1 then FSubstr:=FSchema.MatchingRules[idx];
  end;
  result:=FSubstr;
end;

function TLDAPSchemaAttribute.GetSuperior: TLdapSchemaAttribute;
var
  idx: integer;
begin
  if FSuperior=nil then begin
    idx:=FSchema.Attributes.IndexOf(FSuperiorAsStr);
    if idx>-1 then FSuperior:=FSchema.Attributes[idx];
  end;
  result:=FSuperior;
end;

function TLDAPSchemaAttribute.GetSyntax: TLDAPSchemaSyntax;
var
  idx: integer;
begin
  if FSyntax=nil then begin
    idx:=FSchema.Syntaxes.IndexOf(FSyntaxAsStr);
    if idx>-1 then FSyntax:=FSchema.Syntaxes[idx];
  end;
  result:=FSyntax;
end;

function TLDAPSchemaAttribute.GetWhichUse: TLdapSchemaClasses;
var
  i,j: integer;
begin
  if FWhichUse=nil then begin
    FWhichUse:=TLDAPSchemaClasses.Create(FSchema, false);
    for i:=0 to FSchema.ObjectClasses.Count-1 do begin
      for j:=0 to Name.Count-1 do begin
        if (FSchema.ObjectClasses[i].May.IndexOf(Name[j])>-1) or
           (FSchema.ObjectClasses[i].Must.IndexOf(Name[j])>-1) then
            FWhichUse.Add(FSchema.ObjectClasses[i]);
      end;
    end;
  end;

  result:=FWhichUse;
end;


{ TLDAPSchemaClass }

constructor TLDAPSchemaClass.Create(const ASchema: TLdapSchema; const LDAPString: RawUtf8);
begin
  inherited;
  FObsolete:=GetBoolean(LDAPString,'OBSOLETE');

  if GetBoolean(LDAPString,'ABSTRACT') then FKind:=lck_Abstract else
  if GetBoolean(LDAPString,'STRUCTURAL') then FKind:=lck_Structural else
  FKind:=lck_Auxiliary;

  FSuperiorAsStr:=GetString(LDAPString,'SUP');
  FMustStr:=GetString(LDAPString,'MUST');
  FMayStr:=GetString(LDAPString,'MAY');
end;

destructor TLDAPSchemaClass.Destroy;
begin
  FMay.Free;
  FMust.Free;
  inherited;
end;

function TLDAPSchemaClass.GetMust: TLDAPSchemaAttributes;
begin
  if FMust=nil then begin
    FMust:=TLDAPSchemaAttributes.Create(FSchema, false);
    FSchema.Attributes.SliceByName(FMustStr, FMust);
  end;
  result:=FMust;
end;

function TLDAPSchemaClass.GetMay: TLDAPSchemaAttributes;
begin
  if FMay=nil then begin
    FMay:=TLDAPSchemaAttributes.Create(FSchema, false);
    FSchema.Attributes.SliceByName(FMayStr, FMay);
  end;
  result:=FMay;
end;

function TLDAPSchemaClass.GetSuperior: TLdapSchemaClass;
var
  idx: integer;
begin
  if FSuperior=nil then begin
    idx:=FSchema.ObjectClasses.IndexOf(FSuperiorAsStr);
    if idx>-1 then FSuperior:=FSchema.ObjectClasses[idx];
  end;
  result:=FSuperior;
end;


{ TLDAPSchemaSyntax }

constructor TLDAPSchemaSyntax.Create(const ASchema: TLdapSchema; const LDAPString: RawUtf8);
begin
  inherited;
  Name.Text:=Oid;
end;


{ TLDAPSchemaMatchingRule }

constructor TLDAPSchemaMatchingRule.Create(const ASchema: TLdapSchema; const LDAPString: RawUtf8);
begin
  inherited;
  FObsolete:=GetBoolean(LDAPString,'OBSOLETE');
  FSyntaxAsStr:=GetString(LDAPString,'SYNTAX');
end;

function TLDAPSchemaMatchingRule.GetSyntax: TLdapSchemaSyntax;
var
  idx: integer;
begin
  if FSyntax=nil then begin
    idx:=FSchema.Syntaxes.IndexOf(FSyntaxAsStr);
    if idx>-1 then FSyntax:=FSchema.Syntaxes[idx];
  end;
  result:=FSyntax;
end;

{ TLDAPSchemaMatchingRuleUse }

constructor TLDAPSchemaMatchingRuleUse.Create(const ASchema: TLdapSchema; const LDAPString: RawUtf8);
begin
  inherited;
  FAppliesStr:=GetString(LDAPString,'APPLIES');
end;

destructor TLDAPSchemaMatchingRuleUse.Destroy;
begin
  inherited;
end;

function TLDAPSchemaMatchingRuleUse.GetApplies: TLDAPSchemaAttributes;
begin
  if FApplies=nil then begin
    FApplies:=TLDAPSchemaAttributes.Create(FSchema, false);
    FSchema.Attributes.SliceByName(FAppliesStr, FApplies);
  end;
  result:=FApplies;
end;




{ TLDAPSchema }

constructor TLDAPSchema.Create(const ASession: TLDAPSEssion);
begin
  inherited Create;
  FSession:=ASession;
  FAttributes:=TLDAPSchemaAttributes.Create(self);
  FObjectClasses:=TLDAPSchemaClasses.Create(self);
  FSyntaxes:=TLDAPSchemaSyntaxes.Create(self);
  FMatchingRules:=TLDAPSchemaMatchingRules.Create(self);
  FMatchingRuleUses:=TLDAPSchemaMatchingRuleUses.Create(self);
  FDn:='';
  Load;
end;

destructor TLDAPSchema.Destroy;
begin
  FAttributes.Free;
  FObjectClasses.Free;
  FSyntaxes.Free;
  FMatchingRules.Free;
  FMatchingRuleUses.Free;
  inherited;
end;

procedure TLDAPSchema.Clear;
begin
  FSyntaxes.Clear;
  FAttributes.Clear;
  FObjectClasses.Clear;
  FMatchingRules.Clear;
  FMatchingRuleUses.Clear;
end;

procedure TLDAPSchema.Load;
var
//  SubschemaSubentry: RawUtf8;
  SearchResult: TLdapEntryList;
begin
  FLoaded:=false;
  Clear;

  if (FSession=nil) or (FSession.Version < LDAP_VERSION3) then exit;
  
  SearchResult:=TLdapEntryList.Create;
  try
    // Search path to schema ///////////////////////////////////////////////////
    FSession.Search('(objectclass=*)','',LDAP_SCOPE_BASE,['subschemaSubentry'],false,SearchResult);
    if SearchResult.Count = 0 then Abort;   // Added, 23.06.2016, T.Karlovic
    FDn:=SearchResult[0].AttributesByName['subschemaSubentry'].AsString;
    if FDn='' then raise Exception.Create(stSchemaNoSubentry);


    // Get schema values ///////////////////////////////////////////////////////
    SearchResult.Clear;
    FSession.Search('(objectClass=*)', FDn, LDAP_SCOPE_BASE,
                    ['ldapSyntaxes', 'attributeTypes', 'objectclasses', 'matchingRules', 'matchingRuleUse'],
                    false, SearchResult);

    if SearchResult.Count>0 then
    begin
      with SearchResult.Items[0] do
      begin
        FSyntaxes.Load(AttributesByName['ldapSyntaxes']);
        FAttributes.Load(AttributesByName['attributeTypes']);
        FObjectClasses.Load(AttributesByName['objectclasses']);
        FMatchingRules.Load(AttributesByName['matchingRules']);
        FMatchingRuleUses.Load(AttributesByName['matchingRuleUse']);
      end;
    end;
    FLoaded:=true;
  except
    //
  end;
  SearchResult.Clear;
  SearchResult.Free;
end;


{ TLdapSchemaItems }

function TLdapSchemaItems.IndexOf(const Name: RawUtf8): integer;
begin
  if Name='' then begin
    result:=-1;
    exit;
  end;

  result:=0;
  while result<Count do begin
    if Items[result].Oid=Name then exit;
    inc(result);
  end;

  result:=0;
  while result<Count do begin
    if Items[result].Name.IndexOf(Name)>-1 then exit;
    inc(result);
  end;
  result:=-1;
end;

constructor TLdapSchemaItems.Create(const ASchema: TLdapSchema;  AOwnsObjects: Boolean);
begin
  inherited Create(AOwnsObjects);
  FSchema:=ASchema;
end;

function TLdapSchemaItems.GetItems(Index: integer): TLdapSchemaItem;
begin
  result:=TLdapSchemaItem(inherited Items[Index]);
end;


procedure TLdapSchemaItems.Load(const Attribute: TLdapAttribute);
var
  i: integer;
  AClass: TLdapSchemaItemClass;
begin
  AClass:=GetItemClass;

  for i:=0 to Attribute.ValueCount-1 do
    Add(AClass.Create(Schema, Attribute.Values[i].AsString));
end;

procedure TLdapSchemaItems.SliceByName(const Str: RawUtf8; result: TLdapSchemaItems);
var
  i, idx: integer;
  Strs: TStringList;
begin
  Strs:=TStringList.Create;
  Strs.CommaText:=Str;
  for i:=0 to Strs.Count-1 do begin
    idx:=IndexOf(Strs[i]);
    if idx>0 then result.Add(Items[idx]);
  end;
  Strs.Free;
end;

{ TLDAPSchemaClasses }

function TLDAPSchemaClasses.GetItemClass: TLdapSchemaItemClass;
begin
  result:=TLDAPSchemaClass;
end;

function TLDAPSchemaClasses.GetItems(Index: Integer): TLDAPSchemaClass;
begin
  result:= TLDAPSchemaClass(inherited GetItem(Index));
end;

function TLDAPSchemaClasses.GetByName(Index: RawUtf8): TLdapSchemaClass;
var
  i, j: Integer;
begin
  Result := nil;
  for i := 0 to Count - 1 do
  with Items[i] do
  for j := 0 to Name.Count - 1 do
    if CompareText(Name[j], Index) = 0 then
    begin
      Result := Items[i];
      Exit;
    end;
end;

{ TLDAPSchemaAttributes }

function TLDAPSchemaAttributes.GetItemClass: TLdapSchemaItemClass;
begin
  result:=TLDAPSchemaAttribute;
end;

function TLDAPSchemaAttributes.GetItems(Index: Integer): TLDAPSchemaAttribute;
begin
  result:= TLDAPSchemaAttribute(inherited GetItem(Index));
end;

function TLDAPSchemaAttributes.GetByName(Name: RawUtf8): TLDAPSchemaAttribute;
var
  i: integer;
begin
  result:=nil;
  for i:=0 to Count-1 do
    if Items[i].Name.IndexOf(Name)>-1 then begin
      result:=Items[i];
      exit;
    end;
end;

{ TLDAPSchemaSyntaxes }

function TLDAPSchemaSyntaxes.GetItemClass: TLdapSchemaItemClass;
begin
  result:=TLDAPSchemaSyntax;
end;

function TLDAPSchemaSyntaxes.GetItems(Index: Integer): TLDAPSchemaSyntax;
begin
  result:= TLDAPSchemaSyntax(inherited GetItem(Index));
end;


{ TLDAPSchemaMatchingRules }

function TLDAPSchemaMatchingRules.GetItemClass: TLdapSchemaItemClass;
begin
  result:=TLDAPSchemaMatchingRule;
end;

function TLDAPSchemaMatchingRules.GetItems(Index: Integer): TLDAPSchemaMatchingRule;
begin
  result:= TLDAPSchemaMatchingRule(inherited GetItem(Index));
end;


{ TLDAPSchemaMatchingRuleUses }

function TLDAPSchemaMatchingRuleUses.GetItemClass: TLdapSchemaItemClass;
begin
  result:=TLDAPSchemaMatchingRuleUse;
end;

function TLDAPSchemaMatchingRuleUses.GetItems(Index: Integer): TLDAPSchemaMatchingRuleUse;
begin
   result:= TLDAPSchemaMatchingRuleUse(inherited GetItem(Index));
end;

end.
