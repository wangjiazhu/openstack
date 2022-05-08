#!/bin/bash
#Author:Wjz
#Email:1072002783@qq.com
#Blog:https://blog.csdn.net/weixin_51720652
#Time:2022-04-26 20:02:51
#Name:deployment.sh
#Description:deploy the openstack-ocata playook

[ -e /etc/init.d/functions ] && source /etc/init.d/functions

ANSIBLE_DIR="/etc/ansible"
DISTRO_DIR="/openstack_distro"
DISTRO_TARFILE="openstack.tar.gz"


# check user
id |grep -w "uid=0" &>/dev/null
if [ $? -ne 0 ];then
    echo -e "\E[1;31mERROR: This script requires root to run. \E[0m"
    exit 1
fi

# check directory
pwd|grep "openstack_distro" &>/dev/null
if [ $? -ne 0 ];then
    echo -e "\E[1;31mERROR: This script needs to run under its directory. \E[0m"    
    exit 1
fi

echo -e "\E[1;32mdeploying the openstack-ocata playbook... \E[0m"
# deploy the palybook to ansible
cp -ra $DISTRO_DIR/hosts $ANSIBLE_DIR/hosts &&\
tar xzf $DISTRO_DIR/$DISTRO_TARFILE -C $ANSIBLE_DIR
if [ $? -ne 0 ];then
    action "deploy the openstack-ocata playbook" /bin/false
	exit 1
else
	action "deploy the openstack-ocata playbook" /bin/true
fi


# config the controller /etc/hosts,/etc/ansible/hosts
cd ./scripts &&\
/usr/bin/python3 config_hosts.py &>/dev/null
if [ $? -ne 0 ];then
	action "config host list" /bin/false
	exit 1
else
	action "config host list" /bin/true
fi
cd - &>/dev/null

# config ntpdate network
#manage_ip=$(grep "hostname=controller" $ANSIBLE_DIR/hosts |awk '{print $1}')
manage_ip=$(grep -w "controller" /etc/hosts|awk '{print $1}')
ip_mask=$(ip addr|grep "$manage_ip" |awk '{print $2}')
ntp_network=$(/usr/bin/python3 ./scripts/ntp_network.py $ip_mask)
#sed -i '2d' /etc/ansible/roles/prepare/vars/main.yaml
echo "network: $ntp_network" >$ANSIBLE_DIR/openstack/roles/prepare/vars/main.yaml

# distribute the key to every hosts
ssh-keygen -f ~/.ssh/id_rsa -P '' -q
if [ $? -eq 0 ];then
    action "key-pair create success!" /bin/true
else
    action "key-pair keep old!" /bin/true
fi

cd ./scripts && /usr/bin/python3 manageip_rootpasswd.py| while read -r line
do
	ip=$(echo $line |awk '{print $1}')
	password=$(echo $line |awk '{print $2}')
	sshpass -p$password ssh-copy-id -f -i ~/.ssh/id_rsa.pub "-o StrictHostKeyChecking=no" root@$ip &>/dev/null
    if [ $? -eq 0 ];then
        action "copy id_rsa.pub to $ip success!" /bin/true
    else
        action "copy id_rsa.pub to $ip failed!" /bin/false
        continue
    fi
done
cd - &>/dev/null
sleep 2

# config hostname
cat /etc/hosts|awk 'NR>2' | while read -r line4
do	
	hostip=$(echo $line4|awk '{print $1}')
    hostname=$(echo $line4|awk '{print $2}')
	cmd="hostnamectl set-hostname $hostname"
	# echo "$cmd"
	ansible $hostip -m command -a "$cmd" &>/dev/null
	if [ $? -ne 0 ];then
		action "host $hostip sethostname to $hostname" /bin/false
		continue
	else
		action "host $hostip sethostname to $hostname" /bin/true
	fi
done

sleep 2
# config /etc/hosts
cat /etc/hosts|awk 'NR>2' | while read -r line6
do	
	hostip=$(echo $line6|awk '{print $1}')
    hostname=$(echo $line6|awk '{print $2}')
	# get the local host hostname
	local_hostname=$(hostname)
	if [ $hostname != $local_hostname ];then
		ansible $hostip -m copy -a "src=/etc/hosts dest=/etc/" &>/dev/null
		if [ $? -eq 0 ];then
			action "host $hostip /etc/hosts" /bin/true
		else
			action "host $hostip /etc/hosts" /bin/false
		fi
	fi
done

sleep 2
# config repo
cat /etc/hosts|awk 'NR>2 {print $1}' | while read -r line2
do	
    ansible $line2 -m shell -a "rm -rf /etc/yum.repos.d/*" &>/dev/null
	if [ $? -ne 0 ];then
		action "host $line2 clean old yum repo" /bin/false
		continue
	else
		action "host $line2 clean old yum repo" /bin/true
	fi
done

cat /etc/hosts|awk 'NR>2 {print $1}' | while read -r line3
do	
	ansible $line3 -m shell -a "curl -o /etc/yum.repos.d/CentOS-Base.repo https://mirrors.aliyun.com/repo/Centos-7.repo" &>/dev/null &&\
	ansible $line3 -m copy -a "src=./ocata.repo dest=/etc/yum.repos.d/ocata.repo" &>/dev/null &&\
	ansible $line3 -m shell -a "yum clean all && yum makecache" &>/dev/null
	if [ $? -ne 0 ];then
		action "host $line3 CentOS7 and openstack repo" /bin/false
		continue
	else
		action "host $line3 CentOS7 and openstack repo" /bin/true
	fi
done

# The host optimization
# firewalld 、selinux、some softrware ...SSH
cat /etc/hosts|awk 'NR>2 {print $1}' | while read -r line4
do	
    ansible $line4 -m script -a "scripts/youhua.sh" &>/dev/null
	if [ $? -ne 0 ];then
		action "host $line4 optimization" /bin/false
		continue
	else
		action "host $line4 optimization" /bin/true
	fi
done

echo -e "\E[1;32mplease execute 'ansible-playbook -C /etc/ansible/openstack/roles/site.yaml' to check playbook \E[0m"
echo -e "\E[1;32mplease execute 'ansible-playbook -v /etc/ansible/openstack/roles/site.yaml' to deploy openstack \E[0m"
