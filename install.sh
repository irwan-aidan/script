#!/bin/bash
cyber(){
	wget -O cyberpanel.sh https://cyberpanel.net/install.sh
	chmod +x cyberpanel.sh
	./cyberpanel.sh -v ols -c 1 -a 1 -p r << EOF
	n
EOF
}
#Thay doi gia tri PHP
centos(){
	cd /usr/local/lsws/
	find ./  -type f -name "php.ini" | xargs sed -i -e 's/2M/1024M/g' -e 's/128M/256M/g' -e 's/8M/1024M/g'
	echo "max_allowed_packet=1024M" >> /etc/my.cnf
	service lscpd restart && service mysql restart
}
ubuntu(){
	cd /usr/local/lsws/
	find ./  -type f -name "php.ini" | xargs sed -i -e 's/2M/1024M/g' -e 's/128M/256M/g' -e 's/8M/1024M/g'
	echo "max_allowed_packet=1024M" >> /etc/mysql/my.cnf
	service lscpd restart && service mysql restart
}
if [ -f /etc/redhat-release ]; then
  yum update -y
  cyber && centos
elif [ -f /etc/lsb-release ]; then
  apt update -y && apt upgrade -y
  cyber && ubuntu
fi
rm -rf install* cyber*
