# husarion-motd

Welcome message for Linux-based Husarion robots.

## Building

Building process is handled inside docker container so make sure you have it installed.

### Single platform

```bash
mkdir output
docker build -t husarion-motod-builder .
docker container run --rm \
    -e VERSION='2.0.1' \
    -e PLATFORM='rosbot-2r' \
    -e LONG_MESSAGE='ROSbot 2R' \
    -e SHORT_MESSAGE_UP='ROSbot'
    -e SHORT_MESSAGE_DOWN='2R' \
    -e ARCHITECTURES='arm64' \
    -v ${PWD}/output:/output \
    husarion-motod-builder \
    ./build_package.sh
```
Final deb package will appear in */output* directory as *husarion-motd-rosbot-2r-2.0.1-arm64.deb*.
Environment variables:
- `VERSION`: version of deb package.
- `PLATFORM`: platform or robot name.
- `LONG_MESSAGE`: robot name to appear at full length.
- `SHORT_MESSAGE_UP`: upper part of robot name to appear at shorter length.
- `SHORT_MESSAGE_DOWN`: lower part to appear at shorten length.
- `ARCHITECTURES`: deb package architectures. For multiple architectures separate them with spaces, eg: **'amd64 arm64 armhf'**.


### Multiple platforms from YAML

```bash
mkdir output
docker build -t husarion-motod-builder .
docker container run --rm \
    -e VERSION='2.0.1' \
    -v ${PWD}/output:/output \
    husarion-motod-builder \
    ./build_platforms.py
```


YAML file allows to automate the above process by specifying platforms and their configs in single file.

New platform is added by entering new item. Parameters of this item are exactly the same as for environment variables, but written in lower case. Below YAML example will create three following files:
- *husarion-motd-rosbot-2r-2.0.1-arm64.deb*
- *husarion-motd-rosbot-xl-2.0.1-arm64.deb*
- *husarion-motd-rosbot-xl-2.0.1-amd64.deb*

Note there are two files for ROSbot XL. One for **amd64** and one for **arm64** architecture.

``` yaml
rosbot-2r:
    short_msg_up: 'ROSbot'
    short_msg_down: '2R'
    long_msg: 'ROSbot 2R'
    architectures: [arm64]

rosbot-xl:
    short_msg_up: 'ROSbot'
    short_msg_down: 'XL'
    long_msg: 'ROSbot XL'
    architectures: [arm64, amd64]
```

### OS requirements
Field `Board` requires environment variable `SBC_NAME_FANCY`. This is used to set custom SBC name such as **Raspberry Pi 4b**.