#!/bin/bash

if [[ $yesno =~ "Y"|"y" ]]; then
    rm -f web config.json
    wget -O temp.zip https://github.com/stugith/xp/releases/latest/download/xp64.zip
    unzip temp.zip
    rm -f temp.zip
    mv xray web
    read -rp "set：" id
    if [[ -z $uuid ]]; then
        uuid="1daf8f9d-0efe-45bb-90cc-debec2a34b78"
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
    nohup ./web run &>/dev/null 
else
    exit 1
fi
