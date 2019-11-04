#!/bin/bash
#Check OS
if	grep -Eqi "release 6" /etc/redhat-release ; then
	echo "Preparing to update to CentOS 7"
else
	echo "OS Running: `cat /etc/redhat-release`: No need to update"
	exit
fi
#New Centos Repository
cat > /etc/yum.repos.d/centos-upgrade.repo <<EOF
[centos-upgrade]
name=centos-upgrade
baseurl=https://buildlogs.centos.org/centos/6/upg/x86_64/
enabled=1
gpgcheck=0
EOF
#Install Pre-Upgrade Tool
yum -y install https://buildlogs.centos.org/centos/6/upg/x86_64/Packages/openscap-1.0.8-1.0.1.el6.centos.x86_64.rpm
yum -y install redhat-upgrade-tool preupgrade-assistant-*
#Import CentOS7 PGP Key
rpm --import http://mirror.centos.org/centos/7/os/x86_64/RPM-GPG-KEY-CentOS-7
#Add Mirrorlist to Upgrade
mkdir -pv /var/tmp/system-upgrade/base/ /var/tmp/system-upgrade/extras/ /var/tmp/system-upgrade/updates/
echo http://mirror.centos.org/centos/7/os/x86_64/ >> /var/tmp/system-upgrade/base/mirrorlist.txt
echo http://mirror.centos.org/centos/7/extras/x86_64/ >> /var/tmp/system-upgrade/extras/mirrorlist.txt
echo http://mirror.centos.org/centos/7/updates/x86_64/ >> /var/tmp/system-upgrade/updates/mirrorlist.txt
#Pre-Upgrade
yes | preupg -v
#Run CentOS Upgrade
centos-upgrade-tool-cli --network=7 --instrepo=http://vault.centos.org/7.0.1406/os/x86_64/ << EOF
Y
EOF
#Delete data update
rm -rf preupgrade* upgrade.sh
reboot
