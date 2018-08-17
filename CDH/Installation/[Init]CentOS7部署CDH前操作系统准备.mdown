title: CentOS7(单台)cdh环境初始化
categories: [CDH,Installation]
date: 2017-06-30
---
```bash
# 替换yum源
find /etc/yum.repos.d/ -name "*.repo" -exec mv {} {}.bak \;
rpm -ivh --force --nodeps http://10.200.40.49/pub/centos-release-el7.noarch.rpm
yum clean all
yum makecache
# 删除cloud-init(会修改网卡)
yum remove -y cloud-init
# 禁用chronyd(会与ntp服务冲突)
sudo systemctl disable chronyd
# 安装ntp服务
sudo yum install -y ntp
sudo scp 10.151.164.84:/etc/ntp.conf /etc/ntp.conf
sudo systemctl enable ntpd.service
sudo systemctl start ntpd.service
# 关闭防火墙
sudo systemctl stop firewalld.service
sudo systemctl disable firewalld.service
sudo firewall-cmd --state
# 关闭SELINUX
sudo setenforce 0
sudo echo "SELINUX=disabled" > /etc/sysconfig/selinux;
# 关闭hugepage
sudo echo never > /sys/kernel/mm/transparent_hugepage/enabled
sudo echo never > /sys/kernel/mm/transparent_hugepage/defrag
sudo scp 10.151.164.84:/etc/rc.d/rc.local /etc/rc.d/rc.local 
sudo chmod +x /etc/rc.d/rc.local
# 修改时区为东八区
sudo cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
sudo echo 'Asia/Shanghai' >/etc/timezone
# 限制动态内存使用
sudo echo 1 > /proc/sys/vm/swappiness
# 设置最大文件数限制
sudo scp 10.151.164.84:/etc/security/limits.conf /etc/security/limits.conf
# 禁用ipv6 
sudo scp 10.151.164.84:/etc/default/grub  /etc/default/grub 
sudo scp 10.151.164.84:/etc/sysctl.conf /etc/sysctl.conf
sudo scp 10.151.164.84:/etc/sysconfig/network /etc/sysconfig/network
# 安装kerberos-client
yum -y install krb5-libs krb5-workstation
sudo scp 10.151.164.84:/etc/krb5.conf /etc/krb5.conf
# 安装jdk
mkdir -p /usr/java/
sudo scp -r 10.151.164.84:/usr/java/jdk1.8.0_131/ /usr/java/
export JAVA_HOME=/usr/java/jdk1.8.0_131
#  同步hosts
sudo scp 10.151.164.84:/etc/hosts /etc/hosts
```