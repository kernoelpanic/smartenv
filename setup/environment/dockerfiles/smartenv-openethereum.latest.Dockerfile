# Dockerfile for smart contract development
# with web3 for python 3.7 on Ubuntu

# Overview of ubuntu docker images
#https://hub.docker.com/_/ubuntu
#FROM ubuntu:eoan
FROM ubuntu:focal

WORKDIR /smartenv

# Add a user given as build argument
ARG UNAME=smartenv
ARG UID=1000
ARG GID=1000
RUN groupadd -g $GID -o $UNAME
RUN useradd -m -u $UID -g $GID -o -s /bin/bash $UNAME

# copy files in build container

COPY --chown=$UID:$GID ./smartenv.python.erequirements.txt /smartenv/requirements.txt
# copy openethereum git repository
RUN mkdir ./openethereum
COPY --chown=$UID:$GID ./openethereum/ ./openethereum/

# update and upgrade
RUN apt-get update 
RUN apt-get dist-upgrade -y

# Required system tools 
RUN apt-get install -y git wget curl
# Additional system tools 
RUN apt-get install -y vim iputils-ping netcat iproute2 sudo

# Install dependencies for build
# to avoid prompt for tzdata
ENV TZ=Europe/Berlin
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
RUN apt-get install -y build-essential cmake libudev-dev

# Install rust
RUN chown $UID.$GID /smartenv
USER $UNAME
RUN curl -# -o /smartenv/rustup-init.sh https://sh.rustup.rs
RUN cd /smartenv && sh ./rustup-init.sh -y

# Get OpenEthereum sources
RUN if test -d /smartenv/openethereum/.git; \
	then echo "Repostory already available"; \
        else git clone --recursive https://github.com/openethereum/openethereum ; \
	fi
# Build OpenEthereum 
RUN cd openethereum && /home/$UNAME/.cargo/bin/cargo build --release --features final
# Install OpenEthereum
USER root
RUN cp /smartenv/openethereum/target/release/openethereum /usr/local/bin

# port jupyter
#EXPOSE 30303

# change final user
USER $UNAME

# Run jupyter per default:
CMD ["openethereum", "--help"]

# References:
# https://openethereum.github.io/wiki/Setup#one-line-binary-installer
# https://github.com/openethereum/openethereum/tree/v3.1.0
