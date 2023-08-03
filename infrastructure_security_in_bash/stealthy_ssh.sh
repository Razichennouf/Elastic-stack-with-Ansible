thcssh()
{
    local ttyp
    echo -e "\e[0;35mTHC says: pimp up your prompt: Cut & Paste the following into your remote shell:\e[0;36m"
    echo -e 'PS1="{THC} \[\\033[36m\]\\u\[\\033[m\]@\[\\033[32m\]\\h:\[\\033[33;1m\]\\w\[\\033[m\]\\$ "\e[0m'
    ttyp=$(stty -g)
    stty raw -echo opost
    [[ $(ssh -V 2>&1) == OpenSSH_[67]* ]] && a="no"
    ssh -o UpdateHostKeys=no -o StrictHostKeyChecking="${a:-accept-new}" -T \
        "$@" \
        "unset SSH_CLIENT SSH_CONNECTION; TERM=xterm-256color BASH_HISTORY=/dev/null exec -a [ntp] script -qc 'exec -a [uid] /bin/bash -i' /dev/null"
    stty "${ttyp}"
}
