<?xml version="1.0"?>

<!--
 - Copyright (C) 2004  Internet Systems Consortium, Inc. ("ISC")
 - 
 - Permission to use, copy, modify, and distribute this software for any
 - purpose with or without fee is hereby granted, provided that the above
 - copyright notice and this permission notice appear in all copies.
 - 
 - THE SOFTWARE IS PROVIDED "AS IS" AND ISC DISCLAIMS ALL WARRANTIES WITH
 - REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY
 - AND FITNESS.  IN NO EVENT SHALL ISC BE LIABLE FOR ANY SPECIAL, DIRECT,
 - INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM
 - LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE
 - OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR
 - PERFORMANCE OF THIS SOFTWARE.
-->

<!-- $Id$
 -
 - Expand xml2rfc <?rfc include="foo"?> processing instructions.
 -
 - I wrote this for use with xsltproc, although presumably one could
 - use it with another xslt engine without much effort.  When using it
 - with xsltproc, xsltproc's "path" command-line option provides an
 - easy way to provide the same functionality as xml2rfc's XML_LIBRARY
 - environment variable (one can in fact just use the value of
 - XML_LIBRARY as the argument to the path option and the right thing
 - should happen).
 -
 - Input for this stylesheet is an RFC 2629 XML document; output is
 - the same document, still in XML, but with <?rfc include="foo"?> PIs
 - expanded.
-->

<!--
 - Adapted for use with xxe by Bill Fenner, 2004-12-22
-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

  <xsl:template match="processing-instruction('rfc')">
    <xsl:choose>
      <xsl:when test="contains(.,'include=')">
	<xsl:variable name="elide">&#9;&#10;&#13;&#32;&#34;&#39;</xsl:variable>
	<xsl:variable name="href"><xsl:value-of select="
	  translate(substring-after(.,'='), $elide, '')"/><xsl:if test="
          not(contains(.,'.xml'))">.xml</xsl:if>
	</xsl:variable>
        <xsl:comment> Begin inclusion <xsl:value-of select="$href"/>. </xsl:comment>
        <!-- XXX first try applying templates to document($href,.)
          - to handle multiple levels of include, except we don't have
          - the original directory so we're looking in the transform
          - directory, which won't have the other xml files.  I don't
          - think this fits into xxe's idea of a transform, since
          - it wants you to copy the necessary files into the temp
          - dir.  So, for now, assume that the only things being
          - included are references and are in xml2rfc-bibxml:
          - or in xml2rfc-bibxml3:. -->
        <xsl:variable name="bibxml"
                      select="document(concat('xml2rfc-bibxml:',$href))"/>
	<xsl:choose>
	  <xsl:when test="$bibxml">
	    <xsl:copy-of select="$bibxml"/>
	  </xsl:when>
	  <xsl:otherwise>
	    <!-- could cascade conditional -->
	    <xsl:copy-of select="document(concat('xml2rfc-bibxml3:',$href))"/>
	  </xsl:otherwise>
	</xsl:choose>
        <xsl:comment> End inclusion <xsl:value-of select="$href"/>. </xsl:comment>
      </xsl:when>
      <xsl:otherwise>
        <xsl:copy/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:copy-of select="@*"/>
      <xsl:apply-templates/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="/">
    <xsl:apply-templates/>
  </xsl:template>

</xsl:stylesheet>
