# EShell
基于Bash Shell的天翼校园登录脚本

## 脚本说明
- 使用Bash Shell轻量脚本，兼容大部分系统。
- 支持Linux、MacOS（未测试）、Windows以及其他支持Shell的系统（如安卓的Termux）等。
- 一键登录/注销。
- 日志输出。

### 与原版的不同点
- 为Iproute2提供支持。
- 新增初始化文件 (eshellrc.sh) 功能。
- 缓存上次登陆数据功能。
- 更好的日志输出机制。
- 默认使用小米Captive Portal 204服务器检测网络连接状态。
- 将大部分公共变量从非主函数中移除，使用参数来传递信息。
- 多语言系统，为不支持中文的环境（如TTY）提供支持。
- 使用-v开关来控制日志输出的详细度。
- 因本校没有Portal认证页。所以已将相关代码移除。

## 运行环境
### 终端
- 对于Linux/Mac系统可以直接运行。
- 对于Windows系统可以安装 MSYS，可以在MSYS提供的Bash中运行。关于获取IP与MAC地址的问题详见该[初始化文件范例](/sample/windows-ipconfig/eshellrc.sh)。

### 工具包
- curl: 用于HTTP请求。（必装）
- cron(crond): 用于自动执行计划任务，OpenWrt自带cron，其他系统可以测试一下。（可选）

## 快速安装
### Arch Linux/Windows MSYS（请注意阅读下方注释）
```Shell
sudo pacman -S curl && sudo curl -L "https://github.com/SummonHIM/EShell/raw/master/eshell.sh" -o "/usr/local/bin/eshell" && sudo chmod +x "/usr/local/bin/eshell"
```

### Ubuntu/Android Termux（请注意阅读下方注释）
```Shell
sudo apt update && sudo apt install curl && curl -L "https://github.com/SummonHIM/EShell/raw/master/eshell.sh" -o "/usr/local/bin/eshell" && chmod +x "/usr/local/bin/eshell"
```

### OpenWrt
```Shell
opkg update && opkg install curl && curl -L "https://github.com/SummonHIM/EShell/raw/master/eshell.sh" -o "/usr/local/bin/eshell" && chmod +x "/usr/local/bin/eshell"
```

> 以上命令将一键安装CUrl并下载本仓库的eshell.sh文件至`/bin/eshell`，最后赋予执行权限。
> 
> 其他Unix系系统也大同小异，只需要把opkg修改为系统常用的包管理器即可。
> 
> 在Windows MSYS和Android Termux中不需要使用sudo来获取管理员权限。Android Termux需要修改`/usr/local/bin/`文件夹为`/data/data/com.termux/files/usr/bin/`。

## 如何使用？
```
用法：eshell <操作> [选项] [...]"
操作：
   eshell {-L --login}	登陆到校园网
   eshell {-O --logout}	注销校园网
   eshell {-D --daemon}	监控模式
   eshell {-C --custom}	调用自定义函数
   eshell {-h --help}	显示本帮助
选项：
   -a, --account	账号
   -p, --password	密码
   -d, --device		指定网口
   -v, --verbose	显示详细信息
```

### 手把手教你最简单的登陆
```Shell
eshell -L -a 123456 -p 654321
```

### 手把手教你最简单的注销
```Shell
eshell -O
```

### 修改初始化文件的主目录
可在执行脚本前提前定义好`_ES_HOMEPATH`变量来修改本脚本的运行主目录。
```
> _ES_HOMEPATH="$HOME/.config/eshell2" ./eshell.sh -L -v
```

## 初始化文件
初始化文件能在不修改脚本的前提下为脚本新增/修改功能、函数以及变量。其定位与Bash中的`.bashrc`一致。

脚本将在执行函数前读取位于`~/.config/eshell/eshellrc.sh`中的初始化文件。你可以将你的自定义功能、函数以及变量提前写入初始化文件中。

### 用一段Bash命令来诠释初始化文件的作用
```
> cat ~/.config/eshell/eshellrc.sh
_ES_ACC_USERNAME="123456"
_ES_ACC_PASSWD="987654"

login() {
    printl Info "Hello! My password is: $_ES_ACC_PASSWD"
}
> eshell -L
2023-04-24 20:58:14 [Info]: Hello! My password is: 987654
```
由以上代码可看出：初始化文件为用户名和密码变量赋上了值。并覆盖了login()函数。当你使用-L参数执行登陆函数时，优先读取初始化文件中的账号密码并执行了初始化文件中的login()函数。

## 参考项目
致谢大佬们的项目
- https://github.com/OJZen/FckESC
- https://github.com/hzwjm/iNot-eclient
- https://github.com/6DDUU6/SchoolAuthentication
- https://github.com/OpenWyu/lua-esurfing-client
- https://github.com/Z446C/ESC-Z


## 开源协议
[GPL-3.0](https://github.com/Z446C/ESC-Z/blob/main/LICENSE)

### 声明
严格遵守GPL-3.0开源协议，禁止任何个人或者公司将本代码投入商业使用，由此造成的后果和法律责任均与本人无关。

本项目只适用于学习交流，请勿商用！
