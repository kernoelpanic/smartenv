# Dockerfile for smart contract development
# with web3 for python 3.7 on Ubuntu

# Overview of ubuntu docker images
#https://hub.docker.com/_/ubuntu
#FROM ubuntu:eoan
FROM ubuntu:focal

# Add a user given as build argument
ARG UNAME=smartenv
ARG UID=1000
ARG GID=1000
ARG WORKDIR_CONTAINER=/smartenv
ARG SETUPDIR=./setup/environment
WORKDIR $WORKDIR_CONTAINER

RUN groupadd -g $GID -o $UNAME
RUN useradd -m -u $UID -g $GID -o -s /bin/bash $UNAME

# update and upgrade
RUN apt-get update 
RUN apt-get dist-upgrade -y

# Configure timezone 
ENV TZ=Europe/Berlin
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Required system tools 
RUN apt-get install -y git wget curl
# Additional system tools 
RUN apt-get install -y vim iputils-ping netcat iproute2 sudo

# Install node.js binary distribution according to:
# https://deb.nodesource.com
RUN curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -
RUN apt-get install -y nodejs

# get recent solc versions for testing
# https://github.com/ethereum/solidity/releases/
RUN cd /usr/local/bin \
  && wget -qO solc https://github.com/ethereum/solidity/releases/download/v0.4.25/solc-static-linux \
  && wget -qO solc_5.4 https://github.com/ethereum/solidity/releases/download/v0.5.4/solc-static-linux \
	&& wget -qO solc_7.4 https://github.com/ethereum/solidity/releases/download/v0.7.4/solc-static-linux \
	&& wget -qO solc_8.4 https://github.com/ethereum/solidity/releases/download/v0.8.4/solc-static-linux \
  && cp solc_8.4 solc \
  && chmod 755 solc*

# get current geth version from here for debug tools etc (not mandatory):
# https://geth.ethereum.org/downloads/#dl_stable_linux
# https://gethstore.blob.core.windows.net/builds/geth-alltools-linux-amd64-1.10.3-991384a7.tar.gz
# https://gethstore.blob.core.windows.net/builds/geth-alltools-linux-amd64-1.9.23-8c2f2715.tar.gz
RUN mkdir -p /tmp/gethtools \
	&& cd /tmp/gethtools \
  && wget -q https://gethstore.blob.core.windows.net/builds/geth-alltools-linux-amd64-1.10.3-991384a7.tar.gz \
  && tar --strip-components=1 -xzf /tmp/gethtools/*.tar.gz \
  && cp /tmp/gethtools/* /usr/local/bin

# change final user
USER $UNAME

# Run jupyter per default:
CMD ["node"]
#ENTRYPOINT ["/smartenv/entrypoint.sh"]

