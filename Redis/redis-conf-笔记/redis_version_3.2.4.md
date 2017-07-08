title: redis_version_3.2.4
categories: 
- redis
- redis-conf-笔记
date: 2016-09-07
---
redis_version:3.2.4                                                                                     //Redis 服务器版本
redis_git_sha1:00000000                                                                                     //Git SHA1
redis_git_dirty:0                                                                                   //Git dirty flag
redis_build_id:96326b2f9b8cf2d2
redis_mode:standalone
os:Linux 3.10.0-327.el7.x86_64 x86_64                                                                                   //Redis 服务器的宿主操作系统
arch_bits:64                                                                                    // 架构（32 或 64 位）
multiplexing_api:epoll                                                                                      // Redis 所使用的事件处理机制
gcc_version:4.8.5                                                                                       //编译 Redis 时所使用的 GCC 版本
process_id:23278                                                                                    //服务器进程的 PID
run_id:f5284394b52327c8697f7bff3995643dcbc2af7b                                                                                     //Redis 服务器的随机标识符（用于 Sentinel 和集群）
tcp_port:7380                                                                                   //TCP/IP 监听端口
uptime_in_seconds:617                                                                                       //自 Redis 服务器启动以来，经过的秒数
uptime_in_days:0                                                                                        // 自 Redis 服务器启动以来，经过的天数
hz:10
lru_clock:16720581                                                                                      //以分钟为单位进行自增的时钟，用于 LRU 管理
executable:/root/redis-server  
config_file:/etc/redis/7380.conf

# Clients
connected_clients:7                                                  : 已连接客户端的数量（不包括通过从属服务器连接的客户端）
client_longest_output_list:0                                                 : 当前连接的客户端当中，最长的输出列表
client_biggest_input_buf:0                                                   : 当前连接的客户端当中，最大输入缓存
blocked_clients:0                                                : 正在等待阻塞命令（BLPOP、BRPOP、BRPOPLPUSH）的客户端的数量

# Memory
used_memory:6210872                                                  : 由 Redis 分配器分配的内存总量，以字节（byte）为单位
used_memory_human:5.92M                                                  : 以人类可读的格式返回 Redis 分配的内存总量
used_memory_rss:2621440                                                  : 从操作系统的角度，返回 Redis 已分配的内存总量（俗称常驻集大小）。这个值和 top 、 ps 等命令的输出一致。
used_memory_rss_human:2.50M  
used_memory_peak:6332792                                                 : Redis 的内存消耗峰值（以字节为单位）
used_memory_peak_human:6.04M                                                
total_system_memory:8087961600  
total_system_memory_human:7.53G
used_memory_lua:37888    Lua 引擎所使用的内存大小（以字节为单位）
used_memory_lua_human:37.00K
maxmemory:2147483648
maxmemory_human:2.00G
maxmemory_policy:noeviction
mem_fragmentation_ratio:0.42                                                 : used_memory_rss 和 used_memory 之间的比率
mem_allocator:jemalloc-4.0.3                                                 : 在编译时指定的， Redis 所使用的内存分配器。可以是 libc 、 jemalloc 或者 tcmalloc 

        在理想情况下， used_memory_rss 的值应该只比 used_memory 稍微高一点儿。
当 rss > used ，且两者的值相差较大时，表示存在（内部或外部的）内存碎片。
内存碎片的比率可以通过 mem_fragmentation_ratio 的值看出。
当 used > rss 时，表示 Redis 的部分内存被操作系统换出到交换空间了，在这种情况下，操作可能会产生明显的延迟。
        Because Redis does not have control over how its allocations are mapped to memory pages, high used_memory_rss is often the result of a spike in memory usage.
当 Redis 释放内存时，分配器可能会，也可能不会，将内存返还给操作系统。
如果 Redis 释放了内存，却没有将内存返还给操作系统，那么 used_memory 的值可能和操作系统显示的 Redis 内存占用并不一致。
查看 used_memory_peak 的值可以验证这种情况是否发生。

# Persistence                                                    : RDB 和 AOF 的相关信息
loading:0
rdb_changes_since_last_save:0
rdb_bgsave_in_progress:0
rdb_last_save_time:1476337757
rdb_last_bgsave_status:ok
rdb_last_bgsave_time_sec:0
rdb_current_bgsave_time_sec:-1
aof_enabled:1
aof_rewrite_in_progress:0
aof_rewrite_scheduled:0
aof_last_rewrite_time_sec:-1
aof_current_rewrite_time_sec:-1
aof_last_bgrewrite_status:ok
aof_last_write_status:ok
aof_current_size:0
aof_base_size:0
aof_pending_rewrite:0
aof_buffer_length:0
aof_rewrite_buffer_length:0
aof_pending_bio_fsync:0
aof_delayed_fsync:0

# Stats                                                  : 一般统计信息
total_connections_received:9
total_commands_processed:3497
instantaneous_ops_per_sec:6
total_net_input_bytes:180031
total_net_output_bytes:12844181
instantaneous_input_kbps:0.35
instantaneous_output_kbps:1.08
rejected_connections:0
sync_full:1
sync_partial_ok:0
sync_partial_err:0
expired_keys:0
evicted_keys:0
keyspace_hits:0
keyspace_misses:0
pubsub_channels:1
pubsub_patterns:0
latest_fork_usec:83
migrate_cached_sockets:0

# Replication                                                : 主/从复制信息
role:master
connected_slaves:1
slave0:ip=192.168.29.136,port=7381,state=online,offset=128863,lag=0
master_repl_offset:128863
repl_backlog_active:1
repl_backlog_size:5242880
repl_backlog_first_byte_offset:2
repl_backlog_histlen:128862

# CPU                                                : CPU 计算量统计信息
used_cpu_sys:0.33
used_cpu_user:0.20
used_cpu_sys_children:0.00
used_cpu_user_children:0.00

# Cluster                                                : Redis 集群信息
cluster_enabled:0

# Keyspace
