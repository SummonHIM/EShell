@echo off
rem 将该文件放入系统Path中即可在终端中快速启动
rem 你可能需要将编码转换为GBK才能正常显示中文
set fileName=%0

:main
if "%*" == "" (
    call:eshellHelp
    goto exitEShell
)
if "%*" == "-h" (
    call:eshellHelp
    goto exitEShell
)
if "%*" == "--help" (
    call:eshellHelp
    goto exitEShell
) else (
    C:\路径到你的\msys2\msys2_shell.cmd -defterm -here -no-start -msys /路径到你的/eshell %*
)

:eshellHelp
echo 用法：%fileName% <操作> [选项] [...]
echo 操作：
echo    %fileName% {-L --login}登陆到校园网
echo    %fileName% {-O --logout}	注销校园网
echo    %fileName% {-D --daemon}	监控模式
echo    %fileName% {-C --custom}	调用自定义函数
echo    %fileName% {-h --help}	显示本帮助
echo 选项：
echo    -a, --account	账号
echo    -p, --password	密码
echo    -d, --device		指定网口
echo    -v, --verbose	显示详细信息

:exitEShell
