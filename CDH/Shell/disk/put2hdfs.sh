cat puttohdfs.sh 
#!/bin/bash
getdate=\/logs\/HDFS_`date '+%Y-%m-%d'.log`
root_dir="/user/"
passwd='Sxdmp123!@#'
tpasswd='thadoop123!@#'


#hdfs 用户认证
function kinituser(){
/usr/bin/expect <<-EOF
set time 30
spawn kinit hdfs
expect {
         "*CMDMP.COM:*" { send "$passwd\r" }
        }
interact
expect eof
EOF
}

#获取4级空间占用
function getdir(){
for path2 in `hdfs dfs -ls -C $1`
  do
    hdfs dfs -du -s $path2
    for path3 in `hdfs dfs -ls -C $path2 `
      do
        hdfs dfs -du $path3        
      done
        echo ""
        echo ""
  done
}

# 将生成的日志发给测试集群的机器
# function sendlog(){
# /usr/bin/expect <<-EOFF
# set time 30
# spawn scp $getdate thadoop@10.200.65.52:$getdate
# expect {
#           "*yes*" {send "yes\r"
#                     expect "*password:*" {send "$tpasswd\r"} 
#                   }
#           "*password:*" {send "$tpasswd\r"}
# }
# interact
# expect eof
# EOFF
# }

# 远程登录并上传至HDFS
# function pthdfs(){
# /usr/bin/expect <<-EOFFF
# set timeout 60
# spawn ssh thadoop@10.200.65.52
# expect {
#   "*yes*" { send "yes\r"; exp_continue}
#   "*password:*" {send "$tpasswd\r"}
# }
# expect "*thadoop*"
# send "kinit -kt /home/thadoop/thadoop.keytab thadoop\r"
# send "hdfs dfs -put $getdate /user/thadoop/pro_hdfs/\r"
# expect "*thadoop*"
# send "exit\r"
# expect eof
# EOFFF
# }

# 上传至HDFS
function put2hdfs(){
  hdfs dfs -put $getdate /user/thadoop/pro_hdfs/

}

kinituser && getdir $root_dir > "$getdate" && put2hdfs && python /logs/script/sendmail.py
