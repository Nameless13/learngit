for i in `cat ~/servers.txt`
do
    echo "--------------begin to add route to $i--------------"
    ssh $i 'route add -net 10.200.0.0/16 gw 10.151.0.1'
    ssh $i 'route add -net 10.125.137.0/24 gw 10.151.0.1'
   #scp /etc/rc.d/rc.local $i:/etc/rc.d/rc.local
done





