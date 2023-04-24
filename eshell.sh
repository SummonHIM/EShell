#!/bin/bash
# EShell by SummonHIM. URL: https://github.com/SummonHIM/EShell
# Original author: @Otm-Z. Create on 2022/03/22. URL: https://github.com/Z446C/ESC-Z
#

# 变量定义
_ES_ACC_USERNAME=""
_ES_ACC_PASSWD=""
_ES_CONFIG_DEVICE=""
_ES_HOMEPATH="$HOME/.config/eshell"

_ES_DAEMON_SLEEPTIME=300

_ES_LOG_ENABLE=false
_ES_LOG_PATH="$_ES_HOMEPATH/eshell.log"
_ES_LOG_MAXSIZE=256

_ES_GLOBAL_TIMESTAMP=`date "+%Y-%m-%d %H:%M:%S"`
_ES_GLOBAL_ISWIFI="4060"
_ES_GLOBAL_SECRET="Eshore!@#"
_ES_GLOBAL_VERSION="214"
_ES_GLOBAL_USERAGENT="User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/86.0.4240.198 Safari/537.36"
_ES_GLOBAL_URL_QUERYSCHOOL="http://enet.10000.gd.cn:10001/client/queryschool"
_ES_GLOBAL_URL_AD="http://enet.10000.gd.cn:10001/advertisement.do"
_ES_GLOBAL_URL_VCHALLENGE="http://enet.10000.gd.cn:10001/client/vchallenge"
_ES_GLOBAL_URL_LOGIN="http://enet.10000.gd.cn:10001/client/login"
_ES_GLOBAL_URL_LOGOUT="http://enet.10000.gd.cn:10001/client/logout"

_ES_CONFIG_COOKIE=""
_ES_CONFIG_VERIFYCODE=""
_ES_CONFIG_MAC=""
_ES_CONFIG_CLIENTIP=""
_ES_CONFIG_NASIP=""
_ES_CONFIG_SCHOOLID=""

_ES_NC_URL="http://connect.rom.miui.com/generate_204"
_ES_REDIR_URL="enet.10000.gd.cn:10001"

_ES_EXIT_CODE=0

# 打印日志
# Params: <Log type> <Log message>
# Return: YYYY-MM-DD [Log type]: Log message
printl() {
    printf "$_ES_GLOBAL_TIMESTAMP [$1]: $2\n"
    if [ $_ES_LOG_ENABLE == true ]; then
        printf "$_ES_GLOBAL_TIMESTAMP [$1]: $2\n" >> $_ES_LOG_PATH
    fi
}

# 创建日志
createLog() {
    if [[ "$_ES_LOG_PATH" == "" ]]; then
        _ES_LOG_PATH="$_ES_HOMEPATH/eshell.log"
    fi
    if [ -f "$_ES_LOG_PATH" ]; then
        local size=`ls -l $_ES_LOG_PATH | awk '{ print $5 }'`
        local maxsize=$((_ES_LOG_MAXSIZE*1024))
        if [ $size -ge $maxsize ]; then
            printl Info "日志容量过大，正在删除旧的日志..."
            #只保留取后3000行内容
            tail -n 3000 $_ES_LOG_PATH > $_ES_LOG_PATH.tmp
            rm -f $_ES_LOG_PATH
            mv $_ES_LOG_PATH.tmp $_ES_LOG_PATH
        else
            if [[ $verbose == true ]]; then
                printl Info "日志容量 $((size/1024))MiB/$((maxsize/1024))MiB"
            fi
        fi
    fi
}

# Json数据解析
# Params: <Origin data> <Json key>
# Return: <Json value>
getJson() {
    echo $1 | awk -F $2 '{print $2}' | awk -F '"' '{print $3}'
}

# Post请求 (postReq url data cookie)
# Params: <Url> <Data> <Cookie>
# Return: <Post return string>
postReq() {
    local contentType="Content-Type: application/json"
    local accept="Accept: */*"
    echo `curl $1 -H "$_ES_GLOBAL_USERAGENT" -H "$contentType" -H "$accept" -d "$2" --cookie "$3" -s`
}

