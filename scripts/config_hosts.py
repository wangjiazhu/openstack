#!/usr/bin/python3
# encoding:utf-8
# @Author   :wjz
# @FileName :config_hosts.py
# @function : config the hosts

import os
import time
import utils

ht = utils.handel_table('../openstack主机清单列表.xlsx', 'OpenStack主机清单', ['A', 'B', 'C', 'D', 'E'])
table = ht.format_table()

hostname = ht.get_attr_index(table, '节点类别/主机名')
manage_ip = ht.get_attr_index(table, '管理IP')
provider_ip = ht.get_attr_index(table, '外网IP')
storage_ip = ht.get_attr_index(table, '存储网络IP')
root_password = ht.get_attr_index(table, 'root密码')

# print(hostname, manage_ip, provider_ip, storage_ip, root_password)

# 配置 /etc/hosts
def config_etc_hosts(table):
    # copy the /etc/hosts file
    os.popen("cp /etc/hosts{,.bak}")
    time.sleep(2)
    os.popen("> /etc/hosts")
    os.popen("head -2 /etc/hosts.bak >/etc/hosts")
    time.sleep(2)
    for i in range(1, len(table)):
        os.popen(f"echo {table[i][manage_ip]} {table[i][hostname]} >>/etc/hosts")
        print(table[i][manage_ip], table[i][hostname])

# 配置 /etc/ansible/hosts
def config_ansible_hosts(table):
    os.popen("> /etc/ansible/hosts")
    time.sleep(1)
    os.popen("echo '[controller]' >>/etc/ansible/hosts")
    os.popen("echo '[compute]' >>/etc/ansible/hosts")
    os.popen("echo '[cinder]' >>/etc/ansible/hosts")
    for i in range(1, len(table)):
        # get the provider ifname
        cmd = "/bin/sh remote_cmd.sh %s %s %s" % (table[i][manage_ip],table[i][root_password],"\"ip addr|grep %s\"" % table[i][provider_ip])
        str_msg = os.popen(cmd).readlines()
        #print(cmd)
        ip_ifname = str_msg[len(str_msg)-1].strip().split()
        #print(ip_ifname)
        host_msg = f"{table[i][manage_ip]} ifname={ip_ifname[len(ip_ifname)-1]} manage_ip={table[i][manage_ip]} provider_ip={table[i][provider_ip]} hostname={table[i][hostname]}"
        #print(host_msg)
        if table[i][hostname] == "controller":
            os.popen(f"sed -i \'1a {host_msg}\' /etc/ansible/hosts")
        if "compute" in table[i][hostname]:
            cmd = "grep -n compute /etc/ansible/hosts |awk -F\":\" '{print $1}'"
            lines = os.popen(cmd).readlines()
            index = lines[len(lines)-1].strip()
            # print(index)
            os.popen(f"sed -i \'{index}a {host_msg}\' /etc/ansible/hosts")
        if "cinder" in table[i][hostname]:
            cmd = "grep -n cinder /etc/ansible/hosts |awk -F\":\" '{print $1}'"
            lines = os.popen(cmd).readlines()
            index = lines[len(lines)-1].strip()
            os.popen(f"sed -i \'{index}a {host_msg}\' /etc/ansible/hosts")

if __name__ == '__main__':
    config_etc_hosts(table)
    config_ansible_hosts(table)
