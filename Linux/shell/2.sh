start() {
/usr/bin/expect<<EOF
spawn scp -q root@192.168.29.136:/opt/testpasswd ./
set timeout 30
expect{
	"yes/no" {send "yes\r";exp_continue}
	"password:" {send "liketeng123456\r"}
	}
set timeout 30
expect eof
EOF
}
