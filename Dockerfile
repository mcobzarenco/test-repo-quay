FROM ubuntu:14.04

MAINTAINER Marius Cobzarenco <marius@reinfer.io>

RUN apt-get update
RUN apt-get install -y ssh git software-properties-common

RUN apt-get install -y clang-3.4
ENV CC clang
ENV CXX clang++

RUN apt-get install -y build-essential cmake
RUN apt-get install -y python-pip python-dev
RUN apt-get install -y protobuf-compiler

# Install node, coffeescript and bower
RUN apt-add-repository -y ppa:chris-lea/node.js
RUN apt-get update && apt-get install -y nodejs
RUN npm install -g coffee-script
RUN npm install -g bower

RUN mkdir /src

# Install zmq
RUN apt-get install -y libzmq3-dev
RUN cd /src && git clone https://github.com/zeromq/cppzmq.git
RUN cd /src/cppzmq && cp zmq.hpp /usr/include/

# Install rpcz
RUN apt-get install -y libboost-program-options-dev
RUN apt-get install -y libprotobuf-dev libprotoc-dev
RUN cd /src && git clone https://github.com/reinferio/rpcz.git
RUN cd /src/rpcz && mkdir -p build && cd build && cmake .. && make && make install
RUN cd /src/rpcz/python && python setup.py build && python setup.py install

WORKDIR /src/
ENTRYPOINT ["ls"]
