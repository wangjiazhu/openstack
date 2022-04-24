#!/bin/sh
# 创建数据库
echo "CREATE DATABASE keystone;"|mysql -u root -p123456
echo "GRANT ALL PRIVILEGES ON keystone.* TO 'keystone'@'localhost' IDENTIFIED BY '123456';"|mysql -u root -p123456
echo "GRANT ALL PRIVILEGES ON keystone.* TO 'keystone'@'%' IDENTIFIED BY '123456';"|mysql -u root -p123456

echo "CREATE DATABASE glance;"|mysql -u root -p123456
echo "GRANT ALL PRIVILEGES ON glance.* TO 'glance'@'localhost' IDENTIFIED BY '123456';"|mysql -u root -p123456
echo "GRANT ALL PRIVILEGES ON glance.* TO 'glance'@'%' IDENTIFIED BY '123456';"|mysql -u root -p123456

echo "CREATE DATABASE nova_api;"|mysql -u root -p123456
echo "GRANT ALL PRIVILEGES ON nova_api.* TO 'nova'@'localhost' IDENTIFIED BY '123456';"|mysql -u root -p123456
echo "GRANT ALL PRIVILEGES ON nova_api.* TO 'nova'@'%' IDENTIFIED BY '123456';"|mysql -u root -p123456

echo "CREATE DATABASE nova;"|mysql -u root -p123456
echo "GRANT ALL PRIVILEGES ON nova.* TO 'nova'@'localhost' IDENTIFIED BY '123456';"|mysql -u root -p123456
echo "GRANT ALL PRIVILEGES ON nova.* TO 'nova'@'%' IDENTIFIED BY '123456';"|mysql -u root -p123456

echo "CREATE DATABASE nova_cell0;"|mysql -u root -p123456
echo "GRANT ALL PRIVILEGES ON nova_cell0.* TO 'nova'@'localhost' IDENTIFIED BY '123456';"|mysql -u root -p123456
echo "GRANT ALL PRIVILEGES ON nova_cell0.* TO 'nova'@'%' IDENTIFIED BY '123456';"|mysql -u root -p123456

echo "CREATE DATABASE neutron;"|mysql -u root -p123456
echo "GRANT ALL PRIVILEGES ON neutron.* TO 'neutron'@'localhost' IDENTIFIED BY '123456';"|mysql -u root -p123456
echo "GRANT ALL PRIVILEGES ON neutron.* TO 'neutron'@'%' IDENTIFIED BY '123456';"|mysql -u root -p123456

echo "CREATE DATABASE cinder;"|mysql -u root -p123456
echo "GRANT ALL PRIVILEGES ON cinder.* TO 'cinder'@'localhost' IDENTIFIED BY '123456';"|mysql -u root -p123456
echo "GRANT ALL PRIVILEGES ON cinder.* TO 'cinder'@'%' IDENTIFIED BY '123456';"|mysql -u root -p123456