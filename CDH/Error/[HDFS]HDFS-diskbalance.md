title: HDFS-diskbalance
categories: [CDH,Error]
date: 2017-06-23
---
# HDFS-diskbalance问题
开头怀疑是sentry的权限问题,就也给hdfs用户hive元数据库的admin权限
```
create role hdfs_role;
grant role hdfs_role to group hdfs;
grant all on URI 'hdfs:///system/diskbalancer' to role hdfs_role;
```

发现问题依旧
```
hdfs dfs -ls /system/diskbalancer
hdfs diskbalancer -plan ddp-dn-04.cmdmp.com
hdfs diskbalancer -plan ddp-dn-129.cmdmp.com

hdfs@ddp-dn-129:~> hdfs diskbalancer -plan ddp-dn-129.cmdmp.com
17/06/12 13:42:31 INFO balancer.KeyManager: Block token params received from NN: update interval=10hrs, 0sec, token lifetime=10hrs, 0sec
17/06/12 13:42:31 INFO block.BlockTokenSecretManager: Setting block keys
17/06/12 13:42:31 INFO balancer.KeyManager: Update block keys every 2hrs, 30mins, 0sec
17/06/12 13:42:32 INFO ipc.Client: Retrying connect to server: ddp-dn-129.cmdmp.com/10.200.60.40:50020. Already tried 0 time(s); retry policy is RetryUpToMaximumCountWithFixedSleep(maxRetries=10, sleepTime=1000 MILLISECONDS)
17/06/12 13:42:33 INFO ipc.Client: Retrying connect to server: ddp-dn-129.cmdmp.com/10.200.60.40:50020. Already tried 1 time(s); retry policy is RetryUpToMaximumCountWithFixedSleep(maxRetries=10, sleepTime=1000 MILLISECONDS)
17/06/12 13:42:34 INFO ipc.Client: Retrying connect to server: ddp-dn-129.cmdmp.com/10.200.60.40:50020. Already tried 2 time(s); retry policy is RetryUpToMaximumCountWithFixedSleep(maxRetries=10, sleepTime=1000 MILLISECONDS)
17/06/12 13:42:35 INFO ipc.Client: Retrying connect to server: ddp-dn-129.cmdmp.com/10.200.60.40:50020. Already tried 3 time(s); retry policy is RetryUpToMaximumCountWithFixedSleep(maxRetries=10, sleepTime=1000 MILLISECONDS)
17/06/12 13:42:36 INFO ipc.Client: Retrying connect to server: ddp-dn-129.cmdmp.com/10.200.60.40:50020. Already tried 4 time(s); retry policy is RetryUpToMaximumCountWithFixedSleep(maxRetries=10, sleepTime=1000 MILLISECONDS)
17/06/12 13:42:37 INFO ipc.Client: Retrying connect to server: ddp-dn-129.cmdmp.com/10.200.60.40:50020. Already tried 5 time(s); retry policy is RetryUpToMaximumCountWithFixedSleep(maxRetries=10, sleepTime=1000 MILLISECONDS)
17/06/12 13:42:38 INFO ipc.Client: Retrying connect to server: ddp-dn-129.cmdmp.com/10.200.60.40:50020. Already tried 6 time(s); retry policy is RetryUpToMaximumCountWithFixedSleep(maxRetries=10, sleepTime=1000 MILLISECONDS)
17/06/12 13:42:39 INFO ipc.Client: Retrying connect to server: ddp-dn-129.cmdmp.com/10.200.60.40:50020. Already tried 7 time(s); retry policy is RetryUpToMaximumCountWithFixedSleep(maxRetries=10, sleepTime=1000 MILLISECONDS)
17/06/12 13:42:40 INFO ipc.Client: Retrying connect to server: ddp-dn-129.cmdmp.com/10.200.60.40:50020. Already tried 8 time(s); retry policy is RetryUpToMaximumCountWithFixedSleep(maxRetries=10, sleepTime=1000 MILLISECONDS)
17/06/12 13:42:41 INFO ipc.Client: Retrying connect to server: ddp-dn-129.cmdmp.com/10.200.60.40:50020. Already tried 9 time(s); retry policy is RetryUpToMaximumCountWithFixedSleep(maxRetries=10, sleepTime=1000 MILLISECONDS)
17/06/12 13:42:41 ERROR tools.DiskBalancerCLI: java.net.ConnectException: Call From ddp-dn-129.cmdmp.com/10.200.60.40 to ddp-dn-129.cmdmp.com:50020 failed on connection exception: java.net.ConnectException: Connection refused; For more details see:  http://wiki.apache.org/hadoop/ConnectionRefused
```

