FROM busybox:latest
MAINTAINER Taichi MIYA <tamy@z.mi2428.net>

EXPOSE 80

ADD http.sh /http.sh
RUN chmod +x /http.sh

CMD ["/http.sh"]
