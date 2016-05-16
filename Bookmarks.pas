unit Bookmarks;

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
  Buttons, ExtCtrls, ComCtrls, Connection;

type
  TBookmarkDlg = class(TForm)
    btnClose: TButton;
    edBookmark: TEdit;
    lblBookmark: TLabel;
    BookmarkList: TListView;
    btnRemove: TBitBtn;
    btnAdd: TBitBtn;
    procedure BookmarkListSelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure edBookmarkChange(Sender: TObject);
    procedure btnAddClick(Sender: TObject);
  private
    { Private declarations }
  public
    constructor Create(AOwner: TComponent; dn: string; Connection: TConnection); reintroduce;
  end;

var
  BookmarkDlg: TBookmarkDlg;

implementation

{$IFnDEF FPC}
  {$R *.dfm}
{$ELSE}
  {$R *.lfm}
{$ENDIF}

constructor TBookmarkDlg.Create(AOwner: TComponent; dn: string; Connection: TConnection);
begin
  inherited Create(AOwner);
  edBookmark.Text := dn;
end;

procedure TBookmarkDlg.BookmarkListSelectItem(Sender: TObject; Item: TListItem; Selected: Boolean);
begin
  btnRemove.Enabled := true;
end;

procedure TBookmarkDlg.edBookmarkChange(Sender: TObject);
begin
  btnAdd.Enabled := edBookmark.text <> '';
end;

procedure TBookmarkDlg.btnAddClick(Sender: TObject);
begin
  BookmarkList.Items.Add.Caption := edBookmark.Text;
end;

end.