```
ddp-dn-04:~ # hdfs diskbalancer -help plan
usage: hdfs diskbalancer -plan <hostname> [options]
Creates a plan that describes how much data should be moved between disks.

    --bandwidth <arg>             Maximum disk bandwidth (MB/s) in integer
                                  to be consumed by diskBalancer. e.g. 10
                                  MB/s.
    --maxerror <arg>              Describes how many errors can be
                                  tolerated while copying between a pair
                                  of disks.
    --out <arg>                   Local path of file to write output to,
                                  if not specified defaults will be used.
    --plan <arg>                  Hostname, IP address or UUID of datanode
                                  for which a plan is created.
    --thresholdPercentage <arg>   Percentage of data skew that is
                                  tolerated before disk balancer starts
                                  working. For example, if total data on a
                                  2 disk node is 100 GB then disk balancer
                                  calculates the expected value on each
                                  disk, which is 50 GB. If the tolerance
                                  is 10% then data on a single disk needs
                                  to be more than 60 GB (50 GB + 10%
                                  tolerance value) for Disk balancer to
                                  balance the disks.
    --v                           Print out the summary of the plan on
                                  console

Plan command creates a set of steps that represent a planned data move. A
plan file can be executed on a data node, which will balance the data.


ddp-nn-02:/etc/hadoop/conf # hdfs getconf -confkey dfs.disk.balancer.enabled
false

ddp-dn-01:~ # hdfs diskbalancer --plan ddp-dn-12.cmdmp.com
17/06/13 16:54:09 INFO balancer.KeyManager: Block token params received from NN: update interval=10hrs, 0sec, token lifetime=10hrs, 0sec
17/06/13 16:54:09 INFO block.BlockTokenSecretManager: Setting block keys
17/06/13 16:54:09 INFO balancer.KeyManager: Update block keys every 2hrs, 30mins, 0sec
17/06/13 16:54:09 ERROR tools.DiskBalancerCLI: org.apache.hadoop.ipc.RemoteException(org.apache.hadoop.security.AccessControlException): Permission denied.
  at org.apache.hadoop.hdfs.server.datanode.DataNode.checkSuperuserPrivilege(DataNode.java:948)
  at org.apache.hadoop.hdfs.server.datanode.DataNode.getDiskBalancerSetting(DataNode.java:3208)
  at org.apache.hadoop.hdfs.protocolPB.ClientDatanodeProtocolServerSideTranslatorPB.getDiskBalancerSetting(ClientDatanodeProtocolServerSideTranslatorPB.java:361)
  at org.apache.hadoop.hdfs.protocol.proto.ClientDatanodeProtocolProtos$ClientDatanodeProtocolService$2.callBlockingMethod(ClientDatanodeProtocolProtos.java:17901)
  at org.apache.hadoop.ipc.ProtobufRpcEngine$Server$ProtoBufRpcInvoker.call(ProtobufRpcEngine.java:617)
  at org.apache.hadoop.ipc.RPC$Server.call(RPC.java:1073)
  at org.apache.hadoop.ipc.Server$Handler$1.run(Server.java:2216)
  at org.apache.hadoop.ipc.Server$Handler$1.run(Server.java:2212)
  at java.security.AccessController.doPrivileged(Native Method)
  at javax.security.auth.Subject.doAs(Subject.java:415)
  at org.apache.hadoop.security.UserGroupInformation.doAs(UserGroupInformation.java:1796)
  at org.apache.hadoop.ipc.Server$Handler.run(Server.java:2210)
```

---
# hdfs diskbalancer

