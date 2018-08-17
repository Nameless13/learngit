#!/bin/sh

DEVICE_LIST="/dev/sda /dev/sdb /dev/sdc /dev/sdd /dev/sde /dev/sdf /dev/sdg /dev/sdh"
#DEVICE_LIST="/dev/sdb"

for DEVICE in $DEVICE_LIST
do
  echo "+++++create partition for $DEVICE......"
  parted -s $DEVICE mklabel gpt mkpart primary ext4 0% 100%
  PARTITION="$DEVICE""1"
  echo "+++++formatting $PARTITION......"
  mkfs.ext4 -T largefile $PARTITION
done
