  {      LDAPAdmin - Events.pas
  *      Copyright (C) 2006 Alexander Sokoloff
  *
  *      Author: Alexander Sokoloff
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

unit Events;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses Classes, Controls, SysUtils;

type
  TCustomEvents=class
  private
    function GetCount: integer;
  protected
    Items:      array of TMethod;
    procedure   DoAdd(Event: TMethod);
    procedure   DoDelete(Event: TMethod);
    function    IndexOf(Event: TMethod): integer;
    property    Count: integer read GetCount;
   public
    constructor Create; reintroduce;
    destructor  Destroy; override;
  end;

  TNotifyEvents=class(TCustomEvents)
  public
    procedure   Add(Event: TNotifyEvent);
    procedure   Delete(Event: TNotifyEvent);
    procedure   Execute(Sender: TObject);
  end;

  TKeyPressEvents=class(TCustomEvents)
  public
    procedure   Add(Event: TKeyPressEvent);
    procedure   Delete(Event: TKeyPressEvent);
    procedure   Execute(Sender: TObject; var Key: Char);
  end;

implementation

{ TCustomEvents }

constructor TCustomEvents.Create;
begin
  inherited;
  setlength(Items, 0);
end;

destructor TCustomEvents.Destroy;
begin
  inherited;
end;

procedure TCustomEvents.DoAdd(Event: TMethod);
begin
  setlength(Items, length(Items)+1);
  Items[length(Items)-1]:=Event;
end;

procedure TCustomEvents.DoDelete(Event: TMethod);
var
  i, idx: integer;
begin
  idx:=IndexOf(Event);
  if idx<0 then exit;
  for i:=idx to Count-2 do Items[i]:=Items[i+1];
  setlength(Items, Count-1);
end;

function TCustomEvents.GetCount: integer;
begin
  result:=length(Items);
end;

function TCustomEvents.IndexOf(Event: TMethod): integer;
var
  i: integer;
begin
  result:=-1;
  for i:=0 to Count-1 do begin
    if (Items[i].Code=Event.Code) and (Items[i].Data=Event.Data) then begin
      result:=i;
      exit;
    end;
  end;
end;

{ TNotifyEvents }

procedure TNotifyEvents.Add(Event: TNotifyEvent);
begin
  DoAdd(TMethod(Event));
end;

procedure TNotifyEvents.Delete(Event: TNotifyEvent);
begin
  DoDelete(TMethod(Event));
end;

procedure TNotifyEvents.Execute(Sender: TObject);
var
  i: integer;
begin
  for i := Count - 1 downto 0 do
    TNotifyEvent(Items[i])(Sender);
end;

{ TKeyPressEvents }

procedure TKeyPressEvents.Add(Event: TKeyPressEvent);
begin
  DoAdd(TMethod(Event));
end;

procedure TKeyPressEvents.Delete(Event: TKeyPressEvent);
begin
  DoDelete(TMethod(Event));
end;

procedure TKeyPressEvents.Execute(Sender: TObject; var Key: Char);
var
  i: integer;
begin
  for i:=0 to Count-1 do
    TKeyPressEvent(Items[i])(Sender, Key);
end;

end.
