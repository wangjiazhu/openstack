#!/bin/sh
source /etc/init.d/functions 

# install the sshpass
yum install -y sshpass
if [ $? -eq 0 ];then
    action "sshpass install success!" /bin/true
else
    action "sshpass install failed!" /bin/false
    exit 1
fi

# create the key-pair
ssh-keygen -f ~/.ssh/id_rsa -P '' -q
if [ $? -eq 0 ];then
    action "key-pair create success!" /bin/true
else
    action "key-pair create failed!" /bin/false
    exit 2
fi

# input the remote hosts ip
read -p "Please input the romote host ip_address: " IP_LIST

# distribute public key files to hosts
for ip in $IP_LIST
do
    sshpass -p111111 ssh-copy-id -f -i ~/.ssh/id_rsa.pub "-o StrictHostKeyChecking=no" root@$ip
    if [ $? -eq 0 ];then
        action "copy id_rsa.pub to $ip success!" /bin/true
    else
        action "copy id_rsa.pub to $ip failed!" /bin/false
        continue
    fi
done
exit 0
