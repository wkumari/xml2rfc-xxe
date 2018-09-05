xml2rfc-xxe
============

### A configuration to assist editing xml2rfc-format documents using XMLMind XML Editor.

XMLMind has kindly brought back their Personal edition. The license file is [here](http://www.xmlmind.com/xmleditor/license_xxe_perso.html). Pleare review it and confirm that it meets your usage.

The XMLMind XML Editor downloads are here: [http://www.xmlmind.com/xmleditor/download.shtml](http://www.xmlmind.com/xmleditor/download.shtml)

#### Super-brief installation instructions:
* Install XMLmind! (8.0 was released Mar 5, 2018, previous verions are available http://www.xmlmind.com/archive/xmleditor/ )
* Go to *Options* -> *Preferences...*, then *Install Add-ons*. (**NOTE**: *Options* -> **Preferences...** -> *Install Add-ons*. This trips many people up! )
* Find the link for the version of XMLmind you have installed in the table below, click "Add", copy and paste the link into the "Download add-ons from these servers:" box. 
* Click "OK".
* Click *Options* -> *Install Add-ons...* (**NOTE**: This is **NOT** *Options* -> *Preferences...* -> *Install Add-ons*!)
* Look for the "XML2RFC plug-in" (it is a "Configuration"), select it and click OK. If it isn't listed, check under the "Uninstall" tab (it may already be installed) and make sure you have the link for the correct version.
* Restart XML Editor.
* Now open a (valid!) Internet Draft. 


###### Plugin Version

| XMLMind Version | XML2RFC Addon |
| --------------- | ------------- |
| 8.x             | [xml2rfc-0.8.4](https://raw.githubusercontent.com/wkumari/xml2rfc-xxe/master/downloads/xml2rfc-0.8.4.xxe_addon) |
| 7.x             | [xml2rfc-0.8.3](https://raw.githubusercontent.com/wkumari/xml2rfc-xxe/master/downloads/xml2rfc-0.8.3.xxe_addon) |
| 6.x             | [xml2rfc-0.8.2](https://raw.githubusercontent.com/wkumari/xml2rfc-xxe/master/downloads/xml2rfc-0.8.2.xxe_addon) |
| 5.x             | [xml2rfc-0.8.0](https://raw.githubusercontent.com/wkumari/xml2rfc-xxe/master/downloads/xml2rfc-0.8.0.xxe_addon) |
| 4.x             | [xml2rfc-0.7.9](https://raw.githubusercontent.com/wkumari/xml2rfc-xxe/master/downloads/xml2rfc-0.7.9.xxe_addon) |



Make sure you download and install XMLMind XML Editor first.
This configuration works with both Personal and Professional editions.
Some features (e.g., format using XSLT) only work with Professional edition.

This is a WYSIKN (What You See Is Kinda Neat) addon for the very configurable XMLMind XML Editor (“xxe”).
The personal version of xxe is free and very capable. It's also written in java, so one addon works on many 
platforms (I've tested it on MacOS, Windows 2000 and FreeBSD).

The addon is capable of graphical editing of sections, anchors, lists, cross-references, etc.
and allows word processor-like behavior of "enter" to create a new paragraph or list item.
It can use a locally-installed xml2rfc to format the document for preview or conversion, 
or use xxe's built-in XSL transform or submit the document to the xml.resource.org web form. 
It provides easy hooks to validate the references to other IETF documents in your document to make sure they're up to date.


Note: This project was migrated from Google Code (https://code.google.com/archive/p/xml2rfc-xxe/) -- we have not really maintainted it after this.
Prerequisites:

- For building java help:
  xsltproc (and libxml2)
  docbook-xsl style sheets
  javahelp-2.0 (possibly earlier)

- As there is no Makefile for the xml2rfc.jar file I simply copied if from
  a previous version. -- Warren Kumari
