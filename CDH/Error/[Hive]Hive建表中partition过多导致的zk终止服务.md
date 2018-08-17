title: Hive建表中partition过多导致的zk终止服务
categories: [CDH,Error]
date: 2018-05-25 18:12:03
---
# Hive建表中partition过多导致的zk终止服务
检查zoo.cfg

```
maxClientCnxns=50
# The number of milliseconds of each tick
tickTime=2000
# The number of ticks that the initial 
# synchronization phase can take
initLimit=10
# The number of ticks that can pass between 
# sending a request and getting an acknowledgement
syncLimit=5
# the directory where the snapshot is stored.
dataDir=/var/lib/zookeeper
# the port at which the clients will connect
clientPort=2181
# the directory where the transaction logs are stored.
dataLogDir=/var/lib/zookeeper
```

zookeep

```
2018-01-11 15:00:57,154 INFO org.apache.zookeeper.server.PrepRequestProcessor: Got user-level KeeperException when processing sessionid:0x25bfba6d6a3d356 type:create cxid:0xddbb47b zxid:0x17859dbd63 txntype:-1 reqpath:n/a Error Path:/hive_zookeeper_namespace_hive/intdata Error:KeeperErrorCode = NodeExists for /hive_zookeeper_namespace_hive/intdata
2018-01-11 15:00:57,190 INFO org.apache.zookeeper.server.PrepRequestProcessor: Got user-level KeeperException when processing sessionid:0x25bfba6d6a3d356 type:create cxid:0xddbb47e zxid:0x17859dbd6a txntype:-1 reqpath:n/a Error Path:/hive_zookeeper_namespace_hive/intdata/ott_device_status_change_log Error:KeeperErrorCode = NodeExists for /hive_zookeeper_namespace_hive/intdata/ott_device_status_change_log
2018-01-11 15:00:57,252 INFO org.apache.zookeeper.server.PrepRequestProcessor: Got user-level KeeperException when processing sessionid:0x25bfba6d6a3d356 type:create cxid:0xddbb484 zxid:0x17859dbd76 txntype:-1 reqpath:n/a Error Path:/hive_zookeeper_namespace_hive/ods Error:KeeperErrorCode = NodeExists for /hive_zookeeper_namespace_hive/ods
2018-01-11 15:00:58,257 INFO org.apache.zookeeper.server.persistence.FileTxnSnapLog: Snapshotting: 0x17859dbe1e to /var/lib/zookeeper/version-2/snapshot.17859dbe1e
2018-01-11 15:00:58,262 INFO org.apache.zookeeper.server.persistence.FileTxnLog: Creating new log file: log.17859dbe20
2018-01-11 15:01:03,596 WARN org.apache.zookeeper.server.persistence.FileTxnLog: fsync-ing the write ahead log in SyncThread:2 took 1442ms which will adversely effect operation latency. See the ZooKeeper troubleshooting guide
2018-01-11 15:01:05,958 WARN org.apache.zookeeper.server.persistence.FileTxnLog: fsync-ing the write ahead log in SyncThread:2 took 2318ms which will adversely effect operation latency. See the ZooKeeper troubleshooting guide
2018-01-11 15:01:09,106 WARN org.apache.zookeeper.server.persistence.FileTxnLog: fsync-ing the write ahead log in SyncThread:2 took 3082ms which will adversely effect operation latency. See the ZooKeeper troubleshooting guide
2018-01-11 15:01:13,185 WARN org.apache.zookeeper.server.persistence.FileTxnLog: fsync-ing the write ahead log in SyncThread:2 took 3420ms which will adversely effect operation latency. See the ZooKeeper troubleshooting guide
2018-01-11 15:01:14,742 INFO org.apache.zookeeper.server.PrepRequestProcessor: Got user-level KeeperException when processing sessionid:0x25bfba6d6a43321 type:create cxid:0x147a6fa zxid:0x17859dc2c1 txntype:-1 reqpath:n/a Error Path:/hive_zookeeper_namespace_hive/acc Error:KeeperErrorCode = NodeExists for /hive_zookeeper_namespace_hive/acc
2018-01-11 15:01:25,970 INFO org.apache.zookeeper.server.PrepRequestProcessor: Got user-level KeeperException when processing sessionid:0x25bfba6d6a3d356 type:create cxid:0xddbb4d5 zxid:0x17859dc68d txntype:-1 reqpath:n/a Error Path:/hive_zookeeper_namespace_hive/default Error:KeeperErrorCode = NodeExists for /hive_zookeeper_namespace_hive/default
2018-01-11 15:01:32,616 INFO org.apache.zookeeper.server.NIOServerCnxnFactory: Accepted socket connection from /10.200.60.114:45594
2018-01-11 15:01:32,617 INFO org.apache.zookeeper.server.ZooKeeperServer: Client attempting to establish new session at /10.200.60.114:45594
2018-01-11 15:01:32,618 INFO org.apache.zookeeper.server.ZooKeeperServer: Established session 0x25bfba6d6a58cd2 with negotiated timeout 30000 for client /10.200.60.114:45594
2018-01-11 15:01:32,840 INFO org.apache.zookeeper.server.NIOServerCnxnFactory: Accepted socket connection from /10.200.60.114:45600
2018-01-11 15:01:32,841 INFO org.apache.zookeeper.server.ZooKeeperServer: Client attempting to establish new session at /10.200.60.114:45600
2018-01-11 15:01:32,842 INFO org.apache.zookeeper.server.ZooKeeperServer: Established session 0x25bfba6d6a58cd3 with negotiated timeout 30000 for client /10.200.60.114:45600
2018-01-11 15:01:33,289 INFO org.apache.zookeeper.server.PrepRequestProcessor: Processed session termination for sessionid: 0x15bfba733c68c56
2018-01-11 15:01:33,301 INFO org.apache.zookeeper.server.PrepRequestProcessor: Processed session termination for sessionid: 0x25bfba6d6a58cd3
2018-01-11 15:01:33,309 INFO org.apache.zookeeper.server.NIOServerCnxn: Closed socket connection for client /10.200.60.114:45600 which had sessionid 0x25bfba6d6a58cd3
2018-01-11 15:01:33,310 INFO org.apache.zookeeper.server.PrepRequestProcessor: Processed session termination for sessionid: 0x35bfba6d7d488e3
2018-01-11 15:01:33,361 INFO org.apache.zookeeper.server.PrepRequestProcessor: Processed session termination for sessionid: 0x25bfba6d6a58cd2
2018-01-11 15:01:33,444 INFO org.apache.zookeeper.server.NIOServerCnxn: Closed socket connection for client /10.200.60.114:45594 which had sessionid 0x25bfba6d6a58cd2
2018-01-11 15:01:40,472 INFO org.apache.zookeeper.server.quorum.QuorumPeerConfig: Reading configuration from: /var/run/cloudera-scm-agent/process/44352-zookeeper-server/zoo.cfg


2018-01-11 15:01:40,472 INFO org.apache.zookeeper.server.quorum.QuorumPeerConfig: Reading configuration from: /var/run/cloudera-scm-agent/process/44352-zookeeper-server/zoo.cfg
2018-01-11 15:01:40,483 INFO org.apache.zookeeper.server.quorum.QuorumPeerConfig: Defaulting to majority quorums
2018-01-11 15:01:40,487 INFO org.apache.zookeeper.server.DatadirCleanupManager: autopurge.snapRetainCount set to 5
2018-01-11 15:01:40,487 INFO org.apache.zookeeper.server.DatadirCleanupManager: autopurge.purgeInterval set to 24
2018-01-11 15:01:40,488 INFO org.apache.zookeeper.server.DatadirCleanupManager: Purge task started.
2018-01-11 15:01:40,497 INFO org.apache.zookeeper.server.quorum.QuorumPeerMain: Starting quorum peer
2018-01-11 15:01:40,695 INFO org.apache.zookeeper.Login: successfully logged in.
2018-01-11 15:01:40,696 INFO org.apache.zookeeper.Login: TGT refresh thread started.
2018-01-11 15:01:40,698 INFO org.apache.zookeeper.server.NIOServerCnxnFactory: binding to port 0.0.0.0/0.0.0.0:2181
2018-01-11 15:01:40,701 INFO org.apache.zookeeper.Login: TGT valid starting at:        Thu Jan 11 15:01:40 CST 2018
2018-01-11 15:01:40,702 INFO org.apache.zookeeper.Login: TGT expires:                  Fri Jan 12 15:01:40 CST 2018
2018-01-11 15:01:40,702 INFO org.apache.zookeeper.Login: TGT refresh sleeping until: Fri Jan 12 10:49:49 CST 2018
2018-01-11 15:01:40,706 INFO org.apache.zookeeper.server.quorum.QuorumPeer: tickTime set to 2000
2018-01-11 15:01:40,706 INFO org.apache.zookeeper.server.quorum.QuorumPeer: minSessionTimeout set to 4000
2018-01-11 15:01:40,706 INFO org.apache.zookeeper.server.quorum.QuorumPeer: maxSessionTimeout set to 180000
2018-01-11 15:01:40,706 INFO org.apache.zookeeper.server.quorum.QuorumPeer: initLimit set to 10
2018-01-11 15:01:40,722 INFO org.apache.zookeeper.server.persistence.FileSnap: Reading snapshot /var/lib/zookeeper/version-2/snapshot.17859dbe1e
2018-01-11 15:01:49,423 INFO org.apache.zookeeper.server.DatadirCleanupManager: Purge task completed.
2018-01-11 15:01:54,593 ERROR org.apache.zookeeper.server.persistence.Util: Last transaction was partial.
2018-01-11 15:01:54,596 INFO org.apache.zookeeper.server.quorum.QuorumCnxManager: My election bind port: 0.0.0.0/0.0.0.0:4181
2018-01-11 15:01:54,608 INFO org.apache.zookeeper.server.quorum.QuorumPeer: LOOKING
2018-01-11 15:01:54,609 INFO org.apache.zookeeper.server.quorum.FastLeaderElection: New election. My id =  2, proposed zxid=0x17859dc8b6
2018-01-11 15:01:54,612 WARN org.apache.zookeeper.server.quorum.QuorumCnxManager: Cannot open channel to 1 at election address ddp-hnn-03.cmdmp.com/10.200.60.113:4181
java.net.ConnectException: Connection refused
    at java.net.PlainSocketImpl.socketConnect(Native Method)
    at java.net.AbstractPlainSocketImpl.doConnect(AbstractPlainSocketImpl.java:339)
    at java.net.AbstractPlainSocketImpl.connectToAddress(AbstractPlainSocketImpl.java:200)
    at java.net.AbstractPlainSocketImpl.connect(AbstractPlainSocketImpl.java:182)
    at java.net.SocksSocketImpl.connect(SocksSocketImpl.java:392)
    at java.net.Socket.connect(Socket.java:579)
    at org.apache.zookeeper.server.quorum.QuorumCnxManager.connectOne(QuorumCnxManager.java:354)
    at org.apache.zookeeper.server.quorum.QuorumCnxManager.toSend(QuorumCnxManager.java:327)
    at org.apache.zookeeper.server.quorum.FastLeaderElection$Messenger$WorkerSender.process(FastLeaderElection.java:393)
    at org.apache.zookeeper.server.quorum.FastLeaderElection$Messenger$WorkerSender.run(FastLeaderElection.java:365)
    at java.lang.Thread.run(Thread.java:745)
2018-01-11 15:01:54,625 WARN org.apache.zookeeper.server.quorum.QuorumCnxManager: Cannot open channel to 3 at election address ddp-hnn-02.cmdmp.com/10.200.60.105:4181
java.net.ConnectException: Connection refused
    at java.net.PlainSocketImpl.socketConnect(Native Method)
    at java.net.AbstractPlainSocketImpl.doConnect(AbstractPlainSocketImpl.java:339)
    at java.net.AbstractPlainSocketImpl.connectToAddress(AbstractPlainSocketImpl.java:200)
    at java.net.AbstractPlainSocketImpl.connect(AbstractPlainSocketImpl.java:182)
    at java.net.SocksSocketImpl.connect(SocksSocketImpl.java:392)
    at java.net.Socket.connect(Socket.java:579)
    at org.apache.zookeeper.server.quorum.QuorumCnxManager.connectOne(QuorumCnxManager.java:354)
    at org.apache.zookeeper.server.quorum.QuorumCnxManager.toSend(QuorumCnxManager.java:327)
    at org.apache.zookeeper.server.quorum.FastLeaderElection$Messenger$WorkerSender.process(FastLeaderElection.java:393)
    at org.apache.zookeeper.server.quorum.FastLeaderElection$Messenger$WorkerSender.run(FastLeaderElection.java:365)
    at java.lang.Thread.run(Thread.java:745)
2018-01-11 15:01:54,625 INFO org.apache.zookeeper.server.quorum.FastLeaderElection: Notification: 2 (n.leader), 0x17859dc8b6 (n.zxid), 0x1 (n.round), LOOKING (n.state), 2 (n.sid), 0x17 (n.peerEPoch), LOOKING (my state)
2018-01-11 15:01:54,626 WARN org.apache.zookeeper.server.NIOServerCnxn: Exception causing close of session 0x0 due to java.io.IOException: ZooKeeperServer not running
2018-01-11 15:01:54,626 INFO org.apache.zookeeper.server.NIOServerCnxn: Closed socket connection for client /10.200.60.107:50157 (no session established for client)
2018-01-11 15:01:54,628 WARN org.apache.zookeeper.server.NIOServerCnxn: Exception causing close of session 0x0 due to java.io.IOException: ZooKeeperServer not running
2018-01-11 15:01:54,628 INFO org.apache.zookeeper.server.NIOServerCnxn: Closed socket connection for client /10.200.60.100:49602 (no session established for client)
2018-01-11 15:01:54,628 WARN org.apache.zookeeper.server.NIOServerCnxn: Exception causing close of session 0x0 due to java.io.IOException: ZooKeeperServer not running
2018-01-11 15:01:54,628 INFO org.apache.zookeeper.server.NIOServerCnxn: Closed socket connection for client /10.200.60.99:50430 (no session established for client)

...

2018-01-11 15:02:10,323 INFO org.apache.zookeeper.server.NIOServerCnxn: Closed socket connection for client /10.200.60.99:50441 (no session established for client)
2018-01-11 15:02:10,465 WARN org.apache.zookeeper.server.quorum.QuorumCnxManager: Connection broken for id 3, my id = 2, error = 
java.io.EOFException
    at java.io.DataInputStream.readInt(DataInputStream.java:392)
    at org.apache.zookeeper.server.quorum.QuorumCnxManager$RecvWorker.run(QuorumCnxManager.java:747)
2018-01-11 15:02:10,465 WARN org.apache.zookeeper.server.quorum.Learner: Exception when following the leader
java.net.SocketException: Connection reset
    at java.net.SocketInputStream.read(SocketInputStream.java:196)
    at java.net.SocketInputStream.read(SocketInputStream.java:122)
    at java.io.BufferedInputStream.fill(BufferedInputStream.java:235)
    at java.io.BufferedInputStream.read(BufferedInputStream.java:254)
    at java.io.DataInputStream.readInt(DataInputStream.java:387)
    at org.apache.jute.BinaryInputArchive.readInt(BinaryInputArchive.java:63)
    at org.apache.zookeeper.server.quorum.QuorumPacket.deserialize(QuorumPacket.java:83)
    at org.apache.jute.BinaryInputArchive.readRecord(BinaryInputArchive.java:99)
    at org.apache.zookeeper.server.quorum.Learner.readPacket(Learner.java:152)
    at org.apache.zookeeper.server.quorum.Learner.registerWithLeader(Learner.java:272)
    at org.apache.zookeeper.server.quorum.Follower.followLeader(Follower.java:72)
    at org.apache.zookeeper.server.quorum.QuorumPeer.run(QuorumPeer.java:740)
2018-01-11 15:02:10,466 WARN org.apache.zookeeper.server.quorum.QuorumCnxManager: Interrupting SendWorker
2018-01-11 15:02:10,468 WARN org.apache.zookeeper.server.quorum.QuorumCnxManager: Interrupted while waiting for message on queue
java.lang.InterruptedException
    at java.util.concurrent.locks.AbstractQueuedSynchronizer$ConditionObject.reportInterruptAfterWait(AbstractQueuedSynchronizer.java:2017)
    at java.util.concurrent.locks.AbstractQueuedSynchronizer$ConditionObject.awaitNanos(AbstractQueuedSynchronizer.java:2095)
    at java.util.concurrent.ArrayBlockingQueue.poll(ArrayBlockingQueue.java:389)
    at org.apache.zookeeper.server.quorum.QuorumCnxManager.pollSendQueue(QuorumCnxManager.java:831)
    at org.apache.zookeeper.server.quorum.QuorumCnxManager.access$500(QuorumCnxManager.java:62)
    at org.apache.zookeeper.server.quorum.QuorumCnxManager$SendWorker.run(QuorumCnxManager.java:667)
2018-01-11 15:02:10,468 INFO org.apache.zookeeper.server.quorum.Learner: shutdown called
java.lang.Exception: shutdown Follower
    at org.apache.zookeeper.server.quorum.Follower.shutdown(Follower.java:166)
    at org.apache.zookeeper.server.quorum.QuorumPeer.run(QuorumPeer.java:744)
2018-01-11 15:02:10,469 WARN org.apache.zookeeper.server.quorum.QuorumCnxManager: Send worker leaving thread
2018-01-11 15:02:10,470 INFO org.apache.zookeeper.server.quorum.FollowerZooKeeperServer: Shutting down
2018-01-11 15:02:10,470 INFO org.apache.zookeeper.server.ZooKeeperServer: shutting down
2018-01-11 15:02:10,470 INFO org.apache.zookeeper.server.quorum.QuorumPeer: LOOKING
2018-01-11 15:02:10,471 INFO org.apache.zookeeper.server.persistence.FileSnap: Reading snapshot /var/lib/zookeeper/version-2/snapshot.17859dbe1e

2018-01-11 15:02:10,585 INFO org.apache.zookeeper.server.NIOServerCnxn: Closed socket connection for client /10.200.60.100:49788 (no session established for client)

2018-01-11 15:02:10,663 INFO org.apache.zookeeper.server.NIOServerCnxn: Closed socket connection for client /10.200.60.10:58443 (no session established for client)

2018-01-11 15:02:11,008 INFO org.apache.zookeeper.server.NIOServerCnxn: Closed socket connection for client /10.200.60.106:42822 (no session established for client)

2018-01-11 15:02:11,339 INFO org.apache.zookeeper.server.NIOServerCnxn: Closed socket connection for client /10.200.60.107:50190 (no session established for client)

2018-01-11 15:02:12,100 INFO org.apache.zookeeper.server.NIOServerCnxn: Closed socket connection for client /10.200.60.100:49838 (no session established for client)

2018-01-11 15:02:12,823 INFO org.apache.zookeeper.server.NIOServerCnxn: Closed socket connection for client /10.200.60.107:50192 (no session established for client)

2018-01-11 15:02:13,106 INFO org.apache.zookeeper.server.NIOServerCnxn: Closed socket connection for client /10.200.60.100:49851 (no session established for client)

2018-01-11 15:02:13,468 INFO org.apache.zookeeper.server.NIOServerCnxn: Closed socket connection for client /10.200.60.99:50444 (no session established for client)

2018-01-11 15:02:14,167 INFO org.apache.zookeeper.server.NIOServerCnxn: Closed socket connection for client /10.200.60.10:58450 (no session established for client)

2018-01-11 15:02:17,645 INFO org.apache.zookeeper.server.NIOServerCnxn: Closed socket connection for client /10.200.60.100:49878 (no session established for client)

2018-01-11 15:02:18,446 INFO org.apache.zookeeper.server.NIOServerCnxn: Closed socket connection for client /10.200.60.107:50197 (no session established for client)
2018-01-11 15:02:21,618 INFO org.apache.zookeeper.server.quorum.QuorumCnxManager: Received connection request /10.200.60.105:46568
2018-01-11 15:02:21,620 INFO org.apache.zookeeper.server.quorum.FastLeaderElection: Notification: 3 (n.leader), 0x17859dc8b7 (n.zxid), 0x1 (n.round), LOOKING (n.state), 3 (n.sid), 0x17 (n.peerEPoch), LOOKING (my state)

2018-01-11 15:02:22,348 INFO org.apache.zookeeper.server.NIOServerCnxn: Closed socket connection for client /10.200.60.100:49881 (no session established for client)

2018-01-11 15:02:22,349 INFO org.apache.zookeeper.server.NIOServerCnxn: Closed socket connection for client /10.200.60.100:49927 (no session established for client)
2018-01-11 15:02:22,357 WARN org.apache.zookeeper.server.quorum.QuorumCnxManager: Connection broken for id 1, my id = 2, error = 
java.io.EOFException
    at java.io.DataInputStream.readInt(DataInputStream.java:392)
    at org.apache.zookeeper.server.quorum.QuorumCnxManager$RecvWorker.run(QuorumCnxManager.java:747)
2018-01-11 15:02:22,359 WARN org.apache.zookeeper.server.quorum.QuorumCnxManager: Interrupting SendWorker
2018-01-11 15:02:22,359 WARN org.apache.zookeeper.server.quorum.QuorumCnxManager: Interrupted while waiting for message on queue
java.lang.InterruptedException
    at java.util.concurrent.locks.AbstractQueuedSynchronizer$ConditionObject.reportInterruptAfterWait(AbstractQueuedSynchronizer.java:2017)
    at java.util.concurrent.locks.AbstractQueuedSynchronizer$ConditionObject.awaitNanos(AbstractQueuedSynchronizer.java:2095)
    at java.util.concurrent.ArrayBlockingQueue.poll(ArrayBlockingQueue.java:389)
    at org.apache.zookeeper.server.quorum.QuorumCnxManager.pollSendQueue(QuorumCnxManager.java:831)
    at org.apache.zookeeper.server.quorum.QuorumCnxManager.access$500(QuorumCnxManager.java:62)
    at org.apache.zookeeper.server.quorum.QuorumCnxManager$SendWorker.run(QuorumCnxManager.java:667)
2018-01-11 15:02:22,360 WARN org.apache.zookeeper.server.quorum.QuorumCnxManager: Send worker leaving thread

2018-01-11 15:02:22,665 INFO org.apache.zookeeper.server.NIOServerCnxn: Closed socket connection for client /10.200.60.107:50200 (no session established for client)

2018-01-11 15:02:23,238 INFO org.apache.zookeeper.server.NIOServerCnxn: Closed socket connection for client /10.200.60.106:42826 (no session established for client)

2018-01-11 15:02:23,367 INFO org.apache.zookeeper.server.NIOServerCnxn: Closed socket connection for client /10.200.60.107:50201 (no session established for client)

2018-01-11 15:02:23,603 INFO org.apache.zookeeper.server.NIOServerCnxn: Closed socket connection for client /10.200.60.99:50447 (no session established for client)

2018-01-11 15:02:23,648 INFO org.apache.zookeeper.server.NIOServerCnxn: Closed socket connection for client /10.200.60.10:58473 (no session established for client)

2018-01-11 15:02:24,471 INFO org.apache.zookeeper.server.NIOServerCnxn: Closed socket connection for client /10.200.60.100:49956 (no session established for client)

2018-01-11 15:02:25,554 INFO org.apache.zookeeper.server.NIOServerCnxn: Closed socket connection for client /10.200.60.107:50205 (no session established for client)

2018-01-11 15:02:25,554 INFO org.apache.zookeeper.server.NIOServerCnxn: Closed socket connection for client /10.200.60.100:49959 (no session established for client)

2018-01-11 15:02:25,555 INFO org.apache.zookeeper.server.NIOServerCnxn: Closed socket connection for client /10.200.60.100:49961 (no session established for client)
2018-01-11 15:02:25,694 ERROR org.apache.zookeeper.server.persistence.Util: Last transaction was partial.
2018-01-11 15:02:25,695 INFO org.apache.zookeeper.server.quorum.FastLeaderElection: New election. My id =  2, proposed zxid=0x17859dc8b6
2018-01-11 15:02:25,695 WARN org.apache.zookeeper.server.quorum.QuorumCnxManager: Cannot open channel to 1 at election address ddp-hnn-03.cmdmp.com/10.200.60.113:4181
java.net.ConnectException: Connection refused
    at java.net.PlainSocketImpl.socketConnect(Native Method)
    at java.net.AbstractPlainSocketImpl.doConnect(AbstractPlainSocketImpl.java:339)
    at java.net.AbstractPlainSocketImpl.connectToAddress(AbstractPlainSocketImpl.java:200)
    at java.net.AbstractPlainSocketImpl.connect(AbstractPlainSocketImpl.java:182)
    at java.net.SocksSocketImpl.connect(SocksSocketImpl.java:392)
    at java.net.Socket.connect(Socket.java:579)
    at org.apache.zookeeper.server.quorum.QuorumCnxManager.connectOne(QuorumCnxManager.java:354)
    at org.apache.zookeeper.server.quorum.QuorumCnxManager.toSend(QuorumCnxManager.java:327)
    at org.apache.zookeeper.server.quorum.FastLeaderElection$Messenger$WorkerSender.process(FastLeaderElection.java:393)
    at org.apache.zookeeper.server.quorum.FastLeaderElection$Messenger$WorkerSender.run(FastLeaderElection.java:365)
    at java.lang.Thread.run(Thread.java:745)
2018-01-11 15:02:25,696 INFO org.apache.zookeeper.server.quorum.FastLeaderElection: Notification: 3 (n.leader), 0x17859dc8b7 (n.zxid), 0x1 (n.round), LEADING (n.state), 3 (n.sid), 0x17 (n.peerEPoch), LOOKING (my state)
2018-01-11 15:02:25,697 INFO org.apache.zookeeper.server.quorum.FastLeaderElection: Notification: 2 (n.leader), 0x17859dc8b6 (n.zxid), 0x2 (n.round), LOOKING (n.state), 2 (n.sid), 0x17 (n.peerEPoch), LOOKING (my state)
2018-01-11 15:02:25,697 INFO org.apache.zookeeper.server.quorum.FastLeaderElection: Notification: 3 (n.leader), 0x17859dc8b7 (n.zxid), 0x1 (n.round), LEADING (n.state), 3 (n.sid), 0x17 (n.peerEPoch), LOOKING (my state)
2018-01-11 15:02:25,898 INFO org.apache.zookeeper.server.quorum.FastLeaderElection: Notification time out: 400

...

2018-01-11 15:02:32,341 INFO org.apache.zookeeper.server.quorum.FastLeaderElection: Notification: 2 (n.leader), 0x17859dc8b6 (n.zxid), 0x2 (n.round), LOOKING (n.state), 2 (n.sid), 0x17 (n.peerEPoch), LOOKING (my state)
2018-01-11 15:02:32,532 WARN org.apache.zookeeper.server.quorum.QuorumCnxManager: Connection broken for id 3, my id = 2, error = 
java.net.SocketException: Connection reset
    at java.net.SocketInputStream.read(SocketInputStream.java:196)
    at java.net.SocketInputStream.read(SocketInputStream.java:122)
    at java.net.SocketInputStream.read(SocketInputStream.java:210)
    at java.io.DataInputStream.readInt(DataInputStream.java:387)
    at org.apache.zookeeper.server.quorum.QuorumCnxManager$RecvWorker.run(QuorumCnxManager.java:747)
2018-01-11 15:02:32,533 WARN org.apache.zookeeper.server.quorum.QuorumCnxManager: Interrupting SendWorker
2018-01-11 15:02:32,533 WARN org.apache.zookeeper.server.quorum.QuorumCnxManager: Interrupted while waiting for message on queue
java.lang.InterruptedException
    at java.util.concurrent.locks.AbstractQueuedSynchronizer$ConditionObject.reportInterruptAfterWait(AbstractQueuedSynchronizer.java:2017)
    at java.util.concurrent.locks.AbstractQueuedSynchronizer$ConditionObject.awaitNanos(AbstractQueuedSynchronizer.java:2095)
    at java.util.concurrent.ArrayBlockingQueue.poll(ArrayBlockingQueue.java:389)
    at org.apache.zookeeper.server.quorum.QuorumCnxManager.pollSendQueue(QuorumCnxManager.java:831)
    at org.apache.zookeeper.server.quorum.QuorumCnxManager.access$500(QuorumCnxManager.java:62)
    at org.apache.zookeeper.server.quorum.QuorumCnxManager$SendWorker.run(QuorumCnxManager.java:667)
2018-01-11 15:02:32,534 WARN org.apache.zookeeper.server.quorum.QuorumCnxManager: Send worker leaving thread

2018-01-11 15:02:32,722 INFO org.apache.zookeeper.server.NIOServerCnxn: Closed socket connection for client /10.200.60.114:46793 (no session established for client)

2018-01-11 15:02:32,876 INFO org.apache.zookeeper.server.NIOServerCnxn: Closed socket connection for client /10.200.60.100:50012 (no session established for client)
2018-01-11 15:02:34,360 INFO org.apache.zookeeper.server.quorum.QuorumCnxManager: Received connection request /10.200.60.113:54918
2018-01-11 15:02:34,362 INFO org.apache.zookeeper.server.quorum.FastLeaderElection: Notification: 1 (n.leader), 0x17859dc8b7 (n.zxid), 0x1 (n.round), LOOKING (n.state), 1 (n.sid), 0x17 (n.peerEPoch), LOOKING (my state)
2018-01-11 15:02:34,374 INFO org.apache.zookeeper.server.quorum.FastLeaderElection: Notification: 1 (n.leader), 0x17859dc8b7 (n.zxid), 0x2 (n.round), LOOKING (n.state), 1 (n.sid), 0x17 (n.peerEPoch), LOOKING (my state)
2018-01-11 15:02:34,375 INFO org.apache.zookeeper.server.quorum.FastLeaderElection: Notification: 1 (n.leader), 0x17859dc8b7 (n.zxid), 0x2 (n.round), LOOKING (n.state), 2 (n.sid), 0x17 (n.peerEPoch), LOOKING (my state)


2018-01-11 15:02:40,236 INFO org.apache.zookeeper.server.NIOServerCnxn: Closed socket connection for client /10.200.60.100:50074 (no session established for client)
2018-01-11 15:02:43,874 INFO org.apache.zookeeper.server.quorum.QuorumCnxManager: Received connection request /10.200.60.105:46571
2018-01-11 15:02:43,875 INFO org.apache.zookeeper.server.quorum.FastLeaderElection: Notification: 3 (n.leader), 0x17859dc8b7 (n.zxid), 0x1 (n.round), LOOKING (n.state), 3 (n.sid), 0x17 (n.peerEPoch), FOLLOWING (my state)
2018-01-11 15:02:43,878 INFO org.apache.zookeeper.server.quorum.FastLeaderElection: Notification: 3 (n.leader), 0x17859dc8b7 (n.zxid), 0x2 (n.round), LOOKING (n.state), 3 (n.sid), 0x17 (n.peerEPoch), FOLLOWING (my state)
...
INFO org.apache.zookeeper.server.NIOServerCnxnFactory: Accepted socket connection from /10.200.60.170:35995
2018-01-11 15:47:19,303 WARN org.apache.zookeeper.server.NIOServerCnxn: Exception causing close of session 0x0 due to java.io.IOException: ZooKeeperServer not running
2018-01-11 15:47:19,303 INFO org.apache.zookeeper.server.NIOServerCnxn: Closed socket connection for client /10.200.60.170:35995 (no session established for client)
2018-01-11 15:47:19,316 INFO org.apache.zookeeper.server.NIOServerCnxnFactory: Accepted socket connection from /10.200.60.170:35996
2018-01-11 15:47:19,317 WARN org.apache.zookeeper.server.NIOServerCnxn: Exception causing close of session 0x0 due to java.io.IOException: ZooKeeperServer not running
2018-01-11 15:47:19,317 INFO org.apache.zookeeper.server.NIOServerCnxn: Closed socket connection for client /10.200.60.170:35996 (no session established for client)
2018-01-11 15:47:19,430 INFO org.apache.zookeeper.server.NIOServerCnxnFactory: Accepted socket connection from /10.200.60.172:30872
2018-01-11 15:47:19,431 WARN org.apache.zookeeper.server.NIOServerCnxn: Exception causing close of session 0x0 due to java.io.IOException: ZooKeeperServer not running
2018-01-11 15:47:19,431 INFO org.apache.zookeeper.server.NIOServerCnxn: Closed socket connection for client /10.200.60.172:30872 (no session established for client)
2018-01-11 15:47:19,473 INFO org.apache.zookeeper.server.NIOServerCnxnFactory: Accepted socket connection from /10.200.60.170:35997
2018-01-11 15:47:19,473 WARN org.apache.zookeeper.server.NIOServerCnxn: Exception causing close of session 0x0 due to java.io.IOException: ZooKeeperServer not running
2018-01-11 15:47:19,473 INFO org.apache.zookeeper.server.NIOServerCnxn: Closed socket connection for client /10.200.60.170:35997 (no session established for client)
2018-01-11 15:47:19,645 INFO org.apache.zookeeper.server.NIOServerCnxnFactory: Accepted socket connection from /10.200.60.99:56280
2018-01-11 15:47:19,646 WARN org.apache.zookeeper.server.NIOServerCnxn: Exception causing close of session 0x0 due to java.io.IOException: ZooKeeperServer not running
2018-01-11 15:47:19,646 INFO org.apache.zookeeper.server.NIOServerCnxn: Closed socket connection for client /10.200.60.99:56280 (no session established for client)
2018-01-11 15:47:19,670 INFO org.apache.zookeeper.server.NIOServerCnxnFactory: Accepted socket connection from /10.200.60.170:36001
```
一个 ZooKeeper 的节点（ znode ）存储两部分内容：数据和状态，状态中包含 ACL 信息。创建一个 znode 会产生一个 ACL 列表，列表中每个 ACL 包括

