title: kerberos迁移以及问题汇总
categories: [CDH,Kerberos MIT]
date: 2017-11-24
---

```bash
ddp-dn-01:~/hct # cat /etc/krb5.conf 
[libdefaults]
#       default_realm = EXAMPLE.COM 
default_realm = CMDMP.COM
dns_lookup_realm = false
dns_lookup_kdc = false
ticket_lifetime = 24h
renew_lifetime = 7d
forwardable = true
default_tkt_enctypes = arcfour-hmac-md5
default_tgs_enctypes = arcfour-hmac-md5

[realms]
#       EXAMPLE.COM = {
#                kdc = kerberos.example.com
#               admin_server = kerberos.example.com
#       }
CMDMP.COM = {
  kdc = ddp-nn-02.cmdmp.com
  admin_server = ddp-nn-02.cmdmp.com
  kdc = ddp-dn-07.cmdmp.com
  admin_server = ddp-dn-07.cmdmp.com

}

[domain_realm]
.cmdmp.com = CMDMP.COM
cmdmp.com = CMDMP.COM

[logging]
    kdc = FILE:/var/log/krb5/krb5kdc.log
    admin_server = FILE:/var/log/krb5/kadmind.log
    default = SYSLOG:NOTICE:DAEMON
```




------------

```
ddp-dn-07:~ # kadmin.local 
Authenticating as principal host/admin@CMDMP.COM with password.
kadmin.local:  addprinc -randkey krbtgt/SJTEST.COM@CMDMP.COM
WARNING: no policy specified for krbtgt/SJTEST.COM@CMDMP.COM; defaulting to no policy
Principal "krbtgt/SJTEST.COM@CMDMP.COM" created.
kadmin.local:  addprinc -randkey krbtgt/CMDMP.COM@SJTEST.COM
WARNING: no policy specified for krbtgt/CMDMP.COM@SJTEST.COM; defaulting to no policy
add_principal: No such entry in the database while randomizing key for "krbtgt/CMDMP.COM@SJTEST.COM".




Restarting cloudera-scm-server (via systemctl):            [  OK  ]
[root@dsj-ddp-test-cm-01 ~]# ssh 10.151.164.41
Last login: Tue Jan 16 14:28:49 2018
[root@dsj-ddp-test-mstr-02 ~]# 
[root@dsj-ddp-test-mstr-02 ~]# 
[root@dsj-ddp-test-mstr-02 ~]# 
[root@dsj-ddp-test-mstr-02 ~]# kadmin.local 
Authenticating as principal hdfs/admin@SJTEST.COM with password.
kadmin.local:  addprinc -randkey krbtgt/SJTEST.COM@CMDMP.COM
WARNING: no policy specified for krbtgt/SJTEST.COM@CMDMP.COM; defaulting to no policy
Principal "krbtgt/SJTEST.COM@CMDMP.COM" created.
kadmin.local:  addprinc -randkey krbtgt/CMDMP.COM@SJTEST.COM
WARNING: no policy specified for krbtgt/CMDMP.COM@SJTEST.COM; defaulting to no policy
Principal "krbtgt/CMDMP.COM@SJTEST.COM" created.
```


-------------
```bash
[libdefaults]
default_realm = CMDMP.COM
dns_lookup_realm = false
dns_lookup_kdc = false
ticket_lifetime = 24h
renew_lifetime = 7d
forwardable = true
default_tkt_enctypes = arcfour-hmac-md5
default_tgs_enctypes = arcfour-hmac-md5

[realms]
CMDMP.COM = {
  kdc = ddp-nn-02.cmdmp.com
  admin_server = ddp-nn-02.cmdmp.com
  kdc = ddp-dn-07.cmdmp.com
  admin_server = ddp-dn-07.cmdmp.com
}
SJTEST.COM = {
kdc = dsj-ddp-test-mstr-02
admin_server = dsj-ddp-test-mstr-02
}

[domain_realm]
.cmdmp.com = CMDMP.COM
cmdmp.com = CMDMP.COM
.sjtest.com = SJTEST.COM
sjtest.com = SJTEST.COM

[logging]
    kdc = FILE:/var/log/krb5/krb5kdc.log
    admin_server = FILE:/var/log/krb5/kadmind.log
    default = SYSLOG:NOTICE:DAEMON
```

------------
```
[libdefaults]
default_realm = SJTEST.COM
dns_lookup_kdc = false
dns_lookup_realm = false
ticket_lifetime = 86400
renew_lifetime = 604800
forwardable = true
udp_preference_limit = 1
kdc_timeout = 3000
[realms]
SJTEST.COM = {
kdc = dsj-ddp-test-mstr-02
admin_server = dsj-ddp-test-mstr-02
kdc = dsj-ddp-test-mstr-06
admin_server = dsj-ddp-test-mstr-06
}
CMDMP.COM = {
  kdc = ddp-nn-02.cmdmp.com
  admin_server = ddp-nn-02.cmdmp.com
  kdc = ddp-dn-07.cmdmp.com
  admin_server = ddp-dn-07.cmdmp.com
}


[domain_realm]
.sjtest.com = SJTEST.COM
sjtest.com = SJTEST.COM
.cmdmp.com = CMDMP.COM
cmdmp.com = CMDMP.COM


[logging]
    kdc = FILE:/var/log/krb5/krb5kdc.log
    admin_server = FILE:/var/log/krb5/kadmind.log
```


-----
cm HDFS上也需要配置trust realm


krb5.conf 中kdc顺序有问题


---
````
Couldn't renew kerberos ticket in order to work around Kerberos 1.8.1 issue. Please check that the ticket for 'hue/dsj-ddp-test-mstr-05@SJTEST.COM' is still renewable:
  $ klist -f -c /tmp/hue_krb5_ccache
If the 'renew until' date is the same as the 'valid starting' date, the ticket cannot be renewed. Please check your KDC configuration, and the ticket renewal policy (maxrenewlife) for the 'hue/dsj-ddp-test-mstr-05@SJTEST.COM' and `krbtgt' principals.
````

krbtgt 问题

`modprinc -maxrenewlife 1week krbtgt/CMDMP.COM@CMDMP.COM`
`krbtgt/CMDMP.COM@CMDMP.COM`

解决Kerberos Kadmin链接问题
配置文件只能配置一个kadmin 可以多个kdc