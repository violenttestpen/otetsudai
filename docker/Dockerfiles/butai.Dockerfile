FROM alpine:latest

RUN apk add --no-cache python py-pip 

WORKDIR /root
ADD https://github.com/winstonho90/butai/archive/master.tar.gz master.tar.gz
RUN tar -xzvf master.tar.gz \
    && mv */ butai \
    && rm master.tar.gz butai/setup.sh

RUN pip install --no-cache-dir -r butai/requirements.txt \
    && rm butai/requirements.txt \
    && apk del py-pip

CMD ["/usr/bin/python", "butai/app.py"]
