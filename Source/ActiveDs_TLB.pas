unit ActiveDs_TLB;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

// ************************************************************************ //
// WARNUNG                                                                    
// -------                                                                    
// Die in dieser Datei deklarierten Typen wurden aus Daten einer Typbibliothek
// generiert. Wenn diese Typbibliothek explizit oder indirekt (über eine     
// andere Typbibliothek) reimportiert wird oder wenn die Anweisung            
// 'Aktualisieren' im Typbibliotheks-Editor während des Bearbeitens der     
// Typbibliothek aktiviert ist, wird der Inhalt dieser neu generiert und alle 
// manuell vorgenommenen Änderungen gehen verloren.                           
// ************************************************************************ //

// PASTLWTR : $Revision:   1.88.1.0.1.0  $
// Datei generiert am 30.04.2012 15:31:15 aus der unten beschriebenen Typbibliothek.

// ************************************************************************ //
// Typbib: C:\WINDOWS\system32\activeds.tlb (1)
// IID\LCID: {97D25DB0-0363-11CF-ABC4-02608C9E7553}\0
// Hilfedatei: 
// AbhLst: 
//   (1) v2.0 stdole, (C:\WINDOWS\system32\STDOLE2.TLB)
//   (2) v4.0 StdVCL, (C:\WINDOWS\system32\stdvcl40.dll)
// Fehler
//   Hinweis: Element 'RawUtf8' von '_ADS_CASEIGNORE_LIST' geändert zu 'String_'
//   Hinweis: Element 'Type' von '__MIDL___MIDL_itf_ads_0000_0005' geändert zu 'Type_'
//   Hinweis: Element 'Type' von '__MIDL___MIDL_itf_ads_0000_0014' geändert zu 'Type_'
//   Hinweis: Element 'Class' von 'IADs' geändert zu 'Class_'
//   Hinweis: Element 'Set' von 'IADsNameTranslate' geändert zu 'Set_'
//   Hinweis: Element 'Type' von 'IADsEmail' geändert zu 'Type_'
//   Hinweis: Element 'Type' von 'IADsPath' geändert zu 'Type_'
//   Hinweis: Element 'Set' von 'IADsPathname' geändert zu 'Set_'
// ************************************************************************ //
{$TYPEDADDRESS OFF} // Unit muss ohne typüberprüfte Zeiger compiliert werden. 
interface

uses
  ActiveX, OleServer,
  LCLIntf, LCLType, LMessages,
  Classes, Graphics;

// *********************************************************************//
// In dieser Typbibliothek deklarierte GUIDS . Es werden folgende         
// Präfixe verwendet:                                                     
//   Typbibliotheken     : LIBID_xxxx                                     
//   CoClasses           : CLASS_xxxx                                     
//   DISPInterfaces      : DIID_xxxx                                      
//   Non-DISP interfaces : IID_xxxx                                       
// *********************************************************************//
const
  // Haupt- und Nebenversionen der Typbibliothek
  ActiveDsMajorVersion = 1;
  ActiveDsMinorVersion = 0;

  LIBID_ActiveDs: TGUID = '{97D25DB0-0363-11CF-ABC4-02608C9E7553}';

  IID_IADs: TGUID = '{FD8256D0-FD15-11CE-ABC4-02608C9E7553}';
  IID_IADsContainer: TGUID = '{001677D0-FD16-11CE-ABC4-02608C9E7553}';
  IID_IADsCollection: TGUID = '{72B945E0-253B-11CF-A988-00AA006BC149}';
  IID_IADsMembers: TGUID = '{451A0030-72EC-11CF-B03B-00AA006E0975}';
  IID_IADsPropertyList: TGUID = '{C6F602B6-8F69-11D0-8528-00C04FD8D503}';
  IID_IADsPropertyEntry: TGUID = '{05792C8E-941F-11D0-8529-00C04FD8D503}';
  CLASS_PropertyEntry: TGUID = '{72D3EDC2-A4C4-11D0-8533-00C04FD8D503}';
  IID_IADsPropertyValue: TGUID = '{79FA9AD0-A97C-11D0-8534-00C04FD8D503}';
  IID_IADsPropertyValue2: TGUID = '{306E831C-5BC7-11D1-A3B8-00C04FB950DC}';
  CLASS_PropertyValue: TGUID = '{7B9E38B0-A97C-11D0-8534-00C04FD8D503}';
  IID_IPrivateDispatch: TGUID = '{86AB4BBE-65F6-11D1-8C13-00C04FD8D503}';
  IID_ITypeInfo: TGUID = '{00020401-0000-0000-C000-000000000046}';
  IID_ITypeComp: TGUID = '{00020403-0000-0000-C000-000000000046}';
  IID_ITypeLib: TGUID = '{00020402-0000-0000-C000-000000000046}';
  IID_IPrivateUnknown: TGUID = '{89126BAB-6EAD-11D1-8C18-00C04FD8D503}';
  IID_IADsExtension: TGUID = '{3D35553C-D2B0-11D1-B17B-0000F87593A0}';
  IID_IADsDeleteOps: TGUID = '{B2BD0902-8878-11D1-8C21-00C04FD8D503}';
  IID_IADsNamespaces: TGUID = '{28B96BA0-B330-11CF-A9AD-00AA006BC149}';
  IID_IADsClass: TGUID = '{C8F93DD0-4AE0-11CF-9E73-00AA004A5691}';
  IID_IADsProperty: TGUID = '{C8F93DD3-4AE0-11CF-9E73-00AA004A5691}';
  IID_IADsSyntax: TGUID = '{C8F93DD2-4AE0-11CF-9E73-00AA004A5691}';
  IID_IADsLocality: TGUID = '{A05E03A2-EFFE-11CF-8ABC-00C04FD8D503}';
  IID_IADsO: TGUID = '{A1CD2DC6-EFFE-11CF-8ABC-00C04FD8D503}';
  IID_IADsOU: TGUID = '{A2F733B8-EFFE-11CF-8ABC-00C04FD8D503}';
  IID_IADsDomain: TGUID = '{00E4C220-FD16-11CE-ABC4-02608C9E7553}';
  IID_IADsComputer: TGUID = '{EFE3CC70-1D9F-11CF-B1F3-02608C9E7553}';
  IID_IADsComputerOperations: TGUID = '{EF497680-1D9F-11CF-B1F3-02608C9E7553}';
  IID_IADsGroup: TGUID = '{27636B00-410F-11CF-B1FF-02608C9E7553}';
  IID_IADsUser: TGUID = '{3E37E320-17E2-11CF-ABC4-02608C9E7553}';
  IID_IADsPrintQueue: TGUID = '{B15160D0-1226-11CF-A985-00AA006BC149}';
  IID_IADsPrintQueueOperations: TGUID = '{124BE5C0-156E-11CF-A986-00AA006BC149}';
  IID_IADsPrintJob: TGUID = '{32FB6780-1ED0-11CF-A988-00AA006BC149}';
  IID_IADsPrintJobOperations: TGUID = '{9A52DB30-1ECF-11CF-A988-00AA006BC149}';
  IID_IADsService: TGUID = '{68AF66E0-31CA-11CF-A98A-00AA006BC149}';
  IID_IADsServiceOperations: TGUID = '{5D7B33F0-31CA-11CF-A98A-00AA006BC149}';
  IID_IADsFileService: TGUID = '{A89D1900-31CA-11CF-A98A-00AA006BC149}';
  IID_IADsFileServiceOperations: TGUID = '{A02DED10-31CA-11CF-A98A-00AA006BC149}';
  IID_IADsFileShare: TGUID = '{EB6DCAF0-4B83-11CF-A995-00AA006BC149}';
  IID_IADsSession: TGUID = '{398B7DA0-4AAB-11CF-AE2C-00AA006EBFB9}';
  IID_IADsResource: TGUID = '{34A05B20-4AAB-11CF-AE2C-00AA006EBFB9}';
  IID_IADsOpenDSObject: TGUID = '{DDF2891E-0F9C-11D0-8AD4-00C04FD8D503}';
  IID_IDirectoryObject: TGUID = '{E798DE2C-22E4-11D0-84FE-00C04FD8D503}';
  IID_IDirectorySearch: TGUID = '{109BA8EC-92F0-11D0-A790-00C04FD8D5A8}';
  IID_IDirectorySchemaMgmt: TGUID = '{75DB3B9C-A4D8-11D0-A79C-00C04FD8D5A8}';
  IID_IADsAggregatee: TGUID = '{1346CE8C-9039-11D0-8528-00C04FD8D503}';
  IID_IADsAggregator: TGUID = '{52DB5FB0-941F-11D0-8529-00C04FD8D503}';
  IID_IADsAccessControlEntry: TGUID = '{B4F3A14C-9BDD-11D0-852C-00C04FD8D503}';
  CLASS_AccessControlEntry: TGUID = '{B75AC000-9BDD-11D0-852C-00C04FD8D503}';
  IID_IADsAccessControlList: TGUID = '{B7EE91CC-9BDD-11D0-852C-00C04FD8D503}';
  CLASS_AccessControlList: TGUID = '{B85EA052-9BDD-11D0-852C-00C04FD8D503}';
  IID_IADsSecurityDescriptor: TGUID = '{B8C787CA-9BDD-11D0-852C-00C04FD8D503}';
  CLASS_SecurityDescriptor: TGUID = '{B958F73C-9BDD-11D0-852C-00C04FD8D503}';
  IID_IADsLargeInteger: TGUID = '{9068270B-0939-11D1-8BE1-00C04FD8D503}';
  CLASS_LargeInteger: TGUID = '{927971F5-0939-11D1-8BE1-00C04FD8D503}';
  IID_IADsNameTranslate: TGUID = '{B1B272A3-3625-11D1-A3A4-00C04FB950DC}';
  CLASS_NameTranslate: TGUID = '{274FAE1F-3626-11D1-A3A4-00C04FB950DC}';
  IID_IADsCaseIgnoreList: TGUID = '{7B66B533-4680-11D1-A3B4-00C04FB950DC}';
  CLASS_CaseIgnoreList: TGUID = '{15F88A55-4680-11D1-A3B4-00C04FB950DC}';
  IID_IADsFaxNumber: TGUID = '{A910DEA9-4680-11D1-A3B4-00C04FB950DC}';
  CLASS_FaxNumber: TGUID = '{A5062215-4681-11D1-A3B4-00C04FB950DC}';
  IID_IADsNetAddress: TGUID = '{B21A50A9-4080-11D1-A3AC-00C04FB950DC}';
  CLASS_NetAddress: TGUID = '{B0B71247-4080-11D1-A3AC-00C04FB950DC}';
  IID_IADsOctetList: TGUID = '{7B28B80F-4680-11D1-A3B4-00C04FB950DC}';
  CLASS_OctetList: TGUID = '{1241400F-4680-11D1-A3B4-00C04FB950DC}';
  IID_IADsEmail: TGUID = '{97AF011A-478E-11D1-A3B4-00C04FB950DC}';
  CLASS_Email: TGUID = '{8F92A857-478E-11D1-A3B4-00C04FB950DC}';
  IID_IADsPath: TGUID = '{B287FCD5-4080-11D1-A3AC-00C04FB950DC}';
  CLASS_Path: TGUID = '{B2538919-4080-11D1-A3AC-00C04FB950DC}';
  IID_IADsReplicaPointer: TGUID = '{F60FB803-4080-11D1-A3AC-00C04FB950DC}';
  CLASS_ReplicaPointer: TGUID = '{F5D1BADF-4080-11D1-A3AC-00C04FB950DC}';
  IID_IADsAcl: TGUID = '{8452D3AB-0869-11D1-A377-00C04FB950DC}';
  IID_IADsTimestamp: TGUID = '{B2F5A901-4080-11D1-A3AC-00C04FB950DC}';
  CLASS_Timestamp: TGUID = '{B2BED2EB-4080-11D1-A3AC-00C04FB950DC}';
  IID_IADsPostalAddress: TGUID = '{7ADECF29-4680-11D1-A3B4-00C04FB950DC}';
  CLASS_PostalAddress: TGUID = '{0A75AFCD-4680-11D1-A3B4-00C04FB950DC}';
  IID_IADsBackLink: TGUID = '{FD1302BD-4080-11D1-A3AC-00C04FB950DC}';
  CLASS_BackLink: TGUID = '{FCBF906F-4080-11D1-A3AC-00C04FB950DC}';
  IID_IADsTypedName: TGUID = '{B371A349-4080-11D1-A3AC-00C04FB950DC}';
  CLASS_TypedName: TGUID = '{B33143CB-4080-11D1-A3AC-00C04FB950DC}';
  IID_IADsHold: TGUID = '{B3EB3B37-4080-11D1-A3AC-00C04FB950DC}';
  CLASS_Hold: TGUID = '{B3AD3E13-4080-11D1-A3AC-00C04FB950DC}';
  IID_IADsObjectOptions: TGUID = '{46F14FDA-232B-11D1-A808-00C04FD8D5A8}';
  IID_IADsPathname: TGUID = '{D592AED4-F420-11D0-A36E-00C04FB950DC}';
  CLASS_Pathname: TGUID = '{080D0D78-F421-11D0-A36E-00C04FB950DC}';
  IID_IADsADSystemInfo: TGUID = '{5BB11929-AFD1-11D2-9CB9-0000F87A369E}';
  CLASS_ADSystemInfo: TGUID = '{50B6327F-AFD1-11D2-9CB9-0000F87A369E}';
  IID_IADsWinNTSystemInfo: TGUID = '{6C6D65DC-AFD1-11D2-9CB9-0000F87A369E}';
  CLASS_WinNTSystemInfo: TGUID = '{66182EC4-AFD1-11D2-9CB9-0000F87A369E}';
  IID_IADsDNWithBinary: TGUID = '{7E99C0A2-F935-11D2-BA96-00C04FB6D0D1}';
  CLASS_DNWithBinary: TGUID = '{7E99C0A3-F935-11D2-BA96-00C04FB6D0D1}';
  IID_IADsDNWithString: TGUID = '{370DF02E-F934-11D2-BA96-00C04FB6D0D1}';
  CLASS_DNWithString: TGUID = '{334857CC-F934-11D2-BA96-00C04FB6D0D1}';
  IID_IADsSecurityUtility: TGUID = '{A63251B2-5F21-474B-AB52-4A8EFAD10895}';
  CLASS_ADsSecurityUtility: TGUID = '{F270C64A-FFB8-4AE4-85FE-3A75E5347966}';

// *********************************************************************//
// Deklaration von in der Typbibliothek definierten Enumerationen         
// *********************************************************************//
// Konstanten für enum __MIDL___MIDL_itf_ads_0000_0001
///type
  ///__MIDL___MIDL_itf_ads_0000_0001 = TOleEnum;
const
  ADSTYPE_INVALID = $00000000;
  ADSTYPE_DN_STRING = $00000001;
  ADSTYPE_CASE_EXACT_STRING = $00000002;
  ADSTYPE_CASE_IGNORE_STRING = $00000003;
  ADSTYPE_PRINTABLE_STRING = $00000004;
  ADSTYPE_NUMERIC_STRING = $00000005;
  ADSTYPE_BOOLEAN = $00000006;
  ADSTYPE_INTEGER = $00000007;
  ADSTYPE_OCTET_STRING = $00000008;
  ADSTYPE_UTC_TIME = $00000009;
  ADSTYPE_LARGE_INTEGER = $0000000A;
  ADSTYPE_PROV_SPECIFIC = $0000000B;
  ADSTYPE_OBJECT_CLASS = $0000000C;
  ADSTYPE_CASEIGNORE_LIST = $0000000D;
  ADSTYPE_OCTET_LIST = $0000000E;
  ADSTYPE_PATH = $0000000F;
  ADSTYPE_POSTALADDRESS = $00000010;
  ADSTYPE_TIMESTAMP = $00000011;
  ADSTYPE_BACKLINK = $00000012;
  ADSTYPE_TYPEDNAME = $00000013;
  ADSTYPE_HOLD = $00000014;
  ADSTYPE_NETADDRESS = $00000015;
  ADSTYPE_REPLICAPOINTER = $00000016;
  ADSTYPE_FAXNUMBER = $00000017;
  ADSTYPE_EMAIL = $00000018;
  ADSTYPE_NT_SECURITY_DESCRIPTOR = $00000019;
  ADSTYPE_UNKNOWN = $0000001A;
  ADSTYPE_DN_WITH_BINARY = $0000001B;
  ADSTYPE_DN_WITH_STRING = $0000001C;

// Konstanten für enum __MIDL___MIDL_itf_ads_0000_0018
//type
///  __MIDL___MIDL_itf_ads_0000_0018 = TOleEnum;
const
  ADS_SECURE_AUTHENTICATION = $00000001;
  ADS_USE_ENCRYPTION = $00000002;
  ADS_USE_SSL = $00000002;
  ADS_READONLY_SERVER = $00000004;
  ADS_PROMPT_CREDENTIALS = $00000008;
  ADS_NO_AUTHENTICATION = $00000010;
  ADS_FAST_BIND = $00000020;
  ADS_USE_SIGNING = $00000040;
  ADS_USE_SEALING = $00000080;
  ADS_USE_DELEGATION = $00000100;
  ADS_SERVER_BIND = $00000200;
  ADS_AUTH_RESERVED = $80000000;

// Konstanten für enum __MIDL___MIDL_itf_ads_0000_0019
type
  __MIDL___MIDL_itf_ads_0000_0019 = TOleEnum;
const
  ADS_STATUS_S_OK = $00000000;
  ADS_STATUS_INVALID_SEARCHPREF = $00000001;
  ADS_STATUS_INVALID_SEARCHPREFVALUE = $00000002;

// Konstanten für enum __MIDL___MIDL_itf_ads_0000_0020
type
  __MIDL___MIDL_itf_ads_0000_0020 = TOleEnum;
const
  ADS_DEREF_NEVER = $00000000;
  ADS_DEREF_SEARCHING = $00000001;
  ADS_DEREF_FINDING = $00000002;
  ADS_DEREF_ALWAYS = $00000003;

// Konstanten für enum __MIDL___MIDL_itf_ads_0000_0021
type
  __MIDL___MIDL_itf_ads_0000_0021 = TOleEnum;
const
  ADS_SCOPE_BASE = $00000000;
  ADS_SCOPE_ONELEVEL = $00000001;
  ADS_SCOPE_SUBTREE = $00000002;

// Konstanten für enum __MIDL___MIDL_itf_ads_0000_0022
type
  __MIDL___MIDL_itf_ads_0000_0022 = TOleEnum;
const
  ADSIPROP_ASYNCHRONOUS = $00000000;
  ADSIPROP_DEREF_ALIASES = $00000001;
  ADSIPROP_SIZE_LIMIT = $00000002;
  ADSIPROP_TIME_LIMIT = $00000003;
  ADSIPROP_ATTRIBTYPES_ONLY = $00000004;
  ADSIPROP_SEARCH_SCOPE = $00000005;
  ADSIPROP_TIMEOUT = $00000006;
  ADSIPROP_PAGESIZE = $00000007;
  ADSIPROP_PAGED_TIME_LIMIT = $00000008;
  ADSIPROP_CHASE_REFERRALS = $00000009;
  ADSIPROP_SORT_ON = $0000000A;
  ADSIPROP_CACHE_RESULTS = $0000000B;
  ADSIPROP_ADSIFLAG = $0000000C;

// Konstanten für enum __MIDL___MIDL_itf_ads_0000_0023
type
  __MIDL___MIDL_itf_ads_0000_0023 = TOleEnum;
const
  ADSI_DIALECT_LDAP = $00000000;
  ADSI_DIALECT_SQL = $00000001;

// Konstanten für enum __MIDL___MIDL_itf_ads_0000_0024
type
  __MIDL___MIDL_itf_ads_0000_0024 = TOleEnum;
const
  ADS_CHASE_REFERRALS_NEVER = $00000000;
  ADS_CHASE_REFERRALS_SUBORDINATE = $00000020;
  ADS_CHASE_REFERRALS_EXTERNAL = $00000040;
  ADS_CHASE_REFERRALS_ALWAYS = $00000060;

// Konstanten für enum __MIDL___MIDL_itf_ads_0000_0025
type
  __MIDL___MIDL_itf_ads_0000_0025 = TOleEnum;
const
  ADS_SEARCHPREF_ASYNCHRONOUS = $00000000;
  ADS_SEARCHPREF_DEREF_ALIASES = $00000001;
  ADS_SEARCHPREF_SIZE_LIMIT = $00000002;
  ADS_SEARCHPREF_TIME_LIMIT = $00000003;
  ADS_SEARCHPREF_ATTRIBTYPES_ONLY = $00000004;
  ADS_SEARCHPREF_SEARCH_SCOPE = $00000005;
  ADS_SEARCHPREF_TIMEOUT = $00000006;
  ADS_SEARCHPREF_PAGESIZE = $00000007;
  ADS_SEARCHPREF_PAGED_TIME_LIMIT = $00000008;
  ADS_SEARCHPREF_CHASE_REFERRALS = $00000009;
  ADS_SEARCHPREF_SORT_ON = $0000000A;
  ADS_SEARCHPREF_CACHE_RESULTS = $0000000B;
  ADS_SEARCHPREF_DIRSYNC = $0000000C;
  ADS_SEARCHPREF_TOMBSTONE = $0000000D;
  ADS_SEARCHPREF_VLV = $0000000E;
  ADS_SEARCHPREF_ATTRIBUTE_QUERY = $0000000F;
  ADS_SEARCHPREF_SECURITY_MASK = $00000010;

// Konstanten für enum __MIDL___MIDL_itf_ads_0000_0026
type
  __MIDL___MIDL_itf_ads_0000_0026 = TOleEnum;
const
  ADS_PROPERTY_CLEAR = $00000001;
  ADS_PROPERTY_UPDATE = $00000002;
  ADS_PROPERTY_APPEND = $00000003;
  ADS_PROPERTY_DELETE = $00000004;

// Konstanten für enum tagTYPEKIND
type
  tagTYPEKIND = TOleEnum;
const
  TKIND_ENUM = $00000000;
  TKIND_RECORD = $00000001;
  TKIND_MODULE = $00000002;
  TKIND_INTERFACE = $00000003;
  TKIND_DISPATCH = $00000004;
  TKIND_COCLASS = $00000005;
  TKIND_ALIAS = $00000006;
  TKIND_UNION = $00000007;
  TKIND_MAX = $00000008;

// Konstanten für enum tagDESCKIND
type
  tagDESCKIND = TOleEnum;
const
  DESCKIND_NONE = $00000000;
  DESCKIND_FUNCDESC = $00000001;
  DESCKIND_VARDESC = $00000002;
  DESCKIND_TYPECOMP = $00000003;
  DESCKIND_IMPLICITAPPOBJ = $00000004;
  DESCKIND_MAX = $00000005;

// Konstanten für enum tagFUNCKIND
type
  tagFUNCKIND = TOleEnum;
const
  FUNC_VIRTUAL = $00000000;
  FUNC_PUREVIRTUAL = $00000001;
  FUNC_NONVIRTUAL = $00000002;
  FUNC_STATIC = $00000003;
  FUNC_DISPATCH = $00000004;

// Konstanten für enum tagINVOKEKIND
type
  tagINVOKEKIND = TOleEnum;
const
  INVOKE_FUNC = $00000001;
  INVOKE_PROPERTYGET = $00000002;
  INVOKE_PROPERTYPUT = $00000004;
  INVOKE_PROPERTYPUTREF = $00000008;

// Konstanten für enum tagCALLCONV
type
  tagCALLCONV = TOleEnum;
const
  CC_FASTCALL = $00000000;
  CC_CDECL = $00000001;
  CC_MSCPASCAL = $00000002;
  CC_PASCAL = $00000002;
  CC_MACPASCAL = $00000003;
  CC_STDCALL = $00000004;
  CC_FPFASTCALL = $00000005;
  CC_SYSCALL = $00000006;
  CC_MPWCDECL = $00000007;
  CC_MPWPASCAL = $00000008;
  CC_MAX = $00000009;

// Konstanten für enum tagVARKIND
type
  tagVARKIND = TOleEnum;
const
  VAR_PERINSTANCE = $00000000;
  VAR_STATIC = $00000001;
  VAR_CONST = $00000002;
  VAR_DISPATCH = $00000003;

// Konstanten für enum tagSYSKIND
type
  tagSYSKIND = TOleEnum;
const
  SYS_WIN16 = $00000000;
  SYS_WIN32 = $00000001;
  SYS_MAC = $00000002;
  SYS_WIN64 = $00000003;

// Konstanten für enum __MIDL___MIDL_itf_ads_0125_0001
type
  __MIDL___MIDL_itf_ads_0125_0001 = TOleEnum;
const
  ADS_SYSTEMFLAG_DISALLOW_DELETE = $80000000;
  ADS_SYSTEMFLAG_CONFIG_ALLOW_RENAME = $40000000;
  ADS_SYSTEMFLAG_CONFIG_ALLOW_MOVE = $20000000;
  ADS_SYSTEMFLAG_CONFIG_ALLOW_LIMITED_MOVE = $10000000;
  ADS_SYSTEMFLAG_DOMAIN_DISALLOW_RENAME = $08000000;
  ADS_SYSTEMFLAG_DOMAIN_DISALLOW_MOVE = $04000000;
  ADS_SYSTEMFLAG_CR_NTDS_NC = $00000001;
  ADS_SYSTEMFLAG_CR_NTDS_DOMAIN = $00000002;
  ADS_SYSTEMFLAG_ATTR_NOT_REPLICATED = $00000001;
  ADS_SYSTEMFLAG_ATTR_IS_CONSTRUCTED = $00000004;

// Konstanten für enum __MIDL___MIDL_itf_ads_0131_0001
type
  __MIDL___MIDL_itf_ads_0131_0001 = TOleEnum;
const
  ADS_GROUP_TYPE_GLOBAL_GROUP = $00000002;
  ADS_GROUP_TYPE_DOMAIN_LOCAL_GROUP = $00000004;
  ADS_GROUP_TYPE_LOCAL_GROUP = $00000004;
  ADS_GROUP_TYPE_UNIVERSAL_GROUP = $00000008;
  ADS_GROUP_TYPE_SECURITY_ENABLED = $80000000;

// Konstanten für enum ADS_USER_FLAG
///type
///  ADS_USER_FLAG = TOleEnum;
const
  ADS_UF_SCRIPT = $00000001;
  ADS_UF_ACCOUNTDISABLE = $00000002;
  ADS_UF_HOMEDIR_REQUIRED = $00000008;
  ADS_UF_LOCKOUT = $00000010;
  ADS_UF_PASSWD_NOTREQD = $00000020;
  ADS_UF_PASSWD_CANT_CHANGE = $00000040;
  ADS_UF_ENCRYPTED_TEXT_PASSWORD_ALLOWED = $00000080;
  ADS_UF_TEMP_DUPLICATE_ACCOUNT = $00000100;
  ADS_UF_NORMAL_ACCOUNT = $00000200;
  ADS_UF_INTERDOMAIN_TRUST_ACCOUNT = $00000800;
  ADS_UF_WORKSTATION_TRUST_ACCOUNT = $00001000;
  ADS_UF_SERVER_TRUST_ACCOUNT = $00002000;
  ADS_UF_DONT_EXPIRE_PASSWD = $00010000;
  ADS_UF_MNS_LOGON_ACCOUNT = $00020000;
  ADS_UF_SMARTCARD_REQUIRED = $00040000;
  ADS_UF_TRUSTED_FOR_DELEGATION = $00080000;
  ADS_UF_NOT_DELEGATED = $00100000;
  ADS_UF_USE_DES_KEY_ONLY = $00200000;
  ADS_UF_DONT_REQUIRE_PREAUTH = $00400000;
  ADS_UF_PASSWORD_EXPIRED = $00800000;
  ADS_UF_TRUSTED_TO_AUTHENTICATE_FOR_DELEGATION = $01000000;

// Konstanten für enum __MIDL___MIDL_itf_ads_0153_0001
type
  __MIDL___MIDL_itf_ads_0153_0001 = TOleEnum;
