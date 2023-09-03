#!/bin/bash
# EsurfingShell by SummonHIM. URL: https://github.com/SummonHIM/EsurfingShell
# Original author: @Otm-Z. Create on 2022/03/22. URL: https://github.com/Z446C/ESC-Z
# shellcheck disable=SC2317
#

# 变量定义
[ -z "$_ES_HOMEPATH" ] && _ES_HOMEPATH="$HOME/.config/esfshell"
[ -z "$_ES_DAEMON_SLEEPTIME" ] && _ES_DAEMON_SLEEPTIME="300s"
[ -z "$_ES_LOG_ENABLE" ] && _ES_LOG_ENABLE=false
[ -z "$_ES_LOG_PATH" ] && _ES_LOG_PATH="$_ES_HOMEPATH/esfshell.log"
[ -z "$_ES_LOG_MAXSIZE" ] && _ES_LOG_MAXSIZE=256
[ -z "$_ES_LOG_TAILLINE" ] && _ES_LOG_TAILLINE=3000
[ -z "$_ES_LOG_TIMESTAMP" ] && _ES_LOG_TIMESTAMP="+%Y-%m-%d %H:%M:%S"
[ -z "$_ES_GLOBAL_ISWIFI" ] && _ES_GLOBAL_ISWIFI="4060"
[ -z "$_ES_GLOBAL_SECRET" ] && _ES_GLOBAL_SECRET="Eshore!@#"
[ -z "$_ES_GLOBAL_VERSION" ] && _ES_GLOBAL_VERSION="214"
[ -z "$_ES_GLOBAL_USERAGENT" ] && _ES_GLOBAL_USERAGENT="User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/86.0.4240.198 Safari/537.36"
[ -z "$_ES_GLOBAL_ENET_URL_QUERYSCHOOL" ] && _ES_GLOBAL_ENET_URL_QUERYSCHOOL="/client/queryschool"
[ -z "$_ES_GLOBAL_ENET_URL_AD" ] && _ES_GLOBAL_ENET_URL_AD="/advertisement.do"
[ -z "$_ES_GLOBAL_ENET_URL_VCHALLENGE" ] && _ES_GLOBAL_ENET_URL_VCHALLENGE="/client/vchallenge"
[ -z "$_ES_GLOBAL_ENET_URL_LOGIN" ] && _ES_GLOBAL_ENET_URL_LOGIN="/client/login"
[ -z "$_ES_GLOBAL_ENET_URL_LOGOUT" ] && _ES_GLOBAL_ENET_URL_LOGOUT="/client/logout"
[ -z "$_ES_NC_URL" ] && _ES_NC_URL="http://connect.rom.miui.com/generate_204"
[ -z "$_ES_REDIR_URL" ] && _ES_REDIR_URL="enet.10000.gd.cn:10001"

_ES_EXIT_CODE=0

