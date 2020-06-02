#!/bin/bash

ARCHITECTURE=$(uname -m)
VERSION='1.0.2'

if [ $ARCHITECTURE = "x86_64" ]
then
    ARCH='amd64'
elif [[ $ARCHITECTURE = 'armv7l' ]]
then
    ARCH='armhf'
else
    echo 'Unsupported architecture'
    exit 1
fi

rm -rf package_dir
mkdir package_dir
mkdir package_dir/DEBIAN
mkdir package_dir/etc
mkdir package_dir/etc/profile.d/
mkdir package_dir/usr
mkdir package_dir/usr/bin

echo "Package: husarion-motd
Version: $VERSION
Section: custom
Priority: optional
Architecture: $ARCH
Essential: no
Installed-Size: 1024
Maintainer: Husarion <support@husarion.com>
Description: Welcome message for Linux-based Husarion devices" > package_dir/DEBIAN/control

echo "#!/bin/sh
set -e
if [ -e /etc/motd -a ! -e /etc/motd.old ]; then
  mv /etc/motd /etc/motd.old
  touch /etc/motd
fi
chmod -x /etc/update-motd.d/*" > package_dir/DEBIAN/postinst
chmod a+x package_dir/DEBIAN/postinst

cp -a husarion-motd.sh package_dir/etc/profile.d/husarion-motd.sh


if [ $ARCH = 'amd64' ]
then
    nim compile --define:pro husarion_motd.nim
elif [ $ARCH = 'armhf' ]
then
    nim compile husarion_motd.nim
fi

mv husarion_motd package_dir/usr/bin/husarion-motd

dpkg-deb --build package_dir husarion-motd-$VERSION-$ARCH.deb