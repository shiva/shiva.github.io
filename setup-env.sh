#!/bin/bash
set -e # Exit with nonzero exit code if anything fails

HUGO_TARBALL="https://github.com/spf13/hugo/releases/download/v0.16/hugo_0.16_linux-64bit.tgz"
CHECKOUT_DIR=`pwd`

echo "Install hugo ..."
rm -rf ${CHECKOUT_DIR}/binaries/
mkdir -p ${CHECKOUT_DIR}/binaries/
cd ${CHECKOUT_DIR}/binaries/
echo ${HUGO_TARBALL}
curl -L ${HUGO_TARBALL} | tar -xz

echo "Done."
