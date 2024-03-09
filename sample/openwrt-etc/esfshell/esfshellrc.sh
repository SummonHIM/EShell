#!/bin/bash
# 打印日志
# Params: <Log type> <Log message>
# Return: [Log type]: Log message
printl() {
    printf "[%s] %s\n" "$1" "$2"
    if [ "$_ES_LOG_ENABLE" == true ]; then
        printf "[%s] %s\n" "$1" "$2" >>"$_ES_LOG_PATH"
    fi
}

before_login() {
    if [ -n "$_ES_OPENWRT_DEVICE_ALIAS" ]; then
        printl Info "Tring ifup $_ES_OPENWRT_DEVICE_ALIAS..."
        ifup "$_ES_OPENWRT_DEVICE_ALIAS"
    fi
}
