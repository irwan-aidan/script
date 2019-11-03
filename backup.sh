#!/bin/bash
indomain (){
	echo "======================================="
	read -p "Backup website:" domain
}

indomain
while [ ! -d $domain ]; do
	echo "$domain not found, please try again"
	indomain	
done

#Check config
if [ -f $domain/DocumentRoot/wp-config.php ]; then
	config=$domain/DocumentRoot/wp-config.php
	rm -f $domain/wp-config.php
elif [ -f $domain/wp-config.php ]; then
	config=$domain/wp-config.php
else
	echo "Config website not found"
	exit
fi
#Variable
bkdir=backup/
web=$domain/DocumentRoot
user=$(grep DB_USER $config | awk -F\' '{print$4}')
db=$(grep DB_NAME $config | awk -F\' '{print$4}')
pass=$(grep DB_PASSWORD $config | awk -F\' '{print$4}')

#Delete backup old & create backup
rm -rf $backup && mkdir -p $bkdir

timeout 3 wget -q script.lehait.net/restore.sh -O "$bkdir"restore.sh
while [ ! -f $bkdir/restore.sh ]; do
	timeout 3 wget -q script.lehait.net/restore.sh -O "$bkdir"restore.sh
done

#Backup database
mysqldump --user $user --password=$pass $db > $bkdir/backup.sql
if [ $? -eq 0 ] ; then
	echo "======================================="
	echo "Backup database successful"
else
	echo "Backup database fail"
fi
#Backup code
zip -r "$bkdir""$domain".zip $web -q -x $web/wp-content/cache/**\*
echo "Backup code successful"
echo "======================================="

rhost (){
	read -p "Server need copy website:" host
	read -p "Username SFTP:" acc
	scp -r -P 9090 $bkdir $acc@$host:/home/$acc/
}

rhost
while [ $? -ge 1 ]; do
	echo "Connect fail, please try again"
	rhost
done

rm -rf $bkdir
rssh(){
    echo "======================================="
	echo "Password connect SSH Server"
	ssh -p 9090 $acc@$host "cd backup && sh restore.sh"
}

rssh
while [ $? -ge 1 ]; do
	echo "Connect fail, please try again"
	rssh
done
exit

