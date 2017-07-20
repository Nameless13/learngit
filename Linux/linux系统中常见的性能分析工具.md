title: linux系统中常见的性能分析工具
categories: [Linux]
date: 2017-05-24
---
linux系统中常见的性能分析工具
## vmstat
            vmstat是linux/unix上一个监控工具，能展示给定时间间隔的服务器的状态，包括操作系统的内存信息，CPU使用状态、进程信息等。
语法：
vmstat [-V] [delay [count]]
    #-V     打印出vmstat工具的版本信息
    #delay  设置两次输出的时间间隔
    #count  设置总共输出的次数

---
```
host-xxx-xxx-xxx-xxx:~ # vmstat -V
procps version 3.2.7
host-xxx-xxx-xxx-xxx:~ # vmstat 2 3
procs -----------memory---------- ---swap-- -----io---- -system-- -----cpu------
 r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id wa st
 0  0      0 13107104 1981044 766592    0    0     0    18    0    1  0  0 100  0  0
 0  0      0 13106776 1981044 766592    0    0     0     0  833  697  0  0 100  0  0
 0  0      0 13106784 1981044 766592    0    0     0     0  391  427  0  0 100  0  0
```

对输出参数进行讲解
    procs
        r：运行进程数（即真正分配到cpu的进程数量），如果该值长期大于系统逻辑cpu的数量，表示cpu不足
        b：表示阻塞的进程数
    memory
        swpd：表示正在使用的虚拟内存的多少
        free：表示当前空闲的物理内存的大小
        buff：表示当前使用的buffers的大小
        cached：表示当前使用的cached的大小
buffers和cached的区别：
    ①buffers和cached都是内存的一部分
    ②buffers是内存与磁盘之间的，当对磁盘进行读写操作时，内存先将数据缓存到buffers中，然后再写入磁盘;cached是cpu和内存之间的，cached是缓存读取过的内容，下次再读时，如果在缓存中命中，则直接从缓存读取，否则读取磁盘。
      swap
        si：表示从磁盘读入到虚拟内存的大小
        so：表示从虚拟内存写入到磁盘的大小

如果si和so长期不为0,表示系统内存不足;而如果swpd的值长期不为0,但si和so的值长期为0,则无需担心
      io
        bi：表示从磁盘读取数据的总量
        bo：表示写入磁盘的数据总量
      system
        in：表示系统中断数
        cs：表示每秒产生的上下文切换次数
in和cs的值越大，内核消耗cpu时间越大
      cpu
         us：用户进程消耗的cpu时间所占百分比
         sy：内核进程消耗的cpu时间所占百分比
          id：cpu空闲状态的时间百分比
          wa：表示IO等待所占用的cpu时间百分比

us+sy+id=100

## sar命令
 sar命令可以获取系统的cpu、磁盘、内存、网络运行状态等信息
常见用法有

---
host-xxx-xxx-xxx-xxx:~ # sar -u 1 3
Linux 3.0.76-0.11-default (host-10-200-43-168)  10/19/16    _x86_64_

10:00:56        CPU     %user     %nice   %system   %iowait    %steal     %idle
10:00:57        all      0.12      0.00      0.12      0.00      0.00     99.75
10:00:58        all      0.25      0.00      0.25      0.00      0.00     99.50
10:00:59        all      0.00      0.00      0.00      0.00      0.00    100.00
Average:        all      0.13      0.00      0.13      0.00      0.00     99.75

host-xxx-xxx-xxx-xxx:~ # sar -P 0 1 2
Linux 3.0.76-0.11-default (host-10-200-43-168)  10/19/16    _x86_64_

10:02:10        CPU     %user     %nice   %system   %iowait    %steal     %idle
10:02:11          0      0.00      0.00      1.00      0.00      0.00     99.00
10:02:12          0      3.00      0.00      0.00      0.00      0.00     97.00
Average:          0      1.50      0.00      0.50      0.00      0.00     98.00
host-xxx-xxx-xxx-xxx:~ # sar -d 1 3
Linux 3.0.76-0.11-default (host-10-200-43-168)  10/19/16    _x86_64_

10:02:20          DEV       tps  rd_sec/s  wr_sec/s  avgrq-sz  avgqu-sz     await     svctm     %util
10:02:21     dev202-0      0.00      0.00      0.00      0.00      0.00      0.00      0.00      0.00
10:02:21     dev253-0      0.00      0.00      0.00      0.00      0.00      0.00      0.00      0.00
10:02:21     dev253-1      0.00      0.00      0.00      0.00      0.00      0.00      0.00      0.00
10:02:21     dev253-2      0.00      0.00      0.00      0.00      0.00      0.00      0.00      0.00

10:02:21          DEV       tps  rd_sec/s  wr_sec/s  avgrq-sz  avgqu-sz     await     svctm     %util
10:02:22     dev202-0      0.99      0.00     15.84     16.00      0.00      0.00      0.00      0.00
10:02:22     dev253-0      1.98      0.00     15.84      8.00      0.00      0.00      0.00      0.00
10:02:22     dev253-1      0.00      0.00      0.00      0.00      0.00      0.00      0.00      0.00
10:02:22     dev253-2      0.00      0.00      0.00      0.00      0.00      0.00      0.00      0.00

