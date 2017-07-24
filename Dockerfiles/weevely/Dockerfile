FROM alpine:latest

WORKDIR /root
RUN apk add --no-cache \
    g++ \
    python \
    py-pip \
    yaml-dev \
    python-dev \
    wget

RUN pip install --no-cache-dir prettytable Mako PyYAML python-dateutil PySocks

RUN wget --no-check-certificate https://github.com/epinna/weevely3/archive/master.tar.gz && \
    tar xzvf master.tar.gz && \
    mv */ weevely3 && \
    rm master.tar.gz && \
    ln -s /root/weevely3/weevely.py /usr/local/bin/weevely && \
    apk del --purge g++ py-pip yaml-dev python-dev wget

ENTRYPOINT [ "weevely" ]