# 多语言
loadLang() {
    if [[ $LANG =~ "zh_CN" ]] || [[ $_ES_LANG =~ "zh_CN" ]]; then
        _ES_LANG_LOG_TOOLARGE="日志容量过大，正在删除旧的日志..."
        _ES_LANG_LOG_SIZE="日志容量"
        _ES_LANG_LOGIN_CHECK="正在检查当前网络..."
        _ES_LANG_LOGIN_CHECK_SUCCESS="网络正常！"
        _ES_LANG_LOGIN_CHECK_NEED="当前网络需要登陆。"
        _ES_LANG_LOGIN_CHECK_REDIRURL="获取到重定向地址为:"
        _ES_LANG_LOGIN_GET_USERDATA="正在获取用户数据..."
        _ES_LANG_LOGIN_GET_CLIENTIP="获取到客户端IP:"
        _ES_LANG_LOGIN_GET_CLIENTIP_FAILED="无法获取到客户端IP。"
        _ES_LANG_LOGIN_GET_NASIP="获取到服务器IP:"
        _ES_LANG_LOGIN_GET_NASIP_FAILED="无法获取到服务器IP。"
        _ES_LANG_LOGIN_GET_MAC_RETRY="因无法获取到客户端IP，所以尝试使用第一活跃网口/预定义网口的IP与MAC。"
        _ES_LANG_LOGIN_GET_MAC="获取到客户端MAC:"
        _ES_LANG_LOGIN_GET_MAC_FAILED="无法获取到客户端MAC。"
        _ES_LANG_LOGIN_GET_SCHOOLID="获取到学校ID:"
        _ES_LANG_LOGIN_GET_SCHOOLID_FAILED="无法获取到学校ID。"
        _ES_LANG_LOGIN_GET_COOKIE="获取到Cookie:"
        _ES_LANG_LOGIN_GET_COOKIE_FAILED="无法获取到Cookie。"
        _ES_LANG_LOGIN_GET_VERIFYCODE="获取到验证码:"
        _ES_LANG_LOGIN_GET_VERIFYCODE_FAILED="无法获取到验证码。"
        _ES_LANG_LOGIN_ING="正在登录中，请稍后..."
        _ES_LANG_LOGIN_SUCCESS="登陆成功！"
        _ES_LANG_LOGIN_FAILED="登录失败。"
        _ES_LANG_LOGIN_RESULT="服务器返回结果:"
        _ES_LANG_LOGIN_CHECK_REDIRURL_FAILED="获取登陆地址失败。"
        _ES_LANG_LOGIN_CHECK_FAILED="登录失败。请检查当前网络环境。"
        _ES_LANG_LOGOUT_RUNFILE_LOST_A="文件"
        _ES_LANG_LOGOUT_RUNFILE_LOST_B="已丢失，无法读取上次登陆的缓存信息。"
        _ES_LANG_LOGOUT_GET_CLIENT_FAILED="无法读取上次登陆缓存的客户端IP信息。"
        _ES_LANG_LOGOUT_GET_MAC_FAILED="无法读取上次登陆缓存的本机MAC信息。"
        _ES_LANG_LOGOUT_GET_NASIP_FAILED="无法读取上次登陆缓存的服务器IP信息。"
        _ES_LANG_LOGOUT_GET_NASIP_MANUAL="请输入登出所需的服务器IP:"
        _ES_LANG_LOGOUT_GET_COOKIE_FAILED="无法读取上次登陆缓存的Cookie信息。"
        _ES_LANG_LOGOUT_GET_COOKIE_MANUAL="请输入登出所需的Cookie:"
        _ES_LANG_LOGOUT_GET_CLIENTIP="获取到客户端IP:"
        _ES_LANG_LOGOUT_GET_NASIP="获取到服务器IP:"
        _ES_LANG_LOGOUT_GET_MAC="获取到客户端MAC:"
        _ES_LANG_LOGOUT_GET_COOKIE="获取到Cookie:"
        _ES_LANG_LOGOUT_ING="正在注销中，请稍后..."
        _ES_LANG_LOGOUT_SUCCESS="注销成功！"
        _ES_LANG_LOGOUT_FAILED="注销失败。"
        _ES_LANG_LOGOUT_RESULT="服务器返回结果:"
        _ES_LANG_DAEMON_WAIT_A="等待"
        _ES_LANG_DAEMON_WAIT_B="后重复执行。"
        _ES_LANG_MAIN_HOMEPATH_MKDIR_A="主目录"
        _ES_LANG_MAIN_HOMEPATH_MKDIR_B="不存在，正在创建..."
        _ES_LANG_MAIN_USERNAME_EMPTY="用户名为空！"
        _ES_LANG_MAIN_USERNAME_MANUAL="请输入用户名:"
        _ES_LANG_MAIN_PASSWD_EMPTY="密码为空！"
        _ES_LANG_MAIN_PASSWD_MANUAL="请输入密码:"
        _ES_LANG_ACTIVATE_ETHER="获取到第一活跃网口:"
        _ES_LANG_ACTIVATE_ETHER_FAILED="无法获取到第一活跃网口！"
        _ES_LANG_ACTIVATE_ETHER_MANUAL="请输入正连接校园网的网口:"
        _ES_LANG_STARTING_DAEMON="正在启动监控模式..."

        help() {
            echo "用法：${0##*/} <操作> [选项] [...]"
            echo "操作："
            printf "   %s {-L --login}\t\t登陆到校园网\n" "${0##*/}"
            printf "   %s {-O --logout}\t\t注销校园网\n" "${0##*/}"
            printf "   %s {-D --daemon}\t\t监控模式\n" "${0##*/}"
            printf "   %s {-C --custom} <函数名>\t调用自定义函数\n" "${0##*/}"
            printf "   %s {-h --help}\t\t\t显示本帮助\n" "${0##*/}"
            echo "选项："
            printf "   -a, --account <账号>\t\t账号\n"
            printf "   -p, --password <密码>\t密码\n"
            printf "   -d, --device <网口>\t\t指定网口\n"
            printf "   -f, --force\t\t\t强制操作\n"
            printf "   -v, --verbose\t\t显示详细信息\n"
            printf "       --home <主目录>\t\t指定主目录\n"
        }
    else
        _ES_LANG_LOG_TOOLARGE="Log size too large, deleting outdate log..."
        _ES_LANG_LOG_SIZE="Log size"
        _ES_LANG_LOGIN_CHECK="Checking network connection..."
        _ES_LANG_LOGIN_CHECK_SUCCESS="Network connect successful."
        _ES_LANG_LOGIN_CHECK_NEED="Need to login to auth platform."
        _ES_LANG_LOGIN_CHECK_REDIRURL="Fetched redirect URL:"
        _ES_LANG_LOGIN_GET_USERDATA="Fetching user data..."
        _ES_LANG_LOGIN_GET_CLIENTIP="Fetched client IP:"
        _ES_LANG_LOGIN_GET_CLIENTIP_FAILED="Fetch client IP failed."
        _ES_LANG_LOGIN_GET_NASIP="Fetched NAS IP:"
        _ES_LANG_LOGIN_GET_NASIP_FAILED="Fetch NAS IP failed."
        _ES_LANG_LOGIN_GET_MAC_RETRY="Because of fetch client IP failed. Try using first activating network interface/definition network interface's IP & MAC."
        _ES_LANG_LOGIN_GET_MAC="Fetched client MAC:"
        _ES_LANG_LOGIN_GET_MAC_FAILED="Fetch client MAC failed."
        _ES_LANG_LOGIN_GET_SCHOOLID="Fetched school ID:"
        _ES_LANG_LOGIN_GET_SCHOOLID_FAILED="Fetch school ID failed."
        _ES_LANG_LOGIN_GET_COOKIE="Fetched Cookie:"
        _ES_LANG_LOGIN_GET_COOKIE_FAILED="Fetch Cookie failed."
        _ES_LANG_LOGIN_GET_VERIFYCODE="Fetched verify code:"
        _ES_LANG_LOGIN_GET_VERIFYCODE_FAILED="Fetch verify code failed."
        _ES_LANG_LOGIN_ING="Logging..."
        _ES_LANG_LOGIN_SUCCESS="Login successful!"
        _ES_LANG_LOGIN_FAILED="Login failed."
        _ES_LANG_LOGIN_RESULT="Server response result:"
        _ES_LANG_LOGIN_CHECK_REDIRURL_FAILED="Fetch login URL failed."
        _ES_LANG_LOGIN_CHECK_FAILED="Login failed. please check your network environment."
        _ES_LANG_LOGOUT_RUNFILE_LOST_A="File"
        _ES_LANG_LOGOUT_RUNFILE_LOST_B="not found, can not fetch cached last login information."
        _ES_LANG_LOGOUT_GET_CLIENT_FAILED="Can not fetch cached last login's client IP."
        _ES_LANG_LOGOUT_GET_MAC_FAILED="Can not fetch cached last login's client MAC."
        _ES_LANG_LOGOUT_GET_NASIP_FAILED="Can not fetch cached last login's NAS IP."
        _ES_LANG_LOGOUT_GET_NASIP_MANUAL="Please enter the NAS IP which need to logout:"
        _ES_LANG_LOGOUT_GET_COOKIE_FAILED="Can not fetch cached last login's cookie."
        _ES_LANG_LOGOUT_GET_COOKIE_MANUAL="Please enter the cookie which need to logout:"
        _ES_LANG_LOGOUT_GET_CLIENTIP="Fetched client IP:"
        _ES_LANG_LOGOUT_GET_NASIP="Fetched NAS IP:"
        _ES_LANG_LOGOUT_GET_MAC="Fetched client MAC:"
        _ES_LANG_LOGOUT_GET_COOKIE="Fetched Cookie:"
        _ES_LANG_LOGOUT_ING="Logouting..."
        _ES_LANG_LOGOUT_SUCCESS="Logout successful!"
        _ES_LANG_LOGOUT_FAILED="Logout failed."
        _ES_LANG_LOGOUT_RESULT="Server response result:"
        _ES_LANG_DAEMON_WAIT_A="Wait"
        _ES_LANG_DAEMON_WAIT_B="."
        _ES_LANG_MAIN_HOMEPATH_MKDIR_A="Home path"
        _ES_LANG_MAIN_HOMEPATH_MKDIR_B="not exist, creating..."
        _ES_LANG_MAIN_USERNAME_EMPTY="User name empty!"
        _ES_LANG_MAIN_USERNAME_MANUAL="Please enter the user name:"
        _ES_LANG_MAIN_PASSWD_EMPTY="Password empty!"
        _ES_LANG_MAIN_PASSWD_MANUAL="Please enter the password:"
        _ES_LANG_ACTIVATE_ETHER="Fetched first activating network interface:"
        _ES_LANG_ACTIVATE_ETHER_FAILED="Can not fetch first activating network interface."
        _ES_LANG_ACTIVATE_ETHER_MANUAL="Please enter a working network interface:"
        _ES_LANG_STARTING_DAEMON="Starting daemon mode..."

        help() {
            echo "Usage：${0##*/} <Operation> [Options] [...]"
            echo "Operation:"
            printf "   %s {-L --login}\t\tLogin into esurfing network\n" "${0##*/}"
            printf "   %s {-O --logout}\t\tLogout esurfing network\n" "${0##*/}"
            printf "   %s {-D --daemon}\t\tDaemon mode\n" "${0##*/}"
            printf "   %s {-C --custom} <Function>\tCall custom function\n" "${0##*/}"
            printf "   %s {-h --help}\t\t\tShow this help\n" "${0##*/}"
            echo "Options:"
            printf "   -a, --account <Account>\tAccount\n"
            printf "   -p, --password <Password>\tPassword\n"
            printf "   -d, --device <Interface>\tSpecify network interface\n"
            printf "   -f, --force\t\t\tForce action\n"
            printf "   -v, --verbose\t\tBe verbose\n"
            printf "       --home <Home path>\tSpecify home path\n"
        }
    fi
}

