#FROM --platform=$BUILDPLATFORM alpine:edge

FROM alpine:edge
ARG BUILDPLATFORM
ARG TARGETARCH

ADD download.sh /tmp
RUN /tmp/download.sh && \
    apk update && \
    apk upgrade && \
    apk add android-tools --update-cache --repository http://dl-3.alpinelinux.org/alpine/edge/testing/ --allow-untrusted && \
    tar xzf /tmp/s6overlay.tar.gz -C / && \
    rm /tmp/s6overlay.tar.gz

COPY services.d/ /etc/services.d/

RUN mkdir /data
RUN ln -s /data /root/.android

VOLUME ["/data"]

ENV ADB_SERVER_PORT 5037
ENV ADB_DEVICES ""

ENTRYPOINT ["/init"]
