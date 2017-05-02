# hive Sentry用户授权配置
## 为Hive用户添加全局的权限。
目前的管理员为Hive，用户授权的操作都需要由Hive完成。这里使用Hive用户的Kerberos账户进入Beeline
为hive用户获取principal 
`kinit -kt hive.keytab  hive`

列出了当前缓存中保存的Kerberos主体和Kerberos principal
`klist`

由于我们使用的是sentry基于数据库的存储方式,我们直接建在了hive的元数据库中
`beeline -u 'jdbc:hive2://10.200.65.50:10000/rptdata;principal=hive/ddp-cm.cmdmp.com@CMDMP.COM'`

在beeline中，添加管理员角色，然后将Sentry服务器上的所有权限付给hive用户，然后将admin的角色赋给hive组，让hive组能够自由的建立数据库。

### 创建角色声明
语句创建一个可以授予权限的角色。权限可以授予角色，然后可以将其分配给用户。已分配角色的用户只能行使该角色的权限。
只有具有管理权限的用户才能创建/删除角色。默认情况下hive, impala 和 hue用户在Sentry中拥有管理员权限。(然而并没有)

`CREATE ROLE [role_name];`

### 删除角色声明
一旦删除，该角色将被撤销给以前分配给它的所有用户。已经执行的查询不会受到影响。但是，由于Hive在执行每个查询之前检查用户权限，因此角色已启用的活动用户会话将受到影响。

`DROP ROLE [role_name];`

### 授权角色声明
只有Sentry管理员用户可以将角色授予组。

`GRANT ROLE role_name [, role_name] TO GROUP <groupName> [,GROUP <groupName>]`

### 撤销角色声明
可用于从组中撤销角色。只有Sentry管理员用户可以从组中撤销该角色。

`REVOKE ROLE role_name [, role_name] FROM GROUP <groupName> [,GROUP <groupName>]`

### 赋予角色权限声明
用户必须是Sentry admin用户。
`GRANT <PRIVILEGE> [, <PRIVILEGE> ] ON <OBJECT> <object_name> TO ROLE <roleName> [,ROLE <roleName>]`

### 赋予角色外部表权限
`GRANT ALL ON URI 'hdfs://namenode:XXX/path/to/table'`

`grant all on URI 'hdfs://nameservice1/user/thadoop/ods' to role thadoop`

### 撤销角色权限
只有Sentry管理员用户可以从组中撤销权限
`REVOKE <PRIVILEGE> [, <PRIVILEGE> ] ON <OBJECT> <object_name> FROM ROLE <roleName> [,ROLE <roleName>]`

### 指定角色声明
用于指定当前会话启用的角色。用户只能启用已授予他们的角色。任何未列出，尚未启用的角色均将禁用当前会话。如果没有指定启用任何角色，用户将具有由他所属的所有角色授予的权限。
- 启用特定角色
`SET ROLE <roleName>;`
- 启用所有角色：
`SET ROLE ALL;`
- 未启用角色：
`SET ROLE NONE;`

### show声明
- 列出当前用户具有数据库，表或列级访问的数据库：
`SHOW DATABASES;`
- 列出当前用户具有表或列级访问权限的表：
`SHOW TABLES;`
- 列出当前用户拥有的列的访问：
`SHOW COLUMNS;`
- 列出系统中的所有角色（仅适用于哨兵管理员用户）：
`SHOW ROLES;`
- 列出当前用户会话有效的所有角色：
`SHOW CURRENT ROLES;`
- 列出分配给给定的所有角色 <groupName> （仅允许Sentry管理员用户和属于指定的组的其他用户 <groupName>）：
`SHOW ROLE GRANT GROUP <groupName>;`
- SHOW语句也可以用于列出授予角色的特权或给予特定对象的角色的所有特权
`SHOW GRANT ROLE <roleName>;`
- 列出给定的角色的所有授权
`SHOW GRANT ROLE <roleName> on OBJECT <objectName>;`

