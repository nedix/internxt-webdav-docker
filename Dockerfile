ARG ALPINE_VERSION=3.20
ARG MITMPROXY_VERSION=10.4.2
ARG NODE_VERSION=20.17.0
ARG PYTHON_VERSION=3.12

FROM node:${NODE_VERSION}-alpine${ALPINE_VERSION} AS node

FROM python:${PYTHON_VERSION}-alpine${ALPINE_VERSION}

COPY --from=node /usr/local/lib/node_modules/ /usr/local/lib/node_modules/
COPY --from=node /usr/local/bin/node /usr/local/bin/

RUN ln -s /usr/local/lib/node_modules/npm/bin/npm-cli.js /usr/local/bin/npm
RUN ln -s /usr/local/lib/node_modules/npm/bin/npx-cli.js /usr/local/bin/npx

RUN apk add --virtual .build-deps \
        bsd-compat-headers \
        build-base \
        curl \
        openssl-dev \
    && apk add \
        iptables \
        libstdc++ \
        nftables \
    && echo "http://dl-cdn.alpinelinux.org/alpine/edge/main" >> /etc/apk/repositories \
    && echo "http://dl-cdn.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories \
    && echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories \
    && apk add \
        s6-overlay \
        skalibs-dev \
    && npm install -g \
        @internxt/cli

ARG MITMPROXY_VERSION

RUN curl -fsSL https://sh.rustup.rs \
    | sh -s -- --profile minimal --default-toolchain stable -y \
    && source ~/.cargo/env \
    && pip install --upgrade pip \
    && pip install \
        --ignore-installed \
        mitmproxy=="$MITMPROXY_VERSION"

RUN apk del .build-deps

COPY /rootfs/ /

ENTRYPOINT ["/entrypoint.sh"]

# Webdav
EXPOSE 80/tcp

HEALTHCHECK CMD nc -z 127.0.0.1 80
