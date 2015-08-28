coldkernel 
==========
coldkernel is an attempt at automating the build process of grsec-enabled kernels on Debian/Ubuntu. 

Place all files into the same directory, and run ```make```. This directory will become messy, so it is encouraged to create a directory specifically for building coldkernel. 

Dependencies
------------
```
sudo apt-get install paxctl bc wget gnupg fakeroot build-essential devscripts libfile-fcntllock-perl curl
sudo apt-get build-dep linux
sudo apt-get install gcc-4.9-plugin-dev (replace with the version appropriate for your gcc version)
```

Once built
----------
```
sudo dpkg -i linux-*.deb
sudo paxctl -Cm /usr/sbin/grub-probe
sudo paxctl -Cm /usr/sbin/grub-mkdevicemap
sudo paxctl -Cm /usr/sbin/grub-setup
sudo paxctl -Cm /usr/bin/grub-script-check
sudo paxctl -Cm /usr/bin/grub-mount
```
Note: Some of the above may not exist on your system, this is OK.

GIDs
----
* TPE-trusted(CONFIG_GRKERNSEC_TPE_TRUSTED_GID) = ```1005```
* Deny sockets(CONFIG_GRKERNSEC_SOCKET_ALL)  = ```1004```
* PROC usergroup(GRKERNSEC_PROC_USERGROUP) = ```1001```

Important Notice
-----------------
This is still extremely alpha. If it breaks, you get to keep the pieces. There is currently support for x86_64 only.

