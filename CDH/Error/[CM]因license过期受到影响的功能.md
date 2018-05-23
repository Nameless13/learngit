title: 因license过期受到影响的功能
categories: [CDH,Error]
date: 2017-05-24
---

# 因license过期受到影响的功能
1. 为Cloudera Manager配置外部验证功能

    Cloudera Manager支持对内部数据库和外部服务的用户身份验证。

2. 查看和恢复配置更改功能

    无论何时更改并保存服务或角色实例或主机的一组配置设置，Cloudera Manager将保存先前设置的修订版本和进行更改的用户的名称。然后，您可以查看配置设置的过去版本，如果需要，将设置回滚到之前的状态。

3. 配置警报SNMP通知和配置自定义警报脚本功能
4. 备份和灾难恢复功能

    Cloudera Manager能够跨数据中心复制并进行灾难恢复。 复制包括存储在HDFS中的数据，Hive表中存储的数据，Hive转移数据以及与Hive转移中注册的Impala表相关联的Impala元数据（catalog server metadata）。

5. Reports功能

    “报告”页面会根据用户，组或目录在群集数据大小和文件数量来创建有关HDFS使用情况的报告。它还可以让用户根据集群中的MapReduce活动进行报告。

6. 一些管理命令比如Rolling Restart,History and Rollback,Send Diagnostic Data 无法使用
7. 集群利用率报告功能

### 目前已经影响使用的功能
8. Cloudera Navigator功能

    Cloudera Navigator是于Hadoop平台的完全集成的数据管理和安全系统,目前不可用,同时影响正常使用
    
    1. RegionServer,Hue Server,Navigator Metadata Server,,ImpalaOozie,ZooKeeper审计功能失效
    2. 授权和审计。配置身份验证，户和服务未证明身份之前将无法访问群集。授权机制，可以为用户和用户组分配权限。设置审计程序来跟踪谁访问集群,目前均失效
    3. NameNode节点的audit log提交后无法得到正确响应(正确响应后会删除本地log),导致NameNode节点的log越积越多,同时Navigator节点也不断接受log导致两个host的磁盘空间经常告警(通过修改hdfs配置,暂时关闭该服务)

9. 怀疑机器加入集群时候受影响