# 打印日志
# Params: <Log type> <Log message>
# Return: YYYY-MM-DD [Log type]: Log message
printl() {
    printf "%s [%s]: %s\n" "$(date "$_ES_LOG_TIMESTAMP")" "$1" "$2"
    if [ "$_ES_LOG_ENABLE" == true ]; then
        printf "%s [%s]: %s\n" "$(date "$_ES_LOG_TIMESTAMP")" "$1" "$2" >>"$_ES_LOG_PATH"
    fi
}

# 创建日志
createLog() {
    if [[ "$_ES_LOG_PATH" == "" ]]; then
        _ES_LOG_PATH="$_ES_HOMEPATH/esfshell.log"
    fi
    if [ -f "$_ES_LOG_PATH" ]; then
        local size
        size=$(find "$_ES_LOG_PATH" | awk '{ print $5 }')
        local maxsize=$((_ES_LOG_MAXSIZE * 1024))
        if [ "$size" -ge $maxsize ]; then
            printl Info "$_ES_LANG_LOG_TOOLARGE"
            #只保留取后$_ES_LOG_TAILLINE行内容
            tail -n "$_ES_LOG_TAILLINE" "$_ES_LOG_PATH" >"$_ES_LOG_PATH.tmp"
            rm -f "$_ES_LOG_PATH"
            mv "$_ES_LOG_PATH.tmp" "$_ES_LOG_PATH"
        else
            if [[ $_ES_VERBOSE == true ]]; then
                printl Debug "$_ES_LANG_LOG_SIZE $((size / 1024))MiB/$((maxsize / 1024))MiB"
            fi
        fi
    fi
}

