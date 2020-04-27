FROM centos:7 as BUILD

ENV GMP_VERSION=6.0.0
ENV GNU_COBOL=1.1

RUN yum install -y libtool ncurses ncurses-devel ncurses-libs make && \
    yum install -y libdb-devel libdbi libdbi-devel libtool-ltdl libtool-ltdl-devel db4 db4-devel wget

RUN mkdir -p /src/cobol

RUN cd /src && wget https://ftp.gnu.org/gnu/gmp/gmp-${GMP_VERSION}a.tar.xz && \
    tar xf gmp-${GMP_VERSION}a.tar.xz && \
    cd gmp-${GMP_VERSION} && ./configure ; make ; make check ; make install

RUN cd /src && wget http://sourceforge.net/projects/open-cobol/files/gnu-cobol/${GNU_COBOL}/gnu-cobol-${GNU_COBOL}.tar.gz && \
    tar xvzf gnu-cobol-${GNU_COBOL}.tar.gz && \
    cd gnu-cobol-${GNU_COBOL} && ./configure ; make ; make check ; make install

COPY  ./plus5numbers.cbl /src/cobol/

RUN cd /src/cobol && cobc -free -x -o plus5numbers-exe plus5numbers.cbl

FROM centos:7

RUN yum install -y wget procps-ng

RUN wget -O /tmp/libcob.rpm http://packages.psychotic.ninja/7/base/x86_64/RPMS/libcob-1.1-5.el7.psychotic.x86_64.rpm && \
    rpm -Uvh /tmp/libcob.rpm

COPY --from=BUILD /src/cobol/plus5numbers-exe /app/plus5numbers-exe
COPY ./scripts/* /app/

RUN chmod +x /app/*.sh

ENV LD_LIBRARY_PATH /usr/local/lib:$LD_LIBRARY_PATH

CMD ["/app/watcher-cobol.sh"]