const
  ADS_RIGHT_DELETE = $00010000;
  ADS_RIGHT_READ_CONTROL = $00020000;
  ADS_RIGHT_WRITE_DAC = $00040000;
  ADS_RIGHT_WRITE_OWNER = $00080000;
  ADS_RIGHT_SYNCHRONIZE = $00100000;
  ADS_RIGHT_ACCESS_SYSTEM_SECURITY = $01000000;
  ADS_RIGHT_GENERIC_READ = $80000000;
  ADS_RIGHT_GENERIC_WRITE = $40000000;
  ADS_RIGHT_GENERIC_EXECUTE = $20000000;
  ADS_RIGHT_GENERIC_ALL = $10000000;
  ADS_RIGHT_DS_CREATE_CHILD = $00000001;
  ADS_RIGHT_DS_DELETE_CHILD = $00000002;
  ADS_RIGHT_ACTRL_DS_LIST = $00000004;
  ADS_RIGHT_DS_SELF = $00000008;
  ADS_RIGHT_DS_READ_PROP = $00000010;
  ADS_RIGHT_DS_WRITE_PROP = $00000020;
  ADS_RIGHT_DS_DELETE_TREE = $00000040;
  ADS_RIGHT_DS_LIST_OBJECT = $00000080;
  ADS_RIGHT_DS_CONTROL_ACCESS = $00000100;

// Konstanten für enum __MIDL___MIDL_itf_ads_0153_0002
type
  __MIDL___MIDL_itf_ads_0153_0002 = TOleEnum;
const
  ADS_ACETYPE_ACCESS_ALLOWED = $00000000;
  ADS_ACETYPE_ACCESS_DENIED = $00000001;
  ADS_ACETYPE_SYSTEM_AUDIT = $00000002;
  ADS_ACETYPE_ACCESS_ALLOWED_OBJECT = $00000005;
  ADS_ACETYPE_ACCESS_DENIED_OBJECT = $00000006;
  ADS_ACETYPE_SYSTEM_AUDIT_OBJECT = $00000007;
  ADS_ACETYPE_SYSTEM_ALARM_OBJECT = $00000008;
  ADS_ACETYPE_ACCESS_ALLOWED_CALLBACK = $00000009;
  ADS_ACETYPE_ACCESS_DENIED_CALLBACK = $0000000A;
  ADS_ACETYPE_ACCESS_ALLOWED_CALLBACK_OBJECT = $0000000B;
  ADS_ACETYPE_ACCESS_DENIED_CALLBACK_OBJECT = $0000000C;
  ADS_ACETYPE_SYSTEM_AUDIT_CALLBACK = $0000000D;
  ADS_ACETYPE_SYSTEM_ALARM_CALLBACK = $0000000E;
  ADS_ACETYPE_SYSTEM_AUDIT_CALLBACK_OBJECT = $0000000F;
  ADS_ACETYPE_SYSTEM_ALARM_CALLBACK_OBJECT = $00000010;

// Konstanten für enum __MIDL___MIDL_itf_ads_0153_0003
type
  __MIDL___MIDL_itf_ads_0153_0003 = TOleEnum;
const
  ADS_ACEFLAG_INHERIT_ACE = $00000002;
  ADS_ACEFLAG_NO_PROPAGATE_INHERIT_ACE = $00000004;
  ADS_ACEFLAG_INHERIT_ONLY_ACE = $00000008;
  ADS_ACEFLAG_INHERITED_ACE = $00000010;
  ADS_ACEFLAG_VALID_INHERIT_FLAGS = $0000001F;
  ADS_ACEFLAG_SUCCESSFUL_ACCESS = $00000040;
  ADS_ACEFLAG_FAILED_ACCESS = $00000080;

// Konstanten für enum __MIDL___MIDL_itf_ads_0153_0004
type
  __MIDL___MIDL_itf_ads_0153_0004 = TOleEnum;
const
  ADS_FLAG_OBJECT_TYPE_PRESENT = $00000001;
  ADS_FLAG_INHERITED_OBJECT_TYPE_PRESENT = $00000002;

// Konstanten für enum __MIDL___MIDL_itf_ads_0153_0005
type
 __MIDL___MIDL_itf_ads_0153_0005 = TOleEnum;
const
  ADS_SD_CONTROL_SE_OWNER_DEFAULTED = $00000001;
  ADS_SD_CONTROL_SE_GROUP_DEFAULTED = $00000002;
  ADS_SD_CONTROL_SE_DACL_PRESENT = $00000004;
  ADS_SD_CONTROL_SE_DACL_DEFAULTED = $00000008;
  ADS_SD_CONTROL_SE_SACL_PRESENT = $00000010;
  ADS_SD_CONTROL_SE_SACL_DEFAULTED = $00000020;
  ADS_SD_CONTROL_SE_DACL_AUTO_INHERIT_REQ = $00000100;
  ADS_SD_CONTROL_SE_SACL_AUTO_INHERIT_REQ = $00000200;
  ADS_SD_CONTROL_SE_DACL_AUTO_INHERITED = $00000400;
  ADS_SD_CONTROL_SE_SACL_AUTO_INHERITED = $00000800;
  ADS_SD_CONTROL_SE_DACL_PROTECTED = $00001000;
  ADS_SD_CONTROL_SE_SACL_PROTECTED = $00002000;
  ADS_SD_CONTROL_SE_SELF_RELATIVE = $00008000;

// Konstanten für enum __MIDL___MIDL_itf_ads_0153_0006
type
  __MIDL___MIDL_itf_ads_0153_0006 = TOleEnum;
const
  ADS_SD_REVISION_DS = $00000004;

// Konstanten für enum __MIDL___MIDL_itf_ads_0154_0001
type
  __MIDL___MIDL_itf_ads_0154_0001 = TOleEnum;
const
  ADS_NAME_TYPE_1779 = $00000001;
  ADS_NAME_TYPE_CANONICAL = $00000002;
  ADS_NAME_TYPE_NT4 = $00000003;
  ADS_NAME_TYPE_DISPLAY = $00000004;
  ADS_NAME_TYPE_DOMAIN_SIMPLE = $00000005;
  ADS_NAME_TYPE_ENTERPRISE_SIMPLE = $00000006;
  ADS_NAME_TYPE_GUID = $00000007;
  ADS_NAME_TYPE_UNKNOWN = $00000008;
  ADS_NAME_TYPE_USER_PRINCIPAL_NAME = $00000009;
  ADS_NAME_TYPE_CANONICAL_EX = $0000000A;
  ADS_NAME_TYPE_SERVICE_PRINCIPAL_NAME = $0000000B;
  ADS_NAME_TYPE_SID_OR_SID_HISTORY_NAME = $0000000C;

// Konstanten für enum __MIDL___MIDL_itf_ads_0154_0002
type
  __MIDL___MIDL_itf_ads_0154_0002 = TOleEnum;
const
  ADS_NAME_INITTYPE_DOMAIN = $00000001;
  ADS_NAME_INITTYPE_SERVER = $00000002;
  ADS_NAME_INITTYPE_GC = $00000003;

// Konstanten für enum __MIDL___MIDL_itf_ads_0168_0001
type
  __MIDL___MIDL_itf_ads_0168_0001 = TOleEnum;
const
  ADS_OPTION_SERVERNAME = $00000000;
  ADS_OPTION_REFERRALS = $00000001;
  ADS_OPTION_PAGE_SIZE = $00000002;
  ADS_OPTION_SECURITY_MASK = $00000003;
  ADS_OPTION_MUTUAL_AUTH_STATUS = $00000004;

// Konstanten für enum __MIDL___MIDL_itf_ads_0168_0002
type
  __MIDL___MIDL_itf_ads_0168_0002 = TOleEnum;
const
  ADS_SECURITY_INFO_OWNER = $00000001;
  ADS_SECURITY_INFO_GROUP = $00000002;
  ADS_SECURITY_INFO_DACL = $00000004;
  ADS_SECURITY_INFO_SACL = $00000008;

// Konstanten für enum __MIDL___MIDL_itf_ads_0169_0001
type
  __MIDL___MIDL_itf_ads_0169_0001 = TOleEnum;
const
  ADS_SETTYPE_FULL = $00000001;
  ADS_SETTYPE_PROVIDER = $00000002;
  ADS_SETTYPE_SERVER = $00000003;
  ADS_SETTYPE_DN = $00000004;

// Konstanten für enum __MIDL___MIDL_itf_ads_0169_0002
type
  __MIDL___MIDL_itf_ads_0169_0002 = TOleEnum;
const
  ADS_FORMAT_WINDOWS = $00000001;
  ADS_FORMAT_WINDOWS_NO_SERVER = $00000002;
  ADS_FORMAT_WINDOWS_DN = $00000003;
  ADS_FORMAT_WINDOWS_PARENT = $00000004;
  ADS_FORMAT_X500 = $00000005;
  ADS_FORMAT_X500_NO_SERVER = $00000006;
  ADS_FORMAT_X500_DN = $00000007;
  ADS_FORMAT_X500_PARENT = $00000008;
  ADS_FORMAT_SERVER = $00000009;
  ADS_FORMAT_PROVIDER = $0000000A;
  ADS_FORMAT_LEAF = $0000000B;

// Konstanten für enum __MIDL___MIDL_itf_ads_0169_0003
type
  __MIDL___MIDL_itf_ads_0169_0003 = TOleEnum;
const
  ADS_DISPLAY_FULL = $00000001;
  ADS_DISPLAY_VALUE_ONLY = $00000002;

// Konstanten für enum __MIDL___MIDL_itf_ads_0169_0004
type
  __MIDL___MIDL_itf_ads_0169_0004 = TOleEnum;
const
  ADS_ESCAPEDMODE_DEFAULT = $00000001;
  ADS_ESCAPEDMODE_ON = $00000002;
  ADS_ESCAPEDMODE_OFF = $00000003;
  ADS_ESCAPEDMODE_OFF_EX = $00000004;

// Konstanten für enum __MIDL___MIDL_itf_ads_0174_0001
type
  __MIDL___MIDL_itf_ads_0174_0001 = TOleEnum;
const
  ADS_PATH_FILE = $00000001;
  ADS_PATH_FILESHARE = $00000002;
  ADS_PATH_REGISTRY = $00000003;

// Konstanten für enum __MIDL___MIDL_itf_ads_0174_0002
type
  __MIDL___MIDL_itf_ads_0174_0002 = TOleEnum;
const
  ADS_SD_FORMAT_IID = $00000001;
  ADS_SD_FORMAT_RAW = $00000002;
  ADS_SD_FORMAT_HEXSTRING = $00000003;

///type

// *********************************************************************//
// Forward-Deklaration von in der Typbibliothek definierten Typen         
// *********************************************************************//
{
  IADs = interface;
  IADsDisp = dispinterface;
  IADsContainer = interface;
  IADsContainerDisp = dispinterface;
  IADsCollection = interface;
  IADsCollectionDisp = dispinterface;
  IADsMembers = interface;
  IADsMembersDisp = dispinterface;
  IADsPropertyList = interface;
  IADsPropertyListDisp = dispinterface;
  IADsPropertyEntry = interface;
  IADsPropertyEntryDisp = dispinterface;
  IADsPropertyValue = interface;
  IADsPropertyValueDisp = dispinterface;
  IADsPropertyValue2 = interface;
  IADsPropertyValue2Disp = dispinterface;
  IPrivateDispatch = interface;
  ITypeInfo = interface;
  ITypeComp = interface;
  ITypeLib = interface;
  IPrivateUnknown = interface;
  IADsExtension = interface;
  IADsDeleteOps = interface;
  IADsDeleteOpsDisp = dispinterface;
  IADsNamespaces = interface;

  IADsNamespacesDisp = dispinterface;
  IADsClass = interface;
  IADsClassDisp = dispinterface;
  IADsProperty = interface;
  IADsPropertyDisp = dispinterface;
  IADsSyntax = interface;
  IADsSyntaxDisp = dispinterface;
  IADsLocality = interface;
  IADsLocalityDisp = dispinterface;
  IADsO = interface;
  IADsODisp = dispinterface;
  IADsOU = interface;
  IADsOUDisp = dispinterface;
  IADsDomain = interface;
  IADsDomainDisp = dispinterface;
  IADsComputer = interface;
  IADsComputerDisp = dispinterface;
  IADsComputerOperations = interface;
  IADsComputerOperationsDisp = dispinterface;
  IADsGroup = interface;
  IADsGroupDisp = dispinterface;
  IADsUser = interface;
  IADsUserDisp = dispinterface;
  IADsPrintQueue = interface;
  IADsPrintQueueDisp = dispinterface;

  IADsPrintQueueOperations = interface;
  IADsPrintQueueOperationsDisp = dispinterface;
  IADsPrintJob = interface;
  IADsPrintJobDisp = dispinterface;
  IADsPrintJobOperations = interface;
  IADsPrintJobOperationsDisp = dispinterface;
  IADsService = interface;
  IADsServiceDisp = dispinterface;
  IADsServiceOperations = interface;
  IADsServiceOperationsDisp = dispinterface;
  IADsFileService = interface;
  IADsFileServiceDisp = dispinterface;
  IADsFileServiceOperations = interface;
  IADsFileServiceOperationsDisp = dispinterface;
  IADsFileShare = interface;
  IADsFileShareDisp = dispinterface;
  IADsSession = interface;
  IADsSessionDisp = dispinterface;
  IADsResource = interface;
  IADsResourceDisp = dispinterface;
  IADsOpenDSObject = interface;
  IADsOpenDSObjectDisp = dispinterface;
  IDirectoryObject = interface;
  IDirectorySearch = interface;
  IDirectorySchemaMgmt = interface;
  IADsAggregatee = interface;
  IADsAggregator = interface;

  IADsAccessControlEntry = interface;
  IADsAccessControlEntryDisp = dispinterface;
  IADsAccessControlList = interface;
  IADsAccessControlListDisp = dispinterface;
  IADsSecurityDescriptor = interface;
  IADsSecurityDescriptorDisp = dispinterface;
  IADsLargeInteger = interface;
  IADsLargeIntegerDisp = dispinterface;
  IADsNameTranslate = interface;
  IADsNameTranslateDisp = dispinterface;
  IADsCaseIgnoreList = interface;
  IADsCaseIgnoreListDisp = dispinterface;
  IADsFaxNumber = interface;
  IADsFaxNumberDisp = dispinterface;
  IADsNetAddress = interface;
  IADsNetAddressDisp = dispinterface;
  IADsOctetList = interface;
  IADsOctetListDisp = dispinterface;
  IADsEmail = interface;
  IADsEmailDisp = dispinterface;
  IADsPath = interface;
  IADsPathDisp = dispinterface;
  IADsReplicaPointer = interface;
  IADsReplicaPointerDisp = dispinterface;
  IADsAcl = interface;

  IADsAclDisp = dispinterface;
  IADsTimestamp = interface;
  IADsTimestampDisp = dispinterface;
  IADsPostalAddress = interface;
  IADsPostalAddressDisp = dispinterface;
  IADsBackLink = interface;
  IADsBackLinkDisp = dispinterface;
  IADsTypedName = interface;
  IADsTypedNameDisp = dispinterface;
  IADsHold = interface;
  IADsHoldDisp = dispinterface;
  IADsObjectOptions = interface;
  IADsObjectOptionsDisp = dispinterface;
  IADsPathname = interface;
  IADsPathnameDisp = dispinterface;
  IADsADSystemInfo = interface;
  IADsADSystemInfoDisp = dispinterface;
  IADsWinNTSystemInfo = interface;
  IADsWinNTSystemInfoDisp = dispinterface;
  IADsDNWithBinary = interface;
  IADsDNWithBinaryDisp = dispinterface;
  IADsDNWithString = interface;
  IADsDNWithStringDisp = dispinterface;
  IADsSecurityUtility = interface;
  IADsSecurityUtilityDisp = dispinterface;
}
// *********************************************************************//
// Deklaration von in der Typbibliothek definierten CoClasses             
// (HINWEIS: Hier wird jede CoClass zu ihrer Standardschnittstelle        
// zugewiesen)                                                            
// *********************************************************************//
{
  PropertyEntry = IADsPropertyEntry;
  PropertyValue = IADsPropertyValue;
  AccessControlEntry = IADsAccessControlEntry;
  AccessControlList = IADsAccessControlList;
  SecurityDescriptor = IADsSecurityDescriptor;
  LargeInteger = IADsLargeInteger;
  NameTranslate = IADsNameTranslate;
  CaseIgnoreList = IADsCaseIgnoreList;
  FaxNumber = IADsFaxNumber;
  NetAddress = IADsNetAddress;
  OctetList = IADsOctetList;
  Email = IADsEmail;
  Path = IADsPath;
  ReplicaPointer = IADsReplicaPointer;
  Timestamp = IADsTimestamp;
  PostalAddress = IADsPostalAddress;
  BackLink = IADsBackLink;
  TypedName = IADsTypedName;
  Hold = IADsHold;
  Pathname = IADsPathname;
  ADSystemInfo = IADsADSystemInfo;
  WinNTSystemInfo = IADsWinNTSystemInfo;
  DNWithBinary = IADsDNWithBinary;
  DNWithString = IADsDNWithString;
  ADsSecurityUtility = IADsSecurityUtility;
}

// *********************************************************************// 
// Deklaration von  Strukturen, Unions und Aliasen.                        
// *********************************************************************//
type
  PUserType1 = ^_ADS_CASEIGNORE_LIST; {*}
  PUserType2 = ^_ADS_OCTET_LIST; {*}
  PPWideChar1 = ^PWideChar; {*}
  PUserType8 = ^tagTYPEDESC; {*}
  PUserType9 = ^tagARRAYDESC; {*}
  PUserType3 = ^TGUID; {*}
  PWord1 = ^Word; {*}
  PPWord1 = ^PWord1; {*}
  PUserType4 = ^TGUID; {*}
  PUserType5 = ^tagTYPEATTR; {*}
  PUserType6 = ^tagFUNCDESC; {*}
  PUserType7 = ^tagVARDESC; {*}
  PUserType10 = ^tagTLIBATTR; {*}
  PUserType11 = ^_ads_object_info; {*}
  PUserType12 = ^_ads_attr_info; {*}
  PUserType13 = ^ads_searchpref_info; {*}
  PUserType14 = ^ads_search_column; {*}
  PUserType15 = ^_ads_attr_def; {*}
  PPUserType1 = ^PUserType15; {*}
  PUINT1 = ^LongWord; {*}
  PUserType16 = ^_ads_class_def; {*}
  PPUserType2 = ^PUserType16; {*}


  ADSTYPEENUM = LongWord;// __MIDL___MIDL_itf_ads_0000_0001;

  __MIDL___MIDL_itf_ads_0000_0002 = packed record
    dwLength: LongWord;
    lpValue: ^Byte;
  end;

  ADS_OCTET_STRING = __MIDL___MIDL_itf_ads_0000_0002; 

  __MIDL___MIDL_itf_ads_0000_0003 = packed record
    dwLength: LongWord;
    lpValue: ^Byte;
  end;

  ADS_NT_SECURITY_DESCRIPTOR = __MIDL___MIDL_itf_ads_0000_0003; 

  _SYSTEMTIME = packed record
    wYear: Word;
    wMonth: Word;
    wDayOfWeek: Word;
    wDay: Word;
    wHour: Word;
    wMinute: Word;
    wSecond: Word;
    wMilliseconds: Word;
  end;

  _LARGE_INTEGER = packed record
    QuadPart: Int64;
  end;

  __MIDL___MIDL_itf_ads_0000_0004 = packed record
    dwLength: LongWord;
    lpValue: ^Byte;
  end;

  ADS_PROV_SPECIFIC = __MIDL___MIDL_itf_ads_0000_0004; 

  __MIDL___MIDL_itf_ads_0000_0005 = packed record
    Type_: LongWord;
    VolumeName: PWideChar;
    Path: PWideChar;
  end;

  ADS_PATH = __MIDL___MIDL_itf_ads_0000_0005; 

  __MIDL___MIDL_itf_ads_0000_0006 = packed record
    PostalAddress: array[0..5] of PWideChar;
  end;

  ADS_POSTALADDRESS = __MIDL___MIDL_itf_ads_0000_0006; 

  __MIDL___MIDL_itf_ads_0000_0007 = packed record
    WholeSeconds: LongWord;
    EventID: LongWord;
  end;

  ADS_TIMESTAMP = __MIDL___MIDL_itf_ads_0000_0007; 

  __MIDL___MIDL_itf_ads_0000_0008 = packed record
    RemoteID: LongWord;
    ObjectName: PWideChar;
  end;

  ADS_BACKLINK = __MIDL___MIDL_itf_ads_0000_0008; 

  __MIDL___MIDL_itf_ads_0000_0009 = packed record
    ObjectName: PWideChar;
    Level: LongWord;
    Interval: LongWord;
  end;

  ADS_TYPEDNAME = __MIDL___MIDL_itf_ads_0000_0009; 

  __MIDL___MIDL_itf_ads_0000_0010 = packed record
    ObjectName: PWideChar;
    Amount: LongWord;
  end;

  ADS_HOLD = __MIDL___MIDL_itf_ads_0000_0010; 

  __MIDL___MIDL_itf_ads_0000_0011 = packed record
    AddressType: LongWord;
    AddressLength: LongWord;
    Address: ^Byte;
  end;

  ADS_NETADDRESS = __MIDL___MIDL_itf_ads_0000_0011; 

  __MIDL___MIDL_itf_ads_0000_0012 = packed record
    ServerName: PWideChar;
    ReplicaType: LongWord;
    ReplicaNumber: LongWord;
    Count: LongWord;
    ReplicaAddressHints: ^__MIDL___MIDL_itf_ads_0000_0011;
  end;

  ADS_REPLICAPOINTER = __MIDL___MIDL_itf_ads_0000_0012; 

  __MIDL___MIDL_itf_ads_0000_0013 = packed record
    TelephoneNumber: PWideChar;
    NumberOfBits: LongWord;
    Parameters: ^Byte;
  end;

  ADS_FAXNUMBER = __MIDL___MIDL_itf_ads_0000_0013; 

  __MIDL___MIDL_itf_ads_0000_0014 = packed record
    Address: PWideChar;
    Type_: LongWord;
  end;

  ADS_EMAIL = __MIDL___MIDL_itf_ads_0000_0014; 

  __MIDL___MIDL_itf_ads_0000_0015 = packed record
    dwLength: LongWord;
    lpBinaryValue: ^Byte;
    pszDNString: PWideChar;
  end;

  ADS_DN_WITH_BINARY = __MIDL___MIDL_itf_ads_0000_0015; 

  __MIDL___MIDL_itf_ads_0000_0016 = packed record
    pszStringValue: PWideChar;
    pszDNString: PWideChar;
  end;

  ADS_DN_WITH_STRING = __MIDL___MIDL_itf_ads_0000_0016; 

  _ADS_CASEIGNORE_LIST = packed record
    Next: PUserType1;
    String_: PWideChar;
  end;

  _ADS_OCTET_LIST = packed record
    Next: PUserType2;
    Length: LongWord;
    Data: ^Byte;
  end;

  __MIDL___MIDL_itf_ads_0000_0017 = record
    case Integer of
      0: (DNString: PWideChar);
      1: (CaseExactString: PWideChar);
      2: (CaseIgnoreString: PWideChar);
      3: (PrintableString: PWideChar);
      4: (NumericString: PWideChar);
      5: (Boolean: LongWord);
      6: (Integer: LongWord);
      7: (OctetString: ADS_OCTET_STRING);
      8: (UTCTime: _SYSTEMTIME);
      9: (LargeInteger: _LARGE_INTEGER);
      10: (ClassName: PWideChar);
      11: (ProviderSpecific: ADS_PROV_SPECIFIC);
      12: (pCaseIgnoreList: ^_ADS_CASEIGNORE_LIST);
      13: (pOctetList: ^_ADS_OCTET_LIST);
      14: (pPath: ^__MIDL___MIDL_itf_ads_0000_0005);
      15: (pPostalAddress: ^__MIDL___MIDL_itf_ads_0000_0006);
      16: (Timestamp: ADS_TIMESTAMP);
      17: (BackLink: ADS_BACKLINK);
      18: (pTypedName: ^__MIDL___MIDL_itf_ads_0000_0009);
      19: (Hold: ADS_HOLD);
      20: (pNetAddress: ^__MIDL___MIDL_itf_ads_0000_0011);
      21: (pReplicaPointer: ^__MIDL___MIDL_itf_ads_0000_0012);
      22: (pFaxNumber: ^__MIDL___MIDL_itf_ads_0000_0013);
      23: (Email: ADS_EMAIL);
      24: (SecurityDescriptor: ADS_NT_SECURITY_DESCRIPTOR);
      25: (pDNWithBinary: ^__MIDL___MIDL_itf_ads_0000_0015);
      26: (pDNWithString: ^__MIDL___MIDL_itf_ads_0000_0016);
  end;

  //ADS_AUTHENTICATION_ENUM = __MIDL___MIDL_itf_ads_0000_0018; 

  _ads_object_info = packed record
    pszRDN: PWideChar;
    pszObjectDN: PWideChar;
    pszParentDN: PWideChar;
    pszSchemaDN: PWideChar;
    pszClassName: PWideChar;
  end;

  ADS_STATUSENUM = __MIDL___MIDL_itf_ads_0000_0019;
  ADS_DEREFENUM = __MIDL___MIDL_itf_ads_0000_0020;
  ADS_SCOPEENUM = __MIDL___MIDL_itf_ads_0000_0021;
  ADS_PREFERENCES_ENUM = __MIDL___MIDL_itf_ads_0000_0022;
  ADSI_DIALECT_ENUM = __MIDL___MIDL_itf_ads_0000_0023;
  ADS_CHASE_REFERRALS_ENUM = __MIDL___MIDL_itf_ads_0000_0024;
  ADS_SEARCHPREF_ENUM = __MIDL___MIDL_itf_ads_0000_0025;


  _adsvalue = packed record
    dwType: ADSTYPEENUM;
    __MIDL_0010: __MIDL___MIDL_itf_ads_0000_0017;
  end;

  ads_search_column = packed record
    pszAttrName: PWideChar;
    dwADsType: ADSTYPEENUM;
    pADsValues: ^_adsvalue;
    dwNumValues: LongWord;
    hReserved: Pointer;
  end;

  _ads_attr_def = packed record
    pszAttrName: PWideChar;
    dwADsType: ADSTYPEENUM;
    dwMinRange: LongWord;
    dwMaxRange: LongWord;
    fMultiValued: Integer;
  end;


  _ads_sortkey = packed record
    pszAttrType: PWideChar;
    pszReserved: PWideChar;
    fReverseorder: Shortint;
  end;

  _ads_vlv = packed record
    dwBeforeCount: LongWord;
    dwAfterCount: LongWord;
    dwOffset: LongWord;
    dwContentCount: LongWord;
    pszTarget: PWideChar;
    dwContextIDLength: LongWord;
    lpContextID: ^Byte;
  end;

  ADS_PROPERTY_OPERATION_ENUM = LongWord; //__MIDL___MIDL_itf_ads_0000_0026;

  __MIDL_IOleAutomationTypes_0005 = record
    case Integer of
      0: (lptdesc: PUserType8);
      1: (lpadesc: PUserType9);
      2: (hreftype: LongWord);
  end;

  tagTYPEDESC = packed record
    __MIDL_0008: __MIDL_IOleAutomationTypes_0005;
    vt: Word;
  end;

  tagSAFEARRAYBOUND = packed record
    cElements: LongWord;
    lLbound: Integer;
  end;

  ULONG_PTR = LongWord; 

  tagIDLDESC = packed record
    dwReserved: ULONG_PTR;
    wIDLFlags: Word;
  end;

  DWORD = LongWord; 

  tagPARAMDESCEX = packed record
    cBytes: LongWord;
    varDefaultValue: OleVariant;
  end;

  tagPARAMDESC = packed record
    pparamdescex: ^tagPARAMDESCEX;
    wParamFlags: Word;
  end;

  tagELEMDESC = packed record
    tdesc: tagTYPEDESC;
    paramdesc: tagPARAMDESC;
  end;

  tagFUNCDESC = packed record
    memid: Integer;
    lprgscode: ^SCODE;
    lprgelemdescParam: ^tagELEMDESC;
    funckind: tagFUNCKIND;
    invkind: tagINVOKEKIND;
    callconv: tagCALLCONV;
    cParams: Smallint;
    cParamsOpt: Smallint;
    oVft: Smallint;
    cScodes: Smallint;
    elemdescFunc: tagELEMDESC;
    wFuncFlags: Word;
  end;

  __MIDL_IOleAutomationTypes_0006 = record
    case Integer of
      0: (oInst: LongWord);
      1: (lpvarValue: ^OleVariant);
  end;

  tagVARDESC = packed record
    memid: Integer;
    lpstrSchema: PWideChar;
    __MIDL_0009: __MIDL_IOleAutomationTypes_0006;
    elemdescVar: tagELEMDESC;
    wVarFlags: Word;
    varkind: tagVARKIND;
  end;

  tagTLIBATTR = packed record
    GUID: TGUID;
    lcid: LongWord;
    syskind: tagSYSKIND;
    wMajorVerNum: Word;
    wMinorVerNum: Word;
    wLibFlags: Word;
  end;

  ADS_SYSTEMFLAG_ENUM = __MIDL___MIDL_itf_ads_0125_0001; 
  ADS_GROUP_TYPE_ENUM = __MIDL___MIDL_itf_ads_0131_0001; 
  ADS_RIGHTS_ENUM = __MIDL___MIDL_itf_ads_0153_0001; 
  ADS_ACETYPE_ENUM = __MIDL___MIDL_itf_ads_0153_0002; 
  ADS_ACEFLAG_ENUM = __MIDL___MIDL_itf_ads_0153_0003; 
  ADS_FLAGTYPE_ENUM = __MIDL___MIDL_itf_ads_0153_0004; 
  ADS_SD_CONTROL_ENUM = __MIDL___MIDL_itf_ads_0153_0005; 
  ADS_SD_REVISION_ENUM = __MIDL___MIDL_itf_ads_0153_0006; 
  ADS_NAME_TYPE_ENUM = __MIDL___MIDL_itf_ads_0154_0001; 
  ADS_NAME_INITTYPE_ENUM = __MIDL___MIDL_itf_ads_0154_0002; 
  ADS_OPTION_ENUM = __MIDL___MIDL_itf_ads_0168_0001; 
  ADS_SECURITY_INFO_ENUM = __MIDL___MIDL_itf_ads_0168_0002; 
  ADS_SETTYPE_ENUM = __MIDL___MIDL_itf_ads_0169_0001; 
  ADS_FORMAT_ENUM = __MIDL___MIDL_itf_ads_0169_0002; 
  ADS_DISPLAY_ENUM = __MIDL___MIDL_itf_ads_0169_0003; 
  ADS_ESCAPE_MODE_ENUM = __MIDL___MIDL_itf_ads_0169_0004; 
  ADS_PATHTYPE_ENUM = __MIDL___MIDL_itf_ads_0174_0001; 
  ADS_SD_FORMAT_ENUM = __MIDL___MIDL_itf_ads_0174_0002; 

  _ads_attr_info = packed record
    pszAttrName: PWideChar;
    dwControlCode: LongWord;
    dwADsType: ADSTYPEENUM;
    pADsValues: ^_adsvalue;
    dwNumValues: LongWord;
  end;

  ads_searchpref_info = packed record
    dwSearchPref: ADS_SEARCHPREF_ENUM;
    vValue: _adsvalue;
    dwStatus: ADS_STATUSENUM;
  end;

  _ads_class_def = packed record
    pszClassName: PWideChar;
    dwMandatoryAttrs: LongWord;
    ppszMandatoryAttrs: ^PWideChar;
    optionalAttrs: LongWord;
    ppszOptionalAttrs: ^PPWideChar1;
    dwNamingAttrs: LongWord;
    ppszNamingAttrs: ^PPWideChar1;
    dwSuperClasses: LongWord;
    ppszSuperClasses: ^PPWideChar1;
    fIsContainer: Integer;
  end;


  tagTYPEATTR = packed record
    GUID: TGUID;
    lcid: LongWord;
    dwReserved: LongWord;
    memidConstructor: Integer;
    memidDestructor: Integer;
    lpstrSchema: PWideChar;
    cbSizeInstance: LongWord;
    typekind: tagTYPEKIND;
    cFuncs: Word;
    cVars: Word;
    cImplTypes: Word;
    cbSizeVft: Word;
    cbAlignment: Word;
    wTypeFlags: Word;
    wMajorVerNum: Word;
    wMinorVerNum: Word;
    tdescAlias: tagTYPEDESC;
    idldescType: tagIDLDESC;
  end;

  tagARRAYDESC = packed record
    tdescElem: tagTYPEDESC;
    cDims: Word;
    rgbounds: ^tagSAFEARRAYBOUND;
  end;




