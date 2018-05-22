#!/bin/bash
USER_UID=root
USER_DIR=/root
IP_PW='mg123!@#'

establishSSH ()
{
cat >establishSSH.exp<<EOF
#!/usr/bin/expect
spawn ssh-copy-id -i $USER_DIR/.ssh/id_rsa.pub $SSH_IP
expect {
	"*yes/no" {send "yes\r"; exp_continue}
	"*password" {send "$IP_PW\r";}
}
expect eof
EOF
chmod 755 establishSSH.exp
./establishSSH.exp > /dev/null
/bin/rm -rf establishSSH.exp
}

##############################main################################

if [ -f servers.txt ]
	then
	 :
	else
		echo
		echo "---------Please touch File: servers.txt ---------"
		echo "######### servers.txt For Example #########"
		echo "192.168.100.10"
		exit 0
fi

if ( rpm -qa | grep -q expect)
	then
	:
else
	yum -y install expect > /dev/null
fi

if [ -f $USER_DIR/.ssh/id_rsa.pub ] 
	then
	:
else
	ssh-keygen
fi

for SSH_IP in `cat servers.txt`
do 
	establishSSH
	if [ $? -eq 0 ]
		then
			echo "-----------$SSH_IP is OK-----------"
		else
			echo "-----------$SSH_IP is failed-----------"
	fi
done

