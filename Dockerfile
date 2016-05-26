FROM debian:jessie

MAINTAINER Platzhalter <platzhalter@sigaint.org>

RUN printf "deb http://ppa.launchpad.net/bzr/ppa/ubuntu trusty main\ndeb-src http://ppa.launchpad.net/bzr/ppa/ubuntu trusty main" >> /etc/apt/sources.list
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys D702BF6B8C6C1EFD
RUN apt-get update
RUN apt-get install -y bzr mercurial git python-pygments golang sudo
RUN adduser -q --home /ghostbin --uid 10000 --disabled-password --gecos "" ghostbin
USER ghostbin
ENV GOPATH=/ghostbin/go
RUN mkdir -p /ghostbin/go/src/github.com
RUN git clone https://github.com/DHowett/ghostbin.git /ghostbin/go/src/github.com/ghostbin
WORKDIR /ghostbin/go/src/github.com/ghostbin
RUN go get
RUN go install
RUN go build
USER root
RUN mkdir /logs
RUN chown ghostbin:ghostbin /logs

EXPOSE 8619

VOLUME /logs

COPY ghostbin.sh /ghostbin/ghostbin.sh

ENTRYPOINT /ghostbin/ghostbin.sh
CMD -addr="0.0.0.0:8619" -log_dir="/logs"
