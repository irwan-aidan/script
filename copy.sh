#!/bin/bash
echo "======================================="
while read -p "Backup website: " back 
do	if [[ -d $back ]]; then
		break
        else	
		echo "$back not found, please try again"
        fi
done
#Variable
bkdir=backup/
web=$back/DocumentRoot
#Check config
if [ -f $web/wp-config.php ]; then
	config=$web/wp-config.php
	rm -f $back/wp-config.php
elif [ -f $back/wp-config.php ]; then
	config=$back/wp-config.php
else
	echo "Config website not found"
	exit
fi
#Variable
user=$(grep DB_USER $config | awk -F\' '{print$4}')
db=$(grep DB_NAME $config | awk -F\' '{print$4}')
pass=$(grep DB_PASSWORD $config | awk -F\' '{print$4}')
mkdir -p $bkdir
#Backup database
mysqldump --user $user --password=$pass $db > "$bkdir"backup.sql
if [ $? -eq 0 ] ; then
	echo "Backup database successful"
	echo "======================================="
else
	echo "Backup database fail"
fi

while read -p "Website restore: " restore
do
	if [[ -d $restore ]]; then
		break
	else
		echo "$restore not found, please try again"
	fi
done
conf=$restore/wp-config.php
u1=$(grep DB_USER $conf | awk -F\' '{print$4}')
d1=$(grep DB_NAME $conf | awk -F\' '{print$4}')
p1=$(grep DB_PASSWORD $conf | awk -F\' '{print$4}')
rm -rf $restore/DocumentRoot
mysql -u $u1 -p$p1 $d1 < "$bkdir"backup.sql
if [ $? -eq 0 ] ; then
	echo "Restore database successful"
else
	echo "Restore database fail"
fi
cp -r $web $ $restore > /dev/null 2>&1
echo "Copy code website $domain successful"
rm -rf $bkdir
