 {      LDAPAdmin - LinLDAP.pas
 *      Copyright (C) 2016 Ivo Brhel
 *
 *      Author: Ivo Brhel, 2016
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

unit LinLDAP;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

{$WEAKPACKAGEUNIT}

interface

{$IFnDEF FPC}
uses
  Windows;
{$ELSE}
uses
  SysUtils, ldapsend, ssl_openssl,
  Classes, LazFileUtils,
  LCLIntf, LCLType, LMessages, Ctypes;
{$ENDIF}


{$HPPEMIT '#ifndef LDAP_CLIENT_DEFINED'}
{$HPPEMIT '#pragma option push -b -a8 -pc -A- /*P_O_Push_S*/'}
{$HPPEMIT '#define LDAP_CLIENT_DEFINED'}

{$HPPEMIT '#ifndef BASETYPES'}
{$HPPEMIT '#include <windef.h>'}
{$HPPEMIT '#endif'}

(*


*)

// Extra defines to keep compiler happy.
type
  PPCharA = ^PAnsiChar;
  {$NODEFINE PPCharA}
  PPCharW = ^PWideChar;
  {$NODEFINE PPCharW}
  PPChar = PPCharA;

  PPPCharA = ^PPCharA;
  {$NODEFINE PPPCharA}
  PPPCharW = ^PPCharW;
  {$NODEFINE PPPCharW}
  PPPChar = PPPCharA;


  ULONG = Cardinal ;
  PULONG = ^ULONG;

  PCharArray = array of PChar;


  LPSTR = PAnsiChar;
  LPCSTR = PAnsiChar;
  LPTSTR = PAnsiChar;
  LPCTSTR = PChar;
  LPWSTR = PWideChar;
  LPCWSTR = PWideChar;

  UCHAR = Char;


  PLDAPResult = ^TLDAPResult;

//
//  The #define LDAP_UNICODE controls if we map the undecorated calls to
//  their unicode counterparts or just leave them defined as the normal
//  single byte entry points.
//
//  If you want to write a UNICODE enabled application, you'd normally
//  just have UNICODE defined and then we'll default to using all LDAP
//  Unicode calls.
//

const
  //
  //  Global constants
  //

  {$EXTERNALSYM LDAP_PORT}
  LDAP_PORT               = 389;
  {$EXTERNALSYM LDAP_SSL_PORT}
  LDAP_SSL_PORT           = 636;
  {$EXTERNALSYM LDAP_GC_PORT}
  LDAP_GC_PORT            = 3268;
  {$EXTERNALSYM LDAP_SSL_GC_PORT}
  LDAP_SSL_GC_PORT        = 3269;


//
//  We currently support going to either v2 or v3 servers, though the API
//  is only a V2 API.  We'll add support for result sets, server side
//  sorting, extended operations, etc as soon as they stabilize.
//

  {$EXTERNALSYM LDAP_VERSION1}
  LDAP_VERSION1          = 1;
  {$EXTERNALSYM LDAP_VERSION2}
  LDAP_VERSION2          = 2;
  {$EXTERNALSYM LDAP_VERSION3}
  LDAP_VERSION3          = 3;
  {$EXTERNALSYM LDAP_VERSION}
  LDAP_VERSION           = LDAP_VERSION2;

//
//  All tags are CCFTTTTT.
//               CC        Tag Class 00 = universal
//                                   01 = application wide
//                                   10 = context specific
//                                   11 = private use
//
//                 F       Form 0 primitive
//                              1 constructed
//
//                  TTTTT  Tag Number
//

//
// LDAP v2 & v3 commands.
//

  {$EXTERNALSYM LDAP_BIND_CMD}
  LDAP_BIND_CMD          = $60;   // application + constructed
  {$EXTERNALSYM LDAP_UNBIND_CMD}
  LDAP_UNBIND_CMD        = $42;   // application + primitive
  {$EXTERNALSYM LDAP_SEARCH_CMD}
  LDAP_SEARCH_CMD        = $63;   // application + constructed
  {$EXTERNALSYM LDAP_MODIFY_CMD}
  LDAP_MODIFY_CMD        = $66;   // application + constructed
  {$EXTERNALSYM LDAP_ADD_CMD}
  LDAP_ADD_CMD           = $68;   // application + constructed
  {$EXTERNALSYM LDAP_DELETE_CMD}
  LDAP_DELETE_CMD        = $4a;   // application + primitive
  {$EXTERNALSYM LDAP_MODRDN_CMD}
  LDAP_MODRDN_CMD        = $6c;   // application + constructed
  {$EXTERNALSYM LDAP_COMPARE_CMD}
  LDAP_COMPARE_CMD       = $6e;   // application + constructed
  {$EXTERNALSYM LDAP_ABANDON_CMD}
  LDAP_ABANDON_CMD       = $50;   // application + primitive
  {$EXTERNALSYM LDAP_SESSION_CMD}
  LDAP_SESSION_CMD       = $71;   // application + constructed
  {$EXTERNALSYM LDAP_EXTENDED_CMD}
  LDAP_EXTENDED_CMD      = $77;   // application + constructed

//
// Responses/Results for LDAP v2 & v3
//

  {$EXTERNALSYM LDAP_RES_BIND}
  LDAP_RES_BIND           = $61;   // application + constructed
  {$EXTERNALSYM LDAP_RES_SEARCH_ENTRY}
  LDAP_RES_SEARCH_ENTRY   = $64;   // application + constructed
  {$EXTERNALSYM LDAP_RES_SEARCH_RESULT}
  LDAP_RES_SEARCH_RESULT  = $65;   // application + constructed
  {$EXTERNALSYM LDAP_RES_MODIFY}
  LDAP_RES_MODIFY         = $67;   // application + constructed
  {$EXTERNALSYM LDAP_RES_ADD}
  LDAP_RES_ADD            = $69;   // application + constructed
  {$EXTERNALSYM LDAP_RES_DELETE}
  LDAP_RES_DELETE         = $6b;   // application + constructed
  {$EXTERNALSYM LDAP_RES_MODRDN}
  LDAP_RES_MODRDN         = $6d;   // application + constructed
  {$EXTERNALSYM LDAP_RES_COMPARE}
  LDAP_RES_COMPARE        = $6f;   // application + constructed
  {$EXTERNALSYM LDAP_RES_SESSION}
  LDAP_RES_SESSION        = $72;   // application + constructed
  {$EXTERNALSYM LDAP_RES_REFERRAL}
  LDAP_RES_REFERRAL       = $73;   // application + constructed
  {$EXTERNALSYM LDAP_RES_EXTENDED}
  LDAP_RES_EXTENDED       = $78;   // application + constructed
  {$EXTERNALSYM LDAP_RES_ANY}
  LDAP_RES_ANY            = -1;

  {$EXTERNALSYM LDAP_INVALID_CMD}
  LDAP_INVALID_CMD         = $FF;
  {$EXTERNALSYM LDAP_INVALID_RES}
  LDAP_INVALID_RES         = $FF;


//
// We'll make the error codes compatible with reference implementation
//

type
  {$EXTERNALSYM LDAP_RETCODE}
  LDAP_RETCODE = ULONG;
  //LDAP_RETCODE = Cardinal;

const
  {$EXTERNALSYM LDAP_SUCCESS}
  LDAP_SUCCESS                    =   $00;
  {$EXTERNALSYM LDAP_OPERATIONS_ERROR}
  LDAP_OPERATIONS_ERROR           =   $01;
  {$EXTERNALSYM LDAP_PROTOCOL_ERROR}
  LDAP_PROTOCOL_ERROR             =   $02;
  {$EXTERNALSYM LDAP_TIMELIMIT_EXCEEDED}
  LDAP_TIMELIMIT_EXCEEDED         =   $03;
  {$EXTERNALSYM LDAP_SIZELIMIT_EXCEEDED}
  LDAP_SIZELIMIT_EXCEEDED         =   $04;
  {$EXTERNALSYM LDAP_COMPARE_FALSE}
  LDAP_COMPARE_FALSE              =   $05;
  {$EXTERNALSYM LDAP_COMPARE_TRUE}
  LDAP_COMPARE_TRUE               =   $06;
  {$EXTERNALSYM LDAP_AUTH_METHOD_NOT_SUPPORTED}
  LDAP_AUTH_METHOD_NOT_SUPPORTED  =   $07;
  {$EXTERNALSYM LDAP_STRONG_AUTH_REQUIRED}
  LDAP_STRONG_AUTH_REQUIRED       =   $08;
  {$EXTERNALSYM LDAP_REFERRAL_V2}
  LDAP_REFERRAL_V2                =   $09;
  {$EXTERNALSYM LDAP_PARTIAL_RESULTS}
  LDAP_PARTIAL_RESULTS            =   $09;
  {$EXTERNALSYM LDAP_REFERRAL}
  LDAP_REFERRAL                   =   $0a;
  {$EXTERNALSYM LDAP_ADMIN_LIMIT_EXCEEDED}
  LDAP_ADMIN_LIMIT_EXCEEDED       =   $0b;
  {$EXTERNALSYM LDAP_UNAVAILABLE_CRIT_EXTENSION}
  LDAP_UNAVAILABLE_CRIT_EXTENSION =   $0c;
  {$EXTERNALSYM LDAP_CONFIDENTIALITY_REQUIRED}
  LDAP_CONFIDENTIALITY_REQUIRED   =   $0d;
  {$EXTERNALSYM LDAP_SASL_BIND_IN_PROGRESS}
  LDAP_SASL_BIND_IN_PROGRESS      =   $0e;


  {$EXTERNALSYM LDAP_NO_SUCH_ATTRIBUTE}
  LDAP_NO_SUCH_ATTRIBUTE          =   $10;
  {$EXTERNALSYM LDAP_UNDEFINED_TYPE}
  LDAP_UNDEFINED_TYPE             =   $11;
  {$EXTERNALSYM LDAP_INAPPROPRIATE_MATCHING}
  LDAP_INAPPROPRIATE_MATCHING     =   $12;
  {$EXTERNALSYM LDAP_CONSTRAINT_VIOLATION}
  LDAP_CONSTRAINT_VIOLATION       =   $13;
  {$EXTERNALSYM LDAP_ATTRIBUTE_OR_VALUE_EXISTS}
  LDAP_ATTRIBUTE_OR_VALUE_EXISTS  =   $14;
  {$EXTERNALSYM LDAP_INVALID_SYNTAX}
  LDAP_INVALID_SYNTAX             =   $15;

  {$EXTERNALSYM LDAP_NO_SUCH_OBJECT}
  LDAP_NO_SUCH_OBJECT             =   $20;
  {$EXTERNALSYM LDAP_ALIAS_PROBLEM}
  LDAP_ALIAS_PROBLEM              =   $21;
  {$EXTERNALSYM LDAP_INVALID_DN_SYNTAX}
  LDAP_INVALID_DN_SYNTAX          =   $22;
  {$EXTERNALSYM LDAP_IS_LEAF}
  LDAP_IS_LEAF                    =   $23;
  {$EXTERNALSYM LDAP_ALIAS_DEREF_PROBLEM}
  LDAP_ALIAS_DEREF_PROBLEM        =   $24;

  {$EXTERNALSYM LDAP_INAPPROPRIATE_AUTH}
  LDAP_INAPPROPRIATE_AUTH         =   $30;
  {$EXTERNALSYM LDAP_INVALID_CREDENTIALS}
  LDAP_INVALID_CREDENTIALS        =   $31;
  {$EXTERNALSYM LDAP_INSUFFICIENT_RIGHTS}
  LDAP_INSUFFICIENT_RIGHTS        =   $32;
  {$EXTERNALSYM LDAP_BUSY}
  LDAP_BUSY                       =   $33;
  {$EXTERNALSYM LDAP_UNAVAILABLE}
  LDAP_UNAVAILABLE                =   $34;
  {$EXTERNALSYM LDAP_UNWILLING_TO_PERFORM}
  LDAP_UNWILLING_TO_PERFORM       =   $35;
  {$EXTERNALSYM LDAP_LOOP_DETECT}
  LDAP_LOOP_DETECT                =   $36;

  {$EXTERNALSYM LDAP_NAMING_VIOLATION}
  LDAP_NAMING_VIOLATION           =   $40;
  {$EXTERNALSYM LDAP_OBJECT_CLASS_VIOLATION}
  LDAP_OBJECT_CLASS_VIOLATION     =   $41;
  {$EXTERNALSYM LDAP_NOT_ALLOWED_ON_NONLEAF}
  LDAP_NOT_ALLOWED_ON_NONLEAF     =   $42;
  {$EXTERNALSYM LDAP_NOT_ALLOWED_ON_RDN}
  LDAP_NOT_ALLOWED_ON_RDN         =   $43;
  {$EXTERNALSYM LDAP_ALREADY_EXISTS}
  LDAP_ALREADY_EXISTS             =   $44;
  {$EXTERNALSYM LDAP_NO_OBJECT_CLASS_MODS}
  LDAP_NO_OBJECT_CLASS_MODS       =   $45;
  {$EXTERNALSYM LDAP_RESULTS_TOO_LARGE}
  LDAP_RESULTS_TOO_LARGE          =   $46;
  {$EXTERNALSYM LDAP_AFFECTS_MULTIPLE_DSAS}
  LDAP_AFFECTS_MULTIPLE_DSAS      =   $47;

  {$EXTERNALSYM LDAP_OTHER}
  LDAP_OTHER                      =   $50;
  {$EXTERNALSYM LDAP_SERVER_DOWN}
  LDAP_SERVER_DOWN                =   $51;
  {$EXTERNALSYM LDAP_LOCAL_ERROR}
  LDAP_LOCAL_ERROR                =   $52;
  {$EXTERNALSYM LDAP_ENCODING_ERROR}
  LDAP_ENCODING_ERROR             =   $53;
  {$EXTERNALSYM LDAP_DECODING_ERROR}
  LDAP_DECODING_ERROR             =   $54;
  {$EXTERNALSYM LDAP_TIMEOUT}
  LDAP_TIMEOUT                    =   $55;
  {$EXTERNALSYM LDAP_AUTH_UNKNOWN}
  LDAP_AUTH_UNKNOWN               =   $56;
  {$EXTERNALSYM LDAP_FILTER_ERROR}
  LDAP_FILTER_ERROR               =   $57;
  {$EXTERNALSYM LDAP_USER_CANCELLED}
  LDAP_USER_CANCELLED             =   $58;
  {$EXTERNALSYM LDAP_PARAM_ERROR}
  LDAP_PARAM_ERROR                =   $59;
  {$EXTERNALSYM LDAP_NO_MEMORY}
  LDAP_NO_MEMORY                  =   $5a;
  {$EXTERNALSYM LDAP_CONNECT_ERROR}
  LDAP_CONNECT_ERROR              =   $5b;
  {$EXTERNALSYM LDAP_NOT_SUPPORTED}
  LDAP_NOT_SUPPORTED              =   $5c;
  {$EXTERNALSYM LDAP_NO_RESULTS_RETURNED}
  LDAP_NO_RESULTS_RETURNED        =   $5e;
  {$EXTERNALSYM LDAP_CONTROL_NOT_FOUND}
  LDAP_CONTROL_NOT_FOUND          =   $5d;
  {$EXTERNALSYM LDAP_MORE_RESULTS_TO_RETURN}
  LDAP_MORE_RESULTS_TO_RETURN     =   $5f;

  {$EXTERNALSYM LDAP_CLIENT_LOOP}
  LDAP_CLIENT_LOOP                =   $60;
  {$EXTERNALSYM LDAP_REFERRAL_LIMIT_EXCEEDED}
  LDAP_REFERRAL_LIMIT_EXCEEDED    =   $61;


//
//  Bind methods.  We support the following methods :
//
//      Simple         Clear text password... try not to use as it's not secure.
//
//      MSN            MSN(Microsoft Network)authentication. This package
//                     may bring up UI to prompt the user for MSN credentials.
//
//      DPA            Normandy authentication... new MSN authentication.  Same
//                     usage as MSN.
//
//      NTLM           NT domain authentication.  Use NULL credentials and
//                     we'll try to use default logged in user credentials.
//
//      Sicily         Negotiate with the server for any of: MSN, DPA, NTLM
//
//      SSPI           Use GSSAPI Negotiate package to negotiate security
//                     package of either Kerberos v5 or NTLM(or any other
//                     package the client and server negotiate).  Pass in
//                     NULL credentials to specify default logged in user or
//                     you may pass in a SEC_WINNT_AUTH_IDENTITY_W(defined
//                     in rpcdce.h)to specify alternate credentials.
//
//  For all bind methods except for Simple, you may pass in a
//  SEC_WINNT_AUTH_IDENTITY_W (defined in rpcdce.h) or the newer
//  SEC_WINNT_AUTH_IDENTITY_EXW (defined in secext.h) to specify alternate
//  credentials.
//
//  All bind methods other than simple are synchronous only calls.
//  Calling the asynchronous bind call for any of these messages will
//  return LDAP_PARAM_ERROR.
//
//  Using any other method besides simple will cause WLDAP32 to pull in
//  the SSPI security DLLs(SECURITY.DLL etc).
//
//  On NTLM and SSPI, if you specify NULL credentials, we'll attempt to use
//  the default logged in user.
//

const
  {$EXTERNALSYM LDAP_AUTH_SIMPLE}
  LDAP_AUTH_SIMPLE                = $80;
  {$EXTERNALSYM LDAP_AUTH_SASL}
  LDAP_AUTH_SASL                  = $83;

  {$EXTERNALSYM LDAP_AUTH_OTHERKIND}
  LDAP_AUTH_OTHERKIND             = $86;

// The SICILY type covers package negotiation to MSN servers.
// Each of the supported types can also be specified without
// doing the package negotiation, assuming the caller knows
// what the server supports.

  {$EXTERNALSYM LDAP_AUTH_SICILY}
  LDAP_AUTH_SICILY                = LDAP_AUTH_OTHERKIND or $0200;

  {$EXTERNALSYM LDAP_AUTH_MSN}
  LDAP_AUTH_MSN                   = LDAP_AUTH_OTHERKIND or $0800;
  {$EXTERNALSYM LDAP_AUTH_NTLM}
  LDAP_AUTH_NTLM                  = LDAP_AUTH_OTHERKIND or $1000;
  {$EXTERNALSYM LDAP_AUTH_DPA}
  LDAP_AUTH_DPA                   = LDAP_AUTH_OTHERKIND or $2000;

// This will cause the client to use the GSSAPI negotiation
// package to determine the most appropriate authentication type.
// This type should be used when talking to NT5.

  {$EXTERNALSYM LDAP_AUTH_NEGOTIATE}
  LDAP_AUTH_NEGOTIATE             = LDAP_AUTH_OTHERKIND or $0400;

// backward compatible #define for older constant name.

  {$EXTERNALSYM LDAP_AUTH_SSPI}
  LDAP_AUTH_SSPI                  = LDAP_AUTH_NEGOTIATE;

//
//  Client applications typically don't have to encode/decode LDAP filters,
//  but if they do, we define the operators here.
//
//  Filter types.

  {$EXTERNALSYM LDAP_FILTER_AND}
  LDAP_FILTER_AND         = $a0;    // context specific + constructed - SET OF Filters.
  {$EXTERNALSYM LDAP_FILTER_OR}
  LDAP_FILTER_OR          = $a1;    // context specific + constructed - SET OF Filters.
  {$EXTERNALSYM LDAP_FILTER_NOT}
  LDAP_FILTER_NOT         = $a2;    // context specific + constructed - Filter
  {$EXTERNALSYM LDAP_FILTER_EQUALITY}
  LDAP_FILTER_EQUALITY    = $a3;    // context specific + constructed - AttributeValueAssertion.
  {$EXTERNALSYM LDAP_FILTER_SUBSTRINGS}
  LDAP_FILTER_SUBSTRINGS  = $a4;    // context specific + constructed - SubstringFilter
  {$EXTERNALSYM LDAP_FILTER_GE}
  LDAP_FILTER_GE          = $a5;    // context specific + constructed - AttributeValueAssertion.
  {$EXTERNALSYM LDAP_FILTER_LE}
  LDAP_FILTER_LE          = $a6;    // context specific + constructed - AttributeValueAssertion.
  {$EXTERNALSYM LDAP_FILTER_PRESENT}
  LDAP_FILTER_PRESENT     = $87;    // context specific + primitive   - AttributeType.
  {$EXTERNALSYM LDAP_FILTER_APPROX}
  LDAP_FILTER_APPROX      = $a8;    // context specific + constructed - AttributeValueAssertion.
  {$EXTERNALSYM LDAP_FILTER_EXTENSIBLE}
  LDAP_FILTER_EXTENSIBLE  = $a9;    // context specific + constructed - MatchingRuleAssertion.

//  Substring filter types

  {$EXTERNALSYM LDAP_SUBSTRING_INITIAL}
  LDAP_SUBSTRING_INITIAL  = $80;   // class context specific
  {$EXTERNALSYM LDAP_SUBSTRING_ANY}
  LDAP_SUBSTRING_ANY      = $81;   // class context specific
  {$EXTERNALSYM LDAP_SUBSTRING_FINAL}
  LDAP_SUBSTRING_FINAL    = $82;   // class context specific

//
//  Possible values for ld_deref field.
//      "Never"     - never deref aliases.  return only the alias.
//      "Searching" - only deref aliases when searching, not when locating
//                    the base object of a search.
//      "Finding"   - dereference the alias when locating the base object but
//                    not during a search.
//      "Always"    - always dereference aliases.
//

  {$EXTERNALSYM LDAP_DEREF_NEVER}
  LDAP_DEREF_NEVER        = 0;
  {$EXTERNALSYM LDAP_DEREF_SEARCHING}
  LDAP_DEREF_SEARCHING    = 1;
  {$EXTERNALSYM LDAP_DEREF_FINDING}
  LDAP_DEREF_FINDING      = 2;
  {$EXTERNALSYM LDAP_DEREF_ALWAYS}
  LDAP_DEREF_ALWAYS       = 3;

//  Special values for ld_sizelimit :

  {$EXTERNALSYM LDAP_NO_LIMIT}
  LDAP_NO_LIMIT       = 0;

//  Flags for ld_options field :

  {$EXTERNALSYM LDAP_OPT_DNS}
  LDAP_OPT_DNS                = $00000001;  // utilize DN & DNS
  {$EXTERNALSYM LDAP_OPT_CHASE_REFERRALS}
  LDAP_OPT_CHASE_REFERRALS    = $00000002;  // chase referrals
  {$EXTERNALSYM LDAP_OPT_RETURN_REFS}
  LDAP_OPT_RETURN_REFS        = $00000004;  // return referrals to calling app

//
//  LDAP structure per connection
//

{$HPPEMIT '#pragma pack(push, 4)'}
{$ALIGN ON}

type
  {$EXTERNALSYM PLDAP}
  PLDAP2 = ^LDAP2;
  {$EXTERNALSYM LDAP}
  LDAP2 = record

    ld_sb: record
      sb_sd: ULONG;
      Reserved1: array [0..(10 * sizeof(ULONG))] of Byte;
      sb_naddr: ULONG;   // notzero implies CLDAP available
      Reserved2: array [0..(6 * sizeof(ULONG)) - 1] of Byte;
    end;

    //
    //  Following parameters MAY match up to reference implementation of LDAP
    //

    ld_host: PChar;
    ld_version: ULONG;
    ld_lberoptions: Byte;

    //
    //  Safe to assume that these parameters are in same location as
    //  reference implementation of LDAP API.
    //

    ld_deref: ULONG;

    ld_timelimit: ULONG;
    ld_sizelimit: ULONG;

    ld_errno: ULONG;
    ld_matched: PChar;
    ld_error: PChar;
    ld_msgid: ULONG;

    Reserved3: array  [0..(6*sizeof(ULONG))] of Byte;

    //
    //  Following parameters may match up to reference implementation of LDAP API.
    //

    ld_cldaptries: ULONG;
    ld_cldaptimeout: ULONG;
    ld_refhoplimit: ULONG;
    ld_options: ULONG;
  end;

//
//  Our timeval structure is a bit different from the reference implementation
//  since Win32 defines a _timeval structure that is different from the LDAP
//  one.
//

  PLDAPTimeVal = ^TLDAPTimeVal;
  {$EXTERNALSYM l_timeval}
  l_timeval = packed record
    tv_sec: Longint;
    tv_usec: Longint;
  end;
  {$EXTERNALSYM LDAP_TIMEVAL}
  LDAP_TIMEVAL = l_timeval;
  {$EXTERNALSYM PLDAP_TIMEVAL}
  PLDAP_TIMEVAL = ^LDAP_TIMEVAL;
  TLDAPTimeVal = l_timeval;

//
//  The berval structure is used to pass in any arbitrary octet string.  It
//  is useful for attributes that cannot be represented using a null
//  terminated string.
//

  PLDAPBerVal = ^TLDAPBerVal;
  PPLDAPBerVal = ^PLDAPBerVal;
  {$EXTERNALSYM PLDAP_BERVAL}
  PLDAP_BERVAL = ^berval;
  {$EXTERNALSYM PBERVAL}
  PBERVAL = ^berval;
  {$EXTERNALSYM berval}
  berval = record
    bv_len: ULONG;
    bv_val: PChar;
  end;
  {$EXTERNALSYM LDAP_BERVAL}
  LDAP_BERVAL = berval;
  TLDAPBerVal = berval;

  PPLdapBerValA = array of PLdapBerVal;


//
//  The following structure has to be compatible with reference implementation.
//

  PPLDAPMessage = ^PLDAPMessage;
  {$EXTERNALSYM PLDAPMessage}
  PLDAPMessage = ^LDAPMessage;
  {$EXTERNALSYM ldapmsg}
  ldapmsg = record
    lm_msgid: ULONG;             // message number for given connection
    lm_msgtype: ULONG;           // message type of the form LDAP_RES_xxx

    lm_ber: Pointer;             // ber form of message

    lm_chain: PLDAPMessage;      // pointer to next result value
    lm_next: PLDAPMessage;       // pointer to next message
    lm_time: ULONG;

    //
    //  new fields below not in reference implementation
    //

    Connection: PLDAP2;           // connection from which we received response
    Request: Pointer;            // owning request(opaque structure)
    lm_returncode: ULONG;        // server's return code
    lm_referral: Word;           // index of referral within ref table
    lm_chased: ByteBool;         // has referral been chased already?
    lm_eom: ByteBool;            // is this the last entry for this message?
    ConnectionReferenced: ByteBool; // is the Connection still valid?
  end;
  {$EXTERNALSYM LDAPMessage}
  LDAPMessage = ldapmsg;

//
//  Controls... there are three types :
//
//   1) those passed to the server
//   2) those passed to the client and handled by the client API
//   3) those returned by the server
//

// Extra types defined for use as parameter.
  PPPLDAPControlA = ^PPLDAPControlA;
  {$NODEFINE PPPLDAPControlA}
  PPPLDAPControlW = ^PPLDAPControlW;
  {$NODEFINE PPPLDAPControlW}
  {$IFDEF UNICODE}
  PPPLDAPControl = PPPLDAPControlW;
  {$ELSE}
  PPPLDAPControl = PPPLDAPControlA;
  {$ENDIF}
  PPLDAPControlA = ^PLDAPControlA;
  {$NODEFINE PPLDAPControlA}
  PPLDAPControlW = ^PLDAPControlW;
  {$NODEFINE PPLDAPControlW}
  {$IFDEF UNICODE}
  PPLDAPControl = PPLDAPControlW;
  {$ELSE}
  PPLDAPControl = PPLDAPControlA;
  {$ENDIF}

  {$EXTERNALSYM PLDAPControlA}
  PLDAPControlA = ^LDAPControlA;
  {$EXTERNALSYM PLDAPControlW}
  PLDAPControlW = ^LDAPControlW;
  {$EXTERNALSYM PLDAPControl}
  {$IFDEF UNICODE}
  PLDAPControl = PLDAPControlW;
  {$ELSE}
  PLDAPControl = PLDAPControlA;
  {$ENDIF}

  {$EXTERNALSYM LDAPControlA}
  LDAPControlA = record
    ldctl_oid: PAnsiChar;
    ldctl_value: TLDAPBerVal;
    ldctl_iscritical: ByteBool;
  end;
  {$EXTERNALSYM LDAPControlW}
  LDAPControlW = record
    ldctl_oid: PWideChar;
    ldctl_value: TLDAPBerVal;
    ldctl_iscritical: ByteBool;
  end;
  {$EXTERNALSYM LDAPControl}
  {$IFDEF UNICODE}
  LDAPControl = LDAPControlW;
  {$ELSE}
  LDAPControl = LDAPControlA;
  {$ENDIF}

  TLDAPControlA = LDAPControlA;
  TLDAPControlW = LDAPControlW;
  {$IFDEF UNICODE}
  TLDAPControl = TLDAPControlW;
  {$ELSE}
  TLDAPControl = TLDAPControlA;
  {$ENDIF}

//
//  Client controls section : these are the client controls that wldap32.dll
//  supports.
//
//  If you specify LDAP_CONTROL_REFERRALS in a control, the value field should
//  point to a ULONG of the following flags :
//
//      LDAP_CHASE_SUBORDINATE_REFERRALS
//      LDAP_CHASE_EXTERNAL_REFERRALS
//
const
  {$EXTERNALSYM LDAP_CONTROL_REFERRALS_W}
  LDAP_CONTROL_REFERRALS_W = '1.2.840.113556.1.4.616';
  {$EXTERNALSYM LDAP_CONTROL_REFERRALS}
  {$IFDEF UNICODE}
  LDAP_CONTROL_REFERRALS   = LDAP_CONTROL_REFERRALS_W;
  {$ELSE}
  LDAP_CONTROL_REFERRALS   = '1.2.840.113556.1.4.616';
  {$ENDIF}

//
//  Values required for Modification command  These are options for the
//  mod_op field of LDAPMod structure
//

const
  {$EXTERNALSYM LDAP_MOD_ADD}
  LDAP_MOD_ADD            = $00;
  {$EXTERNALSYM LDAP_MOD_DELETE}
  LDAP_MOD_DELETE         = $01;
  {$EXTERNALSYM LDAP_MOD_REPLACE}
  LDAP_MOD_REPLACE        = $02;
  {$EXTERNALSYM LDAP_MOD_BVALUES}
  LDAP_MOD_BVALUES        = $80;


type
  {$EXTERNALSYM PLDAPModA}
  PLDAPModA = ^LDAPModA;
  {$EXTERNALSYM PLDAPModW}
  PLDAPModW = ^LDAPModW;
  {$EXTERNALSYM PLDAPMod}
  {$IFDEF UNICODE}
  PLDAPMod = PLDAPModW;
  {$ELSE}
  PLDAPMod = PLDAPModA;
  {$ENDIF}
  {$EXTERNALSYM LDAPModA}
  LDAPModA = record
    mod_op: ULONG;
    mod_type: PAnsiChar;
    case integer of
      0:(modv_strvals: ^PAnsiChar);
      1:(modv_bvals: ^PLDAPBerVal);
  end;
  PPLDAPMod = array of PLDAPMod;
  {$EXTERNALSYM LDAPModW}
  LDAPModW = record
    mod_op: ULONG;
    mod_type: PWideChar;
    case integer of
      0:(modv_strvals: ^PWideChar);
      1:(modv_bvals: ^PLDAPBerVal);
  end;
  {$EXTERNALSYM LDAPMod}
  {$IFDEF UNICODE}
  LDAPMod = LDAPModW;
  {$ELSE}
  LDAPMod = LDAPModA;
  {$ENDIF}
  TLDAPModA = LDAPModA;
  TLDAPModW = LDAPModW;
  {$IFDEF UNICODE}
  TLDAPMod = TLDAPModW;
  {$ELSE}
  TLDAPMod = TLDAPModA;
  {$ENDIF}

{$HPPEMIT '#pragma pack(pop)'}

//
//  macros compatible with reference implementation...
//

{$EXTERNALSYM LDAP_IS_CLDAP}
///function LDAP_IS_CLDAP(ld: PLDAP): Boolean;
{$EXTERNALSYM NAME_ERROR}
///function NAME_ERROR(n: Integer): Boolean;

//
//  function definitions for LDAP API
//

//
//  Create a connection block to an LDAP server.  HostName can be NULL, in
//  which case we'll try to go off and find the "default" LDAP server.
//
//  Note that if we have to go off and find the default server, we'll pull
//  in NETAPI32.DLL and ADVAPI32.DLL.
//
//  If it returns NULL, an error occurred.  Pick up error code with
//     GetLastError().
//
//  ldap_open actually opens the connection at the time of the call,
//  whereas ldap_init only opens the connection when an operation is performed
//  that requires it.


//
//  These are the values to pass to ldap_get/set_option :
//

const
  {$EXTERNALSYM LDAP_OPT_DESC}
  LDAP_OPT_DESC               = $01;
  {$EXTERNALSYM LDAP_OPT_DEREF}
  LDAP_OPT_DEREF              = $02;
  {$EXTERNALSYM LDAP_OPT_SIZELIMIT}
  LDAP_OPT_SIZELIMIT          = $03;
  {$EXTERNALSYM LDAP_OPT_TIMELIMIT}
  LDAP_OPT_TIMELIMIT          = $04;
  {$EXTERNALSYM LDAP_OPT_THREAD_FN_PTRS}
  LDAP_OPT_THREAD_FN_PTRS     = $05;
  {$EXTERNALSYM LDAP_OPT_REBIND_FN}
  LDAP_OPT_REBIND_FN          = $06;
  {$EXTERNALSYM LDAP_OPT_REBIND_ARG}
  LDAP_OPT_REBIND_ARG         = $07;
  {$EXTERNALSYM LDAP_OPT_REFERRALS}
  LDAP_OPT_REFERRALS          = $08;
  {$EXTERNALSYM LDAP_OPT_RESTART}
  LDAP_OPT_RESTART            = $09;

  LDAP_OPT_SSL                = $0a;
  {$EXTERNALSYM LDAP_OPT_IO_FN_PTRS}
  LDAP_OPT_IO_FN_PTRS         = $0b;
  {$EXTERNALSYM LDAP_OPT_CACHE_FN_PTRS}
  LDAP_OPT_CACHE_FN_PTRS      = $0d;
  {$EXTERNALSYM LDAP_OPT_CACHE_STRATEGY}
  LDAP_OPT_CACHE_STRATEGY     = $0e;
  {$EXTERNALSYM LDAP_OPT_CACHE_ENABLE}
  LDAP_OPT_CACHE_ENABLE       = $0f;
  {$EXTERNALSYM LDAP_OPT_REFERRAL_HOP_LIMIT}
  LDAP_OPT_REFERRAL_HOP_LIMIT = $10;

  {$EXTERNALSYM LDAP_OPT_PROTOCOL_VERSION}
  LDAP_OPT_PROTOCOL_VERSION   = $11;
  {$EXTERNALSYM LDAP_OPT_VERSION}
  LDAP_OPT_VERSION            = $11;
  {$EXTERNALSYM LDAP_OPT_SORTKEYS}
  LDAP_OPT_SORTKEYS           = $11;

//
//  These are new ones that we've defined, not in current RFC draft.
//

  {$EXTERNALSYM LDAP_OPT_HOST_NAME}
  LDAP_OPT_HOST_NAME          = $30;
  {$EXTERNALSYM LDAP_OPT_ERROR_NUMBER}
  LDAP_OPT_ERROR_NUMBER       = $31;
  {$EXTERNALSYM LDAP_OPT_ERROR_STRING}
  LDAP_OPT_ERROR_STRING       = $32;
  {$EXTERNALSYM LDAP_OPT_SERVER_ERROR}
  LDAP_OPT_SERVER_ERROR       = $33;
  {$EXTERNALSYM LDAP_OPT_SERVER_EXT_ERROR}
  LDAP_OPT_SERVER_EXT_ERROR   = $34;
  {$EXTERNALSYM LDAP_OPT_HOST_REACHABLE}
  LDAP_OPT_HOST_REACHABLE     = $3E;

//
//  These options control the keep-alive logic.  Keep alives are sent as
//  ICMP ping messages (which currently don't go through firewalls).
//
//  There are three values that control how this works :
//  PING_KEEP_ALIVE : min number of seconds since we last received a response
//                    from the server before we send a keep-alive ping
//  PING_WAIT_TIME  : number of milliseconds we wait for the response to
//                    come back when we send a ping
//  PING_LIMIT      : number of unanswered pings we send before we close the
//                    connection.
//
//  To disable the keep-alive logic, set any of the values (PING_KEEP_ALIVE,
//  PING_LIMIT, or PING_WAIT_TIME) to zero.
//
//  The current default/min/max for these values are as follows :
//
//  PING_KEEP_ALIVE :  120/5/maxInt  seconds (may also be zero)
//  PING_WAIT_TIME  :  2000/10/60000 milliseconds (may also be zero)
//  PING_LIMIT      :  4/0/maxInt
//

  {$EXTERNALSYM LDAP_OPT_PING_KEEP_ALIVE}
  LDAP_OPT_PING_KEEP_ALIVE    = $36;
  {$EXTERNALSYM LDAP_OPT_PING_WAIT_TIME}
  LDAP_OPT_PING_WAIT_TIME     = $37;
  {$EXTERNALSYM LDAP_OPT_PING_LIMIT}
  LDAP_OPT_PING_LIMIT         = $38;

//
//  These won't be in the RFC.  Only use these if you're going to be dependent
//  on our implementation.
//

  {$EXTERNALSYM LDAP_OPT_DNSDOMAIN_NAME}
  LDAP_OPT_DNSDOMAIN_NAME     = $3B;    // return DNS name of domain
  {$EXTERNALSYM LDAP_OPT_GETDSNAME_FLAGS}
  LDAP_OPT_GETDSNAME_FLAGS    = $3D;    // flags for DsGetDcName

  {$EXTERNALSYM LDAP_OPT_PROMPT_CREDENTIALS}
  LDAP_OPT_PROMPT_CREDENTIALS = $3F;    // prompt for creds? currently
                                        // only for DPA & NTLM if no creds
                                        // are loaded

  {$EXTERNALSYM LDAP_OPT_AUTO_RECONNECT}
  LDAP_OPT_AUTO_RECONNECT     = $91;    // enable/disable autoreconnect
  {$EXTERNALSYM LDAP_OPT_SSPI_FLAGS}
  LDAP_OPT_SSPI_FLAGS         = $92;    // flags to pass to InitSecurityContext

//
// To retrieve information on an secure connection, a pointer to a
// SecPkgContext_connectionInfo structure (defined in schnlsp.h) must be
// passed in. On success, it is filled with relevent security information.
//

  {$EXTERNALSYM LDAP_OPT_SSL_INFO}
  LDAP_OPT_SSL_INFO           = $93;

//
// Turing on either the sign or the encrypt option prior to binding using
// LDAP_AUTH_NEGOTIATE will result in the ensuing LDAP session to be signed
// or encrypted using either Kerberos or NTLM (as negotiated by the underlying
// security packages). Note that these options can't be used with SSL.
//

  {$EXTERNALSYM LDAP_OPT_SIGN}
  LDAP_OPT_SIGN               = $95;
  {$EXTERNALSYM LDAP_OPT_ENCRYPT}
  LDAP_OPT_ENCRYPT            = $96;

//
// The user can set a preferred SASL method prior to binding using LDAP_AUTH_NEGOTIATE
// We will try to use this mechanism while binding. One example is "GSSAPI".
//

  {$EXTERNALSYM LDAP_OPT_SASL_METHOD}
  LDAP_OPT_SASL_METHOD        = $97;

//
// Setting this option to LDAP_OPT_ON will instruct the library to only perform an
// A-Record DNS lookup on the supplied host string. This option is OFF by default.
//

  {$EXTERNALSYM LDAP_OPT_AREC_EXCLUSIVE}
  LDAP_OPT_AREC_EXCLUSIVE     = $98;

//
// Retrieve the security context associated with the connection.
//

  {$EXTERNALSYM LDAP_OPT_SECURITY_CONTEXT}
  LDAP_OPT_SECURITY_CONTEXT   = $99;


//
//  End of Microsoft only options
//

  {$EXTERNALSYM LDAP_OPT_ON}
  LDAP_OPT_ON                 = Pointer(1);
  {$EXTERNALSYM LDAP_OPT_OFF}
  LDAP_OPT_OFF                = Pointer(0);

//
//  For chasing referrals, we extend this a bit for LDAP_OPT_REFERRALS.  If
//  the value is not LDAP_OPT_ON or LDAP_OPT_OFF, we'll treat them as the
//  following :
//
//  LDAP_CHASE_SUBORDINATE_REFERRALS  : chase subordinate referrals (or
//                                      references) returned in a v3 search
//  LDAP_CHASE_EXTERNAL_REFERRALS : chase external referrals. These are
//                          returned possibly on any operation except bind.
//
//  If you OR these flags together, it's equivalent to setting referrals to
//  LDAP_OPT_ON.
//

  {$EXTERNALSYM LDAP_CHASE_SUBORDINATE_REFERRALS}
  LDAP_CHASE_SUBORDINATE_REFERRALS    = $00000020;
  {$EXTERNALSYM LDAP_CHASE_EXTERNAL_REFERRALS}
  LDAP_CHASE_EXTERNAL_REFERRALS       = $00000040;

//
//  Bind is required as the first operation to v2 servers, not so for v3
//  servers.  See above description of authentication methods.
//


const
  {$EXTERNALSYM LDAP_SCOPE_BASE}
  LDAP_SCOPE_BASE         = $00;
  {$EXTERNALSYM LDAP_SCOPE_ONELEVEL}
  LDAP_SCOPE_ONELEVEL     = $01;
  {$EXTERNALSYM LDAP_SCOPE_SUBTREE}
  LDAP_SCOPE_SUBTREE      = $02;


const
  {$EXTERNALSYM LDAP_MSG_ONE}
  LDAP_MSG_ONE       = 0;
  {$EXTERNALSYM LDAP_MSG_ALL}
  LDAP_MSG_ALL       = 1;
  {$EXTERNALSYM LDAP_MSG_RECEIVED}
  LDAP_MSG_RECEIVED  = 2;

//
//  Get a response from a connection.  One enhancement here is that ld can
//  be null, in which case we'll return responses from any server.  Free
//  responses here with ldap_msgfree.
//
//  For connection-less LDAP, you should pass in both a LDAP connection
//  handle and a msgid.  This will ensure we know which request the app
//  is waiting on a reply to. (we actively resend request until we get
//  a response.)
//

//  A BerElement really maps out to a C++ class object that does BER encoding.
//  Don't mess with it as it's opaque.
//
type
  PBerElement = ^BerElement;
  {$EXTERNALSYM BerElement}
  BerElement = record
    opaque: PChar;      // this is an opaque structure used just for
                        // compatibility with reference implementation
  end;

const
  {$EXTERNALSYM NULLBER}
  NULLBER = PBerElement(nil);

// ADDED ber_free

  {$EXTERNALSYM LBER_USE_DER}
  LBER_USE_DER            = $01;
  {$EXTERNALSYM LBER_USE_INDEFINITE_LEN}
  LBER_USE_INDEFINITE_LEN = $02;
  {$EXTERNALSYM LBER_TRANSLATE_STRINGS}
  LBER_TRANSLATE_STRINGS  = $04;

//
//  Call to initialize the LDAP library.  Pass in a version structure with
//  lv_size set to sizeof(LDAP_VERSION), lv_major set to LAPI_MAJOR_VER1,
//  and lv_minor set to LAPI_MINOR_VER1.  Return value will be either
//  LDAP_SUCCESS if OK or LDAP_OPERATIONS_ERROR if can't be supported.
//

  {$EXTERNALSYM LAPI_MAJOR_VER1}
  LAPI_MAJOR_VER1     = 1;
  {$EXTERNALSYM LAPI_MINOR_VER1}
  LAPI_MINOR_VER1     = 1;

type
  PLDAPVersionInfo = ^TLDAPVersionInfo;
  {$EXTERNALSYM PLDAP_VERSION_INFO}
  PLDAP_VERSION_INFO = ^LDAP_VERSION_INFO;
  {$EXTERNALSYM LDAP_VERSION_INFO}
  LDAP_VERSION_INFO = record
     lv_size: ULONG;
     lv_major: ULONG;
     lv_minor: ULONG;
  end;
  TLDAPVersionInfo = LDAP_VERSION_INFO;


const
  {$EXTERNALSYM LDAP_SERVER_SORT_OID}
  LDAP_SERVER_SORT_OID        = '1.2.840.113556.1.4.473';
  {$EXTERNALSYM LDAP_SERVER_SORT_OID_W}
  LDAP_SERVER_SORT_OID_W      = '1.2.840.113556.1.4.473';

  {$EXTERNALSYM LDAP_SERVER_RESP_SORT_OID}
  LDAP_SERVER_RESP_SORT_OID   = '1.2.840.113556.1.4.474';
  {$EXTERNALSYM LDAP_SERVER_RESP_SORT_OID_W}
  LDAP_SERVER_RESP_SORT_OID_W = '1.2.840.113556.1.4.474';

{
  NOTE from translator: I'm not quite sure about the following
  declaration:

  typedef struct ldapsearch LDAPSearch, *PLDAPSearch;
}

type
// Note from translator:
// The following two types don't have a TLDAPxxx type declared, since they are
// meant as opaque pointer types only, so a TLDAPxxx is not needed.

  {$EXTERNALSYM PLDAPSearch}
  PLDAPSearch = ^LDAPSearch;
  {$EXTERNALSYM LDAPSearch}
  LDAPSearch = record
     Base: PAnsiChar;
     Scope: cardinal;
     Filter: PAnsiChar;
     attrs: PChar;
     NoValues: cardinal;
  end;

  {$EXTERNALSYM PLDAPSortKeyA}
  PLDAPSortKeyA = ^LDAPSortKeyA;
  {$EXTERNALSYM PLDAPSortKeyW}
  PLDAPSortKeyW = ^LDAPSortKeyW;
  {$EXTERNALSYM PLDAPSortKey}
  {$IFDEF UNICODE}
    PLDAPSortKey = PLDAPSortKeyW;
  {$ELSE}
  PLDAPSortKey = PLDAPSortKeyA;
  {$ENDIF}
  {$EXTERNALSYM LDAPSortKeyA}
  LDAPSortKeyA = packed record
    sk_attrtype: PAnsiChar;
    sk_matchruleoid: PAnsiChar;
    sk_reverseorder: ByteBool;
  end;
  {$EXTERNALSYM LDAPSortKeyW}
  LDAPSortKeyW = packed record
    sk_attrtype: PWideChar;
    sk_matchruleoid: PWideChar;
    sk_reverseorder: ByteBool;
  end;
  {$EXTERNALSYM LDAPSortKey}
  {$IFDEF UNICODE}
  LDAPSortKey = LDAPSortKeyW;
  {$ELSE}
  LDAPSortKey = LDAPSortKeyA;
  {$ENDIF}

//
//  This API formats a list of sort keys into a search control.  Call
//  ldap_control_free when you're finished with the control.
//
//  Use this one rather than ldap_encode_sort_control as this is per RFC.
//


const
  {$EXTERNALSYM LDAP_PAGED_RESULT_OID_STRING}
  LDAP_PAGED_RESULT_OID_STRING   = '1.2.840.113556.1.4.319';
  {$EXTERNALSYM LDAP_PAGED_RESULT_OID_STRING_W}
  LDAP_PAGED_RESULT_OID_STRING_W = '1.2.840.113556.1.4.319';



const
  {$EXTERNALSYM LDAP_OPT_REFERRAL_CALLBACK}
  LDAP_OPT_REFERRAL_CALLBACK = $70;

//
//  This first routine is called when we're about to chase a referral.  We
//  callout to it to see if there is already a connection cached that we
//  can use.  If so, the callback routine returns the pointer to the
//  connection to use in ConnectionToUse.  If not, it sets
//  *ConnectionToUse to NULL.
//
//  For a return code, it should return 0 if we should continue to chase the
//  referral.  If it returns a non-zero return code, we'll treat that as the
//  error code for chasing the referral.  This allows caching of host names
//  that are not reachable, if we decide to add that in the future.
//

type
  {$EXTERNALSYM QUERYFORCONNECTION}
  QUERYFORCONNECTION = function(
    PrimaryConnection: PLDAP2;
    ReferralFromConnection: PLDAP2;
    NewDN: PWideChar;
    HostName: PChar;
    PortNumber: ULONG;
    SecAuthIdentity: Pointer;    // if null, use CurrentUser below
    CurrentUserToken: Pointer;   // pointer to current user's LUID
    var ConnectionToUse: PLDAP2):ULONG cdecl;
  TQueryForConnection = QUERYFORCONNECTION;

//
//  This next function is called when we've created a new connection while
//  chasing a referral.  Note that it gets assigned the same callback functions
//  as the PrimaryConnection.  If the return code is FALSE, then the call
//  back function doesn't want to cache the connection and it will be
//  destroyed after the operation is complete.  If TRUE is returned, we'll
//  assume that the callee has taken ownership of the connection and it will
//  not be destroyed after the operation is complete.
//
//  If the ErrorCodeFromBind field is not 0, then the bind operation to
//  that server failed.
//

  {$EXTERNALSYM NOTIFYOFNEWCONNECTION}
  NOTIFYOFNEWCONNECTION = function(
    PrimaryConnection: PLDAP2;
    ReferralFromConnection: PLDAP2;
    NewDN: PWideChar;
    HostName: PChar;
    NewConnection: PLDAP2;
    PortNumber: ULONG;
    SecAuthIdentity: Pointer;    // if null, use CurrentUser below
    CurrentUser: Pointer;        // pointer to current user's LUID
    ErrorCodeFromBind: ULONG): ByteBool cdecl;
  TNotifyOfNewConnection = NOTIFYOFNEWCONNECTION;

//
//  This next function is called when we've successfully called off to the
//  QueryForConnection call and received a connection OR when we called off
//  to the NotifyOfNewConnection call and it returned TRUE.  We call this
//  function when we're dereferencing the connection after we're done with it.
//
//  Return code is currently ignored, but the function should return
//  LDAP_SUCCESS if all went well.
//

 {$EXTERNALSYM DEREFERENCECONNECTION}
 DEREFERENCECONNECTION = function(PrimaryConnection: PLDAP2;
   ConnectionToDereference: PLDAP2): ULONG cdecl;
 TDereferenceConnection = DEREFERENCECONNECTION;

  PLDAPReferralCallback = ^TLDAPReferralCallback;
  {$EXTERNALSYM LdapReferralCallback}
  LdapReferralCallback = packed record
    SizeOfCallbacks: ULONG;        // set to sizeof( LDAP_REFERRAL_CALLBACK )
    QueryForConnection: QUERYFORCONNECTION;
    NotifyRoutine: NOTIFYOFNEWCONNECTION;
    DereferenceRoutine: DEREFERENCECONNECTION;
  end;
  {$EXTERNALSYM LDAP_REFERRAL_CALLBACK}
  LDAP_REFERRAL_CALLBACK = LdapReferralCallback;
  {$EXTERNALSYM PLDAP_REFERRAL_CALLBACK}
  PLDAP_REFERRAL_CALLBACK = ^LdapReferralCallback;
  TLDAPReferralCallback = LdapReferralCallback;

//
//  Thread Safe way to get last error code returned by LDAP API is to call
//  LdapGetLastError();
//


const
  {$EXTERNALSYM LDAP_OPT_CLIENT_CERTIFICATE}
  LDAP_OPT_CLIENT_CERTIFICATE    = $80;

//
// This callback is invoked when the server demands a client certificate for
// authorization. We pass a structure containing a list of server-trusted
// Certificate Authorities. If the client has certificates to provide, it
// converts them to CERT_CONTEXTs and adds them to the given certificate
// store. LDAP subsequently passes these credentials to the SSL server as part
// of the handshake.
//

type
  {$EXTERNALSYM QUERYCLIENTCERT}
  QUERYCLIENTCERT = function(
    Connection: PLDAP2;
    trusted_CAs: Pointer {PSecPkgContext_IssuerListInfoEx};
    hCertStore: LongWord {HCERTSTORE};
    var pcCreds: DWORD
  ): ByteBool cdecl;

//
// We are also giving an opportunity for the client to verify the certificate
// of the server. The client registers a callback which is invoked after the
// secure connection is setup. The server certificate is presented to the
// client who invokes it and decides it it is acceptable. To register this
// callback, simply call ldap_set_option( conn, LDAP_OPT_SERVER_CERTIFICATE, &CertRoutine )
//

const
  {$EXTERNALSYM LDAP_OPT_SERVER_CERTIFICATE}
  LDAP_OPT_SERVER_CERTIFICATE    = $81;

//
// This function is called after the secure connection has been established. The
// certificate of the server is supplied for examination by the client. If the
// client approves it, it returns TRUE else, it returns false and the secure
// connection is torn down.
//

type
  VERIFYSERVERCERT = function(
    Connection: PLDAP2;
    pServerCert: Pointer {PCCERT_CONTEXT}
  ): ByteBool cdecl;



//
//  Given an LDAP message, return the connection pointer where the message
//  came from.  It can return NULL if the connection has already been freed.
//

const
  {$EXTERNALSYM LDAP_OPT_REF_DEREF_CONN_PER_MSG}
  LDAP_OPT_REF_DEREF_CONN_PER_MSG = $94;

  ///LDAPLib = 'wldap32.dll';
  //LDAPLib = 'libldap.so';


  function ldap_explode_dn(dn: string; notypes: ULONG; list: TStringList): boolean; overload;

  function ldap_value_free(vals: PPChar): ULONG;

  function ldap_get_option(ld: TLDAPsend; option: integer; outvalue: pointer): ULONG;

  function ldap_err2string(ld: TLDAPsend;err: ULONG): PChar;

  procedure ldap_memfree(Block: PChar);

  {
  function ldap_first_attribute(ld: TLDAPsend; entry: TLDAPsend;
           var ptr: PBerElement): PChar;
  function ldap_next_attribute(ld: TLDAPsend; entry: TLDAPsend;
           ptr: PBerElement): PChar;

  function ldap_get_values_len(ExternalHandle: TLDAPsend; Message: TLDAPsend;
                    attr: PChar): PPLDAPBerVal;
  }
  function ldap_get_values(ld: TLDAPsend; entry: TLDAPResult; attr: PChar): PPChar;


  function ldap_value_free_len(vals: PPLDAPBerVal): ULONG;

  procedure ber_free(var BerElement: PBerElement; fbuf: Integer);

  function ldap_first_entry(ld: TLDAPsend; res: TLDAPsend): TLDAPResult;

  function ldap_get_dn(ld: TLDAPsend; entry: TLDAPResult): PChar;

  function ldap_next_entry(ld: TLDAPsend; entry: TLDAPResult): TLDAPResult;

  function ldap_msgfree(res: TLDAPsend): ULONG;

  function ldap_search_s(ld: TLDAPsend; base: PChar; scope: ULONG;
           filter, attrs:  PChar; attrsonly: ULONG;
           var res: TLDAPsend): ULONG;

  function ldap_search_init_page(ExternalHandle: TLDAPsend;
           DistinguishedName: PChar; ScopeOfSearch: ULONG; SearchFilter: PChar;
           AttributeList: PChar; AttributesOnly: ULONG;
           var ServerControls, ClientControls: PLDAPControl;
           PageTimeLimit, TotalSizeLimit: ULONG;
           var SortKeys: PLDAPSortKey): PLDAPSearch;

  function LdapGetLastError: ULONG;

  function ldap_get_next_page_s(ExternalHandle: TLDAPsend; SearchHandle: PLDAPSearch;
           var timeout: TLDAPTimeVal; PageSize: ULONG; var TotalCount: ULONG;
           var Res: TLDAPsend): ULONG;

  function ldap_search_abandon_page(SearchBlock: PLDAPSearch): ULONG;

  function ldap_add_s(ld: TLDAPsend; dn: PChar; attrs: TLDAPAttributeList): ULONG;

  //function ldap_modify_s(ld: TLDAPsend; dn: PChar; mods: PLDAPMod): ULONG;
  function ldap_modify_s(ld: TLDAPsend; dn: PChar; ModOp: TLDAPModifyOp; Value: TLDAPAttribute): ULONG;


  function ldap_rename_ext_s(ld: TLDAPSend; dn, NewRDN, NewParent: PChar; DeleteOldRdn: Integer;
                              var ServerControls, ClientControls: PLDAPControl): ULONG;


  function ldap_delete_s(ld: TLDAPsend; dn: PChar): ULONG;


  function ldap_start_tls_s( ExternalHandle: TLDAPsend; ServerReturnValue: PULONG;
                           res: PPLDAPMessage; ServerControls: PPLDAPControl;
                           ClientControls: PPLDAPControl): ULONG;


  function ldap_stop_tls_s( ExternalHandle: TLDAPsend): BOOLEAN;

  function ldap_set_option(ld: TLDAPsend; option: integer; invalue: pointer): ULONG;

  function ldap_sslinit(ld: TLDAPsend; HostName: AnsiString; PortNumber: ULONG; secure: integer): boolean;

  function ldap_init(ld: TLDAPsend;HostName: AnsiString; PortNumber: ULONG): boolean;


  function ldap_bind_s(ld: TLDAPsend; dn, cred: PChar; method: ULONG): ULONG;

  //function ldap_simple_bind_s(ld: PLDAP2; dn, passwd: PChar): ULONG;
  {$EXTERNALSYM ldap_simple_bind_s}
  function ldap_simple_bind_s(ld: TLDAPsend; dn, passwd: PChar): ULONG;
  {
  function ldap_simple_bind_s(
	ld		: PLDAP;
	const dn	: pcchar;
	const passwd	: pcchar;
	); cint; cdecl; external;
   }


  function ldap_unbind_s(ld: TLDAPsend): ULONG;


  procedure SaveLogfile(st: string);

implementation



function ldap_explode_dn(dn: string; notypes: ULONG; list: TStringList): boolean;
begin
  result:=false;
  if length(dn)=0 then exit;
  ExtractStrings([','], [], PChar(dn), list);
  result:= list.count > 0;
end;




function ldap_value_free(vals: PPChar): ULONG;
begin
  //ldap.ldap_value_free_len(@vals);
end;

function ldap_get_option(ld: TLDAPsend; option: integer; outvalue: pointer): ULONG;
begin
  //result:=ldap.ldap_get_option(ld,option, outvalue);
end;


function ldap_err2string(ld: TLDAPsend; err: ULONG): PChar;
begin
  result:=PChar(ld.GetErrorString(err));
end;


procedure ldap_memfree(Block: PChar);
begin

end;

{
function ldap_first_attribute(ld: TLDAPsend; entry: TLDAPsend;
  var ptr: PBerElement): PChar;
begin
  //result:=PChar(ldap.ldap_first_attribute(ld,entry,ptr));
end;


function ldap_next_attribute(ld: TLDAPsend; entry: TLDAPsend;
  ptr: PBerElement): PChar;
begin
  //result:=PChar(ldap.ldap_next_attribute(ld,entry,ptr));
end;

function ldap_get_values_len(ExternalHandle: TLDAPsend; Message: TLDAPsend;
 attr: PChar): PPLDAPBerVal;
begin
  //result:=PPLDAPBerVal(ldap.ldap_get_values_len(ExternalHandle,Message, @attr));
end;
}

function ldap_get_values(ld: TLDAPsend; entry: TLDAPResult; attr: PChar): PPChar;
var
  i: integer;
  LDAPAttr: TLDAPAttribute;
  p: string;
  a: PCharArray;
begin
  result:=nil;
  LDAPAttr:=entry.Attributes.Find(attr);
  if LDAPAttr<> nil then
  begin
    SetLength(a, LDAPAttr.Count+1);
    for i:=0 to LDAPAttr.Count-1 do
    begin
      a[i]:=PChar(LDAPattr[i]);
    end;
    a[LDAPAttr.Count]:=nil;
    result:=@a[0];
  end;
end;


function ldap_value_free_len(vals: PPLDAPBerVal): ULONG;
begin
   //result:=(ldap.ldap_value_free_len(@vals));
end;


procedure ber_free(var BerElement: PBerElement; fbuf: Integer);
begin

end;




function ldap_first_entry(ld: TLDAPsend; res: TLDAPsend): TLDAPResult;
begin
  result:=nil;
  if (ld.SearchResult.Count > 0) and (ld.SearchResult[0].Attributes.Count > 0) then
  begin
    result:=ld.SearchResult.Items[0];
  end;
  //result:=ldap.ldap_first_entry(ld,res);
end;


function ldap_next_entry(ld: TLDAPsend; entry: TLDAPResult): TLDAPResult;
var
  i: integer;
begin
  result:=nil;
  if ld.SearchResult.Count =0 then exit;
  i:=0;
  while i < LD.SearchResult.Count-1 do
  begin
    if ld.SearchResult[i].ObjectName = entry.ObjectName then
    begin
      result:=ld.SearchResult[i+1];
      break;
    end;
    inc(i);
  end;
  //result:=ldap.ldap_next_entry(ld,entry);
end;


function ldap_get_dn(ld: TLDAPsend; entry: TLDAPResult): PChar;
begin
  //result:=PChar(ldap.ldap_get_dn(ld,entry));
end;


function ldap_msgfree(res: TLDAPsend): ULONG;
begin

end;


procedure SaveLogfile(st: string);
var
  FileName: string;
  LogFile: TextFile;
  i: Integer;
begin
  FileName :=  'ldap.log';
  AssignFile(LogFile, FileName);
  try
    if FileExistsUTF8(FileName) { *Converted from FileExists* } then
      Append(LogFile)
    else
      Rewrite(LogFile);
    try
        WriteLn(LogFile, st);
        writeln(LogFile,'========>');
    finally
      CloseFile(LogFile);
    end;
  except
    on E: Exception do
    begin
      ;
    end;
  end;
end;


function ldap_search_s(ld: TLDAPsend; base: PChar; scope: ULONG;
  filter, attrs: PChar; attrsonly: ULONG;
  var res: TLDAPsend): ULONG;
var
  lAttribs : TStringList;
  i        : integer;
begin
  result:=LDAP_OPERATIONS_ERROR;
  lAttribs := TStringList.Create;
  i:=0;
  if attrs<> nil then
  begin
    while PCharArray(attrs)[i] <> nil do
    begin
      lAttribs.Add(PCharArray(attrs)[i]);
      inc(i);
    end;
  end;
  ld.SearchScope:=TLDAPSearchScope(scope);
  ld.Search(base,false,filter,lAttribs);
  res:=nil;
  if ld.SearchResult.Count >0 then
  begin
    res:=ld;
    //SaveLogfile(LDAPResultDump(ld.SearchResult));
  end;
  result := ld.ResultCode;
  lAttribs.Free;
end;


function ldap_search_init_page(ExternalHandle: TLDAPsend;
  DistinguishedName: PChar; ScopeOfSearch: ULONG; SearchFilter: PChar;
  AttributeList: PChar; AttributesOnly: ULONG;
  var ServerControls, ClientControls: PLDAPControl;
  PageTimeLimit, TotalSizeLimit: ULONG;
  var SortKeys: PLDAPSortKey): PLDAPSearch;
var
  t: PLDAPSearch ;
begin
  ExternalHandle.SearchSizeLimit:=TotalSizeLimit;
  ExternalHandle.SearchTimeLimit:=PageTimeLimit;
  //ExternalHandle.SearchPageSize:=0;
  ExternalHandle.SearchCookie:='';
  t:=new(PLDAPSearch);
  t.Base:=DistinguishedName;
  t.Scope:=ScopeOfSearch;
  t.Filter:=SearchFilter;
  t.attrs:=AttributeList;
  t.NoValues:=AttributesOnly;
  result:=t;
end;


function ldap_get_next_page_s(ExternalHandle: TLDAPsend; SearchHandle: PLDAPSearch;
  var timeout: TLDAPTimeVal; PageSize: ULONG; var TotalCount: ULONG;
  var Res: TLDAPsend): ULONG;
begin
  ExternalHandle.SearchPageSize:=PageSize;
  result:=LDAP_NO_RESULTS_RETURNED;
  if TotalCount <> 0 then
  begin
    result:= ldap_search_s(ExternalHandle,SearchHandle.Base,SearchHandle.Scope,SearchHandle.Filter,SearchHandle.attrs,SearchHandle.NoValues,res);
    //SaveLogfile(LDAPResultDump(res.SearchResult));
    TotalCount:=0;
    if ExternalHandle.SearchCookie<>'' then
      inc(TotalCount);
    Res:=ExternalHandle;
  end;
end;


function ldap_search_abandon_page(SearchBlock: PLDAPSearch): ULONG;
begin
  try
    Dispose(SearchBlock);
    result:=LDAP_SUCCESS;
  except
    result:=LDAP_OPERATIONS_ERROR;
  end;
end;



function LdapGetLastError: ULONG;
begin
  result:=LDAP_NOT_SUPPORTED;
end;



function ldap_add_s(ld: TLDAPsend; dn: PChar; attrs: TLDAPAttributeList): ULONG;
begin
  ld.Add(dn,attrs);
  result := ld.ResultCode;
end;


function ldap_modify_s(ld: TLDAPsend; dn: PChar; ModOp: TLDAPModifyOp ; Value: TLDAPAttribute): ULONG;
begin
  ld.Modify(dn, ModOp, Value);
  result := ld.ResultCode;
end;


function ldap_rename_ext_s(ld: TLDAPSend; dn, NewRDN, NewParent: PChar; DeleteOldRdn: Integer;
                            var ServerControls, ClientControls: PLDAPControl): ULONG;
begin
  result:=LDAP_NOT_SUPPORTED;
  if ld.Version>= LDAP_VERSION3 then
  begin
    ld.ModifyDN(dn, newRDN, newParent, DeleteOldRDN=1);
    result := ld.ResultCode;
  end;
end;

function ldap_delete_s(ld: TLDAPsend; dn: PChar): ULONG;
begin
  ld.Delete(dn);
  result := ld.ResultCode;
end;


function ldap_start_tls_s( ExternalHandle: TLDAPsend; ServerReturnValue: PULONG;
                           res: PPLDAPMessage; ServerControls: PPLDAPControl;
                           ClientControls: PPLDAPControl): ULONG;
begin
  ExternalHandle.AutoTLS := true;
  result:=LDAP_SUCCESS;
end;

{
function ldap_start_tls_sA( ExternalHandle: TLDAPsend; ServerReturnValue: PULONG;
                           res: PPLDAPMessage; ServerControls: PPLDAPControl;
                           ClientControls: PPLDAPControl): ULONG;
begin

end;
}

function ldap_stop_tls_s( ExternalHandle: TLDAPsend): BOOLEAN;
begin
  ExternalHandle.AutoTLS := false;
  result:=true;

end;

function ldap_set_option(ld: TLDAPsend; option: integer; invalue: pointer): ULONG;
begin
  //result:=ldap.ldap_set_option(ld, option, invalue);
  case option of
       LDAP_OPT_PROTOCOL_VERSION: ld.version:=Integer(invalue^);
       //LDAP_OPT_ENCRYPT,
       //LDAP_OPT_DEREF,
       //LDAP_OPT_REFERRAL_HOP_LIMIT
       LDAP_OPT_SIZELIMIT:        ld.SearchSizeLimit:=Integer(invalue^);
       LDAP_OPT_TIMELIMIT:        ld.SearchTimeLimit:=Integer(invalue^);
  end;
  result:=LDAP_SUCCESS;
end;


function ldap_sslinit(ld:TLDAPsend; HostName: AnsiString; PortNumber: ULONG; secure: integer): boolean;
begin
  ld.TargetHost:=Hostname;
  ld.TargetPort:=IntToStr(PortNumber);
  ld.FullSSL := true;
  result:=ld.login;
end;


function ldap_init(ld:TLDAPsend; HostName: AnsiString; PortNumber: ULONG): boolean;
begin
  ld.TargetHost:=Hostname;
  ld.TargetPort:=IntToStr(PortNumber);
  result:=ld.login;
end;


function ldap_simple_bind_s(ld: TLDAPsend; dn, passwd: PChar): ULONG;
begin
  result:=LDAP_OPERATIONS_ERROR;
  ld.UserName:=dn;
  ld.Password:=passwd;
  if ld.bind then result:=LDAP_SUCCESS;
end;

//function ldap_simple_bind_s; external LDAPLib name 'ldap_simple_bind_s';

function ldap_bind_s(ld: TLDAPsend; dn, cred: PChar; method: ULONG): ULONG;
begin

end;


function ldap_unbind_s(ld: TLDAPsend): ULONG;
begin

end;


end.

