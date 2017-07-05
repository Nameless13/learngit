```
rpm -ihv haproxy-1.5.14-91.1.x86_64.rpm 
chkconfig haproxy on
chkconfig --list haproxy 
cp /etc/haproxy/haproxy.cfg /etc/haproxy/bak.cfg
vi /etc/haproxy/haproxy.cfg 
/etc/init.d/haproxy start

ss -an |grep 10003
```
  
  