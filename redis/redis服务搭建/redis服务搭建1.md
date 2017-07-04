#redis服务搭建
## 主机命名
1. 确定操作系统类型 
    `cat  /etc/issue`
2. 查看当前系统的主机名
`hostname`

3. 改/etc/sysconfig下的network文件`vi /etc/sysconfig/network`

    把HOSTNAME后面的值改为想要设置的主机名
    `NETWORKING=yes
    HOSTNAME=CentOS2`

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


## 操作系统
CentOS release 6.8 (Final)

## 网络
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


## 源码安装redis

        wget http://download.redis.io/releases/redis-3.2.4.tar.gz
        tar xzf redis-3.2.4.tar.gz
        cd redis-3.2.4
        make
        make test
        make install

##开机启动redis

`/usr/local/redis/utils/install_server.sh `


    Welcome to the redis service installer
    This script will help you easily set up a running redis server

    Please select the redis port for this instance: [6379] 6379
    Please select the redis config file name [/etc/redis/6379.conf] /etc/redis/test/6379.conf
    Please select the redis log file name [/var/log/redis_6379.log] /data/redis/test/6379/redis.log
    Please select the data directory for this instance [/var/lib/redis/6379] /data/redis/test/6379
    Please select the redis executable path [/usr/local/bin/redis-server] 
    Selected config:
    Port           : 6379
    Config file    : /etc/redis/test/6379.conf
    Log file       : /data/redis/test/6379/redis.log
    Data dir       : /data/redis/test/6379
    Executable     : /usr/local/bin/redis-server
    Cli Executable : /usr/local/bin/redis-cli
    Is this ok? Then press ENTER to go on or Ctrl-C to abort.
    Copied /tmp/6379.conf => /etc/init.d/redis_7380
    Installing service...
    Successfully added to chkconfig!
    Successfully added to runlevels 345!
    Starting Redis server...
    Installation successful!

### 关闭实例 
`redis-cli shutdown`
## 依次启动实例
`scp 7380.conf 7381.conf sentinal-test.conf root@192.168.29.135:/etc/redis/test/`

conf:  `cd /etc/redis/test`

<!-- data: `mkdir -p  /etc/redis/test /data/redis/test/7380 /data/redis/test/7381 /data/redis/test/sentinel` -->

<!-- 删除数据: `rm -rf /data/redis/test/7380/* /data/redis/test/7381/* /data/redis/test/sentinel/*` -->


### 主从实例配置
| 主 | 从 |
| :-- | :-- |
| 192.168.29.136:7380 | 192.168.29.135:7381 |
| 192.168.29.135:7380 | 192.168.29.134:7381 |
| 192.168.29.134:7380 | 192.168.29.136:7381 |

因为主从节点的confing 有概率会被sentinel  重写,所以要按**顺序依次**启动实例

先从.29.136开始 :

`[root@CentOS1 test]# redis-server /etc/redis/test/7380.conf`

检查:

`[root@CentOS1 test]# redis-cli -h 192.168.29.136 -p 7380`

`192.168.29.136:7380> info Replication`

切换.29.135

`[root@CentOS2 test]# redis-server /etc/redis/test/7381.conf`

`[root@CentOS2 test]# redis-server /etc/redis/test/7380.conf`

切换29.134

`[root@CentOS3 test]# redis-server /etc/redis/test/7381.conf`

`[root@CentOS3 test]# redis-server /etc/redis/test/7380.conf`

切换回29.136

`[root@CentOS1 test]# redis-server /etc/redis/test/7381.conf`

最后在每个服务器上开启sentinel实例


因为之前错误操作 导致sentinel配置文件 错误 , 重新启动sentinel的时候要把config文件重写,否则从节点的config文件将被sentinel继续修改


## resid-service config
`

    daemonize yes

    pidfile "/data/redis/test/7380/redis.pid"

    port 7380 

    tcp-backlog 511

    bind 192.168.29.135

    unixsocket /tmp/redis.sock
    unixsocketperm 700

    timeout 300

    tcp-keepalive 0

    loglevel notice

    logfile "/data/redis/test/7380/redis.log"

    databases 16

    stop-writes-on-bgsave-error no

    rdbcompression yes

    rdbchecksum yes

    dbfilename "dump.rdb"

    dir /data/redis/test/7380

    slave-serve-stale-data yes

    slave-read-only yes

    repl-diskless-sync no

    repl-diskless-sync-delay 5

    # Slaves send PINGs to server in a predefined interval. It's possible to change
    # this interval with the repl_ping_slave_period option. The default value is 10
    # seconds.
    #
     repl-ping-slave-period 10
    # repl-timeout 60
    repl-disable-tcp-nodelay no
    ###
    repl-backlog-size 5mb
    repl-backlog-ttl 600
    # repl-backlog-size 1mb
    # repl-backlog-ttl 3600
    slave-priority 100
    # min-slaves-to-write 3
    # min-slaves-max-lag 10

    maxclients 10000

    maxmemory 2gb

    appendonly yes 

    appendfilename "appendonly.aof"

    # appendfsync always
    appendfsync everysec
    # appendfsync no

    no-appendfsync-on-rewrite no

    auto-aof-rewrite-percentage 100
    auto-aof-rewrite-min-size 64mb

    aof-load-truncated yes

    lua-time-limit 5000

    slowlog-log-slower-than 10000
    slowlog-max-len 128


    latency-monitor-threshold 0

    notify-keyspace-events ""

    hash-max-ziplist-entries 512
    hash-max-ziplist-value 64


    list-max-ziplist-entries 512
    list-max-ziplist-value 64

    set-max-intset-entries 512

    zset-max-ziplist-entries 128
    zset-max-ziplist-value 64
    hll-sparse-max-bytes 3000
    activerehashing yes

    client-output-buffer-limit normal 0 0 0
    client-output-buffer-limit slave 256mb 64mb 60
    client-output-buffer-limit pubsub 32mb 8mb 60

    hz 10

    aof-rewrite-incremental-fsync yes

`





## redis-sentinal config

默认端口不改,开启`daemonize yes`
因为sentinel2 后会对主从节点的config文件进行修改 所以在sentinel应该在所有实例配置完成后再开启

`

    port 26379
    ###
    daemonize yes
    dir "/data/redis/test/sentinel"

    ###R136 
    sentinel monitor redis136 192.168.29.136 7380 2
    sentinel down-after-milliseconds redis136 60000
    sentinel failover-timeout redis136 180000
    sentinel parallel-syncs redis136 1
    sentinel known-slave redis136 192.168.29.135 7381

    ###R135
    sentinel monitor redis135 192.168.29.135 7380 2
    sentinel down-after-milliseconds redis135 60000
    sentinel failover-timeout redis135 180000
    sentinel parallel-syncs redis135 1
    sentinel known-slave redis135 192.168.29.134 7381
    sentinel current-epoch 14


    ###R134 
    sentinel monitor redis134 192.168.29.134 7380 2
    sentinel down-after-milliseconds redis134 60000
    sentinel failover-timeout redis134 180000
    sentinel parallel-syncs redis134 1
    sentinel known-slave redis134 192.168.29.136 7381

    
`



### sentinel 实例启动
`redis-sentinel /etc/redis/test/sentinel-test.conf `

检查,直接查看sentinel的config文件就可以了,sentinel实例启动成功后会重写自己的config文件:

`vim /etc/redis/test/sentinel-test.conf`






