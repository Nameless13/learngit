PRD_DT-[root@scsp00257 ~]# cat check_disk.sh 

#!/bin/bash

num=1

for i in $(df -h|grep mnt/sd*|awk -F' ' '{print $1 "|" $6}')     ###  注意，实际环境，过滤条件“grep sd*”改为实际挂在磁盘目录，此处脚本为挂载到/sdb1 ，...，/datan下
do 
   echo -e "=====number: $num ====="

   disk=$(echo -e "$i"|cut -d '|' -f 1)
   mounton=$(echo -e "$i"|cut -d '|' -f 2)
   echo -e "Disk is $disk"
   echo -e "Mount on $mounton"

   
   smartctl -H $disk

   num=$[$num+1]
done






manage@ddp-dn-114:~> sudo sh check_disk.sh |grep faile

Disk is /dev/sdf1
Mount on /mnt/sdf1
smartctl 6.0 2012-10-10 r3643 [x86_64-linux-3.0.76-0.11-default] (SUSE RPM)
Copyright (C) 2002-12, Bruce Allen, Christian Franke, www.smartmontools.org

Smartctl open device: /dev/sdf1 failed: No such device
