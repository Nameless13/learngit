每日定时遍历出HDFS上目录空间 并发送邮件
crontab -e
0 09 */1 * * sh /logs/script/getdata.sh

---
#!/bin/bash
getdate=\/logs\/HDFS_`date '+%Y-%m-%d'.log`
root_dir="/user/"
# 测试环境密码
passwd='123456'
function getdir(){
for path2 in `hdfs dfs -ls -C $1`
  do
    hdfs dfs -du -s $path2
    for path3 in `hdfs dfs -ls -C $path2 `
      do
        hdfs dfs -du $path3
        # echo $path3
      done
        echo ""
        echo ""
  done
}
/usr/bin/expect <<-EOF
set time 30
spawn kinit hdfs
expect {
         "*CMDMP.COM:*" { send "$passwd\r" }
        }
interact
expect eof
EOF
getdir $root_dir > "$getdate" && python /logs/script/sendmail.py



---


awk '{for(i=1;i<=NF;i++)printf("%.2f\t",$1,$2);printf("\n");}' test.log
awk '{print $3,$1/1024/1024/1024"gb",$2/1024/1024/1024"gb"}' test.log


awk '{for(i=1;i<=NF;i++)printf("%.2f\t",$1/1024/1024/1024"gb");printf("%.2f\t",$2/1024/1024/1024"gb");printf("\n");}' test.log



awk '{printf("%.2f\t%.2f\n",$1/1073741824,$2/1073741824) }' test.log	




