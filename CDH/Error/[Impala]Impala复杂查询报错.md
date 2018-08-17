title: Impala复杂查询报错
categories: [CDH,Error]
date: 2017-03-30
---
# Impala Error: Couldn't open transport(未解决)
 >**v1.0** updated:2017-03-30 何常通
 > [原地址](https://community.cloudera.com/t5/Interactive-Short-cycle-SQL/Impala-Error-Couldn-t-open-transport/m-p/15916#M366)

## 当运行复杂查询的时候会报出这种错误
When we try to run more complex Impala queries, we often run into the following error:
Couldn't open transport for worker29.ourdomain.com:22000(connect() failed: Connection timed out)
 
Sometimes there's only one node with that error message, sometimes there are 2-5.
There doesn't seem to be a network related problem - ping works, telnet to that port works, Impala debug ui works.
We tried setting vm.swappiness on the nodes from 60 to 0 - no positive effect. Same with switching vm.overcommit from 0 to 1.

Our setup:
- around 40 nodes, i7 quad core, 2-3TB, 1Gbit NIC, located in 5 different racks
- nodes have around 16-48GB ram, same amount of swap, which they alsmost never use
- OS: Ubuntu Linux 12.04
- CDH 5.1.0
- impalad version 1.4.0-cdh5-INTERNAL RELEASE (build e801bd8c0d134e783c2313c7dd422a5ad06591af)
- ~100TB HDFS storage
- we are using a HA proxy which points to the nodes with >32GB ram
- "workerlogs"-table is around 6-7TB big, partitioned by year > month > day and contains apache log-data
- almost 100% short circuit reads

---
### Solution
We found cause for the error - our firewall settings were to restrictive. Interestingly smaller queries without many query fragments worked even with these restrictive settings.


### 另一种解决方法
发现impala daemon 进程因为端口不能正常释放导致进程僵死,而且cloudera manage 并不能很好的反应这个问题,只能在重启impala集群的时候,才能统一发现问题节点
登入上出问题的节点后,手动kill -9 结束impala daemon 进程等所有端口22000 释放后 重启impala角色

### 之后怀疑是catalog中java堆栈不足导致
因为其会存放所有的hive表,调大后问题依旧


```
LISTEN     0      128                      :::22000                   :::*     

...
CLOSE-WAIT 1      0              10.200.63.40:59113         10.200.60.37:22000 
CLOSE-WAIT 1      0              10.200.63.40:49935         10.200.60.84:22000 
CLOSE-WAIT 1      0              10.200.63.40:37983         10.200.63.95:22000 
CLOSE-WAIT 1      0              10.200.63.40:54077        10.200.60.141:22000 
ESTAB      0      0       ::ffff:10.200.63.40:22000  ::ffff:10.200.60.79:35306 
CLOSE-WAIT 1      0              10.200.63.40:54735         10.200.60.18:22000 
CLOSE-WAIT 1      0              10.200.63.40:56024        10.200.60.104:22000 
CLOSE-WAIT 1      0              10.200.63.40:58151         10.200.63.83:22000 
CLOSE-WAIT 1      0              10.200.63.40:48922         10.200.60.28:22000 
ESTAB      0      0       ::ffff:10.200.63.40:22000  ::ffff:10.200.60.39:54698 
CLOSE-WAIT 1      0              10.200.63.40:60084         10.200.63.10:22000 
CLOSE-WAIT 1      0              10.200.63.40:34485        10.200.60.133:22000 
CLOSE-WAIT 1      0              10.200.63.40:38254         10.200.60.21:22000 
CLOSE-WAIT 1      0              10.200.63.40:44333         10.200.63.92:22000 
CLOSE-WAIT 1      0              10.200.63.40:49949         10.200.60.70:22000 
CLOSE-WAIT 1      0              10.200.63.40:45932         10.200.63.23:22000 
CLOSE-WAIT 1      0              10.200.63.40:49212         10.200.60.89:22000 
CLOSE-WAIT 1      0              10.200.63.40:59992        10.200.60.142:22000 
ESTAB      0      0       ::ffff:10.200.63.40:22000  ::ffff:10.200.63.40:36279 
CLOSE-WAIT 1      0              10.200.63.40:54234         10.200.63.85:22000 
CLOSE-WAIT 1      0              10.200.63.40:38895         10.200.60.63:22000 
...
```

```
ddp-dn-001:~ # ss -na |grep 22000
FIN-WAIT-2 0      0       ::ffff:10.200.60.10:22000 ::ffff:10.200.60.131:55870 
FIN-WAIT-2 0      0       ::ffff:10.200.60.10:22000  ::ffff:10.200.60.27:34903 
FIN-WAIT-2 0      0       ::ffff:10.200.60.10:22000  ::ffff:10.200.63.87:34871 
FIN-WAIT-2 0      0       ::ffff:10.200.60.10:22000  ::ffff:10.200.63.94:53015 
FIN-WAIT-2 0      0       ::ffff:10.200.60.10:22000  ::ffff:10.200.63.30:47730 
FIN-WAIT-2 0      0       ::ffff:10.200.60.10:22000  ::ffff:10.200.63.40:44511 
FIN-WAIT-2 0      0       ::ffff:10.200.60.10:22000  ::ffff:10.200.60.27:34902 
FIN-WAIT-2 0      0       ::ffff:10.200.60.10:22000  ::ffff:10.200.60.25:54064 
FIN-WAIT-2 0      0       ::ffff:10.200.60.10:22000  ::ffff:10.200.60.41:34054 
FIN-WAIT-2 0      0       ::ffff:10.200.60.10:22000  ::ffff:10.200.60.27:34899 
FIN-WAIT-2 0      0       ::ffff:10.200.60.10:22000  ::ffff:10.200.63.26:58685 
FIN-WAIT-2 0      0       ::ffff:10.200.60.10:22000  ::ffff:10.200.63.94:33762 
FIN-WAIT-2 0      0       ::ffff:10.200.60.10:22000  ::ffff:10.200.60.39:37609 
FIN-WAIT-2 0      0       ::ffff:10.200.60.10:22000  ::ffff:10.200.60.32:54664 
FIN-WAIT-2 0      0       ::ffff:10.200.60.10:22000  ::ffff:10.200.60.74:40587 
FIN-WAIT-2 0      0       ::ffff:10.200.60.10:22000  ::ffff:10.200.63.30:51810 
FIN-WAIT-2 0      0       ::ffff:10.200.60.10:22000  ::ffff:10.200.63.40:44504 
FIN-WAIT-2 0      0       ::ffff:10.200.60.10:22000  ::ffff:10.200.60.79:34747 
FIN-WAIT-2 0      0       ::ffff:10.200.60.10:22000  ::ffff:10.200.63.87:35121 
FIN-WAIT-2 0      0       ::ffff:10.200.60.10:22000  ::ffff:10.200.63.94:33765 
FIN-WAIT-2 0      0       ::ffff:10.200.60.10:22000  ::ffff:10.200.60.69:43695 
FIN-WAIT-2 0      0       ::ffff:10.200.60.10:22000  ::ffff:10.200.60.74:58780 
FIN-WAIT-2 0      0       ::ffff:10.200.60.10:22000  ::ffff:10.200.63.30:51809 
```

后来通过cm的api写了一个全集群手动停止impala deamon的脚本