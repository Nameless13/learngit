title: Linux 防火墙
categories: 
- Linux
date: 2017-07-07
---
[root@CentOS3 redis]# service iptables status
Table: filter
Chain INPUT (policy ACCEPT)
num  target     prot opt source               destination         
1    ACCEPT     all  --  0.0.0.0/0            0.0.0.0/0           state RELATED,ESTABLISHED 
2    ACCEPT     icmp --  0.0.0.0/0            0.0.0.0/0           
3    ACCEPT     all  --  0.0.0.0/0            0.0.0.0/0           
4    ACCEPT     tcp  --  0.0.0.0/0            0.0.0.0/0           state NEW tcp dpt:22 
5    REJECT     all  --  0.0.0.0/0            0.0.0.0/0           reject-with icmp-host-prohibited 

Chain FORWARD (policy ACCEPT)
num  target     prot opt source               destination         
1    REJECT     all  --  0.0.0.0/0            0.0.0.0/0           reject-with icmp-host-prohibited 

Chain OUTPUT (policy ACCEPT)
num  target     prot opt source               destination         

[root@CentOS3 redis]# service iptables stop
iptables: Setting chains to policy ACCEPT: filter          [  OK  ]
iptables: Flushing firewall rules:                         [  OK  ]
iptables: Unloading modules:                               [  OK  ]
[root@CentOS3 redis]# service ip6tables stop
ip6tables: Setting chains to policy ACCEPT: filter         [  OK  ]
ip6tables: Flushing firewall rules:                        [  OK  ]
ip6tables: Unloading modules:                              [  OK  ]
[root@CentOS3 redis]# chkconfig iptables down
chkconfig version 1.3.49.3 - Copyright (C) 1997-2000 Red Hat, Inc.
This may be freely redistributed under the terms of the GNU Public License.

usage:   chkconfig [--list] [--type <type>] [name]
         chkconfig --add <name>
         chkconfig --del <name>
         chkconfig --override <name>
         chkconfig [--level <levels>] [--type <type>] <name> <on|off|reset|resetpriorities>
[root@CentOS3 redis]# chkconfig iptables off
[root@CentOS3 redis]# chkconfig ip6tables off



`service iptables status`   查看iptables状态
`service iptables restart`  iptables服务重启
`service iptables stop`     iptables服务禁用 


---
ip地址后边加个/8(16,24,32)是什么意思?
是掩码的位数，A类IP地址的默认子网掩码为255.0.0.0（由于255相当于二进制的8位1，所以也缩写成“/8”，表示网络号占了8位）;B类的为255.255.0.0（/16）;C类的为255.255.255.0(/24)。/30就是255.255.255.252。32就是255.255.255.255.

本机的DNS配置信息是在：/etc/resolv.conf

---
time cost is(3\d{3}?ms)

