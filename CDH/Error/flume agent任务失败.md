title: flume agent任务失败
categories: 
- CDH
- Error
date: 2017/09/24 13:58:04
---
# flume agent任务失败
[https://community.hortonworks.com/questions/45962/dataxceiver-error-processing-write-block-operation.html]
flume日志报错: 

```
PriviledgedActionException as:hadoop@CMDMP.COM (auth:KERBEROS) cause:java.io.IOException: Couldn't setup connection for hadoop@CMDMP.COM to ddp-nn-02.cmdmp.com/10.200.60.107:8020
06 Jul 2017 06:39:23,507 INFO  [hdfs-sink1-call-runner-5] (org.apache.hadoop.io.retry.RetryInvocationHandler.invoke:148)  - Exception while invoking create of class ClientNamenodeProtocolTranslatorPB over ddp-nn-02.cmdmp.com/10.200.60.107:8020 after 1 fail over attempts. Trying to fail over immediately.
java.io.IOException: Failed on local exception: java.io.IOException: Couldn't setup connection for hadoop@CMDMP.COM to ddp-nn-02.cmdmp.com/10.200.60.107:8020; Host Details : local host is: "ddp-dn-101.cmdmp.com/10.200.63.89"; destination host is: "ddp-nn-02.cmdmp.com":8020;

Unable to close file because the last block des not have enough number of replicas.
```

开头开发怀疑是kerberos的问题,后来排查发现是每个agent进程jvm内存使用超出配额8192m,但是进程也没有配上超出后自动kill的参数,所以可以运行但是会报错

The flume agents went in OutOfMemoryError (unable to create new native thread) and the impact on the hdfs had been the error posted above



同时hdfs上也会有日志写入出错的记录
hadoop-datanode1:50010ataXceiver error processing WRITE_BLOCK operation
运行mapreduce程序在reduce阶段时出现错误提示： Unable to close file because the last block does not have enough number of replicas.


jmap -heap pid 查看java进程内存使用情况