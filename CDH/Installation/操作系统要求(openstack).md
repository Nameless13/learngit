title: 操作系统要求(openstack)
categories: [CDH,Installation]
date: 2018-05-23 09:57:35
---
# 资源池环境搭建
>何常通 

## 操作系统配置准备
1. 建议对操作系统盘做RAID1[无法满足]

2. 需要配置OS的repository，以便yum可以访问OS镜像[需要 createrepo httpd postgresql91 python-psycopg2 ]
	```
	Usage: Local YUM  [Adept for RHEL/CentOS]

	1. Backup repository. 
	find /etc/yum.repos.d/ -name "*.repo" -exec mv {} {}.bak \; 

	2. Install 
	For CentOS6/RHEL6: rpm -ivh --force --nodeps http://10.200.40.49/pub/centos-release-el6.noarch.rpm
	For CentOS7/RHEL7: rpm -ivh --force --nodeps http://10.200.40.49/pub/centos-release-el7.noarch.rpm

	3. Update cache 
	yum clean all
	yum makecache


	# Description

	系统安全加固:     curl -s http://10.200.40.49/pub/install | bash 
	SA安装:   curl -s http://10.200.40.49/pub/sa | bash 
	YUM源配置:     curl -s http://10.200.40.49/pub/yum | bash 
	OpenSSH升级:  curl -s http://10.200.40.49/pub/ssh7.5 | bash 
	```

3. 配置静态IP地址[无法满足,DHCP]

4. 需要所有主机/etc/hosts内容一致确保静态DNS解析[相互包含]
	由于hostname会
	hostname规范 
	```
	nm-1   10.150.4.88     10.151.0.185    mysql,hive metastore
	nm-2   10.150.4.96     10.151.0.193    mysql,hive metastore
	nm-3   10.150.4.97     10.151.0.194    [namenode,failover controller,HttpFS,JobHistory Server],ResourceManager
	nm-4   10.150.4.98     10.151.0.195    [namenode,failover controller,HttpFS],ResourceManager
	nm-5   10.150.4.90     10.151.0.187    spark1 history server,(NodeManager)
	nm-6   10.150.4.92     10.151.0.189    impala catalog server,impala statestore,(NodeManager)
	nm-7   10.150.4.89     10.151.0.186    [hue,kerberos ticket renewer],sqoop,ooize,hiveserver2
	nm-8   10.150.4.95     10.151.0.192    spark2 history server,(NodeManager)
	nm-9   10.150.4.94     10.151.0.191    [DataNode],(NodeManager,impala deamon)
	nm-10  10.150.4.93     10.151.0.190    [DataNode],(NodeManager,impala deamon)
	nm-11  10.150.4.86     10.151.0.183    [DataNode],(NodeManager,impala deamon)
	zk-1   10.150.4.85     10.151.0.182    Zookeeper,kerberos server,(NodeManager)
	zk-2   10.150.4.84     10.151.0.181    Zookeeper,kerberos server,(NodeManager) 
	zk-3   10.150.4.83     10.151.0.180    Zookeeper,(NodeManager)
	sj-cm  10.150.4.81     10.151.0.147    cm,sentry,haproxy,(NodeManager)
	```

4. 需要使用root用户 或者无密码使用sudo权限的其他用户[uid必须保持一致]

5. 关闭并禁用iptables[无需操作]
	提供的KVM Centos7 的镜像源默认没有开启防火墙

6. 关闭SELinux
	`echo "SELINUX=disabled" > /etc/sysconfig/selinux;`

7.	重启网络服务，并初始化网络[无需操作]
	由于网络由openstack那边配好所以不需要	`/etc/init.d/network restart`

