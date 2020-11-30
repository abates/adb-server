FROM alpine:3.12 AS builder
ARG PKGNAME="android-tools"
ARG PKGVER="29.0.6"

RUN apk update && \
    apk upgrade && \
    apk add build-base pcre2-dev linux-headers libusb-dev gtest-dev go perl cmake

WORKDIR /tmp
RUN wget https://github.com/nmeum/$PKGNAME/releases/download/$PKGVER/$PKGNAME-$PKGVER.tar.xz && \
    tar -xf /tmp/$PKGNAME-$PKGVER.tar.xz && \
    mkdir  /tmp/$PKGNAME-$PKGVER/build

WORKDIR /tmp/$PKGNAME-$PKGVER/build
RUN cmake -DCMAKE_INSTALL_PREFIX=/usr .. && \
    make && \
    make install

FROM alpine:3.12
ARG BUILDPLATFORM
ARG TARGETARCH

ADD download.sh /tmp
RUN apk update && \
    apk upgrade && \
    /tmp/download.sh && \
    tar xzf /tmp/s6overlay.tar.gz -C / && \
    rm /tmp/s6overlay.tar.gz

COPY root/ /
COPY --from=builder /usr/bin/adb /usr/bin
COPY --from=builder /usr/bin/fastboot /usr/bin
COPY --from=builder /usr/bin/mke2fs.android /usr/bin
COPY --from=builder /usr/bin/simg2img /usr/bin
COPY --from=builder /usr/bin/img2simg /usr/bin
COPY --from=builder /usr/bin/append2simg /usr/bin

RUN mkdir /data
RUN ln -s /data /root/.android

VOLUME ["/data"]

ENV ADB_SERVER_PORT 5037
ENV ADB_DEVICES ""

ENTRYPOINT ["/init"]