# 获取用户IP
# Params: <Url> <type>
# Return: Value
getIP() {
    # 2、从重定向网页中获取
    # "http://enet.10000.gd.cn:10001/?wlanuserip=100.2.49.240&wlanacip=119.146.175.80"
    # "http://enet.10000.gd.cn:10001/qs/main.jsp?wlanacip=119.146.175.80&wlanuserip=100.2.50.69"
    local tmp1=`echo -n $1 | cut -d '?' -f2 | cut -d '&' -f1`
    local tmp2=`echo -n $1 | cut -d '?' -f2 | cut -d '&' -f2`
        
    local tClientIp=`echo -n $tmp1 | grep "wlanuserip"`

    local tNasIp=`echo -n $tmp2 | grep "wlanacip"`

    if [[ "$2" == "clientip" ]]; then
        if [[ "$tClientIp" == "" ]]; then
            echo -n $tmp2 | cut -d '=' -f2 | tr -d '\r' | tr -d '\n'
        else
            echo -n $tmp1 | cut -d '=' -f2 | tr -d '\r' | tr -d '\n'
        fi
    fi

    if [[ "$2" == "nasip" ]]; then
        if [[ "$tNasIp" == "" ]]; then
            echo -n $tmp1 | cut -d '=' -f2 | tr -d '\r' | tr -d '\n'
        else
            echo -n $tmp2 | cut -d '=' -f2 | tr -d '\r' | tr -d '\n'
        fi
    fi
}

# 获取第一活跃端口
# Return: Ether name
getActivateEther() {
    echo `ip addr | grep "state UP" | awk '{print $2}' | cut -d: -f1`
}

# 获取MAC地址
# Params: <IP>
# Return: MAC
getMAC() {
    echo `ip addr |grep -3 $1 |awk '/ether/ { print $2 }'`
}

# 获取本地IP地址
# Params: <Ether>
# Return: Ether's IP
getLocalIP() {
    echo `ip addr show dev $1 |grep "inet " |awk '{print $2}'| cut -d/ -f1`
}

# 网站访问状态
# Params: <URL> <Output type>
# Return: CUrl output data
getUrlStatus() {
    if [[ "$2" == "location" ]]; then
        #获取重定向地址
        echo `curl $1 -H "$_ES_GLOBAL_USERAGENT" -I -G -s | grep "Location" | awk '{print $2}' | tr -d '\r' | tr -d '\n'`
    elif [[ "$2" == "code" ]]; then
        #获取状态码
        echo `curl $1 -H "$_ES_GLOBAL_USERAGENT" -I -G -s | grep "HTTP" | awk '{print $2}' | tr -d '\r' | tr -d '\n'`
    fi
}

# 检查网络状态
# Params: <Url>
# Retrun: 302=false, other=true
networkCheck() {
    if [[ `getUrlStatus $1 code` == 302 ]]; then
        false
    else
        true
    fi
}

# 获取学校ID
# Params: <Client IP> <Nas IP> <MAC>
# Return: {"schoolid": "xxx","domain": "xxx","rescode": "xxx","resinfo": "xxx"}
getSchoolId() {
    local cookie=""
    local timeStamp=`date +%s`
    local buffer=$1$2$3$timeStamp$_ES_GLOBAL_SECRET
    local md5=`echo -n "$buffer"|md5sum|cut -d ' ' -f1| tr '[a-z]' '[A-Z]'`
    local data="{\"clientip\":\"$1\",\"nasip\":\"$2\",\"mac\":\"$3\",\"timestamp\":$timeStamp,\"authenticator\":\"$md5\"}"
    local response=`postReq $_ES_GLOBAL_URL_QUERYSCHOOL $data $cookie`
    echo `getJson $response schoolid`
}

# 获取Cookie
# Params: <School ID>
# Return: Cookies
getCookie() {
    echo -n `curl "$_ES_GLOBAL_URL_AD" -H "$_ES_GLOBAL_USERAGENT" -G -d "$1" -s -i | grep Set-Cookie | awk '{print $2,$3,$4}'`
}

