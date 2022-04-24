#!/bin/sh
[ -f /etc/init.d/functions ] && . /etc/init.d/functions
[ -f /root/admin-rc ] && . /root/admin-rc

openstack user create --domain default --password 123456 glance &&\
openstack role add --project service --user glance admin &&\
openstack service create --name glance  --description "OpenStack Image" image
if [ $? -ne 0 ];then
    action "glance 用户、角色、服务实体" /bin/false
	exit 1
else
    action "glance 用户、角色、服务实体" /bin/true
fi

openstack endpoint create --region RegionOne image public http://controller:9292 &&\
openstack endpoint create --region RegionOne image internal http://controller:9292 &&\
openstack endpoint create --region RegionOne image admin http://controller:9292
if [ $? -ne 0 ];then
    action "glance api" /bin/false
	exit 1
else
    action "glance api" /bin/true
fi
exit 0