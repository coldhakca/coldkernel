default:
	@bash build.sh

install-deb:
	@dpkg -i linux-image*.deb &&
	@dpkg -i linux-headers*.deb

install-rpm:
	@yum localinstall kernel-*

debug:
	@bash build.sh -v

clean:
	@rm -rv linux-*/ &
	@rm -rv *.tar &
	@rm -rv *-coldkernel-* &
	@rm -rv *_coldkernel_*

distclean: 
	@rm -rv linux-* &
	@rm -rvf patches &
	@rm -rv kernel-*
