FROM ubuntu:16.04


RUN apt update && apt install -y nginx supervisor uwsgi openssh-server sudo net-tools python-pip
RUN apt install -y libmysqlclient-dev libssl-dev vim curl
RUN useradd ubuntu && echo "ubuntu:password" | chpasswd && adduser ubuntu sudo

# Add repo
WORKDIR /home/ubuntu
ADD base base

# Application files
WORKDIR base
ADD base.conf config/base.conf
ADD config.ini config/config.ini

# Replace default configs
ADD nginx.conf /etc/nginx/nginx.conf
ADD supervisord.conf /etc/supervisor/supervisord.conf

# Symlink custom configs
RUN unlink /etc/nginx/sites-enabled/default
RUN ln -s /home/ubuntu/base/config/base.conf /etc/nginx/sites-enabled/base.conf
RUN rm -f config.ini
RUN ln -s /home/ubuntu/base/config/config.ini config.ini
RUN mkdir /home/ubuntu/.local/bin -p && ln -s /usr/local/bin/uwsgi /home/ubuntu/.local/bin/uwsgi

# Install dependencies
RUN pip install -r requirements.txt

# Start supervisor service
RUN service supervisor start

# Run as user ubuntu
USER ubuntu

# Expose the HTTP port
EXPOSE 80

CMD ["/usr/sbin/sshd", "-D"]