# Json数据解析
# Params: <Origin data> <Json key>
# Return: <Json value>
getJson() {
    echo "$1" | awk -F "$2" '{print $2}' | awk -F '"' '{print $3}'
}

# Post请求 (postReq url data cookie)
# Params: <Url> <Data> <Cookie>
# Return: <Post return string>
postReq() {
    local contentType="Content-Type: application/json"
    local accept="Accept: */*"
    curl "$1" -H "$_ES_GLOBAL_USERAGENT" -H "$contentType" -H "$accept" -d "$2" --cookie "$3" -s --interface "$_ES_GLOBAL_DEVICE"
}

# 获取用户IP
# Params: <Url> <type>
# Return: Value
getIP() {
    # 2、从重定向网页中获取
    # "http://enet.10000.gd.cn:10001/?wlanuserip=100.2.49.240&wlanacip=119.146.175.80"
    # "http://enet.10000.gd.cn:10001/qs/main.jsp?wlanacip=119.146.175.80&wlanuserip=100.2.50.69"
    local tmp1 tmp2 tClientIp tNasIp
    tmp1=$(echo -n "$1" | cut -d '?' -f2 | cut -d '&' -f1)
    tmp2=$(echo -n "$1" | cut -d '?' -f2 | cut -d '&' -f2)

    tClientIp=$(echo -n "$tmp1" | grep "wlanuserip")

    tNasIp=$(echo -n "$tmp2" | grep "wlanacip")

    if [[ "$2" == "clientip" ]]; then
        if [[ "$tClientIp" == "" ]]; then
            echo -n "$tmp2" | cut -d '=' -f2 | tr -d '\r' | tr -d '\n'
        else
            echo -n "$tmp1" | cut -d '=' -f2 | tr -d '\r' | tr -d '\n'
        fi
    fi

    if [[ "$2" == "nasip" ]]; then
        if [[ "$tNasIp" == "" ]]; then
            echo -n "$tmp1" | cut -d '=' -f2 | tr -d '\r' | tr -d '\n'
        else
            echo -n "$tmp2" | cut -d '=' -f2 | tr -d '\r' | tr -d '\n'
        fi
    fi
}

# 获取第一活跃端口
# Return: Ether name
getActivateEther() {
    ip addr | grep "state UP" | awk '{print $2}' | cut -d: -f1 | head -1
}

# 获取MAC地址
# Params: <IP>
# Return: MAC
getMAC() {
    ip addr | grep -C3 "$1" | awk '/ether/ { print $2 }' | head -1
}

# 获取本地IP地址
# Params: <Ether>
# Return: Ether's IP
getLocalIP() {
    ip addr show dev "$1 " | grep "inet " | awk '{print $2}' | cut -d/ -f1 | head -1
}