#获取验证码，响应{"challenge": "MR71","resinfo": "success","rescode": "0"}
# Params: <User Name> <Client IP> <Nas IP> <MAC> <Cookie>
# Return: Challenge
getVerifyCode() {
    local timeStamp=`date +%s`
    local buffer=$_ES_GLOBAL_VERSION$2$3$4$timeStamp$_ES_GLOBAL_SECRET
    local md5=`echo -n "$buffer"|md5sum|cut -d ' ' -f1| tr '[a-z]' '[A-Z]'`
    local data="{\"version\":\"$_ES_GLOBAL_VERSION\",\"username\":\"$1\",\"clientip\":\"$2\",\"nasip\":\"$3\",\"mac\":\"$4\",\"timestamp\":\"$timeStamp\",\"authenticator\":\"$md5\"}"
    local response=`postReq $_ES_GLOBAL_URL_VCHALLENGE $data $5`
    echo `getJson $response challenge`
}

# 登录外网
# Params: <User Name> <Password> <Client IP> <Nas IP> <Mac> <Cookie> <Verify Code>
# Return: {"resinfo":"login success","rescode":"0"}
loginTask() {
    local timeStamp=`date +%s`
    local buffer="$3$4$5$timeStamp$7$_ES_GLOBAL_SECRET"
    local md5=`echo -n "$buffer"|md5sum|cut -d ' ' -f1| tr '[a-z]' '[A-Z]'`
    local data="{\"username\":\"$1\",\"password\":\"$2\",\"clientip\":\"$3\",\"nasip\":\"$4\",\"mac\":\"$5\",\"iswifi\":\"$_ES_GLOBAL_ISWIFI\",\"timestamp\":\"$timeStamp\",\"authenticator\":\"$md5\"}"
    local response=`postReq $_ES_GLOBAL_URL_LOGIN $data $6`
    local rescode=`echo $response | awk -F rescode '{print $2}' | awk -F '"' '{print $3}'`
    _ES_RESULT_LOGING=$response
    if [[ "$rescode" == 0 ]]; then
        return
    else
        _ES_EXIT_CODE=1
        return 1
    fi
}

# 注销外网
# Params: <Client IP> <Nas IP> <Mac> <Cookie>
# Return: {"rescode":"xxx","resinfo":"xxx"}
logoutTask() {
    local timeStamp=`date +%s`
    local md5=`echo -n "$1$2$3$timeStamp$_ES_GLOBAL_SECRET"|md5sum|cut -d ' ' -f1| tr '[a-z]' '[A-Z]'`
    local data="{\"clientip\":\"$1\",\"nasip\":\"$2\",\"mac\":\"$3\",\"secret\":\"$_ES_GLOBAL_SECRET\",\"timestamp\":$timeStamp,\"authenticator\":\"$md5\"}"
    local response=`postReq $_ES_GLOBAL_URL_LOGOUT $data $4`
    local rescode=`echo $response | awk -F rescode '{print $2}' | awk -F '"' '{print $3}'`
    _ES_RESULT_LOGOUT=$response
    if [[ "$rescode" == 0 ]]; then
        return
    else
        _ES_EXIT_CODE=1
        return 1
    fi
}

# 检测是否在线，响应{"rescode":"0","resinfo":"在线"}/{"rescode":"-1","resinfo":"不在线"}
# isOnline(){
# 	local url="http://enet.10000.gd.cn:8001/hbservice/client/active?"
# 	local cookie=""
# 	local timestamp=`date +%s`
# 	local buffer=$_ES_CONFIG_CLIENTIP$_ES_CONFIG_NASIP$_ES_CONFIG_MAC$timestamp$_ES_GLOBAL_SECRET
# 	local md5=`echo -n "$buffer"|md5sum|cut -d ' ' -f1| tr '[a-z]' '[A-Z]'`
# 	local data="username=$_ES_ACC_USERNAME&clientip=$_ES_CONFIG_CLIENTIP&nasip=$_ES_CONFIG_NASIP&mac=$_ES_CONFIG_MAC&timestamp=$timestamp&authenticator=$md5"
# 	local response=`curl $url -G -d "$data" --cookie "$_ES_CONFIG_COOKIE" -s`
# 	#echo `getJson $response rescode`
# 	echo $response
# }

