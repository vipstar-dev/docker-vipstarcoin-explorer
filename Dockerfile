FROM node:8.12.0-stretch
#FROM fkfk/node:xenial-9.3.0

# install dependency package
RUN set -x \
 && apt-get update \
 && apt-get install -y libzmq3-dev \
                       git \
                       python \
                       build-essential

# install s6-overlay
ADD https://github.com/just-containers/s6-overlay/releases/download/v1.21.7.0/s6-overlay-amd64.tar.gz /tmp/
RUN tar xzf /tmp/s6-overlay-amd64.tar.gz -C / \
 && rm /tmp/s6-overlay-amd64.tar.gz

# install vipstarcoin-explorer
RUN npm install --unsafe-perm -g https://github.com/fkfk/vipstarcoincore-node/tarball/065739d \
 && /usr/local/lib/node_modules/vipstarcoincore-node/scripts/download \
 && rm /usr/local/lib/node_modules/vipstarcoincore-node/bin/VIPSTARCOIN-1.0.0-beta-linux64.tar.gz
COPY 01-coind-data-dir /etc/fix-attrs.d/01-coind-data-dir

WORKDIR /root
RUN vipstarcoincore-node create explorer

WORKDIR /root/explorer
RUN vipstarcoincore-node install https://github.com/fkfk/vipstarcoin-api/tarball/82db698
RUN vipstarcoincore-node install https://github.com/fkfk/vipstarcoin-explorer/tarball/d3ab20a

COPY vipstarcoincore-node.json /root/explorer/vipstarcoincore-node.json
COPY VIPSTARCOIN.conf /root/explorer/VIPSTARCOIN.conf

VOLUME /root/explorer/data
EXPOSE 3001 31915

ENTRYPOINT ["/init"]
CMD ["/usr/local/lib/node_modules/vipstarcoincore-node/bin/vipstarcoincore-node", "start"]
