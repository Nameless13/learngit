#!/usr/bin/env bash

CONFSERVER="192.168.29.136"
CONFUSER="devops"
CONFPASSWD="password"
CONFPATH="/opt/passwd/"
CONFFILE="passwd"


LOCALIP=$(netstat -nt | sed -n '3p' | awk -F '[ :]+' '{print $4}')


show_help() {
cat << EOF
Tasks useed for read the passwd file from config server and change the user password.

Tasks provided by the sysv init script:
    username    -  which os username will be change the password 
    help        -  show the help information

EOF
  exit 1
}


user_check() {
tmp_name=$1
is_exists="no"
usernames=$(getent passwd | awk -F: '{print $1}')
for user in $usernames
    do 
	if [ "$user" == "$tmp_name" ];then 
	    is_exists="yes"
	    break
	fi
    done
echo $is_exists
}


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



get_passwd() {
passwd="none"
if [ ! -f "./$CONFFILE" ]; then
    echo "Couldn't get the user passwd file from configure server!" 
    echo $passwd
    exit 1
else
    passwd=$(cat ./$CONFFILE)
    current_time=`date "+%Y-%m-%d %H:%M:%S"`
    #current_timestamp=`date -d "$current_time" +%s`
    current_timestamp=`date +%s`
    #删除空格 空行
    line_count=$(cat ./$CONFFILE | sed 's/[[:space:]]//g' |  sed 's/[[:blank:]]//g'   | sed '/^$/d' | wc -l)
    if [ $line_count -eq 0 ];then 
	echo "The passwd file is null!"
        echo $passwd
        exit 1
    else
        line_num=$[ $current_timestamp % $line_count ]
        passwd=$(cat ./$CONFFILE | sed 's/[[:space:]]//g' |  sed 's/[[:blank:]]//g'  | sed '/^$/d' | head -n  $[ $line_num + 1 ] | tail -n 1 )
        rm -rf ./$CONFFILE
        echo $passwd
        exit 0
    fi
fi
}

writeback_passwd() {
#action="none"
new_passwd=$(echo  $1 | sed 's/\!/\\!/g' | sed 's/\$/\\$/g' | sed 's/\[/\\[/g' )

/usr/bin/expect <<EOF
spawn ssh $CONFUSER@$CONFSERVER "echo '$new_passwd' >>$CONFPATH$LOCALIP" 
set timeout 30
expect { 
	"yes/no" { send "yes\r";exp_continue}
        "password:" {send "$CONFPASSWD\r"}
        }
set timeout 30
expect eof
EOF
}




change_passwd() {
writeback_passwd $2
echo $2
get_passwdfile $LOCALIP

if [ ! -f "./$LOCALIP" ]; then
    echo "Couldn't get the user password writeback file from configure server!" 
    exit 1
else
    f_passwd=$(tail -1 ./$LOCALIP)
    if [ $f_passwd == $2 ];then 
	echo "OS user $1 will changed passwd to $2"
	echo "$2" | passwd --stdin  $1
    else
	echo "Password Couldn't writeback or check$1!"
	exit 1
    fi
    rm -rf ./$LOCALIP
fi
}





# Main Program start--------------------------------------------
if [ $UID -ne 0 ]; then
    echo "Usage:`basename $0` run in root user!"
    exit 1	
fi


if [ $# != 1 ]; then 
    echo "Usage:`basename $0` [osusername| help]" >&2
    exit 1
fi


case "$1" in
  help)
    show_help
    ;;
  *)
    if [ $(user_check $1) == "yes" ];then 
	echo "User Exists!"
    #get_passwdfile的$1 变为$CONFFILE 的值:passwd

	get_passwdfile $CONFFILE
 	m_passwd=$(get_passwd)
	if [ "$m_passwd" != "none" -a $? = 0 ];then
	    # got the user's passwd 
	    change_passwd $1 $m_passwd
	    if [ $? = 0 ];then 
		# successed changed passwd
		echo "OS user $1 had successed changed passwd!"
	    else
		echo "OS user $1 had not changed passwd!"
	    fi
	else
	    echo "Couldn't get the user passwd!"
	fi
    else
    	echo "Your parameter \"$1\" is not a OS username!"
    	exit 1 
    fi
    ;;
esac



 *)
    if [ $(user_check $1) == "yes" ];then
        echo "User Exists!"
        get_passwdfile $CONFFILE
        m_passwd=$(get_passwd)
   #     if [ "$m_passwd" !="none" -a $? = 0 ];then
        if [ "$m_passwd" != "none" -a $? = 0 ];then
          change_passwd $1 $m_passwd
          if [ $?=0 ];then
                echo "OS user $1 had successed changed passwd!"
            else
                echo "OS user $1 had not changed passwd!"
           fi
        else
        echo "Couldn't get the user passwd!"
        fi
else
echo "Your parameter \"$1\" is not a OS username!"
        exit 1
    fi
    ;;
esac
