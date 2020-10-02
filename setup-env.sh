#!/bin/bash
set -e # Exit with nonzero exit code if anything fails

HUGO_TARBALL="https://github.com/gohugoio/hugo/releases/download/v0.75.1/hugo_0.75.1_Linux-64bit.tar.gz"
CHECKOUT_DIR=`pwd`

echo "Install hugo ..."
rm -rf ${CHECKOUT_DIR}/binaries/
mkdir -p ${CHECKOUT_DIR}/binaries/
cd ${CHECKOUT_DIR}/binaries/
echo ${HUGO_TARBALL}
curl -L ${HUGO_TARBALL} | tar -xz

echo "Done."
