xml2rfc_help.jar:	xml2rfc_help_vers.xml icons
	rm -rf xml2rfc_help
	mkdir xml2rfc_help
	cp -pr icons xml2rfc_help/
	rm -rf xml2rfc_help/icons/.svn	# hokey
	cd xml2rfc_help; xsltproc /opt/local/share/xsl/docbook-xsl/javahelp/javahelp.xsl ../xml2rfc_help_vers.xml; jhindexer *.html
	jar -cvf xml2rfc_help.jar xml2rfc_help
	rm -f xml2rfc_help_vers.xml

html:	xml2rfc_help_vers.xml icons
	rm -rf html
	mkdir html
	cp -pr icons html/
	rm -rf html/icons/.svn	# hokey
	cd html; xsltproc /opt/local/share/xsl/docbook-xsl/html/chunk.xsl ../xml2rfc_help_vers.xml
	rm -f xml2rfc_help_vers.xml

wiki:	xml2rfc_help_vers.xml
	-mkdir wiki
	xsltproc db2wiki.xsl xml2rfc_help_vers.xml

copy:
	rsync -var html/ rtg.ietf.org:public_html/ietf/xml2rfc-xxe/xml2rfc_help/

icons:
	ln -s ../xml2rfc/icons .

clean:
	rm -rf xml2rfc_help.jar xml2rfc_help
	rm -rf wiki

xml2rfc_help_vers.xml:	xml2rfc_help.xml
	sed -e "s/%%VERSION%%/`cat ../xml2rfc/version.txt`/" xml2rfc_help.xml > xml2rfc_help_vers.xml
