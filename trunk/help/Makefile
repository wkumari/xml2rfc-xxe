xml2rfc_help.jar:	xml2rfc_help_vers.xml
	rm -rf xml2rfc_help
	mkdir xml2rfc_help
	cd xml2rfc_help; xsltproc --xinclude /opt/local/share/xsl/docbook-xsl/javahelp/javahelp.xsl ../xml2rfc_help_vers.xml
	jar -cvf xml2rfc_help.jar xml2rfc_help
	rm -f xml2rfc_help_vers.xml

xml2rfc_help_vers.xml:	xml2rfc_help.xml
	sed -e "s/%%VERSION%%/`cat ../xml2rfc/version.txt`/" xml2rfc_help.xml > xml2rfc_help_vers.xml
