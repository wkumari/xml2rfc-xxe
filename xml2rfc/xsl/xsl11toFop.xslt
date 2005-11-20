<!-- 
    Transform XSL 1.1 extensions to FOP extensions

    Copyright (c) 2004 Julian F. Reschke (julian.reschke@greenbytes.de)

    placed into the public domain

    change history:

    2004-05-17  julian.reschke@greenbytes.de

    Initial release.
-->

<xsl:transform xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
               xmlns:fo="http://www.w3.org/1999/XSL/Format"
               xmlns:fox="http://xml.apache.org/fop/extensions"
               version="1.0"
>

<!-- transform bookmark elements -->

<xsl:template match="fo:bookmark-tree" >
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="fo:bookmark" >
  <fox:outline internal-destination="{@internal-destination}">
    <xsl:apply-templates/>
  </fox:outline>
</xsl:template>

<xsl:template match="fo:bookmark-title" >
  <fox:label>
    <xsl:apply-templates/>
  </fox:label>
</xsl:template>


<!-- work around for missing page break stuff -->

<xsl:template match="fo:block[@page-break-before='always']">
  <xsl:copy>
    <xsl:attribute name="break-before">page</xsl:attribute>
    <xsl:attribute name="keep-with-previous">auto</xsl:attribute>
    <xsl:apply-templates select="@*[not(name()='page-break-before') and not(name()='id')]" />
    <xsl:apply-templates select="@id" />
    <xsl:apply-templates select="node()" />
  </xsl:copy>
</xsl:template>


<!-- add destination elements where IDs are defined -->
<xsl:template match="@id">
  <xsl:copy-of select="."/>
  <fox:destination internal-destination="{.}"/>
</xsl:template>

<xsl:template match="fo:list-item/@id">
  <!-- dunno how to in list items, so move into list-item-body -->
</xsl:template>

<xsl:template match="fo:list-item[@id]/fo:list-item-body">
  <xsl:copy>
    <xsl:attribute name="id"><xsl:value-of select="../@id"/></xsl:attribute>
    <xsl:apply-templates select="@*|node()"/>
  </xsl:copy>
</xsl:template>

<!-- page index -->

<xsl:attribute-set name="internal-link">
  <xsl:attribute name="color">#000080</xsl:attribute>
</xsl:attribute-set>

<xsl:template match="fo:page-index">
  <xsl:variable name="items" select="fo:index-item"/>
  <xsl:variable name="entries" select="//*[@index-key=$items/@ref-index-key]"/>
  <xsl:for-each select="$entries">
    <fo:basic-link internal-destination="{@id}" xsl:use-attribute-sets="internal-link">
      <xsl:if test="contains(@index-key,',primary') and substring-after(@index-key,',primary')=''">
        <xsl:attribute name="font-weight">bold</xsl:attribute>
      </xsl:if>
      <fo:page-number-citation ref-id="{@id}"/>
    </fo:basic-link>
    <xsl:if test="position()!=last()"><xsl:text>, </xsl:text></xsl:if>
  </xsl:for-each>
</xsl:template>

<!-- suppress and map-->
<xsl:template match="@index-key" />
<xsl:template match="fo:end-index-range" />
<xsl:template match="fo:begin-index-range">
  <fo:wrapper id="{@id}"/>
</xsl:template>

<!-- remove third-party extensions -->

<xsl:template match="*[namespace-uri()!='http://www.w3.org/1999/XSL/Format' and namespace-uri()!='http://xml.apache.org/fop/extensions']" />
<xsl:template match="@*[namespace-uri()!='' and namespace-uri()!='http://www.w3.org/1999/XSL/Format' and namespace-uri()!='http://xml.apache.org/fop/extensions']" />



<xsl:template match="node()|@*">
  <xsl:copy>
    <xsl:apply-templates select="@*[not(name()='id')]" />
    <xsl:apply-templates select="@id" />
    <xsl:apply-templates select="node()" />
  </xsl:copy>
</xsl:template>

<xsl:template match="/">
	<xsl:copy><xsl:apply-templates select="node()" /></xsl:copy>
</xsl:template>

</xsl:transform>