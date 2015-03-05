# Including External References #

There are two commonly-used methods of importing references from the reference database maintained at xml.resource.org:

  * **Entity definitions and references.** This is the form shown under "Including files" on the xml.resource.org web page. Definitions are of the form
```
<DOCTYPE rfc SYSTEM 'rfc2629.dtd' [
 <!ENTITY rfc2629 PUBLIC '' 'http://xml.resource.org/public/rfc/bibxml/reference.RFC.2629.xml'>
]>
```
> ` xxe ` understands these references when loading the file, and also loads the referenced file read-only; this makes the document validate and allows the cross-reference macros to notice it. When xxe saves the document, it turns the entity definition into the equivalent:
```
<DOCTYPE rfc SYSTEM 'rfc2629.dtd' [
 <!ENTITY rfc2629 SYSTEM 'http://xml.resource.org/public/rfc/bibxml/reference.RFC.2629.xml'>
]>
```
When ` xml2rfc ` prior to version 1.29 reads this, it looks for a relative reference - it only handles fully-qualified URLs in PUBLIC entity definitions, so it cannot format a file that has been edited this way.

  * In addition, this creates a dependency on the http reference, so offline editing is not possible. ` xxe ` will not load a file with these kinds of entity references if the referenced file is not available.

  * **<?rfc include="..."?> processing instructions.** These are described in the README for ` xml2rfc ` . They only require a single processing instruction inserted where the reference belongs, e.g.:
```
<?rfc include="reference.RFC.2629.xml"?>
```
However, this does not cause ` xxe ` to load the reference, so it may think that the document is not well-formed (e.g., a 

&lt;references&gt;

 section with no 

&lt;reference&gt;

 elements since they're all included). xxe will also refuse to allow you to delete an element that makes the document not-well-formed, so you may end up with a placehodler 

&lt;reference&gt;

 inside a references section that you have to delete by editing the .xml file elsewhere. The 

&lt;xref&gt;

-checking code does check for the standard naming convention, so an xref to "RFC2629" will show as "included" given the above processing instruction.

  * To insert a processing instruction, use F6 or select the ` Insert <?rfc include=''?> ` menu item in theXML2RFCmenu. This will insert an <?rfc include=''?> processing instruction inside or after the currently-selected element.

  * The XSL transforms will process <?rfc include=''?> instructions. They default to using the xml.resource.org site; if you have a local mirror you can configure it as follows:

Create a file "my\_xml2rfc\_catalog.xml" in your XXE configuration directory (the same place you unzipped the xml2rfc plugin, in the addon/ directory)

Add the following two lines:


```
  <rewriteURI uriStartString="xml2rfc-bibxml:"
              rewritePrefix="(URL to your RFC bibxml mirror)" />
  <rewriteURI uriStartString="xml2rfc-bibxml3:"
              rewritePrefix="(URL to your I-D bibxml mirror)" />

```


  * Future work will hopefully teach xxe about this style of inclusion so that it can include the actual referenced file read-only. (xxe knows how to do this with entities and xi:include)