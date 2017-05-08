# Impala Error: Couldn't open transport
 >**v1.0** updated:2017-03-30 何常通
 
 <a href="https://community.cloudera.com/t5/Interactive-Short-cycle-SQL/Impala-Error-Couldn-t-open-transport/m-p/15916#M366">原地址</a>

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
## Solution
We found cause for the error - our firewall settings were to restrictive. Interestingly smaller queries without many query fragments worked even with these restrictive settings.


### 另一种解决方法
发现impala daemon 进程因为端口不能正常释放导致进程僵死,而且cloudera manage 并不能很好的反应这个问题,只能在重启impala集群的时候,才能统一发现问题节点
登入上出问题的节点后,手动kill -9 结束impala daemon 进程等所有端口22000 释放后 重启impala角色