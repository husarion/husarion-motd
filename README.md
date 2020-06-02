# husarion-motd

Welcome message for Linux-based Husarion devices

## Building

To build the package you need `nim`:

```
sudo apt install nim
```

You can use `build.sh` script to preapare `.deb` package:

```
./build.sh
```

Script will create a `.deb` package named according to pattern: `husarion-motd-VERSION-ARCH.deb`

Install it with:

```
sudo dpkg -i husarion-motd-VERSION-ARCH.deb
```

