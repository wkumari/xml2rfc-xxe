<!-- 
    Transform XSL 1.1 extensions to RenderX extensions

    Copyright (c) 2004 Julian F. Reschke (julian.reschke@greenbytes.de)

    placed into the public domain

    change history:

    2004-05-17  julian.reschke@greenbytes.de

    Initial release.

    2004-09-04  julian.reschke@greenbytes.de

    Fix xep:index-item attributes.
-->

<xsl:transform xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
               xmlns:fo="http://www.w3.org/1999/XSL/Format"
               xmlns:xep="http://www.renderx.com/XSL/Extensions"
               version="1.0"
>

<!-- transform bookmark elements -->

<xsl:template match="fo:bookmark-tree">
  <xep:outline>
    <xsl:apply-templates/>
  </xep:outline>
</xsl:template>

<xsl:template match="fo:bookmark" >
  <xep:bookmark internal-destination="{@internal-destination}">
    <xsl:apply-templates/>
  </xep:bookmark>
</xsl:template>

<xsl:template match="fo:bookmark-title" >
  <xep:bookmark-label>
    <xsl:apply-templates/>
  </xep:bookmark-label>
</xsl:template>

<!-- page index -->

<xsl:template match="@index-key">
  <xsl:attribute name="xep:key">
    <xsl:value-of select="."/>
  </xsl:attribute>
</xsl:template>

<xsl:template match="fo:page-index">
  <xep:page-index>
    <xsl:apply-templates/>
  </xep:page-index>
</xsl:template>

<xsl:template match="fo:index-item">
  <xep:index-item ref-key="{@ref-index-key}" merge-subsequent-page-numbers="true" link-back="true">
    <xsl:apply-templates select="@*[name()!='ref-index-key' and name()!='create-index-link' and name()!='merge-sequential-index-page-numbers']"/>
    <xsl:apply-templates select="*"/>
  </xep:index-item>
</xsl:template>

<xsl:template match="fo:begin-index-range">
  <xep:begin-index-range id="{@id}" xep:key="{@index-key}" />
</xsl:template>

<xsl:template match="fo:end-index-range">
  <xep:end-index-range ref-id="{@ref-id}" />
</xsl:template>

<!-- remove third-party extensions -->

<xsl:template match="*[namespace-uri()!='http://www.w3.org/1999/XSL/Format' and namespace-uri()!='http://www.renderx.com/XSL/Extensions']" />
<xsl:template match="@*[namespace-uri()!='' and namespace-uri()!='http://www.w3.org/1999/XSL/Format' and namespace-uri()!='http://www.renderx.com/XSL/Extensions']" />

<!-- rules for identity transformations -->

<xsl:template match="node()|@*"><xsl:copy><xsl:apply-templates select="node()|@*" /></xsl:copy></xsl:template>

<xsl:template match="/">
	<xsl:copy><xsl:apply-templates select="node()" /></xsl:copy>
</xsl:template>

</xsl:transform>