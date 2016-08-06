program LdapAdmin;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

uses
{$IFnDEF FPC}
{$ELSE}
  cthreads,
  //cmem,
  Interfaces,
{$ENDIF}
  Forms,
  Main in 'Main.pas' {MainFrm},
  User in 'User.pas' {UserDlg},
{$IFNDEF FPC}
  WinLDAP in 'WinLDAP.pas',
{$ELSE}
  LinLDAP in 'LinLDAP.pas',
{$ENDIF}
  LDAPClasses in 'LDAPClasses.pas',
  EditEntry in 'EditEntry.pas' {EditEntryFrm},
  Input in 'Input.pas' {InputDlg},
  Constant in 'Constant.pas',
  Pickup in 'Pickup.pas' {PickupDlg},
  ConnProp in 'ConnProp.pas' {ConnPropDlg},
  PassDlg in 'PassDlg.pas' {PasswordDlg},
  smbdes in 'smbdes.pas',
  ConnList in 'ConnList.pas' {ConnListFrm},
  Group in 'Group.pas' {GroupDlg},
  Computer in 'Computer.pas' {ComputerDlg},
  Transport in 'Transport.pas' {TransportDlg},
  Search in 'Search.pas' {SearchFrm},
  Ou in 'Ou.pas' {OuDlg},
  Export in 'Export.pas' {ExportDlg},
  Prefs in 'Prefs.pas' {PrefDlg},
  Samba in 'Samba.pas',
  Posix in 'Posix.pas',
  PrefWiz in 'PrefWiz.pas' {PrefWizDlg},
  About in 'About.pas' {AboutDlg},
  LdapOp in 'LdapOp.pas' {LdapOpDlg},
  Import in 'Import.pas' {ImportDlg},
  Ldif in 'Ldif.pas',
  Misc in 'Misc.pas',
  Postfix in 'Postfix.pas',
  MailGroup in 'MailGroup.pas' {MailGroupDlg},
  Host in 'Host.pas' {HostDlg},
  Locality in 'Locality.pas' {LocalityDlg},
  LdapCopy in 'LdapCopy.pas' {CopyDlg},
  InetOrg in 'InetOrg.pas',
  PropertyObject in 'PropertyObject.pas',
  Shadow in 'Shadow.pas',
  password in 'password.pas',
  uSchemaDlg in 'uSchemaDlg.pas' {SchemaDlg},
  Schema in 'Schema.pas',
  BinView in 'BinView.pas' {HexView},
  AdvSamba in 'AdvSamba.pas' {SambaAdvancedDlg},
  TextFile in 'TextFile.pas',
  md5crypt in 'md5crypt.pas',
  Config in 'Config.pas',
  IControls in 'IControls.pas',
  Xml in 'Xml.pas',
  Templates in 'Templates.pas',
  TemplateCtrl in 'TemplateCtrl.pas',
  ConfigDlg in 'ConfigDlg.pas' {ConfigDlg},
  PickAttr in 'PickAttr.pas' {PickAttributesDlg},
  uAccountCopyDlg in 'uAccountCopyDlg.pas' {AccountCopyDlg},
  LAControls in 'LAControls.pas',
  Events in 'Events.pas',
  Core in 'Core.pas',
  Cert in 'Cert.pas',
  Dsml in 'Dsml.pas',
  Gss in 'Gss.pas',
  uBetaImgLists in 'uBetaImgLists.pas',
  Params in 'Params.pas',
  PicView in 'PicView.pas' {ViewPicFrm},
  Sorter in 'Sorter.pas',
  ShaCrypt in 'ShaCrypt.pas',
  ParseErr in 'ParseErr.pas' {ParseErrDlg},
  //---ScriptIntf in 'ScriptIntf.pas',
  Script in 'Script.pas',
  GraphicHint in 'GraphicHint.pas',
  Connection in 'Connection.pas',
  adsie in 'adsie.pas',
  ADPassDlg in 'ADPassDlg.pas' {ADPassDlg},
  Alias in 'Alias.pas' {AliasDlg},
  SizeGrip in 'SizeGrip.pas',
  CustomMenus in 'CustomMenus.pas',
  CustMenuDlg in 'CustMenuDlg.pas' {CustomMenuDlg},
  ObjectInfo in 'ObjectInfo.pas',
  XmlLoader in 'XmlLoader.pas',
  Lang in 'Lang.pas',
  ///VCLFixes in 'VCLFixes.pas',
  ListViewDlg in 'ListViewDlg.pas' {ListViewDlg},
  Bookmarks in 'Bookmarks.pas' {BookmarkDlg},
  ast in 'ast.pas',
  DBLoad in 'DBLoad.pas' {DBLoadDlg},
  DlgWrap in 'DlgWrap.pas',
  EncodedDn in 'EncodedDn.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TMainFrm, MainFrm);
  Application.Run;
end.
