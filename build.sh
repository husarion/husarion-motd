docker build -t husarion-motod-builder .
docker container run --rm \
    -e VERSION='1.0.3' \
    -v ${PWD}/output:/output \
    husarion-motod-builder \
    ./build_platforms.py