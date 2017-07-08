title: redis_version_3.2.4-sc
categories: 
- redis
- redis-conf-笔记
date: 2017-07-05
---
127.0.0.1:6379> info
# Server
redis_version:3.2.3
redis_git_sha1:00000000
redis_git_dirty:0
redis_build_id:276113d15453bda8
redis_mode:cluster
os:Linux 3.0.76-0.11-default x86_64
arch_bits:64
multiplexing_api:epoll
gcc_version:4.3.4
process_id:21542
run_id:9bb6d2f200729eb837c86510afcc7025dec26586
tcp_port:6379
uptime_in_seconds:6130854
uptime_in_days:70
hz:10
lru_clock:16723061
executable:/usr/local/bin/redis-server
config_file:/etc/redis/redis.conf

# Clients
connected_clients:358
client_longest_output_list:0
client_biggest_input_buf:0
blocked_clients:0

# Memory
used_memory:151730448
used_memory_human:144.70M
used_memory_rss:159973376
used_memory_rss_human:152.56M
used_memory_peak:677126784
used_memory_peak_human:645.76M
total_system_memory:16686497792
total_system_memory_human:15.54G
used_memory_lua:37888
used_memory_lua_human:37.00K
maxmemory:8589934592
maxmemory_human:8.00G
maxmemory_policy:noeviction
mem_fragmentation_ratio:1.05
mem_allocator:jemalloc-4.0.3

# Persistence
loading:0
rdb_changes_since_last_save:11820
rdb_bgsave_in_progress:0
rdb_last_save_time:1476340843
rdb_last_bgsave_status:ok
rdb_last_bgsave_time_sec:1
rdb_current_bgsave_time_sec:-1
aof_enabled:0
aof_rewrite_in_progress:0
aof_rewrite_scheduled:0
aof_last_rewrite_time_sec:-1
aof_current_rewrite_time_sec:-1
aof_last_bgrewrite_status:ok
aof_last_write_status:ok

# Stats
total_connections_received:136623
total_commands_processed:3090632890
instantaneous_ops_per_sec:1288
total_net_input_bytes:274676332779
total_net_output_bytes:20528196260
instantaneous_input_kbps:108.62
instantaneous_output_kbps:8.95
rejected_connections:0
sync_full:0
sync_partial_ok:0
sync_partial_err:0
expired_keys:43
evicted_keys:0
keyspace_hits:512379822
keyspace_misses:419500843
pubsub_channels:0
pubsub_patterns:0
latest_fork_usec:3517
migrate_cached_sockets:0

# Replication
role:master
connected_slaves:0
master_repl_offset:0
repl_backlog_active:0
repl_backlog_size:1048576
repl_backlog_first_byte_offset:0
repl_backlog_histlen:0

# CPU
used_cpu_sys:51186.74
used_cpu_user:45645.72
used_cpu_sys_children:2273.35
used_cpu_user_children:58689.30

# Cluster
cluster_enabled:1

# Keyspace
db0:keys=3,expires=2,avg_ttl=86397596
