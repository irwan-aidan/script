#!/bin/bash
echo "======================================="
while read -p "Backup website: " domain 
do	if [[ -d $domain ]]; then
		break
        else	
		echo "$domain not found, please try again"
        fi
done
#Variable
bkdir=backup/
web=$domain/DocumentRoot
#Check config
if [ -f $web/wp-config.php ]; then
	config=$web/wp-config.php
	rm -f $domain/wp-config.php
elif [ -f $domain/wp-config.php ]; then
	config=$domain/wp-config.php
else
	echo "Config website not found"
	exit
fi
#Variable
user=$(grep DB_USER $config | awk -F\' '{print$4}')
db=$(grep DB_NAME $config | awk -F\' '{print$4}')
pass=$(grep DB_PASSWORD $config | awk -F\' '{print$4}')
mkdir -p $bkdir
wget -q script.lehait.net/restore.sh -O "$bkdir"restore.sh
#Backup database
mysqldump --user $user --password=$pass $db > "$bkdir"backup.sql
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
remote(){
	read -p "Server need copy website:" host
	read -p "Username SFTP:" acc
	scp -r -P 9090 $bkdir $acc@$host:/home/$acc/
}
#Connect remote hosting and tranfer file
remote
#Check connect
while [ $? -ge 1 ]; do
	echo "Connect fail, please try again"
	remote
done
rm -rf $bkdir
echo "======================================="
echo "Password connect SSH Server"
ssh -p 9090 $acc@$host "cd backup && sh restore.sh"
while [ $? -ge 1 ]; do
	echo "Connect fail, try connect again..."
	ssh -p 9090 $acc@$host "cd backup && sh restore.sh"
done
exit
