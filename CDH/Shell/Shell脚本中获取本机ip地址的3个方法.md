title: Shell脚本中获取本机ip地址的3个方法
categories: [CDH,Shell]
date: 2018-05-29 16:40:11
---
# Shell脚本中获取本机ip地址的3个方法

```
/sbin/ifconfig -a|grep inet|grep -v 127.0.0.1|grep -v inet6|awk '{print $2}'|tr -d "addr:"
or

/sbin/ifconfig|sed -n '/inet addr/s/^[^:]*:\([0-9.]\{7,15\}\) .*/\1/p'


local_host="`hostname --fqdn`"
local_ip=`host $local_host 2>/dev/null | awk '{print $NF}'`


local_host="`hostname --fqdn`"
nslookup -sil $local_host 2>/dev/null | grep Address: | sed '1d' | sed 's/Address://g'
```