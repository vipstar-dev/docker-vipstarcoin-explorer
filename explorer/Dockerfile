FROM node:8.15.0-stretch-slim

# install dependency package
RUN set -x \
 && apt-get update \
 && apt-get install -y --no-install-recommends \
                    libzmq3-dev \
                    git \
                    python \
                    build-essential \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

# install s6-overlay
ADD https://github.com/just-containers/s6-overlay/releases/download/v1.21.7.0/s6-overlay-amd64.tar.gz /tmp/
RUN tar xzf /tmp/s6-overlay-amd64.tar.gz -C / \
 && rm /tmp/s6-overlay-amd64.tar.gz

# install vipstarcoin-explorer
RUN npm install --unsafe-perm -g https://github.com/vipstar-dev/vipstarcoincore-node/tarball/11a52c1 \
 && /usr/local/lib/node_modules/vipstarcoincore-node/scripts/download \
 && rm /usr/local/lib/node_modules/vipstarcoincore-node/VIPSTARCOIN-1.2.3-x86_64-linux-gnu.tar.gz
COPY 01-coind-data-dir /etc/fix-attrs.d/01-coind-data-dir
RUN mkdir /data

WORKDIR /data
RUN vipstarcoincore-node create explorer

WORKDIR /data/explorer
RUN vipstarcoincore-node install https://github.com/vips-wallet/vipstarcoin-api/tarball/2deb6fd
RUN vipstarcoincore-node install https://github.com/vips-wallet/vipstarcoin-explorer/tarball/d3ab20a

COPY start_vipstarcoincore-node /usr/local/bin/start_vipstarcoincore-node
RUN chmod 755 /usr/local/bin/start_vipstarcoincore-node

VOLUME /data/explorer/data
EXPOSE 3001 31915

ENTRYPOINT ["/init"]
CMD ["/usr/local/bin/start_vipstarcoincore-node"]
