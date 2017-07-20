title: redis服务搭建
categories: [redis,redis服务搭建]
date: 2016-09-07
---
# redis服务搭建
## 主机命名
1. 确定操作系统类型 
    `cat  /etc/issue`
2. 查看当前系统的主机名`hostname`

3. 改/etc/sysconfig下的network文件`vi /etc/sysconfig/network`

    把HOSTNAME后面的值改为想要设置的主机名
    `NETWORKING=yes
    HOSTNAME=CentOS2`

system network reset

exit 验证

不得重启

4. 更改/etc下的hosts文件
    
    `vi /etc/hosts`
    然后将localhost.localdomain改为想要设置的主机名。
    
        127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4
        ::1         localhost localhost.localdomain localhost6 localhost6.localdomain6
        192.168.29.136  CentOS1
        192.168.29.135  CentOS2
        192.168.29.134  CentOS3
    


5.  `reboot`
6.  检查`hostname`

## 时钟同步
### CentOS6
1. 检查是否启动时钟同步服务
service检查:  `service ntpd status`
job 检查 :    `crontab -l`
修改定时任务: ` crontab -e` 

2. 设置时钟同步:
    - 修改 /etc/ntp.conf  加入 ntp server ip
    `vi /etc/ntp.conf` `server 10.200.92.18`
    - 启动ntp服务:
    `service ntpd start`
    - 设置服务自动启动: 
        1. 设置 `chkconfig ntpd on`
        2. 检查 `chkconfig -list ntpd`

### CentOS7
- 使用rpm检查ntp包是否安装
[root@CentOS3 home]# rpm -q ntp
ntp-4.2.6p5-22.el7.centos.x86_64
- 如果已经安装则略过此步，否则使用yum进行安装，并设置系统开机自动启动并启动服务
    ```
    yum -y install ntp
    systemctl enable ntpd
    systemctl start ntpd
    ```
修改完成后重启ntpd服务systemctl restart ntpd

使用ntpq -p 查看网络中的NTP服务器，同时显示客户端和每个服务器的关系

使用ntpstat 命令查看时间同步状态，这个一般需要5-10分钟后才能成功连接和同步。所以，服务器启动后需要稍等下： 
刚启动的时候，一般是：

        unsynchronised
          time server re-starting
           polling server every 8 s




## 操作系统
CentOS release 6.8 (Final)

CentOS 7
## 网络
### CentOS 6.8:
    - 防火墙:
        - 即使生效,重启后失效
            开启: service iptables start
            关闭: service iptables stop
        - 重启后生效
            开启: chkconfig iptables on
            关闭: chkconfig iptables off
    - 开启了防火墙时,做如下设置可以仅开启相关端口:
        修改/etc/sysconfig/iptables 文件,添加以下内容:
            -A RH-Firewall-1-INPUT -m state --state NEW -m tcp -p tcp --dport 80 -j ACCEPT 
            -A RH-Firewall-1-INPUT -m state --state NEW -m tcp -p tcp --dport 22 -j ACCEPT

### CentOS 7.0:
CentOS 7.0默认使用的是firewall作为防火墙，这里改为iptables防火墙。
firewall：

    systemctl start firewalld.service#启动firewall

    systemctl stop firewalld.service#停止firewall

    systemctl disable firewalld.service#禁止firewall开机启动


## 源码安装redis

        wget http://download.redis.io/releases/redis-3.2.4.tar.gz
        tar xzf redis-3.2.4.tar.gz
        cd redis-3.2.4
        make
        make test   //只用单核运行 make test：taskset -c 1 sudo make test
        make install
        mv redis-3.2.4 redis
        mv redis /usr/local/


## 修复3个redis-server 启动警告
    echo 1 > /proc/sys/vm/overcommit_memory
    echo never > /sys/kernel/mm/transparent_hugepage/enabled
    echo 511 > /proc/sys/net/core/somaxconn

## 开机启动redis

`/usr/local/redis/utils/install_server.sh `
第一个参数分别选择7380 7381 26379
### 26379
    Please select the redis executable path [/usr/local/bin/redis-server] 
    +  /usr/local/bin/redis-sentinel


### 关闭实例 
    [root@CentOS3 redis]# ps aux|grep redis
    root     19874  0.0  0.0 136912  7528 ?        Ssl  15:43   0:00 /usr/local/bin/redis-server 127.0.0.1:7380
    root     20178  0.0  0.0 136912  7528 ?        Ssl  15:43   0:00 /usr/local/bin/redis-server 127.0.0.1:7381
    root     20541  0.0  0.0 136912  7528 ?        Ssl  15:47   0:00 /usr/local/bin/redis-server 127.0.0.1:26379
    root     20705  0.0  0.0 112644   992 pts/2    S+   15:48   0:00 grep --color=auto redis
    [root@CentOS3 redis]# redis-cli -p 7380 shutdown
    [root@CentOS3 redis]# redis-cli -p 7381 shutdown
    [root@CentOS3 redis]# redis-cli -p 26379 shutdown
    [root@CentOS3 redis]# ps aux|grep redis
    root     20721  0.0  0.0 112644   996 pts/2    S+   15:49   0:00 grep --color=auto redis

