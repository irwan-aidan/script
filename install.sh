#!bin/bash

#Cai dat Cyberpanel
install(){
	wget -O cyberpanel.sh https://cyberpanel.net/install.sh
	chmod +x cyberpanel.sh
	./cyberpanel.sh -v ols -c 1 -a 1 -p r
}

#Thay doi gia tri PHP
change(){
	cd /usr/local/lsws/
	find ./  -type f -name "php.ini" | xargs sed -i -e 's/2M/1024M/g' -e 's/128M/256M/g' -e 's/8M/1024M/g'
	echo "max_allowed_packet=1024M" >> /etc/my.cnf
	service lscpd restart
}

delete(){
	rm -rf install* cyberpanel*
}

if	grep -q -i "release 7" /etc/redhat-release ; then
	echo "Update CentOS moi nhat"
	sleep 2 && yum update -y
	install
	change
	sleep 2 && delete
else
	echo "Cyberpanel khong ho tro hien tai:`cat /etc/*-release`"
	delete
fi
