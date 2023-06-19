FROM alpine

# Установка пакетов wget и tar
RUN apk update && apk add --no-cache wget tar

# Создание пользователя doby
RUN adduser -D -u 1000 doby

# Установка Shadowsocks и V2Ray
RUN wget -O /tmp/shadowsocks.tar.xz "https://github.com/shadowsocks/shadowsocks-rust/releases/download/v1.15.3/shadowsocks-v1.15.3.x86_64-unknown-linux-gnu.tar.xz" \
    && tar -xf /tmp/shadowsocks.tar.xz -C /bin --strip-components=1 \
    && wget -O /tmp/v2ray.tar.gz "https://github.com/shadowsocks/v2ray-plugin/releases/download/v1.3.2/v2ray-plugin-linux-amd64-v1.3.2.tar.gz" \
    && tar -xf /tmp/v2ray.tar.gz -C /bin --strip-components=1 --transform 's|.*/|v2ray-plugin/|'

# Удаление загруженных архивов
RUN rm /tmp/shadowsocks.tar.xz /tmp/v2ray.tar.gz

# Установка прав доступа
RUN chmod +x /bin/ssserver /bin/v2ray-plugin

USER doby

CMD ["/bin/ssserver", "-c", "/etc/shadowsocks/config.json"]

FROM alpine:latest

RUN apk --no-cache add curl wget

# Проверка доступности хоста и загрузка файла с использованием curl
RUN curl -I https://github.com/shadowsocks/shadowsocks-rust/releases/download/v1.15.3/shadowsocks-v1.15.3.x86_64-unknown-linux-gnu.tar.xz

# Проверка доступности хоста и загрузка файла с использованием wget
RUN wget hhttps://github.com/shadowsocks/shadowsocks-rust/releases/download/v1.15.3/shadowsocks-v1.15.3.x86_64-unknown-linux-gnu.tar.xz
