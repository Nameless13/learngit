# 替换yum源
find /etc/yum.repos.d/ -name "*.repo" -exec mv {} {}.bak \; 
rpm -ivh --force --nodeps http://10.200.40.49/pub/centos-release-el6.noarch.rpm
yum clean all
yum makecache

# 关闭SELinux
echo "SELINUX=disabled" > /etc/sysconfig/selinux;


# 改transparent_hugepage参数，这一参数默认值可能会导致CDH性能下降
    echo never > /sys/kernel/mm/transparent_hugepage/enabled
    echo never > /sys/kernel/mm/transparent_hugepage/defrag
    同时确保开机自动关闭transparent_hugepage
    vi /etc/rc.d/rc.local



# 修改/etc/security/limits.conf或者在/etc/security/limits.d下增加相应的配置文件 
    ```
    - soft noproc 11000
    - hard noproc 11000
    - soft nofile 65535
    - hard nofile 65535
    ```

11. 需要统一开启ntp服务,并且开机启动
    在集群中选择一台机器作为ntp服务器，剩余的作为ntp客户端。所有客户端时间与ntp服务器保持同步。
    `vi /etc/ntp.conf` 
    ntp同步ip地址和鹏博士的保持一致:
    server 64.113.32.5
    server 216.229.0.179

    systemctl start ntpd.service
    systemctl enable ntpd.service

    systemctl disable chronyd 会影响ntp服务的开机启动所以禁用掉了



# grep -qf file my.cnf || sed -i '/\[mysqld]/r file' my.cnf