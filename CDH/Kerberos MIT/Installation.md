title: Installation
categories: 
- CDH
- Kerberos MIT
date: 2017-05-24
---

## 初始化
```
➜  ~ kdb5_util create -s
Loading random data
Initializing database '/var/kerberos/krb5kdc/principal' for realm 'EXAMPLE.COM',
master key name 'K/M@EXAMPLE.COM'
You will be prompted for the database Master Password.
It is important that you NOT FORGET this password.
Enter KDC database master key: 
Re-enter KDC database master key to verify: 
```

This will create five files in LOCALSTATEDIR/krb5kdc (or at the locations specified in kdc.conf):

- two Kerberos database files, principal, and principal.ok
- the Kerberos administrative database file, principal.kadm5
- the administrative database lock file, principal.kadm5.lock
- the stash file, in this example .k5.ATHENA.MIT.EDU. If you do not want a stash file, run the above command without the -s option.

## krb5.conf
cat /etc/krb5.conf
```
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
}

[domain_realm]
.cmdmp.com = CMDMP.COM
cmdmp.com = CMDMP.COM

[logging]
    kdc = FILE:/var/log/krb5/krb5kdc.log
    admin_server = FILE:/var/log/krb5/kadmind.log
    default = SYSLOG:NOTICE:DAEMON

```

## kdc.conf
cat /var/lib/kerberos/krb5kdc/kdc.conf
```
[kdcdefaults]
        kdc_ports = 750,88
        kdc_tcp_ports = 750,88

[realms]
#       EXAMPLE.COM = {
#               database_name = /var/lib/kerberos/krb5kdc/principal
#               admin_keytab = FILE:/var/lib/kerberos/krb5kdc/kadm5.keytab
#               acl_file = /var/lib/kerberos/krb5kdc/kadm5.acl
#               dict_file = /var/lib/kerberos/krb5kdc/kadm5.dict
#               key_stash_file = /var/lib/kerberos/krb5kdc/.k5.EXAMPLE.COM
#               kdc_ports = 750,88
#               max_life = 10h 0m 0s
#               max_renewable_life = 7d 0h 0m 0s
#       }
 CMDMP.COM = {
  max_renewable_life = 7d 0h 0m 0s
  database_name = /var/lib/kerberos/krb5kdc/principal
  acl_file = /var/lib/kerberos/krb5kdc/kadm5.acl
  dict_file = /var/lib/kerberos/krb5kdc/kadm5.dict
  admin_keytab = /var/lib/kerberos/krb5kdc/kadm5.keytab
  supported_enctypes = aes256-cts:normal aes128-cts:normal des3-hmac-sha1:normal arcfour-hmac:normal des-hmac-sha1:normal dex-cbc-md5:normal des-cbc-crc:normal
}

[logging]
    kdc = FILE:/var/log/krb5/krb5kdc.log
    admin_server = FILE:/var/log/krb5/kadmind.log
```
