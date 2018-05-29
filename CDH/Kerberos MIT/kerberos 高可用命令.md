title: kerberos 高可用命令
categories: [CDH,Kerberos MIT]
date: 2018-05-25 15:31:29
---
# kerberos高可用命令
```
sudo vim kpropd.acl

host/dsj-ddp-test-mstr-02@SJTEST.COM
host/dsj-ddp-test-mstr-06@SJTEST.COM

sudo systemctl enable kprop
sudo systemctl start kprop
sudo systemctl status kprop


service kprop start
chkconfig kprop on


sudo kprop -f /var/kerberos/krb5kdc/master.dump -d -P 754 dsj-ddp-test-mstr-06@SJTEST.COM
```

## 同步脚本kprop_sync.sh master节点配置
```
sudo vim kprop_sync.sh
#!/bin/bash
DUMP=/var/kerberos/krb5kdc/master.dump
PORT=754
SLAVE="dsj-ddp-test-mstr-06"
TIMESTAMP=`date`
echo "Start at $TIMESTAMP"
sudo kdb5_utildump $DUMP
sudo kprop -f $DUMP -d -P $PORT $SLAVE
```

## 定时同步配置
```
sudo chmod 700 /var/kerberos/krb5kdc/kprop_sync.sh
sudo sh /var/kerberos/krb5kdc/kprop_sync.sh 

sudo crontab -e
0 * * * * root/var/kerberos/krb5kdc/kprop_sync.sh >/var/kerberos/krb5kdc/lastupdate

sudo systemctl enable crond
sudo systemctl start crond
```