#登录逻辑
login() {
    # 网络检测，若可以连接外网则退出
    printl Info "正在检查当前网络..."
    if networkCheck $_ES_NC_URL; then
        printl Info "网络正常！"
        return
    fi
    # 开始登陆
    local urlCode=`getUrlStatus $_ES_NC_URL code`
    local urlLocation=`getUrlStatus $_ES_NC_URL location`
    if [[ "$urlCode" == "302" ]]; then
        # 获取重定向地址
        printl Info "当前网络需要登陆。"
        if [[ $verbose == true ]]; then
            printl Info "获取到重定向地址为: $urlLocation"
        fi
        if [[ $urlLocation =~ $_ES_REDIR_URL ]]; then
            # 获取用户IP和服务器IP
            printl Info "正在获取用户数据..."
            _ES_CONFIG_CLIENTIP=`getIP $urlLocation clientip`
            if [ $_ES_CONFIG_CLIENTIP ]; then
                if [[ $verbose == true ]]; then
                    printl Info "获取到客户端IP: $_ES_CONFIG_CLIENTIP"
                fi
            else
                printl Error "无法获取到客户端IP。"
                _ES_EXIT_CODE=1
            fi
            _ES_CONFIG_NASIP=`getIP $urlLocation nasip`
            if [ $_ES_CONFIG_NASIP ]; then
                if [[ $verbose == true ]]; then
                    printl Info "获取到服务器IP: $_ES_CONFIG_NASIP"
                fi
            else
                printl Error "无法获取到服务器IP。"
                _ES_EXIT_CODE=1
            fi

            # 获取MAC地址
            if [ $_ES_CONFIG_CLIENTIP ]; then
                _ES_CONFIG_MAC=`getMAC $_ES_CONFIG_CLIENTIP`
            else
                if [[ $verbose == true ]]; then
                    printl Info "因无法获取到客户端IP，所以尝试使用第一活跃网口/预定义网口的IP与MAC。"
                fi
                _ES_CONFIG_CLIENTIP=`getLocalIP $_ES_CONFIG_DEVICE`
                _ES_CONFIG_MAC=`getMAC $_ES_CONFIG_CLIENTIP`
            fi
            if [ $_ES_CONFIG_MAC ]; then
                if [[ $verbose == true ]]; then
                    printl Info "获取到客户端MAC: $_ES_CONFIG_MAC"
                fi
            else
                printl Error "无法获取到客户端MAC。"
                _ES_EXIT_CODE=1
            fi

            # 获取学校ID
            if [[ "$_ES_CONFIG_SCHOOLID" == "" ]]; then
                _ES_CONFIG_SCHOOLID=`getSchoolId $_ES_CONFIG_CLIENTIP $_ES_CONFIG_NASIP $_ES_CONFIG_MAC`
            fi
            if [ $_ES_CONFIG_SCHOOLID ]; then
                if [[ $verbose == true ]]; then
                    printl Info "获取到学校ID: $_ES_CONFIG_SCHOOLID"
                fi
            else
                printl Error "无法获取到学校ID。"
                _ES_EXIT_CODE=1
            fi

            # 获取Cookie
            if [ $_ES_CONFIG_SCHOOLID ]; then
                _ES_CONFIG_COOKIE=`getCookie $_ES_CONFIG_SCHOOLID`
            fi
            if [ "$_ES_CONFIG_COOKIE" ]; then
                if [[ $verbose == true ]]; then
                    printl Info "获取到Cookie: $_ES_CONFIG_COOKIE"
                fi
            else
                printl Error "无法获取到Cookie。"
                _ES_EXIT_CODE=1
            fi
            
            # 获取验证码
            _ES_CONFIG_VERIFYCODE=`getVerifyCode $_ES_ACC_USERNAME $_ES_CONFIG_CLIENTIP $_ES_CONFIG_NASIP $_ES_CONFIG_MAC $_ES_CONFIG_COOKIE`
            if [ $_ES_CONFIG_VERIFYCODE ]; then
                if [[ $verbose == true ]]; then
                    printl Info "获取到验证码: $_ES_CONFIG_VERIFYCODE"
                fi
            else
                printl Error "无法获取到验证码。"
                _ES_EXIT_CODE=1
            fi

            # 登录
            if [ $_ES_CONFIG_VERIFYCODE ]; then
                printl Info "正在登录中，请稍后..."
                if loginTask $_ES_ACC_USERNAME $_ES_ACC_PASSWD $_ES_CONFIG_CLIENTIP $_ES_CONFIG_NASIP $_ES_CONFIG_MAC "$_ES_CONFIG_COOKIE" $_ES_CONFIG_VERIFYCODE; then
                    printl Info "登陆成功！"
                    echo "_ES_CONFIG_CLIENTIP=$_ES_CONFIG_CLIENTIP" >> $_ES_HOMEPATH/eshell.run
                    echo "_ES_CONFIG_NASIP=$_ES_CONFIG_NASIP" >> $_ES_HOMEPATH/eshell.run
                    echo "_ES_CONFIG_MAC=$_ES_CONFIG_MAC" >> $_ES_HOMEPATH/eshell.run
                    echo "_ES_CONFIG_COOKIE=\"$_ES_CONFIG_COOKIE\"" >> $_ES_HOMEPATH/eshell.run
                else
                    printl Error "登陆失败。"
                fi
                if [[ $verbose == true ]]; then
                    printl Info "服务器返回结果: $_ES_RESULT_LOGING"
                fi
            else
                _ES_EXIT_CODE=1
                return
            fi

        else
            printl Error "获取登陆地址失败。"
            _ES_EXIT_CODE=1
        fi
    else
        printl Error "登录失败。请检查当前网络环境。"
        _ES_EXIT_CODE=1
        return
    fi
}


