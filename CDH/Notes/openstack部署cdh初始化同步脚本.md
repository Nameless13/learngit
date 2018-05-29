title: openstack部署cdh初始化同步脚本
categories: [CDH,Notes]
date: 2018-05-23 09:57:35
---
```bash
for i in `cat ~/servers.txt`
do
    echo "--------------begin to sync ntp.conf to $i--------------"
    scp /etc/ntp.conf $i:/etc/ntp.conf
    ssh $i 'systemctl restart ntpd.service'

    echo "--------------begin to change ntpd to $i--------------"
    ssh $i 'systemctl enable ntpd.service'
    ssh $i 'systemctl start ntpd.service'
    ssh $i 'systemctl disable chronyd'

    echo "--------------begin to change hugepage to $i--------------"
    scp /etc/rc.d/rc.local $i:/etc/rc.d/rc.local
    ssh $i 'chmod +x /etc/rc.d/rc.local'
    ssh $i 'echo never > /sys/kernel/mm/transparent_hugepage/enabled'
    ssh $i 'echo never > /sys/kernel/mm/transparent_hugepage/defrag'

    echo "--------------begin to sync hosts to $i--------------"
    scp /etc/hosts $i:/etc/hosts

    echo "--------------begin to add route to $i--------------"
    ssh $i 'route add -net 10.200.0.0/16 gw 10.151.0.1'
    ssh $i 'route add -net 10.125.137.0/24 gw 10.151.0.1'

    echo "--------------begin to restart agent to $i--------------"
    ssh $i 'systemctl restart cloudera-scm-agent.service'

    echo "--------------begin to restart agent to $i--------------"
    ssh $i 'service cloudera-scm-agent restart'

    echo "--------------begin to rm cloudera to $i--------------"
    scp /root/rmall.sh $i:/root/
    ssh $i 'sh /root/rmall.sh'

    echo "--------------begin to sync disable ens6 to default-route  $i--------------"
    scp /etc/sysconfig/network-scripts/ifcfg-ens6 $i:/etc/sysconfig/network-scripts/ifcfg-ens6

    echo "--------------begin to sync wget to $i--------------"
    ssh  $i 'yum -y install wget'
done
```

