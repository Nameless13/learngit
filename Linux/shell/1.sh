get_passwdfile() {
/usr/bin/expect <<EOF
spawn scp -q $CONFUSER@$CONFSERVER:$CONFPATH$1 ./ 
set timeout 30
expect { 
	"yes/no" { send "yes\r";exp_continue}
 	"password:" {send "$CONFPASSWD\r"}
	}
set timeout 30
expect eof
EOF
}
