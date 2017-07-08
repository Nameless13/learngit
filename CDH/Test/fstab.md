title: fstab
categories: 
- CDH
- Test
date: 2017-05-24
---
ddp-nn-01:~ # cat /etc/fstab
/dev/disk/by-id/scsi-3600605b00aa90f901dd8c1c109e9a38b-part4 /                    ext3       acl,user_xattr        1 1
/dev/disk/by-id/scsi-3600605b00aa90f901dd8c1c109e9a38b-part3 /boot                ext3       acl,user_xattr        1 2
/dev/disk/by-id/scsi-3600605b00aa90f901dd8c1c109e9a38b-part1 /opt                 ext3       acl,user_xattr        1 2
/dev/disk/by-id/scsi-3600605b00aa90f901dd8c1c109e9a38b-part2 /var                 ext3       acl,user_xattr        1 2
proc                 /proc                proc       defaults              0 0
sysfs                /sys                 sysfs      noauto                0 0
debugfs              /sys/kernel/debug    debugfs    noauto                0 0
usbfs                /proc/bus/usb        usbfs      noauto                0 0
devpts               /dev/pts             devpts     mode=0620,gid=5       0 0
/dev/sdb1 /mnt/sdb1 ext3 defaults,noatime,nodiratime,barrier=0,data=writeback,commit=100 0 0
/dev/sdc1 /mnt/sdc1 ext3 defaults,noatime,nodiratime,barrier=0,data=writeback,commit=100 0 0
