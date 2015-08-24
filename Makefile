default:
	bash build.sh

debug:
	bash build.sh -v

update:
	git pull

clean:
	rm -r linux-*
	rm grsecurity*

debclean:
	rm *.deb
