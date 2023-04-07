  {      LDAPAdmin - Ast.pas
  *      Copyright (C) 2016 Tihomir Karlovic
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
unit Ast;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
  Classes, SysUtils, Contnrs, Connection, LdapClasses, mormot.net.ldap;


const
  LDAP_MATCHING_RULE_BIT_AND          = '1.2.840.113556.1.4.803';
  LDAP_MATCHING_RULE_BIT_OR           = '1.2.840.113556.1.4.804';
  LDAP_MATCHING_RULE_TRANSITIVE_EVAL  = '1.2.840.113556.1.4.1941';
  LDAP_MATCHING_RULE_DN_WITH_DATA     = '1.2.840.113556.1.4.2253';

  InvalidAttrChars = ['*'] + LdapInvalidChars;

type
  TFilterType = (ftEqual, ftGrEq, ftLessEq); // Flags for Equality operator
  TExtensibleType = (etDefault, etAnd, etOr, etTransitive, etDnWithData);

  TASTNode = class
  public
    procedure ExecuteFilter(Session: TLdapSession; BaseNode: TEntryNode; const Scope: TLdapsearchScope; Result: TLdapEntryList); virtual; abstract;
  end;

  TAstNodeFactor = class(TAstNode)
  protected
    fFactors: TObjectList;
    procedure GetFactorList(s: string);
  public
    constructor Create(s: string); virtual;
    destructor Destroy; override;
  end;

  TASTNodeOr = class(TASTNodeFactor)
  public
    procedure ExecuteFilter(Session: TLdapSession; BaseNode: TEntryNode; const Scope: TLdapsearchScope; Result: TLdapEntryList); override;
  end;

  TASTNodeAnd = class(TASTNodeFactor)
    public
      procedure ExecuteFilter(Session: TLdapSession; BaseNode: TEntryNode; const Scope: TLdapsearchScope; Result: TLdapEntryList); override;
  end;

  { TASTNodeNot }

  TASTNodeNot = class(TASTNodeFactor)
    public
      constructor Create(s: string); override;
      procedure ExecuteFilter(Session: TLdapSession; BaseNode: TEntryNode; const Scope: TLdapsearchScope; Result: TLdapEntryList); override;
  end;

  TASTNodeItem = class(TAstNode)
  private
    procedure AddEntry(ANode: TEntryNode);
  protected
    fSession: TLdapSession;
    fScope: TLdapsearchScope;
    fResult: TLdapentryList;
    fAttribute, fAssertionValue: string;
    procedure DoCompare(ANode: TEntryNode); virtual; abstract;
    procedure Traverse(ANode: TEntryNode);
  public
    constructor Create(Attribute, AssertionValue: string); reintroduce; virtual;
    procedure ExecuteFilter(Session: TLdapSession; BaseNode: TEntryNode; const Scope: TLdapsearchScope; Result: TLdapEntryList); override;
  end;

  TASTNodeItemEquality = class(TAstNodeItem)
  private
    fFilterType: TFilterType;
    function CompareValue(AValue: string): Boolean;
  protected
    procedure DoCompare(ANode: TEntryNode); override;
  public
    constructor Create(Attribute, AssertionValue: string; FilterType: TFilterType); reintroduce;
  end;

  TASTNodeItemPresence = class(TAstNodeItem)
  protected
    procedure DoCompare(ANode: TEntryNode); override;
  end;

  TASTNodeItemSubstring = class(TAstNodeItem)
    function Matches(Wildcard, Text: string): Boolean;
  protected
    procedure DoCompare(ANode: TEntryNode); override;
  end;

  TAstNodeItemExtensibleMatch = class(TastNodeItem)
  private
    fDn: Boolean;
    fRule: TExtensibleType;
    fData: Cardinal;
    function CompareValue(AValue: string): Boolean;
    function CompareDn(adn: string): Boolean;
    function CompareName(AName: string): Boolean;
  protected
    procedure DoCompare(ANode: TEntryNode); override;
  public
    constructor Create(Attribute, AssertionValue: string); override;
  end;

function Parse(Filter: string): TASTNode;


implementation

uses Constant;

procedure Split(const Separator: Char; const Value: string; var attrib, assertion: string);
var
  p, p0, p1: PChar;
begin
  p := PChar(Value);
  p0 := p;
  while (p^ <> #0) and (p^ <> Separator) do
    p := p + 1;
  SetString(attrib, p0, p - p0);
  inc(p);
  p1 := p;
  while (p1^ <> #0) do inc(p1);
  SetString(assertion, p, p1 - p);
end;

{ Tests whether data contains only safe chars }
function ValidChars(s: string): Boolean;
var
  p: PChar;
begin
  Result := true;
  p := PChar(s);
  while (p^ <> #0) do begin
    if p^ in InvalidAttrChars then
    begin
      Result := false;
      break;
    end;
    Inc(p);
  end;
end;

function CreateNodeItem(s: string): TAstNodeItem;
var
  i: Integer;
  Attribute, AssertionValue: string;
  FilterType: TFilterType;
begin
  i := Pos('=', s);
  Attribute := DecodeLdapString(Trim(Copy(s, 1, i - 1)));
  if (Attribute = '') or not ValidChars(Attribute) then
    raise Exception.CreateFmt(stInvalidFilter, [s]);
  AssertionValue := DecodeLdapString(Trim(Copy(s, i + 1, MaxInt)));

  case Attribute[i - 1] of
    ':':  // Extensible match
         begin
           System.Delete(Attribute, i - 1, 1);
           Result := TAstNodeItemExtensibleMatch.Create(Attribute, AssertionValue);
           exit;
         end;
    //'~': Approximate match is not supported, same as equality
    '>': // Greater or equal
         begin
           FilterType := ftGrEq;
           System.Delete(Attribute, i - 1, 1);
         end;
    '<': // Less or equal
              begin
                FilterType := ftLessEq;
                System.Delete(Attribute, i - 1, 1);
              end;
          else
            if AssertionValue = '*' then // presence
            begin
              Result := TAstNodeItemPresence.Create(Attribute, AssertionValue);
              exit;
            end
            else
              if Pos('*', AssertionValue) > 0 then // substrings
              begin
                Result := TAstNodeItemSubstring.Create(Attribute, AssertionValue);
                exit;
              end
              else
                FilterType := ftEqual;
          end;
    Result := TAstNodeItemEquality.Create(Attribute, AssertionValue, FilterType);
end;

function GetParented(s: string): string;
begin
  s := Trim(s);
  if s[1] <> '(' then
    raise Exception.CreateFmt(stExpectedAt, ['(', s]);
  if s[Length(s)] <> ')' then
    raise Exception.CreateFmt(stExpectedAt, [')', s]);
  Result := Trim(Copy(s, 2, Length(s) - 2));
end;

function GetFactor(s: string): TASTNode;
begin
  s := GetParented(s);
  if s='' then
    raise Exception.Create(stEmptyArg);
  case s[1] of
    '&': Result := TAstNodeAND.Create(Copy(s, 2, MaxInt));
    '|': Result := TAstNodeOR.Create(Copy(s, 2, MaxInt));
    '!': Result := TAstNodeNOT.Create(Copy(s, 2, MaxInt));
    '(': Result := GetFactor(s);
  else
    Result := CreateNodeItem(s);
  end;
end;

function Parse(Filter: string): TASTNode;
begin
  Result := GetFactor(Filter);
end;

{ TASTNodeFactor }

procedure TAstNodeFactor.GetFactorList(s: string);
var
  p1, p2: PChar;
  bc: Integer;
  x: string;

  function GetNext: TAstNode;
  begin
    bc := 0;
    repeat
      case p2^ of
        ')': begin
               dec(bc);
               if bc = 0 then
                 break
               else
               if bc < 0 then
                 raise Exception.Create(Format(stExpectedEndOfStr, [')', p2]));
             end;
        '(': inc(bc);
        #0: raise Exception.Create(Format(stMissingIn, [')', s]));
      end;
      p2 := p2 + 1;
    until false;
    p2 := p2 + 1;
    SetString(x, p1, p2 - p1);
    p1 := p2;
    Result := GetFactor(x);
  end;

begin
  s := Trim(s);
  p1 := PChar(s);
  p2 := p1;
  while p2^ <> #0 do
    fFactors.Add(GetNext);
end;

constructor TASTNodeFactor.Create(s: string);
begin
  inherited Create;
  fFactors := TObjectList.Create;
  GetFactorList(s);
end;

destructor TAstNodeFactor.Destroy;
begin
  fFactors.Free;
  inherited;
end;

procedure TASTNodeOR.ExecuteFilter(Session: TLdapSession; BaseNode: TEntryNode; const Scope: TLdapsearchScope; Result: TLdapEntryList);
var
  i, j: Integer;
  l: TLdapEntryList;
begin
  TAstNode(fFactors[0]).ExecuteFilter(Session, BaseNode, Scope, Result);
  l := TLdapEntryList.Create;
  try
    for i := 1 to fFactors.Count - 1 do
    begin
      TAstNode(fFactors[i]).ExecuteFilter(Session, BaseNode, Scope, l);
      for j := l.Count - 1 downto 0 do
        if Result.IndexOf(l[j].dn) = -1 then
        begin
          Result.Add(l[j]);
          l.Extract(j);
        end;
      l.Clear;
    end;
  finally
    l.Free;
  end;
end;

procedure TASTNodeAND.ExecuteFilter(Session: TLdapSession; BaseNode: TEntryNode; const Scope: TLdapsearchScope; Result: TLdapEntryList);
var
  i, j: Integer;
  l: TLdapEntryList;
begin
  TAstNode(fFactors[0]).ExecuteFilter(Session, BaseNode, Scope, Result);
  l := TLdapEntryList.Create;
  try
    for i := 1 to fFactors.Count - 1 do
    begin
      TAstNode(fFactors[i]).ExecuteFilter(Session, BaseNode, Scope, l);
      for j := Result.Count - 1 downto 0 do
      begin
        if l.IndexOf(Result[j].dn) = -1 then
          Result.Delete(j);
      end;
      l.Clear;
    end;
  finally
    l.Free;
  end;
end;

{ TAstNodeNOT }

constructor TASTNodeNot.Create(s: string);
begin
  inherited;
  if fFactors.Count > 1 then
    raise Exception.CreateFmt(StErrUnaryOp, ['!', s]);
end;

procedure TASTNodeNot.ExecuteFilter(Session: TLdapSession;
  BaseNode: TEntryNode; const Scope: TLdapsearchScope; Result: TLdapEntryList);
var
  l: TLdapEntryList;
  Entry: TLdapEntry;

  procedure Traverse(ANode: TEntryNode);
  var
    i, idx: Integer;
  begin
      for i := 0 to ANode.Children.Count - 1 do
        Traverse(ANode.Children[i] as TEntryNode);

      idx := l.IndexOf(ANode.dn);
      if idx = -1 then
      begin
        Entry := TLdapEntry.Create(Session, ANode.dn);
        ANode.Clone(Entry);
        Result.Add(Entry);
      end;
  end;

begin
  l := TLdapEntryList.Create;
  try
    TAstNode(fFactors[0]).ExecuteFilter(Session, BaseNode, Scope, l);
    Traverse(BaseNode);
  finally
    l.Free;
  end;
end;

{ TAstNodeItem }

procedure TAstNodeItem.AddEntry(ANode: TEntryNode);
var
  Entry: TLdapEntry;
begin
  Entry := TLdapEntry.Create(fSession, ANode.dn);
  ANode.Clone(Entry);
  fResult.Add(Entry);
end;

function TAstNodeItemEquality.CompareValue(AValue: string): Boolean;
var
  CompRes: Integer;
begin
  CompRes := AnsiCompareText(AValue, fAssertionValue);
  case fFilterType of
    ftEqual: Result := compRes = 0;
    ftGrEq: Result := (compRes >= 0);
    ftLessEq: Result := (compRes <= 0);
  else
    //Should actually never come here!
    raise Exception.Create('Internal error: TAstNodeItemEquality.CompareValue: Invalid operator!');
  end;
end;

procedure TAstNodeItem.Traverse(ANode: TEntryNode);
var
  i: Integer;
begin
  case fScope of
    lssBaseObject:
      begin
        DoCompare(ANode);
        exit;
      end;
    lssSingleLevel:
      begin
        for i := 0 to ANode.Children.Count - 1 do
          DoCompare(ANode.Children[i] as TEntryNode);
      end;
  else
    DoCompare(ANode);
    for i := 0 to ANode.Children.Count - 1 do
      Traverse(ANode.Children[i] as TEntryNode);
  end;
end;

constructor TAstNodeItem.Create(Attribute, AssertionValue: string);
begin
  inherited Create;
  fAttribute := Attribute;
  fAssertionValue := AssertionValue;
end;

procedure TAstNodeItem.ExecuteFilter(Session: TLdapSession; BaseNode: TEntryNode; const Scope: TLdapsearchScope; Result: TLdapEntryList);
begin
  fSession := Session;
  fScope := Scope;
  fResult := Result;
  Traverse(BaseNode);
end;

{ TAstNodeItemEquality }
procedure TAstNodeItemEquality.DoCompare(ANode: TEntryNode);
var
  i, j: Integer;
begin
  for i := 0 to ANode.Attributes.Count - 1 do with ANode.Attributes[i] do
    if AnsiSameText(fAttribute, Name) then
      for j := 0 to ValueCount - 1 do
        if CompareValue(ANode.Attributes[i].Values[j].AsString) then
        begin
          AddEntry(ANode);
          exit;
        end;
end;

constructor TAstNodeItemEquality.Create(Attribute, AssertionValue: string; FilterType: TFilterType);
begin
  inherited Create(Attribute, AssertionValue);
  fFilterType := FilterType;
end;

{ TAstNodeItemPresence }
procedure TAstNodeItemPresence.DoCompare(ANode: TEntryNode);
var
  i, j: Integer;
begin
for i := 0 to ANode.Attributes.Count - 1 do with ANode.Attributes[i] do
  if AnsiSameText(fAttribute, Name) then
    for j := 0 to ValueCount - 1 do
      if Values[j].DataSize > 0 then
      begin
        AddEntry(ANode);
        exit;
      end;
end;

{ TAstNodeItemSubstring }

function TAstNodeItemSubstring.Matches(Wildcard, Text: string): Boolean;

var

  pw, pt, pa: PChar;
  c: Char;
begin
  pw := PChar(lowercase(Wildcard));
  pt := PChar(lowercase(Text));

  while pw^ <> #0 do
  begin
    if pw^ = '*' then
    begin
      inc(pw);
      if pw^ = #0 then // ends with wildcard, the rest of the Text doesn't matter
      begin
        Result := true;
        exit;
      end;
      pa := pw;
      while (pw^ <> #0) and (pw^ <> '*') do
        inc(pw);
      c := pw^;
      pw^:= #0;
      if AnsiStrPos(pt, pa)= nil then
      begin
        Result := false;
        exit;
      end;
      pw^ := c;
      pt := pw;
      continue;
    end;

    if pw^ <> pt^ then
    begin
      Result := false;
      exit;
    end;
    inc(pw);
    inc(pt);
  end;
  Result := pt^ = pw^;
end;


procedure TAstNodeItemSubstring.DoCompare(ANode: TEntryNode);
var
  i, j: Integer;
begin
for i := 0 to ANode.Attributes.Count - 1 do with ANode.Attributes[i] do
  if AnsiSameText(fAttribute, Name) then
    for j := 0 to ValueCount - 1 do
      if Matches(fAssertionValue, Values[j].AsString) then
      begin
        AddEntry(ANode);
        exit;
      end;
end;

{ TASTNodeItemExtensibleMatch }

function TASTNodeItemExtensibleMatch.CompareValue(AValue: string): Boolean;
var
  c: Cardinal;
  e: Integer;
begin
  case fRule of
    etDefault: Result := AnsiSameText(AValue, fAssertionValue);
    etAnd,
    etOr:      begin
                 Val(AValue, c, e);
                 if e <> 0 then
                   raise Exception.CreateFmt(stArgDecNum, [AValue]);
                 if fRule = etAnd then
                   Result := (c and fData) <> 0
                 else
                   Result := (c or fData) <> 0;
               end;
    {etTransitive:
    etDnWithData:}
  else
    //Should actually never come here!
    raise Exception.Create('Internal error: TASTNodeItemExtensibleMatch.CompareValue: Ivalid rule!');
  end;
end;

function TASTNodeItemExtensibleMatch.CompareDn(adn: string): Boolean;
begin
  case fRule of
    etDefault: Result := Pos(fAssertionValue, adn) <> 0;
    etAnd,
    etOr:      raise Exception.Create(stBinaryMatchDn);
    {etTransitive:
    etDnWithData:}
  else
    //Should actually never come here!
    raise Exception.Create('Internal error: TASTNodeItemExtensibleMatch.CompareDnIvalid rule!');
  end;
end;

function TASTNodeItemExtensibleMatch.CompareName(AName: string): Boolean;
begin
  if fAttribute = '' then
    Result := true // Compare all attributes
  else
    Result := AnsiSameText(fAttribute, AName);
end;

procedure TASTNodeItemExtensibleMatch.DoCompare(ANode: TEntryNode);
var
  i, j: Integer;
begin
  if fDn and CompareDn(ANode.dn) then
  begin
    AddEntry(ANode);
    exit;
  end;

  for i := 0 to ANode.Attributes.Count - 1 do with ANode.Attributes[i] do
    if CompareName(Name) then
      for j := 0 to ValueCount - 1 do
        if CompareValue(ANode.Attributes[i].Values[j].AsString) then
        begin
          AddEntry(ANode);
          exit;
        end;
end;

constructor TASTNodeItemExtensibleMatch.Create(Attribute, AssertionValue: string);
var
  i, e: Integer;
  Rule: string;
begin
  i := Pos(':dn', Attribute);
  if i > 0 then
  begin
    fdn := True;
    System.Delete(Attribute, i, 3);
  end;
  i := Pos(':', Attribute);
  if i = 0 then
    fRule := etDefault
  else begin
    Rule := Trim(Copy(Attribute, i + 1, MaxInt)); // Right side
    if Rule = LDAP_MATCHING_RULE_BIT_AND then
      fRule := etAnd
    else
    if Rule = LDAP_MATCHING_RULE_BIT_OR then
      fRule := etOr
    else
    if Rule = LDAP_MATCHING_RULE_TRANSITIVE_EVAL then
      fRule := etTransitive
    else
    if Rule = LDAP_MATCHING_RULE_DN_WITH_DATA then
      fRule := etDnWithData
    else
      raise Exception.CreateFmt(stUnsupportedRule, [Rule]);
    if fRule in [etAnd, etOr] then
    begin
      Val(AssertionValue, fData, e);
      if e <> 0 then
        raise Exception.CreateFmt(stAssertDecNum, [AssertionValue]);
    end;
    Attribute := Trim(Copy(Attribute, 1, i - 1)); // Left side
  end;
  inherited Create(Attribute, AssertionValue);
end;

end.
