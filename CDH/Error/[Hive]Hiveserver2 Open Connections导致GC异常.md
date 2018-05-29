title: Hiveserver2 Open Connections导致GC异常
categories: [CDH,Error]
date: 2018-05-25 14:50:09
---
# hiveserver2 GC异常 

发现hiverserver2 GC时间超时,重启实例后故障修复,之后排查日志和监控后发现每两小时其中一个hiveserver2中的
Open Connections达到上限100,Open Operations 突增到800,大概持续15min左右,如果这时候负载高的话,很有可能GC就出现问题,之后和开发定位到具体流程,由于开发这个流程的开发已经离职并且目前也不再需要该流程,便做下线处理,观察下线后之后的指标趋势正常




```
3月 1, 晚上11点05:21.293分   INFO    org.apache.hadoop.hive.ql.Driver    
[HiveServer2-Handler-Pool: Thread-7291541]: Compiling command(queryId=hive_20180301230505_ea12c229-3d8e-4790-b386-40cdf3f7b76e): DESCRIBE FORMATTED `cdmp_dw`.`t2`
3月 1, 晚上11点05:21.293分   INFO    org.apache.hadoop.hive.ql.log.PerfLogger    
[HiveServer2-Handler-Pool: Thread-7291541]: <PERFLOG method=parse from=org.apache.hadoop.hive.ql.Driver>
3月 1, 晚上11点05:21.293分   INFO    org.apache.hadoop.hive.ql.log.PerfLogger    
[HiveServer2-Handler-Pool: Thread-7291541]: </PERFLOG method=parse start=1519916721293 end=1519916721293 duration=0 from=org.apache.hadoop.hive.ql.Driver>
3月 1, 晚上11点05:21.293分   INFO    org.apache.hadoop.hive.ql.log.PerfLogger    
[HiveServer2-Handler-Pool: Thread-7291541]: <PERFLOG method=semanticAnalyze from=org.apache.hadoop.hive.ql.Driver>
3月 1, 晚上11点05:21.313分   INFO    org.apache.sentry.binding.hive.conf.HiveAuthzConf   
[HiveServer2-Handler-Pool: Thread-7291541]: DefaultFS: hdfs://ns1
3月 1, 晚上11点05:21.327分   INFO    org.apache.sentry.binding.hive.conf.HiveAuthzConf   
[HiveServer2-Handler-Pool: Thread-7291541]: DefaultFS: hdfs://ns1
3月 1, 晚上11点05:21.328分   WARN    org.apache.sentry.binding.hive.conf.HiveAuthzConf   
[HiveServer2-Handler-Pool: Thread-7291541]: Using the deprecated config setting hive.sentry.server instead of sentry.hive.server
3月 1, 晚上11点05:21.328分   WARN    org.apache.sentry.binding.hive.conf.HiveAuthzConf   
[HiveServer2-Handler-Pool: Thread-7291541]: Using the deprecated config setting hive.sentry.provider instead of sentry.provider
3月 1, 晚上11点05:21.344分   ERROR   hive.ql.metadata.Hive   
[HiveServer2-Handler-Pool: Thread-7291541]: Table cdmp_dw not found: cdmp_dw.cdmp_dw table not found
3月 1, 晚上11点05:21.348分   ERROR   hive.ql.metadata.Hive   
[HiveServer2-Handler-Pool: Thread-7291541]: Table cdmp_dw not found: cdmp_dw.cdmp_dw table not found
3月 1, 晚上11点05:21.352分   ERROR   org.apache.hadoop.hive.ql.Driver    
[HiveServer2-Handler-Pool: Thread-7291541]: FAILED: SemanticException [Error 10001]: Table not found cdmp_dw.t2
org.apache.hadoop.hive.ql.parse.SemanticException: Table not found cdmp_dw.t2
    at org.apache.hadoop.hive.ql.parse.BaseSemanticAnalyzer.getTable(BaseSemanticAnalyzer.java:1345)
    at org.apache.hadoop.hive.ql.parse.BaseSemanticAnalyzer.getTable(BaseSemanticAnalyzer.java:1324)
    at org.apache.hadoop.hive.ql.parse.DDLSemanticAnalyzer.analyzeDescribeTable(DDLSemanticAnalyzer.java:2027)
    at org.apache.hadoop.hive.ql.parse.DDLSemanticAnalyzer.analyzeInternal(DDLSemanticAnalyzer.java:317)
    at org.apache.hadoop.hive.ql.parse.BaseSemanticAnalyzer.analyze(BaseSemanticAnalyzer.java:223)
    at org.apache.hadoop.hive.ql.Driver.compile(Driver.java:490)
    at org.apache.hadoop.hive.ql.Driver.compileInternal(Driver.java:1276)
    at org.apache.hadoop.hive.ql.Driver.compileAndRespond(Driver.java:1263)
    at org.apache.hive.service.cli.operation.SQLOperation.prepare(SQLOperation.java:186)
    at org.apache.hive.service.cli.operation.SQLOperation.runInternal(SQLOperation.java:267)
    at org.apache.hive.service.cli.operation.Operation.run(Operation.java:337)
    at org.apache.hive.service.cli.session.HiveSessionImpl.executeStatementInternal(HiveSessionImpl.java:439)
    at org.apache.hive.service.cli.session.HiveSessionImpl.executeStatement(HiveSessionImpl.java:405)
    at org.apache.hive.service.cli.CLIService.executeStatement(CLIService.java:257)
    at org.apache.hive.service.cli.thrift.ThriftCLIService.ExecuteStatement(ThriftCLIService.java:501)
    at org.apache.hive.service.cli.thrift.TCLIService$Processor$ExecuteStatement.getResult(TCLIService.java:1313)
    at org.apache.hive.service.cli.thrift.TCLIService$Processor$ExecuteStatement.getResult(TCLIService.java:1298)
    at org.apache.thrift.ProcessFunction.process(ProcessFunction.java:39)
    at org.apache.thrift.TBaseProcessor.process(TBaseProcessor.java:39)
    at org.apache.hadoop.hive.thrift.HadoopThriftAuthBridge$Server$TUGIAssumingProcessor.process(HadoopThriftAuthBridge.java:746)
    at org.apache.thrift.server.TThreadPoolServer$WorkerProcess.run(TThreadPoolServer.java:286)
    at java.util.concurrent.ThreadPoolExecutor.runWorker(ThreadPoolExecutor.java:1145)
    at java.util.concurrent.ThreadPoolExecutor$Worker.run(ThreadPoolExecutor.java:615)
    at java.lang.Thread.run(Thread.java:745)

3月 1, 晚上11点05:21.352分   INFO    org.apache.hadoop.hive.ql.log.PerfLogger    
[HiveServer2-Handler-Pool: Thread-7291541]: </PERFLOG method=compile start=1519916721293 end=1519916721352 duration=59 from=org.apache.hadoop.hive.ql.Driver>
3月 1, 晚上11点05:21.352分   INFO    org.apache.hadoop.hive.ql.log.PerfLogger    
[HiveServer2-Handler-Pool: Thread-7291541]: </PERFLOG method=compile start=1519916721293 end=1519916721352 duration=59 from=org.apache.hadoop.hive.ql.Driver>
3月 1, 晚上11点05:21.352分   INFO    org.apache.hadoop.hive.ql.Driver    
[HiveServer2-Handler-Pool: Thread-7291541]: Completed compiling command(queryId=hive_20180301230505_ea12c229-3d8e-4790-b386-40cdf3f7b76e); Time taken: 0.059 seconds
3月 1, 晚上11点05:21.352分   INFO    org.apache.hadoop.hive.ql.log.PerfLogger    
[HiveServer2-Handler-Pool: Thread-7291541]: <PERFLOG method=releaseLocks from=org.apache.hadoop.hive.ql.Driver>
3月 1, 晚上11点05:21.352分   INFO    org.apache.hadoop.hive.ql.log.PerfLogger    
[HiveServer2-Handler-Pool: Thread-7291541]: </PERFLOG method=releaseLocks start=1519916721352 end=1519916721352 duration=0 from=org.apache.hadoop.hive.ql.Driver>
3月 1, 晚上11点05:21.353分   INFO    org.apache.hive.service.cli.operation.OperationManager  
[HiveServer2-Handler-Pool: Thread-7291541]: Closing operation: OperationHandle [opType=EXECUTE_STATEMENT, getHandleIdentifier()=117fb698-54af-473e-8072-97f413c8758c]
3月 1, 晚上11点05:21.353分   WARN    org.apache.hive.service.cli.thrift.ThriftCLIService 
[HiveServer2-Handler-Pool: Thread-7291541]: Error executing statement: 
org.apache.hive.service.cli.HiveSQLException: Error while compiling statement: FAILED: SemanticException [Error 10001]: Table not found cdmp_dw.t2
    at org.apache.hive.service.cli.operation.Operation.toSQLException(Operation.java:400)
    at org.apache.hive.service.cli.operation.SQLOperation.prepare(SQLOperation.java:188)
    at org.apache.hive.service.cli.operation.SQLOperation.runInternal(SQLOperation.java:267)
    at org.apache.hive.service.cli.operation.Operation.run(Operation.java:337)
    at org.apache.hive.service.cli.session.HiveSessionImpl.executeStatementInternal(HiveSessionImpl.java:439)
    at org.apache.hive.service.cli.session.HiveSessionImpl.executeStatement(HiveSessionImpl.java:405)
    at org.apache.hive.service.cli.CLIService.executeStatement(CLIService.java:257)
    at org.apache.hive.service.cli.thrift.ThriftCLIService.ExecuteStatement(ThriftCLIService.java:501)
    at org.apache.hive.service.cli.thrift.TCLIService$Processor$ExecuteStatement.getResult(TCLIService.java:1313)
    at org.apache.hive.service.cli.thrift.TCLIService$Processor$ExecuteStatement.getResult(TCLIService.java:1298)
    at org.apache.thrift.ProcessFunction.process(ProcessFunction.java:39)
    at org.apache.thrift.TBaseProcessor.process(TBaseProcessor.java:39)
    at org.apache.hadoop.hive.thrift.HadoopThriftAuthBridge$Server$TUGIAssumingProcessor.process(HadoopThriftAuthBridge.java:746)
    at org.apache.thrift.server.TThreadPoolServer$WorkerProcess.run(TThreadPoolServer.java:286)
    at java.util.concurrent.ThreadPoolExecutor.runWorker(ThreadPoolExecutor.java:1145)
    at java.util.concurrent.ThreadPoolExecutor$Worker.run(ThreadPoolExecutor.java:615)
    at java.lang.Thread.run(Thread.java:745)
Caused by: org.apache.hadoop.hive.ql.parse.SemanticException: Table not found cdmp_dw.t2
    at org.apache.hadoop.hive.ql.parse.BaseSemanticAnalyzer.getTable(BaseSemanticAnalyzer.java:1345)
    at org.apache.hadoop.hive.ql.parse.BaseSemanticAnalyzer.getTable(BaseSemanticAnalyzer.java:1324)
    at org.apache.hadoop.hive.ql.parse.DDLSemanticAnalyzer.analyzeDescribeTable(DDLSemanticAnalyzer.java:2027)
    at org.apache.hadoop.hive.ql.parse.DDLSemanticAnalyzer.analyzeInternal(DDLSemanticAnalyzer.java:317)
    at org.apache.hadoop.hive.ql.parse.BaseSemanticAnalyzer.analyze(BaseSemanticAnalyzer.java:223)
    at org.apache.hadoop.hive.ql.Driver.compile(Driver.java:490)
    at org.apache.hadoop.hive.ql.Driver.compileInternal(Driver.java:1276)
    at org.apache.hadoop.hive.ql.Driver.compileAndRespond(Driver.java:1263)
    at org.apache.hive.service.cli.operation.SQLOperation.prepare(SQLOperation.java:186)
    ... 15 more
```

后续找到开发负责人停止对应流程,同时调大hiveserver2中的Open Connections上限