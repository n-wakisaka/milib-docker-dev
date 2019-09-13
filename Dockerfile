FROM ubuntu:18.04 as base

# Install Packages
RUN apt-get update -y && apt-get upgrade -y
RUN apt-get install -y \
      sudo \
      git \
      build-essential

# for roki-gl
RUN apt-get install -y \
			libx11-dev \
      libxext-dev \
      libxpm-dev \
      libpng-dev \
      libjpeg-dev \
      libgl1-mesa-dev \
      libglu1-mesa-dev \
      libglew-dev \
      freeglut3-dev

RUN apt-get clean
RUN rm -rf /var/lib/apt/lists/*

# Create user
RUN groupadd --gid 1000 developer && \
    useradd  --uid 1000 --gid 1000 --groups sudo --create-home --shell /bin/bash developer && \
    echo 'developer:developer-pass' | chpasswd

USER developer
WORKDIR /home/developer

RUN mkdir -p ./usr/bin ./usr/lib ./usr/include
ENV PATH $PATH:/home/developer/usr/bin
ENV LD_LIBRARY_PATH $LD_LIBRARY_PATH:/home/developer/usr/lib

# library
RUN mkdir -p milib
WORKDIR ./milib
RUN git clone https://github.com/n-wakisaka/zeda.git
RUN git clone https://github.com/n-wakisaka/zm.git
RUN git clone https://github.com/n-wakisaka/zeo.git
RUN git clone https://github.com/n-wakisaka/roki.git
RUN git clone https://github.com/n-wakisaka/liw.git
RUN git clone https://github.com/n-wakisaka/zx11.git
RUN git clone https://github.com/n-wakisaka/roki-gl.git
RUN git clone https://github.com/n-wakisaka/roki-fd.git

WORKDIR ../
CMD /bin/bash

FROM base
WORKDIR ./milib

RUN cd zeda && make && make install
RUN cd zm && make && make install
RUN cd zeo && make && make install
RUN cd roki && make && make install
RUN cd liw && make && make install
RUN cd zx11 && make && make install
RUN cd roki-gl && make && make install
RUN cd roki-fd && make && make install

WORKDIR ../
CMD /bin/bash