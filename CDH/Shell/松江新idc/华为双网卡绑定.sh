sudo su -

FILE2="/etc/sysconfig/network-scripts/ifcfg-enp2s0f0"
test -f $FILE2 && echo -e "DEVICE=\"enp2s0f0\"" > $FILE2 && \
echo -e "BOOTPROTO=none" >> $FILE2   && \
echo -e "ONBOOT=\"no\"" >> $FILE2   && \
echo -e "TYPE=\"Ethernet\"" >> $FILE2

FILE5="/etc/sysconfig/network-scripts/ifcfg-enp5s0f0"
test -f $FILE5 && echo -e "DEVICE=\"enp5s0f0\"" > $FILE5 && \
echo -e "BOOTPROTO=none" >> $FILE5   && \
echo -e "ONBOOT=\"yes\"" >> $FILE5   && \
echo -e "TYPE=\"Ethernet\"" >> $FILE5   && \
echo -e "MASTER=bond0" >> $FILE5   && \
echo -e "SLAVE=yes" >> $FILE5  

FILE129="/etc/sysconfig/network-scripts/ifcfg-enp129s0f0"
test -f $FILE129 && echo -e "DEVICE=\"enp129s0f0\"" > $FILE129 && \
echo -e "BOOTPROTO=none" >> $FILE129   && \
echo -e "ONBOOT=\"yes\"" >> $FILE129   && \
echo -e "TYPE=\"Ethernet\"" >> $FILE129   && \
echo -e "USERCTL=no" >> $FILE129  && \
echo -e "MASTER=bond0" >> $FILE129  && \
echo -e "SLAVE=yes" >> $FILE129  

FILE0="/etc/sysconfig/network-scripts/ifcfg-bond0"
echo -e "DEVICE=bond0" > $FILE0 && \
echo -e "BOOTPROTO=none" >> $FILE0 && \
echo -e "ONBOOT=yes" >> $FILE0 && \
echo -e "TYPE=bond" >> $FILE0 && \
echo -e "BONDING_OPTS=\"miimon=100 mode=1\"" >> $FILE0 

FILE610="/etc/sysconfig/network-scripts/ifcfg-bond0.610"
echo -e "DEVICE=bond0.610" > $FILE610 && \
echo -e "ONBOOT=yes" >> $FILE610 && \
echo -e "BOOTPROTO=static" >> $FILE610 && \
echo -e "VLAN=yes" >> $FILE610 && \ 
echo -e "NETMASK=255.255.252.0" >> $FILE610 && \
echo -e "GATEWAY=10.151.164.1" >> $FILE610 && \
echo -e "IPADDR=10.151.165.205" >> $FILE610 && \
modprobe 8021q && \
service network restart &&\
yum -y remove cloud-init
