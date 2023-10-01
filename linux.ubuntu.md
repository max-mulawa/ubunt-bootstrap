---
id: fxpd2un3ezhqxt6o84tqrgs
title: Ubuntu
desc: ''
updated: 1696081247738
created: 1667493670048
---

# Create ISO 

sudo dd bs=4M if=./ubuntu-22.04.1-live-server-amd64.iso of=/dev/sdb conv=fdatasync status=progress
sudo dd bs=4M if=./ubuntu-22.04.1-desktop-amd64.iso of=/dev/sdb conv=fdatasync status=progress


# make monitor dual display work

Lenove P50

During installation I've changed to install also 3rd party software! So by default I had `nvidia-driver-535` installed as the default.


## diagnostics
```bash
ubuntu-drivers devices

....
vendor   : NVIDIA Corporation
model    : GM107GLM [Quadro M1000M]
driver   : nvidia-driver-390 - distro non-free
driver   : nvidia-driver-470-server - distro non-free
driver   : nvidia-driver-470 - distro non-free
driver   : nvidia-driver-535-server - distro non-free
driver   : nvidia-driver-525-server - distro non-free
driver   : nvidia-driver-450-server - distro non-free
driver   : nvidia-driver-525 - distro non-free
driver   : nvidia-driver-535 - distro non-free recommended
driver   : xserver-xorg-video-nouveau - distro free builtin

#### 

lshw -c display #currently used driver

  *-display                 
       description: VGA compatible controller
       product: GM107GLM [Quadro M1000M]
       vendor: NVIDIA Corporation
       physical id: 0
       bus info: pci@0000:01:00.0
       version: a2
       width: 64 bits
       clock: 33MHz
       capabilities: vga_controller bus_master cap_list rom
       configuration: driver=nvidia latency=0
       resources: irq:140 memory:b2000000-b2ffffff memory:a0000000-afffffff memory:b0000000-b1ffffff ioport:4000(size=128) memory:b3080000-b30fffff
  *-graphics
       product: EFI VGA
       physical id: 1
       logical name: /dev/fb0
       capabilities: fb
       configuration: depth=32 resolution=1920,1080
```




## Changes

```bash
prime-select query
prime-select nvidia 

```

### change in BIOS
- disable secure boot (some suggested, I already had this setting on)
- force using NVIDIA graphics card, by selecting `discrete graphics card` this was a game changer here.
