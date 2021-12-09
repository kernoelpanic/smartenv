# Dockerfile for smart contract 
# geth environment

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

### copy files in build container ###
# copy git repository if available
COPY --chown=$UID:$GID ./src-clients/go-ethereum/ "$WORKDIR_CONTAINER"/src-clients/go-ethereum/

### update, upgrade and install basic tools ###
RUN apt update 
RUN apt dist-upgrade -y
# Required system tools 
RUN apt install -y git wget curl
# Additional system tools 
RUN apt install -y vim iputils-ping netcat iproute2 sudo

### Install dependencies for geth build ###
# to avoid prompt for tzdata
ENV TZ=Europe/Berlin
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
RUN apt install -y build-essential make 

### Install dependencies for geth devtools build ###
# Install solc 
RUN cd /usr/local/bin \
  && wget -qO solc_4.25 https://github.com/ethereum/solidity/releases/download/v0.4.25/solc-static-linux \
  && wget -qO solc_5.4 https://github.com/ethereum/solidity/releases/download/v0.5.4/solc-static-linux \
  && wget -qO solc_7.4 https://github.com/ethereum/solidity/releases/download/v0.7.4/solc-static-linux \
  && wget -qO solc_8.4 https://github.com/ethereum/solidity/releases/download/v0.8.4/solc-static-linux \
  && cp solc_8.4 solc \
  && chmod 755 solc*
# Install npm
RUN apt install -y npm
# Install google protocol buffers command line tool (protoc)
RUN apt install -y unzip
RUN cd /usr/local/bin \
  && wget -qO protoc.zip https://github.com/protocolbuffers/protobuf/releases/download/v3.14.0-rc2/protoc-3.14.0-rc-2-linux-x86_64.zip \
  && unzip

### Install go ###
# Ref: https://golang.org/doc/install
RUN chown $UID.$GID /smartenv
USER $UNAME
RUN wget --progress=bar:force:noscroll -P /smartenv/ https://golang.org/dl/go1.15.4.linux-amd64.tar.gz
USER root
RUN tar -C /usr/local -xzf /smartenv/*.tar.gz
USER $UNAME
RUN echo 'PATH=$PATH:/usr/local/go/bin' >> /home/$UNAME/.profile
RUN echo "GO VERSION:" && /usr/local/go/bin/go version

### Install geth sources ###
# if not already available
USER $UNAME
RUN if test -d "$WORKDIR_CONTAINER"/src-clients/go-ethereum/.git; \
	  then echo "Repostory already available"; \
    else \
      cd "$WORKDIR_CONTAINER"/src-clients/ && git clone --recursive https://github.com/ethereum/go-ethereum ; \
    fi

### Build geth version ###
# if not already built 
# Ref: https://github.com/ethereum/go-ethereum/wiki/Installation-Instructions-for-Ubuntu
ARG VERSIONTAG=v1.10.3 
RUN if test -d "$WORKDIR_CONTAINER"/src-clients/go-ethereum/build/bin/geth; \
	then echo "Already compiled"; \
    else export PATH=$PATH:/usr/local/go/bin \
	&& cd "$WORKDIR_CONTAINER"/src-clients/go-ethereum \
  && git checkout $VERSIONTAG \
	&& make all ; \
    fi
USER root
RUN cp "$WORKDIR_CONTAINER"/src-clients/go-ethereum/build/bin/geth /usr/local/bin

### port ###
# Do not expose any port by default
# this is handled by docker run options
#EXPOSE 30303

# change final user
USER $UNAME

# Output version info per default:
RUN echo "GETH VERSION:"
CMD ["geth", "version"]