# 注销逻辑
logout() {
    if [ -e "$_ES_HOMEPATH/eshell.run" ]; then
        . $_ES_HOMEPATH/eshell.run
    else
        printl Warning "文件 $_ES_HOMEPATH/eshell.run 已丢失，无法读取上次登陆的缓存信息。"
    fi

    # 若变量缺失值则尝试获取
    if [ -z $_ES_CONFIG_CLIENTIP ]; then
        printl Warning "无法读取上次登陆缓存的客户端IP信息。"
        _ES_CONFIG_CLIENTIP=`getLocalIP $_ES_CONFIG_DEVICE`
    fi
    if [ -z $_ES_CONFIG_MAC ]; then
        printl Warning "无法读取上次登陆缓存的本机MAC信息。"
        _ES_CONFIG_MAC=`getMAC $_ES_CONFIG_CLIENTIP`
    fi
    if [ -z $_ES_CONFIG_NASIP ]; then
        printl Warning "无法读取上次登陆缓存的服务器IP信息。"
        read -p "请输入登出所需的服务器IP: " _ES_CONFIG_NASIP
    fi
    if [ -z "$_ES_CONFIG_COOKIE" ]; then
        printl Warning "无法读取上次登陆缓存的Cookie信息。"
        read -p "请输入登出所需的Cookie: " _ES_CONFIG_COOKIE
    fi
    if [[ $verbose == true ]]; then
        printl Info "获取到客户端IP为: $_ES_CONFIG_CLIENTIP"
        printl Info "获取到服务器IP为: $_ES_CONFIG_NASIP"
        printl Info "获取到本机MAC为: $_ES_CONFIG_MAC"
        printl Info "获取到Cookie: $_ES_CONFIG_COOKIE"
    fi

    printl Info "正在注销中，请稍后..."
    if logoutTask $_ES_CONFIG_CLIENTIP $_ES_CONFIG_NASIP $_ES_CONFIG_MAC "$_ES_CONFIG_COOKIE"; then
        printl Info "注销成功！"
        if [ -e "$_ES_HOMEPATH/eshell.run" ]; then
            rm $_ES_HOMEPATH/eshell.run
        fi
    else
        printl Error "注销失败。"
        _ES_EXIT_CODE=1
    fi
    if [[ $verbose == true ]]; then
        printl Info "服务器返回结果: $_ES_RESULT_LOGOUT"
    fi
}

