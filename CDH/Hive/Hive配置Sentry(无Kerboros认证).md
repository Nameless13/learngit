title: Hive集成Sentry(无Kerboros认证)
categories: [CDH,Hive]
date: 2017-06-30
---
# Hive集成Sentry(无Kerboros认证)
1. 在集群中添加Sentry服务
    -  sentry-site.xml 的 Sentry 客户端高级配置代码段（安全阀）
        +  `<property><name>sentry.hive.testing.mode</name><value>true</value></property>`
2. 在hive服务中修改配置
    - 开启sentry服务
    - 关闭impersonation选项
    - sentry-site.xml 的 Hive 服务高级配置代码段（安全阀）
        + `<property><name>sentry.hive.testing.mode</name><value>true</value><description>强制开启sentry模式</description></property>`
    + hive-site.xml 的 Hive Metastore Server 高级配置代码段（安全阀）
        * `<property><name>hive.insert.into.multilevel.dirs</name><value>true</value><description>hive MoveTask报错</description></property><property><name>hive.reloadable.aux.jars.path</name><value>/opt/local/hive/reloadable</value><final>true</final><description>reload jar</description></property><property><name>hive.metastore.pre.event.listeners</name><value>org.apache.sentry.binding.metastore.MetastoreAuthzBinding</value><final>true</final><description>强制开启sentry</description></property><property><name>hive.metastore.event.listeners</name><value>org.apache.sentry.binding.metastore.SentryMetastorePostEventListener</value><final>true</final><description>强制开启sentry</description></property>`
    - hive-site.xml 的 HiveServer2 高级配置代码段（安全阀）
        + `<property><name>hive.server2.enable.impersonation</name><value>true</value></property><property><name>hive.security.authorization.task.factory</name><value>org.apache.sentry.binding.hive.SentryHiveAuthorizationTaskFactoryImpl</value></property><property><name>hive.server2.session.hook</name><value>org.apache.sentry.binding.hive.HiveAuthzBindingSessionHook</value></property>`
3. 在HDFS中可以选择将Hive的权限同步到HDFS上，但是该选项不支持两个Metastore的配置方式，另外启用HDFS ACL提供HDFS上更多的授权
    - 启用访问控制列表
    - 启动Sentry同步

beeline 连接:
`beeline -u "jdbc:hive2://10.200.65.40:10000/" -n hive -p hive -d org.apache.hive.jdbc.HiveDriver`
创建admin role;
```
create role admin;
grant all on server server1 to role admin;
grant role admin to group hive;
```
