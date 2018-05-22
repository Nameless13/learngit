# 松江资源池云主机cdh环境准备
```
    1  reboot
    2  ping 114.114.114.114
    3  reboot
    4  ls
    5  cat /etc/issue
    6  top
    7  yum --help
    8  ifconfig 
    9  chkconfig --list
   10  cat /etc/sysconfig/selinux 
   11  echo "SELINUX=disabled" > /etc/sysconfig/selinux 
   12  cat /etc/sysconfig/selinux 
   13  cat /sys/kernel/mm/transparent_hugepage/defrag 
   14  echo never > /sys/kernel/mm/transparent_hugepage/defrag 
   15  cat /sys/kernel/mm/transparent_hugepage/defrag 
   16  cat /etc/sysctl.conf 
   17  echo 0 >/proc/sys/vm/swappiness 
   18  echo 'vm.swqppiness=0'>> /etc/sysctl.conf 
   19  cat /proc/sys/vm/swappiness 
   20  cat /etc/sysctl.conf 
   21  cat /etc/security/limits.conf 
   22  vo /etc/security/limits.conf 
   23  vi /etc/security/limits.conf 
   24  yum install ntp
   25  ifconfig 
   26  ip a
   27  yum install tree
   28  yum install lrzsz
   29  free -g
   30  systemctl stop firewalld.service
   31  chkconfig --list
   32  yum install createrop
   33  yum install createrepo
   34  yum install -y postgresql91
   35  yum install -y python-psycopg2
   36  vi /etc/rc.local 
   37  cat /etc/rc.local 
   38  cat /sys/kernel/mm/transparent_hugepage/
   39  cat /sys/kernel/mm/transparent_hugepage/defrag 
   40  ll /etc/rc.local 
   41  hostname
   42  hostname -f
   43  view /etc/ssh/ssh_config 
   44  chkconfig ntp on
   45  chkconfig ntpd on
   46  chkconfig --lis
   47  chkconfig --list
   48  systemctl enable ntpd.service
   49  chkconfig --list
   50  systemctl list-unit-files
   51  systemctl list-unit-files |grep ntp
   52  systemctl list-unit-files |grep fire
   53  systemctl list-unit-files |grep ip
   54  systemctl list-unit-files |grep wall
   55  yum install gcc
   56  systemctl list-unit-files |grep firewall
   57  systemctl list-unit-files |grep ipta
   58  iptables -C
   59  iptables -V
   60  systemctl list-unit-files |grep iptables
   61  whereis iptables
   62  ll /usr/bin/iptables-xml 
   63  systat
   64  sysstat
   65  yum install -y sysstat
   66  firewalls -v
   67  firewalld -v
   68  systemctl stop firewalld.service
   69  whereis firewalld
   70  ll /usr/lib/firewalld/ipsets/
   71  ll /etc/firewalld/zones/public.xml
   72  systemctl disable firewalld.service
   73  cat /etc/sysctl.conf 
   74  systemctl list-unit-files |Net
   75  systemctl list-unit-files |grep Net
   76  systemctl list-unit-files |grep net
   77  systemctl --help
   78  systemctl list -units --type=service
   79  sudo systemctl status firewalld.service
   80  systemctl enable ntpd.service
   81  chkconfig --list
   82  systemctl list-unit-files |grep ntpd
   83  reboot
   84  df -h
   85  firewalld
   86  whereis firewalld
   87  systemctl status firewalld
   88  cat /etc/issue
   89  uname -a
   90  cat /etc/*release
   91  ping 8.8.8.8
   92  vi /etc/ntp.conf 
   93  /etc/init.d/ntpd restart
   94  service ntpd restart
   95  ntpq -p
   96  date
   97  reboot 
   98  vi /etc/ssh/sshd_config 
   99  systemctl restart sshd.service
  100  history > 1.log


    1  systemctl --hlep
    2  systemctl --help
    3  systemctl stop firewalld.service
    4  ssh 10.150.4.5
    5  ssh 10.150.4.5 -p 10022
    6  ssh 10.150.4.5 
    7  head 1.log 
    8  head 15 1.log 
    9  head -15 1.log 
   10  cat /etc/sysconfig/selinux 
   11  echo "SELINUX=disabled" > /etc/sysconfig/selinux 
   12  cat /etc/sysconfig/selinux 
   13  cat /sys/kernel/mm/transparent_hugepage/defrag 
   14  echo never > /sys/kernel/mm/transparent_hugepage/defrag 
   15  cat /sys/kernel/mm/transparent_hugepage/defrag 
   16  head -20 1.log |tail -5
   17  cat /etc/sysctl.conf 
   18  free
   19  echo 0 > /proc/sys/vm/swappiness 
   20  echo 'vm.swappiness=0' >> /etc/sysctl.conf 
   21  cat /etc/sysctl.conf 
   22  cat /proc/sys/vm/swappiness 
   23  head -25 1.log |tail -5
   24  cat /etc/security/limits.conf 
   25  ll
   26  cat /etc/security/limits.conf 
   27  ll /etc/security/limits.conf 
   28  scp root@10.150.4.5:/etc/security/limits.conf /etc/security/limits.conf 
   29  vi /etc/security/limits.conf 
   30  head -25 1.log |tail -5
   31  yum install ntp
   32  head -25 1.log |tail -5
   33  head -30 1.log |tail -5
   34  yum install tree
   35  yum install -y lrzsz
   36  yum install -y bash-completion
   37  head -30 1.log |tail -5
   38  head -35 1.log |tail -5
   39  head -33 1.log |tail -1 | sh
   40  yum install -y createrepo python-psycopg2
   41  yum instal -y httpd
   42  yum install -y httpd
   43  vi /etc/ntp.conf 
   44  ssh 10.150.4.5
   45  head -40 1.log |tail -5
   46  vi /etc/rc.local 
   47  scp root@10.150.4.5:/etc/rc.local /etc/rc.local 
   48  head -40 1.log |tail -5
   49  cat /etc/rc.local 
   50  head -45 1.log |tail -5
   51  chkconfig ntpd on
   52  ntpq -p
   53  systemctl enable ntpd.service
   54  systemctl start ntpd.service
   55  ntpq -p
   56  date
   57  ssh 10.150.4.5
   58  scp root@10.150.4.5:/etc/ntp.conf /etc/ntp.conf 
   59  systemctl restart ntpd.service
   60  ntpq -p
   61  date
   62  ntpq -p
   63  timedatectl 
   64  timedatectl set-timezone Asia/Shanghai
   65  timedatectl 
   66  date
   67  head -45 1.log |tail -5
   68  head -50 1.log |tail -5
   69  head -50 1.log |tail -10
   70  head -60 1.log |tail -10
   71  head -70 1.log |tail -10
   72  yum install -y gcc sysstat
   73  head -70 1.log |tail -10
   74  head -80 1.log |tail -10
   75  systemctl list-unit-file |grep ntp
   76  systemctl list-unit-files |grep ntp
   77  ntpq -p
   78  yum install httpd
   79  ulimit -a
   80  reboot
   81  cat /etc/issue
   82  root
   83  reboot 
   84  ifconfig 
   85  python --version
   86  yum update python
   87  yum upgrade python
   88  ifconfig
   89  vi /etc/default/grub 
   90  grub2-mkconfig -0 /boot/grub2/grub.cfg 
   91  grub2-mkconfig -o /boot/grub2/grub.cfg 
   92  lsmod |grep ipv6
   93  reboot 
   94  pinh 8.8.8.8
   95  ping 8.8.8.8
   96  route -n
   97  ifconfig 
   98  lsblk
   99  cat /sys/kernel/mm/transparent_hugepage/defrag 
  100  cat /etc/rc.local 
  101  echo never > /sys/kernel/mm/transparent_hugepage/defrag 
  102  cat /sys/kernel/mm/transparent_hugepage/defrag 
  103  df -h
  104  cd /opt/
  105  ll
  106  cat /sys/kernel/mm/transparent_hugepage/defrag 
  107  vi /etc/rc.d/rc.local 
  108  ll /etc/rc.d/rc.local 
  109  chmod  +x /etc/rc.d/rc.local 
  110  reboot 
  111  echo never > /sys/kernel/mm/transparent_hugepage/enabled
  112  echo never > /sys/kernel/mm/transparent_hugepage/defrag
  113  vi /etc/rc.d/rc.local
  114  chmod +x /etc/rc.d/rc.local
  115  route add -net 10.200.0.0/16 gw 10.151.0.1
  116  history 
  117  ll
  118  sz 1.log 
  119  history > 2.log




```