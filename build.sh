#!/bin/bash
# Description = coldkernel build script
# Script version = 0.8f
# Code name = Furious Ferret
# Kernel version = 4.6.4-coldkernel-grsec
# Authors = coldhak (C. // J. // R. // T.)

set -e
trap "mv coldkernel.config.orig coldkernel.config & pkill -f build.sh " 1 2

source "$(pwd)/spinner.sh"

SOURCE=https://www.kernel.org/pub/linux/kernel/v4.x
KERNEL=linux
VERSION=4.6.4
GRSECVERSION=3.1
NUM_CPUS=`grep -c ^processor /proc/cpuinfo`

# Fetch Greg & Spender's keys
function import_keys () {
    gpg --homedir=./.gnupg --import ./keys/greg.asc
    gpg --homedir=./.gnupg --import ./keys/spender.asc
}

# Remove Linux working directory
function remove_wrkdir () {
    if [ ! -d $KERNEL-$VERSION ]
    then
	echo "Directory doesn't exist"
    else
	rm -rv $KERNEL-$VERSION
    fi
}

# Fetch Linux Kernel sources and signatures
function get_kernel () {
    wget -cN $SOURCE/$KERNEL-$VERSION.tar.{sign,xz}
}

# Fetch Kernel patch sources and signatures
function get_patches () {
    if [ ! -d patches ]
    then
	git clone https://github.com/coldhakca/deepfreeze patches -b $VERSION
    else
	cd patches
	git pull
	git checkout $VERSION
	cd ..
    fi
}

# Unxz Kernel
function unpack_kernel () {
    unxz -fk $KERNEL-$VERSION.tar.xz
}

# Verify Linux Kernel sources
function verify_kernel () {
    gpg --homedir=./.gnupg --verify $KERNEL-$VERSION.{tar.sign,tar}
}

# Verify Kernel patches
function verify_patches () {
    gpg --homedir=./.gnupg --verify ./patches/grsecurity/grsecurity-$GRSECVERSION-$VERSION-*.{patch.sig,patch}
}

# Extract Linux Kernel
function extract_kernel () {
    tar -xvf $KERNEL-$VERSION.tar
}

# Patch the kernel with grsec, and apply coldkernel config
function patch_kernel () {
    cd $KERNEL-$VERSION &&
	patch -p1 < ../patches/grsecurity/grsecurity-$GRSECVERSION-$VERSION-*.patch
    cp ../coldkernel.config .config
}

# Build coldkernel
function build_kernel () {
    REVISION=`git --git-dir ../patches/.git log | grep -c $VERSION`
    rm localversion-grsec
    if [ -f /etc/debian_version ]
    then
	fakeroot make bindeb-pkg -j $NUM_CPUS LOCALVERSION=-coldkernel-grsec-$REVISION \
		 KDEB_PKGVERSION=$VERSION-coldkernel-grsec-$REVISION
    elif [ -f /etc/redhat-release ]
    then
	make binrpm-pkg -j $NUM_CPUS LOCALVERSION=-coldkernel-grsec-$REVISION &&
		mv ~/rpmbuild/RPMS/x86_64/kernel-* ..
    else
   	echo "Your system does not appear to be running Debian, Redhat or their derivatives."
	kill -1 $$
fi
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
	    remove_wrkdir &&
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
	 sleep 1
	 stop_spinner $?
	 start_spinner "Removing previous working directory (if one exists)..."
	 remove_wrkdir > /dev/null 2>&1 &&
	 sleep 1
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
