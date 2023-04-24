# 使用Windows IPConfig工具获取活跃端口、IP地址和MAC地址

# 获取第一活跃端口
# Return: Ether name
getActivateEther() {
    echo -n `ipconfig -all | iconv -f gbk -t utf-8 | grep -i '描述' | cut -d: -f2 | awk '{ print $1 }' | head -1`
}

# 获取MAC地址
# Params: <IP>
# Return: MAC
getMAC() {
    echo -n `ipconfig -all | iconv -f gbk -t utf-8 | grep -ioPz "(?s)物理地址.*?$1.*?\n" | head -1 | awk '{ gsub(/-/,":"); print $NF }' | head -1`
}

# 获取本地IP地址
# Params: <Ether>
# Return: Ether's IP
getLocalIP() {
    echo -n `ipconfig -all | iconv -f gbk -t utf-8 | grep -ioPz "(?s)$1.*?IPv4.*?\n" | tail -2 | awk '{ print $NF }' | cut -d"(" -f1 | head -1`
}
