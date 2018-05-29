title: 从zypper源手动安装CDH,以及所缺rpm包
categories: [CDH,Upgrade]
date: 2017-05-24
---
# 手动安装CDH
因CDH平台升级,有部分节点发现通过cm批量安装失败,且新版本需要将安装python-psycopg2-2.6.2-3.3.x86_64.rpm这个包

>操作系统:SUSE11 SP3
>CM版本:CM5.10.0
>CDH版本:CDH5.10.1
>使用root用户对集群进行部署

## CM前端管理方式安装CDH失败:
1. 主机密码不对
2. 先手工卸载旧rpm包,手工配zypper源安装
    如果安装时报出缺少`libpq.so.5()(64bit)`依赖,需要先安装系统ISO镜像自带的postgresql91-9.1.9-0.3.1.x86_64.rpm（需要用到此包中的libpq库）,之后再安装python-psycopg2-2.6.2-3.3.x86_64.rpm
    ```
    zypper in postgresql91
    rpm -ivh python-psycopg2-2.6.2-3.2.x86_64.rpm
    ```
    [下载地址1](https://software.opensuse.org/download.html?project=server%3Adatabase%3Apostgresql&package=python-psycopg2)
    [下载地址2](http://ftp.rrzn.uni-hannover.de/opensuse/repositories/server:/database:/postgresql/SLE_11_SP3/x86_64/?winzoom=1)
3. zypper源指向不对,删除无效的zypper源
    1. Backup repository.
    `find /etc/zypp/repos.d -name "*.repo" -exec mv {} {}.bak \;`
    2. Change
    `sudo zypper mr -d "SUSE-Linux-Enterprise-Server-11-SP3 11.3.3-1.138"`
    `zypper ar http://10.200.58.43/ local.main`
    3. Update cache
    `zypper ref`

先手工卸载旧rpm包

4. hostd影响,
    ```
    /etc/hosts和CM节点不一致
    mv /usr/bin/host /usr/bin/host.bak
    ```
5. supervisord进程未停止
    `ps aux|grep  supervisord |grep -v grep | awk '{print "kill -9 "$2}'|sh`

    zypper in cloudera-manager-daemons-5.11.1-1.cm5111.p0.9.sles11
    zypper in cloudera-manager-agent-5.11.1-1.cm5111.p0.9.sles11


----
## Zookeeper提权
[Zookeeper 绕过密码注册超级管理员](http://stackoverflow.com/questions/35544155/how-to-access-a-zookeeper-ensemble-as-a-super-user-via-zookeeper-shell/35654757#35654757)

cm中 **Zookeeper Server 的 Java 配置选项**
`SERVER_JVMFLAGS=-Dzookeeper.DigestAuthenticationProvider.superDigest=super:DyNYQEQvajljsxlhf5uS4PJ9R28=`

http://www.tuicool.com/articles/neY7Vrq








