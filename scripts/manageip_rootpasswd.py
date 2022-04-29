#!/usr/bin/python3

import utils

ht = utils.handel_table('../openstack主机清单列表.xlsx', 'OpenStack主机清单', ['A', 'B', 'C', 'D', 'E'])
ip_passwd_list = ht.get_attrs_value(ht.format_table(), ['管理IP', 'root密码'])

for i in range(0, len(ip_passwd_list)):
    for j in range(0, len(ip_passwd_list[0])):
        print(ip_passwd_list[i][j], end=" ")
    print()