8.	修改transparent_hugepage参数，这一参数默认值可能会导致CDH性能下降
	`echo never > /sys/kernel/mm/transparent_hugepage/enabled`
	`echo never > /sys/kernel/mm/transparent_hugepage/defrag`
	同时确保开机自动关闭transparent_hugepage
	`vi /etc/rc.d/rc.local`

	```
	#!/bin/bash
	# THIS FILE IS ADDED FOR COMPATIBILITY PURPOSES
	#
	# It is highly advisable to create own systemd services or udev rules
	# to run scripts during boot instead of using this file.
	#
	# In contrast to previous versions due to parallel execution during boot
	# this script will NOT be run after all other services.
	#
	# Please note that you must run 'chmod +x /etc/rc.d/rc.local' to ensure
	# that this script will be executed during boot.

	touch /var/lock/subsys/local

	if test -f /sys/kernel/mm/transparent_hugepage/enabled; then
	echo never > /sys/kernel/mm/transparent_hugepage/enabled
	fi
	if test -f /sys/kernel/mm/transparent_hugepage/defrag; then
	echo never > /sys/kernel/mm/transparent_hugepage/defrag
	fi
	```

	最后给rc.local赋予执行权限 `chmod +x /etc/rc.d/rc.local`

9.  禁用交换内存
	`vi /etc/sysctl.conf`
	增加一行：vm.swappiness=0
	`sudo sysctl vm.swappiness=0`
	```
	echo 0 >/proc/sys/vm/swappiness
	echo 'vm.swappiness=0'>> /etc/sysctl.conf
	cat /proc/sys/vm/swappiness
	```

10. 修改/etc/security/limits.conf或者在/etc/security/limits.d下增加相应的配置文件 
	```
	* soft noproc 11000
	* hard noproc 11000
	* soft nofile 65535
	* hard nofile 65535
	```
11. 需要统一开启ntp服务,并且开机启动
	在集群中选择一台机器作为ntp服务器，剩余的作为ntp客户端。所有客户端时间与ntp服务器保持同步。
	`vi /etc/ntp.conf` 
	ntp同步ip地址和鹏博士的保持一致:
	server 64.113.32.5
	server 216.229.0.179

	systemctl start ntpd.service
	systemctl enable ntpd.service

	[root@nm-2 ~]# ntpq -p
	     remote           refid      st t when poll reach   delay   offset  jitter
	==============================================================================
	 nist.netservice .ACTS.           1 u    7   64    1  238.736   -7.477   0.000 
	 nist1-lnk.binar .ACTS.           1 u    6   64    1  234.281   -6.177   0.000

	systemctl disable chronyd 会影响ntp服务的开机启动所以禁用掉了


12. 同时配置spark2.2需要java8环境+特定的jce包
	JAVA_HOME=/usr/java/jdk1.8.0_144/
	创建JDBC存放目录`mkdir -p /usr/share/java/`
	同时替换为cdh的jce

13. 配置路由连通鹏博士IDC以及Ceph的RGW
	route add -net 10.200.0.0/16 gw 10.151.0.1
	route add -net 10.125.137.0/24 gw 10.151.0.1
	(删除路由 route del -net 10.125.137.0/24 gw 10.150.4.1
	显示路由 netstat -rn)	

14. disable ipv6,同时需要配置4个网卡
	ifcfg-eth1、ifcfg-ens5、ifcfg-ens6，这几个文件的内容与ifcfg-eth0一样，只是里面的device名字不同，取-后面的

15. RHEL 7 & CentOS 7禁用IPV6
	http://blog.csdn.net/bluishglc/article/details/41390785

16. 准备jdbc连接mysql的jar包
[root@sj-cm ~]# scp /usr/share/java/mysql-connector-java-5.1.38-bin.jar 10.150.4.89:/usr/share/java/
[root@nm-7 ~]# mkdir /usr/share/java
[root@nm-7 ~]# ln -s /usr/share/java/mysql-connector-java-5.1.38-bin.jar /usr/share/java/mysql-connector-java.jar

17. 检查文件完整性
	```
	[root@cm cdh5.13]# ll
	total 1889332
	-rw-r--r-- 1 root root 1934590563 Oct 18 16:13 CDH-5.13.0-1.cdh5.13.0.p0.29-el7.parcel
	-rw-r--r-- 1 root root         41 Oct 18 16:13 CDH-5.13.0-1.cdh5.13.0.p0.29-el7.parcel.sha1
	-rw-r--r-- 1 root root      74072 Oct 18 16:13 manifest.json
	[root@cm cdh5.13]# sha1sum CDH-5.13.0-1.cdh5.13.0.p0.29-el7.parcel
	bef6f3f074e0a88cd79d6d37abc6698471e3d279  CDH-5.13.0-1.cdh5.13.0.p0.29-el7.parcel
	[root@cm cdh5.13]# cat CDH-5.13.0-1.cdh5.13.0.p0.29-el7.parcel.sha1 
	bef6f3f074e0a88cd79d6d37abc6698471e3d279
	```

