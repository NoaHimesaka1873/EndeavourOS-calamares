#!/bin/bash

_make_pacstrap_calamares(){

if [ ! -f "/etc/calamares/scripts/pacstrap_calamares" ]

then

sed -e '/chroot_add_mount proc/d' -e '/chroot_add_mount sys/d' -e '/ignore_error chroot_maybe_add_mount/d' -e '/chroot_add_mount udev/d' -e '/chroot_add_mount devpts/d' -e '/chroot_add_mount shm/d' -e '/chroot_add_mount \/run/d' -e '/chroot_add_mount tmp/d' -e '/efivarfs \"/d' /usr/bin/pacstrap >/etc/calamares/scripts/pacstrap_calamares
chmod +x /etc/calamares/scripts/pacstrap_calamares

fi

}
  
# Install base system + endeavouros packages + copy necessary config files

_packages_array=(
base
base-devel
btrfs-progs
cryptsetup
device-mapper
diffutils
dosfstools
e2fsprogs
efibootmgr
endeavouros-keyring
endeavouros-mirrorlist
exfatprogs
f2fs-tools
grub2-theme-endeavouros
inetutils
jfsutils
less
linux-t2
linux-firmware
linux-t2-headers
apple-ibridge-dkms-git
apple-bcm-wifi-firmware
logrotate
lsb-release
lvm2
man-db
man-pages
mdadm
mkinitcpio-busybox
mkinitcpio-nfs-utils
mkinitcpio-openswap
nano
netctl
ntfs-3g
os-prober
perl
python
reiserfsprogs
s-nail
sudo grub
sysfsutils
systemd-sysvcompat
texinfo
usbutils
which
xfsprogs
xterm mkinitcpio
)

_chroot_path=$(cat /tmp/chrootpath.txt) # can't be stored as string

_pacstrap="/etc/calamares/scripts/pacstrap_calamares -c"

for pkgs in "${_packages_array[*]}"
do
    $_pacstrap -c $_chroot_path $pkgs
done

# run_once needed to be present for chrooted_cleaner_script to detect online install
touch /tmp/run_once

_files_to_copy=(

#/etc/calamares/scripts/{chrooted_cleaner_script,cleaner_script}.sh
/etc/pacman.conf
/tmp/run_once
/etc/default/grub
/etc/mkinitcpio.conf

)

for copy_files in "${_files_to_copy[@]}"
do
    rsync -vaRI $copy_files $_chroot_path
done

}

############ SCRIPT STARTS HERE ############
_make_pacstrap_calamares
############ SCRIPT ENDS HERE ##############
