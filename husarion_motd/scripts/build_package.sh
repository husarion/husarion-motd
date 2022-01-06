#!/bin/bash

# Create messagaes
touch package_dir/usr/bin/title.txt
figlet $LONG_MESSAGE > package_dir/usr/bin/title.txt

touch package_dir/usr/bin/title_short.txt
figlet $SHORT_MESSAGE_UP > package_dir/usr/bin/title_short.txt
figlet $SHORT_MESSAGE_DOWN >> package_dir/usr/bin/title_short.txt

cp husarion-motd.base package_dir/usr/bin/husarion-motd

echo "
husarion_logo=r'''" >> package_dir/usr/bin/husarion-motd
echo "$(cat package_dir/usr/bin/husarion_logo.txt)" >> package_dir/usr/bin/husarion-motd

echo "'''
title=r'''" >> package_dir/usr/bin/husarion-motd
echo "$(cat package_dir/usr/bin/title.txt)" >> package_dir/usr/bin/husarion-motd

echo "'''
title_short=r'''" >> package_dir/usr/bin/husarion-motd
echo "$(cat package_dir/usr/bin/title_short.txt)" >> package_dir/usr/bin/husarion-motd

echo "'''" >> package_dir/usr/bin/husarion-motd

echo "
if __name__ == '__main__':
    main(title, title_short, husarion_logo)" >> package_dir/usr/bin/husarion-motd

rm -rf package_dir/usr/bin/title.txt
rm -rf package_dir/usr/bin/title_short.txt
rm -rf package_dir/usr/bin/title_short.txt

# Set current version
sed -i "s/Version: VERSION/Version: ${VERSION}/g" control.base


for ARCH in $ARCHITECTURES
do
    # Set architecture
    cp -f control.base package_dir/DEBIAN/control
	sed -i "s/Architecture: ARCHITECTURE/Architecture: ${ARCH}/g" package_dir/DEBIAN/control
    dpkg-deb --build package_dir husarion-motd-$PLATFORM-$VERSION-$ARCH.deb
    mv husarion-motd-$PLATFORM-$VERSION-$ARCH.deb ./output/husarion-motd-$PLATFORM-$VERSION-$ARCH.deb
done