# ARG FRM='testdasi/pihole-base-buster-plus'
ARG FRM='pihole/pihole'
ARG TAG='latest'

FROM ${FRM}:${TAG}
ARG FRM
ARG TAG
ARG TARGETPLATFORM

ADD stuff /temp

RUN /bin/bash /temp/install.sh \
    && rm -f /temp/install.sh

RUN /bin/bash /temp/install_configs.sh \
    && rm -f /temp/install_configs.sh

VOLUME ["/config"]

RUN echo "$(date "+%d.%m.%Y %T") Built from ${FRM} with tag ${TAG}" >> /build_date.info
