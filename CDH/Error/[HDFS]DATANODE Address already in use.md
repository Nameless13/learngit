title: DATANODE Address already in use
categories: [CDH,Error]
date: 2018-05-29 16:33:15
---
# DATANODE Address already in use
由于原先这台机器已经部署过cdh环境,因为太旧没有启用,发现kerberos认证有问题log如下,后重新授权datanode角色,重新生成对应keytab文件后,恢复正常
```
Exception in secureMain
java.net.BindException: Problem binding to [ddp-dn-062.cmdmp.com:50020] java.net.BindException: Address already in use; For more details see:  http://wiki.apache.org/hadoop/BindException
    at sun.reflect.NativeConstructorAccessorImpl.newInstance0(Native Method)
    at sun.reflect.NativeConstructorAccessorImpl.newInstance(NativeConstructorAccessorImpl.java:57)
    at sun.reflect.DelegatingConstructorAccessorImpl.newInstance(DelegatingConstructorAccessorImpl.java:45)
    at java.lang.reflect.Constructor.newInstance(Constructor.java:526)
    at org.apache.hadoop.net.NetUtils.wrapWithMessage(NetUtils.java:791)
    at org.apache.hadoop.net.NetUtils.wrapException(NetUtils.java:720)
    at org.apache.hadoop.ipc.Server.bind(Server.java:481)
    at org.apache.hadoop.ipc.Server$Listener.<init>(Server.java:687)
    at org.apache.hadoop.ipc.Server.<init>(Server.java:2375)
    at org.apache.hadoop.ipc.RPC$Server.<init>(RPC.java:1042)
    at org.apache.hadoop.ipc.ProtobufRpcEngine$Server.<init>(ProtobufRpcEngine.java:535)
    at org.apache.hadoop.ipc.ProtobufRpcEngine.getServer(ProtobufRpcEngine.java:510)
    at org.apache.hadoop.ipc.RPC$Builder.build(RPC.java:887)
    at org.apache.hadoop.hdfs.server.datanode.DataNode.initIpcServer(DataNode.java:891)
    at org.apache.hadoop.hdfs.server.datanode.DataNode.startDataNode(DataNode.java:1277)
    at org.apache.hadoop.hdfs.server.datanode.DataNode.<init>(DataNode.java:464)
    at org.apache.hadoop.hdfs.server.datanode.DataNode.makeInstance(DataNode.java:2545)
    at org.apache.hadoop.hdfs.server.datanode.DataNode.instantiateDataNode(DataNode.java:2432)
    at org.apache.hadoop.hdfs.server.datanode.DataNode.createDataNode(DataNode.java:2479)
    at org.apache.hadoop.hdfs.server.datanode.DataNode.secureMain(DataNode.java:2661)
    at org.apache.hadoop.hdfs.server.datanode.SecureDataNodeStarter.start(SecureDataNodeStarter.java:77)
    at sun.reflect.NativeMethodAccessorImpl.invoke0(Native Method)
    at sun.reflect.NativeMethodAccessorImpl.invoke(NativeMethodAccessorImpl.java:57)
    at sun.reflect.DelegatingMethodAccessorImpl.invoke(DelegatingMethodAccessorImpl.java:43)
    at java.lang.reflect.Method.invoke(Method.java:606)
    at org.apache.commons.daemon.support.DaemonLoader.start(DaemonLoader.java:243)
Caused by: java.net.BindException: Address already in use
    at sun.nio.ch.Net.bind0(Native Method)
    at sun.nio.ch.Net.bind(Net.java:444)
    at sun.nio.ch.Net.bind(Net.java:436)
    at sun.nio.ch.ServerSocketChannelImpl.bind(ServerSocketChannelImpl.java:214)
    at sun.nio.ch.ServerSocketAdaptor.bind(ServerSocketAdaptor.java:74)
    at org.apache.hadoop.ipc.Server.bind(Server.java:464)
    ... 19 more
```
检查了一下所在集群kafka的端口 发现没有被占用 之后重新生成http以及hdfs 对应的kerberos认证解决