# 网站访问状态
# Params: <URL> <Output type>
# Return: CUrl output data
getUrlStatus() {
    if [[ "$2" == "location" ]]; then
        #获取重定向地址
        curl "$1" -H "$_ES_GLOBAL_USERAGENT" -I -G -s --interface "$_ES_GLOBAL_DEVICE" | grep "Location" | awk '{print $2}' | tr -d '\r' | tr -d '\n'
    elif [[ "$2" == "code" ]]; then
        #获取状态码
        curl "$1" -H "$_ES_GLOBAL_USERAGENT" -I -G -s --interface "$_ES_GLOBAL_DEVICE" | grep "HTTP" | awk '{print $2}' | tr -d '\r' | tr -d '\n'
    fi
}

# 检查网络状态
# Params: <Url>
# Retrun: 302=false, other=true
networkCheck() {
    if [[ $(getUrlStatus "$1" code) == 302 ]]; then
        false
    else
        true
    fi
}

# 获取Enet的Host
# Params: <Url>
# Return: host
getEnetHost() {
    echo "$1" | cut -d '/' -f3
}

# 获取学校ID
# Params: <Client IP> <Nas IP> <MAC>
# Return: {"schoolid": "xxx","domain": "xxx","rescode": "xxx","resinfo": "xxx"}
getSchoolId() {
    local timeStamp md5 data response
    local cookie=""
    timeStamp=$(date +%s)
    md5=$(echo -n "$1$2$3$timeStamp$_ES_GLOBAL_SECRET" | md5sum | cut -d ' ' -f1 | tr 'a-z[]' 'A-Z[]')
    data="{\"clientip\":\"$1\",\"nasip\":\"$2\",\"mac\":\"$3\",\"timestamp\":$timeStamp,\"authenticator\":\"$md5\"}"
    response=$(postReq "$_ES_GLOBAL_ENET_URL$_ES_GLOBAL_ENET_URL_QUERYSCHOOL" "$data" "$cookie")
    getJson "$response" schoolid
}

# 获取Cookie
# Params: <School ID>
# Return: Cookies
getCookie() {
    curl "$_ES_GLOBAL_ENET_URL$_ES_GLOBAL_ENET_URL_AD" -H "$_ES_GLOBAL_USERAGENT" -G -d "$1" -s -i --interface "$_ES_GLOBAL_DEVICE" | grep Set-Cookie | awk '{print $2,$3,$4}'
}

#获取验证码，响应{"challenge": "MR71","resinfo": "success","rescode": "0"}
# Params: <User Name> <Client IP> <Nas IP> <MAC> <Cookie>
# Return: Challenge
getVerifyCode() {
    local timeStamp md5 response data
    timeStamp=$(date +%s)
    md5=$(echo -n "$_ES_GLOBAL_VERSION$2$3$4$timeStamp$_ES_GLOBAL_SECRET" | md5sum | cut -d ' ' -f1 | tr 'a-z[]' 'A-Z[]')
    data="{\"version\":\"$_ES_GLOBAL_VERSION\",\"username\":\"$1\",\"clientip\":\"$2\",\"nasip\":\"$3\",\"mac\":\"$4\",\"timestamp\":\"$timeStamp\",\"authenticator\":\"$md5\"}"
    response=$(postReq "$_ES_GLOBAL_ENET_URL$_ES_GLOBAL_ENET_URL_VCHALLENGE" "$data" "$5")
    getJson "$response" challenge
}

