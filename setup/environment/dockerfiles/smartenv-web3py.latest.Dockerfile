# Dockerfile for smart contract development
# with web3 for python 3.7 on Ubuntu

# Overview of ubuntu docker images
#https://hub.docker.com/_/ubuntu
#https://www.releases.ubuntu.com/
#FROM ubuntu:focal
FROM ubuntu:jammy

# Add a user given as build argument
ARG UNAME=smartenv
ARG UID=1000
ARG GID=1000
ARG WORKDIR_CONTAINER=/smartenv
ARG SETUPDIR=./setup/environment
WORKDIR $WORKDIR_CONTAINER
COPY "$SETUPDIR""$WORKDIR_CONTAINER"-web3py.requirements.txt "$WORKDIR_CONTAINER"/requirements.txt
RUN groupadd -g $GID -o $UNAME
RUN useradd -m -u $UID -g $GID -o -s /bin/bash $UNAME

# update and upgrade
RUN apt-get update 
RUN apt-get dist-upgrade -y

# Configure timezone 
ENV TZ=Europe/Berlin
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# basic python3.8 setup
# To be explicit and use pip3 to install packages  
# can be installed by invoking like this:
# python3 -m pip --version    
RUN apt-get install -y python3 python3-dev \
  && apt-get install -y python3-pip \
  && apt-get install -y python3-venv virtualenv \
  && cd /usr/local/bin \
  && ln -s /usr/bin/python3 python 

# requirements for building underlying packages when installing required python modules later 
# e.g., secp256k1 
RUN apt-get install -y build-essential pkg-config autoconf libtool libssl-dev libffi-dev libgmp-dev libsecp256k1-0 libsecp256k1-dev

# Required system tools 
RUN apt-get install -y git wget curl
# Additional system tools 
RUN apt-get install -y vim iputils-ping netcat iproute2 sudo


# get recent solc versions for testing
# https://github.com/ethereum/solidity/releases/
RUN cd /usr/local/bin \
  && wget -qO solc https://github.com/ethereum/solidity/releases/download/v0.4.25/solc-static-linux \
  && wget -qO solc_5.4 https://github.com/ethereum/solidity/releases/download/v0.5.4/solc-static-linux \
	&& wget -qO solc_7.4 https://github.com/ethereum/solidity/releases/download/v0.7.4/solc-static-linux \
	&& wget -qO solc_8.4 https://github.com/ethereum/solidity/releases/download/v0.8.4/solc-static-linux \
  && wget -qO solc_8.19 https://github.com/ethereum/solidity/releases/download/v0.8.19/solc-static-linux \
  && wget -qO solc_8.23 https://github.com/ethereum/solidity/releases/download/v0.8.23/solc-static-linux \
  && cp solc_8.23 solc \
  && chmod 755 solc*

# get current geth version from here for debug tools etc (not mandatory):
# https://geth.ethereum.org/downloads/#dl_stable_linux
# https://gethstore.blob.core.windows.net/builds/geth-alltools-linux-amd64-1.10.3-991384a7.tar.gz
# https://gethstore.blob.core.windows.net/builds/geth-alltools-linux-amd64-1.9.23-8c2f2715.tar.gz
# https://gethstore.blob.core.windows.net/builds/geth-alltools-linux-amd64-1.10.25-69568c55.tar.gz
RUN mkdir -p /tmp/gethtools \
	&& cd /tmp/gethtools \
  && wget -q https://gethstore.blob.core.windows.net/builds/geth-alltools-linux-amd64-1.13.5-916d6a44.tar.gz \
  && tar --strip-components=1 -xzf /tmp/gethtools/*.tar.gz \
  && cp /tmp/gethtools/* /usr/local/bin

# upgrade pip and install requirements for python3.7 which have been previously added to /smartcode
RUN python3 -m pip install --upgrade pip
#RUN python3 -m pip install -r requirements.txt

# port jupyter
EXPOSE 8888

# change final user
USER $UNAME

# Run jupyter per default:
#CMD ["jupyter", "notebook", "--ip", "0.0.0.0", "--port", "8888"]
ENTRYPOINT ["/smartenv/entrypoint.sh"]

