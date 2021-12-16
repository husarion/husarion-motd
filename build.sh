#!/bin/bash

# Create messagaes
touch package_dir/usr/bin/title.txt
figlet $LONG_MESSAGE > package_dir/usr/bin/title.txt

touch package_dir/usr/bin/title_short.txt
for line in $(echo -e $SHORT_MESSAGE | tr ' ' '_')
do
    figlet $(echo $line | tr '_' ' ') >> package_dir/usr/bin/title_short.txt
done


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

architectures=( arm64 armhf amd64 )
for ARCHITECTURE in "${architectures[@]}"
do
    # Set architecture
    cp -f control.base package_dir/DEBIAN/control
	sed -i "s/Architecture: ARCHITECTURE/Architecture: ${ARCHITECTURE}/g" package_dir/DEBIAN/control
    dpkg-deb --build package_dir husarion-motd-$VERSION-$ARCHITECTURE.deb
    mv husarion-motd-$VERSION-$ARCHITECTURE.deb ./output/husarion-motd-$VERSION-$ARCHITECTURE.deb
done
