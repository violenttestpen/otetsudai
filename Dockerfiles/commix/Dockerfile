FROM alpine:latest

WORKDIR /root
RUN apk add --no-cache python wget && \
    wget --no-check-certificate https://github.com/commixproject/commix/archive/master.tar.gz && \
    apk del --purge wget && \
    tar xzf master.tar.gz && \
    rm -f master.tar.gz

ENTRYPOINT ["/root/commix-master/commix.py"]
