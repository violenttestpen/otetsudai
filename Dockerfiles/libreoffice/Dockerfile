FROM alpine:latest

RUN apk add --no-cache \
    libreoffice \
    ttf-dejavu

RUN adduser winston -D
USER winston
ENTRYPOINT ["libreoffice"]
