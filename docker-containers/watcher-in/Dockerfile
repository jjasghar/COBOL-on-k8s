FROM centos:7

RUN yum install -y wget

COPY ./watcher-in.sh ./src/

CMD ["/src/watcher-in.sh"]
