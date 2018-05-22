OpenLDAP is a decent product, but it's really just a bare-bones LDAP server, and something you might integrate into a more complete product or service. For example, even the schemas that it ships with have not changed in a long time and would need to be augmented with at least rfc2307bis. It also doesn't ship with any management tools. Apache Directory Studio is decent, but quite low-level.

Active Directory is a suite of services that include LDAP and some schemas, but also a Kerberos service, a certificate authority, and a DNS service. The (Windows based) AD user and group management tools are OK, and slightly more convenient than Apache Directory Studio, although they only run on Windows. The integration between everything is very good. Binding Linux machines to AD is pretty simple these days with sssd.

Samba 4 is the open source implementation of Active Directory, and is what Amazon use to power their Active Directory compatible Simple AD service.

FreeIPA is an open source alternative to AD that combines LDAP, Kerberos, CA services and management tools, and ships with its own schemas.

To echo other commenters, if most of your users are running Windows, I would recommend deploying Active Directory or Samba 4, and look into binding your Linux machines to it with SSSD.

(Migration from openldap to freeipa.)[https://www.reddit.com/r/linuxadmin/comments/7979e3/migration_from_openldap_to_freeipa/]

`ldapsearch -Z -h oldldap.company.com -D "uid=admin,ou=people,DC=company,DC=com" -W -b "dc=company,dc=com" > /tmp/ldapdump`