#!/usr/bin/python3

import os
import yaml
import subprocess

if __name__ == '__main__':
    with open("./platforms.yaml", "r") as file:
        try:
            platforms = yaml.safe_load(file)
        except yaml.YAMLError as exc:
            print(exc)

    for platform in platforms:
        os.environ['PLATFORM'] = platform
        os.environ['SHORT_MESSAGE_UP'] = platforms[platform]['short_msg_up']
        os.environ['SHORT_MESSAGE_DOWN'] = platforms[platform]['short_msg_down']
        os.environ['LONG_MESSAGE'] = platforms[platform]['long_msg']
        os.environ['ARCHITECTURES'] = ' '.join(platforms[platform]['architectures'])
        subprocess.call('./build_package.sh')
