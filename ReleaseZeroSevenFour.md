# xml2rfc-xxe 0.7.4 release notes #

Released 2008-07-26.

# Installation #

Please see [Installation](Installation.md).

# Changes #

  * Update for xxe 4.0.0
  * Update DTD and Entities to those supported in xml2rfc 1.33
  * Display the inherited or implicit list style; display the list style in red and use a hanging text of "-?-" if it's using the xml2rfc inherited style, which this style sheet doesn't currently support. (This behavior, however, is probably an advancement from displaying it as empty.)
  * Supports &rfc.number; and &rfc2629.processor; entities
  * More support for images: teach xxe that images need to get saved with the document, and support figure src=
  * Fix the Insert <?rfc include=''> menu item
  * Switch to Java code to run a locally-installed xml2rfc. This allows us to control the executable and the environment, so Windows users can point to their xml2rfc installation.
  * Support the "unpg" output type for conversions
  * Add combo-box to select list style
  * Make reference section titles directly editable
  * Improved texttable rendering by setting the column properly
  * Updated Julian's xslt