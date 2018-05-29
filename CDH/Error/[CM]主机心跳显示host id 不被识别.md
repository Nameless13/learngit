title: 主机心跳显示host id 不被识别
categories: [CDH,Error]
date: 2018-05-23 09:57:34
---
# 主机心跳显示host id 不被识别
主要是有些主机停止服务后太久没有启用,后重新启用导致的
```
The process directory is within /var/run/cloudera-scm-agent/process which
is a in-memory filesystem. You can recreate it by rebooting the box or by
restarting the agent with the clean_restart option, which will restart all
CDH roles on the host as well.

# service cloudera-scm-agent clean_restart

If you face this error again, please check the filesystem's health (disk
free, is it writable etc)
```

```
WARN 2140628375@agentServer-117775:com.cloudera.server.cmf.AgentProtocolImpl: Received an optimized heartbeat for a host with ID '85e3dd0a-f712-4f70-b151-89d56ae895d2' that is not recognized
```

建议尝试重启agent