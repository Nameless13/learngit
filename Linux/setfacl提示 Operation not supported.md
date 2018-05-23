title: setfacl提示 Operation not supported
categories: [Linux]
date: 2018-05-23 09:57:35
---
# setfacl提示 Operation not supported  

问题：/mnt/bak为硬盘的一个分区，在fstab做了defaults挂载，当我需要配置acl权限时

命令为：setfacl -m u:luo:rwx /mnt/bak的时候提示

setfacl: /mnt/bak: Operation not supported 错误

解决方法：重新修改/etc/fstab文件，加入acl选项

/dev/vg/bak             /mnt/bak                ext3    defaults,acl    0 0

然后：mount -o remount /mnt/bak 重新挂载，再执行上面的命令，成功！


