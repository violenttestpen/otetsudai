FROM kalilinux/kali-linux-docker
USER root
EXPOSE 22

RUN apt-get update && apt-get install ssh firefox-esr -y
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed -i 's/#X11UseLocalhost yes/X11UseLocalhost no/' /etc/ssh/sshd_config
RUN mkdir /run/sshd
RUN echo 'root:toor' | chpasswd

CMD ["/usr/sbin/sshd", "-D"]