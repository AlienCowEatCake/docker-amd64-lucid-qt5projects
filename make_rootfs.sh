#!/bin/bash -e

# See https://stafwag.github.io/blog/blog/2019/04/22/building-your-own-docker-images_part1/

if [ $(id -u) -ne 0 ] ; then
    echo "This script must be run as root!"
    exit 1
fi

TMPDIR="${PWD}/tmp"
mkdir -p "${TMPDIR}"
cd "${TMPDIR}"

git clone --depth 1 -b v20.10.0-beta1 https://github.com/moby/moby.git
cd moby/contrib
./mkimage.sh \
    -d "${TMPDIR}" \
    --no-compression \
    debootstrap \
    --no-check-gpg \
    --no-check-certificate \
    --components=main,universe,multiverse,restricted \
    --arch=amd64 \
    lucid http://old-releases.ubuntu.com/ubuntu
cd "${TMPDIR}"
xz -z9ev --threads=0 rootfs.tar
mv rootfs.tar.xz ../rootfs.tar.xz

cd ..
rm -rf "${TMPDIR}"
