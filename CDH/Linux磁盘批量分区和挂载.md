Format
```
#!/bin/sh

#DEVICE_LIST="/dev/sdb /dev/sdc /dev/sdd /dev/sde /dev/sdf /dev/sdg /dev/sdh /dev/sdi /dev/sdj /dev/sdk /dev/sdl /dev/sdm"
DEVICE_LIST="/dev/sdb /dev/sdc"
for DEVICE in $DEVICE_LIST
do
  echo "+++++create partition for $DEVICE......"
  parted -s $DEVICE mklabel gpt mkpart primary ext3 0% 100%
  PARTITION="$DEVICE""1"
  echo "+++++formatting $PARTITION......"
  sleep 1
  mkfs.ext3 -T largefile $PARTITION
  #mkfs -t ext4 -j -m 1 -O extent,dir_index,spare_super $PARTITION
done
```

Mount
```
#!/bin/sh

#backup /etc/fstab
cp /etc/fstab /etc/fstab.bak
PARTITION_LIST="sdb1 sdc1 sdd1 sde1 sdf1 sdg1 sdh1 sdi1 sdj1 sdk1 sdl1 sdm1"
#PARTITION_LIST="sdb1 sdc1"
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

  echo "appending \"$UUID $MOUNTDIR ext3 defaults 0 0\" to /etc/fstab "
  #echo "$UUID $MOUNTDIR ext4 noatime,nodiratime,barrier=0,data=writeback,commit=100 0 0" >> /etc/fstab
  echo "/dev/$PARTITION $MOUNTDIR ext3 defaults,noatime,nodiratime,barrier=0,data=writeback,commit=100 0 0" >> /etc/fstab
  echo "" 
done

#mount all partitions
mount -a

#show mounted partitions
df -h

```