// *********************************************************************//
// Schnittstelle: IADs
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {FD8256D0-FD15-11CE-ABC4-02608C9E7553}
// *********************************************************************//
  IADs = interface(IDispatch)
    ['{FD8256D0-FD15-11CE-ABC4-02608C9E7553}']
    function  Get_Name: WideString; safecall;
    function  Get_Class_: WideString; safecall;
    function  Get_GUID: WideString; safecall;
    function  Get_ADsPath: WideString; safecall;
    function  Get_Parent: WideString; safecall;
    function  Get_Schema: WideString; safecall;
    procedure GetInfo; safecall;
    procedure SetInfo; safecall;
    function  Get(const bstrName: WideString): OleVariant; safecall;
    procedure Put(const bstrName: WideString; vProp: OleVariant); safecall;
    function  GetEx(const bstrName: WideString): OleVariant; safecall;
    procedure PutEx(lnControlCode: Integer; const bstrName: WideString; vProp: OleVariant); safecall;
    procedure GetInfoEx(vProperties: OleVariant; lnReserved: Integer); safecall;
    property Name: WideString read Get_Name;
    property Class_: WideString read Get_Class_;
    property GUID: WideString read Get_GUID;
    property ADsPath: WideString read Get_ADsPath;
    property Parent: WideString read Get_Parent;
    property Schema: WideString read Get_Schema;
  end;

// *********************************************************************//
// DispIntf:  IADsDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {FD8256D0-FD15-11CE-ABC4-02608C9E7553}
// *********************************************************************//
  IADsDisp = dispinterface
    ['{FD8256D0-FD15-11CE-ABC4-02608C9E7553}']
    property Name: WideString readonly dispid 2;
    property Class_: WideString readonly dispid 3;
    property GUID: WideString readonly dispid 4;
    property ADsPath: WideString readonly dispid 5;
    property Parent: WideString readonly dispid 6;
    property Schema: WideString readonly dispid 7;
    procedure GetInfo; dispid 8;
    procedure SetInfo; dispid 9;
    function  Get(const bstrName: WideString): OleVariant; dispid 10;
    procedure Put(const bstrName: WideString; vProp: OleVariant); dispid 11;
    function  GetEx(const bstrName: WideString): OleVariant; dispid 12;
    procedure PutEx(lnControlCode: Integer; const bstrName: WideString; vProp: OleVariant); dispid 13;
    procedure GetInfoEx(vProperties: OleVariant; lnReserved: Integer); dispid 14;
  end;

// *********************************************************************//
// Schnittstelle: IADsContainer
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {001677D0-FD16-11CE-ABC4-02608C9E7553}
// *********************************************************************//
  IADsContainer = interface(IDispatch)
    ['{001677D0-FD16-11CE-ABC4-02608C9E7553}']
    function  Get_Count: Integer; safecall;
    function  Get__NewEnum: IUnknown; safecall;
    function  Get_Filter: OleVariant; safecall;
    procedure Set_Filter(pVar: OleVariant); safecall;
    function  Get_Hints: OleVariant; safecall;
    procedure Set_Hints(pvFilter: OleVariant); safecall;
    function  GetObject(const ClassName: WideString; const RelativeName: WideString): IDispatch; safecall;
    function  Create(const ClassName: WideString; const RelativeName: WideString): IDispatch; safecall;
    procedure Delete(const bstrClassName: WideString; const bstrRelativeName: WideString); safecall;
    function  CopyHere(const SourceName: WideString; const NewName: WideString): IDispatch; safecall;
    function  MoveHere(const SourceName: WideString; const NewName: WideString): IDispatch; safecall;
    property Count: Integer read Get_Count;
    property _NewEnum: IUnknown read Get__NewEnum;
    property Filter: OleVariant read Get_Filter write Set_Filter;
    property Hints: OleVariant read Get_Hints write Set_Hints;
  end;

// *********************************************************************//
// DispIntf:  IADsContainerDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {001677D0-FD16-11CE-ABC4-02608C9E7553}
// *********************************************************************//
  IADsContainerDisp = dispinterface
    ['{001677D0-FD16-11CE-ABC4-02608C9E7553}']
    property Count: Integer readonly dispid 2;
    property _NewEnum: IUnknown readonly dispid -4;
    property Filter: OleVariant dispid 3;
    property Hints: OleVariant dispid 4;
    function  GetObject(const ClassName: WideString; const RelativeName: WideString): IDispatch; dispid 5;
    function  Create(const ClassName: WideString; const RelativeName: WideString): IDispatch; dispid 6;
    procedure Delete(const bstrClassName: WideString; const bstrRelativeName: WideString); dispid 7;
    function  CopyHere(const SourceName: WideString; const NewName: WideString): IDispatch; dispid 8;
    function  MoveHere(const SourceName: WideString; const NewName: WideString): IDispatch; dispid 9;
  end;

// *********************************************************************//
// Schnittstelle: IADsCollection
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {72B945E0-253B-11CF-A988-00AA006BC149}
// *********************************************************************//
  IADsCollection = interface(IDispatch)
    ['{72B945E0-253B-11CF-A988-00AA006BC149}']
    function  Get__NewEnum: IUnknown; safecall;
    procedure Add(const bstrName: WideString; vItem: OleVariant); safecall;
    procedure Remove(const bstrItemToBeRemoved: WideString); safecall;
    function  GetObject(const bstrName: WideString): OleVariant; safecall;
    property _NewEnum: IUnknown read Get__NewEnum;
  end;

// *********************************************************************//
// DispIntf:  IADsCollectionDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {72B945E0-253B-11CF-A988-00AA006BC149}
// *********************************************************************//
  IADsCollectionDisp = dispinterface
    ['{72B945E0-253B-11CF-A988-00AA006BC149}']
    property _NewEnum: IUnknown readonly dispid -4;
    procedure Add(const bstrName: WideString; vItem: OleVariant); dispid 4;
    procedure Remove(const bstrItemToBeRemoved: WideString); dispid 5;
    function  GetObject(const bstrName: WideString): OleVariant; dispid 6;
  end;

// *********************************************************************//
// Schnittstelle: IADsMembers
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {451A0030-72EC-11CF-B03B-00AA006E0975}
// *********************************************************************//
  IADsMembers = interface(IDispatch)
    ['{451A0030-72EC-11CF-B03B-00AA006E0975}']
    function  Get_Count: Integer; safecall;
    function  Get__NewEnum: IUnknown; safecall;
    function  Get_Filter: OleVariant; safecall;
    procedure Set_Filter(pvFilter: OleVariant); safecall;
    property Count: Integer read Get_Count;
    property _NewEnum: IUnknown read Get__NewEnum;
    property Filter: OleVariant read Get_Filter write Set_Filter;
  end;

// *********************************************************************//
// DispIntf:  IADsMembersDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {451A0030-72EC-11CF-B03B-00AA006E0975}
// *********************************************************************//
  IADsMembersDisp = dispinterface
    ['{451A0030-72EC-11CF-B03B-00AA006E0975}']
    property Count: Integer readonly dispid 2;
    property _NewEnum: IUnknown readonly dispid -4;
    property Filter: OleVariant dispid 3;
  end;

// *********************************************************************//
// Schnittstelle: IADsPropertyList
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {C6F602B6-8F69-11D0-8528-00C04FD8D503}
// *********************************************************************//
  IADsPropertyList = interface(IDispatch)
    ['{C6F602B6-8F69-11D0-8528-00C04FD8D503}']
    function  Get_PropertyCount: Integer; safecall;
    function  Next: OleVariant; safecall;
    procedure Skip(cElements: Integer); safecall;
    procedure Reset; safecall;
    function  Item(varIndex: OleVariant): OleVariant; safecall;
    function  GetPropertyItem(const bstrName: WideString; lnADsType: Integer): OleVariant; safecall;
    procedure PutPropertyItem(varData: OleVariant); safecall;
    procedure ResetPropertyItem(varEntry: OleVariant); safecall;
    procedure PurgePropertyList; safecall;
    property PropertyCount: Integer read Get_PropertyCount;
  end;

// *********************************************************************//
// DispIntf:  IADsPropertyListDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {C6F602B6-8F69-11D0-8528-00C04FD8D503}
// *********************************************************************//
  IADsPropertyListDisp = dispinterface
    ['{C6F602B6-8F69-11D0-8528-00C04FD8D503}']
    property PropertyCount: Integer readonly dispid 2;
    function  Next: OleVariant; dispid 3;
    procedure Skip(cElements: Integer); dispid 4;
    procedure Reset; dispid 5;
    function  Item(varIndex: OleVariant): OleVariant; dispid 0;
    function  GetPropertyItem(const bstrName: WideString; lnADsType: Integer): OleVariant; dispid 6;
    procedure PutPropertyItem(varData: OleVariant); dispid 7;
    procedure ResetPropertyItem(varEntry: OleVariant); dispid 8;
    procedure PurgePropertyList; dispid 9;
  end;

// *********************************************************************//
// Schnittstelle: IADsPropertyEntry
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {05792C8E-941F-11D0-8529-00C04FD8D503}
// *********************************************************************//
  IADsPropertyEntry = interface(IDispatch)
    ['{05792C8E-941F-11D0-8529-00C04FD8D503}']
    procedure Clear; safecall;
    function  Get_Name: WideString; safecall;
    procedure Set_Name(const retval: WideString); safecall;
    function  Get_ADsType: Integer; safecall;
    procedure Set_ADsType(retval: Integer); safecall;
    function  Get_ControlCode: Integer; safecall;
    procedure Set_ControlCode(retval: Integer); safecall;
    function  Get_Values: OleVariant; safecall;
    procedure Set_Values(retval: OleVariant); safecall;
    property Name: WideString read Get_Name write Set_Name;
    property ADsType: Integer read Get_ADsType write Set_ADsType;
    property ControlCode: Integer read Get_ControlCode write Set_ControlCode;
    property Values: OleVariant read Get_Values write Set_Values;
  end;

// *********************************************************************//
// DispIntf:  IADsPropertyEntryDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {05792C8E-941F-11D0-8529-00C04FD8D503}
// *********************************************************************//
  IADsPropertyEntryDisp = dispinterface
    ['{05792C8E-941F-11D0-8529-00C04FD8D503}']
    procedure Clear; dispid 1;
    property Name: WideString dispid 2;
    property ADsType: Integer dispid 3;
    property ControlCode: Integer dispid 4;
    property Values: OleVariant dispid 5;
  end;

// *********************************************************************//
// Schnittstelle: IADsPropertyValue
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {79FA9AD0-A97C-11D0-8534-00C04FD8D503}
// *********************************************************************//
  IADsPropertyValue = interface(IDispatch)
    ['{79FA9AD0-A97C-11D0-8534-00C04FD8D503}']
    procedure Clear; safecall;
    function  Get_ADsType: Integer; safecall;
    procedure Set_ADsType(retval: Integer); safecall;
    function  Get_DNString: WideString; safecall;
    procedure Set_DNString(const retval: WideString); safecall;
    function  Get_CaseExactString: WideString; safecall;
    procedure Set_CaseExactString(const retval: WideString); safecall;
    function  Get_CaseIgnoreString: WideString; safecall;
    procedure Set_CaseIgnoreString(const retval: WideString); safecall;
    function  Get_PrintableString: WideString; safecall;
    procedure Set_PrintableString(const retval: WideString); safecall;
    function  Get_NumericString: WideString; safecall;
    procedure Set_NumericString(const retval: WideString); safecall;
    function  Get_Boolean: Integer; safecall;
    procedure Set_Boolean(retval: Integer); safecall;
    function  Get_Integer: Integer; safecall;
    procedure Set_Integer(retval: Integer); safecall;
    function  Get_OctetString: OleVariant; safecall;
    procedure Set_OctetString(retval: OleVariant); safecall;
    function  Get_SecurityDescriptor: IDispatch; safecall;
    procedure Set_SecurityDescriptor(const retval: IDispatch); safecall;
    function  Get_LargeInteger: IDispatch; safecall;
    procedure Set_LargeInteger(const retval: IDispatch); safecall;
    function  Get_UTCTime: TDateTime; safecall;
    procedure Set_UTCTime(retval: TDateTime); safecall;
    property ADsType: Integer read Get_ADsType write Set_ADsType;
    property DNString: WideString read Get_DNString write Set_DNString;
    property CaseExactString: WideString read Get_CaseExactString write Set_CaseExactString;
    property CaseIgnoreString: WideString read Get_CaseIgnoreString write Set_CaseIgnoreString;
    property PrintableString: WideString read Get_PrintableString write Set_PrintableString;
    property NumericString: WideString read Get_NumericString write Set_NumericString;
    property Boolean: Integer read Get_Boolean write Set_Boolean;
    property Integer: Integer read Get_Integer write Set_Integer;
    property OctetString: OleVariant read Get_OctetString write Set_OctetString;
    property SecurityDescriptor: IDispatch read Get_SecurityDescriptor write Set_SecurityDescriptor;
    property LargeInteger: IDispatch read Get_LargeInteger write Set_LargeInteger;
    property UTCTime: TDateTime read Get_UTCTime write Set_UTCTime;
  end;

// *********************************************************************//
// DispIntf:  IADsPropertyValueDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {79FA9AD0-A97C-11D0-8534-00C04FD8D503}
// *********************************************************************//
  IADsPropertyValueDisp = dispinterface
    ['{79FA9AD0-A97C-11D0-8534-00C04FD8D503}']
    procedure Clear; dispid 1;
    property ADsType: Integer dispid 2;
    property DNString: WideString dispid 3;
    property CaseExactString: WideString dispid 4;
    property CaseIgnoreString: WideString dispid 5;
    property PrintableString: WideString dispid 6;
    property NumericString: WideString dispid 7;
    property Boolean: Integer dispid 8;
    property Integer: Integer dispid 9;
    property OctetString: OleVariant dispid 10;
    property SecurityDescriptor: IDispatch dispid 11;
    property LargeInteger: IDispatch dispid 12;
    property UTCTime: TDateTime dispid 13;
  end;

// *********************************************************************//
// Schnittstelle: IADsPropertyValue2
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {306E831C-5BC7-11D1-A3B8-00C04FB950DC}
// *********************************************************************//
  IADsPropertyValue2 = interface(IDispatch)
    ['{306E831C-5BC7-11D1-A3B8-00C04FB950DC}']
    function  GetObjectProperty(var lnADsType: Integer): OleVariant; safecall;
    procedure PutObjectProperty(lnADsType: Integer; vProp: OleVariant); safecall;
  end;

// *********************************************************************//
// DispIntf:  IADsPropertyValue2Disp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {306E831C-5BC7-11D1-A3B8-00C04FB950DC}
// *********************************************************************//
  IADsPropertyValue2Disp = dispinterface
    ['{306E831C-5BC7-11D1-A3B8-00C04FB950DC}']
    function  GetObjectProperty(var lnADsType: Integer): OleVariant; dispid 1;
    procedure PutObjectProperty(lnADsType: Integer; vProp: OleVariant); dispid 2;
  end;

// *********************************************************************//
// Schnittstelle: IPrivateDispatch
// Flags:     (0)
// GUID:      {86AB4BBE-65F6-11D1-8C13-00C04FD8D503}
// *********************************************************************//
  IPrivateDispatch = interface(IUnknown)
    ['{86AB4BBE-65F6-11D1-8C13-00C04FD8D503}']
    function  ADSIInitializeDispatchManager(dwExtensionId: Integer): HResult; stdcall;
    function  ADSIGetTypeInfoCount(out pctinfo: SYSUINT): HResult; stdcall;
    function  ADSIGetTypeInfo(itinfo: SYSUINT; lcid: LongWord; out ppTInfo: ITypeInfo): HResult; stdcall;
    function  ADSIGetIDsOfNames(var riid: TGUID; rgszNames: PPWord1; cNames: SYSUINT; 
                                lcid: LongWord; out rgdispid: Integer): HResult; stdcall;
    function  ADSIInvoke(dispidMember: Integer; var riid: TGUID; lcid: LongWord; wFlags: Word; 
                         var pdispparams: TGUID; out pvarResult: OleVariant; out pexcepinfo: TGUID; 
                         out puArgErr: SYSUINT): HResult; stdcall;
  end;

// *********************************************************************//
// Schnittstelle: ITypeInfo
// Flags:     (0)
// GUID:      {00020401-0000-0000-C000-000000000046}
// *********************************************************************//
  ITypeInfo = interface(IUnknown)
    ['{00020401-0000-0000-C000-000000000046}']
    function  RemoteGetTypeAttr(out ppTypeAttr: PUserType5; out pDummy: DWORD): HResult; stdcall;
    function  GetTypeComp(out ppTComp: ITypeComp): HResult; stdcall;
    function  RemoteGetFuncDesc(index: SYSUINT; out ppFuncDesc: PUserType6; out pDummy: DWORD): HResult; stdcall;
    function  RemoteGetVarDesc(index: SYSUINT; out ppVarDesc: PUserType7; out pDummy: DWORD): HResult; stdcall;
    function  RemoteGetNames(memid: Integer; out rgBstrNames: WideString; cMaxNames: SYSUINT; 
                             out pcNames: SYSUINT): HResult; stdcall;
    function  GetRefTypeOfImplType(index: SYSUINT; out pRefType: LongWord): HResult; stdcall;
    function  GetImplTypeFlags(index: SYSUINT; out pImplTypeFlags: SYSINT): HResult; stdcall;
    function  LocalGetIDsOfNames: HResult; stdcall;
    function  LocalInvoke: HResult; stdcall;
    function  RemoteGetDocumentation(memid: Integer; refPtrFlags: LongWord; 
                                     out pBstrName: WideString; out pBstrDocString: WideString; 
                                     out pdwHelpContext: LongWord; out pBstrHelpFile: WideString): HResult; stdcall;
    function  RemoteGetDllEntry(memid: Integer; invkind: tagINVOKEKIND; refPtrFlags: LongWord; 
                                out pBstrDllName: WideString; out pBstrName: WideString; 
                                out pwOrdinal: Word): HResult; stdcall;
    function  GetRefTypeInfo(hreftype: LongWord; out ppTInfo: ITypeInfo): HResult; stdcall;
    function  LocalAddressOfMember: HResult; stdcall;
    function  RemoteCreateInstance(var riid: TGUID; out ppvObj: IUnknown): HResult; stdcall;
    function  GetMops(memid: Integer; out pBstrMops: WideString): HResult; stdcall;
    function  RemoteGetContainingTypeLib(out ppTLib: ITypeLib; out pIndex: SYSUINT): HResult; stdcall;
    function  LocalReleaseTypeAttr: HResult; stdcall;
    function  LocalReleaseFuncDesc: HResult; stdcall;
    function  LocalReleaseVarDesc: HResult; stdcall;
  end;

// *********************************************************************//
// Schnittstelle: ITypeComp
// Flags:     (0)
// GUID:      {00020403-0000-0000-C000-000000000046}
// *********************************************************************//
  ITypeComp = interface(IUnknown)
    ['{00020403-0000-0000-C000-000000000046}']
    function  RemoteBind(szName: PWideChar; lHashVal: LongWord; wFlags: Word; 
                         out ppTInfo: ITypeInfo; out pDescKind: tagDESCKIND; 
                         out ppFuncDesc: PUserType6; out ppVarDesc: PUserType7; 
                         out ppTypeComp: ITypeComp; out pDummy: DWORD): HResult; stdcall;
    function  RemoteBindType(szName: PWideChar; lHashVal: LongWord; out ppTInfo: ITypeInfo): HResult; stdcall;
  end;

// *********************************************************************//
// Schnittstelle: ITypeLib
// Flags:     (0)
// GUID:      {00020402-0000-0000-C000-000000000046}
// *********************************************************************//
  ITypeLib = interface(IUnknown)
    ['{00020402-0000-0000-C000-000000000046}']
    function  RemoteGetTypeInfoCount(out pctinfo: SYSUINT): HResult; stdcall;
    function  GetTypeInfo(index: SYSUINT; out ppTInfo: ITypeInfo): HResult; stdcall;
    function  GetTypeInfoType(index: SYSUINT; out pTKind: tagTYPEKIND): HResult; stdcall;
    function  GetTypeInfoOfGuid(var GUID: TGUID; out ppTInfo: ITypeInfo): HResult; stdcall;
    function  RemoteGetLibAttr(out ppTLibAttr: PUserType10; out pDummy: DWORD): HResult; stdcall;
    function  GetTypeComp(out ppTComp: ITypeComp): HResult; stdcall;
    function  RemoteGetDocumentation(index: SYSINT; refPtrFlags: LongWord; 
                                     out pBstrName: WideString; out pBstrDocString: WideString; 
                                     out pdwHelpContext: LongWord; out pBstrHelpFile: WideString): HResult; stdcall;
    function  RemoteIsName(szNameBuf: PWideChar; lHashVal: LongWord; out pfName: Integer; 
                           out pBstrLibName: WideString): HResult; stdcall;
    function  RemoteFindName(szNameBuf: PWideChar; lHashVal: LongWord; out ppTInfo: ITypeInfo; 
                             out rgMemId: Integer; var pcFound: Word; out pBstrLibName: WideString): HResult; stdcall;
    function  LocalReleaseTLibAttr: HResult; stdcall;
  end;

// *********************************************************************//
// Schnittstelle: IPrivateUnknown
// Flags:     (0)
// GUID:      {89126BAB-6EAD-11D1-8C18-00C04FD8D503}
// *********************************************************************//
  IPrivateUnknown = interface(IUnknown)
    ['{89126BAB-6EAD-11D1-8C18-00C04FD8D503}']
    function  ADSIInitializeObject(const lpszUserName: WideString; const lpszPassword: WideString; 
                                   lnReserved: Integer): HResult; stdcall;
    function  ADSIReleaseObject: HResult; stdcall;
  end;

// *********************************************************************//
// Schnittstelle: IADsExtension
// Flags:     (0)
// GUID:      {3D35553C-D2B0-11D1-B17B-0000F87593A0}
// *********************************************************************//
  IADsExtension = interface(IUnknown)
    ['{3D35553C-D2B0-11D1-B17B-0000F87593A0}']
    function  Operate(dwCode: LongWord; varData1: OleVariant; varData2: OleVariant; 
                      varData3: OleVariant): HResult; stdcall;
    function  PrivateGetIDsOfNames(var riid: TGUID; rgszNames: PPWord1; cNames: SYSUINT; 
                                   lcid: LongWord; out rgdispid: Integer): HResult; stdcall;
    function  PrivateInvoke(dispidMember: Integer; var riid: TGUID; lcid: LongWord; wFlags: Word; 
                            var pdispparams: TGUID; out pvarResult: OleVariant; 
                            out pexcepinfo: TGUID; out puArgErr: SYSUINT): HResult; stdcall;
  end;

// *********************************************************************//
// Schnittstelle: IADsDeleteOps
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {B2BD0902-8878-11D1-8C21-00C04FD8D503}
// *********************************************************************//
  IADsDeleteOps = interface(IDispatch)
    ['{B2BD0902-8878-11D1-8C21-00C04FD8D503}']
    procedure DeleteObject(lnFlags: Integer); safecall;
  end;

// *********************************************************************//
// DispIntf:  IADsDeleteOpsDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {B2BD0902-8878-11D1-8C21-00C04FD8D503}
// *********************************************************************//
  IADsDeleteOpsDisp = dispinterface
    ['{B2BD0902-8878-11D1-8C21-00C04FD8D503}']
    procedure DeleteObject(lnFlags: Integer); dispid 2;
  end;

