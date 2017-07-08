title: swap 系统值修改
categories: 
- CDH
- Error
date: 2017-05-24
---
# Impala swapp系统值修改
>部分组件HDFS,YARN,HBAS有黄色警告是因为系统默认SWAP默认值为60

导致内存未使用满便使用swap memory导致的，已经修改过配对应系统的配置值为SWAP=0。
```
echo 0 >/proc/sys/vm/swappiness
echo 'vm.swappiness=0'>> /etc/sysctl.conf
cat /proc/sys/vm/swappiness
```