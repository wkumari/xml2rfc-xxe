release:
	mkdir -p dist
	mkdir -p dist/xml2rfc
	cd help; make
	cp help/xml2rfc_help.jar dist/xml2rfc
	# need to get build system in place for xml2rfc.jar
	cp xml2rfc.jar dist/xml2rfc
	#
	# copy all the files from the repository, excluding CVS
	# metadata and xmlmind editor backups.
	tar --exclude CVS --exclude '*~' -cf - xml2rfc | tar -C dist -xvf -
	#
	# Create zip file.
	rm -f dist/xml2rfc-xxe-`cat xml2rfc/version.txt`.zip
	cd dist; zip -r xml2rfc-xxe-`cat xml2rfc/version.txt`.zip xml2rfc

clean:
	rm -rf dist