// *********************************************************************//
// Schnittstelle: IADsNamespaces
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {28B96BA0-B330-11CF-A9AD-00AA006BC149}
// *********************************************************************//
  IADsNamespaces = interface(IADs)
    ['{28B96BA0-B330-11CF-A9AD-00AA006BC149}']
    function  Get_DefaultContainer: WideString; safecall;
    procedure Set_DefaultContainer(const retval: WideString); safecall;
    property DefaultContainer: WideString read Get_DefaultContainer write Set_DefaultContainer;
  end;

// *********************************************************************//
// DispIntf:  IADsNamespacesDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {28B96BA0-B330-11CF-A9AD-00AA006BC149}
// *********************************************************************//
  IADsNamespacesDisp = dispinterface
    ['{28B96BA0-B330-11CF-A9AD-00AA006BC149}']
    property DefaultContainer: WideString dispid 1;
    property Name: WideString readonly dispid 2;
    property Class_: WideString readonly dispid 3;
    property GUID: WideString readonly dispid 4;
    property ADsPath: WideString readonly dispid 5;
    property Parent: WideString readonly dispid 6;
    property Schema: WideString readonly dispid 7;
    procedure GetInfo; dispid 8;
    procedure SetInfo; dispid 9;
    function  Get(const bstrName: WideString): OleVariant; dispid 10;
    procedure Put(const bstrName: WideString; vProp: OleVariant); dispid 11;
    function  GetEx(const bstrName: WideString): OleVariant; dispid 12;
    procedure PutEx(lnControlCode: Integer; const bstrName: WideString; vProp: OleVariant); dispid 13;
    procedure GetInfoEx(vProperties: OleVariant; lnReserved: Integer); dispid 14;
  end;

// *********************************************************************//
// Schnittstelle: IADsClass
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {C8F93DD0-4AE0-11CF-9E73-00AA004A5691}
// *********************************************************************//
  IADsClass = interface(IADs)
    ['{C8F93DD0-4AE0-11CF-9E73-00AA004A5691}']
    function  Get_PrimaryInterface: WideString; safecall;
    function  Get_CLSID: WideString; safecall;
    procedure Set_CLSID(const retval: WideString); safecall;
    function  Get_OID: WideString; safecall;
    procedure Set_OID(const retval: WideString); safecall;
    function  Get_Abstract: WordBool; safecall;
    procedure Set_Abstract(retval: WordBool); safecall;
    function  Get_Auxiliary: WordBool; safecall;
    procedure Set_Auxiliary(retval: WordBool); safecall;
    function  Get_MandatoryProperties: OleVariant; safecall;
    procedure Set_MandatoryProperties(retval: OleVariant); safecall;
    function  Get_OptionalProperties: OleVariant; safecall;
    procedure Set_OptionalProperties(retval: OleVariant); safecall;
    function  Get_NamingProperties: OleVariant; safecall;
    procedure Set_NamingProperties(retval: OleVariant); safecall;
    function  Get_DerivedFrom: OleVariant; safecall;
    procedure Set_DerivedFrom(retval: OleVariant); safecall;
    function  Get_AuxDerivedFrom: OleVariant; safecall;
    procedure Set_AuxDerivedFrom(retval: OleVariant); safecall;
    function  Get_PossibleSuperiors: OleVariant; safecall;
    procedure Set_PossibleSuperiors(retval: OleVariant); safecall;
    function  Get_Containment: OleVariant; safecall;
    procedure Set_Containment(retval: OleVariant); safecall;
    function  Get_Container: WordBool; safecall;
    procedure Set_Container(retval: WordBool); safecall;
    function  Get_HelpFileName: WideString; safecall;
    procedure Set_HelpFileName(const retval: WideString); safecall;
    function  Get_HelpFileContext: Integer; safecall;
    procedure Set_HelpFileContext(retval: Integer); safecall;
    function  Qualifiers: IADsCollection; safecall;
    property PrimaryInterface: WideString read Get_PrimaryInterface;
    property CLSID: WideString read Get_CLSID write Set_CLSID;
    property OID: WideString read Get_OID write Set_OID;
    property Abstract: WordBool read Get_Abstract write Set_Abstract;
    property Auxiliary: WordBool read Get_Auxiliary write Set_Auxiliary;
    property MandatoryProperties: OleVariant read Get_MandatoryProperties write Set_MandatoryProperties;
    property OptionalProperties: OleVariant read Get_OptionalProperties write Set_OptionalProperties;
    property NamingProperties: OleVariant read Get_NamingProperties write Set_NamingProperties;
    property DerivedFrom: OleVariant read Get_DerivedFrom write Set_DerivedFrom;
    property AuxDerivedFrom: OleVariant read Get_AuxDerivedFrom write Set_AuxDerivedFrom;
    property PossibleSuperiors: OleVariant read Get_PossibleSuperiors write Set_PossibleSuperiors;
    property Containment: OleVariant read Get_Containment write Set_Containment;
    property Container: WordBool read Get_Container write Set_Container;
    property HelpFileName: WideString read Get_HelpFileName write Set_HelpFileName;
    property HelpFileContext: Integer read Get_HelpFileContext write Set_HelpFileContext;
  end;

// *********************************************************************//
// DispIntf:  IADsClassDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {C8F93DD0-4AE0-11CF-9E73-00AA004A5691}
// *********************************************************************//
  IADsClassDisp = dispinterface
    ['{C8F93DD0-4AE0-11CF-9E73-00AA004A5691}']
    property PrimaryInterface: WideString readonly dispid 15;
    property CLSID: WideString dispid 16;
    property OID: WideString dispid 17;
    property Abstract: WordBool dispid 18;
    property Auxiliary: WordBool dispid 26;
    property MandatoryProperties: OleVariant dispid 19;
    property OptionalProperties: OleVariant dispid 29;
    property NamingProperties: OleVariant dispid 30;
    property DerivedFrom: OleVariant dispid 20;
    property AuxDerivedFrom: OleVariant dispid 27;
    property PossibleSuperiors: OleVariant dispid 28;
    property Containment: OleVariant dispid 21;
    property Container: WordBool dispid 22;
    property HelpFileName: WideString dispid 23;
    property HelpFileContext: Integer dispid 24;
    function  Qualifiers: IADsCollection; dispid 25;
    property Name: WideString readonly dispid 2;
    property Class_: WideString readonly dispid 3;
    property GUID: WideString readonly dispid 4;
    property ADsPath: WideString readonly dispid 5;
    property Parent: WideString readonly dispid 6;
    property Schema: WideString readonly dispid 7;
    procedure GetInfo; dispid 8;
    procedure SetInfo; dispid 9;
    function  Get(const bstrName: WideString): OleVariant; dispid 10;
    procedure Put(const bstrName: WideString; vProp: OleVariant); dispid 11;
    function  GetEx(const bstrName: WideString): OleVariant; dispid 12;
    procedure PutEx(lnControlCode: Integer; const bstrName: WideString; vProp: OleVariant); dispid 13;
    procedure GetInfoEx(vProperties: OleVariant; lnReserved: Integer); dispid 14;
  end;

// *********************************************************************//
// Schnittstelle: IADsProperty
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {C8F93DD3-4AE0-11CF-9E73-00AA004A5691}
// *********************************************************************//
  IADsProperty = interface(IADs)
    ['{C8F93DD3-4AE0-11CF-9E73-00AA004A5691}']
    function  Get_OID: WideString; safecall;
    procedure Set_OID(const retval: WideString); safecall;
    function  Get_Syntax: WideString; safecall;
    procedure Set_Syntax(const retval: WideString); safecall;
    function  Get_MaxRange: Integer; safecall;
    procedure Set_MaxRange(retval: Integer); safecall;
    function  Get_MinRange: Integer; safecall;
    procedure Set_MinRange(retval: Integer); safecall;
    function  Get_MultiValued: WordBool; safecall;
    procedure Set_MultiValued(retval: WordBool); safecall;
    function  Qualifiers: IADsCollection; safecall;
    property OID: WideString read Get_OID write Set_OID;
    property Syntax: WideString read Get_Syntax write Set_Syntax;
    property MaxRange: Integer read Get_MaxRange write Set_MaxRange;
    property MinRange: Integer read Get_MinRange write Set_MinRange;
    property MultiValued: WordBool read Get_MultiValued write Set_MultiValued;
  end;

// *********************************************************************//
// DispIntf:  IADsPropertyDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {C8F93DD3-4AE0-11CF-9E73-00AA004A5691}
// *********************************************************************//
  IADsPropertyDisp = dispinterface
    ['{C8F93DD3-4AE0-11CF-9E73-00AA004A5691}']
    property OID: WideString dispid 17;
    property Syntax: WideString dispid 18;
    property MaxRange: Integer dispid 19;
    property MinRange: Integer dispid 20;
    property MultiValued: WordBool dispid 21;
    function  Qualifiers: IADsCollection; dispid 22;
    property Name: WideString readonly dispid 2;
    property Class_: WideString readonly dispid 3;
    property GUID: WideString readonly dispid 4;
    property ADsPath: WideString readonly dispid 5;
    property Parent: WideString readonly dispid 6;
    property Schema: WideString readonly dispid 7;
    procedure GetInfo; dispid 8;
    procedure SetInfo; dispid 9;
    function  Get(const bstrName: WideString): OleVariant; dispid 10;
    procedure Put(const bstrName: WideString; vProp: OleVariant); dispid 11;
    function  GetEx(const bstrName: WideString): OleVariant; dispid 12;
    procedure PutEx(lnControlCode: Integer; const bstrName: WideString; vProp: OleVariant); dispid 13;
    procedure GetInfoEx(vProperties: OleVariant; lnReserved: Integer); dispid 14;
  end;

// *********************************************************************//
// Schnittstelle: IADsSyntax
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {C8F93DD2-4AE0-11CF-9E73-00AA004A5691}
// *********************************************************************//
  IADsSyntax = interface(IADs)
    ['{C8F93DD2-4AE0-11CF-9E73-00AA004A5691}']
    function  Get_OleAutoDataType: Integer; safecall;
    procedure Set_OleAutoDataType(retval: Integer); safecall;
    property OleAutoDataType: Integer read Get_OleAutoDataType write Set_OleAutoDataType;
  end;

// *********************************************************************//
// DispIntf:  IADsSyntaxDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {C8F93DD2-4AE0-11CF-9E73-00AA004A5691}
// *********************************************************************//
  IADsSyntaxDisp = dispinterface
    ['{C8F93DD2-4AE0-11CF-9E73-00AA004A5691}']
    property OleAutoDataType: Integer dispid 15;
    property Name: WideString readonly dispid 2;
    property Class_: WideString readonly dispid 3;
    property GUID: WideString readonly dispid 4;
    property ADsPath: WideString readonly dispid 5;
    property Parent: WideString readonly dispid 6;
    property Schema: WideString readonly dispid 7;
    procedure GetInfo; dispid 8;
    procedure SetInfo; dispid 9;
    function  Get(const bstrName: WideString): OleVariant; dispid 10;
    procedure Put(const bstrName: WideString; vProp: OleVariant); dispid 11;
    function  GetEx(const bstrName: WideString): OleVariant; dispid 12;
    procedure PutEx(lnControlCode: Integer; const bstrName: WideString; vProp: OleVariant); dispid 13;
    procedure GetInfoEx(vProperties: OleVariant; lnReserved: Integer); dispid 14;
  end;

// *********************************************************************//
// Schnittstelle: IADsLocality
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {A05E03A2-EFFE-11CF-8ABC-00C04FD8D503}
// *********************************************************************//
  IADsLocality = interface(IADs)
    ['{A05E03A2-EFFE-11CF-8ABC-00C04FD8D503}']
    function  Get_Description: WideString; safecall;
    procedure Set_Description(const retval: WideString); safecall;
    function  Get_LocalityName: WideString; safecall;
    procedure Set_LocalityName(const retval: WideString); safecall;
    function  Get_PostalAddress: WideString; safecall;
    procedure Set_PostalAddress(const retval: WideString); safecall;
    function  Get_SeeAlso: OleVariant; safecall;
    procedure Set_SeeAlso(retval: OleVariant); safecall;
    property Description: WideString read Get_Description write Set_Description;
    property LocalityName: WideString read Get_LocalityName write Set_LocalityName;
    property PostalAddress: WideString read Get_PostalAddress write Set_PostalAddress;
    property SeeAlso: OleVariant read Get_SeeAlso write Set_SeeAlso;
  end;

// *********************************************************************//
// DispIntf:  IADsLocalityDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {A05E03A2-EFFE-11CF-8ABC-00C04FD8D503}
// *********************************************************************//
  IADsLocalityDisp = dispinterface
    ['{A05E03A2-EFFE-11CF-8ABC-00C04FD8D503}']
    property Description: WideString dispid 15;
    property LocalityName: WideString dispid 16;
    property PostalAddress: WideString dispid 17;
    property SeeAlso: OleVariant dispid 18;
    property Name: WideString readonly dispid 2;
    property Class_: WideString readonly dispid 3;
    property GUID: WideString readonly dispid 4;
    property ADsPath: WideString readonly dispid 5;
    property Parent: WideString readonly dispid 6;
    property Schema: WideString readonly dispid 7;
    procedure GetInfo; dispid 8;
    procedure SetInfo; dispid 9;
    function  Get(const bstrName: WideString): OleVariant; dispid 10;
    procedure Put(const bstrName: WideString; vProp: OleVariant); dispid 11;
    function  GetEx(const bstrName: WideString): OleVariant; dispid 12;
    procedure PutEx(lnControlCode: Integer; const bstrName: WideString; vProp: OleVariant); dispid 13;
    procedure GetInfoEx(vProperties: OleVariant; lnReserved: Integer); dispid 14;
  end;

// *********************************************************************//
// Schnittstelle: IADsO
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {A1CD2DC6-EFFE-11CF-8ABC-00C04FD8D503}
// *********************************************************************//
  IADsO = interface(IADs)
    ['{A1CD2DC6-EFFE-11CF-8ABC-00C04FD8D503}']
    function  Get_Description: WideString; safecall;
    procedure Set_Description(const retval: WideString); safecall;
    function  Get_LocalityName: WideString; safecall;
    procedure Set_LocalityName(const retval: WideString); safecall;
    function  Get_PostalAddress: WideString; safecall;
    procedure Set_PostalAddress(const retval: WideString); safecall;
    function  Get_TelephoneNumber: WideString; safecall;
    procedure Set_TelephoneNumber(const retval: WideString); safecall;
    function  Get_FaxNumber: WideString; safecall;
    procedure Set_FaxNumber(const retval: WideString); safecall;
    function  Get_SeeAlso: OleVariant; safecall;
    procedure Set_SeeAlso(retval: OleVariant); safecall;
    property Description: WideString read Get_Description write Set_Description;
    property LocalityName: WideString read Get_LocalityName write Set_LocalityName;
    property PostalAddress: WideString read Get_PostalAddress write Set_PostalAddress;
    property TelephoneNumber: WideString read Get_TelephoneNumber write Set_TelephoneNumber;
    property FaxNumber: WideString read Get_FaxNumber write Set_FaxNumber;
    property SeeAlso: OleVariant read Get_SeeAlso write Set_SeeAlso;
  end;

// *********************************************************************//
// DispIntf:  IADsODisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {A1CD2DC6-EFFE-11CF-8ABC-00C04FD8D503}
// *********************************************************************//
  IADsODisp = dispinterface
    ['{A1CD2DC6-EFFE-11CF-8ABC-00C04FD8D503}']
    property Description: WideString dispid 15;
    property LocalityName: WideString dispid 16;
    property PostalAddress: WideString dispid 17;
    property TelephoneNumber: WideString dispid 18;
    property FaxNumber: WideString dispid 19;
    property SeeAlso: OleVariant dispid 20;
    property Name: WideString readonly dispid 2;
    property Class_: WideString readonly dispid 3;
    property GUID: WideString readonly dispid 4;
    property ADsPath: WideString readonly dispid 5;
    property Parent: WideString readonly dispid 6;
    property Schema: WideString readonly dispid 7;
    procedure GetInfo; dispid 8;
    procedure SetInfo; dispid 9;
    function  Get(const bstrName: WideString): OleVariant; dispid 10;
    procedure Put(const bstrName: WideString; vProp: OleVariant); dispid 11;
    function  GetEx(const bstrName: WideString): OleVariant; dispid 12;
    procedure PutEx(lnControlCode: Integer; const bstrName: WideString; vProp: OleVariant); dispid 13;
    procedure GetInfoEx(vProperties: OleVariant; lnReserved: Integer); dispid 14;
  end;

// *********************************************************************//
// Schnittstelle: IADsOU
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {A2F733B8-EFFE-11CF-8ABC-00C04FD8D503}
// *********************************************************************//
  IADsOU = interface(IADs)
    ['{A2F733B8-EFFE-11CF-8ABC-00C04FD8D503}']
    function  Get_Description: WideString; safecall;
    procedure Set_Description(const retval: WideString); safecall;
    function  Get_LocalityName: WideString; safecall;
    procedure Set_LocalityName(const retval: WideString); safecall;
    function  Get_PostalAddress: WideString; safecall;
    procedure Set_PostalAddress(const retval: WideString); safecall;
    function  Get_TelephoneNumber: WideString; safecall;
    procedure Set_TelephoneNumber(const retval: WideString); safecall;
    function  Get_FaxNumber: WideString; safecall;
    procedure Set_FaxNumber(const retval: WideString); safecall;
    function  Get_SeeAlso: OleVariant; safecall;
    procedure Set_SeeAlso(retval: OleVariant); safecall;
    function  Get_BusinessCategory: WideString; safecall;
    procedure Set_BusinessCategory(const retval: WideString); safecall;
    property Description: WideString read Get_Description write Set_Description;
    property LocalityName: WideString read Get_LocalityName write Set_LocalityName;
    property PostalAddress: WideString read Get_PostalAddress write Set_PostalAddress;
    property TelephoneNumber: WideString read Get_TelephoneNumber write Set_TelephoneNumber;
    property FaxNumber: WideString read Get_FaxNumber write Set_FaxNumber;
    property SeeAlso: OleVariant read Get_SeeAlso write Set_SeeAlso;
    property BusinessCategory: WideString read Get_BusinessCategory write Set_BusinessCategory;
  end;

// *********************************************************************//
// DispIntf:  IADsOUDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {A2F733B8-EFFE-11CF-8ABC-00C04FD8D503}
// *********************************************************************//
  IADsOUDisp = dispinterface
    ['{A2F733B8-EFFE-11CF-8ABC-00C04FD8D503}']
    property Description: WideString dispid 15;
    property LocalityName: WideString dispid 16;
    property PostalAddress: WideString dispid 17;
    property TelephoneNumber: WideString dispid 18;
    property FaxNumber: WideString dispid 19;
    property SeeAlso: OleVariant dispid 20;
    property BusinessCategory: WideString dispid 21;
    property Name: WideString readonly dispid 2;
    property Class_: WideString readonly dispid 3;
    property GUID: WideString readonly dispid 4;
    property ADsPath: WideString readonly dispid 5;
    property Parent: WideString readonly dispid 6;
    property Schema: WideString readonly dispid 7;
    procedure GetInfo; dispid 8;
    procedure SetInfo; dispid 9;
    function  Get(const bstrName: WideString): OleVariant; dispid 10;
    procedure Put(const bstrName: WideString; vProp: OleVariant); dispid 11;
    function  GetEx(const bstrName: WideString): OleVariant; dispid 12;
    procedure PutEx(lnControlCode: Integer; const bstrName: WideString; vProp: OleVariant); dispid 13;
    procedure GetInfoEx(vProperties: OleVariant; lnReserved: Integer); dispid 14;
  end;

// *********************************************************************//
// Schnittstelle: IADsDomain
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {00E4C220-FD16-11CE-ABC4-02608C9E7553}
// *********************************************************************//
  IADsDomain = interface(IADs)
    ['{00E4C220-FD16-11CE-ABC4-02608C9E7553}']
    function  Get_IsWorkgroup: WordBool; safecall;
    function  Get_MinPasswordLength: Integer; safecall;
    procedure Set_MinPasswordLength(retval: Integer); safecall;
    function  Get_MinPasswordAge: Integer; safecall;
    procedure Set_MinPasswordAge(retval: Integer); safecall;
    function  Get_MaxPasswordAge: Integer; safecall;
    procedure Set_MaxPasswordAge(retval: Integer); safecall;
    function  Get_MaxBadPasswordsAllowed: Integer; safecall;
    procedure Set_MaxBadPasswordsAllowed(retval: Integer); safecall;
    function  Get_PasswordHistoryLength: Integer; safecall;
    procedure Set_PasswordHistoryLength(retval: Integer); safecall;
    function  Get_PasswordAttributes: Integer; safecall;
    procedure Set_PasswordAttributes(retval: Integer); safecall;
    function  Get_AutoUnlockInterval: Integer; safecall;
    procedure Set_AutoUnlockInterval(retval: Integer); safecall;
    function  Get_LockoutObservationInterval: Integer; safecall;
    procedure Set_LockoutObservationInterval(retval: Integer); safecall;
    property IsWorkgroup: WordBool read Get_IsWorkgroup;
    property MinPasswordLength: Integer read Get_MinPasswordLength write Set_MinPasswordLength;
    property MinPasswordAge: Integer read Get_MinPasswordAge write Set_MinPasswordAge;
    property MaxPasswordAge: Integer read Get_MaxPasswordAge write Set_MaxPasswordAge;
    property MaxBadPasswordsAllowed: Integer read Get_MaxBadPasswordsAllowed write Set_MaxBadPasswordsAllowed;
    property PasswordHistoryLength: Integer read Get_PasswordHistoryLength write Set_PasswordHistoryLength;
    property PasswordAttributes: Integer read Get_PasswordAttributes write Set_PasswordAttributes;
    property AutoUnlockInterval: Integer read Get_AutoUnlockInterval write Set_AutoUnlockInterval;
    property LockoutObservationInterval: Integer read Get_LockoutObservationInterval write Set_LockoutObservationInterval;
  end;

// *********************************************************************//
// DispIntf:  IADsDomainDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {00E4C220-FD16-11CE-ABC4-02608C9E7553}
// *********************************************************************//
  IADsDomainDisp = dispinterface
    ['{00E4C220-FD16-11CE-ABC4-02608C9E7553}']
    property IsWorkgroup: WordBool readonly dispid 15;
    property MinPasswordLength: Integer dispid 16;
    property MinPasswordAge: Integer dispid 17;
    property MaxPasswordAge: Integer dispid 18;
    property MaxBadPasswordsAllowed: Integer dispid 19;
    property PasswordHistoryLength: Integer dispid 20;
    property PasswordAttributes: Integer dispid 21;
    property AutoUnlockInterval: Integer dispid 22;
    property LockoutObservationInterval: Integer dispid 23;
    property Name: WideString readonly dispid 2;
    property Class_: WideString readonly dispid 3;
    property GUID: WideString readonly dispid 4;
    property ADsPath: WideString readonly dispid 5;
    property Parent: WideString readonly dispid 6;
    property Schema: WideString readonly dispid 7;
    procedure GetInfo; dispid 8;
    procedure SetInfo; dispid 9;
    function  Get(const bstrName: WideString): OleVariant; dispid 10;
    procedure Put(const bstrName: WideString; vProp: OleVariant); dispid 11;
    function  GetEx(const bstrName: WideString): OleVariant; dispid 12;
    procedure PutEx(lnControlCode: Integer; const bstrName: WideString; vProp: OleVariant); dispid 13;
    procedure GetInfoEx(vProperties: OleVariant; lnReserved: Integer); dispid 14;
  end;

// *********************************************************************//
// Schnittstelle: IADsComputer
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {EFE3CC70-1D9F-11CF-B1F3-02608C9E7553}
// *********************************************************************//
  IADsComputer = interface(IADs)
    ['{EFE3CC70-1D9F-11CF-B1F3-02608C9E7553}']
    function  Get_ComputerID: WideString; safecall;
    function  Get_Site: WideString; safecall;
    function  Get_Description: WideString; safecall;
    procedure Set_Description(const retval: WideString); safecall;
    function  Get_Location: WideString; safecall;
    procedure Set_Location(const retval: WideString); safecall;
    function  Get_PrimaryUser: WideString; safecall;
    procedure Set_PrimaryUser(const retval: WideString); safecall;
    function  Get_Owner: WideString; safecall;
    procedure Set_Owner(const retval: WideString); safecall;
    function  Get_Division: WideString; safecall;
    procedure Set_Division(const retval: WideString); safecall;
    function  Get_Department: WideString; safecall;
    procedure Set_Department(const retval: WideString); safecall;
    function  Get_Role: WideString; safecall;
    procedure Set_Role(const retval: WideString); safecall;
    function  Get_OperatingSystem: WideString; safecall;
    procedure Set_OperatingSystem(const retval: WideString); safecall;
    function  Get_OperatingSystemVersion: WideString; safecall;
    procedure Set_OperatingSystemVersion(const retval: WideString); safecall;
    function  Get_Model: WideString; safecall;
    procedure Set_Model(const retval: WideString); safecall;
    function  Get_Processor: WideString; safecall;
    procedure Set_Processor(const retval: WideString); safecall;
    function  Get_ProcessorCount: WideString; safecall;
    procedure Set_ProcessorCount(const retval: WideString); safecall;
    function  Get_MemorySize: WideString; safecall;
    procedure Set_MemorySize(const retval: WideString); safecall;
    function  Get_StorageCapacity: WideString; safecall;
    procedure Set_StorageCapacity(const retval: WideString); safecall;
    function  Get_NetAddresses: OleVariant; safecall;
    procedure Set_NetAddresses(retval: OleVariant); safecall;
    property ComputerID: WideString read Get_ComputerID;
    property Site: WideString read Get_Site;
    property Description: WideString read Get_Description write Set_Description;
    property Location: WideString read Get_Location write Set_Location;
    property PrimaryUser: WideString read Get_PrimaryUser write Set_PrimaryUser;
    property Owner: WideString read Get_Owner write Set_Owner;
    property Division: WideString read Get_Division write Set_Division;
    property Department: WideString read Get_Department write Set_Department;
    property Role: WideString read Get_Role write Set_Role;
    property OperatingSystem: WideString read Get_OperatingSystem write Set_OperatingSystem;
    property OperatingSystemVersion: WideString read Get_OperatingSystemVersion write Set_OperatingSystemVersion;
    property Model: WideString read Get_Model write Set_Model;
    property Processor: WideString read Get_Processor write Set_Processor;
    property ProcessorCount: WideString read Get_ProcessorCount write Set_ProcessorCount;
    property MemorySize: WideString read Get_MemorySize write Set_MemorySize;
    property StorageCapacity: WideString read Get_StorageCapacity write Set_StorageCapacity;
    property NetAddresses: OleVariant read Get_NetAddresses write Set_NetAddresses;
  end;

// *********************************************************************//
// DispIntf:  IADsComputerDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {EFE3CC70-1D9F-11CF-B1F3-02608C9E7553}
// *********************************************************************//
  IADsComputerDisp = dispinterface
    ['{EFE3CC70-1D9F-11CF-B1F3-02608C9E7553}']
    property ComputerID: WideString readonly dispid 16;
    property Site: WideString readonly dispid 18;
    property Description: WideString dispid 19;
    property Location: WideString dispid 20;
    property PrimaryUser: WideString dispid 21;
    property Owner: WideString dispid 22;
    property Division: WideString dispid 23;
    property Department: WideString dispid 24;
    property Role: WideString dispid 25;
    property OperatingSystem: WideString dispid 26;
    property OperatingSystemVersion: WideString dispid 27;
    property Model: WideString dispid 28;
    property Processor: WideString dispid 29;
    property ProcessorCount: WideString dispid 30;
    property MemorySize: WideString dispid 31;
    property StorageCapacity: WideString dispid 32;
    property NetAddresses: OleVariant dispid 17;
    property Name: WideString readonly dispid 2;
    property Class_: WideString readonly dispid 3;
    property GUID: WideString readonly dispid 4;
    property ADsPath: WideString readonly dispid 5;
    property Parent: WideString readonly dispid 6;
    property Schema: WideString readonly dispid 7;
    procedure GetInfo; dispid 8;
    procedure SetInfo; dispid 9;
    function  Get(const bstrName: WideString): OleVariant; dispid 10;
    procedure Put(const bstrName: WideString; vProp: OleVariant); dispid 11;
    function  GetEx(const bstrName: WideString): OleVariant; dispid 12;
    procedure PutEx(lnControlCode: Integer; const bstrName: WideString; vProp: OleVariant); dispid 13;
    procedure GetInfoEx(vProperties: OleVariant; lnReserved: Integer); dispid 14;
  end;

