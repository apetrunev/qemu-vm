#!/bin/sh -ex 

DISK=deb10x64.qcow2
ISO=debian-10.10.0-amd64-netinst.iso

test -f $DISK || qemu-img create -f qcow2 -o size=8G $DISK

enable () {
  case $1 in
  display_resolution)
    display_resolution="on"
    ;;
  boot_from_cd)
    boot_from_cd="on"
    ;;
  display_with_gtk)
    display_with_gtk="on"
    ;; 
  esac
}

unset display_resolution
unset display_with_gtk
unset boot_from_cd

enable display_resolution
enable display_with_gtk

qemu-system-x86_64 \
-machine type=q35,accel=kvm \
-cpu kvm64 \
-m 2G,slots=2,maxmem=4G \
${boot_from_cd:+-boot once=d} \
-cdrom $ISO \
-device qemu-xhci \
-device usb-mouse \
-device usb-kbd \
${display_with_gtk:+-display gtk,grab-on-hover=off,gl=off} \
${display_resolution:+-device VGA,edid=on,xres=1440,yres=900} \
-vga std \
-nic user,net=192.168.65.0/24,hostfwd=tcp::2222-:22 \
$DISK

