FROM alpine:edge

RUN apk update \
  && apk upgrade \
  && apk add android-tools --update-cache --repository http://dl-3.alpinelinux.org/alpine/edge/testing/ --allow-untrusted

COPY entrypoint.sh /usr/bin
RUN mkdir /data
RUN ln -s /data /root/.android

VOLUME ["/data"]

CMD entrypoint.sh