// *********************************************************************//
// Schnittstelle: IADsComputerOperations
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {EF497680-1D9F-11CF-B1F3-02608C9E7553}
// *********************************************************************//
  IADsComputerOperations = interface(IADs)
    ['{EF497680-1D9F-11CF-B1F3-02608C9E7553}']
    function  Status: IDispatch; safecall;
    procedure Shutdown(bReboot: WordBool); safecall;
  end;

// *********************************************************************//
// DispIntf:  IADsComputerOperationsDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {EF497680-1D9F-11CF-B1F3-02608C9E7553}
// *********************************************************************//
  IADsComputerOperationsDisp = dispinterface
    ['{EF497680-1D9F-11CF-B1F3-02608C9E7553}']
    function  Status: IDispatch; dispid 33;
    procedure Shutdown(bReboot: WordBool); dispid 34;
    property Name: WideString readonly dispid 2;
    property Class_: WideString readonly dispid 3;
    property GUID: WideString readonly dispid 4;
    property ADsPath: WideString readonly dispid 5;
    property Parent: WideString readonly dispid 6;
    property Schema: WideString readonly dispid 7;
    procedure GetInfo; dispid 8;
    procedure SetInfo; dispid 9;
    function  Get(const bstrName: WideString): OleVariant; dispid 10;
    procedure Put(const bstrName: WideString; vProp: OleVariant); dispid 11;
    function  GetEx(const bstrName: WideString): OleVariant; dispid 12;
    procedure PutEx(lnControlCode: Integer; const bstrName: WideString; vProp: OleVariant); dispid 13;
    procedure GetInfoEx(vProperties: OleVariant; lnReserved: Integer); dispid 14;
  end;

// *********************************************************************//
// Schnittstelle: IADsGroup
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {27636B00-410F-11CF-B1FF-02608C9E7553}
// *********************************************************************//
  IADsGroup = interface(IADs)
    ['{27636B00-410F-11CF-B1FF-02608C9E7553}']
    function  Get_Description: WideString; safecall;
    procedure Set_Description(const retval: WideString); safecall;
    function  Members: IADsMembers; safecall;
    function  IsMember(const bstrMember: WideString): WordBool; safecall;
    procedure Add(const bstrNewItem: WideString); safecall;
    procedure Remove(const bstrItemToBeRemoved: WideString); safecall;
    property Description: WideString read Get_Description write Set_Description;
  end;

// *********************************************************************//
// DispIntf:  IADsGroupDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {27636B00-410F-11CF-B1FF-02608C9E7553}
// *********************************************************************//
  IADsGroupDisp = dispinterface
    ['{27636B00-410F-11CF-B1FF-02608C9E7553}']
    property Description: WideString dispid 15;
    function  Members: IADsMembers; dispid 16;
    function  IsMember(const bstrMember: WideString): WordBool; dispid 17;
    procedure Add(const bstrNewItem: WideString); dispid 18;
    procedure Remove(const bstrItemToBeRemoved: WideString); dispid 19;
    property Name: WideString readonly dispid 2;
    property Class_: WideString readonly dispid 3;
    property GUID: WideString readonly dispid 4;
    property ADsPath: WideString readonly dispid 5;
    property Parent: WideString readonly dispid 6;
    property Schema: WideString readonly dispid 7;
    procedure GetInfo; dispid 8;
    procedure SetInfo; dispid 9;
    function  Get(const bstrName: WideString): OleVariant; dispid 10;
    procedure Put(const bstrName: WideString; vProp: OleVariant); dispid 11;
    function  GetEx(const bstrName: WideString): OleVariant; dispid 12;
    procedure PutEx(lnControlCode: Integer; const bstrName: WideString; vProp: OleVariant); dispid 13;
    procedure GetInfoEx(vProperties: OleVariant; lnReserved: Integer); dispid 14;
  end;

// *********************************************************************//
// Schnittstelle: IADsUser
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {3E37E320-17E2-11CF-ABC4-02608C9E7553}
// *********************************************************************//
  IADsUser = interface(IADs)
    ['{3E37E320-17E2-11CF-ABC4-02608C9E7553}']
    function  Get_BadLoginAddress: WideString; safecall;
    function  Get_BadLoginCount: Integer; safecall;
    function  Get_LastLogin: TDateTime; safecall;
    function  Get_LastLogoff: TDateTime; safecall;
    function  Get_LastFailedLogin: TDateTime; safecall;
    function  Get_PasswordLastChanged: TDateTime; safecall;
    function  Get_Description: WideString; safecall;
    procedure Set_Description(const retval: WideString); safecall;
    function  Get_Division: WideString; safecall;
    procedure Set_Division(const retval: WideString); safecall;
    function  Get_Department: WideString; safecall;
    procedure Set_Department(const retval: WideString); safecall;
    function  Get_EmployeeID: WideString; safecall;
    procedure Set_EmployeeID(const retval: WideString); safecall;
    function  Get_FullName: WideString; safecall;
    procedure Set_FullName(const retval: WideString); safecall;
    function  Get_FirstName: WideString; safecall;
    procedure Set_FirstName(const retval: WideString); safecall;
    function  Get_LastName: WideString; safecall;
    procedure Set_LastName(const retval: WideString); safecall;
    function  Get_OtherName: WideString; safecall;
    procedure Set_OtherName(const retval: WideString); safecall;
    function  Get_NamePrefix: WideString; safecall;
    procedure Set_NamePrefix(const retval: WideString); safecall;
    function  Get_NameSuffix: WideString; safecall;
    procedure Set_NameSuffix(const retval: WideString); safecall;
    function  Get_Title: WideString; safecall;
    procedure Set_Title(const retval: WideString); safecall;
    function  Get_Manager: WideString; safecall;
    procedure Set_Manager(const retval: WideString); safecall;
    function  Get_TelephoneHome: OleVariant; safecall;
    procedure Set_TelephoneHome(retval: OleVariant); safecall;
    function  Get_TelephoneMobile: OleVariant; safecall;
    procedure Set_TelephoneMobile(retval: OleVariant); safecall;
    function  Get_TelephoneNumber: OleVariant; safecall;
    procedure Set_TelephoneNumber(retval: OleVariant); safecall;
    function  Get_TelephonePager: OleVariant; safecall;
    procedure Set_TelephonePager(retval: OleVariant); safecall;
    function  Get_FaxNumber: OleVariant; safecall;
    procedure Set_FaxNumber(retval: OleVariant); safecall;
    function  Get_OfficeLocations: OleVariant; safecall;
    procedure Set_OfficeLocations(retval: OleVariant); safecall;
    function  Get_PostalAddresses: OleVariant; safecall;
    procedure Set_PostalAddresses(retval: OleVariant); safecall;
    function  Get_PostalCodes: OleVariant; safecall;
    procedure Set_PostalCodes(retval: OleVariant); safecall;
    function  Get_SeeAlso: OleVariant; safecall;
    procedure Set_SeeAlso(retval: OleVariant); safecall;
    function  Get_AccountDisabled: WordBool; safecall;
    procedure Set_AccountDisabled(retval: WordBool); safecall;
    function  Get_AccountExpirationDate: TDateTime; safecall;
    procedure Set_AccountExpirationDate(retval: TDateTime); safecall;
    function  Get_GraceLoginsAllowed: Integer; safecall;
    procedure Set_GraceLoginsAllowed(retval: Integer); safecall;
    function  Get_GraceLoginsRemaining: Integer; safecall;
    procedure Set_GraceLoginsRemaining(retval: Integer); safecall;
    function  Get_IsAccountLocked: WordBool; safecall;
    procedure Set_IsAccountLocked(retval: WordBool); safecall;
    function  Get_LoginHours: OleVariant; safecall;
    procedure Set_LoginHours(retval: OleVariant); safecall;
    function  Get_LoginWorkstations: OleVariant; safecall;
    procedure Set_LoginWorkstations(retval: OleVariant); safecall;
    function  Get_MaxLogins: Integer; safecall;
    procedure Set_MaxLogins(retval: Integer); safecall;
    function  Get_MaxStorage: Integer; safecall;
    procedure Set_MaxStorage(retval: Integer); safecall;
    function  Get_PasswordExpirationDate: TDateTime; safecall;
    procedure Set_PasswordExpirationDate(retval: TDateTime); safecall;
    function  Get_PasswordMinimumLength: Integer; safecall;
    procedure Set_PasswordMinimumLength(retval: Integer); safecall;
    function  Get_PasswordRequired: WordBool; safecall;
    procedure Set_PasswordRequired(retval: WordBool); safecall;
    function  Get_RequireUniquePassword: WordBool; safecall;
    procedure Set_RequireUniquePassword(retval: WordBool); safecall;
    function  Get_EmailAddress: WideString; safecall;
    procedure Set_EmailAddress(const retval: WideString); safecall;
    function  Get_HomeDirectory: WideString; safecall;
    procedure Set_HomeDirectory(const retval: WideString); safecall;
    function  Get_Languages: OleVariant; safecall;
    procedure Set_Languages(retval: OleVariant); safecall;
    function  Get_Profile: WideString; safecall;
    procedure Set_Profile(const retval: WideString); safecall;
    function  Get_LoginScript: WideString; safecall;
    procedure Set_LoginScript(const retval: WideString); safecall;
    function  Get_Picture: OleVariant; safecall;
    procedure Set_Picture(retval: OleVariant); safecall;
    function  Get_HomePage: WideString; safecall;
    procedure Set_HomePage(const retval: WideString); safecall;
    function  Groups: IADsMembers; safecall;
    procedure SetPassword(const NewPassword: WideString); safecall;
    procedure ChangePassword(const bstrOldPassword: WideString; const bstrNewPassword: WideString); safecall;
    property BadLoginAddress: WideString read Get_BadLoginAddress;
    property BadLoginCount: Integer read Get_BadLoginCount;
    property LastLogin: TDateTime read Get_LastLogin;
    property LastLogoff: TDateTime read Get_LastLogoff;
    property LastFailedLogin: TDateTime read Get_LastFailedLogin;
    property PasswordLastChanged: TDateTime read Get_PasswordLastChanged;
    property Description: WideString read Get_Description write Set_Description;
    property Division: WideString read Get_Division write Set_Division;
    property Department: WideString read Get_Department write Set_Department;
    property EmployeeID: WideString read Get_EmployeeID write Set_EmployeeID;
    property FullName: WideString read Get_FullName write Set_FullName;
    property FirstName: WideString read Get_FirstName write Set_FirstName;
    property LastName: WideString read Get_LastName write Set_LastName;
    property OtherName: WideString read Get_OtherName write Set_OtherName;
    property NamePrefix: WideString read Get_NamePrefix write Set_NamePrefix;
    property NameSuffix: WideString read Get_NameSuffix write Set_NameSuffix;
    property Title: WideString read Get_Title write Set_Title;
    property Manager: WideString read Get_Manager write Set_Manager;
    property TelephoneHome: OleVariant read Get_TelephoneHome write Set_TelephoneHome;
    property TelephoneMobile: OleVariant read Get_TelephoneMobile write Set_TelephoneMobile;
    property TelephoneNumber: OleVariant read Get_TelephoneNumber write Set_TelephoneNumber;
    property TelephonePager: OleVariant read Get_TelephonePager write Set_TelephonePager;
    property FaxNumber: OleVariant read Get_FaxNumber write Set_FaxNumber;
    property OfficeLocations: OleVariant read Get_OfficeLocations write Set_OfficeLocations;
    property PostalAddresses: OleVariant read Get_PostalAddresses write Set_PostalAddresses;
    property PostalCodes: OleVariant read Get_PostalCodes write Set_PostalCodes;
    property SeeAlso: OleVariant read Get_SeeAlso write Set_SeeAlso;
    property AccountDisabled: WordBool read Get_AccountDisabled write Set_AccountDisabled;
    property AccountExpirationDate: TDateTime read Get_AccountExpirationDate write Set_AccountExpirationDate;
    property GraceLoginsAllowed: Integer read Get_GraceLoginsAllowed write Set_GraceLoginsAllowed;
    property GraceLoginsRemaining: Integer read Get_GraceLoginsRemaining write Set_GraceLoginsRemaining;
    property IsAccountLocked: WordBool read Get_IsAccountLocked write Set_IsAccountLocked;
    property LoginHours: OleVariant read Get_LoginHours write Set_LoginHours;
    property LoginWorkstations: OleVariant read Get_LoginWorkstations write Set_LoginWorkstations;
    property MaxLogins: Integer read Get_MaxLogins write Set_MaxLogins;
    property MaxStorage: Integer read Get_MaxStorage write Set_MaxStorage;
    property PasswordExpirationDate: TDateTime read Get_PasswordExpirationDate write Set_PasswordExpirationDate;
    property PasswordMinimumLength: Integer read Get_PasswordMinimumLength write Set_PasswordMinimumLength;
    property PasswordRequired: WordBool read Get_PasswordRequired write Set_PasswordRequired;
    property RequireUniquePassword: WordBool read Get_RequireUniquePassword write Set_RequireUniquePassword;
    property EmailAddress: WideString read Get_EmailAddress write Set_EmailAddress;
    property HomeDirectory: WideString read Get_HomeDirectory write Set_HomeDirectory;
    property Languages: OleVariant read Get_Languages write Set_Languages;
    property Profile: WideString read Get_Profile write Set_Profile;
    property LoginScript: WideString read Get_LoginScript write Set_LoginScript;
    property Picture: OleVariant read Get_Picture write Set_Picture;
    property HomePage: WideString read Get_HomePage write Set_HomePage;
  end;

// *********************************************************************//
// DispIntf:  IADsUserDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {3E37E320-17E2-11CF-ABC4-02608C9E7553}
// *********************************************************************//
  IADsUserDisp = dispinterface
    ['{3E37E320-17E2-11CF-ABC4-02608C9E7553}']
    property BadLoginAddress: WideString readonly dispid 53;
    property BadLoginCount: Integer readonly dispid 54;
    property LastLogin: TDateTime readonly dispid 56;
    property LastLogoff: TDateTime readonly dispid 57;
    property LastFailedLogin: TDateTime readonly dispid 58;
    property PasswordLastChanged: TDateTime readonly dispid 59;
    property Description: WideString dispid 15;
    property Division: WideString dispid 19;
    property Department: WideString dispid 122;
    property EmployeeID: WideString dispid 20;
    property FullName: WideString dispid 23;
    property FirstName: WideString dispid 22;
    property LastName: WideString dispid 25;
    property OtherName: WideString dispid 27;
    property NamePrefix: WideString dispid 114;
    property NameSuffix: WideString dispid 115;
    property Title: WideString dispid 36;
    property Manager: WideString dispid 26;
    property TelephoneHome: OleVariant dispid 32;
    property TelephoneMobile: OleVariant dispid 33;
    property TelephoneNumber: OleVariant dispid 34;
    property TelephonePager: OleVariant dispid 17;
    property FaxNumber: OleVariant dispid 16;
    property OfficeLocations: OleVariant dispid 28;
    property PostalAddresses: OleVariant dispid 30;
    property PostalCodes: OleVariant dispid 31;
    property SeeAlso: OleVariant dispid 117;
    property AccountDisabled: WordBool dispid 37;
    property AccountExpirationDate: TDateTime dispid 38;
    property GraceLoginsAllowed: Integer dispid 41;
    property GraceLoginsRemaining: Integer dispid 42;
    property IsAccountLocked: WordBool dispid 43;
    property LoginHours: OleVariant dispid 45;
    property LoginWorkstations: OleVariant dispid 46;
    property MaxLogins: Integer dispid 47;
    property MaxStorage: Integer dispid 48;
    property PasswordExpirationDate: TDateTime dispid 49;
    property PasswordMinimumLength: Integer dispid 50;
    property PasswordRequired: WordBool dispid 51;
    property RequireUniquePassword: WordBool dispid 52;
    property EmailAddress: WideString dispid 60;
    property HomeDirectory: WideString dispid 61;
    property Languages: OleVariant dispid 62;
    property Profile: WideString dispid 63;
    property LoginScript: WideString dispid 64;
    property Picture: OleVariant dispid 65;
    property HomePage: WideString dispid 120;
    function  Groups: IADsMembers; dispid 66;
    procedure SetPassword(const NewPassword: WideString); dispid 67;
    procedure ChangePassword(const bstrOldPassword: WideString; const bstrNewPassword: WideString); dispid 68;
    property Name: WideString readonly dispid 2;
    property Class_: WideString readonly dispid 3;
    property GUID: WideString readonly dispid 4;
    property ADsPath: WideString readonly dispid 5;
    property Parent: WideString readonly dispid 6;
    property Schema: WideString readonly dispid 7;
    procedure GetInfo; dispid 8;
    procedure SetInfo; dispid 9;
    function  Get(const bstrName: WideString): OleVariant; dispid 10;
    procedure Put(const bstrName: WideString; vProp: OleVariant); dispid 11;
    function  GetEx(const bstrName: WideString): OleVariant; dispid 12;
    procedure PutEx(lnControlCode: Integer; const bstrName: WideString; vProp: OleVariant); dispid 13;
    procedure GetInfoEx(vProperties: OleVariant; lnReserved: Integer); dispid 14;
  end;

// *********************************************************************//
// Schnittstelle: IADsPrintQueue
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {B15160D0-1226-11CF-A985-00AA006BC149}
// *********************************************************************//
  IADsPrintQueue = interface(IADs)
    ['{B15160D0-1226-11CF-A985-00AA006BC149}']
    function  Get_PrinterPath: WideString; safecall;
    procedure Set_PrinterPath(const retval: WideString); safecall;
    function  Get_Model: WideString; safecall;
    procedure Set_Model(const retval: WideString); safecall;
    function  Get_Datatype: WideString; safecall;
    procedure Set_Datatype(const retval: WideString); safecall;
    function  Get_PrintProcessor: WideString; safecall;
    procedure Set_PrintProcessor(const retval: WideString); safecall;
    function  Get_Description: WideString; safecall;
    procedure Set_Description(const retval: WideString); safecall;
    function  Get_Location: WideString; safecall;
    procedure Set_Location(const retval: WideString); safecall;
    function  Get_StartTime: TDateTime; safecall;
    procedure Set_StartTime(retval: TDateTime); safecall;
    function  Get_UntilTime: TDateTime; safecall;
    procedure Set_UntilTime(retval: TDateTime); safecall;
    function  Get_DefaultJobPriority: Integer; safecall;
    procedure Set_DefaultJobPriority(retval: Integer); safecall;
    function  Get_Priority: Integer; safecall;
    procedure Set_Priority(retval: Integer); safecall;
    function  Get_BannerPage: WideString; safecall;
    procedure Set_BannerPage(const retval: WideString); safecall;
    function  Get_PrintDevices: OleVariant; safecall;
    procedure Set_PrintDevices(retval: OleVariant); safecall;
    function  Get_NetAddresses: OleVariant; safecall;
    procedure Set_NetAddresses(retval: OleVariant); safecall;
    property PrinterPath: WideString read Get_PrinterPath write Set_PrinterPath;
    property Model: WideString read Get_Model write Set_Model;
    property Datatype: WideString read Get_Datatype write Set_Datatype;
    property PrintProcessor: WideString read Get_PrintProcessor write Set_PrintProcessor;
    property Description: WideString read Get_Description write Set_Description;
    property Location: WideString read Get_Location write Set_Location;
    property StartTime: TDateTime read Get_StartTime write Set_StartTime;
    property UntilTime: TDateTime read Get_UntilTime write Set_UntilTime;
    property DefaultJobPriority: Integer read Get_DefaultJobPriority write Set_DefaultJobPriority;
    property Priority: Integer read Get_Priority write Set_Priority;
    property BannerPage: WideString read Get_BannerPage write Set_BannerPage;
    property PrintDevices: OleVariant read Get_PrintDevices write Set_PrintDevices;
    property NetAddresses: OleVariant read Get_NetAddresses write Set_NetAddresses;
  end;

// *********************************************************************//
// DispIntf:  IADsPrintQueueDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {B15160D0-1226-11CF-A985-00AA006BC149}
// *********************************************************************//
  IADsPrintQueueDisp = dispinterface
    ['{B15160D0-1226-11CF-A985-00AA006BC149}']
    property PrinterPath: WideString dispid 15;
    property Model: WideString dispid 16;
    property Datatype: WideString dispid 17;
    property PrintProcessor: WideString dispid 18;
    property Description: WideString dispid 19;
    property Location: WideString dispid 20;
    property StartTime: TDateTime dispid 21;
    property UntilTime: TDateTime dispid 22;
    property DefaultJobPriority: Integer dispid 23;
    property Priority: Integer dispid 24;
    property BannerPage: WideString dispid 25;
    property PrintDevices: OleVariant dispid 26;
    property NetAddresses: OleVariant dispid 27;
    property Name: WideString readonly dispid 2;
    property Class_: WideString readonly dispid 3;
    property GUID: WideString readonly dispid 4;
    property ADsPath: WideString readonly dispid 5;
    property Parent: WideString readonly dispid 6;
    property Schema: WideString readonly dispid 7;
    procedure GetInfo; dispid 8;
    procedure SetInfo; dispid 9;
    function  Get(const bstrName: WideString): OleVariant; dispid 10;
    procedure Put(const bstrName: WideString; vProp: OleVariant); dispid 11;
    function  GetEx(const bstrName: WideString): OleVariant; dispid 12;
    procedure PutEx(lnControlCode: Integer; const bstrName: WideString; vProp: OleVariant); dispid 13;
    procedure GetInfoEx(vProperties: OleVariant; lnReserved: Integer); dispid 14;
  end;

// *********************************************************************//
// Schnittstelle: IADsPrintQueueOperations
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {124BE5C0-156E-11CF-A986-00AA006BC149}
// *********************************************************************//
  IADsPrintQueueOperations = interface(IADs)
    ['{124BE5C0-156E-11CF-A986-00AA006BC149}']
    function  Get_Status: Integer; safecall;
    function  PrintJobs: IADsCollection; safecall;
    procedure Pause; safecall;
    procedure Resume; safecall;
    procedure Purge; safecall;
    property Status: Integer read Get_Status;
  end;

// *********************************************************************//
// DispIntf:  IADsPrintQueueOperationsDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {124BE5C0-156E-11CF-A986-00AA006BC149}
// *********************************************************************//
  IADsPrintQueueOperationsDisp = dispinterface
    ['{124BE5C0-156E-11CF-A986-00AA006BC149}']
    property Status: Integer readonly dispid 27;
    function  PrintJobs: IADsCollection; dispid 28;
    procedure Pause; dispid 29;
    procedure Resume; dispid 30;
    procedure Purge; dispid 31;
    property Name: WideString readonly dispid 2;
    property Class_: WideString readonly dispid 3;
    property GUID: WideString readonly dispid 4;
    property ADsPath: WideString readonly dispid 5;
    property Parent: WideString readonly dispid 6;
    property Schema: WideString readonly dispid 7;
    procedure GetInfo; dispid 8;
    procedure SetInfo; dispid 9;
    function  Get(const bstrName: WideString): OleVariant; dispid 10;
    procedure Put(const bstrName: WideString; vProp: OleVariant); dispid 11;
    function  GetEx(const bstrName: WideString): OleVariant; dispid 12;
    procedure PutEx(lnControlCode: Integer; const bstrName: WideString; vProp: OleVariant); dispid 13;
    procedure GetInfoEx(vProperties: OleVariant; lnReserved: Integer); dispid 14;
  end;

// *********************************************************************//
// Schnittstelle: IADsPrintJob
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {32FB6780-1ED0-11CF-A988-00AA006BC149}
// *********************************************************************//
  IADsPrintJob = interface(IADs)
    ['{32FB6780-1ED0-11CF-A988-00AA006BC149}']
    function  Get_HostPrintQueue: WideString; safecall;
    function  Get_User: WideString; safecall;
    function  Get_UserPath: WideString; safecall;
    function  Get_TimeSubmitted: TDateTime; safecall;
    function  Get_TotalPages: Integer; safecall;
    function  Get_Size: Integer; safecall;
    function  Get_Description: WideString; safecall;
    procedure Set_Description(const retval: WideString); safecall;
    function  Get_Priority: Integer; safecall;
    procedure Set_Priority(retval: Integer); safecall;
    function  Get_StartTime: TDateTime; safecall;
    procedure Set_StartTime(retval: TDateTime); safecall;
    function  Get_UntilTime: TDateTime; safecall;
    procedure Set_UntilTime(retval: TDateTime); safecall;
    function  Get_Notify: WideString; safecall;
    procedure Set_Notify(const retval: WideString); safecall;
    function  Get_NotifyPath: WideString; safecall;
    procedure Set_NotifyPath(const retval: WideString); safecall;
    property HostPrintQueue: WideString read Get_HostPrintQueue;
    property User: WideString read Get_User;
    property UserPath: WideString read Get_UserPath;
    property TimeSubmitted: TDateTime read Get_TimeSubmitted;
    property TotalPages: Integer read Get_TotalPages;
    property Size: Integer read Get_Size;
    property Description: WideString read Get_Description write Set_Description;
    property Priority: Integer read Get_Priority write Set_Priority;
    property StartTime: TDateTime read Get_StartTime write Set_StartTime;
    property UntilTime: TDateTime read Get_UntilTime write Set_UntilTime;
    property Notify: WideString read Get_Notify write Set_Notify;
    property NotifyPath: WideString read Get_NotifyPath write Set_NotifyPath;
  end;

// *********************************************************************//
// DispIntf:  IADsPrintJobDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {32FB6780-1ED0-11CF-A988-00AA006BC149}
// *********************************************************************//
  IADsPrintJobDisp = dispinterface
    ['{32FB6780-1ED0-11CF-A988-00AA006BC149}']
    property HostPrintQueue: WideString readonly dispid 15;
    property User: WideString readonly dispid 16;
    property UserPath: WideString readonly dispid 17;
    property TimeSubmitted: TDateTime readonly dispid 18;
    property TotalPages: Integer readonly dispid 19;
    property Size: Integer readonly dispid 234;
    property Description: WideString dispid 20;
    property Priority: Integer dispid 21;
    property StartTime: TDateTime dispid 22;
    property UntilTime: TDateTime dispid 23;
    property Notify: WideString dispid 24;
    property NotifyPath: WideString dispid 25;
    property Name: WideString readonly dispid 2;
    property Class_: WideString readonly dispid 3;
    property GUID: WideString readonly dispid 4;
    property ADsPath: WideString readonly dispid 5;
    property Parent: WideString readonly dispid 6;
    property Schema: WideString readonly dispid 7;
    procedure GetInfo; dispid 8;
    procedure SetInfo; dispid 9;
    function  Get(const bstrName: WideString): OleVariant; dispid 10;
    procedure Put(const bstrName: WideString; vProp: OleVariant); dispid 11;
    function  GetEx(const bstrName: WideString): OleVariant; dispid 12;
    procedure PutEx(lnControlCode: Integer; const bstrName: WideString; vProp: OleVariant); dispid 13;
    procedure GetInfoEx(vProperties: OleVariant; lnReserved: Integer); dispid 14;
  end;

// *********************************************************************//
// Schnittstelle: IADsPrintJobOperations
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {9A52DB30-1ECF-11CF-A988-00AA006BC149}
// *********************************************************************//
  IADsPrintJobOperations = interface(IADs)
    ['{9A52DB30-1ECF-11CF-A988-00AA006BC149}']
    function  Get_Status: Integer; safecall;
    function  Get_TimeElapsed: Integer; safecall;
    function  Get_PagesPrinted: Integer; safecall;
    function  Get_Position: Integer; safecall;
    procedure Set_Position(retval: Integer); safecall;
    procedure Pause; safecall;
    procedure Resume; safecall;
    property Status: Integer read Get_Status;
    property TimeElapsed: Integer read Get_TimeElapsed;
    property PagesPrinted: Integer read Get_PagesPrinted;
    property Position: Integer read Get_Position write Set_Position;
  end;

