# syntax=docker/dockerfile:1

# My current workflow is to build this on an M1 MacBook for both amd64 and arm64 using:
# docker buildx build --platform linux/arm64/v8,linux/amd64 -t boarstone.mcphail.uk/mcphail/speccydev:tagname .

FROM ubuntu:24.04 AS build
RUN apt-get update \
	&& apt-get install -y --no-install-recommends \
	autoconf \
	automake \
	build-essential \
	fpc \
	libdsk4-dev \
	make \
	python3-pip \
	unzip \
	&& rm -rf /var/lib/apt/lists/*

ADD https://github.com/z00m128/sjasmplus.git#v1.23.0 /sjasmplus
RUN cd /sjasmplus && make -j8 && make install
ADD https://boarstone.mcphail.uk/mcphail/spectrum_remload.git /ttttt
RUN cd /ttttt && make ttttt
ADD https://github.com/einar-saukas/ZX0.git /zx0
RUN cd /zx0/src/ \
	&& gcc -O2 -o zx0 zx0.c optimize.c compress.c memory.c \
	&& gcc -O2 -o dzx0 dzx0.c
ADD https://www.boriel.com/files/zxb/zxbasic-1.18.7-linux64.tar.gz .
RUN tar xf zxbasic*
ADD https://github.com/Mastodon-/inpaws.git /inpaws
RUN cd /inpaws/ \
	&& make -j8
RUN python3 -m pip install --break-system-packages skoolkit
ADD https://github.com/gasman/hdfmonkey.git /hdfmonkey
RUN cd /hdfmonkey/ \
	&& autoheader \
	&& aclocal \
	&& autoconf \
	&& automake -a \
	&& ./configure \
	&& make -j16 \
	&& make install
ADD https://github.com/pleumann/pasta80.git#v0.98 /opt/pasta80
RUN cd /opt/pasta80 \
	&& fpc pasta
ADD --unpack https://www.seasip.info/ZX/taptools-1.1.3.tar.gz taptools/
RUN cd taptools/taptools* \
	&& cp /usr/share/automake-1.16/config.guess . \
	&& ./configure \
	&& make -j8 \
	&& make install

FROM ubuntu:24.04
RUN apt-get update \
	&& apt-get install -y --no-install-recommends \
	ca-certificates \
	fuse-emulator-utils \
	git \
	libdsk4 \
	libdsk-utils \
	m4 \
	make \
	openssh-client \
	pasmo \
	python3 \
	z80asm \
	z80dasm \
	zmakebas \
	&& rm -rf /var/lib/apt/lists/*
COPY --from=build /ttttt/ttttt /bin/ttttt
COPY --from=build /zx0/src/zx0 /bin/zx0
COPY --from=build /zx0/src/dzx0 /bin/dzx0
COPY --from=build /zxbasic/zxbasm.py /opt/zxbasic/zxbasm
COPY --from=build /zxbasic/zxbc.py /opt/zxbasic/zxbc
COPY --from=build /zxbasic/zxbpp.py /opt/zxbasic/zxbpp
COPY --from=build /zxbasic/src /opt/zxbasic/src
COPY --from=build /zxbasic/tools /opt/zxbasic/tools
COPY --from=build /inpaws/inpaws /bin/inpaws
COPY --from=build /usr/local/bin/ /usr/local/bin/
COPY --from=build /usr/local/lib/python3.12/dist-packages/skoolkit/ /usr/local/lib/python3.12/dist-packages/skoolkit/
COPY --from=build /opt/pasta80 /opt/pasta80

# z88dk takes a long time to cross compile so I'm keeping this in a separate container
# so it doesn't require building every time the cache expires. The Dockerfile for z88dk
# is in a subdirectory of this one. If you're building the container yourself you may
# want to alter the next line to your own tagged build of z88dk but you're welcome to
# use mine.
COPY --from=boarstone.mcphail.uk/mcphail/z88dk:v2.4 /opt/z88dk/ /opt/z88dk/
ENV PATH="${PATH}:/opt/z88dk/bin:/opt/zxbasic:/opt/zxbasic/tools:/opt/pasta80"
ENV ZCCCFG="/opt/z88dk/lib/config"
USER ubuntu
