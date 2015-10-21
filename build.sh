#!/bin/bash
# ColdKernel build script
# build 0.3a
# 4.2.3-grsec-coldkernel
# ColdHak (C. // J. // R. // T.)

source "$(pwd)/spinner.sh"

KERNEL=https://www.kernel.org/pub/linux/kernel/v4.x
KERNEL_VERSION=linux-4.2.3
NUM_CPUS=`grep processor /proc/cpuinfo | wc -l`

# Fetch Greg & Spender's keys
function import_keys () {
    gpg --homedir=./.gnupg --import ./keys/greg.asc
    gpg --homedir=./.gnupg --import ./keys/spender.asc
}

# Fetch Linux Kernel sources and signatures
function get_kernel () {
    wget -c $KERNEL/$KERNEL_VERSION.tar.{sign,xz}
}

# Fetch Kernel patch sources and signatures
function get_patches () {
if [ ! -d patches ]
then
    git clone https://github.com/coldhakca/deepfreeze patches
else
    cd patches
    git pull
    cd ..
fi
}

# Unxz Kernel
function unpack_kernel () {
    unxz $KERNEL_VERSION.tar.xz
}

# Verify Linux Kernel sources
function verify_kernel () {
    gpg --homedir=./.gnupg --verify $KERNEL_VERSION.{tar.sign,tar}
}

# Verify Kernel patches
function verify_patches () {
    gpg --homedir=./.gnupg --verify ./patches/grsecurity/grsecurity-*.{patch.sig,patch}
}

# Extract Linux Kernel
function extract_kernel () {
    tar -xvf $KERNEL_VERSION.tar
}

# Patch the kernel with grsec, and apply coldkernel config
function patch_kernel () {
    cd $KERNEL_VERSION &&
    patch -p1 < ../patches/grsecurity/grsecurity-*.patch
    cp ../coldkernel.config .config
}

# Build coldkernel on Debian
function build_kernel () {
    fakeroot make -j $NUM_CPUS deb-pkg 
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

case "$1" in
                -v)
                import_keys &&
                get_kernel &&
                get_patches &&
                unpack_kernel &&
                verify_kernel &&
                verify_patches &&
                extract_kernel &&
                patch_kernel &&
                build_kernel
                exit 0;;

		*)
		start_spinner "Importing signing keys..."
		import_keys > /dev/null 2>&1 &&
		stop_spinner $?
		start_spinner "Fetching kernel sources and signatures..."
		get_kernel > /dev/null 2>&1 &&
		stop_spinner $?
		start_spinner "Fetching grsecurity patch and signatures..."
		get_patches > /dev/null 2>&1 &&
		stop_spinner $?
		start_spinner "Unpacking Linux Kernel sources..."
		unpack_kernel > /dev/null 2>&1 &&
		stop_spinner $?
		start_spinner "Verifying the Linux Kernel sources..."
		verify_kernel > /dev/null 2>&1 &&
		stop_spinner $?
		start_spinner "Verifying Kernel patches..."
		verify_patches > /dev/null 2>&1 &&
		stop_spinner $?
		start_spinner "Extracting Linux Kernel sources..."
		extract_kernel > /dev/null 2>&1 &&
		stop_spinner $?
		start_spinner "Applying grsecurity patch, and moving coldkernel.config into place..."
		patch_kernel > /dev/null 2>&1 &&
		stop_spinner $?
		start_spinner "Building coldkernel..."
		build_kernel > /dev/null 2>&1
		stop_spinner $?
		exit 0;;
esac
