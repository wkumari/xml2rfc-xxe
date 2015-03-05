# Overview #

This xxe plugin attempts to support most of the rfc2629bis DTD, as of xml2rfc release 1.34, October, 2009. This documentation is for plugin version 0.7.8. The plugin requires at least xxe 4.0 (released July 21, 2008) and has been tested with xxe 4.5 (released September 24, 2009).

This plugin can create text or HTML output using xml2rfc, if installed; it can also use xmlmind's native XSL support to generate HTML (As of 3.5.1, this feature is limited to the Professional Edition). It can also convert to txt, HTML, nroff or canonical XML using the xml.resource.org web form. Use the menu items ` Convert to HTML using XSL ` , ` HTML Preview using XSL ` , ` Text Preview using xml.resource.org ` , and the ` ...using xml.resource.org ` Convert submenu if you don't have xml2rfc installed.

The following items are not yet (and may never be) completely supported:

  * texttable. This requires some extra help (probably a custom java widget) to style the table for xmlmind. However, starting in 0.7.3, the addon labels rows and columns with their numbers, and puts entries in the right columns.

  * <?rfc ?> processing instructions in the document, <?rfc include= in particular. (Wish: to be able to handle this like external entity references) (Partial <?rfc include= support is described in). The <?rfc ?> processing instructions before the root element are supported by a custom editor.

Planned features:

  * Make toolbar helpers more useful

  * Increase/decrease list item level (tab?)

  * Fix section manager, including a version of >> which attaches to previous-sibling's last section descendant

  * Improve <list counter> support

  * <?rfc ?> PI editor inside the document