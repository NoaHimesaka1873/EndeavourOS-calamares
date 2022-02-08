#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import libcalamares
import subprocess
from libcalamares.utils import check_target_env_call, target_env_call
from libcalamares.utils import *

def run():
    """ Copy kernel and install scripts to target system.

    :return:
    """

    root_mount_point = libcalamares.globalstorage.value("rootMountPoint")

    # Copy kernels
    try:
     subprocess.check_call(["cp", "/run/archiso/bootmnt/arch/boot/x86_64/vmlinuz", root_mount_point + "/boot/vmlinuz-linux"])
    except:
     pass # doing nothing on exception
    try:
     subprocess.check_call(["cp", "/run/archiso/bootmnt/arch/boot/x86_64/vmlinuz-lts", root_mount_point + "/boot/vmlinuz-linux-lts"])
    except:
     pass # doing nothing on exception
    # New archiso kernel names
    try:
     subprocess.check_call(["cp", "/run/archiso/bootmnt/arch/boot/x86_64/vmlinuz-linux", root_mount_point + "/boot/vmlinuz-linux"])
    except:
     pass # doing nothing on exception
    try:
     subprocess.check_call(["cp", "/run/archiso/bootmnt/arch/boot/x86_64/vmlinuz-linux-t2", root_mount_point + "/boot/vmlinuz-linux-t2"])
    except:
     pass # doing nothing on exception

    # Copy cleaner script for install process
    try:
     subprocess.check_call(["cp", "-f", "/usr/bin/cleaner_script.sh", root_mount_point + "/usr/bin"])
    except:
     pass # doing nothing on exception
    try:
     subprocess.check_call(["cp", "-f", "/usr/bin/chrooted_cleaner_script.sh", root_mount_point + "/usr/bin"])
    except:
     pass # doing nothing on exception

    return None
