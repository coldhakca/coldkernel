default:
	bash build.sh

clean:
	rm -r linux-*
	rm grsecurity*

debclean:
	rm *.deb
