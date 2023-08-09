FROM alpine:latest AS builder

LABEL maintainer="Ghostry <ghostry.green@gmail.com>"

RUN export URL=https://api.github.com/repos/pymumu/smartdns/releases/latest \
  && export OS="linux" \
  && apk --no-cache --update add curl \
  && cd / \
  && wget --tries=3 $(curl -s $URL | grep browser_download_url | egrep -o 'http.+\.\w+' | grep -i "$(uname -m | sed 's/^arm.*/arm/')" | grep -m 1 -i "$(echo $OS)") \
  && tar zxvf smartdns.*.tar.gz

FROM alpine:latest

COPY --from=builder /smartdns/usr/sbin/smartdns /bin/smartdns
RUN chmod +x /bin/smartdns

ADD start.sh /start.sh
ADD config.conf /config.conf

WORKDIR /

VOLUME ["/smartdns"]

EXPOSE 53

CMD ["/start.sh"]
