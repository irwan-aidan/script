#!/bin/bash
echo "Connect server successful"
indomain (){
	echo "Website need restore:"
	read domain
}

indomain
while [ ! -d /home/*/$domain ]; do
	echo "$domain not found, please try again"
	indomain	
done

rm -rf /home/*/$domain/DocumentRoot
config=/home/*/$domain/wp-config.php

user=$(grep DB_USER $config | awk -F\' '{print$4}')
db=$(grep DB_NAME $config | awk -F\' '{print$4}')
pass=$(grep DB_PASSWORD $config | awk -F\' '{print$4}')
unzip -q *.zip 
mv -f home/*/$domain/DocumentRoot/ /home/*/$domain/

mysql -u $user -p$pass $db < backup.sql
if [ "$?" -eq 0 ] ; then
    echo "======================================="
	echo "Restore successful"
	rm -rf /home/*/backup
else
	echo "Restore fail"
fi
