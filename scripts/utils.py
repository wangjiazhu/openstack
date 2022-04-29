#!/usr/bin/python3
import openpyxl

# 格式化表格内容
class handel_table:
    # 构造函数
    def __init__(self, file_path, sheetname, columns):
        self.path = file_path
        self.sheetname = sheetname
        self.columns = columns
        self.wb = openpyxl.load_workbook(self.path)
    
    # 初始化表格，获取表格为sheetname中column列的数据
    def get_cell(self, column):
        table = self.wb[self.sheetname]
        cell = table[column]
        tmp = []
        for ce in cell:
            tmp.append(ce.value)
        return tmp
    
    # 格式化表格，形成以行单元的表格数据
    def format_table(self):
        # 获取以列为单元的所有表格内容
        col_table_list = []
        for column in self.columns:
            col_table_list.append(self.get_cell(column))
        # print(col_table_list)
        
        # 将以上表格内容格式化为以行为单位
        row_table_list = []
        for j in range(0, len(col_table_list[0])):
            tmp = []
            for i in range(0, len(col_table_list)):
                tmp.append(col_table_list[i][j])
            row_table_list.append(tmp)   
        # print(row_table_list)
        return row_table_list
    
    # 格式化列表后，获取表属性的索引位置【如属性“外网IP”的索引是2】
    def get_attr_index(self, table, attr):
        # 定义一个字典，其中key表示属性名，value表示索引
        attrs_dict = {}
        for index,value in enumerate(table[0]):
            attrs_dict[value]=index
        return attrs_dict[attr]
    
    def get_attrs_value(self, table, attrs):
        index_list = []
        for attr in attrs:
            index_list.append(self.get_attr_index(table, attr))
        # print(index_list)
        
        attr_value = []
        for i in range(1, len(table)):
            tmp = []
            for index in index_list:
                tmp.append(table[i][index])
            # print(tmp)
            attr_value.append(tmp)
        return attr_value

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


if __name__ == '__main__':
    ht = handel_table('../openstack主机清单列表.xlsx', 'OpenStack主机清单', ['A', 'B', 'C', 'D', 'E'])
    list_A = ht.get_cell('A')
    print(list_A)
    index1 = ht.get_attr_index(ht.format_table(), 'root密码')
    index2 = ht.get_attr_index(ht.format_table(), '管理IP')
    print(index1, index2)
    index_list = ht.get_attrs_value(ht.format_table(), ['管理IP', 'root密码'])
    index_list = ht.get_attrs_value(ht.format_table(), ['外网IP', 'root密码'])
        
    ntpnetwork = ntp_network("202.207.240.110/24").get_ntpNetworkMask()
    print(ntpnetwork)
    
    