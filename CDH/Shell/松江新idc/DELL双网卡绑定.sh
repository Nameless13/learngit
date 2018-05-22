sudo su -

FILE5="/etc/sysconfig/network-scripts/ifcfg-p5p2"
test -f $FILE5 && echo -e "DEVICE=\"p5p2\"" > $FILE5 && \
echo -e "BOOTPROTO=none" >> $FILE5   && \
echo -e "ONBOOT=\"yes\"" >> $FILE5   && \
echo -e "TYPE=\"Ethernet\"" >> $FILE5   && \
echo -e "MASTER=bond0" >> $FILE5   && \
echo -e "SLAVE=yes" >> $FILE5  

FILE7="/etc/sysconfig/network-scripts/ifcfg-p7p2"
test -f $FILE7 && echo -e "DEVICE=\"p7p2\"" > $FILE7 && \ 
echo -e "BOOTPROTO=none" >> $FILE7   && \
echo -e "ONBOOT=\"yes\"" >> $FILE7   && \
echo -e "TYPE=\"Ethernet\"" >> $FILE7   && \
echo -e "MASTER=bond0" >> $FILE7   && \
echo -e "SLAVE=yes" >> $FILE7  

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
echo -e "IPADDR=10.151.165.50" >> $FILE610 && \
echo -e "NETMASK=255.255.252.0" >> $FILE610 && \
echo -e "GATEWAY=10.151.164.1" >> $FILE610 && \
modprobe 8021q && \
service network restart
