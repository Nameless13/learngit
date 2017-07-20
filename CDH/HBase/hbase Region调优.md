title: hbase Region调优
categories: [CDH,HBase]
date: 2017-07-07
---
# hbase Region调优
在hbase shell 中输入:
`balance_switch true`

在滚动重启的时候 会有如下警告:
    The Load Balancer is not enabled which will eventually cause performance degradation in HBase as Regions will not be distributed across all RegionServers. The balancer is only expected to be disabled during rolling upgrade scenarios. 
说明重启过程中改变这个参数 之前由于重启失败导致 region balance这个默认参数被改为false后,没能自动恢复

但是设置为true后依然没有平衡,最终重启master(leader)后,新的master开始触发平衡,说明之前的master不正常工作了