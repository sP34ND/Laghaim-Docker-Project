#!/bin/bash
set -eux

LIB_DIR="/usr/lib/i386-linux-gnu"
DEB_URL="http://archive.debian.org/debian/pool/main/m/mysql-5.1/libmysqlclient16_5.1.73-1+deb6u1_i386.deb"

cd /tmp
apt-get update
apt-get install -y --no-install-recommends wget ca-certificates binutils dpkg

wget -q -O mysql51-client.deb "${DEB_URL}"
dpkg-deb -x mysql51-client.deb extract

mkdir -p "${LIB_DIR}"
cp -a extract/usr/lib/libmysqlclient.so.16 "${LIB_DIR}/"
cp -a extract/usr/lib/libmysqlclient.so.16.0.0 "${LIB_DIR}/"
ln -sf libmysqlclient.so.16 "${LIB_DIR}/libmysqlclient.so"

ldconfig

objdump -p "${LIB_DIR}/libmysqlclient.so.16" | grep libmysqlclient
ls -la "${LIB_DIR}/libmysqlclient.so.16"*
