release:
	mkdir -p dist
	mkdir -p dist/xml2rfc
	cd help; make
	cp help/xml2rfc_help.jar dist/xml2rfc
	cp xml2rfc.jar dist/xml2rfc
	tar --exclude CVS --exclude '*~' -cf - xml2rfc | tar -C dist -xvf -
	cd dist; zip -r xml2rfc-xxe-`cat xml2rfc/version.txt`.zip xml2rfc
