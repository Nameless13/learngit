# OpenLDAP使用手册

---
## 创建用户

当前的LDAP服务器部署在dsj-ddp-ad-kdc-01上,管理员先以root登录 到dsj-ddp-ad-kdc-01节点上,为一个新的用户创建一个LDIF文件(其中uid,uidNumber,gidNumber,homeDirectory可以自行定义)
```
#cat adduser.ldif
dn: uid=ldaptest,ou=People,dc=sjad,dc=com
objectClass: account
objectClass: posixAccount
objectClass: top
objectClass: shadowAccount
uid: ldaptest
cn: ldaptest
loginShell: /bin/bash
userPassword: {crypt}x
uidNumber: 2004
gidNumber: 100
homeDirectory: /home/ldaptest
```

使用ladpadd添加用户,终端会提示输入ladpadm密码:
ldapadd -x -W -D "cn=ldapadm,dc=sjad,dc=com" -f adduser.ldif



为ladptest用户设置密码:
ldappasswd -s password123 -W -D "cn=ldapadm,dc=sjad,dc=com" -x
"uid=ldaptest,ou=People,dc=sjad,dc=com"

也可以在开始ldif文件中指定用户密码,根据需要灵活配置

## 创建组
创建一个ldif文件
```
#cat addgroup.ldif
dn: cn=group2,ou=Group,dc=sjad,dc=com
objectClass: posixGroup
objectClass: top
cn: group2
gidNumber: 2345
```

## 使用ldapadd添加组

ldapadd -x -W -D "cn=ldapadm,dc=sjad,dc=com" -f addgroup.ldif


## 把用户添加到组中

把ladptest添加到用户组**group4**中,创建一个LDIF文件
```
#cat u2g.ldif
dn: cn=group4,ou=Group,dc=sjad,dc=com
changetype: modify
add: memberuid
memberuid: ldaptest
```

使用**ladpmodify**将user添加到group
`ldapmodify -x -W -D "cn=ldapadm,dc=sjad,dc=com" -f u2g.ldif`

## 列出当前用户和组
ldapsearch -x

```
[root@dsj-ddp-ad-kdc-01 cn=config]# ldapsearch -x
# extended LDIF
#
# LDAPv3
# base <dc=sjad,dc=com> (default) with scope subtree
# filter: (objectclass=*)
# requesting: ALL
#

# sjad.com
dn: dc=sjad,dc=com
dc: sjad
objectClass: top
objectClass: domain

# ldapadm, sjad.com
dn: cn=ldapadm,dc=sjad,dc=com
objectClass: organizationalRole
cn: ldapadm
description: LDAP Manager

# People, sjad.com
dn: ou=People,dc=sjad,dc=com
objectClass: organizationalUnit
ou: People

# Group, sjad.com
dn: ou=Group,dc=sjad,dc=com
objectClass: organizationalUnit
ou: Group

# ldaptest, People, sjad.com
dn: uid=ldaptest,ou=People,dc=sjad,dc=com
objectClass: top
objectClass: account
objectClass: posixAccount
objectClass: shadowAccount
cn: ldaptest
uid: ldaptest
uidNumber: 9988
gidNumber: 100
homeDirectory: /home/ldaptest
loginShell: /bin/bash
gecos: LDAP Replication Test User
shadowLastChange: 17058
shadowMin: 0
shadowMax: 99999
shadowWarning: 7

# ldaptestgroup, Group, sjad.com
dn: cn=ldaptestgroup,ou=Group,dc=sjad,dc=com
objectClass: posixGroup
objectClass: top
cn: ldaptestgroup
gidNumber: 100
memberUid: ldaptest

# ldaptest1, People, sjad.com
dn: uid=ldaptest1,ou=People,dc=sjad,dc=com
objectClass: top
objectClass: account
objectClass: posixAccount
objectClass: shadowAccount
cn: ldaptest1
uid: ldaptest1
uidNumber: 9989
gidNumber: 101
homeDirectory: /home/ldaptest1
loginShell: /bin/bash
gecos: LDAP Replication Test User
shadowLastChange: 17058
shadowMin: 0
shadowMax: 99999
shadowWarning: 7

# ldaptest2, People, sjad.com
dn: uid=ldaptest2,ou=People,dc=sjad,dc=com
objectClass: top
objectClass: account
objectClass: posixAccount
objectClass: shadowAccount
cn: ldaptest2
uid: ldaptest2
uidNumber: 9990
gidNumber: 1500
homeDirectory: /home/ldaptest2
loginShell: /bin/bash
gecos: LDAP Replication Test User
shadowLastChange: 17058
shadowMin: 0
shadowMax: 99999
shadowWarning: 7

# ldaptestgroup2, Group, sjad.com
dn: cn=ldaptestgroup2,ou=Group,dc=sjad,dc=com
objectClass: posixGroup
objectClass: top
cn: ldaptestgroup
cn: ldaptestgroup2
gidNumber: 1500
memberUid: ldaptest2

# ldaptestgroup3, Group, sjad.com
dn: cn=ldaptestgroup3,ou=Group,dc=sjad,dc=com
objectClass: posixGroup
objectClass: top
cn: ldaptestgroup
cn: ldaptestgroup3
gidNumber: 1501
memberUid: ldaptest2
memberUid: ldaptest

# hadoop, People, sjad.com
dn: uid=hadoop,ou=People,dc=sjad,dc=com
objectClass: top
objectClass: account
objectClass: posixAccount
objectClass: shadowAccount
cn: hadoop
uid: hadoop
uidNumber: 6606
gidNumber: 991
homeDirectory: /home/hadoop
loginShell: /bin/bash
gecos: LDAP Replication Test User
shadowLastChange: 17058
shadowMin: 0
shadowMax: 99999
shadowWarning: 7

# hadoop, Group, sjad.com
dn: cn=hadoop,ou=Group,dc=sjad,dc=com
objectClass: posixGroup
objectClass: top
cn: hadoop
gidNumber: 991
memberUid: hadoop

# addata, People, sjad.com
dn: uid=addata,ou=People,dc=sjad,dc=com
objectClass: top
objectClass: account
objectClass: posixAccount
objectClass: shadowAccount
cn: addata
uid: addata
uidNumber: 1504
gidNumber: 1504
homeDirectory: /home/addata
loginShell: /bin/bash
gecos: LDAP Replication Test User
shadowLastChange: 17058
shadowMin: 0
shadowMax: 99999
shadowWarning: 7

# addata, Group, sjad.com
dn: cn=addata,ou=Group,dc=sjad,dc=com
objectClass: posixGroup
objectClass: top
cn: addata
gidNumber: 1504
memberUid: addata

# search result
search: 2
result: 0 Success

# numResponses: 15
# numEntries: 14
```


FreeIPA 迁移工具**ipa migrate-ds**,有-shema参数,您可以使用它来指定您正在从中迁移的是什么属性 (values are RFC2307 and RFC2307bis)