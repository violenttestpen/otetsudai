FROM alpine:latest

#RUN apk add --no-cache \
#    midori \
#    ttf-dejavu \
#    gnome-icon-theme
RUN apk add --no-cache xrdp
#ENTRYPOINT ["midori"]
