# EsurfingShell
基于Bash Shell的天翼校园登录脚本

## 脚本说明
- 使用Bash Shell轻量脚本，兼容大部分系统。
- 支持Linux、MacOS（未测试）、Windows以及其他支持Shell的系统（如安卓的Termux）等。
- 支持 OpenWrt UCI。
- 一键登录/注销。
- 日志输出。

### 与原版的不同点
- 为Iproute2提供支持。
- 新增初始化文件 (esfshellrc.sh) 功能。
- 缓存上次登陆数据功能。
- 更好的日志输出机制。
- 默认使用小米Captive Portal 204服务器检测网络连接状态。
- 将大部分公共变量从非主函数中移除，使用参数来传递信息。
- 多语言系统，为不支持中文的环境（如TTY）提供支持。
- 使用-v开关来控制日志输出的详细度。
- 因本校没有Portal认证页。所以已将相关代码移除。
- OpenWrt UCI 支持。

## 运行环境
### 终端
- 对于Linux/Mac系统可以直接运行。
- 对于Windows系统可以安装 MSYS，可以在MSYS提供的Bash中运行。关于获取IP与MAC地址的问题详见该[初始化文件范例](/sample/windows-net-tools/esfshellrc.sh)。

### 工具包
- curl: 用于HTTP请求。（必装）
- cron(crond): 用于自动执行计划任务，OpenWrt自带cron，其他系统可以测试一下。（可选）

## 快速安装
### Arch Linux/Windows MSYS（请注意阅读下方注释）
```Shell
sudo pacman -Su bash curl && sudo sh -c "$(curl -fsSL https://fastly.jsdelivr.net/gh/SummonHIM/EsurfingShell@master/install/linux.sh)"
```

### Ubuntu/Android Termux（请注意阅读下方注释）
```Shell
sudo apt update && sudo apt install bash curl && sudo sh -c "$(curl -fsSL https://fastly.jsdelivr.net/gh/SummonHIM/EsurfingShell@master/install/linux.sh)"
```

### OpenWrt
敬请期待

> - 以上命令将一键安装Bash和curl并下载本仓库的esfshell.sh文件至`/usr/bin`，最后赋予执行权限。
> - 其他Unix系系统也大同小异，只需要修改以上命令为系统常用的包管理器即可。
> - 在Windows MSYS和Android Termux中不需要使用sudo来获取管理员权限。可提前定义变量`_ES_SKIP`为`true`来跳过Root检查。
> - Android Termux需要修改`/usr/bin`文件夹为`/data/data/com.termux/files/usr/bin`。即：
> ```Shell
> _ES_INSTALL_ESFSHELL_LOC="/data/data/com.termux/files/usr/bin" _ES_SKIP=true sh -c "$(curl -fsSL https://fastly.jsdelivr.net/gh/SummonHIM/EsurfingShell@master/install/linux.sh)"
> ```

## 如何使用？
```
用法：esfshell <操作> [选项] [...]
操作：
   esfshell {-L --login}		登陆到校园网
   esfshell {-O --logout}		注销校园网
   esfshell {-D --daemon}		监控模式
   esfshell {-C --custom} <函数名>	调用自定义函数
   esfshell {-h --help}			显示本帮助
选项：
   -a, --account <账号>		账号
   -p, --password <密码>	密码
   -d, --device <网口>		指定网口
   -f, --force			强制操作
   -v, --verbose		显示详细信息
       --home <主目录>		指定主目录
```

### 手把手教你最简单的登陆
```Shell
esfshell -L -a 123456 -p 654321
```

### 手把手教你最简单的注销
```Shell
esfshell -O
```

### 修改初始化文件的主目录
可在执行脚本前提前定义好`_ES_HOMEPATH`变量来修改本脚本的运行主目录。
```
> _ES_HOMEPATH="$HOME/.config/esfshell2" ./esfshell.sh -L -v
```

### 作为系统服务监控网络
> 注：以下服务文件默认使用`/etc/esfshell`作为主目录
#### Linux systemd
[范例文件](/sample/linux-systemd/esfshell.service) | [多网卡范例文件](/sample/linux-systemd/esfshell@.service)

> 注意：需要提前在初始化文件中定义用户名和密码才能正常使用。

将范例文件下载至`/etc/systemd/system/`或`~/.config/systemd/user/`（作为用户服务）文件夹后，修改文件内的路径即可。

可使用`esfshell@网卡名称`来自定义默认网卡。详细信息可参阅[多网卡范例文件](/sample/linux-systemd/esfshell@.service)源代码。

#### OpenWrt init.d
[范例文件](/sample/openwrt-etc/init.d/esfshell)