`redis-cli -p 7380 shutdown && redis-cli -p 7381 shutdown && redis-cli -p 26379 shutdown`

### 修改sentinel启动脚本

`vim /etc/init.d/redis_26379`

        +  REDISHOSTNAME="192.168.29.134"
       
        -   $CLIEXEC -p $REDISPORT shutdown
        +   $CLIEXEC -h $REDISHOSTNAME -p $REDISPORT shutdown

## resid-service config (135:7380)
    -  bind 127.0.0.1
    +  bind 192.168.29.135   

    -  protected-mode yes
    +  protected-mode no

    -  # unixsocket /tmp/redis.sock
    -  # unixsocketperm 700
    +  unixsocket /tmp/redis.sock
    +  unixsocketperm 700

    -  timeout 0 
    +  timeout 300

    -  tcp-keepalive 300
    +  tcp-keepalive 0

    -  save 900 1
    -  save 300 10
    -  save 60 10000
    +  #save 900 1
    +  #save 300 10
    +  #save 60 10000

    -  stop-writes-on-bgsave-error yes
    +  stop-writes-on-bgsave-error no

    -  #repl-ping-slave-period 10
    +  repl-ping-slave-period 10

    -  # repl-backlog-size 1mb
    +  repl-backlog-size 5mb
    -  # repl-backlog-ttl 3600
    +  repl-backlog-ttl 600

    -  #maxclients 10000
    +  maxclients 10000

    -  # maxmemory <bytes>
    +  maxmemory 2gb

    -  appendonly no
    +  appendonly yes 

### resid-service config (135:7381)
    cp /etc/redis/7380.conf /etc/redis/7381.conf
    vim  /etc/redis/7381.conf
        
        `:%s/7380/7381/g`   //替换所有的7380为7381

## redis-sentinal config (135:26379)
    rm -f /etc/redis/26379.conf
    cp /usr/local/redis/sentinel.conf /etc/redis/26379.conf
    vim /usr/local/redis/26379.conf
 
        +  daemonize yes
        -  #protected-mode no
        +  protected-mode no
        -  dir /tmp
        +  dir /var/lib/redis/26379
        +  logfile /var/log/redis_26379.log

        -  sentinel monitor mymaster 127.0.0.1 6379 2
        +  sentinel monitor redis136 192.168.29.136 7380 2
        -  sentinel down-after-milliseconds mymaster 30000
        +  sentinel down-after-milliseconds redis136 5000        
        -  sentinel parallel-syncs mymaster 1
        +  sentinel parallel-syncs redis136 1 
        -  sentinel failover-timeout mymaster 180000
        +  sentinel failover-timeout redis136 60000

        +  sentinel monitor redis135 192.168.29.135 7380 2
        +  sentinel down-after-milliseconds redis135 5000
        +  sentinel failover-timeout redis135 60000
        +  sentinel parallel-syncs redis135 1
       
        +  sentinel monitor redis134 192.168.29.134 7380 2
        +  sentinel down-after-milliseconds redis134 5000
        +  sentinel failover-timeout redis134 60000
        +  sentinel parallel-syncs redis134 1
        

## redis部署

### 预定分配方案:
                  192.168.29.134
                   +---------+  
                   | M1 7380 |
                   | R3 7381 |
                   | S1      |
                   +---------+
      192.168.29.136    |    192.168.29.135
        +---------+     |     +---------+
        | M3 7380 |     |     | M2 7380 |  
        | R2 7381 |-----------| R1 7381 |
        | S3      |           | S2      |
        +---------+           +---------+

        Configuration: quorum = 2



### redis-server实例启动:
    redis-server /etc/redis/7380.conf
    redis-server /etc/redis/7381.conf
    
    netstat -lntpa |grep redis 
### 主从分配
三台主机实例均启动之后,进行主从配置:
    
    redis-cli -h 192.168.29.134 -p 7381 slaveof 192.168.29.136 7380
    redis-cli -h 192.168.29.135 -p 7381 slaveof 192.168.29.134 7380
    redis-cli -h 192.168.29.136 -p 7381 slaveof 192.168.29.135 7380

### redis-sentinel实例启动:
最后在三台主机上启动sentinel

`redis-sentinel /etc/redis/26379.conf`

## 检查failover
    redis-cli -h 192.168.29.135 -p 7380  debug sleep 300s
    redis-cli -p 26379 sentinel master redis135


