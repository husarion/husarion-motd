FROM ubuntu:20.04

ENV VERSION "1.0.0"
ENV LONG_MESSAGE "ROSbot 2.0"
ENV SHORT_MESSAGE "ROSbot;2.0"

# Install ASCII text creator and debian package manager
RUN apt update && apt install -y figlet dpkg

# Create file tree
RUN mkdir package_dir \
    && mkdir -p package_dir/DEBIAN \
    && mkdir -p package_dir/etc \
    && mkdir -p package_dir/etc/profile.d/ \
    && mkdir -p package_dir/usr \
    && mkdir -p package_dir/usr/bin

# Package info
COPY ./control package_dir/DEBIAN/control

# First install script
COPY ./postinst package_dir/DEBIAN/postinst
RUN chmod a+x package_dir/DEBIAN/postinst

# Script execution
COPY ./husarion-motd.sh package_dir/etc/profile.d/husarion-motd.sh
RUN chmod a+x package_dir/etc/profile.d/husarion-motd.sh

# Setup motod script
COPY ./husarion_motd.py package_dir/usr/bin/husarion-motd
RUN chmod a+x package_dir/usr/bin/husarion-motd

RUN mkdir output
COPY ./build.sh ./build.sh