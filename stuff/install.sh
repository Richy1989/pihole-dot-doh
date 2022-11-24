#!/bin/bash



# install basic packages
apt-get -y update \
    && apt-get -y dist-upgrade \
    && apt-get -y install sudo bash nano curl git 
    
# install stubby
#apt-get -y update \
#    && apt-get -y install stubby


git clone https://github.com/getdnsapi/stubby.git
cd stubby
cmake .
make

# clean stubby config
mkdir -p /etc/stubby \
    && rm -f /etc/stubby/stubby.yml

# install cloudflared
mkdir -p /tmp \
    && cd /tmp

curl -sL https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64.deb -o /tmp/cloudflared.deb
    dpkg --add-architecture amd64
    echo "$(date "+%d.%m.%Y %T") Added cloudflared for ${TARGETPLATFORM}" >> /build.info
    
#apt install /tmp/cloudflared.deb \
dpkg -i /tmp/cloudflared.deb \
    && rm -f /tmp/cloudflared.deb \
    && useradd -s /usr/sbin/nologin -r -M cloudflared \
    && chown cloudflared:cloudflared /usr/local/bin/cloudflared

# clean cloudflared config
mkdir -p /etc/cloudflared \
    && rm -f /etc/cloudflared/config.yml

# clean up
apt-get -y autoremove \
    && apt-get -y autoclean \
    && apt-get -y clean \
    && rm -fr /tmp/* /var/tmp/* /var/lib/apt/lists/*