// *********************************************************************//
// DispIntf:  IADsPrintJobOperationsDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {9A52DB30-1ECF-11CF-A988-00AA006BC149}
// *********************************************************************//
  IADsPrintJobOperationsDisp = dispinterface
    ['{9A52DB30-1ECF-11CF-A988-00AA006BC149}']
    property Status: Integer readonly dispid 26;
    property TimeElapsed: Integer readonly dispid 27;
    property PagesPrinted: Integer readonly dispid 28;
    property Position: Integer dispid 29;
    procedure Pause; dispid 30;
    procedure Resume; dispid 31;
    property Name: WideString readonly dispid 2;
    property Class_: WideString readonly dispid 3;
    property GUID: WideString readonly dispid 4;
    property ADsPath: WideString readonly dispid 5;
    property Parent: WideString readonly dispid 6;
    property Schema: WideString readonly dispid 7;
    procedure GetInfo; dispid 8;
    procedure SetInfo; dispid 9;
    function  Get(const bstrName: WideString): OleVariant; dispid 10;
    procedure Put(const bstrName: WideString; vProp: OleVariant); dispid 11;
    function  GetEx(const bstrName: WideString): OleVariant; dispid 12;
    procedure PutEx(lnControlCode: Integer; const bstrName: WideString; vProp: OleVariant); dispid 13;
    procedure GetInfoEx(vProperties: OleVariant; lnReserved: Integer); dispid 14;
  end;

// *********************************************************************//
// Schnittstelle: IADsService
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {68AF66E0-31CA-11CF-A98A-00AA006BC149}
// *********************************************************************//
  IADsService = interface(IADs)
    ['{68AF66E0-31CA-11CF-A98A-00AA006BC149}']
    function  Get_HostComputer: WideString; safecall;
    procedure Set_HostComputer(const retval: WideString); safecall;
    function  Get_DisplayName: WideString; safecall;
    procedure Set_DisplayName(const retval: WideString); safecall;
    function  Get_Version: WideString; safecall;
    procedure Set_Version(const retval: WideString); safecall;
    function  Get_ServiceType: Integer; safecall;
    procedure Set_ServiceType(retval: Integer); safecall;
    function  Get_StartType: Integer; safecall;
    procedure Set_StartType(retval: Integer); safecall;
    function  Get_Path: WideString; safecall;
    procedure Set_Path(const retval: WideString); safecall;
    function  Get_StartupParameters: WideString; safecall;
    procedure Set_StartupParameters(const retval: WideString); safecall;
    function  Get_ErrorControl: Integer; safecall;
    procedure Set_ErrorControl(retval: Integer); safecall;
    function  Get_LoadOrderGroup: WideString; safecall;
    procedure Set_LoadOrderGroup(const retval: WideString); safecall;
    function  Get_ServiceAccountName: WideString; safecall;
    procedure Set_ServiceAccountName(const retval: WideString); safecall;
    function  Get_ServiceAccountPath: WideString; safecall;
    procedure Set_ServiceAccountPath(const retval: WideString); safecall;
    function  Get_Dependencies: OleVariant; safecall;
    procedure Set_Dependencies(retval: OleVariant); safecall;
    property HostComputer: WideString read Get_HostComputer write Set_HostComputer;
    property DisplayName: WideString read Get_DisplayName write Set_DisplayName;
    property Version: WideString read Get_Version write Set_Version;
    property ServiceType: Integer read Get_ServiceType write Set_ServiceType;
    property StartType: Integer read Get_StartType write Set_StartType;
    property Path: WideString read Get_Path write Set_Path;
    property StartupParameters: WideString read Get_StartupParameters write Set_StartupParameters;
    property ErrorControl: Integer read Get_ErrorControl write Set_ErrorControl;
    property LoadOrderGroup: WideString read Get_LoadOrderGroup write Set_LoadOrderGroup;
    property ServiceAccountName: WideString read Get_ServiceAccountName write Set_ServiceAccountName;
    property ServiceAccountPath: WideString read Get_ServiceAccountPath write Set_ServiceAccountPath;
    property Dependencies: OleVariant read Get_Dependencies write Set_Dependencies;
  end;

// *********************************************************************//
// DispIntf:  IADsServiceDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {68AF66E0-31CA-11CF-A98A-00AA006BC149}
// *********************************************************************//
  IADsServiceDisp = dispinterface
    ['{68AF66E0-31CA-11CF-A98A-00AA006BC149}']
    property HostComputer: WideString dispid 15;
    property DisplayName: WideString dispid 16;
    property Version: WideString dispid 17;
    property ServiceType: Integer dispid 18;
    property StartType: Integer dispid 19;
    property Path: WideString dispid 20;
    property StartupParameters: WideString dispid 21;
    property ErrorControl: Integer dispid 22;
    property LoadOrderGroup: WideString dispid 23;
    property ServiceAccountName: WideString dispid 24;
    property ServiceAccountPath: WideString dispid 25;
    property Dependencies: OleVariant dispid 26;
    property Name: WideString readonly dispid 2;
    property Class_: WideString readonly dispid 3;
    property GUID: WideString readonly dispid 4;
    property ADsPath: WideString readonly dispid 5;
    property Parent: WideString readonly dispid 6;
    property Schema: WideString readonly dispid 7;
    procedure GetInfo; dispid 8;
    procedure SetInfo; dispid 9;
    function  Get(const bstrName: WideString): OleVariant; dispid 10;
    procedure Put(const bstrName: WideString; vProp: OleVariant); dispid 11;
    function  GetEx(const bstrName: WideString): OleVariant; dispid 12;
    procedure PutEx(lnControlCode: Integer; const bstrName: WideString; vProp: OleVariant); dispid 13;
    procedure GetInfoEx(vProperties: OleVariant; lnReserved: Integer); dispid 14;
  end;

// *********************************************************************//
// Schnittstelle: IADsServiceOperations
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {5D7B33F0-31CA-11CF-A98A-00AA006BC149}
// *********************************************************************//
  IADsServiceOperations = interface(IADs)
    ['{5D7B33F0-31CA-11CF-A98A-00AA006BC149}']
    function  Get_Status: Integer; safecall;
    procedure Start; safecall;
    procedure Stop; safecall;
    procedure Pause; safecall;
    procedure Continue; safecall;
    procedure SetPassword(const bstrNewPassword: WideString); safecall;
    property Status: Integer read Get_Status;
  end;

// *********************************************************************//
// DispIntf:  IADsServiceOperationsDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {5D7B33F0-31CA-11CF-A98A-00AA006BC149}
// *********************************************************************//
  IADsServiceOperationsDisp = dispinterface
    ['{5D7B33F0-31CA-11CF-A98A-00AA006BC149}']
    property Status: Integer readonly dispid 27;
    procedure Start; dispid 28;
    procedure Stop; dispid 29;
    procedure Pause; dispid 30;
    procedure Continue; dispid 31;
    procedure SetPassword(const bstrNewPassword: WideString); dispid 32;
    property Name: WideString readonly dispid 2;
    property Class_: WideString readonly dispid 3;
    property GUID: WideString readonly dispid 4;
    property ADsPath: WideString readonly dispid 5;
    property Parent: WideString readonly dispid 6;
    property Schema: WideString readonly dispid 7;
    procedure GetInfo; dispid 8;
    procedure SetInfo; dispid 9;
    function  Get(const bstrName: WideString): OleVariant; dispid 10;
    procedure Put(const bstrName: WideString; vProp: OleVariant); dispid 11;
    function  GetEx(const bstrName: WideString): OleVariant; dispid 12;
    procedure PutEx(lnControlCode: Integer; const bstrName: WideString; vProp: OleVariant); dispid 13;
    procedure GetInfoEx(vProperties: OleVariant; lnReserved: Integer); dispid 14;
  end;

// *********************************************************************//
// Schnittstelle: IADsFileService
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {A89D1900-31CA-11CF-A98A-00AA006BC149}
// *********************************************************************//
  IADsFileService = interface(IADsService)
    ['{A89D1900-31CA-11CF-A98A-00AA006BC149}']
    function  Get_Description: WideString; safecall;
    procedure Set_Description(const retval: WideString); safecall;
    function  Get_MaxUserCount: Integer; safecall;
    procedure Set_MaxUserCount(retval: Integer); safecall;
    property Description: WideString read Get_Description write Set_Description;
    property MaxUserCount: Integer read Get_MaxUserCount write Set_MaxUserCount;
  end;

// *********************************************************************//
// DispIntf:  IADsFileServiceDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {A89D1900-31CA-11CF-A98A-00AA006BC149}
// *********************************************************************//
  IADsFileServiceDisp = dispinterface
    ['{A89D1900-31CA-11CF-A98A-00AA006BC149}']
    property Description: WideString dispid 33;
    property MaxUserCount: Integer dispid 34;
    property HostComputer: WideString dispid 15;
    property DisplayName: WideString dispid 16;
    property Version: WideString dispid 17;
    property ServiceType: Integer dispid 18;
    property StartType: Integer dispid 19;
    property Path: WideString dispid 20;
    property StartupParameters: WideString dispid 21;
    property ErrorControl: Integer dispid 22;
    property LoadOrderGroup: WideString dispid 23;
    property ServiceAccountName: WideString dispid 24;
    property ServiceAccountPath: WideString dispid 25;
    property Dependencies: OleVariant dispid 26;
    property Name: WideString readonly dispid 2;
    property Class_: WideString readonly dispid 3;
    property GUID: WideString readonly dispid 4;
    property ADsPath: WideString readonly dispid 5;
    property Parent: WideString readonly dispid 6;
    property Schema: WideString readonly dispid 7;
    procedure GetInfo; dispid 8;
    procedure SetInfo; dispid 9;
    function  Get(const bstrName: WideString): OleVariant; dispid 10;
    procedure Put(const bstrName: WideString; vProp: OleVariant); dispid 11;
    function  GetEx(const bstrName: WideString): OleVariant; dispid 12;
    procedure PutEx(lnControlCode: Integer; const bstrName: WideString; vProp: OleVariant); dispid 13;
    procedure GetInfoEx(vProperties: OleVariant; lnReserved: Integer); dispid 14;
  end;

// *********************************************************************//
// Schnittstelle: IADsFileServiceOperations
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {A02DED10-31CA-11CF-A98A-00AA006BC149}
// *********************************************************************//
  IADsFileServiceOperations = interface(IADsServiceOperations)
    ['{A02DED10-31CA-11CF-A98A-00AA006BC149}']
    function  Sessions: IADsCollection; safecall;
    function  Resources: IADsCollection; safecall;
  end;

// *********************************************************************//
// DispIntf:  IADsFileServiceOperationsDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {A02DED10-31CA-11CF-A98A-00AA006BC149}
// *********************************************************************//
  IADsFileServiceOperationsDisp = dispinterface
    ['{A02DED10-31CA-11CF-A98A-00AA006BC149}']
    function  Sessions: IADsCollection; dispid 35;
    function  Resources: IADsCollection; dispid 36;
    property Status: Integer readonly dispid 27;
    procedure Start; dispid 28;
    procedure Stop; dispid 29;
    procedure Pause; dispid 30;
    procedure Continue; dispid 31;
    procedure SetPassword(const bstrNewPassword: WideString); dispid 32;
    property Name: WideString readonly dispid 2;
    property Class_: WideString readonly dispid 3;
    property GUID: WideString readonly dispid 4;
    property ADsPath: WideString readonly dispid 5;
    property Parent: WideString readonly dispid 6;
    property Schema: WideString readonly dispid 7;
    procedure GetInfo; dispid 8;
    procedure SetInfo; dispid 9;
    function  Get(const bstrName: WideString): OleVariant; dispid 10;
    procedure Put(const bstrName: WideString; vProp: OleVariant); dispid 11;
    function  GetEx(const bstrName: WideString): OleVariant; dispid 12;
    procedure PutEx(lnControlCode: Integer; const bstrName: WideString; vProp: OleVariant); dispid 13;
    procedure GetInfoEx(vProperties: OleVariant; lnReserved: Integer); dispid 14;
  end;

// *********************************************************************//
// Schnittstelle: IADsFileShare
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {EB6DCAF0-4B83-11CF-A995-00AA006BC149}
// *********************************************************************//
  IADsFileShare = interface(IADs)
    ['{EB6DCAF0-4B83-11CF-A995-00AA006BC149}']
    function  Get_CurrentUserCount: Integer; safecall;
    function  Get_Description: WideString; safecall;
    procedure Set_Description(const retval: WideString); safecall;
    function  Get_HostComputer: WideString; safecall;
    procedure Set_HostComputer(const retval: WideString); safecall;
    function  Get_Path: WideString; safecall;
    procedure Set_Path(const retval: WideString); safecall;
    function  Get_MaxUserCount: Integer; safecall;
    procedure Set_MaxUserCount(retval: Integer); safecall;
    property CurrentUserCount: Integer read Get_CurrentUserCount;
    property Description: WideString read Get_Description write Set_Description;
    property HostComputer: WideString read Get_HostComputer write Set_HostComputer;
    property Path: WideString read Get_Path write Set_Path;
    property MaxUserCount: Integer read Get_MaxUserCount write Set_MaxUserCount;
  end;

// *********************************************************************//
// DispIntf:  IADsFileShareDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {EB6DCAF0-4B83-11CF-A995-00AA006BC149}
// *********************************************************************//
  IADsFileShareDisp = dispinterface
    ['{EB6DCAF0-4B83-11CF-A995-00AA006BC149}']
    property CurrentUserCount: Integer readonly dispid 15;
    property Description: WideString dispid 16;
    property HostComputer: WideString dispid 17;
    property Path: WideString dispid 18;
    property MaxUserCount: Integer dispid 19;
    property Name: WideString readonly dispid 2;
    property Class_: WideString readonly dispid 3;
    property GUID: WideString readonly dispid 4;
    property ADsPath: WideString readonly dispid 5;
    property Parent: WideString readonly dispid 6;
    property Schema: WideString readonly dispid 7;
    procedure GetInfo; dispid 8;
    procedure SetInfo; dispid 9;
    function  Get(const bstrName: WideString): OleVariant; dispid 10;
    procedure Put(const bstrName: WideString; vProp: OleVariant); dispid 11;
    function  GetEx(const bstrName: WideString): OleVariant; dispid 12;
    procedure PutEx(lnControlCode: Integer; const bstrName: WideString; vProp: OleVariant); dispid 13;
    procedure GetInfoEx(vProperties: OleVariant; lnReserved: Integer); dispid 14;
  end;

// *********************************************************************//
// Schnittstelle: IADsSession
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {398B7DA0-4AAB-11CF-AE2C-00AA006EBFB9}
// *********************************************************************//
  IADsSession = interface(IADs)
    ['{398B7DA0-4AAB-11CF-AE2C-00AA006EBFB9}']
    function  Get_User: WideString; safecall;
    function  Get_UserPath: WideString; safecall;
    function  Get_Computer: WideString; safecall;
    function  Get_ComputerPath: WideString; safecall;
    function  Get_ConnectTime: Integer; safecall;
    function  Get_IdleTime: Integer; safecall;
    property User: WideString read Get_User;
    property UserPath: WideString read Get_UserPath;
    property Computer: WideString read Get_Computer;
    property ComputerPath: WideString read Get_ComputerPath;
    property ConnectTime: Integer read Get_ConnectTime;
    property IdleTime: Integer read Get_IdleTime;
  end;

// *********************************************************************//
// DispIntf:  IADsSessionDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {398B7DA0-4AAB-11CF-AE2C-00AA006EBFB9}
// *********************************************************************//
  IADsSessionDisp = dispinterface
    ['{398B7DA0-4AAB-11CF-AE2C-00AA006EBFB9}']
    property User: WideString readonly dispid 15;
    property UserPath: WideString readonly dispid 16;
    property Computer: WideString readonly dispid 17;
    property ComputerPath: WideString readonly dispid 18;
    property ConnectTime: Integer readonly dispid 19;
    property IdleTime: Integer readonly dispid 20;
    property Name: WideString readonly dispid 2;
    property Class_: WideString readonly dispid 3;
    property GUID: WideString readonly dispid 4;
    property ADsPath: WideString readonly dispid 5;
    property Parent: WideString readonly dispid 6;
    property Schema: WideString readonly dispid 7;
    procedure GetInfo; dispid 8;
    procedure SetInfo; dispid 9;
    function  Get(const bstrName: WideString): OleVariant; dispid 10;
    procedure Put(const bstrName: WideString; vProp: OleVariant); dispid 11;
    function  GetEx(const bstrName: WideString): OleVariant; dispid 12;
    procedure PutEx(lnControlCode: Integer; const bstrName: WideString; vProp: OleVariant); dispid 13;
    procedure GetInfoEx(vProperties: OleVariant; lnReserved: Integer); dispid 14;
  end;

// *********************************************************************//
// Schnittstelle: IADsResource
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {34A05B20-4AAB-11CF-AE2C-00AA006EBFB9}
// *********************************************************************//
  IADsResource = interface(IADs)
    ['{34A05B20-4AAB-11CF-AE2C-00AA006EBFB9}']
    function  Get_User: WideString; safecall;
    function  Get_UserPath: WideString; safecall;
    function  Get_Path: WideString; safecall;
    function  Get_LockCount: Integer; safecall;
    property User: WideString read Get_User;
    property UserPath: WideString read Get_UserPath;
    property Path: WideString read Get_Path;
    property LockCount: Integer read Get_LockCount;
  end;

// *********************************************************************//
// DispIntf:  IADsResourceDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {34A05B20-4AAB-11CF-AE2C-00AA006EBFB9}
// *********************************************************************//
  IADsResourceDisp = dispinterface
    ['{34A05B20-4AAB-11CF-AE2C-00AA006EBFB9}']
    property User: WideString readonly dispid 15;
    property UserPath: WideString readonly dispid 16;
    property Path: WideString readonly dispid 17;
    property LockCount: Integer readonly dispid 18;
    property Name: WideString readonly dispid 2;
    property Class_: WideString readonly dispid 3;
    property GUID: WideString readonly dispid 4;
    property ADsPath: WideString readonly dispid 5;
    property Parent: WideString readonly dispid 6;
    property Schema: WideString readonly dispid 7;
    procedure GetInfo; dispid 8;
    procedure SetInfo; dispid 9;
    function  Get(const bstrName: WideString): OleVariant; dispid 10;
    procedure Put(const bstrName: WideString; vProp: OleVariant); dispid 11;
    function  GetEx(const bstrName: WideString): OleVariant; dispid 12;
    procedure PutEx(lnControlCode: Integer; const bstrName: WideString; vProp: OleVariant); dispid 13;
    procedure GetInfoEx(vProperties: OleVariant; lnReserved: Integer); dispid 14;
  end;

// *********************************************************************//
// Schnittstelle: IADsOpenDSObject
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {DDF2891E-0F9C-11D0-8AD4-00C04FD8D503}
// *********************************************************************//
  IADsOpenDSObject = interface(IDispatch)
    ['{DDF2891E-0F9C-11D0-8AD4-00C04FD8D503}']
    function  OpenDSObject(const lpszDNName: WideString; const lpszUserName: WideString; 
                           const lpszPassword: WideString; lnReserved: Integer): IDispatch; safecall;
  end;

// *********************************************************************//
// DispIntf:  IADsOpenDSObjectDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {DDF2891E-0F9C-11D0-8AD4-00C04FD8D503}
// *********************************************************************//
  IADsOpenDSObjectDisp = dispinterface
    ['{DDF2891E-0F9C-11D0-8AD4-00C04FD8D503}']
    function  OpenDSObject(const lpszDNName: WideString; const lpszUserName: WideString; 
                           const lpszPassword: WideString; lnReserved: Integer): IDispatch; dispid 1;
  end;

// *********************************************************************//
// Schnittstelle: IDirectoryObject
// Flags:     (0)
// GUID:      {E798DE2C-22E4-11D0-84FE-00C04FD8D503}
// *********************************************************************//
  IDirectoryObject = interface(IUnknown)
    ['{E798DE2C-22E4-11D0-84FE-00C04FD8D503}']
    function  GetObjectInformation(out ppObjInfo: PUserType11): HResult; stdcall;
    function  GetObjectAttributes(var pAttributeNames: PWideChar; dwNumberAttributes: LongWord; 
                                  out ppAttributeEntries: PUserType12; 
                                  out pdwNumAttributesReturned: LongWord): HResult; stdcall;
    function  SetObjectAttributes(var pAttributeEntries: _ads_attr_info; dwNumAttributes: LongWord; 
                                  out pdwNumAttributesModified: LongWord): HResult; stdcall;
    function  CreateDSObject(pszRDNName: PWideChar; var pAttributeEntries: _ads_attr_info; 
                             dwNumAttributes: LongWord; out ppObject: IDispatch): HResult; stdcall;
    function  DeleteDSObject(pszRDNName: PWideChar): HResult; stdcall;
  end;

// *********************************************************************//
// Schnittstelle: IDirectorySearch
// Flags:     (0)
// GUID:      {109BA8EC-92F0-11D0-A790-00C04FD8D5A8}
// *********************************************************************//
  IDirectorySearch = interface(IUnknown)
    ['{109BA8EC-92F0-11D0-A790-00C04FD8D5A8}']
    function  SetSearchPreference(var pSearchPrefs: ads_searchpref_info; dwNumPrefs: LongWord): HResult; stdcall;
    function  ExecuteSearch(pszSearchFilter: PWideChar; var pAttributeNames: PWideChar; 
                            dwNumberAttributes: LongWord; out phSearchResult: Pointer): HResult; stdcall;
    function  AbandonSearch(var phSearchResult: Pointer): HResult; stdcall;
    function  GetFirstRow(var hSearchResult: Pointer): HResult; stdcall;
    function  GetNextRow(var hSearchResult: Pointer): HResult; stdcall;
    function  GetPreviousRow(var hSearchResult: Pointer): HResult; stdcall;
    function  GetNextColumnName(var hSearchHandle: Pointer; out ppszColumnName: PWideChar): HResult; stdcall;
    function  GetColumn(var hSearchResult: Pointer; szColumnName: PWideChar; 
                        out pSearchColumn: ads_search_column): HResult; stdcall;
    function  FreeColumn(var pSearchColumn: ads_search_column): HResult; stdcall;
    function  CloseSearchHandle(var hSearchResult: Pointer): HResult; stdcall;
  end;

// *********************************************************************//
// Schnittstelle: IDirectorySchemaMgmt
// Flags:     (0)
// GUID:      {75DB3B9C-A4D8-11D0-A79C-00C04FD8D5A8}
// *********************************************************************//
  IDirectorySchemaMgmt = interface(IUnknown)
    ['{75DB3B9C-A4D8-11D0-A79C-00C04FD8D5A8}']
    function  EnumAttributes(var ppszAttrNames: PWideChar; dwNumAttributes: LongWord; 
                             ppAttrDefinition: PPUserType1; var pdwNumAttributes: LongWord): HResult; stdcall;
    function  CreateAttributeDefinition(pszAttributeName: PWideChar; 
                                        var pAttributeDefinition: _ads_attr_def): HResult; stdcall;
    function  WriteAttributeDefinition(pszAttributeName: PWideChar; 
                                       var pAttributeDefinition: _ads_attr_def): HResult; stdcall;
    function  DeleteAttributeDefinition(pszAttributeName: PWideChar): HResult; stdcall;
    function  EnumClasses(var ppszClassNames: PWideChar; dwNumClasses: LongWord; 
                          ppClassDefinition: PPUserType2; var pdwNumClasses: LongWord): HResult; stdcall;
    function  WriteClassDefinition(pszClassName: PWideChar; var pClassDefinition: _ads_class_def): HResult; stdcall;
    function  CreateClassDefinition(pszClassName: PWideChar; var pClassDefinition: _ads_class_def): HResult; stdcall;
    function  DeleteClassDefinition(pszClassName: PWideChar): HResult; stdcall;
  end;

// *********************************************************************//
// Schnittstelle: IADsAggregatee
// Flags:     (0)
// GUID:      {1346CE8C-9039-11D0-8528-00C04FD8D503}
// *********************************************************************//
  IADsAggregatee = interface(IUnknown)
    ['{1346CE8C-9039-11D0-8528-00C04FD8D503}']
    function  ConnectAsAggregatee(const pOuterUnknown: IUnknown): HResult; stdcall;
    function  DisconnectAsAggregatee: HResult; stdcall;
    function  RelinquishInterface(var riid: TGUID): HResult; stdcall;
    function  RestoreInterface(var riid: TGUID): HResult; stdcall;
  end;

// *********************************************************************//
// Schnittstelle: IADsAggregator
// Flags:     (0)
// GUID:      {52DB5FB0-941F-11D0-8529-00C04FD8D503}
// *********************************************************************//
  IADsAggregator = interface(IUnknown)
    ['{52DB5FB0-941F-11D0-8529-00C04FD8D503}']
    function  ConnectAsAggregator(const pAggregatee: IUnknown): HResult; stdcall;
    function  DisconnectAsAggregator: HResult; stdcall;
  end;

// *********************************************************************//
// Schnittstelle: IADsAccessControlEntry
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {B4F3A14C-9BDD-11D0-852C-00C04FD8D503}
// *********************************************************************//
  IADsAccessControlEntry = interface(IDispatch)
    ['{B4F3A14C-9BDD-11D0-852C-00C04FD8D503}']
    function  Get_AccessMask: Integer; safecall;
    procedure Set_AccessMask(retval: Integer); safecall;
    function  Get_AceType: Integer; safecall;
    procedure Set_AceType(retval: Integer); safecall;
    function  Get_AceFlags: Integer; safecall;
    procedure Set_AceFlags(retval: Integer); safecall;
    function  Get_Flags: Integer; safecall;
    procedure Set_Flags(retval: Integer); safecall;
    function  Get_ObjectType: WideString; safecall;
    procedure Set_ObjectType(const retval: WideString); safecall;
    function  Get_InheritedObjectType: WideString; safecall;
    procedure Set_InheritedObjectType(const retval: WideString); safecall;
    function  Get_Trustee: WideString; safecall;
    procedure Set_Trustee(const retval: WideString); safecall;
    property AccessMask: Integer read Get_AccessMask write Set_AccessMask;
    property AceType: Integer read Get_AceType write Set_AceType;
    property AceFlags: Integer read Get_AceFlags write Set_AceFlags;
    property Flags: Integer read Get_Flags write Set_Flags;
    property ObjectType: WideString read Get_ObjectType write Set_ObjectType;
    property InheritedObjectType: WideString read Get_InheritedObjectType write Set_InheritedObjectType;
    property Trustee: WideString read Get_Trustee write Set_Trustee;
  end;

// *********************************************************************//
// DispIntf:  IADsAccessControlEntryDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {B4F3A14C-9BDD-11D0-852C-00C04FD8D503}
// *********************************************************************//
  IADsAccessControlEntryDisp = dispinterface
    ['{B4F3A14C-9BDD-11D0-852C-00C04FD8D503}']
    property AccessMask: Integer dispid 2;
    property AceType: Integer dispid 3;
    property AceFlags: Integer dispid 4;
    property Flags: Integer dispid 5;
    property ObjectType: WideString dispid 6;
    property InheritedObjectType: WideString dispid 7;
    property Trustee: WideString dispid 8;
  end;

// *********************************************************************//
// Schnittstelle: IADsAccessControlList
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {B7EE91CC-9BDD-11D0-852C-00C04FD8D503}
// *********************************************************************//
  IADsAccessControlList = interface(IDispatch)
    ['{B7EE91CC-9BDD-11D0-852C-00C04FD8D503}']
    function  Get_AclRevision: Integer; safecall;
    procedure Set_AclRevision(retval: Integer); safecall;
    function  Get_AceCount: Integer; safecall;
    procedure Set_AceCount(retval: Integer); safecall;
    procedure AddAce(const pAccessControlEntry: IDispatch); safecall;
    procedure RemoveAce(const pAccessControlEntry: IDispatch); safecall;
    function  CopyAccessList: IDispatch; safecall;
    function  Get__NewEnum: IUnknown; safecall;
    property AclRevision: Integer read Get_AclRevision write Set_AclRevision;
    property AceCount: Integer read Get_AceCount write Set_AceCount;
    property _NewEnum: IUnknown read Get__NewEnum;
  end;

