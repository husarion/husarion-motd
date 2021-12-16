# husarion-motd

Welcome message for Linux-based Husarion devices

## Building

To build the package you need `docker`:

```bash
docker build -t husarion-motod-builder .
docker container run --rm \
    -e VERSION='1.0.3' \
    -e LONG_MESSAGE='ROSbot 2.0 PRO' \
    -e SHORT_MESSAGE='ROSbot;2.0 PRO' \
    -v ${PWD}/output:/output \
    husarion-motod-builder \
    ./build.sh
```
Final deb package will appear in */output* directory. For shorter messages use `\n` to separate new lines. Created packages are multi-arch.
