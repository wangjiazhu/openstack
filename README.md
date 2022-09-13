# ansible-playbook剧本自动化部署openstack-ocata

#### openstack节点安排

说明：以下给出示范

| 节点类型/主机名 |     管理IP      |   外网IP   |                    服务                    |      系统       | 备注 |
| :-------------: | :-------------: | :--------: | :----------------------------------------: | :-------------: | :--: |
|   controller    | 202.207.240.110 | 10.0.0.110 | keystone、glance、nova、neutron、dashborad | CentOS 7.5.1804 |      |
|   comoute1    | 202.207.240.111 | 10.0.0.111 |               nova、neutron                | CentOS 7.5.1804 |      |
|   compute2    | 202.207.240.112 | 10.0.0.112 |               nova、neutron                | CentOS 7.5.1804 |      |

#### 用户完成部分

##### 网络设置

​	用户按照自己的部署方案，在装好CentOS7.5.1804系统的主机上，配置好管理IP和外网IP。

##### openstack主机清单列表

​	说明：用户从提供的网络地址下载“**openstack主机清单列表**”，按照用户自己的部署方案（假设以上openstack节点安排就是用户部署方案），将主机信息填写到“**OpenStack主机清单**”中，其填写说明见表格“**主机清单列表配置说明**”。

###### 下载 

说明：可以使用迅雷或者直接在浏览器中下载。

下载地址：https://raw.githubusercontent.com/wangjiazhu/openstack/master/openstack主机清单列表.xlsx

###### 用户提交表格

用户按照自己的方案准备好CentOS主机，配置好网络，并填写完该表格，提交给运维部署人员。

注意：接下来OpenStack所有的部署均以读该表格内容为前提进行自动化部署，需认真填写。

#### 部署人员部分

##### 准备部分

1. 将存放剧本文件的目录openstack放在控制节点的任意目录下。（这里以根目录为例）

   ![image-20220429215025525](https://raw.githubusercontent.com/wjzcscloud/MarkTextImg/master/image-20220429215025525.png)

2. 将用户提交的“openstack主机清单列表”放在openstack目录中。

![image-20220429215204913](https://raw.githubusercontent.com/wjzcscloud/MarkTextImg/master/image-20220429215204913.png)

##### 部署过程

1. 进入到openstack剧本目录，执行脚本prepare_install.sh

```bash
sh prepare_install.sh
```

![image-20220429220110252](https://raw.githubusercontent.com/wjzcscloud/MarkTextImg/master/image-20220429220110252.png)

执行完毕后，根目录多出一个安装目录 /openstack_distro

![image-20220429220447641](https://raw.githubusercontent.com/wjzcscloud/MarkTextImg/master/image-20220429220447641.png)


2. 进入到 /openstack_distro 目录，执行脚本 deployment.sh

```bash
cd /openstack_distro
sh deployment.sh
```

![image-20220429221346796](https://raw.githubusercontent.com/wjzcscloud/MarkTextImg/master/image-20220429221346796.png)

3. 按照以上脚本执行完毕后给的提示，进行验证剧本语法以及部署openstack

```bash
# 检查剧本语法
ansible-playbook -C /etc/ansible/openstack/roles/site.yaml

# 运行剧本，部署openstack
ansible-playbook -v /etc/ansible/openstack/roles/site.yaml
```

![](https://raw.githubusercontent.com/wjzcscloud/MarkTextImg/master/image-20220424214247918.png)

![](https://raw.githubusercontent.com/wjzcscloud/MarkTextImg/master/image-20220424214329097.png)
