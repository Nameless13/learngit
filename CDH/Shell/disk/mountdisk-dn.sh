#!/bin/sh

#backup /etc/fstab
cp /etc/fstab /etc/fstab.bak
PARTITION_LIST="sdb1 sdc1 sdd1 sde1 sdf1 sdg1 sdh1 sdi1 sdj1 sdk1 sdl1 sdm1 sdn1 sdo1 sdp1 sdq1 sdr1 sds1 sdt1 sdu1 sdv1 sdw1 sdx1 sdy1"
#PARTITION_LIST="sdb1"
for PARTITION in $PARTITION_LIST
do
  UUID=`blkid "/dev/""$PARTITION" | awk '{print $2}' | sed 's/\"//g'`
  echo $UUID

  echo "add $PARTITION to /etc/fstab"
  MOUNTDIR="/mnt/""$PARTITION"
  echo "mkdir -p $MOUNTDIR"
  mkdir -p $MOUNTDIR

  #remove existing mount point
  mp="$PARTITION"
  sed -i '/'"$mp"'/d' /etc/fstab

  echo "appending \"$UUID $MOUNTDIR ext4 defaults 0 0\" to /etc/fstab "
  echo "/dev/$PARTITION $MOUNTDIR ext4 defaults,noatime,nodiratime,barrier=0,data=writeback,commit=100 0 0" >> /etc/fstab
  echo "" 
done

#mount all partitions
mount -a

#show mounted partitions
df -h

