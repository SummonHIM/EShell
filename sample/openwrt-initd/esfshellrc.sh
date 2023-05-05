# 打印日志
# Params: <Log type> <Log message>
# Return: [Log type]: Log message
printl() {
    printf "[$1] $2\n"
    if [ $_ES_LOG_ENABLE == true ]; then
        printf "[$1] $2\n" >>$_ES_LOG_PATH
    fi
}