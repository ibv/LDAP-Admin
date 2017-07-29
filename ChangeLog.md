* Sat Jul 29 2017 Ivo <ivo.brhel at gmail.com>
---------------------
+ fixed drawing templates for Lazarus version > 1.7
+ fixed .lpi file for publish clean project
+ fixed deprecated utf8 file utils (fpc version > 3.0)
+ prepare for new .lrj resource file


* Thu Apr 20 2017 Ivo <ivo.brhel at gmail.com>
---------------------
+ Version 1.8.2
+ Add reset to menus
+ Fixed deleting of attributes and values in TDBConnection
+ Multivalue template checkbox
+ Fixed Edit popup to use Schema info to determine read only status


* Sun Mar 5 2017 Ivo <ivo.brhel at gmail.com>
---------------------
+ Fixed MessageDlg
+ Confirm rename entry


* Fri Mar 3 2017 Ivo <ivo.brhel at gmail.com>
---------------------
+ Add function ldap_bind_s, DIGEST-MD5 SASL method
+ Fixed templates sizeX,Y


* Wed Mar 1 2017 Ivo <ivo.brhel at gmail.com>
---------------------
+ Add function ldap_get_dn


* Thu Feb 23 2017 Ivo <ivo.brhel at gmail.com>
---------------------
+ Add ldap_rename_ext_s function [LDAPClasses.pas]
+ Fixed ConvertVariant function [Templates.pas]


* Tue Feb 21 2017 Ivo <ivo.brhel at gmail.com>
---------------------
+ Fixed export nested list, ConnList form
+ Fixed ldap_stop_tls_s


* Fri Feb 17 2017 Ivo <ivo.brhel at gmail.com>
---------------------
+ Add LDAP SSL/TLS support from synapse library


* Mon Feb 13 2017 Ivo <ivo.brhel at gmail.com>
---------------------
+ Adapt changes from Tihomir's SourceForge git, win version 1.7.2.0
+ New storage type 
+ Fixed template changes
+ Fixed ConnList dialog


* Wed Feb 8 2017 Ivo <ivo.brhel at gmail.com>
---------------------
+ Fixed doubleclik error on ConnList Form, ConnListFrm: Can not focus


* Thu Jan 5 2017 Ivo <ivo.brhel at gmail.com>
---------------------
+ Fixed binary attribute


* Wed Jan 4 2017 Ivo <ivo.brhel at gmail.com>
---------------------
+ Fixed export form
+ Fixed function  IsText, Attribute.fDataType
+ Adapt changes from win version 1.7.2.0


* Sat Sep 6 2016 Ivo <ivo.brhel at gmail.com>
---------------------
+ Convert *.pas file LF to CRLF


* Fri Sep 5 2016 Ivo <ivo.brhel at gmail.com>
---------------------
+ Fixed drawing templates


* Tue Jul 26 2016 Ivo <ivo.brhel at gmail.com>
---------------------
+ Adapt changes from Tihomir's SourceForge git


* Thu Jul 21 2016 Ivo <ivo.brhel at gmail.com>
---------------------
+ Fixed display the contents lang files


* Wed Jul 20 2016  Ivo <ivo.brhel at gmail.com>
---------------------
+ Fixed BinView 2-byte chars


* Fri Jul 15 2016 Ivo <ivo.brhel at gmail.com>
---------------------
+ Fixed Drag&Drop in LdapTree
+ Fixed TreeDropTarget in Lazarus source
  http://forum.lazarus.freepascal.org/index.php?topic=30263.0 
  see DragDrop.info


* Wed Jul 13 2016 Ivo <ivo.brhel at gmail.com>
---------------------
+ Fixed drawing Items in ValueListView


* Tue Jul 12 2016 Ivo <ivo.brhel at gmail.com>
---------------------
+ Fixed BinView


* Mon Jul 11 2016 Ivo <ivo.brhel at gmail.com>
---------------------
+ Fixed Add/Del/Modify attibute in EditEntry Form
+ Fixed add new entry
+ Clean uses in interface units

* Thu Jul 07 2016 Ivo <ivo.brhel at gmail.com>
---------------------
+ Adapt windows version 1.7 to linux
+ Fixed EditEntry Form


* Wed May 08 2016 Ivo <ivo.brhel at gmail.com> 
---------------------
+ Fixed copy/move LDAP entry


* Mon Jun 06 2016 Ivo <ivo.brhel at gmail.com> 
---------------------
+ Add functions ldap_get_values


* Sun May 29 2016 Ivo <ivo.brhel at gmail.com> 
---------------------
+ Enable basic multilang support in main form


* Sat May 28 2016 Ivo <ivo.brhel at gmail.com> 
---------------------
+ Add basic multi lang support


* Tue May 17 2016 Ivo <ivo.brhel at gmail.com> 
---------------------
+ Add LdapAdmin.res
+ Modify .gitignore


* Mon May 16 2016 Ivo <ivo.brhel at gmail.com> 
---------------------
+ First commit 
+ Windows release 1.6.0
