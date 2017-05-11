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
## resid-service config
`

    daemonize yes

    pidfile "/var/run/redis.pid"

    port 7379 

    tcp-backlog 511

    # bind 192.168.1.100 10.0.0.1
    # bind 127.0.0.1
    bind 192.168.29.136

    unixsocket /tmp/redis.sock
    unixsocketperm 700

    timeout 300

    tcp-keepalive 0

    loglevel notice

    logfile "/logs/redis/redis-master1.conf"

    databases 16

    # save 900 1
    # save 300 10
    # save 60 10000

    stop-writes-on-bgsave-error no

    rdbcompression yes

    rdbchecksum yes

    dbfilename "dump.rdb"

    dir /data/redis/7379

    # slaveof <masterip> <masterport>
    # masterauth <master-password>
    slave-serve-stale-data yes

    slave-read-only yes

    repl-diskless-sync no

    repl-diskless-sync-delay 5

    # Slaves send PINGs to server in a predefined interval. It's possible to change
    # this interval with the repl_ping_slave_period option. The default value is 10
    # seconds.
    #
    # repl-ping-slave-period 10
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

    # requirepass foobared
    # rename-command CONFIG b840fc02d524045429941cc15f59e41cb7be6c52
    # rename-command CONFIG ""


    maxclients 10000
    ###
    maxmemort 2gb

    # maxmemory-policy noeviction


    # maxmemory-samples 5






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




    # cluster-enabled yes
    # cluster-config-file nodes-7379.conf
    # cluster-node-timeout 15000
    # cluster-slave-validity-factor 10
    # cluster-migration-barrier 1
    # cluster-require-full-coverage yes




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