```
ddp-dn-033:~ # hdfs diskbalancer -plan ddp-dn-033.cmdmp.com
17/10/27 11:01:31 INFO balancer.KeyManager: Block token params received from NN: update interval=10hrs, 0sec, token lifetime=10hrs, 0sec
17/10/27 11:01:31 INFO block.BlockTokenSecretManager: Setting block keys
17/10/27 11:01:31 INFO balancer.KeyManager: Update block keys every 2hrs, 30mins, 0sec
17/10/27 11:01:31 ERROR tools.DiskBalancerCLI: org.apache.hadoop.ipc.RemoteException(org.apache.hadoop.security.AccessControlException): Permission denied.
    at org.apache.hadoop.hdfs.server.datanode.DataNode.checkSuperuserPrivilege(DataNode.java:948)
    at org.apache.hadoop.hdfs.server.datanode.DataNode.getDiskBalancerSetting(DataNode.java:3208)
    at org.apache.hadoop.hdfs.protocolPB.ClientDatanodeProtocolServerSideTranslatorPB.getDiskBalancerSetting(ClientDatanodeProtocolServerSideTranslatorPB.java:361)
    at org.apache.hadoop.hdfs.protocol.proto.ClientDatanodeProtocolProtos$ClientDatanodeProtocolService$2.callBlockingMethod(ClientDatanodeProtocolProtos.java:17901)
    at org.apache.hadoop.ipc.ProtobufRpcEngine$Server$ProtoBufRpcInvoker.call(ProtobufRpcEngine.java:617)
    at org.apache.hadoop.ipc.RPC$Server.call(RPC.java:1073)
    at org.apache.hadoop.ipc.Server$Handler$1.run(Server.java:2216)
    at org.apache.hadoop.ipc.Server$Handler$1.run(Server.java:2212)
    at java.security.AccessController.doPrivileged(Native Method)
    at javax.security.auth.Subject.doAs(Subject.java:415)
    at org.apache.hadoop.security.UserGroupInformation.doAs(UserGroupInformation.java:1796)
    at org.apache.hadoop.ipc.Server$Handler.run(Server.java:2210)
```

一般来说，对于需要HDFS超级用户权限的命令，使用任何HDFS主体去kinit都是有效的。然而，为了增加datanodes安全性在CDH 5.10.0中增加了一个变化。--HDFS11069
这一更改确保了对任何datanode运行一个超级用户命令，您必须首先执行kinit并使用和datanode相同服务主体

To run the intra node balancer, you must do the following:
1. Ensure that the HDFS Gateway is deployed on the Datanode you wish to run it against.(个人认为只需要保证本机使用HDFS-cli能连上nn就好,自己配置也行当然通过cm配置会比较块)
2. Login to the datanode you wish to balance, and kinit as follows:
    
    ```
        cd /var/run/cloudera-scm-agent/process/`ls -1 /var/run/cloudera-scm-agent/process/ | grep 'hdfs-DATANODE$' |
    sort -n | tail -1`
        kinit -kt hdfs.keytab hdfs/$(hostname -f)
    ```
3. Run the intra node balancer as usual:
    hdfs diskbalancer -plan datanode.hostname.com
    hdfs diskbalancer -plan $(hostname -f)

```
cd /var/run/cloudera-scm-agent/process/`ls -1 /var/run/cloudera-scm-agent/process/ | grep 'hdfs-DATANODE$' |sort -n | tail -1`
kinit -kt hdfs.keytab hdfs/$(hostname -f)
hdfs diskbalancer -plan $(hostname -f)

    17/11/15 10:41:25 INFO balancer.KeyManager: Block token params received from NN: update interval=10hrs, 0sec, token lifetime=10hrs, 0sec
    17/11/15 10:41:25 INFO block.BlockTokenSecretManager: Setting block keys
    17/11/15 10:41:25 INFO balancer.KeyManager: Update block keys every 2hrs, 30mins, 0sec
    17/11/15 10:41:25 INFO planner.GreedyPlanner: Starting plan for Node : ddp-dn-165.cmdmp.com:50020
    17/11/15 10:41:25 INFO planner.GreedyPlanner: Disk Volume set 9006e969-abee-4719-b2fa-be1b5a1bb0a0 Type : DISK plan completed.
    17/11/15 10:41:25 INFO planner.GreedyPlanner: Compute Plan for Node : ddp-dn-165.cmdmp.com:50020 took 11 ms 
    17/11/15 10:41:26 INFO command.Command: Writing plan to : /system/diskbalancer/2017-Nov-15-10-41-25

hdfs dfs -ls /system/diskbalancer/2017-Nov-15-10-41-25

hdfs diskbalancer -execute /system/diskbalancer/2017-Nov-15-10-41-25/$(hostname -f).plan.json

hdfs diskbalancer -query $(hostname) --v
```


