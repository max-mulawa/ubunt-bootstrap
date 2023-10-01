---
id: dmxsiiwdw2qttdsx5i7qdv1
title: Disk Encryption
desc: ''
updated: 1676448509686
created: 1676448482225
---


# Change cryptsetup passphrase https://www.cyberciti.biz/security/how-to-change-luks-disk-encryption-passphrase-in-linux/  
```bash
ls /dev/nv 
sudo fdisk -l /dev/nvme0n1 
sudo cryptsetup luksDump /dev/nvme0n1p3 
sudo cryptsetup --verbose open --test-passphrase /dev/nvme0n1p3 
sudo cryptsetup luksChangeKey /dev/nvme0n1p3 -S 0 //change passphrase 
sudo cryptsetup --verbose open --test-passphrase /dev/nvme0n1p3 

#Or  
gnome-disks #and enter passphrase 
```