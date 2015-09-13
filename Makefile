default:
	bash build.sh

debug:
	bash build.sh -v

clean:
	rm -r linux-*
	rm grsecurity*

debclean:
	rm *.deb
