FROM alpine

WORKDIR /root
RUN apk add --no-cache python py-pip nmap wget && \
    wget --no-check-certificate https://github.com/k4m4/kickthemout/archive/master.tar.gz && \
    tar xzf master.tar.gz && \
    pip install -r kickthemout-master/requirements.txt && \
    rm -f master.tar.gz kickthemout-master/requirements.txt && \
    apk del --purge wget

CMD ["python", "/root/kickthemout-master/kickthemout.py"]
