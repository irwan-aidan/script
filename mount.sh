#!/bin/bash
read -p "The folder to mount to external disk: " dir
while [[ ! -d $dir ]]; do
	echo "Folder $dir not found, try again"
	read -p "The folder to mount to external disk:" dir
done
disk=`parted -l 2>&1 > /dev/null | awk -F ':' {'print $2'} | grep -Ev '[0-9]$|Warning|Read-only'`
if [[ -n "$disk" ]]; then
	echo "External disk ready to format and mount"
else
	echo "No external disk found"
	sleep 2 && exit
fi
#Start mount data to external disk
mkdir -p /backup
mkfs.ext4 $disk > /dev/null 2>&1
mount $disk /backup
echo "======================================================================"
echo "Start sync data to external disk"
rsync -a --info=progress2 $dir /backup
umount $disk
rm -rf $dir/* /backup
mount $disk $dir
echo "$disk $dir ext4 defaults 0 1" >> /etc/fstab
read -p "The process mount successful. Do you want to restart the server? [Y/n]: " boot
if [[ "$boot" = "Y" ]] || [[ "$boot" = "y" ]] || [[ -z "$boot" ]]; then
	reboot
fi
#Destroy disk
#wipefs -a /dev/vdb