# 循环检测登陆
daemon() {
    while true; do
        login
        printl Info "等待 $_ES_DAEMON_SLEEPTIME 后重复执行。"
        sleep $_ES_DAEMON_SLEEPTIME
    done
}

#帮助
help() {
    echo "用法：$0 <操作> [选项] [...]"
    echo "操作："
    printf "   $0 {-L --login}\t登陆到校园网\n"
    printf "   $0 {-O --logout}\t注销校园网\n"
    printf "   $0 {-D --daemon}\t监控模式\n"
    printf "   $0 {-C --custom}\t调用自定义函数\n"
    printf "   $0 {-h --help}\t显示本帮助\n"
    echo "选项："
    printf "   -a, --account\t账号\n"
    printf "   -p, --password\t密码\n"
    printf "   -d, --device\t\t指定网口\n"
    printf "   -v, --verbose\t显示详细信息\n"
}

main() {
    # 加载初始化文件
    if [ -e "$_ES_HOMEPATH/eshellrc.sh" ]; then
        . $_ES_HOMEPATH/eshellrc.sh
    fi

    if [[ "$funcCall" == "custom" ]]; then
        $funcCallCustom
    fi

    # Home目录不存在则创建
    if [ ! -d $_ES_HOMEPATH ]; then
        mkdir -p $_ES_HOMEPATH
    fi

    if [ -v $funcCall ]; then
        help
    else
        if [ $_ES_LOG_ENABLE == true ]; then
            createLog
        fi
        # 检测用户名和密码
        if [ -z $_ES_ACC_USERNAME ]; then
            printl Warning "用户名为空！"
            read -p "请输入用户名: " _ES_ACC_USERNAME
        fi
        if [ -z $_ES_ACC_PASSWD ]; then
            printl Warning "密码为空！"
            read -sp "请输入密码: " _ES_ACC_PASSWD
            echo ""
        fi

        # 获取第一活跃网口
        if [ -z $_ES_CONFIG_DEVICE ]; then
            _ES_CONFIG_DEVICE=`getActivateEther`
            if [ $_ES_CONFIG_DEVICE ]; then
                if [[ $verbose == true ]]; then
                    printl Info "获取到第一活跃网口: $_ES_CONFIG_DEVICE"
                fi
            else
                printl Warning "无法获取到第一活跃网口！"
                read -sp "请输入正连接校园网的网口: " _ES_CONFIG_DEVICE
                exit 1
            fi
        fi

        # 登录/注销
        if [[ "$funcCall" == "login" ]]; then
            login
        elif [[ "$funcCall" == "logout" ]]; then
            logout
        elif [[ "$funcCall" == "daemon" ]]; then
            daemon
        fi
    fi
}

# 解析参数
while [[ $# -gt 0 ]]; do
    case "${1}" in
        -C|--custom)
            funcCall="custom"
            funcCallCustom=$2
            shift 2
            ;;
        -D|--daemon)
            funcCall="daemon"
            shift
            ;;
        -L|--login)
            funcCall="login"
            shift
            ;;
        -O|--logout)
            funcCall="logout"
            shift
            ;;
        -h|--help)
            help
            ;;
    esac
    while true; do
        case "$1" in
            -a|--account)
                _ES_ACC_USERNAME=$2
                shift 2
                ;;
            -d|--device)
                _ES_CONFIG_DEVICE=$2
                shift 2
                ;;
            -p|--password)
                _ES_ACC_PASSWD=$2
                shift 2
                ;;
            -v|--verbose)
                verbose=true
                shift
                ;;
            *)
                break
                ;;
        esac
    done
    break
done

main

exit $_ES_EXIT_CODE
