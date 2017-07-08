title: Hive Metastore Server 僵死
categories: 
- CDH
- Hive
date: 2017-06-23
---
# Hive Metastore Server 僵死
现状: 在Hive Metastore Server上的角色只要停止服务,就无法再启动

开头怀疑是cloudera-scm-agent 出问题
```
877  2017-05-24 15:50:05 /etc/init.d/cloudera-scm-agent stop
878  2017-05-24 15:50:15 ss -anp|grep 9000
879  2017-05-24 15:50:39 ps axu|grep agent
880  2017-05-24 15:51:08 ss -anp|grep 9000
881  2017-05-24 15:51:18 /etc/init.d/cloudera-scm-agent start
882  2017-05-24 15:51:27 /etc/init.d/cloudera-scm-agent status
883  2017-05-24 15:51:51 ss -anp|grep 9000
884  2017-05-24 15:55:14 cd /var/log/
```
重启后发现依旧

于是怀疑IO问题
```
891  2017-05-24 16:04:03 ulimit -a
892  2017-05-24 16:04:55 cat /etc/passwd

896  2017-05-24 16:07:10 vi /etc/security/limits.conf 
897  2017-05-24 16:08:14 ulimit -a
898  2017-05-24 16:09:38 lsof -n |awk '{print $2}'|sort|uniq -c |sort -nr|more
```
之后reboot解决

```
#ftp             hard    nproc           0
#@student        -       maxlogins       4

*                soft    nofile          65535
*                hard    nofile          65535
```