ddp-dn-11:~ # cat umountdisk.sh 
#!/bin/sh

PARTITION_LIST="sdb1 sdc1 sdd1 sde1 sdf1 sdg1 sdh1 sdi1 sdj1 sdk1 sdl1 sdm1"
#PARTITION_LIST="sdb1 sdc1 sdd1 sde1 sdf1 sdg1 sdh1 sdi1 sdj1 sdk1 sdl1"

for PARTITION in $PARTITION_LIST
do
  echo "umount /dev/$PARTITION"
  umount /dev/$PARTITION
done

#show mounted partitions
df -h
