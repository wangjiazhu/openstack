#!/bin/sh
[ -f /etc/init.d/functions ] && . /etc/init.d/functions
[ -f /root/admin-rc ] && . /root/admin-rc

openstack project create --domain default --description "Service Project" service &&\
openstack project create --domain default --description "Demo Project" demo &&\
openstack user create --domain default --password 123456 demo &&\
openstack role create user &&\
openstack role add --project demo --user demo user
if [ $? -ne 0 ];then
    action "创建项目、用户、角色任务" /bin/false
	exit 1
else
    action "创建项目、用户、角色任务" /bin/true	
fi
exit 0