#!/bin/sh

DEVICE_LIST="/dev/sdb /dev/sdc /dev/sdd /dev/sde /dev/sdf /dev/sdg /dev/sdh /dev/sdi /dev/sdj /dev/sdk /dev/sdl /dev/sdm /dev/sdn /dev/sdo /dev/sdp /dev/sdq /dev/sdr /dev/sds /dev/sdt /dev/sdu /dev/sdv /dev/sdw /dev/sdx /dev/sdy"
#DEVICE_LIST="/dev/sdb"

for DEVICE in $DEVICE_LIST
do
  echo "umount all"
  umount "$DEVICE""1"
  echo "+++++create partition for $DEVICE......"
  parted -s $DEVICE mklabel gpt mkpart primary ext4 0% 100%
  PARTITION="$DEVICE""1"
  echo "+++++formatting $PARTITION......"
  mkfs.ext4 -T largefile $PARTITION
done
