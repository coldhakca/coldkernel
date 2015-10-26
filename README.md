coldkernel 
==========
coldkernel is an attempt at automating the build process of grsec-enabled kernels on Debian/Ubuntu. 

Dependencies
------------
```
sudo apt-get install paxctl bc wget gnupg fakeroot build-essential devscripts libfile-fcntllock-perl curl git
sudo apt-get build-dep linux
sudo apt-get install gcc-4.9-plugin-dev (replace with the version appropriate for your gcc version)
```

Clone / Build
-------------
```
wget "https://coldhak.ca/coldhak/keys/colin.asc" -O colin.asc
gpg --import colin.asc
git clone https://github.com/coldhakca/coldkernel
cd coldkernel
git verify-tag coldkernel-0.4b-4.2.4
git checkout tags/coldkernel-0.4b-4.2.4
make
```

Once built
----------
```
wget https://grsecurity.net/paxctld/paxctld_1.0-2_amd64.{deb,deb.sig}
gpg --verify paxctld_1.0-2_amd64.{deb.sig,deb}
sudo dpkg -i paxctld_1.0-2_amd64.deb
sudo make install
sudo cp paxctld.conf /etc/paxctld.conf
sudo paxctld -d
sudo update-rc.d paxctld enable
sudo reboot
```

GIDs and group creation
-----------------------
* TPE-trusted(CONFIG_GRKERNSEC_TPE_TRUSTED_GID) = ```1005```
* Deny sockets(CONFIG_GRKERNSEC_SOCKET_ALL)  = ```1004```
* PROC usergroup(GRKERNSEC_PROC_USERGROUP) = ```1001```

```
sudo groupadd -g 1005 tpe
sudo groupadd -g 1004 denysockets
sudo groupadd -g 1001 grsecproc
```

Important Notice
-----------------
This is still extremely alpha. If it breaks, you get to keep the pieces. There is currently support for x86_64 only.

