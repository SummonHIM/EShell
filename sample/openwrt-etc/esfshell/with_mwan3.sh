#!/bin/bash

# Post请求 (postReq url data cookie)
# Params: <Url> <Data> <Cookie>
# Return: <Post return string>
postReq() {
    local contentType="Content-Type: application/json"
    local accept="Accept: */*"
    mwan3 use "$_ES_OPENWRT_DEVICE_ALIAS" curl "$1" -H "$_ES_GLOBAL_USERAGENT" -H "$contentType" -H "$accept" -d "$2" --cookie "$3" -s --interface "$_ES_GLOBAL_DEVICE"
}

# 网站访问状态
# Params: <URL> <Output type>
# Return: CUrl output data
getUrlStatus() {
    if [[ "$2" == "location" ]]; then
        #获取重定向地址
        mwan3 use "$_ES_OPENWRT_DEVICE_ALIAS" curl "$1" -H "$_ES_GLOBAL_USERAGENT" -i -G -s --interface "$_ES_GLOBAL_DEVICE" | grep "Location" | awk '{print $2}' | tr -d '\r' | tr -d '\n'
    elif [[ "$2" == "code" ]]; then
        #获取状态码
        mwan3 use "$_ES_OPENWRT_DEVICE_ALIAS" curl "$1" -H "$_ES_GLOBAL_USERAGENT" -i -G -s --interface "$_ES_GLOBAL_DEVICE" | grep "HTTP" | awk '{print $2}' | tr -d '\r' | tr -d '\n'
    fi
}

# 获取Cookie
# Params: <School ID>
# Return: Cookies
getCookie() {
    mwan3 use "$_ES_OPENWRT_DEVICE_ALIAS" curl "$_ES_GLOBAL_ENET_URL$_ES_GLOBAL_ENET_URL_AD" -H "$_ES_GLOBAL_USERAGENT" -G -d "$1" -s -i --interface "$_ES_GLOBAL_DEVICE" | grep Set-Cookie | awk '{print $2,$3,$4}'
}
