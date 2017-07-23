FROM ubuntu:16.04


RUN apt update 
RUN apt install -y nginx supervisor uwsgi
RUN apt install -y sudo net-tools vim curl python-pip
RUN apt install -y libmysqlclient-dev libssl-dev
RUN useradd ubuntu \
    && echo "ubuntu:password" | chpasswd \
    && adduser ubuntu sudo

# Add repo
WORKDIR /home/ubuntu
COPY base base

# Replace default configs
COPY nginx.conf /etc/nginx/nginx.conf
COPY supervisord.conf /etc/supervisor/supervisord.conf

# Symlink custom configs
RUN unlink /etc/nginx/sites-enabled/default \
    && mkdir /home/ubuntu/.local/bin -p \
    && ln -s /usr/bin/uwsgi /home/ubuntu/.local/bin/uwsgi

# Install dependencies
RUN pip install -r requirements.txt

# Run as user ubuntu
USER ubuntu

# Expose the HTTP port
EXPOSE 80

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/supervisord.conf", "-n"]