需要统计分区(partition)数超过1000的表名,因为后续数据迁移过程中需要对其拆分

虽然每次建表

## 尤其是某些多级分区的hql
```
PARTITIONED BY (                                   
   `src_file_day` string,                           
   `src_file_hour` string,                          
   `grain_ind` string)                              
 ROW FORMAT SERDE 
```

后续:
完成集群数据梳理工作，包括HDFS数据，Hive数据，重点的目录以及table,同时hive部分table的partition数目过多，导致Zookeeper snapshot占用空间异常大大，并且给ZK内存带来压力。后续需要开发人员对Partition进行修改。梳理出所有影响Zookeeper服务的所有table,下线所有不合理的任务流程,没有整改前全部不允许在生产环境调用

## 列出hive元数据库中所有表所拥有的分区个数
`use metastore;select d.NAME, a.TBL_NAME, b.count, c.LOCATION from TBLS a join (select TBL_ID,count(*) as count from PARTITIONS group by TBL_ID ) b join SDS c join DBS d where a.TBL_ID=b.TBL_ID and a.SD_ID=c.SD_ID and a.DB_ID=d.DB_ID order by b.count;`


## 列出hive元数据库中单个database中所有表所拥有的分区个数
`use metastore;select d.NAME, a.TBL_NAME, b.count, c.LOCATION from TBLS a join (select TBL_ID,count(*) as count from PARTITIONS group by TBL_ID ) b join SDS c join DBS d on a.TBL_ID=b.TBL_ID and a.SD_ID=c.SD_ID and a.DB_ID=d.DB_ID and d.NAME='dly' order by b.count;`