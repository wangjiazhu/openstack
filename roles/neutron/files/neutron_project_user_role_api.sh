#!/bin/sh
[ -f /etc/init.d/functions ] && . /etc/init.d/functions
[ -f /root/admin-rc ] && . /root/admin-rc

openstack user create --domain default --password 123456 neutron &&\
openstack role add --project service --user neutron admin &&\
openstack service create --name neutron --description "OpenStack Networking" network
if [ $? -ne 0 ];then
    action "neutron 用户、角色、服务实体" /bin/false
	exit 1
else
    action "neutron 用户、角色、服务实体" /bin/true
fi

openstack endpoint create --region RegionOne network public http://controller:9696 &&\
openstack endpoint create --region RegionOne network internal http://controller:9696 &&\
openstack endpoint create --region RegionOne network admin http://controller:9696
if [ $? -ne 0 ];then
    action "neutron api" /bin/false
	exit 1
else
    action "neutron api" /bin/true
fi
exit 0