FROM alpine:latest

EXPOSE 443 80

RUN apk --no-cache add curl tar \
    && curl -o /tmp/shadowsocks.tar.xz -L "https://github.com/shadowsocks/shadowsocks-rust/releases/download/v1.15.3/shadowsocks-v1.15.3.x86_64-unknown-linux-gnu.tar.xz" \
    && tar -xf /tmp/shadowsocks.tar.xz -C /usr/local/bin --strip-components=1 \
    && curl -o /tmp/v2ray.tar.gz -L "https://github.com/shadowsocks/v2ray-plugin/releases/download/v1.3.2/v2ray-plugin-linux-amd64-v1.3.2.tar.gz" \
    && tar -xf /tmp/v2ray.tar.gz -C /usr/local/bin --strip-components=1 --transform 's|.*/|v2ray-plugin/|' \
    && chmod +x /usr/local/bin/ssserver /usr/local/bin/v2ray-plugin \
    && apk del curl tar \
    && rm -rf /tmp/shadowsocks.tar.xz /tmp/v2ray.tar.gz

ENV USER_PASSWORD=12345678

RUN adduser -D -u 1000 doby \
    && echo "doby:${USER_PASSWORD}" | chpasswd

WORKDIR /etc/shadowsocks

RUN echo -e "{\n    \"server\": \"\$(hostname -i)\",\n    \"server_port\": 80,\n    \"password\": \"\",\n    \"timeout\": 60,\n    \"method\": \"chacha20-ietf-poly1305\",\n    \"fast_open\": true,\n    \"plugin\": \"v2ray-plugin\",\n    \"plugin_opts\": \"server\"\n}" > config.json

USER doby

CMD ["sh", "-c", "echo 'Enter new password for Shadowsocks:'; read -s PASSWORD; sed -i \"s/\"password\": \"\"/\"password\": \"$PASSWORD\"/\" /etc/shadowsocks/config.json; /usr/local/bin/ssserver -c /etc/shadowsocks/config.json"]
