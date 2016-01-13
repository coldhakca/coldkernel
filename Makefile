default:
	@bash build.sh

install:
	@if [ -f *.rpm ] ; \
		then \
			yum localinstall kernel-*.rpm ; \
	fi;
	@if [ -f *.deb ] ; \
		then \
			dpkg -i linux-image*.deb linux-headers*.deb
	fi;

debug:
	@bash build.sh -v

clean:
	@if [ -d linux-*/ ] ; \
		then \
			rm -rv linux-*/ ; \
	fi;
	@if [ -f *.tar ] ; \
		then \
			rm -rv *.tar ; \
	fi;
	@if [ -f *-coldkernel-* ] ; \
		then \
			rm -rv *-coldkernel-* ; \
	fi;
	@if [ -f *_coldkernel_* ] ; \
		then \
			rm -rv *_coldkernel_* ; \
	fi;

distclean:
	@if [ -e linux-* ] ; \
		then \
			rm -rv linux-* ; \
	fi;
	@if [ -d patches ] ; \
		then \
			rm -rvf patches ; \
	fi;
