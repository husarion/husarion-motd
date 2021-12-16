#!/bin/bash

# Set current version
sed -i "s/Version: VERSION/Version: ${VERSION}/g" package_dir/DEBIAN/control

# Create messagaes
touch package_dir/usr/bin/title.txt
figlet $LONG_MESSAGE > package_dir/usr/bin/title.txt

touch package_dir/usr/bin/title_short.txt
for line in $(echo $SHORT_MESSAGE | tr ";" "\n")
do
    figlet $line >> package_dir/usr/bin/title_short.txt
done



dpkg-deb --build package_dir husarion-motd-$VERSION-multi-arch.deb
mv husarion-motd-$VERSION-multi-arch.deb ./output/husarion-motd-$VERSION-multi-arch.deb