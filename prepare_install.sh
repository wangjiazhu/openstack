#!/bin/bash
#Author:Wjz
#Email:1072002783@qq.com
#Blog:https://blog.csdn.net/weixin_51720652
#Time:2022-04-26 20:02:51
#Name:prepare_install.sh
#Description:openstack-ocata deployment prepare

[ -e /etc/init.d/functions ] && source /etc/init.d/functions

# define var
DISTRO_DIR="/openstack_distro"
DISTRO_TARFILE="openstack.tar.gz"

YUMREPO_DIR="/etc/yum.repos.d"
YUMREPOBAK_DIR="/opt/yum.repos.d.bak"

# check user
id |grep -w "uid=0" &>/dev/null
if [ $? -ne 0 ];then
    echo -e "\E[1;31mERROR: This script requires root to run. \E[0m"
    exit 1
fi

# check directory
pwd|grep openstack &>/dev/null
if [ $? -ne 0 ];then
    echo -e "\E[1;31mERROR: This script needs to run under its directory. \E[0m"    
    exit 1
fi

echo -e "\E[1;32mprepare ansible-playbook... \E[0m"
# config the yum
[ -e $YUMREPOBAK_DIR ] || mkdir -p $YUMREPOBAK_DIR
mv $YUMREPO_DIR/*.repo $YUMREPOBAK_DIR &&>/dev/null
curl -o $YUMREPO_DIR/CentOS-Base.repo https://mirrors.aliyun.com/repo/Centos-7.repo &>/dev/null &&\
curl -o $YUMREPO_DIR/epel.repo http://mirrors.aliyun.com/repo/epel-7.repo  &>/dev/null
if [ $? -ne 0 ];then
	action "config yum repo" /bin/false
	exit 1
else
	action "config yum repo" /bin/true
fi

# install ansible
yum install ansible-2.9.27 -y &>/dev/null
if [ $? -ne 0 ];then
	action "install ansible" /bin/false
	exit 1
else
	action "install ansible" /bin/true
fi

# create the tar package
[ -e $DISTRO_DIR ] || mkdir -p $DISTRO_DIR
cp -ap ./hosts $DISTRO_DIR/hosts
cp -ap ./scripts $DISTRO_DIR/
mv $DISTRO_DIR/scripts/deployment.sh $DISTRO_DIR
cp ./openstack主机清单列表.xlsx $DISTRO_DIR
cp ./ocata.repo $DISTRO_DIR
mkdir -p ./openstack
cp -ra ./roles ./openstack
tar czf $DISTRO_DIR/$DISTRO_TARFILE ./openstack &>/dev/null
if [ $? -ne 0 ];then
	action "create the openstack playbook package" /bin/false
	exit 1
else
	action "create the openstack playbook package" /bin/true
fi
rm -rf ./openstack


# install python3 python3-pip openpyxl
yum install python3 python3-pip -y &>/dev/null &&\
pip3 install openpyxl -i https://pypi.tuna.tsinghua.edu.cn/simple &>/dev/null
if [ $? -ne 0 ];then
	action "install python3 openpyxl" /bin/false
	exit 1
else
	action "install python3 openpyxl" /bin/true
fi

# install expect tool
yum install expect -y &>/dev/null
if [ $? -ne 0 ];then
	action "install expect" /bin/false
	exit 1
else
	action "install expect" /bin/true
fi

# remove epel
[ -e $YUMREPO_DIR/epel.repo ] && rm -rf $YUMREPO_DIR/epel.repo

# remove the directory .git
[ -e ./.git ] && rm -rf ./.git
