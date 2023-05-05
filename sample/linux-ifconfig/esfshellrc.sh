# 注意：在使用本初始化文件前请先前去README.md了解初始化文件的运行机制
# 测试环境：Arch Linux，日期：2023/04/25

# 获取第一活跃端口
# Return: Ether name
getActivateEther() {
    echo $(ifconfig | grep "UP" | awk '{print $1}' | cut -d: -f1 | head -1)
}

# 获取MAC地址
# Params: <IP>
# Return: MAC
getMAC() {
    echo $(ifconfig | grep -3 $1 | awk '/ether/ { print $2 }' | head -1)
}

# 获取本地IP地址
# Params: <Ether>
# Return: Ether's IP
getLocalIP() {
    echo $(ifconfig $1 | grep -E "inet (addr)?" | awk '{print $2}' | tr -d "addr:" | head -1)
}
