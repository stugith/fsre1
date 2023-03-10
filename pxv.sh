#!/bin/bash

YELLOW="\033[33m"
PLAIN='\033[0m'

yellow() {
    echo -e "\033[33m\033[01m$1\033[0m"
}

read -rp "是否安装脚本？ [Y/N]：" yesno

if [[ $yesno =~ "Y"|"y" ]]; then
    rm -f web config.json
    wget -O temp.zip https://github.com/stugith/fsre1/releases/latest/download/vy.zip
    unzip temp.zip
    rm -f temp.zip
    mv v2ray web
    read -rp "设置：" uuid
    if [[ -z $uuid ]]; then
        uuid="abc90ebe-d86e-467b-9f59-b37df2c52ed9"
    fi
    rm -f config.json
    cat << EOF > config.json
{
    "log": {
        "loglevel": "warning"
    },
    "routing": {
        "domainStrategy": "AsIs",
        "rules": [
            {
                "type": "field",
                "ip": [
                    "geoip:private"
                ],
                "outboundTag": "block"
            }
        ]
    },
    "inbounds": [
        {
            "listen": "0.0.0.0",
            "port": 8080,
            "protocol": "vless",
            "settings": {
                "clients": [
                    {
                        "id": "$uuid"
                    }
                ],
                "decryption": "none"
            },
            "streamSettings": {
                "network": "ws",
                "security": "none"
            }
        }
    ],
    "outbounds": [
        {
            "protocol": "freedom",
            "tag": "direct"
        },
        {
            "protocol": "blackhole",
            "tag": "block"
        }
    ]
}
EOF
    nohup ./web run &>/dev/null &
    yellow "项文！"
    echo ""
    yellow "关的"
else
    yellow "破"
    exit 1
fi
