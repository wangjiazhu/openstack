#!/bin/sh
[ -f /etc/init.d/functions ] && . /etc/init.d/functions
[ -f /root/admin-rc ] && . /root/admin-rc

openstack user create --domain default --password 123456 nova &&\
openstack user create --domain default --password 123456 placement &&\
openstack role add --project service --user nova admin &&\
openstack role add --project service --user placement admin &&\
openstack service create --name nova --description "OpenStack Compute" compute &&\
openstack service create --name placement --description "Placement API" placement
if [ $? -ne 0 ];then
    action "nova 用户、角色、服务实体" /bin/false
	exit 1
else
    action "nova 用户、角色、服务实体" /bin/true
fi

openstack endpoint create --region RegionOne compute public http://controller:8774/v2.1 &&\
openstack endpoint create --region RegionOne compute internal http://controller:8774/v2.1 &&\
openstack endpoint create --region RegionOne compute admin http://controller:8774/v2.1 &&\
openstack endpoint create --region RegionOne placement public http://controller:8778 &&\
openstack endpoint create --region RegionOne placement internal http://controller:8778 &&\
openstack endpoint create --region RegionOne placement admin http://controller:8778
if [ $? -ne 0 ];then
    action "nova api" /bin/false
	exit 1
else
    action "nova api" /bin/true
fi
exit 0