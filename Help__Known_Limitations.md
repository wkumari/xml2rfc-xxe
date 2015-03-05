# Known Limitations #

  * Pasting from the ASCII art editor JavE (at least on MacOS) produces a garbled figure. This is fixed in xxe 2.9.

  * xml2rfc version 1.28 and earlier cannot load <ENTITY SYSTEM "http://..."> definitions; xxe will change the <ENTITY PUBLIC "" "http://..."> format that xml2rfc understands to the SYSTEM one. This is fixed in xml2rfc version 1.29.