10:02:22          DEV       tps  rd_sec/s  wr_sec/s  avgrq-sz  avgqu-sz     await     svctm     %util
10:02:23     dev202-0      0.00      0.00      0.00      0.00      0.00      0.00      0.00      0.00
10:02:23     dev253-0      0.00      0.00      0.00      0.00      0.00      0.00      0.00      0.00
10:02:23     dev253-1      0.00      0.00      0.00      0.00      0.00      0.00      0.00      0.00
10:02:23     dev253-2      0.00      0.00      0.00      0.00      0.00      0.00      0.00      0.00

Average:          DEV       tps  rd_sec/s  wr_sec/s  avgrq-sz  avgqu-sz     await     svctm     %util
Average:     dev202-0      0.34      0.00      5.39     16.00      0.00      0.00      0.00      0.00
Average:     dev253-0      0.67      0.00      5.39      8.00      0.00      0.00      0.00      0.00
Average:     dev253-1      0.00      0.00      0.00      0.00      0.00      0.00      0.00      0.00
Average:     dev253-2      0.00      0.00      0.00      0.00      0.00      0.00      0.00      0.00
host-xxx-xxx-xxx-xxx:~ # sar -r 1 3
Linux 3.0.76-0.11-default (host-10-200-43-168)  10/19/16    _x86_64_

10:02:32    kbmemfree kbmemused  %memused kbbuffers  kbcached  kbcommit   %commit
10:02:33     13106232   3189176     19.57   1981048    766804   1231016      6.01
10:02:34     13105448   3189960     19.58   1981048    766804   1231016      6.01
10:02:35     13105448   3189960     19.58   1981048    766804   1231016      6.01
Average:     13105709   3189699     19.57   1981048    766804   1231016      6.01
host-xxx-xxx-xxx-xxx:~ # sar -n DEV 1 1
Linux 3.0.76-0.11-default (host-10-200-43-168)  10/19/16    _x86_64_

10:03:02        IFACE   rxpck/s   txpck/s    rxkB/s    txkB/s   rxcmp/s   txcmp/s  rxmcst/s
10:03:03           lo      0.00      0.00      0.00      0.00      0.00      0.00      0.00
10:03:03         eth0    371.72    363.64     58.21     28.63      0.00      0.00      0.00

Average:        IFACE   rxpck/s   txpck/s    rxkB/s    txkB/s   rxcmp/s   txcmp/s  rxmcst/s
Average:           lo      0.00      0.00      0.00      0.00      0.00      0.00      0.00
Average:         eth0    371.72    363.64     58.21     28.63      0.00      0.00      0.00
注意要点：
    -u表示查看系统cpu整体的使用状态，-P可以分开查询每个cpu的使用情况，其中对cpu的计数是从0开始的

## iostat
可以对系统磁盘的IO操作进行监控，同时也可以输出显示cpu的使用情况
语法：

iostat options [interval [count]]
options
说明
-c
显示cpu的使用情况
-d
显示磁盘的使用情况
-k
表示以KB为单位显示数据
-x device
指定要统计的磁盘设备

host-xxx-xxx-xxx-xxx:~ # iostat -d -k
Linux 3.0.76-0.11-default (host-10-200-43-168)  10/19/16    _x86_64_

Device:            tps    kB_read/s    kB_wrtn/s    kB_read    kB_wrtn
xvda              3.65         0.08       144.00     556844  970083876
dm-0              0.69         0.07         2.75     494361   18546224
dm-1             35.31         0.00       141.22      13817  951330764
dm-2              0.01         0.00         0.03      24905     206736

KB_read/s:表示每秒读取的数据块数量
KB_wrtn/s:表示每秒写入的数据块数量
KB_read:表示总共读的数据块数量KB_wrtn:表示总共写的数据块数量

## netstat
    可以显示网络连接、端口状态和路由表等信息
语法：netstat [options]
常见option
说明
-a
显示所有的连接和监听的端口
-r
显示路由信息
-t
显示tcp连接
-u
显示udp连接
-l
显示连接状态为LISTEN的连接
-p
显示连接对应的PID
-n
以IP和端口的形式显示连接
比较常见用法：
netstat -plnt
netstat -puln
netstat -r

## free
    监控linux内存的使用情况
host-xxx-xxx-xxx-xxx:~ # free
             total       used       free     shared    buffers     cached
Mem:      16295408    3190164   13105244          0    1981048     766576
-/+ buffers/cache:     442540   15852868
Swap:      4193276          0    4193276

## uptime
    可以查看系统的启动时长和cpu的负载情况
host-xxx-xxx-xxx-xxx:~ # uptime 
 10:12am  up 77 days 23:17,  3 users,  load average: 0.08, 0.12, 0.13
系统现在时间    启动时长   登录用户数量      1分钟内的平均负载  5分钟内的平均负载   15分钟内的平均负载
注意：load average的三个输出值如果大于系统逻辑cpu数量时，表示cpu繁忙，会影响系统性能
 