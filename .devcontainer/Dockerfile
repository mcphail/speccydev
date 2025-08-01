# syntax=docker/dockerfile:1

FROM ubuntu:24.04 AS build
RUN apt-get update \
	&& apt-get install -y --no-install-recommends \
	build-essential \
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
ADD https://www.boriel.com/files/zxb/zxbasic-1.18.1-linux64.tar.gz .
RUN tar xf zxbasic*
ADD https://github.com/Mastodon-/inpaws.git /inpaws
RUN cd /inpaws/ \
	&& make -j8
RUN python3 -m pip install --break-system-packages skoolkit

FROM build AS z88dk
RUN apt-get update \
	&& apt-get install -y --no-install-recommends \
	bison \
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
	&& git clone --depth 1 --recursive https://github.com/z88dk/z88dk.git ${Z88DK_PATH} \
	&& cd ${Z88DK_PATH} \ 
	&& eval "$(perl -I$HOME/perl5/lib/perl5 -Mlocal::lib)" \
	&& chmod 777 build.sh \
	&& sed -i -e "s/make/make -j8/g" build.sh \
	&& BUILD_SDCC=1 BUILD_SDCC_HTTP=1 ./build.sh \
	&& make install-clean bins-clean 

FROM ubuntu:24.04
RUN apt-get update \
	&& apt-get install -y --no-install-recommends \
	ca-certificates \
	fuse-emulator-utils \
	git \
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
COPY --from=z88dk /opt/z88dk/bin /opt/z88dk/bin
COPY --from=z88dk /opt/z88dk/lib /opt/z88dk/lib
COPY --from=z88dk /opt/z88dk/include /opt/z88dk/include
ENV PATH="${PATH}:/opt/z88dk/bin:/opt/zxbasic:/opt/zxbasic/tools"
ENV ZCCCFG="/opt/z88dk/lib/config"
USER ubuntu