#!/bin/bash
# 使用Windows命令行网络工具获取活跃端口、IP地址和MAC地址
# 注意：在使用本初始化文件前请先前去README.md了解初始化文件的运行机制
# 测试环境：Windows 10 Version 22H2 (19045.2908)，日期：2023/04/25

# 获取第一活跃端口
# Return: Ether name
getActivateEther() {
    local etherName
    etherName=$(netsh interface show interface | iconv -f gbk -t utf-8 | grep -i '已连接' | awk '{ for (i=4; i<=NF; ++i) printf $i""FS; print ""}' | head -1)
    echo "${etherName%?}"
}

# 获取MAC地址
# Params: <IP>
# Return: MAC
getMAC() {
    wmic nicconfig where IPEnabled=True get ipaddress,macaddress | iconv -f gbk -t utf-8 | grep "$1" | awk '{print $NF}'
}

# 获取本地IP地址
# Params: <Ether>
# Return: Ether's IP
getLocalIP() {
    netsh interface ipv4 show ipaddresses "$1" | iconv -f gbk -t utf-8 | grep -E "地址.*参数" | awk '{print $2}'
}
