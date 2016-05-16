  {      LDAPAdmin - Dsml.pas
  *      Copyright (C) 2003-2013 Tihomir Karlovic
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

unit Dsml;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses Xml, LDAPClasses, Classes;

type
  TDsmlTree = class(TXmlTree)
  private
    fEntries: TLdapEntryList;
  public
    constructor Create(Entries: TLdapEntryList); reintroduce;
    procedure   LoadFromStream(const Stream: TStream); override;
    procedure   SaveToStream(const Stream: TStream; StreamCallback: TStreamCallback = nil); override;
  end;

implementation

uses Sysutils, WinBase64;

constructor TDsmlTree.Create;
begin
  inherited Create;
  Utf8 := true;
  fEntries := Entries;
end;

procedure TDsmlTree.LoadFromStream(const Stream: TStream);
begin
  raise Exception.Create('Not implemented!');
end;

procedure TDsmlTree.SaveToStream(const Stream: TStream; StreamCallback: TStreamCallback = nil);
var
  i, j, k: Integer;
  OC: TLdapAttribute;
  Node: TxmlNode;

  procedure XmlAddValue(Node: TXmlNode; Value: TLdapAttributeData);
  var
    v: string;
  begin
    if Value.DataType = dtBinary then
    begin
      SetLength(v, Base64encSize(Value.DataSize));
      Base64Encode(Pointer(Value.Data)^, Value.DataSize, v[1]);
      Node.Attributes.Add('encoding=base64');
    end
    else
      v := Value.AsString;
    Node.Add('value', v);
  end;


begin
    Markups := true;
    Root.Name := 'dsml:dsml';
    Root.Attributes.Add('xmlns:dsml=http://www.dsml.org/DSML');
    for i := 0 to fEntries.Count - 1 do
    begin
      with Root.Add('directory-entry') do
      begin
        Attributes.Add('dn=' + fEntries[i].dn);
        { write objectclasses }
        OC := fEntries[i].AttributesByName['objectclass'];
        if Assigned(OC) then with Add('objectclass') do
          for j := 0 to OC.ValueCount - 1 do
            Add('oc-value', OC[j].AsString);
        { write attributes }
        for j := 0 to fEntries[i].Attributes.Count - 1 do with fEntries[i].Attributes[j] do
        begin
          if ValueCount > 0 then
          begin
            if lowercase(Name) = 'objectclass' then
              Continue;
            Node := Add('attr');
            Node.Attributes.Add('name=' + Name);
            for k := 0 to ValueCount - 1 do
              XmlAddValue(Node, Values[k]);
          end;
        end;
      end;
    end;

    inherited; // do actual write

end;

end.
