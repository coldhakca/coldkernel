default:
	bash build.sh

rebuild:
	rm *.deb &
	bash build.sh

update:
	git pull 
	git verify-tag coldkernel-0.4a-4.2.4
	git checkout tags/coldkernel-0.4a-4.2.4
	rm -r linux-* &
	bash build.sh

install:
	dpkg -i *.deb	

debug:
	bash build.sh -v

clean:
	rm -r linux-*

