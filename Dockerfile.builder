FROM ubuntu:20.04 AS builder
ARG DEBIAN_FRONTEND=noninteractive

# mount sources
ADD . /home/

# installing packages
# RUN apt-get update && \
#     apt-get install -y wget software-properties-common && \
#     add-apt-repository ppa:deadsnakes/ppa && \
#     apt-get update && \
#     apt-get install -y --no-install-recommends \
#     make gcc espeak espeak-ng \
#     python3.11 python3.11-dev libexpat1-dev zlib1g-dev

RUN useradd -ms /bin/bash andrey

RUN chown -R andrey /home

# RUN su -c "cd /home/andrey/ && wget https://bootstrap.pypa.io/get-pip.py && python3.11 get-pip.py &&  python3.11 -m pip install pip && python3.11 -m pip install TTS wave cython playsound PyObjC" andrey

# RUN su -c 'export PATH="/home/andrey/.local/bin:$PATH" && cd /home && make -j8 run && make -j8 build' andrey

RUN su -c 'cd /home && make -j8 run && make -j8 build' andrey
