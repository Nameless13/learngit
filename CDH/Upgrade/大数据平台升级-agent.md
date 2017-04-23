2 packages to upgrade.
Overall download size: 604.1 MiB. After the operation, 59.9 MiB will be freed.
Continue? [y/n/?] (y): y
Retrieving package cloudera-manager-daemons-5.10.0-1.cm5100.p0.85.sles11.x86_64 (1/2), 580.2 MiB (732.1 MiB unpacked)
Retrieving: cloudera-manager-daemons-5.10.0-1.cm5100.p0.85.sles11.x86_64.rpm [.done]
Retrieving package cloudera-manager-agent-5.10.0-1.cm5100.p0.85.sles11.x86_64 (2/2), 23.9 MiB (144.7 MiB unpacked)
Retrieving: cloudera-manager-agent-5.10.0-1.cm5100.p0.85.sles11.x86_64.rpm [done]
Installing: cloudera-manager-daemons-5.10.0-1.cm5100.p0.85.sles11 [..error]
Installation of cloudera-manager-daemons-5.10.0-1.cm5100.p0.85.sles11 failed:
(with --nodeps --force) Error: Subprocess failed. Error: RPM failed: warning: /var/cache/zypp/packages/cloudera-manager/cloudera-manager-daemons-5.10.0-1.cm5100.p0.85.sles11.x86_64.rpm: Header V4 DSA signature: NOKEY, key ID e8f86acd
installing package cloudera-manager-daemons-5.10.0-1.cm5100.p0.85.sles11.x86_64 needs 434MB on the / filesystem




CM前端管理方式安装CDH失败:

1. 主机密码不对
2. 先手工卸载旧rpm包,手工配zypper源安装
3. zypper源指向不对,删除过期的zypper源
4. host mv usr
/etc/hosts 没配
5. host 127.0.0.1 没删,复制114过去
6. 

http://10.200.58.39/repo.html


Usage: 本地Zypper源使用 [适用SUSE]

1. Backup repository.
find /etc/zypp/repos.d -name "*.repo" -exec mv {} {}.bak \;
2. Install
zypper ar http://10.200.58.43/ local.main
3. Update cache
zypper ref


kinint Sxdmp123!@#