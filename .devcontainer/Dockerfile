# syntax=docker/dockerfile:1

FROM ubuntu:24.04 AS build
RUN apt-get update \
	&& apt-get install -y --no-install-recommends \
	autoconf \
	automake \
	build-essential \
	fpc \
	make \
	python3-pip \
	unzip \
	&& rm -rf /var/lib/apt/lists/*

ADD https://github.com/z00m128/sjasmplus.git#v1.21.0 /sjasmplus
RUN cd /sjasmplus && make -j8 && make install
ADD https://boarstone.mcphail.uk/mcphail/spectrum_remload.git /ttttt
RUN cd /ttttt && make ttttt
ADD https://github.com/einar-saukas/ZX0.git /zx0
RUN cd /zx0/src/ \
	&& gcc -O2 -o zx0 zx0.c optimize.c compress.c memory.c \
	&& gcc -O2 -o dzx0 dzx0.c
ADD https://www.boriel.com/files/zxb/zxbasic-1.18.3-linux64.tar.gz .
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
ADD https://github.com/pleumann/pasta80.git#v0.96 /opt/pasta80
RUN cd /opt/pasta80 \
	&& fpc pasta

FROM ubuntu:24.04 AS z88dk
RUN apt-get update \
	&& apt-get install -y --no-install-recommends \
	bison \
	build-essential \
	ca-certificates \
	ccache \
	cpanminus \
	curl \
	dos2unix \
	flex \
	gdb \
	git \
	libboost-all-dev \
	libcapture-tiny-perl \
	libclone-perl \
	libdata-hexdump-perl \
	libfile-slurp-perl \
	libgmp3-dev \
	liblocal-lib-perl \
	libmodern-perl-perl \
	libpath-tiny-perl \
	libregexp-common-perl \
	libtext-table-perl \
	libxml2-dev \
	libyaml-perl \
	m4 \
	make \
	perl \
	pkg-config \
	ragel \
	re2c \
	texi2html \
	texinfo \
	zlib1g-dev \
	&& rm -rf /var/lib/apt/lists/*
ENV Z88DK_PATH="/opt/z88dk"
RUN cpanm -l $HOME/perl5 --no-wget local::lib Template::Plugin::YAML \
	&& git clone --depth 1 --branch v2.4 --recursive https://github.com/z88dk/z88dk.git ${Z88DK_PATH} \
	&& cd ${Z88DK_PATH} \ 
	&& eval "$(perl -I$HOME/perl5/lib/perl5 -Mlocal::lib)" \
	&& chmod 777 build.sh \
	&& BUILD_SDCC=1 BUILD_SDCC_HTTP=1 MAKE_CONCURRENCY=-j8 ./build.sh \
	&& make install-clean bins-clean 

FROM ubuntu:24.04
RUN apt-get update \
	&& apt-get install -y --no-install-recommends \
	ca-certificates \
	fuse-emulator-utils \
	git \
	m4 \
	make \
	openssh-client \
	pasmo \
	python3 \
	z80asm \
	z80dasm \
	zmakebas \
	&& rm -rf /var/lib/apt/lists/*
COPY --from=build /usr/local/bin/sjasmplus /bin/sjasmplus
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
COPY --from=build /usr/local/bin/hdfmonkey /bin/hdfmonkey
COPY --from=build /opt/pasta80 /opt/pasta80
COPY --from=z88dk /opt/z88dk/ /opt/z88dk/
ENV PATH="${PATH}:/opt/z88dk/bin:/opt/zxbasic:/opt/zxbasic/tools:/opt/pasta80"
ENV ZCCCFG="/opt/z88dk/lib/config"
USER ubuntu
