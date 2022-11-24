#!/bin/bash

# Creating pihole-dot-doh service

serviceFileStubby='pihole-dot-doh-stubby'
serviceFileCloudfared='pihole-dot-doh-cloudf'
servicePath='/etc/s6-overlay/s6-rc.d/' #'/etc/services.d/'

fullServicePathStubby=$servicePath$serviceFileStubby
fullServicePathCloudfared=$servicePath$serviceFileCloudfared

mkdir -p $fullServicePathStubby
mkdir -p $fullServicePathCloudfared

#Stubby
# run file
echo '#!/command/with-contenv bash' > $fullServicePathStubby'/run'
# Copy config file if not exists
echo 'cp -n /temp/stubby.yml /config/' >> $fullServicePathStubby'/run'
# run stubby in background
echo 's6-echo "Starting stubby"' >> $fullServicePathStubby'/run'
echo '/opt/stubby -g -C /config/stubby.yml' >> $fullServicePathStubby'/run'

# finish file
echo '#!/command/with-contenv bash' > $fullServicePathStubby'/finish'
echo 's6-echo "Stopping stubby"' >> $fullServicePathStubby'/finish'
echo 'killall -9 stubby' >> $fullServicePathStubby'/finish'

#type file
echo 'longrun' >> $fullServicePathStubby'/type'

#CLOUDFARED
# run file
echo '#!/command/with-contenv bash' > $fullServicePathCloudfared'/run'
# Copy config file if not exists
echo 'cp -n /temp/cloudflared.yml /config/' >> $fullServicePathCloudfared'/run'
# run cloudflared in foreground
echo 's6-echo "Starting cloudflared"' >> $fullServicePathCloudfared'/run'
echo '/usr/local/bin/cloudflared --config /config/cloudflared.yml' >> $fullServicePathCloudfared'/run'

# finish file
echo '#!/command/with-contenv bash' > $fullServicePathCloudfared'/finish'
echo 's6-echo "Stopping cloudflared"' >> $fullServicePathCloudfared'/finish'
echo 'killall -9 cloudflared' >> $fullServicePathCloudfared'/finish'

#type file
echo 'longrun' >> $fullServicePathCloudfared'/type'

#contents file 
echo '' >> $servicePath'user/contents.d/'$serviceFileCloudfared
echo '' >> $servicePath'user/contents.d/'$serviceFileStubby

# - !/command/with-contenv bash
# - !/usr/bin/with-contenv bash'