18. route配置
	```
	[root@tddp-zk-2 ~]# route
	Kernel IP routing table
	Destination     Gateway         Genmask         Flags Metric Ref    Use Iface
	default         host-10-150-4-1 0.0.0.0         UG    0      0        0 eth1
	10.125.137.0    .               255.255.255.0   UG    0      0        0 ens6
	10.150.4.0      0.0.0.0         255.255.255.0   U     0      0        0 eth1
	10.151.0.0      0.0.0.0         255.255.252.0   U     0      0        0 ens6
	10.200.0.0      .               255.255.0.0     UG    0      0        0 ens6
	169.254.169.254 host-10-150-4-4 255.255.255.255 UGH   0      0        0 eth1

	```

### 节点配置

CPU	8
Memory	64GB
Disk	100G
Network	2*10Gbits，主备模式绑定

----
## mysql 主从配置
yum install -y wget
wget http://repo.mysql.com/mysql-community-release-el7-5.noarch.rpm
sudo rpm -ivh mysql-community-release-el7-5.noarch.rpm
yum -y update
sudo yum install -y mysql-server
sudo systemctl start mysqld
sudo /usr/bin/mysql_secure_installation

```
CREATE USER 'hive'@'%' IDENTIFIED BY 'Cloudera@123';
create database metastore_test default character set utf8;
GRANT ALL PRIVILEGES ON metastore_test. * TO 'hive'@'%';

create user 'amon'@'%' identified by 'Cloudera@123'
create database amon_test default character set utf8;
grant all privileges on amon_test.* to 'amon'@'%';

create user 'rman'@'%' identified by 'Cloudera@123';
create database rman_test default character set utf8;
grant all privileges on rman_test.* to 'rman'@'%';

create user 'sentry'@'%' identified by 'Cloudera@123';
create database sentry_test default character set utf8;
grant all privileges on sentry_test.* to 'sentry'@'%';

create user 'nav'@'%' identified by 'Cloudera@123';
create database nav_test default character set utf8;
grant all privileges on nav_test.* to 'nav'@'%';

create user 'navms'@'%' identified by 'Cloudera@123';
create database navms_test default character set utf8;
grant all privileges on navms_test.* to 'navms'@'%';

create user 'cm'@'%' identified by 'Cloudera@123';
create database cm_test default character set utf8;
grant all privileges on cm_test.* to 'cm'@'%';

CREATE USER 'hue'@'%' IDENTIFIED BY 'Cloudera@123'; 
create database hue_test default character set utf8;
GRANT ALL PRIVILEGES ON hue_test.* TO 'hue'@'%'; 

CREATE USER 'oozie'@'%' IDENTIFIED BY 'Cloudera@123'; 
create database oozie_test default character set utf8;
GRANT ALL PRIVILEGES ON oozie_test.* TO 'oozie'@'%'; 
FLUSH PRIVILEGES;
```

[root@nm-1 ~]# vi /etc/my.cnf
log-bin=mysql-bin
server-id=88
binlog_format=MIXED
[root@nm-2 ~]# vi /etc/my.cnf


[root@nm-1 ~]# systemctl restart mysqld

```
在Master(172.31.10.118) 主MySQL上创建一个mysnc用户
用户名：mysync   密码：mysync
GRANT REPLICATION SLAVE ON *.* TO 'mysync'@'%';
FLUSH PRIVILEGES;
```

```
CREATE USER 'mysync'@'%' IDENTIFIED BY 'Cloudera@123';
change master to
master_host='10.150.4.88',
master_user='mysync',
master_password='mysync',
master_log_file='mysql-bin.000001',
master_log_pos=987;
```

