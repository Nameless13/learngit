title: Linux Performance Observability Tools
categories: [Linux]
date: 2016-09-07
---
## agenda

a brief discussion of 6 facets of Linux performance:

1. observalility
2. Methodologies
3. benchmarking
4. profiling
5. tracing
6. tuning

---
### observability tools

- Tools showcase common metrics
    + lenrning linux tools is useful even if you never use them:
    the same metrics are in GUIs
- we usually use these metrics via:
    + netflix atlas: cloud-wide monitoring
    + netflix vector: instance analysis
- Linux has many tools
    + plus many extra kernel sourcse of data that lack tools,are harder to use ,and are practically undocumented

----
#### uptime

- one way to print load averages:
- a measure of resource demand: CPUs + disk
    + other OSes only show CPUs: easier to interpret
- exponentially-damped moving averages
- time constants of 1,5,and 15 minutes
    + historic trend without the line graph
- Load > # of CPUs,may mean CPU saturation
    + Don't spent more than 5 seconds studying these 

---
#### top (or htop)
- system and per-process interval summary:
- %CPU is summed across all CPUs
- Can miss short-lives processes(atop won't)
- Can consume noticeable CPU to read/proc

---
#### vmstat
- Virtual memory statistics and more:
- USAGE:vmstat [interval[count]]
- First output line has some summary since boot values 
    + Should be all;partial is confusing
- High level CPU summary
    + "r" is runnable tasks

---
#### iostat
- Block I/O (disk)stats.1st output is since boot.
- very useful set of stats

---
#### free
- Main memory usage:
- buffers: block device I/O cache
- cached: virtua; page cache

---
#### strace
- System call tracer:
- Eg, -ttt:time (us) since epoch;-T:syscall time(s)
- Translates syscall arges
    + very helpful for solving system usage issues
- Currently has massive overhead(ptrace based)
    + can slow the target by > 100x.Use extreme caution.

---
#### tcpdump
- sniff network packets for post analysis:
- study packet sequences with timestamps(us)
- CPU overhead optimized (socket ring buffers),but can still be significant.use caution.

---
netstat
- various network protocol statistics using -s:
- a multi-tool:
    + i:interface stats
    + r:route table
    default:list conns
- netstat -p:shows process details!
- Per-second interval with -c

---
#### slabtop
- Kernel slab allocator memory usage

---
#### pcstat
- show page cache residency 
- Uses the mincore(2)syscall.Useful for database performance analysis.

---
#### perf_events
- Provides the "perf" command
- in Linux source code:tools/perf
    + Usually pkg added by linux-tools-common.etc.
- `Multi-tool` with many capabilities
    + CPU profiling
    + PMC profiling
    + Static & dynamic tracing
- Covered later in Profiling & Tracing

---
### Methodologies

#### anti-Methodologies
- The lack of a deliberate methodology...
- Street Light Anti-Method:
    1. Pick observability tools that are
        * Familiar
        * Found on the Internet
        * Found at random
    2. Run tools
    3. Look for obvious issues
- Drunk Man Anti-Method:
    + Tune things at random until the problem goes away

---

在Linux世界，进程不能直接访问硬件设备，当进程需要访问硬件设备(比如读取磁盘文件，接收网络数据等等)时，必须由用户态模式切换至内核态模式，通 过系统调用访问硬件设备。strace可以跟踪到一个进程产生的系统调用,包括参数，返回值，执行消耗的时间。

----
#### ss
ss -l 显示本地打开的所有端口
ss -pl 显示每个进程具体打开的socket
ss -t -a 显示所有tcp socket
ss -u -a 显示所有的UDP Socekt
ss -o state established '( dport = :smtp or sport = :smtp )' 显示所有已建立的SMTP连接
ss -o state established '( dport = :http or sport = :http )' 显示所有已建立的HTTP连接
ss -x src /tmp/.X11-unix/* 找出所有连接X服务器的进程
ss -s 列出当前socket详细信息:


---
#### strace 
-c 统计每一系统调用的所执行的时间,次数和出错的次数等. 
-d 输出strace关于标准错误的调试信息. 
-f 跟踪由fork调用所产生的子进程. 
-ff 如果提供-o filename,则所有进程的跟踪结果输出到相应的filename.pid中,pid是各进程的进程号. 
-F 尝试跟踪vfork调用.在-f时,vfork不被跟踪. 
-h 输出简要的帮助信息. 
-i 输出系统调用的入口指针. 
-q 禁止输出关于脱离的消息. 
-r 打印出相对时间关于,,每一个系统调用. 
-t 在输出中的每一行前加上时间信息. 
-tt 在输出中的每一行前加上时间信息,微秒级. 
-ttt 微秒级输出,以秒了表示时间. 
-T 显示每一调用所耗的时间. 
-v 输出所有的系统调用.一些调用关于环境变量,状态,输入输出等调用由于使用频繁,默认不输出. 
-V 输出strace的版本信息. 
-x 以十六进制形式输出非标准字符串 
-xx 所有字符串以十六进制形式输出. 
-a column 
设置返回值的输出位置.默认 为40. 
-e expr 
指定一个表达式,用来控制如何跟踪.格式如下: 
[qualifier=][!]value1[,value2]... 
qualifier只能是 trace,abbrev,verbose,raw,signal,read,write其中之一.value是用来限定的符号或数字.默认的 qualifier是 trace.感叹号是否定符号.例如: 
-eopen等价于 -e trace=open,表示只跟踪open调用.而-etrace!=open表示跟踪除了open以外的其他调用.有两个特殊的符号 all 和 none. 
注意有些shell使用!来执行历史记录里的命令,所以要使用\\. 
-e trace=set 
只跟踪指定的系统 调用.例如:-e trace=open,close,rean,write表示只跟踪这四个系统调用.默认的为set=all. 
-e trace=file 
只跟踪有关文件操作的系统调用. 
-e trace=process 
只跟踪有关进程控制的系统调用. 
-e trace=network 
跟踪与网络有关的所有系统调用. 
-e strace=signal 
跟踪所有与系统信号有关的 系统调用 
-e trace=ipc 
跟踪所有与进程通讯有关的系统调用 
-e abbrev=set 
设定 strace输出的系统调用的结果集.-v 等与 abbrev=none.默认为abbrev=all. 
-e raw=set 
将指 定的系统调用的参数以十六进制显示. 
-e signal=set 
指定跟踪的系统信号.默认为all.如 signal=!SIGIO(或者signal=!io),表示不跟踪SIGIO信号. 
-e read=set 
输出从指定文件中读出 的数据.例如: 
-e read=3,5 
-e write=set 
输出写入到指定文件中的数据. 
-o filename 
将strace的输出写入文件filename 
-p pid 
跟踪指定的进程pid. 
-s strsize 
指定输出的字符串的最大长度.默认为32.文件名一直全部输出. 
-u username 
以username 的UID和GID执行被跟踪的命令

