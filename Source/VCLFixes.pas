unit VCLFixes;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

implementation

uses
  LCLIntf, LCLType, LMessages,
  Messages, Controls, Dialogs;

// WMDrawItem fails under WOW64, see http://qc.codegear.com/wc/qcmain.aspx?d=19859

{$IFDEF VER150} // Delphi7

function GetMethodAddress(AMessageID: Word; AClass: TClass; out MethodAddr: Pointer): Boolean;
var
  DynamicTableAddress: Pointer;
  MethodEntry: ^Pointer;
  MessageHandlerList: PWord;
  EntryCount, EntryIndex: Word;
begin
  Result := False;

  DynamicTableAddress := Pointer(PInteger(Integer(AClass) + vmtDynamicTable)^);
  MessageHandlerList := PWord(DynamicTableAddress);
  EntryCount := MessageHandlerList^;

  if EntryCount > 0 then
  for EntryIndex := EntryCount - 1 downto 0 do
  begin
    Inc(MessageHandlerList);
    if (MessageHandlerList^ = AMessageID) then
    begin
      Inc(MessageHandlerList);
      MethodEntry := Pointer(Integer(MessageHandlerList) + 2 * (2 * EntryCount - EntryIndex) - 4);
      MethodAddr := MethodEntry^;
      Result := True;
    end;
  end;
end;

function PatchInstructionByte(MethodAddress: Pointer; ExpectedOffset: Cardinal;
  ExpectedValue: Byte; NewValue: Byte): Boolean;
var
  BytePtr: PByte;
  OldProtect: Cardinal;
begin
  Result := False;

  BytePtr := PByte(Cardinal(MethodAddress) + ExpectedOffset);

  if BytePtr^ = NewValue then
  begin
    Result := True;
    Exit;
  end;

  if BytePtr^ <> ExpectedValue then
    Exit;

  if VirtualProtect(BytePtr, SizeOf(BytePtr^), PAGE_EXECUTE_READWRITE, OldProtect) then
  begin
    try
      BytePtr^ := NewValue;
      Result := True;
    finally
      Result := Result
                and VirtualProtect(BytePtr, SizeOf(BytePtr^), OldProtect, OldProtect)
                and FlushInstructionCache(GetCurrentProcess, BytePtr, SizeOf(BytePtr^));
    end;
  end;
end;

function PatchInstructionBytes(MethodAddress: Pointer; ExpectedOffset: Cardinal;
const ExpectedValues: array of Byte; const NewValues: array of Byte;
const PatchedValues: array of Byte): Boolean;
var
  BytePtr, TestPtr: PByte;
  OldProtect, Index, PatchSize: Cardinal;
begin
  BytePtr := PByte(Cardinal(MethodAddress) + ExpectedOffset);

  Result := True;
  TestPtr := BytePtr;
  for Index := Low(PatchedValues) to High(PatchedValues) do
  begin
    if TestPtr^ <> PatchedValues[Index] then
    begin
      Result := False;
      Break;
    end;
    Inc(TestPtr);
  end;

  if Result then
    Exit;

  Result := True;
  TestPtr := BytePtr;
  for Index := Low(ExpectedValues) to High(ExpectedValues) do
  begin
    if TestPtr^ <> ExpectedValues[Index] then
    begin
      Result := False;
      Exit;
    end;
    Inc(TestPtr);
  end;

  PatchSize := Length(NewValues) * SizeOf(Byte);

  if VirtualProtect(BytePtr, PatchSize, PAGE_EXECUTE_READWRITE, OldProtect) then
  begin
    try
      TestPtr := BytePtr;
      for Index := Low(NewValues) to High(NewValues) do
      begin
        TestPtr^ := NewValues[Index];
        Inc(TestPtr);
      end;
      Result := True;
    finally
      Result := Result
                and VirtualProtect(BytePtr, PatchSize, OldProtect, OldProtect)
                and FlushInstructionCache(GetCurrentProcess, BytePtr, PatchSize);
    end;
  end;
end;

procedure PatchWinControl;
var
  MethodAddress: Pointer;
begin
  if not GetMethodAddress(WM_DRAWITEM, TWinControl, MethodAddress) then
  begin
    ShowMessage('Cannot find WM_DRAWITEM handler in TWinControl');
    Exit;
  end;
  if (not PatchInstructionByte(MethodAddress, 13, $4, $14)) // release and package
      and (not PatchInstructionByte(MethodAddress, 23, $4, $14)) then // debug
    ShowMessage('Cannot patch WM_DRAWITEM');

  if not GetMethodAddress(WM_COMPAREITEM, TWinControl, MethodAddress) then
  begin
    ShowMessage('Cannot find WM_COMPAREITEM handler in TWinControl');
    Exit;
  end;
  if (not PatchInstructionByte(MethodAddress, 13, $04, $8)) // release and package
      and (not PatchInstructionByte(MethodAddress, 23, $04, $8)) then // debug
    ShowMessage('Cannot patch WM_COMPAREITEM handler');

  if not GetMethodAddress(WM_DELETEITEM, TWinControl, MethodAddress) then
  begin
    ShowMessage('Cannot find WM_DELETEITEM handler in TWinControl');
    Exit;
  end;
  if (not PatchInstructionByte(MethodAddress, 13, $04, $0C)) // release and package
      and (not PatchInstructionByte(MethodAddress, 23, $04, $0C)) then // debug
    ShowMessage('Cannot patch WM_DELETEITEM handler');

  if not GetMethodAddress(WM_MEASUREITEM, TWinControl, MethodAddress) then
  begin
     ShowMessage('Cannot find WM_MEASUREITEM handler in TWinControl');
    Exit;
  end;
  if (not PatchInstructionBytes(MethodAddress, 10, [$08, $8B], [$04, $90, $90, $90], [$04, $E8])) // release and package
      and (not PatchInstructionBytes(MethodAddress, 20, [$08, $8B], [$04, $90, $90, $90], [$04, $E8])) then // debug
    ShowMessage('Cannot patch WM_MEASUREITEM handler');
end;

{$ENDIF}

// end of "WMDrawItem fails under WOW64" patch
// --------------------------------------------------------------------------------

initialization
{$IFDEF VER150} // Delphi7
  PatchWinControl;
{$ENDIF}

end.
