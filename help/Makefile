xml2rfc_help.jar:	xml2rfc_help_vers.xml icons
	rm -rf xml2rfc_help
	mkdir xml2rfc_help
	cp -pr icons xml2rfc_help/
	cd xml2rfc_help; xsltproc /opt/local/share/xsl/docbook-xsl/javahelp/javahelp.xsl ../xml2rfc_help_vers.xml; jhindexer *.html
	jar -cvf xml2rfc_help.jar xml2rfc_help
	rm -f xml2rfc_help_vers.xml

icons:
	ln -s ../xml2rfc/icons .

clean:
	rm -rf xml2rfc_help.jar xml2rfc_help

xml2rfc_help_vers.xml:	xml2rfc_help.xml
	sed -e "s/%%VERSION%%/`cat ../xml2rfc/version.txt`/" xml2rfc_help.xml > xml2rfc_help_vers.xml
