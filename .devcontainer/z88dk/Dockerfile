# syntax=docker/dockerfile:1

# Similar to the speccydev container, I'm building this with:
# docker buildx build --platform linux/arm64/v8,linux/amd64 -t boarstone.mcphail.uk/mcphail/z88dk:tagname .

FROM ubuntu:24.04 AS build
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
	&& BUILD_SDCC=1 BUILD_SDCC_HTTP=1 ./build.sh \
	&& make install-clean bins-clean 

FROM ubuntu:24.04
COPY --from=build /opt/z88dk/ /opt/z88dk/
ENV PATH="$(PATH):/opt/z88dk/bin"
ENV ZCCCFG="/opt/z88dk/lib/config"
USER ubuntu
