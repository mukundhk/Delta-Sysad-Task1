FROM ubuntu:latest

RUN apt-get -y update
RUN apt-get -y upgrade

RUN mkdir /bashscripts
WORKDIR /bashscripts

COPY . /bashscripts/