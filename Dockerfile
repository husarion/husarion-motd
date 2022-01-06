FROM ubuntu:20.04

ENV VERSION "1.0.0"
ENV LONG_MESSAGE "ROSbot 2.0"
ENV SHORT_MESSAGE "ROSbot;2.0"

# Install ASCII text creator, debian package manager and python
RUN apt update \
    && apt install -y \
        figlet \
        dpkg \
        python3 \
        python3-pip

RUN pip3 install pyyaml

# Create file tree
RUN mkdir package_dir \
    && mkdir -p package_dir/DEBIAN \
    && mkdir -p package_dir/etc \
    && mkdir -p package_dir/etc/profile.d/ \
    && mkdir -p package_dir/usr \
    && mkdir -p package_dir/usr/bin

# Package info
COPY ./husarion_motd/deb_pkg/control control.base

# First install script
COPY ./husarion_motd/deb_pkg/postinst package_dir/DEBIAN/postinst
RUN chmod a+x package_dir/DEBIAN/postinst

# Script execution
COPY ./husarion_motd/deb_pkg/husarion-motd.sh package_dir/etc/profile.d/husarion-motd.sh
RUN chmod a+x package_dir/etc/profile.d/husarion-motd.sh

# Copy husarion logo
COPY ./husarion_motd/src/husarion_logo.txt package_dir/usr/bin/husarion_logo.txt

# Setup motod script
COPY ./husarion_motd/src/husarion_motd.py ./husarion-motd.base
RUN chmod a+x ./husarion-motd.base

RUN mkdir output
COPY ./husarion_motd/scripts/build_package.sh ./build_package.sh
COPY ./husarion_motd/scripts/build_platforms.py ./build_platforms.py

# Copy platforms to build
COPY ./platforms.yaml ./platforms.yaml