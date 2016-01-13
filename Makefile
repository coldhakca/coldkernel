default:
	@bash build.sh

install:
	@if [ -e *.rpm ] ; \
		then \
			yum localinstall kernel-*.rpm ; \
	fi;
	@if [ -e *.deb ] ; \
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
	@if [ -e *.tar ] ; \
		then \
			rm -rv *.tar ; \
	fi;
	@if [ -e *-coldkernel-* ] ; \
		then \
			rm -rv *-coldkernel-* ; \
	fi;
	@if [ -e *_coldkernel_* ] ; \
		then \
			rm -rv *_coldkernel_* ; \
	fi;

distclean:
	@if [ -f *.sign ] ; \
               then \
                       rm -rv *.sign ; \
       fi
	@if [ -e linux-* ] ; \
		then \
			rm -rv linux-* ; \
	fi;
	@if [ -d patches ] ; \
		then \
			rm -rvf patches ; \
	fi;
