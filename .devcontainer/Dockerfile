# syntax=docker/dockerfile:1

FROM z88dk/z88dk:latest as z88dk

FROM ubuntu:24.04 AS build
RUN apt-get update \
	&& apt-get install -y --no-install-recommends \
	build-essential \
	make \
	&& rm -rf /var/lib/apt/lists/*

ADD https://github.com/z00m128/sjasmplus.git#v1.21.0 /sjasmplus
RUN cd /sjasmplus && make && make install
ADD https://boarstone.mcphail.uk/mcphail/spectrum_remload.git /ttttt
RUN cd /ttttt && make ttttt
ADD https://github.com/einar-saukas/ZX0.git /zx0
RUN cd /zx0/src/ \
	&& gcc -O2 -o zx0 zx0.c optimize.c compress.c memory.c \
	&& gcc -O2 -o dzx0 dzx0.c

FROM ubuntu:24.04
RUN apt-get update \
	&& apt-get install -y --no-install-recommends \
	fuse-emulator-utils\
	git \
	make \
	openssh-client\
	pasmo \
	z80asm \
	z80dasm \
	zmakebas \
	&& rm -rf /var/lib/apt/lists/*
COPY --from=build /usr/local/bin/sjasmplus /bin/sjasmplus
COPY --from=build /ttttt/ttttt /bin/ttttt
COPY --from=build /zx0/src/zx0 /bin/zx0
COPY --from=build /zx0/src/dzx0 /bin/dzx0
COPY --from=z88dk /opt/z88dk /opt/z88dk
USER ubuntu
RUN echo "PATH=$PATH:/opt/z88dk/bin" >> ~/.profile
RUN echo "ZCCCFG=/opt/z88dk/lib/config/" >> ~/.profile