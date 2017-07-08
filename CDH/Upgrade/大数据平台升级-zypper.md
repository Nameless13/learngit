title: 大数据平台升级-zypper
categories: 
- CDH
- Upgrade
date: 2017-05-24
---

sudo /usr/sbin/groupadd manage

manage@ddp-dn-101:/home> sudo chown manage:manage manage/


zypper ar http://10.200.58.43/ local.main

sudo zypper mr -d "SUSE-Linux-Enterprise-Server-11-SP3 11.3.3-1.138"
Repository 'SUSE-Linux-Enterprise-Server-11-SP3 11.3.3-1.138' has been successfully disabled.
manage@ddp-storm-09:~> sudo zypper ref

sudo zypper in postgresql91
sudo rpm -ivh python-psycopg2-2.6.2-3.2.x86_64.rpm