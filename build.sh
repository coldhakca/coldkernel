#!/bin/bash
# ColdKernel build script
# build 0.1a
# 4.0.7-grsec-coldkernel
# ColdHak (C. // J. // R. // T.)

source "$(pwd)/spinner.sh"

GRSECURITY=https://grsecurity.net/test/
GRSECURITY_VERSION="$(curl --silent https://grsecurity.net/testing_rss.php | sed -ne 's/.*\(http[^"]*\).patch/\1/p' | sed 's/<.*//' | sed 's/^.*grsecurity-3.1-4.0.7/grsecurity-3.1-4.0.7/' | sed -n '1p')"
KERNEL=https://www.kernel.org/pub/linux/kernel/v4.x
KERNEL_VERSION=linux-4.0.7

# Fetch Greg & Spender's keys
function get_keys () {
    start_spinner "Receiving Greg Kroah-Hartman's signing key..."
    gpg -q --recv-key 647F28654894E3BD457199BE38DBBDC86092693E > /dev/null 2>&1 &&
    stop_spinner $?
    start_spinner "Receiving Spender's signing key..."
    gpg -q --recv-key DE9452CE46F42094907F108B44D1C0F82525FE49 > /dev/null 2>&1 
    stop_spinner $?
}

# Fetch Linux Kernel sources and signatures
function get_kernel () {
    start_spinner "Fetching kernel sources and signatures..."
    wget --no-clobber $KERNEL/$KERNEL_VERSION.tar.{sign,xz} > /dev/null 2>&1
    stop_spinner $?
}

# Fetch Kernel patch sources and signatures
function get_patches () {
    start_spinner "Fetching grsecurity patch and signatures..."
    wget --no-clobber $GRSECURITY/$GRSECURITY_VERSION.{patch.sig,patch} > /dev/null 2>&1
    stop_spinner $?
}

# Unxz Kernel
function unpack_kernel () {
    start_spinner "Unpacking Linux Kernel sources..."
    unxz $KERNEL_VERSION.tar.xz
    stop_spinner $?
}

# Verify Linux Kernel sources
function verify_kernel () {
    start_spinner "Verifying the Linux Kernel sources..."
    gpg --verify $KERNEL_VERSION.{tar.sign,tar} > /dev/null 2>&1
    stop_spinner $?
}

# Verify Kernel patches
function verify_patches () {
    start_spinner "Verifying Kernel patches..."
    gpg --verify $GRSECURITY_VERSION.{patch.sig,patch} > /dev/null 2>&1
    stop_spinner $?
}

# Extract Linux Kernel
function extract_kernel () {
    start_spinner "Extracting Linux Kernel sources..."
    tar -xf $KERNEL_VERSION.tar
    stop_spinner $?
}

# Patch the kernel with grsec, and apply coldkernel config
function patch_kernel () {
    start_spinner "Applying grsecurity patch, and moving coldkernel.config into place..."
    cd $KERNEL_VERSION &&
    patch -s -p1 < ../$GRSECURITY_VERSION.patch
    cp ../coldkernel.config .config > /dev/null 2>&1
    stop_spinner $?
}

# Build coldkernel on Debian
function build_kernel () {
    start_spinner "Building coldkernel..."
    fakeroot make deb-pkg > /dev/null 2>&1
    stop_spinner $?
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

