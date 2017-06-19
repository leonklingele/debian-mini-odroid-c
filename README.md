Debian for ODROID
=================

Script to build a minimal Debian sd card image.

## Features:
* Supports ODROID-C1 and ODROID-C2
* Supports building Wheezy (ODROID-C1 only), Jessie or Stretch (default) images (specify using the DIST variable)
* SSH root login via PubKey
* Host name: odroidc-MACADDRESS (e.g. odroidc-1a2b3c4d5e6f)
* If built with ROOT_RW=no the image will have a read-only root file system: /tmp, /root, /var/log, /media are tmpfs file systems and are writable, but won't persist
* SSH host keys are generated and saved permanently on first boot
* Automatic mounting of USB storage devices using usbmount

## Prerequisites:
Docker

or

On a x86 based Ubuntu system, make sure the following packages are installed:
```
sudo apt-get install sudo build-essential wget git lzop u-boot-tools binfmt-support \
                     qemu qemu-user-static debootstrap parted bc udev dosfstool
```

If you are running 64 bit Ubuntu, you might need to run the following commands to be able to launch the 32 bit toolchain:
```
sudo dpkg --add-architecture i386
sudo apt-get update
sudo apt-get install libc6:i386 libncurses5:i386 libstdc++6:i386 lib32z1
```

## Build the image (without Docker):
Just use the make utility to build e.g. an sdcard-c2-stretch.img.  Be sure to run this with sudo, as root privileges are required to mount the image.
```
sudo make ODROID=c2 DIST=stretch ROOT_RW=yes IMAGE_MB=2048 SSH_PUBLIC_KEY_FILE="$HOME/.ssh/id_rsa.pub"
```

This will install the toolchains, compile u-boot, the kernel, bootstrap Debian and create a 1024mb sdcard-c1-stretch.img file, which then can be transferred to a sd card (e.g. using dd):
```
sudo dd bs=1M if=sdcard-c2-stretch.img of=/dev/YOUR_SD_CARD && sync
```

## Build the image (with Docker):
```
# First build the Docker image
docker build -t build-debian-odroid-image .

# Then build the image
./docker/build "c2" "stretch" "yes" "$(cat "$HOME/.ssh/id_rsa.pub")"
```

## Customize your image:
It should be fairly easy to customize your image for your own needs.  You can drop scripts into the `postinst` folder and add patches to the `patches` folder, as well as add any files you want as part of the root file system into the `files` folder.  This should allow you install extra packages (e.g. using apt-get) and modify configurations to your needs.  Of course, you can do all this manually after booting the device, but the goal of this project is to be able to generate re-usable images that can be deployed on any number of ODROID-C1 devices (think of it as "firmware" of a consumer device).