##操作样例:
```
0: jdbc:hive2://10.200.65.50:10000/rptdata> create role test_role;
0: jdbc:hive2://10.200.65.50:10000/rptdata> grant all on server hive to role test_role;
0: jdbc:hive2://10.200.65.50:10000/rptdata> show roles;
+---------------+--+
|     role      |
+---------------+--+
| test_role     |
| thadoop       |
| admin_role    |
| thadoop_role  |
+---------------+--+
4 rows selected (0.179 seconds)
0: jdbc:hive2://10.200.65.50:10000/rptdata> show grant role test_role;
+-----------+--------+------------+---------+-----------------+-----------------+------------+---------------+-------------------+----------+--+
| database  | table  | partition  | column  | principal_name  | principal_type  | privilege  | grant_option  |    grant_time     | grantor  |
+-----------+--------+------------+---------+-----------------+-----------------+------------+---------------+-------------------+----------+--+
| *         |        |            |         | test_role       | ROLE            | *          | false         | 1493690779745000  | --       |
+-----------+--------+------------+---------+-----------------+-----------------+------------+---------------+-------------------+----------+--+
1 row selected (0.146 seconds)
0: jdbc:hive2://10.200.65.50:10000/rptdata> show grant role admin_role;

+-----------+--------+------------+---------+-----------------+-----------------+------------+---------------+-------------------+----------+--+
| database  | table  | partition  | column  | principal_name  | principal_type  | privilege  | grant_option  |    grant_time     | grantor  |
+-----------+--------+------------+---------+-----------------+-----------------+------------+---------------+-------------------+----------+--+
| *         |        |            |         | admin_role      | ROLE            | *          | false         | 1490532327514000  | --       |
+-----------+--------+------------+---------+-----------------+-----------------+------------+---------------+-------------------+----------+--+
1 row selected (0.167 seconds)

0: jdbc:hive2://10.200.65.50:10000/rptdata> drop role test_role;
0: jdbc:hive2://10.200.65.50:10000/rptdata> show roles;
+---------------+--+
|     role      |
+---------------+--+
| thadoop       |
| admin_role    |
| thadoop_role  |
+---------------+--+
0: jdbc:hive2://10.200.65.50:10000/rptdata> grant select on database rpt to role thadoop;
0: jdbc:hive2://10.200.65.50:10000/rptdata> grant insert on database rpt to role thadoop;
0: jdbc:hive2://10.200.65.50:10000/rptdata> grant all on database rptdata to role thadoop;

#对于建表权限 必须先把要要建的表的权限赋给相应的role
0: jdbc:hive2://10.200.65.50:10000/rptdata> grant all on database ods to role thadoop;
0: jdbc:hive2://10.200.65.50:10000/rptdata> show grant role thadoop;
+---------------------------------------+-----------------------------------+------------+---------+-----------------+-----------------+------------+---------------+-------------------+----------+--+
|               database                |               table               | partition  | column  | principal_name  | principal_type  | privilege  | grant_option  |    grant_time     | grantor  |
+---------------------------------------+-----------------------------------+------------+---------+-----------------+-----------------+------------+---------------+-------------------+----------+--+
| hdfs://nameservice1/user/thadoop/ods  |                                   |            |         | thadoop         | ROLE            | *          | false         | 1493369887314000  | --       |
| ods                                   | pub_50118_visit_log_voms_tour_ex  |            |         | thadoop         | ROLE            | select     | false         | 1492593741232000  | --       |
| rptdata                               |                                   |            |         | thadoop         | ROLE            | *          | false         | 1492619387707000  | --       |
| rpt                                   |                                   |            |         | thadoop         | ROLE            | *          | false         | 1493023378368000  | --       |
| ods                                   |                                   |            |         | thadoop         | ROLE            | *          | false         | 1493369642620000  | --       |
+---------------------------------------+-----------------------------------+------------+---------+-----------------+-----------------+------------+---------------+-------------------+----------+--+
5 rows selected (0.159 seconds)
0: jdbc:hive2://10.200.65.50:10000/rptdata> use ods;
0: jdbc:hive2://10.200.65.50:10000/rptdata> revoke select on table pub_50118_visit_log_voms_tour_ex from role thadoop;
0: jdbc:hive2://10.200.65.50:10000/rptdata> show grant role thadoop;
+---------------------------------------+--------+------------+---------+-----------------+-----------------+------------+---------------+-------------------+----------+--+
|               database                | table  | partition  | column  | principal_name  | principal_type  | privilege  | grant_option  |    grant_time     | grantor  |
+---------------------------------------+--------+------------+---------+-----------------+-----------------+------------+---------------+-------------------+----------+--+
| ods                                   |        |            |         | thadoop         | ROLE            | *          | false         | 1493369642620000  | --       |
| hdfs://nameservice1/user/thadoop/ods  |        |            |         | thadoop         | ROLE            | *          | false         | 1493369887314000  | --       |
| rptdata                               |        |            |         | thadoop         | ROLE            | *          | false         | 1492619387707000  | --       |
| rpt                                   |        |            |         | thadoop         | ROLE            | *          | false         | 1493023378368000  | --       |
+---------------------------------------+--------+------------+---------+-----------------+-----------------+------------+---------------+-------------------+----------+--+
4 rows selected (0.142 seconds)
```


#### 此外发现hive开启sentry后 hue中对应的用户也得是sentry最终授权的用户,否则将无法访问元数据

