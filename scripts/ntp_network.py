#!/usr/bin/python3

import sys

# 获取NTP时间同步网络段
class ntp_network:
    def __init__(self, ip_mask):
        self.ip_mask = ip_mask
    
    def parse_ip(self, ip_num):
        ip = str(ip_num // 2 ** 24) + '.'
        ip_num = ip_num % 2 ** 24
        ip = ip + str(ip_num // 2 ** 16) + '.'
        ip_num = ip_num % 2 ** 16
        ip = ip + str(ip_num // 2 ** 8) + '.'
        ip_num = ip_num % 2 ** 8
        ip = ip + str(ip_num)
        return ip
    
    def get_ntpNetworkMask(self):
        ip = self.ip_mask.split('/')[0]
        netmask_bit = int(self.ip_mask.split('/')[1])
        
        ips_t = ip.split('.')
        ip1 = int(ips_t[0])
        ip2 = int(ips_t[1])
        ip3 = int(ips_t[2])
        ip4 = int(ips_t[3])
        
        netmask_num = 2 ** 32 - 2 ** (32 - netmask_bit)   # 掩码十进制表示（网络号全1，主机号全0）
        ip_num = ip1 * 2 ** 24 + ip2 * 2 ** 16 + ip3 * 2 ** 8 + ip4  # ip地址十进制表示
        network_num = ip_num & netmask_num   # 网络号十进制表示
        network_ip = self.parse_ip(network_num)
        return f"{network_ip}/{netmask_bit}"

# 获取ip_mask值
ip_mask = sys.argv[1]
ntpnetwork = ntp_network(ip_mask).get_ntpNetworkMask()
print(ntpnetwork)
