# get iPXE source, at specified commit/tag
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
        git
ENV \
    CROSS_COMPILE=aarch64-linux-gnu- \
    EMBED=san-boot.ipxe
COPY --from=ipxe_source /opt/ipxe /opt/ipxe
WORKDIR /opt/ipxe/src
COPY ${EMBED} .
CMD \
    make -j bin-arm64-efi/ipxe.efi && \
    cp bin-arm64-efi/*.efi /opt/output
