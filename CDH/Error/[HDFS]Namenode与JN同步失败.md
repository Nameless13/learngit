title: [HDFS]Namenode与JN同步失败
categories: [CDH,Error]
date: 2017-11-07
---
namenode无故Shutdown,可能的原因是当时正好是jn同步数据并合并到fsimage时失败

```
Remote journal 10.200.60.113:8485 failed to write txns 11564575193-11564575195. Will try to write to this JN again after the next log roll.
org.apache.hadoop.ipc.RemoteException(java.io.IOException): IPC's epoch 82 is less than the last promised epoch 83
    at org.apache.hadoop.hdfs.qjournal.server.Journal.checkRequest(Journal.java:429)
    at org.apache.hadoop.hdfs.qjournal.server.Journal.checkWriteRequest(Journal.java:457)
    at org.apache.hadoop.hdfs.qjournal.server.Journal.journal(Journal.java:352)
    at org.apache.hadoop.hdfs.qjournal.server.JournalNodeRpcServer.journal(JournalNodeRpcServer.java:149)
    at org.apache.hadoop.hdfs.qjournal.protocolPB.QJournalProtocolServerSideTranslatorPB.journal(QJournalProtocolServerSideTranslatorPB.java:158)
    at org.apache.hadoop.hdfs.qjournal.protocol.QJournalProtocolProtos$QJournalProtocolService$2.callBlockingMethod(QJournalProtocolProtos.java:25421)
    at org.apache.hadoop.ipc.ProtobufRpcEngine$Server$ProtoBufRpcInvoker.call(ProtobufRpcEngine.java:617)
    at org.apache.hadoop.ipc.RPC$Server.call(RPC.java:1073)
    at org.apache.hadoop.ipc.Server$Handler$1.run(Server.java:2216)
    at org.apache.hadoop.ipc.Server$Handler$1.run(Server.java:2212)
    at java.security.AccessController.doPrivileged(Native Method)
    at javax.security.auth.Subject.doAs(Subject.java:415)
    at org.apache.hadoop.security.UserGroupInformation.doAs(UserGroupInformation.java:1796)
    at org.apache.hadoop.ipc.Server$Handler.run(Server.java:2210)

    at org.apache.hadoop.ipc.Client.call(Client.java:1472)
    at org.apache.hadoop.ipc.Client.call(Client.java:1409)
    at org.apache.hadoop.ipc.ProtobufRpcEngine$Invoker.invoke(ProtobufRpcEngine.java:230)
    at com.sun.proxy.$Proxy17.journal(Unknown Source)
    at org.apache.hadoop.hdfs.qjournal.protocolPB.QJournalProtocolTranslatorPB.journal(QJournalProtocolTranslatorPB.java:167)
    at org.apache.hadoop.hdfs.qjournal.client.IPCLoggerChannel$7.call(IPCLoggerChannel.java:385)
    at org.apache.hadoop.hdfs.qjournal.client.IPCLoggerChannel$7.call(IPCLoggerChannel.java:378)
    at java.util.concurrent.FutureTask.run(FutureTask.java:262)
    at java.util.concurrent.ThreadPoolExecutor.runWorker(ThreadPoolExecutor.java:1145)
    at java.util.concurrent.ThreadPoolExecutor$Worker.run(ThreadPoolExecutor.java:615)
    at java.lang.Thread.run(Thread.java:745)

11月 6, 下午4点00:49.883分   INFO    BlockStateChange    

BLOCK* addToInvalidates: blk_2239499981_1210072156 10.200.60.92:1004 10.200.63.97:1004 10.200.63.96:1004 

11月 6, 下午4点00:49.885分   FATAL   org.apache.hadoop.hdfs.server.namenode.FSEditLog    

Error: flush failed for required journal (JournalAndStream(mgr=QJM to [10.200.60.98:8485, 10.200.60.105:8485, 10.200.60.113:8485], stream=QuorumOutputStream starting at txid 11564549439))
org.apache.hadoop.hdfs.qjournal.client.QuorumException: Got too many exceptions to achieve quorum size 2/3. 3 exceptions thrown:
10.200.60.105:8485: IPC's epoch 82 is less than the last promised epoch 83
    at org.apache.hadoop.hdfs.qjournal.server.Journal.checkRequest(Journal.java:429)
    at org.apache.hadoop.hdfs.qjournal.server.Journal.checkWriteRequest(Journal.java:457)
    at org.apache.hadoop.hdfs.qjournal.server.Journal.journal(Journal.java:352)
    at org.apache.hadoop.hdfs.qjournal.server.JournalNodeRpcServer.journal(JournalNodeRpcServer.java:149)
    at org.apache.hadoop.hdfs.qjournal.protocolPB.QJournalProtocolServerSideTranslatorPB.journal(QJournalProtocolServerSideTranslatorPB.java:158)
    at org.apache.hadoop.hdfs.qjournal.protocol.QJournalProtocolProtos$QJournalProtocolService$2.callBlockingMethod(QJournalProtocolProtos.java:25421)
    at org.apache.hadoop.ipc.ProtobufRpcEngine$Server$ProtoBufRpcInvoker.call(ProtobufRpcEngine.java:617)
    at org.apache.hadoop.ipc.RPC$Server.call(RPC.java:1073)
    at org.apache.hadoop.ipc.Server$Handler$1.run(Server.java:2216)
    at org.apache.hadoop.ipc.Server$Handler$1.run(Server.java:2212)
    at java.security.AccessController.doPrivileged(Native Method)
    at javax.security.auth.Subject.doAs(Subject.java:415)
    at org.apache.hadoop.security.UserGroupInformation.doAs(UserGroupInformation.java:1796)
    at org.apache.hadoop.ipc.Server$Handler.run(Server.java:2210)

10.200.60.113:8485: IPC's epoch 82 is less than the last promised epoch 83
    at org.apache.hadoop.hdfs.qjournal.server.Journal.checkRequest(Journal.java:429)
    at org.apache.hadoop.hdfs.qjournal.server.Journal.checkWriteRequest(Journal.java:457)
    at org.apache.hadoop.hdfs.qjournal.server.Journal.journal(Journal.java:352)
    at org.apache.hadoop.hdfs.qjournal.server.JournalNodeRpcServer.journal(JournalNodeRpcServer.java:149)
    at org.apache.hadoop.hdfs.qjournal.protocolPB.QJournalProtocolServerSideTranslatorPB.journal(QJournalProtocolServerSideTranslatorPB.java:158)
    at org.apache.hadoop.hdfs.qjournal.protocol.QJournalProtocolProtos$QJournalProtocolService$2.callBlockingMethod(QJournalProtocolProtos.java:25421)
    at org.apache.hadoop.ipc.ProtobufRpcEngine$Server$ProtoBufRpcInvoker.call(ProtobufRpcEngine.java:617)
    at org.apache.hadoop.ipc.RPC$Server.call(RPC.java:1073)
    at org.apache.hadoop.ipc.Server$Handler$1.run(Server.java:2216)
    at org.apache.hadoop.ipc.Server$Handler$1.run(Server.java:2212)
    at java.security.AccessController.doPrivileged(Native Method)
    at javax.security.auth.Subject.doAs(Subject.java:415)
    at org.apache.hadoop.security.UserGroupInformation.doAs(UserGroupInformation.java:1796)
    at org.apache.hadoop.ipc.Server$Handler.run(Server.java:2210)

10.200.60.98:8485: IPC's epoch 82 is less than the last promised epoch 83
    at org.apache.hadoop.hdfs.qjournal.server.Journal.checkRequest(Journal.java:429)
    at org.apache.hadoop.hdfs.qjournal.server.Journal.checkWriteRequest(Journal.java:457)
    at org.apache.hadoop.hdfs.qjournal.server.Journal.journal(Journal.java:352)
    at org.apache.hadoop.hdfs.qjournal.server.JournalNodeRpcServer.journal(JournalNodeRpcServer.java:149)
    at org.apache.hadoop.hdfs.qjournal.protocolPB.QJournalProtocolServerSideTranslatorPB.journal(QJournalProtocolServerSideTranslatorPB.java:158)
    at org.apache.hadoop.hdfs.qjournal.protocol.QJournalProtocolProtos$QJournalProtocolService$2.callBlockingMethod(QJournalProtocolProtos.java:25421)
    at org.apache.hadoop.ipc.ProtobufRpcEngine$Server$ProtoBufRpcInvoker.call(ProtobufRpcEngine.java:617)
    at org.apache.hadoop.ipc.RPC$Server.call(RPC.java:1073)
    at org.apache.hadoop.ipc.Server$Handler$1.run(Server.java:2216)
    at org.apache.hadoop.ipc.Server$Handler$1.run(Server.java:2212)
    at java.security.AccessController.doPrivileged(Native Method)
    at javax.security.auth.Subject.doAs(Subject.java:415)
    at org.apache.hadoop.security.UserGroupInformation.doAs(UserGroupInformation.java:1796)
    at org.apache.hadoop.ipc.Server$Handler.run(Server.java:2210)

    at org.apache.hadoop.hdfs.qjournal.client.QuorumException.create(QuorumException.java:81)
    at org.apache.hadoop.hdfs.qjournal.client.QuorumCall.rethrowException(QuorumCall.java:223)
    at org.apache.hadoop.hdfs.qjournal.client.AsyncLoggerSet.waitForWriteQuorum(AsyncLoggerSet.java:142)
    at org.apache.hadoop.hdfs.qjournal.client.QuorumOutputStream.flushAndSync(QuorumOutputStream.java:107)
    at org.apache.hadoop.hdfs.server.namenode.EditLogOutputStream.flush(EditLogOutputStream.java:113)
    at org.apache.hadoop.hdfs.server.namenode.EditLogOutputStream.flush(EditLogOutputStream.java:107)
    at org.apache.hadoop.hdfs.server.namenode.JournalSet$JournalSetOutputStream$8.apply(JournalSet.java:533)
    at org.apache.hadoop.hdfs.server.namenode.JournalSet.mapJournalsAndReportErrors(JournalSet.java:393)
    at org.apache.hadoop.hdfs.server.namenode.JournalSet.access$100(JournalSet.java:57)
    at org.apache.hadoop.hdfs.server.namenode.JournalSet$JournalSetOutputStream.flush(JournalSet.java:529)
    at org.apache.hadoop.hdfs.server.namenode.FSEditLog.logSync(FSEditLog.java:651)
    at org.apache.hadoop.hdfs.server.namenode.FSEditLog.logSync(FSEditLog.java:585)
    at org.apache.hadoop.hdfs.server.namenode.FSNamesystem.mkdirsInt(FSNamesystem.java:4361)
    at org.apache.hadoop.hdfs.server.namenode.FSNamesystem.mkdirs(FSNamesystem.java:4327)
    at org.apache.hadoop.hdfs.server.namenode.NameNodeRpcServer.mkdirs(NameNodeRpcServer.java:873)
    at org.apache.hadoop.hdfs.server.namenode.AuthorizationProviderProxyClientProtocol.mkdirs(AuthorizationProviderProxyClientProtocol.java:323)
    at org.apache.hadoop.hdfs.protocolPB.ClientNamenodeProtocolServerSideTranslatorPB.mkdirs(ClientNamenodeProtocolServerSideTranslatorPB.java:618)
    at org.apache.hadoop.hdfs.protocol.proto.ClientNamenodeProtocolProtos$ClientNamenodeProtocol$2.callBlockingMethod(ClientNamenodeProtocolProtos.java)
    at org.apache.hadoop.ipc.ProtobufRpcEngine$Server$ProtoBufRpcInvoker.call(ProtobufRpcEngine.java:617)
    at org.apache.hadoop.ipc.RPC$Server.call(RPC.java:1073)
    at org.apache.hadoop.ipc.Server$Handler$1.run(Server.java:2216)
    at org.apache.hadoop.ipc.Server$Handler$1.run(Server.java:2212)
    at java.security.AccessController.doPrivileged(Native Method)
    at javax.security.auth.Subject.doAs(Subject.java:415)
    at org.apache.hadoop.security.UserGroupInformation.doAs(UserGroupInformation.java:1796)
    at org.apache.hadoop.ipc.Server$Handler.run(Server.java:2210)
```