// *********************************************************************//
// DispIntf:  IADsAccessControlListDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {B7EE91CC-9BDD-11D0-852C-00C04FD8D503}
// *********************************************************************//
  IADsAccessControlListDisp = dispinterface
    ['{B7EE91CC-9BDD-11D0-852C-00C04FD8D503}']
    property AclRevision: Integer dispid 3;
    property AceCount: Integer dispid 4;
    procedure AddAce(const pAccessControlEntry: IDispatch); dispid 5;
    procedure RemoveAce(const pAccessControlEntry: IDispatch); dispid 6;
    function  CopyAccessList: IDispatch; dispid 7;
    property _NewEnum: IUnknown readonly dispid -4;
  end;

// *********************************************************************//
// Schnittstelle: IADsSecurityDescriptor
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {B8C787CA-9BDD-11D0-852C-00C04FD8D503}
// *********************************************************************//
  IADsSecurityDescriptor = interface(IDispatch)
    ['{B8C787CA-9BDD-11D0-852C-00C04FD8D503}']
    function  Get_Revision: Integer; safecall;
    procedure Set_Revision(retval: Integer); safecall;
    function  Get_Control: Integer; safecall;
    procedure Set_Control(retval: Integer); safecall;
    function  Get_Owner: WideString; safecall;
    procedure Set_Owner(const retval: WideString); safecall;
    function  Get_OwnerDefaulted: WordBool; safecall;
    procedure Set_OwnerDefaulted(retval: WordBool); safecall;
    function  Get_Group: WideString; safecall;
    procedure Set_Group(const retval: WideString); safecall;
    function  Get_GroupDefaulted: WordBool; safecall;
    procedure Set_GroupDefaulted(retval: WordBool); safecall;
    function  Get_DiscretionaryAcl: IDispatch; safecall;
    procedure Set_DiscretionaryAcl(const retval: IDispatch); safecall;
    function  Get_DaclDefaulted: WordBool; safecall;
    procedure Set_DaclDefaulted(retval: WordBool); safecall;
    function  Get_SystemAcl: IDispatch; safecall;
    procedure Set_SystemAcl(const retval: IDispatch); safecall;
    function  Get_SaclDefaulted: WordBool; safecall;
    procedure Set_SaclDefaulted(retval: WordBool); safecall;
    function  CopySecurityDescriptor: IDispatch; safecall;
    property Revision: Integer read Get_Revision write Set_Revision;
    property Control: Integer read Get_Control write Set_Control;
    property Owner: WideString read Get_Owner write Set_Owner;
    property OwnerDefaulted: WordBool read Get_OwnerDefaulted write Set_OwnerDefaulted;
    property Group: WideString read Get_Group write Set_Group;
    property GroupDefaulted: WordBool read Get_GroupDefaulted write Set_GroupDefaulted;
    property DiscretionaryAcl: IDispatch read Get_DiscretionaryAcl write Set_DiscretionaryAcl;
    property DaclDefaulted: WordBool read Get_DaclDefaulted write Set_DaclDefaulted;
    property SystemAcl: IDispatch read Get_SystemAcl write Set_SystemAcl;
    property SaclDefaulted: WordBool read Get_SaclDefaulted write Set_SaclDefaulted;
  end;

// *********************************************************************//
// DispIntf:  IADsSecurityDescriptorDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {B8C787CA-9BDD-11D0-852C-00C04FD8D503}
// *********************************************************************//
  IADsSecurityDescriptorDisp = dispinterface
    ['{B8C787CA-9BDD-11D0-852C-00C04FD8D503}']
    property Revision: Integer dispid 2;
    property Control: Integer dispid 3;
    property Owner: WideString dispid 4;
    property OwnerDefaulted: WordBool dispid 5;
    property Group: WideString dispid 6;
    property GroupDefaulted: WordBool dispid 7;
    property DiscretionaryAcl: IDispatch dispid 8;
    property DaclDefaulted: WordBool dispid 9;
    property SystemAcl: IDispatch dispid 10;
    property SaclDefaulted: WordBool dispid 11;
    function  CopySecurityDescriptor: IDispatch; dispid 12;
  end;

// *********************************************************************//
// Schnittstelle: IADsLargeInteger
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {9068270B-0939-11D1-8BE1-00C04FD8D503}
// *********************************************************************//
  IADsLargeInteger = interface(IDispatch)
    ['{9068270B-0939-11D1-8BE1-00C04FD8D503}']
    function  Get_HighPart: Integer; safecall;
    procedure Set_HighPart(retval: Integer); safecall;
    function  Get_LowPart: Integer; safecall;
    procedure Set_LowPart(retval: Integer); safecall;
    property HighPart: Integer read Get_HighPart write Set_HighPart;
    property LowPart: Integer read Get_LowPart write Set_LowPart;
  end;

// *********************************************************************//
// DispIntf:  IADsLargeIntegerDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {9068270B-0939-11D1-8BE1-00C04FD8D503}
// *********************************************************************//
  IADsLargeIntegerDisp = dispinterface
    ['{9068270B-0939-11D1-8BE1-00C04FD8D503}']
    property HighPart: Integer dispid 2;
    property LowPart: Integer dispid 3;
  end;

// *********************************************************************//
// Schnittstelle: IADsNameTranslate
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {B1B272A3-3625-11D1-A3A4-00C04FB950DC}
// *********************************************************************//
  IADsNameTranslate = interface(IDispatch)
    ['{B1B272A3-3625-11D1-A3A4-00C04FB950DC}']
    procedure Set_ChaseReferral(Param1: Integer); safecall;
    procedure Init(lnSetType: Integer; const bstrADsPath: WideString); safecall;
    procedure InitEx(lnSetType: Integer; const bstrADsPath: WideString; 
                     const bstrUserID: WideString; const bstrDomain: WideString; 
                     const bstrPassword: WideString); safecall;
    procedure Set_(lnSetType: Integer; const bstrADsPath: WideString); safecall;
    function  Get(lnFormatType: Integer): WideString; safecall;
    procedure SetEx(lnFormatType: Integer; pVar: OleVariant); safecall;
    function  GetEx(lnFormatType: Integer): OleVariant; safecall;
    property ChaseReferral: Integer write Set_ChaseReferral;
  end;

// *********************************************************************//
// DispIntf:  IADsNameTranslateDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {B1B272A3-3625-11D1-A3A4-00C04FB950DC}
// *********************************************************************//
  IADsNameTranslateDisp = dispinterface
    ['{B1B272A3-3625-11D1-A3A4-00C04FB950DC}']
    property ChaseReferral: Integer writeonly dispid 1;
    procedure Init(lnSetType: Integer; const bstrADsPath: WideString); dispid 2;
    procedure InitEx(lnSetType: Integer; const bstrADsPath: WideString; 
                     const bstrUserID: WideString; const bstrDomain: WideString; 
                     const bstrPassword: WideString); dispid 3;
    procedure Set_(lnSetType: Integer; const bstrADsPath: WideString); dispid 4;
    function  Get(lnFormatType: Integer): WideString; dispid 5;
    procedure SetEx(lnFormatType: Integer; pVar: OleVariant); dispid 6;
    function  GetEx(lnFormatType: Integer): OleVariant; dispid 7;
  end;

// *********************************************************************//
// Schnittstelle: IADsCaseIgnoreList
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {7B66B533-4680-11D1-A3B4-00C04FB950DC}
// *********************************************************************//
  IADsCaseIgnoreList = interface(IDispatch)
    ['{7B66B533-4680-11D1-A3B4-00C04FB950DC}']
    function  Get_CaseIgnoreList: OleVariant; safecall;
    procedure Set_CaseIgnoreList(retval: OleVariant); safecall;
    property CaseIgnoreList: OleVariant read Get_CaseIgnoreList write Set_CaseIgnoreList;
  end;

// *********************************************************************//
// DispIntf:  IADsCaseIgnoreListDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {7B66B533-4680-11D1-A3B4-00C04FB950DC}
// *********************************************************************//
  IADsCaseIgnoreListDisp = dispinterface
    ['{7B66B533-4680-11D1-A3B4-00C04FB950DC}']
    property CaseIgnoreList: OleVariant dispid 2;
  end;

// *********************************************************************//
// Schnittstelle: IADsFaxNumber
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {A910DEA9-4680-11D1-A3B4-00C04FB950DC}
// *********************************************************************//
  IADsFaxNumber = interface(IDispatch)
    ['{A910DEA9-4680-11D1-A3B4-00C04FB950DC}']
    function  Get_TelephoneNumber: WideString; safecall;
    procedure Set_TelephoneNumber(const retval: WideString); safecall;
    function  Get_Parameters: OleVariant; safecall;
    procedure Set_Parameters(retval: OleVariant); safecall;
    property TelephoneNumber: WideString read Get_TelephoneNumber write Set_TelephoneNumber;
    property Parameters: OleVariant read Get_Parameters write Set_Parameters;
  end;

// *********************************************************************//
// DispIntf:  IADsFaxNumberDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {A910DEA9-4680-11D1-A3B4-00C04FB950DC}
// *********************************************************************//
  IADsFaxNumberDisp = dispinterface
    ['{A910DEA9-4680-11D1-A3B4-00C04FB950DC}']
    property TelephoneNumber: WideString dispid 2;
    property Parameters: OleVariant dispid 3;
  end;

// *********************************************************************//
// Schnittstelle: IADsNetAddress
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {B21A50A9-4080-11D1-A3AC-00C04FB950DC}
// *********************************************************************//
  IADsNetAddress = interface(IDispatch)
    ['{B21A50A9-4080-11D1-A3AC-00C04FB950DC}']
    function  Get_AddressType: Integer; safecall;
    procedure Set_AddressType(retval: Integer); safecall;
    function  Get_Address: OleVariant; safecall;
    procedure Set_Address(retval: OleVariant); safecall;
    property AddressType: Integer read Get_AddressType write Set_AddressType;
    property Address: OleVariant read Get_Address write Set_Address;
  end;

// *********************************************************************//
// DispIntf:  IADsNetAddressDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {B21A50A9-4080-11D1-A3AC-00C04FB950DC}
// *********************************************************************//
  IADsNetAddressDisp = dispinterface
    ['{B21A50A9-4080-11D1-A3AC-00C04FB950DC}']
    property AddressType: Integer dispid 2;
    property Address: OleVariant dispid 3;
  end;

// *********************************************************************//
// Schnittstelle: IADsOctetList
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {7B28B80F-4680-11D1-A3B4-00C04FB950DC}
// *********************************************************************//
  IADsOctetList = interface(IDispatch)
    ['{7B28B80F-4680-11D1-A3B4-00C04FB950DC}']
    function  Get_OctetList: OleVariant; safecall;
    procedure Set_OctetList(retval: OleVariant); safecall;
    property OctetList: OleVariant read Get_OctetList write Set_OctetList;
  end;

// *********************************************************************//
// DispIntf:  IADsOctetListDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {7B28B80F-4680-11D1-A3B4-00C04FB950DC}
// *********************************************************************//
  IADsOctetListDisp = dispinterface
    ['{7B28B80F-4680-11D1-A3B4-00C04FB950DC}']
    property OctetList: OleVariant dispid 2;
  end;

// *********************************************************************//
// Schnittstelle: IADsEmail
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {97AF011A-478E-11D1-A3B4-00C04FB950DC}
// *********************************************************************//
  IADsEmail = interface(IDispatch)
    ['{97AF011A-478E-11D1-A3B4-00C04FB950DC}']
    function  Get_Type_: Integer; safecall;
    procedure Set_Type_(retval: Integer); safecall;
    function  Get_Address: WideString; safecall;
    procedure Set_Address(const retval: WideString); safecall;
    property Type_: Integer read Get_Type_ write Set_Type_;
    property Address: WideString read Get_Address write Set_Address;
  end;

// *********************************************************************//
// DispIntf:  IADsEmailDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {97AF011A-478E-11D1-A3B4-00C04FB950DC}
// *********************************************************************//
  IADsEmailDisp = dispinterface
    ['{97AF011A-478E-11D1-A3B4-00C04FB950DC}']
    property Type_: Integer dispid 2;
    property Address: WideString dispid 3;
  end;

// *********************************************************************//
// Schnittstelle: IADsPath
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {B287FCD5-4080-11D1-A3AC-00C04FB950DC}
// *********************************************************************//
  IADsPath = interface(IDispatch)
    ['{B287FCD5-4080-11D1-A3AC-00C04FB950DC}']
    function  Get_Type_: Integer; safecall;
    procedure Set_Type_(retval: Integer); safecall;
    function  Get_VolumeName: WideString; safecall;
    procedure Set_VolumeName(const retval: WideString); safecall;
    function  Get_Path: WideString; safecall;
    procedure Set_Path(const retval: WideString); safecall;
    property Type_: Integer read Get_Type_ write Set_Type_;
    property VolumeName: WideString read Get_VolumeName write Set_VolumeName;
    property Path: WideString read Get_Path write Set_Path;
  end;

// *********************************************************************//
// DispIntf:  IADsPathDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {B287FCD5-4080-11D1-A3AC-00C04FB950DC}
// *********************************************************************//
  IADsPathDisp = dispinterface
    ['{B287FCD5-4080-11D1-A3AC-00C04FB950DC}']
    property Type_: Integer dispid 2;
    property VolumeName: WideString dispid 3;
    property Path: WideString dispid 4;
  end;

// *********************************************************************//
// Schnittstelle: IADsReplicaPointer
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {F60FB803-4080-11D1-A3AC-00C04FB950DC}
// *********************************************************************//
  IADsReplicaPointer = interface(IDispatch)
    ['{F60FB803-4080-11D1-A3AC-00C04FB950DC}']
    function  Get_ServerName: WideString; safecall;
    procedure Set_ServerName(const retval: WideString); safecall;
    function  Get_ReplicaType: Integer; safecall;
    procedure Set_ReplicaType(retval: Integer); safecall;
    function  Get_ReplicaNumber: Integer; safecall;
    procedure Set_ReplicaNumber(retval: Integer); safecall;
    function  Get_Count: Integer; safecall;
    procedure Set_Count(retval: Integer); safecall;
    function  Get_ReplicaAddressHints: OleVariant; safecall;
    procedure Set_ReplicaAddressHints(retval: OleVariant); safecall;
    property ServerName: WideString read Get_ServerName write Set_ServerName;
    property ReplicaType: Integer read Get_ReplicaType write Set_ReplicaType;
    property ReplicaNumber: Integer read Get_ReplicaNumber write Set_ReplicaNumber;
    property Count: Integer read Get_Count write Set_Count;
    property ReplicaAddressHints: OleVariant read Get_ReplicaAddressHints write Set_ReplicaAddressHints;
  end;

// *********************************************************************//
// DispIntf:  IADsReplicaPointerDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {F60FB803-4080-11D1-A3AC-00C04FB950DC}
// *********************************************************************//
  IADsReplicaPointerDisp = dispinterface
    ['{F60FB803-4080-11D1-A3AC-00C04FB950DC}']
    property ServerName: WideString dispid 2;
    property ReplicaType: Integer dispid 3;
    property ReplicaNumber: Integer dispid 4;
    property Count: Integer dispid 5;
    property ReplicaAddressHints: OleVariant dispid 6;
  end;

// *********************************************************************//
// Schnittstelle: IADsAcl
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {8452D3AB-0869-11D1-A377-00C04FB950DC}
// *********************************************************************//
  IADsAcl = interface(IDispatch)
    ['{8452D3AB-0869-11D1-A377-00C04FB950DC}']
    function  Get_ProtectedAttrName: WideString; safecall;
    procedure Set_ProtectedAttrName(const retval: WideString); safecall;
    function  Get_SubjectName: WideString; safecall;
    procedure Set_SubjectName(const retval: WideString); safecall;
    function  Get_Privileges: Integer; safecall;
    procedure Set_Privileges(retval: Integer); safecall;
    function  CopyAcl: IDispatch; safecall;
    property ProtectedAttrName: WideString read Get_ProtectedAttrName write Set_ProtectedAttrName;
    property SubjectName: WideString read Get_SubjectName write Set_SubjectName;
    property Privileges: Integer read Get_Privileges write Set_Privileges;
  end;

// *********************************************************************//
// DispIntf:  IADsAclDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {8452D3AB-0869-11D1-A377-00C04FB950DC}
// *********************************************************************//
  IADsAclDisp = dispinterface
    ['{8452D3AB-0869-11D1-A377-00C04FB950DC}']
    property ProtectedAttrName: WideString dispid 2;
    property SubjectName: WideString dispid 3;
    property Privileges: Integer dispid 4;
    function  CopyAcl: IDispatch; dispid 5;
  end;

// *********************************************************************//
// Schnittstelle: IADsTimestamp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {B2F5A901-4080-11D1-A3AC-00C04FB950DC}
// *********************************************************************//
  IADsTimestamp = interface(IDispatch)
    ['{B2F5A901-4080-11D1-A3AC-00C04FB950DC}']
    function  Get_WholeSeconds: Integer; safecall;
    procedure Set_WholeSeconds(retval: Integer); safecall;
    function  Get_EventID: Integer; safecall;
    procedure Set_EventID(retval: Integer); safecall;
    property WholeSeconds: Integer read Get_WholeSeconds write Set_WholeSeconds;
    property EventID: Integer read Get_EventID write Set_EventID;
  end;

// *********************************************************************//
// DispIntf:  IADsTimestampDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {B2F5A901-4080-11D1-A3AC-00C04FB950DC}
// *********************************************************************//
  IADsTimestampDisp = dispinterface
    ['{B2F5A901-4080-11D1-A3AC-00C04FB950DC}']
    property WholeSeconds: Integer dispid 2;
    property EventID: Integer dispid 3;
  end;

// *********************************************************************//
// Schnittstelle: IADsPostalAddress
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {7ADECF29-4680-11D1-A3B4-00C04FB950DC}
// *********************************************************************//
  IADsPostalAddress = interface(IDispatch)
    ['{7ADECF29-4680-11D1-A3B4-00C04FB950DC}']
    function  Get_PostalAddress: OleVariant; safecall;
    procedure Set_PostalAddress(retval: OleVariant); safecall;
    property PostalAddress: OleVariant read Get_PostalAddress write Set_PostalAddress;
  end;

// *********************************************************************//
// DispIntf:  IADsPostalAddressDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {7ADECF29-4680-11D1-A3B4-00C04FB950DC}
// *********************************************************************//
  IADsPostalAddressDisp = dispinterface
    ['{7ADECF29-4680-11D1-A3B4-00C04FB950DC}']
    property PostalAddress: OleVariant dispid 2;
  end;

// *********************************************************************//
// Schnittstelle: IADsBackLink
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {FD1302BD-4080-11D1-A3AC-00C04FB950DC}
// *********************************************************************//
  IADsBackLink = interface(IDispatch)
    ['{FD1302BD-4080-11D1-A3AC-00C04FB950DC}']
    function  Get_RemoteID: Integer; safecall;
    procedure Set_RemoteID(retval: Integer); safecall;
    function  Get_ObjectName: WideString; safecall;
    procedure Set_ObjectName(const retval: WideString); safecall;
    property RemoteID: Integer read Get_RemoteID write Set_RemoteID;
    property ObjectName: WideString read Get_ObjectName write Set_ObjectName;
  end;

// *********************************************************************//
// DispIntf:  IADsBackLinkDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {FD1302BD-4080-11D1-A3AC-00C04FB950DC}
// *********************************************************************//
  IADsBackLinkDisp = dispinterface
    ['{FD1302BD-4080-11D1-A3AC-00C04FB950DC}']
    property RemoteID: Integer dispid 2;
    property ObjectName: WideString dispid 3;
  end;

// *********************************************************************//
// Schnittstelle: IADsTypedName
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {B371A349-4080-11D1-A3AC-00C04FB950DC}
// *********************************************************************//
  IADsTypedName = interface(IDispatch)
    ['{B371A349-4080-11D1-A3AC-00C04FB950DC}']
    function  Get_ObjectName: WideString; safecall;
    procedure Set_ObjectName(const retval: WideString); safecall;
    function  Get_Level: Integer; safecall;
    procedure Set_Level(retval: Integer); safecall;
    function  Get_Interval: Integer; safecall;
    procedure Set_Interval(retval: Integer); safecall;
    property ObjectName: WideString read Get_ObjectName write Set_ObjectName;
    property Level: Integer read Get_Level write Set_Level;
    property Interval: Integer read Get_Interval write Set_Interval;
  end;

// *********************************************************************//
// DispIntf:  IADsTypedNameDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {B371A349-4080-11D1-A3AC-00C04FB950DC}
// *********************************************************************//
  IADsTypedNameDisp = dispinterface
    ['{B371A349-4080-11D1-A3AC-00C04FB950DC}']
    property ObjectName: WideString dispid 2;
    property Level: Integer dispid 3;
    property Interval: Integer dispid 4;
  end;

// *********************************************************************//
// Schnittstelle: IADsHold
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {B3EB3B37-4080-11D1-A3AC-00C04FB950DC}
// *********************************************************************//
  IADsHold = interface(IDispatch)
    ['{B3EB3B37-4080-11D1-A3AC-00C04FB950DC}']
    function  Get_ObjectName: WideString; safecall;
    procedure Set_ObjectName(const retval: WideString); safecall;
    function  Get_Amount: Integer; safecall;
    procedure Set_Amount(retval: Integer); safecall;
    property ObjectName: WideString read Get_ObjectName write Set_ObjectName;
    property Amount: Integer read Get_Amount write Set_Amount;
  end;

// *********************************************************************//
// DispIntf:  IADsHoldDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {B3EB3B37-4080-11D1-A3AC-00C04FB950DC}
// *********************************************************************//
  IADsHoldDisp = dispinterface
    ['{B3EB3B37-4080-11D1-A3AC-00C04FB950DC}']
    property ObjectName: WideString dispid 2;
    property Amount: Integer dispid 3;
  end;

// *********************************************************************//
// Schnittstelle: IADsObjectOptions
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {46F14FDA-232B-11D1-A808-00C04FD8D5A8}
// *********************************************************************//
  IADsObjectOptions = interface(IDispatch)
    ['{46F14FDA-232B-11D1-A808-00C04FD8D5A8}']
    function  GetOption(lnOption: Integer): OleVariant; safecall;
    procedure SetOption(lnOption: Integer; vValue: OleVariant); safecall;
  end;

// *********************************************************************//
// DispIntf:  IADsObjectOptionsDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {46F14FDA-232B-11D1-A808-00C04FD8D5A8}
// *********************************************************************//
  IADsObjectOptionsDisp = dispinterface
    ['{46F14FDA-232B-11D1-A808-00C04FD8D5A8}']
    function  GetOption(lnOption: Integer): OleVariant; dispid 2;
    procedure SetOption(lnOption: Integer; vValue: OleVariant); dispid 3;
  end;

// *********************************************************************//
// Schnittstelle: IADsPathname
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {D592AED4-F420-11D0-A36E-00C04FB950DC}
// *********************************************************************//
  IADsPathname = interface(IDispatch)
    ['{D592AED4-F420-11D0-A36E-00C04FB950DC}']
    procedure Set_(const bstrADsPath: WideString; lnSetType: Integer); safecall;
    procedure SetDisplayType(lnDisplayType: Integer); safecall;
    function  Retrieve(lnFormatType: Integer): WideString; safecall;
    function  GetNumElements: Integer; safecall;
    function  GetElement(lnElementIndex: Integer): WideString; safecall;
    procedure AddLeafElement(const bstrLeafElement: WideString); safecall;
    procedure RemoveLeafElement; safecall;
    function  CopyPath: IDispatch; safecall;
    function  GetEscapedElement(lnReserved: Integer; const bstrInStr: WideString): WideString; safecall;
    function  Get_EscapedMode: Integer; safecall;
    procedure Set_EscapedMode(retval: Integer); safecall;
    property EscapedMode: Integer read Get_EscapedMode write Set_EscapedMode;
  end;

// *********************************************************************//
// DispIntf:  IADsPathnameDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {D592AED4-F420-11D0-A36E-00C04FB950DC}
// *********************************************************************//
  IADsPathnameDisp = dispinterface
    ['{D592AED4-F420-11D0-A36E-00C04FB950DC}']
    procedure Set_(const bstrADsPath: WideString; lnSetType: Integer); dispid 2;
    procedure SetDisplayType(lnDisplayType: Integer); dispid 3;
    function  Retrieve(lnFormatType: Integer): WideString; dispid 4;
    function  GetNumElements: Integer; dispid 5;
    function  GetElement(lnElementIndex: Integer): WideString; dispid 6;
    procedure AddLeafElement(const bstrLeafElement: WideString); dispid 7;
    procedure RemoveLeafElement; dispid 8;
    function  CopyPath: IDispatch; dispid 9;
    function  GetEscapedElement(lnReserved: Integer; const bstrInStr: WideString): WideString; dispid 10;
    property EscapedMode: Integer dispid 11;
  end;

// *********************************************************************//
// Schnittstelle: IADsADSystemInfo
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {5BB11929-AFD1-11D2-9CB9-0000F87A369E}
// *********************************************************************//
  IADsADSystemInfo = interface(IDispatch)
    ['{5BB11929-AFD1-11D2-9CB9-0000F87A369E}']
    function  Get_UserName: WideString; safecall;
    function  Get_ComputerName: WideString; safecall;
    function  Get_SiteName: WideString; safecall;
    function  Get_DomainShortName: WideString; safecall;
    function  Get_DomainDNSName: WideString; safecall;
    function  Get_ForestDNSName: WideString; safecall;
    function  Get_PDCRoleOwner: WideString; safecall;
    function  Get_SchemaRoleOwner: WideString; safecall;
    function  Get_IsNativeMode: WordBool; safecall;
    function  GetAnyDCName: WideString; safecall;
    function  GetDCSiteName(const szServer: WideString): WideString; safecall;
    procedure RefreshSchemaCache; safecall;
    function  GetTrees: OleVariant; safecall;
    property UserName: WideString read Get_UserName;
    property ComputerName: WideString read Get_ComputerName;
    property SiteName: WideString read Get_SiteName;
    property DomainShortName: WideString read Get_DomainShortName;
    property DomainDNSName: WideString read Get_DomainDNSName;
    property ForestDNSName: WideString read Get_ForestDNSName;
    property PDCRoleOwner: WideString read Get_PDCRoleOwner;
    property SchemaRoleOwner: WideString read Get_SchemaRoleOwner;
    property IsNativeMode: WordBool read Get_IsNativeMode;
  end;

// *********************************************************************//
// DispIntf:  IADsADSystemInfoDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {5BB11929-AFD1-11D2-9CB9-0000F87A369E}
// *********************************************************************//
  IADsADSystemInfoDisp = dispinterface
    ['{5BB11929-AFD1-11D2-9CB9-0000F87A369E}']
    property UserName: WideString readonly dispid 2;
    property ComputerName: WideString readonly dispid 3;
    property SiteName: WideString readonly dispid 4;
    property DomainShortName: WideString readonly dispid 5;
    property DomainDNSName: WideString readonly dispid 6;
    property ForestDNSName: WideString readonly dispid 7;
    property PDCRoleOwner: WideString readonly dispid 8;
    property SchemaRoleOwner: WideString readonly dispid 9;
    property IsNativeMode: WordBool readonly dispid 10;
    function  GetAnyDCName: WideString; dispid 11;
    function  GetDCSiteName(const szServer: WideString): WideString; dispid 12;
    procedure RefreshSchemaCache; dispid 13;
    function  GetTrees: OleVariant; dispid 14;
  end;