# 登录外网
# Params: <User Name> <Password> <Client IP> <Nas IP> <Mac> <Cookie> <Verify Code>
# Return: {"resinfo":"login success","rescode":"0"}
loginTask() {
    local timeStamp md5 response data rescode
    timeStamp=$(date +%s)
    md5=$(echo -n "$3$4$5$timeStamp$7$_ES_GLOBAL_SECRET" | md5sum | cut -d ' ' -f1 | tr 'a-z[]' 'A-Z[]')
    data="{\"username\":\"$1\",\"password\":\"$2\",\"clientip\":\"$3\",\"nasip\":\"$4\",\"mac\":\"$5\",\"iswifi\":\"$_ES_GLOBAL_ISWIFI\",\"timestamp\":\"$timeStamp\",\"authenticator\":\"$md5\"}"
    response=$(postReq "$_ES_GLOBAL_ENET_URL$_ES_GLOBAL_ENET_URL_LOGIN" "$data" "$6")
    rescode=$(echo "$response" | awk -F rescode '{print $2}' | awk -F '"' '{print $3}')
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
    local timeStamp md5 response data rescode
    timeStamp=$(date +%s)
    md5=$(echo -n "$1$2$3$timeStamp$_ES_GLOBAL_SECRET" | md5sum | cut -d ' ' -f1 | tr 'a-z[]' 'A-Z[]')
    data="{\"clientip\":\"$1\",\"nasip\":\"$2\",\"mac\":\"$3\",\"secret\":\"$_ES_GLOBAL_SECRET\",\"timestamp\":$timeStamp,\"authenticator\":\"$md5\"}"
    response=$(postReq "$_ES_GLOBAL_ENET_URL$_ES_GLOBAL_ENET_URL_LOGOUT" "$data" "$4")
    rescode=$(echo "$response" | awk -F rescode '{print $2}' | awk -F '"' '{print $3}')
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

# 获取第一活跃网口逻辑
logicActivateEther() {
    if [ -z "$_ES_GLOBAL_DEVICE" ]; then
        _ES_GLOBAL_DEVICE=$(getActivateEther)
        if [ "$_ES_GLOBAL_DEVICE" ]; then
            if [[ $_ES_VERBOSE == true ]]; then
                printl Debug "$_ES_LANG_ACTIVATE_ETHER $_ES_GLOBAL_DEVICE"
            fi
        else
            printl Warning "$_ES_LANG_ACTIVATE_ETHER_FAILED"
            read -rsp "$_ES_LANG_ACTIVATE_ETHER_MANUAL " _ES_GLOBAL_DEVICE
            exit 1
        fi
    fi
}

loginEnet() {
    # 获取用户IP和服务器IP
    printl Info "$_ES_LANG_LOGIN_GET_USERDATA"

    _ES_GLOBAL_ENET_URL="http://$(getEnetHost "$_ES_NC_URLLOCATION")"

    _ES_CONFIG_CLIENTIP=$(getIP "$_ES_NC_URLLOCATION" clientip)
    if [ "$_ES_CONFIG_CLIENTIP" ]; then
        if [[ $_ES_VERBOSE == true ]]; then
            printl Debug "$_ES_LANG_LOGIN_GET_CLIENTIP $_ES_CONFIG_CLIENTIP"
        fi
    else
        printl Error "$_ES_LANG_LOGIN_GET_CLIENTIP_FAILED"
        _ES_EXIT_CODE=1
    fi
    _ES_CONFIG_NASIP=$(getIP "$_ES_NC_URLLOCATION" nasip)
    if [ "$_ES_CONFIG_NASIP" ]; then
        if [[ $_ES_VERBOSE == true ]]; then
            printl Debug "$_ES_LANG_LOGIN_GET_NASIP $_ES_CONFIG_NASIP"
        fi
    else
        printl Error "$_ES_LANG_LOGIN_GET_NASIP_FAILED"
        _ES_EXIT_CODE=1
    fi

    # 获取MAC地址
    if [ "$_ES_CONFIG_CLIENTIP" ]; then
        _ES_CONFIG_MAC=$(getMAC "$_ES_CONFIG_CLIENTIP")
    else
        if [[ $_ES_VERBOSE == true ]]; then
            printl Debug "$_ES_LANG_LOGIN_GET_MAC_RETRY"
        fi
        _ES_CONFIG_CLIENTIP=$(getLocalIP "$_ES_GLOBAL_DEVICE")
        _ES_CONFIG_MAC=$(getMAC "$_ES_CONFIG_CLIENTIP")
    fi
    if [ "$_ES_CONFIG_MAC" ]; then
        if [[ $_ES_VERBOSE == true ]]; then
            printl Debug "$_ES_LANG_LOGIN_GET_MAC $_ES_CONFIG_MAC"
        fi
    else
        printl Error "$_ES_LANG_LOGIN_GET_MAC_FAILED"
        _ES_EXIT_CODE=1
    fi

    # 获取学校ID
    if [[ "$_ES_CONFIG_SCHOOLID" == "" ]]; then
        _ES_CONFIG_SCHOOLID=$(getSchoolId "$_ES_CONFIG_CLIENTIP" "$_ES_CONFIG_NASIP" "$_ES_CONFIG_MAC")
    fi
    if [ "$_ES_CONFIG_SCHOOLID" ]; then
        if [[ $_ES_VERBOSE == true ]]; then
            printl Debug "$_ES_LANG_LOGIN_GET_SCHOOLID $_ES_CONFIG_SCHOOLID"
        fi
    else
        printl Error "$_ES_LANG_LOGIN_GET_SCHOOLID_FAILED"
        _ES_EXIT_CODE=1
    fi

    # 获取Cookie
    if [ "$_ES_CONFIG_SCHOOLID" ]; then
        _ES_CONFIG_COOKIE=$(getCookie "$_ES_CONFIG_SCHOOLID")
    fi
    if [ "$_ES_CONFIG_COOKIE" ]; then
        if [[ $_ES_VERBOSE == true ]]; then
            printl Debug "$_ES_LANG_LOGIN_GET_COOKIE $_ES_CONFIG_COOKIE"
        fi
    else
        printl Error "$_ES_LANG_LOGIN_GET_COOKIE_FAILED"
        _ES_EXIT_CODE=1
    fi

    # 获取验证码
    _ES_CONFIG_VERIFYCODE=$(getVerifyCode "$_ES_ACC_USERNAME" "$_ES_CONFIG_CLIENTIP" "$_ES_CONFIG_NASIP" "$_ES_CONFIG_MAC" "$_ES_CONFIG_COOKIE")
    if [ "$_ES_CONFIG_VERIFYCODE" ]; then
        if [[ $_ES_VERBOSE == true ]]; then
            printl Debug "$_ES_LANG_LOGIN_GET_VERIFYCODE $_ES_CONFIG_VERIFYCODE"
        fi
    else
        printl Error "$_ES_LANG_LOGIN_GET_VERIFYCODE_FAILED"
        _ES_EXIT_CODE=1
    fi

    # 登录
    if [ "$_ES_CONFIG_VERIFYCODE" ]; then
        printl Info "$_ES_LANG_LOGIN_ING"
        if loginTask "$_ES_ACC_USERNAME" "$_ES_ACC_PASSWD" "$_ES_CONFIG_CLIENTIP" "$_ES_CONFIG_NASIP" "$_ES_CONFIG_MAC" "$_ES_CONFIG_COOKIE" "$_ES_CONFIG_VERIFYCODE"; then
            printl Info "$_ES_LANG_LOGIN_SUCCESS"
            {
                echo "_ES_GLOBAL_ENET_URL=\"$_ES_GLOBAL_ENET_URL\""
                echo "_ES_CONFIG_CLIENTIP=\"$_ES_CONFIG_CLIENTIP\""
                echo "_ES_CONFIG_NASIP=\"$_ES_CONFIG_NASIP\""
                echo "_ES_CONFIG_MAC=\"$_ES_CONFIG_MAC\""
                echo "_ES_CONFIG_COOKIE=\"$_ES_CONFIG_COOKIE\""
            } >"$_ES_HOMEPATH/esfshell.run"
        else
            printl Error "$_ES_LANG_LOGIN_FAILED"
        fi
        if [[ $_ES_VERBOSE == true ]]; then
            printl Debug "$_ES_LANG_LOGIN_RESULT $_ES_RESULT_LOGING"
        fi
    else
        _ES_EXIT_CODE=1
        return
    fi
}

#登录逻辑
login() {
    # 网络检测，若可以连接外网则退出
    printl Info "$_ES_LANG_LOGIN_CHECK"
    if [[ $_ES_FORCE != true ]]; then
        if networkCheck "$_ES_NC_URL"; then
            printl Info "$_ES_LANG_LOGIN_CHECK_SUCCESS"
            return
        fi
    fi
    # 开始登陆
    if [[ $_ES_FORCE == true ]]; then
        if [[ $_ES_NC_URLLOCATION =~ $_ES_REDIR_URL ]]; then
            loginEnet
        else
            printl Error "$_ES_LANG_LOGIN_CHECK_REDIRURL_FAILED"
            _ES_EXIT_CODE=1
        fi
    else
        local urlCode
        urlCode=$(getUrlStatus "$_ES_NC_URL" code)
        _ES_NC_URLLOCATION=$(getUrlStatus "$_ES_NC_URL" location)
        if [[ "$urlCode" == "302" ]]; then
            # 获取重定向地址
            printl Info "$_ES_LANG_LOGIN_CHECK_NEED"
            if [[ $_ES_VERBOSE == true ]]; then
                printl Debug "$_ES_LANG_LOGIN_CHECK_REDIRURL $_ES_NC_URLLOCATION"
            fi
            if [[ $_ES_NC_URLLOCATION =~ $_ES_REDIR_URL ]]; then
                loginEnet
            else
                printl Error "$_ES_LANG_LOGIN_CHECK_REDIRURL_FAILED"
                _ES_EXIT_CODE=1
            fi
        else
            printl Error "$_ES_LANG_LOGIN_CHECK_FAILED"
            _ES_EXIT_CODE=1
            return
        fi
    fi
}

# 注销逻辑
logout() {
    if [ -e "$_ES_HOMEPATH/esfshell.run" ]; then
        source "$_ES_HOMEPATH/esfshell.run"
    else
        printl Warning "$_ES_LANG_LOGOUT_RUNFILE_LOST_A $_ES_HOMEPATH/esfshell.run $_ES_LANG_LOGOUT_RUNFILE_LOST_B"
    fi

    if [[ $_ES_FORCE != true ]]; then
        # 若变量缺失值则尝试获取
        if [ -z "$_ES_CONFIG_CLIENTIP" ]; then
            printl Warning "$_ES_LANG_LOGOUT_GET_CLIENT_FAILED"
            _ES_CONFIG_CLIENTIP=$(getLocalIP "$_ES_GLOBAL_DEVICE")
        fi
        if [ -z "$_ES_CONFIG_MAC" ]; then
            printl Warning "$_ES_LANG_LOGOUT_GET_MAC_FAILED"
            _ES_CONFIG_MAC=$(getMAC "$_ES_CONFIG_CLIENTIP")
        fi
        if [ -z "$_ES_CONFIG_NASIP" ]; then
            printl Warning "$_ES_LANG_LOGOUT_GET_NASIP_FAILED"
            read -rp "$_ES_LANG_LOGOUT_GET_NASIP_MANUAL " _ES_CONFIG_NASIP
        fi
        if [ -z "$_ES_CONFIG_COOKIE" ]; then
            printl Warning "$_ES_LANG_LOGOUT_GET_COOKIE_FAILED"
            read -rp "$_ES_LANG_LOGOUT_GET_COOKIE_MANUAL " _ES_CONFIG_COOKIE
        fi
    fi

    if [[ $_ES_VERBOSE == true ]]; then
        printl Debug "$_ES_LANG_LOGOUT_GET_CLIENTIP $_ES_CONFIG_CLIENTIP"
        printl Debug "$_ES_LANG_LOGOUT_GET_NASIP $_ES_CONFIG_NASIP"
        printl Debug "$_ES_LANG_LOGOUT_GET_MAC $_ES_CONFIG_MAC"
        printl Debug "$_ES_LANG_LOGOUT_GET_COOKIE $_ES_CONFIG_COOKIE"
    fi

    printl Info "$_ES_LANG_LOGOUT_ING"
    if logoutTask "$_ES_CONFIG_CLIENTIP" "$_ES_CONFIG_NASIP" "$_ES_CONFIG_MAC" "$_ES_CONFIG_COOKIE"; then
        printl Info "$_ES_LANG_LOGOUT_SUCCESS"
        if [ -e "$_ES_HOMEPATH/esfshell.run" ]; then
            rm "$_ES_HOMEPATH/esfshell.run"
        fi
    else
        printl Error "$_ES_LANG_LOGOUT_FAILED"
        _ES_EXIT_CODE=1
    fi
    if [[ $_ES_VERBOSE == true ]]; then
        printl Debug "$_ES_LANG_LOGOUT_RESULT $_ES_RESULT_LOGOUT"
    fi
}

# 循环检测登陆
daemon() {
    printl Info "$_ES_LANG_STARTING_DAEMON"
    while true; do
        if [[ $_ES_VERBOSE == true ]]; then
            logicActivateEther
            login
            printl Info "$_ES_LANG_DAEMON_WAIT_A $_ES_DAEMON_SLEEPTIME $_ES_LANG_DAEMON_WAIT_B"
        else
            logicActivateEther >nul
            login >nul
        fi
        sleep "$_ES_DAEMON_SLEEPTIME"
    done
}

# 解析参数
while [[ $# -gt 0 ]]; do
    case "${1}" in
    -C | --custom)
        funcCall=$2
        shift 2
        ;;
    -D | --daemon)
        funcCall="daemon"
        shift
        ;;
    -L | --login)
        funcCall="login"
        shift
        ;;
    -O | --logout)
        funcCall="logout"
        shift
        ;;
    -h | --help)
        funcCall="help"
        shift
        ;;
    esac
    while true; do
        case "$1" in
        -a | --account)
            _ES_ACC_USERNAME=$2
            shift 2
            ;;
        -d | --device)
            _ES_GLOBAL_DEVICE=$2
            shift 2
            ;;
        -f | --force)
            _ES_FORCE=true
            shift
            ;;
        -p | --password)
            _ES_ACC_PASSWD=$2
            shift 2
            ;;
        -v | --verbose)
            _ES_VERBOSE=true
            shift
            ;;
        --home)
            _ES_HOMEPATH=$2
            shift 2
            ;;
        *)
            break
            ;;
        esac
    done
    break
