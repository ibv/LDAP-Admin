unit Input;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
{$IFnDEF FPC}
  Windows,
{$ELSE}
  LCLIntf, LCLType, LMessages,
{$ENDIF}
  SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ExtCtrls;

type
  TInputDlg = class(TForm)
    OKBtn: TButton;
    CancelBtn: TButton;
    Edit: TEdit;
    Prompt: TLabel;
    procedure EditChange(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

function InputDlg(ACaption, APrompt: string; var AValue: string; PasswordChar: Char=#0; AcceptEmpty:Boolean=False): Boolean;

implementation

{$R *.dfm}

function InputDlg(ACaption, APrompt: string; var AValue: string; PasswordChar: Char=#0; AcceptEmpty:Boolean=False): Boolean;
begin
  Result := false;
  with TInputDlg.Create(Application) do
  begin
    if AcceptEmpty then
      Edit.OnChange := nil
    else
      OKBtn.Enabled := false;
    Caption := ACaption;
    Prompt.Caption := APrompt;
    Edit.Text := AValue;
    Edit.PasswordChar := PasswordChar;
    if ShowModal = mrOk then
    begin
      AValue := Edit.Text;
      Result := true
    end;
    Free;
  end;
end;

procedure TInputDlg.EditChange(Sender: TObject);
begin
  OkBtn.Enabled := Edit.Text <> '';
end;

end.
