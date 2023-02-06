# get iPXE source, at specified commit/tag
# TODO replace with git submodule
FROM alpine/git as ipxe_source
WORKDIR /opt/ipxe
ARG GIT_REFERENCE=e09e1142a3bd8bdb702efc92994c419a53e9933b
ARG REPO_URL=https://github.com/ipxe/ipxe
RUN \
    git clone ${REPO_URL} . && \
    git checkout ${GIT_REFERENCE}

# build iPXE for arm64 EFI
FROM debian:bullseye
ENV DEBIAN_FRONTEND=noninteractive
RUN \
    apt-get update --quiet > /dev/null && \
    apt-get install --quiet --quiet --no-install-recommends \
        build-essential \
        gcc-aarch64-linux-gnu \
        git \
        quilt
ENV \
    QUILT_PATCHES=debian/patches

COPY --from=ipxe_source /opt/ipxe /opt/ipxe
COPY patches /opt/ipxe/${QUILT_PATCHES}

WORKDIR /opt/ipxe/src
CMD \
    quilt push -a && \
    make -j  bin-x86_64-efi/ipxe.efi EMBED=autoboot.ipxe && \
    cp bin-x86_64-efi/*.efi /opt/output
