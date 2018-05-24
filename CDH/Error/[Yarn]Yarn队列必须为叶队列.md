title: Yarn队列必须为叶队列
categories: [CDH,YARN]
date: 2017-10-14
---
## Yarn队列必须为叶队列

```
INFO  : Compiling command(queryId=hive_20171014104747_ef9adfe5-dd2b-493b-8557-7bce196ebf06): select count(*) from cdmp_dw.td_cms_content_class_d where src_file_day='20171013' limit 10
INFO  : Semantic Analysis Completed
INFO  : Returning Hive schema: Schema(fieldSchemas:[FieldSchema(name:_c0, type:bigint, comment:null)], properties:null)
INFO  : Completed compiling command(queryId=hive_20171014104747_ef9adfe5-dd2b-493b-8557-7bce196ebf06); Time taken: 0.214 seconds
INFO  : Executing command(queryId=hive_20171014104747_ef9adfe5-dd2b-493b-8557-7bce196ebf06): select count(*) from cdmp_dw.td_cms_content_class_d where src_file_day='20171013' limit 10
INFO  : Query ID = hive_20171014104747_ef9adfe5-dd2b-493b-8557-7bce196ebf06
INFO  : Total jobs = 1
INFO  : Launching Job 1 out of 1
INFO  : Starting task [Stage-1:MAPRED] in serial mode
INFO  : Number of reduce tasks determined at compile time: 1
INFO  : In order to change the average load for a reducer (in bytes):
INFO  :   set hive.exec.reducers.bytes.per.reducer=<number>
INFO  : In order to limit the maximum number of reducers:
INFO  :   set hive.exec.reducers.max=<number>
INFO  : In order to set a constant number of reducers:
INFO  :   set mapreduce.job.reduces=<number>
INFO  : number of splits:10
INFO  : Submitting tokens for job: job_1507886429302_10129
INFO  : Kind: HDFS_DELEGATION_TOKEN, Service: ha-hdfs:ns1, Ident: (token for hive: HDFS_DELEGATION_TOKEN owner=hive/ddp-cm.cmdmp.com@CMDMP.COM, renewer=yarn, realUser=, issueDate=1507949231769, maxDate=1508554031769, sequenceNumber=5622438, masterKeyId=763)
INFO  : Cleaning up the staging area /user/hive/.staging/job_1507886429302_10129
ERROR : Job Submission failed with exception 'java.io.IOException(org.apache.hadoop.yarn.exceptions.YarnException: Failed to submit application_1507886429302_10129 to YARN : root.users.cdmpview is not a leaf queue)'
java.io.IOException: org.apache.hadoop.yarn.exceptions.YarnException: Failed to submit application_1507886429302_10129 to YARN : root.users.cdmpview is not a leaf queue
	at org.apache.hadoop.mapred.YARNRunner.submitJob(YARNRunner.java:306)
	at org.apache.hadoop.mapreduce.JobSubmitter.submitJobInternal(JobSubmitter.java:244)
	at org.apache.hadoop.mapreduce.Job$10.run(Job.java:1307)
	at org.apache.hadoop.mapreduce.Job$10.run(Job.java:1304)
	at java.security.AccessController.doPrivileged(Native Method)
	at javax.security.auth.Subject.doAs(Subject.java:415)
	at org.apache.hadoop.security.UserGroupInformation.doAs(UserGroupInformation.java:1796)
	at org.apache.hadoop.mapreduce.Job.submit(Job.java:1304)
	at org.apache.hadoop.mapred.JobClient$1.run(JobClient.java:578)
	at org.apache.hadoop.mapred.JobClient$1.run(JobClient.java:573)
	at java.security.AccessController.doPrivileged(Native Method)
	at javax.security.auth.Subject.doAs(Subject.java:415)
	at org.apache.hadoop.security.UserGroupInformation.doAs(UserGroupInformation.java:1796)
	at org.apache.hadoop.mapred.JobClient.submitJobInternal(JobClient.java:573)
	at org.apache.hadoop.mapred.JobClient.submitJob(JobClient.java:564)
	at org.apache.hadoop.hive.ql.exec.mr.ExecDriver.execute(ExecDriver.java:418)
	at org.apache.hadoop.hive.ql.exec.mr.MapRedTask.execute(MapRedTask.java:142)
	at org.apache.hadoop.hive.ql.exec.Task.executeTask(Task.java:214)
	at org.apache.hadoop.hive.ql.exec.TaskRunner.runSequential(TaskRunner.java:100)
	at org.apache.hadoop.hive.ql.Driver.launchTask(Driver.java:1976)
	at org.apache.hadoop.hive.ql.Driver.execute(Driver.java:1689)
	at org.apache.hadoop.hive.ql.Driver.runInternal(Driver.java:1421)
	at org.apache.hadoop.hive.ql.Driver.run(Driver.java:1205)
	at org.apache.hadoop.hive.ql.Driver.run(Driver.java:1200)
	at org.apache.hive.service.cli.operation.SQLOperation.runQuery(SQLOperation.java:237)
	at org.apache.hive.service.cli.operation.SQLOperation.access$300(SQLOperation.java:88)
	at org.apache.hive.service.cli.operation.SQLOperation$3$1.run(SQLOperation.java:293)
	at java.security.AccessController.doPrivileged(Native Method)
	at javax.security.auth.Subject.doAs(Subject.java:415)
	at org.apache.hadoop.security.UserGroupInformation.doAs(UserGroupInformation.java:1796)
	at org.apache.hive.service.cli.operation.SQLOperation$3.run(SQLOperation.java:306)
	at java.util.concurrent.Executors$RunnableAdapter.call(Executors.java:471)
	at java.util.concurrent.FutureTask.run(FutureTask.java:262)
	at java.util.concurrent.ThreadPoolExecutor.runWorker(ThreadPoolExecutor.java:1145)
	at java.util.concurrent.ThreadPoolExecutor$Worker.run(ThreadPoolExecutor.java:615)
	at java.lang.Thread.run(Thread.java:745)
Caused by: org.apache.hadoop.yarn.exceptions.YarnException: Failed to submit application_1507886429302_10129 to YARN : root.users.cdmpview is not a leaf queue
	at org.apache.hadoop.yarn.client.api.impl.YarnClientImpl.submitApplication(YarnClientImpl.java:257)
	at org.apache.hadoop.mapred.ResourceMgrDelegate.submitApplication(ResourceMgrDelegate.java:290)
	at org.apache.hadoop.mapred.YARNRunner.submitJob(YARNRunner.java:290)
	... 35 more

ERROR : FAILED: Execution Error, return code 1 from org.apache.hadoop.hive.ql.exec.mr.MapRedTask
INFO  : Completed executing command(queryId=hive_20171014104747_ef9adfe5-dd2b-493b-8557-7bce196ebf06); Time taken: 1.268 seconds
Query History  

```