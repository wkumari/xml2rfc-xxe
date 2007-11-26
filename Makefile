release:
	mkdir -p dist
	rm -rf dist/xml2rfc
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
	# Create xxe addon file and symlink, and copy it into the zip file
	sed -e "s/%%VERSION%%/`cat xml2rfc/version.txt`/" xml2rfc/xml2rfc.xxe_addon > dist/xml2rfc-`cat xml2rfc/version.txt`.xxe_addon
	rm -f dist/xml2rfc.xxe_addon
	ln -s xml2rfc-`cat xml2rfc/version.txt`.xxe_addon dist/xml2rfc.xxe_addon
	cp dist/xml2rfc-`cat xml2rfc/version.txt`.xxe_addon dist/xml2rfc/xml2rfc.xxe_addon
	#
	# Create zip file.
	rm -f dist/xml2rfc-xxe-`cat xml2rfc/version.txt`.zip
	cd dist; zip -r xml2rfc-xxe-`cat xml2rfc/version.txt`.zip xml2rfc

clean:
	rm -rf dist

copy:
	@addon=""; \
	grep beta xml2rfc/version.txt >/dev/null || addon="dist/xml2rfc.xxe_addon"; \
	rsync -a dist/*`cat xml2rfc/version.txt`* $$addon silk.research.att.com:external/wwwfiles/ietf/xml2rfc-xxe/
	rsync -a help/html silk.research.att.com:external/wwwfiles/ietf/xml2rfc-xxe/xml2rfc_help/

getxsl:
	wget http://greenbytes.de/tech/webdav/rfc2629xslt.zip
