<!-- Convert the limited subset of docbook that I use in the xml2rfc-xxe
  -  help system to google-code's wiki format.
  -->
<xsl:transform xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	       xmlns:exsl="http://exslt.org/common"
	       extension-element-prefixes="exsl"
               version="1.0">
    <xsl:output method="text" omit-xml-declaration="yes" />

    <!-- The prefix for the output files, including directory separator. -->
    <xsl:param name="dir" select="'wiki/Help__'"/>

    <!-- For debugging, mostly. -->
    <xsl:param name="verbose" select="1"/>

    <!-- TODO:
	 Make a SideBar.wiki that has the help ToC, set it as the sidebar
	 inside the help.
	 Make a Help.wiki that is the top-level help page.
	 -->
    <xsl:template match="article/section">
	<xsl:variable name="filename">
	    <xsl:value-of select="$dir"/>
	    <xsl:value-of select="translate( title, ' -,.', '__' )"/>
	    <xsl:text>.wiki</xsl:text>
	</xsl:variable>
	<xsl:if test="$verbose">
	  <xsl:message>
	    <xsl:text>Writing </xsl:text>
	    <xsl:value-of select="$filename"/>
	  </xsl:message>
	</xsl:if>
	<exsl:document href="{$filename}" method="text" omit-xml-declaration="yes" encoding="US-ASCII">#summary <xsl:value-of select="title"/>
#labels Help

<xsl:apply-templates/>
	</exsl:document>
    </xsl:template>

    <!-- First: strip out all whitespace on matching text. -->
    <xsl:template match="text()"><xsl:value-of select="normalize-space(.)"/></xsl:template>

    <!-- TODO: count the number of parent sections and vary the ='s -->
    <xsl:template match="section/title">= <xsl:value-of select="normalize-space(.)"/> =
</xsl:template>

    <!-- Paragraphs get surrounded by blank lines. -->
    <xsl:template match="para"><xsl:text>
</xsl:text><xsl:apply-templates/><xsl:text>
</xsl:text></xsl:template>

    <!-- TODO: Figure out how to put the right whitespace around these -->
    <xsl:template match="guimenuitem"> `<xsl:value-of select="normalize-space(.)"/>` </xsl:template>
    <xsl:template match="guisubmenu"> `<xsl:value-of select="normalize-space(.)"/>` </xsl:template>
    <xsl:template match="emphasis[@role='bold']"> *<xsl:value-of select="normalize-space(.)"/>* </xsl:template>
    <xsl:template match="emphasis"> _<xsl:value-of select="normalize-space(.)"/>_ </xsl:template>
    <xsl:template match="literal"> `<xsl:value-of select="normalize-space(.)"/>` </xsl:template>

    <!-- itemized list -->
    <xsl:template match="itemizedlist/listitem/para"><xsl:text>
  * </xsl:text><xsl:apply-templates/><xsl:text>
</xsl:text></xsl:template>

    <!-- variable list -->
    <xsl:template match="varlistentry/term"><xsl:text>
  * </xsl:text><xsl:apply-templates/></xsl:template>
    <xsl:template match="varlistentry/listitem/para"><xsl:text>
    * </xsl:text><xsl:apply-templates/><xsl:text>
</xsl:text></xsl:template>

    <xsl:template match="ulink"> [<xsl:value-of select="@url"/><xsl:text> </xsl:text><xsl:value-of select="normalize-space(.)"/>] </xsl:template>
    <xsl:template match="literallayout">
{{{
<xsl:value-of select="."/>}}}
</xsl:template>

    <!-- rough attempt at tables -->
    <xsl:template match="informaltable"><xsl:text>
</xsl:text><xsl:apply-templates/><xsl:text>
</xsl:text></xsl:template>
    <xsl:template match="row">
||<xsl:apply-templates/></xsl:template>
    <xsl:template match="row/entry"><xsl:text> </xsl:text><xsl:value-of select="normalize-space(.)"/> ||</xsl:template>

</xsl:transform>
