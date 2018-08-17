ddp-dn-11:~ # cat formatdisk.sh 
#!/bin/sh

DEVICE_LIST="/dev/sdb /dev/sdc /dev/sdd /dev/sde /dev/sdf /dev/sdg /dev/sdh /dev/sdi /dev/sdj /dev/sdk /dev/sdl /dev/sdm"
#DEVICE_LIST="/dev/sdb /dev/sdc /dev/sdd /dev/sde /dev/sdf /dev/sdg /dev/sdh /dev/sdi /dev/sdj /dev/sdk /dev/sdl"
#DEVICE_LIST="/dev/sdl"
for DEVICE in $DEVICE_LIST
do
  echo "+++++create partition for $DEVICE......"
  parted -s $DEVICE mklabel gpt mkpart primary ext3 0% 100%
  PARTITION="$DEVICE""1"
  #PARTITION="$DEVICE"
  echo "+++++formatting $PARTITION......"
  sleep 1
  mkfs.ext3 -T largefile $PARTITION
  #mkfs -t ext4 -j -m 1 -O extent,dir_index,spare_super $PARTITION
done
