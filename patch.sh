#!/bin/sh

adb wait-for-device
target=/data/local/tmp

[ -f "ramdisk.img" ] && adb -e push ramdisk.img $target/ramdisk.img.gz || {
    echo "ERROR: no ramdisk.img" && exit 1
}

[ -f "busybox" ] && adb -e push busybox $target/busybox || {
    echo "ERROR: no busybox" && exit 0
}

if [ ! -f magisk.apk ]; then
    ver=v26.0
    echo "not exists, try to download magisk-${ver}..."
    curl -L https://github.com/topjohnwu/Magisk/releases/download/${ver}/Magisk-${ver}.apk -o magisk.apk
fi

adb -e push magisk.apk $target/magisk.zip
adb -e push process.sh $target
adb -e shell "dos2unix $target/process.sh"
adb -e shell "sh $target/process.sh $target $1"
adb -e pull $target/ramdisk.img
