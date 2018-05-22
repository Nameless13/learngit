SUSE hostname 4分钟修改为host-ip
1. dhcp SERVER 肯定那是设置了 修改client端的主机名的,因为我本机dhcp /etc/sysconfig/network/scripts/dhcpcd-hook 配置文件把修改主机名的 函数干掉了都还是会被修改
2. 模版默认参数被修改了 /etc/sysconfig/network/dhcp DHCLIENT_SET_HOSTNAME:Q 默认应该client端不允许修改主机名才对
3. 结果互相连接不上了