> 注意：需要提前在初始化文件中定义用户名和密码才能正常使用。
>
> [OpenWrt服务使用教程（英文）](https://openwrt.org/docs/guide-user/base-system/managing_services) | [OpenWrt日志查看教程（英文）](https://openwrt.org/docs/guide-user/base-system/log.essentials)

将范例文件下载至`/etc/init.d`文件夹后，修改文件内的路径即可。

可在`/etc/esfshell`中新建名为网卡名称的文件夹来自定义默认网卡。若`/etc/esfshell`中没有文件夹则使用`/etc/esfshell`作为主目录。

## 初始化文件
初始化文件能在不修改脚本的前提下为脚本新增/修改功能、函数以及变量。其定位与Bash中的`.bashrc`一致。

脚本将在执行函数前读取位于`~/.config/esfshell/esfshellrc.sh`中的初始化文件。你可以将你的自定义功能、函数以及变量提前写入初始化文件中。

### 用一段Bash命令来诠释初始化文件的作用
```Shell
> cat ~/.config/esfshell/esfshellrc.sh
_ES_ACC_USERNAME="123456"
_ES_ACC_PASSWD="987654"

login() {
    printl Info "Hello! My password is: $_ES_ACC_PASSWD"
}
> esfshell -L
2023-04-24 20:58:14 [Info]: Hello! My password is: 987654
```
由以上代码可看出：初始化文件为用户名和密码变量赋上了值。并覆盖了login()函数。当你使用-L参数执行登陆函数时，优先读取初始化文件中的账号密码并执行了初始化文件中的login()函数。

### 脚本变量解释

可随时使用初始化文件为本脚本变量赋值。
```Shell
_ES_ACC_USERNAME=登录用户名
_ES_ACC_PASSWD=登录密码
_ES_GLOBAL_DEVICE=指定网卡

_ES_HOMEPATH=主目录路径，用于存储初始化文件、登录缓存和运行日志
_ES_LANG=强制使用指定语言

_ES_FORCE=启用强制登陆。需要提前指定 $_ES_NC_URLLOCATION 变量
_ES_VERBOSE=显示详细信息

_ES_DAEMON_SLEEPTIME=监听模式执行间隔（单位详见sleep --help）

_ES_LOG_ENABLE=是否启用日志。布尔值，默认False
_ES_LOG_PATH=日志路径。默认"$_ES_HOMEPATH/esfshell.log"
_ES_LOG_MAXSIZE=日志最大大小，超出后将移除旧日志
_ES_LOG_TAILLINE=超出日志大小后裁剪保留的行数
_ES_LOG_TIMESTAMP=日志内容时间戳，默认"+%Y-%m-%d %H:%M:%S"

# 如有特殊需要，否则最好不要编辑以下内容
_ES_GLOBAL_ISWIFI="4060"
_ES_GLOBAL_SECRET="Eshore!@#"
_ES_GLOBAL_VERSION="214"
_ES_GLOBAL_USERAGENT="User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/86.0.4240.198 Safari/537.36"
_ES_GLOBAL_URL="http://enet.10000.gd.cn:10001" # 一般会自动获取，如需修改可提前定义
_ES_GLOBAL_URL_QUERYSCHOOL="/client/queryschool"
_ES_GLOBAL_URL_AD="/advertisement.do"
_ES_GLOBAL_URL_VCHALLENGE="/client/vchallenge"
_ES_GLOBAL_URL_LOGIN="/client/login"
_ES_GLOBAL_URL_LOGOUT="/client/logout"
# 如有特殊需要，否则最好不要编辑以上内容

# 以下内容一般都是自动获取的。可以不用编辑
_ES_CONFIG_COOKIE=登录/注销Cookie
_ES_CONFIG_VERIFYCODE=登录验证码
_ES_CONFIG_MAC=登录/注销客户端MAC
_ES_CONFIG_CLIENTIP=登录/注销客户端IP
_ES_CONFIG_NASIP=登录/注销服务器IP
_ES_CONFIG_SCHOOLID=登录/注销学校ID

_ES_NC_URL=HTTP204验证服务器，默认"http://connect.rom.miui.com/generate_204"
_ES_REDIR_URL=网络登录跳转检测链接，用于检测是否跳转到该登录页。默认"enet.10000.gd.cn:10001"
_ES_NC_URLLOCATION=强制使用该登录链接，配合-f/--force使用
```

## 参考项目
致谢大佬们的项目
- https://github.com/OJZen/FckESC
- https://github.com/hzwjm/iNot-eclient
- https://github.com/6DDUU6/SchoolAuthentication
- https://github.com/OpenWyu/lua-esurfing-client
- https://github.com/Z446C/ESC-Z

## 开源协议
[GPL-3.0](/LICENSE)

### 声明
严格遵守GPL-3.0开源协议，禁止任何个人或者公司将本代码投入商业使用，由此造成的后果和法律责任均与本人无关。

本项目只适用于学习交流，请勿商用！
