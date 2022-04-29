#!/bin/bash
#Author:Wjz
#Blog:https://blog.csdn.net/weixin_51720652
#Time:2022-03-11 12:44:52
#Description:Execute remote command exp script to execute command on remote host.
if [ $# -ne 3 ];then
    echo "USAGE: $0 hosts password cmd"
    exit 1
fi

hosts=$1
password=$2
cmd=$3

for host in $hosts
do
    expect remote_cmd.exp $host $password "$cmd"
done
