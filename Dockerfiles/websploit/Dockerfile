FROM alpine:latest

WORKDIR /root
RUN apk add --no-cache python py-pip wget && \
    wget --no-check-certificate https://github.com/websploit/websploit/archive/master.tar.gz && \
    tar xzf master.tar.gz && \
    pip install scapy && \
    rm -f master.tar.gz && \
    apk del --purge py-pip wget

ENTRYPOINT ["/root/websploit-master/websploit"]
