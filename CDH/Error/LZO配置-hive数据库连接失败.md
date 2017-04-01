# LZO压缩文件支持

ddp-dn-02:~ # klist
klist: No credentials cache found (ticket cache FILE:/tmp/krb5cc_0)


Kerberos 4 ticket cache: /tmp/tkt0
klist: You have no tickets cached
ddp-dn-02:~ # 
ddp-dn-02:~ # 
ddp-dn-02:~ # kinit hive
kinit(v5): Client not found in Kerberos database while getting initial credentials
ddp-dn-02:~ # 
ddp-dn-02:~ # 
ddp-dn-02:~ # kinit hdfs
Password for hdfs@CMDMP.COM: 
ddp-dn-02:~ # klist
Ticket cache: FILE:/tmp/krb5cc_0
Default principal: hdfs@CMDMP.COM

Valid starting     Expires            Service principal
03/26/17 18:52:01  03/27/17 18:52:01  krbtgt/CMDMP.COM@CMDMP.COM
	renew until 04/02/17 18:52:01


Kerberos 4 ticket cache: /tmp/tkt0
klist: You have no tickets cached
ddp-dn-02:~ # hive

Logging initialized using configuration in jar:file:/opt/cloudera/parcels/CDH-5.10.0-1.cdh5.10.0.p0.41/jars/hive-common-1.1.0-cdh5.10.0.jar!/hive-log4j.properties
[INFO] Unable to bind key for unsupported operation: backward-delete-word
[INFO] Unable to bind key for unsupported operation: backward-delete-word
[INFO] Unable to bind key for unsupported operation: down-history
[INFO] Unable to bind key for unsupported operation: up-history
[INFO] Unable to bind key for unsupported operation: up-history
[INFO] Unable to bind key for unsupported operation: down-history
[INFO] Unable to bind key for unsupported operation: up-history
[INFO] Unable to bind key for unsupported operation: down-history
[INFO] Unable to bind key for unsupported operation: up-history
[INFO] Unable to bind key for unsupported operation: down-history
[INFO] Unable to bind key for unsupported operation: up-history
[INFO] Unable to bind key for unsupported operation: down-history
WARNING: Hive CLI is deprecated and migration to Beeline is recommended.
hive> 





Logging initialized using configuration in jar:file:/opt/cloudera/parcels/CDH-5.10.0-1.cdh5.10.0.p0.41/jars/hive-common-1.1.0-cdh5.10.0.jar!/hive-log4j.properties


hive> show databases;
OK
Failed with exception java.io.IOException:java.lang.RuntimeException: Error in configuring object
Time taken: 1.541 seconds
hive> show tables;
OK
Failed with exception java.io.IOException:java.lang.RuntimeException: Error in configuring object
Time taken: 0.071 seconds
hive> 


