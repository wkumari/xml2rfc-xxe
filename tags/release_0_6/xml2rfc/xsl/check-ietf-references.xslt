<!--
    Check IERFC RFC references (requires local copy of "rfc-index.xml",
    available from <ftp://ftp.isi.edu/in-notes/rfc-index.xml>)

    Copyright (c) 2003 Julian F. Reschke (julian.reschke@greenbytes.de)

    placed into the public domain

    change history:

    2003-11-16  julian.reschke@greenbytes.de

    Initial release.

    2004-05-11  julian.reschke@greenbytes.de

    Add document status; print references type.
    
    2005-01-01  julian.reschke@greenbytes.de

    Add experimental check for ID status.

    2005-03-31  fenner@research.att.com

    Allowed ID status check to follow renaming or newer versions.
    Check for down-references from standards-track documents'
    normative references section.

-->

<xsl:transform xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0"
                xmlns:ed="http://greenbytes.de/2002/rfcedit"
                xmlns:rfced="http://www.rfc-editor.org/rfc-index"
>

<xsl:output method="text" encoding="UTF-8"/>

<xsl:template match="/">
  <xsl:for-each select="//references">
    <xsl:variable name="title">
      <xsl:choose>
	<xsl:when test="@title">
	  <xsl:value-of select="@title"/>
	</xsl:when>
	<xsl:otherwise>
	  <xsl:text>References:</xsl:text>
	</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:value-of select="$title"/><xsl:text>&#10;</xsl:text>
    <xsl:for-each select=".//reference[seriesInfo/@name='RFC' and not(ancestor::ed:del)]">
      <xsl:variable name="no" select="seriesInfo[@name='RFC']/@value" />
      <xsl:variable name="id" select="concat('RFC',substring('000',string-length($no)),$no)" />
      <xsl:value-of select="$id" />
      <xsl:text>: </xsl:text>
      <xsl:variable name="stat" select="document('xml2rfc-rfcindex:rfc-index.xml')/*/rfced:rfc-entry[rfced:doc-id=$id]" />
      <xsl:if test="$stat/rfced:current-status">
        <xsl:text>[</xsl:text><xsl:value-of select="$stat/rfced:current-status"/><xsl:text>] </xsl:text>
      </xsl:if> 
      <xsl:if test="$stat/rfced:is-also">
        <xsl:text>(-> </xsl:text><xsl:value-of select="$stat/rfced:is-also/rfced:doc-id"/><xsl:text>) </xsl:text>
      </xsl:if> 
      <xsl:choose>
        <xsl:when test="$stat/rfced:obsoleted-by">
          <xsl:text>obsoleted by </xsl:text>
          <xsl:for-each select="$stat/rfced:obsoleted-by/rfced:doc-id">
            <xsl:value-of select="."/>
            <xsl:text> </xsl:text>
          </xsl:for-each>
        </xsl:when>
	<xsl:when test="(/rfc/@category = 'std' or /rfc/@category = 'bcp') and starts-with($title,'Normative') and ($stat/rfced:current-status != 'BEST CURRENT PRACTICE') and not(contains($stat/rfced:current-status, 'STANDARD'))">
	  <xsl:text>*DOWNREF*</xsl:text>
	</xsl:when>
	<xsl:when test="$stat">ok</xsl:when>
        <xsl:otherwise>can't find in rfc-index!</xsl:otherwise>
      </xsl:choose>
      <xsl:text>&#10;</xsl:text>    
    </xsl:for-each>
    
    <!-- check ID status -->
    <xsl:for-each select=".//reference[(seriesInfo/@name='ID' or seriesInfo/@name='Internet-Draft') and starts-with(seriesInfo/@value,'draft-') and not(ancestor::ed:del)]">
      <xsl:variable name="name" select="seriesInfo[(@name='ID' or @name='Internet-Draft') and starts-with(@value,'draft-')]/@value" />
      <xsl:value-of select="$name" />
      <xsl:text>: </xsl:text>
      <xsl:call-template name="idstatus">
	<xsl:with-param name="name" select="$name"/>
      </xsl:call-template>
      <xsl:text>&#10;</xsl:text>        
    </xsl:for-each>
  </xsl:for-each>
</xsl:template>

<xsl:template name="idstatus">
  <xsl:param name="name"/>
      <xsl:variable name="stat" select="document('xml2rfc-ietfidstatus:ietf-id-status.xml')/*/id[@name=$name]" />
      <xsl:choose>
        <xsl:when test="$stat[@status='active' or @status='IESG']">
          <xsl:value-of select="concat('[',$stat/@date,' ',$stat/@status,'] ok')"/>
        </xsl:when>
        <xsl:when test="$stat[@status='RFC']">
          <xsl:value-of select="concat('[',$stat/@date,' ',$stat/@status,'] (-> RFC',$stat/@num,')')"/>
        </xsl:when>
        <xsl:when test="$stat[@status='expired']">
          <xsl:value-of select="concat('[',$stat/@date,' ',$stat/@status,'] expired!')"/>
        </xsl:when>
        <xsl:when test="$stat[@status='replaced']">
          <xsl:value-of select="concat('[',$stat/@date,' ',$stat/@status,'] replaced by ',$stat/@by,' -> ')"/>
	  <xsl:call-template name="idstatus">
	    <xsl:with-param name="name" select="concat($stat/@by,'-xx')"/>
	  </xsl:call-template>
        </xsl:when>
        <xsl:when test="$stat">
          <xsl:value-of select="concat('[',$stat/@date,' ',$stat/@status,'] UNKNOWN STATUS!')"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:variable name="base" select="substring($name,1,string-length($name)-3)"/>
          <xsl:variable name="stat2" select="document('xml2rfc-ietfidstatus:ietf-id-status.xml')/*/id[starts-with(@name,$base)]" />
          <xsl:choose>
            <xsl:when test="$stat2">
              <xsl:text>Latest version available: </xsl:text><xsl:value-of select="$stat2/@name"/><xsl:text> -&gt; </xsl:text>
	      <xsl:call-template name="idstatus">
		<xsl:with-param name="name" select="$stat2/@name"/>
	      </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
              <xsl:text>ID does not exist</xsl:text>
            </xsl:otherwise>
          </xsl:choose>     
        </xsl:otherwise>
      </xsl:choose>
</xsl:template>

</xsl:transform>
