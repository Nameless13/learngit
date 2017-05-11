#!/bin/bash
#删除各个节点上僵死的impala daemon
#1. 先重启所有impala角色后可以看到僵死impala daemon接受不到由agent发出的重启信号
#2. 登到一台报错的impala主机上,执行`ps aux|grep  impala-conf |grep -v grep | awk '{print "kill -9 "$2}'|sh`
#3. 之后`netstat -nt  |sed -n '3,$p' | awk -F '[ :]+' '{print $4}' |sort -u`查看所有未能正确释放的impala角色ip

ps aux|grep  impala-conf |grep -v grep | awk '{print "kill -9 "$2}'|sh

netstat -nt  |grep 22000 |sed -n '3,$p' | awk -F '[ :]+' '{print $4}' |sort -u


---
#-*- coding: utf-8 -*-
#!/usr/bin/python 
import paramiko
import threading

def ssh2(ip,username,passwd,cmd):
    try:
        ssh = paramiko.SSHClient()
        ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())
        ssh.connect(ip,22,username,passwd,timeout=5)
        for m in cmd:
            stdin, stdout, stderr = ssh.exec_command(m)
#           stdin.write("Y")   #简单交互，输入 ‘Y’ 
            out = stdout.readlines()
            #屏幕输出
            for o in out:
                print o,
        print '%s\tOK\n'%(ip)
        ssh.close()
    except :
        print '%s\tError\n'%(ip)


if __name__=='__main__':
    cmd = ['cal','echo hello!']#你要执行的命令列表
    username = "root"  #用户名
    passwd = "mg123!@#"    #密码
    threads = []   #多线程
    print "Begin......"
    for i in range(50,55):
        ip = '192.168.1.'+str(i)
        a=threading.Thread(target=ssh2,args=(ip,username,passwd,cmd))
        a.start() 


---
ddp-dn-07:/opt/cloudera/parcels/CDH-5.4.7-1.cdh5.4.7.p0.3 # find . -name pip
./lib/hue/build/env/bin/pip
./lib/hue/build/env/lib/python2.6/site-packages/pip-1.1-py2.6.egg/pip
/opt/cloudera/parcels/CDH-5.4.7-1.cdh5.4.7.p0.3/lib/hue/build/env/bin/

pip install --no-index --find-links="/tmp/offline_packages" paramiko
---
cat test.sh

#!/bin/bash  

#本地通过ssh执行远程服务器的脚本  
for ip in `cat iplist` 
do  
    echo $1
    if [[ -z $1 ]]; then  #"-z"，如果为空 
        echo "Not find command."
        break 
    else  
        echo "$ip----------------------"
        ssh $ip $1 
    fi
done  