// *********************************************************************//
// Schnittstelle: IADsWinNTSystemInfo
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {6C6D65DC-AFD1-11D2-9CB9-0000F87A369E}
// *********************************************************************//
  IADsWinNTSystemInfo = interface(IDispatch)
    ['{6C6D65DC-AFD1-11D2-9CB9-0000F87A369E}']
    function  Get_UserName: WideString; safecall;
    function  Get_ComputerName: WideString; safecall;
    function  Get_DomainName: WideString; safecall;
    function  Get_PDC: WideString; safecall;
    property UserName: WideString read Get_UserName;
    property ComputerName: WideString read Get_ComputerName;
    property DomainName: WideString read Get_DomainName;
    property PDC: WideString read Get_PDC;
  end;

// *********************************************************************//
// DispIntf:  IADsWinNTSystemInfoDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {6C6D65DC-AFD1-11D2-9CB9-0000F87A369E}
// *********************************************************************//
  IADsWinNTSystemInfoDisp = dispinterface
    ['{6C6D65DC-AFD1-11D2-9CB9-0000F87A369E}']
    property UserName: WideString readonly dispid 2;
    property ComputerName: WideString readonly dispid 3;
    property DomainName: WideString readonly dispid 4;
    property PDC: WideString readonly dispid 5;
  end;

// *********************************************************************//
// Schnittstelle: IADsDNWithBinary
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {7E99C0A2-F935-11D2-BA96-00C04FB6D0D1}
// *********************************************************************//
  IADsDNWithBinary = interface(IDispatch)
    ['{7E99C0A2-F935-11D2-BA96-00C04FB6D0D1}']
    function  Get_BinaryValue: OleVariant; safecall;
    procedure Set_BinaryValue(retval: OleVariant); safecall;
    function  Get_DNString: WideString; safecall;
    procedure Set_DNString(const retval: WideString); safecall;
    property BinaryValue: OleVariant read Get_BinaryValue write Set_BinaryValue;
    property DNString: WideString read Get_DNString write Set_DNString;
  end;

// *********************************************************************//
// DispIntf:  IADsDNWithBinaryDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {7E99C0A2-F935-11D2-BA96-00C04FB6D0D1}
// *********************************************************************//
  IADsDNWithBinaryDisp = dispinterface
    ['{7E99C0A2-F935-11D2-BA96-00C04FB6D0D1}']
    property BinaryValue: OleVariant dispid 2;
    property DNString: WideString dispid 3;
  end;

// *********************************************************************//
// Schnittstelle: IADsDNWithString
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {370DF02E-F934-11D2-BA96-00C04FB6D0D1}
// *********************************************************************//
  IADsDNWithString = interface(IDispatch)
    ['{370DF02E-F934-11D2-BA96-00C04FB6D0D1}']
    function  Get_StringValue: WideString; safecall;
    procedure Set_StringValue(const retval: WideString); safecall;
    function  Get_DNString: WideString; safecall;
    procedure Set_DNString(const retval: WideString); safecall;
    property StringValue: WideString read Get_StringValue write Set_StringValue;
    property DNString: WideString read Get_DNString write Set_DNString;
  end;

// *********************************************************************//
// DispIntf:  IADsDNWithStringDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {370DF02E-F934-11D2-BA96-00C04FB6D0D1}
// *********************************************************************//
  IADsDNWithStringDisp = dispinterface
    ['{370DF02E-F934-11D2-BA96-00C04FB6D0D1}']
    property StringValue: WideString dispid 2;
    property DNString: WideString dispid 3;
  end;

// *********************************************************************//
// Schnittstelle: IADsSecurityUtility
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {A63251B2-5F21-474B-AB52-4A8EFAD10895}
// *********************************************************************//
  IADsSecurityUtility = interface(IDispatch)
    ['{A63251B2-5F21-474B-AB52-4A8EFAD10895}']
    function  GetSecurityDescriptor(varPath: OleVariant; lPathFormat: Integer; lFormat: Integer): OleVariant; safecall;
    procedure SetSecurityDescriptor(varPath: OleVariant; lPathFormat: Integer; varData: OleVariant; 
                                    lDataFormat: Integer); safecall;
    function  ConvertSecurityDescriptor(varSD: OleVariant; lDataFormat: Integer; lOutFormat: Integer): OleVariant; safecall;
    function  Get_SecurityMask: Integer; safecall;
    procedure Set_SecurityMask(retval: Integer); safecall;
    property SecurityMask: Integer read Get_SecurityMask write Set_SecurityMask;
  end;

// *********************************************************************//
// DispIntf:  IADsSecurityUtilityDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {A63251B2-5F21-474B-AB52-4A8EFAD10895}
// *********************************************************************//
  IADsSecurityUtilityDisp = dispinterface
    ['{A63251B2-5F21-474B-AB52-4A8EFAD10895}']
    function  GetSecurityDescriptor(varPath: OleVariant; lPathFormat: Integer; lFormat: Integer): OleVariant; dispid 2;
    procedure SetSecurityDescriptor(varPath: OleVariant; lPathFormat: Integer; varData: OleVariant; 
                                    lDataFormat: Integer); dispid 3;
    function  ConvertSecurityDescriptor(varSD: OleVariant; lDataFormat: Integer; lOutFormat: Integer): OleVariant; dispid 4;
    property SecurityMask: Integer dispid 5;
  end;

// *********************************************************************//
// Die Klasse CoPropertyEntry stellt eine Methode Create und CreateRemote zur      
// Verfügung, um Instanzen der Standardschnittstelle IADsPropertyEntry, dargestellt von
// CoClass PropertyEntry, zu erzeugen. Diese Funktionen können                     
// von einem Client verwendet werden, der die CoClasses automatisieren    
// möchte, die von dieser Typbibliothek dargestellt werden.               
// *********************************************************************//
  CoPropertyEntry = class
    class function Create: IADsPropertyEntry;
    class function CreateRemote(const MachineName: RawUtf8): IADsPropertyEntry;
  end;

// *********************************************************************//
// Die Klasse CoPropertyValue stellt eine Methode Create und CreateRemote zur      
// Verfügung, um Instanzen der Standardschnittstelle IADsPropertyValue, dargestellt von
// CoClass PropertyValue, zu erzeugen. Diese Funktionen können                     
// von einem Client verwendet werden, der die CoClasses automatisieren    
// möchte, die von dieser Typbibliothek dargestellt werden.               
// *********************************************************************//
  CoPropertyValue = class
    class function Create: IADsPropertyValue;
    class function CreateRemote(const MachineName: RawUtf8): IADsPropertyValue;
  end;

// *********************************************************************//
// Die Klasse CoAccessControlEntry stellt eine Methode Create und CreateRemote zur      
// Verfügung, um Instanzen der Standardschnittstelle IADsAccessControlEntry, dargestellt von
// CoClass AccessControlEntry, zu erzeugen. Diese Funktionen können                     
// von einem Client verwendet werden, der die CoClasses automatisieren    
// möchte, die von dieser Typbibliothek dargestellt werden.               
// *********************************************************************//
  CoAccessControlEntry = class
    class function Create: IADsAccessControlEntry;
    class function CreateRemote(const MachineName: RawUtf8): IADsAccessControlEntry;
  end;

// *********************************************************************//
// Die Klasse CoAccessControlList stellt eine Methode Create und CreateRemote zur      
// Verfügung, um Instanzen der Standardschnittstelle IADsAccessControlList, dargestellt von
// CoClass AccessControlList, zu erzeugen. Diese Funktionen können                     
// von einem Client verwendet werden, der die CoClasses automatisieren    
// möchte, die von dieser Typbibliothek dargestellt werden.               
// *********************************************************************//
  CoAccessControlList = class
    class function Create: IADsAccessControlList;
    class function CreateRemote(const MachineName: RawUtf8): IADsAccessControlList;
  end;

// *********************************************************************//
// Die Klasse CoSecurityDescriptor stellt eine Methode Create und CreateRemote zur      
// Verfügung, um Instanzen der Standardschnittstelle IADsSecurityDescriptor, dargestellt von
// CoClass SecurityDescriptor, zu erzeugen. Diese Funktionen können                     
// von einem Client verwendet werden, der die CoClasses automatisieren    
// möchte, die von dieser Typbibliothek dargestellt werden.               
// *********************************************************************//
  CoSecurityDescriptor = class
    class function Create: IADsSecurityDescriptor;
    class function CreateRemote(const MachineName: RawUtf8): IADsSecurityDescriptor;
  end;

// *********************************************************************//
// Die Klasse CoLargeInteger stellt eine Methode Create und CreateRemote zur      
// Verfügung, um Instanzen der Standardschnittstelle IADsLargeInteger, dargestellt von
// CoClass LargeInteger, zu erzeugen. Diese Funktionen können                     
// von einem Client verwendet werden, der die CoClasses automatisieren    
// möchte, die von dieser Typbibliothek dargestellt werden.               
// *********************************************************************//
  CoLargeInteger = class
    class function Create: IADsLargeInteger;
    class function CreateRemote(const MachineName: RawUtf8): IADsLargeInteger;
  end;

// *********************************************************************//
// Die Klasse CoNameTranslate stellt eine Methode Create und CreateRemote zur      
// Verfügung, um Instanzen der Standardschnittstelle IADsNameTranslate, dargestellt von
// CoClass NameTranslate, zu erzeugen. Diese Funktionen können                     
// von einem Client verwendet werden, der die CoClasses automatisieren    
// möchte, die von dieser Typbibliothek dargestellt werden.               
// *********************************************************************//
  CoNameTranslate = class
    class function Create: IADsNameTranslate;
    class function CreateRemote(const MachineName: RawUtf8): IADsNameTranslate;
  end;

// *********************************************************************//
// Die Klasse CoCaseIgnoreList stellt eine Methode Create und CreateRemote zur      
// Verfügung, um Instanzen der Standardschnittstelle IADsCaseIgnoreList, dargestellt von
// CoClass CaseIgnoreList, zu erzeugen. Diese Funktionen können                     
// von einem Client verwendet werden, der die CoClasses automatisieren    
// möchte, die von dieser Typbibliothek dargestellt werden.               
// *********************************************************************//
  CoCaseIgnoreList = class
    class function Create: IADsCaseIgnoreList;
    class function CreateRemote(const MachineName: RawUtf8): IADsCaseIgnoreList;
  end;

// *********************************************************************//
// Die Klasse CoFaxNumber stellt eine Methode Create und CreateRemote zur      
// Verfügung, um Instanzen der Standardschnittstelle IADsFaxNumber, dargestellt von
// CoClass FaxNumber, zu erzeugen. Diese Funktionen können                     
// von einem Client verwendet werden, der die CoClasses automatisieren    
// möchte, die von dieser Typbibliothek dargestellt werden.               
// *********************************************************************//
  CoFaxNumber = class
    class function Create: IADsFaxNumber;
    class function CreateRemote(const MachineName: RawUtf8): IADsFaxNumber;
  end;

// *********************************************************************//
// Die Klasse CoNetAddress stellt eine Methode Create und CreateRemote zur      
// Verfügung, um Instanzen der Standardschnittstelle IADsNetAddress, dargestellt von
// CoClass NetAddress, zu erzeugen. Diese Funktionen können                     
// von einem Client verwendet werden, der die CoClasses automatisieren    
// möchte, die von dieser Typbibliothek dargestellt werden.               
// *********************************************************************//
  CoNetAddress = class
    class function Create: IADsNetAddress;
    class function CreateRemote(const MachineName: RawUtf8): IADsNetAddress;
  end;

// *********************************************************************//
// Die Klasse CoOctetList stellt eine Methode Create und CreateRemote zur      
// Verfügung, um Instanzen der Standardschnittstelle IADsOctetList, dargestellt von
// CoClass OctetList, zu erzeugen. Diese Funktionen können                     
// von einem Client verwendet werden, der die CoClasses automatisieren    
// möchte, die von dieser Typbibliothek dargestellt werden.               
// *********************************************************************//
  CoOctetList = class
    class function Create: IADsOctetList;
    class function CreateRemote(const MachineName: RawUtf8): IADsOctetList;
  end;

// *********************************************************************//
// Die Klasse CoEmail stellt eine Methode Create und CreateRemote zur      
// Verfügung, um Instanzen der Standardschnittstelle IADsEmail, dargestellt von
// CoClass Email, zu erzeugen. Diese Funktionen können                     
// von einem Client verwendet werden, der die CoClasses automatisieren    
// möchte, die von dieser Typbibliothek dargestellt werden.               
// *********************************************************************//
  CoEmail = class
    class function Create: IADsEmail;
    class function CreateRemote(const MachineName: RawUtf8): IADsEmail;
  end;

// *********************************************************************//
// Die Klasse CoPath stellt eine Methode Create und CreateRemote zur      
// Verfügung, um Instanzen der Standardschnittstelle IADsPath, dargestellt von
// CoClass Path, zu erzeugen. Diese Funktionen können                     
// von einem Client verwendet werden, der die CoClasses automatisieren    
// möchte, die von dieser Typbibliothek dargestellt werden.               
// *********************************************************************//
  CoPath = class
    class function Create: IADsPath;
    class function CreateRemote(const MachineName: RawUtf8): IADsPath;
  end;

// *********************************************************************//
// Die Klasse CoReplicaPointer stellt eine Methode Create und CreateRemote zur      
// Verfügung, um Instanzen der Standardschnittstelle IADsReplicaPointer, dargestellt von
// CoClass ReplicaPointer, zu erzeugen. Diese Funktionen können                     
// von einem Client verwendet werden, der die CoClasses automatisieren    
// möchte, die von dieser Typbibliothek dargestellt werden.               
// *********************************************************************//
  CoReplicaPointer = class
    class function Create: IADsReplicaPointer;
    class function CreateRemote(const MachineName: RawUtf8): IADsReplicaPointer;
  end;

// *********************************************************************//
// Die Klasse CoTimestamp stellt eine Methode Create und CreateRemote zur      
// Verfügung, um Instanzen der Standardschnittstelle IADsTimestamp, dargestellt von
// CoClass Timestamp, zu erzeugen. Diese Funktionen können                     
// von einem Client verwendet werden, der die CoClasses automatisieren    
// möchte, die von dieser Typbibliothek dargestellt werden.               
// *********************************************************************//
  CoTimestamp = class
    class function Create: IADsTimestamp;
    class function CreateRemote(const MachineName: RawUtf8): IADsTimestamp;
  end;

// *********************************************************************//
// Die Klasse CoPostalAddress stellt eine Methode Create und CreateRemote zur      
// Verfügung, um Instanzen der Standardschnittstelle IADsPostalAddress, dargestellt von
// CoClass PostalAddress, zu erzeugen. Diese Funktionen können                     
// von einem Client verwendet werden, der die CoClasses automatisieren    
// möchte, die von dieser Typbibliothek dargestellt werden.               
// *********************************************************************//
  CoPostalAddress = class
    class function Create: IADsPostalAddress;
    class function CreateRemote(const MachineName: RawUtf8): IADsPostalAddress;
  end;

// *********************************************************************//
// Die Klasse CoBackLink stellt eine Methode Create und CreateRemote zur      
// Verfügung, um Instanzen der Standardschnittstelle IADsBackLink, dargestellt von
// CoClass BackLink, zu erzeugen. Diese Funktionen können                     
// von einem Client verwendet werden, der die CoClasses automatisieren    
// möchte, die von dieser Typbibliothek dargestellt werden.               
// *********************************************************************//
  CoBackLink = class
    class function Create: IADsBackLink;
    class function CreateRemote(const MachineName: RawUtf8): IADsBackLink;
  end;

// *********************************************************************//
// Die Klasse CoTypedName stellt eine Methode Create und CreateRemote zur      
// Verfügung, um Instanzen der Standardschnittstelle IADsTypedName, dargestellt von
// CoClass TypedName, zu erzeugen. Diese Funktionen können                     
// von einem Client verwendet werden, der die CoClasses automatisieren    
// möchte, die von dieser Typbibliothek dargestellt werden.               
// *********************************************************************//
  CoTypedName = class
    class function Create: IADsTypedName;
    class function CreateRemote(const MachineName: RawUtf8): IADsTypedName;
  end;

// *********************************************************************//
// Die Klasse CoHold stellt eine Methode Create und CreateRemote zur      
// Verfügung, um Instanzen der Standardschnittstelle IADsHold, dargestellt von
// CoClass Hold, zu erzeugen. Diese Funktionen können                     
// von einem Client verwendet werden, der die CoClasses automatisieren    
// möchte, die von dieser Typbibliothek dargestellt werden.               
// *********************************************************************//
  CoHold = class
    class function Create: IADsHold;
    class function CreateRemote(const MachineName: RawUtf8): IADsHold;
  end;

// *********************************************************************//
// Die Klasse CoPathname stellt eine Methode Create und CreateRemote zur      
// Verfügung, um Instanzen der Standardschnittstelle IADsPathname, dargestellt von
// CoClass Pathname, zu erzeugen. Diese Funktionen können                     
// von einem Client verwendet werden, der die CoClasses automatisieren    
// möchte, die von dieser Typbibliothek dargestellt werden.               
// *********************************************************************//
  CoPathname = class
    class function Create: IADsPathname;
    class function CreateRemote(const MachineName: RawUtf8): IADsPathname;
  end;

// *********************************************************************//
// Die Klasse CoADSystemInfo stellt eine Methode Create und CreateRemote zur      
// Verfügung, um Instanzen der Standardschnittstelle IADsADSystemInfo, dargestellt von
// CoClass ADSystemInfo, zu erzeugen. Diese Funktionen können                     
// von einem Client verwendet werden, der die CoClasses automatisieren    
// möchte, die von dieser Typbibliothek dargestellt werden.               
// *********************************************************************//
  CoADSystemInfo = class
    class function Create: IADsADSystemInfo;
    class function CreateRemote(const MachineName: RawUtf8): IADsADSystemInfo;
  end;

// *********************************************************************//
// Die Klasse CoWinNTSystemInfo stellt eine Methode Create und CreateRemote zur      
// Verfügung, um Instanzen der Standardschnittstelle IADsWinNTSystemInfo, dargestellt von
// CoClass WinNTSystemInfo, zu erzeugen. Diese Funktionen können                     
// von einem Client verwendet werden, der die CoClasses automatisieren    
// möchte, die von dieser Typbibliothek dargestellt werden.               
// *********************************************************************//
  CoWinNTSystemInfo = class
    class function Create: IADsWinNTSystemInfo;
    class function CreateRemote(const MachineName: RawUtf8): IADsWinNTSystemInfo;
  end;

// *********************************************************************//
// Die Klasse CoDNWithBinary stellt eine Methode Create und CreateRemote zur      
// Verfügung, um Instanzen der Standardschnittstelle IADsDNWithBinary, dargestellt von
// CoClass DNWithBinary, zu erzeugen. Diese Funktionen können                     
// von einem Client verwendet werden, der die CoClasses automatisieren    
// möchte, die von dieser Typbibliothek dargestellt werden.               
// *********************************************************************//
  CoDNWithBinary = class
    class function Create: IADsDNWithBinary;
    class function CreateRemote(const MachineName: RawUtf8): IADsDNWithBinary;
  end;

// *********************************************************************//
// Die Klasse CoDNWithString stellt eine Methode Create und CreateRemote zur      
// Verfügung, um Instanzen der Standardschnittstelle IADsDNWithString, dargestellt von
// CoClass DNWithString, zu erzeugen. Diese Funktionen können                     
// von einem Client verwendet werden, der die CoClasses automatisieren    
// möchte, die von dieser Typbibliothek dargestellt werden.               
// *********************************************************************//
  CoDNWithString = class
    class function Create: IADsDNWithString;
    class function CreateRemote(const MachineName: RawUtf8): IADsDNWithString;
  end;

// *********************************************************************//
// Die Klasse CoADsSecurityUtility stellt eine Methode Create und CreateRemote zur      
// Verfügung, um Instanzen der Standardschnittstelle IADsSecurityUtility, dargestellt von
// CoClass ADsSecurityUtility, zu erzeugen. Diese Funktionen können                     
// von einem Client verwendet werden, der die CoClasses automatisieren    
// möchte, die von dieser Typbibliothek dargestellt werden.               
// *********************************************************************//
  CoADsSecurityUtility = class
    class function Create: IADsSecurityUtility;
    class function CreateRemote(const MachineName: RawUtf8): IADsSecurityUtility;
  end;

implementation

{$IFnDEF FPC}
uses
  ComObj;
{$ELSE}
{$ENDIF}


class function CoPropertyEntry.Create: IADsPropertyEntry;
begin
  Result := CreateComObject(CLASS_PropertyEntry) as IADsPropertyEntry;
end;

class function CoPropertyEntry.CreateRemote(const MachineName: RawUtf8): IADsPropertyEntry;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_PropertyEntry) as IADsPropertyEntry;
end;

class function CoPropertyValue.Create: IADsPropertyValue;
begin
  Result := CreateComObject(CLASS_PropertyValue) as IADsPropertyValue;
end;

class function CoPropertyValue.CreateRemote(const MachineName: RawUtf8): IADsPropertyValue;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_PropertyValue) as IADsPropertyValue;
end;

class function CoAccessControlEntry.Create: IADsAccessControlEntry;
begin
  Result := CreateComObject(CLASS_AccessControlEntry) as IADsAccessControlEntry;
end;

class function CoAccessControlEntry.CreateRemote(const MachineName: RawUtf8): IADsAccessControlEntry;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_AccessControlEntry) as IADsAccessControlEntry;
end;

class function CoAccessControlList.Create: IADsAccessControlList;
begin
  Result := CreateComObject(CLASS_AccessControlList) as IADsAccessControlList;
end;

class function CoAccessControlList.CreateRemote(const MachineName: RawUtf8): IADsAccessControlList;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_AccessControlList) as IADsAccessControlList;
end;

class function CoSecurityDescriptor.Create: IADsSecurityDescriptor;
begin
  Result := CreateComObject(CLASS_SecurityDescriptor) as IADsSecurityDescriptor;
end;

class function CoSecurityDescriptor.CreateRemote(const MachineName: RawUtf8): IADsSecurityDescriptor;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_SecurityDescriptor) as IADsSecurityDescriptor;
end;

class function CoLargeInteger.Create: IADsLargeInteger;
begin
  Result := CreateComObject(CLASS_LargeInteger) as IADsLargeInteger;
end;

class function CoLargeInteger.CreateRemote(const MachineName: RawUtf8): IADsLargeInteger;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_LargeInteger) as IADsLargeInteger;
end;

class function CoNameTranslate.Create: IADsNameTranslate;
begin
  Result := CreateComObject(CLASS_NameTranslate) as IADsNameTranslate;
end;

class function CoNameTranslate.CreateRemote(const MachineName: RawUtf8): IADsNameTranslate;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_NameTranslate) as IADsNameTranslate;
end;

class function CoCaseIgnoreList.Create: IADsCaseIgnoreList;
begin
  Result := CreateComObject(CLASS_CaseIgnoreList) as IADsCaseIgnoreList;
end;

class function CoCaseIgnoreList.CreateRemote(const MachineName: RawUtf8): IADsCaseIgnoreList;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_CaseIgnoreList) as IADsCaseIgnoreList;
end;

class function CoFaxNumber.Create: IADsFaxNumber;
begin
  Result := CreateComObject(CLASS_FaxNumber) as IADsFaxNumber;
end;

class function CoFaxNumber.CreateRemote(const MachineName: RawUtf8): IADsFaxNumber;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_FaxNumber) as IADsFaxNumber;
end;

class function CoNetAddress.Create: IADsNetAddress;
begin
  Result := CreateComObject(CLASS_NetAddress) as IADsNetAddress;
end;

class function CoNetAddress.CreateRemote(const MachineName: RawUtf8): IADsNetAddress;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_NetAddress) as IADsNetAddress;
end;

class function CoOctetList.Create: IADsOctetList;
begin
  Result := CreateComObject(CLASS_OctetList) as IADsOctetList;
end;

class function CoOctetList.CreateRemote(const MachineName: RawUtf8): IADsOctetList;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_OctetList) as IADsOctetList;
end;

class function CoEmail.Create: IADsEmail;
begin
  Result := CreateComObject(CLASS_Email) as IADsEmail;
end;

class function CoEmail.CreateRemote(const MachineName: RawUtf8): IADsEmail;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_Email) as IADsEmail;
end;

class function CoPath.Create: IADsPath;
begin
  Result := CreateComObject(CLASS_Path) as IADsPath;
end;

class function CoPath.CreateRemote(const MachineName: RawUtf8): IADsPath;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_Path) as IADsPath;
end;

class function CoReplicaPointer.Create: IADsReplicaPointer;
begin
  Result := CreateComObject(CLASS_ReplicaPointer) as IADsReplicaPointer;
end;

class function CoReplicaPointer.CreateRemote(const MachineName: RawUtf8): IADsReplicaPointer;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_ReplicaPointer) as IADsReplicaPointer;
end;

class function CoTimestamp.Create: IADsTimestamp;
begin
  Result := CreateComObject(CLASS_Timestamp) as IADsTimestamp;
end;

class function CoTimestamp.CreateRemote(const MachineName: RawUtf8): IADsTimestamp;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_Timestamp) as IADsTimestamp;
end;

class function CoPostalAddress.Create: IADsPostalAddress;
begin
  Result := CreateComObject(CLASS_PostalAddress) as IADsPostalAddress;
end;

class function CoPostalAddress.CreateRemote(const MachineName: RawUtf8): IADsPostalAddress;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_PostalAddress) as IADsPostalAddress;
end;

class function CoBackLink.Create: IADsBackLink;
begin
  Result := CreateComObject(CLASS_BackLink) as IADsBackLink;
end;

class function CoBackLink.CreateRemote(const MachineName: RawUtf8): IADsBackLink;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_BackLink) as IADsBackLink;
end;

class function CoTypedName.Create: IADsTypedName;
begin
  Result := CreateComObject(CLASS_TypedName) as IADsTypedName;
end;

class function CoTypedName.CreateRemote(const MachineName: RawUtf8): IADsTypedName;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_TypedName) as IADsTypedName;
end;

class function CoHold.Create: IADsHold;
begin
  Result := CreateComObject(CLASS_Hold) as IADsHold;
end;

class function CoHold.CreateRemote(const MachineName: RawUtf8): IADsHold;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_Hold) as IADsHold;
end;

class function CoPathname.Create: IADsPathname;
begin
  Result := CreateComObject(CLASS_Pathname) as IADsPathname;
end;

class function CoPathname.CreateRemote(const MachineName: RawUtf8): IADsPathname;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_Pathname) as IADsPathname;
end;

class function CoADSystemInfo.Create: IADsADSystemInfo;
begin
  Result := CreateComObject(CLASS_ADSystemInfo) as IADsADSystemInfo;
end;

class function CoADSystemInfo.CreateRemote(const MachineName: RawUtf8): IADsADSystemInfo;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_ADSystemInfo) as IADsADSystemInfo;
end;

class function CoWinNTSystemInfo.Create: IADsWinNTSystemInfo;
begin
  Result := CreateComObject(CLASS_WinNTSystemInfo) as IADsWinNTSystemInfo;
end;

class function CoWinNTSystemInfo.CreateRemote(const MachineName: RawUtf8): IADsWinNTSystemInfo;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_WinNTSystemInfo) as IADsWinNTSystemInfo;
end;

class function CoDNWithBinary.Create: IADsDNWithBinary;
begin
  Result := CreateComObject(CLASS_DNWithBinary) as IADsDNWithBinary;
end;

class function CoDNWithBinary.CreateRemote(const MachineName: RawUtf8): IADsDNWithBinary;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_DNWithBinary) as IADsDNWithBinary;
end;

class function CoDNWithString.Create: IADsDNWithString;
begin
  Result := CreateComObject(CLASS_DNWithString) as IADsDNWithString;
end;

class function CoDNWithString.CreateRemote(const MachineName: RawUtf8): IADsDNWithString;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_DNWithString) as IADsDNWithString;
end;

class function CoADsSecurityUtility.Create: IADsSecurityUtility;
begin
  Result := CreateComObject(CLASS_ADsSecurityUtility) as IADsSecurityUtility;
end;

class function CoADsSecurityUtility.CreateRemote(const MachineName: RawUtf8): IADsSecurityUtility;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_ADsSecurityUtility) as IADsSecurityUtility;
end;

end.
