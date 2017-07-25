FROM alpine:latest

WORKDIR /root
RUN apk add --no-cache python py-pip wget

RUN wget --no-check-certificate https://github.com/winstonho90/butai/archive/master.tar.gz && \
    tar -xzvf master.tar.gz && \
    mv butai-master butai && \
    rm master.tar.gz butai/setup.sh butai/LICENSE

RUN pip install --no-cache-dir -r butai/requirements.txt \
    && rm butai/requirements.txt \
    && apk del --purge py-pip wget

CMD ["/usr/bin/python", "butai/app.py"]
