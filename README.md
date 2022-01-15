# Raspberry Pi iPXE Builder
Repo for building custom iPXE binaries

Builds iPXE EFI images for arm64

## Usage
To build iPXE for arm64 EFI, run `docker-compose` as follows:

    docker-compose run --rm ipxe

When complete, `ipxe.efi` will be available in [`output`](./output)

## License
BSD
