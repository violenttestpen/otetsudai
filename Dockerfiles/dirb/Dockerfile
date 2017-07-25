FROM alpine:latest

RUN apk add --no-cache curl g++ make curl-dev wget

# Download the latest version from Github 
WORKDIR /root
RUN wget --no-check-certificate https://github.com/seifreed/dirb/archive/master.tar.gz && \
    tar xzf master.tar.gz

# Install dirb and do post-install
RUN cd /root/dirb-master && \
    ./configure && \
    make && \
    cp dirb /bin && \
    mkdir -p /usr/share/dirb/wordlists && \
    cp -r wordlists /usr/share/dirb/

# Cleanup unneeded packages
RUN apk del --purge g++ make curl-dev wget && \
    rm -rf master.tar.gz dirb-master/

ENTRYPOINT ["dirb"]