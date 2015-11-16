default:
	bash build.sh

rebuild:
	rm -v *.deb &
	bash build.sh

install:
	dpkg -i *.deb

debug:
	bash build.sh -v

clean:
	rm -rv linux-*/ &
	rm -rv *.deb &
	rm -rv *.tar

distclean: 
	rm -rv linux-* &
	rm -rv patches
