FROM fedora:latest

RUN dnf -y update
RUN dnf -y install nginx certbot certbot-nginx

COPY nginx.conf /etc/nginx/
COPY conf.d/proxy.conf /root/

COPY certbot.env /root/
COPY init.bash /root/
CMD bash /root/init.bash