## CDH软件下载与配置（Cloudera管理器节点）
1.	下载Cloudera管理器需要的rpm包
2.	下载Parcel包（包含了CDH中的Hadoop组件）
4.	创建repo文件以支持本地yum的操作

	```
	[root@cm 5.13.0]# pwd
	/var/www/html/cloudera/cm5/redhat/7/5.13.0
	[root@cm 5.13.0]# ll
	total 1101380
	-rw-r--r-- 1 root root   9787192 Oct 18 16:10 cloudera-manager-agent-5.13.0-1.cm5130.p0.55.el7.x86_64.rpm
	-rw-r--r-- 1 root root 699978252 Oct 18 16:10 cloudera-manager-daemons-5.13.0-1.cm5130.p0.55.el7.x86_64.rpm
	-rw-r--r-- 1 root root      8716 Oct 18 16:10 cloudera-manager-server-5.13.0-1.cm5130.p0.55.el7.x86_64.rpm
	-rw-r--r-- 1 root root     10604 Oct 18 16:10 cloudera-manager-server-db-2-5.13.0-1.cm5130.p0.55.el7.x86_64.rpm
	-rw-r--r-- 1 root root  30604232 Oct 18 16:10 enterprise-debuginfo-5.13.0-1.cm5130.p0.55.el7.x86_64.rpm
	-rw-r--r-- 1 root root  71204325 Oct 18 16:10 jdk-6u31-linux-amd64.rpm
	-rw-r--r-- 1 root root 174163338 Oct 19 15:04 jdk-8u151-linux-x64.rpm
	-rw-r--r-- 1 root root 142039186 Oct 18 16:10 oracle-j2sdk1.7-1.7.0+update67-1.x86_64.rpm
	[root@cm 5.13.0]# createrepo .
	Spawning worker 0 with 1 pkgs
	Spawning worker 1 with 1 pkgs
	Spawning worker 2 with 1 pkgs
	Spawning worker 3 with 1 pkgs
	Spawning worker 4 with 1 pkgs
	Spawning worker 5 with 1 pkgs
	Spawning worker 6 with 1 pkgs
	Spawning worker 7 with 1 pkgs
	Workers Finished
	Saving Primary metadata
	Saving file lists metadata
	Saving other metadata
	Generating sqlite DBs
	Sqlite DBs complete
	```


	```
	[root@cm 5.13.0]# cat /etc/yum.repos.d/cm513.repo 
	[cm513]
	name=cm513
	baseurl=http://10.150.4.47/cloudera/cm5/redhat/7/5.13.0/
	enabled=true
	gpgcheck=false
	```


```
[root@sj-cm ~]# mkdir /usr/share/java
[root@sj-cm ~]# ln -s /usr/share/java/mysql-connector-java-5.1.38-bin.jar /usr/share/java/mysql-connector-java.jar 
```




Storage: Use S3 for storage of input data and final output, and use HDFS for storage of intermediate data.
Compress all data to improve performance.
Avoid small files when defining your partitioning strategy.
Use Parquet columnar data format on S3.
Impala block size: 256 MB
Change S3A to “fs.s3a.block.size” to match block size.
For information about configuring Hive ETL jobs to use Amazon S3, see Configuring Transient Hive ETL Jobs to Use the Amazon S3 Filesystem in the Cloudera Enterprise documentation.



rgw地址:
 
10.125.137.30:8080
10.125.137.31:8080
10.125.137.32:8080

之后做了haproxy
 
测试用户信息
"user": "umtest2",
"access_key": "BBBA74VJ69J8I4N0GW3O",
"secret_key": "eNKTsutRmHR8HHM03Mx3xT6ctaW3Fd+PX75KGatk"
 



将所有的数据同步到s3上后 替换Defaultfs

检查 hive spark yarn 以及 mapreduce的使用

启用yarn的ha


## CDH core.xml 配置
<property>
  <name>fs.s3a.access.key</name>
  <value>BBBA74VJ69J8I4N0GW3O</value>
  <description>AWS access key ID. Omit for Role-based authentication.</description>
</property>

<property>
  <name>fs.s3a.secret.key</name>
  <value>eNKTsutRmHR8HHM03Mx3xT6ctaW3Fd+PX75KGatk</value>
  <description>AWS secret key</description>
</property>

<property>
  <name>fs.s3a.endpoint</name>
  <value>10.125.137.200:8000</value>
  <description>AWS S3 endpoint to connect to. An up-to-date list is
    provided in the AWS Documentation: regions and endpoints. Without this
    property, the standard region (s3.amazonaws.com) is assumed.
  </description>
