#!/bin/bash

# Creating pihole-dot-doh service

serviceFile='pihole-dot-doh'
servicePath='/etc/s6-overlay/s6-rc.d/' #'/etc/services.d/'

fullServicePath=$servicePath$serviceFile

mkdir -p $fullServicePath

# run file
echo '#!/command/with-contenv bash' > /etc/services.d/pihole-dot-doh'/run'
# Copy config file if not exists
echo 'cp -n /temp/stubby.yml /config/' >> $fullServicePath'/run'
echo 'cp -n /temp/cloudflared.yml /config/' >> $fullServicePath'/run'
# run stubby in background
echo 's6-echo "Starting stubby"' >> $fullServicePath'/run'
echo 'stubby -g -C /config/stubby.yml' >> $fullServicePath'/run'
# run cloudflared in foreground
echo 's6-echo "Starting cloudflared"' >> $fullServicePath'/run'
echo '/usr/local/bin/cloudflared --config /config/cloudflared.yml' >> $fullServicePath'/run'

# finish file
echo '#!/command/with-contenv bash' > $fullServicePath'/finish'
echo 's6-echo "Stopping stubby"' >> $fullServicePath'/finish'
echo 'killall -9 stubby' >> $fullServicePath'/finish'
echo 's6-echo "Stopping cloudflared"' >> $fullServicePath'/finish'
echo 'killall -9 cloudflared' >> $fullServicePath'/finish'


# - !/command/with-contenv bash
# - !/usr/bin/with-contenv bash'