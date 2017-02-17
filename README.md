LDAP Admin for Linux
===========================

What it is
----------

Linux port of free Windows LDAP Admin (http://ldapadmin.org), client and administration tool for LDAP directory management.

Status
------

Stable functions: 
 * Browsing and editing of LDAP directories
 * Recursive operations on directory trees (copy, move and delete)
 * Schema browsing
 * LDIF export and import
 * Password management (supports crypt, md5, sha, sha-crypt, samba)
 * Template support
 * Binary attribute support
 * LDAP SSL/TLS support
 
Untested functions: 
 * Management of Posix Groups and Accounts
 * Management of Samba Accounts
 * Postfix MTA Support
 

Disabled functions: 
 * Scripting



Requirements
------------
 * Lazarus (FPC) compiler
 * Linux desktop


How to compile
--------------
 * install Lazarus (1.6 or above) from binaries - http://wiki.freepascal.org/Installing_Lazarus
 * get source code Ldap-Admin from https://github.com/ibv/LDAP-Admin
 * in Lazarus IDE, menu - File -> Open -> "/path/to/LdapAdmin.lpi"
 * in Lazarus IDE, menu - Run -> F9 (run) or Ctrl+F9 (compile) or Shift+F9 (link)


Further information
-------------------

For more information about it, please visit:
> http://ivb.sweb.cz/ldap-en.html