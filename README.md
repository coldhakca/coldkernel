# coldkernel 

coldkernel is an attempt at automating the build process of grsec-enabled kernels on Debian/Ubuntu. Now with
experimental CentOS support! 

## Dependencies

### Debian 7+
```
sudo apt-get install paxctl bc wget gnupg fakeroot build-essential devscripts libfile-fcntllock-perl curl git
sudo apt-get build-dep linux
sudo apt-get install gcc-4.9-plugin-dev (replace with the version appropriate for your gcc version)
```

### CentOS 7+
```
sudo yum groupinstall "Development Tools"
sudo yum install hmaccalc zlib-devel binutils-devel elfutils-libelf-devel ncurses-devel gcc-plugin-devel wget git gnupg2 bc
```

## Clone / Build

### Clone
```
wget "https://coldhak.ca/coldhak/keys/colin.asc" -O colin.asc
gpg --import colin.asc
git clone https://github.com/coldhakca/coldkernel
cd coldkernel
git verify-tag coldkernel-0.8a-4.4.5
git checkout tags/coldkernel-0.8a-4.4.5
```

### Build
Run ```make``` without arguments to build without hypervisor support. Otherwise, select the option below that best describes
your setup.
```
make kvm-host
make kvm-guest
make virtualbox-host
make virtualbox-guest
make xen-host
make xen-guest
make vmware-host
make vmware-guest
make hyperv-guest
```

## Once built

### Debian 7+
```
wget https://grsecurity.net/paxctld/paxctld_1.1-1_amd64.{deb,deb.sig}
gpg --homedir=.gnupg --verify paxctld_1.1-1_amd64.{deb.sig,deb}
sudo dpkg -i paxctld_1.1-1_amd64.deb
sudo make install-deb
sudo cp paxctld.conf /etc/paxctld.conf
sudo paxctld -d
sudo systemctl enable paxctld
sudo reboot
```

## CentOS 7+
```
wget https://grsecurity.net/paxctld/paxctld-systemd-1.1-1.x86_64.{rpm,rpm.sig}
gpg --homedir=.gnupg --verify paxctld-systemd-1.1-1.x86_64.{rpm.sig,rpm}
sudo yum localinstall paxctld-systemd-1.1-1.x86_64.rpm
sudo make install-rpm
sudo cp paxctld.conf /etc/paxctld.conf
sudo paxctld -d
sudo systemctl enable paxctld
sudo reboot
```

## GIDs
### ```9001```:GRKERNSEC_PROC_USERGROUP 
Users in this group are exempted from grsecurity's /proc restrictions.

###  ```9002```:CONFIG_GRKERNSEC_TPE_UNTRUSTED_GID
Users in this group will not be able to execute any files that are not in root-owned directories writable only by root.

### ```9003```:CONFIG_GRKERNSEC_SOCKET_ALL 
Users in this group will be unable to connect to other hosts from your machine or run server applications from your machine.

## Group Creation
```
sudo groupadd -g 9001 grsecproc
sudo groupadd -g 9002 tpeuntrusted
sudo groupadd -g 9003 denysockets
```

## Important Notice
This is still extremely alpha. If it breaks, you get to keep the pieces. There is currently support for x86_64 only.

