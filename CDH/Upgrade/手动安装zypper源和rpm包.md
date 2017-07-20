title: 手动安装zypper源和rpm包
categories: [CDH,Upgrade]
date: 2017-05-24
---
因大数据cloudera manager 平台升级,请将所有大数据服务器安装python-psycopg2-2.6.2-3.3.x86_64.rpm这个包,大数据服务器列表见附件



CM前端管理方式安装CDH失败:

1. 主机密码不对
2. 先手工卸载旧rpm包,手工配zypper源安装
3. zypper源指向不对,删除无效的zypper源
4. 用户目录下的host影响,或者/etc/hosts和CM节点不一致


Usage: 本地Zypper源使用 [适用SUSE]

1. Backup repository.
find /etc/zypp/repos.d -name "*.repo" -exec mv {} {}.bak \;
2. Install
zypper ar http://10.200.58.43/ local.main
3. Update cache
zypper ref

zyppzy


ps aux|grep  supervisord |grep -v grep | awk '{print "kill -9 "$2}'|sh

zypper in cloudera-manager-daemons-5.11.1-1.cm5111.p0.9.sles11
zypper in cloudera-manager-agent-5.11.1-1.cm5111.p0.9.sles11
下载地址:https://software.opensuse.org/download.html?project=server%3Adatabase%3Apostgresql&package=python-psycopg2

如果安装时报出缺少   libpq.so.5()(64bit) 依赖,需要先安装系统ISO镜像自带的postgresql91-9.1.9-0.3.1.x86_64.rpm（需要用到此包中的libpq库）,之后再安装python-psycopg2-2.6.2-3.3.x86_64.rpm

```
zypper in postgresql91
rpm -ivh python-psycopg2-2.6.2-3.2.x86_64.rpm
```




----
[Zookeeper 绕过密码注册超级管理员](http://stackoverflow.com/questions/35544155/how-to-access-a-zookeeper-ensemble-as-a-super-user-via-zookeeper-shell/35654757#35654757)

SERVER_JVMFLAGS=-Dzookeeper.DigestAuthenticationProvider.superDigest=super:DyNYQEQvajljsxlhf5uS4PJ9R28=

http://www.tuicool.com/articles/neY7Vrq


suse http zypper源 http
apache2
分发服务器
/srv/www/
HA namenode snamenode
zypper 源配置 添加http源 ar 指定源名字

/mnt/suse/x86_64/postgresql91-9.1.24-1.1.x86_64.rpm

http://ftp.rrzn.uni-hannover.de/opensuse/repositories/server:/database:/postgresql/SLE_11_SP3/x86_64/?winzoom=1

sudo /usr/sbin/groupadd manage

manage@ddp-dn-101:/home> sudo chown manage:manage manage/


`zypper ar http://10.200.58.43/ local.main`

`sudo zypper mr -d "SUSE-Linux-Enterprise-Server-11-SP3 11.3.3-1.138"`
Repository 'SUSE-Linux-Enterprise-Server-11-SP3 11.3.3-1.138' has been successfully disabled.
`sudo zypper ref`

sudo zypper in postgresql91
sudo rpm -ivh python-psycopg2-2.6.2-3.2.x86_64.rpm





密码不对

先手工卸载旧rpm包

host mv usr
 

/etc/hosts 没配