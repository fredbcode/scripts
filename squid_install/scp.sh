#!/bin/bash

IP=$1
set -vx

# A commenter si 1 er install
rm errors/fr/ERR_ACCESS_DENIED
rm errors/fr/ERR_CACHE_ACCESS_DENIED

for file in errors/fr/*
do
  echo "Traitement de $file ..."
  sed -i -e "s/Générée le %T en %h (%s)/Générée le %t par %h (%s)/g" "$file"
done

grep LimitNOFILE=65535 tools/systemd/squid.service
if [ $? = 1 ]
then
        sed -i "/Type=simple/i\LimitNOFILE=65535" tools/systemd/squid.service
fi

ssh -i /root/.ssh/myroot.key root@$IP "/etc/init.d/squid stop"
ssh -i /root/.ssh/myroot.key root@$IP "mkdir -p /usr/lib/squid/errors/French"
ssh -i /root/.ssh/myroot.key root@$IP "mkdir -p /usr/lib/squid/icons"
ssh -i /root/.ssh/myroot.key root@$IP "mkdir /etc/squid/"
ssh -i /root/.ssh/myroot.key root@$IP "mkdir -p /var/spool/squid"
scp -r -i /root/.ssh/myroot.key src/mime.conf.default root@$IP:/etc/squid/mime.conf
scp -r -i /root/.ssh/myroot.key errors/fr/* root@$IP:/usr/lib/squid/errors/French/
scp -i /root/.ssh/myroot.key src/DiskIO/DiskDaemon/diskd root@$IP:/usr/lib/squid/
scp -i /root/.ssh/myroot.key src/unlinkd root@$IP:/usr/lib/squid/
scp -i /root/.ssh/myroot.key src/squid root@$IP:/usr/sbin/
scp -r -i /root/.ssh/myroot.key icons/silk root@$IP:/usr/lib/squid/icons/
scp -r -i /root/.ssh/myroot.key icons/*.png root@$IP:/usr/lib/squid/icons/
scp -i /root/.ssh/myroot.key tools/squidclient/squidclient root@$IP:/usr/sbin/
scp -i /root/.ssh/myroot.key helpers/basic_auth/LDAP/basic_ldap_auth root@$IP:/usr/lib/squid/
scp -i /root/.ssh/myroot.key helpers/basic_auth/LDAP/squid_ldap_auth root@$IP:/usr/lib/squid/
scp -i /root/.ssh/myroot.key helpers/digest_auth/LDAP/digest_ldap_auth root@$IP:/usr/lib/squid/
scp -i /root/.ssh/myroot.key helpers/log_daemon/file/log_file_daemon root@$IP:/usr/lib/squid/
scp -i /root/.ssh/myroot.key tools/systemd/squid.service root@$IP:/etc/systemd/system/
ssh -i /root/.ssh/myroot.key root@$IP "chown -Rf squid /etc/squid"
ssh -i /root/.ssh/myroot.key root@$IP "chown -Rf squid /usr/lib/squid"
ssh -i /root/.ssh/myroot.key root@$IP "chown -Rf squid /var/spool/squid" &
sleep 5
ssh -i /root/.ssh/myroot.key root@$IP "systemctl enable squid"
ssh -i /root/.ssh/myroot.key root@$IP "service squid start"

