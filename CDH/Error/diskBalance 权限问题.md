diskBalance 权限问题
create role hdfs_role;
grant role hdfs_role to group hdfs;
grant all on URI 'hdfs:///system/diskbalancer' to role hdfs_role;


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