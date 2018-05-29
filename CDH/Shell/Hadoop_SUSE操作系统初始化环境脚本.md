title: Hadoop_SUSE操作系统初始化环境脚本
categories: [CDH,Shell]
date: 2018-05-29 16:46:37
---
# Hadoop_SUSE操作系统初始化环境脚本
```bash
#!/usr/bin/shell
# 批量处理鹏博士机房,由于安全加固导致无法使用root账户分发以及批量更改配置的处理脚本
# for i in `cat servers.txt`
# do
#     echo "--------------begin to init $i--------------"

#     scp /tmp/pbs-init.sh $i:/tmp/pbs-init.sh
#     ssh $i 'sudo sh /tmp/pbs-init.sh'
#     ssh $i 'sudo rm /tmp/pbs-init.sh'
# done

IP_PW='XXXXXXX'

sycCONF ()
{
cat > sycCONF.exp<<EOF
#!/usr/bin/expect
spawn sudo scp root@10.200.60.114:$1 $1
expect {
    "*yes/no" {send "yes\r"; exp_continue}
    "*assword" {send "$IP_PW\r";}
}
expect eof
EOF
chmod 755 sycCONF.exp
./sycCONF.exp > /dev/null
/bin/rm -rf sycCONF.exp
}

sycCONF '/etc/hosts'
sycCONF '/etc/security/limits.conf'
sycCONF '/tmp/python-psycopg2-2.6.2-3.3.x86_64.rpm'
sycCONF '/tmp/formatdisk.sh'
sycCONF '/tmp/mountdisk.sh'

sudo zypper rr local.main
sudo zypper ar http://10.200.58.39/suse/ local.main
sudo zypper update
sudo zypper install -y postgresql91
sudo zypper install -y krb5-client
sycCONF '/etc/krb5.conf'
sudo rpm -ivh /tmp/python-psycopg2-2.6.2-3.3.x86_64.rpm
#NTP
sycCONF '/etc/ntp.conf'
sudo /sbin/service ntp restart
sudo /sbin/chkconfig ntp on

#FIREWALL
sudo /sbin/rcSuSEfirewall2 stop
sudo /sbin/chkconfig SuSEfirewall2_setup off
#SELINUX
sudo /sbin/service boot.apparmor stop
sudo /sbin/chkconfig boot.apparmor off
#HUGEPAGE
sudo bash -c "echo never > /sys/kernel/mm/transparent_hugepage/enabled"
sudo bash -c "echo never > /sys/kernel/mm/transparent_hugepage/defrag"
#SWAPING
sycCONF '/etc/sysctl.conf'
sudo bash -c "echo 0 >/proc/sys/vm/swappiness"
#ADDUSER
sudo /usr/sbin/groupadd hadoop
sudo /usr/sbin/useradd  hadoop
sudo /usr/sbin/groupadd acc
sudo /usr/sbin/useradd  acc
sudo /usr/sbin/groupadd cdmpview
sudo /usr/sbin/useradd  cdmpview
sudo /usr/sbin/groupadd oru
sudo /usr/sbin/useradd  orusudo 

#HOSTNAME
LOCAL_IP=`/sbin/ifconfig|sed -n '/inet addr/s/^[^:]*:\([0-9.]\{7,15\}\) .*/\1/p' |head -1`
LOCAL_HOSTNAME=`cat /etc/hosts|grep $LOCAL_IP|awk '{print $2}'`
sudo bash -c "hostname $LOCAL_HOSTNAME"
sudo bash -c "echo $LOCAL_HOSTNAME > /etc/HOSTNAME"
hostname 
hostname -f
cat /etc/HOSTNAME 
```