</property>

<property>
  <name>fs.s3a.connection.ssl.enabled</name>
  <value>false</value>
  <description>Enables or disables SSL connections to S3.</description>
</property>
<property>
  <name>fs.defaultFS</name>
  <value>s3a://mybucket/</value>
</property>


hadoop fs -ls s3a://migu001/


-----------
## 问题记录

#### 用root账户启动spark报错
<console>:16: error: not found: value sqlContext
         import sqlContext.implicits._
                ^
<console>:16: error: not found: value sqlContext
         import sqlContext.sql
                ^

找不到文件系统上对应jar包导致

需要配上JAVA_HOME gateway

#### 用admin账户登入hue测试创建表报错
[HiveServer2-Handler-Pool: Thread-35]: unable to return groups for user admin
PartialGroupNameException The user name 'admin' is not found. id: admin: no such user
id: admin: no such user

HUE 通过hive 建表 ddl语句成功却没能见到新建的表,因为使用的是admin用户登入 集群中没有admin用户




#### Oozie缺少js库
To enable Oozie web console install the Ext JS library.

需要单独去安装这个js library


#### hue与s3对接
由于cloudera的hue,我查了源码后发现他们boto的调用根本没有获取port参数 所以私有s3的访问得首先改ini配置文件使得其在web上能显示,至于调用我是直接修改源码写死在代码里


hue_safety_valve_server.ini 的 Hue Server 高级配置代码段（安全阀）

```
[aws]
[[aws_accounts]]
[[[default]]]
#access_key_id_script=</path/to/access_key_script>
#secret_access_key_script=</path/to/secret_key_script>
#security_token=<your AWS security token>
allow_environment_credentials=false
region=<your region, such as us-east-1> 
access_key_id=<your_access_key_id>
secret_access_key=<your_secret_access_key>
```

CDH5.13版本才有host参数但是依旧没有port
```
[aws]
[[aws_accounts]]
[[[default]]]
host=10.125.137.200:8000
access_key_id='BBBA74VJ69J8I4N0GW3O'
secret_access_key='eNKTsutRmHR8HHM03Mx3xT6ctaW3Fd+PX75KGatk'
```


https://www.cloudera.com/documentation/enterprise/release-notes/topics/cm_vd_cdh_package_tarball_513.html#cm_vd_cdh_package_tarball_513
[HUE-6539] - [aws] Update AWS config check to connect to endpoint and avoid region check
[HUE-6515] - [aws] Do not use a default region if not configured, fallback to standard S3 endpoint

Support the new S3 regions
https://issues.cloudera.org/browse/HUE-5851

仅仅只配置了host会报region_name错误,因为他最后还是会去调用region的连接方式,报错如下:

```
S3 filesystem exception.
Failed to initialize bucket cache: local variable 'region_name' referenced before assignment

INFO Configuration.deprecation: fs.s3a.server-side-encryption-key is deprecated. Instead, use fs.s3a.server-side-encryption.key
```

```
S3 filesystem exception.

The AWS Access Key Id you provided does not exist in our records.

 More Info   View Logs 

File Name   Line Number Function Name
/opt/cloudera/parcels/CDH-5.10.0-1.cdh5.10.0.p0.41/lib/hue/apps/filebrowser/src/filebrowser/views.py    188 view
/opt/cloudera/parcels/CDH-5.10.0-1.cdh5.10.0.p0.41/lib/hue/apps/filebrowser/src/filebrowser/views.py    415 listdir_paged
/opt/cloudera/parcels/CDH-5.10.0-1.cdh5.10.0.p0.41/lib/hue/desktop/core/src/desktop/lib/fs/proxyfs.py   101 do_as_user
/opt/cloudera/parcels/CDH-5.10.0-1.cdh5.10.0.p0.41/lib/hue/desktop/core/src/desktop/lib/fs/proxyfs.py   120 listdir_stats
/opt/cloudera/parcels/CDH-5.10.0-1.cdh5.10.0.p0.41/lib/hue/desktop/libs/aws/src/aws/s3/__init__.py  52  wrapped
/opt/cloudera/parcels/CDH-5.10.0-1.cdh5.10.0.p0.41/lib/hue/desktop/libs/aws/src/aws/s3/s3fs.py  256 listdir_stats
/opt/cloudera/parcels/CDH-5.10.0-1.cdh5.10.0.p0.41/lib/hue/desktop/libs/aws/src/aws/s3/s3fs.py  80  _init_bucket_cache
```


