# husarion-motd

Welcome message for Linux-based Husarion devices.

## Building

Building process is handled inside docker container so make sure you have it installed.

### Single platform

```bash
docker build -t husarion-motod-builder .
docker container run --rm \
    -e VERSION='1.0.3' \
    -e PLATFORM='rosbot-2.0'
    -e LONG_MESSAGE='ROSbot 2.0 PRO' \
    -e SHORT_MESSAGE_UP='ROSbot'
    -e SHORT_MESSAGE_DOWN='2.0 PRO' \
    -e ARCHITECTURES='arm64' \
    -v ${PWD}/output:/output \
    husarion-motod-builder \
    ./build_package.sh
```
Final deb package will appear in */output* directory as *husarion-motd-rosbot-2.0-1.0.3-arm64.deb*.
Environment variables:
- `VERSION`: version of deb package.
- `PLATFORM`: platform / robot name.
- `LONG_MESSAGE`: robot name to appear at full length.
- `SHORT_MESSAGE_UP`: upper part of robot name to appear at shorter length.
- `SHORT_MESSAGE_DOWN`: lower part to appear at shorten length.
- `ARCHITECTURES`: deb package architectures. For multiple architectures separate them with spaces, eg: 'amd64 arm64 armhf'.


### Multiple platforms from YAML

YAML file allows to automate the above process by specifying platforms and their configs in single file.

New platform is added by entering new item. Parameters of this item are exactly the same as for environment variables, but written in lower case. Example below will create three files:
- *husarion-motd-rosbot-2.0-1.0.3-arm64.deb*
- *husarion-motd-rosbot-2.0-pro-1.0.3-arm64.deb*
- *husarion-motd-rosbot-2.0-pro-1.0.3-amd64.deb*

``` yaml
rosbot-2.0:
    short_msg_up: 'ROSbot'
    short_msg_down: '2.0'
    long_msg: 'ROSbot 2.0'
    architectures: [arm64]

rosbot-2.0-pro:
    short_msg_up: 'ROSbot'
    short_msg_down: '2.0 PRO'
    long_msg: 'ROSbot 2.0 PRO'
    architectures: [arm64, amd64]
```