# SUSE开机启动脚本配置文件

关于开机启动脚本配置文件  SUSE与其它Linux设置不一样

那就是 /etc/init.d 下的几个档案
1. boot.local –> 这个开机启动档案会在 rc5.d 前就有动作
2. halt.local –> 这个关机启动档案会在最后有动作
3. before.local –> 这个档案比较用不到所以不需多做解释
4. after.local –> 这个档案会在 rc5.d 之后有动作 , 就是最重要的开机启动档 ， 没有的话 新建一个
 
上面第三及第四个档案预设是不存在的喔!!
当你看过 /etc/init.d/rc 这个档案就知道为什幺了
所以当你要使用第三或第四个档案时请自己建立, 就像妳写个 shell 一样很简单

例:
`vi /etc/init.d/after.local`
 

```
#! /bin/sh
/usr/tem/run.sh
 
:wq
```