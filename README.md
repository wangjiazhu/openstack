# 使用ansible-playbook自动化部署openstack

## openstack节点安排

说明：以下给出示范。

|    节点    |   外网IP   |     内网IP      | 网卡名 |                    服务                    |      系统       |
| :--------: | :--------: | :-------------: | :----: | :----------------------------------------: | :-------------: |
| controller | 10.0.0.110 | 202.207.240.110 | ens34  | keystone、glance、nova、neutron、dashborad | CentOS 7.5.1804 |
|  compute1  | 10.0.0.111 | 202.207.240.111 | ens34  |               nova、neutron                | CentOS 7.5.1804 |
|  compute2  | 10.0.0.112 | 202.207.240.112 | ens34  |               nova、neutron                | CentOS 7.5.1804 |

## 准备

1. 按节点部署安排配置内外网卡IP、修改主机名、配置/etc/hosts主机名解析。【controller、compute】
2. 配置openstack、CentOS7的yum源。【controller、compute】
   注意：不要配置epel源，会出现rpm冲突。

## 安装并配置ansible

【controller】或者单独的管理节点。

### 安装ansible

**注意：**

1. 如果安装不上，临时配置epel源，完成ansible后立即删除epel源，避免rpm冲突。（ansible部署在controller节点）
2. 如果ansible安装在单独的一个管理节点，配置CentOS7 和 epel源，直接安装，不用处理epel源。（建议ansible单独部署）

```bash
yum install ansible -y
```

### 下载openstack剧本

1. 将整个openstack目录放在/etc/ansible/目录下。


```bash
cd /etc/ansible
git clone https://github.com/wangjiazhu/openstack.git
```
![image-20220424195248468](https://gitee.com/wjzhuf/mark-text-img/raw/master/imgbed/image-20220424195248468.png)

2. 运行脚本配置免密登录。并验证

```bash
/bin/sh /etc/ansible/openstack/secret-free-login.sh
```
![image-20220424195609671](https://gitee.com/wjzhuf/mark-text-img/raw/master/imgbed/image-20220424195609671.png)

3. 验证ssh免密登录


   ```bash
   ssh root@202.207.240.111
   ssh root@202.207.240.112
   ```

   ![image-20220424200001978](https://gitee.com/wjzhuf/mark-text-img/raw/master/imgbed/image-20220424200001978.png)

4. 将/etc/ansible/openstack/hosts2 拷贝并覆盖 /etc/ansible/hosts

```bash
rm -rf /etc/ansible/hosts
cp /etc/ansible/openstack/hosts2 /etc/ansible/hosts
```

![image-20220424200639213](https://gitee.com/wjzhuf/mark-text-img/raw/master/imgbed/image-20220424200639213.png)

5. 配置ansible主机列表清单/etc/ansible/hosts

```
[controller]
202.207.240.110 ansible_ssh_user=root ansible_ssh_pass='111111' ifname=ens34 ip_addr=202.207.240.110 hostname=controller

[compute]
202.207.240.111 ifname=ens34 ip_addr=202.207.240.111 hostname=compute1
202.207.240.112 ifname=ens34 ip_addr=202.207.240.112 hostname=compute2
```

各个字段含义：

```
[controller] 控制节点主机组名
202.207.240.110 			 控制节点主机IP，表示controller主机组下的IP
ansible_ssh_user=root  		  表示ssh用户，默认是root
ansible_ssh_pass='111111' 	  表示ssh用户远程连接的密码
ifname=ens34 				 表示内网的网卡，neutron配置文件需要的网卡名
ip_addr=202.207.240.110 	  一个变量，用于表示本机的IP地址
hostname=controller 		  一个变量，表示本地的主机名

[compute]   计算节点主机组名
202.207.240.111				 控制节点主机IP，表示compute主机组下的主机IP
ifname=ens34 				 表示内网的网卡，neutron配置文件需要的网卡名
ip_addr=202.207.240.111 	  一个变量，用于表示本机的IP地址
hostname=compute1 		      一个变量，表示本地的主机名

```

6. 验证ansible主机清单是否配置成功

```bash
ansible controller,compute -m command -a "uptime"
```

![image-20220424203639648](https://gitee.com/wjzhuf/mark-text-img/raw/master/imgbed/image-20220424203639648.png)

注意：出现以下报错不要慌，这是因为ansible部署在controller上，因此需要通过ssh密码方式连接本身，需要指纹,可以在controller通过ssh命令连接自身生成密码指纹即可。**(这就是推荐专门单独部署管理节点，进行ansible部署的原因)**

![image-20220424203149239](https://gitee.com/wjzhuf/mark-text-img/raw/master/imgbed/image-20220424203149239.png)

![image-20220424203558870](https://gitee.com/wjzhuf/mark-text-img/raw/master/imgbed/image-20220424203558870.png)

### 修改ntp时间同步网络段

```bash
vim /etc/ansible/openstack/roles/prepare/vars/main.yaml
```

![image-20220424204014790](https://gitee.com/wjzhuf/mark-text-img/raw/master/imgbed/image-20220424204014790.png)

### 检查剧本语法以并完成openstack部署

1. 预执行剧本，检查剧本语法

   ```bash
   ansible-playbook -C /etc/ansible/openstack/roles/site.yaml
   ```

   ![image-20220424214247918](https://gitee.com/wjzhuf/mark-text-img/raw/master/imgbed/image-20220424214247918.png)

2. 语法通过，执行剧本真正部署openstack

   ```bash
   ansible-playbook -v /etc/ansible/openstack/roles/site.yaml
   ```

   ![image-20220424214329097](https://gitee.com/wjzhuf/mark-text-img/raw/master/imgbed/image-20220424214329097.png)





附：

视频教程：https://www.bilibili.com/video/BV1NF411g7TP?t=443.5

