#!/bin/sh
#1.create the related directories
mkdir -p /server/scripts
mkdir -p /server/tools
mkdir -p /application

#2.configure the domian name resolution
#cp /etc/hosts{,.bak}
#while read line
#do
#    echo $line >>/etc/hosts
#done <openstack_domain_name.txt

#3.security optimization
systemctl stop firewalld
systemctl disable firewalld
systemctl status firewalld
sleep 2
setenforce 0
getenforce
sleep 2
sed -i 's#SELINUX=enforcing#SELINUX=disabled#g' /etc/selinux/config
cat /etc/selinux/config |grep "SELINUX"
sleep 2

#4.modify the hostname
# hostnamectl set-hostname xxx

#5.modify the yum.repo
#mkdir -p /etc/yum.repos.d/bak
#find /etc/yum.repos.d/ -type f -exec mv {} /etc/yum.repos.d/bak/ \;
#curl -o /etc/yum.repos.d/CentOS-Base.repo https://mirrors.aliyun.com/repo/Centos-7.repo
#curl -o /etc/yum.repos.d/epel.repo http://mirrors.aliyun.com/repo/epel-7.repo

#6.Streamlined startup service

#7.add user and increase the right about the user
#useradd wjz
#echo '123456' |passwd --stdin wjz
#echo 'wjz ALL=(ALL) NOPASSWD: ALL' >>/etc/sudoers
#visudo -c

#8.set character set
#sed -i 's/LANG="en_US.UTF-8"/LANG="zh_CN.UTF-8"/g' /etc/locale.conf

#9.rsync time
#yum install ntpdate -y
#echo '#crond-001: rsync time' >>/var/spool/cron/root
#echo '*/5 * * * * /usr/sbin/ntpdate ntp3.aliyun.com >/dev/null 2>&1' >>/var/spool/cron/root
#crontab -l

#10.Improve the security of command line operations
#echo 'export TMOUT=300' >>/etc/profile
#echo 'export HISTSIZE=5' >>/etc/profile
#echo 'exprot HISTFILESIZE=5' >>/etc/profile
#tail -3 /etc/profile
#source /etc/profile

#11.Enlarge the file descriptor

#12.Optimize the kernel

#13.Installing basic Software
yum install tree nmap dos2unix lrzsz nc lsof wget tcpdump htop iftop iotop sysstat nethogs -y
yum install psmisc net-tools bash-completion vim-enhanced -y

#14.Optimized the SSH remote connection
# Port 
# PermitRootLogin
# ListenAddress
sed -i 's/#PermitEmptyPasswords no/PermitEmptyPasswords no/g' /etc/ssh/sshd_config
sed -i 's#GSSAPIAuthentication yes#GSSAPIAuthentication no#g' /etc/ssh/sshd_config
sed -i 's/#UseDNS yes/UseDNS no/g' /etc/ssh/sshd_config
cat /etc/ssh/sshd_config |grep UseDNS
cat /etc/ssh/sshd_config |grep GSSAPIAuthentication
