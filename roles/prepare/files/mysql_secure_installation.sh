#!/bin/sh

# 1.安装expect软件
yum install expect -y &>/dev/null
if [ $? -ne 0 ];then
    echo "安装expect软件 失败！"
	exit 1
else
    echo "安装expect软件 成功！"
fi

/usr/bin/expect <<EOF
set timeout -1
spawn bash -c "mysql_secure_installation"
expect "*root (enter for none)*" {send "\r"}
expect "*Set root password?*" {send "y\r"}
expect "*New password:*" {send "123456\r"}
expect "*Re-enter new password*" {send "123456\r"}
expect "*Remove anonymous users?*" {send "y\r"}
expect "*Disallow root login remotely?*" {send "n\r"}
expect "*Remove test database and access to it*" {send "y\r"}
expect "*Reload privilege tables now?*" {send "y\r"}
expect eof
EOF