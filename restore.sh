#!/bin/bash
echo "Connect server successful"
echo "Website need restore:"
read domain
while [ ! -d /home/*/$domain ]; do
	echo "$domain not found, please try again"
	read domain
done
#Delete data old 
rm -rf /home/*/$domain/DocumentRoot
config=/home/*/$domain/wp-config.php
user=$(grep DB_USER $config | awk -F\' '{print$4}')
db=$(grep DB_NAME $config | awk -F\' '{print$4}')
pass=$(grep DB_PASSWORD $config | awk -F\' '{print$4}')
unzip -q *.zip 
mv -f */DocumentRoot/ /home/*/$domain/
mysql -u $user -p$pass $db < backup.sql
if [ "$?" -eq 0 ] ; then
    echo "======================================="
	echo "Restore successful"
	rm -rf /home/*/backup
else
	echo "Restore fail"
fi
