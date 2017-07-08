title: hiveserver2集成haproxy
categories: 
- CDH
- Hive
date: 2017-07-06
---
# 配置HiveServer2负载平衡代理
>操作系统:SUSE11 SP3
>CM版本:CM5.10.041
>CDH版本:CDH5.10.041
>使用root用户对集群进行部署
>[cloudera对应文档](https://www.cloudera.com/documentation/enterprise/5-10-x/topics/admin_ha_hiveserver2.html)

1. 下载负载平衡代理软件到需要的主机上。[haproxy-1.5.14-91.1.x86_64.rpm](http://rpm.pbone.net/index.php3/stat/4/idpl/33562430/dir/opensuse/com/haproxy-1.5.14-91.1.x86_64.rpm.html)
2. 安装,配置开机启动,修改配置文件后启动haproxy,并检查对应端口是否开启  
    1. Set the port for the load balancer to listen on and relay HiveServer2 requests back and forth.
    2. Set the port and hostname for each HiveServer2 host—that is, the hosts from which the load balancer chooses when relaying each query. 

    ```
    rpm -ihv haproxy-1.5.14-91.1.x86_64.rpm 
    chkconfig haproxy on
    chkconfig --list haproxy 
    cp /etc/haproxy/haproxy.cfg /etc/haproxy/bak.cfg
    vi /etc/haproxy/haproxy.cfg 
    /etc/init.d/haproxy start

    ss -an |grep 10003
    ```

    配置文件:[因为balance模式选择导致HUE请求超时](https://issues.cloudera.org/browse/HUE-4990)  
    ```
    global
        # To have these messages end up in /var/log/haproxy.log you will
        # need to:
        #
        # 1) configure syslog to accept network log events.  This is done
        #    by adding the '-r' option to the SYSLOGD_OPTIONS in
        #    /etc/sysconfig/syslog
        #
        # 2) configure local2 events to go to the /var/log/haproxy.log
        #   file. A line like the following can be added to
        #   /etc/sysconfig/syslog
        #
        #    local2.*                       /var/log/haproxy.log
        #
        pidfile     /var/run/haproxy.pid
        nbproc 1
        maxconn     4000
        daemon

        # turn on stats unix socket
        #stats socket /var/lib/haproxy/stats

    #---------------------------------------------------------------------
    # common defaults that all the 'listen' and 'backend' sections will
    # use if not designated in their block
    #
    # You might need to adjust timing values to prevent timeouts.
    #---------------------------------------------------------------------
    defaults
        mode                    tcp
        log                     127.0.0.1 local0 err
        option                  redispatch
        retries                 3
        maxconn                 3000
        contimeout 1800000
        timeout client 1800000
        timeout server 1800000

    #
    # This sets up the admin page for HA Proxy at port 25002.
    #
    listen stats
        bind 10.200.65.71:25002
        balance
        mode http
        stats enable
        stats auth username:password

    # This is the setup for Impala. Impala client connect to load_balancer_host:25003.
    # HAProxy will balance connections among the list of servers listed below.
    # The list of Impalad is listening at port 21000 for beeswax (impala-shell) or original ODBC driver.
    # For JDBC or ODBC version 2.x driver, use port 21050 instead of 21000.
    listen hive
        bind 10.200.65.71:10003
        mode tcp
        balance source
        maxconn 1024
        server ddp-cm ddp-cm.cmdmp.com:10000 check inter 1800000 rise 1 fall 2
        server ddp-dn-12 ddp-dn-12.cmdmp.com:10000 check inter 1800000 rise 1 fall 2
    ```

3. 如果开启hiveserver UDF 配置,需要将之前hiveserver2对应路径下的jar包,放在与之一致的路径里,之后如果更新jar包需要同时更新所有的hiveserver2节点下对应的目录以及haproxy节点下对应的目录
    ```
    mkdir -p /opt/local/hive/lib/
    mkdir -p /opt/local/hive/reloadable/
    scp root@10.200.65.50:/opt/local/hive/lib/* /opt/local/hive/lib/
    scp root@10.200.65.50:/opt/local/hive/reloadable/* /opt/local/hive/reloadable/
    
    chown hadoop:hadoop -R /opt/local/hive/lib/
    chown hadoop:hadoop -R /opt/local/hive/reloadable/
    ```

4. Run the load-balancing proxy server and point it at the configuration file.
5. In Cloudera Manager, configure HiveServer2 Load Balancer for the proxy server.
    1. Go to the Hive service.
    2. Click the Configuration tab.
    3. Select Scope > HiveServer2.
    4. Select Category > Main. 
    5. Locate the HiveServer2 Load Balancer property or search for it by typing its name in the Search box.
    6. Enter values for `hostname:port number`.
    7. Click Save Changes to commit the changes.
    8. Restart the Hive service.
    ```
    Note:When you set the HiveServer2 Load Balancer property, Cloudera Manager regenerates the keytabs for HiveServer2 roles. The principal in these keytabs contains the load balancer hostname. If there is a Hue service that depends on this Hive service, it also uses the load balancer to communicate with Hive.
    ```

6. Point all scripts, jobs, or application configurations to the new proxy server instead of any specific HiveServer2 instance.一旦CM中hive配置配上balance后,原先所有的hiveserver2都将无法继续使用

附录:[Higher Availability](http://blog.cloudera.com/blog/2013/08/how-to-achieve-higher-availability-for-hue/)    