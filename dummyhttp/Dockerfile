FROM busybox:latest
MAINTAINER mi2428

ADD http.sh /http.sh
RUN chmod +x /http.sh

EXPOSE 80

CMD ["/http.sh"]
