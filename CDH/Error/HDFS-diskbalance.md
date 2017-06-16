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