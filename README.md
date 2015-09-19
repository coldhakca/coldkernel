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
wget "https://db.torproject.org/fetchkey.cgi?fingerprint=726824BE9D8D5CF009C5F039FF9D1C57779FB883" -O phoul.asc
gpg --import phoul.asc
git clone https://github.com/coldhakca/coldkernel
cd coldkernel
git verify-tag coldkernel-0.2a-4.1.7
git checkout tags/coldkernel-0.2a-4.1.7
make
```

Once built
----------
```
wget https://grsecurity.net/paxctld/paxctld_1.0-2_amd64.{deb,deb.sig}
gpg --verify paxctld_1.0-2_amd64.{deb.sig,deb}
sudo dpkg -i paxctld_1.0-2_amd64.deb
sudo dpkg -i linux-*.deb
sudo cp paxctld.conf /etc/paxctld.conf
sudo paxctld -d
sudo update-rc.d paxctld enable
sudo reboot
```
Note: Some of the above may not exist on your system, this is OK.

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

