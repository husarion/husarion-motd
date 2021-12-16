docker build -t husarion-motod-builder .
docker container run --rm \
    -e VERSION='1.0.3' \
    -e LONG_MESSAGE='ROSbot 2.0' \
    -e SHORT_MESSAGE='ROSbot\n2.0 PRO' \
    -v ${PWD}/output:/output \
    husarion-motod-builder \
    ./build.sh