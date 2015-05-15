coldkernel 
==========
Place all files into same directory, and run ```make```. This directory will become messy, so it is encouraged to create a directory specifically for coldkernel. 

Debian
------
```
apt-get install bc wget gnupg fakeroot build-essential devscripts libfile-fcntllock-perl curl
apt-get build-dep linux
apt-get install gcc-4.9-plugin-dev (replace with the version appropriate for your gcc version)
```

Once built
----------
```
sudo dpkg -i linux-*.deb
```

GIDs
----
TPE-trusted = ```1005```
Deny sockets  = ```1004```

Important Notice
-----------------
This is still extremely alpha. If it breaks, you get to keep the pieces. There is currently support for x86_64 only.

