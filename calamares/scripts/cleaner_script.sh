#!/usr/bin/env bash

# Made by fernandomaroto for EndeavourOS and Portergos
# Adapted from AIS. An excellent bit of code!
# ISO-NEXT specific cleanup removals and additions (08-2021) @killajoe and @manuel
# 01-2022 passing in root path and username as params - @dalto

_cleaner_msg() {            # use this to provide all user messages (info, warning, error, ...)
    local type="$1"
    local msg="$2"
    echo "==> $type: $msg"
}

# parse the options
for i in "$@"; do
    case $i in
        --root=*)
            ROOT_PATH="${i#*=}"
            shift
        ;;
        --user=*)
            NEW_USER="${i#*=}"
            shift
        ;;
    esac
done

if [ -f /tmp/chrootpath.txt ]
then
    chroot_path=$(echo ${ROOT_PATH} |sed 's/\/tmp\///')
else
    chroot_path=$(lsblk |grep "calamares-root" |awk '{ print $NF }' |sed -e 's/\/tmp\///' -e 's/\/.*$//' |tail -n1)
fi

if [ -z "$chroot_path" ] ; then
    _cleaner_msg "Fatal error" "cleaner_script.sh: chroot_path is empty!"
fi

arch_chroot(){
# Use chroot not arch-chroot because of the way calamares mounts partitions
    chroot /tmp/$chroot_path /bin/bash -c "${1}"
}  

# Anything to be executed outside chroot need to be here.

# Copy any file from live environment to new system

cp -f /etc/skel/.bashrc /tmp/$chroot_path/home/$NEW_USER/.bashrc
cp -f /etc/calamares/files/environment /tmp/$chroot_path/etc/environment
#cp -rf /home/liveuser/.gnupg/gpg.conf /tmp/$chroot_path/etc/pacman.d/gnupg/gpg.conf

_CopyFileToTarget() {
    # Copy a file to target

    local file="$1"
    local targetdir="$2"

    if [ ! -r "$file" ] ; then
        _cleaner_msg warning "file '$file' does not exist."
        return
    fi
    if [ ! -d "$targetdir" ] ; then
        _cleaner_msg warning "folder '$targetdir' does not exist."
        return
    fi
    _cleaner_msg info "copying $(basename "$file") to target"
    cp "$file" "$targetdir"
}

_copy_files(){
    local config_file
    local target=/tmp/$chroot_path            # $target refers to the / folder of the installed system

    if [ -r /home/liveuser/setup.url ] ; then
        # Is this needed anymore?
        # /home/liveuser/setup.url contains the URL to personal setup.sh
        local URL="$(cat /home/liveuser/setup.url)"
        if (wget -q -O /home/liveuser/setup.sh "$URL") ; then
            _cleaner_msg info "copying setup.sh to target"
            cp /home/liveuser/setup.sh $target/tmp/   # into /tmp/setup.sh of chrooted
        fi
    fi

    local card=no
    local driver=no
    echo "nvidia_card=$card"     >> $nvidia_file
    echo "nvidia_driver=$driver" >> $nvidia_file

    # copy user_commands.bash
    _CopyFileToTarget /home/liveuser/user_commands.bash $target/tmp

    # copy 30-touchpad.conf Xorg config file
    _cleaner_msg info "copying 30-touchpad.conf to target"
    mkdir -p $target/usr/share/X11/xorg.conf.d
    cp /usr/share/X11/xorg.conf.d/30-touchpad.conf  $target/usr/share/X11/xorg.conf.d/

    # copy endeavouros-release file
    local file=/usr/lib/endeavouros-release
    if [ -r $file ] ; then
        if [ ! -r $target$file ] ; then
            _cleaner_msg info "copying $file to target"
            rsync -vaRI $file $target
        fi
    else
        _cleaner_msg warning "$FUNCNAME: file $file does not exist in the ISO, copy to target failed!"
    fi
}

_copy_files