```
hdfs diskbalancer -plan $(hostname -f) --out /root/hdfs-diskplan --thresholdPercentage 5
18/02/26 10:14:44 INFO balancer.KeyManager: Block token params received from NN: update interval=10hrs, 0sec, token lifetime=10hrs, 0sec
18/02/26 10:14:44 INFO block.BlockTokenSecretManager: Setting block keys
18/02/26 10:14:44 INFO balancer.KeyManager: Update block keys every 2hrs, 30mins, 0sec
18/02/26 10:14:45 INFO planner.GreedyPlanner: Starting plan for Node : ddp-dn-165.cmdmp.com:50020
18/02/26 10:14:45 INFO planner.GreedyPlanner: Disk Volume set 25e83c15-13e4-4429-96c1-cec44fe8c94c Type : DISK plan completed.
18/02/26 10:14:45 INFO planner.GreedyPlanner: Compute Plan for Node : ddp-dn-165.cmdmp.com:50020 took 8 ms 
18/02/26 10:14:45 INFO command.Command: Writing plan to : /root/hdfs-diskplan
```








```
ddp-dn-165:/var/run/cloudera-scm-agent/process/68817-hdfs-DATANODE # hdfs diskbalancer -plan $(hostname -f)  --thresholdPercentage 5
18/02/28 09:44:08 INFO balancer.KeyManager: Block token params received from NN: update interval=10hrs, 0sec, token lifetime=10hrs, 0sec
18/02/28 09:44:08 INFO block.BlockTokenSecretManager: Setting block keys
18/02/28 09:44:08 INFO balancer.KeyManager: Update block keys every 2hrs, 30mins, 0sec
18/02/28 09:44:08 INFO planner.GreedyPlanner: Starting plan for Node : ddp-dn-165.cmdmp.com:50020
18/02/28 09:44:08 INFO planner.GreedyPlanner: Disk Volume set 6a0d20f1-3936-40f7-a4dd-207c228a676a Type : DISK plan completed.
18/02/28 09:44:08 INFO planner.GreedyPlanner: Compute Plan for Node : ddp-dn-165.cmdmp.com:50020 took 7 ms 
18/02/28 09:44:09 INFO command.Command: Writing plan to : /system/diskbalancer/2018-Feb-28-09-44-08
ddp-dn-165:/var/run/cloudera-scm-agent/process/68817-hdfs-DATANODE # hdfs dfs -ls /system/diskbalancer/2018-Feb-28-09-44-08/
Found 2 items
-rw-r--r--   3 hdfs supergroup     606859 2018-02-28 09:44 /system/diskbalancer/2018-Feb-28-09-44-08/ddp-dn-165.cmdmp.com.before.json
-rw-r--r--   3 hdfs supergroup        928 2018-02-28 09:44 /system/diskbalancer/2018-Feb-28-09-44-08/ddp-dn-165.cmdmp.com.plan.json
ddp-dn-165:/var/run/cloudera-scm-agent/process/68817-hdfs-DATANODE # hdfs diskbalancer -execute /system/diskbalancer/2018-Feb-28-09-44-08/ddp-dn-165.cmdmp.com.plan.json
18/02/28 09:44:46 INFO command.Command: Executing "execute plan" command
ddp-dn-165:/var/run/cloudera-scm-agent/process/68817-hdfs-DATANODE # hdfs diskbalancer -query  $(hostname) --v
18/02/28 09:44:54 INFO command.Command: Executing "query plan" command.
Plan File: /system/diskbalancer/2018-Feb-28-09-44-08/ddp-dn-165.cmdmp.com.plan.json
Plan ID: bf4e1d912cf52fb2df81d1af4406ba3f8fcb4cb05023711a64d1f4101a2379ff8a0e36cedbc901ddbda4c17bc0a851fddfb55361e347c580a0792f6e08d935ac
Result: PLAN_UNDER_PROGRESS
[{"sourcePath":"/mnt/sdf1/dfs/dn","destPath":"/mnt/sdl1/dfs/dn","workItem":{"bytesToCopy":195547775977,"bytesCopied":134219396,"errorCount":0,"errMsg":null,"blocksCopied":2,"maxDiskErrors":0,"tolerancePercent":0,"bandwidth":0}}]
```


```
hdfs diskbalancer -plan $(hostname -f) --out /system/diskbalancer/$(hostname -f)  --thresholdPercentage 5
hdfs diskbalancer -execute /system/diskbalancer/$(hostname -f)/$(hostname -f).plan.json

```