#### OOZIE 错误
```
[11/Oct/2017 18:49:38 -0700] middleware   INFO     Processing exception: HTTPConnectionPool(host='tddp-nm-2', port=14000): Max retries exceeded with url: /webhdfs/v1/user/hue/oozie/deployments/_%24USER_-oozie-%24JOBID-%24TIME?op=GETFILESTATUS&user.name=hue&doas=hue (Caused by NewConnectionError('<requests.packages.urllib3.connection.HTTPConnection object at 0x7f42fc0bcd50>: Failed to establish a new connection: [Errno 111] Connection refused',)): Traceback (most recent call last):
  File "/opt/cloudera/parcels/CDH-5.10.0-1.cdh5.10.0.p0.41/lib/hue/build/env/lib64/python2.7/site-packages/Django-1.6.10-py2.7.egg/django/core/handlers/base.py", line 112, in get_response
    response = wrapped_callback(request, *callback_args, **callback_kwargs)
  File "/opt/cloudera/parcels/CDH-5.10.0-1.cdh5.10.0.p0.41/lib/hue/build/env/lib64/python2.7/site-packages/Django-1.6.10-py2.7.egg/django/db/transaction.py", line 371, in inner
    return func(*args, **kwargs)
  File "/opt/cloudera/parcels/CDH-5.10.0-1.cdh5.10.0.p0.41/lib/hue/apps/oozie/src/oozie/decorators.py", line 110, in decorate
    return view_func(request, *args, **kwargs)
  File "/opt/cloudera/parcels/CDH-5.10.0-1.cdh5.10.0.p0.41/lib/hue/apps/oozie/src/oozie/views/editor2.py", line 136, in new_workflow
    workflow.check_workspace(request.fs, request.user)
  File "/opt/cloudera/parcels/CDH-5.10.0-1.cdh5.10.0.p0.41/lib/hue/apps/oozie/src/oozie/models2.py", line 93, in check_workspace
    create_directories(fs, [REMOTE_SAMPLE_DIR.get()])
  File "/opt/cloudera/parcels/CDH-5.10.0-1.cdh5.10.0.p0.41/lib/hue/desktop/libs/liboozie/src/liboozie/submission2.py", line 436, in create_directories
    if not fs.do_as_user(fs.DEFAULT_USER, fs.exists, directory):
  File "/opt/cloudera/parcels/CDH-5.10.0-1.cdh5.10.0.p0.41/lib/hue/desktop/core/src/desktop/lib/fs/proxyfs.py", line 101, in do_as_user
    return fn(*args, **kwargs)
  File "/opt/cloudera/parcels/CDH-5.10.0-1.cdh5.10.0.p0.41/lib/hue/desktop/core/src/desktop/lib/fs/proxyfs.py", line 132, in exists
    return self._get_fs(path).exists(path)
  File "/opt/cloudera/parcels/CDH-5.10.0-1.cdh5.10.0.p0.41/lib/hue/desktop/libs/hadoop/src/hadoop/fs/webhdfs.py", line 253, in exists
    return self._stats(path) is not None
  File "/opt/cloudera/parcels/CDH-5.10.0-1.cdh5.10.0.p0.41/lib/hue/desktop/libs/hadoop/src/hadoop/fs/webhdfs.py", line 241, in _stats
    raise ex
WebHdfsException: HTTPConnectionPool(host='tddp-nm-2', port=14000): Max retries exceeded with url: /webhdfs/v1/user/hue/oozie/deployments/_%24USER_-oozie-%24JOBID-%24TIME?op=GETFILESTATUS&user.name=hue&doas=hue (Caused by NewConnectionError('<requests.packages.urllib3.connection.HTTPConnection object at 0x7f42fc0bcd50>: Failed to establish a new connection: [Errno 111] Connection refused',))
```

因为之前HDFS是旧版本的,我是干掉重新拷到s3上面去