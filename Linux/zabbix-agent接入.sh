#!/bin/bash
local_ip=$(ifconfig -a|grep inet|grep -v 127.0.0.1|grep -v inet6|awk '{print $2}'|tr -d "addr:"﻿​)
local_role=$(hostname|awk -F- '{print $4}')
local_hostname=$local_role"-"$local_ip
zabbix_agentd_conf=/usr/local/zabbix/etc/zabbix_agentd.conf

if [ ! -d "/usr/local/zabbix" ]; then
  mkdir /usr/local/zabbix 
fi
tar -xf /usr/local/zabbix_centos7.tar.gz -C /usr/local/zabbix --strip-components 1 && \
mv /usr/local/zabbix/zabbix_agentd /etc/init.d/ && chmod +x /etc/init.d/zabbix_agentd && chkconfig zabbix_agentd on
# 创建zabbix用户和用户组，如果已有了，就不需要创建了
# 修改zabbix agentd配置文件,配置agent访问的服务器ip及agent的hostname
sed -i 's/^Server=.*$/Server=10.200.56.126,172.16.70.30/' $zabbix_agentd_conf
sed -i 's/^ServerActive=.*$/ServerActive=10.200.56.126,172.16.70.30/' $zabbix_agentd_conf
sed -i "s/^Hostname=.*$/Hostname=$local_hostname/" $zabbix_agentd_conf
grep -E "^Server=" $zabbix_agentd_conf
grep -E "^ServerActive=" $zabbix_agentd_conf
grep -E "^Hostname=" $zabbix_agentd_conf
#启动zabbix_agentd
service  zabbix_agentd  start && ps -ef | grep zabbix_agentd




