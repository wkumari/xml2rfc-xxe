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
	tar --exclude .svn --exclude '*~' -cf - xml2rfc | tar -C dist -xvf -
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
	version=`cat xml2rfc/version.txt`; \
	googlecode_upload.py -p xml2rfc-xxe -s "xml2rfc-xxe $$version" dist/xml2rfc-xxe-$$version.zip; \
	googlecode_upload.py -p xml2rfc-xxe -s "xml2rfc-xxe $${version}-only addon" dist/xml2rfc-$$version.xxe-addon; \
	[ -n "$$addon" ] && googlecode_upload.py -p xml2rfc-xxe -s "xml2rfc-xxe addon" dist/xml2rfc.xxe-addon

	#rsync -a dist/*`cat xml2rfc/version.txt`* $$addon silk.research.att.com:external/wwwfiles/ietf/xml2rfc-xxe/
	#rsync -a help/html silk.research.att.com:external/wwwfiles/ietf/xml2rfc-xxe/xml2rfc_help/
# new copy todo:
# labels: Type-Addon for the addon
#         Type-Package for the zip file
# use googlecode_upload.py
# figure out help2wiki

getxsl:
	wget http://greenbytes.de/tech/webdav/rfc2629xslt.zip
