for i in `cat ~/servers1.txt`
do
    echo "--------------------------------begin to init $i--------------------------------"
    ssh $i 'find /etc/yum.repos.d/ -name "*.repo" -exec mv {} {}.bak \;'
    ssh $i 'rpm -ivh --force --nodeps http://10.200.40.49/pub/centos-release-el7.noarch.rpm'
    ssh $i 'yum clean all'
    ssh $i 'yum makecache'
    # ssh $i 'yum remove -y cloud-init'
    echo "----------------------------begin to stop firewalld $i---------------------------"
    ssh $i 'sudo systemctl stop firewalld.service'
    ssh $i 'sudo systemctl disable firewalld.service'
    ssh $i 'sudo firewall-cmd --state'
    ssh $i 'sudo setenforce 0'
    ssh $i 'sudo echo "SELINUX=disabled" > /etc/sysconfig/selinux;'
    ssh $i 'sudo echo never > /sys/kernel/mm/transparent_hugepage/enabled'
    ssh $i 'sudo echo never > /sys/kernel/mm/transparent_hugepage/defrag'
    echo "----------------------------begin to change timezone $i---------------------------"
    ssh $i 'sudo cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime'
    ssh $i 'sudo echo 'Asia/Shanghai' >/etc/timezone'
    ssh $i 'sudo echo 0 > /proc/sys/vm/swappiness'
    ssh $i 'sudo yum install -y ntp'
    # ntp
    ssh $i 'sudo systemctl disable chronyd'
    sudo scp /etc/default/grub  $i:/etc/default/grub 
    sudo scp /etc/rc.d/rc.local $i:/etc/rc.d/rc.local
    ssh $i 'sudo chmod +x /etc/rc.d/rc.local'
    sudo scp /etc/security/limits.conf $i:/etc/security/limits.conf
    sudo scp /etc/ntp.conf $i:/etc/ntp.conf
    ssh $i 'sudo systemctl start ntpd.service'
    ssh $i 'sudo systemctl enable ntpd.service'
    sudo scp /etc/sysctl.conf $i:/etc/sysctl.conf
    sudo scp /etc/sysconfig/network $i:/etc/sysconfig/network
    # sudo scp /etc/cloud/cloud.cfg $i:/etc/cloud/cloud.cfg

    #CDH prepare
    sudo scp /root/jdk-8u131-linux-x64.tar.gz $i:/root/
    ssh $i 'sudo mkdir -p /usr/java'
    ssh $i 'ls /usr/java'
    ssh $i 'sudo tar -zxf /root/jdk-8u131-linux-x64.tar.gz -C /usr/java/'
    sudo scp /etc/krb5.conf.new.sjyf $i:/etc/krb5.conf
    sudo scp -o "StrictHostKeyChecking no" /etc/hosts $i:/etc/hosts
    sudo ssh $i 'hostname > /etc/hostname'
    sudo ssh -o "StrictHostKeyChecking no" $i 'hostname -a;hostname'


    #CDH gateway
    ssh $i 'yum install -y krb5-workstation'
    ssh $i 'groupadd sunflower -g 1503'
    ssh $i 'useradd sunflower -u 1503 -g sunflower'
    scp -o "StrictHostKeyChecking no" /etc/hosts $i:/etc/hosts
    scp /etc/krb5.conf $i:/etc/krb5.conf
    scp /etc/ntp.conf $i:/etc/ntp.conf
    ssh $i 'reboot'
    scp /root/establishSSH/formatdisk-dn.sh $i:~/formatdisk-dn.sh
    scp /root/establishSSH/mountdisk-dn.sh $i:~/mountdisk-dn.sh
    ssh $i 'sh /root/formatdisk-dn.sh'
    ssh $i 'sh /root/mountdisk-dn.sh'
    ssh $i 'mount -a'
    ssh $i 'reboot'

    #Check
    ssh $i 'hostname'
    ssh $i 'sudo systemctl status firewalld.service | grep Active'
    ssh $i 'sudo firewall-cmd --state'
    ssh $i 'sudo getenforce'
    ssh $i 'sudo cat /sys/kernel/mm/transparent_hugepage/enabled'
    ssh $i 'sudo cat /sys/kernel/mm/transparent_hugepage/defrag'
    ssh $i 'sudo cat /proc/sys/vm/swappiness'
    ssh $i 'sudo ntpq -p'

    #Remove all CDH
    ssh $i 'service cloudera-scm-agent stop'
    ssh $i 'umount /var/run/cloudera-scm-agent/process'
    ssh $i 'rm -rf /usr/share/cmf /var/lib/cloudera* /var/cache/zypp/packages/cloudera-* /var/cache/zypp/raw/cloudera-* /var/cache/zypp/solv/cloudera-* /var/log/cloudera-scm-* /var/run/cloudera-scm-* /etc/cloudera-scm-server*'
    ssh $i 'rpm -qa |grep cloudera'
    ssh $i 'rpm -e cloudera-manager-agent'
    ssh $i 'rpm -e cloudera-manager-daemons'
    ssh $i 'rm -rf /var/lib/hadoop-* /var/lib/impala /var/lib/solr /var/lib/zookeeper /var/lib/hue /var/lib/oozie  /var/lib/pgsql  /var/lib/sqoop2  /data/dfs/  /data/impala/ /data/yarn/  /dfs/ /impala/ /yarn/  /var/run/hadoop-*/ /var/run/hdfs-*/ /usr/bin/hadoop* /usr/bin/zookeeper* /usr/bin/hbase* /usr/bin/hive* /usr/bin/hdfs /usr/bin/mapred /usr/bin/yarn /usr/bin/sqoop* /usr/bin/oozie /etc/hadoop* /etc/zookeeper* /etc/hive* /etc/hue /etc/impala /etc/sqoop* /etc/oozie /etc/hbase* /etc/hcatalog '
    ssh $i 'rm -rf /opt/cloudera/parcel-cache /opt/cloudera/parcels'
    ssh $i 'ps aux|grep  supervisord |grep -v grep | awk '{print "kill -9" $2}'|sh'
    ssh $i 'for a in {b..y};do rm -rf /mnt/sd${a}1;done'

    #LDAP
    #sudo scp sssdldap.sh $i:/root/
    #ssh -o "StrictHostKeyChecking no" $i 'sh /root/sssdldap.sh'
    #ssh -o "StrictHostKeyChecking no" $i 'sed -i "s/rfc2307bis/rfc2307/g" /etc/sssd/sssd.conf;rm -fr /var/lib/sss/db/*;systemctl restart sssd;id ldaptest2'
    ssh -o "StrictHostKeyChecking no" $i 'systemctl status nscd | grep Active'

    echo "--------------begin to add route to $i--------------"
    ssh $i 'route add -net 10.200.0.0/16 gw 10.151.0.1'
    ssh $i 'route add -net 10.125.137.0/24 gw 10.151.0.1'
done

###sssdladp.sh
yum install -y mlocate sssd authconfig oddjob-mkhomedir nss-pam-ldapd

authconfig --enablesssd --enablesssdauth --enablelocauthorize --enableldap --enableldapauth --ldapserver=ldap://dsj-ddp-ad-kdc-01.sjad.com:389,ldap://dsj-ddp-ad-kdc-02.sjad.com:389 --ldapbasedn=dc=sjad,dc=com --disableldaptls --enablerfc2307bis --enablemkhomedir --enablecachecreds --update

sed -i "1,100s/pam_sss.so/pam_ldap.so/g" /etc/pam.d/password-auth
sed -i "1,100s/pam_sss.so/pam_ldap.so/g" /etc/pam.d/system-auth

systemctl restart messagebus
systemctl restart oddjobd
systemctl restart nslcd
systemctl restart sssd
systemctl restart systemd-logind

systemctl enable messagebus
systemctl enable oddjobd
systemctl enable nslcd
systemctl enable sssd
systemctl enable systemd-logind

id ldaptest
