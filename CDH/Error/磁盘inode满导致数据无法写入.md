# 磁盘inode满导致数据无法写入
BDI的一个工作节点,报错数据没有空间写入,但是通过命令df查看磁盘空间还有剩余,当前目录文件数目也没有超过最大限制,
最后发现是分区inode满了导致
https://www.ibm.com/developerworks/cn/aix/library/au-speakingunix14/

同时bdi的调度,虽然服务停止了之前的调度任务被分配到该节点的话就不会自动选择其他正常工作的节点了