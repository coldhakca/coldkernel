default:
	bash build.sh

rebuild:
	rm *.deb &
	bash build.sh

install:
	dpkg -i *.deb	

debug:
	bash build.sh -v

clean:
	rm -r linux-*
