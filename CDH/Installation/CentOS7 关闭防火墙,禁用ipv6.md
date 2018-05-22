# CentOS7 关闭防火墙,禁用ipv6
## CentOS7 关闭防火墙

firewall-cmd --state #查看默认防火墙状态（关闭后显示notrunning，开启后显示running）

```
[root@localhost network-scripts]# firewall-cmd --state
running
[root@localhost network-scripts]# systemctl stop firewalld.service 
[75721.569225] Ebtables v2.0 unregistered
[root@localhost network-scripts]# systemctl disable firewalld.service
Removed symlink /etc/systemd/system/multi-user.target.wants/firewalld.service.
Removed symlink /etc/systemd/system/dbus-org.fedoraproject.FirewallD1.service.
[root@localhost network-scripts]# firewall-cmd --state
not running

```

systemctl stop firewalld.service #停止firewall
systemctl disable firewalld.service #禁止firewall开机启动



## CentOS7禁用ipv6

vi /etc/default/grub 
```
GRUB_TIMEOUT=1
GRUB_DISTRIBUTOR="$(sed 's, release .*$,,g' /etc/system-release)"
GRUB_DEFAULT=saved
GRUB_DISABLE_SUBMENU=true
GRUB_TERMINAL="serial console"
GRUB_SERIAL_COMMAND="serial --speed=115200"
GRUB_CMDLINE_LINUX="ipv6.disable=1 console=tty0 crashkernel=auto console=ttyS0,115200"
GRUB_DISABLE_RECOVERY="true"
GRUB_DEVICE=LABEL=cloudimg-rootfs
GRUB_DISABLE_LINUX_UUID=true
GRUB_TIMEOUT=5
GRUB_TERMINAL="serial console"
GRUB_GFXPAYLOAD_LINUX=text
GRUB_CMDLINE_LINUX_DEFAULT="console=tty0 console=ttyS0,115200 no_timer_check"
GRUB_SERIAL_COMMAND="serial --speed=115200 --unit=0 --word=8 --parity=no --stop=1"
GRUB_CMDLINE_LINUX="nofb nomodeset vga=normal"

```

grub2-mkconfig -o /boot/grub2/grub.cfg

[root@localhost network-scripts]# cat /proc/sys/net/ipv6/conf/all/disable_ipv6
0


If the output is 0, IPv6 is enabled.
If the output is 1, IPv6 is already disabled.


lsmod | grep ipv6



169.254.169.254

cloud-init[1716]: 2018-01-08 10:05:08,907 - url_helper.py[WARNING]: Calling 'http://10.151.164.1/latest/meta-data/instance-id' failed [30/120s]: request error [('Connection aborted.', error(111, 'Connection refused'))]
