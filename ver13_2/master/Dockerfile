##################################################################
#   Base System
##################################################################
FROM postgres:13.2-alpine
LABEL maintainer="izumroot@deeplay.io"

##################################################################
#   Require pseudo sudo
##################################################################
ENV GOSU_VERSION 1.12
ADD ./gosu-amd64 /usr/bin/
RUN chmod +x /usr/bin/gosu-amd64

##################################################################
#   Install packages
##################################################################
#RUN apk add --update htop

##################################################################
#   Set system
##################################################################
COPY ./setup-master.sh /docker-entrypoint-initdb.d/setup-master.sh
RUN chmod 0666 /docker-entrypoint-initdb.d/setup-master.sh