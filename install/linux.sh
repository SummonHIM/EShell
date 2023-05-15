[ -z $_ES_INSTALL_URL ] && _ES_INSTALL_URL="https://cdn.jsdelivr.net/gh/SummonHIM/EsurfingShell@master"
[ -z $_ES_INSTALL_ESFSHELL ] && _ES_INSTALL_ESFSHELL="esfshell"
[ -z $_ES_INSTALL_ESFSHELL_LOC ] && _ES_INSTALL_ESFSHELL_LOC="/usr/bin"
[ -z $_ES_INSTALL_SYSTEMD ] && _ES_INSTALL_SYSTEMD="esfshell.service"
[ -z $_ES_INSTALL_SYSTEMD_AT ] && _ES_INSTALL_SYSTEMD_AT="esfshell@.service"
[ -z $_ES_INSTALL_SYSTEMD_LOC ] && _ES_INSTALL_SYSTEMD_LOC="/etc/systemd/system"
[ -z $_ES_INSTALL_INITD ] && _ES_INSTALL_INITD="esfshell"
[ -z $_ES_INSTALL_INITD_LOC ] && _ES_INSTALL_INITD_LOC="/etc/init.d"

_exists() {
    local cmd="$1"
    if [ -z "$cmd" ]; then
        echo "Usage: _exists cmd"
        return 1
    fi
    if type command >/dev/null 2>&1; then
        command -v $cmd >/dev/null 2>&1
    else
        type $cmd >/dev/null 2>&1
    fi
    local ret="$?"
    return $ret
}

if [[ $(id -u) != 0 ]]; then
    echo Please run this script as root.
    exit 1
fi

_get=""
if _exists curl; then
    _get="curl -L"
elif _exists wget; then
    _get="wget -O -"
else
    echo "Sorry, you must have curl or wget installed first."
    echo "Please install either of them and try again."
    exit 1
fi

# Install esfshell into $_ES_INSTALL_ESFSHELL_LOC
echo "Downloading $_ES_INSTALL_URL/$_ES_INSTALL_ESFSHELL.sh into $_ES_INSTALL_ESFSHELL_LOC/$_ES_INSTALL_ESFSHELL..."
if ! $_get "$_ES_INSTALL_URL/$_ES_INSTALL_ESFSHELL.sh" -o "$_ES_INSTALL_ESFSHELL_LOC/$_ES_INSTALL_ESFSHELL"; then
    echo "Download error."
fi

if [ -d "$_ES_INSTALL_SYSTEMD_LOC" ]; then
    echo "Downloading systemd service..."
    echo "Downloading $_ES_INSTALL_URL/sample/linux-systemd/$_ES_INSTALL_SYSTEMD into $_ES_INSTALL_SYSTEMD_LOC/$_ES_INSTALL_SYSTEMD..."
    if ! $_get "$_ES_INSTALL_URL/sample/linux-systemd/$_ES_INSTALL_SYSTEMD" -o "$_ES_INSTALL_SYSTEMD_LOC/$_ES_INSTALL_SYSTEMD"; then
        echo "Download error."
    fi
    echo "Downloading $_ES_INSTALL_URL/sample/linux-systemd/$_ES_INSTALL_SYSTEMD_AT into $_ES_INSTALL_SYSTEMD_LOC/$_ES_INSTALL_SYSTEMD_AT..."
    if ! $_get "$_ES_INSTALL_URL/sample/linux-systemd/$_ES_INSTALL_SYSTEMD_AT" -o "$_ES_INSTALL_SYSTEMD_LOC/$_ES_INSTALL_SYSTEMD_AT"; then
        echo "Download error."
    fi
elif [ -d "$_ES_INSTALL_INITD_LOC" ]; then
    echo "Downloading init.d service..."
    echo "Downloading $_ES_INSTALL_URL/sample/linux-systemd/$_ES_INSTALL_INITD into $_ES_INSTALL_INITD_LOC/$_ES_INSTALL_INITD..."
    if ! $_get "$_ES_INSTALL_URL/sample/linux-systemd/$_ES_INSTALL_INITD" -o "$_ES_INSTALL_INITD_LOC/$_ES_INSTALL_INITD"; then
        echo "Download error."
    fi
else
    echo "Systemd or init.d not found. Skip service installation."
fi
