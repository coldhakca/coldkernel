coldkernel 
==========
coldkernel is an attempt at automating the build process of grsec-enabled kernels on Debian/Ubuntu. 

Dependencies
------------
```
sudo apt-get install paxctl bc wget gnupg fakeroot build-essential devscripts libfile-fcntllock-perl curl git kernel-package
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
git verify-tag coldkernel-0.6a-4.3.3
git checkout tags/coldkernel-0.6a-4.3.3
make
```

Once built
----------
```
wget https://grsecurity.net/paxctld/paxctld_1.0-4_amd64.{deb,deb.sig}
gpg --homedir=.gnupg --verify paxctld_1.0-4_amd64.{deb.sig,deb}
sudo dpkg -i paxctld_1.0-4_amd64.deb
sudo make install
sudo cp paxctld.conf /etc/paxctld.conf
sudo paxctld -d
sudo systemctl enable paxctld
sudo reboot
```

GIDs and group creation
-----------------------
* PROC usergroup(GRKERNSEC_PROC_USERGROUP) = ```9001```
* TPE-untrusted(CONFIG_GRKERNSEC_TPE_UNTRUSTED_GID) = ```9002```
* Deny sockets(CONFIG_GRKERNSEC_SOCKET_ALL)  = ```9003```

```
sudo groupadd -g 9001 grsecproc
sudo groupadd -g 9002 tpe
sudo groupadd -g 9003 denysockets
```

Important Notice
-----------------
This is still extremely alpha. If it breaks, you get to keep the pieces. There is currently support for x86_64 only.

