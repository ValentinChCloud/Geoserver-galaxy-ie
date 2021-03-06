FROM ubuntu:16.10


MAINTAINER Valentin Chambon "valentin.chambon@mnhn.fr"




USER root
ENV DEBIAN_FRONTEND=noninteractive \
    API_KEY=none \
    DEBUG=false \
    PROXY_PREFIX=none \
    GALAXY_URL=none \
    GALAXY_WEB_PORT=10000 \
    HISTORY_ID=none \
    REMOTE_HOST=none
	
RUN apt-get update &&\
apt-get install -y wget

RUN apt-get install --no-install-recommends -y \
wget procps nginx python python-pip net-tools nginx 

RUN apt-get install -y python-pip
RUN pip install --upgrade pip
RUN pip install -U setuptools
RUN pip install bioblend galaxy-ie-helpers

RUN apt-get install -y zip

RUN apt-get install -y software-properties-common
RUN \
  echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | debconf-set-selections && \
  add-apt-repository -y ppa:webupd8team/java && \
  apt-get update && \
  apt-get install -y oracle-java8-installer

RUN wget -c http://sourceforge.net/projects/geoserver/files/GeoServer/2.12.1/geoserver-2.12.1-bin.zip
RUN unzip /geoserver-2.12.1-bin.zip

ENV GEOSERVER_HOME /geoserver-2.12.1
#RUN echo "export GEOSERVER_HOME=/geoserver-2.12.1" >> ~/.profile
#RUN ["/bin/bash","-c","source ~/.profile"]



# Our very important scripts. Make sure you've run `chmod +x startup.sh
# monitor_traffic.sh` outside of the container!
ADD ./startup.sh /startup.sh
ADD ./monitor_traffic.sh /monitor_traffic.sh

ADD ./get_notebook.py /get_notebook.py

# Nginx configuration
COPY ./proxy.conf /proxy.conf
VOLUME ["/import"]
WORKDIR /import/

RUN apt-get install -y curl


RUN rm -rf /var/lib/apt/lists/* && \
    rm -rf /var/cache/oracle-jdk8-installer



EXPOSE 80
CMD /startup.sh
