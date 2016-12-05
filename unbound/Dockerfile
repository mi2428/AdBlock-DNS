FROM ubuntu:xenial
MAINTAINER Taichi MIYA <tamy@z.mi2428.net>

ENV VERSION 1.5.10

EXPOSE 53/udp
EXPOSE 53

WORKDIR /opt

# apt does not have a stable CLI interface.
RUN apt-get update && apt-get -y upgrade && \
    apt-get -y install \
        apt-utils \
        build-essential \
        tar \
        file \
        wget \
        dnsutils \
        libevent-dev \
        libevent-2.0.5 \
        libssl-dev \
        libexpat1-dev && \
    wget http://www.unbound.net/downloads/unbound-${VERSION}.tar.gz -P /opt && \
    tar zxvf unbound-${VERSION}.tar.gz && \
    rm unbound-${VERSION}.tar.gz && \
    cd unbound-${VERSION} && \
    ./configure --prefix=/ --with-libevent && \
    make && \
    make install && \
    cd .. && \
    rm -r unbound-${VERSION} && \
    apt-get -y purge \
        build-essential \
        gcc \
        gcc-4.8 \
        cpp \
        cpp-4.8 \
        libevent-dev \
        libssl-dev \
        libexpat1-dev && \
    apt-get -y autoremove --purge && \
    apt-get clean && \
    rm -r /var/lib/apt/lists/* && \
    useradd --system unbound && \
    wget -O /etc/unbound/named.cache https://www.internic.net/domain/named.cache && \
    chown -R unbound:unbound /etc/unbound && \
    mkdir -p /var/log/unbound && \
    chown -R unbound:unbound /var/log/unbound

ADD assets/ad.db /etc/unbound/ad.db
ADD assets/unbound.conf /etc/unbound/unbound.conf
ADD init.sh /init.sh
RUN chmod +x /init.sh

CMD ["/init.sh"]
