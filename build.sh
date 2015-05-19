#!/bin/bash
# ColdKernel build script
# build 0.1a
# 4.0.4-grsec-coldkernel
# ColdHak (C. // J. // R. // T.)

GRSECURITY=https://grsecurity.net/test/
GRSECURITY_VERSION="$(curl --silent https://grsecurity.net/testing_rss.php | sed -ne 's/.*\(http[^"]*\).patch/\1/p' | sed 's/<.*//' | sed 's/^.*grsecurity-3.1-4.0.4/grsecurity-3.1-4.0.4/' | sed -n '1p')"
KERNEL=https://www.kernel.org/pub/linux/kernel/v4.x
KERNEL_VERSION=linux-4.0.4

# Fetch Greg & Spender's keys
function get_keys () {
    echo "Receiving Greg Kroah-Hartman's signing key"
    gpg --recv-key 647F28654894E3BD457199BE38DBBDC86092693E &&
    echo "Receiving Spender's signing key"
    gpg --recv-key DE9452CE46F42094907F108B44D1C0F82525FE49
}

# Fetch Linux Kernel sources and signatures
function get_kernel () {
    echo "Fetching kernel sources and signatures"
    wget --no-clobber $KERNEL/$KERNEL_VERSION.tar.{sign,xz}
}

# Fetch Kernel patch sources and signatures
function get_patches () {
    echo "Fetching grsecurity patch and signatures"
    wget --no-clobber $GRSECURITY/$GRSECURITY_VERSION.{patch.sig,patch}
}

# Unxz Kernel
function unpack_kernel () {
    echo "Unpacking Linux Kernel sources"
    unxz $KERNEL_VERSION.tar.xz
}

# Verify Linux Kernel sources
function verify_kernel () {
    echo "Verifying the Linux Kernel sources"
    gpg --verify $KERNEL_VERSION.{tar.sign,tar}
}

# Verify Kernel patches
function verify_patches () {
    echo "Verifying Kernel patches"
    gpg --verify $GRSECURITY_VERSION.{patch.sig,patch}
}

# Extract Linux Kernel
function extract_kernel () {
    echo "Extracting Linux Kernel sources"
    tar -vxf $KERNEL_VERSION.tar
}

# Patch the kernel with grsec, and apply coldkernel config
function patch_kernel () {
    echo "Applying grsecurity patch; and moving coldkernel.config into place"
    cd $KERNEL_VERSION &&
    patch -p1 < ../$GRSECURITY_VERSION.patch
    cp ../coldkernel.config .config
}

# Build coldkernel on Debian
function build_kernel () {
    echo "Building coldkernel"
    fakeroot make deb-pkg
}

#	      /\
#	 __   \/   __
#	 \_\_\/\/_/_/
#	   _\_\/_/_
#	  __/_/\_\__
#	 /_/ /\/\ \_\
#	      /\
#	      \/
#
#  ______________________________
#  Do the coldkernel happy dance
#  ------------------------------

get_keys &&
get_kernel &&
get_patches &&
unpack_kernel &&
verify_kernel &&
verify_patches &&
extract_kernel &&
patch_kernel &&
build_kernel

