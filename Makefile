default:
	bash build.sh

rebuild:
	rm -v *.deb &
	bash build.sh

install:
	dpkg -i linux-image*.deb &&
	dpkg -i linux-headers*.deb

debug:
	bash build.sh -v

clean:
	rm -rv linux-*/ &
	rm -rv *.tar &
	rm -rv *-coldkernel-*
	
distclean: 
	rm -rv linux-* &
	rm -rvf patches
