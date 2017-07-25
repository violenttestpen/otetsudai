FROM alpine:latest

RUN apk add --no-cache \
    vlc \
    dbus-libs \
    dbus-x11 \
    libxcb \
    libxv \
    mesa-dri-ati \
    mesa-dri-intel \
    mesa-dri-nouveau \
    mesa-dri-swrast \
    mesa-dri-vmwgfx \
    ttf-freefont \
    vlc-qt \
    alsa-utils && \
    dbus-uuidgen --ensure=/etc/machine-id && \
    ln -sf /etc/machine-id /var/lib/dbus/machine-id

RUN adduser winston -D
USER winston
ENTRYPOINT ["vlc"]