done

# 加载初始化文件
if [ -e "$_ES_HOMEPATH/esfshellrc.sh" ]; then
    source "$_ES_HOMEPATH/esfshellrc.sh"
fi

# 加载语言
loadLang

# Home目录不存在则创建
if [ ! -d "$_ES_HOMEPATH" ]; then
    if [[ $_ES_VERBOSE == true ]]; then
        printl Warning "$_ES_LANG_MAIN_HOMEPATH_MKDIR_A $_ES_HOMEPATH $_ES_LANG_MAIN_HOMEPATH_MKDIR_B"
    fi
    mkdir -p "$_ES_HOMEPATH"
fi

if [ -z "$funcCall" ]; then
    help
else
    if [ "$_ES_LOG_ENABLE" == true ]; then
        createLog
    fi
    # 检测用户名和密码
    if [ -z "$_ES_ACC_USERNAME" ]; then
        printl Warning "$_ES_LANG_MAIN_USERNAME_EMPTY"
        read -rp "$_ES_LANG_MAIN_USERNAME_MANUAL " _ES_ACC_USERNAME
    fi
    if [ -z "$_ES_ACC_PASSWD" ]; then
        printl Warning "$_ES_LANG_MAIN_PASSWD_EMPTY"
        read -rsp "$_ES_LANG_MAIN_PASSWD_MANUAL " _ES_ACC_PASSWD
        echo ""
    fi

    logicActivateEther

    $funcCall
fi

exit $_ES_EXIT_CODE
